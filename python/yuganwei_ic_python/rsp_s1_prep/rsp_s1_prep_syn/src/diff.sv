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
  parameter NUM                 = 8
)
(
  input                                         rst_n                ,
  input                                         clk                  ,
  input                                         i_switch             ,
  input      signed [SAMPLE_WIDTH/2-1:0]        i_x0_data [NUM-1:0]  ,
  input                                         i_x0_valid           ,
  input                                         i_x0_last            ,
  output reg signed [SAMPLE_WIDTH/2-1:0]        o_y0      [NUM-1:0]  ,       
  output                                        o_y0_valid
);
//********************  parameter  ********************//

//********************  reg & wire ********************//
reg  signed [SAMPLE_WIDTH/2-1:0]  data0 [NUM-1:0];
reg  signed [SAMPLE_WIDTH/2-1:0]  data1 [NUM-1:0];
reg  signed [SAMPLE_WIDTH/2:0]    s_data[NUM-1:0];
wire                              x0_last;

//********************  delay  ********************//
delay #(4) delay_y0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(o_y0_valid));
delay #(2) delay_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));

//******************** Indicative signal ********************//



//********************  data  ********************//
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
    s_data[0] <= data0[1] - data0[0];
    s_data[1] <= data0[2] - data0[1];
    s_data[2] <= data0[3] - data0[2];
    s_data[3] <= data0[4] - data0[3];
    s_data[4] <= data0[5] - data0[4];
    s_data[5] <= data0[6] - data0[5];
    s_data[6] <= data0[7] - data0[6];
    s_data[7] <= data1[0] - data0[7];
    if(x0_last) begin
      s_data[7] <= data0[7] - data0[6];
    end
    else begin
      s_data[7] <= data1[0] - data0[7];
    end
  end
  else if(i_switch == 1'b0) begin
    s_data[0] <= data0[2] - data0[0];
    s_data[1] <= data0[3] - data0[1];
    s_data[2] <= data0[4] - data0[2];
    s_data[3] <= data0[5] - data0[3];
    s_data[4] <= data0[6] - data0[4];
    s_data[5] <= data0[7] - data0[5];
    s_data[6] <= data1[0] - data0[6];
    s_data[7] <= data1[1] - data0[7];
    if(x0_last) begin
      s_data[6] <= data0[6] - data0[4];
      s_data[7] <= data0[7] - data0[5];
    end
    else begin
      s_data[6] <= data1[0] - data0[6];
      s_data[7] <= data1[1] - data0[7];
    end
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