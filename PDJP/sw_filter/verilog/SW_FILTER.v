// =================================================================================================
// Phine Design (Japan) Co., Ltd.
// https://www.phinedesign.co.jp
// =================================================================================================

// =================================================================================================
// File Name      : SW_FILTER.v
// Module         : SW_FILTER
// Function       : Switch filter
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by         Contents
// 1.0.0      2022/08/02   PDJP   			PDJP(K)-02-023(01)
//
// =================================================================================================
// End Revision
// =================================================================================================

// =================================================================================================
// RTL Header
// =================================================================================================
`timescale 1 ps / 1 ps
`default_nettype  none

module SW_FILTER #(
	parameter								P_SIM				= 0			  	, // 1:simulation use only
	parameter								P_DBUS_W			= 8				, // data bus width
	parameter								P_INIT_VAL			= 1'b0			, // The Initial value of Switch 
	parameter								P_SAMP_CNT			= 10000			  // Sampling Timecounter(100MHz Clock: 100us/10ns=10000,Max:65536) 

	)(
	// board clock & reset signals
	input	wire							CLK									, // (i) Clock
	input	wire							RST									, // (i) async. reset (high active)

	// Switch Input
	input	wire	[P_DBUS_W-1:0]			SW_I								, // (i) Switch input

	// Switch Output
	output	wire	[P_DBUS_W-1:0]			SW_O								  // (o) Switch output
	);

	// -------------------------------------------------------------------------
	// Internal Parameter Definition
	// -------------------------------------------------------------------------
    parameter		[15:0]					P_100US	= (P_SIM) ? 16'd1 : P_SAMP_CNT-2	; // Time about 100us (100MHz Clock: 0x2710-2)

	// -------------------------------------------------------------------------
	// Internal Signal Definition
	// -------------------------------------------------------------------------
	// 10us timer
	reg				[15:0]					r_sampl_cnt							; // Sampling timer counter
	reg										r_sampl_timeup						; // Sampling timer timeup

	// sw filter
	reg				[P_DBUS_W-1:0]			r_sw_ff1							; // buffer1 of SW_I
	reg				[P_DBUS_W-1:0]			r_sw_ff2							; // buffer2 of SW_I
	reg				[P_DBUS_W-1:0]			r_sw_ff3							; // buffer3 of SW_I
	reg				[P_DBUS_W-1:0]			r_sw_ff4							; // buffer4 of SW_I
	reg				[P_DBUS_W-1:0]			r_sw_ff5							; // buffer5 of SW_I
	reg				[P_DBUS_W-1:0]			r_sw_ff6							; // buffer6 of SW_I

// =================================================================================================
// RTL Body
// =================================================================================================

	// -------------------------------------------------------------------------
	// 10us timer
	// -------------------------------------------------------------------------
	// timer counter
	always @( posedge CLK or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_sampl_cnt	<= 16'd0 ;
		end else begin
			if ( r_sampl_timeup == 1'b1 ) begin
				r_sampl_cnt <= 16'd0;
			end else begin
				r_sampl_cnt <= r_sampl_cnt + 1;
			end
		end
	end

	// 10 us flag generate
	always @( posedge CLK or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_sampl_timeup <= 1'b0;
		end else begin
			if (r_sampl_cnt == P_100US)begin
				r_sampl_timeup <= 1'b1;
			end else begin
				r_sampl_timeup <= 1'b0;
			end
		end
	end

	// -------------------------------------------------------------------------
	// sw filter
	// -------------------------------------------------------------------------
	// timer counter
	always @( posedge CLK or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_sw_ff1	<= {P_DBUS_W{P_INIT_VAL}} ;
			r_sw_ff2	<= {P_DBUS_W{P_INIT_VAL}} ;
			r_sw_ff3	<= {P_DBUS_W{P_INIT_VAL}} ;
			r_sw_ff4	<= {P_DBUS_W{P_INIT_VAL}} ;
			r_sw_ff5	<= {P_DBUS_W{P_INIT_VAL}} ;
			r_sw_ff6	<= {P_DBUS_W{P_INIT_VAL}} ;
		end else begin
			r_sw_ff1	<= SW_I ;
			r_sw_ff2	<= r_sw_ff1 ;
			if ( r_sampl_timeup == 1'b1 ) begin	// sample at 100us 
				r_sw_ff3	<= r_sw_ff2 ;
				r_sw_ff4	<= r_sw_ff3 ;
				r_sw_ff5	<= r_sw_ff4 ;
			end
			if ( r_sw_ff3 == r_sw_ff4 && r_sw_ff4 == r_sw_ff5) begin	// no change
				r_sw_ff6	<= r_sw_ff5 ;
			end
		end
	end

	// -------------------------------------------------------------------------
	// Output
	// -------------------------------------------------------------------------
	assign SW_O 	= r_sw_ff6 ;

endmodule
`default_nettype wire
