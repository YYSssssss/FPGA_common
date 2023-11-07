// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : sbegum                                                      // 
// Date         : 11/01/20                                                    // 
// File         : jb_cmn_ctrl.sv                                                // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_cmn_ctrl_devided_if;
   logic  [15:0]                hw_id;
   logic  [15:0]                soft_reset;
   logic  [20:0]                xssi_num_15p36_tics;
   logic  [1:0]                 frm_mrkr_gen_enable;
   logic  [1:0]                 frm_mrkr_gen_trigger;
   logic  [1:0][3:0]            dl_stream_en;
   logic  [1:0][3:0]            dl_car_bw;
   logic  [1:0][3:0]            ul_stream_en;
   logic  [1:0][3:0]            ul_car_bw;
   logic  [1:0][31:0]           dl_frm_mrkr_cntr_ns;
   logic  [1:0][31:0]           ul_frm_mrkr_cntr_ns;
   logic  [1:0][31:0]           prach_frm_mrkr_cntr_ns;
   logic  [31:0]                com_scratch;


modport ctrl (
output
        hw_id,
        soft_reset,
        xssi_num_15p36_tics,
        frm_mrkr_gen_enable,
        frm_mrkr_gen_trigger,
        dl_stream_en,
        dl_car_bw,
        ul_stream_en,
        ul_car_bw,
        dl_frm_mrkr_cntr_ns,
        ul_frm_mrkr_cntr_ns,
        prach_frm_mrkr_cntr_ns,
        com_scratch
);

modport cmd_dfe (
input
        hw_id,
        soft_reset,
        dl_stream_en,
        dl_car_bw,
        ul_stream_en,
        ul_car_bw		
);

modport xssi (
input 
        xssi_num_15p36_tics
 );
 
modport timers (
input 
        xssi_num_15p36_tics
 );
 
modport  lphy (
input   dl_stream_en,
        dl_car_bw,
        ul_stream_en,
        ul_car_bw, 
        frm_mrkr_gen_enable, 
	    frm_mrkr_gen_trigger,
        dl_frm_mrkr_cntr_ns,
        ul_frm_mrkr_cntr_ns,
        prach_frm_mrkr_cntr_ns
);
endinterface


