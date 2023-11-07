// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : sbegum                                                      // 
// Date         : 09/22/20                                                    // 
// File         : jb_ul_dfe_stat.sv                                             // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_ul_dfe_stat_devided_if;
   logic  [1:0]                       ul_dfe_car_flush_state;
   logic  [1:0][3:0][31:0]      rssi;



modport stat (
input
        ul_dfe_car_flush_state,
        rssi
);


modport ul_dfe (
   output rssi
 );
 
 modport ul_clocking (
   output ul_dfe_car_flush_state
 );



endinterface


