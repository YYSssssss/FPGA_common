`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/11/2024 04:47:33 PM
// Design Name: 
// Module Name: tb_vdma_ctrl_v2
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


module tb_vdma_ctrl_v2();

reg                                s_axis_aclk         ;
reg                                s_axis_aresetn      ;

wire    [63:0]                     s_axis_mm2s_tdata   ;
wire                               s_axis_mm2s_tlast   ;
wire                               s_axis_mm2s_tready  ;
wire                               s_axis_mm2s_tuser   ;
wire                               s_axis_mm2s_tvalid  ;

wire    [63:0]                     m_axis_mm2s_tdata   ;
wire                               m_axis_mm2s_tlast   ;
reg                                m_axis_mm2s_tready  ;
wire                               m_axis_mm2s_tuser   ;
wire                               m_axis_mm2s_tvalid  ;

initial begin
    s_axis_aclk <= 1'b0;
    s_axis_aresetn <= 1'b0;
    m_axis_mm2s_tready <= 1'b0;
    #100 
    s_axis_aresetn <= 1'b1;
    #1000 
    m_axis_mm2s_tready <= 1'b1;
end

always begin
    #2
    s_axis_aclk <= 1'b1;
    #2 
    s_axis_aclk <= 1'b0;
end

axis_master #(
    . S_AXIS_TDATA_WIDTH    ( 16'd64   ) ,
    . VDMA_ROW	            ( 32'd2320 ) , 
    . VDMA_COLUMN           ( 32'd3840 ) ,
    . TLAST_DELAY_TIME      ( 32'd1    ) , // >=1
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

//Ctrl_vdma_out u_Ctrl_vdma_out
vdma_ctrl_v2 u_vdma_ctrl_v2
(
    . s_axis_aclk        (s_axis_aclk       ) ,
    . s_axis_aresetn     (s_axis_aresetn    ) ,
    
    . vdma_row           (32'd2320          ) ,//(32'd2320  ) ,//(16'd2320          ) ,//5ns
    . tlast_time         (32'd2299          ) ,//(32'd19    ) ,//(16'd1912          ) ,
    . frame_end_time     (32'd772432        ) ,//(32'd6059752),//(16'd3218          ) ,

    . s_axis_mm2s_tdata  (s_axis_mm2s_tdata ) ,
    . s_axis_mm2s_tlast  (s_axis_mm2s_tlast ) ,
    . s_axis_mm2s_tready (s_axis_mm2s_tready) ,
    . s_axis_mm2s_tuser  (s_axis_mm2s_tuser ) ,
    . s_axis_mm2s_tvalid (s_axis_mm2s_tvalid) ,

    . m_axis_mm2s_tdata  (m_axis_mm2s_tdata ) ,
    . m_axis_mm2s_tlast  (m_axis_mm2s_tlast ) ,
    . m_axis_mm2s_tready (m_axis_mm2s_tready) ,
    . m_axis_mm2s_tuser  (m_axis_mm2s_tuser ) ,
    . m_axis_mm2s_tvalid (m_axis_mm2s_tvalid)     
);

endmodule
