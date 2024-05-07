//-----------------------------------------------------------------------------
// File: mult.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: multiplier
// Modification history:
// $Log$
//   Jichen 8/28/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s2_prep_mult #(
    parameter DELAY   = 2,
    parameter A_width = 8,
    parameter B_width = 8,
    parameter P_width = 15
)(A,B,TC,CLK,PRODUCT);

integer i;

input	 [A_width-1:0]	A;
input	 [B_width-1:0]	B;
input			            TC; // 0: unsigned, 1: signed
input                 CLK;
output [P_width-1:0]	PRODUCT;

wire	[A_width+B_width-1:0]	pre_product;

wire	[A_width-1:0]	temp_a;
wire	[B_width-1:0]	temp_b;
wire	[A_width+B_width-2:0]	long_temp1, long_temp2;

reg   [A_width+B_width-1:0]   data_arr[DELAY-1:0];

assign	temp_a = (A[A_width-1])? (~A + 1'b1) : A;
assign	temp_b = (B[B_width-1])? (~B + 1'b1) : B;

assign	long_temp1 = temp_a * temp_b;
assign	long_temp2 = ~(long_temp1 - 1'b1);

assign	pre_product = (TC)? (((A[A_width-1] ^ B[B_width-1]) && (|long_temp1))?
				{1'b1,long_temp2} : {1'b0,long_temp1})
			: A * B;
  
always @(posedge CLK) begin
  data_arr[0] <= pre_product;
  for (i=0; i<DELAY-1; i=i+1) begin
    data_arr[i+1] <= data_arr[i];
  end 
end

assign PRODUCT = data_arr[DELAY-1][A_width+B_width-1-:P_width];

endmodule
