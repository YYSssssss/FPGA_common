//-----------------------------------------------------------------------------
// File: abs.sv
// Author: Jade Yu
// Created by : Jade Yu
// Abstract: abs_real
// Modification history:
// $Log$
//   Jichen 5/30/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
// Update from Jichen's abs.sv
//-----------------------------------------------------------------------------

//******************** Description   ********************//
//This module is mainly about abs_real



module rsp_s2_prep_abs_real #(
  parameter WIDTH = 16
)(
  input                      clk,
  input                      rst_n,
  input                      input_vld,
  input  [WIDTH-1:0]         s_real,
  output                     abs_rdy,
  output reg [WIDTH-1:0]     abs_value
);
//********************  reg & wire & assign  ********************//


//********************  abs  ********************//

delay#(1) u_abs_rdy(.clk(clk), .rst_n(rst_n), .din(input_vld), .dout(abs_rdy));

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        abs_value <= {WIDTH{1'b0}};
    end
    else if(s_real[WIDTH-1]) begin
        abs_value <= ~s_real + 1'b1;
    end
    else begin
        abs_value <= s_real;
    end
end

endmodule
