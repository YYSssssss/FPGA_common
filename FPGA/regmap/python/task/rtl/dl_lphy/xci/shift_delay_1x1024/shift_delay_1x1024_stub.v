// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Thu Sep 16 13:39:22 2021
// Host        : DESKTOP-VS8LBFE running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               e:/Work/TDD/Drop_0_4_1/FPGA/design/rtl/dl_lphy/xci/shift_delay_1x1024/shift_delay_1x1024_stub.v
// Design      : shift_delay_1x1024
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu47dr-fsve1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "c_shift_ram_v12_0_14,Vivado 2020.2" *)
module shift_delay_1x1024(D, CLK, Q)
/* synthesis syn_black_box black_box_pad_pin="D[0:0],CLK,Q[0:0]" */;
  input [0:0]D;
  input CLK;
  output [0:0]Q;
endmodule
