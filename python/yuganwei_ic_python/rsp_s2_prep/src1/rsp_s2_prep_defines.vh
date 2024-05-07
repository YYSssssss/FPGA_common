`ifndef _RSP_COMMON_DEFINES_VH_
`define _RSP_COMMON_DEFINES_VH_

`define L1_DATA_WIDTH               128
`define L1_STRB_WIDTH               (`L1_DATA_WIDTH / 8)
`define L1_BANK_DEPTH               1024
`define L1_SUBBANK_DEPTH            512
`define L1_BANK_ADDR_WIDTH          $clog2(`L1_BANK_DEPTH)
`define L1_SUBBANK_ADDR_WIDTH       $clog2(`L1_SUBBANK_DEPTH)
`define L1_BANK_NUM                 14
`define L1_ADDR_WIDTH               18
`define L1_ADDR_ALIGN               $clog2(`L1_STRB_WIDTH)
`define L1_BASE_ADDR_WIDTH          (`L1_ADDR_WIDTH - `L1_ADDR_ALIGN)
`define L1_RD_DELAY                 4


`define L2_DATA_WIDTH               128
`define L2_STRB_WIDTH               (`L2_DATA_WIDTH / 8)
`define L2_BANK_DEPTH               8192
`define L2_BANK_ADDR_WIDTH          $clog2(`L2_BANK_DEPTH)
`define L2_BANK_STRB_ADDR_WIDTH     (`L2_BANK_ADDR_WIDTH + $clog2(`L2_STRB_WIDTH))
`define L2_BANK_NUM                 20
`define L2_ADDR_WIDTH               32
`define L2_ADDR_ALIGN               $clog2(`L2_STRB_WIDTH)
`define L2_BASE_ADDR_WIDTH          (`L2_ADDR_WIDTH - `L2_ADDR_ALIGN)
`define L2_RD_DELAY                 2
`define L2_MAX_WORD_CNT             16384

`define RSP_MAX_BURST_LEN           31
`define RSP_EVENT_BITS              16
`define RSP_IRQ_BITS                4

`define AHB_DW                      32
`define AHB_AW                      32

`endif