///////////////////////////////////////////////////////////////////////////////////
////  File Name : jb_nco.sv
///// Author    : Shehanaj Begum
///// Date      : 1/04/2019
///// Description  : This module does the nco    
////////////////////////////////////////////////////////////////////////////////////
   
module jb_nco #(
  parameter NCO_COEF_WIDTH =40, //
  parameter NCO_COUNT_WIDTH =39, //
  parameter NCO_QUAD_LKUP_TBL_ENTRIES = 1024,
  parameter NCO_COEF_2S_COMPLEMENT=0,
  parameter PRECISION=16,
  parameter MODE=0
                                 
)  (   
  input clk,
  input resetn,
            
  input logic [NCO_COUNT_WIDTH-1:0] nco_cntr,
  input logic  [NCO_COEF_WIDTH-1:0] nco_coef,
  output logic signed [2*PRECISION-1:0] nco_sincos //{Q,I}

  
);

   //localparam QUAD_LKUP_TBL_ENTRIES_BW = $clog2(NCO_QUAD_LKUP_TBL_ENTRIES); //synth may have issue with this
   localparam QUAD_LKUP_TBL_ENTRIES_BW = 10;
   localparam INTERP_FRAC_BW=NCO_COUNT_WIDTH-2-QUAD_LKUP_TBL_ENTRIES_BW;//10 bits for table , 2 bits for QUAD
   
   
   
   logic 				nco_coef_sign;
   logic [NCO_COEF_WIDTH-1:0] 		abs_nco_coef;
   logic [NCO_COUNT_WIDTH+NCO_COEF_WIDTH-2:0] nco_prod;
   logic [NCO_COUNT_WIDTH-1:0]   	    nco_prod_d;
   logic [NCO_COUNT_WIDTH-1:0] nco_prod_lsbs;
   logic [QUAD_LKUP_TBL_ENTRIES_BW-1:0]       rd_ptr;//[9:0]
   logic [1:0] 				      quad_sel;
   logic [1:0] 				      quad_sel_d;
   logic [INTERP_FRAC_BW-1:0] 		      inerp_frac;//[26:0]
   logic [INTERP_FRAC_BW-1:0] 		      inerp_frac_d;//[26:0]
   logic signed [PRECISION-1:0] 	      cos_delta;//slope
   logic signed [PRECISION+INTERP_FRAC_BW-1:0] cos_prod;//[16+26-1:0]
   logic signed [PRECISION-1:0] cos_prod_d;//[16+26-1:0]
   logic signed [PRECISION+1-1:0] 			    cos_sum; //y1+y1delta, +1 for carry over, overflow indication?
   logic signed [PRECISION-1:0] 			    sin_delta;//slope
   logic signed [PRECISION+INTERP_FRAC_BW-1:0] 		    sin_prod;//[16+26-1:0]
   logic signed [PRECISION-1:0]                             sin_prod_d;//[16+26-1:0]
   logic signed [PRECISION+1-1:0] 			    sin_sum; //y1+y1delta, +1 for carry over, overflow never happen since it is multiplied by fraction
   logic signed [PRECISION-1:0] 			    nco_sin;
   logic signed [PRECISION-1:0] 			    nco_cos;
   logic signed [NCO_COEF_WIDTH-1:0] nco_coef_updated;
   
  
   
  // typedef struct  packed {
  //    logic signed [PRECISION-1:0] 			    sin_value;
  //    logic signed [PRECISION-1:0] 			    cos_value;
 //  } sincos_t;
   
   //sincos_t quad0_curr_sincos;
   //sincos_t quad0_next_sincos;
   
   //sincos_t curr_sincos;
   //sincos_t next_sincos;
   
   
   logic signed [PRECISION-1:0] 			    curr_sin_value; 
   logic signed [PRECISION-1:0] 			    curr_sin_value_d;   
   logic signed [PRECISION-1:0] 			    next_sin_value;
   logic signed [PRECISION-1:0] 			    curr_cos_value;  
   logic signed [PRECISION-1:0] 			    curr_cos_value_d;   
   logic signed [PRECISION-1:0] 			    next_cos_value;

   
   logic signed [PRECISION-1:0] 			    quad0_curr_sin_value;
   logic signed [PRECISION-1:0] 			    quad0_curr_cos_value;
   logic signed [PRECISION-1:0] 			    quad0_next_sin_value;
   logic signed [PRECISION-1:0] 			    quad0_next_cos_value;
   
   //if DL don't change the sign, need to upconvert
   //if UL change the sign, for down mixing
   assign nco_coef_sign = (MODE==0) ? nco_coef[NCO_COEF_WIDTH-1] : ~nco_coef[NCO_COEF_WIDTH-1];
   
   generate 
      if (NCO_COEF_2S_COMPLEMENT==1) begin : abs_value
	 always @(*) begin
	    if (nco_coef_sign) begin
	       abs_nco_coef = -$signed(nco_coef);
	    end
	    else begin
	       abs_nco_coef = nco_coef;
      end
	 end
      end : abs_value
      else begin : no_abs_value
	 assign  abs_nco_coef = {1'b0,nco_coef[NCO_COEF_WIDTH-2:0]};//NCO_COEF_WIDTH-1 is a sign bit
      end : no_abs_value
   endgenerate 

   //39x39, latenct=4
   multiplier_1 u_nco_product (
    .CLK(clk),  // input wire CLK
    .A(abs_nco_coef[NCO_COEF_WIDTH-2:0]),      // input wire [38 : 0] A
    .B(nco_cntr[NCO_COUNT_WIDTH-1:0]),      // input wire [38 : 0] B
    .P(nco_prod)      // output wire [77 : 0] P
  );

   //assign nco_prod = abs_nco_coef[NCO_COEF_WIDTH-2:0] * nco_cntr[NCO_COUNT_WIDTH-1:0]; //

  
   
   /*
   always @(posedge clk) begin
      if (!resetn) begin
	 nco_prod_d <= 0;
      end
      else begin
	 nco_prod_d <= nco_prod[NCO_COUNT_WIDTH-1:0];
      end     
   end // always @ (posedge clk)
   */
   
   assign nco_prod_lsbs = nco_prod[NCO_COUNT_WIDTH-1:0]; //[38:0] select the fractional part, picked the counter width not sure which one to pick, can ask Walid
   //1024 values, need to linearly interpolate using the following equation
   
   
   assign rd_ptr = nco_prod_lsbs[NCO_COUNT_WIDTH-2-1:NCO_COUNT_WIDTH-2-QUAD_LKUP_TBL_ENTRIES_BW]; // [36:27],1024 look up table
   assign quad_sel=nco_prod_lsbs[NCO_COUNT_WIDTH-1:NCO_COUNT_WIDTH-2];//[38:37]
   assign inerp_frac = nco_prod_lsbs[INTERP_FRAC_BW-1:0];//27 bits,[26:0]

   //latch the following since the rd data comes in next cycle
    always @(posedge clk) begin
      if (!resetn) begin
	 quad_sel_d <=0;
	 inerp_frac_d<=0;
      end
      else begin
	 quad_sel_d <= quad_sel;
	 inerp_frac_d <= inerp_frac;
      end     
   end // always @ (posedge clk)
   //Map the quad0 values to correct quadrant based on upper MSB 2 bits
   //assign curr_sincos = mapped_sincos(quad_sel_d, quad0_curr_sincos);
   //assign next_sincos = mapped_sincos(quad_sel_d, quad0_next_sincos);

  always @(*) begin
     case(quad_sel_d) 
       2'b00 : begin
	      curr_sin_value=quad0_curr_sin_value;
	      curr_cos_value=quad0_curr_cos_value;
	      next_sin_value=quad0_next_sin_value;
	      next_cos_value=quad0_next_cos_value;
       end
       2'b01 :begin
	      curr_sin_value=quad0_curr_cos_value;
	      curr_cos_value=-quad0_curr_sin_value;
	      next_sin_value=quad0_next_cos_value;
	      next_cos_value=-quad0_next_sin_value;
       end
       2'b10 : begin
	      curr_sin_value=-quad0_curr_sin_value;
	      curr_cos_value=-quad0_curr_cos_value;
	      next_sin_value=-quad0_next_sin_value;
	      next_cos_value=-quad0_next_cos_value;
       end
       2'b11 : begin
	      curr_sin_value=-quad0_curr_cos_value;
	      curr_cos_value=quad0_curr_sin_value;
	      next_sin_value=-quad0_next_cos_value;
	      next_cos_value=quad0_next_sin_value;
       end
     endcase // case (quad)
  end
   
   //Choose 4 Kvalue for look up table, but need to linearly interpolate to avoid huge lookup tables
   //cosSigOut = cosVals0 + (cosVals1-cosVals0) * Frac;
   //sinSigOut = sinVals0 + (sinVals1-sinVals0) * Frac;
   //y=mx+c=> (x1,y1) (x2,y2), y2 is the next value, y1 is the current value, x2-x1=1
   //find yt where, xt=x1+fraction
   //Cos calculation
   //in other words take y2-y1 and scale it with fraction and add y1
   assign cos_delta= next_cos_value-curr_cos_value; //precision bits
   //assign cos_prod = cos_delta * $signed(inerp_frac_d);
   
    nco_frac_interp_mult nco_cos_frac_prod (
     .CLK(clk),  // input wire CLK
     .A(cos_delta),      // input wire [15 : 0] A
     .B(inerp_frac_d),      // input wire [26 : 0] B
     .P(cos_prod)      // output wire [42 : 0] P
    );

   assign sin_delta= next_sin_value-curr_sin_value; //precision bits
   //assign sin_prod = sin_delta * $signed(inerp_frac_d);
   
    nco_frac_interp_mult nco_sin_frac_prod (
     .CLK(clk),  // input wire CLK
     .A(sin_delta),      // input wire [15 : 0] A
     .B(inerp_frac_d),      // input wire [26 : 0] B
     .P(sin_prod)      // output wire [42 : 0] P
    );

   
   assign cos_prod_d = cos_prod[PRECISION+INTERP_FRAC_BW-1:INTERP_FRAC_BW];
   assign sin_prod_d = sin_prod[PRECISION+INTERP_FRAC_BW-1:INTERP_FRAC_BW];
   
   always @(posedge clk) begin
      if (!resetn) begin
	 curr_cos_value_d <= 0;
	 curr_sin_value_d  <= 0;
	 
      end
      else begin
	 curr_cos_value_d <= curr_cos_value;
	 curr_sin_value_d  <= curr_sin_value;
      end     
   end // always @ (posedge clk)
   assign cos_sum = cos_prod_d[PRECISION-1:0]+curr_cos_value_d; //add overflow error
   assign nco_cos = cos_sum[PRECISION-1:0];
  
   //sin calculation
   
   assign sin_sum = sin_prod_d[PRECISION-1:0]+curr_sin_value_d;//add ovfl error
   assign nco_sin = nco_coef_sign ? -sin_sum[PRECISION-1:0] : sin_sum[PRECISION-1:0];

   //Set the output
     always @(posedge clk) begin
      if (!resetn) begin
	 nco_sincos <= 0;
      end
      else begin
	 nco_sincos <=  {nco_sin,nco_cos};
      end     
   end // always @ (posedge clk)
   
   
   
   jb_sincos_lkup #(
      .NCO_QUAD_LKUP_TBL_ENTRIES_BW(QUAD_LKUP_TBL_ENTRIES_BW),
      .PRECISION (PRECISION)
    ) u_jb_sincos_lkup (
      .clk(clk),
      .resetn(resetn),
      .ptr(rd_ptr),
      .curr_sin(quad0_curr_sin_value),
      .curr_cos(quad0_curr_cos_value),
      .next_sin(quad0_next_sin_value),
      .next_cos(quad0_next_cos_value)
   );
   
   
   /*
    //quarter waveform
    case(quarter) 
    2'b00 : sin = first_upper_val;cos=second_lower_val;
    2'b01 : sin = second_lower_val, cos=-first_upper_val;
    2'b10 : sin = -first_upper_val;cos=-second_lower_val;
    2'b11 : sin = -second_lower_val, cos=first_upper_val;
    */
   /*
   function sincos_t mapped_sincos;
      input [1:0] quad;
      input 	  sincos_t quad0_sincos;
      begin
	 case(quad) 
	   2'b00 : begin
	      mapped_sincos.sin_value=quad0_sincos.sin_value;
	      mapped_sincos.cos_value=quad0_sincos.cos_value;
	   end
	   2'b01 :begin
	      mapped_sincos.sin_value=quad0_sincos.cos_value;
	      mapped_sincos.cos_value=-quad0_sincos.sin_value;
	   end
	   2'b10 : begin
	      mapped_sincos.sin_value=-quad0_sincos.sin_value;
	      mapped_sincos.cos_value=-quad0_sincos.cos_value;
	   end
	   2'b11 : begin
	      mapped_sincos.sin_value=-quad0_sincos.cos_value;
	      mapped_sincos.cos_value=quad0_sincos.sin_value;
	   end
	 endcase // case (quad)
      end
   endfunction // mapped_sincos
*/   
   
   
endmodule 
