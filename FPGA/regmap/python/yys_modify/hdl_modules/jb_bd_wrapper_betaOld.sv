
`timescale 1 ps / 1 ps

module jb_bd_wrapper #(
    parameter N_CARRIERS    = 2,
    parameter N_ANTENNAS    = 4,
    parameter N_SRX_ADC     = 2,
    parameter TOP_CTRL_AXI_ADDR_WIDTH = 13,
    parameter DPD_HOST_USER_ADDR_WIDTH = 12,
    parameter DPD_CTRL_ADDR_WIDTH = 26,
    parameter CFR_CTRL_ADDR_WIDTH = 21		       
) (
    
    input                       sysref_in_0_diff_n,
    input                       sysref_in_0_diff_p,

    input                       pl_refclk_clk_n,
    input                       pl_refclk_clk_p,
    input                       pl_refclk1_clk_p,
    input                       pl_refclk1_clk_n,
    input                       pl_sysref_clk_n,
    input                       pl_sysref_clk_p,
    input                       adc0_clk_0_clk_n,
    input                       adc0_clk_0_clk_p,
    input                       adc1_clk_0_clk_n,
    input                       adc1_clk_0_clk_p,
    input                       adc2_clk_0_clk_n,
    input                       adc2_clk_0_clk_p,
    input                       dac0_clk_0_clk_n,
    input                       dac0_clk_0_clk_p,
    input                       cpri_refclk_in_clk_n,
    input                       cpri_refclk_in_clk_p,

    output                      ps_clk1_200K,
    output                      axi_clk_100M,
    output                      axi_resetn_100M,
    output                      clk_122p88,
    output                      clk_368p64,
    output                      clk_491p52,
    output                      clk_15p36,

   output                        dfe_resetn_slow_clk,
    output                      aresetn_368p64,
    output                      dbgbuf_porta_rst,
    output                      dbgbuf_porta_clk,
    jb_ram_sp_if.host           IFP_dbgbuf_porta,

    output                      IFP_iwavebuf_porta_rst,
    output                      IFP_iwavebuf_porta_clk,
    jb_ram_sp_if.host           IFP_iwavebuf_porta,
    
    jb_axi4_lite_if.master      IFP_m0_axi_top_dl_ctrl, // ADDR_WIDTH=32, DATA_WIDTH=32
    jb_axi4_lite_if.master      IFP_m1_axi_top_ul_ctrl,
    jb_axi4_lite_if.master      IFP_m2_axi_top_com_ctrl,
    jb_axi4_lite_if.master      IFP_m3_axi_top_intr_ctrl,
    jb_axi4_lite_if.master      IFP_m14_axi_top_hw_ctrl,
    jb_axi4_lite_if.master      IFP_m15_axi_top_test_ctrl,
    jb_axi4_lite_if.master      IFP_m4_axi_top_ctrl_fh_proc,
   
    jb_axi4_stream_if.slave     IFP_dpd_s_axis_din,         // 128,32
    jb_axi4_stream_if.master    IFP_dpd_m_axis_dout,        // 128,32
    jb_dpd_srx_if.dpd           IFP_dpd_srx,
       
    jb_axi4_stream_if.slave     IFP_cfr_s_axis_din,         // 128,1
    jb_axi4_stream_if.master    IFP_cfr_m_axis_dout,        // 128,1

    
    jb_axi4_stream_if.master    IFP_srx         [N_SRX_ADC-1:0],
    jb_axi4_stream_if.master    IFP_srx_copy    [N_SRX_ADC-1:0],
    
    jb_axi4_stream_if.master    IFP_adc[N_ANTENNAS-1:0],  // adc interface
    jb_axi4_stream_if.slave     IFP_dac[N_ANTENNAS-1:0], // dac interface



    //CPRI SIGNALS
    output cpri_core_clk,
    output cpri_core_recclk,
    input  cpri_core_reset,
    input  cpri_axi_resetn,
     jb_cpri_iq_if.core IFP_cpri_iq,
    jb_cpri_gt_if.core   IFP_cpri_gt,
    jb_cpri_suprt_if.core IFP_cpri_suprt,
    jb_cpri_ctrl_stat_if.core IFP_cpri_ctrl_stat,
   input  cpri_sfp_rxn,
   input  cpri_sfp_rxp,
   output cpri_sfp_txn,
   output cpri_sfp_txp,

    input           [7:0]       pl_ps_irq0,
    input           [7:0]       pl_ps_irq1,
    output                      irq_adc_dac,
    output          [3:0]       irq_adc_threshold1,
    output          [3:0]       irq_adc_threshold2,
    output          [3:0]       adc_over_range,
    output          [3:0]       adc_over_voltage,
    output          [1:0]       srx_over_range,
    output          [1:0]       srx_over_voltage,
    
    input                       axi_i2c_scl_i,
    output                      axi_i2c_scl_o,
    output                      axi_i2c_scl_t,
    input                       axi_i2c_sda_i,
    output                      axi_i2c_sda_o,
    output                      axi_i2c_sda_t,
    input                       axi_i2c1_scl_i,
    output                      axi_i2c1_scl_o,
    output                      axi_i2c1_scl_t,
    input                       axi_i2c1_sda_i,
    output                      axi_i2c1_sda_o,
    output                      axi_i2c1_sda_t,

    input                       emio_spi0_miso_i,
    output                      emio_spi0_mosi_o,
    output                      emio_spi0_sclk_o,
    output          [7:0]       emio_spi0_ss_o_n,

    //input                       emio_spi1_miso_i,
    //output                      emio_spi1_mosi_o,
    //output                      emio_spi1_sclk_o,
    //output          [7:0]       emio_spi1_ss_o_n,

    input                       emio_uart1_rxd,
    output                      emio_uart1_txd,

    input                       vin0_01_0_v_n,
    input                       vin0_01_0_v_p,
    input                       vin0_23_0_v_n,
    input                       vin0_23_0_v_p,
    input                       vin1_01_0_v_n,
    input                       vin1_01_0_v_p,
    input                       vin1_23_0_v_n,
    input                       vin1_23_0_v_p,
    input                       vin2_01_0_v_n,
    input                       vin2_01_0_v_p,
    input                       vin2_23_0_v_n,
    input                       vin2_23_0_v_p,
    output                      vout00_0_v_n,
    output                      vout00_0_v_p,
    output                      vout01_0_v_n,
    output                      vout01_0_v_p,
    output                      vout02_0_v_n,
    output                      vout02_0_v_p,
    output                      vout03_0_v_n,
    output                      vout03_0_v_p,
    output                      clk_testout_fpga_p,
    output                      clk_testout_fpga_n
);

    localparam STAT_SPEED_BITS=10; // 11 max, for 12Gbps=> 10
   logic [STAT_SPEED_BITS-1:0] 	stat_speed;

    // SRX ADCs
    logic [15:0]    m20_axis_0_tdata;
    logic           m20_axis_0_tready;
    logic           m20_axis_0_tvalid;
    logic [15:0]    m21_axis_0_tdata;
    logic           m21_axis_0_tready;
    logic           m21_axis_0_tvalid;
    logic [15:0]    m22_axis_0_tdata;
    logic           m22_axis_0_tready;
    logic           m22_axis_0_tvalid;
    logic [15:0]    m23_axis_0_tdata;
    logic           m23_axis_0_tready;
    logic           m23_axis_0_tvalid;


    // ADC Connections
    logic [15:0]m00_axis_0_tdata;
    logic m00_axis_0_tready;
    logic m00_axis_0_tvalid;
    logic [15:0]m01_axis_0_tdata;
    logic m01_axis_0_tready;
    logic m01_axis_0_tvalid;
    logic [15:0]m02_axis_0_tdata;
    logic m02_axis_0_tready;
    logic m02_axis_0_tvalid;
    logic [15:0]m03_axis_0_tdata;
    logic m03_axis_0_tready;
    logic m03_axis_0_tvalid;

    logic [15:0]m10_axis_0_tdata;
    logic m10_axis_0_tready;
    logic m10_axis_0_tvalid;
    logic [15:0]m11_axis_0_tdata;
    logic m11_axis_0_tready;
    logic m11_axis_0_tvalid;
    logic [15:0]m12_axis_0_tdata;
    logic m12_axis_0_tready;
    logic m12_axis_0_tvalid;
    logic [15:0]m13_axis_0_tdata;
    logic m13_axis_0_tready;
    logic m13_axis_0_tvalid;

    // DAC Connections

    // DAC 4 data
    logic [63:0]s00_axis_0_tdata;
    logic s00_axis_0_tready;
    logic s00_axis_0_tvalid;

    // DAC 3 data
    logic [63:0]s01_axis_0_tdata;
    logic s01_axis_0_tready;
    logic s01_axis_0_tvalid;
   
    // DAC 2 data
    logic [63:0]s02_axis_0_tdata;
    logic s02_axis_0_tready;
    logic s02_axis_0_tvalid;
    
    // DAC 1 data
    logic [63:0]s03_axis_0_tdata;
    logic s03_axis_0_tready;
    logic s03_axis_0_tvalid;

    //bram check 
    logic dbgbuf_rsta_busy;
    logic dbgbuf_rstb_busy;
   
   logic [31:0]  m0_axi_top_dl_ctrl_araddr;
   logic [31:0]  m0_axi_top_dl_ctrl_awaddr;
   logic [31:0]  m1_axi_top_ul_ctrl_araddr;
   logic [31:0]  m1_axi_top_ul_ctrl_awaddr;
   logic [31:0]  m2_axi_top_com_ctrl_araddr;
   logic [31:0]  m2_axi_top_com_ctrl_awaddr;
   logic [31:0]  m3_axi_top_intr_ctrl_araddr;
   logic [31:0]  m3_axi_top_intr_ctrl_awaddr;
   logic [31:0]  m4_axi_top_ctrl_fh_proc_araddr;
   logic [31:0]  m4_axi_top_ctrl_fh_proc_awaddr;
   logic [31:0]  m14_axi_top_hw_ctrl_araddr;
   logic [31:0]  m14_axi_top_hw_ctrl_awaddr;
   logic [31:0]  m15_axi_top_test_ctrl_araddr;
   logic [31:0]  m15_axi_top_test_ctrl_awaddr;
   
    jb_axi4_stream_if  #(.DATA_WIDTH(32),  .USER_SB_WIDTH(8))    IFP_dpd_s_axis_srx();       //
   jb_axi4_stream_if  #(.DATA_WIDTH(8),   .USER_SB_WIDTH(1))    IFP_dpd_m_axis_srx_ctrl();  //
   jb_axi4_stream_if  #(.DATA_WIDTH(16),  .USER_SB_WIDTH(1))    IFP_dpd_s_axis_sid();       //
 

   assign IFP_m0_axi_top_dl_ctrl.araddr =m0_axi_top_dl_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m0_axi_top_dl_ctrl.awaddr = m0_axi_top_dl_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m1_axi_top_ul_ctrl.araddr = m1_axi_top_ul_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m1_axi_top_ul_ctrl.awaddr = m1_axi_top_ul_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m2_axi_top_com_ctrl.araddr = m2_axi_top_com_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m2_axi_top_com_ctrl.awaddr = m2_axi_top_com_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m3_axi_top_intr_ctrl.araddr = m3_axi_top_intr_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m3_axi_top_intr_ctrl.awaddr = m3_axi_top_intr_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m4_axi_top_ctrl_fh_proc.araddr = m4_axi_top_ctrl_fh_proc_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m4_axi_top_ctrl_fh_proc.awaddr = m4_axi_top_ctrl_fh_proc_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m14_axi_top_hw_ctrl.araddr = m14_axi_top_hw_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m14_axi_top_hw_ctrl.awaddr = m14_axi_top_hw_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m15_axi_top_test_ctrl.araddr = m15_axi_top_test_ctrl_araddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
   assign IFP_m15_axi_top_test_ctrl.awaddr = m15_axi_top_test_ctrl_awaddr[TOP_CTRL_AXI_ADDR_WIDTH-1:0];
  

   assign IFP_dpd_s_axis_sid.tdata  =0; // 16
   assign IFP_dpd_s_axis_sid.tvalid = 1'b0;

   
   //cpri stat_speed width changes based on mas line rate
   assign IFP_cpri_ctrl_stat.stat_speed = {{(11-STAT_SPEED_BITS){1'b0}}, stat_speed};

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

  design_1 design_1_i (
        .BRAM_PORTA_addr    (IFP_dbgbuf_porta.addr),
        .BRAM_PORTA_clk     (dbgbuf_porta_clk),
        .BRAM_PORTA_din     (IFP_dbgbuf_porta.wr_data),
        .BRAM_PORTA_dout    (IFP_dbgbuf_porta.rd_data),
        .BRAM_PORTA_en      (IFP_dbgbuf_porta.en),
        .BRAM_PORTA_rst     (dbgbuf_porta_rst),
        .BRAM_PORTA_we      (IFP_dbgbuf_porta.wr_en),
        .aresetn_368p64     (aresetn_368p64),
        .dfe_resetn_slow_clk(dfe_resetn_slow_clk),
        .BRAM_PORTA_iwaveform_addr      (IFP_iwavebuf_porta.addr),
        .BRAM_PORTA_iwaveform_clk       (IFP_iwavebuf_porta_clk),
        .BRAM_PORTA_iwaveform_din       (IFP_iwavebuf_porta.wr_data),
        .BRAM_PORTA_iwaveform_dout      (IFP_iwavebuf_porta.rd_data),
        .BRAM_PORTA_iwaveform_en        (IFP_iwavebuf_porta.en),
        .BRAM_PORTA_iwaveform_rst       (IFP_iwavebuf_porta_rst),
        .BRAM_PORTA_iwaveform_we        (IFP_iwavebuf_porta.wr_en),							  
        .M0_AXI_TOP_DL_CTRL_araddr      (m0_axi_top_dl_ctrl_araddr),
        .M0_AXI_TOP_DL_CTRL_arprot      (IFP_m0_axi_top_dl_ctrl.arprot),
        .M0_AXI_TOP_DL_CTRL_arready     (IFP_m0_axi_top_dl_ctrl.arready),
        .M0_AXI_TOP_DL_CTRL_arvalid     (IFP_m0_axi_top_dl_ctrl.arvalid),
        .M0_AXI_TOP_DL_CTRL_awaddr      (m0_axi_top_dl_ctrl_awaddr),
        .M0_AXI_TOP_DL_CTRL_awprot      (IFP_m0_axi_top_dl_ctrl.awprot),
        .M0_AXI_TOP_DL_CTRL_awready     (IFP_m0_axi_top_dl_ctrl.awready),
        .M0_AXI_TOP_DL_CTRL_awvalid     (IFP_m0_axi_top_dl_ctrl.awvalid),
        .M0_AXI_TOP_DL_CTRL_bready      (IFP_m0_axi_top_dl_ctrl.bready),
        .M0_AXI_TOP_DL_CTRL_bresp       (IFP_m0_axi_top_dl_ctrl.bresp),
        .M0_AXI_TOP_DL_CTRL_bvalid      (IFP_m0_axi_top_dl_ctrl.bvalid),
        .M0_AXI_TOP_DL_CTRL_rdata       (IFP_m0_axi_top_dl_ctrl.rdata),
        .M0_AXI_TOP_DL_CTRL_rready      (IFP_m0_axi_top_dl_ctrl.rready),
        .M0_AXI_TOP_DL_CTRL_rresp       (IFP_m0_axi_top_dl_ctrl.rresp),
        .M0_AXI_TOP_DL_CTRL_rvalid      (IFP_m0_axi_top_dl_ctrl.rvalid),
        .M0_AXI_TOP_DL_CTRL_wdata       (IFP_m0_axi_top_dl_ctrl.wdata),
        .M0_AXI_TOP_DL_CTRL_wready      (IFP_m0_axi_top_dl_ctrl.wready),
        .M0_AXI_TOP_DL_CTRL_wstrb       (IFP_m0_axi_top_dl_ctrl.wstrb),
        .M0_AXI_TOP_DL_CTRL_wvalid      (IFP_m0_axi_top_dl_ctrl.wvalid),
        .M1_AXI_TOP_UL_CTRL_araddr      (m1_axi_top_ul_ctrl_araddr),
        .M1_AXI_TOP_UL_CTRL_arprot      (IFP_m1_axi_top_ul_ctrl.arprot),
        .M1_AXI_TOP_UL_CTRL_arready     (IFP_m1_axi_top_ul_ctrl.arready),
        .M1_AXI_TOP_UL_CTRL_arvalid     (IFP_m1_axi_top_ul_ctrl.arvalid),
        .M1_AXI_TOP_UL_CTRL_awaddr      (m1_axi_top_ul_ctrl_awaddr),
        .M1_AXI_TOP_UL_CTRL_awprot      (IFP_m1_axi_top_ul_ctrl.awprot),
        .M1_AXI_TOP_UL_CTRL_awready     (IFP_m1_axi_top_ul_ctrl.awready),
        .M1_AXI_TOP_UL_CTRL_awvalid     (IFP_m1_axi_top_ul_ctrl.awvalid),
        .M1_AXI_TOP_UL_CTRL_bready      (IFP_m1_axi_top_ul_ctrl.bready),
        .M1_AXI_TOP_UL_CTRL_bresp       (IFP_m1_axi_top_ul_ctrl.bresp),
        .M1_AXI_TOP_UL_CTRL_bvalid      (IFP_m1_axi_top_ul_ctrl.bvalid),
        .M1_AXI_TOP_UL_CTRL_rdata       (IFP_m1_axi_top_ul_ctrl.rdata),
        .M1_AXI_TOP_UL_CTRL_rready      (IFP_m1_axi_top_ul_ctrl.rready),
        .M1_AXI_TOP_UL_CTRL_rresp       (IFP_m1_axi_top_ul_ctrl.rresp),
        .M1_AXI_TOP_UL_CTRL_rvalid      (IFP_m1_axi_top_ul_ctrl.rvalid),
        .M1_AXI_TOP_UL_CTRL_wdata       (IFP_m1_axi_top_ul_ctrl.wdata),
        .M1_AXI_TOP_UL_CTRL_wready      (IFP_m1_axi_top_ul_ctrl.wready),
        .M1_AXI_TOP_UL_CTRL_wstrb       (IFP_m1_axi_top_ul_ctrl.wstrb),
        .M1_AXI_TOP_UL_CTRL_wvalid      (IFP_m1_axi_top_ul_ctrl.wvalid),
        .M2_AXI_TOP_COM_CTRL_araddr     (m2_axi_top_com_ctrl_araddr),
        .M2_AXI_TOP_COM_CTRL_arprot     (IFP_m2_axi_top_com_ctrl.arprot),
        .M2_AXI_TOP_COM_CTRL_arready    (IFP_m2_axi_top_com_ctrl.arready),
        .M2_AXI_TOP_COM_CTRL_arvalid    (IFP_m2_axi_top_com_ctrl.arvalid),
        .M2_AXI_TOP_COM_CTRL_awaddr     (m2_axi_top_com_ctrl_awaddr),
        .M2_AXI_TOP_COM_CTRL_awprot     (IFP_m2_axi_top_com_ctrl.awprot),
        .M2_AXI_TOP_COM_CTRL_awready    (IFP_m2_axi_top_com_ctrl.awready),
        .M2_AXI_TOP_COM_CTRL_awvalid    (IFP_m2_axi_top_com_ctrl.awvalid),
        .M2_AXI_TOP_COM_CTRL_bready     (IFP_m2_axi_top_com_ctrl.bready),
        .M2_AXI_TOP_COM_CTRL_bresp      (IFP_m2_axi_top_com_ctrl.bresp),
        .M2_AXI_TOP_COM_CTRL_bvalid     (IFP_m2_axi_top_com_ctrl.bvalid),
        .M2_AXI_TOP_COM_CTRL_rdata      (IFP_m2_axi_top_com_ctrl.rdata),
        .M2_AXI_TOP_COM_CTRL_rready     (IFP_m2_axi_top_com_ctrl.rready),
        .M2_AXI_TOP_COM_CTRL_rresp      (IFP_m2_axi_top_com_ctrl.rresp),
        .M2_AXI_TOP_COM_CTRL_rvalid     (IFP_m2_axi_top_com_ctrl.rvalid),
        .M2_AXI_TOP_COM_CTRL_wdata      (IFP_m2_axi_top_com_ctrl.wdata),
        .M2_AXI_TOP_COM_CTRL_wready     (IFP_m2_axi_top_com_ctrl.wready),
        .M2_AXI_TOP_COM_CTRL_wstrb      (IFP_m2_axi_top_com_ctrl.wstrb),
        .M2_AXI_TOP_COM_CTRL_wvalid     (IFP_m2_axi_top_com_ctrl.wvalid),
        .M3_AXI_TOP_INTR_CTRL_araddr     (m3_axi_top_intr_ctrl_araddr),
        .M3_AXI_TOP_INTR_CTRL_arprot     (IFP_m3_axi_top_intr_ctrl.arprot),
        .M3_AXI_TOP_INTR_CTRL_arready    (IFP_m3_axi_top_intr_ctrl.arready),
        .M3_AXI_TOP_INTR_CTRL_arvalid    (IFP_m3_axi_top_intr_ctrl.arvalid),
        .M3_AXI_TOP_INTR_CTRL_awaddr     (m3_axi_top_intr_ctrl_awaddr),
        .M3_AXI_TOP_INTR_CTRL_awprot     (IFP_m3_axi_top_intr_ctrl.awprot),
        .M3_AXI_TOP_INTR_CTRL_awready    (IFP_m3_axi_top_intr_ctrl.awready),
        .M3_AXI_TOP_INTR_CTRL_awvalid    (IFP_m3_axi_top_intr_ctrl.awvalid),
        .M3_AXI_TOP_INTR_CTRL_bready     (IFP_m3_axi_top_intr_ctrl.bready),
        .M3_AXI_TOP_INTR_CTRL_bresp      (IFP_m3_axi_top_intr_ctrl.bresp),
        .M3_AXI_TOP_INTR_CTRL_bvalid     (IFP_m3_axi_top_intr_ctrl.bvalid),
        .M3_AXI_TOP_INTR_CTRL_rdata      (IFP_m3_axi_top_intr_ctrl.rdata),
        .M3_AXI_TOP_INTR_CTRL_rready     (IFP_m3_axi_top_intr_ctrl.rready),
        .M3_AXI_TOP_INTR_CTRL_rresp      (IFP_m3_axi_top_intr_ctrl.rresp),
        .M3_AXI_TOP_INTR_CTRL_rvalid     (IFP_m3_axi_top_intr_ctrl.rvalid),
        .M3_AXI_TOP_INTR_CTRL_wdata      (IFP_m3_axi_top_intr_ctrl.wdata),
        .M3_AXI_TOP_INTR_CTRL_wready     (IFP_m3_axi_top_intr_ctrl.wready),
        .M3_AXI_TOP_INTR_CTRL_wstrb      (IFP_m3_axi_top_intr_ctrl.wstrb),
        .M3_AXI_TOP_INTR_CTRL_wvalid     (IFP_m3_axi_top_intr_ctrl.wvalid),
        .M4_AXI_TOP_CTRL_FH_PROC_araddr (m4_axi_top_ctrl_fh_proc_araddr),
        .M4_AXI_TOP_CTRL_FH_PROC_arprot (IFP_m4_axi_top_ctrl_fh_proc.arprot),
        .M4_AXI_TOP_CTRL_FH_PROC_arready(IFP_m4_axi_top_ctrl_fh_proc.arready),
        .M4_AXI_TOP_CTRL_FH_PROC_arvalid(IFP_m4_axi_top_ctrl_fh_proc.arvalid),
        .M4_AXI_TOP_CTRL_FH_PROC_awaddr (m4_axi_top_ctrl_fh_proc_awaddr),
        .M4_AXI_TOP_CTRL_FH_PROC_awprot (IFP_m4_axi_top_ctrl_fh_proc.awprot),
        .M4_AXI_TOP_CTRL_FH_PROC_awready(IFP_m4_axi_top_ctrl_fh_proc.awready),
        .M4_AXI_TOP_CTRL_FH_PROC_awvalid(IFP_m4_axi_top_ctrl_fh_proc.awvalid),
        .M4_AXI_TOP_CTRL_FH_PROC_bready (IFP_m4_axi_top_ctrl_fh_proc.bready),
        .M4_AXI_TOP_CTRL_FH_PROC_bresp  (IFP_m4_axi_top_ctrl_fh_proc.bresp),
        .M4_AXI_TOP_CTRL_FH_PROC_bvalid (IFP_m4_axi_top_ctrl_fh_proc.bvalid),
        .M4_AXI_TOP_CTRL_FH_PROC_rdata  (IFP_m4_axi_top_ctrl_fh_proc.rdata),
        .M4_AXI_TOP_CTRL_FH_PROC_rready (IFP_m4_axi_top_ctrl_fh_proc.rready),
        .M4_AXI_TOP_CTRL_FH_PROC_rresp  (IFP_m4_axi_top_ctrl_fh_proc.rresp),
        .M4_AXI_TOP_CTRL_FH_PROC_rvalid (IFP_m4_axi_top_ctrl_fh_proc.rvalid),
        .M4_AXI_TOP_CTRL_FH_PROC_wdata  (IFP_m4_axi_top_ctrl_fh_proc.wdata),
        .M4_AXI_TOP_CTRL_FH_PROC_wready (IFP_m4_axi_top_ctrl_fh_proc.wready),
        .M4_AXI_TOP_CTRL_FH_PROC_wstrb  (IFP_m4_axi_top_ctrl_fh_proc.wstrb),
        .M4_AXI_TOP_CTRL_FH_PROC_wvalid (IFP_m4_axi_top_ctrl_fh_proc.wvalid),

        .M14_AXI_TOP_HW_CTRL_araddr     (m14_axi_top_hw_ctrl_araddr),
        .M14_AXI_TOP_HW_CTRL_arprot     (IFP_m14_axi_top_hw_ctrl.arprot),
        .M14_AXI_TOP_HW_CTRL_arready    (IFP_m14_axi_top_hw_ctrl.arready),
        .M14_AXI_TOP_HW_CTRL_arvalid    (IFP_m14_axi_top_hw_ctrl.arvalid),
        .M14_AXI_TOP_HW_CTRL_awaddr     (m14_axi_top_hw_ctrl_awaddr),
        .M14_AXI_TOP_HW_CTRL_awprot     (IFP_m14_axi_top_hw_ctrl.awprot),
        .M14_AXI_TOP_HW_CTRL_awready    (IFP_m14_axi_top_hw_ctrl.awready),
        .M14_AXI_TOP_HW_CTRL_awvalid    (IFP_m14_axi_top_hw_ctrl.awvalid),
        .M14_AXI_TOP_HW_CTRL_bready     (IFP_m14_axi_top_hw_ctrl.bready),
        .M14_AXI_TOP_HW_CTRL_bresp      (IFP_m14_axi_top_hw_ctrl.bresp),
        .M14_AXI_TOP_HW_CTRL_bvalid     (IFP_m14_axi_top_hw_ctrl.bvalid),
        .M14_AXI_TOP_HW_CTRL_rdata      (IFP_m14_axi_top_hw_ctrl.rdata),
        .M14_AXI_TOP_HW_CTRL_rready     (IFP_m14_axi_top_hw_ctrl.rready),
        .M14_AXI_TOP_HW_CTRL_rresp      (IFP_m14_axi_top_hw_ctrl.rresp),
        .M14_AXI_TOP_HW_CTRL_rvalid     (IFP_m14_axi_top_hw_ctrl.rvalid),
        .M14_AXI_TOP_HW_CTRL_wdata      (IFP_m14_axi_top_hw_ctrl.wdata),
        .M14_AXI_TOP_HW_CTRL_wready     (IFP_m14_axi_top_hw_ctrl.wready),
        .M14_AXI_TOP_HW_CTRL_wstrb      (IFP_m14_axi_top_hw_ctrl.wstrb),
        .M14_AXI_TOP_HW_CTRL_wvalid     (IFP_m14_axi_top_hw_ctrl.wvalid),

        .M15_AXI_TOP_TEST_CTRL_araddr     (m15_axi_top_test_ctrl_araddr),
        .M15_AXI_TOP_TEST_CTRL_arprot     (IFP_m15_axi_top_test_ctrl.arprot),
        .M15_AXI_TOP_TEST_CTRL_arready    (IFP_m15_axi_top_test_ctrl.arready),
        .M15_AXI_TOP_TEST_CTRL_arvalid    (IFP_m15_axi_top_test_ctrl.arvalid),
        .M15_AXI_TOP_TEST_CTRL_awaddr     (m15_axi_top_test_ctrl_awaddr),
        .M15_AXI_TOP_TEST_CTRL_awprot     (IFP_m15_axi_top_test_ctrl.awprot),
        .M15_AXI_TOP_TEST_CTRL_awready    (IFP_m15_axi_top_test_ctrl.awready),
        .M15_AXI_TOP_TEST_CTRL_awvalid    (IFP_m15_axi_top_test_ctrl.awvalid),
        .M15_AXI_TOP_TEST_CTRL_bready     (IFP_m15_axi_top_test_ctrl.bready),
        .M15_AXI_TOP_TEST_CTRL_bresp      (IFP_m15_axi_top_test_ctrl.bresp),
        .M15_AXI_TOP_TEST_CTRL_bvalid     (IFP_m15_axi_top_test_ctrl.bvalid),
        .M15_AXI_TOP_TEST_CTRL_rdata      (IFP_m15_axi_top_test_ctrl.rdata),
        .M15_AXI_TOP_TEST_CTRL_rready     (IFP_m15_axi_top_test_ctrl.rready),
        .M15_AXI_TOP_TEST_CTRL_rresp      (IFP_m15_axi_top_test_ctrl.rresp),
        .M15_AXI_TOP_TEST_CTRL_rvalid     (IFP_m15_axi_top_test_ctrl.rvalid),
        .M15_AXI_TOP_TEST_CTRL_wdata      (IFP_m15_axi_top_test_ctrl.wdata),
        .M15_AXI_TOP_TEST_CTRL_wready     (IFP_m15_axi_top_test_ctrl.wready),
        .M15_AXI_TOP_TEST_CTRL_wstrb      (IFP_m15_axi_top_test_ctrl.wstrb),
        .M15_AXI_TOP_TEST_CTRL_wvalid     (IFP_m15_axi_top_test_ctrl.wvalid),

        .adc0_01_over_range             (adc_over_range[0]),
        .adc0_01_over_threshold1        (irq_adc_threshold1[0]),
        .adc0_01_over_threshold2        (irq_adc_threshold2[0]),
        .adc0_01_over_voltage           (adc_over_voltage[0]),
        .adc0_23_over_range             (adc_over_range[1]),
        .adc0_23_over_threshold1        (irq_adc_threshold1[1]),
        .adc0_23_over_threshold2        (irq_adc_threshold2[1]),
        .adc0_23_over_voltage           (adc_over_voltage[1]),
        .adc0_clk_0_clk_n               (adc0_clk_0_clk_n),
        .adc0_clk_0_clk_p               (adc0_clk_0_clk_p),
        .adc1_01_over_range             (adc_over_range[2]),
        .adc1_01_over_threshold1        (irq_adc_threshold1[2]),
        .adc1_01_over_threshold2        (irq_adc_threshold2[2]),
        .adc1_01_over_voltage           (adc_over_voltage[2]),
        .adc1_23_over_range             (adc_over_range[3]),
        .adc1_23_over_threshold1        (irq_adc_threshold1[3]),
        .adc1_23_over_threshold2        (irq_adc_threshold2[3]),
        .adc1_23_over_voltage           (adc_over_voltage[3]),
        .adc1_clk_0_clk_n               (adc1_clk_0_clk_n),
        .adc1_clk_0_clk_p               (adc1_clk_0_clk_p),
        .adc2_01_over_range             (srx_over_range[0]),
        .adc2_01_over_voltage           (srx_over_voltage[0]),
        .adc2_23_over_range             (srx_over_range[1]),
        .adc2_23_over_voltage           (srx_over_voltage[1]),
        .adc2_clk_0_clk_n               (adc2_clk_0_clk_n),
        .adc2_clk_0_clk_p               (adc2_clk_0_clk_p),
        .axi_clk_100M                   (axi_clk_100M),
        .axi_resetn_100M                (axi_resetn_100M),
        .axi_i2c_scl_i                  (axi_i2c_scl_i),
        .axi_i2c_scl_o                  (axi_i2c_scl_o),
        .axi_i2c_scl_t                  (axi_i2c_scl_t),
        .axi_i2c_sda_i                  (axi_i2c_sda_i),
        .axi_i2c_sda_o                  (axi_i2c_sda_o),
        .axi_i2c_sda_t                  (axi_i2c_sda_t),
        .axi_i2c1_scl_i                 (axi_i2c1_scl_i),
        .axi_i2c1_scl_o                 (axi_i2c1_scl_o),
        .axi_i2c1_scl_t                 (axi_i2c1_scl_t),
        .axi_i2c1_sda_i                 (axi_i2c1_sda_i),
        .axi_i2c1_sda_o                 (axi_i2c1_sda_o),
        .axi_i2c1_sda_t                 (axi_i2c1_sda_t),
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
        .cpri_sfp_rxn                   (cpri_sfp_rxn),
        .cpri_sfp_rxp                   (cpri_sfp_rxp),
        .cpri_sfp_txn                   (cpri_sfp_txn),
        .cpri_sfp_txp                   (cpri_sfp_txp),
        .cpri_clk_out(cpri_core_clk),
        .cpri_clk_out_ok(IFP_cpri_suprt.clk_out_ok),
        .cpri_control_and_status_barrel_shift_value(IFP_cpri_ctrl_stat.barrel_shift_value),
        .cpri_control_and_status_coarse_timer_value(IFP_cpri_ctrl_stat.coarse_timer_value),
        .cpri_control_and_status_fifo_transit_time(IFP_cpri_ctrl_stat.fifo_transit_time),
        .cpri_control_and_status_hyperframe_number(IFP_cpri_ctrl_stat.hyperframe_number),
        .cpri_control_and_status_local_lof(IFP_cpri_ctrl_stat.local_lof),
        .cpri_control_and_status_local_los(IFP_cpri_ctrl_stat.local_los),
        .cpri_control_and_status_local_rai(IFP_cpri_ctrl_stat.local_rai),
        .cpri_control_and_status_remote_lof(IFP_cpri_ctrl_stat.remote_lof),
        .cpri_control_and_status_remote_los(IFP_cpri_ctrl_stat.remote_los),
        .cpri_control_and_status_remote_rai(IFP_cpri_ctrl_stat.remote_rai),
        .cpri_control_and_status_reset_acknowledge_in(IFP_cpri_ctrl_stat.reset_acknowledge_in),
        .cpri_control_and_status_reset_request_out(IFP_cpri_ctrl_stat.reset_request_out),
        .cpri_control_and_status_rx_gb_latency_value(IFP_cpri_ctrl_stat.rx_gb_latency_value),
        .cpri_control_and_status_sdi_request_in(IFP_cpri_ctrl_stat.sdi_request_in),
        .cpri_control_and_status_sdi_request_out(IFP_cpri_ctrl_stat.sdi_request_out),
        .cpri_control_and_status_stat_alarm(IFP_cpri_ctrl_stat.stat_alarm),
        .cpri_control_and_status_stat_code(IFP_cpri_ctrl_stat.stat_code),
        .cpri_control_and_status_stat_speed(stat_speed),
        .cpri_control_and_status_tx_gb_latency_value(IFP_cpri_ctrl_stat.tx_gb_latency_value),
        .cpri_eth_rx_avail(IFP_cpri_suprt.eth_rx_avail),
        .cpri_eth_rx_ready(IFP_cpri_suprt.eth_rx_ready),
        .cpri_iq_rx_bffw(IFP_cpri_iq.rx_bffw),
        .cpri_iq_rx_data(IFP_cpri_iq.rx_data),
        .cpri_iq_rx_strobe(IFP_cpri_iq.rx_strobe),
        .cpri_iq_rx_strobe_bfn(IFP_cpri_iq.rx_strobe_bfn),
        .cpri_iq_tx_data(IFP_cpri_iq.tx_data),
        .cpri_iq_tx_enable(IFP_cpri_iq.tx_enable),
        .cpri_iq_tx_strobe_bfn(IFP_cpri_iq.nodebfn_tx_nr),
        .cpri_iq_tx_strobe(IFP_cpri_iq.nodebfn_tx_strobe),
        .cpri_recclk_ok(IFP_cpri_suprt.recclk_ok),
        .cpri_recclk_out(cpri_core_recclk),
        .cpri_refclk_in_clk_n(cpri_refclk_in_clk_n),
        .cpri_refclk_in_clk_p(cpri_refclk_in_clk_p),
        .cpri_reset(cpri_core_reset),
        .cpri_axi_resetn(cpri_axi_resetn),
        .cpri_rx_fifo_almost_full(IFP_cpri_suprt.rx_fifo_almost_full),
        .cpri_rx_fifo_full(IFP_cpri_suprt.rx_fifo_full),
        .cpri_transceiver_monitor_rxchariscomma(IFP_cpri_gt.gt_mon_rxchariscomma),
        .cpri_transceiver_monitor_rxcharisk(IFP_cpri_gt.gt_mon_rxcharisk),
        .cpri_transceiver_monitor_rxdata(IFP_cpri_gt.gt_mon_rxdata),
        .cpri_transceiver_monitor_rxdatavalid(IFP_cpri_gt.gt_mon_rxdatavalid),
        .cpri_transceiver_monitor_rxdisperr(IFP_cpri_gt.gt_mon_rxdisperr),
        .cpri_transceiver_monitor_rxgearboxslip(IFP_cpri_gt.gt_mon_rxgearboxslip),
        .cpri_transceiver_monitor_rxheader(IFP_cpri_gt.gt_mon_rxheader),
        .cpri_transceiver_monitor_rxheadervalid(IFP_cpri_gt.gt_mon_rxheadervalid),
        .cpri_transceiver_monitor_rxnotintable(IFP_cpri_gt.gt_mon_rxnotintable),
        .cpri_transceiver_monitor_txcharisk(IFP_cpri_gt.gt_mon_txcharisk),
        .cpri_transceiver_monitor_txdata(IFP_cpri_gt.gt_mon_txdata),
        .cpri_transceiver_monitor_txheader(IFP_cpri_gt.gt_mon_txheader),
        .cpri_transceiver_monitor_txsequence(IFP_cpri_gt.gt_mon_txsequence),	
        .gt_rxlpmen(IFP_cpri_gt.gt_rxlpmen),
        .gt_txdiffctrl(IFP_cpri_gt.gt_txdiffctrl),
        .gt_cplllock(IFP_cpri_gt.gt_cplllock),
        .gt_eyescandataerror(IFP_cpri_gt.gt_eyescandataerror),
        .gt_qplllock(IFP_cpri_gt.gt_qplllock),
        .gt_rxcommadet(IFP_cpri_gt.gt_rxcommadet),
        .gt_rxdisperr(IFP_cpri_gt.gt_rxdisperr),
        .gt_rxdlysresetdone(IFP_cpri_gt.gt_rxdlysresetdone),
        .gt_rxheader(IFP_cpri_gt.gt_rxheader),
        .gt_rxheadervalid(IFP_cpri_gt.gt_rxheadervalid),
        .gt_rxnotintable(IFP_cpri_gt.gt_rxnotintable),
        .gt_rxphaligndone(IFP_cpri_gt.gt_rxphaligndone),
        .gt_rxpmaresetdone(IFP_cpri_gt.gt_rxpmaresetdone),
        .gt_rxpolarity(IFP_cpri_gt.gt_rxpolarity),
        .gt_rxprbserr(IFP_cpri_gt.gt_rxprbserr),
        .gt_rxresetdone(IFP_cpri_gt.gt_rxresetdone),
        .gt_rxsyncdone(IFP_cpri_gt.gt_rxsyncdone),
        .gt_txdlysresetdone(IFP_cpri_gt.gt_txdlysresetdone),
        .gt_txphaligndone(IFP_cpri_gt.gt_txphaligndone),
        .gt_txphinitdone(IFP_cpri_gt.gt_txphinitdone),
        .gt_txpolarity(IFP_cpri_gt.gt_txpolarity),
        .gt_txresetdone(IFP_cpri_gt.gt_txresetdone),
        .dac0_clk_0_clk_n               (dac0_clk_0_clk_n),
        .dac0_clk_0_clk_p               (dac0_clk_0_clk_p),
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
       // .emio_spi1_miso_i               (emio_spi1_miso_i),
       // .emio_spi1_mosi_o               (emio_spi1_mosi_o),
       // .emio_spi1_sclk_o               (emio_spi1_sclk_o),
       // .emio_spi1_ss_o_n               (emio_spi1_ss_o_n),
        .emio_uart1_rxd                 (emio_uart1_rxd),
        .emio_uart1_txd                 (emio_uart1_txd),
        .irq_adc_dac                    (irq_adc_dac),
        .m00_axis_0_tdata               (m00_axis_0_tdata),
        .m00_axis_0_tready              (m00_axis_0_tready),
        .m00_axis_0_tvalid              (m00_axis_0_tvalid),
        .m01_axis_0_tdata               (m01_axis_0_tdata),
        .m01_axis_0_tready              (m01_axis_0_tready),
        .m01_axis_0_tvalid              (m01_axis_0_tvalid),
        .m02_axis_0_tdata               (m02_axis_0_tdata),
        .m02_axis_0_tready              (m02_axis_0_tready),
        .m02_axis_0_tvalid              (m02_axis_0_tvalid),
        .m03_axis_0_tdata               (m03_axis_0_tdata),
        .m03_axis_0_tready              (m03_axis_0_tready),
        .m03_axis_0_tvalid              (m03_axis_0_tvalid),
        .m10_axis_0_tdata               (m10_axis_0_tdata),
        .m10_axis_0_tready              (m10_axis_0_tready),
        .m10_axis_0_tvalid              (m10_axis_0_tvalid),
        .m11_axis_0_tdata               (m11_axis_0_tdata),
        .m11_axis_0_tready              (m11_axis_0_tready),
        .m11_axis_0_tvalid              (m11_axis_0_tvalid),
        .m12_axis_0_tdata               (m12_axis_0_tdata),
        .m12_axis_0_tready              (m12_axis_0_tready),
        .m12_axis_0_tvalid              (m12_axis_0_tvalid),
        .m13_axis_0_tdata               (m13_axis_0_tdata),
        .m13_axis_0_tready              (m13_axis_0_tready),
        .m13_axis_0_tvalid              (m13_axis_0_tvalid),
        .m20_axis_0_tdata               (m20_axis_0_tdata),      // i[15:0]
        .m20_axis_0_tready              (m20_axis_0_tready),
        .m20_axis_0_tvalid              (m20_axis_0_tvalid),
        .m21_axis_0_tdata               (m21_axis_0_tdata),      // q[15:0]
        .m21_axis_0_tready              (m21_axis_0_tready),
        .m21_axis_0_tvalid              (m21_axis_0_tvalid),
        .m22_axis_0_tdata               (m22_axis_0_tdata),      // i[15:0]
        .m22_axis_0_tready              (m22_axis_0_tready),
        .m22_axis_0_tvalid              (m22_axis_0_tvalid),
        .m23_axis_0_tdata               (m23_axis_0_tdata),      // q[15:0]
        .m23_axis_0_tready              (m23_axis_0_tready),
        .m23_axis_0_tvalid              (m23_axis_0_tvalid),
        .pl_ps_irq0                     (pl_ps_irq0),
        .pl_ps_irq1                     (pl_ps_irq1),
        .pl_refclk_clk_n                (pl_refclk_clk_n),
        .pl_refclk_clk_p                (pl_refclk_clk_p),
        .pl_refclk1_clk_n               (pl_refclk1_clk_n),
        .pl_refclk1_clk_p               (pl_refclk1_clk_p),
        .pl_sysref_clk_n                (pl_sysref_clk_n),
        .pl_sysref_clk_p                (pl_sysref_clk_p),
        .ps_clk1_200K                   (ps_clk1_200K),
        .s00_axis_0_tdata               (s00_axis_0_tdata),
        .s00_axis_0_tready              (s00_axis_0_tready),
        .s00_axis_0_tvalid              (s00_axis_0_tvalid),
        .s01_axis_0_tdata               (s01_axis_0_tdata),
        .s01_axis_0_tready              (s01_axis_0_tready),
        .s01_axis_0_tvalid              (s01_axis_0_tvalid),
        .s02_axis_0_tdata               (s02_axis_0_tdata),
        .s02_axis_0_tready              (s02_axis_0_tready),
        .s02_axis_0_tvalid              (s02_axis_0_tvalid),
        .s03_axis_0_tdata               (s03_axis_0_tdata),
        .s03_axis_0_tready              (s03_axis_0_tready),
        .s03_axis_0_tvalid              (s03_axis_0_tvalid),
        .sysref_in_0_diff_n             (sysref_in_0_diff_n),
        .sysref_in_0_diff_p             (sysref_in_0_diff_p),
        .vin0_01_0_v_n                  (vin0_01_0_v_n),
        .vin0_01_0_v_p                  (vin0_01_0_v_p),
        .vin0_23_0_v_n                  (vin0_23_0_v_n),
        .vin0_23_0_v_p                  (vin0_23_0_v_p),
        .vin1_01_0_v_n                  (vin1_01_0_v_n),
        .vin1_01_0_v_p                  (vin1_01_0_v_p),
        .vin1_23_0_v_n                  (vin1_23_0_v_n),
        .vin1_23_0_v_p                  (vin1_23_0_v_p),
        .vin2_01_0_v_n                  (vin2_01_0_v_n),
        .vin2_01_0_v_p                  (vin2_01_0_v_p),
        .vin2_23_0_v_n                  (vin2_23_0_v_n),
        .vin2_23_0_v_p                  (vin2_23_0_v_p),
        .vout00_0_v_n                   (vout00_0_v_n),
        .vout00_0_v_p                   (vout00_0_v_p),
        .vout01_0_v_n                   (vout01_0_v_n),
        .vout01_0_v_p                   (vout01_0_v_p),
        .vout02_0_v_n                   (vout02_0_v_n),
        .vout02_0_v_p                   (vout02_0_v_p),
        .vout03_0_v_n                   (vout03_0_v_n),
        .vout03_0_v_p                   (vout03_0_v_p),
        .clk_testout_fpga_p             (clk_testout_fpga_p),
        .clk_testout_fpga_n             (clk_testout_fpga_n)
    );



    // ------------------------------------------------------------------ //
    // SRX Connections                                                    //
    // ------------------------------------------------------------------ //
    // Tile 226 ADC's provide data in complex IQ format. See BD port map.
    //      m20_axis = ADC0 I data, m21_axis = ADC0 Q data
    //      m22_axis = ADC1 I data, m23_asis = ADC1 Q data
    // IQ data is send to DPD in Single Phase format (Pg076, Table 3-4):
    //      Q = srx_din[31:16], I = srx_din[15:0]

    //assign m20_axis_0_tready        = IFP_srx[0].tready;
    //assign m21_axis_0_tready        = IFP_srx[0].tready;
    
    assign m20_axis_0_tready        = 1'b1;
    assign m21_axis_0_tready        = 1'b1;


    assign IFP_srx[0].tdata         = {m21_axis_0_tdata,   m20_axis_0_tdata};    // {q,i}
    assign IFP_srx[0].tvalid        =  m21_axis_0_tvalid & m20_axis_0_tvalid;

    //assign m22_axis_0_tready        = IFP_srx[1].tready;
    //assign m23_axis_0_tready        = IFP_srx[1].tready;
    
    assign m22_axis_0_tready        = 1'b1;
    assign m23_axis_0_tready        = 1'b1;

    assign IFP_srx[1].tdata         = {m23_axis_0_tdata,   m22_axis_0_tdata};    // {q,i}
    assign IFP_srx[1].tvalid        =  m23_axis_0_tvalid & m22_axis_0_tvalid;

    // Copy sent to dbgmux
    assign IFP_srx_copy[0].tdata    = IFP_srx[0].tdata;
    assign IFP_srx_copy[0].tvalid   = IFP_srx[0].tvalid;

    assign IFP_srx_copy[1].tdata    = IFP_srx[1].tdata;
    assign IFP_srx_copy[1].tvalid   = IFP_srx[1].tvalid;


    // ------------------------------------------------------------------ //
    // ADC Connections                                                    //
    // ------------------------------------------------------------------ //

    //Ant0
    assign m00_axis_0_tready=1'b1;
    assign m01_axis_0_tready=1'b1;
    assign IFP_adc[0].tvalid       = m00_axis_0_tvalid;
    assign IFP_adc[0].tdata[15:0]  = m00_axis_0_tdata; //I
    assign IFP_adc[0].tdata[31:16] = m01_axis_0_tdata; //Q
    
    //ant1
    assign m02_axis_0_tready=1'b1;
    assign m03_axis_0_tready=1'b1;
    assign IFP_adc[1].tvalid       = m02_axis_0_tvalid;
    assign IFP_adc[1].tdata[15:0]  = m02_axis_0_tdata; //I 
    assign IFP_adc[1].tdata[31:16] = m03_axis_0_tdata; //Q
   
    //ant2
    assign m10_axis_0_tready=1'b1;
    assign m11_axis_0_tready=1'b1;
    assign IFP_adc[2].tvalid       = m10_axis_0_tvalid;
    assign IFP_adc[2].tdata[15:0]  = m10_axis_0_tdata; //I 
    assign IFP_adc[2].tdata[31:16] = m11_axis_0_tdata; //Q
   
    //ant3
    assign m12_axis_0_tready=1'b1;
    assign m13_axis_0_tready=1'b1;
    assign IFP_adc[3].tvalid       = m12_axis_0_tvalid;
    assign IFP_adc[3].tdata[15:0]  = m12_axis_0_tdata; //I 
    assign IFP_adc[3].tdata[31:16] = m13_axis_0_tdata; //Q

    // ------------------------------------------------------------------ //
    // DAC Connections                                                    //
    // ------------------------------------------------------------------ //
    // Faizan: 5/14/19: Switched inputs to DACs to match schematic
    // DAC lines were switched (0-3 --> 3-0) to ease layout.
    // Changes are reflected in the schematic.
    
    assign s00_axis_0_tdata = IFP_dac[3].tdata;
    assign s01_axis_0_tdata = IFP_dac[2].tdata;
    assign s02_axis_0_tdata = IFP_dac[1].tdata;
    assign s03_axis_0_tdata = IFP_dac[0].tdata;

    assign s00_axis_0_tvalid = IFP_dac[3].tvalid;
    assign s01_axis_0_tvalid = IFP_dac[2].tvalid;
    assign s02_axis_0_tvalid = IFP_dac[1].tvalid;
    assign s03_axis_0_tvalid = IFP_dac[0].tvalid;

    assign IFP_dac[3].tready  = s00_axis_0_tready;
    assign IFP_dac[2].tready  = s01_axis_0_tready;
    assign IFP_dac[1].tready  = s02_axis_0_tready;
    assign IFP_dac[0].tready  = s03_axis_0_tready;

/* Debug */
/*
    ila_dpd_dbg ila_dpd_dbg_u1 (
        .clk                (clk_368p64),

// DPD Input Data: IFP_dpd_s_axis_din
        .probe0             (IFP_dpd_s_axis_din.tdata),         // 128
        .probe1             (IFP_dpd_s_axis_din.tlast),         // 1
        .probe2             (IFP_dpd_s_axis_din.tready),        // 1
        .probe3             (IFP_dpd_s_axis_din.tuser),         // 32
        .probe4             (IFP_dpd_s_axis_din.tvalid),        // 1

// DPD Output Data: IFP_dpd_m_axis_dout
        .probe5             (IFP_dpd_m_axis_dout.tdata),        // 128
        .probe6             (IFP_dpd_m_axis_dout.tlast),        // 1
        .probe7             (IFP_dpd_m_axis_dout.tready),       // 1
        .probe8             (IFP_dpd_m_axis_dout.tuser),        // 32
        .probe9             (IFP_dpd_m_axis_dout.tvalid),       // 1

// DPD SID: IFP_dpd_s_axis_sid
        .probe10            (IFP_dpd_s_axis_sid.tdata),         // 16
        .probe11            (IFP_dpd_s_axis_sid.tready),        // 1
        .probe12            (IFP_dpd_s_axis_sid.tvalid),        // 1

// IFP_dpd_m_axis_srx_ctrl
        .probe13            (IFP_dpd_m_axis_srx_ctrl.tdata),    // 8
        .probe14            (IFP_dpd_m_axis_srx_ctrl.tready),   // 1
        .probe15            (IFP_dpd_m_axis_srx_ctrl.tvalid),   // 1

// IFP_dpd_s_axis_srx
        .probe16            (IFP_dpd_s_axis_srx.tdata),         // 32
        .probe17            (IFP_dpd_s_axis_srx.tready),        // 1
        .probe18            (IFP_dpd_s_axis_srx.tuser),         // 8
        .probe19            (IFP_dpd_s_axis_srx.tvalid),        // 1

// ORx ADC
        .probe20            (IFP_srx[0].tdata),                 // 32
        .probe21            (IFP_srx[0].tvalid),                 // 1
        .probe22            (IFP_srx[0].tready),                 // 1

        .probe23            (IFP_srx[1].tdata),                 // 32
        .probe24            (IFP_srx[1].tvalid),                 // 1
        .probe25            (IFP_srx[1].tready),                 // 1

// DAC
        .probe26            (IFP_dac[3].tdata),                 // 64
        .probe27            (IFP_dac[3].tready),                // 1
        .probe28            (IFP_dac[3].tvalid),                // 1

// ADC
        .probe29            (IFP_adc[0].tdata),                 // 32
        .probe30            (IFP_adc[0].tvalid)                 // 1
);
*/
   
endmodule
