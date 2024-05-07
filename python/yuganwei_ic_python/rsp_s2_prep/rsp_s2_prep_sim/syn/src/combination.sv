`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/18 14:24:36
// Design Name: 
// Module Name: combination
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


module combination #(
    parameter READ_RAM_WIDTH        = 128 ,
    parameter NUM                   = 8   ,
    parameter DATA_WIDTH            = 16  ,
    parameter COMB_Y0_VALID         = 2   ,
    parameter COMB_S_LF_REAL_CMP    = 9   ,
    parameter COMB_S_HF_REAL_CMP    = 3   ,
    parameter COMB_S_LF_COMPLEX_CMP = 4   ,
    parameter COMB_S_HF_COMPLEX_CMP = 2
)(
    input                               clk             ,
    input                               rst_n           ,
    input                               i_switch        ,
    input [1:0]                         i_config_mode   ,
    input [NUM-1:0]                     LF_real_cmp     ,
    input [NUM/2-1:0]                   LF_complex_cmp  ,
    input                               LF_rcmp_valid   ,
    input                               LF_complex_valid,
    input [NUM-1:0]                     HF_real_cmp     ,
    input [NUM/2-1:0]                   HF_complex_cmp  ,
    input                               HF_rcmp_valid   ,
    input                               HF_complex_valid,
    input [READ_RAM_WIDTH-1:0]          i_x0            ,
    input                               i_x0_valid      ,
    output reg [READ_RAM_WIDTH-1:0]     o_y0            ,
    output                              o_y0_valid
);

//********************  reg & wire  ********************//
reg [NUM-1:0]   rcmp;
reg [NUM/2-1:0] ccmp;
wire [NUM-1:0]  s_LF_real_cmp;
wire [NUM-1:0]  s_HF_real_cmp;
wire [NUM/2-1:0]  s_LF_complex_cmp;
wire [NUM/2-1:0]  s_HF_complex_cmp;

//********************  delay  ********************//
delay #(COMB_Y0_VALID) delay_i_x0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(o_y0_valid));

delay_data #(
  .DEPTH      (COMB_S_LF_REAL_CMP),
  .DATA_WIDTH (NUM)
) u_LF_real_cmp(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (LF_real_cmp),
  .o_y0  (s_LF_real_cmp)
);
delay_data #(
  .DEPTH      (COMB_S_HF_REAL_CMP),
  .DATA_WIDTH (NUM)
) u_HF_real_cmp(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (HF_real_cmp),
  .o_y0  (s_HF_real_cmp)
);
delay_data #(
  .DEPTH      (COMB_S_LF_COMPLEX_CMP),
  .DATA_WIDTH (NUM)
) u_LF_complex_cmp(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (LF_complex_cmp),
  .o_y0  (s_LF_complex_cmp)
);
delay_data #(
  .DEPTH      (COMB_S_HF_COMPLEX_CMP),
  .DATA_WIDTH (NUM)
) u_HF_complex_cmp(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (HF_complex_cmp),
  .o_y0  (s_HF_complex_cmp)
);

//********************  main  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    rcmp <= {NUM{1'b0}};
  end
  else if(i_switch == 1'b1) begin
    rcmp <= s_LF_real_cmp & s_HF_real_cmp;
  end
  else begin
    ccmp <= s_LF_complex_cmp & s_HF_complex_cmp;
    // ccmp <= 'hf;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_y0 <= {READ_RAM_WIDTH{1'b0}};
  end
  else if(i_switch == 1'b1) begin
    o_y0[127:112] <= rcmp[7] ? i_x0[127:112] : {DATA_WIDTH{1'b0}};
    o_y0[111:96]  <= rcmp[6] ? i_x0[111:96]  : {DATA_WIDTH{1'b0}};
    o_y0[95:80]   <= rcmp[5] ? i_x0[95:80]   : {DATA_WIDTH{1'b0}};
    o_y0[79:64]   <= rcmp[4] ? i_x0[79:64]   : {DATA_WIDTH{1'b0}};
    o_y0[63:48]   <= rcmp[3] ? i_x0[63:48]   : {DATA_WIDTH{1'b0}};
    o_y0[47:32]   <= rcmp[2] ? i_x0[47:32]   : {DATA_WIDTH{1'b0}};
    o_y0[31:16]   <= rcmp[1] ? i_x0[31:16]   : {DATA_WIDTH{1'b0}};
    o_y0[15:0]    <= rcmp[0] ? i_x0[15:0]    : {DATA_WIDTH{1'b0}};
  end
  else begin
    o_y0[127:96]  <= ccmp[3] ? i_x0[127:96]  : {DATA_WIDTH{1'b0}};
    o_y0[95:64]   <= ccmp[2] ? i_x0[95:64]   : {DATA_WIDTH{1'b0}};
    o_y0[63:32]   <= ccmp[1] ? i_x0[63:32]   : {DATA_WIDTH{1'b0}};
    o_y0[31:0]    <= ccmp[0] ? i_x0[31:0]    : {DATA_WIDTH{1'b0}};
  end
//   else if(i_switch == 1'b1) begin
//     o_y0[127:112] <= i_x0[127:112];
//     o_y0[111:96]  <= i_x0[111:96] ;
//     o_y0[95:80]   <= i_x0[95:80]  ;
//     o_y0[79:64]   <= i_x0[79:64]  ;
//     o_y0[63:48]   <= i_x0[63:48]  ;
//     o_y0[47:32]   <= i_x0[47:32]  ;
//     o_y0[31:16]   <= i_x0[31:16]  ;
//     o_y0[15:0]    <= i_x0[15:0]   ;
//   end
//   else begin
//     o_y0[127:96]  <= i_x0[127:96] ;
//     o_y0[95:64]   <= i_x0[95:64]  ;
//     o_y0[63:32]   <= i_x0[63:32]  ;
//     o_y0[31:0]    <= i_x0[31:0]   ;
//   end
end

endmodule
