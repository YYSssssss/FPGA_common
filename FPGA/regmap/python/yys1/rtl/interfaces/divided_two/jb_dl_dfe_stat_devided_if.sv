// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 2918630                                                     // 
// Date         : 07/19/21                                                    // 
// File         : jb_dl_dfe_stat.sv                                             // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_dl_dfe_stat_devided_if;
   logic  [1:0]                 dl_dfe_car_flush_state;
   logic  [7:0]                 dl_ant_postcfr_gain_scaler_sign;
   logic  [3:0][3:0]            dl_ant_postcfr_gain_scaler;
   logic  [3:0][15:0]           dl_ant_postcfr_gain_fraction;
   logic  [3:0][31:0]           ant_fh_tssi;
   logic                        bypass_dpd;
   logic  [1:0][31:0]           ps_sat_err_status;
   logic  [1:0][3:0][31:0]      car_inrtp_sat_err_status;
   logic  [31:0]                fir_3x_ant0to3_sat_err_status;
   logic  [31:0]                fir_3x_ant4to7_sat_err_status;
   logic  [31:0]                poly_even_ant0to3_sat_err_status;
   logic  [31:0]                poly_even_ant4to7_sat_err_status;
   logic  [31:0]                poly_odd_ant0to3_sat_err_status;
   logic  [31:0]                poly_odd_ant4to7_sat_err_status;



modport stat (
input
        dl_dfe_car_flush_state,
        dl_ant_postcfr_gain_scaler_sign,
        dl_ant_postcfr_gain_scaler,
        dl_ant_postcfr_gain_fraction,
        ant_fh_tssi,
        bypass_dpd,
        ps_sat_err_status,
        car_inrtp_sat_err_status,
        fir_3x_ant0to3_sat_err_status,
        fir_3x_ant4to7_sat_err_status,
        poly_even_ant0to3_sat_err_status,
        poly_even_ant4to7_sat_err_status,
        poly_odd_ant0to3_sat_err_status,
        poly_odd_ant4to7_sat_err_status
);


modport  dl_dfe (
output
        dl_dfe_car_flush_state,
        dl_ant_postcfr_gain_scaler_sign,
        dl_ant_postcfr_gain_scaler,
        dl_ant_postcfr_gain_fraction,
        ant_fh_tssi,
        bypass_dpd,
        ps_sat_err_status,
        car_inrtp_sat_err_status,
        fir_3x_ant0to3_sat_err_status,
        fir_3x_ant4to7_sat_err_status,
        poly_even_ant0to3_sat_err_status,
        poly_even_ant4to7_sat_err_status,
        poly_odd_ant0to3_sat_err_status,
        poly_odd_ant4to7_sat_err_status
);



endinterface


