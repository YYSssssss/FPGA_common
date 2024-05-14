`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/03 11:47:24
// Design Name: 
// Module Name: gen_framestart
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
// 0.1ms * num => framestart
//////////////////////////////////////////////////////////////////////////////////


module gen_framestart2 #(
    parameter CONFIG_CLK = 200
)(
    input                   clk                       ,
    input                   rst_n                     ,
//    input                   i_start                   ,
    input                   ps_framestart             ,
    input [15:0]            i_config_radar_num_100us  ,
    input [15:0]            i_config_radar_100us      ,
    input [15:0]            i_config_camera_num_100us ,
    input [15:0]            i_config_camera_100us     ,
    input [15:0]            i_config_ir_num_100us     ,
    input [15:0]            i_config_ir_100us         ,
    input [15:0]            i_config_cnt_fs_valid     ,
    output reg              o_radar_framestart        ,
    output reg              o_camera_framestart       ,
    output reg              o_ir_framestart           
);


    reg         i_radar_framestart_d1   ;
    reg         i_radar_framestart_d2   ;
    wire        radar_posedge           ;
    
    reg [31:0]  cnt_radar_period        ;  
 
assign radar_posedge = i_radar_framestart_d1 && (~i_radar_framestart_d2);
    
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        i_radar_framestart_d1 <= 1'b0;
        i_radar_framestart_d2 <= 1'b0;
    end
    else begin
//        i_radar_framestart_d1 <= i_radar_framestart;
        i_radar_framestart_d1 <= o_radar_framestart;
        i_radar_framestart_d2 <= i_radar_framestart_d1;
    end
end
    
    reg     start_en    ;
    
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        start_en <= 1'b0;
    end
    else begin
        if (ps_framestart)
            start_en <= 1'b1;
        else
            start_en <= start_en;
    end
end 
    
    wire    [9:0]   radar_valid     ;
    wire    [31:0]  camera_period   ;
    
assign radar_valid   = 10'd300      ;
assign camera_period = 32'd9_999_999;
    
//FSM 
    
    reg     [3:0]   next_state      ;
    reg     [3:0]   current_state   ;
    
    localparam IDLE_STATE   =   4'd0    ;
    localparam WAIT_STATE   =   4'd1    ;
    localparam TRAGGER_1    =   4'd2    ;
    localparam TRAGGER_2    =   4'd3    ;
    
    
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        current_state <= IDLE_STATE;
    else
        current_state <= next_state;
end

always @(*) begin
    if (!rst_n) begin
        next_state = IDLE_STATE;
    end
    else begin
        case(current_state)
            IDLE_STATE : begin
                if (start_en)
                    next_state = WAIT_STATE;
                else
                    next_state = IDLE_STATE;
            end
            WAIT_STATE : begin
                if (radar_posedge)
                    next_state = TRAGGER_1;
                else
                    next_state = WAIT_STATE;
            end
            TRAGGER_1  : begin
                if (cnt_radar_period == camera_period)
                    next_state = TRAGGER_2;
                else
                    next_state = TRAGGER_1;
            end
            TRAGGER_2  : begin
                if (cnt_radar_period == camera_period + radar_valid)
                    next_state = WAIT_STATE;
                else
                    next_state = TRAGGER_2;
            end
            default    : begin
                next_state = IDLE_STATE;
            end
        endcase
    end    
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        o_camera_framestart <= 1'b0;
        o_ir_framestart     <= 1'b0;
        cnt_radar_period    <= 32'd0;
    end
    else begin
        case(current_state)
            IDLE_STATE,WAIT_STATE : begin
                o_camera_framestart <= 1'b0;
                o_ir_framestart     <= 1'b0;
                cnt_radar_period    <= 32'd0;
            end
            TRAGGER_1 : begin
                cnt_radar_period <= cnt_radar_period + 1'b1;
                if ((cnt_radar_period >= 1) && (cnt_radar_period < radar_valid)) begin
                    o_camera_framestart <= 1'b1;
                    o_ir_framestart     <= 1'b1;
                end
                else begin
                    o_camera_framestart <= 1'b0;
                    o_ir_framestart     <= 1'b0;
                end
            end
            TRAGGER_2 : begin
                cnt_radar_period <= cnt_radar_period + 1'b1;
                if ((cnt_radar_period >= camera_period) && (cnt_radar_period < (camera_period + radar_valid))) begin
                    o_camera_framestart <= 1'b1;
                    o_ir_framestart     <= 1'b1;
                end
                else begin
                    o_camera_framestart <= 1'b0;
                    o_ir_framestart     <= 1'b0;
                end
            end
            default   : begin
                o_camera_framestart <= 1'b0;
                o_ir_framestart     <= 1'b0;
                cnt_radar_period    <= 32'd0;
            end
        endcase 
    end
end

 
 




// ila_framestart u_ila_framestart(
// .clk(clk),
// .probe0(i_radar_framestart),
// .probe1(o_camera_framestart),
// .probe2(o_ir_framestart),
// .probe3(radar_posedge),
// .probe4(cnt_radar_period)
// );




//jade
/////////////////////////// reg & wire ////////////////////////////
reg        o_radar_framestart;
reg [15:0] cnt_radar_us;
reg [15:0] cnt_radar_us_num;
reg [15:0] cnt_radar_fs_valid;

//radar
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_radar_us <= 0;
	else if(ps_framestart) begin
//		if (cnt_radar_us == i_config_radar_100us - 1) begin
		if (cnt_radar_us == 16'd30000 - 1) begin
			cnt_radar_us <= 0;
		end
		else begin
			cnt_radar_us <= cnt_radar_us + 1'b1;
		end
	end
	else begin
		cnt_radar_us <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_radar_us_num <= 0;
	else if(ps_framestart) begin
//	    if (cnt_radar_us_num == i_config_radar_num_100us - 1  && cnt_radar_us == i_config_radar_100us - 1) begin
	    if (cnt_radar_us_num == 16'd660 - 1  && cnt_radar_us == 16'd30000 - 1) begin
	    	cnt_radar_us_num <= 0;
	    end
//	    else if(cnt_radar_us == i_config_radar_100us - 1) begin
	    else if(cnt_radar_us == 16'd30000 - 1) begin
	    	cnt_radar_us_num <= cnt_radar_us_num + 1'b1;
	    end
	    else begin
	        cnt_radar_us_num <= cnt_radar_us_num;
	    end
	end
	else begin
		cnt_radar_us_num <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_radar_fs_valid <= 0;
	else if(o_radar_framestart) begin
		if (cnt_radar_fs_valid == 16'd300 - 1) begin
			cnt_radar_fs_valid <= 0;
		end
		else begin
			cnt_radar_fs_valid <= cnt_radar_fs_valid + 1'b1;
		end
	end
	else begin
		cnt_radar_fs_valid <= 0;
	end
end

//radar
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		o_radar_framestart <= 0;
	else begin
		if (cnt_radar_fs_valid == i_config_cnt_fs_valid - 1) begin
			o_radar_framestart <= 0;
		end
//		else if(cnt_radar_us_num == i_config_radar_num_100us - 1  && cnt_radar_us == i_config_radar_100us - 1) begin
		else if(cnt_radar_us_num == 16'd660 - 1  && cnt_radar_us == 16'd30000 - 1) begin
			o_radar_framestart <= 1'b1;
		end
		else begin
		    o_radar_framestart <= o_radar_framestart;
		end
	end
end
    
    
endmodule
