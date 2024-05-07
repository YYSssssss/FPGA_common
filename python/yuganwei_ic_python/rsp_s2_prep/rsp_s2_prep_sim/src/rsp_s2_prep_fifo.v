//-----------------------------------------------------------------------------
// File: fifo_fwft.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: FIFO (First Word Fall Through)
// Modification history:
// $Log$
//   Jichen 5/14/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s2_prep_fifo (clk,rst_n,push,pop,din,dout,empty,full,afull,word_counter);
parameter                 WIDTH       = 128;
parameter                 DEPTH_FULL  = 18;
parameter                 THRESH_FULL = DEPTH_FULL / 2;
parameter                 RAM_DELAY   = 1;
parameter                 DEPTH_FULL_BITS = $clog2(DEPTH_FULL);

localparam                LARGER_FIFO_SIZE = 20;

input                          clk;
input                          rst_n;
input                          push;
input                          pop;
input  [WIDTH-1:0]             din;
output [WIDTH-1:0]             dout;
output                         empty;
output                         full;
output                         afull;
output [DEPTH_FULL_BITS:0]     word_counter;

generate if (DEPTH_FULL >= LARGER_FIFO_SIZE) begin: inst_fifo_fwft_large
fifo_fwft_large #(
  .WIDTH(WIDTH),
  .DEPTH_FULL(DEPTH_FULL),
  .THRESH_FULL(THRESH_FULL),
  .RAM_DELAY(RAM_DELAY)
) u_fifo_fwft_large(clk,rst_n,push,pop,din,dout,empty,full,afull,word_counter);
end else begin: inst_fifo_fwft_small
fifo_fwft_small #(
  .WIDTH(WIDTH),
  .DEPTH_FULL(DEPTH_FULL),
  .THRESH_FULL(THRESH_FULL)
) u_fifo_fwft_small(clk,rst_n,push,pop,din,dout,empty,full,afull,word_counter);
end
endgenerate

//initial begin
//assert(DEPTH_FULL > 1);  
//end


endmodule




