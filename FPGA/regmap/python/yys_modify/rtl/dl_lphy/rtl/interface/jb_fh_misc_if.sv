////////////////////////////////////////////////////////////////////
////  File Name : jb_fh_misc_if.sv
///// Author    : Shehanaj Begum
///// Date      : 10/14/2020
///// Description  : FrontHaul Miscellanious
////////////////////////////////////////////////////////////////////



interface jb_fh_misc_if #( 
    parameter N_CARRIERS = 2, //power of 2, multiple of 8
    parameter N_ANTENNAS = 4,
    parameter  N_ETH_PORTS= 2			       
);

  
   
   logic 				    one_pps;
   logic [N_CARRIERS-1:0]		    dl_radio_start_10ms;
   logic [N_CARRIERS-1:0]		    ul_radio_start_10ms;
   logic [N_ETH_PORTS-1:0]		    eth_fram_reset_active;
   logic 				    ul_fram_ready;
   logic 				    dl_defm_ready;
   logic [31:0]				    systimer_ns;
   logic [47:0]				    systimer_s;

  
   	   
   modport fh ( 
	  input  dl_radio_start_10ms, 
                 ul_radio_start_10ms, 
	  output one_pps,
		 systimer_s,
		 systimer_ns,
                 eth_fram_reset_active, 
		 ul_fram_ready, 
		 dl_defm_ready 
   );
   modport lphy (
	  output dl_radio_start_10ms, 
                 ul_radio_start_10ms, 
	  input  one_pps,
		 systimer_s,
		 systimer_ns,
                 eth_fram_reset_active, 
		 ul_fram_ready, 
		 dl_defm_ready 
   );

endinterface
