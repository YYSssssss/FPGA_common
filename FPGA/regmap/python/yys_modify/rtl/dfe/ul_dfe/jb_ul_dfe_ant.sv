
 module jb_ul_dfe_ant #(
      parameter  N_ANTENNAS=4, 
      parameter  PRECISION=16,
      parameter  GAIN_SCALER_BW=4,
      parameter  INST_CFR=0,
      parameter  INST_DPD=0   
   ) (

      input clk_3x, //368.64
      input resetn_3x,
      
      jb_ul_dfe_ctrl_devided_if.ul_dfe IFP_ul_dfe_ctrl,
                                               
      input [N_ANTENNAS-1:0]  ul_ant_en,
     
      // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
      // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
      jb_axi4_stream_if.slave IFP_ul_dfe_in[N_ANTENNAS-1:0],

      //DPD outputs 2 arrays of axi stream
      jb_axi4_stream_if.master IFP_ul_dfe_out[N_ANTENNAS-1:0]
      
      
      );

   localparam N_BYTES_AXI = $ceil((PRECISION*2)/8);
   localparam USR_ID_BW   = 1;//no sharing so we don't need usr id
   localparam ILA_EN      = 0;
   
   logic [63:0]          fir_3x_full_data[N_ANTENNAS-1:0];
   logic [PRECISION-1:0] fir_3x_data_i   [N_ANTENNAS-1:0];
   logic [PRECISION-1:0] fir_3x_data_q   [N_ANTENNAS-1:0];

   logic [79:0]   s_hb0_dout_iq     [N_ANTENNAS-1:0];
   logic          s_hb0_dout_v      [N_ANTENNAS-1:0];
   logic [63:0]   s_hb1_dout_iq     [N_ANTENNAS-1:0];
   logic          s_hb1_dout_v      [N_ANTENNAS-1:0];
   logic [79:0]   s_fir_dout_iq     [N_ANTENNAS-1:0];   
   logic          s_fir_dout_v      [N_ANTENNAS-1:0];
   logic [15:0]   s_rnd_satu_dout0_i[N_ANTENNAS-1:0];              
   logic [15:0]   s_rnd_satu_dout0_q[N_ANTENNAS-1:0];              
   logic [15:0]   s_rnd_satu_dout1_i[N_ANTENNAS-1:0];              
   logic [15:0]   s_rnd_satu_dout1_q[N_ANTENNAS-1:0]; 

   logic          s_v_test      [N_ANTENNAS-1:0];
   

   logic  [N_ANTENNAS-1:0]                     ul_ant_gain_scaler_sign_cfg;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_ANTENNAS-1:0][GAIN_SCALER_BW-1:0] ul_ant_gain_scaler_cfg     ;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_ANTENNAS-1:0] [15:0]              ul_ant_gain_fraction_cfg   ;  // Carrier0 in Antenna 0 Path  Gain Register

  
   
 
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ul_dfe_ant_fir2gain[N_ANTENNAS-1:0]();
  

   
genvar i;
generate
    for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : ant_blocks
//decimation from 491 to 245
        hb_491to245 hb_491to245_iq (
         .aresetn            (1'b1                   ),  // input wire aresetn
         .aclk               (clk_3x                 ),  // input wire aclk
         .aclken             (1'b1                   ),  // input wire aclken
         .s_axis_data_tvalid (IFP_ul_dfe_in[i].tvalid),  // input wire s_axis_data_tvalid
         .s_axis_data_tready (                       ),  // output wire s_axis_data_tready
         .s_axis_data_tdata  (IFP_ul_dfe_in[i].tdata ),  // input wire [31 : 0] s_axis_data_tdata
         .m_axis_data_tvalid (s_hb0_dout_v[i]        ),  // output wire m_axis_data_tvalid
         .m_axis_data_tdata  (s_hb0_dout_iq[i]       )  // output wire [63 : 0] m_axis_data_tdata
        );
 
        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (16),
               .DOUT_WIDTH (16))
            data_rnd_satu_inst0_i
            ( 
            .i_rst       (1'b0                  ),
            .i_clk       (clk_3x                ),   
            .i_data      (s_hb0_dout_iq[i][39:0]),    
            .o_data      (s_rnd_satu_dout0_i[i] )
            );      

        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (16),
               .DOUT_WIDTH (16))
            data_rnd_satu_inst0_q
            ( 
            .i_rst       (1'b0                   ),
            .i_clk       (clk_3x                 ),   
            .i_data      (s_hb0_dout_iq[i][79:40]),    
            .o_data      (s_rnd_satu_dout0_q[i]  )
            );			
	 
//decimation from 245 to 122	 
//        hb_245to122 hb_245to122_iq (
//         .aresetn            (1'b1                                           ),  // input wire aresetn
//         .aclk               (clk_3x                                         ),  // input wire aclk
//         .aclken             (1'b1                                           ),  // input wire aclken
//         .s_axis_data_tvalid (s_hb0_dout_v[i]                                ),  // input wire s_axis_data_tvalid
//         .s_axis_data_tready (                                               ),  // output wire s_axis_data_tready
//         .s_axis_data_tdata  ({s_rnd_satu_dout0_q[i],s_rnd_satu_dout0_i[i]}  ),  // input wire [31 : 0] s_axis_data_tdata
//         .m_axis_data_tvalid (s_hb1_dout_v[i]                                ),  // output wire m_axis_data_tvalid
//         .m_axis_data_tdata  (s_hb1_dout_iq[i]                               )  // output wire [63 : 0] m_axis_data_tdata
//        );
 
//        data_rnd_satu
//            #( .DIN_WIDTH  (32),
//			   .FRAC_WIDTH (15),
//               .DOUT_WIDTH (16))
//            data_rnd_satu_inst1_i
//            ( 
//            .i_rst       (1'b0                   ),
//            .i_clk       (clk_3x                 ),   
//            .i_data      (s_hb1_dout_iq[i][31:0] ),    
//            .o_data      (s_rnd_satu_dout1_i[i]  )
//            );      
//
//        data_rnd_satu
//            #( .DIN_WIDTH  (32),
//			   .FRAC_WIDTH (15),
//               .DOUT_WIDTH (16))
//            data_rnd_satu_inst1_q
//            ( 
//            .i_rst       (1'b0                    ),
//            .i_clk       (clk_3x                  ),   
//            .i_data      (s_hb1_dout_iq[i][63:32] ),    
//            .o_data      (s_rnd_satu_dout1_q[i]   )
//            );	 
	 
        fir_245to122 fir_245to122_iq (
         .aresetn            (1'b1                                           ),  // input wire aresetn
         .aclk               (clk_3x                                         ),  // input wire aclk
         .aclken             (1'b1                                           ),  // input wire aclken
         .s_axis_data_tvalid (s_hb0_dout_v[i]                                ),  // input wire s_axis_data_tvalid
         .s_axis_data_tready (                                               ),  // output wire s_axis_data_tready
         .s_axis_data_tdata  ({s_rnd_satu_dout0_q[i],s_rnd_satu_dout0_i[i]}  ),  // input wire [31 : 0] s_axis_data_tdata
         .m_axis_data_tvalid (s_fir_dout_v[i]                                ),  // output wire m_axis_data_tvalid
         .m_axis_data_tdata  (s_fir_dout_iq[i]                               )  // output wire [63 : 0] m_axis_data_tdata
        );
 
        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (16),
               .DOUT_WIDTH (16))
            data_rnd_satu_inst1_i
            ( 
            .i_rst       (1'b0                   ),
            .i_clk       (clk_3x                 ),   
            .i_data      (s_fir_dout_iq[i][39:0] ),    
            .o_data      (s_rnd_satu_dout1_i[i]  )
            );      

        data_rnd_satu
            #( .DIN_WIDTH  (40),
			   .FRAC_WIDTH (16),
               .DOUT_WIDTH (16))
            data_rnd_satu_inst1_q
            ( 
            .i_rst       (1'b0                    ),
            .i_clk       (clk_3x                  ),   
            .i_data      (s_fir_dout_iq[i][79:40] ),    
            .o_data      (s_rnd_satu_dout1_q[i]   )
            );		 
	 
	 
	 
	 
	 
	 
//	 fir_ul_ant_ddc_xby3 u_ul_ant_fir_ddc_xby3
//          (
//           .aclk(clk_3x),
//           .aresetn(resetn_3x),
//           .s_axis_data_tdata(IFP_ul_dfe_in[i].tdata),
//           .s_axis_data_tready(IFP_ul_dfe_in[i].tready),
//           .s_axis_data_tvalid(IFP_ul_dfe_in[i].tvalid),
//           .m_axis_data_tdata(fir_3x_full_data[i]),
//           .m_axis_data_tvalid(IFP_ul_dfe_ant_fir2gain[i].tvalid),
//           .m_axis_data_tuser()
//          );
//	    assign fir_3x_data_q[i] = fir_3x_full_data[i][62:47];//66:51
//	    assign fir_3x_data_i[i] = fir_3x_full_data[i][30:15];//30:15, 31 is not used
        assign IFP_ul_dfe_ant_fir2gain[i].tdata  = {s_rnd_satu_dout1_q[i],s_rnd_satu_dout1_i[i]};
        assign IFP_ul_dfe_ant_fir2gain[i].tuser  = 0;
        assign IFP_ul_dfe_ant_fir2gain[i].tkeep  = 0;
        assign IFP_ul_dfe_ant_fir2gain[i].tlast  = 1'b0;
//        assign IFP_ul_dfe_ant_fir2gain[i].tvalid = s_fir_dout_v[i];

        always @(posedge clk_3x) begin
		  s_v_test[i] <= s_fir_dout_v[i];
		end
        assign IFP_ul_dfe_ant_fir2gain[i].tvalid = s_v_test[i];
		
        always @(posedge clk_3x) begin //no reset,  already config gets reset in the reg block
	       ul_ant_gain_scaler_sign_cfg[i]<=IFP_ul_dfe_ctrl.ul_ant_gain_scaler_sign[i];
	       ul_ant_gain_scaler_cfg[i]     <=IFP_ul_dfe_ctrl.ul_ant_gain_scaler[i]     ;
	       ul_ant_gain_fraction_cfg[i]   <=IFP_ul_dfe_ctrl.ul_ant_gain_fraction[i]   ;
	    end
	
	
	 

	    jb_iq_gain_mult #(
              .PRECISION(PRECISION     ),
              .SCALER_BW(GAIN_SCALER_BW),
              .USR_ID_BW(USR_ID_BW     )
	    ) u_ant_iq_gain (
           .clk_en           (1'b1                          ),
           .clk              (clk_3x                        ),
           .resetn           (resetn_3x                     ),
	       .scaler_gain_sign (ul_ant_gain_scaler_sign_cfg[i]),
	       .scaler_gain      (ul_ant_gain_scaler_cfg[i]     ),
	       .fraction_gain    (ul_ant_gain_fraction_cfg[i]   ),			
	       .IFP_dfe_in       (IFP_ul_dfe_ant_fir2gain[i]    ),
           .IFP_dfe_out      (IFP_ul_dfe_out[i]             )
	    );
			
    end : ant_blocks
	   
endgenerate



/* generate
  if (ILA_EN==1) begin : ila_dbg_en
    ila_0 u_ila_ul_dfe_out (
	   .clk   (clk_3x                       ), // input wire clk
	   .probe0(IFP_ul_dfe_out[0].tvalid     ), // input wire [0:0]  probe0  
	   .probe1(IFP_ul_dfe_out[0].tuser      ), // input wire [1:0]  probe1 
	   .probe2(IFP_ul_dfe_out[0].tdata[31:0])  // input wire [31:0]  probe2
        );
  end : ila_dbg_en
endgenerate  
 */


endmodule // jb_ul_dfe_top
