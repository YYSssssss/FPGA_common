# Input  (P)    pl_refclk1      122.88  MHz   8.138 {PL_CLK1_122M88_P}         #
# Input  (P)    pl_refclk2      122.88  MHz   8.138 {PL_CLK2_122M88_P}         #
# Input  (P)    pl_1pps          10.000 MHz 100.000 {PL_1PPS_P}       (Actual 1Hz)#
# Input  (P)    pl_clk500       500.000 MHz   2.000 {PTP_SYS_500M_P}           #
# Input  (P)    (pl sysref)       3.840 MHz 260.420 {PL_SYSREF_3M84_P}         #
# Input  (P)    fh_mgtrefclk0   161.133 MHz   6.206 {MGTY_REF_CLK_P}           #
# ---------------------------------------------------------------------------- #

# PL_CLK1_122M88_P/N 122.88 MHz (8.138 ns)
create_clock -period 8.138 -name pl_refclk1 -waveform {0.000 4.069} [get_ports PL_CLK1_122M88_P]


# PL_CLK2_122M88_P/N 122.88 MHz (8.138 ns)
create_clock -period 8.138 -name pl_refclk2 -waveform {0.000 4.069} [get_ports PL_CLK2_122M88_P]

# PL_1PPS_P 1 Hz (1000000000 ns) - Make it 100 ns
create_clock -period 100 -name pl_1pps -waveform {0.000 50.000} [get_ports PL_1PPS_P]


# PTP_SYS_500M_P/N 500.00 MHz (2.000 ns)
create_clock -period 2.000 -name pl_clk500 -waveform {0.000 1.000} [get_ports PTP_SYS_500M_P]


# MGTY_REF_CLK_P 161.133 MHz (6.206 ns)
create_clock -period 6.206 -name fh_mgtrefclk0 -waveform {0.000 3.103} [get_ports MGTY_REF_CLK_P]


# PL_SYSREF_3M84_P 3.84 MHz (260.42 ns)- Constrained as a Synchronous Input
set_input_delay -clock [get_clocks pl_refclk1] -max 0.000 [get_ports PL_SYSREF_3M84_P]
set_input_delay -clock [get_clocks pl_refclk1] -min 0.000 [get_ports PL_SYSREF_3M84_P]

#set FH_CLKS         [get_clocks {rxout* txout* rxusr* txusr* refclkoutmonitor* ibert_gty_q128_u0* qpll0out*}]


set pl_clks [get_clocks {clk_pl_*}]

set mmcm1_clks      [get_clocks -of_objects [get_pins Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/clockgen/mmcm_data/inst/mmcme4_adv_inst/CLKOUT*]]
set m1_clk_122p88   [get_clocks -of_objects [get_pins Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/clockgen/mmcm_data/inst/mmcme4_adv_inst/CLKOUT3]]

set mmcm2_clks      [get_clocks -of_objects [get_pins Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/clockgen/mmcm_axi/inst/mmcme4_adv_inst/CLKOUT*]]
set m2_clk_100M     [get_clocks -of_objects [get_pins Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/clockgen/mmcm_axi/inst/mmcme4_adv_inst/CLKOUT0]]

set RFADC_CLKS      [get_clocks RFADC*]
set RFDAC_CLKS      [get_clocks RFDAC*]
set RFDC_CLKS       [get_clocks {RFDAC* RFDAC*}]


# ---------------------------------------------------------------------------- #
# Asynchronous Inputs                                                          #
# ---------------------------------------------------------------------------- #

set_false_path -from [get_ports {   SFP_LOS[*]\
                                    SFP_TX_FAULT[*]\
                                    SFP_DETECT_N[*]}]

set_false_path -from [get_ports {   ALARM[*]}]									
									
# ---------------------------------------------------------------------------- #
# Asynchronous Outputs                                                         #
# ---------------------------------------------------------------------------- #
set_false_path -to  [get_ports {    SFP_TX_EN_N[*]\
                                    SFP_RS[*]\
                                    SFP_LED[*]\
									COLD_RST_REQ_N}]
									
# ---------------------------------------------------------------------------- #
# False Paths                                                                  #
# ---------------------------------------------------------------------------- #
set_clock_groups -asynchronous -group $mmcm1_clks -group $mmcm2_clks
set_clock_groups -asynchronous -group $mmcm1_clks -group $mmcm1_clks
set_clock_groups -asynchronous -group $mmcm1_clks -group $RFDC_CLKS
set_clock_groups -asynchronous -group $mmcm1_clks -group [get_clocks pl_clk500]

set_clock_groups -asynchronous -group $mmcm2_clks -group $mmcm1_clks	
set_clock_groups -asynchronous -group $mmcm2_clks -group [get_clocks pl_clk500]


set_clock_groups -asynchronous -group [get_clocks pl_clk500] -group [get_clocks Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/fh_subsystem/xxv_eth_subs/xxv_wrap/xxv_ethernet_0/inst/gt_refclk_p]
set_clock_groups -asynchronous -group $mmcm2_clks -group [get_clocks Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/fh_subsystem/xxv_eth_subs/xxv_wrap/xxv_ethernet_0/inst/gt_refclk_p]
set_false_path -from [get_pins {Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/axi_gpio_dac/U0/gpio_core_1/Not_Dual.gpio_Data_Out_reg[0]*/C}] -to *
set_false_path -from [get_clocks RFADC*_CLK] -to [get_clocks -of_objects [get_pins Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/clockgen/mmcm_axi/inst/mmcme4_adv_inst/CLKOUT*]]
set_false_path -from [get_ports PL_SYSREF_3M84_P] -to [get_pins Vernon_top_u0/u_jb_vernon_bd_wrapper/vernon_u0/clockgen/jb_pl_sysref/inst/pl_sysref_r_reg/D]
set_false_path -from [get_pins Vernon_top_u0/u_jb_vernon_rst/*/C] -to *
set_false_path -from [get_pins {Vernon_top_u0/u_jb_vernon_top_dbg/u_jb_fhbuf/u_fhbuf_input/u_input_waveform/*/C}] -to *
set_false_path -from [get_clocks axi_clk_100M_vernon_mmcm_axi_0_1] -to [get_clocks txoutclk_out[0]_1]
set_false_path -from [get_clocks clk_out1_vernon_clk_wiz_0_0] -to [get_clocks pl_1pps]
set_false_path -from [get_clocks axi_clk_100M_vernon_mmcm_axi_0_1] -to [get_clocks clk_out1_vernon_clk_wiz_0_0]




#-----------------------------------------------------------------------------
## Timer constraints
##-----------------------------------------------------------------------------
# General CDC - Updated to XPM
#set_false_path -to [get_cells -hier -filter {name =~ */data_sync_reg0}]

# AXI-Lite CDC Address
set_max_delay -from [get_cells -hier -filter {name =~ *I_AXI_LITE_IPIF/I_SLAVE_ATTACHMENT/bus2ip_addr_reg_reg[*]}] 2 -datapath_only

# AXI-Lite CDC Write
set_max_delay -from [get_cells -hier -filter {name =~ *tod_configuration_inst/bus2ip_data_reg_reg[*]}] 2 -datapath_only

# AXI-Lite CDC Read
set_max_delay -from [get_cells -hier -filter {name =~ *tod_configuration_inst/rd_data_result_reg[*]}] -to [get_cells -hier -filter {name =~ *tod_configuration_inst/ip2bus_data_reg[*]}] 8 -datapath_only
