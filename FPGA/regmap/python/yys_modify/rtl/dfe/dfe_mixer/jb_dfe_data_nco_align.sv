
 module jb_dfe_data_nco_align #(
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter  NCO_LATENCY=3
			
   ) (

      input clk,
      input resetn,

      // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0A3
      // 4:C1A0,  5:C1A1, 6: C1A2, 7 : C1A3
      input 		       tvalid_in,
      input [2*PRECISION-1:0]  tdata_in,

      //DPD outputs 2 arrays of axi stream
      output 		       tvalid_out,
      output [2*PRECISION-1:0]  tdata_out
      
      
      );

   localparam N_BYTES_AXI = $ceil((PRECISION*2)/8);
   localparam USER_ID_BW = $clog2(N_ANTENNAS);
   
   logic 		     tvalid[NCO_LATENCY-1:0];
   logic [USER_ID_BW-1:0]    tuser[NCO_LATENCY-1:0];
   logic [2*PRECISION-1:0]   tdata[NCO_LATENCY-1:0];

   genvar 		     i;

   assign tvalid_out = tvalid[NCO_LATENCY-1];
   assign tdata_out = tdata[NCO_LATENCY-1];
     
   always @(posedge clk) begin
      if (!resetn) begin
	 tvalid[0] <= 0;
	 tdata[0]  <= 0;
      end
      else begin
	 tvalid[0] <= tvalid_in;
	 tdata[0]  <= tdata_in;
      end     
   end // always @ (posedge clk)
   
   generate
      for (i = 1; i <  NCO_LATENCY; i = i + 1) begin: dl_dfe_nco_align  
	 always @(posedge clk) begin
	    if (!resetn) begin
	       tvalid[i] <= 0;
	       tdata[i]  <= 0;
	    end
	    else begin
	       tvalid[i] <= tvalid[i-1];     
	       tdata[i]  <= tdata[i-1];
	    end     
	 end // always @ (posedge clk)
      end : dl_dfe_nco_align 
   endgenerate
   
endmodule // jb_dl_dfe_nco
