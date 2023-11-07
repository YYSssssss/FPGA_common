`timescale 1 ns / 1 ps

module jb_powermeter #(
    parameter N_ANTS_SEL   =0,
    parameter N_ANTENNAS   =4,
    parameter N_CARRIERS   =2,
    parameter DFE_PRECISION=16
) (

      input                      clk_3x           ,
      input                      resetn_3x        ,
	  input                      syn_data_dl_ul_5ms,
      input                      rssi_load        ,  
      output logic  [3:0] [31:0] ant_tssi         ,
      output logic  [3:0] [31:0] ul_ant_wrssi     ,
      output logic  [3:0] [31:0] orx_wrssi        ,	  
      input                      pa_odp_tssi_le   ,
      output logic  [3:0] [31:0] pa_odp_tssi      ,
      jb_hw_ctrl_if.hw_ctrl      IFP_hw_ctrl      ,
	  jb_test_ctrl_if.test_dbg   IFP_test_ctrl    ,
      jb_axi4_stream_if.slave    IFP_dac[N_ANTENNAS-1:0]       , 
      jb_axi4_stream_if.slave    IFP_ul_dfe_in[N_ANTENNAS-1:0] ,
      jb_axi4_stream_if.slave    IFP_srx[N_ANTENNAS-1:0]        
);	  
	  
logic  [N_ANTENNAS-1:0][31:0]      s_sel_tdata=0  ;
logic  [N_ANTENNAS-1:0]            s_sel_tvalid   ;	  
logic  [3:0] [31:0]                s_ant_wrssi    ;	  
	  
   //////////////////////////////////////////////////
   ////////////// TSSI Calculation //////////////////
   //////////////////////////////////////////////////
	logic  overiride_tcs_mode_control_rx_tx;	
	assign overiride_tcs_mode_control_rx_tx = (IFP_test_ctrl.debug_rw[0] == 'd0 ? IFP_hw_ctrl.rx_tx_mode_sel : syn_data_dl_ul_5ms);
	
always @(posedge clk_3x) begin
    if (overiride_tcs_mode_control_rx_tx == 1'b1)
        begin
          s_sel_tdata[0]   <= IFP_srx[0].tdata ;
          s_sel_tvalid[0]  <= IFP_srx[0].tvalid;
          s_sel_tdata[1]   <= IFP_srx[1].tdata ;
          s_sel_tvalid[1]  <= IFP_srx[1].tvalid;
          s_sel_tdata[2]   <= IFP_srx[2].tdata ;
          s_sel_tvalid[2]  <= IFP_srx[2].tvalid;
          s_sel_tdata[3]   <= IFP_srx[3].tdata ;
          s_sel_tvalid[3]  <= IFP_srx[3].tvalid;
        end
    else if (overiride_tcs_mode_control_rx_tx == 1'b0)				  
        begin
          s_sel_tdata[0]   <= IFP_ul_dfe_in[0].tdata ;
          s_sel_tvalid[0]  <= IFP_ul_dfe_in[0].tvalid;
          s_sel_tdata[1]   <= IFP_ul_dfe_in[1].tdata ;
          s_sel_tvalid[1]  <= IFP_ul_dfe_in[1].tvalid;
          s_sel_tdata[2]   <= IFP_ul_dfe_in[2].tdata ;
          s_sel_tvalid[2]  <= IFP_ul_dfe_in[2].tvalid;
          s_sel_tdata[3]   <= IFP_ul_dfe_in[3].tdata ;
          s_sel_tvalid[3]  <= IFP_ul_dfe_in[3].tvalid;
        end
    else
        begin
          s_sel_tdata[0]   <= 'd0   ;
          s_sel_tvalid[0]  <= 'd0   ;
          s_sel_tdata[1]   <= 'd0   ;
          s_sel_tvalid[1]  <= 'd0   ;
          s_sel_tdata[2]   <= 'd0   ;
          s_sel_tvalid[2]  <= 'd0   ;
          s_sel_tdata[3]   <= 'd0   ;
          s_sel_tvalid[3]  <= 'd0   ;
        end
	
end      
   
genvar i;
generate
       for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : dl_tssi
         jb_iq_rssi #(
           .SAMPLE_BW(DFE_PRECISION),
           .USR_ID_BW(1),
           .N_USRS(1),
           .WRSSI(1)
         ) u_iq_tssi_odd  (
             .clk_en      (1'b1                  ),
             .clk         (clk_3x                ),
             .resetn      (resetn_3x             ),
             .tvalid      (IFP_dac[i].tvalid     ),
             .tdata       (IFP_dac[i].tdata[31:0]),
             .tusr        (1'b0                  ),
	         .rssi_load   (rssi_load             ),
	         .rssi_value  (ant_tssi[i]           )
	       );

         jb_iq_rssi #(
             .SAMPLE_BW          (DFE_PRECISION),
             .USR_ID_BW          (1),
             .N_USRS             (1),
             .WRSSI              (1)
         ) u_rf_odp_tssi  (
             .clk_en             (1'b1                  ),// i
             .clk                (clk_3x                ),// i
             .resetn             (resetn_3x             ),// i
             .tvalid             (IFP_dac[i].tvalid     ),// i
             .tdata              (IFP_dac[i].tdata[31:0]),// i [31:0]
             .tusr               (1'b0                  ),// i [1:0]
	         .rssi_load          (pa_odp_tssi_le        ),// i                   
	         .rssi_value         (pa_odp_tssi[i]   ) // o [31:0]
	       );

      end : dl_tssi
   ///////////////////////////////////////////////////
   ////////////// WRSSI Calculation //////////////////
   //////////////////////////////////////////////////
    for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : ul_wrssi
        jb_iq_rssi #(
           .SAMPLE_BW(DFE_PRECISION),
           .USR_ID_BW(1),
           .N_USRS(1),
           .WRSSI(1)
         ) u_iq_wrssi (
             .clk_en      (1'b1                   ),
             .clk         (clk_3x                 ),
             .resetn      (resetn_3x              ),
             .tvalid      (s_sel_tvalid[i]        ),
             .tdata       (s_sel_tdata[i]         ),
             .tusr        (1'b0                   ),
	         .rssi_load   (rssi_load              ),
	         .rssi_value  (s_ant_wrssi[i]         )
	  );
      end : ul_wrssi
endgenerate


always @(posedge clk_3x) begin
    if (overiride_tcs_mode_control_rx_tx == 1'b1)begin         
          orx_wrssi    <= s_ant_wrssi ;
		  ul_ant_wrssi <= 'd0;
    end
    else if (overiride_tcs_mode_control_rx_tx == 1'b0)begin				         
		  orx_wrssi    <= 'd0 ;
          ul_ant_wrssi <= s_ant_wrssi ;
    end
    else begin      
		  orx_wrssi    <= 'd0 ;
          ul_ant_wrssi <= 'd0 ;
    end		
end

	
endmodule
