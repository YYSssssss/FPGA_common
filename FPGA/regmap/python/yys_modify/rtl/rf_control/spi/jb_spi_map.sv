
`timescale 1ns / 1ps

module jb_spi_map (
    input                               spi_bank_sel,

    output                              spi_tx_clk,
    output                              spi_tx_mosi,
    output  logic   [4:1]               spi_tx_le,          // TX DSA
    
    output                              spi_orx_clk,
    output                              spi_orx_mosi,
    output  logic   [2:1]               spi_orx_le,         // ORX DSA
  
    output  logic                       spi_pa_clk,
    output  logic                       spi_pa_mosi,
    input                               spi_pa_miso,
    output  logic   [3:2]               spi_pa_le,          // PA Controllers 

    output  logic                       emio_spi0_miso,
    input                               emio_spi0_mosi,
    input                               emio_spi0_sclk,
    input           [7:0]               emio_spi0_ss_n
);

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    wire                                    spi_bank0_miso;
    wire                                    spi_bank1_miso;

    // ------------------------------------------------------------------ //
    // SPI                                                                //
    // ------------------------------------------------------------------ //
    // Don't pull-ups MISO inputs because we're ORing these lines internally.
    //
    // 8/12/19: Disconnected PA_SPI2_MISO and PA_SPI3_MISO per Horatio's request.
    // ADAM ICs (on the PA board) drive PA_SPI2_MISO and PA_SPI3_MISO high
    // sometimes causing the OR gate below to get stuck at 1.
    // It looks like the ADAM ICs are write-only and we dont read from them.
    // So, as a workaround for now, MISO signals from the ADAM ICs are disconnected. 

    // SPI-1: Radio Board, Tx Chain
    assign spi_tx_clk    = (spi_bank_sel == 1) ? emio_spi0_sclk    : 1'b1;
    assign spi_tx_mosi   = (spi_bank_sel == 1) ? emio_spi0_mosi    : 1'b1;
    assign spi_tx_le[4]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[3] : 1'b1;       // Tx4 DSA
    assign spi_tx_le[3]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[2] : 1'b1;       // Tx3 DSA
    assign spi_tx_le[2]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[1] : 1'b1;       // Tx2 DSA
    assign spi_tx_le[1]  = (spi_bank_sel == 1) ? emio_spi0_ss_n[0] : 1'b1;       // Tx1 DSA

    // SPI-1: Radio Board, ORX
    assign spi_orx_clk   = (spi_bank_sel == 1) ? emio_spi0_sclk    : 1'b1;
    assign spi_orx_mosi  = (spi_bank_sel == 1) ? emio_spi0_mosi    : 1'b1;
    assign spi_orx_le[2] = (spi_bank_sel == 1) ? emio_spi0_ss_n[5] : 1'b1;       // ORx1 DSA 
    assign spi_orx_le[1] = (spi_bank_sel == 1) ? emio_spi0_ss_n[4] : 1'b1;       // ORx2 DSA

    assign spi_bank1_miso = 1'b1;
    // ------------------------------------------------------------------ //
    
    // SPI-0: PA Board
    assign spi_pa_clk   = (spi_bank_sel == 0) ? emio_spi0_sclk    : 1'b1;  
    assign spi_pa_mosi  = (spi_bank_sel == 0) ? emio_spi0_mosi    : 1'b1;
    assign spi_pa_le[3] = (spi_bank_sel == 0) ? emio_spi0_ss_n[2] : 1'b1;       // PA Controller 3/4    - PA Board/U600/AMC7834IRTQ
    assign spi_pa_le[2] = (spi_bank_sel == 0) ? emio_spi0_ss_n[1] : 1'b1;       // PA Controller 1/2    - PA Board/U500/AMC7834IRTQ
        

    //assign emio_spi0_miso = spi_pa_miso | PA_SPI2_MISO | PA_SPI3_MISO;
    assign spi_bank0_miso = spi_pa_miso; // | PA_SPI2_MISO | PA_SPI3_MISO;

    assign emio_spi0_miso = (spi_bank_sel == 0) ? spi_bank0_miso : spi_bank1_miso;


endmodule
