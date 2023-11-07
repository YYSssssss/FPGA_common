
`timescale 1ns / 1ps

module jb_edge_det #(
    parameter   SYNC_EN         = 1,        // Synchronize asynchronous input
    parameter   SYNC_STAGES     = 2,        // (0=invalid) Number of synchronizer flops
    parameter   EDGES           = 1,        //  0=neg, 1=pos, 2=both 
    parameter   PULSE_WIDTH     = 4,        // (0=invalid) Output pulse width
    parameter   PULSE_POLARITY  = 1,        //  0=neg, 1=pos
    parameter   RETIME_OUTPUT   = 1         // 1 = yes
) (
    input                       clk,
    input                       mask,       // Mask detection pulse
    input                       din,
    output                      din_syncd,  // Input synchronized
    output                      dout
);

    //localparam RESET_VALUE = EDGE ? = 0 : 1;
    localparam  NEG     = 0,
                POS     = 1,
                POS_NEG = 2;
    

    logic [SYNC_STAGES-1:0]     sync_ff             = 0;
    logic                       sync_out;
    
    logic                       detector_ff         = 0;
    logic                       edge_det_pulse_pos;
    logic                       edge_det_pulse_neg;
    logic                       edge_det_pulse;
    logic                       edge_det_pulse_m;
    
    logic [PULSE_WIDTH-1:0]     stretcher_ff; // reset?
    logic                       pulse_stretched;
    logic                       pulse_out;

    logic                       mask_temp;
    logic                       mask_sync;

    logic                       dout_ff             = 0;
    
    // ------------------------------------------------------------------ //
    // Synchronizer -                                                     //
    // ------------------------------------------------------------------ //
    
    always_ff @(posedge clk) begin
        sync_ff[0] <= din;
    end
    
    genvar i;
    generate
        for (i=1; i<SYNC_STAGES; i=i+1)
        begin : sync_stage
            always_ff @(posedge clk) begin
                sync_ff[i] <= sync_ff[i-1];
            end
        end
    endgenerate

    assign din_syncd   = sync_ff[SYNC_STAGES-1];
    assign sync_out    = SYNC_EN ? sync_ff[SYNC_STAGES-1] : din;
    
    
    // ------------------------------------------------------------------ //
    // Edge Detector -                                                    //
    // ------------------------------------------------------------------ //

    always_ff @(posedge clk) begin
        detector_ff <= sync_out;
    end

    assign edge_det_pulse_pos = ~detector_ff &  sync_out;
    assign edge_det_pulse_neg =  detector_ff & ~sync_out;

    always_comb
    begin
        if (EDGES == POS)
            edge_det_pulse = edge_det_pulse_pos;
        else if (EDGES == NEG)
            edge_det_pulse = edge_det_pulse_neg;
        else // POS_NEG
            edge_det_pulse = edge_det_pulse_pos | edge_det_pulse_neg;
    end


    // ------------------------------------------------------------------ //
    // Pulse Mask -                                                       //
    // ------------------------------------------------------------------ //
    always_ff @(posedge clk) begin
        mask_temp <= mask;
        mask_sync <= mask_temp;
    end
    
    assign edge_det_pulse_m = ~mask_sync & edge_det_pulse;


    // ------------------------------------------------------------------ //
    // Pulse Stretcher -                                                  //
    // ------------------------------------------------------------------ //
    // Starting pulse width is already 1. So start without a flop.

    assign stretcher_ff[0] = edge_det_pulse_m;
    
    generate
        for (i=1; i<PULSE_WIDTH; i=i+1)
        begin : stretch_stage
            always_ff @(posedge clk) begin
                stretcher_ff[i] <= stretcher_ff[i-1];
            end
        end
    endgenerate

    assign pulse_stretched = |stretcher_ff;
    assign pulse_out = PULSE_POLARITY ? pulse_stretched : ~pulse_stretched;

    // ------------------------------------------------------------------ //
    // Retiming -                                                         //
    // ------------------------------------------------------------------ //

    always_ff @(posedge clk) begin
        dout_ff <= pulse_out;
    end

    assign dout = RETIME_OUTPUT ? dout_ff : pulse_out;

    
endmodule

