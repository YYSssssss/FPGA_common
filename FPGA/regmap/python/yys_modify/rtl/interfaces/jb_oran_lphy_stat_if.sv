// -------------------------------------------------------------------------- // 
// Copyright Jabil Inc.                                                       // 
// -------------------------------------------------------------------------- // 
// Name         : 2918630                                                     // 
// Date         : 09/14/21                                                    // 
// File         : jb_oran_lphy_stat.sv                                          // 
// Design       :                                                             // 
// Purpose      :                                                             // 
// Device       :                                                             // 
// -------------------------------------------------------------------------- // 


interface jb_oran_lphy_stat_if;
   logic  [15:0]                ul_lphy_oran_vld_wo_rdy;
   logic  [15:0]                ul_lphy_oran_fifo_overflow;
   logic  [15:0]                ul_lphy_oran_stale_reqs;
   logic  [15:0]                ul_lphy_oran_stale_prbs;
   logic                        section_write_too_long_err;
   logic  [3:0]                 prach_oran_vld_wo_rdy;
   logic  [3:0]                 prach_oran_cplane_fifo_ovfl;
   logic  [7:0][3:0]            prach_oran_reqs_fifo_ovfl;
   logic  [31:0]                lphy_oran_runt_type0_cnt;
   logic  [31:0]                lphy_oran_runt_type2_cnt;
   logic  [31:0]                lphy_oran_win_t2_t1_dl_cnt;
   logic  [31:0]                lphy_oran_win_t2_t1_ul_cnt;
   logic  [31:0]                lphy_oran_win_t2_t3_ul_cnt;
   logic  [31:0]                lphy_oran_win_t0_dl_cnt;
   logic  [31:0]                lphy_oran_other_t0_err_cnt;
   logic  [31:0]                lphy_oran_other_t2_err_cnt;
   logic  [31:0]                lphy_oran_other_t1_ul_err_cnt;
   logic  [31:0]                lphy_oran_other_t1_dl_err_cnt;
   logic  [31:0]                lphy_oran_other_t3_err_cnt;
   logic  [31:0]                lphy_oran_t1_data_dl_cnt;
   logic  [31:0]                lphy_oran_t1_ctrl_ul_cnt;
   logic  [31:0]                lphy_oran_t1_ctrl_dl_cnt;
   logic  [31:0]                lphy_oran_t3_ctrl_ul_cnt;
   logic  [31:0]                lphy_oran_t1_reqs_ul0_cnt;
   logic  [31:0]                lphy_oran_t1_data_ul0_cnt;
   logic  [31:0]                lphy_oran_t1_reqs_ul1_cnt;
   logic  [31:0]                lphy_oran_t1_data_ul1_cnt;
   logic  [31:0]                lphy_oran_t1_reqs_ul2_cnt;
   logic  [31:0]                lphy_oran_t1_data_ul2_cnt;
   logic  [31:0]                lphy_oran_t1_reqs_ul3_cnt;
   logic  [31:0]                lphy_oran_t1_data_ul3_cnt;
   logic  [31:0]                lphy_oran_t3_reqs_ul_cnt;
   logic  [31:0]                lphy_oran_t3_data_ul_cnt;
   

modport stat (
input
        ul_lphy_oran_vld_wo_rdy,
        ul_lphy_oran_fifo_overflow,
        ul_lphy_oran_stale_reqs,
        ul_lphy_oran_stale_prbs,
        prach_oran_vld_wo_rdy,
        prach_oran_cplane_fifo_ovfl,
        prach_oran_reqs_fifo_ovfl,
		section_write_too_long_err,
        lphy_oran_runt_type0_cnt,
        lphy_oran_runt_type2_cnt,
        lphy_oran_win_t2_t1_dl_cnt,
        lphy_oran_win_t2_t1_ul_cnt,
        lphy_oran_win_t2_t3_ul_cnt,
        lphy_oran_win_t0_dl_cnt,
        lphy_oran_other_t0_err_cnt,
        lphy_oran_other_t2_err_cnt,
        lphy_oran_other_t1_ul_err_cnt,
        lphy_oran_other_t1_dl_err_cnt,
        lphy_oran_other_t3_err_cnt,
        lphy_oran_t1_data_dl_cnt,
        lphy_oran_t1_ctrl_ul_cnt,
        lphy_oran_t1_ctrl_dl_cnt,
        lphy_oran_t3_ctrl_ul_cnt,
        lphy_oran_t1_reqs_ul0_cnt,
        lphy_oran_t1_data_ul0_cnt,
        lphy_oran_t1_reqs_ul1_cnt,
        lphy_oran_t1_data_ul1_cnt,
        lphy_oran_t1_reqs_ul2_cnt,
        lphy_oran_t1_data_ul2_cnt,
        lphy_oran_t1_reqs_ul3_cnt,
        lphy_oran_t1_data_ul3_cnt,
        lphy_oran_t3_reqs_ul_cnt,
        lphy_oran_t3_data_ul_cnt
);

modport cnts (
output
        ul_lphy_oran_vld_wo_rdy,
        ul_lphy_oran_fifo_overflow,
        ul_lphy_oran_stale_reqs,
        ul_lphy_oran_stale_prbs,
        prach_oran_vld_wo_rdy,
        prach_oran_cplane_fifo_ovfl,
        prach_oran_reqs_fifo_ovfl,
        lphy_oran_runt_type0_cnt,
        lphy_oran_runt_type2_cnt,
        lphy_oran_win_t2_t1_dl_cnt,
        lphy_oran_win_t2_t1_ul_cnt,
        lphy_oran_win_t2_t3_ul_cnt,
        lphy_oran_win_t0_dl_cnt,
        lphy_oran_other_t0_err_cnt,
        lphy_oran_other_t2_err_cnt,
        lphy_oran_other_t1_ul_err_cnt,
        lphy_oran_other_t1_dl_err_cnt,
        lphy_oran_other_t3_err_cnt,
        lphy_oran_t1_data_dl_cnt,
        lphy_oran_t1_ctrl_ul_cnt,
        lphy_oran_t1_ctrl_dl_cnt,
        lphy_oran_t3_ctrl_ul_cnt,
        lphy_oran_t1_reqs_ul0_cnt,
        lphy_oran_t1_data_ul0_cnt,
        lphy_oran_t1_reqs_ul1_cnt,
        lphy_oran_t1_data_ul1_cnt,
        lphy_oran_t1_reqs_ul2_cnt,
        lphy_oran_t1_data_ul2_cnt,
        lphy_oran_t1_reqs_ul3_cnt,
        lphy_oran_t1_data_ul3_cnt,
        lphy_oran_t3_reqs_ul_cnt,
        lphy_oran_t3_data_ul_cnt
);

modport ul_oran_lphy (
output
        ul_lphy_oran_vld_wo_rdy,
        ul_lphy_oran_fifo_overflow,
        ul_lphy_oran_stale_reqs,
        ul_lphy_oran_stale_prbs
);

modport dl_oran_lphy (
output 
        section_write_too_long_err
);

modport prach_oran (
output
        prach_oran_vld_wo_rdy,
        prach_oran_cplane_fifo_ovfl,
        prach_oran_reqs_fifo_ovfl
);

endinterface


