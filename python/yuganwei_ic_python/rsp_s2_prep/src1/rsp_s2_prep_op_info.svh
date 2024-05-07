`ifndef _RSP_S1_OP_INFO_SVH_
`define _RSP_S1_OP_INFO_SVH_

`include "rsp_common_defines.vh"

`define RSP_S1_OP_TRIG_WIDTH   5
`define RSP_S1_OP_TTL_WIDTH    14
`define RSP_S1_OP_OP_ID_WIDTH  5
`define RSP_S1_OP_FRM_WIDTH    2

typedef struct packed {
    logic [`RSP_S1_OP_OP_ID_WIDTH-1:0]    op_id       ;
    logic [`RSP_S1_OP_TRIG_WIDTH-1:0]     trig_in     ;
    logic [`RSP_S1_OP_TRIG_WIDTH-1:0]     trig_out    ;
    logic [`RSP_S1_OP_TTL_WIDTH-1:0]      ttl         ;
} cmd_info_t; // dispatch static config

typedef struct packed {
    logic [0:0]                           ping_pong     ;
    logic [`RSP_S1_OP_OP_ID_WIDTH-1:0]    source_op     ;
    logic [`RSP_S1_OP_FRM_WIDTH-1:0]      frame_type_id ;
} start_info_t; // sideband config

typedef struct packed {
    logic [0:0]                           ping_pong     ;
    logic [`RSP_S1_OP_OP_ID_WIDTH-1:0]    dest_op       ;
    logic [`RSP_S1_OP_FRM_WIDTH-1:0]      frame_type_id ;
} finish_info_t; // sideband config

`endif