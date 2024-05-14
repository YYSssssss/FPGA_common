`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/11 15:54:07
// Design Name: 
// Module Name: mipi_1lane_yuv422
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


module mipi_1lane_yuv422(

    input                           clk_byte    ,     
    input                           clk_pix     ,      
    input                           rst_n       ,        
                                   
    input   [7:0]                   byte_data0  ,    
    input                           rxsync_hs0  ,    
    input                           rxvalid_hs0 ,  
	
	output reg                         yuv_fv   ,
	output                             yuv_lv   ,
	output  [31:0]                     yuv_data   
);
	
	
(*mark_debug = "true"*)reg rxsync_hs0_r;
(*mark_debug = "true"*)reg[7:0] byte0_dly1;
(*mark_debug = "true"*)reg[7:0] dt;
(*mark_debug = "true"*)reg[15:0] byte_cnt;
(*mark_debug = "true"*)reg[15:0] v_cnt_byte;
(*mark_debug = "true"*)reg[3:0] rxvalid_hs_dly;

reg[7:0] c_data,y_data;


(*mark_debug = "true"*)reg wr_en;
(*mark_debug = "true"*)wire rd_en;
reg rd_ready;
(*mark_debug = "true"*)wire prog_empty,empty;
(*mark_debug = "true"*)wire prog_full,full;
(*mark_debug = "true"*)wire[31:0] dout;
(*mark_debug = "true"*)reg[7:0] dt_sync;

always @( posedge clk_byte )rxsync_hs0_r <= rxsync_hs0;

always @( posedge clk_byte )begin
	rxvalid_hs_dly <= { rxvalid_hs_dly[2:0],rxvalid_hs0 };
end


always @( posedge clk_byte )begin
    byte0_dly1<=byte_data0;
end

    
always @(posedge clk_byte) begin
    if(!rst_n) begin
        dt <= 'd0;
        byte_cnt <= 'd0;
    end
    else begin
        if(rxsync_hs0_r)
            dt <= byte_data0;
            
        if(rxvalid_hs0)
            byte_cnt <= byte_cnt + 1'b1;
        else
            byte_cnt <= 'd0;
    end
end

always @(posedge clk_byte ) begin
    if(!rst_n) begin
        v_cnt_byte <= 'd0;
    end
    else begin
        if(rxvalid_hs_dly[1:0]==2'b01) begin
            if(dt==8'h1e)
                v_cnt_byte <= v_cnt_byte + 1'b1;
            else if(dt==8'd0)
                v_cnt_byte <= 'd0;
        end
        
    end
end

always @( posedge clk_byte )begin
	if(  !rst_n )begin
		y_data <= 8'b0;
		c_data <= 8'b0;
	end
	else if(dt==8'h1e && rxvalid_hs_dly[1] )begin
		case( byte_cnt[0] )
			1'b0:begin
				c_data <= byte_data0;
				y_data <= y_data;
			end
			1'b1:begin
				c_data <= c_data;
				y_data <= byte_data0;
			end
		endcase
		
	end
end
		
always @( posedge clk_byte )begin
	if( !rst_n )
		wr_en <= 1'b0;
	else if( dt==8'h1e && rxvalid_hs_dly[1] )begin
		if(byte_cnt[0] && byte_cnt<16'h502 && v_cnt_byte<481 )
			wr_en <= 1'b1;
	    else
			wr_en <= 1'b0;
	end
    else 
		wr_en <= 1'b0;
end

fifo_16X16_1024FULL fifo_16X16_1024FULL_inst (
  .rst(1'b0),                              // input wire rst
  .wr_clk(clk_byte),                        // input wire wr_clk
  .rd_clk(clk_pix),                        // input wire rd_clk
  .din({c_data,y_data}),                              // input wire [15 : 0] din
  .wr_en(wr_en),                          // input wire wr_en
  .rd_en(rd_en),                          // input wire rd_en
  .prog_empty_thresh(300),  // input wire [9 : 0] prog_empty_thresh
  .prog_full_thresh(1023),    // input wire [9 : 0] prog_full_thresh
  .dout(dout),                            // output wire [15 : 0] dout
  .full(full),                            // output wire full
  .empty(empty),                          // output wire empty
  .prog_full(prog_full),                  // output wire prog_full
  .prog_empty(prog_empty)                // output wire prog_empty
);



always @( posedge clk_pix )begin
	if( !rst_n )begin
		rd_ready <= 1'b0;
	end
	else if( empty )begin
		rd_ready <= 1'b0;
	end
	else if( !prog_empty )begin
		rd_ready <= 1'b1;
	end
end


assign rd_en = rd_ready ? ( empty ? 1'b0 : 1'b1 ) : 1'b0;




assign yuv_lv = rd_en;
assign yuv_data = { dout[15:0],dout[31:16] };

always @( posedge clk_pix ) dt_sync <= dt;


always @( posedge clk_pix )begin
	if( !rst_n )
		yuv_fv <= 1'b0;
    else if( dt_sync==8'b00 )
		yuv_fv <= 1'b1;
    else if( dt_sync==8'b01 )
		yuv_fv <= 1'b0;
end	
	
	
endmodule
