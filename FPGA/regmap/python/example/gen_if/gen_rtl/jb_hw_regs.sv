// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 3007216                                                     // 
// Date         : 05/14/21                                                    // 
// File         : jb_hw_regs.sv                                               // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 

module jb_hw_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_hw_ctrl_if.ctrl         IFP_hw_ctrl
);



////////////////Register Field Declarations//////////////////

   logic                     FPGA_REG_PL_COLD_RST_cold_rst_n;
  // 
   logic                     FPGA_REG_PL_COLD_RST_MASK_cold_rst_n_mask;
  // 1 = Mask cold_rst_n
   logic  [3:0]              FPGA_REG_SPI_BANK_SELECT_spi_bank_sel;
  // 0 =  Disable SPI Access, 1 = TX DSAs 0 to 3, 2 = TX DSAs 4 to 7, 3 = ORx DSAs 0 to 3, 4 = ORx DSA 4 to 7
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac0_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 0 (Bank228 DAC0) - DL Radio Path 1
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac1_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 1 (Bank228 DAC1) - DL Radio Path 2
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac2_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 2 (Bank228 DAC2) - DL Radio Path 3
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac3_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 3 (Bank228 DAC3) - DL Radio Path 4
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac4_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 4 (Bank229 DAC0) - DL Radio Path 5
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac5_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 5 (Bank229 DAC1) - DL Radio Path 6
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac6_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 6 (Bank229 DAC2) - DL Radio Path 7
   logic  [2:0]              FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac7_dl_dfe_sel;
  // Select DL DFE stream (0 to 7) for DAC 7 (Bank229 DAC3) - DL Radio Path 8
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx0_adc_sel;
  // Select ADC for UL DFE0 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx1_adc_sel;
  // Select ADC for UL DFE1 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx2_adc_sel;
  // Select ADC for UL DFE2 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx3_adc_sel;
  // Select ADC for UL DFE3 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx4_adc_sel;
  // Select ADC for UL DFE4 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx5_adc_sel;
  // Select ADC for UL DFE5 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx6_adc_sel;
  // Select ADC for UL DFE6 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx7_adc_sel;
  // Select ADC for UL DFE7 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx0_adc_sel;
  // Select ADC for UL ORX0 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx1_adc_sel;
  // Select ADC for UL ORX1 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx2_adc_sel;
  // Select ADC for UL ORX2 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx3_adc_sel;
  // Select ADC for UL ORX3 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx4_adc_sel;
  // Select ADC for UL ORX4 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx5_adc_sel;
  // Select ADC for UL ORX5 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx6_adc_sel;
  // Select ADC for UL ORX6 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic  [2:0]              FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx7_adc_sel;
  // Select ADC for UL ORX7 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
   logic                     FPGA_REG_ORX_RF_SW_CTRL1_rf_switch_override;
  // 1 = Software override for RF switches
   logic  [2:0]              FPGA_REG_ORX_RF_SW_CTRL1_orx_ant_sel;
  // 0  = Antenna 1, 1 = Antenna 2, 2 = Antenna 3, …, 7 = Antenna 8
   logic                     FPGA_REG_ORX_RF_SW_CTRL1_orx_path_sel;
  // 0 = Incident (DPD), 1 = Reflected (VSWR)
   logic  [15:0]              FPGA_REG_ORX_RF_SW_CTRL2_ant_switch_delay;
  // Antenna switch delay for DPD and VSWR measurements, C8=200 cycles of 368.64MHz = 542ns
   logic                     FPGA_REG_ANT_CAL_CTRL_tx_ant_cal_en;
  // Enable TX calibration. This also controls the Tx vs. Rx switch at the antenna cal port
   logic                     FPGA_REG_ANT_CAL_CTRL_rx_ant_cal_en;
  // Enable RX Calibration. Tx calbration control (tx_ant_cal_en) must be low to enable RX calibration port
   logic                     FPGA_REG_TX_GAINBLOCK_CTRL_tx_gainblock_en_n;
  // 0 = Enable TX Gain Blocks QPA9127 and TQL9062 for all TX paths, 1 = Disable
   logic                     FPGA_REG_RX_GAINBLOCK_CTRL_rx_gainblock_en_n;
  // 0 = Enable RX Gain Blocks QPA9127 and QPL9097 (LNA) for all RX paths, 1 = Disable
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_0;
  // 1 = Bypass QPL9097 LNA on Rx Chain 0
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_1;
  // 1 = Bypass QPL9097 LNA on Rx Chain 1
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_2;
  // 1 = Bypass QPL9097 LNA on Rx Chain 2
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_3;
  // 1 = Bypass QPL9097 LNA on Rx Chain 3
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_4;
  // 1 = Bypass QPL9097 LNA on Rx Chain 4
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_5;
  // 1 = Bypass QPL9097 LNA on Rx Chain 5
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_6;
  // 1 = Bypass QPL9097 LNA on Rx Chain 6
   logic                     FPGA_REG_LNA_CTRL_bypass_lna_7;
  // 1 = Bypass QPL9097 LNA on Rx Chain 7
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_0_disable;
  // 1 = Disable PL ADCP for Rx0 - Only prevents PL from responding to overvoltage and overrange
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_1_disable;
  // 1 = Disable PL ADCP for Rx1 - Only prevents PL from responding to overvoltage and overrange
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_2_disable;
  // 1 = Disable PL ADCP for Rx2 - Only prevents PL from responding to overvoltage and overrange
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_3_disable;
  // 1 = Disable PL ADCP for Rx3 - Only prevents PL from responding to overvoltage and overrange
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_4_disable;
  // 1 = Disable PL ADCP for Rx4 - Only prevents PL from responding to overvoltage and overrange
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_5_disable;
  // 1 = Disable PL ADCP for Rx5 - Only prevents PL from responding to overvoltage and overrange
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_6_disable;
  // 1 = Disable PL ADCP for Rx6 - Only prevents PL from responding to overvoltage and overrange
   logic                     FPGA_REG_PL_ADCP_CTRL_pl_adcp_7_disable;
  // 1 = Disable PL ADCP for Rx7 - Only prevents PL from responding to overvoltage and overrange
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL_ps_rxdsa_0;
  // Rx DSA 0 control from PS
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL_ps_rxdsa_1;
  // Rx DSA 1 control from PS
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL_ps_rxdsa_2;
  // Rx DSA 2 control from PS
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL_ps_rxdsa_3;
  // Rx DSA 3 control from PS
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_4;
  // Rx DSA 4 control from PS
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_5;
  // Rx DSA 5 control from PS
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_6;
  // Rx DSA 6 control from PS
   logic  [6:0]              FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_7;
  // Rx DSA 7 control from PS
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL_pl_rxdsa_0;
  // Actual control applied to Rx DSA 0 from PL (Read Only)
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL_pl_rxdsa_1;
  // Actual control applied to Rx DSA 1 from PL (Read Only)
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL_pl_rxdsa_2;
  // Actual control applied to Rx DSA 2 from PL (Read Only)
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL_pl_rxdsa_3;
  // Actual control applied to Rx DSA 3 from PL (Read Only)
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_4;
  // Actual control applied to Rx DSA 4 from PL (Read Only)
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_5;
  // Actual control applied to Rx DSA 5 from PL (Read Only)
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_6;
  // Actual control applied to Rx DSA 6 from PL (Read Only)
   logic  [6:0]              FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_7;
  // Actual control applied to Rx DSA 7 from PL (Read Only)
   logic                     FPGA_REG_PA_LNA_CTRL_pa_lna_en_1to4;
  // 1 = Enable PA board 1 LNA
   logic                     FPGA_REG_PA_LNA_CTRL_pa_lna_en_5to8;
  // 1 = Enable PA board 2 LNA
   logic                     FPGA_REG_PA_CONTROLLER_RESET_CTRL_pa_resetn;
  // 0 = Reset PA controllers for both PA boards
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_1;
  // TDD on/off control for PA1
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_2;
  // TDD on/off control for PA2
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_3;
  // TDD on/off control for PA3
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_4;
  // TDD on/off control for PA4
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_5;
  // TDD on/off control for PA5
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_6;
  // TDD on/off control for PA6
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_7;
  // TDD on/off control for PA7
   logic                     FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_8;
  // TDD on/off control for PA8
   logic  [7:0]              FPGA_REG_PWR_STATUS_pa_v_pgood;
  // PA_V Power Good
   logic                     FPGA_REG_PWR_STATUS_aisg_pgood;
  // Power Good.  Signal is pulled up on schematic
   logic                     FPGA_REG_AISG_PWR_CTRL_aisg_vdd_enn;
  // 0 - Enabled, 1 - Disabled
   logic                     FPGA_REG_AISG_PWR_CTRL_aisg_vdd_sw_enn;
  // 0 - Enabled, 1 - Disabled
   logic                     FPGA_REG_AISG_CTRL_aisg_uart_de_ren;
  // 0 - Receiving, 1 - Transmitting (Driver En, Receiver En_n)
   logic  [1:0]              FPGA_REG_SFP_CTRL_sfp_tx_en_n;
  // Active low - [0] Bit for SFP0, [1] Bit for SFP1
   logic  [1:0]              FPGA_REG_SFP_CTRL_sfp_tx_en_n_override;
  // 0 = use internal PL logic, 1 = override internal PL logic with sfp_tx_en_n register
   logic  [1:0]              FPGA_REG_SFP_CTRL2_sfp_rs;
  // SFP Rate Select
   logic  [1:0]              FPGA_REG_SFP_CTRL2_sfp_led;
  // SFP LEDs
   logic                     FPGA_REG_TRIG_CTRL_trigger;
  // Trigger to the Maintenance Board
   logic                     FPGA_REG_TRIG_CTRL_trigger_override;
  // 1 = Trigger comes from the register bit, 0 = generated internally
   logic                     FPGA_REG_1PPS_CTRL_one_pps_source;
  // 0 = 1PPS (ONE_PPS) from Si5518, 1 = 1PPS (1PPS_IN2) from Maintenance Board (J12 Molex RF Connector)
   logic  [31:0]              FPGA_REG_HW_SCRATCH_hw_scratch;
  // HW scratch








////////////////ASSIGN PARAMETERS//////////////////





////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_hw_ctrl.cold_rst_n =  FPGA_REG_PL_COLD_RST_cold_rst_n;
   assign  IFP_hw_ctrl.cold_rst_n_mask =  FPGA_REG_PL_COLD_RST_MASK_cold_rst_n_mask;
   assign  IFP_hw_ctrl.spi_bank_sel =  FPGA_REG_SPI_BANK_SELECT_spi_bank_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[0] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac0_dl_dfe_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[1] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac1_dl_dfe_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[2] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac2_dl_dfe_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[3] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac3_dl_dfe_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[4] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac4_dl_dfe_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[5] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac5_dl_dfe_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[6] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac6_dl_dfe_sel;
   assign  IFP_hw_ctrl.dac_dl_dfe_sel[7] =  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac7_dl_dfe_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[0] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx0_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[1] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx1_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[2] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx2_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[3] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx3_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[4] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx4_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[5] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx5_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[6] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx6_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_rx_adc_sel[7] =  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx7_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[0] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx0_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[1] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx1_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[2] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx2_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[3] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx3_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[4] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx4_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[5] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx5_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[6] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx6_adc_sel;
   assign  IFP_hw_ctrl.ul_dfe_orx_adc_sel[7] =  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx7_adc_sel;
   assign  IFP_hw_ctrl.rf_switch_override =  FPGA_REG_ORX_RF_SW_CTRL1_rf_switch_override;
   assign  IFP_hw_ctrl.orx_ant_sel[0] =  FPGA_REG_ORX_RF_SW_CTRL1_orx_ant_sel;
   assign  IFP_hw_ctrl.orx_path_sel[0] =  FPGA_REG_ORX_RF_SW_CTRL1_orx_path_sel;
   assign  IFP_hw_ctrl.ant_switch_delay =  FPGA_REG_ORX_RF_SW_CTRL2_ant_switch_delay;
   assign  IFP_hw_ctrl.tx_ant_cal_en =  FPGA_REG_ANT_CAL_CTRL_tx_ant_cal_en;
   assign  IFP_hw_ctrl.rx_ant_cal_en =  FPGA_REG_ANT_CAL_CTRL_rx_ant_cal_en;
   assign  IFP_hw_ctrl.tx_gainblock_en_n =  FPGA_REG_TX_GAINBLOCK_CTRL_tx_gainblock_en_n;
   assign  IFP_hw_ctrl.rx_gainblock_en_n =  FPGA_REG_RX_GAINBLOCK_CTRL_rx_gainblock_en_n;
   assign  IFP_hw_ctrl.bypass_lna[0] =  FPGA_REG_LNA_CTRL_bypass_lna_0;
   assign  IFP_hw_ctrl.bypass_lna[1] =  FPGA_REG_LNA_CTRL_bypass_lna_1;
   assign  IFP_hw_ctrl.bypass_lna[2] =  FPGA_REG_LNA_CTRL_bypass_lna_2;
   assign  IFP_hw_ctrl.bypass_lna[3] =  FPGA_REG_LNA_CTRL_bypass_lna_3;
   assign  IFP_hw_ctrl.bypass_lna[4] =  FPGA_REG_LNA_CTRL_bypass_lna_4;
   assign  IFP_hw_ctrl.bypass_lna[5] =  FPGA_REG_LNA_CTRL_bypass_lna_5;
   assign  IFP_hw_ctrl.bypass_lna[6] =  FPGA_REG_LNA_CTRL_bypass_lna_6;
   assign  IFP_hw_ctrl.bypass_lna[7] =  FPGA_REG_LNA_CTRL_bypass_lna_7;
   assign  IFP_hw_ctrl.pl_adcp_disable[0] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_0_disable;
   assign  IFP_hw_ctrl.pl_adcp_disable[1] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_1_disable;
   assign  IFP_hw_ctrl.pl_adcp_disable[2] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_2_disable;
   assign  IFP_hw_ctrl.pl_adcp_disable[3] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_3_disable;
   assign  IFP_hw_ctrl.pl_adcp_disable[4] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_4_disable;
   assign  IFP_hw_ctrl.pl_adcp_disable[5] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_5_disable;
   assign  IFP_hw_ctrl.pl_adcp_disable[6] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_6_disable;
   assign  IFP_hw_ctrl.pl_adcp_disable[7] =  FPGA_REG_PL_ADCP_CTRL_pl_adcp_7_disable;
   assign  IFP_hw_ctrl.ps_rxdsa[0] =  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_0;
   assign  IFP_hw_ctrl.ps_rxdsa[1] =  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_1;
   assign  IFP_hw_ctrl.ps_rxdsa[2] =  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_2;
   assign  IFP_hw_ctrl.ps_rxdsa[3] =  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_3;
   assign  IFP_hw_ctrl.ps_rxdsa[4] =  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_4;
   assign  IFP_hw_ctrl.ps_rxdsa[5] =  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_5;
   assign  IFP_hw_ctrl.ps_rxdsa[6] =  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_6;
   assign  IFP_hw_ctrl.ps_rxdsa[7] =  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_7;
   assign  IFP_hw_ctrl.pa_lna_en[0] =  FPGA_REG_PA_LNA_CTRL_pa_lna_en_1to4;
   assign  IFP_hw_ctrl.pa_lna_en[1] =  FPGA_REG_PA_LNA_CTRL_pa_lna_en_5to8;
   assign  IFP_hw_ctrl.pa_resetn =  FPGA_REG_PA_CONTROLLER_RESET_CTRL_pa_resetn;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[0] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_1;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[1] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_2;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[2] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_3;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[3] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_4;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[4] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_5;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[5] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_6;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[6] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_7;
   assign  IFP_hw_ctrl.tdd_ctrl_pa[7] =  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_8;
   assign  IFP_hw_ctrl.aisg_vdd_enn =  FPGA_REG_AISG_PWR_CTRL_aisg_vdd_enn;
   assign  IFP_hw_ctrl.aisg_vdd_sw_enn =  FPGA_REG_AISG_PWR_CTRL_aisg_vdd_sw_enn;
   assign  IFP_hw_ctrl.uart1_de_ren =  FPGA_REG_AISG_CTRL_aisg_uart_de_ren;
   assign  IFP_hw_ctrl.sfp_tx_en_n =  FPGA_REG_SFP_CTRL_sfp_tx_en_n;
   assign  IFP_hw_ctrl.sfp_tx_en_n_override =  FPGA_REG_SFP_CTRL_sfp_tx_en_n_override;
   assign  IFP_hw_ctrl.sfp_rs =  FPGA_REG_SFP_CTRL2_sfp_rs;
   assign  IFP_hw_ctrl.sfp_led =  FPGA_REG_SFP_CTRL2_sfp_led;
   assign  IFP_hw_ctrl.trigger =  FPGA_REG_TRIG_CTRL_trigger;
   assign  IFP_hw_ctrl.trigger_override =  FPGA_REG_TRIG_CTRL_trigger_override;
   assign  IFP_hw_ctrl.one_pps_source =  FPGA_REG_1PPS_CTRL_one_pps_source;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  FPGA_REG_PL_DSA_CTRL_pl_rxdsa_0 = IFP_hw_ctrl.pl_rxdsa[0];
   assign  FPGA_REG_PL_DSA_CTRL_pl_rxdsa_1 = IFP_hw_ctrl.pl_rxdsa[1];
   assign  FPGA_REG_PL_DSA_CTRL_pl_rxdsa_2 = IFP_hw_ctrl.pl_rxdsa[2];
   assign  FPGA_REG_PL_DSA_CTRL_pl_rxdsa_3 = IFP_hw_ctrl.pl_rxdsa[3];
   assign  FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_4 = IFP_hw_ctrl.pl_rxdsa[4];
   assign  FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_5 = IFP_hw_ctrl.pl_rxdsa[5];
   assign  FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_6 = IFP_hw_ctrl.pl_rxdsa[6];
   assign  FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_7 = IFP_hw_ctrl.pl_rxdsa[7];
   assign  FPGA_REG_PWR_STATUS_pa_v_pgood = IFP_hw_ctrl.pa_v_pgood;
   assign  FPGA_REG_PWR_STATUS_aisg_pgood = IFP_hw_ctrl.aisg_pgood;




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_PL_COLD_RST_cold_rst_n <= 'h1;  // 
                  FPGA_REG_PL_COLD_RST_MASK_cold_rst_n_mask <= 'h1;  // 1 = Mask cold_rst_n
                  FPGA_REG_SPI_BANK_SELECT_spi_bank_sel <= 'h0;  // 0 =  Disable SPI Access, 1 = TX DSAs 0 to 3, 2 = TX DSAs 4 to 7, 3 = ORx DSAs 0 to 3, 4 = ORx DSA 4 to 7
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac0_dl_dfe_sel <= 'h2;  // Select DL DFE stream (0 to 7) for DAC 0 (Bank228 DAC0) - DL Radio Path 1
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac1_dl_dfe_sel <= 'h1;  // Select DL DFE stream (0 to 7) for DAC 1 (Bank228 DAC1) - DL Radio Path 2
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac2_dl_dfe_sel <= 'h3;  // Select DL DFE stream (0 to 7) for DAC 2 (Bank228 DAC2) - DL Radio Path 3
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac3_dl_dfe_sel <= 'h0;  // Select DL DFE stream (0 to 7) for DAC 3 (Bank228 DAC3) - DL Radio Path 4
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac4_dl_dfe_sel <= 'h7;  // Select DL DFE stream (0 to 7) for DAC 4 (Bank229 DAC0) - DL Radio Path 5
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac5_dl_dfe_sel <= 'h4;  // Select DL DFE stream (0 to 7) for DAC 5 (Bank229 DAC1) - DL Radio Path 6
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac6_dl_dfe_sel <= 'h6;  // Select DL DFE stream (0 to 7) for DAC 6 (Bank229 DAC2) - DL Radio Path 7
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac7_dl_dfe_sel <= 'h5;  // Select DL DFE stream (0 to 7) for DAC 7 (Bank229 DAC3) - DL Radio Path 8
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx0_adc_sel <= 'h3;  // Select ADC for UL DFE0 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx1_adc_sel <= 'h1;  // Select ADC for UL DFE1 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx2_adc_sel <= 'h0;  // Select ADC for UL DFE2 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx3_adc_sel <= 'h2;  // Select ADC for UL DFE3 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx4_adc_sel <= 'h4;  // Select ADC for UL DFE4 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx5_adc_sel <= 'h6;  // Select ADC for UL DFE5 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx6_adc_sel <= 'h7;  // Select ADC for UL DFE6 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx7_adc_sel <= 'h5;  // Select ADC for UL DFE7 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx0_adc_sel <= 'h3;  // Select ADC for UL ORX0 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx1_adc_sel <= 'h1;  // Select ADC for UL ORX1 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx2_adc_sel <= 'h0;  // Select ADC for UL ORX2 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx3_adc_sel <= 'h2;  // Select ADC for UL ORX3 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx4_adc_sel <= 'h4;  // Select ADC for UL ORX4 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx5_adc_sel <= 'h6;  // Select ADC for UL ORX5 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx6_adc_sel <= 'h7;  // Select ADC for UL ORX6 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx7_adc_sel <= 'h5;  // Select ADC for UL ORX7 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_ORX_RF_SW_CTRL1_rf_switch_override <= 'h0;  // 1 = Software override for RF switches
                  FPGA_REG_ORX_RF_SW_CTRL1_orx_ant_sel <= 'h0;  // 0  = Antenna 1, 1 = Antenna 2, 2 = Antenna 3, …, 7 = Antenna 8
                  FPGA_REG_ORX_RF_SW_CTRL1_orx_path_sel <= 'h0;  // 0 = Incident (DPD), 1 = Reflected (VSWR)
                  FPGA_REG_ORX_RF_SW_CTRL2_ant_switch_delay <= 'hc8;  // Antenna switch delay for DPD and VSWR measurements, C8=200 cycles of 368.64MHz = 542ns
                  FPGA_REG_ANT_CAL_CTRL_tx_ant_cal_en <= 'h0;  // Enable TX calibration. This also controls the Tx vs. Rx switch at the antenna cal port
                  FPGA_REG_ANT_CAL_CTRL_rx_ant_cal_en <= 'h0;  // Enable RX Calibration. Tx calbration control (tx_ant_cal_en) must be low to enable RX calibration port
                  FPGA_REG_TX_GAINBLOCK_CTRL_tx_gainblock_en_n <= 'h1;  // 0 = Enable TX Gain Blocks QPA9127 and TQL9062 for all TX paths, 1 = Disable
                  FPGA_REG_RX_GAINBLOCK_CTRL_rx_gainblock_en_n <= 'h1;  // 0 = Enable RX Gain Blocks QPA9127 and QPL9097 (LNA) for all RX paths, 1 = Disable
                  FPGA_REG_LNA_CTRL_bypass_lna_0 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 0
                  FPGA_REG_LNA_CTRL_bypass_lna_1 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 1
                  FPGA_REG_LNA_CTRL_bypass_lna_2 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 2
                  FPGA_REG_LNA_CTRL_bypass_lna_3 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 3
                  FPGA_REG_LNA_CTRL_bypass_lna_4 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 4
                  FPGA_REG_LNA_CTRL_bypass_lna_5 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 5
                  FPGA_REG_LNA_CTRL_bypass_lna_6 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 6
                  FPGA_REG_LNA_CTRL_bypass_lna_7 <= 'h1;  // 1 = Bypass QPL9097 LNA on Rx Chain 7
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_0_disable <= 'h0;  // 1 = Disable PL ADCP for Rx0 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_1_disable <= 'h0;  // 1 = Disable PL ADCP for Rx1 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_2_disable <= 'h0;  // 1 = Disable PL ADCP for Rx2 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_3_disable <= 'h0;  // 1 = Disable PL ADCP for Rx3 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_4_disable <= 'h0;  // 1 = Disable PL ADCP for Rx4 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_5_disable <= 'h0;  // 1 = Disable PL ADCP for Rx5 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_6_disable <= 'h0;  // 1 = Disable PL ADCP for Rx6 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_7_disable <= 'h0;  // 1 = Disable PL ADCP for Rx7 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_0 <= 'h7f;  // Rx DSA 0 control from PS
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_1 <= 'h7f;  // Rx DSA 1 control from PS
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_2 <= 'h7f;  // Rx DSA 2 control from PS
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_3 <= 'h7f;  // Rx DSA 3 control from PS
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_4 <= 'h7f;  // Rx DSA 4 control from PS
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_5 <= 'h7f;  // Rx DSA 5 control from PS
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_6 <= 'h7f;  // Rx DSA 6 control from PS
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_7 <= 'h7f;  // Rx DSA 7 control from PS
                  FPGA_REG_PA_LNA_CTRL_pa_lna_en_1to4 <= 'h0;  // 1 = Enable PA board 1 LNA
                  FPGA_REG_PA_LNA_CTRL_pa_lna_en_5to8 <= 'h0;  // 1 = Enable PA board 2 LNA
                  FPGA_REG_PA_CONTROLLER_RESET_CTRL_pa_resetn <= 'h1;  // 0 = Reset PA controllers for both PA boards
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_1 <= 'h0;  // TDD on/off control for PA1
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_2 <= 'h0;  // TDD on/off control for PA2
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_3 <= 'h0;  // TDD on/off control for PA3
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_4 <= 'h0;  // TDD on/off control for PA4
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_5 <= 'h0;  // TDD on/off control for PA5
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_6 <= 'h0;  // TDD on/off control for PA6
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_7 <= 'h0;  // TDD on/off control for PA7
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_8 <= 'h0;  // TDD on/off control for PA8
                  FPGA_REG_AISG_PWR_CTRL_aisg_vdd_enn <= 'h1;  // 0 - Enabled, 1 - Disabled
                  FPGA_REG_AISG_PWR_CTRL_aisg_vdd_sw_enn <= 'h1;  // 0 - Enabled, 1 - Disabled
                  FPGA_REG_AISG_CTRL_aisg_uart_de_ren <= 'h0;  // 0 - Receiving, 1 - Transmitting (Driver En, Receiver En_n)
                  FPGA_REG_SFP_CTRL_sfp_tx_en_n <= 'h0;  // Active low - [0] Bit for SFP0, [1] Bit for SFP1
                  FPGA_REG_SFP_CTRL_sfp_tx_en_n_override <= 'h0;  // 0 = use internal PL logic, 1 = override internal PL logic with sfp_tx_en_n register
                  FPGA_REG_SFP_CTRL2_sfp_rs <= 'h0;  // SFP Rate Select
                  FPGA_REG_SFP_CTRL2_sfp_led <= 'h0;  // SFP LEDs
                  FPGA_REG_TRIG_CTRL_trigger <= 'h0;  // Trigger to the Maintenance Board
                  FPGA_REG_TRIG_CTRL_trigger_override <= 'h0;  // 1 = Trigger comes from the register bit, 0 = generated internally
                  FPGA_REG_1PPS_CTRL_one_pps_source <= 'h0;  // 0 = 1PPS (ONE_PPS) from Si5518, 1 = 1PPS (1PPS_IN2) from Maintenance Board (J12 Molex RF Connector)
                  FPGA_REG_HW_SCRATCH_hw_scratch <= 'h3333_ffff;  // HW scratch
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h2  : begin //'h8
                  FPGA_REG_PL_COLD_RST_cold_rst_n <= IFP_axi_rw.wdata[0];  // 
             end
      11'h3  : begin //'hC
                  FPGA_REG_PL_COLD_RST_MASK_cold_rst_n_mask <= IFP_axi_rw.wdata[0];  // 1 = Mask cold_rst_n
             end
      11'h4  : begin //'h10
                  FPGA_REG_SPI_BANK_SELECT_spi_bank_sel <= IFP_axi_rw.wdata[3:0];  // 0 =  Disable SPI Access, 1 = TX DSAs 0 to 3, 2 = TX DSAs 4 to 7, 3 = ORx DSAs 0 to 3, 4 = ORx DSA 4 to 7
             end
      11'h8  : begin //'h20
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac0_dl_dfe_sel <= IFP_axi_rw.wdata[2:0];  // Select DL DFE stream (0 to 7) for DAC 0 (Bank228 DAC0) - DL Radio Path 1
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac1_dl_dfe_sel <= IFP_axi_rw.wdata[6:4];  // Select DL DFE stream (0 to 7) for DAC 1 (Bank228 DAC1) - DL Radio Path 2
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac2_dl_dfe_sel <= IFP_axi_rw.wdata[10:8];  // Select DL DFE stream (0 to 7) for DAC 2 (Bank228 DAC2) - DL Radio Path 3
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac3_dl_dfe_sel <= IFP_axi_rw.wdata[14:12];  // Select DL DFE stream (0 to 7) for DAC 3 (Bank228 DAC3) - DL Radio Path 4
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac4_dl_dfe_sel <= IFP_axi_rw.wdata[18:16];  // Select DL DFE stream (0 to 7) for DAC 4 (Bank229 DAC0) - DL Radio Path 5
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac5_dl_dfe_sel <= IFP_axi_rw.wdata[22:20];  // Select DL DFE stream (0 to 7) for DAC 5 (Bank229 DAC1) - DL Radio Path 6
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac6_dl_dfe_sel <= IFP_axi_rw.wdata[26:24];  // Select DL DFE stream (0 to 7) for DAC 6 (Bank229 DAC2) - DL Radio Path 7
                  FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac7_dl_dfe_sel <= IFP_axi_rw.wdata[30:28];  // Select DL DFE stream (0 to 7) for DAC 7 (Bank229 DAC3) - DL Radio Path 8
             end
      11'ha  : begin //'h28
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx0_adc_sel <= IFP_axi_rw.wdata[2:0];  // Select ADC for UL DFE0 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx1_adc_sel <= IFP_axi_rw.wdata[6:4];  // Select ADC for UL DFE1 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx2_adc_sel <= IFP_axi_rw.wdata[10:8];  // Select ADC for UL DFE2 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx3_adc_sel <= IFP_axi_rw.wdata[14:12];  // Select ADC for UL DFE3 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx4_adc_sel <= IFP_axi_rw.wdata[18:16];  // Select ADC for UL DFE4 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx5_adc_sel <= IFP_axi_rw.wdata[22:20];  // Select ADC for UL DFE5 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx6_adc_sel <= IFP_axi_rw.wdata[26:24];  // Select ADC for UL DFE6 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx7_adc_sel <= IFP_axi_rw.wdata[30:28];  // Select ADC for UL DFE7 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
             end
      11'hc  : begin //'h30
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx0_adc_sel <= IFP_axi_rw.wdata[2:0];  // Select ADC for UL ORX0 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx1_adc_sel <= IFP_axi_rw.wdata[6:4];  // Select ADC for UL ORX1 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx2_adc_sel <= IFP_axi_rw.wdata[10:8];  // Select ADC for UL ORX2 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx3_adc_sel <= IFP_axi_rw.wdata[14:12];  // Select ADC for UL ORX3 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx4_adc_sel <= IFP_axi_rw.wdata[18:16];  // Select ADC for UL ORX4 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx5_adc_sel <= IFP_axi_rw.wdata[22:20];  // Select ADC for UL ORX5 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx6_adc_sel <= IFP_axi_rw.wdata[26:24];  // Select ADC for UL ORX6 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                  FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx7_adc_sel <= IFP_axi_rw.wdata[30:28];  // Select ADC for UL ORX7 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
             end
      11'h40  : begin //'h100
                  FPGA_REG_ORX_RF_SW_CTRL1_rf_switch_override <= IFP_axi_rw.wdata[0];  // 1 = Software override for RF switches
                  FPGA_REG_ORX_RF_SW_CTRL1_orx_ant_sel <= IFP_axi_rw.wdata[10:8];  // 0  = Antenna 1, 1 = Antenna 2, 2 = Antenna 3, …, 7 = Antenna 8
                  FPGA_REG_ORX_RF_SW_CTRL1_orx_path_sel <= IFP_axi_rw.wdata[11];  // 0 = Incident (DPD), 1 = Reflected (VSWR)
             end
      11'h41  : begin //'h104
                  FPGA_REG_ORX_RF_SW_CTRL2_ant_switch_delay <= IFP_axi_rw.wdata[15:0];  // Antenna switch delay for DPD and VSWR measurements, C8=200 cycles of 368.64MHz = 542ns
             end
      11'h44  : begin //'h110
                  FPGA_REG_ANT_CAL_CTRL_tx_ant_cal_en <= IFP_axi_rw.wdata[0];  // Enable TX calibration. This also controls the Tx vs. Rx switch at the antenna cal port
                  FPGA_REG_ANT_CAL_CTRL_rx_ant_cal_en <= IFP_axi_rw.wdata[8];  // Enable RX Calibration. Tx calbration control (tx_ant_cal_en) must be low to enable RX calibration port
             end
      11'h48  : begin //'h120
                  FPGA_REG_TX_GAINBLOCK_CTRL_tx_gainblock_en_n <= IFP_axi_rw.wdata[0];  // 0 = Enable TX Gain Blocks QPA9127 and TQL9062 for all TX paths, 1 = Disable
             end
      11'h49  : begin //'h124
                  FPGA_REG_RX_GAINBLOCK_CTRL_rx_gainblock_en_n <= IFP_axi_rw.wdata[0];  // 0 = Enable RX Gain Blocks QPA9127 and QPL9097 (LNA) for all RX paths, 1 = Disable
             end
      11'h4a  : begin //'h128
                  FPGA_REG_LNA_CTRL_bypass_lna_0 <= IFP_axi_rw.wdata[0];  // 1 = Bypass QPL9097 LNA on Rx Chain 0
                  FPGA_REG_LNA_CTRL_bypass_lna_1 <= IFP_axi_rw.wdata[1];  // 1 = Bypass QPL9097 LNA on Rx Chain 1
                  FPGA_REG_LNA_CTRL_bypass_lna_2 <= IFP_axi_rw.wdata[2];  // 1 = Bypass QPL9097 LNA on Rx Chain 2
                  FPGA_REG_LNA_CTRL_bypass_lna_3 <= IFP_axi_rw.wdata[3];  // 1 = Bypass QPL9097 LNA on Rx Chain 3
                  FPGA_REG_LNA_CTRL_bypass_lna_4 <= IFP_axi_rw.wdata[4];  // 1 = Bypass QPL9097 LNA on Rx Chain 4
                  FPGA_REG_LNA_CTRL_bypass_lna_5 <= IFP_axi_rw.wdata[5];  // 1 = Bypass QPL9097 LNA on Rx Chain 5
                  FPGA_REG_LNA_CTRL_bypass_lna_6 <= IFP_axi_rw.wdata[6];  // 1 = Bypass QPL9097 LNA on Rx Chain 6
                  FPGA_REG_LNA_CTRL_bypass_lna_7 <= IFP_axi_rw.wdata[7];  // 1 = Bypass QPL9097 LNA on Rx Chain 7
             end
      11'h4b  : begin //'h12C
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_0_disable <= IFP_axi_rw.wdata[0];  // 1 = Disable PL ADCP for Rx0 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_1_disable <= IFP_axi_rw.wdata[1];  // 1 = Disable PL ADCP for Rx1 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_2_disable <= IFP_axi_rw.wdata[2];  // 1 = Disable PL ADCP for Rx2 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_3_disable <= IFP_axi_rw.wdata[3];  // 1 = Disable PL ADCP for Rx3 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_4_disable <= IFP_axi_rw.wdata[4];  // 1 = Disable PL ADCP for Rx4 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_5_disable <= IFP_axi_rw.wdata[5];  // 1 = Disable PL ADCP for Rx5 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_6_disable <= IFP_axi_rw.wdata[6];  // 1 = Disable PL ADCP for Rx6 - Only prevents PL from responding to overvoltage and overrange
                  FPGA_REG_PL_ADCP_CTRL_pl_adcp_7_disable <= IFP_axi_rw.wdata[7];  // 1 = Disable PL ADCP for Rx7 - Only prevents PL from responding to overvoltage and overrange
             end
      11'h4c  : begin //'h130
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_0 <= IFP_axi_rw.wdata[6:0];  // Rx DSA 0 control from PS
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_1 <= IFP_axi_rw.wdata[14:8];  // Rx DSA 1 control from PS
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_2 <= IFP_axi_rw.wdata[22:16];  // Rx DSA 2 control from PS
                  FPGA_REG_PS_DSA_CTRL_ps_rxdsa_3 <= IFP_axi_rw.wdata[30:24];  // Rx DSA 3 control from PS
             end
      11'h4d  : begin //'h134
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_4 <= IFP_axi_rw.wdata[6:0];  // Rx DSA 4 control from PS
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_5 <= IFP_axi_rw.wdata[14:8];  // Rx DSA 5 control from PS
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_6 <= IFP_axi_rw.wdata[22:16];  // Rx DSA 6 control from PS
                  FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_7 <= IFP_axi_rw.wdata[30:24];  // Rx DSA 7 control from PS
             end
      11'h80  : begin //'h200
                  FPGA_REG_PA_LNA_CTRL_pa_lna_en_1to4 <= IFP_axi_rw.wdata[0];  // 1 = Enable PA board 1 LNA
                  FPGA_REG_PA_LNA_CTRL_pa_lna_en_5to8 <= IFP_axi_rw.wdata[0];  // 1 = Enable PA board 2 LNA
             end
      11'h81  : begin //'h204
                  FPGA_REG_PA_CONTROLLER_RESET_CTRL_pa_resetn <= IFP_axi_rw.wdata[0];  // 0 = Reset PA controllers for both PA boards
             end
      11'h82  : begin //'h208
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_1 <= IFP_axi_rw.wdata[0];  // TDD on/off control for PA1
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_2 <= IFP_axi_rw.wdata[1];  // TDD on/off control for PA2
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_3 <= IFP_axi_rw.wdata[2];  // TDD on/off control for PA3
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_4 <= IFP_axi_rw.wdata[3];  // TDD on/off control for PA4
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_5 <= IFP_axi_rw.wdata[4];  // TDD on/off control for PA5
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_6 <= IFP_axi_rw.wdata[5];  // TDD on/off control for PA6
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_7 <= IFP_axi_rw.wdata[6];  // TDD on/off control for PA7
                  FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_8 <= IFP_axi_rw.wdata[7];  // TDD on/off control for PA8
             end
      11'hc1  : begin //'h304
                  FPGA_REG_AISG_PWR_CTRL_aisg_vdd_enn <= IFP_axi_rw.wdata[0];  // 0 - Enabled, 1 - Disabled
                  FPGA_REG_AISG_PWR_CTRL_aisg_vdd_sw_enn <= IFP_axi_rw.wdata[1];  // 0 - Enabled, 1 - Disabled
             end
      11'hc2  : begin //'h308
                  FPGA_REG_AISG_CTRL_aisg_uart_de_ren <= IFP_axi_rw.wdata[0];  // 0 - Receiving, 1 - Transmitting (Driver En, Receiver En_n)
             end
      11'hc3  : begin //'h30C
                  FPGA_REG_SFP_CTRL_sfp_tx_en_n <= IFP_axi_rw.wdata[1:0];  // Active low - [0] Bit for SFP0, [1] Bit for SFP1
                  FPGA_REG_SFP_CTRL_sfp_tx_en_n_override <= IFP_axi_rw.wdata[17:16];  // 0 = use internal PL logic, 1 = override internal PL logic with sfp_tx_en_n register
             end
      11'hc4  : begin //'h310
                  FPGA_REG_SFP_CTRL2_sfp_rs <= IFP_axi_rw.wdata[1:0];  // SFP Rate Select
                  FPGA_REG_SFP_CTRL2_sfp_led <= IFP_axi_rw.wdata[3:2];  // SFP LEDs
             end
      11'hc5  : begin //'h314
                  FPGA_REG_TRIG_CTRL_trigger <= IFP_axi_rw.wdata[0];  // Trigger to the Maintenance Board
                  FPGA_REG_TRIG_CTRL_trigger_override <= IFP_axi_rw.wdata[16];  // 1 = Trigger comes from the register bit, 0 = generated internally
             end
      11'hc6  : begin //'h318
                  FPGA_REG_1PPS_CTRL_one_pps_source <= IFP_axi_rw.wdata[0];  // 0 = 1PPS (ONE_PPS) from Si5518, 1 = 1PPS (1PPS_IN2) from Maintenance Board (J12 Molex RF Connector)
             end
      11'h7ff  : begin //'h1FFC
                  FPGA_REG_HW_SCRATCH_hw_scratch <= IFP_axi_rw.wdata[31:0];  // HW scratch
               end
      endcase
    end
  end
///////////////////////////////////////////////



///////////////////READ LOGIC ////////////////
  always @(*) begin
    IFP_axi_rw.rdata = 0;
    if (IFP_axi_rw.rden) begin
       case(IFP_axi_rw.rd_offset)
      11'h2  : begin//'h8
                   IFP_axi_rw.rdata[0] = FPGA_REG_PL_COLD_RST_cold_rst_n;  // 
             end
      11'h3  : begin//'hC
                   IFP_axi_rw.rdata[0] = FPGA_REG_PL_COLD_RST_MASK_cold_rst_n_mask;  // 1 = Mask cold_rst_n
             end
      11'h4  : begin//'h10
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_SPI_BANK_SELECT_spi_bank_sel;  // 0 =  Disable SPI Access, 1 = TX DSAs 0 to 3, 2 = TX DSAs 4 to 7, 3 = ORx DSAs 0 to 3, 4 = ORx DSA 4 to 7
             end
      11'h8  : begin//'h20
                   IFP_axi_rw.rdata[2:0] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac0_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 0 (Bank228 DAC0) - DL Radio Path 1
                   IFP_axi_rw.rdata[6:4] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac1_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 1 (Bank228 DAC1) - DL Radio Path 2
                   IFP_axi_rw.rdata[10:8] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac2_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 2 (Bank228 DAC2) - DL Radio Path 3
                   IFP_axi_rw.rdata[14:12] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac3_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 3 (Bank228 DAC3) - DL Radio Path 4
                   IFP_axi_rw.rdata[18:16] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac4_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 4 (Bank229 DAC0) - DL Radio Path 5
                   IFP_axi_rw.rdata[22:20] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac5_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 5 (Bank229 DAC1) - DL Radio Path 6
                   IFP_axi_rw.rdata[26:24] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac6_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 6 (Bank229 DAC2) - DL Radio Path 7
                   IFP_axi_rw.rdata[30:28] = FPGA_REG_DL_DFE_RADIO_PATH_MAP_dac7_dl_dfe_sel;  // Select DL DFE stream (0 to 7) for DAC 7 (Bank229 DAC3) - DL Radio Path 8
             end
      11'ha  : begin//'h28
                   IFP_axi_rw.rdata[2:0] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx0_adc_sel;  // Select ADC for UL DFE0 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[6:4] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx1_adc_sel;  // Select ADC for UL DFE1 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[10:8] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx2_adc_sel;  // Select ADC for UL DFE2 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[14:12] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx3_adc_sel;  // Select ADC for UL DFE3 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[18:16] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx4_adc_sel;  // Select ADC for UL DFE4 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[22:20] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx5_adc_sel;  // Select ADC for UL DFE5 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[26:24] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx6_adc_sel;  // Select ADC for UL DFE6 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[30:28] = FPGA_REG_UL_DFE_RADIO_PATH_MAP_ul_dfe_rx7_adc_sel;  // Select ADC for UL DFE7 RX. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
             end
      11'hc  : begin//'h30
                   IFP_axi_rw.rdata[2:0] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx0_adc_sel;  // Select ADC for UL ORX0 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[6:4] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx1_adc_sel;  // Select ADC for UL ORX1 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[10:8] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx2_adc_sel;  // Select ADC for UL ORX2 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[14:12] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx3_adc_sel;  // Select ADC for UL ORX3 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[18:16] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx4_adc_sel;  // Select ADC for UL ORX4 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[22:20] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx5_adc_sel;  // Select ADC for UL ORX5 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[26:24] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx6_adc_sel;  // Select ADC for UL ORX6 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
                   IFP_axi_rw.rdata[30:28] = FPGA_REG_UL_ORX_RADIO_PATH_MAP_ul_dfe_orx7_adc_sel;  // Select ADC for UL ORX7 stream. 0=ADC0 (Bank224 ADC01), 1=ADC1 (Bank224 ADC23), 2=ADC2 (Bank225 ADC01) ...
             end
      11'h40  : begin//'h100
                   IFP_axi_rw.rdata[0] = FPGA_REG_ORX_RF_SW_CTRL1_rf_switch_override;  // 1 = Software override for RF switches
                   IFP_axi_rw.rdata[10:8] = FPGA_REG_ORX_RF_SW_CTRL1_orx_ant_sel;  // 0  = Antenna 1, 1 = Antenna 2, 2 = Antenna 3, …, 7 = Antenna 8
                   IFP_axi_rw.rdata[11] = FPGA_REG_ORX_RF_SW_CTRL1_orx_path_sel;  // 0 = Incident (DPD), 1 = Reflected (VSWR)
             end
      11'h41  : begin//'h104
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_ORX_RF_SW_CTRL2_ant_switch_delay;  // Antenna switch delay for DPD and VSWR measurements, C8=200 cycles of 368.64MHz = 542ns
             end
      11'h44  : begin//'h110
                   IFP_axi_rw.rdata[0] = FPGA_REG_ANT_CAL_CTRL_tx_ant_cal_en;  // Enable TX calibration. This also controls the Tx vs. Rx switch at the antenna cal port
                   IFP_axi_rw.rdata[8] = FPGA_REG_ANT_CAL_CTRL_rx_ant_cal_en;  // Enable RX Calibration. Tx calbration control (tx_ant_cal_en) must be low to enable RX calibration port
             end
      11'h48  : begin//'h120
                   IFP_axi_rw.rdata[0] = FPGA_REG_TX_GAINBLOCK_CTRL_tx_gainblock_en_n;  // 0 = Enable TX Gain Blocks QPA9127 and TQL9062 for all TX paths, 1 = Disable
             end
      11'h49  : begin//'h124
                   IFP_axi_rw.rdata[0] = FPGA_REG_RX_GAINBLOCK_CTRL_rx_gainblock_en_n;  // 0 = Enable RX Gain Blocks QPA9127 and QPL9097 (LNA) for all RX paths, 1 = Disable
             end
      11'h4a  : begin//'h128
                   IFP_axi_rw.rdata[0] = FPGA_REG_LNA_CTRL_bypass_lna_0;  // 1 = Bypass QPL9097 LNA on Rx Chain 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_LNA_CTRL_bypass_lna_1;  // 1 = Bypass QPL9097 LNA on Rx Chain 1
                   IFP_axi_rw.rdata[2] = FPGA_REG_LNA_CTRL_bypass_lna_2;  // 1 = Bypass QPL9097 LNA on Rx Chain 2
                   IFP_axi_rw.rdata[3] = FPGA_REG_LNA_CTRL_bypass_lna_3;  // 1 = Bypass QPL9097 LNA on Rx Chain 3
                   IFP_axi_rw.rdata[4] = FPGA_REG_LNA_CTRL_bypass_lna_4;  // 1 = Bypass QPL9097 LNA on Rx Chain 4
                   IFP_axi_rw.rdata[5] = FPGA_REG_LNA_CTRL_bypass_lna_5;  // 1 = Bypass QPL9097 LNA on Rx Chain 5
                   IFP_axi_rw.rdata[6] = FPGA_REG_LNA_CTRL_bypass_lna_6;  // 1 = Bypass QPL9097 LNA on Rx Chain 6
                   IFP_axi_rw.rdata[7] = FPGA_REG_LNA_CTRL_bypass_lna_7;  // 1 = Bypass QPL9097 LNA on Rx Chain 7
             end
      11'h4b  : begin//'h12C
                   IFP_axi_rw.rdata[0] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_0_disable;  // 1 = Disable PL ADCP for Rx0 - Only prevents PL from responding to overvoltage and overrange
                   IFP_axi_rw.rdata[1] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_1_disable;  // 1 = Disable PL ADCP for Rx1 - Only prevents PL from responding to overvoltage and overrange
                   IFP_axi_rw.rdata[2] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_2_disable;  // 1 = Disable PL ADCP for Rx2 - Only prevents PL from responding to overvoltage and overrange
                   IFP_axi_rw.rdata[3] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_3_disable;  // 1 = Disable PL ADCP for Rx3 - Only prevents PL from responding to overvoltage and overrange
                   IFP_axi_rw.rdata[4] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_4_disable;  // 1 = Disable PL ADCP for Rx4 - Only prevents PL from responding to overvoltage and overrange
                   IFP_axi_rw.rdata[5] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_5_disable;  // 1 = Disable PL ADCP for Rx5 - Only prevents PL from responding to overvoltage and overrange
                   IFP_axi_rw.rdata[6] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_6_disable;  // 1 = Disable PL ADCP for Rx6 - Only prevents PL from responding to overvoltage and overrange
                   IFP_axi_rw.rdata[7] = FPGA_REG_PL_ADCP_CTRL_pl_adcp_7_disable;  // 1 = Disable PL ADCP for Rx7 - Only prevents PL from responding to overvoltage and overrange
             end
      11'h4c  : begin//'h130
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_PS_DSA_CTRL_ps_rxdsa_0;  // Rx DSA 0 control from PS
                   IFP_axi_rw.rdata[14:8] = FPGA_REG_PS_DSA_CTRL_ps_rxdsa_1;  // Rx DSA 1 control from PS
                   IFP_axi_rw.rdata[22:16] = FPGA_REG_PS_DSA_CTRL_ps_rxdsa_2;  // Rx DSA 2 control from PS
                   IFP_axi_rw.rdata[30:24] = FPGA_REG_PS_DSA_CTRL_ps_rxdsa_3;  // Rx DSA 3 control from PS
             end
      11'h4d  : begin//'h134
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_4;  // Rx DSA 4 control from PS
                   IFP_axi_rw.rdata[14:8] = FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_5;  // Rx DSA 5 control from PS
                   IFP_axi_rw.rdata[22:16] = FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_6;  // Rx DSA 6 control from PS
                   IFP_axi_rw.rdata[30:24] = FPGA_REG_PS_DSA_CTRL2_ps_rxdsa_7;  // Rx DSA 7 control from PS
             end
      11'h4e  : begin//'h138
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_PL_DSA_CTRL_pl_rxdsa_0;  // Actual control applied to Rx DSA 0 from PL (Read Only)
                   IFP_axi_rw.rdata[14:8] = FPGA_REG_PL_DSA_CTRL_pl_rxdsa_1;  // Actual control applied to Rx DSA 1 from PL (Read Only)
                   IFP_axi_rw.rdata[22:16] = FPGA_REG_PL_DSA_CTRL_pl_rxdsa_2;  // Actual control applied to Rx DSA 2 from PL (Read Only)
                   IFP_axi_rw.rdata[30:24] = FPGA_REG_PL_DSA_CTRL_pl_rxdsa_3;  // Actual control applied to Rx DSA 3 from PL (Read Only)
             end
      11'h4f  : begin//'h13C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_4;  // Actual control applied to Rx DSA 4 from PL (Read Only)
                   IFP_axi_rw.rdata[14:8] = FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_5;  // Actual control applied to Rx DSA 5 from PL (Read Only)
                   IFP_axi_rw.rdata[22:16] = FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_6;  // Actual control applied to Rx DSA 6 from PL (Read Only)
                   IFP_axi_rw.rdata[30:24] = FPGA_REG_PL_DSA_CTRL2_pl_rxdsa_7;  // Actual control applied to Rx DSA 7 from PL (Read Only)
             end
      11'h80  : begin//'h200
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_LNA_CTRL_pa_lna_en_1to4;  // 1 = Enable PA board 1 LNA
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_LNA_CTRL_pa_lna_en_5to8;  // 1 = Enable PA board 2 LNA
             end
      11'h81  : begin//'h204
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_CONTROLLER_RESET_CTRL_pa_resetn;  // 0 = Reset PA controllers for both PA boards
             end
      11'h82  : begin//'h208
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_1;  // TDD on/off control for PA1
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_2;  // TDD on/off control for PA2
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_3;  // TDD on/off control for PA3
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_4;  // TDD on/off control for PA4
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_5;  // TDD on/off control for PA5
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_6;  // TDD on/off control for PA6
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_7;  // TDD on/off control for PA7
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_CONTROLLER_TDD_CTRL_tdd_ctrl_pa_8;  // TDD on/off control for PA8
             end
      11'hc0  : begin//'h300
                   IFP_axi_rw.rdata[7:0] = FPGA_REG_PWR_STATUS_pa_v_pgood;  // PA_V Power Good
                   IFP_axi_rw.rdata[8] = FPGA_REG_PWR_STATUS_aisg_pgood;  // Power Good.  Signal is pulled up on schematic
             end
      11'hc1  : begin//'h304
                   IFP_axi_rw.rdata[0] = FPGA_REG_AISG_PWR_CTRL_aisg_vdd_enn;  // 0 - Enabled, 1 - Disabled
                   IFP_axi_rw.rdata[1] = FPGA_REG_AISG_PWR_CTRL_aisg_vdd_sw_enn;  // 0 - Enabled, 1 - Disabled
             end
      11'hc2  : begin//'h308
                   IFP_axi_rw.rdata[0] = FPGA_REG_AISG_CTRL_aisg_uart_de_ren;  // 0 - Receiving, 1 - Transmitting (Driver En, Receiver En_n)
             end
      11'hc3  : begin//'h30C
                   IFP_axi_rw.rdata[1:0] = FPGA_REG_SFP_CTRL_sfp_tx_en_n;  // Active low - [0] Bit for SFP0, [1] Bit for SFP1
                   IFP_axi_rw.rdata[17:16] = FPGA_REG_SFP_CTRL_sfp_tx_en_n_override;  // 0 = use internal PL logic, 1 = override internal PL logic with sfp_tx_en_n register
             end
      11'hc4  : begin//'h310
                   IFP_axi_rw.rdata[1:0] = FPGA_REG_SFP_CTRL2_sfp_rs;  // SFP Rate Select
                   IFP_axi_rw.rdata[3:2] = FPGA_REG_SFP_CTRL2_sfp_led;  // SFP LEDs
             end
      11'hc5  : begin//'h314
                   IFP_axi_rw.rdata[0] = FPGA_REG_TRIG_CTRL_trigger;  // Trigger to the Maintenance Board
                   IFP_axi_rw.rdata[16] = FPGA_REG_TRIG_CTRL_trigger_override;  // 1 = Trigger comes from the register bit, 0 = generated internally
             end
      11'hc6  : begin//'h318
                   IFP_axi_rw.rdata[0] = FPGA_REG_1PPS_CTRL_one_pps_source;  // 0 = 1PPS (ONE_PPS) from Si5518, 1 = 1PPS (1PPS_IN2) from Maintenance Board (J12 Molex RF Connector)
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_HW_SCRATCH_hw_scratch;  // HW scratch
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule