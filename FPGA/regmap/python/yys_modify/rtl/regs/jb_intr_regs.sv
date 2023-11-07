
module jb_intr_regs ( 
    input                           clk, 
    input                           srst,  
    jb_axi_regs_if.slave            IFP_axi_rw, 
    jb_intr_ctrl_if.ctrl         IFP_intr_ctrl
);



////////////////Register Field Declarations//////////////////

   logic                     FPGA_REG_MASTER_IRQ_STATUS_irq_pl_master;
  // Self clearing. 1 = A sticky interrupt is high in the PL interrupt register.
   logic                     FPGA_REG_MASTER_IRQ_MASK_irq_pl_master_mask;
  // 
   logic                     FPGA_REG_PL_IRQ_STATUS_irq_reset_request;
  // Sticky. Reset request to software before cold reset is asserted
   logic                     FPGA_REG_PL_IRQ_STATUS_irq_rfdc;
  // Sticky - Interrupt from RF Data Converter
   logic                     FPGA_REG_PL_IRQ_STATUS_irq_adc_thresholds;
  // Sticky - Composite interrupt for adcXZ_over_threshold1-2 from all ADCs (except ORX ADCs). See FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER
   logic                     FPGA_REG_PL_IRQ_STATUS_irq_ext_alarms;
  // Sticky - SPF status (i.e. LOS, TX Fault, etc.). See FPGA_REG_SFP_STATUS_REGISTER
   logic                     FPGA_REG_PL_IRQ_STATUS_irq_sfp_faults;
  // Sticky - Customer alarms. See FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER
   logic                     FPGA_REG_PL_IRQ_STATUS_irq_psu_alarms;
  // Sticky - PSU Alarm
   logic                     FPGA_REG_PL_IRQ_STATUS_irq_debug;
  // Sticky - For debug purpose only
   logic                     FPGA_REG_PL_IRQ_MASK_mask_reset_request;
  // Write 1 to mask corresponding interrupt status bit
   logic                     FPGA_REG_PL_IRQ_MASK_mask_rfdc;
  // Write 1 to mask corresponding interrupt status bit
   logic                     FPGA_REG_PL_IRQ_MASK_mask_adc_thresholds;
  // Write 1 to mask corresponding interrupt status bit
   logic                     FPGA_REG_PL_IRQ_MASK_mask_ext_alarms;
  // Write 1 to mask corresponding interrupt status bit
   logic                     FPGA_REG_PL_IRQ_MASK_mask_sfp_faults;
  // Write 1 to mask corresponding interrupt status bit
   logic                     FPGA_REG_PL_IRQ_MASK_mask_psu_alarms;
  // Write 1 to mask corresponding interrupt status bit
   logic                     FPGA_REG_PL_IRQ_MASK_mask_debug;
  // Write 1 to mask corresponding interrupt status bit
   logic                     FPGA_REG_PL_IRQ_CLEAR_clear_reset_request;
  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
   logic                     FPGA_REG_PL_IRQ_CLEAR_clear_rfdc;
  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
   logic                     FPGA_REG_PL_IRQ_CLEAR_clear_adc_thresholds;
  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
   logic                     FPGA_REG_PL_IRQ_CLEAR_clear_ext_alarms;
  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
   logic                     FPGA_REG_PL_IRQ_CLEAR_clear_sfp_faults;
  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
   logic                     FPGA_REG_PL_IRQ_CLEAR_clear_psu_alarms;
  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
   logic                     FPGA_REG_PL_IRQ_CLEAR_clear_debug;
  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_01_over_threshold1;
  // ADC0 (Bank 224 ADC01) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_23_over_threshold1;
  // ADC1 (Bank 224 ADC23) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_01_over_threshold1;
  // ADC2 (Bank 225 ADC01) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_23_over_threshold1;
  // ADC3 (Bank 225 ADC23) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_01_over_threshold1;
  // ADC4 (Bank 226 ADC01) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_23_over_threshold1;
  // ADC5 (Bank 226 ADC23) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_01_over_threshold1;
  // ADC6 (Bank 227 ADC01) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_23_over_threshold1;
  // ADC7 (Bank 227 ADC23) Threshold1 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_01_over_threshold2;
  // ADC0 (Bank 224 ADC01) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_23_over_threshold2;
  // ADC1 (Bank 224 ADC23) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_01_over_threshold2;
  // ADC2 (Bank 225 ADC01) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_23_over_threshold2;
  // ADC3 (Bank 225 ADC23) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_01_over_threshold2;
  // ADC4 (Bank 226 ADC01) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_23_over_threshold2;
  // ADC5 (Bank 226 ADC23) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_01_over_threshold2;
  // ADC6 (Bank 227 ADC01) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_23_over_threshold2;
  // ADC7 (Bank 227 ADC23) Threshold2 Interrupt Status
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold1_mask;
  // ADC0 (Bank 224 ADC01) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold1_mask;
  // ADC1 (Bank 224 ADC23) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold1_mask;
  // ADC2 (Bank 225 ADC01) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold1_mask;
  // ADC3 (Bank 225 ADC23) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold1_mask;
  // ADC4 (Bank 226 ADC01) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold1_mask;
  // ADC5 (Bank 226 ADC23) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold1_mask;
  // ADC6 (Bank 227 ADC01) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold1_mask;
  // ADC7 (Bank 227 ADC23) Threshold1 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold2_mask;
  // ADC0 (Bank 224 ADC01) Threshold2 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold2_mask;
  // ADC1 (Bank 224 ADC23) Threshold2 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold2_mask;
  // ADC2 (Bank 225 ADC01) Threshold2 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold2_mask;
  // ADC3 (Bank 225 ADC23) Threshold2 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold2_mask;
  // ADC4 (Bank 226 ADC01) Threshold2 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold2_mask;
  // ADC5 (Bank 226 ADC23) Threshold2 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold2_mask;
  // ADC6 (Bank 227 ADC01) Threshold2 Interrupt Mask
   logic                     FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold2_mask;
  // ADC7 (Bank 227 ADC23) Threshold2 Interrupt Mask
   logic  [7:0]              FPGA_REG_ADC_REAL_TIME_STATUS_REGISTER_adc_over_range;
  // Over Range, Bit 0:ADC0 (Bank 224 ADC01), 1: ADC1 (Bank 224 ADC23), 2:ADC2 (Bank 225 ADC 01), ...
   logic  [7:0]              FPGA_REG_ADC_REAL_TIME_STATUS_REGISTER_adc_over_voltage;
  // Over Voltage, Bit 0:ADC0 (Bank 224 ADC01), 1: ADC1 (Bank 224 ADC23), 2:ADC2 (Bank 225 ADC 01), 
   logic                     FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_0;
  // External Alarm Interrupt Status
   logic                     FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_1;
  // 
   logic                     FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_2;
  // 
   logic                     FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_3;
  // 
   logic                     FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_0_mask;
  // External Alarm Interrupt Masks
   logic                     FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_1_mask;
  // 
   logic                     FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_2_mask;
  // 
   logic                     FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_3_mask;
  // 
   logic                     FPGA_REG_SFP_STATUS_REGISTER_sfp0_los;
  // SFP0 LOS
   logic                     FPGA_REG_SFP_STATUS_REGISTER_sfp1_los;
  // SFP1 LOS
   logic                     FPGA_REG_SFP_STATUS_REGISTER_sfp0_tx_fault;
  // SFP0 TX FAULT
   logic                     FPGA_REG_SFP_STATUS_REGISTER_sfp1_tx_fault;
  // SFP1 TX FAULT
   logic                     FPGA_REG_SFP_MASK_REGISTER_sfp0_los_mask;
  // SFP0 los mask
   logic                     FPGA_REG_SFP_MASK_REGISTER_sfp1_los_mask;
  // SFP1 los mask
   logic                     FPGA_REG_SFP_MASK_REGISTER_sfp0_tx_fault_mask;
  // SFP0 tx fault mask
   logic                     FPGA_REG_SFP_MASK_REGISTER_sfp1_tx_fault_mask;
  // SFP1 tx fault mask
   logic                     FPGA_REG_SFP_DETECT_REGISTER_sfp0_detect_n;
  // SFP0 Detect active low
   logic                     FPGA_REG_SFP_DETECT_REGISTER_sfp1_detect_n;
  // SFP1 Detect active low
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_0;
  // 1 = Tx paths 0 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_1;
  // 1 = Tx paths 1 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_2;
  // 1 = Tx paths 2 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_3;
  // 1 = Tx paths 3 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_4;
  // 1 = Tx paths 4 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_5;
  // 1 = Tx paths 5 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_6;
  // 1 = Tx paths 6 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_7;
  // 1 = Tx paths 7 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_0;
  // Mask for rf_overdrive_irq_0. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_1;
  // Mask for rf_overdrive_irq_1. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_2;
  // Mask for rf_overdrive_irq_2. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_3;
  // Mask for rf_overdrive_irq_3. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_4;
  // Mask for rf_overdrive_irq_4. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_5;
  // Mask for rf_overdrive_irq_5. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_6;
  // Mask for rf_overdrive_irq_6. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_7;
  // Mask for rf_overdrive_irq_7. Prevents triggering of overdrive interrupts
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_0;
  // Write 1 and then 0 to clear rf_overdrive_irq_0
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_1;
  // Write 1 and then 0 to clear rf_overdrive_irq_1
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_2;
  // Write 1 and then 0 to clear rf_overdrive_irq_2
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_3;
  // Write 1 and then 0 to clear rf_overdrive_irq_3
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_4;
  // Write 1 and then 0 to clear rf_overdrive_irq_4
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_5;
  // Write 1 and then 0 to clear rf_overdrive_irq_5
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_6;
  // Write 1 and then 0 to clear rf_overdrive_irq_6
   logic                     FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_7;
  // Write 1 and then 0 to clear rf_overdrive_irq_7
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_0;
  // Mute state of Tx paths 0. Use rf_overdrive_mute_clr_0 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_1;
  // Mute state of Tx paths 1. Use rf_overdrive_mute_clr_1 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_2;
  // Mute state of Tx paths 2. Use rf_overdrive_mute_clr_2 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_3;
  // Mute state of Tx paths 3. Use rf_overdrive_mute_clr_3 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_4;
  // Mute state of Tx paths 4. Use rf_overdrive_mute_clr_4 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_5;
  // Mute state of Tx paths 5. Use rf_overdrive_mute_clr_5 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_6;
  // Mute state of Tx paths 6. Use rf_overdrive_mute_clr_6 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_7;
  // Mute state of Tx paths 7. Use rf_overdrive_mute_clr_7 to clear
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_0;
  // Mask rf_overdrive_mute_0. Prevents muting of tx path 0
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_1;
  // Mask rf_overdrive_mute_1. Prevents muting of tx path 1
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_2;
  // Mask rf_overdrive_mute_2. Prevents muting of tx path 2
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_3;
  // Mask rf_overdrive_mute_3. Prevents muting of tx path 3
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_4;
  // Mask rf_overdrive_mute_4. Prevents muting of tx path 4
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_5;
  // Mask rf_overdrive_mute_5. Prevents muting of tx path 5
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_6;
  // Mask rf_overdrive_mute_6. Prevents muting of tx path 6
   logic                     FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_7;
  // Mask rf_overdrive_mute_7. Prevents muting of tx path 7
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_0;
  // Write 1 and then 0 to unmute tx path 0
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_1;
  // Write 1 and then 0 to unmute tx path 1
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_2;
  // Write 1 and then 0 to unmute tx path 2
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_3;
  // Write 1 and then 0 to unmute tx path 3
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_4;
  // Write 1 and then 0 to unmute tx path 4
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_5;
  // Write 1 and then 0 to unmute tx path 5
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_6;
  // Write 1 and then 0 to unmute tx path 6
   logic                     FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_7;
  // Write 1 and then 0 to unmute tx path 7
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_0;
  // Indicates of tx path 0 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_1;
  // Indicates of tx path 1 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_2;
  // Indicates of tx path 2 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_3;
  // Indicates of tx path 3 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_4;
  // Indicates of tx path 4 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_5;
  // Indicates of tx path 5 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_6;
  // Indicates of tx path 6 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_slew_rate_irq_7;
  // Indicates of tx path 7 that exceeded slew limit. Use slew_rate_irq_clr to clear
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_0;
  // Mask bitmap for slew_rate_irq_0. Prevents triggering of slew_rate_irq for tx path 0
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_1;
  // Mask bitmap for slew_rate_irq_1. Prevents triggering of slew_rate_irq for tx path 1
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_2;
  // Mask bitmap for slew_rate_irq_2. Prevents triggering of slew_rate_irq for tx path 2
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_3;
  // Mask bitmap for slew_rate_irq_3. Prevents triggering of slew_rate_irq for tx path 3
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_4;
  // Mask bitmap for slew_rate_irq_4. Prevents triggering of slew_rate_irq for tx path 4
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_5;
  // Mask bitmap for slew_rate_irq_5. Prevents triggering of slew_rate_irq for tx path 5
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_6;
  // Mask bitmap for slew_rate_irq_6. Prevents triggering of slew_rate_irq for tx path 6
   logic                     FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_7;
  // Mask bitmap for slew_rate_irq_7. Prevents triggering of slew_rate_irq for tx path 7
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_0;
  // Write 1 and then 0 to clear slew_rate_irq_0
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_1;
  // Write 1 and then 0 to clear slew_rate_irq_1
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_2;
  // Write 1 and then 0 to clear slew_rate_irq_2
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_3;
  // Write 1 and then 0 to clear slew_rate_irq_3
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_4;
  // Write 1 and then 0 to clear slew_rate_irq_4
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_5;
  // Write 1 and then 0 to clear slew_rate_irq_5
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_6;
  // Write 1 and then 0 to clear slew_rate_irq_6
   logic                     FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_7;
  // Write 1 and then 0 to clear slew_rate_irq_7
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_0_slew_rate_fault_count_0;
  // Number of times that the slew rate limit was exceeded on Tx0. Max = 0xFF (8 bits)
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_1_slew_rate_fault_count_1;
  // Number of times that the slew rate limit was exceeded on Tx1. Max = 0xFF (8 bits)
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_2_slew_rate_fault_count_2;
  // Number of times that the slew rate limit was exceeded on Tx2. Max = 0xFF (8 bits)
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_3_slew_rate_fault_count_3;
  // Number of times that the slew rate limit was exceeded on Tx3. Max = 0xFF (8 bits)
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_4_slew_rate_fault_count_4;
  // Number of times that the slew rate limit was exceeded on Tx4. Max = 0xFF (8 bits)
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_5_slew_rate_fault_count_5;
  // Number of times that the slew rate limit was exceeded on Tx5. Max = 0xFF (8 bits)
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_6_slew_rate_fault_count_6;
  // Number of times that the slew rate limit was exceeded on Tx6. Max = 0xFF (8 bits)
   logic  [31:0]              FPGA_REG_PA_SRP_FAULT_7_slew_rate_fault_count_7;
  // Number of times that the slew rate limit was exceeded on Tx7. Max = 0xFF (8 bits)
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_0;
  // Write 1 and then 0 to reset slew fault count for TX path 0
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_1;
  // Write 1 and then 0 to reset slew fault count for TX path 1
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_2;
  // Write 1 and then 0 to reset slew fault count for TX path 2
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_3;
  // Write 1 and then 0 to reset slew fault count for TX path 3
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_4;
  // Write 1 and then 0 to reset slew fault count for TX path 4
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_5;
  // Write 1 and then 0 to reset slew fault count for TX path 5
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_6;
  // Write 1 and then 0 to reset slew fault count for TX path 6
   logic                     FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_7;
  // Write 1 and then 0 to reset slew fault count for TX path 7
   logic  [31:0]              FPGA_REG_INTR_SCRATCH_irq_scratch;
  // 








////////////////ASSIGN PARAMETERS//////////////////





////////////////ASSIGN CONTROL RW INTF FIELDS//////////////////

   assign  IFP_intr_ctrl.pl_master_irq_mask =  FPGA_REG_MASTER_IRQ_MASK_irq_pl_master_mask;
   assign  IFP_intr_ctrl.pl_irq_mask[0] =  FPGA_REG_PL_IRQ_MASK_mask_reset_request;
   assign  IFP_intr_ctrl.pl_irq_mask[1] =  FPGA_REG_PL_IRQ_MASK_mask_rfdc;
   assign  IFP_intr_ctrl.pl_irq_mask[2] =  FPGA_REG_PL_IRQ_MASK_mask_adc_thresholds;
   assign  IFP_intr_ctrl.pl_irq_mask[3] =  FPGA_REG_PL_IRQ_MASK_mask_ext_alarms;
   assign  IFP_intr_ctrl.pl_irq_mask[4] =  FPGA_REG_PL_IRQ_MASK_mask_sfp_faults;
   assign  IFP_intr_ctrl.pl_irq_mask[5] =  FPGA_REG_PL_IRQ_MASK_mask_psu_alarms;
   assign  IFP_intr_ctrl.pl_irq_mask[31] =  FPGA_REG_PL_IRQ_MASK_mask_debug;
   assign  IFP_intr_ctrl.pl_irq_clear[0] =  FPGA_REG_PL_IRQ_CLEAR_clear_reset_request;
   assign  IFP_intr_ctrl.pl_irq_clear[1] =  FPGA_REG_PL_IRQ_CLEAR_clear_rfdc;
   assign  IFP_intr_ctrl.pl_irq_clear[2] =  FPGA_REG_PL_IRQ_CLEAR_clear_adc_thresholds;
   assign  IFP_intr_ctrl.pl_irq_clear[3] =  FPGA_REG_PL_IRQ_CLEAR_clear_ext_alarms;
   assign  IFP_intr_ctrl.pl_irq_clear[4] =  FPGA_REG_PL_IRQ_CLEAR_clear_sfp_faults;
   assign  IFP_intr_ctrl.pl_irq_clear[5] =  FPGA_REG_PL_IRQ_CLEAR_clear_psu_alarms;
   assign  IFP_intr_ctrl.pl_irq_clear[31] =  FPGA_REG_PL_IRQ_CLEAR_clear_debug;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[0] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[1] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[2] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[3] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[4] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[5] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[6] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold1_mask[7] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold1_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[0] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold2_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[1] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold2_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[2] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold2_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[3] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold2_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[4] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold2_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[5] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold2_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[6] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold2_mask;
   assign  IFP_intr_ctrl.adc_over_threshold2_mask[7] =  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold2_mask;
   assign  IFP_intr_ctrl.ext_alarm_mask[0] =  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_0_mask;
   assign  IFP_intr_ctrl.ext_alarm_mask[1] =  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_1_mask;
   assign  IFP_intr_ctrl.ext_alarm_mask[2] =  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_2_mask;
   assign  IFP_intr_ctrl.ext_alarm_mask[3] =  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_3_mask;
   assign  IFP_intr_ctrl.sfp0_los_mask =  FPGA_REG_SFP_MASK_REGISTER_sfp0_los_mask;
   assign  IFP_intr_ctrl.sfp1_los_mask =  FPGA_REG_SFP_MASK_REGISTER_sfp1_los_mask;
   assign  IFP_intr_ctrl.sfp0_tx_fault_mask =  FPGA_REG_SFP_MASK_REGISTER_sfp0_tx_fault_mask;
   assign  IFP_intr_ctrl.sfp1_tx_fault_mask =  FPGA_REG_SFP_MASK_REGISTER_sfp1_tx_fault_mask;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[0] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_0;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[1] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_1;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[2] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_2;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[3] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_3;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[4] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_4;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[5] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_5;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[6] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_6;
   assign  IFP_intr_ctrl.rf_overdrive_irq_mask[7] =  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_7;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[0] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_0;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[1] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_1;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[2] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_2;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[3] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_3;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[4] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_4;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[5] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_5;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[6] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_6;
   assign  IFP_intr_ctrl.rf_overdrive_irq_clr[7] =  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_7;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[0] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_0;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[1] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_1;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[2] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_2;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[3] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_3;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[4] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_4;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[5] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_5;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[6] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_6;
   assign  IFP_intr_ctrl.rf_overdrive_mute_mask[7] =  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_7;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[0] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_0;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[1] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_1;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[2] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_2;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[3] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_3;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[4] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_4;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[5] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_5;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[6] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_6;
   assign  IFP_intr_ctrl.rf_overdrive_mute_clr[7] =  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_7;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[0] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_0;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[1] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_1;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[2] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_2;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[3] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_3;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[4] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_4;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[5] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_5;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[6] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_6;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_mask[7] =  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_7;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[0] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_0;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[1] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_1;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[2] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_2;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[3] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_3;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[4] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_4;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[5] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_5;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[6] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_6;
   assign  IFP_intr_ctrl.rf_slew_rate_irq_clr[7] =  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_7;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[0] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_0;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[1] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_1;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[2] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_2;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[3] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_3;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[4] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_4;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[5] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_5;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[6] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_6;
   assign  IFP_intr_ctrl.rf_slew_fault_clr[7] =  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_7;




////////////////ASSIGN STATUS RO INTF FIELDS//////////////////

   assign  FPGA_REG_MASTER_IRQ_STATUS_irq_pl_master = IFP_intr_ctrl.pl_master_irq;
   assign  FPGA_REG_PL_IRQ_STATUS_irq_reset_request = IFP_intr_ctrl.pl_irq[0];
   assign  FPGA_REG_PL_IRQ_STATUS_irq_rfdc = IFP_intr_ctrl.pl_irq[1];
   assign  FPGA_REG_PL_IRQ_STATUS_irq_adc_thresholds = IFP_intr_ctrl.pl_irq[2];
   assign  FPGA_REG_PL_IRQ_STATUS_irq_ext_alarms = IFP_intr_ctrl.pl_irq[3];
   assign  FPGA_REG_PL_IRQ_STATUS_irq_sfp_faults = IFP_intr_ctrl.pl_irq[4];
   assign  FPGA_REG_PL_IRQ_STATUS_irq_psu_alarms = IFP_intr_ctrl.pl_irq[5];
   assign  FPGA_REG_PL_IRQ_STATUS_irq_debug = IFP_intr_ctrl.pl_irq[31];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_01_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[0];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_23_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[1];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_01_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[2];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_23_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[3];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_01_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[4];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_23_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[5];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_01_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[6];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_23_over_threshold1 = IFP_intr_ctrl.adc_over_threshold1[7];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_01_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[0];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_23_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[1];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_01_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[2];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_23_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[3];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_01_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[4];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_23_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[5];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_01_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[6];
   assign  FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_23_over_threshold2 = IFP_intr_ctrl.adc_over_threshold2[7];
   assign  FPGA_REG_ADC_REAL_TIME_STATUS_REGISTER_adc_over_range = IFP_intr_ctrl.adc_over_range;
   assign  FPGA_REG_ADC_REAL_TIME_STATUS_REGISTER_adc_over_voltage = IFP_intr_ctrl.adc_over_voltage;
   assign  FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_0 = IFP_intr_ctrl.ext_alarm[0];
   assign  FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_1 = IFP_intr_ctrl.ext_alarm[1];
   assign  FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_2 = IFP_intr_ctrl.ext_alarm[2];
   assign  FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_3 = IFP_intr_ctrl.ext_alarm[3];
   assign  FPGA_REG_SFP_STATUS_REGISTER_sfp0_los = IFP_intr_ctrl.sfp0_los;
   assign  FPGA_REG_SFP_STATUS_REGISTER_sfp1_los = IFP_intr_ctrl.sfp1_los;
   assign  FPGA_REG_SFP_STATUS_REGISTER_sfp0_tx_fault = IFP_intr_ctrl.sfp0_tx_fault;
   assign  FPGA_REG_SFP_STATUS_REGISTER_sfp1_tx_fault = IFP_intr_ctrl.sfp1_tx_fault;
   assign  FPGA_REG_SFP_DETECT_REGISTER_sfp0_detect_n = IFP_intr_ctrl.sfp0_detect_n;
   assign  FPGA_REG_SFP_DETECT_REGISTER_sfp1_detect_n = IFP_intr_ctrl.sfp1_detect_n;
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_0 = IFP_intr_ctrl.rf_overdrive_irq[0];
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_1 = IFP_intr_ctrl.rf_overdrive_irq[1];
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_2 = IFP_intr_ctrl.rf_overdrive_irq[2];
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_3 = IFP_intr_ctrl.rf_overdrive_irq[3];
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_4 = IFP_intr_ctrl.rf_overdrive_irq[4];
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_5 = IFP_intr_ctrl.rf_overdrive_irq[5];
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_6 = IFP_intr_ctrl.rf_overdrive_irq[6];
   assign  FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_7 = IFP_intr_ctrl.rf_overdrive_irq[7];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_0 = IFP_intr_ctrl.rf_overdrive_mute[0];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_1 = IFP_intr_ctrl.rf_overdrive_mute[1];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_2 = IFP_intr_ctrl.rf_overdrive_mute[2];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_3 = IFP_intr_ctrl.rf_overdrive_mute[3];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_4 = IFP_intr_ctrl.rf_overdrive_mute[4];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_5 = IFP_intr_ctrl.rf_overdrive_mute[5];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_6 = IFP_intr_ctrl.rf_overdrive_mute[6];
   assign  FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_7 = IFP_intr_ctrl.rf_overdrive_mute[7];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_0 = IFP_intr_ctrl.rf_slew_rate_irq[0];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_1 = IFP_intr_ctrl.rf_slew_rate_irq[1];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_2 = IFP_intr_ctrl.rf_slew_rate_irq[2];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_3 = IFP_intr_ctrl.rf_slew_rate_irq[3];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_4 = IFP_intr_ctrl.rf_slew_rate_irq[4];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_5 = IFP_intr_ctrl.rf_slew_rate_irq[5];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_6 = IFP_intr_ctrl.rf_slew_rate_irq[6];
   assign  FPGA_REG_PA_SRP_IRQ_slew_rate_irq_7 = IFP_intr_ctrl.rf_slew_rate_irq[7];
   assign  FPGA_REG_PA_SRP_FAULT_0_slew_rate_fault_count_0 = IFP_intr_ctrl.rf_slew_fault_count[0];
   assign  FPGA_REG_PA_SRP_FAULT_1_slew_rate_fault_count_1 = IFP_intr_ctrl.rf_slew_fault_count[1];
   assign  FPGA_REG_PA_SRP_FAULT_2_slew_rate_fault_count_2 = IFP_intr_ctrl.rf_slew_fault_count[2];
   assign  FPGA_REG_PA_SRP_FAULT_3_slew_rate_fault_count_3 = IFP_intr_ctrl.rf_slew_fault_count[3];
   assign  FPGA_REG_PA_SRP_FAULT_4_slew_rate_fault_count_4 = IFP_intr_ctrl.rf_slew_fault_count[4];
   assign  FPGA_REG_PA_SRP_FAULT_5_slew_rate_fault_count_5 = IFP_intr_ctrl.rf_slew_fault_count[5];
   assign  FPGA_REG_PA_SRP_FAULT_6_slew_rate_fault_count_6 = IFP_intr_ctrl.rf_slew_fault_count[6];
   assign  FPGA_REG_PA_SRP_FAULT_7_slew_rate_fault_count_7 = IFP_intr_ctrl.rf_slew_fault_count[7];




///////////////////WRITE LOGIC ////////////////
  always @(posedge clk) begin
    if (srst) begin
                  FPGA_REG_MASTER_IRQ_MASK_irq_pl_master_mask <= 'h0;  // 
                  FPGA_REG_PL_IRQ_MASK_mask_reset_request <= 'h0;  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_rfdc <= 'h0;  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_adc_thresholds <= 'h0;  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_ext_alarms <= 'h0;  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_sfp_faults <= 'h0;  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_psu_alarms <= 'h0;  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_debug <= 'h0;  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_CLEAR_clear_reset_request <= 'h0;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_rfdc <= 'h0;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_adc_thresholds <= 'h0;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_ext_alarms <= 'h0;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_sfp_faults <= 'h0;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_psu_alarms <= 'h0;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_debug <= 'h0;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold1_mask <= 'h0;  // ADC0 (Bank 224 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold1_mask <= 'h0;  // ADC1 (Bank 224 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold1_mask <= 'h0;  // ADC2 (Bank 225 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold1_mask <= 'h0;  // ADC3 (Bank 225 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold1_mask <= 'h0;  // ADC4 (Bank 226 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold1_mask <= 'h0;  // ADC5 (Bank 226 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold1_mask <= 'h0;  // ADC6 (Bank 227 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold1_mask <= 'h0;  // ADC7 (Bank 227 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold2_mask <= 'h0;  // ADC0 (Bank 224 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold2_mask <= 'h0;  // ADC1 (Bank 224 ADC23) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold2_mask <= 'h0;  // ADC2 (Bank 225 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold2_mask <= 'h0;  // ADC3 (Bank 225 ADC23) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold2_mask <= 'h0;  // ADC4 (Bank 226 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold2_mask <= 'h0;  // ADC5 (Bank 226 ADC23) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold2_mask <= 'h0;  // ADC6 (Bank 227 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold2_mask <= 'h0;  // ADC7 (Bank 227 ADC23) Threshold2 Interrupt Mask
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_0_mask <= 'h0;  // External Alarm Interrupt Masks
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_1_mask <= 'h0;  // 
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_2_mask <= 'h0;  // 
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_3_mask <= 'h0;  // 
                  FPGA_REG_SFP_MASK_REGISTER_sfp0_los_mask <= 'h0;  // SFP0 los mask
                  FPGA_REG_SFP_MASK_REGISTER_sfp1_los_mask <= 'h0;  // SFP1 los mask
                  FPGA_REG_SFP_MASK_REGISTER_sfp0_tx_fault_mask <= 'h0;  // SFP0 tx fault mask
                  FPGA_REG_SFP_MASK_REGISTER_sfp1_tx_fault_mask <= 'h0;  // SFP1 tx fault mask
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_0 <= 'h0;  // Mask for rf_overdrive_irq_0. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_1 <= 'h0;  // Mask for rf_overdrive_irq_1. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_2 <= 'h0;  // Mask for rf_overdrive_irq_2. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_3 <= 'h0;  // Mask for rf_overdrive_irq_3. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_4 <= 'h0;  // Mask for rf_overdrive_irq_4. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_5 <= 'h0;  // Mask for rf_overdrive_irq_5. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_6 <= 'h0;  // Mask for rf_overdrive_irq_6. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_7 <= 'h0;  // Mask for rf_overdrive_irq_7. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_0 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_0
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_1 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_1
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_2 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_2
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_3 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_3
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_4 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_4
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_5 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_5
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_6 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_6
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_7 <= 'h0;  // Write 1 and then 0 to clear rf_overdrive_irq_7
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_0 <= 'h0;  // Mask rf_overdrive_mute_0. Prevents muting of tx path 0
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_1 <= 'h0;  // Mask rf_overdrive_mute_1. Prevents muting of tx path 1
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_2 <= 'h0;  // Mask rf_overdrive_mute_2. Prevents muting of tx path 2
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_3 <= 'h0;  // Mask rf_overdrive_mute_3. Prevents muting of tx path 3
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_4 <= 'h0;  // Mask rf_overdrive_mute_4. Prevents muting of tx path 4
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_5 <= 'h0;  // Mask rf_overdrive_mute_5. Prevents muting of tx path 5
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_6 <= 'h0;  // Mask rf_overdrive_mute_6. Prevents muting of tx path 6
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_7 <= 'h0;  // Mask rf_overdrive_mute_7. Prevents muting of tx path 7
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_0 <= 'h0;  // Write 1 and then 0 to unmute tx path 0
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_1 <= 'h0;  // Write 1 and then 0 to unmute tx path 1
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_2 <= 'h0;  // Write 1 and then 0 to unmute tx path 2
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_3 <= 'h0;  // Write 1 and then 0 to unmute tx path 3
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_4 <= 'h0;  // Write 1 and then 0 to unmute tx path 4
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_5 <= 'h0;  // Write 1 and then 0 to unmute tx path 5
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_6 <= 'h0;  // Write 1 and then 0 to unmute tx path 6
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_7 <= 'h0;  // Write 1 and then 0 to unmute tx path 7
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_0 <= 'h0;  // Mask bitmap for slew_rate_irq_0. Prevents triggering of slew_rate_irq for tx path 0
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_1 <= 'h0;  // Mask bitmap for slew_rate_irq_1. Prevents triggering of slew_rate_irq for tx path 1
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_2 <= 'h0;  // Mask bitmap for slew_rate_irq_2. Prevents triggering of slew_rate_irq for tx path 2
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_3 <= 'h0;  // Mask bitmap for slew_rate_irq_3. Prevents triggering of slew_rate_irq for tx path 3
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_4 <= 'h0;  // Mask bitmap for slew_rate_irq_4. Prevents triggering of slew_rate_irq for tx path 4
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_5 <= 'h0;  // Mask bitmap for slew_rate_irq_5. Prevents triggering of slew_rate_irq for tx path 5
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_6 <= 'h0;  // Mask bitmap for slew_rate_irq_6. Prevents triggering of slew_rate_irq for tx path 6
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_7 <= 'h0;  // Mask bitmap for slew_rate_irq_7. Prevents triggering of slew_rate_irq for tx path 7
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_0 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_0
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_1 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_1
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_2 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_2
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_3 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_3
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_4 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_4
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_5 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_5
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_6 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_6
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_7 <= 'h0;  // Write 1 and then 0 to clear slew_rate_irq_7
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_0 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 0
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_1 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 1
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_2 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 2
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_3 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 3
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_4 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 4
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_5 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 5
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_6 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 6
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_7 <= 'h0;  // Write 1 and then 0 to reset slew fault count for TX path 7
                  FPGA_REG_INTR_SCRATCH_irq_scratch <= 'h5555_eeee;  // 
    end
    else if (IFP_axi_rw.wren) begin
      case(IFP_axi_rw.wr_offset)
      11'h1  : begin //'h4
                  FPGA_REG_MASTER_IRQ_MASK_irq_pl_master_mask <= IFP_axi_rw.wdata[0];  // 
             end
      11'h5  : begin //'h14
                  FPGA_REG_PL_IRQ_MASK_mask_reset_request <= IFP_axi_rw.wdata[0];  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_rfdc <= IFP_axi_rw.wdata[1];  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_adc_thresholds <= IFP_axi_rw.wdata[2];  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_ext_alarms <= IFP_axi_rw.wdata[3];  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_sfp_faults <= IFP_axi_rw.wdata[4];  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_psu_alarms <= IFP_axi_rw.wdata[5];  // Write 1 to mask corresponding interrupt status bit
                  FPGA_REG_PL_IRQ_MASK_mask_debug <= IFP_axi_rw.wdata[31];  // Write 1 to mask corresponding interrupt status bit
             end
      11'h6  : begin //'h18
                  FPGA_REG_PL_IRQ_CLEAR_clear_reset_request <= IFP_axi_rw.wdata[0];  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_rfdc <= IFP_axi_rw.wdata[1];  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_adc_thresholds <= IFP_axi_rw.wdata[2];  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_ext_alarms <= IFP_axi_rw.wdata[3];  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_sfp_faults <= IFP_axi_rw.wdata[4];  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_psu_alarms <= IFP_axi_rw.wdata[5];  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                  FPGA_REG_PL_IRQ_CLEAR_clear_debug <= IFP_axi_rw.wdata[31];  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
             end
      11'h41  : begin //'h104
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold1_mask <= IFP_axi_rw.wdata[0];  // ADC0 (Bank 224 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold1_mask <= IFP_axi_rw.wdata[1];  // ADC1 (Bank 224 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold1_mask <= IFP_axi_rw.wdata[2];  // ADC2 (Bank 225 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold1_mask <= IFP_axi_rw.wdata[3];  // ADC3 (Bank 225 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold1_mask <= IFP_axi_rw.wdata[4];  // ADC4 (Bank 226 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold1_mask <= IFP_axi_rw.wdata[5];  // ADC5 (Bank 226 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold1_mask <= IFP_axi_rw.wdata[6];  // ADC6 (Bank 227 ADC01) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold1_mask <= IFP_axi_rw.wdata[7];  // ADC7 (Bank 227 ADC23) Threshold1 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold2_mask <= IFP_axi_rw.wdata[8];  // ADC0 (Bank 224 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold2_mask <= IFP_axi_rw.wdata[9];  // ADC1 (Bank 224 ADC23) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold2_mask <= IFP_axi_rw.wdata[10];  // ADC2 (Bank 225 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold2_mask <= IFP_axi_rw.wdata[11];  // ADC3 (Bank 225 ADC23) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold2_mask <= IFP_axi_rw.wdata[12];  // ADC4 (Bank 226 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold2_mask <= IFP_axi_rw.wdata[13];  // ADC5 (Bank 226 ADC23) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold2_mask <= IFP_axi_rw.wdata[14];  // ADC6 (Bank 227 ADC01) Threshold2 Interrupt Mask
                  FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold2_mask <= IFP_axi_rw.wdata[15];  // ADC7 (Bank 227 ADC23) Threshold2 Interrupt Mask
             end
      11'h45  : begin //'h114
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_0_mask <= IFP_axi_rw.wdata[0];  // External Alarm Interrupt Masks
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_1_mask <= IFP_axi_rw.wdata[1];  // 
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_2_mask <= IFP_axi_rw.wdata[2];  // 
                  FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_3_mask <= IFP_axi_rw.wdata[3];  // 
             end
      11'h49  : begin //'h124
                  FPGA_REG_SFP_MASK_REGISTER_sfp0_los_mask <= IFP_axi_rw.wdata[0];  // SFP0 los mask
                  FPGA_REG_SFP_MASK_REGISTER_sfp1_los_mask <= IFP_axi_rw.wdata[1];  // SFP1 los mask
                  FPGA_REG_SFP_MASK_REGISTER_sfp0_tx_fault_mask <= IFP_axi_rw.wdata[8];  // SFP0 tx fault mask
                  FPGA_REG_SFP_MASK_REGISTER_sfp1_tx_fault_mask <= IFP_axi_rw.wdata[9];  // SFP1 tx fault mask
             end
      11'h55  : begin //'h154
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_0 <= IFP_axi_rw.wdata[0];  // Mask for rf_overdrive_irq_0. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_1 <= IFP_axi_rw.wdata[1];  // Mask for rf_overdrive_irq_1. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_2 <= IFP_axi_rw.wdata[2];  // Mask for rf_overdrive_irq_2. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_3 <= IFP_axi_rw.wdata[3];  // Mask for rf_overdrive_irq_3. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_4 <= IFP_axi_rw.wdata[4];  // Mask for rf_overdrive_irq_4. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_5 <= IFP_axi_rw.wdata[5];  // Mask for rf_overdrive_irq_5. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_6 <= IFP_axi_rw.wdata[6];  // Mask for rf_overdrive_irq_6. Prevents triggering of overdrive interrupts
                  FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_7 <= IFP_axi_rw.wdata[7];  // Mask for rf_overdrive_irq_7. Prevents triggering of overdrive interrupts
             end
      11'h56  : begin //'h158
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_0 <= IFP_axi_rw.wdata[0];  // Write 1 and then 0 to clear rf_overdrive_irq_0
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_1 <= IFP_axi_rw.wdata[1];  // Write 1 and then 0 to clear rf_overdrive_irq_1
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_2 <= IFP_axi_rw.wdata[2];  // Write 1 and then 0 to clear rf_overdrive_irq_2
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_3 <= IFP_axi_rw.wdata[3];  // Write 1 and then 0 to clear rf_overdrive_irq_3
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_4 <= IFP_axi_rw.wdata[4];  // Write 1 and then 0 to clear rf_overdrive_irq_4
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_5 <= IFP_axi_rw.wdata[5];  // Write 1 and then 0 to clear rf_overdrive_irq_5
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_6 <= IFP_axi_rw.wdata[6];  // Write 1 and then 0 to clear rf_overdrive_irq_6
                  FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_7 <= IFP_axi_rw.wdata[7];  // Write 1 and then 0 to clear rf_overdrive_irq_7
             end
      11'h59  : begin //'h164
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_0 <= IFP_axi_rw.wdata[0];  // Mask rf_overdrive_mute_0. Prevents muting of tx path 0
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_1 <= IFP_axi_rw.wdata[1];  // Mask rf_overdrive_mute_1. Prevents muting of tx path 1
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_2 <= IFP_axi_rw.wdata[2];  // Mask rf_overdrive_mute_2. Prevents muting of tx path 2
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_3 <= IFP_axi_rw.wdata[3];  // Mask rf_overdrive_mute_3. Prevents muting of tx path 3
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_4 <= IFP_axi_rw.wdata[4];  // Mask rf_overdrive_mute_4. Prevents muting of tx path 4
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_5 <= IFP_axi_rw.wdata[5];  // Mask rf_overdrive_mute_5. Prevents muting of tx path 5
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_6 <= IFP_axi_rw.wdata[6];  // Mask rf_overdrive_mute_6. Prevents muting of tx path 6
                  FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_7 <= IFP_axi_rw.wdata[7];  // Mask rf_overdrive_mute_7. Prevents muting of tx path 7
             end
      11'h5a  : begin //'h168
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_0 <= IFP_axi_rw.wdata[0];  // Write 1 and then 0 to unmute tx path 0
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_1 <= IFP_axi_rw.wdata[1];  // Write 1 and then 0 to unmute tx path 1
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_2 <= IFP_axi_rw.wdata[2];  // Write 1 and then 0 to unmute tx path 2
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_3 <= IFP_axi_rw.wdata[3];  // Write 1 and then 0 to unmute tx path 3
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_4 <= IFP_axi_rw.wdata[4];  // Write 1 and then 0 to unmute tx path 4
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_5 <= IFP_axi_rw.wdata[5];  // Write 1 and then 0 to unmute tx path 5
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_6 <= IFP_axi_rw.wdata[6];  // Write 1 and then 0 to unmute tx path 6
                  FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_7 <= IFP_axi_rw.wdata[7];  // Write 1 and then 0 to unmute tx path 7
             end
      11'h5d  : begin //'h174
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_0 <= IFP_axi_rw.wdata[0];  // Mask bitmap for slew_rate_irq_0. Prevents triggering of slew_rate_irq for tx path 0
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_1 <= IFP_axi_rw.wdata[1];  // Mask bitmap for slew_rate_irq_1. Prevents triggering of slew_rate_irq for tx path 1
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_2 <= IFP_axi_rw.wdata[2];  // Mask bitmap for slew_rate_irq_2. Prevents triggering of slew_rate_irq for tx path 2
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_3 <= IFP_axi_rw.wdata[3];  // Mask bitmap for slew_rate_irq_3. Prevents triggering of slew_rate_irq for tx path 3
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_4 <= IFP_axi_rw.wdata[4];  // Mask bitmap for slew_rate_irq_4. Prevents triggering of slew_rate_irq for tx path 4
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_5 <= IFP_axi_rw.wdata[5];  // Mask bitmap for slew_rate_irq_5. Prevents triggering of slew_rate_irq for tx path 5
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_6 <= IFP_axi_rw.wdata[6];  // Mask bitmap for slew_rate_irq_6. Prevents triggering of slew_rate_irq for tx path 6
                  FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_7 <= IFP_axi_rw.wdata[7];  // Mask bitmap for slew_rate_irq_7. Prevents triggering of slew_rate_irq for tx path 7
             end
      11'h5e  : begin //'h178
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_0 <= IFP_axi_rw.wdata[0];  // Write 1 and then 0 to clear slew_rate_irq_0
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_1 <= IFP_axi_rw.wdata[1];  // Write 1 and then 0 to clear slew_rate_irq_1
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_2 <= IFP_axi_rw.wdata[2];  // Write 1 and then 0 to clear slew_rate_irq_2
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_3 <= IFP_axi_rw.wdata[3];  // Write 1 and then 0 to clear slew_rate_irq_3
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_4 <= IFP_axi_rw.wdata[4];  // Write 1 and then 0 to clear slew_rate_irq_4
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_5 <= IFP_axi_rw.wdata[5];  // Write 1 and then 0 to clear slew_rate_irq_5
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_6 <= IFP_axi_rw.wdata[6];  // Write 1 and then 0 to clear slew_rate_irq_6
                  FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_7 <= IFP_axi_rw.wdata[7];  // Write 1 and then 0 to clear slew_rate_irq_7
             end
      11'h68  : begin //'h1A0
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_0 <= IFP_axi_rw.wdata[0];  // Write 1 and then 0 to reset slew fault count for TX path 0
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_1 <= IFP_axi_rw.wdata[1];  // Write 1 and then 0 to reset slew fault count for TX path 1
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_2 <= IFP_axi_rw.wdata[2];  // Write 1 and then 0 to reset slew fault count for TX path 2
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_3 <= IFP_axi_rw.wdata[3];  // Write 1 and then 0 to reset slew fault count for TX path 3
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_4 <= IFP_axi_rw.wdata[4];  // Write 1 and then 0 to reset slew fault count for TX path 4
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_5 <= IFP_axi_rw.wdata[5];  // Write 1 and then 0 to reset slew fault count for TX path 5
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_6 <= IFP_axi_rw.wdata[6];  // Write 1 and then 0 to reset slew fault count for TX path 6
                  FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_7 <= IFP_axi_rw.wdata[7];  // Write 1 and then 0 to reset slew fault count for TX path 7
             end
      11'h7ff  : begin //'h1FFC
                  FPGA_REG_INTR_SCRATCH_irq_scratch <= IFP_axi_rw.wdata[31:0];  // 
               end
      endcase
    end
  end
///////////////////////////////////////////////



///////////////////READ LOGIC ////////////////
  always @(*) begin
    IFP_axi_rw.rdata = 0;
    if (IFP_axi_rw.rden) begin
       case(IFP_axi_rw.rd_offset)
      11'h0  : begin//'h0
                   IFP_axi_rw.rdata[0] = FPGA_REG_MASTER_IRQ_STATUS_irq_pl_master;  // Self clearing. 1 = A sticky interrupt is high in the PL interrupt register.
             end
      11'h1  : begin//'h4
                   IFP_axi_rw.rdata[0] = FPGA_REG_MASTER_IRQ_MASK_irq_pl_master_mask;  // 
             end
      11'h4  : begin//'h10
                   IFP_axi_rw.rdata[0] = FPGA_REG_PL_IRQ_STATUS_irq_reset_request;  // Sticky. Reset request to software before cold reset is asserted
                   IFP_axi_rw.rdata[1] = FPGA_REG_PL_IRQ_STATUS_irq_rfdc;  // Sticky - Interrupt from RF Data Converter
                   IFP_axi_rw.rdata[2] = FPGA_REG_PL_IRQ_STATUS_irq_adc_thresholds;  // Sticky - Composite interrupt for adcXZ_over_threshold1-2 from all ADCs (except ORX ADCs). See FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER
                   IFP_axi_rw.rdata[3] = FPGA_REG_PL_IRQ_STATUS_irq_ext_alarms;  // Sticky - SPF status (i.e. LOS, TX Fault, etc.). See FPGA_REG_SFP_STATUS_REGISTER
                   IFP_axi_rw.rdata[4] = FPGA_REG_PL_IRQ_STATUS_irq_sfp_faults;  // Sticky - Customer alarms. See FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER
                   IFP_axi_rw.rdata[5] = FPGA_REG_PL_IRQ_STATUS_irq_psu_alarms;  // Sticky - PSU Alarm
                   IFP_axi_rw.rdata[31] = FPGA_REG_PL_IRQ_STATUS_irq_debug;  // Sticky - For debug purpose only
             end
      11'h5  : begin//'h14
                   IFP_axi_rw.rdata[0] = FPGA_REG_PL_IRQ_MASK_mask_reset_request;  // Write 1 to mask corresponding interrupt status bit
                   IFP_axi_rw.rdata[1] = FPGA_REG_PL_IRQ_MASK_mask_rfdc;  // Write 1 to mask corresponding interrupt status bit
                   IFP_axi_rw.rdata[2] = FPGA_REG_PL_IRQ_MASK_mask_adc_thresholds;  // Write 1 to mask corresponding interrupt status bit
                   IFP_axi_rw.rdata[3] = FPGA_REG_PL_IRQ_MASK_mask_ext_alarms;  // Write 1 to mask corresponding interrupt status bit
                   IFP_axi_rw.rdata[4] = FPGA_REG_PL_IRQ_MASK_mask_sfp_faults;  // Write 1 to mask corresponding interrupt status bit
                   IFP_axi_rw.rdata[5] = FPGA_REG_PL_IRQ_MASK_mask_psu_alarms;  // Write 1 to mask corresponding interrupt status bit
                   IFP_axi_rw.rdata[31] = FPGA_REG_PL_IRQ_MASK_mask_debug;  // Write 1 to mask corresponding interrupt status bit
             end
      11'h6  : begin//'h18
                   IFP_axi_rw.rdata[0] = FPGA_REG_PL_IRQ_CLEAR_clear_reset_request;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                   IFP_axi_rw.rdata[1] = FPGA_REG_PL_IRQ_CLEAR_clear_rfdc;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                   IFP_axi_rw.rdata[2] = FPGA_REG_PL_IRQ_CLEAR_clear_adc_thresholds;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                   IFP_axi_rw.rdata[3] = FPGA_REG_PL_IRQ_CLEAR_clear_ext_alarms;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                   IFP_axi_rw.rdata[4] = FPGA_REG_PL_IRQ_CLEAR_clear_sfp_faults;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                   IFP_axi_rw.rdata[5] = FPGA_REG_PL_IRQ_CLEAR_clear_psu_alarms;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
                   IFP_axi_rw.rdata[31] = FPGA_REG_PL_IRQ_CLEAR_clear_debug;  // Write 1 and then 0 to clear irq status. The status will not clear if the interrupt condition still exists.
             end
      11'h40  : begin//'h100
                   IFP_axi_rw.rdata[0] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_01_over_threshold1;  // ADC0 (Bank 224 ADC01) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[1] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_23_over_threshold1;  // ADC1 (Bank 224 ADC23) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[2] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_01_over_threshold1;  // ADC2 (Bank 225 ADC01) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[3] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_23_over_threshold1;  // ADC3 (Bank 225 ADC23) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[4] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_01_over_threshold1;  // ADC4 (Bank 226 ADC01) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[5] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_23_over_threshold1;  // ADC5 (Bank 226 ADC23) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[6] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_01_over_threshold1;  // ADC6 (Bank 227 ADC01) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[7] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_23_over_threshold1;  // ADC7 (Bank 227 ADC23) Threshold1 Interrupt Status
                   IFP_axi_rw.rdata[8] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_01_over_threshold2;  // ADC0 (Bank 224 ADC01) Threshold2 Interrupt Status
                   IFP_axi_rw.rdata[9] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc0_23_over_threshold2;  // ADC1 (Bank 224 ADC23) Threshold2 Interrupt Status
                   IFP_axi_rw.rdata[10] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_01_over_threshold2;  // ADC2 (Bank 225 ADC01) Threshold2 Interrupt Status
                   IFP_axi_rw.rdata[11] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc1_23_over_threshold2;  // ADC3 (Bank 225 ADC23) Threshold2 Interrupt Status
                   IFP_axi_rw.rdata[12] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_01_over_threshold2;  // ADC4 (Bank 226 ADC01) Threshold2 Interrupt Status
                   IFP_axi_rw.rdata[13] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc2_23_over_threshold2;  // ADC5 (Bank 226 ADC23) Threshold2 Interrupt Status
                   IFP_axi_rw.rdata[14] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_01_over_threshold2;  // ADC6 (Bank 227 ADC01) Threshold2 Interrupt Status
                   IFP_axi_rw.rdata[15] = FPGA_REG_ADC_THRESHOLD_INTR_STATUS_REGISTER_adc3_23_over_threshold2;  // ADC7 (Bank 227 ADC23) Threshold2 Interrupt Status
             end
      11'h41  : begin//'h104
                   IFP_axi_rw.rdata[0] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold1_mask;  // ADC0 (Bank 224 ADC01) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[1] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold1_mask;  // ADC1 (Bank 224 ADC23) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[2] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold1_mask;  // ADC2 (Bank 225 ADC01) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[3] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold1_mask;  // ADC3 (Bank 225 ADC23) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[4] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold1_mask;  // ADC4 (Bank 226 ADC01) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[5] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold1_mask;  // ADC5 (Bank 226 ADC23) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[6] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold1_mask;  // ADC6 (Bank 227 ADC01) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[7] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold1_mask;  // ADC7 (Bank 227 ADC23) Threshold1 Interrupt Mask
                   IFP_axi_rw.rdata[8] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_01_over_threshold2_mask;  // ADC0 (Bank 224 ADC01) Threshold2 Interrupt Mask
                   IFP_axi_rw.rdata[9] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc0_23_over_threshold2_mask;  // ADC1 (Bank 224 ADC23) Threshold2 Interrupt Mask
                   IFP_axi_rw.rdata[10] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_01_over_threshold2_mask;  // ADC2 (Bank 225 ADC01) Threshold2 Interrupt Mask
                   IFP_axi_rw.rdata[11] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc1_23_over_threshold2_mask;  // ADC3 (Bank 225 ADC23) Threshold2 Interrupt Mask
                   IFP_axi_rw.rdata[12] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_01_over_threshold2_mask;  // ADC4 (Bank 226 ADC01) Threshold2 Interrupt Mask
                   IFP_axi_rw.rdata[13] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc2_23_over_threshold2_mask;  // ADC5 (Bank 226 ADC23) Threshold2 Interrupt Mask
                   IFP_axi_rw.rdata[14] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_01_over_threshold2_mask;  // ADC6 (Bank 227 ADC01) Threshold2 Interrupt Mask
                   IFP_axi_rw.rdata[15] = FPGA_REG_ADC_THRESHOLD_INTR_MASK_REGISTER_adc3_23_over_threshold2_mask;  // ADC7 (Bank 227 ADC23) Threshold2 Interrupt Mask
             end
      11'h42  : begin//'h108
                   IFP_axi_rw.rdata[7:0] = FPGA_REG_ADC_REAL_TIME_STATUS_REGISTER_adc_over_range;  // Over Range, Bit 0:ADC0 (Bank 224 ADC01), 1: ADC1 (Bank 224 ADC23), 2:ADC2 (Bank 225 ADC 01), ...
                   IFP_axi_rw.rdata[15:8] = FPGA_REG_ADC_REAL_TIME_STATUS_REGISTER_adc_over_voltage;  // Over Voltage, Bit 0:ADC0 (Bank 224 ADC01), 1: ADC1 (Bank 224 ADC23), 2:ADC2 (Bank 225 ADC 01), 
             end
      11'h44  : begin//'h110
                   IFP_axi_rw.rdata[0] = FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_0;  // External Alarm Interrupt Status
                   IFP_axi_rw.rdata[1] = FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_1;  // 
                   IFP_axi_rw.rdata[2] = FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_2;  // 
                   IFP_axi_rw.rdata[3] = FPGA_REG_EXT_ALARM_INTR_STATUS_REGISTER_ext_alarm_3;  // 
             end
      11'h45  : begin//'h114
                   IFP_axi_rw.rdata[0] = FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_0_mask;  // External Alarm Interrupt Masks
                   IFP_axi_rw.rdata[1] = FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_1_mask;  // 
                   IFP_axi_rw.rdata[2] = FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_2_mask;  // 
                   IFP_axi_rw.rdata[3] = FPGA_REG_EXT_ALARM_INTR_MASK_REGISTER_ext_alarm_3_mask;  // 
             end
      11'h48  : begin//'h120
                   IFP_axi_rw.rdata[0] = FPGA_REG_SFP_STATUS_REGISTER_sfp0_los;  // SFP0 LOS
                   IFP_axi_rw.rdata[1] = FPGA_REG_SFP_STATUS_REGISTER_sfp1_los;  // SFP1 LOS
                   IFP_axi_rw.rdata[8] = FPGA_REG_SFP_STATUS_REGISTER_sfp0_tx_fault;  // SFP0 TX FAULT
                   IFP_axi_rw.rdata[9] = FPGA_REG_SFP_STATUS_REGISTER_sfp1_tx_fault;  // SFP1 TX FAULT
             end
      11'h49  : begin//'h124
                   IFP_axi_rw.rdata[0] = FPGA_REG_SFP_MASK_REGISTER_sfp0_los_mask;  // SFP0 los mask
                   IFP_axi_rw.rdata[1] = FPGA_REG_SFP_MASK_REGISTER_sfp1_los_mask;  // SFP1 los mask
                   IFP_axi_rw.rdata[8] = FPGA_REG_SFP_MASK_REGISTER_sfp0_tx_fault_mask;  // SFP0 tx fault mask
                   IFP_axi_rw.rdata[9] = FPGA_REG_SFP_MASK_REGISTER_sfp1_tx_fault_mask;  // SFP1 tx fault mask
             end
      11'h4a  : begin//'h128
                   IFP_axi_rw.rdata[0] = FPGA_REG_SFP_DETECT_REGISTER_sfp0_detect_n;  // SFP0 Detect active low
                   IFP_axi_rw.rdata[1] = FPGA_REG_SFP_DETECT_REGISTER_sfp1_detect_n;  // SFP1 Detect active low
             end
      11'h54  : begin//'h150
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_0;  // 1 = Tx paths 0 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_1;  // 1 = Tx paths 1 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_2;  // 1 = Tx paths 2 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_3;  // 1 = Tx paths 3 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_4;  // 1 = Tx paths 4 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_5;  // 1 = Tx paths 5 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_6;  // 1 = Tx paths 6 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_ODP_IRQ_rf_overdrive_irq_7;  // 1 = Tx paths 7 triggered the overdrive interrupt. Use rf_overdrive_irq_clr to clear
             end
      11'h55  : begin//'h154
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_0;  // Mask for rf_overdrive_irq_0. Prevents triggering of overdrive interrupts
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_1;  // Mask for rf_overdrive_irq_1. Prevents triggering of overdrive interrupts
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_2;  // Mask for rf_overdrive_irq_2. Prevents triggering of overdrive interrupts
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_3;  // Mask for rf_overdrive_irq_3. Prevents triggering of overdrive interrupts
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_4;  // Mask for rf_overdrive_irq_4. Prevents triggering of overdrive interrupts
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_5;  // Mask for rf_overdrive_irq_5. Prevents triggering of overdrive interrupts
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_6;  // Mask for rf_overdrive_irq_6. Prevents triggering of overdrive interrupts
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_ODP_IRQ_MASK_rf_overdrive_irq_mask_7;  // Mask for rf_overdrive_irq_7. Prevents triggering of overdrive interrupts
             end
      11'h56  : begin//'h158
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_0;  // Write 1 and then 0 to clear rf_overdrive_irq_0
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_1;  // Write 1 and then 0 to clear rf_overdrive_irq_1
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_2;  // Write 1 and then 0 to clear rf_overdrive_irq_2
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_3;  // Write 1 and then 0 to clear rf_overdrive_irq_3
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_4;  // Write 1 and then 0 to clear rf_overdrive_irq_4
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_5;  // Write 1 and then 0 to clear rf_overdrive_irq_5
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_6;  // Write 1 and then 0 to clear rf_overdrive_irq_6
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_ODP_IRQ_CLR_rf_overdrive_irq_clr_7;  // Write 1 and then 0 to clear rf_overdrive_irq_7
             end
      11'h58  : begin//'h160
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_0;  // Mute state of Tx paths 0. Use rf_overdrive_mute_clr_0 to clear
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_1;  // Mute state of Tx paths 1. Use rf_overdrive_mute_clr_1 to clear
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_2;  // Mute state of Tx paths 2. Use rf_overdrive_mute_clr_2 to clear
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_3;  // Mute state of Tx paths 3. Use rf_overdrive_mute_clr_3 to clear
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_4;  // Mute state of Tx paths 4. Use rf_overdrive_mute_clr_4 to clear
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_5;  // Mute state of Tx paths 5. Use rf_overdrive_mute_clr_5 to clear
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_6;  // Mute state of Tx paths 6. Use rf_overdrive_mute_clr_6 to clear
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_ODP_MUTE_rf_overdrive_mute_7;  // Mute state of Tx paths 7. Use rf_overdrive_mute_clr_7 to clear
             end
      11'h59  : begin//'h164
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_0;  // Mask rf_overdrive_mute_0. Prevents muting of tx path 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_1;  // Mask rf_overdrive_mute_1. Prevents muting of tx path 1
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_2;  // Mask rf_overdrive_mute_2. Prevents muting of tx path 2
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_3;  // Mask rf_overdrive_mute_3. Prevents muting of tx path 3
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_4;  // Mask rf_overdrive_mute_4. Prevents muting of tx path 4
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_5;  // Mask rf_overdrive_mute_5. Prevents muting of tx path 5
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_6;  // Mask rf_overdrive_mute_6. Prevents muting of tx path 6
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_ODP_MUTE_MASK_rf_overdrive_mute_mask_7;  // Mask rf_overdrive_mute_7. Prevents muting of tx path 7
             end
      11'h5a  : begin//'h168
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_0;  // Write 1 and then 0 to unmute tx path 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_1;  // Write 1 and then 0 to unmute tx path 1
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_2;  // Write 1 and then 0 to unmute tx path 2
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_3;  // Write 1 and then 0 to unmute tx path 3
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_4;  // Write 1 and then 0 to unmute tx path 4
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_5;  // Write 1 and then 0 to unmute tx path 5
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_6;  // Write 1 and then 0 to unmute tx path 6
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_ODP_MUTE_CLR_rf_overdrive_mute_clr_7;  // Write 1 and then 0 to unmute tx path 7
             end
      11'h5c  : begin//'h170
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_0;  // Indicates of tx path 0 that exceeded slew limit. Use slew_rate_irq_clr to clear
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_1;  // Indicates of tx path 1 that exceeded slew limit. Use slew_rate_irq_clr to clear
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_2;  // Indicates of tx path 2 that exceeded slew limit. Use slew_rate_irq_clr to clear
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_3;  // Indicates of tx path 3 that exceeded slew limit. Use slew_rate_irq_clr to clear
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_4;  // Indicates of tx path 4 that exceeded slew limit. Use slew_rate_irq_clr to clear
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_5;  // Indicates of tx path 5 that exceeded slew limit. Use slew_rate_irq_clr to clear
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_6;  // Indicates of tx path 6 that exceeded slew limit. Use slew_rate_irq_clr to clear
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_SRP_IRQ_slew_rate_irq_7;  // Indicates of tx path 7 that exceeded slew limit. Use slew_rate_irq_clr to clear
             end
      11'h5d  : begin//'h174
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_0;  // Mask bitmap for slew_rate_irq_0. Prevents triggering of slew_rate_irq for tx path 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_1;  // Mask bitmap for slew_rate_irq_1. Prevents triggering of slew_rate_irq for tx path 1
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_2;  // Mask bitmap for slew_rate_irq_2. Prevents triggering of slew_rate_irq for tx path 2
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_3;  // Mask bitmap for slew_rate_irq_3. Prevents triggering of slew_rate_irq for tx path 3
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_4;  // Mask bitmap for slew_rate_irq_4. Prevents triggering of slew_rate_irq for tx path 4
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_5;  // Mask bitmap for slew_rate_irq_5. Prevents triggering of slew_rate_irq for tx path 5
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_6;  // Mask bitmap for slew_rate_irq_6. Prevents triggering of slew_rate_irq for tx path 6
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_SRP_IRQ_MASK_slew_rate_irq_mask_7;  // Mask bitmap for slew_rate_irq_7. Prevents triggering of slew_rate_irq for tx path 7
             end
      11'h5e  : begin//'h178
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_0;  // Write 1 and then 0 to clear slew_rate_irq_0
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_1;  // Write 1 and then 0 to clear slew_rate_irq_1
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_2;  // Write 1 and then 0 to clear slew_rate_irq_2
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_3;  // Write 1 and then 0 to clear slew_rate_irq_3
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_4;  // Write 1 and then 0 to clear slew_rate_irq_4
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_5;  // Write 1 and then 0 to clear slew_rate_irq_5
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_6;  // Write 1 and then 0 to clear slew_rate_irq_6
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_SRP_IRQ_CLR_slew_rate_irq_clr_7;  // Write 1 and then 0 to clear slew_rate_irq_7
             end
      11'h60  : begin//'h180
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_0_slew_rate_fault_count_0;  // Number of times that the slew rate limit was exceeded on Tx0. Max = 0xFF (8 bits)
             end
      11'h61  : begin//'h184
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_1_slew_rate_fault_count_1;  // Number of times that the slew rate limit was exceeded on Tx1. Max = 0xFF (8 bits)
             end
      11'h62  : begin//'h188
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_2_slew_rate_fault_count_2;  // Number of times that the slew rate limit was exceeded on Tx2. Max = 0xFF (8 bits)
             end
      11'h63  : begin//'h18C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_3_slew_rate_fault_count_3;  // Number of times that the slew rate limit was exceeded on Tx3. Max = 0xFF (8 bits)
             end
      11'h64  : begin//'h190
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_4_slew_rate_fault_count_4;  // Number of times that the slew rate limit was exceeded on Tx4. Max = 0xFF (8 bits)
             end
      11'h65  : begin//'h194
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_5_slew_rate_fault_count_5;  // Number of times that the slew rate limit was exceeded on Tx5. Max = 0xFF (8 bits)
             end
      11'h66  : begin//'h198
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_6_slew_rate_fault_count_6;  // Number of times that the slew rate limit was exceeded on Tx6. Max = 0xFF (8 bits)
             end
      11'h67  : begin//'h19C
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_PA_SRP_FAULT_7_slew_rate_fault_count_7;  // Number of times that the slew rate limit was exceeded on Tx7. Max = 0xFF (8 bits)
             end
      11'h68  : begin//'h1A0
                   IFP_axi_rw.rdata[0] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_0;  // Write 1 and then 0 to reset slew fault count for TX path 0
                   IFP_axi_rw.rdata[1] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_1;  // Write 1 and then 0 to reset slew fault count for TX path 1
                   IFP_axi_rw.rdata[2] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_2;  // Write 1 and then 0 to reset slew fault count for TX path 2
                   IFP_axi_rw.rdata[3] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_3;  // Write 1 and then 0 to reset slew fault count for TX path 3
                   IFP_axi_rw.rdata[4] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_4;  // Write 1 and then 0 to reset slew fault count for TX path 4
                   IFP_axi_rw.rdata[5] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_5;  // Write 1 and then 0 to reset slew fault count for TX path 5
                   IFP_axi_rw.rdata[6] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_6;  // Write 1 and then 0 to reset slew fault count for TX path 6
                   IFP_axi_rw.rdata[7] = FPGA_REG_PA_SRP_FAULT_CLR_slew_rate_fault_clr_7;  // Write 1 and then 0 to reset slew fault count for TX path 7
             end
      11'h7ff  : begin//'h1FFC
                   IFP_axi_rw.rdata[31:0] = FPGA_REG_INTR_SCRATCH_irq_scratch;  // 
               end
       endcase
   end
 end
///////////////////////////////////////////////



endmodule