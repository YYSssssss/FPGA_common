// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : M Faizan                                                    //
// Date         : 9/28/20                                                     //
// File         : jb_adc_mux.sv                                               //
// Design       :                                                             //
// Purpose      :                                                             //
// Device       : xczu47dr-fsve1156-2-i-es1                                   //
// -------------------------------------------------------------------------- //
`timescale 1 ps / 1 ps

module jb_adc_mux #(
    parameter   N_ADC                   = 8,
	parameter   N_ANT_SEL               = 2
) (
    input                                              axis_clk,
    input                                              axis_aresetn,
    input           [2:0]                              adc_sel,
    jb_axi4_stream_if.slave                            IFP_adc [N_ANT_SEL-1:0][N_ADC/2-1:0],
    jb_axi4_stream_if.master                           IFP_dfe	
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
    localparam  ADC0 = 0,   T224_ADC01 = 0;
    localparam  ADC1 = 1,   T224_ADC23 = 1;
    localparam  ADC2 = 2,   T225_ADC01 = 2;
    localparam  ADC3 = 3,   T225_ADC23 = 3;
    localparam  ADC4 = 4,   T226_ADC01 = 4;
    localparam  ADC5 = 5,   T226_ADC23 = 5;
    localparam  ADC6 = 6,   T227_ADC01 = 6;
    localparam  ADC7 = 7,   T227_ADC23 = 7;

    localparam  USER_ID_BW = $clog2(N_ADC);
    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    jb_axi4_stream_if  #(.DATA_WIDTH(32), .USER_SB_WIDTH(USER_ID_BW)) IFP_mux ();


    // ------------------------------------------------------------------ //
    // ADC Connections (Dual RF-ADC Tiles)                                //
    // ------------------------------------------------------------------ //
    // PG269 v2.2, page 58                                                //
    // There are four streams per tile, and the naming convention is      //
    // mXY_axis, where X represents the RF-ADC tile number and Y          //
    // represents a stream (FIFO) output from that tile.                  //
    //                                                                    //
    // For Dual tiles, a given stream is either real, I or Q.             //
    //      If an RF-ADC is configured with I/Q output data, then the     //
    //      streams with an even number represent I data and the streams  //
    //      with an odd number represent Q data.                          //
    // For Quad tiles, a given stream is either real or I/Q interleaved.  //
    // ------------------------------------------------------------------ //

    // IFP_adc[n].tready   = 1'b1;
    // tready (DFE --> ADC) cannot be assigned here because it's possible that
    // one ADC is assigned to multiple DFE chains by mistake. If that
    // happends, then tready will be multi-driven.
    
    always_comb begin
        case (adc_sel)
            ADC0    : begin
                        IFP_mux.tvalid      = IFP_adc[0][2].tvalid;
                        IFP_mux.tdata       = IFP_adc[0][2].tdata; // {q,i}
                      end
            ADC1    : begin
                        IFP_mux.tvalid      = IFP_adc[0][1].tvalid;
                        IFP_mux.tdata       = IFP_adc[0][1].tdata; // {q,i}
                      end
            ADC2    : begin
                        IFP_mux.tvalid      = IFP_adc[0][3].tvalid;
                        IFP_mux.tdata       = IFP_adc[0][3].tdata; // {q,i}
                      end
            ADC3    : begin
                        IFP_mux.tvalid      = IFP_adc[0][0].tvalid;
                        IFP_mux.tdata       = IFP_adc[0][0].tdata; // {q,i}
                      end
            ADC4    : begin
                        IFP_mux.tvalid      = IFP_adc[1][0].tvalid;
                        IFP_mux.tdata       = IFP_adc[1][0].tdata; // {q,i}
                      end
            ADC5    : begin
                        IFP_mux.tvalid      = IFP_adc[1][3].tvalid;
                        IFP_mux.tdata       = IFP_adc[1][3].tdata; // {q,i}
                      end
            ADC6    : begin
                        IFP_mux.tvalid      = IFP_adc[1][1].tvalid;
                        IFP_mux.tdata       = IFP_adc[1][1].tdata; // {q,i}
                      end
            ADC7    : begin
                        IFP_mux.tvalid      = IFP_adc[1][2].tvalid;
                        IFP_mux.tdata       = IFP_adc[1][2].tdata; // {q,i}
                      end
            default : begin
                        IFP_mux.tvalid      = IFP_adc[0][2].tvalid;
                        IFP_mux.tdata       = IFP_adc[0][2].tdata; // {q,i}
                      end
        endcase
    end

    // Retimed for relaxed timing
    // Do not need to retime adcp_* since these will be synchronized in adcp block
    always_ff @(posedge axis_clk) begin
        IFP_dfe.tvalid  <= IFP_mux.tvalid;
        IFP_dfe.tdata   <= IFP_mux.tdata; // {q,i}
    end

endmodule
