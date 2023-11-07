
module jb_ul_dfe_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_ul_dfe_ctrl_if.ctrl         IFP_ul_dfe_ctrl,
    jb_ul_dfe_stat_if.stat         IFP_ul_dfe_stat 
);



////////////////Register Field Declarations//////////////////

   logic                     FPGA_REG_UL_ANT_INT_FRAC_DLY_TRIG_ul_ant_int_frac_delay_trig;
  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
   logic                     FPGA_REG_UL_DFE_CAR_FLUSH_STATE_ul_dfe_car0_flush_state;
  // 1: Carrier0 dfe chain is busy flushing the pipeline, 0: operational or iULe state and not in flush state
   logic                     FPGA_REG_UL_DFE_CAR_FLUSH_STATE_ul_dfe_car1_flush_state;
  // 1: Carrier1 dfe chain is busy flushing the pipeline, 0: Not flushing
   logic  [31:0]              FPGA_REG_UL_CAR0_NCO_LSB_CFG_ul_car0_nco_lsb;
  // [31:0] of NCO value for carrier0
   logic  [6:0]              FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_msb;
  // [38:32] of NCO value for carrier0
   logic                     FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_sign;
  //  Sign of NCO
   logic  [31:0]              FPGA_REG_UL_CAR1_NCO_LSB_CFG_ul_car1_nco_lsb;
  // [31:0] of NCO value for carrier1
   logic  [6:0]              FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_msb;
  // [38:32] of NCO value for carrier1, 
   logic                     FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_sign;
  //  Sign of NCO
   logic                     FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic  [31:0]              FPGA_REG_UL_C0A0_RSSI_CFG_ul_c0a0_rssi;
  // Carrier0 in Antenna 0 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A0_RSSI_CFG_ul_c1a0_rssi;
  // Carrier1 in Antenna 0 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C0A1_RSSI_CFG_ul_c0a1_rssi;
  // Carrier0 in Antenna 1 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A1_RSSI_CFG_ul_c1a1_rssi;
  // Carrier1 in Antenna 1 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C0A2_RSSI_CFG_ul_c0a2_rssi;
  // Carrier0 in Antenna 2 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A2_RSSI_CFG_ul_c1a2_rssi;
  // Carrier1 in Antenna 2 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C0A3_RSSI_CFG_ul_c0a3_rssi;
  // Carrier0 in Antenna 3 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A3_RSSI_CFG_ul_c1a3_rssi;
  // Carrier1 in Antenna 3 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C0A4_RSSI_CFG_ul_c0a4_rssi;
  // Carrier0 in Antenna 4 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A4_RSSI_CFG_ul_c1a4_rssi;
  // Carrier1 in Antenna 4 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C0A5_RSSI_CFG_ul_c0a5_rssi;
  // Carrier0 in Antenna 5 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A5_RSSI_CFG_ul_c1a5_rssi;
  // Carrier1 in Antenna 5 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C0A6_RSSI_CFG_ul_c0a6_rssi;
  // Carrier0 in Antenna 6 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A6_RSSI_CFG_ul_c1a6_rssi;
  // Carrier1 in Antenna 6 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C0A7_RSSI_CFG_ul_c0a7_rssi;
  // Carrier0 in Antenna 7 Path  RSSI Register
   logic  [31:0]              FPGA_REG_UL_C1A7_RSSI_CFG_ul_c1a7_rssi;
  // Carrier1 in Antenna 7 Path  RSSI Register
   logic  [6:0]              FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_int_delay;
  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_frac_delay;
  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_int_delay;
  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_frac_delay;
  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_int_delay;
  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_frac_delay;
  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_int_delay;
  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_frac_delay;
  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_int_delay;
  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_frac_delay;
  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_int_delay;
  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_frac_delay;
  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_int_delay;
  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_frac_delay;
  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_int_delay;
  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_frac_delay;
  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_int_delay;
  // Carrier 0 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_frac_delay;
  // Carrier0 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_int_delay;
  // Carrier 1 & Antenna 4 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_frac_delay;
  // Carrier1 & Antenna4 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_int_delay;
  // Carrier 0 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_frac_delay;
  // Carrier0 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_int_delay;
  // Carrier 1 & Antenna 5 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_frac_delay;
  // Carrier1 & Antenna5 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_int_delay;
  // Carrier 0 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_frac_delay;
  // Carrier0 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_int_delay;
  // Carrier 1 & Antenna 6 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_frac_delay;
  // Carrier1 & Antenna6 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_int_delay;
  // Carrier 0 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_frac_delay;
  // Carrier0 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [6:0]              FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_int_delay;
  // Carrier 1 & Antenna 7 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
   logic  [15:0]              FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_frac_delay;
  // Carrier1 & Antenna7 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
   logic  [31:0]              FPGA_REG_UL_SCRATCH_ul_scratch;
  // 








////////////////ASSIGN PARAMETERS//////////////////





////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_ul_dfe_ctrl.ul_ant_int_frac_delay_trig =  FPGA_REG_UL_ANT_INT_FRAC_DLY_TRIG_ul_ant_int_frac_delay_trig;
   assign  IFP_ul_dfe_ctrl.ul_car_nco_lsb[0] =  FPGA_REG_UL_CAR0_NCO_LSB_CFG_ul_car0_nco_lsb;
   assign  IFP_ul_dfe_ctrl.ul_car_nco_msb[0] =  FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_msb;
   assign  IFP_ul_dfe_ctrl.ul_car_nco_sign[0] =  FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_sign;
   assign  IFP_ul_dfe_ctrl.ul_car_nco_lsb[1] =  FPGA_REG_UL_CAR1_NCO_LSB_CFG_ul_car1_nco_lsb;
   assign  IFP_ul_dfe_ctrl.ul_car_nco_msb[1] =  FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_msb;
   assign  IFP_ul_dfe_ctrl.ul_car_nco_sign[1] =  FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][0] =  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][0] =  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][0] =  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][0] =  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][0] =  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][0] =  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][1] =  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][1] =  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][1] =  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][1] =  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][1] =  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][1] =  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][2] =  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][2] =  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][2] =  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][2] =  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][2] =  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][2] =  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][3] =  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][3] =  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][3] =  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][3] =  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][3] =  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][3] =  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][4] =  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][4] =  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][4] =  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][4] =  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][4] =  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][4] =  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][5] =  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][5] =  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][5] =  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][5] =  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][5] =  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][5] =  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][6] =  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][6] =  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][6] =  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][6] =  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][6] =  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][6] =  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[0][7] =  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[0][7] =  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[0][7] =  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[1][7] =  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[1][7] =  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler;
   assign  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[1][7] =  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[0] =  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[0] =  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[0] =  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[1] =  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[1] =  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[1] =  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[2] =  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[2] =  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[2] =  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[3] =  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[3] =  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[3] =  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[4] =  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[4] =  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[4] =  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[5] =  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[5] =  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[5] =  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[6] =  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[6] =  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[6] =  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_fraction_gain;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[7] =  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler_sign;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_scaler[7] =  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler;
   assign  IFP_ul_dfe_ctrl.ul_ant_gain_fraction[7] =  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_fraction_gain;
   
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][0] =  FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][0] =  FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][1] =  FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_int_delay;	
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][1] =  FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_int_delay;   
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][2] =  FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_int_delay;   
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][2] =  FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_int_delay;   
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][3] =  FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_int_delay;   
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][3] =  FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_int_delay;   
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][4] =  FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][4] =  FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][5] =  FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][5] =  FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][6] =  FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][6] =  FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[0][7] =  FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_int_delay;
   assign  IFP_ul_dfe_ctrl.ul_int_delay[1][7] =  FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_int_delay;   
   
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][0] =  FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][0] =  FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][1] =  FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][1] =  FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][2] =  FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][2] =  FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][3] =  FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][3] =  FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][4] =  FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][4] =  FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][5] =  FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][5] =  FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][6] =  FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][6] =  FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[0][7] =  FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_frac_delay;
   assign  IFP_ul_dfe_ctrl.ul_frac_delay[1][7] =  FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_frac_delay;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  FPGA_REG_UL_DFE_CAR_FLUSH_STATE_ul_dfe_car0_flush_state = IFP_ul_dfe_stat.ul_dfe_car_flush_state[0];
   assign  FPGA_REG_UL_DFE_CAR_FLUSH_STATE_ul_dfe_car1_flush_state = IFP_ul_dfe_stat.ul_dfe_car_flush_state[1];
   assign  FPGA_REG_UL_C0A0_RSSI_CFG_ul_c0a0_rssi = IFP_ul_dfe_stat.rssi[0][0];
   assign  FPGA_REG_UL_C1A0_RSSI_CFG_ul_c1a0_rssi = IFP_ul_dfe_stat.rssi[1][0];
   assign  FPGA_REG_UL_C0A1_RSSI_CFG_ul_c0a1_rssi = IFP_ul_dfe_stat.rssi[0][1];
   assign  FPGA_REG_UL_C1A1_RSSI_CFG_ul_c1a1_rssi = IFP_ul_dfe_stat.rssi[1][1];
   assign  FPGA_REG_UL_C0A2_RSSI_CFG_ul_c0a2_rssi = IFP_ul_dfe_stat.rssi[0][2];
   assign  FPGA_REG_UL_C1A2_RSSI_CFG_ul_c1a2_rssi = IFP_ul_dfe_stat.rssi[1][2];
   assign  FPGA_REG_UL_C0A3_RSSI_CFG_ul_c0a3_rssi = IFP_ul_dfe_stat.rssi[0][3];
   assign  FPGA_REG_UL_C1A3_RSSI_CFG_ul_c1a3_rssi = IFP_ul_dfe_stat.rssi[1][3];
   assign  FPGA_REG_UL_C0A4_RSSI_CFG_ul_c0a4_rssi = IFP_ul_dfe_stat.rssi[0][4];
   assign  FPGA_REG_UL_C1A4_RSSI_CFG_ul_c1a4_rssi = IFP_ul_dfe_stat.rssi[1][4];
   assign  FPGA_REG_UL_C0A5_RSSI_CFG_ul_c0a5_rssi = IFP_ul_dfe_stat.rssi[0][5];
   assign  FPGA_REG_UL_C1A5_RSSI_CFG_ul_c1a5_rssi = IFP_ul_dfe_stat.rssi[1][5];
   assign  FPGA_REG_UL_C0A6_RSSI_CFG_ul_c0a6_rssi = IFP_ul_dfe_stat.rssi[0][6];
   assign  FPGA_REG_UL_C1A6_RSSI_CFG_ul_c1a6_rssi = IFP_ul_dfe_stat.rssi[1][6];
   assign  FPGA_REG_UL_C0A7_RSSI_CFG_ul_c0a7_rssi = IFP_ul_dfe_stat.rssi[0][7];
   assign  FPGA_REG_UL_C1A7_RSSI_CFG_ul_c1a7_rssi = IFP_ul_dfe_stat.rssi[1][7];




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_UL_ANT_INT_FRAC_DLY_TRIG_ul_ant_int_frac_delay_trig <= 'h0;  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
                  FPGA_REG_UL_CAR0_NCO_LSB_CFG_ul_car0_nco_lsb <= 'h0;  // [31:0] of NCO value for carrier0
                  FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_msb <= 'h0;  // [38:32] of NCO value for carrier0
                  FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_sign <= 'h0;  //  Sign of NCO
                  FPGA_REG_UL_CAR1_NCO_LSB_CFG_ul_car1_nco_lsb <= 'h0;  // [31:0] of NCO value for carrier1
                  FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_msb <= 'h0;  // [38:32] of NCO value for carrier1, 
                  FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_sign <= 'h0;  //  Sign of NCO
                  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_int_delay <= 'h0;  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_frac_delay <= 'h0;  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_int_delay <= 'h0;  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_frac_delay <= 'h0;  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_int_delay <= 'h0;  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_frac_delay <= 'h0;  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_int_delay <= 'h0;  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_frac_delay <= 'h0;  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_int_delay <= 'h0;  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_frac_delay <= 'h0;  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_int_delay <= 'h0;  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_frac_delay <= 'h0;  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_int_delay <= 'h0;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_frac_delay <= 'h0;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_int_delay <= 'h0;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_frac_delay <= 'h0;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_int_delay <= 'h0;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_frac_delay <= 'h0;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_int_delay <= 'h0;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_frac_delay <= 'h0;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_int_delay <= 'h0;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_frac_delay <= 'h0;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_int_delay <= 'h0;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_frac_delay <= 'h0;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_int_delay <= 'h0;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_frac_delay <= 'h0;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_int_delay <= 'h0;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_frac_delay <= 'h0;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_int_delay <= 'h0;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_frac_delay <= 'h0;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_int_delay <= 'h0;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_frac_delay <= 'h0;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
                  FPGA_REG_UL_SCRATCH_ul_scratch <= 'h4444_dddd;  // 
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h6  : begin //'h18
                  FPGA_REG_UL_ANT_INT_FRAC_DLY_TRIG_ul_ant_int_frac_delay_trig <= IFP_axi_rw.wdata[0];  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
             end
      11'h40  : begin //'h100
                  FPGA_REG_UL_CAR0_NCO_LSB_CFG_ul_car0_nco_lsb <= IFP_axi_rw.wdata[31:0];  // [31:0] of NCO value for carrier0
             end
      11'h41  : begin //'h104
                  FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_msb <= IFP_axi_rw.wdata[6:0];  // [38:32] of NCO value for carrier0
                  FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_sign <= IFP_axi_rw.wdata[7];  //  Sign of NCO
             end
      11'h42  : begin //'h108
                  FPGA_REG_UL_CAR1_NCO_LSB_CFG_ul_car1_nco_lsb <= IFP_axi_rw.wdata[31:0];  // [31:0] of NCO value for carrier1
             end
      11'h43  : begin //'h10C
                  FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_msb <= IFP_axi_rw.wdata[6:0];  // [38:32] of NCO value for carrier1, 
                  FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_sign <= IFP_axi_rw.wdata[7];  //  Sign of NCO
             end
      11'h80  : begin //'h200
                  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h81  : begin //'h204
                  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h82  : begin //'h208
                  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h83  : begin //'h20C
                  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h84  : begin //'h210
                  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h85  : begin //'h214
                  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h86  : begin //'h218
                  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h87  : begin //'h21C
                  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h88  : begin //'h220
                  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h89  : begin //'h224
                  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h8a  : begin //'h228
                  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h8b  : begin //'h22C
                  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h8c  : begin //'h230
                  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h8d  : begin //'h234
                  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h8e  : begin //'h238
                  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h8f  : begin //'h23C
                  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h100  : begin //'h400
                  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h101  : begin //'h404
                  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h102  : begin //'h408
                  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h103  : begin //'h40C
                  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h104  : begin //'h410
                  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h105  : begin //'h414
                  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h106  : begin //'h418
                  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h107  : begin //'h41C
                  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h600  : begin //'h1800
                  FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h601  : begin //'h1804
                  FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h602  : begin //'h1808
                  FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h603  : begin //'h180C
                  FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h604  : begin //'h1810
                  FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h605  : begin //'h1814
                  FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h606  : begin //'h1818
                  FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h607  : begin //'h181C
                  FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h608  : begin //'h1820
                  FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h609  : begin //'h1824
                  FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60a  : begin //'h1828
                  FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60b  : begin //'h182C
                  FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60c  : begin //'h1830
                  FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60d  : begin //'h1834
                  FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60e  : begin //'h1838
                  FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60f  : begin //'h183C
                  FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_int_delay <= IFP_axi_rw.wdata[6:0];  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                  FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_frac_delay <= IFP_axi_rw.wdata[31:16];  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h7ff  : begin //'h1FFC
                  FPGA_REG_UL_SCRATCH_ul_scratch <= IFP_axi_rw.wdata[31:0];  // 
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
      11'h6  : begin//'h18
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_ANT_INT_FRAC_DLY_TRIG_ul_ant_int_frac_delay_trig;  // 1: when set  the new Antenna integer and fractional delays values take into effect. This register need to be written 0 and then written 1 whenever the new Ant integer and fracional delays are configured.
             end
      11'h7  : begin//'h1C
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_DFE_CAR_FLUSH_STATE_ul_dfe_car0_flush_state;  // 1: Carrier0 dfe chain is busy flushing the pipeline, 0: operational or iULe state and not in flush state
                   IFP_axi_rw.rdata[1] = FPGA_REG_UL_DFE_CAR_FLUSH_STATE_ul_dfe_car1_flush_state;  // 1: Carrier1 dfe chain is busy flushing the pipeline, 0: Not flushing
             end
      11'h40  : begin//'h100
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_CAR0_NCO_LSB_CFG_ul_car0_nco_lsb;  // [31:0] of NCO value for carrier0
             end
      11'h41  : begin//'h104
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_msb;  // [38:32] of NCO value for carrier0
                   IFP_axi_rw.rdata[7] = FPGA_REG_UL_CAR0_NCO_MSB_CFG_ul_car0_nco_sign;  //  Sign of NCO
             end
      11'h42  : begin//'h108
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_CAR1_NCO_LSB_CFG_ul_car1_nco_lsb;  // [31:0] of NCO value for carrier1
             end
      11'h43  : begin//'h10C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_msb;  // [38:32] of NCO value for carrier1, 
                   IFP_axi_rw.rdata[7] = FPGA_REG_UL_CAR1_NCO_MSB_CFG_ul_car1_nco_sign;  //  Sign of NCO
             end
      11'h80  : begin//'h200
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A0_GAIN_CFG_ul_c0a0_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h81  : begin//'h204
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A0_GAIN_CFG_ul_c1a0_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h82  : begin//'h208
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A1_GAIN_CFG_ul_c0a1_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h83  : begin//'h20C
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A1_GAIN_CFG_ul_c1a1_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h84  : begin//'h210
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A2_GAIN_CFG_ul_c0a2_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h85  : begin//'h214
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A2_GAIN_CFG_ul_c1a2_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h86  : begin//'h218
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A3_GAIN_CFG_ul_c0a3_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h87  : begin//'h21C
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A3_GAIN_CFG_ul_c1a3_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h88  : begin//'h220
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A4_GAIN_CFG_ul_c0a4_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h89  : begin//'h224
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A4_GAIN_CFG_ul_c1a4_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h8a  : begin//'h228
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A5_GAIN_CFG_ul_c0a5_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h8b  : begin//'h22C
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A5_GAIN_CFG_ul_c1a5_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h8c  : begin//'h230
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A6_GAIN_CFG_ul_c0a6_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h8d  : begin//'h234
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A6_GAIN_CFG_ul_c1a6_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h8e  : begin//'h238
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C0A7_GAIN_CFG_ul_c0a7_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h8f  : begin//'h23C
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_C1A7_GAIN_CFG_ul_c1a7_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h100  : begin//'h400
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT0_GAIN_CFG_ul_ant0_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h101  : begin//'h404
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT1_GAIN_CFG_ul_ant1_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h102  : begin//'h408
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT2_GAIN_CFG_ul_ant2_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h103  : begin//'h40C
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT3_GAIN_CFG_ul_ant3_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h104  : begin//'h410
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT4_GAIN_CFG_ul_ant4_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h105  : begin//'h414
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT5_GAIN_CFG_ul_ant5_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h106  : begin//'h418
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT6_GAIN_CFG_ul_ant6_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h107  : begin//'h41C
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_ANT7_GAIN_CFG_ul_ant7_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h480  : begin//'h1200
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A0_RSSI_CFG_ul_c0a0_rssi;  // Carrier0 in Antenna 0 Path  RSSI Register
             end
      11'h481  : begin//'h1204
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A0_RSSI_CFG_ul_c1a0_rssi;  // Carrier1 in Antenna 0 Path  RSSI Register
             end
      11'h482  : begin//'h1208
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A1_RSSI_CFG_ul_c0a1_rssi;  // Carrier0 in Antenna 1 Path  RSSI Register
             end
      11'h483  : begin//'h120C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A1_RSSI_CFG_ul_c1a1_rssi;  // Carrier1 in Antenna 1 Path  RSSI Register
             end
      11'h484  : begin//'h1210
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A2_RSSI_CFG_ul_c0a2_rssi;  // Carrier0 in Antenna 2 Path  RSSI Register
             end
      11'h485  : begin//'h1214
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A2_RSSI_CFG_ul_c1a2_rssi;  // Carrier1 in Antenna 2 Path  RSSI Register
             end
      11'h486  : begin//'h1218
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A3_RSSI_CFG_ul_c0a3_rssi;  // Carrier0 in Antenna 3 Path  RSSI Register
             end
      11'h487  : begin//'h121C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A3_RSSI_CFG_ul_c1a3_rssi;  // Carrier1 in Antenna 3 Path  RSSI Register
             end
      11'h488  : begin//'h1220
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A4_RSSI_CFG_ul_c0a4_rssi;  // Carrier0 in Antenna 4 Path  RSSI Register
             end
      11'h489  : begin//'h1224
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A4_RSSI_CFG_ul_c1a4_rssi;  // Carrier1 in Antenna 4 Path  RSSI Register
             end
      11'h48a  : begin//'h1228
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A5_RSSI_CFG_ul_c0a5_rssi;  // Carrier0 in Antenna 5 Path  RSSI Register
             end
      11'h48b  : begin//'h122C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A5_RSSI_CFG_ul_c1a5_rssi;  // Carrier1 in Antenna 5 Path  RSSI Register
             end
      11'h48c  : begin//'h1230
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A6_RSSI_CFG_ul_c0a6_rssi;  // Carrier0 in Antenna 6 Path  RSSI Register
             end
      11'h48d  : begin//'h1234
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A6_RSSI_CFG_ul_c1a6_rssi;  // Carrier1 in Antenna 6 Path  RSSI Register
             end
      11'h48e  : begin//'h1238
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0A7_RSSI_CFG_ul_c0a7_rssi;  // Carrier0 in Antenna 7 Path  RSSI Register
             end
      11'h48f  : begin//'h123C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1A7_RSSI_CFG_ul_c1a7_rssi;  // Carrier1 in Antenna 7 Path  RSSI Register
             end
      11'h600  : begin//'h1800
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_int_delay;  // Carrier 0 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A0_DELAY_CFG_ul_c0a0_frac_delay;  // Carrier0 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h601  : begin//'h1804
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_int_delay;  // Carrier 1 & Antenna 0 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A0_DELAY_CFG_ul_c1a0_frac_delay;  // Carrier1 & Antenna0 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h602  : begin//'h1808
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_int_delay;  // Carrier 0 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A1_DELAY_CFG_ul_c0a1_frac_delay;  // Carrier0 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h603  : begin//'h180C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_int_delay;  // Carrier 1 & Antenna 1 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A1_DELAY_CFG_ul_c1a1_frac_delay;  // Carrier1 & Antenna1 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h604  : begin//'h1810
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_int_delay;  // Carrier 0 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A2_DELAY_CFG_ul_c0a2_frac_delay;  // Carrier0 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h605  : begin//'h1814
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_int_delay;  // Carrier 1 & Antenna 2 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A2_DELAY_CFG_ul_c1a2_frac_delay;  // Carrier1 & Antenna2 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h606  : begin//'h1818
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_int_delay;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A3_DELAY_CFG_ul_c0a3_frac_delay;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h607  : begin//'h181C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_int_delay;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A3_DELAY_CFG_ul_c1a3_frac_delay;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h608  : begin//'h1820
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_int_delay;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A4_DELAY_CFG_ul_c0a4_frac_delay;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h609  : begin//'h1824
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_int_delay;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A4_DELAY_CFG_ul_c1a4_frac_delay;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60a  : begin//'h1828
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_int_delay;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A5_DELAY_CFG_ul_c0a5_frac_delay;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60b  : begin//'h182C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_int_delay;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A5_DELAY_CFG_ul_c1a5_frac_delay;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60c  : begin//'h1830
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_int_delay;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A6_DELAY_CFG_ul_c0a6_frac_delay;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60d  : begin//'h1834
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_int_delay;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A6_DELAY_CFG_ul_c1a6_frac_delay;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60e  : begin//'h1838
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_int_delay;  // Carrier 0 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C0A7_DELAY_CFG_ul_c0a7_frac_delay;  // Carrier0 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h60f  : begin//'h183C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_int_delay;  // Carrier 1 & Antenna 3 Int Delay, Valid range is -64 to 63. This field is in2's Complement form
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_UL_C1A7_DELAY_CFG_ul_c1a7_frac_delay;  // Carrier1 & Antenna3 fractional delay, register is signed 16-bit with 0 integer bits and 15 fractional bits with range [-1, 1).   The actual allowed range is [-0.9 to 0.9], It is in 2's complement form
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_SCRATCH_ul_scratch;  // 
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule