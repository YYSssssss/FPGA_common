//-----------------------------------------------------------------------------
// File: common_tb.sv
// Author: Jade Yu
// Created by : Jade Yu
// Abstract: abs with JPL
// Modification history:
// $Log$
//   yuyushan 7/25/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps
module commmon_tb;

/////////////////////////// parameter ////////////////////////////
parameter debug_fifo_data_gen_width = 16;
parameter abs_width = 16;
parameter READ_RAM_WIDTH = 128;
parameter SAMPLE_WIDTH   = 32;
parameter READ_DATA_NUM  = 1024;
parameter NUM  = 8;
parameter DATA_WIDTH  = 16;
parameter CNT_DATA = 1024-1; 
parameter PACKET_SELECT = 4;

localparam DELAY          = 2;
localparam INTERVAL       = 50;
localparam DATA_NUM       = 1024;
localparam INIT_ADDR      = 0;
localparam ADD_ADDR       = 1;
localparam END_ADDR       = 1024;

/////////////////////////// logic ////////////////////////////
//clk & rstn
logic rst_n;
logic clk_50m;
logic clk_75m;
logic clk_100m;
logic clk_150m;
logic clk_200m;
logic clk_250m;
logic clk_300m;
logic clk_400m;
logic clk_500m;
logic clk;
logic s_start;
logic start;
logic finish;
logic mem_req;
logic mem_req_ack;
logic done;
logic done_ack;



///////////////////////////////////////////////////////

initial begin
#0  
rst_n=0;
s_start=1;
clk=0;
clk_50m=0;
clk_75m=0;
clk_100m=0;
clk_150m=0;
clk_200m=0;
clk_250m=0;
clk_300m=0;
clk_400m=0;
clk_500m=0;
#100 
rst_n=1;
#50
s_start=0;
#100
start = 1;
// #5700
// #18000
#2000000000
$stop;
end

always #2.5  clk      = ~clk; // 200M
always #10   clk_50m  = ~clk_50m;  // 50M
always #6.67 clk_75m  = ~clk_75m;  // 75M
always #5    clk_100m = ~clk_100m; // 100M
always #3.33 clk_150m = ~clk_150m; // 150M
always #2.5  clk_200m = ~clk_200m; // 200M
always #2    clk_250m = ~clk_250m; // 250M
always #1.67 clk_300m = ~clk_300m; // 300M
always #1.25 clk_400m = ~clk_400m; // 400M
always #1    clk_500m = ~clk_500m; // 500M

//
logic o_radar_framestart;
logic o_camera_framestart;
logic o_ir_framestart;
//gen_framestart #(
//    .CONFIG_CLK (200)
//) u_gen_framestart(
//    .clk                       (clk_300m    ),
//    .rst_n                     (rst_n       ),
//    .ps_framestart             (1'b1        ),
//    .i_config_radar_num_100us  ('d66        ),
//    .i_config_radar_100us      ('d30000     ), //0.1ms   100us
//    .i_config_camera_num_100us ('d100       ),
//    .i_config_camera_100us     ('d30000     ),
//    .i_config_ir_num_100us     ('d300       ),
//    .i_config_ir_100us         ('d30000     ),
//    .i_config_cnt_fs_valid     ('d300       ),
//    .o_radar_framestart        (o_radar_framestart       ),
//    .o_camera_framestart       (o_camera_framestart      ),
//    .o_ir_framestart           (o_ir_framestart          )
//);

//MMW_8M_IR_Framestart u_MMW_8M_IR_Framestart(
//    .clk                 (clk_300m),
//    .rst_n               (rst_n),
//    .start               (1'b1),
//    .ps_framestart       (1'b1),
//    .o_camera_framestart (o_camera_framestart),
//    .o_ir_framestart     (o_ir_framestart)
//);

gen_framestart u_gen_framestart(
    .clk                       (clk_300m),
    .rst_n                     (rst_n  ),
    .i_start                   (start  ),
    .i_config_radar_num_100us  ('d333  ),
    .i_config_radar_100us      ('d30000),
    .i_config_camera_num_100us ('d333  ),
    .i_config_camera_100us     ('d30000),
    .i_config_ir_num_100us     ('d333  ),
    .i_config_ir_100us         ('d30000),
    .i_config_cnt_fs_valid     ('d300  ),
    .o_radar_framestart        (),
    .o_camera_framestart       (),
    .o_ir_framestart           ()
);

reg s0_radar_mipi_vld;
reg s1_radar_mipi_vld;
reg [32-1:0]  radar_mipi_data [4-1:0];
reg [128-1:0]  comb_data ;

integer cnt_data_i;
logic radar_mipi_out_tvalid;
logic [31:0] radar_mipi_out_tdata;



always @(posedge clk_200m or negedge rst_n) begin
  if (!rst_n) begin
    cnt_data_i <= 0;
  end
  else begin
    if(cnt_data_i == 'd3)
        cnt_data_i <= 0;
    else if(radar_mipi_out_tvalid)
        cnt_data_i <= cnt_data_i + 1'b1;
    else
        cnt_data_i <= cnt_data_i;
  end
end
//assign s0_radar_mipi_vld = (cnt_data_i == 'd3);

always @(posedge clk_200m or negedge rst_n) begin
  if (!rst_n) begin
    radar_mipi_data[0] <= 'd0;
    radar_mipi_data[1] <= 'd0;
    radar_mipi_data[2] <= 'd0;
    radar_mipi_data[3] <= 'd0;
  end
  else begin
    radar_mipi_data[cnt_data_i] <= radar_mipi_out_tdata;
  end
end


always @(posedge clk_200m or negedge rst_n) begin
  if (!rst_n) begin
    s0_radar_mipi_vld <= 'd0;
    s1_radar_mipi_vld <= 'd0;
    comb_data <= 128'd0;
  end
  else begin
    s0_radar_mipi_vld <= (cnt_data_i == 'd3);
    s1_radar_mipi_vld <= s0_radar_mipi_vld;
    comb_data = {radar_mipi_data[3][31:16],radar_mipi_data[2][31:16],radar_mipi_data[1][31:16],radar_mipi_data[0][31:16],
                 radar_mipi_data[3][15:0],radar_mipi_data[2][15:0],radar_mipi_data[1][15:0],radar_mipi_data[0][15:0] };
  end
end











//tb
integer cnt0_tb;
always @(posedge clk_200m or negedge rst_n) begin
  if (!rst_n) begin
    radar_mipi_out_tvalid <= 0;
    radar_mipi_out_tdata <= 0;
  end
  else begin
    if(cnt0_tb != 'd4) begin
        radar_mipi_out_tvalid <= 1;
        radar_mipi_out_tdata <= radar_mipi_out_tdata;
    end
    else if(cnt0_tb == 'd4) begin
        radar_mipi_out_tvalid <= 0;
        radar_mipi_out_tdata <= 32'h04030201 + radar_mipi_out_tdata;
    end
  end
end
always @(posedge clk_200m or negedge rst_n) begin
  if (!rst_n) begin
    cnt0_tb <= 0;
  end
  else begin
    if(cnt0_tb == 'd4)
        cnt0_tb <= 'd0;
    else if(cnt0_tb == 'd3)
        cnt0_tb <= 'd4;
    else if(1)
        cnt0_tb <= cnt0_tb + 1'b1;
    else
        cnt0_tb <= cnt0_tb;
  end
end




endmodule