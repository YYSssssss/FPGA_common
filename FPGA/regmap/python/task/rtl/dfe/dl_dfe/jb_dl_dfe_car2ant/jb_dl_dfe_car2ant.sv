////////////////////////////////////////////////////////////////////
////  File Name : jb_dl_dfe_cmbn.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2018
///// Description  : DL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dl_dfe_car2ant  #(
      parameter  DL_TIME_DELAY_BYPASS = 1,
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter  NCO_COEF_WIDTH =40, //
      parameter  NCO_COUNT_WIDTH =39, //
      parameter  NCO_QUAD_LKUP_TBL_ENTRIES = 1024,
      parameter  NCO_COEF_2S_COMPLEMENT=0
   ) (


            input clk_4x,
            input clk_1x,
            input resetn_4x,
            input resetn_1x,
            
            input any_stream_enable,
            
	    jb_dl_dfe_ctrl_devided_if.dl_dfe IFP_dl_dfe_ctrl,
	    
	    // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
	    // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
	    jb_axi4_stream_if.slave IFP_dl_dfe_in[N_CARRIERS-1:0],
        
        input logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]      tvalid_s2p2nco_in,
        input logic [2*PRECISION-1:0]	  tdata_s2p2nco_in [N_CARRIERS-1:0][N_ANTENNAS-1:0],
	    
	    //DPD outputs 2 arrays of axi stream
//	    jb_axi4_stream_if.master IFP_dl_dfe_out[N_ANTENNAS-1:0]
	    jb_axi4_stream_if.master IFP_dl_dfe_out[N_ANTENNAS-1:0][N_CARRIERS-1:0]
      
      
      );

   localparam USR_ID_BW = $clog2(N_ANTENNAS);
   localparam OVER_SAMPLE_RATIO =4;

   logic [N_CARRIERS-1:0]      tvalid_in ;
   logic [2*PRECISION-1:0]	  tdata_in [N_CARRIERS-1:0];
   logic [USR_ID_BW-1:0]	  tuser_in [N_CARRIERS-1:0];

   
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]        tvalid_s2p2nco ;
   logic [2*PRECISION-1:0]	  tdata_s2p2nco [N_CARRIERS-1:0] [N_ANTENNAS-1:0];
   
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]        tvalid_s2p2nco_in_mixer ;
   logic [2*PRECISION-1:0]	  tdata_s2p2nco_in_mixer [N_CARRIERS-1:0] [N_ANTENNAS-1:0];

   
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]           tvalid_nco2cmbn ;
   logic [2*PRECISION-1:0]	  tdata_nco2cmbn [N_CARRIERS-1:0] [N_ANTENNAS-1:0];

   
   logic [N_ANTENNAS-1:0] [N_CARRIERS-1:0] 	  tvalid_cmbn_in   ;//chnaged this for oring
   logic [2*PRECISION-1:0]	  tdata_cmbn_in [N_ANTENNAS-1:0] [N_CARRIERS-1:0] ;

   
   logic [N_ANTENNAS-1:0]     tvalid_cmbn_out ;
   logic [2*PRECISION-1:0]	  tdata_cmbn_out [N_ANTENNAS-1:0];

   
   logic [N_ANTENNAS-1:0]     tvalid_ant_dly_out ;
   logic [2*PRECISION-1:0]	  tdata_ant_dly_out [N_ANTENNAS-1:0];
   
   logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]	 nco_coef;

   genvar   i,j;
   generate
      for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_ant_s2p
      assign nco_coef[i]={IFP_dl_dfe_ctrl.dl_car_nco_msb[i],IFP_dl_dfe_ctrl.dl_car_nco_lsb[i]};
	 assign  tvalid_in[i] = IFP_dl_dfe_in[i].tvalid;
	 assign tdata_in[i] = IFP_dl_dfe_in[i].tdata;
	 assign tuser_in[i] = IFP_dl_dfe_in[i].tuser;
	 assign IFP_dl_dfe_in[i].tready = 1'b1;
   
      jb_dl_dfe_ant_s2p #(
         .N_CARRIERS (N_CARRIERS),
         .N_ANTENNAS (N_ANTENNAS),
         .PRECISION (PRECISION),
	 .USR_ID_BW(USR_ID_BW)		  
      ) u_dl_dfe_ant_s2p (
       .clk_1x(clk_1x),
       .clk_4x(clk_4x),
       .resetn_1x(resetn_1x),
       .resetn_4x(resetn_4x),
       .IFP_dl_dfe_ctrl(IFP_dl_dfe_ctrl),
       .tvalid_in(tvalid_in[i]),
       .tdata_in(tdata_in[i]),//[zle] from the output of module in front of delay module, which is still serial.So it should enter s2p module in order to become parallel format
       .tuser_in(tuser_in[i]),
       .tvalid_out(tvalid_s2p2nco[i]), // No longer used
       .tdata_out(tdata_s2p2nco[i])  // No longer used
	  		  
      );
      end : dl_dfe_ant_s2p
   endgenerate
  
        
   generate 
     if (DL_TIME_DELAY_BYPASS == 1) begin
        assign tvalid_s2p2nco_in_mixer = tvalid_s2p2nco;
        assign tdata_s2p2nco_in_mixer  = tdata_s2p2nco;    
     end
     else begin
        assign tvalid_s2p2nco_in_mixer = tvalid_s2p2nco_in;
        assign tdata_s2p2nco_in_mixer = tdata_s2p2nco_in; //[zle]from the output of delay module, which has been processed from serial to parallel
     end
   endgenerate 
    
   //counter is shared among all carriers, so have one instance
   
   
//   jb_dfe_mixer #(
//       .N_CARRIERS               (N_CARRIERS),
//       .N_ANTENNAS               (N_ANTENNAS),
//       .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
//       .NCO_COEF_2S_COMPLEMENT   (NCO_COEF_2S_COMPLEMENT),
//       .NCO_COUNT_WIDTH          (NCO_COUNT_WIDTH),
//       .NCO_COEF_WIDTH           (NCO_COEF_WIDTH),
//       .PRECISION                (PRECISION)
//   ) u_dl_dfe_mixer  (
//       .clk(clk_1x),
//       .resetn(resetn_1x),
//       .any_stream_enable(any_stream_enable),
//       .nco_coef         (nco_coef),
//
//       .tvalid_in        (tvalid_s2p2nco_in_mixer),
//       .tdata_in         (tdata_s2p2nco_in_mixer),
//       .tvalid_out       (tvalid_nco2cmbn),
//       .tdata_out        (tdata_nco2cmbn)
//   );

   generate
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: dl_dfe_ant_cmbn
       for (j = 0; j <  N_CARRIERS; j = j + 1) begin: dl_dfe_car_cmbn
//	  assign tvalid_cmbn_in[i][j] = tvalid_nco2cmbn[j][i];
//	  assign tdata_cmbn_in[i][j] = tdata_nco2cmbn[j][i];

	  assign tvalid_cmbn_in[i][j] = tvalid_s2p2nco_in_mixer[j][i];
	  assign tdata_cmbn_in[i][j] = tdata_s2p2nco_in_mixer[j][i];



       end : dl_dfe_car_cmbn
      end :dl_dfe_ant_cmbn
   endgenerate

//   generate
//    for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: dl_dfe_ant_cmbn_ant_dly_inst
//     jb_dl_dfe_cmbn #(
//       .N_CARRIERS (N_CARRIERS),
//       .N_ANTENNAS (N_ANTENNAS),
//       .PRECISION (PRECISION)
//   ) u_dl_dfe_cmbn  (
//       .clk(clk_1x),
//       .resetn(resetn_1x),
//       .IFP_dl_dfe_ctrl(IFP_dl_dfe_ctrl),
//       .tvalid_in(tvalid_cmbn_in[i]),
//       .tdata_in(tdata_cmbn_in[i]),
//       .tvalid_out(tvalid_cmbn_out[i]),
//       .tdata_out(tdata_cmbn_out[i])
//   );
//
//     jb_dl_dfe_ant_dly  #(
//       .PRECISION (PRECISION)
//   ) u_jb_dl_dfe_ant_dly  ( 
//       .clk_1x(clk_1x),
//       .resetn_1x(resetn_1x),
//       .ant_delay(IFP_dl_dfe_ctrl.dl_ant_delay[i]),
//       .tvalid_in(tvalid_cmbn_out[i]),
//       .tdata_in(tdata_cmbn_out[i]),
//       .tvalid_out(tvalid_ant_dly_out[i]),
//       .tdata_out(tdata_ant_dly_out[i])
//    );
//       
//
// 
//     assign IFP_dl_dfe_out[i].tvalid = tvalid_ant_dly_out[i];
//     assign IFP_dl_dfe_out[i].tdata = tdata_ant_dly_out[i];
//     assign IFP_dl_dfe_out[i].tuser = 0;
//     assign IFP_dl_dfe_out[i].tkeep = 0;
//     assign IFP_dl_dfe_out[i].tlast = 1'b0;
//       
//    end :  dl_dfe_ant_cmbn_ant_dly_inst
//  endgenerate
   
generate
  for (i = 0; i <  N_ANTENNAS; i = i + 1) begin 
    for (j = 0; j <  N_CARRIERS; j = j + 1) begin  
       assign IFP_dl_dfe_out[i][j].tvalid = tvalid_cmbn_in[i][j];
       assign IFP_dl_dfe_out[i][j].tdata = tdata_cmbn_in[i][j];
       assign IFP_dl_dfe_out[i][j].tuser = 0;
       assign IFP_dl_dfe_out[i][j].tkeep = 0;
       assign IFP_dl_dfe_out[i][j].tlast = 1'b0;   
    end 
  end 
endgenerate   
   
   
endmodule // jb_dl_dfe_car2ant

