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
`include "../src/rsp_s2_prep_defines.vh"
`include "../src/rsp_s2_prep_op_info.svh"

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
parameter PACKET_SELECT = 3;

localparam DELAY          = 2;
localparam INTERVAL       = 50;
localparam DATA_NUM       = 1024;
localparam ADD_ADDR       = 1;
localparam RD_START_ADDR  = 0;
localparam RD_END_ADDR    = 16384;
localparam WR_START_ADDR  = 0;
localparam WR_END_ADDR    = 16384;

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
logic start;
logic finish;
logic mem_req;
logic mem_req_ack;
logic done;
logic done_ack;

//
parameter ADDRESS_NUM  = 1024;
localparam ADDRESS_WIDTH = 32;
logic [READ_RAM_WIDTH-1:0] mem_1024x64[ADDRESS_NUM-1:0];
logic [READ_RAM_WIDTH-1:0] mem_32x32[ADDRESS_NUM-1:0];
logic [128-1:0] mem_1024x128[1024-1:0];
logic [ADDRESS_WIDTH-1:0] address;
logic [ADDRESS_WIDTH-1:0] s_addr;
logic [ADDRESS_WIDTH-1:0] address2;
logic [ADDRESS_WIDTH-1:0] s_addr2;
logic [ADDRESS_WIDTH-1:0] address3;
logic [ADDRESS_WIDTH-1:0] s_addr3;
logic [63:0] data1;
logic [31:0] data2;
logic [127:0] data3;
logic        data1_vld;
logic        data2_vld;
logic        data3_vld;

//
logic [`L1_DATA_WIDTH-1:0]    i_m0_rd_data_A;
logic                         o_m0_rd_en_A;
logic [`L1_ADDR_WIDTH-1:0]    o_m0_rd_addr_A;
logic [`L1_STRB_WIDTH-1:0]    o_m1_wea_A;
logic [`L1_DATA_WIDTH-1:0]    o_m1_wr_data_A;
logic                         o_m1_wr_en_A;
logic [`L1_ADDR_WIDTH-1:0]    o_m1_wr_addr_A;
logic                         o_finish;

axi_v4_rd_if #(
  .DATA_WIDTH  (128),
  .ADDR_WIDTH  (18),
  .ID_WIDTH    ()
) m_axi_rd();

axi_v4_wr_if #(
  .DATA_WIDTH  (128),
  .ADDR_WIDTH  (18),
  .ID_WIDTH    ()
) m_axi_wr();

///////////////////////////////////////////////////////

initial begin
#0  
rst_n=0;
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

#25000
// $stop;
$finish;
end

always #1  clk      = ~clk; // 200M
always #10   clk_50m  = ~clk_50m;  // 50M
always #6.67 clk_75m  = ~clk_75m;  // 75M
always #5    clk_100m = ~clk_100m; // 100M
always #3.33 clk_150m = ~clk_150m; // 150M
always #2.5  clk_200m = ~clk_200m; // 200M
always #2    clk_250m = ~clk_250m; // 250M
always #1.67 clk_300m = ~clk_300m; // 300M
always #1.25 clk_400m = ~clk_400m; // 400M
always #1    clk_500m = ~clk_500m; // 500M

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)begin
    start <= 0;
  end
  else begin
    if(address == 'd130)
      start <= 1;
    else if(finish || o_finish)
      start <= 1;
    else
      start <= 0;
  end
end
 
//******************** chirp_processing_top ********************//
logic [128-1:0]                 o_m1_wr_data  ;
logic [18-1:0]                  o_m1_wr_addr ;
logic                           o_m1_wr_en    ;
logic                           o_m1_wr_wea   ;

logic [128-1:0]                 i_m0_rd_data  ;
logic [128-1:0]                 s_m0_rd_data  ;
logic [18-1:0]                  o_m0_rd_addr  ;
logic                           o_m0_rd_en   ;

logic [128-1:0]                 rd_data1  ;
logic [32-1:0]                  rd_addr1  ;
logic                           rd_en1   ;

logic [128-1:0]                 rd_ram_data;
logic                           rd_ram_valid;



rsp_s1_prep_delay_data #(
  .DEPTH      (3),
  .DATA_WIDTH (READ_RAM_WIDTH)
) u_delay_t8(
  .clk   (clk_500m  ),
  .rst_n (rst_n),
  .i_x0  (s_m0_rd_data ),
  .o_y0  (i_m0_rd_data )
);

rsp_s2_prep_core #(
  .DELAY   (2)
) u_rsp_s1_prep_core(
  .rst_n                (rst_n),
  .hrst_n               (),
  .clk                  (clk_500m),
  .hclk                 (),
  .i_start              (start),
  .o_finish             (finish),

  //config
  .DATA_NUM                 (DATA_NUM     ),
  .RD_START_ADDR            (RD_START_ADDR),
  .RD_END_ADDR              (RD_END_ADDR  ),
  .WR_START_ADDR            (WR_START_ADDR),
  .WR_END_ADDR              (WR_END_ADDR  ),
  .i_is_real                (1'b0),
  .i_dc_est_cmp_cnt         ('d511),
  .i_dc_est_chp_cnt         ('d63),
  .i_dc_est_frm_cnt         ('d0),
  .i_dc_est_scale           ('d65536),
  .i_dc_config_mode         ('h00),
  .i_intf_est_scale         ('d80000),
  .i_intf_config_mode       ('h00),
  .i_combination_config_mode('h00),

  //DC_estimation
  // .i_dc_u                 ({16'd538,16'd538}),
  .i_dc_u                 ({16'd118,16'd420}),//complex
  .o_dc_u                 (),

  //INTF_estimation
  // .i_intf_cmp             (16'd657),
  .i_intf_cmp             (32'd25000),//complex
  .o_intf_cmp             (),

  //phase_gen: AHB to RAM
  .i_phase_entry_select     ('h10),
  .i_phase_w                ('h02000200),
  .i_phase_coe              (),
  
  .i_phase_ram0_addra       (s_addr),
  .i_phase_ram0_bwea        (),
  .i_phase_ram0_ena         (data1_vld),
  .i_phase_ram0_dina        (data1),
  .o_phase_ram0_douta       (),
  .i_phase_ram0_wena        (data1_vld),

  .i_phase_ram1_addra       (s_addr2),
  .i_phase_ram1_bwea        (),
  .i_phase_ram1_ena         (data2_vld),
  .i_phase_ram1_dina        (data2),
  .o_phase_ram1_douta       (),
  .i_phase_ram1_wena        (data2_vld), 

  .i_data_formatter         ('d0),

  .m_axi_rd             (m_axi_rd),
  .m_axi_wr             (m_axi_wr)
);

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s2_prep/txt_file2/XW.txt"),
  .cnt_data        (CNT_DATA),
  .packet_select   (PACKET_SELECT)
) u_XW(
  .rst_n    (rst_n),
  .clk      (clk_500m),
  .valid    (o_m1_wr_en),
  .data     (o_m1_wr_data)
);


//******************** End_chirp_processing_top ********************//


//******************** wrapper ********************//

always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    mem_req_ack <= 0;
  end
  else begin
    if(mem_req)
      mem_req_ack <= 1;
    else
      mem_req_ack <= 0;
  end
end
always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    done_ack <= 0;
  end
  else begin
    if(done)
      done_ack <= 1;
    else
      done_ack <= 0;
  end
end

//******************** end_wrapper ********************//









//******************** phase_ram ********************//

initial begin
    $readmemh("/home/users/yuyushan/work/rsp_s2_prep/twiddle/twiddle_1024x64.txt", mem_1024x64);
end
initial begin
    $readmemh("/home/users/yuyushan/work/rsp_s2_prep/twiddle/twiddle_32x32.txt", mem_32x32);
end


//1
always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    data1 <= 128'b0;
    address <= 0;
    data1_vld <= 1'b0;
  end
  else begin
    if(address == 'd130)
      address <= address + 1'b1;
    else if(address < 'd130)begin
      data1 <= mem_1024x64[address];
      address <= address+1;
      data1_vld <= 1'b1;
    end
    else begin
        data1 <= data1;
        data1_vld <= 0;
    end
  end
end
assign s_addr = address - 1;

//2
always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    data2 <= 128'b0;
    address2 <= 0;
    data2_vld <= 1'b0;
  end
  else begin
    if(address2 < 'd32)begin
      data2 <= mem_32x32[address2];
      address2 <= address2 + 1;
      data2_vld <= 1'b1;
    end
    else begin
        data2 <= data2;
        data2_vld <= 0;
    end
  end
end
assign s_addr2 = address2 - 1;

//3
rd_txt_data_tb #(
  .CODE_RUN_CNT     (50),
  .DATA_WIDTH       (128),
  .DATA_NUM         (1024),
  .FILE_ADDR        ("/home/users/yuyushan/work/rsp_s2_prep/rsp_s2_prep_sim/input_data/rsp_s1_op_mst_a_0.txt"),
  .DELAY_BIT_DEPTH  (0),
  .DELAY_DATA_DEPTH (0),
  .DELAY_ADDR_DEPTH (0)
) u_rd_txt_data_tb(
  .clk        (clk_500m),
  .rst_n      (rst_n),
  .rd_en      (o_m0_rd_en), //input
  .rd_data    (data3),
  .rd_valid   (),
  .rd_addr    ()
);


//******************** End_phase_ram ********************//



//fsdbDump
initial begin 
    $fsdbDumpfile("tb_common_wave.fsdb");
    $fsdbDumpvars(0,commmon_tb);
    $fsdbDumpMDA();
end

endmodule