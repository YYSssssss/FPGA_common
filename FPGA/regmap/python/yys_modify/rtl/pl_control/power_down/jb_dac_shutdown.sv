`timescale 1ns / 1ps

module jb_dac_shutdown (
    input                       axi_resetn,
    input                       axi_clk,
    input                       clk_15p36,
    input                       psu_shutdown,
    output  logic               dac_shutdown
    );
    // ------------------------------------------------------------------ //
    // Parameters                                                         //
    // ------------------------------------------------------------------ //
    localparam  FLUSH_CYCLES = 512; // 4096 x1 cycles (33 us)
                
    // ------------------------------------------------------------------ //
    // Signals                                                            //
    // ------------------------------------------------------------------ //
    logic           [15:0]      flush_cnt = 0;
    logic                       max_cnt_reached;

    logic                       dac_shutdown_15p36  = 0;
    logic                       dac_shutdown_meta   = 0;
    logic                       dac_shutdown_sync   = 0;

    
    // ------------------------------------------------------------------ //
    // SM: sm_flush                                                       //
    // ------------------------------------------------------------------ //

    assign max_cnt_reached = (flush_cnt == FLUSH_CYCLES-1);
    
    always_ff @(posedge clk_15p36) begin
        if (!psu_shutdown)
            flush_cnt <= '0;
        else if (!max_cnt_reached)
            flush_cnt <= flush_cnt + 1;
    end

    // 001 = Scale output data by 0.5
    // 011 = Scale output data by 0.25
    // 111 = scale output data by 0
    // others = Normal Operation
    // 1 bit to 3 bit conversaion is in BD now
    always_ff @(posedge clk_15p36) begin
        dac_shutdown_15p36  <=  max_cnt_reached; //(max_cnt_reached ? 3'b111 : 3'b000);
      //pa_shutdown         <=  max_cnt_reached;
    end


    always_ff @(posedge axi_clk) begin
        if (!axi_resetn) begin
            dac_shutdown_meta   <= 0;
            dac_shutdown_sync   <= 0;
        end
        else begin
            dac_shutdown_meta   <= dac_shutdown_15p36;
            dac_shutdown_sync   <= dac_shutdown_meta;
        end
    end

    assign dac_shutdown = dac_shutdown_sync;

endmodule

