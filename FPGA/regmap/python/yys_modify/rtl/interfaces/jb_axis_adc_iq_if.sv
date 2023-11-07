// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 4/25/19                                                     //
// Module       :                                                             //
// Description  :                                                             //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
// ========================================================================== //


interface jb_axis_adc_iq_if #( 
    parameter DATA_WIDTH = 16
);

    logic [DATA_WIDTH-1:0]  i_tdata;
    logic                   i_tready;
    logic                   i_tvalid;
    
    logic [DATA_WIDTH-1:0]  q_tdata;
    logic                   q_tready;
    logic                   q_tvalid;
   	   
   modport master ( 
        input   i_tready,
        input   q_tready,
        output  i_tdata, i_tvalid,
        output  q_tdata, q_tvalid
   );
   modport slave (	  
        input   i_tdata, i_tvalid,
        input   q_tdata, q_tvalid,
        output  i_tready,
        output  q_tready
   );

endinterface
