`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2023 11:08:20 AM
// Design Name: Jade Yu
// Module Name: sensemi_regmap_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sensemi_regmap_top #(
      parameter  AXI_ADDR_WIDTH=13,
      parameter  AXI_DATA_WIDTH=32
	     
   ) (

      input clk_100m,
      input clk_200m,
      input clk_300m,
      input aresetn_100m,
      input aresetn_200m,
      input aresetn_300m,
         
      sensemi_axi4_lite_if.slave     IFP_axi_lite_test,   
      
      sensemi_test_ctrl_if.ctrl  IFP_test_ctrl,
      sensemi_test_stat_if.stat  IFP_test_stat 
      
      );

  
   sensemi_top_ctrl_test #(
      .AXI_ADDR_WIDTH(AXI_ADDR_WIDTH),
      .AXI_DATA_WIDTH(AXI_DATA_WIDTH)
   ) u0_top_ctrl_test (
      .clk(clk_100m),
      .srst(~aresetn_100m),
      .IFP_axi4_lite     (IFP_axi_lite_test),
      .IFP_test_ctrl (IFP_test_ctrl),
      .IFP_test_stat (IFP_test_stat)
   );

 
   
endmodule
 
