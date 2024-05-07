
`define IRQ_STATUS_ADDR                                    32'h0
`define IRQ_STATUS_FCNT_FINISH_BITS                        1
`define IRQ_STATUS_FCNT_FINISH_DFLT                        1'b0
`define IRQ_STATUS_PCNT_FINISH_BITS                        0
`define IRQ_STATUS_PCNT_FINISH_DFLT                        1'b0

`define IRQ_MASK_ADDR                                      32'h4
`define IRQ_MASK_FCNT_FINISH_BITS                          1
`define IRQ_MASK_FCNT_FINISH_DFLT                          1'b0
`define IRQ_MASK_PCNT_FINISH_BITS                          0
`define IRQ_MASK_PCNT_FINISH_DFLT                          1'b0

`define IRQ_ENABLE_ADDR                                    32'h8
`define IRQ_ENABLE_FCNT_FINISH_BITS                        1
`define IRQ_ENABLE_FCNT_FINISH_DFLT                        1'b0
`define IRQ_ENABLE_PCNT_FINISH_BITS                        0
`define IRQ_ENABLE_PCNT_FINISH_DFLT                        1'b0

`define CMD0_ADDR                                          32'hc
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

`define CMD1_ADDR                                          32'h10
`define CMD1_TRIG_IN_BITS                                  23:0
`define CMD1_TRIG_IN_DFLT                                  24'h0

`define CMD2_ADDR                                          32'h14
`define CMD2_TRIG_OUT_BITS                                 23:0
`define CMD2_TRIG_OUT_DFLT                                 24'h0

`define SW0_ADDR                                           32'h18
`define SW0_CMD_TTL_BITS                                   17:6
`define SW0_CMD_TTL_DFLT                                   12'h0
`define SW0_CMD_OP_ID_BITS                                 5:1
`define SW0_CMD_OP_ID_DFLT                                 5'h0
`define SW0_CMD_REQ_BITS                                   0
`define SW0_CMD_REQ_DFLT                                   1'b0

`define SW1_ADDR                                           32'h1c
`define SW1_CMD_TRIG_IN_BITS                               23:0
`define SW1_CMD_TRIG_IN_DFLT                               24'h0

`define SW2_ADDR                                           32'h20
`define SW2_CMD_TRIG_OUT_BITS                              23:0
`define SW2_CMD_TRIG_OUT_DFLT                              24'h0

`define SW3_ADDR                                           32'h24
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

`define FIDX_ADDR                                          32'h28
`define FIDX_DATA_BITS                                     15:8
`define FIDX_DATA_DFLT                                     8'h0
`define FIDX_EN_BITS                                       0
`define FIDX_EN_DFLT                                       1'b0

`define STS0_ADDR                                          32'h2c
`define STS0_TTL_COUNTER_BITS                              11:0
`define STS0_TTL_COUNTER_DFLT                              12'h0

`define STS1_ADDR                                          32'h30
`define STS1_RC_UPDATE_BITS                                31:16
`define STS1_RC_UPDATE_DFLT                                16'h0
`define STS1_RC_RESUME_BITS                                15:0
`define STS1_RC_RESUME_DFLT                                16'h0

`define STS2_ADDR                                          32'h34
`define STS2_WC_UPDATE_BITS                                31:16
`define STS2_WC_UPDATE_DFLT                                16'h0
`define STS2_WC_RESUME_BITS                                15:0
`define STS2_WC_RESUME_DFLT                                16'h0

`define GM0_ADDR                                           32'h0
`define GM0_SLEN_BITS                                      15:0
`define GM0_SLEN_DFLT                                      16'h0

`define GM1_ADDR                                           32'h4
`define GM1_SCNT_BITS                                      13:0
`define GM1_SCNT_DFLT                                      14'h0

`define GM2_ADDR                                           32'h8
`define GM2_FCNT_BITS                                      13:0
`define GM2_FCNT_DFLT                                      14'h0

`define GM3_ADDR                                           32'hc
`define GM3_PCNT_BITS                                      7:0
`define GM3_PCNT_DFLT                                      8'h0

`define GM4_ADDR                                           32'h10
`define GM4_OUTS_MAX_BITS                                  15:8
`define GM4_OUTS_MAX_DFLT                                  8'h0
`define GM4_BURST_LEN_BITS                                 7:0
`define GM4_BURST_LEN_DFLT                                 8'h0

`define GM5_ADDR                                           32'h14
`define GM5_BASE_ADDR_BITS                                 31:0
`define GM5_BASE_ADDR_DFLT                                 32'h0

`define GM6_ADDR                                           32'h18
`define GM6_SIDX_BITS                                      31:0
`define GM6_SIDX_DFLT                                      32'h0

`define GM7_ADDR                                           32'h1c
`define GM7_FIDX_BITS                                      31:0
`define GM7_FIDX_DFLT                                      32'h0

`define GM8_ADDR                                           32'h20
`define GM8_TIMEOUT_CNT_BITS                               11:0
`define GM8_TIMEOUT_CNT_DFLT                               12'h7ff

`define GM9_ADDR                                           32'h24
`define GM9_AXI_ID_BITS                                    7:0
`define GM9_AXI_ID_DFLT                                    8'h0

`define LM0_ADDR                                           32'h30
`define LM0_SLEN_BITS                                      15:0
`define LM0_SLEN_DFLT                                      16'h0

`define LM1_ADDR                                           32'h34
`define LM1_SCNT_BITS                                      13:0
`define LM1_SCNT_DFLT                                      14'h0

`define LM2_ADDR                                           32'h38
`define LM2_FCNT_BITS                                      13:0
`define LM2_FCNT_DFLT                                      14'h0

`define LM3_ADDR                                           32'h3c
`define LM3_PCNT_BITS                                      7:0
`define LM3_PCNT_DFLT                                      8'h0

`define LM4_ADDR                                           32'h40
`define LM4_OUTS_MAX_BITS                                  15:8
`define LM4_OUTS_MAX_DFLT                                  8'h0
`define LM4_BURST_LEN_BITS                                 7:0
`define LM4_BURST_LEN_DFLT                                 8'h0

`define LM5_ADDR                                           32'h44
`define LM5_BASE_ADDR_BITS                                 27:0
`define LM5_BASE_ADDR_DFLT                                 28'h0

`define LM6_ADDR                                           32'h48
`define LM6_SIDX_BITS                                      27:0
`define LM6_SIDX_DFLT                                      28'h0

`define LM7_ADDR                                           32'h4c
`define LM7_FIDX_BITS                                      27:0
`define LM7_FIDX_DFLT                                      28'h0

`define LM8_ADDR                                           32'h50
`define LM8_TIMEOUT_CNT_BITS                               11:0
`define LM8_TIMEOUT_CNT_DFLT                               12'h7ff

`define LM9_ADDR                                           32'h54
`define LM9_AXI_ID_BITS                                    7:0
`define LM9_AXI_ID_DFLT                                    8'h0

`define EN_ADDR                                            32'h58
`define EN_DECOMP_BITS                                     8
`define EN_DECOMP_DFLT                                     1'b0
`define EN_INDEX_BITS                                      0
`define EN_INDEX_DFLT                                      1'b0

`define INDEX_ADDR                                         32'h5c
`define INDEX_BASE_ADDR_BITS                               27:0
`define INDEX_BASE_ADDR_DFLT                               28'h0

`define FSM_ADDR                                           32'h60
`define FSM_MEM_CLAIM_BITS                                 16
`define FSM_MEM_CLAIM_DFLT                                 1'b0
`define FSM_MEM_PIPO_NUM_WR_BITS                           15:13
`define FSM_MEM_PIPO_NUM_WR_DFLT                           3'h0
`define FSM_MEM_PIPO_NUM_RD_BITS                           12:10
`define FSM_MEM_PIPO_NUM_RD_DFLT                           3'h0
`define FSM_MEM_BASE_IDX_WR_BITS                           9:5
`define FSM_MEM_BASE_IDX_WR_DFLT                           5'h0
`define FSM_MEM_BASE_IDX_RD_BITS                           4:0
`define FSM_MEM_BASE_IDX_RD_DFLT                           5'h0
