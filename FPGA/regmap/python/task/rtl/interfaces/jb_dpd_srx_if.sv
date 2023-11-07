////////////////////////////////////////////////////////////////////
////  File Name : jb_dpd_srx_if.sv
///// Author    : Shehanaj Begum
///// Date      : 4/24/2019
///// Description  : DL DFE COntrol
////////////////////////////////////////////////////////////////////



interface jb_dpd_srx_if;


   logic [7 : 0] 	   srx_ctrl_tdata;   
   logic 		   srx_ctrl_tready;      
   logic 		   srx_ctrl_tvalid;       

   
  logic [7 : 0] 	   srx_tuser;
  logic 		   srx_tready;
  logic [31 : 0] 	   srx_tdata;
  logic                    srx_tvalid;

		       
modport dpd (
     output srx_ctrl_tdata, srx_ctrl_tvalid, srx_tready,
     input  srx_ctrl_tready, srx_tuser, srx_tdata, srx_tvalid
);


modport srx_ctrl (
     input srx_ctrl_tdata, srx_ctrl_tvalid, srx_tready,
     output  srx_ctrl_tready, srx_tuser, srx_tdata, srx_tvalid
 );

endinterface
