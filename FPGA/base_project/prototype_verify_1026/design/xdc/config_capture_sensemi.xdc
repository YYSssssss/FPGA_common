set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]


set_property PACKAGE_PIN J28 [get_ports sys_clk_p]
set_property PACKAGE_PIN J27 [get_ports sys_clk_n]


#set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
#set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
#set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
#connect_debug_port dbg_hub/clk [get_nets u_rf_datacapture_top_wrapper/u_rf_datacapture_top/u_clock_gen/u_clk_wiz/clk_out4]

