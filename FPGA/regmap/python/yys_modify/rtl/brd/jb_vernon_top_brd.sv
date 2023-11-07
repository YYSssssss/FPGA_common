`timescale 1ns / 1ps

module jb_vernon_top_brd #(
    parameter N_CARRIERS    = 2,
    parameter N_ANTENNAS    = 8
) (
    input                               pl_refclk1_locked,
    input                               pl_refclk2_locked,
    input                               clk_122p88,
	input                               clk_491p52,
	input                               dfe_resetn_clk491p52,
    input                               axis_aresetn,
    input                               axi_clk,
    input                               axi_aresetn,
	
    jb_hw_ctrl_if.hw_ctrl               IFP_hw_regs,
    jb_hw_ctrl_if.hw_stat               IFP_hw_stat,	
    jb_test_ctrl_if.test_dbg            IFP_test_regs,
    jb_intr_ctrl_if.irq_rfc             IFP_irq,
    jb_dpd_srx_if.srx_ctrl              IFP_dpd,
    jb_axi4_stream_if.slave             IFP_srx [N_ANTENNAS-1:0],
    output  logic   [2:0]               srx_wrssi_ant,
    input   [N_ANTENNAS-1:0] [31:0]     pa_odp_tssi,
    input                               pa_shutdown,
    output  logic   [3:0]               emio_spi0_bank_sel,
    output  logic                       cold_rst_req_n,
    input           [7:0]               adc_over_range,
    input           [7:0]               adc_over_voltage,	
    output  logic                       orx_dsa_enb    ,     
    output  logic                       tx_dsa_enb     ,
	
    output  logic   [6:0]               rx_dsa_data    ,
    output  logic   [8:1]               rx_dsa_le      ,
    output  logic   [8:1]               rx_bypass      ,
	
    output  logic                       ant_cal_sw_tx  ,
    output  logic                       ant_cal_sw_rx  ,
    output  logic   [8:1]               pa_pwr_en,	
	
    output  logic                       tx_gainblock_en,
    output  logic                       rx_gainblock_en,	
    output  logic   [8:1]               sw_rxfb_dv_en,   
    output  logic   [2:1]               sw_pa_rxfb_vctl, 
    output  logic   [2:1]               sw_pa_dv_vctl,   
    output  logic   [2:1]               pa_lna_en,
	output  logic   [2:1]               sw_pa_lna_vctl,
    output  logic                       sw_rxfb_vctl,    
    output  logic                       sw_rxfb_vctl_n, 	

    output  logic   [4:1]               prdrven,
    output  logic   [8:1]               pa_ctrl_in,
	
    output  logic   [1:0]               resent_pa,      	
	input           [8:1]               pa_psu_pgood,
    input                               aisg_pgood,   
	
    input           [1:0]               sfp_los,
    input           [1:0]               sfp_tx_fault,
    input           [1:0]               sfp_detect_n,
    output  logic   [1:0]               sfp_rs,
    output  logic   [1:0]               sfp_led,
	output  logic   [1:0]               sfp_tx_en_n,
    output  logic   [1:0]               fpga_test,
	output  logic                       aisg_vdd_enn,
	output  logic                       aisg_uart_de_ren,
	output  logic                       aisg_vdd_sw_enn
);
    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    genvar i;
    logic                       vio_en_pl_leds;
    logic                       v_debug_led_0;
    logic                       v_debug_led_1;
	logic           [6:0]       rx_dsa_data_temp;
	logic           [8:1]       rx_dsa_le_temp; 
	logic           [7:0]       temp_pa_ctrl_in;

    // ------------------------------------------------------------------ //
    // Amp Controls                                                       //
    // ------------------------------------------------------------------ //

    
    // ------------------------------------------------------------------ //
    // Cold Reset                                                         //
    // ------------------------------------------------------------------ //
    assign cold_rst_req_n            =   IFP_hw_regs.cold_rst_n_mask ? 1'b1 : IFP_hw_regs.cold_rst_n;
    // ------------------------------------------------------------------ //
    // SPI Banks                                                          //
    // ------------------------------------------------------------------ //
    assign emio_spi0_bank_sel        = IFP_hw_regs.spi_bank_sel;
    assign orx_dsa_enb               = (emio_spi0_bank_sel == 'd3 | emio_spi0_bank_sel == 'd4) ? 1'b0 : 1'b1;
    assign tx_dsa_enb                = (emio_spi0_bank_sel == 'd1 | emio_spi0_bank_sel == 'd2) ? 1'b0 : 1'b1;
							         
    assign ant_cal_sw_tx             = IFP_hw_regs.tx_ant_cal_en;
	assign ant_cal_sw_rx             = IFP_hw_regs.rx_ant_cal_en;
							         
	assign resent_pa[0]              = IFP_hw_regs.pa_resetn[0];
	assign resent_pa[1]              = IFP_hw_regs.pa_resetn[1];	
							                 
	assign aisg_vdd_enn              = IFP_hw_regs.aisg_vdd_enn;
    assign aisg_vdd_sw_enn           = IFP_hw_regs.aisg_vdd_sw_enn;
	assign aisg_uart_de_ren          = IFP_hw_regs.uart1_de_ren;
								     
	assign pa_pwr_en[1]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[0];
	assign pa_pwr_en[2]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[1];
	assign pa_pwr_en[3]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[2];
	assign pa_pwr_en[4]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[3];
	assign pa_pwr_en[5]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[4];
	assign pa_pwr_en[6]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[5];
	assign pa_pwr_en[7]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[6];
	assign pa_pwr_en[8]              = pa_shutdown ? 1'b0 : IFP_hw_regs.en_pa_pwr[7];

    assign IFP_hw_stat.pa_v_pgood[0] = pa_psu_pgood[1];
    assign IFP_hw_stat.pa_v_pgood[1] = pa_psu_pgood[2];
    assign IFP_hw_stat.pa_v_pgood[2] = pa_psu_pgood[3];
    assign IFP_hw_stat.pa_v_pgood[3] = pa_psu_pgood[4];
    assign IFP_hw_stat.pa_v_pgood[4] = pa_psu_pgood[5];
    assign IFP_hw_stat.pa_v_pgood[5] = pa_psu_pgood[6];
    assign IFP_hw_stat.pa_v_pgood[6] = pa_psu_pgood[7];
    assign IFP_hw_stat.pa_v_pgood[7] = pa_psu_pgood[8];
	assign IFP_hw_stat.aisg_pgood    = aisg_pgood;
	
	assign pa_ctrl_in                = pa_shutdown ? 8'h00 : temp_pa_ctrl_in;
	
	
    jb_srx_ctrl jb_srx_ctrl_u0 (
        .axis_aclk              (clk_491p52),               // i
        .axis_aresetn           (dfe_resetn_clk491p52),     // i
        .IFP_hw_regs            (IFP_hw_regs),              // jb_hw_ctrl_if.rf_ctrl
		.IFP_test_regs          (IFP_test_regs),
        .IFP_dpd                (IFP_dpd),                  // jb_dpd_srx_if.ctrl [N_BANDS-1:0]
        .IFP_srx                (IFP_srx),                  // jb_axi4_stream_if.slave [N_BANDS-1:0] [N_ANTENNAS-1:0]
        .srx_wrssi_ant          (srx_wrssi_ant),            // o[2:0]
		
		.tx_gainblock_en        (tx_gainblock_en),
		.rx_gainblock_en        (rx_gainblock_en),               
		.pa_lna_en              (pa_lna_en      ),
		.sw_rxfb_dv_en          (sw_rxfb_dv_en  ),
		.sw_pa_rxfb_vctl        (sw_pa_rxfb_vctl),
		.sw_pa_dv_vctl          (sw_pa_dv_vctl  ),
		.sw_rxfb_vctl           (sw_rxfb_vctl   ),
		.sw_rxfb_vctl_n         (sw_rxfb_vctl_n ),
		.sw_pa_lna_vctl         (sw_pa_lna_vctl ),
		.prdrven                (prdrven        ),   
		.pa_ctrl_in             (temp_pa_ctrl_in)
		);

		
    jb_agc_adcp_top jb_agc_adcp_top_u0 (
        .axi_clk                (axi_clk),                       // i
        .axi_resetn             (axi_aresetn),                   // i
        .adc_over_range         (adc_over_range),                // i [7:0]
        .adc_over_voltage       (adc_over_voltage),              // i [7:0]
        .adcp_disable           (IFP_hw_regs.pl_adcp_disable[7:0]), // i [7:0]
        .ps_rxdsa               (IFP_hw_regs.ps_rxdsa[7:0]),        // i packed [7:0][6:0]
        .pl_rxdsa               (IFP_hw_stat.pl_rxdsa[7:0]),        // o packed [7:0][6:0]
        .rx_dsa_d               (rx_dsa_data),                   // o [6:0]
        .rx_dsa_le              (rx_dsa_le),                     // o [8:1]
        .ps_bypass_lna          (IFP_hw_regs.bypass_lna[7:0]),      // i [7:0]
        .rx_lna_bypass          (rx_bypass[8:1])                 // o [7:0]
    );

    jb_pa_protection #(
        .N_ANTENNAS             (N_ANTENNAS)
    ) jb_pa_protection_u0 (
        .clk_3x                 (clk_491p52),                       // i
        .resetn_3x              (dfe_resetn_clk491p52),                    // i
        .IFP_hw_regs            (IFP_hw_regs),                     // jb_hw_ctrl_if.rf_ctrl
        .IFP_irq                (IFP_irq),                      // jb_intr_ctrl_if.irq_rfc
        .tssi                   (pa_odp_tssi),                  // i [N_ANTENNAS-1:0] [31:0]
        .rf_overdrive_tssi      (IFP_hw_stat.rf_overdrive_tssi)    // o [N_ANTENNAS-1:0] [31:0]
    );
	
    // ------------------------------------------------------------------ //
    // Board VIO                                                          //
    // ------------------------------------------------------------------ //   
    //vio_brd vio_brd_u0 (
    //    .clk                (clk_122p88),                   // i
    //    .probe_in0          (pl_refclk1_locked),            // i
    //    .probe_in1          (pl_refclk2_locked),            // i
    //    .probe_in2          (sfp_los),                      // i [1:0]
    //    .probe_in3          (sfp_tx_fault),                 // i [1:0]
    //    .probe_in4          (sfp_detect_n),                 // i [1:0]
    //    .probe_out0         (vio_en_pl_leds),               // o
    //    .probe_out1         (v_debug_led_0),                // o
    //    .probe_out2         (v_debug_led_1)                 // o
    //);

    // ------------------------------------------------------------------ //
    // Debug                                                              //
    // ------------------------------------------------------------------ //
    assign fpga_test   = vio_en_pl_leds ? {v_debug_led_1, v_debug_led_0} : IFP_hw_regs.sfp_led[1:0];
    assign sfp_led     = IFP_hw_regs.sfp_led[1:0];
    assign sfp_rs      = IFP_hw_regs.sfp_rs[1:0];
	assign sfp_tx_en_n = IFP_hw_regs.sfp_tx_en_n[1:0];
    
    
endmodule
