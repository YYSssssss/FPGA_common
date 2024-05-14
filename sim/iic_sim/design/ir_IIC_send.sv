`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/12 13:26:22
// Design Name: 
// Module Name: IIC_send
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


module IR_IIC_send(
    input                   sys_clk     ,
    input                   sys_rst_n   ,
    input                   iic_en      ,
    input         [7:0]     cs_bit      , //可编程地址
    input         [12:0]    byte_address, //字节地址
    input                   write       ,
    input                   read        ,
    input         [7:0]     write_data  ,
    output reg    [7:0]     read_data   ,
    output reg              scl         ,
    inout                   sda         ,
    output reg              done       ,
    
    output        [3:0]     bit_cnt,
    output        [15:0]    state
);


    parameter
    CONFIG_SYS_CLK=50_000_000, //系统时钟50MHz
    CONFIG_SCL_CLK=200_000; //scl时钟200KHz
    reg [7:0]scl_cnt; //时钟计数

    parameter div_cnt = CONFIG_SYS_CLK/CONFIG_SCL_CLK;

    always @(posedge sys_clk or negedge sys_rst_n)begin
        if(!sys_rst_n)
            scl_cnt<=8'd0;
        else if(scl_cnt == div_cnt-1'b1)
            scl_cnt<=8'd0;
        else
            scl_cnt<=scl_cnt+1'b1;
    end

    //生成scl时钟线
    always @(posedge sys_clk or negedge sys_rst_n)begin
        if(!sys_rst_n)
            scl<=1'b1;
        else if(scl_cnt == (div_cnt>>1)-1'b1)
            scl<=1'b0;
        else if(scl_cnt == div_cnt-1'b1)
            scl<=1'b1;
        else
            scl<=scl;
    end

    //scl电平中线
    reg scl_high_middle; //scl高电平中线
    reg scl_low_middle; //scl低电平中线
    always @(posedge sys_clk or negedge sys_rst_n)begin
        if(!sys_rst_n)begin
            scl_high_middle<=1'b0;
            scl_low_middle<=1'b0;
        end
        else if(scl_cnt == (div_cnt>>2))
            scl_high_middle<=1'b1;
        else if(scl_cnt == (div_cnt>>1)+(div_cnt>>2))
            scl_low_middle<=1'b1;
        else begin
            scl_high_middle<=1'b0;
            scl_low_middle<=1'b0;
        end
    end

    reg [15:0]state;
    parameter
    idle=16'd1, //空闲状态
    w_or_r_start=16'd2, //设备地址
    device_ADDR=16'd3, //发送
    ACK1=16'd4,
    byte_ADDR_high=16'd5, //字节地址高8位
    ACK2=16'd6,
    byte_ADDR_low=16'd7, //字节地址低8位
    ACK3=16'd8,
    w_data=16'd9, //写数据
    ACK4=16'd10,
    r_start=16'd11, //读开始
    device_ADDR_r=16'd12, //设备地址读
    ACK5=16'd13,
    r_data=16'd14, //读数据
    NACK=16'd15, //非应答位
    stop=16'd16;

    reg sda_en; //sda数据线使能
    reg sda_reg; //sda数据暂存位
    reg [7:0]sda_data_out; //sda数据发给从机暂存
    reg [7:0]sda_data_in; //sda数据取之从机暂存
    reg [3:0]bit_cnt; //每一bit
    
//    assign sda=sda_en?sda_reg:1'b0;
    assign sda=sda_en?sda_reg:1'b1;

    //读写标志位
    reg w_flag;
    reg r_flag;

    always @(posedge sys_clk or negedge sys_rst_n)begin
        if(!sys_rst_n)begin
            state<=idle;
            w_flag<=1'b0;
            r_flag<=1'b0;
            sda_reg<=1'b1;
            done<=1'b0;
            sda_en<=1'b0;
            bit_cnt<='d0;
        end
        else begin
            case(state)

                idle:begin
                    sda_reg<=1'b1;
                    w_flag<=1'b0;
                    r_flag<=1'b0;
                    sda_en<=1'b0;
                    sda_reg<=1'b1;
                    done<=1'b0;
                    if(iic_en && write)begin
                        w_flag<=1'b1;
                        sda_en<=1'b1;
                        sda_reg<=1'b1;
                        state<=w_or_r_start;
                    end
                    else if(iic_en && read)begin
                        r_flag<=1'b1;
                        sda_en<=1'b1;
                        sda_reg<=1'b1;
                        state<=w_or_r_start;
                    end
                    else
                        state<=idle;
                end

                w_or_r_start:begin
                    if(scl_high_middle)begin
                        sda_reg<=1'b0;
                        sda_data_out<=cs_bit; //在这里装好设备地址
                        bit_cnt<=4'd8;
                        state<=device_ADDR;
                    end
                    else begin
                        sda_reg<=1'b1;
                        state<=w_or_r_start;
                    end
                end

                device_ADDR:begin
                    if(scl_low_middle)begin
                        bit_cnt<=bit_cnt-1'b1;
                        sda_reg<=sda_data_out[7];
                        sda_data_out<={sda_data_out[6:0],1'b0}; //在这里发出设备地址。其他的也是在上一状态装好值，下一个状态发出
                        if(bit_cnt==0)begin
                            state<=ACK1;
                            sda_en<=1'b0;
                        end
                        else
                            state<=device_ADDR;
                    end
                    else
                        state<=device_ADDR;
                end

                ACK1:begin
                    if(scl_high_middle)begin
                        if(sda==1'b1)begin
                            state<=byte_ADDR_high;
                            sda_data_out<={3'b0,byte_address[12:8]};
                            bit_cnt<=4'd8;
                        end
                        else
                            state<=idle;
                    end
                    else
                        state<=ACK1;
                end

                byte_ADDR_high:begin
                    if(scl_low_middle)begin
                        sda_en<=1'b1;
                        bit_cnt<=bit_cnt+1'b1;
                        sda_reg<=sda_data_out[7];
                        sda_data_out<={sda_data_out[6:0],1'b0};
                        if(bit_cnt==0)begin
                            state<=ACK2;
                            sda_en<=1'b0;
                        end
                        else
                            state<=byte_ADDR_high;
                    end
                    else
                        state<=byte_ADDR_high;
                end

                ACK2:begin
                    if(scl_high_middle)begin
                        if(sda==1'b1)begin
                            state<=byte_ADDR_low;
                            sda_data_out<=byte_address[7:0];
                            bit_cnt<=4'd8;
                        end
                        else
                            state<=idle;
                    end
                    else
                        state<=ACK2;
                end

                byte_ADDR_low:begin
                    if(scl_low_middle)begin
                        sda_en<=1'b1;
                        bit_cnt<=bit_cnt-1'b1;
                        sda_reg<=sda_data_out[7];
                        sda_data_out<={sda_data_out[6:0],1'b0};
                        if(bit_cnt==0)begin
                            state<=ACK3;
                            sda_en<=1'b0;
                        end
                        else
                            state<=byte_ADDR_low;
                    end
                    else
                        state<=byte_ADDR_low;
                end

                ACK3:begin
                    if(scl_high_middle)begin
                        if(sda==1'b1)begin
                            if(w_flag)begin
                                sda_data_out<=write_data;
                                bit_cnt<=4'd8;
                                state<=w_data;
                            end
                            else if(r_flag)begin
                                sda_reg<=1'b1;
                                state<=r_start;
                            end
                        end
                        else
                            state<=ACK3;
                    end
                end

                w_data:begin
                    if(scl_low_middle)begin
                        sda_en<=1'b1;
                        bit_cnt<=bit_cnt-1'b1;
                        sda_reg<=sda_data_out[7];
                        sda_data_out<={sda_data_out[6:0],1'b0};
                        if(bit_cnt==0)begin
                            state<=ACK4;
                            sda_en<=1'b0;
                        end
                        else
                            state<=w_data;
                    end
                    else
                        state<=w_data;
                end

                ACK4:begin
                    if(scl_high_middle)begin
                        if(sda==1'b1)
                            state<=stop;
                        else
                            state<=idle;
                    end
                    else
                        state<=ACK4;
                end

                r_start:begin
                    if(scl_low_middle)begin
                        sda_en<=1'b1;
                    end
                    else if(scl_high_middle)begin
                        sda_reg<=1'b0;
                        state<=device_ADDR_r;
                        sda_data_out<={4'b1010,cs_bit,1'b1};
                        bit_cnt<=4'd8;
                    end
                    else begin
                        sda_reg<=1'b1;
                        state<=r_start;
                    end
                end

                device_ADDR_r:begin
                    if(scl_low_middle)begin
                        bit_cnt<=bit_cnt-1'b1;
                        sda_reg<=sda_data_out[7];
                        sda_data_out<={sda_data_out[6:0],1'b0};
                        if(bit_cnt==0)begin
                            state<=ACK5;
                            sda_en<=1'b0;
                        end
                        else
                            state<=device_ADDR_r;
                    end
                    else
                        state<=device_ADDR_r;
                end

                ACK5:begin
                    if(scl_high_middle)begin
                        if(sda==1'b1)begin
                            state<=r_data;
                            sda_en<=1'b0;
                            bit_cnt<=4'd8;
                        end
                        else
                            state<=idle;
                    end
                    else
                        state<=ACK5;
                end

                r_data:begin
                    if(scl_high_middle)begin
                        sda_data_in<={sda_data_in[6:0],sda};
                        bit_cnt<=bit_cnt-1'b1;
                        state<=r_data;
                    end
                    else if(scl_low_middle && bit_cnt==0)
                        state<=NACK;
                    else
                        state<=r_data;
                end

                NACK:begin
                    read_data<=sda_data_in;
                    if(scl_high_middle)begin
                        state<=stop;
                        sda_reg<=1'b0; //为什么这里要为0?因为你发现其他的应答位都是判断if(sda==1'b0)，而这里由于最后一个是主机发出的应答，而不是像之前那些是从机发出的。
                    end //也可以看出主机应答的是直接让output sda_reg为0，而前面的应答是等待从机input sda的值来判断应答位
                    else
                        state<=NACK;
                end

                stop:begin
                    if(scl_low_middle)begin
                        sda_en<=1'b1;
                        sda_reg<=1'b1;
                        state<=idle;
                        done<=1'b1;
                    end
                    else
                        state<=stop;
                end

                default:begin
                    state<=idle;
                    sda_en<=1'b0;
                    sda_reg<=1'b1;
                    w_flag<=1'b0;
                    r_flag<=1'b0;
                    done<=1'b0;
                end
            endcase
        end
    end




endmodule
