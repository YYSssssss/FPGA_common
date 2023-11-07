// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.
// -------------------------------------------------------------------------- //
// Name         : Kerry Johnson                                               //
// Date         : 6/15/20                                                     //
// File         : jb_top_ctrl_oran_lphy.sv                                                //
// Design       :                                                             //
// Purpose      :                                                             //
// Device       : xczu47dr-fsve1156-2-i-es1                                   //
// -------------------------------------------------------------------------- //

module jb_top_ctrl_oran_lphy #(
    parameter           AXI_ADDR_WIDTH  = 13,
    parameter           AXI_DATA_WIDTH  = 32
)(
    input                       clk,
    input                       srst,
    jb_axi4_lite_if.slave       IFP_axi4_lite,
    jb_oran_lphy_ctrl_if.ctrl   IFP_oran_lphy_ctrl,
    jb_oran_lphy_stat_if.stat   IFP_oran_lphy_stat
);

    // ------------------------------------------------------------------ //
    // Register Set: Top Control                                          //
    // ------------------------------------------------------------------ //

    jb_axi_regs_if      #(.AXI_ADDR_WIDTH(AXI_ADDR_WIDTH), .AXI_DATA_WIDTH(AXI_DATA_WIDTH)) IFP_axi_rw();

    jb_axi_slave #(
        .AXI_ADDR_WIDTH             (AXI_ADDR_WIDTH),
        .AXI_DATA_WIDTH             (AXI_DATA_WIDTH)
    ) u_axi_slave_top_ctrl (
        .clk                        (clk),                  // i
        .srst                       (srst),                 // i
        .IFP_axi4_lite              (IFP_axi4_lite),     // jb_axi4_lite_if.slave
        .IFP_axi_rw                 (IFP_axi_rw)  // jb_axi_regs_if.master
    );


    jb_oran_lphy_regs u_oran_lphy_regs (
        .clk                        (clk),                  // i
        .srst                       (srst),                 // i
        .IFP_axi_rw                 (IFP_axi_rw),  // jb_axi_regs_if.slave
        .IFP_oran_lphy_ctrl         (IFP_oran_lphy_ctrl),     // jb_oran_lphy_regs.ctrl
	.IFP_oran_lphy_stat             (IFP_oran_lphy_stat)
    );

    // ------------------------------------------------------------------ //
    // Register Set: ...                                                  //
    // ------------------------------------------------------------------ //

endmodule
 
