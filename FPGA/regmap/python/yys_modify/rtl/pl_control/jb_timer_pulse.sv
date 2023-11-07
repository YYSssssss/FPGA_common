`timescale 1ns / 1ps

module jb_timer_pulse #(
    parameter MAX_COUNT_NUMBITS = 32
) (    
    input                               timer_clk,
    input                               resetn_15p36,
    input   [MAX_COUNT_NUMBITS-1:0]     max_count,
    output  logic                       timer_pulse = 0
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    logic   [MAX_COUNT_NUMBITS-1:0]     cntr_value;
    logic   [MAX_COUNT_NUMBITS-1:0]     cntr_window;
    logic 	                            cntr_enable;

    // ------------------------------------------------------------------ //
    // Timers                                                             //
    // ------------------------------------------------------------------ //
    assign cntr_enable   = (max_count != 0);
    assign cntr_window   = cntr_enable ? max_count : 0;   

    jb_cntr #(
        .COUNT_WIDTH        (MAX_COUNT_NUMBITS)
    ) u_jb_gen_rssi_cntr (
      .clk                  (timer_clk),
      .resetn               (resetn_15p36),
      .enable               (cntr_enable),
      .max_value            (cntr_window), 
      .cntr                 (cntr_value)
    );


    // ------------------------------------------------------------------ //
    // Timer Pulses                                                       //
    // ------------------------------------------------------------------ //
    always_ff @(posedge timer_clk) begin
        if (!resetn_15p36)  timer_pulse <= 0;
        else                timer_pulse <= (cntr_value == cntr_window-1);
    end

endmodule
	     
