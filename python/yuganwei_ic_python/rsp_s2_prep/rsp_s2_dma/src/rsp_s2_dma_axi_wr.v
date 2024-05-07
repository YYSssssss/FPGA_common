//-----------------------------------------------------------------------------
// File: rsp_s2_dma_axi_wr.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: DMA write with axi wdata transmission
// Modification history:
// $Log$
//   Jichen 3/11/2024 original
// Version: 1.0
// Copyright (C) 2024 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------
       
module rsp_s2_dma_axi_wr (       
  clk,
  rst_n,
  update,
  resume,
  pcnt_finish,
  ccnt_finish,
  outs_timeout,
  wc_update,
  wc_resume,
  //fidx
  i_fidx_en,
  i_fidx_data,
  o_fidx_clr,
  i_fidx_update,
  //config
  BASE_ADDR,
  SIDX,
  FIDX,
  OUTS_MAX,
  TIMEOUT_CNT,
  INDEX_EN,
  INDEX_ADDR,
  //alen fifo
  alen_fifo_pop,
  alen_fifo_empty,
  alen_fifo_dout,
  //data fifo
  wfifo_push,
  wfifo_din,
  wfifo_afull,
  //axi wr signals
  awvalid,
  awready,
  awlen,
  awaddr,
  wvalid,
  wready,
  wdata,
  wstrb,
  wlast,
  bvalid,
  bready
);

parameter                      BASE_ADDR_BITS = 32;
parameter                      ADDR_BITS = 36;
parameter                      SIDX_BITS = 26;
parameter                      FIDX_BITS = 26;
  
parameter                      BUFF_DEPTH = 512;
parameter                      DATA_WIDTH = 128;

localparam                     STRB_WIDTH = DATA_WIDTH / 8;
localparam                     BURST_SIZE = $clog2(STRB_WIDTH);
localparam                     ALEN_INFO = 4;
localparam                     OUT_BITS = 8;
localparam                     TIMEOUT_BITS = 12;

localparam                     FRAME_IDX_BITS = 8;
localparam                     RANGE_IDX_BITS = 16;

input                          clk;
input                          rst_n;
input                          update;
input                          resume;
output                         pcnt_finish;
output                         ccnt_finish;
output                         outs_timeout;
output [15:0]                  wc_update;
output [15:0]                  wc_resume;
//fidx
input                          i_fidx_en;
input [7:0]                    i_fidx_data;
output                         o_fidx_clr;
input                          i_fidx_update;
//config
input  [BASE_ADDR_BITS-1:0]    BASE_ADDR;
input  [SIDX_BITS-1:0]         SIDX;
input  [FIDX_BITS-1:0]         FIDX;
input  [OUT_BITS-1:0]          OUTS_MAX;
input  [TIMEOUT_BITS-1:0]      TIMEOUT_CNT;
input                          INDEX_EN;
input  [BASE_ADDR_BITS-1:0]    INDEX_ADDR;
//alen fifo
output                         alen_fifo_pop;
input                          alen_fifo_empty;
input  [ALEN_INFO+7:0]         alen_fifo_dout;
//data fifo
input                          wfifo_push;
input  [DATA_WIDTH-1:0]        wfifo_din;
output                         wfifo_afull;
//axi wr signals
output                         awvalid;
input                          awready;
output [7:0]                   awlen;
output [ADDR_BITS-1:0]         awaddr;
output                         wvalid;
input                          wready;
output [DATA_WIDTH-1:0]        wdata;
output [STRB_WIDTH-1:0]        wstrb;
output                         wlast;
input                          bvalid;
output                         bready;

wire                           cmd_update;
wire                           cmd_resume;
reg                            avalid_reg;
reg  [ADDR_BITS-1:0]           aaddr_reg, aaddr_s_reg, aaddr_f_reg;
reg                            wvalid_reg;

wire                           cmd;
wire                           clr;
wire [OUT_BITS-1:0]            outs;
wire                           outs_empty;
wire                           outs_full;
wire                           outs_timeout;

wire                           wfifo_push;
wire [DATA_WIDTH-1:0]          wfifo_din;
wire                           wfifo_afull;
wire                           wfifo_full;
wire                           wfifo_pop;
wire [DATA_WIDTH-1:0]          wfifo_dout;
wire                           wfifo_empty;

wire                           s_last;
wire                           p_last;
wire                           f_last;
wire                           c_last;

wire                           cmd_s_last;
wire                           cmd_f_last;
wire                           cmd_p_last;
wire                           cmd_c_last;

reg  [7:0]                     wfifo_pop_count;
reg                            cmd_done;
reg                            data_done;
//status
reg  [15:0]                    wc_update;
reg  [15:0]                    wc_resume;

delay #(1) u_delay_cmd_update(.clk(clk), .rst_n(rst_n), .din(update), .dout(cmd_update));
delay #(1) u_delay_cmd_start(.clk(clk), .rst_n(rst_n), .din(resume), .dout(cmd_resume));

assign cmd = awvalid & awready;
assign clr = bvalid & bready;
assign data_trans_finish = wvalid & wready & wlast;

assign {s_last, f_last, p_last, c_last, awlen} = alen_fifo_dout;
assign cmd_s_last = cmd & s_last;
assign cmd_f_last = cmd & f_last;
assign cmd_p_last = cmd & p_last;
assign cmd_c_last = cmd & c_last;
assign alen_fifo_pop = (cmd & data_trans_finish) | 
                       (cmd & data_done) | 
                       (cmd_done & data_trans_finish);

assign awvalid = avalid_reg & ~alen_fifo_empty & ~outs_full;
assign awaddr  = aaddr_reg;
assign wvalid  = wvalid_reg & ~alen_fifo_empty & ~wfifo_empty;
assign wlast  = wvalid & (wfifo_pop_count == awlen);
assign wstrb = {STRB_WIDTH{1'b1}};
assign bready = 1'b1;
  
always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    avalid_reg <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    avalid_reg <= 1'b1;
  end else if (alen_fifo_pop) begin
    avalid_reg <= 1'b1;
  end else if (cmd) begin
    avalid_reg <= 1'b0;
  end else if (cmd_p_last || cmd_c_last) begin
    avalid_reg <= 1'b0;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    cmd_done <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    cmd_done <= 1'b0;
  end else if (alen_fifo_pop) begin
    cmd_done <= 1'b0;
  end else if (cmd) begin
    cmd_done <= 1'b1;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    data_done <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    data_done <= 1'b0;
  end else if (alen_fifo_pop) begin
    data_done <= 1'b0;
  end else if (data_trans_finish) begin
    data_done <= 1'b1;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    wvalid_reg <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    wvalid_reg <= 1'b1;
  end else if (alen_fifo_pop) begin
    wvalid_reg <= 1'b1;
  end else if (data_trans_finish) begin
    wvalid_reg <= 1'b0;
  end


always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    aaddr_reg <= {ADDR_BITS{1'b0}};
  end else if (cmd_update) begin
    aaddr_reg <= BASE_ADDR << BURST_SIZE;
  end else if (cmd_f_last) begin
    aaddr_reg <= aaddr_f_reg;
  end else if (cmd_s_last) begin
    aaddr_reg <= aaddr_s_reg;
  end else if (cmd) begin
    aaddr_reg <= aaddr_reg + ((awlen+1) << BURST_SIZE);
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    aaddr_s_reg <= {ADDR_BITS{1'b0}};
  end else if (cmd_update) begin
    aaddr_s_reg <= (BASE_ADDR << BURST_SIZE) + (SIDX << BURST_SIZE);
  end else if (cmd_f_last) begin
    aaddr_s_reg <= aaddr_f_reg + (SIDX << BURST_SIZE);
  end else if (cmd_s_last) begin
    aaddr_s_reg <= aaddr_s_reg + (SIDX << BURST_SIZE);
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    aaddr_f_reg <= {ADDR_BITS{1'b0}};
  end else if (cmd_update) begin
    aaddr_f_reg <= (BASE_ADDR << BURST_SIZE) + (FIDX << BURST_SIZE);
  end else if (cmd_f_last) begin
    aaddr_f_reg <= aaddr_f_reg + (FIDX << BURST_SIZE);
  end

assign wfifo_pop = wvalid & wready;
   
always @(posedge clk or negedge rst_n)
  if (!rst_n)
    wfifo_pop_count <= 8'b0;
  else if (data_trans_finish)
    wfifo_pop_count <= 8'b0;
  else if (wfifo_pop)
    wfifo_pop_count <= wfifo_pop_count + 1'b1;


fifo_fwft #(DATA_WIDTH, BUFF_DEPTH, BUFF_DEPTH-2) 
data_fifo(
  .clk(clk),
  .rst_n(rst_n),
  .push(wfifo_push),
  .din(wfifo_din),
  .afull(wfifo_afull),
  .full(wfifo_full),
  .pop(wfifo_pop),
  .dout(wdata),
  .empty(wfifo_empty)
  );

rsp_s2_dma_outs #(
  .OUT_BITS          (OUT_BITS),
  .TIMEOUT_BITS      (TIMEOUT_BITS)
) u_rsp_s2_dma_outs_rd(
  .clk               (clk),
  .rst_n             (rst_n),
  .outs_max          (OUTS_MAX),
  .timeout_cnt       (TIMEOUT_CNT),

  .cmd               (cmd),               // input cmd
  .clr               (clr),               // input clr
  .outs              (outs),              // output outs
  .outs_empty        (outs_empty),        // output outs_empty
  .outs_full         (outs_full),         // output outs_full
  .timeout           (outs_timeout)
  );

reg  pouts_finish;
wire pouts_finish_d; 

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    pouts_finish <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    pouts_finish <= 1'b0;
  end else if (cmd_p_last) begin
    pouts_finish <= 1'b1;
  end else if (outs_empty) begin
    pouts_finish <= 1'b0;
  end

delay #(1) u_delay_pouts_finish(.clk(clk), .rst_n(rst_n), .din(pouts_finish), .dout(pouts_finish_d));

assign pcnt_finish = INDEX_EN? 1'b0: 
                             (~pouts_finish & pouts_finish_d);


reg  couts_finish;
wire couts_finish_d; 

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    couts_finish <= 1'b0;
  end else if (cmd_update) begin
    couts_finish <= 1'b0;
  end else if (cmd_c_last) begin
    couts_finish <= 1'b1;
  end else if (outs_empty) begin
    couts_finish <= 1'b0;
  end

delay #(1) u_delay_couts_finish(.clk(clk), .rst_n(rst_n), .din(couts_finish), .dout(couts_finish_d));

assign ccnt_finish = INDEX_EN? 1'b0: 
                           (~couts_finish & couts_finish_d);


//index
wire                   fidx_wr_en_d1, fidx_wr_en_d2, fidx_wr_en_d3; 
reg  [7:0]             frame_idx;
reg  [15:0]            range_idx;
wire [DATA_WIDTH-1:0]  index_din;
delay #(1) u_delay_fidx_wr_en_d1(.clk(clk), .rst_n(rst_n), .din(i_fidx_en), .dout(fidx_wr_en_d1));
delay #(1) u_delay_fidx_wr_en_d2(.clk(clk), .rst_n(rst_n), .din(fidx_wr_en_d1), .dout(fidx_wr_en_d2));
delay #(1) u_delay_fidx_wr_en_d3(.clk(clk), .rst_n(rst_n), .din(fidx_wr_en_d2), .dout(fidx_wr_en_d3));

assign index_din = {{DATA_WIDTH-FRAME_IDX_BITS-RANGE_IDX_BITS{1'b0}}, frame_idx, range_idx};

assign o_fidx_clr = ~fidx_wr_en_d3 & fidx_wr_en_d2;

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    frame_idx <= {FRAME_IDX_BITS{1'b0}};
  end else if (INDEX_EN) begin
    if (fidx_wr_en_d2) begin
      frame_idx <= i_fidx_data;
    end else if (i_fidx_update) begin
      frame_idx <= frame_idx + 1'd1;
    end
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    range_idx <= {RANGE_IDX_BITS{1'b0}};
  end else if (INDEX_EN) begin
    if (i_fidx_update) begin
      range_idx <= {RANGE_IDX_BITS{1'b0}};
    end else if (cmd_update) begin
      range_idx <= range_idx + 1'd1;
    end
  end

//status
always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    wc_update <= 16'd0;
  end else if (cmd_update) begin
    wc_update <= 16'd0;
  end else if (wvalid && wready) begin
    wc_update <= wc_update + 1'd1;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    wc_resume <= 16'd0;
  end else if (cmd_update || cmd_resume) begin
    wc_resume <= 16'd0;
  end else if (wvalid && wready) begin
    wc_resume <= wc_resume + 1'd1;
  end


//synopsys translate_off
always @(posedge clk)
  if (wfifo_full) begin
    $display("[ERROR] rsp_s2_dma_axi_wr: wfifo full.");
  end
//synopsys translate_on
   
endmodule

   



