`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/28 21:21:06
// Design Name: 
// Module Name: rddmafifo
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


module rddmafifo(
    input sys_rst,
    input sys_clk,
    
    output fifo_ready,
    input fifo_valid,
//    input [31:0] fifo_data,
//    output fifo_clk,
    output [31:0] fifo_rd_cnt
    );

    wire fifo_clk;
    reg fifo_ready;
    reg [31:0] fifo_rd_cnt;
    
    assign fifo_clk = sys_clk;
    //fifo clk = sys_clk/2
//    always@(posedge sys_clk, negedge sys_rst)
//    begin
//        if(!sys_rst)
//        begin
//            fifo_clk <= 0;
//        end
//        else 
//        begin
//            fifo_clk <= ~fifo_clk;
//        end
//    end

    //set fifo_ready
    always@(posedge sys_clk)
    begin
        if(!fifo_valid)
        begin
            fifo_ready <= 0;
        end
        else
        begin
            fifo_ready <= 1;
        end
    end

    //set read fifo count
    always@(negedge fifo_clk, negedge sys_rst)
    begin
        if(!sys_rst)
        begin
            fifo_rd_cnt <= 0;
        end
        else if(fifo_ready)
        begin
            fifo_rd_cnt <= fifo_rd_cnt+1;
        end
    end


endmodule
