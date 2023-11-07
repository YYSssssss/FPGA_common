////////////////////////////////////////////////////////////////////
////  File Name : jb_prach_dfe_top
///// Author    : A. Siegel
///// Date      : 8/8/2020
///// Description  : prach top based on jb_dl_dfe_car2ant
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_prach_dfe_top #(

//	  parameter  UL_TIME_DELAY_BYPASS = 0,
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  NCO_COEF_WIDTH =40, //
      parameter  PRECISION=16,
      parameter  USR_ID_BW=2
) (
			input clk_4x,
            input clk_1x,
            input resetn_4x,
            input resetn_1x,	
            input [N_CARRIERS-1:0] prach_fir_resetn,
            logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]	 nco_coef,

            input [N_CARRIERS-1:0] prach_en,
            input [N_CARRIERS-1:0][3:0]               ch_gain_scalar,
            input [N_CARRIERS-1:0][15:0]              ch_gain_fraction,
            input  [N_CARRIERS-1:0]                   ch_gain_scalar_sign,
            input  [31:0]          systimer_ns,
            input [N_CARRIERS-1:0] [3:0]  ch_bw,
            input [N_CARRIERS-1:0] clk_x1en ,  // tied to car_en_input in tb or ul_clk_x1en in lphy_top, should not toggle
            input [N_CARRIERS-1:0] clk_x4en ,
	//       jb_prach_dfe_ctrl_if.prach_dfe IFP_prach_dfe_ctrl,
	        jb_axi4_stream_if.slave  IFP_prach_dfe_in[N_CARRIERS-1:0],  
		    jb_axi4_stream_if.master IFP_prach_dfe_out[N_CARRIERS-1:0]
);
      
   `include  "jb_common.svh"
  
   localparam USER_ID_BW = USR_ID_BW;
   localparam  ILA_EN = 0;
   localparam OVER_SAMPLE_RATIO =4;
 //  localparam NCO_COEF_WIDTH =40;
   localparam NCO_COUNT_WIDTH =39;
   localparam NCO_QUAD_LKUP_TBL_ENTRIES = 1024;
   localparam NCO_COEF_2S_COMPLEMENT=0;
   localparam  GAIN_SCALER_BW=4;
      
   logic [N_CARRIERS-1:0]      tvalid_in ;
   logic [2*PRECISION-1:0]	  tdata_in [N_CARRIERS-1:0];
   logic [USR_ID_BW-1:0]	  tuser_in [N_CARRIERS-1:0];
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]        tvalid_s2p2nco ;
   logic [2*PRECISION-1:0]	  tdata_s2p2nco [N_CARRIERS-1:0] [N_ANTENNAS-1:0];
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]           tvalid_nco2cmbn ;
   logic [2*PRECISION-1:0]	  tdata_nco2cmbn [N_CARRIERS-1:0] [N_ANTENNAS-1:0];

   logic [N_CARRIERS-1:0]  [N_ANTENNAS-1:0]	         tvalid_mixer2p2s  ;
   logic [2*PRECISION-1:0]	  tdata_mixer2p2s [N_CARRIERS-1:0] [N_ANTENNAS-1:0];
   logic [N_CARRIERS-1:0]     tvalid_p2s_out   ;//chnaged this for oring
   logic [2*PRECISION-1:0]	  tdata_p2s_out [N_CARRIERS-1:0] ;
   logic [USER_ID_BW-1:0]	  tuser_p2s_out [N_CARRIERS-1:0];
   logic [N_CARRIERS-1:0] prach_car_en;
   
//    logic [3:0]               ch_gain_scalar;
//    logic [15:0]              ch_gain_fraction;
//    logic                     ch_gain_scalar_sign;
    
    logic           [1:0]     car_bw;   //  move to input
    logic   [PRECISION-1:0]   prach_nco_out_i [N_CARRIERS-1:0];
    logic   [PRECISION-1:0]   prach_nco_out_q [N_CARRIERS-1:0];
    logic   [PRECISION-1:0]   IFP_prach_gain_out_Q[N_CARRIERS-1:0];
    logic   [PRECISION-1:0]   IFP_prach_gain_out_I[N_CARRIERS-1:0];
    logic   [79:0]            fir_U10_m_axis_tdata[N_CARRIERS-1:0];
    logic   [PRECISION-1:0]   IFP_prach_dfe_out_Q[N_CARRIERS-1:0];
    logic   [PRECISION-1:0]   IFP_prach_dfe_out_I[N_CARRIERS-1:0];
    logic                     prach_1x_out_tvalid[1:0];
    logic [1:0] tuser_cnt[N_CARRIERS-1:0];
    logic       tuser_cnt_en[N_CARRIERS-1:0];
    logic [N_CARRIERS-1:0] clk_x4en_d1;
    logic [N_CARRIERS-1:0] clk_x4en_d2;
    logic [N_CARRIERS-1:0] prach_resetn_1x_lat;
    logic [N_CARRIERS-1:0] prach_resetn_1x_soft;
        logic [N_CARRIERS-1:0] prach_resetn_4x_lat;
    logic [N_CARRIERS-1:0] prach_resetn_4x_soft;
      
    (* dont_touch = "true" *) logic   event_s_data_chanid_incorrect[N_CARRIERS-1:0];
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) prach_filter_in[N_CARRIERS-1:0] ();
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) prach_4x_out[N_CARRIERS-1:0] ();
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) prach_nco_out[N_CARRIERS-1:0] ();
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) prach_filter_out[N_CARRIERS-1:0] ();
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) prach_1x_out[N_CARRIERS-1:0] ();
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) prach_gain_out[N_CARRIERS-1:0] ();
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_prach_gain_out[N_CARRIERS-1:0] ();
  jb_prach_dfe_ctrl_if #(.N_CARRIERS(N_CARRIERS), .N_ANTENNAS(N_ANTENNAS), .NCO_COEF_WIDTH(NCO_COEF_WIDTH)) IFP_prach_dfe_ctrl_temp();
  
   logic mux_sel_1;
   logic mux_sel_2;
   logic mux_sel_3;
   logic [7:0] s_axis_config_tdata;
   logic s_axis_config_tvalid;
   logic s_axis_config_tready;
//   assign mux_sel_1=1'b1;  //  1 is mux input b, 20Mhz path
//   assign mux_sel_2=1'b0;  //  0 is mux input a, 20Mhz path
//   assign mux_sel_3=1'b0;  //  0 is mux input a, 20Mhz path
   assign s_axis_config_tdata= 8'h00;
   assign s_axis_config_tvalid= 1'b1;
   assign s_axis_config_tready= 1'b1; 

// assign ch_gain_scalar = (car_bw == BW_15MHZ) ? 1 : 0;
// assign car_bw[1] = 1'b0;   // fix for 20 mhz for now
// assign car_bw[0] = 1'b0;
// assign ch_gain_scalar = car_bw[1] ? (car_bw[0] ? 4'b0011 : 4'b0001) : (car_bw[0] ? 4'b0001 : 4'b0001); 
// assign ch_gain_fraction = car_bw[1] ? (car_bw[0] ? 16'hEEE9 : 16'h047C) : (car_bw[0] ? 16'h0472 : 16'h0465);                            

//   assign ch_gain_scalar_sign = 1'b0;
//   assign ch_gain_scalar = 4'b0000; 
//   assign ch_gain_fraction = 16'hFFFF;
   
//  assign ch_gain_fraction = (car_bw == BW_15MHZ) ? 16'hE429 : 16'hFFFF;//5dB gain for 15Mhz Bandwidth
// assign ch_gain_fraction = car_bw[1] ? (car_bw[0] ? 16'h047B : 16'h047C) : (car_bw[0] ? 16'h0472 : 16'h0465); 

//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[0]  =  {40'h0040100082};
//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[1]  =  {40'h0040100082};
//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[0]  =  {40'h0020000082};
//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[1]  =  {40'h0020000082};
//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[0]  =  {40'h0020000000};   //120KHz
//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[1]  =  {40'h0020000000};
//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[0]  =  {40'h0000000000};
//  assign  IFP_prach_dfe_ctrl_temp.prach_car_nco[1]  =  {40'h0000000000};

 genvar   i,j;
   generate
      for (i = 0; i <  N_CARRIERS; i = i + 1) begin: u_prach_s2p_inst
//	 assign  tvalid_in[i] = IFP_prach_dfe_in[i].tvalid;
//	 assign tdata_in[i] = IFP_prach_dfe_in[i].tdata;
//	 assign tuser_in[i] = IFP_prach_dfe_in[i].tuser;
//	 assign IFP_prach_dfe_in[i].tready = 1'b1;

 
	 
     jb_axis_sync_slowc_fastc #(
        .FAST_TO_SLOW_RATIO     (4),
        .FAST_TO_SLOW_RATIO_BW  (2)
    ) u_prach_dfe_1x_to_4x  (
        .clk_slow_en            (clk_x1en[i]),  // clk_x1en[i]
        .clk_fast_en            (clk_x4en[i]),  // clk_x4en[i]
        .clk_slow               (clk_1x),
        .clk_fast               (clk_4x),
        .resetn                 (resetn_4x), //used at 491.52Mhz clock
        .IFP_axis_in            (IFP_prach_dfe_in[i]),
        .IFP_axis_out           (prach_4x_out[i])
    ); 
    
    
     assign  tvalid_in[i] = prach_4x_out[i].tvalid;
	 assign tdata_in[i] = prach_4x_out[i].tdata;
	 assign tuser_in[i] = prach_4x_out[i].tuser;
//	 assign prach_4x_out[i].tready = 1'b1;
//     assign  tvalid_in[i] = IFP_prach_dfe_in[i].tvalid;
//	 assign tdata_in[i] = IFP_prach_dfe_in[i].tdata;
//	 assign tuser_in[i] = IFP_prach_dfe_in[i].tuser;

 always_ff @(posedge clk_4x) begin 
    clk_x4en_d1[i] <= clk_x4en[i];
    clk_x4en_d2[i] <= clk_x4en_d1[i];
    
  end
  
 
     
      jb_prach_s2p #(
         .N_CARRIERS (N_CARRIERS),
         .N_ANTENNAS (N_ANTENNAS),
         .PRECISION (PRECISION),
	 .USR_ID_BW(USR_ID_BW)		  
      ) u_prach_s2p (
       .clk_1x(clk_1x),
       .clk_4x(clk_4x),
       .clk_en(clk_x4en[i]),  // not used yet
       .resetn_1x(resetn_1x),
       .resetn_4x(resetn_4x),
  //     .IFP_prach_dfe_ctrl(IFP_prach_dfe_ctrl_temp),
       .tvalid_in(tvalid_in[i]),
       .tdata_in(tdata_in[i]),
       .tuser_in(tuser_in[i]),
       .tvalid_out(tvalid_s2p2nco[i]), 
       .tdata_out(tdata_s2p2nco[i])  // tdata_nco2cmbn [N_CARRIERS-1:0] [N_ANTENNAS-1:0]
	  		  
      );
      end : u_prach_s2p_inst
   endgenerate


 jb_prach_mixer #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
       .NCO_COEF_2S_COMPLEMENT(NCO_COEF_2S_COMPLEMENT),
       .NCO_COUNT_WIDTH(NCO_COUNT_WIDTH),
       .NCO_COEF_WIDTH(NCO_COEF_WIDTH),
       .PRECISION (PRECISION),
       .MODE(1) //DL=0, UL=1
   ) u_prach_dfe_mixer  (
       .clk(clk_1x),
       .clk_en (clk_x1en[0]),
       .resetn(resetn_1x),
       .nco_coef(nco_coef),   // use IFP_prach_dfe_ctrl_temp.prach_car_nco for local setting
       .tvalid_in(tvalid_s2p2nco),
       .tdata_in(tdata_s2p2nco),
       .tvalid_out(tvalid_mixer2p2s),  //tvalid_nco2cmbn  [N_CARRIERS-1:0] [N_ANTENNAS-1:0]
       .tdata_out(tdata_mixer2p2s)
   );

 generate
 
    for (i = 0; i <  N_CARRIERS; i = i + 1) begin: u_prach_filter_inst //ul_prach_p2s
    
    jb_prach_p2s #(
           .N_CARRIERS (N_CARRIERS),
           .N_ANTENNAS (N_ANTENNAS),
           .PRECISION (PRECISION),
	   .USR_ID_BW(USR_ID_BW)		  
         ) u_prach_p2s (
           .clk_1x(clk_1x),
           .clk_4x(clk_4x),
           .clk_en (clk_x4en[i]),
           .resetn_1x(resetn_1x),
           .resetn_4x(resetn_4x),
     //      .IFP_prach_dfe_ctrl(IFP_prach_dfe_ctrl_temp),
           .any_stream_enable(prach_en[i]),    //not used yet
           .tvalid_in(tvalid_mixer2p2s[i]),
           .tdata_in(tdata_mixer2p2s[i]),
           .tvalid_out(tvalid_p2s_out[i]),
           .tdata_out(tdata_p2s_out[i]),
           .tuser_out(tuser_p2s_out[i])
	  		  
        );

assign prach_nco_out[i].tvalid = tvalid_p2s_out[i];
assign prach_nco_out[i].tdata = tdata_p2s_out[i];
assign prach_nco_out_i[i]=tdata_p2s_out[i][15:0];
assign prach_nco_out_q[i]=tdata_p2s_out[i][31:16];
assign prach_nco_out[i].tuser = tuser_p2s_out[i];

	//122.88Mhz to 491.52Mhz

//    jb_axis_sync_slowc_fastc #(
//        .FAST_TO_SLOW_RATIO     (4),
//        .FAST_TO_SLOW_RATIO_BW  (2)
//    ) u_prach_dfe_1x_to_4x  (
//        .clk_slow_en            (clk_x1en[i]),
//        .clk_fast_en            (clk_x4en[i]),
//        .clk_slow               (clk_1x),
//        .clk_fast               (clk_4x),
//        .resetn                 (resetn_4x), //used at 491.52Mhz clock
//        .IFP_axis_in            (prach_nco_out[i]),
//        .IFP_axis_out           (prach_4x_out[i])
//    ); 

   assign tuser_cnt_en[i] = tvalid_p2s_out[i] & (tuser_p2s_out[i] == tuser_cnt[i]);

    always_ff @(posedge clk_4x) begin
        if (!resetn_4x) begin
            tuser_cnt[i] <= 2'b00;
        end
        else if (clk_x4en[i]) begin
            if (tuser_cnt_en[i])
                tuser_cnt[i] <= tuser_cnt[i] + 1;
        end
    end
    
    always_ff @(posedge clk_1x) begin	
        prach_resetn_1x_lat[i] <= resetn_1x;
	    prach_resetn_1x_soft[i] <= prach_resetn_1x_lat[i] & resetn_1x;
     end
     always_ff @(posedge clk_4x) begin	
        prach_resetn_4x_lat[i] <= prach_fir_resetn[i];
	    prach_resetn_4x_soft[i] <= prach_resetn_4x_lat[i] & resetn_4x;
     end
   
 
    assign prach_filter_in[i].tvalid = tvalid_p2s_out[i] & (tuser_p2s_out[i] == tuser_cnt[i]);
//    assign prach_filter_in[i].tvalid = tvalid_p2s_out[i];
//    assign prach_filter_in[i].tuser  = tuser_p2s_out[i];
    assign prach_filter_in[i].tuser  = (ch_bw[i]== 4'b0000) ? tuser_p2s_out[i]: tuser_cnt[i];
    assign prach_filter_in[i].tdata  = tdata_p2s_out[i];

     
    jb_prach_filt #(
      .N_CARRIERS (N_CARRIERS),
      .N_ANTENNAS (N_ANTENNAS) ,
      .PRECISION  (PRECISION)
   ) u_prach_filt (
      .aclk (clk_4x),  
      .srst (prach_resetn_4x_soft[i]),    //prach_resetn_4x_soft[i]
      .aclken (clk_x4en[i]),   //was clk_x4en_d2
      .aclken_1x (1'b1),
      .ch_bw  (ch_bw[i]),
  //      .s_axis_config_tdata (s_axis_config_tdata),
  //      .s_axis_config_tvalid (s_axis_config_tvalid), 
  //      .s_axis_config_tready (s_axis_config_tready),
      .IFP_prach_in (prach_filter_in[i]),
      .IFP_prach_out (prach_filter_out[i])     
    );  

    jb_axis_sync_fastc_slowc #(
        .FAST_TO_SLOW_RATIO     (4),
        .FAST_TO_SLOW_RATIO_BW  (2),
        .DATA_BW                (2*PRECISION),
        .USR_ID_BW              (USR_ID_BW)			   
    ) u_prach_4x_to_1x  (
        .clk_slow_en            (1'b1),         // should be clk_x1en[i]
        .clk_fast_en            (1'b1),  // should be clk_x4en[i]
        .clk_slow               (clk_1x),
        .clk_fast               (clk_4x),
			  
        .resetn_clk_fast(prach_resetn_4x_soft[i]),   // should be prach_resetn_4x_soft[i] 
        .resetn_clk_slow(prach_resetn_1x_soft[i]),             // should be prach_resetn_1x_soft[i]
			  
        .IFP_axis_in            (prach_filter_out[i]),
        .IFP_axis_out           (prach_1x_out[i])
    );

   
    jb_iq_gain_mult #(
        .PRECISION                      (PRECISION),
        .SCALER_BW                      (GAIN_SCALER_BW),
        .USR_ID_BW                      (USR_ID_BW)
    ) u_prach_gain_car (
        .clk                            (clk_1x),
        .clk_en                         (1'b1),   // need enable here, was clk_x1en
        .resetn                         (prach_resetn_1x_soft[i]),  //prach_resetn_1x_soft[i]
        .scaler_gain_sign               (ch_gain_scalar_sign[i]),
        .scaler_gain                    (ch_gain_scalar[i]),
        .fraction_gain                  (ch_gain_fraction[i]),			
        .IFP_dfe_in                     (prach_1x_out[i]),
        .IFP_dfe_out                    (prach_gain_out[i])
    );
    
     assign IFP_prach_gain_out[i].tdata = prach_gain_out[i].tdata ;
     assign IFP_prach_gain_out[i].tvalid = prach_gain_out[i].tvalid ;
     assign IFP_prach_gain_out[i].tuser = prach_gain_out[i].tuser ;
    
//     assign IFP_prach_dfe_out[i].tvalid = IFP_prach_gain_out[i].tvalid;
//	 assign IFP_prach_dfe_out[i].tdata = IFP_prach_gain_out[i].tdata;
//	 assign IFP_prach_dfe_out[i].tuser = IFP_prach_gain_out[i].tuser;
     assign IFP_prach_gain_out_Q[i]=IFP_prach_gain_out[i].tdata[31:16];
     assign IFP_prach_gain_out_I[i]=IFP_prach_gain_out[i].tdata[15:0];
    
     
//     ACS_prach_filt U10 (
//  .aresetn                              (resetn_1x),                                              // input wire aresetn
//  .aclk                                 (clk_1x),                                                    // input wire aclk
//  .aclken                               (clk_x1en[i]),                                                // input wire aclken
//  .s_axis_data_tvalid                   (IFP_prach_gain_out[i].tvalid),                        // input wire s_axis_data_tvalid
//  .s_axis_data_tready                   (IFP_prach_gain_out[i].tready),                        // output wire s_axis_data_tready
//  .s_axis_data_tuser                    (IFP_prach_gain_out[i].tuser),                          // input wire [1 : 0] s_axis_data_tuser
//  .s_axis_data_tdata                    (IFP_prach_gain_out[i].tdata),                          // input wire [31 : 0] s_axis_data_tdata
//  .m_axis_data_tvalid                   (IFP_prach_dfe_out[i].tvalid),                        // output wire m_axis_data_tvalid
//  .m_axis_data_tuser                    (IFP_prach_dfe_out[i].tuser),                          // output wire [1 : 0] m_axis_data_tuser
//  .m_axis_data_tdata                    (fir_U10_m_axis_tdata[i]),                          // output wire [79 : 0] m_axis_data_tdata
//  .event_s_data_chanid_incorrect        (event_s_data_chanid_incorrect[i])  // output wire event_s_data_chanid_incorrect
//);

     assign IFP_prach_dfe_out[i].tvalid = IFP_prach_gain_out[i].tvalid;
	 assign IFP_prach_dfe_out[i].tdata = IFP_prach_gain_out[i].tdata;
	 assign IFP_prach_dfe_out[i].tuser = IFP_prach_gain_out[i].tuser;

//   assign IFP_prach_dfe_out_Q[i] = fir_U10_m_axis_tdata[i][64:49];// was 70:55 truncate [54:40]
//   assign IFP_prach_dfe_out_I[i] = fir_U10_m_axis_tdata[i][24:9];//30:15, 39:31 not used
//   assign IFP_prach_dfe_out[i].tdata = {IFP_prach_dfe_out_Q[i],IFP_prach_dfe_out_I[i]};

     
    end: u_prach_filter_inst 
    endgenerate

// ila_prach_nco_2 ila_prach_nco_2_inst (
//	.clk(clk_4x), // input wire clk


//	.probe0(resetn_1x), // input wire [0:0]  probe0  
//	.probe1(clk_x1en), // input wire [0:0]  probe1 
//	.probe2(nco_coef), // input wire [39:0]  probe2 
//	.probe3(tvalid_s2p2nco[0][0]), // input wire [0:0]  probe3 
//	.probe4(tdata_s2p2nco[0][0]), // input wire [31:0]  probe4 
//	.probe5(tvalid_mixer2p2s[0][0]), // input wire [0:0]  probe5 
//	.probe6(tdata_mixer2p2s[0][0]) // input wire [31:0]  probe6
//);
/*
  ila_prach_nco_2 ila_prach_nco_2_inst (
	.clk(clk_1x), // input wire clk


	.probe0(resetn_1x), // input wire [0:0]  probe0  
	.probe1(clk_x1en), // input wire [0:0]  probe1 
	.probe2(nco_coef), // input wire [39:0]  probe2 
	.probe3(tvalid_s2p2nco[0][0]), // input wire [0:0]  probe3 
	.probe4(tdata_s2p2nco[0][0][31:16]), // input wire [15:0]  probe4 
	.probe5(tdata_s2p2nco[0][0][15:0]), // input wire [15:0]  probe5 
	.probe6(tvalid_mixer2p2s[0][0]), // input wire [0:0]  probe6 
	.probe7(tdata_mixer2p2s[0][0][31:16]), // input wire [15:0]  probe7 
	.probe8(tdata_mixer2p2s[0][0][15:0]), // input wire [15:0]  probe8 
	.probe9(IFP_prach_dfe_in[0].tdata[31:16]), // input wire [15:0]  probe9 
	.probe10(IFP_prach_dfe_in[0].tdata[15:0]), // input wire [15:0]  probe10 
	.probe11(IFP_prach_dfe_out[0].tdata[31:16]), // input wire [15:0]  probe11 
	.probe12(IFP_prach_dfe_out[0].tdata[15:0]), // input wire [15:0]  probe12 
	.probe13(tvalid_in[0]), // input wire [0:0]  probe13
	.probe14(systimer_ns), // input wire [31:0]  probe14
	.probe15(IFP_prach_dfe_in[0].tuser), // input wire [1:0]  probe15 
	.probe16(IFP_prach_dfe_out[0].tuser) // input wire [1:0]  probe16
);
*/
//ila_prach_filter ila_prach_filter_inst (
//	.clk(clk_4x), // input wire clk


//	.probe0(clk_x4en), // input wire [0:0]  probe0  
//	.probe1(prach_filter_in[0].tdata[31:16]), // input wire [15:0]  probe1 
//	.probe2(prach_filter_in[0].tdata[15:0]), // input wire [15:0]  probe2 
//	.probe3(prach_filter_in[0].tvalid), // input wire [0:0]  probe3 
//	.probe4(prach_filter_in[0].tuser), // input wire [1:0]  probe4 
//	.probe5(prach_filter_out[0].tdata[31:16]), // input wire [15:0]  probe5 
//	.probe6(prach_filter_out[0].tdata[15:0]), // input wire [15:0]  probe6 
//	.probe7(prach_filter_out[0].tvalid), // input wire [0:0]  probe7 
//	.probe8(prach_filter_out[0].tuser), // input wire [1:0]  probe8
//	.probe9(resetn_4x) // input wire [0:0]  probe9
//);

 
endmodule // jb_prach_dfe_top

                                                                                                              