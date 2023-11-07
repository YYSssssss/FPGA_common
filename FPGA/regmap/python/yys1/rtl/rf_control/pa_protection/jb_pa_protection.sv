// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 11/11/20                                                    //
// Module       : jb_pa_protection                                            //
// Description  :                                                             //
// ========================================================================== //

`timescale 1ns / 1ps

module jb_pa_protection #(
    parameter N_ANTENNAS = 8
) (
    input                                   clk_3x,
    input                                   resetn_3x,
    jb_hw_ctrl_if.hw_ctrl                   IFP_hw_regs,
    jb_intr_ctrl_if.irq_rfc                 IFP_irq,
    input           [N_ANTENNAS-1:0] [31:0] tssi,
    output  logic   [N_ANTENNAS-1:0] [31:0] rf_overdrive_tssi
);

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    genvar i;

    // ------------------------------------------------------------------ //
    // PA Overdrive Protection                                            //
    // ------------------------------------------------------------------ //
generate
for (i=0; i<N_ANTENNAS; i=i+1)
begin : gen_pa_odp
    jb_pa_odp jb_pa_odp_u0 (
        .clk_3x                 (clk_3x),                               // i
        .resetn_3x              (resetn_3x),                            // i
        .tssi                   (tssi[i]),                              // i [31:0]
        .tssi_threshold         (IFP_hw_regs.rf_overdrive_thresh),      // i [31:0]
        .tssi_violation         (rf_overdrive_tssi[i]),                 // o [31:0]
        .rf_overdrive_mute      (IFP_irq.rf_overdrive_mute[i]),         // o
        .rf_overdrive_mute_mask (IFP_irq.rf_overdrive_mute_mask[i]),    // i
        .rf_overdrive_mute_clr  (IFP_irq.rf_overdrive_mute_clr[i]),     // i
        .rf_overdrive_irq       (IFP_irq.rf_overdrive_irq[i]),          // o
        .rf_overdrive_irq_mask  (IFP_irq.rf_overdrive_irq_mask[i]),     // i
        .rf_overdrive_irq_clr   (IFP_irq.rf_overdrive_irq_clr[i])       // i
    );
end
endgenerate

    // ------------------------------------------------------------------ //
    // PA Slew Rate Protection                                            //
    // ------------------------------------------------------------------ //


endmodule

