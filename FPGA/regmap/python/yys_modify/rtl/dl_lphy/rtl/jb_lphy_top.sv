
`timescale 1ns / 1ps

module jb_lphy_top # (
    parameter FH_DATA_WIDTH=64,
    parameter N_CARRIERS = 2,
    parameter N_ANTENNAS = 4,
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16,
    parameter DL_DEFM_UPLANE_TUSER_BW=31,
    parameter GAIN_SCALER_BW  = 4,
    parameter NCO_COEF_WIDTH=40

) (
     input                                        clk_4x, // Clock for FFT
     input                                        clk_1x,
	 input                                        clk_122p88,
     input                                        ptp_clk,
     input                                        reset_4x,
     input                                        reset_1x,
										          
     input                                        radio_if_clk,
     input                                        radio_if_reset,
     input [N_CARRIERS-1:0]                       prach_fir_resetn,
										          
     input [N_CARRIERS-1:0]                       dl_clk_x4_en, //clk_en for 122.88 at 491.52Mhz clock
     input [N_CARRIERS-1:0]                       ul_clk_x4_en,
     input [N_CARRIERS-1:0]                       dl_clk_x1en,
     input [N_CARRIERS-1:0]                       ul_clk_x1en,
     input [N_CARRIERS-1:0]                       prach_dfe_clk_x4_en, //clk_en for 122.88 at 491.52Mhz clock
										          
     output [N_CARRIERS-1:0]                      dl_frm_mrkr_10ms,
	 output reg [N_CARRIERS-1:0]                  dl_frm_mrkr_10ms_pin,
     output reg [N_CARRIERS-1:0]                      ul_frm_mrkr_10ms,
     output [N_CARRIERS-1:0]                      prach_frm_mrkr_10ms,  
     output [N_CARRIERS-1:0]                      dl_dfe_frm_mrkr,
     output logic                                 syn_data_dl_ul_5ms_lphy,	 
     jb_test_ctrl_if.test_dbg                     IFP_test_ctrl, 	 
     jb_cmn_ctrl_devided_if.lphy                  IFP_cmn_ctrl,
     jb_oran_lphy_ctrl_devided_if.lphy            IFP_oran_lphy_ctrl, 
     jb_oran_lphy_stat_devided_if.ul_oran_lphy    IFP_oran_ul_oran_lphy_stat,
     jb_oran_lphy_stat_devided_if.dl_oran_lphy    IFP_oran_dl_oran_lphy_stat,
     jb_oran_lphy_stat_devided_if.prach_oran      IFP_oran_prach_oran_stat,
     jb_fh_misc_new_if.lphy                       IFP_fh_misc,
     jb_fh_cc_timing_if.lphy                      IFP_fh_cc_timing [N_CARRIERS-1:0], 
										          
										          
     input [N_ANTENNAS-1:0] [24:0]                ul_oran_data_req,
										          
     jb_axi4_stream_if.slave                      IFP_dl_lphy_in[N_ANTENNAS-1:0],  //from ORAN              
     jb_axi4_stream_if.master                     IFP_dl_lphy_out[N_CARRIERS-1:0], //to DFE
										          
     jb_axi4_stream_if.slave                      IFP_ul_lphy_in[N_CARRIERS-1:0],  //From DFE
     jb_axi4_stream_if.master                     IFP_ul_lphy_out[N_ANTENNAS-1:0], //to ORAN
                           
     
     jb_prach_cplane_if.lphy                      IFP_prach_cplane,
     jb_axi4_stream_if.master                     IFP_prach_out   //to ORAN
  
    ); 


    
    jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_prach_in[N_CARRIERS-1:0]();
 
   
   logic [N_CARRIERS-1:0]         dl_ch_bw_update_req;   
   logic [N_CARRIERS-1:0]         dl_ch_bw_update_done;
   
   // UL Interface     
   logic [N_CARRIERS-1:0]         ul_ch_bw_update_req;
   logic [N_CARRIERS-1:0]         ul_ch_bw_update_done;
   logic [N_CARRIERS-1:0]	      ul_frm_mrkr_10ms_dlyd;
   logic [N_CARRIERS-1:0]         ul_frm_mrkr_10ms_clk_tmp;
   logic [N_CARRIERS-1:0]         ul_frm_mrkr_10ms_clk_tmp_d1;
   logic [N_CARRIERS-1:0]         ul_frm_mrkr_10ms_clk_tmp_d2;
   logic [N_CARRIERS-1:0]         ul_frm_mrkr_10ms_clk_tmp_d3;
   logic [N_CARRIERS-1:0]         ul_frm_mrkr_10ms_clk_400;
   logic [N_CARRIERS-1:0]         dl_frm_mrkr_10ms_clk_400;
   logic [N_CARRIERS-1:0]         s_trig;
   logic [N_CARRIERS-1:0]         s_trig_extend;
   logic [N_CARRIERS-1:0]         s_trig_extend_d1;   
   logic [N_CARRIERS-1:0]         s_trig_extend_d2;      
   logic [N_CARRIERS-1:0]         dl_frm_mrkr_10ms_clk_tmp;
   logic [N_CARRIERS-1:0]         dl_frm_mrkr_10ms_clk_tmp_d1;
   logic [N_CARRIERS-1:0]         dl_frm_mrkr_10ms_clk_tmp_d2;
   logic [N_CARRIERS-1:0]         dl_frm_mrkr_10ms_clk_tmp_d3;
   logic [31:0]					  cnt_10ms;
   
   logic [N_CARRIERS-1:0]         ul_frm_mrkr_10ms_fir;
   logic [N_CARRIERS-1:0] [31:0]  ul_frm_delay_cnt ;

   genvar j;

   assign dl_ch_bw_update_req = 2'b00;
   assign ul_ch_bw_update_req = 2'b00;
   logic [31:0]	count_10ms = 32'd0;
   logic		start = 0;


	always @ (posedge clk_1x) begin
		if(dl_frm_mrkr_10ms[0]) begin
			count_10ms <= 32'd0;
		end
		else if(count_10ms == 32'd4915199)
			count_10ms <= 32'd0;
		else
			count_10ms <= count_10ms + 1'd1;
	end
	
	always @ (posedge clk_1x) begin
		if(dl_frm_mrkr_10ms[0]) begin
			start = 1;
		end
	end
	
	always @ (posedge clk_1x) begin
		if(reset_1x) begin
			syn_data_dl_ul_5ms_lphy <= 0;
		end
		if(start) begin
			if(count_10ms < 32'd1843199) begin
				syn_data_dl_ul_5ms_lphy <= 1;
			end
			else if(count_10ms < 32'd2457599) begin
				syn_data_dl_ul_5ms_lphy <= 0;
			end
			else if(count_10ms < 32'd4300799)begin
				syn_data_dl_ul_5ms_lphy <= 1;
			end
			else if(count_10ms < 32'd4915199)
				syn_data_dl_ul_5ms_lphy <= 0;
			else
				syn_data_dl_ul_5ms_lphy <= 1;;
		end
	end

   /*
   //Temporary assignment, remove it later
   assign IFP_prach_out.tdata = IFP_ul_lphy_in[0].tdata;
   assign IFP_prach_out.tvalid =  IFP_ul_lphy_in[0].tvalid;
   assign IFP_prach_out.tuser =  IFP_ul_lphy_in[0].tuser;
   assign IFP_prach_out.tkeep =  0;
   assign IFP_prach_out.tlast = 0;
   //remove above once connected
*/
   assign IFP_fh_misc.dl_radio_start_10ms=dl_frm_mrkr_10ms_clk_400; //only 0 is used in ORAN
   assign IFP_fh_misc.ul_radio_start_10ms=ul_frm_mrkr_10ms_clk_400;//only 0 is used in ORAN

   generate            
      for (j = 0; j < N_CARRIERS; j = j + 1) begin : set_prach_in
       assign IFP_prach_in[j].tdata = IFP_ul_lphy_in[j].tdata;
       assign IFP_prach_in[j].tvalid =  IFP_ul_lphy_in[j].tvalid;
       assign IFP_prach_in[j].tuser =  IFP_ul_lphy_in[j].tuser;
      end : set_prach_in

       for (j = 0; j < N_CARRIERS; j = j + 1) begin : sys_frm_gen_inst
       jb_sys_frm_gen  u_sys_frm_gen (
                   .ptp_clk(ptp_clk),
                   .ptp_reset(1'b0), //connect later
                   .one_pps(IFP_fh_misc.one_pps),
                   .clk(clk_1x),
                   .reset(reset_1x), 
       
                   .dl_frm_mrkr_cntr_ns({IFP_cmn_ctrl.dl_frm_mrkr_cntr_ns[j][31:1],1'b0}),//2ns increment, 500Mhz clock, cycles
                   .ul_frm_mrkr_cntr_ns({IFP_cmn_ctrl.ul_frm_mrkr_cntr_ns[j][31:1],1'b0}),//2ns increment,500Mhz clock, cycles
                   .prach_frm_mrkr_cntr_ns({IFP_cmn_ctrl.prach_frm_mrkr_cntr_ns[j][31:1],1'b0}),//2ns increment, 500Mhz clock, cycles
                   .frm_mrkr_gen_trigger(IFP_cmn_ctrl.frm_mrkr_gen_trigger[j]),
                   .frm_mrkr_gen_enable(IFP_cmn_ctrl.frm_mrkr_gen_enable[j]),
       
                   .systimer_s(IFP_fh_misc.systimer_s),
                   .systimer_ns(IFP_fh_misc.systimer_ns),
       
                   .dl_frm_mrkr_10ms(dl_frm_mrkr_10ms[j]),
                   .ul_frm_mrkr_10ms(ul_frm_mrkr_10ms_fir[j]),
                   .prach_frm_mrkr_10ms(prach_frm_mrkr_10ms[j])
       );
       (*Dont_touch="true"*)jb_sys_frm_gen_tcs  u_sys_frm_gen_tcs (                                                                                               
            .ptp_clk(ptp_clk),                                                                                                
            .ptp_reset(1'b0), //connect later                                                                                 
            .one_pps(IFP_fh_misc.one_pps),                                                                                    
            .clk(clk_1x),                                                                                                     
            .reset(reset_1x),                                                                                                 
                                                                                                                              
            .dl_frm_mrkr_cntr_ns({IFP_cmn_ctrl.dl_frm_mrkr_cntr_ns[j][31:1],1'b0}),//2ns increment, 500Mhz clock, cycles      
            .ul_frm_mrkr_cntr_ns({IFP_cmn_ctrl.ul_frm_mrkr_cntr_ns[j][31:1],1'b0}),//2ns increment,500Mhz clock, cycles       
            .prach_frm_mrkr_cntr_ns({IFP_cmn_ctrl.prach_frm_mrkr_cntr_ns[j][31:1],1'b0}),//2ns increment, 500Mhz clock, cycles
            .frm_mrkr_gen_trigger(IFP_cmn_ctrl.frm_mrkr_gen_trigger[j]),                                                      
            .frm_mrkr_gen_enable(IFP_cmn_ctrl.frm_mrkr_gen_enable[j]),                                                        
                                                                                                                              
            //.systimer_s(IFP_fh_misc.systimer_s),                                                                              
            .systimer_ns(IFP_fh_misc.systimer_ns),                                                                            
                                          
                                                                                                                              
            .dl_frm_mrkr_10ms( ),
            .dl_frm_mrke_10ms_one_clk(),                                                                           
            .ul_frm_mrkr_10ms(),                                                                           
            .prach_frm_mrkr_10ms(),
            .syn_data_dl_ul_5ms( )                                                                     
        );                                                                                                                            
 
       
       
always @ (posedge clk_4x)begin
         if(ul_frm_mrkr_10ms_fir[j]==1'b1)
                  ul_frm_delay_cnt[j] <= 32'b0 ;
         else
                  ul_frm_delay_cnt[j] <= ul_frm_delay_cnt[j] + 32'b1 ;
end


always @ (posedge clk_4x)begin
         if(ul_frm_delay_cnt[j]==IFP_test_ctrl.debug_rw[21][31:0])
                  ul_frm_mrkr_10ms[j] <= 1'b1 ;
         else
                  ul_frm_mrkr_10ms[j] <= 1'b0 ;
end   
             
       

        jb_edge_det #(
        .SYNC_EN            (1),
        .SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (16),
        .PULSE_POLARITY     (1),//pos
	    .RETIME_OUTPUT      (1)
    ) u_dl_frm_mrkr_1x_to_400 (
        .clk                (clk_1x),
        .mask               (1'b0),
        .din                (dl_frm_mrkr_10ms[j]),
        .din_syncd          (),
        .dout               (dl_frm_mrkr_10ms_clk_tmp[j])
    );

        jb_edge_det #(
        .SYNC_EN            (1),
        .SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (200),
        .PULSE_POLARITY     (1),//pos
	    .RETIME_OUTPUT      (1)
    ) u_trig (
        .clk                (clk_1x),
        .mask               (1'b0),
        .din                (dl_frm_mrkr_10ms[j]),
        .din_syncd          (),
        .dout               (s_trig_extend[j])
    );



always @ ( posedge radio_if_clk )
begin
	dl_frm_mrkr_10ms_clk_tmp_d1[j]<= dl_frm_mrkr_10ms_clk_tmp[j];
	dl_frm_mrkr_10ms_clk_tmp_d2[j]<= dl_frm_mrkr_10ms_clk_tmp_d1[j];
	dl_frm_mrkr_10ms_clk_tmp_d3[j]<= dl_frm_mrkr_10ms_clk_tmp_d2[j];
end

assign dl_frm_mrkr_10ms_clk_400[j] = ( !dl_frm_mrkr_10ms_clk_tmp_d2[j] ) && dl_frm_mrkr_10ms_clk_tmp_d3[j];

    
    end : sys_frm_gen_inst
   endgenerate
   
  jb_dl_lphy_top #(
          .N_CARRIERS(N_CARRIERS),
          .N_ANTENNAS (N_ANTENNAS),
          .USR_ID_BW (USR_ID_BW),
          .PRECISION (PRECISION),
          .FH_DATA_WIDTH(FH_DATA_WIDTH), 
          .DL_DEFM_UPLANE_TUSER_BW(DL_DEFM_UPLANE_TUSER_BW), 
          .GAIN_SCALER_BW(GAIN_SCALER_BW)
   )  u_dl_lphy_top    (
          .clk_4x                         (clk_4x), // input wire CLK
          .clk_1x                         (clk_1x),
        
          .radio_if_clk                   (radio_if_clk),
          .radio_if_reset                 (radio_if_reset),
        
          .reset_4x                       (reset_4x), // input reset          
          .reset_1x                       (reset_1x),
          .clk_x4_en                      (dl_clk_x4_en),// input clk enable// Out to DFE
          .clk_x1en                       (dl_clk_x1en),
          .dl_frm_mrkr_10ms               (dl_frm_mrkr_10ms),// one pulse every 10ms
          .IFP_fh_cc_timing               (IFP_fh_cc_timing),
          .dl_ch_bw_update_req            (dl_ch_bw_update_req),
          .dl_ch_bw_update_done           (dl_ch_bw_update_done),

          .dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr),  
          .IFP_cmn_ctrl                   (IFP_cmn_ctrl),// input bandwidth b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
          .IFP_oran_lphy_ctrl             (IFP_oran_lphy_ctrl),  // input
          .IFP_oran_dl_oran_lphy_stat     (IFP_oran_dl_oran_lphy_stat),
          .IFP_dl_lphy_in                 (IFP_dl_lphy_in),
          .IFP_dl_lphy_out_nr             (IFP_dl_lphy_out)
      );

      
(* DONT_TOUCH = "TRUE" *)      jb_ul_lphy_top #(
          .N_ANTENNAS (N_ANTENNAS),
          .N_CARRIERS (N_CARRIERS),
          .USR_ID_BW (USR_ID_BW),
          .PRECISION (PRECISION),
          .FH_DATA_WIDTH(FH_DATA_WIDTH),  
          .GAIN_SCALER_BW(GAIN_SCALER_BW)
       )  u_ul_lphy_top  (
          .clk_4x                         (clk_4x), // input wire CLK
          .radio_if_clk                   (radio_if_clk),
          .radio_if_reset                 (radio_if_reset),
          .reset_4x                       (reset_4x), // input reset          
          .clk_x4_en                      (ul_clk_x4_en),// input clk enable// Out to DFE
          .test_mode                      (IFP_test_ctrl.debug_rw[18][0]),
		  .frm_delay_ul_oran              (IFP_test_ctrl.debug_rw[19][15:0]),
		  .IFP_fh_cc_timing               (IFP_fh_cc_timing),
          .ul_frm_mrkr_10ms               (ul_frm_mrkr_10ms),// one pulse every 10ms
		  .ul_frm_mrkr_10ms_clk_400       (ul_frm_mrkr_10ms_clk_400),
          .ul_ch_bw_update_req            (ul_ch_bw_update_req),
          .ul_ch_bw_update_done           (ul_ch_bw_update_done), 
          .IFP_cmn_ctrl                   (IFP_cmn_ctrl),// input bandwidth b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
          .IFP_oran_lphy_ctrl             (IFP_oran_lphy_ctrl),  // input
          .IFP_oran_ul_oran_lphy_stat     (IFP_oran_ul_oran_lphy_stat),
          .ul_oran_data_req               (ul_oran_data_req), 
          .IFP_ul_lphy_in                 (IFP_ul_lphy_in),
          .IFP_ul_lphy_out                (IFP_ul_lphy_out)        
      );

   
(* DONT_TOUCH = "TRUE" *)  jb_prach_top #(
          .N_ANTENNAS (N_ANTENNAS),
          .N_CARRIERS (N_CARRIERS),
          .PRECISION (PRECISION),
          .USR_ID_BW (USR_ID_BW),
          .NCO_COEF_WIDTH(NCO_COEF_WIDTH)
  ) u_prach_top ( 
          .clk_4x                         (clk_4x), // input wire CLK
          .clk_1x                         (clk_122p88),
          .radio_if_clk                   (radio_if_clk),
          .radio_if_reset                 (radio_if_reset),
          .resetn_4x                      (~reset_4x), // input reset          
          .resetn_1x                      (~reset_1x),
          .prach_fir_resetn               (prach_fir_resetn),
          .clk_x4en                       (prach_dfe_clk_x4_en),// input clk enable// Out to DFE
          .clk_x1en                       (ul_clk_x1en),
          .frm_mrkr                       (prach_frm_mrkr_10ms),
          .systimer_ns                    (IFP_fh_misc.systimer_ns),
	      .IFP_cmn_ctrl                   (IFP_cmn_ctrl),
	      .IFP_oran_lphy_ctrl             (IFP_oran_lphy_ctrl),
	      .IFP_oran_prach_oran_stat       (IFP_oran_prach_oran_stat),
	      .IFP_prach_in                   (IFP_prach_in),
	      .IFP_prach_out                  (IFP_prach_out),
	      .IFP_prach_cplane               (IFP_prach_cplane)
    );
	
always @ (posedge clk_1x)begin
  s_trig_extend_d1[0]     <= s_trig_extend[0];
  s_trig_extend_d1[1]     <= s_trig_extend[1];
  s_trig_extend_d2[0]     <= s_trig_extend_d1[0];
  s_trig_extend_d2[1]     <= s_trig_extend_d1[1];
  dl_frm_mrkr_10ms_pin[0] <= s_trig_extend_d2[0];
  dl_frm_mrkr_10ms_pin[1] <= s_trig_extend_d2[1];
end

endmodule
