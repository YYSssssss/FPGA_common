//-----------------------------------------------------------------------------
// File: rsp_s2_dma_defines.vh
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: DMA global defines
// Modification history:
// $Log$
//   Jichen 7/7/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------
`ifndef _S2_DMA_DEFINES_VH_
`define _S2_DMA_DEFINES_VH_

`include "rsp_common_defines.vh"

`define S2_DMA                   1

`define S2_DMA_BURST_SIZE        $clog2(`L2_STRB_WIDTH)
`define S2_DMA_OUT_BITS          8
`define S2_DMA_TIMEOUT_BITS      12
`define S2_DMA_GM_BUFFER_DEPTH   512
`define S2_DMA_LM_BUFFER_DEPTH   16
`define S2_DMA_CMD_DEPTH         16

// DMA REG
`define S2_DMA_PCNT_BITS         8
`define S2_DMA_SLEN_BITS         16
`define S2_DMA_SCNT_BITS         14
`define S2_DMA_FCNT_BITS         14
`define S2_DMA_GM_ADDR_BITS      36
`define S2_DMA_GM_BASE_BITS      (`S2_DMA_GM_ADDR_BITS - $clog2(`L2_STRB_WIDTH)) // 32
`define S2_DMA_LM_ADDR_BITS      `L2_ADDR_WIDTH // 32
`define S2_DMA_LM_ADDR_ALIGN     `L2_ADDR_ALIGN // 4
`define S2_DMA_LM_BASE_BITS      (`S2_DMA_LM_ADDR_BITS - `S2_DMA_LM_ADDR_ALIGN) // 28

`define S2_DMA_RD_STATUS_BITS    1
`define S2_DMA_RD_IRQ_BITS       4

`define S2_DMA_WR_STATUS_BITS    1
`define S2_DMA_WR_IRQ_BITS       5

`endif
