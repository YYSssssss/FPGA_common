`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/13 09:11:31
// Design Name: 
// Module Name: buffer_8data
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


module buffer_8data #(
    parameter READ_RAM_WIDTH = 128,
    parameter SAMPLE_WIDTH   = 32,
    parameter NUM            = 8
)(
    input                                    clk                ,
    input                                    rst_n              ,
    input signed [SAMPLE_WIDTH/2-1:0]        i_x0_data [NUM-1:0],
    input                                    i_x0_valid         ,
    input                                    i_x0_last          ,
    output reg signed [SAMPLE_WIDTH/2-1:0]   o_y0_data [NUM-1:0],
    output reg                               o_y0_valid
);

//********************  reg & wire & assign  ********************//
reg [READ_RAM_WIDTH-1:0]  data0 [NUM-1:0];
reg [READ_RAM_WIDTH-1:0]  data1 [NUM-1:0];
reg [READ_RAM_WIDTH-1:0]  data2 [NUM-1:0];

reg                       s_y0_valid;
reg                       s_y0_valid1;
reg                       i_x0_valid_0;
reg                       i_x0_valid_1;
reg                       i_x0_valid_p;
reg                       x0_last0;
reg                       x0_last1;
reg                       x0_last2;

integer i;
integer k;
integer L;
reg [3:0] cnt_pulse;
reg [3:0] cnt_add_valid;
//********************  delay  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    x0_last0 <= 1'b0;
    x0_last1 <= 1'b0;
    x0_last2 <= 1'b0;
  end
  else begin
    x0_last0 <= i_x0_last;
    x0_last1 <= x0_last0;
    x0_last2 <= x0_last1;
  end
end

//********************  cnt & edge  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    i_x0_valid_0 <= 1'b0;
    i_x0_valid_1 <= 1'b0;
  end
  else begin
    i_x0_valid_0 <= i_x0_valid;
    i_x0_valid_1 <= i_x0_valid_0;
  end
end
assign i_x0_valid_p = i_x0_valid & ~i_x0_valid_0;

//********************  buffer_data0  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    i <= 0;
  end
  else if(i == 7)
    i <= 0;
  else if(i_x0_valid)
    i <= i + 1;
  else
    i <= i;
end
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    data0[0] <= 128'b0;
    data0[1] <= 128'b0;
    data0[2] <= 128'b0;
    data0[3] <= 128'b0;
    data0[4] <= 128'b0;
    data0[5] <= 128'b0;
    data0[6] <= 128'b0;
    data0[7] <= 128'b0;
  end
  else begin
    data0[i] <= {i_x0_data[7],i_x0_data[6],i_x0_data[5],i_x0_data[4],i_x0_data[3],i_x0_data[2],i_x0_data[1],i_x0_data[0]};
  end
  // else begin
  //   data0[i] <= data0[i];
  // end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    data1[0] <= 128'b0;
    data1[1] <= 128'b0;
    data1[2] <= 128'b0;
    data1[3] <= 128'b0;
    data1[4] <= 128'b0;
    data1[5] <= 128'b0;
    data1[6] <= 128'b0;
    data1[7] <= 128'b0;
  end
  else if(i_x0_valid_0) begin
    data1[0] <= data0[0];
    data1[1] <= data0[1];
    data1[2] <= data0[2];
    data1[3] <= data0[3];
    data1[4] <= data0[4];
    data1[5] <= data0[5];
    data1[6] <= data0[6];
    data1[7] <= data0[7];
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    data2[0] <= 128'b0;
    data2[1] <= 128'b0;
    data2[2] <= 128'b0;
    data2[3] <= 128'b0;
    data2[4] <= 128'b0;
    data2[5] <= 128'b0;
    data2[6] <= 128'b0;
    data2[7] <= 128'b0;
  end
  else if(i_x0_valid_1) begin
    data2[0] <= data1[0];
    data2[1] <= data1[1];
    data2[2] <= data1[2];
    data2[3] <= data1[3];
    data2[4] <= data1[4];
    data2[5] <= data1[5];
    data2[6] <= data1[6];
    data2[7] <= data1[7];
  end
end

//********************  buffer_data1  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    k <= 0;
  end
  else if(k == 7)
    k <= 0;
  else if(s_y0_valid)
    k <= k + 1;
  else
    k <= k;
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    L <= 0;
  end
  else if(L == 7)
    L <= 0;
  else if(s_y0_valid1)
    L <= L + 1;
  else
    L <= L;
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_pulse <= 3'b0;;
  end
  else if(x0_last0)
    cnt_pulse <= 3'b0;
  else if(i_x0_valid_p)
    cnt_pulse <= cnt_pulse + 1'b1;
  else if(cnt_pulse == 3'd2)
    cnt_pulse <= 3'd1;
  else
    cnt_pulse <= cnt_pulse;
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_add_valid <= 3'b0;;
  end
  else if(s_y0_valid1)
    cnt_add_valid <= cnt_add_valid + 1'b1;
  else
    cnt_add_valid <= cnt_add_valid;
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_y0_valid <= 1'b0;
  end
  else if(cnt_pulse == 3'd2) begin
    s_y0_valid <= 1'b1;
  end
  else if(k == 7) begin
    s_y0_valid <= 1'b0;
  end
  else begin
    s_y0_valid <= s_y0_valid;
  end
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)
    s_y0_valid1 <= 1'b0;
  else if(x0_last2)
    s_y0_valid1 <= 1'b1;
  else if(L == 7)
    s_y0_valid1 <= 1'b0;
  else
    s_y0_valid1 <= s_y0_valid1;
end 





//********************  output  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_y0_valid <= 1'b0;
  end
  else begin
    o_y0_valid <= s_y0_valid || s_y0_valid1;
  end
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_y0_data[0] <= 16'b0;
    o_y0_data[1] <= 16'b0;
    o_y0_data[2] <= 16'b0;
    o_y0_data[3] <= 16'b0;
    o_y0_data[4] <= 16'b0;
    o_y0_data[5] <= 16'b0;
    o_y0_data[6] <= 16'b0;
    o_y0_data[7] <= 16'b0;
  end
  else if(s_y0_valid1) begin
    {o_y0_data[7],o_y0_data[6],o_y0_data[5],o_y0_data[4],o_y0_data[3],o_y0_data[2],o_y0_data[1],o_y0_data[0]} <= data2[L];
  end
  else begin
    {o_y0_data[7],o_y0_data[6],o_y0_data[5],o_y0_data[4],o_y0_data[3],o_y0_data[2],o_y0_data[1],o_y0_data[0]} <= data2[k];
  end
end 


endmodule
