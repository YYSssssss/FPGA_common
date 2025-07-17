// =================================================================================================
// Phine Design (Japan) Co., Ltd.
// https://www.phinedesign.co.jp
// =================================================================================================

// =================================================================================================
// File Name      : PULSE_GEN.v
// Module         : PULSE_GEN
// Function       : Synchronous pulse from CLK_I to CLK_O
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by         Contents
// 1.0.0      2022/08/02   PDJP   			PDJP(K)-02-001(01)
//
// =================================================================================================
// End Revision
// =================================================================================================

// =================================================================================================
// RTL Header
// =================================================================================================
`timescale 1 ps / 1 ps
`default_nettype  none

module PULSE_GEN (
    input	wire							RST          	  					, // (i) Reset Input ( Asynchronous )
    input	wire							CLK_I           					, // (i) Clock at input side
    input	wire							CLK_O           					, // (i) Clock at output side
    input	wire							PULSE_I         					, // (i) Pulse input
    output	wire							PULSE_O            					  // (o) Pulse output
	) ;

	// -------------------------------------------------------------------------
	// Internal Signal Definition
	// -------------------------------------------------------------------------
    reg                   					r_pulse_i   						; // PULSE_I Toogle
    reg     		[2:0]               	r_pulse_o   						; // Sync of r_pulse_i

// =================================================================================================
// RTL Body
// =================================================================================================

	// -------------------------------------------------------------------------
	//      Input pulse keep                            ( CLK_I domain )
	// -------------------------------------------------------------------------
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
            r_pulse_i       <= 1'b0 ;
        end else begin
            if ( PULSE_I == 1'b1 ) begin
                r_pulse_i   <= ~r_pulse_i ;
            end
        end
    end


	// -------------------------------------------------------------------------
	//      Output pulse sync. and generate             ( CLK_O domain )
	// -------------------------------------------------------------------------
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
            r_pulse_o   <= 3'b000 ;
        end else begin
            r_pulse_o   <= { r_pulse_o[1:0] , r_pulse_i } ;
        end
    end

    assign PULSE_O = (r_pulse_o[2] != r_pulse_o[1] ) ;   // 0 -> 1

endmodule
`default_nettype wire
