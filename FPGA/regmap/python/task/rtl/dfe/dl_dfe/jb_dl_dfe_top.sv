////////////////////////////////////////////////////////////////////
////  File Name : jb_top_ctrl_cfg.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2018
///// Description  : DL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dl_dfe_top #(

      parameter  DL_TIME_DELAY_BYPASS=1,
    parameter                       N_CARRIERS=2,
    parameter                       N_ANTENNAS=4,
    parameter                       PRECISION=16,
    parameter                       GAIN_SCALER_BW=4,
    parameter                       NCO_COEF_WIDTH =40
) (
    input [N_CARRIERS-1:0]                          car_resetn  ,
    input [N_CARRIERS-1:0]                          clk_x1en    ,
    input [N_CARRIERS-1:0]                          clk_x4en    ,
    input [N_CARRIERS-1:0]                          clk_x8en    ,
    input [N_CARRIERS-1:0]                          clk_x16en   ,
    input                           clk_1x,
    input                           clk_3x,
    input                           clk_4x,
    input  resetn_1x,
    input  resetn_4x,
    input  resetn_3x,
    input  Error_10ms,
 
    input                           axi_clk,
    input                           axi_resetn,
	//input         [3:0]             rf_odp_ant_mute,
    input                           rssi_load,
    input  [N_CARRIERS-1:0]         dl_dfe_frm_mrkr,
    jb_axi4_stream_if.master         IFP_dpd_s_axis_din,         // 128,32
    jb_axi4_stream_if.slave          IFP_dpd_m_axis_dout,        // 128,32
    jb_axi4_stream_if.master         IFP_cfr_s_axis_din,         // 128,1
    jb_axi4_stream_if.slave          IFP_cfr_m_axis_dout,        // 128,1
//    input                           IFP_iwavebuf_porta_rst,
//    input                           IFP_iwavebuf_porta_clk,	
//    jb_ram_sp_if.mem                IFP_iwavebuf_porta,
    jb_dl_dfe_ctrl_devided_if.dl_dfe IFP_dl_dfe_ctrl,
    jb_cmn_ctrl_devided_if.cmd_dfe   IFP_cmn_ctrl,
    jb_dl_dfe_rfc_if.dl_dfe          IFP_rfc,

    jb_dl_dfe_stat_devided_if.dl_dfe IFP_dl_dfe_stat,
    // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
    // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
    jb_axi4_stream_if.slave          IFP_dl_dfe_in[N_CARRIERS-1:0],
//    jb_axi4_stream_if.slave         IFP_dl_dfe_in_from_fhbuf,

    //DPD outputs 2 arrays of axi stream
    jb_axi4_stream_if.master         IFP_dl_dfe_out[N_ANTENNAS-1:0] //{,i}- cocatenated

);

   localparam USR_ID_BW = $clog2(N_ANTENNAS);
   localparam OVER_SAMPLE_RATIO =4;
   localparam INST_CFR=1;
   localparam INST_DPD=1;
   localparam ILA_EN = 0;
     
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_instage2gain[N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_gain2conv[N_CARRIERS-1:0]();

   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ps_in[N_CARRIERS-1:0]();
   
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_chan_filt_dout[N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_conv2car[N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_car2ncocmbn[N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_car_ant_delay[N_CARRIERS-1:0]();
//   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_ncocmbn2cdc[N_ANTENNAS-1:0]();

   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_ncocmbn2cdc[N_ANTENNAS-1:0][N_CARRIERS-1:0]();


   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_cdc2ant[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dl_dfe_out_FTD[N_ANTENNAS-1:0](); 
   
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]        tvalid_s2p2nco ;
   logic [2*PRECISION-1:0]	  tdata_s2p2nco [N_CARRIERS-1:0] [N_ANTENNAS-1:0];

   //localparam  NCO_COEF_WIDTH =40;
   localparam  NCO_COUNT_WIDTH=39;
   localparam  NCO_COEF_2S_COMPLEMENT=0;
   localparam  NCO_QUAD_LKUP_TBL_ENTRIES=1024;
   
   logic  [N_CARRIERS-1:0]                      dl_stream_sel_gain_scaler_sign; // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [GAIN_SCALER_BW-1:0] dl_stream_sel_gain_scaler;      // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [15:0]               dl_stream_sel_gain_fraction;    // Carrier0 in Antenna 0 Path  Gain Register

   logic  [N_CARRIERS-1:0]  [N_ANTENNAS-1:0]    dl_stream_gain_scaler_sign_cfg; // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0][GAIN_SCALER_BW-1:0]    dl_stream_gain_scaler_cfg;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0] [15:0]    dl_stream_gain_fraction_cfg;  // Carrier0 in Antenna 0 Path  Gain Register

   logic [N_CARRIERS-1:0] [USR_ID_BW-1:0] 	     gain_usr_id;
   logic  [N_ANTENNAS-1:0] [N_CARRIERS-1:0] dl_stream_ant_car_en;
   logic  [N_ANTENNAS-1:0] dl_ant_en;
   logic  [N_ANTENNAS-1:0] 	ant_path_enable;
   logic 	any_stream_enable;
   logic [N_CARRIERS-1:0] dl_car_en;

   logic [N_CARRIERS-1:0]   car_resetn_1x_soft;
   logic [N_CARRIERS-1:0]   car_resetn_1x_lat;

   
   logic [N_CARRIERS-1:0]   car_resetn_4x_soft;
   logic [N_CARRIERS-1:0]   car_resetn_4x_lat;
   logic 	clear_ovrfl_undfl_pulse;
    logic [1:0] tuser_cnt[1:0];
    logic       tuser_cnt_en[1:0];
   
      genvar  i,j;


   logic      rssi_load_clk_1x;
   
   
   assign     IFP_dl_dfe_stat.fir_3x_ant0to3_sat_err_status=0;
   //assign     IFP_dl_dfe_stat.fir_3x_ant4to7_sat_err_status=0;   
   assign     IFP_dl_dfe_stat.poly_even_ant0to3_sat_err_status=0;
   //assign     IFP_dl_dfe_stat.poly_even_ant4to7_sat_err_status=0;     
   assign     IFP_dl_dfe_stat.poly_odd_ant0to3_sat_err_status=0;
   //assign     IFP_dl_dfe_stat.poly_odd_ant4to7_sat_err_status=0;
   //assign     IFP_dl_dfe_stat.ps_sat_err_status=0;
   //assign     IFP_dl_dfe_stat.car_inrtp_sat_err_status='{default:0};
   
   jb_edge_det #(
        .SYNC_EN            (1),
	.SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (4),
        .PULSE_POLARITY     (1),//pos
	.RETIME_OUTPUT      (0)
    ) u_dl_test_mode_start_pulse (
        .clk                (clk_4x),
        .mask               (1'b0),
        .din                (IFP_dl_dfe_ctrl.clear_sat_flags),
        .din_syncd          (),
        .dout               (clear_ovrfl_undfl_pulse)
    );

   //any_stream_enable is set if anu one of the stream is enabled
   assign any_stream_enable = |dl_ant_en;
generate
    for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: dl_dfe_ant_enable_bus	
        for (j = 0; j <  N_CARRIERS; j = j + 1) begin: dl_dfe_car_enable	
            assign dl_stream_ant_car_en[i][j] = IFP_cmn_ctrl.dl_stream_en[j][i];
        end :dl_dfe_car_enable
    end: dl_dfe_ant_enable_bus

   	
   for (j = 0; j <  N_CARRIERS; j = j + 1) begin: reset_mux
     always @(posedge clk_1x) begin	
        car_resetn_1x_lat[j] <= car_resetn[j];
	    car_resetn_1x_soft[j] <= car_resetn_1x_lat[j] & resetn_1x;
     end
     always @(posedge clk_4x) begin	
        car_resetn_4x_lat[j] <= car_resetn[j];
	    car_resetn_4x_soft[j] <= car_resetn_4x_lat[j] & resetn_4x;
     end
   end :reset_mux
endgenerate    

   
//ila_1_for_dfe dfe_input(
//	.clk(clk_4x), 
//	.probe0(IFP_dl_dfe_in[0].tdata[15:0]), 
//	.probe1(IFP_dl_dfe_in[0].tdata[31:16]), 
//	.probe2(IFP_dl_dfe_in[0].tuser), 
//	.probe3(IFP_dl_dfe_in[0].tvalid) 
//);
     
    jb_dl_dfe_input_stage #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION (PRECISION),
       .OVER_SAMPLE_RATIO(OVER_SAMPLE_RATIO) //real rate to core clock
   ) u_dl_dfe_input_stage  (       
    //   .clk_x1en (clk_x1en),
    //   .clk_x4en (clk_x4en),       
         .clk_x1en (2'b11),
         .clk_x4en (2'b11),
       .clk_1x(clk_1x),
       .clk_4x(clk_4x),
       .resetn(resetn_1x),
//       .resetn(resetn),
       .dl_dfe_frm_mrkr(dl_dfe_frm_mrkr),
//       .IFP_iwavebuf_porta_rst  (IFP_iwavebuf_porta_rst),
//       .IFP_iwavebuf_porta_clk  (IFP_iwavebuf_porta_clk),
//       .IFP_iwavebuf_porta      (IFP_iwavebuf_porta),
     //.rf_odp_ant_mute        (rf_odp_ant_mute),
       .rf_odp_ant_mute        (IFP_rfc.rf_overdrive_mute),
       .IFP_cmn_ctrl           (IFP_cmn_ctrl),
       .IFP_dl_dfe_ctrl        (IFP_dl_dfe_ctrl),
       .IFP_dl_dfe_in          (IFP_dl_dfe_in),
//       .IFP_dl_dfe_in_from_fhbuf(IFP_dl_dfe_in_from_fhbuf),	   
       .IFP_dl_dfe_out         (IFP_dl_dfe_instage2gain) //{q,i} concatenated	   
	   
   );


 // Assign Packed to unpacked.
  logic signed [6:0] reg_temp [1:0] [3:0]; 
  assign reg_temp[0][0] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[0][0]);
  assign reg_temp[0][1] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[0][1]);
  assign reg_temp[0][2] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[0][2]);
  assign reg_temp[0][3] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[0][3]);
  assign reg_temp[1][0] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[1][0]);
  assign reg_temp[1][1] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[1][1]);
  assign reg_temp[1][2] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[1][2]);
  assign reg_temp[1][3] = $signed(IFP_dl_dfe_ctrl.dl_int_delay[1][3]);
 
  logic signed [15:0] reg_temp2 [1:0] [3:0]; 
  assign reg_temp2[0][0] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[0][0]);
  assign reg_temp2[0][1] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[0][1]);
  assign reg_temp2[0][2] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[0][2]);
  assign reg_temp2[0][3] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[0][3]);
  assign reg_temp2[1][0] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[1][0]);
  assign reg_temp2[1][1] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[1][1]);
  assign reg_temp2[1][2] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[1][2]);
  assign reg_temp2[1][3] = $signed(IFP_dl_dfe_ctrl.dl_frac_delay[1][3]);
   
  jb_pulse_stretch #(
	.PULSE_WIDTH(4)
  ) u_rssi_load_stretch (
	.clk(clk_1x),
	.din(rssi_load),
	.dout(rssi_load_clk_1x)
  );
   
      	     
 
      
    jb_iq_rssi #(
        .SAMPLE_BW              (PRECISION),
        .USR_ID_BW              (USR_ID_BW),
        .N_USRS                 (N_ANTENNAS),
        .WRSSI                  (0) //log2(100ms@30.74)+30
    ) u_iq_rssi (
        .clk                    (clk_1x),
        .clk_en                 (clk_x1en[0]),
        .resetn                 (car_resetn_1x_soft[0]),
        .tvalid                 (IFP_dl_dfe_instage2gain[0].tvalid),
        .tdata                  (IFP_dl_dfe_instage2gain[0].tdata),
        .tusr                   (IFP_dl_dfe_instage2gain[0].tuser),
	.rssi_load              (rssi_load_clk_1x),
	.rssi_value             (IFP_dl_dfe_stat.ant_fh_tssi)
    );


logic [1:0] [79:0] fir_tdata  ;	
logic [1:0] [17:0] fir_tdata_i;   
logic [1:0] [17:0] fir_tdata_q;
logic [1:0]        fir_tvalid ;
logic [1:0] [1:0]  fir_tuser  ;  
logic [1:0]        fir_tvalid_d1 ;
logic [1:0] [1:0]  fir_tuser_d1  ;  
logic [1:0] [15:0] fir_dout_i ;
logic [1:0] [15:0] fir_dout_q ;  
logic [1:0] [24:0] s_rnd_dout;  

generate
for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_gain_inst
    for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: dl_dfe_ant_gain_inst
        always @(posedge clk_1x) begin //no reset,  already config gets reset in the reg block
        if (clk_x1en[i]) begin
            dl_stream_gain_scaler_sign_cfg[i][j]<=IFP_dl_dfe_ctrl.dl_stream_gain_scaler_sign[i][j];
            dl_stream_gain_scaler_cfg[i][j]<=IFP_dl_dfe_ctrl.dl_stream_gain_scaler[i][j];
            dl_stream_gain_fraction_cfg[i][j]<=IFP_dl_dfe_ctrl.dl_stream_gain_fraction[i][j];
        end
	end
	end :   dl_dfe_ant_gain_inst

	 assign gain_usr_id[i] = IFP_dl_dfe_instage2gain[i].tuser;
	 assign dl_stream_sel_gain_scaler_sign[i] = dl_stream_gain_scaler_sign_cfg[i][gain_usr_id[i]];
	 assign dl_stream_sel_gain_scaler[i] = dl_stream_gain_scaler_cfg[i][gain_usr_id[i]]; 
	 assign dl_stream_sel_gain_fraction[i] = dl_stream_gain_fraction_cfg[i][gain_usr_id[i]]; 

    //instantiate gain block
	jb_iq_gain_mult #(
        .PRECISION              (PRECISION),
        .SCALER_BW              (GAIN_SCALER_BW),
        .USR_ID_BW              (USR_ID_BW)
	) u_iq_stream_gain_car (
        .clk_en                 (clk_x1en[i]),
        .clk                    (clk_1x),
        .resetn                 (car_resetn_1x_soft[i]),
	    .scaler_gain_sign       (dl_stream_sel_gain_scaler_sign[i]),
	    .scaler_gain            (dl_stream_sel_gain_scaler[i]),
	    .fraction_gain          (dl_stream_sel_gain_fraction[i]),			
	    .IFP_dfe_in             (IFP_dl_dfe_instage2gain[i]),
        .IFP_dfe_out            (IFP_dl_dfe_gain2conv[i])
	);
	


assign tuser_cnt_en[i] = IFP_dl_dfe_gain2conv[i].tvalid & (IFP_dl_dfe_gain2conv[i].tuser == tuser_cnt[i]);

always_ff @(posedge clk_1x) begin
    if (!resetn_1x) begin
        tuser_cnt[i] <= '0;
    end
    else if (clk_x4en) begin
        if (tuser_cnt_en[i])
            tuser_cnt[i] <= tuser_cnt[i] + 1;
    end
end




assign IFP_ps_in[i].tvalid = IFP_dl_dfe_gain2conv[i].tvalid & (IFP_dl_dfe_gain2conv[i].tuser == tuser_cnt[i]);
assign IFP_ps_in[i].tuser  = IFP_dl_dfe_gain2conv[i].tuser;
assign IFP_ps_in[i].tdata  = IFP_dl_dfe_gain2conv[i].tdata;


   
      fir_singlerate_122p88 u_fir_singlerate_122p88 (
        .aresetn                        (car_resetn_4x_soft[i]         ),      
        .aclk                           (clk_1x                        ),      
        .aclken                         (clk_x4en[i]                   ),
		.s_axis_data_tvalid             (IFP_ps_in[i].tvalid),    
        .s_axis_data_tuser              (IFP_ps_in[i].tuser ),
        .s_axis_data_tdata              (IFP_ps_in[i].tdata ),     
        .m_axis_data_tvalid             (fir_tvalid[i]                 ),     
        .m_axis_data_tdata              (fir_tdata[i]                  ),     
        .m_axis_data_tuser              (fir_tuser[i]                  ), 
        .s_axis_data_tready             (),     
        .event_s_data_chanid_incorrect  ()  
    );	
	
   assign fir_tdata_i[i]= fir_tdata[i][32:15];
   assign fir_tdata_q[i]= fir_tdata[i][72:55];	
   

//   jb_ovrfl_undfl_det #(
//      .INPUT_DATA_BUS_WIDTH(18),
//      .OUTPUT_DATA_BUS_WIDTH(16)
//   ) u_intrp_i_ovrfl_undfl_det (
//     .clk                             (clk_1x          ),
//     .resetn                          (resetn          ),
//     .clk_en                          (clk_x4en[i]     ),
//     .data_in                         (fir_tdata_i[i]  ),
//     .data_out                        (fir_dout_i[i]   ),
//     .ovrfl_undfl_flag_msb_plus1_flag (),
//     .ovrfl_undfl_flag_all_msb_flag   ()   
//);
//
//    jb_ovrfl_undfl_det #(
//      .INPUT_DATA_BUS_WIDTH(18),
//      .OUTPUT_DATA_BUS_WIDTH(16)
//   ) u_intrp_q_ovrfl_undfl_det (
//     .clk                             (clk_1x        ),
//     .resetn                          (resetn        ),
//     .clk_en                          (clk_x4en[i]   ),
//     .data_in                         (fir_tdata_q[i]),
//     .data_out                        (fir_dout_q[i] ),
//     .ovrfl_undfl_flag_msb_plus1_flag ( ),
//     .ovrfl_undfl_flag_all_msb_flag   ( )
//   
//
//);

        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_chan_i
            ( 
            .i_rst       (1'b0                   ),
            .i_clk       (clk_1x                 ),   
            .i_data      (fir_tdata[i][39:0]  ),    
            .o_data      (fir_dout_i[i]  )
            );      

        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_chan_q
            ( 
            .i_rst       (1'b0                    ),
            .i_clk       (clk_1x                  ),   
            .i_data      (fir_tdata[i][79:40]  ),    
            .o_data      (fir_dout_q[i]   )
            );


always @(posedge clk_1x)
begin
  fir_tvalid_d1 <= fir_tvalid;
  fir_tuser_d1  <= fir_tuser ;
end

assign IFP_chan_filt_dout[i].tdata  = {fir_dout_q[i],fir_dout_i[i]};
assign IFP_chan_filt_dout[i].tvalid = fir_tvalid_d1                ;
assign IFP_chan_filt_dout[i].tuser  = fir_tuser_d1                 ; 	

	//122.88Mhz ot 491.52Mhz
//    jb_axis_sync_slowc_fastc #(
//        .FAST_TO_SLOW_RATIO     (4),
//        .FAST_TO_SLOW_RATIO_BW  (2)
//    ) u_dl_dfe_1x_to_4x  (
//        .clk_slow_en            (clk_x1en[i]),
//        .clk_fast_en            (clk_x4en[i]),
//        .clk_slow               (clk_1x),
//        .clk_fast               (clk_4x),
//        .resetn                 (car_resetn_4x_soft[i]), //used at 491.52Mhz clock
//        .IFP_axis_in            (IFP_dl_dfe_gain2conv[i]),
//        .IFP_axis_out           (IFP_dl_dfe_conv2car[i])
//    );
  end : dl_dfe_gain_inst
   
//   for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_car_inst
//     assign dl_car_en[i] = |IFP_cmn_ctrl.dl_stream_en[i];
//	//runs at 491.52MHz
//	jb_dl_dfe_car #(
//        .N_CARRIERS             (N_CARRIERS),
//        .N_ANTENNAS             (N_ANTENNAS),
//        .PRECISION              (PRECISION)
//    ) u_dl_dfe_car  (
//        .clk_x4en               (clk_x4en[i]),
//        .clk_x8en               (clk_x8en[i]),
//        .clk_x16en              (clk_x16en[i]),
//        .clear_ovrfl_undfl_pulse (clear_ovrfl_undfl_pulse),
//        .clk_4x                 (clk_4x),
//        .clk_8x                 (clk_4x),   // Effective freq with clk_en is 246.76 for 5MHz BW and 491.52 for 10MHz BW. Disabled for other BW settings.
//        .clk_16x                (clk_4x),   // Effective freq with clk_en is 491.52 for 5MHz BW. Disabled for other BW settings.
//        .resetn                 (car_resetn_4x_soft[i]), 
//        .car_bw                 (IFP_cmn_ctrl.dl_car_bw[i]),
//        .ps_filter_bypass       (IFP_dl_dfe_ctrl.ps_filter_bypass),
//	.car_inrtp_sat_err_status (IFP_dl_dfe_stat.car_inrtp_sat_err_status[i]),
//	.ps_sat_err_status      (IFP_dl_dfe_stat.ps_sat_err_status[i]),
//        .IFP_dl_dfe_in          (IFP_dl_dfe_conv2car[i]),
//        .IFP_dl_dfe_out         (IFP_dl_dfe_car2ncocmbn[i])   
//	);
//   end :   dl_dfe_car_inst
   
      // Time Delay Module
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////// FRACTIONAL INTERPOLATOR ///////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////    

//    for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_time_delay_inst
//    jb_dl_dfe_time_delay #(
//          .N_CARRIERS (N_CARRIERS),
//          .N_ANTENNAS (N_ANTENNAS),
//          .PRECISION  (PRECISION)
//        ) u_dl_dfe_time_delay  (
//          .clk_4x           (clk_4x),
//          .clk_1x           (clk_1x),
//          .resetn_1x           (resetn_1x),
//          .resetn_4x           (resetn_4x),
//          .frt_delay        (reg_temp2[i]),   //[15:0]
//          .int_delay        (reg_temp[i]),    //[6:0]
//          .time_reg_trigger (IFP_dl_dfe_ctrl.dl_ant_int_frac_delay_trig),                 
////          .IFP_dfe_delay_in (IFP_dl_dfe_car2ncocmbn[i]),
//          .IFP_dfe_delay_in (IFP_chan_filt_dout[i]),//[zle]modification for mintaka
//          .tvalid_s2p2nco   (tvalid_s2p2nco[i]), // tvalid[1:0][3:0]
//          .tdata_s2p2nco    (tdata_s2p2nco[i]) // [31:0] tdata[1:0][3:0]
//    );
//end : dl_dfe_time_delay_inst
endgenerate

    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_car2ncocmbn_temp[N_CARRIERS-1:0]();

    assign IFP_dl_dfe_car2ncocmbn_temp[0].tuser  = IFP_chan_filt_dout[0].tuser;
    assign IFP_dl_dfe_car2ncocmbn_temp[0].tvalid = IFP_chan_filt_dout[0].tvalid;
    assign IFP_dl_dfe_car2ncocmbn_temp[0].tdata  = IFP_chan_filt_dout[0].tdata;
    //assign IFP_dl_dfe_car2ncocmbn_temp[1].tuser  = IFP_chan_filt_dout[1].tuser;
    //assign IFP_dl_dfe_car2ncocmbn_temp[1].tvalid = IFP_chan_filt_dout[1].tvalid;
    //assign IFP_dl_dfe_car2ncocmbn_temp[1].tdata  = IFP_chan_filt_dout[1].tdata; 
    
     //s2p, mixer runs at 122.88Mhz
     jb_dl_dfe_car2ant #(
       .DL_TIME_DELAY_BYPASS     (DL_TIME_DELAY_BYPASS),
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
       .NCO_COEF_2S_COMPLEMENT(NCO_COEF_2S_COMPLEMENT),
       .NCO_COUNT_WIDTH(NCO_COUNT_WIDTH),
       .NCO_COEF_WIDTH(NCO_COEF_WIDTH),
       .PRECISION (PRECISION)
   ) u_dl_dfe_car2ant  (
       .clk_4x(clk_4x),
       .clk_1x(clk_1x),
       .resetn_4x(resetn_4x),
       .resetn_1x(resetn_1x),
       .any_stream_enable(any_stream_enable),
       .IFP_dl_dfe_in    (IFP_dl_dfe_car2ncocmbn_temp),
       .IFP_dl_dfe_ctrl  (IFP_dl_dfe_ctrl),
       .tvalid_s2p2nco_in(tvalid_s2p2nco),
       .tdata_s2p2nco_in (tdata_s2p2nco), // [31:0] tdata[1:0][3:0]
       .IFP_dl_dfe_out   (IFP_dl_dfe_ncocmbn2cdc)   
   );



   // need a separate sync becasue there is ant delay before this
   // So data may not be aligned based on delay
//generate
//for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: clk_1x_to_3x
//	 //122.88M to 368.64M
//	jb_axis_sync_slowc_fastc #(
//        .FAST_TO_SLOW_RATIO     (3),
//        .FAST_TO_SLOW_RATIO_BW  (2)
//    ) u_dl_dfe_1x_to_3x (
//        .clk_slow_en            (1'b1),
//        .clk_fast_en            (1'b1),
//        .clk_slow               (clk_1x),
//        .clk_fast               (clk_3x),
//        .resetn                 (resetn_3x),
//        .IFP_axis_in            (IFP_dl_dfe_ncocmbn2cdc[j]),
//        .IFP_axis_out           (IFP_dl_dfe_cdc2ant[j])
//    );
//end : clk_1x_to_3x
//endgenerate
 
  
   jb_dl_dfe_ant #(
       .NCO_COEF_WIDTH(NCO_COEF_WIDTH),   
       .N_CARRIERS    (N_CARRIERS    ),   
       .N_ANTENNAS    (N_ANTENNAS    ),
       .PRECISION     (PRECISION     ),
       .GAIN_SCALER_BW(GAIN_SCALER_BW),
       .INST_CFR      (INST_CFR      ),
       .INST_DPD      (INST_DPD      )
   ) u_dl_dfe_ant  (
       .clk_3x                          (clk_4x),
       .resetn                          (resetn_4x),
       .axi_clk                         (axi_clk),
       .axi_resetn                      (axi_resetn),
       .Error_10ms                      (Error_10ms),
       .rssi_load                       (rssi_load),
	   .any_stream_enable               (any_stream_enable),
       .IFP_dpd_s_axis_din              (IFP_dpd_s_axis_din),
       .IFP_dpd_m_axis_dout             (IFP_dpd_m_axis_dout),
								        
       .IFP_cfr_s_axis_din              (IFP_cfr_s_axis_din),
       .IFP_cfr_m_axis_dout             (IFP_cfr_m_axis_dout),
       .IFP_dl_dfe_ctrl                 (IFP_dl_dfe_ctrl),
       .IFP_rfc                         (IFP_rfc),          // jb_dl_dfe_rfc_if.dl_dfe
								        
//       .IFP_dl_dfe_in                   (IFP_dl_dfe_cdc2ant),

       .IFP_dl_dfe_in                   (IFP_dl_dfe_ncocmbn2cdc),
   
       .IFP_dl_dfe_out                  (IFP_dl_dfe_out),
       .real_bypass_dpd                 (IFP_dl_dfe_stat.bypass_dpd),
       .dl_postcfr_gain_scaler_sign_cfg (IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler_sign),
       .dl_postcfr_gain_scaler_cfg      (IFP_dl_dfe_stat.dl_ant_postcfr_gain_scaler),
       .dl_postcfr_gain_fraction_cfg    (IFP_dl_dfe_stat.dl_ant_postcfr_gain_fraction)
   );

//ila_1_for_dfe chan_122(
//	.clk(clk_4x), 
//	.probe0(IFP_chan_filt_dout[0].tdata[15:0]), 
//	.probe1(IFP_chan_filt_dout[0].tdata[31:16]), 
//	.probe2(IFP_chan_filt_dout[0].tuser), 
//	.probe3(IFP_chan_filt_dout[0].tvalid) 
//);

//generate
//if (ILA_EN==1) begin : ila_dbg_en
//	ila_0 u_ila_input_stage (
//	   .clk(clk_3x), // input wire clk
//	   .probe0(IFP_dl_dfe_instage2gain[0].tvalid), // input wire [0:0]  probe0  
//	   .probe1(IFP_dl_dfe_instage2gain[0].tuser), // input wire [1:0]  probe1 
//	   .probe2(IFP_dl_dfe_instage2gain[0].tdata) // input wire [31:0]  probe2
//    );

//    ila_0 u_ila_conv_stage (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_dl_dfe_conv2car[0].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_dl_dfe_conv2car[0].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_dl_dfe_conv2car[0].tdata) // input wire [31:0]  probe2
//    );

//    ila_0 u_ila_car_stage (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_dl_dfe_car2ncocmbn[0].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_dl_dfe_car2ncocmbn[0].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_dl_dfe_car2ncocmbn[0].tdata) // input wire [31:0]  probe2
//    );

///*
//    ila_ants_1x u_ila_ants_1x (
//        .clk(clk_1x), // input wire clk
//        .probe0(IFP_dl_dfe_ncocmbn2cdc[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(IFP_dl_dfe_ncocmbn2cdc[0].tdata[31:0]), // input wire [31:0]  probe1 
//        .probe2(IFP_dl_dfe_ncocmbn2cdc[1].tvalid), // input wire [0:0]  probe2 
//        .probe3(IFP_dl_dfe_ncocmbn2cdc[1].tdata[31:0]), // input wire [31:0]  probe3 
//        .probe4(IFP_dl_dfe_ncocmbn2cdc[2].tvalid), // input wire [0:0]  probe4 
//        .probe5(IFP_dl_dfe_ncocmbn2cdc[2].tdata[31:0]), // input wire [31:0]  probe5 
//        .probe6(IFP_dl_dfe_ncocmbn2cdc[3].tvalid), // input wire [0:0]  probe6 
//        .probe7(IFP_dl_dfe_ncocmbn2cdc[3].tdata[31:0]) // input wire [31:0]  probe7 
//    );

//    ila_ants_3x u_ila_ants_3x (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_dl_dfe_cdc2ant[0].tvalid), // input wire [0:0]  probe8 
//        .probe1(IFP_dl_dfe_cdc2ant[0].tdata[31:0]), // input wire [31:0]  probe9 
//        .probe2(IFP_dl_dfe_cdc2ant[1].tvalid), // input wire [0:0]  probe10 
//        .probe3(IFP_dl_dfe_cdc2ant[1].tdata[31:0]), // input wire [31:0]  probe11 
//        .probe4(IFP_dl_dfe_cdc2ant[2].tvalid), // input wire [0:0]  probe12 
//        .probe5(IFP_dl_dfe_cdc2ant[2].tdata[31:0]), // input wire [31:0]  probe13 
//        .probe6(IFP_dl_dfe_cdc2ant[3].tvalid), // input wire [0:0]  probe14 
//        .probe7(IFP_dl_dfe_cdc2ant[3].tdata[31:0]), // input wire [31:0]  probe15 
//        .probe8(IFP_dl_dfe_out[0].tvalid), // input wire [0:0]  probe16 
//        .probe9(IFP_dl_dfe_out[0].tdata[31:0]), // input wire [31:0]  probe17 
//        .probe10(IFP_dl_dfe_out[1].tvalid), // input wire [0:0]  probe18 
//        .probe11(IFP_dl_dfe_out[1].tdata[31:0]), // input wire [31:0]  probe19 
//        .probe12(IFP_dl_dfe_out[2].tvalid), // input wire [0:0]  probe20 
//        .probe13(IFP_dl_dfe_out[2].tdata[31:0]), // input wire [31:0]  probe21 
//        .probe14(IFP_dl_dfe_out[3].tvalid), // input wire [0:0]  probe22 
//        .probe15(IFP_dl_dfe_out[3].tdata[31:0]) // input wire [31:0]  probe23
//    );
//*/

//	ila_0 u_ila_car2ant_stage (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_dl_dfe_ncocmbn2cdc[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(2'b00), // input wire [1:0]  probe1 
//        .probe2(IFP_dl_dfe_ncocmbn2cdc[0].tdata) // input wire [31:0]  probe2
//	);
//	 ila_1 u_ila_delay (
//	  .clk(clk_4x), // input wire clk	.probe0(probe0), // input wire [0:0]  probe0 
//	  .probe0(IFP_dl_dfe_car2ncocmbn[0].tvalid), // input wire [0:0]  probe0    
//	  .probe1(IFP_dl_dfe_car2ncocmbn[0].tdata), // input wire [31:0]  probe1 
//	  .probe2(IFP_dl_dfe_car2ncocmbn[0].tuser), // input wire [1:0]  probe2 
//	  .probe3(tvalid_s2p2nco[0][0]), // input wire [0:0]  probe3 
//	  .probe4(tdata_s2p2nco[0][0]), // input wire [31:0]  probe4 
//	  .probe5(tvalid_s2p2nco[0][1]), // input wire [0:0]  probe5 
//	  .probe6(tdata_s2p2nco[0][1]), // input wire [31:0]  probe6 
//	  .probe7(tvalid_s2p2nco[0][2]), // input wire [0:0]  probe7 
//	  .probe8(tdata_s2p2nco[0][2]), // input wire [31:0]  probe8 
//	  .probe9(tvalid_s2p2nco[0][3]), // input wire [0:0]  probe9 
//	  .probe10(tdata_s2p2nco[0][3]) // input wire [31:0]  probe10
//         );
//    ila_0 u_ila_pre_ant_stage (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_dl_dfe_cdc2ant[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(2'b00), // input wire [1:0]  probe1 
//        .probe2(IFP_dl_dfe_cdc2ant[0].tdata) // input wire [31:0]  probe2
//    );
//	ila_0 u_ila_ant_stage (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_dl_dfe_out[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(2'b00), // input wire [1:0]  probe1 
//        .probe2(IFP_dl_dfe_out[0].tdata[31:0]) // input wire [31:0]  probe2
//    );
//    ila_0 u_ila_ant1_stage (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_dl_dfe_out[1].tvalid), // input wire [0:0]  probe0  
//        .probe1(2'b00), // input wire [1:0]  probe1 
//        .probe2(IFP_dl_dfe_out[1].tdata[31:0]) // input wire [31:0]  probe2
//    );
//end : ila_dbg_en
//endgenerate

      
   
endmodule // jb_dl_dfe_top


