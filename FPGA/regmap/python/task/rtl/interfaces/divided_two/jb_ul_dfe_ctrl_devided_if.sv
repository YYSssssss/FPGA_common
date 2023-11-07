// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : begum                                                       // 
// Date         : 12/17/20                                                    // 
// File         : jb_ul_dfe_ctrl.sv                                             // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_ul_dfe_ctrl_devided_if;
   logic                        ul_ant_int_frac_delay_trig;
   logic  [1:0][31:0]           ul_car_nco_lsb;
//   logic  [1:0][6:0]             ul_car_nco_msb;
   logic  [1:0][7:0]            ul_car_nco_msb;
   logic  [1:0]                 ul_car_nco_sign;
   logic  [1:0][3:0]            ul_stream_gain_scaler_sign;
   logic  [1:0][3:0][3:0]       ul_stream_gain_scaler;
   logic  [1:0][3:0][15:0]      ul_stream_gain_fraction;
   logic  [3:0]                 ul_ant_gain_scaler_sign;
   logic  [3:0][3:0]            ul_ant_gain_scaler;
   logic  [3:0][15:0]           ul_ant_gain_fraction;
   logic  [1:0][3:0][6:0]       ul_int_delay;
   logic  [1:0][3:0][15:0]      ul_frac_delay;
   
 

modport ctrl (
output
        ul_ant_int_frac_delay_trig,
        ul_car_nco_lsb,
        ul_car_nco_msb,
		ul_car_nco_sign,
        ul_stream_gain_scaler_sign,
        ul_stream_gain_scaler,
        ul_stream_gain_fraction,
        ul_ant_gain_scaler_sign,
        ul_ant_gain_scaler,
        ul_ant_gain_fraction,
        ul_int_delay,
        ul_frac_delay
);


modport  ul_dfe (
input
        ul_ant_int_frac_delay_trig,
        ul_car_nco_lsb,
        ul_car_nco_msb,
		ul_car_nco_sign,
        ul_stream_gain_scaler_sign,
        ul_stream_gain_scaler,
        ul_stream_gain_fraction,
        ul_ant_gain_scaler_sign,
        ul_ant_gain_scaler,
        ul_ant_gain_fraction,
        ul_int_delay,
        ul_frac_delay
);



endinterface


