`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/23 10:37:01
// Design Name: 
// Module Name: cp_s1_write_ram
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


module rsp_s2_prep_add_u #(
    parameter DATA_WIDTH = 16
)(
   input  [DATA_WIDTH-1:0]          num1 ,
   input  [DATA_WIDTH-1:0]          num2 ,
   output [DATA_WIDTH-1:0]          out_num ,  
   input                            i_c ,  
   output                           o_c
);

assign {o_c,out_num} = num1 + num2 + i_c; 

endmodule

