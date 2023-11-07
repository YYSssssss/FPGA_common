# ---------------------------------------------------------------------------- #
#  Copyright Jabil Inc.                                                        #
# ---------------------------------------------------------------------------- #
#  Name         : 
#  Date         : 
#  File         :                                      
#  Design       :                                                             
#  Purpose      :           
#  Device       :                                      
# ---------------------------------------------------------------------------- #

# ==============================================================
# HP Bank 65
# ==============================================================
  set_property PACKAGE_PIN AM14 [get_ports {SW_RXFB_DV_EN[1]}]
  set_property PACKAGE_PIN AN14 [get_ports {SW_RXFB_DV_EN[2]}]
  set_property PACKAGE_PIN AM15 [get_ports {SW_RXFB_DV_EN[3]}]
  set_property PACKAGE_PIN AN15 [get_ports {SW_RXFB_DV_EN[4]}]
  set_property PACKAGE_PIN AP16 [get_ports {SW_RXFB_DV_EN[5]}]
  set_property PACKAGE_PIN AP15 [get_ports {SW_RXFB_DV_EN[6]}]
  set_property PACKAGE_PIN AL17 [get_ports {SW_RXFB_DV_EN[7]}]
  set_property PACKAGE_PIN AM16 [get_ports {SW_RXFB_DV_EN[8]}]
  set_property PACKAGE_PIN AM17 [get_ports {SW_PA_RXFB_VCTL[1]}]
  set_property PACKAGE_PIN AN17 [get_ports {SW_PA_RXFB_VCTL[2]}]
  set_property PACKAGE_PIN AN18 [get_ports {SW_PA_DV_VCTL[1]}]
  set_property PACKAGE_PIN AP17 [get_ports {SW_PA_DV_VCTL[2]}]
# set_property PACKAGE_PIN AL14 [get_ports {}]

  set_property PACKAGE_PIN AH13 [get_ports {RX_DSA_LE[1]}]
  set_property PACKAGE_PIN AJ13 [get_ports {RX_DSA_LE[2]}]
  set_property PACKAGE_PIN AK15 [get_ports {RX_DSA_LE[3]}]
  set_property PACKAGE_PIN AK14 [get_ports {RX_DSA_LE[4]}]
  set_property PACKAGE_PIN AK18 [get_ports {RX_DSA_LE[5]}]
  set_property PACKAGE_PIN AL18 [get_ports {RX_DSA_LE[6]}] 
  set_property PACKAGE_PIN AH18 [get_ports {RX_DSA_LE[7]}]
  set_property PACKAGE_PIN AH14 [get_ports {RX_DSA_LE[8]}]
 
# set_property PACKAGE_PIN AJ18 [get_ports {}]
  set_property PACKAGE_PIN AJ16 [get_ports {PL_1PPS_P}]
  set_property PACKAGE_PIN AJ15 [get_ports {PL_1PPS_N}]
  set_property PACKAGE_PIN AJ17 [get_ports {PL_CLK2_122M88_P}]
  set_property PACKAGE_PIN AK16 [get_ports {PL_CLK2_122M88_N}]
# set_property PACKAGE_PIN AL16 [get_ports {}]
  

  set_property PACKAGE_PIN AG15 [get_ports {TRIGGER_FPGA}]
# set_property PACKAGE_PIN AH15 [get_ports {}]
  set_property PACKAGE_PIN AG17 [get_ports {PTP_SYS_500M_P}]
  set_property PACKAGE_PIN AH17 [get_ports {PTP_SYS_500M_N}]
  set_property PACKAGE_PIN AF13 [get_ports {PA_LNA_EN[1]}]
  set_property PACKAGE_PIN AG14 [get_ports {PA_LNA_EN[2]}]
  set_property PACKAGE_PIN AF16 [get_ports {PGOOD_EXT_48V }]
  
# set_property PACKAGE_PIN AE16 [get_ports {}]
  set_property PACKAGE_PIN AF14 [get_ports {EN_PA_PWR[8]}]
  set_property PACKAGE_PIN AJ12 [get_ports {EN_PA_PWR[7]}]
  set_property PACKAGE_PIN AG16 [get_ports {EN_PA_PWR[6]}]
  set_property PACKAGE_PIN AC13 [get_ports {EN_PA_PWR[5]}]
  set_property PACKAGE_PIN AD13 [get_ports {EN_PA_PWR[4]}]
  set_property PACKAGE_PIN AE14 [get_ports {EN_PA_PWR[3]}]
  set_property PACKAGE_PIN AE13 [get_ports {EN_PA_PWR[2]}]
  set_property PACKAGE_PIN AD15 [get_ports {EN_PA_PWR[1]}]

  set_property PACKAGE_PIN AE15 [get_ports {PGOOD_PA_PSU[8]}]
  set_property PACKAGE_PIN AC16 [get_ports {PGOOD_PA_PSU[7]}]
  set_property PACKAGE_PIN AC15 [get_ports {PGOOD_PA_PSU[6]}]
  set_property PACKAGE_PIN AC17 [get_ports {PGOOD_PA_PSU[5]}]
  set_property PACKAGE_PIN AD16 [get_ports {PGOOD_PA_PSU[4]}]
  set_property PACKAGE_PIN AD18 [get_ports {PGOOD_PA_PSU[3]}]
  set_property PACKAGE_PIN AE18 [get_ports {PGOOD_PA_PSU[2]}]
  set_property PACKAGE_PIN AD17 [get_ports {PGOOD_PA_PSU[1]}]
  
# ==============================================================
# HP Bank 66
# ==============================================================
  set_property PACKAGE_PIN AP8  [get_ports {ANT_CAL_SW_TX}]
  set_property PACKAGE_PIN AP7  [get_ports {ANT_CAL_SW_RX}]
# set_property PACKAGE_PIN AP6  [get_ports {}]
# set_property PACKAGE_PIN AP5  [get_ports {}]
  set_property PACKAGE_PIN AM6  [get_ports {TX_Gainblock_EN}]
  set_property PACKAGE_PIN AM5  [get_ports {SPI_TX_DSA_CS[1]}]
  set_property PACKAGE_PIN AN5  [get_ports {SPI_TX_DSA_CS[2]}]
  set_property PACKAGE_PIN AN4  [get_ports {SPI_TX_DSA_CS[3]}]
  set_property PACKAGE_PIN AP3  [get_ports {SPI_TX_DSA_CS[4]}]
  set_property PACKAGE_PIN AP2  [get_ports {SPI_TX_DSA_CS[5]}]
  set_property PACKAGE_PIN AN2  [get_ports {SPI_TX_DSA_CS[6]}]
  set_property PACKAGE_PIN AN1  [get_ports {SPI_TX_DSA_CS[7]}]
  set_property PACKAGE_PIN AN3  [get_ports {SPI_TX_DSA_CS[8]}]
  
  set_property PACKAGE_PIN AP13 [get_ports {SPI_MOSI}]
  set_property PACKAGE_PIN AP12 [get_ports {SPI_CLK}]
  set_property PACKAGE_PIN AN13 [get_ports {ORX_MOSI}]
  set_property PACKAGE_PIN AN12 [get_ports {ORX_CLK}]
  set_property PACKAGE_PIN AM8  [get_ports {SW_RXFB_VCTL}]
  set_property PACKAGE_PIN AM7  [get_ports {SW_RXFB_VCTL_N}]
  set_property PACKAGE_PIN AP11 [get_ports {PL_SYSREF_3M84_P}]
  set_property PACKAGE_PIN AP10 [get_ports {PL_SYSREF_3M84_N}]
  set_property PACKAGE_PIN AM10 [get_ports {RX_Gainblock_EN}]
# set_property PACKAGE_PIN AN10 [get_ports {}]
# set_property PACKAGE_PIN AN9  [get_ports {}]

  set_property PACKAGE_PIN AL9  [get_ports {PL_CLK1_122M88_P}]
  set_property PACKAGE_PIN AM9  [get_ports {PL_CLK1_122M88_N}]
# set_property PACKAGE_PIN AM12 [get_ports {}] 
# set_property PACKAGE_PIN AM11 [get_ports {}]
  set_property PACKAGE_PIN AK13 [get_ports {RX_Bypass[1]}]
  set_property PACKAGE_PIN AL13 [get_ports {RX_Bypass[2]}]
  set_property PACKAGE_PIN AL12 [get_ports {RX_Bypass[3]}]
  set_property PACKAGE_PIN AL11 [get_ports {RX_Bypass[4]}]
  set_property PACKAGE_PIN AK10 [get_ports {RX_Bypass[5]}]
  set_property PACKAGE_PIN AK9  [get_ports {RX_Bypass[6]}]
  set_property PACKAGE_PIN AJ11 [get_ports {RX_Bypass[7]}]
  set_property PACKAGE_PIN AK11 [get_ports {RX_Bypass[8]}]

  set_property PACKAGE_PIN AG12 [get_ports {RX_DSA_DATA[0]}]
  set_property PACKAGE_PIN AG11 [get_ports {RX_DSA_DATA[1]}]
  set_property PACKAGE_PIN AH10 [get_ports {RX_DSA_DATA[2]}]
  set_property PACKAGE_PIN AH9  [get_ports {RX_DSA_DATA[3]}]
  set_property PACKAGE_PIN AG10 [get_ports {RX_DSA_DATA[4]}]
  set_property PACKAGE_PIN AG9  [get_ports {RX_DSA_DATA[5]}]
  set_property PACKAGE_PIN AJ10 [get_ports {RX_DSA_DATA[6]}]
  

  set_property PACKAGE_PIN AJ9  [get_ports {PrDrvEN[1]}]
  set_property PACKAGE_PIN AF12 [get_ports {PrDrvEN[2]}] 
  set_property PACKAGE_PIN AF11 [get_ports {PrDrvEN[3]}]
  set_property PACKAGE_PIN AE11 [get_ports {PrDrvEN[4]}]  
  set_property PACKAGE_PIN AF10 [get_ports {TX_DSA_Enb}]
  set_property PACKAGE_PIN AH12 [get_ports {ORX_DSA_Enb}]
  
# --------------------------------------------------------------
# HP Banks 65 & 66 - IO Ports Physical Properties
# --------------------------------------------------------------
# Since these banks have both LVDCMOS18 and LVDS IOs, IOSTANDARD 
# cannot be set globally.

    # --- LVCMOS18 IO Ports ---
    set HP_LVCMOS18_allPorts [get_ports { 
										SW_RXFB_DV_EN[*] \
										SW_PA_RXFB_VCTL[*] \
										SW_PA_DV_VCTL[*] \
										PA_LNA_EN[*] \
                                        TRIGGER_FPGA \
                                        PGOOD_* \										
                                        ANT_CAL_SW_* \
										TX_Gainblock_EN \
                                        SPI_* \
										ORX_* \
                                        TX_DSA_* \
										ORX_DSA_* \
										EN_PA_PWR[*] \
										SW_RXFB_VCTL \
										SW_RXFB_VCTL_N \
										RX_Gainblock_EN \
										RX_Bypass[*] \
										RX_DSA_* \
                                        PrDrvEN[*]										
										}]

    set HP_LVCMOS18_iPorts [get_ports $HP_LVCMOS18_allPorts -filter {DIRECTION == IN}]
    set HP_LVCMOS18_oPorts [get_ports $HP_LVCMOS18_allPorts -filter {DIRECTION == OUT  || DIRECTION == INOUT}]
    
    set_property IOSTANDARD LVCMOS18    $HP_LVCMOS18_allPorts
    set_property DRIVE      8           $HP_LVCMOS18_oPorts
    set_property SLEW       SLOW        $HP_LVCMOS18_oPorts


    # --- LVDS IO Ports ---
    set_property IOSTANDARD     LVDS        [get_ports {PL_1PPS_P}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_1PPS_P}]
    set_property IOSTANDARD     LVDS        [get_ports {PL_1PPS_N}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_1PPS_N}]
    set_property IOSTANDARD     LVDS        [get_ports {PL_CLK2_122M88_P}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_CLK2_122M88_P}]
    set_property IOSTANDARD     LVDS        [get_ports {PL_CLK2_122M88_N}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_CLK2_122M88_N}]
	set_property IOSTANDARD     LVDS        [get_ports {PTP_SYS_500M_P}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PTP_SYS_500M_P}]
    set_property IOSTANDARD     LVDS        [get_ports {PTP_SYS_500M_N}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PTP_SYS_500M_N}]
	
	set_property IOSTANDARD     LVDS        [get_ports {PL_SYSREF_3M84_P}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_SYSREF_3M84_P}]
    set_property IOSTANDARD     LVDS        [get_ports {PL_SYSREF_3M84_N}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_SYSREF_3M84_N}]
	set_property IOSTANDARD     LVDS        [get_ports {PL_CLK1_122M88_P}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_CLK1_122M88_P}]
    set_property IOSTANDARD     LVDS        [get_ports {PL_CLK1_122M88_N}]
    set_property DIFF_TERM_ADV  TERM_100    [get_ports {PL_CLK1_122M88_N}]
	
# ==============================================================
# HD Bank 88
# ==============================================================
  set_property PACKAGE_PIN K15     [get_ports {FPGA_TEST[0]}]
  set_property PACKAGE_PIN K14     [get_ports {FPGA_TEST[1]}]
  set_property PACKAGE_PIN H15     [get_ports {SFP_LOS[0]}]
  set_property PACKAGE_PIN H14     [get_ports {SFP_TX_FAULT[1]}]
  set_property PACKAGE_PIN J14     [get_ports {SFP_DETECT_N[0]}]
  set_property PACKAGE_PIN H13     [get_ports {SFP_TX_EN_N[1]}]
  set_property PACKAGE_PIN G13     [get_ports {I2C_SDA[1]}]
  set_property PACKAGE_PIN H11     [get_ports {I2C_SCL[1]}]
  set_property PACKAGE_PIN F14     [get_ports {SFP_DETECT_N[1]}]
  set_property PACKAGE_PIN F13     [get_ports {SFP_LOS[1]}]
  set_property PACKAGE_PIN F12     [get_ports {ALARM[1]}]
  set_property PACKAGE_PIN G12     [get_ports {ALARM[2]}]
  set_property PACKAGE_PIN E14     [get_ports {ALARM[3]}]
  set_property PACKAGE_PIN D14     [get_ports {ALARM[4]}]
# set_property PACKAGE_PIN D12     [get_ports {}]
  set_property PACKAGE_PIN D13     [get_ports {SW_PA_LNA_VCTL[1]}]
  set_property PACKAGE_PIN C13     [get_ports {SW_PA_LNA_VCTL[2]}]
  set_property PACKAGE_PIN C14     [get_ports {AISG_UART1_RXD}]
  set_property PACKAGE_PIN B13     [get_ports {AISG_UART1_TXD}]
  set_property PACKAGE_PIN A14     [get_ports {COLD_RST_REQ_N}]
  set_property PACKAGE_PIN B12     [get_ports {UART_DE_REN}]
  set_property PACKAGE_PIN A12     [get_ports {PSU_ALARM}]

# ==============================================================
# HD Bank 89
# ==============================================================
# Byte 0
  set_property PACKAGE_PIN C11     [get_ports {AISG_VDD_ENN}]
  set_property PACKAGE_PIN B11     [get_ports {AISG_VDD_SW_ENN}]
  set_property PACKAGE_PIN C10     [get_ports {AISG_PGOOD}]
  set_property PACKAGE_PIN B10     [get_ports {I2C_SCL[2]}]
  set_property PACKAGE_PIN A10     [get_ports {I2C_SDA[2]}]
  set_property PACKAGE_PIN A9      [get_ports {SFP_LED[0]}]
  set_property PACKAGE_PIN D9      [get_ports {SFP_LED[1]}]
  set_property PACKAGE_PIN C9      [get_ports {SFP_RS[1]}]
  
# Byte 1 
  set_property PACKAGE_PIN E11     [get_ports {I2C_SCL[3]}]
  set_property PACKAGE_PIN D11     [get_ports {I2C_SDA[3]}]
  set_property PACKAGE_PIN E10     [get_ports {RESETN_PA[0]}]
  set_property PACKAGE_PIN A13     [get_ports {RESETN_PA[1]}]
  set_property PACKAGE_PIN E9      [get_ports {PA_CTRL_IN[1]}]
  set_property PACKAGE_PIN F10     [get_ports {PA_CTRL_IN[2]}]
  set_property PACKAGE_PIN F9      [get_ports {PA_CTRL_IN[3]}]
  set_property PACKAGE_PIN G11     [get_ports {PA_CTRL_IN[4]}]
  set_property PACKAGE_PIN G10     [get_ports {SFP_RS[0]}]
  
# Byte 2 
  set_property PACKAGE_PIN H10     [get_ports {PA_CTRL_IN[5]}]
  set_property PACKAGE_PIN H9      [get_ports {PA_CTRL_IN[6]}]
  set_property PACKAGE_PIN K11     [get_ports {PA_CTRL_IN[7]}]
  set_property PACKAGE_PIN K10     [get_ports {PA_CTRL_IN[8]}]
  set_property PACKAGE_PIN J11     [get_ports {SFP_TX_EN_N[0]}]
  set_property PACKAGE_PIN K12     [get_ports {SFP_TX_FAULT[0]}]
  set_property PACKAGE_PIN J12     [get_ports {I2C_SDA[0]}]
  set_property PACKAGE_PIN J13     [get_ports {I2C_SCL[0]}]
  
# --------------------------------------------------------------
# HD Banks 88 & 89 - IO Ports Physical Properties
# --------------------------------------------------------------
    set HP_LVCMOS33_allPorts [ get_ports { 
										FPGA_TEST* \
                                        SFP_LOS* \
										SFP_TX_FAULT* \
										SFP_DETECT_N* \
										SFP_TX_EN_N* \
										SFP_RS* \
										SFP_LED* \
										I2C_* \
										ALARM[*] \
										SW_PA_LNA_VCTL* \
										COLD_RST_REQ_N \
										UART_DE_REN \
										PSU_ALARM \										
										AISG_* \
										RESETN_PA[*] \
										PA_CTRL*        										    
										}]

    set HP_LVCMOS33_iPorts [get_ports $HP_LVCMOS33_allPorts -filter {DIRECTION == IN}]
    set HP_LVCMOS33_oPorts [get_ports $HP_LVCMOS33_allPorts -filter {DIRECTION == OUT  || DIRECTION == INOUT}]
    
    set_property IOSTANDARD LVCMOS33    $HP_LVCMOS33_allPorts
    set_property DRIVE      8           $HP_LVCMOS33_oPorts
    set_property SLEW       SLOW        $HP_LVCMOS33_oPorts
	
# ==============================================================
# ==============================================================

# ==============================================================
#  Bank 128
# ==============================================================

  set_property PACKAGE_PIN N30  [get_ports {SFP0_TX_T}]
  set_property PACKAGE_PIN N31  [get_ports {SFP0_TX_C}]
  set_property PACKAGE_PIN P33  [get_ports {SFP0_RX_T}]
  set_property PACKAGE_PIN P34  [get_ports {SFP0_RX_C}]
 
 #set_property PACKAGE_PIN L30  [get_ports {SFP1_TX_T}]
 #set_property PACKAGE_PIN L31  [get_ports {SFP1_TX_C}]
 #set_property PACKAGE_PIN M33  [get_ports {SFP1_RX_T}]
 #set_property PACKAGE_PIN M34  [get_ports {SFP1_RX_C}]

  set_property PACKAGE_PIN M28  [get_ports {MGTY_REF_CLK_P}]
  set_property PACKAGE_PIN M29  [get_ports {MGTY_REF_CLK_N}]
# set_property PACKAGE_PIN K28  [get_ports {FH_RECOV_CLK_P}]
# set_property PACKAGE_PIN K29  [get_ports {FH_RECOV_CLK_N}]
  
# set_property PACKAGE_PIN J30  [get_ports {}]
# set_property PACKAGE_PIN J31  [get_ports {}]
# set_property PACKAGE_PIN K33  [get_ports {}]
# set_property PACKAGE_PIN K34  [get_ports {}]
# set_property PACKAGE_PIN G30  [get_ports {}]
# set_property PACKAGE_PIN G31  [get_ports {}]
# set_property PACKAGE_PIN H33  [get_ports {}]
# set_property PACKAGE_PIN H34  [get_ports {}]

current_instance -quiet