// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Apr 12 16:21:18 2024
// Host        : DESKTOP-KHT2SE1 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               d:/yuganwei/fpga_sim/IIC_sim/design/ir_mem_config/ir_mem_config_stub.v
// Design      : ir_mem_config
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *)
module ir_mem_config(clka, ena, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,ena,wea[0:0],addra[5:0],dina[31:0],douta[31:0]" */;
  input clka;
  input ena;
  input [0:0]wea;
  input [5:0]addra;
  input [31:0]dina;
  output [31:0]douta;
endmodule
