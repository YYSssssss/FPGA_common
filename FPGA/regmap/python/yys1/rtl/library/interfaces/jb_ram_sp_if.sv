////////////////////////////////////////////////////////////////////
////  File Name : jb_axi4_stream_if.sv
///// Author    : Shehanaj Begum
///// Date      : 11/09/2018
///// Description  : Used for 40G Ethernet Core 256 axi stream interface
////////////////////////////////////////////////////////////////////



interface jb_ram_sp_if #( 
    parameter DATA_WIDTH  = 32, 
    parameter ADDR_WIDTH   = 1024 //power of 2, multiple of 8			       
);

   //clog2 does not work in vivado in synth
   //localparam ADDR_WIDTH = $clog2(MEM_DEPTH);
   localparam BYTE_EN_WIDTH = DATA_WIDTH/8;
   
   
   logic [DATA_WIDTH-1:0]   wr_data;
   logic [ADDR_WIDTH-1:0]   addr;
   logic [BYTE_EN_WIDTH-1:0] wr_en;

   
   logic [DATA_WIDTH-1:0]   rd_data;
   logic 		    en;
   
   
	 
 
   modport mem (
     output rd_data,
     input  addr,en, wr_data, wr_en
   );
   modport host (
     input rd_data,
     output en, addr, wr_data, wr_en
   );
  
   
endinterface // jb_ram_dp_if
