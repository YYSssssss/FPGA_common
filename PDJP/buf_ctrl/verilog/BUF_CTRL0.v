// =================================================================================================
// Phine Design (Japan) Co., Ltd.
// https://www.phinedesign.co.jp
// =================================================================================================

// =================================================================================================
// File Name      : BUF_CTRL0.v
// Module         : BUF_CTRL0
// Function       : Buffer Control(AXIS->LocalBus)
// Type           : RTL
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by         Contents
// 1.0.0      2022/08/02   PDJP   			PDJP(K)-02-018(01)
//
// =================================================================================================
// End Revision
// =================================================================================================

// =================================================================================================
// RTL Header
// =================================================================================================
`timescale 1 ps / 1 ps
`default_nettype  none

module BUF_CTRL0 #(
	parameter								P_FPGA_TYP			= 0				, // FPGA Type(0:Xilinx,1:Intel)
	parameter								P_DBUS_W_I			= 32			, // Input data bus width
	parameter								P_DBUS_W_O			= 128			, // Output data bus width
	parameter								P_DBUF_DEP			= 1024			, // Max depth of 1Block Data(Input Data)
	parameter								P_DBUF_NUM			= 4				  // Block Number

	)(
	// board clock & reset signals
	input	wire							CLK_I								, // (i) Clock Input Side
	input	wire							CLK_O								, // (i) Clock Output Side
	input	wire							RST									, // (i) async. reset (high active)

	// Data Input
	input 	wire							I_AXIS_TUSER						, // (i) AXI Stream SOF(1pulse)
	input 	wire	[P_DBUS_W_I-1:0]		I_AXIS_TDATA						, // (i) AXI Stream Data
	input 	wire							I_AXIS_TVALID						, // (i) AXI Stream Valid
	input 	wire							I_AXIS_TLAST						, // (i) AXI Stream EOL
	output 	wire							I_AXIS_TREADY						, // (o) AXI Stream Ready

	// Data Output
	output 	wire							O_LBUS_TUSER						, // (o) Local Bus SOF(1pulse)
	output 	wire							O_LBUS_STATUS						, // (o) Local Bus Status(0:empty 1:not empty)
	output	wire	[15:0]					O_LBUS_DLEN							, // (o) Local Bus Datalength
	input 	wire							O_LBUS_REN							, // (i) Local Bus Read Enable
	output 	wire	[P_DBUS_W_O-1:0]		O_LBUS_RDATA						, // (o) Local Bus Data
	output 	wire							O_LBUS_RVALID						, // (o) Local Bus Valid
	output 	wire							O_LBUS_RLAST						  // (o) Local Bus EOL
	);

	// -------------------------------------------------------------------------
	// Internal Parameter Definition
	// -------------------------------------------------------------------------
    parameter								P_HADD_W	= $clog2(P_DBUF_NUM)				; // High Address Depth
    parameter								P_WADD_W	= $clog2(P_DBUF_DEP*P_DBUF_NUM)		; // Total Ram Write Address Depth
    parameter								P_I_D_O		= $clog2(P_DBUS_W_I/P_DBUS_W_O)		; // Input Width/Output Width
    parameter								P_O_D_I		= $clog2(P_DBUS_W_O/P_DBUS_W_I)		; // Output Width/Input Width
    parameter								P_RADD_W	= ( P_DBUS_W_I > P_DBUS_W_O ) 		? P_WADD_W+P_I_D_O	: P_WADD_W-P_O_D_I	; // Total Ram Read Address Depth

	// -------------------------------------------------------------------------
	// Internal Signal Definition
	// -------------------------------------------------------------------------

	//      Buffer Write Control
	reg										r_axis_tvalid						; // 1FF of I_AXIS_TVALID
	reg										r_axis_tlast						; // 1FF of I_AXIS_TLAST
	wire									s_dbuf_wen							; // Write Enable of Databuf
	reg				[P_WADD_W-1:0]			r_dbuf_wadd							; // Write Addres of Databuf
	reg				[P_DBUS_W_I-1:0]		r_dbuf_wdt							; // Write Data of Databuf
	wire									s_dbuf_wcmp							; // Write Complete of 1 Block
	reg										r_dbuf_wcmp							; // 1FF of s_dbuf_wcmp
	reg				[P_WADD_W-P_HADD_W:0]	r_wdt_len							; // Write Data length

	//      CLK_I -> CLK_O
	wire									s_i_axis_tuser_clko					; // I_AXIS_TUSER(CLK_O Domain)
	wire									s_dbuf_wcmp_clko					; // r_dbuf_wcmp(CLK_O Domain)
	wire									s_dbuf_rcmp_clki					; // r_dbuf_rcmp(CLK_I Domain)
	
	//      Buffer Read Control
	wire									s_dbuf_ren							; // Read Enable of Databuf
	reg				[P_RADD_W-1:0]			r_dbuf_radd							; // Read Addres of Databuf
	wire			[P_DBUS_W_O-1:0]		s_dbuf_rdt							; // Read Data of Databuf
	reg										r_dbuf_rvld							; // Read Data Valid of Databuf
	wire									s_dbuf_rcmp							; // Read data valid last
	reg				[ 1:0]					r_dbuf_rcmp							; // Read data valid last

	//      Buffer Status
	reg				[P_HADD_W:0]			r_dbuf_blk_cnt0						; // Buffer Status(Write side use) 
	reg				[P_HADD_W:0]			r_dbuf_blk_cnt1						; // Buffer Status(Read side use) 
	wire									s_dbuf_not_empty					; // not empty
	wire									s_dbuf_not_full						; // not full
	reg										r_dbuf_not_full						; // FF of s_dbuf_not_full

	//      Data Length For Read
	reg				[ 2:0]					r_dbuf_wcmp_clko					; // FF of s_dbuf_wcmp_clko
	reg										r_wr_rd_sametime					; // length Latch buffer wirte and read at same time
	reg				[P_WADD_W-P_HADD_W:0]	r_wdt_len_clko						; // Write Data length Latch
	reg				[P_HADD_W-1:0]			r_dlen_buf_add						; // data length buffer address
	reg				[P_WADD_W-P_HADD_W:0]	r_dlen_buf[0:P_DBUF_NUM-1]			; // data length buffer address
	reg				[15:0]					r_rdt_len							; // read data length 
	wire			[15:0]					s_rdt_len_m1						; // r_rdt_len - 1 

// =================================================================================================
// RTL Body
// =================================================================================================


	// -------------------------------------------------------------------------
	//      Buffer Write Control
	// -------------------------------------------------------------------------
	// buffer
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_axis_tvalid 		<= 1'b0 ;
			r_axis_tlast 		<= 1'b0 ;
		end else begin
			r_axis_tvalid	<= I_AXIS_TVALID;
			r_axis_tlast	<= I_AXIS_TLAST;
		end
	end

	// Write Enable
	assign s_dbuf_wen 	= r_axis_tvalid & r_dbuf_not_full;

	// 1 Block Write Complete
	assign s_dbuf_wcmp = s_dbuf_wen && r_axis_tlast ;
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_wcmp 	<= 1'b0 ;
		end else begin
			r_dbuf_wcmp 	<= s_dbuf_wcmp ;
		end
	end

	// Write Address
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_wadd 	<= {P_WADD_W{1'b0}} ;
		end else begin
			if (I_AXIS_TUSER == 1'b1 ) begin											// SOF Clear
				r_dbuf_wadd 	<= {P_WADD_W{1'b0}} ;
			end else if (s_dbuf_wcmp == 1'b1 ) begin									// 1 Block Wirte Complete
				if (r_dbuf_wadd[P_WADD_W-1:P_WADD_W-P_HADD_W] == P_DBUF_NUM-1 ) begin			// Max buffer number
					r_dbuf_wadd 	<= {P_WADD_W{1'b0}} ;
				end else begin
					r_dbuf_wadd[P_WADD_W-1:P_WADD_W-P_HADD_W] 	<= r_dbuf_wadd[P_WADD_W-1:P_WADD_W-P_HADD_W] + 1 ;	// High address
					r_dbuf_wadd[P_WADD_W-P_HADD_W-1:0] 			<= {P_WADD_W-P_HADD_W{1'b0}} ;						// Low address
				end
			end else if (s_dbuf_wen) begin
				r_dbuf_wadd[P_WADD_W-P_HADD_W-1:0]  	<= r_dbuf_wadd[P_WADD_W-P_HADD_W-1:0]  + 1 ;
			end
		end
	end

	// Write Data
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_wdt 	<= {P_DBUS_W_I{1'b0}} ;
		end else begin
			r_dbuf_wdt 	<= I_AXIS_TDATA ;
		end
	end

	// Write Data length
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_wdt_len 	<= {(P_WADD_W-P_HADD_W+1){1'b0}} ;
		end else begin
			if (s_dbuf_wcmp == 1'b1 ) begin
				r_wdt_len 	<= {1'b0,r_dbuf_wadd[P_WADD_W-P_HADD_W-1:0]} + 1;
			end
		end
	end


	// -------------------------------------------------------------------------
	//      Data Buffer
	// -------------------------------------------------------------------------
	BUF_CTRL0_RAM_WRAP #(
		.P_FPGA_TYP		( P_FPGA_TYP			) , // FPGA Type(0:Xilinx,1:Intel)
		.P_DBUS_W_I		( P_DBUS_W_I			) , // Input data bus width
		.P_DBUS_W_O		( P_DBUS_W_O			) , // Output data bus width
		.P_ABUS_W_I		( P_WADD_W				) , // Input address bus width
		.P_ABUS_W_O		( P_RADD_W				)   // Output address bus width
	)U_DBUF(
		.CLK_I			( CLK_I					), // (i)
		.WADD			( r_dbuf_wadd			), // (i)
		.WDT			( r_dbuf_wdt			), // (i)
		.WEN			( s_dbuf_wen			), // (i)
		.CLK_O			( CLK_O					), // (i)
		.RADD			( r_dbuf_radd			), // (i)
		.RDT			( s_dbuf_rdt			), // (o)
		.REN			( s_dbuf_ren			)  // (i)
	);

	// -------------------------------------------------------------------------
	//      CLK_I -> CLK_O
	// -------------------------------------------------------------------------
    PULSE_GEN U_PG_TUSER (
        .RST       		( RST	          		), // (i)
        .CLK_I      	( CLK_I					), // (i)
        .CLK_O      	( CLK_O 				), // (i)
        .PULSE_I    	( I_AXIS_TUSER			), // (i)
        .PULSE_O    	( s_i_axis_tuser_clko	)  // (o)
    ) ;

    PULSE_GEN U_PG_WCMP (
        .RST       		( RST	          		), // (i)
        .CLK_I      	( CLK_I					), // (i)
        .CLK_O      	( CLK_O 				), // (i)
        .PULSE_I    	( r_dbuf_wcmp			), // (i)
        .PULSE_O    	( s_dbuf_wcmp_clko		)  // (o)
    ) ;

	// -------------------------------------------------------------------------
	//      CLK_O -> CLK_I
	// -------------------------------------------------------------------------
    PULSE_GEN U_PG_RCMP (
        .RST       		( RST	          		), // (i)
        .CLK_I      	( CLK_O					), // (i)
        .CLK_O      	( CLK_I 				), // (i)
        .PULSE_I    	( r_dbuf_rcmp[0]		), // (i)
        .PULSE_O    	( s_dbuf_rcmp_clki		)  // (o)
    ) ;


	// -------------------------------------------------------------------------
	//      Buffer Read Control
	// -------------------------------------------------------------------------

	// Read Enable
	assign s_dbuf_ren 	= O_LBUS_REN;


	// Read Address
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_radd 	<= {P_RADD_W{1'b0}} ;
		end else begin
			if (s_i_axis_tuser_clko == 1'b1 ) begin										// SOF Clear
				r_dbuf_radd 	<= {P_RADD_W{1'b0}} ;
			end else if (s_dbuf_rcmp == 1'b1 ) begin									// 1 Block Wirte Complete
				if (r_dbuf_radd[P_RADD_W-1:P_RADD_W-P_HADD_W] == P_DBUF_NUM-1 ) begin			// Max buffer number
					r_dbuf_radd 	<= {P_RADD_W{1'b0}} ;
				end else begin
					r_dbuf_radd[P_RADD_W-1:P_RADD_W-P_HADD_W] 	<= r_dbuf_radd[P_RADD_W-1:P_RADD_W-P_HADD_W] + 1 ;	// High address
					r_dbuf_radd[P_RADD_W-P_HADD_W-1:0] 			<= {P_RADD_W-P_HADD_W{1'b0}} ;						// Low address
				end
			end else if (s_dbuf_ren) begin
				r_dbuf_radd[P_RADD_W-P_HADD_W-1:0]  	<= r_dbuf_radd[P_RADD_W-P_HADD_W-1:0]  + 1 ;
			end
		end
	end

	// Read data valid
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_rvld 	<= 1'b0 ;
		end else begin
			r_dbuf_rvld 	<= s_dbuf_ren ;
		end
	end

	// Read data valid last
	assign s_rdt_len_m1 = r_rdt_len - 1 ;
	assign s_dbuf_rcmp = (s_dbuf_ren == 1'b1 && r_dbuf_radd[P_RADD_W-P_HADD_W-1:0] == s_rdt_len_m1[P_RADD_W-P_HADD_W-1:0]) ? 1'b1 : 1'b0 ;
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_rcmp 	<= 2'b00 ;
		end else begin
			r_dbuf_rcmp 	<= {r_dbuf_rcmp[0],s_dbuf_rcmp} ;
		end
	end

	// -------------------------------------------------------------------------
	//      Buffer Status(CLK_I)(Write side use)
	// -------------------------------------------------------------------------
	// 'd0 : empty
	// 'dx : x block data
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_blk_cnt0	<= {(P_HADD_W+1){1'b0}} ;
		end else begin
			if (I_AXIS_TUSER == 1'b1 ) begin										// SOF Clear
				r_dbuf_blk_cnt0	<= {(P_HADD_W+1){1'b0}} ;
			end else if (s_dbuf_wcmp == 1'b1 && s_dbuf_rcmp_clki == 1'b0) begin		// Write 1 Line
				r_dbuf_blk_cnt0	<= r_dbuf_blk_cnt0 + 1 ;
			end else if (s_dbuf_wcmp == 1'b0 && s_dbuf_rcmp_clki == 1'b1) begin		// Read 1 Line
				r_dbuf_blk_cnt0	<= r_dbuf_blk_cnt0 - 1 ;
			end 
		end
	end

	// Buffer Status
	assign s_dbuf_not_full 	= (r_dbuf_blk_cnt0 < P_DBUF_NUM	&& r_axis_tlast != 1'b1) ? 1'b1 :1'b0 ;	// Not Full
	always @( posedge CLK_I or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_not_full	<= 1'b1 ;
		end else begin
			r_dbuf_not_full	<= s_dbuf_not_full ;
		end
	end

	// -------------------------------------------------------------------------
	//      Buffer Status(CLK_O)(Read side use)
	// -------------------------------------------------------------------------
	// 'd0 : empty
	// 'dx : x block data
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_blk_cnt1	<= {(P_HADD_W+1){1'b0}} ;
		end else begin
			if (s_i_axis_tuser_clko == 1'b1 ) begin									// SOF Clear
				r_dbuf_blk_cnt1 	<= {(P_HADD_W+1){1'b0}} ;
			end else if (r_dbuf_wcmp_clko[2] == 1'b1 && s_dbuf_rcmp == 1'b0) begin		// Write 1 Line
				r_dbuf_blk_cnt1	<= r_dbuf_blk_cnt1 + 1 ;
			end else if (r_dbuf_wcmp_clko[2] == 1'b0 && s_dbuf_rcmp == 1'b1) begin		// Read 1 Line
				r_dbuf_blk_cnt1	<= r_dbuf_blk_cnt1 - 1 ;
			end 
		end
	end

	// Buffer Status
	assign s_dbuf_not_empty	= (r_dbuf_blk_cnt1 != 0	&& r_dbuf_rcmp == 2'b00	) ? 1'b1 :1'b0 ;	// Not Empty


	// -------------------------------------------------------------------------
	//      Data Length For Read
	// -------------------------------------------------------------------------
	// FF of s_dbuf_wcmp_clko
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dbuf_wcmp_clko	<= 3'b000 ;
		end else begin
			r_dbuf_wcmp_clko 	<= {r_dbuf_wcmp_clko[1:0],s_dbuf_wcmp_clko} ;
		end
	end

	// length Latch buffer wirte and read at same time
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_wr_rd_sametime	<= 1'b0 ;
		end else begin
			r_wr_rd_sametime 	<= r_dbuf_wcmp_clko[0] & r_dbuf_rcmp[0] ;
		end
	end

	// Write Data length Latch
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_wdt_len_clko	<= {(P_WADD_W-P_HADD_W+1){1'b0}} ;
		end else begin
			if (s_dbuf_wcmp_clko == 1'b1 ) begin
				r_wdt_len_clko 	<= r_wdt_len ;
			end
		end
	end

	// Data length buffer address
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dlen_buf_add	<= {P_HADD_W{1'b0}} ;
		end else begin
			if (s_i_axis_tuser_clko == 1'b1 ) begin	
				r_dlen_buf_add	<= {P_HADD_W{1'b0}} ;
			end else if (r_dbuf_rcmp[0] == 1) begin
				r_dlen_buf_add 	<= r_dlen_buf_add - 1 ;
			end else if (r_dbuf_wcmp_clko[0] == 1'b1 || r_wr_rd_sametime == 1'b1 ) begin
				r_dlen_buf_add 	<= r_dlen_buf_add + 1 ;
			end
		end
	end

	// Data length buffer
  	genvar i;
  	generate
    for(i = 0; i < P_DBUF_NUM; i = i+1) begin: video_data
	always @(posedge CLK_O or posedge RST ) begin
		if ( RST == 1'b1 ) begin
			r_dlen_buf[i]	<= {(P_WADD_W-P_HADD_W+1){1'b0}} ;
		end else begin
			if (r_dbuf_rcmp[0] == 1) begin
				if ( i == P_DBUF_NUM - 1) begin
					r_dlen_buf[i]	<= {(P_WADD_W-P_HADD_W+1){1'b0}} ;
				end else begin
					r_dlen_buf[i]	<= r_dlen_buf[i+1] ;
				end 
			end else if (r_dbuf_wcmp_clko[0] == 1'b1 || r_wr_rd_sametime == 1'b1 ) begin
				if (r_dlen_buf_add == i) begin
					r_dlen_buf[i]	<= r_wdt_len_clko ;
				end
			end
		end
	end
	end
	endgenerate

	// Read Data Length
	generate
		if ( P_DBUS_W_I > P_DBUS_W_O ) begin : rdt_len0
			always @(posedge CLK_O or posedge RST ) begin
				if ( RST == 1'b1 ) begin
					r_rdt_len	<= {16{1'b0}} ;
				end else begin
					r_rdt_len[P_I_D_O-1:0] 								<= {P_I_D_O{1'b0}} ;
					r_rdt_len[P_WADD_W-P_HADD_W+P_I_D_O:P_I_D_O] 		<= r_dlen_buf[0] ;
					r_rdt_len[15:P_WADD_W-P_HADD_W+P_I_D_O+1] 			<= 'd0 ;
				end
			end	
		end

		if ( P_DBUS_W_I < P_DBUS_W_O ) begin : rdt_len1
			always @(posedge CLK_O or posedge RST ) begin
				if ( RST == 1'b1 ) begin
					r_rdt_len	<= {16{1'b0}} ;
				end else begin
					if ( r_dlen_buf[0][P_O_D_I-1:0] == {P_O_D_I{1'b0}} ) begin
						r_rdt_len[P_WADD_W-P_HADD_W-P_O_D_I:0] 			<= r_dlen_buf[0][P_WADD_W-P_HADD_W:P_O_D_I] ; 
					end else begin
						r_rdt_len[P_WADD_W-P_HADD_W-P_O_D_I:0] 			<= r_dlen_buf[0][P_WADD_W-P_HADD_W:P_O_D_I] + 1;
					end	
					r_rdt_len[15:P_WADD_W-P_HADD_W-P_O_D_I+1] 			<= 'd0 ;
				end
			end	
		end

		if ( P_DBUS_W_I == P_DBUS_W_O ) begin : rdt_len2
			always @(posedge CLK_O or posedge RST ) begin
				if ( RST == 1'b1 ) begin
					r_rdt_len	<= {16{1'b0}} ;
				end else begin
					r_rdt_len[P_WADD_W-P_HADD_W:0] 						<= r_dlen_buf[0] ; 
					r_rdt_len[15:P_WADD_W-P_HADD_W+1] 					<= 'd0 ;
				end
			end	
		end
	endgenerate
	// -------------------------------------------------------------------------
	// Output
	// -------------------------------------------------------------------------
	assign I_AXIS_TREADY	= s_dbuf_not_full		;
	assign O_LBUS_TUSER 	= s_i_axis_tuser_clko 	;
	assign O_LBUS_STATUS 	= s_dbuf_not_empty 		;
	assign O_LBUS_RDATA 	= s_dbuf_rdt	 		;
	assign O_LBUS_RVALID 	= r_dbuf_rvld			;
	assign O_LBUS_RLAST 	= r_dbuf_rcmp[0]		;
	assign O_LBUS_DLEN 		= r_rdt_len				;

endmodule
`default_nettype wire
