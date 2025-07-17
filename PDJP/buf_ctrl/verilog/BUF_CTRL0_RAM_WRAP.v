// =================================================================================================
// Phine Design (Japan) Co., Ltd.
// https://www.phinedesign.co.jp
// =================================================================================================

// =================================================================================================
// File Name      : BUF_CTRL0_RAM_WRAP.v
// Module         : BUF_CTRL0_RAM_WRAP
// Function       : Buffer Wrap
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by         Contents
// 1.0.0      2022/08/02   PDJP   			-
//
// =================================================================================================
// End Revision
// =================================================================================================

// =================================================================================================
// RTL Header
// =================================================================================================
`timescale 1 ps / 1 ps
`default_nettype  none

module BUF_CTRL0_RAM_WRAP #(
	parameter								P_FPGA_TYP			= 0				, // FPGA Type(0:Xilinx,1:Intel)
	parameter								P_DBUS_W_I			= 32			, // Input data bus width
	parameter								P_DBUS_W_O			= 128			, // Output data bus width
	parameter								P_ABUS_W_I			= 12			, // Input address bus width
	parameter								P_ABUS_W_O			= 10			  // Output address bus width

	)(
	// Write 
	input	wire							CLK_I								, // (i) Clock Input Side
	input 	wire	[P_ABUS_W_I-1:0]		WADD								, // (i) Write Address
	input 	wire	[P_DBUS_W_I-1:0]		WDT									, // (i) Write Data
	input	wire							WEN									, // (i) Write Enable

	// Read
	input	wire							CLK_O								, // (i) Clock Output Side
	input 	wire	[P_ABUS_W_O-1:0]		RADD								, // (i) Read Address
	output 	wire	[P_DBUS_W_O-1:0]		RDT									, // (o) Read Data
	input	wire							REN									  // (i) Read Enable
	);

// =================================================================================================
// RTL Body
// =================================================================================================


generate
	if ( P_FPGA_TYP == 0 ) begin : DBUF_X
//	DPRAM_I_32x5K_32x5K U_DBUF(
//	DPRAM_I_32x3K_128x3K U_DBUF(
	DPRAM_I_128x2K_32x2K U_DBUF(
			.clka			( CLK_I					), // (i)
		.addra			( WADD					), // (i)
		.dina			( WDT					), // (i)
		.ena			( 1'b1					), // (i)
		.wea			( WEN					), // (i)
		.clkb			( CLK_O					), // (i)
		.addrb			( RADD					), // (i)
		.doutb			( RDT					), // (o)
		.enb			( REN					)  // (i)
	);
    end
endgenerate


endmodule
`default_nettype wire
