// =================================================================================================
// Copyright(C)	2007- TOKYO	ELECTRON DEVICE	LIMITED. All rigths	reserved.
// =================================================================================================

// =================================================================================================
// File	Name		:	video_tim_gen.v
// Module			:	video_tim_gen
// Function			:	Video Timing Generation
// Type				:	RTL
// -------------------------------------------------------------------------------------------------
// Update History	:
// -------------------------------------------------------------------------------------------------
// Rev.Level	Date		Coded by		Contents
// 0.0.1	  2013/12/17   TEDWX)zhu.g		create new
// 1.0.4	  2014/07/18   TEDWX)zhu.g		Vbyone Vidio Timing Adjust
//
// =================================================================================================
// End Revision
// =================================================================================================

`timescale 1ns/1ps

module video_tim_gen
(
	CLK					,	// (i) Clock input
	XRST				,	// (i) Reset

	VTGEN_EN			,	// (i) Video Timing Generating Enable

	REG_VX1_LINE_PARA	,   // (o) Register VX1 Timing Gen Line Parameter	
	REG_VX1_INI_PARA	,   // (o) Register VX1 Timing Gen Initial Parameter	
	REG_DVIMODE			,	// (i) DVI Output Mode Set

	V_HBLANK			,	// (o) Video H-Blank output
	V_VBLANK			,	// (o) Video V-Blank output
	V_FIELD				,	// (o) Video Field output (1:odd,0:even)
	V_HSYNC				,	// (o) Video H-Sync output
	V_VSYNC				,	// (o) Video V-Sync output
	V_DE					// (o) Video Data Enable output
);

//==============================================================================
// Signal &	Parameter Declaration
//==============================================================================

	//--------------------------------------------------------------------------
	//	Inputs and Outputs Delcaration
	//--------------------------------------------------------------------------
	input				CLK					; // (i) Clock input
	input				XRST				; // (i) Reset
                                              
	input				VTGEN_EN			; // (i) Video Timing Generating Enable
                                              
	input	[31:0]		REG_VX1_LINE_PARA	; // (i) Register VX1 Timing Gen Line Parameter	
	input	[31:0]		REG_VX1_INI_PARA	; // (i) Register VX1 Timing Gen Initial Parameter	
	input	[ 2:0]		REG_DVIMODE			; // (i) DVI Output Mode Set
                                              
	output				V_HBLANK			; // (o) Video H-Blank output
	output				V_VBLANK			; // (o) Video V-Blank output
	output				V_FIELD				; // (o) Video Field output (1:odd,0:even)
	output	[ 7:0]		V_HSYNC				; // (o) Video H-Sync output
	output	[ 7:0]		V_VSYNC				; // (o) Video V-Sync output
	output	[ 7:0]		V_DE				; // (o) Video Data Enable output

	//--------------------------------------------------------------------------
	//	Internal Used Signals' Declaration
	//--------------------------------------------------------------------------


	//	240	x 2160 120p, clk = 74.25M
	parameter	p_dvi0_hsync		= 275,		// total pixel/line
				p_dvi0_hvalid		= 240,		// valid pixel/line
				p_dvi0_hftporch		=  11,		// hsync front porch
				p_dvi0_hsync_lw		=   6,		// hsync low-pulse width
				p_dvi0_hbkporch		=  18,		// hsync back porch
				p_dvi0_vsync		=2250,		// total line/fram
				p_dvi0_vvalid		=2160,		// valid line/frame
// [Begin] Modify at Ver1.04
//				p_dvi0_vftporch		=   8,		// vsync front porch
				p_dvi0_vftporch		=  72,		// vsync front porch
// [End]   Modify at Ver1.04
				p_dvi0_vsync_lw		=  10,		// vsync low-pulse width
// [Begin] Modify at Ver1.04
//				p_dvi0_vbkporch		=  72;		// vsync back porch
				p_dvi0_vbkporch		=   8;		// vsync back porch
// [End]   Modify at Ver1.04

	//	240	x 2160 120p, clk = 74.25M
	parameter	p_dvi1_hsync		= 275,		// total pixel/line
				p_dvi1_hvalid		= 240,		// valid pixel/line
				p_dvi1_hftporch		=  11,		// hsync front porch
				p_dvi1_hsync_lw		=   6,		// hsync low-pulse width
				p_dvi1_hbkporch		=  18,		// hsync back porch
				p_dvi1_vsync		=2250,		// total line/fram
				p_dvi1_vvalid		=2160,		// valid line/frame
				p_dvi1_vftporch		=   8,		// vsync front porch
				p_dvi1_vsync_lw		=  10,		// vsync low-pulse width
				p_dvi1_vbkporch		=  72;		// vsync back porch

	//	16	x 60 120p, clk = 74.25M
	parameter	p_dvi2_hsync		= 171,		// total pixel/line
				p_dvi2_hvalid		=  16,		// valid pixel/line
				p_dvi2_hftporch		=  21,		// hsync front porch
				p_dvi2_hsync_lw		=  16,		// hsync low-pulse width
				p_dvi2_hbkporch		= 118,		// hsync back porch
				p_dvi2_vsync		=  75,		// total line/fram
				p_dvi2_vvalid		=  60,		// valid line/frame
				p_dvi2_vftporch		=   4,		// vsync front porch
				p_dvi2_vsync_lw		=   5,		// vsync low-pulse width
				p_dvi2_vbkporch		=   6;		// vsync back porch

	//	1920 x 1080	60p, clk = 148.5M
	parameter	p_dvi3_hsync		=2200,		// total pixel/line
				p_dvi3_hvalid		=1920,		// valid pixel/line
				p_dvi3_hftporch		=  88,		// hsync front porch
				p_dvi3_hsync_lw		=  44,		// hsync low-pulse width
				p_dvi3_hbkporch		= 148,		// hsync back porch
				p_dvi3_vsync		=1125,		// total line/fram
				p_dvi3_vvalid		=1080,		// valid line/frame
				p_dvi3_vftporch		=   4,		// vsync front porch
				p_dvi3_vsync_lw		=   5,		// vsync low-pulse width
				p_dvi3_vbkporch		=  36;		// vsync back porch

	//	120 x 60	60p, clk = 148.5M
	parameter	p_dvi4_hsync		= 408,		// total pixel/line
				p_dvi4_hvalid		= 128,		// valid pixel/line
				p_dvi4_hftporch		=  88,		// hsync front porch
				p_dvi4_hsync_lw		=  44,		// hsync low-pulse width
				p_dvi4_hbkporch		= 148,		// hsync back porch
				p_dvi4_vsync		=  75,		// total line/fram
				p_dvi4_vvalid		=  60,		// valid line/frame
				p_dvi4_vftporch		=   4,		// vsync front porch
				p_dvi4_vsync_lw		=   5,		// vsync low-pulse width
				p_dvi4_vbkporch		=   6;		// vsync back porch


	wire	[12:0]		s_dvi0_vsync		;
	wire	[12:0]		s_dvi0_vbkporch		;
	wire	[12:0]		s_dvi0_vftporch		;
	

	wire	[12:0]		s_dvi_hsync_cyc		;
	wire	[12:0]		s_dvi_hsync_f1		;
	wire	[12:0]		s_dvi_hsync_r1		;
	wire	[12:0]		s_dvi_hsync_f2		;
	wire	[12:0]		s_dvi_hsync_r2		;
	wire	[12:0]		s_dvi_hblank_f		;
	wire	[12:0]		s_dvi_hblank_r		;
	wire	[12:0]		s_dvi_heqspulse_f1	;
	wire	[12:0]		s_dvi_heqspulse_r1	;
	wire	[12:0]		s_dvi_heqspulse_f2	;
	wire	[12:0]		s_dvi_heqspulse_r2	;
	wire	[12:0]		s_dvi_hserpulse_f1	;
	wire	[12:0]		s_dvi_hserpulse_r1	;
	wire	[12:0]		s_dvi_hserpulse_f2	;
	wire	[12:0]		s_dvi_hserpulse_r2	;
	wire	[12:0]		s_dvi_vsync_cyc		;
	wire	[12:0]		s_dvi_vsync_f1		;
	wire	[12:0]		s_dvi_vsync_r1		;
	wire	[12:0]		s_dvi_vsync_f2		;
	wire	[12:0]		s_dvi_vsync_r2		;
	wire	[12:0]		s_dvi_vblank_f1		;
	wire	[12:0]		s_dvi_vblank_r1		;
	wire	[12:0]		s_dvi_vblank_f2		;
	wire	[12:0]		s_dvi_vblank_r2		;

	reg		[ 2:0]		R_VTGEN_EN			;
	reg		[12:0]		R_HPIXEL_CNT		;
	reg					R_HBLANK			;
	reg					R_HSYNC				;
	reg					R_HEQSPULSE			;
	reg					R_HSERPULSE			;
	reg		[12:0]		R_VLINE_CNT			;
	reg					R_VBLANK			;
	reg					R_VSYNC				;
	reg					R_VEQSPULSE			;
	reg					R_ODD_FIELD			;
	wire				S_CSYNC				;

	reg		[15:0]		R_HS_OUT_BF			;
	reg		[15:0]		R_VS_OUT_BF			;
	reg		[15:0]		R_BL_OUT_BF			;
	reg		[ 3:0]		R_CS_OUT_BF			;

	reg		[ 3:0]		R_HBLK_OUT_BF		;
	reg		[ 3:0]		R_VBLK_OUT_BF		;
	reg		[ 3:0]		R_FIELD_OUT_BF		;

	wire	[12:0]		s_hdec_hsync_cyc	;
	wire	[12:0]		s_hdec_hsync_r1		;
	wire	[12:0]		s_hdec_hsync_f1		;
	wire	[12:0]		s_hdec_hsync_r2		;
	wire	[12:0]		s_hdec_hsync_f2		;
	wire	[12:0]		s_hdec_hblank_r		;
	wire	[12:0]		s_hdec_hblank_f		;
	wire	[12:0]		s_hdec_heqspulse_f1	;
	wire	[12:0]		s_hdec_heqspulse_r1	;
	wire	[12:0]		s_hdec_heqspulse_f2	;
	wire	[12:0]		s_hdec_heqspulse_r2	;
	wire	[12:0]		s_hdec_hserpulse_f1	;
	wire	[12:0]		s_hdec_hserpulse_r1	;
	wire	[12:0]		s_hdec_hserpulse_f2	;
	wire	[12:0]		s_hdec_hserpulse_r2	;
	wire	[12:0]		s_vdec_vsync_cyc	;
	wire	[12:0]		s_vdec_vsync_f1		;
	wire	[12:0]		s_vdec_vsync_r1		;
	wire	[12:0]		s_vdec_vsync_f2		;
	wire	[12:0]		s_vdec_vsync_r2		;
	wire	[12:0]		s_vdec_vblank_f1	;
	wire	[12:0]		s_vdec_vblank_r1	;
	wire	[12:0]		s_vdec_vblank_f2	;
	wire	[12:0]		s_vdec_vblank_r2	;
	wire	[12:0]		s_vdec_veqs_f1		;
	wire	[12:0]		s_vdec_veqs_r1		;
	wire	[12:0]		s_vdec_veqs_f2		;
	wire	[12:0]		s_vdec_veqs_r2		;


//==============================================================================
//	RTL	Body
//==============================================================================


	assign s_dvi_hsync_cyc		=	(REG_DVIMODE==0) ?	(p_dvi0_hsync)	:
									(REG_DVIMODE==1) ?	(p_dvi1_hsync)	:
									(REG_DVIMODE==2) ?	(p_dvi2_hsync)	:
									(REG_DVIMODE==3) ?	(p_dvi3_hsync)	:
														(p_dvi4_hsync)	;

	assign s_dvi_hsync_f1		=	(REG_DVIMODE==0) ?	(p_dvi0_hftporch)	:
									(REG_DVIMODE==1) ?	(p_dvi1_hftporch)	:
									(REG_DVIMODE==2) ?	(p_dvi2_hftporch)	:
									(REG_DVIMODE==3) ?	(p_dvi3_hftporch)	:
														(p_dvi4_hftporch)	;

	assign s_dvi_hsync_r1		=	(REG_DVIMODE==0) ?	(p_dvi0_hftporch + p_dvi0_hsync_lw)	:
									(REG_DVIMODE==1) ?	(p_dvi1_hftporch + p_dvi1_hsync_lw)	:
									(REG_DVIMODE==2) ?	(p_dvi2_hftporch + p_dvi2_hsync_lw)	:
									(REG_DVIMODE==3) ?	(p_dvi3_hftporch + p_dvi3_hsync_lw)	:
														(p_dvi4_hftporch + p_dvi4_hsync_lw)	;

	assign s_dvi_hsync_f2		=	(REG_DVIMODE==0) ?	(p_dvi0_hftporch + p_dvi0_hsync/2)	:
									(REG_DVIMODE==1) ?	(p_dvi1_hftporch + p_dvi1_hsync/2)	:
									(REG_DVIMODE==2) ?	(p_dvi2_hftporch + p_dvi2_hsync/2)	:
									(REG_DVIMODE==3) ?	(p_dvi3_hftporch + p_dvi3_hsync/2)	:
														(p_dvi4_hftporch + p_dvi4_hsync/2)	;

	assign s_dvi_hsync_r2		=	(REG_DVIMODE==0) ?	(p_dvi0_hftporch + p_dvi0_hsync/2 +	p_dvi0_hsync_lw)	:
									(REG_DVIMODE==1) ?	(p_dvi1_hftporch + p_dvi1_hsync/2 +	p_dvi1_hsync_lw)	:
									(REG_DVIMODE==2) ?	(p_dvi2_hftporch + p_dvi2_hsync/2 +	p_dvi2_hsync_lw)	:
									(REG_DVIMODE==3) ?	(p_dvi3_hftporch + p_dvi3_hsync/2 +	p_dvi3_hsync_lw)	:
														(p_dvi4_hftporch + p_dvi4_hsync/2 +	p_dvi3_hsync_lw)	;

	assign s_dvi_hblank_f		=	(REG_DVIMODE==0) ?	(p_dvi0_hsync)	:
									(REG_DVIMODE==1) ?	(p_dvi1_hsync)	:
									(REG_DVIMODE==2) ?	(p_dvi2_hsync)	:
									(REG_DVIMODE==3) ?	(p_dvi3_hsync)	:
														(p_dvi4_hsync)	;

	assign s_dvi_hblank_r		=	(REG_DVIMODE==0) ?	(p_dvi0_hftporch + p_dvi0_hsync_lw + p_dvi0_hbkporch)	:
									(REG_DVIMODE==1) ?	(p_dvi1_hftporch + p_dvi1_hsync_lw + p_dvi1_hbkporch)	:
									(REG_DVIMODE==2) ?	(p_dvi2_hftporch + p_dvi2_hsync_lw + p_dvi2_hbkporch)	:
									(REG_DVIMODE==3) ?	(p_dvi3_hftporch + p_dvi3_hsync_lw + p_dvi3_hbkporch)	:
														(p_dvi4_hftporch + p_dvi4_hsync_lw + p_dvi4_hbkporch)	;

	assign s_dvi_heqspulse_f1	=	s_dvi_hsync_f1 ;

	assign s_dvi_heqspulse_r1	=	s_dvi_hsync_r1 ;

	assign s_dvi_heqspulse_f2	=	s_dvi_hsync_f2 ;

	assign s_dvi_heqspulse_r2	=	s_dvi_hsync_r2 ;

	assign s_dvi_hserpulse_f1	=	s_dvi_hsync_f1 ;
	assign s_dvi_hserpulse_r1	=	s_dvi_hsync_r1 ;
	assign s_dvi_hserpulse_f2	=	s_dvi_hsync_f2 ;
	assign s_dvi_hserpulse_r2	=	s_dvi_hsync_r2 ;


	assign s_dvi0_vsync 		= 	REG_VX1_LINE_PARA[31] ?	p_dvi0_vsync - REG_VX1_LINE_PARA[12:0]  :
															p_dvi0_vsync + REG_VX1_LINE_PARA[12:0]  ;
// [Begin] Modify at Ver1.04
//	assign s_dvi0_vbkporch		=	REG_VX1_LINE_PARA[31] ?	p_dvi0_vbkporch - REG_VX1_LINE_PARA[12:0] :
//															p_dvi0_vbkporch + REG_VX1_LINE_PARA[12:0] ;
	assign s_dvi0_vbkporch		=	p_dvi0_vbkporch ;


	assign s_dvi0_vftporch		=	REG_VX1_LINE_PARA[31] ?	p_dvi0_vftporch - REG_VX1_LINE_PARA[12:0] :
															p_dvi0_vftporch + REG_VX1_LINE_PARA[12:0] ;
// [End]   Modify at Ver1.04



	assign s_dvi_vsync_cyc		=	(REG_DVIMODE==0) ?	(s_dvi0_vsync)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vsync)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vsync)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vsync)	:
														(p_dvi4_vsync)	;

	assign s_dvi_vsync_f1		=	(REG_DVIMODE==0) ?	(s_dvi0_vftporch)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vftporch)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vftporch)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vftporch)	:
														(p_dvi4_vftporch)	;

	assign s_dvi_vsync_r1		=	(REG_DVIMODE==0) ?	(s_dvi0_vftporch + p_dvi0_vsync_lw)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vftporch + p_dvi1_vsync_lw)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vftporch + p_dvi2_vsync_lw)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vftporch + p_dvi3_vsync_lw)	:
														(p_dvi4_vftporch + p_dvi4_vsync_lw)	;

	assign s_dvi_vsync_f2		=	(REG_DVIMODE==0) ?	(s_dvi0_vftporch + s_dvi0_vsync/2)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vftporch + p_dvi1_vsync/2)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vftporch + p_dvi2_vsync/2)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vftporch + p_dvi3_vsync/2)	:
														(p_dvi4_vftporch + p_dvi4_vsync/2)	;

	assign s_dvi_vsync_r2		=	(REG_DVIMODE==0) ?	(s_dvi0_vftporch + s_dvi0_vsync/2 +	p_dvi0_vsync_lw)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vftporch + p_dvi1_vsync/2 +	p_dvi1_vsync_lw)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vftporch + p_dvi2_vsync/2 +	p_dvi2_vsync_lw)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vftporch + p_dvi3_vsync/2 +	p_dvi3_vsync_lw)	:
														(p_dvi4_vftporch + p_dvi4_vsync/2 +	p_dvi4_vsync_lw)	;

	assign s_dvi_vblank_f1		=	(REG_DVIMODE==0) ?	(s_dvi0_vsync)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vsync)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vsync)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vsync)	:
														(p_dvi4_vsync)	;

	assign s_dvi_vblank_r1		=	(REG_DVIMODE==0) ?	(s_dvi0_vftporch + p_dvi0_vsync_lw + s_dvi0_vbkporch)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vftporch + p_dvi1_vsync_lw + p_dvi1_vbkporch)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vftporch + p_dvi2_vsync_lw + p_dvi2_vbkporch)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vftporch + p_dvi3_vsync_lw + p_dvi3_vbkporch)	:
														(p_dvi4_vftporch + p_dvi4_vsync_lw + p_dvi4_vbkporch)	;

	assign s_dvi_vblank_f2		=	(REG_DVIMODE==0) ?	(s_dvi0_vsync/2)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vsync/2)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vsync/2)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vsync/2)	:
														(p_dvi4_vsync/2)	;

	assign s_dvi_vblank_r2		=	(REG_DVIMODE==0) ?	(s_dvi0_vftporch + s_dvi0_vsync/2 +	p_dvi0_vsync_lw	+ s_dvi0_vbkporch)	:
									(REG_DVIMODE==1) ?	(p_dvi1_vftporch + p_dvi1_vsync/2 +	p_dvi1_vsync_lw	+ p_dvi1_vbkporch)	:
									(REG_DVIMODE==2) ?	(p_dvi2_vftporch + p_dvi2_vsync/2 +	p_dvi2_vsync_lw	+ p_dvi2_vbkporch)	:
									(REG_DVIMODE==3) ?	(p_dvi3_vftporch + p_dvi3_vsync/2 +	p_dvi3_vsync_lw	+ p_dvi3_vbkporch)	:
														(p_dvi4_vftporch + p_dvi4_vsync/2 +	p_dvi4_vsync_lw	+ p_dvi4_vbkporch)	;


	//--------------------------------------------------------------------------
	//		Hpixel/Vline Counter Timing-Parameter Decoder
	//--------------------------------------------------------------------------

	assign s_hdec_hsync_cyc		= s_dvi_hsync_cyc		;
	assign s_hdec_hsync_r1		= s_dvi_hsync_r1		;
	assign s_hdec_hsync_f1		= s_dvi_hsync_f1		;
	assign s_hdec_hsync_r2		= s_dvi_hsync_r2		;
	assign s_hdec_hsync_f2		= s_dvi_hsync_f2		;
	assign s_hdec_hblank_r		= s_dvi_hblank_r		;
	assign s_hdec_hblank_f		= s_dvi_hblank_f		;
	assign s_hdec_heqspulse_f1	= s_dvi_heqspulse_f1	;
	assign s_hdec_heqspulse_r1	= s_dvi_heqspulse_r1	;
	assign s_hdec_heqspulse_f2	= s_dvi_heqspulse_f2	;
	assign s_hdec_heqspulse_r2	= s_dvi_heqspulse_r2	;
	assign s_hdec_hserpulse_f1	= s_dvi_hserpulse_f1	;
	assign s_hdec_hserpulse_r1	= s_dvi_hserpulse_r1	;
	assign s_hdec_hserpulse_f2	= s_dvi_hserpulse_f2	;
	assign s_hdec_hserpulse_r2	= s_dvi_hserpulse_r2	;

	assign s_vdec_vsync_cyc		= s_dvi_vsync_cyc		;
	assign s_vdec_vsync_f1		= s_dvi_vsync_f1		;
	assign s_vdec_vsync_r1		= s_dvi_vsync_r1		;
	assign s_vdec_vsync_f2		= s_dvi_vsync_f2		;
	assign s_vdec_vsync_r2		= s_dvi_vsync_r2		;
	assign s_vdec_vblank_f1		= s_dvi_vblank_f1		;
	assign s_vdec_vblank_r1		= s_dvi_vblank_r1		;
	assign s_vdec_vblank_f2		= s_dvi_vblank_f2		;
	assign s_vdec_vblank_r2		= s_dvi_vblank_r2		;
	assign s_vdec_veqs_f1		= 10'd0					;
	assign s_vdec_veqs_r1		= 10'd0					;
	assign s_vdec_veqs_f2		= 10'd0					;
	assign s_vdec_veqs_r2		= 10'd0					;

	//-------------------------------------------------------
	//		Video Horizonal-Timing Generation
	//-------------------------------------------------------
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_VTGEN_EN <= 3'h0 ;
		end	else begin
			R_VTGEN_EN <= {R_VTGEN_EN[1:0],VTGEN_EN} ;
		end
	end
	// Horizonal-Pixel Counter
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_HPIXEL_CNT <=	s_hdec_hsync_f1 + 1 ;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if ( R_HPIXEL_CNT ==	s_hdec_hsync_cyc ) begin
					R_HPIXEL_CNT <=	1;
				end	else begin
					R_HPIXEL_CNT <=	R_HPIXEL_CNT + 1;
				end
			end	else begin
				R_HPIXEL_CNT <=	s_hdec_hsync_f1 + 1 ;
//				R_HPIXEL_CNT <=	REG_VX1_INI_PARA[12:0] ;
			end
		end
	end

	// HBlank signal generating
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_HBLANK <=	1'b0;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if (R_HPIXEL_CNT ==	s_hdec_hblank_f) begin
					R_HBLANK <=	1'b0;
				end	else if	(R_HPIXEL_CNT == s_hdec_hblank_r) begin
					R_HBLANK <=	1'b1;
				end
			end	else begin
				R_HBLANK <=	1'b0;
			end
		end
	end

	// HSync signal	generating
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_HSYNC	<= 1'b0;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
//				if (R_HPIXEL_CNT ==	s_hdec_hsync_f1) begin
//					R_HSYNC	<= 1'b1;
//				end	else if	(R_HPIXEL_CNT == s_hdec_hsync_r1)  begin
//					R_HSYNC	<= 1'b0;
//				end
				if (R_HPIXEL_CNT >=	s_hdec_hsync_f1 && R_HPIXEL_CNT < s_hdec_hsync_r1) begin
					R_HSYNC	<= 1'b1;
				end else begin
					R_HSYNC	<= 1'b0;
				end
			end	else begin
				R_HSYNC	<= 1'b0;
			end
		end
	end

	// Equation	pulse generating
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_HEQSPULSE <= 1'b1;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if ((R_HPIXEL_CNT == s_hdec_heqspulse_f1) ||
					(R_HPIXEL_CNT == s_hdec_heqspulse_f2) )	begin
					R_HEQSPULSE <= 1'b0;
				end	else if	((R_HPIXEL_CNT == s_hdec_heqspulse_r1)||
							 (R_HPIXEL_CNT == s_hdec_heqspulse_r2))	 begin
					R_HEQSPULSE <= 1'b1;
				end
			end	else begin
				R_HEQSPULSE <= 1'b1;
			end
		end
	end

	// Serration pulse generating
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_HSERPULSE <= 1'b1;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if ((R_HPIXEL_CNT == s_hdec_hserpulse_f1) ||
					(R_HPIXEL_CNT == s_hdec_hserpulse_f2) )	begin
					R_HSERPULSE <= 1'b0;
				end	else if	((R_HPIXEL_CNT == s_hdec_hserpulse_r1)||
							 (R_HPIXEL_CNT == s_hdec_hserpulse_r2))	 begin
					R_HSERPULSE <= 1'b1;
				end
			end	else begin
				R_HSERPULSE <= 1'b1;
			end
		end
	end

	//-------------------------------------------------------
	//		Video Horizonal-Timing Generation
	//-------------------------------------------------------
	// Vertical-Line counter
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_VLINE_CNT	<= s_vdec_vsync_f1 - 1 ;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if (R_HPIXEL_CNT ==	s_hdec_hsync_f1	) begin
					if (R_VLINE_CNT	 ==	s_vdec_vsync_cyc) begin
						R_VLINE_CNT	<= 1;
					end	else begin
						R_VLINE_CNT	<= R_VLINE_CNT + 1;
					end
				end
			end	else begin
				R_VLINE_CNT	<= s_vdec_vsync_f1 - 1 ;
//				R_VLINE_CNT	<= REG_VX1_INI_PARA[28:16] ;
			end
		end
	end

	// VBlank signal generating
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_VBLANK <=	1'b0;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if ( R_HPIXEL_CNT == s_hdec_hsync_f1 ) begin
//					if ( (R_VLINE_CNT ==	s_vdec_vblank_f1) || (R_VLINE_CNT == s_vdec_vblank_f2) ) begin
					if ( R_VLINE_CNT ==	s_vdec_vblank_f1 ) begin
						R_VBLANK <=	1'b0;
//					end	else if	( (R_VLINE_CNT == s_vdec_vblank_r1) || (R_VLINE_CNT == s_vdec_vblank_r2) ) begin
					end	else if	( R_VLINE_CNT == s_vdec_vblank_r1 ) begin
						R_VBLANK <=	1'b1;
					end
				end
			end	else begin
				R_VBLANK <=	1'b0;
			end
		end
	end

	// Vsync signal	generating
	// Odd/Even	field signal generating
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_ODD_FIELD	<= 1'b0	;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if (R_HPIXEL_CNT ==	s_hdec_hsync_f1) begin
					if ((R_VLINE_CNT ==	s_vdec_vsync_f1))begin
						R_ODD_FIELD	<= 1'b1	;
					end
				end	else begin
					if (R_HPIXEL_CNT ==	s_hdec_hsync_f2) begin
						if ((R_VLINE_CNT ==	s_vdec_vsync_f2))begin
							R_ODD_FIELD	<= 1'b0	;
						end
					end
				end
			end	else begin
				R_ODD_FIELD	<= 1'b0	;
			end
		end
	end

	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_VSYNC	<= 1'b0;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if (R_HPIXEL_CNT ==	s_hdec_hsync_f1) begin
					if (R_VLINE_CNT >=	s_vdec_vsync_f1 && R_VLINE_CNT < s_vdec_vsync_r1)begin
						R_VSYNC	<= 1'b1;
					end	else begin
						R_VSYNC	<= 1'b0;
					end
				end
			end	else begin
				R_VSYNC	<= 1'b0;
			end
		end
	end

	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_VEQSPULSE	<= 1'b0;
		end	else begin
			if ( R_VTGEN_EN[2] )	begin
				if (R_HPIXEL_CNT ==	s_hdec_hsync_f1) begin
					if ((R_VLINE_CNT ==	s_vdec_veqs_f1))begin
						R_VEQSPULSE	<= 1'b0;
					end	else if	(R_VLINE_CNT ==	s_vdec_veqs_r1)begin
						R_VEQSPULSE	<= 1'b1;
					end
				end	else begin
					if (R_HPIXEL_CNT ==	s_hdec_hsync_f2) begin
						if ((R_VLINE_CNT ==	s_vdec_veqs_f2))begin
							R_VEQSPULSE	<= 1'b0;
						end	else if	(R_VLINE_CNT ==	s_vdec_veqs_r2)begin
							R_VEQSPULSE	<= 1'b1;
						end
					end
				end
			end	else begin
				R_VEQSPULSE	<= 1'b0;
			end
		end
	end

	// Csync signal	generating
//	assign S_CSYNC = (R_VBLANK & R_VSYNC & R_HSYNC)	| (!R_VBLANK & R_VSYNC & R_HEQSPULSE) | (!R_VBLANK & !R_VSYNC & R_HSERPULSE) ;
	assign S_CSYNC = (R_VEQSPULSE & R_VSYNC & R_HSYNC)	| (!R_VEQSPULSE & R_VSYNC & R_HEQSPULSE) | (!R_VEQSPULSE & !R_VSYNC & R_HSERPULSE) ;

	// --------------------------------------------------
	// output signals for video	encoder	output
	// --------------------------------------------------
	always @(posedge CLK or negedge XRST) begin
		if (XRST == 1'b0) begin
			R_HS_OUT_BF		<= 16'h0000 ;
			R_VS_OUT_BF		<= 16'h0000 ;
			R_BL_OUT_BF		<= 16'h0000 ;

			R_HBLK_OUT_BF	<= 4'b0000 ;
			R_VBLK_OUT_BF	<= 4'b0000 ;
			R_CS_OUT_BF		<= 4'b0000 ;
			R_FIELD_OUT_BF	<= 4'b0000 ;
		end	else begin
			R_HS_OUT_BF		<= {R_HS_OUT_BF[14:0], R_HSYNC } ;
			R_VS_OUT_BF		<= {R_VS_OUT_BF[14:0], R_VSYNC } ;
			R_BL_OUT_BF		<= {R_BL_OUT_BF[14:0], R_VBLANK & R_HBLANK } ;

			R_HBLK_OUT_BF	<= {R_HBLK_OUT_BF[2:0], R_HBLANK & R_VBLANK } ;
			R_VBLK_OUT_BF	<= {R_VBLK_OUT_BF[2:0], R_VBLANK } ;
			R_CS_OUT_BF		<= {R_CS_OUT_BF[2:0], S_CSYNC } ;
			R_FIELD_OUT_BF	<= {R_FIELD_OUT_BF[2:0], R_ODD_FIELD } ;
		end
	end

	assign V_HSYNC	 = R_HS_OUT_BF[8:1];
	assign V_VSYNC	 = R_VS_OUT_BF[8:1];
	assign V_DE 	 = R_BL_OUT_BF[8:1];

	assign V_HBLANK	 = R_HBLK_OUT_BF[1];
	assign V_VBLANK	 = R_VBLK_OUT_BF[1];
	assign V_FIELD	 = R_FIELD_OUT_BF[1] ;

endmodule