// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : M. Faizan                                                   // 
// Date         : 02/16/21                                                    // 
// File         : jb_dl_dfe_rfc_if.sv                                         // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_dl_dfe_rfc_if;
   logic  [3:0]                 rf_overdrive_mute;
   logic  [3:0]                 rf_slew_rate_irq;
   logic  [3:0]                 rf_slew_rate_irq_mask;
   logic  [3:0]                 rf_slew_rate_irq_clr;
   logic  [3:0][31:0]           rf_slew_fault_count;
   logic  [3:0]                 rf_slew_fault_clr;

   logic  [16:0]                rf_slew_limit;
   logic  [15:0]                rf_slew_duration_limit;
   logic  [3:0]                 disable_rf_srp;

modport dl_dfe (
input
        rf_overdrive_mute,
        rf_slew_rate_irq_mask,
        rf_slew_rate_irq_clr,
        rf_slew_fault_clr,
        rf_slew_limit,
        rf_slew_duration_limit,
        disable_rf_srp,
output
        rf_slew_rate_irq,
        rf_slew_fault_count
);

endinterface


