
module jb_oran_monitor_counter #(
  parameter COUNTER_WIDTH  = 8
  )(
  input  wire                         clk,
  input  wire                         rst,
  input  wire                         alarm,
  output logic  [COUNTER_WIDTH-1:0]   alarm_count,
  input  wire                         clear
  );
  
  localparam 
    COUNTER_MAXIMUM  = 2**COUNTER_WIDTH;
 
  logic             alarm_hold;
  
  always@(posedge clk) begin
    if (alarm && ~alarm_hold)
      if (clear)
        alarm_count <= 1'd1;
      else
        alarm_count <= alarm_count + 1'd1;
    else if (clear)
      alarm_count <= 1'd0;
  
    alarm_hold <= 1'd0;
    if (alarm_count >= COUNTER_MAXIMUM-1)
      alarm_hold <= 1'd1;
      
    if (rst) begin
      alarm_count <= 1'd0;
    end
  end
endmodule



module jb_oran_monitor(
  input  wire   	        clkin,
  input  wire   	        rstin,
  input  wire             clear,
  input  wire             transport_header_offset_valid,
  input  wire             runt_packet_len,
  input  wire             packet_in_window,
  input  wire   [2:0]     messagetype,
  input  wire             radio_app_header_valid,
  input  wire             datadirection,
  input  wire   [2:0]     sectiontype,
  input  wire             section_header_valid,
  
  input  wire             s000_fram_data_tvalid,
  input  wire             s000_fram_data_tlast,
  input  wire             s000_fram_data_tready,
  input  wire             s000_fram_data_req_24,
  
  input  wire             s001_fram_data_tvalid,
  input  wire             s001_fram_data_tlast,
  input  wire             s001_fram_data_tready,
  input  wire             s001_fram_data_req_24,

  input  wire             s002_fram_data_tvalid,
  input  wire             s002_fram_data_tlast,
  input  wire             s002_fram_data_tready,
  input  wire             s002_fram_data_req_24,

  input  wire             s003_fram_data_tvalid,
  input  wire             s003_fram_data_tlast,
  input  wire             s003_fram_data_tready,
  input  wire             s003_fram_data_req_24,

  input  wire             m0_prach_tvalid,
  input  wire             m0_prach_tready,
  input  wire             s00_fram_prach_tvalid,
  input  wire             s00_fram_prach_tlast,
  input  wire             s00_fram_prach_tready,
  
  output logic  [4:0]     counter_names,
  output logic  [31:0]    counter_values
  );
  
  localparam
    CB = 32;
    
  typedef enum logic[3:0]{
    TRANSPORT,
    RADIO_APP,
    SECTION
    } state_t;
    
  typedef enum logic[4:0]{
    runt_type0_cnt,
    runt_type2_cnt,
    win_t2_t1_dl_cnt,
    win_t2_t1_ul_cnt,
    win_t2_t3_ul_cnt,
    win_t0_t1_dl_cnt,
    other_type0_cnt,
    other_type2_cnt,
    other_type1_ul_cnt,
    other_type1_dl_cnt,
    other_type3_cnt,
    type1_data_dl_cnt,
    type1_ctrl_ul_cnt,
    type1_ctrl_dl_cnt,
    type3_ctrl_ul_cnt,
    type1_reqs_ul0_cnt,
    type1_data_ul0_cnt,
    type1_reqs_ul1_cnt,
    type1_data_ul1_cnt,
    type1_reqs_ul2_cnt,
    type1_data_ul2_cnt,
    type1_reqs_ul3_cnt,
    type1_data_ul3_cnt,
    type3_reqs_ul_cnt,
    type3_data_ul_cnt
    } counter_names_t;
    
  logic                 transport_header_offset_valid_0;
  logic                 runt_packet_len_0;
  logic                 packet_in_window_0;
  logic      [2:0]      messagetype_0;
  logic                 radio_app_header_valid_0;
  logic                 datadirection_0;
  logic      [2:0]      sectiontype_0;
  logic                 section_header_valid_0;

  logic                 packet_in_window_1;
  logic      [2:0]      messagetype_1;
  logic                 datadirection_1;
  logic      [2:0]      sectiontype_1;

  state_t               state;
  logic      [2:0]      watchdog;
  
  logic                 runt_type0_err;
  logic                 runt_type2_err;
  logic                 win_type2_type1_dl_err;
  logic                 win_type2_type1_ul_err;
  logic                 win_type2_type3_ul_err;
  logic                 win_type0_dl_err;
  logic                 other_type0_err;
  logic                 other_type2_err;
  logic                 other_type1_ul_err;
  logic                 other_type1_dl_err;
  logic                 other_type3_err;

  logic [10:0]          alarms;
  logic [10:0][CB-1:0]  alarm_counts;
  
  logic                 s000_fram_data_tvalid_0;
  logic                 s000_fram_data_tlast_0;
  logic                 s000_fram_data_tready_0;
  logic                 s000_fram_data_req_24_0;
  
  logic                 s001_fram_data_tvalid_0;
  logic                 s001_fram_data_tlast_0;
  logic                 s001_fram_data_tready_0;
  logic                 s001_fram_data_req_24_0;

  logic                 s002_fram_data_tvalid_0;
  logic                 s002_fram_data_tlast_0;
  logic                 s002_fram_data_tready_0;
  logic                 s002_fram_data_req_24_0;

  logic                 s003_fram_data_tvalid_0;
  logic                 s003_fram_data_tlast_0;
  logic                 s003_fram_data_tready_0;
  logic                 s003_fram_data_req_24_0;

  logic                 m0_prach_tvalid_0;
  logic                 m0_prach_tready_0;
  logic                 s00_fram_prach_tvalid_0;
  logic                 s00_fram_prach_tlast_0;
  logic                 s00_fram_prach_tready_0;
  
  logic                 packet_type0_data_dl_ok;
  logic                 packet_type1_ctrl_ul_ok;
  logic                 packet_type1_ctrl_dl_ok;
  logic                 packet_type3_ctrl_ul_ok;
  logic                 packet_type1_reqs_ul0_ok;
  logic                 packet_type1_data_ul0_ok;
  logic                 packet_type1_reqs_ul1_ok;
  logic                 packet_type1_data_ul1_ok;
  logic                 packet_type1_reqs_ul2_ok;
  logic                 packet_type1_data_ul2_ok;
  logic                 packet_type1_reqs_ul3_ok;
  logic                 packet_type1_data_ul3_ok;
  logic                 packet_type3_reqs_ul_ok;
  logic                 packet_type3_data_ul_ok;

  logic [13:0]          oks;
  logic [13:0][CB-1:0]  ok_counts;

  logic  [4:0]          counter_idx;
  logic  [4:0]          counter_idx_0;
  logic       [CB-1:0]  counter_mux;

  /*  Rising-edge detect and fanout for CLEAR inputs... */
  localparam
    FANOUT_DEPTH  = 4;
 
  logic                        clear_0;
  logic                        clear_1;
  logic                        clear_2;
  logic                        clear_rise;
  logic   [FANOUT_DEPTH-1:0]   clear_fan;
    
  always@(posedge clkin) begin
    /* CDC and detect rising-edge on this control signal, allow FANOUT_DEPTH stages for timing closure...  */
    clear_0     <= clear;
    clear_1     <= clear_0;
    clear_2     <= clear_1;
    clear_rise  <= (clear_1 && ~clear_2);
    clear_fan   <= {clear_fan[FANOUT_DEPTH-2:0], clear_rise};

    /* Register inputs... */
    transport_header_offset_valid_0   <= transport_header_offset_valid;
    runt_packet_len_0                 <= runt_packet_len;
    packet_in_window_0                <= packet_in_window;
    messagetype_0                     <= messagetype;
    radio_app_header_valid_0          <= radio_app_header_valid;
    datadirection_0                   <= datadirection;
    sectiontype_0                     <= sectiontype;
    section_header_valid_0            <= section_header_valid;
  
    if (transport_header_offset_valid_0) begin
      packet_in_window_1  <= packet_in_window_0;
      messagetype_1       <= messagetype_0;
    end
    
    if (radio_app_header_valid_0) begin
      datadirection_1 <= datadirection_0;
      sectiontype_1   <= sectiontype_0;
    end

    /*
      Transport -> radio -> section.
      Any error stops the progression... a new sequence starts later.
    */
    case (state)
      TRANSPORT: begin
          watchdog  <= 7;
          if (transport_header_offset_valid_0 && ~runt_packet_len_0)
            state   <= RADIO_APP;
        end
      RADIO_APP: begin
          watchdog  <= watchdog - 1;
          if (radio_app_header_valid_0 && messagetype_1 == 0)
            state   <= TRANSPORT;
          else if (radio_app_header_valid_0 && messagetype_1 == 2) begin
            watchdog  <= 7;
            state     <= SECTION;
          end else if (watchdog == 0)
            state   <= TRANSPORT;
        end
      SECTION: begin
          watchdog  <= watchdog - 1;
          if (section_header_valid_0 || watchdog == 0)
            state   <= TRANSPORT;
        end
    endcase
  
    /* When either RUNT_PACKET_LEN error occur, the remaining headers are not forwarded... */
    runt_type0_err <= 0;
    if (transport_header_offset_valid_0 && runt_packet_len_0 && messagetype_0 == 0)
      runt_type0_err <= 1;
      
    runt_type2_err <= 0;
    if (transport_header_offset_valid_0 && runt_packet_len_0 && messagetype_0 == 2)
      runt_type2_err <= 1;

    /* Monitor for packet_in_window errors... */
    win_type2_type1_dl_err <= 0;
    if (radio_app_header_valid_0 && ~packet_in_window_1 && messagetype_1 == 2 && sectiontype_0 == 1 && datadirection_0 == 1)
      win_type2_type1_dl_err <= 1;

    win_type2_type1_ul_err <= 0;
    if (radio_app_header_valid_0 && ~packet_in_window_1 && messagetype_1 == 2 && sectiontype_0 == 1 && datadirection_0 == 0)
      win_type2_type1_ul_err <= 1;
    
    win_type2_type3_ul_err <= 0;
    if (radio_app_header_valid_0 && ~packet_in_window_1 && messagetype_1 == 2 && sectiontype_0 == 3 && datadirection_0 == 0)
      win_type2_type3_ul_err <= 1;
      
    win_type0_dl_err <= 0;
    if (radio_app_header_valid_0 && ~packet_in_window_1 && messagetype_1 == 0 && datadirection_0 == 1)
      win_type0_dl_err <= 1;
      
    /* Monitor for any RADIO_APP timeouts...  */
    other_type0_err <= 0;
    if (state == RADIO_APP && watchdog == 0 && messagetype_1 == 0)
      other_type0_err <= 1;

    other_type2_err <= 0;
    if (state == RADIO_APP && watchdog == 0 && messagetype_1 == 2)
      other_type2_err <= 1;
    
    /* Monitor for any SECTION timeouts...  */
    other_type1_ul_err <= 0;
    if (state == SECTION && watchdog == 0 && sectiontype_1 == 1 && datadirection_1 == 0)
      other_type1_ul_err <= 1;
      
    other_type1_dl_err <= 0;
    if (state == SECTION && watchdog == 0 && sectiontype_1 == 1 && datadirection_1 == 1)
      other_type1_dl_err <= 1;

    other_type3_err <= 0;
    if (state == SECTION && watchdog == 0 && sectiontype_1 == 3)
      other_type3_err <= 1;

    if (rstin) begin
      clear_fan              <= 0;
      state                  <= TRANSPORT;
      watchdog               <= 7;
      runt_type0_err         <= 0;
      runt_type2_err         <= 0;
      win_type2_type1_dl_err <= 0;
      win_type2_type1_ul_err <= 0;
      win_type2_type3_ul_err <= 0;
      win_type0_dl_err       <= 0;
      other_type0_err        <= 0;
      other_type2_err        <= 0;
      other_type1_ul_err     <= 0;
      other_type1_dl_err     <= 0;
      other_type3_err        <= 0;
    end
  end

  assign alarms[0]  = runt_type0_err;
  assign alarms[1]  = runt_type2_err;
  assign alarms[2]  = win_type2_type1_dl_err;
  assign alarms[3]  = win_type2_type1_ul_err;
  assign alarms[4]  = win_type2_type3_ul_err;
  assign alarms[5]  = win_type0_dl_err;
  assign alarms[6]  = other_type0_err;
  assign alarms[7]  = other_type2_err;
  assign alarms[8]  = other_type1_ul_err;
  assign alarms[9]  = other_type1_dl_err;
  assign alarms[10] = other_type3_err;

  genvar k;
  generate
    for (k=0; k<11; k++) begin
      jb_oran_monitor_counter #(
        .COUNTER_WIDTH (CB)
        )
        jb_oran_monitor_counter_inst1(
          .clk          (clkin),
          .rst          (rstin),
          .alarm        (alarms[k]),
          .alarm_count  (alarm_counts[k]),
          .clear        (clear_fan[3])
          );
    end
  endgenerate
  
  /* Everything is fine.... :) */
  always@(posedge clkin) begin
    packet_type0_data_dl_ok <= 0;
    if (radio_app_header_valid_0 && packet_in_window_1 && messagetype_1 == 0 && datadirection_0 == 1)
      packet_type0_data_dl_ok <= 1;

    packet_type1_ctrl_ul_ok <= 0;
    if (section_header_valid_0 && packet_in_window_1 && sectiontype_1 == 1 && datadirection_1 == 0)
      packet_type1_ctrl_ul_ok <= 1;

    packet_type1_ctrl_dl_ok <= 0;
    if (section_header_valid_0 && packet_in_window_1 && sectiontype_1 == 1 && datadirection_1 == 1)
      packet_type1_ctrl_dl_ok <= 1;

    packet_type3_ctrl_ul_ok <= 0;
    if (section_header_valid_0 && packet_in_window_1 && sectiontype_1 == 3 && datadirection_1 == 0)
      packet_type3_ctrl_ul_ok <= 1;

    // Ant0
    s000_fram_data_tvalid_0   <= s000_fram_data_tvalid;
    s000_fram_data_tlast_0    <= s000_fram_data_tlast;
    s000_fram_data_tready_0   <= s000_fram_data_tready;
    s000_fram_data_req_24_0   <= s000_fram_data_req_24;

    packet_type1_reqs_ul0_ok <= 0;
    if (s000_fram_data_req_24_0)
      packet_type1_reqs_ul0_ok <= 1;

    packet_type1_data_ul0_ok <= 0;
    if (s000_fram_data_tvalid_0 && s000_fram_data_tlast_0 && s000_fram_data_tready_0)
      packet_type1_data_ul0_ok <= 1;

    // Ant1
    s001_fram_data_tvalid_0   <= s001_fram_data_tvalid;
    s001_fram_data_tlast_0    <= s001_fram_data_tlast;
    s001_fram_data_tready_0   <= s001_fram_data_tready;
    s001_fram_data_req_24_0   <= s001_fram_data_req_24;

    packet_type1_reqs_ul1_ok <= 0;
    if (s001_fram_data_req_24_0)
      packet_type1_reqs_ul1_ok <= 1;

    packet_type1_data_ul1_ok <= 0;
    if (s001_fram_data_tvalid_0 && s001_fram_data_tlast_0 && s001_fram_data_tready_0)
      packet_type1_data_ul1_ok <= 1;

    // Ant2
    s002_fram_data_tvalid_0   <= s002_fram_data_tvalid;
    s002_fram_data_tlast_0    <= s002_fram_data_tlast;
    s002_fram_data_tready_0   <= s002_fram_data_tready;
    s002_fram_data_req_24_0   <= s002_fram_data_req_24;

    packet_type1_reqs_ul2_ok <= 0;
    if (s002_fram_data_req_24_0)
      packet_type1_reqs_ul2_ok <= 1;

    packet_type1_data_ul2_ok <= 0;
    if (s002_fram_data_tvalid_0 && s002_fram_data_tlast_0 && s002_fram_data_tready_0)
      packet_type1_data_ul2_ok <= 1;

    //Ant3
    s003_fram_data_tvalid_0   <= s003_fram_data_tvalid;
    s003_fram_data_tlast_0    <= s003_fram_data_tlast;
    s003_fram_data_tready_0   <= s003_fram_data_tready;
    s003_fram_data_req_24_0   <= s003_fram_data_req_24;

    packet_type1_reqs_ul3_ok <= 0;
    if (s003_fram_data_req_24_0)
      packet_type1_reqs_ul3_ok <= 1;

    packet_type1_data_ul3_ok <= 0;
    if (s003_fram_data_tvalid_0 && s003_fram_data_tlast_0 && s003_fram_data_tready_0)
      packet_type1_data_ul3_ok <= 1;

    m0_prach_tvalid_0           <= m0_prach_tvalid;
    m0_prach_tready_0           <= m0_prach_tready;
    s00_fram_prach_tvalid_0     <= s00_fram_prach_tvalid;
    s00_fram_prach_tlast_0      <= s00_fram_prach_tlast;
    s00_fram_prach_tready_0     <= s00_fram_prach_tready;

    packet_type3_reqs_ul_ok <= 0;
    if (m0_prach_tvalid_0 && m0_prach_tready_0)
      packet_type3_reqs_ul_ok <= 1;

    packet_type3_data_ul_ok <= 0;
    if (s00_fram_prach_tvalid_0 && s00_fram_prach_tlast_0 && s00_fram_prach_tready_0)
      packet_type3_data_ul_ok <= 1;

    if (rstin) begin
      packet_type0_data_dl_ok <= 0;
      packet_type1_ctrl_ul_ok <= 0;
      packet_type1_ctrl_dl_ok <= 0;
      packet_type3_ctrl_ul_ok <= 0;
      packet_type1_reqs_ul0_ok <= 0;
      packet_type1_data_ul0_ok <= 0;
      packet_type1_reqs_ul1_ok <= 0;
      packet_type1_data_ul1_ok <= 0;
      packet_type1_reqs_ul2_ok <= 0;
      packet_type1_data_ul2_ok <= 0;
      packet_type1_reqs_ul3_ok <= 0;
      packet_type1_data_ul3_ok <= 0;
      packet_type3_reqs_ul_ok <= 0;
      packet_type3_data_ul_ok <= 0;
    end
  end

  assign oks[ 0] = packet_type0_data_dl_ok;
  assign oks[ 1] = packet_type1_ctrl_ul_ok;
  assign oks[ 2] = packet_type1_ctrl_dl_ok;
  assign oks[ 3] = packet_type3_ctrl_ul_ok;
  assign oks[ 4] = packet_type1_reqs_ul0_ok;
  assign oks[ 5] = packet_type1_data_ul0_ok;
  assign oks[ 6] = packet_type1_reqs_ul1_ok;
  assign oks[ 7] = packet_type1_data_ul1_ok;
  assign oks[ 8] = packet_type1_reqs_ul2_ok;
  assign oks[ 9] = packet_type1_data_ul2_ok;
  assign oks[10] = packet_type1_reqs_ul3_ok;
  assign oks[11] = packet_type1_data_ul3_ok;
  assign oks[12] = packet_type3_reqs_ul_ok;
  assign oks[13] = packet_type3_data_ul_ok;
  
  generate
    for (k=0; k<14; k++) begin
      jb_oran_monitor_counter #(
        .COUNTER_WIDTH (CB)
        )
        jb_oran_monitor_counter_inst2(
          .clk          (clkin),
          .rst          (rstin),
          .alarm        (oks[k]),
          .alarm_count  (ok_counts[k]),
          .clear        (clear_fan[3])
          );
    end
  endgenerate
  
  always@(posedge clkin) begin
    // Scroll through all the counters for output...
    counter_idx <= counter_idx + 1;
    
    case (counter_idx)
       0: counter_mux <= alarm_counts[0];
       1: counter_mux <= alarm_counts[1];
       2: counter_mux <= alarm_counts[2];
       3: counter_mux <= alarm_counts[3];
       4: counter_mux <= alarm_counts[4];
       5: counter_mux <= alarm_counts[5];
       6: counter_mux <= alarm_counts[6];
       7: counter_mux <= alarm_counts[7];
       8: counter_mux <= alarm_counts[8]; 
       9: counter_mux <= alarm_counts[9]; 
      10: counter_mux <= alarm_counts[10];
      11: counter_mux <= ok_counts[0];
      12: counter_mux <= ok_counts[1];
      13: counter_mux <= ok_counts[2];
      14: counter_mux <= ok_counts[3];
      15: counter_mux <= ok_counts[4];
      16: counter_mux <= ok_counts[5];
      17: counter_mux <= ok_counts[6];
      18: counter_mux <= ok_counts[7];
      19: counter_mux <= ok_counts[8];
      20: counter_mux <= ok_counts[9];
      21: counter_mux <= ok_counts[10];
      22: counter_mux <= ok_counts[11];
      23: counter_mux <= ok_counts[12];
      24: counter_mux <= ok_counts[13];
      default : counter_mux <= 0;
    endcase
    
    // Delay to align values with names...
    counter_idx_0 <= counter_idx;
    
    // Output register...
    counter_names   <= counter_idx_0;
    counter_values  <= counter_mux;
    
    if (rstin) begin
      counter_names   <= 0;
      counter_values  <= 0;
      counter_idx     <= 0;
      counter_idx_0   <= 0;
      counter_mux     <= 0;
    end
  end
endmodule
