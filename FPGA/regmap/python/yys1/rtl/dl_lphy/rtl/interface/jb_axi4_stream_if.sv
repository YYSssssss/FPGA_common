////////////////////////////////////////////////////////////////////
////  File Name : jb_axi4_stream_if.sv
///// Author    : Shehanaj Begum
///// Date      : 11/09/2018
///// Description  : Used for 40G Ethernet Core 256 axi stream interface
////////////////////////////////////////////////////////////////////



interface jb_axi4_stream_if #( 
    parameter DATA_WIDTH = 256, //power of 2, multiple of 8
    parameter USER_SB_WIDTH =1			       
);

   localparam N_BYTES = DATA_WIDTH/8;
 
  
   logic [7:0]               tid; //not used
   logic [3:0]               tdest; //not used
   logic [N_BYTES-1:0] 	     tstrb;
   logic [USER_SB_WIDTH-1:0] tuser;
   logic [N_BYTES-1:0]       tkeep;
   logic [DATA_WIDTH-1:0]    tdata;
   logic                     tvalid;
   logic                     tready;
   logic                     tlast;
   	   
   modport master ( 
	  input tready,
	  output tuser,tkeep,tdata,tvalid,tlast
   );
   modport slave (	  
	  input tuser,tkeep,tdata,tvalid,tlast,
	  output tready
   );

endinterface
