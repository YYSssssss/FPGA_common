// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Mon Sep 11 12:02:59 2023
// Host        : DESKTOP-1U5KA9Q running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               c:/work/debug_2021/RCI_Yu_0907_rst_test/design/bd/design_0/ip/design_0_bd_bram_divide_0_0/design_0_bd_bram_divide_0_0_sim_netlist.v
// Design      : design_0_bd_bram_divide_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "design_0_bd_bram_divide_0_0,bd_bram_divide,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* IP_DEFINITION_SOURCE = "module_ref" *) 
(* X_CORE_INFO = "bd_bram_divide,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module design_0_bd_bram_divide_0_0
   (bram_addr_a,
    bram_clk_a,
    bram_wrdata_a,
    bram_rddata_a,
    bram_en_a,
    bram_rst_a,
    bram_we_a,
    bram_addr_0,
    bram_clk_0,
    bram_wrdata_0,
    bram_en_0,
    bram_rst_0,
    bram_we_0,
    bram_addr_1,
    bram_clk_1,
    bram_wrdata_1,
    bram_rddata_1,
    bram_en_1,
    bram_rst_1,
    bram_we_1);
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

  wire [12:0]bram_addr_a;
  wire bram_clk_a;
  wire bram_en_a;
  wire [31:0]bram_rddata_1;
  wire bram_rst_a;
  wire [3:0]bram_we_a;
  wire [31:0]bram_wrdata_a;

  assign bram_addr_0[12:0] = bram_addr_a;
  assign bram_addr_1[12:0] = bram_addr_a;
  assign bram_clk_0 = bram_clk_a;
  assign bram_clk_1 = bram_clk_a;
  assign bram_en_0 = bram_en_a;
  assign bram_en_1 = bram_en_a;
  assign bram_rddata_a[31:0] = bram_rddata_1;
  assign bram_rst_0 = bram_rst_a;
  assign bram_rst_1 = bram_rst_a;
  assign bram_we_0[3:0] = bram_we_a;
  assign bram_we_1[3:0] = bram_we_a;
  assign bram_wrdata_0[31:0] = bram_wrdata_a;
  assign bram_wrdata_1[31:0] = bram_wrdata_a;
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
