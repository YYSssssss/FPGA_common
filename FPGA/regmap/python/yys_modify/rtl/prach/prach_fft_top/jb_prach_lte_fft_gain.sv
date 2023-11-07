`timescale 1ns / 1ps

module jb_prach_lte_fft_gain # (
    parameter USR_ID_BW=2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4
)
 (
    input clk,              
    input clk_en,
    input reset,
    jb_axi4_stream_if.slave IFP_prach_fft_gain_in,
    input [3:0] ch_bw, // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    
    // Output
    jb_axi4_stream_if.master IFP_prach_fft_gain_out
    ); 
    
    logic 		               gain_scalar_sign;
    logic [GAIN_SCALER_BW-1:0] gain_scalar;
    logic [PRECISION-1:0]      gain_fraction;

    
// Gain  20MHz 3.1030 db => scaler 1 fraction 'hB763
// Gain  15Mhz 3.1030 db => scaler 1 fraction 'hB763  Need to be reevaluated
// Gain  10Mhz 6.0206 db => scaler 2 fraction 'h809B  Need to be reevaluated
// Gain  5Mhz  3.1030 db => scaler 2 fraction 'hB763  Need to be reevaluated
/*always_comb begin
    case (ch_bw) // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
      //  4'b0000 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103
        4'b0000 : begin gain_scalar =  2; gain_fraction = 'h809C; end  // 3.0103
        4'b0001 : begin gain_scalar =  2; gain_fraction = 'h809C; end  // 6.0206
        4'b0010 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 
        4'b0011 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103
        default : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103     
    endcase
end
*/
    assign gain_scaler = 2;
    assign gain_fraction = 'h809C;
    assign gain_scalar_sign = 0;  // Direction of the shift 0 left, 1 right

   //Set the gain based on bandwidth, BW=15, 5dB, else 0
    jb_iq_gain_mult #(
        .PRECISION                      (PRECISION),
        .SCALER_BW                      (GAIN_SCALER_BW),
        .USR_ID_BW                      (USR_ID_BW)   // include address in USR ID.
    ) u_iq_fft_gain(
        .clk                            (clk),
        .clk_en                         (clk_en),
        .resetn                         (!reset),
        .scaler_gain_sign               (gain_scalar_sign),
        .scaler_gain                    (gain_scalar),
        .fraction_gain                  (gain_fraction),			
        .IFP_dfe_in                     (IFP_prach_fft_gain_in),
        .IFP_dfe_out                    (IFP_prach_fft_gain_out)
        );
//vio_fft_prach_gain vio_fft_prach_gain_1 (
//  .clk(clk),                // input wire clk
//  .probe_in0(ch_bw),    // input wire [3 : 0] probe_in0
//  .probe_out0(gain_scalar),  // output wire [3 : 0] probe_out0
//  .probe_out1(gain_fraction)  // output wire [15 : 0] probe_out1
//);
endmodule
