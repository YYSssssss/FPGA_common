`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/26/2024 02:32:59 PM
// Design Name: 
// Module Name: Ctrl_vdma_out
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


module Ctrl_vdma_out 
#(
    parameter   VEDIO_COLUMN = 3840 ,      
    parameter   VEDIO_ROW    = 2320        
)
(
    input   wire            s_axis_aclk         ,
    input   wire            s_axis_aresetn      ,
    
    input   wire    [31:0]  vdma_column         ,
    input   wire    [31:0]  vdma_row            ,
    input   wire    [31:0]  tlast_time          ,
    input   wire    [31:0]  frame_end_time      ,
    
    input   wire    [63:0]  s_axis_mm2s_tdata   ,
//    input   wire    [7:0]   s_axis_mm2s_tkeep   ,
    input   wire            s_axis_mm2s_tlast   ,
    output  wire            s_axis_mm2s_tready  ,
    input   wire            s_axis_mm2s_tuser   ,
    input   wire            s_axis_mm2s_tvalid  ,
    
    
    output  wire    [63:0]  m_axis_mm2s_tdata   ,
//    output  wire    [7:0]   m_axis_mm2s_tkeep   ,
    output  reg             m_axis_mm2s_tlast   ,
    input   wire            m_axis_mm2s_tready  ,
    output  wire            m_axis_mm2s_tuser   ,
    output  wire            m_axis_mm2s_tvalid      
);

reg             frame_end_en    ;
reg     [31:0]  cnt_frame_time  ;
reg     [15:0]  cnt_tlast       ;
reg             tlast_en        ;
reg     [31:0]  cnt_tlast_time  ;
reg     [15:0]  cnt_vdma_cloumn ;

//delay frame_end
always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        cnt_tlast <= 16'd0;
    end
    else if (m_axis_mm2s_tuser) begin
        cnt_tlast <= 16'd0;
    end
    else if (m_axis_mm2s_tlast) begin
        cnt_tlast <= cnt_tlast + 1'b1;
    end
    else begin
        cnt_tlast <= cnt_tlast;
    end
end

always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        frame_end_en <= 1'b0;
    end
    else if ((cnt_tlast == vdma_row - 1'b1)&&(m_axis_mm2s_tlast)) begin
        frame_end_en <= 1'b1;
    end
    else if (cnt_frame_time == frame_end_time) begin
        frame_end_en <= 1'b0;
    end
    else begin
        frame_end_en <= frame_end_en;
    end
end

always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        cnt_frame_time <= 32'd0;
    end
    else if (frame_end_en == 1'b0) begin
        cnt_frame_time <= 32'd0;
    end
    else begin
        cnt_frame_time <= cnt_frame_time + 1'b1;
    end
end


//delay tlast
always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        tlast_en <= 1'b0;
    end
    else if (m_axis_mm2s_tlast == 1'b1) begin
        tlast_en <= 1'b1;
    end
    else if (cnt_tlast_time == tlast_time) begin
        tlast_en <= 1'b0;
    end
    else begin
        tlast_en <= tlast_en;
    end
end

always @(posedge s_axis_aclk or negedge s_axis_aresetn) begin
    if (!s_axis_aresetn) begin
        cnt_tlast_time <= 32'd0;
    end
    else if (tlast_en == 1'b0) begin
        cnt_tlast_time <= 32'd0;
    end
    else begin
        cnt_tlast_time <= cnt_tlast_time + 1'b1;
    end
end

wire            m_axis_tvalid       ;
wire            m_axis_tready       ;
wire            s_axis_tready       ;
wire [71 : 0]   m_axis_tdata        ;
wire [31 : 0]   axis_wr_data_count  ;
wire [31 : 0]   axis_rd_data_count  ;
wire            almost_empty        ;
wire            almost_full         ;
wire            prog_full         ;


reg  s_axis_mm2s_tuser_d0;
reg  s_axis_mm2s_tuser_d1;
reg  s_axis_mm2s_tuser_d2;
reg  frame_start;
reg  tlast_en_d0;
reg  tlast_en_d1;
wire tlast_en_neg;
reg [15:0] cnt_vdma_column;
reg [15:0] cnt_vdma_row;

always@(posedge s_axis_aclk  or negedge s_axis_aresetn)begin
    if(!s_axis_aresetn)begin
        cnt_vdma_column <= 0;
    end
    else begin
        if(s_axis_mm2s_tuser == 1'b1 || s_axis_mm2s_tlast == 1'b1)
            cnt_vdma_column <= 0;
        else if(s_axis_mm2s_tvalid & s_axis_mm2s_tready)
            cnt_vdma_column <= cnt_vdma_column + 1'b1;
    end
end

always@(posedge s_axis_aclk or negedge s_axis_aresetn)begin
    if(!s_axis_aresetn)begin
        cnt_vdma_row <= 0;
    end
    else begin
        if(s_axis_mm2s_tuser == 1'b1)begin
            cnt_vdma_row <= 0;
        end
        else if((cnt_vdma_column == vdma_column - 1) && (s_axis_mm2s_tlast == 1'b1))
            cnt_vdma_row <= cnt_vdma_row + 1'b1;
    end
end

always@(posedge s_axis_aclk  or negedge s_axis_aresetn)begin
    if(!s_axis_aresetn)begin
        s_axis_mm2s_tuser_d0 <= 0;
        s_axis_mm2s_tuser_d1 <= 0;
        s_axis_mm2s_tuser_d2 <= 0;
        tlast_en_d0 <= 0;
        tlast_en_d1 <= 0;
    end
    else begin
        s_axis_mm2s_tuser_d0 <= s_axis_mm2s_tuser;
        s_axis_mm2s_tuser_d1 <= s_axis_mm2s_tuser_d0;
        s_axis_mm2s_tuser_d2 <= s_axis_mm2s_tuser_d1;
        tlast_en_d0 <= tlast_en;
        tlast_en_d1 <= tlast_en_d0;
    end
end

assign tlast_en_neg = ~tlast_en_d0 & tlast_en_d1;

assign s_axis_mm2s_tready = s_axis_tready & (!prog_full);

axis_data_fifo_vdma_0ut u_axis_data_fifo_vdma_0ut (
  .s_axis_aresetn   (s_axis_aresetn ),          // input wire s_axis_aresetn
  .s_axis_aclk      (s_axis_aclk    ),                // input wire s_axis_aclk

  .s_axis_tvalid    (s_axis_mm2s_tvalid & s_axis_mm2s_tready ),            // input wire s_axis_tvalid
  .s_axis_tready    (s_axis_tready      ),            // output wire s_axis_tready
  .s_axis_tdata     ({7'd0,s_axis_mm2s_tuser,s_axis_mm2s_tdata}),              // input wire [71 : 0] s_axis_tdata
  
  .m_axis_tvalid    (m_axis_tvalid  ),              // output wire m_axis_tvalid
  .m_axis_tready    (m_axis_tready & m_axis_mm2s_tready  ),              // input  wire m_axis_tready
  .m_axis_tdata     (m_axis_tdata   ),              // output wire [71 : 0] m_axis_tdata
  
  .axis_wr_data_count (axis_wr_data_count),  // output wire [31 : 0] axis_wr_data_count
  .axis_rd_data_count (axis_rd_data_count),  // output wire [31 : 0] axis_rd_data_count
  .almost_empty       (almost_empty),              // output wire almost_empty
  .almost_full        (almost_full),                 // output wire almost_full
  .prog_full          (prog_full)
);


always@(posedge s_axis_aclk  or negedge s_axis_aresetn)begin
    if(!s_axis_aresetn)begin
        frame_start <= 0;
    end
    else begin
        if(s_axis_mm2s_tuser_d2 == 1'b1 || tlast_en_neg == 1'b1)
            frame_start <= 1;
        else if( (m_axis_mm2s_tvalid & m_axis_mm2s_tready) && (cnt_vdma_cloumn == 16'd959) )
            frame_start <= 0;
    end
end

assign m_axis_tready = frame_start;




assign m_axis_mm2s_tdata  = m_axis_tdata[63:0];
assign m_axis_mm2s_tuser  = m_axis_tdata[64] & m_axis_mm2s_tvalid;
assign m_axis_mm2s_tvalid = m_axis_tvalid;

always@(posedge s_axis_aclk  or negedge s_axis_aresetn)begin
    if(!s_axis_aresetn)begin
        cnt_vdma_cloumn <= 0;
    end
    else begin
        if(m_axis_mm2s_tlast == 1'b1)
            cnt_vdma_cloumn <= 0;
        else if(m_axis_mm2s_tvalid & m_axis_tready & m_axis_mm2s_tready)
            cnt_vdma_cloumn <= cnt_vdma_cloumn + 1'b1;
    end
end


always@(posedge s_axis_aclk)begin
    if(!s_axis_aresetn)begin
        m_axis_mm2s_tlast <= 0;
    end
    else begin
        if((m_axis_mm2s_tvalid & m_axis_tready & m_axis_mm2s_tready)&&(cnt_vdma_cloumn == 16'd958))
            m_axis_mm2s_tlast <= 1'b1;
        else
            m_axis_mm2s_tlast <= 1'b0;
    end
end




//ila_vdma_ctrl u_ila_vdma_ctrl (
//	.clk(s_axis_aclk), // input wire clk


//	.probe0(vdma_row      ), // input wire [31:0]  probe0  
//	.probe1(tlast_time    ), // input wire [31:0]  probe1 
//	.probe2(frame_end_time), // input wire [31:0]  probe2 
//	.probe3(s_axis_mm2s_tdata), // input wire [63:0]  probe3 
//	.probe4(s_axis_mm2s_tlast ), // input wire [0:0]  probe4 
//	.probe5(s_axis_mm2s_tready), // input wire [0:0]  probe5 
//	.probe6(s_axis_mm2s_tuser ), // input wire [0:0]  probe6 
//	.probe7(s_axis_mm2s_tvalid), // input wire [0:0]  probe7 
//	.probe8(m_axis_mm2s_tdata), // input wire [63:0]  probe8 
//	.probe9( m_axis_mm2s_tlast ), // input wire [0:0]  probe9 
//	.probe10(m_axis_mm2s_tready), // input wire [0:0]  probe10 
//	.probe11(m_axis_mm2s_tuser ), // input wire [0:0]  probe11 
//	.probe12(m_axis_mm2s_tvalid), // input wire [0:0]  probe12 
//	.probe13(frame_end_en  ), // input wire [0:0]  probe13 
//	.probe14(cnt_frame_time), // input wire [31:0]  probe14 
//	.probe15(cnt_tlast     ), // input wire [15:0]  probe15 
//	.probe16(tlast_en      ), // input wire [0:0]  probe16 
//	.probe17(cnt_tlast_time), // input wire [31:0]  probe17 
//	.probe18(m_axis_tvalid     ), // input wire [0:0]  probe18 
//	.probe19(m_axis_tready     ), // input wire [0:0]  probe19 
//	.probe20(m_axis_tdata      ), // input wire [71:0]  probe20 
//	.probe21(m_axis_tlast      ), // input wire [0:0]  probe21 
//	.probe22(axis_wr_data_count), // input wire [31:0]  probe22 
//	.probe23(axis_rd_data_count), // input wire [31:0]  probe23 
//	.probe24(almost_empty      ), // input wire [0:0]  probe24 
//	.probe25(almost_full       ), // input wire [0:0]  probe25
//	.probe26(cnt_vdma_cloumn       ) // input wire [15:0]  probe26
//);


endmodule
