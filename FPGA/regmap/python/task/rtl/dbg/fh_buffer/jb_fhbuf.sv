
 module jb_fhbuf #(
	  parameter  N_ANTS_SEL       =2     ,
      parameter  N_ANTENNAS       =4     ,
      parameter  N_CARRIERS       =2     ,	  
      parameter  MAX_NUM_SAMPLES  =307200,
      parameter  PRECISION        =16    
//      parameter  OVER_SAMPLE_RATIO=4  
   ) (
      input                     clk_x1en                  ,
      input                     clk_1x                    ,
      input [N_ANTS_SEL-1:0][N_CARRIERS-1:0] dl_clk_x1en  ,	  
      input                     resetn                    ,
      input        [31:0]       s_tdata                   , 
      input        [1:0]        s_tuser                   , 
      input                     s_tvalid                  ,
	  input 					IFP_iwavebuf_porta_rst    ,
      input                     IFP_iwavebuf_porta_clk    ,	
      input                     dl_dfe_frm_mrkr           ,	  
	  jb_ram_sp_if.mem          IFP_iwavebuf_porta        ,      
      jb_test_ctrl_if.test_dbg  IFP_test_ctrl              ,
      jb_axi4_stream_if.slave   IFP_dl_dfe_in[N_ANTS_SEL-1:0][N_CARRIERS-1:0],
      jb_axi4_stream_if.master  IFP_dl_pre_dfe_out[N_ANTS_SEL-1:0][N_CARRIERS-1:0],
      jb_axi4_stream_if.master  IFP_test_data[N_ANTS_SEL-1:0]     	  
      );
	  
localparam USER_ID_BW = 2;
jb_axi4_stream_if   #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW))  IFP_fhbuf_out();

  
	  
	  
//jb_fhbuf_input #(
//	  .N_ANTS_SEL          (N_ANTS_SEL        ),
//      .N_ANTENNAS       (N_ANTENNAS     ),
//      .N_CARRIERS       (N_CARRIERS     ),	  
//      .MAX_NUM_SAMPLES  (MAX_NUM_SAMPLES),
//      .PRECISION        (PRECISION      )
//   ) u_fhbuf_input(
//      .clk_x1en              (clk_x1en              ),
//      .clk_1x                (clk_1x                ),
//      .resetn                (resetn                ),
//	  .IFP_iwavebuf_porta_rst(IFP_iwavebuf_porta_rst),
//      .IFP_iwavebuf_porta_clk(IFP_iwavebuf_porta_clk),	
//      .dl_dfe_frm_mrkr       (dl_dfe_frm_mrkr       ),	  
//	  .IFP_iwavebuf_porta    (IFP_iwavebuf_porta    ),      
//      .IFP_test_ctrl         (IFP_test_ctrl         ),
//      .IFP_dl_dfe_in         (IFP_dl_dfe_in         ),
//      .IFP_dl_dfe_out        (IFP_fhbuf_out         )	        
//      );


genvar    i,j;
generate
for (i = 0; i <  N_ANTS_SEL; i = i + 1) begin:band_set
    for (j = 0; j <  N_CARRIERS; j = j + 1) begin:car_set
         
//        assign IFP_dl_pre_dfe_out[i][j].tuser  = IFP_test_ctrl.debug_rw[1][0] == 0 ? s_tuser  : ((IFP_test_ctrl.dl_test_mode_en & (|dl_clk_x1en[i])) ? IFP_fhbuf_out.tuser  : IFP_dl_dfe_in[i][j].tuser );
//        assign IFP_dl_pre_dfe_out[i][j].tdata  = IFP_test_ctrl.debug_rw[1][0] == 0 ? s_tdata  : ((IFP_test_ctrl.dl_test_mode_en & (|dl_clk_x1en[i])) ? IFP_fhbuf_out.tdata  : IFP_dl_dfe_in[i][j].tdata );
//        assign IFP_dl_pre_dfe_out[i][j].tvalid = IFP_test_ctrl.debug_rw[1][0] == 0 ? s_tvalid : ((IFP_test_ctrl.dl_test_mode_en & (|dl_clk_x1en[i])) ? IFP_fhbuf_out.tvalid : IFP_dl_dfe_in[i][j].tvalid);	
        assign IFP_dl_pre_dfe_out[i][j].tkeep  = 0;	    	 
    
        always@(posedge clk_1x)begin
		  if(IFP_test_ctrl.debug_rw[1][0]==1'b1)begin
            IFP_dl_pre_dfe_out[i][j].tuser   <= s_tuser ; 
            IFP_dl_pre_dfe_out[i][j].tdata   <= s_tdata ;
            IFP_dl_pre_dfe_out[i][j].tvalid  <= s_tvalid;
		  end
		  else begin
            IFP_dl_pre_dfe_out[i][j].tuser   <= IFP_dl_dfe_in[i][j].tuser ; 
            IFP_dl_pre_dfe_out[i][j].tdata   <= IFP_dl_dfe_in[i][j].tdata ;
            IFP_dl_pre_dfe_out[i][j].tvalid  <= IFP_dl_dfe_in[i][j].tvalid ;
		  end
        end
	end :car_set	
	
        assign IFP_test_data[i].tvalid = IFP_fhbuf_out.tvalid;
        assign IFP_test_data[i].tuser  = IFP_fhbuf_out.tuser;
        assign IFP_test_data[i].tdata  = IFP_fhbuf_out.tdata;	
	
	
end:band_set
endgenerate








endmodule // jb_dl_dfe_input_stage_gen_iq

