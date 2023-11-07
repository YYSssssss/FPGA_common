///////////////////////////////////////////////////////////////////////////////////
////  File Name : jb_ovrfl_undfl_det.sv
///// Author    : Shehanaj Begum
///// Date      : 3/12/2020
///// Description  : This module detects overflow and underflow condition. 
///// It also saturates the data when the codition happens
////////////////////////////////////////////////////////////////////////////////////

module jb_ovrfl_undfl_det #(
      parameter INPUT_DATA_BUS_WIDTH = 32,
      parameter OUTPUT_DATA_BUS_WIDTH = 16
) (

   input 			      clk,
   input 			      resetn,
   input                              clk_en,

   input [INPUT_DATA_BUS_WIDTH-1:0]   data_in,
   output [OUTPUT_DATA_BUS_WIDTH-1:0] data_out,

   output logic			      ovrfl_undfl_flag_msb_plus1_flag,
   output logic			      ovrfl_undfl_flag_all_msb_flag
   

);


   localparam MSB_DATA_BITS_DROP = INPUT_DATA_BUS_WIDTH-OUTPUT_DATA_BUS_WIDTH;

   logic [1:0] 			      msb_2bits;
   logic 			      ovfl_2bits;
   logic 			      undfl_2bits;
   logic 			      ovrfl_undfl_flag_all_msb;
   


   assign msb_2bits = (INPUT_DATA_BUS_WIDTH > OUTPUT_DATA_BUS_WIDTH) ?  data_in[OUTPUT_DATA_BUS_WIDTH:OUTPUT_DATA_BUS_WIDTH-1] : 2'b00;
   assign ovfl_2bits = (msb_2bits == 2'b01) ? 1'b1 : 1'b0;
   assign undfl_2bits = (msb_2bits == 2'b10) ? 1'b1 : 1'b0;

   assign ovrfl_undfl_flag_all_msb = (INPUT_DATA_BUS_WIDTH > OUTPUT_DATA_BUS_WIDTH) ?  
				     ~(&(data_in[INPUT_DATA_BUS_WIDTH-1:OUTPUT_DATA_BUS_WIDTH-1]) | 
				       (~|(data_in[INPUT_DATA_BUS_WIDTH-1:OUTPUT_DATA_BUS_WIDTH-1]))) : 1'b0;

   //if overf, assign max positive, if underflow asisgn to min negative
   assign data_out = (ovfl_2bits ?  {1'b0, {(OUTPUT_DATA_BUS_WIDTH-1){1'b1}}} : 
		      (undfl_2bits ? {1'b1, {(OUTPUT_DATA_BUS_WIDTH-1){1'b0}}} :
		       data_in[OUTPUT_DATA_BUS_WIDTH-1:0]));


   assign ovrfl_undfl_flag_msb_plus1_flag = ovfl_2bits|undfl_2bits;
   assign ovrfl_undfl_flag_all_msb_flag = ovrfl_undfl_flag_all_msb;

  									 
   

		      

endmodule
   
