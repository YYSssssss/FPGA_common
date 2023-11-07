`timescale 1ns / 1ps

module jb_lte_ifft_gain_nr # (
    parameter USR_ID_BW=2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4
)
 (
    input clk,              
    input clk_en,
    input reset,
    jb_axi4_stream_if.slave IFP_ifft_gain_in,
    input [3:0] ch_bw, // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    input cp_in,
    
    // Output
    jb_axi4_stream_if.master IFP_ifft_gain_out,
    output logic cp_out    
    ); 
    
    logic 		               gain_scalar_sign;
    logic [GAIN_SCALER_BW-1:0] gain_scalar;
    logic [PRECISION-1:0]      gain_fraction;
    logic [4:0]                cp_delay;
 
/*
always_comb begin
    case (ch_bw) // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
        4'b0000 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103
        4'b0001 : begin gain_scalar =  2; gain_fraction = 'h809C; end  // 6.0206
        4'b0010 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103
        4'b0011 : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103
        default : begin gain_scalar =  1; gain_fraction = 'hB573; end  // 3.0103     
    endcase
end
*/
 
//Gain settings are updated to compensate for gain loss due to 0 padding in iFFT
always_comb begin
    case (ch_bw) // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
        4'b0000 : begin gain_scalar =  1; gain_fraction = 'hED0B; end  // 20Mhz:3.0103 + 2.3215=5.33178, 10log(2048/1200)=2.32
        4'b0001 : begin gain_scalar =  2; gain_fraction = 'hA803; end  // 10Mhz:6.0206 + 2.3215=8.3406, 10 log(1024/600)=2.32
        4'b0010 : begin gain_scalar =  2; gain_fraction = 'hED0B; end  // 5Mhz:3.0103 + 6 (observed in tests) + 2.32=11.33, 10log(512/300)=2.32
        4'b0011 : begin gain_scalar =  2; gain_fraction = 'h892F; end  // 15Mhz:3.0103 + 3.57087=6.5813, 10log(2048/900)=3.571
        4'b0100 : begin gain_scalar =  1; gain_fraction = 'hED0B ; end     //100M : 10log(4096/3276)=0.97016    -----??
        default : begin gain_scalar =  1; gain_fraction = 'hED0B; end  // 20Mhz:3.0103 + 2.3215=5.33, 10log(2048/1200)=2.32
    endcase
end


    assign gain_scalar_sign = 0;  // Direction of the shift 0 left, 1 right

   //Set the gain based on bandwidth, BW=15, 5dB, else 0
    jb_iq_gain_mult #(
        .PRECISION                      (PRECISION),
        .SCALER_BW                      (GAIN_SCALER_BW),
        .USR_ID_BW                      (USR_ID_BW)
    ) u_iq_ifft_gain(
        .clk                            (clk),
        .clk_en                         (clk_en),
        .resetn                         (!reset),
        .scaler_gain_sign               (gain_scalar_sign),
        .scaler_gain                    (gain_scalar),
        .fraction_gain                  (gain_fraction),			
        .IFP_dfe_in                     (IFP_ifft_gain_in),
        .IFP_dfe_out                    (IFP_ifft_gain_out)
        );

// Six clock delay 
always_ff @(posedge clk) begin
    if (clk_en) begin
        cp_delay[0] <= cp_in;
        cp_delay[1] <= cp_delay[0];
        cp_delay[2] <= cp_delay[1];
        cp_delay[3] <= cp_delay[2];
        cp_delay[4] <= cp_delay[3];
        cp_out      <= cp_delay[4];
    end
end

endmodule
