package jb_ul_oran_pkg;

  typedef struct packed{
    logic           valid;
    logic   [8:0]   start_rb;
    logic   [7:0]   num_rb;
    logic   [2:0]   cc_num;
    logic   [3:0]   rsvd;
    } requests_t;
    
  typedef struct packed{
    logic   [8:0]   start_rb;
    logic   [7:0]   num_rb;
    logic   [2:0]   cc_num;
    logic   [3:0]   symbol;
    } fifo_words_t;
    
  typedef enum logic[2:0]{
    IDLE,
    WAIT1,
    WAIT2,
    SEND,
    WAIT3,
    WAIT4,
    WAIT5
    } send_states_t;


endpackage
