// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : sbegum                                                      // 
// Date         : 11/01/20                                                    // 
// File         : jb_fh_proc_ctrl.sv                                            // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_fh_proc_ctrl_if;
   logic                        eth_dl_to_ul_lpbk;



modport ctrl (
output
        eth_dl_to_ul_lpbk
);


modport  fh (
input
        eth_dl_to_ul_lpbk
);



endinterface


