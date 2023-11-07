////////////////////////////////////////////////////////////////////
////  File Name : IFP_xran_header_app_cmn.sv
///// Author    : Shehanaj Begum
///// Date      : 10/14/2020
///// Description  : FrontHaul Miscellanious
////////////////////////////////////////////////////////////////////



interface jb_xran_header_app_cmn_if ();

   logic          radio_app_head_valid;
   logic 	  datadirection;
   logic [7:0] 	  numsections;
   logic [2:0] 	  sectiontype;
   logic [3:0] 	  filterindex;
   logic [7:0] 	  frameid;
   logic [3:0] 	  subframeid;
   logic [5:0] 	  slotid;
   logic [5:0] 	  symbolid;
   logic [7:0] 	  udcomphdr;
   logic [15:0]   timeoffset;
   logic [7:0] 	  framestructure;
   logic [15:0]   cplength;
  
   	   
   modport fh ( 
	output	radio_app_head_valid,
		datadirection,
		numsections,
		sectiontype,
		filterindex,
		frameid,
		subframeid,
		slotid,
		symbolid,
		udcomphdr,
		timeoffset,
		framestructure,
		cplength   
   );
   modport lphy (
	input	radio_app_head_valid,
		datadirection,
		numsections,
		sectiontype,
		filterindex,
		frameid,
		subframeid,
		slotid,
		symbolid,
		udcomphdr,
		timeoffset,
		framestructure,
		cplength   
     
   );

endinterface
