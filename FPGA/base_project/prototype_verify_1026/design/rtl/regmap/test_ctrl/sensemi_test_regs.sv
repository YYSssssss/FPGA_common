// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : YYS                                                         // 
// Date         : 10/30/23                                                    // 
// File         : sensemi_test_regs.sv                                        // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 

module sensemi_test_regs ( 
    input                           clk, 
    input                           srst,  
    sensemi_axi_regs_if.slave            IFP_axi_rw, 
    sensemi_test_ctrl_if.ctrl         IFP_test_ctrl,
    sensemi_test_stat_if.stat         IFP_test_stat 
);

    `include "sensemi_params.svh"



////////////////Register Field Declarations//////////////////

   logic  [15:0]              VERSION_REGISTER_revision_num;
  // Revision number
   logic  [7:0]              VERSION_REGISTER_minor_version;
  // minor version
   logic  [7:0]              VERSION_REGISTER_major_version;
  // major version
   logic  [31:0]              DEBUG_REVISION_debug_revision;
  // Debug build version. Should be 0 for official builds. 
   logic  [31:0]              TIMESTAMP_timestamp;
  // timestamp
   logic  [31:0]              DEBUG_RW_0_debug_rw_0;
  // debug ethernet loopback
   logic  [31:0]              DEBUG_RW_1_debug_rw_1;
  // debug ethernet restart_tx_rx
   logic  [31:0]              DEBUG_RW_2_debug_rw_2;
  // debug ethernet sys_reset
   logic  [31:0]              DEBUG_RW_3_debug_rw_3;
  // 
   logic  [31:0]              DEBUG_RW_4_debug_rw_4;
  // 
   logic  [31:0]              DEBUG_RW_5_debug_rw_5;
  // 
   logic  [31:0]              DEBUG_RW_6_debug_rw_6;
  // 
   logic  [31:0]              DEBUG_RW_7_debug_rw_7;
  // 
   logic  [31:0]              DEBUG_RW_8_debug_rw_8;
  // 
   logic  [31:0]              DEBUG_RW_9_debug_rw_9;
  // 
   logic  [31:0]              DEBUG_RW_10_debug_rw_10;
  // 
   logic  [31:0]              DEBUG_RW_11_debug_rw_11;
  // 
   logic  [31:0]              DEBUG_RW_12_debug_rw_12;
  // 
   logic  [31:0]              DEBUG_RW_13_debug_rw_13;
  // 
   logic  [31:0]              DEBUG_RW_14_debug_rw_14;
  // 
   logic  [31:0]              DEBUG_RW_15_debug_rw_15;
  // 
   logic  [31:0]              DEBUG_RW_16_debug_rw_16;
  // 
   logic  [31:0]              DEBUG_RW_17_debug_rw_17;
  // 
   logic  [31:0]              DEBUG_RW_18_debug_rw_18;
  // 
   logic  [31:0]              DEBUG_RW_19_debug_rw_19;
  // 
   logic  [31:0]              DEBUG_RW_20_debug_rw_20;
  // 
   logic  [31:0]              DEBUG_RW_21_debug_rw_21;
  // 
   logic  [31:0]              DEBUG_RW_22_debug_rw_22;
  // 
   logic  [31:0]              DEBUG_RW_23_debug_rw_23;
  //  
   logic  [31:0]              DEBUG_RW_24_debug_rw_24;
  //  
   logic  [31:0]              DEBUG_RW_25_debug_rw_25;
  //  
   logic  [31:0]              DEBUG_RW_26_debug_rw_26;
  //  
   logic  [31:0]              DEBUG_RW_27_debug_rw_27;
  //  
   logic  [31:0]              DEBUG_RW_28_debug_rw_28;
  //  
   logic  [31:0]              DEBUG_RW_29_debug_rw_29;
  //  
   logic  [31:0]              DEBUG_RW_30_debug_rw_30;
  // 
   logic  [31:0]              DBG_SCRATCH_dbg_scratch;
  //  








////////////////ASSIGN PARAMETERS//////////////////

   assign  VERSION_REGISTER_revision_num =  REVISION_NUM;
   assign  VERSION_REGISTER_minor_version =  MINOR_VERSION;
   assign  VERSION_REGISTER_major_version =  MAJOR_VERSION;
   assign  DEBUG_REVISION_debug_revision =  DEBUG_REVISION;




////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_test_ctrl.debug_rw[0] =  DEBUG_RW_0_debug_rw_0;
   assign  IFP_test_ctrl.debug_rw[1] =  DEBUG_RW_1_debug_rw_1;
   assign  IFP_test_ctrl.debug_rw[2] =  DEBUG_RW_2_debug_rw_2;
   assign  IFP_test_ctrl.debug_rw[3] =  DEBUG_RW_3_debug_rw_3;
   assign  IFP_test_ctrl.debug_rw[4] =  DEBUG_RW_4_debug_rw_4;
   assign  IFP_test_ctrl.debug_rw[5] =  DEBUG_RW_5_debug_rw_5;
   assign  IFP_test_ctrl.debug_rw[6] =  DEBUG_RW_6_debug_rw_6;
   assign  IFP_test_ctrl.debug_rw[7] =  DEBUG_RW_7_debug_rw_7;
   assign  IFP_test_ctrl.debug_rw[8] =  DEBUG_RW_8_debug_rw_8;
   assign  IFP_test_ctrl.debug_rw[9] =  DEBUG_RW_9_debug_rw_9;
   assign  IFP_test_ctrl.debug_rw[10] =  DEBUG_RW_10_debug_rw_10;
   assign  IFP_test_ctrl.debug_rw[11] =  DEBUG_RW_11_debug_rw_11;
   assign  IFP_test_ctrl.debug_rw[12] =  DEBUG_RW_12_debug_rw_12;
   assign  IFP_test_ctrl.debug_rw[13] =  DEBUG_RW_13_debug_rw_13;
   assign  IFP_test_ctrl.debug_rw[14] =  DEBUG_RW_14_debug_rw_14;
   assign  IFP_test_ctrl.debug_rw[15] =  DEBUG_RW_15_debug_rw_15;
   assign  IFP_test_ctrl.debug_rw[16] =  DEBUG_RW_16_debug_rw_16;
   assign  IFP_test_ctrl.debug_rw[17] =  DEBUG_RW_17_debug_rw_17;
   assign  IFP_test_ctrl.debug_rw[18] =  DEBUG_RW_18_debug_rw_18;
   assign  IFP_test_ctrl.debug_rw[19] =  DEBUG_RW_19_debug_rw_19;
   assign  IFP_test_ctrl.debug_rw[20] =  DEBUG_RW_20_debug_rw_20;
   assign  IFP_test_ctrl.debug_rw[21] =  DEBUG_RW_21_debug_rw_21;
   assign  IFP_test_ctrl.debug_rw[22] =  DEBUG_RW_22_debug_rw_22;
   assign  IFP_test_ctrl.debug_rw[23] =  DEBUG_RW_23_debug_rw_23;
   assign  IFP_test_ctrl.debug_rw[24] =  DEBUG_RW_24_debug_rw_24;
   assign  IFP_test_ctrl.debug_rw[25] =  DEBUG_RW_25_debug_rw_25;
   assign  IFP_test_ctrl.debug_rw[26] =  DEBUG_RW_26_debug_rw_26;
   assign  IFP_test_ctrl.debug_rw[27] =  DEBUG_RW_27_debug_rw_27;
   assign  IFP_test_ctrl.debug_rw[28] =  DEBUG_RW_28_debug_rw_28;
   assign  IFP_test_ctrl.debug_rw[29] =  DEBUG_RW_29_debug_rw_29;
   assign  IFP_test_ctrl.debug_rw[30] =  DEBUG_RW_30_debug_rw_30;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  TIMESTAMP_timestamp = IFP_test_stat.timestamp;




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  DEBUG_RW_0_debug_rw_0 <= 'h0;  // debug ethernet loopback
                  DEBUG_RW_1_debug_rw_1 <= 'h1;  // debug ethernet restart_tx_rx
                  DEBUG_RW_2_debug_rw_2 <= 'h1;  // debug ethernet sys_reset
                  DEBUG_RW_3_debug_rw_3 <= 'h0;  // 
                  DEBUG_RW_4_debug_rw_4 <= 'h0;  // 
                  DEBUG_RW_5_debug_rw_5 <= 'h0;  // 
                  DEBUG_RW_6_debug_rw_6 <= 'h0;  // 
                  DEBUG_RW_7_debug_rw_7 <= 'h0;  // 
                  DEBUG_RW_8_debug_rw_8 <= 'h0;  // 
                  DEBUG_RW_9_debug_rw_9 <= 'h0;  // 
                  DEBUG_RW_10_debug_rw_10 <= 'h0;  // 
                  DEBUG_RW_11_debug_rw_11 <= 'h0;  // 
                  DEBUG_RW_12_debug_rw_12 <= 'h0;  // 
                  DEBUG_RW_13_debug_rw_13 <= 'h0;  // 
                  DEBUG_RW_14_debug_rw_14 <= 'h0;  // 
                  DEBUG_RW_15_debug_rw_15 <= 'h0;  // 
                  DEBUG_RW_16_debug_rw_16 <= 'h0;  // 
                  DEBUG_RW_17_debug_rw_17 <= 'h0;  // 
                  DEBUG_RW_18_debug_rw_18 <= 'h0;  // 
                  DEBUG_RW_19_debug_rw_19 <= 'h0;  // 
                  DEBUG_RW_20_debug_rw_20 <= 'h0;  // 
                  DEBUG_RW_21_debug_rw_21 <= 'h0;  // 
                  DEBUG_RW_22_debug_rw_22 <= 'h0;  // 
                  DEBUG_RW_23_debug_rw_23 <= 'h0;  //  
                  DEBUG_RW_24_debug_rw_24 <= 'h0;  //  
                  DEBUG_RW_25_debug_rw_25 <= 'h0;  //  
                  DEBUG_RW_26_debug_rw_26 <= 'h0;  //  
                  DEBUG_RW_27_debug_rw_27 <= 'h0;  //  
                  DEBUG_RW_28_debug_rw_28 <= 'h0;  //  
                  DEBUG_RW_29_debug_rw_29 <= 'h0;  //  
                  DEBUG_RW_30_debug_rw_30 <= 'h0;  // 
                  DBG_SCRATCH_dbg_scratch <= 'h3333_cccc;  //  
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h7c0  : begin //'h1F00
                  DEBUG_RW_0_debug_rw_0 <= IFP_axi_rw.wdata[31:0];  // debug ethernet loopback
             end
      11'h7c1  : begin //'h1F04
                  DEBUG_RW_1_debug_rw_1 <= IFP_axi_rw.wdata[31:0];  // debug ethernet restart_tx_rx
             end
      11'h7c2  : begin //'h1F08
                  DEBUG_RW_2_debug_rw_2 <= IFP_axi_rw.wdata[31:0];  // debug ethernet sys_reset
             end
      11'h7c3  : begin //'h1F0C
                  DEBUG_RW_3_debug_rw_3 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c4  : begin //'h1F10
                  DEBUG_RW_4_debug_rw_4 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c5  : begin //'h1F14
                  DEBUG_RW_5_debug_rw_5 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c6  : begin //'h1F18
                  DEBUG_RW_6_debug_rw_6 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c7  : begin //'h1F1C
                  DEBUG_RW_7_debug_rw_7 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c8  : begin //'h1F20
                  DEBUG_RW_8_debug_rw_8 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7c9  : begin //'h1F24
                  DEBUG_RW_9_debug_rw_9 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7ca  : begin //'h1F28
                  DEBUG_RW_10_debug_rw_10 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cb  : begin //'h1F2C
                  DEBUG_RW_11_debug_rw_11 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cc  : begin //'h1F30
                  DEBUG_RW_12_debug_rw_12 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cd  : begin //'h1F34
                  DEBUG_RW_13_debug_rw_13 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7ce  : begin //'h1F38
                  DEBUG_RW_14_debug_rw_14 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7cf  : begin //'h1F3C
                  DEBUG_RW_15_debug_rw_15 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d0  : begin //'h1F40
                  DEBUG_RW_16_debug_rw_16 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d1  : begin //'h1F44
                  DEBUG_RW_17_debug_rw_17 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d2  : begin //'h1F48
                  DEBUG_RW_18_debug_rw_18 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d3  : begin //'h1F4C
                  DEBUG_RW_19_debug_rw_19 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d4  : begin //'h1F50
                  DEBUG_RW_20_debug_rw_20 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d5  : begin //'h1F54
                  DEBUG_RW_21_debug_rw_21 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d6  : begin //'h1F58
                  DEBUG_RW_22_debug_rw_22 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7d7  : begin //'h1F5C
                  DEBUG_RW_23_debug_rw_23 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7d8  : begin //'h1F60
                  DEBUG_RW_24_debug_rw_24 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7d9  : begin //'h1F64
                  DEBUG_RW_25_debug_rw_25 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7da  : begin //'h1F68
                  DEBUG_RW_26_debug_rw_26 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7db  : begin //'h1F6C
                  DEBUG_RW_27_debug_rw_27 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7dc  : begin //'h1F70
                  DEBUG_RW_28_debug_rw_28 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7dd  : begin //'h1F74
                  DEBUG_RW_29_debug_rw_29 <= IFP_axi_rw.wdata[31:0];  //  
             end
      11'h7de  : begin //'h1F78
                  DEBUG_RW_30_debug_rw_30 <= IFP_axi_rw.wdata[31:0];  // 
             end
      11'h7ff  : begin //'h1FFC
                  DBG_SCRATCH_dbg_scratch <= IFP_axi_rw.wdata[31:0];  //  
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
                   IFP_axi_rw.rdata[15:0] = VERSION_REGISTER_revision_num;  // Revision number
                   IFP_axi_rw.rdata[23:16] = VERSION_REGISTER_minor_version;  // minor version
                   IFP_axi_rw.rdata[31:24] = VERSION_REGISTER_major_version;  // major version
             end
      11'h1  : begin//'h4
                   IFP_axi_rw.rdata[31:0] = DEBUG_REVISION_debug_revision;  // Debug build version. Should be 0 for official builds. 
             end
      11'h2  : begin//'h8
                   IFP_axi_rw.rdata[31:0] = TIMESTAMP_timestamp;  // timestamp
             end
      11'h7c0  : begin//'h1F00
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_0_debug_rw_0;  // debug ethernet loopback
             end
      11'h7c1  : begin//'h1F04
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_1_debug_rw_1;  // debug ethernet restart_tx_rx
             end
      11'h7c2  : begin//'h1F08
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_2_debug_rw_2;  // debug ethernet sys_reset
             end
      11'h7c3  : begin//'h1F0C
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_3_debug_rw_3;  // 
             end
      11'h7c4  : begin//'h1F10
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_4_debug_rw_4;  // 
             end
      11'h7c5  : begin//'h1F14
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_5_debug_rw_5;  // 
             end
      11'h7c6  : begin//'h1F18
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_6_debug_rw_6;  // 
             end
      11'h7c7  : begin//'h1F1C
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_7_debug_rw_7;  // 
             end
      11'h7c8  : begin//'h1F20
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_8_debug_rw_8;  // 
             end
      11'h7c9  : begin//'h1F24
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_9_debug_rw_9;  // 
             end
      11'h7ca  : begin//'h1F28
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_10_debug_rw_10;  // 
             end
      11'h7cb  : begin//'h1F2C
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_11_debug_rw_11;  // 
             end
      11'h7cc  : begin//'h1F30
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_12_debug_rw_12;  // 
             end
      11'h7cd  : begin//'h1F34
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_13_debug_rw_13;  // 
             end
      11'h7ce  : begin//'h1F38
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_14_debug_rw_14;  // 
             end
      11'h7cf  : begin//'h1F3C
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_15_debug_rw_15;  // 
             end
      11'h7d0  : begin//'h1F40
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_16_debug_rw_16;  // 
             end
      11'h7d1  : begin//'h1F44
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_17_debug_rw_17;  // 
             end
      11'h7d2  : begin//'h1F48
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_18_debug_rw_18;  // 
             end
      11'h7d3  : begin//'h1F4C
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_19_debug_rw_19;  // 
             end
      11'h7d4  : begin//'h1F50
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_20_debug_rw_20;  // 
             end
      11'h7d5  : begin//'h1F54
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_21_debug_rw_21;  // 
             end
      11'h7d6  : begin//'h1F58
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_22_debug_rw_22;  // 
             end
      11'h7d7  : begin//'h1F5C
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_23_debug_rw_23;  //  
             end
      11'h7d8  : begin//'h1F60
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_24_debug_rw_24;  //  
             end
      11'h7d9  : begin//'h1F64
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_25_debug_rw_25;  //  
             end
      11'h7da  : begin//'h1F68
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_26_debug_rw_26;  //  
             end
      11'h7db  : begin//'h1F6C
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_27_debug_rw_27;  //  
             end
      11'h7dc  : begin//'h1F70
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_28_debug_rw_28;  //  
             end
      11'h7dd  : begin//'h1F74
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_29_debug_rw_29;  //  
             end
      11'h7de  : begin//'h1F78
                   IFP_axi_rw.rdata[31:0] = DEBUG_RW_30_debug_rw_30;  // 
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = DBG_SCRATCH_dbg_scratch;  //  
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule