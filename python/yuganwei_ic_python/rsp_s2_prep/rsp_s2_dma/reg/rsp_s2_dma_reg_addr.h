
#define GM0_CSR0_ADDR                                      0x0
#define GM0_CSR0_SLEN_BITS                                 15:0
#define GM0_CSR0_SLEN_DFLT                                 0x0

#define GM1_CSR0_ADDR                                      0x4
#define GM1_CSR0_SCNT_BITS                                 13:0
#define GM1_CSR0_SCNT_DFLT                                 0x0

#define GM2_CSR0_ADDR                                      0x8
#define GM2_CSR0_FCNT_BITS                                 13:0
#define GM2_CSR0_FCNT_DFLT                                 0x0

#define GM3_CSR0_ADDR                                      0xc
#define GM3_CSR0_PCNT_BITS                                 7:0
#define GM3_CSR0_PCNT_DFLT                                 0x0

#define GM4_CSR0_ADDR                                      0x10
#define GM4_CSR0_OUTS_MAX_BITS                             15:8
#define GM4_CSR0_OUTS_MAX_DFLT                             0x0
#define GM4_CSR0_BURST_LEN_BITS                            7:0
#define GM4_CSR0_BURST_LEN_DFLT                            0x0

#define GM5_CSR0_ADDR                                      0x14
#define GM5_CSR0_BASE_ADDR_BITS                            31:0
#define GM5_CSR0_BASE_ADDR_DFLT                            0x0

#define GM6_CSR0_ADDR                                      0x18
#define GM6_CSR0_SIDX_BITS                                 31:0
#define GM6_CSR0_SIDX_DFLT                                 0x0

#define GM7_CSR0_ADDR                                      0x1c
#define GM7_CSR0_FIDX_BITS                                 31:0
#define GM7_CSR0_FIDX_DFLT                                 0x0

#define GM8_CSR0_ADDR                                      0x20
#define GM8_CSR0_TIMEOUT_CNT_BITS                          11:0
#define GM8_CSR0_TIMEOUT_CNT_DFLT                          0x7ff

#define GM9_CSR0_ADDR                                      0x24
#define GM9_CSR0_AXI_ID_BITS                               7:0
#define GM9_CSR0_AXI_ID_DFLT                               0x0

#define LM0_CSR0_ADDR                                      0x30
#define LM0_CSR0_SLEN_BITS                                 15:0
#define LM0_CSR0_SLEN_DFLT                                 0x0

#define LM1_CSR0_ADDR                                      0x34
#define LM1_CSR0_SCNT_BITS                                 13:0
#define LM1_CSR0_SCNT_DFLT                                 0x0

#define LM2_CSR0_ADDR                                      0x38
#define LM2_CSR0_FCNT_BITS                                 13:0
#define LM2_CSR0_FCNT_DFLT                                 0x0

#define LM3_CSR0_ADDR                                      0x3c
#define LM3_CSR0_PCNT_BITS                                 7:0
#define LM3_CSR0_PCNT_DFLT                                 0x0

#define LM4_CSR0_ADDR                                      0x40
#define LM4_CSR0_OUTS_MAX_BITS                             15:8
#define LM4_CSR0_OUTS_MAX_DFLT                             0x0
#define LM4_CSR0_BURST_LEN_BITS                            7:0
#define LM4_CSR0_BURST_LEN_DFLT                            0x0

#define LM5_CSR0_ADDR                                      0x44
#define LM5_CSR0_BASE_ADDR_BITS                            27:0
#define LM5_CSR0_BASE_ADDR_DFLT                            0x0

#define LM6_CSR0_ADDR                                      0x48
#define LM6_CSR0_SIDX_BITS                                 27:0
#define LM6_CSR0_SIDX_DFLT                                 0x0

#define LM7_CSR0_ADDR                                      0x4c
#define LM7_CSR0_FIDX_BITS                                 27:0
#define LM7_CSR0_FIDX_DFLT                                 0x0

#define LM8_CSR0_ADDR                                      0x50
#define LM8_CSR0_TIMEOUT_CNT_BITS                          11:0
#define LM8_CSR0_TIMEOUT_CNT_DFLT                          0x7ff

#define LM9_CSR0_ADDR                                      0x54
#define LM9_CSR0_AXI_ID_BITS                               7:0
#define LM9_CSR0_AXI_ID_DFLT                               0x0

#define EN_CSR0_ADDR                                       0x58
#define EN_CSR0_DECOMP_BITS                                8
#define EN_CSR0_DECOMP_DFLT                                0x0
#define EN_CSR0_INDEX_BITS                                 0
#define EN_CSR0_INDEX_DFLT                                 0x0

#define INDEX_CSR0_ADDR                                    0x5c
#define INDEX_CSR0_BASE_ADDR_BITS                          27:0
#define INDEX_CSR0_BASE_ADDR_DFLT                          0x0

#define FSM_CSR0_ADDR                                      0x60
#define FSM_CSR0_MEM_CLAIM_BITS                            16
#define FSM_CSR0_MEM_CLAIM_DFLT                            0x0
#define FSM_CSR0_MEM_PIPO_NUM_WR_BITS                      15:13
#define FSM_CSR0_MEM_PIPO_NUM_WR_DFLT                      0x0
#define FSM_CSR0_MEM_PIPO_NUM_RD_BITS                      12:10
#define FSM_CSR0_MEM_PIPO_NUM_RD_DFLT                      0x0
#define FSM_CSR0_MEM_BASE_IDX_WR_BITS                      9:5
#define FSM_CSR0_MEM_BASE_IDX_WR_DFLT                      0x0
#define FSM_CSR0_MEM_BASE_IDX_RD_BITS                      4:0
#define FSM_CSR0_MEM_BASE_IDX_RD_DFLT                      0x0

#define GM0_CSR1_ADDR                                      0x400
#define GM0_CSR1_SLEN_BITS                                 15:0
#define GM0_CSR1_SLEN_DFLT                                 0x0

#define GM1_CSR1_ADDR                                      0x404
#define GM1_CSR1_SCNT_BITS                                 13:0
#define GM1_CSR1_SCNT_DFLT                                 0x0

#define GM2_CSR1_ADDR                                      0x408
#define GM2_CSR1_FCNT_BITS                                 13:0
#define GM2_CSR1_FCNT_DFLT                                 0x0

#define GM3_CSR1_ADDR                                      0x40c
#define GM3_CSR1_PCNT_BITS                                 7:0
#define GM3_CSR1_PCNT_DFLT                                 0x0

#define GM4_CSR1_ADDR                                      0x410
#define GM4_CSR1_OUTS_MAX_BITS                             15:8
#define GM4_CSR1_OUTS_MAX_DFLT                             0x0
#define GM4_CSR1_BURST_LEN_BITS                            7:0
#define GM4_CSR1_BURST_LEN_DFLT                            0x0

#define GM5_CSR1_ADDR                                      0x414
#define GM5_CSR1_BASE_ADDR_BITS                            31:0
#define GM5_CSR1_BASE_ADDR_DFLT                            0x0

#define GM6_CSR1_ADDR                                      0x418
#define GM6_CSR1_SIDX_BITS                                 31:0
#define GM6_CSR1_SIDX_DFLT                                 0x0

#define GM7_CSR1_ADDR                                      0x41c
#define GM7_CSR1_FIDX_BITS                                 31:0
#define GM7_CSR1_FIDX_DFLT                                 0x0

#define GM8_CSR1_ADDR                                      0x420
#define GM8_CSR1_TIMEOUT_CNT_BITS                          11:0
#define GM8_CSR1_TIMEOUT_CNT_DFLT                          0x7ff

#define GM9_CSR1_ADDR                                      0x424
#define GM9_CSR1_AXI_ID_BITS                               7:0
#define GM9_CSR1_AXI_ID_DFLT                               0x0

#define LM0_CSR1_ADDR                                      0x430
#define LM0_CSR1_SLEN_BITS                                 15:0
#define LM0_CSR1_SLEN_DFLT                                 0x0

#define LM1_CSR1_ADDR                                      0x434
#define LM1_CSR1_SCNT_BITS                                 13:0
#define LM1_CSR1_SCNT_DFLT                                 0x0

#define LM2_CSR1_ADDR                                      0x438
#define LM2_CSR1_FCNT_BITS                                 13:0
#define LM2_CSR1_FCNT_DFLT                                 0x0

#define LM3_CSR1_ADDR                                      0x43c
#define LM3_CSR1_PCNT_BITS                                 7:0
#define LM3_CSR1_PCNT_DFLT                                 0x0

#define LM4_CSR1_ADDR                                      0x440
#define LM4_CSR1_OUTS_MAX_BITS                             15:8
#define LM4_CSR1_OUTS_MAX_DFLT                             0x0
#define LM4_CSR1_BURST_LEN_BITS                            7:0
#define LM4_CSR1_BURST_LEN_DFLT                            0x0

#define LM5_CSR1_ADDR                                      0x444
#define LM5_CSR1_BASE_ADDR_BITS                            27:0
#define LM5_CSR1_BASE_ADDR_DFLT                            0x0

#define LM6_CSR1_ADDR                                      0x448
#define LM6_CSR1_SIDX_BITS                                 27:0
#define LM6_CSR1_SIDX_DFLT                                 0x0

#define LM7_CSR1_ADDR                                      0x44c
#define LM7_CSR1_FIDX_BITS                                 27:0
#define LM7_CSR1_FIDX_DFLT                                 0x0

#define LM8_CSR1_ADDR                                      0x450
#define LM8_CSR1_TIMEOUT_CNT_BITS                          11:0
#define LM8_CSR1_TIMEOUT_CNT_DFLT                          0x7ff

#define LM9_CSR1_ADDR                                      0x454
#define LM9_CSR1_AXI_ID_BITS                               7:0
#define LM9_CSR1_AXI_ID_DFLT                               0x0

#define EN_CSR1_ADDR                                       0x458
#define EN_CSR1_DECOMP_BITS                                8
#define EN_CSR1_DECOMP_DFLT                                0x0
#define EN_CSR1_INDEX_BITS                                 0
#define EN_CSR1_INDEX_DFLT                                 0x0

#define INDEX_CSR1_ADDR                                    0x45c
#define INDEX_CSR1_BASE_ADDR_BITS                          27:0
#define INDEX_CSR1_BASE_ADDR_DFLT                          0x0

#define FSM_CSR1_ADDR                                      0x460
#define FSM_CSR1_MEM_CLAIM_BITS                            16
#define FSM_CSR1_MEM_CLAIM_DFLT                            0x0
#define FSM_CSR1_MEM_PIPO_NUM_WR_BITS                      15:13
#define FSM_CSR1_MEM_PIPO_NUM_WR_DFLT                      0x0
#define FSM_CSR1_MEM_PIPO_NUM_RD_BITS                      12:10
#define FSM_CSR1_MEM_PIPO_NUM_RD_DFLT                      0x0
#define FSM_CSR1_MEM_BASE_IDX_WR_BITS                      9:5
#define FSM_CSR1_MEM_BASE_IDX_WR_DFLT                      0x0
#define FSM_CSR1_MEM_BASE_IDX_RD_BITS                      4:0
#define FSM_CSR1_MEM_BASE_IDX_RD_DFLT                      0x0

#define GM0_CSR2_ADDR                                      0x800
#define GM0_CSR2_SLEN_BITS                                 15:0
#define GM0_CSR2_SLEN_DFLT                                 0x0

#define GM1_CSR2_ADDR                                      0x804
#define GM1_CSR2_SCNT_BITS                                 13:0
#define GM1_CSR2_SCNT_DFLT                                 0x0

#define GM2_CSR2_ADDR                                      0x808
#define GM2_CSR2_FCNT_BITS                                 13:0
#define GM2_CSR2_FCNT_DFLT                                 0x0

#define GM3_CSR2_ADDR                                      0x80c
#define GM3_CSR2_PCNT_BITS                                 7:0
#define GM3_CSR2_PCNT_DFLT                                 0x0

#define GM4_CSR2_ADDR                                      0x810
#define GM4_CSR2_OUTS_MAX_BITS                             15:8
#define GM4_CSR2_OUTS_MAX_DFLT                             0x0
#define GM4_CSR2_BURST_LEN_BITS                            7:0
#define GM4_CSR2_BURST_LEN_DFLT                            0x0

#define GM5_CSR2_ADDR                                      0x814
#define GM5_CSR2_BASE_ADDR_BITS                            31:0
#define GM5_CSR2_BASE_ADDR_DFLT                            0x0

#define GM6_CSR2_ADDR                                      0x818
#define GM6_CSR2_SIDX_BITS                                 31:0
#define GM6_CSR2_SIDX_DFLT                                 0x0

#define GM7_CSR2_ADDR                                      0x81c
#define GM7_CSR2_FIDX_BITS                                 31:0
#define GM7_CSR2_FIDX_DFLT                                 0x0

#define GM8_CSR2_ADDR                                      0x820
#define GM8_CSR2_TIMEOUT_CNT_BITS                          11:0
#define GM8_CSR2_TIMEOUT_CNT_DFLT                          0x7ff

#define GM9_CSR2_ADDR                                      0x824
#define GM9_CSR2_AXI_ID_BITS                               7:0
#define GM9_CSR2_AXI_ID_DFLT                               0x0

#define LM0_CSR2_ADDR                                      0x830
#define LM0_CSR2_SLEN_BITS                                 15:0
#define LM0_CSR2_SLEN_DFLT                                 0x0

#define LM1_CSR2_ADDR                                      0x834
#define LM1_CSR2_SCNT_BITS                                 13:0
#define LM1_CSR2_SCNT_DFLT                                 0x0

#define LM2_CSR2_ADDR                                      0x838
#define LM2_CSR2_FCNT_BITS                                 13:0
#define LM2_CSR2_FCNT_DFLT                                 0x0

#define LM3_CSR2_ADDR                                      0x83c
#define LM3_CSR2_PCNT_BITS                                 7:0
#define LM3_CSR2_PCNT_DFLT                                 0x0

#define LM4_CSR2_ADDR                                      0x840
#define LM4_CSR2_OUTS_MAX_BITS                             15:8
#define LM4_CSR2_OUTS_MAX_DFLT                             0x0
#define LM4_CSR2_BURST_LEN_BITS                            7:0
#define LM4_CSR2_BURST_LEN_DFLT                            0x0

#define LM5_CSR2_ADDR                                      0x844
#define LM5_CSR2_BASE_ADDR_BITS                            27:0
#define LM5_CSR2_BASE_ADDR_DFLT                            0x0

#define LM6_CSR2_ADDR                                      0x848
#define LM6_CSR2_SIDX_BITS                                 27:0
#define LM6_CSR2_SIDX_DFLT                                 0x0

#define LM7_CSR2_ADDR                                      0x84c
#define LM7_CSR2_FIDX_BITS                                 27:0
#define LM7_CSR2_FIDX_DFLT                                 0x0

#define LM8_CSR2_ADDR                                      0x850
#define LM8_CSR2_TIMEOUT_CNT_BITS                          11:0
#define LM8_CSR2_TIMEOUT_CNT_DFLT                          0x7ff

#define LM9_CSR2_ADDR                                      0x854
#define LM9_CSR2_AXI_ID_BITS                               7:0
#define LM9_CSR2_AXI_ID_DFLT                               0x0

#define EN_CSR2_ADDR                                       0x858
#define EN_CSR2_DECOMP_BITS                                8
#define EN_CSR2_DECOMP_DFLT                                0x0
#define EN_CSR2_INDEX_BITS                                 0
#define EN_CSR2_INDEX_DFLT                                 0x0

#define INDEX_CSR2_ADDR                                    0x85c
#define INDEX_CSR2_BASE_ADDR_BITS                          27:0
#define INDEX_CSR2_BASE_ADDR_DFLT                          0x0

#define FSM_CSR2_ADDR                                      0x860
#define FSM_CSR2_MEM_CLAIM_BITS                            16
#define FSM_CSR2_MEM_CLAIM_DFLT                            0x0
#define FSM_CSR2_MEM_PIPO_NUM_WR_BITS                      15:13
#define FSM_CSR2_MEM_PIPO_NUM_WR_DFLT                      0x0
#define FSM_CSR2_MEM_PIPO_NUM_RD_BITS                      12:10
#define FSM_CSR2_MEM_PIPO_NUM_RD_DFLT                      0x0
#define FSM_CSR2_MEM_BASE_IDX_WR_BITS                      9:5
#define FSM_CSR2_MEM_BASE_IDX_WR_DFLT                      0x0
#define FSM_CSR2_MEM_BASE_IDX_RD_BITS                      4:0
#define FSM_CSR2_MEM_BASE_IDX_RD_DFLT                      0x0

#define GM0_CSR3_ADDR                                      0xc00
#define GM0_CSR3_SLEN_BITS                                 15:0
#define GM0_CSR3_SLEN_DFLT                                 0x0

#define GM1_CSR3_ADDR                                      0xc04
#define GM1_CSR3_SCNT_BITS                                 13:0
#define GM1_CSR3_SCNT_DFLT                                 0x0

#define GM2_CSR3_ADDR                                      0xc08
#define GM2_CSR3_FCNT_BITS                                 13:0
#define GM2_CSR3_FCNT_DFLT                                 0x0

#define GM3_CSR3_ADDR                                      0xc0c
#define GM3_CSR3_PCNT_BITS                                 7:0
#define GM3_CSR3_PCNT_DFLT                                 0x0

#define GM4_CSR3_ADDR                                      0xc10
#define GM4_CSR3_OUTS_MAX_BITS                             15:8
#define GM4_CSR3_OUTS_MAX_DFLT                             0x0
#define GM4_CSR3_BURST_LEN_BITS                            7:0
#define GM4_CSR3_BURST_LEN_DFLT                            0x0

#define GM5_CSR3_ADDR                                      0xc14
#define GM5_CSR3_BASE_ADDR_BITS                            31:0
#define GM5_CSR3_BASE_ADDR_DFLT                            0x0

#define GM6_CSR3_ADDR                                      0xc18
#define GM6_CSR3_SIDX_BITS                                 31:0
#define GM6_CSR3_SIDX_DFLT                                 0x0

#define GM7_CSR3_ADDR                                      0xc1c
#define GM7_CSR3_FIDX_BITS                                 31:0
#define GM7_CSR3_FIDX_DFLT                                 0x0

#define GM8_CSR3_ADDR                                      0xc20
#define GM8_CSR3_TIMEOUT_CNT_BITS                          11:0
#define GM8_CSR3_TIMEOUT_CNT_DFLT                          0x7ff

#define GM9_CSR3_ADDR                                      0xc24
#define GM9_CSR3_AXI_ID_BITS                               7:0
#define GM9_CSR3_AXI_ID_DFLT                               0x0

#define LM0_CSR3_ADDR                                      0xc30
#define LM0_CSR3_SLEN_BITS                                 15:0
#define LM0_CSR3_SLEN_DFLT                                 0x0

#define LM1_CSR3_ADDR                                      0xc34
#define LM1_CSR3_SCNT_BITS                                 13:0
#define LM1_CSR3_SCNT_DFLT                                 0x0

#define LM2_CSR3_ADDR                                      0xc38
#define LM2_CSR3_FCNT_BITS                                 13:0
#define LM2_CSR3_FCNT_DFLT                                 0x0

#define LM3_CSR3_ADDR                                      0xc3c
#define LM3_CSR3_PCNT_BITS                                 7:0
#define LM3_CSR3_PCNT_DFLT                                 0x0

#define LM4_CSR3_ADDR                                      0xc40
#define LM4_CSR3_OUTS_MAX_BITS                             15:8
#define LM4_CSR3_OUTS_MAX_DFLT                             0x0
#define LM4_CSR3_BURST_LEN_BITS                            7:0
#define LM4_CSR3_BURST_LEN_DFLT                            0x0

#define LM5_CSR3_ADDR                                      0xc44
#define LM5_CSR3_BASE_ADDR_BITS                            27:0
#define LM5_CSR3_BASE_ADDR_DFLT                            0x0

#define LM6_CSR3_ADDR                                      0xc48
#define LM6_CSR3_SIDX_BITS                                 27:0
#define LM6_CSR3_SIDX_DFLT                                 0x0

#define LM7_CSR3_ADDR                                      0xc4c
#define LM7_CSR3_FIDX_BITS                                 27:0
#define LM7_CSR3_FIDX_DFLT                                 0x0

#define LM8_CSR3_ADDR                                      0xc50
#define LM8_CSR3_TIMEOUT_CNT_BITS                          11:0
#define LM8_CSR3_TIMEOUT_CNT_DFLT                          0x7ff

#define LM9_CSR3_ADDR                                      0xc54
#define LM9_CSR3_AXI_ID_BITS                               7:0
#define LM9_CSR3_AXI_ID_DFLT                               0x0

#define EN_CSR3_ADDR                                       0xc58
#define EN_CSR3_DECOMP_BITS                                8
#define EN_CSR3_DECOMP_DFLT                                0x0
#define EN_CSR3_INDEX_BITS                                 0
#define EN_CSR3_INDEX_DFLT                                 0x0

#define INDEX_CSR3_ADDR                                    0xc5c
#define INDEX_CSR3_BASE_ADDR_BITS                          27:0
#define INDEX_CSR3_BASE_ADDR_DFLT                          0x0

#define FSM_CSR3_ADDR                                      0xc60
#define FSM_CSR3_MEM_CLAIM_BITS                            16
#define FSM_CSR3_MEM_CLAIM_DFLT                            0x0
#define FSM_CSR3_MEM_PIPO_NUM_WR_BITS                      15:13
#define FSM_CSR3_MEM_PIPO_NUM_WR_DFLT                      0x0
#define FSM_CSR3_MEM_PIPO_NUM_RD_BITS                      12:10
#define FSM_CSR3_MEM_PIPO_NUM_RD_DFLT                      0x0
#define FSM_CSR3_MEM_BASE_IDX_WR_BITS                      9:5
#define FSM_CSR3_MEM_BASE_IDX_WR_DFLT                      0x0
#define FSM_CSR3_MEM_BASE_IDX_RD_BITS                      4:0
#define FSM_CSR3_MEM_BASE_IDX_RD_DFLT                      0x0

#define IRQ_STATUS_ADDR                                    0x1000
#define IRQ_STATUS_FCNT_FINISH_BITS                        1
#define IRQ_STATUS_FCNT_FINISH_DFLT                        0x0
#define IRQ_STATUS_PCNT_FINISH_BITS                        0
#define IRQ_STATUS_PCNT_FINISH_DFLT                        0x0

#define IRQ_MASK_ADDR                                      0x1004
#define IRQ_MASK_FCNT_FINISH_BITS                          1
#define IRQ_MASK_FCNT_FINISH_DFLT                          0x0
#define IRQ_MASK_PCNT_FINISH_BITS                          0
#define IRQ_MASK_PCNT_FINISH_DFLT                          0x0

#define IRQ_ENABLE_ADDR                                    0x1008
#define IRQ_ENABLE_FCNT_FINISH_BITS                        1
#define IRQ_ENABLE_FCNT_FINISH_DFLT                        0x0
#define IRQ_ENABLE_PCNT_FINISH_BITS                        0
#define IRQ_ENABLE_PCNT_FINISH_DFLT                        0x0

#define CMD0_ADDR                                          0x100c
#define CMD0_CS_BITS                                       27:24
#define CMD0_CS_DFLT                                       0x0
#define CMD0_TRIG_CS_BITS                                  23:21
#define CMD0_TRIG_CS_DFLT                                  0x0
#define CMD0_TRIG_WORD_COUNTER_BITS                        20:17
#define CMD0_TRIG_WORD_COUNTER_DFLT                        0x0
#define CMD0_TTL_BITS                                      16:5
#define CMD0_TTL_DFLT                                      0x0
#define CMD0_OP_ID_BITS                                    4:0
#define CMD0_OP_ID_DFLT                                    0x0

#define CMD1_ADDR                                          0x1010
#define CMD1_TRIG_IN_BITS                                  23:0
#define CMD1_TRIG_IN_DFLT                                  0x0

#define CMD2_ADDR                                          0x1014
#define CMD2_TRIG_OUT_BITS                                 23:0
#define CMD2_TRIG_OUT_DFLT                                 0x0

#define SW0_ADDR                                           0x1018
#define SW0_CMD_TTL_BITS                                   17:6
#define SW0_CMD_TTL_DFLT                                   0x0
#define SW0_CMD_OP_ID_BITS                                 5:1
#define SW0_CMD_OP_ID_DFLT                                 0x0
#define SW0_CMD_REQ_BITS                                   0
#define SW0_CMD_REQ_DFLT                                   0x0

#define SW1_ADDR                                           0x101c
#define SW1_CMD_TRIG_IN_BITS                               23:0
#define SW1_CMD_TRIG_IN_DFLT                               0x0

#define SW2_ADDR                                           0x1020
#define SW2_CMD_TRIG_OUT_BITS                              23:0
#define SW2_CMD_TRIG_OUT_DFLT                              0x0

#define SW3_ADDR                                           0x1024
#define SW3_MEM_ALLOC_BITS                                 8
#define SW3_MEM_ALLOC_DFLT                                 0x0
#define SW3_FINISH_ACK_BITS                                7
#define SW3_FINISH_ACK_DFLT                                0x0
#define SW3_FINISH_REQ_MASK_BITS                           6
#define SW3_FINISH_REQ_MASK_DFLT                           0x0
#define SW3_START_FID_BITS                                 5:4
#define SW3_START_FID_DFLT                                 0x0
#define SW3_START_PIPO_BITS                                3:1
#define SW3_START_PIPO_DFLT                                0x0
#define SW3_START_BITS                                     0
#define SW3_START_DFLT                                     0x0

#define FIDX_ADDR                                          0x1028
#define FIDX_DATA_BITS                                     15:8
#define FIDX_DATA_DFLT                                     0x0
#define FIDX_EN_BITS                                       0
#define FIDX_EN_DFLT                                       0x0

#define STS0_ADDR                                          0x102c
#define STS0_TTL_COUNTER_BITS                              11:0
#define STS0_TTL_COUNTER_DFLT                              0x0

#define STS1_ADDR                                          0x1030
#define STS1_RC_UPDATE_BITS                                31:16
#define STS1_RC_UPDATE_DFLT                                0x0
#define STS1_RC_RESUME_BITS                                15:0
#define STS1_RC_RESUME_DFLT                                0x0

#define STS2_ADDR                                          0x1034
#define STS2_WC_UPDATE_BITS                                31:16
#define STS2_WC_UPDATE_DFLT                                0x0
#define STS2_WC_RESUME_BITS                                15:0
#define STS2_WC_RESUME_DFLT                                0x0
