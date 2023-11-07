
module jb_iq_rssi #(
      parameter  SAMPLE_BW=16, //max precision supported is 16
      parameter  USR_ID_BW=1,
      parameter  N_USRS=4,
      parameter  WRSSI=1
) (
    input 		    clk,
    input           clk_en,
    input 		    resetn,

			    
    input                   tvalid,
    input [2*SAMPLE_BW-1:0]       tdata,
    input [USR_ID_BW-1:0]   tusr,

    input                   rssi_load,
    output logic [N_USRS-1:0] [31:0]     rssi_value
   
);

     localparam  ILA_EN = 0;

   localparam ADC_RESOLUTION= 16;//chnaged from 12
   
   localparam RESOLUTION= (WRSSI==1) ?  ADC_RESOLUTION: SAMPLE_BW;
   //wrssi=>26+22=48,  rssi=>22+30=52
   localparam MAX_ACC_BITS= (WRSSI==1) ? 57 : 57; //ADC is giving sign exntension need to confirm

   //log2(100ms@368.64)+22
   //.MAX_ACC_BITS(52), //log2(100ms@30.74)+30
   localparam MULT_LATENCY=3; //configured it in the ip block design
   localparam LATENCY=MULT_LATENCY+2; //configured it in the ip block design
   
   logic signed [SAMPLE_BW-1:0] in_i; 
   logic signed [SAMPLE_BW-1:0] in_q;

   logic [SAMPLE_BW-1:0] in_i_mag; 
   logic [SAMPLE_BW-1:0] in_q_mag;
   
   logic [RESOLUTION-1:0] in_i_mag_adc; 
   logic [RESOLUTION-1:0] in_q_mag_adc;
  
   logic [2*RESOLUTION-1:0] 	i_square; //21:0]
   logic [2*RESOLUTION-1:0] 	q_square;

   logic [2*RESOLUTION-1+1:0] 	iq_sum;

   logic [N_USRS-1:0] [MAX_ACC_BITS-1:0] iq_acc_sum; //for 100ms,

   logic [N_USRS-1:0] [31:0]  iq_acc_sum_trunc; //for 100ms, 
   
   logic [2:0] 				 rssi_load_sync;
   logic    [LATENCY-1:0] [USR_ID_BW-1:0]   tusr_id_dly;

   logic [N_USRS-1:0]		    user_tvalid;
   
   
   
   logic [LATENCY-1:0] 		tvalid_dly;
   
   logic in_i_sign;
   logic in_q_sign;
   
   logic rssi_load_pulse;

   logic rssi_load_pulse_d;


   
   
   
   assign in_i_sign = in_i[SAMPLE_BW-1];
   assign in_q_sign = in_q[SAMPLE_BW-1];


    always @(posedge clk) begin
      if (!resetn) begin
	 in_i <= $signed(0);
	 in_q <= $signed(0);
	 rssi_load_sync <= 0;
	 rssi_load_pulse_d <= 1'b0;
      end
      else if (clk_en) begin
	 in_i <= $signed(tdata[SAMPLE_BW-1:0]);
	 in_q <= $signed(tdata[2*SAMPLE_BW-1:SAMPLE_BW]);
	 rssi_load_sync <= {rssi_load_sync[1:0], rssi_load};
	 rssi_load_pulse_d <= rssi_load_pulse;
      end
    end // always @ (posedge clk)

   assign rssi_load_pulse = ~rssi_load_sync[2] & rssi_load_sync[1];
   
    
    //always @(*) begin
	always @(posedge clk) begin
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

  
   assign in_i_mag_adc = in_i_mag[SAMPLE_BW-1:SAMPLE_BW-RESOLUTION];
   assign in_q_mag_adc = in_q_mag[SAMPLE_BW-1:SAMPLE_BW-RESOLUTION];
   
   always @(posedge clk) begin
      if (!resetn) begin
	 tvalid_dly <= 0;
	 tusr_id_dly<='{default:0};
      end
      else if (clk_en) begin
	 tvalid_dly[0] <= tvalid;
	 tusr_id_dly[0] <= tusr;         
	 for(int i=1;i<LATENCY;i=i+1) begin //+1 is for the pipeline stage I added before MULT
	    tvalid_dly[i] <= tvalid_dly[i-1];
	    tusr_id_dly[i] <= tusr_id_dly[i-1];
	 end 	 
      end // else: !if(!resetn)
   end // always @ (posedge clk)

   genvar   i;
   generate
      for (i = 0; i <  N_USRS; i = i + 1) begin: rssi_load_reg

	 assign iq_acc_sum_trunc[i] = iq_acc_sum[i][MAX_ACC_BITS-1:MAX_ACC_BITS-32];
	 
	 //Load when either with CPRI BFn or a timer (100msec)
	 always @(posedge clk) begin
	    if (!resetn) begin
	       rssi_value[i] <= 0;
	    end
            else if (clk_en & rssi_load_pulse_d) begin
	       rssi_value[i] <= iq_acc_sum_trunc[i];
	    end
        end
	 assign user_tvalid[i] = (tvalid_dly[LATENCY-1]) && (tusr_id_dly[LATENCY-1] == i);
	 
	 //Delay the tvalid to match the latency, mult antenna paths time interleaved
	 always @(posedge clk) begin //1 input latency+ 1 mult latency+ 1 adder latency=3 cycles
	    if (!resetn) begin
	       iq_acc_sum[i] <= 0;
	    end
        else if (clk_en) begin
	    if (rssi_load_pulse_d) begin
	       iq_acc_sum[i] <= 0;	       
	    end
	    else if (user_tvalid[i]) begin
	       iq_acc_sum[i] <= iq_acc_sum[i] + iq_sum;
	    end
        end
	 end
   end : rssi_load_reg
   endgenerate

    always @(posedge clk) begin
     if (clk_en)
       iq_sum <= i_square + q_square;
    end

// using clock en on multipliers may slow them down? Dont need it anyways.
   generate
      if (WRSSI==1) begin : wrssi_mult
	 mult_16x16 u_i_square
	   (.A(in_i_mag_adc),
            .B(in_i_mag_adc),
            .CLK(clk), 
            .P(i_square)
	    ); 
	 mult_16x16 u_q_square
	   (.A(in_q_mag_adc),
            .B(in_q_mag_adc),
            .CLK(clk), 
            .P(q_square)
	    );

      end : wrssi_mult
      else begin : rssi_mult
	 mult_16x16 u_i_square
	   (.A(in_i_mag_adc),
            .B(in_i_mag_adc),
            .CLK(clk), 
            .P(i_square)
	    ); 
	 mult_16x16 u_q_square
	   (.A(in_q_mag_adc),
            .B(in_q_mag_adc),
            .CLK(clk), 
            .P(q_square)
	    );
	 end : rssi_mult
    endgenerate

/*
   generate
      if (ILA_EN==1) begin : ila_dbg_en
   ila_rssi ila_wrssi (
	.clk(clk), // input wire clk
	.probe0(tvalid), // input wire [0:0]  probe0  
	.probe1(in_i_mag), // input wire [15:0]  probe1 
	.probe2(in_q_mag), // input wire [15:0]  probe2 
	.probe3(i_square), // input wire [31:0]  probe3 
	.probe4(q_square), // input wire [31:0]  probe4 
	.probe5(iq_acc_sum[0]), // input wire [56:0]  probe5 
	.probe6(rssi_load_pulse_d), // input wire [0:0]  probe6 
	.probe7(rssi_value[0]) // input wire [31:0]  probe7
);
 end : ila_dbg_en
   endgenerate
*/   
endmodule




   
