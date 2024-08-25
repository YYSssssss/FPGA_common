`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/20/2024 04:18:45 PM
// Design Name: 
// Module Name: pixel_out_ctrl
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


module pixel_out_ctrl #(
    parameter MODULE_DELAY          = 1,
    parameter DELAY_COORDINATE_VALID= 1,
    parameter PIXEL_DATA_WIDTH      = 16,
    parameter DATA_WIDTH            = 128,
    parameter DATA_BYTE             = DATA_WIDTH/8,
    parameter xKB_BLOCK_NUM         = 1152,         // 3840*2160*2*2 / 1024 / 28.125KB
    parameter xKB_DATA_NUM          = 992,          // 28.125KB * 1024 / 128bit
    parameter COORDINATE_NUM        = 7200/4,
    parameter COORDINATE_BLOCK_NUM  = 1152
)
(
    input                                           clk                             ,
    input                                           rstn                            ,
    input                                           soft_rstn                       ,
    
    input                                           i_pixel_ram_ctrl_tready         ,
    input                                           i_map_ctrl_tvalid               ,
    output reg                                      o_map_ctrl_tready               ,
    input      [DATA_WIDTH-1:0]                     i_map_ctrl_tdata                ,
    
    input                                           i_gdc_start                     ,
    input                                           i_ram_ready                     ,
    input      [2-1:0]                              i_wr_ram_id                     ,                     
    output reg [2-1:0]                              o_rd_ram_id                     ,
    output                                          o_pixel_out_ctrl_finish         
);

//******************** parameter ********************//
localparam INIT_TIME          = 16'd50;
localparam RD_WAIT_NUM        = 4'd2;
localparam INIT               = 5'b00000;
localparam IDLE               = 5'b00001;
localparam RD_RAM_A           = 5'b00010;
localparam RD_RAM_B           = 5'b00100;
localparam RD_RAM_A_WAIT      = 5'b01000;
localparam RD_RAM_B_WAIT      = 5'b10000;

reg [5-1:0] c_state;
reg [5-1:0] n_state;


localparam PIXEL_RAM_CTRL_INIT_TIME_WIDTH       = $clog2(INIT_TIME);
localparam PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH  = $clog2(COORDINATE_NUM);
localparam PIXEL_RAM_CTRL_COORDINATE_BLOCK_NUM_WIDTH  = $clog2(COORDINATE_BLOCK_NUM);

//******************** reg wire logic assign********************//
reg [PIXEL_RAM_CTRL_INIT_TIME_WIDTH     : 0]     cnt_init_time;
reg [PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH  : 0]     cnt_coordinate_num;
reg [PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH  : 0]     cnt_coordinate_num_1;
reg [PIXEL_RAM_CTRL_COORDINATE_BLOCK_NUM_WIDTH  : 0]     cnt_coordinate_block_num;

reg         gdc_start_d0;     
reg         gdc_start_d1;     
reg         gdc_start_pos;

reg [3:0]   cnt_rd_wait;
wire   map_ctrl_tvalid_d0;
wire   map_ctrl_tready_d0;




assign o_pixel_out_ctrl_finish = (cnt_coordinate_block_num == COORDINATE_BLOCK_NUM) && (cnt_coordinate_num_1 == COORDINATE_NUM);
delay_bit #(1) u_delay_ready(.clk(clk), .rst_n(rstn), .din(i_map_ctrl_tready), .dout(map_ctrl_tready_d0));
delay_bit #(1) u_delay_valid(.clk(clk), .rst_n(rstn), .din(i_map_ctrl_tvalid), .dout(map_ctrl_tvalid_d0));


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
        cnt_init_time <= {PIXEL_RAM_CTRL_INIT_TIME_WIDTH{1'b0}};
    end
    else begin
        if (!soft_rstn)
            cnt_init_time <= {PIXEL_RAM_CTRL_INIT_TIME_WIDTH{1'b0}};
        else if(cnt_init_time == INIT_TIME - 1'b1)
            cnt_init_time <= cnt_init_time;
        else
            cnt_init_time <= cnt_init_time + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_coordinate_num <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
    end
    else begin
        if(gdc_start_pos == 1'b1)
            cnt_coordinate_num <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
        else if(o_rd_ram_id == 2'd0)
            cnt_coordinate_num <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
        else if(cnt_coordinate_num == COORDINATE_NUM - 1'b1)
            cnt_coordinate_num <= cnt_coordinate_num;//different
//        else if(i_map_ctrl_tvalid && o_map_ctrl_tready)
        else if(i_map_ctrl_tvalid)
            cnt_coordinate_num <= cnt_coordinate_num + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_coordinate_num_1 <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
    end
    else begin
        if(gdc_start_pos == 1'b1)
            cnt_coordinate_num_1 <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
        else if(o_rd_ram_id == 2'd0)
            cnt_coordinate_num_1 <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
        else if(cnt_coordinate_num_1 == COORDINATE_NUM - 1'b1)
            cnt_coordinate_num_1 <= cnt_coordinate_num_1 + 1'b1; //different
//        else if(i_map_ctrl_tvalid && o_map_ctrl_tready)
        else if(i_map_ctrl_tvalid)
            cnt_coordinate_num_1 <= cnt_coordinate_num_1 + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_coordinate_block_num <= {PIXEL_RAM_CTRL_COORDINATE_BLOCK_NUM_WIDTH{1'b0}};
    end
    else begin
        if(gdc_start_pos == 1'b1)
            cnt_coordinate_block_num <= {PIXEL_RAM_CTRL_COORDINATE_BLOCK_NUM_WIDTH{1'b0}};
        else if(c_state == INIT)
            cnt_coordinate_block_num <= {PIXEL_RAM_CTRL_COORDINATE_BLOCK_NUM_WIDTH{1'b0}};
        else if(cnt_coordinate_num_1 == COORDINATE_NUM - 1'b1)
            cnt_coordinate_block_num <= cnt_coordinate_block_num + 1'b1;
    end
end

//******************** pixel_out_ctrl_state_machine ********************//
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
                    if(i_ram_ready == 1'b1)
                        n_state = RD_RAM_A;
                    else
                        n_state = IDLE;
                end
            RD_RAM_A : begin
//                    if(cnt_coordinate_num == COORDINATE_NUM - 1'b1 && i_map_ctrl_tvalid && o_map_ctrl_tready)
                    if(cnt_coordinate_num == COORDINATE_NUM - 1'b1 && i_map_ctrl_tvalid)
                        n_state = RD_RAM_A_WAIT;
                    else
                        n_state = RD_RAM_A;
                end
            RD_RAM_B : begin
//                    if(cnt_coordinate_num == COORDINATE_NUM - 1'b1 && i_map_ctrl_tvalid && o_map_ctrl_tready)
                    if(cnt_coordinate_num == COORDINATE_NUM - 1'b1 && i_map_ctrl_tvalid)
                        n_state = RD_RAM_B_WAIT;
                    else
                        n_state = RD_RAM_B;
                end
            RD_RAM_A_WAIT : begin
                    if(cnt_coordinate_block_num == COORDINATE_BLOCK_NUM)
                        n_state = INIT;
//                    else if(o_rd_ram_id == 2'd0 && cnt_rd_wait == RD_WAIT_NUM)
                    else if(o_rd_ram_id == 2'd0)
                        n_state = RD_RAM_B;
                    else
                        n_state = RD_RAM_A_WAIT;
                end
            RD_RAM_B_WAIT : begin
                    if(cnt_coordinate_block_num == COORDINATE_BLOCK_NUM)
                        n_state = INIT;
//                    else if(o_rd_ram_id == 2'd0 && cnt_rd_wait == RD_WAIT_NUM)
                    else if(o_rd_ram_id == 2'd0)
                        n_state = RD_RAM_A;
                    else
                        n_state = RD_RAM_B_WAIT;
                end
            default : ;
        endcase
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_rd_wait <= 4'b0;
        o_rd_ram_id   <= 2'd0;
        o_map_ctrl_tready <= 1'b0;
    end
    else begin
        case (n_state) 
            INIT : begin
                    cnt_rd_wait <= 4'b0;
                    o_rd_ram_id   <= 2'd0;
                    o_map_ctrl_tready <= 1'b0;
                end
            IDLE : begin
                    cnt_rd_wait <= 4'b0;
                    o_rd_ram_id   <= 2'd0;
                    o_map_ctrl_tready <= 1'b0;
                end
            RD_RAM_A : begin
                    cnt_rd_wait <= 4'b0;
                    o_rd_ram_id   <= 2'd1;
                    
                    o_map_ctrl_tready <= i_pixel_ram_ctrl_tready;
                end
            RD_RAM_B : begin
                    cnt_rd_wait <= 4'b0;
                    o_rd_ram_id   <= 2'd2;
//                    o_map_ctrl_tready <= 1'b1;
                    o_map_ctrl_tready <= i_pixel_ram_ctrl_tready;
                end
            RD_RAM_A_WAIT : begin
                    if(cnt_rd_wait == RD_WAIT_NUM)
                        cnt_rd_wait <= cnt_rd_wait;
                    else
                        cnt_rd_wait <= cnt_rd_wait + 1'b1;
            
                    if(cnt_coordinate_num == COORDINATE_NUM - 1'b1 && cnt_rd_wait == RD_WAIT_NUM && i_wr_ram_id == 2'd0)
                        o_rd_ram_id   <= 2'd0;
                    else
                        o_rd_ram_id   <= 2'd1;
                    
                    o_map_ctrl_tready <= 1'b0;
                    
                end
            RD_RAM_B_WAIT : begin
                    if(cnt_rd_wait == RD_WAIT_NUM)
                        cnt_rd_wait <= cnt_rd_wait;
                    else
                        cnt_rd_wait <= cnt_rd_wait + 1'b1;
                        
                    if(cnt_coordinate_num == COORDINATE_NUM - 1'b1 && cnt_rd_wait == RD_WAIT_NUM && i_wr_ram_id == 2'd0)
                        o_rd_ram_id   <= 2'd0;
                    else
                        o_rd_ram_id   <= 2'd2;
                        
                    o_map_ctrl_tready <= 1'b0;
                end
            default : ;
        endcase
    end
end

//always@(posedge clk or negedge rstn)begin
//    if(!rstn) begin
//        o_map_ctrl_tready <= 1'b0;
//    end
//    else begin
//        if(gdc_start_pos == 1'b1)
//            o_map_ctrl_tready <= 1'b0;
//        else if(c_state == RD_RAM_A)
//            o_map_ctrl_tready <= 1'b1;
//        else if(c_state == RD_RAM_B)
//            o_map_ctrl_tready <= 1'b1;
//        else
//            o_map_ctrl_tready <= 2'd0;
//    end
//end

    
    
    
    
    
endmodule
