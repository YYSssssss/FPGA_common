// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : YYS                                                         // 
// Date         : 10/30/23                                                    // 
// File         : sensemi_test_ctrl.sv                                               // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface sensemi_test_ctrl_if;
   logic  [30:0][31:0]          debug_rw;



modport ctrl (
output
        debug_rw
);


modport  blk (
input
        debug_rw
);



endinterface


