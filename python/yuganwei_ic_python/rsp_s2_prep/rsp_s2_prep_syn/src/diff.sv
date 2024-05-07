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
  parameter SAMPLE_WIDTH        = 32 ,
  parameter DATA_NUM            = 1024 ,
  parameter BURST_LEN           = 8
)
(
  input                                         rst_n                      ,
  input                                         clk                        ,
  input                                         i_switch                   ,
  input      signed [SAMPLE_WIDTH/2-1:0]        i_x0_data [BURST_LEN-1:0]  ,
  input                                         i_x0_valid           ,
  input                                         i_x0_last            ,
  output reg signed [SAMPLE_WIDTH/2-1:0]        o_y0      [BURST_LEN-1:0]  ,       
  output                                        o_y0_valid
);
//********************  parameter  ********************//
localparam CNT_D_WIDTH  = $clog2(BURST_LEN);
localparam CNT_ALL_DATA = $clog2(DATA_NUM);


//********************  reg & wire ********************//
reg  signed [SAMPLE_WIDTH/2-1:0]  data0 [BURST_LEN+1:0];
reg  signed [SAMPLE_WIDTH/2-1:0]  data1 [BURST_LEN-1:0];
reg  signed [SAMPLE_WIDTH/2:0]    s_data[BURST_LEN-1:0];
reg                               valid_d0;
reg                               valid_d1;
wire                              x0_last;


reg [CNT_ALL_DATA:0] cnt_data;
integer i;
integer j;
integer k;
integer L;
//********************  delay  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    valid_d0 <= 1'b0;
    valid_d1 <= 1'b0;
  end
  else begin
    valid_d0 <= i_x0_valid;
    valid_d1 <= valid_d0;
  end
end

delay #(4) delay_y0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(o_y0_valid));
delay #(2) delay_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));

//********************  cnt  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_data <= {CNT_ALL_DATA{1'b0}};
  end
  else if(cnt_data == DATA_NUM-1) begin
    cnt_data <= {CNT_ALL_DATA{1'b0}};
  end
  else if(valid_d1) begin
    cnt_data <= cnt_data + 1'b1;
  end
  else begin
    cnt_data <= cnt_data;
  end
end

//******************** Indicative signal ********************//



//********************  data  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    for (i = 0;i < BURST_LEN+2 ;i = i + 1) begin
      data0[i] <= {SAMPLE_WIDTH/2{1'b0}};
    end
    for (j = 0;j < BURST_LEN ;j = j + 1) begin
      data1[j] <= {SAMPLE_WIDTH/2{1'b0}};
    end
  end
  else begin
    if(i_switch == 1'b1) begin
      data0[1] <= data0[9];
    end
    else begin
      data0[0] <= data0[8];
      data0[1] <= data0[9];
    end

    for (i = 2;i < BURST_LEN+2 ;i = i + 1) begin
      data0[i] <= data1[i-2];
    end

    for (j = 0;j < BURST_LEN;j = j + 1) begin
      data1[j] <= i_x0_data[j];
    end
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
  else if(i_switch == 1'b1) begin
    if(cnt_data == 'd0 && valid_d1)
      s_data[0] <= data0[3] - data0[2];
    else
      s_data[0] <= data0[2] - data0[1];
    s_data[1] <= data0[3] - data0[2];
    s_data[2] <= data0[4] - data0[3];
    s_data[3] <= data0[5] - data0[4];
    s_data[4] <= data0[6] - data0[5];
    s_data[5] <= data0[7] - data0[6];
    s_data[6] <= data0[8] - data0[7];
    s_data[7] <= data0[9] - data0[8];
  end
  else begin
    if(cnt_data == 'd0 && valid_d1) begin
      s_data[0] <= data0[4] - data0[2];
      s_data[1] <= data0[5] - data0[3];
    end
    else begin
      s_data[0] <= data0[2] - data0[0];
      s_data[1] <= data0[3] - data0[1];
    end
    s_data[2] <= data0[4] - data0[2];
    s_data[3] <= data0[5] - data0[3];
    s_data[4] <= data0[6] - data0[4];
    s_data[5] <= data0[7] - data0[5];
    s_data[6] <= data0[8] - data0[6];
    s_data[7] <= data0[9] - data0[7];
  end
  // else begin
  //   s_data[0] <= s_data[0];
  //   s_data[1] <= s_data[1];
  //   s_data[2] <= s_data[2];
  //   s_data[3] <= s_data[3];
  //   s_data[4] <= s_data[4];
  //   s_data[5] <= s_data[5];
  //   s_data[6] <= s_data[6];
  //   s_data[7] <= s_data[7];
  // end
end 





//********************  o_y0  ********************//
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
    o_y0[0] <= {s_data[0][SAMPLE_WIDTH/2],s_data[0][SAMPLE_WIDTH/2-2:0]};
    o_y0[1] <= {s_data[1][SAMPLE_WIDTH/2],s_data[1][SAMPLE_WIDTH/2-2:0]};
    o_y0[2] <= {s_data[2][SAMPLE_WIDTH/2],s_data[2][SAMPLE_WIDTH/2-2:0]};
    o_y0[3] <= {s_data[3][SAMPLE_WIDTH/2],s_data[3][SAMPLE_WIDTH/2-2:0]};
    o_y0[4] <= {s_data[4][SAMPLE_WIDTH/2],s_data[4][SAMPLE_WIDTH/2-2:0]};
    o_y0[5] <= {s_data[5][SAMPLE_WIDTH/2],s_data[5][SAMPLE_WIDTH/2-2:0]};
    o_y0[6] <= {s_data[6][SAMPLE_WIDTH/2],s_data[6][SAMPLE_WIDTH/2-2:0]};
    o_y0[7] <= {s_data[7][SAMPLE_WIDTH/2],s_data[7][SAMPLE_WIDTH/2-2:0]};
  end
end 


endmodule