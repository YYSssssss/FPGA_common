`timescale 1ns / 1ps

module jb_rfsw_map (
    input           [2:0]       ant_sel,
    input                       path_sel,

    output  logic               swa_en_n,
    output  logic               swa,
    output  logic               swb_en_n,
    output  logic               swb,
    output  logic               swc_en_n,
    output  logic               swc
);

    localparam      PATH_TYPE_DPD           = 0,
                    PATH_TYPE_VSWR          = 1;

    localparam      RF_PORT1    = 1'b1,
                    RF_PORT2    = 1'b0;

    // ------------------------------------------------------------------ //
    // HMC8038 SPDT Switches                                              //
    // ------------------------------------------------------------------ //
    // Switch Port Select
    // Vctl:    1 (RF_PORT1) = RFC to RF1
    //          0 (RF_PORT2) = RFC to RF2
    // Switch Enable
    // EN is Active-Low: 0 = ON, 1 = OFF
    //
    // Mapping based on Common Radioboard Specification 0.9, PA Control Interface

    // -------------------------------------------------- //
    // SWa_EN is tied to GND on the board. So, it's here just for completeness
    assign swa_en_n    = 0;
    // SWb_EN is enabled (low) when Antenna x (1st or 3rd) is selected
    assign swb_en_n    = ((ant_sel == 0) | (ant_sel == 2)) ? 0 : 1;
    // SWc_EN is enabled (low) when Antenna y (2nd or 4th) is selected
    assign swc_en_n    = ((ant_sel == 1) | (ant_sel == 3)) ? 0 : 1;

    // -------------------------------------------------- //
    // RF1 (1) for Antenna Y (2nd or 4th) and RF2 for Antenna x (1st or 3rd)
    // pa14_sw1_en controls "switch a" on the 2nd PA pallet. This control
    // is driven with inversion of swa which controls "switch a" on the 1st pallet.
    // So, when antenna X is selected on pallet 1, antenna Y gets selected on palet 2.
    // However, since swa is inverted for the 2nd PA pallet, when selecting
    // an antenna on that pallet, we're correcting for the swa inversion here.

//  assign swa         = ((ant_sel == 0) | (ant_sel == 2)) ? RF_PORT2 : RF_PORT1;
//  assign swa_adjust  = ((ant_sel == 0) | (ant_sel == 1)) ? swa : ~swa;
    assign swa         = ((ant_sel == 0) | (ant_sel == 3)) ? RF_PORT2 : RF_PORT1;
    // RF1 (1) for DPD  and RF2 (0) for VSWR 
    assign swb         = (path_sel == PATH_TYPE_DPD) ? RF_PORT1 : RF_PORT2;
    // RF1 (1) for VSWR and RF2 (0) for DPD 
    assign swc         = (path_sel == PATH_TYPE_DPD) ? RF_PORT2 : RF_PORT1;

endmodule
