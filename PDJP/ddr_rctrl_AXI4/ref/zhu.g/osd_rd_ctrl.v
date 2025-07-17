// =================================================================================================

// =================================================================================================
// File Name	  : osd_rd_ctrl.v
// Module		  : osd_rd_ctrl
// Function 	  : OSD Data DDR3 Read Control
// Type 		  : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date		   Coded by 		Contents
// 0.0.1	  2013/12/17   TEDWX)zhu.g		create new
//
// =================================================================================================
// End Revision
// =================================================================================================

// =============================================================================
// Timescale Define
// =============================================================================
`timescale 1ns / 1ps


module osd_rd_ctrl #(
	parameter 				P_SIM				= 1'b0 ,
	parameter 				P_DEVICE_ID			= 4'h0
	)(
	// Reset
	input	wire			XRST				, // (i) Async. Reset (Low Active)
	input	wire			CLK_MIG0_UI			, // (i) OSD Mig ui_clk
	input	wire			CLK_VX1				, // (i) V-By-One User CLk(74.25MHz)


	// Register
	input	wire			OSD_DISP_EN			, // (i) Dispaly Enable

	// blackfin_decode
	input	wire			OSD_CMD_CTRL_EN		, // (i) OSD Control Command Enable
	input	wire	[ 4:0]	OSD_CMD_PEND_BUF	, // (i) OSD Pending Buffer
	input	wire			OSD_CMD_CTRL_SCALE	, // (i) OSD Control Command Scaler Enable

	// V-By-One Timing Generator
	input	wire			VX1_VSYNC			, // (i) V-By-One VSync
	input	wire			VX1_VSYNC_FE_MIG0	, // (i) V-By-One VSync Fall Edge(MIG0_UI Clock)

	// Master Interface Read Address Ports
	output	wire	[ 3:0]	OSD_AXIM_ARID		, // (o) Read address ID
	output	wire	[31:0]	OSD_AXIM_ARADDR		, // (o) Read address
	output	wire	[ 7:0]	OSD_AXIM_ARLEN		, // (o) Burst length
	output	wire	[ 2:0]	OSD_AXIM_ARSIZE		, // (o) Burst size
	output	wire	[ 1:0]	OSD_AXIM_ARBURST	, // (o) Burst type
	output	wire			OSD_AXIM_ARLOCK		, // (o) Lock type
	output	wire	[ 3:0]	OSD_AXIM_ARCACHE	, // (o) Cache type
	output	wire	[ 2:0]	OSD_AXIM_ARPROT		, // (o) Protection type
	output	wire	[ 3:0]	OSD_AXIM_ARQOS		, // (o) QoS identifier
	output	wire			OSD_AXIM_ARVALID	, // (o) Read address valid
	input	wire			OSD_AXIM_ARREADY	, // (i) Read address ready
	// Master Interface Read Data Ports
	output	wire			OSD_AXIM_RREADY		, // (o) Read ready
	input	wire	[ 3:0]	OSD_AXIM_RID		, // (i) Read ID tag
	input	wire	[63:0]	OSD_AXIM_RDATA		, // (i) Read data
	input	wire	[ 1:0]	OSD_AXIM_RRESP		, // (i) Read response
	input	wire			OSD_AXIM_RLAST		, // (i) Read last
	input	wire			OSD_AXIM_RVALID		, // (i) Read valid

	// OSD Buffer Output
	input	wire			OSD_BUF_REN			, // (i) OSD Buffer Read Enable
	input	wire			OSD_BUF_RD_CMP		, // (i) OSD Buffer Read Line End
	input	wire			OSD_BUF_RD_REW		, // (i) OSD Buffer Read Line Rewind
	output	wire			OSD_BUF_ST			, // (o) OSD Buffer Status(1:Have Data 0:NO Data)
	output	wire	[127:0]	OSD_BUF_RDT			, // (o) OSD Buffer Read Data
	output	wire			OSD_BUF_RVLD		  // (o) OSD Buffer Read Data Valid

) ;

// =============================================================================
// Signal Define
// =============================================================================
	parameter   P_AXIM_DWIDTH	    = 8'h08     		; // 8Byte
	parameter   P_AXIM_DLEN	    	= P_SIM ? 8'd15		: 8'd239     	; // 240 x 8B(1920B) - 1
	parameter   P_FRM_END_ADD	    = P_SIM ? 22'h00F00	: 22'h1FA400    ; // 1920*1080
	parameter   P_TXBUF_SFT_CNT_SCL = P_SIM ? 6'd1	 	: 6'd29     	; // 30-1
	parameter   P_TXBUF_SFT_CNT_CEN = P_SIM ? 6'd3	 	: 6'd59     	; // 60-1


	parameter   P_AXIM_RD_IDLE	    = 6'h01     	; // Idle
	parameter   P_AXIM_RD_AINF    	= 6'h02     	; // Write Address And Information
	parameter   P_AXIM_RD_AVLD    	= 6'h04     	; // Write Address Valid
	parameter   P_AXIM_RD_WAIT    	= 6'h08     	; // Write Data Prepare
	parameter   P_AXIM_RD_DATA    	= 6'h10     	; // Write Data 
	parameter   P_AXIM_RD_END    	= 6'h20     	; // Write Last Data 

	//      OSD Read Enable
	reg		[ 2:0] 		r_OSD_DISP_EN_MIG0			; // SYNC. Of OSD_DISP_EN
	reg					r_OSD_DISP_EN				; // OSD Read Enable

	//      AXI Master State Machine
	reg		[ 5:0] 		r_AXIM_RD_FSM				; // AXI Master State Machine
	wire				s_FSM_AXIM_RD_AINF			; // Decoder Of FSM
	wire				s_FSM_AXIM_RD_AVLD			; // Decoder Of FSM
	wire				s_FSM_AXIM_RD_DATA			; // Decoder Of FSM
	wire				s_FSM_AXIM_RD_END 			; // Decoder Of FSM
	reg		[ 4:0] 		r_WAIT_CNT					; // Wait Counter
	wire				s_WAIT_CNT_EXPIRE 			; // Wait Counter Expire
	wire				s_AXIM_1LINE_RD_END			; // OSD 1Line Read End
	reg					r_AXIM_1LINE_RD_END			; // OSD 1Line Read End
	reg		[ 4:0] 		r_OSD_CMD_PEND_BUF			; // OSD_CMD_PEND_BUF Latch
	reg		[27:0] 		r_AXIM_RD_ADDR				; // OSD Read Address Control

	//      OSD Buffer Write Control
	reg					r_OSD_TXBUF_WEN				; // Write Enable
	reg		[63:0] 		r_OSD_TXBUF_DIN				; // Write Data
	reg					r_OSD_TXBUF_1LINE_WEND		; // 1Line Write End
	reg		[ 8:0] 		r_OSD_TXBUF_WADDR			; // Write Address

	//      OSD Buffer Read Control
	reg		[ 2:0] 		r_VX1_VSYNC					; // Falling Edge Of VX1_VSYNC
	wire				s_VX1_VSYNC_FE	 			; // Falling Edge Of VX1_VSYNC
	reg					r_VX1_VSYNC_FE	 			; // Falling Edge Of VX1_VSYNC
	reg		[ 2:0] 		r_OSD_DISP_EN_VX1			; // SYNC. Of OSD_DISP_EN
	wire				s_OSD_TXBUF_REN	 			; // Buffer Read Enable
	reg		[ 7:0] 		r_OSD_TXBUF_RADDR			; // Read Address
	reg					r_OSD_TXBUF_RVLD			; // Read Data Valid
	wire	[127:0] 	s_OSD_TXBUF_DOUT			; // Read Data

	//     OSD Buffer Status
	wire				s_OSD_TXBUF_1LINE_WEND_VX1	; // Sync. Of r_OSD_TXBUF_1LINE_WEND
	reg		[ 1:0] 		r_OSD_TXBUF_CNT				; // Buffer Status
	wire				s_OSD_TXBUF_EMPTY			; // OSD Buffer Empty
	wire				s_OSD_TXBUF_FULL			; // OSD Buffer Full
	reg		[ 2:0] 		r_OSD_TXBUF_FULL_MIG0		; // Buffer Of s_OSD_TXBUF_FULL

// =============================================================================
// RTL
// =============================================================================

	//-----------------------------------------------
	//      OSD Read Enable
	//-----------------------------------------------
	// SYNC. Of OSD_DISP_EN
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_DISP_EN_MIG0 <= {3{1'b0}} ;
		end else begin
			r_OSD_DISP_EN_MIG0 <= {r_OSD_DISP_EN_MIG0[1:0],OSD_DISP_EN} ;
		end
	end

	// OSD Read Enable
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_DISP_EN <= 1'b0 ;
		end else begin
			if (!r_OSD_DISP_EN_MIG0[2]) begin											// Dispaly OFF
				r_OSD_DISP_EN <= 1'b0 ;
			end else if (r_AXIM_1LINE_RD_END && r_AXIM_RD_ADDR == P_FRM_END_ADD ) begin	// 1 Frame End
				r_OSD_DISP_EN <= 1'b0 ;
			end else if (VX1_VSYNC_FE_MIG0) begin										// VSYNC
				r_OSD_DISP_EN <= 1'b1 ;
			end
		end
	end

	//-----------------------------------------------
	//      AXI Master State Machine(Read)
	//-----------------------------------------------
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_AXIM_RD_FSM <= P_AXIM_RD_IDLE ;
		end else begin
			case (r_AXIM_RD_FSM) 
				P_AXIM_RD_IDLE : 			// IDLE
					begin
						if (r_OSD_DISP_EN && 					// Display Enable
							!r_OSD_TXBUF_FULL_MIG0[2]) begin		// OSD Buffer Not Full
							r_AXIM_RD_FSM <= P_AXIM_RD_AINF ;
						end
					end

				P_AXIM_RD_AINF : 			// Read Address And Information
					begin
							r_AXIM_RD_FSM <= P_AXIM_RD_AVLD ;
					end

				P_AXIM_RD_AVLD : 			// Read Address Valid
					begin
						if (OSD_AXIM_ARREADY) begin				// Read Address Ready
							r_AXIM_RD_FSM <= P_AXIM_RD_WAIT ;
						end
					end

				P_AXIM_RD_WAIT : 			// Read Data Wait
					begin
						if (OSD_AXIM_RVALID) begin 				// Data Receive
							r_AXIM_RD_FSM <= P_AXIM_RD_DATA ;
						end
					end

				P_AXIM_RD_DATA : 			// Read Data 
					begin
						if (OSD_AXIM_RLAST) begin 				// Last Data Receive
							r_AXIM_RD_FSM <= P_AXIM_RD_END ;
						end
					end

				P_AXIM_RD_END : 			// Read Data End
					begin
						if (s_WAIT_CNT_EXPIRE) begin 			// Wait Counter Exipire
							r_AXIM_RD_FSM <= P_AXIM_RD_IDLE ;
						end
					end

				default : 
					begin
							r_AXIM_RD_FSM <= P_AXIM_RD_IDLE ;
					end
			endcase
		end
	end

	// FSM Decoder
	assign s_FSM_AXIM_RD_AINF	= (r_AXIM_RD_FSM == P_AXIM_RD_AINF ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_RD_AVLD	= (r_AXIM_RD_FSM == P_AXIM_RD_AVLD ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_RD_DATA 	= (r_AXIM_RD_FSM == P_AXIM_RD_DATA ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_RD_END 	= (r_AXIM_RD_FSM == P_AXIM_RD_END  ) ? 1'b1 : 1'b0 ;

	// Wait Counter
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_WAIT_CNT	<= 5'h0F ;
		end else begin
			if (s_FSM_AXIM_RD_END) begin
	            r_WAIT_CNT	<= r_WAIT_CNT - 1 ;
			end else begin
            	r_WAIT_CNT	<= 5'h0F ;
			end
		end
	end
	assign s_WAIT_CNT_EXPIRE = r_WAIT_CNT[4] ;
	assign s_AXIM_1LINE_RD_END = s_FSM_AXIM_RD_END & s_WAIT_CNT_EXPIRE ;
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_1LINE_RD_END 	<= 1'b0 ;
		end else begin
            r_AXIM_1LINE_RD_END 	<= s_AXIM_1LINE_RD_END  ;
		end
	end

	//-----------------------------------------------
	//      OSD Read Address Control
	//-----------------------------------------------
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_OSD_CMD_PEND_BUF	<= {5{1'b0}} ;
		end else begin
			if (OSD_CMD_CTRL_EN) begin
	            r_OSD_CMD_PEND_BUF	<= OSD_CMD_PEND_BUF ;
			end
		end
	end

    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_RD_ADDR	<= {28{1'b0}} ;
		end else begin
			if (r_OSD_DISP_EN_MIG0[2:1] == 2'b10) begin						// Dispaly OFF
		    	r_AXIM_RD_ADDR[21: 0]	<= {22{1'b0}} ;
				r_AXIM_RD_ADDR[26:22]	<= r_OSD_CMD_PEND_BUF ;
				r_AXIM_RD_ADDR[27]		<= r_AXIM_RD_ADDR[27] ;
			end else if (VX1_VSYNC_FE_MIG0) begin							// 1 Frame Start
				if (OSD_CMD_CTRL_EN) begin										// Load Frame Pending Buffer
			    	r_AXIM_RD_ADDR[21: 0]	<= {22{1'b0}} ;
					r_AXIM_RD_ADDR[26:22]	<= OSD_CMD_PEND_BUF ;
					r_AXIM_RD_ADDR[27]		<= r_AXIM_RD_ADDR[27] ;
				end else begin
			    	r_AXIM_RD_ADDR[21: 0]	<= {22{1'b0}} ;
					r_AXIM_RD_ADDR[26:22]	<= r_OSD_CMD_PEND_BUF ;
					r_AXIM_RD_ADDR[27]		<= r_AXIM_RD_ADDR[27] ;
				end
			end else if (s_AXIM_1LINE_RD_END) begin							// 1 Line End
		    	r_AXIM_RD_ADDR[21: 0]	<= r_AXIM_RD_ADDR[21: 0] + 1920 ;
				r_AXIM_RD_ADDR[26:22]	<= r_OSD_CMD_PEND_BUF ;
				r_AXIM_RD_ADDR[27]		<= r_AXIM_RD_ADDR[27] ;
			end
		end
	end

	//-----------------------------------------------
	//      AXI Master Output
	//-----------------------------------------------
	assign OSD_AXIM_ARID		= P_DEVICE_ID			;
	assign OSD_AXIM_ARADDR		= {4'h0,r_AXIM_RD_ADDR}	;
	assign OSD_AXIM_ARLEN		= P_AXIM_DLEN			;
	assign OSD_AXIM_ARSIZE		= 3'b011				; // 8bytes
	assign OSD_AXIM_ARBURST		= 2'b01					; // INRC
	assign OSD_AXIM_ARLOCK		= 1'b0					;
	assign OSD_AXIM_ARCACHE		= 4'h3					;
	assign OSD_AXIM_ARPROT		= 3'b000				;
	assign OSD_AXIM_ARQOS		= 4'h0					;
	assign OSD_AXIM_ARVALID		= s_FSM_AXIM_RD_AVLD	;
	assign OSD_AXIM_RREADY		= 1'b1					;

	//-----------------------------------------------
	//      OSD Buffer Write Control
	//-----------------------------------------------
	// Write Enable
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_TXBUF_WEN <= 1'b0 ;
		end else begin
			r_OSD_TXBUF_WEN <= OSD_AXIM_RVALID ;
		end
	end

	// Write Data
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_TXBUF_DIN 		<= {64{1'b0}} ;
			r_OSD_TXBUF_1LINE_WEND	<= 1'b0 ;
		end else begin
			r_OSD_TXBUF_DIN 		<= OSD_AXIM_RDATA ;
			r_OSD_TXBUF_1LINE_WEND	<= s_FSM_AXIM_RD_DATA & OSD_AXIM_RLAST ;
		end
	end

	// Write Address
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_TXBUF_WADDR <= {9{1'b0}} ;
		end else begin
			if (!r_OSD_DISP_EN_MIG0[2]) begin					// Dispaly OFF
				r_OSD_TXBUF_WADDR <= {9{1'b0}} ;
			end else if (r_OSD_TXBUF_1LINE_WEND) begin			// 1 Line End
				r_OSD_TXBUF_WADDR[8] 	<= ~r_OSD_TXBUF_WADDR[8] ;
				r_OSD_TXBUF_WADDR[7:0] 	<= {8{1'b0}} ;
			end else if (r_OSD_TXBUF_WEN) begin
				r_OSD_TXBUF_WADDR <= r_OSD_TXBUF_WADDR + 1 ;
			end
		end
	end

	dpram_I_64x512_O_128x256 osd_txbuf(
		.clka			( CLK_MIG0_UI			),
		.ena			( 1'b1					),
		.wea			( r_OSD_TXBUF_WEN		),
		.addra			( r_OSD_TXBUF_WADDR		),
		.dina			( r_OSD_TXBUF_DIN		),
		.clkb			( CLK_VX1				),
		.enb			( s_OSD_TXBUF_REN		),
		.addrb			( r_OSD_TXBUF_RADDR		),
		.doutb			( s_OSD_TXBUF_DOUT		));

	//-----------------------------------------------
	//      OSD Buffer Read Control
	//-----------------------------------------------
	// Falling Edge Of VX1_VSYNC
	always @ (posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VX1_VSYNC <= {3{1'b0}} ;
		end else begin
			r_VX1_VSYNC <= {r_VX1_VSYNC[1:0],VX1_VSYNC} ;
		end
	end
	assign s_VX1_VSYNC_FE = r_VX1_VSYNC[2] & ~r_VX1_VSYNC[1] ;
	always @ (posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VX1_VSYNC_FE <= 1'b0 ;
		end else begin
			r_VX1_VSYNC_FE <= s_VX1_VSYNC_FE ;
		end
	end

	// SYNC. Of OSD_DISP_EN
	always @ (posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_DISP_EN_VX1 <= {3{1'b0}} ;
		end else begin
			r_OSD_DISP_EN_VX1 <= {r_OSD_DISP_EN_VX1[1:0],OSD_DISP_EN} ;
		end
	end

	// Buffer Read Enable
	assign s_OSD_TXBUF_REN = OSD_BUF_REN ;

	// Buffer Read Address
	always @ (posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_TXBUF_RADDR <= {8{1'b0}} ;
		end else begin
			if (!r_OSD_DISP_EN_VX1[2]) begin					// Dispaly OFF
				r_OSD_TXBUF_RADDR <= {8{1'b0}} ;
			end else if (r_VX1_VSYNC_FE) begin					// VSYNC
				r_OSD_TXBUF_RADDR <= {8{1'b0}} ;
			end else if (OSD_BUF_RD_CMP) begin					// 1Line Read End
				r_OSD_TXBUF_RADDR[7] 	<= ~r_OSD_TXBUF_RADDR[7] ;
				r_OSD_TXBUF_RADDR[6:0] 	<= {7{1'b0}} ;
			end else if (OSD_BUF_RD_REW) begin					// 1Line Read Rewind
				r_OSD_TXBUF_RADDR[7] 	<= r_OSD_TXBUF_RADDR[7] ;
				r_OSD_TXBUF_RADDR[6:0] 	<= {7{1'b0}} ;
			end else if (s_OSD_TXBUF_REN) begin					// Read Enable
				r_OSD_TXBUF_RADDR <= r_OSD_TXBUF_RADDR + 1 ;
			end
		end
	end

	// Read Data Valid
	always @ (posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_TXBUF_RVLD	<= 1'b0 ;
		end else begin
			r_OSD_TXBUF_RVLD	<= s_OSD_TXBUF_REN ;
		end
	end

	// Output
	assign OSD_BUF_RVLD = r_OSD_TXBUF_RVLD ;
	assign OSD_BUF_RDT	= s_OSD_TXBUF_DOUT ;

	//-----------------------------------------------
	//     OSD Buffer Status
	//-----------------------------------------------
    pulse_gen u_pg_wend (
        .XRST       ( XRST          				) ,   // (i)
        .CLK_I      ( CLK_MIG0_UI      				) ,   // (i)
        .CLK_O      ( CLK_VX1 		  				) ,   // (i)
        .PULSE_I    ( r_OSD_TXBUF_1LINE_WEND		) ,   // (i)
        .PULSE_O    ( s_OSD_TXBUF_1LINE_WEND_VX1	)     // (o)
    ) ;

	// Buffer Status
	always @ (posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_TXBUF_CNT <= {2{1'b0}} ;
		end else begin
			if (!r_OSD_DISP_EN_VX1[2]) begin					// Dispaly OFF
				r_OSD_TXBUF_CNT <= {2{1'b0}} ;
			end else if (r_VX1_VSYNC_FE) begin					// VSYNC
				r_OSD_TXBUF_CNT <= {2{1'b0}} ;
			end else if (s_OSD_TXBUF_1LINE_WEND_VX1 == 1'b1 && OSD_BUF_RD_CMP == 1'b0) begin	// Write
				r_OSD_TXBUF_CNT <= r_OSD_TXBUF_CNT + 1 ;
			end else if (s_OSD_TXBUF_1LINE_WEND_VX1 == 1'b0 && OSD_BUF_RD_CMP == 1'b1) begin	// Read
				r_OSD_TXBUF_CNT <= r_OSD_TXBUF_CNT - 1 ;
			end
		end
	end

	// Buffer Status
	assign s_OSD_TXBUF_EMPTY 	= (r_OSD_TXBUF_CNT == 2'b00) ? 1'b1 :1'b0 ;
	assign s_OSD_TXBUF_FULL 	= (r_OSD_TXBUF_CNT == 2'b10) ? 1'b1 :1'b0 ;

	// Buffer Of s_OSD_TXBUF_FULL
	always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_TXBUF_FULL_MIG0 	<= {3{1'b0}} ;
		end else begin
			r_OSD_TXBUF_FULL_MIG0 	<= {r_OSD_TXBUF_FULL_MIG0[1:0],s_OSD_TXBUF_FULL} ;
		end
	end

	// Output
	assign OSD_BUF_ST = ~s_OSD_TXBUF_EMPTY ;

endmodule