
 module jb_fhbuf_input #(
	  parameter  N_ANTS_SEL       =2     ,
      parameter  N_ANTENNAS       =4     ,
      parameter  N_CARRIERS       =2     ,	  
      parameter  MAX_NUM_SAMPLES  =307200,
      parameter  PRECISION        =16    
//      parameter  OVER_SAMPLE_RATIO=4  
   ) (
      input                     clk_x1en                  ,
      input                     clk_1x                    ,
      input                     resetn                    ,
	  input 					IFP_iwavebuf_porta_rst    ,
      input                     IFP_iwavebuf_porta_clk    ,	
      input                     dl_dfe_frm_mrkr           ,	  
	  jb_ram_sp_if.mem          IFP_iwavebuf_porta        ,      
      jb_test_ctrl_if.test_dbg  IFP_test_ctrl              ,
      jb_axi4_stream_if.slave   IFP_dl_dfe_in[N_ANTS_SEL-1:0][N_CARRIERS-1:0],
      jb_axi4_stream_if.master  IFP_dl_dfe_out         	  	        
      );
   `include "jb_common.svh"

   localparam N_INTERLEAVE_CHANNELS = N_ANTENNAS;
   //localparam MAX_NUM_SAMPLES_BW = $clog2(MAX_NUM_SAMPLES);//15
//   localparam MAX_NUM_SAMPLES_BW = 20;
   localparam MAX_NUM_SAMPLES_BW = 15;
   //localparam OVER_SAMPLES_RATIO_BW = $clog2(OVER_SAMPLE_RATIO); //  clk_freq(491.52)/(sample freq*n_antennas(30.72*4)
   
   localparam OVER_SAMPLES_RATIO_BW = 2; //  clk_freq(491.52)/(sample freq*n_antennas(30.72*4)
   //localparam N_INTERLEAVE_CHANNELS_BW = $clog2(N_INTERLEAVE_CHANNELS);
   localparam N_INTERLEAVE_CHANNELS_BW = 2;
   localparam N_BYTES_AXI = $ceil((PRECISION*2)/8);

   localparam ADDR_LATENCY=4;
   localparam ADDR_LATENCY_BW=2;
   
   
   logic [MAX_NUM_SAMPLES_BW-1:0]       num_of_samples    ; //config
   logic [MAX_NUM_SAMPLES_BW-1:0]       iq_ptr            ;
   logic 			                    iq_gen_mode       ; //debug mode
   logic 			                    iq_gen_mode_en    ; //debug mode
   logic 			                    dl_test_store_en  ;
   logic [N_INTERLEAVE_CHANNELS_BW-1:0] usr_id_cntr       ;
   logic [PRECISION-1:0]                real_value        ;
   logic [PRECISION-1:0]                imag_value        ;
   logic [2*PRECISION-1:0]              data              ;
   logic 		                        data_valid        ;  
   logic                                iq_gen_cntr_enable;
   logic                                start_pulse       ;
   logic                                rom_sleep         ;
   logic [ADDR_LATENCY_BW-1:0]          addr_lat_cntr     ;
   logic [1:0] 		                    store_ant_sel     ;
   logic 		                        wr_en             ;
   logic [2*PRECISION-1:0]              wr_data           ;
   logic [2*PRECISION-1:0]              s_fhbuf_data      ;  
   logic                                s_fhbuf_tvalid    ;   
   logic [1:0] 		                    s_fhbuf_tuser     ;   
   dl_inp_addr_sm_t inp_addr_sm;
   dl_inp_data_sm_t inp_data_sm;
   


   
   assign  IFP_dl_dfe_out.tlast  =1'b0; //not used
   //Connect them later
   assign dl_test_store_en= IFP_test_ctrl.dl_test_store_en;
   assign iq_gen_mode_en  = IFP_test_ctrl.dl_test_mode_en;
   assign iq_gen_mode     = IFP_test_ctrl.dl_test_mode;
   assign num_of_samples  = (IFP_test_ctrl.dl_test_mode_num_samples!=0) ? IFP_test_ctrl.dl_test_mode_num_samples[MAX_NUM_SAMPLES_BW-1:0] -1 : 0;
   assign rom_sleep       = !IFP_test_ctrl.dl_test_mode_en;
   assign store_ant_sel   = 0;
   
   // We need to generate clk_enables based on bandwidth
   // Since we are sharing the filter among them

 
    // Make the pulse wide enough so it can be captured by the slowest clk_1xen
    // Slowest clk_1xen is div4, so 4 cycles wide pulse is enough.
    localparam START_PULSE_WIDTH = 4;

   jb_edge_det #(
        .SYNC_EN            (1),
	    .SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (START_PULSE_WIDTH),
        .PULSE_POLARITY     (1),//pos
	    .RETIME_OUTPUT      (0)
    ) u_dl_test_mode_start_pulse (
        .clk                (clk_1x),
        .mask               (1'b0  ),
        .din                (IFP_test_ctrl.dl_test_mode_trigger),
        .din_syncd          (),
        .dout               (start_pulse)
    );

    always_ff @(posedge clk_1x) begin
        if (!resetn)
		   s_fhbuf_data <= 0;
		else 
		   casex(IFP_test_ctrl.dl_test_ants_sel)
		   2'b00: begin
		            s_fhbuf_data   <= IFP_dl_dfe_in[0][0].tdata;
		            s_fhbuf_tvalid <= IFP_dl_dfe_in[0][0].tvalid;
		            s_fhbuf_tuser  <= IFP_dl_dfe_in[0][0].tuser;
				  end								
		   2'b01: begin
		            s_fhbuf_data   <= IFP_dl_dfe_in[1][0].tdata;
		            s_fhbuf_tvalid <= IFP_dl_dfe_in[1][0].tvalid;
		            s_fhbuf_tuser  <= IFP_dl_dfe_in[1][0].tuser;
				  end													
		   default: begin
                    s_fhbuf_data   <= 0;
                    s_fhbuf_tvalid <= 0;
                    s_fhbuf_tuser  <= 0;
                    end		   
		   endcase
	end	 	 

    always @(posedge clk_1x) begin
      //Remove reset since FPGA reset can take resources
      if (!resetn ) begin
	    iq_ptr        <= 0;
	    addr_lat_cntr <= 0;
	    data_valid    <= 1'b0;
	    data          <= 0;
	    wr_en         <= 1'b0;
	    wr_data       <= 0;
	    inp_addr_sm   <= INP_ADDR_IDLE;	 
      end
      else if (clk_x1en) begin
	 case (inp_addr_sm)
	   INP_ADDR_IDLE :  begin
	      iq_ptr        <= 0;
	      addr_lat_cntr <= 0;
	      data_valid    <= 1'b0;
	      wr_en         <= 1'b0;
	      wr_data       <= 0;
	      if (iq_gen_mode_en & start_pulse) begin
		    inp_addr_sm <= ADDR_PHASE;
	      end //if
	      else if (dl_test_store_en & start_pulse) begin
		    inp_addr_sm <= WAIT_MRKR;
	      end
	   end
	   WAIT_MRKR : begin
	      if (!dl_test_store_en) begin
		    inp_addr_sm   <= INP_ADDR_IDLE;
		    iq_ptr        <= 0;
		    addr_lat_cntr <= 0;
		    data_valid    <= 1'b0;
		    wr_en         <= 1'b0;
		    wr_data       <= 0;
	      end
	      else if (dl_dfe_frm_mrkr) begin
		    inp_addr_sm <= STORE_DATA;
	      end
	   end
	   STORE_DATA : begin
	      if (!dl_test_store_en) begin
		    inp_addr_sm   <= INP_ADDR_IDLE;
		    iq_ptr        <= 0;
		    addr_lat_cntr <= 0;
		    data_valid    <= 1'b0;
		    wr_en         <= 1'b0;
		    wr_data       <= 0;
	      end
	      else if (iq_ptr==num_of_samples) begin
		    inp_addr_sm   <= INP_ADDR_IDLE;
		    iq_ptr        <= 0;
		    addr_lat_cntr <= 0;
		    data_valid    <= 1'b0;
		    wr_en         <= 1'b0;
		    wr_data       <= 0;
	      end		 
//	     else if (IFP_dl_dfe_in.tvalid & (IFP_dl_dfe_in.tuser==store_ant_sel)) begin
	     else if (s_fhbuf_tvalid & (s_fhbuf_tuser==store_ant_sel)) begin
	        wr_en       <= 1'b1;
//		      wr_data <= IFP_dl_dfe_in.tdata;
		    wr_data     <= s_fhbuf_data;
		    inp_addr_sm <= STORE_DATA;
		    iq_ptr      <= iq_ptr+1;
	     end
	   end
	   ADDR_PHASE : begin
	      if (!iq_gen_mode_en) begin
		    inp_addr_sm   <= INP_ADDR_IDLE;
		    iq_ptr        <= 0;
		    addr_lat_cntr <= 0;
		    data_valid    <= 1'b0;
	      end
	      else begin
		     if (addr_lat_cntr == ADDR_LATENCY-1) begin
		        data_valid <= 1'b1;
		        data       <= {imag_value,real_value};
		        if (iq_ptr==num_of_samples) begin
		           iq_ptr        <= 0;
		           addr_lat_cntr <= 0;
		           if (!iq_gen_mode) begin
		    	     inp_addr_sm <= INP_ADDR_IDLE;
		           end
		           else begin
		    	     inp_addr_sm <= ADDR_PHASE;
		           end
		        end
		        else begin
		           iq_ptr <= iq_ptr+1;
		           addr_lat_cntr <= 0;
		           inp_addr_sm <= ADDR_PHASE;		   
		        end
		     end
		     else begin
		        data_valid <= 1'b0;
		        inp_addr_sm <= ADDR_PHASE;
		        addr_lat_cntr <= addr_lat_cntr + 1;
		     end // else: !if(addr_lat_cntr == ADDR_LATENCY)
	      end // else: !if(!iq_gen_mode_en)
	   end // case: ADDR_PHASE
	   default : begin	      
	      inp_addr_sm <= INP_ADDR_IDLE;
	   end
	 endcase // case (inp_addr_sm)	 
      end // else: !if(!resetn | IFP_test_ctrl.dfe_adcdac_test_reset)
    end // always @ (posedge clk_1x)
   

   
   jb_dl_dfe_input_waveform #(
      .PTR_WIDTH(MAX_NUM_SAMPLES_BW),
      .PRECISION(PRECISION)
   ) u_input_waveform (				  
      .clk_en                 (clk_x1en              ),
      .clk                    (clk_1x                ),
      .resetn                 (resetn                ),
	  .IFP_iwavebuf_porta_rst (IFP_iwavebuf_porta_rst),
	  .IFP_iwavebuf_porta_clk (IFP_iwavebuf_porta_clk),
	  .IFP_iwavebuf_porta     (IFP_iwavebuf_porta    ),
      .ptr                    (iq_ptr                ),
      .dina                   (wr_data               ),
      .wea                    ({4{wr_en}}            ),
      .real_value             (real_value            ),
      .imag_value             (imag_value            )
    );

  
  always @(posedge clk_1x) begin
      if (!resetn) begin
	    IFP_dl_dfe_out.tuser  <= 0;
	    IFP_dl_dfe_out.tdata  <= 0;
	    IFP_dl_dfe_out.tvalid <= 0;
	    inp_data_sm <= INP_DATA_IDLE;
      end
      else if (clk_x1en) begin
	    case (inp_data_sm)
	      INP_DATA_IDLE :  begin
	         if (data_valid) begin
	   	       inp_data_sm           <= DRIVE_DATA;
	   	       IFP_dl_dfe_out.tvalid <= 1'b1;
	           IFP_dl_dfe_out.tdata  <= data;
	   	       IFP_dl_dfe_out.tuser  <= 0;		 
	         end //if
	      end
	      DRIVE_DATA : begin
	         if(!data_valid & (IFP_dl_dfe_out.tuser==3)) begin
	   	       IFP_dl_dfe_out.tvalid <= 1'b0;
	   	       IFP_dl_dfe_out.tuser  <=0;
	   	       inp_data_sm           <= INP_DATA_IDLE;
	         end
	         else begin
	   	       IFP_dl_dfe_out.tuser  <=IFP_dl_dfe_out.tuser+1;	 //should wrap around 0-3
	   	       IFP_dl_dfe_out.tvalid <= 1'b1;
	           IFP_dl_dfe_out.tdata  <= data;
	   	       inp_data_sm           <= DRIVE_DATA;     
	         end
	      end // case: DRIVE_DATA
	    endcase // case (inp_addr_sm)
      end // else: !if(!resetn)
  end 
   

   
   // ila_dl_oran_schr u_ila_dl_oran_schlr (
	// .clk    (clk_1x                            ), // input wire clkdl_oran_schlr_sm
	// .probe0 (clk_x1en                          ), // input wire [0:0]  probe0  
	// .probe1 ({17'd0,iq_ptr,s_fhbuf_data}       ), // input wire [63:0]  probe1 
	// .probe2 (s_fhbuf_tvalid                    ), // input wire [0:0]  probe2 
	// .probe3 (s_fhbuf_tuser                     ), // input wire [31:0]  probe3 
	// .probe4 (wr_en                             ), // input wire [0:0]  probe4 
	// .probe5 ({32'd0,wr_data}                   ), // input wire [63:0]  probe5 
	// .probe6 (0                                 ), // input wire [10:0]  probe6 
	// .probe7 ({1'b0,inp_addr_sm}                ), // input wire [2:0]  probe7 
	// .probe8 (IFP_test_ctrl.dl_test_band_sel     ), // input wire [1:0]  probe8 
	// .probe9 (0                                 ), // input wire [7:0]  probe9 
	// .probe10({start_pulse,dl_test_store_en,dl_dfe_frm_mrkr}), // input wire [2:0]  probe1
	// .probe11(0                                 ), // input wire [2:0]  probe10
	// .probe12(0                                 ), // input wire [2:0]  probe10
	// .probe13(0                                 ), // input wire [2:0]  probe10
	// .probe14(0                                 )  // input wire [2:0]  probe10
// );


endmodule // jb_dl_dfe_input_stage_gen_iq

