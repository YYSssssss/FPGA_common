//-----------------------------------------------------------------------------
// File: rsp_s2_dma_axi_alen.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: DMA read with single channel
// Modification history:
// $Log$
//   Jichen 3/10/2024 original
// Version: 1.0
// Copyright (C) 2024 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s2_dma_axi_alen (
  clk,
  rst_n,
  update,
  resume,
  //config
  SLEN,
  SCNT,
  FCNT,
  PCNT,
  BASE_ADDR,
  SIDX,
  FIDX,
  BUSRT_LEN,
  //fifo
  alen_fifo_pop,
  alen_fifo_empty,
  alen_fifo_dout
);

parameter SLEN_BITS = 16;
parameter SCNT_BITS = 14;
parameter FCNT_BITS = 14;
parameter PCNT_BITS = 6;
parameter BASE_ADDR_BITS = 32;
parameter ADDR_BITS = 36;
parameter SIDX_BITS = 26;
parameter FIDX_BITS = 26;
parameter STRB_WIDTH = 16;

localparam BURST_SIZE = $clog2(STRB_WIDTH);

localparam ALEN_FIFO_DEPTH = 16;
localparam ALEN_INFO = 4;

input                            clk;
input                            rst_n;
input                            update;
input                            resume;
//config
input  [SLEN_BITS-1:0]           SLEN;
input  [SCNT_BITS-1:0]           SCNT;
input  [FCNT_BITS-1:0]           FCNT;
input  [PCNT_BITS-1:0]           PCNT;
input  [BASE_ADDR_BITS-1:0]      BASE_ADDR;
input  [SIDX_BITS-1:0]           SIDX;
input  [FIDX_BITS-1:0]           FIDX;
input  [7:0]                     BUSRT_LEN;
//fifo    
input                            alen_fifo_pop;
output                           alen_fifo_empty;
output [ALEN_INFO+7:0]           alen_fifo_dout;

wire [8:0] BUSRT_SLEN = BUSRT_LEN + 1;


wire                             alen_fifo_push;  
wire [ALEN_INFO+7:0]             alen_fifo_din;
wire                             alen_fifo_afull;
wire                             alen_fifo_full;
wire                             alen_fifo_pop;
wire [ALEN_INFO+7:0]             alen_fifo_dout;
wire                             alen_fifo_empty;

reg                              alen_valid_reg;
wire [7:0]                       alen;

wire cmd_update;
wire cmd_resume;
wire [12-BURST_SIZE:0]  addr_next;
wire                    cross_start;
wire                    page_cross;

reg  [SCNT_BITS-1:0]  s_counter;
reg  [FCNT_BITS-1:0]  f_counter;
reg  [PCNT_BITS-1:0]  p_counter;

reg  [SLEN_BITS-1:0]  slen_remain;

wire cmd_s_last;
wire cmd_f_last;
wire cmd_p_last;
wire cmd_c_last;

reg  [ADDR_BITS-1:0]    aaddr_reg, aaddr_s_reg, aaddr_f_reg;
reg  [7:0]              alen_reg;
wire [7:0]              max_burst;

delay #(1) u_delay_cmd_update(.clk(clk), .rst_n(rst_n), .din(update), .dout(cmd_update));
delay #(1) u_delay_cmd_start(.clk(clk), .rst_n(rst_n), .din(resume), .dout(cmd_resume));

assign cmd_s_last = alen_fifo_push & ~page_cross & (~|slen_remain);
assign cmd_f_last = cmd_s_last & s_counter == SCNT;
assign cmd_p_last = cmd_s_last & p_counter == PCNT & (~&PCNT);
assign cmd_c_last = cmd_f_last & f_counter == FCNT;

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    s_counter <= {SCNT_BITS{1'b0}}; 
  end else if (cmd_update) begin
    s_counter <= {SCNT_BITS{1'b0}};
  end else if (cmd_f_last) begin
    s_counter <= {SCNT_BITS{1'b0}};
  end else if (cmd_s_last) begin
    s_counter <= s_counter + 1'b1;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    f_counter <= {FCNT_BITS{1'b0}}; 
  end else if (cmd_update) begin
    f_counter <= {FCNT_BITS{1'b0}};
  end else if (cmd_f_last) begin
    f_counter <= f_counter + 1'b1;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    p_counter <= {PCNT_BITS{1'b0}}; 
  end else if (cmd_update) begin
    p_counter <= {PCNT_BITS{1'b0}};
  end else if (cmd_resume) begin
    p_counter <= {PCNT_BITS{1'b0}};
  end else if (cmd_s_last) begin
    p_counter <= p_counter + 1'b1;
  end

// cmd
assign alen = page_cross? max_burst: alen_reg;
// fifo
assign alen_fifo_push = alen_valid_reg & ~alen_fifo_afull;
assign alen_fifo_din  = {cmd_s_last, cmd_p_last, cmd_f_last, cmd_c_last, alen};

// page cross
assign addr_next   = aaddr_reg[11:BURST_SIZE] + (alen_reg[7:0] + 1);
assign page_cross  = addr_next[12-BURST_SIZE] & |addr_next[11-BURST_SIZE:0];
assign max_burst   = {12-BURST_SIZE{1'b1}} - aaddr_reg[11:BURST_SIZE];
assign cross_start = alen_fifo_push & page_cross;

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

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    aaddr_reg <= {ADDR_BITS{1'b0}};
  end else if (cmd_update) begin
    aaddr_reg <= BASE_ADDR << BURST_SIZE;
  end else if (cmd_f_last) begin
    aaddr_reg <= aaddr_f_reg;
  end else if (cmd_s_last) begin
    aaddr_reg <= aaddr_s_reg;
  end else if (alen_fifo_push) begin
    aaddr_reg <= aaddr_reg + ((alen+1) << BURST_SIZE);
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    slen_remain <= {SLEN_BITS{1'b0}};
  end else if (cmd_update || cmd_resume || cmd_s_last) begin
    if (SLEN > BUSRT_SLEN) begin
      slen_remain <= SLEN - BUSRT_SLEN;
    end else begin
      slen_remain <= {SLEN_BITS{1'b0}};
    end
  end else if (alen_fifo_push && ~page_cross) begin
    if (slen_remain > BUSRT_SLEN) begin
      slen_remain <= slen_remain - BUSRT_SLEN;
    end else begin
      slen_remain <= {SLEN_BITS{1'b0}};
    end
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    alen_reg <= 8'd0;
  end else if (cmd_update || cmd_resume || cmd_s_last) begin
    if (SLEN > BUSRT_SLEN) begin
      alen_reg <= BUSRT_LEN;
    end else begin
      alen_reg <= SLEN - 1;
    end
  end else if (cross_start) begin
    alen_reg <= alen_reg - alen - 1;
  end else if (alen_fifo_push) begin
    if (slen_remain > BUSRT_SLEN) begin
      alen_reg <= BUSRT_LEN;
    end else begin
      alen_reg <= slen_remain - 1;
    end
  end
   
always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    alen_valid_reg <= 1'b0;
  end else if (cmd_update || cmd_resume) begin
    alen_valid_reg <= 1'b1;
  end else if (cmd_p_last || cmd_c_last) begin
    alen_valid_reg <= 1'b0;
  end


fifo_fwft_with_update #(ALEN_INFO+8, ALEN_FIFO_DEPTH, ALEN_FIFO_DEPTH-1)
u_blen_fifo(
  .clk(clk),
  .rst_n(rst_n),
  .update(cmd_update),
  .push(alen_fifo_push),
  .din(alen_fifo_din),
  .afull(alen_fifo_afull),
  .full(alen_fifo_full),
  .pop(alen_fifo_pop),
  .dout(alen_fifo_dout),
  .empty(alen_fifo_empty)
  );

endmodule


