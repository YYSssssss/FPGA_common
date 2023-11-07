// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : faizan                                                      // 
// Date         : 01/26/21                                                    // 
// File         : jb_hw_ctrl.sv                                                 // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_hw_ctrl_if;
   logic  [1:0]                 spi_bank_sel;
   logic  [7:0][2:0]            dac_dl_dfe_sel;
   logic  [7:0][2:0]            ul_dfe_rx_adc_sel;
   logic  [7:0][2:0]            ul_dfe_orx_adc_sel;
   logic                        rf_switch_override;
   logic                        orx_band_sel;
   logic  [2:0]                 orx_ant_sel;
   logic                        orx_path_sel;
   logic  [15:0]                ant_switch_delay;
   logic  [7:0]                 bypass_lna;
   logic  [7:0]                 pl_adcp_disable;
   logic  [7:0][6:0]            ps_rxdsa;
   logic  [7:0][6:0]            pl_rxdsa;
   logic                        pa_v_pgood;
   logic                        aisg_pgood;
   logic                        aisg_vdd_enn;
   logic                        aisg_vdd_sw_enn;
   logic                        uart1_de_ren;
   logic  [1:0]                 sfp_tx_en_n;
   logic  [1:0]                 sfp_tx_en_n_override;
   logic                        trigger;
   logic                        trigger_override;
   logic                        one_pps_source;
   logic  [1:0]                 pa_v_en;
   logic                        pa_ch12_dc_sw;
   logic                        pa_ch34_dc_sw;
   logic                        pa_ch56_dc_sw;
   logic                        pa_ch78_dc_sw;
   logic                        pa_ctrl12_reset;
   logic                        pa_ctrl12_dactrig;
   logic                        pa_ctrl12_adcrdy;
   logic                        pa_ctrl1_sleep;
   logic                        pa_ctrl2_sleep;
   logic                        pa_ctrl34_reset;
   logic                        pa_ctrl34_dactrig;
   logic                        pa_ctrl34_adcrdy;
   logic                        pa_ctrl3_sleep;
   logic                        pa_ctrl4_sleep;
   logic                        pa_ctrl56_reset;
   logic                        pa_ctrl56_dactrig;
   logic                        pa_ctrl56_adcrdy;
   logic                        pa_ctrl5_sleep;
   logic                        pa_ctrl6_sleep;
   logic                        pa_ctrl78_reset;
   logic                        pa_ctrl78_dactrig;
   logic                        pa_ctrl78_adcrdy;
   logic                        pa_ctrl7_sleep;
   logic                        pa_ctrl8_sleep;
   logic  [31:0]                rf_overdrive_thresh;
   logic  [20:0]                rf_overdrive_avg_per;
   logic  [7:0][31:0]           rf_overdrive_tssi;
   logic  [16:0]                rf_slew_limit;
   logic  [15:0]                rf_slew_duration_limit;
   logic  [7:0]                 disable_rf_srp;
   logic  [7:0]                 disable_rf_odp;
   logic                        cold_rst_n_mask;
   logic                        cold_rst_n;



modport ctrl (
output
        spi_bank_sel,
        dac_dl_dfe_sel,
        ul_dfe_rx_adc_sel,
        ul_dfe_orx_adc_sel,
        rf_switch_override,
        orx_band_sel,
        orx_ant_sel,
        orx_path_sel,
        ant_switch_delay,
        bypass_lna,
        pl_adcp_disable,
        ps_rxdsa,
        aisg_vdd_enn,
        aisg_vdd_sw_enn,
        uart1_de_ren,
        sfp_tx_en_n,
        sfp_tx_en_n_override,
        trigger,
        trigger_override,
        one_pps_source,
        pa_v_en,
        pa_ch12_dc_sw,
        pa_ch34_dc_sw,
        pa_ch56_dc_sw,
        pa_ch78_dc_sw,
        pa_ctrl12_reset,
        pa_ctrl12_dactrig,
        pa_ctrl12_adcrdy,
        pa_ctrl1_sleep,
        pa_ctrl2_sleep,
        pa_ctrl34_reset,
        pa_ctrl34_dactrig,
        pa_ctrl34_adcrdy,
        pa_ctrl3_sleep,
        pa_ctrl4_sleep,
        pa_ctrl56_reset,
        pa_ctrl56_dactrig,
        pa_ctrl56_adcrdy,
        pa_ctrl5_sleep,
        pa_ctrl6_sleep,
        pa_ctrl78_reset,
        pa_ctrl78_dactrig,
        pa_ctrl78_adcrdy,
        pa_ctrl7_sleep,
        pa_ctrl8_sleep,
        rf_overdrive_thresh,
        rf_overdrive_avg_per,
        rf_slew_limit,
        rf_slew_duration_limit,
        disable_rf_srp,
        disable_rf_odp,
        cold_rst_n_mask,
        cold_rst_n,

input
        pl_rxdsa,
        pa_v_pgood,
        aisg_pgood,
        rf_overdrive_tssi
);


modport  rf_ctrl (
input
        spi_bank_sel,
        rf_switch_override,
        orx_band_sel,
        orx_ant_sel,
        orx_path_sel,
        ant_switch_delay,
        bypass_lna,
        pl_adcp_disable,
        ps_rxdsa,
        aisg_vdd_enn,
        aisg_vdd_sw_enn,
        uart1_de_ren,
        sfp_tx_en_n,
        sfp_tx_en_n_override,
        trigger,
        trigger_override,
        one_pps_source,
        pa_v_en,
        pa_ch12_dc_sw,
        pa_ch34_dc_sw,
        pa_ch56_dc_sw,
        pa_ch78_dc_sw,
        pa_ctrl12_reset,
        pa_ctrl12_dactrig,
        pa_ctrl12_adcrdy,
        pa_ctrl1_sleep,
        pa_ctrl2_sleep,
        pa_ctrl34_reset,
        pa_ctrl34_dactrig,
        pa_ctrl34_adcrdy,
        pa_ctrl3_sleep,
        pa_ctrl4_sleep,
        pa_ctrl56_reset,
        pa_ctrl56_dactrig,
        pa_ctrl56_adcrdy,
        pa_ctrl5_sleep,
        pa_ctrl6_sleep,
        pa_ctrl78_reset,
        pa_ctrl78_dactrig,
        pa_ctrl78_adcrdy,
        pa_ctrl7_sleep,
        pa_ctrl8_sleep,
        rf_overdrive_thresh,
        rf_overdrive_avg_per,
        rf_slew_limit,
        rf_slew_duration_limit,
        disable_rf_srp,
        disable_rf_odp,
        cold_rst_n_mask,
        cold_rst_n
);

modport  hw_stat (
output
        pl_rxdsa,
        pa_v_pgood,
        aisg_pgood,
        rf_overdrive_tssi
);

modport hw_ctrl_rfdc (
input
        dac_dl_dfe_sel,
        ul_dfe_rx_adc_sel,
        ul_dfe_orx_adc_sel
);

endinterface


