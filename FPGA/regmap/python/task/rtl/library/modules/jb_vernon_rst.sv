///////////////////////////////////////////////////////////////////////////////////
////  File Name : jb_logan_rst.sv
///// Author    : Shehanaj Begum
///// Date      : 11/11/2019
///// Description  : This module contains all reset muxes, controls, syncs   
////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module jb_vernon_rst (

 input 	[15:0]  soft_reset_axi_clk, //active high now
 input 	dfe_resetn_slow_clk, //active low 
 input  axi_clk, 

 input 	clk_122p88,
 input 	clk_368p64,
 input 	clk_491p52,
 input 	clk_15p36,

 output logic dfe_resetn_clk122p88,
 output logic dfe_resetn_clk368p64,
 output logic dfe_resetn_clk491p52,
(* DONT_TOUCH = "TRUE" *)  output logic duc0_resetn_clk491p52, 
(* DONT_TOUCH = "TRUE" *)  output logic duc1_resetn_clk491p52, 
(* DONT_TOUCH = "TRUE" *)  output logic lphy0_resetn_clk491p52, 
(* DONT_TOUCH = "TRUE" *)  output logic lphy1_resetn_clk491p52,  
 
 

 output logic dfe_resetn_clk15p36

);

   logic [2:0] resetn_clk122p88;
   logic [2:0] resetn_clk368p64;
   logic [2:0] resetn_clk491p52;

   
   logic [2:0] soft_resetn_clk122p88;
   logic [2:0] soft_resetn_clk368p64;
   logic [2:0] soft_resetn_clk491p52;

   logic       dfe_soft_resetn_axi_clk;
   logic       dfe_soft_reset_axi_clk;
   

   assign dfe_soft_reset_axi_clk = soft_reset_axi_clk[0];
   
   assign dfe_resetn_clk15p36 = dfe_resetn_slow_clk;

   assign dfe_soft_resetn_axi_clk = ~dfe_soft_reset_axi_clk; //create active low

 always_ff @(posedge clk_122p88) begin
    resetn_clk122p88[2:0] <= {resetn_clk122p88[1:0],dfe_resetn_slow_clk};
    soft_resetn_clk122p88[2:0] <= {soft_resetn_clk122p88[1:0],dfe_soft_resetn_axi_clk};
    dfe_resetn_clk122p88 <= resetn_clk122p88[2] & soft_resetn_clk122p88[2];
    
 end

 always @(posedge clk_368p64) begin
    resetn_clk368p64[2:0] <= {resetn_clk368p64[1:0],dfe_resetn_slow_clk};
    soft_resetn_clk368p64[2:0] <= {soft_resetn_clk368p64[1:0],dfe_soft_resetn_axi_clk};
    dfe_resetn_clk368p64 <= resetn_clk368p64[2] & soft_resetn_clk368p64[2];
 end
  
 always @(posedge clk_491p52) begin
    resetn_clk491p52[2:0] <= {resetn_clk491p52[1:0],dfe_resetn_slow_clk};
    soft_resetn_clk491p52[2:0] <= {soft_resetn_clk491p52[1:0],dfe_soft_resetn_axi_clk};
    dfe_resetn_clk491p52 <= resetn_clk491p52[2] & soft_resetn_clk491p52[2];
    duc0_resetn_clk491p52 <= resetn_clk491p52[2] & soft_resetn_clk491p52[2];
    duc1_resetn_clk491p52 <= resetn_clk491p52[2] & soft_resetn_clk491p52[2];
    lphy0_resetn_clk491p52 <= resetn_clk491p52[2] & soft_resetn_clk491p52[2];
    lphy1_resetn_clk491p52   <= resetn_clk491p52[2] & soft_resetn_clk491p52[2];
	
	
	
	
	
 end
   
 
endmodule
