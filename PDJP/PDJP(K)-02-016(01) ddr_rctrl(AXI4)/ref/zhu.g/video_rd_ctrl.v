// =================================================================================================
// File Name	  : video_rd_ctrl.v
// Module		  : video_rd_ctrl
// Function 	  : Video Read Control
// Type 		  : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date		   Coded by 		Contents
// 0.0.1	  2013/10/15   zhu.g	 		create new
//
// =================================================================================================
// End Revision
// =================================================================================================

// =============================================================================
// Timescale Define
// =============================================================================

`timescale 1ns / 1ps

module video_rd_ctrl  #(
	parameter 				P_SIM				= 1'b0 ,
	parameter 				P_DEVICE_ID			= 4'h0 
	)(	
	// Reset
	input	wire			XRST				, // (i) async. reset (low active)
	input	wire			CLK_MIG1_UI			, // (i) Mig ui_clk
	input	wire			CLK_VX1				, // (i) Vbyone Clock

	// 16Channel Vbyone IF
	input           		VX1_VS	    		, // (i) V-By-One Vsync
    input           		VX1_HS	    		, // (i) V-By-One Hsync
    input           		VX1_DE	    		, // (i) V-By-One Data Enable

    output  [29:0]  		VX1_VIDEO_D0   		, // (o) V-By-One Video Data Lane0
    output  [29:0]  		VX1_VIDEO_D1   		, // (o) V-By-One Video Data Lane1
    output  [29:0]  		VX1_VIDEO_D2   		, // (o) V-By-One Video Data Lane2
    output  [29:0]  		VX1_VIDEO_D3   		, // (o) V-By-One Video Data Lane3
    output  [29:0]  		VX1_VIDEO_D4   		, // (o) V-By-One Video Data Lane4
    output  [29:0]  		VX1_VIDEO_D5   		, // (o) V-By-One Video Data Lane5
    output  [29:0]  		VX1_VIDEO_D6   		, // (o) V-By-One Video Data Lane6
    output  [29:0]  		VX1_VIDEO_D7   		, // (o) V-By-One Video Data Lane7
    output 	[29:0]			VX1_VIDEO_D8     	, // (o) V-By-One Video Data Lane8
    output 	[29:0]			VX1_VIDEO_D9     	, // (o) V-By-One Video Data Lane9
    output 	[29:0]			VX1_VIDEO_D10     	, // (o) V-By-One Video Data Lane10
    output 	[29:0]			VX1_VIDEO_D11     	, // (o) V-By-One Video Data Lane11
    output	[29:0]			VX1_VIDEO_D12     	, // (o) V-By-One Video Data Lane12
    output 	[29:0]			VX1_VIDEO_D13     	, // (o) V-By-One Video Data Lane13
    output 	[29:0]			VX1_VIDEO_D14     	, // (o) V-By-One Video Data Lane14
    output 	[29:0]			VX1_VIDEO_D15     	, // (o) V-By-One Video Data Lane15
    output					VX1_VIDEO_VLD		, // (o) V-By-One Data Valid

	// Video Frame Counter
	input	wire	[ 1:0]	VIDEO_RX_FRM_WCNT	, // (i) HDMI Frame Counter
	input	wire			VIDEO_DISP_EN		, // (o) Video Output Enable

	// Master Interface Read Address Ports
	output	wire	[ 3:0]	VIDEO_AXIM_ARID		, // (o) Read address ID
	output	wire	[31:0]	VIDEO_AXIM_ARADDR	, // (o) Read address
	output	wire	[ 7:0]	VIDEO_AXIM_ARLEN	, // (o) Burst length
	output	wire	[ 2:0]	VIDEO_AXIM_ARSIZE	, // (o) Burst size
	output	wire	[ 1:0]	VIDEO_AXIM_ARBURST	, // (o) Burst type
	output	wire			VIDEO_AXIM_ARLOCK	, // (o) Lock type
	output	wire	[ 3:0]	VIDEO_AXIM_ARCACHE	, // (o) Cache type
	output	wire	[ 2:0]	VIDEO_AXIM_ARPROT	, // (o) Protection type
	output	wire	[ 3:0]	VIDEO_AXIM_ARQOS	, // (o) QoS identifier
	output	wire			VIDEO_AXIM_ARVALID	, // (o) Read address valid
	input	wire			VIDEO_AXIM_ARREADY	, // (i) Read address ready
	// Master Interface Read Data Ports
	output	wire			VIDEO_AXIM_RREADY	, // (o) Read ready
	input	wire	[ 3:0]	VIDEO_AXIM_RID		, // (i) Read ID tag
	input	wire	[511:0]	VIDEO_AXIM_RDATA	, // (i) Read data
	input	wire	[ 1:0]	VIDEO_AXIM_RRESP	, // (i) Read response
	input	wire			VIDEO_AXIM_RLAST	, // (i) Read last
	input	wire			VIDEO_AXIM_RVALID	  // (i) Read valid
) ;

// =============================================================================
// Signal Define
// =============================================================================
	parameter   P_AXIM_DLEN	    	= P_SIM ? 8'd15		: 8'd239     	; // 240 x 64B(3840x4B) - 1
	parameter   P_FRM_END_ADD	    = P_SIM ? 12'd59 	: 12'd2159     	; // 2160-1
	parameter   P_TXBUF_SFT_CNT	    = P_SIM ? 5'd1	 	: 5'd29     	; // 30-1

	parameter   P_AXIM_RD_IDLE	    = 6'h01     	; // Idle
	parameter   P_AXIM_RD_AINF    	= 6'h02     	; // Write Address And Information
	parameter   P_AXIM_RD_AVLD    	= 6'h04     	; // Write Address Valid
	parameter   P_AXIM_RD_WAIT    	= 6'h08     	; // Write Data Prepare
	parameter   P_AXIM_RD_DATA    	= 6'h10     	; // Write Data 
	parameter   P_AXIM_RD_END    	= 6'h20     	; // Write Last Data 

	//      AXI Master State Machine
	reg					r_AXIM_RD_EN				; // // DDR3 Read Enalbe
	reg		[ 5:0] 		r_AXIM_RD_FSM				; // AXI Master State Machine
	wire				s_FSM_AXIM_RD_AINF			; // Decoder Of FSM
	wire				s_FSM_AXIM_RD_AVLD			; // Decoder Of FSM
	wire				s_FSM_AXIM_RD_DATA			; // Decoder Of FSM
	wire				s_FSM_AXIM_RD_END 			; // Decoder Of FSM
	reg					r_FSM_AXIM_RD_END 			; // Decoder Of FSM

	//      DDR3 Write Address Control
	reg		[ 3:0] 		r_VX1_VS_MIG1				; // Shifter Register of VX1_VS
	wire				s_VX1_VS_NEG				; // Negedge Of VX1_VS
	reg					r_VX1_VS_NEG				; // Negedge Of VX1_VS
	reg		[31:0] 		r_AXIM_RD_ADDR				; // OSD Read Address Control
	reg					r_VX1_2ND_FRM_EN			; // Vbyone 2nd Frame Enable
	//      TX Buffer Write Control
	reg					r_VIDEO_TXBUF_WEN			; // TX Buffer Write Enable
	reg		[ 8:0]		r_VIDEO_TXBUF_WADD			; // TX Buffer Write Address
	reg		[511:0]		r_VIDEO_TXBUF_WD			; // TX Buffer Write Data
	//      TX Buffer Read Control
	reg		[ 2:0]		r_VIDEO_DISP_EN				; // Buffer Of VIDEO_DISP_EN
	reg		[ 2:0]		r_VX1_DE					; // Buffer Of VX1_DE
	reg					r_VIDEO_RD_EN				; // Video Read Enable
	wire				s_VIDEO_TXBUF_REN			; // TX Buffer Read Enable
	wire				s_VIDEO_TXBUF_RCMP			; // TX Buffer Read Complete
	reg					r_VIDEO_TXBUF_RCMP			; // TX Buffer Read Complete
	reg		[ 8:0]		r_VIDEO_TXBUF_RADD			; // TX Buffer Read Address
	wire	[511:0]		s_VIDEO_TXBUF_RD			; // TX Buffer Read Data
	reg		[ 2:0]		r_VIDEO_TXBUF_REN			; // Buffer Of s_VIDEO_TXBUF_REN
	reg		[31:0]		r_VIDEO_TXBUF_RD[0:15]		; // TX Buffer Read Data

	//      Buffer Status
	reg		[ 1:0]		r_VIDEO_TXBUF_CNT			; // TX Buffer Counter
	wire				s_VIDEO_TXBUF_FULL	 		; // TX Buffer Full

// =============================================================================
// RTL
// =============================================================================

	//-----------------------------------------------
	//      AXI Master State Machine(Read)
	//-----------------------------------------------
	// DDR3 Read Enalbe
	always @ (posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_AXIM_RD_EN <= 1'b0 ;
		end else begin
			if (!VIDEO_DISP_EN) begin
				r_AXIM_RD_EN <= 1'b0 ;
			end else if (s_FSM_AXIM_RD_END && r_AXIM_RD_ADDR[25:14] == P_FRM_END_ADD) begin	// 1 Frame End
				r_AXIM_RD_EN <= 1'b0 ;
			end else if (r_VX1_VS_NEG) begin												// 1 Frame Start
				r_AXIM_RD_EN <= 1'b1 ;
			end
		end
	end

	always @ (posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_AXIM_RD_FSM <= P_AXIM_RD_IDLE ;
		end else begin
			case (r_AXIM_RD_FSM) 
				P_AXIM_RD_IDLE : 			// IDLE
					begin
						if (r_AXIM_RD_EN && !s_VIDEO_TXBUF_FULL) begin	// Not Full
							r_AXIM_RD_FSM <= P_AXIM_RD_AINF ;
						end
					end

				P_AXIM_RD_AINF : 			// Read Address And Information
					begin
							r_AXIM_RD_FSM <= P_AXIM_RD_AVLD ;
					end

				P_AXIM_RD_AVLD : 			// Read Address Valid
					begin
						if (VIDEO_AXIM_ARREADY) begin				// Read Address Ready
							r_AXIM_RD_FSM <= P_AXIM_RD_WAIT ;
						end
					end

				P_AXIM_RD_WAIT : 			// Read Data Wait
					begin
						if (VIDEO_AXIM_RVALID) begin 				// Data Receive
							r_AXIM_RD_FSM <= P_AXIM_RD_DATA ;
						end
					end

				P_AXIM_RD_DATA : 			// Read Data 
					begin
						if (VIDEO_AXIM_RLAST) begin 				// Last Data Receive
							r_AXIM_RD_FSM <= P_AXIM_RD_END ;
						end
					end

				P_AXIM_RD_END : 			// Read Data End
					begin
						r_AXIM_RD_FSM <= P_AXIM_RD_IDLE ;
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

	// Buffer
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_FSM_AXIM_RD_END 	<= 1'b0 ;
		end else begin
            r_FSM_AXIM_RD_END 	<= s_FSM_AXIM_RD_END  ;
		end
	end


	//-----------------------------------------------
	//      DDR3 Write Address Control
	//-----------------------------------------------
	// Shifter Register of VX1_VS
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_VX1_VS_MIG1	<= {4{1'b0}} ;
		end else begin
            r_VX1_VS_MIG1	<= {r_VX1_VS_MIG1[2:0],VX1_VS} ;
		end
	end
	assign s_VX1_VS_NEG	= (r_VX1_VS_MIG1[3:2] == 2'b10) ? 1'b1 : 1'b0 ;
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_VX1_VS_NEG	<= 1'b0 ;
		end else begin
            r_VX1_VS_NEG	<= s_VX1_VS_NEG ;
		end
	end

	// Vbyone 2nd Frame Enable
	always @ (posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VX1_2ND_FRM_EN <= 1'b0 ;
		end else begin
			if (!VIDEO_DISP_EN) begin
				r_VX1_2ND_FRM_EN <= 1'b0 ;
			end else if (r_VX1_VS_NEG) begin					// 1 Frame Start
				r_VX1_2ND_FRM_EN <= 1'b1 ;
			end
		end
	end

	// [13: 0]: Horizontal 	3840x4B(16KB)
	// [25:14]: Vertical	2160(4K)
	// [28:26]: Frame		8
	// [31:29]: Unused
    always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
            r_AXIM_RD_ADDR	<= {32{1'b0}} ;
		end else begin
			if (!VIDEO_DISP_EN) begin													// Video Disable
	            r_AXIM_RD_ADDR	<= {32{1'b0}} ;
			end else if (r_VX1_VS_NEG && r_VX1_2ND_FRM_EN) begin						// 1 Frame Start
    			r_AXIM_RD_ADDR[13: 0]	<= {14{1'b0}} ;	
				r_AXIM_RD_ADDR[25:14]	<= {12{1'b0}} ;
				r_AXIM_RD_ADDR[27:26]	<= VIDEO_RX_FRM_WCNT -1 ;
				r_AXIM_RD_ADDR[31:28]	<= r_AXIM_RD_ADDR[31:28] ;
			end else if (r_FSM_AXIM_RD_END) begin										// 1 Line End
		    	r_AXIM_RD_ADDR[13: 0]	<= {14{1'b0}} ;
				r_AXIM_RD_ADDR[25:14]	<= r_AXIM_RD_ADDR[25:14] + 1 ;
				r_AXIM_RD_ADDR[27:26]	<= r_AXIM_RD_ADDR[27:26] ;
				r_AXIM_RD_ADDR[31:28]	<= r_AXIM_RD_ADDR[31:28] ;
			end
		end
	end
	//-----------------------------------------------
	//      AXI Master Output
	//-----------------------------------------------
	assign VIDEO_AXIM_ARID		= P_DEVICE_ID		;
	assign VIDEO_AXIM_ARADDR	= r_AXIM_RD_ADDR	;
	assign VIDEO_AXIM_ARLEN		= P_AXIM_DLEN		;
	assign VIDEO_AXIM_ARSIZE	= 3'b110			; // 64bytes
	assign VIDEO_AXIM_ARBURST	= 2'b01				; // INRC
	assign VIDEO_AXIM_ARLOCK	= 1'b0				;
	assign VIDEO_AXIM_ARCACHE	= 4'h3				;
	assign VIDEO_AXIM_ARPROT	= 3'b000			;
	assign VIDEO_AXIM_ARQOS		= 4'h0				;
	assign VIDEO_AXIM_ARVALID	= s_FSM_AXIM_RD_AVLD;

	assign VIDEO_AXIM_RREADY	= 1'b1				;

	//-----------------------------------------------
	//      TX Buffer Write Control
	//-----------------------------------------------

	// Write Enable
	always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_TXBUF_WEN 		<= 1'b0 ;
		end else begin
			r_VIDEO_TXBUF_WEN 		<= VIDEO_AXIM_RVALID ;
		end
	end
	// Write Address
	always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_TXBUF_WADD 	<= {9{1'b0}} ;
		end else begin
			if (!VIDEO_DISP_EN) begin											// Video Disable
				r_VIDEO_TXBUF_WADD 	<= {9{1'b0}} ;
			end else if (r_FSM_AXIM_RD_END) begin								// 1 Line Wirte End
				r_VIDEO_TXBUF_WADD[8] 		<= ~r_VIDEO_TXBUF_WADD[8] ;
				r_VIDEO_TXBUF_WADD[7:0] 	<= {8{1'b0}} ;
			end else if (r_VIDEO_TXBUF_WEN) begin
				r_VIDEO_TXBUF_WADD 	<= r_VIDEO_TXBUF_WADD + 1 ;
			end
		end
	end

	// Write Data
	always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_TXBUF_WD 	<= {512{1'b0}} ;
		end else begin
			r_VIDEO_TXBUF_WD 	<= VIDEO_AXIM_RDATA ;
		end
	end

	dpram_I_512x512_O_512x512 video_txbuf(
		.clka			(   CLK_MIG1_UI			),
		.addra			( r_VIDEO_TXBUF_WADD	),
		.dina			( r_VIDEO_TXBUF_WD		),
		.ena			( 1'b1					),
		.wea			( r_VIDEO_TXBUF_WEN		),
		.clkb			(   CLK_VX1				),
		.addrb			( r_VIDEO_TXBUF_RADD	),
		.doutb			( s_VIDEO_TXBUF_RD		),
		.enb			( s_VIDEO_TXBUF_REN		));


	//-----------------------------------------------
	//      TX Buffer Read Control
	//-----------------------------------------------
	// Buffer 
	always @(posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_DISP_EN <= {3{1'b0}} ;
			r_VX1_DE 		<= {3{1'b0}} ;
		end else begin
			r_VIDEO_DISP_EN <= {r_VIDEO_DISP_EN[1:0],VIDEO_DISP_EN} ;
			r_VX1_DE 		<= {r_VX1_DE[1:0],VX1_DE} ;
		end
	end

	// Video Read Enable
	always @(posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_RD_EN <= 1'b0 ;
		end else begin
			if (r_VIDEO_DISP_EN[2]) begin
				if (VX1_VS) begin
					r_VIDEO_RD_EN <= 1'b1 ;
				end
			end else begin
				r_VIDEO_RD_EN <= 1'b0 ;
			end
		end
	end

	// Read Enable
	assign s_VIDEO_TXBUF_REN 	= r_VX1_DE[0] & r_VIDEO_RD_EN;

	// Read Complete
	assign s_VIDEO_TXBUF_RCMP	= (r_VX1_DE[2:1] == 2'b10 && r_VIDEO_RD_EN) ? 1'b1 : 1'b0 ;
	always @(posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_TXBUF_RCMP <= 1'b0 ;
		end else begin
			r_VIDEO_TXBUF_RCMP <= s_VIDEO_TXBUF_RCMP ;
		end
	end

	// Read Address
	always @(posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_TXBUF_RADD 	<= {9{1'b0}} ;
		end else begin
			if (!r_VIDEO_DISP_EN[2]) begin									// Video Disable
				r_VIDEO_TXBUF_RADD 	<= {9{1'b0}} ;
			end else if (s_VIDEO_TXBUF_RCMP) begin							// 1 Line Wirte End
				r_VIDEO_TXBUF_RADD[8] 		<= ~r_VIDEO_TXBUF_RADD[8] ;
				r_VIDEO_TXBUF_RADD[7:0] 	<= {8{1'b0}} ;
			end else if (s_VIDEO_TXBUF_REN) begin
				r_VIDEO_TXBUF_RADD 			<= r_VIDEO_TXBUF_RADD + 1 ;
			end
		end
	end

	// Buffer Of s_VIDEO_TXBUF_REN
	always @(posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_TXBUF_REN 	<= {2{1'b0}} ;
		end else begin
			r_VIDEO_TXBUF_REN 	<= {r_VIDEO_TXBUF_REN[0],s_VIDEO_TXBUF_REN} ;
		end
	end

  	genvar i;
  	generate
    for(i = 0; i < 16; i = i+1) begin: video_data
	always @(posedge CLK_VX1 or negedge XRST) begin
		if ( !XRST ) begin
			r_VIDEO_TXBUF_RD[i]	<= {32{1'b0}} ;
		end else begin
			r_VIDEO_TXBUF_RD[i]	<= s_VIDEO_TXBUF_RD[i*32+31:i*32] ;
		end
	end
	end
	endgenerate

	assign VX1_VIDEO_VLD 	= r_VIDEO_TXBUF_REN[1] ;
	assign VX1_VIDEO_D0 	= r_VIDEO_TXBUF_RD[0] ;
	assign VX1_VIDEO_D1 	= r_VIDEO_TXBUF_RD[1] ;
	assign VX1_VIDEO_D2 	= r_VIDEO_TXBUF_RD[2] ;
	assign VX1_VIDEO_D3 	= r_VIDEO_TXBUF_RD[3] ;
	assign VX1_VIDEO_D4 	= r_VIDEO_TXBUF_RD[4] ;
	assign VX1_VIDEO_D5 	= r_VIDEO_TXBUF_RD[5] ;
	assign VX1_VIDEO_D6 	= r_VIDEO_TXBUF_RD[6] ;
	assign VX1_VIDEO_D7 	= r_VIDEO_TXBUF_RD[7] ;
	assign VX1_VIDEO_D8 	= r_VIDEO_TXBUF_RD[8] ;
	assign VX1_VIDEO_D9 	= r_VIDEO_TXBUF_RD[9] ;
	assign VX1_VIDEO_D10	= r_VIDEO_TXBUF_RD[10] ;
	assign VX1_VIDEO_D11	= r_VIDEO_TXBUF_RD[11] ;
	assign VX1_VIDEO_D12	= r_VIDEO_TXBUF_RD[12] ;
	assign VX1_VIDEO_D13	= r_VIDEO_TXBUF_RD[13] ;
	assign VX1_VIDEO_D14	= r_VIDEO_TXBUF_RD[14] ;
	assign VX1_VIDEO_D15	= r_VIDEO_TXBUF_RD[15] ;

	//-----------------------------------------------
	//     (HDMI1) Buffer Status
	//-----------------------------------------------
    pulse_gen u_pg_wend (
        .XRST       ( XRST          			) ,   // (i)
        .CLK_I      ( CLK_VX1      				) ,   // (i)
        .CLK_O      ( CLK_MIG1_UI 				) ,   // (i)
        .PULSE_I    ( s_VIDEO_TXBUF_RCMP		) ,   // (i)
        .PULSE_O    ( s_VIDEO_TXBUF_RCMP_MIG	)     // (o)
    ) ;

	always @(posedge CLK_MIG1_UI or negedge XRST) begin
		if(!XRST) begin
			r_VIDEO_TXBUF_CNT	<= 2'b00 ;
		end else begin
			if (!VIDEO_DISP_EN) begin														// Video Disable
				r_VIDEO_TXBUF_CNT	<= 2'b00 ;
			end else if (s_FSM_AXIM_RD_END == 1'b1 && s_VIDEO_TXBUF_RCMP_MIG == 1'b0) begin	// Write 1 Line
				r_VIDEO_TXBUF_CNT	<= r_VIDEO_TXBUF_CNT + 1 ;
			end else if (s_FSM_AXIM_RD_END == 1'b0 && s_VIDEO_TXBUF_RCMP_MIG == 1'b1) begin	// Read 1 Line
				r_VIDEO_TXBUF_CNT	<= r_VIDEO_TXBUF_CNT - 1 ;
			end 
		end
	end

	// Buffer Status
	assign s_VIDEO_TXBUF_FULL 	= (r_VIDEO_TXBUF_CNT == 2'b10) ? 1'b1 :1'b0 ;

endmodule