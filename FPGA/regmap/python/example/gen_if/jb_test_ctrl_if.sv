// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 3007216                                                     // 
// Date         : 06/24/22                                                    // 
// File         : jb_test_ctrl.sv                                               // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_test_ctrl_if;
   logic                        rfbuf_trig_align_en;
   logic  [19:0]                dfe_adcdac_test_num_samples;
   logic                        dfe_adcdac_test_mode;
   logic  [2:0]                 dfe_adcdac_test_path_select;
   logic                        dfe_adcdac_test_trigger;
   logic                        dfe_adcdac_test_reset;
   logic  [1:0]                 uldfe_to_dldfe_lpbk;
   logic  [1:0]                 fh_dbg_mode;
   logic  [1:0]                 orx_to_uldfe_en;
   logic  [1:0]                 rx0_to_all_ul_paths;
   logic  [4:0]                 rx_antenna_dgb_sel;
   logic                        adc_invert_q;
   logic  [19:0]                dl_test_mode_num_samples;
   logic  [1:0]                 dl_test_ants_sel;
   logic                        dl_test_store_en;
   logic                        dl_test_mode;
   logic                        dl_test_mode_en;
   logic                        dl_test_mode_trigger;
   logic  [7:0][31:0]           ant_tssi;
   logic  [7:0][31:0]           ul_ant_wrssi;
   logic  [7:0][31:0]           orx_wrssi;
   logic  [7:0][31:0]           debug_rw;
   logic  [7:0][31:0]           debug_ro;
   logic  [31:0]                vio_config_ul;
   logic  [31:0]                vio_config_dl;
   logic  [31:0]                ila_config_adc;
   logic  [31:0]                ila_config_dac;



modport ctrl (
output
        rfbuf_trig_align_en,
        dfe_adcdac_test_num_samples,
        dfe_adcdac_test_mode,
        dfe_adcdac_test_path_select,
        dfe_adcdac_test_trigger,
        dfe_adcdac_test_reset,
        uldfe_to_dldfe_lpbk,
        fh_dbg_mode,
        orx_to_uldfe_en,
        rx0_to_all_ul_paths,
        rx_antenna_dgb_sel,
        adc_invert_q,
        dl_test_mode_num_samples,
        dl_test_ants_sel,
        dl_test_store_en,
        dl_test_mode,
        dl_test_mode_en,
        dl_test_mode_trigger,
        debug_rw,
        vio_config_ul,
        vio_config_dl,
        ila_config_adc,
        ila_config_dac,

input
        ant_tssi,
        ul_ant_wrssi,
        orx_wrssi,
        debug_ro
);


modport  blk (
input
        rfbuf_trig_align_en,
        dfe_adcdac_test_num_samples,
        dfe_adcdac_test_mode,
        dfe_adcdac_test_path_select,
        dfe_adcdac_test_trigger,
        dfe_adcdac_test_reset,
        uldfe_to_dldfe_lpbk,
        fh_dbg_mode,
        orx_to_uldfe_en,
        rx0_to_all_ul_paths,
        rx_antenna_dgb_sel,
        adc_invert_q,
        dl_test_mode_num_samples,
        dl_test_ants_sel,
        dl_test_store_en,
        dl_test_mode,
        dl_test_mode_en,
        dl_test_mode_trigger,
        debug_rw,
        vio_config_ul,
        vio_config_dl,
        ila_config_adc,
        ila_config_dac,

output
        ant_tssi,
        ul_ant_wrssi,
        orx_wrssi,
        debug_ro
);



endinterface


