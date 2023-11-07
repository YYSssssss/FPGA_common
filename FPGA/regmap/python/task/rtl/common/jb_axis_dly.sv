// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : Shehanaj Begum                                              //
// Date         : 07/25/2019                                                  //
// Module       : jb_axis_dly                                                 //
// Description  :  This module adds pipeline in the axi stream path           //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
// ========================================================================== //

`timescale 1ns / 1ps

module jb_axis_dly #(
    parameter   N_INTF        = 2        
) (
    input clk,
    input resetn,
    
   jb_axi4_stream_if.slave IFP_axis_in[N_INTF-1:0],
   jb_axi4_stream_if.master IFP_axis_out[N_INTF-1:0]
);

genvar i;
 generate
      for (i = 0; i <  N_INTF; i = i + 1) begin: axis_reg
	 assign IFP_axis_in[i].tready = 1'b1; //flow control is not supported
	 always @(posedge clk) begin
	    if (!resetn) begin
	       IFP_axis_out[i].tvalid <= 1'b0;
	       IFP_axis_out[i].tdata <= 0;
	       IFP_axis_out[i].tuser <= 0;
	    end
	    else begin
	       IFP_axis_out[i].tvalid <= IFP_axis_in[i].tvalid;
	       IFP_axis_out[i].tdata <= IFP_axis_in[i].tdata;
	       IFP_axis_out[i].tuser <= IFP_axis_in[i].tuser;
	    end // else: !if(!resetn)
	 end // always @ (posedge clk)
      end : axis_reg
endgenerate
   
    

   
endmodule

