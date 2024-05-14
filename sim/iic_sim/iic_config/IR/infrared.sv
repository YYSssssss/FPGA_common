`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/06/28 17:22:28
// Design Name: 
// Module Name: infrared
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


module infrared(
  input core_clk,
  //input core_rst,
  input pix_clk, // 200M
  
  input clk_10m,
  input rst_n, //10M
  

//input         mipi_phy_if_0_clk_p  ,
//input         mipi_phy_if_0_clk_n  ,
//input  [1:0]  mipi_phy_if_0_data_p ,
//input  [1:0]  mipi_phy_if_0_data_n ,

//output to ddr
//output  o_ddr_fv,
//output  o_ddr_lv,
//output  [31:0]o_ddr_data,

  inout iic_0_scl_io,
  inout iic_0_sda_io,
  output gpio_tri_io
);

reg[5:0] rst_cnt;
wire    rxbyteclkhs;
wire    clkoutphy_out;
wire    pll_lock_out;
wire    init_done;
wire    cl_stopstate;
wire    dl0_stopstate  ,  dl1_stopstate;
wire[7:0] dl0_rxdatahs,dl1_rxdatahs;
wire    dl0_rxvalidhs,dl1_rxvalidhs;
wire    dl0_rxactivehs,dl1_rxactivehs;
wire    dl0_rxsynchs,dl1_rxsynchs; 
wire                          yuv_fv   ;
wire                          yuv_lv   ;
wire  [31:0]                  yuv_data ;  

reg core_rst;



always @( posedge core_clk or negedge rst_n)
begin
    if( ~rst_n )begin
        rst_cnt<=6'b0;
        core_rst<=1'b1;
    end
    else if( &rst_cnt )begin
        rst_cnt<=rst_cnt;
        core_rst<=1'b0;
    end else begin
        rst_cnt<=rst_cnt+1'b1;
        core_rst<=core_rst;
    end
end
 
// mipi_dphy_0 mipi_dphy_inst (
//  .core_clk(core_clk),                    // input wire core_clk
//  .core_rst(core_rst),                    // input wire core_rst
//  .rxbyteclkhs(rxbyteclkhs),              // output wire rxbyteclkhs
//  .clkoutphy_out(clkoutphy_out),          // output wire clkoutphy_out
//  .pll_lock_out(pll_lock_out),            // output wire pll_lock_out
//  .system_rst_out(system_rst_out),        // output wire system_rst_out
//  .init_done(init_done),                  // output wire init_done
//  .cl_stopstate(cl_stopstate),            // output wire cl_stopstate
//  .cl_enable(1'b1),                  // input wire cl_enable
//  .cl_ulpsactivenot(),    // output wire cl_ulpsactivenot
//  .dl0_stopstate(dl0_stopstate),          // output wire dl0_stopstate
//  .dl0_enable(1'b1),                // input wire dl0_enable
//  .dl0_ulpsactivenot(),  // output wire dl0_ulpsactivenot
//  .dl1_stopstate(dl1_stopstate),          // output wire dl1_stopstate
//  .dl1_enable(1'b1),                // input wire dl1_enable
//  .dl1_ulpsactivenot(),  // output wire dl1_ulpsactivenot
//  .dl0_rxdatahs(dl0_rxdatahs),            // output wire [7 : 0] dl0_rxdatahs
//  .dl0_rxvalidhs(dl0_rxvalidhs),          // output wire dl0_rxvalidhs
//  .dl0_rxactivehs(dl0_rxactivehs),        // output wire dl0_rxactivehs
//  .dl0_rxsynchs(dl0_rxsynchs),            // output wire dl0_rxsynchs
//  .dl0_forcerxmode(1'b0),      // input wire dl0_forcerxmode
//  .dl0_rxclkesc(),            // output wire dl0_rxclkesc
//  .dl0_rxlpdtesc(),          // output wire dl0_rxlpdtesc
//  .dl0_rxulpsesc(),          // output wire dl0_rxulpsesc
//  .dl0_rxtriggeresc(),    // output wire [3 : 0] dl0_rxtriggeresc
//  .dl0_rxdataesc(),          // output wire [7 : 0] dl0_rxdataesc
//  .dl0_rxvalidesc(),        // output wire dl0_rxvalidesc
//  .dl0_errsoths(),            // output wire dl0_errsoths
//  .dl0_errsotsynchs(),    // output wire dl0_errsotsynchs
//  .dl0_erresc(),                // output wire dl0_erresc
//  .dl0_errsyncesc(),        // output wire dl0_errsyncesc
//  .dl0_errcontrol(),        // output wire dl0_errcontrol
//  .dl1_rxdatahs(dl1_rxdatahs),            // output wire [7 : 0] dl1_rxdatahs
//  .dl1_rxvalidhs(dl1_rxvalidhs),          // output wire dl1_rxvalidhs
//  .dl1_rxactivehs(dl1_rxactivehs),        // output wire dl1_rxactivehs
//  .dl1_rxsynchs(dl1_rxsynchs),            // output wire dl1_rxsynchs
//  .dl1_forcerxmode(1'b0),      // input wire dl1_forcerxmode
//  .dl1_rxclkesc(),            // output wire dl1_rxclkesc
//  .dl1_rxlpdtesc(),          // output wire dl1_rxlpdtesc
//  .dl1_rxulpsesc(),          // output wire dl1_rxulpsesc
//  .dl1_rxtriggeresc(),    // output wire [3 : 0] dl1_rxtriggeresc
//  .dl1_rxdataesc(),          // output wire [7 : 0] dl1_rxdataesc
//  .dl1_rxvalidesc(),        // output wire dl1_rxvalidesc
//  .dl1_errsoths(),            // output wire dl1_errsoths
//  .dl1_errsotsynchs(),    // output wire dl1_errsotsynchs
//  .dl1_erresc(),                // output wire dl1_erresc
//  .dl1_errsyncesc(),        // output wire dl1_errsyncesc
//  .dl1_errcontrol(),        // output wire dl1_errcontrol
//  .cl_rxclkactivehs(),    // output wire cl_rxclkactivehs
//  .cl_rxulpsclknot(),      // output wire cl_rxulpsclknot
//  .clk_rxp(mipi_phy_if_0_clk_p),                      // input wire clk_rxp
//  .clk_rxn(mipi_phy_if_0_clk_n),                      // input wire clk_rxn
//  .data_rxp(mipi_phy_if_0_data_p),                    // input wire [1 : 0] data_rxp
//  .data_rxn(mipi_phy_if_0_data_n)                    // input wire [1 : 0] data_rxn
//); 

//mipi_1lane_yuv422 mipi_1lane_yuv422_inst(

//    .clk_byte    (rxbyteclkhs),     
//    .clk_pix     (pix_clk),      
//    .rst_n       (rst_n),        
//    .byte_data0  (dl0_rxdatahs),    
//    .rxsync_hs0  (dl0_rxsynchs),    
//    .rxvalid_hs0 (dl0_rxvalidhs),  	
	
//    .yuv_fv	     (yuv_fv),
//    .yuv_lv	     (yuv_lv),
//    .yuv_data	 (yuv_data)
//);


///////////////////////////////////////????????///////////////////////////////////////////
wire trans_en;
reg trans_en_reg;
wire i_new_frame;
reg fv_r;
reg lv_r;
reg[31:0] data_r;
reg i_ddr_fv,i_ddr_lv;
reg[31:0] i_ddr_data;


wire color_bar_vs,color_bar_de;
wire[15:0] color_bar_data;

//    ila_if      u_ila_if(
//    .clk        (pix_clk),
//    .probe0     (yuv_fv),
//    .probe1     (yuv_lv),
//    .probe2     (yuv_data),
//    .probe3     (o_ddr_fv),
//    .probe4     (o_ddr_lv),
//    .probe5     (o_ddr_data)                    
//);

always @( posedge pix_clk )begin
	fv_r<= yuv_fv;// !color_bar_vs;
	lv_r<= yuv_lv;//color_bar_de;
	data_r<=yuv_data ;//color_bar_data;
end
assign i_new_frame=(!fv_r & yuv_fv) ? 1'b1 : 1'b0;
	

always @( posedge pix_clk )begin
	if( !rst_n )
		trans_en_reg<=1'b0;
	else if( i_new_frame )
		trans_en_reg <= 1'b1;
end


always @( posedge pix_clk )begin
	if(!rst_n )begin
		i_ddr_fv  <='b0;
		i_ddr_lv  <='b0;
		i_ddr_data<='b0;
	end
	else if(trans_en_reg)begin
		i_ddr_fv  <=fv_r  ;
		i_ddr_lv  <=lv_r  ;
		i_ddr_data<=data_r;		
	end
end

//pic_num_check #(
//	.DATA_WIDTH(32)
//)pic_num_check(
//    .clk   (pix_clk),
//    .rst_n (rst_n),
//    .i_fv  (i_ddr_fv),
//    .i_lv  (i_ddr_lv),
//    .i_data(i_ddr_data)
//    );

//if_ddc #(
//    .DDC_IF_FRAME_NUM (10)
//)
//    u_if_ddc    (
//    .i_sys_clk  (pix_clk),
//    .i_sys_rstn (rst_n),
//    .i_fv       (i_ddr_fv),
//    .i_lv       (i_ddr_lv),
//    .i_data     (i_ddr_data),
//    .o_fv       (o_ddr_fv),
//    .o_lv       (o_ddr_lv),
//    .o_data     (o_ddr_data)   
//);

//uivideo2axism_ir #(
//    .FIFO_DEPTH         (1024      )
//) nv16_video2axism_inst_ir( 
//	.vid_clk_i          (pix_clk   ),
//	.vid_rstn_i         (rst_n),
//	.vid_vs_i           (i_ddr_fv  ),
//	.vid_he_i           (i_ddr_lv  ),
//	.vid_de_i           (i_ddr_lv  ),
//	.vid_data_i         (i_ddr_data),
//	
//	// AXI4-Stream signals
//	.m_axis_vid_aclk    (pix_clk),//(pl_clk_250m         ),     
//	.m_axis_vid_tuser   (s_axis_video_tuser  ),//frame start  
//	.m_axis_vid_tdata   (s_axis_video_tdata  ),  
//	.m_axis_vid_tkeep   (s_axis_video_tkeep  ),   
//	.m_axis_vid_tvalid  (s_axis_video_tvalid ),   
//	.m_axis_vid_tready  (s_axis_video_tready ),   
//	.m_axis_vid_tlast   (s_axis_video_tlast  )//line end 
//);

/////////////////////////////////////////////////////////IIC///////////////////////////////////////////////
(* MARK_DEBUG="true" *)wire set_wr;
(* MARK_DEBUG="true" *)wire[7:0] set_wrdev;
(* MARK_DEBUG="true" *)wire[15:0] set_wraddr;
(* MARK_DEBUG="true" *)wire[15:0] set_wrdata;
(* MARK_DEBUG="true" *)wire i2c_transfer_end;

(* MARK_DEBUG="true" *)reg[31:0] i2c_rst_cnt;
(* MARK_DEBUG="true" *)reg[31:0] sensor_rst_cnt;
(* MARK_DEBUG="true" *)wire i2c_rst_n;
wire test_i2c_rst_n;

always @( posedge clk_10m )begin
	if( !rst_n )
		sensor_rst_cnt<=32'd0;
    else if( sensor_rst_cnt==32'hf )
		sensor_rst_cnt<=sensor_rst_cnt;
    else sensor_rst_cnt<=sensor_rst_cnt+1'b1;
end
assign gpio_tri_io = (sensor_rst_cnt==32'hf) ? 1'b1 : 1'b0;  //sensor��λ1s��������


assign test_i2c_rst_n = &sensor_rst_cnt[23:20];

always @( posedge clk_10m )begin
	if( !rst_n )
		i2c_rst_cnt<=32'd0;
    else if( &sensor_rst_cnt[3] )begin
		if( i2c_rst_cnt==32'hf )
			i2c_rst_cnt<=i2c_rst_cnt;
	    else i2c_rst_cnt<=i2c_rst_cnt+1'b1;
			
	end
	else 
	   i2c_rst_cnt<=i2c_rst_cnt;
		
end
assign i2c_rst_n   = ( i2c_rst_cnt==32'hf ) ? 1'b1 : 1'b0;

i2c_init_ir u_i2c_init_ir( 
    .clk                     (clk_10m               ),
    .rst_n                   (i2c_rst_n             ),
    .scl                     (iic_0_scl_io          ),
    .sda                     (iic_0_sda_io          ),
    .set_wr                  (set_wr                ),
    .set_wrdev               (set_wrdev             ),
    .set_wraddr              (set_wraddr            ),
    .set_wrdata              (set_wrdata            ),
    .i2c_transfer_end        (i2c_transfer_end      ) 
);
   
endmodule
