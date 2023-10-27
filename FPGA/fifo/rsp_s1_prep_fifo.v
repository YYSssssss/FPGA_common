//-----------------------------------------------------------------------------
// File: fifo.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: FIFO (First Word Fall Through)
// Modification history:
// $Log$
//   Jichen 5/14/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s1_prep_fifo #(
  parameter               WIDTH       = 8
)(clk,rst_n,push,pop,din,dout,empty,full,afull);
parameter                 DEPTH_FULL  = 18;
parameter                 THRESH_FULL = DEPTH_FULL / 2;

parameter                 DEPTH       = DEPTH_FULL - 1;
parameter                 DEPTH_BITS  = $clog2(DEPTH);

parameter                 LAST_LINE   = DEPTH - 1;
     
input                     clk;
input                     rst_n;

input                     push;
input                     pop;
input  [WIDTH-1:0]        din;
output [WIDTH-1:0]        dout;
output                    empty;
output                    full;
output                    afull;
  
wire                      reg_push;
wire                      reg_pop;
wire                      fifo_push;
wire                      fifo_pop;
  
reg [WIDTH-1:0]           fifo[DEPTH-1:0];
reg [WIDTH-1:0]           dout;
reg                       dout_empty;
reg [DEPTH_BITS-1:0]      ptr_in, ptr_in_next;
reg                       ptr_in_carry, ptr_in_carry_next;
reg [DEPTH_BITS-1:0]      ptr_out, ptr_out_next;
reg                       ptr_out_carry, ptr_out_carry_next;

reg                       fifo_empty, fifo_full, afull;
wire                      ptr_eq;
wire                      ptr_carry_xor;

reg [DEPTH_BITS-1:0]      cnt, cnt_next;

assign reg_push  = push & fifo_empty & (dout_empty | pop);
assign reg_pop   = pop & fifo_empty;
assign fifo_push = push & (~reg_push);
assign fifo_pop  = pop & (~reg_pop);

assign ptr_eq        = ptr_in_next == ptr_out_next;
assign ptr_carry_xor = ptr_in_carry_next ^ ptr_out_carry_next;

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    dout       <= {WIDTH{1'b0}};
    dout_empty <= 1'b1;
  end else if (reg_push) begin
    dout       <= din;
    dout_empty <= 1'b0;
  end else if (reg_pop) begin
    dout       <= {WIDTH{1'b0}};
    dout_empty <= 1'b1;
  end else if (fifo_pop) begin
    dout       <= fifo[ptr_out];
    dout_empty <= 1'b0;
  end
   
// FIFO push ptr
always @(*) begin
  ptr_in_next = ptr_in;
  if (fifo_push) begin
    ptr_in_next = ptr_in == LAST_LINE ? {DEPTH_BITS{1'b0}} : ptr_in + 1'b1;
  end
end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    ptr_in <= {DEPTH_BITS{1'b0}};
  end else begin
    ptr_in <= ptr_in_next;
  end

always @(*) begin
  ptr_in_carry_next = ptr_in_carry;
  if (fifo_push && ptr_in == LAST_LINE) begin
    ptr_in_carry_next = ~ptr_in_carry;
  end
end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    ptr_in_carry <= 1'b0;
  end else begin
    ptr_in_carry <= ptr_in_carry_next;
  end

// FIFO pop ptr
always @(*) begin
  ptr_out_next = ptr_out;
  if (fifo_pop) begin
    ptr_out_next = ptr_out == LAST_LINE ? {DEPTH_BITS{1'b0}} : ptr_out + 1'b1;
  end
end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    ptr_out <= {DEPTH_BITS{1'b0}};
  end else begin
    ptr_out <= ptr_out_next;
  end

always @(*) begin
  ptr_out_carry_next = ptr_out_carry;
  if (fifo_pop && ptr_out == LAST_LINE) begin
    ptr_out_carry_next = ~ptr_out_carry;
  end
end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    ptr_out_carry <= 1'b0;
  end else begin
    ptr_out_carry <= ptr_out_carry_next;
  end

// data counter
always @(*) begin
  cnt_next = cnt;
  if (fifo_push | fifo_pop) begin
    cnt_next = cnt + fifo_push - fifo_pop;
  end
end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    cnt <= {DEPTH_BITS{1'b0}};
  end else begin
    cnt <= cnt_next;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    fifo_full <= 1'b0;
  end else begin
    fifo_full <= ptr_eq & ptr_carry_xor;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    fifo_empty <= 1'b1;
  end else begin
    fifo_empty <= ptr_eq & (~ptr_carry_xor);
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    afull <= 1'b0;
  end else begin
    afull <= cnt_next >= (THRESH_FULL-1);
  end

always @(posedge clk)
  if (fifo_push) begin
    fifo[ptr_in] <= din;
  end

assign empty = fifo_empty & dout_empty;
assign full  = fifo_full;

//initial begin
//assert(DEPTH_FULL > 1);  
//end


endmodule




