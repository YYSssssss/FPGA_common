#/**************************************************/
#/* Compile Script for Synopsys                    */
#/*                                                */
#/* dc_shell-t -f compile_dc.tcl                   */
#/*                                                */
#/* SMIC 40nm                                      */
#/**************************************************/

#/* All verilog files, separated by spaces         */
set root_dir "/home/users/yuyushan/sim/rsp_s2_cp/syn/src"
set my_verilog_files [list \
$root_dir/axi4/axi_v4_rd_if.sv \
$root_dir/axi4/axi_v4_wr_if.sv \
$root_dir/axi4_master_write.sv \
$root_dir/axi4_master_read.sv \
$root_dir/chirp_processing_core.sv \
$root_dir/chirp_processing_top.sv \
$root_dir/diff.sv \
$root_dir/abs_cmp.sv \
$root_dir/abs_complex.sv \
$root_dir/abs_real.sv \
$root_dir/buffer_8data.sv \
$root_dir/chirp_processing_multiplier0.sv \
$root_dir/combination.sv \
$root_dir/delay_data.sv \
$root_dir/estimation.sv \
$root_dir/fifo_cp.v \
$root_dir/tb/delay.v \
$root_dir/mult_cp.v   
]
#/* Top-level Module                               */
set my_toplevel rsp_s1_prep 

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
#set OSU_FREEPDK [format "%s%s"  [getenv "PDK_DIR"] "/osu_soc/lib/files"]
#set search_path [concat  $search_path "/data/pdk/"]
set TAR_PATH "/iceng/lib/stdcell/smic40/"
set LIN_PATH "/iceng/lib/memory/tsmc28/0.1/DB"
set search_path [concat $TAR_PATH $LIN_PATH]
#set alib_library_analysis_path $OSU_FREEPDK
set target_lib [list \
scc40nll_vhsc40_rvt_ss_v0p99_125c_basic.db \
]
set link_lib [list \
ts6n28hpcpsvta512x128m2sw_130a_ssg0p81v125c.db]

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

analyze -f sverilog $my_verilog_files
#read_sverilog $my_verilog_files

elaborate $my_toplevel

current_design $my_toplevel

link
uniquify

set report_default_significant_digits 4


check_design

#timing constraints
#set my_period [expr "1000/$my_clk_freq_MHz"]
set my_period 1
set find_clock [ find port [list $my_clock_pin] ]
if {  $find_clock != [list] } {
   set clk_name $my_clock_pin
   create_clock -period $my_period $clk_name
} else {
   set clk_name clk
   create_clock -period $my_period -name $clk_name
}
#set_driving_cell  -lib_cell INVX1  [all_inputs]
set_input_delay $my_input_delay_ns -clock $clk_name [remove_from_collection [all_inputs] $my_clock_pin]
set_output_delay $my_output_delay_ns -clock $clk_name [all_outputs]


set report_default_significant_digits 4

check_timing

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
