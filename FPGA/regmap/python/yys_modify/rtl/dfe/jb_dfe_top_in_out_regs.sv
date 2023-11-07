
 module jb_dfe_top #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter  NCO_COEF_WIDTH =40 //   
   ) (

      input clk_4x,
      input clk_3x,
      input clk_1x,
      input clk_15p36,
      input resetn,

      
      input axi_clk,
      input axi_resetn,
	    
      
      jb_axi4_stream_if.master  IFP_dpd_s_axis_din,         // 128,32
      jb_axi4_stream_if.slave   IFP_dpd_m_axis_dout,        // 128,32
      
      jb_axi4_stream_if.master  IFP_cfr_s_axis_din,         // 128,1
      jb_axi4_stream_if.slave   IFP_cfr_m_axis_dout,        // 128,1

      
      jb_dl_dfe_ctrl_if.dl_dfe IFP_dl_dfe_ctrl,
      
      jb_ul_dfe_ctrl_if.ul_dfe IFP_ul_dfe_ctrl,
      jb_ul_dfe_stat_if.ul_dfe IFP_ul_dfe_stat,
      

      // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
      // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
      jb_axi4_stream_if.slave IFP_dl_dfe_in[N_CARRIERS-1:0],

      //DPD outputs 2 arrays of axi stream
      jb_axi4_stream_if.master IFP_dl_dfe_out[N_ANTENNAS-1:0],

      

      // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
      // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
      jb_axi4_stream_if.slave IFP_ul_dfe_in[N_ANTENNAS-1:0],

      //DPD outputs 2 arrays of axi stream
      jb_axi4_stream_if.master IFP_ul_dfe_out[N_CARRIERS-1:0]
      
      
      );
   
   localparam USER_ID_BW = $clog2(N_ANTENNAS);

   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_dfe_in_int [N_CARRIERS-1:0] ();//cpri
    jb_axi4_stream_if  #(.DATA_WIDTH(64), .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_dfe_out_int[N_ANTENNAS-1:0](); //dac interface
     jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_ul_dfe_in_int[N_ANTENNAS-1:0]();//adc
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_ul_dfe_out_int[N_CARRIERS-1:0]();//cpri

   jb_axis_dly  #(
       .N_INTF(N_CARRIERS)
   ) u_dl_dfe_in_dly  (
       .clk (clk_4x),
       .resetn(resetn),
       .IFP_axis_in(IFP_dl_dfe_in),
       .IFP_axis_out(IFP_dl_dfe_in_int)
  );
   

   
     jb_dl_dfe_top  #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION (PRECISION),
       .NCO_COEF_WIDTH(NCO_COEF_WIDTH)
   ) u_dl_dfe_top  (
       .clk_4x(clk_4x),
       .clk_3x(clk_3x),
       .clk_1x(clk_1x),
       .resetn(resetn),
       .axi_clk(axi_clk),
       .axi_resetn(axi_resetn),
       .IFP_dpd_s_axis_din      (IFP_dpd_s_axis_din),
       .IFP_dpd_m_axis_dout     (IFP_dpd_m_axis_dout),
       .IFP_cfr_s_axis_din      (IFP_cfr_s_axis_din),
       .IFP_cfr_m_axis_dout     (IFP_cfr_m_axis_dout),
       .IFP_dl_dfe_ctrl(IFP_dl_dfe_ctrl),
       .IFP_dl_dfe_in(IFP_dl_dfe_in_int),
       .IFP_dl_dfe_out(IFP_dl_dfe_out_int) //{q,i} concatenated
   );



     jb_axis_dly  #(
       .N_INTF(N_ANTENNAS)
   ) u_dl_dfe_out_dly  (
       .clk (clk_4x),
       .resetn(resetn),
       .IFP_axis_in(IFP_dl_dfe_out_int),
       .IFP_axis_out(IFP_dl_dfe_out)
  );

   
     jb_axis_dly  #(
       .N_INTF(N_ANTENNAS)
   ) u_ul_dfe_in_dly  (
       .clk (clk_4x),
       .resetn(resetn),
       .IFP_axis_in(IFP_ul_dfe_in),
       .IFP_axis_out(IFP_ul_dfe_in_int)
  );

   
     jb_ul_dfe_top  #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION (PRECISION),
       .NCO_COEF_WIDTH(NCO_COEF_WIDTH)
   ) u_ul_dfe_top  (
       .clk_4x(clk_4x),
       .clk_3x(clk_3x),
       .clk_1x(clk_1x),
       .clk_15p36(clk_15p36),
       .resetn(resetn),
       .IFP_ul_dfe_ctrl(IFP_ul_dfe_ctrl),
       .IFP_ul_dfe_stat(IFP_ul_dfe_stat),
       .IFP_ul_dfe_in(IFP_ul_dfe_in_int),
       .IFP_ul_dfe_out(IFP_ul_dfe_out_int) //{q,i} concatenated
   );

     jb_axis_dly  #(
       .N_INTF(N_CARRIERS)
   ) u_ul_dfe_out_dly  (
       .clk (clk_4x),
       .resetn(resetn),
       .IFP_axis_in(IFP_ul_dfe_out_int),
       .IFP_axis_out(IFP_ul_dfe_out)
  );

   endmodule
