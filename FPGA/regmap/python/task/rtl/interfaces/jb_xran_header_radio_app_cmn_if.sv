////////////////////////////////////////////////////////////////////
////  File Name : jb_xran_header_ecpri_if.sv
///// Author    : Shehanaj Begum
///// Date      : 10/14/2020
///// Description  : FrontHaul Miscellanious
////////////////////////////////////////////////////////////////////



interface jb_xran_header_ecpri_if ();

  
   
   logic           t_header_offset_valid;
   logic 	   runt_packet_len;
   logic [15:0]    rtc_pc_id;
   logic 	   concat;
   logic [2:0] 	   messagetype;
   logic [7:0] 	   seqid;
   logic [6:0] 	   subseqid;
   logic 	   ebit;
   logic [15:0]    payloadsize;
   logic 	   packet_in_window;
   logic [11:0]    offset_in_symbol;
   	   
   modport fh ( 
       output	t_header_offset_valid,
		runt_packet_len,
		rtc_pc_id,
		concat,
		messagetype,
		seqid,
		subseqid,
		ebit,
		payloadsize,
		packet_in_window,
		offset_in_symbol
   );
   modport lphy (
      input	t_header_offset_valid,
		runt_packet_len,
		rtc_pc_id,
		concat,
		messagetype,
		seqid,
		subseqid,
		ebit,
		payloadsize,
		packet_in_window,
		offset_in_symbol
   );

endinterface
