
///// Description  : This module is dl_oran which is an interface block between radio IP and iFFT in Dl direction
////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module jb_dl_oran_nr # (
    parameter N_ANTENNAS = 4,
    parameter PRECISION = 16,
    parameter DEFM_TUSER_WIDTH  = 31,
    parameter FH_DATA_WIDTH = 64,
    parameter INST = 0

) (
   
     input 		    clk_4x, 
     input 		    clk_1x,
     input          radio_if_clk,
     input          radio_if_reset, 
     input 		    reset_1x,
     input 		    reset_4x,
     input 		    clk_en,
     input [3:0] 	dl_car_bw,
     input 		    dl_swap_ifft, 
      input         dl_iq_endianness, 

     input 		    extended_cp,
     input [N_ANTENNAS-1:0] ant_en,
     input 		    radio_en,

     input 		    dl_frm_mrkr_10ms,
   
     input 		    dl_sym_mrkr_4x_ifft,
   
     input 		    dl_pre_ifft_sym_mrkr,
     input 		    dl_ifft_sym_mrkr,



     output 		    dl_oran_ready,
			    
			    jb_axi4_stream_if.slave IFP_dl_oran[N_ANTENNAS-1:0], //from ORAN
			    jb_axi4_stream_if.master IFP_dl_oran_ifft  //to DFE

   );

   localparam SYMBOL_SIZE_1K=4; //ping, pong
   localparam WR_ADDR_WIDTH = 12;//add 1 bit for nr
   localparam RD_ADDR_WIDTH = 13;
   localparam IFFT_DATA_WIDTH=2*PRECISION;
   
   
     
   logic 		    sym_mrkr;
   logic 		    sym_mrkr_clk_4x;

   logic 		    sym_mrkr_pre;
   logic 		    sym_mrkr_4x;
   logic [2:0] dl_oran_ready_radio_sync;
   logic dl_oran_ready_radio_clk;
	 
   
   jb_ram_sp_if #(.DATA_WIDTH(IFFT_DATA_WIDTH), .ADDR_WIDTH(RD_ADDR_WIDTH)) IFP_dl_mem2ifft();
   jb_ram_sp_if #(.DATA_WIDTH(FH_DATA_WIDTH), .ADDR_WIDTH(WR_ADDR_WIDTH)) IFP_dl_oran2mem();
   jb_ram_sp_if #(.DATA_WIDTH(IFFT_DATA_WIDTH), .ADDR_WIDTH(RD_ADDR_WIDTH)) IFP_dbgbuf_portb();

 
 
jb_marker_generation_nr_tc #(
    .CLOCK_PERIOD   (2.5)  //491.52 => 2.03450521  122.88 => 8.13802083  156.25 => 6.4 368.68Mhz => 2.7123793 245.76 => 4.06901042
) u_dl_oran_marker_generation_nr_tc (
    .clk(radio_if_clk),
    .reset(radio_if_reset),
    .car_en(radio_en),
    .frm_mrkr(dl_frm_mrkr_10ms),
    .extended_cp(1'b0),    
    
     // real time indicators at clk input rate of 491.52Mhz
    .frm_mrkr_out(),                 // o 10ms Frame Marker aligned
    .frm_mrkr_sample_cnt(),   // o framer marker sample count [22:0]
    .sub_frame_mrkr(),             // o sub frame marker every 1ms
    .sub_frame_sample_cnt(), // o sub frame sample count [18:0]
    .sub_frame_cnt(),               // o sub frame count 0 to 9 [3:0]
    .slot_mrkr(),                       // o slot marker 0.5ms
    .slot_mrkr_sample_cnt(), // o slot marker sample count [17:0]
    .slot_cnt(),                         // o slot count 0 to 19 [4:0]
    .sym_mrkr(sym_mrkr),                         // o symbol marker  
    .sym_mrkr_pre(sym_mrkr_pre),                         // o symbol marker  
    .sym_mrkr_sample_cnt(),   // o symbol marker sample count [15:0]
    .sym_cnt(),                           // o symbol count [2:0]
    .cp_mrkr(),                            // o cp marker
    .sym_mrkr_4x(sym_mrkr_4x)
);   

/*   
 jb_sym_mrkr_gen jb_sym_mrkr_gen_inst (
    .clk(clk_1x),
    .clk_en(1'b1),
    .reset(reset_1x),
    .clk_frm_mrkr(clk_4x),                    // input clk for framer marker 491.52Mhz expected
    .reset_frm_mrkr(reset_4x),                // input reset for framer marker clock
    .car_en(radio_en),
    .frm_mrkr(dl_frm_mrkr_10ms),
    .ch_bw(4'd00),
    .extended_cp(extended_cp),    
    
     // real time indicators
    .frm_mrkr_out(),                    // o 10ms Frame Marker aligned
    .sub_frame_mrkr(),                // o 1ms Sub Frame Marker Aligned
    .slot_mrkr (),                         // o slot marker 0.5ms
    .sym_mrkr(sym_mrkr),                            // o symbol marker  
    .sym_mrkr_pre(sym_mrkr_pre),                    // o symbol marker one early
    .sym_cnt(),                              // o symbol count
    .cp_mrkr(),                              // o cp marker
    .slot_cnt(),                            // o slot count 
    .sample_cnt_per_slot(),      // o sample count per slot
    .sample_cnt_per_sym(),        // o sample count per symbol
    
     // 4x indicators
    .sym_mrkr_4x(sym_mrkr_4x),                       // o symbol marker at the 4x rate
    .sym_cnt_4x(),                         // o symbol count at the 4x rate
    .sample_cnt_4x_per_slot(), // o sample count per slot at 4x rate
    .sample_cnt_per_sym_4x()    // o sample count per symbol 4x rate

);     
 */  
  

   jb_dl_oran_schlr_nr #(
      .N_ANTENNAS               (N_ANTENNAS),
      .FH_DATA_WIDTH            (FH_DATA_WIDTH),                     
      .DEFM_TUSER_WIDTH         (DEFM_TUSER_WIDTH),
      .INST(INST)
   ) u_dl_oran_schlr_nr (
      .clk                      (radio_if_clk),
      .reset                    (radio_if_reset),
      .sym_mrkr                 (sym_mrkr),
      .pre_sym_mrkr             (sym_mrkr_pre),
      .sym_mrkr_4x              (sym_mrkr_4x),
      .dl_oran_ready            (dl_oran_ready_radio_clk),
      .car_bw                   (dl_car_bw),
      .ant_en                   (ant_en),
      .oran_en                  (radio_en),   //connect to bd
      .IFP_dl_oran_in           (IFP_dl_oran),  //per carrier
      .IFP_dl_oran2mem          (IFP_dl_oran2mem) 
     );

  always_ff @(posedge clk_4x) begin
     if (reset_4x) begin
	    dl_oran_ready_radio_sync <= 0;
     end
     else begin
        dl_oran_ready_radio_sync <= {dl_oran_ready_radio_sync[1:0],dl_oran_ready_radio_clk};
     end
   end
   
   assign dl_oran_ready = dl_oran_ready_radio_sync[2];

    jb_dl_oran_mem_nr #(
      .N_ANTENNAS               (N_ANTENNAS),
      .FH_DATA_WIDTH            (FH_DATA_WIDTH), 
      .IFFT_DATA_WIDTH          (IFFT_DATA_WIDTH)
    ) u_dl_oran_mem_nr  (
      .clk_oran                      (radio_if_clk),
      .reset_oran                    (radio_if_reset),     
      .clk_ifft                      (clk_4x),
      .reset_ifft                    (reset_4x),
      .IFP_dl_oran2mem          (IFP_dl_oran2mem),
      .IFP_dl_mem2ifft          (IFP_dl_mem2ifft)
    );
		      
   jb_dl_egress_nr #(
      .N_ANTENNAS               (N_ANTENNAS),
      .IFFT_DATA_WIDTH          (IFFT_DATA_WIDTH),
      .RD_ADDR_WIDTH            (RD_ADDR_WIDTH),
      .INST                     (INST)
   ) u_dl_egress_nr (
      .clk                      (clk_4x),
      .clk_en                   (clk_en),
      .reset                    (reset_4x),
      .dl_oran_en               (radio_en),
      .dl_car_bw                (dl_car_bw),
      .dl_swap_ifft             (dl_swap_ifft),
      .dl_iq_endianness         (dl_iq_endianness),
      .dl_oran_ready            (dl_oran_ready),
      .dl_pre_sym_mrkr          (dl_pre_ifft_sym_mrkr),
      .dl_sym_mrkr              (dl_ifft_sym_mrkr),
      .dl_sym_mrkr_4x_ifft      (dl_sym_mrkr_4x_ifft),    
      .IFP_dl_mem2ifft          (IFP_dl_mem2ifft),
      .IFP_dl_oran_out          (IFP_dl_oran_ifft) 
	);     
   endmodule
   
