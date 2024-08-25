`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/19/2024 02:23:32 PM
// Design Name: 
// Module Name: delay_data
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


module delay_data #(
    parameter DEPTH      = 2,   
    parameter DATA_WIDTH = 16
)(
    input                   clk         ,
    input                   rst_n       ,
    input [DATA_WIDTH-1:0]  i_x0        ,
    output[DATA_WIDTH-1:0]  o_y0

);
reg  [DATA_WIDTH-1:0] s_delay_data[DEPTH-1:0];
reg  [15:0]           gv_i;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	for (gv_i = 0; gv_i < DEPTH; gv_i = gv_i + 1) begin
        s_delay_data[gv_i] <= 16'h0000; // Initialize to 0
    end
  end
  else begin
    s_delay_data[0] <= i_x0;
    for(gv_i=1; gv_i<DEPTH; gv_i = gv_i+1 )
      begin
        s_delay_data[gv_i]<=s_delay_data[gv_i-1];
      end
  end
end
assign o_y0 = (DEPTH==0) ? i_x0 : s_delay_data[DEPTH-1];

endmodule
