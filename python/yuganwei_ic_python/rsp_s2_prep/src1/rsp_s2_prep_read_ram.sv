`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 23:27:25
// Design Name: 
// Module Name: cp_read_ram
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


module rsp_s1_prep_read_ram #(
    parameter DELAY_DATA_ARRIVE = 5,
    parameter READ_RAM_WIDTH = 128,
    parameter SAMPLE_WIDTH = 32,
    parameter RD_INTERVAL = 50,
    parameter ADD_ADDR = 16
   // parameter DATA_NUM = 1024,
   //    parameter INIT_ADDR = 0,
   //parameter END_ADDR = 16384 //DATA_NUM*ADD_ADDR
)(
   input                                       clk            ,
   input                                       rst_n          ,
   input      [15:0]                           DATA_NUM       ,
   input      [17:0]                           RD_START_ADDR  ,
   input      [17:0]                           RD_END_ADDR    ,
   input                                       i_start        ,
   input      [READ_RAM_WIDTH-1:0]             i_m0_rd_data   ,            
   output reg [18-1:0]                         o_m0_rd_addr   ,
   output reg                                  o_m0_rd_en     ,
   output reg [READ_RAM_WIDTH-1:0]             o_data         ,
   output                                      o_data_valid   ,
   output                                      o_data_last
);

//********************  parameter  ********************//
//localparam CNT_RD_WIDTH = $clog2(DATA_NUM);
localparam CNT_RD_WIDTH = 16;
localparam RD_INTERVAL_WIDTH = $clog2(RD_INTERVAL);

//********************  reg & wire  ********************//
reg i_start_d0;
reg i_start_d1;
wire start_p;
wire start_p1;
reg  s_data_last;

reg [15:0] cnt_rd_en;
reg [RD_INTERVAL_WIDTH:0] cnt_rd_interval;

//********************  cnt  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_rd_en <= {CNT_RD_WIDTH{1'b0}};
  end
  else begin
    if(cnt_rd_en == DATA_NUM-1)
      cnt_rd_en <= {CNT_RD_WIDTH{1'b0}};
    else if(o_m0_rd_en)
      cnt_rd_en <= cnt_rd_en + 1'b1;
    else
      cnt_rd_en <= cnt_rd_en;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_rd_interval <= {RD_INTERVAL_WIDTH{1'b0}};
  end
  else begin
    if(cnt_rd_interval == RD_INTERVAL-1)
      cnt_rd_interval <= {RD_INTERVAL_WIDTH{1'b0}};
    else if(cnt_rd_en == DATA_NUM-1)
      cnt_rd_interval <= 1'b1;
    else if(cnt_rd_interval >= 1'b1)
      cnt_rd_interval <= cnt_rd_interval + 1'b1;
  end
end

//******************** Indicative signal ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_start_d0 <= 1'b0;
    i_start_d1 <= 1'b0;
  end
  else begin
    i_start_d0 <= i_start;
    i_start_d1 <= i_start_d0;
  end
end
assign start_p = ~i_start_d0 & i_start_d1; //negedge
// assign start_p1 = cnt_rd_interval == RD_INTERVAL-1;
assign start_p1 = 0;




//******************** output ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m0_rd_en <= 1'b0;
  end
  else begin
    if(start_p == 1'b1 || start_p1 == 1'b1)
      o_m0_rd_en <= 1'b1;
    else if(cnt_rd_en == DATA_NUM-1)
      o_m0_rd_en <= 1'b0;
    else
      o_m0_rd_en <= o_m0_rd_en;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m0_rd_addr <= RD_START_ADDR;
  end
  else begin
    if(o_m0_rd_addr == RD_END_ADDR)
      o_m0_rd_addr <= RD_START_ADDR;
    else if(o_m0_rd_en == 1'b1)
      o_m0_rd_addr <= o_m0_rd_addr + ADD_ADDR;
    else
      o_m0_rd_addr <= o_m0_rd_addr;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_data <= {READ_RAM_WIDTH{1'b0}};
  end
  else begin
    o_data <= i_m0_rd_data;
  end
end

delay #(DELAY_DATA_ARRIVE) delay_rd_en(.clk(clk), .rst_n(rst_n), .din(o_m0_rd_en), .dout(o_data_valid));

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    s_data_last <= 1'b0;
  end
  else begin
    if(cnt_rd_en == DATA_NUM-1)
      s_data_last <= 1'b1;
    else
      s_data_last <= 1'b0;
  end
end
delay #(DELAY_DATA_ARRIVE-1) delay_data_last(.clk(clk), .rst_n(rst_n), .din(s_data_last), .dout(o_data_last));

endmodule
