// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : YYS                                                         // 
// Date         : 10/30/23                                                    // 
// File         : sensemi_helpchip_regs.sv                                    // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 

module sensemi_helpchip_regs ( 
    input                           clk, 
    input                           srst,  
    sensemi_axi_regs_if.slave            IFP_axi_rw, 
    sensemi_helpchip_ctrl_if.ctrl         IFP_helpchip_ctrl,
    sensemi_helpchip_stat_if.stat         IFP_helpchip_stat 
);

    `include "sensemi_logan_params.svh"



////////////////Register Field Declarations//////////////////

   logic  [15:0]              HC_VERSION_REGISTER_hc_revision_num;
  // Revision number
   logic  [7:0]              HC_VERSION_REGISTER_hc_minor_version;
  // minor version
   logic  [7:0]              HC_VERSION_REGISTER_hc_major_version;
  // major version
   logic  [31:0]              HC_DEBUG_REVISION_hc_debug_revision;
  // Debug build version. Should be 0 for official builds. 
   logic  [31:0]              HC_TIMESTAMP_hc_timestamp;
  // timestamp
   logic  [31:0]              HC_DEBUG_RW_0_hc_debug_rw_0;
  // debug ethernet loopback
   logic  [31:0]              HC_DEBUG_RW_1_hc_debug_rw_1;
  // debug ethernet restart_tx_rx
   logic  [31:0]              HC_DEBUG_RW_2_hc_debug_rw_2;
  // debug ethernet sys_reset
   logic  [31:0]              HC_DEBUG_RW_3_hc_debug_rw_3;
  // 
   logic  [31:0]              HC_DEBUG_RW_4_hc_debug_rw_4;
  // 
   logic  [31:0]              HC_DEBUG_RW_5_hc_debug_rw_5;
  // 
   logic  [31:0]              HC_DEBUG_RW_6_hc_debug_rw_6;
  // 
   logic  [31:0]              HC_DEBUG_RW_7_hc_debug_rw_7;
  // 
   logic  [31:0]              HC_DEBUG_RW_8_hc_debug_rw_8;
  // 
   logic  [31:0]              HC_DEBUG_RW_9_hc_debug_rw_9;
  // 
   logic  [31:0]              HC_DEBUG_RW_10_hc_debug_rw_10;
  // 
   logic  [31:0]              HC_DEBUG_RW_11_hc_debug_rw_11;
  // 
   logic  [31:0]              HC_DEBUG_RW_12_hc_debug_rw_12;
  // 
   logic  [31:0]              HC_DEBUG_RW_13_hc_debug_rw_13;
  // 
   logic  [31:0]              HC_DEBUG_RW_14_hc_debug_rw_14;
  // 
   logic  [31:0]              HC_DEBUG_RW_15_hc_debug_rw_15;
  // 
   logic  [31:0]              HC_DEBUG_RW_16_hc_debug_rw_16;
  // 
   logic  [31:0]              HC_DEBUG_RW_17_hc_debug_rw_17;
  // 
   logic  [31:0]              HC_DEBUG_RW_18_hc_debug_rw_18;
  // 
   logic  [31:0]              HC_DEBUG_RW_19_hc_debug_rw_19;
  // 
   logic  [31:0]              HC_DEBUG_RW_20_hc_debug_rw_20;
  // 
   logic  [31:0]              HC_DEBUG_RW_21_hc_debug_rw_21;
  // 
   logic  [31:0]              HC_DEBUG_RW_22_hc_debug_rw_22;
  // 
   logic  [31:0]              HC_DEBUG_RW_23_hc_debug_rw_23;
  //  
   logic  [31:0]              HC_DEBUG_RW_24_hc_debug_rw_24;
  //  
   logic  [31:0]              HC_DEBUG_RW_25_hc_debug_rw_25;
  //  
   logic  [31:0]              HC_DEBUG_RW_26_hc_debug_rw_26;
  //  
   logic  [31:0]              HC_DEBUG_RW_27_hc_debug_rw_27;
  //  
   logic  [31:0]              HC_DEBUG_RW_28_hc_debug_rw_28;
  //  
   logic  [31:0]              HC_DEBUG_RW_29_hc_debug_rw_29;
  //  
   logic  [31:0]              HC_DEBUG_RW_30_hc_debug_rw_30;
  // 
   logic  [31:0]              HC_DBG_SCRATCH_hc_dbg_scratch;
  //  








////////////////ASSIGN PARAMETERS//////////////////

   assign  HC_VERSION_REGISTER_hc_revision_num =  HC_REVISION_NUM;
   assign  HC_VERSION_REGISTER_hc_minor_version =  HC_MINOR_VERSION;
   assign  HC_VERSION_REGISTER_hc_major_version =  HC_MAJOR_VERSION;
   assign  HC_DEBUG_REVISION_hc_debug_revision =  HC_DEBUG_REVISION;




////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_helpchip_ctrl.debug_rw[0] =  HC_DEBUG_RW_0_hc_debug_rw_0;
   assign  IFP_helpchip_ctrl.debug_rw[1] =  HC_DEBUG_RW_1_hc_debug_rw_1;
   assign  IFP_helpchip_ctrl.debug_rw[2] =  HC_DEBUG_RW_2_hc_debug_rw_2;
   assign  IFP_helpchip_ctrl.debug_rw[3] =  HC_DEBUG_RW_3_hc_debug_rw_3;
   assign  IFP_helpchip_ctrl.debug_rw[4] =  HC_DEBUG_RW_4_hc_debug_rw_4;
   assign  IFP_helpchip_ctrl.debug_rw[5] =  HC_DEBUG_RW_5_hc_debug_rw_5;
   assign  IFP_helpchip_ctrl.debug_rw[6] =  HC_DEBUG_RW_6_hc_debug_rw_6;
   assign  IFP_helpchip_ctrl.debug_rw[7] =  HC_DEBUG_RW_7_hc_debug_rw_7;
   assign  IFP_helpchip_ctrl.debug_rw[8] =  HC_DEBUG_RW_8_hc_debug_rw_8;
   assign  IFP_helpchip_ctrl.debug_rw[9] =  HC_DEBUG_RW_9_hc_debug_rw_9;
   assign  IFP_helpchip_ctrl.debug_rw[10] =  HC_DEBUG_RW_10_hc_debug_rw_10;
   assign  IFP_helpchip_ctrl.debug_rw[11] =  HC_DEBUG_RW_11_hc_debug_rw_11;
   assign  IFP_helpchip_ctrl.debug_rw[12] =  HC_DEBUG_RW_12_hc_debug_rw_12;
   assign  IFP_helpchip_ctrl.debug_rw[13] =  HC_DEBUG_RW_13_hc_debug_rw_13;
   assign  IFP_helpchip_ctrl.debug_rw[14] =  HC_DEBUG_RW_14_hc_debug_rw_14;
   assign  IFP_helpchip_ctrl.debug_rw[15] =  HC_DEBUG_RW_15_hc_debug_rw_15;
   assign  IFP_helpchip_ctrl.debug_rw[16] =  HC_DEBUG_RW_16_hc_debug_rw_16;
   assign  IFP_helpchip_ctrl.debug_rw[17] =  HC_DEBUG_RW_17_hc_debug_rw_17;
   assign  IFP_helpchip_ctrl.debug_rw[18] =  HC_DEBUG_RW_18_hc_debug_rw_18;
   assign  IFP_helpchip_ctrl.debug_rw[19] =  HC_DEBUG_RW_19_hc_debug_rw_19;
   assign  IFP_helpchip_ctrl.debug_rw[20] =  HC_DEBUG_RW_20_hc_debug_rw_20;
   assign  IFP_helpchip_ctrl.debug_rw[21] =  HC_DEBUG_RW_21_hc_debug_rw_21;
   assign  IFP_helpchip_ctrl.debug_rw[22] =  HC_DEBUG_RW_22_hc_debug_rw_22;
   assign  IFP_helpchip_ctrl.debug_rw[23] =  HC_DEBUG_RW_23_hc_debug_rw_23;
   assign  IFP_helpchip_ctrl.debug_rw[24] =  HC_DEBUG_RW_24_hc_debug_rw_24;
   assign  IFP_helpchip_ctrl.debug_rw[25] =  HC_DEBUG_RW_25_hc_debug_rw_25;
   assign  IFP_helpchip_ctrl.debug_rw[26] =  HC_DEBUG_RW_26_hc_debug_rw_26;
   assign  IFP_helpchip_ctrl.debug_rw[27] =  HC_DEBUG_RW_27_hc_debug_rw_27;
   assign  IFP_helpchip_ctrl.debug_rw[28] =  HC_DEBUG_RW_28_hc_debug_rw_28;
   assign  IFP_helpchip_ctrl.debug_rw[29] =  HC_DEBUG_RW_29_hc_debug_rw_29;
   assign  IFP_helpchip_ctrl.debug_rw[30] =  HC_DEBUG_RW_30_hc_debug_rw_30;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  HC_TIMESTAMP_hc_timestamp = IFP_helpchip_stat.hc_timestamp;




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  HC_DEBUG_RW_0_hc_debug_rw_0 <= 'h0;  // debug ethernet loopback
                  HC_DEBUG_RW_1_hc_debug_rw_1 <= 'h1;  // debug ethernet restart_tx_rx
                  HC_DEBUG_RW_2_hc_debug_rw_2 <= 'h1;  // debug ethernet sys_reset
                  HC_DEBUG_RW_3_hc_debug_rw_3 <= 'h0;  // 
                  HC_DEBUG_RW_4_hc_debug_rw_4 <= 'h0;  // 
                  HC_DEBUG_RW_5_hc_debug_rw_5 <= 'h0;  // 
                  HC_DEBUG_RW_6_hc_debug_rw_6 <= 'h0;  // 
                  HC_DEBUG_RW_7_hc_debug_rw_7 <= 'h0;  // 
                  HC_DEBUG_RW_8_hc_debug_rw_8 <= 'h0;  // 
                  HC_DEBUG_RW_9_hc_debug_rw_9 <= 'h0;  // 
                  HC_DEBUG_RW_10_hc_debug_rw_10 <= 'h0;  // 
                  HC_DEBUG_RW_11_hc_debug_rw_11 <= 'h0;  // 
                  HC_DEBUG_RW_12_hc_debug_rw_12 <= 'h0;  // 
                  HC_DEBUG_RW_13_hc_debug_rw_13 <= 'h0;  // 
                  HC_DEBUG_RW_14_hc_debug_rw_14 <= 'h0;  // 
                  HC_DEBUG_RW_15_hc_debug_rw_15 <= 'h0;  // 
                  HC_DEBUG_RW_16_hc_debug_rw_16 <= 'h0;  // 
                  HC_DEBUG_RW_17_hc_debug_rw_17 <= 'h0;  // 
                  HC_DEBUG_RW_18_hc_debug_rw_18 <= 'h0;  // 
                  HC_DEBUG_RW_19_hc_debug_rw_19 <= 'h0;  // 
                  HC_DEBUG_RW_20_hc_debug_rw_20 <= 'h0;  // 
                  HC_DEBUG_RW_21_hc_debug_rw_21 <= 'h0;  // 
                  HC_DEBUG_RW_22_hc_debug_rw_22 <= 'h0;  // 
                  HC_DEBUG_RW_23_hc_debug_rw_23 <= 'h0;  //  
                  HC_DEBUG_RW_24_hc_debug_rw_24 <= 'h0;  //  
                  HC_DEBUG_RW_25_hc_debug_rw_25 <= 'h0;  //  
                  HC_DEBUG_RW_26_hc_debug_rw_26 <= 'h0;  //  
                  HC_DEBUG_RW_27_hc_debug_rw_27 <= 'h0;  //  
                  HC_DEBUG_RW_28_hc_debug_rw_28 <= 'h0;  //  
                  HC_DEBUG_RW_29_hc_debug_rw_29 <= 'h0;  //  
                  HC_DEBUG_RW_30_hc_debug_rw_30 <= 'h0;  // 
                  HC_DBG_SCRATCH_hc_dbg_scratch <= 'h3333_cccc;  //  
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h7c0  : begin //'h1F00
                  HC_DEBUG_RW_0_hc_debug_rw_0 <= IFP_axi_rw.wdata[31:0];  // debug ethernet loopback
             end
      11'h7c1  : begin //'h1F04
                  HC_DEBUG_RW_1_hc_debug_rw_1 <= IFP_axi_rw.wdata[31:0];  // debug ethernet restart_tx_rx
             end
      11'h7c2  : begin //'h1F08
                  HC_DEBUG_RW_2_hc_debug_rw_2 <= IFP_axi_rw.wdata[31:0];  // debug ethernet sys_reset
             end
      11'h7c3  : begin //'h1F0C
                  HC_DEBUG_RW_3_hc_debug_rw_3 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c4  : begin //'h1F10
                  HC_DEBUG_RW_4_hc_debug_rw_4 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c5  : begin //'h1F14
                  HC_DEBUG_RW_5_hc_debug_rw_5 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c6  : begin //'h1F18
                  HC_DEBUG_RW_6_hc_debug_rw_6 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c7  : begin //'h1F1C
                  HC_DEBUG_RW_7_hc_debug_rw_7 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c8  : begin //'h1F20
                  HC_DEBUG_RW_8_hc_debug_rw_8 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c9  : begin //'h1F24
                  HC_DEBUG_RW_9_hc_debug_rw_9 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7ca  : begin //'h1F28
                  HC_DEBUG_RW_10_hc_debug_rw_10 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cb  : begin //'h1F2C
                  HC_DEBUG_RW_11_hc_debug_rw_11 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cc  : begin //'h1F30
                  HC_DEBUG_RW_12_hc_debug_rw_12 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cd  : begin //'h1F34
                  HC_DEBUG_RW_13_hc_debug_rw_13 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7ce  : begin //'h1F38
                  HC_DEBUG_RW_14_hc_debug_rw_14 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cf  : begin //'h1F3C
                  HC_DEBUG_RW_15_hc_debug_rw_15 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d0  : begin //'h1F40
                  HC_DEBUG_RW_16_hc_debug_rw_16 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d1  : begin //'h1F44
                  HC_DEBUG_RW_17_hc_debug_rw_17 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d2  : begin //'h1F48
                  HC_DEBUG_RW_18_hc_debug_rw_18 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d3  : begin //'h1F4C
                  HC_DEBUG_RW_19_hc_debug_rw_19 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d4  : begin //'h1F50
                  HC_DEBUG_RW_20_hc_debug_rw_20 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d5  : begin //'h1F54
                  HC_DEBUG_RW_21_hc_debug_rw_21 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d6  : begin //'h1F58
                  HC_DEBUG_RW_22_hc_debug_rw_22 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d7  : begin //'h1F5C
                  HC_DEBUG_RW_23_hc_debug_rw_23 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7d8  : begin //'h1F60
                  HC_DEBUG_RW_24_hc_debug_rw_24 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7d9  : begin //'h1F64
                  HC_DEBUG_RW_25_hc_debug_rw_25 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7da  : begin //'h1F68
                  HC_DEBUG_RW_26_hc_debug_rw_26 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7db  : begin //'h1F6C
                  HC_DEBUG_RW_27_hc_debug_rw_27 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7dc  : begin //'h1F70
                  HC_DEBUG_RW_28_hc_debug_rw_28 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7dd  : begin //'h1F74
                  HC_DEBUG_RW_29_hc_debug_rw_29 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7de  : begin //'h1F78
                  HC_DEBUG_RW_30_hc_debug_rw_30 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7ff  : begin //'h1FFC
                  HC_DBG_SCRATCH_hc_dbg_scratch <= IFP_axi_rw.wdata[31:0];  //  
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
                   IFP_axi_rw.rdata[15:0] = HC_VERSION_REGISTER_hc_revision_num;  // Revision number
                   IFP_axi_rw.rdata[23:16] = HC_VERSION_REGISTER_hc_minor_version;  // minor version
                   IFP_axi_rw.rdata[31:24] = HC_VERSION_REGISTER_hc_major_version;  // major version
             end
      11'h1  : begin//'h4
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_REVISION_hc_debug_revision;  // Debug build version. Should be 0 for official builds. 
             end
      11'h2  : begin//'h8
                   IFP_axi_rw.rdata[31:0] = HC_TIMESTAMP_hc_timestamp;  // timestamp
             end
      11'h7c0  : begin//'h1F00
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_0_hc_debug_rw_0;  // debug ethernet loopback
             end
      11'h7c1  : begin//'h1F04
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_1_hc_debug_rw_1;  // debug ethernet restart_tx_rx
             end
      11'h7c2  : begin//'h1F08
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_2_hc_debug_rw_2;  // debug ethernet sys_reset
             end
      11'h7c3  : begin//'h1F0C
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_3_hc_debug_rw_3;  // 
             end
      11'h7c4  : begin//'h1F10
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_4_hc_debug_rw_4;  // 
             end
      11'h7c5  : begin//'h1F14
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_5_hc_debug_rw_5;  // 
             end
      11'h7c6  : begin//'h1F18
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_6_hc_debug_rw_6;  // 
             end
      11'h7c7  : begin//'h1F1C
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_7_hc_debug_rw_7;  // 
             end
      11'h7c8  : begin//'h1F20
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_8_hc_debug_rw_8;  // 
             end
      11'h7c9  : begin//'h1F24
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_9_hc_debug_rw_9;  // 
             end
      11'h7ca  : begin//'h1F28
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_10_hc_debug_rw_10;  // 
             end
      11'h7cb  : begin//'h1F2C
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_11_hc_debug_rw_11;  // 
             end
      11'h7cc  : begin//'h1F30
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_12_hc_debug_rw_12;  // 
             end
      11'h7cd  : begin//'h1F34
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_13_hc_debug_rw_13;  // 
             end
      11'h7ce  : begin//'h1F38
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_14_hc_debug_rw_14;  // 
             end
      11'h7cf  : begin//'h1F3C
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_15_hc_debug_rw_15;  // 
             end
      11'h7d0  : begin//'h1F40
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_16_hc_debug_rw_16;  // 
             end
      11'h7d1  : begin//'h1F44
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_17_hc_debug_rw_17;  // 
             end
      11'h7d2  : begin//'h1F48
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_18_hc_debug_rw_18;  // 
             end
      11'h7d3  : begin//'h1F4C
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_19_hc_debug_rw_19;  // 
             end
      11'h7d4  : begin//'h1F50
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_20_hc_debug_rw_20;  // 
             end
      11'h7d5  : begin//'h1F54
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_21_hc_debug_rw_21;  // 
             end
      11'h7d6  : begin//'h1F58
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_22_hc_debug_rw_22;  // 
             end
      11'h7d7  : begin//'h1F5C
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_23_hc_debug_rw_23;  //  
             end
      11'h7d8  : begin//'h1F60
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_24_hc_debug_rw_24;  //  
             end
      11'h7d9  : begin//'h1F64
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_25_hc_debug_rw_25;  //  
             end
      11'h7da  : begin//'h1F68
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_26_hc_debug_rw_26;  //  
             end
      11'h7db  : begin//'h1F6C
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_27_hc_debug_rw_27;  //  
             end
      11'h7dc  : begin//'h1F70
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_28_hc_debug_rw_28;  //  
             end
      11'h7dd  : begin//'h1F74
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_29_hc_debug_rw_29;  //  
             end
      11'h7de  : begin//'h1F78
                   IFP_axi_rw.rdata[31:0] = HC_DEBUG_RW_30_hc_debug_rw_30;  // 
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = HC_DBG_SCRATCH_hc_dbg_scratch;  //  
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule