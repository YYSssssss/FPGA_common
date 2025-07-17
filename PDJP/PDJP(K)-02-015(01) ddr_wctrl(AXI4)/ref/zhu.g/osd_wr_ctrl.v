// =================================================================================================

// =================================================================================================
// File Name	  : osd_wr_ctrl.v
// Module		  : osd_wr_ctrl
// Function 	  : OSD Data DDR3 Write Control
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


module osd_wr_ctrl #(
	parameter 				P_DEVICE_ID			= 4'h0
	)(
	// Reset
	input	wire			XRST					, // (i) Async. Reset (Low Active)
	input	wire			CLK_MIG0_UI				, // (i) OSD Mig ui_clk

	// blackfin_decode
	output	wire			OSD_CMD_DRAW_END		, // (o) OSD Command Operation End
	input	wire			OSD_CMD_DRAW_EN			, // (i) OSD Draw Command Enable
	input	wire	[ 6:0]	OSD_CMD_DRAW_LEN		, // (i) OSD Draw Command Length
	input	wire	[ 7:0]	OSD_CMD_DRAW_COLOR		, // (i) OSD Draw Command Color

	output	wire			OSD_CMD_DRAW_EXT_END	, // (o) OSD Command Operation End
	input	wire			OSD_CMD_DRAW_EXT_EN		, // (i) OSD Draw Extended Command Enable
	input	wire	[ 7:0]	OSD_CMD_DRAW_EXT_LEN	, // (i) OSD Draw Extended Command Length

	input	wire			OSD_CMD_LPOINT_EN		, // (i) OSD Load Low Point Command Enable
	input	wire	[ 9:0]	OSD_CMD_LPOINT			, // (i) OSD Low Point

	input	wire			OSD_CMD_DRAW_BUF_EN		, // (i) OSD Draw Buffer Select Command Enable
	input	wire	[ 4:0]	OSD_CMD_DRAW_BUF		, // (i) OSD Draw Buffer

	input	wire			OSD_CMD_SKIP_EN			, // (i) OSD Draw Skip Command Enable
	input	wire	[11:0]	OSD_CMD_SKIP_VALUE		, // (i) OSD Skip Value(bit12 1:- 0:+)

	// Master Interface Write Address Ports
	output	wire	[ 3:0]	OSD_AXIM_AWID			, // (o) Write address ID
	output	wire	[31:0]	OSD_AXIM_AWADDR			, // (o) Write address
	output	wire	[ 7:0]	OSD_AXIM_AWLEN			, // (o) Burst length
	output	wire	[ 2:0]	OSD_AXIM_AWSIZE			, // (o) Burst size
	output	wire	[ 1:0]	OSD_AXIM_AWBURST		, // (o) Burst type
	output	wire			OSD_AXIM_AWLOCK			, // (o) Lock type
	output	wire	[ 3:0]	OSD_AXIM_AWCACHE		, // (o) Cache type
	output	wire	[ 2:0]	OSD_AXIM_AWPROT			, // (o) Protection type
	output	wire	[ 3:0]	OSD_AXIM_AWQOS			, // (o) QoS identifier
	output	wire			OSD_AXIM_AWVALID		, // (o) Write address valid
	input	wire			OSD_AXIM_AWREADY		, // (i) Write address ready
	// Master Interface Write Data Ports
	output	wire	[63:0]	OSD_AXIM_WDATA			, // (o) Write data
	output	wire	[ 7:0]	OSD_AXIM_WSTRB			, // (o) Write strobes
	output	wire			OSD_AXIM_WLAST			, // (o) Write last
	output	wire			OSD_AXIM_WVALID			, // (o) Write valid
	input	wire			OSD_AXIM_WREADY			, // (i) Write ready
	// Master Interface Write Response Ports
	output	wire			OSD_AXIM_BREADY			, // (o) Response ready
	input	wire	[ 3:0]	OSD_AXIM_BID			, // (i) Response ID
	input	wire	[ 1:0]	OSD_AXIM_BRESP			, // (i) Write response
	input	wire			OSD_AXIM_BVALID			  // (i) Write response valid

) ;

// =============================================================================
// Signal Define
// =============================================================================
	parameter   P_AXIM_DWIDTH	    = 8'h08     	; // 8Byte
	parameter   P_AXIM_BSIZE    	= 15'h800     	; // 2048Byte(256x8B)

	parameter   P_OSD_WR_IDLE	    = 4'h1     		; // Idle
	parameter   P_OSD_WR_JUG    	= 4'h2     		; // Write Judge
	parameter   P_OSD_WR_ACT    	= 4'h4     		; // Write Active
	parameter   P_OSD_WR_END    	= 4'h8     		; // Write End

	parameter   P_AXIM_WR_IDLE	    = 7'h01     	; // Idle
	parameter   P_AXIM_WR_AINF    	= 7'h02     	; // Write Address And Information
	parameter   P_AXIM_WR_AVLD    	= 7'h04     	; // Write Address Valid
	parameter   P_AXIM_WR_DPRE    	= 7'h08     	; // Write Data Prepare
	parameter   P_AXIM_WR_DATA    	= 7'h10     	; // Write Data 
	parameter   P_AXIM_WR_DLST    	= 7'h20     	; // Write Last Data 
	parameter   P_AXIM_WR_END    	= 7'h40     	; // Write End

	//      OSD Write Control
	reg		[ 3:0] 		r_OSD_WR_FSM				; // OSD Write State Machine
	wire				s_FSM_OSD_WR_JUG			; // Decoder Of FSM
	wire				s_FSM_OSD_WR_ACT			; // Decoder Of FSM
	wire				s_FSM_OSD_WR_END			; // Decoder Of FSM
	reg					r_FSM_OSD_WR_END			; // Decoder Of FSM
	reg					r_FSM_OSD_WR_JUG			; // Decoder Of FSM

	//      AXI Master State Machine
	reg		[ 6:0] 		r_AXIM_WR_FSM				; // AXI Master State Machine
	wire				s_FSM_AXIM_WR_AINF			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_AVLD			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_DPRE			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_DATA			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_DLST			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_END			; // Decoder Of FSM
	reg					r_FSM_AXIM_WR_AINF			; // Decoder Of FSM
	reg					r_FSM_AXIM_WR_END			; // Decoder Of FSM

	//      OSD Write Total Data Size
	reg		[14:0] 		r_OSD_WR_TSIZE				; // Total Data Size
	wire	[15:0] 		s_OSD_WR_TSIZE_OUT			; // Total Data Size
	reg		[11:0] 		r_AXIM_WR_TSIZE				; // OSD Write Total Data Size
	wire	[12:0] 		s_AXIM_WR_TSIZE_OUT0		; // Left Data Size > Burst size Judgment
	wire	[12:0] 		s_AXIM_WR_TSIZE_OUT1		; // Left Data Size > 2*Burst size Judgment

	//      OSD Write Address Control
	reg		[27:0] 		r_AXIM_WR_ADDR				; // OSD Write Address Control
	reg		[ 2:0] 		r_AXIM_WR_ADDR_L3B			; // OSD Write Address Control(Low 3 Bit)
	reg		[ 2:0] 		r_OSD_CMD_DRAW_LEN_L3B		; // OSD_CMD_DRAW_LEN Low 3 Bit Latch
	//      OSD Write Burst Length
	reg		[ 7:0] 		r_AXIM_WR_LEN				; // OSD Write Burst Length

	//      OSD Write Data
	reg		[63:0] 		r_AXIM_WR_DATA				; // OSD Write Data

	//      OSD Write Data Byte Enable
	wire	[ 7:0] 		s_AXIM_WR_BE_BGN			; // OSD Write Data Byte Enable(Begin)
	reg		[ 7:0] 		r_AXIM_WR_BE_BGN			; // OSD Write Data Byte Enable(Begin)
	wire	[ 7:0] 		s_AXIM_WR_BE_END7			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END6			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END5			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END4			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END3			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END2			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END1			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END0			; // OSD Write Data Byte Enable(End)
	wire	[ 7:0] 		s_AXIM_WR_BE_END			; // OSD Write Data Byte Enable(End)
	reg		[ 7:0] 		r_AXIM_WR_BE_END			; // OSD Write Data Byte Enable(End)
	reg		[ 7:0] 		r_AXIM_WR_BE_END0			; // OSD Write Data Byte Enable(End)
	reg					r_FSM_AXIM_WR_DBGN			; // 1st Data Write Enable
	reg					r_FSM_AXIM_WR_1DT			; // Only One Data Write Enable
	wire	[ 7:0] 		s_AXIM_WR_STRB				; // OSD Write Data Strobes
	reg					r_OSD_CMD_DRAW_END			; // OSD Write End
// =============================================================================
// RTL
// =============================================================================

	//-----------------------------------------------
	//      OSD Write Control
	//-----------------------------------------------
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_WR_FSM <= P_OSD_WR_IDLE ;
		end else begin
			case (r_OSD_WR_FSM) 
				P_OSD_WR_IDLE : 			// IDLE
					begin
						if (OSD_CMD_DRAW_EN 	&& OSD_CMD_DRAW_LEN 	!= 7'h00 ||			// Draw Command
							OSD_CMD_DRAW_EXT_EN && OSD_CMD_DRAW_EXT_LEN != 8'h00) begin		// Draw Extended Command
							r_OSD_WR_FSM <= P_OSD_WR_JUG ;
						end
					end

				P_OSD_WR_JUG : 				// Write Judge
					begin
							r_OSD_WR_FSM <= P_OSD_WR_ACT ;
					end

				P_OSD_WR_ACT : 				// Write Active
					begin
						if (r_FSM_AXIM_WR_END) begin			// DDR3 Access End
							if (s_OSD_WR_TSIZE_OUT[15]) begin		// All Size End
								r_OSD_WR_FSM <= P_OSD_WR_END ;
							end else begin							// All Size Not End
								r_OSD_WR_FSM <= P_OSD_WR_JUG ;
							end
						end
					end

				P_OSD_WR_END : 				// Write End
					begin
							r_OSD_WR_FSM <= P_OSD_WR_IDLE ;
					end

				default : 
					begin
							r_OSD_WR_FSM <= P_OSD_WR_IDLE ;
					end
			endcase
		end
	end

	// FSM Decoder
	assign s_FSM_OSD_WR_JUG	= (r_OSD_WR_FSM == P_OSD_WR_JUG  ) ? 1'b1 : 1'b0 ;
	assign s_FSM_OSD_WR_ACT	= (r_OSD_WR_FSM == P_OSD_WR_ACT  ) ? 1'b1 : 1'b0 ;
	assign s_FSM_OSD_WR_END	= (r_OSD_WR_FSM == P_OSD_WR_END  ) ? 1'b1 : 1'b0 ;

    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_FSM_OSD_WR_JUG	<= 1'b0 ;
			r_FSM_OSD_WR_END	<= 1'b0 ;
		end else begin
			r_FSM_OSD_WR_JUG	<= s_FSM_OSD_WR_JUG  ;
			r_FSM_OSD_WR_END	<= s_FSM_OSD_WR_END  ;
		end
	end

	//-----------------------------------------------
	//      AXI Master State Machine(Write)
	//-----------------------------------------------
	always @ (posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_AXIM_WR_FSM <= P_AXIM_WR_IDLE ;
		end else begin
			case (r_AXIM_WR_FSM) 
				P_AXIM_WR_IDLE : 			// IDLE
					begin
						if (r_FSM_OSD_WR_JUG) begin				// Draw Command Enable
							r_AXIM_WR_FSM <= P_AXIM_WR_AINF ;
						end
					end

				P_AXIM_WR_AINF : 			// Write Address And Information
					begin
							r_AXIM_WR_FSM <= P_AXIM_WR_AVLD ;
					end

				P_AXIM_WR_AVLD : 			// Write Address Valid
					begin
						if (OSD_AXIM_AWREADY) begin				// Write Address Ready
							r_AXIM_WR_FSM <= P_AXIM_WR_DPRE ;
						end
					end

				P_AXIM_WR_DPRE : 			// Write Data Prepare
					begin
						if (s_AXIM_WR_TSIZE_OUT0[12]) begin 	// Left Data Size <= Burst size
							r_AXIM_WR_FSM <= P_AXIM_WR_DLST ;
						end else begin
							r_AXIM_WR_FSM <= P_AXIM_WR_DATA ;
						end
					end

				P_AXIM_WR_DATA : 			// Write Data 
					begin
						if (s_AXIM_WR_TSIZE_OUT1[12] && 		// Left Data Size <= 2*Burst size
							OSD_AXIM_WREADY) begin 				// And Write Data ready
							r_AXIM_WR_FSM <= P_AXIM_WR_DLST ;
						end
					end

				P_AXIM_WR_DLST : 			// Write Last Data 
					begin
						if (OSD_AXIM_WREADY) begin 				// And Write Data ready
							r_AXIM_WR_FSM <= P_AXIM_WR_END ;
						end
					end

				P_AXIM_WR_END : 			// Write End 
					begin
							r_AXIM_WR_FSM <= P_AXIM_WR_IDLE ;
					end

				default : 
					begin
							r_AXIM_WR_FSM <= P_AXIM_WR_IDLE ;
					end
			endcase
		end
	end

	// FSM Decoder
	assign s_FSM_AXIM_WR_AINF	= (r_AXIM_WR_FSM == P_AXIM_WR_AINF ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_WR_AVLD	= (r_AXIM_WR_FSM == P_AXIM_WR_AVLD ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_WR_DPRE	= (r_AXIM_WR_FSM == P_AXIM_WR_DPRE ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_WR_DATA	= (r_AXIM_WR_FSM == P_AXIM_WR_DATA ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_WR_DLST	= (r_AXIM_WR_FSM == P_AXIM_WR_DLST ) ? 1'b1 : 1'b0 ;
	assign s_FSM_AXIM_WR_END	= (r_AXIM_WR_FSM == P_AXIM_WR_END  ) ? 1'b1 : 1'b0 ;

    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_FSM_AXIM_WR_AINF	<= 1'b0 ;
			r_FSM_AXIM_WR_END	<= 1'b0 ;
		end else begin
			r_FSM_AXIM_WR_AINF	<= s_FSM_AXIM_WR_AINF ;
			r_FSM_AXIM_WR_END	<= s_FSM_AXIM_WR_END  ;
		end
	end
	//-----------------------------------------------
	//      OSD Write Total Data Size
	//-----------------------------------------------
	// Total Data Size
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_OSD_WR_TSIZE	<= {15{1'b0}} ;
		end else begin
			if (OSD_CMD_DRAW_EN) begin								// Load OSD Draw Command Length
				if (r_AXIM_WR_ADDR[2:0] != 3'b000) begin				// Not 8Byte Boundary
		            r_OSD_WR_TSIZE	<= {{8{1'b0}},OSD_CMD_DRAW_LEN} + {{12{1'b0}},r_AXIM_WR_ADDR[2:0]};
				end else begin
		            r_OSD_WR_TSIZE	<= {{8{1'b0}},OSD_CMD_DRAW_LEN};
				end
			end else if (OSD_CMD_DRAW_EXT_EN) begin					// Load OSD Draw Extended Command Length
				if (r_AXIM_WR_ADDR[2:0] != 3'b000) begin				// Not 8Byte Boundary
		            r_OSD_WR_TSIZE	<= {OSD_CMD_DRAW_EXT_LEN,{7{1'b0}}} + {{12{1'b0}},r_AXIM_WR_ADDR[2:0]};
				end else begin
		            r_OSD_WR_TSIZE	<= {OSD_CMD_DRAW_EXT_LEN,{7{1'b0}}} ;
				end
			end else if (r_FSM_AXIM_WR_AINF) begin					// Write Data Size
				r_OSD_WR_TSIZE	<= r_OSD_WR_TSIZE - {{3{1'b0}},r_AXIM_WR_TSIZE} ;
			end
		end
	end
	assign s_OSD_WR_TSIZE_OUT = {1'b0,r_OSD_WR_TSIZE} - 1;

	// DDR3 Access Size
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_AXIM_WR_TSIZE	<= {12{1'b0}} ;
		end else begin
			if (r_FSM_OSD_WR_JUG) begin								// Load OSD Draw Command Length
				if(r_OSD_WR_TSIZE >= P_AXIM_BSIZE) begin				// Size >= 256x8B
	            	r_AXIM_WR_TSIZE	<= P_AXIM_BSIZE[11:0] ;
				end else begin											// Size <= 256x8B
	            	r_AXIM_WR_TSIZE	<= r_OSD_WR_TSIZE[11:0] ;
				end
			end else if (s_FSM_AXIM_WR_DATA && OSD_AXIM_WREADY) begin	// Write Data 
	            r_AXIM_WR_TSIZE	<= r_AXIM_WR_TSIZE - P_AXIM_DWIDTH  ;
			end
		end
	end

	// Left Data Size > Burst size Judgment
	assign s_AXIM_WR_TSIZE_OUT0 = {1'b0,r_AXIM_WR_TSIZE} - P_AXIM_DWIDTH - 1;
	assign s_AXIM_WR_TSIZE_OUT1 = s_AXIM_WR_TSIZE_OUT0 - P_AXIM_DWIDTH;

	//-----------------------------------------------
	//      OSD Write Address Control
	//-----------------------------------------------
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_WR_ADDR	<= {28{1'b0}} ;
		end else begin
			if (OSD_CMD_DRAW_BUF_EN) begin								// Draw Buffer
	            r_AXIM_WR_ADDR	<= {1'b0,OSD_CMD_DRAW_BUF,{22{1'b0}}} ;
			end else if (OSD_CMD_LPOINT_EN) begin						// Load Point
	            r_AXIM_WR_ADDR	<= 	{r_AXIM_WR_ADDR[27:22],1'b0,OSD_CMD_LPOINT,{11{1'b0}}} ; 	// LPOINT *2K
			end else if (OSD_CMD_SKIP_EN) begin							// Skip Point 
				if (OSD_CMD_SKIP_VALUE[11]) begin		// -
					r_AXIM_WR_ADDR	<= r_AXIM_WR_ADDR - {{17{1'b0}},OSD_CMD_SKIP_VALUE[10:0]} ;
				end else begin							// +
		            r_AXIM_WR_ADDR	<= r_AXIM_WR_ADDR + {{17{1'b0}},OSD_CMD_SKIP_VALUE[10:0]} ;
				end
			end else if (s_FSM_AXIM_WR_DPRE) begin						// Pluse Write Size
		    	r_AXIM_WR_ADDR	<= {r_AXIM_WR_ADDR[27:3],3'b000} + r_AXIM_WR_TSIZE ;
			end
		end
	end

	// Low 3 Bit Latch
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_WR_ADDR_L3B	<= {3{1'b0}} ;
		end else begin
			if (r_FSM_AXIM_WR_AINF) begin
	            r_AXIM_WR_ADDR_L3B	<= r_AXIM_WR_ADDR[2:0] ;
			end
		end
	end

	// OSD_CMD_DRAW_LEN Low 3 Bit Latch
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_OSD_CMD_DRAW_LEN_L3B	<= {3{1'b0}} ;
		end else begin
			if (OSD_CMD_DRAW_EN) begin
	            r_OSD_CMD_DRAW_LEN_L3B	<= OSD_CMD_DRAW_LEN[2:0] ;
			end
		end
	end

	//-----------------------------------------------
	//      OSD Write Burst Length
	//-----------------------------------------------
	// OSD Write Burst Length
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_WR_LEN	<= {8{1'b0}} ;
		end else begin
			if (s_FSM_AXIM_WR_AINF) begin				// Judge Length
				if (r_AXIM_WR_TSIZE[2:0] == 3'b000) begin			// 8Byte Unit
	            	r_AXIM_WR_LEN	<= r_AXIM_WR_TSIZE[10:3] ;
				end else begin										// Not 8Byte Unit
	            	r_AXIM_WR_LEN	<= r_AXIM_WR_TSIZE[10:3] + 1 ;
				end
			end
		end
	end

	//-----------------------------------------------
	//      OSD Write Data
	//-----------------------------------------------
	always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_WR_DATA	<= {64{1'b0}} ;
		end else begin
			if (OSD_CMD_DRAW_EN) begin				// Load Draw Command Color
	            r_AXIM_WR_DATA	<= {8{OSD_CMD_DRAW_COLOR}}  ;
			end
		end
	end

//    always @(posedge CLK_MIG0_UI or negedge XRST) begin
//		if ( !XRST ) begin
//            r_AXIM_WR_DATA	<= {64{1'b0}} ;
//		end else begin
//			if (OSD_AXIM_WREADY && (s_FSM_AXIM_WR_DATA || s_FSM_AXIM_WR_DLST)) begin
//	            r_AXIM_WR_DATA	<= r_AXIM_WR_DATA + 1  ;
//			end
//		end
//	end

	//-----------------------------------------------
	//      OSD Write Data Byte Enable
	//-----------------------------------------------
	assign s_AXIM_WR_BE_BGN = 	r_AXIM_WR_ADDR_L3B == 3'h7 ? 8'b1000_0000 :
								r_AXIM_WR_ADDR_L3B == 3'h6 ? 8'b1100_0000 :
								r_AXIM_WR_ADDR_L3B == 3'h5 ? 8'b1110_0000 :
								r_AXIM_WR_ADDR_L3B == 3'h4 ? 8'b1111_0000 :
								r_AXIM_WR_ADDR_L3B == 3'h3 ? 8'b1111_1000 :
								r_AXIM_WR_ADDR_L3B == 3'h2 ? 8'b1111_1100 :
								r_AXIM_WR_ADDR_L3B == 3'h1 ? 8'b1111_1110 :
															 8'b1111_1111 ;

	// Address=0
	assign s_AXIM_WR_BE_END0 = 	r_AXIM_WR_TSIZE[2:0] == 3'h1 ? 8'b0000_0001 :
								r_AXIM_WR_TSIZE[2:0] == 3'h2 ? 8'b0000_0011 :
								r_AXIM_WR_TSIZE[2:0] == 3'h3 ? 8'b0000_0111 :
								r_AXIM_WR_TSIZE[2:0] == 3'h4 ? 8'b0000_1111 :
								r_AXIM_WR_TSIZE[2:0] == 3'h5 ? 8'b0001_1111 :
								r_AXIM_WR_TSIZE[2:0] == 3'h6 ? 8'b0011_1111 :
								r_AXIM_WR_TSIZE[2:0] == 3'h7 ? 8'b0111_1111 :
															   8'b1111_1111 ;
	// Address=1
	assign s_AXIM_WR_BE_END1 = 	r_OSD_CMD_DRAW_LEN_L3B == 3'h1 ? 8'b0000_0010 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h2 ? 8'b0000_0110 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h3 ? 8'b0000_1110 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h4 ? 8'b0001_1110 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h5 ? 8'b0011_1110 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h6 ? 8'b0111_1110 :
															     8'b1111_1110 ;
	// Address=2
	assign s_AXIM_WR_BE_END2 = 	r_OSD_CMD_DRAW_LEN_L3B == 3'h1 ? 8'b0000_0100 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h2 ? 8'b0000_1100 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h3 ? 8'b0001_1100 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h4 ? 8'b0011_1100 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h5 ? 8'b0111_1100 :
															     8'b1111_1100 ;
	// Address=3
	assign s_AXIM_WR_BE_END3 = 	r_OSD_CMD_DRAW_LEN_L3B == 3'h1 ? 8'b0000_1000 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h2 ? 8'b0001_1000 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h3 ? 8'b0011_1000 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h4 ? 8'b0111_1000 :
															     8'b1111_1000 ;
	// Address=4
	assign s_AXIM_WR_BE_END4 = 	r_OSD_CMD_DRAW_LEN_L3B == 3'h1 ? 8'b0001_0000 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h2 ? 8'b0011_0000 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h3 ? 8'b0111_0000 :
															     8'b1111_0000 ;
	// Address=5
	assign s_AXIM_WR_BE_END5 = 	r_OSD_CMD_DRAW_LEN_L3B == 3'h1 ? 8'b0010_0000 :
								r_OSD_CMD_DRAW_LEN_L3B == 3'h2 ? 8'b0110_0000 :
															     8'b1110_0000 ;
	// Address=6
	assign s_AXIM_WR_BE_END6 = 	r_OSD_CMD_DRAW_LEN_L3B == 3'h1 ? 8'b0100_0000 :
															   	 8'b1100_0000 ;
	// Address=7
	assign s_AXIM_WR_BE_END7 = 								     8'b1000_0000 ;

	assign s_AXIM_WR_BE_END = 	r_AXIM_WR_ADDR_L3B == 3'h7 ? s_AXIM_WR_BE_END7 :
								r_AXIM_WR_ADDR_L3B == 3'h6 ? s_AXIM_WR_BE_END6 :
								r_AXIM_WR_ADDR_L3B == 3'h5 ? s_AXIM_WR_BE_END5 :
								r_AXIM_WR_ADDR_L3B == 3'h4 ? s_AXIM_WR_BE_END4 :
								r_AXIM_WR_ADDR_L3B == 3'h3 ? s_AXIM_WR_BE_END3 :
								r_AXIM_WR_ADDR_L3B == 3'h2 ? s_AXIM_WR_BE_END2 :
								r_AXIM_WR_ADDR_L3B == 3'h1 ? s_AXIM_WR_BE_END1 :
														     s_AXIM_WR_BE_END0 ;

    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_WR_BE_BGN	<= {8{1'b0}} ;
            r_AXIM_WR_BE_END	<= {8{1'b0}} ;
            r_AXIM_WR_BE_END0	<= {8{1'b0}} ;
		end else begin
            r_AXIM_WR_BE_BGN	<= s_AXIM_WR_BE_BGN ;
            r_AXIM_WR_BE_END	<= s_AXIM_WR_BE_END ;
            r_AXIM_WR_BE_END0	<= s_AXIM_WR_BE_END0 ;
		end
	end

	// 1st Data Write Enable
	// Only One Data Write Enable
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_FSM_AXIM_WR_DBGN	<= 1'b0 ;
            r_FSM_AXIM_WR_1DT	<= 1'b0 ;
		end else begin
			if (OSD_AXIM_WVALID && OSD_AXIM_WREADY) begin
	            r_FSM_AXIM_WR_DBGN	<= 1'b0 ;
	            r_FSM_AXIM_WR_1DT	<= 1'b0 ;
			end else begin
				if (s_FSM_AXIM_WR_DPRE) begin
					if (s_AXIM_WR_TSIZE_OUT0[12]) begin		// Only One Cycle Write
			            r_FSM_AXIM_WR_DBGN	<= 1'b0 ;
			            r_FSM_AXIM_WR_1DT	<= 1'b1 ;
					end else begin
			            r_FSM_AXIM_WR_DBGN	<= 1'b1 ;
			            r_FSM_AXIM_WR_1DT	<= 1'b0 ;
					end
				end
			end
		end
	end

	// OSD Write Data Strobes
	assign s_AXIM_WR_STRB = r_FSM_AXIM_WR_1DT	? 	r_AXIM_WR_BE_END	:
							s_FSM_AXIM_WR_DLST 	? 	r_AXIM_WR_BE_END0 	:
							r_FSM_AXIM_WR_DBGN	? 	r_AXIM_WR_BE_BGN	:
													{8{1'b1}} 			;

	//-----------------------------------------------
	//      OSD Write End
	//-----------------------------------------------
    always @(posedge CLK_MIG0_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_OSD_CMD_DRAW_END		<= 1'b0 ;
		end else begin
			if ((OSD_CMD_DRAW_EN 	 && OSD_CMD_DRAW_LEN == 7'h00) ||
				(OSD_CMD_DRAW_EXT_EN && OSD_CMD_DRAW_EXT_LEN == 8'h00)) begin
	            r_OSD_CMD_DRAW_END	<= 1'b1 ;
			end else begin
	            r_OSD_CMD_DRAW_END	<= 1'b0 ;
			end
		end
	end

	assign OSD_CMD_DRAW_END 	= r_FSM_OSD_WR_END | r_OSD_CMD_DRAW_END ;
	assign OSD_CMD_DRAW_EXT_END = r_FSM_OSD_WR_END | r_OSD_CMD_DRAW_END ;
	//-----------------------------------------------
	//      Output
	//-----------------------------------------------
	assign OSD_AXIM_AWID		= P_DEVICE_ID			;
	assign OSD_AXIM_AWADDR		= {4'h0,r_AXIM_WR_ADDR}	;
	assign OSD_AXIM_AWLEN		= r_AXIM_WR_LEN -1		;
	assign OSD_AXIM_AWSIZE		= 3'b011				; // 8bytes
	assign OSD_AXIM_AWBURST		= 2'b01					; // INRC
	assign OSD_AXIM_AWLOCK		= 1'b0					;
	assign OSD_AXIM_AWCACHE		= 4'h3					;
	assign OSD_AXIM_AWPROT		= 3'b000				;
	assign OSD_AXIM_AWQOS		= 4'h0					;
	assign OSD_AXIM_AWVALID		= s_FSM_AXIM_WR_AVLD	;

	assign OSD_AXIM_WDATA		= r_AXIM_WR_DATA		;
	assign OSD_AXIM_WSTRB		= s_AXIM_WR_STRB		;
	assign OSD_AXIM_WLAST		= s_FSM_AXIM_WR_DLST	;
	assign OSD_AXIM_WVALID		= s_FSM_AXIM_WR_DATA 	| 
								  s_FSM_AXIM_WR_DLST	;
	assign OSD_AXIM_BREADY		= 1'b1					;

endmodule