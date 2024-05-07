#/**************************************************/
#/* Compile Script for Synopsys                    */
#/*                                                */
#/* dc_shell-t -f compile_dc.tcl                   */
#/*                                                */
#/* SMIC 40nm                                      */
#/**************************************************/

#/* All verilog files, separated by spaces         */
set vobs "/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs"
set rsp_amba "/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/common/amba"
set rsp_mem "/iceng/lib/memory/tsmc28/0.1"
set my_verilog_files [list \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_cc_constants.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_constants.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm_params.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm02.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_sfsm.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_sbiu.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_begen.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_dreg.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_mfsm.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_mbiu.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_core.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm21.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm99.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_sync.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h.v \
${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h-undef.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/data_delay.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/handshake_pipie_forward.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/fifo_fwft_small.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/radix2_3mul.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/mult.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/fifo_fwft_large.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/delay.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/radix2_opt.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/handshake_pipie_backward.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/fifo_fwft.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/fifo_standard.v \
${vobs}/ip/rsp/design/common/dsp_lib/src/interpolation.sv \
${vobs}/ip/rsp/design/common/dsp_lib/src/radix2_shared_tw.sv \
${vobs}/ip/rsp/design/common/dsp_lib/src/log2.sv \
${vobs}/ip/rsp/design/common/dsp_lib/src/pipelined_radix2_shared_tw.sv \
${vobs}/ip/rsp/design/common/dsp_lib/src/abs.sv \
${vobs}/ip/rsp/design/common/dsp_lib/src/data_select_2d.sv \
${vobs}/ip/rsp/design/common/dsp_lib/src/frac_divider.sv \
${vobs}/ip/rsp/design/common/amba/src/ahb2en.v \
${vobs}/ip/rsp/design/common/amba/src/axi_v4_wr_if.sv \
${vobs}/ip/rsp/design/common/amba/src/ahb_if_cfg.sv \
${vobs}/ip/rsp/design/common/amba/src/axi_v4_rd_if.sv \
${vobs}/ip/rsp/design/common/amba/src/axi_v4_if.sv \
${vobs}/ip/rsp/design/common/amba/src/axi_ram.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../ahb_ic/src/rsp_s2_prep_ahbic_in.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../ahb_ic/src/rsp_s2_prep_ahbic_out.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../ahb_ic/src/rsp_s2_prep_ahbic_default_slave.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../ahb_ic/src/rsp_s2_prep_ahbic_lite.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../ahb_ic/src/rsp_s2_prep_ahbic_arb.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../ahb_ic/src/rsp_s2_prep_ahbic_decS0.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../ahb_ic/src/rsp_s2_prep_ahbic.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/../reg/rsp_s2_prep_regmap.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_mult.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_fifo.v \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_phase_generation.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_abs_complex.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_axi4_m_wr.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_estimation.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_pg_select_ram_data.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_combination.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_abs_cmp.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_delay_data.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_core.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_multiplier0.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_axi4_m_rd.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_top.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_diff.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_abs_real.sv \
${vobs}/ip/rsp/design/rsp_s2/sub/rsp_s2_prep/src/rsp_s2_prep_add_u.sv \
$rsp_mem/wrapper/src/tpram.v \
$rsp_mem/wrapper/src/spram.v \
$rsp_mem/wrapper/src/spram_136x64.v \
$rsp_mem/wrapper/src/spram_32x32.v \
$rsp_mem/t28_mem_wrap/src/sprf_lvt_136x64m2s.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdlvt_136x64m2s.v \
$rsp_mem/t28_mem_wrap/src/sprf_svt_136x64m2s.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdsvt_136x64m2s.v \
$rsp_mem/t28_mem_wrap/src/sprf_lvt_136x64m2f.v \
$rsp_mem/t28_mem_wrap/src/sprf_svt_136x64m2f.v \
$rsp_mem/t28_mem_wrap/src/spram_lvt_32x32m4s.v \
$rsp_mem/t28_mem_wrap/src/sprf_lvt_32x32m4f.v \
$rsp_mem/t28_mem_wrap/src/sprf_svt_32x32m8f.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdlvt_32x32m1s.v \
$rsp_mem/t28_mem_wrap/src/spram_svt_32x32m4s.v \
$rsp_mem/t28_mem_wrap/src/sprf_svt_32x32m4f.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdsvt_32x32m2s.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdlvt_32x32m4s.v \
$rsp_mem/t28_mem_wrap/src/sprf_svt_32x32m2f.v \
$rsp_mem/t28_mem_wrap/src/sprf_lvt_32x32m2f.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdlvt_32x32m2s.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdsvt_32x32m4s.v \
$rsp_mem/t28_mem_wrap/src/spram_uhdsvt_32x32m1s.v \
$rsp_mem/t28_mem_wrap/src/sprf_lvt_32x32m8f.v
]
#/* Top-level Module                               */
set my_toplevel rsp_s2_prep
#/* The name of the clock pin. If no clock-pin     */
#/* exists, pick anything                          */
set my_clock_pin clk

#/* Delay of input signals (Clock-to-Q, Package etc.)  */
set my_input_delay_ns 0.0

#/* Reserved time for output signals (Holdtime etc.)   */
set my_output_delay_ns 0

#DC setting
set case_analysis_with_logic_constants true
set_host_options -max_cores 16
#/**************************************************/
#/* No modifications needed below                  */
#/**************************************************/
set HEAD_PATH "/prj/chips/pvg/venus/yuyushan/jade_venus_1/vobs/ip/rsp/design/common/header/"
set TAR_PATH "/iceng/lib/stdcell/smic40/"
set LIN_PATH "/iceng/lib/memory/tsmc28/0.1/DB/"
set search_path [concat $TAR_PATH $LIN_PATH $HEAD_PATH]

set target_lib [list \
scc40nll_vhsc40_rvt_ss_v0p99_125c_basic.db \
]
set link_lib [list \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ssg0p9v0c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ffg1p05vm40c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_tt1v25c.db \
ts5n28hpcplvta136x64m2sw_130a_ffg0p99v0c.db \
ts5n28hpcplvta136x64m2sw_130a_ssg0p81vm40c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ssg0p9vm40c.db \
ts5n28hpcplvta136x64m2fw_130a_tt0p9v25c.db \
ts5n28hpcplvta136x64m2fw_130a_ssg0p9v0c.db \
ts5n28hpcpsvta136x64m2sw_130a_tt1v85c.db \
ts5n28hpcplvta136x64m2sw_130a_ffg0p99vm40c.db \
ts5n28hpcpsvta136x64m2sw_130a_tt1v25c.db \
ts5n28hpcplvta136x64m2sw_130a_tt0p9v85c.db \
ts5n28hpcpsvta136x64m2fw_130a_ssg0p81vm40c.db \
ts5n28hpcpsvta136x64m2sw_130a_ffg0p99v0c.db \
ts5n28hpcpsvta136x64m2fw_130a_ffg0p99v125c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ssg0p81v125c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_tt1v25c.db \
ts5n28hpcpsvta136x64m2sw_130a_ffg0p99v125c.db \
ts5n28hpcpsvta136x64m2fw_130a_tt0p9v85c.db \
ts5n28hpcplvta136x64m2sw_130a_ffg1p05v125c.db \
ts5n28hpcpsvta136x64m2sw_130a_ssg0p81v125c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_tt0p9v25c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ffg0p99v0c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_tt0p9v25c.db \
ts5n28hpcpsvta136x64m2fw_130a_ssg0p9vm40c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_tt1v85c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ffg0p99v125c.db \
ts5n28hpcplvta136x64m2fw_130a_ssg0p9v125c.db \
ts5n28hpcplvta136x64m2sw_130a_tt0p9v25c.db \
ts5n28hpcpsvta136x64m2fw_130a_ssg0p81v125c.db \
ts5n28hpcplvta136x64m2sw_130a_tt1v85c.db \
ts5n28hpcpsvta136x64m2fw_130a_ffg0p99vm40c.db \
ts5n28hpcplvta136x64m2fw_130a_ssg0p81vm40c.db \
ts5n28hpcplvta136x64m2fw_130a_tt1v85c.db \
ts5n28hpcpsvta136x64m2fw_130a_ffg1p05vm40c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_tt1v85c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ffg1p05vm40c.db \
ts5n28hpcpsvta136x64m2sw_130a_tt0p9v85c.db \
ts5n28hpcplvta136x64m2fw_130a_ffg0p99v125c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ssg0p9v125c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ffg0p99v125c.db \
ts5n28hpcpsvta136x64m2fw_130a_ffg1p05v125c.db \
ts5n28hpcpsvta136x64m2sw_130a_ssg0p81v0c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_tt0p9v85c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ffg0p99vm40c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ssg0p81v125c.db \
ts5n28hpcplvta136x64m2fw_130a_ffg1p05v0c.db \
ts5n28hpcplvta136x64m2fw_130a_ssg0p9vm40c.db \
ts5n28hpcpsvta136x64m2sw_130a_ffg1p05v125c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ffg0p99vm40c.db \
ts5n28hpcplvta136x64m2sw_130a_ffg1p05v0c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ssg0p9vm40c.db \
ts5n28hpcplvta136x64m2sw_130a_ffg1p05vm40c.db \
ts5n28hpcpsvta136x64m2fw_130a_ffg1p05v0c.db \
ts5n28hpcplvta136x64m2fw_130a_ffg0p99v0c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ffg0p99v0c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ssg0p9v0c.db \
ts5n28hpcpsvta136x64m2sw_130a_ssg0p9v0c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ffg1p05v0c.db \
ts5n28hpcpsvta136x64m2fw_130a_ssg0p9v0c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ssg0p81vm40c.db \
ts5n28hpcplvta136x64m2sw_130a_ssg0p9v0c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ffg1p05v125c.db \
ts5n28hpcpsvta136x64m2sw_130a_tt0p9v25c.db \
ts5n28hpcpsvta136x64m2fw_130a_ssg0p81v0c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ssg0p81vm40c.db \
ts5n28hpcplvta136x64m2fw_130a_tt1v25c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ssg0p9v125c.db \
ts5n28hpcpsvta136x64m2sw_130a_ffg0p99vm40c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ffg1p05v125c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_tt0p9v85c.db \
ts5n28hpcpsvta136x64m2sw_130a_ssg0p9v125c.db \
ts5n28hpcplvta136x64m2fw_130a_ffg1p05v125c.db \
ts5n28hpcplvta136x64m2sw_130a_ssg0p9v125c.db \
ts5n28hpcplvta136x64m2fw_130a_tt0p9v85c.db \
ts5n28hpcplvta136x64m2sw_130a_tt1v25c.db \
ts5n28hpcplvta136x64m2sw_130a_ssg0p81v0c.db \
ts5n28hpcpsvta136x64m2fw_130a_tt0p9v25c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ssg0p81v0c.db \
ts1n28hpcpuhdsvtb136x64m2sw_170a_ssg0p81v0c.db \
ts5n28hpcpsvta136x64m2sw_130a_ssg0p9vm40c.db \
ts5n28hpcplvta136x64m2sw_130a_ssg0p9vm40c.db \
ts5n28hpcplvta136x64m2fw_130a_ssg0p81v0c.db \
ts5n28hpcplvta136x64m2fw_130a_ssg0p81v125c.db \
ts5n28hpcpsvta136x64m2sw_130a_ffg1p05vm40c.db \
ts5n28hpcpsvta136x64m2fw_130a_ffg0p99v0c.db \
ts5n28hpcpsvta136x64m2fw_130a_ssg0p9v125c.db \
ts5n28hpcpsvta136x64m2sw_130a_ffg1p05v0c.db \
ts5n28hpcplvta136x64m2fw_130a_ffg0p99vm40c.db \
ts5n28hpcplvta136x64m2sw_130a_ffg0p99v125c.db \
ts5n28hpcpsvta136x64m2fw_130a_tt1v85c.db \
ts5n28hpcpsvta136x64m2fw_130a_tt1v25c.db \
ts5n28hpcplvta136x64m2sw_130a_ssg0p81v125c.db \
ts5n28hpcplvta136x64m2fw_130a_ffg1p05vm40c.db \
ts5n28hpcpsvta136x64m2sw_130a_ssg0p81vm40c.db \
ts1n28hpcpuhdlvtb136x64m2sw_170a_ffg1p05v0c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ssg0p81v125c.db \
ts1n28hpcpsvtb32x32m4sw_130a_tt1v25c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ssg0p9v125c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ffg0p99v125c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ffg0p99vm40c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ssg0p81v125c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_tt0p9v85c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ssg0p9v0c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ssg0p9v0c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ssg0p81v0c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ffg0p99v125c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ssg0p81vm40c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ffg1p05vm40c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ssg0p9vm40c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ffg1p05v125c.db \
ts1n28hpcpsvtb32x32m4sw_130a_tt0p9v25c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ffg0p99v0c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_tt0p9v25c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ffg1p05v0c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ssg0p81vm40c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ssg0p81v0c.db \
ts1n28hpcpsvtb32x32m4sw_130a_tt0p9v85c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ffg0p99vm40c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ssg0p9v125c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ffg0p99v0c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ffg1p05v125c.db \
ts1n28hpcpsvtb32x32m4sw_130a_ffg1p05v0c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ffg1p05vm40c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_ssg0p9vm40c.db \
ts1n28hpcpuhdsvtb32x32m4sw_170a_tt1v25c.db \
ts1n28hpcpsvtb32x32m4sw_130a_tt1v85c.db 
]

set target_library $target_lib 
#set link_library "* $target_lib"
set link_library [list * $link_lib]
define_design_lib WORK -path ./WORK
set verilogout_show_unconnected_pins "true"
#set_ultra_optimization true
#set_ultra_optimization -force

#dont use setting
#set cell_list [get_lib_cells typical/CLK*]
#set_dont_use $cell_list

analyze -f sverilog $my_verilog_files -vcs "+define+ASIC"
#read_sverilog $my_verilog_files

elaborate $my_toplevel

current_design $my_toplevel

link
uniquify

check_design

#timing constraints
#set my_period [expr "1000/$my_clk_freq_MHz"]
set my_period 1.2
set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name vclk
   create_clock -period $my_period -name $clk_name
}
#set_driving_cell  -lib_cell INVX1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]


check_timing
set report_default_significant_digits 4

#compile -map_effort high 
#compile -incremental_mapping -map_effort medium
compile_ultra -no_autoungroup
#compile_ultra

report_constraint -all_violators
change_names -rule verilog -hier
set filename [format "%s%s"  $my_toplevel ".gv"]
write -f verilog -hier -output $filename

set filename [format "%s%s"  $my_toplevel ".ddc"]
write -f ddc  -hier -output $filename

set filename [format "%s%s"  $my_toplevel ".sdc"]
write_sdc $filename

#set filename [format "%s%s"  $my_toplevel ".db"]
#write -f db -hier -output $filename -xg_force_db

redirect $my_toplevel.timing { report_timing }
redirect $my_toplevel.cell { report_cell }
redirect $my_toplevel.power { report_power }
redirect $my_toplevel.area {report_area -hierarchy}
quit

