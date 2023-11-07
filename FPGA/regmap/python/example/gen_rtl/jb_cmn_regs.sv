// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 3007216                                                     // 
// Date         : 06/24/22                                                    // 
// File         : jb_cmn_regs.sv                                              // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 

module jb_cmn_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_cmn_ctrl_if.ctrl         IFP_cmn_ctrl
);

    `include "jb_logan_params.svh"



////////////////Register Field Declarations//////////////////

   logic  [7:0]              FPGA_REG_VERSION_REGISTER_major_version;
  // major version
   logic  [7:0]              FPGA_REG_VERSION_REGISTER_minor_version;
  // minor version
   logic  [15:0]              FPGA_REG_VERSION_REGISTER_revision_num;
  // Revision number
   logic  [31:0]              FPGA_REG_INTERNAL_REVISION_debug_revision;
  // Debug build version. Should be 0 for official builds.
   logic  [15:0]              FPGA_REG_HW_ID_hw_id;
  // 
   logic  [15:0]              FPGA_REG_SOFT_RESET_REGISTER_soft_reset;
  // bit 0 - Write 1 and then 0 to resets data path except Fronthaul. 
   logic  [20:0]              FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics;
  // Number of tics @15.36Mhz clock after which RSSI, WRSSI, TSSI re-loaded into registers
   logic                     FPGA_REG_DL_DFE_RESET_REGISTER_dl_dfe_reset;
  // bit 0 - Write 1 and then 0 to resets dl_dfe data path  
   logic                     FPGA_REG_UL_DFE_RESET_REGISTER_ul_dfe_reset;
  // bit 0 - Write 1 and then 0 to resets ul_dfe data path  
   logic                     FPGA_REG_DBG_RESET_REGISTER_dbg_reset;
  // bit 0 - Write 1 and then 0 to resets dbg whole module  
   logic  [31:0]              FPGA_REG_CMN_SCRATCH_com_scratch;
  // common scratch








////////////////ASSIGN PARAMETERS//////////////////

   assign  FPGA_REG_VERSION_REGISTER_major_version =  MAJOR_VERSION;
   assign  FPGA_REG_VERSION_REGISTER_minor_version =  MINOR_VERSION;
   assign  FPGA_REG_VERSION_REGISTER_revision_num =  REVISION_NUM;
   assign  FPGA_REG_INTERNAL_REVISION_debug_revision =  DEBUG_REVISION;




////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_cmn_ctrl.hw_id =  FPGA_REG_HW_ID_hw_id;
   assign  IFP_cmn_ctrl.soft_reset =  FPGA_REG_SOFT_RESET_REGISTER_soft_reset;
   assign  IFP_cmn_ctrl.xssi_num_15p36_tics =  FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics;
   assign  IFP_cmn_ctrl.dl_dfe_reset =  FPGA_REG_DL_DFE_RESET_REGISTER_dl_dfe_reset;
   assign  IFP_cmn_ctrl.ul_dfe_reset =  FPGA_REG_UL_DFE_RESET_REGISTER_ul_dfe_reset;
   assign  IFP_cmn_ctrl.dbg_module_reset =  FPGA_REG_DBG_RESET_REGISTER_dbg_reset;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////





///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_HW_ID_hw_id <= 'h0;  // 
                  FPGA_REG_SOFT_RESET_REGISTER_soft_reset <= 'h0;  // bit 0 - Write 1 and then 0 to resets data path except Fronthaul. 
                  FPGA_REG_xSSI_WINDOW_CFG_xssi_num_15p36_tics <= 'h177000;  // Number of tics @15.36Mhz clock after which RSSI, WRSSI, TSSI re-loaded into registers
                  FPGA_REG_DL_DFE_RESET_REGISTER_dl_dfe_reset <= 'h0;  // bit 0 - Write 1 and then 0 to resets dl_dfe data path  
                  FPGA_REG_UL_DFE_RESET_REGISTER_ul_dfe_reset <= 'h0;  // bit 0 - Write 1 and then 0 to resets ul_dfe data path  
                  FPGA_REG_DBG_RESET_REGISTER_dbg_reset <= 'h0;  // bit 0 - Write 1 and then 0 to resets dbg whole module  
                  FPGA_REG_CMN_SCRATCH_com_scratch <= 'h3333_cccc;  // common scratch
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
                  FPGA_REG_DL_DFE_RESET_REGISTER_dl_dfe_reset <= IFP_axi_rw.wdata[0];  // bit 0 - Write 1 and then 0 to resets dl_dfe data path  
             end
      11'h6  : begin //'h18
                  FPGA_REG_UL_DFE_RESET_REGISTER_ul_dfe_reset <= IFP_axi_rw.wdata[0];  // bit 0 - Write 1 and then 0 to resets ul_dfe data path  
             end
      11'h7  : begin //'h1C
                  FPGA_REG_DBG_RESET_REGISTER_dbg_reset <= IFP_axi_rw.wdata[0];  // bit 0 - Write 1 and then 0 to resets dbg whole module  
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
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_INTERNAL_REVISION_debug_revision;  // Debug build version. Should be 0 for official builds.
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
                   IFP_axi_rw.rdata[0] = FPGA_REG_DL_DFE_RESET_REGISTER_dl_dfe_reset;  // bit 0 - Write 1 and then 0 to resets dl_dfe data path  
             end
      11'h6  : begin//'h18
                   IFP_axi_rw.rdata[0] = FPGA_REG_UL_DFE_RESET_REGISTER_ul_dfe_reset;  // bit 0 - Write 1 and then 0 to resets ul_dfe data path  
             end
      11'h7  : begin//'h1C
                   IFP_axi_rw.rdata[0] = FPGA_REG_DBG_RESET_REGISTER_dbg_reset;  // bit 0 - Write 1 and then 0 to resets dbg whole module  
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_CMN_SCRATCH_com_scratch;  // common scratch
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule