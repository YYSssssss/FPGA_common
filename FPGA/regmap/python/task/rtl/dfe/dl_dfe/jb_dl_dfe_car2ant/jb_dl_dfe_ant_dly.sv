////////////////////////////////////////////////////////////////////
////  File Name : jb_dl_dfe_cmbn.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2018
///// Description  : DL Antenna Delay Module
///                 
///
////////////////////////////////////////////////////////////////////
 module jb_dl_dfe_ant_dly  #(
      parameter  PRECISION=16
   ) (


            input 		     clk_1x,
            input 		     resetn_1x,
	    input [5:0]              ant_delay,		     
	    
	    input 		     tvalid_in,
            input [2*PRECISION-1:0]  tdata_in,
	    
	    //DPD outputs 2 arrays of axi stream
	    output logic 		     tvalid_out,
	    output logic [2*PRECISION-1:0] tdata_out
      
      
      );

   localparam ANT_MAX_DELAY=32;

   logic [4:0] 			     ant_delay_minus_one;
   
  logic [ANT_MAX_DELAY-1:0] tvalid_dly;
  logic [ANT_MAX_DELAY-1:0] [2*PRECISION-1:0] tdata_dly;
   genvar i;

   assign ant_delay_minus_one = (ant_delay!=0) ? ant_delay-1 : 0;
   
   
   always @(posedge clk_1x) begin
      if (!resetn_1x) begin
	 tvalid_dly[0] <= 1'b0;
	 tdata_dly[0] <= 0;
      end
      else begin
	 tvalid_dly[0] <= tvalid_in;
	 tdata_dly[0] <= tdata_in;
      end // else: !if(!resetn)
   end // always @ (posedge clk)
   

   generate
      for (i = 1; i <  ANT_MAX_DELAY; i = i + 1) begin: ant_dly
	 always @(posedge clk_1x) begin
	    if (!resetn_1x) begin
	       tvalid_dly[i] <= 1'b0;
	       tdata_dly[i] <= 0;
	    end
	    else begin
	       tvalid_dly[i] <= tvalid_dly[i-1];
	       tdata_dly[i] <= tdata_dly[i-1];
	    end // else: !if(!resetn)
	 end // always @ (posedge clk)
      end : ant_dly   
   endgenerate

   
   always @(posedge clk_1x) begin
      if (!resetn_1x) begin
	 tvalid_out <= 1'b0;
	 tdata_out <= 0;
      end
      else begin
	 tvalid_out <= (ant_delay==0) ? tvalid_in :  tvalid_dly[ant_delay_minus_one];
	 tdata_out <= (ant_delay==0) ? tdata_in   :  tdata_dly[ant_delay_minus_one];
      end // else: !if(!resetn)
   end // always @ (posedge clk)
 
endmodule
