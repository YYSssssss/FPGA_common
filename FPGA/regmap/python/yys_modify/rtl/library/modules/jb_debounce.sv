
`timescale 1ns / 1ps

module jb_debounce #(
    parameter   SYNC_STAGES     = 2,        // (0=invalid) Number of synchronizer flops
    parameter   STABLE_CYCLES   = 16,       // Number of clk cycles the input must stay stable
    parameter   COUNTER_BITS    = 8         // Try to use log2(STABLE_CYCLES), but careful with synth
) (
    input                       clk,
    input                       din,
    output  logic               dout = 0
);


    logic   [SYNC_STAGES:0]     din_d       = 0;
    logic                       din_stable;
    logic   [COUNTER_BITS-1:0]  cntr = 0;
    logic                       stop_cntr;
    
    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //

    // Synchronize Input
    always_ff @(posedge clk) begin
        din_d <= {din_d[SYNC_STAGES-1:0], din};
    end

    
    // Input is stable if sync bit is same as delayd sync bit
    assign din_stable = (din_d[SYNC_STAGES] == din_d[SYNC_STAGES-1]);
    
    
    // Count specified number of cycles and then stop
    // Resets to 0 when the signal changes state again

    assign stop_cntr = (cntr == STABLE_CYCLES-1);

    always_ff @(posedge clk) begin
        if (!din_stable)    cntr <= 0;
        else if (!stop_cntr)  cntr <= cntr + 1;
    end


    always_ff @(posedge clk) begin
        if (stop_cntr)
            dout <= din_d[SYNC_STAGES];
    end
    
endmodule

