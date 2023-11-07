
`timescale 1 ps / 1 ps

module jb_vernon_sfp_ibert_tests (
    input                           sys_clk_100,
    input                           sfp_refclk_p,
    input                           sfp_refclk_n,
    input           [1:0]           sfp_rxp,
    input           [1:0]           sfp_rxn,
    output  logic   [1:0]           sfp_txp,
    output  logic   [1:0]           sfp_txn,
    output  logic                   fh_recov_clk
);

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    logic                           gty_refclk0_i;
    logic           [3:0]           rxoutclk;
    logic           [3:0]           txoutclk;
	
    // ------------------------------------------------------------------ //
    // Clock Buffers:                                                     //
    // ------------------------------------------------------------------ //
    IBUFDS_GTE4 u_buf_q1_clk0 (
        .O            (gty_refclk0_i),
        .ODIV2        (),
        .CEB          (1'b0),
        .I            (sfp_refclk_p),
        .IB           (sfp_refclk_n)
    );

    // ------------------------------------------------------------------ //
    // Misc. Logic:                                                       //
    // ------------------------------------------------------------------ //
    assign fh_recov_clk = rxoutclk[0];

    // ------------------------------------------------------------------ //
    // IBERT:                                                             //
    // ------------------------------------------------------------------ //

    ibert_gty_q128 ibert_gty_q128_u0 (
        .txn_o                          (sfp_txn),                      // o [3:0]
        .txp_o                          (sfp_txp),                      // o [3:0]
        .rxoutclk_o                     (rxoutclk),                     // o [3:0]
        .txoutclk_o                     (txoutclk),                     // o [3:0]
        .rxn_i                          (sfp_rxn),                      // i [3:0]
        .rxp_i                          (sfp_rxp),                      // i [3:0]
        .gtrefclk0_i                    (gty_refclk0_i),                // i
        .gtrefclk1_i                    ('0),                           // i
        .gtnorthrefclk0_i               ('0),                           // i
        .gtnorthrefclk1_i               ('0),                           // i
        .gtsouthrefclk0_i               ('0),                           // i
        .gtsouthrefclk1_i               ('0),                           // i
        .gtrefclk00_i                   (gty_refclk0_i),                // i
        .gtrefclk10_i                   ('0),                           // i
        .gtrefclk01_i                   ('0),                           // i
        .gtrefclk11_i                   ('0),                           // i
        .gtnorthrefclk00_i              ('0),                           // i
        .gtnorthrefclk10_i              ('0),                           // i
        .gtnorthrefclk01_i              ('0),                           // i
        .gtnorthrefclk11_i              ('0),                           // i
        .gtsouthrefclk00_i              ('0),                           // i
        .gtsouthrefclk10_i              ('0),                           // i
        .gtsouthrefclk01_i              ('0),                           // i
        .gtsouthrefclk11_i              ('0),                           // i
        .clk                            (sys_clk_100)                        // i
    );


endmodule
