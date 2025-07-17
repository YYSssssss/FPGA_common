// =================================================================================================
// File Name	  : video_wr_ctrl.v
// Module		  : video_wr_ctrl
// Function 	  : Video Write Control
// Type 		  : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date		   Coded by 		Contents
// 0.0.1	  2014/02/15   zhu.g	 		create new
//
// =================================================================================================
// End Revision
// =================================================================================================

// =============================================================================
// Timescale Define
// =============================================================================

`timescale 1ns / 1ps

module video_wr_ctrl #(
	parameter 				P_SIM				= 1'b0 ,
	parameter 				P_DEVICE_ID			= 4'h0  
	)(	// Reset
	input	wire			XRST				, // (i) async. reset (low active)
	input	wire			CLK_MIG1_UI			, // (i) Mig ui_clk

	// register
	input	wire		 	REG_VACT_EN_MIG1	, // (i) Video Active Enable
	input	wire	[ 3:0] 	REG_VIN_FRM_RATE	, // (i) VIDEO_IN_FRM_RATE
												  //	 [0]: 24Hz
												  //	 [1]: 30Hz
												  //	 [2]: 59.94Hz
												  //	 [3]: 60Hz
	input	wire			TST_RD_EN			, // (i) Read Enable

	// Cropper Line Buffer
	input	wire			CRP1_SOF			, // (i) Cropper1 SOF
	input	wire			CRP1_LBUF_ST      	, // (i) Cropper1 Line Buffer Status(0:no data 1:have data)
	output	wire			CRP1_LBUF_REN		, // (o) Cropper1 Line Buffer Read Enable
	output	wire			CRP1_LBUF_RCMP    	, // (o) Cropper1 Line Buffer Read Complete
	input	wire  	[511:0]	CRP1_LBUF_RD		, // (i) Cropper1 Line Buffer Read Data(SOF,EOL,R,B,G)

	// Frame Counter
	output	wire	[ 1:0]	VIDEO_RX_FRM_WCNT	, // (o) Video Frame Writing Counter
	output	wire			VIDEO_DISP_EN		, // (o) Video Output Enable

	// Master Interface Write Address Ports
	output	wire	[ 3:0]	VIDEO_AXIM_AWID		, // (o) Write address ID
	output	wire	[31:0]	VIDEO_AXIM_AWADDR	, // (o) Write address
	output	wire	[ 7:0]	VIDEO_AXIM_AWLEN	, // (o) Burst length
	output	wire	[ 2:0]	VIDEO_AXIM_AWSIZE	, // (o) Burst size
	output	wire	[ 1:0]	VIDEO_AXIM_AWBURST	, // (o) Burst type
	output	wire			VIDEO_AXIM_AWLOCK	, // (o) Lock type
	output	wire	[ 3:0]	VIDEO_AXIM_AWCACHE	, // (o) Cache type
	output	wire	[ 2:0]	VIDEO_AXIM_AWPROT	, // (o) Protection type
	output	wire	[ 3:0]	VIDEO_AXIM_AWQOS	, // (o) QoS identifier
	output	wire			VIDEO_AXIM_AWVALID	, // (o) Write address valid
	input	wire			VIDEO_AXIM_AWREADY	, // (i) Write address ready
	// Master Interface Write Data Ports
	output	wire	[511:0]	VIDEO_AXIM_WDATA	, // (o) Write data
	output	wire	[ 63:0]	VIDEO_AXIM_WSTRB	, // (o) Write strobes
	output	wire			VIDEO_AXIM_WLAST	, // (o) Write last
	output	wire			VIDEO_AXIM_WVALID	, // (o) Write valid
	input	wire			VIDEO_AXIM_WREADY	, // (i) Write ready
	// Master Interface Write Response Ports
	output	wire			VIDEO_AXIM_BREADY	, // (o) Response ready
	input	wire	[ 3:0]	VIDEO_AXIM_BID		, // (i) Response ID
	input	wire	[ 1:0]	VIDEO_AXIM_BRESP	, // (i) Write response
	input	wire			VIDEO_AXIM_BVALID	  // (i) Write response valid

) ;

// =============================================================================
// Signal Define
// =============================================================================

// =============================================================================
// Signal Define
// =============================================================================
	parameter   P_VIDEO_LINE_1_2   	= P_SIM ? 12'd50	: 12'd1080     	; // 2160 *1/2
	parameter   P_VIDEO_LINE_3_4   	= P_SIM ? 12'd50	: 12'd1620     	; // 2160 *3/4
	parameter   P_VIDEO_LINE_4_5   	= P_SIM ? 12'd50	: 12'd1728     	; // 2160 *4/5

	parameter   P_AXIM_DLEN	    	= P_SIM ? 8'd15		: 8'd239     	; // 240 x 64B(3840x4B) - 1
	parameter   P_AXIM_DWIDTH	    = 8'd64     	; // 64Byte

	parameter   P_AXIM_WR_IDLE	    = 7'h01     	; // Idle
	parameter   P_AXIM_WR_AINF    	= 7'h02     	; // Write Address And Information
	parameter   P_AXIM_WR_AVLD    	= 7'h04     	; // Write Address Valid
	parameter   P_AXIM_WR_DPRE    	= 7'h08     	; // Write Data Prepare
	parameter   P_AXIM_WR_DATA    	= 7'h10     	; // Write Data 
	parameter   P_AXIM_WR_DLST    	= 7'h20     	; // Write Last Data 
	parameter   P_AXIM_WR_END    	= 7'h40     	; // Write Last Data 

	//      AXI Master State Machine
	reg		[ 6:0] 		r_AXIM_WR_FSM				; // AXI Master State Machine
	wire				s_FSM_AXIM_WR_AINF			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_AVLD			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_DPRE			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_DATA			; // Decoder Of FSM
	wire				s_FSM_AXIM_WR_DLST			; // Decoder Of FSM

	//      DDR3 Write Total Data Size
	reg		[ 7:0] 		r_AXIM_WR_TSIZE				; // HDMI Write Total Data Size
	wire				s_AXIM_WR_TSIZE_OUT			; // Left Data Size > Burst size Judgment

	//      DDR3 Write Address Control
	reg					r_VIDEO_FRM_IN_ACT			; // 2nd and So On Frame Flage
	reg		[31:0] 		r_AXIM_WR_ADDR				; // HDMI Write Address Control

	//      Video Read Enable
	wire	[11:0] 		s_VIDEO_WR_LNUM_EXP			; // Video Write Expect Line Number
	wire				s_VIDEO_WR_LNUM_EXP_HIT		; // Video Write Expect Line Number Hit
	reg					r_VIDEO_WR_LNUM_EXP_HIT		; // Video Write Expect Line Number Hit
	reg					r_VIDEO_DISP_EN				; // Video Read Enable
	reg		[ 1:0]		r_VIDEO_RX_FRM_WCNT			; // Video Frame Writing Counter

	//      Cropper Line Buffer Read Control
	reg					r_CRP1_LBUF_RCMP			; // HDMI Write End

// =============================================================================
// RTL
// =============================================================================

	//-----------------------------------------------
	//      AXI Master State Machine(Write)
	//-----------------------------------------------
	always @ (posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_AXIM_WR_FSM <= P_AXIM_WR_IDLE ;
		end else begin
			case (r_AXIM_WR_FSM) 
				P_AXIM_WR_IDLE : 			// IDLE
					begin
						if (CRP1_LBUF_ST) begin						// Buffer Is Not Empty
							r_AXIM_WR_FSM <= P_AXIM_WR_AINF ;
						end
					end

				P_AXIM_WR_AINF : 			// Write Address And Information
					begin
							r_AXIM_WR_FSM <= P_AXIM_WR_AVLD ;
					end

				P_AXIM_WR_AVLD : 			// Write Address Valid
					begin
						if (VIDEO_AXIM_AWREADY) begin				// Write Address Ready
							r_AXIM_WR_FSM <= P_AXIM_WR_DPRE ;
						end
					end

				P_AXIM_WR_DPRE : 			// Write Data Prepare
					begin
						r_AXIM_WR_FSM <= P_AXIM_WR_DATA ;
					end

				P_AXIM_WR_DATA : 			// Write Data 
					begin
						if (s_AXIM_WR_TSIZE_OUT && 					// Left Data Size <= 2*Burst size
							VIDEO_AXIM_WREADY) begin 				// And Write Data ready
							r_AXIM_WR_FSM <= P_AXIM_WR_DLST ;
						end
					end

				P_AXIM_WR_DLST : 			// Write Last Data 
					begin
						if (VIDEO_AXIM_WREADY) begin 				// And Write Data ready
							r_AXIM_WR_FSM <= P_AXIM_WR_END ;
						end
					end

				P_AXIM_WR_END : 			// Write Last Data 
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

	//-----------------------------------------------
	//      DDR3 Write Total Data Size
	//-----------------------------------------------
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_WR_TSIZE	<= P_AXIM_DLEN ;
		end else begin
			if (s_FSM_AXIM_WR_AINF) begin
	            r_AXIM_WR_TSIZE	<= P_AXIM_DLEN ;
			end else if (s_FSM_AXIM_WR_DATA && VIDEO_AXIM_WREADY) begin	// Write Data 
	            r_AXIM_WR_TSIZE	<= r_AXIM_WR_TSIZE - 1  ;
			end
		end
	end

	// Left Data Size > Burst size Judgment
	assign s_AXIM_WR_TSIZE_OUT = (r_AXIM_WR_TSIZE == 8'd1) ? 1'b1 : 1'b0;

	//-----------------------------------------------
	//      DDR3 Write Address Control
	//-----------------------------------------------
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_FRM_IN_ACT  <= 1'b0 ;
		end else begin
			if (!REG_VACT_EN_MIG1) begin					// Video Disable
				r_VIDEO_FRM_IN_ACT   <= 1'b0 ;
			end else if (CRP1_SOF) begin
				r_VIDEO_FRM_IN_ACT   <= 1'b1 ;
			end
		end
	end


	// [13: 0]: Horizontal 	3840x4B(16KB)
	// [25:14]: Vertical	2160(4K)
	// [27:26]: Frame		4
	// [31:29]: Unused
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_WR_ADDR	<= {32{1'b0}} ;
		end else begin
			if (!REG_VACT_EN_MIG1) begin									// Video Disable
	            r_AXIM_WR_ADDR	<= {32{1'b0}} ;
			end else if (CRP1_SOF && r_VIDEO_FRM_IN_ACT) begin				// 1 Frame End
		    	r_AXIM_WR_ADDR[13: 0]	<= {14{1'b0}} ;	
				r_AXIM_WR_ADDR[25:14]	<= {12{1'b0}} ;
				r_AXIM_WR_ADDR[27:26]	<= r_AXIM_WR_ADDR[27:26] + 1 ;
				r_AXIM_WR_ADDR[31:28]	<= r_AXIM_WR_ADDR[31:28] ;
			end else if (s_FSM_AXIM_WR_AVLD && VIDEO_AXIM_AWREADY) begin	// 1Line End
		    	r_AXIM_WR_ADDR[13: 0]	<= {14{1'b0}} ;
				r_AXIM_WR_ADDR[25:14]	<= r_AXIM_WR_ADDR[25:14] + 1 ;
				r_AXIM_WR_ADDR[27:26]	<= r_AXIM_WR_ADDR[27:26] ;
				r_AXIM_WR_ADDR[31:28]	<= r_AXIM_WR_ADDR[31:28] ;
			end
		end
	end

	//-----------------------------------------------
	//      Video Display Enable
	//-----------------------------------------------
	// Video Display Enable When Hit The Write Line Number
	assign s_VIDEO_WR_LNUM_EXP = 	REG_VIN_FRM_RATE[0] ? 	P_VIDEO_LINE_4_5 :	// 24Hz 4/5Frame
									REG_VIN_FRM_RATE[1] ? 	P_VIDEO_LINE_3_4 :	// 30Hz 3/4Frame
															P_VIDEO_LINE_1_2 ;	// 60Hz 1/2Frame

	assign s_VIDEO_WR_LNUM_EXP_HIT = (s_VIDEO_WR_LNUM_EXP == r_AXIM_WR_ADDR[25:14]) ? 1'b1 : 1'b0 ;
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_WR_LNUM_EXP_HIT  <= 1'b0 ;
		end else begin
			r_VIDEO_WR_LNUM_EXP_HIT  <= s_VIDEO_WR_LNUM_EXP_HIT ;
		end
	end
	//  Video Display Enable
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_DISP_EN    	<= 1'b0 ;
		end else begin
			if (!REG_VACT_EN_MIG1) begin					// Video Disable
				r_VIDEO_DISP_EN    <= 1'b0 ;
			end else begin
				if (TST_RD_EN) begin
					if (CRP1_SOF && r_VIDEO_FRM_IN_ACT) begin
						r_VIDEO_DISP_EN   <= 1'b1 ;
					end
				end else begin
					if (s_FSM_AXIM_WR_AINF && r_VIDEO_WR_LNUM_EXP_HIT) begin
						r_VIDEO_DISP_EN   <= 1'b1 ;
					end
				end
			end
		end
	end
	assign VIDEO_DISP_EN = r_VIDEO_DISP_EN ;

	// Video Frame Writing Counter
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_RX_FRM_WCNT	<= 2'b00 ;
		end else begin
			if (!REG_VACT_EN_MIG1) begin					// Video Disable
				r_VIDEO_RX_FRM_WCNT	<= 2'b00 ;
			end else begin
				if (TST_RD_EN) begin
					r_VIDEO_RX_FRM_WCNT	<= r_AXIM_WR_ADDR[27:26] ;
				end else if (s_FSM_AXIM_WR_AINF && r_VIDEO_WR_LNUM_EXP_HIT) begin
					r_VIDEO_RX_FRM_WCNT <= r_AXIM_WR_ADDR[27:26] + 1 ;
				end
			end
		end
	end
	assign VIDEO_RX_FRM_WCNT = r_VIDEO_RX_FRM_WCNT ;
	//-----------------------------------------------
	//      Cropper Line Buffer Read Control
	//-----------------------------------------------
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_CRP1_LBUF_RCMP	<= 1'b0 ;
		end else begin
			if (s_FSM_AXIM_WR_DLST && VIDEO_AXIM_WREADY) begin
	            r_CRP1_LBUF_RCMP	<= 1'b1 ;
			end else begin
	            r_CRP1_LBUF_RCMP	<= 1'b0 ;
			end
		end
	end
	assign CRP1_LBUF_REN 	= s_FSM_AXIM_WR_DPRE | (s_FSM_AXIM_WR_DATA & VIDEO_AXIM_WREADY) ;
	assign CRP1_LBUF_RCMP 	= r_CRP1_LBUF_RCMP ;

	//-----------------------------------------------
	//      Output
	//-----------------------------------------------
	assign VIDEO_AXIM_AWID		= 	P_DEVICE_ID			;
	assign VIDEO_AXIM_AWADDR	= 	r_AXIM_WR_ADDR		;
	assign VIDEO_AXIM_AWLEN		= 	P_AXIM_DLEN			;
	assign VIDEO_AXIM_AWSIZE	= 	3'b110				; // 64bytes
	assign VIDEO_AXIM_AWBURST	= 	2'b01				; // INRC
	assign VIDEO_AXIM_AWLOCK	= 	1'b0				;
	assign VIDEO_AXIM_AWCACHE	= 	4'h3				;
	assign VIDEO_AXIM_AWPROT	= 	3'b000				;
	assign VIDEO_AXIM_AWQOS		= 	4'h0				;
	assign VIDEO_AXIM_AWVALID	= 	s_FSM_AXIM_WR_AVLD	;

	assign VIDEO_AXIM_WDATA		= 	CRP1_LBUF_RD		;
	assign VIDEO_AXIM_WSTRB		= 	{64{1'b1}}			;
	assign VIDEO_AXIM_WLAST		= 	s_FSM_AXIM_WR_DLST	;
	assign VIDEO_AXIM_WVALID	= 	s_FSM_AXIM_WR_DATA 	|
									s_FSM_AXIM_WR_DLST	;

	assign VIDEO_AXIM_BREADY	= 	1'b1				;

endmodule