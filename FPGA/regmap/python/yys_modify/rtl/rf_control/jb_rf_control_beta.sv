
`timescale 1ns / 1ps

module jb_rf_control #(
    parameter N_CARRIERS    = 2,
    parameter N_ANTENNAS    = 4,
    parameter PRECISION     = 16
) (
    input                               clk_3x,
    input                               resetn_3x,
    input                               axi_clk,
    input                               axi_resetn,

    input                               cpri_cold_rst_req_n,
    output  logic                       cold_rst_req_n,

    jb_hw_ctrl_if.rf_ctrl               IFP_ctrl,
    jb_hw_ctrl_if.hw_stat               IFP_stat,
    jb_intr_ctrl_if.irq_rfc             IFP_irq,
    jb_dpd_srx_if.srx_ctrl              IFP_dpd,
    jb_axi4_stream_if.slave             IFP_srx [N_ANTENNAS-1:0],
    output  logic   [2:0]               srx_wrssi_ant,
    input   [N_ANTENNAS-1:0] [31:0]     pa_odp_tssi,

    output  logic   [5:0]               rf_switch_n,
    output  logic   [5:0]               rf_switch_en_n,

    input           [7:0]               adc_over_range,
    input           [7:0]               adc_over_voltage,
    output  logic   [6:0]               rx_dsa_d,
    output  logic   [4:1]               rx_dsa_le,
    output  logic   [3:0]               rx_lna_bypass,

    output  logic                       pa_v_en_n,
    input                               pa_v_pgood,     // 5/16/19: Ignored
    output  logic                       pa_ch12_dc_sw,
    output  logic                       pa_ch34_dc_sw,
    output  logic                       pa_ctrl1_reset,
    output  logic                       pa_ctrl2_reset,
    output  logic   [4:1]               pa_ctrl_sleep,

    input                               aisg_pgood,
    output  logic                       aisg_vdd_enn,
    output  logic                       aisg_vdd_sw_enn,   
    output  logic                       aisg_dir,

    output                              SPI_TX_CLK,
    output                              SPI_TX_D,
    output [4:1]                        SPI_TX_LE, // TX DSA
    
    output                              SPI_ORX_CLK,
    output                              SPI_ORX_D,
    output [2:1]                        SPI_ORX_LE,   // ORX DSA
  
    input                               PA_SPI1_MISO,
    output                              PA_SPI1_SCLK,
    output                              PA_SPI1_MOSI,
    output [3:1]                        PA_SPI1_CS,   // PA Controllers 
    
    output                              PA_SPI2_SCLK,
    output                              PA_SPI2_MOSI,
    output [2:1]                        PA_SPI2_LE, // ADAM (Doherty Align) - PA Board/U201/MMDS20254HT1
        
    output                              PA_SPI3_SCLK,
    output                              PA_SPI3_MOSI,
    output                              PA_SPI3_LE4,      // ADAM (Doherty Align) - PA Board/U201/MMDS20254HT1
    output                              PA_SPI3_LE3,      // ADAM (Doherty Align) - PA Board/U301/MMDS20254HT1
    
    output  logic                       emio_spi0_miso,
    input                               emio_spi0_mosi,
    input                               emio_spi0_sclk,
    input           [7:0]               emio_spi0_ss_n
);

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    genvar i;
    logic   [7:0]               spi_slave_rxdata[1:0];
    logic   [3:0]               adcp_over_range;
    logic   [3:0]               adcp_over_voltage;

    // ------------------------------------------------------------------ //
    // DPD/SRX control                                                    //
    // ------------------------------------------------------------------ //
    jb_srx_ctrl jb_srx_ctrl_u0 (
        .axis_aclk              (clk_3x),                   // i
        .axis_aresetn           (resetn_3x),                // i
        .IFP_ctrl               (IFP_ctrl),                 // jb_hw_ctrl_if.rf_ctrl
        .IFP_dpd                (IFP_dpd),                  // jb_dpd_srx_if.ctrl
        .IFP_srx                (IFP_srx),                  // jb_axi4_stream_if.slave [N_ANTENNAS-1:0]
        .srx_wrssi_ant          (srx_wrssi_ant),            // o [2:0]
        .rf_switch_n            (rf_switch_n),              // o [5:0]
        .rf_switch_en_n         (rf_switch_en_n)            // o [5:0]
    );

    // ------------------------------------------------------------------ //
    // AGC/ADCP                                                           //
    // ------------------------------------------------------------------ //
    assign adcp_over_range      = adc_over_range   [3:0];
    assign adcp_over_voltage    = adc_over_voltage [3:0];

    jb_agc_adcp_top jb_agc_adcp_top_u0 (
        .axi_clk                (axi_clk),                  // i
        .axi_resetn             (axi_resetn),               // i
        .adc_over_range         (adcp_over_range),          // i [3:0]
        .adc_over_voltage       (adcp_over_voltage),        // i [3:0]
        .adcp_disable           (IFP_ctrl.pl_adcp_disable), // i [3:0]
        .ps_rxdsa               (IFP_ctrl.ps_rxdsa),        // i packed [3:0][6:0]
        .pl_rxdsa               (IFP_stat.pl_rxdsa),        // o packed [3:0][6:0]
        .rx_dsa_d               (rx_dsa_d),                 // o [6:0]
        .rx_dsa_le              (rx_dsa_le),                // o [4:1]
        .ps_bypass_lna          (IFP_ctrl.bypass_lna),      // i [3:0]
        .rx_lna_bypass          (rx_lna_bypass)             // o [3:0]
    );

    // ------------------------------------------------------------------ //
    // PA Protection                                                      //
    // ------------------------------------------------------------------ //
    jb_pa_protection #(
        .N_ANTENNAS             (N_ANTENNAS)
    ) jb_pa_protection_u0 (
        .clk_3x                 (clk_3x),                       // i
        .resetn_3x              (resetn_3x),                    // i
        .IFP_ctrl               (IFP_ctrl),                     // jb_hw_ctrl_if.rf_ctrl
        .IFP_irq                (IFP_irq),                      // jb_intr_ctrl_if.irq_rfc
        .tssi                   (pa_odp_tssi),                  // i [N_ANTENNAS-1:0] [31:0]
        .rf_overdrive_tssi      (IFP_stat.rf_overdrive_tssi)    // o [N_ANTENNAS-1:0] [31:0]
    );

    // ------------------------------------------------------------------ //
    // Misc RF IO Control                                                 //
    // ------------------------------------------------------------------ //
    // pa_v_en (active low) controls the 28V power brick on the radioboard
    // Old brick (T1, silver shield)
    // New brick (ALT_T1, black shield) by NetPower
    // ALT_T1 outputs 22V by default which is then trimmed to 28V with U5
    // via I2C from the PS.
    
    // 8/6/19 - Email from Jason
    // Mod #15 does not change the polarity of the PA_V_EN, it only changes
    // the pull-down on PA_V_EN to a pull-up so that the brick is off by default. 
    // PA_V_EN is still active low enable (instead of the planned active high enable)
    // with the bricks we have, regardless whether MOD#15 is implemented.

    assign pa_v_en_n        = IFP_ctrl.pa_v_en;

    // pa_chxx_dc_sw (active hi) control Q24 switch that supplies 28V to
    // the PA module. This signal is ANDed with PA_ONxx from PA controller
    // to provide an extra layer of protection. PA_ONxx are enabled for PA
    // Drain voltage via SPI after the PA gate voltages are set to 0.
    assign pa_ch12_dc_sw    = IFP_ctrl.pa_ch12_dc_sw;
    assign pa_ch34_dc_sw    = IFP_ctrl.pa_ch34_dc_sw;


    assign pa_ctrl1_reset   = IFP_ctrl.pa_ctrl1_reset;
    assign pa_ctrl2_reset   = IFP_ctrl.pa_ctrl2_reset;

    assign pa_ctrl_sleep[1] = IFP_ctrl.pa_ctrl1_sleep;  // PA_CTRL1_SLEEP1
    assign pa_ctrl_sleep[2] = IFP_ctrl.pa_ctrl2_sleep;  // PA_CTRL1_SLEEP2
    assign pa_ctrl_sleep[3] = IFP_ctrl.pa_ctrl3_sleep;  // PA_CTRL2_SLEEP1
    assign pa_ctrl_sleep[4] = IFP_ctrl.pa_ctrl4_sleep;  // PA_CTRL2_SLEEP2

    assign cold_rst_req_n   = IFP_ctrl.cold_rst_n_mask ? cpri_cold_rst_req_n : IFP_ctrl.cold_rst_n;

    // ------------------------------------------------------------------ //
    // AISG signals                                                       //
    // ------------------------------------------------------------------ //
    assign  aisg_dir = IFP_ctrl.aisg_direction;
    assign  IFP_stat.aisg_pgood = aisg_pgood;
    assign  aisg_vdd_enn = IFP_ctrl.aisg_vdd_enn;
    assign  aisg_vdd_sw_enn = IFP_ctrl.aisg_vdd_sw_enn;    

    // ------------------------------------------------------------------ //
    // Debug                                                              //
    // ------------------------------------------------------------------ //

/*    jb_spi_slave_dsa spi_slave0_dsa_u1 (
        .sclk                           (spi0_sclk),                // i
        .csn                            (spi0_csn),                 // i
        .mosi                           (spi0_mosi),                // i
        .miso                           (),                         // o
        .rx_clk                         (axi_clk),                  // i
        .trn_rxd                        (spi_slave_rxdata[0])       // o [7:0]
    );

    jb_spi_slave_dsa spi_slave1_dsa_u1 (
        .sclk                           (spi1_sclk),                // i
        .csn                            (spi1_csn),                 // i
        .mosi                           (spi1_mosi),                // i
        .miso                           (),                         // o
        .rx_clk                         (axi_clk),                  // i
        .trn_rxd                        (spi_slave_rxdata[1])       // o [7:0]
    );

*/
    assign IFP_stat.spi_slave0_rxdata = 0; //spi_slave_rxdata[0][6:0];
    assign IFP_stat.spi_slave1_rxdata = 0; //spi_slave_rxdata[1][6:0];
    
    // ------------------------------------------------------------------ //
    // SPI                                                                //
    // ------------------------------------------------------------------ //
    // Don't pull-ups MISO inputs because we're ORing these lines internally.
    //
    // 8/12/19: Disconnected PA_SPI2_MISO and PA_SPI3_MISO per Horatio's request.
    // ADAM ICs (on the PA board) drive PA_SPI2_MISO and PA_SPI3_MISO high
    // sometimes causing the OR gate below to get stuck at 1.
    // It looks like the ADAM ICs are write-only and we dont read from them.
    // So, as a workaround for now, MISO signals from the ADAM ICs are disconnected. 


    wire                                    spi_bank_sel;
    wire                                    spi_bank0_miso;
    wire                                    spi_bank1_miso;
            
    assign spi_bank_sel = IFP_ctrl.spi_bank_sel;

    // SPI-1: Radio Board, Tx Chain
    assign SPI_TX_CLK    = (spi_bank_sel == 1) ? emio_spi0_sclk    : 1'b1;
    assign SPI_TX_D      = (spi_bank_sel == 1) ? emio_spi0_mosi    : 1'b1;
    assign SPI_TX_LE[4]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[3] : 1'b1;       // Tx4 DSA
    assign SPI_TX_LE[3]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[2] : 1'b1;       // Tx3 DSA
    assign SPI_TX_LE[2]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[1] : 1'b1;       // Tx2 DSA
    assign SPI_TX_LE[1]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[0] : 1'b1;       // Tx1 DSA

    // SPI-1: Radio Board, ORX
    assign SPI_ORX_CLK   = (spi_bank_sel == 1) ? emio_spi0_sclk    : 1'b1;
    assign SPI_ORX_D     = (spi_bank_sel == 1) ? emio_spi0_mosi    : 1'b1;
    assign SPI_ORX_LE[2] = (spi_bank_sel == 1) ? emio_spi0_ss_n[5] : 1'b1;       // ORx1 DSA 
    assign SPI_ORX_LE[1] = (spi_bank_sel == 1) ? emio_spi0_ss_n[4] : 1'b1;       // ORx2 DSA

    assign spi_bank1_miso = 1'b1;
    // ------------------------------------------------------------------ //
    
    // SPI-0: PA Board
    assign PA_SPI1_SCLK  = (spi_bank_sel == 0) ? emio_spi0_sclk    : 1'b1;  
    assign PA_SPI1_MOSI  = (spi_bank_sel == 0) ? emio_spi0_mosi    : 1'b1;
    assign PA_SPI1_CS[3] = (spi_bank_sel == 0) ? emio_spi0_ss_n[2] : 1'b1;       // PA Controller 3/4    - PA Board/U600/AMC7834IRTQ
    assign PA_SPI1_CS[2] = (spi_bank_sel == 0) ? emio_spi0_ss_n[1] : 1'b1;       // PA Controller 1/2    - PA Board/U500/AMC7834IRTQ
    assign PA_SPI1_CS[1] = (spi_bank_sel == 0) ? emio_spi0_ss_n[0] : 1'b1;       // EEPROM               - PA Board/U902/M95256-DRMN3TP/K
        
    assign PA_SPI2_SCLK  = (spi_bank_sel == 0) ? emio_spi0_sclk    : 1'b1;
    assign PA_SPI2_MOSI  = (spi_bank_sel == 0) ? emio_spi0_mosi    : 1'b1;
    assign PA_SPI2_LE[2] = (spi_bank_sel == 0) ? emio_spi0_ss_n[4] : 1'b1;       // ADAM (Doherty Align) - PA Board/U201/MMDS20254HT1
    assign PA_SPI2_LE[1] = (spi_bank_sel == 0) ? emio_spi0_ss_n[3] : 1'b1;       // ADAM (Doherty Align) - PA Board/U101/MMDS20254HT1
        
    assign PA_SPI3_SCLK  = (spi_bank_sel == 0) ? emio_spi0_sclk    : 1'b1;
    assign PA_SPI3_MOSI  = (spi_bank_sel == 0) ? emio_spi0_mosi    : 1'b1;
    assign PA_SPI3_LE4   = (spi_bank_sel == 0) ? emio_spi0_ss_n[6] : 1'b1;       // ADAM (Doherty Align) - PA Board/U201/MMDS20254HT1
    assign PA_SPI3_LE3   = (spi_bank_sel == 0) ? emio_spi0_ss_n[5] : 1'b1;       // ADAM (Doherty Align) - PA Board/U301/MMDS20254HT1

    //assign emio_spi0_miso = PA_SPI1_MISO | PA_SPI2_MISO | PA_SPI3_MISO;
    assign spi_bank0_miso = PA_SPI1_MISO; // | PA_SPI2_MISO | PA_SPI3_MISO;

    assign emio_spi0_miso = (spi_bank_sel == 0) ? spi_bank0_miso : spi_bank1_miso;

endmodule
