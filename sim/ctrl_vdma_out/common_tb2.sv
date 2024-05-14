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


#100 
rst_n=1;


#250000
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

//initial begin
//    $readmemh("/home/users/yuyushan/work/rsp_s1_prep/twiddle/twiddle_txt.txt", mem_1024x64);
//end
//initial begin
//    $readmemh("/home/users/yuyushan/work/rsp_s1_prep/twiddle/twiddle_32x32.txt", mem_32x32);
//end


//1
//always@(posedge clk_100m or negedge rst_n)begin
//  if(rst_n == 1'b0)begin
//    data1 <= 128'b0;
//    address <= 0;
//    data1_vld <= 1'b0;
//  end
//  else begin
//    if(address == 'd130)
//      address <= address + 1'b1;
//    else if(address < 'd130 && ctrl_read_data_tw)begin
//      data1 <= mem_1024x64[address];
//      address <= address+1;
//      data1_vld <= 1'b1;
//    end
//    else begin
//        data1 <= data1;
//        data1_vld <= 0;
//    end
//  end
//end
//assign s_addr = address - 1;

////2
//always@(posedge clk_100m or negedge rst_n)begin
//  if(rst_n == 1'b0)begin
//    data2 <= 128'b0;
//    address2 <= 0;
//    data2_vld <= 1'b0;
//  end
//  else begin
//    if(address2 < 'd32 && ctrl_read_data_et)begin
//      data2 <= mem_32x32[address2];
//      address2 <= address2 + 1;
//      data2_vld <= 1'b1;
//    end
//    else begin
//        data2 <= data2;
//        data2_vld <= 0;
//    end
//  end
//end
//assign s_addr2 = address2 - 1;

//3
logic  [63 : 0]         video_tdata  ;
logic                   video_tvalid ;
logic                   video_tready ;
logic                   video_tuser  ;
logic                   video_tlast  ;
logic                   video_clk    ;
  
rd_txt_data_tb #(
  .CODE_RUN_CNT     (50),
  .DATA_WIDTH       (128),
  .DATA_NUM         (1024),
  .FILE_ADDR        (),
  .DELAY_BIT_DEPTH  (0),
  .DELAY_DATA_DEPTH (0),
  .DELAY_ADDR_DEPTH (0),
  .CFG_X_NUM        (3840),
  .CFG_Y_NUM        (2160),
  .VEDIO_DATA_WIDTH (64)  
) u_rd_txt_data_tb(
  .clk        (clk_200m),
  .rst_n      (rst_n   ),
  .rd_en      (),
  .rd_data    (),
  .rd_valid   (),
  .rd_addr    (),
  
  .video_tdata  (video_tdata ),
  .video_tvalid (video_tvalid),
  .video_tready (video_tready),
  .video_tuser  (video_tuser ),
  .video_tlast  (video_tlast ),
  .video_clk    (video_clk   )
);


//******************** End ********************//


//******************** TOP ********************//
//task automatic ahb_cfg6_write (int addr,data);
//  begin
//    ahb_cfg.hsel     = 1;
//    ahb_cfg.htrans   = 2'd2;
//    ahb_cfg.haddr    = addr;
//    ahb_cfg.hsize    = 2'd2;
//    ahb_cfg.hburst   = 1'd0;
//    ahb_cfg.hwdata   = data;
//    @(posedge clk_100m);
//    ahb_cfg.hwrite   = 1;
//    ahb_cfg.hreadyin = 0;
//    ahb_cfg.htrans   = 'd2;
//    ahb_cfg.haddr    = addr;
//    ahb_cfg.hsize    = 'd2;
//    ahb_cfg.hburst   = 0;
//    ahb_cfg.hwdata   = data;
//    @(posedge clk_100m);
//    ahb_cfg.hwrite   = 0;
//    ahb_cfg.hreadyin = 1;
//    ahb_cfg.haddr    = 0;
//    ahb_cfg.htrans   = 0;
//    ahb_cfg.hsize    = 0;
//    @(posedge clk_100m);
//  end
//endtask

//task automatic ahb_cfg7_write (int addr,data);
//  begin
//    ahb_cfg.hsel     = 1;
//    ahb_cfg.htrans   = 2'd2;
//    ahb_cfg.haddr    = addr;
//    ahb_cfg.hsize    = 2'd2;
//    ahb_cfg.hburst   = 1'd0;
//    ahb_cfg.hwdata   = data;
//    @(posedge clk_100m);
//    ahb_cfg.hwrite   = 1;
//    ahb_cfg.hreadyin = 0;
//    ahb_cfg.htrans   = 'd2;
//    ahb_cfg.haddr    = addr;
//    ahb_cfg.hsize    = 'd2;
//    ahb_cfg.hburst   = 0;
//    ahb_cfg.hwdata   = data;
//    @(posedge clk_100m);
//    ahb_cfg.hwrite   = 0;
//    ahb_cfg.hreadyin = 1;
//    ahb_cfg.haddr    = 0;
//    ahb_cfg.htrans   = 0;
//    ahb_cfg.hsize    = 0;
//    @(posedge clk_100m);
//  end
//endtask


Ctrl_vdma_out u_Ctrl_vdma_out(
    .s_axis_aclk         (clk_200m),
    .s_axis_aresetn      (rst_n),
    
    .vdma_row            ('d2320),
    .tlast_time          ('d50  ),
    .frame_end_time      ('d2000),
    
    .s_axis_mm2s_tdata   (),//(video_tdata        ),
    .s_axis_mm2s_tlast   (),//(video_tlast        ),
    .s_axis_mm2s_tready  (),//(video_tready       ),
    .s_axis_mm2s_tuser   (),//(video_tuser        ),
    .s_axis_mm2s_tvalid  (),//(video_tvalid       ),
    
    .m_axis_mm2s_tdata   (),
    .m_axis_mm2s_tlast   (),
    .m_axis_mm2s_tready  (1'b1),
    .m_axis_mm2s_tuser   (),
    .m_axis_mm2s_tvalid  ()    
);

vdma_ctrl_v2 u_Ctrl_vdma_out2(
    .s_axis_aclk         (clk_200m),
    .s_axis_aresetn      (rst_n),
    
    .vdma_row            ('d2320),
    .tlast_time          ('d500  ),
    .frame_end_time      ('d2000),
    
    .s_axis_mm2s_tdata   (video_tdata        ),
    .s_axis_mm2s_tlast   (video_tlast        ),
    .s_axis_mm2s_tready  (video_tready       ),
    .s_axis_mm2s_tuser   (video_tuser        ),
    .s_axis_mm2s_tvalid  (video_tvalid       ),
    
    .m_axis_mm2s_tdata   (),
    .m_axis_mm2s_tlast   (),
    .m_axis_mm2s_tready  (1'b1),
    .m_axis_mm2s_tuser   (),
    .m_axis_mm2s_tvalid  ()    
);








//******************** End ********************//



//fsdbDump
//initial begin 
//    $fsdbDumpfile("tb_common_wave.fsdb");
//    $fsdbDumpvars(0,commmon_tb,"+all");
//    $fsdbDumpMDA();
//end

endmodule