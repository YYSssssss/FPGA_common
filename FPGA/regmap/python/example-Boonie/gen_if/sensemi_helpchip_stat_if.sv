// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : YYS                                                         // 
// Date         : 10/30/23                                                    // 
// File         : sensemi_helpchip_stat.sv                                           // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface sensemi_helpchip_stat_if;
   logic  [31:0]                hc_timestamp;



modport stat (
input
        hc_timestamp
);


modport  blk (
output
        hc_timestamp
);



endinterface


