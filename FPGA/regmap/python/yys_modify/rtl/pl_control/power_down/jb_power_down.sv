`timescale 1ns / 1ps

module jb_power_down (
    input                               axi_resetn,
    input                               axi_clk,
    input                               clk_15p36,
    input                               psu_alarm_n,
    input                               psu_alarm_enable,
    output  logic                       psu_shutdown = 0,
    output  logic                       dac_shutdown,
    output  logic                       pa_shutdown
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    logic                       psu_alarm_n_meta    = 1;
    logic                       psu_alarm_n_sync    = 1;
    logic           [3:0]       psu_alarm_n_dly     = '1;
    
    logic                       psu_alarm_enable_meta = 0;
    logic                       psu_alarm_enable_sync = 0;

    // ------------------------------------------------------------------ //
    // PSU Alarm                                                          //
    // ------------------------------------------------------------------ //
    // De-glitch psu_alarm_n input
    always_ff @(posedge clk_15p36) begin
        psu_alarm_n_meta    <= psu_alarm_n;
        psu_alarm_n_sync    <= psu_alarm_n_meta;
        psu_alarm_n_dly[0]  <= psu_alarm_n_sync;
        for (int i = 1; i <= 3; i = i + 1) begin
            psu_alarm_n_dly[i] <= psu_alarm_n_dly[i-1];
        end
    end

    // psu_shutdown becomes and stays high only when psu_alarm_n input is
    // low for a x cycles (i.e. glitches less than x cycles are ignored).
    always_ff @(posedge clk_15p36) begin
        psu_alarm_enable_meta <= psu_alarm_enable;
        psu_alarm_enable_sync <= psu_alarm_enable_meta;
        if (~|psu_alarm_n_dly)
            psu_shutdown   <= psu_alarm_enable_sync;
    end

    // ------------------------------------------------------------------ //
    // DAC fast shutdown due to PSU_ALARM                                 //
    // ------------------------------------------------------------------ //
    jb_dac_shutdown jb_dac_shutdown_u0 (
        .axi_resetn                 (axi_resetn),               // i
        .axi_clk                    (axi_clk),                  // i
        .clk_15p36                  (clk_15p36),                // i
        .psu_shutdown               (psu_shutdown),             // i
        .dac_shutdown               (dac_shutdown)              // o
    );


    assign pa_shutdown = dac_shutdown;

endmodule
	     
