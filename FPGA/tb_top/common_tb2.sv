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
`include "rsp_common_defines.vh"
`include "rsp_s1_prep_defines.vh"
`include "rsp_s1_op_info.svh"

module commmon_tb;

/////////////////////////// parameter ////////////////////////////
parameter abs_width = 16;
parameter READ_RAM_WIDTH = 128;
parameter SAMPLE_WIDTH   = 32;
parameter READ_DATA_NUM  = 1024;


/////////////////////////// logic ////////////////////////////
//clk & rstn
logic rst_n;
logic clk_12p5m;
logic clk_25m;
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

logic                                       pos_d0         ;
logic                                       pos_d1         ;
logic                                       pos            ;
logic                                       i_cmd_req        ;
rsp_s1_cmd_info_t                           i_cmd_info       ;  
logic                                       o_cmd_ack        ;
logic [`RSP_S1_OP_NUM-1:0]                  i_start_req_op   ; 
rsp_s1_start_info_t [`RSP_S1_OP_NUM-1:0]    i_start_info_op  ;
logic                                       o_start_ack      ;  
logic                                       o_finish_req     ;  
rsp_s1_finish_info_t                        o_finish_info    ;  
logic [`RSP_S1_OP_NUM-1:0]                  i_finish_ack_op  ; 
logic                                       i_init           ;      
logic                                       i_reset          ;    
logic                                       i_stop           ;     
logic                                       i_rerun          ;    
logic                                       o_mem_req        ;     
logic [`L1_BANK_NUM-1:0]                    o_mem_bm         ;        
logic                                       i_mem_ack        ;     

logic [`L1_DATA_WIDTH-1:0]    i_m0_rd_data_A;
logic                         o_m0_rd_en_A;
logic [`L1_ADDR_WIDTH-1:0]    o_m0_rd_addr_A;
logic [`L1_STRB_WIDTH-1:0]    o_m1_wea_A;
logic [`L1_DATA_WIDTH-1:0]    o_m1_wr_data_A;
logic                         o_m1_wr_en_A;
logic [`L1_ADDR_WIDTH-1:0]    o_m1_wr_addr_A;
logic [`L1_DATA_WIDTH-1:0]    i_m0_rd_data_B;
logic                         o_m0_rd_en_B;
logic [`L1_ADDR_WIDTH-1:0]    o_m0_rd_addr_B;
logic [`L1_STRB_WIDTH-1:0]    o_m1_wea_B;
logic [`L1_DATA_WIDTH-1:0]    o_m1_wr_data_B;
logic                         o_m1_wr_en_B;
logic [`L1_ADDR_WIDTH-1:0]    o_m1_wr_addr_B;
logic                         o_finish;

ahb_if_cfg #(.AHB_WDW(32), .AHB_RDW(32), .AHB_AW(32)) ahb_cfg();

integer cnt_test0;
integer cnt_test_i;
logic ctrl_read_data_tw;
logic ctrl_read_data_et;
logic op_prepare_ready;

///////////////////////////////////////////////////////

initial begin
#0  
rst_n=0;
clk=0;
clk_12p5m=0;
clk_50m=0;
clk_75m=0;
clk_100m=0;
clk_150m=0;
clk_200m=0;
clk_250m=0;
clk_300m=0;
clk_400m=0;
clk_500m=0;

i_cmd_req=0;
i_start_req_op   = {{0,0},{0,0}};
i_finish_ack_op  = 0; 
i_init = 0;
i_reset = 0;
i_stop = 0;
i_rerun = 0;
i_mem_ack = 0;

ctrl_read_data_tw = 0;
ahb_cfg.hsel     = 1;
ahb_cfg.hreadyin = 1;
ahb_cfg.hwdata   = 0;
ahb_cfg.haddr    = 0;
ahb_cfg.htrans   = 0;
ahb_cfg.hburst   = 0;
ahb_cfg.hsize    = 0;
ahb_cfg.hwrite   = 0;
op_prepare_ready = 0;


#100 
rst_n=1;
@(posedge clk_100m);
ahb_cfg.hreadyin = 0;
@(posedge clk_100m);
ahb_cfg.hreadyin = 1;
@(posedge clk_100m);
ahb_cfg.hreadyin = 0;

#10
ctrl_read_data_tw = 0;
@(posedge clk_100m);
ctrl_read_data_tw = 1;
@(posedge clk_100m);
ctrl_read_data_tw = 0;
for (integer i = 0;i < 136;i = i + 1) begin
  @(posedge clk_100m);
  ctrl_read_data_tw = 0;
  @(posedge clk_100m)
  ahb_cfg6_write({32'h1400},data1[63:32]);
  ahb_cfg6_write({32'h1400},data1[31:0]);
  @(posedge clk_100m);
  ctrl_read_data_tw = 1;
end
@(posedge clk_100m);
ctrl_read_data_tw = 0;


ahb_cfg.hsel     = 1;
ahb_cfg.hreadyin = 0;
ahb_cfg.hwdata   = 0;
ahb_cfg.haddr    = 0;
ahb_cfg.htrans   = 0;
ahb_cfg.hburst   = 0;
ahb_cfg.hsize    = 0;
ahb_cfg.hwrite   = 0;
op_prepare_ready = 0;

ctrl_read_data_et = 0;
@(posedge clk_100m);
ctrl_read_data_et = 1;
@(posedge clk_100m);
ctrl_read_data_et = 0;
for (integer i = 0;i < 32;i = i + 1) begin
  @(posedge clk_100m);
  ctrl_read_data_et = 0;
  @(posedge clk_100m)
  ahb_cfg7_write({32'h1800},data2[31:0]);
  @(posedge clk_100m);
  ctrl_read_data_et = 1;
end
@(posedge clk_100m);
ctrl_read_data_et = 0;


#10
op_prepare_ready = 1;

#25000
// $stop;
$finish;
end

always #1  clk      = ~clk; // 200M
always #40   clk_12p5m  = ~clk_12p5m;  // 12.5M
always #10   clk_50m  = ~clk_50m;  // 50M
always #6.67 clk_75m  = ~clk_75m;  // 75M
always #5    clk_100m = ~clk_100m; // 100M
always #3.33 clk_150m = ~clk_150m; // 150M
always #2.5  clk_200m = ~clk_200m; // 200M
always #2    clk_250m = ~clk_250m; // 250M
always #1.67 clk_300m = ~clk_300m; // 300M
always #1.25 clk_400m = ~clk_400m; // 400M
always #1    clk_500m = ~clk_500m; // 500M












//******************** phase_ram ********************//

initial begin
    $readmemh("/home/users/yuyushan/work/rsp_s1_prep/twiddle/twiddle_txt.txt", mem_1024x64);
end
initial begin
    $readmemh("/home/users/yuyushan/work/rsp_s1_prep/twiddle/twiddle_32x32.txt", mem_32x32);
end


//1
always@(posedge clk_100m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    data1 <= 128'b0;
    address <= 0;
    data1_vld <= 1'b0;
  end
  else begin
    if(address == 'd130)
      address <= address + 1'b1;
    else if(address < 'd130 && ctrl_read_data_tw)begin
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
always@(posedge clk_100m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    data2 <= 128'b0;
    address2 <= 0;
    data2_vld <= 1'b0;
  end
  else begin
    if(address2 < 'd32 && ctrl_read_data_et)begin
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
  .FILE_ADDR        ("/home/users/yuyushan/work/rsp_s1_prep/rsp_s1_prep_sim/input_data/rsp_s1_op_mst_a_1.txt"),
  // .FILE_ADDR        ("/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/verif/rsp_s2_prep/sim/run/tl_rsp_s2_prep_normal_rsp_s2_prep_test_0_0_100/rsp_s2_prep_in_0.txt"),
  // .FILE_ADDR        ("/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/verif/rsp_s1_prep/sim/run/tl_rsp_s1_prep_normal_rsp_s1_prep_test_0_0_1115/rsp_s1_op_mst_a_0.txt"),
  // .FILE_ADDR        ("/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/verif/rsp_s1_prep/sim/run/tl_rsp_s1_prep_normal_rsp_s1_prep_test_0_0_861239/rsp_s1_op_mst_a_321.txt"),
  .DELAY_BIT_DEPTH  (0),
  .DELAY_DATA_DEPTH (0),
  .DELAY_ADDR_DEPTH (0)
) u_rd_txt_data_tb(
  .clk        (clk_200m),
  .rst_n      (rst_n),
  .rd_en      (o_m0_rd_en_A), //input
  .rd_data    (i_m0_rd_data_A),
  .rd_valid   (),
  .rd_addr    ()
);
//******************** End_phase_ram ********************//


//******************** prep_wrapper ********************//
// assign ahb_cfg.hreadyin = ahb_cfg.hready;
task automatic ahb_cfg6_write (int addr,data);
  begin
    ahb_cfg.hsel     = 1;
    ahb_cfg.htrans   = 2'd2;
    ahb_cfg.haddr    = addr;
    ahb_cfg.hsize    = 2'd2;
    ahb_cfg.hburst   = 1'd0;
    ahb_cfg.hwdata   = data;
    @(posedge clk_100m);
    ahb_cfg.hwrite   = 1;
    ahb_cfg.hreadyin = 0;
    ahb_cfg.htrans   = 'd2;
    ahb_cfg.haddr    = addr;
    ahb_cfg.hsize    = 'd2;
    ahb_cfg.hburst   = 0;
    ahb_cfg.hwdata   = data;
    @(posedge clk_100m);
    ahb_cfg.hwrite   = 0;
    ahb_cfg.hreadyin = 1;
    ahb_cfg.haddr    = 0;
    ahb_cfg.htrans   = 0;
    ahb_cfg.hsize    = 0;
    @(posedge clk_100m);
  end
endtask

task automatic ahb_cfg7_write (int addr,data);
  begin
    ahb_cfg.hsel     = 1;
    ahb_cfg.htrans   = 2'd2;
    ahb_cfg.haddr    = addr;
    ahb_cfg.hsize    = 2'd2;
    ahb_cfg.hburst   = 1'd0;
    ahb_cfg.hwdata   = data;
    @(posedge clk_100m);
    ahb_cfg.hwrite   = 1;
    ahb_cfg.hreadyin = 0;
    ahb_cfg.htrans   = 'd2;
    ahb_cfg.haddr    = addr;
    ahb_cfg.hsize    = 'd2;
    ahb_cfg.hburst   = 0;
    ahb_cfg.hwdata   = data;
    @(posedge clk_100m);
    ahb_cfg.hwrite   = 0;
    ahb_cfg.hreadyin = 1;
    ahb_cfg.haddr    = 0;
    ahb_cfg.htrans   = 0;
    ahb_cfg.hsize    = 0;
    @(posedge clk_100m);
  end
endtask


task automatic ahb_cfg_read (int addr);
  begin
    
  end
endtask

always@(posedge clk_200m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    pos_d0 <= 0;
    pos_d1 <= 0;
  end
  else begin
    pos_d0 <= op_prepare_ready;
    pos_d1 <= pos_d0;
  end
end
assign pos = pos_d0 & ~pos_d1;


always@(posedge clk_200m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    i_cmd_req <= 0;
  end
  else begin
    if(o_cmd_ack)
      i_cmd_req <= 0;
    else if(pos)
      i_cmd_req <= 1;
  end
end

always@(posedge clk_200m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    i_start_req_op <= 0;
  end
  else begin
    if(o_cmd_ack)
      i_start_req_op <= 1;
    else if(pos)
      i_start_req_op <= 0;
    else if(o_start_ack)
      i_start_req_op <= 0;
  end
end
assign i_cmd_info = '{'d0,'d1,'d2,'d1};
assign i_start_info_op = '{{0,0},{0,0},{0,0},{0,0},
                           {0,0},{0,0},{0,0},{0,0},
                           {0,0},{0,0},{0,0},{0,0},
                           {0,0},{0,0},{0,0},{0,2}
                          };

always@(posedge clk_200m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    i_mem_ack <= 0;
  end
  else begin
    if(o_start_ack)
      i_mem_ack <= 1;
    
  end
end

rsp_s1_prep #(
  .RSP_S1_OP_IDX_OPNAME (8)
) u_rsp_s1_prep(
  .rst_n                (rst_n),
  .clk                  (clk_200m),
  .i_cmd_req            (i_cmd_req      ),
  .i_cmd_info           (i_cmd_info     ),
  .o_cmd_ack            (o_cmd_ack      ),
  .i_start_req_op       (i_start_req_op ),
  .i_start_info_op      (i_start_info_op),
  .o_start_ack          (o_start_ack    ),
  .o_finish_req         (o_finish_req   ),
  .o_finish_info        (o_finish_info  ),
  .i_finish_ack_op      (i_finish_ack_op),
  .i_init               (i_init         ),
  .i_reset              (i_reset        ),
  .i_stop               (i_stop         ),
  .i_rerun              (i_rerun        ),
  .o_mem_req            (o_mem_req      ),
  .o_mem_bm             (o_mem_bm       ),
  .i_mem_ack            (i_mem_ack      ),
  .ahb_cfg              (ahb_cfg        ),
  .hclk                 (clk_100m       ),
  .hreset               (~rst_n         ),
  .i_m0_rd_data_A       (i_m0_rd_data_A ),
  .o_m0_rd_en_A         (o_m0_rd_en_A   ),
  .o_m0_rd_addr_A       (o_m0_rd_addr_A ),
  .i_m0_rd_data_B       (),
  .o_m0_rd_en_B         (), 
  .o_m0_rd_addr_B       (),
  .o_m1_wea_A           (o_m1_wea_A    ),
  .o_m1_wr_data_A       (o_m1_wr_data_A),
  .o_m1_wr_en_A         (o_m1_wr_en_A  ),
  .o_m1_wr_addr_A       (o_m1_wr_addr_A),
  .o_m1_wea_B           (),
  .o_m1_wr_data_B       (),
  .o_m1_wr_en_B         (), 
  .o_m1_wr_addr_B       (), 
  .o_event              (),
  .o_irq                ()
);

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (`L1_DATA_WIDTH),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/XW.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (`DEBUG_PACKET_SELECT)
) u_XW(
  .rst_n    (rst_n),
  .clk      (clk_200m),
  .valid    (o_m1_wr_en_A),
  .data     (o_m1_wr_data_A)
);
//******************** End_prep_wrapper ********************//



//fsdbDump
initial begin 
    $fsdbDumpfile("tb_common_wave.fsdb");
    $fsdbDumpvars(0,commmon_tb,"+all");
    $fsdbDumpMDA();
end

endmodule