
 module jb_axis_sync_slowc_fastc #(
      parameter  FAST_TO_SLOW_RATIO=4,
      parameter  FAST_TO_SLOW_RATIO_BW=2
   ) (
      input clk_slow_en,
      input clk_fast_en,
      input clk_slow,
      input clk_fast,
      input resetn,

      
      jb_axi4_stream_if.slave IFP_axis_in,

      
      jb_axi4_stream_if.master IFP_axis_out //{q,i}- cocatenated
      
      
      );

  
   
   logic    tvalid_d;
   logic [FAST_TO_SLOW_RATIO_BW-1:0] clk_fast_cntr;

   logic counter_en;   
   assign counter_en = clk_fast_en & IFP_axis_in.tvalid;
 
 jb_cntr #(
      .COUNT_WIDTH(FAST_TO_SLOW_RATIO_BW)
   ) u_jb_fast_cntr (
      .clk(clk_fast),
      .resetn(resetn),
      .enable (counter_en), //connect enable based on divide every 4 cycles
//      .enable (IFP_axis_in.tvalid), //connect enable based on divide every 4 cycles
      .max_value(FAST_TO_SLOW_RATIO-1),
      .cntr(clk_fast_cntr)
    );
   
   //assuming valid is coming from a flop
   always @(posedge clk_fast) begin
      if (!resetn) begin
	 tvalid_d <= 1'b0;
      end
      else if (clk_fast_en) begin
	 tvalid_d <= IFP_axis_in.tvalid & (clk_fast_cntr==0);//if we use max value, can add multi cycles to previous stage	 
      end
   end

   //since sync clocks no need of double sync stages
  
   always @(posedge clk_fast) begin 
   if (!resetn) begin
	 IFP_axis_out.tdata <= 1'b0;
     IFP_axis_out.tuser <= 0;
     IFP_axis_out.tvalid<=1'b0;   
     end
      else if (clk_fast_en) begin
       if (tvalid_d) begin
	    IFP_axis_out.tdata <=IFP_axis_in.tdata;
	    IFP_axis_out.tuser <= IFP_axis_in.tuser;
      end
      IFP_axis_out.tvalid<=tvalid_d;
     end
   end // always @ (posedge clk)
   assign IFP_axis_out.tkeep = 0;
   assign IFP_axis_out.tlast = 1'b0;
   assign IFP_axis_in.tready = 1'b1;

endmodule
