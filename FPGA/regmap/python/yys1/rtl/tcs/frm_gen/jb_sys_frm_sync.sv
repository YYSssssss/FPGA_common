// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : Shehanaj Begum                                                    //
// Date         : 10/30/2020                                                  //
// Module       : jb_sys_frm_sync.sv                                                 //
// Description  :                                                             //
// ========================================================================== //

module jb_sys_frm_sync #(
      parameter CYCLES_10MS = 1228800,     
      parameter CYCLES_10MS_BW = 21			 
) (

       input      clk,
       input      reset,
       input      frm_mrkr_start,
       output     frm_mrkr
);


  logic [2:0]             frm_mrkr_start_sync=0;  
  logic 		  frm_mrkr_syncd;
  logic 		  reset_cntr_n;
  logic 		  reset_cntr;
  logic [CYCLES_10MS_BW-1:0] frm_cntr;
   
   

    always_ff @(posedge clk) begin
      if (reset) begin
         frm_mrkr_start_sync <= 0;
      end
      else  begin
         frm_mrkr_start_sync <= {frm_mrkr_start_sync[1:0],frm_mrkr_start};
      end
    end

   assign frm_mrkr_syncd = frm_mrkr_start_sync[2];
   assign reset_cntr = reset | !frm_mrkr_syncd;
   assign reset_cntr_n = !reset_cntr;
   
		      

   jb_cntr #(
      .COUNT_WIDTH(CYCLES_10MS_BW)
   ) u_frm_mrkr_cntr (
      .clk(clk),
      .resetn(reset_cntr_n),
      .enable (1'b1),
      .max_value(CYCLES_10MS-1),
      .cntr(frm_cntr)
    );

   assign frm_mrkr = frm_mrkr_syncd & (frm_cntr==0);
   

endmodule   
