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
    jb_hw_ctrl_if.rf_ctrl       IFP_ctrl,
    input                       axis_aclk,
    input                       axis_aresetn,
    jb_dpd_srx_if.srx_ctrl      IFP_dpd,
    jb_axi4_stream_if.slave     IFP_srx [N_ANTENNAS-1:0],
    output  logic   [2:0]       srx_wrssi_ant,
    output  logic [5:0]         rf_switch_n = 'h3f,
    output  logic [5:0]         rf_switch_en_n = 'h3f
);

    localparam      REQUEST_TYPE_DPD        = 4'h0,
                    REQUEST_TYPE_HIRES      = 4'h1,
                    REQUEST_TYPE_VSWR       = 4'h2,
                    REQUEST_TYPE_AVAIL      = 4'hF;

    localparam      S_WAIT_FOR_REQUEST      = 2'd0,
                    S_SWITCH_ANTENNA        = 2'd1,
                    S_WAIT_FOR_ANTENNA      = 2'd2,
                    S_GRANT_REQUEST         = 2'd3;

    localparam      RF_PORT1                = 1'b1,
                    RF_PORT2                = 1'b0;

    localparam      SRX_CNTR_MAX            = 16'hC8; // 200 cycles (368.64MHz) = 542 ns

    logic [2:0]     dpd_ant_sel             = 0;
    logic [3:0]     dpd_req_type            = REQUEST_TYPE_DPD;
    logic           dpd_req_valid;
    logic           dpd_req_granted;
    logic           dpd_req_is_dpd;
    logic           dpd_tready_valid        = 0;
    logic [5:0]     dpd_rf_switch_en_n      = 'h3F;
    logic [5:0]     dpd_rf_switch_n         = 'h3F;

    logic [1:0]     srx_state               = S_WAIT_FOR_REQUEST;
    logic [1:0]     srx_state_next          = S_WAIT_FOR_REQUEST;
    logic [15:0]    srx_cntr                = 0;
    logic [2:0]     srx_tuser_antenna       = 0;

    logic [2:0]     curr_ant;

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
            dpd_ant_sel  <= IFP_dpd.srx_ctrl_tdata[2:0];
        end
    end

    // ------------------------------------------------------------------ //
    // Antenna Switching control                                          //
    // ------------------------------------------------------------------ //
    assign dpd_req_valid    = (dpd_req_type == REQUEST_TYPE_DPD) | (dpd_req_type == REQUEST_TYPE_VSWR);
    assign dpd_req_is_dpd   = (dpd_req_type == REQUEST_TYPE_DPD);
    
    // Switch SRX path on the PA board
    // Switch all 2nd level switches together based on request type
    always_ff @(posedge axis_aclk) begin
        if (srx_state == S_SWITCH_ANTENNA) begin

            // HMC8038 SPDT Switch Enable
            // Turn off all switches if the dpd request is invalid
            // EN is Active-Low: 0 = ON, 1 = OFF
            dpd_rf_switch_en_n[0] <= ~(dpd_req_valid & ((dpd_ant_sel == 0) | (dpd_ant_sel == 1)));
            dpd_rf_switch_en_n[3] <= ~(dpd_req_valid & ((dpd_ant_sel == 2) | (dpd_ant_sel == 3)));
            dpd_rf_switch_en_n[1] <= ~(dpd_req_valid &  (dpd_ant_sel == 0));
            dpd_rf_switch_en_n[2] <= ~(dpd_req_valid &  (dpd_ant_sel == 1));
            dpd_rf_switch_en_n[4] <= ~(dpd_req_valid &  (dpd_ant_sel == 2));
            dpd_rf_switch_en_n[5] <= ~(dpd_req_valid &  (dpd_ant_sel == 3));

            // HMC8038 SPDT Switch Port Select
            // Vctl:    1 (RF_PORT1) = RFC to RF1
            //          0 (RF_PORT2) = RFC to RF2
            
            // RF Switch 1 selects between Antenna 0 and Antenna 1
            dpd_rf_switch_n[0] <= (dpd_ant_sel == 0) ? RF_PORT2 : RF_PORT1; // ORX01 path = P2=ANT0 : P1=ANT1
            
            // RF Switch 3 selects between Antenna 2 and Antenna 3
            dpd_rf_switch_n[3] <= (dpd_ant_sel == 2) ? RF_PORT2 : RF_PORT1; // ORX23 path = P2=ANT2 : P1=ANT3
            
            // These switches select between DPD and VSWR paths
            dpd_rf_switch_n[1] <= dpd_req_is_dpd ? RF_PORT2 : RF_PORT1;     // Ant0 = P2=DPD0 : P1=VSWR0
            dpd_rf_switch_n[2] <= dpd_req_is_dpd ? RF_PORT1 : RF_PORT2;     // Ant1 = P1=DPD1 : P2=VSWR1
            dpd_rf_switch_n[4] <= dpd_req_is_dpd ? RF_PORT2 : RF_PORT1;     // Ant2 = P2=DPD2 : P1=VSWR2
            dpd_rf_switch_n[5] <= dpd_req_is_dpd ? RF_PORT1 : RF_PORT2;     // Ant3 = P1=DPD3 : P2=VSWR3
        end
    end

    // These flops are probably not needed
    always_ff @(posedge axis_aclk) begin
        rf_switch_en_n <= IFP_ctrl.rf_switch_override ? IFP_ctrl.rf_switch_en_n : dpd_rf_switch_en_n;
        rf_switch_n    <= IFP_ctrl.rf_switch_override ? IFP_ctrl.rf_switch_n    : dpd_rf_switch_n;
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

/*
    logic [31:0]    orx01_tdata;
    logic           orx01_tvalid;
    logic [31:0]    orx23_tdata;
    logic           orx23_tvalid;

    assign orx01_tdata = {IFP_srx[1].tdata,   IFP_srx[0].tdata};    // {q,i}
    assign orx01_tvalid = IFP_srx[1].tvalid & IFP_srx[0].tvalid;

    assign orx23_tdata = {IFP_srx[3].tdata,   IFP_srx[2].tdata};    // {q,i}
    assign orx23_tvalid = IFP_srx[3].tvalid & IFP_srx[2].tvalid;
*/

    // Grant requestd antenna data stream.
    // SRX0 = Antenna 0 0r 1, SRX1 = Antenna 2 or 3

    assign dpd_req_granted = (srx_state == S_GRANT_REQUEST);

    always_ff @(posedge axis_aclk) begin
        if (dpd_req_granted) begin
            srx_tuser_antenna <= dpd_ant_sel;
        end
    end
    
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

    assign curr_ant = IFP_ctrl.rf_switch_override ? IFP_ctrl.orx_ant_sel    : dpd_ant_sel;

    always_ff @(posedge axis_aclk) begin
        srx_wrssi_ant <= curr_ant;
    end

endmodule

