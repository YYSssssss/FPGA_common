
module jb_top_ctrl_ul_dfe #(
    parameter           AXI_ADDR_WIDTH  = 13,
    parameter           AXI_DATA_WIDTH  = 32
)(
    input                       clk,
    input                       srst,
    jb_axi4_lite_if.slave       IFP_axi4_lite,
    jb_ul_dfe_ctrl_if.ctrl      IFP_ul_dfe_ctrl,
    jb_ul_dfe_stat_if.stat      IFP_ul_dfe_stat
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


    jb_ul_dfe_regs u_ul_dfe_regs (
        .clk                        (clk),                  // i
        .srst                       (srst),                 // i
        .IFP_axi_rw                 (IFP_axi_rw),  // jb_axi_regs_if.slave
        .IFP_ul_dfe_ctrl            (IFP_ul_dfe_ctrl),     // mm_regs_top_ctrl_if.ctrl
        .IFP_ul_dfe_stat            (IFP_ul_dfe_stat)
    );

    // ------------------------------------------------------------------ //
    // Register Set: ...                                                  //
    // ------------------------------------------------------------------ //

endmodule
 
