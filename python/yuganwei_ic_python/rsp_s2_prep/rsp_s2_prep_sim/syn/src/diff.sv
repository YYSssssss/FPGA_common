`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jade_Yu
// 
// Create Date: 2023/08/01 19:52:30
// Design Name: 
// Module Name: diff
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


module diff #(
  parameter READ_RAM_WIDTH      = 128,
  parameter SAMPLE_WIDTH        = 32,
  parameter NUM                 = 8,
  parameter DIFF_X0_LAST_DATA   = 1,
  parameter DIFF_X0_DIFF_VALID  = 2,
  parameter DIFF_X0_LAST        = 2,
  parameter TOP_X0_DIFF_VALID   = 2,
  parameter CNT_LEN             = 8
)
(
  input                             rst_n                ,
  input                             clk                  ,
  input                             i_switch             ,        //switch-- 1:real_cal  0:complex_cal
  input signed [SAMPLE_WIDTH/2-1:0] i_x0_data [NUM-1:0]  ,        //input complex or real 128bit
  input                             i_x0_valid           ,        //input complex or real valid data
  input                             i_x0_last            ,        //input complex or real last data
  output reg signed [SAMPLE_WIDTH/2-1:0]   o_y0      [NUM-1:0]  ,        //output complex or real
  output                            o_y0_valid
);
//********************  parameter  ********************//
localparam MODE = 1;

//********************  reg & wire & assign  ********************//
reg  signed [SAMPLE_WIDTH/2-1:0]  data0 [NUM-1:0];
reg  signed [SAMPLE_WIDTH/2-1:0]  data1 [NUM-1:0];
reg  signed [SAMPLE_WIDTH/2:0]    s_data[NUM-1:0];
reg  signed [READ_RAM_WIDTH+7:0]  s_data1[NUM-2:0];
reg  signed [READ_RAM_WIDTH+7:0]  s_data1_7;
reg  signed [READ_RAM_WIDTH+7:0]  s_data2[NUM-1:0];
reg  signed [SAMPLE_WIDTH/2:0]    s_data3[NUM-1:0];

wire                            x0_last_data;
wire                            x0_diff_valid;
wire                            x0_last;
reg                             x0_last_d1;
reg                             x0_last_d2;

reg                             i_x0_valid_0;
reg                             i_x0_valid_1;
reg                             i_x0_valid_2;
reg                             i_x0_valid_3;
wire                            i_x0_valid_0_p;
wire                            i_x0_valid_1_p;
wire                            i_x0_valid_0_n;
reg                             s_y0_valid;
reg                             s_y0_valid1;

reg [15:0]                      cnt_valid;
reg [2:0]                       cnt_pulse;
reg [2:0]                       cnt_add_valid;

integer i;
integer j;
integer k;
integer L;

//********************  delay  ********************//
delay #(DIFF_X0_LAST_DATA) delay_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last_data));
delay #(DIFF_X0_DIFF_VALID) delay_diff_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(x0_diff_valid));
delay #(DIFF_X0_LAST) delay_diff_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));
delay #(TOP_X0_DIFF_VALID) delay_diff_HF_cvalid(.clk(clk), .rst_n(rst_n), .din(s_y0_valid || s_y0_valid1), .dout(o_y0_valid));

//********************  cnt & edge  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_valid <= 16'b0;
  end
  else if(cnt_valid == 16'd8) begin
    cnt_valid <= 16'b0;
  end
  else if(x0_diff_valid) begin
    cnt_valid <= cnt_valid + 1'b1;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    i_x0_valid_0    <= 1'b0;
    i_x0_valid_1    <= 1'b0;
    i_x0_valid_2    <= 1'b0;
    i_x0_valid_3    <= 1'b0;
    x0_last_d1      <= 1'b0;
    x0_last_d2      <= 1'b0;
  end
  else begin
    i_x0_valid_0    <= i_x0_valid;
    i_x0_valid_1    <= i_x0_valid_0;
    i_x0_valid_2    <= i_x0_valid_1;
    i_x0_valid_3    <= i_x0_valid_2;
    x0_last_d1      <= x0_last;
    x0_last_d2      <= x0_last_d1;
  end
end
assign i_x0_valid_0_p = i_x0_valid_0 & ~i_x0_valid_1;
assign i_x0_valid_1_p = i_x0_valid_1 & ~i_x0_valid_2;
assign i_x0_valid_0_n = ~i_x0_valid & i_x0_valid_0;



//********************  slice_data  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    data0[0] <= {SAMPLE_WIDTH/2{1'b0}};
    data0[1] <= {SAMPLE_WIDTH/2{1'b0}};
    data0[2] <= {SAMPLE_WIDTH/2{1'b0}};
    data0[3] <= {SAMPLE_WIDTH/2{1'b0}};
    data0[4] <= {SAMPLE_WIDTH/2{1'b0}};
    data0[5] <= {SAMPLE_WIDTH/2{1'b0}};
    data0[6] <= {SAMPLE_WIDTH/2{1'b0}};
    data0[7] <= {SAMPLE_WIDTH/2{1'b0}};

    data1[0] <= {SAMPLE_WIDTH/2{1'b0}};
    data1[1] <= {SAMPLE_WIDTH/2{1'b0}};
    data1[2] <= {SAMPLE_WIDTH/2{1'b0}};
    data1[3] <= {SAMPLE_WIDTH/2{1'b0}};
    data1[4] <= {SAMPLE_WIDTH/2{1'b0}};
    data1[5] <= {SAMPLE_WIDTH/2{1'b0}};
    data1[6] <= {SAMPLE_WIDTH/2{1'b0}};
    data1[7] <= {SAMPLE_WIDTH/2{1'b0}};
  end

  else if(i_x0_valid || i_x0_valid_0_n) begin
    data1[0] <= i_x0_data[0];
    data1[1] <= i_x0_data[1];
    data1[2] <= i_x0_data[2];
    data1[3] <= i_x0_data[3];
    data1[4] <= i_x0_data[4];
    data1[5] <= i_x0_data[5];
    data1[6] <= i_x0_data[6];
    data1[7] <= i_x0_data[7];

    data0[0] <= data1[0];
    data0[1] <= data1[1];
    data0[2] <= data1[2];
    data0[3] <= data1[3];
    data0[4] <= data1[4];
    data0[5] <= data1[5];
    data0[6] <= data1[6];
    data0[7] <= data1[7];
  end

  else begin
    data1[0] <= data1[0];
    data1[1] <= data1[1];
    data1[2] <= data1[2];
    data1[3] <= data1[3];
    data1[4] <= data1[4];
    data1[5] <= data1[5];
    data1[6] <= data1[6];
    data1[7] <= data1[7];

    data0[0] <= data0[0];
    data0[1] <= data0[1];
    data0[2] <= data0[2];
    data0[3] <= data0[3];
    data0[4] <= data0[4];
    data0[5] <= data0[5];
    data0[6] <= data0[6];
    data0[7] <= data0[7];
  end
end

//********************  diff  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_data[0] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data[1] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data[2] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data[3] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data[4] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data[5] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data[6] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data[7] <= {SAMPLE_WIDTH/2{1'b0}};
  end
  else if(i_switch == 1'b1 && i_x0_valid_1) begin
    s_data[0] <= data0[1] - data0[0];
    s_data[1] <= data0[2] - data0[1];
    s_data[2] <= data0[3] - data0[2];
    s_data[3] <= data0[4] - data0[3];
    s_data[4] <= data0[5] - data0[4];
    s_data[5] <= data0[6] - data0[5];
    s_data[6] <= data0[7] - data0[6];
    s_data[7] <= data1[0] - data0[7];
  end
  else if(i_switch == 1'b0 && i_x0_valid_1) begin
    s_data[0] <= data0[2] - data0[0];
    s_data[1] <= data0[3] - data0[1];
    s_data[2] <= data0[4] - data0[2];
    s_data[3] <= data0[5] - data0[3];
    s_data[4] <= data0[6] - data0[4];
    s_data[5] <= data0[7] - data0[5];
    s_data[6] <= data1[0] - data0[6];
    s_data[7] <= data1[1] - data0[7];
  end
  else begin
    s_data[0] <= s_data[0];
    s_data[1] <= s_data[1];
    s_data[2] <= s_data[2];
    s_data[3] <= s_data[3];
    s_data[4] <= s_data[4];
    s_data[5] <= s_data[5];
    s_data[6] <= s_data[6];
    s_data[7] <= s_data[7];
  end
end 
////
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    i <= 0;
  end
  else if(i == 7)
    i <= 0;
  else if(i_x0_valid_2)
    i <= i + 1;
  else
    i <= i;
end 
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_data1[0] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data1[1] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data1[2] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data1[3] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data1[4] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data1[5] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data1[6] <= {SAMPLE_WIDTH/2{1'b0}};
  end
  else if(i <= 6) begin
    s_data1[i][17*1-1:17*0] <= s_data[0];
    s_data1[i][17*2-1:17*1] <= s_data[1];
    s_data1[i][17*3-1:17*2] <= s_data[2];
    s_data1[i][17*4-1:17*3] <= s_data[3];
    s_data1[i][17*5-1:17*4] <= s_data[4];
    s_data1[i][17*6-1:17*5] <= s_data[5];
    s_data1[i][17*7-1:17*6] <= s_data[6];
    s_data1[i][17*8-1:17*7] <= s_data[7];
  end
end 
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_data1_7 <= 136'b0;
  end
  else if(i_x0_valid_0_p || x0_last_d1) begin
    if(i_switch == 1'b1) begin
      s_data1_7[17*1-1:17*0] <= data0[1] - data0[0];
      s_data1_7[17*2-1:17*1] <= data0[2] - data0[1];
      s_data1_7[17*3-1:17*2] <= data0[3] - data0[2];
      s_data1_7[17*4-1:17*3] <= data0[4] - data0[3];
      s_data1_7[17*5-1:17*4] <= data0[5] - data0[4];
      s_data1_7[17*6-1:17*5] <= data0[6] - data0[5];
      s_data1_7[17*7-1:17*6] <= data0[7] - data0[6];
      if(x0_last_d1)
        s_data1_7[17*8-1:17*7] <= data0[7] - data0[6];
      else
        s_data1_7[17*8-1:17*7] <= data1[0] - data0[7];
    end
    else begin
      s_data1_7[17*1-1:17*0] <= data0[2] - data0[0];
      s_data1_7[17*2-1:17*1] <= data0[3] - data0[1];
      s_data1_7[17*3-1:17*2] <= data0[4] - data0[2];
      s_data1_7[17*4-1:17*3] <= data0[5] - data0[3];
      s_data1_7[17*5-1:17*4] <= data0[6] - data0[4];
      s_data1_7[17*6-1:17*5] <= data0[7] - data0[5];
      if(x0_last_d1) begin
        s_data1_7[17*7-1:17*6] <= data0[6] - data0[4];
        s_data1_7[17*8-1:17*7] <= data0[7] - data0[5];
      end
      else begin
        s_data1_7[17*7-1:17*6] <= data1[0] - data0[6];
        s_data1_7[17*8-1:17*7] <= data1[1] - data0[7];
      end
    end
  end
  else begin
    s_data1_7 <= s_data1_7;
    s_data1_7 <= s_data1_7;
    s_data1_7 <= s_data1_7;
    s_data1_7 <= s_data1_7;
    s_data1_7 <= s_data1_7;
    s_data1_7 <= s_data1_7;
    s_data1_7 <= s_data1_7;
    s_data1_7 <= s_data1_7;
  end
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    j <= 0;
  end
  else if(i_x0_valid_1_p)
    j <= 0;
  else if(j == 7)
    j <= j;
  else if(i_x0_valid_3)
    j <= j + 1;
  else
    j <= j;
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_data2[0] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data2[1] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data2[2] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data2[3] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data2[4] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data2[5] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data2[6] <= {SAMPLE_WIDTH/2{1'b0}};
    s_data2[7] <= {SAMPLE_WIDTH/2{1'b0}};
  end
  else begin
    if(j==7)
      s_data2[j] <= s_data1_7;
    else
      s_data2[j] <= s_data1[j];
  end
end


//********************  o_y0  ********************//
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
  else if(x0_last)
    cnt_pulse <= 3'b0;
  else if(i_x0_valid_0_p)
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
  if(!rst_n)
    s_y0_valid <= 1'b0;
  else if(cnt_pulse == 3'd2)
    s_y0_valid <= 1'b1;
  else if(k == 7)
    s_y0_valid <= 1'b0;
  else
    s_y0_valid <= s_y0_valid;
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)
    s_y0_valid1 <= 1'b0;
  else if(x0_last_d2)
    s_y0_valid1 <= 1'b1;
  else if(L == 7)
    s_y0_valid1 <= 1'b0;
  else
    s_y0_valid1 <= s_y0_valid1;
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_data3[0] <= 17'b0;
    s_data3[1] <= 17'b0;
    s_data3[2] <= 17'b0;
    s_data3[3] <= 17'b0;
    s_data3[4] <= 17'b0;
    s_data3[5] <= 17'b0;
    s_data3[6] <= 17'b0;
    s_data3[7] <= 17'b0;
  end
  else if(s_y0_valid1) begin
    s_data3[0] <= s_data2[L][17*1-1:17*0];
    s_data3[1] <= s_data2[L][17*2-1:17*1];
    s_data3[2] <= s_data2[L][17*3-1:17*2];
    s_data3[3] <= s_data2[L][17*4-1:17*3];
    s_data3[4] <= s_data2[L][17*5-1:17*4];
    s_data3[5] <= s_data2[L][17*6-1:17*5];
    s_data3[6] <= s_data2[L][17*7-1:17*6];
    s_data3[7] <= s_data2[L][17*8-1:17*7];
  end
  else begin
    s_data3[0] <= s_data2[k][17*1-1:17*0];
    s_data3[1] <= s_data2[k][17*2-1:17*1];
    s_data3[2] <= s_data2[k][17*3-1:17*2];
    s_data3[3] <= s_data2[k][17*4-1:17*3];
    s_data3[4] <= s_data2[k][17*5-1:17*4];
    s_data3[5] <= s_data2[k][17*6-1:17*5];
    s_data3[6] <= s_data2[k][17*7-1:17*6];
    s_data3[7] <= s_data2[k][17*8-1:17*7];
  end
end 

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_y0[0] <= {READ_RAM_WIDTH{1'b0}};
    o_y0[1] <= {READ_RAM_WIDTH{1'b0}};
    o_y0[2] <= {READ_RAM_WIDTH{1'b0}};
    o_y0[3] <= {READ_RAM_WIDTH{1'b0}};
    o_y0[4] <= {READ_RAM_WIDTH{1'b0}};
    o_y0[5] <= {READ_RAM_WIDTH{1'b0}};
    o_y0[6] <= {READ_RAM_WIDTH{1'b0}};
    o_y0[7] <= {READ_RAM_WIDTH{1'b0}};
  end
  else begin
    o_y0[0] <= {s_data3[0][SAMPLE_WIDTH/2],s_data3[0][SAMPLE_WIDTH/2-2:0]};
    o_y0[1] <= {s_data3[1][SAMPLE_WIDTH/2],s_data3[1][SAMPLE_WIDTH/2-2:0]};
    o_y0[2] <= {s_data3[2][SAMPLE_WIDTH/2],s_data3[2][SAMPLE_WIDTH/2-2:0]};
    o_y0[3] <= {s_data3[3][SAMPLE_WIDTH/2],s_data3[3][SAMPLE_WIDTH/2-2:0]};
    o_y0[4] <= {s_data3[4][SAMPLE_WIDTH/2],s_data3[4][SAMPLE_WIDTH/2-2:0]};
    o_y0[5] <= {s_data3[5][SAMPLE_WIDTH/2],s_data3[5][SAMPLE_WIDTH/2-2:0]};
    o_y0[6] <= {s_data3[6][SAMPLE_WIDTH/2],s_data3[6][SAMPLE_WIDTH/2-2:0]};
    o_y0[7] <= {s_data3[7][SAMPLE_WIDTH/2],s_data3[7][SAMPLE_WIDTH/2-2:0]};
  end
end 


endmodule