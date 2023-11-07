// ========================================================================== //
// Company      : Jabil                                                       //
// Author       : M Faizan                                                    //
// Date         : 9/29/20                                                     //
// Module       : jb_rfsw_map                                                 //
// Description  :                                                             //
// ========================================================================== //
// Revision     : 0.01 - Created                                              //
// ========================================================================== //
`timescale 1ns / 1ps

module jb_rfsw_map (
    input           [2:0]       ant_sel,
    input                       path_sel,//0 = dpd , 1 = vswr	
	input                       rx_tx_mode_sel,//0 = rx , 1 = tx
	input                       pa_indicate,//0 = vernon pa, 1 = mintaka pa
	input           [7:0]       pa_sleep,     
    output  logic               tx_gainblock_en,
    output  logic               rx_gainblock_en,               
    output  logic   [1:0]       pa_lna_en,
    output  logic   [7:0]       sw_rxfb_dv_en,
    output  logic   [1:0]       sw_pa_rxfb_vctl,
	output  logic   [1:0]       sw_pa_dv_vctl,
    output  logic               sw_rxfb_vctl,
    output  logic               sw_rxfb_vctl_n,
	output  logic   [1:0]       sw_pa_lna_vctl,
    output  logic   [3:0]       prdrven,  
    output  logic   [7:0]       pa_ctrl_in
);

    localparam      PATH_TYPE_DPD  = 1'b0,
                    PATH_TYPE_VSWR = 1'b1;
 
    localparam      RF_PORT1       = 1'b1,
                    RF_PORT2       = 1'b0;
	

    assign          tx_gainblock_en =  rx_tx_mode_sel == 1'b1 ? 1'b0 : 1'b1;
	assign          rx_gainblock_en =  rx_tx_mode_sel == 1'b1 ? 1'b1 : 1'b0;
	assign          pa_lna_en       =  rx_tx_mode_sel == 1'b1 ? (pa_indicate == 1'b0 ? 2'b11 : 2'b00) : (pa_indicate == 1'b0 ? 2'b00 : 2'b11);
	assign          sw_pa_rxfb_vctl =  rx_tx_mode_sel == 1'b1 ? 2'b11 : 2'b00;
	assign          sw_rxfb_vctl    =  rx_tx_mode_sel == 1'b1 ? 1'b0 : 1'b1;
    assign          sw_rxfb_vctl_n  =  rx_tx_mode_sel == 1'b1 ? 1'b1 : 1'b0;
    assign          sw_pa_lna_vctl  =  rx_tx_mode_sel == 1'b1 ? (pa_indicate == 1'b0 ? 2'b11 : 2'b00) : (pa_indicate == 1'b0 ? 2'b00 : 2'b11);
    assign          prdrven         =  rx_tx_mode_sel == 1'b1 ? 4'hf  : 4'h0;
    assign          pa_ctrl_in[0]   =  pa_sleep[0]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
    assign          pa_ctrl_in[1]   =  pa_sleep[1]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
    assign          pa_ctrl_in[2]   =  pa_sleep[2]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
    assign          pa_ctrl_in[3]   =  pa_sleep[3]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
    assign          pa_ctrl_in[4]   =  pa_sleep[4]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
    assign          pa_ctrl_in[5]   =  pa_sleep[5]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
    assign          pa_ctrl_in[6]   =  pa_sleep[6]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
    assign          pa_ctrl_in[7]   =  pa_sleep[7]    == 1'b1 ? 1'b0 : (rx_tx_mode_sel ? 1'b1 : 1'b0);
	
/* 	assign          sw_rxfb_dv_en[0]=  ant_sel        == 3'd0 ? 1'b0 : 1'b1; // low (active) for Rx and ORx
	assign          sw_rxfb_dv_en[1]=  ant_sel        == 3'd1 ? 1'b0 : 1'b1;
	assign          sw_rxfb_dv_en[2]=  ant_sel        == 3'd2 ? 1'b0 : 1'b1;
	assign          sw_rxfb_dv_en[3]=  ant_sel        == 3'd3 ? 1'b0 : 1'b1;
	assign          sw_rxfb_dv_en[4]=  ant_sel        == 3'd4 ? 1'b0 : 1'b1;
	assign          sw_rxfb_dv_en[5]=  ant_sel        == 3'd5 ? 1'b0 : 1'b1;
	assign          sw_rxfb_dv_en[6]=  ant_sel        == 3'd6 ? 1'b0 : 1'b1;
	assign          sw_rxfb_dv_en[7]=  ant_sel        == 3'd7 ? 1'b0 : 1'b1; */	
	
	assign          sw_rxfb_dv_en   = 8'b0;
	assign          sw_pa_dv_vctl[0]=  (rx_tx_mode_sel == 1'b1 && (ant_sel == 3'd0 | ant_sel == 3'd1 | ant_sel == 3'd4 | ant_sel == 3'd5)) ? (path_sel == PATH_TYPE_DPD ? RF_PORT1 : RF_PORT2) : RF_PORT2;
	assign          sw_pa_dv_vctl[1]=  (rx_tx_mode_sel == 1'b1 && (ant_sel == 3'd2 | ant_sel == 3'd3 | ant_sel == 3'd6 | ant_sel == 3'd7)) ? (path_sel == PATH_TYPE_DPD ? RF_PORT1 : RF_PORT2) : RF_PORT2;	

	
endmodule