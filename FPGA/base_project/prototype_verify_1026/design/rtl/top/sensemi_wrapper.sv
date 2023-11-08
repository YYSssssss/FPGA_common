`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 09:25:35 PM
// Design Name: 
// Module Name: sensemi_wrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sensemi_prototype_wrapper(
    input              sys_clk_p, 
    input              sys_clk_n
);

//******************** reg & wire ********************//
wire fpga_clk;

//******************** primitive ********************//
IBUFGDS u_fpga_clk(
    .O(fpga_clk),
    .I(sys_clk_p),
    .IB(sys_clk_n)
);

sensemi_prototype_top u_sensemi_prototype_top(
    .i_fpga_clk       (fpga_clk)
);    

endmodule
