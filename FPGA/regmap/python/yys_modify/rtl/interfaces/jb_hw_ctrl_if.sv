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
   logic                        cold_rst_n;
   logic                        cold_rst_n_mask;
   logic  [3:0]                 spi_bank_sel;
   logic  [7:0][2:0]            dac_dl_dfe_sel;
   logic  [7:0][2:0]            ul_dfe_rx_adc_sel;
   logic  [7:0][2:0]            ul_dfe_orx_adc_sel;
   logic                        rf_switch_override;
   logic  [2:0]                 orx_ant_sel;
   logic                        orx_path_sel;
   logic                        rx_tx_mode_sel;
   logic  [15:0]                ant_switch_delay;
   logic                        tx_ant_cal_en;
   logic                        rx_ant_cal_en;
   logic  [7:0]                 bypass_lna;
   logic  [7:0]                 pl_adcp_disable;
   logic  [7:0][6:0]            ps_rxdsa;
   logic  [7:0][6:0]            pl_rxdsa;
   logic  [1:0]                 pa_resetn;
   logic  [7:0]                 tdd_pa_sleep;
   logic  [7:0]                 en_pa_pwr;
   logic  [7:0]                 pa_v_pgood;
   logic                        aisg_pgood;
   logic                        aisg_vdd_enn;
   logic                        aisg_vdd_sw_enn;
   logic                        uart1_de_ren;
   logic  [1:0]                 sfp_tx_en_n;
   logic  [1:0]                 sfp_tx_en_n_override;
   logic  [1:0]                 sfp_rs;
   logic  [1:0]                 sfp_led;
   logic                        trigger;
   logic                        trigger_override;
   logic                        one_pps_source;
   logic  [31:0]                rf_overdrive_thresh;
   logic  [20:0]                rf_overdrive_avg_per;
   logic  [7:0][31:0]           rf_overdrive_tssi;
   logic  [16:0]                rf_slew_limit;
   logic  [15:0]                rf_slew_duration_limit;
   logic  [7:0]                 disable_rf_srp;
   logic  [7:0]                 disable_rf_odp;
   logic                        psu_alarm_enable;
   
modport ctrl (
output
        cold_rst_n,
        cold_rst_n_mask,
        spi_bank_sel,
        dac_dl_dfe_sel,
        ul_dfe_rx_adc_sel,
        ul_dfe_orx_adc_sel,
        rf_switch_override,
        orx_ant_sel,
        orx_path_sel,
        rx_tx_mode_sel,
        ant_switch_delay,
        tx_ant_cal_en,
        rx_ant_cal_en,
        bypass_lna,
        pl_adcp_disable,
        ps_rxdsa,
        pa_resetn,
        tdd_pa_sleep,
        en_pa_pwr,
        aisg_vdd_enn,
        aisg_vdd_sw_enn,
        uart1_de_ren,
        sfp_tx_en_n,
        sfp_tx_en_n_override,
        sfp_rs,
        sfp_led,
        trigger,
        trigger_override,
        one_pps_source,
        rf_overdrive_thresh,
        rf_overdrive_avg_per,
        rf_slew_limit,
        rf_slew_duration_limit,
        disable_rf_srp,
        disable_rf_odp,
        psu_alarm_enable,

input
        pl_rxdsa,
        pa_v_pgood,
        aisg_pgood,
        rf_overdrive_tssi
);


modport  hw_ctrl (
input
        cold_rst_n,
        cold_rst_n_mask,
        spi_bank_sel,
        dac_dl_dfe_sel,
        ul_dfe_rx_adc_sel,
        ul_dfe_orx_adc_sel,
        rf_switch_override,
        orx_ant_sel,
        orx_path_sel,
        rx_tx_mode_sel,
        ant_switch_delay,
        tx_ant_cal_en,
        rx_ant_cal_en,
        bypass_lna,
        pl_adcp_disable,
        ps_rxdsa,
        pa_resetn,
        tdd_pa_sleep,
        en_pa_pwr,
        aisg_vdd_enn,
        aisg_vdd_sw_enn,
        uart1_de_ren,
        sfp_tx_en_n,
        sfp_tx_en_n_override,
        sfp_rs,
        sfp_led,
        trigger,
        trigger_override,
        one_pps_source,
        rf_overdrive_thresh,
        rf_overdrive_avg_per,
        rf_slew_limit,
        rf_slew_duration_limit,
        disable_rf_srp,
        disable_rf_odp,
        psu_alarm_enable
);

modport hw_stat (
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


