`timescale 1ns / 1ps

module jb_nr100m_fft # (
    parameter N_ANTENNAS=4,
    parameter USR_ID_BW=2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4,
    parameter INST = 0
)
 (
    input clk,              // Clock for FFT
    input clk_en,
    input reset,
    input frm_mrkr,

    input car_en,
	input test_mode ,
    jb_axi4_stream_if.slave IFP_fft_in,
    input [3:0] ch_bw, // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    input extended_cp,
    input ch_bw_update_req,
    output ch_bw_update_done,
	output sym_mrkr_out,
    
    // Output
    jb_axi4_stream_if.master IFP_fft_out,
    
    // Output marker aligned with data out 
    output frm_mrkr_out,         // o
    output subfrm_mrkr_out,      // o
    output slot_mrkr_out        // o
	
	//for sim
	// output [3:0] sym_cnt_out
    ); 
    
logic [11:0]  scale_sch;
logic rfd;
logic overflow;
logic dv_mem;

logic [PRECISION-1:0] output_I_FFT_zero; 
logic [PRECISION-1:0] output_Q_FFT_zero;   
logic output_FFT_zero_valid; 
logic output_FFT_zero_tlast; 
logic output_FFT_zero_tfirst; 

logic [3:0] current_ch_bw;
logic [4:0] nfft_size_set;
logic dv;
logic frame_marker;
logic sym_mrkr;
logic [3:0] sym_cnt;
logic [2:0] sym_cnt_4x;

logic sym_mrkr_4x;
logic [11:0] output_add;
logic [11:0] output_address_zero;

logic [USR_ID_BW-1:0] antenna_out_zero;
logic antenna_out = 0;
logic [15:0] nscs_set;       // Number of carrier spacing
logic car_en_d = 0;
logic sub_frame_mrkr;
logic slot_mrkr ;

logic frm_mrkr_aligned;
logic slot_mrkr_aligned;                
logic sym_mrkr_aligned;
logic [3:0] sym_cnt_aligned; 
logic [2:0] sym_cnt_4x_aligned;
logic sub_frame_mrkr_aligned;
logic sym_mrkr_4x_aligned;

logic frm_mrkr_mem_out         ;
logic frm_mrkr_aligned_fft_out ;

logic frm_mrkr_dly;
logic subfrm_mrkr_dly;
logic slot_mrkr_dly;
logic sym_mrkr_dly;  
logic [3:0] sym_cnt_dly ;   

logic [31:0] fft_data_in ;
logic        fft_start   ; 
logic [11:0] input_index ;

logic        busy  ;
logic        edone ;
logic        done  ;

logic [15:0] output_fft_I ;
logic [15:0] output_fft_Q ;

logic frm_mrkr_zero;
logic subfrm_mrkr_zero;
logic slot_mrkr_zero;

jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW + 11 + 1 + 3))  IFP_fft_to_gain(); // inlude address in user ID and tfirst for symbol marker
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW + 11 + 1 + 3))  IFP_fft_from_gain(); // inlude address in user ID and tfirst for symbol marker
//jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_from_dfe_cdc();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_from_alignment();
//jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_from_mem_write();

// Register Carrrier enable.  It is will be "OR" in higher level
always_ff @(posedge clk) begin
    if (clk_en) begin
        car_en_d <= car_en;
    end
end
    
//tyh change 
 jb_marker_generation_nr_ul_tc #(
    .CLOCK_PERIOD (2.03450521)           //491.52 => 2.03450521  122.88 => 8.13802083  156.25 => 6.4 368.68Mhz => 2.7123793 245.76 => 4.06901042
) jb_marker_generation_nr_tc_fftin_inst(
    .clk(clk),
    .reset(reset),
    .car_en(car_en_d),
    .frm_mrkr(frm_mrkr),
    .extended_cp(extended_cp),    
    
     // real time indicators
    .frm_mrkr_out(frame_marker),      
    .frm_mrkr_sample_cnt(),
	.sub_frame_mrkr(sub_frame_mrkr),  
    .sub_frame_sample_cnt(),
	.sub_frame_cnt(),
	.slot_mrkr (slot_mrkr),           
    .slot_mrkr_sample_cnt(),
	.slot_cnt(),                      
	.sym_mrkr(sym_mrkr),              
    .sym_mrkr_pre(),                  
    .sym_mrkr_sample_cnt(),
	.sym_cnt(sym_cnt),                
    .cp_mrkr(),                       
    
     // 4x indicators
    .sym_mrkr_4x(sym_mrkr_4x),        
    .sym_cnt_4x(sym_cnt_4x)           
);     

jb_bw_update_nr  # (
    .FFT_IFFT (1)  // 0 is IFFT. 1 is FFT, for different scaling
) jb_bw_update_nr_inst
(
    .clk(clk),
    .clk_en(clk_en),
    .reset(reset),
    .car_en(car_en_d),                     //i
    .ch_bw_update_req(ch_bw_update_req),   //i
    .ch_bw_update_done(ch_bw_update_done), //o
    .ch_bw(ch_bw),                         //i 
    .nfft_size(nfft_size_set),             //o
    .nscs(nscs_set),                       //o
    .scale_sch(scale_sch),                 //o
    .nfft_we(nfft_we),                     //o
    .ctrl_we(ctrl_we),                     //o 
    .current_ch_bw(current_ch_bw)          //o
);    


// write logic.  Need to write only the data 
jb_fft_alignment_nr # (
       .USR_ID_BW (USR_ID_BW),
       .PRECISION (PRECISION)
   )   jb_fft_alignment_nr_inst (
      .clk(clk),                                   // i clock  
      .clk_en(clk_en),                             // i clock enable           
      .reset(reset),                               // i reset   
      .ch_bw_update_done(ch_bw_update_done),       // i
      .ch_bw(current_ch_bw),                       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz    
      .extended_cp(extended_cp),                   // i
      .dv(IFP_fft_in.tvalid),                      // i  
      .frm_mrkr(frame_marker),                     // i
      .subfrm_mrkr(sub_frame_mrkr),                // i
      .slot_mrkr(slot_mrkr),                       // i
      .sym_mrkr(sym_mrkr),                         // i
      .sym_mrkr_4x(sym_mrkr_4x),                   // i
      .sym_cnt(sym_cnt),                           // i symbol count
      .sym_cnt_4x(sym_cnt_4x),                     // i 
      .IFP_fft_in (IFP_fft_in),                    // i
      .IFP_fft_out (IFP_fft_from_alignment),       // o
      .frm_mrkr_out(frm_mrkr_aligned),             // o
      .subfrm_mrkr_out(sub_frame_mrkr_aligned),    // o
      .slot_mrkr_out(slot_mrkr_aligned),           // o
      .sym_mrkr_out(sym_mrkr_aligned),             // o
      .sym_mrkr_4x_out(sym_mrkr_4x_aligned),       // o
      .sym_cnt_out(sym_cnt_aligned),               // o 
      .sym_cnt_4x_out(sym_cnt_4x_aligned)          // o 
);  


//tyh change for uram
jb_fft_mem_desp  jb_fft_mem_desp_inst(
          .clk             (clk                   ),
		  .reset           (reset                 ),
		  .car_en          (car_en_d              ),
		  .frm_mrkr        (frm_mrkr_aligned      ), 
          .sym_mrkr        (sym_mrkr_aligned      ),
          .sym_mrkr_4x     (sym_mrkr_4x_aligned   ),
          .sym_cnt         (sym_cnt_aligned       ),
          .sym_cnt_4x      (sym_cnt_4x_aligned    ), 
          .IFP_fft_mem_in  (IFP_fft_from_alignment), 	
          .fft_data_in     (fft_data_in           ),
          .fft_start_in    (fft_start             ),
		  .frm_mrkr_mem_out(frm_mrkr_mem_out      )
    ) ; 	
	

lte_ul_fft_4096 u_jb_lte_ul_fft_4096 (
      .CLK(clk),                     // input wire CLK
      .CE(clk_en),                   // input wire CE
      .SCLR(1'b0),                   // input wire SCLR
      .NFFT(nfft_size_set),          // input wire [4 : 0] NFFT
      .NFFT_WE(nfft_we),             // input wire NFFT_WE
      .START(fft_start),             // input wire START
      .CTRL_WE(ctrl_we),             // input wire CTRL_WE
      .SCALE_SCH(scale_sch),         // input wire [11 : 0] SCALE_SCH
      .FWD_INV(1'b1),                // input wire FWD_INV  0 - IFFT, 1 - FFT
      .XN0_RE(fft_data_in[15:0]),    // input wire [15 : 0] XN0_RE
      .XN0_IM(fft_data_in[31:16]),   // input wire [15 : 0] XN0_IM
      .XK0_RE(output_fft_I),         // output wire [27 : 0] XK0_RE
      .XK0_IM(output_fft_Q),         // output wire [27 : 0] XK0_IM
      .OVFLO0(overflow),             // output wire OVFLO0
      .RFD(rfd),                     // output wire RFD
      .XN_INDEX(input_index),        // output wire [10 : 0] XN_INDEX
      .XK_INDEX(output_add),         // output wire [10 : 0] XK_INDEX
      .BUSY (busy ),                       // output wire BUSY
      .EDONE(edone),                      // output wire EDONE
      .DONE (done ),                       // output wire DONE
      .DV(dv)                        // output wire DV
    );    		  


jb_frm_mrkr_dly_nr  #(
           .DELAY_1024_UNITS(4), 
           .DELAY_ONE_CYCLE_UNITS(152)
       )   u_dl_fdfe_rm_mrkr_nr_dly (
           .clk                 (clk),
           .frm_mrkr_10ms       (frm_mrkr_mem_out),
           .frm_mrkr_10ms_dlyd  (frm_mrkr_aligned_fft_out)
       );

jb_marker_generation_nr_ul_tc #(
    .CLOCK_PERIOD (2.03450521)           //491.52 => 2.03450521  122.88 => 8.13802083  156.25 => 6.4 368.68Mhz => 2.7123793 245.76 => 4.06901042
) jb_marker_generation_nr_tc_fftout_inst(
    .clk(clk),
    .reset(reset),
    .car_en(car_en_d),
    .frm_mrkr(frm_mrkr_aligned_fft_out),
    .extended_cp(extended_cp),    
    
    //real time indicators
    .frm_mrkr_out(frm_mrkr_dly),      
    .frm_mrkr_sample_cnt(),
	.sub_frame_mrkr(subfrm_mrkr_dly),  
    .sub_frame_sample_cnt(),
	.sub_frame_cnt(),
	.slot_mrkr (slot_mrkr_dly),           
    .slot_mrkr_sample_cnt(),
	.slot_cnt(),                      
	.sym_mrkr(sym_mrkr_dly),              
    .sym_mrkr_pre(),                  
    .sym_mrkr_sample_cnt(),
	.sym_cnt(sym_cnt_dly),                
    .cp_mrkr(),                       
    
    //4x indicators
    .sym_mrkr_4x(),        
    .sym_cnt_4x()           
);     
   
//Zero data removal before sending to ORAN  
jb_fft_zero_data_removal_nr # (
    .USR_ID_BW (USR_ID_BW),
    .PRECISION (PRECISION)
) jb_fft_zero_data_removal_nr_inst
 (
    .clk(clk),
    .clk_en(clk_en),
    .reset(reset),
    .ch_bw_update_done(ch_bw_update_done), // i
	.test_mode(test_mode),
    .frm_mrkr(frm_mrkr_dly),               // i
    .subfrm_mrkr(subfrm_mrkr_dly),         // i
    .slot_mrkr(slot_mrkr_dly),             // i
    .sym_mrkr(sym_mrkr_dly),               // i
	.input_I(output_fft_I),                // i
    .input_Q(output_fft_Q),                // i
    .address(output_add),                  // i
    .dv(dv),                               // i 
	.fft_done(done),
    .output_I(output_I_FFT_zero),          // o 
    .output_Q(output_Q_FFT_zero),          // o
    .address_out(output_address_zero),     // o
    .antenna_out(antenna_out_zero),        // o
    .tvalid(output_FFT_zero_valid),        // o
    .tlast(output_FFT_zero_tlast),         // o  at 4x rate
    .tfirst(output_FFT_zero_tfirst),       // o  Will be symbol marker
    .frm_mrkr_out(frm_mrkr_zero),          // o
    .subfrm_mrkr_out(subfrm_mrkr_zero),    // o
    .slot_mrkr_out(slot_mrkr_zero),        // o
	.sym_mrkr_out(sym_mrkr_zero)
    );
       
//IQ Gain    
assign IFP_fft_to_gain.tdata  = {output_Q_FFT_zero, output_I_FFT_zero};  // {Q,I} Copy order from jb_dl_dfe_gen_input_iq.sv  
assign IFP_fft_to_gain.tvalid = output_FFT_zero_valid;
assign IFP_fft_to_gain.tuser  = {frm_mrkr_zero, sym_mrkr_zero, output_address_zero, antenna_out_zero};    
assign IFP_fft_to_gain.tlast  = output_FFT_zero_tlast;

    jb_lte_fft_gain # (
        .USR_ID_BW (USR_ID_BW + 11 + 3),  // include address and tfirst
        .PRECISION (PRECISION),
        .GAIN_SCALER_BW (GAIN_SCALER_BW)
     )  jb_lte_fft_gain_inst
     (
        .clk                           (clk),
        .clk_en                        (clk_en),
        .reset                         (reset),
        .IFP_fft_gain_in               (IFP_fft_to_gain),
        .ch_bw                         (current_ch_bw),       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
        
       // Output
        .IFP_fft_gain_out              (IFP_fft_from_gain)
        );     

assign frm_mrkr_out             = IFP_fft_from_gain.tuser[15];
assign sym_mrkr_out             = IFP_fft_from_gain.tuser[14];
assign IFP_fft_out.tuser        = IFP_fft_from_gain.tuser[13:0];
assign IFP_fft_out.tdata        = IFP_fft_from_gain.tdata;
assign IFP_fft_out.tlast        = IFP_fft_from_gain.tlast;
assign IFP_fft_out.tkeep        = IFP_fft_from_gain.tkeep;
assign IFP_fft_out.tvalid       = IFP_fft_from_gain.tvalid;
assign IFP_fft_from_gain.tready = IFP_fft_out.tready; 

//////for-sim

// shreg
    // #(
        // .DATA_WIDTH(4  ),
        // .DEPTH     (254  ) //               
    // )
    // u_delay_sym_cnt
    // (
        // .clk (clk),
        // .din (sym_cnt_dly),
        // .dout(sym_cnt_out)
    // ); 


ul_oran_ila_nr100m_fft
  ul_oran_ila_nr100m_fft_inst (
    .clk      (clk),
    .probe0   (frm_mrkr_dly),
    .probe1   (subfrm_mrkr_dly),
    .probe2   (slot_mrkr_dly),
    .probe3   (sym_mrkr_dly),
    .probe4   (output_fft_I),
    .probe5   (output_fft_Q),
    .probe6   (output_add),
    .probe7   (dv),
    .probe8   (done),
    .probe9   (output_I_FFT_zero),
    .probe10  (output_Q_FFT_zero),
	.probe11  (output_address_zero),
	.probe12  (antenna_out_zero),
	.probe13  (output_FFT_zero_valid),
	.probe14  (output_FFT_zero_tlast),
	.probe15  (output_FFT_zero_tfirst),
	.probe16  (frm_mrkr_zero),
	.probe17  (subfrm_mrkr_zero),
	.probe18  (slot_mrkr_zero),
    .probe19  (sym_mrkr_zero),
	.probe20  (fft_data_in      ),    
	.probe21  (fft_start        ),
	.probe22  (frm_mrkr_mem_out )
	
	);





endmodule
