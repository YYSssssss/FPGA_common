// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 2918630                                                     // 
// Date         : 09/14/21                                                    // 
// File         : jb_oran_lphy_ctrl.sv                                          // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_oran_lphy_ctrl_devided_if;
   logic                        dl_swap_ifft;
   logic                        ul_swap_fft;
   logic                        prach_swap_fft;
   logic                        dl_iq_endianness;
   logic                        ul_iq_endianness;
   logic                        prach_iq_endianness;
   logic  [1:0]                 dl_ifft_gain_override;
   logic  [1:0]                 ul_fft_gain_override;
   logic                        dl_route_c0_to_c1;
   logic  [1:0]                 dl_lte_5g;
   logic  [1:0]                 dl_extended_cp;
   logic  [1:0][3:0]            dl_cc_numerology;
   logic  [1:0]                 dl_ifft_scaler_sign;
   logic  [1:0][3:0]            dl_ifft_scaler;
   logic  [1:0][15:0]           dl_ifft_fraction_gain;
   logic  [1:0]                 ul_lte_5g;
   logic  [1:0]                 ul_extended_cp;
   logic  [1:0][3:0]            ul_cc_numerology;
   logic  [1:0]                 ul_fft_scaler_sign;
   logic  [1:0][3:0]            ul_fft_scaler;
   logic  [1:0][15:0]           ul_fft_fraction_gain;
   logic  [1:0][3:0]            prach_en;
   logic  [1:0][3:0]            prach_format;
   logic  [1:0][15:0]           prach_cp;
   logic                        prach_use_sec_type3_freq_offset;
   logic  [1:0][31:0]           prach_car_nco_lsb;
   logic  [1:0][6:0]            prach_car_nco_msb;
   logic  [1:0]                 prach_car_nco_sign;
   logic  [1:0][3:0]            prach_gain_scaler_sign;
   logic  [1:0][3:0][3:0]       prach_gain_scaler;
   logic  [1:0][3:0][15:0]      prach_gain_fraction;
   logic                        ul_lphy_oran_clear;
   logic                        ul_lphy_oran_fifo_reset;
   logic                        prach_oran_clear;
   logic                        prach_oran_fifo_reset;
   logic                        lphy_oran_dbg_clear;
   logic                        lphy_oran_dbg_click;



modport ctrl (
output
        dl_swap_ifft,
        ul_swap_fft,
        prach_swap_fft,
        dl_iq_endianness,
        ul_iq_endianness,
        prach_iq_endianness,
        dl_ifft_gain_override,
        ul_fft_gain_override,
        dl_route_c0_to_c1,
        dl_lte_5g,
        dl_extended_cp,
        dl_cc_numerology,
        dl_ifft_scaler_sign,
        dl_ifft_scaler,
        dl_ifft_fraction_gain,
        ul_lte_5g,
        ul_extended_cp,
        ul_cc_numerology,
        ul_fft_scaler_sign,
        ul_fft_scaler,
        ul_fft_fraction_gain,
        prach_en,
        prach_format,
        prach_cp,
        prach_use_sec_type3_freq_offset,
        prach_car_nco_lsb,
        prach_car_nco_msb,
        prach_car_nco_sign,
        prach_gain_scaler_sign,
        prach_gain_scaler,
        prach_gain_fraction,
        ul_lphy_oran_clear,
        ul_lphy_oran_fifo_reset,
        prach_oran_clear,
        prach_oran_fifo_reset,
        lphy_oran_dbg_clear,
        lphy_oran_dbg_click
);


modport  lphy (
input
        dl_swap_ifft,
        ul_swap_fft,
        prach_swap_fft,
        dl_iq_endianness,
        ul_iq_endianness,
        prach_iq_endianness,
        dl_ifft_gain_override,
        ul_fft_gain_override,
        dl_route_c0_to_c1,
        dl_lte_5g,
        dl_extended_cp,
        dl_cc_numerology,
        dl_ifft_scaler_sign,
        dl_ifft_scaler,
        dl_ifft_fraction_gain,
        ul_lte_5g,
        ul_extended_cp,
        ul_cc_numerology,
        ul_fft_scaler_sign,
        ul_fft_scaler,
        ul_fft_fraction_gain,
        prach_en,
        prach_format,
        prach_cp,
        prach_use_sec_type3_freq_offset,
        prach_car_nco_lsb,
        prach_car_nco_msb,
        prach_car_nco_sign,
        prach_gain_scaler_sign,
        prach_gain_scaler,
        prach_gain_fraction,
        ul_lphy_oran_clear,
        ul_lphy_oran_fifo_reset,
        prach_oran_clear,
        prach_oran_fifo_reset,
        lphy_oran_dbg_clear,
        lphy_oran_dbg_click
);



endinterface


