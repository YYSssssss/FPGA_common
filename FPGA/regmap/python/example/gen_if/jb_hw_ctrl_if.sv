// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 3007216                                                     // 
// Date         : 06/24/22                                                    // 
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
   logic  [0:0][2:0]            orx_ant_sel;
   logic  [0:0]                 orx_path_sel;
   logic  [15:0]                ant_switch_delay;
   logic                        tx_ant_cal_en;
   logic                        rx_ant_cal_en;
   logic                        tx_gainblock_en_n;
   logic                        rx_gainblock_en_n;
   logic  [7:0]                 bypass_lna;
   logic  [7:0]                 pl_adcp_disable;
   logic  [7:0][6:0]            ps_rxdsa;
   logic  [7:0][6:0]            pl_rxdsa;
   logic  [1:0]                 pa_lna_en;
   logic                        pa_resetn;
   logic  [7:0]                 tdd_ctrl_pa;
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
        ant_switch_delay,
        tx_ant_cal_en,
        rx_ant_cal_en,
        tx_gainblock_en_n,
        rx_gainblock_en_n,
        bypass_lna,
        pl_adcp_disable,
        ps_rxdsa,
        pa_lna_en,
        pa_resetn,
        tdd_ctrl_pa,
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

input
        pl_rxdsa,
        pa_v_pgood,
        aisg_pgood
);


modport  blk (
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
        ant_switch_delay,
        tx_ant_cal_en,
        rx_ant_cal_en,
        tx_gainblock_en_n,
        rx_gainblock_en_n,
        bypass_lna,
        pl_adcp_disable,
        ps_rxdsa,
        pa_lna_en,
        pa_resetn,
        tdd_ctrl_pa,
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

output
        pl_rxdsa,
        pa_v_pgood,
        aisg_pgood
);



endinterface


