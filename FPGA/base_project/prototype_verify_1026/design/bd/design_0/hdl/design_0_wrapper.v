//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
//Date        : Mon Oct 30 21:03:36 2023
//Host        : localhost.localdomain running 64-bit unknown
//Command     : generate_target design_0_wrapper.bd
//Design      : design_0_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_0_wrapper
   (IFP_TEST_CTRL_araddr,
    IFP_TEST_CTRL_arprot,
    IFP_TEST_CTRL_arready,
    IFP_TEST_CTRL_arvalid,
    IFP_TEST_CTRL_awaddr,
    IFP_TEST_CTRL_awprot,
    IFP_TEST_CTRL_awready,
    IFP_TEST_CTRL_awvalid,
    IFP_TEST_CTRL_bready,
    IFP_TEST_CTRL_bresp,
    IFP_TEST_CTRL_bvalid,
    IFP_TEST_CTRL_rdata,
    IFP_TEST_CTRL_rready,
    IFP_TEST_CTRL_rresp,
    IFP_TEST_CTRL_rvalid,
    IFP_TEST_CTRL_wdata,
    IFP_TEST_CTRL_wready,
    IFP_TEST_CTRL_wstrb,
    IFP_TEST_CTRL_wvalid,
    aresetn_100M,
    clk_100M);
  output [31:0]IFP_TEST_CTRL_araddr;
  output [2:0]IFP_TEST_CTRL_arprot;
  input IFP_TEST_CTRL_arready;
  output IFP_TEST_CTRL_arvalid;
  output [31:0]IFP_TEST_CTRL_awaddr;
  output [2:0]IFP_TEST_CTRL_awprot;
  input IFP_TEST_CTRL_awready;
  output IFP_TEST_CTRL_awvalid;
  output IFP_TEST_CTRL_bready;
  input [1:0]IFP_TEST_CTRL_bresp;
  input IFP_TEST_CTRL_bvalid;
  input [31:0]IFP_TEST_CTRL_rdata;
  output IFP_TEST_CTRL_rready;
  input [1:0]IFP_TEST_CTRL_rresp;
  input IFP_TEST_CTRL_rvalid;
  output [31:0]IFP_TEST_CTRL_wdata;
  input IFP_TEST_CTRL_wready;
  output [3:0]IFP_TEST_CTRL_wstrb;
  output IFP_TEST_CTRL_wvalid;
  input aresetn_100M;
  input clk_100M;

  wire [31:0]IFP_TEST_CTRL_araddr;
  wire [2:0]IFP_TEST_CTRL_arprot;
  wire IFP_TEST_CTRL_arready;
  wire IFP_TEST_CTRL_arvalid;
  wire [31:0]IFP_TEST_CTRL_awaddr;
  wire [2:0]IFP_TEST_CTRL_awprot;
  wire IFP_TEST_CTRL_awready;
  wire IFP_TEST_CTRL_awvalid;
  wire IFP_TEST_CTRL_bready;
  wire [1:0]IFP_TEST_CTRL_bresp;
  wire IFP_TEST_CTRL_bvalid;
  wire [31:0]IFP_TEST_CTRL_rdata;
  wire IFP_TEST_CTRL_rready;
  wire [1:0]IFP_TEST_CTRL_rresp;
  wire IFP_TEST_CTRL_rvalid;
  wire [31:0]IFP_TEST_CTRL_wdata;
  wire IFP_TEST_CTRL_wready;
  wire [3:0]IFP_TEST_CTRL_wstrb;
  wire IFP_TEST_CTRL_wvalid;
  wire aresetn_100M;
  wire clk_100M;

  design_0 design_0_i
       (.IFP_TEST_CTRL_araddr(IFP_TEST_CTRL_araddr),
        .IFP_TEST_CTRL_arprot(IFP_TEST_CTRL_arprot),
        .IFP_TEST_CTRL_arready(IFP_TEST_CTRL_arready),
        .IFP_TEST_CTRL_arvalid(IFP_TEST_CTRL_arvalid),
        .IFP_TEST_CTRL_awaddr(IFP_TEST_CTRL_awaddr),
        .IFP_TEST_CTRL_awprot(IFP_TEST_CTRL_awprot),
        .IFP_TEST_CTRL_awready(IFP_TEST_CTRL_awready),
        .IFP_TEST_CTRL_awvalid(IFP_TEST_CTRL_awvalid),
        .IFP_TEST_CTRL_bready(IFP_TEST_CTRL_bready),
        .IFP_TEST_CTRL_bresp(IFP_TEST_CTRL_bresp),
        .IFP_TEST_CTRL_bvalid(IFP_TEST_CTRL_bvalid),
        .IFP_TEST_CTRL_rdata(IFP_TEST_CTRL_rdata),
        .IFP_TEST_CTRL_rready(IFP_TEST_CTRL_rready),
        .IFP_TEST_CTRL_rresp(IFP_TEST_CTRL_rresp),
        .IFP_TEST_CTRL_rvalid(IFP_TEST_CTRL_rvalid),
        .IFP_TEST_CTRL_wdata(IFP_TEST_CTRL_wdata),
        .IFP_TEST_CTRL_wready(IFP_TEST_CTRL_wready),
        .IFP_TEST_CTRL_wstrb(IFP_TEST_CTRL_wstrb),
        .IFP_TEST_CTRL_wvalid(IFP_TEST_CTRL_wvalid),
        .aresetn_100M(aresetn_100M),
        .clk_100M(clk_100M));
endmodule
