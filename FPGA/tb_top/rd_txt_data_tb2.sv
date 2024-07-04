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
  parameter CODE_RUN_CNT     = 10 ,
  parameter DATA_WIDTH       = 128,
  parameter DATA_NUM         = 1024,
  parameter FILE_ADDR        = "/home/users/yuyushan/work/XXX.txt",
  parameter DELAY_BIT_DEPTH  = 0,
  parameter DELAY_DATA_DEPTH = 0,
  parameter DELAY_ADDR_DEPTH = 0,
  parameter    AXIS_DATA_WIDTH   = 8,
  parameter    AXIS_COLUMN       = 128,
  parameter    AXIS_ROW          = 1024,
  parameter    AXIS_ROW_INTERVAL = 16,
  parameter    AXIS_RUN_CNT      = 3
)
(
  input                          clk        ,
  input                          rst_n      ,
  input                          rd_en      ,
  
  output [AXIS_DATA_WIDTH-1:0]   axis_tdata    ,
  output logic                   axis_tvalid   ,
  input                          axis_tready   ,
  output                         axis_tlast    ,

  output                         rd_valid   ,
  output [DATA_WIDTH-1:0]        rd_data    ,
  output [31:0]                  rd_addr       
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
    $readmemh(FILE_ADDR, mem);
    // $readmemh("/home/users/yuyushan/work/rsp_s1_prep/rsp_s1_prep_sim/input_data/rsp_s1_op_mst_a_0.txt", mem_1024x128);
end

//********************  rd  ********************//
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    s_rd_data <= 128'b0;
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