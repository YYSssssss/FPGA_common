
`timescale 1 ps / 1 ps


module jb_rfbuf #(
    parameter N_ANTS_SEL       =2,
    parameter N_ANTENNAS       =4,
    parameter N_CARRIERS       =2,	
    parameter DFE_PRECISION    =16,
    parameter DBGBUF_ADDR_WIDTH=32,
    parameter DBGBUF_DATA_WIDTH=64	
) (
      input                      clk_3x                 ,
      input                      clk_1x                 ,
      input                      resetn_3x              ,
      input                      resetn_1x              ,
      input [N_ANTS_SEL-1:0][N_CARRIERS-1:0] dl_clk_x1en   ,	
      input [N_ANTS_SEL-1:0][N_CARRIERS-1:0] ul_clk_x1en   ,
	  input                      syn_data_dl_ul_5ms     , 	  
      input                      ptp_clk                ,
      input                      ptp_align_pulse        ,
      input                      dbgbuf_porta_rst       ,
      input                      dbgbuf_porta_clk       ,
      input                      rssi_load              ,
      input                      pa_odp_tssi_le         , 
      output logic  [(N_ANTS_SEL*N_ANTENNAS)-1:0][31:0] pa_odp_tssi,
	  
      jb_ram_sp_if.mem           IFP_dbgbuf_porta  ,	  
      jb_test_ctrl_if.test_dbg   IFP_test_ctrl     ,     
      jb_test_ctrl_if.test_stat  IFP_test_stat     ,
      jb_hw_ctrl_if.hw_ctrl      IFP_hw_ctrl       ,	  
      jb_axi4_stream_if.slave    IFP_srx[N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //incoming
      jb_axi4_stream_if.slave    IFP_adc[N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //incoming   
      jb_axi4_stream_if.slave    IFP_adc_iq[N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //incoming  
      jb_axi4_stream_if.master   IFP_dac[N_ANTS_SEL-1:0][N_ANTENNAS-1:0]       , //drive         
      jb_axi4_stream_if.slave    IFP_fh_dl[N_ANTS_SEL-1:0][N_CARRIERS-1:0]     ,
      jb_axi4_stream_if.master   IFP_fh_ul[N_ANTS_SEL-1:0][N_CARRIERS-1:0]     ,
      jb_axi4_stream_if.slave    IFP_fh_ul_test_data[N_ANTS_SEL-1:0]           ,      
      jb_axi4_stream_if.master   IFP_ul_dfe_in[N_ANTS_SEL-1:0][N_ANTENNAS-1:0] ,     
      jb_axi4_stream_if.master   IFP_dl_dfe_in[N_ANTS_SEL-1:0][N_CARRIERS-1:0] ,
      jb_axi4_stream_if.slave    IFP_ul_dfe_out[N_ANTS_SEL-1:0][N_CARRIERS-1:0],  
      jb_axi4_stream_if.slave    IFP_dl_dfe_out[N_ANTS_SEL-1:0][N_ANTENNAS-1:0]     
	  		   
       				   
				    

);

     `include  "jb_common.svh"

   jb_ram_sp_if #(.DATA_WIDTH(DBGBUF_DATA_WIDTH), .ADDR_WIDTH(DBGBUF_ADDR_WIDTH)) IFP_dbgbuf_portb();

   logic                       s_first_cycle_acc;
   logic [63:0] 		       s_rd_data        ;   
   logic                       dbgbuf_portb_rst ;   
   assign dbgbuf_portb_rst = ~resetn_3x;   

   logic  [(N_ANTS_SEL*N_ANTENNAS)-1:0][31:0] ant_tssi;
   logic  [(N_ANTS_SEL*N_ANTENNAS)-1:0][31:0] ul_ant_wrssi;
   logic  [(N_ANTS_SEL*N_ANTENNAS)-1:0][31:0] orx_wrssi;

    jb_axi4_stream_if   #(.DATA_WIDTH(32))                      IFP_srx_copy        [N_ANTS_SEL-1:0] [N_ANTENNAS-1:0] ();
    jb_axi4_stream_if   #(.DATA_WIDTH(32), .USER_SB_WIDTH(2))   IFP_adc_copy        [N_ANTS_SEL-1:0] [N_ANTENNAS-1:0] ();
    jb_axi4_stream_if   #(.DATA_WIDTH(64), .USER_SB_WIDTH(2))   IFP_dl_dfe_out_copy [N_ANTS_SEL-1:0] [N_ANTENNAS-1:0] ();

// This is to avoid multi-driven nets
genvar band;
genvar ant;
generate
for (band = 0; band < N_ANTS_SEL;    band = band + 1) begin
for (ant  = 0; ant  < N_ANTENNAS; ant  = ant  + 1) begin
    assign IFP_srx_copy[band][ant].tvalid           = IFP_srx[band][ant].tvalid;
    assign IFP_srx_copy[band][ant].tdata            = IFP_srx[band][ant].tdata;
    assign IFP_adc_copy[band][ant].tvalid           = IFP_adc[band][ant].tvalid;
    assign IFP_adc_copy[band][ant].tdata            = IFP_adc[band][ant].tdata;
    assign IFP_dl_dfe_out_copy[band][ant].tvalid    = IFP_dl_dfe_out[band][ant].tvalid;
    assign IFP_dl_dfe_out_copy[band][ant].tdata     = IFP_dl_dfe_out[band][ant].tdata;
end
end
endgenerate   
    

//jb_rfbuf_input #(
//       .N_ANTS_SEL (N_ANTS_SEL),
//       .N_ANTENNAS (N_ANTENNAS),
//       .N_CARRIERS (N_CARRIERS),
//       .DFE_PRECISION(DFE_PRECISION)
//   ) u_rfbuf_input (
//       .clk_3x                     (clk_3x            ),
//       .clk_1x                     (clk_1x            ),
//       .resetn_3x                  (resetn_3x         ),
//       .resetn_1x                  (resetn_1x         ),
//       .ptp_clk                    (ptp_clk           ),
//       .ptp_align_pulse            (ptp_align_pulse   ),
//       .IFP_test_ctrl               (IFP_test_ctrl      ),
//       .IFP_srx                    (IFP_srx_copy      ),
//       .IFP_adc                    (IFP_adc_copy      ),
//       .IFP_dl_dfe_out             (IFP_dl_dfe_out_copy ),
//       .IFP_bram_dbgbuf            (IFP_dbgbuf_portb  ),
//	   .o_first_cycle_acc          (s_first_cycle_acc ),
//       .o_rd_data                  (s_rd_data         )	   
//   );
   


//jb_dbgmux_mem #(
//	.BD_LATENCY_SETTING(15)   // This parameter must; (a) be at least 12, (b) match the setting in the Block Design.
//	)jb_dbgmux_mem_inst (
//      .axi_clk    (dbgbuf_porta_clk           ),//input wire clka
//      .axi_rst    (dbgbuf_porta_rst           ),//input wire rsta
//      .axi_en     (IFP_dbgbuf_porta.en        ),//input wire ena
//      .axi_we     (IFP_dbgbuf_porta.wr_en     ),//input wire [7 : 0] wea
//      .axi_addr   (IFP_dbgbuf_porta.addr[19:0]),//input wire [31 : 0] addra
//      .axi_din    (IFP_dbgbuf_porta.wr_data   ),//input wire [63 : 0] dina
//      .axi_dout   (IFP_dbgbuf_porta.rd_data   ),//output wire [63 : 0] douta
//      .dbg_clk    (clk_3x                     ),//input wire clkb
//      .dbg_rst    (dbgbuf_portb_rst           ),//input wire rstb
//      .dbg_en     (IFP_dbgbuf_portb.en        ),//input wire enb
//      .dbg_we     (IFP_dbgbuf_portb.wr_en     ),//input wire [7 : 0] web
//      .dbg_addr   (IFP_dbgbuf_portb.addr[19:0]),//input wire [31 : 0] addrb
//      .dbg_din    (IFP_dbgbuf_portb.wr_data   ),//input wire [63 : 0] dinb
//      .dbg_dout   (IFP_dbgbuf_portb.rd_data   ) //output wire [63 : 0] doutb
//	);



genvar j;
generate
for (j = 0; j < N_ANTS_SEL; j = j + 1) begin

jb_dbgmux_perband #(
       .N_ANTS_SEL (j),
       .N_ANTENNAS (N_ANTENNAS),
       .N_CARRIERS (N_CARRIERS),
       .DFE_PRECISION(DFE_PRECISION)
   ) u_dbgmux_perband (
       .clk_3x                 (clk_3x                           ),
       .clk_1x                 (clk_1x                           ),
       .dl_clk_x1en            (dl_clk_x1en[j]                   ),// i [N_CARRIERS-1:0]
       .ul_clk_x1en            (ul_clk_x1en[j]                   ),// i [N_CARRIERS-1:0]
       .resetn_3x              (resetn_3x                        ),
       .resetn_1x              (resetn_1x                        ),
	   .syn_data_dl_ul_5ms     (syn_data_dl_ul_5ms               ),	
	   .i_first_cycle_acc      (s_first_cycle_acc                ),
	   .i_rd_data              (s_rd_data                        ),
	   .i_en                   (IFP_dbgbuf_portb.en              ),
       .rssi_load              (rssi_load                        ),// i
       .pa_odp_tssi_le         (pa_odp_tssi_le                   ),// i
       .pa_odp_tssi            (pa_odp_tssi[(4*j+N_ANTENNAS)-1:4*j+0]),// o [3:0] [31:0]
       .IFP_test_ctrl          (IFP_test_ctrl                    ),
	   .IFP_hw_ctrl            (IFP_hw_ctrl                      ),	   
       .ant_tssi               (ant_tssi       [(4*j+N_ANTENNAS)-1:4*j+0]),
       .ul_ant_wrssi           (ul_ant_wrssi   [(4*j+N_ANTENNAS)-1:4*j+0]),
       .orx_wrssi              (orx_wrssi      [(4*j+N_ANTENNAS)-1:4*j+0]),
       .IFP_srx                (IFP_srx[j]                       ),
       .IFP_adc                (IFP_adc[j]                       ),
       .IFP_adc_iq             (IFP_adc_iq[j]                       ),
       .IFP_dac                (IFP_dac[j]                       ),
       .IFP_fh_dl              (IFP_fh_dl[j]                     ),
       .IFP_fh_ul              (IFP_fh_ul[j]                     ),
       .IFP_fh_ul_test_data    (IFP_fh_ul_test_data[j]           ),
       .IFP_dl_dfe_out         (IFP_dl_dfe_out[j]                ),
       .IFP_ul_dfe_in          (IFP_ul_dfe_in[j]                 ),	
       .IFP_dl_dfe_in          (IFP_dl_dfe_in[j]                 ),
       .IFP_ul_dfe_out         (IFP_ul_dfe_out[j]                ) //i{q,i} concatenated
   );
      
end
endgenerate   


assign IFP_test_stat.ant_tssi        = ant_tssi;
assign IFP_test_stat.ul_ant_wrssi    = ul_ant_wrssi;
assign IFP_test_stat.orx_wrssi       = orx_wrssi;


endmodule
	     
