
 module jb_ul_dfe_ant2car  #(
      parameter  UL_TIME_DELAY_BYPASS = 1,
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter  NCO_COEF_WIDTH =40, //
      parameter  NCO_COUNT_WIDTH =39, //
      parameter  NCO_QUAD_LKUP_TBL_ENTRIES = 1024,
      parameter  NCO_COEF_2S_COMPLEMENT=0
   ) (


        input                    clk_4x,
        input                    clk_1x,            
	    input                    resetn_1x,
        input                    resetn_4x,
        input                    ul_dfe_time_delay_resetn,
            
        input                    any_stream_enable,
	    jb_ul_dfe_ctrl_devided_if.ul_dfe IFP_ul_dfe_ctrl,
        jb_cmn_ctrl_devided_if.cmd_dfe   IFP_cmn_ctrl,
	    
	    // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
	    // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
	    jb_axi4_stream_if.slave  IFP_ul_dfe_in[N_ANTENNAS-1:0],
	    jb_axi4_stream_if.slave  IFP_p2s_in   [N_CARRIERS-1:0][N_ANTENNAS-1:0],
	    
	    //DPD outputs 2 arrays of axi stream
	    jb_axi4_stream_if.master IFP_ul_dfe_out[N_CARRIERS-1:0]
      
      
      );

   localparam USR_ID_BW = $clog2(N_ANTENNAS);
   localparam OVER_SAMPLE_RATIO =4;

   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]                 tvalid_in ;
   logic [2*PRECISION-1:0]	  tdata_in [N_CARRIERS-1:0] [N_ANTENNAS-1:0];


   
   logic [N_CARRIERS-1:0]  [N_ANTENNAS-1:0]	         tvalid_mixer2p2s  ;
   logic [N_CARRIERS-1:0]               	         tvalid_mixer2p2s_ant1_d1  ;
   logic [N_CARRIERS-1:0]               	         tvalid_mixer2p2s_ant2_d1  ;
   logic [N_CARRIERS-1:0]               	         tvalid_mixer2p2s_ant2_d2  ;
   logic [N_CARRIERS-1:0]               	         tvalid_mixer2p2s_ant3_d1  ;
   logic [N_CARRIERS-1:0]               	         tvalid_mixer2p2s_ant3_d2  ;
   logic [N_CARRIERS-1:0]               	         tvalid_mixer2p2s_ant3_d3  ;
   logic [N_CARRIERS-1:0]  [N_ANTENNAS-1:0]	         tvalid_mixer2p2s_reshape  ;
   logic [2*PRECISION-1:0]	  tdata_mixer2p2s [N_CARRIERS-1:0] [N_ANTENNAS-1:0];

   
   logic [N_CARRIERS-1:0]     tvalid_p2s_out   ;//chnaged this for oring
   logic [2*PRECISION-1:0]	  tdata_p2s_out [N_CARRIERS-1:0] ;
   logic [USR_ID_BW-1:0]	  tuser_p2s_out [N_CARRIERS-1:0];
   logic [N_CARRIERS-1:0] ul_car_en;
   logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]	 nco_coef;
   
   genvar   i,j;
   
   generate
     for (i = 0; i <  N_CARRIERS; i = i + 1) begin: gen_car_en      
        assign ul_car_en[i] = |IFP_cmn_ctrl.ul_stream_en[i];
        assign nco_coef[i]={IFP_ul_dfe_ctrl.ul_car_nco_msb[i],IFP_ul_dfe_ctrl.ul_car_nco_lsb[i]};
     end :  gen_car_en
	 for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: ul_dfe_ant_assign
	 
       for (i = 0; i <  N_CARRIERS; i = i + 1) begin: ul_dfe_ant_car_split
//	    assign  tvalid_in[i][j] = IFP_ul_dfe_in[j].tvalid;
//	    assign  tdata_in[i][j]  = ul_car_en[i] ? IFP_ul_dfe_in[j].tdata : 0;

	    assign  tvalid_in[i][j] = IFP_p2s_in[i][j].tvalid;
	    assign  tdata_in[i][j]  = IFP_p2s_in[i][j].tdata ;

	   end : ul_dfe_ant_car_split
	 
	 assign IFP_ul_dfe_in[j].tready = 1'b1;
	 
	 end :  ul_dfe_ant_assign
   endgenerate
   
   //counter is shared among all carriers, so have one instance
//   jb_dfe_mixer #(
//       .N_CARRIERS (N_CARRIERS),
//       .N_ANTENNAS (N_ANTENNAS),
//       .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
//       .NCO_COEF_2S_COMPLEMENT(NCO_COEF_2S_COMPLEMENT),
//       .NCO_COUNT_WIDTH(NCO_COUNT_WIDTH),
//       .NCO_COEF_WIDTH(NCO_COEF_WIDTH),
//       .PRECISION (PRECISION),
//       .MODE(1) //DL=0, UL=1
//   ) u_ul_dfe_mixer  (
//       .clk(clk_1x),
//       .resetn(resetn_1x),
//       .any_stream_enable(any_stream_enable),
//       .nco_coef(nco_coef),
//       .tvalid_in(tvalid_in),
//       .tdata_in(tdata_in),
//       .tvalid_out(tvalid_mixer2p2s),
//       .tdata_out(tdata_mixer2p2s)
//   );

   /*
	 ila_0 u_ila_ul_mixer_out (
	   .clk(clk_1x), // input wire clk
	   .probe0(tvalid_mixer2p2s[0][0]), // input wire [0:0]  probe0  
	   .probe1(2'd0), // input wire [1:0]  probe1 
	   .probe2(tdata_mixer2p2s[0][0]) // input wire [31:0]  probe2
        );
    */
   
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out[1:0] ();

// Assign Packed to unpacked.
  logic signed [6:0] reg_temp [1:0] [3:0]; 
  assign reg_temp[0][0] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[0][0]);
  assign reg_temp[0][1] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[0][1]);
  assign reg_temp[0][2] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[0][2]);
  assign reg_temp[0][3] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[0][3]);
  assign reg_temp[1][0] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[1][0]);
  assign reg_temp[1][1] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[1][1]);
  assign reg_temp[1][2] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[1][2]);
  assign reg_temp[1][3] = $signed(IFP_ul_dfe_ctrl.ul_int_delay[1][3]);
  
  logic signed [15:0] reg_temp2 [1:0] [3:0]; 
  assign reg_temp2[0][0] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[0][0]);
  assign reg_temp2[0][1] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[0][1]);
  assign reg_temp2[0][2] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[0][2]);
  assign reg_temp2[0][3] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[0][3]);
  assign reg_temp2[1][0] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[1][0]);
  assign reg_temp2[1][1] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[1][1]);
  assign reg_temp2[1][2] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[1][2]);
  assign reg_temp2[1][3] = $signed(IFP_ul_dfe_ctrl.ul_frac_delay[1][3]);
/*  
   ila_0 u_ila_ctrl1_INT_Delay_in (
	   .clk(clk_4x), // input wire clk
	   .probe0(IFP_ul_dfe_ctrl.ul_ant_int_frac_delay_trig), // input wire [0:0]  probe0  
	   .probe1(2'b00), // input wire [1:0]  probe1 
	   .probe2({reg_temp2[0][3][15:0], reg_temp[0][3][6:0], 9'b00}) // input wire [31:0]  probe2
        ); 
        
   ila_0 u_ila_ctrl2_INT_Delay_in (
	   .clk(clk_4x), // input wire clk
	   .probe0(IFP_ul_dfe_ctrl.ul_ant_int_frac_delay_trig), // input wire [0:0]  probe0  
	   .probe1(2'b00), // input wire [1:0]  probe1 
	   .probe2({IFP_ul_dfe_ctrl.ul_frac_delay[0][3][15:0], IFP_ul_dfe_ctrl.ul_int_delay[0][3][6:0], 9'b00}) // input wire [31:0]  probe2
        ); 
*/ 

  // VIO test
  
 /* logic resetn_test;
   vio_ul_dfe_resetn u_vio_ul_dfe_resetn (
	   .clk(clk_1x), // input wire clk
	   .probe_out0(resetn_test) // startup is 0... will need to change
        ); 
  */
  // Sense no reset.  Create my own SM 12/24/2019  
  // 12/26/2019  Didn't work because now the FIR filters after are no longer aligned and 
  // data comes out the wrong place.  May need to be longer...
  
  logic resetn_created = 'b1;
  logic reset_done = 'b0;
  logic [3:0] count = 'd0;
  
  always_ff @(posedge clk_1x) begin
    if ((reset_done == 'b0) && (count == 'd15)) begin // if reset not done
            reset_done <= 'b1; // set done to 1
            resetn_created <= 'b1; // create reset
            count <= 'd0;
        end
    else if (reset_done) begin
        reset_done <= 'b1; // set done to 1
        resetn_created <= 'b1; // create reset
        count <= 'd0;
        end
    else begin  // Reset was done
        reset_done <= 'b0; // Keep reset done
        resetn_created <= 'b0; // keep reset at 1
        count <= count + 'd1;
        end
  end
  
generate
 
for (i = 0; i <  N_CARRIERS; i = i + 1) begin  
   always @(posedge clk_4x)begin
   
     tvalid_mixer2p2s_ant1_d1[i] <= tvalid_mixer2p2s[i][1]     ;
     tvalid_mixer2p2s_ant2_d1[i] <= tvalid_mixer2p2s[i][2]     ;
     tvalid_mixer2p2s_ant2_d2[i] <= tvalid_mixer2p2s_ant2_d1[i];
     tvalid_mixer2p2s_ant3_d1[i] <= tvalid_mixer2p2s[i][3]     ; 
     tvalid_mixer2p2s_ant3_d2[i] <= tvalid_mixer2p2s_ant3_d1[i]; 
     tvalid_mixer2p2s_ant3_d3[i] <= tvalid_mixer2p2s_ant3_d2[i]; 
      
   end  
     
   assign tvalid_mixer2p2s_reshape[i][0] = tvalid_mixer2p2s[i][0]     ;
   assign tvalid_mixer2p2s_reshape[i][1] = tvalid_mixer2p2s_ant1_d1[i];
   assign tvalid_mixer2p2s_reshape[i][2] = tvalid_mixer2p2s_ant2_d2[i];
   assign tvalid_mixer2p2s_reshape[i][3] = tvalid_mixer2p2s_ant3_d3[i];
   
end   
endgenerate


  
   generate
 
    for (i = 0; i <  N_CARRIERS; i = i + 1) begin: ul_dfe_ant_p2s
     // Time Delay
//     jb_ul_dfe_time_delay #(
//           .N_CARRIERS (N_CARRIERS),
//           .N_ANTENNAS (N_ANTENNAS),
//           .PRECISION  (PRECISION)	  
//         ) u_ul_dfe_time_delay (
//           .clk_1x            (clk_1x),
//           .clk_4x            (clk_4x),
//           //.resetn            (resetn),
//           // .resetn            (resetn_test && resetn && reset_created),
//           //.resetn            (resetn_test && resetn),
//           .resetn_1x            (resetn_1x),          
//           .resetn_4x            (resetn_4x),
//           // .resetn            (resetn_created && resetn),
//           //.frt_delay         (IFP_ul_dfe_ctrl.ul_frt_delay[i]), //[15:0]
//           //.int_delay         (IFP_ul_dfe_ctrl.ul_int_delay[i]), //[6:0]
//           //.time_reg_trigger  (IFP_ul_dfe_ctrl.ul_delay_trigger),
//           .frt_delay         (reg_temp2[i]),  //[15:0]
//           .int_delay         (reg_temp[i]),  //[6:0]
//           .time_reg_trigger  (IFP_ul_dfe_ctrl.ul_ant_int_frac_delay_trig),
//           .tvalid_p2s        (tvalid_mixer2p2s[i]),
//           .tdata_p2s         (tdata_mixer2p2s[i]),
//           .IFP_dfe_delay_out (IFP_dfe_delay_out[i])
//        );
   /* 
    ila_0 u_ila_ul_time_delay_out (
	   .clk(clk_4x), // input wire clk
	   .probe0(IFP_dfe_delay_out[0].tvalid), // input wire [0:0]  probe0  
	   .probe1(IFP_dfe_delay_out[0].tuser), // input wire [1:0]  probe1 
	   .probe2(IFP_dfe_delay_out[0].tdata) // input wire [31:0]  probe2
        );
	*/




        
	 jb_ul_dfe_ant_p2s #(
           .N_CARRIERS (N_CARRIERS),
           .N_ANTENNAS (N_ANTENNAS),
           .PRECISION (PRECISION),
	   .USR_ID_BW(USR_ID_BW)		  
         ) u_ul_dfe_ant_p2s (
           .clk_1x         (clk_1x           ),
           .clk_4x         (clk_4x           ),
           .resetn_1x      (resetn_1x        ),
           .resetn_4x      (resetn_4x        ),
           .IFP_ul_dfe_ctrl(IFP_ul_dfe_ctrl  ),
//           .tvalid_in(tvalid_mixer2p2s[i]),
//           .tdata_in(tdata_mixer2p2s[i]),
           .tvalid_in      (tvalid_in[i]     ),
           .tdata_in       (tdata_in[i]      ),
//           .tvalid_in      (IFP_p2s_in[i].tvalid),
//           .tdata_in       (IFP_p2s_in[i].tdata ),
           .tvalid_out     (tvalid_p2s_out[i]   ),
           .tdata_out      (tdata_p2s_out[i]    ),
           .tuser_out      (tuser_p2s_out[i]    )
	  		  
        );
        

     if (UL_TIME_DELAY_BYPASS == 1) begin
     	assign IFP_ul_dfe_out[i].tvalid = tvalid_p2s_out[i];
        assign IFP_ul_dfe_out[i].tdata = tdata_p2s_out[i];
        assign IFP_ul_dfe_out[i].tuser = tuser_p2s_out[i];
        assign IFP_ul_dfe_out[i].tkeep = 0;
        assign IFP_ul_dfe_out[i].tlast = 1'b0;
     end
     else begin
        assign IFP_ul_dfe_out[i].tvalid = IFP_dfe_delay_out[i].tvalid; 
        assign IFP_ul_dfe_out[i].tdata = IFP_dfe_delay_out[i].tdata; 
        assign IFP_ul_dfe_out[i].tuser = IFP_dfe_delay_out[i].tuser;
        assign IFP_ul_dfe_out[i].tkeep = 0;
        assign IFP_ul_dfe_out[i].tlast = 1'b0;
     end
     
      end : ul_dfe_ant_p2s
   endgenerate
   
  

/*
	  ila_1 u_ila_delay (
	  .clk(clk_4x), // input wire clk	.probe0(probe0), // input wire [0:0]  probe0 
	  .probe0(IFP_dfe_delay_out[0].tvalid), // input wire [0:0]  probe0    
	  .probe1(IFP_dfe_delay_out[0].tdata), // input wire [31:0]  probe1 
	  .probe2(IFP_dfe_delay_out[0].tuser), // input wire [1:0]  probe2 
	  .probe3(tvalid_mixer2p2s[0][0]), // input wire [0:0]  probe3 
	  .probe4(tdata_mixer2p2s[0][0]), // input wire [31:0]  probe4 
	  .probe5(tvalid_mixer2p2s[0][1]), // input wire [0:0]  probe5 
	  .probe6(tdata_mixer2p2s[0][1]), // input wire [31:0]  probe6 
	  .probe7(tvalid_mixer2p2s[0][2]), // input wire [0:0]  probe7 
	  .probe8(tdata_mixer2p2s[0][2]), // input wire [31:0]  probe8 
	  .probe9(tvalid_mixer2p2s[0][3]), // input wire [0:0]  probe9 
	  .probe10(tdata_mixer2p2s[0][3]) // input wire [31:0]  probe10
         );
  */ 
endmodule // jb_ul_dfe_car2ant

