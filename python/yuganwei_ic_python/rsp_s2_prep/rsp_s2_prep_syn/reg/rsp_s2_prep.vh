
`define i_dc_est_cmp_cnt_ADDR                              32'h0000
`define i_dc_est_cmp_cnt_i_dc_est_cmp_cnt_BITS             12:0
`define i_dc_est_cmp_cnt_i_dc_est_cmp_cnt_DFLT             13'h0

`define i_dc_est_chp_cnt_ADDR                              32'h0004
`define i_dc_est_chp_cnt_i_dc_est_chp_cnt_BITS             9:0
`define i_dc_est_chp_cnt_i_dc_est_chp_cnt_DFLT             10'h0

`define i_dc_est_frm_cnt_ADDR                              32'h0008
`define i_dc_est_frm_cnt_i_dc_est_frm_cnt_BITS             3:0
`define i_dc_est_frm_cnt_i_dc_est_frm_cnt_DFLT             4'h0

`define i_dc_est_scale_ADDR                                32'h000c
`define i_dc_est_scale_i_dc_est_scale_BITS                 16:0
`define i_dc_est_scale_i_dc_est_scale_DFLT                 17'h0

`define i_dc_config_mode_ADDR                              32'h0010
`define i_dc_config_mode_i_dc_config_mode_BITS             3:0
`define i_dc_config_mode_i_dc_config_mode_DFLT             4'h0

`define i_dc_u_ADDR                                        32'h0014
`define i_dc_u_i_dc_u_BITS                                 31:0
`define i_dc_u_i_dc_u_DFLT                                 32'h0

`define o_dc_u_ADDR                                        32'h0018
`define o_dc_u_o_dc_u_BITS                                 31:0
`define o_dc_u_o_dc_u_DFLT                                 32'h0

`define i_intf_est_scale_ADDR                              32'h001c
`define i_intf_est_scale_i_intf_est_scale_BITS             16:0
`define i_intf_est_scale_i_intf_est_scale_DFLT             17'h0

`define i_intf_config_mode_ADDR                            32'h0020
`define i_intf_config_mode_i_intf_config_mode_BITS         3:0
`define i_intf_config_mode_i_intf_config_mode_DFLT         4'h0

`define i_intf_cmp_ADDR                                    32'h0024
`define i_intf_cmp_i_intf_cmp_BITS                         31:0
`define i_intf_cmp_i_intf_cmp_DFLT                         32'h0

`define o_intf_cmp_ADDR                                    32'h0028
`define o_intf_cmp_o_intf_cmp_BITS                         31:0
`define o_intf_cmp_o_intf_cmp_DFLT                         32'h0

`define i_combination_config_mode_ADDR                     32'h002c
`define i_combination_config_mode_i_combination_config_mode_BITS 3:0
`define i_combination_config_mode_i_combination_config_mode_DFLT 4'h0

`define i_phase_config_mode_ADDR                           32'h0030
`define i_phase_config_mode_i_phase_config_mode_BITS       3:0
`define i_phase_config_mode_i_phase_config_mode_DFLT       4'h0

`define i_phase_w_ADDR                                     32'h0034
`define i_phase_w_i_phase_w_BITS                           31:0
`define i_phase_w_i_phase_w_DFLT                           32'h0

`define i_phase_coe_ADDR                                   32'h0038
`define i_phase_coe_i_phase_coe_BITS                       31:0
`define i_phase_coe_i_phase_coe_DFLT                       32'h0

`define i_data_formatter_ADDR                              32'h003c
`define i_data_formatter_i_data_formatter_BITS             15:0
`define i_data_formatter_i_data_formatter_DFLT             16'h0

`define i_frame_num_format_ADDR                            32'h0040
`define i_frame_num_format_i_frame_num_format_BITS         15:0
`define i_frame_num_format_i_frame_num_format_DFLT         16'h0

`define s1_prep_debug_0_ADDR                               32'h0044
`define s1_prep_debug_0_s1_prep_debug_0_BITS               31:0
`define s1_prep_debug_0_s1_prep_debug_0_DFLT               32'h0

`define s1_prep_debug_1_ADDR                               32'h0048
`define s1_prep_debug_1_s1_prep_debug_1_BITS               31:0
`define s1_prep_debug_1_s1_prep_debug_1_DFLT               32'h0

`define s1_prep_debug_2_ADDR                               32'h004c
`define s1_prep_debug_2_s1_prep_debug_2_BITS               31:0
`define s1_prep_debug_2_s1_prep_debug_2_DFLT               32'h0

`define s1_prep_debug_3_ADDR                               32'h0050
`define s1_prep_debug_3_s1_prep_debug_3_BITS               31:0
`define s1_prep_debug_3_s1_prep_debug_3_DFLT               32'h0

`define s1_prep_debug_4_ADDR                               32'h0054
`define s1_prep_debug_4_s1_prep_debug_4_BITS               31:0
`define s1_prep_debug_4_s1_prep_debug_4_DFLT               32'h0

`define s1_prep_debug_5_ADDR                               32'h0058
`define s1_prep_debug_5_s1_prep_debug_5_BITS               31:0
`define s1_prep_debug_5_s1_prep_debug_5_DFLT               32'h0

`define s1_prep_debug_6_ADDR                               32'h005c
`define s1_prep_debug_6_s1_prep_debug_6_BITS               31:0
`define s1_prep_debug_6_s1_prep_debug_6_DFLT               32'h0

`define s1_prep_debug_7_ADDR                               32'h0060
`define s1_prep_debug_7_s1_prep_debug_7_BITS               31:0
`define s1_prep_debug_7_s1_prep_debug_7_DFLT               32'h0

`define s1_prep_debug_8_ADDR                               32'h0064
`define s1_prep_debug_8_s1_prep_debug_8_BITS               31:0
`define s1_prep_debug_8_s1_prep_debug_8_DFLT               32'h0

`define s1_prep_debug_9_ADDR                               32'h0068
`define s1_prep_debug_9_s1_prep_debug_9_BITS               31:0
`define s1_prep_debug_9_s1_prep_debug_9_DFLT               32'h0

`define s1_prep_debug_10_ADDR                              32'h006c
`define s1_prep_debug_10_s1_prep_debug_10_BITS             31:0
`define s1_prep_debug_10_s1_prep_debug_10_DFLT             32'h0

`define s1_prep_debug_11_ADDR                              32'h0070
`define s1_prep_debug_11_s1_prep_debug_11_BITS             31:0
`define s1_prep_debug_11_s1_prep_debug_11_DFLT             32'h0

`define s1_prep_debug_12_ADDR                              32'h0074
`define s1_prep_debug_12_s1_prep_debug_12_BITS             31:0
`define s1_prep_debug_12_s1_prep_debug_12_DFLT             32'h0

`define s1_prep_debug_13_ADDR                              32'h0078
`define s1_prep_debug_13_s1_prep_debug_13_BITS             31:0
`define s1_prep_debug_13_s1_prep_debug_13_DFLT             32'h0

`define s1_prep_debug_14_ADDR                              32'h007c
`define s1_prep_debug_14_s1_prep_debug_14_BITS             31:0
`define s1_prep_debug_14_s1_prep_debug_14_DFLT             32'h0

`define s1_prep_debug_15_ADDR                              32'h0080
`define s1_prep_debug_15_s1_prep_debug_15_BITS             31:0
`define s1_prep_debug_15_s1_prep_debug_15_DFLT             32'h0

`define s1_prep_debug_16_ADDR                              32'h0084
`define s1_prep_debug_16_s1_prep_debug_16_BITS             31:0
`define s1_prep_debug_16_s1_prep_debug_16_DFLT             32'h0

`define last_register_ADDR                                 32'h0088
`define last_register_last_register_BITS                   31:0
`define last_register_last_register_DFLT                   32'h0
