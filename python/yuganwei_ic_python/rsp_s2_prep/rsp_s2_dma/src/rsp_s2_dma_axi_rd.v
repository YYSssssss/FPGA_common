//-----------------------------------------------------------------------------
// File: rsp_s2_dma_axi_rd.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: DMA read with axi rdata transmission
// Modification history:
// $Log$
//   Jichen 3/11/2024 original
// Version: 1.0
// Copyright (C) 2024 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s2_dma_axi_rd (    
  clk,
  rst_n,
  update,
  resume,
  pcnt_finish,
  ccnt_finish,
  outs_timeout,
  rc_update,
  rc_resume,
  //config
  BASE_ADDR,
  SIDX,
  FIDX,
  OUTS_MAX,
  TIMEOUT_CNT,
  //alen fifo
  alen_fifo_pop,
  alen_fifo_empty,
  alen_fifo_dout,
  //data fifo
  rfifo_pop,
  rfifo_empty,
  rfifo_dout,
  //axi rd signals
  arvalid,
  arready,
  arlen,
  araddr,
  rvalid,
  rready,
  rdata,
  rlast
);

parameter                      BASE_ADDR_BITS = 32;
parameter                      ADDR_BITS = 36;
parameter                      SIDX_BITS = 26;
parameter                      FIDX_BITS = 26;

parameter                      BUFF_DEPTH = 16;
parameter                      DATA_WIDTH = 128;

localparam                     STRB_WIDTH = DATA_WIDTH / 8;
localparam                     BURST_SIZE = $clog2(STRB_WIDTH);
localparam                     BUFF_PTR_BITS = $clog2(BUFF_DEPTH)>8? $clog2(BUFF_DEPTH): 8;
localparam                     ALEN_INFO = 4;
localparam                     OUT_BITS = 8;
localparam                     TIMEOUT_BITS = 12;

input                          clk;
input                          rst_n;
input                          update;
input                          resume;
output                         pcnt_finish;
output                         ccnt_finish;
output                         outs_timeout;
output [15:0]                  rc_update;
output [15:0]                  rc_resume;
//config
input  [BASE_ADDR_BITS-1:0]    BASE_ADDR;
input  [SIDX_BITS-1:0]         SIDX;
input  [FIDX_BITS-1:0]         FIDX;
input  [OUT_BITS-1:0]          OUTS_MAX;
input  [TIMEOUT_BITS-1:0]      TIMEOUT_CNT;
//alen fifo
output                         alen_fifo_pop;
input                          alen_fifo_empty;
input  [ALEN_INFO+7:0]         alen_fifo_dout;
//data fifo
input                          rfifo_pop;
output                         rfifo_empty;
output [DATA_WIDTH-1:0]        rfifo_dout;
//axi rd signals
output                         arvalid;
input                          arready;
output [7:0]                   arlen;
output [ADDR_BITS-1:0]         araddr;
input                          rvalid;
output                         rready;
input  [DATA_WIDTH-1:0]        rdata;
input                          rlast;

wire                           cmd_update;
wire                           cmd_resume;
reg                            avalid_reg;
reg  [ADDR_BITS-1:0]           aaddr_reg, aaddr_s_reg, aaddr_f_reg;

wire                           cmd;
wire                           clr;
wire [OUT_BITS-1:0]            outs;
wire                           outs_empty;
wire                           outs_full;
wire                           outs_timeout;

wire                           rfifo_push;
reg  [DATA_WIDTH-1:0]          rfifo_din;
wire                           rfifo_afull;
wire                           rfifo_full;
wire                           rfifo_pop;
wire [DATA_WIDTH-1:0]          rfifo_dout;
wire                           rfifo_empty;

wire [BUFF_PTR_BITS:0]         buff_ptr_pre;
reg  [BUFF_PTR_BITS:0]         buff_ptr;
reg                            buffer_pfull;

wire                           s_last;
wire                           p_last;
wire                           f_last;
wire                           c_last;

wire                           cmd_s_last;
wire                           cmd_f_last;
wire                           cmd_p_last;
wire                           cmd_c_last;
//status
reg  [15:0]                    rc_update;
reg  [15:0]                    rc_resume;

delay #(1) u_delay_cmd_update(.clk(clk), .rst_n(rst_n), .din(update), .dout(cmd_update));
delay #(1) u_delay_cmd_start(.clk(clk), .rst_n(rst_n), .din(resume), .dout(cmd_resume));

assign cmd = arvalid & arready;
assign clr = rvalid & rready & rlast;

assign {s_last, p_last, f_last, c_last, arlen} = alen_fifo_dout;
assign cmd_s_last = cmd & s_last;
assign cmd_f_last = cmd & f_last;
assign cmd_p_last = cmd & p_last;
assign cmd_c_last = cmd & c_last;
assign alen_fifo_pop = cmd;

assign arvalid = avalid_reg & ~alen_fifo_empty & ~outs_full & ~buffer_pfull;
assign araddr = aaddr_reg;
assign rready = ~rfifo_afull;

assign buff_ptr_pre = buff_ptr + {{8{cmd}} & (arlen+1)} - rfifo_pop;

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    buff_ptr <= {BUFF_PTR_BITS+1{1'b0}};
  end else if (cmd || rfifo_pop) begin
    buff_ptr <= buff_ptr_pre;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    buffer_pfull <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    buffer_pfull <= 1'b0;
  end else if (cmd && buff_ptr_pre >= BUFF_DEPTH-2) begin
    buffer_pfull <= 1'b1;
  end else if (buff_ptr <= BUFF_DEPTH / 2) begin
    buffer_pfull <= 1'b0;
  end

delay #(1) u_delay_rfifo_push(.clk(clk), .rst_n(rst_n), .din(rvalid & rready), .dout(rfifo_push));

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    rfifo_din <= {DATA_WIDTH{1'b0}};
  end else if (rvalid & rready) begin
    rfifo_din <= rdata;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    avalid_reg <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    avalid_reg <= 1'b1;
  end else if (cmd_p_last || cmd_c_last) begin
    avalid_reg <= 1'b0;
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
    aaddr_reg <= aaddr_reg + ((arlen+1) << BURST_SIZE);
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

fifo_fwft #(DATA_WIDTH, BUFF_DEPTH, BUFF_DEPTH-2)
data_fifo(
  .clk(clk),
  .rst_n(rst_n),
  .push(rfifo_push),
  .pop(rfifo_pop),
  .din(rfifo_din),
  .dout(rfifo_dout),
  .empty(rfifo_empty),
  .afull(rfifo_afull),
  .full(rfifo_full)
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

assign pcnt_finish = ~pouts_finish & pouts_finish_d;

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

assign ccnt_finish = ~couts_finish & couts_finish_d;

//status
always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    rc_update <= 16'd0;
  end else if (cmd_update) begin
    rc_update <= 16'd0;
  end else if (rvalid && rready) begin
    rc_update <= rc_update + 1'd1;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    rc_resume <= 16'd0;
  end else if (cmd_update || cmd_resume) begin
    rc_resume <= 16'd0;
  end else if (rvalid && rready) begin
    rc_resume <= rc_resume + 1'd1;
  end


//synopsys translate_off
always @(posedge clk)
  if (rfifo_full) begin
    $display("[ERROR] rsp_s2_dma_axi_rd: rfifo full.");
  end
//synopsys translate_on
   
endmodule

   



