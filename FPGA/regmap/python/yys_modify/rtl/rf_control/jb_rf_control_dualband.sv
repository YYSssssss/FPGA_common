
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

    input                               pps_in_pll,
    input                               pps_in_ext,
    output  logic                       pps_in,

    input                               cpri_cold_rst_req_n,
    output  logic                       cold_rst_req_n,

    jb_hw_ctrl_if.rf_ctrl               IFP_ctrl,
    jb_hw_ctrl_if.hw_stat               IFP_stat,
    jb_intr_ctrl_if.irq_rfc             IFP_irq,
    jb_dpd_srx_if.srx_ctrl              IFP_dpd,
    jb_axi4_stream_if.slave             IFP_srx [1:0] [N_ANTENNAS-1:0],
    output  logic   [2:0]               srx_wrssi_ant,
    input   [2*N_ANTENNAS-1:0] [31:0]   pa_odp_tssi,

    output  logic   [1:0]               pa_swen,
    output  logic   [1:0][5:1]          pa_sw,
	
    input                [7:0]          adc_over_range,
    input                [7:0]          adc_over_voltage,
    output  logic   [1:0][6:0]          rx_dsa_d,
    output  logic   [1:0][4:1]          rx_dsa_le,
    output  logic        [7:0]          rx_lna_bypass,

    input                               pa_v_pgood,	
    output  logic   [1:0]               pa_v_en_n,	
    output  logic                       pa_ch12_dc_sw,
    output  logic                       pa_ch34_dc_sw,
    output  logic                       pa_ch56_dc_sw,
    output  logic                       pa_ch78_dc_sw,	
	
    output  logic                       pa_ctrl12_reset,
    output  logic                       pa_ctrl12_adcrdy,
    output  logic                       pa_ctrl12_dactrig,
    output  logic                       pa_ctrl34_reset,
    output  logic                       pa_ctrl34_adcrdy,
    output  logic                       pa_ctrl34_dactrig,

    output  logic                       pa_ctrl56_reset,
    output  logic                       pa_ctrl56_adcrdy,
    output  logic                       pa_ctrl56_dactrig,
    output  logic                       pa_ctrl78_reset,
    output  logic                       pa_ctrl78_adcrdy,
    output  logic                       pa_ctrl78_dactrig,	
    output  logic   [8:1]               pa_ctrl_sleep,
	
    input                               cpri_sfp_tx_en_n,
    output  logic                       sfp_tx_en_n     [1:0],

    input                               aisg_pgood,
    output  logic                       aisg_vdd_enn,
    output  logic                       aisg_vdd_sw_enn,   
    output  logic                       aisg_dir,
    
    output                              spi_tx_clk,
    output                              spi_tx_mosi,
    output  logic   [8:1]               spi_tx_le,          // TX DSA
    
    output                              spi_orx_clk,
    output                              spi_orx_mosi,
    output  logic   [4:1]               spi_orx_le,         // ORX DSA
  
    output  logic                       spi_pa_clk,
    output  logic                       spi_pa_mosi,
    input                               spi_pa_miso,
    output  logic   [5:2]               spi_pa_le,          // PA Controllers 

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

	logic   [3:1]               pa14_sw  ;
	logic                       pa14_swd ;
	logic                       pa14_swe ;
	logic                       pa14_swen;
										 
	logic   [3:1]               pa58_sw  ;
	logic                       pa58_swd ;
	logic                       pa58_swe ;
	logic                       pa58_swen;
	
    // ------------------------------------------------------------------ //
    // DPD/SRX control                                                    //
    // ------------------------------------------------------------------ //
    jb_srx_ctrl jb_srx_ctrl_u0 (
        .axis_aclk              (clk_3x),                   // i
        .axis_aresetn           (resetn_3x),                // i
        .IFP_ctrl               (IFP_ctrl),                 // jb_hw_ctrl_if.rf_ctrl
        .IFP_dpd                (IFP_dpd),                  // jb_dpd_srx_if.ctrl
        .IFP_srx                (IFP_srx[0]),  // Temp for now                // jb_axi4_stream_if.slave [N_ANTENNAS-1:0]
        .srx_wrssi_ant          (srx_wrssi_ant),            // o [2:0]
		
        .pa14_sw                (pa14_sw  ),
        .pa14_swd               (pa14_swd ),
        .pa14_swe               (pa14_swe ),
        .pa14_swen              (pa14_swen),
		
        .pa58_sw                (pa58_sw  ),
        .pa58_swd               (pa58_swd ),
        .pa58_swe               (pa58_swe ),
        .pa58_swen              (pa58_swen)
		);

    // ------------------------------------------------------------------ //
    // AGC/ADCP                                                           //
    // ------------------------------------------------------------------ //
    assign adcp_over_range      = {adc_over_range   [7:6], adc_over_range   [1:0]};
    assign adcp_over_voltage    = {adc_over_voltage [7:6], adc_over_voltage [1:0]};

    jb_agc_adcp_top jb_agc_adcp_top_u0 (
        .axi_clk                (axi_clk),                       // i
        .axi_resetn             (axi_resetn),                    // i
        .adc_over_range         (adcp_over_range),               // i [3:0]
        .adc_over_voltage       (adcp_over_voltage),             // i [3:0]
        .adcp_disable           (IFP_ctrl.pl_adcp_disable[3:0]), // i [3:0]
        .ps_rxdsa               (IFP_ctrl.ps_rxdsa[3:0]),        // i packed [3:0][6:0]
        .pl_rxdsa               (IFP_stat.pl_rxdsa[3:0]),        // o packed [3:0][6:0]
        .rx_dsa_d               (rx_dsa_d[0]),                   // o[1:0] [6:0]
        .rx_dsa_le              (rx_dsa_le[0]),                  // o[1:0] [4:1]
        .ps_bypass_lna          (IFP_ctrl.bypass_lna[3:0]),      // i [3:0]
        .rx_lna_bypass          (rx_lna_bypass[3:0])             // o [3:0]
    );

    jb_agc_adcp_top jb_agc_adcp_top_u1 (
        .axi_clk                (axi_clk),                       // i
        .axi_resetn             (axi_resetn),                    // i
        .adc_over_range         (adcp_over_range),               // i [3:0]
        .adc_over_voltage       (adcp_over_voltage),             // i [3:0]
        .adcp_disable           (IFP_ctrl.pl_adcp_disable[7:4]), // i [3:0]
        .ps_rxdsa               (IFP_ctrl.ps_rxdsa[7:4]),        // i packed [3:0][6:0]
        .pl_rxdsa               (IFP_stat.pl_rxdsa[7:4]),        // o packed [3:0][6:0]
        .rx_dsa_d               (rx_dsa_d[1]),                   // o [1:0] [6:0]
        .rx_dsa_le              (rx_dsa_le[1]),                  // o [1:0] [4:1]
        .ps_bypass_lna          (IFP_ctrl.bypass_lna[7:4]),      // i [3:0]
        .rx_lna_bypass          (rx_lna_bypass[7:4])             // o [3:0]
    );

    // ------------------------------------------------------------------ //
    // PA Protection                                                      //
    // ------------------------------------------------------------------ //
    jb_pa_protection #(
        .N_ANTENNAS             (8)
    ) jb_pa_protection_u0 (
        .clk_3x                 (clk_3x),                       // i
        .resetn_3x              (resetn_3x),                    // i
        .IFP_ctrl               (IFP_ctrl),                     // jb_hw_ctrl_if.rf_ctrl
        .IFP_irq                (IFP_irq),                      // jb_intr_ctrl_if.irq_rfc
        .tssi                   (pa_odp_tssi),                  // i [2* N_ANTENNAS-1:0] [31:0]
        .rf_overdrive_tssi      (IFP_stat.rf_overdrive_tssi)    // o [2* N_ANTENNAS-1:0] [31:0]
    );

    // ------------------------------------------------------------------ //
    // SPI                                                                //
    // ------------------------------------------------------------------ //
    jb_spi_map jb_spi_map_u0 (
        .spi_bank_sel           (IFP_ctrl.spi_bank_sel),    // i
        .spi_tx_clk             (spi_tx_clk),               // o
        .spi_tx_mosi            (spi_tx_mosi),              // o
        .spi_tx_le              (spi_tx_le),                // o [8:1]
        .spi_orx_clk            (spi_orx_clk),              // o
        .spi_orx_mosi           (spi_orx_mosi),             // o
        .spi_orx_le             (spi_orx_le),               // o [4:1]
        .spi_pa_clk             (spi_pa_clk),               // o
        .spi_pa_mosi            (spi_pa_mosi),              // o
        .spi_pa_miso            (spi_pa_miso),              // i
        .spi_pa_le              (spi_pa_le),                // o [5:2]
        .emio_spi0_miso         (emio_spi0_miso),           // o
        .emio_spi0_mosi         (emio_spi0_mosi),           // i
        .emio_spi0_sclk         (emio_spi0_sclk),           // i
        .emio_spi0_ss_n         (emio_spi0_ss_n)            // i [7:0]
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
    assign pa_swen[0]           = pa14_swen;
    assign pa_swen[1]           = pa58_swen; 
	assign pa_sw[0][1]          = pa14_sw[1];
	assign pa_sw[0][2]          = pa14_sw[2];	
	assign pa_sw[0][3]          = pa14_sw[3];
	assign pa_sw[0][4]          = pa14_swd;	
	assign pa_sw[0][5]          = pa14_swe;	

	assign pa_sw[1][1]          = pa58_sw[1];
	assign pa_sw[1][2]          = pa58_sw[2];	
	assign pa_sw[1][3]          = pa58_sw[3];
	assign pa_sw[1][4]          = pa58_swd;	
	assign pa_sw[1][5]          = pa58_swe;
	
    assign pa_v_en_n           = IFP_ctrl.pa_v_en;

    assign IFP_stat.pa_v_pgood  = pa_v_pgood;
    
    // pa_chxx_dc_sw (active hi) control Q24 switch that supplies 28V to
    // the PA module. This signal is ANDed with PA_ONxx from PA controller
    // to provide an extra layer of protection. PA_ONxx are enabled for PA
    // Drain voltage via SPI after the PA gate voltages are set to 0.
    assign pa_ch12_dc_sw        = IFP_ctrl.pa_ch12_dc_sw;
    assign pa_ch34_dc_sw        = IFP_ctrl.pa_ch34_dc_sw;
    assign pa_ch56_dc_sw        = IFP_ctrl.pa_ch56_dc_sw;
    assign pa_ch78_dc_sw        = IFP_ctrl.pa_ch78_dc_sw;
	
    assign pa_ctrl12_reset      = IFP_ctrl.pa_ctrl12_reset;
    assign pa_ctrl12_dactrig    = 1'b1; // IFP_ctrl.pa_ctrl12_dactrig;
    assign pa_ctrl12_adcrdy     = 1'bz; // IFP_ctrl.pa_ctrl12_adcrdy;

    assign pa_ctrl34_reset      = IFP_ctrl.pa_ctrl34_reset;
    assign pa_ctrl34_dactrig    = 1'b1; // IFP_ctrl.pa_ctrl34_dactrig;
    assign pa_ctrl34_adcrdy     = 1'bz; // IFP_ctrl.pa_ctrl34_adcrdy;

    assign pa_ctrl56_reset      = IFP_ctrl.pa_ctrl56_reset;
    assign pa_ctrl56_dactrig    = 1'b1; // IFP_ctrl.pa_ctrl56_dactrig;
    assign pa_ctrl56_adcrdy     = 1'bz; // IFP_ctrl.pa_ctrl56_adcrdy;

    assign pa_ctrl78_reset      = IFP_ctrl.pa_ctrl78_reset;
    assign pa_ctrl78_dactrig    = 1'b1; // IFP_ctrl.pa_ctrl78_dactrig;
    assign pa_ctrl78_adcrdy     = 1'bz; // IFP_ctrl.pa_ctrl78_adcrdy;

    assign pa_ctrl_sleep[1]     = IFP_ctrl.pa_ctrl1_sleep; // PA_SLEEP12_SLEEP1
    assign pa_ctrl_sleep[2]     = IFP_ctrl.pa_ctrl2_sleep; // PA_SLEEP12_SLEEP2
    assign pa_ctrl_sleep[3]     = IFP_ctrl.pa_ctrl3_sleep; // PA_SLEEP34_SLEEP1
    assign pa_ctrl_sleep[4]     = IFP_ctrl.pa_ctrl4_sleep; // PA_SLEEP34_SLEEP2
    assign pa_ctrl_sleep[5]     = IFP_ctrl.pa_ctrl5_sleep; // PA_SLEEP56_SLEEP1
    assign pa_ctrl_sleep[6]     = IFP_ctrl.pa_ctrl6_sleep; // PA_SLEEP56_SLEEP2
    assign pa_ctrl_sleep[7]     = IFP_ctrl.pa_ctrl7_sleep; // PA_SLEEP78_SLEEP1
    assign pa_ctrl_sleep[8]     = IFP_ctrl.pa_ctrl8_sleep; // PA_SLEEP78_SLEEP2
	
    assign cold_rst_req_n       = IFP_ctrl.cold_rst_n_mask ? cpri_cold_rst_req_n : IFP_ctrl.cold_rst_n;

    // ------------------------------------------------------------------ //
    // Fronthaul Misc.                                                    //
    // ------------------------------------------------------------------ //
     assign sfp_tx_en_n[0] = IFP_ctrl.sfp_tx_en_n_override[0] ? IFP_ctrl.sfp_tx_en_n[0] : cpri_sfp_tx_en_n;
     assign sfp_tx_en_n[1] = IFP_ctrl.sfp_tx_en_n_override[1] ? IFP_ctrl.sfp_tx_en_n[1] : IFP_ctrl.sfp_tx_en_n[1];


    // ------------------------------------------------------------------ //
    // AISG signals                                                       //
    // ------------------------------------------------------------------ //
    assign  aisg_dir = IFP_ctrl.uart1_de_ren;
    assign  IFP_stat.aisg_pgood = aisg_pgood;
    assign  aisg_vdd_enn = IFP_ctrl.aisg_vdd_enn;
    assign  aisg_vdd_sw_enn = IFP_ctrl.aisg_vdd_sw_enn;    

    // ------------------------------------------------------------------ //
    // PPS                                                                //
    // ------------------------------------------------------------------ //
    //assign pps_in = IFP_ctrl.one_pps_source ? pps_in_ext : pps_in_pll;

/*
    BUFGMUX BUFGMUX_PPS (
        .S      (IFP_ctrl.one_pps_source),
        .I0     (pps_in_pll),
        .I1     (pps_in_ext),
        .O      (pps_in)
    );
*/

    logic   pps_in_ext_bufg;
    logic   pps_in_pll_bufg;
    
    BUFG BUFG_pps_in_ext (
        .I          (pps_in_ext),
        .O          (pps_in_ext_bufg)
    );
    
    BUFG BUFG_pps_in_pll (
        .I          (pps_in_pll),
        .O          (pps_in_pll_bufg)
    );
    
    // Since we require immediate switching between the two clock inputs,
    // we need to bypass the edge sensitivity of BUFGCTRL.
    // If one of the clock inputs is no longer switching, the clock
    // output would not have the proper switching conditions because
    // the BUFGCTRL never detected a clock edge.
    // For this case, we need to use the asynchronous MUX. See UG572
    // Clocking Resources "Additional BUFGCTRL Use Models" section.
    
    // Asynchronous MUX Using BUFGCTRL
    BUFGCTRL BUFGMUX_PPS (
        .IGNORE1    (1'b1),
        .CE1        (1'b1),
        .IGNORE0    (1'b1),
        .CE0        (1'b1),
        .S1         (IFP_ctrl.one_pps_source),
        .S0         (~IFP_ctrl.one_pps_source),
        .I1         (pps_in_ext_bufg),
        .I0         (pps_in_pll_bufg),
        .O          (pps_in)
    );

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

    assign IFP_ctrl.spi_slave0_rxdata = spi_slave_rxdata[0][6:0];
    assign IFP_ctrl.spi_slave1_rxdata = spi_slave_rxdata[1][6:0];
*/
    

endmodule
