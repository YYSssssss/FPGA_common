//-----------------------------------------------------------------------------
// File: common_tb.sv
// Author: Jade Yu
// Created by : Jade Yu
// Abstract: abs with JPL
// Modification history:
// $Log$
//   yuyushan 7/25/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps

module commmon_tb;

/////////////////////////// parameter ////////////////////////////
parameter txt_input = "";

localparam mapbase  = 32'h10000;
localparam mapwidth = 12'd3840;
localparam mapheight= 12'd2160;
localparam mapstride= 15'd15360;
localparam map1= $clog2(mapwidth*mapheight);
localparam imgwidth = 12'd3840;
localparam imgheight= 12'd2160;
localparam imgbase  = 32'h20000;
localparam imgstride= 14'd7680;
localparam outbase  = 32'h30000;
localparam outstride= 14'd7680;
localparam start_x  = 12'd0;
localparam start_y  = 12'd0;
localparam end_x    = 12'd3839;
localparam end_y    = 12'd2159;   
localparam INTEGER_WIDTH = 12; 

localparam IMAGE_WIDTHBIT    = 12    ;
localparam IMAGE_HEIGHTBIT   = 12    ;
localparam DECIMAL_WIDTH     =  4    ;
localparam CMD_WIDTH         = IMAGE_WIDTHBIT+DECIMAL_WIDTH; 
localparam AXIADDR_WIDTH     = 32    ;
localparam AXIDATA_WIDTH     = 128   ;
localparam BURSTBIT          = 8     ; 
localparam IMAGE_STRIDEBIT   = IMAGE_WIDTHBIT + 2;

localparam CACHE_WAY_NUM     =  4    ;
localparam TAG_WIDTH         = 11    ;
localparam INDEX_WIDTH       =  6    ;
localparam OFFSET_WIDTH      =  8    ;    
localparam CACHE_NUM         =  2    ;
localparam PIXEL_WIDTH       = 16    ;

/////////////////////////// logic ////////////////////////////
//clk & rstn
logic rst_n;
logic clk_12p5m;
logic clk_25m;
logic clk_50m;
logic clk_60m;
logic clk_75m;
logic clk_100m;
logic clk_150m;
logic clk_200m;
logic clk_250m;
logic clk_300m;
logic clk_400m;
logic clk_500m;
logic clk;

logic start;
logic start_d0;
logic start_d1;

///////////////////////////////////////////////////////

initial begin
#0  
rst_n=0;
clk=0;
clk_12p5m=0;
clk_50m=0;
clk_60m=0;
clk_75m=0;
clk_100m=0;
clk_150m=0;
clk_200m=0;
clk_250m=0;
clk_300m=0;
clk_400m=0;
clk_500m=0;
start=0;

#100
rst_n = 1;
#100
start = 1;


#25000
// $stop;
$finish;
end

always #1    clk        = ~clk;        // 200M
always #40   clk_12p5m  = ~clk_12p5m;  // 12.5M
always #10   clk_50m    = ~clk_50m;    // 50M
always #8.33 clk_60m    = ~clk_60m;    // 50M
always #6.67 clk_75m    = ~clk_75m;    // 75M
always #5    clk_100m   = ~clk_100m;   // 100M
always #3.33 clk_150m   = ~clk_150m;   // 150M
always #2.5  clk_200m   = ~clk_200m;   // 200M
always #2    clk_250m   = ~clk_250m;   // 250M
always #1.67 clk_300m   = ~clk_300m;   // 300M
always #1.25 clk_400m   = ~clk_400m;   // 400M
always #1    clk_500m   = ~clk_500m;   // 500M


//******************** map_ctrl ********************//
//logic 
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

initial begin
    $readmemh("/home/ssm/Desktop/yys/sim/map_ctrl_sim/tb/map_3840x2160_U16_12Q4.txt", mem);
    // $readmemh("/home/users/yuyushan/work/rsp_s1_prep/rsp_s1_prep_sim/input_data/rsp_s1_op_mst_a_0.txt", mem_1024x128);
end

always @ (posedge clk_300m or negedge rst_n) begin
    if(!rst_n) begin
        start_d0 <= 'd0;
    end
    else begin
        start_d0 <= start;
        start_d1 <= start_d0;
    end
end
assign frame_pos = start_d0 && ~start_d1;


    PULSE_GEN (
    .RST          	  					(), // (i) Reset Input ( Asynchronous )
    .CLK_I           					(), // (i) Clock at input side
    .CLK_O           					(), // (i) Clock at output side
    .PULSE_I         					(), // (i) Pulse input
    .PULSE_O            				()	// (o) Pulse output
	) ;








endmodule