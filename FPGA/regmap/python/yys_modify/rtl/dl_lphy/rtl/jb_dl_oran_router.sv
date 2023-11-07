
///// Description  : This module is an interface block between Radio IF IP and iFFT block   
////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps


module jb_dl_oran_router #(
    parameter N_ANTENNAS= 4,
    parameter N_CARRIERS=2,
    parameter FH_DATA_WIDTH=64,
    parameter DEFM_TUSER_WIDTH=31
) (
      input 	  clk,
      input       reset,
		  
      jb_axi4_stream_if.slave IFP_fh_defm[N_ANTENNAS-1:0], //From Radio IF IP
      //jb_axi4_stream_if.master IFP_dl_oran_c0[N_ANTENNAS-1:0] // to ORAN_IFFT, not sure about 2 Dimensional arrays
      //jb_axi4_stream_if.master IFP_dl_oran_c1[N_ANTENNAS-1:0] // to ORAN_IFFT
      jb_axi4_stream_if.master IFP_dl_oran[N_CARRIERS-1:0][N_ANTENNAS-1:0] // to ORAN_IFFT, not sure about 2 Dimensional arrays
		  
);

  `include  "jb_common.svh"

   localparam N_ANTENNAS_BW=$clog2(N_ANTENNAS);
   localparam N_CARRIERS_BW=$clog2(N_CARRIERS);
   
   
   
   logic [N_ANTENNAS-1:0] [N_CARRIERS_BW-1:0]   car_id;
   logic [N_ANTENNAS-1:0]		        symb_mrkr;
   logic [N_ANTENNAS-1:0] 		        rb;
   logic [N_ANTENNAS-1:0] [3:0] 		iq_signal_width;//16
   logic [N_ANTENNAS-1:0] [2:0] 		compression_type;//0  [3:0]-> 2:0
   logic [N_ANTENNAS-1:0] [8:0] 		num_rb; //add 1 bit for nr 100 ->273
   logic [N_ANTENNAS-1:0] [9:0] 		start_rb; //0
   
   
   
   
    genvar 			  i,j;
   generate
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : fh_ant_assign
	  //tuser decode for debug
         assign car_id[i]           = IFP_fh_defm[i].tuser[29:28];
         assign symb_mrkr[i]        = IFP_fh_defm[i].tuser[27];
         assign rb[i]               = IFP_fh_defm[i].tuser[26];
         assign iq_signal_width[i]  = IFP_fh_defm[i].tuser[25:22]; 
         assign compression_type[i] = IFP_fh_defm[i].tuser[21:18];//IFP_fh_defm[i].tuser[21:18]; 
         assign num_rb[i]           = IFP_fh_defm[i].tuser[17:10];//IFP_fh_defm[i].tuser[17:10]; 
         assign start_rb[i]         = IFP_fh_defm[i].tuser[9:0];

	 /*
	 //check for comb loop tready going back without flop, hope xilinx is latching
	 assign IFP_dl_oran_c0[i].tvalid = IFP_fh_defm[i].tvalid & (car_id[i]==CAR0_ID);
	 assign IFP_dl_oran_c0[i].tdata = (car_id[i]==CAR0_ID) ? IFP_fh_defm[i].tdata : 0;
	 assign IFP_dl_oran_c0[i].tkeep = (car_id[i]==CAR0_ID) ? IFP_fh_defm[i].tkeep : 0;
	 assign IFP_dl_oran_c0[i].tlast = IFP_fh_defm[i].tlast & (car_id[i]==CAR0_ID);
	 assign IFP_dl_oran_c0[i].tuser    = (car_id[i]==CAR0_ID) ? IFP_fh_defm[i].tuser :  0;

	 
	 assign IFP_dl_oran_c1[i].tvalid = IFP_fh_defm[i].tvalid && (car_id[i]==CAR1_ID);
	 assign IFP_dl_oran_c1[i].tdata = (car_id[i]==CAR1_ID) ? IFP_fh_defm[i].tdata : 0;
	 assign IFP_dl_oran_c1[i].tkeep = (car_id[i]==CAR1_ID) ? IFP_fh_defm[i].tkeep : 0;
	 assign IFP_dl_oran_c1[i].tlast = IFP_fh_defm[i].tlast && (car_id[i]==CAR1_ID);
	 assign IFP_dl_oran_c1[i].tuser    = (car_id[i]==CAR1_ID) ? IFP_fh_defm[i].tuser :  0;
      */
	 
	 //assign IFP_fh_defm[i].tready = (car_id[i]==CAR0_ID) ? IFP_dl_oran_c0[i].tready : IFP_dl_oran_c1[i].tready;
	 //assign IFP_fh_defm[i].tready = (car_id[i]==0) ? IFP_dl_oran[0][i].tready : IFP_dl_oran[1][i].tready; //passing an index to 2-D interface array
	   assign IFP_fh_defm[i].tready = IFP_dl_oran[0][i].tready;
         for (j = 0; j <  N_CARRIERS; j = j + 1) begin : fh_ant_assign	
	    assign IFP_dl_oran[j][i].tvalid = IFP_fh_defm[i].tvalid & (car_id[i]==j);
	    assign IFP_dl_oran[j][i].tdata = (car_id[i]==j) ? IFP_fh_defm[i].tdata : 0;
	    assign IFP_dl_oran[j][i].tkeep = (car_id[i]==j) ? IFP_fh_defm[i].tkeep : 0;
	    assign IFP_dl_oran[j][i].tlast = IFP_fh_defm[i].tlast & (car_id[i]==j);
	    assign IFP_dl_oran[j][i].tuser    = (car_id[i]==j) ? IFP_fh_defm[i].tuser :  0;
	 end
      end : fh_ant_assign 
   
   endgenerate
   
endmodule // jb_dl_oran_router
