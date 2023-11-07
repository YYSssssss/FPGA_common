
///// Description  : This module is dl_oran which is an interface block between radio IP and iFFT in Dl direction
////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps

module jb_dl_oran_mem_nr # (
    parameter N_ANTENNAS = 4,
    parameter IFFT_DATA_WIDTH = 16,
    parameter FH_DATA_WIDTH = 64

) (

      input 		       clk_oran,
      input 		       reset_oran,
      input 		       clk_ifft,
      input 		       reset_ifft,
      jb_ram_sp_if.mem         IFP_dl_oran2mem,
      jb_ram_sp_if.mem         IFP_dl_mem2ifft
   );

logic rsta_busy;
logic rstb_busy;

assign IFP_dl_oran2mem.rd_data=0;
   //----------- Memory  INSTANTIATION 
   dl_oran_mem_4kx64 u_dl_oran_mem_4kx64 (
    .clka(clk_oran),    // input wire clka
    .ena(IFP_dl_oran2mem.en),      // input wire ena
    .wea(IFP_dl_oran2mem.wr_en[0]),      // input wire [0 : 0] wea
    .addra(IFP_dl_oran2mem.addr),  // input wire [10 : 0] addra
    .dina(IFP_dl_oran2mem.wr_data),    // input wire [63 : 0] dina
    .clkb(clk_ifft),    // input wire clkb
    .rstb(reset_ifft),            // input wire rstb
    .enb(IFP_dl_mem2ifft.en),      // input wire enb
    .addrb(IFP_dl_mem2ifft.addr),  // input wire [11 : 0] addrb
    .doutb(IFP_dl_mem2ifft.rd_data),  // output wire [31 : 0] doutb
    
  .rsta_busy(rsta_busy),  // output wire rsta_busy
  .rstb_busy(rstb_busy)  // output wire rstb_busy
 );

endmodule // jb_dl_oran

                  
