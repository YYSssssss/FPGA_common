// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (win64) Build 3247384 Thu Jun 10 19:36:33 MDT 2021
// Date        : Fri Apr 12 16:31:48 2024
// Host        : DESKTOP-KHT2SE1 running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim
//               d:/yuganwei/fpga_sim/IIC_sim/design/camera_mem_config/camera_mem_config_sim_netlist.v
// Design      : camera_mem_config
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xczu15eg-ffvb1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "camera_mem_config,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module camera_mem_config
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [0:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [4:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [4:0]addra;
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
  wire [4:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [4:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "5" *) 
  (* C_ADDRB_WIDTH = "5" *) 
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
  (* C_INIT_FILE = "camera_mem_config.mem" *) 
  (* C_INIT_FILE_NAME = "camera_mem_config.mif" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "1" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "32" *) 
  (* C_READ_DEPTH_B = "32" *) 
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
  (* C_WRITE_DEPTH_A = "32" *) 
  (* C_WRITE_DEPTH_B = "32" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "zynquplus" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  camera_mem_config_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0}),
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
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[4:0]),
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
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[4:0]),
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
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 21136)
`pragma protect data_block
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
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
