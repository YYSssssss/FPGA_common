
module jb_top_ctrl_cmn #(
    parameter           AXI_ADDR_WIDTH  = 13,
    parameter           AXI_DATA_WIDTH  = 32
)(
    input                       clk,
    input                       srst,
    jb_axi4_lite_if.slave       IFP_axi4_lite,
    jb_cmn_ctrl_if.ctrl         IFP_cmn_ctrl
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


    jb_cmn_regs u_cmn_regs (
        .clk                        (clk),                  // i
        .srst                       (srst),                 // i
        .IFP_axi_rw                 (IFP_axi_rw),  // jb_axi_regs_if.slave
        .IFP_cmn_ctrl               (IFP_cmn_ctrl)     // mm_regs_top_ctrl_if.ctrl
    );

    // ------------------------------------------------------------------ //
    // Register Set: ...                                                  //
    // ------------------------------------------------------------------ //

endmodule
 
