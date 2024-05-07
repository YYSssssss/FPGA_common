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


module rsp_s1_prep_write_ram #(
    parameter DELAY_DATA_ARRIVE = 2,
    parameter READ_RAM_WIDTH = 128,
    parameter SAMPLE_WIDTH = 32,
    parameter ADD_ADDR = 16
//    parameter INIT_ADDR = 0,
    // parameter WR_INTERVAL = 50,
//    parameter DATA_NUM = 1024,
//    parameter END_ADDR = 16384 //DATA_NUM*ADD_ADDR
)(
   input                                       clk            ,
   input                                       rst_n          ,
   input      [15:0]                           DATA_NUM       ,
   input      [17:0]                           WR_START_ADDR  ,
   input      [17:0]                           WR_END_ADDR    ,
   input      [READ_RAM_WIDTH-1:0]             i_data         ,
   input                                       i_data_valid   ,
   input                                       i_data_last    ,
   output     [READ_RAM_WIDTH-1:0]             o_m1_wr_data   ,            
   output reg [18-1:0]                         o_m1_wr_addr   ,
   output reg                                  o_m1_wr_en     ,
   output reg [16-1:0]                         o_m1_wr_wea    ,
   output reg                                  o_finish
);

//********************  parameter  ********************//
//localparam CNT_WR_WIDTH = $clog2(DATA_NUM);
localparam CNT_WR_WIDTH = 16;


//********************  reg & wire  ********************//
reg  i_data_valid_d0;
reg  i_data_valid_d1;
wire data_valid;
wire [READ_RAM_WIDTH-1:0] s_data;

reg [CNT_WR_WIDTH:0] cnt_wr_en;

//********************  cnt  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_wr_en <= {CNT_WR_WIDTH{1'b0}};
  end
  else begin
    if(cnt_wr_en == DATA_NUM-1)
        cnt_wr_en <= {CNT_WR_WIDTH{1'b0}};
    else if(o_m1_wr_en)
        cnt_wr_en <= cnt_wr_en + 1'b1;
    else
        cnt_wr_en <= cnt_wr_en;
  end
end


//******************** Indicative signal ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_data_valid_d0 <= 1'b0;
    i_data_valid_d1 <= 1'b0;
  end
  else begin
    i_data_valid_d0 <= i_data_valid;
    i_data_valid_d1 <= i_data_valid_d0;
  end
end
assign data_valid = i_data_valid_d0 & ~i_data_valid_d1;

//******************** output ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m1_wr_en <= 1'b0;
    o_m1_wr_wea <= {SAMPLE_WIDTH/2{1'b0}};
  end
  else begin
    o_m1_wr_en <= i_data_valid;
    o_m1_wr_wea <= 16'hffff;
  end
end


assign s_data = i_data_valid ? i_data : {READ_RAM_WIDTH{1'b0}};
rsp_s1_prep_delay_data #(
  .DEPTH      (DELAY_DATA_ARRIVE),
  .DATA_WIDTH (READ_RAM_WIDTH)
)u_delay_data(
  .clk          (clk         ),
  .rst_n        (rst_n       ),
  .i_x0         (s_data      ),
  .o_y0         (o_m1_wr_data)
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m1_wr_addr <= WR_START_ADDR;
  end
  else begin
    if(o_m1_wr_addr == WR_END_ADDR)
        o_m1_wr_addr <= WR_START_ADDR;
    else if(o_m1_wr_en)
        o_m1_wr_addr <= o_m1_wr_addr + ADD_ADDR;
    else
        o_m1_wr_addr <= o_m1_wr_addr;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_finish <= 1'b0;
  end
  else begin
    if(cnt_wr_en == DATA_NUM-1)
        o_finish <= 1'b1;
    else
        o_finish <= 1'b0;
  end
end

endmodule

