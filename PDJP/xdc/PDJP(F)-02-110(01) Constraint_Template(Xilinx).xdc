## =================================================================================================
## Phine Design (Japan) Co., Ltd.
## https://www.phinedesign.co.jp
## =================================================================================================

## =================================================================================================
## File Name      : FPGA_TOP.xdc
## Function       : FPGA configuration, pin, timing, bitstream
## Type           : XDC
## -------------------------------------------------------------------------------------------------
## Update History :
## -------------------------------------------------------------------------------------------------
## Rev.Level  Date         Coded by         Contents
## 0.0.1      2020/01/01   PDJP)ding.r      Create new
## 1.0.0      2020/01/10   PDJP)ding.r      Swap pin location
##
## =================================================================================================
## End Revision
## =================================================================================================

## Guide
## Reading "Vivado Design Suite User Guide: Using Constraints (UG903)" first.
## Refer to UG912 if you don't understand the meaning of following sentences.
## This file gives you a quick start but not everything, or almost nothing.

## Ref site
## https://www.acri.c.titech.ac.jp/wordpress/archives/3449
## https://www.paltek.co.jp/techblog/techinfo/211018_01
## https://www.paltek.co.jp/techblog/techinfo/220324_01


## =================================================================================================
## 1,PIN
## =================================================================================================
## Guide 
## in order to understand pin attribute, you should refer to target FPGAs SelectIO guide.
## eg. 7 Series FPGAs SelectIO Resources User Guide

## single end pin, PACKAGE_PIN + IOSTANDARD
set_property PACKAGE_PIN E14 [get_ports hdmi_rx_hpd_out]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_rx_hpd_out]

## IOSTANDARD maybe 
## LVTTL, LVCMOS, HSTL, SSTL
## Voltage maybe 3.3 2.5 1.8 1.5 to 1.0
## check the schematic and schematic designer



## Tri-state pin should be pulled up when not driven: PACKAGE_PIN + IOSTANDARD + PULLUP
## Wildcard symbol * to match all occurrences of characters
set_property PACKAGE_PIN K15 [get_ports sensor_iic_sda_io]
set_property PACKAGE_PIN L15 [get_ports sensor_iic_scl_io]
set_property PULLUP true [get_ports sensor_iic_*]
set_property IOSTANDARD HSUL_12_DCI [get_ports sensor_iic_*]

## IOSTANDARD maybe 
## LVDS, DIFF_SSTL, DIFF_HSTL,
## Voltage maybe 3.3 2.5 1.8 1.5 to 1.0
## check the schematic and schematic designer



# differential port can be declared by only the P side signal or both
set_property PACKAGE_PIN D7 [get_ports DAC0_DCO_P]
set_property PACKAGE_PIN D6 [get_ports DAC0_DCO_N]
set_property IOSTANDARD LVDS [get_ports DAC0_DCO_P]
set_property IOSTANDARD LVDS [get_ports DAC0_DCO_N]

# if the internal differentian termination should be added, following sentences should be added
set_property DIFF_TERM TRUE [get_ports DAC0_DCO_P]


## =================================================================================================
## 2,Timing
## =================================================================================================
## clock can be created by using ports name
## clock period can be declared by period of time (ns)
create_clock -period 3.200 -name DAC0_DCO_P [get_ports DAC0_DCO_P]

## clock period can be declard by frequence (Mhz)
create_clock -period 312.5MHz -name DAC0_DCO_P [get_ports DAC0_DCO_P]

## choosing the convinent one for yourself

## if you want to indicate the clock phase, using -waveform
create_clock -period 8 -name DAC0_DCO_P -waveform{0 4} [get_ports DAC0_DCO_P]

## =================================================================================================
## 3,Asynchronous handle
## =================================================================================================
## Princinple
## Don't
## If you don't understand what's going on between two clocks,
## set_false_path between clocks is not highly recommended.

## 1. Trying best to set the constraint between registers, not clocks.
## 2. Use "set_max_delay -datapath_only" instead of "set_false_path".
## 3. Use asynchronous group methods to assign different clocks to different groups.
## 4, Use vivado tools to help generating statment will be much easier.

set_max_delay 10 -datapath_only -from [get_pins -hier -filter {name =~ */SiTCP_INT_REG/regX10Data_reg*/C}] -to [get_pins -hier -filter {name =~ */GMII_RXCNT/irMacFlowEnb_reg/D}] 

set_false_path -from [get_pins -hier -filter {name =~ */SiTCP_INT/SiTCP_RESET_OUT_reg*/C}]

## using clock name to set clock groups
set_clock_groups -name async_clk0_clk1 -asynchronous -group {clk0 usrclk itfclk} \
-group {clk1 gtclkrx gtclktx}

## if you don't know the name or not create generated clock for yourself, 
##  using include generated clock or get_pin directly
set_clock_groups -name async_clk0_clk1 -asynchronous \
-group [get_clocks -include_generated_clocks clk0] \
-group [get_clocks -include_generated_clocks clk1]

## clock mux
## Only one clock will be selected at a time to clock the designs logic, no true cross-clocking situations will occur. 
set_clock_groups -physically_exclusive -group clk_1 -group clk_2 


## =================================================================================================
## 4,Bitstream setting
## =================================================================================================
# SPI bit width: Set according to actual usage and the corresponding SPI device.
set_property CONFIG_MODE SPIx8 [current_design]
# SPI Configure clock frequency. It is recommended to set it lower than 33 MHz to avoid configuration errors.
set_property BITSTREAM.CONFIG.CONFIGRATE 22 [current_design]
# Enable to reduce bitstream size. Note that this may cause boot-up failures.
set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]
# set the unused pins to pullup/down/none status
set_property BITSTREAM.CONFIG.UNUSEDPIN PULLNONE [current_design]
