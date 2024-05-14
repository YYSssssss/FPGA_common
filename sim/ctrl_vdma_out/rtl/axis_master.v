`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 11:13:41 AM
// Design Name: 
// Module Name: axis_master
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


module axis_master #(
    parameter integer S_AXIS_TDATA_WIDTH    = 16'd64    ,
    parameter         VDMA_ROW	            = 32'd2160  , 
    parameter         VDMA_COLUMN           = 32'd3840  , 
    parameter         TLAST_DELAY_TIME      = 32'd100   , // >=1
    parameter         FRAME_START_TIME      = 32'd999   
)(
    input    wire                               s_axis_aclk         ,
    input    wire                               s_axis_aresetn      ,
    
    output   reg     [S_AXIS_TDATA_WIDTH-1:0]   s_axis_mm2s_tdata   ,
    output   wire                               s_axis_mm2s_tlast   ,
    input    wire                               s_axis_mm2s_tready  ,
    output   wire                               s_axis_mm2s_tuser   ,
    output   wire                               s_axis_mm2s_tvalid  
);

localparam  IDLE        =   3'd1;
localparam  FIRST_LAST  =   3'd2;
localparam  MIDDLE_LAST =   3'd3;
localparam  END_LAST    =   3'd4;
localparam  LAST_DELAY  =   3'd5;

reg     [2:0]   next_state      ;
reg     [2:0]   current_state   ;
reg     [0:0]   frame_start     ;
reg     [31:0]  cnt_tlast       ;
reg     [31:0]  cnt_cloumn      ;
reg     [31:0]  cnt_framestart_time ;
reg     [31:0]  cnt_tlast_time      ;

always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        current_state <= IDLE;
    end
    else begin
        current_state <= next_state;
    end
end

always @(*) begin
    if (!s_axis_aresetn) begin
        next_state <= IDLE;
    end
    else begin
        case(current_state)
            IDLE        : begin
                if (frame_start) begin
                    next_state <= FIRST_LAST;
                end
                else begin
                    next_state <= IDLE;
                end
            end
            FIRST_LAST  :begin
                if (s_axis_mm2s_tlast) begin
                    next_state <= LAST_DELAY;
                end
                else begin
                    next_state <= FIRST_LAST;
                end
            end
            MIDDLE_LAST :begin
                if (s_axis_mm2s_tlast) begin
                    next_state <= LAST_DELAY;
                end
                else begin
                    next_state <= MIDDLE_LAST;
                end
            end
            END_LAST    :begin
                if (s_axis_mm2s_tlast) begin
                    next_state <= IDLE;
                end
                else begin
                    next_state <= END_LAST;
                end
            end
            LAST_DELAY  :begin
                if (cnt_tlast_time == TLAST_DELAY_TIME - 1'b1) begin
                    if (cnt_tlast == VDMA_ROW - 1'b1) begin
                        next_state <= END_LAST;
                    end
                    else begin
                        next_state <= MIDDLE_LAST;
                    end
                end
                else begin
                    next_state <= LAST_DELAY;
                end
            end
            default     :begin
                next_state <= IDLE;
            end
        endcase
    end
end

always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin 
        frame_start <= 1'b0;
        cnt_framestart_time <= 32'd0;
        cnt_tlast_time <= 32'd0;
        cnt_cloumn <= 32'd0;
    end
    else begin
        case(current_state)
            IDLE        :begin
                if (cnt_framestart_time == FRAME_START_TIME) begin
                    cnt_framestart_time <= 32'd0;
                    frame_start <= 1'b1;
                end
                else begin
                    cnt_framestart_time <= cnt_framestart_time + 1'b1;
                    frame_start <= 1'b0;
                end
                cnt_tlast_time <= 32'd0;
            end
            FIRST_LAST,MIDDLE_LAST,END_LAST  :begin
                if ((s_axis_mm2s_tlast)&(s_axis_mm2s_tready & s_axis_mm2s_tvalid)) begin
                    cnt_cloumn <= 32'd0;
                end
                else if (s_axis_mm2s_tready & s_axis_mm2s_tvalid) begin
                    cnt_cloumn <= cnt_cloumn + 1'b1;
                end
                else begin
                    cnt_cloumn <= cnt_cloumn;
                end
                cnt_tlast_time <= 32'd0;
                cnt_framestart_time <= 32'd0;
            end
            LAST_DELAY  :begin
                cnt_tlast_time <= cnt_tlast_time + 1'b1;
            end
            default     :begin
                frame_start <= 1'b0;
                cnt_framestart_time <= 32'd0;
                cnt_tlast_time <= 32'd0;
                cnt_cloumn <= 32'd0;
            end
        endcase
    end
end

always @ (posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        cnt_tlast <= 32'd0;
    end
    else if (s_axis_mm2s_tuser) begin
        cnt_tlast <= 32'd0;
    end
    else if (s_axis_mm2s_tlast) begin
        cnt_tlast <= cnt_tlast + 1'b1;
    end
    else begin
        cnt_tlast <= cnt_tlast;
    end
end

always @ (posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        s_axis_mm2s_tdata <= 'd0;
    end
    else if (s_axis_mm2s_tready & s_axis_mm2s_tvalid) begin
        s_axis_mm2s_tdata <= s_axis_mm2s_tdata + 1'b1;
    end
    else begin
        s_axis_mm2s_tdata <= s_axis_mm2s_tdata;
    end
end


assign s_axis_mm2s_tlast = ((cnt_cloumn == (VDMA_COLUMN>>2'd2) -1'b1) & (s_axis_mm2s_tready & s_axis_mm2s_tvalid)) ? 1'b1 : 1'b0;
assign s_axis_mm2s_tuser = ((current_state == FIRST_LAST) & (cnt_cloumn == 1'b0) & (s_axis_mm2s_tready & s_axis_mm2s_tvalid)) ? 1'b1 : 1'b0;
assign s_axis_mm2s_tvalid = ((current_state == FIRST_LAST) || (current_state == MIDDLE_LAST) || (current_state == END_LAST)) ? 1'b1 : 1'b0;



endmodule
