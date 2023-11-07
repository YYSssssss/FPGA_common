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


interface jb_cmn_ctrl_if;
   logic  [15:0]                hw_id;
   logic  [15:0]                soft_reset;
   logic  [20:0]                xssi_num_15p36_tics;
   logic  [1:0]                 frm_mrkr_gen_enable;
   logic  [1:0]                 frm_mrkr_gen_trigger;
   logic  [1:0][3:0]            dl_stream_en;
   logic  [1:0][3:0]            dl_car_bw;
   logic  [3:0]                 dl_iq_sample_width;
   logic  [2:0]                 dl_iq_sample_pad;
   logic  [1:0][3:0]            ul_stream_en;
   logic  [1:0][3:0]            ul_car_bw;
   logic  [3:0]                 ul_iq_sample_width;
   logic  [2:0]                 ul_iq_sample_pad;
   logic  [1:0][31:0]           dl_frm_mrkr_cntr_ns;
   logic  [1:0][31:0]           ul_frm_mrkr_cntr_ns;
   logic  [1:0][31:0]           prach_frm_mrkr_cntr_ns;
   logic [31:0]                 t2a;
   logic [31:0]                 ta3;


modport ctrl (
output
        hw_id,
        soft_reset,
        xssi_num_15p36_tics,
        frm_mrkr_gen_enable,
        frm_mrkr_gen_trigger,
        dl_stream_en,
        dl_car_bw,
        dl_iq_sample_width,
        dl_iq_sample_pad,
        ul_stream_en,
        ul_car_bw,
        ul_iq_sample_width,
        ul_iq_sample_pad,
        dl_frm_mrkr_cntr_ns,
        ul_frm_mrkr_cntr_ns,
        prach_frm_mrkr_cntr_ns
);


modport  dfe (
input
        hw_id,
        soft_reset,
        dl_stream_en,
        dl_car_bw,
        dl_iq_sample_width,
        dl_iq_sample_pad,
        ul_stream_en,
        ul_car_bw,
        ul_iq_sample_width,
        ul_iq_sample_pad
);

 modport lat (
     input dl_car_bw, 
           ul_car_bw,
     output t2a,
            ta3
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
  input  dl_stream_en,
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


