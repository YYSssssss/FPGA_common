`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/08/24 19:12:47
// Design Name: 
// Module Name: gen_ram_data
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


module gen_ram_data0 #(
  READ_RAM_WIDTH = 128,
  READ_DATA_NUM  = 1024
)(
    input                             clk,
    input                             rst_n,
    output logic [READ_RAM_WIDTH-1:0] test_data,
    output logic                      cp_valid,
    output logic                      cp_last
);


logic cp_rdy;
logic start = 0;
logic cp_last_d0;
logic cp_last_d1;
logic enb;
logic enb_1;
logic [31:0] cnt_cp_valid;
logic [9:0] addrb;
tpram_1024x128 gen_data (
  .clka   (clk      ),      // input wire clka
  .ena    (1'b1     ),      // input wire ena
  .wea    (1'b0     ),      // input wire [0 : 0] wea
  .addra  ('d0      ),      // input wire [9 : 0] addra
  .dina   ('d0      ),      // input wire [127 : 0] dina
  .clkb   (clk      ),      // input wire clkb
  .enb    (enb | enb_1),      // input wire enb
  .addrb  (addrb    ),      // input wire [9 : 0] addrb
  .doutb  (test_data)       // output wire [127 : 0] doutb
);



always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cp_rdy <= 0;
  end
  else begin
    cp_rdy <= 1;
  end
end

assign enb = cp_valid;
always @(posedge clk or negedge rst_n) begin //enb
  enb_1 <= enb;
end

always @(posedge clk or negedge rst_n) begin //cp_valid
  if(!rst_n) begin
    cp_valid <= 'd0;
  end
  else if(cnt_cp_valid == READ_DATA_NUM-1) begin
    cp_valid <= 1'b0;
  end
  else if(cp_rdy) begin
    cp_valid <= 1'b1;
  end
  else begin
    cp_valid <= 1'b0;
  end
end

always @(posedge clk or negedge rst_n) begin //cp_valid
  if(!rst_n) begin
    cp_last_d0 <= 'd0;
    cp_last_d1 <= 'd0;
  end
  else begin
    cp_last_d0 <= cp_valid;
    cp_last_d1 <= cp_last_d0;
  end
end
assign cp_last = ~cp_last_d0 & cp_last_d1;

always @(posedge clk or negedge rst_n) begin //cnt_cp_valid
  if(!rst_n || start) begin
    cnt_cp_valid <= 'd0;
  end
  else if(cnt_cp_valid == READ_DATA_NUM-1) begin
    cnt_cp_valid <= READ_DATA_NUM-1;
  end
  else if(cp_valid) begin
    cnt_cp_valid <= cnt_cp_valid + 1'b1;
  end
  else begin
    cnt_cp_valid <= 'd0;
  end
end

always @(posedge clk or negedge rst_n) begin //addrb
  if(!rst_n) begin
    addrb <= 'd0;
  end
  else if(addrb == 'd1023) begin
    addrb <= 'd0;
  end
  else if(cp_valid) begin
    addrb <= addrb + 1'b1;
  end
  else 
    addrb <= 'd0;
end


endmodule
