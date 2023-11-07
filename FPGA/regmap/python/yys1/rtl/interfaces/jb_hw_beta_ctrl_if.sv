// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : begum                                                       // 
// Date         : 11/22/20                                                    // 
// File         : jb_hw_ctrl.sv                                                 // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_hw_ctrl_if;
   logic  [3:0][1:0]            dac_dl_dfe_sel;
   logic  [3:0][2:0]            ul_dfe_rx_adc_sel;
   logic  [3:0][2:0]            ul_dfe_orx_adc_sel;
   logic                        rf_switch_override;
   logic  [5:0]                 rf_switch_n;
   logic  [5:0]                 rf_switch_en_n;
   logic  [2:0]                 orx_ant_sel;
   logic                        orx_path_sel;
   logic  [15:0]                ant_switch_delay;
   logic  [3:0]                 bypass_lna;
   logic  [3:0][6:0]            ps_rxdsa;
   logic  [3:0][6:0]            pl_rxdsa;
   logic  [3:0]                 pl_adcp_disable;
   logic                        pa_v_en;
   logic                        pa_ch12_dc_sw;
   logic                        pa_ch34_dc_sw;
   logic                        pa_ctrl1_reset;
   logic                        pa_ctrl2_reset;
   logic                        pa_ctrl1_sleep;
   logic                        pa_ctrl2_sleep;
   logic                        pa_ctrl3_sleep;
   logic                        pa_ctrl4_sleep;
   logic  [6:0]                 spi_slave0_rxdata;
   logic  [6:0]                 spi_slave1_rxdata;
   logic                        spi_bank_sel;
   logic  [1:0]                 sfp_pwr_en_n;
   logic  [1:0]                 sfp_tx_en_n;
   logic  [3:0]                 sfp_rs;
   logic  [1:0]                 sfp_tx_en_n_override;
   logic                        aisg_vdd_enn;
   logic                        aisg_vdd_sw_enn;
   logic                        aisg_direction;
   logic                        aisg_pgood;
   logic                        clk_testout_ctrl;
   logic  [31:0]                rf_overdrive_thresh;
   logic  [20:0]                rf_overdrive_avg_per;
   logic  [3:0][31:0]           rf_overdrive_tssi;
   logic  [16:0]                rf_slew_limit;
   logic  [15:0]                rf_slew_duration_limit;
   logic  [3:0]                 disable_rf_srp;
   logic  [3:0]                 disable_rf_odp;
   logic                        cold_rst_n_mask;
   logic                        cold_rst_n;
   logic  [31:0]                pl_debug0;
   logic  [31:0]                pl_debug1;



modport ctrl (
output
        dac_dl_dfe_sel,
        ul_dfe_rx_adc_sel,
        ul_dfe_orx_adc_sel,
        rf_switch_override,
        rf_switch_n,
        rf_switch_en_n,
        orx_ant_sel,
        orx_path_sel,
        ant_switch_delay,
        bypass_lna,
        ps_rxdsa,
        pl_adcp_disable,
        pa_v_en,
        pa_ch12_dc_sw,
        pa_ch34_dc_sw,
        pa_ctrl1_reset,
        pa_ctrl2_reset,
        pa_ctrl1_sleep,
        pa_ctrl2_sleep,
        pa_ctrl3_sleep,
        pa_ctrl4_sleep,
        spi_bank_sel,
        sfp_pwr_en_n,
        sfp_tx_en_n,
        sfp_rs,
        sfp_tx_en_n_override,
        aisg_vdd_enn,
        aisg_vdd_sw_enn,
        aisg_direction,
        clk_testout_ctrl,
        rf_overdrive_thresh,
        rf_overdrive_avg_per,
        rf_slew_limit,
        rf_slew_duration_limit,
        disable_rf_srp,
        disable_rf_odp,
        cold_rst_n_mask,
        cold_rst_n,
        pl_debug0,
        pl_debug1,

input
        pl_rxdsa,
        spi_slave0_rxdata,
        spi_slave1_rxdata,
        aisg_pgood,
        rf_overdrive_tssi
);


modport  rf_ctrl (
input
        rf_switch_override,
        rf_switch_n,
        rf_switch_en_n,
        orx_ant_sel,
        orx_path_sel,
        ant_switch_delay,
        bypass_lna,
        ps_rxdsa,
        pl_adcp_disable,
        pa_v_en,
        pa_ch12_dc_sw,
        pa_ch34_dc_sw,
        pa_ctrl1_reset,
        pa_ctrl2_reset,
        pa_ctrl1_sleep,
        pa_ctrl2_sleep,
        pa_ctrl3_sleep,
        pa_ctrl4_sleep,
        spi_bank_sel,
        sfp_pwr_en_n,
        sfp_tx_en_n,
        sfp_rs,
        sfp_tx_en_n_override,
        aisg_vdd_enn,
        aisg_vdd_sw_enn,
        aisg_direction,
        clk_testout_ctrl,
        rf_overdrive_thresh,
        rf_overdrive_avg_per,
        rf_slew_limit,
        rf_slew_duration_limit,
        disable_rf_srp,
        disable_rf_odp,
        cold_rst_n_mask,
        cold_rst_n,
        pl_debug0,
        pl_debug1
);

modport  hw_stat (
output
        pl_rxdsa,
        spi_slave0_rxdata,
        spi_slave1_rxdata,
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


