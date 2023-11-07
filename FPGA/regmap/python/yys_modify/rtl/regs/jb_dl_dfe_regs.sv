
module jb_dl_dfe_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_dl_dfe_ctrl_if.ctrl         IFP_dl_dfe_ctrl,
    jb_dl_dfe_stat_if.stat         IFP_dl_dfe_stat 
);



////////////////Register Field Declarations//////////////////
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a0_mute_en;
  // Mute Enable for Carrier 0 in Antenna 0
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a0_mute_en;
  // Mute Enable for Carrier 1 in Antenna 0
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a1_mute_en;
  // Mute Enable for Carrier 0 in Antenna 1
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a1_mute_en;
  // Mute Enable for Carrier 1 in Antenna 1
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a2_mute_en;
  // Mute Enable for Carrier 0 in Antenna 2
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a2_mute_en;
  // Mute Enable for Carrier 1 in Antenna 2
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a3_mute_en;
  // Mute Enable for Carrier 0 in Antenna 3
   logic                     FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a3_mute_en;
  // Mute Enable for Carrier 1 in Antenna 3
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a4_mute_en;
  // Mute Enable for Carrier 0 in Antenna 4
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a4_mute_en;
  // Mute Enable for Carrier 1 in Antenna 4
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a5_mute_en;
  // Mute Enable for Carrier 0 in Antenna 5
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a5_mute_en;
  // Mute Enable for Carrier 1 in Antenna 5
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a6_mute_en;
  // Mute Enable for Carrier 0 in Antenna 6
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a6_mute_en;
  // Mute Enable for Carrier 1 in Antenna 6
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a7_mute_en;
  // Mute Enable for Carrier 0 in Antenna 7
   logic                     FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a7_mute_en;
  // Mute Enable for Carrier 1 in Antenna 7
   logic                     FPGA_REG_DL_ANT_INT_FRAC_DLY_TRIG_dl_ant_int_frac_delay_trig;
  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
   logic                     FPGA_REG_DL_DFE_CAR_FLUSH_STATE_dl_dfe_car0_flush_state;
  // 1: Carrier0 dfe chain is busy flushing the pipeline, 0: operational or idle state and not in flush state
   logic                     FPGA_REG_DL_DFE_CAR_FLUSH_STATE_dl_dfe_car1_flush_state;
  // 1: Carrier1 dfe chain is busy flushing the pipeline, 0: Not flushing
   logic  [31:0]              FPGA_REG_DL_CAR0_NCO_LSB_CFG_dl_car0_nco_lsb;
  // [31:0] of NCO value for carrier0
   logic  [6:0]              FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_msb;
  // [38:32] of NCO value for carrier0
   logic                     FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_sign;
  // Sign of NCO
   logic  [31:0]              FPGA_REG_DL_CAR1_NCO_LSB_CFG_dl_car1_nco_lsb;
  // [31:0] of NCO value for carrier1
   logic  [6:0]              FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_msb;
  // [38:32] of NCO value for carrier1
   logic                     FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_sign;
  // Sign of NCO
   logic                     FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_fraction_gain;
  // Unsigned multiplier to both I & Q?
   logic                     FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_fraction_gain;
  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
   logic                     FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
   logic  [15:0]              FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q,  Can only be updated when the override bit is set
   logic                     FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
   logic  [3:0]              FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
   logic                     FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set 
   logic  [3:0]              FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB)?
   logic  [15:0]              FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
   logic                     FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
   logic  [3:0]              FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
   logic  [15:0]              FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
   logic                     FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
   logic  [3:0]              FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
   logic  [15:0]              FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
   logic                     FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
   logic  [3:0]              FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
   logic  [15:0]              FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
   logic                     FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
   logic  [3:0]              FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
   logic  [15:0]              FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
   logic                     FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_sign;
   logic                     FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_sign_mod;
  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
   logic  [3:0]              FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler;
   logic  [3:0]              FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_mod;
  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
   logic  [15:0]              FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_fraction_gain;
   logic  [15:0]              FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_fraction_gain_mod;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
   logic  [5:0]              FPGA_REG_DL_ANT0_DELAY_CFG_dl_ant0_delay;
  // Antenna0 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles,
   logic  [5:0]              FPGA_REG_DL_ANT1_DELAY_CFG_dl_ant1_delay;
  // Antenna1 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles, 
   logic  [5:0]              FPGA_REG_DL_ANT2_DELAY_CFG_dl_ant2_delay;
  // Antenna2 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
   logic  [5:0]              FPGA_REG_DL_ANT3_DELAY_CFG_dl_ant3_delay;
  // Antenna3 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
   logic  [5:0]              FPGA_REG_DL_ANT4_DELAY_CFG_dl_ant4_delay;
  // Antenna4 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
   logic  [5:0]              FPGA_REG_DL_ANT5_DELAY_CFG_dl_ant5_delay;
  // Antenna5 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
   logic  [5:0]              FPGA_REG_DL_ANT6_DELAY_CFG_dl_ant6_delay;
  // Antenna6 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
   logic  [5:0]              FPGA_REG_DL_ANT7_DELAY_CFG_dl_ant7_delay;
  // Antenna7 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
   logic  [31:0]              FPGA_REG_DL_FH_ANT0_TSSI_ant0_fh_tssi;
  // Antenna 0 Path FH TSSI
   logic  [31:0]              FPGA_REG_DL_FH_ANT1_TSSI_ant1_fh_tssi;
  // Antenna 1 Path FH TSSI
   logic  [31:0]              FPGA_REG_DL_FH_ANT2_TSSI_ant2_fh_tssi;
  // Antenna 2 Path FH TSSI
   logic  [31:0]              FPGA_REG_DL_FH_ANT3_TSSI_ant3_fh_tssi;
  // Antenna 3 Path FH TSSI
   logic  [31:0]              FPGA_REG_DL_FH_ANT4_TSSI_ant4_fh_tssi;
  // Antenna 4 Path FH TSSI
   logic  [31:0]              FPGA_REG_DL_FH_ANT5_TSSI_ant5_fh_tssi;
  // Antenna 5 Path FH TSSI
   logic  [31:0]              FPGA_REG_DL_FH_ANT6_TSSI_ant6_fh_tssi;
  // Antenna 6 Path FH TSSI
   logic  [31:0]              FPGA_REG_DL_FH_ANT7_TSSI_ant7_fh_tssi;
  // Antenna 7 Path FH TSSI
   logic                     FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_dpd;
   logic                     FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_dpd_mod;
  // This bit is always tied to 0 (RO), DPD bypass is removed to avoid damage to PA during CLGC algorithm. 
   logic                     FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_cfr;
  // 1: Bypass CFR  0: Normal operation
   logic                     FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_override_postcfr;
  // 1: Override bit to configure the pre DPD Gain (also called postcfr_gain), when this bit set to 0, 6dB gain is added when DPD is not in bypass and remove 6dB gain when DPD is in Bypass.
   logic                     FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_ps_filter_bypass;
  // 1:Bypass PS Filter, 0: Normal operation
   logic  [2:0]              FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_dl_dfe_path_dbg_sel;
  // Select the point in DL DFE to be latched into the Debug Buffer for debugging DC Spur
   logic                     FPGA_REG_DL_DFE_CLEAR_SAT_FLAGS_clear_sat_flags;
  // Write 0 and then write 1 to clear all the overflow and underflow flags (pos edge)
   logic  [31:0]              FPGA_REG_DL_DFE_C0_ANT0TO3PULSE_SHAPE_SAT_STAT_car0_ps_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for Ant3
   logic  [31:0]              FPGA_REG_DL_DFE_C0_ANT4TO7PULSE_SHAPE_SAT_STAT_car0_ps_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for Ant7
   logic  [31:0]              FPGA_REG_DL_DFE_C1_ANT0TO3PULSE_SHAPE_SAT_STAT_car1_ps_sat_flag;
  // sam as above 128
   logic  [31:0]              FPGA_REG_DL_DFE_C1_ANT4TO7PULSE_SHAPE_SAT_STAT_car1_ps_sat_flag;
  // sam as above 129
   logic  [31:0]              FPGA_REG_DL_DFE_C0A0_INTRP_SAT_STAT_c0a0_intrp_sat_flag;
  // Saturation Flag for Interpolatror 0 (first 2X Filter), Valid for all BandwidthsBit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id errorSaturation Flag for Interpolatror 1 (Second 2X Filter), Valid for all BandwidthsBit [8] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [9] - All the MSB bits in I (real part) from FIR are checked and reportedBit [10] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [11] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [15] - FIR internal error, set when there is channel id errorSaturation Flag for Interpolatror 2 (Third 2X Filter), Valid for 10Mhz BWBit [16] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [17] - All the MSB bits in I (real part) from FIR are checked and reportedBit [18] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [19] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [23] - FIR internal error, set when there is channel id errorSaturation Flag for Interpolatror 3 (Third 2X Filter), Valid for 5Mhz BWBit [24] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [25] - All the MSB bits in I (real part) from FIR are checked and reportedBit [26] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [27] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [31] - FIR internal error, set when there is channel id error
   logic  [31:0]              FPGA_REG_DL_DFE_C0A1_INTRP_SAT_STAT_c0a1_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C0A2_INTRP_SAT_STAT_c0a2_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C0A3_INTRP_SAT_STAT_c0a3_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C0A4_INTRP_SAT_STAT_c0a4_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C0A5_INTRP_SAT_STAT_c0a5_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C0A6_INTRP_SAT_STAT_c0a6_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C0A7_INTRP_SAT_STAT_c0a7_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A0_INTRP_SAT_STAT_c1a0_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A1_INTRP_SAT_STAT_c1a1_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A2_INTRP_SAT_STAT_c1a2_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A3_INTRP_SAT_STAT_c1a3_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A4_INTRP_SAT_STAT_c1a4_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A5_INTRP_SAT_STAT_c1a5_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A6_INTRP_SAT_STAT_c1a6_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_C1A7_INTRP_SAT_STAT_c1a7_intrp_sat_flag;
  // Same as above
   logic  [31:0]              FPGA_REG_DL_DFE_FIR_3X_ANT0TO3_SAT_STAT_fir_3x_ant0to3_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for An3
   logic  [31:0]              FPGA_REG_DL_DFE_FIR_3X_ANT4TO7_SAT_STAT_fir_3x_ant4to7_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for An7
   logic  [31:0]              FPGA_REG_DL_DFE_POLY_EVEN_ANT0TO3_SAT_STAT_poly_even_ant0to3_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for An3
   logic  [31:0]              FPGA_REG_DL_DFE_POLY_EVEN_ANT4TO7_SAT_STAT_poly_even_ant4to7_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for An7
   logic  [31:0]              FPGA_REG_DL_DFE_POLY_ODD_ANT0TO3_SAT_STAT_poly_odd_ant0to3_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for An3
   logic  [31:0]              FPGA_REG_DL_DFE_POLY_ODD_ANT4TO7_SAT_STAT_poly_odd_ant4to7_sat_flag;
  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for An7
   logic  [6:0]              FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_int_delay;
  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_frac_delay;
  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_int_delay;
  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_frac_delay;
  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_int_delay;
  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_frac_delay;
  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_int_delay;
  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_frac_delay;
  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_int_delay;
  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_frac_delay;
  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_int_delay;
  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_frac_delay;
  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_int_delay;
  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_frac_delay;
  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_int_delay;
  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_frac_delay;
  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_int_delay;
  // Carrier 0 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_frac_delay;
  // Carrier0 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_int_delay;
  // Carrier 1 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_frac_delay;
  // Carrier1 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_int_delay;
  // Carrier 0 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_frac_delay;
  // Carrier0 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_int_delay;
  // Carrier 1 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_frac_delay;
  // Carrier1 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_int_delay;
  // Carrier 0 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_frac_delay;
  // Carrier0 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_int_delay;
  // Carrier 1 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_frac_delay;
  // Carrier1 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_int_delay;
  // Carrier 0 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_frac_delay;
  // Carrier0 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_int_delay;
  // Carrier 1 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_frac_delay;
  // Carrier1 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [31:0]              FPGA_REG_DL_SCRATCH_DEBUG_pl_debug;
  // Used by pl for debug
   logic  [31:0]              FPGA_REG_DL_SCRATCH_scratch;
  // 








////////////////ASSIGN PARAMETERS//////////////////





////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[0][0] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a0_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[1][0] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a0_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[0][1] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a1_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[1][1] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a1_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[0][2] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a2_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[1][2] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a2_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[0][3] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a3_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path0to3[1][3] =  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a3_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[0][0] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a4_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[1][0] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a4_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[0][1] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a5_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[1][1] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a5_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[0][2] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a6_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[1][2] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a6_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[0][3] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a7_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_dfe_mute_path4to7[1][3] =  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a7_mute_en;
   assign  IFP_dl_dfe_ctrl.dl_ant_int_frac_delay_trig =  FPGA_REG_DL_ANT_INT_FRAC_DLY_TRIG_dl_ant_int_frac_delay_trig;
   assign  IFP_dl_dfe_ctrl.dl_car_nco_lsb[0] =  FPGA_REG_DL_CAR0_NCO_LSB_CFG_dl_car0_nco_lsb;
   assign  IFP_dl_dfe_ctrl.dl_car_nco_msb[0] =  FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_msb;
   assign  IFP_dl_dfe_ctrl.dl_car_nco_sign[0] =  FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_sign;
   assign  IFP_dl_dfe_ctrl.dl_car_nco_lsb[1] =  FPGA_REG_DL_CAR1_NCO_LSB_CFG_dl_car1_nco_lsb;
   assign  IFP_dl_dfe_ctrl.dl_car_nco_msb[1] =  FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_msb;
   assign  IFP_dl_dfe_ctrl.dl_car_nco_sign[1] =  FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][0] =  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][0] =  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][0] =  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][0] =  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][0] =  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][0] =  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][1] =  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][1] =  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][1] =  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][1] =  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][1] =  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][1] =  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][2] =  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][2] =  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][2] =  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][2] =  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][2] =  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][2] =  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][3] =  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][3] =  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][3] =  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][3] =  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][3] =  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][3] =  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][4] =  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][4] =  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][4] =  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][4] =  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][4] =  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][4] =  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][5] =  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][5] =  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][5] =  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][5] =  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][5] =  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][5] =  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][6] =  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][6] =  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][6] =  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][6] =  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][6] =  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][6] =  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[0][7] =  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[0][7] =  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[0][7] =  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[1][7] =  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_scaler[1][7] =  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler;
   assign  IFP_dl_dfe_ctrl.dl_stream_gain_fraction[1][7] =  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[0] =  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[0] =  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[0] =  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[1] =  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[1] =  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[1] =  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[2] =  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[2] =  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[2] =  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[3] =  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[3] =  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[3] =  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[4] =  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[4] =  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[4] =  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[5] =  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[5] =  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[5] =  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[6] =  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[6] =  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[6] =  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[7] =  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[7] =  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[7] =  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[0] =  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[0] =  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[0] =  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[1] =  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[1] =  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[1] =  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[2] =  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[2] =  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[2] =  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[3] =  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[3] =  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[3] =  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[4] =  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[4] =  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[4] =  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[5] =  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[5] =  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[5] =  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[6] =  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[6] =  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[6] =  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[7] =  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_sign;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[7] =  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler;
   assign  IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[7] =  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_fraction_gain;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[0] =  FPGA_REG_DL_ANT0_DELAY_CFG_dl_ant0_delay;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[1] =  FPGA_REG_DL_ANT1_DELAY_CFG_dl_ant1_delay;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[2] =  FPGA_REG_DL_ANT2_DELAY_CFG_dl_ant2_delay;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[3] =  FPGA_REG_DL_ANT3_DELAY_CFG_dl_ant3_delay;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[4] =  FPGA_REG_DL_ANT4_DELAY_CFG_dl_ant4_delay;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[5] =  FPGA_REG_DL_ANT5_DELAY_CFG_dl_ant5_delay;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[6] =  FPGA_REG_DL_ANT6_DELAY_CFG_dl_ant6_delay;
   assign  IFP_dl_dfe_ctrl.dl_ant_delay[7] =  FPGA_REG_DL_ANT7_DELAY_CFG_dl_ant7_delay;
   assign  IFP_dl_dfe_ctrl.bypass_dpd =  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_dpd;
   assign  IFP_dl_dfe_ctrl.bypass_cfr =  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_cfr;
   assign  IFP_dl_dfe_ctrl.override_postcfr =  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_override_postcfr;
   assign  IFP_dl_dfe_ctrl.ps_filter_bypass =  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_ps_filter_bypass;
   assign  IFP_dl_dfe_ctrl.dl_dfe_path_dbg_sel =  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_dl_dfe_path_dbg_sel;
   assign  IFP_dl_dfe_ctrl.clear_sat_flags =  FPGA_REG_DL_DFE_CLEAR_SAT_FLAGS_clear_sat_flags;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][0] =  FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][0] =  FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][0] =  FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][0] =  FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][1] =  FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][1] =  FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][1] =  FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][1] =  FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][2] =  FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][2] =  FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][2] =  FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][2] =  FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][3] =  FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][3] =  FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][3] =  FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][3] =  FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][4] =  FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][4] =  FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][4] =  FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][4] =  FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][5] =  FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][5] =  FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][5] =  FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][5] =  FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][6] =  FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][6] =  FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][6] =  FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][6] =  FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[0][7] =  FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[0][7] =  FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_frac_delay;
   assign  IFP_dl_dfe_ctrl.dl_int_delay[1][7] =  FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_int_delay;
   assign  IFP_dl_dfe_ctrl.dl_frac_delay[1][7] =  FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_frac_delay;
   assign  IFP_dl_dfe_ctrl.pl_debug            =  FPGA_REG_DL_SCRATCH_DEBUG_pl_debug;



////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  FPGA_REG_DL_DFE_CAR_FLUSH_STATE_dl_dfe_car0_flush_state = IFP_dl_dfe_stat.dl_dfe_car_flush_state[0];
   assign  FPGA_REG_DL_DFE_CAR_FLUSH_STATE_dl_dfe_car1_flush_state = IFP_dl_dfe_stat.dl_dfe_car_flush_state[1];
   assign  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[0];
   assign  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[0];
   assign  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[0];
   assign  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[1];
   assign  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[1];
   assign  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[1];
   assign  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[2];
   assign  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[2];
   assign  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[2];
   assign  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[3];
   assign  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[3];
   assign  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[3];
   assign  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[4];
   assign  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[4];
   assign  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[4];
   assign  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[5];
   assign  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[5];
   assign  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[5];
   assign  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[6];
   assign  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[6];
   assign  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[6];
   assign  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_sign_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign[7];
   assign  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler[7];
   assign  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_fraction_gain_mod = IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction[7];
   assign  FPGA_REG_DL_FH_ANT0_TSSI_ant0_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[0];
   assign  FPGA_REG_DL_FH_ANT1_TSSI_ant1_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[1];
   assign  FPGA_REG_DL_FH_ANT2_TSSI_ant2_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[2];
   assign  FPGA_REG_DL_FH_ANT3_TSSI_ant3_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[3];
   assign  FPGA_REG_DL_FH_ANT4_TSSI_ant4_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[4];
   assign  FPGA_REG_DL_FH_ANT5_TSSI_ant5_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[5];
   assign  FPGA_REG_DL_FH_ANT6_TSSI_ant6_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[6];
   assign  FPGA_REG_DL_FH_ANT7_TSSI_ant7_fh_tssi = IFP_dl_dfe_stat.ant_fh_tssi[7];
   assign  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_dpd_mod = IFP_dl_dfe_stat.bypass_dpd;
   assign  FPGA_REG_DL_DFE_C0_ANT0TO3PULSE_SHAPE_SAT_STAT_car0_ps_sat_flag = IFP_dl_dfe_stat.ps_sat_err_status[0];
   assign  FPGA_REG_DL_DFE_C0_ANT4TO7PULSE_SHAPE_SAT_STAT_car0_ps_sat_flag = IFP_dl_dfe_stat.ps_sat_err_status[1];
   assign  FPGA_REG_DL_DFE_C1_ANT0TO3PULSE_SHAPE_SAT_STAT_car1_ps_sat_flag = IFP_dl_dfe_stat.ps_sat_err_status[2];
   assign  FPGA_REG_DL_DFE_C1_ANT4TO7PULSE_SHAPE_SAT_STAT_car1_ps_sat_flag = IFP_dl_dfe_stat.ps_sat_err_status[3];
   assign  FPGA_REG_DL_DFE_C0A0_INTRP_SAT_STAT_c0a0_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][0];
   assign  FPGA_REG_DL_DFE_C0A1_INTRP_SAT_STAT_c0a1_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][1];
   assign  FPGA_REG_DL_DFE_C0A2_INTRP_SAT_STAT_c0a2_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][2];
   assign  FPGA_REG_DL_DFE_C0A3_INTRP_SAT_STAT_c0a3_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][3];
   assign  FPGA_REG_DL_DFE_C0A4_INTRP_SAT_STAT_c0a4_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][4];
   assign  FPGA_REG_DL_DFE_C0A5_INTRP_SAT_STAT_c0a5_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][5];
   assign  FPGA_REG_DL_DFE_C0A6_INTRP_SAT_STAT_c0a6_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][6];
   assign  FPGA_REG_DL_DFE_C0A7_INTRP_SAT_STAT_c0a7_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[0][7];
   assign  FPGA_REG_DL_DFE_C1A0_INTRP_SAT_STAT_c1a0_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][0];
   assign  FPGA_REG_DL_DFE_C1A1_INTRP_SAT_STAT_c1a1_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][1];
   assign  FPGA_REG_DL_DFE_C1A2_INTRP_SAT_STAT_c1a2_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][2];
   assign  FPGA_REG_DL_DFE_C1A3_INTRP_SAT_STAT_c1a3_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][3];
   assign  FPGA_REG_DL_DFE_C1A4_INTRP_SAT_STAT_c1a4_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][4];
   assign  FPGA_REG_DL_DFE_C1A5_INTRP_SAT_STAT_c1a5_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][5];
   assign  FPGA_REG_DL_DFE_C1A6_INTRP_SAT_STAT_c1a6_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][6];
   assign  FPGA_REG_DL_DFE_C1A7_INTRP_SAT_STAT_c1a7_intrp_sat_flag = IFP_dl_dfe_stat.car_inrtp_sat_err_status[1][7];
   assign  FPGA_REG_DL_DFE_FIR_3X_ANT0TO3_SAT_STAT_fir_3x_ant0to3_sat_flag = IFP_dl_dfe_stat.fir_3x_ant0to3_sat_err_status;
   assign  FPGA_REG_DL_DFE_FIR_3X_ANT4TO7_SAT_STAT_fir_3x_ant4to7_sat_flag = IFP_dl_dfe_stat.fir_3x_ant4to7_sat_err_status;
   assign  FPGA_REG_DL_DFE_POLY_EVEN_ANT0TO3_SAT_STAT_poly_even_ant0to3_sat_flag = IFP_dl_dfe_stat.poly_even_ant0to3_sat_err_status;
   assign  FPGA_REG_DL_DFE_POLY_EVEN_ANT4TO7_SAT_STAT_poly_even_ant4to7_sat_flag = IFP_dl_dfe_stat.poly_even_ant4to7_sat_err_status;
   assign  FPGA_REG_DL_DFE_POLY_ODD_ANT0TO3_SAT_STAT_poly_odd_ant0to3_sat_flag = IFP_dl_dfe_stat.poly_odd_ant0to3_sat_err_status;
   assign  FPGA_REG_DL_DFE_POLY_ODD_ANT4TO7_SAT_STAT_poly_odd_ant4to7_sat_flag = IFP_dl_dfe_stat.poly_odd_ant4to7_sat_err_status;




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a0_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 0
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a0_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 0
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a1_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 1
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a1_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 1
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a2_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 2
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a2_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 2
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a3_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 3
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a3_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 3
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a4_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 4
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a4_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 4
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a5_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 5
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a5_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 5
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a6_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 6
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a6_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 6
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a7_mute_en <= 'h1;  // Mute Enable for Carrier 0 in Antenna 7
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a7_mute_en <= 'h1;  // Mute Enable for Carrier 1 in Antenna 7
                  FPGA_REG_DL_ANT_INT_FRAC_DLY_TRIG_dl_ant_int_frac_delay_trig <= 'h0;  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
                  FPGA_REG_DL_CAR0_NCO_LSB_CFG_dl_car0_nco_lsb <= 'h0;  // [31:0] of NCO value for carrier0
                  FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_msb <= 'h0;  // [38:32] of NCO value for carrier0
                  FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_sign <= 'h0;  // Sign of NCO
                  FPGA_REG_DL_CAR1_NCO_LSB_CFG_dl_car1_nco_lsb <= 'h0;  // [31:0] of NCO value for carrier1
                  FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_msb <= 'h0;  // [38:32] of NCO value for carrier1
                  FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_sign <= 'h0;  // Sign of NCO
                  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q?
                  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
                  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q,  Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set 
                  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
                  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
                  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
                  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
                  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
                  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
                  FPGA_REG_DL_ANT0_DELAY_CFG_dl_ant0_delay <= 'h0;  // Antenna0 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles,
                  FPGA_REG_DL_ANT1_DELAY_CFG_dl_ant1_delay <= 'h0;  // Antenna1 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles, 
                  FPGA_REG_DL_ANT2_DELAY_CFG_dl_ant2_delay <= 'h0;  // Antenna2 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
                  FPGA_REG_DL_ANT3_DELAY_CFG_dl_ant3_delay <= 'h0;  // Antenna3 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
                  FPGA_REG_DL_ANT4_DELAY_CFG_dl_ant4_delay <= 'h0;  // Antenna4 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
                  FPGA_REG_DL_ANT5_DELAY_CFG_dl_ant5_delay <= 'h0;  // Antenna5 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
                  FPGA_REG_DL_ANT6_DELAY_CFG_dl_ant6_delay <= 'h0;  // Antenna6 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
                  FPGA_REG_DL_ANT7_DELAY_CFG_dl_ant7_delay <= 'h0;  // Antenna7 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_dpd <= 'h0;  // This bit is always tied to 0 (RO), DPD bypass is removed to avoid damage to PA during CLGC algorithm. 
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_cfr <= 'h1;  // 1: Bypass CFR  0: Normal operation
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_override_postcfr <= 'h0;  // 1: Override bit to configure the pre DPD Gain (also called postcfr_gain), when this bit set to 0, 6dB gain is added when DPD is not in bypass and remove 6dB gain when DPD is in Bypass.
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_ps_filter_bypass <= 'h0;  // 1:Bypass PS Filter, 0: Normal operation
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_dl_dfe_path_dbg_sel <= 'h0;  // Select the point in DL DFE to be latched into the Debug Buffer for debugging DC Spur
                  FPGA_REG_DL_DFE_CLEAR_SAT_FLAGS_clear_sat_flags <= 'h0;  // Write 0 and then write 1 to clear all the overflow and underflow flags (pos edge)
                  FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_int_delay <= 'h0;  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_frac_delay <= 'h0;  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_int_delay <= 'h0;  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_frac_delay <= 'h0;  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_int_delay <= 'h0;  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_frac_delay <= 'h0;  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_int_delay <= 'h0;  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_frac_delay <= 'h0;  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_int_delay <= 'h0;  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_frac_delay <= 'h0;  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_int_delay <= 'h0;  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_frac_delay <= 'h0;  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_int_delay <= 'h0;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_frac_delay <= 'h0;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_int_delay <= 'h0;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_frac_delay <= 'h0;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_int_delay <= 'h0;  // Carrier 0 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_frac_delay <= 'h0;  // Carrier0 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_int_delay <= 'h0;  // Carrier 1 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_frac_delay <= 'h0;  // Carrier1 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_int_delay <= 'h0;  // Carrier 0 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_frac_delay <= 'h0;  // Carrier0 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_int_delay <= 'h0;  // Carrier 1 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_frac_delay <= 'h0;  // Carrier1 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_int_delay <= 'h0;  // Carrier 0 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_frac_delay <= 'h0;  // Carrier0 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_int_delay <= 'h0;  // Carrier 1 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_frac_delay <= 'h0;  // Carrier1 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_int_delay <= 'h0;  // Carrier 0 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_frac_delay <= 'h0;  // Carrier0 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_int_delay <= 'h0;  // Carrier 1 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_frac_delay <= 'h0;  // Carrier1 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_DL_SCRATCH_DEBUG_pl_debug <= 'h3333_cccc;  // Used by pl for debug
                  FPGA_REG_DL_SCRATCH_scratch <= 'h2222_bbbb;  // 
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h4  : begin //'h10
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a0_mute_en <= IFP_axi_rw.wdata[0];  // Mute Enable for Carrier 0 in Antenna 0
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a0_mute_en <= IFP_axi_rw.wdata[1];  // Mute Enable for Carrier 1 in Antenna 0
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a1_mute_en <= IFP_axi_rw.wdata[8];  // Mute Enable for Carrier 0 in Antenna 1
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a1_mute_en <= IFP_axi_rw.wdata[9];  // Mute Enable for Carrier 1 in Antenna 1
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a2_mute_en <= IFP_axi_rw.wdata[16];  // Mute Enable for Carrier 0 in Antenna 2
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a2_mute_en <= IFP_axi_rw.wdata[17];  // Mute Enable for Carrier 1 in Antenna 2
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a3_mute_en <= IFP_axi_rw.wdata[24];  // Mute Enable for Carrier 0 in Antenna 3
                  FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a3_mute_en <= IFP_axi_rw.wdata[25];  // Mute Enable for Carrier 1 in Antenna 3
             end
      11'h5  : begin //'h14
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a4_mute_en <= IFP_axi_rw.wdata[0];  // Mute Enable for Carrier 0 in Antenna 4
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a4_mute_en <= IFP_axi_rw.wdata[1];  // Mute Enable for Carrier 1 in Antenna 4
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a5_mute_en <= IFP_axi_rw.wdata[8];  // Mute Enable for Carrier 0 in Antenna 5
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a5_mute_en <= IFP_axi_rw.wdata[9];  // Mute Enable for Carrier 1 in Antenna 5
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a6_mute_en <= IFP_axi_rw.wdata[16];  // Mute Enable for Carrier 0 in Antenna 6
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a6_mute_en <= IFP_axi_rw.wdata[17];  // Mute Enable for Carrier 1 in Antenna 6
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a7_mute_en <= IFP_axi_rw.wdata[24];  // Mute Enable for Carrier 0 in Antenna 7
                  FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a7_mute_en <= IFP_axi_rw.wdata[25];  // Mute Enable for Carrier 1 in Antenna 7
             end
      11'h6  : begin //'h18
                  FPGA_REG_DL_ANT_INT_FRAC_DLY_TRIG_dl_ant_int_frac_delay_trig <= IFP_axi_rw.wdata[0];  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
             end
      11'h40  : begin //'h100
                  FPGA_REG_DL_CAR0_NCO_LSB_CFG_dl_car0_nco_lsb <= IFP_axi_rw.wdata[31:0];  // [31:0] of NCO value for carrier0
             end
      11'h41  : begin //'h104
                  FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_msb <= IFP_axi_rw.wdata[6:0];  // [38:32] of NCO value for carrier0
                  FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_sign <= IFP_axi_rw.wdata[7];  // Sign of NCO
             end
      11'h42  : begin //'h108
                  FPGA_REG_DL_CAR1_NCO_LSB_CFG_dl_car1_nco_lsb <= IFP_axi_rw.wdata[31:0];  // [31:0] of NCO value for carrier1
             end
      11'h43  : begin //'h10C
                  FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_msb <= IFP_axi_rw.wdata[6:0];  // [38:32] of NCO value for carrier1
                  FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_sign <= IFP_axi_rw.wdata[7];  // Sign of NCO
             end
      11'h80  : begin //'h200
                  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h81  : begin //'h204
                  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h82  : begin //'h208
                  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h83  : begin //'h20C
                  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h84  : begin //'h210
                  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h85  : begin //'h214
                  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h86  : begin //'h218
                  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h87  : begin //'h21C
                  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h88  : begin //'h220
                  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h89  : begin //'h224
                  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h8a  : begin //'h228
                  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h8b  : begin //'h22C
                  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h8c  : begin //'h230
                  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h8d  : begin //'h234
                  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h8e  : begin //'h238
                  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h8f  : begin //'h23C
                  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q?
             end
      11'h100  : begin //'h400
                  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h101  : begin //'h404
                  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h102  : begin //'h408
                  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h103  : begin //'h40C
                  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h104  : begin //'h410
                  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h105  : begin //'h414
                  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h106  : begin //'h418
                  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h107  : begin //'h41C
                  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h108  : begin //'h420
                  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                  FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q,  Can only be updated when the override bit is set
             end
      11'h109  : begin //'h424
                  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h10a  : begin //'h428
                  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set 
                  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB)?
                  FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10b  : begin //'h42C
                  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10c  : begin //'h430
                  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10d  : begin //'h434
                  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10e  : begin //'h438
                  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10f  : begin //'h43C
                  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                  FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h400  : begin //'h1000
                  FPGA_REG_DL_ANT0_DELAY_CFG_dl_ant0_delay <= IFP_axi_rw.wdata[5:0];  // Antenna0 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles,
             end
      11'h401  : begin //'h1004
                  FPGA_REG_DL_ANT1_DELAY_CFG_dl_ant1_delay <= IFP_axi_rw.wdata[5:0];  // Antenna1 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles, 
             end
      11'h402  : begin //'h1008
                  FPGA_REG_DL_ANT2_DELAY_CFG_dl_ant2_delay <= IFP_axi_rw.wdata[5:0];  // Antenna2 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h403  : begin //'h100C
                  FPGA_REG_DL_ANT3_DELAY_CFG_dl_ant3_delay <= IFP_axi_rw.wdata[5:0];  // Antenna3 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h404  : begin //'h1010
                  FPGA_REG_DL_ANT4_DELAY_CFG_dl_ant4_delay <= IFP_axi_rw.wdata[5:0];  // Antenna4 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h405  : begin //'h1014
                  FPGA_REG_DL_ANT5_DELAY_CFG_dl_ant5_delay <= IFP_axi_rw.wdata[5:0];  // Antenna5 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h406  : begin //'h1018
                  FPGA_REG_DL_ANT6_DELAY_CFG_dl_ant6_delay <= IFP_axi_rw.wdata[5:0];  // Antenna6 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h407  : begin //'h101C
                  FPGA_REG_DL_ANT7_DELAY_CFG_dl_ant7_delay <= IFP_axi_rw.wdata[5:0];  // Antenna7 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h4c2  : begin //'h1308
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_dpd <= IFP_axi_rw.wdata[0];  // This bit is always tied to 0 (RO), DPD bypass is removed to avoid damage to PA during CLGC algorithm. 
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_cfr <= IFP_axi_rw.wdata[1];  // 1: Bypass CFR  0: Normal operation
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_override_postcfr <= IFP_axi_rw.wdata[2];  // 1: Override bit to configure the pre DPD Gain (also called postcfr_gain), when this bit set to 0, 6dB gain is added when DPD is not in bypass and remove 6dB gain when DPD is in Bypass.
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_ps_filter_bypass <= IFP_axi_rw.wdata[3];  // 1:Bypass PS Filter, 0: Normal operation
                  FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_dl_dfe_path_dbg_sel <= IFP_axi_rw.wdata[14:12];  // Select the point in DL DFE to be latched into the Debug Buffer for debugging DC Spur
             end
      11'h4c3  : begin //'h130C
                  FPGA_REG_DL_DFE_CLEAR_SAT_FLAGS_clear_sat_flags <= IFP_axi_rw.wdata[0];  // Write 0 and then write 1 to clear all the overflow and underflow flags (pos edge)
             end
      11'h600  : begin //'h1800
                  FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h601  : begin //'h1804
                  FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h602  : begin //'h1808
                  FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h603  : begin //'h180C
                  FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h604  : begin //'h1810
                  FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h605  : begin //'h1814
                  FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h606  : begin //'h1818
                  FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h607  : begin //'h181C
                  FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h608  : begin //'h1820
                  FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h609  : begin //'h1824
                  FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60a  : begin //'h1828
                  FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60b  : begin //'h182C
                  FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60c  : begin //'h1830
                  FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60d  : begin //'h1834
                  FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60e  : begin //'h1838
                  FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60f  : begin //'h183C
                  FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h7fe  : begin //'h1FF8
                  FPGA_REG_DL_SCRATCH_DEBUG_pl_debug <= IFP_axi_rw.wdata[31:0];  // Used by pl for debug
             end 
	  11'h7ff  : begin //'h1FFC
                  FPGA_REG_DL_SCRATCH_scratch <= IFP_axi_rw.wdata[31:0];  // 
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
      11'h4  : begin//'h10
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a0_mute_en;  // Mute Enable for Carrier 0 in Antenna 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a0_mute_en;  // Mute Enable for Carrier 1 in Antenna 0
                   IFP_axi_rw.rdata[8] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a1_mute_en;  // Mute Enable for Carrier 0 in Antenna 1
                   IFP_axi_rw.rdata[9] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a1_mute_en;  // Mute Enable for Carrier 1 in Antenna 1
                   IFP_axi_rw.rdata[16] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a2_mute_en;  // Mute Enable for Carrier 0 in Antenna 2
                   IFP_axi_rw.rdata[17] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a2_mute_en;  // Mute Enable for Carrier 1 in Antenna 2
                   IFP_axi_rw.rdata[24] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c0a3_mute_en;  // Mute Enable for Carrier 0 in Antenna 3
                   IFP_axi_rw.rdata[25] = FPGA_REG_DL_PATH_MUTE0TO3_dl_c1a3_mute_en;  // Mute Enable for Carrier 1 in Antenna 3
             end
      11'h5  : begin//'h14
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a4_mute_en;  // Mute Enable for Carrier 0 in Antenna 4
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a4_mute_en;  // Mute Enable for Carrier 1 in Antenna 4
                   IFP_axi_rw.rdata[8] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a5_mute_en;  // Mute Enable for Carrier 0 in Antenna 5
                   IFP_axi_rw.rdata[9] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a5_mute_en;  // Mute Enable for Carrier 1 in Antenna 5
                   IFP_axi_rw.rdata[16] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a6_mute_en;  // Mute Enable for Carrier 0 in Antenna 6
                   IFP_axi_rw.rdata[17] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a6_mute_en;  // Mute Enable for Carrier 1 in Antenna 6
                   IFP_axi_rw.rdata[24] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c0a7_mute_en;  // Mute Enable for Carrier 0 in Antenna 7
                   IFP_axi_rw.rdata[25] = FPGA_REG_DL_PATH_MUTE4TO7_dl_c1a7_mute_en;  // Mute Enable for Carrier 1 in Antenna 7
             end
      11'h6  : begin//'h18
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_ANT_INT_FRAC_DLY_TRIG_dl_ant_int_frac_delay_trig;  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
             end
      11'h7  : begin//'h1C
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_DFE_CAR_FLUSH_STATE_dl_dfe_car0_flush_state;  // 1: Carrier0 dfe chain is busy flushing the pipeline, 0: operational or idle state and not in flush state
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_DFE_CAR_FLUSH_STATE_dl_dfe_car1_flush_state;  // 1: Carrier1 dfe chain is busy flushing the pipeline, 0: Not flushing
             end
      11'h40  : begin//'h100
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_CAR0_NCO_LSB_CFG_dl_car0_nco_lsb;  // [31:0] of NCO value for carrier0
             end
      11'h41  : begin//'h104
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_msb;  // [38:32] of NCO value for carrier0
                   IFP_axi_rw.rdata[7] = FPGA_REG_DL_CAR0_NCO_MSB_CFG_dl_car0_nco_sign;  // Sign of NCO
             end
      11'h42  : begin//'h108
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_CAR1_NCO_LSB_CFG_dl_car1_nco_lsb;  // [31:0] of NCO value for carrier1
             end
      11'h43  : begin//'h10C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_msb;  // [38:32] of NCO value for carrier1
                   IFP_axi_rw.rdata[7] = FPGA_REG_DL_CAR1_NCO_MSB_CFG_dl_car1_nco_sign;  // Sign of NCO
             end
      11'h80  : begin//'h200
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A0_GAIN_CFG_dl_c0a0_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h81  : begin//'h204
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A0_GAIN_CFG_dl_c1a0_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h82  : begin//'h208
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A1_GAIN_CFG_dl_c0a1_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h83  : begin//'h20C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A1_GAIN_CFG_dl_c1a1_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h84  : begin//'h210
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A2_GAIN_CFG_dl_c0a2_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h85  : begin//'h214
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A2_GAIN_CFG_dl_c1a2_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h86  : begin//'h218
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A3_GAIN_CFG_dl_c0a3_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h87  : begin//'h21C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A3_GAIN_CFG_dl_c1a3_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h88  : begin//'h220
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A4_GAIN_CFG_dl_c0a4_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h89  : begin//'h224
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A4_GAIN_CFG_dl_c1a4_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h8a  : begin//'h228
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A5_GAIN_CFG_dl_c0a5_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h8b  : begin//'h22C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A5_GAIN_CFG_dl_c1a5_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h8c  : begin//'h230
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A6_GAIN_CFG_dl_c0a6_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h8d  : begin//'h234
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A6_GAIN_CFG_dl_c1a6_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h8e  : begin//'h238
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C0A7_GAIN_CFG_dl_c0a7_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h8f  : begin//'h23C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_scaler;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_C1A7_GAIN_CFG_dl_c1a7_fraction_gain;  // Unsigned multiplier to both I & Q?
             end
      11'h100  : begin//'h400
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT0_PRECFR_GAIN_CFG_dl_ant0_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h101  : begin//'h404
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT1_PRECFR_GAIN_CFG_dl_ant1_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h102  : begin//'h408
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT2_PRECFR_GAIN_CFG_dl_ant2_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h103  : begin//'h40C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT3_PRECFR_GAIN_CFG_dl_ant3_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h104  : begin//'h410
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT4_PRECFR_GAIN_CFG_dl_ant4_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h105  : begin//'h414
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT5_PRECFR_GAIN_CFG_dl_ant5_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h106  : begin//'h418
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT6_PRECFR_GAIN_CFG_dl_ant6_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h107  : begin//'h41C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_scaler;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT7_PRECFR_GAIN_CFG_dl_ant7_precfr_fraction_gain;  // Unsigned multiplier to both I & Q, Default value is 1dB, additional gain needs to  be added to 1dB
             end
      11'h108  : begin//'h420
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB), Default value is 1dB,  
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT0_POSTCFR_GAIN_CFG_dl_ant0_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q,  Can only be updated when the override bit is set
             end
      11'h109  : begin//'h424
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT1_POSTCFR_GAIN_CFG_dl_ant1_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h10a  : begin//'h428
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set 
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB)?
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT2_POSTCFR_GAIN_CFG_dl_ant2_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10b  : begin//'h42C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT3_POSTCFR_GAIN_CFG_dl_ant3_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10c  : begin//'h430
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT4_POSTCFR_GAIN_CFG_dl_ant4_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10d  : begin//'h434
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT5_POSTCFR_GAIN_CFG_dl_ant5_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10e  : begin//'h438
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT6_POSTCFR_GAIN_CFG_dl_ant6_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h10f  : begin//'h43C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_sign_mod;  // When negative (1), shift right, When positive (0), shift left, Can only be updated when the override bit is set  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_scaler_mod;  // Number of bits to be shifted (multiple of 6dB), Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_ANT7_POSTCFR_GAIN_CFG_dl_ant7_postcfr_fraction_gain_mod;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set?
             end
      11'h400  : begin//'h1000
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT0_DELAY_CFG_dl_ant0_delay;  // Antenna0 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles,
             end
      11'h401  : begin//'h1004
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT1_DELAY_CFG_dl_ant1_delay;  // Antenna1 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles, 
             end
      11'h402  : begin//'h1008
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT2_DELAY_CFG_dl_ant2_delay;  // Antenna2 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h403  : begin//'h100C
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT3_DELAY_CFG_dl_ant3_delay;  // Antenna3 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h404  : begin//'h1010
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT4_DELAY_CFG_dl_ant4_delay;  // Antenna4 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h405  : begin//'h1014
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT5_DELAY_CFG_dl_ant5_delay;  // Antenna5 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h406  : begin//'h1018
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT6_DELAY_CFG_dl_ant6_delay;  // Antenna6 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h407  : begin//'h101C
                   IFP_axi_rw.rdata[5:0] = FPGA_REG_DL_ANT7_DELAY_CFG_dl_ant7_delay;  // Antenna7 delay path in number of cycles at clock 491.52Mhz, Maxmimum delay=32 cycles
             end
      11'h408  : begin//'h1020
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT0_TSSI_ant0_fh_tssi;  // Antenna 0 Path FH TSSI
             end
      11'h409  : begin//'h1024
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT1_TSSI_ant1_fh_tssi;  // Antenna 1 Path FH TSSI
             end
      11'h40a  : begin//'h1028
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT2_TSSI_ant2_fh_tssi;  // Antenna 2 Path FH TSSI
             end
      11'h40b  : begin//'h102C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT3_TSSI_ant3_fh_tssi;  // Antenna 3 Path FH TSSI
             end
      11'h40c  : begin//'h1030
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT4_TSSI_ant4_fh_tssi;  // Antenna 4 Path FH TSSI
             end
      11'h40d  : begin//'h1034
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT5_TSSI_ant5_fh_tssi;  // Antenna 5 Path FH TSSI
             end
      11'h40e  : begin//'h1038
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT6_TSSI_ant6_fh_tssi;  // Antenna 6 Path FH TSSI
             end
      11'h40f  : begin//'h103C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_FH_ANT7_TSSI_ant7_fh_tssi;  // Antenna 7 Path FH TSSI
             end
      11'h4c2  : begin//'h1308
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_dpd_mod;  // This bit is always tied to 0 (RO), DPD bypass is removed to avoid damage to PA during CLGC algorithm. 
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_bypass_cfr;  // 1: Bypass CFR  0: Normal operation
                   IFP_axi_rw.rdata[2] = FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_override_postcfr;  // 1: Override bit to configure the pre DPD Gain (also called postcfr_gain), when this bit set to 0, 6dB gain is added when DPD is not in bypass and remove 6dB gain when DPD is in Bypass.
                   IFP_axi_rw.rdata[3] = FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_ps_filter_bypass;  // 1:Bypass PS Filter, 0: Normal operation
                   IFP_axi_rw.rdata[14:12] = FPGA_REG_DL_DFE_BYPASS_BLOCKS_CFG_dl_dfe_path_dbg_sel;  // Select the point in DL DFE to be latched into the Debug Buffer for debugging DC Spur
             end
      11'h4c3  : begin//'h130C
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_DFE_CLEAR_SAT_FLAGS_clear_sat_flags;  // Write 0 and then write 1 to clear all the overflow and underflow flags (pos edge)
             end
      11'h500  : begin//'h1400
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0_ANT0TO3PULSE_SHAPE_SAT_STAT_car0_ps_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for Ant3
             end
      11'h501  : begin//'h1404
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0_ANT4TO7PULSE_SHAPE_SAT_STAT_car0_ps_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for Ant7
             end
      11'h502  : begin//'h1408
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1_ANT0TO3PULSE_SHAPE_SAT_STAT_car1_ps_sat_flag;  // sam as above 128
             end
      11'h503  : begin//'h140C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1_ANT4TO7PULSE_SHAPE_SAT_STAT_car1_ps_sat_flag;  // sam as above 129
             end
      11'h504  : begin//'h1410
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A0_INTRP_SAT_STAT_c0a0_intrp_sat_flag;  // Saturation Flag for Interpolatror 0 (first 2X Filter), Valid for all BandwidthsBit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id errorSaturation Flag for Interpolatror 1 (Second 2X Filter), Valid for all BandwidthsBit [8] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [9] - All the MSB bits in I (real part) from FIR are checked and reportedBit [10] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [11] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [15] - FIR internal error, set when there is channel id errorSaturation Flag for Interpolatror 2 (Third 2X Filter), Valid for 10Mhz BWBit [16] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [17] - All the MSB bits in I (real part) from FIR are checked and reportedBit [18] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [19] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [23] - FIR internal error, set when there is channel id errorSaturation Flag for Interpolatror 3 (Third 2X Filter), Valid for 5Mhz BWBit [24] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [25] - All the MSB bits in I (real part) from FIR are checked and reportedBit [26] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [27] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [31] - FIR internal error, set when there is channel id error
             end
      11'h505  : begin//'h1414
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A1_INTRP_SAT_STAT_c0a1_intrp_sat_flag;  // Same as above
             end
      11'h506  : begin//'h1418
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A2_INTRP_SAT_STAT_c0a2_intrp_sat_flag;  // Same as above
             end
      11'h507  : begin//'h141C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A3_INTRP_SAT_STAT_c0a3_intrp_sat_flag;  // Same as above
             end
      11'h508  : begin//'h1420
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A4_INTRP_SAT_STAT_c0a4_intrp_sat_flag;  // Same as above
             end
      11'h509  : begin//'h1424
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A5_INTRP_SAT_STAT_c0a5_intrp_sat_flag;  // Same as above
             end
      11'h50a  : begin//'h1428
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A6_INTRP_SAT_STAT_c0a6_intrp_sat_flag;  // Same as above
             end
      11'h50b  : begin//'h142C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C0A7_INTRP_SAT_STAT_c0a7_intrp_sat_flag;  // Same as above
             end
      11'h50c  : begin//'h1430
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A0_INTRP_SAT_STAT_c1a0_intrp_sat_flag;  // Same as above
             end
      11'h50d  : begin//'h1434
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A1_INTRP_SAT_STAT_c1a1_intrp_sat_flag;  // Same as above
             end
      11'h50e  : begin//'h1438
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A2_INTRP_SAT_STAT_c1a2_intrp_sat_flag;  // Same as above
             end
      11'h50f  : begin//'h143C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A3_INTRP_SAT_STAT_c1a3_intrp_sat_flag;  // Same as above
             end
      11'h510  : begin//'h1440
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A4_INTRP_SAT_STAT_c1a4_intrp_sat_flag;  // Same as above
             end
      11'h511  : begin//'h1444
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A5_INTRP_SAT_STAT_c1a5_intrp_sat_flag;  // Same as above
             end
      11'h512  : begin//'h1448
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A6_INTRP_SAT_STAT_c1a6_intrp_sat_flag;  // Same as above
             end
      11'h513  : begin//'h144C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_C1A7_INTRP_SAT_STAT_c1a7_intrp_sat_flag;  // Same as above
             end
      11'h514  : begin//'h1450
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_FIR_3X_ANT0TO3_SAT_STAT_fir_3x_ant0to3_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for An3
             end
      11'h515  : begin//'h1454
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_FIR_3X_ANT4TO7_SAT_STAT_fir_3x_ant4to7_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for An7
             end
      11'h516  : begin//'h1458
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_POLY_EVEN_ANT0TO3_SAT_STAT_poly_even_ant0to3_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for An3
             end
      11'h517  : begin//'h145C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_POLY_EVEN_ANT4TO7_SAT_STAT_poly_even_ant4to7_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for An7
             end
      11'h518  : begin//'h1460
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_POLY_ODD_ANT0TO3_SAT_STAT_poly_odd_ant0to3_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant1[23:16] for Ant2[31:16] for An3
             end
      11'h519  : begin//'h1464
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_DFE_POLY_ODD_ANT4TO7_SAT_STAT_poly_odd_ant4to7_sat_flag;  // Bit [0] - Saturtion Flag for I (real part), only 2 valid MSBs are used for checking saturationBit [1] - All the MSB bits in I (real part) from FIR are checked and reportedBit [2] - Saturtion Flag for Q (imag part), only 2 valid MSBs are used for checking saturationBit [3] - All the MSB bits in Q (real part) from FIR are checked and reportedBit [7] - FIR internal error, set when there is channel id error[15:8] for Ant5[23:16] for Ant6[31:16] for An7
             end
      11'h600  : begin//'h1800
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_int_delay;  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A0_DELAY_CFG_dl_c0a0_frac_delay;  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h601  : begin//'h1804
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_int_delay;  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A0_DELAY_CFG_dl_c1a0_frac_delay;  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h602  : begin//'h1808
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_int_delay;  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A1_DELAY_CFG_dl_c0a1_frac_delay;  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h603  : begin//'h180C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_int_delay;  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A1_DELAY_CFG_dl_c1a1_frac_delay;  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h604  : begin//'h1810
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_int_delay;  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A2_DELAY_CFG_dl_c0a2_frac_delay;  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h605  : begin//'h1814
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_int_delay;  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A2_DELAY_CFG_dl_c1a2_frac_delay;  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h606  : begin//'h1818
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_int_delay;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A3_DELAY_CFG_dl_c0a3_frac_delay;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h607  : begin//'h181C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_int_delay;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A3_DELAY_CFG_dl_c1a3_frac_delay;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h608  : begin//'h1820
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_int_delay;  // Carrier 0 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A4_DELAY_CFG_dl_c0a4_frac_delay;  // Carrier0 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h609  : begin//'h1824
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_int_delay;  // Carrier 1 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A4_DELAY_CFG_dl_c1a4_frac_delay;  // Carrier1 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60a  : begin//'h1828
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_int_delay;  // Carrier 0 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A5_DELAY_CFG_dl_c0a5_frac_delay;  // Carrier0 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60b  : begin//'h182C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_int_delay;  // Carrier 1 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A5_DELAY_CFG_dl_c1a5_frac_delay;  // Carrier1 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60c  : begin//'h1830
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_int_delay;  // Carrier 0 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A6_DELAY_CFG_dl_c0a6_frac_delay;  // Carrier0 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60d  : begin//'h1834
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_int_delay;  // Carrier 1 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A6_DELAY_CFG_dl_c1a6_frac_delay;  // Carrier1 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60e  : begin//'h1838
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_int_delay;  // Carrier 0 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C0A7_DELAY_CFG_dl_c0a7_frac_delay;  // Carrier0 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60f  : begin//'h183C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_int_delay;  // Carrier 1 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_DL_C1A7_DELAY_CFG_dl_c1a7_frac_delay;  // Carrier1 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h7fe  : begin//'h1FF8
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_SCRATCH_DEBUG_pl_debug;  // Used by pl for debug
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_SCRATCH_scratch;  // 
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule