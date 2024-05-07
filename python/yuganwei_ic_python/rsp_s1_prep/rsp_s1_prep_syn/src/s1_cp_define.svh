`ifndef _COMP_DEFINE_SVH_
  `define  _COMP_DEFINE_SVH_
    `define L1_BANK_NUM   14
    `define L1_DATA_WIDTH 128
    `define L1_ADDR_WIDTH 18
    `define L1_STRB_WIDTH 16

// 1. comp_send_rd data_count width
// 2. comp_pipo rd_address width
// 3. comp_send_wr comp_cnt width
    `define BFP_DATA_CNT_WIDTH     3
// 1. mark which channel is
    `define BFP_CHANNEL_NUM        4
    `define BFP_CHANNEL_WIDTH      $clog2(`BFP_CHANNEL_NUM)
    `define BFP_CHANNEL_NUM_3      3
    `define BFP_CHANNEL_WIDTH_3    $clog2(`BFP_CHANNEL_NUM_3)
// 1. more 1bit than comfigure sscnt
    `define BFP_SAMP_NUM_WIDTH     14
// 1. read once, include 4 32bit sample or 2 64bit sample
    `define BFP_SAMP_NUM_32        4
    `define BFP_SAMP_NUM_64        `BFP_SAMP_NUM_32/2
// 1. every line include 16 Byte
    `define BFP_BYTE_ADDR          16

// 1. before compression, data width is 32
// 1. after compression, data width is 64
    `define BFP_DATA_BF_COMP_WIDTH `L1_DATA_WIDTH/4
    `define BFP_DATA_AF_COMP_WIDTH `L1_DATA_WIDTH/2
// 1. write or read memory by pingpong
    `define BFP_MEM_DEPTH          4

// 1.according to rambank read delay
    `define BFP_RD_DELAY           2

// 1. 64bit sampel ~wrpi_en & ~wrpo_en at last 4
// 2. 32bit sample ~wrpi_en & ~wrpo_en at last 8+4
    `define BFP_FREE_WIDTH         4
    `define BFP_MEM_WR_ADDR_WIDTH  2

// 1. find the first "1" place
    `define BFP_MAX_WIDTH          $clog2(`BFP_DATA_BF_COMP_WIDTH)
// 1. mantissa width
    `define BFP_MANTI_WIDTH_64     15
    `define BFP_MANTI_WIDTH_32     7
// 1. exponent width
    `define BFP_EXP_WIDTH          4

`endif
