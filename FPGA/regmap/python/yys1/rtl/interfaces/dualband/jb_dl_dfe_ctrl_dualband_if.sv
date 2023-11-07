// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : begum                                                       // 
// Date         : 11/16/20                                                    // 
// File         : jb_dl_dfe_ctrl.sv                                             // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_dl_dfe_ctrl_if;
   logic                        dl_ant_int_frac_delay_trig;
   logic  [1:0][31:0]           dl_car_nco_lsb;
   logic  [1:0][6:0]            dl_car_nco_msb;
   logic  [1:0]                 dl_car_nco_sign;
   logic  [1:0][3:0]            dl_stream_gain_scaler_sign;
   logic  [1:0][3:0][3:0]       dl_stream_gain_scaler;
   logic  [1:0][3:0][15:0]      dl_stream_gain_fraction;
   logic  [3:0]                 dl_ant_precfr_gain_scaler_sign;
   logic  [3:0][3:0]            dl_ant_precfr_gain_scaler;
   logic  [3:0][15:0]           dl_ant_precfr_gain_fraction;
   logic  [3:0]                 dl_ant_postcfr_gain_scaler_sign;
   logic  [3:0][3:0]            dl_ant_postcfr_gain_scaler;
   logic  [3:0][15:0]           dl_ant_postcfr_gain_fraction;
   logic  [3:0][5:0]            dl_ant_delay;
   logic                        bypass_dpd;
   logic                        bypass_cfr;
   logic                        override_postcfr;
   logic                        ps_filter_bypass;
   logic                        clear_sat_flags;
   logic  [1:0][3:0][6:0]       dl_int_delay;
   logic  [1:0][3:0][15:0]      dl_frac_delay;
   logic  [31:0]                pl_debug;



modport ctrl (
output
        dl_ant_int_frac_delay_trig,
        dl_car_nco_lsb,
        dl_car_nco_msb,
        dl_car_nco_sign,
        dl_stream_gain_scaler_sign,
        dl_stream_gain_scaler,
        dl_stream_gain_fraction,
        dl_ant_precfr_gain_scaler_sign,
        dl_ant_precfr_gain_scaler,
        dl_ant_precfr_gain_fraction,
        dl_ant_postcfr_gain_scaler_sign,
        dl_ant_postcfr_gain_scaler,
        dl_ant_postcfr_gain_fraction,
        dl_ant_delay,
        bypass_dpd,
        bypass_cfr,
        override_postcfr,
        ps_filter_bypass,
        clear_sat_flags,
        dl_int_delay,
        dl_frac_delay,
        pl_debug
);


modport  dl_dfe (
input
        dl_ant_int_frac_delay_trig,
        dl_car_nco_lsb,
        dl_car_nco_msb,
        dl_car_nco_sign,
        dl_stream_gain_scaler_sign,
        dl_stream_gain_scaler,
        dl_stream_gain_fraction,
        dl_ant_precfr_gain_scaler_sign,
        dl_ant_precfr_gain_scaler,
        dl_ant_precfr_gain_fraction,
        dl_ant_postcfr_gain_scaler_sign,
        dl_ant_postcfr_gain_scaler,
        dl_ant_postcfr_gain_fraction,
        dl_ant_delay,
        bypass_dpd,
        bypass_cfr,
        override_postcfr,
        ps_filter_bypass,
        clear_sat_flags,
        dl_int_delay,
        dl_frac_delay,
        pl_debug
);

modport lat (
     input bypass_dpd, bypass_cfr
 );

endinterface


