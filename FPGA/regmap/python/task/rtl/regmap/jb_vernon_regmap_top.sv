// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : Fei Qin                                                     //
// Date         : 02/07/21                                                     //
// File         : top_register.v                                                   //
// Design       :                                                             //
// Purpose      : MM Board Controls                                           //
// Device       : xczu47dr-fsve1156-2-i                                       //
// -------------------------------------------------------------------------- //


module jb_vernon_regmap_top #(
      parameter  AXI_ADDR_WIDTH=13,
      parameter  AXI_DATA_WIDTH=32
	     
   ) (

      input clk,
      input srst,
           
      jb_axi4_lite_if.slave IFP_top_com_axi4_lite,      
      jb_axi4_lite_if.slave IFP_test_axi4_lite,     
      jb_axi4_lite_if.slave IFP_hw_axi4_lite,   
      jb_axi4_lite_if.slave IFP_intr_axi4_lite,  
      jb_axi4_lite_if.slave IFP_dl_dfe_axi4_lite,
      jb_axi4_lite_if.slave IFP_oran_lphy_axi4_lite,
      jb_axi4_lite_if.slave IFP_ul_dfe_axi4_lite,	  
      
      jb_cmn_ctrl_if.ctrl IFP_cmn_ctrl, 
      jb_test_ctrl_if.ctrl IFP_test_ctrl,	
      jb_hw_ctrl_if.ctrl IFP_hw_ctrl,	  
      jb_intr_ctrl_if.ctrl IFP_intr_ctrl,
      jb_dl_dfe_ctrl_if.ctrl IFP_dl_dfe_ctrl,
      jb_dl_dfe_stat_if.stat IFP_dl_dfe_stat,
	  jb_oran_lphy_ctrl_if.ctrl IFP_oran_lphy_ctrl,
	  jb_oran_lphy_stat_if.stat IFP_oran_lphy_stat,
      jb_ul_dfe_ctrl_if.ctrl IFP_ul_dfe_ctrl,
      jb_ul_dfe_stat_if.stat IFP_ul_dfe_stat  
      );

  
   jb_top_dl_dfe #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_dl_dfe (
      .clk(clk),
      .srst(srst),
      .IFP_axi4_lite(IFP_dl_dfe_axi4_lite),
      .IFP_dl_dfe_ctrl(IFP_dl_dfe_ctrl),
      .IFP_dl_dfe_stat(IFP_dl_dfe_stat)
   );    
   
   
   jb_top_ctrl_ul_dfe #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_ul_dfe (
      .clk(clk),
      .srst(srst),
      .IFP_axi4_lite(IFP_ul_dfe_axi4_lite),
      .IFP_ul_dfe_ctrl(IFP_ul_dfe_ctrl),
      .IFP_ul_dfe_stat(IFP_ul_dfe_stat)
   );    

  

 jb_top_ctrl_cmn #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_cmn (
      .clk(clk),
      .srst(srst),
      .IFP_axi4_lite(IFP_top_com_axi4_lite),
      .IFP_cmn_ctrl(IFP_cmn_ctrl)
   );       


 jb_top_ctrl_test #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_test (
      .clk(clk),
      .srst(srst),
      .IFP_axi4_lite(IFP_test_axi4_lite),
      .IFP_test_ctrl(IFP_test_ctrl)
   );

 jb_top_ctrl_hw #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_hw (
      .clk(clk),
      .srst(srst),
      .IFP_axi4_lite(IFP_hw_axi4_lite),
      .IFP_hw_ctrl(IFP_hw_ctrl)
   );
   
 jb_top_ctrl_intr #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_intr (
      .clk(clk),
      .srst(srst),
      .IFP_axi4_lite(IFP_intr_axi4_lite),
      .IFP_intr_ctrl(IFP_intr_ctrl)
   );


 //remove later   
 //jb_top_ctrl_fh_proc #(
 //     .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
 //     .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
 //  ) u0_fh_proc (
 //     .clk(clk),
 //     .srst(srst),
 //     .IFP_axi4_lite(IFP_fh_proc_axi4_lite),
 //     .IFP_fh_proc_ctrl(IFP_fh_proc_ctrl),
 //     .IFP_fh_proc_stat(IFP_fh_proc_stat)
 //  );
 //
 
 jb_top_ctrl_oran_lphy #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_oran_lphy (
      .clk(clk),
      .srst(srst),
      .IFP_axi4_lite(IFP_oran_lphy_axi4_lite), //temp
      .IFP_oran_lphy_ctrl(IFP_oran_lphy_ctrl),
      .IFP_oran_lphy_stat(IFP_oran_lphy_stat)
   );

 
   
endmodule
 
