
module jb_cmn_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_cmn_ctrl_if.ctrl         IFP_cmn_ctrl
);

    `include "jb_vernon_params.svh"



////////////////Register Field Declarations//////////////////

   logic  [7:0]              FPGA_REG_VERSION_REGISTER_major_version;
  // major version
   logic  [7:0]              FPGA_REG_VERSION_REGISTER_minor_version;
  // minor version
   logic  [15:0]              FPGA_REG_VERSION_REGISTER_revision_num;
  // Revision number
   logic  [31:0]              FPGA_REG_DEBUG_REVISION_debug_revision;
  // Debug build version. Should be 0 for official builds.
   logic  [15:0]              FPGA_REG_HW_ID_hw_id;
  // 
   logic  [15:0]              FPGA_REG_SOFT_RESET_REGISTER_soft_reset;
  // bit 0 - Write 1 and then 0 to resets data path except Fronthaul. 
   logic  [20:0]              FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics;
  // Number of tics @15.36Mhz clock after which RSSI, WRSSI, TSSI re-loaded into registers
   logic                     FPGA_REG_FRM_MRKR_GEN_CFG_c0_frm_mrkr_gen_enable;
  // Enable for the Carrier0 Frame Generation Logic
   logic                     FPGA_REG_FRM_MRKR_GEN_CFG_c1_frm_mrkr_gen_enable;
  // Enable for the Carrier0 Frame Generation Logic
   logic                     FPGA_REG_FRM_MRKR_GEN_TRIGGER_c0_frm_mrkr_gen_trigger;
  // When a rising edge is created on this bit, Car0 Frame marker is generated based on configurd frame marker counters
   logic                     FPGA_REG_FRM_MRKR_GEN_TRIGGER_c1_frm_mrkr_gen_trigger;
  // When a rising edge is created on this bit, Car1 Frame marker is generated based on configurd frame marker counters
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a0_en;
  // Enable for Carrier 0 in Antenna 0
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a0_en;
  // Enable for Carrier 1 in Antenna 0
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a1_en;
  // Enable for Carrier 0 in Antenna 1
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a1_en;
  // Enable for Carrier 1 in Antenna 1
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a2_en;
  // Enable for Carrier 0 in Antenna 2
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a2_en;
  // Enable for Carrier 1 in Antenna 2
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a3_en;
  // Enable for Carrier 0 in Antenna 3
   logic                     FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a3_en;
  // Enable for Carrier 1 in Antenna 3
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a4_en;
  // Enable for Carrier 0 in Antenna 4
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a4_en;
  // Enable for Carrier 1 in Antenna 4
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a5_en;
  // Enable for Carrier 0 in Antenna 5
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a5_en;
  // Enable for Carrier 1 in Antenna 5
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a6_en;
  // Enable for Carrier 0 in Antenna 6
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a6_en;
  // Enable for Carrier 1 in Antenna 6
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a7_en;
  // Enable for Carrier 0 in Antenna 7
   logic                     FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a7_en;
  // Enable for Carrier 1 in Antenna 7
   logic  [3:0]              FPGA_REG_DL_CAR_CFG_dl_car0_bw;
  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
   logic  [3:0]              FPGA_REG_DL_CAR_CFG_dl_car1_bw;
  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a0_en;
  // Enable for Carrier 0 in Antenna 0
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a0_en;
  // Enable for Carrier 1 in Antenna 0
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a1_en;
  // Enable for Carrier 0 in Antenna 1
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a1_en;
  // Enable for Carrier 1 in Antenna 1
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a2_en;
  // Enable for Carrier 0 in Antenna 2
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a2_en;
  // Enable for Carrier 1 in Antenna 2
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a3_en;
  // Enable for Carrier 0 in Antenna 3
   logic                     FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a3_en;
  // Enable for Carrier 1 in Antenna 3
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a4_en;
  // Enable for Carrier 0 in Antenna 4
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a4_en;
  // Enable for Carrier 1 in Antenna 4
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a5_en;
  // Enable for Carrier 0 in Antenna 5
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a5_en;
  // Enable for Carrier 1 in Antenna 5
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a6_en;
  // Enable for Carrier 0 in Antenna 6
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a6_en;
  // Enable for Carrier 1 in Antenna 6
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a7_en;
  // Enable for Carrier 0 in Antenna 7
   logic                     FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a7_en;
  // Enable for Carrier 1 in Antenna 7
   logic  [3:0]              FPGA_REG_UL_CAR_CFG_ul_car0_bw;
  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
   logic  [3:0]              FPGA_REG_UL_CAR_CFG_ul_car1_bw;
  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
   logic  [31:0]              FPGA_REG_DL_C0_FRM_MRKR_CNTR_NS_dl_c0_frm_mrkr_cntr_ns;
  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
   logic  [31:0]              FPGA_REG_DL_C1_FRM_MRKR_CNTR_NS_dl_c1_frm_mrkr_cntr_ns;
  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
   logic  [31:0]              FPGA_REG_UL_C0_FRM_MRKR_CNTR_NS_ul_c0_frm_mrkr_cntr_ns;
  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
   logic  [31:0]              FPGA_REG_UL_C1_FRM_MRKR_CNTR_NS_ul_c1_frm_mrkr_cntr_ns;
  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
   logic  [31:0]              FPGA_REG_PRACH_C0_FRM_MRKR_CNTR_NS_prach_c0_frm_mrkr_cntr_ns;
  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
   logic  [31:0]              FPGA_REG_PRACH_C1_FRM_MRKR_CNTR_NS_prach_c1_frm_mrkr_cntr_ns;
  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
   logic                     FPGA_REG_CMN_FEATURE_SPRT_fh_mode;
  // Front Haul mode, 0:Cpri, 1:ecpri
   logic  [1:0]              FPGA_REG_CMN_FEATURE_SPRT_num_eth_cores;
  // Number of SFPS  or Number of Eth Cores
   logic                     FPGA_REG_CMN_FEATURE_SPRT_fdd_supported;
  // when set FDD is Supported
   logic                     FPGA_REG_CMN_FEATURE_SPRT_tdd_supported;
  // when set TDD is Supported
   logic  [7:0]              FPGA_REG_CMN_FEATURE_SPRT_max_supported_antennas;
  // Number of Max Antenna Paths Supported
   logic  [3:0]              FPGA_REG_CMN_FEATURE_SPRT_max_supported_carriers;
  // Number of Max Carrier Paths Supported
   logic  [3:0]              FPGA_REG_CMN_FEATURE_SPRT_max_precision;
  // Maximum Supported I or Q Sample width
   logic                     FPGA_REG_CAR_FEATURE_SPRT_car0_lte_supported;
  // When set lte is supported on carrier0
   logic                     FPGA_REG_CAR_FEATURE_SPRT_car1_lte_supported;
  // When set 5G/NR is supported on carrier0
   logic                     FPGA_REG_CAR_FEATURE_SPRT_car0_5g_supported;
  // When set lte is supported on carrier1
   logic                     FPGA_REG_CAR_FEATURE_SPRT_car1_5g_supported;
  // When set 5G/NR is supported on carrier1
   logic                     FPGA_REG_NUMEROLOGY_SPRT_numerology0_supported;
  // When set 15khz scs is supported
   logic                     FPGA_REG_NUMEROLOGY_SPRT_numerology1_supported;
  // When set 30khz scs is supported
   logic                     FPGA_REG_NUMEROLOGY_SPRT_numerology2_supported;
  // When set 60khz scs is supported
   logic                     FPGA_REG_NUMEROLOGY_SPRT_extended_cp_supported;
  // When set extended CP is supoprted (60khz extened CP in 5G/NR, 15khz extended CP in LTE)
   logic                     FPGA_REG_SECTION_TYPE_SPRT_sec_type0_supported;
  // Section Type 0 is supported
   logic                     FPGA_REG_SECTION_TYPE_SPRT_sec_type1_supported;
  // Section Type 1 is supported
   logic                     FPGA_REG_SECTION_TYPE_SPRT_sec_type3_supported;
  // Section Type 3 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format0_supported;
  // When set prach LTE format0 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format1_supported;
  // When set prach LTE format1 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format2_supported;
  // When set prach LTE format2 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format3_supported;
  // When set prach LTE format3 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format4_supported;
  // When set prach LTE format4 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format0_supported;
  // When set prach LTE format0 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format1_supported;
  // When set prach LTE format1 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format2_supported;
  // When set prach LTE format2 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format3_supported;
  // When set prach LTE format3 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format4_supported;
  // When set prach LTE format4 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format0_supported;
  // When set prach NR format0 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format1_supported;
  // When set prach NR format1 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format2_supported;
  // When set prach NR format2 is supported
   logic                     FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format3_supported;
  // When set prach NR format3 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format0_supported;
  // When set prach NR format0 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format1_supported;
  // When set prach NR format1 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format2_supported;
  // When set prach NR format2 is supported
   logic                     FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format3_supported;
  // When set prach NR format3 is supported
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_5mhz_supported;
  // When set 5MHZ is supporterd
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_10mhz_supported;
  // When set 10MHZ is supporterd
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_15mhz_supported;
  // When set 15MHZ is supporterd
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_20mhz_supported;
  // When set 20MHZ is supporterd
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_40mhz_supported;
  // When set 40MHZ is supporterd
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_60mhz_supported;
  // When set 60MHZ is supporterd
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_80mhz_supported;
  // When set 80MHZ is supporterd
   logic                     FPGA_REG_CAR0_BW_SPRT_car0_bw_100mhz_supported;
  // When set 100MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_5mhz_supported;
  // When set 5MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_10mhz_supported;
  // When set 10MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_15mhz_supported;
  // When set 15MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_20mhz_supported;
  // When set 20MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_40mhz_supported;
  // When set 40MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_60mhz_supported;
  // When set 60MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_80mhz_supported;
  // When set 80MHZ is supporterd
   logic                     FPGA_REG_CAR1_BW_SPRT_car1_bw_100mhz_supported;
  // When set 100MHZ is supporterd
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_100MHZ_t2a_min_up_ns_100MHZ;
  // T2a min for user plane when BW=100Mhz
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_80MHZ_t2a_min_up_ns_80MHZ;
  // T2a min for user plane when BW=80Mhz
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_60MHZ_t2a_min_up_ns_60MHZ;
  // T2a min for user plane when BW=60Mhz
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_40MHZ_t2a_min_up_ns_40MHZ;
  // T2a min for user plane when BW=40Mhz
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_20MHZ_t2a_min_up_ns_20MHZ;
  // T2a min for user plane when BW=20Mhz
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_15MHZ_t2a_min_up_ns_15MHZ;
  // T2a min for user plane when BW=15Mhz
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_10MHZ_t2a_min_up_ns_10MHZ;
  // T2a min for user plane when BW=10Mhz
   logic  [19:0]              FPGA_REG_T2A_MIN_UP_5MHZ_t2a_min_up_ns_5MHZ;
  // T2a min for user plane when BW=5Mhz
   logic  [19:0]              FPGA_REG_TUP_RECEPTION_WINDOW_DL_tup_reception_window_dl_ns;
  // DL User Plane Reception Window
   logic  [19:0]              FPGA_REG_TCP_DL_RECEPTION_WINDOW_DL_tcp_reception_window_dl_ns;
  // DL Control Plane reception Window
   logic  [19:0]              FPGA_REG_TCP_ADV_DL_tcp_adv_dl_ns;
  // Control Plane reception Window
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_100MHZ_ta3_min_up_ns_100MHZ;
  // Ta3  min for user plane when BW=100Mhz for scs 30khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_80MHZ_ta3_min_up_ns_80MHZ;
  // Ta3  min for user plane when BW=80Mhz for scs 30khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_60MHZ_ta3_min_up_ns_60MHZ;
  // Ta3 min for user plane when BW=60Mhz for scs 30khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_40MHZ_ta3_min_up_ns_40MHZ;
  // Ta3 min for user plane when BW=40Mhz for scs 30khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_20MHZ_ta3_min_up_ns_20MHZ;
  // Ta3 min for user plane when BW=20Mhz for scs 30khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_15MHZ_ta3_min_up_ns_15MHZ;
  // Ta3 min for user plane when BW=15Mhz for scs 15khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_10MHZ_ta3_min_up_ns_10MHZ;
  // Ta3 min for user plane when BW=10Mhz for scs 15khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_5MHZ_ta3_min_up_ns_5MHZ;
  // Ta3  min for user plane when BW=5Mhz for scs 15khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_100MHZ_ta3_min_up_prach_ns_100MHZ;
  // Ta3  min for user plane when BW=100Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_80MHZ_ta3_min_up_prach_ns_80MHZ;
  // Ta3  min for user plane when BW=80Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_60MHZ_ta3_min_up_prach_ns_60MHZ;
  // Ta3 min for user plane when BW=60Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_40MHZ_ta3_min_up_prach_ns_40MHZ;
  // Ta3 min for user plane when BW=40Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_20MHZ_ta3_min_up_prach_ns_20MHZ;
  // Ta3 min for user plane when BW=20Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_15MHZ_ta3_min_up_prach_ns_15MHZ;
  // Ta3 min for user plane when BW=15Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_10MHZ_ta3_min_up_prach_ns_10MHZ;
  // Ta3 min for user plane when BW=10Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TA3_MIN_UP_PRACH_5MHZ_ta3_min_up_prach_ns_5MHZ;
  // Ta3  min for user plane when BW=5Mhz for scs 1.25khz
   logic  [19:0]              FPGA_REG_TUP_TRANSMISION_WINDOW_UL_tup_transmission_window_ul_ns;
  // User Plane Reception Window
   logic  [19:0]              FPGA_REG_T2A_MIN_CP_UL_t2a_min_cp_ul_ns;
  // This can 0  when we dont have beam forming
   logic  [19:0]              FPGA_REG_TCP_RECEPTION_WINDOW_UL_tcp_reception_window_ul_ns;
  // Reception window time for UL Control Plane
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_100MHZ_dl_frm_mrkr_time_advance_100mhz;
  // Frame Marker DL Time Advance for 100Mhz in ns
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_80MHZ_dl_frm_mrkr_time_advance_80mhz;
  // Frame Marker DL Time Advance for 80Mhz in ns
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_60MHZ_dl_frm_mrkr_time_advance_60mhz;
  // Frame Marker DL Time Advance for 60Mhz in ns
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_40MHZ_dl_frm_mrkr_time_advance_40mhz;
  // Frame Marker DL Time Advance for 40Mhz in ns
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_20MHZ_dl_frm_mrkr_time_advance_20mhz;
  // Frame Marker DL Time Advance for 20Mhz in ns
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_15MHZ_dl_frm_mrkr_time_advance_15mhz;
  // Frame Marker DL Time Advance for 15Mhz in ns
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_10MHZ_dl_frm_mrkr_time_advance_10mhz;
  // Frame Marker DL Time Advance for 10Mhz in ns
   logic  [19:0]              FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_5MHZ_dl_frm_mrkr_time_advance_5mhz;
  // Frame Marker DL Time Advance for 5Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_100MHZ_ul_frm_mrkr_time_delay_100mhz;
  // Frame Marker Delay for uplink for 100Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_80MHZ_ul_frm_mrkr_time_delay_80mhz;
  // Frame Marker Delay for uplink for 80Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_60MHZ_ul_frm_mrkr_time_delay_60mhz;
  // Frame Marker Delay for uplink for 60Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_40MHZ_ul_frm_mrkr_time_delay_40mhz;
  // Frame Marker Delay for uplink for 40Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_20MHZ_ul_frm_mrkr_time_delay_20mhz;
  // Frame Marker Delay for uplink for 20Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_15MHZ_ul_frm_mrkr_time_delay_15mhz;
  // Frame Marker Delay for uplink for 15Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_10MHZ_ul_frm_mrkr_time_delay_10mhz;
  // Frame Marker Delay for uplink for 10Mhz in ns
   logic  [19:0]              FPGA_REG_UL_FRM_MRKR_TIME_DELAY_5MHZ_ul_frm_mrkr_time_delay_5mhz;
  // Frame Marker Delay for uplink for 5Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_100MHZ_prach_frm_mrkr_time_delay_100mhz;
  // Frame Marker Delay for prach for 100Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_80MHZ_prach_frm_mrkr_time_delay_80mhz;
  // Frame Marker Delay for prach for 80Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_60MHZ_prach_frm_mrkr_time_delay_60mhz;
  // Frame Marker Delay for prach for 60Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_40MHZ_prach_frm_mrkr_time_delay_40mhz;
  // Frame Marker Delay for prach for 40Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_20MHZ_prach_frm_mrkr_time_delay_20mhz;
  // Frame Marker Delay for prach for 20Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_15MHZ_prach_frm_mrkr_time_delay_15mhz;
  // Frame Marker Delay for prach for 15Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_10MHZ_prach_frm_mrkr_time_delay_10mhz;
  // Frame Marker Delay for prach for 10Mhz in ns
   logic  [19:0]              FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_5MHZ_prach_frm_mrkr_time_delay_5mhz;
  // Frame Marker Delay for prach for 5Mhz in ns
   logic  [7:0]              FPGA_REG_TSSI_CFG_tssi_samples_per_15p36_tic;
  // 24 (0x18) for 368.64MHz, 32 (0x20) for 491.52MHz
   logic  [7:0]              FPGA_REG_TSSI_CFG_tssi_accum_truncated_bits;
  // Number of LSBs truncated
   logic  [7:0]              FPGA_REG_WRSSI_CFG_wrssi_samples_per_15p36_tic;
  // 24 (0x18) for 368.64MHz, 32 (0x20) for 491.52MHz
   logic  [7:0]              FPGA_REG_WRSSI_CFG_wrssi_accum_truncated_bits;
  // Number of LSBs truncated
   logic  [7:0]              FPGA_REG_RSSI_20M_CFG_rssi_samples_per_15p36_tic_20M;
  // 30.72/15.36=2 for 20MHz& 15Mhz.Software can extrapolate for other BWs, For example, 15.36/15.36=1 for 10MHz7.68/15.36=0.5 for 5Mhz
   logic  [7:0]              FPGA_REG_RSSI_20M_CFG_rssi_accum_truncated_bits;
  // Number of LSBs truncated
   logic  [15:0]              FPGA_REG_CFR_SAMPLE_PERIOD_cfr_sample_period_ps;
  // Sample period in ps used by CFR
   logic  [15:0]              FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_path_delay_sample_period_ps;
  // Sample period in ps in the integer and fractional interpolator. This field is used to calculate the integer and fractional sample delay that needs to be programmed in  delay registers for UL & DL
   logic                     FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_dl_time_delay_bypass;
  // when set  DL Time delay module which has integer and fractional interpolator is not included 
   logic                     FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_ul_time_delay_bypass;
  // when set UL Time delay module which has integer and fractional interpolator is not included 
   logic  [31:0]              FPGA_REG_CMN_SCRATCH_com_scratch;
  // common scratch








////////////////ASSIGN PARAMETERS//////////////////

   assign  FPGA_REG_VERSION_REGISTER_major_version =  MAJOR_VERSION;
   assign  FPGA_REG_VERSION_REGISTER_minor_version =  MINOR_VERSION;
   assign  FPGA_REG_VERSION_REGISTER_revision_num =  REVISION_NUM;
   assign  FPGA_REG_DEBUG_REVISION_debug_revision =  DEBUG_REVISION;
   assign  FPGA_REG_CMN_FEATURE_SPRT_fh_mode =  FH_MODE;
   assign  FPGA_REG_CMN_FEATURE_SPRT_num_eth_cores =  NUM_ETH_CORES;
   assign  FPGA_REG_CMN_FEATURE_SPRT_fdd_supported =  FDD_SUPPORTED;
   assign  FPGA_REG_CMN_FEATURE_SPRT_tdd_supported =  TDD_SUPPORTED;
   assign  FPGA_REG_CMN_FEATURE_SPRT_max_supported_antennas =  MAX_SUPPORTED_ANTENNAS;
   assign  FPGA_REG_CMN_FEATURE_SPRT_max_supported_carriers =  MAX_SUPPORTED_CARRIERS;
   assign  FPGA_REG_CMN_FEATURE_SPRT_max_precision =  MAX_PRECISION;
   assign  FPGA_REG_CAR_FEATURE_SPRT_car0_lte_supported =  CAR0_LTE_SUPPORTED;
   assign  FPGA_REG_CAR_FEATURE_SPRT_car1_lte_supported =  CAR1_LTE_SUPPORTED;
   assign  FPGA_REG_CAR_FEATURE_SPRT_car0_5g_supported =  CAR0_5G_SUPPORTED;
   assign  FPGA_REG_CAR_FEATURE_SPRT_car1_5g_supported =  CAR1_5G_SUPPORTED;
   assign  FPGA_REG_NUMEROLOGY_SPRT_numerology0_supported =  NUMEROLOGY0_SUPPORTED;
   assign  FPGA_REG_NUMEROLOGY_SPRT_numerology1_supported =  NUMEROLOGY1_SUPPORTED;
   assign  FPGA_REG_NUMEROLOGY_SPRT_numerology2_supported =  NUMEROLOGY2_SUPPORTED;
   assign  FPGA_REG_NUMEROLOGY_SPRT_extended_cp_supported =  EXTENDED_CP_SUPPORTED;
   assign  FPGA_REG_SECTION_TYPE_SPRT_sec_type0_supported =  SEC_TYPE0_SUPPORTED;
   assign  FPGA_REG_SECTION_TYPE_SPRT_sec_type1_supported =  SEC_TYPE1_SUPPORTED;
   assign  FPGA_REG_SECTION_TYPE_SPRT_sec_type3_supported =  SEC_TYPE3_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format0_supported =  CAR0_PRACH_LTE_FORMAT0_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format1_supported =  CAR0_PRACH_LTE_FORMAT1_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format2_supported =  CAR0_PRACH_LTE_FORMAT2_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format3_supported =  CAR0_PRACH_LTE_FORMAT3_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format4_supported =  CAR0_PRACH_LTE_FORMAT4_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format0_supported =  CAR1_PRACH_LTE_FORMAT0_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format1_supported =  CAR1_PRACH_LTE_FORMAT1_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format2_supported =  CAR1_PRACH_LTE_FORMAT2_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format3_supported =  CAR1_PRACH_LTE_FORMAT3_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format4_supported =  CAR1_PRACH_LTE_FORMAT4_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format0_supported =  CAR0_PRACH_5G_FORMAT0_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format1_supported =  CAR0_PRACH_5G_FORMAT1_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format2_supported =  CAR0_PRACH_5G_FORMAT2_SUPPORTED;
   assign  FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format3_supported =  CAR0_PRACH_5G_FORMAT3_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format0_supported =  CAR1_PRACH_5G_FORMAT0_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format1_supported =  CAR1_PRACH_5G_FORMAT1_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format2_supported =  CAR1_PRACH_5G_FORMAT2_SUPPORTED;
   assign  FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format3_supported =  CAR1_PRACH_5G_FORMAT3_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_5mhz_supported =  CAR0_BW_5MHZ_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_10mhz_supported =  CAR0_BW_10MHZ_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_15mhz_supported =  CAR0_BW_15MHZ_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_20mhz_supported =  CAR0_BW_20MHZ_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_40mhz_supported =  CAR0_BW_40MHZ_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_60mhz_supported =  CAR0_BW_60MHZ_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_80mhz_supported =  CAR0_BW_80MHZ_SUPPORTED;
   assign  FPGA_REG_CAR0_BW_SPRT_car0_bw_100mhz_supported =  CAR0_BW_100MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_5mhz_supported =  CAR1_BW_5MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_10mhz_supported =  CAR1_BW_10MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_15mhz_supported =  CAR1_BW_15MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_20mhz_supported =  CAR1_BW_20MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_40mhz_supported =  CAR1_BW_40MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_60mhz_supported =  CAR1_BW_60MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_80mhz_supported =  CAR1_BW_80MHZ_SUPPORTED;
   assign  FPGA_REG_CAR1_BW_SPRT_car1_bw_100mhz_supported =  CAR1_BW_100MHZ_SUPPORTED;
   assign  FPGA_REG_T2A_MIN_UP_100MHZ_t2a_min_up_ns_100MHZ =  T2A_MIN_UP_NS_100MHZ;
   assign  FPGA_REG_T2A_MIN_UP_80MHZ_t2a_min_up_ns_80MHZ =  T2A_MIN_UP_NS_80MHZ;
   assign  FPGA_REG_T2A_MIN_UP_60MHZ_t2a_min_up_ns_60MHZ =  T2A_MIN_UP_NS_60MHZ;
   assign  FPGA_REG_T2A_MIN_UP_40MHZ_t2a_min_up_ns_40MHZ =  T2A_MIN_UP_NS_40MHZ;
   assign  FPGA_REG_T2A_MIN_UP_20MHZ_t2a_min_up_ns_20MHZ =  T2A_MIN_UP_NS_20MHZ;
   assign  FPGA_REG_T2A_MIN_UP_15MHZ_t2a_min_up_ns_15MHZ =  T2A_MIN_UP_NS_15MHZ;
   assign  FPGA_REG_T2A_MIN_UP_10MHZ_t2a_min_up_ns_10MHZ =  T2A_MIN_UP_NS_10MHZ;
   assign  FPGA_REG_T2A_MIN_UP_5MHZ_t2a_min_up_ns_5MHZ =  T2A_MIN_UP_NS_5MHZ;
   assign  FPGA_REG_TUP_RECEPTION_WINDOW_DL_tup_reception_window_dl_ns =  TUP_RECEPTION_WINDOW_DL_NS;
   assign  FPGA_REG_TCP_DL_RECEPTION_WINDOW_DL_tcp_reception_window_dl_ns =  TCP_RECEPTION_WINDOW_DL_NS;
   assign  FPGA_REG_TCP_ADV_DL_tcp_adv_dl_ns =  TCP_ADV_DL_NS;
   assign  FPGA_REG_TA3_MIN_UP_100MHZ_ta3_min_up_ns_100MHZ =  TA3_MIN_UP_NS_100MHZ;
   assign  FPGA_REG_TA3_MIN_UP_80MHZ_ta3_min_up_ns_80MHZ =  TA3_MIN_UP_NS_80MHZ;
   assign  FPGA_REG_TA3_MIN_UP_60MHZ_ta3_min_up_ns_60MHZ =  TA3_MIN_UP_NS_60MHZ;
   assign  FPGA_REG_TA3_MIN_UP_40MHZ_ta3_min_up_ns_40MHZ =  TA3_MIN_UP_NS_40MHZ;
   assign  FPGA_REG_TA3_MIN_UP_20MHZ_ta3_min_up_ns_20MHZ =  TA3_MIN_UP_NS_20MHZ;
   assign  FPGA_REG_TA3_MIN_UP_15MHZ_ta3_min_up_ns_15MHZ =  TA3_MIN_UP_NS_15MHZ;
   assign  FPGA_REG_TA3_MIN_UP_10MHZ_ta3_min_up_ns_10MHZ =  TA3_MIN_UP_NS_10MHZ;
   assign  FPGA_REG_TA3_MIN_UP_5MHZ_ta3_min_up_ns_5MHZ =  TA3_MIN_UP_NS_5MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_100MHZ_ta3_min_up_prach_ns_100MHZ =  TA3_MIN_UP_PRACH_NS_100MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_80MHZ_ta3_min_up_prach_ns_80MHZ =  TA3_MIN_UP_PRACH_NS_80MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_60MHZ_ta3_min_up_prach_ns_60MHZ =  TA3_MIN_UP_PRACH_NS_60MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_40MHZ_ta3_min_up_prach_ns_40MHZ =  TA3_MIN_UP_PRACH_NS_40MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_20MHZ_ta3_min_up_prach_ns_20MHZ =  TA3_MIN_UP_PRACH_NS_20MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_15MHZ_ta3_min_up_prach_ns_15MHZ =  TA3_MIN_UP_PRACH_NS_15MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_10MHZ_ta3_min_up_prach_ns_10MHZ =  TA3_MIN_UP_PRACH_NS_10MHZ;
   assign  FPGA_REG_TA3_MIN_UP_PRACH_5MHZ_ta3_min_up_prach_ns_5MHZ =  TA3_MIN_UP_PRACH_NS_5MHZ;
   assign  FPGA_REG_TUP_TRANSMISION_WINDOW_UL_tup_transmission_window_ul_ns =  TUP_TRANSMISSION_WINDOW_UL_NS;
   assign  FPGA_REG_T2A_MIN_CP_UL_t2a_min_cp_ul_ns =  T2A_MIN_CP_UL_NS;
   assign  FPGA_REG_TCP_RECEPTION_WINDOW_UL_tcp_reception_window_ul_ns =  TCP_RECEPTION_WINDOW_UL_NS;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_100MHZ_dl_frm_mrkr_time_advance_100mhz =  DL_FRM_MRKR_TIME_ADVANCE_100MHZ;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_80MHZ_dl_frm_mrkr_time_advance_80mhz =  DL_FRM_MRKR_TIME_ADVANCE_80MHZ;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_60MHZ_dl_frm_mrkr_time_advance_60mhz =  DL_FRM_MRKR_TIME_ADVANCE_60MHZ;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_40MHZ_dl_frm_mrkr_time_advance_40mhz =  DL_FRM_MRKR_TIME_ADVANCE_40MHZ;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_20MHZ_dl_frm_mrkr_time_advance_20mhz =  DL_FRM_MRKR_TIME_ADVANCE_20MHZ;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_15MHZ_dl_frm_mrkr_time_advance_15mhz =  DL_FRM_MRKR_TIME_ADVANCE_15MHZ;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_10MHZ_dl_frm_mrkr_time_advance_10mhz =  DL_FRM_MRKR_TIME_ADVANCE_10MHZ;
   assign  FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_5MHZ_dl_frm_mrkr_time_advance_5mhz =  DL_FRM_MRKR_TIME_ADVANCE_5MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_100MHZ_ul_frm_mrkr_time_delay_100mhz =  UL_FRM_MRKR_TIME_DELAY_100MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_80MHZ_ul_frm_mrkr_time_delay_80mhz =  UL_FRM_MRKR_TIME_DELAY_80MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_60MHZ_ul_frm_mrkr_time_delay_60mhz =  UL_FRM_MRKR_TIME_DELAY_60MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_40MHZ_ul_frm_mrkr_time_delay_40mhz =  UL_FRM_MRKR_TIME_DELAY_40MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_20MHZ_ul_frm_mrkr_time_delay_20mhz =  UL_FRM_MRKR_TIME_DELAY_20MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_15MHZ_ul_frm_mrkr_time_delay_15mhz =  UL_FRM_MRKR_TIME_DELAY_15MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_10MHZ_ul_frm_mrkr_time_delay_10mhz =  UL_FRM_MRKR_TIME_DELAY_10MHZ;
   assign  FPGA_REG_UL_FRM_MRKR_TIME_DELAY_5MHZ_ul_frm_mrkr_time_delay_5mhz =  UL_FRM_MRKR_TIME_DELAY_5MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_100MHZ_prach_frm_mrkr_time_delay_100mhz =  PRACH_FRM_MRKR_TIME_DELAY_100MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_80MHZ_prach_frm_mrkr_time_delay_80mhz =  PRACH_FRM_MRKR_TIME_DELAY_80MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_60MHZ_prach_frm_mrkr_time_delay_60mhz =  PRACH_FRM_MRKR_TIME_DELAY_60MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_40MHZ_prach_frm_mrkr_time_delay_40mhz =  PRACH_FRM_MRKR_TIME_DELAY_40MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_20MHZ_prach_frm_mrkr_time_delay_20mhz =  PRACH_FRM_MRKR_TIME_DELAY_20MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_15MHZ_prach_frm_mrkr_time_delay_15mhz =  PRACH_FRM_MRKR_TIME_DELAY_15MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_10MHZ_prach_frm_mrkr_time_delay_10mhz =  PRACH_FRM_MRKR_TIME_DELAY_10MHZ;
   assign  FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_5MHZ_prach_frm_mrkr_time_delay_5mhz =  PRACH_FRM_MRKR_TIME_DELAY_5MHZ;
   assign  FPGA_REG_TSSI_CFG_tssi_samples_per_15p36_tic =  TSSI_SAMPLES_PER_15P36_TIC;
   assign  FPGA_REG_TSSI_CFG_tssi_accum_truncated_bits =  TSSI_ACCUM_TRUNCATED_BITS;
   assign  FPGA_REG_WRSSI_CFG_wrssi_samples_per_15p36_tic =  WRSSI_SAMPLES_PER_15P36_TIC;
   assign  FPGA_REG_WRSSI_CFG_wrssi_accum_truncated_bits =  WRSSI_ACCUM_TRUNCATED_BITS;
   assign  FPGA_REG_RSSI_20M_CFG_rssi_samples_per_15p36_tic_20M =  RSSI_SAMPLES_PER_15P36_TIC_20M;
   assign  FPGA_REG_RSSI_20M_CFG_rssi_accum_truncated_bits =  RSSI_ACCUM_TRUNCATED_BITS;
   assign  FPGA_REG_CFR_SAMPLE_PERIOD_cfr_sample_period_ps =  CFR_SAMPLE_PERIOD_PS;
   assign  FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_path_delay_sample_period_ps =  PATH_DELAY_SAMPLE_PERIOD_PS;
   assign  FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_dl_time_delay_bypass =  DL_TIME_DELAY_BYPASS;
   assign  FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_ul_time_delay_bypass =  UL_TIME_DELAY_BYPASS;




////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_cmn_ctrl.hw_id =  FPGA_REG_HW_ID_hw_id;
   assign  IFP_cmn_ctrl.soft_reset =  FPGA_REG_SOFT_RESET_REGISTER_soft_reset;
   assign  IFP_cmn_ctrl.xssi_num_15p36_tics =  FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics;
   assign  IFP_cmn_ctrl.frm_mrkr_gen_enable[0] =  FPGA_REG_FRM_MRKR_GEN_CFG_c0_frm_mrkr_gen_enable;
   assign  IFP_cmn_ctrl.frm_mrkr_gen_enable[1] =  FPGA_REG_FRM_MRKR_GEN_CFG_c1_frm_mrkr_gen_enable;
   assign  IFP_cmn_ctrl.frm_mrkr_gen_trigger[0] =  FPGA_REG_FRM_MRKR_GEN_TRIGGER_c0_frm_mrkr_gen_trigger;
   assign  IFP_cmn_ctrl.frm_mrkr_gen_trigger[1] =  FPGA_REG_FRM_MRKR_GEN_TRIGGER_c1_frm_mrkr_gen_trigger;
   assign  IFP_cmn_ctrl.dl_stream_en[0][0] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a0_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][0] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a0_en;
   assign  IFP_cmn_ctrl.dl_stream_en[0][1] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a1_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][1] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a1_en;
   assign  IFP_cmn_ctrl.dl_stream_en[0][2] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a2_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][2] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a2_en;
   assign  IFP_cmn_ctrl.dl_stream_en[0][3] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a3_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][3] =  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a3_en;
   assign  IFP_cmn_ctrl.dl_stream_en[0][4] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a4_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][4] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a4_en;
   assign  IFP_cmn_ctrl.dl_stream_en[0][5] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a5_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][5] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a5_en;
   assign  IFP_cmn_ctrl.dl_stream_en[0][6] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a6_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][6] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a6_en;
   assign  IFP_cmn_ctrl.dl_stream_en[0][7] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a7_en;
   assign  IFP_cmn_ctrl.dl_stream_en[1][7] =  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a7_en;
   assign  IFP_cmn_ctrl.dl_car_bw[0] =  FPGA_REG_DL_CAR_CFG_dl_car0_bw;
   assign  IFP_cmn_ctrl.dl_car_bw[1] =  FPGA_REG_DL_CAR_CFG_dl_car1_bw;
   assign  IFP_cmn_ctrl.ul_stream_en[0][0] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a0_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][0] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a0_en;
   assign  IFP_cmn_ctrl.ul_stream_en[0][1] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a1_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][1] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a1_en;
   assign  IFP_cmn_ctrl.ul_stream_en[0][2] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a2_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][2] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a2_en;
   assign  IFP_cmn_ctrl.ul_stream_en[0][3] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a3_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][3] =  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a3_en;
   assign  IFP_cmn_ctrl.ul_stream_en[0][4] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a4_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][4] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a4_en;
   assign  IFP_cmn_ctrl.ul_stream_en[0][5] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a5_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][5] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a5_en;
   assign  IFP_cmn_ctrl.ul_stream_en[0][6] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a6_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][6] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a6_en;
   assign  IFP_cmn_ctrl.ul_stream_en[0][7] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a7_en;
   assign  IFP_cmn_ctrl.ul_stream_en[1][7] =  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a7_en;
   assign  IFP_cmn_ctrl.ul_car_bw[0] =  FPGA_REG_UL_CAR_CFG_ul_car0_bw;
   assign  IFP_cmn_ctrl.ul_car_bw[1] =  FPGA_REG_UL_CAR_CFG_ul_car1_bw;
   assign  IFP_cmn_ctrl.dl_frm_mrkr_cntr_ns[0] =  FPGA_REG_DL_C0_FRM_MRKR_CNTR_NS_dl_c0_frm_mrkr_cntr_ns;
   assign  IFP_cmn_ctrl.dl_frm_mrkr_cntr_ns[1] =  FPGA_REG_DL_C1_FRM_MRKR_CNTR_NS_dl_c1_frm_mrkr_cntr_ns;
   assign  IFP_cmn_ctrl.ul_frm_mrkr_cntr_ns[0] =  FPGA_REG_UL_C0_FRM_MRKR_CNTR_NS_ul_c0_frm_mrkr_cntr_ns;
   assign  IFP_cmn_ctrl.ul_frm_mrkr_cntr_ns[1] =  FPGA_REG_UL_C1_FRM_MRKR_CNTR_NS_ul_c1_frm_mrkr_cntr_ns;
   assign  IFP_cmn_ctrl.prach_frm_mrkr_cntr_ns[0] =  FPGA_REG_PRACH_C0_FRM_MRKR_CNTR_NS_prach_c0_frm_mrkr_cntr_ns;
   assign  IFP_cmn_ctrl.prach_frm_mrkr_cntr_ns[1] =  FPGA_REG_PRACH_C1_FRM_MRKR_CNTR_NS_prach_c1_frm_mrkr_cntr_ns;
   assign  IFP_cmn_ctrl.com_scratch =  FPGA_REG_CMN_SCRATCH_com_scratch;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////





///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_HW_ID_hw_id <= 'h0;  // 
                  FPGA_REG_SOFT_RESET_REGISTER_soft_reset <= 'h0;  // bit 0 - Write 1 and then 0 to resets data path except Fronthaul. 
                  FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics <= 'h177000;  // Number of tics @15.36Mhz clock after which RSSI, WRSSI, TSSI re-loaded into registers
                  FPGA_REG_FRM_MRKR_GEN_CFG_c0_frm_mrkr_gen_enable <= 'h0;  // Enable for the Carrier0 Frame Generation Logic
                  FPGA_REG_FRM_MRKR_GEN_CFG_c1_frm_mrkr_gen_enable <= 'h0;  // Enable for the Carrier0 Frame Generation Logic
                  FPGA_REG_FRM_MRKR_GEN_TRIGGER_c0_frm_mrkr_gen_trigger <= 'h0;  // When a rising edge is created on this bit, Car0 Frame marker is generated based on configurd frame marker counters
                  FPGA_REG_FRM_MRKR_GEN_TRIGGER_c1_frm_mrkr_gen_trigger <= 'h0;  // When a rising edge is created on this bit, Car1 Frame marker is generated based on configurd frame marker counters
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a0_en <= 'h0;  // Enable for Carrier 0 in Antenna 0
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a0_en <= 'h0;  // Enable for Carrier 1 in Antenna 0
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a1_en <= 'h0;  // Enable for Carrier 0 in Antenna 1
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a1_en <= 'h0;  // Enable for Carrier 1 in Antenna 1
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a2_en <= 'h0;  // Enable for Carrier 0 in Antenna 2
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a2_en <= 'h0;  // Enable for Carrier 1 in Antenna 2
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a3_en <= 'h0;  // Enable for Carrier 0 in Antenna 3
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a3_en <= 'h0;  // Enable for Carrier 1 in Antenna 3
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a4_en <= 'h0;  // Enable for Carrier 0 in Antenna 4
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a4_en <= 'h0;  // Enable for Carrier 1 in Antenna 4
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a5_en <= 'h0;  // Enable for Carrier 0 in Antenna 5
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a5_en <= 'h0;  // Enable for Carrier 1 in Antenna 5
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a6_en <= 'h0;  // Enable for Carrier 0 in Antenna 6
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a6_en <= 'h0;  // Enable for Carrier 1 in Antenna 6
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a7_en <= 'h0;  // Enable for Carrier 0 in Antenna 7
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a7_en <= 'h0;  // Enable for Carrier 1 in Antenna 7
                  FPGA_REG_DL_CAR_CFG_dl_car0_bw <= 'h4;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                  FPGA_REG_DL_CAR_CFG_dl_car1_bw <= 'h4;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a0_en <= 'h0;  // Enable for Carrier 0 in Antenna 0
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a0_en <= 'h0;  // Enable for Carrier 1 in Antenna 0
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a1_en <= 'h0;  // Enable for Carrier 0 in Antenna 1
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a1_en <= 'h0;  // Enable for Carrier 1 in Antenna 1
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a2_en <= 'h0;  // Enable for Carrier 0 in Antenna 2
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a2_en <= 'h0;  // Enable for Carrier 1 in Antenna 2
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a3_en <= 'h0;  // Enable for Carrier 0 in Antenna 3
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a3_en <= 'h0;  // Enable for Carrier 1 in Antenna 3
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a4_en <= 'h0;  // Enable for Carrier 0 in Antenna 4
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a4_en <= 'h0;  // Enable for Carrier 1 in Antenna 4
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a5_en <= 'h0;  // Enable for Carrier 0 in Antenna 5
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a5_en <= 'h0;  // Enable for Carrier 1 in Antenna 5
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a6_en <= 'h0;  // Enable for Carrier 0 in Antenna 6
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a6_en <= 'h0;  // Enable for Carrier 1 in Antenna 6
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a7_en <= 'h0;  // Enable for Carrier 0 in Antenna 7
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a7_en <= 'h0;  // Enable for Carrier 1 in Antenna 7
                  FPGA_REG_UL_CAR_CFG_ul_car0_bw <= 'h4;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                  FPGA_REG_UL_CAR_CFG_ul_car1_bw <= 'h4;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                  FPGA_REG_DL_C0_FRM_MRKR_CNTR_NS_dl_c0_frm_mrkr_cntr_ns <= 'h0;  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
                  FPGA_REG_DL_C1_FRM_MRKR_CNTR_NS_dl_c1_frm_mrkr_cntr_ns <= 'h0;  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
                  FPGA_REG_UL_C0_FRM_MRKR_CNTR_NS_ul_c0_frm_mrkr_cntr_ns <= 'h0;  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
                  FPGA_REG_UL_C1_FRM_MRKR_CNTR_NS_ul_c1_frm_mrkr_cntr_ns <= 'h0;  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
                  FPGA_REG_PRACH_C0_FRM_MRKR_CNTR_NS_prach_c0_frm_mrkr_cntr_ns <= 'h0;  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
                  FPGA_REG_PRACH_C1_FRM_MRKR_CNTR_NS_prach_c1_frm_mrkr_cntr_ns <= 'h0;  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
                  FPGA_REG_CMN_SCRATCH_com_scratch <= 'h1111_aaaa;  // common scratch
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h2  : begin //'h8
                  FPGA_REG_HW_ID_hw_id <= IFP_axi_rw.wdata[15:0];  // 
             end
      11'h3  : begin //'hC
                  FPGA_REG_SOFT_RESET_REGISTER_soft_reset <= IFP_axi_rw.wdata[15:0];  // bit 0 - Write 1 and then 0 to resets data path except Fronthaul. 
             end
      11'h4  : begin //'h10
                  FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics <= IFP_axi_rw.wdata[20:0];  // Number of tics @15.36Mhz clock after which RSSI, WRSSI, TSSI re-loaded into registers
             end
      11'h5  : begin //'h14
                  FPGA_REG_FRM_MRKR_GEN_CFG_c0_frm_mrkr_gen_enable <= IFP_axi_rw.wdata[0];  // Enable for the Carrier0 Frame Generation Logic
                  FPGA_REG_FRM_MRKR_GEN_CFG_c1_frm_mrkr_gen_enable <= IFP_axi_rw.wdata[1];  // Enable for the Carrier0 Frame Generation Logic
             end
      11'h6  : begin //'h18
                  FPGA_REG_FRM_MRKR_GEN_TRIGGER_c0_frm_mrkr_gen_trigger <= IFP_axi_rw.wdata[0];  // When a rising edge is created on this bit, Car0 Frame marker is generated based on configurd frame marker counters
                  FPGA_REG_FRM_MRKR_GEN_TRIGGER_c1_frm_mrkr_gen_trigger <= IFP_axi_rw.wdata[1];  // When a rising edge is created on this bit, Car1 Frame marker is generated based on configurd frame marker counters
             end
      11'h80  : begin //'h200
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a0_en <= IFP_axi_rw.wdata[0];  // Enable for Carrier 0 in Antenna 0
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a0_en <= IFP_axi_rw.wdata[1];  // Enable for Carrier 1 in Antenna 0
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a1_en <= IFP_axi_rw.wdata[8];  // Enable for Carrier 0 in Antenna 1
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a1_en <= IFP_axi_rw.wdata[9];  // Enable for Carrier 1 in Antenna 1
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a2_en <= IFP_axi_rw.wdata[16];  // Enable for Carrier 0 in Antenna 2
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a2_en <= IFP_axi_rw.wdata[17];  // Enable for Carrier 1 in Antenna 2
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a3_en <= IFP_axi_rw.wdata[24];  // Enable for Carrier 0 in Antenna 3
                  FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a3_en <= IFP_axi_rw.wdata[25];  // Enable for Carrier 1 in Antenna 3
             end
      11'h81  : begin //'h204
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a4_en <= IFP_axi_rw.wdata[0];  // Enable for Carrier 0 in Antenna 4
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a4_en <= IFP_axi_rw.wdata[1];  // Enable for Carrier 1 in Antenna 4
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a5_en <= IFP_axi_rw.wdata[8];  // Enable for Carrier 0 in Antenna 5
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a5_en <= IFP_axi_rw.wdata[9];  // Enable for Carrier 1 in Antenna 5
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a6_en <= IFP_axi_rw.wdata[16];  // Enable for Carrier 0 in Antenna 6
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a6_en <= IFP_axi_rw.wdata[17];  // Enable for Carrier 1 in Antenna 6
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a7_en <= IFP_axi_rw.wdata[24];  // Enable for Carrier 0 in Antenna 7
                  FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a7_en <= IFP_axi_rw.wdata[25];  // Enable for Carrier 1 in Antenna 7
             end
      11'h82  : begin //'h208
                  FPGA_REG_DL_CAR_CFG_dl_car0_bw <= IFP_axi_rw.wdata[3:0];  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                  FPGA_REG_DL_CAR_CFG_dl_car1_bw <= IFP_axi_rw.wdata[11:8];  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
             end
      11'h100  : begin //'h400
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a0_en <= IFP_axi_rw.wdata[0];  // Enable for Carrier 0 in Antenna 0
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a0_en <= IFP_axi_rw.wdata[1];  // Enable for Carrier 1 in Antenna 0
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a1_en <= IFP_axi_rw.wdata[8];  // Enable for Carrier 0 in Antenna 1
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a1_en <= IFP_axi_rw.wdata[9];  // Enable for Carrier 1 in Antenna 1
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a2_en <= IFP_axi_rw.wdata[16];  // Enable for Carrier 0 in Antenna 2
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a2_en <= IFP_axi_rw.wdata[17];  // Enable for Carrier 1 in Antenna 2
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a3_en <= IFP_axi_rw.wdata[24];  // Enable for Carrier 0 in Antenna 3
                  FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a3_en <= IFP_axi_rw.wdata[25];  // Enable for Carrier 1 in Antenna 3
             end
      11'h101  : begin //'h404
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a4_en <= IFP_axi_rw.wdata[0];  // Enable for Carrier 0 in Antenna 4
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a4_en <= IFP_axi_rw.wdata[1];  // Enable for Carrier 1 in Antenna 4
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a5_en <= IFP_axi_rw.wdata[8];  // Enable for Carrier 0 in Antenna 5
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a5_en <= IFP_axi_rw.wdata[9];  // Enable for Carrier 1 in Antenna 5
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a6_en <= IFP_axi_rw.wdata[16];  // Enable for Carrier 0 in Antenna 6
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a6_en <= IFP_axi_rw.wdata[17];  // Enable for Carrier 1 in Antenna 6
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a7_en <= IFP_axi_rw.wdata[24];  // Enable for Carrier 0 in Antenna 7
                  FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a7_en <= IFP_axi_rw.wdata[25];  // Enable for Carrier 1 in Antenna 7
             end
      11'h102  : begin //'h408
                  FPGA_REG_UL_CAR_CFG_ul_car0_bw <= IFP_axi_rw.wdata[3:0];  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                  FPGA_REG_UL_CAR_CFG_ul_car1_bw <= IFP_axi_rw.wdata[11:8];  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
             end
      11'h180  : begin //'h600
                  FPGA_REG_DL_C0_FRM_MRKR_CNTR_NS_dl_c0_frm_mrkr_cntr_ns <= IFP_axi_rw.wdata[31:0];  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h181  : begin //'h604
                  FPGA_REG_DL_C1_FRM_MRKR_CNTR_NS_dl_c1_frm_mrkr_cntr_ns <= IFP_axi_rw.wdata[31:0];  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h182  : begin //'h608
                  FPGA_REG_UL_C0_FRM_MRKR_CNTR_NS_ul_c0_frm_mrkr_cntr_ns <= IFP_axi_rw.wdata[31:0];  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h183  : begin //'h60C
                  FPGA_REG_UL_C1_FRM_MRKR_CNTR_NS_ul_c1_frm_mrkr_cntr_ns <= IFP_axi_rw.wdata[31:0];  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h184  : begin //'h610
                  FPGA_REG_PRACH_C0_FRM_MRKR_CNTR_NS_prach_c0_frm_mrkr_cntr_ns <= IFP_axi_rw.wdata[31:0];  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h185  : begin //'h614
                  FPGA_REG_PRACH_C1_FRM_MRKR_CNTR_NS_prach_c1_frm_mrkr_cntr_ns <= IFP_axi_rw.wdata[31:0];  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h7ff  : begin //'h1FFC
                  FPGA_REG_CMN_SCRATCH_com_scratch <= IFP_axi_rw.wdata[31:0];  // common scratch
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
                   IFP_axi_rw.rdata[31:24] = FPGA_REG_VERSION_REGISTER_major_version;  // major version
                   IFP_axi_rw.rdata[23:16] = FPGA_REG_VERSION_REGISTER_minor_version;  // minor version
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_VERSION_REGISTER_revision_num;  // Revision number
             end
      11'h1  : begin//'h4
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_REVISION_debug_revision;  // Debug build version. Should be 0 for official builds.
             end
      11'h2  : begin//'h8
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_HW_ID_hw_id;  // 
             end
      11'h3  : begin//'hC
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_SOFT_RESET_REGISTER_soft_reset;  // bit 0 - Write 1 and then 0 to resets data path except Fronthaul. 
             end
      11'h4  : begin//'h10
                   IFP_axi_rw.rdata[20:0] = FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics;  // Number of tics @15.36Mhz clock after which RSSI, WRSSI, TSSI re-loaded into registers
             end
      11'h5  : begin//'h14
                   IFP_axi_rw.rdata[0] = FPGA_REG_FRM_MRKR_GEN_CFG_c0_frm_mrkr_gen_enable;  // Enable for the Carrier0 Frame Generation Logic
                   IFP_axi_rw.rdata[1] = FPGA_REG_FRM_MRKR_GEN_CFG_c1_frm_mrkr_gen_enable;  // Enable for the Carrier0 Frame Generation Logic
             end
      11'h6  : begin//'h18
                   IFP_axi_rw.rdata[0] = FPGA_REG_FRM_MRKR_GEN_TRIGGER_c0_frm_mrkr_gen_trigger;  // When a rising edge is created on this bit, Car0 Frame marker is generated based on configurd frame marker counters
                   IFP_axi_rw.rdata[1] = FPGA_REG_FRM_MRKR_GEN_TRIGGER_c1_frm_mrkr_gen_trigger;  // When a rising edge is created on this bit, Car1 Frame marker is generated based on configurd frame marker counters
             end
      11'h80  : begin//'h200
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a0_en;  // Enable for Carrier 0 in Antenna 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a0_en;  // Enable for Carrier 1 in Antenna 0
                   IFP_axi_rw.rdata[8] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a1_en;  // Enable for Carrier 0 in Antenna 1
                   IFP_axi_rw.rdata[9] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a1_en;  // Enable for Carrier 1 in Antenna 1
                   IFP_axi_rw.rdata[16] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a2_en;  // Enable for Carrier 0 in Antenna 2
                   IFP_axi_rw.rdata[17] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a2_en;  // Enable for Carrier 1 in Antenna 2
                   IFP_axi_rw.rdata[24] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c0a3_en;  // Enable for Carrier 0 in Antenna 3
                   IFP_axi_rw.rdata[25] = FPGA_REG_DL_STRM_EN_CFG0TO3_dl_c1a3_en;  // Enable for Carrier 1 in Antenna 3
             end
      11'h81  : begin//'h204
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a4_en;  // Enable for Carrier 0 in Antenna 4
                   IFP_axi_rw.rdata[1] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a4_en;  // Enable for Carrier 1 in Antenna 4
                   IFP_axi_rw.rdata[8] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a5_en;  // Enable for Carrier 0 in Antenna 5
                   IFP_axi_rw.rdata[9] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a5_en;  // Enable for Carrier 1 in Antenna 5
                   IFP_axi_rw.rdata[16] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a6_en;  // Enable for Carrier 0 in Antenna 6
                   IFP_axi_rw.rdata[17] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a6_en;  // Enable for Carrier 1 in Antenna 6
                   IFP_axi_rw.rdata[24] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c0a7_en;  // Enable for Carrier 0 in Antenna 7
                   IFP_axi_rw.rdata[25] = FPGA_REG_DL_STRM_EN_CFG4TO7_dl_c1a7_en;  // Enable for Carrier 1 in Antenna 7
             end
      11'h82  : begin//'h208
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_DL_CAR_CFG_dl_car0_bw;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_DL_CAR_CFG_dl_car1_bw;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
             end
      11'h100  : begin//'h400
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a0_en;  // Enable for Carrier 0 in Antenna 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a0_en;  // Enable for Carrier 1 in Antenna 0
                   IFP_axi_rw.rdata[8] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a1_en;  // Enable for Carrier 0 in Antenna 1
                   IFP_axi_rw.rdata[9] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a1_en;  // Enable for Carrier 1 in Antenna 1
                   IFP_axi_rw.rdata[16] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a2_en;  // Enable for Carrier 0 in Antenna 2
                   IFP_axi_rw.rdata[17] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a2_en;  // Enable for Carrier 1 in Antenna 2
                   IFP_axi_rw.rdata[24] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c0a3_en;  // Enable for Carrier 0 in Antenna 3
                   IFP_axi_rw.rdata[25] = FPGA_REG_UL_STRM_EN_CFG0TO3_ul_c1a3_en;  // Enable for Carrier 1 in Antenna 3
             end
      11'h101  : begin//'h404
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a4_en;  // Enable for Carrier 0 in Antenna 4
                   IFP_axi_rw.rdata[1] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a4_en;  // Enable for Carrier 1 in Antenna 4
                   IFP_axi_rw.rdata[8] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a5_en;  // Enable for Carrier 0 in Antenna 5
                   IFP_axi_rw.rdata[9] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a5_en;  // Enable for Carrier 1 in Antenna 5
                   IFP_axi_rw.rdata[16] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a6_en;  // Enable for Carrier 0 in Antenna 6
                   IFP_axi_rw.rdata[17] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a6_en;  // Enable for Carrier 1 in Antenna 6
                   IFP_axi_rw.rdata[24] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c0a7_en;  // Enable for Carrier 0 in Antenna 7
                   IFP_axi_rw.rdata[25] = FPGA_REG_UL_STRM_EN_CFG4TO7_ul_c1a7_en;  // Enable for Carrier 1 in Antenna 7
             end
      11'h102  : begin//'h408
                   IFP_axi_rw.rdata[3:0] = FPGA_REG_UL_CAR_CFG_ul_car0_bw;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
                   IFP_axi_rw.rdata[11:8] = FPGA_REG_UL_CAR_CFG_ul_car1_bw;  // 0: 20MHz  1:40MHz 2: 60Mhz 3:80Mhz, 4:100M
             end
      11'h180  : begin//'h600
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_C0_FRM_MRKR_CNTR_NS_dl_c0_frm_mrkr_cntr_ns;  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h181  : begin//'h604
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_C1_FRM_MRKR_CNTR_NS_dl_c1_frm_mrkr_cntr_ns;  // Nano Second System timer value at which frame marker needs to be genrated at RIDIO IF interface in DL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h182  : begin//'h608
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C0_FRM_MRKR_CNTR_NS_ul_c0_frm_mrkr_cntr_ns;  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h183  : begin//'h60C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_C1_FRM_MRKR_CNTR_NS_ul_c1_frm_mrkr_cntr_ns;  // Nano Second System timer value at which frame marker needs to be genrated at UL FFT input (UL DFE output)  interface in UL direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h184  : begin//'h610
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PRACH_C0_FRM_MRKR_CNTR_NS_prach_c0_frm_mrkr_cntr_ns;  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier0, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h185  : begin//'h614
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PRACH_C1_FRM_MRKR_CNTR_NS_prach_c1_frm_mrkr_cntr_ns;  // Nano Second System timer value at which frame marker needs to be genrated at PRACH  FFT input (PRACH DFE output)  interface in PRACH direction for carrier1, Needs to be calculated based on latency for that carrier Bandwidth
             end
      11'h400  : begin//'h1000
                   IFP_axi_rw.rdata[0] = FPGA_REG_CMN_FEATURE_SPRT_fh_mode;  // Front Haul mode, 0:Cpri, 1:ecpri
                   IFP_axi_rw.rdata[2:1] = FPGA_REG_CMN_FEATURE_SPRT_num_eth_cores;  // Number of SFPS  or Number of Eth Cores
                   IFP_axi_rw.rdata[4] = FPGA_REG_CMN_FEATURE_SPRT_fdd_supported;  // when set FDD is Supported
                   IFP_axi_rw.rdata[5] = FPGA_REG_CMN_FEATURE_SPRT_tdd_supported;  // when set TDD is Supported
                   IFP_axi_rw.rdata[15:8] = FPGA_REG_CMN_FEATURE_SPRT_max_supported_antennas;  // Number of Max Antenna Paths Supported
                   IFP_axi_rw.rdata[19:16] = FPGA_REG_CMN_FEATURE_SPRT_max_supported_carriers;  // Number of Max Carrier Paths Supported
                   IFP_axi_rw.rdata[23:20] = FPGA_REG_CMN_FEATURE_SPRT_max_precision;  // Maximum Supported I or Q Sample width
             end
      11'h401  : begin//'h1004
                   IFP_axi_rw.rdata[0] = FPGA_REG_CAR_FEATURE_SPRT_car0_lte_supported;  // When set lte is supported on carrier0
                   IFP_axi_rw.rdata[1] = FPGA_REG_CAR_FEATURE_SPRT_car1_lte_supported;  // When set 5G/NR is supported on carrier0
                   IFP_axi_rw.rdata[15] = FPGA_REG_CAR_FEATURE_SPRT_car0_5g_supported;  // When set lte is supported on carrier1
                   IFP_axi_rw.rdata[16] = FPGA_REG_CAR_FEATURE_SPRT_car1_5g_supported;  // When set 5G/NR is supported on carrier1
             end
      11'h402  : begin//'h1008
                   IFP_axi_rw.rdata[0] = FPGA_REG_NUMEROLOGY_SPRT_numerology0_supported;  // When set 15khz scs is supported
                   IFP_axi_rw.rdata[1] = FPGA_REG_NUMEROLOGY_SPRT_numerology1_supported;  // When set 30khz scs is supported
                   IFP_axi_rw.rdata[2] = FPGA_REG_NUMEROLOGY_SPRT_numerology2_supported;  // When set 60khz scs is supported
                   IFP_axi_rw.rdata[3] = FPGA_REG_NUMEROLOGY_SPRT_extended_cp_supported;  // When set extended CP is supoprted (60khz extened CP in 5G/NR, 15khz extended CP in LTE)
             end
      11'h403  : begin//'h100C
                   IFP_axi_rw.rdata[0] = FPGA_REG_SECTION_TYPE_SPRT_sec_type0_supported;  // Section Type 0 is supported
                   IFP_axi_rw.rdata[1] = FPGA_REG_SECTION_TYPE_SPRT_sec_type1_supported;  // Section Type 1 is supported
                   IFP_axi_rw.rdata[3] = FPGA_REG_SECTION_TYPE_SPRT_sec_type3_supported;  // Section Type 3 is supported
             end
      11'h440  : begin//'h1100
                   IFP_axi_rw.rdata[0] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format0_supported;  // When set prach LTE format0 is supported
                   IFP_axi_rw.rdata[1] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format1_supported;  // When set prach LTE format1 is supported
                   IFP_axi_rw.rdata[2] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format2_supported;  // When set prach LTE format2 is supported
                   IFP_axi_rw.rdata[3] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format3_supported;  // When set prach LTE format3 is supported
                   IFP_axi_rw.rdata[4] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_lte_format4_supported;  // When set prach LTE format4 is supported
             end
      11'h441  : begin//'h1104
                   IFP_axi_rw.rdata[0] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format0_supported;  // When set prach LTE format0 is supported
                   IFP_axi_rw.rdata[1] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format1_supported;  // When set prach LTE format1 is supported
                   IFP_axi_rw.rdata[2] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format2_supported;  // When set prach LTE format2 is supported
                   IFP_axi_rw.rdata[3] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format3_supported;  // When set prach LTE format3 is supported
                   IFP_axi_rw.rdata[4] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_lte_format4_supported;  // When set prach LTE format4 is supported
             end
      11'h442  : begin//'h1108
                   IFP_axi_rw.rdata[0] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format0_supported;  // When set prach NR format0 is supported
                   IFP_axi_rw.rdata[1] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format1_supported;  // When set prach NR format1 is supported
                   IFP_axi_rw.rdata[2] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format2_supported;  // When set prach NR format2 is supported
                   IFP_axi_rw.rdata[3] = FPGA_REG_CAR0_PRACH_FORMAT_SPRT_car0_prach_5g_format3_supported;  // When set prach NR format3 is supported
             end
      11'h443  : begin//'h110C
                   IFP_axi_rw.rdata[0] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format0_supported;  // When set prach NR format0 is supported
                   IFP_axi_rw.rdata[1] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format1_supported;  // When set prach NR format1 is supported
                   IFP_axi_rw.rdata[2] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format2_supported;  // When set prach NR format2 is supported
                   IFP_axi_rw.rdata[3] = FPGA_REG_CAR1_PRACH_FORMAT_SPRT_car1_prach_5g_format3_supported;  // When set prach NR format3 is supported
             end
      11'h480  : begin//'h1200
                   IFP_axi_rw.rdata[0] = FPGA_REG_CAR0_BW_SPRT_car0_bw_5mhz_supported;  // When set 5MHZ is supporterd
                   IFP_axi_rw.rdata[1] = FPGA_REG_CAR0_BW_SPRT_car0_bw_10mhz_supported;  // When set 10MHZ is supporterd
                   IFP_axi_rw.rdata[2] = FPGA_REG_CAR0_BW_SPRT_car0_bw_15mhz_supported;  // When set 15MHZ is supporterd
                   IFP_axi_rw.rdata[3] = FPGA_REG_CAR0_BW_SPRT_car0_bw_20mhz_supported;  // When set 20MHZ is supporterd
                   IFP_axi_rw.rdata[4] = FPGA_REG_CAR0_BW_SPRT_car0_bw_40mhz_supported;  // When set 40MHZ is supporterd
                   IFP_axi_rw.rdata[5] = FPGA_REG_CAR0_BW_SPRT_car0_bw_60mhz_supported;  // When set 60MHZ is supporterd
                   IFP_axi_rw.rdata[6] = FPGA_REG_CAR0_BW_SPRT_car0_bw_80mhz_supported;  // When set 80MHZ is supporterd
                   IFP_axi_rw.rdata[7] = FPGA_REG_CAR0_BW_SPRT_car0_bw_100mhz_supported;  // When set 100MHZ is supporterd
             end
      11'h4c0  : begin//'h1300
                   IFP_axi_rw.rdata[0] = FPGA_REG_CAR1_BW_SPRT_car1_bw_5mhz_supported;  // When set 5MHZ is supporterd
                   IFP_axi_rw.rdata[1] = FPGA_REG_CAR1_BW_SPRT_car1_bw_10mhz_supported;  // When set 10MHZ is supporterd
                   IFP_axi_rw.rdata[2] = FPGA_REG_CAR1_BW_SPRT_car1_bw_15mhz_supported;  // When set 15MHZ is supporterd
                   IFP_axi_rw.rdata[3] = FPGA_REG_CAR1_BW_SPRT_car1_bw_20mhz_supported;  // When set 20MHZ is supporterd
                   IFP_axi_rw.rdata[4] = FPGA_REG_CAR1_BW_SPRT_car1_bw_40mhz_supported;  // When set 40MHZ is supporterd
                   IFP_axi_rw.rdata[5] = FPGA_REG_CAR1_BW_SPRT_car1_bw_60mhz_supported;  // When set 60MHZ is supporterd
                   IFP_axi_rw.rdata[6] = FPGA_REG_CAR1_BW_SPRT_car1_bw_80mhz_supported;  // When set 80MHZ is supporterd
                   IFP_axi_rw.rdata[7] = FPGA_REG_CAR1_BW_SPRT_car1_bw_100mhz_supported;  // When set 100MHZ is supporterd
             end
      11'h4c1  : begin//'h1304
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_100MHZ_t2a_min_up_ns_100MHZ;  // T2a min for user plane when BW=100Mhz
             end
      11'h4c2  : begin//'h1308
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_80MHZ_t2a_min_up_ns_80MHZ;  // T2a min for user plane when BW=80Mhz
             end
      11'h4c3  : begin//'h130C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_60MHZ_t2a_min_up_ns_60MHZ;  // T2a min for user plane when BW=60Mhz
             end
      11'h4c4  : begin//'h1310
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_40MHZ_t2a_min_up_ns_40MHZ;  // T2a min for user plane when BW=40Mhz
             end
      11'h4c5  : begin//'h1314
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_20MHZ_t2a_min_up_ns_20MHZ;  // T2a min for user plane when BW=20Mhz
             end
      11'h4c7  : begin//'h131C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_15MHZ_t2a_min_up_ns_15MHZ;  // T2a min for user plane when BW=15Mhz
             end
      11'h4c8  : begin//'h1320
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_10MHZ_t2a_min_up_ns_10MHZ;  // T2a min for user plane when BW=10Mhz
             end
      11'h4c9  : begin//'h1324
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_UP_5MHZ_t2a_min_up_ns_5MHZ;  // T2a min for user plane when BW=5Mhz
             end
      11'h4ca  : begin//'h1328
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TUP_RECEPTION_WINDOW_DL_tup_reception_window_dl_ns;  // DL User Plane Reception Window
             end
      11'h4cb  : begin//'h132C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TCP_DL_RECEPTION_WINDOW_DL_tcp_reception_window_dl_ns;  // DL Control Plane reception Window
             end
      11'h4cc  : begin//'h1330
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TCP_ADV_DL_tcp_adv_dl_ns;  // Control Plane reception Window
             end
      11'h4cd  : begin//'h1334
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_100MHZ_ta3_min_up_ns_100MHZ;  // Ta3  min for user plane when BW=100Mhz for scs 30khz
             end
      11'h4ce  : begin//'h1338
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_80MHZ_ta3_min_up_ns_80MHZ;  // Ta3  min for user plane when BW=80Mhz for scs 30khz
             end
      11'h4cf  : begin//'h133C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_60MHZ_ta3_min_up_ns_60MHZ;  // Ta3 min for user plane when BW=60Mhz for scs 30khz
             end
      11'h4d0  : begin//'h1340
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_40MHZ_ta3_min_up_ns_40MHZ;  // Ta3 min for user plane when BW=40Mhz for scs 30khz
             end
      11'h4d1  : begin//'h1344
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_20MHZ_ta3_min_up_ns_20MHZ;  // Ta3 min for user plane when BW=20Mhz for scs 30khz
             end
      11'h4d2  : begin//'h1348
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_15MHZ_ta3_min_up_ns_15MHZ;  // Ta3 min for user plane when BW=15Mhz for scs 15khz
             end
      11'h4d3  : begin//'h134C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_10MHZ_ta3_min_up_ns_10MHZ;  // Ta3 min for user plane when BW=10Mhz for scs 15khz
             end
      11'h4d4  : begin//'h1350
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_5MHZ_ta3_min_up_ns_5MHZ;  // Ta3  min for user plane when BW=5Mhz for scs 15khz
             end
      11'h4d5  : begin//'h1354
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_100MHZ_ta3_min_up_prach_ns_100MHZ;  // Ta3  min for user plane when BW=100Mhz for scs 1.25khz
             end
      11'h4d6  : begin//'h1358
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_80MHZ_ta3_min_up_prach_ns_80MHZ;  // Ta3  min for user plane when BW=80Mhz for scs 1.25khz
             end
      11'h4d7  : begin//'h135C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_60MHZ_ta3_min_up_prach_ns_60MHZ;  // Ta3 min for user plane when BW=60Mhz for scs 1.25khz
             end
      11'h4d8  : begin//'h1360
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_40MHZ_ta3_min_up_prach_ns_40MHZ;  // Ta3 min for user plane when BW=40Mhz for scs 1.25khz
             end
      11'h4d9  : begin//'h1364
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_20MHZ_ta3_min_up_prach_ns_20MHZ;  // Ta3 min for user plane when BW=20Mhz for scs 1.25khz
             end
      11'h4da  : begin//'h1368
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_15MHZ_ta3_min_up_prach_ns_15MHZ;  // Ta3 min for user plane when BW=15Mhz for scs 1.25khz
             end
      11'h4db  : begin//'h136C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_10MHZ_ta3_min_up_prach_ns_10MHZ;  // Ta3 min for user plane when BW=10Mhz for scs 1.25khz
             end
      11'h4dc  : begin//'h1370
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TA3_MIN_UP_PRACH_5MHZ_ta3_min_up_prach_ns_5MHZ;  // Ta3  min for user plane when BW=5Mhz for scs 1.25khz
             end
      11'h4dd  : begin//'h1374
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TUP_TRANSMISION_WINDOW_UL_tup_transmission_window_ul_ns;  // User Plane Reception Window
             end
      11'h4de  : begin//'h1378
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_T2A_MIN_CP_UL_t2a_min_cp_ul_ns;  // This can 0  when we dont have beam forming
             end
      11'h4df  : begin//'h137C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_TCP_RECEPTION_WINDOW_UL_tcp_reception_window_ul_ns;  // Reception window time for UL Control Plane
             end
      11'h4e0  : begin//'h1380
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_100MHZ_dl_frm_mrkr_time_advance_100mhz;  // Frame Marker DL Time Advance for 100Mhz in ns
             end
      11'h4e1  : begin//'h1384
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_80MHZ_dl_frm_mrkr_time_advance_80mhz;  // Frame Marker DL Time Advance for 80Mhz in ns
             end
      11'h4e2  : begin//'h1388
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_60MHZ_dl_frm_mrkr_time_advance_60mhz;  // Frame Marker DL Time Advance for 60Mhz in ns
             end
      11'h4e3  : begin//'h138C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_40MHZ_dl_frm_mrkr_time_advance_40mhz;  // Frame Marker DL Time Advance for 40Mhz in ns
             end
      11'h4e4  : begin//'h1390
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_20MHZ_dl_frm_mrkr_time_advance_20mhz;  // Frame Marker DL Time Advance for 20Mhz in ns
             end
      11'h4e5  : begin//'h1394
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_15MHZ_dl_frm_mrkr_time_advance_15mhz;  // Frame Marker DL Time Advance for 15Mhz in ns
             end
      11'h4e6  : begin//'h1398
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_10MHZ_dl_frm_mrkr_time_advance_10mhz;  // Frame Marker DL Time Advance for 10Mhz in ns
             end
      11'h4e7  : begin//'h139C
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_DL_FRM_MRKR_TIME_ADVANCE_5MHZ_dl_frm_mrkr_time_advance_5mhz;  // Frame Marker DL Time Advance for 5Mhz in ns
             end
      11'h4e8  : begin//'h13A0
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_100MHZ_ul_frm_mrkr_time_delay_100mhz;  // Frame Marker Delay for uplink for 100Mhz in ns
             end
      11'h4e9  : begin//'h13A4
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_80MHZ_ul_frm_mrkr_time_delay_80mhz;  // Frame Marker Delay for uplink for 80Mhz in ns
             end
      11'h4ea  : begin//'h13A8
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_60MHZ_ul_frm_mrkr_time_delay_60mhz;  // Frame Marker Delay for uplink for 60Mhz in ns
             end
      11'h4eb  : begin//'h13AC
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_40MHZ_ul_frm_mrkr_time_delay_40mhz;  // Frame Marker Delay for uplink for 40Mhz in ns
             end
      11'h4ec  : begin//'h13B0
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_20MHZ_ul_frm_mrkr_time_delay_20mhz;  // Frame Marker Delay for uplink for 20Mhz in ns
             end
      11'h4ed  : begin//'h13B4
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_15MHZ_ul_frm_mrkr_time_delay_15mhz;  // Frame Marker Delay for uplink for 15Mhz in ns
             end
      11'h4ee  : begin//'h13B8
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_10MHZ_ul_frm_mrkr_time_delay_10mhz;  // Frame Marker Delay for uplink for 10Mhz in ns
             end
      11'h4ef  : begin//'h13BC
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_UL_FRM_MRKR_TIME_DELAY_5MHZ_ul_frm_mrkr_time_delay_5mhz;  // Frame Marker Delay for uplink for 5Mhz in ns
             end
      11'h4f0  : begin//'h13C0
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_100MHZ_prach_frm_mrkr_time_delay_100mhz;  // Frame Marker Delay for prach for 100Mhz in ns
             end
      11'h4f1  : begin//'h13C4
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_80MHZ_prach_frm_mrkr_time_delay_80mhz;  // Frame Marker Delay for prach for 80Mhz in ns
             end
      11'h4f2  : begin//'h13C8
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_60MHZ_prach_frm_mrkr_time_delay_60mhz;  // Frame Marker Delay for prach for 60Mhz in ns
             end
      11'h4f3  : begin//'h13CC
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_40MHZ_prach_frm_mrkr_time_delay_40mhz;  // Frame Marker Delay for prach for 40Mhz in ns
             end
      11'h4f4  : begin//'h13D0
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_20MHZ_prach_frm_mrkr_time_delay_20mhz;  // Frame Marker Delay for prach for 20Mhz in ns
             end
      11'h4f5  : begin//'h13D4
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_15MHZ_prach_frm_mrkr_time_delay_15mhz;  // Frame Marker Delay for prach for 15Mhz in ns
             end
      11'h4f6  : begin//'h13D8
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_10MHZ_prach_frm_mrkr_time_delay_10mhz;  // Frame Marker Delay for prach for 10Mhz in ns
             end
      11'h4f7  : begin//'h13DC
                   IFP_axi_rw.rdata[19:0] = FPGA_REG_PRACH_FRM_MRKR_TIME_DELAY_5MHZ_prach_frm_mrkr_time_delay_5mhz;  // Frame Marker Delay for prach for 5Mhz in ns
             end
      11'h4f8  : begin//'h13E0
                   IFP_axi_rw.rdata[7:0] = FPGA_REG_TSSI_CFG_tssi_samples_per_15p36_tic;  // 24 (0x18) for 368.64MHz, 32 (0x20) for 491.52MHz
                   IFP_axi_rw.rdata[15:8] = FPGA_REG_TSSI_CFG_tssi_accum_truncated_bits;  // Number of LSBs truncated
             end
      11'h4f9  : begin//'h13E4
                   IFP_axi_rw.rdata[7:0] = FPGA_REG_WRSSI_CFG_wrssi_samples_per_15p36_tic;  // 24 (0x18) for 368.64MHz, 32 (0x20) for 491.52MHz
                   IFP_axi_rw.rdata[15:8] = FPGA_REG_WRSSI_CFG_wrssi_accum_truncated_bits;  // Number of LSBs truncated
             end
      11'h4fa  : begin//'h13E8
                   IFP_axi_rw.rdata[7:0] = FPGA_REG_RSSI_20M_CFG_rssi_samples_per_15p36_tic_20M;  // 30.72/15.36=2 for 20MHz& 15Mhz.Software can extrapolate for other BWs, For example, 15.36/15.36=1 for 10MHz7.68/15.36=0.5 for 5Mhz
                   IFP_axi_rw.rdata[15:8] = FPGA_REG_RSSI_20M_CFG_rssi_accum_truncated_bits;  // Number of LSBs truncated
             end
      11'h4fb  : begin//'h13EC
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_CFR_SAMPLE_PERIOD_cfr_sample_period_ps;  // Sample period in ps used by CFR
             end
      11'h4fc  : begin//'h13F0
                   IFP_axi_rw.rdata[15:0] = FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_path_delay_sample_period_ps;  // Sample period in ps in the integer and fractional interpolator. This field is used to calculate the integer and fractional sample delay that needs to be programmed in  delay registers for UL & DL
                   IFP_axi_rw.rdata[16] = FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_dl_time_delay_bypass;  // when set  DL Time delay module which has integer and fractional interpolator is not included 
                   IFP_axi_rw.rdata[17] = FPGA_REG_PATH_DELAY_SAMPLE_PERIOD_ul_time_delay_bypass;  // when set UL Time delay module which has integer and fractional interpolator is not included 
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_CMN_SCRATCH_com_scratch;  // common scratch
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule