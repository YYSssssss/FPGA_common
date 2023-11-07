//Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2020.1.1_AR76049 (win64) Build 2960000 Wed Aug  5 22:57:20 MDT 2020
//Date        : Wed Apr 28 18:27:30 2021
//Host        : DESKTOP-VS8LBFE running 64-bit major release  (build 9200)
//Command     : generate_target MINTAKA_wrapper.bd
//Design      : MINTAKA_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module MINTAKA_wrapper
   (GPIO_0_tri_io,
    M00_AXI_TOP_CTRL_CMN_araddr,
    M00_AXI_TOP_CTRL_CMN_arprot,
    M00_AXI_TOP_CTRL_CMN_arready,
    M00_AXI_TOP_CTRL_CMN_arvalid,
    M00_AXI_TOP_CTRL_CMN_awaddr,
    M00_AXI_TOP_CTRL_CMN_awprot,
    M00_AXI_TOP_CTRL_CMN_awready,
    M00_AXI_TOP_CTRL_CMN_awvalid,
    M00_AXI_TOP_CTRL_CMN_bready,
    M00_AXI_TOP_CTRL_CMN_bresp,
    M00_AXI_TOP_CTRL_CMN_bvalid,
    M00_AXI_TOP_CTRL_CMN_rdata,
    M00_AXI_TOP_CTRL_CMN_rready,
    M00_AXI_TOP_CTRL_CMN_rresp,
    M00_AXI_TOP_CTRL_CMN_rvalid,
    M00_AXI_TOP_CTRL_CMN_wdata,
    M00_AXI_TOP_CTRL_CMN_wready,
    M00_AXI_TOP_CTRL_CMN_wstrb,
    M00_AXI_TOP_CTRL_CMN_wvalid,
    M00_AXI_TOP_CTRL_HW_araddr,
    M00_AXI_TOP_CTRL_HW_arprot,
    M00_AXI_TOP_CTRL_HW_arready,
    M00_AXI_TOP_CTRL_HW_arvalid,
    M00_AXI_TOP_CTRL_HW_awaddr,
    M00_AXI_TOP_CTRL_HW_awprot,
    M00_AXI_TOP_CTRL_HW_awready,
    M00_AXI_TOP_CTRL_HW_awvalid,
    M00_AXI_TOP_CTRL_HW_bready,
    M00_AXI_TOP_CTRL_HW_bresp,
    M00_AXI_TOP_CTRL_HW_bvalid,
    M00_AXI_TOP_CTRL_HW_rdata,
    M00_AXI_TOP_CTRL_HW_rready,
    M00_AXI_TOP_CTRL_HW_rresp,
    M00_AXI_TOP_CTRL_HW_rvalid,
    M00_AXI_TOP_CTRL_HW_wdata,
    M00_AXI_TOP_CTRL_HW_wready,
    M00_AXI_TOP_CTRL_HW_wstrb,
    M00_AXI_TOP_CTRL_HW_wvalid,
    M00_AXI_TOP_CTRL_INTR_araddr,
    M00_AXI_TOP_CTRL_INTR_arprot,
    M00_AXI_TOP_CTRL_INTR_arready,
    M00_AXI_TOP_CTRL_INTR_arvalid,
    M00_AXI_TOP_CTRL_INTR_awaddr,
    M00_AXI_TOP_CTRL_INTR_awprot,
    M00_AXI_TOP_CTRL_INTR_awready,
    M00_AXI_TOP_CTRL_INTR_awvalid,
    M00_AXI_TOP_CTRL_INTR_bready,
    M00_AXI_TOP_CTRL_INTR_bresp,
    M00_AXI_TOP_CTRL_INTR_bvalid,
    M00_AXI_TOP_CTRL_INTR_rdata,
    M00_AXI_TOP_CTRL_INTR_rready,
    M00_AXI_TOP_CTRL_INTR_rresp,
    M00_AXI_TOP_CTRL_INTR_rvalid,
    M00_AXI_TOP_CTRL_INTR_wdata,
    M00_AXI_TOP_CTRL_INTR_wready,
    M00_AXI_TOP_CTRL_INTR_wstrb,
    M00_AXI_TOP_CTRL_INTR_wvalid,
    M00_AXI_TOP_CTRL_TEST_araddr,
    M00_AXI_TOP_CTRL_TEST_arprot,
    M00_AXI_TOP_CTRL_TEST_arready,
    M00_AXI_TOP_CTRL_TEST_arvalid,
    M00_AXI_TOP_CTRL_TEST_awaddr,
    M00_AXI_TOP_CTRL_TEST_awprot,
    M00_AXI_TOP_CTRL_TEST_awready,
    M00_AXI_TOP_CTRL_TEST_awvalid,
    M00_AXI_TOP_CTRL_TEST_bready,
    M00_AXI_TOP_CTRL_TEST_bresp,
    M00_AXI_TOP_CTRL_TEST_bvalid,
    M00_AXI_TOP_CTRL_TEST_rdata,
    M00_AXI_TOP_CTRL_TEST_rready,
    M00_AXI_TOP_CTRL_TEST_rresp,
    M00_AXI_TOP_CTRL_TEST_rvalid,
    M00_AXI_TOP_CTRL_TEST_wdata,
    M00_AXI_TOP_CTRL_TEST_wready,
    M00_AXI_TOP_CTRL_TEST_wstrb,
    M00_AXI_TOP_CTRL_TEST_wvalid,
    RF_BRAM_PORTB_addr,
    RF_BRAM_PORTB_clk,
    RF_BRAM_PORTB_din,
    RF_BRAM_PORTB_dout,
    RF_BRAM_PORTB_en,
    RF_BRAM_PORTB_rst,
    RF_BRAM_PORTB_we,
    T224_m00_adc0_i_tdata,
    T224_m00_adc0_i_tready,
    T224_m00_adc0_i_tvalid,
    T224_m01_adc0_q_tdata,
    T224_m01_adc0_q_tready,
    T224_m01_adc0_q_tvalid,
    T224_m02_adc1_i_tdata,
    T224_m02_adc1_i_tready,
    T224_m02_adc1_i_tvalid,
    T224_m03_adc1_q_tdata,
    T224_m03_adc1_q_tready,
    T224_m03_adc1_q_tvalid,
    T225_m10_adc2_i_tdata,
    T225_m10_adc2_i_tready,
    T225_m10_adc2_i_tvalid,
    T225_m11_adc2_q_tdata,
    T225_m11_adc2_q_tready,
    T225_m11_adc2_q_tvalid,
    T225_m12_adc3_i_tdata,
    T225_m12_adc3_i_tready,
    T225_m12_adc3_i_tvalid,
    T225_m13_adc3_q_tdata,
    T225_m13_adc3_q_tready,
    T225_m13_adc3_q_tvalid,
    T226_m20_adc4_i_tdata,
    T226_m20_adc4_i_tready,
    T226_m20_adc4_i_tvalid,
    T226_m21_adc4_q_tdata,
    T226_m21_adc4_q_tready,
    T226_m21_adc4_q_tvalid,
    T226_m22_adc5_i_tdata,
    T226_m22_adc5_i_tready,
    T226_m22_adc5_i_tvalid,
    T226_m23_adc5_q_tdata,
    T226_m23_adc5_q_tready,
    T226_m23_adc5_q_tvalid,
    T227_m30_adc6_i_tdata,
    T227_m30_adc6_i_tready,
    T227_m30_adc6_i_tvalid,
    T227_m31_adc6_q_tdata,
    T227_m31_adc6_q_tready,
    T227_m31_adc6_q_tvalid,
    T227_m32_adc7_i_tdata,
    T227_m32_adc7_i_tready,
    T227_m32_adc7_i_tvalid,
    T227_m33_adc7_q_tdata,
    T227_m33_adc7_q_tready,
    T227_m33_adc7_q_tvalid,
    T228_s00_dac0_tdata,
    T228_s00_dac0_tready,
    T228_s00_dac0_tvalid,
    T228_s02_dac1_tdata,
    T228_s02_dac1_tready,
    T228_s02_dac1_tvalid,
    T229_s10_dac2_tdata,
    T229_s10_dac2_tready,
    T229_s10_dac2_tvalid,
    T229_s12_dac3_tdata,
    T229_s12_dac3_tready,
    T229_s12_dac3_tvalid,
    T230_s20_dac4_tdata,
    T230_s20_dac4_tready,
    T230_s20_dac4_tvalid,
    T230_s22_dac5_tdata,
    T230_s22_dac5_tready,
    T230_s22_dac5_tvalid,
    T231_s30_dac6_tdata,
    T231_s30_dac6_tready,
    T231_s30_dac6_tvalid,
    T231_s32_dac7_tdata,
    T231_s32_dac7_tready,
    T231_s32_dac7_tvalid,
    adc1_clk_clk_n,
    adc1_clk_clk_p,
    adc_over_range,
    adc_over_threshold1,
    adc_over_threshold2,
    adc_over_voltage,
    axi_aresetn_100M,
    axi_clk_100M,
    axis_aresetn,
    clk_122p88,
    clk_15p36,
    clk_245p76,
    clk_368p64,
    clk_491p52,
    dac2_clk_clk_n,
    dac2_clk_clk_p,
    emio_spi0_m_i,
    emio_spi0_m_o,
    emio_spi0_sclk_o,
    emio_spi0_ss_o_n,
    iic_sfp0_scl_io,
    iic_sfp0_sda_io,
    iic_sfp1_scl_io,
    iic_sfp1_sda_io,
    iic_sfp2_scl_io,
    iic_sfp2_sda_io,
    iic_sfp3_scl_io,
    iic_sfp3_sda_io,
    irq_adc_dac,
    pl_ps_irq0,
    pl_ps_irq1,
    pl_refclk1_clk_n,
    pl_refclk1_clk_p,
    pl_refclk1_locked,
    pl_refclk2_clk_n,
    pl_refclk2_clk_p,
    pl_refclk2_locked,
    pl_sysref_clk_n,
    pl_sysref_clk_p,
    sysref_in_diff_n,
    sysref_in_diff_p);
  inout [94:0]GPIO_0_tri_io;
  output [31:0]M00_AXI_TOP_CTRL_CMN_araddr;
  output [2:0]M00_AXI_TOP_CTRL_CMN_arprot;
  input M00_AXI_TOP_CTRL_CMN_arready;
  output M00_AXI_TOP_CTRL_CMN_arvalid;
  output [31:0]M00_AXI_TOP_CTRL_CMN_awaddr;
  output [2:0]M00_AXI_TOP_CTRL_CMN_awprot;
  input M00_AXI_TOP_CTRL_CMN_awready;
  output M00_AXI_TOP_CTRL_CMN_awvalid;
  output M00_AXI_TOP_CTRL_CMN_bready;
  input [1:0]M00_AXI_TOP_CTRL_CMN_bresp;
  input M00_AXI_TOP_CTRL_CMN_bvalid;
  input [31:0]M00_AXI_TOP_CTRL_CMN_rdata;
  output M00_AXI_TOP_CTRL_CMN_rready;
  input [1:0]M00_AXI_TOP_CTRL_CMN_rresp;
  input M00_AXI_TOP_CTRL_CMN_rvalid;
  output [31:0]M00_AXI_TOP_CTRL_CMN_wdata;
  input M00_AXI_TOP_CTRL_CMN_wready;
  output [3:0]M00_AXI_TOP_CTRL_CMN_wstrb;
  output M00_AXI_TOP_CTRL_CMN_wvalid;
  output [31:0]M00_AXI_TOP_CTRL_HW_araddr;
  output [2:0]M00_AXI_TOP_CTRL_HW_arprot;
  input M00_AXI_TOP_CTRL_HW_arready;
  output M00_AXI_TOP_CTRL_HW_arvalid;
  output [31:0]M00_AXI_TOP_CTRL_HW_awaddr;
  output [2:0]M00_AXI_TOP_CTRL_HW_awprot;
  input M00_AXI_TOP_CTRL_HW_awready;
  output M00_AXI_TOP_CTRL_HW_awvalid;
  output M00_AXI_TOP_CTRL_HW_bready;
  input [1:0]M00_AXI_TOP_CTRL_HW_bresp;
  input M00_AXI_TOP_CTRL_HW_bvalid;
  input [31:0]M00_AXI_TOP_CTRL_HW_rdata;
  output M00_AXI_TOP_CTRL_HW_rready;
  input [1:0]M00_AXI_TOP_CTRL_HW_rresp;
  input M00_AXI_TOP_CTRL_HW_rvalid;
  output [31:0]M00_AXI_TOP_CTRL_HW_wdata;
  input M00_AXI_TOP_CTRL_HW_wready;
  output [3:0]M00_AXI_TOP_CTRL_HW_wstrb;
  output M00_AXI_TOP_CTRL_HW_wvalid;
  output [31:0]M00_AXI_TOP_CTRL_INTR_araddr;
  output [2:0]M00_AXI_TOP_CTRL_INTR_arprot;
  input M00_AXI_TOP_CTRL_INTR_arready;
  output M00_AXI_TOP_CTRL_INTR_arvalid;
  output [31:0]M00_AXI_TOP_CTRL_INTR_awaddr;
  output [2:0]M00_AXI_TOP_CTRL_INTR_awprot;
  input M00_AXI_TOP_CTRL_INTR_awready;
  output M00_AXI_TOP_CTRL_INTR_awvalid;
  output M00_AXI_TOP_CTRL_INTR_bready;
  input [1:0]M00_AXI_TOP_CTRL_INTR_bresp;
  input M00_AXI_TOP_CTRL_INTR_bvalid;
  input [31:0]M00_AXI_TOP_CTRL_INTR_rdata;
  output M00_AXI_TOP_CTRL_INTR_rready;
  input [1:0]M00_AXI_TOP_CTRL_INTR_rresp;
  input M00_AXI_TOP_CTRL_INTR_rvalid;
  output [31:0]M00_AXI_TOP_CTRL_INTR_wdata;
  input M00_AXI_TOP_CTRL_INTR_wready;
  output [3:0]M00_AXI_TOP_CTRL_INTR_wstrb;
  output M00_AXI_TOP_CTRL_INTR_wvalid;
  output [31:0]M00_AXI_TOP_CTRL_TEST_araddr;
  output [2:0]M00_AXI_TOP_CTRL_TEST_arprot;
  input M00_AXI_TOP_CTRL_TEST_arready;
  output M00_AXI_TOP_CTRL_TEST_arvalid;
  output [31:0]M00_AXI_TOP_CTRL_TEST_awaddr;
  output [2:0]M00_AXI_TOP_CTRL_TEST_awprot;
  input M00_AXI_TOP_CTRL_TEST_awready;
  output M00_AXI_TOP_CTRL_TEST_awvalid;
  output M00_AXI_TOP_CTRL_TEST_bready;
  input [1:0]M00_AXI_TOP_CTRL_TEST_bresp;
  input M00_AXI_TOP_CTRL_TEST_bvalid;
  input [31:0]M00_AXI_TOP_CTRL_TEST_rdata;
  output M00_AXI_TOP_CTRL_TEST_rready;
  input [1:0]M00_AXI_TOP_CTRL_TEST_rresp;
  input M00_AXI_TOP_CTRL_TEST_rvalid;
  output [31:0]M00_AXI_TOP_CTRL_TEST_wdata;
  input M00_AXI_TOP_CTRL_TEST_wready;
  output [3:0]M00_AXI_TOP_CTRL_TEST_wstrb;
  output M00_AXI_TOP_CTRL_TEST_wvalid;
  input [31:0]RF_BRAM_PORTB_addr;
  input RF_BRAM_PORTB_clk;
  input [63:0]RF_BRAM_PORTB_din;
  output [63:0]RF_BRAM_PORTB_dout;
  input RF_BRAM_PORTB_en;
  input RF_BRAM_PORTB_rst;
  input [7:0]RF_BRAM_PORTB_we;
  output [15:0]T224_m00_adc0_i_tdata;
  input T224_m00_adc0_i_tready;
  output T224_m00_adc0_i_tvalid;
  output [15:0]T224_m01_adc0_q_tdata;
  input T224_m01_adc0_q_tready;
  output T224_m01_adc0_q_tvalid;
  output [15:0]T224_m02_adc1_i_tdata;
  input T224_m02_adc1_i_tready;
  output T224_m02_adc1_i_tvalid;
  output [15:0]T224_m03_adc1_q_tdata;
  input T224_m03_adc1_q_tready;
  output T224_m03_adc1_q_tvalid;
  output [15:0]T225_m10_adc2_i_tdata;
  input T225_m10_adc2_i_tready;
  output T225_m10_adc2_i_tvalid;
  output [15:0]T225_m11_adc2_q_tdata;
  input T225_m11_adc2_q_tready;
  output T225_m11_adc2_q_tvalid;
  output [15:0]T225_m12_adc3_i_tdata;
  input T225_m12_adc3_i_tready;
  output T225_m12_adc3_i_tvalid;
  output [15:0]T225_m13_adc3_q_tdata;
  input T225_m13_adc3_q_tready;
  output T225_m13_adc3_q_tvalid;
  output [15:0]T226_m20_adc4_i_tdata;
  input T226_m20_adc4_i_tready;
  output T226_m20_adc4_i_tvalid;
  output [15:0]T226_m21_adc4_q_tdata;
  input T226_m21_adc4_q_tready;
  output T226_m21_adc4_q_tvalid;
  output [15:0]T226_m22_adc5_i_tdata;
  input T226_m22_adc5_i_tready;
  output T226_m22_adc5_i_tvalid;
  output [15:0]T226_m23_adc5_q_tdata;
  input T226_m23_adc5_q_tready;
  output T226_m23_adc5_q_tvalid;
  output [15:0]T227_m30_adc6_i_tdata;
  input T227_m30_adc6_i_tready;
  output T227_m30_adc6_i_tvalid;
  output [15:0]T227_m31_adc6_q_tdata;
  input T227_m31_adc6_q_tready;
  output T227_m31_adc6_q_tvalid;
  output [15:0]T227_m32_adc7_i_tdata;
  input T227_m32_adc7_i_tready;
  output T227_m32_adc7_i_tvalid;
  output [15:0]T227_m33_adc7_q_tdata;
  input T227_m33_adc7_q_tready;
  output T227_m33_adc7_q_tvalid;
  input [63:0]T228_s00_dac0_tdata;
  output T228_s00_dac0_tready;
  input T228_s00_dac0_tvalid;
  input [63:0]T228_s02_dac1_tdata;
  output T228_s02_dac1_tready;
  input T228_s02_dac1_tvalid;
  input [63:0]T229_s10_dac2_tdata;
  output T229_s10_dac2_tready;
  input T229_s10_dac2_tvalid;
  input [63:0]T229_s12_dac3_tdata;
  output T229_s12_dac3_tready;
  input T229_s12_dac3_tvalid;
  input [63:0]T230_s20_dac4_tdata;
  output T230_s20_dac4_tready;
  input T230_s20_dac4_tvalid;
  input [63:0]T230_s22_dac5_tdata;
  output T230_s22_dac5_tready;
  input T230_s22_dac5_tvalid;
  input [63:0]T231_s30_dac6_tdata;
  output T231_s30_dac6_tready;
  input T231_s30_dac6_tvalid;
  input [63:0]T231_s32_dac7_tdata;
  output T231_s32_dac7_tready;
  input T231_s32_dac7_tvalid;
  input adc1_clk_clk_n;
  input adc1_clk_clk_p;
  output [7:0]adc_over_range;
  output [7:0]adc_over_threshold1;
  output [7:0]adc_over_threshold2;
  output [7:0]adc_over_voltage;
  output [0:0]axi_aresetn_100M;
  output axi_clk_100M;
  output [0:0]axis_aresetn;
  output clk_122p88;
  output clk_15p36;
  output clk_245p76;
  output clk_368p64;
  output clk_491p52;
  input dac2_clk_clk_n;
  input dac2_clk_clk_p;
  input emio_spi0_m_i;
  output emio_spi0_m_o;
  output emio_spi0_sclk_o;
  output [7:0]emio_spi0_ss_o_n;
  inout iic_sfp0_scl_io;
  inout iic_sfp0_sda_io;
  inout iic_sfp1_scl_io;
  inout iic_sfp1_sda_io;
  inout iic_sfp2_scl_io;
  inout iic_sfp2_sda_io;
  inout iic_sfp3_scl_io;
  inout iic_sfp3_sda_io;
  output irq_adc_dac;
  input [7:0]pl_ps_irq0;
  input [7:0]pl_ps_irq1;
  input [0:0]pl_refclk1_clk_n;
  input [0:0]pl_refclk1_clk_p;
  output pl_refclk1_locked;
  input [0:0]pl_refclk2_clk_n;
  input [0:0]pl_refclk2_clk_p;
  output pl_refclk2_locked;
  input pl_sysref_clk_n;
  input pl_sysref_clk_p;
  input sysref_in_diff_n;
  input sysref_in_diff_p;

  wire [0:0]GPIO_0_tri_i_0;
  wire [1:1]GPIO_0_tri_i_1;
  wire [10:10]GPIO_0_tri_i_10;
  wire [11:11]GPIO_0_tri_i_11;
  wire [12:12]GPIO_0_tri_i_12;
  wire [13:13]GPIO_0_tri_i_13;
  wire [14:14]GPIO_0_tri_i_14;
  wire [15:15]GPIO_0_tri_i_15;
  wire [16:16]GPIO_0_tri_i_16;
  wire [17:17]GPIO_0_tri_i_17;
  wire [18:18]GPIO_0_tri_i_18;
  wire [19:19]GPIO_0_tri_i_19;
  wire [2:2]GPIO_0_tri_i_2;
  wire [20:20]GPIO_0_tri_i_20;
  wire [21:21]GPIO_0_tri_i_21;
  wire [22:22]GPIO_0_tri_i_22;
  wire [23:23]GPIO_0_tri_i_23;
  wire [24:24]GPIO_0_tri_i_24;
  wire [25:25]GPIO_0_tri_i_25;
  wire [26:26]GPIO_0_tri_i_26;
  wire [27:27]GPIO_0_tri_i_27;
  wire [28:28]GPIO_0_tri_i_28;
  wire [29:29]GPIO_0_tri_i_29;
  wire [3:3]GPIO_0_tri_i_3;
  wire [30:30]GPIO_0_tri_i_30;
  wire [31:31]GPIO_0_tri_i_31;
  wire [32:32]GPIO_0_tri_i_32;
  wire [33:33]GPIO_0_tri_i_33;
  wire [34:34]GPIO_0_tri_i_34;
  wire [35:35]GPIO_0_tri_i_35;
  wire [36:36]GPIO_0_tri_i_36;
  wire [37:37]GPIO_0_tri_i_37;
  wire [38:38]GPIO_0_tri_i_38;
  wire [39:39]GPIO_0_tri_i_39;
  wire [4:4]GPIO_0_tri_i_4;
  wire [40:40]GPIO_0_tri_i_40;
  wire [41:41]GPIO_0_tri_i_41;
  wire [42:42]GPIO_0_tri_i_42;
  wire [43:43]GPIO_0_tri_i_43;
  wire [44:44]GPIO_0_tri_i_44;
  wire [45:45]GPIO_0_tri_i_45;
  wire [46:46]GPIO_0_tri_i_46;
  wire [47:47]GPIO_0_tri_i_47;
  wire [48:48]GPIO_0_tri_i_48;
  wire [49:49]GPIO_0_tri_i_49;
  wire [5:5]GPIO_0_tri_i_5;
  wire [50:50]GPIO_0_tri_i_50;
  wire [51:51]GPIO_0_tri_i_51;
  wire [52:52]GPIO_0_tri_i_52;
  wire [53:53]GPIO_0_tri_i_53;
  wire [54:54]GPIO_0_tri_i_54;
  wire [55:55]GPIO_0_tri_i_55;
  wire [56:56]GPIO_0_tri_i_56;
  wire [57:57]GPIO_0_tri_i_57;
  wire [58:58]GPIO_0_tri_i_58;
  wire [59:59]GPIO_0_tri_i_59;
  wire [6:6]GPIO_0_tri_i_6;
  wire [60:60]GPIO_0_tri_i_60;
  wire [61:61]GPIO_0_tri_i_61;
  wire [62:62]GPIO_0_tri_i_62;
  wire [63:63]GPIO_0_tri_i_63;
  wire [64:64]GPIO_0_tri_i_64;
  wire [65:65]GPIO_0_tri_i_65;
  wire [66:66]GPIO_0_tri_i_66;
  wire [67:67]GPIO_0_tri_i_67;
  wire [68:68]GPIO_0_tri_i_68;
  wire [69:69]GPIO_0_tri_i_69;
  wire [7:7]GPIO_0_tri_i_7;
  wire [70:70]GPIO_0_tri_i_70;
  wire [71:71]GPIO_0_tri_i_71;
  wire [72:72]GPIO_0_tri_i_72;
  wire [73:73]GPIO_0_tri_i_73;
  wire [74:74]GPIO_0_tri_i_74;
  wire [75:75]GPIO_0_tri_i_75;
  wire [76:76]GPIO_0_tri_i_76;
  wire [77:77]GPIO_0_tri_i_77;
  wire [78:78]GPIO_0_tri_i_78;
  wire [79:79]GPIO_0_tri_i_79;
  wire [8:8]GPIO_0_tri_i_8;
  wire [80:80]GPIO_0_tri_i_80;
  wire [81:81]GPIO_0_tri_i_81;
  wire [82:82]GPIO_0_tri_i_82;
  wire [83:83]GPIO_0_tri_i_83;
  wire [84:84]GPIO_0_tri_i_84;
  wire [85:85]GPIO_0_tri_i_85;
  wire [86:86]GPIO_0_tri_i_86;
  wire [87:87]GPIO_0_tri_i_87;
  wire [88:88]GPIO_0_tri_i_88;
  wire [89:89]GPIO_0_tri_i_89;
  wire [9:9]GPIO_0_tri_i_9;
  wire [90:90]GPIO_0_tri_i_90;
  wire [91:91]GPIO_0_tri_i_91;
  wire [92:92]GPIO_0_tri_i_92;
  wire [93:93]GPIO_0_tri_i_93;
  wire [94:94]GPIO_0_tri_i_94;
  wire [0:0]GPIO_0_tri_io_0;
  wire [1:1]GPIO_0_tri_io_1;
  wire [10:10]GPIO_0_tri_io_10;
  wire [11:11]GPIO_0_tri_io_11;
  wire [12:12]GPIO_0_tri_io_12;
  wire [13:13]GPIO_0_tri_io_13;
  wire [14:14]GPIO_0_tri_io_14;
  wire [15:15]GPIO_0_tri_io_15;
  wire [16:16]GPIO_0_tri_io_16;
  wire [17:17]GPIO_0_tri_io_17;
  wire [18:18]GPIO_0_tri_io_18;
  wire [19:19]GPIO_0_tri_io_19;
  wire [2:2]GPIO_0_tri_io_2;
  wire [20:20]GPIO_0_tri_io_20;
  wire [21:21]GPIO_0_tri_io_21;
  wire [22:22]GPIO_0_tri_io_22;
  wire [23:23]GPIO_0_tri_io_23;
  wire [24:24]GPIO_0_tri_io_24;
  wire [25:25]GPIO_0_tri_io_25;
  wire [26:26]GPIO_0_tri_io_26;
  wire [27:27]GPIO_0_tri_io_27;
  wire [28:28]GPIO_0_tri_io_28;
  wire [29:29]GPIO_0_tri_io_29;
  wire [3:3]GPIO_0_tri_io_3;
  wire [30:30]GPIO_0_tri_io_30;
  wire [31:31]GPIO_0_tri_io_31;
  wire [32:32]GPIO_0_tri_io_32;
  wire [33:33]GPIO_0_tri_io_33;
  wire [34:34]GPIO_0_tri_io_34;
  wire [35:35]GPIO_0_tri_io_35;
  wire [36:36]GPIO_0_tri_io_36;
  wire [37:37]GPIO_0_tri_io_37;
  wire [38:38]GPIO_0_tri_io_38;
  wire [39:39]GPIO_0_tri_io_39;
  wire [4:4]GPIO_0_tri_io_4;
  wire [40:40]GPIO_0_tri_io_40;
  wire [41:41]GPIO_0_tri_io_41;
  wire [42:42]GPIO_0_tri_io_42;
  wire [43:43]GPIO_0_tri_io_43;
  wire [44:44]GPIO_0_tri_io_44;
  wire [45:45]GPIO_0_tri_io_45;
  wire [46:46]GPIO_0_tri_io_46;
  wire [47:47]GPIO_0_tri_io_47;
  wire [48:48]GPIO_0_tri_io_48;
  wire [49:49]GPIO_0_tri_io_49;
  wire [5:5]GPIO_0_tri_io_5;
  wire [50:50]GPIO_0_tri_io_50;
  wire [51:51]GPIO_0_tri_io_51;
  wire [52:52]GPIO_0_tri_io_52;
  wire [53:53]GPIO_0_tri_io_53;
  wire [54:54]GPIO_0_tri_io_54;
  wire [55:55]GPIO_0_tri_io_55;
  wire [56:56]GPIO_0_tri_io_56;
  wire [57:57]GPIO_0_tri_io_57;
  wire [58:58]GPIO_0_tri_io_58;
  wire [59:59]GPIO_0_tri_io_59;
  wire [6:6]GPIO_0_tri_io_6;
  wire [60:60]GPIO_0_tri_io_60;
  wire [61:61]GPIO_0_tri_io_61;
  wire [62:62]GPIO_0_tri_io_62;
  wire [63:63]GPIO_0_tri_io_63;
  wire [64:64]GPIO_0_tri_io_64;
  wire [65:65]GPIO_0_tri_io_65;
  wire [66:66]GPIO_0_tri_io_66;
  wire [67:67]GPIO_0_tri_io_67;
  wire [68:68]GPIO_0_tri_io_68;
  wire [69:69]GPIO_0_tri_io_69;
  wire [7:7]GPIO_0_tri_io_7;
  wire [70:70]GPIO_0_tri_io_70;
  wire [71:71]GPIO_0_tri_io_71;
  wire [72:72]GPIO_0_tri_io_72;
  wire [73:73]GPIO_0_tri_io_73;
  wire [74:74]GPIO_0_tri_io_74;
  wire [75:75]GPIO_0_tri_io_75;
  wire [76:76]GPIO_0_tri_io_76;
  wire [77:77]GPIO_0_tri_io_77;
  wire [78:78]GPIO_0_tri_io_78;
  wire [79:79]GPIO_0_tri_io_79;
  wire [8:8]GPIO_0_tri_io_8;
  wire [80:80]GPIO_0_tri_io_80;
  wire [81:81]GPIO_0_tri_io_81;
  wire [82:82]GPIO_0_tri_io_82;
  wire [83:83]GPIO_0_tri_io_83;
  wire [84:84]GPIO_0_tri_io_84;
  wire [85:85]GPIO_0_tri_io_85;
  wire [86:86]GPIO_0_tri_io_86;
  wire [87:87]GPIO_0_tri_io_87;
  wire [88:88]GPIO_0_tri_io_88;
  wire [89:89]GPIO_0_tri_io_89;
  wire [9:9]GPIO_0_tri_io_9;
  wire [90:90]GPIO_0_tri_io_90;
  wire [91:91]GPIO_0_tri_io_91;
  wire [92:92]GPIO_0_tri_io_92;
  wire [93:93]GPIO_0_tri_io_93;
  wire [94:94]GPIO_0_tri_io_94;
  wire [0:0]GPIO_0_tri_o_0;
  wire [1:1]GPIO_0_tri_o_1;
  wire [10:10]GPIO_0_tri_o_10;
  wire [11:11]GPIO_0_tri_o_11;
  wire [12:12]GPIO_0_tri_o_12;
  wire [13:13]GPIO_0_tri_o_13;
  wire [14:14]GPIO_0_tri_o_14;
  wire [15:15]GPIO_0_tri_o_15;
  wire [16:16]GPIO_0_tri_o_16;
  wire [17:17]GPIO_0_tri_o_17;
  wire [18:18]GPIO_0_tri_o_18;
  wire [19:19]GPIO_0_tri_o_19;
  wire [2:2]GPIO_0_tri_o_2;
  wire [20:20]GPIO_0_tri_o_20;
  wire [21:21]GPIO_0_tri_o_21;
  wire [22:22]GPIO_0_tri_o_22;
  wire [23:23]GPIO_0_tri_o_23;
  wire [24:24]GPIO_0_tri_o_24;
  wire [25:25]GPIO_0_tri_o_25;
  wire [26:26]GPIO_0_tri_o_26;
  wire [27:27]GPIO_0_tri_o_27;
  wire [28:28]GPIO_0_tri_o_28;
  wire [29:29]GPIO_0_tri_o_29;
  wire [3:3]GPIO_0_tri_o_3;
  wire [30:30]GPIO_0_tri_o_30;
  wire [31:31]GPIO_0_tri_o_31;
  wire [32:32]GPIO_0_tri_o_32;
  wire [33:33]GPIO_0_tri_o_33;
  wire [34:34]GPIO_0_tri_o_34;
  wire [35:35]GPIO_0_tri_o_35;
  wire [36:36]GPIO_0_tri_o_36;
  wire [37:37]GPIO_0_tri_o_37;
  wire [38:38]GPIO_0_tri_o_38;
  wire [39:39]GPIO_0_tri_o_39;
  wire [4:4]GPIO_0_tri_o_4;
  wire [40:40]GPIO_0_tri_o_40;
  wire [41:41]GPIO_0_tri_o_41;
  wire [42:42]GPIO_0_tri_o_42;
  wire [43:43]GPIO_0_tri_o_43;
  wire [44:44]GPIO_0_tri_o_44;
  wire [45:45]GPIO_0_tri_o_45;
  wire [46:46]GPIO_0_tri_o_46;
  wire [47:47]GPIO_0_tri_o_47;
  wire [48:48]GPIO_0_tri_o_48;
  wire [49:49]GPIO_0_tri_o_49;
  wire [5:5]GPIO_0_tri_o_5;
  wire [50:50]GPIO_0_tri_o_50;
  wire [51:51]GPIO_0_tri_o_51;
  wire [52:52]GPIO_0_tri_o_52;
  wire [53:53]GPIO_0_tri_o_53;
  wire [54:54]GPIO_0_tri_o_54;
  wire [55:55]GPIO_0_tri_o_55;
  wire [56:56]GPIO_0_tri_o_56;
  wire [57:57]GPIO_0_tri_o_57;
  wire [58:58]GPIO_0_tri_o_58;
  wire [59:59]GPIO_0_tri_o_59;
  wire [6:6]GPIO_0_tri_o_6;
  wire [60:60]GPIO_0_tri_o_60;
  wire [61:61]GPIO_0_tri_o_61;
  wire [62:62]GPIO_0_tri_o_62;
  wire [63:63]GPIO_0_tri_o_63;
  wire [64:64]GPIO_0_tri_o_64;
  wire [65:65]GPIO_0_tri_o_65;
  wire [66:66]GPIO_0_tri_o_66;
  wire [67:67]GPIO_0_tri_o_67;
  wire [68:68]GPIO_0_tri_o_68;
  wire [69:69]GPIO_0_tri_o_69;
  wire [7:7]GPIO_0_tri_o_7;
  wire [70:70]GPIO_0_tri_o_70;
  wire [71:71]GPIO_0_tri_o_71;
  wire [72:72]GPIO_0_tri_o_72;
  wire [73:73]GPIO_0_tri_o_73;
  wire [74:74]GPIO_0_tri_o_74;
  wire [75:75]GPIO_0_tri_o_75;
  wire [76:76]GPIO_0_tri_o_76;
  wire [77:77]GPIO_0_tri_o_77;
  wire [78:78]GPIO_0_tri_o_78;
  wire [79:79]GPIO_0_tri_o_79;
  wire [8:8]GPIO_0_tri_o_8;
  wire [80:80]GPIO_0_tri_o_80;
  wire [81:81]GPIO_0_tri_o_81;
  wire [82:82]GPIO_0_tri_o_82;
  wire [83:83]GPIO_0_tri_o_83;
  wire [84:84]GPIO_0_tri_o_84;
  wire [85:85]GPIO_0_tri_o_85;
  wire [86:86]GPIO_0_tri_o_86;
  wire [87:87]GPIO_0_tri_o_87;
  wire [88:88]GPIO_0_tri_o_88;
  wire [89:89]GPIO_0_tri_o_89;
  wire [9:9]GPIO_0_tri_o_9;
  wire [90:90]GPIO_0_tri_o_90;
  wire [91:91]GPIO_0_tri_o_91;
  wire [92:92]GPIO_0_tri_o_92;
  wire [93:93]GPIO_0_tri_o_93;
  wire [94:94]GPIO_0_tri_o_94;
  wire [0:0]GPIO_0_tri_t_0;
  wire [1:1]GPIO_0_tri_t_1;
  wire [10:10]GPIO_0_tri_t_10;
  wire [11:11]GPIO_0_tri_t_11;
  wire [12:12]GPIO_0_tri_t_12;
  wire [13:13]GPIO_0_tri_t_13;
  wire [14:14]GPIO_0_tri_t_14;
  wire [15:15]GPIO_0_tri_t_15;
  wire [16:16]GPIO_0_tri_t_16;
  wire [17:17]GPIO_0_tri_t_17;
  wire [18:18]GPIO_0_tri_t_18;
  wire [19:19]GPIO_0_tri_t_19;
  wire [2:2]GPIO_0_tri_t_2;
  wire [20:20]GPIO_0_tri_t_20;
  wire [21:21]GPIO_0_tri_t_21;
  wire [22:22]GPIO_0_tri_t_22;
  wire [23:23]GPIO_0_tri_t_23;
  wire [24:24]GPIO_0_tri_t_24;
  wire [25:25]GPIO_0_tri_t_25;
  wire [26:26]GPIO_0_tri_t_26;
  wire [27:27]GPIO_0_tri_t_27;
  wire [28:28]GPIO_0_tri_t_28;
  wire [29:29]GPIO_0_tri_t_29;
  wire [3:3]GPIO_0_tri_t_3;
  wire [30:30]GPIO_0_tri_t_30;
  wire [31:31]GPIO_0_tri_t_31;
  wire [32:32]GPIO_0_tri_t_32;
  wire [33:33]GPIO_0_tri_t_33;
  wire [34:34]GPIO_0_tri_t_34;
  wire [35:35]GPIO_0_tri_t_35;
  wire [36:36]GPIO_0_tri_t_36;
  wire [37:37]GPIO_0_tri_t_37;
  wire [38:38]GPIO_0_tri_t_38;
  wire [39:39]GPIO_0_tri_t_39;
  wire [4:4]GPIO_0_tri_t_4;
  wire [40:40]GPIO_0_tri_t_40;
  wire [41:41]GPIO_0_tri_t_41;
  wire [42:42]GPIO_0_tri_t_42;
  wire [43:43]GPIO_0_tri_t_43;
  wire [44:44]GPIO_0_tri_t_44;
  wire [45:45]GPIO_0_tri_t_45;
  wire [46:46]GPIO_0_tri_t_46;
  wire [47:47]GPIO_0_tri_t_47;
  wire [48:48]GPIO_0_tri_t_48;
  wire [49:49]GPIO_0_tri_t_49;
  wire [5:5]GPIO_0_tri_t_5;
  wire [50:50]GPIO_0_tri_t_50;
  wire [51:51]GPIO_0_tri_t_51;
  wire [52:52]GPIO_0_tri_t_52;
  wire [53:53]GPIO_0_tri_t_53;
  wire [54:54]GPIO_0_tri_t_54;
  wire [55:55]GPIO_0_tri_t_55;
  wire [56:56]GPIO_0_tri_t_56;
  wire [57:57]GPIO_0_tri_t_57;
  wire [58:58]GPIO_0_tri_t_58;
  wire [59:59]GPIO_0_tri_t_59;
  wire [6:6]GPIO_0_tri_t_6;
  wire [60:60]GPIO_0_tri_t_60;
  wire [61:61]GPIO_0_tri_t_61;
  wire [62:62]GPIO_0_tri_t_62;
  wire [63:63]GPIO_0_tri_t_63;
  wire [64:64]GPIO_0_tri_t_64;
  wire [65:65]GPIO_0_tri_t_65;
  wire [66:66]GPIO_0_tri_t_66;
  wire [67:67]GPIO_0_tri_t_67;
  wire [68:68]GPIO_0_tri_t_68;
  wire [69:69]GPIO_0_tri_t_69;
  wire [7:7]GPIO_0_tri_t_7;
  wire [70:70]GPIO_0_tri_t_70;
  wire [71:71]GPIO_0_tri_t_71;
  wire [72:72]GPIO_0_tri_t_72;
  wire [73:73]GPIO_0_tri_t_73;
  wire [74:74]GPIO_0_tri_t_74;
  wire [75:75]GPIO_0_tri_t_75;
  wire [76:76]GPIO_0_tri_t_76;
  wire [77:77]GPIO_0_tri_t_77;
  wire [78:78]GPIO_0_tri_t_78;
  wire [79:79]GPIO_0_tri_t_79;
  wire [8:8]GPIO_0_tri_t_8;
  wire [80:80]GPIO_0_tri_t_80;
  wire [81:81]GPIO_0_tri_t_81;
  wire [82:82]GPIO_0_tri_t_82;
  wire [83:83]GPIO_0_tri_t_83;
  wire [84:84]GPIO_0_tri_t_84;
  wire [85:85]GPIO_0_tri_t_85;
  wire [86:86]GPIO_0_tri_t_86;
  wire [87:87]GPIO_0_tri_t_87;
  wire [88:88]GPIO_0_tri_t_88;
  wire [89:89]GPIO_0_tri_t_89;
  wire [9:9]GPIO_0_tri_t_9;
  wire [90:90]GPIO_0_tri_t_90;
  wire [91:91]GPIO_0_tri_t_91;
  wire [92:92]GPIO_0_tri_t_92;
  wire [93:93]GPIO_0_tri_t_93;
  wire [94:94]GPIO_0_tri_t_94;
  wire [31:0]M00_AXI_TOP_CTRL_CMN_araddr;
  wire [2:0]M00_AXI_TOP_CTRL_CMN_arprot;
  wire M00_AXI_TOP_CTRL_CMN_arready;
  wire M00_AXI_TOP_CTRL_CMN_arvalid;
  wire [31:0]M00_AXI_TOP_CTRL_CMN_awaddr;
  wire [2:0]M00_AXI_TOP_CTRL_CMN_awprot;
  wire M00_AXI_TOP_CTRL_CMN_awready;
  wire M00_AXI_TOP_CTRL_CMN_awvalid;
  wire M00_AXI_TOP_CTRL_CMN_bready;
  wire [1:0]M00_AXI_TOP_CTRL_CMN_bresp;
  wire M00_AXI_TOP_CTRL_CMN_bvalid;
  wire [31:0]M00_AXI_TOP_CTRL_CMN_rdata;
  wire M00_AXI_TOP_CTRL_CMN_rready;
  wire [1:0]M00_AXI_TOP_CTRL_CMN_rresp;
  wire M00_AXI_TOP_CTRL_CMN_rvalid;
  wire [31:0]M00_AXI_TOP_CTRL_CMN_wdata;
  wire M00_AXI_TOP_CTRL_CMN_wready;
  wire [3:0]M00_AXI_TOP_CTRL_CMN_wstrb;
  wire M00_AXI_TOP_CTRL_CMN_wvalid;
  wire [31:0]M00_AXI_TOP_CTRL_HW_araddr;
  wire [2:0]M00_AXI_TOP_CTRL_HW_arprot;
  wire M00_AXI_TOP_CTRL_HW_arready;
  wire M00_AXI_TOP_CTRL_HW_arvalid;
  wire [31:0]M00_AXI_TOP_CTRL_HW_awaddr;
  wire [2:0]M00_AXI_TOP_CTRL_HW_awprot;
  wire M00_AXI_TOP_CTRL_HW_awready;
  wire M00_AXI_TOP_CTRL_HW_awvalid;
  wire M00_AXI_TOP_CTRL_HW_bready;
  wire [1:0]M00_AXI_TOP_CTRL_HW_bresp;
  wire M00_AXI_TOP_CTRL_HW_bvalid;
  wire [31:0]M00_AXI_TOP_CTRL_HW_rdata;
  wire M00_AXI_TOP_CTRL_HW_rready;
  wire [1:0]M00_AXI_TOP_CTRL_HW_rresp;
  wire M00_AXI_TOP_CTRL_HW_rvalid;
  wire [31:0]M00_AXI_TOP_CTRL_HW_wdata;
  wire M00_AXI_TOP_CTRL_HW_wready;
  wire [3:0]M00_AXI_TOP_CTRL_HW_wstrb;
  wire M00_AXI_TOP_CTRL_HW_wvalid;
  wire [31:0]M00_AXI_TOP_CTRL_INTR_araddr;
  wire [2:0]M00_AXI_TOP_CTRL_INTR_arprot;
  wire M00_AXI_TOP_CTRL_INTR_arready;
  wire M00_AXI_TOP_CTRL_INTR_arvalid;
  wire [31:0]M00_AXI_TOP_CTRL_INTR_awaddr;
  wire [2:0]M00_AXI_TOP_CTRL_INTR_awprot;
  wire M00_AXI_TOP_CTRL_INTR_awready;
  wire M00_AXI_TOP_CTRL_INTR_awvalid;
  wire M00_AXI_TOP_CTRL_INTR_bready;
  wire [1:0]M00_AXI_TOP_CTRL_INTR_bresp;
  wire M00_AXI_TOP_CTRL_INTR_bvalid;
  wire [31:0]M00_AXI_TOP_CTRL_INTR_rdata;
  wire M00_AXI_TOP_CTRL_INTR_rready;
  wire [1:0]M00_AXI_TOP_CTRL_INTR_rresp;
  wire M00_AXI_TOP_CTRL_INTR_rvalid;
  wire [31:0]M00_AXI_TOP_CTRL_INTR_wdata;
  wire M00_AXI_TOP_CTRL_INTR_wready;
  wire [3:0]M00_AXI_TOP_CTRL_INTR_wstrb;
  wire M00_AXI_TOP_CTRL_INTR_wvalid;
  wire [31:0]M00_AXI_TOP_CTRL_TEST_araddr;
  wire [2:0]M00_AXI_TOP_CTRL_TEST_arprot;
  wire M00_AXI_TOP_CTRL_TEST_arready;
  wire M00_AXI_TOP_CTRL_TEST_arvalid;
  wire [31:0]M00_AXI_TOP_CTRL_TEST_awaddr;
  wire [2:0]M00_AXI_TOP_CTRL_TEST_awprot;
  wire M00_AXI_TOP_CTRL_TEST_awready;
  wire M00_AXI_TOP_CTRL_TEST_awvalid;
  wire M00_AXI_TOP_CTRL_TEST_bready;
  wire [1:0]M00_AXI_TOP_CTRL_TEST_bresp;
  wire M00_AXI_TOP_CTRL_TEST_bvalid;
  wire [31:0]M00_AXI_TOP_CTRL_TEST_rdata;
  wire M00_AXI_TOP_CTRL_TEST_rready;
  wire [1:0]M00_AXI_TOP_CTRL_TEST_rresp;
  wire M00_AXI_TOP_CTRL_TEST_rvalid;
  wire [31:0]M00_AXI_TOP_CTRL_TEST_wdata;
  wire M00_AXI_TOP_CTRL_TEST_wready;
  wire [3:0]M00_AXI_TOP_CTRL_TEST_wstrb;
  wire M00_AXI_TOP_CTRL_TEST_wvalid;
  wire [31:0]RF_BRAM_PORTB_addr;
  wire RF_BRAM_PORTB_clk;
  wire [63:0]RF_BRAM_PORTB_din;
  wire [63:0]RF_BRAM_PORTB_dout;
  wire RF_BRAM_PORTB_en;
  wire RF_BRAM_PORTB_rst;
  wire [7:0]RF_BRAM_PORTB_we;
  wire [15:0]T224_m00_adc0_i_tdata;
  wire T224_m00_adc0_i_tready;
  wire T224_m00_adc0_i_tvalid;
  wire [15:0]T224_m01_adc0_q_tdata;
  wire T224_m01_adc0_q_tready;
  wire T224_m01_adc0_q_tvalid;
  wire [15:0]T224_m02_adc1_i_tdata;
  wire T224_m02_adc1_i_tready;
  wire T224_m02_adc1_i_tvalid;
  wire [15:0]T224_m03_adc1_q_tdata;
  wire T224_m03_adc1_q_tready;
  wire T224_m03_adc1_q_tvalid;
  wire [15:0]T225_m10_adc2_i_tdata;
  wire T225_m10_adc2_i_tready;
  wire T225_m10_adc2_i_tvalid;
  wire [15:0]T225_m11_adc2_q_tdata;
  wire T225_m11_adc2_q_tready;
  wire T225_m11_adc2_q_tvalid;
  wire [15:0]T225_m12_adc3_i_tdata;
  wire T225_m12_adc3_i_tready;
  wire T225_m12_adc3_i_tvalid;
  wire [15:0]T225_m13_adc3_q_tdata;
  wire T225_m13_adc3_q_tready;
  wire T225_m13_adc3_q_tvalid;
  wire [15:0]T226_m20_adc4_i_tdata;
  wire T226_m20_adc4_i_tready;
  wire T226_m20_adc4_i_tvalid;
  wire [15:0]T226_m21_adc4_q_tdata;
  wire T226_m21_adc4_q_tready;
  wire T226_m21_adc4_q_tvalid;
  wire [15:0]T226_m22_adc5_i_tdata;
  wire T226_m22_adc5_i_tready;
  wire T226_m22_adc5_i_tvalid;
  wire [15:0]T226_m23_adc5_q_tdata;
  wire T226_m23_adc5_q_tready;
  wire T226_m23_adc5_q_tvalid;
  wire [15:0]T227_m30_adc6_i_tdata;
  wire T227_m30_adc6_i_tready;
  wire T227_m30_adc6_i_tvalid;
  wire [15:0]T227_m31_adc6_q_tdata;
  wire T227_m31_adc6_q_tready;
  wire T227_m31_adc6_q_tvalid;
  wire [15:0]T227_m32_adc7_i_tdata;
  wire T227_m32_adc7_i_tready;
  wire T227_m32_adc7_i_tvalid;
  wire [15:0]T227_m33_adc7_q_tdata;
  wire T227_m33_adc7_q_tready;
  wire T227_m33_adc7_q_tvalid;
  wire [63:0]T228_s00_dac0_tdata;
  wire T228_s00_dac0_tready;
  wire T228_s00_dac0_tvalid;
  wire [63:0]T228_s02_dac1_tdata;
  wire T228_s02_dac1_tready;
  wire T228_s02_dac1_tvalid;
  wire [63:0]T229_s10_dac2_tdata;
  wire T229_s10_dac2_tready;
  wire T229_s10_dac2_tvalid;
  wire [63:0]T229_s12_dac3_tdata;
  wire T229_s12_dac3_tready;
  wire T229_s12_dac3_tvalid;
  wire [63:0]T230_s20_dac4_tdata;
  wire T230_s20_dac4_tready;
  wire T230_s20_dac4_tvalid;
  wire [63:0]T230_s22_dac5_tdata;
  wire T230_s22_dac5_tready;
  wire T230_s22_dac5_tvalid;
  wire [63:0]T231_s30_dac6_tdata;
  wire T231_s30_dac6_tready;
  wire T231_s30_dac6_tvalid;
  wire [63:0]T231_s32_dac7_tdata;
  wire T231_s32_dac7_tready;
  wire T231_s32_dac7_tvalid;
  wire adc1_clk_clk_n;
  wire adc1_clk_clk_p;
  wire [7:0]adc_over_range;
  wire [7:0]adc_over_threshold1;
  wire [7:0]adc_over_threshold2;
  wire [7:0]adc_over_voltage;
  wire [0:0]axi_aresetn_100M;
  wire axi_clk_100M;
  wire [0:0]axis_aresetn;
  wire clk_122p88;
  wire clk_15p36;
  wire clk_245p76;
  wire clk_368p64;
  wire clk_491p52;
  wire dac2_clk_clk_n;
  wire dac2_clk_clk_p;
  wire emio_spi0_m_i;
  wire emio_spi0_m_o;
  wire emio_spi0_sclk_o;
  wire [7:0]emio_spi0_ss_o_n;
  wire iic_sfp0_scl_i;
  wire iic_sfp0_scl_io;
  wire iic_sfp0_scl_o;
  wire iic_sfp0_scl_t;
  wire iic_sfp0_sda_i;
  wire iic_sfp0_sda_io;
  wire iic_sfp0_sda_o;
  wire iic_sfp0_sda_t;
  wire iic_sfp1_scl_i;
  wire iic_sfp1_scl_io;
  wire iic_sfp1_scl_o;
  wire iic_sfp1_scl_t;
  wire iic_sfp1_sda_i;
  wire iic_sfp1_sda_io;
  wire iic_sfp1_sda_o;
  wire iic_sfp1_sda_t;
  wire iic_sfp2_scl_i;
  wire iic_sfp2_scl_io;
  wire iic_sfp2_scl_o;
  wire iic_sfp2_scl_t;
  wire iic_sfp2_sda_i;
  wire iic_sfp2_sda_io;
  wire iic_sfp2_sda_o;
  wire iic_sfp2_sda_t;
  wire iic_sfp3_scl_i;
  wire iic_sfp3_scl_io;
  wire iic_sfp3_scl_o;
  wire iic_sfp3_scl_t;
  wire iic_sfp3_sda_i;
  wire iic_sfp3_sda_io;
  wire iic_sfp3_sda_o;
  wire iic_sfp3_sda_t;
  wire irq_adc_dac;
  wire [7:0]pl_ps_irq0;
  wire [7:0]pl_ps_irq1;
  wire [0:0]pl_refclk1_clk_n;
  wire [0:0]pl_refclk1_clk_p;
  wire pl_refclk1_locked;
  wire [0:0]pl_refclk2_clk_n;
  wire [0:0]pl_refclk2_clk_p;
  wire pl_refclk2_locked;
  wire pl_sysref_clk_n;
  wire pl_sysref_clk_p;
  wire sysref_in_diff_n;
  wire sysref_in_diff_p;

  IOBUF GPIO_0_tri_iobuf_0
       (.I(GPIO_0_tri_o_0),
        .IO(GPIO_0_tri_io[0]),
        .O(GPIO_0_tri_i_0),
        .T(GPIO_0_tri_t_0));
  IOBUF GPIO_0_tri_iobuf_1
       (.I(GPIO_0_tri_o_1),
        .IO(GPIO_0_tri_io[1]),
        .O(GPIO_0_tri_i_1),
        .T(GPIO_0_tri_t_1));
  IOBUF GPIO_0_tri_iobuf_10
       (.I(GPIO_0_tri_o_10),
        .IO(GPIO_0_tri_io[10]),
        .O(GPIO_0_tri_i_10),
        .T(GPIO_0_tri_t_10));
  IOBUF GPIO_0_tri_iobuf_11
       (.I(GPIO_0_tri_o_11),
        .IO(GPIO_0_tri_io[11]),
        .O(GPIO_0_tri_i_11),
        .T(GPIO_0_tri_t_11));
  IOBUF GPIO_0_tri_iobuf_12
       (.I(GPIO_0_tri_o_12),
        .IO(GPIO_0_tri_io[12]),
        .O(GPIO_0_tri_i_12),
        .T(GPIO_0_tri_t_12));
  IOBUF GPIO_0_tri_iobuf_13
       (.I(GPIO_0_tri_o_13),
        .IO(GPIO_0_tri_io[13]),
        .O(GPIO_0_tri_i_13),
        .T(GPIO_0_tri_t_13));
  IOBUF GPIO_0_tri_iobuf_14
       (.I(GPIO_0_tri_o_14),
        .IO(GPIO_0_tri_io[14]),
        .O(GPIO_0_tri_i_14),
        .T(GPIO_0_tri_t_14));
  IOBUF GPIO_0_tri_iobuf_15
       (.I(GPIO_0_tri_o_15),
        .IO(GPIO_0_tri_io[15]),
        .O(GPIO_0_tri_i_15),
        .T(GPIO_0_tri_t_15));
  IOBUF GPIO_0_tri_iobuf_16
       (.I(GPIO_0_tri_o_16),
        .IO(GPIO_0_tri_io[16]),
        .O(GPIO_0_tri_i_16),
        .T(GPIO_0_tri_t_16));
  IOBUF GPIO_0_tri_iobuf_17
       (.I(GPIO_0_tri_o_17),
        .IO(GPIO_0_tri_io[17]),
        .O(GPIO_0_tri_i_17),
        .T(GPIO_0_tri_t_17));
  IOBUF GPIO_0_tri_iobuf_18
       (.I(GPIO_0_tri_o_18),
        .IO(GPIO_0_tri_io[18]),
        .O(GPIO_0_tri_i_18),
        .T(GPIO_0_tri_t_18));
  IOBUF GPIO_0_tri_iobuf_19
       (.I(GPIO_0_tri_o_19),
        .IO(GPIO_0_tri_io[19]),
        .O(GPIO_0_tri_i_19),
        .T(GPIO_0_tri_t_19));
  IOBUF GPIO_0_tri_iobuf_2
       (.I(GPIO_0_tri_o_2),
        .IO(GPIO_0_tri_io[2]),
        .O(GPIO_0_tri_i_2),
        .T(GPIO_0_tri_t_2));
  IOBUF GPIO_0_tri_iobuf_20
       (.I(GPIO_0_tri_o_20),
        .IO(GPIO_0_tri_io[20]),
        .O(GPIO_0_tri_i_20),
        .T(GPIO_0_tri_t_20));
  IOBUF GPIO_0_tri_iobuf_21
       (.I(GPIO_0_tri_o_21),
        .IO(GPIO_0_tri_io[21]),
        .O(GPIO_0_tri_i_21),
        .T(GPIO_0_tri_t_21));
  IOBUF GPIO_0_tri_iobuf_22
       (.I(GPIO_0_tri_o_22),
        .IO(GPIO_0_tri_io[22]),
        .O(GPIO_0_tri_i_22),
        .T(GPIO_0_tri_t_22));
  IOBUF GPIO_0_tri_iobuf_23
       (.I(GPIO_0_tri_o_23),
        .IO(GPIO_0_tri_io[23]),
        .O(GPIO_0_tri_i_23),
        .T(GPIO_0_tri_t_23));
  IOBUF GPIO_0_tri_iobuf_24
       (.I(GPIO_0_tri_o_24),
        .IO(GPIO_0_tri_io[24]),
        .O(GPIO_0_tri_i_24),
        .T(GPIO_0_tri_t_24));
  IOBUF GPIO_0_tri_iobuf_25
       (.I(GPIO_0_tri_o_25),
        .IO(GPIO_0_tri_io[25]),
        .O(GPIO_0_tri_i_25),
        .T(GPIO_0_tri_t_25));
  IOBUF GPIO_0_tri_iobuf_26
       (.I(GPIO_0_tri_o_26),
        .IO(GPIO_0_tri_io[26]),
        .O(GPIO_0_tri_i_26),
        .T(GPIO_0_tri_t_26));
  IOBUF GPIO_0_tri_iobuf_27
       (.I(GPIO_0_tri_o_27),
        .IO(GPIO_0_tri_io[27]),
        .O(GPIO_0_tri_i_27),
        .T(GPIO_0_tri_t_27));
  IOBUF GPIO_0_tri_iobuf_28
       (.I(GPIO_0_tri_o_28),
        .IO(GPIO_0_tri_io[28]),
        .O(GPIO_0_tri_i_28),
        .T(GPIO_0_tri_t_28));
  IOBUF GPIO_0_tri_iobuf_29
       (.I(GPIO_0_tri_o_29),
        .IO(GPIO_0_tri_io[29]),
        .O(GPIO_0_tri_i_29),
        .T(GPIO_0_tri_t_29));
  IOBUF GPIO_0_tri_iobuf_3
       (.I(GPIO_0_tri_o_3),
        .IO(GPIO_0_tri_io[3]),
        .O(GPIO_0_tri_i_3),
        .T(GPIO_0_tri_t_3));
  IOBUF GPIO_0_tri_iobuf_30
       (.I(GPIO_0_tri_o_30),
        .IO(GPIO_0_tri_io[30]),
        .O(GPIO_0_tri_i_30),
        .T(GPIO_0_tri_t_30));
  IOBUF GPIO_0_tri_iobuf_31
       (.I(GPIO_0_tri_o_31),
        .IO(GPIO_0_tri_io[31]),
        .O(GPIO_0_tri_i_31),
        .T(GPIO_0_tri_t_31));
  IOBUF GPIO_0_tri_iobuf_32
       (.I(GPIO_0_tri_o_32),
        .IO(GPIO_0_tri_io[32]),
        .O(GPIO_0_tri_i_32),
        .T(GPIO_0_tri_t_32));
  IOBUF GPIO_0_tri_iobuf_33
       (.I(GPIO_0_tri_o_33),
        .IO(GPIO_0_tri_io[33]),
        .O(GPIO_0_tri_i_33),
        .T(GPIO_0_tri_t_33));
  IOBUF GPIO_0_tri_iobuf_34
       (.I(GPIO_0_tri_o_34),
        .IO(GPIO_0_tri_io[34]),
        .O(GPIO_0_tri_i_34),
        .T(GPIO_0_tri_t_34));
  IOBUF GPIO_0_tri_iobuf_35
       (.I(GPIO_0_tri_o_35),
        .IO(GPIO_0_tri_io[35]),
        .O(GPIO_0_tri_i_35),
        .T(GPIO_0_tri_t_35));
  IOBUF GPIO_0_tri_iobuf_36
       (.I(GPIO_0_tri_o_36),
        .IO(GPIO_0_tri_io[36]),
        .O(GPIO_0_tri_i_36),
        .T(GPIO_0_tri_t_36));
  IOBUF GPIO_0_tri_iobuf_37
       (.I(GPIO_0_tri_o_37),
        .IO(GPIO_0_tri_io[37]),
        .O(GPIO_0_tri_i_37),
        .T(GPIO_0_tri_t_37));
  IOBUF GPIO_0_tri_iobuf_38
       (.I(GPIO_0_tri_o_38),
        .IO(GPIO_0_tri_io[38]),
        .O(GPIO_0_tri_i_38),
        .T(GPIO_0_tri_t_38));
  IOBUF GPIO_0_tri_iobuf_39
       (.I(GPIO_0_tri_o_39),
        .IO(GPIO_0_tri_io[39]),
        .O(GPIO_0_tri_i_39),
        .T(GPIO_0_tri_t_39));
  IOBUF GPIO_0_tri_iobuf_4
       (.I(GPIO_0_tri_o_4),
        .IO(GPIO_0_tri_io[4]),
        .O(GPIO_0_tri_i_4),
        .T(GPIO_0_tri_t_4));
  IOBUF GPIO_0_tri_iobuf_40
       (.I(GPIO_0_tri_o_40),
        .IO(GPIO_0_tri_io[40]),
        .O(GPIO_0_tri_i_40),
        .T(GPIO_0_tri_t_40));
  IOBUF GPIO_0_tri_iobuf_41
       (.I(GPIO_0_tri_o_41),
        .IO(GPIO_0_tri_io[41]),
        .O(GPIO_0_tri_i_41),
        .T(GPIO_0_tri_t_41));
  IOBUF GPIO_0_tri_iobuf_42
       (.I(GPIO_0_tri_o_42),
        .IO(GPIO_0_tri_io[42]),
        .O(GPIO_0_tri_i_42),
        .T(GPIO_0_tri_t_42));
  IOBUF GPIO_0_tri_iobuf_43
       (.I(GPIO_0_tri_o_43),
        .IO(GPIO_0_tri_io[43]),
        .O(GPIO_0_tri_i_43),
        .T(GPIO_0_tri_t_43));
  IOBUF GPIO_0_tri_iobuf_44
       (.I(GPIO_0_tri_o_44),
        .IO(GPIO_0_tri_io[44]),
        .O(GPIO_0_tri_i_44),
        .T(GPIO_0_tri_t_44));
  IOBUF GPIO_0_tri_iobuf_45
       (.I(GPIO_0_tri_o_45),
        .IO(GPIO_0_tri_io[45]),
        .O(GPIO_0_tri_i_45),
        .T(GPIO_0_tri_t_45));
  IOBUF GPIO_0_tri_iobuf_46
       (.I(GPIO_0_tri_o_46),
        .IO(GPIO_0_tri_io[46]),
        .O(GPIO_0_tri_i_46),
        .T(GPIO_0_tri_t_46));
  IOBUF GPIO_0_tri_iobuf_47
       (.I(GPIO_0_tri_o_47),
        .IO(GPIO_0_tri_io[47]),
        .O(GPIO_0_tri_i_47),
        .T(GPIO_0_tri_t_47));
  IOBUF GPIO_0_tri_iobuf_48
       (.I(GPIO_0_tri_o_48),
        .IO(GPIO_0_tri_io[48]),
        .O(GPIO_0_tri_i_48),
        .T(GPIO_0_tri_t_48));
  IOBUF GPIO_0_tri_iobuf_49
       (.I(GPIO_0_tri_o_49),
        .IO(GPIO_0_tri_io[49]),
        .O(GPIO_0_tri_i_49),
        .T(GPIO_0_tri_t_49));
  IOBUF GPIO_0_tri_iobuf_5
       (.I(GPIO_0_tri_o_5),
        .IO(GPIO_0_tri_io[5]),
        .O(GPIO_0_tri_i_5),
        .T(GPIO_0_tri_t_5));
  IOBUF GPIO_0_tri_iobuf_50
       (.I(GPIO_0_tri_o_50),
        .IO(GPIO_0_tri_io[50]),
        .O(GPIO_0_tri_i_50),
        .T(GPIO_0_tri_t_50));
  IOBUF GPIO_0_tri_iobuf_51
       (.I(GPIO_0_tri_o_51),
        .IO(GPIO_0_tri_io[51]),
        .O(GPIO_0_tri_i_51),
        .T(GPIO_0_tri_t_51));
  IOBUF GPIO_0_tri_iobuf_52
       (.I(GPIO_0_tri_o_52),
        .IO(GPIO_0_tri_io[52]),
        .O(GPIO_0_tri_i_52),
        .T(GPIO_0_tri_t_52));
  IOBUF GPIO_0_tri_iobuf_53
       (.I(GPIO_0_tri_o_53),
        .IO(GPIO_0_tri_io[53]),
        .O(GPIO_0_tri_i_53),
        .T(GPIO_0_tri_t_53));
  IOBUF GPIO_0_tri_iobuf_54
       (.I(GPIO_0_tri_o_54),
        .IO(GPIO_0_tri_io[54]),
        .O(GPIO_0_tri_i_54),
        .T(GPIO_0_tri_t_54));
  IOBUF GPIO_0_tri_iobuf_55
       (.I(GPIO_0_tri_o_55),
        .IO(GPIO_0_tri_io[55]),
        .O(GPIO_0_tri_i_55),
        .T(GPIO_0_tri_t_55));
  IOBUF GPIO_0_tri_iobuf_56
       (.I(GPIO_0_tri_o_56),
        .IO(GPIO_0_tri_io[56]),
        .O(GPIO_0_tri_i_56),
        .T(GPIO_0_tri_t_56));
  IOBUF GPIO_0_tri_iobuf_57
       (.I(GPIO_0_tri_o_57),
        .IO(GPIO_0_tri_io[57]),
        .O(GPIO_0_tri_i_57),
        .T(GPIO_0_tri_t_57));
  IOBUF GPIO_0_tri_iobuf_58
       (.I(GPIO_0_tri_o_58),
        .IO(GPIO_0_tri_io[58]),
        .O(GPIO_0_tri_i_58),
        .T(GPIO_0_tri_t_58));
  IOBUF GPIO_0_tri_iobuf_59
       (.I(GPIO_0_tri_o_59),
        .IO(GPIO_0_tri_io[59]),
        .O(GPIO_0_tri_i_59),
        .T(GPIO_0_tri_t_59));
  IOBUF GPIO_0_tri_iobuf_6
       (.I(GPIO_0_tri_o_6),
        .IO(GPIO_0_tri_io[6]),
        .O(GPIO_0_tri_i_6),
        .T(GPIO_0_tri_t_6));
  IOBUF GPIO_0_tri_iobuf_60
       (.I(GPIO_0_tri_o_60),
        .IO(GPIO_0_tri_io[60]),
        .O(GPIO_0_tri_i_60),
        .T(GPIO_0_tri_t_60));
  IOBUF GPIO_0_tri_iobuf_61
       (.I(GPIO_0_tri_o_61),
        .IO(GPIO_0_tri_io[61]),
        .O(GPIO_0_tri_i_61),
        .T(GPIO_0_tri_t_61));
  IOBUF GPIO_0_tri_iobuf_62
       (.I(GPIO_0_tri_o_62),
        .IO(GPIO_0_tri_io[62]),
        .O(GPIO_0_tri_i_62),
        .T(GPIO_0_tri_t_62));
  IOBUF GPIO_0_tri_iobuf_63
       (.I(GPIO_0_tri_o_63),
        .IO(GPIO_0_tri_io[63]),
        .O(GPIO_0_tri_i_63),
        .T(GPIO_0_tri_t_63));
  IOBUF GPIO_0_tri_iobuf_64
       (.I(GPIO_0_tri_o_64),
        .IO(GPIO_0_tri_io[64]),
        .O(GPIO_0_tri_i_64),
        .T(GPIO_0_tri_t_64));
  IOBUF GPIO_0_tri_iobuf_65
       (.I(GPIO_0_tri_o_65),
        .IO(GPIO_0_tri_io[65]),
        .O(GPIO_0_tri_i_65),
        .T(GPIO_0_tri_t_65));
  IOBUF GPIO_0_tri_iobuf_66
       (.I(GPIO_0_tri_o_66),
        .IO(GPIO_0_tri_io[66]),
        .O(GPIO_0_tri_i_66),
        .T(GPIO_0_tri_t_66));
  IOBUF GPIO_0_tri_iobuf_67
       (.I(GPIO_0_tri_o_67),
        .IO(GPIO_0_tri_io[67]),
        .O(GPIO_0_tri_i_67),
        .T(GPIO_0_tri_t_67));
  IOBUF GPIO_0_tri_iobuf_68
       (.I(GPIO_0_tri_o_68),
        .IO(GPIO_0_tri_io[68]),
        .O(GPIO_0_tri_i_68),
        .T(GPIO_0_tri_t_68));
  IOBUF GPIO_0_tri_iobuf_69
       (.I(GPIO_0_tri_o_69),
        .IO(GPIO_0_tri_io[69]),
        .O(GPIO_0_tri_i_69),
        .T(GPIO_0_tri_t_69));
  IOBUF GPIO_0_tri_iobuf_7
       (.I(GPIO_0_tri_o_7),
        .IO(GPIO_0_tri_io[7]),
        .O(GPIO_0_tri_i_7),
        .T(GPIO_0_tri_t_7));
  IOBUF GPIO_0_tri_iobuf_70
       (.I(GPIO_0_tri_o_70),
        .IO(GPIO_0_tri_io[70]),
        .O(GPIO_0_tri_i_70),
        .T(GPIO_0_tri_t_70));
  IOBUF GPIO_0_tri_iobuf_71
       (.I(GPIO_0_tri_o_71),
        .IO(GPIO_0_tri_io[71]),
        .O(GPIO_0_tri_i_71),
        .T(GPIO_0_tri_t_71));
  IOBUF GPIO_0_tri_iobuf_72
       (.I(GPIO_0_tri_o_72),
        .IO(GPIO_0_tri_io[72]),
        .O(GPIO_0_tri_i_72),
        .T(GPIO_0_tri_t_72));
  IOBUF GPIO_0_tri_iobuf_73
       (.I(GPIO_0_tri_o_73),
        .IO(GPIO_0_tri_io[73]),
        .O(GPIO_0_tri_i_73),
        .T(GPIO_0_tri_t_73));
  IOBUF GPIO_0_tri_iobuf_74
       (.I(GPIO_0_tri_o_74),
        .IO(GPIO_0_tri_io[74]),
        .O(GPIO_0_tri_i_74),
        .T(GPIO_0_tri_t_74));
  IOBUF GPIO_0_tri_iobuf_75
       (.I(GPIO_0_tri_o_75),
        .IO(GPIO_0_tri_io[75]),
        .O(GPIO_0_tri_i_75),
        .T(GPIO_0_tri_t_75));
  IOBUF GPIO_0_tri_iobuf_76
       (.I(GPIO_0_tri_o_76),
        .IO(GPIO_0_tri_io[76]),
        .O(GPIO_0_tri_i_76),
        .T(GPIO_0_tri_t_76));
  IOBUF GPIO_0_tri_iobuf_77
       (.I(GPIO_0_tri_o_77),
        .IO(GPIO_0_tri_io[77]),
        .O(GPIO_0_tri_i_77),
        .T(GPIO_0_tri_t_77));
  IOBUF GPIO_0_tri_iobuf_78
       (.I(GPIO_0_tri_o_78),
        .IO(GPIO_0_tri_io[78]),
        .O(GPIO_0_tri_i_78),
        .T(GPIO_0_tri_t_78));
  IOBUF GPIO_0_tri_iobuf_79
       (.I(GPIO_0_tri_o_79),
        .IO(GPIO_0_tri_io[79]),
        .O(GPIO_0_tri_i_79),
        .T(GPIO_0_tri_t_79));
  IOBUF GPIO_0_tri_iobuf_8
       (.I(GPIO_0_tri_o_8),
        .IO(GPIO_0_tri_io[8]),
        .O(GPIO_0_tri_i_8),
        .T(GPIO_0_tri_t_8));
  IOBUF GPIO_0_tri_iobuf_80
       (.I(GPIO_0_tri_o_80),
        .IO(GPIO_0_tri_io[80]),
        .O(GPIO_0_tri_i_80),
        .T(GPIO_0_tri_t_80));
  IOBUF GPIO_0_tri_iobuf_81
       (.I(GPIO_0_tri_o_81),
        .IO(GPIO_0_tri_io[81]),
        .O(GPIO_0_tri_i_81),
        .T(GPIO_0_tri_t_81));
  IOBUF GPIO_0_tri_iobuf_82
       (.I(GPIO_0_tri_o_82),
        .IO(GPIO_0_tri_io[82]),
        .O(GPIO_0_tri_i_82),
        .T(GPIO_0_tri_t_82));
  IOBUF GPIO_0_tri_iobuf_83
       (.I(GPIO_0_tri_o_83),
        .IO(GPIO_0_tri_io[83]),
        .O(GPIO_0_tri_i_83),
        .T(GPIO_0_tri_t_83));
  IOBUF GPIO_0_tri_iobuf_84
       (.I(GPIO_0_tri_o_84),
        .IO(GPIO_0_tri_io[84]),
        .O(GPIO_0_tri_i_84),
        .T(GPIO_0_tri_t_84));
  IOBUF GPIO_0_tri_iobuf_85
       (.I(GPIO_0_tri_o_85),
        .IO(GPIO_0_tri_io[85]),
        .O(GPIO_0_tri_i_85),
        .T(GPIO_0_tri_t_85));
  IOBUF GPIO_0_tri_iobuf_86
       (.I(GPIO_0_tri_o_86),
        .IO(GPIO_0_tri_io[86]),
        .O(GPIO_0_tri_i_86),
        .T(GPIO_0_tri_t_86));
  IOBUF GPIO_0_tri_iobuf_87
       (.I(GPIO_0_tri_o_87),
        .IO(GPIO_0_tri_io[87]),
        .O(GPIO_0_tri_i_87),
        .T(GPIO_0_tri_t_87));
  IOBUF GPIO_0_tri_iobuf_88
       (.I(GPIO_0_tri_o_88),
        .IO(GPIO_0_tri_io[88]),
        .O(GPIO_0_tri_i_88),
        .T(GPIO_0_tri_t_88));
  IOBUF GPIO_0_tri_iobuf_89
       (.I(GPIO_0_tri_o_89),
        .IO(GPIO_0_tri_io[89]),
        .O(GPIO_0_tri_i_89),
        .T(GPIO_0_tri_t_89));
  IOBUF GPIO_0_tri_iobuf_9
       (.I(GPIO_0_tri_o_9),
        .IO(GPIO_0_tri_io[9]),
        .O(GPIO_0_tri_i_9),
        .T(GPIO_0_tri_t_9));
  IOBUF GPIO_0_tri_iobuf_90
       (.I(GPIO_0_tri_o_90),
        .IO(GPIO_0_tri_io[90]),
        .O(GPIO_0_tri_i_90),
        .T(GPIO_0_tri_t_90));
  IOBUF GPIO_0_tri_iobuf_91
       (.I(GPIO_0_tri_o_91),
        .IO(GPIO_0_tri_io[91]),
        .O(GPIO_0_tri_i_91),
        .T(GPIO_0_tri_t_91));
  IOBUF GPIO_0_tri_iobuf_92
       (.I(GPIO_0_tri_o_92),
        .IO(GPIO_0_tri_io[92]),
        .O(GPIO_0_tri_i_92),
        .T(GPIO_0_tri_t_92));
  IOBUF GPIO_0_tri_iobuf_93
       (.I(GPIO_0_tri_o_93),
        .IO(GPIO_0_tri_io[93]),
        .O(GPIO_0_tri_i_93),
        .T(GPIO_0_tri_t_93));
  IOBUF GPIO_0_tri_iobuf_94
       (.I(GPIO_0_tri_o_94),
        .IO(GPIO_0_tri_io[94]),
        .O(GPIO_0_tri_i_94),
        .T(GPIO_0_tri_t_94));
  MINTAKA MINTAKA_i
       (.GPIO_0_tri_i({GPIO_0_tri_i_94,GPIO_0_tri_i_93,GPIO_0_tri_i_92,GPIO_0_tri_i_91,GPIO_0_tri_i_90,GPIO_0_tri_i_89,GPIO_0_tri_i_88,GPIO_0_tri_i_87,GPIO_0_tri_i_86,GPIO_0_tri_i_85,GPIO_0_tri_i_84,GPIO_0_tri_i_83,GPIO_0_tri_i_82,GPIO_0_tri_i_81,GPIO_0_tri_i_80,GPIO_0_tri_i_79,GPIO_0_tri_i_78,GPIO_0_tri_i_77,GPIO_0_tri_i_76,GPIO_0_tri_i_75,GPIO_0_tri_i_74,GPIO_0_tri_i_73,GPIO_0_tri_i_72,GPIO_0_tri_i_71,GPIO_0_tri_i_70,GPIO_0_tri_i_69,GPIO_0_tri_i_68,GPIO_0_tri_i_67,GPIO_0_tri_i_66,GPIO_0_tri_i_65,GPIO_0_tri_i_64,GPIO_0_tri_i_63,GPIO_0_tri_i_62,GPIO_0_tri_i_61,GPIO_0_tri_i_60,GPIO_0_tri_i_59,GPIO_0_tri_i_58,GPIO_0_tri_i_57,GPIO_0_tri_i_56,GPIO_0_tri_i_55,GPIO_0_tri_i_54,GPIO_0_tri_i_53,GPIO_0_tri_i_52,GPIO_0_tri_i_51,GPIO_0_tri_i_50,GPIO_0_tri_i_49,GPIO_0_tri_i_48,GPIO_0_tri_i_47,GPIO_0_tri_i_46,GPIO_0_tri_i_45,GPIO_0_tri_i_44,GPIO_0_tri_i_43,GPIO_0_tri_i_42,GPIO_0_tri_i_41,GPIO_0_tri_i_40,GPIO_0_tri_i_39,GPIO_0_tri_i_38,GPIO_0_tri_i_37,GPIO_0_tri_i_36,GPIO_0_tri_i_35,GPIO_0_tri_i_34,GPIO_0_tri_i_33,GPIO_0_tri_i_32,GPIO_0_tri_i_31,GPIO_0_tri_i_30,GPIO_0_tri_i_29,GPIO_0_tri_i_28,GPIO_0_tri_i_27,GPIO_0_tri_i_26,GPIO_0_tri_i_25,GPIO_0_tri_i_24,GPIO_0_tri_i_23,GPIO_0_tri_i_22,GPIO_0_tri_i_21,GPIO_0_tri_i_20,GPIO_0_tri_i_19,GPIO_0_tri_i_18,GPIO_0_tri_i_17,GPIO_0_tri_i_16,GPIO_0_tri_i_15,GPIO_0_tri_i_14,GPIO_0_tri_i_13,GPIO_0_tri_i_12,GPIO_0_tri_i_11,GPIO_0_tri_i_10,GPIO_0_tri_i_9,GPIO_0_tri_i_8,GPIO_0_tri_i_7,GPIO_0_tri_i_6,GPIO_0_tri_i_5,GPIO_0_tri_i_4,GPIO_0_tri_i_3,GPIO_0_tri_i_2,GPIO_0_tri_i_1,GPIO_0_tri_i_0}),
        .GPIO_0_tri_o({GPIO_0_tri_o_94,GPIO_0_tri_o_93,GPIO_0_tri_o_92,GPIO_0_tri_o_91,GPIO_0_tri_o_90,GPIO_0_tri_o_89,GPIO_0_tri_o_88,GPIO_0_tri_o_87,GPIO_0_tri_o_86,GPIO_0_tri_o_85,GPIO_0_tri_o_84,GPIO_0_tri_o_83,GPIO_0_tri_o_82,GPIO_0_tri_o_81,GPIO_0_tri_o_80,GPIO_0_tri_o_79,GPIO_0_tri_o_78,GPIO_0_tri_o_77,GPIO_0_tri_o_76,GPIO_0_tri_o_75,GPIO_0_tri_o_74,GPIO_0_tri_o_73,GPIO_0_tri_o_72,GPIO_0_tri_o_71,GPIO_0_tri_o_70,GPIO_0_tri_o_69,GPIO_0_tri_o_68,GPIO_0_tri_o_67,GPIO_0_tri_o_66,GPIO_0_tri_o_65,GPIO_0_tri_o_64,GPIO_0_tri_o_63,GPIO_0_tri_o_62,GPIO_0_tri_o_61,GPIO_0_tri_o_60,GPIO_0_tri_o_59,GPIO_0_tri_o_58,GPIO_0_tri_o_57,GPIO_0_tri_o_56,GPIO_0_tri_o_55,GPIO_0_tri_o_54,GPIO_0_tri_o_53,GPIO_0_tri_o_52,GPIO_0_tri_o_51,GPIO_0_tri_o_50,GPIO_0_tri_o_49,GPIO_0_tri_o_48,GPIO_0_tri_o_47,GPIO_0_tri_o_46,GPIO_0_tri_o_45,GPIO_0_tri_o_44,GPIO_0_tri_o_43,GPIO_0_tri_o_42,GPIO_0_tri_o_41,GPIO_0_tri_o_40,GPIO_0_tri_o_39,GPIO_0_tri_o_38,GPIO_0_tri_o_37,GPIO_0_tri_o_36,GPIO_0_tri_o_35,GPIO_0_tri_o_34,GPIO_0_tri_o_33,GPIO_0_tri_o_32,GPIO_0_tri_o_31,GPIO_0_tri_o_30,GPIO_0_tri_o_29,GPIO_0_tri_o_28,GPIO_0_tri_o_27,GPIO_0_tri_o_26,GPIO_0_tri_o_25,GPIO_0_tri_o_24,GPIO_0_tri_o_23,GPIO_0_tri_o_22,GPIO_0_tri_o_21,GPIO_0_tri_o_20,GPIO_0_tri_o_19,GPIO_0_tri_o_18,GPIO_0_tri_o_17,GPIO_0_tri_o_16,GPIO_0_tri_o_15,GPIO_0_tri_o_14,GPIO_0_tri_o_13,GPIO_0_tri_o_12,GPIO_0_tri_o_11,GPIO_0_tri_o_10,GPIO_0_tri_o_9,GPIO_0_tri_o_8,GPIO_0_tri_o_7,GPIO_0_tri_o_6,GPIO_0_tri_o_5,GPIO_0_tri_o_4,GPIO_0_tri_o_3,GPIO_0_tri_o_2,GPIO_0_tri_o_1,GPIO_0_tri_o_0}),
        .GPIO_0_tri_t({GPIO_0_tri_t_94,GPIO_0_tri_t_93,GPIO_0_tri_t_92,GPIO_0_tri_t_91,GPIO_0_tri_t_90,GPIO_0_tri_t_89,GPIO_0_tri_t_88,GPIO_0_tri_t_87,GPIO_0_tri_t_86,GPIO_0_tri_t_85,GPIO_0_tri_t_84,GPIO_0_tri_t_83,GPIO_0_tri_t_82,GPIO_0_tri_t_81,GPIO_0_tri_t_80,GPIO_0_tri_t_79,GPIO_0_tri_t_78,GPIO_0_tri_t_77,GPIO_0_tri_t_76,GPIO_0_tri_t_75,GPIO_0_tri_t_74,GPIO_0_tri_t_73,GPIO_0_tri_t_72,GPIO_0_tri_t_71,GPIO_0_tri_t_70,GPIO_0_tri_t_69,GPIO_0_tri_t_68,GPIO_0_tri_t_67,GPIO_0_tri_t_66,GPIO_0_tri_t_65,GPIO_0_tri_t_64,GPIO_0_tri_t_63,GPIO_0_tri_t_62,GPIO_0_tri_t_61,GPIO_0_tri_t_60,GPIO_0_tri_t_59,GPIO_0_tri_t_58,GPIO_0_tri_t_57,GPIO_0_tri_t_56,GPIO_0_tri_t_55,GPIO_0_tri_t_54,GPIO_0_tri_t_53,GPIO_0_tri_t_52,GPIO_0_tri_t_51,GPIO_0_tri_t_50,GPIO_0_tri_t_49,GPIO_0_tri_t_48,GPIO_0_tri_t_47,GPIO_0_tri_t_46,GPIO_0_tri_t_45,GPIO_0_tri_t_44,GPIO_0_tri_t_43,GPIO_0_tri_t_42,GPIO_0_tri_t_41,GPIO_0_tri_t_40,GPIO_0_tri_t_39,GPIO_0_tri_t_38,GPIO_0_tri_t_37,GPIO_0_tri_t_36,GPIO_0_tri_t_35,GPIO_0_tri_t_34,GPIO_0_tri_t_33,GPIO_0_tri_t_32,GPIO_0_tri_t_31,GPIO_0_tri_t_30,GPIO_0_tri_t_29,GPIO_0_tri_t_28,GPIO_0_tri_t_27,GPIO_0_tri_t_26,GPIO_0_tri_t_25,GPIO_0_tri_t_24,GPIO_0_tri_t_23,GPIO_0_tri_t_22,GPIO_0_tri_t_21,GPIO_0_tri_t_20,GPIO_0_tri_t_19,GPIO_0_tri_t_18,GPIO_0_tri_t_17,GPIO_0_tri_t_16,GPIO_0_tri_t_15,GPIO_0_tri_t_14,GPIO_0_tri_t_13,GPIO_0_tri_t_12,GPIO_0_tri_t_11,GPIO_0_tri_t_10,GPIO_0_tri_t_9,GPIO_0_tri_t_8,GPIO_0_tri_t_7,GPIO_0_tri_t_6,GPIO_0_tri_t_5,GPIO_0_tri_t_4,GPIO_0_tri_t_3,GPIO_0_tri_t_2,GPIO_0_tri_t_1,GPIO_0_tri_t_0}),
        .M00_AXI_TOP_CTRL_CMN_araddr(M00_AXI_TOP_CTRL_CMN_araddr),
        .M00_AXI_TOP_CTRL_CMN_arprot(M00_AXI_TOP_CTRL_CMN_arprot),
        .M00_AXI_TOP_CTRL_CMN_arready(M00_AXI_TOP_CTRL_CMN_arready),
        .M00_AXI_TOP_CTRL_CMN_arvalid(M00_AXI_TOP_CTRL_CMN_arvalid),
        .M00_AXI_TOP_CTRL_CMN_awaddr(M00_AXI_TOP_CTRL_CMN_awaddr),
        .M00_AXI_TOP_CTRL_CMN_awprot(M00_AXI_TOP_CTRL_CMN_awprot),
        .M00_AXI_TOP_CTRL_CMN_awready(M00_AXI_TOP_CTRL_CMN_awready),
        .M00_AXI_TOP_CTRL_CMN_awvalid(M00_AXI_TOP_CTRL_CMN_awvalid),
        .M00_AXI_TOP_CTRL_CMN_bready(M00_AXI_TOP_CTRL_CMN_bready),
        .M00_AXI_TOP_CTRL_CMN_bresp(M00_AXI_TOP_CTRL_CMN_bresp),
        .M00_AXI_TOP_CTRL_CMN_bvalid(M00_AXI_TOP_CTRL_CMN_bvalid),
        .M00_AXI_TOP_CTRL_CMN_rdata(M00_AXI_TOP_CTRL_CMN_rdata),
        .M00_AXI_TOP_CTRL_CMN_rready(M00_AXI_TOP_CTRL_CMN_rready),
        .M00_AXI_TOP_CTRL_CMN_rresp(M00_AXI_TOP_CTRL_CMN_rresp),
        .M00_AXI_TOP_CTRL_CMN_rvalid(M00_AXI_TOP_CTRL_CMN_rvalid),
        .M00_AXI_TOP_CTRL_CMN_wdata(M00_AXI_TOP_CTRL_CMN_wdata),
        .M00_AXI_TOP_CTRL_CMN_wready(M00_AXI_TOP_CTRL_CMN_wready),
        .M00_AXI_TOP_CTRL_CMN_wstrb(M00_AXI_TOP_CTRL_CMN_wstrb),
        .M00_AXI_TOP_CTRL_CMN_wvalid(M00_AXI_TOP_CTRL_CMN_wvalid),
        .M00_AXI_TOP_CTRL_HW_araddr(M00_AXI_TOP_CTRL_HW_araddr),
        .M00_AXI_TOP_CTRL_HW_arprot(M00_AXI_TOP_CTRL_HW_arprot),
        .M00_AXI_TOP_CTRL_HW_arready(M00_AXI_TOP_CTRL_HW_arready),
        .M00_AXI_TOP_CTRL_HW_arvalid(M00_AXI_TOP_CTRL_HW_arvalid),
        .M00_AXI_TOP_CTRL_HW_awaddr(M00_AXI_TOP_CTRL_HW_awaddr),
        .M00_AXI_TOP_CTRL_HW_awprot(M00_AXI_TOP_CTRL_HW_awprot),
        .M00_AXI_TOP_CTRL_HW_awready(M00_AXI_TOP_CTRL_HW_awready),
        .M00_AXI_TOP_CTRL_HW_awvalid(M00_AXI_TOP_CTRL_HW_awvalid),
        .M00_AXI_TOP_CTRL_HW_bready(M00_AXI_TOP_CTRL_HW_bready),
        .M00_AXI_TOP_CTRL_HW_bresp(M00_AXI_TOP_CTRL_HW_bresp),
        .M00_AXI_TOP_CTRL_HW_bvalid(M00_AXI_TOP_CTRL_HW_bvalid),
        .M00_AXI_TOP_CTRL_HW_rdata(M00_AXI_TOP_CTRL_HW_rdata),
        .M00_AXI_TOP_CTRL_HW_rready(M00_AXI_TOP_CTRL_HW_rready),
        .M00_AXI_TOP_CTRL_HW_rresp(M00_AXI_TOP_CTRL_HW_rresp),
        .M00_AXI_TOP_CTRL_HW_rvalid(M00_AXI_TOP_CTRL_HW_rvalid),
        .M00_AXI_TOP_CTRL_HW_wdata(M00_AXI_TOP_CTRL_HW_wdata),
        .M00_AXI_TOP_CTRL_HW_wready(M00_AXI_TOP_CTRL_HW_wready),
        .M00_AXI_TOP_CTRL_HW_wstrb(M00_AXI_TOP_CTRL_HW_wstrb),
        .M00_AXI_TOP_CTRL_HW_wvalid(M00_AXI_TOP_CTRL_HW_wvalid),
        .M00_AXI_TOP_CTRL_INTR_araddr(M00_AXI_TOP_CTRL_INTR_araddr),
        .M00_AXI_TOP_CTRL_INTR_arprot(M00_AXI_TOP_CTRL_INTR_arprot),
        .M00_AXI_TOP_CTRL_INTR_arready(M00_AXI_TOP_CTRL_INTR_arready),
        .M00_AXI_TOP_CTRL_INTR_arvalid(M00_AXI_TOP_CTRL_INTR_arvalid),
        .M00_AXI_TOP_CTRL_INTR_awaddr(M00_AXI_TOP_CTRL_INTR_awaddr),
        .M00_AXI_TOP_CTRL_INTR_awprot(M00_AXI_TOP_CTRL_INTR_awprot),
        .M00_AXI_TOP_CTRL_INTR_awready(M00_AXI_TOP_CTRL_INTR_awready),
        .M00_AXI_TOP_CTRL_INTR_awvalid(M00_AXI_TOP_CTRL_INTR_awvalid),
        .M00_AXI_TOP_CTRL_INTR_bready(M00_AXI_TOP_CTRL_INTR_bready),
        .M00_AXI_TOP_CTRL_INTR_bresp(M00_AXI_TOP_CTRL_INTR_bresp),
        .M00_AXI_TOP_CTRL_INTR_bvalid(M00_AXI_TOP_CTRL_INTR_bvalid),
        .M00_AXI_TOP_CTRL_INTR_rdata(M00_AXI_TOP_CTRL_INTR_rdata),
        .M00_AXI_TOP_CTRL_INTR_rready(M00_AXI_TOP_CTRL_INTR_rready),
        .M00_AXI_TOP_CTRL_INTR_rresp(M00_AXI_TOP_CTRL_INTR_rresp),
        .M00_AXI_TOP_CTRL_INTR_rvalid(M00_AXI_TOP_CTRL_INTR_rvalid),
        .M00_AXI_TOP_CTRL_INTR_wdata(M00_AXI_TOP_CTRL_INTR_wdata),
        .M00_AXI_TOP_CTRL_INTR_wready(M00_AXI_TOP_CTRL_INTR_wready),
        .M00_AXI_TOP_CTRL_INTR_wstrb(M00_AXI_TOP_CTRL_INTR_wstrb),
        .M00_AXI_TOP_CTRL_INTR_wvalid(M00_AXI_TOP_CTRL_INTR_wvalid),
        .M00_AXI_TOP_CTRL_TEST_araddr(M00_AXI_TOP_CTRL_TEST_araddr),
        .M00_AXI_TOP_CTRL_TEST_arprot(M00_AXI_TOP_CTRL_TEST_arprot),
        .M00_AXI_TOP_CTRL_TEST_arready(M00_AXI_TOP_CTRL_TEST_arready),
        .M00_AXI_TOP_CTRL_TEST_arvalid(M00_AXI_TOP_CTRL_TEST_arvalid),
        .M00_AXI_TOP_CTRL_TEST_awaddr(M00_AXI_TOP_CTRL_TEST_awaddr),
        .M00_AXI_TOP_CTRL_TEST_awprot(M00_AXI_TOP_CTRL_TEST_awprot),
        .M00_AXI_TOP_CTRL_TEST_awready(M00_AXI_TOP_CTRL_TEST_awready),
        .M00_AXI_TOP_CTRL_TEST_awvalid(M00_AXI_TOP_CTRL_TEST_awvalid),
        .M00_AXI_TOP_CTRL_TEST_bready(M00_AXI_TOP_CTRL_TEST_bready),
        .M00_AXI_TOP_CTRL_TEST_bresp(M00_AXI_TOP_CTRL_TEST_bresp),
        .M00_AXI_TOP_CTRL_TEST_bvalid(M00_AXI_TOP_CTRL_TEST_bvalid),
        .M00_AXI_TOP_CTRL_TEST_rdata(M00_AXI_TOP_CTRL_TEST_rdata),
        .M00_AXI_TOP_CTRL_TEST_rready(M00_AXI_TOP_CTRL_TEST_rready),
        .M00_AXI_TOP_CTRL_TEST_rresp(M00_AXI_TOP_CTRL_TEST_rresp),
        .M00_AXI_TOP_CTRL_TEST_rvalid(M00_AXI_TOP_CTRL_TEST_rvalid),
        .M00_AXI_TOP_CTRL_TEST_wdata(M00_AXI_TOP_CTRL_TEST_wdata),
        .M00_AXI_TOP_CTRL_TEST_wready(M00_AXI_TOP_CTRL_TEST_wready),
        .M00_AXI_TOP_CTRL_TEST_wstrb(M00_AXI_TOP_CTRL_TEST_wstrb),
        .M00_AXI_TOP_CTRL_TEST_wvalid(M00_AXI_TOP_CTRL_TEST_wvalid),
        .RF_BRAM_PORTB_addr(RF_BRAM_PORTB_addr),
        .RF_BRAM_PORTB_clk(RF_BRAM_PORTB_clk),
        .RF_BRAM_PORTB_din(RF_BRAM_PORTB_din),
        .RF_BRAM_PORTB_dout(RF_BRAM_PORTB_dout),
        .RF_BRAM_PORTB_en(RF_BRAM_PORTB_en),
        .RF_BRAM_PORTB_rst(RF_BRAM_PORTB_rst),
        .RF_BRAM_PORTB_we(RF_BRAM_PORTB_we),
        .T224_m00_adc0_i_tdata(T224_m00_adc0_i_tdata),
        .T224_m00_adc0_i_tready(T224_m00_adc0_i_tready),
        .T224_m00_adc0_i_tvalid(T224_m00_adc0_i_tvalid),
        .T224_m01_adc0_q_tdata(T224_m01_adc0_q_tdata),
        .T224_m01_adc0_q_tready(T224_m01_adc0_q_tready),
        .T224_m01_adc0_q_tvalid(T224_m01_adc0_q_tvalid),
        .T224_m02_adc1_i_tdata(T224_m02_adc1_i_tdata),
        .T224_m02_adc1_i_tready(T224_m02_adc1_i_tready),
        .T224_m02_adc1_i_tvalid(T224_m02_adc1_i_tvalid),
        .T224_m03_adc1_q_tdata(T224_m03_adc1_q_tdata),
        .T224_m03_adc1_q_tready(T224_m03_adc1_q_tready),
        .T224_m03_adc1_q_tvalid(T224_m03_adc1_q_tvalid),
        .T225_m10_adc2_i_tdata(T225_m10_adc2_i_tdata),
        .T225_m10_adc2_i_tready(T225_m10_adc2_i_tready),
        .T225_m10_adc2_i_tvalid(T225_m10_adc2_i_tvalid),
        .T225_m11_adc2_q_tdata(T225_m11_adc2_q_tdata),
        .T225_m11_adc2_q_tready(T225_m11_adc2_q_tready),
        .T225_m11_adc2_q_tvalid(T225_m11_adc2_q_tvalid),
        .T225_m12_adc3_i_tdata(T225_m12_adc3_i_tdata),
        .T225_m12_adc3_i_tready(T225_m12_adc3_i_tready),
        .T225_m12_adc3_i_tvalid(T225_m12_adc3_i_tvalid),
        .T225_m13_adc3_q_tdata(T225_m13_adc3_q_tdata),
        .T225_m13_adc3_q_tready(T225_m13_adc3_q_tready),
        .T225_m13_adc3_q_tvalid(T225_m13_adc3_q_tvalid),
        .T226_m20_adc4_i_tdata(T226_m20_adc4_i_tdata),
        .T226_m20_adc4_i_tready(T226_m20_adc4_i_tready),
        .T226_m20_adc4_i_tvalid(T226_m20_adc4_i_tvalid),
        .T226_m21_adc4_q_tdata(T226_m21_adc4_q_tdata),
        .T226_m21_adc4_q_tready(T226_m21_adc4_q_tready),
        .T226_m21_adc4_q_tvalid(T226_m21_adc4_q_tvalid),
        .T226_m22_adc5_i_tdata(T226_m22_adc5_i_tdata),
        .T226_m22_adc5_i_tready(T226_m22_adc5_i_tready),
        .T226_m22_adc5_i_tvalid(T226_m22_adc5_i_tvalid),
        .T226_m23_adc5_q_tdata(T226_m23_adc5_q_tdata),
        .T226_m23_adc5_q_tready(T226_m23_adc5_q_tready),
        .T226_m23_adc5_q_tvalid(T226_m23_adc5_q_tvalid),
        .T227_m30_adc6_i_tdata(T227_m30_adc6_i_tdata),
        .T227_m30_adc6_i_tready(T227_m30_adc6_i_tready),
        .T227_m30_adc6_i_tvalid(T227_m30_adc6_i_tvalid),
        .T227_m31_adc6_q_tdata(T227_m31_adc6_q_tdata),
        .T227_m31_adc6_q_tready(T227_m31_adc6_q_tready),
        .T227_m31_adc6_q_tvalid(T227_m31_adc6_q_tvalid),
        .T227_m32_adc7_i_tdata(T227_m32_adc7_i_tdata),
        .T227_m32_adc7_i_tready(T227_m32_adc7_i_tready),
        .T227_m32_adc7_i_tvalid(T227_m32_adc7_i_tvalid),
        .T227_m33_adc7_q_tdata(T227_m33_adc7_q_tdata),
        .T227_m33_adc7_q_tready(T227_m33_adc7_q_tready),
        .T227_m33_adc7_q_tvalid(T227_m33_adc7_q_tvalid),
        .T228_s00_dac0_tdata(T228_s00_dac0_tdata),
        .T228_s00_dac0_tready(T228_s00_dac0_tready),
        .T228_s00_dac0_tvalid(T228_s00_dac0_tvalid),
        .T228_s02_dac1_tdata(T228_s02_dac1_tdata),
        .T228_s02_dac1_tready(T228_s02_dac1_tready),
        .T228_s02_dac1_tvalid(T228_s02_dac1_tvalid),
        .T229_s10_dac2_tdata(T229_s10_dac2_tdata),
        .T229_s10_dac2_tready(T229_s10_dac2_tready),
        .T229_s10_dac2_tvalid(T229_s10_dac2_tvalid),
        .T229_s12_dac3_tdata(T229_s12_dac3_tdata),
        .T229_s12_dac3_tready(T229_s12_dac3_tready),
        .T229_s12_dac3_tvalid(T229_s12_dac3_tvalid),
        .T230_s20_dac4_tdata(T230_s20_dac4_tdata),
        .T230_s20_dac4_tready(T230_s20_dac4_tready),
        .T230_s20_dac4_tvalid(T230_s20_dac4_tvalid),
        .T230_s22_dac5_tdata(T230_s22_dac5_tdata),
        .T230_s22_dac5_tready(T230_s22_dac5_tready),
        .T230_s22_dac5_tvalid(T230_s22_dac5_tvalid),
        .T231_s30_dac6_tdata(T231_s30_dac6_tdata),
        .T231_s30_dac6_tready(T231_s30_dac6_tready),
        .T231_s30_dac6_tvalid(T231_s30_dac6_tvalid),
        .T231_s32_dac7_tdata(T231_s32_dac7_tdata),
        .T231_s32_dac7_tready(T231_s32_dac7_tready),
        .T231_s32_dac7_tvalid(T231_s32_dac7_tvalid),
        .adc1_clk_clk_n(adc1_clk_clk_n),
        .adc1_clk_clk_p(adc1_clk_clk_p),
        .adc_over_range(adc_over_range),
        .adc_over_threshold1(adc_over_threshold1),
        .adc_over_threshold2(adc_over_threshold2),
        .adc_over_voltage(adc_over_voltage),
        .axi_aresetn_100M(axi_aresetn_100M),
        .axi_clk_100M(axi_clk_100M),
        .axis_aresetn(axis_aresetn),
        .clk_122p88(clk_122p88),
        .clk_15p36(clk_15p36),
        .clk_245p76(clk_245p76),
        .clk_368p64(clk_368p64),
        .clk_491p52(clk_491p52),
        .dac2_clk_clk_n(dac2_clk_clk_n),
        .dac2_clk_clk_p(dac2_clk_clk_p),
        .emio_spi0_m_i(emio_spi0_m_i),
        .emio_spi0_m_o(emio_spi0_m_o),
        .emio_spi0_sclk_o(emio_spi0_sclk_o),
        .emio_spi0_ss_o_n(emio_spi0_ss_o_n),
        .iic_sfp0_scl_i(iic_sfp0_scl_i),
        .iic_sfp0_scl_o(iic_sfp0_scl_o),
        .iic_sfp0_scl_t(iic_sfp0_scl_t),
        .iic_sfp0_sda_i(iic_sfp0_sda_i),
        .iic_sfp0_sda_o(iic_sfp0_sda_o),
        .iic_sfp0_sda_t(iic_sfp0_sda_t),
        .iic_sfp1_scl_i(iic_sfp1_scl_i),
        .iic_sfp1_scl_o(iic_sfp1_scl_o),
        .iic_sfp1_scl_t(iic_sfp1_scl_t),
        .iic_sfp1_sda_i(iic_sfp1_sda_i),
        .iic_sfp1_sda_o(iic_sfp1_sda_o),
        .iic_sfp1_sda_t(iic_sfp1_sda_t),
        .iic_sfp2_scl_i(iic_sfp2_scl_i),
        .iic_sfp2_scl_o(iic_sfp2_scl_o),
        .iic_sfp2_scl_t(iic_sfp2_scl_t),
        .iic_sfp2_sda_i(iic_sfp2_sda_i),
        .iic_sfp2_sda_o(iic_sfp2_sda_o),
        .iic_sfp2_sda_t(iic_sfp2_sda_t),
        .iic_sfp3_scl_i(iic_sfp3_scl_i),
        .iic_sfp3_scl_o(iic_sfp3_scl_o),
        .iic_sfp3_scl_t(iic_sfp3_scl_t),
        .iic_sfp3_sda_i(iic_sfp3_sda_i),
        .iic_sfp3_sda_o(iic_sfp3_sda_o),
        .iic_sfp3_sda_t(iic_sfp3_sda_t),
        .irq_adc_dac(irq_adc_dac),
        .pl_ps_irq0(pl_ps_irq0),
        .pl_ps_irq1(pl_ps_irq1),
        .pl_refclk1_clk_n(pl_refclk1_clk_n),
        .pl_refclk1_clk_p(pl_refclk1_clk_p),
        .pl_refclk1_locked(pl_refclk1_locked),
        .pl_refclk2_clk_n(pl_refclk2_clk_n),
        .pl_refclk2_clk_p(pl_refclk2_clk_p),
        .pl_refclk2_locked(pl_refclk2_locked),
        .pl_sysref_clk_n(pl_sysref_clk_n),
        .pl_sysref_clk_p(pl_sysref_clk_p),
        .sysref_in_diff_n(sysref_in_diff_n),
        .sysref_in_diff_p(sysref_in_diff_p));
  IOBUF iic_sfp0_scl_iobuf
       (.I(iic_sfp0_scl_o),
        .IO(iic_sfp0_scl_io),
        .O(iic_sfp0_scl_i),
        .T(iic_sfp0_scl_t));
  IOBUF iic_sfp0_sda_iobuf
       (.I(iic_sfp0_sda_o),
        .IO(iic_sfp0_sda_io),
        .O(iic_sfp0_sda_i),
        .T(iic_sfp0_sda_t));
  IOBUF iic_sfp1_scl_iobuf
       (.I(iic_sfp1_scl_o),
        .IO(iic_sfp1_scl_io),
        .O(iic_sfp1_scl_i),
        .T(iic_sfp1_scl_t));
  IOBUF iic_sfp1_sda_iobuf
       (.I(iic_sfp1_sda_o),
        .IO(iic_sfp1_sda_io),
        .O(iic_sfp1_sda_i),
        .T(iic_sfp1_sda_t));
  IOBUF iic_sfp2_scl_iobuf
       (.I(iic_sfp2_scl_o),
        .IO(iic_sfp2_scl_io),
        .O(iic_sfp2_scl_i),
        .T(iic_sfp2_scl_t));
  IOBUF iic_sfp2_sda_iobuf
       (.I(iic_sfp2_sda_o),
        .IO(iic_sfp2_sda_io),
        .O(iic_sfp2_sda_i),
        .T(iic_sfp2_sda_t));
  IOBUF iic_sfp3_scl_iobuf
       (.I(iic_sfp3_scl_o),
        .IO(iic_sfp3_scl_io),
        .O(iic_sfp3_scl_i),
        .T(iic_sfp3_scl_t));
  IOBUF iic_sfp3_sda_iobuf
       (.I(iic_sfp3_sda_o),
        .IO(iic_sfp3_sda_io),
        .O(iic_sfp3_sda_i),
        .T(iic_sfp3_sda_t));
endmodule
