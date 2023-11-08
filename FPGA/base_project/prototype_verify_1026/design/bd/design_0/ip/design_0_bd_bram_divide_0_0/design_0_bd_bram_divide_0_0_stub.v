// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Sep 11 12:02:59 2023
// Host        : DESKTOP-1U5KA9Q running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/work/debug_2021/RCI_Yu_0907_rst_test/design/bd/design_0/ip/design_0_bd_bram_divide_0_0/design_0_bd_bram_divide_0_0_stub.v
// Design      : design_0_bd_bram_divide_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "bd_bram_divide,Vivado 2021.1" *)
module design_0_bd_bram_divide_0_0(bram_addr_a, bram_clk_a, bram_wrdata_a, 
  bram_rddata_a, bram_en_a, bram_rst_a, bram_we_a, bram_addr_0, bram_clk_0, bram_wrdata_0, 
  bram_en_0, bram_rst_0, bram_we_0, bram_addr_1, bram_clk_1, bram_wrdata_1, bram_rddata_1, 
  bram_en_1, bram_rst_1, bram_we_1)
/* synthesis syn_black_box black_box_pad_pin="bram_addr_a[12:0],bram_clk_a,bram_wrdata_a[31:0],bram_rddata_a[31:0],bram_en_a,bram_rst_a,bram_we_a[3:0],bram_addr_0[12:0],bram_clk_0,bram_wrdata_0[31:0],bram_en_0,bram_rst_0,bram_we_0[3:0],bram_addr_1[12:0],bram_clk_1,bram_wrdata_1[31:0],bram_rddata_1[31:0],bram_en_1,bram_rst_1,bram_we_1[3:0]" */;
  input [12:0]bram_addr_a;
  input bram_clk_a;
  input [31:0]bram_wrdata_a;
  output [31:0]bram_rddata_a;
  input bram_en_a;
  input bram_rst_a;
  input [3:0]bram_we_a;
  output [12:0]bram_addr_0;
  output bram_clk_0;
  output [31:0]bram_wrdata_0;
  output bram_en_0;
  output bram_rst_0;
  output [3:0]bram_we_0;
  output [12:0]bram_addr_1;
  output bram_clk_1;
  output [31:0]bram_wrdata_1;
  input [31:0]bram_rddata_1;
  output bram_en_1;
  output bram_rst_1;
  output [3:0]bram_we_1;
endmodule
