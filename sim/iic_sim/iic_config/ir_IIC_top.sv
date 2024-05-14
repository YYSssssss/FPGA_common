`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/12 13:45:47
// Design Name: 
// Module Name: IIC_top
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


module IR_IIC_top(

input                   clk                ,
input                   rst_n              ,
input                   iic_config_start   ,

inout                   scl                ,
inout                   sda         

);

parameter IIC_CONFIG_NUMBER = 41;

logic [5 : 0] addra  ;
logic [5 : 0] addra_d0  ;
logic [5 : 0] addra_d1  ;
logic         addra_change_flag  ;
logic [31 : 0] dina  ;
logic [31 : 0] douta ;
logic          iic_config_start_d0 ;
logic          iic_config_start_d1 ;
logic          iic_config_start_pos;
logic          iic_start;
logic [7:0]    cnt_done;
logic          iic_write;
logic          done;
logic [3:0]    bit_cnt;

always @(posedge clk)begin
    if(!rst_n) begin
        iic_config_start_d0<=1'd0;
        iic_config_start_d1<=1'd0;
    end
    else begin
        iic_config_start_d0 <= iic_config_start;
        iic_config_start_d1 <= iic_config_start_d0;
    end
end
assign iic_config_start_pos = iic_config_start_d0 & ~iic_config_start_d1;
always @(posedge clk)begin
    if(!rst_n) begin
        iic_start<=1'd0;
    end
    else begin
        if(iic_config_start_pos)
            iic_start <= 1'b1;
        else if(cnt_done == IIC_CONFIG_NUMBER)
            iic_start <= 1'b0;
    end
end

always @(posedge clk)begin
    if(!rst_n) begin
        cnt_done<=8'd0;
    end
    else begin
        if(iic_config_start_pos)
            cnt_done <= 'd0;
        else if(cnt_done == IIC_CONFIG_NUMBER)
            cnt_done <= cnt_done;
        else if(done)
            cnt_done <= cnt_done + 1'b1;
    end
end


ir_mem_config u_mem_gen_ir_config (
  .clka     (clk   ),      // input wire clka
  .ena      (1'b1  ),      // input wire ena
  .wea      ('d0   ),      // input wire [3 : 0] wea
  .addra    (addra ),      // input wire [5 : 0] addra
  .dina     ('d0   ),      // input wire [31 : 0] dina
  .douta    (douta )       // output wire [31 : 0] douta
);

always @(posedge clk)begin
    if(!rst_n)
        addra <= 6'd0;
    else if(iic_config_start_pos)
        addra <= 6'd0;
    else if(done)
        addra <= addra + 1'b1;
end

always @(posedge clk)begin
    if(!rst_n) begin
        addra_d0 <= 6'd0;
        addra_d1 <= 6'd0;
    end
    else begin
        addra_d0 <= addra;
        addra_d1 <= addra_d0;
    end
end

always @(posedge clk)begin
    if(!rst_n) begin
        addra_change_flag <= 0;
    end
    else begin
        if(addra_d1 != addra_d0)
            addra_change_flag <= 1;
        else 
            addra_change_flag <= 0;
    end
end

always @(posedge clk)begin
    if(!rst_n)
        iic_write <= 0;
    else if(done || cnt_done == IIC_CONFIG_NUMBER)
        iic_write <= 0;
    else if(addra_change_flag || iic_config_start_pos)
        iic_write <= 1;
end



logic [7:0]  cs_bit;
logic [15:0] byte_address;
logic [7:0]  write_data;
logic [15:0] state;
always @(posedge clk)begin
    if(!rst_n)
        cs_bit <= 'd0;
    else if(state==16'd2)
        cs_bit <= douta[31:24];
    else 
        cs_bit <= 'd0;
end
always @(posedge clk)begin
    if(!rst_n)
        byte_address <= 'd0;
    else if(state==16'd4)
        byte_address <= douta[23:8];
    else if(state==16'd6)
        byte_address <= douta[23:8];    
    else
        byte_address <= 'd0;
end
always @(posedge clk)begin
    if(!rst_n)
        write_data <= 'd0;
    else if(state==16'd8)
        write_data <= douta[7:0];
    else 
        write_data <= 'd0;
end


IR_IIC_send u_IIC_send(
    .sys_clk      (clk  ),
    .sys_rst_n    (rst_n),
    .iic_en       (1'b1 ),
    .cs_bit       (cs_bit), //可编程地址
    .byte_address (byte_address), //字节地址
    .write        (iic_write),
    .read         (1'b0),
    .write_data   (write_data),
    .read_data    (),
    .scl          (scl),
    .sda          (sda),
    .done         (done),
    .bit_cnt      (bit_cnt),
    .state        (state)
);

endmodule
