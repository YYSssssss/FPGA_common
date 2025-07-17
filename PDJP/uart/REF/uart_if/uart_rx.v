// =================================================================================================
// File Name      : UART_RX.v
// Module         : UART_RX
// Function       : UART_RX Control
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by        Contents
// 0.0.1      2011/10/10   TEDWX)wei.w	   create new 
// 1.0.1      2014/08/28   TEDWX)Guo.j     Modify to Verilog
//
// =================================================================================================
// End Revision
// =================================================================================================

// =============================================================================
// Timescale Define
// =============================================================================

`timescale 1ns / 1ps

module uart_rx # (
	parameter			C_BIT_CNT				= 12'h364
	)(
 	// Global Signal
	input               CLK_100M        	, 						// System Clock 100MHz
	input               IO_RESET        	, 						// ASY System Reset

	// GTX Interface
    input	            UART_RXD		 	, 						// UART Input Data
    output    [7:0]     UART_RX_DATA		, 						// UART RX Data
    output              UART_RX_COMPLETE  							// UART 8Bit Data RX Complete
	) ;

	// =============================================================================
	// Signal Define
	// =============================================================================
	
	parameter	RX_IDLE			= 4'b0001		, // Idle
				RX_START		= 4'b0010		, // Start
				RX_DATA			= 4'b0100		, // TX data
				RX_END 			= 4'b1000		; // End
	
	reg		[ 3:0]		r_RX_FSM				; // RX State Machine
	
	// RXD
	reg					r_RXD_1D				; // UART_RXD Input Register
	reg					r_RXD_2D				; // UART_RXD Input Register
	reg					r_RXD_3D				; // UART_RXD Input Register
	reg					r_RXD					; // UART_RXD Input Register
	reg		[11:0]		r_RX_CNT				; // UART_RXD RX Count
	wire	[10:0]		s_HALF_BIT_CNT			; // UART_RXD RX 1/2 Bit Clk Count
	wire				s_HALF_BIT_END			; // UART_RXD RX 1/2 Bit Clk end
	wire				s_RX_BIT_END			; // UART_RXD RX 1 Bit End
	wire				s_RX_FSM_IDLE			; // RXD FSM IDLE Status
	wire				s_RX_FSM_RX_START		; // RXD FSM START Status
	wire				s_RX_FSM_RX_DATA		; // RXD FSM DATA Status
	wire				s_RX_FSM_RX_END			; // RXD FSM END Status
	reg		[ 3:0]		r_RX_BIT_CNT			; // UART Receive Data Count
	reg		[ 7:0]		r_RX_DATA				; // UART Receive Data
	reg					r_RX_COMPLETE			; // UART 8Bit Data Receive Complete

	// =============================================================================
	// RTL
	// =============================================================================

	// =====================================================
	// UART Receive Control
	// =====================================================
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_RXD_1D <= 1'b1 ;
            r_RXD_2D <= 1'b1 ;   
			r_RXD_3D <= 1'b1 ;
 	 	end else begin
			r_RXD_1D <= UART_RXD ;
            r_RXD_2D <= r_RXD_1D ;
            r_RXD_3D <= r_RXD_2D ;
		end
	end

	// Filter Noise
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_RXD <= 1'b1;
 	 	end else begin
			if( r_RXD_2D == r_RXD_3D ) begin
				r_RXD <= r_RXD_2D ;
			end else begin
				r_RXD <= r_RXD ;
			end
		end
	end

	assign s_HALF_BIT_CNT	=  C_BIT_CNT[11:1] ;
	assign s_RX_BIT_END 	=  ( r_RX_CNT == C_BIT_CNT	) ? 1'b1 : 1'b0 ;
	assign s_HALF_BIT_END	=  ( r_RX_CNT == s_HALF_BIT_CNT ) ? 1'b1 : 1'b0 ;


	// RXD Main FSM
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
 	 	if ( IO_RESET ) begin
			r_RX_FSM <= RX_IDLE ;
 	 	end else begin
			case ( r_RX_FSM )
				RX_IDLE : begin
					if( r_RXD == 1'b0 ) begin
						r_RX_FSM <= RX_START ;
					end else begin
						r_RX_FSM <= RX_IDLE ;
					end
				end
				RX_START : begin
					if( s_HALF_BIT_END == 1'b1 ) begin
						if( r_RXD == 1'b1 ) begin
							r_RX_FSM <= RX_IDLE ;
						end else begin
							r_RX_FSM <= RX_START ;
						end
					end else if( s_RX_BIT_END == 1'b1 ) begin
						r_RX_FSM <=RX_DATA ;
					end else begin
						r_RX_FSM <= RX_START ;
					end
				end
				RX_DATA : begin
					if( s_RX_BIT_END == 1'b1 && r_RX_BIT_CNT == 4'h7 ) begin
						r_RX_FSM <= RX_END ;
					end else begin
						r_RX_FSM <= RX_DATA ;
					end
				end
				RX_END : begin
					if( s_HALF_BIT_END == 1'b1 ) begin
						r_RX_FSM <= RX_IDLE ;
					end else begin
						r_RX_FSM <= RX_END ;
					end
				end
                default :begin
					r_RX_FSM  <= RX_IDLE ;
				end
			endcase
		end
	end

	// FSM Decode    
	assign s_RX_FSM_IDLE		= ( r_RX_FSM == RX_IDLE  ) ? 1'b1 : 1'b0 ;
	assign s_RX_FSM_RX_START	= ( r_RX_FSM == RX_START ) ? 1'b1 : 1'b0 ;
	assign s_RX_FSM_RX_DATA		= ( r_RX_FSM == RX_DATA  ) ? 1'b1 : 1'b0 ;
	assign s_RX_FSM_RX_END		= ( r_RX_FSM == RX_END   ) ? 1'b1 : 1'b0 ;

	// RX_CNT
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET) begin
			r_RX_CNT <= {12{1'b0}} ;
 	 	end else begin
			if( s_RX_FSM_IDLE == 1'b1 ) begin
				if( r_RXD == 1'b0 ) begin
					r_RX_CNT <= {12{1'b0}} ;
				end
			end else if(( s_RX_FSM_RX_START == 1'b1 ||
				   	s_RX_FSM_RX_DATA  == 1'b1 ) && 
					s_RX_BIT_END == 1'b1	) begin
				r_RX_CNT <= {12{1'b0}} ;
			end else if( s_RX_FSM_RX_END == 1'b1 && 		// Rx End
					s_HALF_BIT_END == 1'b1 ) begin
				r_RX_CNT <= {12{1'b0}} ;
			end else begin
				r_RX_CNT <= r_RX_CNT + 1'b1 ;
			end
		end
	end

	// RX_BIT_CNT
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_RX_BIT_CNT <= 4'h0 ;
 	 	end else begin
			if( s_RX_FSM_RX_DATA == 1'b1 ) begin
				if( s_RX_BIT_END == 1'b1 ) begin
					if( r_RX_BIT_CNT == 4'h7 ) begin
						r_RX_BIT_CNT <= 4'h0 ;
					end else begin
						r_RX_BIT_CNT <= r_RX_BIT_CNT + 1'b1;
					end
				end else begin
					r_RX_BIT_CNT <= r_RX_BIT_CNT ;
				end
			end else begin
				r_RX_BIT_CNT <= 4'h0 ;
			end
		end
	end

	// UART Receive DATA
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_RX_DATA <= 8'h00 ;
 	 	end else begin
			if( s_RX_FSM_RX_DATA == 1'b1 ) begin
				if( s_HALF_BIT_END == 1'b1 ) begin
					r_RX_DATA <= {r_RXD , r_RX_DATA[7:1]} ;
				end else begin
					r_RX_DATA <= r_RX_DATA ;
				end
			end else begin
				r_RX_DATA <= r_RX_DATA ;
			end
		end
	end

	assign UART_RX_DATA	= r_RX_DATA ;

	// 8Bit Data Receive Complete
	// RX_DATA is not VALID
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_RX_COMPLETE <= 1'b0 ;
 	 	end else begin
			if( s_RX_FSM_RX_END == 1'b1 && s_HALF_BIT_END == 1'b1 ) begin
				r_RX_COMPLETE <= 1'b1 ;
			end else begin
				r_RX_COMPLETE <= 1'b0 ;
			end
		end
	end

	assign UART_RX_COMPLETE	= r_RX_COMPLETE ;

endmodule
