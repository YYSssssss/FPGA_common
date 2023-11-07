// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : M Faizan                                                    //
// Date         : 9/28/20                                                     //
// File         : jb_dac_mux.sv                                               //
// Design       :                                                             //
// Purpose      :                                                             //
// Device       : xczu47dr-fsve1156-2-i-es1                                   //
// -------------------------------------------------------------------------- //
`timescale 1 ps / 1 ps

module jb_dac_mux #(
    parameter   N_ANTENNAS              = 4
) (
    input                               axis_clk,
    input                               axis_aresetn,
    input           [1:0]               dfe_sel,
    jb_axi4_stream_if.slave             IFP_dfe         [N_ANTENNAS-1:0],
    jb_axi4_stream_if.master            IFP_dac
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
    localparam  DAC0 = 0,   T228_DAC00 = 0;
    localparam  DAC1 = 1,   T228_DAC01 = 1;
    localparam  DAC2 = 2,   T228_DAC02 = 2;
    localparam  DAC3 = 3,   T228_DAC03 = 3;
    localparam  DAC4 = 4,   T229_DAC00 = 4;
    localparam  DAC5 = 5,   T229_DAC01 = 5;
    localparam  DAC6 = 6,   T229_DAC02 = 6;
    localparam  DAC7 = 7,   T229_DAC03 = 7;

    localparam  USER_ID_BW = $clog2(N_ANTENNAS);
    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(USER_ID_BW)) IFP_mux ();

    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    // IFP_dfe[n].tready   = IFP_dac.tready;
    // tready (DAC --> DFE) cannot be assigned here because it's possible
    // that one DFE chain is assigned to multiple DACs by mistake. If that
    // happends, then tready will be multi-driven.
    
    always_comb begin
        case (dfe_sel)
            0    : begin
                        IFP_mux.tvalid  = IFP_dfe[0].tvalid;
                        IFP_mux.tdata   = IFP_dfe[0].tdata;
                      end
            1    : begin
                        IFP_mux.tvalid  = IFP_dfe[1].tvalid;
                        IFP_mux.tdata   = IFP_dfe[1].tdata;
                      end
            2    : begin
                        IFP_mux.tvalid  = IFP_dfe[2].tvalid;
                        IFP_mux.tdata   = IFP_dfe[2].tdata;
                      end
            3    : begin
                        IFP_mux.tvalid  = IFP_dfe[3].tvalid;
                        IFP_mux.tdata   = IFP_dfe[3].tdata;
                      end
            default : begin
                        IFP_mux.tvalid  = IFP_dfe[0].tvalid;
                        IFP_mux.tdata   = IFP_dfe[0].tdata;
                      end
        endcase
    end

    // Retimed for relaxed timing
    always_ff @(posedge axis_clk) begin
        IFP_dac.tvalid  <= IFP_mux.tvalid;
        IFP_dac.tdata   <= IFP_mux.tdata;
    end

endmodule
