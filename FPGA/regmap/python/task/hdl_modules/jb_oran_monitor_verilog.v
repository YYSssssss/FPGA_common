/*
  This wrapper and helper blocks needed for integration into the Vivado BD...
*/
module jb_oran_monitor_verilog(
  aclk,
  aresetn,
  clear,

  m0_t_header_offset_valid,
  m0_runt_packet_len,
  m0_packet_in_window,
  m0_messagetype,
  m0_radio_app_head_valid,
  m0_datadirection,
  m0_sectiontype,
  m0_section_header_valid,
  m0_prach_tvalid,
  m0_prach_tready,

  s000_fram_data_tvalid,
  s000_fram_data_tlast,
  s000_fram_data_tready,
  s000_fram_data_req,

  s001_fram_data_tvalid,
  s001_fram_data_tlast,
  s001_fram_data_tready,
  s001_fram_data_req,
  
  s002_fram_data_tvalid,
  s002_fram_data_tlast,
  s002_fram_data_tready,
  s002_fram_data_req,
  
  s003_fram_data_tvalid,
  s003_fram_data_tlast,
  s003_fram_data_tready,
  s003_fram_data_req,

  s00_fram_prach_tvalid,
  s00_fram_prach_tlast,
  s00_fram_prach_tready,

  counter_names,
  counter_values
  );

  input  wire   	        aclk;
  input  wire   	        aresetn;
  input  wire             clear;
  
  input  wire             m0_t_header_offset_valid;
  input  wire             m0_runt_packet_len;
  input  wire             m0_packet_in_window;
  input  wire   [2:0]     m0_messagetype;
  input  wire             m0_radio_app_head_valid;
  input  wire             m0_datadirection;
  input  wire   [2:0]     m0_sectiontype;
  input  wire             m0_section_header_valid;
  input  wire             m0_prach_tvalid;
  input  wire             m0_prach_tready;
  
  input  wire             s000_fram_data_tvalid;
  input  wire             s000_fram_data_tlast;
  input  wire             s000_fram_data_tready;
  input  wire             s000_fram_data_req;
  
  input  wire             s001_fram_data_tvalid;
  input  wire             s001_fram_data_tlast;
  input  wire             s001_fram_data_tready;
  input  wire             s001_fram_data_req;
  
  input  wire             s002_fram_data_tvalid;
  input  wire             s002_fram_data_tlast;
  input  wire             s002_fram_data_tready;
  input  wire             s002_fram_data_req;
  
  input  wire             s003_fram_data_tvalid;
  input  wire             s003_fram_data_tlast;
  input  wire             s003_fram_data_tready;
  input  wire             s003_fram_data_req;
  
  input  wire             s00_fram_prach_tvalid;
  input  wire             s00_fram_prach_tlast;
  input  wire             s00_fram_prach_tready;
  
  output wire   [4:0]     counter_names;
  output wire   [23:0]    counter_values;
  
  wire rstin;
  assign rstin  = ~aresetn;
  
  jb_oran_monitor
    jb_oran_monitor_inst(
      .clkin(aclk),
      .rstin(rstin),
      .clear(clear),
      .transport_header_offset_valid(m0_t_header_offset_valid),
      .runt_packet_len(m0_runt_packet_len),
      .packet_in_window(m0_packet_in_window),
      .messagetype(m0_messagetype),
      .radio_app_header_valid(m0_radio_app_head_valid),
      .datadirection(m0_datadirection),
      .sectiontype(m0_sectiontype),
      .section_header_valid(m0_section_header_valid),
      .m0_prach_tvalid(m0_prach_tvalid),
      .m0_prach_tready(m0_prach_tready),

      .s000_fram_data_tvalid(s000_fram_data_tvalid),
      .s000_fram_data_tlast (s000_fram_data_tlast),
      .s000_fram_data_tready(s000_fram_data_tready),
      .s000_fram_data_req_24(s000_fram_data_req),
          
      .s001_fram_data_tvalid(s001_fram_data_tvalid),
      .s001_fram_data_tlast (s001_fram_data_tlast),
      .s001_fram_data_tready(s001_fram_data_tready),
      .s001_fram_data_req_24(s001_fram_data_req),
          
      .s002_fram_data_tvalid(s002_fram_data_tvalid),
      .s002_fram_data_tlast (s002_fram_data_tlast),
      .s002_fram_data_tready(s002_fram_data_tready),
      .s002_fram_data_req_24(s002_fram_data_req),
          
      .s003_fram_data_tvalid(s003_fram_data_tvalid),
      .s003_fram_data_tlast (s003_fram_data_tlast),
      .s003_fram_data_tready(s003_fram_data_tready),
      .s003_fram_data_req_24(s003_fram_data_req),

      .s00_fram_prach_tvalid(s00_fram_prach_tvalid),
      .s00_fram_prach_tlast(s00_fram_prach_tlast),
      .s00_fram_prach_tready(s00_fram_prach_tready),

      .counter_names(counter_names),
      .counter_values(counter_values)
      );
endmodule



module jb_oran_monitor_spy1(
  s0_tready,
  s0_tvalid,
  s0_tlast,
  s0_tkeep,
  s0_tdata,

  m0_tready,
  m0_tvalid,
  m0_tlast,
  m0_tkeep,
  m0_tdata,

  u0_tready,
  u0_tvalid,
  u0_tlast,
  
  aclk,
  aresetn
  );

  output wire             s0_tready;
  input  wire             s0_tvalid;
  input  wire             s0_tlast;
  input  wire   [7:0]     s0_tkeep;
  input  wire   [63:0]    s0_tdata;
  input  wire             m0_tready;
  output wire             m0_tvalid;
  output wire             m0_tlast;
  output wire   [7:0]     m0_tkeep;
  output wire   [63:0]    m0_tdata;
  output reg              u0_tready;
  output reg              u0_tvalid;
  output reg              u0_tlast;
  input  wire             aclk;
  input  wire             aresetn;

  assign s0_tready  = m0_tready;
  assign m0_tvalid  = s0_tvalid;
  assign m0_tlast   = s0_tlast;
  assign m0_tkeep   = s0_tkeep;
  assign m0_tdata   = s0_tdata;
  
  always@(posedge aclk) begin
    u0_tready   <= m0_tready;
    u0_tvalid   <= s0_tvalid;
    u0_tlast    <= s0_tlast;
    if (~aresetn) begin
      u0_tready   <= 0;
      u0_tvalid   <= 0;
      u0_tlast    <= 0;
    end
  end
endmodule

module jb_oran_monitor_spy2(
  s0_tready,
  s0_tvalid,
  s0_tlast,
  s0_tkeep,
  s0_tdata,
  s0_tuser,

  m0_tready,
  m0_tvalid,
  m0_tlast,
  m0_tkeep,
  m0_tdata,
  m0_tuser,

  u0_tready,
  u0_tvalid,
  u0_tlast,
  
  aclk,
  aresetn
  );

  output wire             s0_tready;
  input  wire             s0_tvalid;
  input  wire             s0_tlast;
  input  wire   [7:0]     s0_tkeep;
  input  wire   [63:0]    s0_tdata;
  input  wire   [31:0]    s0_tuser;
  input  wire             m0_tready;
  output wire             m0_tvalid;
  output wire             m0_tlast;
  output wire   [7:0]     m0_tkeep;
  output wire   [63:0]    m0_tdata;
  output wire   [31:0]    m0_tuser;
  output reg              u0_tready;
  output reg              u0_tvalid;
  output reg              u0_tlast;
  input  wire             aclk;
  input  wire             aresetn;

  assign s0_tready  = m0_tready;
  assign m0_tvalid  = s0_tvalid;
  assign m0_tlast   = s0_tlast;
  assign m0_tkeep   = s0_tkeep;
  assign m0_tdata   = s0_tdata;
  assign m0_tuser   = s0_tuser;
  
  always@(posedge aclk) begin
    u0_tready   <= m0_tready;
    u0_tvalid   <= s0_tvalid;
    u0_tlast    <= s0_tlast;
    if (~aresetn) begin
      u0_tready   <= 0;
      u0_tvalid   <= 0;
      u0_tlast    <= 0;
    end
  end
endmodule

module jb_oran_monitor_spy3(
  s0,
  m0,
  u0,
  
  aclk,
  aresetn
  );

  input  wire   [24:0]    s0;
  output wire   [24:0]    m0;
  output reg              u0;
  input  wire             aclk;
  input  wire             aresetn;

  assign m0 = s0;

  always@(posedge aclk) begin
    u0  <= s0[24];
    if (~aresetn) begin
      u0  <= 0;
    end
  end
endmodule

module jb_oran_monitor_spy4(
  s0_prach_tvalid,
  s0_prach_tready,
  s0_prach_cc,
  s0_prach_ss,
  s0_prach_section_id,
  s0_prach_return_port,
  s0_prach_filter_index,
  s0_prach_sf,
  s0_prach_sl,
  s0_prach_sy,
  s0_prach_time_offset,
  s0_prach_frame_structure,
  s0_prach_cp_length,
  s0_prach_udcomphdr,
  s0_prach_rb,
  s0_prach_syminc,
  s0_prach_start_prbc,
  s0_prach_num_prbc,
  s0_prach_remask,
  s0_prach_num_symbol,
  s0_prach_beamid,
  s0_prach_freqoffset,

  m0_prach_tvalid,
  m0_prach_tready,
  m0_prach_cc,
  m0_prach_ss,
  m0_prach_section_id,
  m0_prach_return_port,
  m0_prach_filter_index,
  m0_prach_sf,
  m0_prach_sl,
  m0_prach_sy,
  m0_prach_time_offset,
  m0_prach_frame_structure,
  m0_prach_cp_length,
  m0_prach_udcomphdr,
  m0_prach_rb,
  m0_prach_syminc,
  m0_prach_start_prbc,
  m0_prach_num_prbc,
  m0_prach_remask,
  m0_prach_num_symbol,
  m0_prach_beamid,
  m0_prach_freqoffset,

  u0_prach_tvalid,
  u0_prach_tready,
  
  aclk,
  aresetn
  );

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_tvalid            "*) input  wire             s0_prach_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_tready            "*) output wire             s0_prach_tready;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_cc                "*) input  wire   [3 :0]    s0_prach_cc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_ss                "*) input  wire   [7 :0]    s0_prach_ss;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_section_id        "*) input  wire   [11:0]    s0_prach_section_id;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_return_port       "*) input  wire   [3 :0]    s0_prach_return_port;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_filter_index      "*) input  wire   [3 :0]    s0_prach_filter_index;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_sf                "*) input  wire   [3 :0]    s0_prach_sf;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_sl                "*) input  wire   [5 :0]    s0_prach_sl;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_sy                "*) input  wire   [5 :0]    s0_prach_sy;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_time_offset       "*) input  wire   [15:0]    s0_prach_time_offset;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_frame_structure   "*) input  wire   [7 :0]    s0_prach_frame_structure;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_cp_length         "*) input  wire   [15:0]    s0_prach_cp_length;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_udcomphdr         "*) input  wire   [7 :0]    s0_prach_udcomphdr;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_rb                "*) input  wire             s0_prach_rb;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_syminc            "*) input  wire             s0_prach_syminc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_start_prbc        "*) input  wire   [9 :0]    s0_prach_start_prbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_num_prbc          "*) input  wire   [7 :0]    s0_prach_num_prbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_remask            "*) input  wire   [11:0]    s0_prach_remask;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_num_symbol        "*) input  wire   [3 :0]    s0_prach_num_symbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_beamid            "*) input  wire   [14:0]    s0_prach_beamid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_freqoffset        "*) input  wire   [23:0]    s0_prach_freqoffset;

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_tvalid            "*) output wire             m0_prach_tvalid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_tready            "*) input  wire             m0_prach_tready;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_cc                "*) output wire    [3 :0]   m0_prach_cc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_ss                "*) output wire    [7 :0]   m0_prach_ss;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_section_id        "*) output wire    [11:0]   m0_prach_section_id;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_return_port       "*) output wire    [3 :0]   m0_prach_return_port;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_filter_index      "*) output wire    [3 :0]   m0_prach_filter_index;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_sf                "*) output wire    [3 :0]   m0_prach_sf;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_sl                "*) output wire    [5 :0]   m0_prach_sl;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_sy                "*) output wire    [5 :0]   m0_prach_sy;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_time_offset       "*) output wire    [15:0]   m0_prach_time_offset;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_frame_structure   "*) output wire    [7 :0]   m0_prach_frame_structure;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_cp_length         "*) output wire    [15:0]   m0_prach_cp_length;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_udcomphdr         "*) output wire    [7 :0]   m0_prach_udcomphdr;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_rb                "*) output wire             m0_prach_rb;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_syminc            "*) output wire             m0_prach_syminc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_start_prbc        "*) output wire    [9 :0]   m0_prach_start_prbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_num_prbc          "*) output wire    [7 :0]   m0_prach_num_prbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_remask            "*) output wire    [11:0]   m0_prach_remask;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_num_symbol        "*) output wire    [3 :0]   m0_prach_num_symbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_beamid            "*) output wire    [14:0]   m0_prach_beamid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 m0_prach prach_freqoffset        "*) output wire    [23:0]   m0_prach_freqoffset;
  
  output reg    u0_prach_tvalid;
  output reg    u0_prach_tready;
  
  input  wire   aclk;
  input  wire   aresetn;

  assign s0_prach_tready          = m0_prach_tready;
  assign m0_prach_tvalid          = s0_prach_tvalid;
  assign m0_prach_cc              = s0_prach_cc;
  assign m0_prach_ss              = s0_prach_ss;
  assign m0_prach_section_id      = s0_prach_section_id;
  assign m0_prach_return_port     = s0_prach_return_port;
  assign m0_prach_filter_index    = s0_prach_filter_index;
  assign m0_prach_sf              = s0_prach_sf;
  assign m0_prach_sl              = s0_prach_sl;
  assign m0_prach_sy              = s0_prach_sy;
  assign m0_prach_time_offset     = s0_prach_time_offset;
  assign m0_prach_frame_structure = s0_prach_frame_structure;
  assign m0_prach_cp_length       = s0_prach_cp_length;
  assign m0_prach_udcomphdr       = s0_prach_udcomphdr;
  assign m0_prach_rb              = s0_prach_rb;
  assign m0_prach_syminc          = s0_prach_syminc;
  assign m0_prach_start_prbc      = s0_prach_start_prbc;
  assign m0_prach_num_prbc        = s0_prach_num_prbc;
  assign m0_prach_remask          = s0_prach_remask;
  assign m0_prach_num_symbol      = s0_prach_num_symbol;
  assign m0_prach_beamid          = s0_prach_beamid;
  assign m0_prach_freqoffset      = s0_prach_freqoffset;
  
  always@(posedge aclk) begin
    u0_prach_tvalid   <= s0_prach_tvalid;
    u0_prach_tready   <= s0_prach_tready;
    if (~aresetn) begin
      u0_prach_tvalid   <= 0;
      u0_prach_tready   <= 0;
    end
  end
endmodule

module jb_oran_monitor_spy5(
  s0_t_header_offset_valid,
  s0_runt_packet_len,
  s0_rtc_pc_id,
  s0_concat,
  s0_messagetype,
  s0_seqid,
  s0_subseqid,
  s0_ebit,
  s0_payloadsize,
  s0_packet_in_window,
  s0_offset_in_symbol,
  s0_radio_app_head_valid,
  s0_datadirection,
  s0_numsections,
  s0_sectiontype,
  s0_filterindex,
  s0_frameid,
  s0_subframeid,
  s0_slotid,
  s0_symbolid,
  s0_udcomphdr,
  s0_timeoffset,
  s0_framestructure,
  s0_cplength,
  s0_section_header_valid,
  s0_numsymbol,
  s0_numprbc,
  s0_startprbc,
  s0_sectionid,
  s0_rb,
  s0_remask,
  s0_beamid15,
  s0_freqoffset,

  m0_t_header_offset_valid,
  m0_runt_packet_len,
  m0_rtc_pc_id,
  m0_concat,
  m0_messagetype,
  m0_seqid,
  m0_subseqid,
  m0_ebit,
  m0_payloadsize,
  m0_packet_in_window,
  m0_offset_in_symbol,
  m0_radio_app_head_valid,
  m0_datadirection,
  m0_numsections,
  m0_sectiontype,
  m0_filterindex,
  m0_frameid,
  m0_subframeid,
  m0_slotid,
  m0_symbolid,
  m0_udcomphdr,
  m0_timeoffset,
  m0_framestructure,
  m0_cplength,
  m0_section_header_valid,
  m0_numsymbol,
  m0_numprbc,
  m0_startprbc,
  m0_sectionid,
  m0_rb,
  m0_remask,
  m0_beamid15,
  m0_freqoffset,

  u0_t_header_offset_valid,
  u0_runt_packet_len,
  u0_rtc_pc_id,
  u0_concat,
  u0_messagetype,
  u0_seqid,
  u0_subseqid,
  u0_ebit,
  u0_payloadsize,
  u0_packet_in_window,
  u0_offset_in_symbol,
  u0_radio_app_head_valid,
  u0_datadirection,
  u0_numsections,
  u0_sectiontype,
  u0_filterindex,
  u0_frameid,
  u0_subframeid,
  u0_slotid,
  u0_symbolid,
  u0_udcomphdr,
  u0_timeoffset,
  u0_framestructure,
  u0_cplength,
  u0_section_header_valid,
  u0_numsymbol,
  u0_numprbc,
  u0_startprbc,
  u0_sectionid,
  u0_rb,
  u0_remask,
  u0_beamid15,
  u0_freqoffset,
  
  aclk,
  aresetn
  );
  
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran t_header_offset_valid "*)  input  wire          s0_t_header_offset_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran runt_packet_len       "*)  input  wire          s0_runt_packet_len;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran rtc_pc_id             "*)  input  wire  [15:0]  s0_rtc_pc_id;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran concat                "*)  input  wire          s0_concat;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran messagetype           "*)  input  wire  [2:0]   s0_messagetype;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran seqid                 "*)  input  wire  [7:0]   s0_seqid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran subseqid              "*)  input  wire  [6:0]   s0_subseqid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran ebit                  "*)  input  wire          s0_ebit;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran payloadsize           "*)  input  wire  [15:0]  s0_payloadsize;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran packet_in_window      "*)  input  wire          s0_packet_in_window;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran offset_in_symbol      "*)  input  wire  [11:0]  s0_offset_in_symbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran radio_app_head_valid  "*)  input  wire          s0_radio_app_head_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran datadirection         "*)  input  wire          s0_datadirection;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran numsections           "*)  input  wire  [7:0]   s0_numsections;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran sectiontype           "*)  input  wire  [2:0]   s0_sectiontype;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran filterindex           "*)  input  wire  [3:0]   s0_filterindex;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran frameid               "*)  input  wire  [7:0]   s0_frameid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran subframeid            "*)  input  wire  [3:0]   s0_subframeid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran slotid                "*)  input  wire  [5:0]   s0_slotid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran symbolid              "*)  input  wire  [5:0]   s0_symbolid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran udcomphdr             "*)  input  wire  [7:0]   s0_udcomphdr;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran timeoffset            "*)  input  wire  [15:0]  s0_timeoffset;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran framestructure        "*)  input  wire  [7:0]   s0_framestructure;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran cplength              "*)  input  wire  [15:0]  s0_cplength;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran section_header_valid  "*)  input  wire          s0_section_header_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran numsymbol             "*)  input  wire  [3:0]   s0_numsymbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran numprbc               "*)  input  wire  [7:0]   s0_numprbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran startprbc             "*)  input  wire  [9:0]   s0_startprbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran sectionid             "*)  input  wire  [11:0]  s0_sectionid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran rb                    "*)  input  wire          s0_rb;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran remask                "*)  input  wire  [11:0]  s0_remask;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran beamid15              "*)  input  wire  [14:0]  s0_beamid15;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 s0_oran freqoffset            "*)  input  wire  [23:0]  s0_freqoffset;
  
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran t_header_offset_valid "*)  output wire          m0_t_header_offset_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran runt_packet_len       "*)  output wire          m0_runt_packet_len;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran rtc_pc_id             "*)  output wire  [15:0]  m0_rtc_pc_id;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran concat                "*)  output wire          m0_concat;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran messagetype           "*)  output wire  [2:0]   m0_messagetype;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran seqid                 "*)  output wire  [7:0]   m0_seqid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran subseqid              "*)  output wire  [6:0]   m0_subseqid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran ebit                  "*)  output wire          m0_ebit;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran payloadsize           "*)  output wire  [15:0]  m0_payloadsize;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran packet_in_window      "*)  output wire          m0_packet_in_window;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran offset_in_symbol      "*)  output wire  [11:0]  m0_offset_in_symbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran radio_app_head_valid  "*)  output wire          m0_radio_app_head_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran datadirection         "*)  output wire          m0_datadirection;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran numsections           "*)  output wire  [7:0]   m0_numsections;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran sectiontype           "*)  output wire  [2:0]   m0_sectiontype;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran filterindex           "*)  output wire  [3:0]   m0_filterindex;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran frameid               "*)  output wire  [7:0]   m0_frameid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran subframeid            "*)  output wire  [3:0]   m0_subframeid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran slotid                "*)  output wire  [5:0]   m0_slotid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran symbolid              "*)  output wire  [5:0]   m0_symbolid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran udcomphdr             "*)  output wire  [7:0]   m0_udcomphdr;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran timeoffset            "*)  output wire  [15:0]  m0_timeoffset;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran framestructure        "*)  output wire  [7:0]   m0_framestructure;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran cplength              "*)  output wire  [15:0]  m0_cplength;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran section_header_valid  "*)  output wire          m0_section_header_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran numsymbol             "*)  output wire  [3:0]   m0_numsymbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran numprbc               "*)  output wire  [7:0]   m0_numprbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran startprbc             "*)  output wire  [9:0]   m0_startprbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran sectionid             "*)  output wire  [11:0]  m0_sectionid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran rb                    "*)  output wire          m0_rb;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran remask                "*)  output wire  [11:0]  m0_remask;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran beamid15              "*)  output wire  [14:0]  m0_beamid15;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 m0_oran freqoffset            "*)  output wire  [23:0]  m0_freqoffset;

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran t_header_offset_valid "*)  output reg           u0_t_header_offset_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran runt_packet_len       "*)  output reg           u0_runt_packet_len;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran rtc_pc_id             "*)  output reg   [15:0]  u0_rtc_pc_id;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran concat                "*)  output reg           u0_concat;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran messagetype           "*)  output reg   [2:0]   u0_messagetype;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran seqid                 "*)  output reg   [7:0]   u0_seqid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran subseqid              "*)  output reg   [6:0]   u0_subseqid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran ebit                  "*)  output reg           u0_ebit;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran payloadsize           "*)  output reg   [15:0]  u0_payloadsize;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran packet_in_window      "*)  output reg           u0_packet_in_window;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran offset_in_symbol      "*)  output reg   [11:0]  u0_offset_in_symbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran radio_app_head_valid  "*)  output reg           u0_radio_app_head_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran datadirection         "*)  output reg           u0_datadirection;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran numsections           "*)  output reg   [7:0]   u0_numsections;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran sectiontype           "*)  output reg   [2:0]   u0_sectiontype;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran filterindex           "*)  output reg   [3:0]   u0_filterindex;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran frameid               "*)  output reg   [7:0]   u0_frameid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran subframeid            "*)  output reg   [3:0]   u0_subframeid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran slotid                "*)  output reg   [5:0]   u0_slotid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran symbolid              "*)  output reg   [5:0]   u0_symbolid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran udcomphdr             "*)  output reg   [7:0]   u0_udcomphdr;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran timeoffset            "*)  output reg   [15:0]  u0_timeoffset;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran framestructure        "*)  output reg   [7:0]   u0_framestructure;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran cplength              "*)  output reg   [15:0]  u0_cplength;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran section_header_valid  "*)  output reg           u0_section_header_valid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran numsymbol             "*)  output reg   [3:0]   u0_numsymbol;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran numprbc               "*)  output reg   [7:0]   u0_numprbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran startprbc             "*)  output reg   [9:0]   u0_startprbc;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran sectionid             "*)  output reg   [11:0]  u0_sectionid;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran rb                    "*)  output reg           u0_rb;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran remask                "*)  output reg   [11:0]  u0_remask;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran beamid15              "*)  output reg   [14:0]  u0_beamid15;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_header_if_rtl:1.0 u0_oran freqoffset            "*)  output reg   [23:0]  u0_freqoffset;

  input  wire   aclk;
  input  wire   aresetn;

  assign m0_t_header_offset_valid   = s0_t_header_offset_valid;
  assign m0_runt_packet_len         = s0_runt_packet_len;
  assign m0_rtc_pc_id               = s0_rtc_pc_id;
  assign m0_concat                  = s0_concat;
  assign m0_messagetype             = s0_messagetype;
  assign m0_seqid                   = s0_seqid;
  assign m0_subseqid                = s0_subseqid;
  assign m0_ebit                    = s0_ebit;
  assign m0_payloadsize             = s0_payloadsize;
  assign m0_packet_in_window        = s0_packet_in_window;
  assign m0_offset_in_symbol        = s0_offset_in_symbol;
  assign m0_radio_app_head_valid    = s0_radio_app_head_valid;
  assign m0_datadirection           = s0_datadirection;
  assign m0_numsections             = s0_numsections;
  assign m0_sectiontype             = s0_sectiontype;
  assign m0_filterindex             = s0_filterindex;
  assign m0_frameid                 = s0_frameid;
  assign m0_subframeid              = s0_subframeid;
  assign m0_slotid                  = s0_slotid;
  assign m0_symbolid                = s0_symbolid;
  assign m0_udcomphdr               = s0_udcomphdr;
  assign m0_timeoffset              = s0_timeoffset;
  assign m0_framestructure          = s0_framestructure;
  assign m0_cplength                = s0_cplength;
  assign m0_section_header_valid    = s0_section_header_valid;
  assign m0_numsymbol               = s0_numsymbol;
  assign m0_numprbc                 = s0_numprbc;
  assign m0_startprbc               = s0_startprbc;
  assign m0_sectionid               = s0_sectionid;
  assign m0_rb                      = s0_rb;
  assign m0_remask                  = s0_remask;
  assign m0_beamid15                = s0_beamid15;
  assign m0_freqoffset              = s0_freqoffset;
  
  always@(posedge aclk) begin
    u0_t_header_offset_valid  <= s0_t_header_offset_valid;
    u0_runt_packet_len        <= s0_runt_packet_len;
    u0_rtc_pc_id              <= s0_rtc_pc_id;
    u0_concat                 <= s0_concat;
    u0_messagetype            <= s0_messagetype;
    u0_seqid                  <= s0_seqid;
    u0_subseqid               <= s0_subseqid;
    u0_ebit                   <= s0_ebit;
    u0_payloadsize            <= s0_payloadsize;
    u0_packet_in_window       <= s0_packet_in_window;
    u0_offset_in_symbol       <= s0_offset_in_symbol;
    u0_radio_app_head_valid   <= s0_radio_app_head_valid;
    u0_datadirection          <= s0_datadirection;
    u0_numsections            <= s0_numsections;
    u0_sectiontype            <= s0_sectiontype;
    u0_filterindex            <= s0_filterindex;
    u0_frameid                <= s0_frameid;
    u0_subframeid             <= s0_subframeid;
    u0_slotid                 <= s0_slotid;
    u0_symbolid               <= s0_symbolid;
    u0_udcomphdr              <= s0_udcomphdr;
    u0_timeoffset             <= s0_timeoffset;
    u0_framestructure         <= s0_framestructure;
    u0_cplength               <= s0_cplength;
    u0_section_header_valid   <= s0_section_header_valid;
    u0_numsymbol              <= s0_numsymbol;
    u0_numprbc                <= s0_numprbc;
    u0_startprbc              <= s0_startprbc;
    u0_sectionid              <= s0_sectionid;
    u0_rb                     <= s0_rb;
    u0_remask                 <= s0_remask;
    u0_beamid15               <= s0_beamid15;
    u0_freqoffset             <= s0_freqoffset;
    if (~aresetn) begin
      u0_t_header_offset_valid  <= 0;
      u0_runt_packet_len        <= 0;
      u0_rtc_pc_id              <= 0;
      u0_concat                 <= 0;
      u0_messagetype            <= 0;
      u0_seqid                  <= 0;
      u0_subseqid               <= 0;
      u0_ebit                   <= 0;
      u0_payloadsize            <= 0;
      u0_packet_in_window       <= 0;
      u0_offset_in_symbol       <= 0;
      u0_radio_app_head_valid   <= 0;
      u0_datadirection          <= 0;
      u0_numsections            <= 0;
      u0_sectiontype            <= 0;
      u0_filterindex            <= 0;
      u0_frameid                <= 0;
      u0_subframeid             <= 0;
      u0_slotid                 <= 0;
      u0_symbolid               <= 0;
      u0_udcomphdr              <= 0;
      u0_timeoffset             <= 0;
      u0_framestructure         <= 0;
      u0_cplength               <= 0;
      u0_section_header_valid   <= 0;
      u0_numsymbol              <= 0;
      u0_numprbc                <= 0;
      u0_startprbc              <= 0;
      u0_sectionid              <= 0;
      u0_rb                     <= 0;
      u0_remask                 <= 0;
      u0_beamid15               <= 0;
      u0_freqoffset             <= 0;
    end
  end
endmodule

module jb_oran_monitor_spy6(
  m0_ul_sym_num,
  m0_ul_cta_sym_num,
  m0_ul_update,
  m0_dl_sym_num,
  m0_dl_cta_sym_num,
  m0_dl_update,
  m0_cc_enable,
  m0_cc_reload,

  s0_ul_sym_num,
  s0_ul_cta_sym_num,
  s0_ul_update,
  s0_dl_sym_num,
  s0_dl_cta_sym_num,
  s0_dl_update,
  s0_cc_enable,
  s0_cc_reload,

  u0_ul_sym_num,
  u0_ul_cta_sym_num,
  u0_ul_update,
  u0_dl_sym_num,
  u0_dl_cta_sym_num,
  u0_dl_update,
  u0_cc_enable,
  u0_cc_reload,
  
  aclk,
  aresetn
  );

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing ul_sym_num       "*) input  wire [11:0] m0_ul_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing ul_cta_sym_num   "*) input  wire [11:0] m0_ul_cta_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing ul_update        "*) input  wire        m0_ul_update;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing dl_sym_num       "*) input  wire [11:0] m0_dl_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing dl_cta_sym_num   "*) input  wire [11:0] m0_dl_cta_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing dl_update        "*) input  wire        m0_dl_update;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing cc_enable        "*) input  wire        m0_cc_enable;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 m0_timing cc_reload        "*) input  wire        m0_cc_reload;
  
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing ul_sym_num       "*) output  reg [11:0] s0_ul_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing ul_cta_sym_num   "*) output  reg [11:0] s0_ul_cta_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing ul_update        "*) output  reg        s0_ul_update;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing dl_sym_num       "*) output  reg [11:0] s0_dl_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing dl_cta_sym_num   "*) output  reg [11:0] s0_dl_cta_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing dl_update        "*) output  reg        s0_dl_update;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing cc_enable        "*) output  reg        s0_cc_enable;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 s0_timing cc_reload        "*) output  reg        s0_cc_reload;

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing ul_sym_num       "*) output  reg [11:0] u0_ul_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing ul_cta_sym_num   "*) output  reg [11:0] u0_ul_cta_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing ul_update        "*) output  reg        u0_ul_update;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing dl_sym_num       "*) output  reg [11:0] u0_dl_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing dl_cta_sym_num   "*) output  reg [11:0] u0_dl_cta_sym_num;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing dl_update        "*) output  reg        u0_dl_update;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing cc_enable        "*) output  reg        u0_cc_enable;
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_timing_if_rtl:1.0 u0_timing cc_reload        "*) output  reg        u0_cc_reload;
  
  input  wire aclk;
  input  wire aresetn;

  always@(posedge aclk) begin
    s0_ul_sym_num       <= m0_ul_sym_num;
    s0_ul_cta_sym_num   <= m0_ul_cta_sym_num;
    s0_ul_update        <= m0_ul_update;
    s0_dl_sym_num       <= m0_dl_sym_num;
    s0_dl_cta_sym_num   <= m0_dl_cta_sym_num;
    s0_dl_update        <= m0_dl_update;
    s0_cc_enable        <= m0_cc_enable;
    s0_cc_reload        <= m0_cc_reload;
    u0_ul_sym_num       <= m0_ul_sym_num;
    u0_ul_cta_sym_num   <= m0_ul_cta_sym_num;
    u0_ul_update        <= m0_ul_update;
    u0_dl_sym_num       <= m0_dl_sym_num;
    u0_dl_cta_sym_num   <= m0_dl_cta_sym_num;
    u0_dl_update        <= m0_dl_update;
    u0_cc_enable        <= m0_cc_enable;
    u0_cc_reload        <= m0_cc_reload;
    if (~aresetn) begin
      s0_ul_sym_num       <= 0;
      s0_ul_cta_sym_num   <= 0;
      s0_ul_update        <= 0;
      s0_dl_sym_num       <= 0;
      s0_dl_cta_sym_num   <= 0;
      s0_dl_update        <= 0;
      s0_cc_enable        <= 0;
      s0_cc_reload        <= 0;
      u0_ul_sym_num       <= 0;
      u0_ul_cta_sym_num   <= 0;
      u0_ul_update        <= 0;
      u0_dl_sym_num       <= 0;
      u0_dl_cta_sym_num   <= 0;
      u0_dl_update        <= 0;
      u0_cc_enable        <= 0;
      u0_cc_reload        <= 0;
    end
  end
endmodule
