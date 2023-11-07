
`timescale 1ns / 1ps

module jb_spi_slave_dsa #(
    parameter TRN_WIDTH = 8,
    parameter MSB_FIRST = 0
)(
    input                                   sclk,
    input                                   csn,
    input                                   mosi,
    output  logic                           miso,
    input                                   rx_clk,
    output  logic [TRN_WIDTH-1:0]           trn_rxd
);

    localparam  LOCAL_PARAM = 4'h0;

    logic [TRN_WIDTH-1:0]       mosi_sr;
    logic                       rxd_we;

    // ------------------------------------------------------------------ //
    // SPI side                                                           //
    // ------------------------------------------------------------------ //
    
    always_ff @(posedge sclk) begin
        if (~csn) begin
            if (MSB_FIRST)
                mosi_sr <= {mosi_sr[TRN_WIDTH-2:0], mosi};  // shift left
            else
                mosi_sr <= {mosi, mosi_sr[TRN_WIDTH-1:1]};  // shift right
        end
    end

    assign miso = 0;
    
    // IDT_F1958 datasheet: LE to posedge CLK setup is 10 ns

    // ------------------------------------------------------------------ //
    //  AXI side                                                          //
    // ------------------------------------------------------------------ //
    // Detect posedge on csn
    jb_edge_det #(
        .SYNC_EN            (1),    // yes
        .SYNC_STAGES        (2),    // 2
        .EDGES              (1),    // pos
        .PULSE_WIDTH        (1),    // 1
        .PULSE_POLARITY     (1),    // pos
        .RETIME_OUTPUT      (1)     // yes
    ) edge_det_over_range_u1 (
        .clk                (rx_clk),
        .mask               (1'b0),
        .din                (csn),
        .din_syncd          (),
        .dout               (rxd_we)
    );
    
    always_ff @(posedge rx_clk) begin
        if (rxd_we) trn_rxd <= mosi_sr;
    end

endmodule

