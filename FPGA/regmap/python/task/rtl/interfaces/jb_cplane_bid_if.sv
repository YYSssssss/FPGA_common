////////////////////////////////////////////////////////////////////
////  File Name : jb_cplane_bid_if.sv
///// Author    : Shehanaj Begum
///// Date      : 10/14/2020
///// Description  : FrontHaul Miscellanious
////////////////////////////////////////////////////////////////////



interface jb_cplane_bid_if ();

  
   logic [14:0]               beamid15;
   logic [7:0] 		      cc_id;
   logic [7:0] 		      num_prbc;
   logic [3:0] 		      num_symbol;
   logic 		      rb;
   logic 		      ready;
   logic [11:0] 	      remask;
   logic [9:0] 		      start_prbc;
   logic 		      tlast;
   logic 		      valid;
  
   	   
   modport fh ( 
	output	beamid15,
		cc_id,
		num_prbc,
		num_symbol,
		rb,
		remask,
		start_prbc,
		tlast,
		valid,
	input   ready
   );
   modport lphy (
	input	beamid15,
		cc_id,
		num_prbc,
		num_symbol,
		rb,
		remask,
		start_prbc,
		tlast,
		valid,
	output  ready
   );

endinterface
