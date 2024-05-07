`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jade_Yu
// 
// Create Date: 2023/08/01 14:47:03
// Design Name: 
// Module Name: chirp_processing_multiplier0
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rsp_s2_prep_multiplier0 #(
  parameter TWIDDLE_WIDTH       = 50,
  parameter SAMPLE_WIDTH        = 32,
  parameter NUM                 = 8,
  parameter MUL_COMPLEX_VALID   = 6,
  parameter MUL_REAL_VALID      = 3
)
(
  input                             rst_n       ,
  input                             clk         ,
  input                             i_switch    ,        //switch-- 1:real_cal  0:complex_cal
  //input  [SAMPLE_WIDTH-1:0]         i_u         ,        //i_u
  input  [SAMPLE_WIDTH-1:0]         i_x0_data   ,        //input complex or real 128bit
  input  [TWIDDLE_WIDTH-1:0]        i_w         ,        //i_W
  input                             i_x0_valid  ,
  output reg [SAMPLE_WIDTH-1:0]     o_y0        ,        //output complex or real
  output                            o_y0_valid           //output complex or real
);
//******************** Description   ********************//
//This module is mainly implemented Y=(x-u) * w
//At the same time, this module can support the calculation of complex(32bit) or real(2*16bit) numbers,
//as well as being bypassed

//********************  reg & wire & assign & init  ********************//
wire signed [SAMPLE_WIDTH/2-1:0]  x0_imag;
wire signed [SAMPLE_WIDTH/2-1:0]  x0_real;
// wire signed [SAMPLE_WIDTH/2-1:0]  u_imag;
// wire signed [SAMPLE_WIDTH/2-1:0]  u_real;
reg signed [TWIDDLE_WIDTH/2-1:0]  d;
reg signed [TWIDDLE_WIDTH/2-1:0]  c;
wire signed [SAMPLE_WIDTH/2-1:0]  b;
wire signed [SAMPLE_WIDTH/2-1:0]  a;

wire       [0:0]              temp_y1rH;
wire       [0:0]              temp_y1rL;
reg signed [SAMPLE_WIDTH-2:0] y1_real_H; //real_High
reg signed [SAMPLE_WIDTH-2:0] y1_real_L; //real_Low
// wire signed [TWIDDLE_WIDTH/2-1:0] w_real_H; //real_High
// wire signed [TWIDDLE_WIDTH/2-1:0] w_real_L; //real_Low

reg signed [SAMPLE_WIDTH/2-1:0] y0_imag;
reg signed [SAMPLE_WIDTH/2-1:0] y0_real;
reg signed [SAMPLE_WIDTH/2:0]   t1;
reg signed [TWIDDLE_WIDTH/2:0]  t2;

wire       [0:0]                temp_t3t4;
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-2:0]   t3;
// reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-2:0]   s_t3;
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-2:0]   t4;
// reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-2:0]   s_t4;

wire       [0:0]                temp_t5;
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2:0]     t5; 
// reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2:0]     s_t5; 
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-1:0]   t6;
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2+1:0]   t7;
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2+1:0] s_t7;
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-1:0] t8;//imag
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-1:0] s_t8;//imag
reg signed [SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-1:0] ss_t8;//imag

wire complex_valid;
wire real_valid;

assign {x0_imag, x0_real} = i_x0_data;
// assign {u_imag, u_real} = i_u;
// assign {w_real_H,w_real_L} = i_w;
// assign {d,c} = (i_switch == 1'b0) ? i_w : {d,c};
assign b = (i_switch == 1'b0) ? y0_imag : b;
assign a = (i_switch == 1'b0) ? y0_real : a;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      d <= {TWIDDLE_WIDTH/2{1'b0}};
      c <= {TWIDDLE_WIDTH/2{1'b0}};
  end
  else begin
    if(i_switch == 1'b0) begin
      d <= i_w[TWIDDLE_WIDTH-1:TWIDDLE_WIDTH/2];
      c <= i_w[TWIDDLE_WIDTH/2-1:0];
    end
    else begin
      d <= d;
      c <= c;
    end
  end
end

//********************  delay  ********************//0
delay #(MUL_COMPLEX_VALID) delay_complex_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(complex_valid));
delay #(MUL_REAL_VALID) delay_real_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(real_valid));
assign o_y0_valid = (i_switch == 1'b1) ? real_valid : complex_valid;

//********************  first  ********************//
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        y0_imag <= {SAMPLE_WIDTH/2{1'b0}};
        y0_real <= {SAMPLE_WIDTH/2{1'b0}};
    end
    else begin
        y0_imag <= x0_imag;
        y0_real <= x0_real;
    end
end

//********************  main  ********************//

//complex (a+b), (c-d)
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    t1 <= {SAMPLE_WIDTH/2{1'b0}};
    t2 <= {SAMPLE_WIDTH/2{1'b0}};
  end 
  else begin
    t1 <= {{2{a[SAMPLE_WIDTH/2-1]}},a[SAMPLE_WIDTH/2-2:0]} + {{2{b[SAMPLE_WIDTH/2-1]}},b[SAMPLE_WIDTH/2-2:0]};
    t2 <= {{2{c[TWIDDLE_WIDTH/2-1]}},c[TWIDDLE_WIDTH/2-2:0]} - {{2{d[TWIDDLE_WIDTH/2-1]}},d[TWIDDLE_WIDTH/2-2:0]};
  end
end

// (a*d), (b*c)
rsp_s2_prep_mult #(
  .DELAY    (3),
  .A_width  (SAMPLE_WIDTH/2),
  .B_width  (TWIDDLE_WIDTH/2),
  .P_width  (SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2)
)u_t3(
  .A      (a),
  .B      (d),
  .TC     (1'b1),
  .CLK    (clk),
  .PRODUCT({temp_t3t4,t3})
);
rsp_s2_prep_mult #(
  .DELAY    (3),
  .A_width  (SAMPLE_WIDTH/2),
  .B_width  (TWIDDLE_WIDTH/2),
  .P_width  (SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2)
)u_t4(
  .A      (b),
  .B      (c),
  .TC     (1'b1),
  .CLK    (clk),
  .PRODUCT({temp_t3t4,t4})
);

// (a+b) * (c-d)
rsp_s2_prep_mult #(
  .DELAY    (3),
  .A_width  (SAMPLE_WIDTH/2+1),
  .B_width  (TWIDDLE_WIDTH/2+1),
  .P_width  (SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2+2)
)u_t5(
  .A      (t1),
  .B      (t2),
  .TC     (1'b1),
  .CLK    (clk),
  .PRODUCT({temp_t5,t5})
);


// ad-bc
always @(posedge clk or negedge rst_n)
  if (!rst_n)
    t6 <= {SAMPLE_WIDTH-1{1'b0}};
  else 
    t6 <= {{2{t3[SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-2]}},t3[SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-3:0]} - 
    {{2{t4[SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-2]}},t4[SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-3:0]};

assign t7 = t6 + t5;
assign t8 = t3 + t4;

// always @(posedge clk or negedge rst_n) begin
//   if(!rst_n)
//     s_t7 <= 16'b0;
//   else begin
//     if(t7[SAMPLE_WIDTH+1] == 1'b0 && (|t7[SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1]))
//       s_t7 <= 16'h7FFF;
//     else if(t7[SAMPLE_WIDTH+1] == 1'b1 && (&t7[SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1]))
//       s_t7 <= 16'hFFFF;
//     else 
//       s_t7 <= {t7[SAMPLE_WIDTH+1],t7[14:0]};
//   end
// end

// always @(posedge clk or negedge rst_n) begin
//   if(!rst_n)
//     s_t8 <= 16'b0;
//   else begin
//     if(t8[SAMPLE_WIDTH-1] == 1'b0 || (|t8[SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1]))
//       s_t8 <= 16'h7FFF;
//     else if(t8[SAMPLE_WIDTH-1] == 1'b1 && (&t8[SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1]))
//       s_t8 <= 16'hFFFF;
//     else 
//       s_t8 <= {t8[SAMPLE_WIDTH-1],t8[14:0]};
//   end
// end

rsp_s2_prep_delay_data #(
  .DEPTH      (1),
  .DATA_WIDTH (SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2)
) u_delay_t8(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (t8 ),
  .o_y0  (ss_t8   )
);

//********************  output o_y0  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_y0 <= {SAMPLE_WIDTH-1{1'b0}};
  end 
  else if(i_switch == 1'b1) begin
    // o_y0 <= {y1_real_H[SAMPLE_WIDTH-2],y1_real_H[14:0],
    //   y1_real_L[SAMPLE_WIDTH-2],y1_real_L[14:0]};
    o_y0 <= i_x0_data;
  end
  else begin
    o_y0 <= {{ss_t8[SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2-1],ss_t8[14:0]},{t7[SAMPLE_WIDTH/2+TWIDDLE_WIDTH/2+1],t7[14:0]}};
  end
end

endmodule
