// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : Fei Qin                                                     //
// Date         : 02/07/21                                                     //
// File         : bd_wrapper.v                                                   //
// Design       :                                                             //
// Purpose      : Vernon Board Controls                                           //
// Device       : xczu47dr-fsve1156-2-i                                       //
// -------------------------------------------------------------------------- //
`timescale 1 ps / 1 ps

module jb_vernon_bd_wrapper #(
    parameter N_CARRIERS                = 2,
    parameter N_ANTENNAS                = 8,
    parameter AXI_ADDR_WIDTH_TOP_CTRL   = 13,
	parameter N_ETH_PORTS               = 1
) (
    input                               pl_refclk1_p,
    input                               pl_refclk1_n,
    input                               pl_refclk2_p,
    input                               pl_refclk2_n,
    output  logic                       pl_refclk1_locked,
    output  logic                       pl_refclk2_locked,
	input                               pl_ptpclk_p,
	input                               pl_ptpclk_n,
    output  logic                       axi_clk,
    output  logic                       axi_aresetn,
	output  logic                       reg_top_reset,
    output  logic                       clk_15p36,
    output  logic                       clk_122p88,
    output  logic                       clk_245p76,
    output  logic                       clk_368p64,
    output  logic                       clk_491p52,
	output  logic                       clk_400M,
	output  logic                       ptp_clk,
	input                               one_pps_in,
	input                               dac_shutdown,
	input                               gt_ref_clk_clk_p,
	input                               gt_ref_clk_clk_n,
    input                               fh_sfp_rx_gt_port_0_n,
    input                               fh_sfp_rx_gt_port_0_p,
    output                              fh_sfp_tx_gt_port_0_n,
    output                              fh_sfp_tx_gt_port_0_p,
    output  logic                       axis_aresetn,
	input                               adc1_clk_clk_p,
	input                               adc1_clk_clk_n,
	input                               dac2_clk_clk_p,
	input                               dac2_clk_clk_n,
    input                               ana_sysref_p,
    input                               ana_sysref_n,
    input                               pl_sysref_n,
    input                               pl_sysref_p,
    input           [7:0]               pl_ps_irq0,
    input                               uart1_rxd,      	
    output  logic                       uart1_txd, 
    output  logic                       irq_adc_dac,
    output  logic   [31:0]              o_fifo_dac_tdata,
    output  logic                       o_fifo_dac_tvalid,
    output  logic   [N_ANTENNAS-1:0]    adc_over_threshold1,
    output  logic   [N_ANTENNAS-1:0]    adc_over_threshold2,
    output  logic   [N_ANTENNAS-1:0]    adc_over_range,
    output  logic   [N_ANTENNAS-1:0]    adc_over_voltage,
    input                               emio_spi0_m_i,
    output  logic                       emio_spi0_m_o,
    output  logic                       emio_spi0_sclk_o,
    output  logic   [7:0]               emio_spi0_ss_o_n,
    input                               iic_sfp_scl_i [3:0],
    output  logic                       iic_sfp_scl_o [3:0],
    output  logic                       iic_sfp_scl_t [3:0],
    input                               iic_sfp_sda_i [3:0],
    output  logic                       iic_sfp_sda_o [3:0],
    output  logic                       iic_sfp_sda_t [3:0],
    input           [94:0]              GPIO_0_tri_i,
    output logic    [94:0]              GPIO_0_tri_o,
    output logic    [94:0]              GPIO_0_tri_t,
    output                              dbgbuf_porta_rst,
    output                              dbgbuf_porta_clk,
    jb_ram_sp_if.host                   IFP_dbgbuf_porta,

    output                              IFP_iwavebuf_porta_rst,
    output                              IFP_iwavebuf_porta_clk,
    jb_ram_sp_if.host                   IFP_iwavebuf_porta,

    //jb_axi4_stream_if.master            IFP_srx         [7:0],
    //jb_axi4_stream_if.master            IFP_srx_copy    [1:0][3:0],
	
    jb_axi4_stream_if.slave             IFP_cfr_s_axis_din,         // 256,1
    jb_axi4_stream_if.master            IFP_cfr_m_axis_dout,        // 256,1

    jb_axi4_stream_if.slave             IFP_dpd_s_axis_din,         // 256,32
    jb_axi4_stream_if.master            IFP_dpd_m_axis_dout,        // 256,32
    jb_dpd_srx_if.dpd                   IFP_dpd_srx,
    //FH Interfaces 
    jb_fh_misc_if.fh                    IFP_fh_misc,
    jb_fh_cc_timing_if.fh               IFP_fh_cc_timing [N_CARRIERS-1:0],
    jb_cplane_bid_if.fh                 IFP_dl_defm_cplane_bid [N_ANTENNAS-1:0],
    jb_cplane_bid_if.fh                 IFP_ul_fram_cplane_bid [N_ANTENNAS-1:0],
    jb_prach_cplane_if.fh               IFP_prach_cplane,   // adc inte
    jb_oran_lphy_ctrl_if.lphy           IFP_oran_lphy_ctrl,
    jb_oran_lphy_stat_if.cnts           IFP_oran_lphy_stat,
    jb_xran_header_ecpri_if.fh          IFP_xran_header_ecpri[N_ETH_PORTS-1:0],
    jb_xran_header_app_cmn_if.fh        IFP_xran_header_app_cmn[N_ETH_PORTS-1:0],
    jb_xran_header_app_section_if.fh    IFP_xran_header_app_section[N_ETH_PORTS-1:0],

    jb_axi4_stream_if.master            IFP_dl_defm_uplane  [1:0][3:0],// Radio IP DL
    jb_axi4_stream_if.slave             IFP_ul_fram_uplane  [1:0][3:0],
    output  [N_ANTENNAS-1:0] [24:0]     fh_ul_fram_data_req,	
    jb_axi4_stream_if.slave             IFP_prach_uplane,      // Prach U Plane
    jb_axi4_stream_if.slave             IFP_unsol_ul_uplane,   // Radio IP UL
    jb_axi4_stream_if.master            IFP_xran_unsup[N_ETH_PORTS-1:0],
    jb_axi4_stream_if.master            IFP_xran_bweight[N_ETH_PORTS-1:0],
	
    jb_axi4_stream_if.master            IFP_ul[1:0][3:0],           // ADCs
    jb_axi4_stream_if.slave             IFP_dl[1:0][3:0],           // DACs
    jb_axi4_lite_if.master              IFP_cmn_axi,                // ADDR_WIDTH=32, DATA_WIDTH=32
	jb_axi4_lite_if.master              IFP_dl_dfe_axi,             // ADDR_WIDTH=32, DATA_WIDTH=32               
    jb_axi4_lite_if.master              IFP_test_axi,               // ADDR_WIDTH=32, DATA_WIDTH=32
    jb_axi4_lite_if.master              IFP_hw_axi,                 // ADDR_WIDTH=32, DATA_WIDTH=32
    jb_axi4_lite_if.master              IFP_intr_axi,               // ADDR_WIDTH=32, DATA_WIDTH=32
    jb_axi4_lite_if.master              IFP_lphy_axi,               // ADDR_WIDTH=32, DATA_WIDTH=32
    jb_axi4_lite_if.master              IFP_ul_dfe_axi              // ADDR_WIDTH=32, DATA_WIDTH=32	
);

	assign IFP_dl_defm_uplane[1][0].tdata  = IFP_dl_defm_uplane[0][0].tdata ; 
	assign IFP_dl_defm_uplane[1][0].tkeep  = IFP_dl_defm_uplane[0][0].tkeep ;
	assign IFP_dl_defm_uplane[1][0].tlast  = IFP_dl_defm_uplane[0][0].tlast ;
	assign IFP_dl_defm_uplane[1][0].tuser  = IFP_dl_defm_uplane[0][0].tuser ;
	assign IFP_dl_defm_uplane[1][0].tvalid = IFP_dl_defm_uplane[0][0].tvalid;
	
	assign IFP_dl_defm_uplane[1][1].tdata  = IFP_dl_defm_uplane[0][1].tdata ; 
	assign IFP_dl_defm_uplane[1][1].tkeep  = IFP_dl_defm_uplane[0][1].tkeep ;
	assign IFP_dl_defm_uplane[1][1].tlast  = IFP_dl_defm_uplane[0][1].tlast ;
	assign IFP_dl_defm_uplane[1][1].tuser  = IFP_dl_defm_uplane[0][1].tuser ;
	assign IFP_dl_defm_uplane[1][1].tvalid = IFP_dl_defm_uplane[0][1].tvalid;	
	
	assign IFP_dl_defm_uplane[1][2].tdata  = IFP_dl_defm_uplane[0][2].tdata ; 
	assign IFP_dl_defm_uplane[1][2].tkeep  = IFP_dl_defm_uplane[0][2].tkeep ;
	assign IFP_dl_defm_uplane[1][2].tlast  = IFP_dl_defm_uplane[0][2].tlast ;
	assign IFP_dl_defm_uplane[1][2].tuser  = IFP_dl_defm_uplane[0][2].tuser ;
	assign IFP_dl_defm_uplane[1][2].tvalid = IFP_dl_defm_uplane[0][2].tvalid;
	
	assign IFP_dl_defm_uplane[1][3].tdata  = IFP_dl_defm_uplane[0][3].tdata ; 
	assign IFP_dl_defm_uplane[1][3].tkeep  = IFP_dl_defm_uplane[0][3].tkeep ;
	assign IFP_dl_defm_uplane[1][3].tlast  = IFP_dl_defm_uplane[0][3].tlast ;
	assign IFP_dl_defm_uplane[1][3].tuser  = IFP_dl_defm_uplane[0][3].tuser ;
	assign IFP_dl_defm_uplane[1][3].tvalid = IFP_dl_defm_uplane[0][3].tvalid;
								 
    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
    localparam  T224_M00_ADC0 = 0,  ADC0 = T224_M00_ADC0;
    localparam  T224_M02_ADC1 = 1,  ADC1 = T224_M02_ADC1;
    localparam  T225_M10_ADC2 = 2,  ADC2 = T225_M10_ADC2;
    localparam  T225_M12_ADC3 = 3,  ADC3 = T225_M12_ADC3;
    localparam  T226_M20_ADC4 = 4,  ADC4 = T226_M20_ADC4;
    localparam  T226_M22_ADC5 = 5,  ADC5 = T226_M22_ADC5;
    localparam  T227_M30_ADC6 = 6,  ADC6 = T227_M30_ADC6;
    localparam  T227_M32_ADC7 = 7,  ADC7 = T227_M32_ADC7;

    localparam  T224_M01_ADC0 = 0;
    localparam  T224_M03_ADC1 = 1;
    localparam  T225_M11_ADC2 = 2;
    localparam  T225_M13_ADC3 = 3;
    localparam  T226_M21_ADC4 = 4;
    localparam  T226_M23_ADC5 = 5;
    localparam  T227_M31_ADC6 = 6;
    localparam  T227_M33_ADC7 = 7;

    localparam  T228_S00_DAC0 = 0,  DAC0 = T228_S00_DAC0;
    localparam  T228_S02_DAC1 = 1,  DAC1 = T228_S02_DAC1;
    localparam  T229_S10_DAC2 = 2,  DAC2 = T229_S10_DAC2;
    localparam  T229_S12_DAC3 = 3,  DAC3 = T229_S12_DAC3;
    localparam  T230_S20_DAC4 = 4,  DAC4 = T230_S20_DAC4;
    localparam  T230_S22_DAC5 = 5,  DAC5 = T230_S22_DAC5;
    localparam  T231_S30_DAC6 = 6,  DAC6 = T231_S30_DAC6;
    localparam  T231_S32_DAC7 = 7,  DAC7 = T231_S32_DAC7;

    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    // ADC Connections
    logic   [31:0]              adc_i_tdata     [N_ANTENNAS-1:0];
    logic                       adc_i_tready    [N_ANTENNAS-1:0];
    logic                       adc_i_tvalid    [N_ANTENNAS-1:0];
    logic   [31:0]              adc_q_tdata     [N_ANTENNAS-1:0];
    logic                       adc_q_tready    [N_ANTENNAS-1:0];
    logic                       adc_q_tvalid    [N_ANTENNAS-1:0];
    // DAC Connections
    logic   [63:0]              dac_tdata       [N_ANTENNAS-1:0];
    logic                       dac_tready      [N_ANTENNAS-1:0];
    logic                       dac_tvalid      [N_ANTENNAS-1:0];
    logic   [4:0]               CounterNames;
    logic   [23:0]              CounterValues;
    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    logic   [31:0]              cmn_axi_araddr;
    logic   [31:0]              cmn_axi_awaddr;
	logic   [31:0]              dl_dfe_axi_araddr;
	logic   [31:0]              dl_dfe_axi_awaddr;
	logic   [31:0]              test_axi_araddr;
    logic   [31:0]              test_axi_awaddr;
	logic   [31:0]              hw_axi_araddr;
    logic   [31:0]              hw_axi_awaddr;	
	logic   [31:0]              intr_axi_araddr;
    logic   [31:0]              intr_axi_awaddr;
	logic   [31:0]              lphy_axi_araddr;
    logic   [31:0]              lphy_axi_awaddr;
	logic   [31:0]              ul_dfe_axi_araddr;
    logic   [31:0]              ul_dfe_axi_awaddr;	
   jb_axi4_stream_if  #(.DATA_WIDTH(32),  .USER_SB_WIDTH(8))    IFP_dpd_s_axis_srx();       //
   jb_axi4_stream_if  #(.DATA_WIDTH(8),   .USER_SB_WIDTH(1))    IFP_dpd_m_axis_srx_ctrl();  //	
	
    assign IFP_cmn_axi.araddr    = cmn_axi_araddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_cmn_axi.awaddr    = cmn_axi_awaddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];	
    assign IFP_dl_dfe_axi.araddr = dl_dfe_axi_araddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_dl_dfe_axi.awaddr = dl_dfe_axi_awaddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];	
    assign IFP_test_axi.araddr   = test_axi_araddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_test_axi.awaddr   = test_axi_awaddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_hw_axi.araddr     = hw_axi_araddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_hw_axi.awaddr     = hw_axi_awaddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_intr_axi.araddr   = intr_axi_araddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_intr_axi.awaddr   = intr_axi_awaddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_lphy_axi.araddr   = lphy_axi_araddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_lphy_axi.awaddr   = lphy_axi_awaddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_ul_dfe_axi.araddr    = ul_dfe_axi_araddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
    assign IFP_ul_dfe_axi.awaddr  = ul_dfe_axi_awaddr[AXI_ADDR_WIDTH_TOP_CTRL-1:0];
	
    assign IFP_dpd_srx.srx_ctrl_tdata     = IFP_dpd_m_axis_srx_ctrl.tdata;
    assign IFP_dpd_srx.srx_ctrl_tvalid    = IFP_dpd_m_axis_srx_ctrl.tvalid;
    assign IFP_dpd_srx.srx_tready         = IFP_dpd_s_axis_srx.tready;		
    assign IFP_dpd_m_axis_srx_ctrl.tready = IFP_dpd_srx.srx_ctrl_tready;
    assign IFP_dpd_s_axis_srx.tdata       = IFP_dpd_srx.srx_tdata; // 32
    assign IFP_dpd_s_axis_srx.tuser       = IFP_dpd_srx.srx_tuser; // 8
    assign IFP_dpd_s_axis_srx.tvalid      = IFP_dpd_srx.srx_tvalid; 

 vernon vernon_u0 (
        .RF_BRAM_PORTA_addr             (IFP_dbgbuf_porta.addr),
        .RF_BRAM_PORTA_clk              (dbgbuf_porta_clk),
        .RF_BRAM_PORTA_din              (IFP_dbgbuf_porta.wr_data),
        .RF_BRAM_PORTA_dout             (IFP_dbgbuf_porta.rd_data),
        .RF_BRAM_PORTA_en               (IFP_dbgbuf_porta.en),
        .RF_BRAM_PORTA_rst              (dbgbuf_porta_rst),
        .RF_BRAM_PORTA_we               (IFP_dbgbuf_porta.wr_en),

        .FH_BRAM_PORTA_addr             (IFP_iwavebuf_porta.addr),
        .FH_BRAM_PORTA_clk              (IFP_iwavebuf_porta_clk),
        .FH_BRAM_PORTA_din              (IFP_iwavebuf_porta.wr_data),
        .FH_BRAM_PORTA_dout             (IFP_iwavebuf_porta.rd_data),
        .FH_BRAM_PORTA_en               (IFP_iwavebuf_porta.en),
        .FH_BRAM_PORTA_rst              (IFP_iwavebuf_porta_rst),
        .FH_BRAM_PORTA_we               (IFP_iwavebuf_porta.wr_en),

        .GPIO_0_tri_i                   (GPIO_0_tri_i),                     // i [94:0]
        .GPIO_0_tri_o                   (GPIO_0_tri_o),                     // o [94:0]
        .GPIO_0_tri_t                   (GPIO_0_tri_t),                     // o [94:0]
        .dl_defm_radio_start_10ms       (IFP_fh_misc.dl_radio_start_10ms[0]),
		.ul_fram_radio_start_10ms       (IFP_fh_misc.ul_radio_start_10ms[0]),
		.systimer_ns                    (IFP_fh_misc.systimer_ns),
		.systimer_s                     (IFP_fh_misc.systimer_s),
        .eth0_fram_reset_active         (IFP_fh_misc.eth_fram_reset_active[0]), //per ETh port
        .ul_fram_ready                  (IFP_fh_misc.ul_fram_ready),
        .dl_defm_ready                  (IFP_fh_misc.dl_defm_ready),
        .one_pps_out                    (IFP_fh_misc.one_pps),
		.ClearCounters                  (IFP_oran_lphy_ctrl.lphy_oran_dbg_clear ),
        .CounterNames                   (CounterNames ),
        .CounterValues                  (CounterValues),
		
	//DL DATA from RADIo IF IP AXIS steam, Ant0
        .m000_data_axis_tdata           (IFP_dl_defm_uplane[0][0].tdata),
        .m000_data_axis_tkeep           (IFP_dl_defm_uplane[0][0].tkeep),
        .m000_data_axis_tlast           (IFP_dl_defm_uplane[0][0].tlast),
        .m000_data_axis_tready          (IFP_dl_defm_uplane[0][0].tready),
        .m000_data_axis_tuser           (IFP_dl_defm_uplane[0][0].tuser),
        .m000_data_axis_tvalid          (IFP_dl_defm_uplane[0][0].tvalid),
	//DL DATA from RADIo IF IP AXIS steam,Ant1
        .m001_data_axis_tdata           (IFP_dl_defm_uplane[0][1].tdata),
        .m001_data_axis_tkeep           (IFP_dl_defm_uplane[0][1].tkeep),
        .m001_data_axis_tlast           (IFP_dl_defm_uplane[0][1].tlast),
        .m001_data_axis_tready          (IFP_dl_defm_uplane[0][1].tready),
        .m001_data_axis_tuser           (IFP_dl_defm_uplane[0][1].tuser),
        .m001_data_axis_tvalid          (IFP_dl_defm_uplane[0][1].tvalid),

	//DL DATA from RADIo IF IP AXIS steam,Ant2
        .m002_data_axis_tdata           (IFP_dl_defm_uplane[0][2].tdata),
        .m002_data_axis_tkeep           (IFP_dl_defm_uplane[0][2].tkeep),
        .m002_data_axis_tlast           (IFP_dl_defm_uplane[0][2].tlast),
        .m002_data_axis_tready          (IFP_dl_defm_uplane[0][2].tready),
        .m002_data_axis_tuser           (IFP_dl_defm_uplane[0][2].tuser),
        .m002_data_axis_tvalid          (IFP_dl_defm_uplane[0][2].tvalid),
	
    //DL DATA from RADIo IF IP AXIS steam,Ant3
        .m003_data_axis_tdata           (IFP_dl_defm_uplane[0][3].tdata),
        .m003_data_axis_tkeep           (IFP_dl_defm_uplane[0][3].tkeep),
        .m003_data_axis_tlast           (IFP_dl_defm_uplane[0][3].tlast),
        .m003_data_axis_tready          (IFP_dl_defm_uplane[0][3].tready),
        .m003_data_axis_tuser           (IFP_dl_defm_uplane[0][3].tuser),
        .m003_data_axis_tvalid          (IFP_dl_defm_uplane[0][3].tvalid),

	//DL DATA from RADIo IF IP AXIS steam, Ant4
        .m004_data_axis_tdata           (),//IFP_dl_defm_uplane[1][0].tdata),
        .m004_data_axis_tkeep           (),//IFP_dl_defm_uplane[1][0].tkeep),
        .m004_data_axis_tlast           (),//IFP_dl_defm_uplane[1][0].tlast),
        .m004_data_axis_tready          (),//IFP_dl_defm_uplane[1][0].tready),
        .m004_data_axis_tuser           (),//IFP_dl_defm_uplane[1][0].tuser),
        .m004_data_axis_tvalid          (),//IFP_dl_defm_uplane[1][0].tvalid),
	//DL DATA from RADIo IF IP AXIS steam,Ant5
        .m005_data_axis_tdata           (),//IFP_dl_defm_uplane[1][1].tdata),
        .m005_data_axis_tkeep           (),//IFP_dl_defm_uplane[1][1].tkeep),
        .m005_data_axis_tlast           (),//IFP_dl_defm_uplane[1][1].tlast),
        .m005_data_axis_tready          (),//IFP_dl_defm_uplane[1][1].tready),
        .m005_data_axis_tuser           (),//IFP_dl_defm_uplane[1][1].tuser),
        .m005_data_axis_tvalid          (),//IFP_dl_defm_uplane[1][1].tvalid),

	//DL DATA from RADIo IF IP AXIS steam,Ant6
        .m006_data_axis_tdata           (),//IFP_dl_defm_uplane[1][2].tdata),
        .m006_data_axis_tkeep           (),//IFP_dl_defm_uplane[1][2].tkeep),
        .m006_data_axis_tlast           (),//IFP_dl_defm_uplane[1][2].tlast),
        .m006_data_axis_tready          (),//IFP_dl_defm_uplane[1][2].tready),
        .m006_data_axis_tuser           (),//IFP_dl_defm_uplane[1][2].tuser),
        .m006_data_axis_tvalid          (),//IFP_dl_defm_uplane[1][2].tvalid),
	
    //DL DATA from RADIo IF IP AXIS steam,Ant7
        .m007_data_axis_tdata           (),//IFP_dl_defm_uplane[1][3].tdata),
        .m007_data_axis_tkeep           (),//IFP_dl_defm_uplane[1][3].tkeep),
        .m007_data_axis_tlast           (),//IFP_dl_defm_uplane[1][3].tlast),
        .m007_data_axis_tready          (),//IFP_dl_defm_uplane[1][3].tready),
        .m007_data_axis_tuser           (),//IFP_dl_defm_uplane[1][3].tuser),
        .m007_data_axis_tvalid          (),//IFP_dl_defm_uplane[1][3].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant0
        .s000_data_axis_tdata           (IFP_ul_fram_uplane[0][0].tdata),
        .s000_data_axis_tkeep           (IFP_ul_fram_uplane[0][0].tkeep),
        .s000_data_axis_tlast           (IFP_ul_fram_uplane[0][0].tlast),
        .s000_data_axis_tready          (IFP_ul_fram_uplane[0][0].tready),
        .s000_data_axis_tvalid          (IFP_ul_fram_uplane[0][0].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant1
        .s001_data_axis_tdata           (IFP_ul_fram_uplane[0][1].tdata),
        .s001_data_axis_tkeep           (IFP_ul_fram_uplane[0][1].tkeep),
        .s001_data_axis_tlast           (IFP_ul_fram_uplane[0][1].tlast),
        .s001_data_axis_tready          (IFP_ul_fram_uplane[0][1].tready),
        .s001_data_axis_tvalid          (IFP_ul_fram_uplane[0][1].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant2	       
        .s002_data_axis_tdata           (IFP_ul_fram_uplane[0][2].tdata),
        .s002_data_axis_tkeep           (IFP_ul_fram_uplane[0][2].tkeep),
        .s002_data_axis_tlast           (IFP_ul_fram_uplane[0][2].tlast),
        .s002_data_axis_tready          (IFP_ul_fram_uplane[0][2].tready),
        .s002_data_axis_tvalid          (IFP_ul_fram_uplane[0][2].tvalid),
		       
	//UL DATA AXIS to RADIO IF IP, Ant3
        .s003_data_axis_tdata           (IFP_ul_fram_uplane[0][3].tdata),
        .s003_data_axis_tkeep           (IFP_ul_fram_uplane[0][3].tkeep),
        .s003_data_axis_tlast           (IFP_ul_fram_uplane[0][3].tlast),
        .s003_data_axis_tready          (IFP_ul_fram_uplane[0][3].tready),
        .s003_data_axis_tvalid          (IFP_ul_fram_uplane[0][3].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant4
        .s004_data_axis_tdata           (IFP_ul_fram_uplane[1][0].tdata),
        .s004_data_axis_tkeep           (IFP_ul_fram_uplane[1][0].tkeep),
        .s004_data_axis_tlast           (IFP_ul_fram_uplane[1][0].tlast),
        .s004_data_axis_tready          (IFP_ul_fram_uplane[1][0].tready),
        .s004_data_axis_tvalid          (IFP_ul_fram_uplane[1][0].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant5
        .s005_data_axis_tdata           (IFP_ul_fram_uplane[1][1].tdata),
        .s005_data_axis_tkeep           (IFP_ul_fram_uplane[1][1].tkeep),
        .s005_data_axis_tlast           (IFP_ul_fram_uplane[1][1].tlast),
        .s005_data_axis_tready          (IFP_ul_fram_uplane[1][1].tready),
        .s005_data_axis_tvalid          (IFP_ul_fram_uplane[1][1].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant6	       
        .s006_data_axis_tdata           (IFP_ul_fram_uplane[1][2].tdata),
        .s006_data_axis_tkeep           (IFP_ul_fram_uplane[1][2].tkeep),
        .s006_data_axis_tlast           (IFP_ul_fram_uplane[1][2].tlast),
        .s006_data_axis_tready          (IFP_ul_fram_uplane[1][2].tready),
        .s006_data_axis_tvalid          (IFP_ul_fram_uplane[1][2].tvalid),
		       
	//UL DATA AXIS to RADIO IF IP, Ant7
        .s007_data_axis_tdata           (IFP_ul_fram_uplane[1][3].tdata),
        .s007_data_axis_tkeep           (IFP_ul_fram_uplane[1][3].tkeep),
        .s007_data_axis_tlast           (IFP_ul_fram_uplane[1][3].tlast),
        .s007_data_axis_tready          (IFP_ul_fram_uplane[1][3].tready),
        .s007_data_axis_tvalid          (IFP_ul_fram_uplane[1][3].tvalid),
		

    // Ul Framer Request for the Data
        .s000_fram_data_req             (fh_ul_fram_data_req[0]),
        .s001_fram_data_req             (fh_ul_fram_data_req[1]),
        .s002_fram_data_req             (fh_ul_fram_data_req[2]),
        .s003_fram_data_req             (fh_ul_fram_data_req[3]),


	//Carrier0  timing params
        .cc0_timing_cc_enable           (IFP_fh_cc_timing[0].cc_enable),
        .cc0_timing_cc_reload           (IFP_fh_cc_timing[0].cc_reload),
        .cc0_timing_dl_cta_sym_num      (IFP_fh_cc_timing[0].dl_cta_sym_num),
        .cc0_timing_dl_sym_num          (IFP_fh_cc_timing[0].dl_sym_num),
        .cc0_timing_dl_update           (IFP_fh_cc_timing[0].dl_update),
        .cc0_timing_ul_cta_sym_num      (IFP_fh_cc_timing[0].ul_cta_sym_num),
        .cc0_timing_ul_sym_num          (IFP_fh_cc_timing[0].ul_sym_num),
        .cc0_timing_ul_update           (IFP_fh_cc_timing[0].ul_update),

	//Carrier1 timing params
        //.cc1_timing_cc_enable           (IFP_fh_cc_timing[1].cc_enable),
        //.cc1_timing_cc_reload           (IFP_fh_cc_timing[1].cc_reload),
        //.cc1_timing_dl_cta_sym_num      (IFP_fh_cc_timing[1].dl_cta_sym_num),
        //.cc1_timing_dl_sym_num          (IFP_fh_cc_timing[1].dl_sym_num),
        //.cc1_timing_dl_update           (IFP_fh_cc_timing[1].dl_update),
        //.cc1_timing_ul_cta_sym_num      (IFP_fh_cc_timing[1].ul_cta_sym_num),
        //.cc1_timing_ul_sym_num          (IFP_fh_cc_timing[1].ul_sym_num),
        //.cc1_timing_ul_update           (IFP_fh_cc_timing[1].ul_update),

    //PRACH C-Plane Signals, secion type3 message
        .m0_prach_prach_tready          (IFP_prach_cplane.tready),
        .m0_prach_prach_tvalid          (IFP_prach_cplane.tvalid),
		.m0_prach_prach_beamid          (IFP_prach_cplane.beamid),
        .m0_prach_prach_cc              (IFP_prach_cplane.cc),
        .m0_prach_prach_cp_length       (IFP_prach_cplane.cp_length),
        .m0_prach_prach_filter_index    (IFP_prach_cplane.filter_index),
        .m0_prach_prach_frame_structure (IFP_prach_cplane.frame_structure),
        .m0_prach_prach_freqoffset      (IFP_prach_cplane.freqoffset),
        .m0_prach_prach_num_prbc        (IFP_prach_cplane.num_prbc),
        .m0_prach_prach_num_symbol      (IFP_prach_cplane.num_symbol),
        .m0_prach_prach_rb              (IFP_prach_cplane.rb),
        .m0_prach_prach_remask          (IFP_prach_cplane.remask),
        .m0_prach_prach_return_port     (IFP_prach_cplane.return_port),
        .m0_prach_prach_section_id      (IFP_prach_cplane.section_id),
        .m0_prach_prach_sf              (IFP_prach_cplane.sf),
        .m0_prach_prach_sl              (IFP_prach_cplane.sl),
        .m0_prach_prach_ss              (IFP_prach_cplane.ss),
        .m0_prach_prach_start_prbc      (IFP_prach_cplane.start_prbc),
        .m0_prach_prach_sy              (IFP_prach_cplane.sy),
        .m0_prach_prach_syminc          (IFP_prach_cplane.syminc),
        .m0_prach_prach_time_offset     (IFP_prach_cplane.time_offset),
        .m0_prach_prach_udcomphdr       (IFP_prach_cplane.udcomphdr),

	//PRACH DATA AXIS in UL to Radio IP        
        .s00_prach_axis_tdata           (IFP_prach_uplane.tdata),
        .s00_prach_axis_tkeep           (IFP_prach_uplane.tkeep),
        .s00_prach_axis_tlast           (IFP_prach_uplane.tlast),
        .s00_prach_axis_tready          (IFP_prach_uplane.tready),
        .s00_prach_axis_tuser           (IFP_prach_uplane.tuser),
        .s00_prach_axis_tvalid          (IFP_prach_uplane.tvalid),

    //Ant0 Defmer BID Interface, C-Plane, sections       		       
        //.m000_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[0].ready),//      		       
        .m000_defm_bid_bid_ready        (1'b1),// 
        .m000_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[0].tlast),
        .m000_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[0].valid),	       
        .m000_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[0].beamid15),
        .m000_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[0].cc_id),
        .m000_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[0].num_prbc),
        .m000_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[0].num_symbol),
        .m000_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[0].rb),
        .m000_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[0].remask),
        .m000_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[0].start_prbc),


	//Ant1 Defmer BID (beam forming id)  Interface, C-Plane, sections       	       
//        .m001_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[1].ready),
        .m001_defm_bid_bid_ready        (1'b1),
        .m001_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[1].tlast),
        .m001_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[1].valid),
        .m001_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[1].beamid15),
        .m001_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[1].cc_id),
        .m001_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[1].num_prbc),
        .m001_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[1].num_symbol),
        .m001_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[1].rb),
        .m001_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[1].remask),
        .m001_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[1].start_prbc),


	//Ant2 Defmer BID Interface
//        .m002_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[2].ready),
        .m002_defm_bid_bid_ready        (1'b1),
        .m002_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[2].tlast),
        .m002_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[2].valid),	       
        .m002_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[2].beamid15),
        .m002_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[2].cc_id),
        .m002_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[2].num_prbc),
        .m002_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[2].num_symbol),
        .m002_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[2].rb),
        .m002_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[2].remask),
        .m002_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[2].start_prbc),

	//Ant3 Defmer BID ports            (Beam forming)
//        .m003_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[3].ready),
        .m003_defm_bid_bid_ready        (1'b1),
        .m003_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[3].tlast),
        .m003_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[3].valid),
        .m003_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[3].beamid15),
        .m003_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[3].cc_id),
        .m003_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[3].num_prbc),
        .m003_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[3].num_symbol),
        .m003_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[3].rb),
        .m003_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[3].remask),
        .m003_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[3].start_prbc),


    //Ant4 Defmer BID Interface, C-Plane, sections       		       
        //.m004_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[4].ready),//      		       
        .m004_defm_bid_bid_ready        (1'b1),// 
        .m004_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[4].tlast),
        .m004_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[4].valid),	       
        .m004_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[4].beamid15),
        .m004_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[4].cc_id),
        .m004_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[4].num_prbc),
        .m004_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[4].num_symbol),
        .m004_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[4].rb),
        .m004_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[4].remask),
        .m004_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[4].start_prbc),


	//Ant5 Defmer BID (beam forming id)  Interface, C-Plane, sections       	       
//        .m005_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[5].ready),
        .m005_defm_bid_bid_ready        (1'b1),
        .m005_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[5].tlast),
        .m005_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[5].valid),
        .m005_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[5].beamid15),
        .m005_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[5].cc_id),
        .m005_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[5].num_prbc),
        .m005_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[5].num_symbol),
        .m005_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[5].rb),
        .m005_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[5].remask),
        .m005_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[5].start_prbc),


	//Ant6 Defmer BID Interface
//        .m006_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[6].ready),
        .m006_defm_bid_bid_ready        (1'b1),
        .m006_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[6].tlast),
        .m006_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[6].valid),	       
        .m006_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[6].beamid15),
        .m006_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[6].cc_id),
        .m006_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[6].num_prbc),
        .m006_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[6].num_symbol),
        .m006_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[6].rb),
        .m006_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[6].remask),
        .m006_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[6].start_prbc),

	//Ant7 Defmer BID ports            (Beam forming)
//        .m007_defm_bid_bid_ready        (IFP_dl_defm_cplane_bid[7].ready),
        .m007_defm_bid_bid_ready        (1'b1),
        .m007_defm_bid_bid_tlast        (IFP_dl_defm_cplane_bid[7].tlast),
        .m007_defm_bid_bid_valid        (IFP_dl_defm_cplane_bid[7].valid),
        .m007_defm_bid_bid_beamid15     (IFP_dl_defm_cplane_bid[7].beamid15),
        .m007_defm_bid_bid_cc_id        (IFP_dl_defm_cplane_bid[7].cc_id),
        .m007_defm_bid_bid_num_prbc     (IFP_dl_defm_cplane_bid[7].num_prbc),
        .m007_defm_bid_bid_num_symbol   (IFP_dl_defm_cplane_bid[7].num_symbol),
        .m007_defm_bid_bid_rb           (IFP_dl_defm_cplane_bid[7].rb),
        .m007_defm_bid_bid_remask       (IFP_dl_defm_cplane_bid[7].remask),
        .m007_defm_bid_bid_start_prbc   (IFP_dl_defm_cplane_bid[7].start_prbc),

	//Ant0 framer BID Interface, C-Plane, sections       
//        .m000_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[0].ready),
        .m000_fram_bid_bid_ready        (1'b1),
        .m000_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[0].tlast),
        .m000_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[0].valid),	       
        .m000_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[0].beamid15),
        .m000_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[0].cc_id),
        .m000_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[0].num_prbc),
        .m000_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[0].num_symbol),
        .m000_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[0].rb),
        .m000_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[0].remask),
        .m000_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[0].start_prbc),
        
    //Ant1 framer BID            (beam forming id)  Interface , C-Plane, sections
//        .m001_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[1].ready),
        .m001_fram_bid_bid_ready        (1'b1), 
        .m001_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[1].tlast),
        .m001_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[1].valid),      
        .m001_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[1].beamid15),
        .m001_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[1].cc_id),
        .m001_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[1].num_prbc),
        .m001_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[1].num_symbol),
        .m001_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[1].rb),
        .m001_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[1].remask),
        .m001_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[1].start_prbc),

       
	//Ant2 Framer BID            (beam forming id)  Interface
//        .m002_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[2].ready),
        .m002_fram_bid_bid_ready        (1'b1),
        .m002_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[2].tlast),
        .m002_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[2].valid),
        .m002_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[2].beamid15),
        .m002_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[2].cc_id),
        .m002_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[2].num_prbc),
        .m002_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[2].num_symbol),
        .m002_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[2].rb),
        .m002_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[2].remask),
        .m002_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[2].start_prbc),

	//Ant3 Framer BID ports            (Beam forming)
//        .m003_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[3].ready),
        .m003_fram_bid_bid_ready        (1'b1),
        .m003_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[3].tlast),
        .m003_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[3].valid),
        .m003_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[3].beamid15),
        .m003_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[3].cc_id),
        .m003_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[3].num_prbc),
        .m003_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[3].num_symbol),
        .m003_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[3].rb),
        .m003_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[3].remask),
        .m003_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[3].start_prbc),

	//Ant4 framer BID Interface, C-Plane, sections       
//        .m004_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[4].ready),
        .m004_fram_bid_bid_ready        (1'b1),
        .m004_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[4].tlast),
        .m004_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[4].valid),	       
        .m004_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[4].beamid15),
        .m004_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[4].cc_id),
        .m004_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[4].num_prbc),
        .m004_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[4].num_symbol),
        .m004_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[4].rb),
        .m004_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[4].remask),
        .m004_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[4].start_prbc),
        
    //Ant5 framer BID            (beam forming id)  Interface , C-Plane, sections
//        .m005_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[5].ready),
        .m005_fram_bid_bid_ready        (1'b1), 
        .m005_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[5].tlast),
        .m005_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[5].valid),      
        .m005_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[5].beamid15),
        .m005_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[5].cc_id),
        .m005_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[5].num_prbc),
        .m005_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[5].num_symbol),
        .m005_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[5].rb),
        .m005_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[5].remask),
        .m005_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[5].start_prbc),

       
	//Ant6 Framer BID            (beam forming id)  Interface
//        .m006_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[6].ready),
        .m006_fram_bid_bid_ready        (1'b1),
        .m006_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[6].tlast),
        .m006_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[6].valid),
        .m006_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[6].beamid15),
        .m006_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[6].cc_id),
        .m006_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[6].num_prbc),
        .m006_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[6].num_symbol),
        .m006_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[6].rb),
        .m006_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[6].remask),
        .m006_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[6].start_prbc),

	//Ant7 Framer BID ports            (Beam forming)
//        .m007_fram_bid_bid_ready        (IFP_ul_fram_cplane_bid[7].ready),
        .m007_fram_bid_bid_ready        (1'b1),
        .m007_fram_bid_bid_tlast        (IFP_ul_fram_cplane_bid[7].tlast),
        .m007_fram_bid_bid_valid        (IFP_ul_fram_cplane_bid[7].valid),
        .m007_fram_bid_bid_beamid15     (IFP_ul_fram_cplane_bid[7].beamid15),
        .m007_fram_bid_bid_cc_id        (IFP_ul_fram_cplane_bid[7].cc_id),
        .m007_fram_bid_bid_num_prbc     (IFP_ul_fram_cplane_bid[7].num_prbc),
        .m007_fram_bid_bid_num_symbol   (IFP_ul_fram_cplane_bid[7].num_symbol),
        .m007_fram_bid_bid_rb           (IFP_ul_fram_cplane_bid[7].rb),
        .m007_fram_bid_bid_remask       (IFP_ul_fram_cplane_bid[7].remask),
        .m007_fram_bid_bid_start_prbc   (IFP_ul_fram_cplane_bid[7].start_prbc),

	//C-Plane message as it arrives	
	//eCPRI Header	       
        .m0_xran_head_t_header_offset_valid (IFP_xran_header_ecpri[0].t_header_offset_valid),//
	//Runt packet length: 1 indicates that the actual size of a received packet 
	// does not match the size declared in the transport header.
        .m0_xran_head_runt_packet_len    (IFP_xran_header_ecpri[0].runt_packet_len), 
        .m0_xran_head_rtc_pc_id          (IFP_xran_header_ecpri[0].rtc_pc_id),
        .m0_xran_head_concat             (IFP_xran_header_ecpri[0].concat),
        .m0_xran_head_messagetype        (IFP_xran_header_ecpri[0].messagetype), 
        .m0_xran_head_seqid              (IFP_xran_header_ecpri[0].seqid),  
        .m0_xran_head_subseqid           (IFP_xran_header_ecpri[0].subseqid),
        .m0_xran_head_ebit               (IFP_xran_header_ecpri[0].ebit),  
        .m0_xran_head_payloadsize        (IFP_xran_header_ecpri[0].payloadsize),
        .m0_xran_head_packet_in_window   (IFP_xran_header_ecpri[0].packet_in_window),
        .m0_xran_head_offset_in_symbol   (IFP_xran_header_ecpri[0].offset_in_symbol),

        //ORAN Common Header
        .m0_xran_head_radio_app_head_valid (IFP_xran_header_app_cmn[0].radio_app_head_valid),
        .m0_xran_head_datadirection      (IFP_xran_header_app_cmn[0].datadirection),
        .m0_xran_head_numsections        (IFP_xran_header_app_cmn[0].numsections),
        .m0_xran_head_sectiontype        (IFP_xran_header_app_cmn[0].sectiontype),
        .m0_xran_head_filterindex        (IFP_xran_header_app_cmn[0].filterindex),
        .m0_xran_head_frameid            (IFP_xran_header_app_cmn[0].frameid),
        .m0_xran_head_subframeid         (IFP_xran_header_app_cmn[0].subframeid),
        .m0_xran_head_slotid             (IFP_xran_header_app_cmn[0].slotid),
        .m0_xran_head_symbolid           (IFP_xran_header_app_cmn[0].symbolid),
        .m0_xran_head_udcomphdr          (IFP_xran_header_app_cmn[0].udcomphdr),
        .m0_xran_head_timeoffset         (IFP_xran_header_app_cmn[0].timeoffset),
        .m0_xran_head_framestructure     (IFP_xran_header_app_cmn[0].framestructure),
        .m0_xran_head_cplength           (IFP_xran_header_app_cmn[0].cplength),

	 //ORAN Section Header
        .m0_xran_head_section_header_valid (IFP_xran_header_app_section[0].section_header_valid),
        .m0_xran_head_beamid15           (IFP_xran_header_app_section[0].beamid15),
        .m0_xran_head_freqoffset         (IFP_xran_header_app_section[0].freqoffset),
        .m0_xran_head_numprbc            (IFP_xran_header_app_section[0].numprbc),
	 //Number of consecutive symbols to which the section control is applicable.
        .m0_xran_head_numsymbol          (IFP_xran_header_app_section[0].numsymbol),
        .m0_xran_head_rb                 (IFP_xran_header_app_section[0].rb),
	//The resource elements (REs) in the RB to apply section information to.
        .m0_xran_head_remask             (IFP_xran_header_app_section[0].remask),
        .m0_xran_head_sectionid          (IFP_xran_header_app_section[0].sectionid),
        .m0_xran_head_startprbc          (IFP_xran_header_app_section[0].startprbc),

	//xran bweight	       
        .m0_xran_bweight_tdata           (IFP_xran_bweight[0].tdata),
        .m0_xran_bweight_tlast           (IFP_xran_bweight[0].tlast),
        .m0_xran_bweight_tuser           (IFP_xran_bweight[0].tuser),
     //   .m0_xran_bweight_tvalid          (IFP_xran_bweight[0].tvalid),

	//C-Plane/U_plane both UL/DL Unsupported Messages, AXIS, whole packet
        .m0_xran_unsup_tdata             (IFP_xran_unsup[0].tdata),
        .m0_xran_unsup_tkeep             (IFP_xran_unsup[0].tkeep),
        .m0_xran_unsup_tlast             (IFP_xran_unsup[0].tlast),
        .m0_xran_unsup_tuser             (IFP_xran_unsup[0].tuser),
        .m0_xran_unsup_tvalid            (IFP_xran_unsup[0].tvalid),
	
     	//In UL direction, UL solicted packets, AXIS stream    
        .s00_unsol_axis_tdata            (IFP_unsol_ul_uplane.tdata),
        .s00_unsol_axis_tkeep            (IFP_unsol_ul_uplane.tkeep),
        .s00_unsol_axis_tlast            (IFP_unsol_ul_uplane.tlast),
//        .s00_unsol_axis_tready           (IFP_unsol_ul_uplane.tready),
        .s00_unsol_axis_tready           (1'b1),
        .s00_unsol_axis_tuser            (IFP_unsol_ul_uplane.tuser),
        .s00_unsol_axis_tvalid           (IFP_unsol_ul_uplane.tvalid),
		
		
        .M00_AXI_TOP_CTRL_CMN_araddr    (cmn_axi_araddr),
        .M00_AXI_TOP_CTRL_CMN_arprot    (IFP_cmn_axi.arprot),
        .M00_AXI_TOP_CTRL_CMN_arready   (IFP_cmn_axi.arready),
        .M00_AXI_TOP_CTRL_CMN_arvalid   (IFP_cmn_axi.arvalid),
        .M00_AXI_TOP_CTRL_CMN_awaddr    (cmn_axi_awaddr),
        .M00_AXI_TOP_CTRL_CMN_awprot    (IFP_cmn_axi.awprot),
        .M00_AXI_TOP_CTRL_CMN_awready   (IFP_cmn_axi.awready),
        .M00_AXI_TOP_CTRL_CMN_awvalid   (IFP_cmn_axi.awvalid),
        .M00_AXI_TOP_CTRL_CMN_bready    (IFP_cmn_axi.bready),
        .M00_AXI_TOP_CTRL_CMN_bresp     (IFP_cmn_axi.bresp),
        .M00_AXI_TOP_CTRL_CMN_bvalid    (IFP_cmn_axi.bvalid),
        .M00_AXI_TOP_CTRL_CMN_rdata     (IFP_cmn_axi.rdata),
        .M00_AXI_TOP_CTRL_CMN_rready    (IFP_cmn_axi.rready),
        .M00_AXI_TOP_CTRL_CMN_rresp     (IFP_cmn_axi.rresp),
        .M00_AXI_TOP_CTRL_CMN_rvalid    (IFP_cmn_axi.rvalid),
        .M00_AXI_TOP_CTRL_CMN_wdata     (IFP_cmn_axi.wdata),
        .M00_AXI_TOP_CTRL_CMN_wready    (IFP_cmn_axi.wready),
        .M00_AXI_TOP_CTRL_CMN_wstrb     (IFP_cmn_axi.wstrb),
        .M00_AXI_TOP_CTRL_CMN_wvalid    (IFP_cmn_axi.wvalid),

		.M00_AXI_TOP_CTRL_DL_DFE_araddr (dl_dfe_axi_araddr),
		.M00_AXI_TOP_CTRL_DL_DFE_arprot (IFP_dl_dfe_axi.arprot),
		.M00_AXI_TOP_CTRL_DL_DFE_arready(IFP_dl_dfe_axi.arready),
		.M00_AXI_TOP_CTRL_DL_DFE_arvalid(IFP_dl_dfe_axi.arvalid),
		.M00_AXI_TOP_CTRL_DL_DFE_awaddr (dl_dfe_axi_awaddr),
		.M00_AXI_TOP_CTRL_DL_DFE_awprot (IFP_dl_dfe_axi.awprot),
		.M00_AXI_TOP_CTRL_DL_DFE_awready(IFP_dl_dfe_axi.awready),
		.M00_AXI_TOP_CTRL_DL_DFE_awvalid(IFP_dl_dfe_axi.awvalid),
		.M00_AXI_TOP_CTRL_DL_DFE_bready (IFP_dl_dfe_axi.bready),
		.M00_AXI_TOP_CTRL_DL_DFE_bresp  (IFP_dl_dfe_axi.bresp),
		.M00_AXI_TOP_CTRL_DL_DFE_bvalid (IFP_dl_dfe_axi.bvalid),
		.M00_AXI_TOP_CTRL_DL_DFE_rdata  (IFP_dl_dfe_axi.rdata),
		.M00_AXI_TOP_CTRL_DL_DFE_rready (IFP_dl_dfe_axi.rready),
		.M00_AXI_TOP_CTRL_DL_DFE_rresp  (IFP_dl_dfe_axi.rresp),
		.M00_AXI_TOP_CTRL_DL_DFE_rvalid (IFP_dl_dfe_axi.rvalid),
		.M00_AXI_TOP_CTRL_DL_DFE_wdata  (IFP_dl_dfe_axi.wdata),
		.M00_AXI_TOP_CTRL_DL_DFE_wready (IFP_dl_dfe_axi.wready),
		.M00_AXI_TOP_CTRL_DL_DFE_wstrb  (IFP_dl_dfe_axi.wstrb),
		.M00_AXI_TOP_CTRL_DL_DFE_wvalid (IFP_dl_dfe_axi.wvalid),
		
		
        .M00_AXI_TOP_CTRL_TEST_araddr   (test_axi_araddr),
        .M00_AXI_TOP_CTRL_TEST_arprot   (IFP_test_axi.arprot),
        .M00_AXI_TOP_CTRL_TEST_arready  (IFP_test_axi.arready),
        .M00_AXI_TOP_CTRL_TEST_arvalid  (IFP_test_axi.arvalid),
        .M00_AXI_TOP_CTRL_TEST_awaddr   (test_axi_awaddr),
        .M00_AXI_TOP_CTRL_TEST_awprot   (IFP_test_axi.awprot),
        .M00_AXI_TOP_CTRL_TEST_awready  (IFP_test_axi.awready),
        .M00_AXI_TOP_CTRL_TEST_awvalid  (IFP_test_axi.awvalid),
        .M00_AXI_TOP_CTRL_TEST_bready   (IFP_test_axi.bready),
        .M00_AXI_TOP_CTRL_TEST_bresp    (IFP_test_axi.bresp),
        .M00_AXI_TOP_CTRL_TEST_bvalid   (IFP_test_axi.bvalid),
        .M00_AXI_TOP_CTRL_TEST_rdata    (IFP_test_axi.rdata),
        .M00_AXI_TOP_CTRL_TEST_rready   (IFP_test_axi.rready),
        .M00_AXI_TOP_CTRL_TEST_rresp    (IFP_test_axi.rresp),
        .M00_AXI_TOP_CTRL_TEST_rvalid   (IFP_test_axi.rvalid),
        .M00_AXI_TOP_CTRL_TEST_wdata    (IFP_test_axi.wdata),
        .M00_AXI_TOP_CTRL_TEST_wready   (IFP_test_axi.wready),
        .M00_AXI_TOP_CTRL_TEST_wstrb    (IFP_test_axi.wstrb),
        .M00_AXI_TOP_CTRL_TEST_wvalid   (IFP_test_axi.wvalid),		
		
        .M00_AXI_TOP_CTRL_HW_araddr     (hw_axi_araddr),
        .M00_AXI_TOP_CTRL_HW_arprot     (IFP_hw_axi.arprot),
        .M00_AXI_TOP_CTRL_HW_arready    (IFP_hw_axi.arready),
        .M00_AXI_TOP_CTRL_HW_arvalid    (IFP_hw_axi.arvalid),
        .M00_AXI_TOP_CTRL_HW_awaddr     (hw_axi_awaddr),
        .M00_AXI_TOP_CTRL_HW_awprot     (IFP_hw_axi.awprot),
        .M00_AXI_TOP_CTRL_HW_awready    (IFP_hw_axi.awready),
        .M00_AXI_TOP_CTRL_HW_awvalid    (IFP_hw_axi.awvalid),
        .M00_AXI_TOP_CTRL_HW_bready     (IFP_hw_axi.bready),
        .M00_AXI_TOP_CTRL_HW_bresp      (IFP_hw_axi.bresp),
        .M00_AXI_TOP_CTRL_HW_bvalid     (IFP_hw_axi.bvalid),
        .M00_AXI_TOP_CTRL_HW_rdata      (IFP_hw_axi.rdata),
        .M00_AXI_TOP_CTRL_HW_rready     (IFP_hw_axi.rready),
        .M00_AXI_TOP_CTRL_HW_rresp      (IFP_hw_axi.rresp),
        .M00_AXI_TOP_CTRL_HW_rvalid     (IFP_hw_axi.rvalid),
        .M00_AXI_TOP_CTRL_HW_wdata      (IFP_hw_axi.wdata),
        .M00_AXI_TOP_CTRL_HW_wready     (IFP_hw_axi.wready),
        .M00_AXI_TOP_CTRL_HW_wstrb      (IFP_hw_axi.wstrb),
        .M00_AXI_TOP_CTRL_HW_wvalid     (IFP_hw_axi.wvalid),	

        .M00_AXI_TOP_CTRL_INTR_araddr   (intr_axi_araddr),
        .M00_AXI_TOP_CTRL_INTR_arprot   (IFP_intr_axi.arprot),
        .M00_AXI_TOP_CTRL_INTR_arready  (IFP_intr_axi.arready),
        .M00_AXI_TOP_CTRL_INTR_arvalid  (IFP_intr_axi.arvalid),
        .M00_AXI_TOP_CTRL_INTR_awaddr   (intr_axi_awaddr),
        .M00_AXI_TOP_CTRL_INTR_awprot   (IFP_intr_axi.awprot),
        .M00_AXI_TOP_CTRL_INTR_awready  (IFP_intr_axi.awready),
        .M00_AXI_TOP_CTRL_INTR_awvalid  (IFP_intr_axi.awvalid),
        .M00_AXI_TOP_CTRL_INTR_bready   (IFP_intr_axi.bready),
        .M00_AXI_TOP_CTRL_INTR_bresp    (IFP_intr_axi.bresp),
        .M00_AXI_TOP_CTRL_INTR_bvalid   (IFP_intr_axi.bvalid),
        .M00_AXI_TOP_CTRL_INTR_rdata    (IFP_intr_axi.rdata),
        .M00_AXI_TOP_CTRL_INTR_rready   (IFP_intr_axi.rready),
        .M00_AXI_TOP_CTRL_INTR_rresp    (IFP_intr_axi.rresp),
        .M00_AXI_TOP_CTRL_INTR_rvalid   (IFP_intr_axi.rvalid),
        .M00_AXI_TOP_CTRL_INTR_wdata    (IFP_intr_axi.wdata),
        .M00_AXI_TOP_CTRL_INTR_wready   (IFP_intr_axi.wready),
        .M00_AXI_TOP_CTRL_INTR_wstrb    (IFP_intr_axi.wstrb),
        .M00_AXI_TOP_CTRL_INTR_wvalid   (IFP_intr_axi.wvalid),	


		.M00_AXI_TOP_CTRL_LPHY_araddr   (lphy_axi_araddr),
		.M00_AXI_TOP_CTRL_LPHY_arprot   (IFP_lphy_axi.arprot),
		.M00_AXI_TOP_CTRL_LPHY_arready  (IFP_lphy_axi.arready),
		.M00_AXI_TOP_CTRL_LPHY_arvalid  (IFP_lphy_axi.arvalid),
		.M00_AXI_TOP_CTRL_LPHY_awaddr   (lphy_axi_awaddr),
		.M00_AXI_TOP_CTRL_LPHY_awprot   (IFP_lphy_axi.awprot),
		.M00_AXI_TOP_CTRL_LPHY_awready  (IFP_lphy_axi.awready),
		.M00_AXI_TOP_CTRL_LPHY_awvalid  (IFP_lphy_axi.awvalid),
		.M00_AXI_TOP_CTRL_LPHY_bready   (IFP_lphy_axi.bready),
		.M00_AXI_TOP_CTRL_LPHY_bresp    (IFP_lphy_axi.bresp),
		.M00_AXI_TOP_CTRL_LPHY_bvalid   (IFP_lphy_axi.bvalid),
		.M00_AXI_TOP_CTRL_LPHY_rdata    (IFP_lphy_axi.rdata),
		.M00_AXI_TOP_CTRL_LPHY_rready   (IFP_lphy_axi.rready),
		.M00_AXI_TOP_CTRL_LPHY_rresp    (IFP_lphy_axi.rresp),
		.M00_AXI_TOP_CTRL_LPHY_rvalid   (IFP_lphy_axi.rvalid),
		.M00_AXI_TOP_CTRL_LPHY_wdata    (IFP_lphy_axi.wdata),
		.M00_AXI_TOP_CTRL_LPHY_wready   (IFP_lphy_axi.wready),
		.M00_AXI_TOP_CTRL_LPHY_wstrb    (IFP_lphy_axi.wstrb),
		.M00_AXI_TOP_CTRL_LPHY_wvalid   (IFP_lphy_axi.wvalid),	

		.M00_AXI_TOP_CTRL_UL_DFE_araddr   (ul_dfe_axi_araddr),
		.M00_AXI_TOP_CTRL_UL_DFE_arprot     (IFP_ul_dfe_axi.arprot),
		.M00_AXI_TOP_CTRL_UL_DFE_arready  (IFP_ul_dfe_axi.arready),
		.M00_AXI_TOP_CTRL_UL_DFE_arvalid    (IFP_ul_dfe_axi.arvalid),
		.M00_AXI_TOP_CTRL_UL_DFE_awaddr   (ul_dfe_axi_awaddr),
		.M00_AXI_TOP_CTRL_UL_DFE_awprot    (IFP_ul_dfe_axi.awprot),
		.M00_AXI_TOP_CTRL_UL_DFE_awready (IFP_ul_dfe_axi.awready),
		.M00_AXI_TOP_CTRL_UL_DFE_awvalid   (IFP_ul_dfe_axi.awvalid),
		.M00_AXI_TOP_CTRL_UL_DFE_bready    (IFP_ul_dfe_axi.bready),
		.M00_AXI_TOP_CTRL_UL_DFE_bresp      (IFP_ul_dfe_axi.bresp),
		.M00_AXI_TOP_CTRL_UL_DFE_bvalid      (IFP_ul_dfe_axi.bvalid),
		.M00_AXI_TOP_CTRL_UL_DFE_rdata       (IFP_ul_dfe_axi.rdata),
		.M00_AXI_TOP_CTRL_UL_DFE_rready     (IFP_ul_dfe_axi.rready),
		.M00_AXI_TOP_CTRL_UL_DFE_rresp       (IFP_ul_dfe_axi.rresp),
		.M00_AXI_TOP_CTRL_UL_DFE_rvalid       (IFP_ul_dfe_axi.rvalid),
		.M00_AXI_TOP_CTRL_UL_DFE_wdata      (IFP_ul_dfe_axi.wdata),
		.M00_AXI_TOP_CTRL_UL_DFE_wready    (IFP_ul_dfe_axi.wready),
		.M00_AXI_TOP_CTRL_UL_DFE_wstrb       (IFP_ul_dfe_axi.wstrb),
		.M00_AXI_TOP_CTRL_UL_DFE_wvalid      (IFP_ul_dfe_axi.wvalid),	
		
        .T224_m00_adc0_i_tdata          (adc_i_tdata [T224_M00_ADC0]),
        .T224_m00_adc0_i_tready         (adc_i_tready[T224_M00_ADC0]),
        .T224_m00_adc0_i_tvalid         (adc_i_tvalid[T224_M00_ADC0]),
        .T224_m01_adc0_q_tdata          (adc_q_tdata [T224_M01_ADC0]),
        .T224_m01_adc0_q_tready         (adc_q_tready[T224_M01_ADC0]),
        .T224_m01_adc0_q_tvalid         (adc_q_tvalid[T224_M01_ADC0]),
        .T224_m02_adc1_i_tdata          (adc_i_tdata [T224_M02_ADC1]),
        .T224_m02_adc1_i_tready         (adc_i_tready[T224_M02_ADC1]),
        .T224_m02_adc1_i_tvalid         (adc_i_tvalid[T224_M02_ADC1]),
        .T224_m03_adc1_q_tdata          (adc_q_tdata [T224_M03_ADC1]),
        .T224_m03_adc1_q_tready         (adc_q_tready[T224_M03_ADC1]),
        .T224_m03_adc1_q_tvalid         (adc_q_tvalid[T224_M03_ADC1]),
        .T225_m10_adc2_i_tdata          (adc_i_tdata [T225_M10_ADC2]),
        .T225_m10_adc2_i_tready         (adc_i_tready[T225_M10_ADC2]),
        .T225_m10_adc2_i_tvalid         (adc_i_tvalid[T225_M10_ADC2]),
        .T225_m11_adc2_q_tdata          (adc_q_tdata [T225_M11_ADC2]),
        .T225_m11_adc2_q_tready         (adc_q_tready[T225_M11_ADC2]),
        .T225_m11_adc2_q_tvalid         (adc_q_tvalid[T225_M11_ADC2]),
        .T225_m12_adc3_i_tdata          (adc_i_tdata [T225_M12_ADC3]),
        .T225_m12_adc3_i_tready         (adc_i_tready[T225_M12_ADC3]),
        .T225_m12_adc3_i_tvalid         (adc_i_tvalid[T225_M12_ADC3]),
        .T225_m13_adc3_q_tdata          (adc_q_tdata [T225_M13_ADC3]),
        .T225_m13_adc3_q_tready         (adc_q_tready[T225_M13_ADC3]),
        .T225_m13_adc3_q_tvalid         (adc_q_tvalid[T225_M13_ADC3]),
        .T226_m20_adc4_i_tdata          (adc_i_tdata [T226_M20_ADC4]),
        .T226_m20_adc4_i_tready         (adc_i_tready[T226_M20_ADC4]),
        .T226_m20_adc4_i_tvalid         (adc_i_tvalid[T226_M20_ADC4]),
        .T226_m21_adc4_q_tdata          (adc_q_tdata [T226_M21_ADC4]),
        .T226_m21_adc4_q_tready         (adc_q_tready[T226_M21_ADC4]),
        .T226_m21_adc4_q_tvalid         (adc_q_tvalid[T226_M21_ADC4]),
        .T226_m22_adc5_i_tdata          (adc_i_tdata [T226_M22_ADC5]),
        .T226_m22_adc5_i_tready         (adc_i_tready[T226_M22_ADC5]),
        .T226_m22_adc5_i_tvalid         (adc_i_tvalid[T226_M22_ADC5]),
        .T226_m23_adc5_q_tdata          (adc_q_tdata [T226_M23_ADC5]),
        .T226_m23_adc5_q_tready         (adc_q_tready[T226_M23_ADC5]),
        .T226_m23_adc5_q_tvalid         (adc_q_tvalid[T226_M23_ADC5]),
        .T227_m30_adc6_i_tdata          (adc_i_tdata [T227_M30_ADC6]),
        .T227_m30_adc6_i_tready         (adc_i_tready[T227_M30_ADC6]),
        .T227_m30_adc6_i_tvalid         (adc_i_tvalid[T227_M30_ADC6]),
        .T227_m31_adc6_q_tdata          (adc_q_tdata [T227_M31_ADC6]),
        .T227_m31_adc6_q_tready         (adc_q_tready[T227_M31_ADC6]),
        .T227_m31_adc6_q_tvalid         (adc_q_tvalid[T227_M31_ADC6]),
        .T227_m32_adc7_i_tdata          (adc_i_tdata [T227_M32_ADC7]),
        .T227_m32_adc7_i_tready         (adc_i_tready[T227_M32_ADC7]),
        .T227_m32_adc7_i_tvalid         (adc_i_tvalid[T227_M32_ADC7]),
        .T227_m33_adc7_q_tdata          (adc_q_tdata [T227_M33_ADC7]),
        .T227_m33_adc7_q_tready         (adc_q_tready[T227_M33_ADC7]),
        .T227_m33_adc7_q_tvalid         (adc_q_tvalid[T227_M33_ADC7]),
        .T228_dac_s00_axis_tdata        (dac_tdata   [T228_S00_DAC0]),
        .T228_dac_s00_axis_tready       (dac_tready  [T228_S00_DAC0]),
        .T228_dac_s00_axis_tvalid       (dac_tvalid  [T228_S00_DAC0]),
        .T228_dac_s02_axis_tdata        (dac_tdata   [T228_S02_DAC1]),
        .T228_dac_s02_axis_tready       (dac_tready  [T228_S02_DAC1]),
        .T228_dac_s02_axis_tvalid       (dac_tvalid  [T228_S02_DAC1]),
        .T229_dac_s10_axis_tdata        (dac_tdata   [T229_S10_DAC2]),
        .T229_dac_s10_axis_tready       (dac_tready  [T229_S10_DAC2]),
        .T229_dac_s10_axis_tvalid       (dac_tvalid  [T229_S10_DAC2]),
        .T229_dac_s12_axis_tdata        (dac_tdata   [T229_S12_DAC3]),
        .T229_dac_s12_axis_tready       (dac_tready  [T229_S12_DAC3]),
        .T229_dac_s12_axis_tvalid       (dac_tvalid  [T229_S12_DAC3]),
        .T230_dac_s20_axis_tdata        (dac_tdata   [T230_S20_DAC4]),
        .T230_dac_s20_axis_tready       (dac_tready  [T230_S20_DAC4]),
        .T230_dac_s20_axis_tvalid       (dac_tvalid  [T230_S20_DAC4]),
        .T230_dac_s22_axis_tdata        (dac_tdata   [T230_S22_DAC5]),
        .T230_dac_s22_axis_tready       (dac_tready  [T230_S22_DAC5]),
        .T230_dac_s22_axis_tvalid       (dac_tvalid  [T230_S22_DAC5]),
        .T231_dac_s30_axis_tdata        (dac_tdata   [T231_S30_DAC6]),
        .T231_dac_s30_axis_tready       (dac_tready  [T231_S30_DAC6]),
        .T231_dac_s30_axis_tvalid       (dac_tvalid  [T231_S30_DAC6]),
        .T231_dac_s32_axis_tdata        (dac_tdata   [T231_S32_DAC7]),
        .T231_dac_s32_axis_tready       (dac_tready  [T231_S32_DAC7]),
        .T231_dac_s32_axis_tvalid       (dac_tvalid  [T231_S32_DAC7]),		
        .adc1_clk_clk_n                 (adc1_clk_clk_n  ),
        .adc1_clk_clk_p                 (adc1_clk_clk_p  ),	
		.one_pps_in                     (one_pps_in      ),
		.fh_gtrefclk0_clk_p             (gt_ref_clk_clk_p),
		.fh_gtrefclk0_clk_n             (gt_ref_clk_clk_n),
		
		.fh_sfp_rx_gt_port_0_n          (fh_sfp_rx_gt_port_0_n),
        .fh_sfp_rx_gt_port_0_p          (fh_sfp_rx_gt_port_0_p),
        .fh_sfp_tx_gt_port_0_n          (fh_sfp_tx_gt_port_0_n),
        .fh_sfp_tx_gt_port_0_p          (fh_sfp_tx_gt_port_0_p),

        .M_AXIS_CFR_DOUT_tdata          (IFP_cfr_m_axis_dout.tdata ),
        .M_AXIS_CFR_DOUT_tready         (IFP_cfr_m_axis_dout.tready),
        .M_AXIS_CFR_DOUT_tvalid         (IFP_cfr_m_axis_dout.tvalid),

        .S_AXIS_CFR_DIN_tdata           (IFP_cfr_s_axis_din.tdata ),
        .S_AXIS_CFR_DIN_tready          (IFP_cfr_s_axis_din.tready),
        .S_AXIS_CFR_DIN_tvalid          (IFP_cfr_s_axis_din.tvalid),

        .m_axis_dpd_dout_tdata          (IFP_dpd_m_axis_dout.tdata),
        .m_axis_dpd_dout_tlast          (IFP_dpd_m_axis_dout.tlast),
        .m_axis_dpd_dout_tready         (IFP_dpd_m_axis_dout.tready),
        .m_axis_dpd_dout_tuser          (IFP_dpd_m_axis_dout.tuser),
        .m_axis_dpd_dout_tvalid         (IFP_dpd_m_axis_dout.tvalid),

        .m_axis_dpd_srx_ctrl_tdata      (IFP_dpd_m_axis_srx_ctrl.tdata),
        .m_axis_dpd_srx_ctrl_tready     (IFP_dpd_m_axis_srx_ctrl.tready),
        .m_axis_dpd_srx_ctrl_tvalid     (IFP_dpd_m_axis_srx_ctrl.tvalid),

        .s_axis_dpd_din_tdata           (IFP_dpd_s_axis_din.tdata),
        .s_axis_dpd_din_tlast           (IFP_dpd_s_axis_din.tlast),
        .s_axis_dpd_din_tready          (IFP_dpd_s_axis_din.tready),
        .s_axis_dpd_din_tuser           (IFP_dpd_s_axis_din.tuser),
        .s_axis_dpd_din_tvalid          (IFP_dpd_s_axis_din.tvalid),	

        .s_axis_dpd_srx_tdata           (IFP_dpd_s_axis_srx.tdata),
        .s_axis_dpd_srx_tready          (IFP_dpd_s_axis_srx.tready),
        .s_axis_dpd_srx_tuser           (IFP_dpd_s_axis_srx.tuser),
        .s_axis_dpd_srx_tvalid          (IFP_dpd_s_axis_srx.tvalid),
		
        .adc_over_range                 (adc_over_range),
        .adc_over_threshold1            (adc_over_threshold1),
        .adc_over_threshold2            (adc_over_threshold2),
        .adc_over_voltage               (adc_over_voltage),
        .axi_aresetn_100M               (axi_aresetn),
        .axi_clk_100M                   (axi_clk),
        .axis_aresetn                   (axis_aresetn),
		.reg_top_reset                  (reg_top_reset),
		.dac_shutdown                   (dac_shutdown),
        .clk_15p36                      (clk_15p36),
        .clk_122p88                     (clk_122p88),
        .clk_245p76                     (clk_245p76),
        .clk_368p64                     (clk_368p64),
        .clk_491p52                     (clk_491p52),
		.clk_400M                       (clk_400M),
		.pl_ptpclk_clk_p                (pl_ptpclk_p),
		.pl_ptpclk_clk_n                (pl_ptpclk_n),
		.ptp_clk                        (ptp_clk    ), 
        .dac2_clk_clk_n                 (dac2_clk_clk_n),
        .dac2_clk_clk_p                 (dac2_clk_clk_p),
        .emio_spi0_m_i                  (emio_spi0_m_i),
        .emio_spi0_m_o                  (emio_spi0_m_o),
        .emio_spi0_sclk_o               (emio_spi0_sclk_o),
        .emio_spi0_ss_o_n               (emio_spi0_ss_o_n),
        .iic_sfp0_scl_i                 (iic_sfp_scl_i[0]),
        .iic_sfp0_scl_o                 (iic_sfp_scl_o[0]),
        .iic_sfp0_scl_t                 (iic_sfp_scl_t[0]),
        .iic_sfp0_sda_i                 (iic_sfp_sda_i[0]),
        .iic_sfp0_sda_o                 (iic_sfp_sda_o[0]),
        .iic_sfp0_sda_t                 (iic_sfp_sda_t[0]),
        .iic_sfp1_scl_i                 (iic_sfp_scl_i[1]),
        .iic_sfp1_scl_o                 (iic_sfp_scl_o[1]),
        .iic_sfp1_scl_t                 (iic_sfp_scl_t[1]),
        .iic_sfp1_sda_i                 (iic_sfp_sda_i[1]),
        .iic_sfp1_sda_o                 (iic_sfp_sda_o[1]),
        .iic_sfp1_sda_t                 (iic_sfp_sda_t[1]),
        .iic_sfp2_scl_i                 (iic_sfp_scl_i[2]),
        .iic_sfp2_scl_o                 (iic_sfp_scl_o[2]),
        .iic_sfp2_scl_t                 (iic_sfp_scl_t[2]),
        .iic_sfp2_sda_i                 (iic_sfp_sda_i[2]),
        .iic_sfp2_sda_o                 (iic_sfp_sda_o[2]),
        .iic_sfp2_sda_t                 (iic_sfp_sda_t[2]),
        .iic_sfp3_scl_i                 (iic_sfp_scl_i[3]),
        .iic_sfp3_scl_o                 (iic_sfp_scl_o[3]),
        .iic_sfp3_scl_t                 (iic_sfp_scl_t[3]),
        .iic_sfp3_sda_i                 (iic_sfp_sda_i[3]),
        .iic_sfp3_sda_o                 (iic_sfp_sda_o[3]),
        .iic_sfp3_sda_t                 (iic_sfp_sda_t[3]),
        .irq_adc_dac                    (irq_adc_dac     ),
        .o_fifo_dac_tdata               (o_fifo_dac_tdata ),
        .o_fifo_dac_tvalid              (o_fifo_dac_tvalid),
        .pl_ps_irq0                     (pl_ps_irq0),
		.UART_1_rxd                     (uart1_rxd),
		.UART_1_txd                     (uart1_txd),
        //.pl_ps_irq1                     (pl_ps_irq1),
        .pl_refclk1_clk_n               (pl_refclk1_n),
        .pl_refclk1_clk_p               (pl_refclk1_p),
        .pl_refclk1_locked              (pl_refclk1_locked),
        .pl_refclk2_clk_n               (pl_refclk2_n),
        .pl_refclk2_clk_p               (pl_refclk2_p),
        .pl_refclk2_locked              (pl_refclk2_locked),
        .pl_sysref_clk_n                (pl_sysref_n),
        .pl_sysref_clk_p                (pl_sysref_p),
        .sysref_in_diff_n               (ana_sysref_n),
        .sysref_in_diff_p               (ana_sysref_p)

);
    
    // ------------------------------------------------------------------ //
    // ADC Connections (Dual RF-ADC Tiles)                                //
    // ------------------------------------------------------------------ //
    // PG269 v2.2, page 58                                                //
    // There are four streams per tile, and the naming convention is      //
    // mXY_axis, where X represents the RF-ADC tile number and Y          //
    // represents a stream (FIFO) output from that tile.                  //
    //                                                                    //
    // For Dual tiles, a given stream is either real, I or Q.             //
    //      If an RF-ADC is configured with I/Q output data, then the     //
    //      streams with an even number represent I data and the streams  //
    //      with an odd number represent Q data.                          //
    // For Quad tiles, a given stream is either real or I/Q interleaved.  //
    // ------------------------------------------------------------------ //
    
    // RX RF chain to ADC mapping - See schematic for details on ADC/RX mapping
    localparam RX0 = ADC0;
    localparam RX1 = ADC1;
    localparam RX2 = ADC2;
    localparam RX3 = ADC3;
    localparam RX4 = ADC4;
    localparam RX5 = ADC5;
    localparam RX6 = ADC6;
    localparam RX7 = ADC7;

    // Ant 0
    assign adc_i_tready[RX3]    = 1'b1; // IFP_ul[0].tready;
    assign adc_q_tready[RX3]    = 1'b1; // IFP_ul[0].tready;
    assign IFP_ul[0][0].tvalid  = adc_i_tvalid[RX3]; // & adc_q_tvalid[RX3];
    assign IFP_ul[0][0].tdata   = {adc_q_tdata[RX3][31:16], adc_i_tdata[RX3][31:16],adc_q_tdata[RX3][15:0], adc_i_tdata[RX3][15:0]}; // {q,i}	
	//assign IFP_srx[0].tvalid    = IFP_ul[0][0].tvalid;
	//assign IFP_srx[0].tdata     = IFP_ul[0][0].tdata;
	//assign IFP_srx_copy[0][0].tvalid = IFP_ul[0][0].tvalid;
	//assign IFP_srx_copy[0][0].tdata  = IFP_ul[0][1].tdata;	
    // Ant 1
    assign adc_i_tready[RX1]    = 1'b1; // IFP_ul[1].tready;
    assign adc_q_tready[RX1]    = 1'b1; // IFP_ul[1].tready;
    assign IFP_ul[0][1].tvalid  = adc_i_tvalid[RX1]; // & adc_q_tvalid[RX1];
    assign IFP_ul[0][1].tdata   = {adc_q_tdata[RX1][31:16], adc_i_tdata[RX1][31:16],adc_q_tdata[RX1][15:0], adc_i_tdata[RX1][15:0]}; // {q,i}
	//assign IFP_srx[1].tvalid    = IFP_ul[0][1].tvalid;
	//assign IFP_srx[1].tdata     = IFP_ul[0][1].tdata;
	//assign IFP_srx_copy[0][1].tvalid = IFP_ul[0][1].tvalid;
	//assign IFP_srx_copy[0][1].tdata  = IFP_ul[0][1].tdata;	
    // Ant 2
    assign adc_i_tready[RX0]    = 1'b1; // IFP_ul[2].tready;
    assign adc_q_tready[RX0]    = 1'b1; // IFP_ul[2].tready;
    assign IFP_ul[0][2].tvalid  = adc_i_tvalid[RX0]; // & adc_q_tvalid[RX0];
    assign IFP_ul[0][2].tdata   = {adc_q_tdata[RX0][31:16], adc_i_tdata[RX0][31:16],adc_q_tdata[RX0][15:0], adc_i_tdata[RX0][15:0]}; // {q,i}
	//assign IFP_srx[2].tvalid    = IFP_ul[0][2].tvalid;
	//assign IFP_srx[2].tdata     = IFP_ul[0][2].tdata;
	//assign IFP_srx_copy[0][2].tvalid = IFP_ul[0][2].tvalid;
	//assign IFP_srx_copy[0][2].tdata  = IFP_ul[0][2].tdata;	
    // Ant 3
    assign adc_i_tready[RX2]    = 1'b1; // IFP_ul[3].tready;
    assign adc_q_tready[RX2]    = 1'b1; // IFP_ul[3].tready;
    assign IFP_ul[0][3].tvalid  = adc_i_tvalid[RX2]; // & adc_q_tvalid[RX3];
    assign IFP_ul[0][3].tdata   = {adc_q_tdata[RX2][31:16], adc_i_tdata[RX2][31:16],adc_q_tdata[RX2][15:0], adc_i_tdata[RX2][15:0]}; // {q,i}
	//assign IFP_srx[3].tvalid    = IFP_ul[0][3].tvalid;
	//assign IFP_srx[3].tdata     = IFP_ul[0][3].tdata;
 	//assign IFP_srx_copy[0][3].tvalid = IFP_ul[0][3].tvalid;
	//assign IFP_srx_copy[0][3].tdata  = IFP_ul[0][3].tdata;	
   // Ant 4
    assign adc_i_tready[RX4]    = 1'b1; // IFP_ul[4].tready;
    assign adc_q_tready[RX4]    = 1'b1; // IFP_ul[4].tready;
    assign IFP_ul[1][0].tvalid  = adc_i_tvalid[RX4]; // & adc_q_tvalid[RX4];
    assign IFP_ul[1][0].tdata   = {adc_q_tdata[RX4][31:16], adc_i_tdata[RX4][31:16],adc_q_tdata[RX4][15:0], adc_i_tdata[RX4][15:0]}; // {q,i}
	//assign IFP_srx[4].tvalid    = IFP_ul[1][0].tvalid;
	//assign IFP_srx[4].tdata     = IFP_ul[1][0].tdata;
	//assign IFP_srx_copy[1][0].tvalid = IFP_ul[1][0].tvalid;
	//assign IFP_srx_copy[1][0].tdata  = IFP_ul[1][0].tdata;	
    // Ant 5
    assign adc_i_tready[RX6]    = 1'b1; // IFP_ul[5].tready;
    assign adc_q_tready[RX6]    = 1'b1; // IFP_ul[5].tready;
    assign IFP_ul[1][1].tvalid  = adc_i_tvalid[RX6]; // & adc_q_tvalid[RX6];
    assign IFP_ul[1][1].tdata   = {adc_q_tdata[RX6][31:16], adc_i_tdata[RX6][31:16],adc_q_tdata[RX6][15:0], adc_i_tdata[RX6][15:0]}; // {q,i}
	//assign IFP_srx[5].tvalid    = IFP_ul[1][1].tvalid;
	//assign IFP_srx[5].tdata     = IFP_ul[1][1].tdata;
	//assign IFP_srx_copy[1][1].tvalid = IFP_ul[1][1].tvalid;
	//assign IFP_srx_copy[1][1].tdata  = IFP_ul[1][1].tdata;
    // Ant 6
    assign adc_i_tready[RX7]    = 1'b1; // IFP_ul[6].tready;
    assign adc_q_tready[RX7]    = 1'b1; // IFP_ul[6].tready;
    assign IFP_ul[1][2].tvalid  = adc_i_tvalid[RX7]; // & adc_q_tvalid[RX7];
    assign IFP_ul[1][2].tdata   = {adc_q_tdata[RX7][31:16], adc_i_tdata[RX7][31:16],adc_q_tdata[RX7][15:0], adc_i_tdata[RX7][15:0]}; // {q,i}
	//assign IFP_srx[6].tvalid    = IFP_ul[1][2].tvalid;
	//assign IFP_srx[6].tdata     = IFP_ul[1][2].tdata;
	//assign IFP_srx_copy[1][2].tvalid = IFP_ul[1][2].tvalid;
	//assign IFP_srx_copy[1][2].tdata  = IFP_ul[1][2].tdata;
    // Ant 7
    assign adc_i_tready[RX5]    = 1'b1; // IFP_ul[7].tready;
    assign adc_q_tready[RX5]    = 1'b1; // IFP_ul[7].tready;
    assign IFP_ul[1][3].tvalid  = adc_i_tvalid[RX5]; // & adc_q_tvalid[RX5];
    assign IFP_ul[1][3].tdata   = {adc_q_tdata[RX5][31:16], adc_i_tdata[RX5][31:16],adc_q_tdata[RX5][15:0], adc_i_tdata[RX5][15:0]}; // {q,i}
	//assign IFP_srx[7].tvalid    = IFP_ul[1][3].tvalid;
	//assign IFP_srx[7].tdata     = IFP_ul[1][3].tdata;
	//assign IFP_srx_copy[1][3].tvalid = IFP_ul[1][3].tvalid;
	//assign IFP_srx_copy[1][3].tdata  = IFP_ul[1][3].tdata;
    // ------------------------------------------------------------------ //
    // DAC Connections                                                    //
    // ------------------------------------------------------------------ //
    // DAC to TX RF chain mapping -See schematic for details on DAC/TX mapping
    localparam TX0 = DAC0;
    localparam TX1 = DAC1;
    localparam TX2 = DAC2;
    localparam TX3 = DAC3;
    localparam TX4 = DAC4;
    localparam TX5 = DAC5;
    localparam TX6 = DAC6;
    localparam TX7 = DAC7;

    // Ant 0
    assign IFP_dl[0][0].tready  = dac_tready[TX3];
    assign dac_tvalid[TX3]         = IFP_dl[0][0].tvalid;
    assign dac_tdata[TX3]          = IFP_dl[0][0].tdata;

    // Ant 1
    assign IFP_dl[0][1].tready  = dac_tready[TX1];
    assign dac_tvalid[TX1]         = IFP_dl[0][1].tvalid;
    assign dac_tdata[TX1]          = IFP_dl[0][1].tdata;

    // Ant 2
    assign IFP_dl[0][2].tready  = dac_tready[TX0];
    assign dac_tvalid[TX0]         = IFP_dl[0][2].tvalid;
    assign dac_tdata[TX0]          = IFP_dl[0][2].tdata;

    // Ant 3
    assign IFP_dl[0][3].tready  = dac_tready[TX2];
    assign dac_tvalid[TX2]         = IFP_dl[0][3].tvalid;
    assign dac_tdata[TX2]          = IFP_dl[0][3].tdata;

    // Ant 4
    assign IFP_dl[1][0].tready  = dac_tready[TX5];
    assign dac_tvalid[TX5]         = IFP_dl[1][0].tvalid;
    assign dac_tdata[TX5]          = IFP_dl[1][0].tdata;

    // Ant 5
    assign IFP_dl[1][1].tready  = dac_tready[TX7];
    assign dac_tvalid[TX7]         = IFP_dl[1][1].tvalid;
    assign dac_tdata[TX7]          = IFP_dl[1][1].tdata;

    // Ant 6
    assign IFP_dl[1][2].tready  = dac_tready[TX6];
    assign dac_tvalid[TX6]         = IFP_dl[1][2].tvalid;
    assign dac_tdata[TX6]          = IFP_dl[1][2].tdata;

    // Ant 7
    assign IFP_dl[1][3].tready  = dac_tready[TX4];
    assign dac_tvalid[TX4]         = IFP_dl[1][3].tvalid;
    assign dac_tdata[TX4]          = IFP_dl[1][3].tdata;


endmodule
