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


    map_ctrl                        #(
    .AXIADDR_WIDTH                  (AXIADDR_WIDTH),
    .IMAGE_WIDTHBIT                 (IMAGE_WIDTHBIT),
    .IMAGE_HEIGHTBIT                (IMAGE_HEIGHTBIT),
    .BURSTBIT                       (BURSTBIT),
    .OUTSTANDING_NUM                (4),
    .AXIDATA_WIDTH                  (AXIDATA_WIDTH),
    .FIFO_DEPTH                     (261),//(37),
    .DECIMAL_WIDTH                  (DECIMAL_WIDTH),   
    .CACHE_NUM                      (CACHE_NUM)
)
    u0_map_ctrl(
    .clk                            (clk_300m ),
    .rstn                           (rst_n),
    .frame_pos                      (frame_pos),
    .mapbase                        (mapbase  ),
    .mapwidth                       (mapwidth ),
    .mapheight                      (mapheight),    
    .mapstride                      (mapstride),
    
    .start_x                        (start_x  ),
    .start_y                        (start_y  ),
    .end_x                          (end_x    ),
    .end_y                          (end_y    ), 
       
    .map_ready                      (map_ready      ),
    .map_req                        (map_req        ),
    .map_addr                       (map_addr       ),
    .map_burst                      (map_burst      ),
    .mapbuffer_empty                (mapbuffer_empty),
    .map_rd                         (map_rd         ),   
    .map_data                       (map_data       ),
    .map_cmd_rd                     (map_cmd_rd     ),   
    .map_cmd_empty                  (map_cmd_empty  ),
    .map_cmd_y                      (map_cmd_y      ),
    .map_cmd_x                      (map_cmd_x      )          
);
//******************** end_map_ctrl ****************//




//******************** rd_txt_data_tb ********************//
rd_txt_data_tb #(
  .CODE_RUN_CNT               (5),
  .DATA_WIDTH                 (128),
  .DATA_NUM                   (32400),
  .RAM_FILE                   (),
  .DELAY_BIT_DEPTH            (0),
  .DELAY_DATA_DEPTH           (0),
  .DELAY_ADDR_DEPTH           (0),
  .AXIS_DATA_WIDTH            ( ),
  .AXIS_COLUMN                ( ),
  .AXIS_ROW                   ( ),
  .AXIS_ROW_INTERVAL          (16   ),
  .AXIS_RUN_CNT               (3    ),
  .S_AXI4_DATA_WIDTH            (128  ),
  .S_AXI4_EVERY_REQ_ADDR_NUM    (4    ),
  .S_AXI4_MEM_DEPTH             (16200),
  .S_AXI4_MEM_FILE              ()
) u_rd_txt_data_tb(
  .clk           (clk_200m),
  .rst_n         (rst_n),
  
  .axis_tdata    (),
  .axis_tvalid   (),
  .axis_tready   (),
  .axis_tlast    (),
  
  .rd_en         (),
  .rd_data       (),
  .rd_valid      (),
  .rd_addr       (),
  
  .s_axi4_araddr  (),
  .s_axi4_arlen   (),
  .s_axi4_arsize  (),
  .s_axi4_arburst (),
  .s_axi4_arvalid (),
  .s_axi4_arready (),
  .s_axi4_rready  (),
  .s_axi4_rlast   (),
  .s_axi4_rvalid  (),
  .s_axi4_rresp   (),
  .s_axi4_rid     (),
  .s_axi4_rdata   ()
);

//******************** end_rd_txt_data_tb ********************//



//******************** save_file ********************//
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (8),
  .FILE_ADDR       (32),
  .cnt_data        (1024),
  .packet_select   (1)
) u_save_encode_input(
  .rst_n    (rst_n),
  .clk      (clk_300m),
  .valid    (),
  .data     ()
);

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (8),
  .FILE_ADDR       (32),
  .cnt_data        (1024),
  .packet_select   (1)
) u_save_decode_output(
  .rst_n    (rst_n),
  .clk      (clk_300m),
  .valid    (),
  .data     ()
);
//******************** end_save_file ********************//



endmodule