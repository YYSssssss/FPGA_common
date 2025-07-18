// =================================================================================================
// Phine Design (Japan) Co., Ltd.
// https://www.phinedesign.co.jp
// =================================================================================================

// =================================================================================================
// File Name      : common_tb.sv
// Module         : common_tb
// Function       : Testbench for verification
// Type           : Testbench
// -------------------------------------------------------------------------------------------------
// Update History :
// -------------------------------------------------------------------------------------------------
// Rev.Level  Date         Coded by         Contents
// 0.0.1      2023/07/25   yuyushan         Original version
// 0.0.2      2025/07/18   yuyushan         Original version
//
// =================================================================================================
// End Revision
// =================================================================================================

// =================================================================================================
// Testbench Header
// =================================================================================================
`timescale 1ns / 1ps
`default_nettype  none

module common_tb;

    // -------------------------------------------------------------------------
	// Internal Parameter Definition
	// -------------------------------------------------------------------------
    localparam txt_input = "";
    localparam PIXEL_WIDTH       = 16    ;


        // -------------------------------------------------------------------------
        // ADDITIONAL Parameter
        // -------------------------------------------------------------------------
        localparam P_SIM		= 0			  	;// 1:simulation use only
	    localparam P_DBUS_W	    = 8				;// data bus width
	    localparam P_INIT_VAL	= 1'b0			;// The Initial value of Switch 
	    localparam P_SAMP_CNT	= 10000			;// Sampling Timecounter(100MHz Clock: 100us/10ns=10000,Max:65536) 


	// -------------------------------------------------------------------------
	// Internal Signal Definition
	// -------------------------------------------------------------------------
    //CLK & RST_N
    logic RST;
    logic RST_N;
    logic CLK_12p5m;
    logic CLK_25m;
    logic CLK_50m;
    logic CLK_60m;
    logic CLK_75m;
    logic CLK_100m;
    logic CLK_150m;
    logic CLK_200m;
    logic CLK_250m;
    logic CLK_300m;
    logic CLK_400m;
    logic CLK_500m;
    logic CLK;

    logic start;
    logic start_d0;
    logic start_d1;

    logic [0:128-1]    mem [2073600-1:0];
    logic           frame_pos         ; 
    logic           map_ready         ; 
    logic           map_req           ;
    logic [32-1:0]  map_addr          ;
    logic [8-1:0]   map_burst         ;
    logic           mapbuffer_empty   ;
    logic           map_rd            ;
    logic [128-1:0] map_data          ;
    logic [2-1:0]   map_cmd_rd        ;
    logic [2-1:0]   map_cmd_empty     ;
    logic [16-1:0]  map_cmd_y [0:2-1] ;
    logic [16-1:0]  map_cmd_x [0:2-1] ;

        // -------------------------------------------------------------------------
	    // ADDITIONAL SIGNALS
        // -------------------------------------------------------------------------
        logic PULSE_I;
        logic PULSE_O;
        logic [P_DBUS_W-1:0] SW_O;

// =================================================================================================
// Initial
// =================================================================================================

    initial begin
    #0  
        RST=1;
        RST_N=0;
        CLK=0;
        CLK_12p5m=0;
        CLK_50m=0;
        CLK_60m=0;
        CLK_75m=0;
        CLK_100m=0;
        CLK_150m=0;
        CLK_200m=0;
        CLK_250m=0;
        CLK_300m=0;
        CLK_400m=0;
        CLK_500m=0;
        start=0;

        #100
        RST = 0;
        RST_N = 1;
        #100
        start = 1;

        #25000
        // $stop;
        $finish;
    end

    initial begin
        $readmemh("/home/ssm/Desktop/yys/sim/map_ctrl_sim/tb/map_3840x2160_U16_12Q4.txt", mem);
        // $readmemh("/home/users/yuyushan/work/rsp_s1_prep/rsp_s1_prep_sim/input_data/rsp_s1_op_mst_a_0.txt", mem_1024x128);
    end

    always #1    CLK        = ~CLK;        // 200M
    always #40   CLK_12p5m  = ~CLK_12p5m;  // 12.5M
    always #10   CLK_50m    = ~CLK_50m;    // 50M
    always #8.33 CLK_60m    = ~CLK_60m;    // 60M
    always #6.67 CLK_75m    = ~CLK_75m;    // 75M
    always #5    CLK_100m   = ~CLK_100m;   // 100M
    always #3.33 CLK_150m   = ~CLK_150m;   // 150M
    always #2.5  CLK_200m   = ~CLK_200m;   // 200M
    always #2    CLK_250m   = ~CLK_250m;   // 250M
    always #1.67 CLK_300m   = ~CLK_300m;   // 300M
    always #1.25 CLK_400m   = ~CLK_400m;   // 400M
    always #1    CLK_500m   = ~CLK_500m;   // 500M

// =================================================================================================
// RTL Main
// =================================================================================================
    always @ (posedge CLK_300m or negedge RST_N) begin
        if(!RST_N) begin
            start_d0 <= 'd0;
        end
        else begin
            start_d0 <= start;
            start_d1 <= start_d0;
        end
    end
    assign frame_pos = start_d0 && ~start_d1;

    // =================================================================================================
    // ADDITIONAL RTL
    // =================================================================================================
    assign PULSE_I = frame_pos;



// =================================================================================================
// Module initialization
// =================================================================================================

    // -------------------------------------------------------------------------
	//      PULSE_GEN
	// -------------------------------------------------------------------------
    PULSE_GEN u_PULSE_GEN(
        .RST          	  					(RST), // (i) Reset Input ( Asynchronous )
        .CLK_I           					(CLK_300m), // (i) Clock at input side
        .CLK_O           					(), // (i) Clock at output side
        .PULSE_I         					(PULSE_I), // (i) Pulse input
        .PULSE_O            				(PULSE_O)	// (o) Pulse output
	) ;

    // -------------------------------------------------------------------------
	//      PULSE_GEN
	// -------------------------------------------------------------------------
    SW_FILTER #(
        .P_SIM				(P_SIM), // 1:simulation use only
        .P_DBUS_W			(P_DBUS_W), // data bus width
        .P_INIT_VAL			(P_INIT_VAL), // The Initial value of Switch
        .P_SAMP_CNT			(P_SAMP_CNT)  // Sampling Timecounter(100MHz Clock: 100us/10ns=10000,Max:65536)

        ) u_SW_FILTER(
        // board clock & reset signals
        .CLK									(CLK_300m), // (i) Clock
        .RST									(RST), // (i) async. reset (high active)

        // Switch Input
        .SW_I								    (CLK_150m), // (i) Switch input

        // Switch Output
        .SW_O								    (SW_O)	// (o) Switch output
	);
    


// -------------------------------------------------------------------------
// Output
// -------------------------------------------------------------------------





endmodule