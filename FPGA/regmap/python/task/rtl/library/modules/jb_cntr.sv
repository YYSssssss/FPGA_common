    ///////////////////////////////////////////////////////////////////////////////////
    ////  File Name : jb_nco_cntr.sv
    ///// Author    : Shehanaj Begum
    ///// Date      : 1/04/2019
    ///// Description  : This module does the nco    
    ////////////////////////////////////////////////////////////////////////////////////
   
module jb_cntr #(
    parameter COUNT_WIDTH =39 //supported 128,256,512, based on input width
  ) (    
          input clk,
          input resetn,

          input enable,
          input [COUNT_WIDTH-1:0] max_value,
            
          output logic [COUNT_WIDTH-1:0] cntr		
  );

   always @(posedge clk) begin
      if (!resetn) begin
	 cntr <= 0;
      end
      else if (enable) begin
	 if (cntr == max_value) begin
	    cntr <= 0;
	 end
	 else begin
	    cntr <= cntr +1;
	 end
      end
   end


endmodule
