`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YU GAN WEI
// Engineer: Jade Yu 
// 
// Create Date: 08/13/2024 03:25:28 PM
// Design Name: 
// Module Name: map_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module map_ctrl #(
    parameter MODULE_DELAY          = 1,
    parameter DATA_WIDTH            = 128,
    parameter DATA_BYTE             = DATA_WIDTH/8,
    parameter xKB_BLOCK_NUM         = 1152,  // 3840*2160*2*2 / 1024 / 28.125KB
    parameter xKB_DATA_NUM          = 1800,  // 28.125KB * 1024 / 128bit
    parameter PICTURE_H             = 3840,
    parameter PICTURE_V             = 2160,
    parameter MAP_DATA_BYTE         = PICTURE_H * PICTURE_V * 2 * 2,
    parameter LAST_xKB_BLOCK_NUM    = 1152,  // 3840*2160*2*2 / 1024 / 28.125KB
    parameter LAST_xKB_DATA_NUM     = 1800   // 28.125KB * 1024 / 128bit
)
(
    input                                           clk                     ,
    input                                           rstn                    ,
    input                                           soft_rstn               ,
    
    input                                           s_axis_tvalid           ,
    output logic                                    s_axis_tready           ,
    input      [DATA_WIDTH-1:0]                     s_axis_tdata            ,
    
    output logic                                    map_ctrl_m_axis_tvalid           ,
    input                                           map_ctrl_m_axis_tready           ,
    output reg [DATA_WIDTH-1:0]                     map_ctrl_m_axis_tdata            ,
    
    input                                           i_gdc_start                      ,
    input  reg [2-1:0]                              i_wr_fifo_en_id                  ,//0:IDLE     1:FIFO_A     2:FIFO_B
    output reg [2-1:0]                              o_rd_fifo_en_id                  ,//0:IDLE     1:FIFO_A     2:FIFO_B
    input                                           i_map_ctrl_start                 ,
    output                                          o_map_ctrl_finish  
    
    );

//******************** parameter ********************//
localparam INIT_TIME          = 16'd50;
localparam RD_WAIT_NUM        = 4'd2;
localparam INIT               = 5'b00000;
localparam IDLE               = 5'b00001;
localparam RD_FIFO_A          = 5'b00010;
localparam RD_FIFO_B          = 5'b00100;
localparam RD_FIFO_A_WAIT     = 5'b01000;
localparam RD_FIFO_B_WAIT     = 5'b10000;
reg [5-1:0] c_state;
reg [5-1:0] n_state;

localparam INIT_TIME_WIDTH              = $clog2(INIT_TIME);
localparam MAP_CTRL_xKB_BLOCK_NUM_WIDTH = $clog2(xKB_BLOCK_NUM);
localparam MAP_CTRL_xKB_DATA_NUM_WIDTH  = $clog2(xKB_DATA_NUM);

//******************** reg wire logic assign********************//
reg [INIT_TIME_WIDTH    : 0] cnt_init_time;
reg [MAP_CTRL_xKB_DATA_NUM_WIDTH : 0] cnt_xKB_DATA;
reg [MAP_CTRL_xKB_BLOCK_NUM_WIDTH: 0] cnt_xKB_BLOCK;


reg         gdc_start_d0;     
reg         gdc_start_d1;     
reg         gdc_start_pos; 

reg [3:0]   cnt_rd_wait;
reg         rd_ping_pong_flag;

wire        s_axis_tready_d0;

assign o_map_ctrl_finish = (cnt_xKB_DATA == LAST_xKB_DATA_NUM - 1'b1) && (cnt_xKB_BLOCK == LAST_xKB_BLOCK_NUM - 1'b1);

//******************** instruct ********************//
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        gdc_start_d0 <= 1'b0;
        gdc_start_d1 <= 1'b0;
    end
    else begin
        gdc_start_d0 <= i_gdc_start;
        gdc_start_d1 <= gdc_start_d0;
    end
end
assign gdc_start_pos = gdc_start_d0 && ~gdc_start_d1;

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_init_time <= {INIT_TIME_WIDTH{1'b0}};
    end
    else begin
        if (!soft_rstn)
            cnt_init_time <= {INIT_TIME_WIDTH{1'b0}};
        else if(cnt_init_time == INIT_TIME - 1'b1)
            cnt_init_time <= cnt_init_time;
        else
            cnt_init_time <= cnt_init_time + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_xKB_DATA <= 'd0;
    end
    else begin
        if(gdc_start_pos == 1'b1)
            cnt_xKB_DATA <= 'd0;
        else if(o_rd_fifo_en_id == 2'd0)
            cnt_xKB_DATA <= 'd0;
        else if(map_ctrl_m_axis_tvalid && i_map_ctrl_start == 1'b1)
            cnt_xKB_DATA <= cnt_xKB_DATA + 1'b1;

    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_xKB_BLOCK <= 'd0;
    end
    else begin
        if(gdc_start_pos == 1'b1)
            cnt_xKB_BLOCK <= 'd0;
        else if(cnt_xKB_DATA == xKB_DATA_NUM - 1'b1 && map_ctrl_m_axis_tvalid)
            cnt_xKB_BLOCK <= cnt_xKB_BLOCK + 1'b1;

    end
end

  
//********************map ctrl state machine ********************//
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        c_state <= 'd0;
    end
    else begin
        c_state <= n_state;  
    end
end

always@(*)begin
    if(!rstn) begin
        n_state = INIT;
    end
    else begin
        case (c_state) 
            INIT : begin
                if(cnt_init_time == INIT_TIME - 1'b1 && gdc_start_pos == 1'b1)
                    n_state = IDLE;
                else
                    n_state = INIT;
            end
            IDLE : begin
                    if(i_map_ctrl_start == 1'b1)
                        n_state = RD_FIFO_A;
                    else
                        n_state = IDLE;
                end
            RD_FIFO_A : begin
                    if(cnt_xKB_DATA == xKB_DATA_NUM - 1'b1 && map_ctrl_m_axis_tvalid)
                        n_state = RD_FIFO_A_WAIT;
                    else
                        n_state = RD_FIFO_A;
                end
            RD_FIFO_B : begin
                    if(cnt_xKB_DATA == xKB_DATA_NUM - 1'b1 && map_ctrl_m_axis_tvalid)
                        n_state = RD_FIFO_B_WAIT;
                    else
                        n_state = RD_FIFO_B;
                end
            RD_FIFO_A_WAIT : begin
                    if(cnt_xKB_BLOCK == LAST_xKB_BLOCK_NUM)
                        n_state = INIT;
                    else if(o_rd_fifo_en_id == 2'd0)
                        n_state = RD_FIFO_B;
                    else
                        n_state = RD_FIFO_A_WAIT;
                end
            RD_FIFO_B_WAIT : begin
                    if(cnt_xKB_BLOCK == LAST_xKB_BLOCK_NUM)
                        n_state = INIT;
                    else if(o_rd_fifo_en_id == 2'd0)
                        n_state = RD_FIFO_A;
                    else
                        n_state = RD_FIFO_B_WAIT;
                end
            
            default : ;
        endcase
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_rd_wait            <= 4'b0;
        o_rd_fifo_en_id        <= 2'b0;
        s_axis_tready          <= 1'b0;
    end
    else begin
        case (n_state) 
            INIT : begin
                   cnt_rd_wait       <= 4'b0;
                   o_rd_fifo_en_id   <= 2'b0;
                   s_axis_tready     <= 1'b0;
                end
            IDLE : begin
                   cnt_rd_wait       <= 4'b0;
                   s_axis_tready     <= 1'b0;
                   o_rd_fifo_en_id   <= 2'd0;
                end
            RD_FIFO_A : begin
                   cnt_rd_wait       <= 4'b0;
                   o_rd_fifo_en_id   <= 2'd1;
                   s_axis_tready     <= map_ctrl_m_axis_tready;
                end
            RD_FIFO_B : begin
                   cnt_rd_wait       <= 4'b0;
                   o_rd_fifo_en_id   <= 2'd2;
                   s_axis_tready     <= map_ctrl_m_axis_tready;
                end
            RD_FIFO_A_WAIT : begin
                   if(cnt_xKB_DATA == xKB_DATA_NUM && i_wr_fifo_en_id == 2'd0)
                        o_rd_fifo_en_id   <= 2'd0;
                    else
                        o_rd_fifo_en_id   <= 2'd1;
                   s_axis_tready     <= 1'b0;
                end
            RD_FIFO_B_WAIT : begin
                   if(cnt_xKB_DATA == xKB_DATA_NUM && i_wr_fifo_en_id == 2'd0)
                        o_rd_fifo_en_id   <= 2'd0;
                    else
                        o_rd_fifo_en_id   <= 2'd2;
                   s_axis_tready     <= 1'b0;
                end
            
            default : ;
        endcase
    end
end


//******************** OUTPUT ********************//
logic [DATA_WIDTH - 1 : 0] s_axis_tdata_d0;
logic [DATA_WIDTH - 1 : 0] s_axis_tdata_d1;
logic                      s_axis_tvalid_d0;
logic                      s_axis_tvalid_d1;
delay_bit #(2) u_delay_ready(.clk(clk), .rst_n(rstn), .din(s_axis_tready), .dout(s_axis_tready_d0));
delay_bit #(2) u_delay_valid(.clk(clk), .rst_n(rstn), .din(s_axis_tvalid), .dout(s_axis_tvalid_d0));
assign map_ctrl_m_axis_tvalid = s_axis_tvalid_d0 && s_axis_tready_d0;
//assign s_axis_tvalid_d1 = s_axis_tvalid_d0 && s_axis_tready_d0;

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        map_ctrl_m_axis_tdata  <= {DATA_WIDTH{1'b0}};
    end
    else begin
        if(gdc_start_pos == 1'b1) begin
            map_ctrl_m_axis_tdata  <= {DATA_WIDTH{1'b0}}; 
        end
        else begin
            s_axis_tdata_d0         <= s_axis_tdata; 
            map_ctrl_m_axis_tdata   <= s_axis_tdata_d0; 
        end
    end
end   

//always@(posedge clk or negedge rstn)begin
//    if(!rstn) begin
//        s_axis_tdata_d1  <= {DATA_WIDTH{1'b0}};
//    end
//    else begin
//        if(gdc_start_pos == 1'b1) begin
//            s_axis_tdata_d1  <= {DATA_WIDTH{1'b0}}; 
//        end
//        else begin
//            s_axis_tdata_d0         <= s_axis_tdata; 
//            s_axis_tdata_d1   <= s_axis_tdata_d0; 
//        end
//    end
//end   

//map_ctrl_fifo_0 u_map_ctrl_fifo_0 (
//  .s_axis_aresetn   (rstn  ),  // input wire s_axis_aresetn
//  .s_axis_aclk      (clk   ),        // input wire s_axis_aclk
//  .s_axis_tvalid    (s_axis_tvalid_d1 ),    // input wire s_axis_tvalid
//  .s_axis_tready    (s_axis_tready    ),    // output wire s_axis_tready
//  .s_axis_tdata     (s_axis_tdata_d1  ),      // input wire [127 : 0] s_axis_tdata
//  .m_axis_tvalid    (map_ctrl_m_axis_tvalid ),    // output wire m_axis_tvalid
//  .m_axis_tready    (map_ctrl_m_axis_tready ),    // input wire m_axis_tready
//  .m_axis_tdata     (map_ctrl_m_axis_tdata  )      // output wire [127 : 0] m_axis_tdata
//);
    
endmodule
