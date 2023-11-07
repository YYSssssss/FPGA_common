
package jb_prach_oran_pkg;

  typedef struct packed{
    logic   [7:0]   ss;
    logic   [3:0]   cc;          
    logic   [3:0] 	sf;
    logic   [11:0]  section_id;
    } cplane_fifo_words_t;
    
  typedef struct packed{
    logic   [7:0]   ss;
    logic   [3:0]   cc;
    logic   [3:0]   sf;
    logic   [11:0]  section_id;
    } prach_fifo_words_t;
    
  typedef struct packed{
    logic           valid;
    logic           ready;
    logic   [7:0]   ss;
    logic   [3:0]   cc;
    logic   [3:0]   sf;
    logic   [11:0]  section_id;
    } prach_requests_t;

  typedef enum logic[2:0]{
    RED,
    BLUE,
    GREEN,
    GOLD
    } queue_states_t;
  
  typedef enum logic[2:0]{
    IDLE,
    STAGE,
    SEND,
    WAIT1,
    WAIT2,
    WAIT3
    } send_states_t;
    
  typedef struct packed{
    logic   [3:0]   sub_frame;  /* Sub-Frame number... valid range 0..9             */
    logic   [9:0]   address;    /* FFT output sample index... valid range 0..1023   */
    logic   [1:0]   antenna;    /* Antenna number... valid range 0..3               */
    } prach_fft_tuser_t;
    
endpackage
