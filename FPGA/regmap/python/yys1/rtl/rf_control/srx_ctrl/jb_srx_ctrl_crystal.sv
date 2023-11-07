// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 4/25/19                                                     //
// Module       : srx_ctrl                                                    //
// Description  :                                                             //
//    Logan shares the observation path between DPD and VSWR. Xilinx DPD is   //
//    the master and will always have highest priority to the observation     //
//    path. PL configures the observation path in accordance with the DPD     //
//    request and then acknowledges back to DPD when ready.                   //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
//     08/14/19 : 0.02 - Updated HMC switch port assignments per Lintao's req //
// ========================================================================== //

`timescale 1ns / 1ps

module jb_srx_ctrl #(
    parameter N_ANTENNAS = 4
) (
    input                               axis_aclk,
    input                               axis_aresetn,
    jb_hw_ctrl_if.rf_ctrl               IFP_ctrl,
    jb_dpd_srx_if.srx_ctrl              IFP_dpd,
    jb_axi4_stream_if.slave             IFP_srx [N_ANTENNAS-1:0],
    output  logic   [2:0]               srx_wrssi_ant,

    output  logic                       pa14_swen   = 1,    // off (active low on board)
    output  logic                       pa14_swen_n = 1,    // off (active low on board)
    output  logic   [3:1]               pa14_sw,
    output  logic                       pa14_sw1_n
);

    localparam      REQUEST_TYPE_DPD        = 4'h0,
                    REQUEST_TYPE_HIRES      = 4'h1,
                    REQUEST_TYPE_VSWR       = 4'h2,
                    REQUEST_TYPE_AVAIL      = 4'hF;

    localparam      S_WAIT_FOR_REQUEST      = 2'd0,
                    S_SWITCH_ANTENNA        = 2'd1,
                    S_WAIT_FOR_ANTENNA      = 2'd2,
                    S_GRANT_REQUEST         = 2'd3;

    localparam      SRX_CNTR_MAX            = 16'hC8; // 200 cycles (368.64MHz) = 542 ns

    localparam      PATH_TYPE_DPD           = 0,
                    PATH_TYPE_VSWR          = 1;

    logic [2:0]     dpd_req_ant             = 0;
    logic [3:0]     dpd_req_type            = REQUEST_TYPE_DPD;
    logic           dpd_req_valid;
    logic           dpd_req_granted;
    logic [2:0]     dpd_sel_ant             = 0;
    logic           dpd_sel_type            = PATH_TYPE_DPD;
    logic           dpd_tready_valid        = 0;

    logic [1:0]     srx_state               = S_WAIT_FOR_REQUEST;
    logic [1:0]     srx_state_next          = S_WAIT_FOR_REQUEST;
    logic [15:0]    srx_cntr                = 0;

    logic           swa_en_n;
    logic           swa;
    logic           swb_en_n; 
    logic           swb; 
    logic           swc_en_n;
    logic           swc;

    logic [2:0]     srx_tuser_antenna       = 0;

    logic [2:0]     curr_ant;
    logic           curr_path;

    // ------------------------------------------------------------------ //
    // SRX Control State Machine                                          //
    // ------------------------------------------------------------------ //
    // Status back to the DPD core: 
    //      The DPD core needs to know when the antenna switch has completed.
    //      There are two possible methods:
    //          1. Programmable software delay
    //          2. Append antenna info to s_axis_srx_tuser
    //      We use option 2 with a fixed delay
    
    always_ff @(posedge axis_aclk) begin
        srx_state <= srx_state_next;
    end
    
    always_comb begin
        case (srx_state)
            S_WAIT_FOR_REQUEST  : srx_state_next = (IFP_dpd.srx_ctrl_tvalid & IFP_dpd.srx_ctrl_tready) ? S_SWITCH_ANTENNA : S_WAIT_FOR_REQUEST;
            S_SWITCH_ANTENNA    : srx_state_next = S_WAIT_FOR_ANTENNA; 
          //S_WAIT_FOR_ANTENNA  : srx_state_next = (srx_cntr == SRX_CNTR_MAX) ? S_GRANT_REQUEST : S_WAIT_FOR_ANTENNA;
            S_WAIT_FOR_ANTENNA  : srx_state_next = (srx_cntr == IFP_ctrl.ant_switch_delay) ? S_GRANT_REQUEST : S_WAIT_FOR_ANTENNA;
            S_GRANT_REQUEST     : srx_state_next = S_WAIT_FOR_REQUEST;
            default             : srx_state_next = S_WAIT_FOR_REQUEST;
        endcase
    end

    // Counter for SRX path switching/transient delay
    always_ff @(posedge axis_aclk) begin
        if (srx_state != S_WAIT_FOR_ANTENNA)
            srx_cntr <= 0;
        else
            srx_cntr++;
    end

    // ------------------------------------------------------------------ //
    // DPD SRX Control Stream (DPD/m_axis_srx_ctrl)                       //
    // ------------------------------------------------------------------ //
    // We use Direct hardware control (SRX control stream) for our multi-
    // antenna system. DPD makes requests and selects data from among the
    // different antennas. Request Types are:
    // 0=Normal, 1=HI-Res ADC, 2=VSWR, 0xF=SRX available

    // Always ready to accept an antenna change request
    assign IFP_dpd.srx_ctrl_tready = 1;

    // Latch DPD request because it's only active when tvalid is high
    always_ff @(posedge axis_aclk) begin
        if (IFP_dpd.srx_ctrl_tvalid) begin
            dpd_req_type <= IFP_dpd.srx_ctrl_tdata[7:4];
            dpd_req_ant  <= IFP_dpd.srx_ctrl_tdata[2:0];
        end
    end

    // ------------------------------------------------------------------ //
    // Antenna Switching control                                          //
    // ------------------------------------------------------------------ //
    assign dpd_req_valid    = (srx_state == S_SWITCH_ANTENNA) & ((dpd_req_type == REQUEST_TYPE_DPD) | (dpd_req_type == REQUEST_TYPE_VSWR));

    // Latch antenna and type so when override is enabled and then disabled,
    // you go back to the latched antenna and type.
    always_ff @(posedge axis_aclk) begin
        if (dpd_req_valid) begin
            dpd_sel_ant     <= dpd_req_ant;
            dpd_sel_type    <= (dpd_req_type == REQUEST_TYPE_DPD) ? PATH_TYPE_DPD : PATH_TYPE_VSWR;
        end
    end

    assign curr_ant      = IFP_ctrl.rf_switch_override ? IFP_ctrl.orx_ant_sel    : dpd_sel_ant;
    assign curr_path     = IFP_ctrl.rf_switch_override ? IFP_ctrl.orx_path_sel   : dpd_sel_type;

    // PA board RF switches for observation paths
    jb_rfsw_map jb_rfsw_map_u0 (
        .ant_sel            (curr_ant),             // i [2:0]
        .path_sel           (curr_path),            // i
        .swa_en_n           (swa_en_n),             // o
        .swa                (swa),                  // o
        .swb_en_n           (swb_en_n),             // o
        .swb                (swb),                  // o
        .swc_en_n           (swc_en_n),             // o
        .swc                (swc)                   // o
    );

    always_ff @(posedge axis_aclk) begin
        pa14_sw[1]      <= swa;
        pa14_sw[2]      <= swb;
        pa14_sw[3]      <= swc;

        pa14_sw1_n      <= ~swa;
        pa14_swen       <= swb_en_n;
        pa14_swen_n     <= swc_en_n;
    end
    
    // ------------------------------------------------------------------ //
    // DPD Sample Receiver (SRX) AXI4-Stream Interface                    //
    // ------------------------------------------------------------------ //
    // Data on the DPD/srx I/F is provided independent of the Tx baseband I/F.
    // Once s_axis_srx_tvalid is asserted, DPD expects it to remain high
    // or an underrun event is flagged.
    //
    // Tile 226 ADC's provide data in complex IQ format. See BD port map.
    //      m20_axis = ADC0 I data, m21_axis = ADC0 Q data
    //      m22_axis = ADC1 I data, m23_asis = ADC1 Q data
    // IQ data is send to DPD in Single Phase format (Pg076, Table 3-4):
    //      Q = srx_din[31:16], I = srx_din[15:0]
    // ------------------------------------------------------------------ //

    assign dpd_req_granted = (srx_state == S_GRANT_REQUEST);

    always_ff @(posedge axis_aclk) begin
        if (dpd_req_granted) begin
            srx_tuser_antenna <= dpd_sel_ant;
        end
    end

    // For DPD, the observation antenna is not changed for rf_switch_override
    always_comb begin
        case (srx_tuser_antenna)
            0   : begin
                    IFP_dpd.srx_tdata   = IFP_srx[0].tdata;
                    IFP_dpd.srx_tvalid  = IFP_srx[0].tvalid;
                  end
            1   : begin
                    IFP_dpd.srx_tdata   = IFP_srx[1].tdata;
                    IFP_dpd.srx_tvalid  = IFP_srx[1].tvalid;
                  end
            2   : begin
                    IFP_dpd.srx_tdata   = IFP_srx[2].tdata;
                    IFP_dpd.srx_tvalid  = IFP_srx[2].tvalid;
                  end
            3   : begin
                    IFP_dpd.srx_tdata   = IFP_srx[3].tdata;
                    IFP_dpd.srx_tvalid  = IFP_srx[3].tvalid;
                  end
            default : begin
                    IFP_dpd.srx_tdata   = IFP_srx[0].tdata;
                    IFP_dpd.srx_tvalid  = IFP_srx[0].tvalid;
                  end
        endcase
    end

    // srx_tuser lets DPD know that the antenna has switched. Based on
    // fig 3-4 in PG076, srx_tready and srx_tvalid may be high all the time.
    assign IFP_dpd.srx_tuser = {5'd0, srx_tuser_antenna};

    // Per Figure 3-4 in pg076, DPD tready is invalid after request
    // until the antenna switch is complete.
    assign IFP_srx[0].tready = IFP_dpd.srx_tready;
    assign IFP_srx[1].tready = IFP_dpd.srx_tready;
    assign IFP_srx[2].tready = IFP_dpd.srx_tready;
    assign IFP_srx[3].tready = IFP_dpd.srx_tready;

    // ------------------------------------------------------------------ //
    // Observation Stream for WRSSI calculation                           //
    // ------------------------------------------------------------------ //
    // For WRSSI (Debug), the observation antenna is changed for
    // rf_switch_override. So use curr_ant instead of dpd_sel_ant

    always_ff @(posedge axis_aclk) begin
        srx_wrssi_ant <= curr_ant;
    end


endmodule

