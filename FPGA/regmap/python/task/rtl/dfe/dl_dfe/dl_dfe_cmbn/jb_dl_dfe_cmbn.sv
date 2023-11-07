////////////////////////////////////////////////////////////////////
////  File Name : jb_dl_dfe_cmbn.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2018
///// Description  : DL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dl_dfe_cmbn  #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16
   ) (


      input 		       clk,
      input 		       resetn,
			       jb_dl_dfe_ctrl_devided_if.dl_dfe IFP_dl_dfe_ctrl,

      input [N_CARRIERS-1:0]     tvalid_in,
      input [2*PRECISION-1:0]  tdata_in[N_CARRIERS-1:0],
			      
			      //DPD outputs 2 arrays of axi stream
      output 		       tvalid_out,
      output [2*PRECISION-1:0] tdata_out
      
      
      );
 

   localparam N_SUM_EXTRA_BITS= $clog2(N_CARRIERS);
 
   

   logic signed [N_CARRIERS-1:0] [PRECISION-1:0] real_value;
   logic signed [N_CARRIERS-1:0] [PRECISION-1:0] imag_value;
   logic [N_CARRIERS-1:0] 			 car_en;
   logic 					 any_car_en;
   
   
   logic signed [N_SUM_EXTRA_BITS+PRECISION-1:0] sum_i;
   logic signed [N_SUM_EXTRA_BITS+PRECISION-1:0] sum_q;
   
   logic signed [PRECISION-1:0] 		 sum_i_d;
   logic signed [PRECISION-1:0] 		 sum_q_d;
   logic signed 				 tvalid_d;
   logic signed [N_ANTENNAS-1:0] [PRECISION-1:0] ant_tdata_i;
   logic signed [N_ANTENNAS-1:0] [PRECISION-1:0] ant_tdata_q;
   logic signed  		                 ant_tvalid;
   logic signed  		                 ant_tvalid_d;
   



   
   localparam N_BYTES_AXI = $ceil((PRECISION*2)/8);
   
   
/*
   genvar i;
   generate
      for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_cmbn_assign
	 assign car_en[i] = |IFP_cmn_ctrl.dl_stream_en[i];
         assign real_value[i] = car_en[i] ? $signed(tdata_in[i][PRECISION-1:0]) : $signed(0); //if unsigned saw a problem in the past
         assign imag_value[i] = car_en[i] ? $signed(tdata_in[i][2*PRECISION-1:PRECISION]) : $signed(0);	
      end : dl_dfe_cmbn_assign

      if (N_CARRIERS==2) begin : two_car
         assign any_car_en = |(car_en & tvalid_in);
	 assign sum_i = real_value[0] + real_value[1];	 
	 assign sum_q = imag_value[0] + imag_value[1];
      end : two_car	 
      else begin: bypass_cmn //fix this for different no of carriers, temp assignment
         assign any_car_en = car_en[0] & tvalid_in[0];
	 assign sum_i = real_value[0] ;	 
	 assign sum_q = imag_value[0] ;
      end : bypass_cmn
   endgenerate
*/
genvar i;
   generate
      for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_cmbn_assign
        assign real_value[i] = $signed(tdata_in[i][PRECISION-1:0]); //if unsigned saw a problem in the past
        assign imag_value[i] =  $signed(tdata_in[i][2*PRECISION-1:PRECISION]);	 
    end : dl_dfe_cmbn_assign    
    
 if (N_CARRIERS==2) begin : two_car  
	 assign sum_i = real_value[0] + real_value[1];	 
	 assign sum_q = imag_value[0] + imag_value[1];
      end : two_car	 
      else begin: bypass_cmn //fix this for different no of carriers, temp assignment
         assign any_car_en = car_en[0] & tvalid_in[0];
	 assign sum_i = real_value[0] ;	 
	 assign sum_q = imag_value[0] ;
  end : bypass_cmn
  endgenerate    
      
   /*
    following code does not work in vivado
    always @(*) begin
      sum_i=0;
      sum_q=0;
      for (int j=0; j<N_CARRIERS; j=j+1) begin
	 if (car_en[j]==1'b1) begin
	    sum_i = sum_i + real_value[j];
	    sum_q = sum_q + imag_value[j];
	 end
      end
   end
    */
   
   //Take the usr id from the carrier which is enabled, but Vivado is giving trouble with for loop
   //for now this statement whousl be replace by whichever carrier is enabled use that usr id
  

   always @(posedge clk) begin
      if (!resetn) begin
	    sum_i_d <= 0;
	    sum_q_d <= 0;
	    tvalid_d <= 0;	 
      end
      else  begin
	    sum_i_d <= sum_i[PRECISION-1:0];
	    sum_q_d <= sum_q[PRECISION-1:0];
        tvalid_d <= |tvalid_in;
      end
   end //always
   assign tvalid_out = tvalid_d;
   assign tdata_out = {sum_q_d,sum_i_d};
   
	       
endmodule // jb_dl_cmbn


