// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Sep 11 11:57:26 2023
// Host        : DESKTOP-1U5KA9Q running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/work/debug_2021/RCI_Yu_0907_rst_test/design/bd/design_0/ip/design_0_ila_0_0/design_0_ila_0_0_stub.v
// Design      : design_0_ila_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "ila,Vivado 2021.1" *)
module design_0_ila_0_0(clk, probe0, probe1, probe2)
/* synthesis syn_black_box black_box_pad_pin="clk,probe0[31:0],probe1[0:0],probe2[3:0]" */;
  input clk;
  input [31:0]probe0;
  input [0:0]probe1;
  input [3:0]probe2;
endmodule
