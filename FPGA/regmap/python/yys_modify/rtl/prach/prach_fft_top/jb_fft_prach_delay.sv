`timescale 1ns / 1ps

module jb_fft_prach_delay 
 (
    input        clk,               // i clock  using clk_4x
    input        clk_en,            // i clock enable           
    input        reset,             // i reset
    
    input  [3:0] ch_bw,             // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    input        frm_mrkr,          // i
    input        slot_mrkr,         // i
    input        sym_mrkr,          // i
    input        cp_mrkr,           // i
    input  [2:0] sym_cnt,           // i 
    output       frm_mrkr_out,      // o
    output       slot_mrkr_out,     // o
    output       sym_mrkr_out,      // o
    output       cp_mrkr_out,       // o
    output [2:0] sym_cnt_out        // o 
    );
    
logic [2:0][9:0] delay;
genvar i,j;
logic [2:0][6:0] data_in;
logic [2:0][6:0] data_out;

// create delay based on Channel Bandwidth
// delay is 2 more than value set. So 1023 is 1025.
// From PG126 LTE v2.1
// The latency is from asserting the START input to the last sample of
// output data coming out of the core, assuming that the UNLOAD input (if present) is
// asserted as soon as DONE goes High. Note that this is not the minimum number of
// cycles between starting consecutive frames, as frames can overlap in some cases.
// Basically need to calculate delay in simulation
   
always_ff @(posedge clk) begin
    if (clk_en) begin
        case (ch_bw)                                  //clk =2.034ns using 4x
            4'b0000 : begin                          //   now need 75.347496us which is 71.62731 more 71.62731us/2.034ns=35,215clks more
                      delay[0] <= 'd1022; // d1023  // need 3.718152 for prach? (based on pulse response)
                      delay[1] <= 'd800;  //d1023   // getting 3.720186 using 1022,800,1 ;getting 3.716485 w/ 1022,800,1    
                      delay[2] <= 'd1;  //d144
                      end
            4'b0001 : begin
                      delay[0] <= 'd1023;   // 10Mhz Delay based on IFFT/FFT core is 1100 TBD
                      delay[1] <= 'd73;
                      delay[2] <= 'd0;
                      end
            4'b0010 : begin 
                      delay[0] <= 'd544;   //  5Mhz Delay based on IFFT/FFT core is 550 TBD
                      delay[1] <= 'd0;
                      delay[2] <= 'd0;
                      end
            4'b0011 : begin
                      delay[0] <= 'd1023;   // 20Mhz Delay based on IFFT/FFT core is 2195
                      delay[1] <= 'd1023;
                      delay[2] <= 'd144;
                      end
            default : begin
                      delay[0] <= 'd1023;
                      delay[1] <= 'd1023;
                      delay[2] <= 'd144;
                      end        
        endcase
    end
end

assign data_in[0] = {frm_mrkr, slot_mrkr, sym_mrkr, cp_mrkr, sym_cnt};

generate
    for (i = 1; i < 3; i = i + 1) begin : gen_delay_connect
        assign data_in[i] = data_out[i-1];
    end : gen_delay_connect
endgenerate

generate
    for (j = 0; j < 3; j = j + 1) begin : gen_delay
        shift_delay_4x1024 shift_delay_inst (
          .A(delay[j]),        // input wire [9 : 0] A
          .D(data_in[j]),      // input wire [3 : 0] D
          .CLK(clk),           // input wire CLK
          .CE(clk_en),         // input wire clk enable
          .Q(data_out[j])      // output wire [3 : 0] Q
        );
    end : gen_delay
endgenerate

assign frm_mrkr_out  = data_out[2][6];
assign slot_mrkr_out = data_out[2][5];
assign sym_mrkr_out  = data_out[2][4];
assign cp_mrkr_out   = data_out[2][3];
assign sym_cnt_out   = data_out[2][2:0];
 
endmodule
