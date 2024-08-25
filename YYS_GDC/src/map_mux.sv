`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YU GAN WEI
// Engineer: Jade Yu 
// 
// Create Date: 08/06/2024 09:20:23 AM
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


module map_mux #(
    parameter MODULE_DELAY       = 1,
    parameter MAP_DATA_WIDTH     = 128 ,
    parameter DELAY_RD_FINISH    = 10  ,
    parameter xKB_BLOCK_NUM      = 1152,  // 3840*2160*2*2 / 1024 / 28.125KB
    parameter xKB_DATA_NUM       = 1800   // 28.125KB * 1024 / 128bit
)(

    input                                           clk                     ,
    input                                           rstn                    ,
    input                                           soft_rstn               ,
    
    input                                           s_axis_tvalid           ,
    output reg                                      s_axis_tready           ,
    input      [MAP_DATA_WIDTH-1:0]                 s_axis_tdata            ,
    
    output reg                                      m_axis_tvalid           ,
    input                                           m_axis_tready           ,
    output reg [MAP_DATA_WIDTH-1:0]                 m_axis_tdata            ,
    
    input                                           i_gdc_start             ,
    input      [2-1:0]                              i_rd_fifo_en_id         ,//0:IDLE     1:FIFO_A     2:FIFO_B
    output reg [2-1:0]                              o_wr_fifo_en_id         ,//0:IDLE     1:FIFO_A     2:FIFO_B
//    input                                           i_bypass_backpressure ,
    output reg                                      o_rd_fifo_start         ,
    input                                           i_rd_finish  

);

//******************** parameter ********************//
localparam WRITE_WAIT_TIME    = 8'd3;
localparam INIT_TIME          = 16'd50;
localparam INIT               = 5'b00000;
localparam IDLE               = 5'b00001;
localparam WRITE_A            = 5'b00010;
localparam WRITE_B            = 5'b00100;
localparam WRITE_WAIT_A       = 5'b01000;
localparam WRITE_WAIT_B       = 5'b10000;
reg [5-1:0] c_state;
reg [5-1:0] n_state;

localparam MAP_MUX_INIT_TIME_WIDTH         = $clog2(INIT_TIME);
localparam MAP_MUX_xKB_DATA_NUM_WIDTH      = $clog2(xKB_DATA_NUM);
localparam MAP_MUX_xKB_BLOCK_NUM_WIDTH     = $clog2(xKB_BLOCK_NUM);

//******************** reg wire logic assign********************//
reg [MAP_MUX_INIT_TIME_WIDTH - 1 : 0]     cnt_init_time;
reg [MAP_MUX_xKB_DATA_NUM_WIDTH - 1 : 0]  cnt_s_axis_handshake;
reg [MAP_MUX_xKB_BLOCK_NUM_WIDTH - 1 : 0] cnt_block;
reg [7:0] cnt_wr_wait;

reg                              s_axis_fifo_tvalid      [2-1:0];             
wire                             s_axis_fifo_tready      [2-1:0];        
reg  [MAP_DATA_WIDTH-1 : 0]      s_axis_fifo_tdata       [2-1:0];
wire                             m_axis_fifo_tvalid      [2-1:0];        
reg                              m_axis_fifo_tready      [2-1:0];         
wire [MAP_DATA_WIDTH-1 : 0]      m_axis_fifo_tdata       [2-1:0];
wire [31 : 0]                    fifo_axis_wr_data_count [2-1:0];
wire [31 : 0]                    fifo_axis_rd_data_count [2-1:0];
wire                             fifo_almost_empty       [2-1:0];        
wire                             fifo_prog_empty         [2-1:0];        
wire                             fifo_almost_full        [2-1:0];        
wire                             fifo_prog_full          [2-1:0];  

reg         gdc_start_d0;     
reg         gdc_start_d1;     
reg         gdc_start_pos;    

reg         rd_finish_d0;     
reg         rd_finish_d1;     
reg         rd_finish_pos;
wire        rd_finish;

reg                      m_axis_tvalid_d0;
reg [MAP_DATA_WIDTH-1:0] m_axis_tdata_d0;


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
        cnt_init_time <= {MAP_MUX_INIT_TIME_WIDTH{1'b0}};
    end
    else begin
        if (!soft_rstn)
            cnt_init_time <= {MAP_MUX_INIT_TIME_WIDTH{1'b0}};
        else if(cnt_init_time == INIT_TIME - 1'b1)
            cnt_init_time <= cnt_init_time;
        else
            cnt_init_time <= cnt_init_time + 1'b1;
    end
end

//one block s_axis_handshake count
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_s_axis_handshake <= {MAP_MUX_xKB_DATA_NUM_WIDTH{1'b0}};
    end
    else begin
        if (!soft_rstn || gdc_start_pos)
            cnt_s_axis_handshake <= {MAP_MUX_xKB_DATA_NUM_WIDTH{1'b0}};
        else if(o_wr_fifo_en_id == 2'd0)
            cnt_s_axis_handshake <= {MAP_MUX_xKB_DATA_NUM_WIDTH{1'b0}};
        else if(s_axis_tvalid && s_axis_tready)
            cnt_s_axis_handshake <= cnt_s_axis_handshake + 1'b1;
    end
end

//block count
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_block <= {MAP_MUX_xKB_BLOCK_NUM_WIDTH{1'b0}};
    end
    else begin
        if (!soft_rstn || gdc_start_pos)
            cnt_block <= {MAP_MUX_xKB_BLOCK_NUM_WIDTH{1'b0}};
//        else if(cnt_block == xKB_BLOCK_NUM - 1'b1 && cnt_s_axis_handshake == xKB_DATA_NUM - 1'b1)
//            cnt_block <= {MAP_MUX_xKB_BLOCK_NUM_WIDTH{1'b0}};
        else if(cnt_s_axis_handshake == xKB_DATA_NUM - 1'b1 && s_axis_tvalid && s_axis_tready)
            cnt_block <= cnt_block + 1'b1;
    end
end


always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        rd_finish_d0 <= 1'b0;
        rd_finish_d1 <= 1'b0;
    end
    else begin
        rd_finish_d0 <= i_rd_finish;
        rd_finish_d1 <= rd_finish_d0;
    end
end
assign rd_finish_pos = rd_finish_d0 && ~rd_finish_d1;

//********************map mux state machine ********************//
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
                if(cnt_init_time == INIT_TIME - 1'b1)
                    n_state = IDLE;
                else
                    n_state = INIT;
            end
            IDLE : begin
                    if(gdc_start_pos == 1'b1)
                        n_state = WRITE_A;
                    else
                        n_state = IDLE;
                end
            WRITE_A : begin
                    if(cnt_s_axis_handshake == xKB_DATA_NUM - 1'b1 && s_axis_tvalid && s_axis_tready)
                        n_state = WRITE_WAIT_A;
                    else
                        n_state = WRITE_A;
                end
            WRITE_B : begin
                    if(cnt_s_axis_handshake == xKB_DATA_NUM - 1'b1 && s_axis_tvalid && s_axis_tready)
                        n_state = WRITE_WAIT_B;
                    else
                        n_state = WRITE_B;
                end
            WRITE_WAIT_A : begin
                    if(rd_finish_pos == 1'b1)
                        n_state = IDLE;
                    else if(cnt_block == xKB_BLOCK_NUM)
                        n_state = WRITE_WAIT_A;
                    else if(i_rd_fifo_en_id == 2'd1)
                        n_state = WRITE_B;
                    else
                        n_state = WRITE_WAIT_A;
                end
            WRITE_WAIT_B : begin
                    if(rd_finish_pos == 1'b1)
                        n_state = IDLE;
                    else if(cnt_block == xKB_BLOCK_NUM)
                        n_state = WRITE_WAIT_B;
                    else if(i_rd_fifo_en_id == 2'd2)
                        n_state = WRITE_A;
                    else
                        n_state = WRITE_WAIT_B;
                end
            default : ;
        endcase
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_wr_wait <= 8'b0;
        s_axis_tready <= 1'b0;
        o_wr_fifo_en_id <= 2'd0;
    end
    else begin
        case (n_state) 
            INIT : begin
                    cnt_wr_wait <= 8'b0;
                    s_axis_tready <= 1'b0;
                    o_wr_fifo_en_id <= 2'd0;
                end
            IDLE : begin
                    cnt_wr_wait <= 8'b0;
                    s_axis_tready <= 1'b0;
                    o_wr_fifo_en_id <= 2'd0;
                end
            WRITE_A : begin
                    cnt_wr_wait <= 8'b0;
                    o_wr_fifo_en_id <= 2'd1;
                    s_axis_tready <= (cnt_block == xKB_BLOCK_NUM) ? 1'b0 : s_axis_fifo_tready[0];
                end
            WRITE_B : begin
                    cnt_wr_wait <= 8'b0;
                    o_wr_fifo_en_id <= 2'd2;
                    s_axis_tready <= (cnt_block == xKB_BLOCK_NUM) ? 1'b0 : s_axis_fifo_tready[1];
                end
            WRITE_WAIT_A : begin
                    if(cnt_wr_wait == WRITE_WAIT_TIME)
                        cnt_wr_wait <= cnt_wr_wait;
                    else
                        cnt_wr_wait <= cnt_wr_wait + 1'b1;
                        
                    o_wr_fifo_en_id <= 2'd0;
                    s_axis_tready <= 1'b0;
                end
            WRITE_WAIT_B : begin
                    if(cnt_wr_wait == WRITE_WAIT_TIME)
                        cnt_wr_wait <= cnt_wr_wait;
                    else
                        cnt_wr_wait <= cnt_wr_wait + 1'b1;
                        
                    o_wr_fifo_en_id <= 2'd0;
                    s_axis_tready <= 1'b0;
                end
            default : ;
        endcase
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        o_rd_fifo_start <= 'd0;
    end
    else begin
        if(gdc_start_pos == 1'b1 || i_rd_finish == 1'b1)
            o_rd_fifo_start <= 'd0;
        else if(cnt_s_axis_handshake == xKB_DATA_NUM - 1'b1)
            o_rd_fifo_start <= 1'b1;  
    end
end


//******************** fifo ********************//
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        s_axis_fifo_tvalid[0] <= 1'b0;
        s_axis_fifo_tdata[0]  <= {MAP_DATA_WIDTH{1'b0}};
    end
    else begin
        if(c_state == WRITE_A) begin
            s_axis_fifo_tvalid[0] <= s_axis_tvalid;
            s_axis_fifo_tdata[0]  <= s_axis_tdata;
        end
        else begin
            s_axis_fifo_tvalid[0] <= 1'b0;                  
            s_axis_fifo_tdata[0]  <= {MAP_DATA_WIDTH{1'b0}};
        end  
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        s_axis_fifo_tvalid[1] <= 1'b0;
        s_axis_fifo_tdata[1]  <= {MAP_DATA_WIDTH{1'b0}};
    end
    else begin
        if(c_state == WRITE_B) begin
            s_axis_fifo_tvalid[1] <= s_axis_tvalid;
            s_axis_fifo_tdata[1]  <= s_axis_tdata;
        end
        else begin
            s_axis_fifo_tvalid[1] <= 1'b0;                  
            s_axis_fifo_tdata[1]  <= {MAP_DATA_WIDTH{1'b0}};
        end  
    end
end

delay_bit #(DELAY_RD_FINISH) u_delay_valid(.clk(clk), .rst_n(rstn), .din(rd_finish_pos), .dout(rd_finish));

map_fifo u_map_fifo_A (
  .s_axis_aresetn       (rstn || rd_finish),             // input wire s_axis_aresetn
  .s_axis_aclk          (clk ),             // input wire s_axis_aclk
  .s_axis_tvalid        (s_axis_fifo_tvalid[0]),           // input wire s_axis_tvalid
  .s_axis_tready        (s_axis_fifo_tready[0]),           // output wire s_axis_tready
  .s_axis_tdata         (s_axis_fifo_tdata[0] ),           // input wire [127 : 0] s_axis_tdata
  .m_axis_tvalid        (m_axis_fifo_tvalid[0]),           // output wire m_axis_tvalid
  .m_axis_tready        (m_axis_fifo_tready[0]),           // input wire m_axis_tready
  .m_axis_tdata         (m_axis_fifo_tdata[0] ),           // output wire [127 : 0] m_axis_tdata
  .axis_wr_data_count   (fifo_axis_wr_data_count[0]),           // output wire [31 : 0] axis_wr_data_count
  .axis_rd_data_count   (fifo_axis_rd_data_count[0]),           // output wire [31 : 0] axis_rd_data_count
  .almost_empty         (fifo_almost_empty[0] ),           // output wire almost_empty
  .prog_empty           (fifo_prog_empty[0]   ),           // output wire prog_empty
  .almost_full          (fifo_almost_full[0]  ),           // output wire almost_full
  .prog_full            (fifo_prog_full[0]    )            // output wire prog_full
);

map_fifo u_map_fifo_B (
  .s_axis_aresetn       (rstn || rd_finish),             // input wire s_axis_aresetn
  .s_axis_aclk          (clk ),             // input wire s_axis_aclk
  .s_axis_tvalid        (s_axis_fifo_tvalid[1]),           // input wire s_axis_tvalid
  .s_axis_tready        (s_axis_fifo_tready[1]),           // output wire s_axis_tready
  .s_axis_tdata         (s_axis_fifo_tdata[1] ),           // input wire [127 : 0] s_axis_tdata
  .m_axis_tvalid        (m_axis_fifo_tvalid[1]),           // output wire m_axis_tvalid
  .m_axis_tready        (m_axis_fifo_tready[1]),           // input wire m_axis_tready
  .m_axis_tdata         (m_axis_fifo_tdata[1] ),           // output wire [127 : 0] m_axis_tdata
  .axis_wr_data_count   (fifo_axis_wr_data_count[1]),           // output wire [31 : 0] axis_wr_data_count
  .axis_rd_data_count   (fifo_axis_rd_data_count[1]),           // output wire [31 : 0] axis_rd_data_count
  .almost_empty         (fifo_almost_empty[1] ),           // output wire almost_empty
  .prog_empty           (fifo_prog_empty[1]   ),           // output wire prog_empty
  .almost_full          (fifo_almost_full[1]  ),           // output wire almost_full
  .prog_full            (fifo_prog_full[1]    )            // output wire prog_full
);



//******************** output ********************//
assign m_axis_fifo_tready[0] = (i_rd_fifo_en_id == 'd1) ? m_axis_tready : 1'b0;
assign m_axis_fifo_tready[1] = (i_rd_fifo_en_id == 'd2) ? m_axis_tready : 1'b0;
assign m_axis_tvalid         = (i_rd_fifo_en_id == 'd1) ? m_axis_fifo_tvalid[0] : (i_rd_fifo_en_id == 'd2 ? m_axis_fifo_tvalid[1] : 1'b0);
assign m_axis_tdata          = (i_rd_fifo_en_id == 'd1) ? m_axis_fifo_tdata[0] : (i_rd_fifo_en_id == 'd2 ? m_axis_fifo_tdata[1] : 1'b0);

//always@(posedge clk or negedge rstn)begin
//    if(!rstn) begin
//        m_axis_tvalid <= 1'b0;
//        m_axis_tdata  <= {MAP_DATA_WIDTH{1'b0}};
//    end
//    else begin
//        if(i_rd_fifo_en_id == 'd0 && m_axis_tready == 1'b0) begin
//            m_axis_tvalid         <= 1'b0;
//            m_axis_tdata          <= {MAP_DATA_WIDTH{1'b0}};
//        end
//        else if(i_rd_fifo_en_id == 'd1 && m_axis_fifo_tready[0] == 1'b1 && m_axis_fifo_tvalid[0]) begin
//            m_axis_tvalid         <= m_axis_fifo_tvalid[0];
//            m_axis_tdata          <= m_axis_fifo_tdata[0];
//        end
//        else if(i_rd_fifo_en_id == 'd2 && m_axis_fifo_tready[1] == 1'b1 && m_axis_fifo_tvalid[1]) begin
//            m_axis_tvalid         <= m_axis_fifo_tvalid[1];
//            m_axis_tdata          <= m_axis_fifo_tdata[1];
//        end
//    end
//end






    
endmodule