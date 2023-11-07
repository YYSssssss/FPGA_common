// ========================================================================== //
// Copyright Jabil Inc.                                                       //
// ========================================================================== //
// Name         : M Faizan (Based on jb_xssi_cntr)                            //
// Date         : 11/10/20                                                    //
// File         : jb_timers.sv                                                //
// Design       :                                                             //
// Purpose      :                                                             //
// Device       :                                                             //
// ========================================================================== //
`timescale 1ns / 1ps

module jb_timers #(
    parameter MAX_RSSI_TICS_BW = 21
) (
    input                               clk_15p36,
    input                               clk_368p64,
    input                               resetn_15p36,
    jb_cmn_ctrl_if.timers               IFP_regs,
    input           [20:0]              rf_overdrive_avg_per,
    output  logic                       timer_pulse_xssi,
    output  logic                       timer_pulse_xssi_x3,
    output  logic                       timer_pulse_tssi_pap_x3
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    logic                               timer_pulse_xssi_15p36;
    logic                               timer_pulse_tssi_pap_15p36;


    // ------------------------------------------------------------------ //
    // Timer - XSSI                                                       //
    // ------------------------------------------------------------------ //
    // Default = 100ms [T(15.36) * 0x177000(1536000) = 100_000_000ns]
    // Counter Width = log2(1536000) = 21
    jb_timer_pulse #(
        .MAX_COUNT_NUMBITS          (MAX_RSSI_TICS_BW)
    ) jb_timer_xssi_u0 (
        .timer_clk                  (clk_15p36),                    // i
        .resetn_15p36               (resetn_15p36),                 // i
        .max_count                  (IFP_regs.xssi_num_15p36_tics), // i [MAX_RSSI_TICS_BW-1:0]
        .timer_pulse                (timer_pulse_xssi_15p36)        // o
    );

    jb_edge_det #(
        .SYNC_EN            (1),    // Not needed, but just in case someone false paths these domains
        .PULSE_WIDTH        (1),
        .RETIME_OUTPUT      (1)
    ) u_pulse_xssi_x3 (
        .clk                (clk_368p64),
        .mask               (0),
        .din                (timer_pulse_xssi_15p36),
        .din_syncd          (/* open */),
        .dout               (timer_pulse_xssi_x3)
    );

    // The rssi_load pulse is used for RSSI meters in UL DFE.
    // RSSI in UL DFE is calculated with 1x clock samples. However, the
    // effective 1x rate changes with carrier bandwidth (i.e. using clock
    // enables). The lowest effective rate is 30.72 MHz when the carrier
    // bandwidth is set to 5 MHz, So a 15.36 MHz pulse should work for
    // all cases.

    assign timer_pulse_xssi = timer_pulse_xssi_15p36;

    // ------------------------------------------------------------------ //
    // Timer - PA Overdrive                                               //
    // ------------------------------------------------------------------ //
    // Default = 10us [T(15.36) * 0x9A(154) = 10_000ns]
    // Counter Width = log2(154) = 7 bits (allowing 16 for now)
    jb_timer_pulse #(
        .MAX_COUNT_NUMBITS          (21)
    ) jb_timer_pa_overdrive_u0 (
        .timer_clk                  (clk_15p36),                    // i
        .resetn_15p36               (resetn_15p36),                 // i
        .max_count                  (rf_overdrive_avg_per),         // i [20:0]
        .timer_pulse                (timer_pulse_tssi_pap_15p36)     // o
    );

    jb_edge_det #(
        .SYNC_EN            (1),    // Not needed, but just in case someone false paths these domains
        .PULSE_WIDTH        (1),
        .RETIME_OUTPUT      (1)
    ) u_pulse_pap_tssi (
        .clk                (clk_368p64),
        .mask               (0),
        .din                (timer_pulse_tssi_pap_15p36),
        .din_syncd          (/* open */),
        .dout               (timer_pulse_tssi_pap_x3)
    );

    // ------------------------------------------------------------------ //
    // Pulses                                                             //
    // ------------------------------------------------------------------ //

endmodule
	     
