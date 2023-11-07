// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 05/10/2019                                                  //
// Module       : edge_detect                                                 //
// Description  :                                                             //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
// ========================================================================== //

`timescale 1ns / 1ps

module jb_pulse_stretch #(
    parameter   PULSE_WIDTH     = 4        // (0=invalid) Output pulse width
) (
    input                       clk,
    input                       din,
    output                      dout
);

    
   
    
    logic [PULSE_WIDTH-1:0]     stretcher_ff; // reset?
    logic                       pulse_stretched;
   
    logic                       dout_ff             = 0;
    
  genvar i;


    // ------------------------------------------------------------------ //
    // Pulse Stretcher -                                                  //
    // ------------------------------------------------------------------ //
    // Starting pulse width is already 1. So start without a flop.

    assign stretcher_ff[0] = din;
    
    generate
        for (i=1; i<PULSE_WIDTH; i=i+1)
        begin : stretch_stage
            always_ff @(posedge clk) begin
                stretcher_ff[i] <= stretcher_ff[i-1];
            end
        end
    endgenerate

    assign pulse_stretched = |stretcher_ff;

    // ------------------------------------------------------------------ //
    // Retiming -                                                         //
    // ------------------------------------------------------------------ //

    always_ff @(posedge clk) begin
        dout_ff <= pulse_stretched;
    end

    assign dout = dout_ff;

    
endmodule // jb_pulse_stretch


