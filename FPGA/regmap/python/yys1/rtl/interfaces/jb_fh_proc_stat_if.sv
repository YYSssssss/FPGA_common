// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : sbegum                                                      // 
// Date         : 11/01/20                                                    // 
// File         : jb_fh_proc_stat.sv                                            // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_fh_proc_stat_if;

logic pll_lock;

modport stat (
input
        pll_lock
);


modport  fh (
output
        pll_lock
);





endinterface