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
parameter FILE_MAP_TXT = "/home/yys/Desktop/sim/gdc_top_sim/picture/map_3840x2160_U16_12Q4.txt";

localparam mapbase  = 'd0;//32'h10000;
localparam mapwidth = 12'd3840;
localparam mapheight= 12'd2160;
localparam mapstride= 15'd15360;
localparam map1= $clog2(mapwidth*mapheight);
localparam imgwidth = 12'd3840;
localparam imgheight= 12'd2160;
localparam imgbase  = 32'h00000;
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

localparam COL_WIDTH     = 12;
localparam ROW_WIDTH     = 12;

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

logic gen_start;
logic start;
logic start_d;
logic start_d0;
logic start_d1;
logic start_d2;
logic start_d3;
logic start_d4;


logic [31:0] cnt_valid_map_cmd_rd0;
wire            s_axi_lite_awvalid ;            
wire            s_axi_lite_awready ;          
wire [8 : 0]    s_axi_lite_awaddr  ; 
wire            s_axi_lite_wvalid  ;         
wire            s_axi_lite_wready  ;        
wire [31 : 0]   s_axi_lite_wdata   ;
wire [1 : 0]    s_axi_lite_bresp   ;
wire            s_axi_lite_bvalid  ;        
wire            s_axi_lite_bready  ;         
wire            s_axi_lite_arvalid ;           
wire            s_axi_lite_arready ;          
wire [8 : 0]    s_axi_lite_araddr  ; 
wire            s_axi_lite_rvalid  ;        
wire            s_axi_lite_rready  ;         
wire [31 : 0]   s_axi_lite_rdata   ;
wire [1 : 0]    s_axi_lite_rresp   ;
wire [31 : 0]   m_axi_mm2s_araddr  ;
wire [7 : 0]    m_axi_mm2s_arlen   ;
wire [2 : 0]    m_axi_mm2s_arsize  ;
wire [1 : 0]    m_axi_mm2s_arburst ;  
wire [2 : 0]    m_axi_mm2s_arprot  ;
wire [3 : 0]    m_axi_mm2s_arcache ;  
wire            m_axi_mm2s_arvalid ;          
wire            m_axi_mm2s_arready ;           
wire [127 : 0]  m_axi_mm2s_rdata   ;
wire [1 : 0]    m_axi_mm2s_rresp   ;
wire            m_axi_mm2s_rlast   ;       
wire            m_axi_mm2s_rvalid  ;         
wire            m_axi_mm2s_rready  ;        
wire [127 : 0]  m_axis_mm2s_tdata  ;
wire [15 : 0]   m_axis_mm2s_tkeep  ;
wire [0 : 0]    m_axis_mm2s_tuser  ;
wire            m_axis_mm2s_tvalid ;          
wire            m_axis_mm2s_tready ;           
wire            m_axis_mm2s_tlast  ;        
wire            mm2s_introut       ;   

logic dma_done_irq;  
logic i_rd_finish;
logic pixel_ram_ctrl_finish;

///////////////////////////////////////////////////////

initial begin
#0  
rst_n=0;
gen_start = 0;

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
gen_start = 1;
#500
start = 1;
#100
start = 0;


wait(i_rd_finish == 1'b1);
//wait(pixel_ram_ctrl_finish == 1'b1);
//#100000
//start = 1;
//#100
//start = 0;
//wait(pixel_ram_ctrl_finish == 1'b1);
//#100000
//start = 1;
//#100
//start = 0;
//wait(pixel_ram_ctrl_finish == 1'b1);
#100000



$stop;
end

assign       clk = ~clk_200m;        // 200M
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

//******************** instruct ********************//
reg frame_start_d0;
reg frame_start_d1;
wire frame_start_pos;
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        frame_start_d0 <= 1'b0;
        frame_start_d1 <= 1'b0;
    end
    else begin
        frame_start_d0 <= start;
        frame_start_d1 <= frame_start_d0;
    end
end
assign frame_start_pos = frame_start_d0 && ~frame_start_d1;

//******************** axi_lite_vdma_ctrl ****************//
//******************** axi_lite_vdma_ctrl ****************//
logic [31:0] awaddr;
logic [31:0] wdata;
logic        push_write;
logic start_input_gpio;
logic [15:0] cnt_m_axis_mm2s_tlast_pos;
//axi_lite_user_logic u_axi_lite_user_logic(
//    .clk                (clk_200m),
//    .rstn               (rst_n),
//    .i_frame_start      (start),
//    .i_start_input_gpio ('d0),                    
//    .awaddr             (awaddr),
//    .wdata              (wdata),
//    .araddr             (),
//    .push_write         (push_write),
//    .pop_read           ()
//);
axi_lite_master u_axi_lite_master(
    .m_axi_aclk                         (clk),
    .m_axi_aresetn                      (rst_n),

    .m_axi_awaddr                       (s_axi_lite_awaddr ),
    .m_axi_awprot                       (  ),
    .m_axi_awvalid                      (s_axi_lite_awvalid),
    .m_axi_awready                      (s_axi_lite_awready),
    .m_axi_wdata                        (s_axi_lite_wdata  ),
    .m_axi_wstrb                        (   ),
    .m_axi_wvalid                       (s_axi_lite_wvalid ),
    .m_axi_wready                       (s_axi_lite_wready ),
    .m_axi_bresp                        (s_axi_lite_bresp  ),
    .m_axi_bvalid                       (s_axi_lite_bvalid ),
    .m_axi_bready                       (s_axi_lite_bready ),
    
    .m_axi_araddr                       (),
    .m_axi_arprot                       (),
    .m_axi_arvalid                      (),
    .m_axi_arready                      (),
    .m_axi_rdata                        (),
    .m_axi_rresp                        (),
    .m_axi_rvalid                       (),
    .m_axi_rready                       (),
    .done_success                       (),
    .i_frame_start                      (start),
    .i_start_input_gpio                 (start_input_gpio),
    .i_cnt_m_axis_mm2s_tlast_pos        (cnt_m_axis_mm2s_tlast_pos),
    .dma_done_irq                       (dma_done_irq)
);
logic m_axis_mm2s_tlast_d0;
logic m_axis_mm2s_tlast_d1;
logic m_axis_mm2s_tlast_pos;

logic [15:0] cnt_test_irq;

localparam VDMA_IRQ_NUM = 'd4; ///////////////////////////////////important

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        m_axis_mm2s_tlast_d0 <= 1'b0;
        m_axis_mm2s_tlast_d1 <= 1'b0;
    end
    else begin
        m_axis_mm2s_tlast_d0 <= m_axis_mm2s_tlast;
        m_axis_mm2s_tlast_d1 <= m_axis_mm2s_tlast_d0;
    end
end
assign m_axis_mm2s_tlast_pos = m_axis_mm2s_tlast_d0 && ~m_axis_mm2s_tlast_d1;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        cnt_m_axis_mm2s_tlast_pos <= 'd0;
    end
    else begin
        if(cnt_m_axis_mm2s_tlast_pos == VDMA_IRQ_NUM)
            cnt_m_axis_mm2s_tlast_pos <= 'd0;
        else if(m_axis_mm2s_tlast_pos == 1'b1)
            cnt_m_axis_mm2s_tlast_pos <= cnt_m_axis_mm2s_tlast_pos + 1'b1;
    end
end
assign start_input_gpio = (cnt_m_axis_mm2s_tlast_pos == VDMA_IRQ_NUM && cnt_test_irq != 'd1153);

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        cnt_test_irq <= 'd0;
    end
    else begin
        if(frame_start_pos == 'd1)
            cnt_test_irq <= 'd0;
        else if(cnt_m_axis_mm2s_tlast_pos == VDMA_IRQ_NUM)
            cnt_test_irq <= cnt_test_irq + 1'b1;
    end
end


axi_vdma_0 u_axi_vdma_0 (
  .s_axi_lite_aclk      (clk),        // input wire s_axi_lite_aclk
  .m_axi_mm2s_aclk      (clk),        // input wire m_axi_mm2s_aclk
  .m_axis_mm2s_aclk     (clk),      // input wire m_axis_mm2s_aclk
  .axi_resetn           (rst_n),                  // input wire axi_resetn
  .s_axi_lite_awvalid   (s_axi_lite_awvalid),  // input wire s_axi_lite_awvalid
  .s_axi_lite_awready   (s_axi_lite_awready),  // output wire s_axi_lite_awready
  .s_axi_lite_awaddr    (s_axi_lite_awaddr ),    // input wire [8 : 0] s_axi_lite_awaddr
  .s_axi_lite_wvalid    (s_axi_lite_wvalid ),    // input wire s_axi_lite_wvalid
  .s_axi_lite_wready    (s_axi_lite_wready ),    // output wire s_axi_lite_wready
  .s_axi_lite_wdata     (s_axi_lite_wdata  ),      // input wire [31 : 0] s_axi_lite_wdata
  .s_axi_lite_bresp     (s_axi_lite_bresp  ),      // output wire [1 : 0] s_axi_lite_bresp
  .s_axi_lite_bvalid    (s_axi_lite_bvalid ),    // output wire s_axi_lite_bvalid
  .s_axi_lite_bready    (s_axi_lite_bready ),    // input wire s_axi_lite_bready
  .s_axi_lite_arvalid   (1'd0),//(s_axi_lite_arvalid),  // input wire s_axi_lite_arvalid
  .s_axi_lite_arready   (),//(s_axi_lite_arready),  // output wire s_axi_lite_arready
  .s_axi_lite_araddr    (9'd0),//(s_axi_lite_araddr ),    // input wire [8 : 0] s_axi_lite_araddr
  .s_axi_lite_rvalid    (),//(s_axi_lite_rvalid ),    // output wire s_axi_lite_rvalid
  .s_axi_lite_rready    (1'd0),//(s_axi_lite_rready ),    // input wire s_axi_lite_rready
  .s_axi_lite_rdata     (),//(s_axi_lite_rdata  ),      // output wire [31 : 0] s_axi_lite_rdata
  .s_axi_lite_rresp     (),//(s_axi_lite_rresp  ),      // output wire [1 : 0] s_axi_lite_rresp
  .m_axi_mm2s_araddr    (m_axi_mm2s_araddr ),    // output wire [31 : 0] m_axi_mm2s_araddr
  .m_axi_mm2s_arlen     (m_axi_mm2s_arlen  ),      // output wire [7 : 0] m_axi_mm2s_arlen
  .m_axi_mm2s_arsize    (m_axi_mm2s_arsize ),    // output wire [2 : 0] m_axi_mm2s_arsize
  .m_axi_mm2s_arburst   (m_axi_mm2s_arburst),  // output wire [1 : 0] m_axi_mm2s_arburst
  .m_axi_mm2s_arprot    (m_axi_mm2s_arprot ),    // output wire [2 : 0] m_axi_mm2s_arprot
  .m_axi_mm2s_arcache   (m_axi_mm2s_arcache),  // output wire [3 : 0] m_axi_mm2s_arcache
  .m_axi_mm2s_arvalid   (m_axi_mm2s_arvalid),  // output wire m_axi_mm2s_arvalid
  .m_axi_mm2s_arready   (m_axi_mm2s_arready),  // input wire m_axi_mm2s_arready
  .m_axi_mm2s_rdata     (m_axi_mm2s_rdata  ),      // input wire [127 : 0] m_axi_mm2s_rdata
  .m_axi_mm2s_rresp     (m_axi_mm2s_rresp  ),      // input wire [1 : 0] m_axi_mm2s_rresp
  .m_axi_mm2s_rlast     (m_axi_mm2s_rlast  ),      // input wire m_axi_mm2s_rlast
  .m_axi_mm2s_rvalid    (m_axi_mm2s_rvalid ),    // input wire m_axi_mm2s_rvalid
  .m_axi_mm2s_rready    (m_axi_mm2s_rready ),    // output wire m_axi_mm2s_rready
  .m_axis_mm2s_tdata    (m_axis_mm2s_tdata ),    // output wire [127 : 0] m_axis_mm2s_tdata
  .m_axis_mm2s_tkeep    (m_axis_mm2s_tkeep ),    // output wire [15 : 0] m_axis_mm2s_tkeep
  .m_axis_mm2s_tuser    (m_axis_mm2s_tuser ),    // output wire [0 : 0] m_axis_mm2s_tuser
  .m_axis_mm2s_tvalid   (m_axis_mm2s_tvalid),  // output wire m_axis_mm2s_tvalid
  .m_axis_mm2s_tready   (m_axis_mm2s_tready),//(1'b1),  // input wire m_axis_mm2s_tready
//  .m_axis_mm2s_tready   (1'b1),  // input wire m_axis_mm2s_tready
  .m_axis_mm2s_tlast    (m_axis_mm2s_tlast ),    // output wire m_axis_mm2s_tlast
  .mm2s_introut         (mm2s_introut)              // output wire mm2s_introut
);
logic mm2s_introut_d0;
logic mm2s_introut_d1;
logic mm2s_introut_pos;

always@(posedge clk_200m or negedge rst_n)begin
    if(!rst_n) begin
        mm2s_introut_d0 <= 1'b0;
        mm2s_introut_d1 <= 1'b0;
    end
    else begin
        mm2s_introut_d0 <= mm2s_introut;
        mm2s_introut_d1 <= mm2s_introut_d0;
    end
end
assign mm2s_introut_pos = mm2s_introut_d0 && ~mm2s_introut_d1;

blk_mem_gen_0 u_blk_mem_gen_0 (
  .rsta_busy        (),          // output wire rsta_busy
  .rstb_busy        (),          // output wire rstb_busy
  .s_aclk           (clk),                // input wire s_aclk
  .s_aresetn        (rst_n),          // input wire s_aresetn
  .s_axi_awid       ('d0),//(s_axi_awid   ),        // input wire [3 : 0] s_axi_awid
  .s_axi_awaddr     ('d0),//(s_axi_awaddr ),    // input wire [31 : 0] s_axi_awaddr
  .s_axi_awlen      ('d0),//(s_axi_awlen  ),      // input wire [7 : 0] s_axi_awlen
  .s_axi_awsize     ('d0),//(s_axi_awsize ),    // input wire [2 : 0] s_axi_awsize
  .s_axi_awburst    ('d0),//(s_axi_awburst),  // input wire [1 : 0] s_axi_awburst
  .s_axi_awvalid    (1'd0),//(s_axi_awvalid),  // input wire s_axi_awvalid
  .s_axi_awready    (),//(s_axi_awready),  // output wire s_axi_awready
  .s_axi_wdata      ('d0),//(s_axi_wdata  ),      // input wire [127 : 0] s_axi_wdata
  .s_axi_wstrb      ('d0),//(s_axi_wstrb  ),      // input wire [15 : 0] s_axi_wstrb
  .s_axi_wlast      ('d0),//(s_axi_wlast  ),      // input wire s_axi_wlast
  .s_axi_wvalid     ('d0),//(s_axi_wvalid ),    // input wire s_axi_wvalid
  .s_axi_wready     (),//(s_axi_wready ),    // output wire s_axi_wready
  .s_axi_bid        (),//(s_axi_bid    ),          // output wire [3 : 0] s_axi_bid
  .s_axi_bresp      (),//(s_axi_bresp  ),      // output wire [1 : 0] s_axi_bresp
  .s_axi_bvalid     (),//(s_axi_bvalid ),    // output wire s_axi_bvalid
  .s_axi_bready     ('d0 ),    // input wire s_axi_bready
  .s_axi_arid       ('d0),        // input wire [3 : 0] s_axi_arid
  .s_axi_araddr     (m_axi_mm2s_araddr),    // input wire [31 : 0] s_axi_araddr
  .s_axi_arlen      (m_axi_mm2s_arlen),      // input wire [7 : 0] s_axi_arlen
  .s_axi_arsize     (m_axi_mm2s_arsize),    // input wire [2 : 0] s_axi_arsize
  .s_axi_arburst    (m_axi_mm2s_arburst),  // input wire [1 : 0] s_axi_arburst
  .s_axi_arvalid    (m_axi_mm2s_arvalid),  // input wire s_axi_arvalid
  .s_axi_arready    (m_axi_mm2s_arready),  // output wire s_axi_arready
  .s_axi_rid        (m_axi_mm2s_rid),          // output wire [3 : 0] s_axi_rid
  .s_axi_rdata      (m_axi_mm2s_rdata),      // output wire [127 : 0] s_axi_rdata
  .s_axi_rresp      (m_axi_mm2s_rresp),      // output wire [1 : 0] s_axi_rresp
  .s_axi_rlast      (m_axi_mm2s_rlast),      // output wire s_axi_rlast
  .s_axi_rvalid     (m_axi_mm2s_rvalid),    // output wire s_axi_rvalid
  .s_axi_rready     (m_axi_mm2s_rready)    // input wire s_axi_rready
);


//******************** end_axi_lite_vdma_ctrl ****************//







//******************** map_ctrl ********************//

//////////fifo test////////////
logic                             s_axis_fifo_tvalid      [1-1:0];             
logic                             s_axis_fifo_tready      [1-1:0];        
logic [128-1 : 0]                 s_axis_fifo_tdata       [1-1:0];
logic                             m_axis_fifo_tvalid      [1-1:0];        
logic                             m_axis_fifo_tready      [1-1:0];         
logic [128-1 : 0]                 m_axis_fifo_tdata       [1-1:0];
logic [31 : 0]                    fifo_axis_wr_data_count [1-1:0];
logic [31 : 0]                    fifo_axis_rd_data_count [1-1:0];
logic                             fifo_almost_empty       [1-1:0];        
logic                             fifo_prog_empty         [1-1:0];        
logic                             fifo_almost_full        [1-1:0];        
logic                             fifo_prog_full          [1-1:0]; 

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        s_axis_fifo_tvalid[0] <= 1'b0;
    end
    else begin
        if(!gen_start)
            s_axis_fifo_tvalid[0] <= 1'b0;
//        else if(s_axis_fifo_tvalid[0])
//            s_axis_fifo_tvalid[0] <= 1'b0;
        else if(fifo_almost_full[0])
            s_axis_fifo_tvalid[0] <= 1'b0;
        else
            s_axis_fifo_tvalid[0] <= 1'b1;
    end
end

logic [31:0] cnt_gen_map_data;
always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        cnt_gen_map_data <= 'd0;
    end
    else begin
        if(!gen_start)
            cnt_gen_map_data <= 'd0;
        else if(cnt_gen_map_data == 'd1799)
            cnt_gen_map_data <= 'd0;
        else if(s_axis_fifo_tvalid[0] && s_axis_fifo_tready[0])
            cnt_gen_map_data <= cnt_gen_map_data + 'd1;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
//        s_axis_fifo_tdata[0] <= 'h00070006000500040003000200010000;
        s_axis_fifo_tdata[0] <= 'h00000001000000010000000100000001;
    end
    else begin
        if(!gen_start) begin
            s_axis_fifo_tdata[0] <= 'h0000000C000000080000000400000000;
//            s_axis_fifo_tdata[0] <= 'h00000001000000010000000100000001;
        end
        else if(cnt_gen_map_data == 'd1799) begin
            s_axis_fifo_tdata[0] <= 'h0000000C000000080000000400000000;
        end
        else if(s_axis_fifo_tvalid[0] && s_axis_fifo_tready[0])
//            s_axis_fifo_tdata[0] <= s_axis_fifo_tdata[0] + 'h00010001000100010001000100010001;
//            s_axis_fifo_tdata[0] <= s_axis_fifo_tdata[0] + 'h00000001000000010000000100000001;
//            s_axis_fifo_tdata[0] <= s_axis_fifo_tdata[0] + 'h00080008000800080008000800080008;
            s_axis_fifo_tdata[0]   <= s_axis_fifo_tdata[0] + 'h00000008000000080000000800000008;
    end
end

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        m_axis_fifo_tready[0] <= 'd0;
    end
    else begin
        if(!gen_start)
            m_axis_fifo_tready[0] <= 'd0;
        else if(fifo_almost_full[0])
            m_axis_fifo_tready[0] <= 'd1;
        else
            m_axis_fifo_tready[0] <= 'd0;
    end
end

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("/home/yys/Desktop/sim/vdmarx_map_ram/txt/gen_map_data_0.txt"),
  .cnt_data        (16588800*2),
  .packet_select   (1)
) u_save_gen_map_data_0_output(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (s_axis_fifo_tvalid[0] && s_axis_fifo_tready[0]),
  .data     (s_axis_fifo_tdata[0]),
  
  .cnt_valid()
);

//map_fifo u_map_fifo_A (
//  .s_axis_aresetn       (rst_n),             // input wire s_axis_aresetn
//  .s_axis_aclk          (clk ),             // input wire s_axis_aclk
//  .s_axis_tvalid        (1'd0),//(s_axis_fifo_tvalid[0]),           // input wire s_axis_tvalid
//  .s_axis_tready        (),//(s_axis_fifo_tready[0]),           // output wire s_axis_tready
//  .s_axis_tdata         (s_axis_fifo_tdata[0] ),           // input wire [127 : 0] s_axis_tdata
//  .m_axis_tvalid        (m_axis_fifo_tvalid[0]),           // output wire m_axis_tvalid
//  .m_axis_tready        (1'd1),//(m_axis_fifo_tready[0]),           // input wire m_axis_tready
//  .m_axis_tdata         (m_axis_fifo_tdata[0] ),           // output wire [127 : 0] m_axis_tdata
//  .axis_wr_data_count   (fifo_axis_wr_data_count[0]),           // output wire [31 : 0] axis_wr_data_count
//  .axis_rd_data_count   (fifo_axis_rd_data_count[0]),           // output wire [31 : 0] axis_rd_data_count
//  .almost_empty         (fifo_almost_empty[0] ),           // output wire almost_empty
//  .prog_empty           (fifo_prog_empty[0]   ),           // output wire prog_empty
//  .almost_full          (fifo_almost_full[0]  ),           // output wire almost_full
//  .prog_full            (fifo_prog_full[0]    )            // output wire prog_full
//);

//blk_mem_gen_3 u_blk_mem_gen_3 (
//  .clka     (clk  ),  // input wire clka
//  .ena      (1'b1 ),  // input wire ena
//  .wea      (1'b0 ),  // input wire [0 : 0] wea
//  .addra    ('d3),  // input wire [14 : 0] addra
//  .dina     (128'd0),  // input wire [127 : 0] dina
//  .douta    (),  // output wire [15 : 0] douta
//  .clkb     (clk ),  // input wire clkb
//  .enb      (1'b1 ),  // input wire enb
//  .web      (1'b0 ),  // input wire [0 : 0] web
//  .addrb    ('d4),  // input wire [14 : 0] addrb
//  .dinb     ('d0),  // input wire [127 : 0] dinb
//  .doutb    ()   // output wire [15 : 0] doutb
//);


////////////end fifo test////////////





/////////////////////////////////////////////////////
logic           o_rd_fifo_start;
logic [2-1:0]   rd_fifo_en_id;
logic [2-1:0]   wr_fifo_en_id;
logic           map_mux_m_axis_tvalid ;
logic           map_mux_m_axis_tready;
logic           map_mux_m_axis_tready_d0;
logic [128-1:0] map_mux_m_axis_tdata  ; 
logic flag;
//logic i_rd_finish;
logic [31:0] cnt_map_mux_handshake;
logic [31:0] cnt_block_8KB;
logic [31:0] cnt_block;
logic [31:0] cnt_wait_time;

localparam xKB_BLOCK_NUM      = 1152;  // 3840*2160*2*2 / 1024 / 28.125KB
localparam xKB_DATA_NUM       = 1800;  // 28.125KB * 1024 / 128bit

map_mux #(
    .MAP_DATA_WIDTH (128),
    .xKB_DATA_NUM   (xKB_DATA_NUM)
) u_map_mux(

    .clk                     (clk),
    .rstn                    (rst_n),
    .soft_rstn               (rst_n),
    .s_axis_tvalid           (s_axis_fifo_tvalid[0]),
    .s_axis_tready           (s_axis_fifo_tready[0]),
    .s_axis_tdata            (s_axis_fifo_tdata[0] ),
//    .s_axis_tvalid           (m_axis_mm2s_tvalid),//(s_axis_fifo_tvalid[0]),
//    .s_axis_tready           (m_axis_mm2s_tready),//(s_axis_fifo_tready[0]),
//    .s_axis_tdata            (m_axis_mm2s_tdata ),//(s_axis_fifo_tdata[0] ),
    .m_axis_tvalid           (map_mux_m_axis_tvalid),
    .m_axis_tready           (map_mux_m_axis_tready),
    .m_axis_tdata            (map_mux_m_axis_tdata ),
    .i_gdc_start             (frame_start_pos),
    .i_rd_fifo_en_id         (rd_fifo_en_id),
    .o_wr_fifo_en_id         (wr_fifo_en_id),
    .o_rd_fifo_start         (o_rd_fifo_start),
    .i_rd_finish             (i_rd_finish)
);

//always@(posedge clk or negedge rst_n)begin
//    if(!rst_n) begin
//        map_mux_m_axis_tready <= 'd0;
//    end
//    else begin
//        if(map_mux_m_axis_tvalid == 1'b1 && map_mux_m_axis_tready == 1'b1)
//            map_mux_m_axis_tready <= 1'b0;
//        else
//            map_mux_m_axis_tready <= 1'b1;
//    end
//end

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("/home/yys/Desktop/sim/vdmarx_map_ram/txt/map_mux_output.txt"),
  .cnt_data        (16588800*2),
  .packet_select   (1)
) u_save_map_mux_output(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (map_mux_m_axis_tready && map_mux_m_axis_tready),
  .data     (map_mux_m_axis_tdata),
  
  .cnt_valid()
);


logic           map_ctrl_m_axis_tvalid;
logic           map_ctrl_m_axis_tready;
logic [128-1:0] map_ctrl_m_axis_tdata ;

map_ctrl #(
    .MODULE_DELAY          (1            ),
    .DATA_WIDTH            (128          ),
    .DATA_BYTE             (128/8        ),
    .xKB_BLOCK_NUM         (1152         ),
    .xKB_DATA_NUM          (xKB_DATA_NUM),
    .PICTURE_H             (3840         ),
    .PICTURE_V             (2160         ),
    .MAP_DATA_BYTE         (3840*2160*2*2),
    .LAST_xKB_BLOCK_NUM    (1152         ),
    .LAST_xKB_DATA_NUM     (xKB_DATA_NUM)
) u_map_ctrl(
    .clk                    (clk),       
    .rstn                   (rst_n), 
    .soft_rstn              (rst_n), 
    .s_axis_tvalid          (map_mux_m_axis_tvalid), 
    .s_axis_tready          (map_mux_m_axis_tready), 
    .s_axis_tdata           (map_mux_m_axis_tdata ), 
    .map_ctrl_m_axis_tvalid (map_ctrl_m_axis_tvalid), 
    .map_ctrl_m_axis_tready (map_ctrl_m_axis_tready), 
//    .map_ctrl_m_axis_tready (1'b1), 
    .map_ctrl_m_axis_tdata  (map_ctrl_m_axis_tdata ), 
    .i_gdc_start            (frame_start_pos), 
    .i_wr_fifo_en_id        (wr_fifo_en_id), 
    .o_rd_fifo_en_id        (rd_fifo_en_id), 
    .i_map_ctrl_start       (o_rd_fifo_start), 
    .o_map_ctrl_finish      (i_rd_finish)
    
);

//logic test_handshake;
//assign test_handshake = map_ctrl_m_axis_tvalid == 1'b1 && map_ctrl_m_axis_tready == 1'b1;

//always@(posedge clk or negedge rst_n)begin
//    if(!rst_n) begin
//        map_ctrl_m_axis_tready <= 'd0;
//    end
//    else begin
//        if(map_ctrl_m_axis_tvalid == 1'b1 && map_ctrl_m_axis_tready == 1'b1)
//            map_ctrl_m_axis_tready <= 1'b0;
//        else
//            map_ctrl_m_axis_tready <= 1'b1;
//    end
//end

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("/home/yys/Desktop/sim/vdmarx_map_ram/txt/map_ctrl_output.txt"),
  .cnt_data        (16588800*2),
  .packet_select   (1)
) u_save_map_ctrl_output(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (map_ctrl_m_axis_tvalid),
  .data     (map_ctrl_m_axis_tdata),
  
  .cnt_valid()
);
//******************** end_map_ctrl ****************//

//******************** pixel_ram_ctrl ********************//
logic[15:0] o_pixel_ram_ctrl_tdata [15:0];
logic o_pixel_ram_ctrl_tvalid;
logic i_pixel_ram_ctrl_tready;

pixel_ram_ctrl #(
    .MODULE_DELAY           (1      ),   
    .DELAY_COORDINATE_VALID (1      ),
    .PIXEL_DATA_WIDTH       (16     ),
    .DATA_WIDTH             (128    ),
    .DATA_BYTE              (16     ),
    .xKB_BLOCK_NUM          (1152   ),
    .xKB_DATA_NUM           (1024   ),
    .COORDINATE_NUM         (1800   ),
    .COORDINATE_BLOCK_NUM   (1152   )
) u_pixel_ram_ctrl(
    .clk                             (clk),
    .rstn                            (rst_n),
    .soft_rstn                       (rst_n),
    .i_dma_tvalid                    (m_axis_mm2s_tvalid),
    .o_dma_tready                    (m_axis_mm2s_tready),
    .i_dma_tdata                     (m_axis_mm2s_tdata ),
    .i_map_ctrl_tvalid               (map_ctrl_m_axis_tvalid),
    .o_map_ctrl_tready               (map_ctrl_m_axis_tready),
    .i_map_ctrl_tdata                (map_ctrl_m_axis_tdata ),
    .i_pixel_ram_ctrl_tready         (i_pixel_ram_ctrl_tready),
    .o_pixel_ram_ctrl_tvalid         (o_pixel_ram_ctrl_tvalid),
    .o_pixel_ram_ctrl_tdata0         (o_pixel_ram_ctrl_tdata[0 ]),
    .o_pixel_ram_ctrl_tdata1         (o_pixel_ram_ctrl_tdata[1 ]),
    .o_pixel_ram_ctrl_tdata2         (o_pixel_ram_ctrl_tdata[2 ]),
    .o_pixel_ram_ctrl_tdata3         (o_pixel_ram_ctrl_tdata[3 ]),
    .o_pixel_ram_ctrl_tdata4         (o_pixel_ram_ctrl_tdata[4 ]),
    .o_pixel_ram_ctrl_tdata5         (o_pixel_ram_ctrl_tdata[5 ]),
    .o_pixel_ram_ctrl_tdata6         (o_pixel_ram_ctrl_tdata[6 ]),
    .o_pixel_ram_ctrl_tdata7         (o_pixel_ram_ctrl_tdata[7 ]),
    .o_pixel_ram_ctrl_tdata8         (o_pixel_ram_ctrl_tdata[8 ]),
    .o_pixel_ram_ctrl_tdata9         (o_pixel_ram_ctrl_tdata[9 ]),
    .o_pixel_ram_ctrl_tdata10        (o_pixel_ram_ctrl_tdata[10]),
    .o_pixel_ram_ctrl_tdata11        (o_pixel_ram_ctrl_tdata[11]),
    .o_pixel_ram_ctrl_tdata12        (o_pixel_ram_ctrl_tdata[12]),
    .o_pixel_ram_ctrl_tdata13        (o_pixel_ram_ctrl_tdata[13]),
    .o_pixel_ram_ctrl_tdata14        (o_pixel_ram_ctrl_tdata[14]),
    .o_pixel_ram_ctrl_tdata15        (o_pixel_ram_ctrl_tdata[15]),
    .i_gdc_start                     (frame_start_pos),
    .o_pixel_ram_ctrl_finish         (pixel_ram_ctrl_finish)
);

always@(posedge clk or negedge rst_n)begin
    if(!rst_n) begin
        i_pixel_ram_ctrl_tready <= 'd0;
    end
    else begin
        if(o_pixel_ram_ctrl_tvalid == 1'b1 && i_pixel_ram_ctrl_tready == 1'b1)
            i_pixel_ram_ctrl_tready <= 1'b0;
        else
            i_pixel_ram_ctrl_tready <= 1'b1;
    end
end


save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (256),
  .FILE_ADDR       ("/home/yys/Desktop/sim/vdmarx_map_ram/txt/pixel_ram_ctrl.txt"),
  .cnt_data        (16588800*2),
  .packet_select   (1)
) u_save_pixel_ram_ctrl(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (o_pixel_ram_ctrl_tvalid),
  .data     ({
              o_pixel_ram_ctrl_tdata[15],o_pixel_ram_ctrl_tdata[14],o_pixel_ram_ctrl_tdata[13],o_pixel_ram_ctrl_tdata[12],
              o_pixel_ram_ctrl_tdata[11],o_pixel_ram_ctrl_tdata[10],o_pixel_ram_ctrl_tdata[9] ,o_pixel_ram_ctrl_tdata[8],
              o_pixel_ram_ctrl_tdata[7] ,o_pixel_ram_ctrl_tdata[6] ,o_pixel_ram_ctrl_tdata[5] ,o_pixel_ram_ctrl_tdata[4],
              o_pixel_ram_ctrl_tdata[3] ,o_pixel_ram_ctrl_tdata[2] ,o_pixel_ram_ctrl_tdata[1] ,o_pixel_ram_ctrl_tdata[0]
              }),
  
  .cnt_valid()
);
//******************** end_pixel_ram_ctrl ********************//
















//******************** rd_txt_data_tb ********************//
//rd_txt_data_tb #(
//  .CODE_RUN_CNT               (5),
//  .DATA_WIDTH                 (128),
//  .DATA_NUM                   (32400),
//  .RAM_FILE                   (),
//  .DELAY_BIT_DEPTH            (0),
//  .DELAY_DATA_DEPTH           (0),
//  .DELAY_ADDR_DEPTH           (0),
//  .AXIS_DATA_WIDTH            ( ),
//  .AXIS_COLUMN                ( ),
//  .AXIS_ROW                   ( ),
//  .AXIS_ROW_INTERVAL          (16   ),
//  .AXIS_RUN_CNT               (3    ),
//  .S_AXI4_DATA_WIDTH            (128  ),
//  .S_AXI4_EVERY_REQ_ADDR_NUM    (4    ),
//  .S_AXI4_MEM_DEPTH             (16200),
//  .S_AXI4_MEM_FILE              ()
//) u_rd_txt_data_tb(
//  .clk           (clk_200m),
//  .rst_n         (rst_n),
  
//  .axis_tdata    (),
//  .axis_tvalid   (),
//  .axis_tready   (),
//  .axis_tlast    (),
  
//  .rd_en         (),
//  .rd_data       (),
//  .rd_valid      (),
//  .rd_addr       (),
  
//  .s_axi4_araddr  (),
//  .s_axi4_arlen   (),
//  .s_axi4_arsize  (),
//  .s_axi4_arburst (),
//  .s_axi4_arvalid (),
//  .s_axi4_arready (),
//  .s_axi4_rready  (),
//  .s_axi4_rlast   (),
//  .s_axi4_rvalid  (),
//  .s_axi4_rresp   (),
//  .s_axi4_rid     (),
//  .s_axi4_rdata   ()
//);

//******************** end_rd_txt_data_tb ********************//



//******************** save_map_ctrl_file ********************//

//save_file_tb #(
//  .DELAY_VALID_NUM (0), 
//  .DATA_WIDTH      (128),
//  .FILE_ADDR       ("/home/yys/Desktop/sim/map_ctrl/txt/map_cmd_rd1.txt"),
//  .cnt_data        (1036800),
//  .packet_select   (1)
//) u_save_map_cmd_rd1(
//  .rst_n    (rst_n),
//  .clk      (clk_300m),
//  .valid    (),
//  .data     (),
  
//  .cnt_valid()
//);
//******************** end_save_map_ctrl_file ********************//



endmodule