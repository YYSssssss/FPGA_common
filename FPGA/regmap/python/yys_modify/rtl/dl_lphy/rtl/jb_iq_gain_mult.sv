
module jb_iq_gain_mult #(
      parameter  PRECISION=16, //max precision supported is 16
      parameter  SCALER_BW=4, //max precision supported is 16
      parameter  USR_ID_BW=2
) (
    input           clk_en,
    input 		    clk,
    input 		    resetn,
 
    input 		    scaler_gain_sign,
    input [SCALER_BW-1:0] scaler_gain,
    input [PRECISION-1:0] fraction_gain,
			    
   jb_axi4_stream_if.slave IFP_dfe_in, 
   jb_axi4_stream_if.master IFP_dfe_out
);

   localparam MULT_LATENCY=3+3; //configured it in the ip block design, data is available after 3 cycles, but in 4th cycle
   
   logic signed [PRECISION-1:0] in_i;
   logic signed [PRECISION-1:0] in_q;

   
   logic [PRECISION-1:0] in_i_mag;
   logic [PRECISION-1:0] in_q_mag;
   
   logic [PRECISION+SCALER_BW-1:0] in_i_mag_scaler_updated; //19
   logic [PRECISION+SCALER_BW-1:0] in_q_mag_scaler_updated;

   logic [PRECISION+SCALER_BW-1:0] in_i_mag_scaler_updated_sat;
   logic [PRECISION+SCALER_BW-1:0] in_q_mag_scaler_updated_sat;
   
   logic [PRECISION+SCALER_BW-1:0] in_i_mag_scaler_left;
   logic [PRECISION+SCALER_BW-1:0] in_i_mag_scaler_right;
   logic [PRECISION+SCALER_BW-1:0] in_q_mag_scaler_left;
   logic [PRECISION+SCALER_BW-1:0] in_q_mag_scaler_right;

   
   logic signed [PRECISION+SCALER_BW-1:0] in_i_pre_mult;
   logic signed [PRECISION+SCALER_BW-1:0] in_q_pre_mult;
   
   
   logic signed [PRECISION+SCALER_BW-1:0] in_i_scaler_updated;
   logic signed [PRECISION+SCALER_BW-1:0] in_q_scaler_updated;
   
   
   logic [PRECISION+SCALER_BW-1:0] 	prod_i;
   logic [PRECISION+SCALER_BW-1:0] 	prod_q;

   logic [MULT_LATENCY-1:0]     tvalid_dly ;
   logic [MULT_LATENCY-1:0]     tlast_dly ;
   logic [USR_ID_BW-1:0]	tusr_id_dly[MULT_LATENCY-1:0];

   logic 			in_i_sign;
   logic 			in_q_sign;
   logic 			in_i_sign_d;
   logic 			in_q_sign_d;
   logic [PRECISION-1:0] 	fraction_gain_d;   
   logic [PRECISION-1:0] 	fraction_gain_dd;

   logic  gain_sat_err;
   
   logic  gain_sat_err_i;
   logic  gain_sat_err_q;
   
   
   logic			scaler_gain_sign_reg;
   logic 			scaler_gain_sign_d;
   
   logic [SCALER_BW-1:0] scaler_gain_reg;
   logic [PRECISION-1:0] fraction_gain_reg;
   
   //localparam N_BYTES_AXI = $ceil((PRECISION*2)/8);
   localparam N_BYTES_AXI = 4;


   //assign in_i = $signed(IFP_dfe_in.tdata[PRECISION-1:0]);
   //assign in_q = $signed(IFP_dfe_in.tdata[2*PRECISION-1:PRECISION]);

    always @(posedge clk)
    if (!resetn) begin
       in_i <= '0;
       in_q <= '0;
       scaler_gain_sign_reg <= '0;
       scaler_gain_reg <= '0;
       fraction_gain_reg <= '0;
    end

    else if (clk_en) begin
       in_i <= $signed(IFP_dfe_in.tdata[PRECISION-1:0]);
       in_q <= $signed(IFP_dfe_in.tdata[2*PRECISION-1:PRECISION]);
       scaler_gain_sign_reg <= scaler_gain_sign; // need to latch it to clign with data
       scaler_gain_reg <= scaler_gain;
       fraction_gain_reg <= fraction_gain;
       
    end
    
   assign in_i_sign = in_i[PRECISION-1];
   assign in_q_sign = in_q[PRECISION-1];

   
 
   always @(*) begin
      if (in_i_sign) begin
	 in_i_mag = -in_i;
      end
      else begin
	 in_i_mag = in_i;
      end
      
      if (in_q_sign) begin
	 in_q_mag = -in_q;
      end
      else begin
	 in_q_mag = in_q;
      end
   end
    
   always @(posedge clk) begin
      if (!resetn) begin
	 in_i_mag_scaler_left <= 0;
	 in_i_mag_scaler_right<=0;
	 in_q_mag_scaler_left <=0;
	 in_q_mag_scaler_right <=0;	 
	 scaler_gain_sign_d <= 1'b0; // need to latch it to clign with data
	 fraction_gain_d <=0;
	 fraction_gain_dd <=0;
	 in_i_sign_d <= 1'b0;
	 in_q_sign_d <= 1'b0;
      end
   else if (clk_en) begin
	 in_i_mag_scaler_right <=  (in_i_mag>>scaler_gain_reg);
	 in_i_mag_scaler_left<= (in_i_mag<<scaler_gain_reg);
	 in_q_mag_scaler_right <=  (in_q_mag>>scaler_gain_reg);
	 in_q_mag_scaler_left<= (in_q_mag<<scaler_gain_reg);
	 fraction_gain_d <=fraction_gain_reg;	
	 fraction_gain_dd <= fraction_gain_d; 
	 scaler_gain_sign_d <= scaler_gain_sign_reg; // need to latch it to clign with data
	 in_i_sign_d <= in_i_sign;
	 in_q_sign_d <= in_q_sign;
      end // else: !if(!resetn)
   end // always @ (posedge clk)
										       
   assign in_i_mag_scaler_updated =  scaler_gain_sign_d ? in_i_mag_scaler_right: in_i_mag_scaler_left;   
   assign in_q_mag_scaler_updated =  scaler_gain_sign_d ? in_q_mag_scaler_right:in_q_mag_scaler_left;
   
   
   //assign gain_sat_err_i = |(in_i_mag_scaler_updated[PRECISION-1+SCALER_BW-1:PRECISION-1]);
   //assign gain_sat_err_q = |(in_q_mag_scaler_updated[PRECISION-1+SCALER_BW-1:PRECISION-1]);
   
   //assign gain_sat_err = gain_sat_err_i | gain_sat_err_q;
   //assign in_i_mag_scaler_updated_sat =  gain_sat_err_i ?  {(PRECISION-1){1'b1}} : in_i_mag_scaler_updated;   
   //assign in_q_mag_scaler_updated_sat =  gain_sat_err_q ?  {(PRECISION-1){1'b1}} : in_q_mag_scaler_updated;   

   
   //assign in_i_scaler_updated = in_i_sign_d ? -$signed(in_i_mag_scaler_updated_sat) : $signed(in_i_mag_scaler_updated_sat);
   //assign in_q_scaler_updated = in_q_sign_d ? -$signed(in_q_mag_scaler_updated_sat) : $signed(in_q_mag_scaler_updated_sat);
   
   assign in_i_scaler_updated = in_i_sign_d ? -$signed(in_i_mag_scaler_updated) : $signed(in_i_mag_scaler_updated);
   assign in_q_scaler_updated = in_q_sign_d ? -$signed(in_q_mag_scaler_updated) : $signed(in_q_mag_scaler_updated);


   //if you add a pipeline here, don't foget to add latch on fraction gain
   //assign in_i_pre_mult =  in_i_scaler_updated;
   //assign in_q_pre_mult = in_q_scaler_updated;
   
  always @(posedge clk) begin
      if (!resetn) begin
        in_i_pre_mult <=  0;
        in_q_pre_mult <= 0;
      end
      else if (clk_en) begin
        in_i_pre_mult <=  in_i_scaler_updated;
        in_q_pre_mult <= in_q_scaler_updated;
      end
  end
	 
  
   //assign IFP_dfe_out.tdata = (PRECISION<16) ? {prod_q,{16-PRECISION{1'b0},prod_i} : {prod_q,prod_i}; //if precision is less than 16, make sure to shift left prod_q
   assign IFP_dfe_out.tdata = {prod_q[PRECISION-1:0],prod_i[PRECISION-1:0]}; //if precision is less than 16, make sure to shift left prod_q
   assign IFP_dfe_out.tvalid = tvalid_dly[MULT_LATENCY-1];
   assign IFP_dfe_out.tuser = tusr_id_dly[MULT_LATENCY-1];
   assign IFP_dfe_in.tready = 1'b1;
   assign IFP_dfe_out.tkeep = {N_BYTES_AXI{1'b1}};
   //assign IFP_dfe_out.tlast = 1'b0;
   assign IFP_dfe_out.tlast = tlast_dly[MULT_LATENCY-1];
  
   always @(posedge clk) begin
      if (!resetn) begin
	 tvalid_dly <= 0;
	 tlast_dly <= 0;
	 tusr_id_dly<='{default:0};
      end
   else if (clk_en) begin
     tlast_dly[0] <= IFP_dfe_in.tlast;
	 tvalid_dly[0] <= IFP_dfe_in.tvalid;
	 tusr_id_dly[0] <= IFP_dfe_in.tuser;  
	 for(int i=1;i<MULT_LATENCY;i=i+1) begin //+1 is for the pipeline stage I added before MULT
	    tvalid_dly[i] <= tvalid_dly[i-1];
	    tlast_dly[i] <= tlast_dly[i-1];
	    tusr_id_dly[i] <= tusr_id_dly[i-1];	 
	 end 	 
      end // else: !if(!resetn)
   end // always @ (posedge clk)
   
 

gain_block_1 u_gain_block_i
       (.A(in_i_pre_mult),
        .B(fraction_gain_dd),
        .CE(clk_en),
        .CLK(clk), 
        .P(prod_i)
);

   
gain_block_1 u_gain_block_q
       (.A(in_q_pre_mult),
        .B(fraction_gain_dd),
        .CE(clk_en),
        .CLK(clk), 
        .P(prod_q)
);

   
endmodule



   
