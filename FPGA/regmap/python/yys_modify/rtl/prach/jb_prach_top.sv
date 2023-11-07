
 module jb_prach_top #(

      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  USR_ID_BW = 2,
      parameter  PRECISION=16,
      parameter  NCO_COEF_WIDTH =40, 
      parameter INST = 1
) (
     input                               clk_4x,
     input                               clk_1x,
     
     input                                radio_if_clk,
     input                                radio_if_reset,
     
     input                               resetn_4x,
     input                               resetn_1x,
     input [N_CARRIERS-1:0]              prach_fir_resetn,
     input [N_CARRIERS-1:0]              clk_x1en ,  // tied to car_en_input in tb or ul_clk_x1en in lphy_top, should not toggle
     input [N_CARRIERS-1:0]              clk_x4en , //  tied to prach_dfe_clk_x4_en in lphy_top 
     input [N_CARRIERS-1:0]              frm_mrkr,
     input  [31:0]                       systimer_ns,
     jb_cmn_ctrl_devided_if.lphy         IFP_cmn_ctrl,
     jb_oran_lphy_ctrl_devided_if.lphy           IFP_oran_lphy_ctrl, 
     jb_oran_lphy_stat_devided_if.prach_oran     IFP_oran_prach_oran_stat,
     jb_axi4_stream_if.slave             IFP_prach_in[N_CARRIERS-1:0],
     jb_axi4_stream_if.master            IFP_prach_out,   //to ORAN
     jb_prach_cplane_if.lphy             IFP_prach_cplane
);

`include  "jb_common.svh"
   
   
   
   //  logic sub_frame_mrkr_delayed;
  
  
   logic  [N_CARRIERS-1:0]                                 sym_mrkr;
   logic [N_CARRIERS-1:0]                                  ch_bw_update_done;
   logic             prach_car_en[N_CARRIERS-1:0];
   logic [N_CARRIERS-1:0]  [3:0] 	 format;
   logic             reset_dfe;
   
   
   
   logic [PRECISION-1:0]                                   prach_out_q [N_CARRIERS-1:0] ;
   logic [PRECISION-1:0]                                   prach_out_i [N_CARRIERS-1:0] ;
   logic                                                   sub_frame_mrkr_delayed; 
   logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]      nco_coef;
   logic [N_CARRIERS-1:0]                                  prach_en; 
   logic [N_CARRIERS-1:0] [3:0] 	                   ch_bw;
   logic [N_CARRIERS-1:0][3:0]               ch_gain_scalar;
   logic [N_CARRIERS-1:0][15:0]              ch_gain_fraction;
   logic [N_CARRIERS-1:0]                   ch_gain_scalar_sign;
   logic  [N_CARRIERS-1:0][9:0]            prach_cp;
   logic [N_CARRIERS-1:0] 	        frm_mrkr_clk_4x;
   
   
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_prach_dfe_in[N_CARRIERS-1:0]();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_prach_dfe_out[N_CARRIERS-1:0]();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_prach_fft_in[N_CARRIERS-1:0]();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW+10+4)) IFP_prach_fft_out[N_CARRIERS-1:0]();
    
 //    jb_prach_dfe_ctrl_if #(.N_CARRIERS(N_CARRIERS), .N_ANTENNAS(N_ANTENNAS), .NCO_COEF_WIDTH(NCO_COEF_WIDTH)) IFP_prach_dfe_ctrl();
  
   genvar              j;  
 generate
      for (j = 0; j <  N_CARRIERS; j = j + 1) begin : u_prach_in
        //Fix teh timing violation
        always @(posedge clk_1x) begin
          if (!resetn_1x) begin
            IFP_prach_dfe_in[j].tdata <=  0;
            IFP_prach_dfe_in[j].tvalid <= 0;
            IFP_prach_dfe_in[j].tuser <= 0;
          end    
          else if (clk_x1en) begin
            IFP_prach_dfe_in[j].tdata <= IFP_prach_in[j].tdata;
            IFP_prach_dfe_in[j].tvalid <= IFP_prach_in[j].tvalid;
            IFP_prach_dfe_in[j].tuser <= IFP_prach_in[j].tuser;
          end
       end
       assign IFP_prach_in[j].tready= 1'b1;
	   assign prach_en[j] = (|IFP_oran_lphy_ctrl.prach_en[j]) & (| IFP_cmn_ctrl.ul_stream_en[j]);	 
	   assign nco_coef[j]= {IFP_oran_lphy_ctrl.prach_car_nco_sign[j],IFP_oran_lphy_ctrl.prach_car_nco_msb[j],IFP_oran_lphy_ctrl.prach_car_nco_lsb[j]};  //-as
	   assign  ch_gain_scalar[j] = IFP_oran_lphy_ctrl.prach_gain_scaler[j];
	   assign  ch_gain_fraction[j] = IFP_oran_lphy_ctrl.prach_gain_fraction[j];
	   assign  ch_gain_scalar_sign[j] = IFP_oran_lphy_ctrl.prach_gain_scaler_sign[j];
	   assign ch_bw[j]= IFP_cmn_ctrl.ul_car_bw[j];
	   assign prach_cp[j] = IFP_oran_lphy_ctrl.prach_cp[j][9:0];
	     
	     
/*	       jb_edge_det #(
        .SYNC_EN            (1),
	    .SYNC_STAGES        (1),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1),//pos
	    .RETIME_OUTPUT      (1)
    ) u_frm_mrkr_1x_to_4x (
        .clk                (clk_4x),
        .mask               (1'b0),
        .din                (frm_mrkr[j]),
        .din_syncd          (),
        .dout               (frm_mrkr_clk_4x[j])
);      
*/	     
      end :  u_prach_in
   endgenerate

jb_prach_dfe_top #(
    .N_CARRIERS (N_CARRIERS),
    .N_ANTENNAS (N_ANTENNAS),
    .USR_ID_BW  (USR_ID_BW),
    .PRECISION  (PRECISION)
) u_prach_dfe_top(
    .clk_4x                    (clk_4x),                               
    .clk_1x                    (clk_1x),                      
    .resetn_4x                 (resetn_4x),                   
    .resetn_1x                 (resetn_1x),
    .prach_fir_resetn          (prach_fir_resetn),     
     .nco_coef                 (nco_coef),               
     .prach_en                 (prach_en),
     .ch_gain_scalar           (ch_gain_scalar),      
     .ch_gain_fraction         (ch_gain_fraction),    
     .ch_gain_scalar_sign      (ch_gain_scalar_sign), 
     .systimer_ns              (systimer_ns),
     .ch_bw                    (ch_bw), 
     .clk_x1en                 (clk_x1en),   
     .clk_x4en                 (clk_x4en),
  //  .IFP_prach_dfe_ctrl             (IFP_prach_dfe_ctrl),         
    .IFP_prach_dfe_in         (IFP_prach_dfe_in),
    .IFP_prach_dfe_out        (IFP_prach_dfe_out)
    
    );  


   assign reset_dfe = !resetn_1x;
   

jb_prach_fft_top #(
   // .UL_TIME_DELAY_BYPASS (UL_TIME_DELAY_BYPASS),
    .N_CARRIERS (N_CARRIERS),
    .N_ANTENNAS (N_ANTENNAS) ,
    .PRECISION  (PRECISION),
    .USR_ID_BW  (USR_ID_BW)
) u_prach_fft_top(
     .clk_4x                    (clk_4x),                               
//     .clk_1x                    (clk_1x),                      
     .resetn_1x                 (resetn_1x),                   
  //   .resetn_1x                 (resetn_1x),
     .clk_x1en                  (clk_x1en),
     .clk_x4en                  (clk_x4en),
     .frm_mrkr                  (frm_mrkr),
     .prach_en                  (prach_en),
     .prach_cp                  (prach_cp),
     .systimer_ns              (systimer_ns),  
     .IFP_fft_in                (IFP_prach_dfe_out), 
     .format                    (IFP_oran_lphy_ctrl.prach_format), // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
     .ch_bw                     (ch_bw),
    // .ch_bw_update_req            (ch_bw_update_req),
     .sub_frame_mrkr_delayed     (sub_frame_mrkr_delayed),
     .sym_mrkr                   (sym_mrkr),
     .ch_bw_update_done          (ch_bw_update_done), 
    // Output DFE side
    .clk_dfe                     (clk_1x),
    .clk_en_dfe                  (1'b1),   //was clk_x1en[0] or use prach_dfe_clk_x4_en
    .reset_dfe                   (reset_dfe),
    .IFP_fft_out                 (IFP_prach_fft_out) 
    );
    
  logic  [N_CARRIERS-1:0]          prach_fft_tready;
  logic  [N_CARRIERS-1:0]          prach_fft_tvalid;
  logic  [N_CARRIERS-1:0][15:0]    prach_fft_tuser;
  logic  [N_CARRIERS-1:0][31:0]    prach_fft_tdata;
  logic  [N_CARRIERS-1:0]          prach_fft_tlast;
  
  generate
    for (j=0; j<N_CARRIERS; j++) begin 
      assign prach_fft_tdata[j]           = IFP_prach_fft_out[j].tdata;
      assign prach_fft_tvalid[j]          = IFP_prach_fft_out[j].tvalid;
      assign prach_fft_tuser[j]           = IFP_prach_fft_out[j].tuser;
      assign prach_fft_tlast[j]           = IFP_prach_fft_out[j].tlast;
      assign IFP_prach_fft_out[j].tready  = prach_fft_tready[j];	 
    end 
  endgenerate
  
  jb_prach_oran_data #(
    .NA(N_ANTENNAS),  /* Number of antennae...              */
    .NC(N_CARRIERS),  /* NUmber of carriers...              */
    .CB(4)            /* Number of debug counter bits...    */
    )
    u_prach_oran_data (
      .clkin(clk_1x),
      .rstin(~resetn_1x),
      
      .clkout(radio_if_clk),
      .rstout(radio_if_reset),
      
      .prach_swap_fft       (IFP_oran_lphy_ctrl.prach_swap_fft      ),
      .prach_endianness     (IFP_oran_lphy_ctrl.prach_iq_endianness ),
      .IFP_prach_cplane     (IFP_prach_cplane                       ),
      
      .prach_oran_tready    (IFP_prach_out.tready ),
      .prach_oran_tvalid    (IFP_prach_out.tvalid ),
      .prach_oran_tuser     (IFP_prach_out.tuser  ),
      .prach_oran_tdata     (IFP_prach_out.tdata  ),
      .prach_oran_tkeep     (IFP_prach_out.tkeep  ),
      .prach_oran_tlast     (IFP_prach_out.tlast  ),

      .prach_fft_tready     (prach_fft_tready ),
      .prach_fft_tvalid     (prach_fft_tvalid ),
      .prach_fft_tuser      (prach_fft_tuser  ),
      .prach_fft_tdata      (prach_fft_tdata  ),
      .prach_fft_tlast      (prach_fft_tlast  ),
      .prach_fft_clken      (clk_x1en         ),

      .clear                      (IFP_oran_lphy_ctrl.prach_oran_clear                  ),
      .vld_wo_rdy_err_cnt         (IFP_oran_prach_oran_stat.prach_oran_vld_wo_rdy       ),
      .cplane_fifo_ovfl_err_cnt   (IFP_oran_prach_oran_stat.prach_oran_cplane_fifo_ovfl ),
      .prach_fifo_ovfl_err_cnt    (IFP_oran_prach_oran_stat.prach_oran_reqs_fifo_ovfl   )
      );
      
      
//      ila_prach_top_1 ila_prach_top_inst (
//	.clk(clk_4x), // input wire clk
//	.probe0(clk_x1en[0]), // input wire [0:0]  probe0  
//	.probe1(clk_x4en[0]), // input wire [0:0]  probe1 
//	.probe2(prach_en), // input wire [0:0]  probe2 
//	.probe3(frm_mrkr[0]) // input wire [0:0]  probe3
//);

//ila_prach_1 ila_prach_1_oran_inst (
//	.clk(clk_1x), // input wire clk
//	.probe0(IFP_prach_out.tdata[15:0]), // input wire [15:0]  probe0  
//	.probe1(IFP_prach_out.tdata[31:16]), // input wire [15:0]  probe1 
//	.probe2(prach_fft_tdata[0][15:0]), // input wire [15:0]  probe2 
//	.probe3(prach_fft_tdata[0][31:16]), // input wire [15:0]  probe3 
//	.probe4(IFP_prach_out.tuser[21:12]), // input wire [9:0]  probe4 
//	.probe5(IFP_prach_out.tvalid), // input wire [0:0]  probe5 
//	.probe6(prach_fft_tvalid), // input wire [0:0]  probe6 
//	.probe7(prach_fft_tlast), // input wire [0:0]  probe7 
//	.probe8(IFP_prach_out.tready), // input wire [0:0]  probe8 
//	.probe9(prach_fft_tready), // input wire [0:0]  probe9 
//	.probe10(IFP_prach_cplane.tvalid), // input wire [0:0]  probe10 
//	.probe11(IFP_prach_out.tlast), // input wire [0:0]  probe11 
//	.probe12(IFP_prach_cplane.tready), // input wire [0:0]  probe12 
//	.probe13(IFP_prach_cplane.sf[3:0]), // input wire [3:0]  probe13 
//	.probe14(1'b0), // input wire [0:0]  probe14 
//	.probe15(prach_fft_tuser), // input wire [15:0]  probe15
//	.probe16(IFP_prach_dfe_in[0].tdata[31:16]), // input wire [15:0]  probe16 
//	.probe17(IFP_prach_dfe_in[0].tdata[15:0]), // input wire [15:0]  probe17 
//	.probe18(frm_mrkr), // input wire [0:0]  probe18 
//	.probe19(1'b0), // input wire [0:0]  probe19
//    .probe20(systimer_ns), // input wire [31:0]  probe20 
//	.probe21(IFP_prach_dfe_out[0].tdata[31:16]), // input wire [15:0]  probe21 
//	.probe22(IFP_prach_dfe_out[0].tdata[15:0]), // input wire [15:0]  probe22 
//	.probe23(IFP_prach_dfe_out[0].tvalid), // input wire [0:0]  probe23 
//	.probe24(16'b0), // input wire [15:0]  probe24 
//	.probe25(16'b0) // input wire [15:0]  probe25
//);



/*
generate 
if (INST == 0) begin 

ila_prach_delay_1 ila_prach_delay_inst (
	.clk(clk_1x), // input wire clk
	.probe0(frm_mrkr[0]), // input wire [0:0]  probe0  
	.probe1(IFP_prach_dfe_in[0].tvalid), // input wire [0:0]  probe1 
	.probe2(IFP_prach_dfe_in[0].tuser), // input wire [1:0]  probe2 
	.probe3(IFP_prach_dfe_in[0].tdata[31:16]), // input wire [15:0]  probe3 
	.probe4(IFP_prach_dfe_in[0].tdata[15:0]), // input wire [15:0]  probe4 
	.probe5(IFP_prach_dfe_out[0].tvalid), // input wire [0:0]  probe5 
	.probe6(IFP_prach_dfe_out[0].tuser), // input wire [1:0]  probe6 
	.probe7(IFP_prach_dfe_out[0].tdata[31:16]), // input wire [15:0]  probe7 
	.probe8(IFP_prach_dfe_out[0].tdata[15:0]), // input wire [15:0]  probe8 
	.probe9(clk_x1en[0]), // input wire [0:0]  probe9 
	.probe10(clk_x4en[0]), // input wire [0:0]  probe10 
	.probe11(resetn_4x), // input wire [0:0]  probe11 
	.probe12(prach_en[0]) // input wire [0:0]  probe12
);
end
endgenerate
*/
endmodule // jb_prach_top


