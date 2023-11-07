
 
module jb_ul_oran_data #(
  parameter NA  = 4,  /*  Number of antennae...               */
  parameter NC  = 1,  /*  Number of carriers...               */
  parameter CB  = 4   /*  Number of debug counter bits...     */
  )(
  input  wire               clkin,
  input  wire               rstin,
  input  wire               clkout,
  input  wire               rstout,
  
  input  wire           [NC-1:0]          ul_car_en,
  input  wire           [NC-1:0][3:0]     ul_car_bw,
  input  wire                             ul_swap_fft,
  input  wire                             ul_endianness,
  input  wire                             ul_fifo_reset,
  
  input  wire           [NC-1:0][3:0]     ul_oran_symbol,
  input  wire   [NA-1:0]        [24:0]    ul_oran_request,
  input  wire   [NA-1:0]                  ul_oran_tready,
  output logic  [NA-1:0]        [63:0]    ul_oran_tdata,
  output logic  [NA-1:0]        [7:0]     ul_oran_tkeep,
  output logic  [NA-1:0]                  ul_oran_tvalid,
  output logic  [NA-1:0]                  ul_oran_tlast,

  output wire           [NC-1:0]          ul_fft_tready,
  input  wire           [NC-1:0][31:0]    ul_fft_tdata,
  input  wire           [NC-1:0][15:0]    ul_fft_tuser,
  input  wire           [NC-1:0]          ul_fft_tvalid,
  input  wire           [NC-1:0]          ul_fft_tlast,
  input  wire           [NC-1:0]          ul_fft_clken,
  
  input  wire                             clear,
  output logic  [NA-1:0]        [CB-1:0]  vld_wo_rdy_err_cnt,
  output logic  [NA-1:0]        [CB-1:0]  fifo_ovfl_err_cnt,
  output logic  [NA-1:0]        [CB-1:0]  stale_reqs_err_cnt,
  output logic  [NA-1:0]        [CB-1:0]  stale_prbs_err_cnt
  );
  
  import jb_ul_oran_pkg::*;
    
  localparam
    WC  = $clog2(NC),     /*  Width of the carrier index fields...  */
    WA  = $clog2(NA),     /*  Width of the antenna index fields...  */
	n_half_tones = 12'd1638 ;
    
  localparam
    NUM_OUT_PER_CYCLE   = 3'd2,       /*  Output side of the FFT buffer yields two samples at a time.... */
    NUM_SAMPLES_PER_RB  = 4'd12,      /*  12-REs per PRB  */
	NUM_OUT_PER_CYCLE_RB   = 3'd6;
    
  requests_t      [NA-1:0]          requests;
  fifo_words_t    [NA-1:0]          request_fifo_in;
  fifo_words_t    [NA-1:0]          request_fifo_out;
  
  logic           [NC-1:0]          ul_car_good_0;
  logic           [NC-1:0]          ul_car_good_1;
  logic           [NC-1:0]          ul_car_good_2;
  logic           [NC-1:0]          ul_car_good_rise;

  logic                             ul_fifo_reset_0;
  logic                             ul_fifo_reset_1;
  logic                             ul_fifo_reset_2;
  logic                             ul_fifo_reset_rise;
  
  logic           [NA-1:0]          request_fifo_wr;
  logic           [NA-1:0][23:0]    request_fifo_wr_data;
  logic           [NA-1:0]          fifo_reset;
  
  logic           [NA-1:0]          request_fifo_rd;
  logic           [NA-1:0][23:0]    request_fifo_rd_data;
  logic           [NA-1:0]          request_fifo_empty;
  logic           [NA-1:0]          request_fifo_overflow;
  
  send_states_t   [NC-1:0]          send_state;  
  logic           [NA-1:0]          ul_oran_port_busy;
  logic           [NC-1:0]          fsm_reset;

  logic           [NC-1:0]          ul_car_en_0;
  logic           [NC-1:0]          ul_car_en_1;
  logic           [NC-1:0]          ul_car_en_2;
  logic           [NC-1:0]          ul_car_en_rise;
  logic           [NC-1:0][3:0]     ul_car_bw_0;
  logic           [NC-1:0]          ul_swap_fft_0;
  logic           [NC-1:0]          ul_endianness_0;
  logic           [NC-1:0]          ul_car_ok;
  logic           [NC-1:0]          ul_car_good;
  logic           [NC-1:0][7:0]     ul_car_count;

  logic           [NC-1:0]          ul_fft_tready_0;
  logic           [NC-1:0][31:0]    ul_fft_tdata_0;
  logic           [NC-1:0][15:0]    ul_fft_tuser_0;
  logic           [NC-1:0]          ul_fft_tvalid_0;
  logic           [NC-1:0]          ul_fft_tlast_0;
  logic           [NC-1:0]          ul_fft_tvld_trdy_tlast_0;
  logic           [NC-1:0][WA-1:0]  ul_fft_tuser_antenna;
  logic           [NC-1:0][3:0]     ul_fft_symbol = 0;
  
  logic           [NC-1:0]          data_buffer_wr;
  logic           [NC-1:0][31:0]    data_buffer_wr_data;
  logic           [NC-1:0][12:0]    data_buffer_wr_addr;  /*  This width supports up to 100MHz case... */

  logic           [NC-1:0][WA-1:0]  counter;
  logic           [NC-1:0][WA-1:0]  counter_0;
  logic           [NC-1:0][WA-1:0]  counter_1;
  logic           [NC-1:0][WA-1:0]  antenna;
  logic           [NC-1:0]          fifo_not_empty;
  logic           [NC-1:0]          fifo_symbol_match;
  logic           [NC-1:0]          fifo_cc_match;
  logic           [NC-1:0]          requests_pending;
  logic           [NC-1:0][11:0]    request_start;
  logic           [NC-1:0][10:0]    request_number;
  logic           [NC-1:0][10:0]    req_sample_address;
  logic           [NC-1:0][10:0]    request_last;
  logic           [NC-1:0][10:0]    request_last_m1;

  logic           [NC-1:0]          data_buffer_rd;
  logic           [NC-1:0][63:0]    data_buffer_rd_data;
  logic           [NC-1:0][11:0]    data_buffer_rd_addr;

  logic           [NC-1:0][WA-1:0]  ul_fft_antenna;
  logic           [NC-1:0][0:0]     ul_fft_wr_pointer;
  logic           [NC-1:0]          ul_fft_wr_pointer_0;
  logic           [NC-1:0]          ul_fft_wr_pointer_1;
  logic           [NC-1:0]          ul_fft_wr_pointer_2;
  logic           [NC-1:0]          ul_fft_wr_pointer_x;
  logic           [NC-1:0][0:0]     ul_fft_rd_pointer;
  logic           [NC-1:0][WA-1:0]  ul_fft_rd_antenna;
  logic           [NC-1:0][3:0]     ul_fft_rd_symbol;

  logic           [NC-1:0]          sending;
  logic           [NC-1:0]          sending_0;   
  logic           [NA-1:0]          ul_oran_tnext;
  logic           [NC-1:0]          send_zeros;
  
 
  /*
    FIFO reset...
    Always accept requests, send zeros until after FFT has started sending data...
    This reset might cause an outgoing packet to be truncated, this is observed to be handled ok by the receiveing ORAN IP (simulation).
  */
  always@(posedge clkout) begin
    //CDC and rising-edge detect for carrier enable signal from FFT clock domain...
    for (int j=0; j<NC; j++) begin
      ul_car_good_0[j]    <= ul_car_en[j] ;
      ul_car_good_1[j]    <= ul_car_good_0[j];    
      ul_car_good_2[j]    <= ul_car_good_1[j];
      ul_car_good_rise[j] <= ul_car_good_1[j] && ~ul_car_good_2[j];
    end
end

   always@(posedge clkout) begin
    // CDC for fifo_reset from PS clock domain...
    ul_fifo_reset_0     <= ul_fifo_reset;
    ul_fifo_reset_1     <= ul_fifo_reset_0;
    ul_fifo_reset_2     <= ul_fifo_reset_1;
    ul_fifo_reset_rise  <= ul_fifo_reset_1 && ~ul_fifo_reset_2;
end

    always@(posedge clkout) begin 
    // Fanout for reset to FIFOs...
	 for (int k=0; k<NA; k++)
        if(rstout)
		    fifo_reset[k]  <= 1'h1;
		else	
	        fifo_reset[k]  <= ul_fifo_reset_rise || |ul_car_good_rise;
	//        fifo_reset[k]  <= ul_fifo_reset_rise ;
end    
    // Fanout for reset to FSMs...
    always@(posedge clkout) begin   
	 for (int j=0; j<NC; j++)
      if (rstout) 
	    fsm_reset[j]   <= 1'h1;
	  else
	    fsm_reset[j]  <= ul_fifo_reset_rise || |ul_car_good_rise;
end
  
  /*
    Requests Queue process.
    Accept 'requests' as single cycle wide command that must be responded to...
    Put requests in a FIFO incase multiple requests arrive ahead of available data to send.
    We expect up to four interfaces for requests.
  */
  genvar k;
  generate
    for (k=0; k<NA; k++) begin
      // Rename the request bus segments for convenience...
      assign requests[k].valid    = ul_oran_request[k][24];
      assign requests[k].start_rb = ul_oran_request[k][23:15];
      assign requests[k].num_rb   = ul_oran_request[k][14:7];
      assign requests[k].cc_num   = ul_oran_request[k][6:4];
      assign requests[k].rsvd     = ul_oran_request[k][3:0];

      assign request_fifo_in[k].start_rb  = requests[k].start_rb;
      assign request_fifo_in[k].num_rb    = requests[k].num_rb;
      assign request_fifo_in[k].cc_num    = requests[k].cc_num;
      assign request_fifo_in[k].symbol    = ul_oran_symbol[requests[k].cc_num][3:0];
      
        always@(posedge clkout) begin
          if (requests[k].valid) begin
            /* We do not try to block overflow here, instead we let it happen and report the alarm below... */
            request_fifo_wr[k]       <= 1'd1;
            request_fifo_wr_data[k]  <= request_fifo_in[k];
        end
		  else begin
		    request_fifo_wr[k] <= 1'd0;
		    request_fifo_wr_data[k]  <= 0 ;
		end
      end
 
      jb_ul_oran_request_fifo
      jb_ul_oran_request_fifo_inst(
        .clk          (clkout),
        .rst          (fifo_reset[k]),
        .write        (request_fifo_wr[k]),
        .write_data   (request_fifo_wr_data[k]),
        .read         (request_fifo_rd[k]),
        .read_data    (request_fifo_rd_data[k]),
        .full         (),                                   /* No attempt to handle overflow... it must be reported and resolved!    */
        .almost_full  (),                                   /* No attempt to handle overflow... it must be reported and resolved!    */
        .empty        (request_fifo_empty[k]),
        .almost_empty (),                                   /* Current FSM provides idle cycles between reads, so empty flag is enough. */
        .overflow     (request_fifo_overflow[k]),
        .underflow    ()                                    /* Underflow not posible with the current FSM design. */
        );

      // Rename the request bus segments for convenience...
      assign request_fifo_out[k]  = request_fifo_rd_data[k];
    end
  endgenerate
  
  
  /*
    FFT Data Queue Process.
    Store FFT packets in buffer and await requests to send them on...
  */
  genvar j;
  generate    
    for (j=0; j<NC; j++) begin      
        always@(posedge clkin) begin
             /* Register inputs, and CDC... */
             ul_car_en_0[j]      <= ul_car_en[j];
             ul_car_en_1[j]      <= ul_car_en_0[j];
             ul_car_en_2[j]      <= ul_car_en_1[j];
             ul_car_en_rise[j]   <= ul_car_en_1[j] && ~ul_car_en_2[j];
          end
		  
        always@(posedge clkin) begin
             ul_car_bw_0[j]      <= ul_car_bw[j];
             ul_swap_fft_0[j]    <= ul_swap_fft;
             ul_endianness_0[j]  <= ul_endianness;
          end
        
		always@(posedge clkin) begin
          if (~ul_car_en_2[j]) begin
            ul_car_ok[j]      <= 1'd0;
            ul_car_good[j]    <= 1'd0;
            ul_car_count[j]   <= 8'd0;
          end else if (ul_fft_tuser_0[j][14]) begin     /* Wait until FFT is reaonable active...  */
            ul_car_count[j] <= ul_car_count[j] + 1'd1;
            if (ul_car_count[j] >= 155)
              ul_car_ok[j]  <= ul_car_en_2[j];
            if (ul_car_ok[j] && ul_fft_tuser_0[j][15])  /* Wait until symbol counters are in sync again before trying to send data... */
              ul_car_good[j]  <= ul_car_en_2[j];
          end
        end

	   always@(posedge clkin) begin    
          ul_fft_tready_0[j]  <= ul_fft_tready[j];
          ul_fft_tdata_0[j]   <= ul_fft_tdata[j];
          ul_fft_tuser_0[j]   <= ul_fft_tuser[j];
          ul_fft_tvalid_0[j]  <= ul_fft_tvalid[j];
          ul_fft_tlast_0[j]   <= ul_fft_tlast[j];
  end
  
        always@(posedge clkin) begin 
          /* Swap upper/lower FFT sections... */
          if (ul_swap_fft_0[j]) 
				data_buffer_wr_addr[j]  <= {ul_fft_wr_pointer[j], {~ul_fft_tuser_0[j][WA+11], ul_fft_tuser_0[j][WA+10:WA]} - 12'd410}; /* 100MHz... */ 
		 else
		    begin
			   if(ul_fft_tuser_0[j][WA+11:WA]>=12'd2458)
                data_buffer_wr_addr[j]  <= {ul_fft_wr_pointer[j],{ul_fft_tuser_0[j][WA+11:WA] - 12'd820}};
			   else
			    data_buffer_wr_addr[j]  <= {ul_fft_wr_pointer[j],ul_fft_tuser_0[j][WA+11:WA]};
			end
  end      
		
	    always@(posedge clkin) begin 	
          if (ul_fft_tvalid_0[j] && ul_fft_tready_0[j]) 
            data_buffer_wr[j] <= 1'd1;
          else
		    data_buffer_wr[j] <= 1'd0;  
  end		
		

		always@(posedge clkin) begin 	
			case (ul_endianness_0[j])
              0:  data_buffer_wr_data[j]  <= {ul_fft_tdata_0[j][23:16], ul_fft_tdata_0[j][31:24], ul_fft_tdata_0[j][7:0],   ul_fft_tdata_0[j][15:8]};     /* Big endian     */
			 // 0:  data_buffer_wr_data[j]  <= {ul_fft_tdata_0[j][31:24], ul_fft_tdata_0[j][23:16], ul_fft_tdata_0[j][15:8],   ul_fft_tdata_0[j][7:0]};
              1:  data_buffer_wr_data[j]  <= {ul_fft_tdata_0[j][15:8],  ul_fft_tdata_0[j][7:0],   ul_fft_tdata_0[j][31:24], ul_fft_tdata_0[j][23:16]};     /* Little endian  */
            endcase
          end
        
		always@(posedge clkin) begin 
          /* Record the antenna number for the packet...  */
          ul_fft_tuser_antenna[j] <= ul_fft_tuser_0[j][WA-1:0];
  end
       
		always@(posedge clkin) begin   
		  if(rstin)
		    ul_fft_antenna[j] <= {WA{1'd0}};
		  else if (ul_fft_tvld_trdy_tlast_0[j])
            ul_fft_antenna[j] <= ul_fft_tuser_antenna[j];
  end           
          /* Delay TLAST to align with DATA_BUFFER_* signals....  */
        always@(posedge clkin) begin
          if (rstin)
		    ul_fft_tvld_trdy_tlast_0[j] <= 1'd0;
		  else if (ul_fft_tvalid_0[j] && ul_fft_tready_0[j] && ul_fft_tlast_0[j])
            ul_fft_tvld_trdy_tlast_0[j] <= 1'd1;
		  else
		    ul_fft_tvld_trdy_tlast_0[j] <= 1'd0;
  end
        
        always@(posedge clkin) begin		
          /* Update the section pointer... let it wrap. TODO: Number of sections needs to be a power of 2 for now...  */
          if(rstin)
		    ul_fft_wr_pointer[j] <= 1'd0;
		  else if (ul_fft_tvld_trdy_tlast_0[j])
            ul_fft_wr_pointer[j] <= ul_fft_wr_pointer[j] + 1'd1;
  end          
          /* 
            Use the symbol/frame markers to label the FFT packets in the buffer....  
            Here we keep track of the four LSBs of the frame-based symbol counter that the ORAN side maintains.
          */
        always@(posedge clkin) begin 
		  if (ul_fft_tuser_0[j][15])  // Frame-Marker: expect one every one-hundred-forty symbols.
            ul_fft_symbol[j]  <= 4'd0;
          else if (ul_fft_tuser_0[j][14])   // Symbol-Marker: expect one every NA antennae
            ul_fft_symbol[j]  <= ul_fft_symbol[j] + 1'd1;
  end
        
      
      // No need to throttle FFT inputs so far...
      assign ul_fft_tready[j] = 1'd1;
      
      // FFT Packet Buffer...
      ul_oran_bram_32x8192_64x4096
      ul_oran_buffer_inst(
        .clka         (clkin),
        .ena          (ul_fft_clken[j]),
        .wea          (data_buffer_wr[j]),
        .addra        (data_buffer_wr_addr[j]),
        .dina         (data_buffer_wr_data[j]),
        .clkb         (clkout),
        .enb          (data_buffer_rd[j]),
        .addrb        (data_buffer_rd_addr[j]),
        .doutb        (data_buffer_rd_data[j])
      );
      
      assign data_buffer_rd[j]      = ul_oran_tnext[antenna[j]];
      assign data_buffer_rd_addr[j] = {ul_fft_rd_pointer[j], req_sample_address[j]};
      
      always@(posedge clkout) begin
        // Maintain read-side section pointer and packet counters (on diferent clock maybe ??) TODO: Number of sections needs to be a power of 2 for now...
        ul_fft_wr_pointer_0[j]  <= ul_fft_wr_pointer[j][0];
        ul_fft_wr_pointer_1[j]  <= ul_fft_wr_pointer_0[j];
        ul_fft_wr_pointer_2[j]  <= ul_fft_wr_pointer_1[j];
        ul_fft_wr_pointer_x[j]  <= ul_fft_wr_pointer_2[j] ^ ul_fft_wr_pointer_1[j];
    end    
    
      always@(posedge clkout) begin
        if (rstout) begin
          ul_fft_rd_pointer[j]  <=     1'd0;
          ul_fft_rd_antenna[j]  <= {WA{1'd0}};
          ul_fft_rd_symbol[j]   <=     4'd0;
        end
		
		else if (ul_fft_wr_pointer_x[j]) begin
          ul_fft_rd_antenna[j]  <= ul_fft_antenna[j];
          ul_fft_rd_pointer[j]  <= ~ul_fft_wr_pointer[j];
          ul_fft_rd_symbol[j]   <= ul_fft_symbol[j];
        end
	 end	
   end
  endgenerate
    
  // Check if there are any requests along with data availbale to send... and send it.
  always@(posedge clkout) begin
    for (int j=0; j<NC; j++) begin
      /* Check all antennae round-robin for requests...  */
      if (counter[j] == NA-1)
        counter[j] <= 0;
      else
        counter[j] <= counter[j] + 1'd1;
      
      /* Register the various components of the state transition condition to ease timing closure... */
      fifo_not_empty[j] <= 1'd0;
      if (~request_fifo_empty[counter[j]])
        fifo_not_empty[j] <= 1'd1;
      
      fifo_symbol_match[j] <= 1'd0;
      if (request_fifo_out[counter[j]].symbol == ul_fft_rd_symbol[j])
        fifo_symbol_match[j] <= 1'd1;
      
      fifo_cc_match[j] <= 1'd0;
      if (request_fifo_out[counter[j]].cc_num == j)
        fifo_cc_match[j] <= 1'd1;
              
      requests_pending[j] <= 1'd0;
      if (fifo_not_empty[j] && fifo_cc_match[j] && (~ul_car_good_2[j] || fifo_symbol_match[j]))
        requests_pending[j] <= 1'd1;
      
      /* Align counter with the requests_pending flag... */
      counter_0[j]  <= counter[j];
      counter_1[j]  <= counter_0[j];
    
      case (send_state[j])
        IDLE: begin
            /* Find a new request in any FIFO (including the same) and transition the the WAIT1/2 states to wait until the port is free...
               This is OK since each buffer/carrier serves only one port/antenna at a time, there is no risk of underseving the other ports.
            */
            if (requests_pending[j] && (~ul_car_good_2[j] || ul_fft_rd_antenna[j] == counter_1[j])) begin
              antenna[j]          <= counter_1[j];
              send_state[j]       <= WAIT1;
              send_zeros[j]       <= ~ul_car_good_2[j];
              /* Convert the request's RB parameters into address parameters...   */
              request_start[j]    <= request_fifo_out[counter_1[j]].start_rb * NUM_OUT_PER_CYCLE_RB;
              request_number[j]   <= request_fifo_out[counter_1[j]].num_rb * NUM_OUT_PER_CYCLE_RB;
            end
          end
        WAIT1: begin
            send_state[j]               <= WAIT2;
            request_last[j]             <= request_start[j][10:0] + request_number[j][10:0];
          end
        WAIT2: begin
            /* Wait here until the antenna port is free....  */
            req_sample_address[j] <= request_start[j][10:0];
            if (~ul_oran_port_busy[antenna[j]]) begin
              send_state[j]       <= SEND;
              request_last_m1[j]  <= request_last[j] - 1;
              /* Remove the request from the FIFO               */
              request_fifo_rd[antenna[j]]  <= 1'd1;
              /* Tag the requested antenna output port          */
              ul_oran_port_busy[antenna[j]]  <= 1'd1;
            end
          end
        SEND: begin
            request_fifo_rd[antenna[j]] <= 1'd0;
            if ((req_sample_address[j] == request_last_m1[j]) && ul_oran_tnext[antenna[j]]) begin
              send_state[j]         <= WAIT3;
            end else if (ul_oran_tnext[antenna[j]])
              req_sample_address[j] <= req_sample_address[j] + 1;
          end
        WAIT3: 
          if (ul_oran_tnext[antenna[j]])
            send_state[j] <= WAIT4;
        WAIT4:
          if (ul_oran_tnext[antenna[j]])
            send_state[j] <= WAIT5;
        WAIT5: begin
            if (ul_oran_tnext[antenna[j]]) begin
              send_state[j]                 <= IDLE;
              ul_oran_port_busy[antenna[j]] <= 1'd0;
            end
          end
        default: begin
            send_state[j]       <= IDLE;
          end
      endcase
    end
    for (int j=0; j<NC; j++) begin
      if (fsm_reset[j]) begin
        counter[j]        <= 2'd0;
        counter_0[j]      <= 2'd0;
        counter_1[j]      <= 2'd0;
        antenna[j]        <= 2'd0;
        send_zeros[j]     <= 1'd0;
        send_state[j]     <= IDLE;
      end
    end
    for (int k=0; k<NA; k++) begin
      if (fifo_reset[k]) begin
        request_fifo_rd[k]    <= 1'd0;
        ul_oran_port_busy[k]  <= 1'd0;
      end
    end
  end

  generate
    for (k=0; k<NA; k++)
      assign ul_oran_tnext[k] = (ul_oran_tready[k] && ul_oran_tvalid[k]) || ~ul_oran_tvalid[k];
  endgenerate

  /*  Drive output stream...  */
  always@(posedge clkout) begin
    for (int j=0; j<NC; j++) begin
      if (ul_oran_tnext[antenna[j]]) begin
        sending[j]   <= 1'd0;
        if (send_state[j] == SEND)
          sending[j] <= 1'd1;
        
        sending_0[j] <= sending[j]; /*  This is when data appears on DATA_BUFFER_RD_DATA outputs...  */
      end
    end
    for (int k=0; k<NA; k++) begin
      for (int j=0; j<NC; j++) begin
        if ((antenna[j] == k) && ul_oran_tnext[k] && sending_0[j])
          if (send_zeros[j])
            ul_oran_tdata[k]  <= 64'd0;
          else
            ul_oran_tdata[k]  <= data_buffer_rd_data[j];

        if ((antenna[j] == k) && ul_oran_tnext[k] && sending_0[j])
          ul_oran_tvalid[k]  <= 1'd1;
        else if ((antenna[j] == k) && ul_oran_tnext[k] && send_state[j] == WAIT5)
          ul_oran_tvalid[k]  <= 1'd0;
          
        if ((antenna[j] == k) && ul_oran_tnext[k] && send_state[j] == WAIT4)
          ul_oran_tlast[k] <= 1'd1;
        else if ((antenna[j] == k) && ul_oran_tnext[k] && send_state[j] == WAIT5)
          ul_oran_tlast[k] <= 1'd0;
      end      
    end
    for (int j=0; j<NC; j++) begin
      if (fsm_reset[j]) begin
        sending[j]         <=  1'd0;
        sending_0[j]       <=  1'd0;
      end
    end
    for (int k=0; k<NA; k++) begin
      if (fifo_reset[k]) begin
        ul_oran_tdata[k]   <= 64'd0;
        ul_oran_tvalid[k]  <=  1'd0;
        ul_oran_tlast[k]   <=  1'd0;
      end
    end
  end

  generate
    for (k=0; k<NA; k++)
      assign ul_oran_tkeep[k] = 8'd255;  /*  All bytes are always valid since requests have RB granularity...  */
  endgenerate
  
  /*  Debug counters....        */
  jb_ul_oran_alarm #(
    .NA   (NA),   // Number of antennae...
    .NC   (NC),   // Number of carriers...
    .WA   (WA),   // Number of bits for antenna indices...
    .WC   (WC),   // Number of bits for carrier indices...
    .CB   (CB)    // Number of bits for debug counters...
    )
    jb_ul_oran_alarm_inst (
      .clk    (clkout),
      .rst    (rstout),
      .clear  (clear),
      
      .ul_oran_tvalid         (ul_oran_tvalid),
      .ul_oran_tready         (ul_oran_tready),
      .vld_wo_rdy_err_cnt_o   (vld_wo_rdy_err_cnt),
      
      .request_fifo_overflow  (request_fifo_overflow),
      .fifo_ovfl_err_cnt_o    (fifo_ovfl_err_cnt),
      
      .ul_fft_wr_pointer_x    (ul_fft_wr_pointer_x),
      .ul_fft_rd_antenna      (ul_fft_rd_antenna),
      .ul_fft_rd_symbol       (ul_fft_rd_symbol),
      .request_fifo_empty     (request_fifo_empty),
      .request_fifo_out       (request_fifo_out),
      .stale_reqs_err_cnt_o   (stale_reqs_err_cnt),
      
      .send_state             (send_state),
      .stale_prbs_err_cnt_o   (stale_prbs_err_cnt)
      );
 
/*   ul_oran_ila_rd
  ul_oran_ila_rd_inst (
    .clk      (clkout),
    .probe0   (ul_oran_tready),
    .probe1   (ul_oran_tvalid),
    .probe2   (ul_oran_tlast),
    .probe3   (ul_oran_request[3]),
    .probe4   (ul_oran_request[2]),
    .probe5   (ul_oran_request[1]),
    .probe6   (ul_oran_request[0]),
    .probe7   (ul_oran_symbol[0][3:0]),
    .probe8   (ul_oran_port_busy),
    .probe9   (ul_fft_rd_antenna),
    .probe10  (ul_fft_rd_symbol),
    .probe11  (send_state[0]),
	.probe12  (counter[0]),
	.probe13         (antenna[0]             ),
	.probe14        (fifo_not_empty[0]      ),
	.probe15         (fifo_symbol_match[0]   ),
	.probe16         (fifo_cc_match[0]       ),
	.probe17         (requests_pending[0]    ),
	.probe18         (request_start[0]       ),
	.probe19         (request_number[0]      ),
	.probe20         (req_sample_address[0]  ),
	.probe21        (request_last[0]        ),
	.probe22         (request_last_m1[0]     ),
	.probe23         (sending       ),
	.probe24         (sending_0     ),
	.probe25         (ul_oran_tnext ),
	.probe26         (send_zeros    ),
	.probe27         (ul_oran_tdata[0]   ),
	.probe28         (ul_oran_tdata[1]   ),
	.probe29         (ul_oran_tdata[2]   ),
	.probe30         (ul_oran_tdata[3]   ),
	
	.probe31         (request_fifo_rd      ),
	.probe32         (request_fifo_empty   ),
	.probe33         (request_fifo_overflow),
	.probe34         (request_fifo_rd_data[0]),
	.probe35         (request_fifo_rd_data[1]),                 
	.probe36        (request_fifo_rd_data[2]),
	.probe37         (request_fifo_rd_data[3])
	
    );
	
	
ul_oran_ila_wr
  ul_oran_ila_wr_inst (
    .clk      (clkin),
    .probe0   (ul_fft_tready_0[0]),
    .probe1   (ul_fft_tdata_0[0]),
    .probe2   (ul_fft_tuser_0[0]),
    .probe3   (ul_fft_tvalid_0[0]),
    .probe4   (ul_fft_tlast_0[0]),
    .probe5   (ul_fft_tvld_trdy_tlast_0[0]),
    .probe6   (ul_fft_tuser_antenna[0]),
    .probe7   (ul_fft_symbol[0]),
    .probe8   (data_buffer_wr[0]),
    .probe9   (data_buffer_wr_data[0]),
    .probe10  (data_buffer_wr_addr[0])
  
	); */
	
 
endmodule
