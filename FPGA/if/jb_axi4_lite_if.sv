////////////////////////////////////////////////////////////////////
////  File Name : jb_axi4_stream_if.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2019
///// Description  : Used for 40G Ethernet Core 256 axi stream interface
////////////////////////////////////////////////////////////////////



interface jb_axi4_lite_if #( 
    parameter ADDR_WIDTH = 17, //power of 2, multiple of 8
    parameter DATA_WIDTH =32			       
);

   localparam N_BYTES = DATA_WIDTH/8;
 

     
   logic [ADDR_WIDTH-1:0] 			    awaddr;
   logic [2:0] 					    awprot;
   logic 					    awvalid;
   logic 					    awready;
   logic [DATA_WIDTH-1:0] 			    wdata;
   logic [(DATA_WIDTH/8)-1 : 0]                     wstrb; 
   logic 					    wvalid;   
   logic 					    wready;
   logic 					    bresp;
   logic 					    bvalid;
   logic 					    bready;
   logic [ADDR_WIDTH-1:0] 			    araddr;
   logic [2:0]					    arprot;
   logic 					    arvalid;
   logic 					    arready;
   logic [DATA_WIDTH-1:0]			    rdata;
   logic [1:0] 					    rresp;
   logic 					    rvalid;
   logic 					    rready;
   
   
   
   
  
   	   
   modport master ( 
	  input awready, wready, bresp, bvalid, arready, rvalid, rresp, rdata, 
	  output awaddr, awprot, awvalid, wdata, wstrb, wvalid, bready, araddr, arprot, arvalid,rready
   );
   modport slave (
	  input awaddr, awprot, awvalid, wdata, wstrb, wvalid, bready, araddr, arprot, arvalid,rready,
	  output awready, wready, bresp, bvalid, arready, rvalid, rresp, rdata
   );

endinterface
