
module jb_dl_dfe_car #(
    parameter  N_CARRIERS=2,
    parameter  N_ANTENNAS=4,
    parameter  PRECISION=16
) (
    input 				 clk_x4en,
    input 				 clk_x8en,
    input 				 clk_x16en,
    input 				 clk_4x,
    input 				 clk_8x,
    input 				 clk_16x,
    input 				 resetn,
    input [3:0] 		 car_bw,
    input                ps_filter_bypass,
    input 				 clear_ovrfl_undfl_pulse,
    output logic [N_ANTENNAS-1:0] [31:0] car_inrtp_sat_err_status,
    output logic [31:0] 		 ps_sat_err_status,
					 jb_axi4_stream_if.slave IFP_dl_dfe_in,
					 jb_axi4_stream_if.master IFP_dl_dfe_out
);

    `include  "jb_common.svh"

    localparam USER_ID_BW = $clog2(N_ANTENNAS);
    localparam FIRST_FIR_OP_FULL_PRECISION_DW = 80; //PRECISION+17=33, multiple of 8 = 40, 2X40=80
    localparam FIRST_TRUNCATE_LSB_BITS=15;//COEF_BITWIDTH-1
    localparam SECOND_FIR_OP_FULL_PRECISION_DW = 64; //PRECISION+17=33, multiple of 8 = 40, 2X40=80
    localparam SECOND_TRUNCATE_LSB_BITS=15;

    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fir_s_axis();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fir_s_axis_mux();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fir_m_axis[3:0]();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fir_intrp1_out();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fir_intrp2_out();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) IFP_fir_ps();

   (* dont_touch = "true" *) logic    [3:0] event_s_data_chanid_incorrect;

    logic [FIRST_FIR_OP_FULL_PRECISION_DW-1:0]   fir0_s_axis_tdata;
    logic [SECOND_FIR_OP_FULL_PRECISION_DW-1:0]  fir1_s_axis_tdata;
    logic [63:0] fir2_s_axis_tdata;
    logic        fir2_s_axis_tready;
    logic [63:0] fir3_s_axis_tdata;
    logic        fir3_s_axis_tready;
    logic [PRECISION-1:0] fir_dout_i [3:0];
    logic [PRECISION-1:0] fir_dout_q [3:0];
    logic [1:0] tuser_cnt;
    logic       tuser_cnt_en;
   
    logic [31:0] dl_dfe_car_sat_err;
    logic [3:0] [7:0] intrp_error_flag; //4 interpolation filters, each one 8 flags
   
    logic [7:0]  ps_error_flag; //4 interpolation filters, each one 8 flags
   
    logic [N_ANTENNAS-1:0] [3:0] [7:0] intrp_error_flag_all;
    logic [N_ANTENNAS-1:0] [7:0] ps_error_flag_all;
    logic fir2_s_axis_tvalid;
    logic [3:0][USER_ID_BW-1:0] user_id;
    logic [USER_ID_BW-1:0]      ps_user_id;
   

   genvar i,j,k;
   

 
   assign ps_user_id = IFP_fir_s_axis.tuser;
   
   always_ff @(posedge clk_4x) begin
      if (!resetn) begin
         ps_error_flag_all <= 0;
      end
      else if (clk_x4en) begin
         ps_error_flag_all[ps_user_id]  <= ps_error_flag;
      end
   end
   
   generate
      for (j = 0; j < 4; j = j + 1) begin : ps_ant_ovfl_set //Antenna number
	 for (k = 0; k < 8; k = k + 1) begin : ps_stat_ovfl_set 
	    always_ff @(posedge clk_4x) begin
	       if (!resetn) begin
		  ps_sat_err_status[j*8+k] <= 0;
	       end
	       else if (clear_ovrfl_undfl_pulse) begin
		  ps_sat_err_status[j*8+k] <= 0;
	       end
	       else if (clk_x4en) begin
		  if (ps_error_flag_all[j][k]==1) begin
		     ps_sat_err_status[j*8+k]  <= 1'b1;
		  end
	       end
	    end //always
	 end : ps_stat_ovfl_set 
      end : ps_ant_ovfl_set
      
      //pack the erros and use user id to save per antenna
      for (j = 0; j < 4; j = j + 1) begin : gen_error_flag //no of interpolator stages
	 assign user_id[j] = IFP_fir_m_axis[j].tuser;
 
	 always_ff @(posedge clk_4x) begin
            if (!resetn) begin
               intrp_error_flag_all[user_id[j]][j] <= 0;
            end
            else if (clk_x4en) begin
               intrp_error_flag_all[user_id[j]][j] <= intrp_error_flag[j];
            end
	 end
	 
 
      end : gen_error_flag
      
       for (i = 0; i < 4; i = i + 1) begin :  ant_ovfl_set//no of N_ANT
	   for (j = 0; j < 4; j = j + 1) begin : intrp_ovfl_set //intrp number
	      for (k = 0; k < 8; k = k + 1) begin : stat_ovfl_set 
		 always_ff @(posedge clk_4x) begin
		    if (!resetn) begin
		       car_inrtp_sat_err_status[i][j*8+k] <= 0;
		    end
		    else if (clear_ovrfl_undfl_pulse) begin
		       car_inrtp_sat_err_status[i][j*8+k] <= 0;
		    end
		    else if (clk_x4en) begin
		       if (intrp_error_flag_all[i][j][k]==1) begin
			  car_inrtp_sat_err_status[i][j*8+k]  <= 1'b1;
		       end
		    end
		 end //always
	      end : stat_ovfl_set 
	   end : intrp_ovfl_set
       end : ant_ovfl_set
   endgenerate
   
    // ------------------------------------------------------------------ //
    // 1st 2x Interpolation Filter for All Bandwidths                     //
    // ------------------------------------------------------------------ //
    // Following logic prevents out-of-sequence stream from entering the  //
    // Interpolation filter chain. Tuser (along with tvalid) input to FIR //
    // must start at 0 and also remain in sequence (i.e. 0-3). The logic  //
    // also prevents repeating tuser from entering the filters.           //
    // An out-of-sequence stream or a repeating user id corrupts FIR's    //
    // internal channel ID, causing output data to appear on a random     //
    // (incorrect) channel (tuser).                                       //
    // ------------------------------------------------------------------ //
    
    assign tuser_cnt_en = IFP_dl_dfe_in.tvalid & (IFP_dl_dfe_in.tuser == tuser_cnt);

    always_ff @(posedge clk_4x) begin
        if (!resetn) begin
            tuser_cnt <= '0;
        end
        else if (clk_x4en) begin
            if (tuser_cnt_en)
                tuser_cnt <= tuser_cnt + 1;
        end
    end



    assign IFP_dl_dfe_in.tready     = ps_filter_bypass  ? IFP_fir_s_axis_mux.tready : IFP_fir_ps.tready;
    assign IFP_fir_ps.tvalid = IFP_dl_dfe_in.tvalid & (IFP_dl_dfe_in.tuser == tuser_cnt);
    assign IFP_fir_ps.tuser  = IFP_dl_dfe_in.tuser;
    assign IFP_fir_ps.tdata  = IFP_dl_dfe_in.tdata;
   
    jb_dl_dfe_fir #(
       .FIR_INTRP_NO (7),
       .PRECISION (PRECISION),
       .FIR_FULL_PRECISION_BW(33),
       .FIR_DROP_LSBS(15)			  
   ) u_dl_dfe_car_ps (
        .resetn                       (resetn),                         // i
        .clk                          (clk_4x),                         // i
        .clk_en                       (clk_x4en),                       // i
        .IFP_axis_in                  (IFP_fir_ps),                    // i 
        .IFP_axis_out                 (IFP_fir_s_axis),                    // i     
	.error_flag                   (ps_error_flag)
   );


    //assign IFP_dl_dfe_in.tready     = IFP_fir_s_axis[0].tready;
    assign IFP_fir_s_axis_mux.tvalid = ps_filter_bypass  ?  (IFP_dl_dfe_in.tvalid & (IFP_dl_dfe_in.tuser == tuser_cnt)) : IFP_fir_s_axis.tvalid;
    assign IFP_fir_s_axis_mux.tuser  = ps_filter_bypass  ?  IFP_dl_dfe_in.tuser : IFP_fir_s_axis.tuser;
    assign IFP_fir_s_axis_mux.tdata  = ps_filter_bypass  ?  IFP_dl_dfe_in.tdata : IFP_fir_s_axis.tdata;
    

   


   jb_dl_dfe_fir #(
       .FIR_INTRP_NO (0),
       .PRECISION (PRECISION),
       .FIR_FULL_PRECISION_BW(33),
       .FIR_DROP_LSBS(15)			  
   ) u_dl_dfe_car_intrp0 (
        .resetn                       (resetn),                         // i
        .clk                          (clk_4x),                         // i
        .clk_en                       (clk_x4en),                       // i
        .IFP_axis_in                  (IFP_fir_s_axis_mux),                    // i 
        .IFP_axis_out                 (IFP_fir_m_axis[0]),                    // i     
	.error_flag                   (intrp_error_flag[0])
   );
 		
/*

  jb_fir_dl_car_intrp1_uuc_wrap   #(
       .PRECISION (PRECISION),
       .FIR_FULL_PRECISION_BW(32),
       .FIR_DROP_LSBS(15)			  
   )  u_dl_dfe_car_intrp1 (
        .resetn                       (resetn),                         // i
        .clk                          (clk_4x),                         // i
        .clk_en                       (clk_x4en),                      // i
        .IFP_axis_in                  (IFP_fir_m_axis[0]),                    // i 
        .IFP_axis_out                 (IFP_fir_m_axis[1]),                    // i     
	.error_flag                   (intrp_error_flag[1])
    );
    // ------------------------------------------------------------------ //
    // 2nd 2x Interpolation Filter for All Bandwidths                     //
    // ------------------------------------------------------------------ //

  */ 
   
    jb_dl_dfe_fir #(
       .FIR_INTRP_NO (1),
       .PRECISION (PRECISION),
       .FIR_FULL_PRECISION_BW(32),
       .FIR_DROP_LSBS(15)		
   ) u_dl_dfe_car_intrp1 (
        .resetn                       (resetn),                         // i
        .clk                          (clk_4x),                         // i
        .clk_en                       (clk_x4en),                       // i
        .IFP_axis_in                  (IFP_fir_m_axis[0]),                    // i 
        .IFP_axis_out                 (IFP_fir_intrp1_out),                    // i     
	.error_flag                   (intrp_error_flag[1])
   );
 
/*
 fir_dl_car_intrp1_uuc u_dl_2nd_stage_uuc (
        .aresetn                        (resetn),                           // i
        .aclk                           (clk_4x),                           // i
        .aclken                         (clk_x4en),                         // i
        .s_axis_data_tvalid             (IFP_fir_m_axis[0].tvalid),         // i
        .s_axis_data_tready             (IFP_fir_m_axis[0].tready),         // o
        .s_axis_data_tuser              (IFP_fir_m_axis[0].tuser),          // i [1 : 0]
        .s_axis_data_tdata              (IFP_fir_m_axis[0].tdata),          // i [31: 0]
        .m_axis_data_tvalid             (IFP_fir_m_axis[1].tvalid),         // o
      //.m_axis_data_tready             (IFP_fir_m_axis[1].tready),         // i
        .m_axis_data_tuser              (IFP_fir_m_axis[1].tuser),          // o [1 : 0]
        .m_axis_data_tdata              (fir1_s_axis_tdata),                // o [63: 0]
        .event_s_data_chanid_incorrect  (event_s_data_chanid_incorrect[1])  // o
    );

    assign fir_dout_q[1] = fir1_s_axis_tdata[62:47];//66:51
    assign fir_dout_i[1] = fir1_s_axis_tdata[30:15];//30:15, 31 is not used
    assign IFP_fir_m_axis[1].tdata = {fir_dout_q[1],fir_dout_i[1]};
	*/	

    // ------------------------------------------------------------------ //
    // 3rd 2x Interpolation Filter for 5MHz and 10MHz Bandwidths          //
    // ------------------------------------------------------------------ //
    
    assign IFP_fir_m_axis[1].tvalid = IFP_fir_intrp1_out.tvalid & clk_x4en;
    assign IFP_fir_m_axis[1].tdata  = IFP_fir_intrp1_out.tdata;
    assign IFP_fir_m_axis[1].tuser  = IFP_fir_intrp1_out.tuser;
    assign IFP_fir_intrp1_out.tready  = IFP_fir_m_axis[1].tready;

    jb_dl_dfe_fir #(
       .FIR_INTRP_NO (2),
       .PRECISION (PRECISION),
       .FIR_FULL_PRECISION_BW(32),
       .FIR_DROP_LSBS(15)		
   ) u_dl_dfe_car_intrp2 (
        .resetn                       (resetn),                         // i
        .clk                          (clk_8x),                         // i
        .clk_en                       (clk_x8en),                       // i
        .IFP_axis_in                  (IFP_fir_m_axis[1]),                    // i 
        .IFP_axis_out                 (IFP_fir_intrp2_out),                    // i     
	.error_flag                   (intrp_error_flag[2])
   );
   

  


    // ------------------------------------------------------------------ //
    // 4th 2x Interpolation Filter for 5MHz Bandwidth                     //
    // ------------------------------------------------------------------ //
    assign IFP_fir_m_axis[2].tvalid = IFP_fir_intrp2_out.tvalid & clk_x8en;
    assign IFP_fir_m_axis[2].tdata  = IFP_fir_intrp2_out.tdata;
    assign IFP_fir_m_axis[2].tuser  = IFP_fir_intrp2_out.tuser;
    assign IFP_fir_intrp2_out.tready  = IFP_fir_m_axis[2].tready;

     jb_dl_dfe_fir #(
       .FIR_INTRP_NO (3),
       .PRECISION (PRECISION),
       .FIR_FULL_PRECISION_BW(32),
       .FIR_DROP_LSBS(15)		
   ) u_dl_dfe_car_intrp3 (
        .resetn                       (resetn),                         // i
        .clk                          (clk_16x),                         // i
        .clk_en                       (clk_x16en),                       // i
        .IFP_axis_in                  (IFP_fir_m_axis[2]),                    // i 
        .IFP_axis_out                 (IFP_fir_m_axis[3]),                    // i     
	.error_flag                   (intrp_error_flag[3])
   );
   
   
 

    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    assign IFP_dl_dfe_out.tkeep     =0;
    assign IFP_dl_dfe_out.tlast     =0;

    // If bw is 20 MHz, tready of '0' will propagate through FIR 3 and 2
    assign IFP_fir_m_axis[1].tready = (car_bw == BW_20MHZ) ? IFP_dl_dfe_out.tready : fir2_s_axis_tready;
    assign IFP_fir_m_axis[2].tready = (car_bw == BW_10MHZ) ? IFP_dl_dfe_out.tready : fir3_s_axis_tready;
    assign IFP_fir_m_axis[3].tready = (car_bw == BW_5MHZ)  ? IFP_dl_dfe_out.tready : 1'b0;

    always_comb begin
        case (car_bw)
            BW_20MHZ    : begin
                            IFP_dl_dfe_out.tvalid    = IFP_fir_m_axis[1].tvalid;
                            IFP_dl_dfe_out.tuser     = IFP_fir_m_axis[1].tuser;
                            IFP_dl_dfe_out.tdata     = IFP_fir_m_axis[1].tdata;
                          end
            BW_10MHZ    : begin
                            IFP_dl_dfe_out.tvalid    = IFP_fir_m_axis[2].tvalid;
                            IFP_dl_dfe_out.tuser     = IFP_fir_m_axis[2].tuser;
                            IFP_dl_dfe_out.tdata     = IFP_fir_m_axis[2].tdata;
                          end
            BW_5MHZ     : begin
                            IFP_dl_dfe_out.tvalid    = IFP_fir_m_axis[3].tvalid;
                            IFP_dl_dfe_out.tuser     = IFP_fir_m_axis[3].tuser;
                            IFP_dl_dfe_out.tdata     = IFP_fir_m_axis[3].tdata;
                          end
            BW_15MHZ    : begin // This is temporary until we have interpolators for 15MHz bw
                            IFP_dl_dfe_out.tvalid    = IFP_fir_m_axis[1].tvalid;
                            IFP_dl_dfe_out.tuser     = IFP_fir_m_axis[1].tuser;
                            IFP_dl_dfe_out.tdata     = IFP_fir_m_axis[1].tdata;
                          end
            default     : begin
                            IFP_dl_dfe_out.tvalid    = IFP_fir_m_axis[1].tvalid;
                            IFP_dl_dfe_out.tuser     = IFP_fir_m_axis[1].tuser;
                            IFP_dl_dfe_out.tdata     = IFP_fir_m_axis[1].tdata;
                          end            
        endcase
    end // always_comb


    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //


//    ila_3 debug0225 (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_dl_dfe_in.tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_dl_dfe_in.tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_dl_dfe_in.tdata), // input wire [31:0]  probe2
//	  .probe3(tuser_cnt_en), // input wire [0:0]  probe0  
//	  .probe4(tuser_cnt) // input wire [1:0]  probe1 
//	  
//    );
//
//
//
//
//    ila_0 u_ila_dl_in_aligned (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_fir_s_axis.tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_fir_s_axis.tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_fir_s_axis.tdata) // input wire [31:0]  probe2
//    );
//
//    ila_0 u_ila_dl_fir0 (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_fir_m_axis[0].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_fir_m_axis[0].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_fir_m_axis[0].tdata) // input wire [31:0]  probe2
//    );
//    ila_0 u_ila_dl_fir1 (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_fir_m_axis[1].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_fir_m_axis[1].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_fir_m_axis[1].tdata) // input wire [31:0]  probe2
//    );
//   ila_0 u_ila_dl_fir2 (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_fir_m_axis[2].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_fir_m_axis[2].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_fir_m_axis[2].tdata) // input wire [31:0]  probe2
//   );
//   ila_0 u_ila_dl_fir3 (
//	  .clk(clk_4x), // input wire clk
//	  .probe0(IFP_fir_m_axis[3].tvalid), // input wire [0:0]  probe0  
//	  .probe1(IFP_fir_m_axis[3].tuser), // input wire [1:0]  probe1 
//	  .probe2(IFP_fir_m_axis[3].tdata) // input wire [31:0]  probe2
//   );


endmodule // jb_dl_dfe_top


