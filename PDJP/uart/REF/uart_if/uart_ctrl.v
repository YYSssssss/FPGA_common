// =================================================================================================
// File Name      : UART_CTRL.v
// Module         : UART_CTRL
// Function       : UART Control
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by        Contents
// 0.0.1      2011/10/10   TEDWX)wei.w	   create new 
// 1.0.1      2014/08/28   TEDWX)Guo.j     1)Modify to Verilog
//										   2)Modify Address Format from 8bit to 16 bit
// =================================================================================================
// End Revision
// =================================================================================================

// =============================================================================
// Timescale Define
// =============================================================================

`timescale 1ns / 1ps

module uart_ctrl
	(
	// Global Signal
	input				CLK_100M						, // (i) System Clock 100MHz
	input				IO_RESET						, // (i) ASY System Reset
	                                        			         
	// RX
	input				UART_RX_COMPLETE				, // (i) UART RX 1 Byte Data Complete
	input	[  7:0]		UART_RX_DATA					, // (i) UART Receiving Data

	// TX
	input				UART_TX_COMPLETE				, // (i) UART 8Bit Data TX Complete
	output	[  7:0]		UART_TX_DATA					, // (o) UART TX Data
	output				UART_TX_EN						, // (o) UART TX Enable

	// DRAM_IO Interface
	input	[511:0]		IO_DRAM_RDATA					, // (i) FPGA Configuration Data Request
	input				IO_DRAM_RD_VLD					, // (i) FPGA Configuration One Group Data End Flag(256 Data For One Group)
	output				UART_TRAN_BUSY					, // (o) FPGA Configuration Status(0:No Data, 1:Have Data)

	// PARAM_IO Interface
	output				REG_WE							, // (o) Write Enable Register
	output				REG_RE							, // (o) Read Enable register.
	// [Begin] Modify at Ver1.01
//	output	[ 7:0]		REG_AD							, // (o) Register Address
	output	[15:0]		REG_AD							, // (o) Register Address
	// [End] Modify at Ver1.01
	output	[31:0]		REG_WD							, // (o) Register Write Data
	input				REG_RDVLD						, // (i) Register Read Data valid
	input	[31:0]		REG_RD		 					  // (i) Register Read Data
	) ;
	
	// =============================================================================
	// Signal Define
	// =============================================================================
	// [Begin] Modify at Ver1.01
	// [End] Modify at Ver1.01
	
	parameter	C_BIT_CNT			= 12'h364 	; 	// UART 868 clk Receiving 1 Bit
	parameter	C_ASIC_W			= 8'h57 	; 	// W ASIC
	parameter	C_ASIC_R 			= 8'h52 	; 	// R ASIC
	parameter	C_ASIC_SPACE		= 8'h20 	; 	// SPACE ASIC
	parameter	C_ASIC_3E			= 8'h3E 	; 	// ">" ASIC
	parameter	C_ASIC_O			= 8'h4F 	; 	// "O" ASIC
	parameter	C_ASIC_K			= 8'h4B 	; 	// "K" ASIC
	parameter	C_ASIC_F			= 8'h46 	; 	// "F" ASIC
	parameter	C_ASIC_A			= 8'h41 	; 	// "A" ASIC
	parameter	C_ASIC_I			= 8'h49 	; 	// "I" ASIC
	parameter	C_ASIC_L			= 8'h4C 	; 	// "L" ASIC
	parameter	C_ASIC_LF			= 8'h0A 	; 	// Enter LF ASIC
	
	parameter	RX_DATA_IDLE		= 8'h01		,   // Idle
				RX_DATA_SPACE1		= 8'h02		,   // Space1
				RX_DATA_ADDR		= 8'h04		,   // Addr
				RX_DATA_SPACE2		= 8'h08		,   // Space2
				RX_DATA_DATA		= 8'h10		,   // Data
				RX_DATA_CR			= 8'h20		,   // Enter
				RX_DATA_ERROR		= 8'h40		,   // Error
				RX_DATA_END 		= 8'h80		;   // End

	reg		[  7:0]		r_RX_DATA_FSM			;   // 

	parameter	TX_DATA_INIT_SEND	= 7'h01		,   // init send
				TX_DATA_IDLE		= 7'h02		,   // idle
				TX_DATA_OK			= 7'h04		,   // ok
				TX_DATA_FAIL		= 7'h08		,   // error
				TX_DATA_DATA		= 7'h10		,   // tx data
				TX_DATA_CR			= 7'h20		,   // enter
				TX_DATA_END 		= 7'h40		;   // end

	reg		[  6:0]		r_TX_DATA_FSM			;   // 
	
	// RX_DATA
	reg		[  3:0]		r_RX_COMPLETE_CNT			; // UART 8Bit Data Receive Complete Count
	reg					r_WRITE						; // Write Register signal
	reg					r_READ						; // Read Register signal
	wire				s_RX_DATA_IDLE				; // RX Data FSM IDLE Status
	wire				s_RX_DATA_ADDR				; // RX Data FSM ADDR Status
	wire				s_RX_DATA_DATA				; // RX Data FSM DATA Status
	wire				s_RX_DATA_ERROR				; // RX Data FSM ERROR Status
	wire				s_RX_DATA_END				; // RX Data FSM END Status
	wire				s_RX_DATA_CR				; // RX Data FSM Enter Status
	reg					r_CMD_OK					; // UART CMD input ok
	reg					r_CMD_ERR					; // UART CMD input error
	reg					r_FSM_ERROR					; // RX Data FSM if ERROR Status
	reg					r_REG_WE					; // Write Register Enable
	reg					r_REG_WE_1D					; // Write Register Enable Delay 1 Clk
	reg					r_REG_RE					; // Read Register Enable
	wire				s_RX_DATA_VALID				; // RX Data is Valid
	wire				s_RX_ADDR_VALID				; // RX Addr is Valid
	// [Begin] Modify at Ver1.01
	reg		[  7:0]		r_DA_ADDR_D3				; // UART Receive First Addr
	reg		[  7:0]		r_DA_ADDR_D2				; // UART Receive Second Addr
	reg		[  7:0]		r_DA_ADDR_D1				; // UART Receive Third Addr
	reg		[  7:0]		r_DA_ADDR_D0				; // UART Receive fourth Addr
	wire	[  3:0]		s_ADDR_H1					; // Register Addr (15-12)
	wire	[  3:0]		s_ADDR_H2					; // Register Addr (11-8)
	wire	[  3:0]		s_ADDR_L1					; // Register Addr (7-4)
	wire	[  3:0]		s_ADDR_L2					; // Register Addr (3-0)
//	reg		[  7:0]		r_REG_ADDR					; // Register Addr
	reg		[ 15:0]		r_REG_ADDR					; // Register Addr
	// [Begin] Modify at Ver1.01
	reg		[ 31:0]		r_REG_WD					; // Write Register Data
	wire	[  7:0]		s_WR_DATA					; // Write Register Data
	wire	[  3:0]		s_WR_DATA_OUT				; // Write Register Data Decode

	// TX DATA
	reg		[ 31:0]		r_TX_REG_DATA				; // Read Register Data
	wire	[  3:0]		s_TX_DATA					; // Read Register Data
	wire	[  7:0]		s_TX_DT_CNT_SEL				; // Read TX Data Count
	reg		[  7:0] 	r_TX_DATA					; // Read Register Data
	wire	[  7:0]		s_TX_DATA_DECODE			; // Read Register Data
	wire	[  7:0]		s_TX_DATA_OUT				; // Read Register Data Decode
	reg		[  7:0]		r_TX_DATA_CNT				; // TX DATA Count
	reg					r_TX_EN						; // UART TX Data Enable
	reg					r_SEND_OK_REQ				; // Send OK Request
	reg					r_SEND_FAIL_REQ				; // Send FAIL Request
	reg					r_SEND_DATA_REQ				; // Send DATA Request
	reg 				r_DRAM_SEND_DT_EN			; // Send DATA Enable
	reg					r_REG_RE_1D					; // Read Register Enable
	reg					r_REG_RE_2D					; // Read Register Enable
	wire				s_TX_DATA_FSM_INIT_SEND		; // UART TX Data FSM INIT_SEND Status
	wire				s_TX_DATA_FSM_DATA_IDLE		; // UART TX Data FSM IDLE Status
	wire				s_TX_DATA_FSM_TX_DATA_OK	; // UART TX Data FSM OK Status
	wire				s_TX_DATA_FSM_TX_DATA_FAIL	; // UART TX Data FSM FAIL Status
	wire				s_TX_DATA_FSM_TX_DATA_CR	; // UART TX Data FSM ENTER Status
	wire				s_TX_DATA_FSM_TX_DATA		; // UART TX Data FSM DATA Status
	wire				s_TX_DATA_FSM_TX_END		; // UART TX Data FSM END Status
	wire	[  7:0]		s_TD_CNT					; // UART TX DDR Data Count
	reg					r_DDR_REN					; // UART TX 512 bit length
	reg					r_UART_TRAN_BUSY			; // UART 512 bit Data tx status
	reg		[511:0]		r_TX_DDR_DATA0				; // Read DDR Data
	reg		[31:0]		r_TX_DDR_DATA				; // Read DDR Data

	reg		[  7:0]		r_DDR_DATA_CNT ;
	reg					r_IO_DRAM_RD_VLD_TEMP ;

	// =============================================================================
	// RTL
	// =============================================================================
	// =====================================================
	// UART Receive Control
	// =====================================================
	// RX_DATA Main FSM
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET) begin
			r_RX_DATA_FSM <= RX_DATA_IDLE ;
 	 	end else begin
			case ( r_RX_DATA_FSM )
				RX_DATA_IDLE : begin
					if( UART_RX_COMPLETE == 1'b1 ) begin
						if( UART_RX_DATA == C_ASIC_W || UART_RX_DATA == C_ASIC_R ) begin		// RX_DATA is "W" or "R"
							r_RX_DATA_FSM <= RX_DATA_SPACE1 ;
						end else begin
							r_RX_DATA_FSM <= RX_DATA_ERROR ;
						end
					end else begin
						r_RX_DATA_FSM <= RX_DATA_IDLE ;
					end
				end
				RX_DATA_SPACE1 : begin
					if( UART_RX_COMPLETE == 1'b1 ) begin 
						if( UART_RX_DATA == C_ASIC_SPACE ) begin
							r_RX_DATA_FSM <= RX_DATA_ADDR ;
						end else begin															// RX_DATA not SPACE ASIC FSM Back ERROR
							r_RX_DATA_FSM <= RX_DATA_ERROR ;
						end
					end else begin
						r_RX_DATA_FSM <= RX_DATA_SPACE1 ;
					end
				end
				RX_DATA_ADDR : begin
					if( UART_RX_COMPLETE == 1'b1 ) begin
						if( UART_RX_DATA < 8'h30 || ( UART_RX_DATA > 8'h39 && UART_RX_DATA < 8'h41 ) || UART_RX_DATA > 8'h46 ) begin	// RX_DATA not VALID Back IDLE
							r_RX_DATA_FSM <= RX_DATA_ERROR ;
						// [Begin] Modify at Ver1.01
//						end else if( r_RX_COMPLETE_CNT == 4'h1 && r_WRITE == 1'b1 ) begin		//  8 bit RX_ADDR
						end else if( r_RX_COMPLETE_CNT == 4'h3 && r_WRITE == 1'b1 ) begin		// 16 bit RX_ADDR
							r_RX_DATA_FSM <= RX_DATA_SPACE2 ;
//						end else if( r_RX_COMPLETE_CNT == 4'h1 && r_READ == 1'b1 ) begin
						end else if( r_RX_COMPLETE_CNT == 4'h3 && r_READ == 1'b1 ) begin
							r_RX_DATA_FSM <= RX_DATA_CR ;
						end
						// [End] Modify at Ver1.01
					end else begin
						r_RX_DATA_FSM <= RX_DATA_ADDR ;
					end
				end
				RX_DATA_SPACE2 : begin
					if( UART_RX_COMPLETE == 1'b1 ) begin 
						if( UART_RX_DATA == C_ASIC_SPACE ) begin									// RX_DATA="SPACE"
							r_RX_DATA_FSM <= RX_DATA_DATA ;
						end else begin
							r_RX_DATA_FSM <= RX_DATA_ERROR ;
						end
					end else begin
						r_RX_DATA_FSM <= RX_DATA_SPACE2 ;
					end
				end
				RX_DATA_DATA : begin
					if( UART_RX_COMPLETE == 1'b1 ) begin
						if( UART_RX_DATA < 8'h30 || ( UART_RX_DATA > 8'h39 && UART_RX_DATA < 8'h41 ) || UART_RX_DATA > 8'h46 ) begin	// RX_DATA not VALID Back IDLE
							r_RX_DATA_FSM <= RX_DATA_ERROR ;
						end else if( r_RX_COMPLETE_CNT == 4'h7 ) begin
							r_RX_DATA_FSM <= RX_DATA_CR ;
						end
					end else begin
						r_RX_DATA_FSM <= RX_DATA_DATA ;
					end
				end
				RX_DATA_CR : begin
					if( UART_RX_COMPLETE == 1'b1 ) begin
						if( r_RX_COMPLETE_CNT == 4'h0 ) begin
							if( UART_RX_DATA == 8'h0D ) begin
								r_RX_DATA_FSM <= RX_DATA_CR ;
							end else begin
								r_RX_DATA_FSM <= RX_DATA_ERROR ;
							end
						end else if( r_RX_COMPLETE_CNT == 4'h1 ) begin
							if( UART_RX_DATA == C_ASIC_LF ) begin
								r_RX_DATA_FSM <= RX_DATA_END ;
							end else begin
								r_RX_DATA_FSM <= RX_DATA_ERROR ;
							end
						end
					end else begin
						r_RX_DATA_FSM <= RX_DATA_CR ;
					end
				end
				RX_DATA_ERROR : begin
					if( UART_RX_COMPLETE == 1'b1 ) begin
						if( r_RX_COMPLETE_CNT == 4'h1 ) begin
							if( UART_RX_DATA == C_ASIC_LF ) begin
								r_RX_DATA_FSM <= RX_DATA_IDLE ;
							end else begin
								r_RX_DATA_FSM <= RX_DATA_ERROR ;
							end
						end else begin
							r_RX_DATA_FSM <= RX_DATA_ERROR ;
						end
					end else begin
						r_RX_DATA_FSM <= RX_DATA_ERROR ;
					end
				end
				RX_DATA_END	: begin
					r_RX_DATA_FSM <= RX_DATA_IDLE ;
				end
                default :begin
					r_RX_DATA_FSM <= RX_DATA_IDLE ;
				end
			endcase
		end
	end

	// FSM Decoder
	assign s_RX_DATA_IDLE		= ( r_RX_DATA_FSM == RX_DATA_IDLE  	) ? 1'b1 : 1'b0 ;
	assign s_RX_DATA_ADDR		= ( r_RX_DATA_FSM == RX_DATA_ADDR	) ? 1'b1 : 1'b0 ;
	assign s_RX_DATA_DATA		= ( r_RX_DATA_FSM == RX_DATA_DATA	) ? 1'b1 : 1'b0 ;
	assign s_RX_DATA_ERROR		= ( r_RX_DATA_FSM == RX_DATA_ERROR 	) ? 1'b1 : 1'b0 ;
	assign s_RX_DATA_CR			= ( r_RX_DATA_FSM == RX_DATA_CR		) ? 1'b1 : 1'b0 ;
	assign s_RX_DATA_END		= ( r_RX_DATA_FSM == RX_DATA_END	) ? 1'b1 : 1'b0 ;

	// UART Write or Read
	// Write Register Command
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_WRITE <= 1'b0 ;
 	 	end else begin
			if( s_RX_DATA_IDLE == 1'b1 && UART_RX_COMPLETE == 1'b1 && UART_RX_DATA == C_ASIC_W ) begin
				r_WRITE <= 1'b1 ;
			end else if( s_RX_DATA_IDLE == 1'b1 ) begin
				r_WRITE <= 1'b0 ;
			end else begin
				r_WRITE <= r_WRITE ;
			end
		end
	end

	// Read Register Command
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_READ <= 1'b0 ;
 	 	end else begin
			if( s_RX_DATA_IDLE == 1'b1 && UART_RX_COMPLETE == 1'b1 && UART_RX_DATA == C_ASIC_R ) begin
				r_READ <= 1'b1 ;
			end else if( s_RX_DATA_IDLE == 1'b1 ) begin
				r_READ <= 1'b0 ;
			end else begin
				r_READ <= r_READ ;
			end
		end
	end

	// r_CMD_OK Signal for TX_CTRL to seng OK
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_CMD_OK <= 1'b0 ;
 	 	end else begin
			if( s_RX_DATA_END == 1'b1 && r_WRITE == 1'b1 ) begin
				r_CMD_OK <= 1'b1 ;
			end else begin
				r_CMD_OK <= 1'b0 ;
			end
		end
	end

	// r_CMD_ERR Signal for TX_CTRL to send ERR
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_CMD_ERR <= 1'b0 ;
 	 	end else begin
			if( s_RX_DATA_IDLE == 1'b1 && r_FSM_ERROR == 1'b1 ) begin
				r_CMD_ERR <= 1'b1 ;
			end else begin
				r_CMD_ERR <= 1'b0 ;
			end
		end
	end

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_FSM_ERROR <= 1'b0 ;
 	 	end else begin
			if( s_RX_DATA_ERROR == 1'b1 ) begin
				r_FSM_ERROR <= 1'b1 ;
			end else begin
				r_FSM_ERROR <= 1'b0 ;
			end
		end
	end

	// RX DATA COMPLETE_CNT
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_RX_COMPLETE_CNT <= 4'h0 ;
 	 	end else begin
			if( s_RX_DATA_ERROR == 1'b1 ) begin
				if( UART_RX_COMPLETE == 1'b1 ) begin
					if( UART_RX_DATA == 8'h0D ) begin
						r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT + 1'b1 ;
					end else if( UART_RX_DATA == C_ASIC_LF ) begin
						r_RX_COMPLETE_CNT <= 4'h0 ;
					end else begin
						r_RX_COMPLETE_CNT <= 4'h0 ;
					end
				end
			// [Begin] Modify at Ver1.01
//			end else if( s_RX_DATA_ADDR == '1' || s_RX_DATA_CR == 1'b1 ) begin
//				if( UART_RX_COMPLETE == 1'b1 ) begin
//					if( r_RX_COMPLETE_CNT == 4'h1) begin
//						r_RX_COMPLETE_CNT <= 4'h0 ;
//					end else begin
//						r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT + 1'b1 ;
//					end
//				end else begin
//					r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT ;
//				end
			end else if( s_RX_DATA_ADDR == 1'b1 ) begin
				if( UART_RX_COMPLETE == 1'b1 ) begin
					if( r_RX_COMPLETE_CNT == 4'h3) begin
						r_RX_COMPLETE_CNT <= 4'h0 ;
					end else begin
						r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT + 1'b1 ;
					end
				end else begin
					r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT ;
				end
			end else if( s_RX_DATA_CR == 1'b1 ) begin
				if( UART_RX_COMPLETE == 1'b1 ) begin
					if( r_RX_COMPLETE_CNT == 4'h1) begin
						r_RX_COMPLETE_CNT <= 4'h0 ;
					end else begin
						r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT + 1'b1 ;
					end
				end else begin
					r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT ;
				end
			// [End] Modify at Ver1.01
			end else if( s_RX_DATA_DATA == 1'b1 ) begin
				if( UART_RX_COMPLETE == 1'b1 ) begin
					if(r_RX_COMPLETE_CNT == 4'h7) begin
						r_RX_COMPLETE_CNT <= 4'h0 ;
					end else begin
						r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT + 1'b1 ;
					end
				end else begin
					r_RX_COMPLETE_CNT <= r_RX_COMPLETE_CNT ;
				end
			end
		end
	end

	// Write Register Enable
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_REG_WE <= 1'b0 ;
 	 	end else begin
			if( s_RX_DATA_END == 1'b1 && r_WRITE == 1'b1 ) begin
				r_REG_WE <= 1'b1 ;
			end else begin
				r_REG_WE <= 1'b0 ;
			end
		end
	end

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_REG_WE_1D <= 1'b0 ;
 	 	end else begin
			r_REG_WE_1D <= r_REG_WE ;
		end
	end

	// Read Register Enable
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_REG_RE <= 1'b0 ;
 	 	end else begin
			if( s_RX_DATA_END == 1'b1 && r_READ == 1'b1 ) begin
				r_REG_RE <= 1'b1 ;
			end else begin
				r_REG_RE <= 1'b0 ;
			end
		end
	end

	assign REG_WE = r_REG_WE_1D ;
	assign REG_RE = r_REG_RE_1D ;

	// 8Bit Addr and Data is Valid
	assign s_RX_DATA_VALID = ( s_RX_DATA_DATA == 1'b1 &&  ( ( UART_RX_DATA >= 8'h30 && UART_RX_DATA <= 8'h39 ) || ( UART_RX_DATA >= 8'h41 && UART_RX_DATA <= 8'h46 ) ) ) ? 1'b1 : 1'b0 ;
	assign s_RX_ADDR_VALID = ( s_RX_DATA_ADDR == 1'b1 &&  ( ( UART_RX_DATA >= 8'h30 && UART_RX_DATA <= 8'h39 ) || ( UART_RX_DATA >= 8'h41 && UART_RX_DATA <= 8'h46 ) ) ) ? 1'b1 : 1'b0 ;

	// [Begin] Modify at Ver1.01
	// 8Bit Addr Receive to Register
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_DA_ADDR_D3 <=8'h00 ;
 	 	end else begin
			if( s_RX_DATA_ADDR == 1'b1 ) begin
				if( r_RX_COMPLETE_CNT == 4'h0 && s_RX_ADDR_VALID == 1'b1 ) begin
					r_DA_ADDR_D3 <= UART_RX_DATA - 8'h30 ;
				end else begin
					r_DA_ADDR_D3 <= r_DA_ADDR_D3 ;
				end
			end
		end
	end

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_DA_ADDR_D2 <= 8'h00 ;
 	 	end else begin
			if( s_RX_DATA_ADDR == 1'b1 ) begin
				if( r_RX_COMPLETE_CNT == 4'h1 && s_RX_ADDR_VALID == 1'b1 ) begin
					r_DA_ADDR_D2 <= UART_RX_DATA - 8'h30 ;
				end else begin
					r_DA_ADDR_D2 <= r_DA_ADDR_D2 ;
				end
			end
		end
	end

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_DA_ADDR_D1 <=8'h00 ;
 	 	end else begin
			if( s_RX_DATA_ADDR == 1'b1 ) begin
				if( r_RX_COMPLETE_CNT == 4'h2 && s_RX_ADDR_VALID == 1'b1 ) begin
					r_DA_ADDR_D1 <= UART_RX_DATA - 8'h30 ;
				end else begin
					r_DA_ADDR_D1 <= r_DA_ADDR_D1 ;
				end
			end
		end
	end

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_DA_ADDR_D0 <= 8'h00 ;
 	 	end else begin
			if( s_RX_DATA_ADDR == 1'b1 ) begin
				if( r_RX_COMPLETE_CNT == 4'h3 && s_RX_ADDR_VALID == 1'b1 ) begin
					r_DA_ADDR_D0 <= UART_RX_DATA - 8'h30 ;
				end else begin
					r_DA_ADDR_D0 <= r_DA_ADDR_D0 ;
				end
			end
		end
	end

 	assign s_ADDR_H1 = 	( r_DA_ADDR_D3 == 8'h16 ) ? 4'hF :
				   		( r_DA_ADDR_D3 == 8'h15 ) ? 4'hE :
				   		( r_DA_ADDR_D3 == 8'h14 ) ? 4'hD :
				   		( r_DA_ADDR_D3 == 8'h13 ) ? 4'hC :
				   		( r_DA_ADDR_D3 == 8'h12 ) ? 4'hB :
				   		( r_DA_ADDR_D3 == 8'h11 ) ? 4'hA :
				   		r_DA_ADDR_D3[3:0] ;

 	assign s_ADDR_H2 = 	( r_DA_ADDR_D2 == 8'h16 ) ? 4'hF :
				   		( r_DA_ADDR_D2 == 8'h15 ) ? 4'hE :
				   		( r_DA_ADDR_D2 == 8'h14 ) ? 4'hD :
				   		( r_DA_ADDR_D2 == 8'h13 ) ? 4'hC :
				   		( r_DA_ADDR_D2 == 8'h12 ) ? 4'hB :
				   		( r_DA_ADDR_D2 == 8'h11 ) ? 4'hA :
				   		r_DA_ADDR_D2[3:0] ;

	assign s_ADDR_L1 = 	( r_DA_ADDR_D1 == 8'h16 ) ? 4'hF :
						( r_DA_ADDR_D1 == 8'h15 ) ? 4'hE :
						( r_DA_ADDR_D1 == 8'h14 ) ? 4'hD :
						( r_DA_ADDR_D1 == 8'h13 ) ? 4'hC :
						( r_DA_ADDR_D1 == 8'h12 ) ? 4'hB :
						( r_DA_ADDR_D1 == 8'h11 ) ? 4'hA :
						r_DA_ADDR_D1[3:0] ;

	assign s_ADDR_L2 = 	( r_DA_ADDR_D0 == 8'h16 ) ? 4'hF :
						( r_DA_ADDR_D0 == 8'h15 ) ? 4'hE :
						( r_DA_ADDR_D0 == 8'h14 ) ? 4'hD :
						( r_DA_ADDR_D0 == 8'h13 ) ? 4'hC :
						( r_DA_ADDR_D0 == 8'h12 ) ? 4'hB :
						( r_DA_ADDR_D0 == 8'h11 ) ? 4'hA :
						r_DA_ADDR_D0[3:0] ;

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_REG_ADDR <= {16{1'b0}} ;
 	 	end else begin
			if( r_REG_WE == 1'b1 ) begin
				r_REG_ADDR <= { s_ADDR_H1 , s_ADDR_H2 , s_ADDR_L1 , s_ADDR_L2 } ;
			end else if( r_REG_RE == 1'b1 ) begin
				r_REG_ADDR <= { s_ADDR_H1 , s_ADDR_H2 , s_ADDR_L1 , s_ADDR_L2 } ;
			end
		end
	end
	// [End] Modify at Ver1.01

	// 8Bit DATA Receive to Register

	assign s_WR_DATA =	( s_RX_DATA_DATA == 1'b1 && UART_RX_COMPLETE == 1'b1 && s_RX_DATA_VALID == 1'b1 ) ? ( UART_RX_DATA - 8'h30 ) : 8'h00 ;

	assign s_WR_DATA_OUT = 	( s_WR_DATA == 8'h16 ) ? 4'hF :
				   			( s_WR_DATA == 8'h15 ) ? 4'hE :
				   			( s_WR_DATA == 8'h14 ) ? 4'hD :
				   			( s_WR_DATA == 8'h13 ) ? 4'hC :
				   			( s_WR_DATA == 8'h12 ) ? 4'hB :
				   			( s_WR_DATA == 8'h11 ) ? 4'hA :
				   			s_WR_DATA[3:0] ;

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_REG_WD <= {32{1'b0}} ;
 	 	end else begin
			if( s_RX_DATA_DATA == 1'b1 && UART_RX_COMPLETE == 1'b1 && s_RX_DATA_VALID == 1'b1 ) begin
				r_REG_WD <= { r_REG_WD[27:0] , s_WR_DATA_OUT } ;
			end else begin
				r_REG_WD <= r_REG_WD ;
			end
		end
	end

	assign REG_AD	= r_REG_ADDR ;
	assign REG_WD	= ( r_REG_WE_1D == 1'b1 ) ? r_REG_WD : {32{1'b0}} ;

	// =====================================================
	// UART Transmit Control
	// =====================================================
	// TX DATA Main FSM
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TX_DATA_FSM <= TX_DATA_INIT_SEND ;
 	 	end else begin
			case ( r_TX_DATA_FSM )
				TX_DATA_INIT_SEND : begin
					if( UART_TX_COMPLETE == 1'b1 ) begin
						r_TX_DATA_FSM <= TX_DATA_IDLE ;
					end else begin
						r_TX_DATA_FSM <= TX_DATA_INIT_SEND ;
					end
				end
				TX_DATA_IDLE : begin
					if( r_SEND_OK_REQ == 1'b1 ) begin
						r_TX_DATA_FSM <= TX_DATA_OK ;
					end else if( r_SEND_FAIL_REQ == 1'b1 ) begin
						r_TX_DATA_FSM <= TX_DATA_FAIL ;
					end else if( r_SEND_DATA_REQ == 1'b1 ) begin
						r_TX_DATA_FSM <= TX_DATA_DATA ;
					end else begin
						r_TX_DATA_FSM <= TX_DATA_IDLE ;
					end
				end
				TX_DATA_OK : begin
					if( UART_TX_COMPLETE == 1'b1 && r_TX_DATA_CNT == 8'h01 ) begin
						r_TX_DATA_FSM <= TX_DATA_CR ;
					end else begin
						r_TX_DATA_FSM <= TX_DATA_OK ;
					end
				end
				TX_DATA_FAIL : begin
					if( UART_TX_COMPLETE == 1'b1 && r_TX_DATA_CNT == 8'h03 ) begin
						r_TX_DATA_FSM <= TX_DATA_CR ;
					end else begin
						r_TX_DATA_FSM <= TX_DATA_FAIL ;
					end
				end
				TX_DATA_DATA : begin
					if( UART_TX_COMPLETE == 1'b1 && r_TX_DATA_CNT == s_TD_CNT ) begin
						r_TX_DATA_FSM <= TX_DATA_CR ;
					end else begin
						r_TX_DATA_FSM <= TX_DATA_DATA ;
					end
				end
				TX_DATA_CR : begin
					if( UART_TX_COMPLETE == 1'b1 && r_TX_DATA_CNT == 8'h01 ) begin				// Wait "CR" Send End
						r_TX_DATA_FSM <= TX_DATA_END ;
					end else begin
						r_TX_DATA_FSM <= TX_DATA_CR ;
					end
				end
				TX_DATA_END : begin
					if( UART_TX_COMPLETE == 1'b1 ) begin
						r_TX_DATA_FSM <= TX_DATA_IDLE ;
					end else begin
						r_TX_DATA_FSM <= TX_DATA_END ;
					end
				end
				default : begin  	
					r_TX_DATA_FSM <= TX_DATA_IDLE ;
				end
			endcase
		end
	end

	// FSM Decode    
	assign s_TX_DATA_FSM_INIT_SEND 		= ( r_TX_DATA_FSM == TX_DATA_INIT_SEND	) ? 1'b1 : 1'b0 ;
	assign s_TX_DATA_FSM_DATA_IDLE		= ( r_TX_DATA_FSM == TX_DATA_IDLE		) ? 1'b1 : 1'b0 ;
	assign s_TX_DATA_FSM_TX_DATA_OK		= ( r_TX_DATA_FSM == TX_DATA_OK			) ? 1'b1 : 1'b0 ;
	assign s_TX_DATA_FSM_TX_DATA_FAIL	= ( r_TX_DATA_FSM == TX_DATA_FAIL		) ? 1'b1 : 1'b0 ;
	assign s_TX_DATA_FSM_TX_DATA_CR		= ( r_TX_DATA_FSM == TX_DATA_CR			) ? 1'b1 : 1'b0 ;
	assign s_TX_DATA_FSM_TX_DATA		= ( r_TX_DATA_FSM == TX_DATA_DATA		) ? 1'b1 : 1'b0 ;
	assign s_TX_DATA_FSM_TX_END			= ( r_TX_DATA_FSM == TX_DATA_END 		) ? 1'b1 : 1'b0 ;

	// Send "CMD_OK" Request
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_SEND_OK_REQ <= 1'b0 ;
 	 	end else begin
			if( r_CMD_OK == 1'b1 ) begin							// tx "OK" Enable
				r_SEND_OK_REQ <= 1'b1 ;
			end else if( s_TX_DATA_FSM_DATA_IDLE == 1'b1 && r_SEND_OK_REQ == 1'b1 ) begin
				r_SEND_OK_REQ <= 1'b0 ;
			end
		end
	end

	// Send "FAIL" Request
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_SEND_FAIL_REQ <= 1'b0 ;
 	 	end else begin
			if( r_CMD_ERR == 1'b1 ) begin							// tx "FAIL" Enable
				r_SEND_FAIL_REQ <= 1'b1 ;
			end else if( s_TX_DATA_FSM_DATA_IDLE == 1'b1 && r_SEND_FAIL_REQ == 1'b1 ) begin
				r_SEND_FAIL_REQ <= 1'b0 ;
			end
		end
	end

	// DDR3 Read Data
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_DDR_REN <= 1'b0 ;
 	 	end else begin
			if( IO_DRAM_RD_VLD == 1'b1  || r_IO_DRAM_RD_VLD_TEMP) begin		// IO_DRAM_RD_VLD UART Read DDR Start
				r_DDR_REN <= 1'b1 ;
			end else if( s_TX_DATA_FSM_TX_DATA_CR == 1'b1 && 
					r_DRAM_SEND_DT_EN == 1'b1 ) begin				// 512 bit Data tx end
				r_DDR_REN <= 1'b0 ;
			end
		end
	end

	// 512 bit Data tx status
//	assign s_TD_CNT = (r_DDR_REN == 1'b1) ? 8'h7F : 8'h07 ;
	assign s_TD_CNT = (r_DDR_REN == 1'b1) ? 8'h07 : 8'h07 ;

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_UART_TRAN_BUSY <= 1'b0 ;
 	 	end else begin
			if( IO_DRAM_RD_VLD == 1'b1 || r_IO_DRAM_RD_VLD_TEMP) begin						// UART tx DDR status
				r_UART_TRAN_BUSY <= 1'b1 ;
			end else if( 	s_TX_DATA_FSM_TX_END == 1'b1 && 		// UART 512bit Trans End
					UART_TX_COMPLETE == 1'b1 && 
					r_DRAM_SEND_DT_EN == 1'b1 ) begin
				r_UART_TRAN_BUSY <= 1'b0 ;
			end
		end
	end

	assign UART_TRAN_BUSY	= r_UART_TRAN_BUSY | r_IO_DRAM_RD_VLD_TEMP;

	// Send Data Request
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_REG_RE_1D <= 1'b0 ;
			r_REG_RE_2D <= 1'b0 ;
 	 	end else begin
			r_REG_RE_1D <= r_REG_RE ;
            r_REG_RE_2D <= r_REG_RE_1D ;
		end
	end

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_SEND_DATA_REQ <= 1'b0 ;
 	 	end else begin
//			if( r_REG_RE_2D == 1'b1 || IO_DRAM_RD_VLD == 1'b1 ) begin	// tx Data Enable
			if( REG_RDVLD == 1'b1 || IO_DRAM_RD_VLD == 1'b1 || r_IO_DRAM_RD_VLD_TEMP) begin	// tx Data Enable
				r_SEND_DATA_REQ <= 1'b1 ;
			end else if( s_TX_DATA_FSM_DATA_IDLE == 1'b1 && r_SEND_DATA_REQ == 1'b1 ) begin
				r_SEND_DATA_REQ <= 1'b0 ;
			end
		end
	end

	// DRAM Data Sent Enable
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_DRAM_SEND_DT_EN <= 1'b0 ;
 	 	end else begin
			if( s_TX_DATA_FSM_DATA_IDLE == 1'b1 && r_SEND_DATA_REQ == 1'b1 ) begin
				r_DRAM_SEND_DT_EN <= 1'b1 ;
			end else if( s_TX_DATA_FSM_TX_END == 1'b1 && UART_TX_COMPLETE == 1'b1 ) begin
				r_DRAM_SEND_DT_EN <= 1'b0 ;
			end
		end
	end

	// TX DATA Main FSM
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TX_DATA <= 8'h00 ;
			r_TX_EN	  <= 1'b0 ;
 	 	end else begin
			case ( r_TX_DATA_FSM )
				TX_DATA_INIT_SEND : begin
					r_TX_DATA <= C_ASIC_3E ;
					if( r_TX_DATA == C_ASIC_3E ) begin
						r_TX_EN <= 1'b0 ;
					end else begin
						r_TX_EN <= 1'b1 ;
					end
				end
				TX_DATA_IDLE : begin
					if( r_SEND_OK_REQ == 1'b1 ) begin
						r_TX_DATA	<= C_ASIC_O ;
						r_TX_EN 	<= 1'b1 ;
					end else if( r_SEND_FAIL_REQ == 1'b1 ) begin
						r_TX_DATA 	<= C_ASIC_F ;
						r_TX_EN 	<= 1'b1 ;
					end else if( r_SEND_DATA_REQ == 1'b1 ) begin
						r_TX_DATA 	<= s_TX_DATA_OUT ;
						r_TX_EN 	<= 1'b1 ;
					end else begin
						r_TX_DATA 	<= r_TX_DATA ;
						r_TX_EN 	<= 1'b0 ;
					end
				end
				TX_DATA_OK : begin
					if( UART_TX_COMPLETE == 1'b1 ) begin
						if( r_TX_DATA_CNT == 8'h00 ) begin
							r_TX_DATA 	<= C_ASIC_K ;
							r_TX_EN 	<= 1'b1 ;
						end else if( r_TX_DATA_CNT == 8'h01 ) begin
							r_TX_DATA 	<= 8'h0D ;
							r_TX_EN 	<= 1'b1 ;
						end else begin
							r_TX_DATA 	<= r_TX_DATA ;
                            r_TX_EN 	<= 1'b0 ;
						end
					end else begin
						r_TX_DATA 	<= r_TX_DATA ;
                        r_TX_EN 	<= 1'b0 ;
					end
				end
				TX_DATA_FAIL : begin
					if( UART_TX_COMPLETE == 1'b1 ) begin
						if( r_TX_DATA_CNT == 8'h00 ) begin
							r_TX_DATA 	<= C_ASIC_A ;
							r_TX_EN 	<= 1'b1 ;
						end else if( r_TX_DATA_CNT == 8'h01 ) begin
							r_TX_DATA 	<= C_ASIC_I ;
                            r_TX_EN 	<= 1'b1 ;
						end else if( r_TX_DATA_CNT == 8'h02 ) begin
							r_TX_DATA 	<= C_ASIC_L ;
                            r_TX_EN 	<= 1'b1 ;
						end else if( r_TX_DATA_CNT == 8'h03 ) begin
							r_TX_DATA 	<= 8'h0D;
                            r_TX_EN 	<= 1'b1 ;
						end else begin
							r_TX_DATA 	<= r_TX_DATA ;
                            r_TX_EN 	<= 1'b0 ;
						end
					end else begin
						r_TX_DATA 	<= r_TX_DATA ;
                        r_TX_EN 	<= 1'b0 ;
					end
				end
				TX_DATA_DATA : begin
					if( UART_TX_COMPLETE == 1'b1 ) begin
						r_TX_DATA 	<= s_TX_DATA_OUT ;
						r_TX_EN 	<= 1'b1 ;
						if( r_TX_DATA_CNT ==  s_TD_CNT ) begin
							r_TX_DATA 	<= 8'h0D;
                        	r_TX_EN 	<= 1'b1 ;
						end
					end else begin
						r_TX_DATA 	<= r_TX_DATA ;
                        r_TX_EN 	<= 1'b0 ;
					end
				end
				TX_DATA_CR : begin
					if( UART_TX_COMPLETE == 1'b1 ) begin
						if( r_TX_DATA_CNT == 8'h00 ) begin
							r_TX_DATA	<= C_ASIC_LF ;
							r_TX_EN 	<= 1'b1 ;
						end else if( r_TX_DATA_CNT == 8'h01 ) begin
							r_TX_DATA 	<= C_ASIC_3E ;
                            r_TX_EN 	<= 1'b1 ;
						end else begin
							r_TX_DATA 	<= r_TX_DATA ;
                            r_TX_EN 	<= 1'b0 ;
						end
					end else begin
						r_TX_DATA 	<= r_TX_DATA ;
                        r_TX_EN 	<= 1'b0 ;
					end
				end
                default :begin
  		 	      	r_TX_DATA 	<= r_TX_DATA;
					r_TX_EN		<= 1'b0 ;
				end
			endcase
		end
	end

	assign UART_TX_DATA	= r_TX_DATA ;
	assign UART_TX_EN	= r_TX_EN ;

 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TX_REG_DATA <= {32{1'b0}} ;
 	 	end else begin
			if( s_TX_DATA_FSM_DATA_IDLE == 1'b1 && r_SEND_DATA_REQ == 1'b0 ) begin
				r_TX_REG_DATA <= REG_RD ;
			end else if( ( s_TX_DATA_FSM_TX_DATA == 1'b1 && UART_TX_COMPLETE == 1'b1 ) || r_SEND_DATA_REQ == 1'b1  ) begin
				r_TX_REG_DATA <= { r_TX_REG_DATA[27:0],4'h0} ;
			end
		end
	end



	// DDR_DATA_CNT
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_DDR_DATA_CNT <= 8'h00 ;
 	 	end else begin
			if( IO_DRAM_RD_VLD == 1'b1 ) begin																		// Latch The 512 bit Data
				r_DDR_DATA_CNT <= 8'h10 ;
			end else if( s_TX_DATA_FSM_TX_END == 1'b1 && UART_TX_COMPLETE == 1'b1 && r_DDR_DATA_CNT != 0) begin
				r_DDR_DATA_CNT <= r_DDR_DATA_CNT - 1 ;
			end
		end
	end
	// 
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_IO_DRAM_RD_VLD_TEMP <= 1'b0 ;
 	 	end else begin
			if( s_TX_DATA_FSM_TX_END == 1'b1 && UART_TX_COMPLETE == 1'b1 && r_DDR_DATA_CNT[7:1] != 0) begin
				r_IO_DRAM_RD_VLD_TEMP <= 1'b1 ;
			end else begin
				r_IO_DRAM_RD_VLD_TEMP <= 1'b0 ;
			end
		end
	end

	// Read DDR
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TX_DDR_DATA0 <= {512{1'b0}} ;
			r_TX_DDR_DATA  <= {32{1'b0}} ;
 	 	end else begin
			if( IO_DRAM_RD_VLD == 1'b1 ) begin																		// Latch The 512 bit Data
				r_TX_DDR_DATA0 <= IO_DRAM_RDATA ;
			end else if( s_TX_DATA_FSM_TX_END == 1'b1 && UART_TX_COMPLETE == 1'b1 && r_DDR_DATA_CNT[7:1] != 0) begin
				r_TX_DDR_DATA0 <= {r_TX_DDR_DATA0[479:0],32'b0} ;
			end

			if( IO_DRAM_RD_VLD == 1'b1) begin																		// Latch The 512 bit Data
				r_TX_DDR_DATA  <= IO_DRAM_RDATA[511:480] ;
			end else if( r_IO_DRAM_RD_VLD_TEMP) begin																		// Latch The 512 bit Data
				r_TX_DDR_DATA  <= r_TX_DDR_DATA0[511:480] ;
			end else if ((s_TX_DATA_FSM_DATA_IDLE == 1'b1 && r_SEND_DATA_REQ == 1'b1 ) || 							// 1st Data Shift
					(s_TX_DATA_FSM_TX_DATA == 1'b1 && UART_TX_COMPLETE == 1'b1 && r_DRAM_SEND_DT_EN == 1'b1)) begin	// 2nd Data Shift
				r_TX_DDR_DATA <= {r_TX_DDR_DATA[27:0],4'h0} ;
			end
		end
	end

	assign s_TX_DATA = ( r_DDR_REN == 1'b1 ) ? r_TX_DDR_DATA[31:28] : r_TX_REG_DATA[31:28] ;

	// TX DATA Decode
	assign s_TX_DATA_DECODE	=	( s_TX_DATA == 4'hF ) ? 8'h16 :
				 				( s_TX_DATA == 4'hE ) ? 8'h15 :
				 				( s_TX_DATA == 4'hD ) ? 8'h14 :
				 				( s_TX_DATA == 4'hC ) ? 8'h13 :
				 				( s_TX_DATA == 4'hB ) ? 8'h12 :
				 				( s_TX_DATA == 4'hA ) ? 8'h11 :
								{ 4'h0 , s_TX_DATA} ;

	assign s_TX_DATA_OUT = s_TX_DATA_DECODE + 8'h30 ;

	// TX_DATA_CNT
 	always @( posedge CLK_100M or posedge IO_RESET ) begin
		if( IO_RESET ) begin
			r_TX_DATA_CNT <= 8'h00 ;
 	 	end else begin
			if ( s_TX_DATA_FSM_DATA_IDLE == 1'b0 ) begin
				if( UART_TX_COMPLETE == 1'b1 ) begin
					if( r_TX_DATA_CNT == s_TX_DT_CNT_SEL ) begin
						r_TX_DATA_CNT <= 8'h00 ;
					end else begin
						r_TX_DATA_CNT <= r_TX_DATA_CNT + 1'b1 ;
					end
				end else begin
					r_TX_DATA_CNT <= r_TX_DATA_CNT ;
				end
			end else begin
				r_TX_DATA_CNT <= 8'h00 ;
			end
		end
	end

	assign s_TX_DT_CNT_SEL = ( s_TX_DATA_FSM_INIT_SEND  == 1'b1 || s_TX_DATA_FSM_TX_DATA_OK == 1'b1 || s_TX_DATA_FSM_TX_DATA_CR == 1'b1 ) ? 8'h01 :
					   		 ( s_TX_DATA_FSM_TX_DATA_FAIL == 1'b1 ) ? 8'h03 :
					   		 ( s_TX_DATA_FSM_TX_DATA == 1'b1 ) ? s_TD_CNT : 8'h00 ;

endmodule

