
 module jb_dl_dfe_input_stage #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION =16,
      parameter  OVER_SAMPLE_RATIO=4
   ) (
      input [N_CARRIERS-1:0] clk_x1en ,
      input [N_CARRIERS-1:0] clk_x4en ,

      input clk_1x,
      input clk_4x,
      input resetn,
      input  [N_CARRIERS-1:0]  dl_dfe_frm_mrkr,
//      input 					IFP_iwavebuf_porta_rst,
//      input                   IFP_iwavebuf_porta_clk,	
//      jb_ram_sp_if.mem        IFP_iwavebuf_porta,
      jb_dl_dfe_ctrl_devided_if.dl_dfe  IFP_dl_dfe_ctrl,
      input         [3:0]       rf_odp_ant_mute,
      jb_cmn_ctrl_devided_if.cmd_dfe    IFP_cmn_ctrl,

     
      // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
      // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
      jb_axi4_stream_if.slave IFP_dl_dfe_in[N_CARRIERS-1:0],
//      jb_axi4_stream_if.slave IFP_dl_dfe_in_from_fhbuf,

      //interleave 4 antenna paths
      jb_axi4_stream_if.master IFP_dl_dfe_out[N_CARRIERS-1:0]
     
      );

    //localparam USER_ID_BW = $clog2(N_ANTENNAS);
    localparam USER_ID_BW = 2;
    localparam MAX_NUM_SAMPLES=32744;//15 bits
   
//   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_dfe_gen_iq_out();
//    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_dfe_store_iq_in();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_pre_dfe_out[N_CARRIERS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_dl_dfe_mux_iq();
   
  logic [USER_ID_BW-1:0] user_id [N_CARRIERS-1:0]; 
  logic [N_CARRIERS-1:0] stream_en;
  
   
//zle modify   
//  jb_dl_dfe_gen_input_iq #(
//      .N_ANTENNAS(N_ANTENNAS),
//      .MAX_NUM_SAMPLES(MAX_NUM_SAMPLES),
//      .PRECISION(PRECISION),
//      .OVER_SAMPLE_RATIO(OVER_SAMPLE_RATIO)
//   ) u_dl_dfe_gen_input_iq (
//      .clk_x1en (clk_x1en[0]),
//      .clk_x4en (clk_x4en[0]),
//      .clk_1x(clk_1x),
//      .clk_4x(clk_4x),
//      .resetn(resetn),
//	  .IFP_iwavebuf_porta_rst  (IFP_iwavebuf_porta_rst),
//	  .IFP_iwavebuf_porta_clk  (IFP_iwavebuf_porta_clk),
//	  .IFP_iwavebuf_porta      (IFP_iwavebuf_porta),
//      .dl_dfe_frm_mrkr        (dl_dfe_frm_mrkr[0]),
//      .IFP_dl_dfe_ctrl        (IFP_dl_dfe_ctrl),
//      .IFP_dl_dfe_out         (IFP_dl_dfe_gen_iq_out),
//      .IFP_dl_dfe_in          (IFP_dl_dfe_store_iq_in)
//	  
//    );
				 
//   assign IFP_dl_dfe_store_iq_in.tvalid = IFP_dl_dfe_in[0].tvalid;
//   assign IFP_dl_dfe_store_iq_in.tdata =  IFP_dl_dfe_in[0].tdata;
//   assign IFP_dl_dfe_store_iq_in.tuser =IFP_dl_dfe_in[0].tuser;
//   assign IFP_dl_dfe_store_iq_in.tkeep = 0;

   
   //Mux between the gen iq and cpri data
  genvar    i,j;
   generate
      for (i = 0; i <  N_CARRIERS; i = i + 1) begin:ant_set
	 
	
	    //Remove reset since FPGA reset can take resources
//zle modify		
//        assign   IFP_dl_pre_dfe_out[i].tuser = IFP_dl_dfe_ctrl.dl_test_mode_en ? IFP_dl_dfe_gen_iq_out.tuser : IFP_dl_dfe_in[i].tuser;
//        assign  IFP_dl_pre_dfe_out[i].tdata = IFP_dl_dfe_ctrl.dl_test_mode_en ? IFP_dl_dfe_gen_iq_out.tdata : IFP_dl_dfe_in[i].tdata;
//        assign   IFP_dl_pre_dfe_out[i].tvalid =IFP_dl_dfe_ctrl.dl_test_mode_en ? IFP_dl_dfe_gen_iq_out.tvalid : IFP_dl_dfe_in[i].tvalid;
        assign IFP_dl_pre_dfe_out[i].tuser  = IFP_dl_dfe_in[i].tuser;
        assign IFP_dl_pre_dfe_out[i].tdata  = IFP_dl_dfe_in[i].tdata;
        assign IFP_dl_pre_dfe_out[i].tvalid = IFP_dl_dfe_in[i].tvalid;	
        assign IFP_dl_pre_dfe_out[i].tkeep  = 0;
		
	    assign IFP_dl_dfe_in[i].tready      =1'b1;
	    assign user_id[i]                   = IFP_dl_pre_dfe_out[i].tuser;
		
     //assign stream_en[i] = IFP_cmn_ctrl.dl_stream_en[i][user_id[i]] ;
     // Mute all carriers for a requested antenna
     assign stream_en[i] = IFP_cmn_ctrl.dl_stream_en[i][user_id[i]] & (!(rf_odp_ant_mute[user_id[i]])) & (!(IFP_dl_dfe_ctrl.dl_dfe_mute_path[i][user_id[i]]));
     
	 always @(posedge clk_1x)
       if (!resetn) begin
           IFP_dl_dfe_out[i].tuser <= '0;
           IFP_dl_dfe_out[i].tdata <= '0;
           IFP_dl_dfe_out[i].tvalid <= '0;
       end
       else if (clk_x1en[i])
     begin
	    //Remove reset since FPGA reset can take resources
           IFP_dl_dfe_out[i].tuser <= IFP_dl_pre_dfe_out[i].tuser;
           IFP_dl_dfe_out[i].tdata <= stream_en[i] ?  IFP_dl_pre_dfe_out[i].tdata : 0 ;
           IFP_dl_dfe_out[i].tvalid <=IFP_dl_pre_dfe_out[i].tvalid;
	 end

     assign IFP_dl_dfe_out[i].tkeep = 0;
	 assign  IFP_dl_pre_dfe_out[i].tready=1'b1;
	 
      end :ant_set
   endgenerate
   
   
         
      //ila_input_stage_en u_ila_input_stage_en (
	  //.clk   (clk_4x), // input wire clk
	  //.probe0(stream_en[0]), // input wire [0:0]  probe0  
	  //.probe1(user_id[0]), // input wire [1:0]  probe1 
	  //.probe2(IFP_dl_dfe_out[0].tdata[31:0]),
	  //.probe3(IFP_dl_dfe_out[0].tuser),
	  //.probe4(IFP_dl_dfe_out[0].tvalid), // input wire [31:0]  probe2
	  //.probe5(Error_10ms)
      //);


endmodule // jb_dl_dfe_input_stage

