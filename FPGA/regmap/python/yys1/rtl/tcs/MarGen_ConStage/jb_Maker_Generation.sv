`timescale 1ns / 1ps

module jb_Marker_Generation (
	input         clk,        
	input         reset,      
	input         frm_mrkr,   //one_pps
	//input         extended_cp,
	
	output logic        frm_mrkr_out 			= 0,        
	output logic [22:0] frm_mrkr_sample_cnt 	= 0, 
	output logic        sub_frame_mrkr 			= 0,      
	output logic [18:0] sub_frame_sample_cnt 	= 0,
	output logic [3:0]  sub_frame_cnt 			= 0,       
	output logic        slot_mrkr 				= 0,           
	output logic [17:0] slot_mrkr_sample_cnt 	= 0,
	output logic [4:0]  slot_cnt 				= 0,            
	output logic        sym_mrkr 				= 0,            
	output logic [15:0] sym_mrkr_sample_cnt 	= 0, 
	output logic [3:0]  sym_cnt 				= 0        
	//output logic        cp_mrkr = 0              
);
logic extended_cp = 0;

//1pps
logic [22:0] count_10ms             = 1;
logic [18:0] count_1ms              = 1;
logic [17:0] count_0p5ms            = 1;
logic [15:0] symbol_size_first_real = 0;
logic [15:0] symbol_size_real       = 0;
logic [17:0] start_symbol_real      = 0; 
//logic [15:0] cp_size_first_real     = 0;
//logic [15:0] cp_size_real           = 0;

//491.52Mhz下 10ms 计数 
always_ff @(posedge clk) begin
    if (frm_mrkr) count_10ms <= 0;  
    else if (count_10ms == 4915199) count_10ms <= 0;
    else count_10ms <= count_10ms + 1;
end

//491.52Mhz下 1pps 计数

//491.52Mhz下 1ms 计数 
always_ff @(posedge clk) begin 
    if (frm_mrkr) count_1ms <= 0;  
    else if (count_1ms == 491519) count_1ms <= 0;
    else count_1ms <= count_1ms + 1;
end

//491.52Mhz下 0.5ms 计数
always_ff @(posedge clk) begin  
    if (frm_mrkr) count_0p5ms <= 0; 
    else if (count_0p5ms == 245759) count_0p5ms <= 0;
    else count_0p5ms <= count_0p5ms + 1;
end

// Count sub frames	每1ms对subframe进行一次计数，10ms就是计数10次
always_ff @(posedge clk) begin
    if (count_10ms == 0) sub_frame_cnt <= 0;
    else if (count_1ms == 0) sub_frame_cnt <= sub_frame_cnt + 1;
end

// Count slots	每0.5ms对slot进行一次计数，1ms就是计数2次
always_ff @(posedge clk) begin
    if (count_10ms == 0) slot_cnt <= 0;
    else if (count_0p5ms == 0) slot_cnt <= slot_cnt + 1;
end

// Register all outputs.
always_ff @(posedge clk) begin  
    frm_mrkr_out <= (count_10ms == 0);	//radio_frame（开始）标记位置
    frm_mrkr_sample_cnt <= count_10ms;	//4915199计数显示
    sub_frame_mrkr <= (count_1ms == 0);	//subframe（开始）标记位置
    sub_frame_sample_cnt <= count_1ms;	//491519计数显示
    slot_mrkr <= (count_0p5ms == 0);	//slot（开始）标记位置
    slot_mrkr_sample_cnt <= count_0p5ms;//245759计数显示
end

// symbol size
always_ff @(posedge clk) begin
    if (extended_cp) begin
        symbol_size_first_real <= 16'd40960;
        symbol_size_real <= 16'd40960; 
        //cp_size_first_real <= 16'd8191;
        //cp_size_real <= 16'd8191;
        end
    else begin
        symbol_size_first_real <= 16'd17779; //36.19 
        symbol_size_real <= 16'd17537;		 //35.67/2.034
        //cp_size_first_real <= 16'd2559;
        //cp_size_real <= 16'd2303;
        end       
end

// Create symbol marker real time
always_ff @(posedge clk) begin  
    if (count_0p5ms == 0) begin  // reset on slot marker
        start_symbol_real <= symbol_size_first_real;
        sym_mrkr <= 1;
        sym_mrkr_sample_cnt <= 0;
        sym_cnt <= 0;
        //cp_mrkr <= 1;
        end
    else if (count_0p5ms == start_symbol_real) begin
        start_symbol_real <= start_symbol_real + symbol_size_real;
        sym_mrkr <= 1;
        sym_mrkr_sample_cnt <= 0;
        sym_cnt <= sym_cnt + 1;
		//sym_cnt <= (sym_cnt==4'd14) ? 4'd0 : (sym_cnt + 1) ;
        //cp_mrkr <= 1;
        end
    else begin
        sym_mrkr <= 0;
        sym_mrkr_sample_cnt <= sym_mrkr_sample_cnt + 1;
        //if ((count_0p5ms < symbol_size_first_real) && (sym_mrkr_sample_cnt < cp_size_first_real)) cp_mrkr <= 1;  // first symbol
        //else if (sym_mrkr_sample_cnt < cp_size_real) cp_mrkr <= 1;
        //else cp_mrkr <= 0;
        end
end

endmodule