////////////////////////////////////////////////////////////////////
////  File Name : jb_prach_cplane_if.sv
///// Author    : Shehanaj Begum
///// Date      : 10/14/2020
///// Description  : FrontHaul Miscellanious
////////////////////////////////////////////////////////////////////



interface jb_prach_cplane_if ();

  
   
   logic [14:0]            beamid;
   logic [3:0] 		   cc;
   logic [15:0] 	   cp_length;
   logic [3:0] 		   filter_index;
   logic [7:0] 		   frame_structure;
   logic [23:0] 	   freqoffset;
   logic [7:0] 		   num_prbc;
   logic [3:0] 		   num_symbol;
   logic 		   rb;
   logic [11:0] 	   remask;
   logic [3:0] 		   return_port;
   logic [11:0] 	   section_id;
   logic [3:0] 		   sf;
   logic [5:0] 		   sl;
   logic [7:0] 		   ss;
   logic [9:0] 		   start_prbc;
   logic [5:0] 		   sy;
   logic 		   syminc;
   logic [15:0] 	   time_offset;
   logic 		   tready;
   logic 		   tvalid;
   logic [7:0] 		   udcomphdr;
  
   	   
   modport fh ( 
	output	beamid,
		cc,
		cp_length,
		filter_index,
		frame_structure,
		freqoffset,
		num_prbc,
		num_symbol,
		rb,
		remask,
		return_port,
		section_id,
		sf,
		sl,
		ss,
		start_prbc,
		sy,
		syminc,
		time_offset,
		tvalid,
		udcomphdr,
       input    tready
   );
   modport lphy (
	input	beamid,
		cc,
		cp_length,
		filter_index,
		frame_structure,
		freqoffset,
		num_prbc,
		num_symbol,
		rb,
		remask,
		return_port,
		section_id,
		sf,
		sl,
		ss,
		start_prbc,
		sy,
		syminc,
		time_offset,
		tvalid,
		udcomphdr,
       output   tready
   );

endinterface
