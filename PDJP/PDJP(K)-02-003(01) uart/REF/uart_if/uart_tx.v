// =================================================================================================
// File Name      : UART_TX.v
// Module         : UART_TX
// Function       : UART_TX Control
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

module uart_tx # (
	parameter			C_BIT_CNT				= 12'h364
	)(
 	// Global Signal
	input               CLK_100M         , 						// System Clock 100MHz
	input               IO_RESET         , 						// ASY System Reset

	// GTX Interface
    output              UART_TXD		 , 						// UART Output Data
    input    [7:0]      UART_TX_DATA	 , 						// UART TX Data
    output              UART_TX_COMPLETE , 						// UART 8Bit Data TX Complete
    input               UART_TX_EN		 						// UART TX Enable
	) ;

	// =============================================================================
	// Signal Define
	// =============================================================================
	
	parameter	TX_IDLE			= 4'b0001		, // Idle
				TX_START		= 4'b0010		, // Start
				TX_DATA			= 4'b0100		, // TX data
				TX_END 			= 4'b1000		; // End
	
	reg		[ 3:0]		r_TX_FSM				; // TX State Machine
	
	// TXD
	wire				s_TX_BIT_END			; // UART_TXD TX 1 Bit Clk End
	reg		[3:0]		r_TX_BIT_CNT			; // UART_TXD TX Data Count
	wire				s_TX_FSM_IDLE			; // TXD FSM IDLE Status
	wire				s_TX_FSM_TX_START		; // TXD FSM START Status
	wire				s_TX_FSM_TX_DATA		; // TXD FSM DATA Status
	wire				s_TX_FSM_TX_END			; // TXD FSM END Status
	reg		[11:0]		r_TX_CNT				; // UART_TXD TX Count
	reg		[ 7:0]		r_TXD					; // UART_TXD Onput
	reg					r_TX_COMPLETE			; // UART_TXD 8Bit Data Transmit Complete
	reg					r_UART_TX_EN_1D			; // UART_TX_EN Delay 1Clk

	// =============================================================================
	// RTL
	// =============================================================================

	// =====================================================
	// UART Transmit Control
	// =====================================================
	assign s_TX_BIT_END =  ( r_TX_CNT == C_BIT_CNT) ?  1'b1 : 1'b0 ;

	// TXD Main FSM
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
 	 	if ( IO_RESET ) begin
 	 		r_TX_FSM <= TX_IDLE ;
 	 	end else begin
 	 		case (r_TX_FSM)
 	 			TX_IDLE : begin
 	 				if( UART_TX_EN == 1'b1) begin
 	 					r_TX_FSM <= TX_START ;
 	 				end else begin
 	 					r_TX_FSM <= TX_IDLE ;
 	 				end
 	 			end
 	 			
 	 			TX_START : begin
 	 				if(s_TX_BIT_END == 1'b1) begin
 	 					r_TX_FSM <= TX_DATA ;
					end else begin
						r_TX_FSM <= TX_START ;
 	 				end
 	 			end
 	 			
 	 			TX_DATA : begin
 	 				if(s_TX_BIT_END ==1'b1 && r_TX_BIT_CNT == 4'h7) begin
 	 					r_TX_FSM <= TX_END ;
					end else begin
						r_TX_FSM <= TX_DATA ;
 	 				end
 	 			end
				
 				TX_END : begin
 					if(s_TX_BIT_END == 1'b1) begin
 						r_TX_FSM <= TX_IDLE ;
					end else begin
						r_TX_FSM <= TX_END ;
 					end
 				end 				

                default :begin
                    r_TX_FSM  <= TX_IDLE ;
                end
				
 			endcase
 		end
	end

	// FSM Decode    
	assign s_TX_FSM_IDLE		= ( r_TX_FSM == TX_IDLE  ) ? 1'b1 : 1'b0 ;
	assign s_TX_FSM_TX_START	= ( r_TX_FSM == TX_START ) ? 1'b1 : 1'b0 ;
	assign s_TX_FSM_TX_DATA		= ( r_TX_FSM == TX_DATA  ) ? 1'b1 : 1'b0 ;
	assign s_TX_FSM_TX_END		= ( r_TX_FSM == TX_END	 ) ? 1'b1 : 1'b0 ;

	// TX_CNT
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
 	 	if ( IO_RESET ) begin
 	 		r_UART_TX_EN_1D <= 1'b0 ;
 	 	end else begin
			r_UART_TX_EN_1D <= UART_TX_EN ;
		end 
	end

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET) begin
			r_TX_CNT <= {12{1'b0}} ;
 	 	end else begin
			if( s_TX_FSM_IDLE == 1'b1 ) begin
				if( r_UART_TX_EN_1D == 1'b1 ) begin
					r_TX_CNT <= r_TX_CNT + 1'b1 ;
				end else begin
					r_TX_CNT <= {12{1'b0}} ;
				end
			end else if( s_TX_FSM_TX_START == 1'b1 ||
				   s_TX_FSM_TX_DATA  == 1'b1 ||
				   s_TX_FSM_TX_END   == 1'b1 ) begin
				if( s_TX_BIT_END == 1'b1 ) begin
					r_TX_CNT <= {12{1'b0}} ;
				end else begin
					r_TX_CNT <= r_TX_CNT + 1'b1 ;
				end
			end
		end
	end

	// TX_BIT_CNT
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TX_BIT_CNT <= 4'h0 ;
 	 	end else begin
			if( s_TX_FSM_TX_DATA == 1'b1 ) begin
				if( s_TX_BIT_END == 1'b1 ) begin
					if( r_TX_BIT_CNT == 4'h7 ) begin
						r_TX_BIT_CNT <= 4'h0 ;
					end else begin
						r_TX_BIT_CNT <= r_TX_BIT_CNT + 1'b1 ;
					end
				end else begin
					r_TX_BIT_CNT <= r_TX_BIT_CNT ;
				end
			end else begin
				r_TX_BIT_CNT <= 4'h0 ;
			end
		end
	end

	// TXD Control
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TXD <= 8'hFF ;
 	 	end else begin
			case ( r_TX_FSM ) 
				TX_IDLE	: begin
					if( UART_TX_EN == 1'b1 ) begin
						r_TXD <= 8'hFE ;
					end else begin
						r_TXD <= 8'hFF ;
					end
				end
				TX_START : begin
					if( s_TX_BIT_END == 1'b1 ) begin
						r_TXD <= UART_TX_DATA ;
					end else begin
						r_TXD <= 8'hFE ;
					end
				end
				TX_DATA	: begin
					if( s_TX_BIT_END == 1'b1 ) begin
						if( r_TX_BIT_CNT == 4'h7 ) begin
							r_TXD <= 8'hFF ;
						end else begin
							r_TXD <= { 1'b1, r_TXD[7:1] } ;
						end
					end else begin
						r_TXD <= r_TXD ;
					end
				end
				TX_END : begin
					if( s_TX_BIT_END == 1'b1 ) begin
						r_TXD <= 8'hFF ;
					end else begin
						r_TXD <= r_TXD ;
					end
				end
                default :begin
                    r_TXD  <= r_TXD ;
                end
				
 			endcase
		end
	end

	assign UART_TXD	= r_TXD[0] ;

	// TX_COMPLETE
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TX_COMPLETE <= 1'b0 ;
 	 	end else begin
			if( s_TX_BIT_END == 1'b1 ) begin
				if( s_TX_FSM_TX_END == 1'b1 ) begin
					r_TX_COMPLETE <= 1'b1 ;
				end else begin
					r_TX_COMPLETE <= 1'b0 ;
				end
			end else begin
				r_TX_COMPLETE <= 1'b0 ;
			end
		end
	end

	assign UART_TX_COMPLETE	= r_TX_COMPLETE ;

endmodule
