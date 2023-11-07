// Purpose     : Stub declaration of top-level module interface
// Device      : xczu47dr-fsve1156-2-i
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "mult_gen_v12_0_16,Vivado 2020.2" *)
module gain_block_1(CLK, A, B, CE, P)
/* synthesis syn_black_box black_box_pad_pin="CLK,A[19:0],B[15:0],CE,P[19:0]" */;
  input CLK;
  input [19:0]A;
  input [15:0]B;
  input CE;
  output [19:0]P;
endmodule
