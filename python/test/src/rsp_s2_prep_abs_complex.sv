//-----------------------------------------------------------------------------
// File: abs.sv
// Author: Jade Yu
// Created by : Jade Yu
// Abstract: abs with JPL
// Modification history:
// $Log$
//   Jichen 5/30/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
// Update from Jichen's abs.sv
//-----------------------------------------------------------------------------

///////////////////////////////
// JPL algorithm
// U = max(|I|, |Q|), V = min(|I|, |Q|)
// abs = max(U + V/8, 7U/8 + V/2)
///////////////////////////////
`timescale 1ns / 1ps


module rsp_s1_prep_abs_complex #(
  parameter WIDTH = 16
)(
  input                      clk,
  input                      rst_n,
  input                      input_vld,
  input  [WIDTH-1:0]         s_imag,
  input  [WIDTH-1:0]         s_real,
  output                     abs_rdy,
  output reg [WIDTH-1:0]     abs_value,


  //////////////debug
  output logic               abd_valid,
  output logic [WIDTH-1:0]   a,
  output logic [WIDTH-1:0]   b,
  output logic [WIDTH-1:0]   c,
  output logic [WIDTH-1:0]   d,
  output logic               c_valid
);

localparam [WIDTH-1:0] MAX_U_INPUT = {1'b0, {(WIDTH-1){1'b1}}};

wire [WIDTH-1:0] u_imag;
wire [WIDTH-1:0] u_real;
wire [WIDTH-1:0] U;
wire [WIDTH-1:0] V;
reg  [WIDTH-1:0] sum0_r1, sum0_r2;
reg  [WIDTH-1:0] sum1_r1, sum1_r2;

// pipeline
reg [WIDTH-1:0] U_r1, U_r2;
reg [WIDTH-1:0] V_r1, V_r2;

assign u_imag = (s_imag[WIDTH-1])? (|s_imag[0+:WIDTH-1]==1'b0)? MAX_U_INPUT: (~s_imag + 1'b1): s_imag;
assign u_real = (s_real[WIDTH-1])? (|s_real[0+:WIDTH-1]==1'b0)? MAX_U_INPUT: (~s_real + 1'b1): s_real;

assign U = (u_imag > u_real)? u_imag: u_real; // max of abs(imag), abs(real)
assign V = (u_imag > u_real)? u_real: u_imag; // min of abs(imag), abs(real)

delay#(4) u_abs_rdy(.clk(clk), .rst_n(rst_n), .din(input_vld), .dout(abs_rdy));

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    sum0_r1 <= {WIDTH{1'b0}};
    sum0_r2 <= {WIDTH{1'b0}};
  end else begin
    sum0_r1 <= U_r1 + (V_r1 >> 3);
    sum0_r2 <= sum0_r1;
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    sum1_r1 <= {WIDTH{1'b0}};
    sum1_r2 <= {WIDTH{1'b0}};
  end else begin
    sum1_r1 <= U_r1 - (U_r1 >> 3);
    sum1_r2 <= sum1_r1 + (V_r2 >> 1);
  end

always @(posedge clk or negedge rst_n)
  if (!rst_n)
    abs_value <= {WIDTH{1'b0}};
  else
    abs_value <= (sum0_r2 > sum1_r2)? sum0_r2: sum1_r2;

// pipeline 
always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    U_r1 <= {WIDTH{1'b0}};
    V_r1 <= {WIDTH{1'b0}};
    U_r2 <= {WIDTH{1'b0}};
    V_r2 <= {WIDTH{1'b0}};
  end else begin
    U_r1 <= U;
    V_r1 <= V;
    U_r2 <= U_r1;
    V_r2 <= V_r1;
  end

//////////////debug
delay#(1) u_abd_valid(.clk(clk), .rst_n(rst_n), .din(input_vld), .dout(abd_valid));
delay#(2) u_c_valid(.clk(clk), .rst_n(rst_n), .din(input_vld), .dout(c_valid));
assign a = U_r1;
assign b = (V_r1 >> 3);
assign c = sum1_r1;
assign d = (V_r2 >> 1);


endmodule