// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 3007216                                                     // 
// Date         : 06/24/22                                                    // 
// File         : jb_intr_ctrl.sv                                               // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_intr_ctrl_if;
   logic                        pl_master_irq;
   logic                        pl_master_irq_mask;
   logic  [31:0]                pl_irq;
   logic  [31:0]                pl_irq_mask;
   logic  [31:0]                pl_irq_clear;
   logic  [7:0]                 adc_over_threshold1;
   logic  [7:0]                 adc_over_threshold2;
   logic  [7:0]                 adc_over_threshold1_mask;
   logic  [7:0]                 adc_over_threshold2_mask;
   logic  [7:0]                 adc_over_range;
   logic  [7:0]                 adc_over_voltage;
   logic  [3:0]                 ext_alarm;
   logic  [3:0]                 ext_alarm_mask;
   logic                        sfp0_los;
   logic                        sfp1_los;
   logic                        sfp0_tx_fault;
   logic                        sfp1_tx_fault;
   logic                        sfp0_los_mask;
   logic                        sfp1_los_mask;
   logic                        sfp0_tx_fault_mask;
   logic                        sfp1_tx_fault_mask;
   logic                        sfp0_detect_n;
   logic                        sfp1_detect_n;



modport ctrl (
output
        pl_master_irq_mask,
        pl_irq_mask,
        pl_irq_clear,
        adc_over_threshold1_mask,
        adc_over_threshold2_mask,
        ext_alarm_mask,
        sfp0_los_mask,
        sfp1_los_mask,
        sfp0_tx_fault_mask,
        sfp1_tx_fault_mask,

input
        pl_master_irq,
        pl_irq,
        adc_over_threshold1,
        adc_over_threshold2,
        adc_over_range,
        adc_over_voltage,
        ext_alarm,
        sfp0_los,
        sfp1_los,
        sfp0_tx_fault,
        sfp1_tx_fault,
        sfp0_detect_n,
        sfp1_detect_n
);


modport  blk (
input
        pl_master_irq_mask,
        pl_irq_mask,
        pl_irq_clear,
        adc_over_threshold1_mask,
        adc_over_threshold2_mask,
        ext_alarm_mask,
        sfp0_los_mask,
        sfp1_los_mask,
        sfp0_tx_fault_mask,
        sfp1_tx_fault_mask,

output
        pl_master_irq,
        pl_irq,
        adc_over_threshold1,
        adc_over_threshold2,
        adc_over_range,
        adc_over_voltage,
        ext_alarm,
        sfp0_los,
        sfp1_los,
        sfp0_tx_fault,
        sfp1_tx_fault,
        sfp0_detect_n,
        sfp1_detect_n
);



endinterface


