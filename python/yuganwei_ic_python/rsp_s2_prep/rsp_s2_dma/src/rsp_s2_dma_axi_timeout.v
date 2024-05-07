//-----------------------------------------------------------------------------
// File: rsp_s2_dma_axi_timeout.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: DMA with timeout counter
// Modification history:
// $Log$
//   Jichen 4/20/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s2_dma_axi_timeout(clk,rst_n,VALID,READY,axim_timeout);
parameter                  TIMEOUT_BITS = 10;

input                      clk;
input                      rst_n;

input                      VALID;
input                      READY;

output                     axim_timeout;

  
reg [TIMEOUT_BITS-1:0]    counter;

assign axim_timeout = (~|counter);


always @(posedge clk or negedge rst_n)
  if (!rst_n)
    counter <= {TIMEOUT_BITS{1'b1}};
  else if (VALID && READY)
    counter <= {TIMEOUT_BITS{1'b1}};
  else if (VALID)
    counter <= counter - 1'b1;

endmodule





