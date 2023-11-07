// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 10/01/19                                                    //
// Module       : jb_clk_en_gen                                               //
// Description  :                                                             //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
// ========================================================================== //
`timescale 1ns / 1ps

module jb_clk_en_gen #(
    parameter PLACEHOLDER = 0
) (
    input                       clk,
    input                       reset,
    output  logic               clk_en_div1,
    output  logic               clk_en_div2,
    output  logic               clk_en_div4,
    output  logic               clk_en_div8,  // SM Adding Div 8
    output  logic               clk_en_div16  // SM Adding Div 16
);
    // ------------------------------------------------------------------ //
    // Parameters                                                         //
    // ------------------------------------------------------------------ //

   // localparam  COUNTER_WIDTH  = 2;
    localparam  COUNTER_WIDTH  = 4;  // SM Extending to 1/16 div


    // ------------------------------------------------------------------ //
    // Signals                                                            //
    // ------------------------------------------------------------------ //
    logic [COUNTER_WIDTH-1:0]   clk_count       = 0;
    logic                       clk_count_en;

    // ------------------------------------------------------------------ //
    // Clock Counter                                                      //
    // ------------------------------------------------------------------ //
    assign clk_count_en = ~reset;

    always_ff @(posedge clk) begin
        if      (reset)     clk_count   <= 0;
        else                clk_count   <= clk_count + 1;
    end

    assign clk_en_div1  = clk_count_en; 
    assign clk_en_div2  = clk_count_en & (clk_count[0] == 0);
    //assign clk_en_div4  = clk_count_en & (clk_count == 0);
    assign clk_en_div4  = clk_count_en & ((clk_count == 0) | (clk_count == 4) | (clk_count == 8) | (clk_count == 12)); // SM Extending to 1/16 div
    assign clk_en_div8  = clk_count_en & ((clk_count == 0) | (clk_count == 8)); // SM Extending to 1/16 div
    assign clk_en_div16 = clk_count_en &  (clk_count == 0); // SM Extending to 1/16 div
    

endmodule

