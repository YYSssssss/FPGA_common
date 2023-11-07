

`timescale 1ns / 1ps

module jb_agc_adcp #(
    parameter ATTN_SET  = 24
) (
    input                       axi_clk,
    input                       clk_en,
    input                       axi_reset,
    input                       adc_over_range,
    input                       adc_over_voltage,
    input                       adcp_disable,

    input           [6:0]       ps_rxdsa,
    output  logic   [6:0]       pl_rxdsa,
    output  logic   [6:0]       rx_dsa_d,
    output  logic               rx_dsa_le,
    output  logic               service = 0,
    input                       service_done,  
    input                       ps_bypass_lna,
    output  logic               rx_lna_bypass
);

    localparam      DSA_ATTN_MAX            = 7'h7F;
    localparam      DSA_ATTN_INC            = 7'd24; // 6dB = 0.25 x 24
    localparam      DSA_ATTN_MAX_MINUS_INC  = DSA_ATTN_MAX - DSA_ATTN_INC;

/*    
    localparam      S_IDLE                  = 2'd0,
                    S_OVER_VOLTAGE          = 2'd1,
                    S_OVER_RANGE            = 2'd2,
                    S_PS_UPDATE             = 2'd3;

    logic   [1:0]       adcp_state      = S_IDLE;
    logic   [1:0]       adcp_state_next = S_IDLE;
*/
    logic               adc_over_range_s;       // Syncd
    logic               adc_over_range_p;       // Pulse
    logic               adc_over_range_valid;   // 
    logic               adc_over_voltage_s;     // Syncd
    logic               adc_over_voltage_p;     // Pulse
    logic               adc_over_voltage_valid; //
    logic               ignore_ps_req;
    logic               ps_update_req;
    logic               ps_update_req_valid;
    logic   [6:0]       ps_rxdsa_d1 = 7'h7F;
    logic   [6:0]       ps_rxdsa_d2 = 7'h7F;
    (* dont_touch = "true" *) logic   [6:0]       rxdsa       = 7'h7F;
    (* dont_touch = "true" *) logic   [6:0]       rxdsa_copy  = 7'h7F;
    logic   [6:0]       rxdsa_next;
    logic   [6:0]       adcp_rxdsa;

    // ------------------------------------------------------------------ //
    // PS interface                                                       //
    // ------------------------------------------------------------------ //
    always_ff @(posedge axi_clk) begin
        if (clk_en) begin
            ps_rxdsa_d1     <= ps_rxdsa;
            ps_rxdsa_d2     <= ps_rxdsa_d1;
            ps_update_req   <= (ps_rxdsa_d1 != ps_rxdsa_d2);
        end
    end

    //assign ps_update_req = (ps_rxdsa_d2 != ps_rxdsa_d1);

    // Ignore PS request when real-time over-range or over-voltage alarms
    // are present, unless adcp is disabled.
    // Over-Voltage is self-cleared asynchronously when the condition is
    // no longer present. The associated interrupt is sticky.
    // Over-Range real-time alarm and the associated interrupt are both
    // sticky. Both are cleared by the PS interrupt handling.
    assign ignore_ps_req = ~adcp_disable & (adc_over_range_s | adc_over_voltage_s);

    // Not retimed to save adcp response time.
    assign ps_update_req_valid = ~ignore_ps_req & ps_update_req;
    //assign ps_update_req_valid = (adcp_disable | ~ignore_ps_req) & ps_update_req;

//    always_ff @(posedge axi_clk) begin
//        ps_update_req_valid <= ~ignore_ps_req & ps_update_req;
//    end
    
    // ------------------------------------------------------------------ //
    // ADC real-time signals                                              //
    // ------------------------------------------------------------------ //
    // Because we are retiming/synchronizing over_voltage and over_range,
    // input glitches smaller than a clock pulse may go undetected.
    
    assign adc_over_voltage_valid   = ~adcp_disable & adc_over_voltage_s;  // note: not pulse
    assign adc_over_range_valid     = ~adcp_disable & adc_over_range_p;    // pulse (edge detect)

    // Synchronize and edge detect ADC real-time signals
    jb_edge_det #(
        .SYNC_EN            (1),
        .SYNC_STAGES        (2),
        .EDGES              (1),
        .PULSE_WIDTH        (4), // This is extended to match clock_en.
        .PULSE_POLARITY     (1),
        .RETIME_OUTPUT      (1)
    ) edge_det_over_range_u1 (
        .clk                (axi_clk),
        .mask               (1'b0),
        .din                (adc_over_range),
        .din_syncd          (adc_over_range_s),
        .dout               (adc_over_range_p)
    );

    jb_edge_det #(
        .SYNC_EN            (1),
        .SYNC_STAGES        (2),
        .EDGES              (1),
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1),
        .RETIME_OUTPUT      (1)
    ) edge_det_over_voltage_u1 (
        .clk                (axi_clk),
        .mask               (1'b0),
        .din                (adc_over_voltage),
        .din_syncd          (adc_over_voltage_s),
        .dout               (adc_over_voltage_p)
    );


    // ------------------------------------------------------------------ //
    // ADCP State Machine                                                 //
    // ------------------------------------------------------------------ //
    // ADC Over-Voltage and Over-Range conditions are communicated with   //
    // the PS via interrupts generated in the RF Data Converter IP.       //
    // If ADCP is disabled, PL doesn't respond to the ADC alarms and PS   //
    // has direct control of the DSA settings.                            //
    // Over-Voltage condition takes priority over Over-Range.             //
    // PS can override anytime unless there's an over-voltage alarm.      //
    // ------------------------------------------------------------------ //
/*    
    always_ff @(posedge axi_clk) begin
        adcp_state <= adcp_state_next;
    end

    always_comb begin
        case (adcp_state)
            S_IDLE          :   if (adc_over_voltage_valid)     adcp_state_next = S_OVER_VOLTAGE;
                                else if (adc_over_range_valid)  adcp_state_next = S_OVER_RANGE;
                                else if (ps_update_req_valid)   adcp_state_next = S_PS_UPDATE;
                                else                            adcp_state_next = S_IDLE;
            S_OVER_VOLTAGE  :   adcp_state_next = (adc_over_voltage_valid ? S_OVER_VOLTAGE : S_IDLE);
            S_OVER_RANGE    :   adcp_state_next = S_IDLE; 
            S_PS_UPDATE     :   begin
                                    // Check for over_range pulse, so we dont miss an edge detect pulse
                                    // Dont need to check for over_voltage because we're not using a pulse for it.
                                    // This may not be necessary due to timing of pulse generation. Check later.
                                    adcp_state_next = adc_over_range_valid ? S_OVER_RANGE : S_IDLE;
                                end
            default         : adcp_state_next = S_IDLE;
        endcase
    end
*/
    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    // PL always stores the current/actual DSA settings in RO registers   //
    // PS can read these register to get the current attenuation value    //

    assign rx_dsa_d = rxdsa_copy;
    assign pl_rxdsa = rxdsa_copy;
    
    always_ff @(posedge axi_clk) begin
        if (clk_en) begin
            rxdsa       <= rxdsa_next;  // Synthesis dont touch
            rxdsa_copy  <= rxdsa_next;  // Synthesis dont touch
        end
    end

    // adc_over_voltage_valid:  Level
    // adc_over_range_valid:    Pulse
    // ps_update_req_valid:     Pulse ignored if over-range/over-voltage
    //                          real-time signals (syncd) are present.
    
    always_comb begin
        // prioritized
        if      (adc_over_voltage_valid)    rxdsa_next = DSA_ATTN_MAX;
        else if (adc_over_range_valid)      rxdsa_next = adcp_rxdsa;
        else if (ps_update_req_valid)       rxdsa_next = ps_rxdsa;
        else                                rxdsa_next = rxdsa;
    end

    // ------------------------------------------------------------------ //
    // Attenuation Settings:                                              //
    //      Device defaults to the max atten of 31.75dB at power up.      //
    //      *** 0.25dB increment                                          //
    //          0000000 = 0 dB                                            //
    //          0011000 = 6 dB      (24  * 0.25)                          //
    //          1111111 = 31.75dB   (127 * 0.25)                          //
    //              D6 = 16    dB attenuation                             //
    //              D5 =  8    dB attenuation                             //
    //              D4 =  4    dB attenuation                             //
    //              D3 =  2    dB attenuation                             //
    //              D2 =  1    dB attenuation                             //
    //              D1 =  0.5  dB attenuation                             //
    //              D0 =  0.25 dB attenuation                             //
    // ------------------------------------------------------------------ //
    // Check for rollover settings and clip at max
    always_comb begin
        if (rxdsa > DSA_ATTN_MAX_MINUS_INC) 
            adcp_rxdsa = DSA_ATTN_MAX;
        else
            adcp_rxdsa = rxdsa + DSA_ATTN_INC;
        
    end

    // ------------------------------------------------------------------ //
    // RX LNA Bypass                                                      //
    // ------------------------------------------------------------------ //
    assign rx_lna_bypass = ps_bypass_lna;
    
    
    // LE Delayed once to align with data. Another to add offset needed by DSA
    
    always_ff @(posedge axi_clk) begin
        if (clk_en) begin
            rx_dsa_le <= ps_update_req_valid;
        end
    end
    
    // Edge detect any of the valid changes  SM 
     logic valid;
     logic valid_d;
     logic new_service = 0;
     
     assign valid = ps_update_req_valid | adc_over_voltage_valid | adc_over_range_valid;
     always_ff @(posedge axi_clk) begin
        if (clk_en) begin
            valid_d <= valid;
        end
     end
     
//     always_ff @(posedge axi_clk) begin
//        if (valid &&  ~valid_d) service <= 1'b1;
//        else if (service_done && ~new_service)  service <= 1'b0;
//     end  

//     always_ff @(posedge axi_clk) begin
//        if ((valid &&  ~valid_d) && service) new_service <= 1'b1;  // another service before done
//        else if (service_done) new_service <= 1'b0;  // Remove when setting next service
//     end
   
     always_ff @(posedge axi_clk) begin
        if (clk_en) begin
            if (valid &&  ~valid_d) service <= 1'b1;   // Detect change
            //else if (new_service && service) service <= 1'b0;  // If new service and current service, remove service
            else if (new_service && ~service) service <= 1'b1; // If new service and not current service, set service
            else if (service_done)  service <= 1'b0;  // Remove service when doen
        end
     end  

     always_ff @(posedge axi_clk) begin
        if (clk_en) begin
            if ((valid &&  ~valid_d) && service) new_service <= 1'b1;  // another service before done
            else if (new_service && service && service_done) new_service <= 1'b1;  // If new service and current service don't remove new service if done comes during same clock
            else if (new_service && ~service) new_service <= 1'b0;   // Remove new service when current service is done
            else if (service_done) new_service <= 1'b0;  // Remove when when done
        end
     end

endmodule

