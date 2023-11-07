// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : M Faizan                                                    //
// Date         : 11/10/20                                                    //
// File         : jb_pl_control.sv                                            //
// Design       :                                                             //
// Purpose      : Top-Level Controls and State Machines                       //
// Device       :                                                             //
// -------------------------------------------------------------------------- //
`timescale 1ns / 1ps

module jb_pl_control # (
    parameter MAX_RSSI_TICS_BW = 21
) (
    input                               axi_resetn,
    input                               axi_clk,
    input                               clk_15p36,
    input                               clk_368p64,
    input                               resetn_15p36,
    input                               psu_alarm_n,
    input                               psu_alarm_enable,
    output  logic                       psu_shutdown,
    output  logic                       dac_shutdown,
    output  logic                       pa_shutdown,
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
    // ------------------------------------------------------------------ //
    // Timers                                                             //
    // ------------------------------------------------------------------ //
    jb_timers #(
        .MAX_RSSI_TICS_BW           (MAX_RSSI_TICS_BW)
    )  jb_timers_u0 (
        .clk_15p36                  (clk_15p36),                // i
        .clk_368p64                 (clk_368p64),               // i
        .resetn_15p36               (resetn_15p36),             // i
        .IFP_regs                   (IFP_regs),                 // jb_cmn_ctrl_if.timers
        .rf_overdrive_avg_per       (rf_overdrive_avg_per),     // i [20:0]
        .timer_pulse_xssi           (timer_pulse_xssi),         // o
        .timer_pulse_xssi_x3        (timer_pulse_xssi_x3),      // o
        .timer_pulse_tssi_pap_x3    (timer_pulse_tssi_pap_x3)   // o
    );

    // ------------------------------------------------------------------ //
    // Power Failure                                                      //
    // ------------------------------------------------------------------ //
    jb_power_down jb_power_down_u0 (
        .axi_resetn                 (axi_resetn),               // i
        .axi_clk                    (axi_clk),                  // i
        .clk_15p36                  (clk_15p36),                // i
        .psu_alarm_enable           (psu_alarm_enable),         // i
        .psu_alarm_n                (psu_alarm_n),              // i
        .psu_shutdown               (psu_shutdown),             // i
        .dac_shutdown               (dac_shutdown),             // o
        .pa_shutdown                (pa_shutdown)               // o
    );

endmodule
