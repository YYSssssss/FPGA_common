`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jade_Yu
// 
// Create Date: 2023/11/03 16:01
// Design Name: Jade_Yu
// Module Name: rd_txt_data
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


module rd_txt_data_tb #(
  parameter    CODE_RUN_CNT             = 10 ,
  parameter    DATA_WIDTH               = 128,
  parameter    DATA_NUM                 = 1024,
  parameter    RAM_FILE                 = "/home/users/jade/work/XXX.txt",
  parameter    DELAY_BIT_DEPTH          = 0,
  parameter    DELAY_DATA_DEPTH         = 0,
  parameter    DELAY_ADDR_DEPTH         = 0,
  
  parameter    AXIS_DATA_WIDTH          = 8,
  parameter    AXIS_COLUMN              = 128,
  parameter    AXIS_ROW                 = 1024,
  parameter    AXIS_ROW_INTERVAL        = 16,
  parameter    AXIS_RUN_CNT             = 3,
  
  parameter    S_AXI4_DATA_WIDTH          = 32,
  parameter    S_AXI4_EVERY_REQ_ADDR_NUM  = 8,
  parameter    S_AXI4_MEM_DEPTH           = 1024,
  parameter    S_AXI4_MEM_FILE            = "/home/users/jade/work/XXX.txt",
  
  parameter    M_AXI4_DATA_WIDTH          = 32,
  parameter    M_AXI4_EVERY_REQ_ADDR_NUM  = 8,
  parameter    M_AXI4_BURST_LEN           = 2,
  parameter    M_AXI4_MEM_DEPTH           = 1024,
  parameter    M_AXI4_MEM_FILE            = "/home/users/jade/work/XXX.txt"
)
(
  input                                      clk            ,
  input                                      rst_n          ,
  input                                      rd_en          ,
  
  output [AXIS_DATA_WIDTH-1:0]               axis_tdata     ,
  output logic                               axis_tvalid    ,
  input                                      axis_tready    ,
  output                                     axis_tlast     ,

  output                                     rd_valid       ,
  output [DATA_WIDTH-1:0]                    rd_data        ,
  output [31:0]                              rd_addr        ,
  
  input  [30 : 0]                            s_axi4_araddr   ,
  input  [7 : 0]                             s_axi4_arlen    ,
  input  [2 : 0]                             s_axi4_arsize   ,
  input  [1 : 0]                             s_axi4_arburst  ,
  input                                      s_axi4_arvalid  ,
  output                                     s_axi4_arready  ,
  input                                      s_axi4_rready   ,
  output                                     s_axi4_rlast    ,
  output                                     s_axi4_rvalid   ,
  output [1 : 0]                             s_axi4_rresp    ,
  output [3 : 0]                             s_axi4_rid      ,
  output [S_AXI4_DATA_WIDTH - 1'b1 : 0]        s_axi4_rdata    ,  
  
  output  [30 : 0]                           m_axi4_araddr   ,
  output  [7 : 0]                            m_axi4_arlen    ,
  output  [2 : 0]                            m_axi4_arsize   ,
  output  [1 : 0]                            m_axi4_arburst  ,
  output                                     m_axi4_arvalid  ,
  input                                      m_axi4_arready  ,
  input                                      m_axi4_rready   ,
  output                                     m_axi4_rlast    ,
  output                                     m_axi4_rvalid   ,
  output [1 : 0]                             m_axi4_rresp    ,
  output [3 : 0]                             m_axi4_rid      ,
  output [S_AXI4_DATA_WIDTH - 1'b1 : 0]        m_axi4_rdata    
);

//********************  localparam  ********************//
localparam ADDRESS_WIDTH = 32;


//********************  logic  ********************//
logic [DATA_WIDTH-1:0]    mem [DATA_NUM-1:0];
logic [ADDRESS_WIDTH-1:0] s_rd_addr;
logic [DATA_WIDTH:0]      s_rd_data;
logic                     s_rd_valid;
logic [31:0]              cnt_rd_en;
logic [31:0]              cnt_run;

//******************** cnt ********************//
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    cnt_rd_en <= 0;
  end
  else begin
    if(cnt_rd_en == DATA_NUM) begin
      cnt_rd_en <= 0;
    end
    else if(rd_en == 1'b1)begin
      cnt_rd_en <= cnt_rd_en + 1;
    end
    else begin
      cnt_rd_en <= cnt_rd_en;
    end
  end
end



//******************** Indicative signal ********************//
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    cnt_run <= 0;
  end
  else begin
    if(cnt_run == CODE_RUN_CNT-1) begin
      cnt_run <= CODE_RUN_CNT-1;
    end
    else if(cnt_rd_en == DATA_NUM)begin
      cnt_run <= cnt_run + 1;
    end
    else begin
      cnt_run <= cnt_run;
    end
  end
end

initial begin
    $readmemh(RAM_FILE, mem);
    // $readmemh("/home/users/yuyushan/work/rsp_s1_prep/rsp_s1_prep_sim/input_data/rsp_s1_op_mst_a_0.txt", mem_1024x128);
end

//********************  rd  ********************//
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    s_rd_data <= 128'h00000000000000010000000200000003;
    s_rd_valid <= 1'b0;
  end
  else begin
    if(cnt_run == CODE_RUN_CNT-1) begin
      s_rd_data <= 0;
      s_rd_valid <= 1'b0;
    end
    else if(rd_en == 1'b1 && s_rd_addr < DATA_NUM)begin
      s_rd_data <= mem[s_rd_addr];
      s_rd_valid <= 1'b1;
    end
    else begin
      s_rd_data <= s_rd_data;
      s_rd_valid <= 0;
    end
  end
end
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    s_rd_addr <= 0;
  end
  else begin
    if(cnt_run == CODE_RUN_CNT-1) begin
      s_rd_addr <= 0;
    end
    else if(s_rd_addr == DATA_NUM) begin
      s_rd_addr <= 0;
    end
    else if(rd_en == 1'b1)begin
      s_rd_addr <= s_rd_addr + 1;
    end
    else begin
      s_rd_addr <= s_rd_addr;
    end
  end
end


delay_bit_tb #(
  .DELAY (DELAY_BIT_DEPTH)
) u_delay_valid(
  .clk    (clk), 
  .rst_n  (rst_n), 
  .din    (s_rd_valid), 
  .dout   (rd_valid)
);

delay_data_tb #(
  .DEPTH      (DELAY_DATA_DEPTH),
  .DATA_WIDTH (DATA_WIDTH)
) u_delay_txt_data(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (s_rd_data),
  .o_y0  (rd_data)
);
delay_data_tb #(
  .DEPTH      (DELAY_ADDR_DEPTH),
  .DATA_WIDTH (32)
) u_delay_txt_addr(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (s_rd_addr),
  .o_y0  (rd_addr)
);


axis_gen_data #(
    .AXIS_DATA_WIDTH     (AXIS_DATA_WIDTH   ),
    .AXIS_COLUMN         (AXIS_COLUMN       ),
    .AXIS_ROW            (AXIS_ROW          ),
    .AXIS_ROW_INTERVAL   (AXIS_ROW_INTERVAL ),
    .AXIS_RUN_CNT        (AXIS_RUN_CNT      )
) u_axis_gen_data(
    .clk           (clk),
    .rst_n         (rst_n),
    .axis_tdata    (axis_tdata ),
    .axis_tvalid   (axis_tvalid),
    .axis_tready   (axis_tready),
    .axis_tlast    (axis_tlast )
);

s_axi4_gen_data #(
    .AXI4_DATA_WIDTH            (S_AXI4_DATA_WIDTH        ),
    .AXI4_EVERY_REQ_ADDR_NUM    (S_AXI4_EVERY_REQ_ADDR_NUM),
    .AXI4_MEM_DEPTH             (S_AXI4_MEM_DEPTH         ),
    .AXI4_MEM_FILE              (S_AXI4_MEM_FILE          )
) u_s_axi4_gen_data(
    .clk            (clk  ),
    .rst_n          (rst_n),
                    
    .s_axi_araddr   (s_axi4_araddr ),
    .s_axi_arlen    (s_axi4_arlen  ),
    .s_axi_arsize   (s_axi4_arsize ),
    .s_axi_arburst  (s_axi4_arburst),
    .s_axi_arvalid  (s_axi4_arvalid),
    .s_axi_arready  (s_axi4_arready),
                    
    .s_axi_rready   (s_axi4_rready  ),
    .s_axi_rlast    (s_axi4_rlast   ),
    .s_axi_rvalid   (s_axi4_rvalid  ),
    .s_axi_rresp    (s_axi4_rresp   ),
    .s_axi_rid      (s_axi4_rid     ),
    .s_axi_rdata    (s_axi4_rdata   )

);

endmodule






/////////////////////////////////////delay bit or data/////////////////////////////////
module delay_bit_tb #(parameter DELAY = 1)
(
  input               clk,
  input               rst_n,
  
  input               din,
  output              dout
);
generate if (DELAY>=1) begin
  reg [DELAY-1:0]     shift_reg;
  
  always @(posedge clk or negedge rst_n)
    if (~rst_n)
      shift_reg <= {DELAY{1'b0}};
    else
      shift_reg <= {shift_reg[DELAY-1:0], din};

  assign dout = shift_reg[DELAY-1];
end else begin
  assign dout = din;
end
endgenerate
endmodule

module delay_data_tb #(
    parameter DEPTH = 2,
    parameter DATA_WIDTH = 16
)(
    input                   clk     ,
    input                   rst_n     ,
    //input                   i_data_valid,
    input [DATA_WIDTH-1:0]  i_x0    ,
    output[DATA_WIDTH-1:0]  o_y0

);
reg  [DATA_WIDTH-1:0] s_delay_data[DEPTH-1:0];
reg  [15:0]           gv_i;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	for (gv_i = 0; gv_i < DEPTH; gv_i = gv_i + 1) begin
        s_delay_data[gv_i] <= 16'h0000; // Initialize to 0
    end
  end
  else begin
    //s_delay_data[0] <= (i_data_valid == 1'b0) ? {DATA_WIDTH{1'b0}} : i_x0;
    s_delay_data[0] <= i_x0;
    for(gv_i=1; gv_i<DEPTH; gv_i = gv_i+1 )
      begin
        s_delay_data[gv_i]<=s_delay_data[gv_i-1];
      end
  end
end
assign o_y0 = (DEPTH==0) ? i_x0 : s_delay_data[DEPTH-1];

endmodule


module axis_gen_data #(
    parameter    AXIS_DATA_WIDTH   = 8,
    parameter    AXIS_COLUMN       = 128,
    parameter    AXIS_ROW          = 1024,
    parameter    AXIS_ROW_INTERVAL = 16,
    parameter    AXIS_RUN_CNT      = 3
)(
    input                                 clk           ,
    input                                 rst_n         ,
    output logic [AXIS_DATA_WIDTH-1:0]    axis_tdata    ,
    output logic                          axis_tvalid   ,
    input                                 axis_tready   ,
    output logic                          axis_tlast    
);

logic [31:0] cnt_all;
logic [31:0] cnt_column;
logic [31:0] cnt_INTERVAL;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	cnt_column <= 'd0;
  end
  else begin
    if(cnt_column == AXIS_COLUMN -1)
        cnt_column <= 'd0;
    else if(axis_tvalid && axis_tready)
        cnt_column <= cnt_column + 1'd1;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	cnt_all <= 'd0;
  end
  else begin
    if(cnt_all == AXIS_ROW -1 && cnt_column == AXIS_COLUMN -1)
        cnt_all <= 'd0;
    else if(cnt_column == AXIS_COLUMN -1)
        cnt_all <= cnt_all + 1'd1;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	cnt_INTERVAL <= 'd0;
  end
  else begin
    if(cnt_column == AXIS_COLUMN -1)
        cnt_INTERVAL <= 'd1;
    else if(cnt_INTERVAL == AXIS_ROW_INTERVAL)
        cnt_INTERVAL <= 'd0;
    else if(cnt_INTERVAL >= 'd1)
        cnt_INTERVAL <= cnt_INTERVAL + 1'b1;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	axis_tvalid <= 'd0;
  end
  else begin
    if(cnt_INTERVAL == 'd1 || (cnt_column == AXIS_COLUMN))
        axis_tvalid <= 1'b0;
    else if(cnt_column == 'd0 && cnt_INTERVAL == AXIS_ROW_INTERVAL-1)
        axis_tvalid <= 1'b1;
    else if(!axis_tready)
        axis_tvalid <= 1'b0;
    else if(axis_tready)
        axis_tvalid <= 1'b1;        
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	axis_tdata <= 'd0;
  end
  else begin
    if(cnt_all == AXIS_ROW -1 && cnt_column == AXIS_COLUMN -1)
        axis_tdata <= 'd0;
    else if(axis_tvalid && axis_tready)
        axis_tdata <= axis_tdata + 1'b1;       
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	axis_tlast <= 'd0;
  end
  else begin
    if(cnt_column == AXIS_COLUMN -1)
        axis_tlast <= 'd1;
    else
        axis_tlast <= 'd0;        
  end
end


endmodule







module s_axi4_gen_data #(
    parameter    AXI4_DATA_WIDTH            = 32,
    parameter    AXI4_EVERY_REQ_ADDR_NUM    = 8,
    parameter    AXI4_MEM_DEPTH             = 1024,
    parameter    AXI4_MEM_FILE              = ""
)(
    input                                 clk           ,
    input                                 rst_n         ,

//    output wire [30 : 0]                       s_axi_awaddr   ,
//    output wire [7 : 0]                        s_axi_awlen    ,
//    output wire [2 : 0]                        s_axi_awsize   ,
//    output wire [1 : 0]                        s_axi_awburst  ,
//    output wire                                s_axi_awvalid  ,
//    input  wire                                s_axi_awready  ,
    
//    output wire [AXI4_DATA_WIDTH - 1'b1 : 0]   s_axi_wdata    ,
//    output wire [31 : 0]                       s_axi_wstrb    ,
//    output wire                                s_axi_wlast    ,
//    output wire                                s_axi_wvalid   ,
//    input  wire                                s_axi_wready   ,
    
//    output wire                                s_axi_bready   ,
//    input  wire [3 : 0]                        s_axi_bid      ,
//    input  wire [1 : 0]                        s_axi_bresp    ,
//    input  wire                                s_axi_bvalid   ,
    
    input  wire [30 : 0]                       s_axi_araddr   ,
    input  wire [7 : 0]                        s_axi_arlen    ,
    input  wire [2 : 0]                        s_axi_arsize   ,
    input  wire [1 : 0]                        s_axi_arburst  ,
    input  wire                                s_axi_arvalid  ,
    output wire                                s_axi_arready  ,
   
    input   wire                                s_axi_rready   ,
    output  wire                                s_axi_rlast    ,
    output  reg                                 s_axi_rvalid   ,
    output  wire [1 : 0]                        s_axi_rresp    ,
    output  wire [3 : 0]                        s_axi_rid      ,
    output  logic  [AXI4_DATA_WIDTH - 1'b1 : 0]   s_axi_rdata    

);
//******************** parameter********************//
localparam OUTSTANDING = 32;
localparam RD_ADDR_OFFSET = 480*2;

//******************** wire reg logic assign  initial********************//
logic [31:0]                   rd_addr_ptr;
logic [31:0]                   rd_addr_buffer [AXI4_EVERY_REQ_ADDR_NUM-1:0];
logic [31:0]                   rd_addr;
logic [31:0]                   rd_addr_offset;
logic [AXI4_DATA_WIDTH-1:0]    mem [AXI4_MEM_DEPTH-1:0];
//logic [0:AXI4_DATA_WIDTH-1]    mem [AXI4_MEM_DEPTH-1:0];
logic [31:0]                   cnt_rd_addr;
logic [31:0]                   cnt_rd_data;
logic [31:0]                   cnt_wr;
logic                          s_axi_arready_d0;
logic                          s_axi_arready_d1;
logic                          s_axi_arready_pos;

initial begin
    $readmemh(AXI4_MEM_FILE, mem);
end

//******************** instructure signals ********************//
//delay_bit_tb #(
//  .DELAY (4)
//) u_delay_valid(
//  .clk    (clk), 
//  .rst_n  (rst_n), 
//  .din    (s_axi_arready), 
//  .dout   (d_s_axi_arready)
//);
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 s_axi_arready_d0 <= 'd0;
	 s_axi_arready_d1 <= 'd0;
  end
  else begin
     s_axi_arready_d0 <= s_axi_arready;    
     s_axi_arready_d1 <= s_axi_arready_d0;    
  end
end
assign s_axi_arready_pos = s_axi_arready_d0 & ~s_axi_arready_d1;

//always_ff @(posedge clk or negedge rst_n) begin
//  if(!rst_n) begin
//	 rd_addr_offset <= 'd0;
//  end
//  else begin
//     if(cnt_rd_addr == AXI4_EVERY_REQ_ADDR_NUM*2-1)
//        rd_addr_offset <= 'd0;
//     else if(s_axi_rlast)
//        rd_addr_offset <= rd_addr_offset + RD_ADDR_OFFSET;
//  end
//end



//******************** main ********************//
//rd_addr
assign s_axi_arready = s_axi_arvalid;

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 cnt_rd_addr <= 'd0;
  end
  else begin
    if(cnt_rd_addr == AXI4_EVERY_REQ_ADDR_NUM-1 && s_axi_rlast != 1'b1)
        cnt_rd_addr  <= 'd0;
    else if(s_axi_rready && s_axi_rvalid && s_axi_rlast != 1'b1)
        cnt_rd_addr  <= cnt_rd_addr + 1;        
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 rd_addr_ptr <= 'd0;
  end
  else begin
    if(cnt_rd_addr == AXI4_EVERY_REQ_ADDR_NUM-1 && s_axi_rlast != 1'b1)
        rd_addr_ptr  <= 'd0;
    else if(s_axi_arready && s_axi_arvalid)
        rd_addr_ptr  <= rd_addr_ptr + 1'b1;        
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
     for(integer i = 0;i < AXI4_EVERY_REQ_ADDR_NUM - 1;i = i + 1) begin
	   rd_addr_buffer[i] <= 'd0;
	 end
  end
  else begin
       rd_addr_buffer[rd_addr_ptr] <= s_axi_araddr / 16;   
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
     rd_addr <= 'd0;
  end
  else begin
    if(s_axi_rlast)
        rd_addr <= rd_addr_buffer[cnt_rd_addr];
    else if(s_axi_rready && s_axi_rvalid)
        rd_addr <= rd_addr_buffer[cnt_rd_addr] + 1; 
    else 
        rd_addr <= rd_addr_buffer[cnt_rd_addr];  
  end
end





//rd_data
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 cnt_wr <= 'd0;
  end
  else begin
    if(s_axi_rlast == 1'b1)
        cnt_wr  <= cnt_wr - 1'b1;   
    else if(s_axi_arready_pos)
        cnt_wr  <= 'd8;        
  end
end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 s_axi_rvalid <= 'd0;
  end
  else begin
    if(cnt_wr == 'd0)
        s_axi_rvalid  <=  'd0;
    else if(cnt_wr >= 'd1)
        s_axi_rvalid  <= 1'b1;        
  end
end

//always_ff @(posedge clk or negedge rst_n) begin
//  if(!rst_n) begin
//	 s_axi_rdata <= 'd0;
//  end
//  else begin
////    if(s_axi_rready && s_axi_rvalid)
//       s_axi_rdata  <= mem[rd_addr];
////    else
////       s_axi_rdata  <= 'd0;        
//  end
//end
assign s_axi_rdata = mem[rd_addr];


always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 cnt_rd_data <= 'd0;
  end
  else begin
    if(cnt_rd_data == s_axi_arlen)
        cnt_rd_data  <= 'd0;
    else if(s_axi_rready && s_axi_rvalid)
        cnt_rd_data  <= cnt_rd_data + 1;       
  end
end

assign s_axi_rlast = cnt_rd_data == s_axi_arlen;






//******************** output ********************//










endmodule


module m_axi4_gen_data #(
    parameter    SIM_M_AXI4_RUN_CNT                 = 5,
    parameter    M_AXI4_DATA_ITERATION_ACCMULATION  = 1,
    parameter    M_AXI4_DATA_RANDOM                 = 0,
    parameter    M_AXI4_DATA_WIDTH                  = 32,
    parameter    M_AXI4_EVERY_REQ_ADDR_NUM          = 8, //outstanding
    parameter    M_AXI4_EVERY_REQ_INTERVAL          = 8, //interval
    parameter    M_AXI4_BURST_LEN                   = 1,
    parameter    M_AXI4_MEM_DEPTH                   = 1024,
    parameter    M_AXI4_MEM_FILE                    = ""
)(
    input                                           clk           ,
    input                                           rst_n         ,
    
    output logic [30 : 0]                            m_axi_awaddr   ,
    output logic [7 : 0]                             m_axi_awlen    ,
    output logic [2 : 0]                             m_axi_awsize   ,
    output logic [1 : 0]                             m_axi_awburst  ,
    output logic                                     m_axi_awvalid  ,
    input  logic                                     m_axi_awready  ,
   
    input   logic                                    m_axi_wready   ,
    output  logic                                    m_axi_wlast    ,
    output  logic                                    m_axi_wvalid   ,
    output  logic [1 : 0]                            m_axi_wresp    ,
    output  logic [3 : 0]                            m_axi_wid      ,
    output  logic  [M_AXI4_DATA_WIDTH - 1'b1 : 0]    m_axi_wdata    

);
//******************** parameter********************//
localparam M_AXI_AWLEN = 4;
localparam BASE_ADDR = 'd0;
localparam WR_ADDR_ALL = 640*480*2/4/M_AXI_AWLEN;
localparam WR_DATA_ALL = 640*480*2/4;

//******************** wire reg logic assign  initial********************//
logic [15:0] cnt_wr_addr_all;
logic [15:0] cnt_wr_addr_burstlen;

assign m_axi_awlen = M_AXI_AWLEN - 1'b1;
assign m_axi_awburst = 'd1;

//******************** instructure signals ********************//
always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 cnt_wr_addr_burstlen <= 'd0;
  end
  else begin
    if(cnt_wr_addr_burstlen == M_AXI_AWLEN - 1'b1)
        cnt_wr_addr_burstlen <= 'd0;
    else if(m_axi_awready && m_axi_awvalid)
        m_axi_awaddr  <= m_axi_awaddr + m_axi_awaddr<<5;       
  end
end

//******************** main ********************//
//wr_addr
//always_ff @(posedge clk or negedge rst_n) begin
//  if(!rst_n) begin
//	 m_axi_awvalid <= 1'b0;
//  end
//  else begin
//    if(m_axi_awaddr == WR_ADDR_ALL - 1'b1)
        
//    else if(m_axi_awready && m_axi_awvalid)
//        m_axi_awvalid  <= 1'b1;
//    else 
//        m_axi_awvalid  <= 1'b0;
//  end
//end

always_ff @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	 m_axi_awaddr <= BASE_ADDR;
  end
  else begin
    if(m_axi_awaddr == WR_ADDR_ALL - 1'b1)
        m_axi_awaddr  <= BASE_ADDR;
    else if(m_axi_awready && m_axi_awvalid)
        m_axi_awaddr  <= m_axi_awaddr + m_axi_awaddr<<5;       
  end
end



//wr_data






endmodule