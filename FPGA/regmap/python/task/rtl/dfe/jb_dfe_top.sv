////////////////////////////////////////////////////////////////////
////  File Name : jb_top_ctrl_cfg.sv
///// Author    : Shehanaj Begum
///// Date      : 2/4/2019
///// Description  : DL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dfe_top #(

      parameter  DL_TIME_DELAY_BYPASS=1,
      parameter  UL_TIME_DELAY_BYPASS=1,
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter  NCO_COEF_WIDTH =40 //   
   ) (
      input [N_CARRIERS-1:0] dl_car_resetn           ,
      input [N_CARRIERS-1:0] dl_clk_x1en             ,
      input [N_CARRIERS-1:0] dl_clk_x4en             ,
      input [N_CARRIERS-1:0] dl_clk_x8en             ,
      input [N_CARRIERS-1:0] dl_clk_x16en            ,
      input [N_CARRIERS-1:0] ul_car_resetn           ,
      input [N_CARRIERS-1:0] ul_clk_x1en             ,
      input [N_CARRIERS-1:0] ul_clk_x4en             ,
      input [N_CARRIERS-1:0] ul_clk_x8en             ,
      input [N_CARRIERS-1:0] ul_clk_x16en            ,
	  input                  Error_10ms,
      input                  clk_4x                  ,
      input                  clk_3x                  ,
      input                  clk_1x                  ,
      input                  ul_dfe_time_delay_resetn,
      input                  resetn_1x               ,
      input                  resetn_4x               ,
      input                  resetn_3x               ,
      input                  rssi_load               ,      
      input                  axi_clk                 ,
      input                  axi_resetn              ,      
      input [N_CARRIERS-1:0] dl_dfe_frm_mrkr         ,
	  
      jb_axi4_stream_if.master          IFP_dpd_s_axis_din            ,         
      jb_axi4_stream_if.slave           IFP_dpd_m_axis_dout           ,       
      jb_axi4_stream_if.master          IFP_cfr_s_axis_din            ,        
      jb_axi4_stream_if.slave           IFP_cfr_m_axis_dout           ,        
      jb_cmn_ctrl_devided_if.cmd_dfe    IFP_cmn_ctrl                  ,
      jb_dl_dfe_rfc_if.dl_dfe           IFP_dl_dfe_rfc                ,      
      jb_dl_dfe_ctrl_devided_if.dl_dfe  IFP_dl_dfe_ctrl               ,
      jb_dl_dfe_stat_devided_if.dl_dfe  IFP_dl_dfe_stat               ,      
      jb_ul_dfe_ctrl_devided_if.ul_dfe  IFP_ul_dfe_ctrl               ,
      jb_ul_dfe_stat_devided_if.ul_dfe  IFP_ul_dfe_stat               ,
      jb_axi4_stream_if.slave           IFP_dl_dfe_in [N_CARRIERS-1:0],
      jb_axi4_stream_if.master          IFP_dl_dfe_out[N_ANTENNAS-1:0],
      jb_axi4_stream_if.slave           IFP_ul_dfe_in [N_ANTENNAS-1:0],
      jb_axi4_stream_if.master          IFP_ul_dfe_out[N_CARRIERS-1:0]

	  
//      jb_axi4_stream_if.slave   IFP_dl_dfe_in_from_fhbuf,



      );

     
   localparam GAIN_SCALER_BW=4;
   
    jb_dl_dfe_top  #(
        .DL_TIME_DELAY_BYPASS(DL_TIME_DELAY_BYPASS),
        .N_CARRIERS          (N_CARRIERS          ),
        .N_ANTENNAS          (N_ANTENNAS          ),
        .PRECISION           (PRECISION           ),
        .GAIN_SCALER_BW      (GAIN_SCALER_BW      ),
        .NCO_COEF_WIDTH      (NCO_COEF_WIDTH      )
    ) u_dl_dfe_top  (
        .car_resetn             (dl_car_resetn      ),     
        .clk_x1en               (dl_clk_x1en        ),       
        .clk_x4en               (dl_clk_x4en        ),      
        .clk_x8en               (dl_clk_x8en        ),       
        .clk_x16en              (dl_clk_x16en       ),      
        .clk_4x                 (clk_4x             ),
        .clk_3x                 (clk_3x             ),
        .clk_1x                 (clk_1x             ),
        .resetn_1x              (resetn_1x          ),
        .resetn_3x              (resetn_3x          ),
        .resetn_4x              (resetn_4x          ),
		.Error_10ms(Error_10ms),
        .axi_clk                (axi_clk            ),
        .axi_resetn             (axi_resetn         ),
        .rssi_load              (rssi_load          ),
	    .dl_dfe_frm_mrkr        (dl_dfe_frm_mrkr    ),
        .IFP_dpd_s_axis_din     (IFP_dpd_s_axis_din ),
        .IFP_dpd_m_axis_dout    (IFP_dpd_m_axis_dout),
        .IFP_cfr_s_axis_din     (IFP_cfr_s_axis_din ),
        .IFP_cfr_m_axis_dout    (IFP_cfr_m_axis_dout),
        .IFP_cmn_ctrl           (IFP_cmn_ctrl       ),
        .IFP_rfc                (IFP_dl_dfe_rfc     ),           
        .IFP_dl_dfe_ctrl        (IFP_dl_dfe_ctrl    ),
        .IFP_dl_dfe_stat        (IFP_dl_dfe_stat    ),
        .IFP_dl_dfe_in          (IFP_dl_dfe_in      ),
        .IFP_dl_dfe_out         (IFP_dl_dfe_out     )  
//       .IFP_dl_dfe_in_from_fhbuf(IFP_dl_dfe_in_from_fhbuf),	
	
   );




(* DONT_TOUCH = "TRUE" *)jb_ul_dfe_top  #(
       .UL_TIME_DELAY_BYPASS(UL_TIME_DELAY_BYPASS),
        .N_CARRIERS         (N_CARRIERS          ),
        .N_ANTENNAS         (N_ANTENNAS          ),
        .PRECISION          (PRECISION           ),
        .GAIN_SCALER_BW     (GAIN_SCALER_BW      ),
        .NCO_COEF_WIDTH     (NCO_COEF_WIDTH      )
    ) u_ul_dfe_top (
        .car_resetn              (ul_car_resetn           ),     
        .clk_x1en                (ul_clk_x1en             ),      
        .clk_x4en                (ul_clk_x4en             ),       
        .clk_x8en                (ul_clk_x8en             ),       
        .clk_x16en               (ul_clk_x16en            ),      
        .clk_4x                  (clk_4x                  ),
        .clk_3x                  (clk_3x                  ),
        .clk_1x                  (clk_1x                  ),
        .resetn_1x               (resetn_1x               ),
       .resetn_3x                (resetn_3x               ),
       .resetn_4x                (resetn_4x               ),       
        .ul_dfe_time_delay_resetn(ul_dfe_time_delay_resetn),
        .rssi_load               (rssi_load               ),
        .IFP_cmn_ctrl            (IFP_cmn_ctrl            ),
        .IFP_ul_dfe_ctrl         (IFP_ul_dfe_ctrl         ),
        .IFP_ul_dfe_stat         (IFP_ul_dfe_stat         ),
        .IFP_ul_dfe_in           (IFP_ul_dfe_in           ),
        .IFP_ul_dfe_out          (IFP_ul_dfe_out          )  
    );


   endmodule
