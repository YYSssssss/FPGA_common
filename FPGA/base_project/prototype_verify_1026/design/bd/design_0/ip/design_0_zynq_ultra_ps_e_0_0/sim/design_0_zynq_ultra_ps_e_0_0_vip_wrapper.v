 








// (c) Copyright 1995-2017 Xilinx, Inc. All rights reserved.
// 
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
// 
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
// 
// DO NOT MODIFY THIS FILE.

`timescale 1ns/1ps

module design_0_zynq_ultra_ps_e_0_0 (
maxihpm0_fpd_aclk, 
maxigp0_awid, 
maxigp0_awaddr, 
maxigp0_awlen, 
maxigp0_awsize, 
maxigp0_awburst, 
maxigp0_awlock, 
maxigp0_awcache, 
maxigp0_awprot, 
maxigp0_awvalid, 
maxigp0_awuser, 
maxigp0_awready, 
maxigp0_wdata, 
maxigp0_wstrb, 
maxigp0_wlast, 
maxigp0_wvalid, 
maxigp0_wready, 
maxigp0_bid, 
maxigp0_bresp, 
maxigp0_bvalid, 
maxigp0_bready, 
maxigp0_arid, 
maxigp0_araddr, 
maxigp0_arlen, 
maxigp0_arsize, 
maxigp0_arburst, 
maxigp0_arlock, 
maxigp0_arcache, 
maxigp0_arprot, 
maxigp0_arvalid, 
maxigp0_aruser, 
maxigp0_arready, 
maxigp0_rid, 
maxigp0_rdata, 
maxigp0_rresp, 
maxigp0_rlast, 
maxigp0_rvalid, 
maxigp0_rready, 
maxigp0_awqos, 
maxigp0_arqos, 
saxihp0_fpd_aclk, 
saxigp2_aruser, 
saxigp2_awuser, 
saxigp2_awid, 
saxigp2_awaddr, 
saxigp2_awlen, 
saxigp2_awsize, 
saxigp2_awburst, 
saxigp2_awlock, 
saxigp2_awcache, 
saxigp2_awprot, 
saxigp2_awvalid, 
saxigp2_awready, 
saxigp2_wdata, 
saxigp2_wstrb, 
saxigp2_wlast, 
saxigp2_wvalid, 
saxigp2_wready, 
saxigp2_bid, 
saxigp2_bresp, 
saxigp2_bvalid, 
saxigp2_bready, 
saxigp2_arid, 
saxigp2_araddr, 
saxigp2_arlen, 
saxigp2_arsize, 
saxigp2_arburst, 
saxigp2_arlock, 
saxigp2_arcache, 
saxigp2_arprot, 
saxigp2_arvalid, 
saxigp2_arready, 
saxigp2_rid, 
saxigp2_rdata, 
saxigp2_rresp, 
saxigp2_rlast, 
saxigp2_rvalid, 
saxigp2_rready, 
saxigp2_awqos, 
saxigp2_arqos, 
saxihp1_fpd_aclk, 
saxigp3_aruser, 
saxigp3_awuser, 
saxigp3_awid, 
saxigp3_awaddr, 
saxigp3_awlen, 
saxigp3_awsize, 
saxigp3_awburst, 
saxigp3_awlock, 
saxigp3_awcache, 
saxigp3_awprot, 
saxigp3_awvalid, 
saxigp3_awready, 
saxigp3_wdata, 
saxigp3_wstrb, 
saxigp3_wlast, 
saxigp3_wvalid, 
saxigp3_wready, 
saxigp3_bid, 
saxigp3_bresp, 
saxigp3_bvalid, 
saxigp3_bready, 
saxigp3_arid, 
saxigp3_araddr, 
saxigp3_arlen, 
saxigp3_arsize, 
saxigp3_arburst, 
saxigp3_arlock, 
saxigp3_arcache, 
saxigp3_arprot, 
saxigp3_arvalid, 
saxigp3_arready, 
saxigp3_rid, 
saxigp3_rdata, 
saxigp3_rresp, 
saxigp3_rlast, 
saxigp3_rvalid, 
saxigp3_rready, 
saxigp3_awqos, 
saxigp3_arqos, 
emio_enet0_enet_tsu_timer_cnt, 
emio_gpio_i, 
emio_gpio_o, 
emio_gpio_t, 
emio_i2c0_scl_i, 
emio_i2c0_scl_o, 
emio_i2c0_scl_t, 
emio_i2c0_sda_i, 
emio_i2c0_sda_o, 
emio_i2c0_sda_t, 
emio_spi0_sclk_i, 
emio_spi0_sclk_o, 
emio_spi0_sclk_t, 
emio_spi0_m_i, 
emio_spi0_m_o, 
emio_spi0_mo_t, 
emio_spi0_s_i, 
emio_spi0_s_o, 
emio_spi0_so_t, 
emio_spi0_ss_i_n, 
emio_spi0_ss_o_n, 
emio_spi0_ss_n_t, 
dp_aux_data_in, 
dp_aux_data_out, 
dp_aux_data_oe_n, 
dp_hot_plug_detect, 
pl_ps_irq0, 
pl_ps_irq1, 
pl_resetn0, 
pl_clk0, 
pl_clk1, 
pl_clk2 
);
input maxihpm0_fpd_aclk;
output [15 : 0] maxigp0_awid;
output [39 : 0] maxigp0_awaddr;
output [7 : 0] maxigp0_awlen;
output [2 : 0] maxigp0_awsize;
output [1 : 0] maxigp0_awburst;
output maxigp0_awlock;
output [3 : 0] maxigp0_awcache;
output [2 : 0] maxigp0_awprot;
output maxigp0_awvalid;
output [15 : 0] maxigp0_awuser;
input maxigp0_awready;
output [127 : 0] maxigp0_wdata;
output [15 : 0] maxigp0_wstrb;
output maxigp0_wlast;
output maxigp0_wvalid;
input maxigp0_wready;
input [15 : 0] maxigp0_bid;
input [1 : 0] maxigp0_bresp;
input maxigp0_bvalid;
output maxigp0_bready;
output [15 : 0] maxigp0_arid;
output [39 : 0] maxigp0_araddr;
output [7 : 0] maxigp0_arlen;
output [2 : 0] maxigp0_arsize;
output [1 : 0] maxigp0_arburst;
output maxigp0_arlock;
output [3 : 0] maxigp0_arcache;
output [2 : 0] maxigp0_arprot;
output maxigp0_arvalid;
output [15 : 0] maxigp0_aruser;
input maxigp0_arready;
input [15 : 0] maxigp0_rid;
input [127 : 0] maxigp0_rdata;
input [1 : 0] maxigp0_rresp;
input maxigp0_rlast;
input maxigp0_rvalid;
output maxigp0_rready;
output [3 : 0] maxigp0_awqos;
output [3 : 0] maxigp0_arqos;
input saxihp0_fpd_aclk;
input saxigp2_aruser;
input saxigp2_awuser;
input [5 : 0] saxigp2_awid;
input [48 : 0] saxigp2_awaddr;
input [7 : 0] saxigp2_awlen;
input [2 : 0] saxigp2_awsize;
input [1 : 0] saxigp2_awburst;
input saxigp2_awlock;
input [3 : 0] saxigp2_awcache;
input [2 : 0] saxigp2_awprot;
input saxigp2_awvalid;
output saxigp2_awready;
input [127 : 0] saxigp2_wdata;
input [15 : 0] saxigp2_wstrb;
input saxigp2_wlast;
input saxigp2_wvalid;
output saxigp2_wready;
output [5 : 0] saxigp2_bid;
output [1 : 0] saxigp2_bresp;
output saxigp2_bvalid;
input saxigp2_bready;
input [5 : 0] saxigp2_arid;
input [48 : 0] saxigp2_araddr;
input [7 : 0] saxigp2_arlen;
input [2 : 0] saxigp2_arsize;
input [1 : 0] saxigp2_arburst;
input saxigp2_arlock;
input [3 : 0] saxigp2_arcache;
input [2 : 0] saxigp2_arprot;
input saxigp2_arvalid;
output saxigp2_arready;
output [5 : 0] saxigp2_rid;
output [127 : 0] saxigp2_rdata;
output [1 : 0] saxigp2_rresp;
output saxigp2_rlast;
output saxigp2_rvalid;
input saxigp2_rready;
input [3 : 0] saxigp2_awqos;
input [3 : 0] saxigp2_arqos;
input saxihp1_fpd_aclk;
input saxigp3_aruser;
input saxigp3_awuser;
input [5 : 0] saxigp3_awid;
input [48 : 0] saxigp3_awaddr;
input [7 : 0] saxigp3_awlen;
input [2 : 0] saxigp3_awsize;
input [1 : 0] saxigp3_awburst;
input saxigp3_awlock;
input [3 : 0] saxigp3_awcache;
input [2 : 0] saxigp3_awprot;
input saxigp3_awvalid;
output saxigp3_awready;
input [127 : 0] saxigp3_wdata;
input [15 : 0] saxigp3_wstrb;
input saxigp3_wlast;
input saxigp3_wvalid;
output saxigp3_wready;
output [5 : 0] saxigp3_bid;
output [1 : 0] saxigp3_bresp;
output saxigp3_bvalid;
input saxigp3_bready;
input [5 : 0] saxigp3_arid;
input [48 : 0] saxigp3_araddr;
input [7 : 0] saxigp3_arlen;
input [2 : 0] saxigp3_arsize;
input [1 : 0] saxigp3_arburst;
input saxigp3_arlock;
input [3 : 0] saxigp3_arcache;
input [2 : 0] saxigp3_arprot;
input saxigp3_arvalid;
output saxigp3_arready;
output [5 : 0] saxigp3_rid;
output [127 : 0] saxigp3_rdata;
output [1 : 0] saxigp3_rresp;
output saxigp3_rlast;
output saxigp3_rvalid;
input saxigp3_rready;
input [3 : 0] saxigp3_awqos;
input [3 : 0] saxigp3_arqos;
output [93 : 0] emio_enet0_enet_tsu_timer_cnt;
input [14 : 0] emio_gpio_i;
output [14 : 0] emio_gpio_o;
output [14 : 0] emio_gpio_t;
input emio_i2c0_scl_i;
output emio_i2c0_scl_o;
output emio_i2c0_scl_t;
input emio_i2c0_sda_i;
output emio_i2c0_sda_o;
output emio_i2c0_sda_t;
input emio_spi0_sclk_i;
output emio_spi0_sclk_o;
output emio_spi0_sclk_t;
input emio_spi0_m_i;
output emio_spi0_m_o;
output emio_spi0_mo_t;
input emio_spi0_s_i;
output emio_spi0_s_o;
output emio_spi0_so_t;
input emio_spi0_ss_i_n;
output emio_spi0_ss_o_n;
output emio_spi0_ss_n_t;
input dp_aux_data_in;
output dp_aux_data_out;
output dp_aux_data_oe_n;
input dp_hot_plug_detect;
input [5 : 0] pl_ps_irq0;
input [5 : 0] pl_ps_irq1;
output pl_resetn0;
output pl_clk0;
output pl_clk1;
output pl_clk2;
wire pl_clk_t[3:0] ;

wire saxihpc0_fpd_rclk_temp;
wire saxihpc0_fpd_wclk_temp;
wire saxihpc1_fpd_rclk_temp;
wire saxihpc1_fpd_wclk_temp;
wire saxihp0_fpd_rclk_temp;
wire saxihp0_fpd_wclk_temp;
wire saxihp1_fpd_rclk_temp;
wire saxihp1_fpd_wclk_temp;
wire saxihp2_fpd_rclk_temp;
wire saxihp2_fpd_wclk_temp;
wire saxihp3_fpd_rclk_temp;
wire saxihp3_fpd_wclk_temp;
wire saxi_lpd_rclk_temp;
wire saxi_lpd_wclk_temp;


assign pl_clk0 = pl_clk_t[0] ;

 assign pl_clk1 = pl_clk_t[1] ;

assign pl_clk2 = pl_clk_t[2] ;

 assign  pl_clk3 = 1'b0 ;

  
   
    assign saxihp0_fpd_rclk_temp  =  saxihp0_fpd_aclk ;
	assign saxihp0_fpd_wclk_temp  =  saxihp0_fpd_aclk ;
   
    assign saxihp1_fpd_rclk_temp  =  saxihp1_fpd_aclk ;
	assign saxihp1_fpd_wclk_temp  =  saxihp1_fpd_aclk ;
   
   
   


  


  zynq_ultra_ps_e_vip_v1_0_10 #(
    .C_USE_M_AXI_GP0(1),
    .C_USE_M_AXI_GP1(0),
    .C_USE_M_AXI_GP2(0),
    .C_USE_S_AXI_GP0(0),
    .C_USE_S_AXI_GP1(0),
    .C_USE_S_AXI_GP2(1),
    .C_USE_S_AXI_GP3(1),
    .C_USE_S_AXI_GP4(0),
    .C_USE_S_AXI_GP5(0),
    .C_USE_S_AXI_GP6(0),
    .C_USE_S_AXI_ACP(0),
    .C_USE_S_AXI_ACE(0),
    .C_M_AXI_GP0_DATA_WIDTH(128),
    .C_M_AXI_GP1_DATA_WIDTH(128),
    .C_M_AXI_GP2_DATA_WIDTH(32),
    .C_S_AXI_GP0_DATA_WIDTH(128),
    .C_S_AXI_GP1_DATA_WIDTH(128),
    .C_S_AXI_GP2_DATA_WIDTH(128),
    .C_S_AXI_GP3_DATA_WIDTH(128),
    .C_S_AXI_GP4_DATA_WIDTH(64),
    .C_S_AXI_GP5_DATA_WIDTH(128),
    .C_S_AXI_GP6_DATA_WIDTH(128),
    .C_FCLK_CLK0_FREQ(200.000000),
    .C_FCLK_CLK1_FREQ(200.000000),
    .C_FCLK_CLK2_FREQ(23.809525),
    .C_FCLK_CLK3_FREQ(100)
  ) inst (
    .MAXIGP0ARVALID(maxigp0_arvalid),
    .MAXIGP0AWVALID(maxigp0_awvalid),
    .MAXIGP0BREADY(maxigp0_bready),
    .MAXIGP0RREADY(maxigp0_rready),
    .MAXIGP0WLAST(maxigp0_wlast),
    .MAXIGP0WVALID(maxigp0_wvalid),
    .MAXIGP0ARID(maxigp0_arid),
    .MAXIGP0ARUSER(maxigp0_aruser),
    .MAXIGP0AWID(maxigp0_awid),
    .MAXIGP0ARBURST(maxigp0_arburst),
    .MAXIGP0ARLOCK(maxigp0_arlock),
    .MAXIGP0ARSIZE(maxigp0_arsize),
    .MAXIGP0AWBURST(maxigp0_awburst),
    .MAXIGP0AWLOCK(maxigp0_awlock),
    .MAXIGP0AWSIZE(maxigp0_awsize),
    .MAXIGP0ARPROT(maxigp0_arprot),
    .MAXIGP0AWPROT(maxigp0_awprot),
    .MAXIGP0ARADDR(maxigp0_araddr),
    .MAXIGP0AWADDR(maxigp0_awaddr),
    .MAXIGP0WDATA(maxigp0_wdata),
    .MAXIGP0AWUSER(maxigp0_awuser),
    .MAXIGP0ARCACHE(maxigp0_arcache),
    .MAXIGP0ARLEN(maxigp0_arlen),
    .MAXIGP0ARQOS(maxigp0_arqos),
    .MAXIGP0AWCACHE(maxigp0_awcache),
    .MAXIGP0AWLEN(maxigp0_awlen),
    .MAXIGP0AWQOS(maxigp0_awqos),
    .MAXIGP0WSTRB(maxigp0_wstrb),
    .MAXIGP0ACLK(maxihpm0_fpd_aclk),
    .MAXIGP0ARREADY(maxigp0_arready),
    .MAXIGP0AWREADY(maxigp0_awready),
    .MAXIGP0BVALID(maxigp0_bvalid),
    .MAXIGP0RLAST(maxigp0_rlast),
    .MAXIGP0RVALID(maxigp0_rvalid),
    .MAXIGP0WREADY(maxigp0_wready),
    .MAXIGP0BID(maxigp0_bid),
    .MAXIGP0RID(maxigp0_rid),
    .MAXIGP0BRESP(maxigp0_bresp),
    .MAXIGP0RRESP(maxigp0_rresp),
    .MAXIGP0RDATA(maxigp0_rdata),
    .MAXIGP1ARVALID(),
    .MAXIGP1AWVALID(),
    .MAXIGP1BREADY(),
    .MAXIGP1RREADY(),
    .MAXIGP1WLAST(),
    .MAXIGP1WVALID(),
    .MAXIGP1ARID(),
    .MAXIGP1ARUSER(),
    .MAXIGP1AWID(),
    .MAXIGP1ARBURST(),
    .MAXIGP1ARLOCK(),
    .MAXIGP1ARSIZE(),
    .MAXIGP1AWBURST(),
    .MAXIGP1AWLOCK(),
    .MAXIGP1AWSIZE(),
    .MAXIGP1ARPROT(),
    .MAXIGP1AWPROT(),
    .MAXIGP1ARADDR(),
    .MAXIGP1AWADDR(),
    .MAXIGP1WDATA(),
    .MAXIGP1AWUSER(),
    .MAXIGP1ARCACHE(),
    .MAXIGP1ARLEN(),
    .MAXIGP1ARQOS(),
    .MAXIGP1AWCACHE(),
    .MAXIGP1AWLEN(),
    .MAXIGP1AWQOS(),
    .MAXIGP1WSTRB(),
    .MAXIGP1ACLK(1'B0),
    .MAXIGP1ARREADY(1'B0),
    .MAXIGP1AWREADY(1'B0),
    .MAXIGP1BVALID(1'B0),
    .MAXIGP1RLAST(1'B0),
    .MAXIGP1RVALID(1'B0),
    .MAXIGP1WREADY(1'B0),
    .MAXIGP1BID(12'B0),
    .MAXIGP1RID(12'B0),
    .MAXIGP1BRESP(2'B0),
    .MAXIGP1RRESP(2'B0),
    .MAXIGP1RDATA(32'B0),

    .MAXIGP2ARVALID(),
    .MAXIGP2AWVALID(),
    .MAXIGP2BREADY(),
    .MAXIGP2RREADY(),
    .MAXIGP2WLAST(),
    .MAXIGP2WVALID(),
    .MAXIGP2ARID(),
    .MAXIGP2ARUSER(),
    .MAXIGP2AWID(),
    .MAXIGP2ARBURST(),
    .MAXIGP2ARLOCK(),
    .MAXIGP2ARSIZE(),
    .MAXIGP2AWBURST(),
    .MAXIGP2AWLOCK(),
    .MAXIGP2AWSIZE(),
    .MAXIGP2ARPROT(),
    .MAXIGP2AWPROT(),
    .MAXIGP2ARADDR(),
    .MAXIGP2AWADDR(),
    .MAXIGP2WDATA(),
    .MAXIGP2AWUSER(),
    .MAXIGP2ARCACHE(),
    .MAXIGP2ARLEN(),
    .MAXIGP2ARQOS(),
    .MAXIGP2AWCACHE(),
    .MAXIGP2AWLEN(),
    .MAXIGP2AWQOS(),
    .MAXIGP2WSTRB(),
    .MAXIGP2ACLK(),
    .MAXIGP2ARREADY(1'B0),
    .MAXIGP2AWREADY(1'B0),
    .MAXIGP2BVALID(1'B0),
    .MAXIGP2RLAST(1'B0),
    .MAXIGP2RVALID(1'B0),
    .MAXIGP2WREADY(1'B0),
    .MAXIGP2BID(12'B0),
    .MAXIGP2RID(12'B0),
    .MAXIGP2BRESP(2'B0),
    .MAXIGP2RRESP(2'B0),
    .MAXIGP2RDATA(32'B0),
    .SAXIGP0RCLK(),
    .SAXIGP0WCLK(),
    .SAXIGP0ARUSER(),
    .SAXIGP0AWUSER(),
    .SAXIGP0RACOUNT(),
    .SAXIGP0WACOUNT(),
    .SAXIGP0RCOUNT(),
    .SAXIGP0WCOUNT(),
    .SAXIGP0ARREADY(),
    .SAXIGP0AWREADY(),
    .SAXIGP0BVALID(),
    .SAXIGP0RLAST(),
    .SAXIGP0RVALID(),
    .SAXIGP0WREADY(),
    .SAXIGP0BRESP(),
    .SAXIGP0RRESP(),
    .SAXIGP0RDATA(),
    .SAXIGP0BID(),
    .SAXIGP0RID(),
    .SAXIGP0ARVALID(1'B0),
    .SAXIGP0AWVALID(1'B0),
    .SAXIGP0BREADY(1'B0),
    .SAXIGP0RREADY(1'B0),
    .SAXIGP0WLAST(1'B0),
    .SAXIGP0WVALID(1'B0),
    .SAXIGP0ARBURST(2'B0),
    .SAXIGP0ARLOCK(2'B0),
    .SAXIGP0ARSIZE(3'B0),
    .SAXIGP0AWBURST(2'B0),
    .SAXIGP0AWLOCK(2'B0),
    .SAXIGP0AWSIZE(3'B0),
    .SAXIGP0ARPROT(3'B0),
    .SAXIGP0AWPROT(3'B0),
    .SAXIGP0ARADDR(32'B0),
    .SAXIGP0AWADDR(32'B0),
    .SAXIGP0WDATA(32'B0),
    .SAXIGP0ARCACHE(4'B0),
    .SAXIGP0ARLEN(4'B0),
    .SAXIGP0ARQOS(4'B0),
    .SAXIGP0AWCACHE(4'B0),
    .SAXIGP0AWLEN(4'B0),
    .SAXIGP0AWQOS(4'B0),
    .SAXIGP0WSTRB(4'B0),
    .SAXIGP0ARID(6'B0),
    .SAXIGP0AWID(6'B0),
    .SAXIGP1RCLK(),
    .SAXIGP1WCLK(),
    .SAXIGP1ARUSER(),
    .SAXIGP1AWUSER(),
    .SAXIGP1RACOUNT(),
    .SAXIGP1WACOUNT(),
    .SAXIGP1RCOUNT(),
    .SAXIGP1WCOUNT(),
    .SAXIGP1ARREADY(),
    .SAXIGP1AWREADY(),
    .SAXIGP1BVALID(),
    .SAXIGP1RLAST(),
    .SAXIGP1RVALID(),
    .SAXIGP1WREADY(),
    .SAXIGP1BRESP(),
    .SAXIGP1RRESP(),
    .SAXIGP1RDATA(),
    .SAXIGP1BID(),
    .SAXIGP1RID(),
    .SAXIGP1ARVALID(1'B0),
    .SAXIGP1AWVALID(1'B0),
    .SAXIGP1BREADY(1'B0),
    .SAXIGP1RREADY(1'B0),
    .SAXIGP1WLAST(1'B0),
    .SAXIGP1WVALID(1'B0),
    .SAXIGP1ARBURST(2'B0),
    .SAXIGP1ARLOCK(2'B0),
    .SAXIGP1ARSIZE(3'B0),
    .SAXIGP1AWBURST(2'B0),
    .SAXIGP1AWLOCK(2'B0),
    .SAXIGP1AWSIZE(3'B0),
    .SAXIGP1ARPROT(3'B0),
    .SAXIGP1AWPROT(3'B0),
    .SAXIGP1ARADDR(32'B0),
    .SAXIGP1AWADDR(32'B0),
    .SAXIGP1WDATA(32'B0),
    .SAXIGP1ARCACHE(4'B0),
    .SAXIGP1ARLEN(4'B0),
    .SAXIGP1ARQOS(4'B0),
    .SAXIGP1AWCACHE(4'B0),
    .SAXIGP1AWLEN(4'B0),
    .SAXIGP1AWQOS(4'B0),
    .SAXIGP1WSTRB(4'B0),
    .SAXIGP1ARID(6'B0),
    .SAXIGP1AWID(6'B0),
    .SAXIGP2RCLK(saxihp0_fpd_rclk_temp),
    .SAXIGP2WCLK(saxihp0_fpd_wclk_temp),
    .SAXIGP2ARUSER(saxigp2_aruser),
    .SAXIGP2AWUSER(saxigp2_awuser),
    .SAXIGP2RACOUNT(saxigp2_racount),
    .SAXIGP2WACOUNT(saxigp2_wacount),
    .SAXIGP2RCOUNT(saxigp2_rcount),
    .SAXIGP2WCOUNT(saxigp2_wcount),
    .SAXIGP2ARREADY(saxigp2_arready),
    .SAXIGP2AWREADY(saxigp2_awready),
    .SAXIGP2BVALID(saxigp2_bvalid),
    .SAXIGP2RLAST(saxigp2_rlast),
    .SAXIGP2RVALID(saxigp2_rvalid),
    .SAXIGP2WREADY(saxigp2_wready),
    .SAXIGP2BRESP(saxigp2_bresp),
    .SAXIGP2RRESP(saxigp2_rresp),
    .SAXIGP2RDATA(saxigp2_rdata),
    .SAXIGP2BID(saxigp2_bid),
    .SAXIGP2RID(saxigp2_rid),
    .SAXIGP2ARVALID(saxigp2_arvalid),
    .SAXIGP2AWVALID(saxigp2_awvalid),
    .SAXIGP2BREADY(saxigp2_bready),
    .SAXIGP2RREADY(saxigp2_rready),
    .SAXIGP2WLAST(saxigp2_wlast),
    .SAXIGP2WVALID(saxigp2_wvalid),
    .SAXIGP2ARBURST(saxigp2_arburst),
    .SAXIGP2ARLOCK(saxigp2_arlock),
    .SAXIGP2ARSIZE(saxigp2_arsize),
    .SAXIGP2AWBURST(saxigp2_awburst),
    .SAXIGP2AWLOCK(saxigp2_awlock),
    .SAXIGP2AWSIZE(saxigp2_awsize),
    .SAXIGP2ARPROT(saxigp2_arprot),
    .SAXIGP2AWPROT(saxigp2_awprot),
    .SAXIGP2ARADDR(saxigp2_araddr),
    .SAXIGP2AWADDR(saxigp2_awaddr),
    .SAXIGP2WDATA(saxigp2_wdata),
    .SAXIGP2ARCACHE(saxigp2_arcache),
    .SAXIGP2ARLEN(saxigp2_arlen),
    .SAXIGP2ARQOS(saxigp2_arqos),
    .SAXIGP2AWCACHE(saxigp2_awcache),
    .SAXIGP2AWLEN(saxigp2_awlen),
    .SAXIGP2AWQOS(saxigp2_awqos),
    .SAXIGP2WSTRB(saxigp2_wstrb),
    .SAXIGP2ARID(saxigp2_arid),
    .SAXIGP2AWID(saxigp2_awid),
    .SAXIGP3RCLK(saxihp1_fpd_rclk_temp),
    .SAXIGP3WCLK(saxihp1_fpd_wclk_temp),
    .SAXIGP3ARUSER(saxigp3_aruser),
    .SAXIGP3AWUSER(saxigp3_awuser),
    .SAXIGP3RACOUNT(saxigp3_racount),
    .SAXIGP3WACOUNT(saxigp3_wacount),
    .SAXIGP3RCOUNT(saxigp3_rcount),
    .SAXIGP3WCOUNT(saxigp3_wcount),
    .SAXIGP3ARREADY(saxigp3_arready),
    .SAXIGP3AWREADY(saxigp3_awready),
    .SAXIGP3BVALID(saxigp3_bvalid),
    .SAXIGP3RLAST(saxigp3_rlast),
    .SAXIGP3RVALID(saxigp3_rvalid),
    .SAXIGP3WREADY(saxigp3_wready),
    .SAXIGP3BRESP(saxigp3_bresp),
    .SAXIGP3RRESP(saxigp3_rresp),
    .SAXIGP3RDATA(saxigp3_rdata),
    .SAXIGP3BID(saxigp3_bid),
    .SAXIGP3RID(saxigp3_rid),
    .SAXIGP3ARVALID(saxigp3_arvalid),
    .SAXIGP3AWVALID(saxigp3_awvalid),
    .SAXIGP3BREADY(saxigp3_bready),
    .SAXIGP3RREADY(saxigp3_rready),
    .SAXIGP3WLAST(saxigp3_wlast),
    .SAXIGP3WVALID(saxigp3_wvalid),
    .SAXIGP3ARBURST(saxigp3_arburst),
    .SAXIGP3ARLOCK(saxigp3_arlock),
    .SAXIGP3ARSIZE(saxigp3_arsize),
    .SAXIGP3AWBURST(saxigp3_awburst),
    .SAXIGP3AWLOCK(saxigp3_awlock),
    .SAXIGP3AWSIZE(saxigp3_awsize),
    .SAXIGP3ARPROT(saxigp3_arprot),
    .SAXIGP3AWPROT(saxigp3_awprot),
    .SAXIGP3ARADDR(saxigp3_araddr),
    .SAXIGP3AWADDR(saxigp3_awaddr),
    .SAXIGP3WDATA(saxigp3_wdata),
    .SAXIGP3ARCACHE(saxigp3_arcache),
    .SAXIGP3ARLEN(saxigp3_arlen),
    .SAXIGP3ARQOS(saxigp3_arqos),
    .SAXIGP3AWCACHE(saxigp3_awcache),
    .SAXIGP3AWLEN(saxigp3_awlen),
    .SAXIGP3AWQOS(saxigp3_awqos),
    .SAXIGP3WSTRB(saxigp3_wstrb),
    .SAXIGP3ARID(saxigp3_arid),
    .SAXIGP3AWID(saxigp3_awid),
    .SAXIGP4RCLK(),
    .SAXIGP4WCLK(),
    .SAXIGP4ARUSER(),
    .SAXIGP4AWUSER(),
    .SAXIGP4RACOUNT(),
    .SAXIGP4WACOUNT(),
    .SAXIGP4RCOUNT(),
    .SAXIGP4WCOUNT(),
    .SAXIGP4ARREADY(),
    .SAXIGP4AWREADY(),
    .SAXIGP4BVALID(),
    .SAXIGP4RLAST(),
    .SAXIGP4RVALID(),
    .SAXIGP4WREADY(),
    .SAXIGP4BRESP(),
    .SAXIGP4RRESP(),
    .SAXIGP4RDATA(),
    .SAXIGP4BID(),
    .SAXIGP4RID(),
    .SAXIGP4ARVALID(1'B0),
    .SAXIGP4AWVALID(1'B0),
    .SAXIGP4BREADY(1'B0),
    .SAXIGP4RREADY(1'B0),
    .SAXIGP4WLAST(1'B0),
    .SAXIGP4WVALID(1'B0),
    .SAXIGP4ARBURST(2'B0),
    .SAXIGP4ARLOCK(2'B0),
    .SAXIGP4ARSIZE(3'B0),
    .SAXIGP4AWBURST(2'B0),
    .SAXIGP4AWLOCK(2'B0),
    .SAXIGP4AWSIZE(3'B0),
    .SAXIGP4ARPROT(3'B0),
    .SAXIGP4AWPROT(3'B0),
    .SAXIGP4ARADDR(32'B0),
    .SAXIGP4AWADDR(32'B0),
    .SAXIGP4WDATA(32'B0),
    .SAXIGP4ARCACHE(4'B0),
    .SAXIGP4ARLEN(4'B0),
    .SAXIGP4ARQOS(4'B0),
    .SAXIGP4AWCACHE(4'B0),
    .SAXIGP4AWLEN(4'B0),
    .SAXIGP4AWQOS(4'B0),
    .SAXIGP4WSTRB(4'B0),
    .SAXIGP4ARID(6'B0),
    .SAXIGP4AWID(6'B0),
    .SAXIGP5RCLK(),
    .SAXIGP5WCLK(),
    .SAXIGP5ARUSER(),
    .SAXIGP5AWUSER(),
    .SAXIGP5RACOUNT(),
    .SAXIGP5WACOUNT(),
    .SAXIGP5RCOUNT(),
    .SAXIGP5WCOUNT(),
    .SAXIGP5ARREADY(),
    .SAXIGP5AWREADY(),
    .SAXIGP5BVALID(),
    .SAXIGP5RLAST(),
    .SAXIGP5RVALID(),
    .SAXIGP5WREADY(),
    .SAXIGP5BRESP(),
    .SAXIGP5RRESP(),
    .SAXIGP5RDATA(),
    .SAXIGP5BID(),
    .SAXIGP5RID(),
    .SAXIGP5ARVALID(1'B0),
    .SAXIGP5AWVALID(1'B0),
    .SAXIGP5BREADY(1'B0),
    .SAXIGP5RREADY(1'B0),
    .SAXIGP5WLAST(1'B0),
    .SAXIGP5WVALID(1'B0),
    .SAXIGP5ARBURST(2'B0),
    .SAXIGP5ARLOCK(2'B0),
    .SAXIGP5ARSIZE(3'B0),
    .SAXIGP5AWBURST(2'B0),
    .SAXIGP5AWLOCK(2'B0),
    .SAXIGP5AWSIZE(3'B0),
    .SAXIGP5ARPROT(3'B0),
    .SAXIGP5AWPROT(3'B0),
    .SAXIGP5ARADDR(32'B0),
    .SAXIGP5AWADDR(32'B0),
    .SAXIGP5WDATA(32'B0),
    .SAXIGP5ARCACHE(4'B0),
    .SAXIGP5ARLEN(4'B0),
    .SAXIGP5ARQOS(4'B0),
    .SAXIGP5AWCACHE(4'B0),
    .SAXIGP5AWLEN(4'B0),
    .SAXIGP5AWQOS(4'B0),
    .SAXIGP5WSTRB(4'B0),
    .SAXIGP5ARID(6'B0),
    .SAXIGP5AWID(6'B0),
    .SAXIGP6RCLK(),
    .SAXIGP6WCLK(),
    .SAXIGP6ARUSER(),
    .SAXIGP6AWUSER(),
    .SAXIGP6RACOUNT(),
    .SAXIGP6WACOUNT(),
    .SAXIGP6RCOUNT(),
    .SAXIGP6WCOUNT(),
    .SAXIGP6ARREADY(),
    .SAXIGP6AWREADY(),
    .SAXIGP6BVALID(),
    .SAXIGP6RLAST(),
    .SAXIGP6RVALID(),
    .SAXIGP6WREADY(),
    .SAXIGP6BRESP(),
    .SAXIGP6RRESP(),
    .SAXIGP6RDATA(),
    .SAXIGP6BID(),
    .SAXIGP6RID(),
    .SAXIGP6ARVALID(1'B0),
    .SAXIGP6AWVALID(1'B0),
    .SAXIGP6BREADY(1'B0),
    .SAXIGP6RREADY(1'B0),
    .SAXIGP6WLAST(1'B0),
    .SAXIGP6WVALID(1'B0),
    .SAXIGP6ARBURST(2'B0),
    .SAXIGP6ARLOCK(2'B0),
    .SAXIGP6ARSIZE(3'B0),
    .SAXIGP6AWBURST(2'B0),
    .SAXIGP6AWLOCK(2'B0),
    .SAXIGP6AWSIZE(3'B0),
    .SAXIGP6ARPROT(3'B0),
    .SAXIGP6AWPROT(3'B0),
    .SAXIGP6ARADDR(32'B0),
    .SAXIGP6AWADDR(32'B0),
    .SAXIGP6WDATA(32'B0),
    .SAXIGP6ARCACHE(4'B0),
    .SAXIGP6ARLEN(4'B0),
    .SAXIGP6ARQOS(4'B0),
    .SAXIGP6AWCACHE(4'B0),
    .SAXIGP6AWLEN(4'B0),
    .SAXIGP6AWQOS(4'B0),
    .SAXIGP6WSTRB(4'B0),
    .SAXIGP6ARID(6'B0),
    .SAXIGP6AWID(6'B0),
    .SAXIACPARREADY(),
    .SAXIACPAWREADY(),
    .SAXIACPBVALID(),
    .SAXIACPRLAST(),
    .SAXIACPRVALID(),
    .SAXIACPWREADY(),
    .SAXIACPBRESP(),
    .SAXIACPRRESP(),
    .SAXIACPBID(),
    .SAXIACPRID(),
    .SAXIACPRDATA(),
    .SAXIACPACLK(1'B0),
    .SAXIACPARVALID(1'B0),
    .SAXIACPAWVALID(1'B0),
    .SAXIACPBREADY(1'B0),
    .SAXIACPRREADY(1'B0),
    .SAXIACPWLAST(1'B0),
    .SAXIACPWVALID(1'B0),
    .SAXIACPARID(3'B0),
    .SAXIACPARPROT(3'B0),
    .SAXIACPAWID(3'B0),
    .SAXIACPAWPROT(3'B0),
    .SAXIACPARADDR(32'B0),
    .SAXIACPAWADDR(32'B0),
    .SAXIACPARCACHE(4'B0),
    .SAXIACPARLEN(4'B0),
    .SAXIACPARQOS(4'B0),
    .SAXIACPAWCACHE(4'B0),
    .SAXIACPAWLEN(4'B0),
    .SAXIACPAWQOS(4'B0),
    .SAXIACPARBURST(2'B0),
    .SAXIACPARLOCK(2'B0),
    .SAXIACPARSIZE(3'B0),
    .SAXIACPAWBURST(2'B0),
    .SAXIACPAWLOCK(2'B0),
    .SAXIACPAWSIZE(3'B0),
    .SAXIACPARUSER(5'B0),
    .SAXIACPAWUSER(5'B0),
    .SAXIACPWDATA(64'B0),
    .SAXIACPWSTRB(8'B0),
.SACEFPDACREADY(),       
.SACEFPDARLOCK(),
.SACEFPDARVALID(),
.SACEFPDAWLOCK(),
.SACEFPDAWVALID(),
.SACEFPDBREADY(),
.SACEFPDCDLAST(),
.SACEFPDCDVALID(),
.SACEFPDCRVALID(),
.SACEFPDRACK(),
.SACEFPDRREADY(),
.SACEFPDWACK(),
.SACEFPDWLAST(),
.SACEFPDWUSER(),
.SACEFPDWVALID(),
.SACEFPDCDDATA(),
.SACEFPDWDATA(),
.SACEFPDARUSER(),
.SACEFPDAWUSER(),
.SACEFPDWSTRB(),
.SACEFPDARBAR(),
.SACEFPDARBURST(),
.SACEFPDARDOMAIN(),
.SACEFPDAWBAR(),
.SACEFPDAWBURST(),
.SACEFPDAWDOMAIN(),
.SACEFPDARPROT(),
.SACEFPDARSIZE(),
.SACEFPDAWPROT(),
.SACEFPDAWSIZE(),
.SACEFPDAWSNOOP(),
.SACEFPDARCACHE(),
.SACEFPDARQOS(),
.SACEFPDARREGION(),
.SACEFPDARSNOOP(),
.SACEFPDAWCACHE(),
.SACEFPDAWQOS(),
.SACEFPDAWREGION(),
.SACEFPDARADDR(),
.SACEFPDAWADDR(),
.SACEFPDCRRESP(),
.SACEFPDARID(),
.SACEFPDAWID(),
.SACEFPDARLEN(),
.SACEFPDAWLEN(),
.SACEFPDACVALID(),
.SACEFPDARREADY(),
.SACEFPDAWREADY(),
.SACEFPDBUSER(),
.SACEFPDBVALID(),
.SACEFPDCDREADY(),
.SACEFPDCRREADY(),
.SACEFPDRLAST(),
.SACEFPDRUSER(),
.SACEFPDRVALID(),
.SACEFPDWREADY(),
.SACEFPDRDATA(),
.SACEFPDBRESP(),
.SACEFPDACPROT(),
.SACEFPDACSNOOP(),
.SACEFPDRRESP(),
.SACEFPDACADDR(),
.SACEFPDBID(),
.SACEFPDRID(),

.PLPSIRQ0(pl_ps_irq0),
.PLPSIRQ1(pl_ps_irq1), 

.PL_RESETN0(pl_resetn0),
.PLCLK({pl_clk_t[3],pl_clk_t[2],pl_clk_t[1],pl_clk_t[0]})
  );

endmodule
