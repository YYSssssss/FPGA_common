////////////////////////////////////////////////////////////////////
////  File Name : jb_prach_fft_top
///// Author    : A. Siegel
///// Date      : 10/16/2020
///// Description  : prach fft top based on tb_fft burst mode
///                 
///
////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

 module jb_prach_fft_top #(


    parameter N_CARRIERS = 2,
    parameter N_ANTENNAS = 4,
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4

)
 (  
    input clk_4x,              // Clock for FFT
//    input clk_1x,              
//    input resetn_4x,
    input resetn_1x,
    input [N_CARRIERS-1:0] clk_x1en,
    input [N_CARRIERS-1:0] clk_x4en,
    input [N_CARRIERS-1:0] frm_mrkr,
    input [N_CARRIERS-1:0] prach_en,
    input [N_CARRIERS-1:0] [9:0] prach_cp,
    input  [31:0]          systimer_ns,
    jb_axi4_stream_if.slave IFP_fft_in[N_CARRIERS-1:0],
    input [N_CARRIERS-1:0][3:0] format,
    input [N_CARRIERS-1:0][3:0] ch_bw, 
  //  input ch_bw_update_req[N_CARRIERS-1:0],
    output sub_frame_mrkr_delayed,
    output [N_CARRIERS-1:0] sym_mrkr,
    output [N_CARRIERS-1:0] ch_bw_update_done,
    
    // Output DFE side
    input clk_dfe,
    input [N_CARRIERS-1:0] clk_en_dfe,
    input reset_dfe,
    jb_axi4_stream_if.master IFP_fft_out[N_CARRIERS-1:0]
    ); 
    
logic sub_frame_mrkr;
//logic sub_frame_mrkr_delayed;
logic [2:0] sub_frm_marker_d;
logic [2:0] sub_frm_marker_delayed_d;
logic sub_frm_marker_extended;
logic sub_frm_marker_delayed_extended;
logic [2:0] sym_cnt;
logic extended_cp = 0;
logic symbol_marker;  //as
logic [22:0] frm_mrkr_sample_cnt;
logic [18:0] sub_frame_sample_cnt;
logic [3:0] sub_frame_cnt;
logic [17:0] slot_mrkr_sample_cnt;
logic [4:0] slot_cnt;
logic [15:0] sym_mrkr_sample_cnt;
logic [2:0] sym_cnt_4x_out;


//jb_marker_generation jb_marker_generation_inst (
//    .clk(clk_4x),
//    .reset(resetn_4x),
//    .frm_mrkr(frm_mrkr),
//    .extended_cp(extended_cp),    
    
//     // real time indicators
//    .frm_mrkr_out(frame_marker),
//    .frm_mrkr_sample_cnt (frm_mrkr_sample_cnt),                 // o 10ms Frame Marker aligned
//    .sub_frame_mrkr (sub_frame_mrkr),
//    .sub_frame_sample_cnt (sub_frame_sample_cnt),
//    .sub_frame_cnt (sub_frame_cnt),
//    .slot_mrkr (slot_mrkr),                         // o slot marker 0.5ms
//    .slot_mrkr_sample_cnt (slot_mrkr_sample_cnt),
//    .slot_cnt (slot_cnt),
//    .sym_mrkr(symbol_marker),                            // o symbol marker  
//    .sym_mrkr_sample_cnt (sym_mrkr_sample_cnt),
//    .sym_cnt(sym_cnt),                              // o symbol count
//    .cp_mrkr(cp_mrkr)                              // o cp marker
//    //.sample_cnt_per_slot(sample_cnt_per_slot),      // o sample count per slot
//    //.sample_cnt_per_sym(sample_cnt_per_sym),        // o sample count per symbol
//         // 4x indicators
//    //.sym_mrkr_4x(sym_mrkr_4x),                       // o symbol marker at the 4x rate
//    //.sym_cnt_4x(sym_cnt_4x),                         // o symbol count at the 4x rate
//    //.sample_cnt_4x_per_slot(sample_cnt_4x_per_slot), // o sample count per slot at 4x rate
//    //.sample_cnt_per_sym_4x(sample_cnt_per_sym_4x)    // o sample count per symbol 4x rate
//);     

//  always_ff @(posedge clk_4x) begin  // Use internal signal to align DFE input.  This will be done in DFE somehow.
//    sub_frm_marker_d[0] <= sub_frame_mrkr;
//    sub_frm_marker_d[1] <= sub_frm_marker_d[0];
//    sub_frm_marker_d[2] <= sub_frm_marker_d[1];
//  end

//  assign sub_frm_marker_extended = |sub_frm_marker_d  || sub_frame_mrkr;
   

//jb_fft_prach_delay jb_fft_prach_delay_inst (
//      .clk(clk_4x),                      // i clock  
//      .clk_en(clk_x4en[0]),                // i clock enable           
//      .reset(resetn_4x),                  // i reset    
//      .ch_bw('b00),          // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
//      .frm_mrkr(sub_frame_mrkr),        // i
//      .slot_mrkr(slot_mrkr),          // i
//      .sym_mrkr(symbol_marker),         // i
//      .cp_mrkr(cp_mrkr),              // i
//      .sym_cnt(sym_cnt),           // i 
//      .frm_mrkr_out(sub_frame_mrkr_delayed),    // o
//      .slot_mrkr_out(slot_mrkr_out),  // o
//      .sym_mrkr_out(sym_mrkr_4x_out), // o
//      .cp_mrkr_out(cp_mrkr_out),      // o
//      .sym_cnt_out(sym_cnt_4x_out)    // o 
//    );
    
    
//always_ff @(posedge clk_4x) begin  // Use internal signal to align DFE input.  This will be done in DFE somehow.
//    sub_frm_marker_delayed_d[0] <= sub_frame_mrkr_delayed;
//    sub_frm_marker_delayed_d[1] <= sub_frm_marker_delayed_d[0];
//    sub_frm_marker_delayed_d[2] <= sub_frm_marker_delayed_d[1];
//end

//  assign sub_frm_marker_delayed_extended = |sub_frm_marker_delayed_d  || sub_frame_mrkr_delayed;
   


genvar j;

generate
    for (j = 0; j < N_CARRIERS; j = j + 1) begin : gen_channels       
       jb_lte_fft_prach #(
          .N_ANTENNAS (N_ANTENNAS),
          .USR_ID_BW (USR_ID_BW),
          .PRECISION (PRECISION),
          .GAIN_SCALER_BW(GAIN_SCALER_BW),
          .INST(j)
            )  u_lte_fft_prach_inst
            (
          .clk_dfe(clk_dfe),                                // using clk_1x for clk_dfe
          .systimer_ns(systimer_ns),
          .clk_en_dfe(clk_en_dfe[j]),     //was clk_x1en[j]
          .reset_dfe(reset_dfe),
          .clk_fft(clk_dfe),                                // using clk_1x for clk_fft
          .clk_x1en(clk_x1en[j]),                          // input clk enable  was clk_x1en[j]
//          .reset(reset),                            // input reset
          .clk_4x(clk_4x),
          .resetn_1x(resetn_1x),
          .frm_mrkr(frm_mrkr[j]),                 // one pulse every 10ms
       //   .sub_frame_mrkr(sub_frm_marker_extended),
       //   .sym_cnt(sym_cnt),
          .car_en(prach_en[j]),                       
          .prach_cp(prach_cp[j]),
      //    .ch_bw_update_req(ch_bw_update_req[j]),
      //    .ch_bw_update_done(ch_bw_update_done[j]),      
          .IFP_prach_fft_in(IFP_fft_in[j]),
          .format(format[j]),                         
      //    .extended_cp(extended_cp[j]),             
      //    .nscs(nscs[j]),
          .ch_bw(ch_bw[j]), 
          .sym_mrkr_out(sym_mrkr[j]),                   // o symbol marker
    
          // Out to ORAN
          .IFP_fft_out(IFP_fft_out[j])
      );
          end : gen_channels
endgenerate

   
endmodule
