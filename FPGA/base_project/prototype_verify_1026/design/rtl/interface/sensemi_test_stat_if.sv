// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : YYS                                                         // 
// Date         : 10/30/23                                                    // 
// File         : sensemi_test_stat.sv                                               // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface sensemi_test_stat_if;
   logic  [31:0]                timestamp;



modport stat (
input
        timestamp
);


modport  blk (
output
        timestamp
);



endinterface


