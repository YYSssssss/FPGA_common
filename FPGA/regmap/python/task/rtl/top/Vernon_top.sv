// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : Fei Qin                                                     //
// Date         : 02/07/21                                                     //
// File         : top.v                                                   //
// Design       :                                                             //
// Purpose      : Vernon Board Controls                                           //
// Device       : xczu47dr-fsve1156-2-i                                       //
// -------------------------------------------------------------------------- //
`timescale 1 ps / 1 ps

module Vernon_top (
    output  logic                       cold_rst_req_n,
    input                               pl_refclk1_p,
    input                               pl_refclk1_n,
	
    input                               pl_refclk2_p,
    input                               pl_refclk2_n,

    input 	                            pl_sysref_p,
    input 	                            pl_sysref_n,

    input                               sfp_refclk_p,
    input                               sfp_refclk_n,
	
	input                               pl_ptpclk_p,
	input                               pl_ptpclk_n,

    input                               pl_1pps_p,
	input                               pl_1pps_n,
	
    input           	                sfp_rxp,
    input           	                sfp_rxn,
    output  logic   	                sfp_txp,
    output  logic   	                sfp_txn,
    output  logic   [1:0]               sfp_tx_en_n,

	input                               adc1_clk_clk_p,
	input                               adc1_clk_clk_n,
	input                               dac2_clk_clk_p,
	input                               dac2_clk_clk_n,
    input                               ana_sysref_p,	
    input                               ana_sysref_n,	
	
    input           [1:0]               sfp_los,
    input           [1:0]               sfp_tx_fault,
    input           [1:0]               sfp_detect_n,
    output  logic   [1:0]               sfp_rs,
    output  logic   [1:0]               sfp_led,

    input   	                        emio_spi0_m_i,
    output  logic                       emio_spi0_m_o,
    output 	logic                       emio_spi0_sclk_o,
    output  logic   [7:0]               emio_spi0_ss_o_n,
    output  logic   [3:0]               emio_spi0_bank_sel,

    output  logic                       orx_dsa_enb,
	output  logic                       tx_dsa_enb,
	output  logic   [6:0]               rx_dsa_data,
	output  logic   [8:1]               rx_dsa_le,
	output  logic   [8:1]               rx_bypass,
	output  logic                       ant_cal_sw_tx,
	output  logic                       ant_cal_sw_rx,
    output  logic   [8:1]               pa_pwr_en,
	
    output  logic                       tx_gainblock_en,
    output  logic                       rx_gainblock_en,  	

    input                               iic_sfp_scl_i [3:0],
    output  logic                       iic_sfp_scl_o [3:0],
    output  logic                       iic_sfp_scl_t [3:0],
    input                               iic_sfp_sda_i [3:0],
    output  logic                       iic_sfp_sda_o [3:0],
    output  logic                       iic_sfp_sda_t [3:0],

    output  logic   [8:1]               sw_rxfb_dv_en,   
    output  logic   [2:1]               sw_pa_rxfb_vctl, 
    output  logic   [2:1]               sw_pa_dv_vctl,   
    output  logic   [2:1]               pa_lna_en, 
    output  logic   [2:1]               sw_pa_lna_vctl,		
    output  logic                       sw_rxfb_vctl,    
    output  logic                       sw_rxfb_vctl_n,  

	input           [4:1]               irq_alarm,
	output          [4:1]               prdrven,
    output  logic                       trigger,
	input           [8:1]               pa_psu_pgood,
	input                               pgood_ext_48v,
	
    output  logic   [1:0]               resent_pa,      	
    output  logic   [8:1]               pa_ctrl_in,     	
    input                               uart1_rxd,      	
    output  logic                       uart1_txd,      	
    output  logic                       aisg_uart_de_ren,    	
    output  logic                       aisg_vdd_enn,   	
    output  logic                       aisg_vdd_sw_enn,	
    input                               aisg_pgood,     	
    input                               psu_alarm,      	
    output  logic   [1:0]               fpga_test      	
	
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
	
    localparam                  PRECISION               = 16;
    localparam                  N_CARRIERS              = 1;
    localparam                  N_ANTENNAS              = 8;
    localparam                  USER_ID_BW              = $clog2(N_ANTENNAS);
    localparam                  AXI_DATA_WIDTH          = 32;
    localparam                  AXI_ADDR_WIDTH          = 32;
    localparam                  AXI_ADDR_WIDTH_TOP_CTRL = AXI_ADDR_WIDTH;

    localparam                  RF_BRAM_ADDR_WIDTH      = 21;
    localparam                  RF_BRAM_DATA_WIDTH      = 64;
    localparam                  FH_BRAM_ADDR_WIDTH      = 17;
    localparam                  FH_BRAM_DATA_WIDTH      = 32;
    localparam                  NCO_COEF_WIDTH          = 40; 
    localparam                  UL_TIME_DELAY_BYPASS    = 1;
    localparam                  DL_TIME_DELAY_BYPASS    = 1;	
	localparam                  N_ETH_PORTS             = 1;
    // ------------------------------------------------------------------ //
    // Outputs: top_regmap_u0                                             //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Outputs: top_ctrl_u0                                               //
    // ------------------------------------------------------------------ //
    logic                                   rssi_load;
	logic                                   rssi_load_x3;

    // ----------------------------------------------------------------- //
    // Outputs: top_mmbd_wrap_u0                                         //
    // ----------------------------------------------------------------- //
    logic                                   pl_refclk1_locked;
    logic                                   pl_refclk2_locked;
    logic                                   axi_aresetn;
    logic                                   axi_clk;
    logic                                   clk_15p36;
    logic                                   clk_122p88;
    logic                                   clk_245p76;
    logic                                   clk_368p64;
    logic                                   clk_491p52;
	logic                                   clk_400M;
    logic                                   irq_adc_dac;
	logic           [31:0]                  s_fifo_dac_tdata;
	logic                                   s_fifo_dac_tvalid;
    logic           [31:0]                  s_tdata ;
    logic           [1:0]                   s_tuser ;
    logic                                   s_tvalid;
    logic           [N_ANTENNAS-1:0]        irq_adc_threshold1;
    logic           [N_ANTENNAS-1:0]        irq_adc_threshold2;
    logic           [N_ANTENNAS-1:0]        adc_over_range;
    logic           [N_ANTENNAS-1:0]        adc_over_voltage;
    logic           [94:0]                  GPIO_0_tri_i;
    logic           [94:0]                  GPIO_0_tri_o;
    logic           [94:0]                  GPIO_0_tri_t;
	logic                                   dbgbuf_porta_rst;
    logic                                   dbgbuf_porta_clk;
    logic                                   IFP_iwavebuf_porta_rst;
    logic                                   IFP_iwavebuf_porta_clk;

	logic                                   pa_odp_tssi_le;
	logic  [N_ANTENNAS-1:0] [31:0]          pa_odp_tssi;
    logic                                   psu_shutdown;
    logic                                   dac_shutdown;
    logic                                   pa_shutdown;
    logic                   [2:0]           srx_wrssi_ant;
    logic 			                        ptp_clk;
    logic                                   ptp_align_pulse;
    logic [N_CARRIERS-1:0] 	                dl_dfe_frm_mrkr_0;
    logic [N_CARRIERS-1:0] 	                dl_dfe_frm_mrkr_1;	
	logic                   [1:0]           debug_led;
	logic [N_CARRIERS-1:0]				    dl_frm_mrkr_10ms_0;
	logic [N_CARRIERS-1:0]				    dl_frm_mrkr_10ms_pin;
	logic [N_CARRIERS-1:0]					ul_frm_mrkr_10ms_0;
	logic [N_CARRIERS-1:0]                  prach_frm_mrkr_10ms_0;
	logic [N_CARRIERS-1:0] 					dl_frm_mrkr_10ms_1;
	logic [N_CARRIERS-1:0] 					ul_frm_mrkr_10ms_1;
	logic [N_CARRIERS-1:0]                  prach_frm_mrkr_10ms_1;  
    logic [N_ANTENNAS-1:0]  [24:0]          fh_ul_fram_data_req;
    logic                                   dl_10ms_sel;	
   // ------------------------------------------------------------------ //
    // Outputs: top_rf_ctrl_u0                                            //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Outputs: top_irq_u0                                                //
    // ------------------------------------------------------------------ //
    logic           [7:0]                   pl_ps_irq0;
    logic           [7:0]                   pl_ps_irq1;

    // ------------------------------------------------------------------ //
    // Outputs: top_dbg_u0                                                //
    // ------------------------------------------------------------------ //
    logic 	                                RF_BRAM_portb_rst; // dbgbuf
    logic 	                                RF_BRAM_portb_clk; // dbgbuf
    logic                                   FH_BRAM_porta_rst; // iwaveform
    logic                                   FH_BRAM_porta_clk; // iwaveform
	
	logic [1:0] [N_CARRIERS-1:0]            dl_car_resetn   ;
	logic [1:0] [N_CARRIERS-1:0]            dl_clk_x1en     ;
	logic [1:0] [N_CARRIERS-1:0]            dl_clk_x4en     ;
	logic [1:0] [N_CARRIERS-1:0]            dl_clk_x8en     ;
	logic [1:0] [N_CARRIERS-1:0]            dl_clk_x16en    ;
	logic [1:0] [N_CARRIERS-1:0]            dl_clk_x4_fft_en;
										    
										    
	logic [1:0] [N_CARRIERS-1:0]            ul_car_resetn   ;
	logic [1:0] [N_CARRIERS-1:0]            ul_clk_x1en     ;
	logic [1:0] [N_CARRIERS-1:0]            ul_clk_x4en     ;
	logic [1:0] [N_CARRIERS-1:0]            ul_clk_x8en     ;
	logic [1:0] [N_CARRIERS-1:0]            ul_clk_x16en    ;
	logic [1:0] [N_CARRIERS-1:0]            ul_clk_x4_fft_en;
	logic                                   ul_dfe_time_delay_resetn;
	

	
    logic			                        DL_state			   ;    
    logic                                   GP1_state              ;
    logic                                   GP2_state              ; 	
    logic                                   UL_state               ; 
    logic                                   Error_10ms             ;	
    logic			                        dl_frm_mrkr_10ms_tcs   ;   
    logic			                        ul_frm_mrkr_10ms_tcs   ;   
    logic			                        prach_frm_mrkr_10ms_tcs;   
    logic                                   syn_data_dl_ul_5ms     ;
	logic                                   syn_data_dl_ul_5ms_lphy;
	logic                                   syn_data_dl_ul_5ms_ddr ;

	logic  [8:1]                            TCS_SW_RXFB_DV_EN     ;	
	logic  [2:1]                            TCS_SW_PA_RXFB_VCTL	  ; 
	logic                                   TCS_SW_RXFB_VCTL	  ;
	logic  	                                TCS_SW_RXFB_VCTL_N	  ;
	logic  [2:1]                            TCS_SW_PA_LNA_VCTL	  ;
	logic  [2:1]                            TCS_PA_LNA_EN		  ;
	logic                                   TCS_PA_DV_VCTL        ;
	logic  [4:1]                            TCS_PrDrvEN_X		  ;
	logic		                            TCS_RX_Gainblock_EN	  ;
	logic		                            TCS_TX_Gainblock_EN	  ;
	logic  [8:1]	                        TCS_PA_CTRL_EN		  ;
	logic                                   DAC_RF_output         ;



	
    logic   [8:1]                           decode_sw_rxfb_dv_en    ;   
    logic   [2:1]                           decode_sw_pa_rxfb_vctl  ; 
    logic                                   decode_sw_rxfb_vctl     ; 
    logic                                   decode_sw_rxfb_vctl_n   ; 
	logic   [2:1]                           decode_sw_pa_lna_vctl   ;
    logic   [2:1]                           decode_pa_lna_en        ;
    logic   [2:1]                           decode_sw_pa_dv_vctl    ;   														  
    logic   [4:1]                           decode_prdrven          ;
    logic                                   decode_tx_gainblock_en  ;
    logic                                   decode_rx_gainblock_en  ;
    logic   [8:1]                           decode_pa_ctrl_in       ;	
    logic                                   pps_in_si5518           ;
	
    IBUFDS IBUFDS_ONE_PPS_T (
        .I  (pl_1pps_p),
        .IB (pl_1pps_n),
        .O  (pps_in_si5518)
    );
	
 	assign sw_rxfb_dv_en   = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_SW_RXFB_DV_EN    : decode_sw_rxfb_dv_en   ;
	assign sw_pa_rxfb_vctl = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_SW_PA_RXFB_VCTL  : decode_sw_pa_rxfb_vctl ;
	assign sw_rxfb_vctl    = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_SW_RXFB_VCTL     : decode_sw_rxfb_vctl    ;
    assign sw_rxfb_vctl_n  = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_SW_RXFB_VCTL_N   : decode_sw_rxfb_vctl_n  ;
    assign sw_pa_lna_vctl  = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_SW_PA_LNA_VCTL   : decode_sw_pa_lna_vctl  ;
	assign pa_lna_en       = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_PA_LNA_EN        : decode_pa_lna_en       ;
	assign sw_pa_dv_vctl   = (IFP_test_ctrl.debug_rw[0][3]) ? decode_sw_pa_dv_vctl : decode_sw_pa_dv_vctl   ;
	assign prdrven         = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_PrDrvEN_X        : decode_prdrven         ;
	assign tx_gainblock_en = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_TX_Gainblock_EN  : decode_tx_gainblock_en ;
	assign rx_gainblock_en = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_RX_Gainblock_EN  : decode_rx_gainblock_en ; 
	assign pa_ctrl_in      = (IFP_test_ctrl.debug_rw[0][3]) ? TCS_PA_CTRL_EN       : decode_pa_ctrl_in      ;
	
    // ------------------------------------------------------------------ //
    // Outputs: sfp_ibert_tests_u0                                        //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Interfaces:                                                        //
    // ------------------------------------------------------------------ //
	
    jb_axi4_lite_if     #(.ADDR_WIDTH(AXI_ADDR_WIDTH_TOP_CTRL), .DATA_WIDTH(AXI_DATA_WIDTH))  IFP_axi4_lite_com();
    jb_axi4_lite_if     #(.ADDR_WIDTH(AXI_ADDR_WIDTH_TOP_CTRL), .DATA_WIDTH(AXI_DATA_WIDTH))  IFP_axi4_lite_test();
    jb_axi4_lite_if     #(.ADDR_WIDTH(AXI_ADDR_WIDTH_TOP_CTRL), .DATA_WIDTH(AXI_DATA_WIDTH))  IFP_axi4_lite_hw();
    jb_axi4_lite_if     #(.ADDR_WIDTH(AXI_ADDR_WIDTH_TOP_CTRL), .DATA_WIDTH(AXI_DATA_WIDTH))  IFP_axi4_lite_intr();
    jb_axi4_lite_if     #(.ADDR_WIDTH(AXI_ADDR_WIDTH_TOP_CTRL), .DATA_WIDTH(AXI_DATA_WIDTH))  IFP_axi4_lite_dl_dfe();
    jb_axi4_lite_if     #(.ADDR_WIDTH(AXI_ADDR_WIDTH_TOP_CTRL), .DATA_WIDTH(AXI_DATA_WIDTH))  IFP_axi4_lite_oran_lphy();
    jb_axi4_lite_if     #(.ADDR_WIDTH(AXI_ADDR_WIDTH_TOP_CTRL), .DATA_WIDTH(AXI_DATA_WIDTH))  IFP_axi4_lite_ul_dfe();	
    jb_ram_sp_if        #(.DATA_WIDTH(RF_BRAM_DATA_WIDTH), .ADDR_WIDTH(RF_BRAM_ADDR_WIDTH))   IFP_dbgbuf_porta();
    jb_ram_sp_if        #(.DATA_WIDTH(FH_BRAM_DATA_WIDTH), .ADDR_WIDTH(FH_BRAM_ADDR_WIDTH))   IFP_iwavebuf_porta();

    jb_axi4_stream_if   #(.DATA_WIDTH(64),          .USER_SB_WIDTH(USER_ID_BW)) IFP_ul        [1:0] [3:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(64),          .USER_SB_WIDTH(USER_ID_BW)) IFP_dl        [1:0] [3:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION))                             IFP_srx_dbg   [1:0] [3:0]();	
    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION))                             IFP_srx       [N_ANTENNAS-1:0]();

    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fh_dl     [1:0] [N_CARRIERS-1:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fh_ul     [1:0] [N_CARRIERS-1:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_dfe_in [1:0] [N_CARRIERS-1:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(64),          .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_dfe_out[1:0] [3:0](); //dac interface
    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_ul_dfe_in [1:0] [3:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_ul_dfe_out[1:0] [N_CARRIERS-1:0]();
 
    jb_axi4_stream_if   #(.DATA_WIDTH(256),         .USER_SB_WIDTH(64))         IFP_dpd_s_axis_din_new();
    jb_axi4_stream_if   #(.DATA_WIDTH(256),         .USER_SB_WIDTH(64))         IFP_dpd_m_axis_dout_new();
    jb_axi4_stream_if   #(.DATA_WIDTH(256),         .USER_SB_WIDTH(1))          IFP_cfr_s_axis_din_new();
    jb_axi4_stream_if   #(.DATA_WIDTH(256),         .USER_SB_WIDTH(1))          IFP_cfr_m_axis_dout_new();
    jb_dpd_srx_if                                                               IFP_dpd_srx        ();	

    jb_axi4_stream_if   #(.DATA_WIDTH(128),         .USER_SB_WIDTH(32))         IFP_dpd_s_axis_din[1:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(128),         .USER_SB_WIDTH(32))         IFP_dpd_m_axis_dout[1:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(128),         .USER_SB_WIDTH(1))          IFP_cfr_s_axis_din[1:0]();
    jb_axi4_stream_if   #(.DATA_WIDTH(128),         .USER_SB_WIDTH(1))          IFP_cfr_m_axis_dout[1:0]();
	
    jb_fh_misc_if       #(.N_CARRIERS(N_CARRIERS), .N_ANTENNAS(N_ANTENNAS), .N_ETH_PORTS(1) ) IFP_fh_misc();  	
    jb_fh_misc_new_if   #(.N_CARRIERS(N_CARRIERS), .N_ANTENNAS(N_ANTENNAS), .N_ETH_PORTS(1) ) IFP_fh_misc_new[1:0](); 
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(32))                  IFP_unsol_ul_uplane ();
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(32))                  IFP_xran_unsup[N_ETH_PORTS-1:0] (); 
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(32))                  IFP_xran_bweight[N_ETH_PORTS-1:0] ();
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(32))                  IFP_dl_defm_uplane[1:0][3:0] (); 	
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(32))                  IFP_ul_fram_uplane[1:0][3:0] ();	
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(32))                  IFP_prach_uplane[1:0] (); 	
    
    jb_oran_lphy_ctrl_if            IFP_oran_lphy_ctrl();
	jb_oran_lphy_ctrl_devided_if    IFP_oran_lphy_ctrl_new[1:0]();
    jb_oran_lphy_stat_if            IFP_oran_lphy_stat();	
    jb_oran_lphy_stat_devided_if    IFP_oran_lphy_stat_new[1:0]();	
    jb_cmn_ctrl_if                  IFP_cmn_ctrl();	
    jb_test_ctrl_if                 IFP_test_ctrl();
    jb_hw_ctrl_if                   IFP_hw_ctrl();
    jb_intr_ctrl_if                 IFP_intr_ctrl();
    jb_dl_dfe_ctrl_if               IFP_dl_dfe_ctrl();
    jb_dl_dfe_stat_if               IFP_dl_dfe_stat();
	jb_dl_dfe_rfc_if                IFP_dl_dfe_rfc[1:0]();
	jb_dl_dfe_ctrl_devided_if       IFP_dl_dfe_ctrl_new[1:0]();
	jb_dl_dfe_stat_devided_if       IFP_dl_dfe_stat_new[1:0]();
	jb_cmn_ctrl_devided_if          IFP_cmn_ctrl_new[1:0]();
	jb_ul_dfe_ctrl_if               IFP_ul_dfe_ctrl();
    jb_ul_dfe_stat_if               IFP_ul_dfe_stat();	
	jb_ul_dfe_ctrl_devided_if       IFP_ul_dfe_ctrl_new[1:0]();
    jb_ul_dfe_stat_devided_if       IFP_ul_dfe_stat_new[1:0]();	
	
	
    jb_fh_cc_timing_if              IFP_fh_cc_timing [N_CARRIERS-1:0]();
    jb_cplane_bid_if                IFP_dl_defm_cplane_bid [N_ANTENNAS-1:0]();
    jb_cplane_bid_if                IFP_ul_fram_cplane_bid [N_ANTENNAS-1:0]();
    jb_prach_cplane_if              IFP_prach_cplane();
    jb_xran_header_ecpri_if         IFP_xran_header_ecpri[N_ETH_PORTS-1:0]();
    jb_xran_header_app_cmn_if       IFP_xran_header_app_cmn[N_ETH_PORTS-1:0]();
    jb_xran_header_app_section_if   IFP_xran_header_app_section[N_ETH_PORTS-1:0]();  
	
    assign IFP_dl_dfe_rfc[0].rf_overdrive_mute              = IFP_intr_ctrl.rf_overdrive_mute       [3:0];
    assign IFP_dl_dfe_rfc[0].rf_slew_rate_irq_mask          = IFP_intr_ctrl.rf_slew_rate_irq_mask   [3:0];
    assign IFP_dl_dfe_rfc[0].rf_slew_rate_irq_clr           = IFP_intr_ctrl.rf_slew_rate_irq_clr    [3:0];
    assign IFP_dl_dfe_rfc[0].rf_slew_fault_clr              = IFP_intr_ctrl.rf_slew_fault_clr       [3:0];
    assign IFP_dl_dfe_rfc[1].rf_overdrive_mute              = IFP_intr_ctrl.rf_overdrive_mute       [7:4];
    assign IFP_dl_dfe_rfc[1].rf_slew_rate_irq_mask          = IFP_intr_ctrl.rf_slew_rate_irq_mask   [7:4];
    assign IFP_dl_dfe_rfc[1].rf_slew_rate_irq_clr           = IFP_intr_ctrl.rf_slew_rate_irq_clr    [7:4];
    assign IFP_dl_dfe_rfc[1].rf_slew_fault_clr              = IFP_intr_ctrl.rf_slew_fault_clr       [7:4];
													        
    assign IFP_dl_dfe_rfc[0].rf_slew_limit                  = IFP_hw_ctrl.rf_slew_limit;
    assign IFP_dl_dfe_rfc[1].rf_slew_limit                  = IFP_hw_ctrl.rf_slew_limit;
    assign IFP_dl_dfe_rfc[0].rf_slew_duration_limit         = IFP_hw_ctrl.rf_slew_duration_limit;
    assign IFP_dl_dfe_rfc[1].rf_slew_duration_limit         = IFP_hw_ctrl.rf_slew_duration_limit;
    assign IFP_dl_dfe_rfc[0].disable_rf_srp                 = IFP_hw_ctrl.disable_rf_srp            [3:0];
    assign IFP_dl_dfe_rfc[1].disable_rf_srp                 = IFP_hw_ctrl.disable_rf_srp            [7:4];
													        
    assign IFP_intr_ctrl.rf_slew_rate_irq                   = {IFP_dl_dfe_rfc[1].rf_slew_rate_irq,     IFP_dl_dfe_rfc[0].rf_slew_rate_irq};
    assign IFP_intr_ctrl.rf_slew_fault_count                = {IFP_dl_dfe_rfc[1].rf_slew_fault_count,  IFP_dl_dfe_rfc[0].rf_slew_fault_count};

    assign IFP_dl_dfe_stat.dl_dfe_car_flush_state           = IFP_dl_dfe_stat_new[0].dl_dfe_car_flush_state; 
    assign IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign  = IFP_dl_dfe_stat_new[0].dl_ant_postcfr_gain_scaler_sign; 	
	assign IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler       = {IFP_dl_dfe_stat_new[1].dl_ant_postcfr_gain_scaler,IFP_dl_dfe_stat_new[0].dl_ant_postcfr_gain_scaler};
	assign IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction     = {IFP_dl_dfe_stat_new[1].dl_ant_postcfr_gain_fraction,IFP_dl_dfe_stat_new[0].dl_ant_postcfr_gain_fraction};
	assign IFP_dl_dfe_stat.ant_fh_tssi                      = {IFP_dl_dfe_stat_new[1].ant_fh_tssi,IFP_dl_dfe_stat_new[0].ant_fh_tssi};
	assign IFP_dl_dfe_stat.ps_sat_err_status                = {IFP_dl_dfe_stat_new[1].ps_sat_err_status,IFP_dl_dfe_stat_new[0].ps_sat_err_status};	
	assign IFP_dl_dfe_stat.car_inrtp_sat_err_status[1:0]    = {IFP_dl_dfe_stat_new[1].car_inrtp_sat_err_status[1:0],IFP_dl_dfe_stat_new[0].car_inrtp_sat_err_status[1:0]};
    assign IFP_dl_dfe_stat.fir_3x_ant0to3_sat_err_status    = IFP_dl_dfe_stat_new[0].fir_3x_ant0to3_sat_err_status;
    assign IFP_dl_dfe_stat.fir_3x_ant4to7_sat_err_status    = IFP_dl_dfe_stat_new[1].fir_3x_ant4to7_sat_err_status;	
    assign IFP_dl_dfe_stat.poly_even_ant0to3_sat_err_status = IFP_dl_dfe_stat_new[0].poly_even_ant0to3_sat_err_status;	
    assign IFP_dl_dfe_stat.poly_even_ant4to7_sat_err_status = IFP_dl_dfe_stat_new[1].poly_even_ant4to7_sat_err_status;
    assign IFP_dl_dfe_stat.poly_odd_ant0to3_sat_err_status  = IFP_dl_dfe_stat_new[0].poly_odd_ant0to3_sat_err_status;	
    assign IFP_dl_dfe_stat.poly_odd_ant4to7_sat_err_status  = IFP_dl_dfe_stat_new[1].poly_odd_ant4to7_sat_err_status;
	assign IFP_fh_misc_new[0].systimer_ns                   = IFP_fh_misc.systimer_ns;
	assign IFP_fh_misc_new[0].systimer_s                    = IFP_fh_misc.systimer_s;
	assign IFP_fh_misc_new[1].systimer_ns                   = IFP_fh_misc.systimer_ns;
	assign IFP_fh_misc_new[1].systimer_s                    = IFP_fh_misc.systimer_s;
	assign IFP_fh_misc.dl_radio_start_10ms                  = IFP_fh_misc_new[0].dl_radio_start_10ms[0];
	assign IFP_fh_misc.ul_radio_start_10ms                  = IFP_fh_misc_new[0].ul_radio_start_10ms[0];		
	
    jb_interface_map_top u_jb_interface_map_top(
		.syn_data_dl_ul_5ms      (syn_data_dl_ul_5ms_ddr ),
		.tuser_dl_frm_mrkr_10ms  (dl_frm_mrkr_10ms_tcs   ),
		.IFP_dl_dfe_ctrl         (IFP_dl_dfe_ctrl        ),
		.IFP_ul_dfe_ctrl         (IFP_ul_dfe_ctrl        ),
		.IFP_cmn_ctrl            (IFP_cmn_ctrl           ),
		.IFP_dl_dfe_ctrl_new     (IFP_dl_dfe_ctrl_new    ),
		.IFP_ul_dfe_ctrl_new     (IFP_ul_dfe_ctrl_new    ),
		.IFP_cmn_ctrl_new        (IFP_cmn_ctrl_new       ),
		.IFP_oran_lphy_ctrl_new  (IFP_oran_lphy_ctrl_new ),
		.IFP_dpd_s_axis_din_new  (IFP_dpd_s_axis_din_new ),
		.IFP_dpd_m_axis_dout_new (IFP_dpd_m_axis_dout_new),
		.IFP_cfr_s_axis_din_new  (IFP_cfr_s_axis_din_new ),
		.IFP_cfr_m_axis_dout_new (IFP_cfr_m_axis_dout_new),
		.IFP_dpd_s_axis_din      (IFP_dpd_s_axis_din     ),
		.IFP_dpd_m_axis_dout     (IFP_dpd_m_axis_dout    ),
		.IFP_cfr_s_axis_din      (IFP_cfr_s_axis_din     ),
		.IFP_cfr_m_axis_dout     (IFP_cfr_m_axis_dout    ),
        .IFP_oran_lphy_ctrl      (IFP_oran_lphy_ctrl     ) 		
	);
	
    // ------------------------------------------------------------------ //
    // Signals: Top-Level                                                 //
    // ------------------------------------------------------------------ //
    genvar i;

    logic   dfe_resetn_slow_clk;
    logic   dfe_resetn_clk15p36;
    logic   dfe_resetn_clk122p88;
    logic   dfe_resetn_clk368p64;
	logic   dfe_resetn_clk491p52;
	logic   duc0_resetn_clk491p52;
	logic   duc1_resetn_clk491p52;
	logic   lphy0_resetn_clk491p52;
	logic   lphy1_resetn_clk491p52  ;
	logic   fh_recov_clk;
	logic   reg_top_reset;
    jb_vernon_rst u_jb_vernon_rst (
        .dfe_resetn_slow_clk        (dfe_resetn_slow_clk),      // 15p36 now
        .soft_reset_axi_clk         (IFP_cmn_ctrl.soft_reset),  // Active high
        .axi_clk                    (axi_clk),                  // 
        .clk_122p88                 (clk_122p88),               //
        .clk_368p64                 (clk_368p64),               //
        .clk_491p52                 (clk_491p52),               //
        .clk_15p36                  (clk_15p36),                //
        .dfe_resetn_clk122p88       (dfe_resetn_clk122p88),     //
        .dfe_resetn_clk368p64       (dfe_resetn_clk368p64),     //
        .dfe_resetn_clk491p52       (dfe_resetn_clk491p52),     //
        .duc0_resetn_clk491p52      (duc0_resetn_clk491p52),     //
        .duc1_resetn_clk491p52      (duc1_resetn_clk491p52),     //
        .lphy0_resetn_clk491p52     (lphy0_resetn_clk491p52),     //
        .lphy1_resetn_clk491p52     (lphy1_resetn_clk491p52),     //		
        .dfe_resetn_clk15p36        (dfe_resetn_clk15p36)       //
    );
  
    jb_pl_control u_jb_pl_control (
        .axi_resetn                     (axi_aresetn),          // i
        .axi_clk                        (axi_clk),              // i
        .clk_15p36                      (clk_15p36),            // i
        .clk_368p64                     (clk_491p52),
        .resetn_15p36                   (dfe_resetn_clk15p36),  // i
        .psu_alarm_n                    (pgood_ext_48v & IFP_test_ctrl.debug_rw[2][0]),// i
        .psu_alarm_enable               (IFP_hw_ctrl.psu_alarm_enable), // i
        .psu_shutdown                   (psu_shutdown),             // o
        .dac_shutdown                   (dac_shutdown),             // o
        .pa_shutdown                    (pa_shutdown),              // o
        .IFP_regs                       (IFP_cmn_ctrl),             // jb_cmn_ctrl_if.timers
        .rf_overdrive_avg_per           (IFP_hw_ctrl.rf_overdrive_avg_per), // i [20:0]
        .timer_pulse_xssi               (rssi_load),                // o
        .timer_pulse_xssi_x3            (rssi_load_x3),             // o
        .timer_pulse_tssi_pap_x3        (pa_odp_tssi_le)            // o
    );
	
	jb_vernon_regmap_top #(
        .AXI_ADDR_WIDTH                 (13),
        .AXI_DATA_WIDTH                 (32)
    ) u_jb_vernon_regmap_top (
        .clk                            (axi_clk),
        .srst                           (reg_top_reset),
                                        
        .IFP_top_com_axi4_lite          (IFP_axi4_lite_com),
        .IFP_test_axi4_lite             (IFP_axi4_lite_test),
        .IFP_hw_axi4_lite               (IFP_axi4_lite_hw),
        .IFP_intr_axi4_lite             (IFP_axi4_lite_intr),
        .IFP_dl_dfe_axi4_lite           (IFP_axi4_lite_dl_dfe),
		.IFP_oran_lphy_axi4_lite        (IFP_axi4_lite_oran_lphy),
        .IFP_ul_dfe_axi4_lite           (IFP_axi4_lite_ul_dfe),
		
        .IFP_cmn_ctrl                   (IFP_cmn_ctrl),
        .IFP_test_ctrl                  (IFP_test_ctrl),
        .IFP_hw_ctrl                    (IFP_hw_ctrl),
        .IFP_intr_ctrl                  (IFP_intr_ctrl),
        .IFP_dl_dfe_ctrl                (IFP_dl_dfe_ctrl),
        .IFP_dl_dfe_stat                (IFP_dl_dfe_stat),
		.IFP_oran_lphy_ctrl             (IFP_oran_lphy_ctrl),
		.IFP_oran_lphy_stat             (IFP_oran_lphy_stat),
        .IFP_ul_dfe_ctrl                (IFP_ul_dfe_ctrl),
        .IFP_ul_dfe_stat                (IFP_ul_dfe_stat)		
    );

    // ------------------------------------------------------------------ //
    // Block Design Wrapper                                               //
    // ------------------------------------------------------------------ //
    jb_vernon_bd_wrapper #(
        .N_CARRIERS                     (N_CARRIERS),
        .N_ANTENNAS                     (N_ANTENNAS),
        .AXI_ADDR_WIDTH_TOP_CTRL        (AXI_ADDR_WIDTH_TOP_CTRL)
    ) u_jb_vernon_bd_wrapper (
        .pl_refclk1_p                   (pl_refclk1_p),                     // i
        .pl_refclk1_n                   (pl_refclk1_n),                     // i
        .pl_refclk2_p                   (pl_refclk2_p),                     // i
        .pl_refclk2_n                   (pl_refclk2_n),                     // i
        .pl_refclk1_locked              (pl_refclk1_locked),                // o
        .pl_refclk2_locked              (pl_refclk2_locked),                // o
        .axi_clk                        (axi_clk),                          // o
        .axi_aresetn                    (axi_aresetn),                      // o
        .clk_15p36                      (clk_15p36),                        // o
        .clk_122p88                     (clk_122p88),                       // o
        .clk_245p76                     (clk_245p76),                       // o
        .clk_368p64                     (clk_368p64),                       // o
        .clk_491p52                     (clk_491p52),                       // o
		.clk_400M                       (clk_400M),
		.ptp_clk                        (ptp_clk   ),
		.one_pps_in                     (pps_in_si5518),
		.dac_shutdown                   (dac_shutdown),
		.gt_ref_clk_clk_p               (sfp_refclk_p),
		.gt_ref_clk_clk_n               (sfp_refclk_n),
	    .fh_sfp_rx_gt_port_0_n          (sfp_rxn),
        .fh_sfp_rx_gt_port_0_p          (sfp_rxp),
        .fh_sfp_tx_gt_port_0_n          (sfp_txn),
        .fh_sfp_tx_gt_port_0_p          (sfp_txp),		
        .axis_aresetn                   (dfe_resetn_slow_clk),              // o
		.pl_ptpclk_p                    (pl_ptpclk_p),
		.pl_ptpclk_n                    (pl_ptpclk_n),
		.reg_top_reset                  (reg_top_reset),
        .adc1_clk_clk_p                 (adc1_clk_clk_p),
        .adc1_clk_clk_n                 (adc1_clk_clk_n),
        .dac2_clk_clk_p                 (dac2_clk_clk_p),
        .dac2_clk_clk_n                 (dac2_clk_clk_n),		
        .ana_sysref_p                   (ana_sysref_p),                     // i
        .ana_sysref_n                   (ana_sysref_n),                     // i
        .pl_sysref_p                    (pl_sysref_p),                      // i
        .pl_sysref_n                    (pl_sysref_n),                      // i
        .pl_ps_irq0                     (pl_ps_irq0),                       // i [7:0]
		.uart1_rxd                      (uart1_rxd),
		.uart1_txd                      (uart1_txd),
        .irq_adc_dac                    (irq_adc_dac),                      // o
        .o_fifo_dac_tdata               (s_fifo_dac_tdata ),
        .o_fifo_dac_tvalid              (s_fifo_dac_tvalid),
        .adc_over_threshold1            (irq_adc_threshold1),               // o [N_ANTENNAS-1:0]
        .adc_over_threshold2            (irq_adc_threshold2),               // o [N_ANTENNAS-1:0]
        .adc_over_range                 (adc_over_range),                   // o [N_ANTENNAS-1:0]
        .adc_over_voltage               (adc_over_voltage),                 // o [N_ANTENNAS-1:0]
        .emio_spi0_m_i                  (emio_spi0_m_i),                    // i
        .emio_spi0_m_o                  (emio_spi0_m_o),                    // o
        .emio_spi0_sclk_o               (emio_spi0_sclk_o),                 // o
        .emio_spi0_ss_o_n               (emio_spi0_ss_o_n),                 // o [7:0]
        .iic_sfp_scl_i                  (iic_sfp_scl_i),                    // i [3:0]
        .iic_sfp_scl_o                  (iic_sfp_scl_o),                    // o [3:0]
        .iic_sfp_scl_t                  (iic_sfp_scl_t),                    // o [3:0]
        .iic_sfp_sda_i                  (iic_sfp_sda_i),                    // i [3:0]
        .iic_sfp_sda_o                  (iic_sfp_sda_o),                    // o [3:0]
        .iic_sfp_sda_t                  (iic_sfp_sda_t),                    // o [3:0]
        .GPIO_0_tri_i                   (GPIO_0_tri_i),                     // i [94:0]
        .GPIO_0_tri_o                   (GPIO_0_tri_o),                     // o [94:0]
        .GPIO_0_tri_t                   (GPIO_0_tri_t),                     // o [94:0]
        //FH Signals.	
        .IFP_fh_cc_timing               (IFP_fh_cc_timing),
        .IFP_dl_defm_cplane_bid         (IFP_dl_defm_cplane_bid),
        .IFP_ul_fram_cplane_bid         (IFP_ul_fram_cplane_bid),
        .IFP_prach_cplane               (IFP_prach_cplane),
        .IFP_dl_defm_uplane             (IFP_dl_defm_uplane),
        .IFP_ul_fram_uplane             (IFP_ul_fram_uplane),
        .IFP_prach_uplane               (IFP_prach_uplane[0]),
        .IFP_unsol_ul_uplane            (IFP_unsol_ul_uplane),
        .IFP_xran_unsup                 (IFP_xran_unsup),
        .IFP_xran_bweight               (IFP_xran_bweight),
        .IFP_xran_header_ecpri          (IFP_xran_header_ecpri),
        .IFP_xran_header_app_cmn        (IFP_xran_header_app_cmn),
        .IFP_xran_header_app_section    (IFP_xran_header_app_section),
        .IFP_fh_misc                    (IFP_fh_misc),
        .fh_ul_fram_data_req            (fh_ul_fram_data_req),
	   
        .IFP_oran_lphy_ctrl             (IFP_oran_lphy_ctrl),
        .IFP_oran_lphy_stat             (IFP_oran_lphy_stat),		
        .dbgbuf_porta_rst               (dbgbuf_porta_rst),
        .dbgbuf_porta_clk               (dbgbuf_porta_clk),
        .IFP_dbgbuf_porta               (IFP_dbgbuf_porta),
        .IFP_iwavebuf_porta_rst         (IFP_iwavebuf_porta_rst),
        .IFP_iwavebuf_porta_clk         (IFP_iwavebuf_porta_clk),
        .IFP_iwavebuf_porta             (IFP_iwavebuf_porta),
        .IFP_dpd_s_axis_din             (IFP_dpd_s_axis_din_new),
        .IFP_dpd_m_axis_dout            (IFP_dpd_m_axis_dout_new),
        .IFP_cfr_s_axis_din             (IFP_cfr_s_axis_din_new),
        .IFP_cfr_m_axis_dout            (IFP_cfr_m_axis_dout_new),
        .IFP_dpd_srx                    (IFP_dpd_srx),
        .IFP_ul                         (IFP_ul),                           // ADCs - jb_axi4_stream_if.master [N_ANTENNAS-1:0]
        .IFP_dl                         (IFP_dl),                           // DACs - jb_axi4_stream_if.slave  [N_ANTENNAS-1:0]
        .IFP_cmn_axi                    (IFP_axi4_lite_com),                // jb_axi4_lite_if.master
		.IFP_dl_dfe_axi                 (IFP_axi4_lite_dl_dfe),             // jb_axi4_lite_if.master      
        .IFP_test_axi                   (IFP_axi4_lite_test),               // jb_axi4_lite_if.master
        .IFP_hw_axi                     (IFP_axi4_lite_hw),                 // jb_axi4_lite_if.master
        .IFP_intr_axi                   (IFP_axi4_lite_intr),               // jb_axi4_lite_if.master	
        .IFP_lphy_axi                   (IFP_axi4_lite_oran_lphy),
        .IFP_ul_dfe_axi                (IFP_axi4_lite_ul_dfe)		
    );

	jb_pre_dfe u_pre_dfe(
		.i_clk_122 (clk_122p88       ), 
		.i_clk_491 (clk_491p52       ),
		.i_tdata   (s_fifo_dac_tdata ),
		.i_tvalid  (s_fifo_dac_tvalid),
		.o_tdata   (s_tdata          ),
		.o_tuser   (s_tuser          ),
		.o_tvalid  (s_tvalid         )
	);
    // ------------------------------------------------------------------ //
    // Board Controls                                                     //
    // ------------------------------------------------------------------ //
    jb_vernon_top_brd #(
        .N_CARRIERS                     (N_CARRIERS),
        .N_ANTENNAS                     (N_ANTENNAS)
    ) u_jb_vernon_top_brd  (
        .pl_refclk1_locked              (pl_refclk1_locked),                // i
        .pl_refclk2_locked              (pl_refclk2_locked),                // i
        .clk_122p88                     (clk_122p88),                       // i
        .axis_aresetn                   (dfe_resetn_clk122p88),             // i
        .axi_clk                        (axi_clk),                          // i
        .axi_aresetn                    (axi_aresetn),                      // i
		.clk_491p52                     (clk_491p52),
		.dfe_resetn_clk491p52           (dfe_resetn_clk491p52),
        .IFP_hw_regs                    (IFP_hw_ctrl),                      // 
		.IFP_hw_stat                    (IFP_hw_ctrl),
		.IFP_test_regs                  (IFP_test_ctrl),
        .IFP_irq                        (IFP_intr_ctrl),                    //
        .IFP_dpd                        (IFP_dpd_srx),                      // jb_dpd_srx_if.srx_ctrl [N_BANDS-1:0]
        .IFP_srx                        (IFP_srx),                          // jb_axis_strea_if.slave [N_BANDS-1:0] [N_ANTENNAS-1:0]
        .srx_wrssi_ant                  (srx_wrssi_ant),                    // o  [2:0]
        .pa_odp_tssi                    (pa_odp_tssi), 
        .emio_spi0_bank_sel             (emio_spi0_bank_sel),               // o [3:0]
        .cold_rst_req_n                 (cold_rst_req_n),                   // o
        .adc_over_range                 (adc_over_range),                   // i [7:0]
        .adc_over_voltage               (adc_over_voltage),                 // i [7:0]		
        .orx_dsa_enb                    (orx_dsa_enb    ),                  // o
        .tx_dsa_enb                     (tx_dsa_enb     ),                  // o
        .rx_dsa_data                    (rx_dsa_data    ),                  // o[6:0]
		.rx_dsa_le                      (rx_dsa_le      ),                  // o[8:1]
        .rx_bypass                      (rx_bypass      ),                  // o[8:1]
        .pa_shutdown                    (pa_shutdown    ),
        .ant_cal_sw_tx                  (ant_cal_sw_tx  ),                  // o 
        .ant_cal_sw_rx                  (ant_cal_sw_rx  ),                  // o
		.pa_pwr_en                      (pa_pwr_en      ),		
  
		.sw_rxfb_dv_en                  (decode_sw_rxfb_dv_en  ),             // o [8:1]  
		.sw_pa_rxfb_vctl                (decode_sw_pa_rxfb_vctl),             // o [2:1]
		.sw_pa_dv_vctl                  (decode_sw_pa_dv_vctl  ),             // o [2:1]
		.sw_pa_lna_vctl                 (decode_sw_pa_lna_vctl ),
		.pa_lna_en                      (decode_pa_lna_en      ), 
		.sw_rxfb_vctl                   (decode_sw_rxfb_vctl   ),             // o
		.sw_rxfb_vctl_n                 (decode_sw_rxfb_vctl_n ),             // o 
        .prdrven                        (decode_prdrven        ),	
        .tx_gainblock_en                (decode_tx_gainblock_en),             // o
        .rx_gainblock_en                (decode_rx_gainblock_en),             // o		
		.pa_ctrl_in                     (decode_pa_ctrl_in     ),             // o [8:1]		

		
		.resent_pa                      (resent_pa           ),                														     
		.pa_psu_pgood                   (pa_psu_pgood        ),
        .aisg_pgood                     (aisg_pgood          ),
		
        .sfp_los                        (sfp_los),                          // i [1:0]
        .sfp_tx_fault                   (sfp_tx_fault),                     // i [1:0]
        .sfp_detect_n                   (sfp_detect_n),                     // i [1:0]
        .sfp_rs                         (sfp_rs),                           // o [1:0]
        //.sfp_led                        (sfp_led),                          // o [1:0]
		.sfp_led                        (),                          // o [1:0]
		.sfp_tx_en_n                    (sfp_tx_en_n),
        .fpga_test                      (fpga_test),                        // o [1:0]
		.aisg_vdd_enn                   (aisg_vdd_enn),
		.aisg_uart_de_ren               (aisg_uart_de_ren),
		.aisg_vdd_sw_enn                (aisg_vdd_sw_enn)
    );

    // ------------------------------------------------------------------ //
    // Interrupts: Interrupt Conditioning Only                            //
    // ------------------------------------------------------------------ //
    jb_vernon_top_irq #(
        .N_CARRIERS                     (N_CARRIERS),
        .N_ANTENNAS                     (N_ANTENNAS)
    ) u_jb_vernon_top_irq (
        .clk                            (axi_clk),                          // i
        .IFP_regs                       (IFP_intr_ctrl),                    // 
        .irq_alarm                      (irq_alarm),                        // i [4:1]
		.irq_psu_alarm                  (psu_alarm),
        .irq_adc_dac                    (irq_adc_dac),                      // i
        .irq_adc_threshold1             (irq_adc_threshold1),               // i [N_ANTENNAS-1:0]
        .irq_adc_threshold2             (irq_adc_threshold2),               // i [N_ANTENNAS-1:0]
        .adc_over_range                 (adc_over_range),                   // i [N_ANTENNAS-1:0]
        .adc_over_voltage               (adc_over_voltage),                 // i [N_ANTENNAS-1:0]
        .pl_ps_irq0                     (pl_ps_irq0),                       // o [7:0]
        .pl_ps_irq1                     (pl_ps_irq1),                       // o [7:0]
        .sfp_los                        (sfp_los        ),                  // i [1:0]
        .sfp_tx_fault                   (sfp_tx_fault   ),                  // i [1:0]
        .sfp_detect_n                   (sfp_detect_n   )                   // i [1:0]
    );

jb_lphy_top #(
    .N_CARRIERS(1),
    .N_ANTENNAS (4),
    .USR_ID_BW (2),
    .DL_DEFM_UPLANE_TUSER_BW(31),
    .PRECISION (16),
    .FH_DATA_WIDTH(64),  
    .GAIN_SCALER_BW(4)
)u_lphy_top_0 (
		.clk_4x                         (clk_491p52), // input wire CLK
		.clk_1x                         (clk_491p52),
        .clk_122p88                     (clk_122p88),		
		.ptp_clk                        (ptp_clk),
		.radio_if_clk                   (clk_400M),//zle 400M
		.radio_if_reset                 (!lphy0_resetn_clk491p52),
		.reset_4x                       (!lphy0_resetn_clk491p52), // input reset          
		.reset_1x                       (!lphy0_resetn_clk491p52),
		.prach_fir_resetn               (ul_car_resetn),                 // o
	    .IFP_test_ctrl                  (IFP_test_ctrl),
		.dl_clk_x4_en                   (2'b11),// input clk enable// Out to DFE
		.ul_clk_x4_en                   (2'b11),// input clk enable// Out to DFE
		.dl_clk_x1en                    (2'b11),
		.ul_clk_x1en                    (2'b11),
		.prach_dfe_clk_x4_en            (2'b11),// input clk enable// Out to DFE
		.dl_frm_mrkr_10ms               (dl_frm_mrkr_10ms_0),// one pulse every 10ms
		.dl_frm_mrkr_10ms_pin           (dl_frm_mrkr_10ms_pin),
		.syn_data_dl_ul_5ms_lphy        (syn_data_dl_ul_5ms_lphy),
		.ul_frm_mrkr_10ms               (ul_frm_mrkr_10ms_0),// one pulse every 10ms
		.prach_frm_mrkr_10ms            (prach_frm_mrkr_10ms_0),
		.dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr_0),
		.IFP_cmn_ctrl                   (IFP_cmn_ctrl_new[0]),// input bandwidth b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
		.IFP_fh_cc_timing               (IFP_fh_cc_timing),
		.IFP_fh_misc                    (IFP_fh_misc_new[0]),
		.IFP_oran_lphy_ctrl             (IFP_oran_lphy_ctrl_new[0]),  // input   
		.IFP_oran_ul_oran_lphy_stat     (IFP_oran_lphy_stat_new[0]),  //    
		.IFP_oran_dl_oran_lphy_stat     (IFP_oran_lphy_stat_new[0]),  //      
		.IFP_oran_prach_oran_stat       (IFP_oran_lphy_stat_new[0]),  //      
		.IFP_dl_lphy_in                 (IFP_dl_defm_uplane[0]), //from Radio IP
		.IFP_dl_lphy_out                (IFP_fh_dl[0]), //to DFE through dbg
		.ul_oran_data_req               (fh_ul_fram_data_req[3:0]), //from Radio IP
		.IFP_ul_lphy_in                 (IFP_fh_ul[0]), //from DFE through dbg
		.IFP_ul_lphy_out                (IFP_ul_fram_uplane[0]), //to Radio IP
		.IFP_prach_out                  (IFP_prach_uplane[0]),
		.IFP_prach_cplane               (IFP_prach_cplane) 
);

jb_lphy_top #(
    .N_CARRIERS(1),
    .N_ANTENNAS (4),
    .USR_ID_BW (2),
    .DL_DEFM_UPLANE_TUSER_BW(31),
    .PRECISION (16),
    .FH_DATA_WIDTH(64),  
    .GAIN_SCALER_BW(4)
)u_lphy_top_1 (
		.clk_4x                         (clk_491p52), // input wire CLK
		.clk_1x                         (clk_491p52),
        .clk_122p88                     (clk_122p88),		
		.ptp_clk                        (ptp_clk),
		.radio_if_clk                   (clk_400M),//zle 400M
		.radio_if_reset                 (!lphy1_resetn_clk491p52),
		.reset_4x                       (!lphy1_resetn_clk491p52), // input reset          
		.reset_1x                       (!lphy1_resetn_clk491p52),
		.prach_fir_resetn               (ul_car_resetn),                 // o
		.IFP_test_ctrl                  (IFP_test_ctrl),
		.dl_clk_x4_en                   (2'b11),// input clk enable// Out to DFE
		.ul_clk_x4_en                   (2'b11),// input clk enable// Out to DFE
		.dl_clk_x1en                    (2'b11),
		.ul_clk_x1en                    (2'b11),
		.prach_dfe_clk_x4_en            (2'b11),// input clk enable// Out to DFE
		.dl_frm_mrkr_10ms               (dl_frm_mrkr_10ms_1),// one pulse every 10ms
		.dl_frm_mrkr_10ms_pin           (),
		.syn_data_dl_ul_5ms_lphy        (),
		.ul_frm_mrkr_10ms               (ul_frm_mrkr_10ms_1),// one pulse every 10ms
		.prach_frm_mrkr_10ms            (prach_frm_mrkr_10ms_1),
		.dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr_1),
		.IFP_cmn_ctrl                   (IFP_cmn_ctrl_new[1]),// input bandwidth b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
		.IFP_fh_cc_timing               (IFP_fh_cc_timing),
		.IFP_fh_misc                    (IFP_fh_misc_new[1]),
		.IFP_oran_lphy_ctrl             (IFP_oran_lphy_ctrl_new[1]),  // input   
		.IFP_oran_ul_oran_lphy_stat     (IFP_oran_lphy_stat_new[1]),  //    
		.IFP_oran_dl_oran_lphy_stat     (IFP_oran_lphy_stat_new[1]),  //      
		.IFP_oran_prach_oran_stat       (IFP_oran_lphy_stat_new[1]),  //      
		.IFP_dl_lphy_in                 (IFP_dl_defm_uplane[1]), //from Radio IP
		.IFP_dl_lphy_out                (IFP_fh_dl[1]), //to DFE through dbg
		.ul_oran_data_req               (fh_ul_fram_data_req[3:0]), //from Radio IP
		.IFP_ul_lphy_in                 (IFP_fh_ul[1]), //from DFE through dbg
		.IFP_ul_lphy_out                (IFP_ul_fram_uplane[1]), //to Radio IP
		.IFP_prach_out                  (IFP_prach_uplane[1]),
		.IFP_prach_cplane               (IFP_prach_cplane) 
);

    jb_dfe_top  #(
       .DL_TIME_DELAY_BYPASS            (DL_TIME_DELAY_BYPASS),
       .UL_TIME_DELAY_BYPASS            (UL_TIME_DELAY_BYPASS),
       .N_CARRIERS                      (N_CARRIERS),
       .N_ANTENNAS                      (N_ANTENNAS/2),
       .PRECISION                       (PRECISION),
       .NCO_COEF_WIDTH                  (NCO_COEF_WIDTH)
    ) u_dfe_top_0 (
        .clk_4x                         (clk_491p52),
        .clk_3x                         (clk_491p52),
        .clk_1x                         (clk_491p52),
        .resetn_1x                      (duc0_resetn_clk491p52),
        .resetn_3x                      (duc0_resetn_clk491p52),
        .resetn_4x                      (duc0_resetn_clk491p52),
		.Error_10ms                     (Error_10ms),
        .dl_car_resetn                  (2'b11),//dl_car_resetn      [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x1en                    (2'b11),//dl_clk_x1en        [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x4en                    (2'b11),//dl_clk_x4en        [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x8en                    (2'b11),//dl_clk_x8en        [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x16en                   (2'b11),//dl_clk_x16en       [0]),   // i [N_CARRIERS-1:0]
        .ul_car_resetn                  (2'b11),//ul_car_resetn      [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x1en                    (2'b11),//ul_clk_x1en        [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x4en                    (2'b11),//ul_clk_x4en        [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x8en                    (2'b11),//ul_clk_x8en        [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x16en                   (2'b11),//ul_clk_x16en       [0]),   // i [N_CARRIERS-1:0]
        .ul_dfe_time_delay_resetn       (ul_dfe_time_delay_resetn  ),      
        .rssi_load                      (rssi_load                 ),
        .dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr_0         ),
        .axi_clk                        (axi_clk                   ),
        .axi_resetn                     (axi_aresetn               ),
        .IFP_dpd_s_axis_din             (IFP_dpd_s_axis_din[0]     ),
        .IFP_dpd_m_axis_dout            (IFP_dpd_m_axis_dout[0]    ),
        .IFP_cfr_s_axis_din             (IFP_cfr_s_axis_din[0]     ),
        .IFP_cfr_m_axis_dout            (IFP_cfr_m_axis_dout[0]    ),
        .IFP_cmn_ctrl                   (IFP_cmn_ctrl_new[0]       ),
        .IFP_dl_dfe_rfc                 (IFP_dl_dfe_rfc[0]         ),    // jb_dl_dfe_rfc_if.dl_dfe
        .IFP_dl_dfe_ctrl                (IFP_dl_dfe_ctrl_new[0]    ),
        .IFP_dl_dfe_stat                (IFP_dl_dfe_stat_new[0]    ),
        .IFP_dl_dfe_in                  (IFP_dl_dfe_in [0]         ),
        .IFP_dl_dfe_out                 (IFP_dl_dfe_out[0]         ),   //{q,i} concatenated
        .IFP_ul_dfe_ctrl                (IFP_ul_dfe_ctrl_new[0]    ),
        .IFP_ul_dfe_stat		        (IFP_ul_dfe_stat_new[0]    ),
        .IFP_ul_dfe_in  		        (IFP_ul_dfe_in [0]         ),
        .IFP_ul_dfe_out 		        (IFP_ul_dfe_out[0]         )
	
    );
	
    jb_dfe_top  #(
       .DL_TIME_DELAY_BYPASS            (DL_TIME_DELAY_BYPASS),
       .UL_TIME_DELAY_BYPASS            (UL_TIME_DELAY_BYPASS),
       .N_CARRIERS                      (N_CARRIERS),
       .N_ANTENNAS                      (N_ANTENNAS/2),
       .PRECISION                       (PRECISION),
       .NCO_COEF_WIDTH                  (NCO_COEF_WIDTH)
    ) u_dfe_top_1 (
        .clk_4x                         (clk_491p52),
        .clk_3x                         (clk_491p52),
        .clk_1x                         (clk_491p52),
        .resetn_1x                      (duc1_resetn_clk491p52),
        .resetn_3x                      (duc1_resetn_clk491p52),
        .resetn_4x                      (duc1_resetn_clk491p52),
		.Error_10ms                     (Error_10ms),
        .dl_car_resetn                  (2'b11),//dl_car_resetn      [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x1en                    (2'b11),//dl_clk_x1en        [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x4en                    (2'b11),//dl_clk_x4en        [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x8en                    (2'b11),//dl_clk_x8en        [0]),   // i [N_CARRIERS-1:0]
        .dl_clk_x16en                   (2'b11),//dl_clk_x16en       [0]),   // i [N_CARRIERS-1:0]
        .ul_car_resetn                  (2'b11),//ul_car_resetn      [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x1en                    (2'b11),//ul_clk_x1en        [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x4en                    (2'b11),//ul_clk_x4en        [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x8en                    (2'b11),//ul_clk_x8en        [0]),   // i [N_CARRIERS-1:0]
        .ul_clk_x16en                   (2'b11),//ul_clk_x16en       [0]),   // i [N_CARRIERS-1:0]
        .ul_dfe_time_delay_resetn       (ul_dfe_time_delay_resetn  ),      
        .rssi_load                      (rssi_load                 ),
        .dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr_1         ),
        .axi_clk                        (axi_clk                   ),
        .axi_resetn                     (axi_aresetn               ),
        .IFP_dpd_s_axis_din             (IFP_dpd_s_axis_din[1]     ),
        .IFP_dpd_m_axis_dout            (IFP_dpd_m_axis_dout[1]    ),
        .IFP_cfr_s_axis_din             (IFP_cfr_s_axis_din[1]     ),
        .IFP_cfr_m_axis_dout            (IFP_cfr_m_axis_dout[1]    ),
        .IFP_cmn_ctrl                   (IFP_cmn_ctrl_new[1]       ),
        .IFP_dl_dfe_rfc                 (IFP_dl_dfe_rfc[1]         ),    // jb_dl_dfe_rfc_if.dl_dfe
        .IFP_dl_dfe_ctrl                (IFP_dl_dfe_ctrl_new[1]    ),
        .IFP_dl_dfe_stat                (IFP_dl_dfe_stat_new[1]    ),
        .IFP_dl_dfe_in                  (IFP_dl_dfe_in [1]         ),
        .IFP_dl_dfe_out                 (IFP_dl_dfe_out[1]         ),   //{q,i} concatenated
        .IFP_ul_dfe_ctrl                (IFP_ul_dfe_ctrl_new[1]    ),
        .IFP_ul_dfe_stat		        (IFP_ul_dfe_stat_new[1]    ),
        .IFP_ul_dfe_in  		        (IFP_ul_dfe_in [1]         ),
        .IFP_ul_dfe_out 		        (IFP_ul_dfe_out[1]         )
	
    );
	
	
    //------------------------------------------------------------------ //
    //Debug Block                                                        //
    //------------------------------------------------------------------ //
    jb_vernon_top_dbg #(
        .N_ANTS_SEL                     (2), 
		.N_ANTENNAS                     (N_ANTENNAS/2),
        .N_CARRIERS                     (N_CARRIERS),
        .DBGBUF_DATA_WIDTH              (RF_BRAM_DATA_WIDTH),
        .DBGBUF_ADDR_WIDTH              (RF_BRAM_ADDR_WIDTH),
        .DFE_PRECISION                  (PRECISION)
    ) u_jb_vernon_top_dbg (
        .clk_1x                         (clk_491p52),                       // i
        .clk_3x                         (clk_491p52),                       // i
        .dl_clk_x1en                    (8'hff),
        .ul_clk_x1en                    (8'hff),
		.syn_data_dl_ul_5ms             (syn_data_dl_ul_5ms),
        .resetn_1x                      (dfe_resetn_clk491p52),             // i
        .resetn_3x                      (dfe_resetn_clk491p52),             // i
        .rssi_load                      (rssi_load_x3),                     // i		
        .pa_odp_tssi_le                 (pa_odp_tssi_le),                   // i
        .pa_odp_tssi                    (pa_odp_tssi),                      // o [2*N_ANTENNAS-1:0] [31:0]
        .ptp_clk                        (ptp_clk),                          // i
        .ptp_align_pulse                (ptp_align_pulse),                  // i
        .dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr_0),                  // i [N_CARRIERS-1:0]
		.s_tdata                        (s_tdata ),
		.s_tuser                        (s_tuser ),
		.s_tvalid                       (s_tvalid),
        .IFP_iwavebuf_porta_rst         (IFP_iwavebuf_porta_rst),           // i
        .IFP_iwavebuf_porta_clk         (IFP_iwavebuf_porta_clk),           // i
		.IFP_iwavebuf_porta             (IFP_iwavebuf_porta),               // jb_ram_sp_if.mem
        .dbgbuf_porta_rst               (dbgbuf_porta_rst),                 // i
        .dbgbuf_porta_clk               (dbgbuf_porta_clk),                 // i
        .IFP_dbgbuf_porta               (IFP_dbgbuf_porta),                 // jb_ram_sp_if.mem		
        .IFP_test_ctrl                  (IFP_test_ctrl),                    // 
        .IFP_test_stat                  (IFP_test_ctrl),                    // 
		.IFP_hw_ctrl                    (IFP_hw_ctrl),
        .IFP_srx                        (IFP_srx_dbg),                      // jb_axis_stream_if.slave   [1:0] [N_ANTENNAS-1:0]
        .IFP_adc                        (IFP_ul),                           // ADCs - jb_axi4_stream_if.slave   [N_ANTENNAS-1:0]
        .IFP_dac                        (IFP_dl),                           // DACs - jb_axi4_stream_if.master  [N_ANTENNAS-1:0]
        .IFP_fh_dl                      (IFP_fh_dl),
        .IFP_fh_ul                      (IFP_fh_ul),
        .IFP_dl_dfe_out                 (IFP_dl_dfe_out),
        .IFP_ul_dfe_in                  (IFP_ul_dfe_in),    
        .IFP_dl_dfe_in                  (IFP_dl_dfe_in),
        .IFP_ul_dfe_out                 (IFP_ul_dfe_out) 
    );
	
    jb_rfdc_map #(
        .N_ANTENNAS                     (8),
        .N_ADC                          (8),
        .N_DAC                          (8),
		.N_ANT_SEL                      (2)
    ) jb_dpd_fb_ctrl_u0 (
        .axis_clk                       (clk_491p52),               // i
        .axis_aresetn                   (dfe_resetn_clk491p52),     // i
        .IFP_ctrl                       (IFP_hw_ctrl),              // jb_cmn_ctrl_if.hw_ctrl_rfdc
        .IFP_adc                        (IFP_ul),                   // jb_axi4_stream_if.slave  [N_ADC-1:0]
        .IFP_srx                        (IFP_srx),                  // jb_axi4_stream_if.master [N_ANTENNAS-1:0]
        .IFP_srx_copy                   (IFP_srx_dbg)               // jb_axi4_stream_if.master [1:0][N_ANTENNAS/2-1:0]
    );
	
	
	jb_top_TCS u_jb_top_TCS(														               
		.ptp_clk				(ptp_clk				               ),
		.ptp_reset			    (1'b0					               ),	
	    .clk					(clk_491p52				               ),
	    .reset				    (~dfe_resetn_clk491p52	               ),
	    .dl_frm_mrkr_from_lphy  (dl_frm_mrkr_10ms_0[0]                 ),
		.s_tvalid               (s_tvalid                              ),
		.dl_10ms_sel            (dl_10ms_sel                           ),
		.dl_frm_mrkr_cntr_ns	(IFP_test_ctrl.debug_rw[3]             ),
		.ul_frm_mrkr_cntr_ns	(IFP_test_ctrl.debug_rw[4]             ),
		.prach_frm_mrkr_cntr_ns	(IFP_test_ctrl.debug_rw[5]             ),
	    .IFP_test_ctrl          (IFP_test_ctrl                         ),
		.ant_sel				(srx_wrssi_ant                         ),
	    .DL_state        	    (DL_state                              ),
	    .GP1_state        	    (GP1_state                             ),
	    .GP2_state        	    (GP2_state                             ),
	    .UL_state			    (UL_state		                       ),	
        .Error_10ms             (Error_10ms                            ),		
	    .dl_frm_mrkr_10ms		(dl_frm_mrkr_10ms_tcs                  ),
	    .ul_frm_mrkr_10ms		(ul_frm_mrkr_10ms_tcs                  ),
	    .prach_frm_mrkr_10ms	(prach_frm_mrkr_10ms_tcs               ),
		.syn_data_dl_ul_5ms_ddr (syn_data_dl_ul_5ms_ddr  			   ),
		.DAC_RF_output          (DAC_RF_output                         ), 
		.SW_RXFB_DV_EN	        (TCS_SW_RXFB_DV_EN 	                   ),	
		.SW_PA_RXFB_VCTL	    (TCS_SW_PA_RXFB_VCTL                   ),
		.SW_RXFB_VCTL	        (TCS_SW_RXFB_VCTL	                   ),
		.SW_RXFB_VCTL_N	        (TCS_SW_RXFB_VCTL_N		               ),
		.SW_PA_LNA_VCTL	        (TCS_SW_PA_LNA_VCTL		               ),
		.PA_LNA_EN		        (TCS_PA_LNA_EN		                   ),
		.PA_CTRL_EN		        (TCS_PA_CTRL_EN		                   ),
		.PrDrvEN_X		        (TCS_PrDrvEN_X			               ),
		.RX_Gainblock_EN	    (TCS_RX_Gainblock_EN                   ),
		.TX_Gainblock_EN	    (TCS_TX_Gainblock_EN                   )
	);
assign trigger            = (IFP_test_ctrl.debug_rw[1] == 'd0) ? dl_frm_mrkr_10ms_pin[0] : dl_frm_mrkr_10ms_tcs;
assign syn_data_dl_ul_5ms = (IFP_test_ctrl.debug_rw[1] == 'd0) ? syn_data_dl_ul_5ms_lphy : syn_data_dl_ul_5ms_ddr;
endmodule
