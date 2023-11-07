// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : Fei Qin                                                     //
// Date         : 02/07/21                                                    //
// File         : top_irq.v                                                   //
// Design       :                                                             //
// Purpose      : Vernon Board Controls                                       //
// Device       : xczu47dr-fsve1156-2-i                                       //
// -------------------------------------------------------------------------- //
`timescale 1ns / 1ps

module jb_vernon_top_irq #(
    parameter N_CARRIERS    = 2,
    parameter N_ANTENNAS    = 8
) (
    input 	                            clk,
    jb_intr_ctrl_if.intr_ctrl           IFP_regs,
    input           [4:1]               irq_alarm,
	input 	                            irq_adc_dac,	
    input           [N_ANTENNAS-1:0]    irq_adc_threshold1,
    input           [N_ANTENNAS-1:0]    irq_adc_threshold2,
    input           [N_ANTENNAS-1:0]    adc_over_range,
    input           [N_ANTENNAS-1:0]    adc_over_voltage,
	input                               irq_psu_alarm,
   //send these signals to status registers 
    output logic    [7:0]               pl_ps_irq0,
    output logic    [7:0]               pl_ps_irq1,
    input           [1:0]               sfp_los,
    input           [1:0]               sfp_tx_fault,
    input           [1:0]               sfp_detect_n
);

    // ------------------------------------------------------------------ //
    // Parameters                                                         //
    // ------------------------------------------------------------------ //
    localparam      VCC         = 1'b1;
    localparam      GND         = 1'b0;
    localparam      NEG         = 0,
                    POS         = 1,
                    POS_NEG     = 2;
                
    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    logic           [4:1]               irq_alarm_db; // debounced
    logic           [4:1]               irq_alarm_mask;
    logic           [N_ANTENNAS-1:0]    irq_adc_threshold2_mask;
    logic           [N_ANTENNAS-1:0]    irq_adc_threshold2_temp;
    logic           [N_ANTENNAS-1:0]    irq_adc_threshold1_mask;
    logic           [N_ANTENNAS-1:0]    irq_adc_threshold1_temp;
    logic                               irq_dbg_pp;
	
    logic           [1:0]               irq_sfp_los_temp;
	logic           [1:0]               sfp_los_mask;	
	logic           [1:0]               irq_sfp_tx_fault_temp;
	logic           [1:0]               sfp_tx_fault_mask;
	
	logic                               irq_ext_alarm_db;   // debounced

    // ------------------------------------------------------------------ //
    // PS Interrupt Assignments                                           //
    // ------------------------------------------------------------------ //
    // From TRM - UG1085 v1.9, page 307                                   //
    // The minimum interrupt pulse width for detection is 4 clock periods //
    // of the GIC, which is normally a 100MHz clk resulting in a minimum  //
    // 40 ns pulse width. The signal synchronizers might detect a shorter //
    // pulse, but it not guaranteed. Glitches should be avoided.          //
    // ------------------------------------------------------------------ //

    assign pl_ps_irq0[7] = GND; 
    assign pl_ps_irq0[6] = GND;
    assign pl_ps_irq0[5] = GND;
    assign pl_ps_irq0[4] = GND;
    assign pl_ps_irq0[3] = GND;
    assign pl_ps_irq0[2] = GND;
    assign pl_ps_irq0[1] = GND;
    assign pl_ps_irq0[0] = IFP_regs.pl_master_irq;
    
    assign pl_ps_irq1[7] = GND;
    assign pl_ps_irq1[6] = GND;
    assign pl_ps_irq1[5] = GND;
    assign pl_ps_irq1[4] = GND;
    assign pl_ps_irq1[3] = GND;
    assign pl_ps_irq1[2] = GND;
    assign pl_ps_irq1[1] = GND;
    assign pl_ps_irq1[0] = GND;

    // ------------------------------------------------------------------ //
    // Interrupt Masks                                                    //
    // ------------------------------------------------------------------ //
    assign  irq_adc_threshold1_mask[0]      = IFP_regs.adc_over_threshold1_mask[0];
    assign  irq_adc_threshold1_mask[1]      = IFP_regs.adc_over_threshold1_mask[1];
    assign  irq_adc_threshold1_mask[2]      = IFP_regs.adc_over_threshold1_mask[2];
    assign  irq_adc_threshold1_mask[3]      = IFP_regs.adc_over_threshold1_mask[3];
    assign  irq_adc_threshold1_mask[4]      = IFP_regs.adc_over_threshold1_mask[4];
    assign  irq_adc_threshold1_mask[5]      = IFP_regs.adc_over_threshold1_mask[5];
    assign  irq_adc_threshold1_mask[6]      = IFP_regs.adc_over_threshold1_mask[6];
    assign  irq_adc_threshold1_mask[7]      = IFP_regs.adc_over_threshold1_mask[7];
			 						        
    assign  irq_adc_threshold2_mask[0]      = IFP_regs.adc_over_threshold2_mask[0];
    assign  irq_adc_threshold2_mask[1]      = IFP_regs.adc_over_threshold2_mask[1];
    assign  irq_adc_threshold2_mask[2]      = IFP_regs.adc_over_threshold2_mask[2];
    assign  irq_adc_threshold2_mask[3]      = IFP_regs.adc_over_threshold2_mask[3];
    assign  irq_adc_threshold2_mask[4]      = IFP_regs.adc_over_threshold2_mask[4];
    assign  irq_adc_threshold2_mask[5]      = IFP_regs.adc_over_threshold2_mask[5];
    assign  irq_adc_threshold2_mask[6]      = IFP_regs.adc_over_threshold2_mask[6];
    assign  irq_adc_threshold2_mask[7]      = IFP_regs.adc_over_threshold2_mask[7];
			 						        
    assign  irq_alarm_mask[1]               = IFP_regs.ext_alarm_mask[0];
    assign  irq_alarm_mask[2]               = IFP_regs.ext_alarm_mask[1];
    assign  irq_alarm_mask[3]               = IFP_regs.ext_alarm_mask[2];
    assign  irq_alarm_mask[4]               = IFP_regs.ext_alarm_mask[3];
			 						        
	assign  sfp_los_mask[0]                 = IFP_regs.sfp0_los_mask;
	assign  sfp_los_mask[1]                 = IFP_regs.sfp1_los_mask;
	assign  sfp_tx_fault_mask[0]            = IFP_regs.sfp0_tx_fault_mask;
	assign  sfp_tx_fault_mask[1]            = IFP_regs.sfp1_tx_fault_mask;	 
	
    assign  IFP_regs.adc_over_threshold1[0] = irq_adc_threshold1[0];
    assign  IFP_regs.adc_over_threshold1[1] = irq_adc_threshold1[1];
    assign  IFP_regs.adc_over_threshold1[2] = irq_adc_threshold1[2];
    assign  IFP_regs.adc_over_threshold1[3] = irq_adc_threshold1[3];
    assign  IFP_regs.adc_over_threshold1[4] = irq_adc_threshold1[4];
    assign  IFP_regs.adc_over_threshold1[5] = irq_adc_threshold1[5];
    assign  IFP_regs.adc_over_threshold1[6] = irq_adc_threshold1[6];
    assign  IFP_regs.adc_over_threshold1[7] = irq_adc_threshold1[7];

    assign  IFP_regs.adc_over_threshold2[0] = irq_adc_threshold2[0];
    assign  IFP_regs.adc_over_threshold2[1] = irq_adc_threshold2[1];
    assign  IFP_regs.adc_over_threshold2[2] = irq_adc_threshold2[2];
    assign  IFP_regs.adc_over_threshold2[3] = irq_adc_threshold2[3];
    assign  IFP_regs.adc_over_threshold2[4] = irq_adc_threshold2[4];
    assign  IFP_regs.adc_over_threshold2[5] = irq_adc_threshold2[5];
    assign  IFP_regs.adc_over_threshold2[6] = irq_adc_threshold2[6];
    assign  IFP_regs.adc_over_threshold2[7] = irq_adc_threshold2[7];
	
 // Real-time, not debounced
    assign  IFP_regs.ext_alarm[0]           = irq_alarm[1];    
    assign  IFP_regs.ext_alarm[1]           = irq_alarm[2];
    assign  IFP_regs.ext_alarm[2]           = irq_alarm[3];    
    assign  IFP_regs.ext_alarm[3]           = irq_alarm[4];
										    
    assign  IFP_regs.sfp0_los               = sfp_los[0];     
    assign  IFP_regs.sfp1_los               = sfp_los[1];
    assign  IFP_regs.sfp0_tx_fault          = sfp_tx_fault[0];
    assign  IFP_regs.sfp1_tx_fault          = sfp_tx_fault[1];
    assign  IFP_regs.sfp0_detect_n          = sfp_detect_n[0];
    assign  IFP_regs.sfp1_detect_n          = sfp_detect_n[1];  
										    
    assign  IFP_regs.adc_over_range         = adc_over_range;
    assign  IFP_regs.adc_over_voltage       = adc_over_voltage;
	
    // ------------------------------------------------------------------ //
    // ------------------------------------------------------------------ //
	logic  [6:0]    pl_irq_sticky;
	logic           irq_adc_threshold ;
	logic  			irq_sfp;
    logic  			irq_ext_alarm;
	logic           irq_sfp_1d;
	logic           irq_sfp_2d;
	logic           irq_psu_alarm_1d;
	logic           irq_psu_alarm_2d;
	assign          irq_adc_threshold = (|irq_adc_threshold1) || (|irq_adc_threshold2);
	assign 			irq_sfp           = (|sfp_los) || (|sfp_tx_fault);
    assign 			irq_ext_alarm     = |irq_alarm;

	always_ff @(posedge clk) begin
		irq_sfp_1d <= irq_sfp;
		irq_sfp_2d <= irq_sfp_1d;
    end
	
	always_ff @(posedge clk) begin
		irq_psu_alarm_1d <= irq_psu_alarm;
		irq_psu_alarm_2d <= irq_psu_alarm_1d;
    end
		
	always_ff @(posedge clk) begin
        if (irq_adc_dac == 1'b1 && (!IFP_regs.pl_irq_mask[1]))
			pl_irq_sticky[1] <= 1'b1;
		else if (IFP_regs.pl_irq_clear[1] == 1'b1) 
			pl_irq_sticky[1] <= 1'b0;
			
    end
	
	always_ff @(posedge clk) begin
		if (irq_adc_threshold == 'b1 && (!IFP_regs.pl_irq_mask[2]))
			pl_irq_sticky[2] <= 'b1;
		else if ( IFP_regs.pl_irq_clear[2] == 1'b1 )
			pl_irq_sticky[2] <= 'b0;	
	end
		
	always_ff @(posedge clk) begin
        if (irq_ext_alarm_db == 1'b1 && (!IFP_regs.pl_irq_mask[3]))
			pl_irq_sticky[3] <= 1'b1;
		else if (IFP_regs.pl_irq_clear[3] == 1'b1) 
			pl_irq_sticky[3] <= 1'b0;
	end

	always_ff @(posedge clk) begin
		if (irq_sfp_2d == 'b1 && (!IFP_regs.pl_irq_mask[4]))
			pl_irq_sticky[4] <= 'b1;
		else if ( IFP_regs.pl_irq_clear[4] == 1'b1 )
			pl_irq_sticky[4] <= 'b0;	
	end

	always_ff @(posedge clk) begin
        if (irq_psu_alarm_2d == 1'b1 && (!IFP_regs.pl_irq_mask[5]))
			pl_irq_sticky[5] <= 1'b1;
		else if (IFP_regs.pl_irq_clear[5] == 1'b1) 
			pl_irq_sticky[5] <= 1'b0;
	end

     
    jb_debounce u_irq_ext_alarm_db(
        .clk                (clk),
        .din                (irq_ext_alarm),
        .dout               (irq_ext_alarm_db)
    );      
	
   assign  IFP_regs.pl_irq[0]           = pl_irq_sticky[0];
   assign  IFP_regs.pl_irq[1]           = pl_irq_sticky[1];
   assign  IFP_regs.pl_irq[2]           = pl_irq_sticky[2];
   assign  IFP_regs.pl_irq[3]           = pl_irq_sticky[3];
   assign  IFP_regs.pl_irq[4]           = pl_irq_sticky[4];
   assign  IFP_regs.pl_irq[5]           = pl_irq_sticky[5];  
   assign  IFP_regs.pl_irq[31]          = pl_irq_sticky[6];
   
   assign  IFP_regs.pl_master_irq       = |pl_irq_sticky;	
endmodule
