/*
  Expect one C-Plane Type3 message per sub-frame, per antenna-carrier.
  Each message is for a single PRACH symbol. PRACH symbols have a fixed size (1024 samples, all bandwidths).
  SECTION_ID, CC, and SS fields must be sent back with all responses.
*/
module jb_prach_oran_data #(
  parameter NA  = 4,  /* Number of antennae...              */
  parameter NC  = 2,  /* NUmber of carriers...              */
  parameter CB  = 4   /* Number of debug counter bits...    */
  )(
  input wire 	      clkin,
  input wire 	      rstin,
  
  input wire 	      clkout,
  input wire 	      rstout,
  
  input  wire                     prach_swap_fft,
  input  wire                     prach_endianness,
  jb_prach_cplane_if.lphy         IFP_prach_cplane,
  
  input  wire                     prach_oran_tready,
  output logic                    prach_oran_tvalid,
  output logic          [31:0]    prach_oran_tuser,
  output logic          [63:0]    prach_oran_tdata,
  output logic          [7:0]     prach_oran_tkeep,
  output logic                    prach_oran_tlast,
  
  output logic  [NC-1:0]          prach_fft_tready,
  input  wire   [NC-1:0]          prach_fft_tvalid,
  input  wire   [NC-1:0][15:0]    prach_fft_tuser,
  input  wire   [NC-1:0][31:0]    prach_fft_tdata,
  input  wire   [NC-1:0]          prach_fft_tlast,
  input  wire   [NC-1:0]          prach_fft_clken,
  
  input  wire                     clear,
  output logic          [CB-1:0]  vld_wo_rdy_err_cnt,
  output logic          [CB-1:0]  cplane_fifo_ovfl_err_cnt,
  output logic  [NA-1:0][CB-1:0]  prach_fifo_ovfl_err_cnt
  );
  
  import jb_prach_oran_pkg::*;
  
  localparam
    REQUEST_SIZE      = 864,
    PRACH_FFT_SIZE    = 1024,
    NUM_OUT_PER_CYCLE = 2;
    
  localparam
    WC  = $clog2(NC),                   /* Width of the carrier index fields...     */
    WA  = $clog2(NA),                   /* Width of the antenna index fields...     */
    WF  = $clog2(PRACH_FFT_SIZE),       /* Width of the FFT index fields...         */
    WS  = 4;                            /* Width of the Sub-Frame index fields...   */
    
  cplane_fifo_words_t                   cplane_fifo_in;
  cplane_fifo_words_t                   cplane_fifo_out;
  
  logic                                 cplane_fifo_wr;
  logic                       [27:0]    cplane_fifo_wr_data;
  logic                                 cplane_fifo_rd;
  logic                       [27:0]    cplane_fifo_rd_data;
  logic                                 cplane_fifo_empty;
  logic                                 cplane_fifo_overflow;
  
  prach_fifo_words_t  [NA-1:0]          prach_fifo_in;
  prach_fifo_words_t  [NA-1:0]          prach_fifo_out;
  
  logic               [NA-1:0]          prach_fifo_wr;
  logic               [NA-1:0][27:0]    prach_fifo_wr_data;
  logic               [NA-1:0]          prach_fifo_rd;
  logic               [NA-1:0][27:0]    prach_fifo_rd_data;
  logic               [NA-1:0]          prach_fifo_empty;
  logic               [NA-1:0]          prach_fifo_overflow;  
  
  queue_states_t                        queue_state;
  logic                       [7:0]     spatial_stream;
  logic                       [3:0]     comp_carrier;
  logic                       [3:0]     sub_frame;
  logic                       [11:0]    section_id;
  logic                       [WA-1:0]  fifo_num_wr;
  
  logic               [NC-1:0]          prach_swap_fft_0;
  logic               [NC-1:0]          prach_endianness_0;
  
  logic               [NC-1:0]          prach_fft_tready_0;
  logic               [NC-1:0]          prach_fft_tvalid_0;
  logic               [NC-1:0][15:0]    prach_fft_tuser_0;
  logic               [NC-1:0][31:0]    prach_fft_tdata_0;
  logic               [NC-1:0]          prach_fft_tlast_0;
  logic               [NC-1:0][WA-1:0]  prach_fft_tuser_antenna;
  logic               [NC-1:0][WS-1:0]  prach_fft_tuser_subframe;
  logic               [NC-1:0]          prach_fft_tvld_trdy_tlast_0;
  logic               [NC-1:0][0:0]     prach_fft_wr_pointer;
  logic               [NC-1:0][WA-1:0]  prach_fft_wr_antenna;
  logic               [NC-1:0][WS-1:0]  prach_fft_wr_subframe;
  
  logic               [NC-1:0]          prach_buffer_wr;
  logic               [NC-1:0][31:0]    prach_buffer_wr_data;
  logic               [NC-1:0][WF:0]    prach_buffer_wr_addr;  /* Double the FFT-SIZE for ping-pong buffering...  */
  
  logic                       [WA-1:0]  stream;
  logic                       [WA-1:0]  stream_0;
  logic                       [WA-1:0]  stream_1;
  send_states_t                         send_state;
  logic                       [WA-1:0]  fifo_num_rd;
  logic                       [9:0]     sample_address;
  logic                                 prach_fifo_empty_0;
  logic                                 prach_fifo_empty_1;
  prach_fifo_words_t                    prach_fifo_out_0;
  logic                                 fifo_ss_match;
  logic                                 fifo_sf_match;
  logic                       [3:0]     fifo_out_cc;
  logic                       [7:0]     fifo_out_ss;
  logic                       [11:0]    fifo_out_section_id;
  
  logic               [NC-1:0]          prach_buffer_rd;
  logic               [NC-1:0][63:0]    prach_buffer_rd_data;
  logic               [NC-1:0][WF-1:0]  prach_buffer_rd_addr;
  
  logic               [NC-1:0]          prach_fft_wr_pointer_0;
  logic               [NC-1:0]          prach_fft_wr_pointer_1;
  logic               [NC-1:0]          prach_fft_wr_pointer_2;
  logic               [NC-1:0]          prach_fft_wr_pointer_x;
  logic               [NC-1:0][0:0]     prach_fft_rd_pointer;
  logic               [NC-1:0][WA-1:0]  prach_fft_rd_antenna;
  logic               [NC-1:0][WS-1:0]  prach_fft_rd_subframe;
  
  logic                                 sending;
  logic                                 sending_0;   
  logic                                 prach_oran_tvalid_tready;
  
  
  /* No need to throttle this interface so far...   */
  assign IFP_prach_cplane.tready  = 1'd1;
  
  /* Parse incoming C-Plane mesages into a FIFO...  */
  assign cplane_fifo_in.ss            = IFP_prach_cplane.ss[7:0];          /* Stream Identifier (antenna)...   */
  assign cplane_fifo_in.cc            = IFP_prach_cplane.cc[3:0];          /* Component Carrier...             */
  assign cplane_fifo_in.sf            = IFP_prach_cplane.sf[3:0];          /* Sub-Frame number...              */
  assign cplane_fifo_in.section_id    = IFP_prach_cplane.section_id[11:0];
  
  always@(posedge clkout) begin
    cplane_fifo_wr  <= 1'd0;
    if (IFP_prach_cplane.tvalid && IFP_prach_cplane.tready) begin
      cplane_fifo_wr      <= 1'd1;
      cplane_fifo_wr_data <= cplane_fifo_in;
    end
  end;
  
  jb_prach_oran_cplane_fifo
  jb_prach_oran_cplane_fifo_inst(
    .clk        (clkout),
    .rst        (rstout),
    .write      (cplane_fifo_wr),
    .write_data (cplane_fifo_wr_data),
    .read       (cplane_fifo_rd),
    .read_data  (cplane_fifo_rd_data),
    .full       (),
    .empty      (cplane_fifo_empty),
    .overflow   (cplane_fifo_overflow)
    );
  
  assign cplane_fifo_out  = cplane_fifo_rd_data;
  
  /* Interpret C-Plane messages and put requests into the appropriate FIFO... */
  always@(posedge clkout) begin

    spatial_stream  <= cplane_fifo_out.ss;
    comp_carrier    <= cplane_fifo_out.cc;
    sub_frame       <= cplane_fifo_out.sf;
    section_id      <= cplane_fifo_out.section_id;

    case (queue_state)
      RED: begin
          if (~cplane_fifo_empty) begin
            queue_state <= BLUE;
          end
        end
      BLUE: begin
          queue_state <= GREEN;
          fifo_num_wr <= spatial_stream[WA-1:0];
        end
      GREEN: begin
          queue_state <= GOLD;
          /* Select one of the antennae FIFO to queue the request... */
          prach_fifo_wr[fifo_num_wr]       <= 1'd1;
          prach_fifo_wr_data[fifo_num_wr]  <= {spatial_stream, comp_carrier, sub_frame, section_id};
        end
      GOLD: begin
          prach_fifo_wr[fifo_num_wr]  <= 1'd0;
          queue_state                 <= RED;
        end
      default: begin
          queue_state <= RED;
        end
    endcase
    
    /* Remove the message from the queue after it is processed... */
    cplane_fifo_rd  <= 1'd0;
    if (queue_state == GREEN)
      cplane_fifo_rd  <= 1'd1;
    
    if (rstout) begin
      queue_state     <= RED;
    end
  end
  
  genvar k;
  generate
    for (k=0; k<NA; k++) begin
      jb_prach_oran_request_fifo
      jb_prach_oran_request_fifo_inst(
        .clk        (clkout),
        .rst        (rstout),
        .write      (prach_fifo_wr[k]),
        .write_data (prach_fifo_wr_data[k]),
        .read       (prach_fifo_rd[k]),
        .read_data  (prach_fifo_rd_data[k]),
        .full       (),
        .empty      (prach_fifo_empty[k]),
        .overflow   (prach_fifo_overflow[k])
        );
  
      assign prach_fifo_in[k]  = prach_fifo_wr_data[k];
      assign prach_fifo_out[k] = prach_fifo_rd_data[k];
    end
  endgenerate

  /* Buffer incoming PRACH symbols... */
  genvar j;
  generate    
    for (j=0; j<NC; j++) begin      
      always@(posedge clkin) begin
        if (prach_fft_clken[j]) begin
           /* Register inputs... */
          prach_swap_fft_0[j]   <= prach_swap_fft;
          prach_endianness_0[j] <= prach_endianness;
          
          prach_fft_tready_0[j] <= prach_fft_tready[j];
          prach_fft_tvalid_0[j] <= prach_fft_tvalid[j];
          prach_fft_tuser_0[j]  <= prach_fft_tuser[j];
          prach_fft_tdata_0[j]  <= prach_fft_tdata[j];
          prach_fft_tlast_0[j]  <= prach_fft_tlast[j];
          
          /* Swap upper/lower FFT sections... */
          if (prach_swap_fft_0[j])
            prach_buffer_wr_addr[j] <= {prach_fft_wr_pointer[j], {~prach_fft_tuser_0[j][WA+WF-1], prach_fft_tuser_0[j][WA+WF-2:WA]} - 10'd80};
          else
            prach_buffer_wr_addr[j] <= {prach_fft_wr_pointer[j], prach_fft_tuser_0[j][WA+WF-1:WA]};
          
          prach_buffer_wr[j] <= 1'd0;
          if (prach_fft_tvalid_0[j] && prach_fft_tready_0[j]) begin
            prach_buffer_wr[j]       <= 1'd1;
            case (prach_endianness_0[j])
              0:  prach_buffer_wr_data[j]  <= {prach_fft_tdata_0[j][23:16], prach_fft_tdata_0[j][31:24], prach_fft_tdata_0[j][7:0],   prach_fft_tdata_0[j][15:8]};    /* Big Endian        */
              1:  prach_buffer_wr_data[j]  <= {prach_fft_tdata_0[j][15:8],  prach_fft_tdata_0[j][7:0],   prach_fft_tdata_0[j][31:24], prach_fft_tdata_0[j][23:16]};   /* Little Endian     */
            endcase
          end
          
          /* Delay TLAST to align with PRACH_BUFFER_* signals....       */
          prach_fft_tvld_trdy_tlast_0[j] <= 1'd0;
          if (prach_fft_tvalid_0[j] && prach_fft_tready_0[j] && prach_fft_tlast_0[j])
            prach_fft_tvld_trdy_tlast_0[j] <= 1'd1;
          
          /* Update the ping-pong section pointer... let it wrap...     */
          if (prach_fft_tvld_trdy_tlast_0[j])
            prach_fft_wr_pointer[j] <= prach_fft_wr_pointer[j] + 1'd1;

          /* Record the antenna number for the packet...                */
          prach_fft_tuser_antenna[j] <= prach_fft_tuser_0[j][WA-1:0];
          if (prach_fft_tvld_trdy_tlast_0[j])
            prach_fft_wr_antenna[j] <= prach_fft_tuser_antenna[j];

          /* Record the sub-frame number form the incoming packet...    */
          prach_fft_tuser_subframe[j] <= prach_fft_tuser_0[j][WA+WF+WS-1:WA+WF];
          if (prach_fft_tvld_trdy_tlast_0[j])
            prach_fft_wr_subframe[j]  <= prach_fft_tuser_subframe[j];
        end
        if (rstin) begin
          prach_fft_wr_subframe[j]        <= {WS{1'd1}};  /* Park at an out-of-range value...  */
          prach_fft_wr_antenna[j]         <= {WA{1'd0}};
          prach_fft_wr_pointer[j]         <=     1'd0;
          prach_fft_tvld_trdy_tlast_0[j]  <=     1'd0;
        end
      end
      
      // No need to throttle FFT inputs so far...
      assign prach_fft_tready[j] = 1'd1;
      
      // FFT Packet Buffer...
      prach_oran_bram_32x2048_64x1024
      prach_oran_buffer_inst(
        .clka         (clkin),
        .ena          (prach_fft_clken[j]),
        .wea          (prach_buffer_wr[j]),
        .addra        (prach_buffer_wr_addr[j]),
        .dina         (prach_buffer_wr_data[j]),
        .clkb         (clkout),
        .enb          (prach_buffer_rd[j]),
        .addrb        (prach_buffer_rd_addr[j]),
        .doutb        (prach_buffer_rd_data[j])
      );
      
      assign prach_buffer_rd[j]      = prach_oran_tvalid_tready;
      assign prach_buffer_rd_addr[j] = {prach_fft_rd_pointer[j], sample_address};
      
      /* Maintain read-side pointers and tags...        */
      always@(posedge clkout) begin
        prach_fft_wr_pointer_0[j]  <= prach_fft_wr_pointer[j][0];
        prach_fft_wr_pointer_1[j]  <= prach_fft_wr_pointer_0[j];
        prach_fft_wr_pointer_2[j]  <= prach_fft_wr_pointer_1[j];
        prach_fft_wr_pointer_x[j]  <= prach_fft_wr_pointer_2[j] ^ prach_fft_wr_pointer_1[j];

        if (prach_fft_wr_pointer_x[j]) begin
          prach_fft_rd_antenna[j]  <= prach_fft_wr_antenna[j];
          prach_fft_rd_pointer[j]  <= ~prach_fft_wr_pointer[j];
          prach_fft_rd_subframe[j] <= prach_fft_wr_subframe[j];
        end
        if (rstout) begin
          prach_fft_rd_pointer[j]  <=     1'd0;
          prach_fft_rd_antenna[j]  <= {WA{1'd0}};
          prach_fft_rd_subframe[j] <= {WS{1'd1}};
        end
      end
    end
  endgenerate

  /* Send data from buffer when matching sub-frame time arrives...   */
  always@(posedge clkout) begin
    if (stream == NA-1)
      stream  <= 0;
    else
      stream  <= stream + 1'd1;
      
    /* Select one set of FIFO outputs at a time...  */
    stream_0 <= stream;
    prach_fifo_empty_0 <= prach_fifo_empty[stream];
    prach_fifo_out_0 <= prach_fifo_out[stream];
    
    /* Check for matching sub-frame, and antenna number...   */
    stream_1 <= stream_0;
    prach_fifo_empty_1 <= prach_fifo_empty_0;
    
    fifo_sf_match <= 1'd0;
    if (prach_fft_rd_subframe[prach_fifo_out_0.cc] == prach_fifo_out_0.sf)
      fifo_sf_match <= 1'd1;
      
    fifo_ss_match <= 1'd0;
    if (prach_fft_rd_antenna[prach_fifo_out_0.cc] == stream_0)
      fifo_ss_match <= 1'd1;
      
    /* Once matching time and data arrive, send the packet...   */
    case (send_state)
      IDLE: begin
          if (~prach_fifo_empty_1 && fifo_sf_match && fifo_ss_match) begin
            send_state    <= STAGE;
            fifo_num_rd   <= stream_1;
          end
        end
      STAGE: begin
          send_state      <= SEND;
          sample_address  <= 10'd0;
        end
      SEND: begin
          if (prach_oran_tvalid_tready)
            if (sample_address == REQUEST_SIZE/NUM_OUT_PER_CYCLE-1)
              send_state  <= WAIT1;
            else
              sample_address  <= sample_address + 1'd1;
        end
      WAIT1: begin
          if (prach_oran_tvalid_tready)
            send_state  <= WAIT2;
        end
      WAIT2: begin
          if (prach_oran_tvalid_tready)
            send_state  <= WAIT3;
        end
      WAIT3: begin
          if (prach_oran_tvalid_tready)
            send_state  <= IDLE;
        end
      default: begin
          send_state <= IDLE;
        end
    endcase
    
    /* Remove the request from the FIFO after it is processed...  */
    prach_fifo_rd <= 0;
    if (send_state == STAGE)
      prach_fifo_rd[fifo_num_rd] <= 1'd1;
      
    /* Select the request parameters for output...  */
    if (send_state == STAGE) begin
      fifo_out_cc         <= prach_fifo_out[fifo_num_rd].cc;
      fifo_out_section_id <= prach_fifo_out[fifo_num_rd].section_id;
      fifo_out_ss         <= prach_fifo_out[fifo_num_rd].ss;
    end
      
    if (rstout) begin
      stream          <= {WA{1'd0}};
      send_state      <= IDLE;
      prach_fifo_rd   <= 0;
    end
  end
  
  assign prach_oran_tvalid_tready = (~prach_oran_tvalid || (prach_oran_tvalid && prach_oran_tready));
  
  /* Drive outputs... */
  always@(posedge clkout) begin
    if (prach_oran_tvalid_tready) begin
      sending <= 1'd0;
      if (send_state == SEND)
        sending <= 1'd1;
        
      sending_0 <= sending; /*  This is when data appears on PRACH_BUFFER_RD_DATA outputs...  */
    end
    
    if (prach_oran_tvalid_tready && sending_0)
      prach_oran_tdata  <= prach_buffer_rd_data[fifo_out_cc];

    if (prach_oran_tvalid_tready && sending_0)
      prach_oran_tuser  <= {8'd0, fifo_out_cc, fifo_out_ss, fifo_out_section_id};

    if (prach_oran_tvalid_tready && sending_0)
      prach_oran_tvalid <= 1'd1;
    else if (prach_oran_tvalid_tready && send_state == WAIT3)
      prach_oran_tvalid <= 1'd0;      
      
    if (prach_oran_tvalid_tready && send_state == WAIT2)
      prach_oran_tlast  <= 1'd1;
    else if (prach_oran_tvalid_tready && send_state == WAIT3)
      prach_oran_tlast  <= 1'd0;
    
    if (rstout) begin
      sending           <=  1'd0;
      sending_0         <=  1'd0;
      prach_oran_tdata  <= 64'd0;
      prach_oran_tuser  <= 31'd0;
      prach_oran_tvalid <=  1'd0;
      prach_oran_tlast  <=  1'd0;
    end
  end
  
  assign prach_oran_tkeep = 8'd255;  /* All bytes are always valid...    */
  
  /* Debug counters...  */
  jb_prach_oran_alarm #(
    .NA  (NA),  /*  Number of antennae...               */
    .NC  (NC),  /*  Number of carriers...               */
    .WA  (WA),  /*  Width of antenna fields...          */
    .WC  (WC),  /*  Width of carrier fields...          */
    .CB  (4)
    )
    jb_prach_oran_alarm_inst (
      .clk    (clkout),
      .rst    (rstout),
      .clear  (clear),
      
      .prach_oran_tvalid            (prach_oran_tvalid),
      .prach_oran_tready            (prach_oran_tready),
      .vld_wo_rdy_err_cnt_o         (vld_wo_rdy_err_cnt),
      
      .prach_fifo_overflow          (prach_fifo_overflow),
      .prach_fifo_ovfl_err_cnt_o    (prach_fifo_ovfl_err_cnt),

      .cplane_fifo_overflow         (cplane_fifo_overflow),
      .cplane_fifo_ovfl_err_cnt_o   (cplane_fifo_ovfl_err_cnt)
      );
      
endmodule
