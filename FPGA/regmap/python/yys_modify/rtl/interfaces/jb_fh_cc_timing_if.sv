////////////////////////////////////////////////////////////////////
////  File Name : jb_fh_cc_timing_if.sv
///// Author    : Shehanaj Begum
///// Date      : 10/14/2020
///// Description  : FrontHaul Miscellanious
////////////////////////////////////////////////////////////////////



interface jb_fh_cc_timing_if ();

  
   
   
   logic 			 cc_enable;
   logic 			 cc_reload;
   logic [11:0]      dl_cta_sym_num;
   logic [11:0] 	 dl_sym_num;
   logic 			 dl_update;
   logic [11:0] 	 ul_cta_sym_num;
   logic [11:0] 	 ul_sym_num;
   logic 			 ul_update;
  
   	   
   modport fh ( 
       output   cc_enable,
	        cc_reload,
   	        dl_cta_sym_num,
   		dl_sym_num,
   		dl_update,
   		ul_cta_sym_num,
   		ul_sym_num,
 		ul_update
   );
   modport lphy (
	   
       input   cc_enable,
	        cc_reload,
   	        dl_cta_sym_num,
   		dl_sym_num,
   		dl_update,
   		ul_cta_sym_num,
   		ul_sym_num,
 		ul_update
   );

endinterface
