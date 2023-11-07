
 module jb_axis_sync_fastc_slowc #(
      parameter  FAST_TO_SLOW_RATIO=4,
      parameter  FAST_TO_SLOW_RATIO_BW=2,
      parameter  DATA_BW=32,
      parameter  ILA_EN=0,
      parameter  USR_ID_BW=2
   ) (

      input clk_slow_en,
      input clk_fast_en,
      input clk_slow,
      input clk_fast,
      input resetn_clk_fast,
      input resetn_clk_slow,

      
      jb_axi4_stream_if.slave IFP_axis_in,

      
      jb_axi4_stream_if.master IFP_axis_out //{q,i}- cocatenated
      
      
      );

  
   
   logic [DATA_BW-1:0]   tdata_d;
   logic [USR_ID_BW-1:0]   tuser_d;
   
   logic    tvalid_d;
   logic [FAST_TO_SLOW_RATIO_BW-1:0] clk_fast_cntr;
   logic 			     enable_cntr;
   
     //to start the counter
    always_ff @(posedge clk_fast) begin
        if (!resetn_clk_fast) begin
            enable_cntr <= 1'b0;
        end
        else if (clk_fast_en) begin
            if (IFP_axis_in.tvalid) begin
                enable_cntr <= 1'b1;
            end 
        end
    end
   
   jb_cntr #(
      .COUNT_WIDTH(FAST_TO_SLOW_RATIO_BW)
   ) u_jb_fast_cntr (
      .clk(clk_fast),
      .resetn(resetn_clk_fast & (!IFP_axis_in.tvalid)),
      .enable (enable_cntr & clk_fast_en), //tvalid aligns with cnt=0
      .max_value(FAST_TO_SLOW_RATIO-1),
      .cntr(clk_fast_cntr)
    );

    //save data, user id, 
    always_ff @(posedge clk_fast) begin
        if (!resetn_clk_fast) begin
            tvalid_d <= 1'b0;
            tdata_d <= 0;
            tuser_d <= 0;
        end
        else if (clk_fast_en) begin
            if (IFP_axis_in.tvalid) begin
                tvalid_d <= 1'b1;
                tdata_d <= IFP_axis_in.tdata;
                tuser_d <= IFP_axis_in.tuser;
            end
            else if ( clk_fast_cntr == FAST_TO_SLOW_RATIO-1) begin //only needed for 
                tvalid_d <= 1'b0;
            end
	   
        end
    end
    
    always @(posedge clk_slow) begin
        if (!resetn_clk_slow) begin
            IFP_axis_out.tdata <= 1'b0;
            IFP_axis_out.tuser <= 0;
            IFP_axis_out.tvalid<=1'b0;   
        end
        else if (clk_slow_en) begin
            if (tvalid_d) begin
                IFP_axis_out.tdata<=tdata_d;
                IFP_axis_out.tuser <= tuser_d;
            end
            IFP_axis_out.tvalid<=tvalid_d;
        end
   end // always @ (posedge clk)

   assign IFP_axis_out.tkeep = 0;
   assign IFP_axis_out.tlast = 1'b0;
   assign IFP_axis_in.tready = 1'b1;
 /*  
   generate
      if (ILA_EN==1) begin : ila_dbg_en
    ila_0 u_ila_ul_dfe_in (
	   .clk(clk_fast), // input wire clk
	   .probe0(tvalid_d), // input wire [0:0]  probe0  
	   .probe1(clk_fast_cntr), // input wire [1:0]  probe1 
	   .probe2(tdata_d) // input wire [31:0]  probe2
         );

   
      end : ila_dbg_en
   endgenerate
*/   
endmodule // jb_axis_sync_fastc_lowc
