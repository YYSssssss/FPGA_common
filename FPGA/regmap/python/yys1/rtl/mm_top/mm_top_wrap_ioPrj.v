// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.1 (win64) Build 2883519 Mon May  4 20:18:30 MDT 2020
// Date        : Tue May 26 17:57:09 2020
// Host        : USSTP00045487 running 64-bit major release  (build 9200)
// Command     : write_verilog -mode pin_planning -force -port_diff_buffers
//               C:/Projects/3Rivers/Firmware/RFSoC/MM/vivado/mm_io_v20.1_ER/mm_io.v
// Design      : ios
// Purpose     : Stub declaration of top-level module interface
// Device      : xczu47dr-fsve1156-2-i-es1
// --------------------------------------------------------------------------------
module mm_top_wrap (DEBUG_LED, ALARM, PAAM_UART_TXD, UART_PAAM_RXD, CLK_MM_PAAM_N, CLK_MM_PAAM_P, CLK_PAAM_MM_N, COLD_RST_REQ_N, MGTY_REF_CLK_N, MGTY_REF_CLK_P, RST_PAAM_N, IRQ_READ_DATA_VALID, IRQ_URGENT_PAAM, CLK_PAAM_MM_P, UART_MPTB_TXD_TRIG, UART_MPTB_RXD, SPI_TX_DSA_CS, SPI_MOSI, SPI_CLK, H_DSA_EN_N, V_DSA_EN_N, I2C1_SFP_SCL, I2C1_SFP_SDA, PAAM_FPGA_CCLK, PAAM_FPGA_DATA, PAAM_FPGA_PROGRAM_N, PAAM_FPGA_DONE, PAAM_FPGA_INIT_N, SPI_PAAM_CLK, SPI_PAAM_MISO, SPI_PAAM_MOSI, SPI_PAAM_CS, PL_1PPS_P, PL_1PPS_N, PL_CLK1_245M76_P, PL_CLK1_245M76_N, PL_CLK2_245M76_P, PL_CLK2_245M76_N, PL_CLK_10M_P, PL_CLK_10M_N, PL_SYSREF_2M84_P, PL_SYSREF_2M84_N, MPTB_1PPS_PL_IN, PTP_SYS_500M_P, PTP_SYS_500M_N, FH_RECOV_CLK_P, FH_RECOV_CLK_N, PL_SYNCPULSE_P, PL_SYNCPULSE_N, AGC_CMD_PANEL0, AGC_CMD_PANEL1, AGC_CMD_PANEL2, AGC_CMD_PANEL3, AGC_CMD_VALID, PAAM_DATA, PAAM_SYMBOL_START, PAAM_DATA_VALID, SFP_LED, SFP_LOS, SFP_RS, SFP_TX_EN_N, SFP_TX_FAULT, SFP_DETECT_N, SFP_TX_P, SFP_TX_N, SFP_RX_P, SFP_RX_N, TX_H_AMP1_CTRL, TX_V_AMP1_CTRL, TX_H_AMP2_CTRL, TX_V_AMP2_CTRL, RX_H_AMP_CTRL, RX_V_AMP_CTRL, RX_H_SW_MODE_SEL, RX_V_SW_MODE_SEL, TX_H_SW_MODE_SEL, TX_V_SW_MODE_SEL);
  output [1:0] DEBUG_LED;
  input [2:1] ALARM;
  output PAAM_UART_TXD;
  input UART_PAAM_RXD;
  output CLK_MM_PAAM_N;
  output CLK_MM_PAAM_P;
  input CLK_PAAM_MM_N;
  output COLD_RST_REQ_N;
  input MGTY_REF_CLK_N;
  input MGTY_REF_CLK_P;
  output RST_PAAM_N;
  input IRQ_READ_DATA_VALID;
  input IRQ_URGENT_PAAM;
  input CLK_PAAM_MM_P;
  output UART_MPTB_TXD_TRIG;
  input UART_MPTB_RXD;
  output [4:1] SPI_TX_DSA_CS;
  output SPI_MOSI;
  output SPI_CLK;
  output H_DSA_EN_N;
  output V_DSA_EN_N;
  output [3:0] I2C1_SFP_SCL;
  inout [3:0] I2C1_SFP_SDA;
  output PAAM_FPGA_CCLK;
  output PAAM_FPGA_DATA;
  output PAAM_FPGA_PROGRAM_N;
  input PAAM_FPGA_DONE;
  input PAAM_FPGA_INIT_N;
  output SPI_PAAM_CLK;
  input SPI_PAAM_MISO;
  output SPI_PAAM_MOSI;
  output SPI_PAAM_CS;
  input PL_1PPS_P;
  input PL_1PPS_N;
  input PL_CLK1_245M76_P;
  input PL_CLK1_245M76_N;
  input PL_CLK2_245M76_P;
  input PL_CLK2_245M76_N;
  input PL_CLK_10M_P;
  input PL_CLK_10M_N;
  input PL_SYSREF_2M84_P;
  input PL_SYSREF_2M84_N;
  input MPTB_1PPS_PL_IN;
  input PTP_SYS_500M_P;
  input PTP_SYS_500M_N;
  output FH_RECOV_CLK_P;
  output FH_RECOV_CLK_N;
  output PL_SYNCPULSE_P;
  output PL_SYNCPULSE_N;
  output [3:0] AGC_CMD_PANEL0;
  output [3:0] AGC_CMD_PANEL1;
  output [3:0] AGC_CMD_PANEL2;
  output [3:0] AGC_CMD_PANEL3;
  output AGC_CMD_VALID;
  output [9:0] PAAM_DATA;
  output [3:0] PAAM_SYMBOL_START;
  output PAAM_DATA_VALID;
  output [3:0] SFP_LED;
  input [3:0] SFP_LOS;
  output [1:0] SFP_RS;
  output [3:0] SFP_TX_EN_N;
  input [3:0] SFP_TX_FAULT;
  input [3:0] SFP_DETECT_N;
  output [3:0] SFP_TX_P;
  output [3:0] SFP_TX_N;
  input [3:0] SFP_RX_P;
  input [3:0] SFP_RX_N;
  output [4:1] TX_H_AMP1_CTRL;
  output [4:1] TX_V_AMP1_CTRL;
  output TX_H_AMP2_CTRL;
  output TX_V_AMP2_CTRL;
  output RX_H_AMP_CTRL;
  output RX_V_AMP_CTRL;
  output [2:1] RX_H_SW_MODE_SEL;
  output [2:1] RX_V_SW_MODE_SEL;
  output [2:1] TX_H_SW_MODE_SEL;
  output [2:1] TX_V_SW_MODE_SEL;

  // internal wires associated with differential buffers

  wire CLK_MM_PAAM_OBUFDS_I;
  wire CLK_PAAM_MM_IBUFDS_O;
  wire PL_1PPS_IBUFDS_O;
  wire PL_CLK1_245M76_IBUFDS_O;
  wire PL_CLK2_245M76_IBUFDS_O;
  wire PL_CLK_10M_IBUFDS_O;
  wire PL_SYSREF_2M84_IBUFDS_O;
  wire PTP_SYS_500M_IBUFDS_O;
  wire FH_RECOV_CLK_OBUFDS_I;
  wire PL_SYNCPULSE_OBUFDS_I;

  // differential buffers

  OBUFDS CLK_MM_PAAM_OBUFDS (.O(CLK_MM_PAAM_P), .OB(CLK_MM_PAAM_N), .I(CLK_MM_PAAM_OBUFDS_I));

  IBUFDS CLK_PAAM_MM_IBUFDS (.I(CLK_PAAM_MM_P), .IB(CLK_PAAM_MM_N), .O(CLK_PAAM_MM_IBUFDS_O));

  IBUFDS PL_1PPS_IBUFDS (.I(PL_1PPS_P), .IB(PL_1PPS_N), .O(PL_1PPS_IBUFDS_O));

  IBUFDS PL_CLK1_245M76_IBUFDS (.I(PL_CLK1_245M76_P), .IB(PL_CLK1_245M76_N), .O(PL_CLK1_245M76_IBUFDS_O));

  IBUFDS PL_CLK2_245M76_IBUFDS (.I(PL_CLK2_245M76_P), .IB(PL_CLK2_245M76_N), .O(PL_CLK2_245M76_IBUFDS_O));

  IBUFDS PL_CLK_10M_IBUFDS (.I(PL_CLK_10M_P), .IB(PL_CLK_10M_N), .O(PL_CLK_10M_IBUFDS_O));

  IBUFDS PL_SYSREF_2M84_IBUFDS (.I(PL_SYSREF_2M84_P), .IB(PL_SYSREF_2M84_N), .O(PL_SYSREF_2M84_IBUFDS_O));

  IBUFDS PTP_SYS_500M_IBUFDS (.I(PTP_SYS_500M_P), .IB(PTP_SYS_500M_N), .O(PTP_SYS_500M_IBUFDS_O));

  OBUFDS FH_RECOV_CLK_OBUFDS (.O(FH_RECOV_CLK_P), .OB(FH_RECOV_CLK_N), .I(FH_RECOV_CLK_OBUFDS_I));

  OBUFDS PL_SYNCPULSE_OBUFDS (.O(PL_SYNCPULSE_P), .OB(PL_SYNCPULSE_N), .I(PL_SYNCPULSE_OBUFDS_I));


endmodule
