`timescale 1ns / 1ps

module jb_lte_fft_gain # (
    parameter USR_ID_BW=2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4
)
 (
    input clk,              
    input clk_en,
    input reset,
    jb_axi4_stream_if.slave IFP_fft_gain_in,
    input [3:0] ch_bw, // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    
    //jb_oran_lphy_ctrl_if.lphy              IFP_oran_lphy_ctrl,
     
    // Output
    jb_axi4_stream_if.master IFP_fft_gain_out
    ); 
    
    logic 		               gain_scalar_sign;
    logic [GAIN_SCALER_BW-1:0] gain_scalar;
    logic [PRECISION-1:0]      gain_fraction;
    
    logic 		               gain_scalar_sign_muxed;
    logic [GAIN_SCALER_BW-1:0] gain_scalar_muxed;
    logic [PRECISION-1:0]      gain_fraction_muxed;

// Including -3db Mavenir gain
//        4'b0000 : begin gain_scalar =  1; gain_fraction = 'h8075; end  // 3.0103 - 3 = 0.0103
//        4'b0001 : begin gain_scalar =  1; gain_fraction = 'hB5AA; end  // 6.0206 - 3 = 3.0206
//        4'b0010 : begin gain_scalar =  1; gain_fraction = 'h8075; end  // 3.0103 - 3 = 0.0103
//        4'b0011 : begin gain_scalar =  1; gain_fraction = 'h8075; end  // 3.0103 - 3 = 0.0103
//        default : begin gain_scalar =  1; gain_fraction = 'h8075; end  // 3.0103 - 3 = 0.0103    
always_comb begin
    case (ch_bw) // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
        4'b0000 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103
        4'b0001 : begin gain_scalar =  2; gain_fraction = 'h809C; end  // 6.0206
        4'b0010 : begin gain_scalar =  1; gain_fraction = 'hFFFF; end  // 6.0103 
        4'b0011 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103
		4'b0100 : begin gain_scalar =  0; gain_fraction = 'hFFFF; end  // 3.0103
        default : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103   
    endcase
end

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
        .IFP_dfe_in                     (IFP_fft_gain_in),
        .IFP_dfe_out                    (IFP_fft_gain_out)
        );

endmodule
