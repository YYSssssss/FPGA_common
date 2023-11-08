//Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
//Date        : Wed Apr 19 19:45:31 2023
//Host        : DESKTOP-NDFD4H3 running 64-bit major release  (build 9200)
//Command     : generate_target design_1_wrapper.bd
//Design      : design_1_wrapper
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module design_1_wrapper
(
  input                             aresetn_100M,
  input                             clk_100M,

  sensemi_axi4_lite_if.master       IFP_axi_lite_test_ctrl
     
);

  design_0 design_0_i(
        .aresetn_100M               (aresetn_100M),
        .clk_100M                   (clk_100M    ),

        .IFP_TEST_CTRL_araddr        (IFP_axi_lite_test_ctrl.araddr),
        .IFP_TEST_CTRL_arprot        (IFP_axi_lite_test_ctrl.arprot),
        .IFP_TEST_CTRL_arready       (IFP_axi_lite_test_ctrl.arready),
        .IFP_TEST_CTRL_arvalid       (IFP_axi_lite_test_ctrl.arvalid),
        .IFP_TEST_CTRL_awaddr        (IFP_axi_lite_test_ctrl.awaddr),
        .IFP_TEST_CTRL_awprot        (IFP_axi_lite_test_ctrl.awprot),
        .IFP_TEST_CTRL_awready       (IFP_axi_lite_test_ctrl.awready),
        .IFP_TEST_CTRL_awvalid       (IFP_axi_lite_test_ctrl.awvalid),
        .IFP_TEST_CTRL_bready        (IFP_axi_lite_test_ctrl.bready),
        .IFP_TEST_CTRL_bresp         (IFP_axi_lite_test_ctrl.bresp),
        .IFP_TEST_CTRL_bvalid        (IFP_axi_lite_test_ctrl.bvalid),
        .IFP_TEST_CTRL_rdata         (IFP_axi_lite_test_ctrl.rdata),
        .IFP_TEST_CTRL_rready        (IFP_axi_lite_test_ctrl.rready),
        .IFP_TEST_CTRL_rresp         (IFP_axi_lite_test_ctrl.rresp),
        .IFP_TEST_CTRL_rvalid        (IFP_axi_lite_test_ctrl.rvalid),
        .IFP_TEST_CTRL_wdata         (IFP_axi_lite_test_ctrl.wdata),
        .IFP_TEST_CTRL_wready        (IFP_axi_lite_test_ctrl.wready),
        .IFP_TEST_CTRL_wstrb         (IFP_axi_lite_test_ctrl.wstrb),
        .IFP_TEST_CTRL_wvalid        (IFP_axi_lite_test_ctrl.wvalid)
  );
   

   
endmodule
