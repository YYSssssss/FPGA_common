`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/07 18:00:17
// Design Name: 
// Module Name: tpram_1024x128_tb
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


module tpram_1024x128_tb #(
  parameter READ_RAM_WIDTH = 128,
  parameter SAMPLE_WIDTH   = 32,
  parameter READ_DATA_NUM  = 1024
)
(
  input                             rst_n,
  input                             clk,
  output logic [READ_RAM_WIDTH-1:0] test_data,
  output logic                      cp_valid,
  output logic                      cp_switch,
  output logic                      cp_last
);

//********************  reg & wire  ********************//
logic rst_n0;
logic rst_n1;
logic rst_n2;
logic [31:0] cnt_rst_n;

//********************  main  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_rst_n <= 'd0;
  end
  else if(cnt_rst_n == 'd1205) begin
    cnt_rst_n <= 'd0;
  end
  else if(rst_n) begin
    cnt_rst_n <= cnt_rst_n + 1'b1;
  end
end

assign rst_n0 = rst_n;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    rst_n1 <= 'd1;
  end
  else if(cnt_rst_n >= 'd1200) begin
    rst_n1 <= 'd0;
  end
  else begin
    rst_n1 <= 'd1;
  end
end

gen_ram_data0 #(
  .READ_RAM_WIDTH (READ_RAM_WIDTH),
  .READ_DATA_NUM  (READ_DATA_NUM)
) u_gen_ram_data0(
  .clk          (clk      ),
  .rst_n        (rst_n0 & rst_n1),
  .test_data    (test_data),
  .cp_valid     (cp_valid ),
  .cp_last      (cp_last  )
);

//********************  switch  ********************//
logic cp_valid_d0;
logic cp_valid_d1;
logic cp_reversal;
always @(posedge clk or negedge rst_n) begin //addrb
  cp_valid_d0 <= cp_valid;
  cp_valid_d1 <= cp_valid_d0;
end
assign cp_reversal = cp_valid_d0 & ~cp_valid_d1;

always @(posedge clk or negedge rst_n) begin //addrb
  if(!rst_n) begin
    cp_switch <= 'd1;
  end
  else if(cp_reversal) begin
    cp_switch <= 'd1;
  end
  else begin
    cp_switch <= cp_switch;
  end
end

endmodule