// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 11/16/20                                                    //
// Module       : jb_pa_srp                                                   //
// Description  : Slew Rate Protection- a fast transient in the analog signal,//
//                such as from an IQ data glitch, results in a wide bandwidth //
//                pulse being delivered to the power amplifiers; even a single//
//                instance of this may be sufficient to damage the devices.   //
// ========================================================================== //
// ========================================================================== //
// Future Updates/Enhancements                                                //
// 1. Do we need to discard data based on tvalid?                             //
// ========================================================================== //

`timescale 1ns / 1ps

module jb_pa_srp  #(
    IQ_PRECISION = 16
) (
    input                               clk,
    input                               resetn,
    jb_axi4_stream_if.slave             IFP_axis_din,
    jb_axi4_stream_if.master            IFP_axis_dout,

    input           [16:0]              rf_slew_limit,              // MSB 17 of 33 bits
    input           [15:0]              rf_slew_duration_limit,
    input                               rf_slew_fault_count_clr,
    output  logic   [31:0]              rf_slew_fault_count,
    output  logic                       rf_slew_irq,
    input                               rf_slew_irq_mask,
    input                               rf_slew_irq_clr
);

    // ------------------------------------------------------------------ //
    // Parameters                                                         //
    // ------------------------------------------------------------------ //
    localparam      SLEW_CALC_DELAY         = 5;

    localparam      HAPPY                   = 2'd0,
                    SAD_FLUSH               = 2'd1,
                    SAD_STATE               = 2'd2;


    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //

    logic   [SLEW_CALC_DELAY-1:0] [IQ_PRECISION*2-1:0]  sample_slr = '{SLEW_CALC_DELAY{0}};
    logic   [SLEW_CALC_DELAY-1:0]                       tvalid_slr = '{SLEW_CALC_DELAY{0}};

    logic   [1:0]                   srp_state;
    logic   [1:0]                   srp_state_next;
    logic   [2:0]                   sad_flush_cntr;


    logic   [IQ_PRECISION*2-1:0]    iq_in_curr;
    logic   [IQ_PRECISION*2-1:0]    iq_in_prev;
    logic   [IQ_PRECISION*2-1:0]    iq_in_aligned;
    logic   [IQ_PRECISION*2-1:0]    iq_out_next;
    logic   [IQ_PRECISION*2-1:0]    iq_out;
    logic                           iq_out_next_ok;
    logic                           tvalid_aligned;
    logic                           tvalid_out;

    logic                           slew_error;
    logic                           sad_slew_err;
    logic                           sad_flushed;

    logic   [15:0]                  slew_err_duration_cntr;
    logic                           slew_err_duration_reached;
    logic                           rf_slew_irq_next;
    logic                           rf_slew_irq_clr_pp;

    logic   [7:0]                   slew_err_cntr;
    logic                           rf_slew_fault_count_clr_pp;

    // ------------------------------------------------------------------ //
    // Input sample stream                                                //
    // ------------------------------------------------------------------ //
    assign IFP_axis_din.tready = 1;

    always_ff @(posedge clk) begin
        sample_slr      <= {sample_slr[SLEW_CALC_DELAY-2:0], IFP_axis_din.tdata};
        tvalid_slr      <= {tvalid_slr[SLEW_CALC_DELAY-2:0], IFP_axis_din.tvalid};
    end

//  assign iq_in_curr       = IFP_axis_din.tvalid ? IFP_axis_din.tdata : 0;
    assign iq_in_curr       = IFP_axis_din.tdata;
    assign iq_in_prev       = sample_slr [0];

    // IQ samples aligned with the slew error indication. Slew calculation
    // and hence the error indication takes SLEW_CALC_DELAY cycles.
    assign iq_in_aligned    = sample_slr [SLEW_CALC_DELAY-1];
    assign tvalid_aligned   = tvalid_slr [SLEW_CALC_DELAY-1];

    // ------------------------------------------------------------------ //
    // Slew Rate Error Detector (SRED)                                    //
    // ------------------------------------------------------------------ //
    // Slew Rate Error Detector (SRED) compares n and n-1 samples.        //
    // It flags an error when slew rate is greater than the threshold.    //
    // Once an error is detected, iq_out stops updating and control is    //
    // now handed over to the Sample Alignment Detector (SAD)             //

    jb_iq_slew_err_det #(
        .IQ_PRECISION       (16)
    ) jb_iq_slew_sred (
        .clk                (clk),                      // i
        .resetn             (resetn),                   // i
        .iq_current         (iq_in_curr),               // i [31:0] {q,i}
        .iq_previous        (iq_in_prev),               // i [31:0] {q,i}
        .iq_slew_threshold  ({rf_slew_limit, 16'd0}),   // i [32:0]
        .iq_slew_error      (slew_error)                // o (5 cycle delayed)
    );

    // ------------------------------------------------------------------ //
    // Sample Alignment Detector (SAD)                                    //
    // ------------------------------------------------------------------ //
    // Sample Alignment Detector (SAD) compares n and last good sample.   //
    // Once a slew rate error is detected by SRED, we wait for Detector   //
    // Delay and then start monitoring SAD slew rate error.               //
    // 
    jb_iq_slew_err_det #(
        .IQ_PRECISION       (16)
    ) jb_iq_slew_sad (
        .clk                (clk),                      // i
        .resetn             (resetn),                   // i
        .iq_current         (iq_in_curr),               // i [31:0] {q,i}
        .iq_previous        (iq_out),                   // i [31:0] {q,i}
        .iq_slew_threshold  ({rf_slew_limit, 16'd0}),   // i [32:0]
        .iq_slew_error      (sad_slew_err)              // o (5 cycle delayed)
    );

    // ------------------------------------------------------------------ //
    // Slew Rate Protection (SRP) State Machine                           //
    // ------------------------------------------------------------------ //
    // HAPPY        : Monitor and report slew rate errors
    // SAD_FLUSH    : Once Slew Rate Error Detector has detected failure, //
    //                Sample Alignment Detector decision is invalid and   //
    //                must be ignored for det Delay (SLEW_CALC_DELAY).    //
    // SAD_STATE    : SAD decision (haha) becomes valid after flush. If   //
    //                no error is detected, we hand control back to SRED. //
    //                We don't need to check for slew_error when making a //
    //                transition from SAD_STATE to HAPPY because the      //
    //                aligned sample slew is OK compared to the held one. //
    //                If next sample has slew error, become SAD again!    //
    // ------------------------------------------------------------------ //

    always_ff @(posedge clk) begin
        if (!resetn)    srp_state <= HAPPY;
        else            srp_state <= srp_state_next;
    end

    always_comb begin
        case (srp_state)
            HAPPY       : srp_state_next = slew_error   ? SAD_FLUSH : HAPPY;
            SAD_FLUSH   : srp_state_next = sad_flushed  ? SAD_STATE : SAD_FLUSH;
            SAD_STATE   : srp_state_next = sad_slew_err ? SAD_STATE : HAPPY;
            default     : srp_state_next = HAPPY;
        endcase
    end

    always_ff @(posedge clk) begin
        if (!resetn)        
            sad_flush_cntr <= 0;
        else if ((srp_state == SAD_FLUSH) & ~sad_flushed)
            sad_flush_cntr++;
        else
            sad_flush_cntr <= 0;
    end

    assign sad_flushed = (sad_flush_cntr == SLEW_CALC_DELAY-1);


    // ------------------------------------------------------------------ //
    // Slew Rate Controlled Output                                        //
    // ------------------------------------------------------------------ //
    assign iq_out_next      = iq_in_aligned;

    assign iq_out_next_ok   = ((srp_state == HAPPY)     & !slew_error) |
                              ((srp_state == SAD_STATE) & !sad_slew_err);

    always_ff @(posedge clk) begin
        if (!resetn) begin
                iq_out  <= 0;
            tvalid_out  <= 0;
        end
        else begin
            if (iq_out_next_ok)
                iq_out  <= iq_out_next;
            tvalid_out  <= tvalid_aligned;
        end
    end


    assign IFP_axis_dout.tvalid = tvalid_out;
    assign IFP_axis_dout.tdata  = iq_out;
    assign IFP_axis_dout.tuser = 0;
    assign IFP_axis_dout.tkeep = 0;
    assign IFP_axis_dout.tlast = 0;

    // ------------------------------------------------------------------ //
    // Slew Violation Duration Counter                                    //
    // ------------------------------------------------------------------ //
    // DFE-072: When a slew rate error is detected, Slew Error Duration   //
    // counter is incremented for each sample period that passes while the//
    // DFE is holding the previous sample, waiting for a sample to satisfy//
    // the sample difference threshold. The Slew Error Duration counter   //
    // resets to 0 once an acceptable sample is encountered.              //
    // If the Slew Error Duration counter exceeds a configured threshold  //
    // then the FPGA raises an interrupt to signal software that the      //
    // transmit path has failed and must be restarted.                    //
    // ------------------------------------------------------------------ //

    always_ff @(posedge clk) begin
        if (!resetn)                            slew_err_duration_cntr <= 0;
        else if (iq_out_next_ok)                slew_err_duration_cntr <= 0;
        else if (!slew_err_duration_reached)    slew_err_duration_cntr++;
    end

    assign slew_err_duration_reached = (slew_err_duration_cntr == rf_slew_duration_limit);

    // Trigger when counter reaches the limit (not limit-1 since count
    // started with 1). Hold the count at limit so it doesn't continue 
    // and clear itself with a wrap around.
    // If slew recovers before irq is cleared, continue with normal opera-
    // tion. Software still needs to to clear irq.
    // If slew doesn't recover before irq is cleared - Fire irq again  

    always_comb begin
        if (rf_slew_irq_clr_pp)
                rf_slew_irq_next = 0;           // clear
        else if (~rf_slew_irq_mask & slew_err_duration_reached)
                rf_slew_irq_next = 1;           // set
        else
                rf_slew_irq_next = rf_slew_irq; // maintain

    end

    always_ff @(posedge clk) begin
        if (!resetn)    rf_slew_irq <= 0;
        else            rf_slew_irq <= rf_slew_irq_next;
    end

    jb_edge_det #(
        .SYNC_EN            (1),
        .EDGES              (1),    // pos
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1)     // pos
    ) rf_slew_irq_clr_pp_u0 (
        .clk                (clk),
        .mask               (0),
        .din                (rf_slew_irq_clr),
        .din_syncd          (/* open */),
        .dout               (rf_slew_irq_clr_pp)
    );


    // ------------------------------------------------------------------ //
    // Slew Violation Counter                                             //
    // ------------------------------------------------------------------ //
    // DFE-072: When a slew error is detected, Slew Rate Error counter is //
    // incremented once with each new slew rate error.                    //
    // RU software shall periodically read & clear the Slew Error counter.//
    // Error Counter Range = 1 - 100 (Default = 1)                        //
    // ------------------------------------------------------------------ //
    jb_edge_det #(
        .SYNC_EN            (1),
        .EDGES              (1),    // pos
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1)     // pos
    ) rf_slew_fault_count_clr_pp_u0 (
        .clk                (clk),
        .mask               (0),
        .din                (rf_slew_fault_count_clr),
        .din_syncd          (/* open */),
        .dout               (rf_slew_fault_count_clr_pp)
    );

    always_ff @(posedge clk) begin
        if (!resetn)        
            slew_err_cntr <= 0;
        else if (rf_slew_fault_count_clr_pp)
            slew_err_cntr <= 0;
        else if (((srp_state == HAPPY) & slew_error) & (slew_err_cntr != '1)) // Increment to max then hold
            slew_err_cntr++;
    end

    assign rf_slew_fault_count  = {24'd0, slew_err_cntr};


endmodule

