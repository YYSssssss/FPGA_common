`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/10/2019 02:32:32 PM
// Design Name: 
// Module Name: jb_decoder_3to8
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


module jb_decoder_3to8(
    input [2:0] din,
    output [7:0] dout
    );

// Active High Output
/* 
    assign dout = (din == 3'b000) ? 8'b00000001 :
                  (din == 3'b001) ? 8'b00000010 :
                  (din == 3'b010) ? 8'b00000100 :
                  (din == 3'b011) ? 8'b00001000 :
                  (din == 3'b100) ? 8'b00010000 :
                  (din == 3'b101) ? 8'b00100000 :
                  (din == 3'b110) ? 8'b01000000 : 8'b10000000;
*/

// Active Low Output
    assign dout = (din == 3'b000) ? 8'b11111110 :
                  (din == 3'b001) ? 8'b11111101 :
                  (din == 3'b010) ? 8'b11111011 :
                  (din == 3'b011) ? 8'b11110111 :
                  (din == 3'b100) ? 8'b11101111 :
                  (din == 3'b101) ? 8'b11011111 :
                  (din == 3'b110) ? 8'b10111111 : 8'b01111111;
    
endmodule
