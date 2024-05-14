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


module gen_framestart #(
    parameter CONFIG_CLK = 300
)(
    input                   clk                       ,
    input                   rst_n                     ,
    input                   i_start                   ,
    input [15:0]            i_config_radar_num_100us  , //333
    input [15:0]            i_config_radar_100us      , //3.33ns * 30000
    input [15:0]            i_config_camera_num_100us , //333
    input [15:0]            i_config_camera_100us     , //3.33ns * 30000
    input [15:0]            i_config_ir_num_100us     , //333
    input [15:0]            i_config_ir_100us         , //3.33ns * 30000
    input [15:0]            i_config_cnt_fs_valid     , //3.33ns * 300
    output reg              o_radar_framestart        ,
    output reg              o_camera_framestart       ,
    output reg              o_ir_framestart           
);


/////////////////////////// localparam ////////////////////////////


/////////////////////////// reg & wire ////////////////////////////
reg [15:0] cnt_radar_us;
reg [15:0] cnt_radar_us_num;
reg [15:0] cnt_radar_fs_valid;
reg [15:0] cnt_camera_us;
reg [15:0] cnt_camera_us_num;
reg [15:0] cnt_camera_fs_valid;
reg [15:0] cnt_ir_us;
reg [15:0] cnt_ir_us_num;
reg [15:0] cnt_ir_fs_valid;

/////////////////////////// assign     ////////////////////////////


/////////////////////////// main     ////////////////////////////
//radar
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_radar_us <= 0;
	else if(i_start) begin
		if (cnt_radar_us == i_config_radar_100us - 1) begin
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
	else if(i_start) begin
	    if (cnt_radar_us_num == i_config_radar_num_100us - 1  && cnt_radar_us == i_config_radar_100us - 1) begin
	    	cnt_radar_us_num <= 0;
	    end
	    else if(cnt_radar_us == i_config_radar_100us - 1) begin
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
		if (cnt_radar_fs_valid == i_config_cnt_fs_valid - 1) begin
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

//camera
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_camera_us <= 0;
	else if(i_start) begin
		if (cnt_camera_us == i_config_camera_100us - 1) begin
			cnt_camera_us <= 0;
		end
		else begin
			cnt_camera_us <= cnt_camera_us + 1'b1;
		end
	end
	else begin
		cnt_camera_us <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_camera_us_num <= 0;
	else if(i_start) begin
	    if (cnt_camera_us_num == i_config_camera_num_100us - 1 && cnt_camera_us == i_config_camera_100us - 1) begin
	    	cnt_camera_us_num <= 0;
	    end
	    else if(cnt_camera_us == i_config_camera_100us - 1) begin
	    	cnt_camera_us_num <= cnt_camera_us_num + 1'b1;
	    end
	    else begin
	        cnt_camera_us_num <= cnt_camera_us_num;
	    end
	end
	else begin
		cnt_camera_us_num <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_camera_fs_valid <= 0;
	else if(o_camera_framestart) begin
		if (cnt_camera_fs_valid == i_config_cnt_fs_valid - 1) begin
			cnt_camera_fs_valid <= 0;
		end
		else begin
			cnt_camera_fs_valid <= cnt_camera_fs_valid + 1'b1;
		end
	end
	else begin
		cnt_camera_fs_valid <= 0;
	end
end

//ir
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_ir_us <= 0;
	else if(i_start) begin
		if (cnt_ir_us == i_config_ir_100us - 1) begin
			cnt_ir_us <= 0;
		end
		else begin
			cnt_ir_us <= cnt_ir_us + 1'b1;
		end
	end
	else begin
		cnt_ir_us <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_ir_us_num <= 0;
	else if(i_start) begin
	    if (cnt_ir_us_num == i_config_ir_num_100us - 1 && cnt_ir_us == i_config_ir_100us - 1) begin
	    	cnt_ir_us_num <= 0;
	    end
	    else if(cnt_ir_us == i_config_ir_100us - 1) begin
	    	cnt_ir_us_num <= cnt_ir_us_num + 1'b1;
	    end
	    else begin
	        cnt_ir_us_num <= cnt_ir_us_num;
	    end
	end
	else begin
		cnt_ir_us_num <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		cnt_ir_fs_valid <= 0;
	else if(o_ir_framestart) begin
		if (cnt_ir_fs_valid == i_config_cnt_fs_valid - 1) begin
			cnt_ir_fs_valid <= 0;
		end
		else begin
			cnt_ir_fs_valid <= cnt_ir_fs_valid + 1'b1;
		end
	end
	else begin
		cnt_ir_fs_valid <= 0;
	end
end

/////////////////////////// output     ////////////////////////////
//radar
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		o_radar_framestart <= 0;
	else begin
		if (cnt_radar_fs_valid == i_config_cnt_fs_valid - 1) begin
			o_radar_framestart <= 0;
		end
		else if(cnt_radar_us_num == i_config_radar_num_100us - 1  && cnt_radar_us == i_config_radar_100us - 1) begin
			o_radar_framestart <= 1'b1;
		end
		else begin
		    o_radar_framestart <= o_radar_framestart;
		end
	end
end

//camera
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		o_camera_framestart <= 0;
	else begin
		if (cnt_camera_fs_valid == i_config_cnt_fs_valid - 1) begin
			o_camera_framestart <= 0;
		end
		else if(cnt_camera_us_num == i_config_camera_num_100us - 1 && cnt_camera_us == i_config_camera_100us - 1) begin
			o_camera_framestart <= 1'b1;
		end
		else begin
		    o_camera_framestart <= o_camera_framestart;
		end
	end
end

//ir
always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		o_ir_framestart <= 0;
	else begin
		if (cnt_ir_fs_valid == i_config_cnt_fs_valid - 1) begin
			o_ir_framestart <= 0;
		end
		else if(cnt_ir_us_num == i_config_ir_num_100us - 1 && cnt_ir_us == i_config_ir_100us - 1) begin
			o_ir_framestart <= 1'b1;
		end
		else begin
		    o_ir_framestart <= o_ir_framestart;
		end
	end
end
    
endmodule
