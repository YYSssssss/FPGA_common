`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/09 14:42:41
// Design Name: 
// Module Name: DC_estimation
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


module estimation #(
    parameter READ_RAM_WIDTH = 128,
    parameter DATA_WIDTH = 16
)
(
  input                             rst_n           ,
  input                             clk             ,
  
  input  [12:0]                     DCEST_SMP_CNT   ,//Number of Samples in a chirp, 0 means 1 sample, and so on
  input  [ 9:0]                     DCEST_CHP_CNT   ,//Number of chirps in a frame, 0 means 1 chirp, and so on.
  input  [ 3:0]                     DCEST_FRM_CNT   ,//Number of frames , 0 means 1 frame, and so on.
  input  [16:0]                     DCEST_SCALE     ,
  input  [ 1:0]                     config_mode     ,
  input                             i_switch        ,
  
  input signed [READ_RAM_WIDTH-1:0] i_x0_data       ,
  input                             i_x0_valid      ,
  input                             i_x0_last       ,
  output reg [31:0]                 o_y0            ,
  output                            o_y0_valid

);
//******************** Description   ********************//
//

//********************  reg & wire & assign  ********************//
reg signed [DATA_WIDTH:0]                sum_0 [3:0];
reg signed [DATA_WIDTH+1:0]              sum_1 [1:0];
reg signed [DATA_WIDTH+2:0]              sum_2;
reg signed [DATA_WIDTH+2:0]              s_sum_2;
reg signed [39:0]                        sum_c_imag;
reg signed [39:0]                        sum_c_real;
reg signed [39:0]                        sum_r;
reg signed [55:0]                        mul_c_imag; 
reg signed [55:0]                        mul_c_real; 
reg        [20:0]                        s0_cimag_L;
reg        [19:0]                        s0_cimag_H;
wire       [39:0]                        s1_cimag ;
reg        [20:0]                        s0_creal_L;
reg        [19:0]                        s0_creal_H;
wire       [39:0]                        s1_creal ;
reg signed [55:0]                        s_mul_c_imag; 
reg signed [55:0]                        s_mul_c_real; 
reg signed [55:0]                        mul_r; 
reg signed [55:0]                        s_mul_r; 
reg signed [39:0]                        c_imag_shift16; 
reg signed [39:0]                        c_real_shift16; 
reg signed [39:0]                        r_shift16; 
reg signed [39:0]                        s_c_imag_shift16; 
reg signed [39:0]                        s_c_real_shift16; 
reg signed [39:0]                        s_r_shift16;
reg signed [39-8:0]                      sc_imag;
reg signed [39-8:0]                      sc_real;
reg signed [39-8:0]                      sc_r;

wire                                     sum0_valid;
wire                                     valid0;
reg                                      s_valid0;
wire                                     valid1;
reg                                      s_valid1;
reg                                      s_valid2;
wire                                     x0_last;
wire                                     x0_last0;
wire                                     real_last;
wire                                     real_last0;
reg  [1:0]                               judge_0_1;
reg  [12:0]                              cnt_sample;
reg  [ 9:0]                              cnt_chirp;
reg  [ 3:0]                              cnt_frame;
reg  [12:0]                              S_DCEST_SMP_CNT;
reg  [ 9:0]                              S_DCEST_CHP_CNT;
reg  [ 3:0]                              S_DCEST_FRM_CNT;
reg  [15:0]                              num0; //
reg  [15:0]                              num1; //
reg  [15:0]                              num2; //
reg  [15:0]                              num;
reg  [15:0]                              SHIFT;

//********************  parameter  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    judge_0_1       <= 'd0;
    S_DCEST_SMP_CNT <= 'd0;
    S_DCEST_CHP_CNT <= 'd0;
    S_DCEST_FRM_CNT <= 'd0;
    num0 <= 'd0;
    num1 <= 'd0;
    num2 <= 'd0;
    num  <= 'd0;
    SHIFT<= 'd0;
  end
  else begin
    judge_0_1       <= (i_switch == 1'b1) ? 2'd2 : 2'd1;
    S_DCEST_SMP_CNT <= DCEST_SMP_CNT + 1;
    S_DCEST_CHP_CNT <= DCEST_CHP_CNT + 1;
    S_DCEST_FRM_CNT <= DCEST_FRM_CNT + 1;
//    num0 <= $clog2(S_DCEST_SMP_CNT);
//    num1 <= $clog2(S_DCEST_CHP_CNT);
//    num2 <= $clog2(S_DCEST_FRM_CNT);
//    num  <= num0 + num1 +num2;
    SHIFT<= 'd8;
  end
end

//********************  delay & cnt & config ********************//
delay #(5) delay_complex_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));
delay #(4) delay_complex_last0(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last0));
delay #(3) delay_real_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(real_last));
delay #(2) delay_real_last0(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(real_last0));
delay #(2) delay_sum0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(sum0_valid));
delay #(3) delay_valid0(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(valid0));
delay #(4) delay_valid1(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(valid1));
delay #(6) delay_yo_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(o_y0_valid));

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_valid0 <= 1'b0;
    s_valid1 <= 1'b0;
    s_valid2 <= 1'b0;
  end
  else begin
    s_valid0 <= valid0;
    s_valid1 <= valid1;
    s_valid2 <= s_valid1;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_sample <= {13{1'b0}};
  end
  else if(cnt_frame == S_DCEST_FRM_CNT) begin
    cnt_sample <= {13{1'b0}};
  end
  else if(cnt_sample == DCEST_SMP_CNT) begin
    cnt_sample <= {13{1'b0}};
  end
  else if(i_x0_valid) begin
    cnt_sample <= cnt_sample + 1'b1;
  end
  else begin
    cnt_sample <= cnt_sample;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_chirp <= {10{1'b0}};
  end
  else if(cnt_frame == S_DCEST_FRM_CNT) begin
    cnt_chirp <= {10{1'b0}};
  end
  else if(cnt_chirp == DCEST_CHP_CNT) begin
    cnt_chirp <= {10{1'b0}};
  end
  else if(cnt_sample == DCEST_SMP_CNT) begin
    cnt_chirp <= cnt_chirp + 1'b1;
  end
  else begin
    cnt_chirp <= cnt_chirp;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_frame <= {4{1'b0}};
  end
  else if(cnt_frame == S_DCEST_FRM_CNT) begin
    cnt_frame <= {4{1'b0}};
  end
  else if(cnt_chirp == DCEST_CHP_CNT) begin
    cnt_frame <= cnt_frame + 1'b1;
  end
  else begin
    cnt_frame <= cnt_frame;
  end
end

//********************  accumulator  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    sum_0[0] <= {DATA_WIDTH+1{1'b0}};
    sum_0[1] <= {DATA_WIDTH+1{1'b0}};
    sum_0[2] <= {DATA_WIDTH+1{1'b0}};
    sum_0[3] <= {DATA_WIDTH+1{1'b0}};
  end
  else if(cnt_frame == S_DCEST_FRM_CNT) begin
    sum_0[0] <= {DATA_WIDTH+1{1'b0}};
    sum_0[1] <= {DATA_WIDTH+1{1'b0}};
    sum_0[2] <= {DATA_WIDTH+1{1'b0}};
    sum_0[3] <= {DATA_WIDTH+1{1'b0}};
  end
  else if(sum0_valid) begin
    sum_0[0] <= {{2{i_x0_data[15]}},i_x0_data[14:0] } + {{2{i_x0_data[47]}},i_x0_data[46:32]  };  // I + I : [15:0]  + [47:32] 
    sum_0[1] <= {{2{i_x0_data[31]}},i_x0_data[30:16]} + {{2{i_x0_data[63]}},i_x0_data[62:48]  };  // Q + Q : [31:16] + [63:48]
    sum_0[2] <= {{2{i_x0_data[79]}},i_x0_data[78:64]} + {{2{i_x0_data[111]}},i_x0_data[110:96] };  // I + I : [79:64] + [111:96]
    sum_0[3] <= {{2{i_x0_data[95]}},i_x0_data[94:80]} + {{2{i_x0_data[127]}},i_x0_data[126:112]};  // Q + Q : [95:80] + [127:112] 
  end
  else begin
    sum_0[0] <= sum_0[0];
    sum_0[1] <= sum_0[1];
    sum_0[2] <= sum_0[2];
    sum_0[3] <= sum_0[3];
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    sum_1[0]   <= {DATA_WIDTH+2{1'b0}};
    sum_1[1]   <= {DATA_WIDTH+2{1'b0}};
  end
  // else if(x0_last) begin
  //   sum_1[0]   <= {DATA_WIDTH+2{1'b0}};
  //   sum_1[1]   <= {DATA_WIDTH+2{1'b0}};
  // end
  else if(i_switch == 1'b0 && (valid0 || s_valid0)) begin
    sum_1[0] <= {{2{sum_0[0][DATA_WIDTH]}},sum_0[0][DATA_WIDTH-1:0]} + {{2{sum_0[2][DATA_WIDTH]}},sum_0[2][DATA_WIDTH-1:0]}; // I
    sum_1[1] <= {{2{sum_0[1][DATA_WIDTH]}},sum_0[1][DATA_WIDTH-1:0]} + {{2{sum_0[3][DATA_WIDTH]}},sum_0[3][DATA_WIDTH-1:0]}; // Q
  end
  else if(i_switch == 1'b1 && (valid0 || s_valid0)) begin
    sum_1[0] <= sum_0[0] + sum_0[2]; // I
    sum_1[1] <= sum_0[1] + sum_0[3]; // Q
  end
  else begin
    sum_1[0]   <= sum_1[0]   ;
    sum_1[1]   <= sum_1[1]   ;
  end
end

assign s1_cimag = (real_last == 1'b1) ? 40'b0 : {{s0_cimag_H + s0_cimag_L[20]},s0_cimag_L[19:0]};
assign s1_creal = (real_last == 1'b1) ? 40'b0 : {{s0_creal_H + s0_creal_L[20]},s0_creal_L[19:0]};
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s0_cimag_L <= 21'b0;
    s0_cimag_H <= 20'b0;
    s0_creal_L <= 21'b0;
    s0_creal_H <= 20'b0;
    // s1_creal   <= 40'b0;
    sum_c_imag <= 40'b0;
    sum_c_real <= 40'b0;
  end
  else if(i_switch == 1'b0 && (valid1 || real_last0)) begin
    s0_cimag_L <= s1_cimag[19:0] + {{3{sum_1[1][DATA_WIDTH+1]}},sum_1[1][16:0]};
    s0_cimag_H <= s1_cimag[39:20] + {20{sum_1[1][DATA_WIDTH+1]}};
    sum_c_imag <= s1_cimag;

    s0_creal_L <= s1_creal[19:0]  + {{3{sum_1[0][DATA_WIDTH+1]}},sum_1[0][16:0]};
    s0_creal_H <= s1_creal[39:20] + {20{sum_1[0][DATA_WIDTH+1]}};
    sum_c_real <= s1_creal;
  end
  else if(real_last) begin
    s0_cimag_L <= 21'b0;
    s0_cimag_H <= 20'b0;
    s0_creal_L <= 21'b0;
    s0_creal_H <= 20'b0;
    sum_c_imag <= 40'b0;
    sum_c_real <= 40'b0;
  end
  else begin
    s0_cimag_L <= s0_cimag_L;
    s0_cimag_H <= s0_cimag_H;
    s0_creal_L <= s0_creal_L;
    s0_creal_H <= s0_creal_H;
  end
end

/////////////////////////////////////////////
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    sum_2 <= {DATA_WIDTH+3{1'b0}};
  end
  // else if(x0_last) begin
  //   sum_2 <= {DATA_WIDTH+3{1'b0}};
  // end
  else if(i_switch == 1'b1 && (valid1 || s_valid1)) begin
    sum_2 <= {{2{sum_1[0][DATA_WIDTH+1]}},sum_1[0][16:0]} + {{2{sum_1[1][DATA_WIDTH+1]}},sum_1[1][16:0]};
  end
  else begin
    sum_2 <= sum_2;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_sum_2 <= {DATA_WIDTH+3{1'b0}};
  end
  else begin
    s_sum_2 <= sum_2;
  end
end

reg [20:0] s0_rreal_L;
reg [19:0] s0_rreal_H;
wire[39:0] s1_rreal  ;
assign s1_rreal = (x0_last) ? 40'd0 : {{s0_rreal_H + s0_rreal_L[20]},s0_rreal_L[19:0]};
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s0_rreal_L <= 21'b0;
    s0_rreal_H <= 20'b0;
    sum_r      <= 40'b0;
  end
  else if(i_switch == 1'b1 && (s_valid2 || x0_last0)) begin
    s0_rreal_L <= s1_rreal[19:0] + {{2{s_sum_2[DATA_WIDTH+2]}},s_sum_2[17:0]};
    s0_rreal_H <= s1_rreal[39:20] + {20{s_sum_2[DATA_WIDTH+2]}};
    sum_r <= s1_rreal;
  end
  else if(x0_last) begin
    s0_rreal_L <= 21'b0;
    s0_rreal_H <= 20'b0;
    sum_r      <= 40'b0;
  end
  else begin
    sum_r <= sum_r;
  end
end

//********************  DCEST_SCALE  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_mul_c_imag <= {56{1'b0}};
    s_mul_c_real <= {56{1'b0}};
    s_mul_r      <= {56{1'b0}};
  end
  else if(x0_last) begin
    s_mul_r <= sum_r;
  end
  else if(real_last) begin
    s_mul_c_imag <= sum_c_imag;
    s_mul_c_real <= sum_c_real;
  end
  else begin
    s_mul_c_imag <= s_mul_c_imag;
    s_mul_c_real <= s_mul_c_real;
    s_mul_r      <= s_mul_r     ;
  end
end

mult_cp #(
  .DELAY    (5),
  .A_width  (40),
  .B_width  (17),
  .P_width  (57)
)u_mult_cimag(
  .A      (s_mul_c_imag),
  .B      (DCEST_SCALE),
  .TC     (1'b0),
  .CLK    (clk),
  .PRODUCT(mul_c_imag)
);
mult_cp #(
  .DELAY    (5),
  .A_width  (40),
  .B_width  (17),
  .P_width  (57)
)u_mult_creal(
  .A      (s_mul_c_real),
  .B      (DCEST_SCALE),
  .TC     (1'b0),
  .CLK    (clk),
  .PRODUCT(mul_c_real)
);
mult_cp #(
  .DELAY    (5),
  .A_width  (40),
  .B_width  (17),
  .P_width  (57)
)u_mult_rreal(
  .A      (s_mul_r),
  .B      (DCEST_SCALE),
  .TC     (1'b0),
  .CLK    (clk),
  .PRODUCT(mul_r)
);



//********************  >>16  ********************//
assign c_imag_shift16 = mul_c_imag >>>16;
assign c_real_shift16 = mul_c_real >>>16;
assign r_shift16      = mul_r >>16;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_c_imag_shift16  <= {40{1'b0}};
    s_c_real_shift16  <= {40{1'b0}};
    s_r_shift16       <= {40{1'b0}};
  end
  else begin
    s_c_imag_shift16 <= c_imag_shift16;
    s_c_real_shift16 <= c_real_shift16;
    s_r_shift16      <= r_shift16     ;
  end
end

//********************  >>SHIFT  ********************//
assign sc_imag = s_c_imag_shift16 >>>SHIFT;
assign sc_real = s_c_real_shift16 >>>SHIFT;
assign sc_r    = s_r_shift16 >>SHIFT;

// reg [2:0] cnt_group_data;

// always @(posedge clk or negedge rst_n) begin
//   if(!rst_n) begin
//     cnt_group_data <= 3'd0;
//   end
//   else if(cnt_group_data == 3'b1) begin
//     cnt_group_data <= 1'b1;
//   end
//   else if(x0_last0) begin
//     cnt_group_data <= cnt_group_data + 1'b1;
//   end
//   else begin
//     cnt_group_data <= cnt_group_data;
//   end
// end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_y0 <= 32'd0;
  end
  else if(i_switch) begin
    o_y0 <= sc_r;
  end
  else begin
    o_y0 <= {sc_imag[31],sc_imag[14:0],sc_real[31],sc_real[14:0]};
  end
end

endmodule