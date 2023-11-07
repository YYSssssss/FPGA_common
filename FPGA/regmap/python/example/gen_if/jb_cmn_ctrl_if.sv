// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 3007216                                                     // 
// Date         : 06/24/22                                                    // 
// File         : jb_cmn_ctrl.sv                                                // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_cmn_ctrl_if;
   logic  [15:0]                hw_id;
   logic  [15:0]                soft_reset;
   logic  [20:0]                xssi_num_15p36_tics;
   logic                        dl_dfe_reset;
   logic                        ul_dfe_reset;
   logic                        dbg_module_reset;



modport ctrl (
output
        hw_id,
        soft_reset,
        xssi_num_15p36_tics,
        dl_dfe_reset,
        ul_dfe_reset,
        dbg_module_reset
);


modport  blk (
input
        hw_id,
        soft_reset,
        xssi_num_15p36_tics,
        dl_dfe_reset,
        ul_dfe_reset,
        dbg_module_reset
);



endinterface


