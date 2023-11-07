`timescale 1ns / 1ps

module jb_prach_marker_generation 
 (
    input         clk,              // i clock  491.52Mhz
    input         reset,            // i reset
    input         frm_mrkr,         // i 10ms frm_mrkr on 491.52Mhz. Pulse
    input         extended_cp,      // i
    
    // Real time signals
    output logic        frm_mrkr_out = 0,          // o frame marker aligned
    output logic [22:0] frm_mrkr_sample_cnt = 0,   // o framer marker sample count
    output logic        sub_frame_mrkr = 0,        // o sub frame marker every 1ms
    output logic [18:0] sub_frame_sample_cnt = 0,  // o sub frame sample count
    output logic [3:0]  sub_frame_cnt = 0,         // o sub frame count 0 to 9
    output logic        slot_mrkr = 0,             // o slot marker every 0.5ms
    output logic [17:0] slot_mrkr_sample_cnt = 0,  // o slot marker sample count
    output logic [4:0]  slot_cnt = 0,              // o slot count 0 to 19
    output logic        sym_mrkr = 0,              // o symbol marker 
    output logic [15:0] sym_mrkr_sample_cnt = 0,   // o symbol marker sample count
    output logic [2:0]  sym_cnt = 0,               // o symbol count
    output logic        cp_mrkr = 0                // o CP marker    
    );
     
logic [22:0] count_10ms             = 4915199;
logic [18:0] count_1ms              = 491519;
logic [17:0] count_0p5ms            = 245759;
logic [15:0] symbol_size_first_real = 0;
logic [15:0] symbol_size_real       = 0;
logic [15:0] cp_size_first_real     = 0;
logic [15:0] cp_size_real           = 0;
logic [17:0] start_symbol_real      = 0; 


always_ff @(posedge clk) begin  
    if (frm_mrkr) count_10ms <= 0;  
    else if (count_10ms == 4915199) count_10ms <= 0;
    else count_10ms <= count_10ms + 1;
end

always_ff @(posedge clk) begin  
    if (frm_mrkr) count_1ms <= 0;  
    else if (count_1ms == 491519) count_1ms <= 0;
    else count_1ms <= count_1ms + 1;
end

always_ff @(posedge clk) begin  
    if (frm_mrkr) count_0p5ms <= 0; 
    else if (count_0p5ms == 245759) count_0p5ms <= 0;
    else count_0p5ms <= count_0p5ms + 1;
end

// Count sub frames
always_ff @(posedge clk) begin
    if (count_10ms == 0) sub_frame_cnt <= 0;
    else if (count_1ms == 0) sub_frame_cnt <= sub_frame_cnt + 1;
end

// Count slots
always_ff @(posedge clk) begin
    if (count_10ms == 0) slot_cnt <= 0;
    else if (count_0p5ms == 0) slot_cnt <= slot_cnt + 1;
end

// Register all outputs.
always_ff @(posedge clk) begin  
    frm_mrkr_out <= (count_10ms == 0);
    frm_mrkr_sample_cnt <= count_10ms;
    sub_frame_mrkr <= (count_1ms == 0);
    sub_frame_sample_cnt <= count_1ms;
    slot_mrkr <= (count_0p5ms == 0);
    slot_mrkr_sample_cnt <= count_0p5ms;
end

// symbol size
always_ff @(posedge clk) begin
    if (extended_cp) begin
        symbol_size_first_real <= 16'd40960;
        symbol_size_real <= 16'd40960; 
        cp_size_first_real <= 16'd8191;
        cp_size_real <= 16'd8191;
        end
    else begin
        symbol_size_first_real <= 16'd35328; 
        symbol_size_real <= 16'd35072; 
        cp_size_first_real <= 16'd2559;
        cp_size_real <= 16'd2303;
        end       
end

// Create symbol marker real time
always_ff @(posedge clk) begin  
    if (count_0p5ms == 0) begin  // reset on slot marker
        start_symbol_real <= symbol_size_first_real;
        sym_mrkr <= 1;
        sym_mrkr_sample_cnt <= 0;
        sym_cnt <= 0;
        cp_mrkr <= 1;
        end
    else if (count_0p5ms == start_symbol_real) begin
        start_symbol_real <= start_symbol_real + symbol_size_real;
        sym_mrkr <= 1;
        sym_mrkr_sample_cnt <= 0;
        sym_cnt <= sym_cnt + 1;
        cp_mrkr <= 1;
        end
    else begin
        sym_mrkr <= 0;
        sym_mrkr_sample_cnt <= sym_mrkr_sample_cnt + 1;
        if ((count_0p5ms < symbol_size_first_real) && (sym_mrkr_sample_cnt < cp_size_first_real)) cp_mrkr <= 1;  // first symbol
        else if (sym_mrkr_sample_cnt < cp_size_real) cp_mrkr <= 1;
        else cp_mrkr <= 0;
        end
end


endmodule

