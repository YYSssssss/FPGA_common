`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 03:42:12 PM
// Design Name: 
// Module Name: tb_axis_master
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


module tb_axis_master();

reg                                s_axis_aclk         ;
reg                                s_axis_aresetn      ;

wire    [63:0]                     s_axis_mm2s_tdata   ;
wire                               s_axis_mm2s_tlast   ;
reg                                s_axis_mm2s_tready  ;
wire                               s_axis_mm2s_tuser   ;
wire                               s_axis_mm2s_tvalid  ;

initial begin
    s_axis_aclk <= 1'b0;
    s_axis_aresetn <= 1'b0;
    s_axis_mm2s_tready <= 1'b0;
    #100 
    s_axis_aresetn <= 1'b1;
    #1000
    s_axis_mm2s_tready <= 1'b1;
end

always begin
    #2
    s_axis_aclk <= 1'b1;
    #2 
    s_axis_aclk <= 1'b0;
end

axis_master #(
    . S_AXIS_TDATA_WIDTH    ( 16'd64   ) ,
    . VDMA_ROW	            ( 32'd2160 ) , 
    . VDMA_COLUMN           ( 32'd3840 ) ,
    . TLAST_DELAY_TIME      ( 32'd100  ) , // >=1
    . FRAME_START_TIME      ( 32'd999  ) 
)u_axis_master
(
    . s_axis_aclk         ( s_axis_aclk        ),
    . s_axis_aresetn      ( s_axis_aresetn     ),

    . s_axis_mm2s_tdata   ( s_axis_mm2s_tdata  ),
    . s_axis_mm2s_tlast   ( s_axis_mm2s_tlast  ),
    . s_axis_mm2s_tready  ( s_axis_mm2s_tready ),
    . s_axis_mm2s_tuser   ( s_axis_mm2s_tuser  ),
    . s_axis_mm2s_tvalid  ( s_axis_mm2s_tvalid )
);

endmodule
