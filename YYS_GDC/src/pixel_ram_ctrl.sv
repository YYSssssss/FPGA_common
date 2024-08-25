`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: YU GAN WEI
// Engineer: Jade Yu 
// 
// Create Date: 08/19/2024 04:07:47 PM
// Design Name: 
// Module Name: pixel_ram_ctrl
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


module pixel_ram_ctrl #(
    parameter MODULE_DELAY          = 1,
    parameter DELAY_COORDINATE_VALID= 1,
    parameter PIXEL_DATA_WIDTH      = 16,
    parameter DATA_WIDTH            = 128,
    parameter DATA_BYTE             = DATA_WIDTH/8,
    parameter xKB_BLOCK_NUM         = 1152,  
    parameter xKB_DATA_NUM          = 1024,  
    parameter COORDINATE_NUM        = 1800,
    parameter COORDINATE_BLOCK_NUM  = 1152
)
(
    input                                           clk                             ,
    input                                           rstn                            ,
    input                                           soft_rstn                       ,
    
    input                                           i_dma_tvalid                    ,
    output reg                                      o_dma_tready                    ,
    input      [DATA_WIDTH-1:0]                     i_dma_tdata                     ,
   
    input                                           i_map_ctrl_tvalid               ,
    output reg                                      o_map_ctrl_tready               ,
    input      [DATA_WIDTH-1:0]                     i_map_ctrl_tdata                ,
    
    input                                           i_pixel_ram_ctrl_tready         ,
    output reg                                      o_pixel_ram_ctrl_tvalid         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata0         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata1         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata2         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata3         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata4         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata5         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata6         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata7         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata8         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata9         ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata10        ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata11        ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata12        ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata13        ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata14        ,
    output reg [PIXEL_DATA_WIDTH-1:0]               o_pixel_ram_ctrl_tdata15        ,
    
    input                                           i_gdc_start                     ,
//    input                                           i_pixel_ram_ctrl_start          ,
    output                                          o_pixel_ram_ctrl_finish  
    
);

//******************** parameter ********************//
localparam INIT_TIME          = 16'd50;
localparam WRITE_WAIT_TIME    = 4'd2;
localparam INIT               = 5'b00000;
localparam IDLE               = 5'b00001;
localparam WRITE_A            = 5'b00010;
localparam WRITE_B            = 5'b00100;
localparam WRITE_WAIT_A       = 5'b01000;
localparam WRITE_WAIT_B       = 5'b10000;
reg [5-1:0] c_state;
reg [5-1:0] n_state;

localparam RAM_NUM            = 4'd8;

localparam PIXEL_RAM_CTRL_INIT_TIME_WIDTH     = $clog2(INIT_TIME);
localparam PIXEL_RAM_CTRL_xKB_BLOCK_NUM_WIDTH = $clog2(xKB_BLOCK_NUM);
localparam PIXEL_RAM_CTRL_xKB_DATA_NUM_WIDTH  = $clog2(xKB_DATA_NUM);
//localparam PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH  = $clog2(COORDINATE_NUM);

//******************** reg wire logic assign********************//
reg [PIXEL_RAM_CTRL_INIT_TIME_WIDTH     : 0]     cnt_init_time;
reg [PIXEL_RAM_CTRL_xKB_DATA_NUM_WIDTH  : 0]     cnt_xkb_data_num;
reg [PIXEL_RAM_CTRL_xKB_BLOCK_NUM_WIDTH : 0]     cnt_xkb_block_num;
//reg [PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH  : 0]     cnt_coordinate_num_d0;
reg [3:0] cnt_wr_wait;

reg         gdc_start_d0;     
reg         gdc_start_d1;     
reg         gdc_start_pos;

reg         ram_ready;
reg [2-1:0] rd_ram_id;//0:IDLE     1:RAM_A     2:RAM_B
reg [2-1:0] wr_ram_id;//0:IDLE     1:RAM_A     2:RAM_B

wire        coordinate_valid;
wire        coordinate_valid_d0;
wire        pixel_out_ctrl_finish;

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
        cnt_xkb_data_num <= {PIXEL_RAM_CTRL_xKB_DATA_NUM_WIDTH{1'b0}};
    end
    else begin
        if(gdc_start_pos == 1'b1)
            cnt_xkb_data_num <= {PIXEL_RAM_CTRL_xKB_DATA_NUM_WIDTH{1'b0}};
        else if(cnt_xkb_data_num == xKB_DATA_NUM - 1'b1)
            cnt_xkb_data_num <= {PIXEL_RAM_CTRL_xKB_DATA_NUM_WIDTH{1'b0}};
        else if(o_dma_tready && i_dma_tvalid)
            cnt_xkb_data_num <= cnt_xkb_data_num + 1'b1;

    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_xkb_block_num <= {PIXEL_RAM_CTRL_xKB_BLOCK_NUM_WIDTH{1'b0}};
    end
    else begin
        if(gdc_start_pos == 1'b1)
            cnt_xkb_block_num <= {PIXEL_RAM_CTRL_xKB_BLOCK_NUM_WIDTH{1'b0}};
        else if(cnt_xkb_data_num == xKB_DATA_NUM - 1'b1)
            cnt_xkb_block_num <= cnt_xkb_block_num + 1'b1;

    end
end



//always@(posedge clk or negedge rstn)begin
//    if(!rstn) begin
//        cnt_coordinate_num_d0 <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
//    end
//    else begin
//        if(gdc_start_pos == 1'b1)
//            cnt_coordinate_num_d0 <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
//        else if(cnt_coordinate_num_d0 == COORDINATE_NUM - 1'b1)
//            cnt_coordinate_num_d0 <= {PIXEL_RAM_CTRL_COORDINATE_NUM_WIDTH{1'b0}};
//        else if(coordinate_valid)
//            cnt_coordinate_num_d0 <= cnt_coordinate_num_d0 + 1'b1;
//    end
//end

//******************** pixel_ram_ctrl_state_machine ********************//
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
                    if(cnt_xkb_data_num == xKB_DATA_NUM - 1'b1)
                        n_state = WRITE_WAIT_A;
                    else
                        n_state = WRITE_A;
                end
            WRITE_B : begin
                    if(cnt_xkb_data_num == xKB_DATA_NUM - 1'b1)
                        n_state = WRITE_WAIT_B;
                    else
                        n_state = WRITE_B;
                end
            WRITE_WAIT_A : begin
                    if(cnt_xkb_block_num == xKB_BLOCK_NUM && pixel_out_ctrl_finish == 1'b1)
                        n_state = IDLE;
                    else if(rd_ram_id == 2'd1 && cnt_wr_wait == WRITE_WAIT_TIME)
                        n_state = WRITE_B;
                    else
                        n_state = WRITE_WAIT_A;
                end
            WRITE_WAIT_B : begin
                    if(cnt_xkb_block_num == xKB_BLOCK_NUM && pixel_out_ctrl_finish == 1'b1)
                        n_state = IDLE;
                    else if(rd_ram_id == 2'd2 && cnt_wr_wait == WRITE_WAIT_TIME)
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
        o_dma_tready<= 1'b0;
        cnt_wr_wait <= 8'b0;
        wr_ram_id   <= 2'd0;
        ram_ready   <= 1'b0;
    end
    else begin
        case (n_state) 
            INIT : begin
                    o_dma_tready<= 1'b0;
                    cnt_wr_wait <= 8'b0;
                    wr_ram_id   <= 2'd0;
                    ram_ready   <= 1'b0;
                end
            IDLE : begin
                    o_dma_tready<= 1'b0;
                    cnt_wr_wait <= 8'b0;
                    wr_ram_id   <= 2'd0;
                    ram_ready   <= 1'b0;
                end
            WRITE_A : begin
                    o_dma_tready<= 1'b1;
                    cnt_wr_wait <= 8'b0;
                    wr_ram_id <= 2'd1;
                end
            WRITE_B : begin
                    o_dma_tready<= 1'b1;
                    cnt_wr_wait <= 8'b0;
                    wr_ram_id <= 2'd2;
                end
            WRITE_WAIT_A : begin
                    o_dma_tready<= 1'b0;
            
                    if(cnt_wr_wait == WRITE_WAIT_TIME)
                        cnt_wr_wait <= cnt_wr_wait;
                    else
                        cnt_wr_wait <= cnt_wr_wait + 1'b1;
                        
                    wr_ram_id   <= 2'd0;
                    
                    ram_ready   <= 1'b1;
                end
            WRITE_WAIT_B : begin
                    o_dma_tready<= 1'b0;
            
                    if(cnt_wr_wait == WRITE_WAIT_TIME)
                        cnt_wr_wait <= cnt_wr_wait;
                    else
                        cnt_wr_wait <= cnt_wr_wait + 1'b1;
                        
                    wr_ram_id <= 2'd0;
                end
            default : ;
        endcase
    end
end



//******************** pixel out ctrl ********************//
pixel_out_ctrl #(
    .MODULE_DELAY           (MODULE_DELAY),
    .DELAY_COORDINATE_VALID (DELAY_COORDINATE_VALID),
    .PIXEL_DATA_WIDTH       (PIXEL_DATA_WIDTH),
    .DATA_WIDTH             (DATA_WIDTH),
    .DATA_BYTE              (DATA_WIDTH/8),
    .xKB_BLOCK_NUM          (xKB_BLOCK_NUM),     
    .xKB_DATA_NUM           (xKB_DATA_NUM),          
    .COORDINATE_NUM         (COORDINATE_NUM),
    .COORDINATE_BLOCK_NUM   (COORDINATE_BLOCK_NUM)
) u_pixel_out_ctrl(
    .clk                             (clk                    ),
    .rstn                            (rstn                   ),
    .soft_rstn                       (soft_rstn              ),
    .i_pixel_ram_ctrl_tready         (i_pixel_ram_ctrl_tready),
    .i_map_ctrl_tvalid               (i_map_ctrl_tvalid      ),
    .o_map_ctrl_tready               (o_map_ctrl_tready      ),
    .i_map_ctrl_tdata                (i_map_ctrl_tdata       ),
    .i_gdc_start                     (i_gdc_start            ),
    .i_ram_ready                     (ram_ready              ),
    .i_wr_ram_id                     (wr_ram_id              ),                     
    .o_rd_ram_id                     (rd_ram_id              ),
    .o_pixel_out_ctrl_finish         (pixel_out_ctrl_finish  )
);


//******************** ram ********************//
//logic           ram_a_ena   [RAM_NUM - 1 : 0];
logic           ram_a_wea   [RAM_NUM - 1 : 0];
logic [12 : 0]  ram_a_addra [RAM_NUM - 1 : 0];
logic [127: 0]  ram_a_dina  [RAM_NUM - 1 : 0];
logic [15 : 0]  ram_a_douta [RAM_NUM - 1 : 0];
//logic           ram_a_enb   [RAM_NUM - 1 : 0];
logic [12 : 0]  ram_a_addrb [RAM_NUM - 1 : 0];
//logic [127: 0]  ram_a_dinb  [RAM_NUM - 1 : 0];
logic [15 : 0]  ram_a_doutb [RAM_NUM - 1 : 0];
//logic           ram_b_ena   [RAM_NUM - 1 : 0];
logic           ram_b_wea   [RAM_NUM - 1 : 0];
logic [12 : 0]  ram_b_addra [RAM_NUM - 1 : 0];
logic [127: 0]  ram_b_dina  [RAM_NUM - 1 : 0];
logic [15 : 0]  ram_b_douta [RAM_NUM - 1 : 0];
//logic           ram_b_enb   [RAM_NUM - 1 : 0];
logic [12 : 0]  ram_b_addrb [RAM_NUM - 1 : 0];
//logic [127: 0]  ram_b_dinb  [RAM_NUM - 1 : 0];
logic [15 : 0]  ram_b_doutb [RAM_NUM - 1 : 0];

reg  [15:0]  map_addr [15:0];
wire         dma_handshake_d0;

delay_bit #(1) u_o_dma_tready(.clk(clk), .rst_n(rstn), .din(o_dma_tready && i_dma_tvalid), .dout(dma_handshake_d0));

//always@(posedge clk or negedge rstn)begin
//    if(!rstn) begin
//        for(integer i = 0; i < RAM_NUM; i = i + 1) begin
//            map_addr[i] <= 16'b0;
//        end
//    end
//    else begin
//        map_addr[0 ] <= i_map_ctrl_tdata[31:0];
//        map_addr[1 ] <= i_map_ctrl_tdata[31:0] + 'd1;
//        map_addr[2 ] <= i_map_ctrl_tdata[31:0] + 'd2;
//        map_addr[3 ] <= i_map_ctrl_tdata[31:0] + 'd3;
//        map_addr[4 ] <= i_map_ctrl_tdata[63:32];      
//        map_addr[5 ] <= i_map_ctrl_tdata[63:32] + 'd1;
//        map_addr[6 ] <= i_map_ctrl_tdata[63:32] + 'd2;
//        map_addr[7 ] <= i_map_ctrl_tdata[63:32] + 'd3;
//        map_addr[8 ] <= i_map_ctrl_tdata[95:64];      
//        map_addr[9 ] <= i_map_ctrl_tdata[95:64] + 'd1;
//        map_addr[10] <= i_map_ctrl_tdata[95:64] + 'd2;
//        map_addr[11] <= i_map_ctrl_tdata[95:64] + 'd3;
//        map_addr[12] <= i_map_ctrl_tdata[127:96];      
//        map_addr[13] <= i_map_ctrl_tdata[127:96] + 'd1;
//        map_addr[14] <= i_map_ctrl_tdata[127:96] + 'd2;
//        map_addr[15] <= i_map_ctrl_tdata[127:96] + 'd3;
//    end
//end
//assign map_addr[0 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[31:0]        ;
//assign map_addr[1 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[31:0]   + 'd1;
//assign map_addr[2 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[31:0]   + 'd2;
//assign map_addr[3 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[31:0]   + 'd3;
//assign map_addr[4 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[63:32]       ;      
//assign map_addr[5 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[63:32]  + 'd1;
//assign map_addr[6 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[63:32]  + 'd2;
//assign map_addr[7 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[63:32]  + 'd3;
//assign map_addr[8 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[95:64]       ;       
//assign map_addr[9 ] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[95:64]  + 'd1;
//assign map_addr[10] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[95:64]  + 'd2;
//assign map_addr[11] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[95:64]  + 'd3;
//assign map_addr[12] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[127:96]      ;      
//assign map_addr[13] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[127:96] + 'd1;
//assign map_addr[14] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[127:96] + 'd2;
//assign map_addr[15] = (ram_ready==1'b1) ? 'd0 : i_map_ctrl_tdata[127:96] + 'd3;

assign map_addr[0 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[31:0]         : 'd0;
assign map_addr[1 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[31:0]   + 'd1 : 'd0;
assign map_addr[2 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[31:0]   + 'd2 : 'd0;
assign map_addr[3 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[31:0]   + 'd3 : 'd0;
assign map_addr[4 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[63:32]        : 'd0;
assign map_addr[5 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[63:32]  + 'd1 : 'd0;
assign map_addr[6 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[63:32]  + 'd2 : 'd0;
assign map_addr[7 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[63:32]  + 'd3 : 'd0;
assign map_addr[8 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[95:64]        : 'd0;
assign map_addr[9 ] = (ram_ready==1'b1) ? i_map_ctrl_tdata[95:64]  + 'd1 : 'd0;
assign map_addr[10] = (ram_ready==1'b1) ? i_map_ctrl_tdata[95:64]  + 'd2 : 'd0;
assign map_addr[11] = (ram_ready==1'b1) ? i_map_ctrl_tdata[95:64]  + 'd3 : 'd0;
assign map_addr[12] = (ram_ready==1'b1) ? i_map_ctrl_tdata[127:96]       : 'd0;
assign map_addr[13] = (ram_ready==1'b1) ? i_map_ctrl_tdata[127:96] + 'd1 : 'd0;
assign map_addr[14] = (ram_ready==1'b1) ? i_map_ctrl_tdata[127:96] + 'd2 : 'd0;
assign map_addr[15] = (ram_ready==1'b1) ? i_map_ctrl_tdata[127:96] + 'd3 : 'd0;



always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        for(integer i = 0; i < RAM_NUM; i = i + 1) begin
            ram_a_wea[i]   <= 1'b0;
            ram_a_addra[i] <= 13'b0;
            ram_a_dina[i]  <= {PIXEL_DATA_WIDTH{1'b0}};
            ram_a_addrb[i] <= 13'b0;
            
            ram_b_wea[i]   <= 1'b0;
            ram_b_addra[i] <= 13'b0;
            ram_b_dina[i]  <= {PIXEL_DATA_WIDTH{1'b0}};
            ram_b_addrb[i] <= 13'b0;
        end
    end
    else begin
        if(gdc_start_pos == 1'b1) begin
            for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                ram_a_wea[i]   <= 1'b0;
                ram_a_addra[i] <= 13'b0;
                ram_a_dina[i]  <= {PIXEL_DATA_WIDTH{1'b0}};
                ram_a_addrb[i] <= 13'b0;
                
                ram_b_wea[i]   <= 1'b0;
                ram_b_addra[i] <= 13'b0;
                ram_b_dina[i]  <= {PIXEL_DATA_WIDTH{1'b0}};
                ram_b_addrb[i] <= 13'b0;
            end
        end   
        else if(wr_ram_id == 2'd1 || rd_ram_id == 2'd2) begin
            if(o_dma_tready && i_dma_tvalid) begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_a_wea[i]   <= 1'b1;
                    ram_a_dina[i]  <= i_dma_tdata;
                end
            end
            else begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_a_wea[i]   <= 1'b0;
                    ram_a_dina[i]  <= ram_a_dina[i];
                end
            end
            
            if(dma_handshake_d0 == 1'b1) begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_a_addra[i] <= ram_a_addra[i] + 4'd8;
                end
            end
            else begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_a_addra[i] <= ram_a_addra[i];
                end
            end
            
            for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                ram_a_addrb[i] <= 13'b0;
            end
            
            ram_b_addra[0] <= map_addr[0 ];
            ram_b_addrb[0] <= map_addr[1 ];
            ram_b_addra[1] <= map_addr[2 ];
            ram_b_addrb[1] <= map_addr[3 ];
            ram_b_addra[2] <= map_addr[4 ];
            ram_b_addrb[2] <= map_addr[5 ];
            ram_b_addra[3] <= map_addr[6 ];
            ram_b_addrb[3] <= map_addr[7 ];
            ram_b_addra[4] <= map_addr[8 ];
            ram_b_addrb[4] <= map_addr[9 ];
            ram_b_addra[5] <= map_addr[10];
            ram_b_addrb[5] <= map_addr[11];
            ram_b_addra[6] <= map_addr[12];
            ram_b_addrb[6] <= map_addr[13];
            ram_b_addra[7] <= map_addr[14];
            ram_b_addrb[7] <= map_addr[15];
        end
        else if(wr_ram_id == 2'd2 || rd_ram_id == 2'd1) begin
            if(o_dma_tready && i_dma_tvalid) begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_b_wea[i]   <= 1'b1;
                    ram_b_dina[i]  <= i_dma_tdata;
                end
            end
            else begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_b_wea[i]   <= 1'b0;
                    ram_b_dina[i]  <= ram_a_dina[i];
                end
            end
            
            if(dma_handshake_d0 == 1'b1) begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_b_addra[i] <= ram_b_addra[i] + 4'd8;
                end
            end
            else begin
                for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                    ram_b_addra[i] <= ram_b_addra[i];
                end
            end
            
            for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                ram_b_addrb[i] <= 13'b0;
            end
            
            ram_a_addra[0] <= map_addr[0 ];
            ram_a_addrb[0] <= map_addr[1 ];
            ram_a_addra[1] <= map_addr[2 ];
            ram_a_addrb[1] <= map_addr[3 ];
            ram_a_addra[2] <= map_addr[4 ];
            ram_a_addrb[2] <= map_addr[5 ];
            ram_a_addra[3] <= map_addr[6 ];
            ram_a_addrb[3] <= map_addr[7 ];
            ram_a_addra[4] <= map_addr[8 ];
            ram_a_addrb[4] <= map_addr[9 ];
            ram_a_addra[5] <= map_addr[10];
            ram_a_addrb[5] <= map_addr[11];
            ram_a_addra[6] <= map_addr[12];
            ram_a_addrb[6] <= map_addr[13];
            ram_a_addra[7] <= map_addr[14];
            ram_a_addrb[7] <= map_addr[15];
        end
        else begin
            for(integer i = 0; i < RAM_NUM; i = i + 1) begin
                ram_a_wea[i]   <= 1'b0;
                ram_a_addra[i] <= 13'b0;
                ram_a_dina[i]  <= {PIXEL_DATA_WIDTH{1'b0}};
                ram_a_addrb[i] <= 13'b0;
                
                ram_b_wea[i]   <= 1'b0;
                ram_b_addra[i] <= 13'b0;
                ram_b_dina[i]  <= {PIXEL_DATA_WIDTH{1'b0}};
                ram_b_addrb[i] <= 13'b0;
            end
        end
    end
end


generate
    genvar RAM_A_INDEX;
    for(RAM_A_INDEX = 0 ; RAM_A_INDEX < RAM_NUM; RAM_A_INDEX = RAM_A_INDEX + 1) begin
        pixel_ram_16KB A_u_pixel_ram_16KB (
            .clka   (clk                     ),  // input wire clka
            .ena    (1'b1                    ),  // input wire ena
            .wea    (ram_a_wea[RAM_A_INDEX]  ),  // input wire [0 : 0] wea
            .addra  (ram_a_addra[RAM_A_INDEX]),  // input wire [12 : 0] addra
            .dina   (ram_a_dina[RAM_A_INDEX] ),  // input wire [127 : 0] dina
            .douta  (ram_a_douta[RAM_A_INDEX]),  // output wire [15 : 0] douta
            .clkb   (clk                     ),  // input wire clkb
            .enb    (1'b1                    ),  // input wire enb
            .web    (1'b0                    ),  // input wire [0 : 0] web
            .addrb  (ram_a_addrb[RAM_A_INDEX]),  // input wire [12 : 0] addrb
            .dinb   (128'd0                  ),  // input wire [127 : 0] dinb
            .doutb  (ram_a_doutb[RAM_A_INDEX])   // output wire [15 : 0] doutb
        );
    end
    
    genvar RAM_B_INDEX;
    for(RAM_B_INDEX = 0 ; RAM_B_INDEX < RAM_NUM; RAM_B_INDEX = RAM_B_INDEX + 1) begin
        pixel_ram_16KB B_u_pixel_ram_16KB (
            .clka   (clk                     ),  // input wire clka
            .ena    (1'b1                    ),  // input wire ena
            .wea    (ram_b_wea[RAM_B_INDEX]  ),  // input wire [0 : 0] wea
            .addra  (ram_b_addra[RAM_B_INDEX]),  // input wire [12 : 0] addra
            .dina   (ram_b_dina[RAM_B_INDEX] ),  // input wire [127 : 0] dina
            .douta  (ram_b_douta[RAM_B_INDEX]),  // output wire [15 : 0] douta
            .clkb   (clk                     ),  // input wire clkb
            .enb    (1'b1                    ),  // input wire enb
            .web    (1'b0                    ),  // input wire [0 : 0] web
            .addrb  (ram_b_addrb[RAM_B_INDEX]),  // input wire [12 : 0] addrb
            .dinb   (128'd0                  ),  // input wire [127 : 0] dinb
            .doutb  (ram_b_doutb[RAM_B_INDEX])   // output wire [15 : 0] doutb
        );
    end
endgenerate














//******************** output ********************//
delay_bit #(DELAY_COORDINATE_VALID) u_coordinate_valid(.clk(clk), .rst_n(rstn), .din(i_map_ctrl_tvalid), .dout(coordinate_valid));
delay_bit #(DELAY_COORDINATE_VALID+1) u_coordinate_valid_d0(.clk(clk), .rst_n(rstn), .din(coordinate_valid), .dout(coordinate_valid_d0));
delay_bit #(DELAY_COORDINATE_VALID+9) u_pixel_out_ctrl_finish(.clk(clk), .rst_n(rstn), .din(pixel_out_ctrl_finish), .dout(o_pixel_ram_ctrl_finish));

assign o_pixel_ram_ctrl_tvalid = coordinate_valid_d0;

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        o_pixel_ram_ctrl_tdata0  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata1  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata2  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata3  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata4  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata5  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata6  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata7  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata8  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata9  <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata10 <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata11 <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata12 <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata13 <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata14 <= {PIXEL_DATA_WIDTH{1'b0}};
        o_pixel_ram_ctrl_tdata15 <= {PIXEL_DATA_WIDTH{1'b0}};
    end
    else begin
        if(gdc_start_pos) begin
            o_pixel_ram_ctrl_tdata0  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata1  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata2  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata3  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata4  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata5  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata6  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata7  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata8  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata9  <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata10 <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata11 <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata12 <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata13 <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata14 <= {PIXEL_DATA_WIDTH{1'b0}};
            o_pixel_ram_ctrl_tdata15 <= {PIXEL_DATA_WIDTH{1'b0}};
        end
        else if(rd_ram_id == 2'd1) begin
            o_pixel_ram_ctrl_tdata0  <= ram_a_douta[0];
            o_pixel_ram_ctrl_tdata1  <= ram_a_doutb[0];
            o_pixel_ram_ctrl_tdata2  <= ram_a_douta[1];
            o_pixel_ram_ctrl_tdata3  <= ram_a_doutb[1];
            o_pixel_ram_ctrl_tdata4  <= ram_a_douta[2];
            o_pixel_ram_ctrl_tdata5  <= ram_a_doutb[2];
            o_pixel_ram_ctrl_tdata6  <= ram_a_douta[3];
            o_pixel_ram_ctrl_tdata7  <= ram_a_doutb[3];
            o_pixel_ram_ctrl_tdata8  <= ram_a_douta[4];
            o_pixel_ram_ctrl_tdata9  <= ram_a_doutb[4];
            o_pixel_ram_ctrl_tdata10 <= ram_a_douta[5];
            o_pixel_ram_ctrl_tdata11 <= ram_a_doutb[5];
            o_pixel_ram_ctrl_tdata12 <= ram_a_douta[6];
            o_pixel_ram_ctrl_tdata13 <= ram_a_doutb[6];
            o_pixel_ram_ctrl_tdata14 <= ram_a_douta[7];
            o_pixel_ram_ctrl_tdata15 <= ram_a_doutb[7];
        end
        else if(rd_ram_id == 2'd2) begin
            o_pixel_ram_ctrl_tdata0  <= ram_b_douta[0];
            o_pixel_ram_ctrl_tdata1  <= ram_b_doutb[0];
            o_pixel_ram_ctrl_tdata2  <= ram_b_douta[1];
            o_pixel_ram_ctrl_tdata3  <= ram_b_doutb[1];
            o_pixel_ram_ctrl_tdata4  <= ram_b_douta[2];
            o_pixel_ram_ctrl_tdata5  <= ram_b_doutb[2];
            o_pixel_ram_ctrl_tdata6  <= ram_b_douta[3];
            o_pixel_ram_ctrl_tdata7  <= ram_b_doutb[3];
            o_pixel_ram_ctrl_tdata8  <= ram_b_douta[4];
            o_pixel_ram_ctrl_tdata9  <= ram_b_doutb[4];
            o_pixel_ram_ctrl_tdata10 <= ram_b_douta[5];
            o_pixel_ram_ctrl_tdata11 <= ram_b_doutb[5];
            o_pixel_ram_ctrl_tdata12 <= ram_b_douta[6];
            o_pixel_ram_ctrl_tdata13 <= ram_b_doutb[6];
            o_pixel_ram_ctrl_tdata14 <= ram_b_douta[7];
            o_pixel_ram_ctrl_tdata15 <= ram_b_doutb[7];
        end
    end
end











//******************** debug ********************//
//1800
//1152

logic [31:0] debug_cnt_coordinate_valid_d0;
logic [31:0] debug_cnt_coordinate_block_d0;

//debug_cnt
logic [31:0] debug_cnt_wr1_rd2;
logic [31:0] debug_cnt_wr2_rd1;

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        debug_cnt_wr2_rd1 <= 'd0;
        debug_cnt_wr1_rd2 <= 'd0;
        
    end
    else begin
        if(gdc_start_pos == 1'b1) begin
            debug_cnt_wr2_rd1 <= 'd0;
            debug_cnt_wr1_rd2 <= 'd0;
        end   
        else if(wr_ram_id == 2'd1 || rd_ram_id == 2'd2) begin
            debug_cnt_wr2_rd1 <= 'd0;
            if(i_map_ctrl_tvalid == 1'b1 && rd_ram_id == 2'd2)
                debug_cnt_wr1_rd2 <= debug_cnt_wr1_rd2 + 1'b1;
        end
        else if(wr_ram_id == 2'd2 || rd_ram_id == 2'd1) begin
            debug_cnt_wr1_rd2 <= 'd0;
            if(i_map_ctrl_tvalid == 1'b1 && rd_ram_id == 2'd1)
                debug_cnt_wr2_rd1 <= debug_cnt_wr2_rd1 + 1'b1;
        end
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        debug_cnt_coordinate_valid_d0 <= 'd0;
    end
    else begin
        if(debug_cnt_coordinate_valid_d0 == COORDINATE_NUM -1)
            debug_cnt_coordinate_valid_d0 <= 'd0;
        else if(coordinate_valid_d0 == 1'b1)
            debug_cnt_coordinate_valid_d0 <= debug_cnt_coordinate_valid_d0 + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        debug_cnt_coordinate_block_d0 <= 'd0;
    end
    else begin
        if(o_pixel_ram_ctrl_finish == 'd1)
            debug_cnt_coordinate_block_d0 <= 'd0;
        else if(debug_cnt_coordinate_valid_d0 == COORDINATE_NUM -1)
            debug_cnt_coordinate_block_d0 <= debug_cnt_coordinate_block_d0 + 1'b1;
    end
end







    
endmodule