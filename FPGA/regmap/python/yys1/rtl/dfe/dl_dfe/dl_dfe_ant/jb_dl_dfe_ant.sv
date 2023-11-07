////////////////////////////////////////////////////////////////////
////  File Name : jb_top_ctrl_cfg.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2018
///// Description  : DL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dl_dfe_ant #(
      parameter  DL_TIME_DELAY_BYPASS=1, 
      parameter  N_CARRIERS=2,	 
      parameter  NCO_COEF_WIDTH =40,
  
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter  GAIN_SCALER_BW=4, 
      parameter  INST_CFR=1,
      parameter  INST_DPD=1   
   ) (

      input clk_3x, //368.64
      input resetn,

      
      input axi_clk,
      input axi_resetn,

      input rssi_load,
      output real_bypass_dpd,
      input Error_10ms,
      
      output logic [31:0]  fir_3x_sat_err_status,
      output logic [31:0]  poly_even_sat_err_status,
      output logic [31:0]  poly_odd_sat_err_status,
      input                clear_ovrfl_undfl_pulse,


      input any_stream_enable,

      jb_axi4_stream_if.master  IFP_dpd_s_axis_din,         // 128,32
      jb_axi4_stream_if.slave   IFP_dpd_m_axis_dout,        // 128,32
      jb_axi4_stream_if.master  IFP_cfr_s_axis_din,         // 128,1
      jb_axi4_stream_if.slave   IFP_cfr_m_axis_dout,        // 128,1
      
 
      
      jb_dl_dfe_ctrl_devided_if.dl_dfe IFP_dl_dfe_ctrl,
      jb_dl_dfe_rfc_if.dl_dfe  IFP_rfc,


      
     
      output logic  [N_ANTENNAS-1:0]                        dl_postcfr_gain_scaler_sign_cfg,  // Carrier0 in Antenna 0 Path  Gain Register
      output logic  [N_ANTENNAS-1:0][GAIN_SCALER_BW-1:0]    dl_postcfr_gain_scaler_cfg,  // Carrier0 in Antenna 0 Path  Gain Register
      output logic  [N_ANTENNAS-1:0] [15:0]                 dl_postcfr_gain_fraction_cfg,  // Carrier0 in Antenna 0 Path  Gain Register

     
      
     
      // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
      // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
//zle nco	  
//      jb_axi4_stream_if.slave IFP_dl_dfe_in[N_ANTENNAS-1:0],
      jb_axi4_stream_if.slave IFP_dl_dfe_in[N_ANTENNAS-1:0][N_CARRIERS-1:0],


      //DPD outputs 2 arrays of axi stream
      jb_axi4_stream_if.master IFP_dl_dfe_out[N_ANTENNAS-1:0]
      
      
      );

   localparam N_BYTES_AXI = $ceil((PRECISION*2)/8);
   localparam USR_ID_BW=1;//no Sharing so we don't need usr id
   
   localparam USR_ID_BW_nco = $clog2(N_ANTENNAS);  
   
   localparam DPD_BYPASS_PATTERN=32'hfeedbeef;
   
   localparam  NCO_COUNT_WIDTH=39;   
   localparam  NCO_COEF_2S_COMPLEMENT=0;   
   localparam  NCO_QUAD_LKUP_TBL_ENTRIES=1024;   

   
   logic                   post_dpd_2x_odd_tvalid[N_ANTENNAS-1:0];
   logic [2*PRECISION-1:0] post_dpd_2x_odd_tdata[N_ANTENNAS-1:0];
   logic                   post_dpd_2x_even_tvalid[N_ANTENNAS-1:0];
   logic [2*PRECISION-1:0] post_dpd_2x_even_tdata[N_ANTENNAS-1:0];

   logic [N_ANTENNAS-1:0] [63:0]   tdata_to_dac;
   logic [N_ANTENNAS-1:0]          unalign_valid_error;

   
   logic [63:0]            fir_3x_full_data[N_ANTENNAS-1:0];
   logic [PRECISION-1:0]   fir_3x_data_i[N_ANTENNAS-1:0];
   logic [PRECISION-1:0]   fir_3x_data_q[N_ANTENNAS-1:0];

   
   logic [79:0]   fir_2x_odd_full_data[N_ANTENNAS-1:0];
   logic [PRECISION-1:0]   fir_2x_odd_data_i[N_ANTENNAS-1:0];
   logic [PRECISION-1:0]   fir_2x_odd_data_q[N_ANTENNAS-1:0];

   
   
   logic [63:0]            fir_2x_even_full_data[N_ANTENNAS-1:0];
   logic [PRECISION-1:0]   fir_2x_even_data_i[N_ANTENNAS-1:0];
   logic [PRECISION-1:0]   fir_2x_even_data_q[N_ANTENNAS-1:0];

   //CFR Signals
   logic 		       cfr_din_tready;
   logic [127:0] 	   cfr_din_tdata;
   logic [127:0] 	   cfr_dout_tdata;
   logic 		       cfr_dout_tvalid;

   
  (* dont_touch = "true" *) logic 		   cfr_event_m_dout_overrun;
  (* dont_touch = "true" *) logic 		   cfr_event_s_din_underrun;
 

  //DPD Signals

   (* dont_touch = "true" *)logic 		   dpd_event_m_dout_overrun;      
   (* dont_touch = "true" *)logic 		   dpd_event_s_din_underrun;      
   (* dont_touch = "true" *)logic 		   dpd_event_s_srx_underrun;     
   (* dont_touch = "true" *)logic 		   dpd_intr;

                            logic [127 : 0]    dpd_din_tdata;
   (* dont_touch = "true" *)logic 		       dpd_din_tready;
   (* dont_touch = "true" *)logic [31 : 0] 	   dpd_din_tuser;
                            logic 		       dpd_dout_tvalid;
                            logic [127 : 0]    dpd_dout_tdata;
   (* dont_touch = "true" *)logic [31 : 0]     dpd_dout_tuser;
                            logic 		       dpd_dout_tlast;


   
   
   logic  [N_ANTENNAS-1:0]                        dl_precfr_gain_scaler_sign_cfg;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_ANTENNAS-1:0][GAIN_SCALER_BW-1:0]    dl_precfr_gain_scaler_cfg;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_ANTENNAS-1:0] [15:0]                 dl_precfr_gain_fraction_cfg;  // Carrier0 in Antenna 0 Path  Gain Register

     
 
  logic [N_ANTENNAS-1:0] 	[7:0] intrp_3x_error_flag;  
  logic [N_ANTENNAS-1:0] 	[7:0] intrp_poly_odd_error_flag;  
  logic [N_ANTENNAS-1:0] 	[7:0] intrp_poly_even_error_flag;  
  
//  logic [3:0]        s_tvalid=0;
//  logic [3:0] [31:0] s_tdata =0;
  logic [3:0][1:0]       s_tvalid=0;
  logic [3:0][1:0][31:0] s_tdata =0;

//  logic [3:0] [31:0] s_hb_dout_i      ;
//  logic [3:0] [31:0] s_hb_dout_q      ;   
  logic [3:0][1:0][31:0] s_hb_dout_i      ;
  logic [3:0][1:0][31:0] s_hb_dout_q      ;  
  
//  logic [3:0] [31:0] s_fir_dout_i     ;
//  logic [3:0] [31:0] s_fir_dout_q     ; 
  logic [3:0][1:0][31:0] s_fir_dout_i     ;
  logic [3:0][1:0][31:0] s_fir_dout_q     ; 
  
  
  
  logic [3:0] [15:0] s_hb_dout2_odd_i ;
  logic [3:0] [15:0] s_hb_dout2_even_i;
  logic [3:0] [15:0] s_hb_dout2_odd_q ;
  logic [3:0] [15:0] s_hb_dout2_even_q;
  logic [3:0]        s_hb983_odd_tvalid =0;
  logic [3:0] [31:0] s_hb983_odd_tdata  =0;
  logic [3:0]        s_hb983_even_tvalid=0;
  logic [3:0] [31:0] s_hb983_even_tdata =0;
  
  logic [3:0] [16:0] s_rnd_dout0   ;
  logic [3:0] [16:0] s_rnd_dout1   ;
  logic [3:0] [16:0] s_rnd_dout2   ;
  logic [3:0] [16:0] s_rnd_dout3   ;
  logic [3:0] [16:0] s_rnd_dout4   ;
  logic [3:0] [16:0] s_rnd_dout5   ;
  logic [3:0] [16:0] s_rnd_dout6   ;
  logic [3:0] [16:0] s_rnd_dout7   ;


  

  
 
//   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_ant_uuc3x2pregain[N_ANTENNAS-1:0]();
//   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_hb_dout                [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_hb_dout                [N_ANTENNAS-1:0][N_CARRIERS-1:0]();



   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_ant_pregain2cfr [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_dl_dfe_ant_cfr2postgain[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_dl_dfe_ant_postgain2dpd[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_dl_dfe_dpd2uuc2x       [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_dl_dfe_srp             [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_dl_dfe_srp_odd         [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_dl_dfe_srp_even        [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_filter_in_sel          [N_ANTENNAS-1:0]();
//   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_fir_dout               [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_fir_dout               [N_ANTENNAS-1:0][N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_hb_dout2_odd_i         [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_hb_dout2_even_i        [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_hb_dout2_odd_q         [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(1))          IFP_hb_dout2_even_q        [N_ANTENNAS-1:0]();

   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_ant_poly_odd    [N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_dl_dfe_ant_poly_even   [N_ANTENNAS-1:0]();

   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_post_nco[N_ANTENNAS-1:0]();	

    genvar    i,j,k;
   
 

   assign real_bypass_dpd = IFP_dl_dfe_ctrl.bypass_dpd & (IFP_dl_dfe_ctrl.pl_debug==DPD_BYPASS_PATTERN);
   

   generate
      for (j = 0; j < 4; j = j + 1) begin : ant_sat_set
	 for (k = 0; k < 8; k = k + 1) begin : bit_ovfl_undfl_set
	    always_ff @(posedge clk_3x) begin
	       if (!resetn) begin
		     fir_3x_sat_err_status[j*8+k]    <= 1'b0;
		     poly_even_sat_err_status[j*8+k] <= 1'b0;
		     poly_odd_sat_err_status[j*8+k]  <= 1'b0;
	       end
	       else if (clear_ovrfl_undfl_pulse) begin
		     fir_3x_sat_err_status[j*8+k]    <= 1'b0;
		     poly_even_sat_err_status[j*8+k] <= 1'b0;
		     poly_odd_sat_err_status[j*8+k]  <= 1'b0;
	       end
	       else  begin
		  if( intrp_3x_error_flag[j][k]) begin
		     fir_3x_sat_err_status[j*8+k]  <=1'b1;
		  end
		  if (intrp_poly_odd_error_flag[j][k]) begin
		     poly_odd_sat_err_status[j*8+k] <= 1'b1;
		  end
		  if (intrp_poly_even_error_flag[j][k]) begin
		     poly_even_sat_err_status[j*8+k] <= 1'b1;
		  end
	       end 
	    end //awlays
	 end : bit_ovfl_undfl_set
      end : ant_sat_set
   endgenerate   


generate
for (i = 0; i <  N_ANTENNAS; i = i + 1) begin 
  for (j = 0; j <  N_CARRIERS; j = j + 1) begin 
    always @(posedge clk_3x)begin
     if(IFP_dl_dfe_in[i][j].tvalid)
       begin
        s_tvalid[i][j] <= IFP_dl_dfe_in[i][j].tvalid;
    	s_tdata[i][j]  <= IFP_dl_dfe_in[i][j].tdata;
       end
     else
       begin
        s_tvalid[i][j] <= 0;
    	s_tdata[i][j]  <= IFP_dl_dfe_in[i][j].tdata;
       end   
    end
 
 
    hb_122to245 hb_122to245_i(
      .aresetn            (1'b1                      ),
      .aclk               (clk_3x                    ),
      .aclken             (1'b1                      ),
      .s_axis_data_tvalid (s_tvalid[i][j]               ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (s_tdata[i][j][15:0]          ),
      .m_axis_data_tvalid (IFP_hb_dout[i][j].tvalid     ),
      .m_axis_data_tdata  (s_hb_dout_i[i][j])
     );
	 
	 
 
	 
	 

    hb_122to245 hb_122to245_q(
      .aresetn            (1'b1                       ),
      .aclk               (clk_3x                     ),
      .aclken             (1'b1                       ),
      .s_axis_data_tvalid (s_tvalid[i][j]                ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (s_tdata[i][j][31:16]          ),
      .m_axis_data_tvalid (),
      .m_axis_data_tdata  (s_hb_dout_q[i][j])
     );
  



        data_rnd_satu
            #( .DIN_WIDTH  (32),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_hb_i
            ( 
            .i_rst       (1'b0                       ),
            .i_clk       (clk_3x                     ),   
            .i_data      (s_hb_dout_i[i][j]             ),    
            .o_data      (IFP_hb_dout[i][j].tdata[15:0] )
            );     



        data_rnd_satu
            #( .DIN_WIDTH  (32),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_hb_q
            ( 
            .i_rst       (1'b0                        ),
            .i_clk       (clk_3x                      ),   
            .i_data      (s_hb_dout_q[i][j]              ),    
            .o_data      (IFP_hb_dout[i][j].tdata[31:16] )
            );  


///245-->491
    fir_245to491 fir_245to491_i(
      .aresetn            (1'b1                       ),
      .aclk               (clk_3x                     ),
      .aclken             (1'b1                       ),
      .s_axis_data_tvalid (IFP_hb_dout[i][j].tvalid      ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (IFP_hb_dout[i][j].tdata[15:0] ),
      .m_axis_data_tvalid (IFP_fir_dout[i][j].tvalid     ),
      .m_axis_data_tdata  (s_fir_dout_i[i][j]            )
     );

    fir_245to491 fir_245to491_q(
      .aresetn            (1'b1                        ),
      .aclk               (clk_3x                      ),
      .aclken             (1'b1                        ),
      .s_axis_data_tvalid (IFP_hb_dout[i][j].tvalid       ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (IFP_hb_dout[i][j].tdata[31:16] ),
      .m_axis_data_tvalid (),
      .m_axis_data_tdata  (s_fir_dout_q[i][j]             )
     );


        data_rnd_satu
            #( .DIN_WIDTH  (32),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_fir_i
            ( 
            .i_rst       (1'b0                       ),
            .i_clk       (clk_3x                     ),   
            .i_data      (s_fir_dout_i[i][j]            ),    
            .o_data      (IFP_fir_dout[i][j].tdata[15:0])
            ); 



        data_rnd_satu
            #( .DIN_WIDTH  (32),
			   .FRAC_WIDTH (15),
               .DOUT_WIDTH (16))
            data_rnd_satu_fir_q
            ( 
            .i_rst       (1'b0                         ),
            .i_clk       (clk_3x                       ),   
            .i_data      (s_fir_dout_q[i][j]              ),    
            .o_data      (IFP_fir_dout[i][j].tdata[31:16] )
            );

    end 
  end 
endgenerate 


logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]        tvalid_s2p2nco_in_mixer ;
logic [2*PRECISION-1:0]	  tdata_s2p2nco_in_mixer [N_CARRIERS-1:0] [N_ANTENNAS-1:0];


logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]           tvalid_nco2cmbn ;
logic [2*PRECISION-1:0]	  tdata_nco2cmbn [N_CARRIERS-1:0] [N_ANTENNAS-1:0];

logic [N_ANTENNAS-1:0] [N_CARRIERS-1:0] 	  tvalid_cmbn_in   ;//chnaged this for oring
logic [2*PRECISION-1:0]	  tdata_cmbn_in [N_ANTENNAS-1:0] [N_CARRIERS-1:0] ;

logic [N_ANTENNAS-1:0]  tvalid_cmbn_out ;
logic [2*PRECISION-1:0]	tdata_cmbn_out [N_ANTENNAS-1:0];

logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]	 nco_coef;  

generate
   for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_ant_s2p
   assign nco_coef[i]={IFP_dl_dfe_ctrl.dl_car_nco_msb[i],IFP_dl_dfe_ctrl.dl_car_nco_lsb[i]};
   end
endgenerate 

generate
for (i = 0; i <  N_ANTENNAS; i = i + 1) begin 
  for (j = 0; j <  N_CARRIERS; j = j + 1) begin 
  
	assign tvalid_s2p2nco_in_mixer[j][i]= IFP_fir_dout[i][j].tvalid;
	assign tdata_s2p2nco_in_mixer[j][i] = IFP_fir_dout[i][j].tdata ;  

	assign tvalid_cmbn_in[i][j] = tvalid_nco2cmbn[j][i];
	assign tdata_cmbn_in[i][j]  = tdata_nco2cmbn[j][i] ;

  end 
end 
endgenerate 

   jb_dfe_mixer #(
       .N_CARRIERS               (N_CARRIERS),
       .N_ANTENNAS               (N_ANTENNAS),
       .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
       .NCO_COEF_2S_COMPLEMENT   (NCO_COEF_2S_COMPLEMENT),
       .NCO_COUNT_WIDTH          (NCO_COUNT_WIDTH),
       .NCO_COEF_WIDTH           (NCO_COEF_WIDTH),
       .PRECISION                (PRECISION)
   ) u_dl_dfe_mixer  (
       .clk              (clk_3x),
       .resetn           (resetn),
       .any_stream_enable(any_stream_enable),
       .nco_coef         (nco_coef),

       .tvalid_in        (tvalid_s2p2nco_in_mixer),
       .tdata_in         (tdata_s2p2nco_in_mixer),
       .tvalid_out       (tvalid_nco2cmbn),
       .tdata_out        (tdata_nco2cmbn)
   );


generate
for (i = 0; i <  N_ANTENNAS; i = i + 1) begin
    jb_dl_dfe_cmbn #(
      .N_CARRIERS (N_CARRIERS),
      .N_ANTENNAS (N_ANTENNAS),
      .PRECISION (PRECISION)
      ) u_dl_dfe_cmbn  (
      .clk            (clk_3x),
      .resetn         (resetn),
      .IFP_dl_dfe_ctrl(IFP_dl_dfe_ctrl),
      .tvalid_in      (tvalid_cmbn_in[i]),
      .tdata_in       (tdata_cmbn_in[i] ),
      .tvalid_out     (tvalid_cmbn_out[i]),
      .tdata_out      (tdata_cmbn_out[i])
    );
end 
endgenerate  





generate
for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : ant_pre_cfr_blocks

	 always @(posedge clk_3x) begin //no reset,  already config gets reset in the reg block
	    dl_precfr_gain_scaler_sign_cfg[i]<=IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler_sign[i];
	    dl_precfr_gain_scaler_cfg[i]     <=IFP_dl_dfe_ctrl.dl_ant_precfr_gain_scaler[i];
	    dl_precfr_gain_fraction_cfg[i]   <=IFP_dl_dfe_ctrl.dl_ant_precfr_gain_fraction[i];
	 end
	 
	assign IFP_post_nco[i].tvalid = tvalid_cmbn_out[i];
	assign IFP_post_nco[i].tdata  = tdata_cmbn_out[i] ;
	
	 
	 
	 
	 //instantiate gain block
	 jb_iq_gain_mult_v2 #(
           .PRECISION(PRECISION),
           .SCALER_BW(GAIN_SCALER_BW),
           .USR_ID_BW(USR_ID_BW)
	 ) u_ant_iq_precfr_gain (
        .clk_en           (1'b1                             ),
        .clk              (clk_3x                           ),
        .resetn           (resetn                           ),
	    .scaler_gain_sign (dl_precfr_gain_scaler_sign_cfg[i]),
	    .scaler_gain      (dl_precfr_gain_scaler_cfg[i]     ),
	    .fraction_gain    (dl_precfr_gain_fraction_cfg[i]   ),			
//	    .IFP_dfe_in       (IFP_dl_dfe_ant_uuc3x2pregain[i]  ),
//	    .IFP_dfe_in       (IFP_fir_dout[i]                   ),
	    .IFP_dfe_in       (IFP_post_nco[i]                   ),
        .IFP_dfe_out      (IFP_dl_dfe_ant_pregain2cfr[i]    )
	 );
			
      end : ant_pre_cfr_blocks
	   
   //////////////////////////////////
   // CFR instantiation
   /////////////////////////////////

      assign cfr_din_tready                 = IFP_cfr_s_axis_din.tready;
      assign IFP_cfr_s_axis_din.tvalid      = cfr_din_tready ? IFP_dl_dfe_ant_pregain2cfr[0].tvalid : 1'b0;
      assign IFP_cfr_s_axis_din.tdata       = cfr_din_tready ? cfr_din_tdata : 0;
      
      assign cfr_dout_tvalid                = IFP_cfr_m_axis_dout.tvalid;
      assign cfr_dout_tdata                 = IFP_cfr_m_axis_dout.tdata;
      assign IFP_cfr_m_axis_dout.tready     = 1'b1;
      
 
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : cfr_set 
        assign IFP_dl_dfe_ant_cfr2postgain[i].tuser  = 0;
        assign IFP_dl_dfe_ant_cfr2postgain[i].tkeep  = 0;
        assign IFP_dl_dfe_ant_cfr2postgain[i].tlast  = 0;
        assign IFP_dl_dfe_ant_cfr2postgain[i].tvalid = IFP_dl_dfe_ctrl.bypass_cfr ? IFP_dl_dfe_ant_pregain2cfr[i].tvalid : cfr_dout_tvalid;
        assign IFP_dl_dfe_ant_pregain2cfr[i].tready  = IFP_dl_dfe_ctrl.bypass_cfr ? 1'b1 : cfr_din_tready;
		
	    assign cfr_din_tdata[i*32+PRECISION-1:i*32]       = IFP_dl_dfe_ant_pregain2cfr[i].tdata[PRECISION-1:0];
	    assign cfr_din_tdata[i*32+16+PRECISION-1:i*32+16] = IFP_dl_dfe_ant_pregain2cfr[i].tdata[2*PRECISION-1:PRECISION];
		
	    assign IFP_dl_dfe_ant_cfr2postgain[i].tdata[PRECISION-1:0]           = IFP_dl_dfe_ctrl.bypass_cfr ? IFP_dl_dfe_ant_pregain2cfr[i].tdata[PRECISION-1:0] : cfr_dout_tdata[i*32+PRECISION-1:i*32];
	    assign IFP_dl_dfe_ant_cfr2postgain[i].tdata[2*PRECISION-1:PRECISION] = IFP_dl_dfe_ctrl.bypass_cfr ? IFP_dl_dfe_ant_pregain2cfr[i].tdata[2*PRECISION-1:PRECISION] : cfr_dout_tdata[i*32+16+PRECISION-1:i*32+16];
      end : cfr_set
 
     
      
      //////////////////////////////////
      // POST CFR GAIN instantiation
      //////////////////////////
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : ant_post_cfr_gain
	 always @(posedge clk_3x) begin //no reset,  already config gets reset in the reg block
	    dl_postcfr_gain_scaler_sign_cfg[i]<=IFP_dl_dfe_ctrl.override_postcfr ? IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler_sign[i] : 1'b0;
	    dl_postcfr_gain_scaler_cfg[i]<=IFP_dl_dfe_ctrl.override_postcfr ? IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_scaler[i] : (IFP_dl_dfe_ctrl.bypass_dpd ? 0 : 1);
	    dl_postcfr_gain_fraction_cfg[i]<=IFP_dl_dfe_ctrl.override_postcfr ? IFP_dl_dfe_ctrl.dl_ant_postcfr_gain_fraction[i] : 16'hFFFF;
	 end
	 //instantiate gain block
	 jb_iq_gain_mult_v2 #(
           .PRECISION(PRECISION),
           .USR_ID_BW(USR_ID_BW)
         ) u_ant_iq_postcfr_gain (
        .clk_en                 (1'b1),
            .clk(clk_3x),
            .resetn(resetn),
	    .scaler_gain_sign(dl_postcfr_gain_scaler_sign_cfg[i]),
	    .scaler_gain(dl_postcfr_gain_scaler_cfg[i]),
	    .fraction_gain(dl_postcfr_gain_fraction_cfg[i]),			
	    .IFP_dfe_in(IFP_dl_dfe_ant_cfr2postgain[i]),
            .IFP_dfe_out(IFP_dl_dfe_ant_postgain2dpd[i])
        ); 
      end : ant_post_cfr_gain

/*
     ////////////// TSSI Calculation //////////////////
     //////////////////////////////////////////////////

       for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : dl_tssi
         jb_iq_rssi #(
           .SAMPLE_BW(PRECISION),
           .USR_ID_BW(USR_ID_BW),
           .N_USRS(1),
           .WRSSI(1)
         ) u_iq_tssi (
             .clk_en(1'b1),
             .clk(clk_3x),
             .resetn(resetn),
             .tvalid(IFP_dl_dfe_ant_postgain2dpd[i].tvalid),
             .tdata(IFP_dl_dfe_ant_postgain2dpd[i].tdata),
             .tusr(0),
	     .rssi_load(rssi_load),
	     .rssi_value(tssi[i])
	  );
      end : dl_tssi
  
 */    
      //////////////////////////////////
      // DPD instantiation
      //////////////////////////

      //temp assignments
     
      
      assign dpd_din_tuser=0;
      assign dpd_din_tready = IFP_dpd_s_axis_din.tready;
      assign IFP_dpd_s_axis_din.tdata  = dpd_din_tready ? dpd_din_tdata : 0; //128
      assign IFP_dpd_s_axis_din.tvalid = dpd_din_tready ? IFP_dl_dfe_ant_postgain2dpd[0].tvalid : 1'b0;
      assign IFP_dpd_s_axis_din.tlast  = 0;
      assign IFP_dpd_s_axis_din.tuser  = dpd_din_tuser; //32
      
      assign dpd_dout_tvalid = IFP_dpd_m_axis_dout.tvalid; //128
      assign dpd_dout_tdata  = IFP_dpd_m_axis_dout.tdata;
      assign dpd_dout_tlast  = IFP_dpd_m_axis_dout.tlast;
      assign dpd_dout_tuser  = IFP_dpd_m_axis_dout.tuser;  //32
      assign IFP_dpd_m_axis_dout.tready = 1'b1;
      
    
      
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : dpd_set 
        assign IFP_dl_dfe_dpd2uuc2x[i].tuser  = 0;
        assign IFP_dl_dfe_dpd2uuc2x[i].tkeep  = 0;
        assign IFP_dl_dfe_dpd2uuc2x[i].tlast  = 0;
        assign IFP_dl_dfe_dpd2uuc2x[i].tvalid = real_bypass_dpd ?  IFP_dl_dfe_ant_postgain2dpd[i].tvalid : dpd_dout_tvalid;
        assign IFP_dl_dfe_ant_postgain2dpd[i].tready = real_bypass_dpd ? 1'b1 : dpd_din_tready;
	    assign dpd_din_tdata[i*32+PRECISION-1:i*32]       = IFP_dl_dfe_ant_postgain2dpd[i].tdata[PRECISION-1:0];
	    assign dpd_din_tdata[i*32+16+PRECISION-1:i*32+16] = IFP_dl_dfe_ant_postgain2dpd[i].tdata[2*PRECISION-1:PRECISION];
	    assign IFP_dl_dfe_dpd2uuc2x[i].tdata[PRECISION-1:0]           = real_bypass_dpd ? IFP_dl_dfe_ant_postgain2dpd[i].tdata[PRECISION-1:0]           : dpd_dout_tdata[i*32+PRECISION-1:i*32]      ;
	    assign IFP_dl_dfe_dpd2uuc2x[i].tdata[2*PRECISION-1:PRECISION] = real_bypass_dpd ? IFP_dl_dfe_ant_postgain2dpd[i].tdata[2*PRECISION-1:PRECISION] : dpd_dout_tdata[i*32+16+PRECISION-1:i*32+16];
      end : dpd_set
  

   
   for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: post_dpd_blocks

        jb_pa_srp  #(
            .IQ_PRECISION           (PRECISION)
        ) u_jb_pa_srp (
            .clk                    (clk_3x),                           // i
            .resetn                 (resetn),                           // i
            .IFP_axis_din           (IFP_dl_dfe_dpd2uuc2x[i]),          // jb_axi4_stream_if.slave
            .IFP_axis_dout          (IFP_dl_dfe_srp[i]),                // jb_axi4_stream_if.master
            .rf_slew_limit          (IFP_rfc.rf_slew_limit),            // i [16:0]
            .rf_slew_duration_limit (IFP_rfc.rf_slew_duration_limit),   // i [15:0]
            .rf_slew_fault_count_clr(IFP_rfc.rf_slew_fault_clr[i]),     // i
            .rf_slew_fault_count    (IFP_rfc.rf_slew_fault_count[i]),   // o [31:0]
            .rf_slew_irq            (IFP_rfc.rf_slew_rate_irq[i]),      // o
            .rf_slew_irq_mask       (IFP_rfc.rf_slew_rate_irq_mask[i]), // i
            .rf_slew_irq_clr        (IFP_rfc.rf_slew_rate_irq_clr[i])   // i
        );

        
        assign IFP_dl_dfe_srp[i].tready = 1'b1;

        assign IFP_dl_dfe_srp_odd[i].tvalid     = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tvalid : IFP_dl_dfe_srp[i].tvalid;
        assign IFP_dl_dfe_srp_odd[i].tdata      = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tdata  : IFP_dl_dfe_srp[i].tdata;
        assign IFP_dl_dfe_srp_odd[i].tuser      = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tuser  : IFP_dl_dfe_srp[i].tuser;
        assign IFP_dl_dfe_srp_odd[i].tkeep      = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tkeep  : IFP_dl_dfe_srp[i].tkeep;
        assign IFP_dl_dfe_srp_odd[i].tlast      = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tlast  : IFP_dl_dfe_srp[i].tlast;
        
        assign IFP_dl_dfe_srp_even[i].tvalid    = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tvalid : IFP_dl_dfe_srp[i].tvalid;
        assign IFP_dl_dfe_srp_even[i].tdata     = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tdata  : IFP_dl_dfe_srp[i].tdata;
        assign IFP_dl_dfe_srp_even[i].tuser     = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tuser  : IFP_dl_dfe_srp[i].tuser;
        assign IFP_dl_dfe_srp_even[i].tkeep     = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tkeep  : IFP_dl_dfe_srp[i].tkeep;
        assign IFP_dl_dfe_srp_even[i].tlast     = IFP_rfc.disable_rf_srp[i] ? IFP_dl_dfe_dpd2uuc2x[i].tlast  : IFP_dl_dfe_srp[i].tlast;








//        jb_dl_dfe_fir #(
//                .FIR_INTRP_NO (5),
//                .PRECISION (PRECISION),
//                .FIR_FULL_PRECISION_BW(40),
//                .FIR_DROP_LSBS(15)		
//            ) u_dl_dfe_fir_post_dpd_uuc_poly_2x_odd (
//                 .resetn                 (resetn),                         // i
//                 .clk                    (clk_3x),                         // i
//                 .clk_en                 (1'b1),                       // i
//                 .IFP_axis_in            (IFP_dl_dfe_srp_odd[i]),                    // i 
//                 .IFP_axis_out           (IFP_dl_dfe_ant_poly_odd[i]),                    // i     
//	         .error_flag             (intrp_poly_odd_error_flag[i])
//           );
      
      
//      assign post_dpd_2x_odd_tdata[i] = IFP_dl_dfe_ant_poly_odd[i].tdata;
//      assign post_dpd_2x_odd_tvalid[i] = IFP_dl_dfe_ant_poly_odd[i].tvalid;



always @(posedge clk_3x)begin
 if(IFP_dl_dfe_srp_odd[i].tvalid)
   begin
    s_hb983_odd_tvalid[i] <= IFP_dl_dfe_srp_odd[i].tvalid;
	s_hb983_odd_tdata[i]  <= IFP_dl_dfe_srp_odd[i].tdata;
   end
 else
   begin
    s_hb983_odd_tvalid[i] <= 0;
	s_hb983_odd_tdata[i]  <= IFP_dl_dfe_srp_odd[i].tdata;
   end   
end

always @(posedge clk_3x)begin
 if(IFP_dl_dfe_srp_even[i].tvalid)
   begin
    s_hb983_even_tvalid[i] <= IFP_dl_dfe_srp_even[i].tvalid;
	s_hb983_even_tdata[i]  <= IFP_dl_dfe_srp_even[i].tdata;
   end
 else
   begin
    s_hb983_even_tvalid[i] <= 0;
	s_hb983_even_tdata[i]  <= IFP_dl_dfe_srp_even[i].tdata;
   end
end

//////poly interpolation for i
    hb_491to983_odd hb_491to983_odd_i(
      .aresetn            (1'b1                       ),
      .aclk               (clk_3x                     ),
      .aclken             (1'b1                       ),
      .s_axis_data_tvalid (s_hb983_odd_tvalid[i]      ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (s_hb983_odd_tdata[i][15:0] ),
      .m_axis_data_tvalid (IFP_hb_dout2_odd_i[i].tvalid),
      .m_axis_data_tdata  (IFP_hb_dout2_odd_i[i].tdata)
     );
	 
	 
    hb_491to983_even hb_491to983_even_i(
      .aresetn            (1'b1                        ),
      .aclk               (clk_3x                      ),
      .aclken             (1'b1                        ),
      .s_axis_data_tvalid (s_hb983_even_tvalid[i]      ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (s_hb983_even_tdata[i][15:0] ),
      .m_axis_data_tvalid (IFP_hb_dout2_even_i[i].tvalid),
      .m_axis_data_tdata  (IFP_hb_dout2_even_i[i].tdata)
     );	 
	 
//    jb_ovrfl_undfl_det #(
//      .INPUT_DATA_BUS_WIDTH(32),
//      .OUTPUT_DATA_BUS_WIDTH(16)
//   ) u_983_odd_i (
//     .clk                             (clk_3x          ),
//     .resetn                          (1'b1            ),
//     .clk_en                          (1'b1            ),
//     .data_in                         (IFP_hb_dout2_odd_i[i].tdata),
//     .data_out                        (s_hb_dout2_odd_i[i]),
//     .ovrfl_undfl_flag_msb_plus1_flag ( ),
//     .ovrfl_undfl_flag_all_msb_flag   ( )
//);	 
//
//    jb_ovrfl_undfl_det #(
//      .INPUT_DATA_BUS_WIDTH(32),
//      .OUTPUT_DATA_BUS_WIDTH(16)
//   ) u_983_even_i (
//     .clk                             (clk_3x          ),
//     .resetn                          (1'b1            ),
//     .clk_en                          (1'b1            ),
//     .data_in                         (IFP_hb_dout2_even_i[i].tdata),
//     .data_out                        (s_hb_dout2_even_i[i]),
//     .ovrfl_undfl_flag_msb_plus1_flag ( ),
//     .ovrfl_undfl_flag_all_msb_flag   ( )
//);


data_rnd_satu
    #( .DIN_WIDTH  (32),
	   .FRAC_WIDTH (14),
       .DOUT_WIDTH (16))
    data_rnd_satu_odd_i
    ( 
    .i_rst       (1'b0                       ),
    .i_clk       (clk_3x                     ),   
    .i_data      (IFP_hb_dout2_odd_i[i].tdata),    
    .o_data      (s_hb_dout2_odd_i[i]        )
    ); 

data_rnd_satu
    #( .DIN_WIDTH  (32),
	   .FRAC_WIDTH (14),
       .DOUT_WIDTH (16))
    data_rnd_satu_even_i
    ( 
    .i_rst       (1'b0                        ),
    .i_clk       (clk_3x                      ),   
    .i_data      (IFP_hb_dout2_even_i[i].tdata),    
    .o_data      (s_hb_dout2_even_i[i]        )
    ); 


//         jb_dl_dfe_fir #(
//                .FIR_INTRP_NO (6),
//                .PRECISION (PRECISION),
//                .FIR_FULL_PRECISION_BW(32),
//                .FIR_DROP_LSBS(15)		
//            ) u_dl_dfe_fir_post_dpd_uuc_poly_2x_even (
//                 .resetn                 (resetn),                         // i
//                 .clk                    (clk_3x),                         // i
//                 .clk_en                 (1'b1),   
//                 .IFP_axis_in            (IFP_dl_dfe_srp_even[i]),                    // i 
//                 .IFP_axis_out           (IFP_dl_dfe_ant_poly_even[i]),                    // i     
//	         .error_flag             (intrp_poly_even_error_flag[i])
//           );
 
      
//      assign post_dpd_2x_even_tdata[i] = IFP_dl_dfe_ant_poly_even[i].tdata;
//      assign post_dpd_2x_even_tvalid[i] = IFP_dl_dfe_ant_poly_even[i].tvalid;





////poly interpolation for q
    hb_491to983_odd hb_491to983_odd_q(
      .aresetn            (1'b1                       ),
      .aclk               (clk_3x                     ),
      .aclken             (1'b1                       ),
      .s_axis_data_tvalid (s_hb983_odd_tvalid[i]               ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (s_hb983_odd_tdata[i][31:16]          ),
      .m_axis_data_tvalid (),
      .m_axis_data_tdata  (IFP_hb_dout2_odd_q[i].tdata)
     );
	 
    hb_491to983_even hb_491to983_even_q(
      .aresetn            (1'b1                       ),
      .aclk               (clk_3x                     ),
      .aclken             (1'b1                       ),
      .s_axis_data_tvalid (s_hb983_even_tvalid[i]                ),
      .s_axis_data_tready (),
      .s_axis_data_tdata  (s_hb983_even_tdata[i][31:16]          ),
      .m_axis_data_tvalid (),
      .m_axis_data_tdata  (IFP_hb_dout2_even_q[i].tdata)
     );

//    jb_ovrfl_undfl_det #(
//      .INPUT_DATA_BUS_WIDTH(32),
//      .OUTPUT_DATA_BUS_WIDTH(16)
//   ) u_983_odd_q (
//     .clk                             (clk_3x          ),
//     .resetn                          (1'b1            ),
//     .clk_en                          (1'b1            ),
//     .data_in                         (IFP_hb_dout2_odd_q[i].tdata),
//     .data_out                        (s_hb_dout2_odd_q[i]),
//     .ovrfl_undfl_flag_msb_plus1_flag ( ),
//     .ovrfl_undfl_flag_all_msb_flag   ( )
//);	 
//
//    jb_ovrfl_undfl_det #(
//      .INPUT_DATA_BUS_WIDTH(32),
//      .OUTPUT_DATA_BUS_WIDTH(16)
//   ) u_983_even_q (
//     .clk                             (clk_3x          ),
//     .resetn                          (1'b1            ),
//     .clk_en                          (1'b1            ),
//     .data_in                         (IFP_hb_dout2_even_q[i].tdata),
//     .data_out                        (s_hb_dout2_even_q[i]),
//     .ovrfl_undfl_flag_msb_plus1_flag ( ),
//     .ovrfl_undfl_flag_all_msb_flag   ( )
//);





data_rnd_satu
    #( .DIN_WIDTH  (32),
	   .FRAC_WIDTH (14),
       .DOUT_WIDTH (16))
    data_rnd_satu_odd_q
    ( 
    .i_rst       (1'b0                         ),
    .i_clk       (clk_3x                       ),   
    .i_data      (IFP_hb_dout2_odd_q[i].tdata  ),    
    .o_data      (s_hb_dout2_odd_q[i]          )
    );	



data_rnd_satu
    #( .DIN_WIDTH  (32),
	   .FRAC_WIDTH (14),
       .DOUT_WIDTH (16))
    data_rnd_satu_even_q
    ( 
    .i_rst       (1'b0                         ),
    .i_clk       (clk_3x                       ),   
    .i_data      (IFP_hb_dout2_even_q[i].tdata ),    
    .o_data      (s_hb_dout2_even_q[i]         )
    );	

      assign post_dpd_2x_odd_tdata[i]   = {s_hb_dout2_odd_q[i],s_hb_dout2_odd_i[i]}  ;
      assign post_dpd_2x_odd_tvalid[i]  = IFP_hb_dout2_odd_i[i].tvalid               ;
      assign post_dpd_2x_even_tdata[i]  = {s_hb_dout2_even_q[i],s_hb_dout2_even_i[i]};
      assign post_dpd_2x_even_tvalid[i] = IFP_hb_dout2_even_i[i].tvalid              ;
      

      //DAc expects 
       always @(*) begin
	  tdata_to_dac[i] =0;
	  tdata_to_dac[i][PRECISION-1:0] = post_dpd_2x_odd_tdata[i][PRECISION-1:0];
	  tdata_to_dac[i][16+PRECISION-1:16] = post_dpd_2x_odd_tdata[i][2*PRECISION-1:PRECISION];
	  tdata_to_dac[i][32+PRECISION-1:32] = post_dpd_2x_even_tdata[i][PRECISION-1:0];
	  tdata_to_dac[i][48+PRECISION-1:48] = post_dpd_2x_even_tdata[i][2*PRECISION-1:PRECISION];
       end
       assign unalign_valid_error[i] = ((post_dpd_2x_odd_tvalid[i] & !post_dpd_2x_even_tvalid[i]) | 
					(!post_dpd_2x_odd_tvalid[i] & post_dpd_2x_even_tvalid[i]));
      
        //assign IFP_dl_dfe_out[i].tuser = 0;
        //assign IFP_dl_dfe_out[i].tkeep = 0;
        //assign IFP_dl_dfe_out[i].tlast = 1'b0;
        //assign IFP_dl_dfe_out[i].tdata = tdata_to_dac[i];
        //assign IFP_dl_dfe_out[i].tvalid = post_dpd_2x_odd_tvalid[i];

        assign IFP_dl_dfe_out[i].tuser  = 0;
        assign IFP_dl_dfe_out[i].tkeep  = 0;
        assign IFP_dl_dfe_out[i].tlast  = 1'b0;
        assign IFP_dl_dfe_out[i].tdata  = Error_10ms ? 'd0 : tdata_to_dac[i];
        assign IFP_dl_dfe_out[i].tvalid = post_dpd_2x_odd_tvalid[i];
		
      end : post_dpd_blocks

      
    
   endgenerate
   
//ila_1_for_dfe fir_122to245(
//	.clk(clk_3x), 
//	.probe0(IFP_hb_dout[0][0].tdata[15:0]), 
//	.probe1(IFP_hb_dout[0][0].tdata[31:16]), 
//	.probe2(IFP_hb_dout[0][0].tuser), 
//	.probe3(IFP_hb_dout[0][0].tvalid) 
//);
//
//ila_1_for_dfe fir_245to491(
//	.clk(clk_3x), 
//	.probe0(IFP_fir_dout[0][0].tdata[15:0]), 
//	.probe1(IFP_fir_dout[0][0].tdata[31:16]), 
//	.probe2(IFP_fir_dout[0][0].tuser), 
//	.probe3(IFP_fir_dout[0][0].tvalid) 
//);
//
//ila_1_for_dfe pregain2cfr(
//	.clk(clk_3x), 
//	.probe0(IFP_dl_dfe_ant_pregain2cfr[0].tdata[15:0]), 
//	.probe1(IFP_dl_dfe_ant_pregain2cfr[0].tdata[31:16]), 
//	.probe2(IFP_dl_dfe_ant_pregain2cfr[0].tuser), 
//	.probe3(IFP_dl_dfe_ant_pregain2cfr[0].tvalid) 
//);
//
//ila_1_for_dfe postgain2dpd(
//	.clk(clk_3x), 
//	.probe0(IFP_dl_dfe_ant_postgain2dpd[0].tdata[15:0]), 
//	.probe1(IFP_dl_dfe_ant_postgain2dpd[0].tdata[31:16]), 
//	.probe2(IFP_dl_dfe_ant_postgain2dpd[0].tuser), 
//	.probe3(IFP_dl_dfe_ant_postgain2dpd[0].tvalid) 
//);
//
//ila_1_for_dfe srp_odd(
//	.clk(clk_3x), 
//	.probe0(IFP_dl_dfe_srp_odd[0].tdata[15:0]), 
//	.probe1(IFP_dl_dfe_srp_odd[0].tdata[31:16]), 
//	.probe2(IFP_dl_dfe_srp_odd[0].tuser), 
//	.probe3(IFP_dl_dfe_srp_odd[0].tvalid) 
//);
//    
//ila_1_for_dfe srp_even(
//	.clk(clk_3x), 
//	.probe0(IFP_dl_dfe_srp_even[0].tdata[15:0]), 
//	.probe1(IFP_dl_dfe_srp_even[0].tdata[31:16]), 
//	.probe2(IFP_dl_dfe_srp_even[0].tuser), 
//	.probe3(IFP_dl_dfe_srp_even[0].tvalid) 
//); 
//
//   
//ila_1_for_dfe fir_491to983_odd(
//	.clk(clk_3x), 
//	.probe0(post_dpd_2x_odd_tdata[0][15:0]), 
//	.probe1(post_dpd_2x_odd_tdata[0][31:16]), 
//	.probe2(0), 
//	.probe3(post_dpd_2x_odd_tvalid[0]) 
//);		
//		
//ila_1_for_dfe fir_491to983_even(
//	.clk(clk_3x), 
//	.probe0(post_dpd_2x_even_tdata[0][15:0]), 
//	.probe1(post_dpd_2x_even_tdata[0][31:16]), 
//	.probe2(0), 
//	.probe3(post_dpd_2x_even_tvalid[0]) 
//);			
		
endmodule // jb_dl_dfe_top
