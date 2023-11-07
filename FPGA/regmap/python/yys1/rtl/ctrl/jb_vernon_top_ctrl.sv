// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : Fei Qin                                                     //
// Date         : 02/07/21                                                     //
// File         : top_brd.v                                                   //
// Design       :                                                             //
// Purpose      : Vernon Board Controls                                           //
// Device       : xczu47dr-fsve1156-2-i                                       //
// -------------------------------------------------------------------------- //
`timescale 1ns / 1ps

module jb_vernon_top_ctrl #(
    parameter PLACEHOLDER       = 0
) (
    input                               clk_15p36,
    input                               axis_aresetn,
    jb_cmn_ctrl_if.xssi                 IFP_regs,
    output  logic                       rssi_load
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Amp Controls                                                       //
    // ------------------------------------------------------------------ //
    rssi_load #(
        .PLACEHOLDER                    (PLACEHOLDER)
    ) rssi_load_u0 (
        .clk_15p36                      (clk_15p36),                        // i
        .resetn_15p36                   (axis_aresetn),                     // i
        .IFP_regs                       (IFP_regs),                         // mm_regs_top_ctrl_if.top_regs
        .rssi_load                      (rssi_load)                         // o
    );

endmodule
