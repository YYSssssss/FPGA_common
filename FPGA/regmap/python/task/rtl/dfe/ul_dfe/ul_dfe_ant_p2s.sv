////////////////////////////////////////////////////////////////////
////  File Name : jb_ul_dfe_cmbn.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2018
///// Description  : UL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_ul_dfe_ant_p2s  #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter USR_ID_BW=2
   ) (


            input clk_4x,
            input clk_1x,
            input resetn_4x,
            input resetn_1x,
	    jb_ul_dfe_ctrl_devided_if.ul_dfe IFP_ul_dfe_ctrl,
      input                any_stream_enable,
	    
	    input [N_ANTENNAS-1:0]tvalid_in,
        input [2*PRECISION-1:0] tdata_in[N_ANTENNAS-1:0],
	    
	    //DPD outputs 2 arrays of axi stream
	    output logic tvalid_out,
	    output logic [2*PRECISION-1:0] tdata_out,
        output logic [USR_ID_BW-1:0] tuser_out
      
      
      );


  logic [1:0] clk_4x_cntr;
  
  logic p2s_cntr_enable;
  logic s_tvalid_in_d1;
  logic s_tvalid_in_d2;
  logic s_tvalid_in_d3;



	
   assign p2s_cntr_enable = (|tvalid_in) ;

//    jb_cntr #(
//      .COUNT_WIDTH(2)
//   ) u_jb_4x_cntr (
//      .clk(clk_4x),
//      .resetn(resetn_4x),
//      .enable (p2s_cntr_enable), //connect enable based ondivide every 4 cycles
//      .max_value(2'b11),
//      .cntr(clk_4x_cntr)
//    );

    jb_cntr_p2s #(
      .COUNT_WIDTH(2)
   ) u_jb_cntr_p2s (
      .clk(clk_4x),
      .resetn(resetn_4x),
      .enable (p2s_cntr_enable), //connect enable based ondivide every 4 cycles
      .max_value(2'b11),
      .cntr(clk_4x_cntr)
    ); 
 

always @(posedge clk_4x) begin
s_tvalid_in_d1  <= tvalid_in     ;
s_tvalid_in_d2  <= s_tvalid_in_d1;
s_tvalid_in_d3  <= s_tvalid_in_d2;
end



   
 
   always @(posedge clk_4x) begin
    if (!resetn_4x) begin
      tdata_out <= 0;
      tvalid_out<=0;
     end
     else begin
//      if (|tvalid_in) begin
//	     tdata_out<=tdata_in[clk_4x_cntr];
//      end
	  tdata_out<=tdata_in[clk_4x_cntr];
//      tvalid_out<=|tvalid_in;
      tvalid_out<=tvalid_in||s_tvalid_in_d1||s_tvalid_in_d2||s_tvalid_in_d3;
      tuser_out<=clk_4x_cntr;
     end
   end // always @ (posedge clk)
 
   
 /*  
  ila_p2s_dbg u_ila_p2s_dbg (
	.clk(clk_4x), // input wire clk
	.probe0(tvalid_in[0]), // input wire [0:0]  probe0  
	.probe1(tvalid_in[1]), // input wire [0:0]  probe1 
	.probe2(tvalid_in[2]), // input wire [0:0]  probe2 
	.probe3(tvalid_in[3]), // input wire [0:0]  probe3 
	.probe4(tdata_in[0]), // input wire [31:0]  probe4 
	.probe5(tdata_in[1]), // input wire [31:0]  probe5 
	.probe6(tdata_in[2]), // input wire [31:0]  probe6 
	.probe7(tdata_in[3]), // input wire [31:0]  probe7 
	.probe8(tuser_out), // input wire [1:0]  probe8 
	.probe9(tvalid_out), // input wire [0:0]  probe9 
	.probe10(tdata_out), // input wire [31:0]  probe10 
	.probe11(clk_4x_cntr), // input wire [1:0]  probe11 
	.probe12(p2s_cntr_enable) // input wire [0:0]  probe12
); 
*/
  
endmodule // jb_ul_dfe_ant_s2p
