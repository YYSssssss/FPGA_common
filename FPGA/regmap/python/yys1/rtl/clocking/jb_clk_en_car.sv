// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 10/01/19                                                    //
// Module       : jb_clk_en_car                                               //
// Description  :                                                             //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
// ========================================================================== //
// Generates divided clock enable based on Bandwidth settings
//                  Bandwidth   20          10          5           15
//               122.88 Clk  (/1)122.88    (/2)61.44   (/4)30.72   (?)368.64?
//               491.52 Clk  (/1)491.52    (/2)245.76  (/4)122.88  (?)368.64?
// ========================================================================== //
// To-Do:
//     * Add dfe reset
// ========================================================================== //
`timescale 1ns / 1ps

module jb_clk_en_car #(
    parameter DEFAULT_BW = 2'b00
) (
    input                       clk_x4,
    input                       clk_x1,
  //input                       clk_368p64,
    input                       car_en,
    input           [1:0]       car_bw,
    output  logic               car_resetn = 0,
    output  logic               dfe_flush,
    output  logic               clk_x4_en,
    output  logic               clk_x1_en,
    output  logic               clk_x8_en,
    output  logic               clk_x16_en,
    output  logic               clk_x4_fft_en
    );
    // ------------------------------------------------------------------ //
    // Parameters                                                         //
    // ------------------------------------------------------------------ //
    localparam  ENABLED             = 1'b1;
    localparam  DISABLED            = 1'b0;
    localparam  SM_FLUSH_IDLE       = 0,
                SM_FLUSH_WAIT       = 1,
                SM_RST_ON           = 2,
                SM_RST_ON_WAIT      = 3,
                SM_CLK_OFF          = 4,
                SM_CLK_OFF_WAIT     = 5,
                SM_RST_OFF          = 6,
                SM_RST_OFF_WAIT     = 7;
                
    localparam  FLUSH_CYCLES_X1 = 2048;
    localparam  CLKEN_CYCLES_X1 = 16;
                
    `include  "jb_common.svh"
/*
    // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    localparam  BW_20MHZ    = 0,
                BW_10MHZ    = 1,
                BW_5MHZ     = 2,
                BW_15MHZ    = 3;
*/
    // ------------------------------------------------------------------ //
    // Signals                                                            //
    // ------------------------------------------------------------------ //
    logic                       car_en_temp = 0;
    logic                       car_en_sync = 0;
    logic                       car_en_d1 = 0;
    logic                       rst_x1clk;
    logic                       rst_x4clk;
    logic           [7:0]       rst_x4clk_dly;
    
    logic                       car_en_qualified;
    logic                       car_disable_pulse;
    logic                       car_enable_pulse;
    logic           [1:0]       car_bw_sync = DEFAULT_BW;

    logic           [2:0]       sm_flush = SM_FLUSH_IDLE;
    logic           [2:0]       sm_flush_next;
    logic                       sm_flush_busy = 0;
    logic           [15:0]      flush_cnt = 0;
    logic                       flush_cnt_en;
    logic                       turn_clks_off;
    logic                       turn_clks_on = 0;
    logic                       rst_clks = 1'b1;
    logic                       rst_clks_d1 = 1'b1;
    logic                       rst_clks_d2 = 1'b1;

    logic                       clk_x1_en_div1;
    logic                       clk_x1_en_div2;
    logic                       clk_x1_en_div4;
    logic                       clk_x1_en_div8;
    logic                       clk_x1_en_div16;
    logic                       clk_x1_en_next;
    
    logic                       clk_x4_en_div1;
    logic                       clk_x4_en_div2;
    logic                       clk_x4_en_div4;
    logic                       clk_x4_en_div8;
    logic                       clk_x4_en_div16;
    logic                       clk_x4_en_next;
    
    logic                       clk_x8_en_next;
    logic                       clk_x16_en_next;
    logic                       clk_x4_fft_en_next;

    // ------------------------------------------------------------------ //
    // Pulses for starting and shutting down clock enables                //
    // ------------------------------------------------------------------ //
    // Once shutdown is initiated (i.e. sm_flush busy due to car_en being 
    // deasserted), inhibit car_en from turning on again until the entire 
    // shutdown sequnence is complete (i.e sm_flush is no longer busy).
    assign car_en_qualified = car_en & ~sm_flush_busy;
    
    always_ff @(posedge clk_x1) begin
        car_en_temp     <=  car_en_qualified;
        car_en_sync     <=  car_en_temp;
        car_en_d1       <=  car_en_sync;
        turn_clks_on    <=  car_enable_pulse;
    end

    assign car_disable_pulse    = ~car_en_sync &  car_en_d1;
    assign car_enable_pulse     =  car_en_sync & ~car_en_d1;

    // Use early pulse to latch car_bw so we can multi-cycle paths from
    // car_bw_sync to enables on the 4x clock.
    // A delayed version of car_enable_pulse (turn_clks_on) is used to
    // bring clock enables out of reset.
    always_ff @(posedge clk_x1) begin
        if (car_enable_pulse)
            car_bw_sync <= car_bw;
    end
    
    // ------------------------------------------------------------------ //
    // SM: sm_flush                                                       //
    // ------------------------------------------------------------------ //
    // When carrier is disabled, we wait for the data to flush through the
    // DFE pipelines before shutting down the clock enables.
    // Use the slowest available clock

    // SM_FLUSH_IDLE:       Wait for carrier disable pulse
    // SM_FLUSH_WAIT:       Allow time for DFE pipeline flush
    // SM_CLK_OFF:    Initiate clock enables shutdown
    // SM_CLK_OFF_WAIT:   Allow time for graceful shutdown of enables
    
    assign dfe_flush = sm_flush_busy;
    
    always_ff @(posedge clk_x1) begin
        sm_flush <= sm_flush_next;
        sm_flush_busy <= (sm_flush != SM_FLUSH_IDLE);
    end
        
    always_comb begin
        case (sm_flush)
            SM_FLUSH_IDLE       : sm_flush_next = car_disable_pulse ? SM_FLUSH_WAIT : SM_FLUSH_IDLE;
            SM_FLUSH_WAIT       : sm_flush_next = (flush_cnt == (FLUSH_CYCLES_X1-1)) ? SM_RST_ON : SM_FLUSH_WAIT;
            SM_RST_ON           : sm_flush_next = SM_RST_ON_WAIT;
            SM_RST_ON_WAIT      : sm_flush_next = (flush_cnt == 'hF) ? SM_CLK_OFF : SM_RST_ON_WAIT; // This is to relax timing
            SM_CLK_OFF          : sm_flush_next = SM_CLK_OFF_WAIT;
            SM_CLK_OFF_WAIT     : sm_flush_next = (flush_cnt == (CLKEN_CYCLES_X1-1)) ? SM_RST_OFF : SM_CLK_OFF_WAIT;
            SM_RST_OFF          : sm_flush_next = SM_RST_OFF_WAIT;
            SM_RST_OFF_WAIT     : sm_flush_next = (flush_cnt == 'hF) ? SM_FLUSH_IDLE : SM_RST_OFF_WAIT;
            default             : sm_flush_next = SM_FLUSH_IDLE;
        endcase
    end

    assign flush_cnt_en = (sm_flush == SM_FLUSH_WAIT) | (sm_flush == SM_RST_ON_WAIT) | (sm_flush == SM_CLK_OFF_WAIT) | (sm_flush == SM_RST_OFF_WAIT);
    
    always_ff @(posedge clk_x1) begin
        if (!flush_cnt_en)
            flush_cnt <= '0;
        else
            flush_cnt <= flush_cnt + 1;
    end

    assign turn_clks_off = (sm_flush == SM_CLK_OFF);
    
    always_ff @(posedge clk_x1) begin
        if      (turn_clks_on)      rst_clks <= 1'b0;   // 1st Priority: Immediate Deassertion
        else if (turn_clks_off)     rst_clks <= 1'b1;   // 2nd Priority: Delayed Assertion
        rst_clks_d1 <= rst_clks;
        rst_clks_d2 <= rst_clks_d1;
    end
    
    // Align rst_x1clk
    assign rst_x1clk    = rst_clks_d1;
    
    // Align rst_x4clk
    always_ff @(posedge clk_x4) begin
        rst_x4clk_dly[0]   <= rst_clks_d2;
        for (int i = 1; i <= 7; i = i + 1) begin
            rst_x4clk_dly[i] <= rst_x4clk_dly[i-1];
        end
    end

    assign rst_x4clk    = rst_x4clk_dly[1];   // 2 cycle delay to align with 122.88


    // External logic reset - assert when clocks are running and deasserted
    // after stopping clocks. This should relax timing requirements.
    always_ff @(posedge clk_x1) begin
        if      (sm_flush == SM_RST_ON)
            car_resetn <= 1'b0;
        else if ((sm_flush == SM_RST_OFF) | (sm_flush == SM_FLUSH_IDLE))
            car_resetn <= 1'b1;
    end

    // ------------------------------------------------------------------ //
    // Clock Enables Generation                                           //
    // ------------------------------------------------------------------ //
    jb_clk_en_gen clk_x1_en_u1 (
        .clk                    (clk_x1),               // i
        .reset                  (rst_x1clk),            // i
        .clk_en_div1            (clk_x1_en_div1),       // o
        .clk_en_div2            (clk_x1_en_div2),       // o
        .clk_en_div4            (clk_x1_en_div4),       // o
        .clk_en_div8            (clk_x1_en_div8),       // o  // SM Added div8
        .clk_en_div16           (clk_x1_en_div16)       // o  // SM Added div16
    );

    jb_clk_en_gen clk_x4_en_u1 (
        .clk                    (clk_x4),               // i
        .reset                  (rst_x4clk),            // i
        .clk_en_div1            (clk_x4_en_div1),       // o
        .clk_en_div2            (clk_x4_en_div2),       // o
        .clk_en_div4            (clk_x4_en_div4),       // o
        .clk_en_div8            (clk_x4_en_div8),       // o  // SM Added div8
        .clk_en_div16           (clk_x4_en_div16)       // o  // SM Added div16
    );

    // ------------------------------------------------------------------ //
    // Clock En Selection                                                 //
    // ------------------------------------------------------------------ //
    always_ff @(posedge clk_x1) begin
        clk_x1_en   <= clk_x1_en_next;
    end

    always_ff @(posedge clk_x4) begin
        clk_x4_en      <= clk_x4_en_next;
        clk_x8_en      <= clk_x8_en_next;
        clk_x16_en     <= clk_x16_en_next;
        clk_x4_fft_en  <= clk_x4_fft_en_next;
    end

    always_comb begin
        case (car_bw_sync)
            BW_20MHZ    : begin
                            clk_x1_en_next     = clk_x1_en_div1;
                            clk_x4_en_next     = clk_x4_en_div1;
                            clk_x8_en_next     = DISABLED;
                            clk_x16_en_next    = DISABLED;
                            clk_x4_fft_en_next = clk_x4_en_div4;  // FFT IFFT needs div 4 clock enable
                          end
            BW_15MHZ    : begin
                            clk_x1_en_next     = clk_x1_en_div1;  // 368.64 Temporary for now. 
                            clk_x4_en_next     = clk_x4_en_div1;  // 368.64 Temporary for now. 
                            clk_x8_en_next     = DISABLED;
                            clk_x16_en_next    = DISABLED;
                            clk_x4_fft_en_next = clk_x4_en_div4;  // FFT IFFT needs div 4 clock enable
                          end
            BW_10MHZ    : begin
                            clk_x1_en_next     = clk_x1_en_div2;
                            clk_x4_en_next     = clk_x4_en_div2;
                            clk_x8_en_next     = clk_x4_en_div1;
                            clk_x16_en_next    = DISABLED;
                            clk_x4_fft_en_next = clk_x4_en_div8;  // FFT IFFT needs div 8 clock enable
                          end
            BW_5MHZ     : begin
                            clk_x1_en_next     = clk_x1_en_div4;
                            clk_x4_en_next     = clk_x4_en_div4;
                            clk_x8_en_next     = clk_x4_en_div2;
                            clk_x16_en_next    = clk_x4_en_div1;
                            clk_x4_fft_en_next = clk_x4_en_div16;  // FFT IFFT needs div 16 clock enable
                          end
            default     : begin
                            clk_x1_en_next     = clk_x1_en_div1;
                            clk_x4_en_next     = clk_x4_en_div1;
                            clk_x8_en_next     = DISABLED;
                            clk_x16_en_next    = DISABLED;
                            clk_x4_fft_en_next = clk_x4_en_div4;  // FFT IFFT needs div 4 clock enable
                          end
        endcase
    end // always_comb

    
    // X8 clk is tied to 491.52 MHz.
    // For 10MHz BW, the x8 freq is 491.52 MHz, so clk_en is always high.
    // For 5MHz BW, the x8 freq is 1/2 of 491.52, so use 
    // For all other BW settings, this clock is not needed and is
    // disabled with clk_x16_en
    //assign clk_x8_en_next = (car_bw_sync == BW_10MHZ) ? ENABLED : ((car_bw_sync == BW_5MHZ) ? clk_x4_en_div2 : DISABLED);


    // X16 clk is tied to 491.52 MHz.
    // For 5MHz BW, the x16 freq is 491.52 MHz, so clk_en is always high.
    // For all other BW settings, this clock is not needed and is
    // disabled with clk_x16_en
    //assign clk_x16_en_next = (car_bw_sync == BW_5MHZ) ? ENABLED : DISABLED;

/*
ila_clocking u_ila_clocking (
	.clk(clk_x4),
	.probe0(car_en_sync),
	.probe1(car_en),
	.probe2(car_disable_pulse),
	.probe3(car_enable_pulse),
	.probe4(car_bw_sync),
	.probe5(car_en_qualified),
	.probe6(sm_flush_busy),
	.probe7(flush_cnt_en),
	.probe8(turn_clks_off),
	.probe9(clk_x1_en),
	.probe10(clk_x4_en),
	.probe11(clk_x8_en),
	.probe12(clk_x16_en),
	.probe13(rst_x1clk),
	.probe14(sm_flush),
	.probe15(flush_cnt)
);
*/

endmodule

