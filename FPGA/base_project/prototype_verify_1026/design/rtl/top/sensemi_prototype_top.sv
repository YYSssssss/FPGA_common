`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/11/08 19:15:18
// Design Name: 
// Module Name: config_capture_top
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


module sensemi_prototype_top(
    input                i_fpga_clk   
);

//******************** reg & wire & IF ********************//
//clk
wire                clk_10m;
wire                clk_100m;
wire                clk_200m;
wire                clk_300m;
wire                aresetn_10m;
wire                aresetn_100m;
wire                aresetn_200m;
wire                aresetn_300m;

sensemi_axi4_lite_if #(.ADDR_WIDTH(17), .DATA_WIDTH(32))        IFP_axi_lite_test_ctrl();

sensemi_test_ctrl_if         IFP_test_ctrl();
sensemi_test_stat_if         IFP_test_stat();


//******************** clock & rstn ********************//
clock_gen u_clock_gen(
    .i_fpga_clk   (i_fpga_clk),
    .o_clk_10m    (clk_10m),
    .o_clk_100m   (clk_100m),
    .o_clk_200m   (clk_200m),
    .o_clk_300m   (clk_300m),
    
    .o_aresetn_10m  (aresetn_10m),
    .o_aresetn_100m (aresetn_100m),
    .o_aresetn_200m (aresetn_200m),
    .o_aresetn_300m (aresetn_300m)
);

//******************** timestamp ********************//
sensemi_timestamp sensemi_timestamp_inst(
    .axi_clk           (clk_100m),
    .IFP_test_stat     (IFP_test_stat)           // 32-bit output: Configuration Data reflecting the contents of the AXIS register
);



//******************** regmap ********************//

sensemi_regmap_top #(
   .AXI_ADDR_WIDTH (17),
   .AXI_DATA_WIDTH (32)
   ) u_regmap_top(

   .clk_100m                     (clk_100m    ),
   .clk_200m                     (clk_200m    ),
   .clk_300m                     (clk_300m    ),
   .aresetn_100m                 (aresetn_100m),
   .aresetn_200m                 (aresetn_200m),
   .aresetn_300m                 (aresetn_300m),
         
   .IFP_axi_lite_test            (IFP_axi_lite_test_ctrl),   
      
   .IFP_test_ctrl                (IFP_test_ctrl),
   .IFP_test_stat                (IFP_test_stat)
      
 );


//******************** block design ********************//    
design_1_wrapper bd_wrapper(
  .aresetn_100M              (aresetn_100m),
  .clk_100M                  (clk_100m),
  
  .IFP_axi_lite_test_ctrl    (IFP_axi_lite_test_ctrl)
  );
  


endmodule
