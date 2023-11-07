////////////////////////////////////////////////////////////////////
////  File Name : jb_axi4_stream_if.sv
///// Author    : Shehanaj Begum
///// Date      : 11/09/2018
///// Description  : Used for 40G Ethernet Core 256 axi stream interface
////////////////////////////////////////////////////////////////////



interface jb_ram_dp_if #( 
    parameter DATA_WIDTH  = 32, 
    parameter MEM_DEPTH   = 1024 //power of 2, multiple of 8			       
);

   
   localparam ADDR_WIDTH = $clog2(MEM_DEPTH);
   localparam BYTE_EN_WIDTH = DATA_WIDTH/8;
   
   logic [DATA_WIDTH-1:0]   wr_data;
   logic [ADDR_WIDTH-1:0]   wr_addr;
   logic 		    wr_en;
   logic [BYTE_EN_WIDTH-1:0]    wr_byte_en;

   
   logic [DATA_WIDTH-1:0]   rd_data;
   logic [ADDR_WIDTH-1:0]   rd_addr;
   logic 		    rd_en;
   
	 
   modport host_wr (
     output wr_addr, wr_data, wr_en, wr_byte_en
   );

   
   modport host_rd (
     input rd_data,
     output rd_addr,rd_en
   );

   modport mem (
     output rd_data,
     input rd_addr,rd_en, wr_addr, wr_data, wr_en, wr_byte_en
   );
   modport host (
     input rd_data,
     output rd_addr,rd_en, wr_addr, wr_data, wr_en, wr_byte_en
   );
  
   
endinterface // jb_ram_dp_if
