////////////////////////////////////////////////////////////////////
////  File Name : IFP_xran_header_app_section.sv
///// Author    : Shehanaj Begum
///// Date      : 10/14/2020
///// Description  : FrontHaul Miscellanious
////////////////////////////////////////////////////////////////////



interface jb_xran_header_app_section_if ();
 
  logic          section_header_valid;
  logic [14:0]   beamid15;
  logic [23:0]   freqoffset;
  logic [7:0]    numprbc;
  logic [3:0]    numsymbol;
  logic          rb;
  logic [11:0]   remask;
  logic [11:0]   sectionid;
  logic [9:0]    startprbc;
    	   
   modport fh ( 
	output	section_header_valid,
		beamid15,
		freqoffset,
		numprbc,
		numsymbol,
		rb,
		remask,
		sectionid,
		startprbc    
       );
        modport lphy (
	 input  section_header_valid,
		beamid15,
		freqoffset,
		numprbc,
		numsymbol,
		rb,
		remask,
		sectionid,
		startprbc
        );
   

endinterface
