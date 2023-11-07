`timescale 1ps/1ps

`ifdef DL_SKEW1
  `define dl_skew 'd28544
`elsif DL_SKEW2
  `define dl_skew 'd57088
`elsif DL_SKEW3
  `define dl_skew 'd85632
`else
  `define dl_skew 'd0
`endif

`ifdef UL_SKEW1
  `define ul_skew 'd28544
`elsif UL_SKEW2
  `define ul_skew 'd57088
`elsif UL_SKEW3
  `define ul_skew 'd85632
`else
  `define ul_skew 'd0
`endif


module roe_radio_top #(
   parameter NO_OF_CLOCKS_FOR_1MS = 'd399616
) (

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_tvalid          "  *)               input  wire           s0_prach_tvalid           ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_tready          "  *)               output reg            s0_prach_tready=1         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_cc              "  *)               input  wire  [3 :0]   s0_prach_cc               ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_ss              "  *)               input  wire  [7 :0]   s0_prach_ss               ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_section_id      "  *)               input  wire  [11:0]   s0_prach_section_id       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_return_port     "  *)               input  wire  [3 :0]   s0_prach_return_port      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_filter_index    "  *)               input  wire  [3 :0]   s0_prach_filter_index     ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_sf              "  *)               input  wire  [3 :0]   s0_prach_sf               ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_sl              "  *)               input  wire  [5 :0]   s0_prach_sl               ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_sy              "  *)               input  wire  [5 :0]   s0_prach_sy               ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_time_offset     "  *)               input  wire  [15:0]   s0_prach_time_offset      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_frame_structure "  *)               input  wire  [7 :0]   s0_prach_frame_structure  ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_cp_length       "  *)               input  wire  [15:0]   s0_prach_cp_length        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_udcomphdr       "  *)               input  wire  [7 :0]   s0_prach_udcomphdr        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_rb              "  *)               input  wire           s0_prach_rb               ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_syminc          "  *)               input  wire           s0_prach_syminc           ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_start_prbc      "  *)               input  wire  [9 :0]   s0_prach_start_prbc       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_num_prbc        "  *)               input  wire  [7 :0]   s0_prach_num_prbc         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_remask          "  *)               input  wire  [11:0]   s0_prach_remask           ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_num_symbol      "  *)               input  wire  [3 :0]   s0_prach_num_symbol       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_beamid          "  *)               input  wire  [14:0]   s0_prach_beamid           ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xorif_prach_if_rtl:1.0 s0_prach prach_freqoffset      "  *)               input  wire  [23:0]   s0_prach_freqoffset       ,

  // CARRIER and RTC ports for the Framer, the datapath to the ethernet
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_000 TDATA"  *)                                     output wire  [63:0] m000_fram_data_tdata        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_000 TKEEP"  *)                                     output wire   [7:0] m000_fram_data_tkeep        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_000 TVALID" *)                                     output wire         m000_fram_data_tvalid       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_000 TLAST"  *)                                     output wire         m000_fram_data_tlast        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_000 TREADY" *)                                     input  wire         m000_fram_data_tready       ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_valid     "  *)  input  wire         s000_fram_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_ready     "  *)  output reg          s000_fram_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_beamid15  "  *)  input  wire  [14:0] s000_fram_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_remask    "  *)  input  wire  [11:0] s000_fram_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_rb        "  *)  input  wire         s000_fram_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_start_prbc"  *)  input  wire   [9:0] s000_fram_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_num_prbc  "  *)  input  wire   [7:0] s000_fram_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_num_symbol"  *)  input  wire   [3:0] s000_fram_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_fram_bid bid_cc_id     "  *)  input  wire   [7:0] s000_fram_bid_cc_id         ,
                                                                                                                           input  wire  [24:0] m000_fram_data_req          ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_001 TDATA"  *)                                     output wire  [63:0] m001_fram_data_tdata        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_001 TKEEP"  *)                                     output wire   [7:0] m001_fram_data_tkeep        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_001 TVALID" *)                                     output wire         m001_fram_data_tvalid       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_001 TLAST"  *)                                     output wire         m001_fram_data_tlast        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_001 TREADY" *)                                     input  wire         m001_fram_data_tready       ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_valid     "  *)  input  wire         s001_fram_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_ready     "  *)  output reg          s001_fram_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_beamid15  "  *)  input  wire  [14:0] s001_fram_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_remask    "  *)  input  wire  [11:0] s001_fram_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_rb        "  *)  input  wire         s001_fram_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_start_prbc"  *)  input  wire   [9:0] s001_fram_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_num_prbc  "  *)  input  wire   [7:0] s001_fram_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_num_symbol"  *)  input  wire   [3:0] s001_fram_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_fram_bid bid_cc_id     "  *)  input  wire   [7:0] s001_fram_bid_cc_id         ,
                                                                                                                           input  wire  [24:0] m001_fram_data_req          ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_002 TDATA"  *)                                     output wire  [63:0] m002_fram_data_tdata        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_002 TKEEP"  *)                                     output wire   [7:0] m002_fram_data_tkeep        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_002 TVALID" *)                                     output wire         m002_fram_data_tvalid       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_002 TLAST"  *)                                     output wire         m002_fram_data_tlast        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_002 TREADY" *)                                     input  wire         m002_fram_data_tready       ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_valid     "  *)  input  wire         s002_fram_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_ready     "  *)  output reg          s002_fram_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_beamid15  "  *)  input  wire  [14:0] s002_fram_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_remask    "  *)  input  wire  [11:0] s002_fram_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_rb        "  *)  input  wire         s002_fram_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_start_prbc"  *)  input  wire   [9:0] s002_fram_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_num_prbc  "  *)  input  wire   [7:0] s002_fram_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_num_symbol"  *)  input  wire   [3:0] s002_fram_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_fram_bid bid_cc_id     "  *)  input  wire   [7:0] s002_fram_bid_cc_id         ,
                                                                                                                           input  wire  [24:0] m002_fram_data_req          ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_003 TDATA"  *)                                     output wire  [63:0] m003_fram_data_tdata        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_003 TKEEP"  *)                                     output wire   [7:0] m003_fram_data_tkeep        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_003 TVALID" *)                                     output wire         m003_fram_data_tvalid       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_003 TLAST"  *)                                     output wire         m003_fram_data_tlast        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_data_003 TREADY" *)                                     input  wire         m003_fram_data_tready       ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_valid     "  *)  input  wire         s003_fram_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_ready     "  *)  output reg          s003_fram_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_beamid15  "  *)  input  wire  [14:0] s003_fram_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_remask    "  *)  input  wire  [11:0] s003_fram_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_rb        "  *)  input  wire         s003_fram_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_start_prbc"  *)  input  wire   [9:0] s003_fram_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_num_prbc  "  *)  input  wire   [7:0] s003_fram_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_num_symbol"  *)  input  wire   [3:0] s003_fram_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_fram_bid bid_cc_id     "  *)  input  wire   [7:0] s003_fram_bid_cc_id         ,
                                                                                                                           input  wire  [24:0] m003_fram_data_req          ,
 
 
 
 
 
 
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_unsol_00 TDATA"  *)                                    output reg   [63:0] m00_fram_unsol_tdata   = 0 ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_unsol_00 TUSER"  *)                                    output reg   [31:0] m00_fram_unsol_tuser   = 0 ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_unsol_00 TKEEP"  *)                                    output reg    [7:0] m00_fram_unsol_tkeep   = 0 ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_unsol_00 TVALID" *)                                    output reg          m00_fram_unsol_tvalid  = 0 ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_unsol_00 TLAST"  *)                                    output reg          m00_fram_unsol_tlast   = 0 ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_unsol_00 TREADY" *)                                    input  wire         m00_fram_unsol_tready      ,

 
 
 
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_prach_00 TDATA"  *)                                    output wire  [63:0] m00_fram_prach_tdata       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_prach_00 TUSER"  *)                                    output wire  [31:0] m00_fram_prach_tuser       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_prach_00 TKEEP"  *)                                    output wire   [7:0] m00_fram_prach_tkeep       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_prach_00 TVALID" *)                                    output wire         m00_fram_prach_tvalid      ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_prach_00 TLAST"  *)                                    output wire         m00_fram_prach_tlast       ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 src_prach_00 TREADY" *)                                    input  wire         m00_fram_prach_tready      ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_000 TDATA"  *)                                    input  wire  [63:0] s000_defm_data_tdata     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_000 TKEEP"  *)                                    input  wire   [7:0] s000_defm_data_tkeep     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_000 TVALID" *)                                    input  wire         s000_defm_data_tvalid    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_000 TLAST"  *)                                    input  wire         s000_defm_data_tlast     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_000 TREADY" *)                                    output reg          s000_defm_data_tready=1    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_000 TUSER"  *)                                    input  wire  [30:0] s000_defm_data_tuser     ,
                                  
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_000 TDATA"  *)                                      output wire  [63:0] s000_defm_data_tdata_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_000 TKEEP"  *)                                      output wire   [7:0] s000_defm_data_tkeep_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_000 TVALID" *)                                      output wire         s000_defm_data_tvalid_mon,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_000 TLAST"  *)                                      output wire         s000_defm_data_tlast_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_000 TUSER"  *)                                      output wire  [30:0] s000_defm_data_tuser_mon ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_valid     "  *)  input  wire         s000_defm_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_ready     "  *)  output reg          s000_defm_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_beamid15  "  *)  input  wire  [14:0] s000_defm_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_remask    "  *)  input  wire  [11:0] s000_defm_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_rb        "  *)  input  wire         s000_defm_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_start_prbc"  *)  input  wire  [9:0]  s000_defm_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_num_prbc  "  *)  input  wire  [7:0]  s000_defm_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_num_symbol"  *)  input  wire  [3:0]  s000_defm_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s000_defm_bid bid_cc_id     "  *)  input  wire  [7:0]  s000_defm_bid_cc_id         ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_001 TDATA"  *)                                    input  wire  [63:0] s001_defm_data_tdata     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_001 TKEEP"  *)                                    input  wire   [7:0] s001_defm_data_tkeep     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_001 TVALID" *)                                    input  wire         s001_defm_data_tvalid    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_001 TLAST"  *)                                    input  wire         s001_defm_data_tlast     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_001 TREADY" *)                                    output reg          s001_defm_data_tready=1    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_001 TUSER"  *)                                    input  wire  [30:0] s001_defm_data_tuser     ,
                                  
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_001 TDATA"  *)                                      output wire  [63:0] s001_defm_data_tdata_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_001 TKEEP"  *)                                      output wire   [7:0] s001_defm_data_tkeep_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_001 TVALID" *)                                      output wire         s001_defm_data_tvalid_mon,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_001 TLAST"  *)                                      output wire         s001_defm_data_tlast_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_001 TUSER"  *)                                      output wire  [30:0] s001_defm_data_tuser_mon ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_valid     "  *)  input  wire         s001_defm_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_ready     "  *)  output reg          s001_defm_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_beamid15  "  *)  input  wire  [14:0] s001_defm_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_remask    "  *)  input  wire  [11:0] s001_defm_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_rb        "  *)  input  wire         s001_defm_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_start_prbc"  *)  input  wire  [9:0]  s001_defm_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_num_prbc  "  *)  input  wire  [7:0]  s001_defm_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_num_symbol"  *)  input  wire  [3:0]  s001_defm_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s001_defm_bid bid_cc_id     "  *)  input  wire  [7:0]  s001_defm_bid_cc_id         ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_002 TDATA"  *)                                    input  wire  [63:0] s002_defm_data_tdata     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_002 TKEEP"  *)                                    input  wire   [7:0] s002_defm_data_tkeep     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_002 TVALID" *)                                    input  wire         s002_defm_data_tvalid    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_002 TLAST"  *)                                    input  wire         s002_defm_data_tlast     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_002 TREADY" *)                                    output reg          s002_defm_data_tready=1    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_002 TUSER"  *)                                    input  wire  [30:0] s002_defm_data_tuser     ,
                                  
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_002 TDATA"  *)                                      output wire  [63:0] s002_defm_data_tdata_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_002 TKEEP"  *)                                      output wire   [7:0] s002_defm_data_tkeep_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_002 TVALID" *)                                      output wire         s002_defm_data_tvalid_mon,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_002 TLAST"  *)                                      output wire         s002_defm_data_tlast_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_002 TUSER"  *)                                      output wire  [30:0] s002_defm_data_tuser_mon ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_valid     "  *)  input  wire         s002_defm_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_ready     "  *)  output reg          s002_defm_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_beamid15  "  *)  input  wire  [14:0] s002_defm_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_remask    "  *)  input  wire  [11:0] s002_defm_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_rb        "  *)  input  wire         s002_defm_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_start_prbc"  *)  input  wire  [9:0]  s002_defm_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_num_prbc  "  *)  input  wire  [7:0]  s002_defm_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_num_symbol"  *)  input  wire  [3:0]  s002_defm_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s002_defm_bid bid_cc_id     "  *)  input  wire  [7:0]  s002_defm_bid_cc_id         ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_003 TDATA"  *)                                    input  wire  [63:0] s003_defm_data_tdata     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_003 TKEEP"  *)                                    input  wire   [7:0] s003_defm_data_tkeep     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_003 TVALID" *)                                    input  wire         s003_defm_data_tvalid    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_003 TLAST"  *)                                    input  wire         s003_defm_data_tlast     ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_003 TREADY" *)                                    output reg          s003_defm_data_tready=1    ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sink_data_003 TUSER"  *)                                    input  wire  [30:0] s003_defm_data_tuser     ,
                                  
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_003 TDATA"  *)                                      output wire  [63:0] s003_defm_data_tdata_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_003 TKEEP"  *)                                      output wire   [7:0] s003_defm_data_tkeep_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_003 TVALID" *)                                      output wire         s003_defm_data_tvalid_mon,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_003 TLAST"  *)                                      output wire         s003_defm_data_tlast_mon ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 sinkMon_003 TUSER"  *)                                      output wire  [30:0] s003_defm_data_tuser_mon ,

  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_valid     "  *)  input  wire         s003_defm_bid_valid         ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_ready     "  *)  output reg          s003_defm_bid_ready=1       ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_beamid15  "  *)  input  wire  [14:0] s003_defm_bid_beamid15      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_remask    "  *)  input  wire  [11:0] s003_defm_bid_remask        ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_rb        "  *)  input  wire         s003_defm_bid_rb            ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_start_prbc"  *)  input  wire  [9:0]  s003_defm_bid_start_prbc    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_num_prbc  "  *)  input  wire  [7:0]  s003_defm_bid_num_prbc      ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_num_symbol"  *)  input  wire  [3:0]  s003_defm_bid_num_symbol    ,
  (* X_INTERFACE_INFO = "xilinx.com:xroe_display:xroe_dl_xran_bidfwd_if_rtl:1.0 s003_defm_bid bid_cc_id     "  *)  input  wire  [7:0]  s003_defm_bid_cc_id         ,

  output  reg         bid_toggle=0               ,

  // Clocks
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_defm_aclk RST" *)
  input  wire         m_axis_defm_aresetn        ,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 m_axis_defm_aclk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF sink_data_000:sinkMon_000:sink_data_001:sinkMon_001:sink_data_002:sinkMon_002:sink_data_003:sinkMon_003" *)
  input  wire         m_axis_defm_aclk           ,

   (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_fram_aresetn RST" *)
  input  wire         s_axis_fram_aresetn        ,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axis_fram_aclk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF src_data_000:src_data_001:src_data_002:src_data_003:src_unsol_00:src_prach_00:s0_prach" *)
  input  wire         s_axis_fram_aclk           ,

  output  wire        fram_radio_start           ,
  output  wire        fram_radio_start_10ms      ,
  output  wire        defm_radio_start           ,
  output  wire        defm_radio_start_10ms      ,
(* KEEP = "true" *)
  output  wire        ant_radio_start_10ms       ,
   
  // General purpose tie off pins
  output reg          logic1=1                   ,
  output reg          logic0=0                   ,
  output reg [31:0]   logic0_32b=0               ,
  
  input wire [31:0]   setup_cnt                  ,
  input wire          cc_reloaded                ,
  
  // Put the radio in loopback mode. DEFM input fed straight to FRAM 
  input  wire         loopback_radio_data        ,

  // Pause control parameters. These are used to rate manage the data stream.
  // The example designs generally use the same clock rate, therefore a 
  // mechanism is required to rate manage the data to the avaiable ethernet
  // bandwidth.
  input  wire   [6:0] packet_data_size           ,
  input  wire   [6:0] pause_data_size            ,

  // Control packet generation mode. When IFG is 0 the generator operates
  // in time-domain constant streaming mode.
  input  wire  [15:0] data_ifg_clocks            ,
  input  wire  [15:0] data_pkt_size_bytes        ,
       
  input  wire  [15:0] ctrl0_ifg_clocks           ,
  input  wire  [15:0] ctrl0_pkt_size_bytes       ,

  output reg   [15:0] data_ifg_clocks_def      = 2  , // Min Supported IFG is 2
  output reg   [15:0] data_pkt_size_bytes_def  = 1024,
  output reg   [15:0] ctrl0_ifg_clocks_def     = 500,
  output reg   [15:0] ctrl0_pkt_size_bytes_def = 100,

  // Enable. 
  // Use to reset source/sink to known values when modifying packet configuration
  // They can also simply be tied to 1 for basic testbench operation.
  input  wire         radio_sink_enable          ,  
  input  wire         radio_source_enable        ,  
  
  // This signal is provided as an optional input so tready patterns can be
  // driven by external text logic. For normal operation it should simply be 
  // tied to 1'b1
  input  wire         radio_sink_drive_tready    , // Tie to one for normal operation
  output reg          pulse_train = 0            , // use to check tready function

  // Error/Status flags
  output wire [127:0] error_seen_reg             ,
  output wire [127:0] sink_status_reg            ,
  output wire         error_seen_led             ,
  output wire         sink_status_led            ,
  output reg          defm_ant0_active = 0       ,
  output wire         defm_ant0_active_axi       ,
   
  // AXI-Lite Control/Status   
  input  wire         s_axi_aclk                 ,
  input  wire         s_axi_aresetn              
  
);

//-----------------------------------------------------------------------------
// Declare internal signals
//-----------------------------------------------------------------------------
wire        loopback_radio_sync;
wire        radio_sink_enable_sync;
wire        radio_source_enable_sync;
reg  [3:0]  pulse_train_count=0;

wire [3:0] error_seen_bus;
wire [3:0] sink_status_bus;
wire [3:0] radio_pause;
wire [3:0] tlast_seen_bus;

wire [0:0] ctrl0_error_seen_bus;
wire [0:0] ctrl0_sink_status_bus;
wire [3:0] comb_error_seen_bus;
wire [3:0] comb_sink_status_bus;

assign comb_error_seen_bus	= error_seen_bus  | ctrl0_error_seen_bus;
assign comb_sink_status_bus	= sink_status_bus & ctrl0_sink_status_bus;

wire       ra000_data_pause;
wire       ra000_data_last;
wire [2:0] ra000_data_remd;

wire       ra001_data_pause;
wire       ra001_data_last;
wire [2:0] ra001_data_remd;

wire       ra002_data_pause;
wire       ra002_data_last;
wire [2:0] ra002_data_remd;

wire       ra003_data_pause;
wire       ra003_data_last;
wire [2:0] ra003_data_remd;

reg          sink_error_seen_i=0       ;
reg          sink_status_i=0           ;
reg    [3:0] defm_ant0_active_count=0  ;
reg          defm_ant0_active_ff;

//-----------------------------------------------------------------------------
// Stop BID's being stripped from design
//-----------------------------------------------------------------------------
reg       reg_s000_fram_bid_valid         ;
reg       reg_s000_fram_bid_beamid15      ;
reg       reg_s000_fram_bid_remask        ;
reg       reg_s000_fram_bid_rb            ;
reg       reg_s000_fram_bid_start_prbc    ;
reg       reg_s000_fram_bid_num_prbc      ;
reg       reg_s000_fram_bid_num_symbol    ;
reg       reg_s000_fram_bid_cc_id         ;
reg [7:0] reg_s000_fram_bid_bus           ;

reg       reg_s001_fram_bid_valid         ;
reg       reg_s001_fram_bid_beamid15      ;
reg       reg_s001_fram_bid_remask        ;
reg       reg_s001_fram_bid_rb            ;
reg       reg_s001_fram_bid_start_prbc    ;
reg       reg_s001_fram_bid_num_prbc      ;
reg       reg_s001_fram_bid_num_symbol    ;
reg       reg_s001_fram_bid_cc_id         ;
reg [7:0] reg_s001_fram_bid_bus           ;

reg       reg_s002_fram_bid_valid         ;
reg       reg_s002_fram_bid_beamid15      ;
reg       reg_s002_fram_bid_remask        ;
reg       reg_s002_fram_bid_rb            ;
reg       reg_s002_fram_bid_start_prbc    ;
reg       reg_s002_fram_bid_num_prbc      ;
reg       reg_s002_fram_bid_num_symbol    ;
reg       reg_s002_fram_bid_cc_id         ;
reg [7:0] reg_s002_fram_bid_bus           ;

reg       reg_s003_fram_bid_valid         ;
reg       reg_s003_fram_bid_beamid15      ;
reg       reg_s003_fram_bid_remask        ;
reg       reg_s003_fram_bid_rb            ;
reg       reg_s003_fram_bid_start_prbc    ;
reg       reg_s003_fram_bid_num_prbc      ;
reg       reg_s003_fram_bid_num_symbol    ;
reg       reg_s003_fram_bid_cc_id         ;
reg [7:0] reg_s003_fram_bid_bus           ;

reg       reg_s000_defm_bid_valid         ;
reg       reg_s000_defm_bid_beamid15      ;
reg       reg_s000_defm_bid_remask        ;
reg       reg_s000_defm_bid_rb            ;
reg       reg_s000_defm_bid_start_prbc    ;
reg       reg_s000_defm_bid_num_prbc      ;
reg       reg_s000_defm_bid_num_symbol    ;
reg       reg_s000_defm_bid_cc_id         ;
reg [7:0] reg_s000_defm_bid_bus           ;

reg       reg_s001_defm_bid_valid         ;
reg       reg_s001_defm_bid_beamid15      ;
reg       reg_s001_defm_bid_remask        ;
reg       reg_s001_defm_bid_rb            ;
reg       reg_s001_defm_bid_start_prbc    ;
reg       reg_s001_defm_bid_num_prbc      ;
reg       reg_s001_defm_bid_num_symbol    ;
reg       reg_s001_defm_bid_cc_id         ;
reg [7:0] reg_s001_defm_bid_bus           ;

reg       reg_s002_defm_bid_valid         ;
reg       reg_s002_defm_bid_beamid15      ;
reg       reg_s002_defm_bid_remask        ;
reg       reg_s002_defm_bid_rb            ;
reg       reg_s002_defm_bid_start_prbc    ;
reg       reg_s002_defm_bid_num_prbc      ;
reg       reg_s002_defm_bid_num_symbol    ;
reg       reg_s002_defm_bid_cc_id         ;
reg [7:0] reg_s002_defm_bid_bus           ;

reg       reg_s003_defm_bid_valid         ;
reg       reg_s003_defm_bid_beamid15      ;
reg       reg_s003_defm_bid_remask        ;
reg       reg_s003_defm_bid_rb            ;
reg       reg_s003_defm_bid_start_prbc    ;
reg       reg_s003_defm_bid_num_prbc      ;
reg       reg_s003_defm_bid_num_symbol    ;
reg       reg_s003_defm_bid_cc_id         ;
reg [7:0] reg_s003_defm_bid_bus           ;

reg [3:0] reg_fram_bid_bus=0;
reg [3:0] reg_defm_bid_bus=0;

reg   [7:0] s0_tlast_counter  = 0; // Count tlasts
wire        s0_tlast_seen        ;
reg         s0_tlast_match    = 0; // Count tlasts

reg  [3 :0] r0_prach_cc               =0;
reg  [7 :0] r0_prach_ss               =0;
reg  [11:0] r0_prach_section_id       =0;
reg  [7 :0] r0_prach_udcomphdr        =0;
reg  [9 :0] r0_prach_start_prbc       =0;
reg  [7 :0] r0_prach_num_prbc         =0;
reg         r0_prach_tvalid           =0;

reg         b0_prach_cc               =0;
reg         b0_prach_ss               =0;
reg         b0_prach_section_id       =0;
reg         b0_prach_udcomphdr        =0;
reg         b0_prach_start_prbc       =0;
reg         b0_prach_num_prbc         =0;

reg         prach_toggle              =0;

//-----------------------------------------------------------------------------
// Register some PRACH signals
//-----------------------------------------------------------------------------
always @(posedge s_axis_fram_aclk) begin

  r0_prach_cc         <= s0_prach_cc         ;
  r0_prach_ss         <= s0_prach_ss         ;
  r0_prach_section_id <= s0_prach_section_id ;
  r0_prach_udcomphdr  <= s0_prach_udcomphdr  ;
  r0_prach_start_prbc <= s0_prach_start_prbc ;
  r0_prach_num_prbc   <= s0_prach_num_prbc   ;
  r0_prach_tvalid     <= s0_prach_tvalid     ;

  b0_prach_cc         <= |r0_prach_cc        ;
  b0_prach_ss         <= |r0_prach_ss        ;
  b0_prach_section_id <= |r0_prach_section_id;
  b0_prach_udcomphdr  <= |r0_prach_udcomphdr ;
  b0_prach_start_prbc <= |r0_prach_start_prbc;
  b0_prach_num_prbc   <= |r0_prach_num_prbc  ;

  // Final output
  prach_toggle        <= b0_prach_cc         | 
                         b0_prach_ss         | 
                         b0_prach_section_id | 
                         b0_prach_udcomphdr  | 
                         b0_prach_start_prbc | 
                         b0_prach_num_prbc   ;
end

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
ul_prach_gen #(
  .C_PRACH_SECTION_DEPTH (8)
) gen_i (

   .m_fram_prach_tdata    (m00_fram_prach_tdata ),
   .m_fram_prach_tkeep    (m00_fram_prach_tkeep ),
   .m_fram_prach_tvalid   (m00_fram_prach_tvalid),
   .m_fram_prach_tlast    (m00_fram_prach_tlast ),
   .m_fram_prach_tuser    (m00_fram_prach_tuser ),
   .m_fram_prach_tready   (m00_fram_prach_tready),

   .s_prach_tready        (                     ),
   .s_prach_tvalid        (r0_prach_tvalid      ),
   .s_prach_section_id    (r0_prach_section_id  ),
   .s_prach_udcomphdr     (r0_prach_udcomphdr   ),
   .s_prach_ss            (r0_prach_ss          ),
   .s_prach_cc            (r0_prach_cc          ),
   .s_prach_num_prbc      (r0_prach_num_prbc    ),

   .clk                   (s_axis_fram_aclk     ),
   .resetn                (m_axis_defm_aresetn  )
);

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
always @(posedge s_axis_fram_aclk) begin
  reg_s000_fram_bid_valid       <= |s000_fram_bid_valid        ;
  reg_s000_fram_bid_beamid15    <= |s000_fram_bid_beamid15     ;
  reg_s000_fram_bid_remask      <= |s000_fram_bid_remask       ;
  reg_s000_fram_bid_rb          <= |s000_fram_bid_rb           ;
  reg_s000_fram_bid_start_prbc  <= |s000_fram_bid_start_prbc   ;
  reg_s000_fram_bid_num_prbc    <= |s000_fram_bid_num_prbc     ;
  reg_s000_fram_bid_num_symbol  <= |s000_fram_bid_num_symbol   ;
  reg_s000_fram_bid_cc_id       <= |s000_fram_bid_cc_id        ;
  reg_s000_fram_bid_bus[0]      <= reg_s000_fram_bid_valid     ;
  reg_s000_fram_bid_bus[1]      <= reg_s000_fram_bid_beamid15  ;
  reg_s000_fram_bid_bus[2]      <= reg_s000_fram_bid_remask    ;
  reg_s000_fram_bid_bus[3]      <= reg_s000_fram_bid_rb        ;
  reg_s000_fram_bid_bus[4]      <= reg_s000_fram_bid_start_prbc;
  reg_s000_fram_bid_bus[5]      <= reg_s000_fram_bid_num_prbc  ;
  reg_s000_fram_bid_bus[6]      <= reg_s000_fram_bid_num_symbol;
  reg_s000_fram_bid_bus[7]      <= reg_s000_fram_bid_cc_id     ;

  reg_fram_bid_bus[000]         <= |reg_s000_fram_bid_bus;

  reg_s001_fram_bid_valid       <= |s001_fram_bid_valid        ;
  reg_s001_fram_bid_beamid15    <= |s001_fram_bid_beamid15     ;
  reg_s001_fram_bid_remask      <= |s001_fram_bid_remask       ;
  reg_s001_fram_bid_rb          <= |s001_fram_bid_rb           ;
  reg_s001_fram_bid_start_prbc  <= |s001_fram_bid_start_prbc   ;
  reg_s001_fram_bid_num_prbc    <= |s001_fram_bid_num_prbc     ;
  reg_s001_fram_bid_num_symbol  <= |s001_fram_bid_num_symbol   ;
  reg_s001_fram_bid_cc_id       <= |s001_fram_bid_cc_id        ;
  reg_s001_fram_bid_bus[0]      <= reg_s001_fram_bid_valid     ;
  reg_s001_fram_bid_bus[1]      <= reg_s001_fram_bid_beamid15  ;
  reg_s001_fram_bid_bus[2]      <= reg_s001_fram_bid_remask    ;
  reg_s001_fram_bid_bus[3]      <= reg_s001_fram_bid_rb        ;
  reg_s001_fram_bid_bus[4]      <= reg_s001_fram_bid_start_prbc;
  reg_s001_fram_bid_bus[5]      <= reg_s001_fram_bid_num_prbc  ;
  reg_s001_fram_bid_bus[6]      <= reg_s001_fram_bid_num_symbol;
  reg_s001_fram_bid_bus[7]      <= reg_s001_fram_bid_cc_id     ;

  reg_fram_bid_bus[001]         <= |reg_s001_fram_bid_bus;

  reg_s002_fram_bid_valid       <= |s002_fram_bid_valid        ;
  reg_s002_fram_bid_beamid15    <= |s002_fram_bid_beamid15     ;
  reg_s002_fram_bid_remask      <= |s002_fram_bid_remask       ;
  reg_s002_fram_bid_rb          <= |s002_fram_bid_rb           ;
  reg_s002_fram_bid_start_prbc  <= |s002_fram_bid_start_prbc   ;
  reg_s002_fram_bid_num_prbc    <= |s002_fram_bid_num_prbc     ;
  reg_s002_fram_bid_num_symbol  <= |s002_fram_bid_num_symbol   ;
  reg_s002_fram_bid_cc_id       <= |s002_fram_bid_cc_id        ;
  reg_s002_fram_bid_bus[0]      <= reg_s002_fram_bid_valid     ;
  reg_s002_fram_bid_bus[1]      <= reg_s002_fram_bid_beamid15  ;
  reg_s002_fram_bid_bus[2]      <= reg_s002_fram_bid_remask    ;
  reg_s002_fram_bid_bus[3]      <= reg_s002_fram_bid_rb        ;
  reg_s002_fram_bid_bus[4]      <= reg_s002_fram_bid_start_prbc;
  reg_s002_fram_bid_bus[5]      <= reg_s002_fram_bid_num_prbc  ;
  reg_s002_fram_bid_bus[6]      <= reg_s002_fram_bid_num_symbol;
  reg_s002_fram_bid_bus[7]      <= reg_s002_fram_bid_cc_id     ;

  reg_fram_bid_bus[002]         <= |reg_s002_fram_bid_bus;

  reg_s003_fram_bid_valid       <= |s003_fram_bid_valid        ;
  reg_s003_fram_bid_beamid15    <= |s003_fram_bid_beamid15     ;
  reg_s003_fram_bid_remask      <= |s003_fram_bid_remask       ;
  reg_s003_fram_bid_rb          <= |s003_fram_bid_rb           ;
  reg_s003_fram_bid_start_prbc  <= |s003_fram_bid_start_prbc   ;
  reg_s003_fram_bid_num_prbc    <= |s003_fram_bid_num_prbc     ;
  reg_s003_fram_bid_num_symbol  <= |s003_fram_bid_num_symbol   ;
  reg_s003_fram_bid_cc_id       <= |s003_fram_bid_cc_id        ;
  reg_s003_fram_bid_bus[0]      <= reg_s003_fram_bid_valid     ;
  reg_s003_fram_bid_bus[1]      <= reg_s003_fram_bid_beamid15  ;
  reg_s003_fram_bid_bus[2]      <= reg_s003_fram_bid_remask    ;
  reg_s003_fram_bid_bus[3]      <= reg_s003_fram_bid_rb        ;
  reg_s003_fram_bid_bus[4]      <= reg_s003_fram_bid_start_prbc;
  reg_s003_fram_bid_bus[5]      <= reg_s003_fram_bid_num_prbc  ;
  reg_s003_fram_bid_bus[6]      <= reg_s003_fram_bid_num_symbol;
  reg_s003_fram_bid_bus[7]      <= reg_s003_fram_bid_cc_id     ;

  reg_fram_bid_bus[003]         <= |reg_s003_fram_bid_bus;

  reg_s000_defm_bid_valid       <= |s000_defm_bid_valid        ;
  reg_s000_defm_bid_beamid15    <= |s000_defm_bid_beamid15     ;
  reg_s000_defm_bid_remask      <= |s000_defm_bid_remask       ;
  reg_s000_defm_bid_rb          <= |s000_defm_bid_rb           ;
  reg_s000_defm_bid_start_prbc  <= |s000_defm_bid_start_prbc   ;
  reg_s000_defm_bid_num_prbc    <= |s000_defm_bid_num_prbc     ;
  reg_s000_defm_bid_num_symbol  <= |s000_defm_bid_num_symbol   ;
  reg_s000_defm_bid_cc_id       <= |s000_defm_bid_cc_id        ;
  reg_s000_defm_bid_bus[0]      <= reg_s000_defm_bid_valid     ;
  reg_s000_defm_bid_bus[1]      <= reg_s000_defm_bid_beamid15  ;
  reg_s000_defm_bid_bus[2]      <= reg_s000_defm_bid_remask    ;
  reg_s000_defm_bid_bus[3]      <= reg_s000_defm_bid_rb        ;
  reg_s000_defm_bid_bus[4]      <= reg_s000_defm_bid_start_prbc;
  reg_s000_defm_bid_bus[5]      <= reg_s000_defm_bid_num_prbc  ;
  reg_s000_defm_bid_bus[6]      <= reg_s000_defm_bid_num_symbol;
  reg_s000_defm_bid_bus[7]      <= reg_s000_defm_bid_cc_id     ;

  reg_defm_bid_bus[000]         <= |reg_s000_defm_bid_bus;

  reg_s001_defm_bid_valid       <= |s001_defm_bid_valid        ;
  reg_s001_defm_bid_beamid15    <= |s001_defm_bid_beamid15     ;
  reg_s001_defm_bid_remask      <= |s001_defm_bid_remask       ;
  reg_s001_defm_bid_rb          <= |s001_defm_bid_rb           ;
  reg_s001_defm_bid_start_prbc  <= |s001_defm_bid_start_prbc   ;
  reg_s001_defm_bid_num_prbc    <= |s001_defm_bid_num_prbc     ;
  reg_s001_defm_bid_num_symbol  <= |s001_defm_bid_num_symbol   ;
  reg_s001_defm_bid_cc_id       <= |s001_defm_bid_cc_id        ;
  reg_s001_defm_bid_bus[0]      <= reg_s001_defm_bid_valid     ;
  reg_s001_defm_bid_bus[1]      <= reg_s001_defm_bid_beamid15  ;
  reg_s001_defm_bid_bus[2]      <= reg_s001_defm_bid_remask    ;
  reg_s001_defm_bid_bus[3]      <= reg_s001_defm_bid_rb        ;
  reg_s001_defm_bid_bus[4]      <= reg_s001_defm_bid_start_prbc;
  reg_s001_defm_bid_bus[5]      <= reg_s001_defm_bid_num_prbc  ;
  reg_s001_defm_bid_bus[6]      <= reg_s001_defm_bid_num_symbol;
  reg_s001_defm_bid_bus[7]      <= reg_s001_defm_bid_cc_id     ;

  reg_defm_bid_bus[001]         <= |reg_s001_defm_bid_bus;

  reg_s002_defm_bid_valid       <= |s002_defm_bid_valid        ;
  reg_s002_defm_bid_beamid15    <= |s002_defm_bid_beamid15     ;
  reg_s002_defm_bid_remask      <= |s002_defm_bid_remask       ;
  reg_s002_defm_bid_rb          <= |s002_defm_bid_rb           ;
  reg_s002_defm_bid_start_prbc  <= |s002_defm_bid_start_prbc   ;
  reg_s002_defm_bid_num_prbc    <= |s002_defm_bid_num_prbc     ;
  reg_s002_defm_bid_num_symbol  <= |s002_defm_bid_num_symbol   ;
  reg_s002_defm_bid_cc_id       <= |s002_defm_bid_cc_id        ;
  reg_s002_defm_bid_bus[0]      <= reg_s002_defm_bid_valid     ;
  reg_s002_defm_bid_bus[1]      <= reg_s002_defm_bid_beamid15  ;
  reg_s002_defm_bid_bus[2]      <= reg_s002_defm_bid_remask    ;
  reg_s002_defm_bid_bus[3]      <= reg_s002_defm_bid_rb        ;
  reg_s002_defm_bid_bus[4]      <= reg_s002_defm_bid_start_prbc;
  reg_s002_defm_bid_bus[5]      <= reg_s002_defm_bid_num_prbc  ;
  reg_s002_defm_bid_bus[6]      <= reg_s002_defm_bid_num_symbol;
  reg_s002_defm_bid_bus[7]      <= reg_s002_defm_bid_cc_id     ;

  reg_defm_bid_bus[002]         <= |reg_s002_defm_bid_bus;

  reg_s003_defm_bid_valid       <= |s003_defm_bid_valid        ;
  reg_s003_defm_bid_beamid15    <= |s003_defm_bid_beamid15     ;
  reg_s003_defm_bid_remask      <= |s003_defm_bid_remask       ;
  reg_s003_defm_bid_rb          <= |s003_defm_bid_rb           ;
  reg_s003_defm_bid_start_prbc  <= |s003_defm_bid_start_prbc   ;
  reg_s003_defm_bid_num_prbc    <= |s003_defm_bid_num_prbc     ;
  reg_s003_defm_bid_num_symbol  <= |s003_defm_bid_num_symbol   ;
  reg_s003_defm_bid_cc_id       <= |s003_defm_bid_cc_id        ;
  reg_s003_defm_bid_bus[0]      <= reg_s003_defm_bid_valid     ;
  reg_s003_defm_bid_bus[1]      <= reg_s003_defm_bid_beamid15  ;
  reg_s003_defm_bid_bus[2]      <= reg_s003_defm_bid_remask    ;
  reg_s003_defm_bid_bus[3]      <= reg_s003_defm_bid_rb        ;
  reg_s003_defm_bid_bus[4]      <= reg_s003_defm_bid_start_prbc;
  reg_s003_defm_bid_bus[5]      <= reg_s003_defm_bid_num_prbc  ;
  reg_s003_defm_bid_bus[6]      <= reg_s003_defm_bid_num_symbol;
  reg_s003_defm_bid_bus[7]      <= reg_s003_defm_bid_cc_id     ;

  reg_defm_bid_bus[003]         <= |reg_s003_defm_bid_bus;

   // Final output
   bid_toggle                         <= (|reg_fram_bid_bus) | (|reg_defm_bid_bus) | prach_toggle;
end

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
radio_start_gen #(
   .NO_OF_CLOCKS_FOR_1MS (NO_OF_CLOCKS_FOR_1MS)
) fram_srf_i (
  .setup_cnt        (setup_cnt + `ul_skew   ),
  .cc_reloaded      (cc_reloaded           ),
  .resetn           (s_axis_fram_aresetn   ),
  .clk              (s_axis_fram_aclk      ),
  .radio_start      (fram_radio_start      ),
  .radio_start_10ms (fram_radio_start_10ms )
);

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
radio_start_gen #(
   .NO_OF_CLOCKS_FOR_1MS (NO_OF_CLOCKS_FOR_1MS)
) defm_srf_i (
  .setup_cnt        (setup_cnt - `dl_skew   ),
  .cc_reloaded      (cc_reloaded           ),
  .resetn           (m_axis_defm_aresetn   ),
  .clk              (m_axis_defm_aclk      ),
  .radio_start      (defm_radio_start      ),
  .radio_start_10ms (defm_radio_start_10ms )
);

radio_start_gen #(
   .NO_OF_CLOCKS_FOR_1MS (NO_OF_CLOCKS_FOR_1MS)
) ant_srf_i (
  .setup_cnt        (setup_cnt             ),
  .cc_reloaded      (cc_reloaded           ),
  .resetn           (m_axis_defm_aresetn   ),
  .clk              (m_axis_defm_aclk      ),
  .radio_start      (                      ),
  .radio_start_10ms (ant_radio_start_10ms  )
);

//-----------------------------------------------------------------------------
// Strobe CDC logic
// XPM's constraints are added sutomatically by Vivado, so these paths 
// are easier to conststrain.
//-----------------------------------------------------------------------------
xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_loopback_i                ( .src_clk(), .src_in (loopback_radio_data),  .dest_clk (s_axis_fram_aclk), .dest_out (loopback_radio_sync     ) );
xpm_cdc_single #( .SRC_INPUT_REG (1) ) xpm_cdc_radio_source_enable_sync_i( .src_clk(s_axi_aclk), .src_in (radio_source_enable),  .dest_clk (s_axis_fram_aclk), .dest_out (radio_source_enable_sync) );
xpm_cdc_single #( .SRC_INPUT_REG (1) ) xpm_cdc_radio_sink_enable_sync_i  ( .src_clk(s_axi_aclk), .src_in (radio_sink_enable),    .dest_clk (m_axis_defm_aclk), .dest_out (radio_sink_enable_sync  ) );

//-----------------------------------------------------------------------------
// No loopback multiplexer on ORAN 
//-----------------------------------------------------------------------------
wire [63:0] m000_fram_dint_tdata ;
wire  [7:0] m000_fram_dint_tkeep ;
wire        m000_fram_dint_tvalid;
wire        m000_fram_dint_tlast ;

assign m000_fram_data_tdata = m000_fram_dint_tdata;
assign m000_fram_data_tkeep = m000_fram_dint_tkeep; 
assign m000_fram_data_tvalid= m000_fram_dint_tvalid;
assign m000_fram_data_tlast = m000_fram_dint_tlast; 
wire [63:0] m001_fram_dint_tdata ;
wire  [7:0] m001_fram_dint_tkeep ;
wire        m001_fram_dint_tvalid;
wire        m001_fram_dint_tlast ;

assign m001_fram_data_tdata = m001_fram_dint_tdata;
assign m001_fram_data_tkeep = m001_fram_dint_tkeep; 
assign m001_fram_data_tvalid= m001_fram_dint_tvalid;
assign m001_fram_data_tlast = m001_fram_dint_tlast; 
wire [63:0] m002_fram_dint_tdata ;
wire  [7:0] m002_fram_dint_tkeep ;
wire        m002_fram_dint_tvalid;
wire        m002_fram_dint_tlast ;

assign m002_fram_data_tdata = m002_fram_dint_tdata;
assign m002_fram_data_tkeep = m002_fram_dint_tkeep; 
assign m002_fram_data_tvalid= m002_fram_dint_tvalid;
assign m002_fram_data_tlast = m002_fram_dint_tlast; 
wire [63:0] m003_fram_dint_tdata ;
wire  [7:0] m003_fram_dint_tkeep ;
wire        m003_fram_dint_tvalid;
wire        m003_fram_dint_tlast ;

assign m003_fram_data_tdata = m003_fram_dint_tdata;
assign m003_fram_data_tkeep = m003_fram_dint_tkeep; 
assign m003_fram_data_tvalid= m003_fram_dint_tvalid;
assign m003_fram_data_tlast = m003_fram_dint_tlast; 

//-----------------------------------------------------------------------------
// Assign debug/monitor ports
//-----------------------------------------------------------------------------
assign s000_defm_data_tdata_mon  = s000_defm_data_tdata;
assign s000_defm_data_tkeep_mon  = s000_defm_data_tkeep;
assign s000_defm_data_tlast_mon  = s000_defm_data_tlast;
assign s000_defm_data_tuser_mon  = s000_defm_data_tuser;
assign s000_defm_data_tvalid_mon = s000_defm_data_tvalid & s000_defm_data_tready;

assign s001_defm_data_tdata_mon  = s001_defm_data_tdata;
assign s001_defm_data_tkeep_mon  = s001_defm_data_tkeep;
assign s001_defm_data_tlast_mon  = s001_defm_data_tlast;
assign s001_defm_data_tuser_mon  = s001_defm_data_tuser;
assign s001_defm_data_tvalid_mon = s001_defm_data_tvalid & s001_defm_data_tready;

assign s002_defm_data_tdata_mon  = s002_defm_data_tdata;
assign s002_defm_data_tkeep_mon  = s002_defm_data_tkeep;
assign s002_defm_data_tlast_mon  = s002_defm_data_tlast;
assign s002_defm_data_tuser_mon  = s002_defm_data_tuser;
assign s002_defm_data_tvalid_mon = s002_defm_data_tvalid & s002_defm_data_tready;

assign s003_defm_data_tdata_mon  = s003_defm_data_tdata;
assign s003_defm_data_tkeep_mon  = s003_defm_data_tkeep;
assign s003_defm_data_tlast_mon  = s003_defm_data_tlast;
assign s003_defm_data_tuser_mon  = s003_defm_data_tuser;
assign s003_defm_data_tvalid_mon = s003_defm_data_tvalid & s003_defm_data_tready;

  parameter	C_FRAM_FD_EN	= 1;

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
   // CARRIER and RTC ports for the Framer, the datapath to the ethernet
// Data Stream
oran_radio_if_0_ba_radio_source rsource_data_0(
   .m_src_tdata             (m000_fram_dint_tdata       ),
   .m_src_tkeep             (m000_fram_dint_tkeep       ),
   .m_src_tvalid            (m000_fram_dint_tvalid      ),
   .m_src_tlast             (m000_fram_dint_tlast       ),
   .m_src_tready            (m000_fram_data_tready      ),
   .m_src_tuser             (m000_fram_data_req         ),

   .slot                    (8'd000   ),
   .ifg_clocks_minus1    	  (data_ifg_clocks          ),
   .pkt_size_bytes	        (data_pkt_size_bytes      ),
   .radio_source_enable     (radio_source_enable_sync   ),

   .m_src_aresetn           (s_axis_fram_aresetn        ),   
   .m_src_aclk              (s_axis_fram_aclk           ),
   .fram_radio_start        (),
   .defm_radio_start        ()
);

// Data Stream
oran_radio_if_0_ba_radio_source rsource_data_1(
   .m_src_tdata             (m001_fram_dint_tdata       ),
   .m_src_tkeep             (m001_fram_dint_tkeep       ),
   .m_src_tvalid            (m001_fram_dint_tvalid      ),
   .m_src_tlast             (m001_fram_dint_tlast       ),
   .m_src_tready            (m001_fram_data_tready      ),
   .m_src_tuser             (m001_fram_data_req         ),

   .slot                    (8'd001   ),
   .ifg_clocks_minus1    	  (data_ifg_clocks          ),
   .pkt_size_bytes	        (data_pkt_size_bytes      ),
   .radio_source_enable     (radio_source_enable_sync   ),

   .m_src_aresetn           (s_axis_fram_aresetn        ),   
   .m_src_aclk              (s_axis_fram_aclk           ),
   .fram_radio_start        (),
   .defm_radio_start        ()
);

// Data Stream
oran_radio_if_0_ba_radio_source rsource_data_2(
   .m_src_tdata             (m002_fram_dint_tdata       ),
   .m_src_tkeep             (m002_fram_dint_tkeep       ),
   .m_src_tvalid            (m002_fram_dint_tvalid      ),
   .m_src_tlast             (m002_fram_dint_tlast       ),
   .m_src_tready            (m002_fram_data_tready      ),
   .m_src_tuser             (m002_fram_data_req         ),

   .slot                    (8'd002   ),
   .ifg_clocks_minus1    	  (data_ifg_clocks          ),
   .pkt_size_bytes	        (data_pkt_size_bytes      ),
   .radio_source_enable     (radio_source_enable_sync   ),

   .m_src_aresetn           (s_axis_fram_aresetn        ),   
   .m_src_aclk              (s_axis_fram_aclk           ),
   .fram_radio_start        (),
   .defm_radio_start        ()
);

// Data Stream
oran_radio_if_0_ba_radio_source rsource_data_3(
   .m_src_tdata             (m003_fram_dint_tdata       ),
   .m_src_tkeep             (m003_fram_dint_tkeep       ),
   .m_src_tvalid            (m003_fram_dint_tvalid      ),
   .m_src_tlast             (m003_fram_dint_tlast       ),
   .m_src_tready            (m003_fram_data_tready      ),
   .m_src_tuser             (m003_fram_data_req         ),

   .slot                    (8'd003   ),
   .ifg_clocks_minus1    	  (data_ifg_clocks          ),
   .pkt_size_bytes	        (data_pkt_size_bytes      ),
   .radio_source_enable     (radio_source_enable_sync   ),

   .m_src_aresetn           (s_axis_fram_aresetn        ),   
   .m_src_aclk              (s_axis_fram_aclk           ),
   .fram_radio_start        (),
   .defm_radio_start        ()
);

//-----------------------------------------------------------------------------
// Generate a pulse train when valid data is being seen on antenna pin 0.
// This can be used outside the block to control the test length.
// We create a div16 version to pass across to the axi clock domain. This
// means if this pin is routed to an external pin (LED for example) the timing
// is likely to be in the 100MHz region. Antenna clock can ragne from 1-500MHz
//-----------------------------------------------------------------------------
always @(posedge m_axis_defm_aclk) begin
   if (defm_ant0_active_count=='hf)
	  defm_ant0_active_ff	 <= 1'b1;
   else
	  defm_ant0_active_ff	 <= 1'b0;
   if (~m_axis_defm_aresetn) begin
      defm_ant0_active       <= 'd0;
      defm_ant0_active_count <= 'd0;
   end else begin
      // We always generate this signal of the antenna 0 Data traffic. It
      // can be used at a higher level, based on configuration is a test
      // has run for long enough. No attempt us made to monitor the CTRL
      // ports.
      if (s000_defm_data_tready & s000_defm_data_tvalid) begin
         defm_ant0_active_count <= defm_ant0_active_count + 'd1;
         defm_ant0_active       <= ~defm_ant0_active;
      end
   end
end

xpm_cdc_single #( .SRC_INPUT_REG (1) ) xpm_cdc_sink_ant0_active_i ( 
  .src_clk  (m_axis_defm_aclk), 
  .src_in   (defm_ant0_active_ff), 
  .dest_clk (s_axi_aclk), 
  .dest_out (defm_ant0_active_axi) );

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
   // CARRIER and RTC ports for the De-Framer, the datapath from the ethernet
oran_radio_if_0_ba_radio_sink  rsink_data0	(
   .s_sink_tdata            (s000_defm_data_tdata       ),
   .s_sink_tkeep            (s000_defm_data_tkeep       ),
   .s_sink_tvalid           (s000_defm_data_tvalid      ),
   .s_sink_tlast            (s000_defm_data_tlast       ),
   .s_sink_tready           (      ),
   .s_sink_tuser            (s000_defm_data_tuser       ),
     
   // Status and config     
   .slot                    (8'd000),
   .status                  (sink_status_bus[0]),
   .error_seen              (error_seen_bus[0] ),
   .tlast_seen              (tlast_seen_bus[0] ),
   .data_error_count        (),
   .radio_sink_enable       (radio_sink_enable_sync     ),
   .radio_sink_drive_tready (radio_sink_drive_tready    ),

   // Clocks
   .s_sink_aresetn          (m_axis_defm_aresetn        ),
   .s_sink_aclk             (m_axis_defm_aclk           )

);

oran_radio_if_0_ba_radio_sink  rsink_data1	(
   .s_sink_tdata            (s001_defm_data_tdata       ),
   .s_sink_tkeep            (s001_defm_data_tkeep       ),
   .s_sink_tvalid           (s001_defm_data_tvalid      ),
   .s_sink_tlast            (s001_defm_data_tlast       ),
   .s_sink_tready           (      ),
   .s_sink_tuser            (s001_defm_data_tuser       ),
     
   // Status and config     
   .slot                    (8'd001),
   .status                  (sink_status_bus[1]),
   .error_seen              (error_seen_bus[1] ),
   .tlast_seen              (tlast_seen_bus[1] ),
   .data_error_count        (),
   .radio_sink_enable       (radio_sink_enable_sync     ),
   .radio_sink_drive_tready (radio_sink_drive_tready    ),

   // Clocks
   .s_sink_aresetn          (m_axis_defm_aresetn        ),
   .s_sink_aclk             (m_axis_defm_aclk           )

);

oran_radio_if_0_ba_radio_sink  rsink_data2	(
   .s_sink_tdata            (s002_defm_data_tdata       ),
   .s_sink_tkeep            (s002_defm_data_tkeep       ),
   .s_sink_tvalid           (s002_defm_data_tvalid      ),
   .s_sink_tlast            (s002_defm_data_tlast       ),
   .s_sink_tready           (      ),
   .s_sink_tuser            (s002_defm_data_tuser       ),
     
   // Status and config     
   .slot                    (8'd002),
   .status                  (sink_status_bus[2]),
   .error_seen              (error_seen_bus[2] ),
   .tlast_seen              (tlast_seen_bus[2] ),
   .data_error_count        (),
   .radio_sink_enable       (radio_sink_enable_sync     ),
   .radio_sink_drive_tready (radio_sink_drive_tready    ),

   // Clocks
   .s_sink_aresetn          (m_axis_defm_aresetn        ),
   .s_sink_aclk             (m_axis_defm_aclk           )

);

oran_radio_if_0_ba_radio_sink  rsink_data3	(
   .s_sink_tdata            (s003_defm_data_tdata       ),
   .s_sink_tkeep            (s003_defm_data_tkeep       ),
   .s_sink_tvalid           (s003_defm_data_tvalid      ),
   .s_sink_tlast            (s003_defm_data_tlast       ),
   .s_sink_tready           (      ),
   .s_sink_tuser            (s003_defm_data_tuser       ),
     
   // Status and config     
   .slot                    (8'd003),
   .status                  (sink_status_bus[3]),
   .error_seen              (error_seen_bus[3] ),
   .tlast_seen              (tlast_seen_bus[3] ),
   .data_error_count        (),
   .radio_sink_enable       (radio_sink_enable_sync     ),
   .radio_sink_drive_tready (radio_sink_drive_tready    ),

   // Clocks
   .s_sink_aresetn          (m_axis_defm_aresetn        ),
   .s_sink_aclk             (m_axis_defm_aclk           )

);

//-----------------------------------------------------------------------------
// Deframer status logic
// Re-time to the AXI4-Lite clock domain. Add this logic here so eases 
// integration in the example design.
//-----------------------------------------------------------------------------
always @(posedge m_axis_defm_aclk) begin
   if (~m_axis_defm_aresetn) begin
      sink_error_seen_i <= 1'd0;
      sink_status_i     <= 1'd0;
      s0_tlast_counter  <= 'd0;
      s0_tlast_match    <= 'd0;
   end else begin
      sink_error_seen_i <= (|error_seen_bus );
      //sink_status_i     <= (|sink_status_bus) ;
      if (tlast_seen_bus[0]) 
        s0_tlast_counter  <= s0_tlast_counter + 'd1;
      s0_tlast_match    <= (s0_tlast_counter == 'd140);
      sink_status_i     <= s0_tlast_match ;
   end
end

xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_sink_error_seen_i ( .src_clk(), .src_in (sink_error_seen_i), .dest_clk (s_axi_aclk), .dest_out (error_seen_led ) );
xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_sink_status_i     ( .src_clk(), .src_in (sink_status_i    ), .dest_clk (s_axi_aclk), .dest_out (sink_status_led) );

xpm_cdc_array_single #( 
    .SRC_INPUT_REG      (1),
    .WIDTH              (4)
) xpm_cdc_error_inst    (
    .src_clk            (m_axis_defm_aclk),
    .src_in             (comb_error_seen_bus),
    .dest_clk           (s_axi_aclk),
    .dest_out           (error_seen_reg[3:0])
);

xpm_cdc_array_single #( 
    .SRC_INPUT_REG      (1),
    .WIDTH              (4)
) xpm_cdc_status_inst   (
    .src_clk            (m_axis_defm_aclk),
    .src_in             (comb_sink_status_bus),
    .dest_clk           (s_axi_aclk),
    .dest_out           (sink_status_reg[3:0])
);


assign error_seen_reg[127:4]  = 'd0;
assign sink_status_reg[127:4] = 'd0;

//-----------------------------------------------------------------------------
// Generate pulse train that can be used to check tready behaviour
//-----------------------------------------------------------------------------
always @(posedge m_axis_defm_aclk) begin
  pulse_train <= 1'd0; 
  if(pulse_train_count == 0) begin
    pulse_train_count <= 'd1; 
    pulse_train       <= 1'd1; 
  end else begin
    pulse_train_count <= pulse_train_count - 'd1; 
  end
end

endmodule

//-----------------------------------------------------------------------------
// Strobe generator block
//-----------------------------------------------------------------------------
module radio_start_gen  #(
   parameter NO_OF_CLOCKS_FOR_1MS = 'd399616
) (
  input  wire [31:0]   setup_cnt           ,
  input  wire          cc_reloaded         ,
  input  wire          resetn              ,
  input  wire          clk                 ,
  output reg           radio_start      = 0,
  output reg           radio_start_10ms = 0
);

//-----------------------------------------------------------------------------
// Sized to deal with a max antenna rate of 500MHz
//-----------------------------------------------------------------------------
reg   [23:0] radio_counter    = {24{1'd1}}; //;
reg          firstd           = 1'b1;
reg    [3:0] radio_counter_10 = 0;          // allow 1ms strobe before 
                                            // the first 10ms strobe;

reg [23:0]   setup_cnt_r         ;
reg          setup_cnt_not_zero=0;
reg          cc_reloaded_r0    =0;
reg          cc_reloaded_r1    =0;
reg          cc_reloaded_r2    =0;

always @(posedge clk) begin
  setup_cnt_r <= setup_cnt[23:0];
  setup_cnt_not_zero <= (setup_cnt_r != 'd0);
  cc_reloaded_r0 <= cc_reloaded;
  cc_reloaded_r1 <= cc_reloaded_r0;
  cc_reloaded_r2 <= cc_reloaded_r1;
end

always @(posedge clk) begin

//  if(setup_cnt_r != 'd0 && firstd && cc_reloaded_r2) begin
  if(setup_cnt_not_zero && firstd && cc_reloaded_r2) begin
    firstd <= 1'b0;
    radio_counter <= setup_cnt_r;
  end
  else if(radio_counter == 'd0)
     radio_counter <= NO_OF_CLOCKS_FOR_1MS-1;
  else 
     radio_counter <= radio_counter - 'd1;

  if (~resetn) begin
    radio_start <= 1'd0;
    radio_start_10ms <= 1'd0;
  end else begin

    radio_start_10ms <= 1'd0; // Catchall
    radio_start      <= 1'd0;

    if (radio_counter == 'd0) begin
      radio_start <= 1'd1;

      if(radio_counter_10 == 'd0) begin
        radio_start_10ms <= 1'd1;
        radio_counter_10 <= 'd9;
      end else begin
        radio_counter_10 <= radio_counter_10 - 'd1;
      end

    end

  end


end

endmodule

//-----------------------------------------------------------------------------
// Shift register for timing replication
//-----------------------------------------------------------------------------
module shift_chain_p #(
   parameter p_sw   = 3,
   parameter p_init = 0
) (
  input  wire    sin  ,
  input  wire    clk  ,
  output reg     sout=p_init  
);

reg [p_sw-1:0] xshifter = p_init; 

always @(posedge clk) begin
  xshifter <= {xshifter[p_sw-2:0],sin};
  sout     <= xshifter[p_sw-1];
end

endmodule

