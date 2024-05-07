`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/08 15:01:15
// Design Name: 
// Module Name: save_file_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 可以控制�?个valid发多少个数据，生成txt文件中的数据可以定位到第几个valid的数据�??
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module save_file_tb #(
    parameter DELAY_VALID_NUM = 4,
    parameter DATA_WIDTH = 16,
    parameter string FILE_ADDR = "D:/IC-DD/ChirpPreprocessing/complex_abs_value.txt",
    parameter cnt_data = 1023,  // one valid = 1023 data
    parameter packet_select = 1    
)(
  input                             rst_n,
  input                             clk,
  input                             valid,
  input  [DATA_WIDTH-1:0]           data
);

localparam para_cnt = 3;

logic delay_valid;
logic cp_last_d0;
logic cp_last_d1;
logic cp_last;
logic [15:0] cnt_valid;
logic [15:0] cnt;
logic s_delay_valid;
logic [15:0] cnt_packet;

integer save_file;

generate 
  if(DELAY_VALID_NUM != 0) begin
    delay#(DELAY_VALID_NUM) u_delay_valid(.clk(clk), .rst_n(rst_n), .din(valid), .dout(s_delay_valid));
  end
  else begin
    assign s_delay_valid = valid;
  end
endgenerate

always @(posedge clk or negedge rst_n) begin //cp_valid
   if(!rst_n) begin
     cp_last_d0 <= 'd0;
     cp_last_d1 <= 'd0;
   end
   else begin
     cp_last_d0 <= valid;
     cp_last_d1 <= cp_last_d0;
   end
 end


// frame cnt
assign cp_last = ~cp_last_d0 & cp_last_d1;

always@(posedge clk) begin
  if(!rst_n)begin
    cnt_packet <= 'd1;
  end
  else begin
    if(cp_last) 
      cnt_packet <= cnt_packet + 'd1;
    else
      cnt_packet <= cnt_packet;
  end
end




always @(posedge clk) begin
  if(!rst_n) begin
    cnt_valid <= 'd0;
  end
  else if(cnt_valid == cnt_data) begin
    cnt_valid <= 'd0;
  end
  else if(s_delay_valid) begin
    cnt_valid <= cnt_valid + 1'b1;
  end
  else begin 
    cnt_valid <= cnt_valid;
  end
end

always @(posedge clk) begin
  if(!rst_n) begin
    cnt <= 'd0;
  end
  else if(cnt_valid == cnt_data) begin
    cnt <= cnt + 1'b1;
  end
  else begin 
    cnt <= cnt;
  end
end


assign delay_valid = (cnt > para_cnt-2 && cnt < para_cnt) ? s_delay_valid : 0;
/////////////////////////////////////////////////////////////

initial begin
  save_file = $fopen(FILE_ADDR);
  if(save_file == 0)begin 
    $display ("can not open the file!");
//    $stop;
  end
end
initial begin
  wait(cnt == para_cnt) #100 $fclose(save_file);
end

always @(posedge clk) begin
   if (delay_valid && cnt_packet == packet_select) begin
     $fdisplay(save_file,"%h",data);
   end
 end

endmodule
