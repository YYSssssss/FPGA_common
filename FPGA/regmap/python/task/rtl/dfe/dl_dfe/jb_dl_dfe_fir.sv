////////////////////////////////////////////////////////////////////
////  File Name : jb_dl_dfe_car_intrp0.sv
///// Author    : Shehanaj Begum
///// Date      : 3/18/2020
///// Description  : Carrier Interp0 fir Up converter wrapper
///                 
///
////////////////////////////////////////////////////////////////////

module jb_dl_dfe_fir #(
  parameter  FIR_INTRP_NO=0, //intrp0,1,2,3, fir_3x=4, poly_odd=5, poly_even=6
  parameter  PRECISION=16,
  parameter  FIR_FULL_PRECISION_BW=33, //FIR compiler gives out the Full precision bits
  parameter  FIR_DROP_LSBS=15, // bits to truncate for multiplication, depends on coefficient values
  parameter  USER_ID_BW=2 	   
 ) (
    input clk,
    input resetn,
    input clk_en,

    jb_axi4_stream_if.slave     IFP_axis_in,
    jb_axi4_stream_if.master     IFP_axis_out,

    output [7:0]                error_flag

);

  // I & Q are aligned to byte boundary
  localparam FIR_FULL_PRECISION_WHOLE_BW = (FIR_FULL_PRECISION_BW%8==0) ? (FIR_FULL_PRECISION_BW*2) : ((FIR_FULL_PRECISION_BW/8)+1)*8*2;
  localparam FIR_Q_OFFSET = FIR_FULL_PRECISION_WHOLE_BW/2+FIR_DROP_LSBS;
  localparam OVFL_UNDFL_FULL_PRECISIOM_BW =  FIR_FULL_PRECISION_BW-FIR_DROP_LSBS;
   
			     
   logic [PRECISION-1:0] fir_dout_i;
   logic [PRECISION-1:0] fir_dout_q;
   logic [FIR_FULL_PRECISION_WHOLE_BW-1:0]   fir_tdata;

   logic [FIR_FULL_PRECISION_BW-FIR_DROP_LSBS-1:0] fir_tdata_i;   
   logic [FIR_FULL_PRECISION_BW-FIR_DROP_LSBS-1:0] fir_tdata_q;
			     

   //i-> [FIR_FULL_PRECISION_BW-1:FIR_DROP_LSBS];
   //q-> [FIR_FULL_PRECISION_WHOLE_BW/2+FIR_FULL_PRECISION_BW-1:FIR_Q_OFFSET];

    //Set output tdata
    assign IFP_axis_out.tdata = {fir_dout_q,fir_dout_i};

   generate
     if (FIR_INTRP_NO==7) begin : dl_ps_inst
      fir_dl_car_ps u_fir_dl_car_ps (
        .aresetn                        (resetn),                           // i
        .aclk                           (clk),                           // input wire aclk
        .aclken                         (clk_en),                         // i
        .s_axis_data_tvalid             (IFP_axis_in.tvalid),     // input wire s_axis_data_tvalid
        .s_axis_data_tready             (IFP_axis_in.tready),     // output wire s_axis_data_tready
        .s_axis_data_tuser              (IFP_axis_in.tuser),
        .s_axis_data_tdata              (IFP_axis_in.tdata),      // input wire [31 : 0] s_axis_data_tdata
        .m_axis_data_tvalid             (IFP_axis_out.tvalid),            // output wire m_axis_data_tvalid
        .m_axis_data_tdata              (fir_tdata),                     // output wire [79 : 0] m_axis_data_tdata
//      .m_axis_data_tready             (1'b1),                             // output wire s_axis_data_tready
        .m_axis_data_tuser              (IFP_axis_out.tuser),   
        .event_s_data_chanid_incorrect  (error_flag[7])  // o
    );
    end : dl_ps_inst
    else if (FIR_INTRP_NO==0) begin : dl_car_intrp0_inst

        fir_dl_car_intrp0_uuc u_dl_1st_stage_uuc (
         .aresetn                        (resetn),                           // i
         .aclk                           (clk),                           // i
         .aclken                         (clk_en),                         // i
         .s_axis_data_tvalid             (IFP_axis_in.tvalid),         // i
         .s_axis_data_tready             (IFP_axis_in.tready),         // o
         .s_axis_data_tuser              (IFP_axis_in.tuser),          // i [1 : 0]
         .s_axis_data_tdata              (IFP_axis_in.tdata),          // i [31: 0]
         .m_axis_data_tvalid             (IFP_axis_out.tvalid),         // o
       //.m_axis_data_tready             (IFP_axis_out.tready),         // i
         .m_axis_data_tuser              (IFP_axis_out.tuser),          // o [1 : 0]
         .m_axis_data_tdata              (fir_tdata),                // o [79: 0]
         .event_s_data_chanid_incorrect  (error_flag[7])  // o
        );
     end : dl_car_intrp0_inst
     else if (FIR_INTRP_NO==1) begin : dl_car_intrp1_inst
       fir_dl_car_intrp1_uuc u_dl_2nd_stage_uuc (
        .aresetn                        (resetn),                           // i
        .aclk                           (clk),                           // i
        .aclken                         (clk_en),                         // i
        .s_axis_data_tvalid             (IFP_axis_in.tvalid),         // i
        .s_axis_data_tready             (IFP_axis_in.tready),         // o
        .s_axis_data_tuser              (IFP_axis_in.tuser),          // i [1 : 0]
        .s_axis_data_tdata              (IFP_axis_in.tdata),          // i [31: 0]
        .m_axis_data_tvalid             (IFP_axis_out.tvalid),         // o
      //.m_axis_data_tready             (IFP_axis_out.tready),         // i
        .m_axis_data_tuser              (IFP_axis_out.tuser),          // o [1 : 0]
        .m_axis_data_tdata              (fir_tdata),                // o [79: 0]
        .event_s_data_chanid_incorrect  (error_flag[7])  // o
       );
     end : dl_car_intrp1_inst
     else if (FIR_INTRP_NO==2) begin : dl_car_intrp2_inst
        fir_dl_car_intrp2_uuc u_dl_3rd_stage_uuc (
        .aresetn                        (resetn),                           // i
        .aclk                           (clk),                           // i
        .aclken                         (clk_en),                         // i
        .s_axis_data_tvalid             (IFP_axis_in.tvalid),         // i
        .s_axis_data_tready             (IFP_axis_in.tready),         // o
        .s_axis_data_tuser              (IFP_axis_in.tuser),          // i [1 : 0]
        .s_axis_data_tdata              (IFP_axis_in.tdata),          // i [31: 0]
        .m_axis_data_tvalid             (IFP_axis_out.tvalid),         // o
      //.m_axis_data_tready             (IFP_axis_out.tready),         // i
        .m_axis_data_tuser              (IFP_axis_out.tuser),          // o [1 : 0]
        .m_axis_data_tdata              (fir_tdata),                // o [79: 0]
        .event_s_data_chanid_incorrect  (error_flag[7])  // o
    );
     end : dl_car_intrp2_inst
     else if (FIR_INTRP_NO==3) begin : dl_car_intrp3_inst
        fir_dl_car_intrp3_uuc u_dl_3rd_stage_uuc (
        .aresetn                        (resetn),                           // i
        .aclk                           (clk),                           // i
        .aclken                         (clk_en),                         // i
        .s_axis_data_tvalid             (IFP_axis_in.tvalid),         // i
        .s_axis_data_tready             (IFP_axis_in.tready),         // o
        .s_axis_data_tuser              (IFP_axis_in.tuser),          // i [1 : 0]
        .s_axis_data_tdata              (IFP_axis_in.tdata),          // i [31: 0]
        .m_axis_data_tvalid             (IFP_axis_out.tvalid),         // o
      //.m_axis_data_tready             (IFP_axis_out.tready),         // i
        .m_axis_data_tuser              (IFP_axis_out.tuser),          // o [1 : 0]
        .m_axis_data_tdata              (fir_tdata),                // o [79: 0]
        .event_s_data_chanid_incorrect  (error_flag[7])  // o
    );
     end : dl_car_intrp3_inst
     else if (FIR_INTRP_NO==4) begin : dl_ant_uuc_3x
        fir_dl_ant_pre_cfr_uuc_3x u_pre_cfr_uuc_3x
          (
           .aclk(clk),
           .aresetn(resetn),
           .s_axis_data_tdata(IFP_axis_in.tdata),
           .s_axis_data_tready(IFP_axis_in.tready),
           .s_axis_data_tvalid(IFP_axis_in.tvalid),
           .m_axis_data_tdata(fir_tdata),
           .m_axis_data_tvalid(IFP_axis_out.tvalid),
           .m_axis_data_tuser()
          );
	assign IFP_axis_out.tuser=0;
	assign error_flag[7]=0;	
     end : dl_ant_uuc_3x 
     else if (FIR_INTRP_NO==5) begin : dl_ant_uuc_poly_odd
        fir_dl_ant_post_dpd_uuc_poly_2x_odd u_post_dpd_uuc_poly_2x_odd  (
           .aclk(clk),
           .aresetn(resetn),
           .s_axis_data_tdata(IFP_axis_in.tdata),
           .s_axis_data_tready(IFP_axis_in.tready),
           .s_axis_data_tvalid(IFP_axis_in.tvalid),
           .m_axis_data_tdata(fir_tdata),
           .m_axis_data_tvalid(IFP_axis_out.tvalid)
          );
	assign IFP_axis_out.tuser=0;	
	assign error_flag[7]=0;	
     end : dl_ant_uuc_poly_odd
     else if (FIR_INTRP_NO==6) begin : dl_ant_uuc_poly_even
        fir_dl_ant_post_dpd_uuc_poly_2x_even u_post_dpd_uuc_poly_2x_even (
           .aclk(clk),
           .aresetn(resetn),
           .s_axis_data_tdata(IFP_axis_in.tdata),
           .s_axis_data_tready(IFP_axis_in.tready),
           .s_axis_data_tvalid(IFP_axis_in.tvalid),
           .m_axis_data_tdata(fir_tdata),
           .m_axis_data_tvalid(IFP_axis_out.tvalid)
          );
	assign IFP_axis_out.tuser=0;
	assign error_flag[7]=0;		
     end : dl_ant_uuc_poly_even
     else begin : dl_car_dflt
	assign IFP_axis_out.tvalid=1'b0;
	assign IFP_axis_out.tuser=0;
	assign fir_tdata=0;
	assign error_flag[7]=0;
     end : dl_car_dflt
   
   endgenerate
  

   assign fir_tdata_i= fir_tdata[FIR_FULL_PRECISION_BW-1:FIR_DROP_LSBS];
   assign fir_tdata_q=fir_tdata[FIR_FULL_PRECISION_WHOLE_BW/2+FIR_FULL_PRECISION_BW-1:FIR_Q_OFFSET];
   assign error_flag[6:4] = 3'b000;
   
   jb_ovrfl_undfl_det #(
      .INPUT_DATA_BUS_WIDTH(OVFL_UNDFL_FULL_PRECISIOM_BW),
      .OUTPUT_DATA_BUS_WIDTH (PRECISION)
   ) u_intrp_i_ovrfl_undfl_det (

     .clk (clk),
     .resetn(resetn),
     .clk_en(clk_en),

     .data_in(fir_tdata_i),
     .data_out(fir_dout_i),

     .ovrfl_undfl_flag_msb_plus1_flag(error_flag[0]),
     .ovrfl_undfl_flag_all_msb_flag(error_flag[1])
   

);

    jb_ovrfl_undfl_det #(
      .INPUT_DATA_BUS_WIDTH(OVFL_UNDFL_FULL_PRECISIOM_BW),
      .OUTPUT_DATA_BUS_WIDTH(PRECISION)
   ) u_intrp_q_ovrfl_undfl_det (

     .clk (clk),
     .resetn(resetn),
     .clk_en(clk_en),

     .data_in(fir_tdata_q),
     .data_out(fir_dout_q),

     .ovrfl_undfl_flag_msb_plus1_flag(error_flag[2]),
     .ovrfl_undfl_flag_all_msb_flag(error_flag[3])
   

);
   
//    ila_0 dl_dfe_car_ps_1 (
//        .clk(clk), // input wire clk
//        .probe0(resetn), // input wire [0:0]  probe0  
//        .probe1(clk_en), // input wire [1:0]  probe1 
//        .probe2(IFP_axis_in.tdata) // input wire [31:0]  probe2
//    );      
//   
//    ila_2 dl_dfe_car_ps_2 (
//        .clk(clk), // input wire clk
//        .probe0(resetn), // input wire [0:0]  probe0  
//        .probe1(clk_en), // input wire [1:0]  probe1 
//        .probe2(IFP_axis_in.tvalid), // input wire [1:0]  probe1 
//        .probe3(IFP_axis_in.tuser), // input wire [1:0]  probe1 
//        .probe4(IFP_axis_in.tdata), // input wire [1:0]  probe1 
//        .probe5(fir_tdata) // input wire [31:0]  probe2
//    ); 
//	
//	
//    ila_0 dl_dfe_car_ps_3 (
//        .clk(clk), // input wire clk
//        .probe0(0), // input wire [0:0]  probe0  
//        .probe1(0), // input wire [1:0]  probe1 
//        .probe2(fir_tdata_i) // input wire [31:0]  probe2
//    );  
//	
//    ila_0 dl_dfe_car_ps_4 (
//        .clk(clk), // input wire clk
//        .probe0(0), // input wire [0:0]  probe0  
//        .probe1(0), // input wire [1:0]  probe1 
//        .probe2(fir_tdata_q) // input wire [31:0]  probe2
//    );  	
   
endmodule
