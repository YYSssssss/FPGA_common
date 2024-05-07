
`define GM0_CSR0_ADDR                                      32'h0
`define GM0_CSR0_SLEN_BITS                                 15:0
`define GM0_CSR0_SLEN_DFLT                                 16'h0

`define GM1_CSR0_ADDR                                      32'h4
`define GM1_CSR0_SCNT_BITS                                 13:0
`define GM1_CSR0_SCNT_DFLT                                 14'h0

`define GM2_CSR0_ADDR                                      32'h8
`define GM2_CSR0_FCNT_BITS                                 13:0
`define GM2_CSR0_FCNT_DFLT                                 14'h0

`define GM3_CSR0_ADDR                                      32'hc
`define GM3_CSR0_PCNT_BITS                                 7:0
`define GM3_CSR0_PCNT_DFLT                                 8'h0

`define GM4_CSR0_ADDR                                      32'h10
`define GM4_CSR0_OUTS_MAX_BITS                             15:8
`define GM4_CSR0_OUTS_MAX_DFLT                             8'h0
`define GM4_CSR0_BURST_LEN_BITS                            7:0
`define GM4_CSR0_BURST_LEN_DFLT                            8'h0

`define GM5_CSR0_ADDR                                      32'h14
`define GM5_CSR0_BASE_ADDR_BITS                            31:0
`define GM5_CSR0_BASE_ADDR_DFLT                            32'h0

`define GM6_CSR0_ADDR                                      32'h18
`define GM6_CSR0_SIDX_BITS                                 31:0
`define GM6_CSR0_SIDX_DFLT                                 32'h0

`define GM7_CSR0_ADDR                                      32'h1c
`define GM7_CSR0_FIDX_BITS                                 31:0
`define GM7_CSR0_FIDX_DFLT                                 32'h0

`define GM8_CSR0_ADDR                                      32'h20
`define GM8_CSR0_TIMEOUT_CNT_BITS                          11:0
`define GM8_CSR0_TIMEOUT_CNT_DFLT                          12'h7ff

`define GM9_CSR0_ADDR                                      32'h24
`define GM9_CSR0_AXI_ID_BITS                               7:0
`define GM9_CSR0_AXI_ID_DFLT                               8'h0

`define LM0_CSR0_ADDR                                      32'h30
`define LM0_CSR0_SLEN_BITS                                 15:0
`define LM0_CSR0_SLEN_DFLT                                 16'h0

`define LM1_CSR0_ADDR                                      32'h34
`define LM1_CSR0_SCNT_BITS                                 13:0
`define LM1_CSR0_SCNT_DFLT                                 14'h0

`define LM2_CSR0_ADDR                                      32'h38
`define LM2_CSR0_FCNT_BITS                                 13:0
`define LM2_CSR0_FCNT_DFLT                                 14'h0

`define LM3_CSR0_ADDR                                      32'h3c
`define LM3_CSR0_PCNT_BITS                                 7:0
`define LM3_CSR0_PCNT_DFLT                                 8'h0

`define LM4_CSR0_ADDR                                      32'h40
`define LM4_CSR0_OUTS_MAX_BITS                             15:8
`define LM4_CSR0_OUTS_MAX_DFLT                             8'h0
`define LM4_CSR0_BURST_LEN_BITS                            7:0
`define LM4_CSR0_BURST_LEN_DFLT                            8'h0

`define LM5_CSR0_ADDR                                      32'h44
`define LM5_CSR0_BASE_ADDR_BITS                            27:0
`define LM5_CSR0_BASE_ADDR_DFLT                            28'h0

`define LM6_CSR0_ADDR                                      32'h48
`define LM6_CSR0_SIDX_BITS                                 27:0
`define LM6_CSR0_SIDX_DFLT                                 28'h0

`define LM7_CSR0_ADDR                                      32'h4c
`define LM7_CSR0_FIDX_BITS                                 27:0
`define LM7_CSR0_FIDX_DFLT                                 28'h0

`define LM8_CSR0_ADDR                                      32'h50
`define LM8_CSR0_TIMEOUT_CNT_BITS                          11:0
`define LM8_CSR0_TIMEOUT_CNT_DFLT                          12'h7ff

`define LM9_CSR0_ADDR                                      32'h54
`define LM9_CSR0_AXI_ID_BITS                               7:0
`define LM9_CSR0_AXI_ID_DFLT                               8'h0

`define EN_CSR0_ADDR                                       32'h58
`define EN_CSR0_DECOMP_BITS                                8
`define EN_CSR0_DECOMP_DFLT                                1'b0
`define EN_CSR0_INDEX_BITS                                 0
`define EN_CSR0_INDEX_DFLT                                 1'b0

`define INDEX_CSR0_ADDR                                    32'h5c
`define INDEX_CSR0_BASE_ADDR_BITS                          27:0
`define INDEX_CSR0_BASE_ADDR_DFLT                          28'h0

`define FSM_CSR0_ADDR                                      32'h60
`define FSM_CSR0_MEM_CLAIM_BITS                            16
`define FSM_CSR0_MEM_CLAIM_DFLT                            1'b0
`define FSM_CSR0_MEM_PIPO_NUM_WR_BITS                      15:13
`define FSM_CSR0_MEM_PIPO_NUM_WR_DFLT                      3'h0
`define FSM_CSR0_MEM_PIPO_NUM_RD_BITS                      12:10
`define FSM_CSR0_MEM_PIPO_NUM_RD_DFLT                      3'h0
`define FSM_CSR0_MEM_BASE_IDX_WR_BITS                      9:5
`define FSM_CSR0_MEM_BASE_IDX_WR_DFLT                      5'h0
`define FSM_CSR0_MEM_BASE_IDX_RD_BITS                      4:0
`define FSM_CSR0_MEM_BASE_IDX_RD_DFLT                      5'h0

`define GM0_CSR1_ADDR                                      32'h400
`define GM0_CSR1_SLEN_BITS                                 15:0
`define GM0_CSR1_SLEN_DFLT                                 16'h0

`define GM1_CSR1_ADDR                                      32'h404
`define GM1_CSR1_SCNT_BITS                                 13:0
`define GM1_CSR1_SCNT_DFLT                                 14'h0

`define GM2_CSR1_ADDR                                      32'h408
`define GM2_CSR1_FCNT_BITS                                 13:0
`define GM2_CSR1_FCNT_DFLT                                 14'h0

`define GM3_CSR1_ADDR                                      32'h40c
`define GM3_CSR1_PCNT_BITS                                 7:0
`define GM3_CSR1_PCNT_DFLT                                 8'h0

`define GM4_CSR1_ADDR                                      32'h410
`define GM4_CSR1_OUTS_MAX_BITS                             15:8
`define GM4_CSR1_OUTS_MAX_DFLT                             8'h0
`define GM4_CSR1_BURST_LEN_BITS                            7:0
`define GM4_CSR1_BURST_LEN_DFLT                            8'h0

`define GM5_CSR1_ADDR                                      32'h414
`define GM5_CSR1_BASE_ADDR_BITS                            31:0
`define GM5_CSR1_BASE_ADDR_DFLT                            32'h0

`define GM6_CSR1_ADDR                                      32'h418
`define GM6_CSR1_SIDX_BITS                                 31:0
`define GM6_CSR1_SIDX_DFLT                                 32'h0

`define GM7_CSR1_ADDR                                      32'h41c
`define GM7_CSR1_FIDX_BITS                                 31:0
`define GM7_CSR1_FIDX_DFLT                                 32'h0

`define GM8_CSR1_ADDR                                      32'h420
`define GM8_CSR1_TIMEOUT_CNT_BITS                          11:0
`define GM8_CSR1_TIMEOUT_CNT_DFLT                          12'h7ff

`define GM9_CSR1_ADDR                                      32'h424
`define GM9_CSR1_AXI_ID_BITS                               7:0
`define GM9_CSR1_AXI_ID_DFLT                               8'h0

`define LM0_CSR1_ADDR                                      32'h430
`define LM0_CSR1_SLEN_BITS                                 15:0
`define LM0_CSR1_SLEN_DFLT                                 16'h0

`define LM1_CSR1_ADDR                                      32'h434
`define LM1_CSR1_SCNT_BITS                                 13:0
`define LM1_CSR1_SCNT_DFLT                                 14'h0

`define LM2_CSR1_ADDR                                      32'h438
`define LM2_CSR1_FCNT_BITS                                 13:0
`define LM2_CSR1_FCNT_DFLT                                 14'h0

`define LM3_CSR1_ADDR                                      32'h43c
`define LM3_CSR1_PCNT_BITS                                 7:0
`define LM3_CSR1_PCNT_DFLT                                 8'h0

`define LM4_CSR1_ADDR                                      32'h440
`define LM4_CSR1_OUTS_MAX_BITS                             15:8
`define LM4_CSR1_OUTS_MAX_DFLT                             8'h0
`define LM4_CSR1_BURST_LEN_BITS                            7:0
`define LM4_CSR1_BURST_LEN_DFLT                            8'h0

`define LM5_CSR1_ADDR                                      32'h444
`define LM5_CSR1_BASE_ADDR_BITS                            27:0
`define LM5_CSR1_BASE_ADDR_DFLT                            28'h0

`define LM6_CSR1_ADDR                                      32'h448
`define LM6_CSR1_SIDX_BITS                                 27:0
`define LM6_CSR1_SIDX_DFLT                                 28'h0

`define LM7_CSR1_ADDR                                      32'h44c
`define LM7_CSR1_FIDX_BITS                                 27:0
`define LM7_CSR1_FIDX_DFLT                                 28'h0

`define LM8_CSR1_ADDR                                      32'h450
`define LM8_CSR1_TIMEOUT_CNT_BITS                          11:0
`define LM8_CSR1_TIMEOUT_CNT_DFLT                          12'h7ff

`define LM9_CSR1_ADDR                                      32'h454
`define LM9_CSR1_AXI_ID_BITS                               7:0
`define LM9_CSR1_AXI_ID_DFLT                               8'h0

`define EN_CSR1_ADDR                                       32'h458
`define EN_CSR1_DECOMP_BITS                                8
`define EN_CSR1_DECOMP_DFLT                                1'b0
`define EN_CSR1_INDEX_BITS                                 0
`define EN_CSR1_INDEX_DFLT                                 1'b0

`define INDEX_CSR1_ADDR                                    32'h45c
`define INDEX_CSR1_BASE_ADDR_BITS                          27:0
`define INDEX_CSR1_BASE_ADDR_DFLT                          28'h0

`define FSM_CSR1_ADDR                                      32'h460
`define FSM_CSR1_MEM_CLAIM_BITS                            16
`define FSM_CSR1_MEM_CLAIM_DFLT                            1'b0
`define FSM_CSR1_MEM_PIPO_NUM_WR_BITS                      15:13
`define FSM_CSR1_MEM_PIPO_NUM_WR_DFLT                      3'h0
`define FSM_CSR1_MEM_PIPO_NUM_RD_BITS                      12:10
`define FSM_CSR1_MEM_PIPO_NUM_RD_DFLT                      3'h0
`define FSM_CSR1_MEM_BASE_IDX_WR_BITS                      9:5
`define FSM_CSR1_MEM_BASE_IDX_WR_DFLT                      5'h0
`define FSM_CSR1_MEM_BASE_IDX_RD_BITS                      4:0
`define FSM_CSR1_MEM_BASE_IDX_RD_DFLT                      5'h0

`define GM0_CSR2_ADDR                                      32'h800
`define GM0_CSR2_SLEN_BITS                                 15:0
`define GM0_CSR2_SLEN_DFLT                                 16'h0

`define GM1_CSR2_ADDR                                      32'h804
`define GM1_CSR2_SCNT_BITS                                 13:0
`define GM1_CSR2_SCNT_DFLT                                 14'h0

`define GM2_CSR2_ADDR                                      32'h808
`define GM2_CSR2_FCNT_BITS                                 13:0
`define GM2_CSR2_FCNT_DFLT                                 14'h0

`define GM3_CSR2_ADDR                                      32'h80c
`define GM3_CSR2_PCNT_BITS                                 7:0
`define GM3_CSR2_PCNT_DFLT                                 8'h0

`define GM4_CSR2_ADDR                                      32'h810
`define GM4_CSR2_OUTS_MAX_BITS                             15:8
`define GM4_CSR2_OUTS_MAX_DFLT                             8'h0
`define GM4_CSR2_BURST_LEN_BITS                            7:0
`define GM4_CSR2_BURST_LEN_DFLT                            8'h0

`define GM5_CSR2_ADDR                                      32'h814
`define GM5_CSR2_BASE_ADDR_BITS                            31:0
`define GM5_CSR2_BASE_ADDR_DFLT                            32'h0

`define GM6_CSR2_ADDR                                      32'h818
`define GM6_CSR2_SIDX_BITS                                 31:0
`define GM6_CSR2_SIDX_DFLT                                 32'h0

`define GM7_CSR2_ADDR                                      32'h81c
`define GM7_CSR2_FIDX_BITS                                 31:0
`define GM7_CSR2_FIDX_DFLT                                 32'h0

`define GM8_CSR2_ADDR                                      32'h820
`define GM8_CSR2_TIMEOUT_CNT_BITS                          11:0
`define GM8_CSR2_TIMEOUT_CNT_DFLT                          12'h7ff

`define GM9_CSR2_ADDR                                      32'h824
`define GM9_CSR2_AXI_ID_BITS                               7:0
`define GM9_CSR2_AXI_ID_DFLT                               8'h0

`define LM0_CSR2_ADDR                                      32'h830
`define LM0_CSR2_SLEN_BITS                                 15:0
`define LM0_CSR2_SLEN_DFLT                                 16'h0

`define LM1_CSR2_ADDR                                      32'h834
`define LM1_CSR2_SCNT_BITS                                 13:0
`define LM1_CSR2_SCNT_DFLT                                 14'h0

`define LM2_CSR2_ADDR                                      32'h838
`define LM2_CSR2_FCNT_BITS                                 13:0
`define LM2_CSR2_FCNT_DFLT                                 14'h0

`define LM3_CSR2_ADDR                                      32'h83c
`define LM3_CSR2_PCNT_BITS                                 7:0
`define LM3_CSR2_PCNT_DFLT                                 8'h0

`define LM4_CSR2_ADDR                                      32'h840
`define LM4_CSR2_OUTS_MAX_BITS                             15:8
`define LM4_CSR2_OUTS_MAX_DFLT                             8'h0
`define LM4_CSR2_BURST_LEN_BITS                            7:0
`define LM4_CSR2_BURST_LEN_DFLT                            8'h0

`define LM5_CSR2_ADDR                                      32'h844
`define LM5_CSR2_BASE_ADDR_BITS                            27:0
`define LM5_CSR2_BASE_ADDR_DFLT                            28'h0

`define LM6_CSR2_ADDR                                      32'h848
`define LM6_CSR2_SIDX_BITS                                 27:0
`define LM6_CSR2_SIDX_DFLT                                 28'h0

`define LM7_CSR2_ADDR                                      32'h84c
`define LM7_CSR2_FIDX_BITS                                 27:0
`define LM7_CSR2_FIDX_DFLT                                 28'h0

`define LM8_CSR2_ADDR                                      32'h850
`define LM8_CSR2_TIMEOUT_CNT_BITS                          11:0
`define LM8_CSR2_TIMEOUT_CNT_DFLT                          12'h7ff

`define LM9_CSR2_ADDR                                      32'h854
`define LM9_CSR2_AXI_ID_BITS                               7:0
`define LM9_CSR2_AXI_ID_DFLT                               8'h0

`define EN_CSR2_ADDR                                       32'h858
`define EN_CSR2_DECOMP_BITS                                8
`define EN_CSR2_DECOMP_DFLT                                1'b0
`define EN_CSR2_INDEX_BITS                                 0
`define EN_CSR2_INDEX_DFLT                                 1'b0

`define INDEX_CSR2_ADDR                                    32'h85c
`define INDEX_CSR2_BASE_ADDR_BITS                          27:0
`define INDEX_CSR2_BASE_ADDR_DFLT                          28'h0

`define FSM_CSR2_ADDR                                      32'h860
`define FSM_CSR2_MEM_CLAIM_BITS                            16
`define FSM_CSR2_MEM_CLAIM_DFLT                            1'b0
`define FSM_CSR2_MEM_PIPO_NUM_WR_BITS                      15:13
`define FSM_CSR2_MEM_PIPO_NUM_WR_DFLT                      3'h0
`define FSM_CSR2_MEM_PIPO_NUM_RD_BITS                      12:10
`define FSM_CSR2_MEM_PIPO_NUM_RD_DFLT                      3'h0
`define FSM_CSR2_MEM_BASE_IDX_WR_BITS                      9:5
`define FSM_CSR2_MEM_BASE_IDX_WR_DFLT                      5'h0
`define FSM_CSR2_MEM_BASE_IDX_RD_BITS                      4:0
`define FSM_CSR2_MEM_BASE_IDX_RD_DFLT                      5'h0

`define GM0_CSR3_ADDR                                      32'hc00
`define GM0_CSR3_SLEN_BITS                                 15:0
`define GM0_CSR3_SLEN_DFLT                                 16'h0

`define GM1_CSR3_ADDR                                      32'hc04
`define GM1_CSR3_SCNT_BITS                                 13:0
`define GM1_CSR3_SCNT_DFLT                                 14'h0

`define GM2_CSR3_ADDR                                      32'hc08
`define GM2_CSR3_FCNT_BITS                                 13:0
`define GM2_CSR3_FCNT_DFLT                                 14'h0

`define GM3_CSR3_ADDR                                      32'hc0c
`define GM3_CSR3_PCNT_BITS                                 7:0
`define GM3_CSR3_PCNT_DFLT                                 8'h0

`define GM4_CSR3_ADDR                                      32'hc10
`define GM4_CSR3_OUTS_MAX_BITS                             15:8
`define GM4_CSR3_OUTS_MAX_DFLT                             8'h0
`define GM4_CSR3_BURST_LEN_BITS                            7:0
`define GM4_CSR3_BURST_LEN_DFLT                            8'h0

`define GM5_CSR3_ADDR                                      32'hc14
`define GM5_CSR3_BASE_ADDR_BITS                            31:0
`define GM5_CSR3_BASE_ADDR_DFLT                            32'h0

`define GM6_CSR3_ADDR                                      32'hc18
`define GM6_CSR3_SIDX_BITS                                 31:0
`define GM6_CSR3_SIDX_DFLT                                 32'h0

`define GM7_CSR3_ADDR                                      32'hc1c
`define GM7_CSR3_FIDX_BITS                                 31:0
`define GM7_CSR3_FIDX_DFLT                                 32'h0

`define GM8_CSR3_ADDR                                      32'hc20
`define GM8_CSR3_TIMEOUT_CNT_BITS                          11:0
`define GM8_CSR3_TIMEOUT_CNT_DFLT                          12'h7ff

`define GM9_CSR3_ADDR                                      32'hc24
`define GM9_CSR3_AXI_ID_BITS                               7:0
`define GM9_CSR3_AXI_ID_DFLT                               8'h0

`define LM0_CSR3_ADDR                                      32'hc30
`define LM0_CSR3_SLEN_BITS                                 15:0
`define LM0_CSR3_SLEN_DFLT                                 16'h0

`define LM1_CSR3_ADDR                                      32'hc34
`define LM1_CSR3_SCNT_BITS                                 13:0
`define LM1_CSR3_SCNT_DFLT                                 14'h0

`define LM2_CSR3_ADDR                                      32'hc38
`define LM2_CSR3_FCNT_BITS                                 13:0
`define LM2_CSR3_FCNT_DFLT                                 14'h0

`define LM3_CSR3_ADDR                                      32'hc3c
`define LM3_CSR3_PCNT_BITS                                 7:0
`define LM3_CSR3_PCNT_DFLT                                 8'h0

`define LM4_CSR3_ADDR                                      32'hc40
`define LM4_CSR3_OUTS_MAX_BITS                             15:8
`define LM4_CSR3_OUTS_MAX_DFLT                             8'h0
`define LM4_CSR3_BURST_LEN_BITS                            7:0
`define LM4_CSR3_BURST_LEN_DFLT                            8'h0

`define LM5_CSR3_ADDR                                      32'hc44
`define LM5_CSR3_BASE_ADDR_BITS                            27:0
`define LM5_CSR3_BASE_ADDR_DFLT                            28'h0

`define LM6_CSR3_ADDR                                      32'hc48
`define LM6_CSR3_SIDX_BITS                                 27:0
`define LM6_CSR3_SIDX_DFLT                                 28'h0

`define LM7_CSR3_ADDR                                      32'hc4c
`define LM7_CSR3_FIDX_BITS                                 27:0
`define LM7_CSR3_FIDX_DFLT                                 28'h0

`define LM8_CSR3_ADDR                                      32'hc50
`define LM8_CSR3_TIMEOUT_CNT_BITS                          11:0
`define LM8_CSR3_TIMEOUT_CNT_DFLT                          12'h7ff

`define LM9_CSR3_ADDR                                      32'hc54
`define LM9_CSR3_AXI_ID_BITS                               7:0
`define LM9_CSR3_AXI_ID_DFLT                               8'h0

`define EN_CSR3_ADDR                                       32'hc58
`define EN_CSR3_DECOMP_BITS                                8
`define EN_CSR3_DECOMP_DFLT                                1'b0
`define EN_CSR3_INDEX_BITS                                 0
`define EN_CSR3_INDEX_DFLT                                 1'b0

`define INDEX_CSR3_ADDR                                    32'hc5c
`define INDEX_CSR3_BASE_ADDR_BITS                          27:0
`define INDEX_CSR3_BASE_ADDR_DFLT                          28'h0

`define FSM_CSR3_ADDR                                      32'hc60
`define FSM_CSR3_MEM_CLAIM_BITS                            16
`define FSM_CSR3_MEM_CLAIM_DFLT                            1'b0
`define FSM_CSR3_MEM_PIPO_NUM_WR_BITS                      15:13
`define FSM_CSR3_MEM_PIPO_NUM_WR_DFLT                      3'h0
`define FSM_CSR3_MEM_PIPO_NUM_RD_BITS                      12:10
`define FSM_CSR3_MEM_PIPO_NUM_RD_DFLT                      3'h0
`define FSM_CSR3_MEM_BASE_IDX_WR_BITS                      9:5
`define FSM_CSR3_MEM_BASE_IDX_WR_DFLT                      5'h0
`define FSM_CSR3_MEM_BASE_IDX_RD_BITS                      4:0
`define FSM_CSR3_MEM_BASE_IDX_RD_DFLT                      5'h0

`define IRQ_STATUS_ADDR                                    32'h1000
`define IRQ_STATUS_FCNT_FINISH_BITS                        1
`define IRQ_STATUS_FCNT_FINISH_DFLT                        1'b0
`define IRQ_STATUS_PCNT_FINISH_BITS                        0
`define IRQ_STATUS_PCNT_FINISH_DFLT                        1'b0

`define IRQ_MASK_ADDR                                      32'h1004
`define IRQ_MASK_FCNT_FINISH_BITS                          1
`define IRQ_MASK_FCNT_FINISH_DFLT                          1'b0
`define IRQ_MASK_PCNT_FINISH_BITS                          0
`define IRQ_MASK_PCNT_FINISH_DFLT                          1'b0

`define IRQ_ENABLE_ADDR                                    32'h1008
`define IRQ_ENABLE_FCNT_FINISH_BITS                        1
`define IRQ_ENABLE_FCNT_FINISH_DFLT                        1'b0
`define IRQ_ENABLE_PCNT_FINISH_BITS                        0
`define IRQ_ENABLE_PCNT_FINISH_DFLT                        1'b0

`define CMD0_ADDR                                          32'h100c
`define CMD0_CS_BITS                                       27:24
`define CMD0_CS_DFLT                                       4'h0
`define CMD0_TRIG_CS_BITS                                  23:21
`define CMD0_TRIG_CS_DFLT                                  3'h0
`define CMD0_TRIG_WORD_COUNTER_BITS                        20:17
`define CMD0_TRIG_WORD_COUNTER_DFLT                        4'h0
`define CMD0_TTL_BITS                                      16:5
`define CMD0_TTL_DFLT                                      12'h0
`define CMD0_OP_ID_BITS                                    4:0
`define CMD0_OP_ID_DFLT                                    5'h0

`define CMD1_ADDR                                          32'h1010
`define CMD1_TRIG_IN_BITS                                  23:0
`define CMD1_TRIG_IN_DFLT                                  24'h0

`define CMD2_ADDR                                          32'h1014
`define CMD2_TRIG_OUT_BITS                                 23:0
`define CMD2_TRIG_OUT_DFLT                                 24'h0

`define SW0_ADDR                                           32'h1018
`define SW0_CMD_TTL_BITS                                   17:6
`define SW0_CMD_TTL_DFLT                                   12'h0
`define SW0_CMD_OP_ID_BITS                                 5:1
`define SW0_CMD_OP_ID_DFLT                                 5'h0
`define SW0_CMD_REQ_BITS                                   0
`define SW0_CMD_REQ_DFLT                                   1'b0

`define SW1_ADDR                                           32'h101c
`define SW1_CMD_TRIG_IN_BITS                               23:0
`define SW1_CMD_TRIG_IN_DFLT                               24'h0

`define SW2_ADDR                                           32'h1020
`define SW2_CMD_TRIG_OUT_BITS                              23:0
`define SW2_CMD_TRIG_OUT_DFLT                              24'h0

`define SW3_ADDR                                           32'h1024
`define SW3_MEM_ALLOC_BITS                                 8
`define SW3_MEM_ALLOC_DFLT                                 1'b0
`define SW3_FINISH_ACK_BITS                                7
`define SW3_FINISH_ACK_DFLT                                1'b0
`define SW3_FINISH_REQ_MASK_BITS                           6
`define SW3_FINISH_REQ_MASK_DFLT                           1'b0
`define SW3_START_FID_BITS                                 5:4
`define SW3_START_FID_DFLT                                 2'h0
`define SW3_START_PIPO_BITS                                3:1
`define SW3_START_PIPO_DFLT                                3'h0
`define SW3_START_BITS                                     0
`define SW3_START_DFLT                                     1'b0

`define FIDX_ADDR                                          32'h1028
`define FIDX_DATA_BITS                                     15:8
`define FIDX_DATA_DFLT                                     8'h0
`define FIDX_EN_BITS                                       0
`define FIDX_EN_DFLT                                       1'b0

`define STS0_ADDR                                          32'h102c
`define STS0_TTL_COUNTER_BITS                              11:0
`define STS0_TTL_COUNTER_DFLT                              12'h0

`define STS1_ADDR                                          32'h1030
`define STS1_RC_UPDATE_BITS                                31:16
`define STS1_RC_UPDATE_DFLT                                16'h0
`define STS1_RC_RESUME_BITS                                15:0
`define STS1_RC_RESUME_DFLT                                16'h0

`define STS2_ADDR                                          32'h1034
`define STS2_WC_UPDATE_BITS                                31:16
`define STS2_WC_UPDATE_DFLT                                16'h0
`define STS2_WC_RESUME_BITS                                15:0
`define STS2_WC_RESUME_DFLT                                16'h0
