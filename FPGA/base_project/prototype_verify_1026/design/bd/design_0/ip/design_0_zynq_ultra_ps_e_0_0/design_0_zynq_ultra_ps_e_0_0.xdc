##############################PS XDC#########################################
############################################################################
##
##  Xilinx, Inc. 2006            www.xilinx.com
############################################################################
##  File name :       psu_constraints.xdc
##
##  Details :     Constraints file
##                    FPGA family:       zynq
##                    FPGA:              PROD-2
##                    Device Size:       xczu15eg
##                    Package:           ffvb1156
##                    Speedgrade:        -2
##
##
############################################################################
############################################################################
############################################################################
# Clock constraints                                                        #
############################################################################
create_clock -name clk_pl_0 -period "5" [get_pins "PS8_i/PLCLK[0]"]
create_clock -name clk_pl_1 -period "5" [get_pins "PS8_i/PLCLK[1]"]
create_clock -name clk_pl_2 -period "41.999" [get_pins "PS8_i/PLCLK[2]"]



set_property DONT_TOUCH true [get_cells "PS8_i"]
