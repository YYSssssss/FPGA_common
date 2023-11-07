
module jb_oran_lphy_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_oran_lphy_ctrl_if.ctrl         IFP_oran_lphy_ctrl,
    jb_oran_lphy_stat_if.stat         IFP_oran_lphy_stat 
);



////////////////Register Field Declarations//////////////////

   logic                     FPGA_REG_DL_LPHY_MISC_CFG_dl_swap_ifft;
  // 1. Swap the 2 halves of tones in DL
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_ul_swap_fft;
  // 1. Swap the 2 halves of tones in UL
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_prach_swap_fft;
  // 1. Swap the 2 halves of tones in PRACH
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_dl_iq_endianness;
  // 0: Big Endian, 1: Little Endian
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_ul_iq_endianness;
  // 0: Big Endian, 1: Little Endian
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_prach_iq_endianness;
  // 0: Big Endian, 1: Little Endian
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_c0_dl_ifft_gain_override;
  // IFFT Gain Override
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_c1_dl_ifft_gain_override;
  // IFFT Gain Override
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_c0_ul_fft_gain_override;
  // FFT Gain Override
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_c1_ul_fft_gain_override;
  // FFT Gain Override
   logic                     FPGA_REG_DL_LPHY_MISC_CFG_dl_route_c0_to_c1;
  // Carrier0 data is routed to both carrier0 & carrier1 in DL at the output of the ORAN RADIo IF IP, Use din debug mode
   logic                     FPGA_REG_DL_LPHY_CC0_CFG_dl_lte_5g;
  // 0:lte, 1:5g
   logic                     FPGA_REG_DL_LPHY_CC0_CFG_dl_extended_cp;
  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
   logic  [3:0]              FPGA_REG_DL_LPHY_CC0_CFG_dl_cc_numerology;
  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
   logic                     FPGA_REG_DL_LPHY_CC1_CFG_dl_lte_5g;
  // 0:lte, 1:5g
   logic                     FPGA_REG_DL_LPHY_CC1_CFG_dl_extended_cp;
  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
   logic  [3:0]              FPGA_REG_DL_LPHY_CC1_CFG_dl_cc_numerology;
  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
   logic                     FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
   logic  [3:0]              FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_fraction_gain;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
   logic                     FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
   logic  [3:0]              FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_fraction_gain;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
   logic                     FPGA_REG_UL_LPHY_CC0_CFG_ul_lte_5g;
  // 0:lte, 1:5g
   logic                     FPGA_REG_UL_LPHY_CC0_CFG_ul_extended_cp;
  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
   logic  [3:0]              FPGA_REG_UL_LPHY_CC0_CFG_ul_cc_numerology;
  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
   logic                     FPGA_REG_UL_LPHY_CC1_CFG_ul_lte_5g;
  // 0:lte, 1:5g
   logic                     FPGA_REG_UL_LPHY_CC1_CFG_ul_extended_cp;
  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
   logic  [3:0]              FPGA_REG_UL_LPHY_CC1_CFG_ul_cc_numerology;
  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
   logic                     FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
   logic  [3:0]              FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_fraction_gain;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
   logic                     FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
   logic  [3:0]              FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_fraction_gain;
  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c0a0_en;
  // Enable for Carrier 0 in Antenna 0
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c1a0_en;
  // Enable for Carrier 1 in Antenna 0
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c0a1_en;
  // Enable for Carrier 0 in Antenna 1
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c1a1_en;
  // Enable for Carrier 1 in Antenna 1
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c0a2_en;
  // Enable for Carrier 0 in Antenna 2
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c1a2_en;
  // Enable for Carrier 1 in Antenna 2
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c0a3_en;
  // Enable for Carrier 0 in Antenna 3
   logic                     FPGA_REG_PRACH_EN_0TO3_prach_c1a3_en;
  // Enable for Carrier 1 in Antenna 3
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c0a4_en;
  // Enable for Carrier 0 in Antenna 4
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c1a4_en;
  // Enable for Carrier 1 in Antenna 4
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c0a5_en;
  // Enable for Carrier 0 in Antenna 5
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c1a5_en;
  // Enable for Carrier 1 in Antenna 5
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c0a6_en;
  // Enable for Carrier 0 in Antenna 6
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c1a6_en;
  // Enable for Carrier 1 in Antenna 6
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c0a7_en;
  // Enable for Carrier 0 in Antenna 7
   logic                     FPGA_REG_PRACH_EN_4TO7_prach_c1a7_en;
  // Enable for Carrier 1 in Antenna 7
   logic  [3:0]              FPGA_REG_PRACH_FORMAT_prach_car0_format;
  // carrier0 prach format
   logic  [3:0]              FPGA_REG_PRACH_FORMAT_prach_car1_format;
  // carrier 1 prach format
   logic  [15:0]              FPGA_REG_PRACH_CP_SAMPLES_prach_car0_cp_samples;
  // Number of CP samples at 1.28MSPS for Car0. At sub frame marker this many samples will be dropped before FFT processing starts
   logic  [15:0]              FPGA_REG_PRACH_CP_SAMPLES_prach_car1_cp_samples;
  // Number of CP samples at 1.28MSPS for Car1. At sub frame marker this many samples will be dropped before FFT processing starts
   logic                     FPGA_REG_PRACH_CFG_prach_use_sec_type3_freq_offset;
  // when set Use Frequency Offset from Section Type3 message, if set to 0, use frequency offset from register 0xA026700 & 0xA026704  configured by M-Plane
   logic  [31:0]              FPGA_REG_PRACH_CAR0_NCO_LSB_CFG_prach_car0_nco_lsb;
  // [31:0] of NCO value for carrier0
   logic  [6:0]              FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_msb;
  // [38:32] of NCO value for carrier0
   logic                     FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_sign;
  //  Sign of NCO
   logic  [31:0]              FPGA_REG_PRACH_CAR1_NCO_LSB_CFG_prach_car1_nco_lsb;
  // [31:0] of NCO value for carrier1
   logic  [6:0]              FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_msb;
  // [38:32] of NCO value for carrier1
   logic                     FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_sign;
  //  Sign of NCO
   logic                     FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler_sign;
  // When negative (1), shift right, When positive (0), shift left  
   logic  [3:0]              FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler;
  // Number of bits to be shifted (multiple of 6dB) 
   logic  [15:0]              FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_fraction_gain;
  // Unsigned multiplier to both I & Q 
   logic                     FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_clear;
  // 0 to 1 transition: Clear all UL_LPHY_ORAN debug counters.
   logic                     FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_fifo_reset;
  // 0 to 1 transition: Return all UL_LPHY_ORAN request FIFOs to reset state.
   logic  [15:0]              FPGA_REG_UL_LPHY_ORAN_STAT_VLD_WO_RDY_ul_lphy_oran_vld_wo_rdy;
  // TVALID asserted upon request, but no TREADY after set timeout, 4bits per antenna
   logic  [15:0]              FPGA_REG_UL_LPHY_ORAN_STAT_FIFO_OVERFLOW_ul_lphy_oran_fifo_overflow;
  // Requests FIFO overflow, 4bits per antenna
   logic  [15:0]              FPGA_REG_UL_LPHY_ORAN_STAT_STALE_REQS_ul_lphy_oran_stale_reqs;
  // Old requests are still in the FIFO after antenna buffer is updated, 4bits per antenna
   logic  [15:0]              FPGA_REG_UL_LPHY_ORAN_STAT_STALE_PRBS_ul_lphy_oran_stale_prbs;
  // Response is interrupted by arrival of new antenna data, 4bits per antenna
   logic                     FPGA_REG_PRACH_ORAN_CMD_prach_oran_clear;
  // 0 to 1 transition: Clear all PRACH_ORAN debug counters.
   logic                     FPGA_REG_PRACH_ORAN_CMD_prach_oran_fifo_reset;
  // 0 to 1 transition: Return all PRACH_ORAN request FIFOs to reset state.
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_VLD_WO_RDY_prach_oran_vld_wo_rdy;
  // TVALID asserted upon request, but no TREADY after set timeout
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_CPLANE_FIFO_OVFL_prach_oran_cplane_fifo_ovfl;
  // C-Plane messges FIFO overflow
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant0_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant1_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant2_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant3_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant4_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant5_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant6_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic  [3:0]              FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant7_oran_reqs_fifo_ovfl;
  // PRACH Requests FIFO overflow, 4bits per antenna
   logic                     FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_clear;
  // 0 to 1 transition: Clear all LPHY-ORAN packet counters.
   logic                     FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_click;
  // 0 to 1 transition: Take a snapshot of all LPHY-ORAN packet counters.
   logic  [31:0]              FPGA_REG_LPHY_ORAN_RUNT_TYPE0_CNT_lphy_oran_runt_type0_cnt;
  // eCPRI Type-0: Unexpected ethernet packet size.
   logic  [31:0]              FPGA_REG_LPHY_ORAN_RUNT_TYPE2_CNT_lphy_oran_runt_type2_cnt;
  // eCPRI Type-2: Unexpected ethernet packet size.
   logic  [31:0]              FPGA_REG_LPHY_ORAN_WIN_T2_T1_DL_CNT_lphy_oran_win_t2_t1_dl_cnt;
  // Packet out of window; eCPRI type2, section type1, downlink
   logic  [31:0]              FPGA_REG_LPHY_ORAN_WIN_T2_T1_UL_CNT_lphy_oran_win_t2_t1_ul_cnt;
  // Packet out of window; eCPRI type2, section type1, uplink
   logic  [31:0]              FPGA_REG_LPHY_ORAN_WIN_T2_T3_UL_CNT_lphy_oran_win_t2_t3_ul_cnt;
  // Packet out of window; eCPRI type2, section type3, uplink
   logic  [31:0]              FPGA_REG_LPHY_ORAN_WIN_T0_DL_CNT_lphy_oran_win_t0_dl_cnt;
  // Packet out of window; eCPRI type0, downlink
   logic  [31:0]              FPGA_REG_LPHY_ORAN_OTHER_T0_ERR_CNT_lphy_oran_other_t0_err_cnt;
  // RADIO_APP header timeout; eCPRI type0
   logic  [31:0]              FPGA_REG_LPHY_ORAN_OTHER_T2_ERR_CNT_lphy_oran_other_t2_err_cnt;
  // RADIO_APP header timeout; eCPRI type2
   logic  [31:0]              FPGA_REG_LPHY_ORAN_OTHER_T1_UL_ERR_CNT_lphy_oran_other_t1_ul_err_cnt;
  // SECTION header timeout; eCPRI type2, section type1, uplink, 
   logic  [31:0]              FPGA_REG_LPHY_ORAN_OTHER_T1_DL_ERR_CNT_lphy_oran_other_t1_dl_err_cnt;
  // SECTION header timeout; eCPRI type2, section type1, downlink
   logic  [31:0]              FPGA_REG_LPHY_ORAN_OTHER_T3_ERR_CNT_lphy_oran_other_t3_err_cnt;
  // SECTION header timeout; eCPRI type2, section type3
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_DATA_DL_CNT_lphy_oran_t1_data_dl_cnt;
  // eCPRI type0, section type1, data, downlink, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_CTRL_UL_CNT_lphy_oran_t1_ctrl_ul_cnt;
  // eCPRI type2, section type1, control, uplink, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_CTRL_DL_CNT_lphy_oran_t1_ctrl_dl_cnt;
  // eCPRI type2, section type1, control, downlink, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T3_CTRL_UL_CNT_lphy_oran_t3_ctrl_ul_cnt;
  // eCPRI type2, section type3, uplink, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_REQS_UL0_CNT_lphy_oran_t1_reqs_ul0_cnt;
  // Uplink data requests, for antenna 0, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_DATA_UL0_CNT_lphy_oran_t1_data_ul0_cnt;
  // Uplink data responses, for antenna 0, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_REQS_UL1_CNT_lphy_oran_t1_reqs_ul1_cnt;
  // Uplink data requests, for antenna 1, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_DATA_UL1_CNT_lphy_oran_t1_data_ul1_cnt;
  // Uplink data responses, for antenna 1, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_REQS_UL2_CNT_lphy_oran_t1_reqs_ul2_cnt;
  // Uplink data requests, for antenna 2, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_DATA_UL2_CNT_lphy_oran_t1_data_ul2_cnt;
  // Uplink data responses, for antenna 2, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_REQS_UL3_CNT_lphy_oran_t1_reqs_ul3_cnt;
  // Uplink data requests, for antenna 3, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T1_DATA_UL3_CNT_lphy_oran_t1_data_ul3_cnt;
  // Uplink data responses, for antenna 3, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T3_REQS_UL_CNT_lphy_oran_t3_reqs_ul_cnt;
  // PRACH data requests, for antenna 0, ok
   logic  [31:0]              FPGA_REG_LPHY_ORAN_T3_DATA_UL_CNT_lphy_oran_t3_data_ul_cnt;
  // PRACH data responses, for antenna 0, ok
   logic  [31:0]              FPGA_REG_LPHY_SCRATCH_lphy_scratch;
  // scratch








////////////////ASSIGN PARAMETERS//////////////////





////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_oran_lphy_ctrl.dl_swap_ifft =  FPGA_REG_DL_LPHY_MISC_CFG_dl_swap_ifft;
   assign  IFP_oran_lphy_ctrl.ul_swap_fft =  FPGA_REG_DL_LPHY_MISC_CFG_ul_swap_fft;
   assign  IFP_oran_lphy_ctrl.prach_swap_fft =  FPGA_REG_DL_LPHY_MISC_CFG_prach_swap_fft;
   assign  IFP_oran_lphy_ctrl.dl_iq_endianness =  FPGA_REG_DL_LPHY_MISC_CFG_dl_iq_endianness;
   assign  IFP_oran_lphy_ctrl.ul_iq_endianness =  FPGA_REG_DL_LPHY_MISC_CFG_ul_iq_endianness;
   assign  IFP_oran_lphy_ctrl.prach_iq_endianness =  FPGA_REG_DL_LPHY_MISC_CFG_prach_iq_endianness;
   assign  IFP_oran_lphy_ctrl.dl_ifft_gain_override[0] =  FPGA_REG_DL_LPHY_MISC_CFG_c0_dl_ifft_gain_override;
   assign  IFP_oran_lphy_ctrl.dl_ifft_gain_override[1] =  FPGA_REG_DL_LPHY_MISC_CFG_c1_dl_ifft_gain_override;
   assign  IFP_oran_lphy_ctrl.ul_fft_gain_override[0] =  FPGA_REG_DL_LPHY_MISC_CFG_c0_ul_fft_gain_override;
   assign  IFP_oran_lphy_ctrl.ul_fft_gain_override[1] =  FPGA_REG_DL_LPHY_MISC_CFG_c1_ul_fft_gain_override;
   assign  IFP_oran_lphy_ctrl.dl_route_c0_to_c1 =  FPGA_REG_DL_LPHY_MISC_CFG_dl_route_c0_to_c1;
   assign  IFP_oran_lphy_ctrl.dl_lte_5g[0] =  FPGA_REG_DL_LPHY_CC0_CFG_dl_lte_5g;
   assign  IFP_oran_lphy_ctrl.dl_extended_cp[0] =  FPGA_REG_DL_LPHY_CC0_CFG_dl_extended_cp;
   assign  IFP_oran_lphy_ctrl.dl_cc_numerology[0] =  FPGA_REG_DL_LPHY_CC0_CFG_dl_cc_numerology;
   assign  IFP_oran_lphy_ctrl.dl_lte_5g[1] =  FPGA_REG_DL_LPHY_CC1_CFG_dl_lte_5g;
   assign  IFP_oran_lphy_ctrl.dl_extended_cp[1] =  FPGA_REG_DL_LPHY_CC1_CFG_dl_extended_cp;
   assign  IFP_oran_lphy_ctrl.dl_cc_numerology[1] =  FPGA_REG_DL_LPHY_CC1_CFG_dl_cc_numerology;
   assign  IFP_oran_lphy_ctrl.dl_ifft_scaler_sign[0] =  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler_sign;
   assign  IFP_oran_lphy_ctrl.dl_ifft_scaler[0] =  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler;
   assign  IFP_oran_lphy_ctrl.dl_ifft_fraction_gain[0] =  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_fraction_gain;
   assign  IFP_oran_lphy_ctrl.dl_ifft_scaler_sign[1] =  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler_sign;
   assign  IFP_oran_lphy_ctrl.dl_ifft_scaler[1] =  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler;
   assign  IFP_oran_lphy_ctrl.dl_ifft_fraction_gain[1] =  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_fraction_gain;
   assign  IFP_oran_lphy_ctrl.ul_lte_5g[0] =  FPGA_REG_UL_LPHY_CC0_CFG_ul_lte_5g;
   assign  IFP_oran_lphy_ctrl.ul_extended_cp[0] =  FPGA_REG_UL_LPHY_CC0_CFG_ul_extended_cp;
   assign  IFP_oran_lphy_ctrl.ul_cc_numerology[0] =  FPGA_REG_UL_LPHY_CC0_CFG_ul_cc_numerology;
   assign  IFP_oran_lphy_ctrl.ul_lte_5g[1] =  FPGA_REG_UL_LPHY_CC1_CFG_ul_lte_5g;
   assign  IFP_oran_lphy_ctrl.ul_extended_cp[1] =  FPGA_REG_UL_LPHY_CC1_CFG_ul_extended_cp;
   assign  IFP_oran_lphy_ctrl.ul_cc_numerology[1] =  FPGA_REG_UL_LPHY_CC1_CFG_ul_cc_numerology;
   assign  IFP_oran_lphy_ctrl.ul_fft_scaler_sign[0] =  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler_sign;
   assign  IFP_oran_lphy_ctrl.ul_fft_scaler[0] =  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler;
   assign  IFP_oran_lphy_ctrl.ul_fft_fraction_gain[0] =  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_fraction_gain;
   assign  IFP_oran_lphy_ctrl.ul_fft_scaler_sign[1] =  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler_sign;
   assign  IFP_oran_lphy_ctrl.ul_fft_scaler[1] =  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler;
   assign  IFP_oran_lphy_ctrl.ul_fft_fraction_gain[1] =  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_en[0][0] =  FPGA_REG_PRACH_EN_0TO3_prach_c0a0_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][0] =  FPGA_REG_PRACH_EN_0TO3_prach_c1a0_en;
   assign  IFP_oran_lphy_ctrl.prach_en[0][1] =  FPGA_REG_PRACH_EN_0TO3_prach_c0a1_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][1] =  FPGA_REG_PRACH_EN_0TO3_prach_c1a1_en;
   assign  IFP_oran_lphy_ctrl.prach_en[0][2] =  FPGA_REG_PRACH_EN_0TO3_prach_c0a2_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][2] =  FPGA_REG_PRACH_EN_0TO3_prach_c1a2_en;
   assign  IFP_oran_lphy_ctrl.prach_en[0][3] =  FPGA_REG_PRACH_EN_0TO3_prach_c0a3_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][3] =  FPGA_REG_PRACH_EN_0TO3_prach_c1a3_en;
   assign  IFP_oran_lphy_ctrl.prach_en[0][4] =  FPGA_REG_PRACH_EN_4TO7_prach_c0a4_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][4] =  FPGA_REG_PRACH_EN_4TO7_prach_c1a4_en;
   assign  IFP_oran_lphy_ctrl.prach_en[0][5] =  FPGA_REG_PRACH_EN_4TO7_prach_c0a5_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][5] =  FPGA_REG_PRACH_EN_4TO7_prach_c1a5_en;
   assign  IFP_oran_lphy_ctrl.prach_en[0][6] =  FPGA_REG_PRACH_EN_4TO7_prach_c0a6_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][6] =  FPGA_REG_PRACH_EN_4TO7_prach_c1a6_en;
   assign  IFP_oran_lphy_ctrl.prach_en[0][7] =  FPGA_REG_PRACH_EN_4TO7_prach_c0a7_en;
   assign  IFP_oran_lphy_ctrl.prach_en[1][7] =  FPGA_REG_PRACH_EN_4TO7_prach_c1a7_en;
   assign  IFP_oran_lphy_ctrl.prach_format[0] =  FPGA_REG_PRACH_FORMAT_prach_car0_format;
   assign  IFP_oran_lphy_ctrl.prach_format[1] =  FPGA_REG_PRACH_FORMAT_prach_car1_format;
   assign  IFP_oran_lphy_ctrl.prach_cp[0] =  FPGA_REG_PRACH_CP_SAMPLES_prach_car0_cp_samples;
   assign  IFP_oran_lphy_ctrl.prach_cp[1] =  FPGA_REG_PRACH_CP_SAMPLES_prach_car1_cp_samples;
   assign  IFP_oran_lphy_ctrl.prach_use_sec_type3_freq_offset =  FPGA_REG_PRACH_CFG_prach_use_sec_type3_freq_offset;
   assign  IFP_oran_lphy_ctrl.prach_car_nco_lsb[0] =  FPGA_REG_PRACH_CAR0_NCO_LSB_CFG_prach_car0_nco_lsb;
   assign  IFP_oran_lphy_ctrl.prach_car_nco_msb[0] =  FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_msb;
   assign  IFP_oran_lphy_ctrl.prach_car_nco_sign[0] =  FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_sign;
   assign  IFP_oran_lphy_ctrl.prach_car_nco_lsb[1] =  FPGA_REG_PRACH_CAR1_NCO_LSB_CFG_prach_car1_nco_lsb;
   assign  IFP_oran_lphy_ctrl.prach_car_nco_msb[1] =  FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_msb;
   assign  IFP_oran_lphy_ctrl.prach_car_nco_sign[1] =  FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][0] =  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][0] =  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][0] =  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][0] =  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][0] =  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][0] =  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][1] =  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][1] =  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][1] =  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][1] =  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][1] =  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][1] =  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][2] =  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][2] =  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][2] =  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][2] =  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][2] =  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][2] =  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][3] =  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][3] =  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][3] =  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][3] =  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][3] =  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][3] =  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][4] =  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][4] =  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][4] =  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][4] =  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][4] =  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][4] =  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][5] =  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][5] =  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][5] =  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][5] =  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][5] =  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][5] =  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][6] =  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][6] =  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][6] =  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][6] =  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][6] =  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][6] =  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[0][7] =  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[0][7] =  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[0][7] =  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_fraction_gain;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler_sign[1][7] =  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler_sign;
   assign  IFP_oran_lphy_ctrl.prach_gain_scaler[1][7] =  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler;
   assign  IFP_oran_lphy_ctrl.prach_gain_fraction[1][7] =  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_fraction_gain;
   assign  IFP_oran_lphy_ctrl.ul_lphy_oran_clear =  FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_clear;
   assign  IFP_oran_lphy_ctrl.ul_lphy_oran_fifo_reset =  FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_fifo_reset;
   assign  IFP_oran_lphy_ctrl.prach_oran_clear =  FPGA_REG_PRACH_ORAN_CMD_prach_oran_clear;
   assign  IFP_oran_lphy_ctrl.prach_oran_fifo_reset =  FPGA_REG_PRACH_ORAN_CMD_prach_oran_fifo_reset;
   assign  IFP_oran_lphy_ctrl.lphy_oran_dbg_clear =  FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_clear;
   assign  IFP_oran_lphy_ctrl.lphy_oran_dbg_click =  FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_click;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  FPGA_REG_UL_LPHY_ORAN_STAT_VLD_WO_RDY_ul_lphy_oran_vld_wo_rdy = IFP_oran_lphy_stat.ul_lphy_oran_vld_wo_rdy;
   assign  FPGA_REG_UL_LPHY_ORAN_STAT_FIFO_OVERFLOW_ul_lphy_oran_fifo_overflow = IFP_oran_lphy_stat.ul_lphy_oran_fifo_overflow;
   assign  FPGA_REG_UL_LPHY_ORAN_STAT_STALE_REQS_ul_lphy_oran_stale_reqs = IFP_oran_lphy_stat.ul_lphy_oran_stale_reqs;
   assign  FPGA_REG_UL_LPHY_ORAN_STAT_STALE_PRBS_ul_lphy_oran_stale_prbs = IFP_oran_lphy_stat.ul_lphy_oran_stale_prbs;
   assign  FPGA_REG_PRACH_ORAN_STAT_VLD_WO_RDY_prach_oran_vld_wo_rdy = IFP_oran_lphy_stat.prach_oran_vld_wo_rdy;
   assign  FPGA_REG_PRACH_ORAN_STAT_CPLANE_FIFO_OVFL_prach_oran_cplane_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_cplane_fifo_ovfl;
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant0_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[0];
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant1_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[1];
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant2_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[2];
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant3_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[3];
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant4_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[4];
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant5_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[5];
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant6_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[6];
   assign  FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant7_oran_reqs_fifo_ovfl = IFP_oran_lphy_stat.prach_oran_reqs_fifo_ovfl[7];
   assign  FPGA_REG_LPHY_ORAN_RUNT_TYPE0_CNT_lphy_oran_runt_type0_cnt = IFP_oran_lphy_stat.lphy_oran_runt_type0_cnt;
   assign  FPGA_REG_LPHY_ORAN_RUNT_TYPE2_CNT_lphy_oran_runt_type2_cnt = IFP_oran_lphy_stat.lphy_oran_runt_type2_cnt;
   assign  FPGA_REG_LPHY_ORAN_WIN_T2_T1_DL_CNT_lphy_oran_win_t2_t1_dl_cnt = IFP_oran_lphy_stat.lphy_oran_win_t2_t1_dl_cnt;
   assign  FPGA_REG_LPHY_ORAN_WIN_T2_T1_UL_CNT_lphy_oran_win_t2_t1_ul_cnt = IFP_oran_lphy_stat.lphy_oran_win_t2_t1_ul_cnt;
   assign  FPGA_REG_LPHY_ORAN_WIN_T2_T3_UL_CNT_lphy_oran_win_t2_t3_ul_cnt = IFP_oran_lphy_stat.lphy_oran_win_t2_t3_ul_cnt;
   assign  FPGA_REG_LPHY_ORAN_WIN_T0_DL_CNT_lphy_oran_win_t0_dl_cnt = IFP_oran_lphy_stat.lphy_oran_win_t0_dl_cnt;
   assign  FPGA_REG_LPHY_ORAN_OTHER_T0_ERR_CNT_lphy_oran_other_t0_err_cnt = IFP_oran_lphy_stat.lphy_oran_other_t0_err_cnt;
   assign  FPGA_REG_LPHY_ORAN_OTHER_T2_ERR_CNT_lphy_oran_other_t2_err_cnt = IFP_oran_lphy_stat.lphy_oran_other_t2_err_cnt;
   assign  FPGA_REG_LPHY_ORAN_OTHER_T1_UL_ERR_CNT_lphy_oran_other_t1_ul_err_cnt = IFP_oran_lphy_stat.lphy_oran_other_t1_ul_err_cnt;
   assign  FPGA_REG_LPHY_ORAN_OTHER_T1_DL_ERR_CNT_lphy_oran_other_t1_dl_err_cnt = IFP_oran_lphy_stat.lphy_oran_other_t1_dl_err_cnt;
   assign  FPGA_REG_LPHY_ORAN_OTHER_T3_ERR_CNT_lphy_oran_other_t3_err_cnt = IFP_oran_lphy_stat.lphy_oran_other_t3_err_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_DATA_DL_CNT_lphy_oran_t1_data_dl_cnt = IFP_oran_lphy_stat.lphy_oran_t1_data_dl_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_CTRL_UL_CNT_lphy_oran_t1_ctrl_ul_cnt = IFP_oran_lphy_stat.lphy_oran_t1_ctrl_ul_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_CTRL_DL_CNT_lphy_oran_t1_ctrl_dl_cnt = IFP_oran_lphy_stat.lphy_oran_t1_ctrl_dl_cnt;
   assign  FPGA_REG_LPHY_ORAN_T3_CTRL_UL_CNT_lphy_oran_t3_ctrl_ul_cnt = IFP_oran_lphy_stat.lphy_oran_t3_ctrl_ul_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_REQS_UL0_CNT_lphy_oran_t1_reqs_ul0_cnt = IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul0_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_DATA_UL0_CNT_lphy_oran_t1_data_ul0_cnt = IFP_oran_lphy_stat.lphy_oran_t1_data_ul0_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_REQS_UL1_CNT_lphy_oran_t1_reqs_ul1_cnt = IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul1_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_DATA_UL1_CNT_lphy_oran_t1_data_ul1_cnt = IFP_oran_lphy_stat.lphy_oran_t1_data_ul1_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_REQS_UL2_CNT_lphy_oran_t1_reqs_ul2_cnt = IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul2_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_DATA_UL2_CNT_lphy_oran_t1_data_ul2_cnt = IFP_oran_lphy_stat.lphy_oran_t1_data_ul2_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_REQS_UL3_CNT_lphy_oran_t1_reqs_ul3_cnt = IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul3_cnt;
   assign  FPGA_REG_LPHY_ORAN_T1_DATA_UL3_CNT_lphy_oran_t1_data_ul3_cnt = IFP_oran_lphy_stat.lphy_oran_t1_data_ul3_cnt;
   assign  FPGA_REG_LPHY_ORAN_T3_REQS_UL_CNT_lphy_oran_t3_reqs_ul_cnt = IFP_oran_lphy_stat.lphy_oran_t3_reqs_ul_cnt;
   assign  FPGA_REG_LPHY_ORAN_T3_DATA_UL_CNT_lphy_oran_t3_data_ul_cnt = IFP_oran_lphy_stat.lphy_oran_t3_data_ul_cnt;




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_DL_LPHY_MISC_CFG_dl_swap_ifft <= 'h1;  // 1. Swap the 2 halves of tones in DL
                  FPGA_REG_DL_LPHY_MISC_CFG_ul_swap_fft <= 'h1;  // 1. Swap the 2 halves of tones in UL
                  FPGA_REG_DL_LPHY_MISC_CFG_prach_swap_fft <= 'h1;  // 1. Swap the 2 halves of tones in PRACH
                  FPGA_REG_DL_LPHY_MISC_CFG_dl_iq_endianness <= 'h0;  // 0: Big Endian, 1: Little Endian
                  FPGA_REG_DL_LPHY_MISC_CFG_ul_iq_endianness <= 'h0;  // 0: Big Endian, 1: Little Endian
                  FPGA_REG_DL_LPHY_MISC_CFG_prach_iq_endianness <= 'h0;  // 0: Big Endian, 1: Little Endian
                  FPGA_REG_DL_LPHY_MISC_CFG_c0_dl_ifft_gain_override <= 'h0;  // IFFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_c1_dl_ifft_gain_override <= 'h0;  // IFFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_c0_ul_fft_gain_override <= 'h0;  // FFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_c1_ul_fft_gain_override <= 'h0;  // FFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_dl_route_c0_to_c1 <= 'h0;  // Carrier0 data is routed to both carrier0 & carrier1 in DL at the output of the ORAN RADIo IF IP, Use din debug mode
                  FPGA_REG_DL_LPHY_CC0_CFG_dl_lte_5g <= 'h1;  // 0:lte, 1:5g
                  FPGA_REG_DL_LPHY_CC0_CFG_dl_extended_cp <= 'h0;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_DL_LPHY_CC0_CFG_dl_cc_numerology <= 'h1;  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
                  FPGA_REG_DL_LPHY_CC1_CFG_dl_lte_5g <= 'h1;  // 0:lte, 1:5g
                  FPGA_REG_DL_LPHY_CC1_CFG_dl_extended_cp <= 'h0;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_DL_LPHY_CC1_CFG_dl_cc_numerology <= 'h1;  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
                  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
                  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
                  FPGA_REG_UL_LPHY_CC0_CFG_ul_lte_5g <= 'h1;  // 0:lte, 1:5g
                  FPGA_REG_UL_LPHY_CC0_CFG_ul_extended_cp <= 'h0;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_UL_LPHY_CC0_CFG_ul_cc_numerology <= 'h1;  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
                  FPGA_REG_UL_LPHY_CC1_CFG_ul_lte_5g <= 'h1;  // 0:lte, 1:5g
                  FPGA_REG_UL_LPHY_CC1_CFG_ul_extended_cp <= 'h0;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_UL_LPHY_CC1_CFG_ul_cc_numerology <= 'h1;  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
                  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
                  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a0_en <= 'h0;  // Enable for Carrier 0 in Antenna 0
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a0_en <= 'h0;  // Enable for Carrier 1 in Antenna 0
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a1_en <= 'h0;  // Enable for Carrier 0 in Antenna 1
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a1_en <= 'h0;  // Enable for Carrier 1 in Antenna 1
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a2_en <= 'h0;  // Enable for Carrier 0 in Antenna 2
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a2_en <= 'h0;  // Enable for Carrier 1 in Antenna 2
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a3_en <= 'h0;  // Enable for Carrier 0 in Antenna 3
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a3_en <= 'h0;  // Enable for Carrier 1 in Antenna 3
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a4_en <= 'h0;  // Enable for Carrier 0 in Antenna 4
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a4_en <= 'h0;  // Enable for Carrier 1 in Antenna 4
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a5_en <= 'h0;  // Enable for Carrier 0 in Antenna 5
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a5_en <= 'h0;  // Enable for Carrier 1 in Antenna 5
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a6_en <= 'h0;  // Enable for Carrier 0 in Antenna 6
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a6_en <= 'h0;  // Enable for Carrier 1 in Antenna 6
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a7_en <= 'h0;  // Enable for Carrier 0 in Antenna 7
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a7_en <= 'h0;  // Enable for Carrier 1 in Antenna 7
                  FPGA_REG_PRACH_FORMAT_prach_car0_format <= 'h0;  // carrier0 prach format
                  FPGA_REG_PRACH_FORMAT_prach_car1_format <= 'h0;  // carrier 1 prach format
                  FPGA_REG_PRACH_CP_SAMPLES_prach_car0_cp_samples <= 'h84;  // Number of CP samples at 1.28MSPS for Car0. At sub frame marker this many samples will be dropped before FFT processing starts
                  FPGA_REG_PRACH_CP_SAMPLES_prach_car1_cp_samples <= 'h84;  // Number of CP samples at 1.28MSPS for Car1. At sub frame marker this many samples will be dropped before FFT processing starts
                  FPGA_REG_PRACH_CFG_prach_use_sec_type3_freq_offset <= 'h0;  // when set Use Frequency Offset from Section Type3 message, if set to 0, use frequency offset from register 0xA026700 & 0xA026704  configured by M-Plane
                  FPGA_REG_PRACH_CAR0_NCO_LSB_CFG_prach_car0_nco_lsb <= 'h0;  // [31:0] of NCO value for carrier0
                  FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_msb <= 'h0;  // [38:32] of NCO value for carrier0
                  FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_sign <= 'h0;  //  Sign of NCO
                  FPGA_REG_PRACH_CAR1_NCO_LSB_CFG_prach_car1_nco_lsb <= 'h0;  // [31:0] of NCO value for carrier1
                  FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_msb <= 'h0;  // [38:32] of NCO value for carrier1
                  FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_sign <= 'h0;  //  Sign of NCO
                  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler_sign <= 'h0;  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler <= 'h0;  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_fraction_gain <= 'hFFFF;  // Unsigned multiplier to both I & Q 
                  FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_clear <= 'h0;  // 0 to 1 transition: Clear all UL_LPHY_ORAN debug counters.
                  FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_fifo_reset <= 'h0;  // 0 to 1 transition: Return all UL_LPHY_ORAN request FIFOs to reset state.
                  FPGA_REG_PRACH_ORAN_CMD_prach_oran_clear <= 'h0;  // 0 to 1 transition: Clear all PRACH_ORAN debug counters.
                  FPGA_REG_PRACH_ORAN_CMD_prach_oran_fifo_reset <= 'h0;  // 0 to 1 transition: Return all PRACH_ORAN request FIFOs to reset state.
                  FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_clear <= 'h0;  // 0 to 1 transition: Clear all LPHY-ORAN packet counters.
                  FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_click <= 'h0;  // 0 to 1 transition: Take a snapshot of all LPHY-ORAN packet counters.
                  FPGA_REG_LPHY_SCRATCH_lphy_scratch <= 'h66666666;  // scratch
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h0  : begin //'h0
                  FPGA_REG_DL_LPHY_MISC_CFG_dl_swap_ifft <= IFP_axi_rw.wdata[0];  // 1. Swap the 2 halves of tones in DL
                  FPGA_REG_DL_LPHY_MISC_CFG_ul_swap_fft <= IFP_axi_rw.wdata[1];  // 1. Swap the 2 halves of tones in UL
                  FPGA_REG_DL_LPHY_MISC_CFG_prach_swap_fft <= IFP_axi_rw.wdata[2];  // 1. Swap the 2 halves of tones in PRACH
                  FPGA_REG_DL_LPHY_MISC_CFG_dl_iq_endianness <= IFP_axi_rw.wdata[4];  // 0: Big Endian, 1: Little Endian
                  FPGA_REG_DL_LPHY_MISC_CFG_ul_iq_endianness <= IFP_axi_rw.wdata[5];  // 0: Big Endian, 1: Little Endian
                  FPGA_REG_DL_LPHY_MISC_CFG_prach_iq_endianness <= IFP_axi_rw.wdata[6];  // 0: Big Endian, 1: Little Endian
                  FPGA_REG_DL_LPHY_MISC_CFG_c0_dl_ifft_gain_override <= IFP_axi_rw.wdata[8];  // IFFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_c1_dl_ifft_gain_override <= IFP_axi_rw.wdata[9];  // IFFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_c0_ul_fft_gain_override <= IFP_axi_rw.wdata[16];  // FFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_c1_ul_fft_gain_override <= IFP_axi_rw.wdata[17];  // FFT Gain Override
                  FPGA_REG_DL_LPHY_MISC_CFG_dl_route_c0_to_c1 <= IFP_axi_rw.wdata[20];  // Carrier0 data is routed to both carrier0 & carrier1 in DL at the output of the ORAN RADIo IF IP, Use din debug mode
             end
      11'h40  : begin //'h100
                  FPGA_REG_DL_LPHY_CC0_CFG_dl_lte_5g <= IFP_axi_rw.wdata[0];  // 0:lte, 1:5g
                  FPGA_REG_DL_LPHY_CC0_CFG_dl_extended_cp <= IFP_axi_rw.wdata[1];  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_DL_LPHY_CC0_CFG_dl_cc_numerology <= IFP_axi_rw.wdata[11:8];  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h41  : begin //'h104
                  FPGA_REG_DL_LPHY_CC1_CFG_dl_lte_5g <= IFP_axi_rw.wdata[0];  // 0:lte, 1:5g
                  FPGA_REG_DL_LPHY_CC1_CFG_dl_extended_cp <= IFP_axi_rw.wdata[1];  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_DL_LPHY_CC1_CFG_dl_cc_numerology <= IFP_axi_rw.wdata[11:8];  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h42  : begin //'h108
                  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h43  : begin //'h10C
                  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h100  : begin //'h400
                  FPGA_REG_UL_LPHY_CC0_CFG_ul_lte_5g <= IFP_axi_rw.wdata[0];  // 0:lte, 1:5g
                  FPGA_REG_UL_LPHY_CC0_CFG_ul_extended_cp <= IFP_axi_rw.wdata[1];  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_UL_LPHY_CC0_CFG_ul_cc_numerology <= IFP_axi_rw.wdata[11:8];  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h101  : begin //'h404
                  FPGA_REG_UL_LPHY_CC1_CFG_ul_lte_5g <= IFP_axi_rw.wdata[0];  // 0:lte, 1:5g
                  FPGA_REG_UL_LPHY_CC1_CFG_ul_extended_cp <= IFP_axi_rw.wdata[1];  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                  FPGA_REG_UL_LPHY_CC1_CFG_ul_cc_numerology <= IFP_axi_rw.wdata[11:8];  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h102  : begin //'h408
                  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h103  : begin //'h40C
                  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h180  : begin //'h600
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a0_en <= IFP_axi_rw.wdata[0];  // Enable for Carrier 0 in Antenna 0
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a0_en <= IFP_axi_rw.wdata[1];  // Enable for Carrier 1 in Antenna 0
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a1_en <= IFP_axi_rw.wdata[8];  // Enable for Carrier 0 in Antenna 1
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a1_en <= IFP_axi_rw.wdata[9];  // Enable for Carrier 1 in Antenna 1
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a2_en <= IFP_axi_rw.wdata[16];  // Enable for Carrier 0 in Antenna 2
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a2_en <= IFP_axi_rw.wdata[17];  // Enable for Carrier 1 in Antenna 2
                  FPGA_REG_PRACH_EN_0TO3_prach_c0a3_en <= IFP_axi_rw.wdata[24];  // Enable for Carrier 0 in Antenna 3
                  FPGA_REG_PRACH_EN_0TO3_prach_c1a3_en <= IFP_axi_rw.wdata[25];  // Enable for Carrier 1 in Antenna 3
             end
      11'h181  : begin //'h604
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a4_en <= IFP_axi_rw.wdata[0];  // Enable for Carrier 0 in Antenna 4
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a4_en <= IFP_axi_rw.wdata[1];  // Enable for Carrier 1 in Antenna 4
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a5_en <= IFP_axi_rw.wdata[8];  // Enable for Carrier 0 in Antenna 5
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a5_en <= IFP_axi_rw.wdata[9];  // Enable for Carrier 1 in Antenna 5
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a6_en <= IFP_axi_rw.wdata[16];  // Enable for Carrier 0 in Antenna 6
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a6_en <= IFP_axi_rw.wdata[17];  // Enable for Carrier 1 in Antenna 6
                  FPGA_REG_PRACH_EN_4TO7_prach_c0a7_en <= IFP_axi_rw.wdata[24];  // Enable for Carrier 0 in Antenna 7
                  FPGA_REG_PRACH_EN_4TO7_prach_c1a7_en <= IFP_axi_rw.wdata[25];  // Enable for Carrier 1 in Antenna 7
             end
      11'h182  : begin //'h608
                  FPGA_REG_PRACH_FORMAT_prach_car0_format <= IFP_axi_rw.wdata[3:0];  // carrier0 prach format
                  FPGA_REG_PRACH_FORMAT_prach_car1_format <= IFP_axi_rw.wdata[11:8];  // carrier 1 prach format
             end
      11'h183  : begin //'h60C
                  FPGA_REG_PRACH_CP_SAMPLES_prach_car0_cp_samples <= IFP_axi_rw.wdata[15:0];  // Number of CP samples at 1.28MSPS for Car0. At sub frame marker this many samples will be dropped before FFT processing starts
                  FPGA_REG_PRACH_CP_SAMPLES_prach_car1_cp_samples <= IFP_axi_rw.wdata[31:16];  // Number of CP samples at 1.28MSPS for Car1. At sub frame marker this many samples will be dropped before FFT processing starts
             end
      11'h184  : begin //'h610
                  FPGA_REG_PRACH_CFG_prach_use_sec_type3_freq_offset <= IFP_axi_rw.wdata[0];  // when set Use Frequency Offset from Section Type3 message, if set to 0, use frequency offset from register 0xA026700 & 0xA026704  configured by M-Plane
             end
      11'h1c0  : begin //'h700
                  FPGA_REG_PRACH_CAR0_NCO_LSB_CFG_prach_car0_nco_lsb <= IFP_axi_rw.wdata[31:0];  // [31:0] of NCO value for carrier0
             end
      11'h1c1  : begin //'h704
                  FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_msb <= IFP_axi_rw.wdata[6:0];  // [38:32] of NCO value for carrier0
                  FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_sign <= IFP_axi_rw.wdata[7];  //  Sign of NCO
             end
      11'h1c2  : begin //'h708
                  FPGA_REG_PRACH_CAR1_NCO_LSB_CFG_prach_car1_nco_lsb <= IFP_axi_rw.wdata[31:0];  // [31:0] of NCO value for carrier1
             end
      11'h1c3  : begin //'h70C
                  FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_msb <= IFP_axi_rw.wdata[6:0];  // [38:32] of NCO value for carrier1
                  FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_sign <= IFP_axi_rw.wdata[7];  //  Sign of NCO
             end
      11'h200  : begin //'h800
                  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h201  : begin //'h804
                  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h202  : begin //'h808
                  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h203  : begin //'h80C
                  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h204  : begin //'h810
                  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h205  : begin //'h814
                  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h206  : begin //'h818
                  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h207  : begin //'h81C
                  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h208  : begin //'h820
                  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h209  : begin //'h824
                  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h20a  : begin //'h828
                  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h20b  : begin //'h82C
                  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h20c  : begin //'h830
                  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h20d  : begin //'h834
                  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h20e  : begin //'h838
                  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h20f  : begin //'h83C
                  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler_sign <= IFP_axi_rw.wdata[31];  // When negative (1), shift right, When positive (0), shift left  
                  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler <= IFP_axi_rw.wdata[19:16];  // Number of bits to be shifted (multiple of 6dB) 
                  FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_fraction_gain <= IFP_axi_rw.wdata[15:0];  // Unsigned multiplier to both I & Q 
             end
      11'h400  : begin //'h1000
                  FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_clear <= IFP_axi_rw.wdata[0];  // 0 to 1 transition: Clear all UL_LPHY_ORAN debug counters.
                  FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_fifo_reset <= IFP_axi_rw.wdata[4];  // 0 to 1 transition: Return all UL_LPHY_ORAN request FIFOs to reset state.
             end
      11'h408  : begin //'h1020
                  FPGA_REG_PRACH_ORAN_CMD_prach_oran_clear <= IFP_axi_rw.wdata[0];  // 0 to 1 transition: Clear all PRACH_ORAN debug counters.
                  FPGA_REG_PRACH_ORAN_CMD_prach_oran_fifo_reset <= IFP_axi_rw.wdata[4];  // 0 to 1 transition: Return all PRACH_ORAN request FIFOs to reset state.
             end
      11'h40d  : begin //'h1034
                  FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_clear <= IFP_axi_rw.wdata[0];  // 0 to 1 transition: Clear all LPHY-ORAN packet counters.
                  FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_click <= IFP_axi_rw.wdata[4];  // 0 to 1 transition: Take a snapshot of all LPHY-ORAN packet counters.
             end
      11'h7ff  : begin //'h1FFC
                  FPGA_REG_LPHY_SCRATCH_lphy_scratch <= IFP_axi_rw.wdata[31:0];  // scratch
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
      11'h0  : begin//'h0
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_LPHY_MISC_CFG_dl_swap_ifft;  // 1. Swap the 2 halves of tones in DL
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_LPHY_MISC_CFG_ul_swap_fft;  // 1. Swap the 2 halves of tones in UL
                   IFP_axi_rw.rdata[2] = FPGA_REG_DL_LPHY_MISC_CFG_prach_swap_fft;  // 1. Swap the 2 halves of tones in PRACH
                   IFP_axi_rw.rdata[4] = FPGA_REG_DL_LPHY_MISC_CFG_dl_iq_endianness;  // 0: Big Endian, 1: Little Endian
                   IFP_axi_rw.rdata[5] = FPGA_REG_DL_LPHY_MISC_CFG_ul_iq_endianness;  // 0: Big Endian, 1: Little Endian
                   IFP_axi_rw.rdata[6] = FPGA_REG_DL_LPHY_MISC_CFG_prach_iq_endianness;  // 0: Big Endian, 1: Little Endian
                   IFP_axi_rw.rdata[8] = FPGA_REG_DL_LPHY_MISC_CFG_c0_dl_ifft_gain_override;  // IFFT Gain Override
                   IFP_axi_rw.rdata[9] = FPGA_REG_DL_LPHY_MISC_CFG_c1_dl_ifft_gain_override;  // IFFT Gain Override
                   IFP_axi_rw.rdata[16] = FPGA_REG_DL_LPHY_MISC_CFG_c0_ul_fft_gain_override;  // FFT Gain Override
                   IFP_axi_rw.rdata[17] = FPGA_REG_DL_LPHY_MISC_CFG_c1_ul_fft_gain_override;  // FFT Gain Override
                   IFP_axi_rw.rdata[20] = FPGA_REG_DL_LPHY_MISC_CFG_dl_route_c0_to_c1;  // Carrier0 data is routed to both carrier0 & carrier1 in DL at the output of the ORAN RADIo IF IP, Use din debug mode
             end
      11'h40  : begin//'h100
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_LPHY_CC0_CFG_dl_lte_5g;  // 0:lte, 1:5g
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_LPHY_CC0_CFG_dl_extended_cp;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_DL_LPHY_CC0_CFG_dl_cc_numerology;  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h41  : begin//'h104
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_LPHY_CC1_CFG_dl_lte_5g;  // 0:lte, 1:5g
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_LPHY_CC1_CFG_dl_extended_cp;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_DL_LPHY_CC1_CFG_dl_cc_numerology;  // DL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h42  : begin//'h108
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler_sign;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_LPHY_CC0_IFFT_GAIN_dl_ifft_fraction_gain;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h43  : begin//'h10C
                   IFP_axi_rw.rdata[31] = FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler_sign;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_DL_LPHY_CC1_IFFT_GAIN_dl_ifft_fraction_gain;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h100  : begin//'h400
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_LPHY_CC0_CFG_ul_lte_5g;  // 0:lte, 1:5g
                   IFP_axi_rw.rdata[1] = FPGA_REG_UL_LPHY_CC0_CFG_ul_extended_cp;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_UL_LPHY_CC0_CFG_ul_cc_numerology;  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h101  : begin//'h404
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_LPHY_CC1_CFG_ul_lte_5g;  // 0:lte, 1:5g
                   IFP_axi_rw.rdata[1] = FPGA_REG_UL_LPHY_CC1_CFG_ul_extended_cp;  // 0:normal CP, 1: extended CP, when set all symbols have extended CP
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_UL_LPHY_CC1_CFG_ul_cc_numerology;  // UL Numerology  0: 15khz, 1:30khz, 2: 60khz
             end
      11'h102  : begin//'h408
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler_sign;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_LPHY_CC0_FFT_GAIN_ul_fft_fraction_gain;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h103  : begin//'h40C
                   IFP_axi_rw.rdata[31] = FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler_sign;  // When negative (1), shift right, When positive (0), shift left , Can only be updated when the override bit is set
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_LPHY_CC1_FFT_GAIN_ul_fft_fraction_gain;  // Unsigned multiplier to both I & Q, Can only be updated when the override bit is set
             end
      11'h180  : begin//'h600
                   IFP_axi_rw.rdata[0] = FPGA_REG_PRACH_EN_0TO3_prach_c0a0_en;  // Enable for Carrier 0 in Antenna 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_PRACH_EN_0TO3_prach_c1a0_en;  // Enable for Carrier 1 in Antenna 0
                   IFP_axi_rw.rdata[8] = FPGA_REG_PRACH_EN_0TO3_prach_c0a1_en;  // Enable for Carrier 0 in Antenna 1
                   IFP_axi_rw.rdata[9] = FPGA_REG_PRACH_EN_0TO3_prach_c1a1_en;  // Enable for Carrier 1 in Antenna 1
                   IFP_axi_rw.rdata[16] = FPGA_REG_PRACH_EN_0TO3_prach_c0a2_en;  // Enable for Carrier 0 in Antenna 2
                   IFP_axi_rw.rdata[17] = FPGA_REG_PRACH_EN_0TO3_prach_c1a2_en;  // Enable for Carrier 1 in Antenna 2
                   IFP_axi_rw.rdata[24] = FPGA_REG_PRACH_EN_0TO3_prach_c0a3_en;  // Enable for Carrier 0 in Antenna 3
                   IFP_axi_rw.rdata[25] = FPGA_REG_PRACH_EN_0TO3_prach_c1a3_en;  // Enable for Carrier 1 in Antenna 3
             end
      11'h181  : begin//'h604
                   IFP_axi_rw.rdata[0] = FPGA_REG_PRACH_EN_4TO7_prach_c0a4_en;  // Enable for Carrier 0 in Antenna 4
                   IFP_axi_rw.rdata[1] = FPGA_REG_PRACH_EN_4TO7_prach_c1a4_en;  // Enable for Carrier 1 in Antenna 4
                   IFP_axi_rw.rdata[8] = FPGA_REG_PRACH_EN_4TO7_prach_c0a5_en;  // Enable for Carrier 0 in Antenna 5
                   IFP_axi_rw.rdata[9] = FPGA_REG_PRACH_EN_4TO7_prach_c1a5_en;  // Enable for Carrier 1 in Antenna 5
                   IFP_axi_rw.rdata[16] = FPGA_REG_PRACH_EN_4TO7_prach_c0a6_en;  // Enable for Carrier 0 in Antenna 6
                   IFP_axi_rw.rdata[17] = FPGA_REG_PRACH_EN_4TO7_prach_c1a6_en;  // Enable for Carrier 1 in Antenna 6
                   IFP_axi_rw.rdata[24] = FPGA_REG_PRACH_EN_4TO7_prach_c0a7_en;  // Enable for Carrier 0 in Antenna 7
                   IFP_axi_rw.rdata[25] = FPGA_REG_PRACH_EN_4TO7_prach_c1a7_en;  // Enable for Carrier 1 in Antenna 7
             end
      11'h182  : begin//'h608
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_PRACH_FORMAT_prach_car0_format;  // carrier0 prach format
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_PRACH_FORMAT_prach_car1_format;  // carrier 1 prach format
             end
      11'h183  : begin//'h60C
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_CP_SAMPLES_prach_car0_cp_samples;  // Number of CP samples at 1.28MSPS for Car0. At sub frame marker this many samples will be dropped before FFT processing starts
                   IFP_axi_rw.rdata[31:16] = FPGA_REG_PRACH_CP_SAMPLES_prach_car1_cp_samples;  // Number of CP samples at 1.28MSPS for Car1. At sub frame marker this many samples will be dropped before FFT processing starts
             end
      11'h184  : begin//'h610
                   IFP_axi_rw.rdata[0] = FPGA_REG_PRACH_CFG_prach_use_sec_type3_freq_offset;  // when set Use Frequency Offset from Section Type3 message, if set to 0, use frequency offset from register 0xA026700 & 0xA026704  configured by M-Plane
             end
      11'h1c0  : begin//'h700
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PRACH_CAR0_NCO_LSB_CFG_prach_car0_nco_lsb;  // [31:0] of NCO value for carrier0
             end
      11'h1c1  : begin//'h704
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_msb;  // [38:32] of NCO value for carrier0
                   IFP_axi_rw.rdata[7] = FPGA_REG_PRACH_CAR0_NCO_MSB_CFG_prach_car0_nco_sign;  //  Sign of NCO
             end
      11'h1c2  : begin//'h708
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PRACH_CAR1_NCO_LSB_CFG_prach_car1_nco_lsb;  // [31:0] of NCO value for carrier1
             end
      11'h1c3  : begin//'h70C
                   IFP_axi_rw.rdata[6:0] = FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_msb;  // [38:32] of NCO value for carrier1
                   IFP_axi_rw.rdata[7] = FPGA_REG_PRACH_CAR1_NCO_MSB_CFG_prach_car1_nco_sign;  //  Sign of NCO
             end
      11'h200  : begin//'h800
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A0_GAIN_CFG_prach_c0a0_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h201  : begin//'h804
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A0_GAIN_CFG_prach_c1a0_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h202  : begin//'h808
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A1_GAIN_CFG_prach_c0a1_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h203  : begin//'h80C
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A1_GAIN_CFG_prach_c1a1_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h204  : begin//'h810
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A2_GAIN_CFG_prach_c0a2_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h205  : begin//'h814
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A2_GAIN_CFG_prach_c1a2_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h206  : begin//'h818
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A3_GAIN_CFG_prach_c0a3_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h207  : begin//'h81C
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A3_GAIN_CFG_prach_c1a3_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h208  : begin//'h820
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A4_GAIN_CFG_prach_c0a4_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h209  : begin//'h824
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A4_GAIN_CFG_prach_c1a4_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h20a  : begin//'h828
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A5_GAIN_CFG_prach_c0a5_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h20b  : begin//'h82C
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A5_GAIN_CFG_prach_c1a5_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h20c  : begin//'h830
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A6_GAIN_CFG_prach_c0a6_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h20d  : begin//'h834
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A6_GAIN_CFG_prach_c1a6_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h20e  : begin//'h838
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C0A7_GAIN_CFG_prach_c0a7_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h20f  : begin//'h83C
                   IFP_axi_rw.rdata[31] = FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler_sign;  // When negative (1), shift right, When positive (0), shift left  
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_scaler;  // Number of bits to be shifted (multiple of 6dB) 
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PRACH_C1A7_GAIN_CFG_prach_c1a7_fraction_gain;  // Unsigned multiplier to both I & Q 
             end
      11'h400  : begin//'h1000
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_clear;  // 0 to 1 transition: Clear all UL_LPHY_ORAN debug counters.
                   IFP_axi_rw.rdata[4] = FPGA_REG_UL_LPHY_ORAN_CMD_ul_lphy_oran_fifo_reset;  // 0 to 1 transition: Return all UL_LPHY_ORAN request FIFOs to reset state.
             end
      11'h401  : begin//'h1004
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_LPHY_ORAN_STAT_VLD_WO_RDY_ul_lphy_oran_vld_wo_rdy;  // TVALID asserted upon request, but no TREADY after set timeout, 4bits per antenna
             end
      11'h402  : begin//'h1008
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_LPHY_ORAN_STAT_FIFO_OVERFLOW_ul_lphy_oran_fifo_overflow;  // Requests FIFO overflow, 4bits per antenna
             end
      11'h403  : begin//'h100C
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_LPHY_ORAN_STAT_STALE_REQS_ul_lphy_oran_stale_reqs;  // Old requests are still in the FIFO after antenna buffer is updated, 4bits per antenna
             end
      11'h404  : begin//'h1010
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_UL_LPHY_ORAN_STAT_STALE_PRBS_ul_lphy_oran_stale_prbs;  // Response is interrupted by arrival of new antenna data, 4bits per antenna
             end
      11'h408  : begin//'h1020
                   IFP_axi_rw.rdata[0] = FPGA_REG_PRACH_ORAN_CMD_prach_oran_clear;  // 0 to 1 transition: Clear all PRACH_ORAN debug counters.
                   IFP_axi_rw.rdata[4] = FPGA_REG_PRACH_ORAN_CMD_prach_oran_fifo_reset;  // 0 to 1 transition: Return all PRACH_ORAN request FIFOs to reset state.
             end
      11'h409  : begin//'h1024
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_PRACH_ORAN_STAT_VLD_WO_RDY_prach_oran_vld_wo_rdy;  // TVALID asserted upon request, but no TREADY after set timeout
             end
      11'h40a  : begin//'h1028
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_PRACH_ORAN_STAT_CPLANE_FIFO_OVFL_prach_oran_cplane_fifo_ovfl;  // C-Plane messges FIFO overflow
             end
      11'h40b  : begin//'h102C
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant0_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
                   IFP_axi_rw.rdata[7:4] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant1_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant2_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
                   IFP_axi_rw.rdata[15:12] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_0TO3_prach_ant3_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
             end
      11'h40c  : begin//'h1030
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant4_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
                   IFP_axi_rw.rdata[7:4] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant5_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant6_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
                   IFP_axi_rw.rdata[15:12] = FPGA_REG_PRACH_ORAN_STAT_REQS_FIFO_OVFL_4TO7_prach_ant7_oran_reqs_fifo_ovfl;  // PRACH Requests FIFO overflow, 4bits per antenna
             end
      11'h40d  : begin//'h1034
                   IFP_axi_rw.rdata[0] = FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_clear;  // 0 to 1 transition: Clear all LPHY-ORAN packet counters.
                   IFP_axi_rw.rdata[4] = FPGA_REG_LPHY_ORAN_DBG_CMD_lphy_oran_dbg_click;  // 0 to 1 transition: Take a snapshot of all LPHY-ORAN packet counters.
             end
      11'h40e  : begin//'h1038
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_RUNT_TYPE0_CNT_lphy_oran_runt_type0_cnt;  // eCPRI Type-0: Unexpected ethernet packet size.
             end
      11'h40f  : begin//'h103C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_RUNT_TYPE2_CNT_lphy_oran_runt_type2_cnt;  // eCPRI Type-2: Unexpected ethernet packet size.
             end
      11'h410  : begin//'h1040
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_WIN_T2_T1_DL_CNT_lphy_oran_win_t2_t1_dl_cnt;  // Packet out of window; eCPRI type2, section type1, downlink
             end
      11'h411  : begin//'h1044
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_WIN_T2_T1_UL_CNT_lphy_oran_win_t2_t1_ul_cnt;  // Packet out of window; eCPRI type2, section type1, uplink
             end
      11'h412  : begin//'h1048
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_WIN_T2_T3_UL_CNT_lphy_oran_win_t2_t3_ul_cnt;  // Packet out of window; eCPRI type2, section type3, uplink
             end
      11'h413  : begin//'h104C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_WIN_T0_DL_CNT_lphy_oran_win_t0_dl_cnt;  // Packet out of window; eCPRI type0, downlink
             end
      11'h414  : begin//'h1050
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_OTHER_T0_ERR_CNT_lphy_oran_other_t0_err_cnt;  // RADIO_APP header timeout; eCPRI type0
             end
      11'h415  : begin//'h1054
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_OTHER_T2_ERR_CNT_lphy_oran_other_t2_err_cnt;  // RADIO_APP header timeout; eCPRI type2
             end
      11'h416  : begin//'h1058
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_OTHER_T1_UL_ERR_CNT_lphy_oran_other_t1_ul_err_cnt;  // SECTION header timeout; eCPRI type2, section type1, uplink, 
             end
      11'h417  : begin//'h105C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_OTHER_T1_DL_ERR_CNT_lphy_oran_other_t1_dl_err_cnt;  // SECTION header timeout; eCPRI type2, section type1, downlink
             end
      11'h418  : begin//'h1060
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_OTHER_T3_ERR_CNT_lphy_oran_other_t3_err_cnt;  // SECTION header timeout; eCPRI type2, section type3
             end
      11'h419  : begin//'h1064
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_DATA_DL_CNT_lphy_oran_t1_data_dl_cnt;  // eCPRI type0, section type1, data, downlink, ok
             end
      11'h41a  : begin//'h1068
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_CTRL_UL_CNT_lphy_oran_t1_ctrl_ul_cnt;  // eCPRI type2, section type1, control, uplink, ok
             end
      11'h41b  : begin//'h106C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_CTRL_DL_CNT_lphy_oran_t1_ctrl_dl_cnt;  // eCPRI type2, section type1, control, downlink, ok
             end
      11'h41c  : begin//'h1070
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T3_CTRL_UL_CNT_lphy_oran_t3_ctrl_ul_cnt;  // eCPRI type2, section type3, uplink, ok
             end
      11'h41d  : begin//'h1074
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_REQS_UL0_CNT_lphy_oran_t1_reqs_ul0_cnt;  // Uplink data requests, for antenna 0, ok
             end
      11'h41e  : begin//'h1078
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_DATA_UL0_CNT_lphy_oran_t1_data_ul0_cnt;  // Uplink data responses, for antenna 0, ok
             end
      11'h41f  : begin//'h107C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_REQS_UL1_CNT_lphy_oran_t1_reqs_ul1_cnt;  // Uplink data requests, for antenna 1, ok
             end
      11'h420  : begin//'h1080
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_DATA_UL1_CNT_lphy_oran_t1_data_ul1_cnt;  // Uplink data responses, for antenna 1, ok
             end
      11'h421  : begin//'h1084
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_REQS_UL2_CNT_lphy_oran_t1_reqs_ul2_cnt;  // Uplink data requests, for antenna 2, ok
             end
      11'h422  : begin//'h1088
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_DATA_UL2_CNT_lphy_oran_t1_data_ul2_cnt;  // Uplink data responses, for antenna 2, ok
             end
      11'h423  : begin//'h108C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_REQS_UL3_CNT_lphy_oran_t1_reqs_ul3_cnt;  // Uplink data requests, for antenna 3, ok
             end
      11'h424  : begin//'h1090
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T1_DATA_UL3_CNT_lphy_oran_t1_data_ul3_cnt;  // Uplink data responses, for antenna 3, ok
             end
      11'h425  : begin//'h1094
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T3_REQS_UL_CNT_lphy_oran_t3_reqs_ul_cnt;  // PRACH data requests, for antenna 0, ok
             end
      11'h426  : begin//'h1098
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_ORAN_T3_DATA_UL_CNT_lphy_oran_t3_data_ul_cnt;  // PRACH data responses, for antenna 0, ok
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_LPHY_SCRATCH_lphy_scratch;  // scratch
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule