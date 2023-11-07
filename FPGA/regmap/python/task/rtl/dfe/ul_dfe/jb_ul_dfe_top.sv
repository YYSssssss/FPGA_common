////////////////////////////////////////////////////////////////////
////  File Name : jb_top_ctrl_cfg.sv
///// Author    : Shehanaj Begum
///// Date      : 4/8/2019
///// Description  : UL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_ul_dfe_top #(
    parameter                       UL_TIME_DELAY_BYPASS = 1,
    parameter                       N_CARRIERS=2            ,
    parameter                       N_ANTENNAS=4            ,
    parameter                       PRECISION=16            ,
    parameter                       GAIN_SCALER_BW=4        ,
    parameter                       NCO_COEF_WIDTH =40 //    
) (
    input [N_CARRIERS-1:0]          car_resetn                    ,
    input [N_CARRIERS-1:0]          clk_x1en                      ,
    input [N_CARRIERS-1:0]          clk_x4en                      ,
    input [N_CARRIERS-1:0]          clk_x8en                      ,
    input [N_CARRIERS-1:0]          clk_x16en                     ,
    input                           clk_4x                        ,
    input                           clk_3x                        ,
    input                           clk_1x                        ,
    input                           resetn_1x                     ,
    input                           resetn_4x                     ,
    input                           resetn_3x                     ,      
    input                           ul_dfe_time_delay_resetn      ,
    input                           rssi_load                     ,	
    jb_cmn_ctrl_devided_if.cmd_dfe   IFP_cmn_ctrl                  ,
    jb_ul_dfe_ctrl_devided_if.ul_dfe IFP_ul_dfe_ctrl               ,
    jb_ul_dfe_stat_devided_if.ul_dfe IFP_ul_dfe_stat               ,
    jb_axi4_stream_if.slave         IFP_ul_dfe_in [N_ANTENNAS-1:0],
    jb_axi4_stream_if.master        IFP_ul_dfe_out[N_CARRIERS-1:0] 
);

   `include  "jb_common.svh"

   //localparam USR_ID_BW = $clog2(N_ANTENNAS);
   localparam USR_ID_BW = 2;   
   localparam ILA_EN = 0;
  
   
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ul_dfe_car2conv [N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ul_dfe_conv2gain[N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ul_dfe_mixer2car[N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ul_dfe_gain_in  [N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_ul_dfe_cdc2mixer[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_ul_dfe_ant2cdc  [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_ul_dfe_ant_out  [N_CARRIERS-1:0][N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_ul_dfe_in_to_ant[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_ul_dfe_mixer_out[N_CARRIERS-1:0][N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(2))          IFP_chan_dout       [N_CARRIERS-1:0]();
   //localparam  NCO_COEF_WIDTH =40;
   localparam  NCO_COUNT_WIDTH=39;
   localparam  NCO_COEF_2S_COMPLEMENT=0;
   localparam  NCO_QUAD_LKUP_TBL_ENTRIES=1024;
   
   logic  [N_CARRIERS-1:0]                         ul_stream_sel_gain_scaler_sign;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [GAIN_SCALER_BW-1:0]    ul_stream_sel_gain_scaler     ;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [15:0]                  ul_stream_sel_gain_fraction   ;  // Carrier0 in Antenna 0 Path  Gain Register

   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0]                        ul_stream_gain_scaler_sign_cfg;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0][GAIN_SCALER_BW-1:0]    ul_stream_gain_scaler_cfg     ;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0] [15:0]                 ul_stream_gain_fraction_cfg   ;  // Carrier0 in Antenna 0 Path  Gain Register

   logic [N_CARRIERS-1:0] [USR_ID_BW-1:0] 	     gain_usr_id;

   //localparam MAX_RSSI_TICS = 21'h177000; //CLK15P36 in 100ms
   localparam MAX_RSSI_TICS_BW = 21;
   logic [N_ANTENNAS-1:0] [N_CARRIERS-1:0] ul_stream_ant_car_en;
   logic [N_ANTENNAS-1:0] ul_ant_en        ;
   logic [N_ANTENNAS-1:0] ant_path_enable  ;
   logic	              any_stream_enable;
   logic [N_CARRIERS-1:0] ul_car_en        ;

   logic [N_CARRIERS-1:0] car_resetn_1x_soft;
   logic [N_CARRIERS-1:0] car_resetn_1x_lat;

   
   logic [N_CARRIERS-1:0]        car_resetn_4x_soft;
   logic [N_CARRIERS-1:0]        car_resetn_4x_lat ;
   logic [N_CARRIERS-1:0] [79:0] s_chan_tdata      ;   
   logic [N_CARRIERS-1:0] [15:0] s_rnd_satu_dout0_i;              
   logic [N_CARRIERS-1:0] [15:0] s_rnd_satu_dout0_q;  
   logic [N_CARRIERS-1:0] [1:0]  s_rnd_satu_tuser  ;  

   logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]	 nco_coef;
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]               tvalid_in ;
   logic [2*PRECISION-1:0]	                              tdata_in [N_CARRIERS-1:0] [N_ANTENNAS-1:0];   
   logic [N_CARRIERS-1:0]  [N_ANTENNAS-1:0]	         tvalid_mixer2p2s  ;
   logic [2*PRECISION-1:0]	  tdata_mixer2p2s [N_CARRIERS-1:0] [N_ANTENNAS-1:0];
   logic [N_ANTENNAS-1:0] [N_CARRIERS-1:0] 	  tvalid_cmbn_in   ;
   logic [2*PRECISION-1:0]	  tdata_cmbn_in [N_ANTENNAS-1:0] [N_CARRIERS-1:0] ;
   logic [N_ANTENNAS-1:0]  tvalid_cmbn_out ;
   logic [2*PRECISION-1:0]	tdata_cmbn_out [N_ANTENNAS-1:0];

   
   genvar  i,j;
   genvar  car,ant;
   
   //any_stream_enable is set if anu one of the stream is enabled
   assign any_stream_enable = |ul_ant_en;
    generate
         
     for (i = 0; i <  N_ANTENNAS; i = i + 1) begin  
        for (j = 0; j <  N_CARRIERS; j = j + 1) begin
          assign ul_stream_ant_car_en[i][j] = IFP_cmn_ctrl.ul_stream_en[j][i];
        end 
      end
         
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin
          assign ul_ant_en[i]                   = |ul_stream_ant_car_en[i];
          assign IFP_ul_dfe_in_to_ant[i].tvalid =  IFP_ul_dfe_in[i].tvalid ;
          assign IFP_ul_dfe_in_to_ant[i].tdata  = ul_ant_en[i] ?  IFP_ul_dfe_in[i].tdata : 0;         
          assign IFP_ul_dfe_in_to_ant[i].tuser  = 0;
      end
      
    endgenerate    
      




   generate
     for (car = 0; car <  N_CARRIERS; car = car + 1) begin: gen_car_en      
        assign nco_coef[car]={IFP_ul_dfe_ctrl.ul_car_nco_msb[car],IFP_ul_dfe_ctrl.ul_car_nco_lsb[car]};
     end :  gen_car_en
	 
	 for (ant = 0; ant <  N_ANTENNAS; ant = ant + 1) begin: ul_dfe_ant_assign
	 
       for (car = 0; car <  N_CARRIERS; car = car + 1) begin: ul_dfe_ant_car_split
	    assign  tvalid_in[car][ant] = IFP_ul_dfe_in_to_ant[ant].tvalid;
	    assign  tdata_in[car][ant]  = ul_car_en[car] ? IFP_ul_dfe_in_to_ant[ant].tdata : 0;
	   end : ul_dfe_ant_car_split
	 
	 assign IFP_ul_dfe_in_to_ant[ant].tready = 1'b1;
	 
	 end :  ul_dfe_ant_assign
   endgenerate



   jb_dfe_mixer #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
       .NCO_COEF_2S_COMPLEMENT(NCO_COEF_2S_COMPLEMENT),
       .NCO_COUNT_WIDTH(NCO_COUNT_WIDTH),
       .NCO_COEF_WIDTH(NCO_COEF_WIDTH),
       .PRECISION (PRECISION),
       .MODE(1) //DL=0, UL=1
   ) u_ul_dfe_mixer  (
       .clk              (clk_3x          ),
       .resetn           (resetn_3x       ),
       .any_stream_enable(1'b1            ),
       .nco_coef         (nco_coef        ),
       .tvalid_in        (tvalid_in       ),
       .tdata_in         (tdata_in        ),
       .tvalid_out       (tvalid_mixer2p2s),
       .tdata_out        (tdata_mixer2p2s )
   );



//generate
//for (i = 0; i <  N_ANTENNAS; i = i + 1) begin 
//  for (j = 0; j <  N_CARRIERS; j = j + 1) begin 
//  
//	assign tvalid_cmbn_in[i][j] = tvalid_mixer2p2s[j][i];
//	assign tdata_cmbn_in[i][j]  = tdata_mixer2p2s[j][i] ;
//
//  end 
//end 
//endgenerate 




//generate
//for (i = 0; i <  N_ANTENNAS; i = i + 1) begin
//    jb_dl_dfe_cmbn #(
//      .N_CARRIERS (N_CARRIERS),
//      .N_ANTENNAS (N_ANTENNAS),
//      .PRECISION (PRECISION)
//      ) u_dl_dfe_cmbn  (
//      .clk            (clk_3x),
//      .resetn         (resetn_3x),
//      .IFP_dl_dfe_ctrl(IFP_dl_dfe_ctrl),
//      .tvalid_in      (tvalid_cmbn_in[i]),
//      .tdata_in       (tdata_cmbn_in[i] ),
//      .tvalid_out     (tvalid_cmbn_out[i]),
//      .tdata_out      (tdata_cmbn_out[i])
//    );
//	
//		
//end 
//endgenerate  



generate
for (car = 0; car <  N_CARRIERS; car = car + 1) begin 
  for (ant = 0; ant <  N_ANTENNAS; ant = ant + 1) begin 
  
	assign IFP_ul_dfe_mixer_out[car][ant].tdata  = tdata_mixer2p2s[car][ant] ;
	assign IFP_ul_dfe_mixer_out[car][ant].tvalid = tvalid_mixer2p2s[car][ant];

  end 
end 
endgenerate 

generate
for (car = 0; car <  N_CARRIERS; car = car + 1) begin: test       

   jb_ul_dfe_ant #(
       .N_ANTENNAS (N_ANTENNAS),
       .GAIN_SCALER_BW(GAIN_SCALER_BW),
       .PRECISION (PRECISION)
   ) u_ul_dfe_ant  (
       .clk_3x          (clk_3x              ),
       .resetn_3x       (resetn_3x           ),
       .ul_ant_en       (ul_ant_en           ),//for clock enable, need to add another control
       .IFP_ul_dfe_ctrl (IFP_ul_dfe_ctrl     ),
//       .IFP_ul_dfe_in   (IFP_ul_dfe_in_to_ant),
       .IFP_ul_dfe_in   (IFP_ul_dfe_mixer_out[car]),
//       .IFP_ul_dfe_out  (IFP_ul_dfe_ant2cdc  )
       .IFP_ul_dfe_out  (IFP_ul_dfe_ant_out[car]	 )   
   );
   
end 
endgenerate    
   
   
//[zle] remove for mintaka
//generate
//for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: ul_dfe_3x_to_1x
//   //368.64 to 122.88
//	jb_axis_sync_fastc_slowc #(
//        .FAST_TO_SLOW_RATIO     (3),
//        .FAST_TO_SLOW_RATIO_BW  (2),
//        .ILA_EN                 (ILA_EN),
//        .DATA_BW                (2*PRECISION),
//        .USR_ID_BW              (1)			   
//    ) u_ul_dfe_3x_to_1x (
//        .clk_slow_en            (1'b1),
//        .clk_fast_en            (1'b1),
//        .clk_slow               (clk_1x),
//        .clk_fast               (clk_3x),
//           .resetn_clk_slow(resetn_1x),
//           .resetn_clk_fast(resetn_3x),
//        .IFP_axis_in            (IFP_ul_dfe_ant2cdc[i]),
//        .IFP_axis_out           (IFP_ul_dfe_cdc2mixer[i])
//    );
//end :ul_dfe_3x_to_1x
//endgenerate
   
   //1x to 4x inside ant2car
     jb_ul_dfe_ant2car #(
       .UL_TIME_DELAY_BYPASS     (UL_TIME_DELAY_BYPASS),
       .N_CARRIERS               (N_CARRIERS),
       .N_ANTENNAS               (N_ANTENNAS),
       .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
       .NCO_COEF_2S_COMPLEMENT   (NCO_COEF_2S_COMPLEMENT),
       .NCO_COUNT_WIDTH          (NCO_COUNT_WIDTH),
       .NCO_COEF_WIDTH           (NCO_COEF_WIDTH),
       .PRECISION                (PRECISION)
   ) u_ul_dfe_ant2car  (
       .clk_1x           (clk_3x),
       .clk_4x           (clk_4x),
       .resetn_4x(resetn_4x),
       .resetn_1x(resetn_3x),
       .ul_dfe_time_delay_resetn (ul_dfe_time_delay_resetn),
       .any_stream_enable(any_stream_enable),
       .IFP_ul_dfe_in    (IFP_ul_dfe_ant2cdc),
       .IFP_p2s_in       (IFP_ul_dfe_ant_out),	   
       .IFP_cmn_ctrl     (IFP_cmn_ctrl),
       .IFP_ul_dfe_ctrl  (IFP_ul_dfe_ctrl),
       .IFP_ul_dfe_out   (IFP_ul_dfe_mixer2car)
   );


generate
for (i = 0; i <  N_CARRIERS; i = i + 1) begin: ul_dfe_car_inst
    assign ul_car_en[i] = |IFP_cmn_ctrl.ul_stream_en[i];

    always_ff @(posedge clk_1x) begin	
        car_resetn_1x_lat[i] <= car_resetn[i];
	    car_resetn_1x_soft[i] <= car_resetn_1x_lat[i] & resetn_1x;
     end
     always_ff @(posedge clk_4x) begin	
        car_resetn_4x_lat[i] <= car_resetn[i];
	    car_resetn_4x_soft[i] <= car_resetn_4x_lat[i] & resetn_4x;
     end

//    jb_ul_dfe_car #(
//		.ILA_EN                   (ILA_EN),
//        .N_CARRIERS             (N_CARRIERS),
//        .N_ANTENNAS             (N_ANTENNAS),
//        .GAIN_SCALER_BW         (GAIN_SCALER_BW),
//        .PRECISION              (PRECISION)
//    ) u_ul_dfe_car (
//        .clk_x4en               (clk_x4en[i]),
//        .clk_x8en               (clk_x8en[i]),
//        .clk_x16en              (clk_x16en[i]),
//        .clk_4x                 (clk_4x),
//        .clk_8x                 (clk_4x),   // Effective freq with clk_en is 246.76 for 5MHz BW and 491.52 for 10MHz BW. Disabled for other BW settings.
//        .clk_16x                (clk_4x),   // Effective freq with clk_en is 491.52 for 5MHz BW. Disabled for other BW settings.
//        .resetn_4x              (car_resetn_4x_soft[i]),
//        .ul_car_en              (ul_car_en[i]),
//        .car_bw                 (IFP_cmn_ctrl.ul_car_bw[i]),
//        .IFP_ul_dfe_in          (IFP_ul_dfe_mixer2car[i]),
//        .IFP_ul_dfe_out         (IFP_ul_dfe_car2conv[i])   
//    );
//
//    //interleaved 
//	jb_axis_sync_fastc_slowc #(
//        .FAST_TO_SLOW_RATIO     (4),
//        .FAST_TO_SLOW_RATIO_BW  (2),
//        .DATA_BW                (2*PRECISION),
//        .USR_ID_BW              (USR_ID_BW)			   
//    ) u_ul_dfe_4x_to_1x  (
//        .clk_slow_en            (clk_x1en[i]),
//        .clk_fast_en            (clk_x4en[i]),
//        .clk_slow               (clk_1x),
//        .clk_fast               (clk_4x),
//			  
//        .resetn_clk_fast(car_resetn_4x_soft[i]),
//        .resetn_clk_slow(car_resetn_1x_soft[i]),
//			  
//        .IFP_axis_in            (IFP_ul_dfe_car2conv[i]),
//        .IFP_axis_out           (IFP_ul_dfe_conv2gain[i])
//    );


      fir_singlerate_122p88 u_fir_singlerate_122p88 (
        .aresetn                        (1'b1                          ),     // i
        .aclk                           (clk_4x                        ),     // input wire aclk
        .aclken                         (1'b1                          ),
		.s_axis_data_tvalid             (IFP_ul_dfe_mixer2car[i].tvalid),     // input wire s_axis_data_tvalid
        .s_axis_data_tuser              (IFP_ul_dfe_mixer2car[i].tuser ),
        .s_axis_data_tdata              (IFP_ul_dfe_mixer2car[i].tdata ),     // input wire [31 : 0] s_axis_data_tdata
        .m_axis_data_tvalid             (IFP_chan_dout[i].tvalid       ),     // output wire m_axis_data_tvalid
        .m_axis_data_tdata              (s_chan_tdata[i]               ),     // output wire [79 : 0] m_axis_data_tdata
        .m_axis_data_tuser              (IFP_chan_dout[i].tuser        ), 
        .s_axis_data_tready             (),     // output wire s_axis_data_tready		
        .event_s_data_chanid_incorrect  () 
    );	
	

        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_chan_i
            ( 
            .i_rst       (1'b0                   ),
            .i_clk       (clk_4x                 ),   
            .i_data      (s_chan_tdata[i][39:0]  ),    
            .o_data      (s_rnd_satu_dout0_i[i]  )
            );      

        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_chan_q
            ( 
            .i_rst       (1'b0                    ),
            .i_clk       (clk_4x                  ),   
            .i_data      (s_chan_tdata[i][79:40]  ),    
            .o_data      (s_rnd_satu_dout0_q[i]   )
            );		 
	 

always@(posedge clk_4x)begin
  s_rnd_satu_tuser[i] <= IFP_chan_dout[i].tuser;
end



    
	jb_iq_rssi #(
        .SAMPLE_BW              (PRECISION),
        .USR_ID_BW              (USR_ID_BW),
        .N_USRS                 (N_ANTENNAS),
        .WRSSI                  (0) //log2(100ms@30.74)+30
    ) u_iq_rssi (
        .clk                    (clk_1x                      ),
        .clk_en                 (clk_x1en[i]                 ),
        .resetn                 (car_resetn_1x_soft[i]       ),
        .tvalid                 (IFP_ul_dfe_gain_in[i].tvalid),
        .tdata                  (IFP_ul_dfe_gain_in[i].tdata ),
        .tusr                   (IFP_ul_dfe_gain_in[i].tuser ),
        .rssi_load              (rssi_load                   ),
	    .rssi_value             (IFP_ul_dfe_stat.rssi[i]     )
	  );

	 for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: ul_dfe_car_gain_params
	    always @(posedge clk_1x) begin //no reset,  already config gets reset in the reg block
	       ul_stream_gain_scaler_sign_cfg[i][j]  <=  IFP_ul_dfe_ctrl.ul_stream_gain_scaler_sign[i][j] ;
	       ul_stream_gain_scaler_cfg[i][j]       <=  IFP_ul_dfe_ctrl.ul_stream_gain_scaler[i][j]      ;
	       ul_stream_gain_fraction_cfg[i][j]     <=  IFP_ul_dfe_ctrl.ul_stream_gain_fraction[i][j]    ;
	    end
	 end :   ul_dfe_car_gain_params
	 
	 
	 assign gain_usr_id[i]                    = IFP_ul_dfe_mixer2car[i].tuser                     ;
	 assign ul_stream_sel_gain_scaler_sign[i] = ul_stream_gain_scaler_sign_cfg[i][gain_usr_id[i]] ;
	 assign ul_stream_sel_gain_scaler[i]      = ul_stream_gain_scaler_cfg[i][gain_usr_id[i]]      ; 
	 assign ul_stream_sel_gain_fraction[i]    = ul_stream_gain_fraction_cfg[i][gain_usr_id[i]]    ;
	 
	 
	 assign IFP_ul_dfe_gain_in[i].tdata       = {s_rnd_satu_dout0_q[i],s_rnd_satu_dout0_i[i]} ;
	 assign IFP_ul_dfe_gain_in[i].tuser       = s_rnd_satu_tuser[i]                           ;
	 assign IFP_ul_dfe_gain_in[i].tvalid      = 1'b1                                          ;
	 
	 
    //instantiate gain block
    jb_iq_gain_mult #(
        .PRECISION              (PRECISION     ),
        .SCALER_BW              (GAIN_SCALER_BW),
        .USR_ID_BW              (USR_ID_BW     )
	) u_iq_stream_gain_car (
        .clk                    (clk_1x                           ),
        .clk_en                 (clk_x1en[i]                      ),
        .resetn                 (car_resetn_1x_soft[i]            ),
	    .scaler_gain_sign       (ul_stream_sel_gain_scaler_sign[i]),
	    .scaler_gain            (ul_stream_sel_gain_scaler[i]     ),
	    .fraction_gain          (ul_stream_sel_gain_fraction[i]   ),			
	    .IFP_dfe_in             (IFP_ul_dfe_gain_in[i]            ),
        .IFP_dfe_out            (IFP_ul_dfe_out[i]                )
	);
end : ul_dfe_car_inst 
endgenerate

/*
 ila_1 u_ila_ul_dfe_in (
	  .clk(clk_3x), // input wire clk	.probe0(probe0), // input wire [0:0]  probe0 
	  .probe0(1'b0), // input wire [0:0]  probe0    
	  .probe1(32'd0), // input wire [31:0]  probe1 
	  .probe2(2'd0), // input wire [1:0]  probe2 
	  .probe3(IFP_ul_dfe_in[0].tvalid), // input wire [0:0]  probe3 
	  .probe4(IFP_ul_dfe_in[0].tdata), // input wire [31:0]  probe4 
	  .probe5(IFP_ul_dfe_in[1].tvalid), // input wire [0:0]  probe5 
	  .probe6(IFP_ul_dfe_in[1].tdata), // input wire [31:0]  probe6 
	  .probe7(IFP_ul_dfe_in[2].tvalid), // input wire [0:0]  probe7 
	  .probe8(IFP_ul_dfe_in[2].tdata), // input wire [31:0]  probe8 
	  .probe9(IFP_ul_dfe_in[3].tvalid), // input wire [0:0]  probe9 
	  .probe10(IFP_ul_dfe_in[3].tdata) // input wire [31:0]  probe10
         );
         
      ila_1 u_ila_ul_dfe_ant2cdc_all (
	  .clk(clk_3x), // input wire clk	.probe0(probe0), // input wire [0:0]  probe0 
	  .probe0(1'b0), // input wire [0:0]  probe0    
	  .probe1(32'd0), // input wire [31:0]  probe1 
	  .probe2(2'd0), // input wire [1:0]  probe2 
	  .probe3(IFP_ul_dfe_ant2cdc[0].tvalid), // input wire [0:0]  probe3 
	  .probe4(IFP_ul_dfe_ant2cdc[0].tdata), // input wire [31:0]  probe4 
	  .probe5(IFP_ul_dfe_ant2cdc[1].tvalid), // input wire [0:0]  probe5 
	  .probe6(IFP_ul_dfe_ant2cdc[1].tdata), // input wire [31:0]  probe6 
	  .probe7(IFP_ul_dfe_ant2cdc[2].tvalid), // input wire [0:0]  probe7 
	  .probe8(IFP_ul_dfe_ant2cdc[2].tdata), // input wire [31:0]  probe8 
	  .probe9(IFP_ul_dfe_ant2cdc[3].tvalid), // input wire [0:0]  probe9 
	  .probe10(IFP_ul_dfe_ant2cdc[3].tdata) // input wire [31:0]  probe10
         );
         
      ila_1 u_ila_ul_dfe_cdc2mixer_all (
	  .clk(clk_3x), // input wire clk	.probe0(probe0), // input wire [0:0]  probe0 
	  .probe0(1'b0), // input wire [0:0]  probe0    
	  .probe1(32'd0), // input wire [31:0]  probe1 
	  .probe2(2'd0), // input wire [1:0]  probe2 
	  .probe3(IFP_ul_dfe_cdc2mixer[0].tvalid), // input wire [0:0]  probe3 
	  .probe4(IFP_ul_dfe_cdc2mixer[0].tdata), // input wire [31:0]  probe4 
	  .probe5(IFP_ul_dfe_cdc2mixer[1].tvalid), // input wire [0:0]  probe5 
	  .probe6(IFP_ul_dfe_cdc2mixer[1].tdata), // input wire [31:0]  probe6 
	  .probe7(IFP_ul_dfe_cdc2mixer[2].tvalid), // input wire [0:0]  probe7 
	  .probe8(IFP_ul_dfe_cdc2mixer[2].tdata), // input wire [31:0]  probe8 
	  .probe9(IFP_ul_dfe_cdc2mixer[3].tvalid), // input wire [0:0]  probe9 
	  .probe10(IFP_ul_dfe_cdc2mixer[3].tdata) // input wire [31:0]  probe10
         );
         
   
 	ila_0 u_ila_ul_mixer2car_stage1 (
        .clk(clk_4x), // input wire clk
        .probe0(IFP_ul_dfe_mixer2car[0].tvalid), // input wire [0:0]  probe0  
        .probe1(IFP_ul_dfe_mixer2car[0].tuser), // input wire [1:0]  probe1 
        .probe2(IFP_ul_dfe_mixer2car[0].tdata) // input wire [31:0]  probe2
	);  
*/	           
//generate
//if (ILA_EN==1) begin : ila_dbg_en

//    ila_0 u_ila_ul_dfe_in (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_ul_dfe_in[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(IFP_ul_dfe_in[0].tuser), // input wire [1:0]  probe1 
//        .probe2(IFP_ul_dfe_in[0].tdata) // input wire [31:0]  probe2
//    );


//	ila_0 u_ila_ul_dfe_ant2cdc (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_ul_dfe_ant2cdc[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(IFP_ul_dfe_ant2cdc[0].tuser), // input wire [1:0]  probe1 
//        .probe2(IFP_ul_dfe_ant2cdc[0].tdata) // input wire [31:0]  probe2
//	);

//	ila_0 u_ila_ul_dfe_cdc2mixer (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_ul_dfe_cdc2mixer[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(IFP_ul_dfe_cdc2mixer[0].tuser), // input wire [1:0]  probe1 
//        .probe2(IFP_ul_dfe_cdc2mixer[0].tdata) // input wire [31:0]  probe2
//	);

//	ila_0 u_ila_ul_mixer2car_stage (
//        .clk(clk_4x), // input wire clk
//        .probe0(IFP_ul_dfe_mixer2car[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(IFP_ul_dfe_mixer2car[0].tuser), // input wire [1:0]  probe1 
//        .probe2(IFP_ul_dfe_mixer2car[0].tdata) // input wire [31:0]  probe2
//	);

//      ila_0 u_ila_ul_dfe_gain (
//	  .clk(clk_1x), // input wire clk
//	  .probe0(IFP_ul_dfe_conv2gain[0].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_ul_dfe_conv2gain[0].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_ul_dfe_conv2gain[0].tdata) // input wire [31:0]  probe2
//	 );
	
//     ila_0 u_ila_ul_dfe_mixer2car(
//	  .clk(clk_1x), // input wire clk
//	  .probe0(IFP_ul_dfe_car2conv[0].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_ul_dfe_car2conv[0].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_ul_dfe_car2conv[0].tdata) // input wire [31:0]  probe2
//	 );

//    ila_0 u_ila_ul_dfe_out (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_ul_dfe_out[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(IFP_ul_dfe_out[0].tuser), // input wire [1:0]  probe1 
//        .probe2(IFP_ul_dfe_out[0].tdata[31:0]) // input wire [31:0]  probe2
//    );

//end : ila_dbg_en
//endgenerate

//    ila_0 u_ila_ul_dfe_out (
//        .clk(clk_3x), // input wire clk
//        .probe0(IFP_ul_dfe_out[0].tvalid), // input wire [0:0]  probe0  
//        .probe1(IFP_ul_dfe_out[0].tuser), // input wire [1:0]  probe1 
//        .probe2(IFP_ul_dfe_out[0].tdata[31:0]) // input wire [31:0]  probe2
//    );

endmodule // jb_ul_dfe_top


