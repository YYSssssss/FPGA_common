`timescale 1ns / 1ps

module jb_lte_ifft_4096 # (
    parameter N_ANTENNAS=4,
    parameter USR_ID_BW=2,
    parameter PRECISION = 16,
    parameter GAIN_SCALER_BW  = 4,
    parameter INST = 1
)
 (
    input 	clk, // Clock for FFT
    input 	clk_en,
    input 	reset,
    input 	clk_frm_mrkr, // Input clock for frame marker.  491.52MHz expected.
    input 	reset_frm_mrkr, // Reset for frame marker clock
    input 	frm_mrkr,
    input 	car_en,
    input 	ready,
	jb_axi4_stream_if.slave IFP_ifft_in,
    input [3:0] ch_bw, // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    input 	extended_cp,
    input 	ch_bw_update_req,
    output 	sym_mrkr,
    output  sym_mrkr_pre,
    output 	sym_mrkr_4x,
    output 	ch_bw_update_done,
    output      dl_dfe_frm_mrkr,
    // Output
    input 	clk_dfe,
    input 	clk_en_dfe,
    input 	reset_dfe,
		jb_axi4_stream_if.master IFP_ifft_out,
    output 	cp_valid    
    ); 
    
logic [4:0] nfft_size;
logic [11:0]  scale_sch;
logic         nfft_we ;
logic         ctrl_we ;
logic start;
logic rfd;
logic [PRECISION-1:0] output_FFT_I;
logic [PRECISION-1:0] output_FFT_Q; 
logic [PRECISION-1:0] output_I_to_mem;
logic [PRECISION-1:0] output_Q_to_mem;
logic [2*PRECISION-1:0] output_from_mem; 
logic [PRECISION-1:0] output_I_from_mem;
logic [PRECISION-1:0] output_Q_from_mem; 
logic [PRECISION-1:0] input_I_FFT_zero; 
logic [PRECISION-1:0] input_Q_FFT_zero;    
logic overflow;
logic [3:0] current_ch_bw;
logic [4:0] nfft_size_set;
logic dv;
logic frame_marker;
logic [3:0] sym_cnt;
logic [3:0] sym_cnt_out;
logic [2:0] sym_cnt_4x;
logic [2:0] sym_cnt_4x_out;
logic [15:0] sample_cnt_4x_per_slot;  // samples in 1/2 subframe / slot
logic [15:0] sample_cnt_per_slot;  // samples in 1/2 subframe / slot
logic [15:0] sample_cnt_per_sym;  // samples in 1 symbol
logic [15:0] sample_cnt_per_sym_4x; // samples per symbol at 4x rate
logic cp_time;
logic frm_mrkr_out;
logic sym_mrkr_4x_out;
logic slot_mrkr;
logic slot_mrkr_out;
logic [11:0] output_add; //  add 1 bit for nr
logic [14:0] output_add_to_mem;//  add 1 bit for nr
logic [14:0] mem_read_add;//  add 1 bit for nr
logic dv_out;
logic bank_0_ready_to_read;
logic bank_1_ready_to_read;
logic cp_mrkr;
logic cp_mrkr_out;
logic first_symbol;
logic read_en;
logic dv_mem;
logic [USR_ID_BW-1:0] antenna_out;
logic cp_time_mem;
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ifft_to_gain();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_ifft_from_gain();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION+1), .USER_SB_WIDTH(USR_ID_BW))  IFP_ifft_to_dfe_cdc();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION+1), .USER_SB_WIDTH(USR_ID_BW))  IFP_ifft_from_dfe_cdc();
logic tvalid;
logic [USR_ID_BW-1:0] tuser;
logic tlast;
logic [PRECISION-1:0] input_I; 
logic [PRECISION-1:0] input_Q;
logic cp_out_gain;
logic [15:0] nscs_set;       // Number of carrier spacing
logic car_en_d = 0;
logic start_process = 0;
logic sub_frame_mrkr;
logic [4:0] slot_cnt;


assign input_I = IFP_ifft_in.tdata[PRECISION-1:0];
assign input_Q = IFP_ifft_in.tdata[2*PRECISION-1:PRECISION];
assign tvalid = IFP_ifft_in.tvalid;
assign tuser = IFP_ifft_in.tuser;
assign tlast = IFP_ifft_in.tlast;

// Register Carrrier enable.  It is will be "OR" in higher level
always_ff @(posedge clk) begin
    if (clk_en) begin
        car_en_d <= car_en;
    end
end

// jb_sym_mrkr_gen_nr jb_sym_mrkr_gen_nr_inst (
    // .clk(clk),
    // .clk_en(clk_en),
    // .reset(reset),
    // .clk_frm_mrkr(clk_frm_mrkr),                    // input clk for framer marker 491.52Mhz expected
    // .reset_frm_mrkr(reset_frm_mrkr),                // input reset for framer marker clock
    // .car_en(car_en_d),                              // input carrier enable
    // .frm_mrkr(frm_mrkr),
    // .ch_bw(ch_bw),
    // .extended_cp(extended_cp),    
    
     //real time indicators
    // .frm_mrkr_out(),                    // o 10ms Frame Marker aligned
    // .sub_frame_mrkr(),                // o 1ms Sub Frame Marker Aligned
    // .slot_mrkr (slot_mrkr),                         // o slot marker 0.5ms
    // .sym_mrkr(sym_mrkr),                            // o symbol marker  
    // .sym_mrkr_pre(sym_mrkr_pre),                    // o symbol marker one early
    // .sym_cnt(),                              // o symbol count
    // .cp_mrkr(cp_mrkr),                              // o cp marker
    // .slot_cnt(),                            // o slot count 
    // .sample_cnt_per_slot(),      // o sample count per slot
    // .sample_cnt_per_sym(),        // o sample count per symbol
    
     //4x indicators
    // .sym_mrkr_4x(sym_mrkr_4x),                       // o symbol marker at the 4x rate
    // .sym_cnt_4x(sym_cnt_4x),                         // o symbol count at the 4x rate
    // .sample_cnt_4x_per_slot(), // o sample count per slot at 4x rate
    // .sample_cnt_per_sym_4x()    // o sample count per symbol 4x rate

// );     

//tyh change for timming

 jb_marker_generation_nr_tc #(
       .CLOCK_PERIOD (2.03450521)           //491.52 => 2.03450521  122.88 => 8.13802083  156.25 => 6.4 368.68Mhz => 2.7123793 245.76 => 4.06901042
) jb_marker_generation_nr_tc_ifft_inst(
          .clk                     (clk),              // i clock  491.52Mhz
          .reset                   (reset),            // i reset
          .car_en                  (car_en_d),           // i car_en
          .frm_mrkr                (frm_mrkr),         // i 10ms frm_mrkr on 491.52Mhz. Pulse
          .extended_cp             (extended_cp),      // i  nr -- 30k:not support , 60k:support
    
    // Real time signals
         .frm_mrkr_out             (),          // o frame marker aligned
         .frm_mrkr_sample_cnt      (),   // o framer marker sample count
         .sub_frame_mrkr           (),        // o sub frame marker every 1ms
         .sub_frame_sample_cnt     (),  // o sub frame sample count
         .sub_frame_cnt            (),         // o sub frame count 0 to 9
         .slot_mrkr                (slot_mrkr),             // o slot marker every 0.5ms
         .slot_mrkr_sample_cnt     (),  // o slot marker sample count
         .slot_cnt                 (),              // o slot count 0 to 19
         .sym_mrkr                 (sym_mrkr),              // o symbol marker 
         .sym_mrkr_pre             (sym_mrkr_pre),          // o pre symbol marker 1 clock earlier
         .sym_mrkr_sample_cnt      (),   // o symbol marker sample count
         .sym_cnt                  (sym_cnt),               // o symbol count
         .cp_mrkr                  (cp_mrkr),               // o CP marker
         .sym_mrkr_4x              (sym_mrkr_4x),  // o sym marker 4x rate 
         .sym_cnt_4x		       (sym_cnt_4x)
    );





jb_bw_update_nr  # (
    .FFT_IFFT (0)  // 0 is IFFT. 1 is FFT, for different scaling
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

jb_ifft_zero_data_ins_nr # (
    .PRECISION (PRECISION)
) jb_ifft_zero_data_ins_nr_inst
 (
    .clk(clk),
    .clk_en(clk_en),
    .reset(reset),
    .input_I(input_I), 
    .input_Q(input_Q),  
    .rfd(rfd & ready),             // i 
    .nfft_size(nfft_size_set),     // i
    .nscs(nscs_set),               // i   
    .output_I(input_I_FFT_zero),   // o 
    .output_Q(input_Q_FFT_zero),  
    .rd_en_data(IFP_ifft_in.tready)
    );

// Qualify start
// Start when ready and first real symbol
always_ff @(posedge clk) begin
    if (clk_en) begin
        if (~ready) start_process <= 0;
        else if (ready && sym_mrkr_pre) start_process <= 1;        
    end
end

assign start = start_process & sym_mrkr_4x;

//tyh change time
logic start_1d;
logic start_2d;
logic start_3d;

always @ (posedge clk) begin
     start_1d <= start;
	 start_2d <= start_1d;
	 start_3d <= start_2d;
    end


lte_fft_4096 u_jb_lte_fft_4096 (
      .CLK(clk),                    // input wire CLK
      .CE(clk_en),                  // input wire CE
      .SCLR(~car_en_d),             // input wire SCLR
      .NFFT(nfft_size_set),         // input wire [4 : 0] NFFT
      .NFFT_WE(nfft_we),            // input wire NFFT_WE
      .START(start_3d),                // input wire START
      .CTRL_WE(ctrl_we),            // input wire CTRL_WE
      .SCALE_SCH(scale_sch),        // input wire [11 : 0] SCALE_SCH
      .FWD_INV(1'b0),               // input wire FWD_INV  0 - IFFT, 1 - FFT
      .XN0_RE(input_I_FFT_zero),    // input wire [15 : 0] XN0_RE
      .XN0_IM(input_Q_FFT_zero),    // input wire [15 : 0] XN0_IM
      .XK0_RE(output_FFT_I),        // output wire [27 : 0] XK0_RE
      .XK0_IM(output_FFT_Q),        // output wire [27 : 0] XK0_IM
      .OVFLO0(overflow),            // output wire OVFLO0
      .RFD(rfd),                    // output wire RFD
      .XN_INDEX(),                  // output wire [10 : 0] XN_INDEX
      .XK_INDEX(output_add),        // output wire [10 : 0] XK_INDEX
      .BUSY(),                      // output wire BUSY
      .EDONE(),                     // output wire EDONE
      .DONE(),                      // output wire DONE
      .DV(dv)                       // output wire DV
    );    
 
logic    frm_mrkr_dly = 1'b0;
always @ (posedge clk) begin
     frm_mrkr_dly <= frm_mrkr;
    end

shreg
    #(
        .DATA_WIDTH(1  ),
        .DEPTH     (4254+4101 ) //               
    )
    u_delay_frm_mrkr
    (
        .clk (clk),
        .din (frm_mrkr_dly),
        .dout(frm_mrkr_out)
    ); 

shreg
    #(
        .DATA_WIDTH(1  ),
        .DEPTH     (4253+4101  ) //               
    )
    u_delay_slot_mrkr
    (
        .clk (clk),
        .din (slot_mrkr),
        .dout(slot_mrkr_out)
    ); 

shreg
    #(
        .DATA_WIDTH(1  ),
        .DEPTH     (4253+4101  ) //               
    )
    u_delay_sym_mrkr
    (
        .clk (clk),
        .din (sym_mrkr),
        .dout(sym_mrkr_4x_out)
    ); 
    
shreg
    #(
        .DATA_WIDTH(1  ),
        .DEPTH     (4253+4101  ) //               
    )
    u_delay_cp_mrkr
    (
        .clk (clk),
        .din (cp_mrkr),
        .dout(cp_mrkr_out)
    );     
    
shreg
    #(
        .DATA_WIDTH(3  ),
        .DEPTH     (4253+4101  ) //               
    )
    u_delay_sym_cnt_4x
    (
        .clk (clk),
        .din (sym_cnt_4x),
        .dout(sym_cnt_4x_out)
    );       
    
shreg
    #(
        .DATA_WIDTH(4  ),
        .DEPTH     (4253+4101  ) //               
    )
    u_delay_sym_cnt
    (
        .clk (clk),
        .din (sym_cnt),
        .dout(sym_cnt_out)
    );      

jb_frm_mrkr_dly_nr  #(
           .DELAY_1024_UNITS(15), 
           .DELAY_ONE_CYCLE_UNITS(870)
       )   u_dl_fdfe_rm_mrkr_nr_dly (
           .clk                 (clk),
           .frm_mrkr_10ms       (frm_mrkr_out),
           .frm_mrkr_10ms_dlyd  (dl_dfe_frm_mrkr)
       );




   
// Write logic for Memory
jb_ifft_mem_write_nr # (
    .PRECISION (PRECISION)
) jb_ifft_mem_write_nr_inst (
      .clk(clk),                      // i clock  
      .clk_en(clk_en),                // i clock enable           
      .reset(reset),                  // i reset   
      .ch_bw(current_ch_bw),          // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz   
      .car_en(car_en_d),              // i  
      .dv(dv),                        // i  
      .frm_mrkr(frm_mrkr_out),        // i
      .slot_mrkr(slot_mrkr_out),      // i
      .sym_mrkr(sym_mrkr_4x_out),     // i
      .cp_mrkr(cp_mrkr_out),          // i
	  .sym_cnt(sym_cnt_out),
      .sym_cnt_4x(sym_cnt_4x_out),       // i
      .input_I(output_FFT_I),         // i
      .input_Q(output_FFT_Q),         // i 
      .input_add(output_add),         // i address
      .dv_out(dv_out),                // o
      .output_I(output_I_to_mem),     // o 
      .output_Q(output_Q_to_mem),     // o 
      .output_add(output_add_to_mem), // o
      .first_symbol(first_symbol),    // o
      .bank_0_ready_to_read(bank_0_ready_to_read), // o
      .bank_1_ready_to_read(bank_1_ready_to_read)  // o

    );

// Memory 
ifft_fft_mem_32kx32 ifft_fft_mem_nr_inst (
      .clka(clk),                                  // input wire clka
      .ena(clk_en),                                // input wire ena
      .wea(dv_out),                                // input wire [0 : 0] wea
      .addra(output_add_to_mem),                   // input wire [13 : 0] addra
      .dina({output_Q_to_mem,output_I_to_mem}),    // input wire [31 : 0] dina
      .douta(),                                    // output wire [31 : 0] douta
      .clkb(clk),                                  // input wire clkb
      .enb(clk_en),                                // input wire enb
      .web('b0),                                   // input wire [0 : 0] web
      .addrb(mem_read_add),                        // input wire [13 : 0] addrb
      .dinb('d0),                                  // input wire [31 : 0] dinb
      .doutb(output_from_mem)                      // output wire [31 : 0] doutb
);

assign output_Q_from_mem = output_from_mem[2*PRECISION-1:PRECISION];
assign output_I_from_mem = output_from_mem[PRECISION-1:0];

// Read logic.  Need to read out CP and data
jb_ifft_mem_read_nr jb_ifft_mem_read_nr_inst (
      .clk(clk),                                   // i clock  
      .clk_en(clk_en),                             // i clock enable           
      .reset(reset),                               // i reset   
      .ch_bw_update_done(ch_bw_update_done),       // i
      .ch_bw(current_ch_bw),                       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz    
      .car_en(car_en_d),                           // i  
      .extended_cp(extended_cp),                   // i
      .first_symbol(first_symbol),                 // i
      .bank_0_ready_to_read(bank_0_ready_to_read), // i
      .bank_1_ready_to_read(bank_1_ready_to_read), // i
      .read_en(read_en),                           // o Aligns with output address
      .output_add(mem_read_add),                   // o
      .dv_mem(dv_mem),                             // o Aligns with mem 2 cycle read delay
      .antenna_out(antenna_out),                   // o Aligns with mem 2 cycle read delay
      .cp_mrkr(cp_time_mem)                        // o Aligns with mem 2 cycle read delay
);       

// IQ Gain    
assign IFP_ifft_to_gain.tdata  = {output_Q_from_mem, output_I_from_mem};  // {Q,I} Copy order from jb_dl_dfe_gen_input_iq.sv  
assign IFP_ifft_to_gain.tvalid = dv_mem;
assign IFP_ifft_to_gain.tuser  = antenna_out;  

    jb_lte_ifft_gain_nr # (
        .USR_ID_BW (USR_ID_BW),
        .PRECISION (PRECISION),
        .GAIN_SCALER_BW (GAIN_SCALER_BW)
     )  jb_lte_ifft_gain_nr_inst
     (
        .clk                            (clk),
        .clk_en                         (clk_en),
        .reset                          (reset),
        .IFP_ifft_gain_in               (IFP_ifft_to_gain),
        .ch_bw                          (current_ch_bw),       // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
        .cp_in                          (cp_time_mem),
        
        // Output
        .IFP_ifft_gain_out              (IFP_ifft_from_gain),
        .cp_out                         (cp_out_gain)    
        );     
           
//  Move to DFE domain
//assign IFP_ifft_to_dfe_cdc.tdata  = {cp_out_gain, IFP_ifft_from_gain.tdata};  // {Q,I} Copy order from jb_dl_dfe_gen_input_iq.sv  // Added CP to data for CDC
//assign IFP_ifft_to_dfe_cdc.tvalid = IFP_ifft_from_gain.tvalid;
//assign IFP_ifft_to_dfe_cdc.tuser  = IFP_ifft_from_gain.tuser;
/*
// This only does data, user and valid.  NOTHING ELSE!!!
jb_axis_sync_fastc_slowc #(
        .FAST_TO_SLOW_RATIO     (4),  // Ratio of clocks
        .FAST_TO_SLOW_RATIO_BW  (2),  // Ratio of 2 is equal.  4 is 2
        .DATA_BW                (2*PRECISION + 1),
        .USR_ID_BW              (USR_ID_BW)			   
    ) u_ifft_491_122_nr  (
        .clk_slow_en            (clk_en_dfe),
        .clk_fast_en            (clk_en),
        .clk_slow               (clk_dfe),
        .clk_fast               (clk),
			  
        .resetn_clk_fast        (!reset),
        .resetn_clk_slow        (!reset_dfe),
			  
        .IFP_axis_in            (IFP_ifft_to_dfe_cdc),
        .IFP_axis_out           (IFP_ifft_from_dfe_cdc)
    );
 */   


// Set outputs
//assign IFP_ifft_out.tdata  = (ifft_out_tvalid) ? ifft_out_tdata[2*PRECISION-1:0]  : 0; 
//assign IFP_ifft_out.tvalid = ifft_out_tvalid;
//assign IFP_ifft_out.tuser  = (ifft_out_tvalid) ? ifft_out_tuser : 0; //antenna_out;
//assign IFP_ifft_out.tkeep  = (ifft_out_tvalid) ? 4'hF : 0;    //Not used, All bytes are valid all the time tvalid is 1
//assign IFP_ifft_out.tlast  = (ifft_out_tvalid) ? 'b0 : 0;    //Not used.  Based on jb_dl_dfe_gen_input_iq.sv
//assign cp_valid            = (ifft_out_tvalid) ? ifft_out_cp_valid : 0;  //cp_time_mem;

assign IFP_ifft_out.tdata  = ifft_out_tdata_d ; 
assign IFP_ifft_out.tvalid = ifft_out_tvalid_d;
assign IFP_ifft_out.tuser  = ifft_out_tuser_d ; //antenna_out;
assign IFP_ifft_out.tkeep  = ifft_out_tkeep_d ;    //Not used, All bytes are valid all the time tvalid is 1
assign IFP_ifft_out.tlast  = ifft_out_tlast_d ;    //Not used.  Based on jb_dl_dfe_gen_input_iq.sv
assign cp_valid            = ifft_out_cp_valid_d;  //cp_time_mem;

//tyh add for timming
logic [2*PRECISION-1:0] ifft_out_tdata     ;
logic                   ifft_out_tvalid    ;
logic [USR_ID_BW-1:0]   ifft_out_tuser     ;
logic [3:0]             ifft_out_tkeep     ;
logic [0:0]             ifft_out_tlast     ;
logic [0:0]             ifft_out_cp_valid  ;

logic [2*PRECISION-1:0] ifft_out_tdata_d     ;
logic                   ifft_out_tvalid_d    ;
logic [USR_ID_BW-1:0]   ifft_out_tuser_d     ;
logic [3:0]             ifft_out_tkeep_d     ;
logic [0:0]             ifft_out_tlast_d     ;
logic [0:0]             ifft_out_cp_valid_d  ;


always @(posedge clk) begin
      ifft_out_tdata    <= IFP_ifft_from_gain.tdata ;
      ifft_out_tvalid   <= IFP_ifft_from_gain.tvalid ;
      ifft_out_tuser    <= IFP_ifft_from_gain.tuser ;
      ifft_out_tkeep    <= 4'hF ;
      ifft_out_tlast    <= 1'b0 ;
      ifft_out_cp_valid <= cp_out_gain ;
end

always @(posedge clk) begin
      if(ifft_out_tvalid)
	    begin			  	  
	       ifft_out_tdata_d    <= ifft_out_tdata ;
           ifft_out_tuser_d    <= ifft_out_tuser ;
           ifft_out_tkeep_d    <= ifft_out_tkeep ;
           ifft_out_tlast_d    <= ifft_out_tlast ;
           ifft_out_cp_valid_d <= ifft_out_cp_valid ;
		end  
	  else
        begin			  	  
	       ifft_out_tdata_d    <= 0 ;
           ifft_out_tuser_d    <= 0 ;
           ifft_out_tkeep_d    <= 0 ;
           ifft_out_tlast_d    <= 0 ;
           ifft_out_cp_valid_d <= 0 ;
		end     				   
end

always @(posedge clk) begin
           ifft_out_tvalid_d <= ifft_out_tvalid ;
end


//generate 
//if (INST == 0) begin 
//ila_ifft ila_ifft_inst (
//	.clk(clk), // input wire clk

//	.probe0(IFP_ifft_in.tdata[31:16]), // input wire [15:0]  probe0  
//	.probe1(IFP_ifft_in.tdata[15:0]), // input wire [15:0]  probe1 
//	.probe2(IFP_ifft_in.tuser), // input wire [1:0]  probe2 	
//	.probe3(IFP_ifft_out.tuser[1:0]), // input wire [1:0]  probe3 
//	.probe4(IFP_ifft_out.tdata[31:16]), // input wire [15:0]  probe4 
//	.probe5(IFP_ifft_out.tdata[15:0]), // input wire [15:0]  probe5 
//	.probe6(IFP_ifft_out.tvalid), // input wire [0:0]  probe6
//	.probe7(cp_valid),
//	.probe8(frame_marker),	
//	.probe9(sym_mrkr), // input wire [0:0]  probe9
//	.probe10(start), // input wire [0:0]  probe10
//	.probe11(dv), // 1
//    .probe12(sym_mrkr_4x_out),
//    .probe13(output_FFT_I),
//    .probe14(output_FFT_Q),
//    .probe15(output_add), // 1
//    .probe16(output_add_to_mem),
//    .probe17(output_I_to_mem),
//    .probe18(output_Q_to_mem),// 1
//    .probe19(antenna_out),
//    .probe20(mem_read_add),
//    .probe21(output_Q_from_mem),
//    .probe22(output_I_from_mem),
//    .probe23(clk_en),
//	.probe24(overflow), // input wire [0:0]  probe11
//    .probe25(IFP_ifft_in.tvalid),	
//	.probe26(frm_mrkr_out), // input wire [0:0]  probe9
//	.probe27(current_ch_bw[1:0])// 2
//);
//end
//endgenerate

endmodule
