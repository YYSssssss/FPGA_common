import jb_ul_oran_pkg::*;

module jb_ul_oran_alarm #(
  parameter NA  = 4,  /*  Number of antennae...               */
  parameter NC  = 2,  /*  Number of carriers...               */
  parameter WA  = 2,  /*  Width of antenna fields...          */
  parameter WC  = 1,  /*  Width of carrier fields...          */
  parameter CB  = 4
  )(
  input  wire               clk,
  input  wire               rst,
  input  wire               clear,
  
  input  wire   [NA-1:0]          ul_oran_tvalid,             /*  A request is made, but TREADY is deasserted...  */
  input  wire   [NA-1:0]          ul_oran_tready,
  output logic  [NA-1:0][CB-1:0]  vld_wo_rdy_err_cnt_o,
  
  input  wire   [NA-1:0]          request_fifo_overflow,      /*  A request arrives but the FIFO is full...   */
  output logic  [NA-1:0][CB-1:0]  fifo_ovfl_err_cnt_o,
  
  input  wire   [NC-1:0]          ul_fft_wr_pointer_x,        /*  A request is still in the FIFO when the ANTENNA/COLOR changes outside...   */
  input  wire   [NC-1:0][WA-1:0]  ul_fft_rd_antenna,
  input  wire   [NC-1:0][3:0]     ul_fft_rd_symbol,
  input  wire   [NA-1:0]          request_fifo_empty,
  input fifo_words_t  [NA-1:0]    request_fifo_out,
  output logic  [NA-1:0][CB-1:0]  stale_reqs_err_cnt_o,
  
  input send_states_t [NC-1:0]    send_state,                 /* A response sequence contains PRBS from two different symbols...  */
  output logic  [NA-1:0][CB-1:0]  stale_prbs_err_cnt_o
  );
  
  /*  Rising-edge detect and fanout for CLEAR inputs... */
  localparam
    FANOUT_DEPTH  = 4;
 
  logic                                clear_0;
  logic                                clear_1;
  logic                                clear_rise;
  logic   [NA-1:0][FANOUT_DEPTH-1:0]   clear_fan;
    
  always@(posedge clk) begin
    /* Detect rising-edge on these control signals... */
    clear_0     <= clear;
    clear_1     <= clear_0;
    clear_rise  <= (clear_0 && ~clear_1); 
      
    /* Duplicate and allow FANOUT_DEPTH stages for timing closure...  */
    for (int k=0; k<NA; k++) begin
      clear_fan[k]  <= {clear_fan[k][FANOUT_DEPTH-2:0], clear_rise};
    end
  end
  
  /*
    A request is made, but TREADY is deasserted...  
  */
  localparam
    VLD_WO_RDY_THRESH = integer($floor(424/16)),             /* 424 idle cycles (out of 1024 @122M88), 16 requests expected per antenna-carrier... */
    VLD_WO_RDY_WIDTH  = integer($clog2(VLD_WO_RDY_THRESH)),
    VLD_WO_RDY_MAX    = integer(2**VLD_WO_RDY_WIDTH);
    
  logic   [NA-1:0]                        ul_oran_tready_i;
  logic   [NA-1:0]                        ul_oran_tvalid_i;
  logic   [NA-1:0][VLD_WO_RDY_WIDTH-1:0]  vld_wo_rdy_count;
  logic   [NA-1:0]                        vld_wo_rdy_hold;
  logic   [NA-1:0]                        vld_wo_rdy_err;
  logic   [NA-1:0]                        vld_wo_rdy_err_0;
  logic   [NA-1:0]                        vld_wo_rdy_err_r;
  logic   [NA-1:0][CB-1:0]                vld_wo_rdy_err_cnt;
  
  always@(posedge clk) begin
    for (int k=0; k<NA; k++) begin
      /*  Register inputs for timing ease... */
      ul_oran_tready_i[k] <= ul_oran_tready[k];
      ul_oran_tvalid_i[k] <= ul_oran_tvalid[k];
      
      if (~ul_oran_tvalid_i[k])
        vld_wo_rdy_count[k] <= 1'd0;
      else if (ul_oran_tvalid_i[k] && ~ul_oran_tready_i[k] && ~vld_wo_rdy_hold[k])
        vld_wo_rdy_count[k] <= vld_wo_rdy_count[k] + 1'd1;
    
      vld_wo_rdy_hold[k] <= 1'd0;
      if (vld_wo_rdy_count[k] >= VLD_WO_RDY_MAX-2)
        vld_wo_rdy_hold[k] <= 1'd1;
        
      vld_wo_rdy_err[k] <= 1'd0;
      if (vld_wo_rdy_count[k] > VLD_WO_RDY_THRESH-1)
        vld_wo_rdy_err[k] <= 1'd1;
    
      vld_wo_rdy_err_r[k] <= 1'd0;
      vld_wo_rdy_err_0[k] <= vld_wo_rdy_err[k];
      if (vld_wo_rdy_err[k] && ~vld_wo_rdy_err_0[k])
        vld_wo_rdy_err_r[k] <= 1'd1;
      
      /*  Register outputs for timing ease... */
      vld_wo_rdy_err_cnt_o[k] <= vld_wo_rdy_err_cnt[k];
    end
  end
  
  genvar k;
  generate
    for (k=0; k<NA; k++)
      jb_ul_oran_alarm_counter #(
        .COUNTER_WIDTH (CB)
        )
        jb_ul_oran_alarm_counter_inst1(
          .clk          (clk),
          .rst          (rst),
          .alarm        (vld_wo_rdy_err_r[k]),
          .alarm_count  (vld_wo_rdy_err_cnt[k]),
          .clear        (clear_fan[k][FANOUT_DEPTH-1])
          );
  endgenerate

  /*  
    A request arrives but the FIFO is full...   
  */
  logic   [NA-1:0]          request_fifo_overflow_i;
  logic   [NA-1:0][CB-1:0]  fifo_ovfl_err_cnt;
  
  always@(posedge clk) begin
    for (int k=0; k<NA; k++) begin
      /*  Register inputs for timing ease... */
      request_fifo_overflow_i[k]   <=  request_fifo_overflow[k];
    
      /*  Register outputs for timing ease... */
      fifo_ovfl_err_cnt_o[k] <= fifo_ovfl_err_cnt[k];
    end
  end

  generate
    for (k=0; k<NA; k++)
      jb_ul_oran_alarm_counter #(
        .COUNTER_WIDTH (CB)
        )
        jb_ul_oran_alarm_counter_inst2(
          .clk          (clk),
          .rst          (rst),
          .alarm        (request_fifo_overflow_i[k]),
          .alarm_count  (fifo_ovfl_err_cnt[k]),
          .clear        (clear_fan[k][FANOUT_DEPTH-1])
          );
  endgenerate

  /*  
    A request is still in the FIFO when the ANTENNA changes outside...   
  */
  logic         [NA-1:0]            request_fifo_empty_i;
  fifo_words_t  [NA-1:0]            request_fifo_out_i;
  logic         [NC-1:0]            ul_fft_wr_pointer_x_i;
  logic         [NC-1:0][WA-1:0]    ul_fft_rd_antenna_i;
  logic         [NC-1:0][3:0]       ul_fft_rd_symbol_i;
  logic         [NC-1:0]            fifo_not_empty;
  logic         [NC-1:0]            fifo_symbol_match;
  logic         [NC-1:0]            ul_fft_wr_pointer_x_i_0;
  logic         [NC-1:0][WA-1:0]    ul_fft_rd_antenna_i_0;
  logic         [NC-1:0]            stale_reqs_err;
  logic         [NA-1:0]            stale_reqs_err_ant;
  logic         [NA-1:0][CB-1:0]    stale_reqs_err_cnt;

  always@(posedge clk) begin
    for (int k=0; k<NA; k++) begin
      /*  Register inputs for timing ease... */
      request_fifo_empty_i[k]   <= request_fifo_empty[k];
      request_fifo_out_i[k]     <= request_fifo_out[k];
    end
    for (int j=0; j<NC; j++) begin
      /*  Register inputs for timing ease... */
      ul_fft_wr_pointer_x_i[j]  <= ul_fft_wr_pointer_x[j];
      ul_fft_rd_antenna_i[j]    <= ul_fft_rd_antenna[j];
      ul_fft_rd_symbol_i[j]     <= ul_fft_rd_symbol[j];
      
      /* Register the components of the alarm condition to ease timing closure... */
      fifo_not_empty[j] <= 1'd0;
      if( ~request_fifo_empty_i[ul_fft_rd_antenna_i[j]])
        fifo_not_empty[j] <= 1'd1;
      
      fifo_symbol_match[j] <= 1'd0;
      if (request_fifo_out_i[ul_fft_rd_antenna_i[j]].symbol == ul_fft_rd_symbol_i[j])
        fifo_symbol_match[j] <= 1'd1;
        
      ul_fft_wr_pointer_x_i_0[j]  <= ul_fft_wr_pointer_x_i[j];
      
      stale_reqs_err[j] <= 1'd0;
      if (ul_fft_wr_pointer_x_i_0[j] && fifo_not_empty[j] && fifo_symbol_match[j])
        stale_reqs_err[j] <= 1'd1;
      
      /* Align antenna number with the error flag, to update the appropriate counter...  */
      ul_fft_rd_antenna_i_0[j]  <= ul_fft_rd_antenna_i[j];
    end
    for (int k=0; k<NA; k++) begin
      stale_reqs_err_ant[k] <= 1'd0;
      for (int j=0; j<NC; j++) begin
        /* We expect only one error flag raised per antenna...  */
        if (stale_reqs_err[j] && ul_fft_rd_antenna_i_0[j] == k)
          stale_reqs_err_ant[k] <= 1'd1;
      end
      
      /*  Register outputs for timing ease... */
      stale_reqs_err_cnt_o[k] <= stale_reqs_err_cnt[k];
    end
  end

  generate
    for (k=0; k<NA; k++)
      jb_ul_oran_alarm_counter #(
        .COUNTER_WIDTH (CB)
        )
        jb_ul_oran_alarm_counter_inst3(
          .clk          (clk),
          .rst          (rst),
          .alarm        (stale_reqs_err_ant[k]),
          .alarm_count  (stale_reqs_err_cnt[k]),
          .clear        (clear_fan[k][FANOUT_DEPTH-1])
          );
  endgenerate

  /*
    An output response sequence contains PRBS from two different symbols...
  */
  send_states_t   [NC-1:0]            send_state_i;
  logic           [NC-1:0]            stale_prbs_err;
  logic           [NA-1:0]            stale_prbs_err_ant;
  logic           [NA-1:0][CB-1:0]    stale_prbs_err_cnt;

  always@(posedge clk) begin
    for (int j=0; j<NC; j++) begin
      /*  Register inputs for timing ease... */
      send_state_i[j] <= send_state[j];
      
      stale_prbs_err[j] <= 1'd0;
      if (ul_fft_wr_pointer_x_i[j] && send_state_i[j] != IDLE)
        stale_prbs_err[j] <= 1'd1;
    end
    for (int k=0; k<NA; k++) begin
      stale_prbs_err_ant[k] <= 1'd0;
      for (int j=0; j<NC; j++) begin
        /* We expect only one error flag raised per antenna...  */
        if (stale_prbs_err[j] && ul_fft_rd_antenna_i_0[j] == k)
          stale_prbs_err_ant[k] <= 1'd1;
      end

      /*  Register outputs for timing ease... */
      stale_prbs_err_cnt_o[k] <= stale_prbs_err_cnt[k];
    end
  end

  generate
    for (k=0; k<NA; k++)
      jb_ul_oran_alarm_counter #(
        .COUNTER_WIDTH (CB)
        )
        jb_ul_oran_alarm_counter_inst4(
          .clk          (clk),
          .rst          (rst),
          .alarm        (stale_prbs_err_ant[k]),
          .alarm_count  (stale_prbs_err_cnt[k]),
          .clear        (clear_fan[k][FANOUT_DEPTH-1])
          );
  endgenerate
  
endmodule
