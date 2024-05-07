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
  parameter DIFF_Y0_VALID       = 6,
  parameter CNT_LEN             = 8
)
(
  input                             rst_n                ,
  input                             clk                  ,
  input                             i_switch             ,        //switch-- 1:real_cal  0:complex_cal
  input  [SAMPLE_WIDTH/2-1:0]       i_x0_data [NUM-1:0]  ,        //input complex or real 128bit
  input                             i_x0_valid           ,        //input complex or real valid data
  input                             i_x0_last            ,        //input complex or real last data
  output reg [SAMPLE_WIDTH/2-1:0]   o_y0      [NUM-1:0]  ,        //output complex or real
  output                            o_y0_valid
);

//********************  reg & wire & assign  ********************//
reg  signed [SAMPLE_WIDTH/2-1:0]  data0 [NUM-1:0];
reg  signed [SAMPLE_WIDTH/2-1:0]  data1 [NUM-1:0];
reg  signed [READ_RAM_WIDTH+7:0]  s_data0[NUM-1:0];
reg  signed [SAMPLE_WIDTH/2:0]    s_data1[NUM-1:0];
reg  signed [SAMPLE_WIDTH/2:0]    s_data[NUM-1:0];

wire                            x0_last_data;
wire                            x0_diff_valid;
wire                            x0_last;

reg [7:0]                       state;
reg [7:0]                       next_state;
reg                             i_x0_valid_d0;
reg                             i_x0_valid_d1;
reg                             i_x0_valid_d2;
wire                            i_x0_valid_p;
wire                            i_x0_valid_d1_p;
wire                            i_x0_valid_d1_n;
wire                            x0_valid_p;

reg [15:0]                      cnt_valid;
reg [15:0]                      cnt_valid_d1;
reg                             s_y0_valid;

integer cnt_i;

//********************  parameter  ********************//
localparam IDLE            = 8'b00000000;
localparam SAVE_DATA       = 8'b00000001;
          // TAKE_SHOT       = 8'b00000010,
localparam LAST_CALC       = 8'b00000010;

//********************  sample edge  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_x0_valid_d0 <= 1'b0;
    i_x0_valid_d1 <= 1'b0;
    i_x0_valid_d2 <= 1'b0;
  end
  else begin
    i_x0_valid_d0 <=i_x0_valid;
    i_x0_valid_d1 <=i_x0_valid_d0;
    i_x0_valid_d2 <=i_x0_valid_d1;
  end
end
assign i_x0_valid_p = i_x0_valid_d0 & ~i_x0_valid_d1;
assign i_x0_valid_d1_p = i_x0_valid_d1 & ~i_x0_valid_d2;
assign i_x0_valid_d1_n = ~i_x0_valid_d1 & i_x0_valid_d2;
assign x0_valid_p = i_x0_valid_d0 & i_x0_valid_d1;

//********************  delay  ********************//
delay #(DIFF_X0_LAST_DATA) delay_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last_data));
delay #(DIFF_X0_DIFF_VALID) delay_diff_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(x0_diff_valid));
delay #(DIFF_X0_LAST) delay_diff_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));
delay #(DIFF_Y0_VALID) delay_diff_HF_cvalid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(s_y0_valid));

//********************  cnt  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_valid <= 16'b0;
  end
  else if(x0_last_data) begin
    cnt_valid <= 16'b0;
  end
  else if(cnt_valid == 16'd7) begin
    cnt_valid <= 16'b0;
  end
  else if(i_x0_valid_d0) begin
    cnt_valid <= cnt_valid + 1'b1;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_valid_d1 <= 12'b0;
  end
  else begin
    cnt_valid_d1 <= cnt_valid;
  end
end

//********************  prepare  ********************//
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
  else if (i_x0_valid || x0_last_data) begin
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
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    state <= 10'b0;
  end
  else begin
    state <= next_state;
  end
end

always @(*) begin
  case(state)
    IDLE : begin
        if(i_x0_valid_p)  next_state = SAVE_DATA;
        else              next_state = IDLE;
      end
    SAVE_DATA  : begin
        if(x0_valid_p) next_state = SAVE_DATA;
        else         next_state = LAST_CALC;
      end
    LAST_CALC  : begin
        if(x0_last_data)         next_state = IDLE;
        else if(i_x0_valid_d1_p) next_state = SAVE_DATA;
        else                     next_state = LAST_CALC;
      end
    default : next_state = IDLE;
  endcase
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    s_data0[0] <= 136'b0;
    s_data0[1] <= 136'b0;
    s_data0[2] <= 136'b0;
    s_data0[3] <= 136'b0;
    s_data0[4] <= 136'b0;
    s_data0[5] <= 136'b0;
    s_data0[6] <= 136'b0;
    s_data0[7] <= 136'b0;
    cnt_i      <= 0;
  end
  else begin
    case(state)
      IDLE : begin
          cnt_i <= 0;
        end
      SAVE_DATA  : begin
          cnt_i <= cnt_i + 1'b1;
          s_data0[cnt_i][17*1-1:17*0] <= data0[1] - data0[0];
          s_data0[cnt_i][17*2-1:17*1] <= data0[2] - data0[1];
          s_data0[cnt_i][17*3-1:17*2] <= data0[3] - data0[2];
          s_data0[cnt_i][17*4-1:17*3] <= data0[4] - data0[3];
          s_data0[cnt_i][17*5-1:17*4] <= data0[5] - data0[4];
          s_data0[cnt_i][17*6-1:17*5] <= data0[6] - data0[5];
          s_data0[cnt_i][17*7-1:17*6] <= data0[7] - data0[6];
          s_data0[cnt_i][17*8-1:17*7] <= data1[0] - data0[7];
        end
      LAST_CALC  : begin
          cnt_i <= 0;

          if(x0_last)
            s_data0[7][17*8+1:18*7] <= data0[7] - data0[6];
          else if(x0_valid_p)
            s_data0[7][17*8+1:18*7] <= data1[0] - data0[7];
        end
      default : next_state = IDLE;
    endcase
  end
end

//********************    ********************//
integer j;
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    j <= 0;
  end
  else if(j == 7)
    j <= 0;
  else if(i_x0_valid_d2)
    j <= j + 1;
  else 
    j <= j;
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
    s_data1[7] <= {SAMPLE_WIDTH/2{1'b0}};
  end
  else if(i_x0_valid_d2) begin
    s_data1[0] <= s_data0[j][17*1-1:17*0];
    s_data1[1] <= s_data0[j][17*2-1:17*1];
    s_data1[2] <= s_data0[j][17*3-1:17*2];
    s_data1[3] <= s_data0[j][17*4-1:17*3];
    s_data1[4] <= s_data0[j][17*5-1:17*4];
    s_data1[5] <= s_data0[j][17*6-1:17*5];
    s_data1[6] <= s_data0[j][17*7-1:17*6];
    s_data1[7] <= s_data0[j][17*8-1:17*7];
  end
end 


//********************  o_y0  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_y0[0] <= {SAMPLE_WIDTH/2{1'b0}};
    o_y0[1] <= {SAMPLE_WIDTH/2{1'b0}};
    o_y0[2] <= {SAMPLE_WIDTH/2{1'b0}};
    o_y0[3] <= {SAMPLE_WIDTH/2{1'b0}};
    o_y0[4] <= {SAMPLE_WIDTH/2{1'b0}};
    o_y0[5] <= {SAMPLE_WIDTH/2{1'b0}};
    o_y0[6] <= {SAMPLE_WIDTH/2{1'b0}};
    o_y0[7] <= {SAMPLE_WIDTH/2{1'b0}};
  end
  else begin
    o_y0[0] <= {s_data1[0][SAMPLE_WIDTH/2],s_data1[0][SAMPLE_WIDTH/2-2:0]};
    o_y0[1] <= {s_data1[1][SAMPLE_WIDTH/2],s_data1[1][SAMPLE_WIDTH/2-2:0]};
    o_y0[2] <= {s_data1[2][SAMPLE_WIDTH/2],s_data1[2][SAMPLE_WIDTH/2-2:0]};
    o_y0[3] <= {s_data1[3][SAMPLE_WIDTH/2],s_data1[3][SAMPLE_WIDTH/2-2:0]};
    o_y0[4] <= {s_data1[4][SAMPLE_WIDTH/2],s_data1[4][SAMPLE_WIDTH/2-2:0]};
    o_y0[5] <= {s_data1[5][SAMPLE_WIDTH/2],s_data1[5][SAMPLE_WIDTH/2-2:0]};
    o_y0[6] <= {s_data1[6][SAMPLE_WIDTH/2],s_data1[6][SAMPLE_WIDTH/2-2:0]};
    o_y0[7] <= {s_data1[7][SAMPLE_WIDTH/2],s_data1[7][SAMPLE_WIDTH/2-2:0]};
  end
end 


endmodule