// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 3007216                                                     // 
// Date         : 05/14/21                                                    // 
// File         : jb_test_regs.sv                                             // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 

module jb_test_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_test_ctrl_if.ctrl         IFP_test_ctrl
);



////////////////Register Field Declarations//////////////////

   logic                     FPGA_REG_RFBUF_CFG0_rfbuf_trig_align_en;
  // Not for software use. Enable alignment of trigger with PTP marker
   logic  [19:0]              FPGA_REG_RFBUF_CFG_rfbuf_num_samples;
  // Number of samples to be written or read from the Debug buffer
   logic                     FPGA_REG_RFBUF_CFG_rfbuf_mode;
  // 1: Continuous mode, 0: Single shot
   logic  [2:0]              FPGA_REG_RFBUF_CFG_rfbuf_path_select;
  // 3'b000: Test mode disable (normal operation), 3'b001: dbgbuf_to_dac, 3'b010: dldfe_to_dbgbuf, 3'b011:adc_to_dbgbuf, 3'b100: dbgbuf_to_uldfe, 3'b101 to 3'b111 : reserved
   logic                     FPGA_REG_RFBUF_TRIGGER_rfbuf_trigger;
  // 1: Start the test with the testpath defined by test_path_select defined in DFE_ADCDAC_TEST_CFG  Register. In single shot mode,  to trigger it for subsequent test, write 0 and then write 1, A rising edge is on this bit is used for triggering the test.
   logic                     FPGA_REG_RFBUF_RESET_rfbuf_reset;
  // 1: Reset the test, This bit can be used to reset the State machine when it is in continuous mode. It has to be set back to 0 to restart the test again
   logic                     FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_uldfe_to_dldfe_lpbk;
  // 1: route UL DFE output to DL DFE input
   logic                     FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_uldfe_to_dldfe_lpbk;
  // 1: route UL DFE output to DL DFE input
   logic  [1:0]              FPGA_REG_CPRI_DFE_TEST_CFG_fh_dbg_mode;
  // 2'b00: Normal operation, 2'b01: Drive data from dbg Buffer,  2'b10: lphy Dl to lphy UL, 2'b11: Reserved
   logic                     FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_orx_to_uldfe_en;
  // 1: Route Orx Path to RX DFE Path
   logic                     FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_rx0_to_all_ul_paths;
  // 1: Route Orx Path to RX DFE Path
   logic                     FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_orx_to_uldfe_en;
  // 1: Route Orx Path to RX DFE Path
   logic                     FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_rx0_to_all_ul_paths;
  // 1: Route Orx Path to RX DFE Path
   logic  [4:0]              FPGA_REG_CPRI_DFE_TEST_CFG_rx_antenna_dgb_sel;
  // 0x0: Rx Ant0 , 0x1: Rx Ant1, 0x2: Rx Ant2, 0x3: Rx Ant3, 0x4: Rx Ant4 , 0x5: Rx Ant5, 0x6: Rx Ant6, 0x7: Rx Ant70x10: ORx Ant0, 0x11: ORx Ant1, 0x12: ORx Ant2, 0x13: ORx Ant3,0x14: ORx Ant4, 0x15: ORx Ant5, 0x16: ORx Ant6, 0x17: ORx Ant7
   logic                     FPGA_REG_UL_TEST_CFG_adc_invert_q;
  // 1: Invert Q on UL Path at ADC output, 
   logic  [19:0]              FPGA_REG_FHBUF_CFG_fhbuf_num_samples;
  // Number of samples to be driven at DL DFE input, Currently FH BUffer is 128KBytes, Bits [14:0] are valid, Maximum number of samples is 30720.
   logic  [1:0]              FPGA_REG_FHBUF_CFG_fhbuf_ants_sel;
  // 0 = first four ants, 1 = last four ants
   logic                     FPGA_REG_FHBUF_CFG_fhbuf_store_en;
  // 1. Store the Data into Buffer, 0:Load the Data from the Buffer (Buffer as a waveform generator)
   logic                     FPGA_REG_FHBUF_CFG_fhbuf_mode;
  // 1: Continuous mode, 0: Single shot
   logic                     FPGA_REG_FHBUF_CFG_fhbuf_en;
  // 1: Enable the test mode
   logic                     FPGA_REG_FHBUF_TRIGGER_fhbuf_trigger;
  // 1: Start driving the data into DL DFE chain
   logic  [31:0]              FPGA_REG_DL_ANT0_TSSI_ant0_tssi;
  // Antenna 0 Path TSSI
   logic  [31:0]              FPGA_REG_DL_ANT1_TSSI_ant1_tssi;
  // Antenna 1 Path TSSI
   logic  [31:0]              FPGA_REG_DL_ANT2_TSSI_ant2_tssi;
  // Antenna 2 Path TSSI
   logic  [31:0]              FPGA_REG_DL_ANT3_TSSI_ant3_tssi;
  // Antenna 3 Path TSSI
   logic  [31:0]              FPGA_REG_DL_ANT4_TSSI_ant4_tssi;
  // Antenna 4 Path TSSI
   logic  [31:0]              FPGA_REG_DL_ANT5_TSSI_ant5_tssi;
  // Antenna 5 Path TSSI
   logic  [31:0]              FPGA_REG_DL_ANT6_TSSI_ant6_tssi;
  // Antenna 6 Path TSSI
   logic  [31:0]              FPGA_REG_DL_ANT7_TSSI_ant7_tssi;
  // Antenna 7 Path TSSI
   logic  [31:0]              FPGA_REG_UL_ANT0_WRSSI_CFG_ul_ant0_wrssi;
  // Antenna 0 Path wrssi 
   logic  [31:0]              FPGA_REG_UL_ANT1_WRSSI_CFG_ul_ant1_wrssi;
  // Antenna 1 Path wrssi 
   logic  [31:0]              FPGA_REG_UL_ANT2_WRSSI_CFG_ul_ant2_wrssi;
  // Antenna 2 Path wrssi 
   logic  [31:0]              FPGA_REG_UL_ANT3_WRSSI_CFG_ul_ant3_wrssi;
  // Antenna 3 Path wrssi 
   logic  [31:0]              FPGA_REG_UL_ANT4_WRSSI_CFG_ul_ant4_wrssi;
  // Antenna 4 Path wrssi 
   logic  [31:0]              FPGA_REG_UL_ANT5_WRSSI_CFG_ul_ant5_wrssi;
  // Antenna 5 Path wrssi 
   logic  [31:0]              FPGA_REG_UL_ANT6_WRSSI_CFG_ul_ant6_wrssi;
  // Antenna 6 Path wrssi 
   logic  [31:0]              FPGA_REG_UL_ANT7_WRSSI_CFG_ul_ant7_wrssi;
  // Antenna 7 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX0_WRSSI_orx0_wrssi;
  // Observation Path Antenna 0 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX1_WRSSI_orx1_wrssi;
  // Observation Path Antenna 1 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX2_WRSSI_orx2_wrssi;
  // Observation Path Antenna 2 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX3_WRSSI_orx3_wrssi;
  // Observation Path Antenna 3 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX4_WRSSI_orx4_wrssi;
  // Observation Path Antenna 4 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX5_WRSSI_orx5_wrssi;
  // Observation Path Antenna 5 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX6_WRSSI_orx6_wrssi;
  // Observation Path Antenna 6 Path wrssi 
   logic  [31:0]              FPGA_REG_ORX7_WRSSI_orx7_wrssi;
  // Observation Path Antenna 7 Path wrssi 
   logic  [31:0]              FPGA_REG_DEBUG_RW_0_debug_rw_0;
  // Temporary. Not for software. Debug RW Register.  Bit0 to send pa_odp_tssi to ant_tssi. Bit4-7 to insert pa_odp_tssi from debug_rw_1-4 regs
   logic  [31:0]              FPGA_REG_DEBUG_RW_1_debug_rw_1;
  // Temporary. Not for software. Debug RW Register. PA_ODP_TSSI on selected antennas
   logic  [31:0]              FPGA_REG_DEBUG_RW_2_debug_rw_2;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_3_debug_rw_3;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_4_debug_rw_4;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_5_debug_rw_5;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_6_debug_rw_6;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_7_debug_rw_7;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_0_debug_ro_0;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_1_debug_ro_1;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_2_debug_ro_2;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_3_debug_ro_3;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_4_debug_ro_4;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_5_debug_ro_5;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_6_debug_ro_6;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_DEBUG_RO_7_debug_ro_7;
  // Temporary. Not for software. Debug Read-Only Register
   logic  [31:0]              FPGA_REG_VIO_CONFIG_UL_vio_config_ul;
  // Temporary. Not for software
   logic  [31:0]              FPGA_REG_VIO_CONFIG_DL_vio_config_dl;
  // Temporary. Not for software
   logic  [31:0]              FPGA_REG_ILA_CONFIG_ADC_ila_config_adc;
  // Temporary. Not for software
   logic  [31:0]              FPGA_REG_ILA_CONFIG_DAC_ila_config_dac;
  // Temporary. Not for software
   logic  [31:0]              FPGA_REG_DBG_SCRATCH_dbg_scratch;
  // 








////////////////ASSIGN PARAMETERS//////////////////





////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_test_ctrl.rfbuf_trig_align_en =  FPGA_REG_RFBUF_CFG0_rfbuf_trig_align_en;
   assign  IFP_test_ctrl.dfe_adcdac_test_num_samples =  FPGA_REG_RFBUF_CFG_rfbuf_num_samples;
   assign  IFP_test_ctrl.dfe_adcdac_test_mode =  FPGA_REG_RFBUF_CFG_rfbuf_mode;
   assign  IFP_test_ctrl.dfe_adcdac_test_path_select =  FPGA_REG_RFBUF_CFG_rfbuf_path_select;
   assign  IFP_test_ctrl.dfe_adcdac_test_trigger =  FPGA_REG_RFBUF_TRIGGER_rfbuf_trigger;
   assign  IFP_test_ctrl.dfe_adcdac_test_reset =  FPGA_REG_RFBUF_RESET_rfbuf_reset;
   assign  IFP_test_ctrl.uldfe_to_dldfe_lpbk[0] =  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_uldfe_to_dldfe_lpbk;
   assign  IFP_test_ctrl.uldfe_to_dldfe_lpbk[1] =  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_uldfe_to_dldfe_lpbk;
   assign  IFP_test_ctrl.fh_dbg_mode =  FPGA_REG_CPRI_DFE_TEST_CFG_fh_dbg_mode;
   assign  IFP_test_ctrl.orx_to_uldfe_en[0] =  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_orx_to_uldfe_en;
   assign  IFP_test_ctrl.rx0_to_all_ul_paths[0] =  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_rx0_to_all_ul_paths;
   assign  IFP_test_ctrl.orx_to_uldfe_en[1] =  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_orx_to_uldfe_en;
   assign  IFP_test_ctrl.rx0_to_all_ul_paths[1] =  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_rx0_to_all_ul_paths;
   assign  IFP_test_ctrl.rx_antenna_dgb_sel =  FPGA_REG_CPRI_DFE_TEST_CFG_rx_antenna_dgb_sel;
   assign  IFP_test_ctrl.adc_invert_q =  FPGA_REG_UL_TEST_CFG_adc_invert_q;
   assign  IFP_test_ctrl.dl_test_mode_num_samples =  FPGA_REG_FHBUF_CFG_fhbuf_num_samples;
   assign  IFP_test_ctrl.dl_test_ants_sel =  FPGA_REG_FHBUF_CFG_fhbuf_ants_sel;
   assign  IFP_test_ctrl.dl_test_store_en =  FPGA_REG_FHBUF_CFG_fhbuf_store_en;
   assign  IFP_test_ctrl.dl_test_mode =  FPGA_REG_FHBUF_CFG_fhbuf_mode;
   assign  IFP_test_ctrl.dl_test_mode_en =  FPGA_REG_FHBUF_CFG_fhbuf_en;
   assign  IFP_test_ctrl.dl_test_mode_trigger =  FPGA_REG_FHBUF_TRIGGER_fhbuf_trigger;
   assign  IFP_test_ctrl.debug_rw[0] =  FPGA_REG_DEBUG_RW_0_debug_rw_0;
   assign  IFP_test_ctrl.debug_rw[1] =  FPGA_REG_DEBUG_RW_1_debug_rw_1;
   assign  IFP_test_ctrl.debug_rw[2] =  FPGA_REG_DEBUG_RW_2_debug_rw_2;
   assign  IFP_test_ctrl.debug_rw[3] =  FPGA_REG_DEBUG_RW_3_debug_rw_3;
   assign  IFP_test_ctrl.debug_rw[4] =  FPGA_REG_DEBUG_RW_4_debug_rw_4;
   assign  IFP_test_ctrl.debug_rw[5] =  FPGA_REG_DEBUG_RW_5_debug_rw_5;
   assign  IFP_test_ctrl.debug_rw[6] =  FPGA_REG_DEBUG_RW_6_debug_rw_6;
   assign  IFP_test_ctrl.debug_rw[7] =  FPGA_REG_DEBUG_RW_7_debug_rw_7;
   assign  IFP_test_ctrl.vio_config_ul =  FPGA_REG_VIO_CONFIG_UL_vio_config_ul;
   assign  IFP_test_ctrl.vio_config_dl =  FPGA_REG_VIO_CONFIG_DL_vio_config_dl;
   assign  IFP_test_ctrl.ila_config_adc =  FPGA_REG_ILA_CONFIG_ADC_ila_config_adc;
   assign  IFP_test_ctrl.ila_config_dac =  FPGA_REG_ILA_CONFIG_DAC_ila_config_dac;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  FPGA_REG_DL_ANT0_TSSI_ant0_tssi = IFP_test_ctrl.ant_tssi[0];
   assign  FPGA_REG_DL_ANT1_TSSI_ant1_tssi = IFP_test_ctrl.ant_tssi[1];
   assign  FPGA_REG_DL_ANT2_TSSI_ant2_tssi = IFP_test_ctrl.ant_tssi[2];
   assign  FPGA_REG_DL_ANT3_TSSI_ant3_tssi = IFP_test_ctrl.ant_tssi[3];
   assign  FPGA_REG_DL_ANT4_TSSI_ant4_tssi = IFP_test_ctrl.ant_tssi[4];
   assign  FPGA_REG_DL_ANT5_TSSI_ant5_tssi = IFP_test_ctrl.ant_tssi[5];
   assign  FPGA_REG_DL_ANT6_TSSI_ant6_tssi = IFP_test_ctrl.ant_tssi[6];
   assign  FPGA_REG_DL_ANT7_TSSI_ant7_tssi = IFP_test_ctrl.ant_tssi[7];
   assign  FPGA_REG_UL_ANT0_WRSSI_CFG_ul_ant0_wrssi = IFP_test_ctrl.ul_ant_wrssi[0];
   assign  FPGA_REG_UL_ANT1_WRSSI_CFG_ul_ant1_wrssi = IFP_test_ctrl.ul_ant_wrssi[1];
   assign  FPGA_REG_UL_ANT2_WRSSI_CFG_ul_ant2_wrssi = IFP_test_ctrl.ul_ant_wrssi[2];
   assign  FPGA_REG_UL_ANT3_WRSSI_CFG_ul_ant3_wrssi = IFP_test_ctrl.ul_ant_wrssi[3];
   assign  FPGA_REG_UL_ANT4_WRSSI_CFG_ul_ant4_wrssi = IFP_test_ctrl.ul_ant_wrssi[4];
   assign  FPGA_REG_UL_ANT5_WRSSI_CFG_ul_ant5_wrssi = IFP_test_ctrl.ul_ant_wrssi[5];
   assign  FPGA_REG_UL_ANT6_WRSSI_CFG_ul_ant6_wrssi = IFP_test_ctrl.ul_ant_wrssi[6];
   assign  FPGA_REG_UL_ANT7_WRSSI_CFG_ul_ant7_wrssi = IFP_test_ctrl.ul_ant_wrssi[7];
   assign  FPGA_REG_ORX0_WRSSI_orx0_wrssi = IFP_test_ctrl.orx_wrssi[0];
   assign  FPGA_REG_ORX1_WRSSI_orx1_wrssi = IFP_test_ctrl.orx_wrssi[1];
   assign  FPGA_REG_ORX2_WRSSI_orx2_wrssi = IFP_test_ctrl.orx_wrssi[2];
   assign  FPGA_REG_ORX3_WRSSI_orx3_wrssi = IFP_test_ctrl.orx_wrssi[3];
   assign  FPGA_REG_ORX4_WRSSI_orx4_wrssi = IFP_test_ctrl.orx_wrssi[4];
   assign  FPGA_REG_ORX5_WRSSI_orx5_wrssi = IFP_test_ctrl.orx_wrssi[5];
   assign  FPGA_REG_ORX6_WRSSI_orx6_wrssi = IFP_test_ctrl.orx_wrssi[6];
   assign  FPGA_REG_ORX7_WRSSI_orx7_wrssi = IFP_test_ctrl.orx_wrssi[7];
   assign  FPGA_REG_DEBUG_RO_0_debug_ro_0 = IFP_test_ctrl.debug_ro[0];
   assign  FPGA_REG_DEBUG_RO_1_debug_ro_1 = IFP_test_ctrl.debug_ro[1];
   assign  FPGA_REG_DEBUG_RO_2_debug_ro_2 = IFP_test_ctrl.debug_ro[2];
   assign  FPGA_REG_DEBUG_RO_3_debug_ro_3 = IFP_test_ctrl.debug_ro[3];
   assign  FPGA_REG_DEBUG_RO_4_debug_ro_4 = IFP_test_ctrl.debug_ro[4];
   assign  FPGA_REG_DEBUG_RO_5_debug_ro_5 = IFP_test_ctrl.debug_ro[5];
   assign  FPGA_REG_DEBUG_RO_6_debug_ro_6 = IFP_test_ctrl.debug_ro[6];
   assign  FPGA_REG_DEBUG_RO_7_debug_ro_7 = IFP_test_ctrl.debug_ro[7];




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_RFBUF_CFG0_rfbuf_trig_align_en <= 'h0;  // Not for software use. Enable alignment of trigger with PTP marker
                  FPGA_REG_RFBUF_CFG_rfbuf_num_samples <= 'h0;  // Number of samples to be written or read from the Debug buffer
                  FPGA_REG_RFBUF_CFG_rfbuf_mode <= 'h0;  // 1: Continuous mode, 0: Single shot
                  FPGA_REG_RFBUF_CFG_rfbuf_path_select <= 'h0;  // 3'b000: Test mode disable (normal operation), 3'b001: dbgbuf_to_dac, 3'b010: dldfe_to_dbgbuf, 3'b011:adc_to_dbgbuf, 3'b100: dbgbuf_to_uldfe, 3'b101 to 3'b111 : reserved
                  FPGA_REG_RFBUF_TRIGGER_rfbuf_trigger <= 'h0;  // 1: Start the test with the testpath defined by test_path_select defined in DFE_ADCDAC_TEST_CFG  Register. In single shot mode,  to trigger it for subsequent test, write 0 and then write 1, A rising edge is on this bit is used for triggering the test.
                  FPGA_REG_RFBUF_RESET_rfbuf_reset <= 'h0;  // 1: Reset the test, This bit can be used to reset the State machine when it is in continuous mode. It has to be set back to 0 to restart the test again
                  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_uldfe_to_dldfe_lpbk <= 'h0;  // 1: route UL DFE output to DL DFE input
                  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_uldfe_to_dldfe_lpbk <= 'h0;  // 1: route UL DFE output to DL DFE input
                  FPGA_REG_CPRI_DFE_TEST_CFG_fh_dbg_mode <= 'h0;  // 2'b00: Normal operation, 2'b01: Drive data from dbg Buffer,  2'b10: lphy Dl to lphy UL, 2'b11: Reserved
                  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_orx_to_uldfe_en <= 'h0;  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_rx0_to_all_ul_paths <= 'h0;  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_orx_to_uldfe_en <= 'h0;  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_rx0_to_all_ul_paths <= 'h0;  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_rx_antenna_dgb_sel <= 'h0;  // 0x0: Rx Ant0 , 0x1: Rx Ant1, 0x2: Rx Ant2, 0x3: Rx Ant3, 0x4: Rx Ant4 , 0x5: Rx Ant5, 0x6: Rx Ant6, 0x7: Rx Ant70x10: ORx Ant0, 0x11: ORx Ant1, 0x12: ORx Ant2, 0x13: ORx Ant3,0x14: ORx Ant4, 0x15: ORx Ant5, 0x16: ORx Ant6, 0x17: ORx Ant7
                  FPGA_REG_UL_TEST_CFG_adc_invert_q <= 'h0;  // 1: Invert Q on UL Path at ADC output, 
                  FPGA_REG_FHBUF_CFG_fhbuf_num_samples <= 'h0;  // Number of samples to be driven at DL DFE input, Currently FH BUffer is 128KBytes, Bits [14:0] are valid, Maximum number of samples is 30720.
                  FPGA_REG_FHBUF_CFG_fhbuf_ants_sel <= 'h0;  // 0 = first four ants, 1 = last four ants
                  FPGA_REG_FHBUF_CFG_fhbuf_store_en <= 'h0;  // 1. Store the Data into Buffer, 0:Load the Data from the Buffer (Buffer as a waveform generator)
                  FPGA_REG_FHBUF_CFG_fhbuf_mode <= 'h0;  // 1: Continuous mode, 0: Single shot
                  FPGA_REG_FHBUF_CFG_fhbuf_en <= 'h0;  // 1: Enable the test mode
                  FPGA_REG_FHBUF_TRIGGER_fhbuf_trigger <= 'h0;  // 1: Start driving the data into DL DFE chain
                  FPGA_REG_DEBUG_RW_0_debug_rw_0 <= 'h0;  // Temporary. Not for software. Debug RW Register.  Bit0 to send pa_odp_tssi to ant_tssi. Bit4-7 to insert pa_odp_tssi from debug_rw_1-4 regs
                  FPGA_REG_DEBUG_RW_1_debug_rw_1 <= 'h0;  // Temporary. Not for software. Debug RW Register. PA_ODP_TSSI on selected antennas
                  FPGA_REG_DEBUG_RW_2_debug_rw_2 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_3_debug_rw_3 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_4_debug_rw_4 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_5_debug_rw_5 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_6_debug_rw_6 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_7_debug_rw_7 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_VIO_CONFIG_UL_vio_config_ul <= 'h0;  // Temporary. Not for software
                  FPGA_REG_VIO_CONFIG_DL_vio_config_dl <= 'h0;  // Temporary. Not for software
                  FPGA_REG_ILA_CONFIG_ADC_ila_config_adc <= 'h0;  // Temporary. Not for software
                  FPGA_REG_ILA_CONFIG_DAC_ila_config_dac <= 'h0;  // Temporary. Not for software
                  FPGA_REG_DBG_SCRATCH_dbg_scratch <= 'h4444_dddd;  // 
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h3c  : begin //'hF0
                  FPGA_REG_RFBUF_CFG0_rfbuf_trig_align_en <= IFP_axi_rw.wdata[0];  // Not for software use. Enable alignment of trigger with PTP marker
             end
      11'h40  : begin //'h100
                  FPGA_REG_RFBUF_CFG_rfbuf_num_samples <= IFP_axi_rw.wdata[19:0];  // Number of samples to be written or read from the Debug buffer
                  FPGA_REG_RFBUF_CFG_rfbuf_mode <= IFP_axi_rw.wdata[24];  // 1: Continuous mode, 0: Single shot
                  FPGA_REG_RFBUF_CFG_rfbuf_path_select <= IFP_axi_rw.wdata[30:28];  // 3'b000: Test mode disable (normal operation), 3'b001: dbgbuf_to_dac, 3'b010: dldfe_to_dbgbuf, 3'b011:adc_to_dbgbuf, 3'b100: dbgbuf_to_uldfe, 3'b101 to 3'b111 : reserved
             end
      11'h41  : begin //'h104
                  FPGA_REG_RFBUF_TRIGGER_rfbuf_trigger <= IFP_axi_rw.wdata[0];  // 1: Start the test with the testpath defined by test_path_select defined in DFE_ADCDAC_TEST_CFG  Register. In single shot mode,  to trigger it for subsequent test, write 0 and then write 1, A rising edge is on this bit is used for triggering the test.
             end
      11'h42  : begin //'h108
                  FPGA_REG_RFBUF_RESET_rfbuf_reset <= IFP_axi_rw.wdata[0];  // 1: Reset the test, This bit can be used to reset the State machine when it is in continuous mode. It has to be set back to 0 to restart the test again
             end
      11'h43  : begin //'h10C
                  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_uldfe_to_dldfe_lpbk <= IFP_axi_rw.wdata[0];  // 1: route UL DFE output to DL DFE input
                  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_uldfe_to_dldfe_lpbk <= IFP_axi_rw.wdata[1];  // 1: route UL DFE output to DL DFE input
                  FPGA_REG_CPRI_DFE_TEST_CFG_fh_dbg_mode <= IFP_axi_rw.wdata[5:4];  // 2'b00: Normal operation, 2'b01: Drive data from dbg Buffer,  2'b10: lphy Dl to lphy UL, 2'b11: Reserved
                  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_orx_to_uldfe_en <= IFP_axi_rw.wdata[8];  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_rx0_to_all_ul_paths <= IFP_axi_rw.wdata[9];  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_orx_to_uldfe_en <= IFP_axi_rw.wdata[8];  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_rx0_to_all_ul_paths <= IFP_axi_rw.wdata[9];  // 1: Route Orx Path to RX DFE Path
                  FPGA_REG_CPRI_DFE_TEST_CFG_rx_antenna_dgb_sel <= IFP_axi_rw.wdata[16:12];  // 0x0: Rx Ant0 , 0x1: Rx Ant1, 0x2: Rx Ant2, 0x3: Rx Ant3, 0x4: Rx Ant4 , 0x5: Rx Ant5, 0x6: Rx Ant6, 0x7: Rx Ant70x10: ORx Ant0, 0x11: ORx Ant1, 0x12: ORx Ant2, 0x13: ORx Ant3,0x14: ORx Ant4, 0x15: ORx Ant5, 0x16: ORx Ant6, 0x17: ORx Ant7
             end
      11'h44  : begin //'h110
                  FPGA_REG_UL_TEST_CFG_adc_invert_q <= IFP_axi_rw.wdata[0];  // 1: Invert Q on UL Path at ADC output, 
             end
      11'h48  : begin //'h120
                  FPGA_REG_FHBUF_CFG_fhbuf_num_samples <= IFP_axi_rw.wdata[19:0];  // Number of samples to be driven at DL DFE input, Currently FH BUffer is 128KBytes, Bits [14:0] are valid, Maximum number of samples is 30720.
                  FPGA_REG_FHBUF_CFG_fhbuf_ants_sel <= IFP_axi_rw.wdata[25:24];  // 0 = first four ants, 1 = last four ants
                  FPGA_REG_FHBUF_CFG_fhbuf_store_en <= IFP_axi_rw.wdata[29];  // 1. Store the Data into Buffer, 0:Load the Data from the Buffer (Buffer as a waveform generator)
                  FPGA_REG_FHBUF_CFG_fhbuf_mode <= IFP_axi_rw.wdata[30];  // 1: Continuous mode, 0: Single shot
                  FPGA_REG_FHBUF_CFG_fhbuf_en <= IFP_axi_rw.wdata[31];  // 1: Enable the test mode
             end
      11'h49  : begin //'h124
                  FPGA_REG_FHBUF_TRIGGER_fhbuf_trigger <= IFP_axi_rw.wdata[0];  // 1: Start driving the data into DL DFE chain
             end
      11'h7c0  : begin //'h1F00
                  FPGA_REG_DEBUG_RW_0_debug_rw_0 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register.  Bit0 to send pa_odp_tssi to ant_tssi. Bit4-7 to insert pa_odp_tssi from debug_rw_1-4 regs
             end
      11'h7c1  : begin //'h1F04
                  FPGA_REG_DEBUG_RW_1_debug_rw_1 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register. PA_ODP_TSSI on selected antennas
             end
      11'h7c2  : begin //'h1F08
                  FPGA_REG_DEBUG_RW_2_debug_rw_2 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7c3  : begin //'h1F0C
                  FPGA_REG_DEBUG_RW_3_debug_rw_3 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7c4  : begin //'h1F10
                  FPGA_REG_DEBUG_RW_4_debug_rw_4 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7c5  : begin //'h1F14
                  FPGA_REG_DEBUG_RW_5_debug_rw_5 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7c6  : begin //'h1F18
                  FPGA_REG_DEBUG_RW_6_debug_rw_6 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7c7  : begin //'h1F1C
                  FPGA_REG_DEBUG_RW_7_debug_rw_7 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7d0  : begin //'h1F40
                  FPGA_REG_VIO_CONFIG_UL_vio_config_ul <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software
             end
      11'h7d1  : begin //'h1F44
                  FPGA_REG_VIO_CONFIG_DL_vio_config_dl <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software
             end
      11'h7d2  : begin //'h1F48
                  FPGA_REG_ILA_CONFIG_ADC_ila_config_adc <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software
             end
      11'h7d3  : begin //'h1F4C
                  FPGA_REG_ILA_CONFIG_DAC_ila_config_dac <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software
             end
      11'h7ff  : begin //'h1FFC
                  FPGA_REG_DBG_SCRATCH_dbg_scratch <= IFP_axi_rw.wdata[31:0];  // 
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
      11'h3c  : begin//'hF0
                   IFP_axi_rw.rdata[0] = FPGA_REG_RFBUF_CFG0_rfbuf_trig_align_en;  // Not for software use. Enable alignment of trigger with PTP marker
             end
      11'h40  : begin//'h100
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_RFBUF_CFG_rfbuf_num_samples;  // Number of samples to be written or read from the Debug buffer
                   IFP_axi_rw.rdata[24] = FPGA_REG_RFBUF_CFG_rfbuf_mode;  // 1: Continuous mode, 0: Single shot
                   IFP_axi_rw.rdata[30:28] = FPGA_REG_RFBUF_CFG_rfbuf_path_select;  // 3'b000: Test mode disable (normal operation), 3'b001: dbgbuf_to_dac, 3'b010: dldfe_to_dbgbuf, 3'b011:adc_to_dbgbuf, 3'b100: dbgbuf_to_uldfe, 3'b101 to 3'b111 : reserved
             end
      11'h41  : begin//'h104
                   IFP_axi_rw.rdata[0] = FPGA_REG_RFBUF_TRIGGER_rfbuf_trigger;  // 1: Start the test with the testpath defined by test_path_select defined in DFE_ADCDAC_TEST_CFG  Register. In single shot mode,  to trigger it for subsequent test, write 0 and then write 1, A rising edge is on this bit is used for triggering the test.
             end
      11'h42  : begin//'h108
                   IFP_axi_rw.rdata[0] = FPGA_REG_RFBUF_RESET_rfbuf_reset;  // 1: Reset the test, This bit can be used to reset the State machine when it is in continuous mode. It has to be set back to 0 to restart the test again
             end
      11'h43  : begin//'h10C
                   IFP_axi_rw.rdata[0] = FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_uldfe_to_dldfe_lpbk;  // 1: route UL DFE output to DL DFE input
                   IFP_axi_rw.rdata[1] = FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_uldfe_to_dldfe_lpbk;  // 1: route UL DFE output to DL DFE input
                   IFP_axi_rw.rdata[5:4] = FPGA_REG_CPRI_DFE_TEST_CFG_fh_dbg_mode;  // 2'b00: Normal operation, 2'b01: Drive data from dbg Buffer,  2'b10: lphy Dl to lphy UL, 2'b11: Reserved
                   IFP_axi_rw.rdata[8] = FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_orx_to_uldfe_en;  // 1: Route Orx Path to RX DFE Path
                   IFP_axi_rw.rdata[9] = FPGA_REG_CPRI_DFE_TEST_CFG_first_4_ants_rx0_to_all_ul_paths;  // 1: Route Orx Path to RX DFE Path
                   IFP_axi_rw.rdata[8] = FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_orx_to_uldfe_en;  // 1: Route Orx Path to RX DFE Path
                   IFP_axi_rw.rdata[9] = FPGA_REG_CPRI_DFE_TEST_CFG_last_4_ants_rx0_to_all_ul_paths;  // 1: Route Orx Path to RX DFE Path
                   IFP_axi_rw.rdata[16:12] = FPGA_REG_CPRI_DFE_TEST_CFG_rx_antenna_dgb_sel;  // 0x0: Rx Ant0 , 0x1: Rx Ant1, 0x2: Rx Ant2, 0x3: Rx Ant3, 0x4: Rx Ant4 , 0x5: Rx Ant5, 0x6: Rx Ant6, 0x7: Rx Ant70x10: ORx Ant0, 0x11: ORx Ant1, 0x12: ORx Ant2, 0x13: ORx Ant3,0x14: ORx Ant4, 0x15: ORx Ant5, 0x16: ORx Ant6, 0x17: ORx Ant7
             end
      11'h44  : begin//'h110
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_TEST_CFG_adc_invert_q;  // 1: Invert Q on UL Path at ADC output, 
             end
      11'h48  : begin//'h120
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_FHBUF_CFG_fhbuf_num_samples;  // Number of samples to be driven at DL DFE input, Currently FH BUffer is 128KBytes, Bits [14:0] are valid, Maximum number of samples is 30720.
                   IFP_axi_rw.rdata[25:24] = FPGA_REG_FHBUF_CFG_fhbuf_ants_sel;  // 0 = first four ants, 1 = last four ants
                   IFP_axi_rw.rdata[29] = FPGA_REG_FHBUF_CFG_fhbuf_store_en;  // 1. Store the Data into Buffer, 0:Load the Data from the Buffer (Buffer as a waveform generator)
                   IFP_axi_rw.rdata[30] = FPGA_REG_FHBUF_CFG_fhbuf_mode;  // 1: Continuous mode, 0: Single shot
                   IFP_axi_rw.rdata[31] = FPGA_REG_FHBUF_CFG_fhbuf_en;  // 1: Enable the test mode
             end
      11'h49  : begin//'h124
                   IFP_axi_rw.rdata[0] = FPGA_REG_FHBUF_TRIGGER_fhbuf_trigger;  // 1: Start driving the data into DL DFE chain
             end
      11'h80  : begin//'h200
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT0_TSSI_ant0_tssi;  // Antenna 0 Path TSSI
             end
      11'h81  : begin//'h204
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT1_TSSI_ant1_tssi;  // Antenna 1 Path TSSI
             end
      11'h82  : begin//'h208
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT2_TSSI_ant2_tssi;  // Antenna 2 Path TSSI
             end
      11'h83  : begin//'h20C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT3_TSSI_ant3_tssi;  // Antenna 3 Path TSSI
             end
      11'h84  : begin//'h210
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT4_TSSI_ant4_tssi;  // Antenna 4 Path TSSI
             end
      11'h85  : begin//'h214
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT5_TSSI_ant5_tssi;  // Antenna 5 Path TSSI
             end
      11'h86  : begin//'h218
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT6_TSSI_ant6_tssi;  // Antenna 6 Path TSSI
             end
      11'h87  : begin//'h21C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT7_TSSI_ant7_tssi;  // Antenna 7 Path TSSI
             end
      11'h88  : begin//'h220
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT0_WRSSI_CFG_ul_ant0_wrssi;  // Antenna 0 Path wrssi 
             end
      11'h89  : begin//'h224
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT1_WRSSI_CFG_ul_ant1_wrssi;  // Antenna 1 Path wrssi 
             end
      11'h8a  : begin//'h228
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT2_WRSSI_CFG_ul_ant2_wrssi;  // Antenna 2 Path wrssi 
             end
      11'h8b  : begin//'h22C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT3_WRSSI_CFG_ul_ant3_wrssi;  // Antenna 3 Path wrssi 
             end
      11'h8c  : begin//'h230
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT4_WRSSI_CFG_ul_ant4_wrssi;  // Antenna 4 Path wrssi 
             end
      11'h8d  : begin//'h234
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT5_WRSSI_CFG_ul_ant5_wrssi;  // Antenna 5 Path wrssi 
             end
      11'h8e  : begin//'h238
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT6_WRSSI_CFG_ul_ant6_wrssi;  // Antenna 6 Path wrssi 
             end
      11'h8f  : begin//'h23C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT7_WRSSI_CFG_ul_ant7_wrssi;  // Antenna 7 Path wrssi 
             end
      11'h90  : begin//'h240
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX0_WRSSI_orx0_wrssi;  // Observation Path Antenna 0 Path wrssi 
             end
      11'h91  : begin//'h244
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX1_WRSSI_orx1_wrssi;  // Observation Path Antenna 1 Path wrssi 
             end
      11'h92  : begin//'h248
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX2_WRSSI_orx2_wrssi;  // Observation Path Antenna 2 Path wrssi 
             end
      11'h93  : begin//'h24C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX3_WRSSI_orx3_wrssi;  // Observation Path Antenna 3 Path wrssi 
             end
      11'h94  : begin//'h250
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX4_WRSSI_orx4_wrssi;  // Observation Path Antenna 4 Path wrssi 
             end
      11'h95  : begin//'h254
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX5_WRSSI_orx5_wrssi;  // Observation Path Antenna 5 Path wrssi 
             end
      11'h96  : begin//'h258
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX6_WRSSI_orx6_wrssi;  // Observation Path Antenna 6 Path wrssi 
             end
      11'h97  : begin//'h25C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX7_WRSSI_orx7_wrssi;  // Observation Path Antenna 7 Path wrssi 
             end
      11'h7c0  : begin//'h1F00
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_0_debug_rw_0;  // Temporary. Not for software. Debug RW Register.  Bit0 to send pa_odp_tssi to ant_tssi. Bit4-7 to insert pa_odp_tssi from debug_rw_1-4 regs
             end
      11'h7c1  : begin//'h1F04
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_1_debug_rw_1;  // Temporary. Not for software. Debug RW Register. PA_ODP_TSSI on selected antennas
             end
      11'h7c2  : begin//'h1F08
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_2_debug_rw_2;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c3  : begin//'h1F0C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_3_debug_rw_3;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c4  : begin//'h1F10
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_4_debug_rw_4;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c5  : begin//'h1F14
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_5_debug_rw_5;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c6  : begin//'h1F18
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_6_debug_rw_6;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c7  : begin//'h1F1C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_7_debug_rw_7;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c8  : begin//'h1F20
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_0_debug_ro_0;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7c9  : begin//'h1F24
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_1_debug_ro_1;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7ca  : begin//'h1F28
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_2_debug_ro_2;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7cb  : begin//'h1F2C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_3_debug_ro_3;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7cc  : begin//'h1F30
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_4_debug_ro_4;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7cd  : begin//'h1F34
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_5_debug_ro_5;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7ce  : begin//'h1F38
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_6_debug_ro_6;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7cf  : begin//'h1F3C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_7_debug_ro_7;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7d0  : begin//'h1F40
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_VIO_CONFIG_UL_vio_config_ul;  // Temporary. Not for software
             end
      11'h7d1  : begin//'h1F44
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_VIO_CONFIG_DL_vio_config_dl;  // Temporary. Not for software
             end
      11'h7d2  : begin//'h1F48
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ILA_CONFIG_ADC_ila_config_adc;  // Temporary. Not for software
             end
      11'h7d3  : begin//'h1F4C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ILA_CONFIG_DAC_ila_config_dac;  // Temporary. Not for software
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DBG_SCRATCH_dbg_scratch;  // 
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule