
module jb_test_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_test_ctrl_if.ctrl            IFP_test_ctrl
);



////////////////Register Field Declarations//////////////////

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
   logic  [31:0]              FPGA_REG_PA_INDICATE_pa_indicate;
  // bit 0 0 Vernon PA indicate  1 Mintake PA indicate 
   logic  [31:0]              FPGA_REG_DEBUG_RW_0_debug_rw_0;
  // tcs_frame_mode0:100% dl 1:70% dl & 30% ul 2:50% dl & 50% 3 100% ul
   logic  [31:0]              FPGA_REG_DEBUG_RW_1_debug_rw_1;
  // bit 0 ,only for test0 Data from DDR, override FH BUFF1 Data from FH BUFF,override DDR 
   logic  [31:0]              FPGA_REG_DEBUG_RW_2_debug_rw_2;
  // bit0,only for test0 Trig PSU alarm signal to generate pa protect1  Not any Trig
   logic  [31:0]              FPGA_REG_DEBUG_RW_3_debug_rw_3;
  // dl_frame_marke_cnt_ns
   logic  [31:0]              FPGA_REG_DEBUG_RW_4_debug_rw_4;
  // ul_frame_marke_cnt_ns
   logic  [31:0]              FPGA_REG_DEBUG_RW_5_debug_rw_5;
  // prach_rrame_marke_cnt_ns
   logic  [31:0]              FPGA_REG_DEBUG_RW_6_debug_rw_6;
  // [15:0] PA_Ctrl_in
   logic  [31:0]              FPGA_REG_DEBUG_RW_7_debug_rw_7;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_8_debug_rw_8;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_9_debug_rw_9;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_10_debug_rw_10;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_11_debug_rw_11;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_12_debug_rw_12;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_13_debug_rw_13;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_14_debug_rw_14;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_15_debug_rw_15;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_16_debug_rw_16;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_17_debug_rw_17;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_18_debug_rw_18;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_19_debug_rw_19;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_20_debug_rw_20;
  // Temporary. Not for software. Debug RW Register
   logic  [31:0]              FPGA_REG_DEBUG_RW_21_debug_rw_21;
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

   assign  IFP_test_ctrl.pa_indicate =  FPGA_REG_PA_INDICATE_pa_indicate;
   assign  IFP_test_ctrl.debug_rw[0] =  FPGA_REG_DEBUG_RW_0_debug_rw_0;
   assign  IFP_test_ctrl.debug_rw[1] =  FPGA_REG_DEBUG_RW_1_debug_rw_1;
   assign  IFP_test_ctrl.debug_rw[2] =  FPGA_REG_DEBUG_RW_2_debug_rw_2;
   assign  IFP_test_ctrl.debug_rw[3] =  FPGA_REG_DEBUG_RW_3_debug_rw_3;
   assign  IFP_test_ctrl.debug_rw[4] =  FPGA_REG_DEBUG_RW_4_debug_rw_4;
   assign  IFP_test_ctrl.debug_rw[5] =  FPGA_REG_DEBUG_RW_5_debug_rw_5;
   assign  IFP_test_ctrl.debug_rw[6] =  FPGA_REG_DEBUG_RW_6_debug_rw_6;
   assign  IFP_test_ctrl.debug_rw[7] =  FPGA_REG_DEBUG_RW_7_debug_rw_7;
   assign  IFP_test_ctrl.debug_rw[8] =  FPGA_REG_DEBUG_RW_8_debug_rw_8;
   assign  IFP_test_ctrl.debug_rw[9] =  FPGA_REG_DEBUG_RW_9_debug_rw_9;
   assign  IFP_test_ctrl.debug_rw[10] =  FPGA_REG_DEBUG_RW_10_debug_rw_10;
   assign  IFP_test_ctrl.debug_rw[11] =  FPGA_REG_DEBUG_RW_11_debug_rw_11;
   assign  IFP_test_ctrl.debug_rw[12] =  FPGA_REG_DEBUG_RW_12_debug_rw_12;
   assign  IFP_test_ctrl.debug_rw[13] =  FPGA_REG_DEBUG_RW_13_debug_rw_13;
   assign  IFP_test_ctrl.debug_rw[14] =  FPGA_REG_DEBUG_RW_14_debug_rw_14;
   assign  IFP_test_ctrl.debug_rw[15] =  FPGA_REG_DEBUG_RW_15_debug_rw_15;
   assign  IFP_test_ctrl.debug_rw[16] =  FPGA_REG_DEBUG_RW_16_debug_rw_16;
   assign  IFP_test_ctrl.debug_rw[17] =  FPGA_REG_DEBUG_RW_17_debug_rw_17;
   assign  IFP_test_ctrl.debug_rw[18] =  FPGA_REG_DEBUG_RW_18_debug_rw_18;
   assign  IFP_test_ctrl.debug_rw[19] =  FPGA_REG_DEBUG_RW_19_debug_rw_19;
   assign  IFP_test_ctrl.debug_rw[20] =  FPGA_REG_DEBUG_RW_20_debug_rw_20;
   assign  IFP_test_ctrl.debug_rw[21] =  FPGA_REG_DEBUG_RW_21_debug_rw_21;
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
                  FPGA_REG_PA_INDICATE_pa_indicate <= 'h0;  // bit 0 0 Vernon PA indicate  1 Mintake PA indicate 
                  FPGA_REG_DEBUG_RW_0_debug_rw_0 <= 'h9;  // tcs_frame_mode0:100% dl 1:70% dl & 30% ul 2:50% dl & 50% 3 100% ul
                  FPGA_REG_DEBUG_RW_1_debug_rw_1 <= 'h0;  // bit 0 ,only for test0 Data from DDR, override FH BUFF1 Data from FH BUFF,override DDR 
                  FPGA_REG_DEBUG_RW_2_debug_rw_2 <= 'h1;  // bit0,only for test0 Trig PSU alarm signal to generate pa protect1  Not any Trig
                  FPGA_REG_DEBUG_RW_3_debug_rw_3 <= 'h0x320;  // dl_frame_marke_cnt_ns
                  FPGA_REG_DEBUG_RW_4_debug_rw_4 <= 'h0x1320;  // ul_frame_marke_cnt_ns
                  FPGA_REG_DEBUG_RW_5_debug_rw_5 <= 'h0x2320;  // prach_rrame_marke_cnt_ns
                  FPGA_REG_DEBUG_RW_6_debug_rw_6 <= 'h099a01eb;  // [15:0] PA_Ctrl_in
                  FPGA_REG_DEBUG_RW_7_debug_rw_7 <= 'h02e100f5;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_8_debug_rw_8 <= 'h00f501eb;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_9_debug_rw_9 <= 'h00f502e1;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_10_debug_rw_10 <= 'h00f502e1;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_11_debug_rw_11 <= 'h00f501eb;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_12_debug_rw_12 <= 'h00f501eb;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_13_debug_rw_13 <= 'h00f501eb;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_14_debug_rw_14 <= 'h00f501eb;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_15_debug_rw_15 <= 'h00f501eb;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_16_debug_rw_16 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_17_debug_rw_17 <= 'h7300;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_18_debug_rw_18 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_19_debug_rw_19 <= 'h6712;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_20_debug_rw_20 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_DEBUG_RW_21_debug_rw_21 <= 'h0;  // Temporary. Not for software. Debug RW Register
                  FPGA_REG_VIO_CONFIG_UL_vio_config_ul <= 'h0;  // Temporary. Not for software
                  FPGA_REG_VIO_CONFIG_DL_vio_config_dl <= 'h0;  // Temporary. Not for software
                  FPGA_REG_ILA_CONFIG_ADC_ila_config_adc <= 'h0;  // Temporary. Not for software
                  FPGA_REG_ILA_CONFIG_DAC_ila_config_dac <= 'h0;  // Temporary. Not for software
                  FPGA_REG_DBG_SCRATCH_dbg_scratch <= 'h3333_cccc;  // 
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h9c  : begin //'h270
                  FPGA_REG_PA_INDICATE_pa_indicate <= IFP_axi_rw.wdata[31:0];  // bit 0 0 Vernon PA indicate  1 Mintake PA indicate 
             end
      11'h7c0  : begin //'h1F00
                  FPGA_REG_DEBUG_RW_0_debug_rw_0 <= IFP_axi_rw.wdata[31:0];  // tcs_frame_mode0:100% dl 1:70% dl & 30% ul 2:50% dl & 50% 3 100% ul
             end
      11'h7c1  : begin //'h1F04
                  FPGA_REG_DEBUG_RW_1_debug_rw_1 <= IFP_axi_rw.wdata[31:0];  // bit 0 ,only for test0 Data from DDR, override FH BUFF1 Data from FH BUFF,override DDR 
             end
      11'h7c2  : begin //'h1F08
                  FPGA_REG_DEBUG_RW_2_debug_rw_2 <= IFP_axi_rw.wdata[31:0];  // bit0,only for test0 Trig PSU alarm signal to generate pa protect1  Not any Trig
             end
      11'h7c3  : begin //'h1F0C
                  FPGA_REG_DEBUG_RW_3_debug_rw_3 <= IFP_axi_rw.wdata[31:0];  // dl_frame_marke_cnt_ns
             end
      11'h7c4  : begin //'h1F10
                  FPGA_REG_DEBUG_RW_4_debug_rw_4 <= IFP_axi_rw.wdata[31:0];  // ul_frame_marke_cnt_ns
             end
      11'h7c5  : begin //'h1F14
                  FPGA_REG_DEBUG_RW_5_debug_rw_5 <= IFP_axi_rw.wdata[31:0];  // prach_rrame_marke_cnt_ns
             end
      11'h7c6  : begin //'h1F18
                  FPGA_REG_DEBUG_RW_6_debug_rw_6 <= IFP_axi_rw.wdata[31:0];  // [15:0] PA_Ctrl_in
             end
      11'h7c7  : begin //'h1F1C
                  FPGA_REG_DEBUG_RW_7_debug_rw_7 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7c8  : begin //'h1F20
                  FPGA_REG_DEBUG_RW_8_debug_rw_8 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7c9  : begin //'h1F24
                  FPGA_REG_DEBUG_RW_9_debug_rw_9 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7ca  : begin //'h1F28
                  FPGA_REG_DEBUG_RW_10_debug_rw_10 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7cb  : begin //'h1F2C
                  FPGA_REG_DEBUG_RW_11_debug_rw_11 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7cc  : begin //'h1F30
                  FPGA_REG_DEBUG_RW_12_debug_rw_12 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7cd  : begin //'h1F34
                  FPGA_REG_DEBUG_RW_13_debug_rw_13 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7ce  : begin //'h1F38
                  FPGA_REG_DEBUG_RW_14_debug_rw_14 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7cf  : begin //'h1F3C
                  FPGA_REG_DEBUG_RW_15_debug_rw_15 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7d0  : begin //'h1F40
                  FPGA_REG_DEBUG_RW_16_debug_rw_16 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7d1  : begin //'h1F44
                  FPGA_REG_DEBUG_RW_17_debug_rw_17 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7d2  : begin //'h1F48
                  FPGA_REG_DEBUG_RW_18_debug_rw_18 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7d3  : begin //'h1F4C
                  FPGA_REG_DEBUG_RW_19_debug_rw_19 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7d4  : begin //'h1F50
                  FPGA_REG_DEBUG_RW_20_debug_rw_20 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7d5  : begin //'h1F54
                  FPGA_REG_DEBUG_RW_21_debug_rw_21 <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software. Debug RW Register
             end
      11'h7de  : begin //'h1F78
                  FPGA_REG_VIO_CONFIG_UL_vio_config_ul <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software
             end
      11'h7df  : begin //'h1F7C
                  FPGA_REG_VIO_CONFIG_DL_vio_config_dl <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software
             end
      11'h7e0  : begin //'h1F80
                  FPGA_REG_ILA_CONFIG_ADC_ila_config_adc <= IFP_axi_rw.wdata[31:0];  // Temporary. Not for software
             end
      11'h7e1  : begin //'h1F84
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
      11'h84  : begin//'h210
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT0_TSSI_ant0_tssi;  // Antenna 0 Path TSSI
             end
      11'h85  : begin//'h214
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT1_TSSI_ant1_tssi;  // Antenna 1 Path TSSI
             end
      11'h86  : begin//'h218
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT2_TSSI_ant2_tssi;  // Antenna 2 Path TSSI
             end
      11'h87  : begin//'h21C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT3_TSSI_ant3_tssi;  // Antenna 3 Path TSSI
             end
      11'h88  : begin//'h220
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT4_TSSI_ant4_tssi;  // Antenna 4 Path TSSI
             end
      11'h89  : begin//'h224
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT5_TSSI_ant5_tssi;  // Antenna 5 Path TSSI
             end
      11'h8a  : begin//'h228
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT6_TSSI_ant6_tssi;  // Antenna 6 Path TSSI
             end
      11'h8b  : begin//'h22C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DL_ANT7_TSSI_ant7_tssi;  // Antenna 7 Path TSSI
             end
      11'h8c  : begin//'h230
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT0_WRSSI_CFG_ul_ant0_wrssi;  // Antenna 0 Path wrssi 
             end
      11'h8d  : begin//'h234
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT1_WRSSI_CFG_ul_ant1_wrssi;  // Antenna 1 Path wrssi 
             end
      11'h8e  : begin//'h238
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT2_WRSSI_CFG_ul_ant2_wrssi;  // Antenna 2 Path wrssi 
             end
      11'h8f  : begin//'h23C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT3_WRSSI_CFG_ul_ant3_wrssi;  // Antenna 3 Path wrssi 
             end
      11'h90  : begin//'h240
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT4_WRSSI_CFG_ul_ant4_wrssi;  // Antenna 4 Path wrssi 
             end
      11'h91  : begin//'h244
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT5_WRSSI_CFG_ul_ant5_wrssi;  // Antenna 5 Path wrssi 
             end
      11'h92  : begin//'h248
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT6_WRSSI_CFG_ul_ant6_wrssi;  // Antenna 6 Path wrssi 
             end
      11'h93  : begin//'h24C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_UL_ANT7_WRSSI_CFG_ul_ant7_wrssi;  // Antenna 7 Path wrssi 
             end
      11'h94  : begin//'h250
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX0_WRSSI_orx0_wrssi;  // Observation Path Antenna 0 Path wrssi 
             end
      11'h95  : begin//'h254
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX1_WRSSI_orx1_wrssi;  // Observation Path Antenna 1 Path wrssi 
             end
      11'h96  : begin//'h258
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX2_WRSSI_orx2_wrssi;  // Observation Path Antenna 2 Path wrssi 
             end
      11'h97  : begin//'h25C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX3_WRSSI_orx3_wrssi;  // Observation Path Antenna 3 Path wrssi 
             end
      11'h98  : begin//'h260
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX4_WRSSI_orx4_wrssi;  // Observation Path Antenna 4 Path wrssi 
             end
      11'h99  : begin//'h264
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX5_WRSSI_orx5_wrssi;  // Observation Path Antenna 5 Path wrssi 
             end
      11'h9a  : begin//'h268
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX6_WRSSI_orx6_wrssi;  // Observation Path Antenna 6 Path wrssi 
             end
      11'h9b  : begin//'h26C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ORX7_WRSSI_orx7_wrssi;  // Observation Path Antenna 7 Path wrssi 
             end
      11'h9c  : begin//'h270
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_INDICATE_pa_indicate;  // bit 0 0 Vernon PA indicate  1 Mintake PA indicate 
             end
      11'h7c0  : begin//'h1F00
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_0_debug_rw_0;  // tcs_frame_mode0:100% dl 1:70% dl & 30% ul 2:50% dl & 50% 3 100% ul
             end
      11'h7c1  : begin//'h1F04
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_1_debug_rw_1;  // bit 0 ,only for test0 Data from DDR, override FH BUFF1 Data from FH BUFF,override DDR 
             end
      11'h7c2  : begin//'h1F08
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_2_debug_rw_2;  // bit0,only for test0 Trig PSU alarm signal to generate pa protect1  Not any Trig
             end
      11'h7c3  : begin//'h1F0C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_3_debug_rw_3;  // dl_frame_marke_cnt_ns
             end
      11'h7c4  : begin//'h1F10
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_4_debug_rw_4;  // ul_frame_marke_cnt_ns
             end
      11'h7c5  : begin//'h1F14
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_5_debug_rw_5;  // prach_rrame_marke_cnt_ns
             end
      11'h7c6  : begin//'h1F18
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_6_debug_rw_6;  // [15:0] PA_Ctrl_in
             end
      11'h7c7  : begin//'h1F1C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_7_debug_rw_7;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c8  : begin//'h1F20
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_8_debug_rw_8;  // Temporary. Not for software. Debug RW Register
             end
      11'h7c9  : begin//'h1F24
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_9_debug_rw_9;  // Temporary. Not for software. Debug RW Register
             end
      11'h7ca  : begin//'h1F28
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_10_debug_rw_10;  // Temporary. Not for software. Debug RW Register
             end
      11'h7cb  : begin//'h1F2C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_11_debug_rw_11;  // Temporary. Not for software. Debug RW Register
             end
      11'h7cc  : begin//'h1F30
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_12_debug_rw_12;  // Temporary. Not for software. Debug RW Register
             end
      11'h7cd  : begin//'h1F34
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_13_debug_rw_13;  // Temporary. Not for software. Debug RW Register
             end
      11'h7ce  : begin//'h1F38
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_14_debug_rw_14;  // Temporary. Not for software. Debug RW Register
             end
      11'h7cf  : begin//'h1F3C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_15_debug_rw_15;  // Temporary. Not for software. Debug RW Register
             end
      11'h7d0  : begin//'h1F40
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_16_debug_rw_16;  // Temporary. Not for software. Debug RW Register
             end
      11'h7d1  : begin//'h1F44
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_17_debug_rw_17;  // Temporary. Not for software. Debug RW Register
             end
      11'h7d2  : begin//'h1F48
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_18_debug_rw_18;  // Temporary. Not for software. Debug RW Register
             end
      11'h7d3  : begin//'h1F4C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_19_debug_rw_19;  // Temporary. Not for software. Debug RW Register
             end
      11'h7d4  : begin//'h1F50
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_20_debug_rw_20;  // Temporary. Not for software. Debug RW Register
             end
      11'h7d5  : begin//'h1F54
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RW_21_debug_rw_21;  // Temporary. Not for software. Debug RW Register
             end
      11'h7d6  : begin//'h1F58
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_0_debug_ro_0;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7d7  : begin//'h1F5C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_1_debug_ro_1;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7d8  : begin//'h1F60
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_2_debug_ro_2;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7d9  : begin//'h1F64
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_3_debug_ro_3;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7da  : begin//'h1F68
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_4_debug_ro_4;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7db  : begin//'h1F6C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_5_debug_ro_5;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7dc  : begin//'h1F70
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_6_debug_ro_6;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7dd  : begin//'h1F74
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_DEBUG_RO_7_debug_ro_7;  // Temporary. Not for software. Debug Read-Only Register
             end
      11'h7de  : begin//'h1F78
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_VIO_CONFIG_UL_vio_config_ul;  // Temporary. Not for software
             end
      11'h7df  : begin//'h1F7C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_VIO_CONFIG_DL_vio_config_dl;  // Temporary. Not for software
             end
      11'h7e0  : begin//'h1F80
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_ILA_CONFIG_ADC_ila_config_adc;  // Temporary. Not for software
             end
      11'h7e1  : begin//'h1F84
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