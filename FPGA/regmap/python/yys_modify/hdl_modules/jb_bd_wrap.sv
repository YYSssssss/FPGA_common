
`timescale 1 ps / 1 ps

module jb_bd_wrap #(
    parameter   N_CARRIERS                  = 2,
    parameter   N_ANTENNAS                  = 4,
    parameter   N_ETH_PORTS                 = 2,
    parameter   TOP_CTRL_AXI_ADDR_WIDTH     = 13,
    parameter   DPD_HOST_USER_ADDR_WIDTH    = 12,
    parameter   DPD_CTRL_ADDR_WIDTH         = 26,
    parameter   CFR_CTRL_ADDR_WIDTH         = 21       
) (
    input                               ana_sysref_n,
    input                               ana_sysref_p,

    input                               pl_refclk_n,
    input                               pl_refclk_p,
    input                               pl_sysref_n,
    input                               pl_sysref_p,
    input                               adc0_clk_n,
    input                               adc0_clk_p,
    input                               adc1_clk_n,
    input                               adc1_clk_p,
    input                               adc2_clk_n,
    input                               adc2_clk_p,
    input                               dac0_clk_n,
    input                               dac0_clk_p,
    input                               fh_gtrefclk0_p,
    input                               fh_gtrefclk0_n,
    input                               pl_ptpclk_p,
    input                               pl_ptpclk_n,
    input                               radio_start_10ms,
    output  logic                       fh_recclk,
    output  logic                       fh_rx_clk_out,
    

    output                              ps_clk1_200K,
    output                              axi_clk_100M,
    output                              axi_resetn_100M,
    output                              clk_122p88,
    output                              clk_368p64,
    output                              clk_491p52,
    output                              clk_15p36,
    output                              clk_400M,
    output                              aresetn_400M,
    output                              dfe_resetn_slow_clk,
    output                              aresetn_368p64,

    jb_hw_ctrl_if.hw_ctrl_rfdc          IFP_ctrl,
    
    output                              dbgbuf_porta_rst,
    output                              dbgbuf_porta_clk,
    jb_ram_sp_if.host                   IFP_dbgbuf_porta,

    output                              IFP_iwavebuf_porta_rst,
    output                              IFP_iwavebuf_porta_clk,
    jb_ram_sp_if.host                   IFP_iwavebuf_porta,

    jb_axi4_lite_if.master              IFP_axi_com_ctrl,
    jb_axi4_lite_if.master              IFP_axi_hw_ctrl,
    jb_axi4_lite_if.master              IFP_axi_intr_ctrl,
    jb_axi4_lite_if.master              IFP_axi_test_ctrl,
    jb_axi4_lite_if.master              IFP_axi_dl_ctrl,
    jb_axi4_lite_if.master              IFP_axi_ul_ctrl,
    jb_axi4_lite_if.master              IFP_axi_oran_lphy,
    jb_axi4_lite_if.master              IFP_axi_fh_proc,
    
    // GCLewis:
    jb_oran_lphy_ctrl_if.lphy           IFP_oran_lphy_ctrl,
    jb_oran_lphy_stat_if.cnts           IFP_oran_lphy_stat,
    
    jb_axi4_stream_if.slave             IFP_dpd_s_axis_din,         // 128,32
    jb_axi4_stream_if.master            IFP_dpd_m_axis_dout,        // 128,32
    jb_dpd_srx_if.dpd                   IFP_dpd_srx,
       
    jb_axi4_stream_if.slave             IFP_cfr_s_axis_din,         // 128,1
    jb_axi4_stream_if.master            IFP_cfr_m_axis_dout,        // 128,1
    
    jb_axi4_stream_if.master            IFP_srx         [N_ANTENNAS-1:0],
    jb_axi4_stream_if.master            IFP_srx_copy    [N_ANTENNAS-1:0],
    
    jb_axi4_stream_if.master            IFP_ul          [N_ANTENNAS-1:0],   // adc interface
    jb_axi4_stream_if.slave             IFP_dl          [N_ANTENNAS-1:0],   // dac interface

    //FH Interfaces
   
    jb_fh_misc_if.fh                    IFP_fh_misc,
    jb_fh_cc_timing_if.fh               IFP_fh_cc_timing [N_CARRIERS-1:0],
    jb_cplane_bid_if.fh                 IFP_dl_defm_cplane_bid [N_ANTENNAS-1:0],
    jb_cplane_bid_if.fh                 IFP_ul_fram_cplane_bid [N_ANTENNAS-1:0],
    jb_prach_cplane_if.fh               IFP_prach_cplane,   // adc inte
    jb_xran_header_ecpri_if.fh          IFP_xran_header_ecpri[N_ETH_PORTS-1:0],
    jb_xran_header_app_cmn_if.fh        IFP_xran_header_app_cmn[N_ETH_PORTS-1:0],
    jb_xran_header_app_section_if.fh    IFP_xran_header_app_section[N_ETH_PORTS-1:0],
    
    jb_axi4_stream_if.master            IFP_dl_defm_uplane  [N_ANTENNAS-1:0],   // Radio IP DL
    jb_axi4_stream_if.slave             IFP_ul_fram_uplane  [N_ANTENNAS-1:0],   // Radio IP UL
    output  [N_ANTENNAS-1:0] [24:0]     fh_ul_fram_data_req,
    jb_axi4_stream_if.slave             IFP_prach_uplane,   // Prach U Plane
    jb_axi4_stream_if.slave             IFP_unsol_ul_uplane,   // Radio IP UL
    jb_axi4_stream_if.master            IFP_xran_unsup[N_ETH_PORTS-1:0],
    jb_axi4_stream_if.master            IFP_xran_bweight[N_ETH_PORTS-1:0],
    
    
    output                              ptp_clk,
    input                               one_pps_in,

    input                               fh_sfp_rxn,
    input                               fh_sfp_rxp,
    output                              fh_sfp_txn,
    output                              fh_sfp_txp,

    input           [7:0]               pl_ps_irq0,
    input           [7:0]               pl_ps_irq1,
    output  logic                       irq_adc_dac,

    output  logic   [7:0]               adc_over_threshold1,
    output  logic   [7:0]               adc_over_threshold2,
    output  logic   [7:0]               adc_over_range,
    output  logic   [7:0]               adc_over_voltage,
    
    input           [1:0]               axi_i2c_scl_i,
    output  logic   [1:0]               axi_i2c_scl_o,
    output  logic   [1:0]               axi_i2c_scl_t,
    input           [1:0]               axi_i2c_sda_i,
    output  logic   [1:0]               axi_i2c_sda_o,
    output  logic   [1:0]               axi_i2c_sda_t,

    input                               emio_spi0_miso_i,
    output                              emio_spi0_mosi_o,
    output                              emio_spi0_sclk_o,
    output          [7:0]               emio_spi0_ss_o_n,

    input                               emio_uart1_rxd,
    output                              emio_uart1_txd,

    output                              clk_testout_fpga_p,
    output                              clk_testout_fpga_n

);

    genvar i;
    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
    localparam  N_ADC = 8;
    localparam  N_DAC = 8;
    localparam  N_ADC_USED = 6;
    localparam  N_DAC_USED = N_ANTENNAS;
    localparam  USER_ID_BW = $clog2(N_ANTENNAS); // $clog2(N_ADC);

    localparam  ADC0 = 0,   T224_ADC01 = 0;
    localparam  ADC1 = 1,   T224_ADC23 = 1;
    localparam  ADC2 = 2,   T225_ADC01 = 2;
    localparam  ADC3 = 3,   T225_ADC23 = 3;
    localparam  ADC4 = 4,   T226_ADC01 = 4;
    localparam  ADC5 = 5,   T226_ADC23 = 5;
    localparam  ADC6 = 6,   T227_ADC01 = 6;
    localparam  ADC7 = 7,   T227_ADC23 = 7;

    localparam  DAC0 = 0,   T228_DAC00 = 0;
    localparam  DAC1 = 1,   T228_DAC01 = 1;
    localparam  DAC2 = 2,   T228_DAC02 = 2;
    localparam  DAC3 = 3,   T228_DAC03 = 3;
    localparam  DAC4 = 4,   T229_DAC00 = 4;
    localparam  DAC5 = 5,   T229_DAC01 = 5;
    localparam  DAC6 = 6,   T229_DAC02 = 6;
    localparam  DAC7 = 7,   T229_DAC03 = 7;


    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    // ADC port connections
    logic   [15:0]              adc_i_tdata     [N_ADC-1:0];
    logic   [15:0]              adc_q_tdata     [N_ADC-1:0];

    jb_axi4_stream_if  #(.DATA_WIDTH(32), .USER_SB_WIDTH(USER_ID_BW)) IFP_adc   [N_ADC-1:0]();
    jb_axi4_stream_if  #(.DATA_WIDTH(64), .USER_SB_WIDTH(USER_ID_BW)) IFP_dac   [N_DAC-1:0]();

    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
 
    //bram check 
    logic dbgbuf_rsta_busy;
    logic dbgbuf_rstb_busy;
   
   logic [31:0]  axi_dl_ctrl_araddr;
   logic [31:0]  axi_dl_ctrl_awaddr;
   logic [31:0]  axi_ul_ctrl_araddr;
   logic [31:0]  axi_ul_ctrl_awaddr;
   logic [31:0]  axi_com_ctrl_araddr;
   logic [31:0]  axi_com_ctrl_awaddr;
   logic [31:0]  axi_intr_ctrl_araddr;
   logic [31:0]  axi_intr_dbg_awaddr;
   logic [31:0]  axi_fh_proc_araddr;
   logic [31:0]  axi_fh_proc_awaddr;
   logic [31:0]  axi_hw_ctrl_araddr;
   logic [31:0]  axi_hw_ctrl_awaddr;
   logic [31:0]  axi_oran_lphy_araddr;
   logic [31:0]  axi_oran_lphy_awaddr;
   logic [31:0]  axi_test_ctrl_araddr;
   logic [31:0]  axi_test_ctrl_awaddr;
   
    jb_axi4_stream_if  #(.DATA_WIDTH(32),  .USER_SB_WIDTH(8))    IFP_dpd_s_axis_srx();       //
   jb_axi4_stream_if  #(.DATA_WIDTH(8),   .USER_SB_WIDTH(1))    IFP_dpd_m_axis_srx_ctrl();  //
   jb_axi4_stream_if  #(.DATA_WIDTH(16),  .USER_SB_WIDTH(1))    IFP_dpd_s_axis_sid();       //
 
    logic [4:0]     CounterNames;
    logic [23:0]    CounterValues;

   assign IFP_axi_dl_ctrl.araddr =axi_dl_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_dl_ctrl.awaddr = axi_dl_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_ul_ctrl.araddr = axi_ul_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_ul_ctrl.awaddr = axi_ul_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_com_ctrl.araddr = axi_com_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_com_ctrl.awaddr = axi_com_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_intr_ctrl.araddr = axi_intr_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_intr_ctrl.awaddr = axi_intr_dbg_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_fh_proc.araddr = axi_fh_proc_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_fh_proc.awaddr = axi_fh_proc_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_hw_ctrl.araddr = axi_hw_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_hw_ctrl.awaddr = axi_hw_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_oran_lphy.araddr = axi_oran_lphy_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_oran_lphy.awaddr = axi_oran_lphy_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_test_ctrl.araddr = axi_test_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_axi_test_ctrl.awaddr = axi_test_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
  

   assign IFP_dpd_s_axis_sid.tdata  =0; // 16
   assign IFP_dpd_s_axis_sid.tvalid = 1'b0;

   
   

   //DPD SRC assignments
   assign IFP_dpd_srx.srx_ctrl_tdata=IFP_dpd_m_axis_srx_ctrl.tdata;
   assign IFP_dpd_srx.srx_ctrl_tvalid=IFP_dpd_m_axis_srx_ctrl.tvalid;
   assign IFP_dpd_m_axis_srx_ctrl.tready =IFP_dpd_srx.srx_ctrl_tready;

   assign IFP_dpd_s_axis_srx.tdata  = IFP_dpd_srx.srx_tdata; // 32
   assign IFP_dpd_s_axis_srx.tuser  = IFP_dpd_srx.srx_tuser; // 8
   assign IFP_dpd_s_axis_srx.tvalid = IFP_dpd_srx.srx_tvalid; 
   assign IFP_dpd_srx.srx_tready = IFP_dpd_s_axis_srx.tready;
   
  // SM BETA 
//  generate 

  jb_lphy_oran_dbg_cntrs
  jb_lphy_oran_dbg_cntrs_inst(
    .clkin              (clk_122p88),
    .rstin              (~dfe_resetn_slow_clk),
    .clkout             (axi_clk_100M),
    .rstout             (~axi_resetn_100M),
    .CounterNames       (CounterNames),
    .CounterValues      (CounterValues),
    .IFP_oran_lphy_stat (IFP_oran_lphy_stat)
    );
  
  design_1 bd_sub6_u0 (
        .aresetn_368p64                 (aresetn_368p64),
        .dfe_resetn_slow_clk            (dfe_resetn_slow_clk),

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
        
        .axi4_lite_com_ctrl_araddr      (axi_com_ctrl_araddr),
        .axi4_lite_com_ctrl_arprot      (IFP_axi_com_ctrl.arprot),
        .axi4_lite_com_ctrl_arready     (IFP_axi_com_ctrl.arready),
        .axi4_lite_com_ctrl_arvalid     (IFP_axi_com_ctrl.arvalid),
        .axi4_lite_com_ctrl_awaddr      (axi_com_ctrl_awaddr),
        .axi4_lite_com_ctrl_awprot      (IFP_axi_com_ctrl.awprot),
        .axi4_lite_com_ctrl_awready     (IFP_axi_com_ctrl.awready),
        .axi4_lite_com_ctrl_awvalid     (IFP_axi_com_ctrl.awvalid),
        .axi4_lite_com_ctrl_bready      (IFP_axi_com_ctrl.bready),
        .axi4_lite_com_ctrl_bresp       (IFP_axi_com_ctrl.bresp),
        .axi4_lite_com_ctrl_bvalid      (IFP_axi_com_ctrl.bvalid),
        .axi4_lite_com_ctrl_rdata       (IFP_axi_com_ctrl.rdata),
        .axi4_lite_com_ctrl_rready      (IFP_axi_com_ctrl.rready),
        .axi4_lite_com_ctrl_rresp       (IFP_axi_com_ctrl.rresp),
        .axi4_lite_com_ctrl_rvalid      (IFP_axi_com_ctrl.rvalid),
        .axi4_lite_com_ctrl_wdata       (IFP_axi_com_ctrl.wdata),
        .axi4_lite_com_ctrl_wready      (IFP_axi_com_ctrl.wready),
        .axi4_lite_com_ctrl_wstrb       (IFP_axi_com_ctrl.wstrb),
        .axi4_lite_com_ctrl_wvalid      (IFP_axi_com_ctrl.wvalid),

        .axi4_lite_dl_ctrl_araddr       (axi_dl_ctrl_araddr),
        .axi4_lite_dl_ctrl_arprot       (IFP_axi_dl_ctrl.arprot),
        .axi4_lite_dl_ctrl_arready      (IFP_axi_dl_ctrl.arready),
        .axi4_lite_dl_ctrl_arvalid      (IFP_axi_dl_ctrl.arvalid),
        .axi4_lite_dl_ctrl_awaddr       (axi_dl_ctrl_awaddr),
        .axi4_lite_dl_ctrl_awprot       (IFP_axi_dl_ctrl.awprot),
        .axi4_lite_dl_ctrl_awready      (IFP_axi_dl_ctrl.awready),
        .axi4_lite_dl_ctrl_awvalid      (IFP_axi_dl_ctrl.awvalid),
        .axi4_lite_dl_ctrl_bready       (IFP_axi_dl_ctrl.bready),
        .axi4_lite_dl_ctrl_bresp        (IFP_axi_dl_ctrl.bresp),
        .axi4_lite_dl_ctrl_bvalid       (IFP_axi_dl_ctrl.bvalid),
        .axi4_lite_dl_ctrl_rdata        (IFP_axi_dl_ctrl.rdata),
        .axi4_lite_dl_ctrl_rready       (IFP_axi_dl_ctrl.rready),
        .axi4_lite_dl_ctrl_rresp        (IFP_axi_dl_ctrl.rresp),
        .axi4_lite_dl_ctrl_rvalid       (IFP_axi_dl_ctrl.rvalid),
        .axi4_lite_dl_ctrl_wdata        (IFP_axi_dl_ctrl.wdata),
        .axi4_lite_dl_ctrl_wready       (IFP_axi_dl_ctrl.wready),
        .axi4_lite_dl_ctrl_wstrb        (IFP_axi_dl_ctrl.wstrb),
        .axi4_lite_dl_ctrl_wvalid       (IFP_axi_dl_ctrl.wvalid),

        .axi4_lite_fh_proc_araddr       (axi_fh_proc_araddr),
        .axi4_lite_fh_proc_arprot       (IFP_axi_fh_proc.arprot),
        .axi4_lite_fh_proc_arready      (IFP_axi_fh_proc.arready),
        .axi4_lite_fh_proc_arvalid      (IFP_axi_fh_proc.arvalid),
        .axi4_lite_fh_proc_awaddr       (axi_fh_proc_awaddr),
        .axi4_lite_fh_proc_awprot       (IFP_axi_fh_proc.awprot),
        .axi4_lite_fh_proc_awready      (IFP_axi_fh_proc.awready),
        .axi4_lite_fh_proc_awvalid      (IFP_axi_fh_proc.awvalid),
        .axi4_lite_fh_proc_bready       (IFP_axi_fh_proc.bready),
        .axi4_lite_fh_proc_bresp        (IFP_axi_fh_proc.bresp),
        .axi4_lite_fh_proc_bvalid       (IFP_axi_fh_proc.bvalid),
        .axi4_lite_fh_proc_rdata        (IFP_axi_fh_proc.rdata),
        .axi4_lite_fh_proc_rready       (IFP_axi_fh_proc.rready),
        .axi4_lite_fh_proc_rresp        (IFP_axi_fh_proc.rresp),
        .axi4_lite_fh_proc_rvalid       (IFP_axi_fh_proc.rvalid),
        .axi4_lite_fh_proc_wdata        (IFP_axi_fh_proc.wdata),
        .axi4_lite_fh_proc_wready       (IFP_axi_fh_proc.wready),
        .axi4_lite_fh_proc_wstrb        (IFP_axi_fh_proc.wstrb),
        .axi4_lite_fh_proc_wvalid       (IFP_axi_fh_proc.wvalid),

        .axi4_lite_hw_ctrl_araddr       (axi_hw_ctrl_araddr),
        .axi4_lite_hw_ctrl_arprot       (IFP_axi_hw_ctrl.arprot),
        .axi4_lite_hw_ctrl_arready      (IFP_axi_hw_ctrl.arready),
        .axi4_lite_hw_ctrl_arvalid      (IFP_axi_hw_ctrl.arvalid),
        .axi4_lite_hw_ctrl_awaddr       (axi_hw_ctrl_awaddr),
        .axi4_lite_hw_ctrl_awprot       (IFP_axi_hw_ctrl.awprot),
        .axi4_lite_hw_ctrl_awready      (IFP_axi_hw_ctrl.awready),
        .axi4_lite_hw_ctrl_awvalid      (IFP_axi_hw_ctrl.awvalid),
        .axi4_lite_hw_ctrl_bready       (IFP_axi_hw_ctrl.bready),
        .axi4_lite_hw_ctrl_bresp        (IFP_axi_hw_ctrl.bresp),
        .axi4_lite_hw_ctrl_bvalid       (IFP_axi_hw_ctrl.bvalid),
        .axi4_lite_hw_ctrl_rdata        (IFP_axi_hw_ctrl.rdata),
        .axi4_lite_hw_ctrl_rready       (IFP_axi_hw_ctrl.rready),
        .axi4_lite_hw_ctrl_rresp        (IFP_axi_hw_ctrl.rresp),
        .axi4_lite_hw_ctrl_rvalid       (IFP_axi_hw_ctrl.rvalid),
        .axi4_lite_hw_ctrl_wdata        (IFP_axi_hw_ctrl.wdata),
        .axi4_lite_hw_ctrl_wready       (IFP_axi_hw_ctrl.wready),
        .axi4_lite_hw_ctrl_wstrb        (IFP_axi_hw_ctrl.wstrb),
        .axi4_lite_hw_ctrl_wvalid       (IFP_axi_hw_ctrl.wvalid),

        .axi4_lite_intr_ctrl_araddr     (axi_intr_ctrl_araddr),
        .axi4_lite_intr_ctrl_arprot     (IFP_axi_intr_ctrl.arprot),
        .axi4_lite_intr_ctrl_arready    (IFP_axi_intr_ctrl.arready),
        .axi4_lite_intr_ctrl_arvalid    (IFP_axi_intr_ctrl.arvalid),
        .axi4_lite_intr_ctrl_awaddr     (axi_intr_dbg_awaddr),
        .axi4_lite_intr_ctrl_awprot     (IFP_axi_intr_ctrl.awprot),
        .axi4_lite_intr_ctrl_awready    (IFP_axi_intr_ctrl.awready),
        .axi4_lite_intr_ctrl_awvalid    (IFP_axi_intr_ctrl.awvalid),
        .axi4_lite_intr_ctrl_bready     (IFP_axi_intr_ctrl.bready),
        .axi4_lite_intr_ctrl_bresp      (IFP_axi_intr_ctrl.bresp),
        .axi4_lite_intr_ctrl_bvalid     (IFP_axi_intr_ctrl.bvalid),
        .axi4_lite_intr_ctrl_rdata      (IFP_axi_intr_ctrl.rdata),
        .axi4_lite_intr_ctrl_rready     (IFP_axi_intr_ctrl.rready),
        .axi4_lite_intr_ctrl_rresp      (IFP_axi_intr_ctrl.rresp),
        .axi4_lite_intr_ctrl_rvalid     (IFP_axi_intr_ctrl.rvalid),
        .axi4_lite_intr_ctrl_wdata      (IFP_axi_intr_ctrl.wdata),
        .axi4_lite_intr_ctrl_wready     (IFP_axi_intr_ctrl.wready),
        .axi4_lite_intr_ctrl_wstrb      (IFP_axi_intr_ctrl.wstrb),
        .axi4_lite_intr_ctrl_wvalid     (IFP_axi_intr_ctrl.wvalid),

        .axi4_lite_oran_lphy_araddr     (axi_oran_lphy_araddr),
        .axi4_lite_oran_lphy_arprot     (IFP_axi_oran_lphy.arprot),
        .axi4_lite_oran_lphy_arready    (IFP_axi_oran_lphy.arready),
        .axi4_lite_oran_lphy_arvalid    (IFP_axi_oran_lphy.arvalid),
        .axi4_lite_oran_lphy_awaddr     (axi_oran_lphy_awaddr),
        .axi4_lite_oran_lphy_awprot     (IFP_axi_oran_lphy.awprot),
        .axi4_lite_oran_lphy_awready    (IFP_axi_oran_lphy.awready),
        .axi4_lite_oran_lphy_awvalid    (IFP_axi_oran_lphy.awvalid),
        .axi4_lite_oran_lphy_bready     (IFP_axi_oran_lphy.bready),
        .axi4_lite_oran_lphy_bresp      (IFP_axi_oran_lphy.bresp),
        .axi4_lite_oran_lphy_bvalid     (IFP_axi_oran_lphy.bvalid),
        .axi4_lite_oran_lphy_rdata      (IFP_axi_oran_lphy.rdata),
        .axi4_lite_oran_lphy_rready     (IFP_axi_oran_lphy.rready),
        .axi4_lite_oran_lphy_rresp      (IFP_axi_oran_lphy.rresp),
        .axi4_lite_oran_lphy_rvalid     (IFP_axi_oran_lphy.rvalid),
        .axi4_lite_oran_lphy_wdata      (IFP_axi_oran_lphy.wdata),
        .axi4_lite_oran_lphy_wready     (IFP_axi_oran_lphy.wready),
        .axi4_lite_oran_lphy_wstrb      (IFP_axi_oran_lphy.wstrb),
        .axi4_lite_oran_lphy_wvalid     (IFP_axi_oran_lphy.wvalid),

        .axi4_lite_test_ctrl_araddr     (axi_test_ctrl_araddr),
        .axi4_lite_test_ctrl_arprot     (IFP_axi_test_ctrl.arprot),
        .axi4_lite_test_ctrl_arready    (IFP_axi_test_ctrl.arready),
        .axi4_lite_test_ctrl_arvalid    (IFP_axi_test_ctrl.arvalid),
        .axi4_lite_test_ctrl_awaddr     (axi_test_ctrl_awaddr),
        .axi4_lite_test_ctrl_awprot     (IFP_axi_test_ctrl.awprot),
        .axi4_lite_test_ctrl_awready    (IFP_axi_test_ctrl.awready),
        .axi4_lite_test_ctrl_awvalid    (IFP_axi_test_ctrl.awvalid),
        .axi4_lite_test_ctrl_bready     (IFP_axi_test_ctrl.bready),
        .axi4_lite_test_ctrl_bresp      (IFP_axi_test_ctrl.bresp),
        .axi4_lite_test_ctrl_bvalid     (IFP_axi_test_ctrl.bvalid),
        .axi4_lite_test_ctrl_rdata      (IFP_axi_test_ctrl.rdata),
        .axi4_lite_test_ctrl_rready     (IFP_axi_test_ctrl.rready),
        .axi4_lite_test_ctrl_rresp      (IFP_axi_test_ctrl.rresp),
        .axi4_lite_test_ctrl_rvalid     (IFP_axi_test_ctrl.rvalid),
        .axi4_lite_test_ctrl_wdata      (IFP_axi_test_ctrl.wdata),
        .axi4_lite_test_ctrl_wready     (IFP_axi_test_ctrl.wready),
        .axi4_lite_test_ctrl_wstrb      (IFP_axi_test_ctrl.wstrb),
        .axi4_lite_test_ctrl_wvalid     (IFP_axi_test_ctrl.wvalid),

        .axi4_lite_ul_ctrl_araddr       (axi_ul_ctrl_araddr),
        .axi4_lite_ul_ctrl_arprot       (IFP_axi_ul_ctrl.arprot),
        .axi4_lite_ul_ctrl_arready      (IFP_axi_ul_ctrl.arready),
        .axi4_lite_ul_ctrl_arvalid      (IFP_axi_ul_ctrl.arvalid),
        .axi4_lite_ul_ctrl_awaddr       (axi_ul_ctrl_awaddr),
        .axi4_lite_ul_ctrl_awprot       (IFP_axi_ul_ctrl.awprot),
        .axi4_lite_ul_ctrl_awready      (IFP_axi_ul_ctrl.awready),
        .axi4_lite_ul_ctrl_awvalid      (IFP_axi_ul_ctrl.awvalid),
        .axi4_lite_ul_ctrl_bready       (IFP_axi_ul_ctrl.bready),
        .axi4_lite_ul_ctrl_bresp        (IFP_axi_ul_ctrl.bresp),
        .axi4_lite_ul_ctrl_bvalid       (IFP_axi_ul_ctrl.bvalid),
        .axi4_lite_ul_ctrl_rdata        (IFP_axi_ul_ctrl.rdata),
        .axi4_lite_ul_ctrl_rready       (IFP_axi_ul_ctrl.rready),
        .axi4_lite_ul_ctrl_rresp        (IFP_axi_ul_ctrl.rresp),
        .axi4_lite_ul_ctrl_rvalid       (IFP_axi_ul_ctrl.rvalid),
        .axi4_lite_ul_ctrl_wdata        (IFP_axi_ul_ctrl.wdata),
        .axi4_lite_ul_ctrl_wready       (IFP_axi_ul_ctrl.wready),
        .axi4_lite_ul_ctrl_wstrb        (IFP_axi_ul_ctrl.wstrb),
        .axi4_lite_ul_ctrl_wvalid       (IFP_axi_ul_ctrl.wvalid),

        .adc_over_range                 (adc_over_range),                       // o [7:0]
        .adc_over_voltage               (adc_over_voltage),                     // o [7:0]
        .adc_over_threshold1            (adc_over_threshold1),                  // o [7:0]
        .adc_over_threshold2            (adc_over_threshold2),                  // o [7:0]
        .adc0_clk_clk_n                 (adc0_clk_n),
        .adc0_clk_clk_p                 (adc0_clk_p),
        .adc1_clk_clk_n                 (adc1_clk_n),
        .adc1_clk_clk_p                 (adc1_clk_p),
        .adc2_clk_clk_n                 (adc2_clk_n),
        .adc2_clk_clk_p                 (adc2_clk_p),
        .axi_clk_100M                   (axi_clk_100M),
        .axi_resetn_100M                (axi_resetn_100M),
        .axi_i2c_scl_i                  (axi_i2c_scl_i[0]),
        .axi_i2c_scl_o                  (axi_i2c_scl_o[0]),
        .axi_i2c_scl_t                  (axi_i2c_scl_t[0]),
        .axi_i2c_sda_i                  (axi_i2c_sda_i[0]),
        .axi_i2c_sda_o                  (axi_i2c_sda_o[0]),
        .axi_i2c_sda_t                  (axi_i2c_sda_t[0]),
        .axi_i2c1_scl_i                 (axi_i2c_scl_i[1]),
        .axi_i2c1_scl_o                 (axi_i2c_scl_o[1]),
        .axi_i2c1_scl_t                 (axi_i2c_scl_t[1]),
        .axi_i2c1_sda_i                 (axi_i2c_sda_i[1]),
        .axi_i2c1_sda_o                 (axi_i2c_sda_o[1]),
        .axi_i2c1_sda_t                 (axi_i2c_sda_t[1]),
        .cfr_m_axis_dout_tdata          (IFP_cfr_m_axis_dout.tdata),
        .cfr_m_axis_dout_tready         (IFP_cfr_m_axis_dout.tready),
        .cfr_m_axis_dout_tvalid         (IFP_cfr_m_axis_dout.tvalid),
        .cfr_s_axis_din_tdata           (IFP_cfr_s_axis_din.tdata),
        .cfr_s_axis_din_tready          (IFP_cfr_s_axis_din.tready),
        .cfr_s_axis_din_tvalid          (IFP_cfr_s_axis_din.tvalid),
        .clk_122p88                     (clk_122p88),
        .clk_368p64                     (clk_368p64),
        .clk_491p52                     (clk_491p52),
        .clk_15p36                      (clk_15p36),
        .clk_400M                       (clk_400M), 
        .aresetn_clk_400M               (aresetn_400M),
        .fh_sfp_rx_gt_port_0_n          (fh_sfp_rxn),
        .fh_sfp_rx_gt_port_0_p          (fh_sfp_rxp),
        .fh_sfp_tx_gt_port_0_n          (fh_sfp_txn),
        .fh_sfp_tx_gt_port_0_p          (fh_sfp_txp),
        .pl_ptpclk_clk_n                (pl_ptpclk_n),
        .pl_ptpclk_clk_p                (pl_ptpclk_p),
        .fh_gtrefclk0_clk_n             (fh_gtrefclk0_n),
        .fh_gtrefclk0_clk_p             (fh_gtrefclk0_p),
        .fh_recclk                      (fh_recclk),
        .fh_rx_clk_out                  (fh_rx_clk_out),
	////////////////////////   RADIO IP IF SIGNAL BEGIN///////////////////
	.ptp_clk                        (ptp_clk),
	.one_pps_in                     (one_pps_in),
	.systimer_s                     (IFP_fh_misc.systimer_s),
	.systimer_ns                    (IFP_fh_misc.systimer_ns),
        .one_pps_out                        (IFP_fh_misc.one_pps),
        .dl_defm_radio_start_10ms       (IFP_fh_misc.dl_radio_start_10ms[0]),
        .ul_fram_radio_start_10ms       (IFP_fh_misc.ul_radio_start_10ms[0]),

	// High when reset is active in the Ethernet clock domains. 
	// This signal can be optionally used to reset downstream logic. 
	// The signal level canalso be read using the AXI4-Literegister bank
        .eth0_fram_reset_active         (IFP_fh_misc.eth_fram_reset_active[0]), //per ETh port
	//Low when the framer is flushing buffers or under
        //reset. Use is optional. The signal level can also be
        //read using the AXI4-Lite register bank. The signal is
        //kept Low while the system resets the table used by
        //the framer sequence counter generator upon a
        //fram_reset activation.
        .ul_fram_ready                  (IFP_fh_misc.ul_fram_ready),
	//Low when the de-framer is flushing buffers or
        //under reset. Use is optional. The signal level can
        //also be read using the AXI4-Lite register bank
        .dl_defm_ready                  (IFP_fh_misc.dl_defm_ready),
        
  // GCLewis: debug counters are cleared when this signal is high. Re-use UL clear for now:
        .ClearCounters                  (IFP_oran_lphy_ctrl.lphy_oran_dbg_clear ),
        .CounterNames                   (CounterNames                           ),
        .CounterValues                  (CounterValues                          ),
	       
	//DL DATA from RADIo IF IP AXIS steam, Ant0
        .m000_data_axis_tdata           (IFP_dl_defm_uplane[0].tdata),
        .m000_data_axis_tkeep           (IFP_dl_defm_uplane[0].tkeep),
        .m000_data_axis_tlast           (IFP_dl_defm_uplane[0].tlast),
        .m000_data_axis_tready          (IFP_dl_defm_uplane[0].tready),
        .m000_data_axis_tuser           (IFP_dl_defm_uplane[0].tuser),
        .m000_data_axis_tvalid          (IFP_dl_defm_uplane[0].tvalid),
	//DL DATA from RADIo IF IP AXIS steam,Ant1
        .m001_data_axis_tdata           (IFP_dl_defm_uplane[1].tdata),
        .m001_data_axis_tkeep           (IFP_dl_defm_uplane[1].tkeep),
        .m001_data_axis_tlast           (IFP_dl_defm_uplane[1].tlast),
        .m001_data_axis_tready          (IFP_dl_defm_uplane[1].tready),
        .m001_data_axis_tuser           (IFP_dl_defm_uplane[1].tuser),
        .m001_data_axis_tvalid          (IFP_dl_defm_uplane[1].tvalid),

	//DL DATA from RADIo IF IP AXIS steam,Ant2
        .m002_data_axis_tdata           (IFP_dl_defm_uplane[2].tdata),
        .m002_data_axis_tkeep           (IFP_dl_defm_uplane[2].tkeep),
        .m002_data_axis_tlast           (IFP_dl_defm_uplane[2].tlast),
        .m002_data_axis_tready          (IFP_dl_defm_uplane[2].tready),
        .m002_data_axis_tuser           (IFP_dl_defm_uplane[2].tuser),
        .m002_data_axis_tvalid          (IFP_dl_defm_uplane[2].tvalid),
	
         //DL DATA from RADIo IF IP AXIS steam,Ant3
        .m003_data_axis_tdata           (IFP_dl_defm_uplane[3].tdata),
        .m003_data_axis_tkeep           (IFP_dl_defm_uplane[3].tkeep),
        .m003_data_axis_tlast           (IFP_dl_defm_uplane[3].tlast),
        .m003_data_axis_tready          (IFP_dl_defm_uplane[3].tready),
        .m003_data_axis_tuser           (IFP_dl_defm_uplane[3].tuser),
        .m003_data_axis_tvalid          (IFP_dl_defm_uplane[3].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant0
        .s000_data_axis_tdata           (IFP_ul_fram_uplane[0].tdata),
        .s000_data_axis_tkeep           (IFP_ul_fram_uplane[0].tkeep),
        .s000_data_axis_tlast           (IFP_ul_fram_uplane[0].tlast),
        .s000_data_axis_tready          (IFP_ul_fram_uplane[0].tready),
        .s000_data_axis_tvalid          (IFP_ul_fram_uplane[0].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant1
        .s001_data_axis_tdata           (IFP_ul_fram_uplane[1].tdata),
        .s001_data_axis_tkeep           (IFP_ul_fram_uplane[1].tkeep),
        .s001_data_axis_tlast           (IFP_ul_fram_uplane[1].tlast),
        .s001_data_axis_tready          (IFP_ul_fram_uplane[1].tready),
        .s001_data_axis_tvalid          (IFP_ul_fram_uplane[1].tvalid),

	//UL DATA AXIS to RADIO IF IP, Ant2	       
        .s002_data_axis_tdata           (IFP_ul_fram_uplane[2].tdata),
        .s002_data_axis_tkeep           (IFP_ul_fram_uplane[2].tkeep),
        .s002_data_axis_tlast           (IFP_ul_fram_uplane[2].tlast),
        .s002_data_axis_tready          (IFP_ul_fram_uplane[2].tready),
        .s002_data_axis_tvalid          (IFP_ul_fram_uplane[2].tvalid),
		       
	//UL DATA AXIS to RADIO IF IP, Ant3
        .s003_data_axis_tdata           (IFP_ul_fram_uplane[3].tdata),
        .s003_data_axis_tkeep           (IFP_ul_fram_uplane[3].tkeep),
        .s003_data_axis_tlast           (IFP_ul_fram_uplane[3].tlast),
        .s003_data_axis_tready          (IFP_ul_fram_uplane[3].tready),
        .s003_data_axis_tvalid          (IFP_ul_fram_uplane[3].tvalid),

	
        // Ul Framer Request for the Data
        .s000_fram_data_req             (fh_ul_fram_data_req[0]),
        .s001_fram_data_req             (fh_ul_fram_data_req[1]),
        .s002_fram_data_req             (fh_ul_fram_data_req[2]),
        .s003_fram_data_req             (fh_ul_fram_data_req[3]),
		       

		       
	//Carrier0  timing params
        .cc0_timing_cc_enable           (IFP_fh_cc_timing[0].cc_enable),
        .cc0_timing_cc_reload           (IFP_fh_cc_timing[0].cc_reload),
     //   .cc0_timing_dl_cta_sym_num      (IFP_fh_cc_timing[0].dl_cta_sym_num),
      //  .cc0_timing_dl_sym_num          (IFP_fh_cc_timing[0].dl_sym_num),
        .cc0_timing_dl_update           (IFP_fh_cc_timing[0].dl_update),
    //    .cc0_timing_ul_cta_sym_num      (IFP_fh_cc_timing[0].ul_cta_sym_num),
      //  .cc0_timing_ul_sym_num          (IFP_fh_cc_timing[0].ul_sym_num),
        .cc0_timing_ul_update           (IFP_fh_cc_timing[0].ul_update),

	//Carrier1 timing params
        .cc1_timing_cc_enable           (IFP_fh_cc_timing[1].cc_enable),
        .cc1_timing_cc_reload           (IFP_fh_cc_timing[1].cc_reload),
        .cc1_timing_dl_cta_sym_num      (IFP_fh_cc_timing[1].dl_cta_sym_num),
        .cc1_timing_dl_sym_num          (IFP_fh_cc_timing[1].dl_sym_num),
        .cc1_timing_dl_update           (IFP_fh_cc_timing[1].dl_update),
        .cc1_timing_ul_cta_sym_num      (IFP_fh_cc_timing[1].ul_cta_sym_num),
        .cc1_timing_ul_sym_num          (IFP_fh_cc_timing[1].ul_sym_num),
        .cc1_timing_ul_update           (IFP_fh_cc_timing[1].ul_update),	       

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
        ////////////////////////   RADIO IP IF SIGNA END///////////////////

		       
        .dac0_clk_clk_n                 (dac0_clk_n),
        .dac0_clk_clk_p                 (dac0_clk_p),
        .dpd_m_axis_dout_tdata          (IFP_dpd_m_axis_dout.tdata),
        .dpd_m_axis_dout_tlast          (IFP_dpd_m_axis_dout.tlast),
        .dpd_m_axis_dout_tready         (IFP_dpd_m_axis_dout.tready),
        .dpd_m_axis_dout_tuser          (IFP_dpd_m_axis_dout.tuser),
        .dpd_m_axis_dout_tvalid         (IFP_dpd_m_axis_dout.tvalid),
        .dpd_m_axis_srx_ctrl_tdata      (IFP_dpd_m_axis_srx_ctrl.tdata),
        .dpd_m_axis_srx_ctrl_tready     (IFP_dpd_m_axis_srx_ctrl.tready),
        .dpd_m_axis_srx_ctrl_tvalid     (IFP_dpd_m_axis_srx_ctrl.tvalid),
        .dpd_s_axis_din_tdata           (IFP_dpd_s_axis_din.tdata),
        .dpd_s_axis_din_tlast           (IFP_dpd_s_axis_din.tlast),
        .dpd_s_axis_din_tready          (IFP_dpd_s_axis_din.tready),
        .dpd_s_axis_din_tuser           (IFP_dpd_s_axis_din.tuser),
        .dpd_s_axis_din_tvalid          (IFP_dpd_s_axis_din.tvalid),
        .dpd_s_axis_sid_tdata           (IFP_dpd_s_axis_sid.tdata),
        .dpd_s_axis_sid_tready          (IFP_dpd_s_axis_sid.tready),
        .dpd_s_axis_sid_tvalid          (IFP_dpd_s_axis_sid.tvalid),
        .dpd_s_axis_srx_tdata           (IFP_dpd_s_axis_srx.tdata),
        .dpd_s_axis_srx_tready          (IFP_dpd_s_axis_srx.tready),
        .dpd_s_axis_srx_tuser           (IFP_dpd_s_axis_srx.tuser),
        .dpd_s_axis_srx_tvalid          (IFP_dpd_s_axis_srx.tvalid),       
        .emio_spi0_miso_i               (emio_spi0_miso_i),
        .emio_spi0_mosi_o               (emio_spi0_mosi_o),
        .emio_spi0_sclk_o               (emio_spi0_sclk_o),
        .emio_spi0_ss_o_n               (emio_spi0_ss_o_n),
        .emio_uart1_rxd                 (emio_uart1_rxd),
        .emio_uart1_txd                 (emio_uart1_txd),
        .irq_adc_dac                    (irq_adc_dac),

        .T224_m00_adc0_i_tdata          (adc_i_tdata [ADC0]),
        .T224_m00_adc0_i_tready         (IFP_adc[ADC0].tready),
        .T224_m00_adc0_i_tvalid         (IFP_adc[ADC0].tvalid),
        .T224_m01_adc0_q_tdata          (adc_q_tdata [ADC0]),
        .T224_m01_adc0_q_tready         (IFP_adc[ADC0].tready),
        .T224_m01_adc0_q_tvalid         (),
        .T224_m02_adc1_i_tdata          (adc_i_tdata [ADC1]),
        .T224_m02_adc1_i_tready         (IFP_adc[ADC1].tready),
        .T224_m02_adc1_i_tvalid         (IFP_adc[ADC1].tvalid),
        .T224_m03_adc1_q_tdata          (adc_q_tdata [ADC1]),
        .T224_m03_adc1_q_tready         (IFP_adc[ADC1].tready),
        .T224_m03_adc1_q_tvalid         (),
        .T225_m10_adc2_i_tdata          (adc_i_tdata [ADC2]),
        .T225_m10_adc2_i_tready         (IFP_adc[ADC2].tready),
        .T225_m10_adc2_i_tvalid         (IFP_adc[ADC2].tvalid),
        .T225_m11_adc2_q_tdata          (adc_q_tdata [ADC2]),
        .T225_m11_adc2_q_tready         (IFP_adc[ADC2].tready),
        .T225_m11_adc2_q_tvalid         (),
        .T225_m12_adc3_i_tdata          (adc_i_tdata [ADC3]),
        .T225_m12_adc3_i_tready         (IFP_adc[ADC3].tready),
        .T225_m12_adc3_i_tvalid         (IFP_adc[ADC3].tvalid),
        .T225_m13_adc3_q_tdata          (adc_q_tdata [ADC3]),
        .T225_m13_adc3_q_tready         (IFP_adc[ADC3].tready),
        .T225_m13_adc3_q_tvalid         (),
        .T226_m20_adc4_i_tdata          (adc_i_tdata [ADC4]),
        .T226_m20_adc4_i_tready         (IFP_adc[ADC4].tready),
        .T226_m20_adc4_i_tvalid         (IFP_adc[ADC4].tvalid),
        .T226_m21_adc4_q_tdata          (adc_q_tdata [ADC4]),
        .T226_m21_adc4_q_tready         (IFP_adc[ADC4].tready),
        .T226_m21_adc4_q_tvalid         (),
        .T226_m22_adc5_i_tdata          (adc_i_tdata [ADC5]),
        .T226_m22_adc5_i_tready         (IFP_adc[ADC5].tready),
        .T226_m22_adc5_i_tvalid         (IFP_adc[ADC5].tvalid),
        .T226_m23_adc5_q_tdata          (adc_q_tdata [ADC5]),
        .T226_m23_adc5_q_tready         (IFP_adc[ADC5].tready),
        .T226_m23_adc5_q_tvalid         (),
//      .T227_m30_adc6_i_tdata          (adc_i_tdata [ADC6]),
//      .T227_m30_adc6_i_tready         (IFP_adc[ADC6].tready),
//      .T227_m30_adc6_i_tvalid         (IFP_adc[ADC6].tvalid),
//      .T227_m31_adc6_q_tdata          (adc_q_tdata [ADC6]),
//      .T227_m31_adc6_q_tready         (IFP_adc[ADC6].tready),
//      .T227_m31_adc6_q_tvalid         (),
//      .T227_m32_adc7_i_tdata          (adc_i_tdata [ADC7]),
//      .T227_m32_adc7_i_tready         (IFP_adc[ADC7].tready),
//      .T227_m32_adc7_i_tvalid         (IFP_adc[ADC7].tvalid),
//      .T227_m33_adc7_q_tdata          (adc_q_tdata [ADC7]),
//      .T227_m33_adc7_q_tready         (IFP_adc[ADC7].tready),
//      .T227_m33_adc7_q_tvalid         (),
        .T228_s00_dac0_tdata            (IFP_dac[DAC0].tdata),
        .T228_s00_dac0_tready           (IFP_dac[DAC0].tready),
        .T228_s00_dac0_tvalid           (IFP_dac[DAC0].tvalid),
        .T228_s01_dac1_tdata            (IFP_dac[DAC1].tdata),
        .T228_s01_dac1_tready           (IFP_dac[DAC1].tready),
        .T228_s01_dac1_tvalid           (IFP_dac[DAC1].tvalid),
        .T228_s02_dac2_tdata            (IFP_dac[DAC2].tdata),
        .T228_s02_dac2_tready           (IFP_dac[DAC2].tready),
        .T228_s02_dac2_tvalid           (IFP_dac[DAC2].tvalid),
        .T228_s03_dac3_tdata            (IFP_dac[DAC3].tdata),
        .T228_s03_dac3_tready           (IFP_dac[DAC3].tready),
        .T228_s03_dac3_tvalid           (IFP_dac[DAC3].tvalid),
//      .T229_s00_dac4_tdata            (IFP_dac[DAC4].tdata),
//      .T229_s00_dac4_tready           (IFP_dac[DAC4].tready),
//      .T229_s00_dac4_tvalid           (IFP_dac[DAC4].tvalid),
//      .T229_s01_dac5_tdata            (IFP_dac[DAC5].tdata),
//      .T229_s01_dac5_tready           (IFP_dac[DAC5].tready),
//      .T229_s01_dac5_tvalid           (IFP_dac[DAC5].tvalid),
//      .T229_s02_dac6_tdata            (IFP_dac[DAC6].tdata),
//      .T229_s02_dac6_tready           (IFP_dac[DAC6].tready),
//      .T229_s02_dac6_tvalid           (IFP_dac[DAC6].tvalid),
//      .T229_s03_dac7_tdata            (IFP_dac[DAC7].tdata),
//      .T229_s03_dac7_tready           (IFP_dac[DAC7].tready),
//      .T229_s03_dac7_tvalid           (IFP_dac[DAC7].tvalid),
        .pl_ps_irq0                     (pl_ps_irq0),
        .pl_ps_irq1                     (pl_ps_irq1),
        .pl_refclk_clk_n                (pl_refclk_n),
        .pl_refclk_clk_p                (pl_refclk_p),
        .pl_sysref_clk_n                (pl_sysref_n),
        .pl_sysref_clk_p                (pl_sysref_p),
        .ps_clk1_200K                   (ps_clk1_200K),
        .sysref_in_diff_n               (ana_sysref_n),
        .sysref_in_diff_p               (ana_sysref_p),
        .clk_testout_fpga_p             (clk_testout_fpga_p),
        .clk_testout_fpga_n             (clk_testout_fpga_n)
    );

    // ------------------------------------------------------------------ //
    // Unused DAC streams                                                 //
    // ------------------------------------------------------------------ //
    // Tie unused DAC signals to DFE
    generate
    for (i = N_DAC_USED; i < N_DAC; i = i + 1) begin : gen_unused_dacs
        assign IFP_dac[i].tready = 0;
    end : gen_unused_dacs
    endgenerate

    // ------------------------------------------------------------------ //
    // Unused ADC streams                                                 //
    // ------------------------------------------------------------------ //
    // Tie unused ADC signals to DFE
    generate
    for (i = N_ADC_USED; i < N_ADC; i = i + 1) begin : gen_unused_adcs
        assign adc_i_tdata [i] = 0;
        assign adc_q_tdata [i] = 0;
        assign IFP_adc[i].tvalid = 0;
    end : gen_unused_adcs
    endgenerate

    // ------------------------------------------------------------------ //
    // ADC IQ streams                                                     //
    // ------------------------------------------------------------------ //
    generate
    for (i = 0; i < N_ADC; i = i + 1) begin : gen_adc_iq
        assign IFP_adc[i].tdata = {adc_q_tdata[i], adc_i_tdata[i]}; // {q,i}
    end : gen_adc_iq
    endgenerate

    // ------------------------------------------------------------------ //
    // RF Data Converter Map                                              //
    // ------------------------------------------------------------------ //
    jb_rfdc_map #(
        .N_ANTENNAS                     (N_ANTENNAS),
        .N_ADC                          (N_ADC),
        .N_DAC                          (N_DAC)
    ) jb_rfdc_map_u0 (
        .axis_clk                       (clk_368p64),               // i
        .axis_aresetn                   (aresetn_368p64),           // i
        .axil_clk                       (axi_clk_100M),             // i
        .axil_aresetn                   (axi_resetn_100M),          // i
        .IFP_ctrl                       (IFP_ctrl),                 // jb_cmn_ctrl_if.hw_ctrl_rfdc
        .IFP_adc                        (IFP_adc),                  // jb_axi4_stream_if.slave  [N_ADC-1:0]
        .IFP_dac                        (IFP_dac),                  // jb_axi4_stream_if.master [N_DAC-1:0]
        .IFP_dfe_ul                     (IFP_ul),                   // jb_axi4_stream_if.master [N_ANTENNAS-1:0]
        .IFP_dfe_dl                     (IFP_dl),                   // jb_axi4_stream_if.slave  [N_ANTENNAS-1:0]
        .IFP_orx                        (IFP_srx)                   // jb_axi4_stream_if.master [N_ANTENNAS-1:0]
    );

    // ------------------------------------------------------------------ //
    // Debug Signals                                                      //
    // ------------------------------------------------------------------ //
    // SRX Streams copy to dbgmux
    generate
    for (i = 0; i < N_ANTENNAS; i = i + 1) begin : gen_srx_copy
        assign IFP_srx_copy[i].tdata    = IFP_srx[i].tdata;
        assign IFP_srx_copy[i].tvalid   = IFP_srx[i].tvalid;
    end : gen_srx_copy
    endgenerate


/*

   ila_oran u_ila_oran (
       .clk(clk_368p64), // input wire clk
       .probe0(IFP_fh_cc_timing[0].cc_enable), // input wire [0:0]  probe0  
       .probe1(IFP_fh_cc_timing[0].cc_reload), // input wire [31:0]  probe1 
       .probe2(IFP_fh_cc_timing[0].dl_cta_sym_num), // input wire [0:0]  probe2 
       .probe3(IFP_fh_cc_timing[0].dl_sym_num), // input wire [1:0]  probe3 
       .probe4(IFP_fh_cc_timing[0].dl_update), // input wire [15:0]  probe4 
       .probe5(IFP_fh_cc_timing[0].ul_cta_sym_num), // input wire [15:0]  probe5 
       .probe6(IFP_fh_cc_timing[0].ul_sym_num), // input wire [0:0]  probe6 
       .probe7(IFP_fh_cc_timing[0].ul_update), // input wire [15:0]  probe7 
       .probe8(IFP_dl_defm_cplane_bid[0].ready), // input wire [15:0]  probe7 
       .probe9(IFP_dl_defm_cplane_bid[0].tlast), // input wire [15:0]  probe8 
       .probe10(IFP_dl_defm_cplane_bid[0].valid), // input wire [15:0]  probe9 
       .probe11(IFP_dl_defm_uplane[0].tready), // input wire [0:0]  probe11 
       .probe12(IFP_xran_header_ecpri[0].t_header_offset_valid),//nput wire [15:0]  probe12 
       .probe13(IFP_dl_defm_cplane_bid[0].num_prbc), // input wire [15:0]  probe13 
       .probe14(IFP_dl_defm_cplane_bid[0].num_symbol), // input wire [0:0]  probe14 
       .probe15(IFP_dl_defm_cplane_bid[0].rb), // input wire [1:0]  probe15 
       .probe16(IFP_dl_defm_cplane_bid[0].remask[0]),// input wire [15:0]  probe16 
       .probe17(IFP_dl_defm_cplane_bid[0].start_prbc), // input wire [15:0]  probe17 
       .probe18(one_pps_in), // input wire [0:0]  probe18 
       .probe19(IFP_fh_misc.systimer_ns), // input wire [31:0]  probe19
       .probe20(IFP_fh_misc.one_pps), // input wire [0:0]  probe20 
       .probe21(IFP_fh_misc.dl_radio_start_10ms[0]), // 11input wire [15:0]  probe21 
       .probe22(IFP_fh_misc.dl_defm_ready), // input wire [15:0]  probe22 
       .probe23(IFP_dl_defm_uplane[0].tvalid), // input wire [0:0]  probe23 
       .probe24(IFP_dl_defm_uplane[0].tdata), // input wire [15:0]  probe24 
       .probe25(IFP_dl_defm_uplane[0].tlast), // input wire [15:0]  probe25 
       .probe26(IFP_dl_defm_uplane[0].tuser), // input wire [15:0]  probe26 
       .probe27(IFP_xran_header_ecpri[0].runt_packet_len), // input wire [15:0]  probe27 
       .probe28(IFP_xran_header_ecpri[0].rtc_pc_id), // input wire [0:0]  probe18 
       .probe29(IFP_xran_header_ecpri[0].concat), // input wire [31:0]  probe19
       .probe30(IFP_xran_header_ecpri[0].messagetype), // input wire [0:0]  probe20 
       .probe31(IFP_xran_header_ecpri[0].seqid), // 11input wire [15:0]  probe21 
       .probe32(IFP_xran_header_ecpri[0].subseqid), // input wire [15:0]  probe22 
       .probe33(IFP_xran_header_ecpri[0].ebit), // input wire [0:0]  probe23 
       .probe34(IFP_xran_header_ecpri[0].payloadsize), // input wire [15:0]  probe24 
       .probe35(IFP_xran_header_ecpri[0].packet_in_window), // input wire [15:0]  probe25 
       .probe36(IFP_xran_header_ecpri[0].offset_in_symbol), // input wire [15:0]  probe26 
       .probe37(IFP_xran_header_app_cmn[0].radio_app_head_valid), // input wire [15:0]  probe27 
       .probe38(IFP_xran_header_app_cmn[0].datadirection), // input wire [0:0]  probe18 
       .probe39(IFP_xran_header_app_cmn[0].numsections), // input wire [31:0]  probe19
       .probe40(IFP_xran_header_app_cmn[0].sectiontype), // input wire [0:0]  probe20 
       .probe41(IFP_xran_header_app_cmn[0].frameid), // 11input wire [15:0]  probe21 
       .probe42(IFP_xran_header_app_cmn[0].subframeid), // input wire [15:0]  probe22 
       .probe43(IFP_xran_header_app_cmn[0].slotid), // input wire [0:0]  probe23 
       .probe44(IFP_xran_header_app_cmn[0].symbolid), // input wire [15:0]  probe24 
       .probe45(IFP_xran_header_app_section[0].section_header_valid), // input wire [15:0]  probe25 
       .probe46(IFP_xran_header_app_section[0].numprbc), // input wire [15:0]  probe26 
       .probe47(IFP_xran_header_app_section[0].startprbc),// input wire [15:0]  probe27
       .probe48(IFP_xran_header_app_section[0].sectionid) // input wire [15:0]  probe27
);
*/
endmodule
