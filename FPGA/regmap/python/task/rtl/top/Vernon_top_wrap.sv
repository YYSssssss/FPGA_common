// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : Fei Qin                                                     //
// Date         : 02/07/21                                                     //
// File         : top_wrapper.v                                                   //
// Design       :                                                             //
// Purpose      : Vernon Board Controls                                           //
// Device       : xczu47dr-fsve1156-2-i                                       //
// -------------------------------------------------------------------------- //
`timescale 1 ps / 1 ps
module Vernon_top_wrap (
    // ------------------------------------------------------------------ //
    // Clocks and Resets                                                  //
    // ------------------------------------------------------------------ //
    output logic                        COLD_RST_REQ_N,             //

    input                               PL_CLK1_122M88_P,           // SI5518/OUT3,  RFSoC Bank 66, AL9/AM9
    input                               PL_CLK1_122M88_N,           //

    input                               PL_CLK2_122M88_P,           // SI5518/OUT0,  RFSoC Bank 65, AJ17/AK16
    input                               PL_CLK2_122M88_N,           //

    input                               PTP_SYS_500M_P,             // SI5518/OUT17, RFSoC Bank 65, AG17/AH17
    input                               PTP_SYS_500M_N,             // 

    input                               PL_1PPS_P,                  // SI5518/OUT11, RFSoC Bank 65, AJ16/AJ15
    input                               PL_1PPS_N,                  // 

    input                               PL_SYSREF_3M84_P,           // SI5518/OUT7,  RFSoC Bank 66, AP11/AP10
    input                               PL_SYSREF_3M84_N,           //  
    
    // ------------------------------------------------------------------ //
    // SFPs                                                               //
    // ------------------------------------------------------------------ //
    input                               MGTY_REF_CLK_P,             // SI5518/OUT17, RFSoC Bank 128, MGTREFCLK0 
    input                               MGTY_REF_CLK_N,             //

    output logic                        SFP0_TX_T,                  // B128/MGTY0/TX - Polarity (P/N) inverted on the board for routing
    output logic                        SFP0_TX_C,                  
    input                               SFP0_RX_T,                  // B128/MGTY0 RX - Polarity (P/N) inverted on the board for routing
    input                               SFP0_RX_C,     
	
    //output logic                        SFP1_TX_T,                  // B128/MGTY1/TX
    //output logic                        SFP1_TX_C,                  
    //input                               SFP1_RX_T,                  // B128/MGTY1/RX
    //input                               SFP1_RX_C,


    input                               ADCCLK_REF2_T,              // ADC Bank 225, 491.52 MHz
    input                               ADCCLK_REF2_C,              
    input                               DACCLK_REF2_T,              // DAC Bank 230, 491.52 MHz
    input                               DACCLK_REF2_C,              
    input                               SYSREF_ANA_T,               // DAC Bank 228, 3.84 MHz Analog Sysref
    input                               SYSREF_ANA_C,


    inout           [3:0]               I2C_SCL,                    //
    inout           [3:0]               I2C_SDA,                    //

    input           [1:0]               SFP_LOS,                    //
    input           [1:0]               SFP_TX_FAULT,               //
    input           [1:0]               SFP_DETECT_N,               //
    output  logic   [1:0]               SFP_TX_EN_N,                //
    output  logic   [1:0]               SFP_RS,                     //
    output  logic   [1:0]               SFP_LED,                    //


    // ------------------------------------------------------------------ //
    // PA POWER EN                                                        //
    // ------------------------------------------------------------------ //
	output  logic   [8:1]               EN_PA_PWR,
    // ------------------------------------------------------------------ //
    // SPI / SPI Bypass (HP Banks 65 & 66)                                //
    // ------------------------------------------------------------------ //
    output  logic   [8:1]               SPI_TX_DSA_CS,              //
	output  logic                       ORX_MOSI,
    output  logic                       ORX_CLK,	
    output  logic                       SPI_MOSI,                   //
    output  logic                       SPI_CLK,                    //
	output  logic                       ORX_DSA_Enb,
	output  logic                       TX_DSA_Enb,

	output  logic  [6:0]                RX_DSA_DATA,
	output  logic  [8:1]                RX_DSA_LE,
	
    output  logic  [8:1]                RX_Bypass,  
    output  logic                       ANT_CAL_SW_TX,
	output  logic                       ANT_CAL_SW_RX,
	output  logic                       TX_Gainblock_EN,
	output  logic                       RX_Gainblock_EN,
	
    // ------------------------------------------------------------------ //
    // MM RF Switch & Amp Controls                                        //
    // ------------------------------------------------------------------ //
    output  logic   [8:1]               SW_RXFB_DV_EN,              //
    output  logic   [2:1]               SW_PA_RXFB_VCTL,            //
    output  logic   [2:1]               SW_PA_DV_VCTL,              //
    output  logic   [2:1]               PA_LNA_EN,                  //
	output  logic   [2:1]               SW_PA_LNA_VCTL,             //
	output  logic                       SW_RXFB_VCTL,
	output  logic                       SW_RXFB_VCTL_N,
    // ------------------------------------------------------------------ //
    // Interrupts / Status / Debug                                        //
    // ------------------------------------------------------------------ //
    input           [4:1]               ALARM,                      //
	output  logic   [4:1]               PrDrvEN,
	output  logic                       TRIGGER_FPGA,                    
	input           [8:1]               PGOOD_PA_PSU,
	input                               PGOOD_EXT_48V,
	output  logic   [1:0]               RESETN_PA,
	output  logic   [8:1]               PA_CTRL_IN ,
    input                               AISG_UART1_RXD,	
    output  logic                       AISG_UART1_TXD,
	output  logic                       UART_DE_REN,
	output  logic                       AISG_VDD_ENN,
	output  logic                       AISG_VDD_SW_ENN,
	input                               AISG_PGOOD,
	input                               PSU_ALARM,
    output  logic   [1:0]               FPGA_TEST                  //
);

    // ------------------------------------------------------------------ //
    // Parameters                                                         //
    // ------------------------------------------------------------------ //
    localparam      VCC     = 1'b1;
    localparam      GND     = 1'b0;

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    genvar 	        i;	 


    // ------------------------------------------------------------------ //
    // SPI - Signals and IOs                                              //
    // ------------------------------------------------------------------ //
    logic   	                        emio_spi0_m_i;
    logic                               emio_spi0_m_o;
    logic                               emio_spi0_sclk_o;
    logic           [7:0]               emio_spi0_ss_o_n;
    logic           [3:0]               emio_spi0_bank_sel;

    // SPI-1: Radio Board, Tx Chain
    assign SPI_CLK          = emio_spi0_sclk_o;
    assign SPI_MOSI         =(emio_spi0_bank_sel == 'd1 |emio_spi0_bank_sel == 'd2) ? emio_spi0_m_o : 'd0;
	assign ORX_CLK          = emio_spi0_sclk_o;
	assign ORX_MOSI         =(emio_spi0_bank_sel == 'd3 |emio_spi0_bank_sel == 'd4) ? emio_spi0_m_o : 'd0;
	
    assign SPI_TX_DSA_CS[1] = (emio_spi0_bank_sel == 'd1 | emio_spi0_bank_sel == 'd3) ? emio_spi0_ss_o_n[1] : 1'b1;      // Tx1 DSA or OrX1 Dsa
    assign SPI_TX_DSA_CS[2] = (emio_spi0_bank_sel == 'd1 | emio_spi0_bank_sel == 'd3) ? emio_spi0_ss_o_n[2] : 1'b1;      // Tx2 DSA or OrX2 Dsa
    assign SPI_TX_DSA_CS[3] = (emio_spi0_bank_sel == 'd1 | emio_spi0_bank_sel == 'd3) ? emio_spi0_ss_o_n[3] : 1'b1;      // Tx3 DSA or OrX3 Dsa
    assign SPI_TX_DSA_CS[4] = (emio_spi0_bank_sel == 'd1 | emio_spi0_bank_sel == 'd3) ? emio_spi0_ss_o_n[4] : 1'b1;      // Tx4 DSA or OrX4 Dsa																																	
    assign SPI_TX_DSA_CS[5] = (emio_spi0_bank_sel == 'd2 | emio_spi0_bank_sel == 'd4) ? emio_spi0_ss_o_n[1] : 1'b1;      // Tx5 DSA or OrX5 Dsa
    assign SPI_TX_DSA_CS[6] = (emio_spi0_bank_sel == 'd2 | emio_spi0_bank_sel == 'd4) ? emio_spi0_ss_o_n[2] : 1'b1;      // Tx6 DSA or OrX6 Dsa
    assign SPI_TX_DSA_CS[7] = (emio_spi0_bank_sel == 'd2 | emio_spi0_bank_sel == 'd4) ? emio_spi0_ss_o_n[3] : 1'b1;      // Tx7 DSA or OrX7 Dsa
    assign SPI_TX_DSA_CS[8] = (emio_spi0_bank_sel == 'd2 | emio_spi0_bank_sel == 'd4) ? emio_spi0_ss_o_n[4] : 1'b1;      // Tx8 DSA or OrX8 Dsa
	
    assign emio_spi0_m_i = 1'b1;

    // ------------------------------------------------------------------ //
    // I2C - Signals and IOs                                              //
    // ------------------------------------------------------------------ //
    // sda & scl are pulled up on the board, so they're high when undriven
    // 7/19: Xilinx: I2C EMIO is not supported by the Cadence I2C drivers.

    logic                               iic_sfp_scl_i [3:0];
    logic                               iic_sfp_scl_o [3:0];
    logic                               iic_sfp_scl_t [3:0];
    logic                               iic_sfp_sda_i [3:0];
    logic                               iic_sfp_sda_o [3:0];
    logic                               iic_sfp_sda_t [3:0];

    generate
    for (i = 0; i < 4; i = i + 1) begin : gen_i2c_bufs

        IOBUF iobuf_sfp0_i2c1_scl (
            .I  (iic_sfp_scl_o  [i]),
            .IO (I2C_SCL        [i]),
            .O  (iic_sfp_scl_i  [i]),
            .T  (iic_sfp_scl_t  [i])
        );
    
        IOBUF iobuf_sfp0_i2c1_sda (
            .I  (iic_sfp_sda_o  [i]),
            .IO (I2C_SDA        [i]),
            .O  (iic_sfp_sda_i  [i]),
            .T  (iic_sfp_sda_t  [i])
        );

    end : gen_i2c_bufs
    endgenerate


    // ------------------------------------------------------------------ //
    // Instance: Main Module Top Level                                    //
    // ------------------------------------------------------------------ //
    Vernon_top Vernon_top_u0 (
        .cold_rst_req_n                 (COLD_RST_REQ_N),                   // o

        .pl_refclk1_p                   (PL_CLK1_122M88_P),                 // i
        .pl_refclk1_n                   (PL_CLK1_122M88_N),                 // i
        .pl_refclk2_p                   (PL_CLK2_122M88_P),                 // i
        .pl_refclk2_n                   (PL_CLK2_122M88_N),                 // i
		
        .pl_sysref_p                    (PL_SYSREF_3M84_P),                 // i
        .pl_sysref_n                    (PL_SYSREF_3M84_N),                 // i
        
        .sfp_refclk_p                   (MGTY_REF_CLK_P),                   // i
        .sfp_refclk_n                   (MGTY_REF_CLK_N),                   // i
		
		.pl_ptpclk_p                    (PTP_SYS_500M_P),
		.pl_ptpclk_n                    (PTP_SYS_500M_N),
		
		.pl_1pps_p                      (PL_1PPS_P),
		.pl_1pps_n                      (PL_1PPS_N),
        .sfp_rxp                        (SFP0_RX_T),                        // i [1:0]
        .sfp_rxn                        (SFP0_RX_C),                        // i [1:0]
        .sfp_txp                        (SFP0_TX_T),                        // o [1:0]
        .sfp_txn                        (SFP0_TX_C),                        // o [1:0]
        .sfp_tx_en_n                    (SFP_TX_EN_N),                      // o [1:0]
		
        .adc1_clk_clk_p                 (ADCCLK_REF2_T),
        .adc1_clk_clk_n                 (ADCCLK_REF2_C),
        .dac2_clk_clk_p                 (DACCLK_REF2_C),
        .dac2_clk_clk_n                 (DACCLK_REF2_T),		
        .ana_sysref_p                   (SYSREF_ANA_T),                     
        .ana_sysref_n                   (SYSREF_ANA_C),
		
        .sfp_los                        (SFP_LOS),                          // i [1:0]
        .sfp_tx_fault                   (SFP_TX_FAULT),                     // i [1:0]
        .sfp_detect_n                   (SFP_DETECT_N),                     // i [1:0]
        .sfp_rs                         (SFP_RS),                           // o [1:0]
        .sfp_led                        (SFP_LED),                          // o [1:0]

        .emio_spi0_m_i                  (emio_spi0_m_i),                    // i
        .emio_spi0_m_o                  (emio_spi0_m_o),                    // o
        .emio_spi0_sclk_o               (emio_spi0_sclk_o),                 // o
        .emio_spi0_ss_o_n               (emio_spi0_ss_o_n),                 // o[7:0]
        .emio_spi0_bank_sel             (emio_spi0_bank_sel),               // o[3:0]
		
        .orx_dsa_enb                    (ORX_DSA_Enb),                      // o
        .tx_dsa_enb                     (TX_DSA_Enb),                       // o
		.rx_dsa_data                    (RX_DSA_DATA),                      // o[6:0]
		.rx_dsa_le                      (RX_DSA_LE),                  // o[8:1]		
		.rx_bypass                      (RX_Bypass),                        // o[8:1]
		.ant_cal_sw_tx                  (ANT_CAL_SW_TX),                    // o 
		.ant_cal_sw_rx                  (ANT_CAL_SW_RX),		            // o
		.tx_gainblock_en                (TX_Gainblock_EN),                  // o
		.rx_gainblock_en                (RX_Gainblock_EN),                  // o
		
		
        .iic_sfp_scl_i                  (iic_sfp_scl_i),                    // i [3:0]
        .iic_sfp_scl_o                  (iic_sfp_scl_o),                    // o [3:0]
        .iic_sfp_scl_t                  (iic_sfp_scl_t),                    // o [3:0]
        .iic_sfp_sda_i                  (iic_sfp_sda_i),                    // i [3:0]
        .iic_sfp_sda_o                  (iic_sfp_sda_o),                    // o [3:0]
        .iic_sfp_sda_t                  (iic_sfp_sda_t),                    // o [3:0]

        .sw_rxfb_dv_en                  (SW_RXFB_DV_EN),                    // o [8:1]
        .sw_pa_rxfb_vctl                (SW_PA_RXFB_VCTL),                  // o [2:1]
        .sw_pa_dv_vctl                  (SW_PA_DV_VCTL),                    // o [2:1]
        .pa_lna_en                      (PA_LNA_EN),                        // o [2:1]
		.pa_pwr_en                      (EN_PA_PWR),
		.sw_pa_lna_vctl                 (SW_PA_LNA_VCTL),
        .sw_rxfb_vctl                   (SW_RXFB_VCTL),                     // o
        .sw_rxfb_vctl_n                 (SW_RXFB_VCTL_N),                   // o
		
        .irq_alarm                      (ALARM),                            // i [4:1]
        .prdrven                        (PrDrvEN),		
		.trigger                        (TRIGGER_FPGA),                   // o 
		.pa_psu_pgood                   (PGOOD_PA_PSU),                     // i [8:1]
		.pgood_ext_48v                  (PGOOD_EXT_48V),
		.resent_pa                      (RESETN_PA),                        
		.pa_ctrl_in                     (PA_CTRL_IN),
		.uart1_rxd                      (AISG_UART1_RXD),
		.uart1_txd                      (AISG_UART1_TXD),
		.aisg_uart_de_ren               (UART_DE_REN),
		.aisg_vdd_enn                   (AISG_VDD_ENN),
		.aisg_vdd_sw_enn                (AISG_VDD_SW_ENN),
		.aisg_pgood                     (AISG_PGOOD),
		.psu_alarm                      (PSU_ALARM),
        .fpga_test                      (FPGA_TEST)                        // o [1:0]
		
);



endmodule
