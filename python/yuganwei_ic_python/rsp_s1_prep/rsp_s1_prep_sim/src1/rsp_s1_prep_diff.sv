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
`include "rsp_s1_prep_defines.vh"

module rsp_s1_prep_diff #(
  parameter READ_RAM_WIDTH      = 128,
  parameter SAMPLE_WIDTH        = 32 ,
  parameter DATA_NUM            = 1024 ,
  parameter BURST_LEN           = 8
)
(
  input                                         rst_n                      ,
  input                                         clk                        ,
  input                                         i_sel_16_32                ,
  input                                         i_switch                   ,
  input             [SAMPLE_WIDTH/2-1:0]        i_x0_data [BURST_LEN-1:0]  ,
  input                                         i_x0_valid           ,
  input                                         i_x0_last            ,
  output reg        [SAMPLE_WIDTH/2-1:0]        o_y0      [BURST_LEN-1:0]  ,       
  output                                        o_y0_valid
);
//********************  parameter  ********************//
localparam CNT_D_WIDTH  = $clog2(BURST_LEN);
localparam CNT_ALL_DATA = $clog2(DATA_NUM);


//********************  reg & wire ********************//
reg [SAMPLE_WIDTH/2-1:0]  y1  [BURST_LEN-1:0];
reg [SAMPLE_WIDTH/2-1:0]  data0 [BURST_LEN+3:0];
reg [SAMPLE_WIDTH/2-1:0]  data1 [BURST_LEN-1:0];
reg [SAMPLE_WIDTH/2:0]    s_data[BURST_LEN-1:0];
reg [SAMPLE_WIDTH:0]      data_32[BURST_LEN/2-1:0];
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

delay #(`DELAY_DIFF_X0_VALID) delay_y0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(o_y0_valid));
delay #(`DELAY_DIFF_X0_LAST) delay_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));

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
    if(i_sel_16_32 == 1'b1) begin
      data0[0] <= data0[8];
      data0[1] <= data0[9];
      data0[2] <= data0[10];
      data0[3] <= data0[11];
    end
    else if(i_switch == 1'b1) begin
      data0[1] <= data0[9];
    end
    else begin
      data0[0] <= data0[8];
      data0[1] <= data0[9];
    end

    if(i_sel_16_32 == 1'b1) begin
      for (i = 4;i < BURST_LEN+4 ;i = i + 1) begin
        data0[i] <= data1[i-4];
      end
    end
    else begin
      for (i = 2;i < BURST_LEN+2 ;i = i + 1) begin
        data0[i] <= data1[i-2];
      end
    end

    for (j = 0;j < BURST_LEN;j = j + 1) begin
      data1[j] <= i_x0_data[j];
    end
  end
end

//********************  diff  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    for (i = 0;i < BURST_LEN ;i = i + 1) begin
      s_data[i] <= {SAMPLE_WIDTH/2{1'b0}};
    end
    for (i = 0;i < BURST_LEN/2 ;i = i + 1) begin
      data_32[i] <= {SAMPLE_WIDTH{1'b0}};
    end
  end
  else if(i_sel_16_32 == 1'b1) begin
    if(cnt_data == 'd0 && valid_d1) begin
      data_32[0] <= {data0[9][15],data0[9],data0[8]} - {data0[5][15],data0[5],data0[4]};
      data_32[1] <= {data0[11][15],data0[11],data0[10]} - {data0[7][15],data0[7],data0[6]};
    end
    else begin
      data_32[0] <= {data0[5][15],data0[5],data0[4]} - {data0[1][15],data0[1],data0[0]};
      data_32[1] <= {data0[7][15],data0[7],data0[6]} - {data0[3][15],data0[3],data0[2]};
    end
    data_32[2] <= {data0[9][15],data0[9],data0[8]} - {data0[5][15],data0[5],data0[4]};
    data_32[3] <= {data0[11][15],data0[11],data0[10]} - {data0[7][15],data0[7],data0[6]};
  end
  // else if(i_sel_16_32 == 1'b1) begin
  //   if(cnt_data == 'd0 && valid_d1) begin
  //     data_32[0] <= {data[9],data[8]} - {data0[5],data0[4]};
  //     data_H16[0] <= data0[9] + ~data0[5];
  //     data_L16[1] <= data0[10] + ~data0[6]+1;
  //     data_H16[1] <= data0[11] + ~data0[7];
  //   end
  //   else begin
  //     data_L16[0] <= data0[4] + ~data0[0]+1;
  //     data_H16[0] <= data0[5] + ~data0[1];
  //     data_L16[1] <= data0[6] + ~data0[2]+1;
  //     data_H16[1] <= data0[7] + ~data0[3];
  //   end
  //   data_L16[2] <= data0[8] + ~data0[4]+1;
  //   data_H16[2] <= data0[9] + ~data0[5];
  //   data_L16[3] <= data0[10] + ~data0[6]+1;
  //   data_H16[3] <= data0[11] + ~data0[7];
  // end
  else if(i_switch == 1'b1) begin
    if(cnt_data == 'd0 && valid_d1)
      s_data[0] <= {data0[3][SAMPLE_WIDTH/2-1],data0[3]} - {data0[2][SAMPLE_WIDTH/2-1],data0[2]};
    else
      s_data[0] <= {data0[2][SAMPLE_WIDTH/2-1],data0[2]} - {data0[1][SAMPLE_WIDTH/2-1],data0[1]};
    s_data[1] <= {data0[3][SAMPLE_WIDTH/2-1],data0[3]} - {data0[2][SAMPLE_WIDTH/2-1],data0[2]};
    s_data[2] <= {data0[4][SAMPLE_WIDTH/2-1],data0[4]} - {data0[3][SAMPLE_WIDTH/2-1],data0[3]};
    s_data[3] <= {data0[5][SAMPLE_WIDTH/2-1],data0[5]} - {data0[4][SAMPLE_WIDTH/2-1],data0[4]};
    s_data[4] <= {data0[6][SAMPLE_WIDTH/2-1],data0[6]} - {data0[5][SAMPLE_WIDTH/2-1],data0[5]};
    s_data[5] <= {data0[7][SAMPLE_WIDTH/2-1],data0[7]} - {data0[6][SAMPLE_WIDTH/2-1],data0[6]};
    s_data[6] <= {data0[8][SAMPLE_WIDTH/2-1],data0[8]} - {data0[7][SAMPLE_WIDTH/2-1],data0[7]};
    s_data[7] <= {data0[9][SAMPLE_WIDTH/2-1],data0[9]} - {data0[8][SAMPLE_WIDTH/2-1],data0[8]};
  end
  else begin
    if(cnt_data == 'd0 && valid_d1) begin
      s_data[0] <= {data0[4][SAMPLE_WIDTH/2-1],data0[4]} - {data0[2][SAMPLE_WIDTH/2-1],data0[2]};
      s_data[1] <= {data0[5][SAMPLE_WIDTH/2-1],data0[5]} - {data0[3][SAMPLE_WIDTH/2-1],data0[3]};
    end
    else begin
      s_data[0] <= {data0[2][SAMPLE_WIDTH/2-1],data0[2]} - {data0[0][SAMPLE_WIDTH/2-1],data0[0]};
      s_data[1] <= {data0[3][SAMPLE_WIDTH/2-1],data0[3]} - {data0[1][SAMPLE_WIDTH/2-1],data0[1]};
    end
    s_data[2] <= {data0[4][SAMPLE_WIDTH/2-1],data0[4]} - {data0[2][SAMPLE_WIDTH/2-1],data0[2]};
    s_data[3] <= {data0[5][SAMPLE_WIDTH/2-1],data0[5]} - {data0[3][SAMPLE_WIDTH/2-1],data0[3]};
    s_data[4] <= {data0[6][SAMPLE_WIDTH/2-1],data0[6]} - {data0[4][SAMPLE_WIDTH/2-1],data0[4]};
    s_data[5] <= {data0[7][SAMPLE_WIDTH/2-1],data0[7]} - {data0[5][SAMPLE_WIDTH/2-1],data0[5]};
    s_data[6] <= {data0[8][SAMPLE_WIDTH/2-1],data0[8]} - {data0[6][SAMPLE_WIDTH/2-1],data0[6]};
    s_data[7] <= {data0[9][SAMPLE_WIDTH/2-1],data0[9]} - {data0[7][SAMPLE_WIDTH/2-1],data0[7]};
  end
end 





//********************  o_y0  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    for (i = 0;i < BURST_LEN ;i = i + 1) begin
      o_y0[i] <= {SAMPLE_WIDTH/2{1'b0}};
    end
  end
  else if(i_sel_16_32 == 1'b1) begin
    if(~data_32[0][SAMPLE_WIDTH] && (|data_32[0][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[0] <= {(SAMPLE_WIDTH/2){1'b1}};
      o_y0[1] <= {(SAMPLE_WIDTH/2-1){1'b1}};
    end
    else if(data_32[0][SAMPLE_WIDTH] && ~(&data_32[0][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[0] <= {{(SAMPLE_WIDTH/2-1){1'b0}},{1'b1}};
      o_y0[1] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
    end
    else begin
      o_y0[0] <= data_32[0][15:0];
      o_y0[1] <= data_32[0][31:16];
    end

    if(~data_32[1][SAMPLE_WIDTH] && (|data_32[1][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[2] <= {(SAMPLE_WIDTH/2){1'b1}};
      o_y0[3] <= {(SAMPLE_WIDTH/2-1){1'b1}};
    end
    else if(data_32[1][SAMPLE_WIDTH] && ~(&data_32[1][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[2] <= {{(SAMPLE_WIDTH/2-1){1'b0}},{1'b1}};
      o_y0[3] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
    end
    else begin
      o_y0[2] <= data_32[1][15:0];
      o_y0[3] <= data_32[1][31:16];
    end

    if(~data_32[2][SAMPLE_WIDTH] && (|data_32[2][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[4] <= {(SAMPLE_WIDTH/2){1'b1}};
      o_y0[5] <= {(SAMPLE_WIDTH/2-1){1'b1}};
    end
    else if(data_32[2][SAMPLE_WIDTH] && ~(&data_32[2][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[4] <= {{(SAMPLE_WIDTH/2-1){1'b0}},{1'b1}};
      o_y0[5] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
    end
    else begin
      o_y0[4] <= data_32[2][15:0];
      o_y0[5] <= data_32[2][31:16];
    end

    if(~data_32[3][SAMPLE_WIDTH] && (|data_32[3][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[6] <= {(SAMPLE_WIDTH/2){1'b1}};
      o_y0[7] <= {(SAMPLE_WIDTH/2-1){1'b1}};
    end
    else if(data_32[3][SAMPLE_WIDTH] && ~(&data_32[3][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
      o_y0[6] <= {{(SAMPLE_WIDTH/2-1){1'b0}},{1'b1}};
      o_y0[7] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
    end
    else begin
      o_y0[6] <= data_32[3][15:0];
      o_y0[7] <= data_32[3][31:16];
    end

    // o_y0[0] <= data_32[0][15:0];
    // o_y0[1] <= data_32[0][31:16];
    // o_y0[2] <= data_32[1][15:0];
    // o_y0[3] <= data_32[1][31:16];
    // o_y0[4] <= data_32[2][15:0];
    // o_y0[5] <= data_32[2][31:16];
    // o_y0[6] <= data_32[3][15:0];
    // o_y0[7] <= data_32[3][31:16];
  end
  else begin
    for (i=0; i<BURST_LEN; i=i+1) begin
      if(~s_data[i][SAMPLE_WIDTH/2] && (|s_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
        o_y0[i] <= {(SAMPLE_WIDTH/2-1){1'b1}};
      end
      else if(s_data[i][SAMPLE_WIDTH/2] && ~(&s_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
        o_y0[i] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
      end
      else begin
        o_y0[i] <= {s_data[i][SAMPLE_WIDTH/2],s_data[i][SAMPLE_WIDTH/2-2:0]};;
      end
    end
  end
end

// generate
//   for (genvar i=0; i<BURST_LEN; i=i+1) begin
//     always @(posedge clk or negedge rst_n) begin
//       if(!rst_n) begin
//         o_y0[i] <= {SAMPLE_WIDTH/2{1'b0}};
//       end
//       else begin
//         if(~s_data[i][SAMPLE_WIDTH/2] && (|s_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
//           o_y0[i] <= {(SAMPLE_WIDTH/2-1){1'b1}};
//         end
//         else if(s_data[i][SAMPLE_WIDTH/2] && ~(&s_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
//           o_y0[i] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
//         end
//         else begin
//           o_y0[i] <= {s_data[i][SAMPLE_WIDTH/2],s_data[i][SAMPLE_WIDTH/2-2:0]};;
//         end
//       end
//     end
//   end
// endgenerate

// always @(posedge clk or negedge rst_n) begin
//   if(!rst_n) begin
//     o_y0[0] <= {READ_RAM_WIDTH{1'b0}};
//     o_y0[1] <= {READ_RAM_WIDTH{1'b0}};
//     o_y0[2] <= {READ_RAM_WIDTH{1'b0}};
//     o_y0[3] <= {READ_RAM_WIDTH{1'b0}};
//     o_y0[4] <= {READ_RAM_WIDTH{1'b0}};
//     o_y0[5] <= {READ_RAM_WIDTH{1'b0}};
//     o_y0[6] <= {READ_RAM_WIDTH{1'b0}};
//     o_y0[7] <= {READ_RAM_WIDTH{1'b0}};
//   end
//   else begin
//     o_y0[0] <= {s_data[0][SAMPLE_WIDTH/2],s_data[0][SAMPLE_WIDTH/2-2:0]};
//     o_y0[1] <= {s_data[1][SAMPLE_WIDTH/2],s_data[1][SAMPLE_WIDTH/2-2:0]};
//     o_y0[2] <= {s_data[2][SAMPLE_WIDTH/2],s_data[2][SAMPLE_WIDTH/2-2:0]};
//     o_y0[3] <= {s_data[3][SAMPLE_WIDTH/2],s_data[3][SAMPLE_WIDTH/2-2:0]};
//     o_y0[4] <= {s_data[4][SAMPLE_WIDTH/2],s_data[4][SAMPLE_WIDTH/2-2:0]};
//     o_y0[5] <= {s_data[5][SAMPLE_WIDTH/2],s_data[5][SAMPLE_WIDTH/2-2:0]};
//     o_y0[6] <= {s_data[6][SAMPLE_WIDTH/2],s_data[6][SAMPLE_WIDTH/2-2:0]};
//     o_y0[7] <= {s_data[7][SAMPLE_WIDTH/2],s_data[7][SAMPLE_WIDTH/2-2:0]};
//   end
// end 

// genvar i;
// generate
//   for (i=0; i<BURST_LEN; i=i+1) begin
//     always @(posedge clk or negedge rst_n) begin
//       if(!rst_n) begin
//         o_y0[i] <= {SAMPLE_WIDTH/2{1'b0}};
//       end
//       else begin
//         if(~s_data[i][SAMPLE_WIDTH/2] && (|s_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
//           o_y0[i] <= {(SAMPLE_WIDTH/2-1){1'b1}};
//         end
//         else if(s_data[i][SAMPLE_WIDTH/2] && ~(&s_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
//           o_y0[i] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
//         end
//         else begin
//           o_y0[i] <= {s_data[i][SAMPLE_WIDTH/2],s_data[i][SAMPLE_WIDTH/2-2:0]};;
//         end
//       end
//     end
//   end
// endgenerate

// always @(posedge clk or negedge rst_n) begin
//   if(!rst_n) begin
//     for (i = 0;i < BURST_LEN ;i = i + 1) begin
//       y1[i] <= {SAMPLE_WIDTH/2{1'b0}};
//     end
//   end
//   else begin
//     if(~data_H16[0][SAMPLE_WIDTH/2+1] && (|data_H16[0][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[0] <= {(SAMPLE_WIDTH/2){1'b1}};
//       y1[1] <= {(SAMPLE_WIDTH/2-1){1'b1}};
//     end
//     else if(data_H16[0][SAMPLE_WIDTH/2+1] && ~(&data_H16[0][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[1] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
//       y1[1] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
//     end
//     else begin
//       y1[0] <= data_L16[0][15:0];
//       y1[1] <= data_H16[0][15:0] + data_L16[0][16];
//     end

//     if(~data_H16[1][SAMPLE_WIDTH/2+1] && (|data_H16[1][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[2] <= {(SAMPLE_WIDTH/2){1'b1}};
//       y1[3] <= {(SAMPLE_WIDTH/2-1){1'b1}};
//     end
//     else if(data_H16[1][SAMPLE_WIDTH/2+1] && ~(&data_H16[1][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[2] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
//       y1[3] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
//     end
//     else begin   
//       o_y0[2] <= data_L16[1][15:0];
//       o_y0[3] <= data_H16[1][15:0] + data_L16[1][16];
//     end

//     if(~data_H16[2][SAMPLE_WIDTH/2+1] && (|data_H16[2][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[4] <= {(SAMPLE_WIDTH/2){1'b1}};
//       y1[5] <= {(SAMPLE_WIDTH/2-1){1'b1}};
//     end
//     else if(data_H16[2][SAMPLE_WIDTH/2+1] && ~(&data_H16[2][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[4] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
//       y1[5] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
//     end
//     else begin
//       y1[4] <= data_L16[2][15:0];
//       y1[5] <= data_H16[2][15:0] + data_L16[2][16];
//     end

//     if(~data_H16[3][SAMPLE_WIDTH/2+1] && (|data_H16[3][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[6] <= {(SAMPLE_WIDTH/2){1'b1}};
//       y1[7] <= {(SAMPLE_WIDTH/2-1){1'b1}};
//     end
//     else if(data_H16[3][SAMPLE_WIDTH/2+1] && ~(&data_H16[3][SAMPLE_WIDTH/2+1:SAMPLE_WIDTH/2])) begin
//       y1[6] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
//       y1[7] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
//     end
//     else begin
//       y1[6] <= data_L16[3][15:0];
//       y1[7] <= data_H16[3][15:0] + data_L16[3][16];
//     end
//   end
// end

endmodule