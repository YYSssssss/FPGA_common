    ///////////////////////////////////////////////////////////////////////////////////
    ////  File Name : jb_nco_cntr.sv
    ///// Author    : Shehanaj Begum
    ///// Date      : 1/04/2019
    ///// Description  : This module does the nco    
    ////////////////////////////////////////////////////////////////////////////////////
   
module jb_cntr_p2s #(
    parameter COUNT_WIDTH =39 //supported 128,256,512, based on input width
  ) (    
          input clk,
          input resetn,

          input enable,
          input [COUNT_WIDTH-1:0] max_value,
            
          output logic [COUNT_WIDTH-1:0] cntr		
  );

logic s_enable_d1;
logic s_enable_r ;

always @(posedge clk)
s_enable_d1 <= enable;

assign s_enable_r = enable & (~s_enable_d1);


always @(posedge clk) begin
   if(!resetn)
    cntr <= 0;
   else if(s_enable_r) 
    cntr <= 1;	
   else if(cntr == max_value)
    cntr <= 0;
   else if(cntr != 0)
    cntr <= cntr +1;   

end


endmodule
