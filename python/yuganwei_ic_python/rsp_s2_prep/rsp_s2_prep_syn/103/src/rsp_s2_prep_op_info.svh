`ifndef RSP_S2_PREP_OP_INFO_SVH
  `define RSP_S2_PREP_OP_INFO_SVH
  typedef struct packed {
    logic [7:0] start_info;
  } start_info_t;
  
  typedef struct packed{
    logic [7:0] id_op;
    logic       trig_in;
    logic       trig_out;
    logic [7:0] id_frame;
    logic [7:0] time_live;
  } cmd_info_t;
  
  typedef struct packed{
    logic [7:0] finish_info;
  } finish_info_t;
`endif
