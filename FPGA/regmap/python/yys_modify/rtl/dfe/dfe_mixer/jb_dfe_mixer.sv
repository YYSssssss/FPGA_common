
 module jb_dfe_mixer #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  NCO_COEF_WIDTH =40, //
      parameter  NCO_COUNT_WIDTH =39, //
      parameter  NCO_QUAD_LKUP_TBL_ENTRIES = 1024,
      parameter  NCO_COEF_2S_COMPLEMENT=0,
      parameter  PRECISION=16,
      parameter  MODE=0
   ) (

      input 		       clk,
      input 		       resetn,
      input                any_stream_enable,
      logic signed [N_CARRIERS-1:0] [NCO_COEF_WIDTH-1:0]	 nco_coef,

      // 0:C0A0,  1:C0A1, 2: C0A2, 3:C0
      input [N_CARRIERS-1:0] [N_ANTENNAS-1:0]   tvalid_in ,
      input [2*PRECISION-1:0]  tdata_in[N_CARRIERS-1:0] [N_ANTENNAS-1:0],
	    
	    //DPD outputs 2 arrays of axi stream
      output [N_CARRIERS-1:0] [N_ANTENNAS-1:0]   tvalid_out,
      output [2*PRECISION-1:0] tdata_out[N_CARRIERS-1:0][N_ANTENNAS-1:0]
      
      
      );

   localparam N_BYTES_AXI = $ceil((PRECISION*2)/8);
   localparam N_INTERLEAVE_CHANNELS = N_ANTENNAS;
   localparam N_INTERLEAVE_CHANNELS_BW = $clog2(N_INTERLEAVE_CHANNELS);
   localparam NCO_LATENCY=4;
   
   
   logic [NCO_COUNT_WIDTH-1:0] 			        nco_cntr;
   logic signed [N_CARRIERS-1:0] [2*PRECISION-1:0]      nco_sincos;
   logic 						nco_cntr_enable;
   
   logic [N_CARRIERS-1:0] [N_ANTENNAS-1:0]				tvalid_align2cmplx;   
   logic [2*PRECISION-1:0] 				tdata_align2cmplx[N_CARRIERS-1:0][N_ANTENNAS-1:0];

   
   localparam USER_ID_BW = $clog2(N_ANTENNAS);

   logic [79:0] 			cmplx_tdata_out[N_CARRIERS-1:0][N_ANTENNAS-1:0];
   logic [PRECISION-1:0] 		cmplx_tdata_i[N_CARRIERS-1:0][N_ANTENNAS-1:0];   
   logic [PRECISION-1:0] 		cmplx_tdata_q[N_CARRIERS-1:0][N_ANTENNAS-1:0];
   logic [PRECISION-1:0] 		s_mix_i[N_CARRIERS-1:0][N_ANTENNAS-1:0]; 
   logic [PRECISION-1:0] 		s_mix_q[N_CARRIERS-1:0][N_ANTENNAS-1:0]; 
   
   
   logic [N_CARRIERS-1:0] carrier_tvalid;
	
	genvar   i,j;
	 generate
	   for (i = 0; i <  N_CARRIERS; i = i + 1) begin		
	    assign carrier_tvalid[i] = |tvalid_in[i];
	   end 
	endgenerate
	
   assign nco_cntr_enable = (|carrier_tvalid) ;
   
   jb_cntr #(
      .COUNT_WIDTH(NCO_COUNT_WIDTH)
   ) u_jb_nco_cntr (
      .clk(clk),
      .resetn(resetn),
      .enable (nco_cntr_enable), //connect enable based ondivide every 4 cycles
      .max_value({NCO_COUNT_WIDTH{1'b1}}),
      .cntr(nco_cntr)
    );
 
   
   generate
     for (i = 0; i <  N_CARRIERS; i = i + 1) begin: dl_dfe_nco_inst 


	 
    jb_nco #(
	  .NCO_COEF_WIDTH(NCO_COEF_WIDTH),
          .NCO_COUNT_WIDTH(NCO_COUNT_WIDTH),
          .NCO_QUAD_LKUP_TBL_ENTRIES(NCO_QUAD_LKUP_TBL_ENTRIES),
          .NCO_COEF_2S_COMPLEMENT(NCO_COEF_2S_COMPLEMENT),
          .PRECISION (PRECISION),
	  .MODE(MODE)
	) u_nco (
          .clk(clk),
          .resetn(resetn),
	  .nco_cntr(nco_cntr),
          .nco_coef(nco_coef[i]),
	  .nco_sincos(nco_sincos[i])
	);
      for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: dl_dfe_cmplx_mult 	 
         jb_dfe_data_nco_align #(
           .PRECISION (PRECISION),
	   .N_ANTENNAS(N_ANTENNAS),
	   .NCO_LATENCY(NCO_LATENCY)
	 ) u_dfe_data_nco_align (
           .clk(clk),
           .resetn(resetn),
           .tvalid_in(tvalid_in[i][j]),
           .tdata_in(tdata_in[i][j]),
           .tvalid_out(tvalid_align2cmplx[i][j]),
           .tdata_out(tdata_align2cmplx[i][j])			 
	 );
	 
    //[zle] for timing, compared to previous setting, now pipeline is changed from 1 to 6
	 cmplx_mult_16 u_dl_nco_cmplx_mult (
           .aclk(clk),
           .s_axis_a_tvalid(tvalid_align2cmplx[i][j]),
           .s_axis_a_tdata(tdata_align2cmplx[i][j]),
           .s_axis_b_tvalid(tvalid_align2cmplx[i][j]),
           .s_axis_b_tdata(nco_sincos[i]),
           .m_axis_dout_tvalid(tvalid_out[i][j]),
           .m_axis_dout_tdata(cmplx_tdata_out[i][j])
        );

data_rnd_satu
    #( .DIN_WIDTH  (40),
	   .FRAC_WIDTH (15),
       .DOUT_WIDTH (16))
    data_rnd_satu_i
    ( 
    .i_rst       (1'b0                        ),
    .i_clk       (clk                         ),   
    .i_data      (cmplx_tdata_out[i][j][39:0] ),    
    .o_data      (s_mix_i[i][j]               )
    );

data_rnd_satu
    #( .DIN_WIDTH  (40),
	   .FRAC_WIDTH (15),
       .DOUT_WIDTH (16))
    data_rnd_satu_q
    ( 
    .i_rst       (1'b0                         ),
    .i_clk       (clk                          ),   
    .i_data      (cmplx_tdata_out[i][j][79:40] ),    
    .o_data      (s_mix_q[i][j]                )
    );



//	 assign cmplx_tdata_q[i][j] = cmplx_tdata_out[i][j][70:55];//truncate [54:40]
//	 assign cmplx_tdata_i[i][j] = cmplx_tdata_out[i][j][30:15];//30:15, 39:31 not used
	 assign cmplx_tdata_q[i][j] = s_mix_q[i][j];
	 assign cmplx_tdata_i[i][j] = s_mix_i[i][j];
  
	 assign tdata_out[i][j] = {cmplx_tdata_q[i][j],cmplx_tdata_i[i][j]};

      end : dl_dfe_cmplx_mult
	 
     end : dl_dfe_nco_inst
   endgenerate
		    
endmodule
