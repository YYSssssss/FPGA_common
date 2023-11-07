`timescale 1ns / 1ps

module jb_dl_lphy_top # (
    parameter N_ANTENNAS = 4,
    parameter N_CARRIERS = 2,
    parameter DL_DEFM_UPLANE_TUSER_BW=31,
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4,
    parameter FH_DATA_WIDTH = 64

) (
     input                                         clk_4x, // Clock for FFT
     input                                         clk_1x,
										           
     input                                         radio_if_clk,
     input                                         radio_if_reset,
										           
     input                                         reset_4x,
     input                                         reset_1x,
										           
     input [N_CARRIERS-1:0]                        clk_x4_en,
     input [N_CARRIERS-1:0]                        clk_x1en,
										           
     //Markers                                     
     input  [N_CARRIERS-1:0]                        dl_frm_mrkr_10ms, //at 122.88
     output [N_CARRIERS-1:0]                        dl_dfe_frm_mrkr,
										           
     input  [N_CARRIERS-1:0]                        dl_ch_bw_update_req,   
     output [N_CARRIERS-1:0]                        dl_ch_bw_update_done,
										           
										           
     jb_cmn_ctrl_devided_if.lphy                    IFP_cmn_ctrl,
     jb_oran_lphy_ctrl_devided_if.lphy              IFP_oran_lphy_ctrl, 
     jb_oran_lphy_stat_devided_if.dl_oran_lphy      IFP_oran_dl_oran_lphy_stat,
     jb_fh_cc_timing_if.lphy                        IFP_fh_cc_timing [N_CARRIERS-1:0], 
											        
											        
     jb_axi4_stream_if.slave                        IFP_dl_lphy_in[N_ANTENNAS-1:0], //from ORAN
     jb_axi4_stream_if.master                       IFP_dl_lphy_out_nr[N_CARRIERS-1:0]  //to DFE

    ); 


     logic [N_CARRIERS-1:0]           dl_car_en;
     logic [N_CARRIERS-1:0]           dl_sym_mrkr_ifft;
     logic [N_CARRIERS-1:0]           dl_sym_mrkr_ifft_pre;
   
     logic [N_CARRIERS-1:0]           dl_sym_mrkr_4x_ifft;
     logic [N_CARRIERS-1:0]           dl_oran_ready;// input ready from ORAN.  Data is available to take
     logic [N_CARRIERS-1:0]           dl_cp_valid;    // Not used... More for debug
     logic  [N_CARRIERS-1:0]          dl_frm_mrkr_10ms_ifft;
     logic [N_CARRIERS-1:0] 	      dl_frm_mrkr_10ms_ifft_clk_4x;
     logic [N_CARRIERS-1:0] 	      dl_frm_mrkr_10ms_clk_4x;
     logic                            radio_en;
 
     //nr
     logic [N_CARRIERS-1:0]           dl_cp_valid_nr;    // Not used... More for debug
     logic [N_CARRIERS-1:0]           dl_oran_ready_nr;// input ready from ORAN.  Data is available to take
     logic [N_CARRIERS-1:0]           dl_sym_mrkr_ifft_nr      ;
     logic [N_CARRIERS-1:0]           dl_sym_mrkr_ifft_pre_nr  ;
     logic [N_CARRIERS-1:0]           dl_sym_mrkr_4x_ifft_nr   ;
     logic [N_CARRIERS-1:0]           dl_dfe_frm_mrkr_nr       ;
     logic [N_CARRIERS-1:0]           dl_ch_bw_update_done_nr  ;
   
     logic [N_CARRIERS-1:0]           dl_frm_mrkr_10ms_clk_tmp;
     logic [N_CARRIERS-1:0]           dl_frm_mrkr_10ms_clk_tmp_d1;
     logic [N_CARRIERS-1:0]           dl_frm_mrkr_10ms_clk_tmp_d2;
     logic [N_CARRIERS-1:0]           dl_frm_mrkr_10ms_clk_tmp_d3;
   

   jb_axi4_stream_if   #(.DATA_WIDTH(FH_DATA_WIDTH), .USER_SB_WIDTH(DL_DEFM_UPLANE_TUSER_BW)) IFP_dl_oran_streams [N_CARRIERS-1:0][N_ANTENNAS-1:0] ();
   jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dl_oran_ifft [N_CARRIERS-1:0] ();
   
   jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dl_oran_ifft_nr [N_CARRIERS-1:0] ();
 //  jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dl_lphy_out_nr [N_CARRIERS-1:0] ();
   
   
   genvar                          i;


   jb_dl_oran_router #(
      .N_ANTENNAS               (N_ANTENNAS),
      .N_CARRIERS               (N_CARRIERS),
      .FH_DATA_WIDTH            (FH_DATA_WIDTH),                     
      .DEFM_TUSER_WIDTH         (DL_DEFM_UPLANE_TUSER_BW)
    ) u_dl_oran_router (
        .clk                   (radio_if_clk),
        .reset                 (radio_if_reset),
//        .IFP_oran_lphy_ctrl    (IFP_oran_lphy_ctrl),  // input
        .IFP_fh_defm           (IFP_dl_lphy_in),
        .IFP_dl_oran           (IFP_dl_oran_streams) //car x ant
    );

   
   generate

      //Delay
      for (i = 0; i < N_CARRIERS; i = i + 1) begin : dl_frm_mrkr_dly

	 	 
       jb_frm_mrkr_dly  #(
           .DELAY_1024_UNITS(5),
           .DELAY_ONE_CYCLE_UNITS(8)
       )   u_dl_frm_mrkr_dly (
           .clk                 (clk_1x),
           .frm_mrkr_10ms       (dl_frm_mrkr_10ms[i]),
           .frm_mrkr_10ms_dlyd  (dl_frm_mrkr_10ms_ifft[i])
       );
	 
       jb_edge_det #(
        .SYNC_EN            (1),
	.SYNC_STAGES        (1),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1),//pos
	.RETIME_OUTPUT      (1)
    ) u_frm_mrkr_ifft_1x_to_4x (
        .clk                (clk_4x),
        .mask               (1'b0),
        .din                (dl_frm_mrkr_10ms_ifft[i]),
        .din_syncd          (),
        .dout               (dl_frm_mrkr_10ms_ifft_clk_4x[i])
    );

     jb_edge_det #(
        .SYNC_EN            (1),
	    .SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (16),
        .PULSE_POLARITY     (1),//pos
	.RETIME_OUTPUT      (1)
    ) u_frm_mrkr_1x_to_4x (
        .clk                (clk_1x),
        .mask               (1'b0),
        .din                (dl_frm_mrkr_10ms[i]),
        .din_syncd          (),
        .dout               (dl_frm_mrkr_10ms_clk_tmp[i])
    );

always @ ( posedge radio_if_clk )
begin
	dl_frm_mrkr_10ms_clk_tmp_d1[i]<= dl_frm_mrkr_10ms_clk_tmp[i];
	dl_frm_mrkr_10ms_clk_tmp_d2[i]<= dl_frm_mrkr_10ms_clk_tmp_d1[i];
	dl_frm_mrkr_10ms_clk_tmp_d3[i]<= dl_frm_mrkr_10ms_clk_tmp_d2[i];
end

assign dl_frm_mrkr_10ms_clk_4x[i] = ( !dl_frm_mrkr_10ms_clk_tmp_d2[i] ) && dl_frm_mrkr_10ms_clk_tmp_d3[i];
end : dl_frm_mrkr_dly

/*    
      //seprate loop names help with hierarchy
      for (i = 0; i < N_CARRIERS; i = i + 1) begin : dl_car_oran
              
        jb_dl_oran #(
             .N_ANTENNAS               (N_ANTENNAS),
             .FH_DATA_WIDTH            (FH_DATA_WIDTH),  
             .DEFM_TUSER_WIDTH         (DL_DEFM_UPLANE_TUSER_BW),               
             .PRECISION                (PRECISION),
             .INST                     (i)
        ) u_dl_oran (
            .clk_4x                      (clk_4x),
            .clk_1x                      (clk_1x),
            .radio_if_clk                (radio_if_clk),
            .radio_if_reset              (radio_if_reset),
            .clk_en                      (clk_x1en[i]),// input clk enable , when clk_4x, connect clk_x4_en[i] for 5G 
            .reset_4x                    (reset_4x),
            .reset_1x                    (reset_1x),
            .extended_cp                 (IFP_oran_lphy_ctrl.dl_extended_cp[i]),
            .ant_en                      (IFP_cmn_ctrl.dl_stream_en[i]),
            .dl_car_bw                   (IFP_cmn_ctrl.dl_car_bw[i]),
            .dl_swap_ifft                 (IFP_oran_lphy_ctrl.dl_swap_ifft),
            .dl_iq_endianness             (IFP_oran_lphy_ctrl.dl_iq_endianness),
            .radio_en                    (IFP_fh_cc_timing[i].cc_enable),   //connect to bd
            .dl_frm_mrkr_10ms            (dl_frm_mrkr_10ms_clk_4x[i]), 
            .dl_ifft_sym_mrkr            (dl_sym_mrkr_ifft[i]), // o symbol marker
            .dl_sym_mrkr_4x_ifft         (dl_sym_mrkr_4x_ifft[i]), // o symbol marker
	        .dl_pre_ifft_sym_mrkr        (dl_sym_mrkr_ifft_pre[i]),
            .dl_oran_ready               (dl_oran_ready[i]),
            .IFP_dl_oran                 (IFP_dl_oran_streams[i]),  //per carrier
            .IFP_dl_oran_ifft            (IFP_dl_oran_ifft[i])
        );
                                   
      end : dl_car_oran
*/
      
     //nr
    //seprate loop names help with hierarchy
      for (i = 0; i < N_CARRIERS; i = i + 1) begin : dl_car_oran_nr
              
        jb_dl_oran_nr #(
             .N_ANTENNAS               (N_ANTENNAS),
             .FH_DATA_WIDTH            (FH_DATA_WIDTH),  
             .DEFM_TUSER_WIDTH         (DL_DEFM_UPLANE_TUSER_BW),               
             .PRECISION                (PRECISION),
             .INST                     (i)
        ) u_dl_oran_nr (
            .clk_4x                      (clk_4x),
            .clk_1x                      (clk_1x),
            .radio_if_clk                (radio_if_clk),
            .radio_if_reset              (radio_if_reset),
            .clk_en                      (clk_x4_en[i]),// input clk enable , when clk_4x, connect clk_x4_en[i] for 5G 
            .reset_4x                    (reset_4x),
            .reset_1x                    (reset_1x),
            .extended_cp                 (IFP_oran_lphy_ctrl.dl_extended_cp[i]),
            .ant_en                      (IFP_cmn_ctrl.dl_stream_en[i]),
            .dl_car_bw                   (IFP_cmn_ctrl.dl_car_bw[i]),
            .dl_swap_ifft                 (IFP_oran_lphy_ctrl.dl_swap_ifft),
            .dl_iq_endianness             (IFP_oran_lphy_ctrl.dl_iq_endianness),
            .radio_en                    (IFP_fh_cc_timing[i].cc_enable),   //connect to bd
            .dl_frm_mrkr_10ms            (dl_frm_mrkr_10ms_clk_4x[i]), 
            .dl_ifft_sym_mrkr            (dl_sym_mrkr_ifft_nr[i]), // o symbol marker
            .dl_sym_mrkr_4x_ifft         (dl_sym_mrkr_4x_ifft_nr[i]), // o symbol marker
	        .dl_pre_ifft_sym_mrkr        (dl_sym_mrkr_ifft_pre_nr[i]),
            .dl_oran_ready               (dl_oran_ready_nr[i]),
            .IFP_dl_oran                 (IFP_dl_oran_streams[i]),  //per carrier
            .IFP_dl_oran_ifft            (IFP_dl_oran_ifft_nr[i])
        );
                                   
      end : dl_car_oran_nr
   
   
/*
      for (i = 0; i < N_CARRIERS; i = i + 1) begin : dl_car_ifft
      
        assign dl_car_en[i] = |IFP_cmn_ctrl.dl_stream_en[i];
        jb_lte_ifft #(
               .N_ANTENNAS                     (N_ANTENNAS),
               .USR_ID_BW                      (USR_ID_BW),
               .PRECISION                      (PRECISION),
               .GAIN_SCALER_BW                 (GAIN_SCALER_BW),
               .INST                           (i)
         )  u_jb_lte_ifft  (
               .clk                            (clk_1x), 
               .clk_dfe                        (clk_1x), // input wire CLK
               .reset                          (reset_1x), //use reset_4x when clk_4x is used for 5G
               .reset_dfe                      (reset_1x), // input reset
               .clk_en                         (clk_x1en[i]),// input clk enable , when clk_4x, connect clk_x4_en[i] for 5G 
               .clk_en_dfe                     (clk_x1en[i]),
               .clk_frm_mrkr                   (clk_4x), // input clk for framer marker 491.52Mhz expected
               .reset_frm_mrkr                 (reset_4x),  // input reset for framer marker clock
               .frm_mrkr                       (dl_frm_mrkr_10ms_ifft_clk_4x[i]), // one pulse every 10ms
               .sym_mrkr                       (dl_sym_mrkr_ifft[i]), // o symbol marker
               .sym_mrkr_pre                   (dl_sym_mrkr_ifft_pre[i]), // o symbol marker
               .sym_mrkr_4x                    (dl_sym_mrkr_4x_ifft[i]), // o symbol marker
               .cp_valid                       (dl_cp_valid[i]),    
               .car_en                         (dl_car_en[i]),
               .ch_bw                          (IFP_cmn_ctrl.dl_car_bw[i]), // input bandwidth b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
	       .dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr[i]),  
               .extended_cp                    (IFP_oran_lphy_ctrl.dl_extended_cp[i]), // input 
               .ch_bw_update_req               (dl_ch_bw_update_req[i]),
               .ch_bw_update_done              (dl_ch_bw_update_done[i]),      
               .ready                          (dl_oran_ready[i]),  // input ready from ORAN.  Data is available to take
               .IFP_ifft_in                    (IFP_dl_oran_ifft[i]),
               .IFP_ifft_out                   (IFP_dl_lphy_out[i]) //to dfe
      );
      end : dl_car_ifft
 */    
      
      //nr
      for (i = 0; i < N_CARRIERS; i = i + 1) begin : dl_car_ifft_nr
      
        assign dl_car_en[i] = |IFP_cmn_ctrl.dl_stream_en[i];
        jb_lte_ifft_4096 #(
               .N_ANTENNAS                     (N_ANTENNAS),
               .USR_ID_BW                      (USR_ID_BW),
               .PRECISION                      (PRECISION),
               .GAIN_SCALER_BW                 (GAIN_SCALER_BW),
               .INST                           (i)
         )  u_jb_lte_ifft_4096  (
               .clk                            (clk_4x), 
               .clk_dfe                        (clk_4x), // input wire CLK
               .reset                          (reset_4x), //use reset_4x when clk_4x is used for 5G
               .reset_dfe                      (reset_4x), // input reset
               .clk_en                         (clk_x4_en[i]),// input clk enable , when clk_4x, connect clk_x4_en[i] for 5G 
               .clk_en_dfe                     (clk_x4_en[i]),
               .clk_frm_mrkr                   (clk_4x), // input clk for framer marker 491.52Mhz expected
               .reset_frm_mrkr                 (reset_4x),  // input reset for framer marker clock
               .frm_mrkr                       (dl_frm_mrkr_10ms_ifft_clk_4x[i]), // one pulse every 10ms
               .sym_mrkr                       (dl_sym_mrkr_ifft_nr[i]), // o symbol marker
               .sym_mrkr_pre                   (dl_sym_mrkr_ifft_pre_nr[i]), // o symbol marker
               .sym_mrkr_4x                    (dl_sym_mrkr_4x_ifft_nr[i]), // o symbol marker
               .cp_valid                       (dl_cp_valid_nr[i]),   //o 
               .car_en                         (dl_car_en[i]),
               .ch_bw                          (IFP_cmn_ctrl.dl_car_bw[i]), // input bandwidth b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
	           .dl_dfe_frm_mrkr                (dl_dfe_frm_mrkr[i]),  //o
               .extended_cp                    (IFP_oran_lphy_ctrl.dl_extended_cp[i]), // input 
               .ch_bw_update_req               (dl_ch_bw_update_req[i]),//i
               .ch_bw_update_done              (dl_ch_bw_update_done_nr[i]), //o     
               .ready                          (dl_oran_ready_nr[i]),  // input ready from ORAN.  Data is available to take                       
               .IFP_ifft_in                    (IFP_dl_oran_ifft_nr[i]),
               .IFP_ifft_out                   (IFP_dl_lphy_out_nr[i]) //to dfe
      );
      end : dl_car_ifft_nr   
endgenerate
   
endmodule
