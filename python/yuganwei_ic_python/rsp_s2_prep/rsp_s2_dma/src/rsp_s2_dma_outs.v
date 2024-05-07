//-----------------------------------------------------------------------------
// File: rsp_s2_dma_outs.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: DMA axi outstandings collection
// Modification history:
// $Log$
//   Jichen 4/20/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s2_dma_outs(
  clk,
  rst_n,

  timeout_cnt,
  outs_max,

  cmd,
  clr,
  outs,
  outs_empty,
  outs_full,
  timeout
  );
   
parameter OUT_BITS = 8;
parameter TIMEOUT_BITS = 24;

input                         clk;
input                         rst_n;
//config
input  [TIMEOUT_BITS-1:0]     timeout_cnt;
input  [OUT_BITS-1:0]         outs_max;

input                         cmd;
input                         clr;
output [OUT_BITS-1:0]         outs;
output                        outs_empty;
output                        outs_full;
output                        timeout;

reg                           outs_full;
reg  [OUT_BITS-1:0]           outs;
wire [OUT_BITS-1:0]           outs_pre;
reg  [TIMEOUT_BITS-1:0]       counter;

assign outs_empty = ~|outs;

assign outs_pre = outs + cmd - clr;

always @(posedge clk or negedge rst_n)
  if (!rst_n)
    outs <= {OUT_BITS{1'b0}};
  else
    outs <= outs_pre;


always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    outs_full <= 1'b0;
  end else if (outs_pre > outs_max) begin
    outs_full <= 1'b1;
  end else begin
    outs_full <= 1'b0;
  end


assign timeout = ~|counter;

always @(posedge clk or negedge rst_n)
  if (!rst_n)
    counter <= timeout_cnt;
  else if (clr)
    counter <= timeout_cnt;
  else if (|outs)
    counter <= counter - 1'b1;
   
             
endmodule