//-----------------------------------------------------------------------------
// File: delay.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: 1-bit delay module
// Modification history:
// $Log$
//   Jichen 5/11/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------

module delay_bit #(parameter DELAY = 1)
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