`timescale 1ns / 1ps

module jb_lte_fft_prach # (
    parameter N_CARRIERS = 2,
    parameter N_ANTENNAS=4,
    parameter USR_ID_BW=2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4,
    parameter INST = 0
)
 (
    input clk_dfe,
    input  [31:0] systimer_ns,
    input clk_en_dfe,
    input reset_dfe,
    input clk_fft,              // Clock for fft, was 491.52
    input clk_x1en,
  //  input reset,
    input clk_4x,
    input resetn_1x,
    input frm_mrkr,
   // input sub_frame_mrkr,
  //  input [ 2:0] sym_cnt,
    input car_en,
    input [9:0] prach_cp,
    jb_axi4_stream_if.slave IFP_prach_fft_in,
    input [3:0] format, // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
//    input extended_cp,
//    input [15:0] nscs,       // Number of carrier spacing
//    input ch_bw_update_req,
    input [3:0] ch_bw,
    output sym_mrkr_out,
    output ch_bw_update_done,
    
    // Output
    jb_axi4_stream_if.master IFP_fft_out
    ); 

logic  extended_cp = 0; 
logic [15:0] nscs = 0;   
//logic [3:0] ch_bw = 4'b0000;
logic ch_bw_update_req = 1'b0;
logic [3:0] ch_bw_delayed;
logic ch_bw_change;
localparam   num_channels = 4; 
logic [4:0] nfft_size; // nfft_size <= 5'd10;//[5:0] fft_size, //{4'b log2(size), 1'b 3x multiplier}  512 => {4'b1001,1'b0}, 1024 => {4'b1010,1'b0}
logic [9:0]  scale_sch = 10'b01_01_01_01_10;  //was  01_10_10_10_10
//logic [9:0]  scale_sch;  //was 11:0 when programmble size , need new one
logic [9:0]  scale_sch_update;
logic start =0;
logic rfd;
logic [PRECISION-1:0] output_FFT_I;
logic [PRECISION-1:0] output_FFT_Q; 
logic [2*PRECISION-1:0] output_from_mem; 
logic [PRECISION-1:0] output_I_from_mem;
logic [PRECISION-1:0] output_Q_from_mem; 
logic [PRECISION-1:0] output_I_FFT_zero; 
logic [PRECISION-1:0] output_Q_FFT_zero;   
logic output_FFT_zero_valid; 
logic output_FFT_zero_tlast; 
logic output_FFT_zero_tfirst; 
logic overflow;
logic [3:0] current_ch_bw;
logic [4:0] nfft_size_set;
logic dv;
logic frame_marker;
logic sym_mrkr;
logic sub_frame_mrkr;
logic [2:0] sub_frm_marker_d;
logic [2:0] sub_frm_marker_delayed_d;
logic sub_frm_marker_extended;
logic sub_frm_marker_delayed_extended;
logic [18:0] sub_frame_sample_cnt;
logic [2:0] sym_cnt;
logic [2:0] sym_cnt_4x;
logic [2:0] sym_cnt_4x_out;
logic [22:0] frm_mrkr_sample_cnt;
logic [3:0]  sub_frame_cnt;
logic [4:0]  slot_cnt;
logic [15:0] sample_cnt_4x_per_slot;  // samples in 1/2 subframe / slot
logic [15:0] sample_cnt_per_slot;  // samples in 1/2 subframe / slot
logic [15:0] sample_cnt_per_sym;  // samples in 1 symbol
logic [15:0] sample_cnt_per_sym_4x; // samples per symbol at 4x rate
logic cp_time;
logic frm_mrkr_out;
logic sym_mrkr_4x;
logic sym_mrkr_4x_out;
logic slot_mrkr;
logic slot_mrkr_out;
logic [17:0] slot_mrkr_sample_cnt;
logic [15:0] sym_mrkr_sample_cnt;
logic [9:0] output_add;
logic [9:0] output_address_zero;
logic [13:0] output_add_to_mem;
logic [13:0] mem_write_add;
logic [13:0] mem_read_add;
logic dv_out;
logic bank_0_ready_to_read;
logic bank_1_ready_to_read;
logic cp_mrkr;
logic cp_mrkr_out;
logic first_symbol;
logic write_en;
logic nfft_we;
logic ctrl_we_update;
logic dv_mem;
logic [USR_ID_BW-1:0] antenna_out_zero;
logic antenna_out = 0;
logic frm_mrkr_aligned;
logic slot_mrkr_aligned;                
logic sym_mrkr_aligned;
logic [2:0] sym_cnt_aligned; 
logic [2:0] sym_cnt_4x_aligned;
logic sub_frame_mrkr_aligned;
logic [2:0] sub_frame_mrkr_aligned_d;
logic [2:0] sub_frame_mrkr_aligned_delayed_d;
logic sub_frame_mrkr_aligned_extended;
logic sub_frame_mrkr_aligned_delayed_extended;
logic sym_mrkr_4x_aligned;

localparam  FFT_OUT_TUSER_BW= USR_ID_BW +10 + 4; //2 + 10 + 4, ffft size address width, subframe_cnt,
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(FFT_OUT_TUSER_BW))  IFP_fft_to_gain(); // inlude address in user ID and tfirst for symbol marker
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(FFT_OUT_TUSER_BW))  IFP_fft_from_gain(); // inlude address in user ID and tfirst for symbol marker
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_from_dfe_cdc();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_from_mem_write();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_from_alignment();


    logic [PRECISION*2-1:0] dout_data [num_channels-1:0];
    logic [PRECISION*2-1:0] dout_data_d [num_channels-1:0];
    logic [PRECISION*2-1:0] dout_data_2d [num_channels-1:0];
    logic [PRECISION*2-1:0] dout_data_3d [num_channels-1:0];
    logic [PRECISION-1:0] dout_data_I [num_channels-1:0];
    logic [PRECISION-1:0] dout_data_Q [num_channels-1:0];
    logic [2*PRECISION-1:0] fifo_1st_dout_data [num_channels-1:0];
    logic [2*PRECISION-1:0] fifo_2nd_dout_data [num_channels-1:0];
    logic [PRECISION-1:0] fifo_1st_dout_data_I [num_channels-1:0];
    logic [PRECISION-1:0] fifo_1st_dout_data_Q [num_channels-1:0];
    logic [PRECISION-1:0] fifo_2nd_dout_data_I [num_channels-1:0];
    logic [PRECISION-1:0] fifo_2nd_dout_data_Q [num_channels-1:0];
    logic [PRECISION*2-1:0] data_zero [num_channels-1:0];
    logic [num_channels-1:0] fifo_1st_full_data;
    logic [num_channels-1:0] fifo_2nd_full_data;
    logic [num_channels-1:0] fifo_1st_overflow_data;
    logic [num_channels-1:0] fifo_2nd_overflow_data;
    logic [num_channels-1:0] empty_data;
    logic [num_channels-1:0] fifo_1st_empty_data;
    logic [num_channels-1:0] fifo_2nd_empty_data;
    logic [num_channels-1:0] valid_data;
    logic [num_channels-1:0] fifo_1st_valid_data;
    logic [num_channels-1:0] fifo_2nd_valid_data;
    logic [23:0] dout_header;
    logic [num_channels-1:0] rd_en_1st_data;
    logic [num_channels-1:0] rd_en_2nd_data;
    logic [num_channels-1:0] wr_en_1st_data;
    logic [num_channels-1:0] wr_en_2nd_data;
    logic dont_read = 0;
    logic rd_en_header;
    logic overflow_header;
    logic empty_header;
    logic valid_header;
    logic [10:0] fifo_1st_data_count [num_channels-1:0];
    logic [13:0] fifo_1st_rd_data_count [num_channels-1:0]; 
    logic [13:0] fifo_2nd_rd_data_count [num_channels-1:0]; 
    logic [4:0]  rd_data_count_hdr; 
    logic [4:0]  wr_data_count_hdr; 
    logic [15:0] dout_header_nscs;
    logic [15:0] space_upper;
    logic [15:0] space_lower;
    logic [15:0] space_upper_minus_1;
    logic [15:0] space_lower_minus_1;
    logic [15:0] count_index = 0;
    logic [15:0] count_index_d = 0;
    logic [15:0] calculation_1 = 0; 
    logic fifo_1st_prog_full_data [num_channels-1:0];
    logic fifo_2nd_prog_full_data [num_channels-1:0];
    logic prog_full_header;
    logic fifo_first = 1;
    logic fifo_wren;
    logic [19:0] wait_time;
    logic [2*PRECISION-1:0] fifo_1st_data_in [N_ANTENNAS-1:0];
    logic [2*PRECISION-1:0] fifo_2nd_data_in [N_ANTENNAS-1:0];
    logic busy;
    logic edone;
    logic done;
    logic start_int=0;
    logic ctrl_we=0;

    assign wait_time=0;
//    assign frame_marker = frm_mrkr;   // do this for no delay - AS
    
    
jb_marker_generation jb_prach_marker_generation_inst (
    .clk(clk_dfe),
    .reset(resetn_1x),
    .car_en(car_en),
    .frm_mrkr(frm_mrkr),
    .extended_cp(extended_cp),    
    
     // real time indicators
    .frm_mrkr_out(frame_marker),
    .frm_mrkr_sample_cnt (frm_mrkr_sample_cnt),                 // o 10ms Frame Marker aligned
    .sub_frame_mrkr (sub_frame_mrkr),
    .sub_frame_sample_cnt (sub_frame_sample_cnt),
    .sub_frame_cnt (sub_frame_cnt),
    .slot_mrkr (slot_mrkr),                         // o slot marker 0.5ms
    .slot_mrkr_sample_cnt (slot_mrkr_sample_cnt),
    .slot_cnt (slot_cnt),
    .sym_mrkr(sym_mrkr),                            // o symbol marker  
    .sym_mrkr_sample_cnt (sym_mrkr_sample_cnt),
    .sym_cnt(sym_cnt),                              // o symbol count
    .cp_mrkr(cp_mrkr),                              // o cp marker
    //.sample_cnt_per_slot(sample_cnt_per_slot),      // o sample count per slot
    //.sample_cnt_per_sym(sample_cnt_per_sym),        // o sample count per symbol
         // 4x indicators
    .sym_mrkr_4x(sym_mrkr_4x)                       // o symbol marker at the 4x rate
    //.sym_cnt_4x(sym_cnt_4x),                         // o symbol count at the 4x rate
    //.sample_cnt_4x_per_slot(sample_cnt_4x_per_slot), // o sample count per slot at 4x rate
    //.sample_cnt_per_sym_4x(sample_cnt_per_sym_4x)    // o sample count per symbol 4x rate

);     

// always_ff @(posedge clk_4x) begin  // Use internal signal to align DFE input.  This will be done in DFE somehow.
//    sub_frm_marker_d[0] <= sub_frame_mrkr;
//    sub_frm_marker_d[1] <= sub_frm_marker_d[0];
//    sub_frm_marker_d[2] <= sub_frm_marker_d[1];
//  end

//  assign sub_frm_marker_extended = |sub_frm_marker_d  || sub_frame_mrkr;
  
//   always_ff @(posedge clk_4x) begin  // Use internal signal to align DFE input.  This will be done in DFE somehow.
//    sub_frame_mrkr_aligned_d[0] <= sub_frame_mrkr_aligned;
//    sub_frame_mrkr_aligned_d[1] <= sub_frame_mrkr_aligned_d[0];
//    sub_frame_mrkr_aligned_d[2] <= sub_frame_mrkr_aligned_d[1];
//  end

//  assign sub_frame_mrkr_aligned_extended = |sub_frame_mrkr_aligned_d  || sub_frame_mrkr_aligned;
  
  
  always @(posedge clk_dfe) begin // always block to update state
    if (clk_en_dfe) begin
        ch_bw_delayed <= ch_bw; 
    end
 end
 assign ch_bw_change = |(ch_bw ^ ch_bw_delayed);  // 010 ^ 000 = 010 
// assign current_ch_bw = ch_bw;
  
  jb_prach_fft_alignment # (
       .USR_ID_BW (USR_ID_BW),
       .PRECISION (PRECISION)
   )   jb_prach_fft_alignment_inst (
      .clk(clk_dfe),                                   // i clock  
      .clk_en(clk_en_dfe),                             // i clock enable           
      .reset(reset_dfe),                               // i reset  
      .car_en(car_en), 
      .ch_bw_update_done(ch_bw_change),       // i
      .ch_bw(current_ch_bw),                       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz    
      .extended_cp(extended_cp),                   // i
      .dv(IFP_prach_fft_in.tvalid),            // i  
      .frm_mrkr(frame_marker),                     // i
      .subfrm_mrkr(sub_frame_mrkr),                // i
      .slot_mrkr(slot_mrkr),                       // i
      .sym_mrkr(sym_mrkr),                         // i
      .sym_mrkr_4x(sym_mrkr_4x),                   // i
      .sym_cnt(sym_cnt),                           // i symbol count
      .sym_cnt_4x(sym_cnt_4x),                     // i 
      .IFP_fft_in (IFP_prach_fft_in),          // i
      .IFP_fft_out (IFP_fft_from_alignment),       // o
      .frm_mrkr_out(frm_mrkr_aligned),             // o
      .subfrm_mrkr_out(sub_frame_mrkr_aligned),    // o
      .slot_mrkr_out(slot_mrkr_aligned),           // o
      .sym_mrkr_out(sym_mrkr_aligned),             // o
      .sym_mrkr_4x_out(sym_mrkr_4x_aligned),       // o
      .sym_cnt_out(sym_cnt_aligned),               // o 
      .sym_cnt_4x_out(sym_cnt_4x_aligned)          // o 
);  

     
//jb_sym_mrkr_gen jb_sym_mrkr_gen_inst (
//    .clk(clk),
//    .clk_en(clk_en),
//    .reset(reset),
//    .frm_mrkr(frm_mrkr),
//    .ch_bw(ch_bw),
//    .extended_cp(extended_cp),    
    
//     // real time indicators
//    .frm_mrkr_out(frame_marker),                    // o 10ms Frame Marker aligned
//    .slot_mrkr (slot_mrkr),                         // o slot marker 0.5ms
//    .sym_mrkr(sym_mrkr),                            // o symbol marker  
//    .sym_cnt(sym_cnt),                              // o symbol count
//    .cp_mrkr(cp_mrkr),                              // o cp marker
//    .sample_cnt_per_slot(sample_cnt_per_slot),      // o sample count per slot
//    .sample_cnt_per_sym(sample_cnt_per_sym),        // o sample count per symbol
    
//     // 4x indicators
//    .sym_mrkr_4x(sym_mrkr_4x),                       // o symbol marker at the 4x rate
//    .sym_cnt_4x(sym_cnt_4x),                         // o symbol count at the 4x rate
//    .sample_cnt_4x_per_slot(sample_cnt_4x_per_slot), // o sample count per slot at 4x rate
//    .sample_cnt_per_sym_4x(sample_cnt_per_sym_4x)    // o sample count per symbol 4x rate

//);     

// Delay symbol marker and cnt to align with output ORAN

//jb_fft_prach_delay jb_fft_prach_delay_inst (
//      .clk(clk_dfe),                      // i clock  
//      .clk_en(clk_en_dfe),                // i clock enable           
//      .reset(reset_dfe),                  // i reset    
//      .ch_bw(ch_bw),          // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
//      .frm_mrkr(frame_marker),        // i
//      .slot_mrkr(slot_mrkr),          // i
//      .sym_mrkr(sym_mrkr_4x),         // i
//      .cp_mrkr(cp_mrkr),              // i
//      .sym_cnt(sym_cnt_4x),           // i 
//      .frm_mrkr_out(frm_mrkr_out),    // o
//      .slot_mrkr_out(slot_mrkr_out),  // o
//      .sym_mrkr_out(sym_mrkr_4x_out), // o
//      .cp_mrkr_out(cp_mrkr_out),      // o
//      .sym_cnt_out(sym_cnt_4x_out)    // o 
//    );

jb_bw_update_nr  # (
    .FFT_IFFT (1)  // 0 is IFFT. 1 is FFT, for different scaling
) jb_prach_bw_update_nr_inst
(
    .clk(clk_dfe),
    .clk_en(clk_en_dfe),
    .reset(reset_dfe),
    .car_en(car_en),                        //i
    .ch_bw_update_req(ch_bw_update_req),   //i
    .ch_bw_update_done(ch_bw_update_done), //o
    .ch_bw(ch_bw),                         //i 
    .nfft_size(nfft_size_set),             //o
    .scale_sch(scale_sch_update),                 //o
    .nfft_we(nfft_we),                     //o
    .ctrl_we(ctrl_we_update),                     //o 
    .current_ch_bw(current_ch_bw)          //o
);    

// This only does data, user and valid.  NOTHING ELSE!!!  not sure about this - AS
//jb_axis_sync_slowc_fastc #(
//        .FAST_TO_SLOW_RATIO     (1),  // Ratio of clocks
//        .FAST_TO_SLOW_RATIO_BW  (1)   // Ratio of 2 is equal.  4 is 2   
//    ) u_fft_122_491  (
//        .clk_slow_en            (clk_en_dfe),
//        .clk_fast_en            (clk_en),
//        .clk_slow               (clk_dfe),
//        .clk_fast               (clk_fft),
			  
//        .resetn                 (!reset),
			  
//        .IFP_axis_in            (IFP_prach_fft_in),
//        .IFP_axis_out           (IFP_fft_from_dfe_cdc)
//    );


  
  
// write logic.  Need to write only the data 
jb_prach_fft_mem_write # (
       .USR_ID_BW (USR_ID_BW),
       .PRECISION (PRECISION)
   )   jb_prach_fft_mem_write_inst (
      .clk(clk_dfe),                                   // i clock  
      .clk_en(clk_en_dfe),                             // i clock enable           
      .reset(reset_dfe),                               // i reset   
      .format(format),                       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
      .prach_cp(prach_cp),    
      .dv(IFP_fft_from_alignment.tvalid),            // i  
//      .frm_mrkr(frm_mrkr_aligned),                     // i
//      .slot_mrkr(slot_mrkr),                       // i
//      .sym_mrkr(sym_mrkr),                         // i
      .sub_frame_mrkr(sub_frame_mrkr_aligned),             // i
//      .sym_cnt(sym_cnt),                           // i symbol count
      .wait_time(wait_time),
      .IFP_fft_in (IFP_fft_from_alignment),          // i
      .IFP_fft_out (IFP_fft_from_mem_write),       // o
      .cp_mrkr(cp_time),                    // o
      .fifo_wren(fifo_wren)
);   

//      if (reset_dfe) fifo_first<= 0;
//     always_ff @(posedge sub_frame_mrkr) begin
//	  fifo_first<= ~fifo_first;
//     end

genvar i;
generate 
 for (i = 0; i < N_ANTENNAS; i = i+1) begin
 
    assign fifo_1st_data_in[i]= IFP_fft_from_mem_write.tdata;
    assign wr_en_1st_data[i] =  fifo_wren && IFP_fft_from_mem_write.tvalid && (IFP_fft_from_mem_write.tuser == i);  //clk_x1en && 
    //assign rd_en_1st_data[i] = 0;
    
    fifo_prach_symbol_data fifo_1st_prach_symbol_data_inst (   
      .clk(clk_dfe),             // input wire clk
      .din(fifo_1st_data_in[i]),   // input wire [31 : 0] din
      .wr_en(wr_en_1st_data[i]),              // input wire wr_en
      .rd_en(rd_en_1st_data[i]),              // input wire rd_en
      .dout(fifo_1st_dout_data[i]),             // output wire [31 : 0] dout
      .full(fifo_1st_full_data[i]),             // output wire full
      .overflow(fifo_1st_overflow_data[i]),     // output wire overflow
      .empty(fifo_1st_empty_data[i]),           // output wire empty
      .valid(fifo_1st_valid_data[i]),           // output wire valid
      .data_count(fifo_1st_data_count[i]), // output wire [10 : 0] rd_data_count
      .prog_full(fifo_1st_prog_full_data[i])    // set to 4100. just greater than 1 symbol.  This way it will allow 2 4k symbols.  
     );


    assign fifo_1st_dout_data_Q[i] = fifo_1st_dout_data[i][31:16];
    assign fifo_1st_dout_data_I[i] = fifo_1st_dout_data[i][15:0];
//    assign data_zero[i] = 0;
    
    end       
endgenerate



// read logic.  
// jb_prach_fft_mem_read  jb_prach_fft_mem_read_inst
// (
//    .clk(clk),                                   // i clock  
//    .clk_en(clk_en),                             // i clock enable           
//    .reset(reset),                               // i reset   
//    .ch_bw(current_ch_bw),                       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz    
//    .rfd(rfd),                                   // i
//    .sym_mrkr_4x(sym_mrkr_4x),                   // i
//    .sym_cnt_4x(sym_cnt_4x),                     // i 
//    .fifo_dout_data(fifo_1st_dout_data),
//    .fifo_full(fifo_1st_full_data),
//    .fifo_empty(fifo_1st_empty_data),
//    .fifo_valid(fifo_1st_valid_data), 
//    .read_en(rd_en_1st_data),                                  // o  Aligns with output address
//    .output_add(mem_read_add),                   // o
//    .dv_mem(dv_mem),                             // o  Aligns with data read from memory outside
//    .start_fft(start_fft)                        // o  hold off fft
//    );


//assign start = sym_mrkr_4x && start_fft;  // Hold off start until first real FFT.  This will help align the Antenna ID
//assign output_Q_from_mem = output_from_mem[2*PRECISION-1:PRECISION];
//assign output_I_from_mem = output_from_mem[PRECISION-1:0];

//lte_prach_fft_1ch u_jb_lte_prach_fft (
//      .CLK(clk),                    // input wire CLK
//      .CE(clk_en),                  // input wire CE
//      .NFFT(nfft_size_set),         // input wire [4 : 0] NFFT
//      .NFFT_WE(nfft_we),            // input wire NFFT_WE
//      .START(start),                // input wire START
//      .CTRL_WE(ctrl_we),            // input wire CTRL_WE
//      .SCALE_SCH(scale_sch),        // input wire [11 : 0] SCALE_SCH
//      .FWD_INV(1'b1),               // input wire FWD_INV  0 - IFFT, 1 - FFT
//      .XN0_RE(output_I_from_mem),   // input wire [15 : 0] XN0_RE
//      .XN0_IM(output_Q_from_mem),   // input wire [15 : 0] XN0_IM
//      .XK0_RE(output_FFT_I),        // output wire [27 : 0] XK0_RE
//      .XK0_IM(output_FFT_Q),        // output wire [27 : 0] XK0_IM
//      .OVFLO0(overflow),            // output wire OVFLO0
//      .RFD(rfd),                    // output wire RFD
//      .XN_INDEX(),                  // output wire [10 : 0] XN_INDEX
//      .XK_INDEX(output_add),        // output wire [10 : 0] XK_INDEX
//      .BUSY(),                      // output wire BUSY
//      .EDONE(),                     // output wire EDONE
//      .DONE(),                      // output wire DONE
//      .DV(dv)                       // output wire DV
//    );    
   
//   always_ff @(posedge clk_dfe) begin
//    if (reset_dfe)  begin
//     start <= 0;
//     ctrl_we <= 0;
//     output_I_from_mem <= fifo_1st_dout_data_I[0];
//     output_Q_from_mem <= fifo_1st_dout_data_Q[0];
//     end
//      else if (clk_en_dfe) begin
//         ctrl_we <=1;
//	     if(rfd && fifo_1st_prog_full_data[0]) begin
//	       ctrl_we <= 0;
//	       start <= fifo_1st_prog_full_data[0];
//	       while (!fifo_1st_empty_data[0])
//	         begin
//	          output_I_from_mem <= fifo_1st_dout_data_I[0];
//	          output_Q_from_mem <= fifo_1st_dout_data_Q[0];
//	         end 
//	     end  
//      end
//     end
  
  
  //////////////////
  // state machine for control   -  move this to a module

logic [3:0] state, nextstate;
logic data_valid_d = 0;
logic reset_d = 0;
localparam state_idle = 0;
localparam state_ctrl_0_we = 1;
localparam state_fifo_0_wr = 2;
localparam state_fifo_0_wait = 3;
localparam state_ctrl_1_we = 4;
localparam state_fifo_1_wr = 5;
localparam state_fifo_1_wait = 6;
localparam state_ctrl_2_we = 7;
localparam state_fifo_2_wr = 8;
localparam state_fifo_2_wait = 9;
localparam state_ctrl_3_we = 10;
localparam state_fifo_3_wr = 11;
localparam state_fifo_3_wait = 12;

always @(posedge clk_dfe) begin // always block to update state
    if (clk_en_dfe) begin
        data_valid_d <= clk_en_dfe; 
        reset_d <= reset_dfe;
    end
 end

always @(posedge clk_dfe) begin // always block to update state
    if (reset_dfe)
        state <= state_idle;
    else if (clk_en_dfe) begin
        state <= nextstate; 
        end
 end
 
 always @(*) // always block to compute both output & nextstate
    begin
     case(state)
     state_idle : begin 
     nextstate = state_idle;         
        if (fifo_1st_prog_full_data[0]) nextstate = state_ctrl_0_we;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[0] = 0;
//         rd_en_1st_data[1] = 0;
//         rd_en_1st_data[2] = 0;
//         rd_en_1st_data[3] = 0;
//         output_I_from_mem <= fifo_1st_dout_data_I[0];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[0];
         end     

     state_ctrl_0_we: begin
         nextstate = state_fifo_0_wr; 
//         ctrl_we = 1;
//         start = 1;
//         rd_en_1st_data[0] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[0];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[0];
         end
     state_fifo_0_wr: begin
         nextstate = state_fifo_0_wr; 
         if (fifo_1st_empty_data[0]) nextstate = state_fifo_0_wait;
 //        else if ((data_valid == 0 && data_valid_d == 1)) nextstate = state_idle;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[0] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[0];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[0];
         end
     state_fifo_0_wait: begin
         nextstate = state_fifo_0_wait; 
         if (done) nextstate = state_ctrl_1_we;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[0] = 0;
//         output_I_from_mem <= fifo_1st_dout_data_I[1];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
     state_ctrl_1_we: begin
         nextstate = state_fifo_1_wr; 
//         ctrl_we = 1;
//         start = 1;
//         rd_en_1st_data[1] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[1];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
      state_fifo_1_wr: begin
         nextstate = state_fifo_1_wr; 
         if (fifo_1st_empty_data[1]) nextstate = state_fifo_1_wait;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[1] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[1];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
      state_fifo_1_wait: begin
         nextstate = state_fifo_1_wait; 
         if (done) nextstate = state_ctrl_2_we;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[1] = 0;
//         output_I_from_mem <= fifo_1st_dout_data_I[2];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[2];
         end
      state_ctrl_2_we: begin
         nextstate = state_fifo_2_wr; 
//         ctrl_we = 1;
//         start = 1;
//         rd_en_1st_data[2] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[2];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[2];
         end
     state_fifo_2_wr: begin
         nextstate = state_fifo_2_wr; 
         if (fifo_1st_empty_data[2]) nextstate = state_fifo_2_wait;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[2] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[2];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[2];
         end
      state_fifo_2_wait: begin
         nextstate = state_fifo_2_wait; 
         if (done) nextstate = state_ctrl_3_we;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[2] = 0;
//         output_I_from_mem <= fifo_1st_dout_data_I[3];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[3];
         end
      state_ctrl_3_we: begin
         nextstate = state_fifo_3_wr; 
//         ctrl_we = 1;
//         start = 1;
//         rd_en_1st_data[3] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[3];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[3];
         end
      state_fifo_3_wr: begin
         nextstate = state_fifo_3_wr;
         if (fifo_1st_empty_data[3]) nextstate = state_fifo_3_wait;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[3] = 1;
//         output_I_from_mem <= fifo_1st_dout_data_I[3];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[3];
         end
      state_fifo_3_wait: begin
         nextstate = state_fifo_3_wait;
         if (done) nextstate = state_idle;
//         ctrl_we = 0;
//         start = 0;
//         rd_en_1st_data[3] = 0;
//         output_I_from_mem <= fifo_1st_dout_data_I[1];
//         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
     default:
        nextstate = state_idle;
     endcase
    end
    
    
    
    always @(posedge clk_dfe) begin // always block to update state
    if (clk_en_dfe) begin
        if(state == state_idle) begin
           ctrl_we <= 0;
           start <= 0;
           rd_en_1st_data[0] <= 0;
           rd_en_1st_data[1] <= 0;
           rd_en_1st_data[2] <= 0;
           rd_en_1st_data[3] <= 0;
           output_I_from_mem <= fifo_1st_dout_data_I[0];
           output_Q_from_mem <= fifo_1st_dout_data_Q[0];
        end
        else if (state == state_ctrl_0_we) begin
                 ctrl_we <= 1;
                 start <= 1;
                 rd_en_1st_data[0] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[0];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[0];      
        end
        else if (state == state_fifo_0_wr) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[0] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[0];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[0];             
        end
        else if (state == state_fifo_0_wait) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[0] <= 0;
                 output_I_from_mem <= fifo_1st_dout_data_I[1];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[1];                      
        end
        else if (state == state_ctrl_1_we) begin
                 ctrl_we <= 1;
                 start <= 1;
                 rd_en_1st_data[1] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[1];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[1];              
        end
        else if (state == state_fifo_1_wr) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[1] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[1];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[1];                 
        end
        else if (state == state_fifo_1_wait) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[1] <= 0;
                 output_I_from_mem <= fifo_1st_dout_data_I[2];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[2];               
        end
        else if (state == state_ctrl_2_we) begin
                 ctrl_we <= 1;
                 start <= 1;
                 rd_en_1st_data[2] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[2];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[2];   
        end
        else if (state == state_fifo_2_wr) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[2] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[2];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[2];
        end
        else if (state == state_fifo_2_wait) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[2] <= 0;
                 output_I_from_mem <= fifo_1st_dout_data_I[3];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[3];
        end 
        else if (state == state_ctrl_3_we) begin
                 ctrl_we <= 1;
                 start <= 1;
                 rd_en_1st_data[3] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[3];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[3];
        end                      
        else if (state == state_fifo_3_wr) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[3] <= 1;
                 output_I_from_mem <= fifo_1st_dout_data_I[3];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[3];
        end
        else if (state == state_fifo_3_wait) begin
                 ctrl_we <= 0;
                 start <= 0;
                 rd_en_1st_data[3] <= 0;
                 output_I_from_mem <= fifo_1st_dout_data_I[1];
                 output_Q_from_mem <= fifo_1st_dout_data_Q[1];
        end     
     
      end  
    end
/////////////////////////////////resd state machine end  ////////////////////////////////    
    
    lte_prach_fft_1ch u_jb_lte_prach_fft (
          .CLK(clk_dfe),              // input wire CLK
          .CE(clk_en_dfe),                // input wire CE
          .START(start),          // input wire START
          .CTRL_WE(ctrl_we),      // input wire CTRL_WE
          .SCALE_SCH(scale_sch),  // input wire [9 : 0] SCALE_SCH
          .FWD_INV(1'b1),      // input wire FWD_INV
          .XN0_RE(output_I_from_mem),        // input wire [15 : 0] XN0_RE
          .XN0_IM(output_Q_from_mem),        // input wire [15 : 0] XN0_IM
          .XK0_RE(output_FFT_I),        // output wire [15 : 0] XK0_RE
          .XK0_IM(output_FFT_Q),        // output wire [15 : 0] XK0_IM
          .OVFLO0(overflow),        // output wire OVFLO0
          .RFD(rfd),              // output wire RFD
          .XN_INDEX(),    // output wire [9 : 0] XN_INDEX
          .XK_INDEX(output_add),    // output wire [9 : 0] XK_INDEX
          .BUSY(busy),            // output wire BUSY
          .EDONE(edone),          // output wire EDONE
          .DONE(done),            // output wire DONE
          .DV(dv)                // output wire DV
);
  
 // Zero data removal before sending to ORAN
jb_prach_fft_zero_data_removal # (
    .USR_ID_BW (USR_ID_BW),
    .PRECISION (PRECISION)
) jb_prach_fft_zero_data_removal_inst
 (
    .clk(clk_dfe),
    .clk_en(clk_en_dfe),
    .reset(reset_dfe),
  //  .ch_bw_update_done(ch_bw_update_done), // i
    .input_I(output_FFT_I),                // i
    .input_Q(output_FFT_Q),                // i
    .address(output_add),                  // i
    .dv(dv),                               // i 
    //.nfft_size(nfft_size_set),             // i
    //.nscs(nscs),                           // i   
    .output_I(output_I_FFT_zero),          // o 
    .output_Q(output_Q_FFT_zero),          // o
    .address_out(output_address_zero),     // o
    .antenna_out(antenna_out_zero),        // o
    .tvalid(output_FFT_zero_valid),        // o
    .tlast(output_FFT_zero_tlast),         // o  at 4x rate
    .tfirst(output_FFT_zero_tfirst)        // o  Will be symbol marker
    );
       
// IQ Gain    
assign IFP_fft_to_gain.tdata  = {output_Q_FFT_zero, output_I_FFT_zero};  // {Q,I} Copy order from jb_dl_dfe_gen_input_iq.sv  
assign IFP_fft_to_gain.tvalid = output_FFT_zero_valid;
assign IFP_fft_to_gain.tuser  = {sub_frame_cnt, output_address_zero, antenna_out_zero};    //add [3:0]sub_frame_cnt
assign IFP_fft_to_gain.tlast  = output_FFT_zero_tlast;

//assign IFP_fft_to_gain.tdata  = {output_FFT_Q, output_FFT_I};  // need tuser - as 
//assign IFP_fft_to_gain.tvalid = dv;
//assign IFP_fft_to_gain.tuser  = {output_FFT_zero_tfirst,output_address_zero, antenna_out_zero};    
//assign IFP_fft_to_gain.tlast  = output_FFT_zero_tlast;

     jb_prach_lte_fft_gain # (
        .USR_ID_BW (FFT_OUT_TUSER_BW),  // include address and tfirst
        .PRECISION (PRECISION),
        .GAIN_SCALER_BW (GAIN_SCALER_BW)
     )  jb_prach_lte_fft_gain_inst
     (
        .clk                           (clk_dfe),
        .clk_en                        (clk_en_dfe),
        .reset                         (reset_dfe),
        .IFP_prach_fft_gain_in               (IFP_fft_to_gain),
        .ch_bw                         (ch_bw),       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
        
        // Output
        .IFP_prach_fft_gain_out              (IFP_fft_from_gain)
        );     

assign sym_mrkr_out             = sym_mrkr;
assign IFP_fft_out.tuser        = IFP_fft_from_gain.tuser[15:0];
assign IFP_fft_out.tdata        = IFP_fft_from_gain.tdata;
assign IFP_fft_out.tlast        = IFP_fft_from_gain.tlast;
assign IFP_fft_out.tkeep        = IFP_fft_from_gain.tkeep;
assign IFP_fft_out.tvalid       = IFP_fft_from_gain.tvalid;
assign IFP_fft_from_gain.tready = IFP_fft_out.tready; 



//generate 
//if (INST == 0) begin 
//ila_prach_1 ila_prach_1_inst (
//	.clk(clk_dfe), // input wire clk
//	.probe0(output_I_from_mem), // input wire [15:0]  probe0  
//	.probe1(output_Q_from_mem), // input wire [15:0]  probe1 
//	.probe2(output_FFT_I), // input wire [15:0]  probe2 
//	.probe3(output_FFT_Q), // input wire [15:0]  probe3 
//	.probe4(output_add), // input wire [9:0]  probe4 
//	.probe5(start), // input wire [0:0]  probe5 
//	.probe6(ctrl_we), // input wire [0:0]  probe6 
//	.probe7(dv), // input wire [0:0]  probe7 
//	.probe8(frm_mrkr), // input wire [0:0]  probe8 
//	.probe9(sub_frame_mrkr_aligned), // input wire [0:0]  probe9 
//	.probe10(IFP_fft_out.tvalid), // input wire [0:0]  probe10 
//	.probe11(sym_mrkr), // input wire [0:0]  probe11 
//	.probe12(overflow), // input wire [0:0]  probe12 
//	.probe13(sub_frame_cnt), // input wire [3:0]  probe13 
//	.probe14(fifo_wren), // input wire [0:0]  probe14 
//	.probe15(IFP_fft_out.tuser), // input wire [15:0]  probe15 
//	.probe16(IFP_prach_fft_in.tdata[31:16]), // input wire [15:0]  probe16 
//	.probe17(IFP_prach_fft_in.tdata[15:0]), // input wire [15:0]  probe17 
//	.probe18(sub_frame_mrkr), // input wire [0:0]  probe18 
//	.probe19(sym_mrkr_out), // input wire [0:0]  probe19
//	.probe20(systimer_ns), // input wire [31:0]  probe20 
//	.probe21(IFP_fft_from_alignment.tdata[31:16]), // input wire [15:0]  probe21 
//	.probe22(IFP_fft_from_alignment.tdata[15:0]), // input wire [15:0]  probe22
//	.probe23(IFP_fft_from_alignment.tvalid), // input wire [0:0]  probe23
//	.probe24(IFP_fft_from_mem_write.tdata[31:16]), // input wire [15:0]  probe24 
//	.probe25(IFP_fft_from_mem_write.tdata[15:0]), // input wire [15:0]  probe25	
//	.probe26(IFP_prach_fft_in.tuser[1:0]) // // input wire [1:0]  probe26
//);
//end
//endgenerate




//  ul_ila_0
//    prach_ila_0_inst0(
//      .clk  (clk_dfe),
//      .probe0   (frame_marker),                                // 1
//      .probe1   (sub_frm_marker_extended),                              // 1
//      .probe2   (slot_mrkr),                                   // 1
//      .probe3   (sym_mrkr),                                    // 1
//      .probe4   (frm_mrkr),                                // 1
//      .probe5   (sym_cnt),                                     // 3
//      .probe6   (cp_time),                                     // 1
//      .probe7   ({1'b0, sub_frame_cnt}),                                    // 5
//      .probe8   (IFP_prach_fft_in.tvalid),                           // 1
//      .probe9   (IFP_prach_fft_in.tready),                           // 1
//      .probe10  (fifo_wren),                            // 1
//      .probe11  (IFP_prach_fft_in.tdata),                            // 32
//      .probe12  ({12'b0, IFP_prach_fft_in.tuser}),                   // 14
//      .probe13  (IFP_fft_out.tvalid),                 // 1
//      .probe14  (IFP_fft_out.tready),                 // 1
//      .probe15  (IFP_fft_out.tlast),                  // 1
//      .probe16  (IFP_fft_out.tdata),                  // 32
//      .probe17  ({2'b0, IFP_fft_out.tuser[11:0]})          // 14
//      );
 
// vio_prach_fft vio_prach_fft_inst (
//  .clk(clk_dfe),                // input wire clk
//  .probe_in0(overflow),    // input wire [0 : 0] probe_in0
//  .probe_in1(ch_bw_update_done),    // input wire [0 : 0] probe_in1
//  .probe_out0(scale_sch),  // output wire [9 : 0] probe_out0
//  .probe_out1(ch_bw_update_req)  // output wire [0 : 0] probe_out1
//);   

endmodule
