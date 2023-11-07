`timescale 1ns / 1ps

module jb_rfsw_map (
    input           [2:0]       ant_sel,
    input                       path_sel,
	input                       band_sel,
	
    output  logic               pa_14_swa,
    output  logic               pa_14_swb,
    output  logic               pa_14_swc,
    output  logic               pa_14_swd,
    output  logic               pa_14_swe,
    output  logic               pa_14_swen,
	
    output  logic               pa_58_swa,
    output  logic               pa_58_swb,
    output  logic               pa_58_swc,
    output  logic               pa_58_swd,
    output  logic               pa_58_swe,
    output  logic               pa_58_swen
);

    localparam      PATH_TYPE_DPD  = 1'b0,
                    PATH_TYPE_VSWR = 1'b1;
 
    localparam      RF_PORT1       = 1'b1,
                    RF_PORT2       = 1'b0;
	


    assign pa_14_swa       = ((ant_sel == 3'd0) | (ant_sel == 3'd1)) ? (band_sel == 1'b0 ? 1'b0 : 1'b1) : 1'b1;
    assign pa_14_swb       = ((ant_sel == 3'd0) | (ant_sel == 3'd1)) ? (band_sel == 1'b0 ? ((path_sel == PATH_TYPE_DPD) ? RF_PORT1 : RF_PORT2) : 1'b0) : 1'b0; 
    assign pa_14_swc       = ((ant_sel == 3'd0) | (ant_sel == 3'd1)) ? (band_sel == 1'b0 ? 1'b1 : ((path_sel == PATH_TYPE_DPD) ? RF_PORT2 : RF_PORT1)) : 1'b1;
    assign pa_14_swd       = ((ant_sel == 3'd0) | (ant_sel == 3'd1)) ? (band_sel == 1'b0 ? 1'b1 : 1'b0) : 1'b1;	
    assign pa_14_swe       = (ant_sel == 3'd0) ? (path_sel == PATH_TYPE_DPD ? RF_PORT2 : RF_PORT1) : ((ant_sel == 3'd1) ? (path_sel == PATH_TYPE_DPD ? RF_PORT1 : RF_PORT2) : 1'b1);
    assign pa_14_swen      = ((ant_sel == 3'd0) | (ant_sel == 3'd1)) ? (path_sel == PATH_TYPE_DPD ? RF_PORT1 : RF_PORT2) : 1'b1;

    assign pa_58_swa       = ((ant_sel == 3'd2) | (ant_sel == 3'd3)) ? (band_sel == 1'b0 ? 1'b0 : 1'b1) : 1'b1;
    assign pa_58_swb       = ((ant_sel == 3'd2) | (ant_sel == 3'd3)) ? (band_sel == 1'b0 ? ((path_sel == PATH_TYPE_DPD) ? RF_PORT1 : RF_PORT2) : 1'b0) : 1'b0; 
    assign pa_58_swc       = ((ant_sel == 3'd2) | (ant_sel == 3'd3)) ? (band_sel == 1'b0 ? 1'b1 : ((path_sel == PATH_TYPE_DPD) ? RF_PORT2 : RF_PORT1)) : 1'b1;
    assign pa_58_swd       = ((ant_sel == 3'd2) | (ant_sel == 3'd3)) ? (band_sel == 1'b0 ? 1'b1 : 1'b0 ) : 1'b1;	
    assign pa_58_swe       = (ant_sel == 3'd2) ? (path_sel == PATH_TYPE_DPD ? RF_PORT2 : RF_PORT1) : ((ant_sel == 3'd3) ? (path_sel == PATH_TYPE_DPD ? RF_PORT1 : RF_PORT2) : 1'b1);
    assign pa_58_swen      = ((ant_sel == 3'd2) | (ant_sel == 3'd3)) ? (path_sel == PATH_TYPE_DPD ? RF_PORT1 : RF_PORT2) : 1'b1;
	
endmodule