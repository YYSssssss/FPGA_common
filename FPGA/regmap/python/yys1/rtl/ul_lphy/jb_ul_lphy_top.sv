`timescale 1ns / 1ps

module jb_ul_lphy_top # (
    parameter N_ANTENNAS = 4,
    parameter N_CARRIERS = 1,
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4,
    parameter FH_DATA_WIDTH = 64

) (
     
     input                                  clk_4x, // Clock for FFT
     
     
     input                                  radio_if_clk,
     input                                  radio_if_reset,
    
     input                                  reset_4x,
  
     input [N_CARRIERS-1:0]                 clk_x4_en,
	 input                                  test_mode,
     input [15:0]                           frm_delay_ul_oran,
	 output                                 ul_frm_mrkr_10ms_clk_400,
     //Markers
     //jb_fh_misc_if.lphy                     IFP_fh_misc,
     jb_fh_cc_timing_if.lphy                IFP_fh_cc_timing[N_CARRIERS-1:0], 
     input  [N_CARRIERS-1:0]                ul_frm_mrkr_10ms, 
     input  [N_CARRIERS-1:0]                ul_ch_bw_update_req,   
     output [N_CARRIERS-1:0]                ul_ch_bw_update_done,
     
   
     jb_cmn_ctrl_devided_if.lphy                    IFP_cmn_ctrl,
     jb_oran_lphy_ctrl_devided_if.lphy              IFP_oran_lphy_ctrl,
     jb_oran_lphy_stat_devided_if.ul_oran_lphy      IFP_oran_ul_oran_lphy_stat,

     input [N_ANTENNAS-1:0][24:0]           ul_oran_data_req,
     jb_axi4_stream_if.slave                IFP_ul_lphy_in[N_CARRIERS-1:0], //from DFE
     jb_axi4_stream_if.master               IFP_ul_lphy_out[N_ANTENNAS-1:0]  //to ORAN
    ); 
    
    
  logic   [N_CARRIERS-1:0]        ul_car_en;
  logic   [N_CARRIERS-1:0]        ul_sym_mrkr;
  logic   [N_CARRIERS-1:0]        ul_frm_mrkr;
  logic   [N_CARRIERS-1:0]        ul_cp_valid;    // Not used... More for debug

  wire    [N_CARRIERS-1:0][11:0]  ul_oran_symbol;
  wire    [N_ANTENNAS-1:0][24:0]  ul_oran_request;
  wire    [N_ANTENNAS-1:0]        ul_oran_tready;
  wire    [N_ANTENNAS-1:0][63:0]  ul_oran_tdata;
  wire    [N_ANTENNAS-1:0][7:0]   ul_oran_tkeep;
  wire    [N_ANTENNAS-1:0]        ul_oran_tvalid;
  wire    [N_ANTENNAS-1:0]        ul_oran_tlast;
  
  wire    [N_CARRIERS-1:0]        ul_fft_tready;
  wire    [N_CARRIERS-1:0][31:0]  ul_fft_tdata;
  wire    [N_CARRIERS-1:0][15:0]  ul_fft_tuser;
  wire    [N_CARRIERS-1:0]        ul_fft_tvalid;
  wire    [N_CARRIERS-1:0]        ul_fft_tlast;
  
  logic                           frm_marker_cnt_en;
  logic   [15:0]                  frm_marker_cnt;
  logic                           ul_frm_mrkr_10ms_dlyd;
  logic                           ul_frm_mrkr_10ms_dlyd_1d;
  logic                           ul_frm_mrkr_10ms_dlyd_all;

  jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(14)) IFP_lphy_ul_oran [N_CARRIERS-1:0] ();

  genvar h;
  generate
    for (h=0; h<N_CARRIERS; h++) begin
      assign ul_car_en[h]       = |IFP_cmn_ctrl.ul_stream_en[h];
      assign ul_oran_symbol[h]  = IFP_fh_cc_timing[h].ul_sym_num;
    end
  endgenerate
  
  genvar i;
  generate
    for (i=0; i<N_ANTENNAS; i++) begin
      assign ul_oran_request[i]         = ul_oran_data_req[i][24:0];
      assign ul_oran_tready[i]          = IFP_ul_lphy_out[i].tready;
      assign IFP_ul_lphy_out[i].tdata   = ul_oran_tdata[i];
      assign IFP_ul_lphy_out[i].tkeep   = ul_oran_tkeep[i];
      assign IFP_ul_lphy_out[i].tvalid  = ul_oran_tvalid[i];
      assign IFP_ul_lphy_out[i].tlast   = ul_oran_tlast[i];
    end
  endgenerate

  jb_ul_oran_data #(
    .NA  (N_ANTENNAS),
    .NC  (N_CARRIERS),
    .CB  (4)                /* Number of bits for debug counters... */
    )
    jb_ul_oran_data_inst (
      .clkin            (clk_4x   ),
      .rstin            (reset_4x ),
      .clkout           (radio_if_clk   ),
      .rstout           (radio_if_reset ),
      
      .ul_car_en        (ul_car_en),
      .ul_car_bw        (IFP_cmn_ctrl.ul_car_bw),
      .ul_swap_fft      (IFP_oran_lphy_ctrl.ul_swap_fft),
      .ul_endianness    (IFP_oran_lphy_ctrl.ul_iq_endianness),
      .ul_fifo_reset    (IFP_oran_lphy_ctrl.ul_lphy_oran_fifo_reset),
      
      .ul_oran_symbol   (ul_oran_symbol ),
      .ul_oran_request  (ul_oran_request),
      .ul_oran_tready   (ul_oran_tready ),
      .ul_oran_tdata    (ul_oran_tdata  ),
      .ul_oran_tkeep    (ul_oran_tkeep  ),
      .ul_oran_tvalid   (ul_oran_tvalid ),
      .ul_oran_tlast    (ul_oran_tlast  ),

      .ul_fft_tready    (ul_fft_tready  ),
      .ul_fft_tdata     (ul_fft_tdata   ),
      .ul_fft_tuser     (ul_fft_tuser   ),
      .ul_fft_tvalid    (ul_fft_tvalid  ),
      .ul_fft_tlast     (ul_fft_tlast   ),
      .ul_fft_clken     (clk_x4_en       ),
      
      .clear              (IFP_oran_lphy_ctrl.ul_lphy_oran_clear),
      .vld_wo_rdy_err_cnt (IFP_oran_ul_oran_lphy_stat.ul_lphy_oran_vld_wo_rdy   ),
      .fifo_ovfl_err_cnt  (IFP_oran_ul_oran_lphy_stat.ul_lphy_oran_fifo_overflow),
      .stale_reqs_err_cnt (IFP_oran_ul_oran_lphy_stat.ul_lphy_oran_stale_reqs   ),
      .stale_prbs_err_cnt (IFP_oran_ul_oran_lphy_stat.ul_lphy_oran_stale_prbs   )
      );
 
  genvar j;
  generate
    for (j=0; j<N_CARRIERS; j++) begin  : nr100m_fft
      assign IFP_lphy_ul_oran[j].tready = ul_fft_tready[j];
      assign ul_fft_tdata[j]            = IFP_lphy_ul_oran[j].tdata;
      assign ul_fft_tuser[j]            = {ul_frm_mrkr[j], ul_sym_mrkr[j], IFP_lphy_ul_oran[j].tuser};
      assign ul_fft_tvalid[j]           = IFP_lphy_ul_oran[j].tvalid;
      assign ul_fft_tlast[j]            = IFP_lphy_ul_oran[j].tlast;      


//tyh change for frm    
always @(posedge clk_4x)
begin
    if(ul_frm_mrkr_10ms==1'b1)
	    frm_marker_cnt_en <= 1'b1 ;
    else
        frm_marker_cnt_en <= frm_marker_cnt_en ;   	
end

always @(posedge clk_4x)
begin
    if(ul_frm_mrkr_10ms==1'b1)
	    frm_marker_cnt <= 16'd0 ;
    else if(frm_marker_cnt==16'd32768)
        frm_marker_cnt <= 16'd32768 ;	
	else if(frm_marker_cnt_en==1'b1)
        frm_marker_cnt <= frm_marker_cnt + 16'd1 ;	
end

always @(posedge clk_4x)
begin
    if(frm_marker_cnt==frm_delay_ul_oran)
          ul_frm_mrkr_10ms_dlyd <= 1'b1 ;
    else 
	      ul_frm_mrkr_10ms_dlyd <= 1'b0 ;
end

always @(posedge clk_4x)
begin
	  ul_frm_mrkr_10ms_dlyd_1d <= ul_frm_mrkr_10ms_dlyd ;
	  ul_frm_mrkr_10ms_dlyd_all <= ul_frm_mrkr_10ms_dlyd | ul_frm_mrkr_10ms_dlyd_1d ;
end

    jb_edge_det #(
        .SYNC_EN            (1),
        .SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1),//pos
	    .RETIME_OUTPUT      (1)
    ) u_ul_frm_mrkr_1x_to_400 (
        .clk                (radio_if_clk),
        .mask               (1'b0),
        .din                (ul_frm_mrkr_10ms_dlyd_all),
        .din_syncd          (),
        .dout               (ul_frm_mrkr_10ms_clk_400)
    );	
	
	
    jb_nr100m_fft #(
               .N_ANTENNAS      (N_ANTENNAS),
               .USR_ID_BW       (USR_ID_BW),
               .PRECISION       (PRECISION),
               .GAIN_SCALER_BW  (GAIN_SCALER_BW),
               .INST            (j)
        ) u_jb_nr100m_fft  (
	           .clk              (clk_4x),              
               .clk_en           (clk_x4_en),
               .reset            (reset_4x),
               .frm_mrkr         (ul_frm_mrkr_10ms[j]),
               .car_en           (ul_car_en[j]),
	           .test_mode        (test_mode),
               .IFP_fft_in       (IFP_ul_lphy_in[j]),
               .ch_bw            (IFP_cmn_ctrl.ul_car_bw[j]), 
               .extended_cp      (IFP_oran_lphy_ctrl.ul_extended_cp[j]),
               .ch_bw_update_req (ul_ch_bw_update_req[j]),
			   .ch_bw_update_done(ul_ch_bw_update_done[j]),
               .sym_mrkr_out     (ul_sym_mrkr[j]),
    
               .IFP_fft_out      (IFP_lphy_ul_oran[j]),   
              
               .frm_mrkr_out     (ul_frm_mrkr[j]),      
               .subfrm_mrkr_out  (),      
               .slot_mrkr_out    ()       
		
		);
    end : nr100m_fft
  endgenerate
endmodule
