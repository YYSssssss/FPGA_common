////////////////////////////////////////////////////////////////////
////  File Name : jb_prach_dfe_ctrl_if.sv
///// Author    : A. Siegel
///// Date      : 8/17/2019
///// Description  : prach DFE COntrol
////////////////////////////////////////////////////////////////////
interface jb_prach_dfe_ctrl_if#( 
    parameter N_CARRIERS  = 2, 
    parameter N_ANTENNAS   = 4, //power of 2, multiple of 8
    parameter NCO_COEF_WIDTH =40
);


logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0] prach_stream_en;
   
   logic [N_CARRIERS-1:0] [1:0]	 prach_car_bw; // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
   
   logic  [3:0]              prach_iq_sample_width;  // Sample precision per dimension I or Q, Final precision = iq_sample_precision+5 0 ">5 bits,  1 -> 6 bits,   2->7 bits, 3 ->8bits,  4->9 bits,  5->10 bits, 6-> 11 bits,  7->12 bits,  8 ->13 bits, 9->14 bits,  4’d10- 15 bits,11->16bits,  12->17 bits, 13->18 bits,14-> 19bits, 15->20 bits
   
   logic  [2:0]              prach_iq_sample_pad;  // Number of padding bits per dimension (I or Q) Values from 0-7
   logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]	 prach_car_nco;
   
   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0]     prach_stream_gain_scaler_sign;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0] [3:0]    prach_stream_gain_scaler;  // Carrier0 in Antenna 0 Path  Gain Register
   logic  [N_CARRIERS-1:0] [N_ANTENNAS-1:0] [15:0]    prach_stream_gain_fraction;  // Carrier0 in Antenna 0 Path  Gain Register

   logic  [N_ANTENNAS-1:0]         prach_ant_gain_scaler_sign;  // Antenna0 Path gain Before CFR
   logic  [N_ANTENNAS-1:0] [3:0]   prach_ant_gain_scaler;  // Antenna0 Path gain Before CFR
   logic  [N_ANTENNAS-1:0] [15:0]  prach_ant_gain_fraction;  // Antenna0 Path gain Before CFR

    logic  [20:0]              prach_rssi_num_15p36_tics;  // Number of tics @15.36Mhz Clock, for both RSSI & WRSSI, MAX_RSSI_TICS = 21'h177000, After this many cycles the rssi is loade dinto the register
   
 
   
   logic  [N_CARRIERS-1:0] [2:0]   prach_car_stg0_coef_set_sel;  // This value is used to index memory address to select that particprachar set for the coefficients in case of reloadable coefficients, (address=prach_stage0_coef_set*0x80)
   logic  [N_CARRIERS-1:0] [2:0]   prach_car_stg1_coef_set_sel;  // This value is used to index memory address to select that particprachar set for the coefficients in case of reloadable coefficients, (address=prach_stage0_coef_set*0x80)
   logic  [2:0]              prach_car_stg2_coef_set_sel;  // This value is used to index memory address to select that particprachar set for the coefficients in case of reloadable coefficients, (address=prach_stage1_coef_set*0x80)
   logic  [N_CARRIERS-1:0] [2:0]   prach_car_stg3_coef_set_sel;  // This value is used to index memory address to select that particprachar set for the coefficients in case of reloadable coefficients, (address=prach_stage0_coef_set*0x80)
  
   logic [N_CARRIERS-1:0]         prach_reload_car_coef_trig;  // 1: Start reloading coefficients Only set this bit if there is any change in the coefficients. When read this bit will return 0. Write to this bit after all the configurations are done and if there are any changes in the coefficients.

   logic 			  prach_ant_int_frac_delay_trig;
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0] [6:0]	  prach_int_delay;
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0] [15:0]	  prach_frac_delay;
   

modport ctrl (
output  prach_stream_en, prach_car_bw,  prach_iq_sample_width,  prach_iq_sample_pad,  prach_car_nco,  prach_stream_gain_scaler_sign, prach_stream_gain_scaler, prach_stream_gain_fraction,    prach_rssi_num_15p36_tics, prach_ant_gain_scaler_sign, prach_ant_gain_scaler, prach_ant_gain_fraction,  prach_car_stg0_coef_set_sel,  prach_car_stg1_coef_set_sel,  prach_car_stg2_coef_set_sel,  prach_car_stg3_coef_set_sel, prach_reload_car_coef_trig,prach_int_delay, prach_frac_delay,prach_ant_int_frac_delay_trig 
);


modport prach_dfe (
input  prach_stream_en, prach_car_bw,  prach_iq_sample_width,  prach_iq_sample_pad,  prach_car_nco,  prach_stream_gain_scaler_sign, prach_stream_gain_scaler, prach_stream_gain_fraction,   prach_ant_gain_scaler_sign, prach_ant_gain_scaler, prach_ant_gain_fraction, prach_rssi_num_15p36_tics,  prach_car_stg0_coef_set_sel,  prach_car_stg1_coef_set_sel,  prach_car_stg2_coef_set_sel,  prach_car_stg3_coef_set_sel, prach_reload_car_coef_trig,prach_ant_int_frac_delay_trig, prach_int_delay, prach_frac_delay
 );

 modport lat (
     input prach_car_bw
 );
 

endinterface
 