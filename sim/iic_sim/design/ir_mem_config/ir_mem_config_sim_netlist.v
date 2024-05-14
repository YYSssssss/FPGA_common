// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Apr 12 16:21:18 2024
// Host        : DESKTOP-KHT2SE1 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/yuganwei/fpga_sim/IIC_sim/design/ir_mem_config/ir_mem_config_sim_netlist.v
// Design      : ir_mem_config
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ir_mem_config,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module ir_mem_config
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [5:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [5:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire [0:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [5:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [5:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "6" *) 
  (* C_ADDRB_WIDTH = "6" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "9" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "1" *) 
  (* C_COUNT_36K_BRAM = "0" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     3.217997 mW" *) 
  (* C_FAMILY = "zynquplus" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "1" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "ir_mem_config.mem" *) 
  (* C_INIT_FILE_NAME = "ir_mem_config.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "64" *) 
  (* C_READ_DEPTH_B = "64" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "0" *) 
  (* C_USE_BYTE_WEB = "0" *) 
  (* C_USE_DEFAULT_DATA = "0" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "1" *) 
  (* C_WEB_WIDTH = "1" *) 
  (* C_WRITE_DEPTH_A = "64" *) 
  (* C_WRITE_DEPTH_B = "64" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  ir_mem_config_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[5:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[5:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb(1'b0),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web(1'b0));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
sbNGmomEbP78s1hfxgX3P1Jo01EKJk0i0C7iGpF+Yibr9EK0s4mcIifHDN/ag4jpPwW3bPllMHvn
U8AEY3mO8hCXVVoilrcRuCaEna/98GycCzy4G7FnYMfowsJb5k9ifRdE2jnurzeTLFbupUSpDF0H
Rl3Ci3DTGeExAZZ9UQE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zZZZoIprBFYfDWmCCcduELBM7HU98/+rvP9g8+y1mYyD3r3HEDm4ZwehwZvPoYWqoGXYoFqWZh3h
utt0abIfUW9/oF2vJ9hXn7nArtcm/Eui18rPYqp3aj/AItPNVXojk9zp7uFZLPTqcyig5v3Jtenl
qPnLi1Z84ZCW7NIRw6Y0bgmw6z26E8VPbYrZHs+0YW8Sztjo6CdIrQeEL5WBDolA0aHoKHWRZyFs
l5eRDmBAolj2uF07t/3eY3J7cYJmEDaoZ0TR1qcz25VFNu0OlcrEJ19IT+QdAxTah4jqJtknGZrT
6lUMwDZ7dBQwF1EuaE6p90gGNERhGAsbHLdvaw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
KUbz0Iu2faeWqD6HFeuGLtSOAlqZmpKCCJfzym8tkcWUUNgNMn2mYvx6PTM7j4tyig8JdUG3uZYs
NfPgAsNXQtTI7b19u9CkMks9jR+oEzX1rW7QtTvSj/nHZLg2smoFwuB5Ieb7/B8IIs1NTUrIz6Rc
itLQVG+L+GMziamsrx4=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
G7XYdRx9VGclyxTEtwMG+rjJHV8bfBxEGdkcN82UL3koN3Dt0M5AWkzEvHcskt1W0hTOjyYgmvYj
/p70w1nz96tlg226+e4UubpRmBH9QXBBX6UmqIwSiHj9H+XI1yNfTIdlwBKGQvfzwCAMwBwrrrGL
/804k5Ux3RhWRvwezZB4+sj9DFm4akREVXmNpfeqjI2X02LU/MxWMUbKxvjJnD9YxikAAO6ccTd6
8DKv76V76MEFVyXc7E2FeQDToW3lqkRTa6MTpIXbYSekRihQC+qPVuhPUneA4kepvQDfgFYE8/Ir
gu5gK+s/qNfuXhJUAqyLjslrUcY4+XD9ckpSvQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YXkYRXpUPv/tETnwnThdQ46UaPmI23lN9vrxHQjIOhq3WNJCuz7TYZK9hyzSdo6k0U6QE9ihQy2L
rYZg68RGbrK8bzlcnQ41r18LZb4GYlAn9PH7IrF1B+aHm3578doOZHf8wzUE2s+d1aHQIn6VIZjL
14pCTAjErJfMO13fgX6h8sgxb4GFC3eIORmkrq2J/fB9HALyh/qdGiLi7DejMfmdsssbOcPQTZUh
6Belf7fHTkIEr9B44rFZgMyrMVx4N9p0XpXD3JPe7Xeg6a3jxdqxHATaMuLdIa4s+ZiAz1TRx0EO
FFihCnLLb7weBBITQyTIncRL817BrF/ZXZD8Yw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g7FbNw1ywd4TBNHq8OmK/4zoKI/t7vKmyT8R8SeiyUtKywhn0/7DZ/lV0Lf4IhY8X5MYsKtOQ5l6
DIl3fxtOhxpi8NHn9Nw3Nfb8NnS38Zuy6DSpwOL0f/GSmUSf2/YdB5Ben6xibQT0Oy//oBl5/1kR
pV5fWjj8WRgI6cnmfyj3g1MxepxPu1A/UHxlm1/i9yUHHi114N/hEQ0iujjrn6GxfZSiJUVF+r6c
rnxD//eOAl/YaxhdU/KhUkfsMn+MxtA5m6hTYYE0bnze8rpmEU5UGYKyY0p8KUs+MgsdTe+m/7gV
HSf6puBqQmEa1qksRfl742aL9B9y169or7Jp9Q==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kd1A2zIphLxXB0RyfHIqLkHXfWl0n38vROERuDghYrhK0ItcWGEP0XBrri6k1VZCSPYwiSu//pM6
83BfcPKbk09/A+ksvDIa3xS8Tg7DJK2AS+0pdnzBSjVWh+QD+glA3Hjk6LG9OMbjXyqD3hnMKacA
VRMwxKktV+KT5NXj5a7fMxXjo9exc0xM+woUJiSYs8onoUSwfBeH5/xhUy+iu+w0/OOydQE2LXZ0
1y+RObiz5C22dD4GGCfuvUCGAthYpUf633ZxRYN45mmAn5PxPsH4o+l2GhH/50Gu/VPVoAWDhgXQ
e93oPri++HinkK2uvDhDl4PI9HtRkq11Ky3uXQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
gDrrFgXHVyBo+Cn0bYn+SOSOCXPg7besukY6l0JmA/nu4gap105Wxbg11c7TJZ9ctHVLc5DXAxr+
EIvFpAIepoZBREtMjTlaIdNJ8k1nUpwAv2jaQeseq1TudTjugV1jtOYYk0RKd88z/6SJ8t9urDW0
yKqsfEWU3PwGcUGHOWtTn2hfAceNznmEIFWLmFmzSQJ1hQNdsIQn3jHnfMVYu8cAz5xvPVQWYyJW
pMHXhNYk6GyAjIshh991slb1g01K1ilR2tKD1EmxH5WGrX9BEUqBjHQo6uluC/d3mvcEQ5nJ1v+P
hIlj4qzUQT1wXjpk6d/BvNx7LyWmj5iq35dzNm+cdhfGwaFGG//vgmB6D/dFfs2BYSjHsa6VlpVM
7e2OgoFenuG9p1SVPI6gAs2MuFtnDKfxW7jS3RGhvsquS3tg1iFCDH/OU7E5aWfY7twF3yyN6G10
l72RZw62DfNoCdyUMG9sA8nc4qf6dEhyrr5S6XxpJhoBDJvkeq0TCUQZ

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XR7vRF1m+9DS2Pv4r/O4uHwmvtXkChnKbsJCYczn1dvkZbcZSbBm/2UH78dXUaNorOh9XAuCvSjb
ER73y7e0anAfaIf1tJ9Y9pIb8EuNxGS/Pqdvg36cWarwGac9tsscdv/HWfb5Z+qWEk0/uFcLI7pH
CZO7fF2/ONQjA0NtUFBjW4idlx8WrySIuJgDs4jyGkMhbHR3U/ghF1YhMhwgwsbbcptfC1XLrIqQ
OecZnZu8E2hyc5eK/ccYdKcHnXoL55z1p5amI6Fuvz0wKTz2QQ/mwXodfGjEC1ZRWwTn7zCFM91M
qrA1Is49i6pSa7/VICjgn8ULMT1oKGfJLPm7hg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21152)
`pragma protect data_block
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
B5RKdbs=
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
