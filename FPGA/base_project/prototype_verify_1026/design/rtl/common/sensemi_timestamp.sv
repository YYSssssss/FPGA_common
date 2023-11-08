`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 11:23:07 AM
// Design Name: Jade Yu
// Module Name: sensemi_timestamp
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
`timescale 1 ps / 1 ps

module sensemi_timestamp(
  input                       axi_clk,
  sensemi_test_stat_if.blk         IFP_test_stat
);


  logic        timestamp_clk;
  logic [31:0] timestamp_data;
  logic        timestamp_valid;
  
  USR_ACCESSE2 
  USR_ACCESSE2_inst(
    .CFGCLK     (timestamp_clk),
    .DATA       (timestamp_data),           // 32-bit output: Configuration Data reflecting the contents of the AXIS register
    .DATAVALID  (timestamp_valid)
    );

  always@(posedge axi_clk)begin
    IFP_test_stat.timestamp <= timestamp_data;
  end


endmodule