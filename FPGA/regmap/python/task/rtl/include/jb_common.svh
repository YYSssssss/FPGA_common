

typedef enum logic [1:0] {DBGBUF_IDLE, READ_DBGBUF, WRITE_DBGBUF,WRITE_DBGBUF_WAIT_DATA} dbgbuf_sm_t;
typedef enum logic [1:0] {INP_ADDR_IDLE, ADDR_PHASE,WAIT_MRKR,STORE_DATA} dl_inp_addr_sm_t;
typedef enum logic [1:0] {INP_DATA_IDLE, DRIVE_DATA} dl_inp_data_sm_t;
typedef enum logic [2:0] {DL_ORAN_SCHLR_IDLE, DL_ORAN_INIT_MEM, DL_ORAN_WRITE_SECTIONS, DL_ORAN_WAIT_TVALID, DL_ORAN_WAIT_SYMB_MRKR_BY4} dl_oran_schlr_sm_t;

typedef enum logic [1:0] {SYSFRM_MRKR_GEN_IDLE,SYSFRM_MRKR_SYSCNT_MATCH,SYSFRM_MRKR_WAIT_DIS} sys_frm_mrkr_gen_sm_t;

typedef enum logic [2:0] {DL_ORAN_EGRS_IDLE, DL_ORAN_EGRS_DRIVE_FIRST_HALF_TONES,DL_ORAN_EGRS_ZERO_TONES,DL_ORAN_EGRS_DRIVE_SECOND_HALF_TONES,DL_ORAN_EGRS_FIRST_CYCLE} dl_oran_egress_sm_t;


localparam  BW_100MHZ=4;
localparam  BW_80MHZ=5;
localparam  BW_60MHZ=6;
localparam  BW_20MHZ=0;
localparam  BW_10MHZ=1;
localparam  BW_5MHZ=2;
localparam  BW_15MHZ=3;

localparam N_MAX_TONE_BW=16;
localparam N_MAX_RB_BW=10;


function [N_MAX_TONE_BW-1:0] f_num_tones;
 input [3:0] ch_bw; // NR: b100: 100MHz b101: 80MHz  b110: 60MHz ;LTE b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
    begin
     case (ch_bw)
       BW_100MHZ   : f_num_tones = 3276;//nr 100M
       BW_80MHZ   :  f_num_tones = 3252;//nr 80M
       BW_60MHZ   :  f_num_tones = 1944;//nr 60M
       BW_20MHZ   :  f_num_tones = 1200;
       BW_15MHZ   :  f_num_tones = 900;
       BW_10MHZ   :  f_num_tones = 600;
       BW_5MHZ    :  f_num_tones = 300;
      endcase
   end
endfunction

function [N_MAX_TONE_BW-1:0] f_num_guard_tones; 
 input [3:0] ch_bw;
   begin
     case (ch_bw)
       BW_100MHZ  :  f_num_guard_tones = 820;//nr 100M
       BW_80MHZ   :  f_num_guard_tones = 844;//nr 80M
       BW_60MHZ   :  f_num_guard_tones = 2152;//nr 60M
       BW_20MHZ   :  f_num_guard_tones = 848;
       BW_15MHZ   :  f_num_guard_tones = 1148;
       BW_10MHZ   :  f_num_guard_tones = 424;
       BW_5MHZ    :  f_num_guard_tones = 212;
      endcase
  end
endfunction

function [N_MAX_RB_BW-1:0] f_num_rb; 
  input [3:0] ch_bw;
     begin
     case (ch_bw)
       BW_100MHZ   : f_num_rb = 273;//nr 100M
       BW_80MHZ   :  f_num_rb = 271;//nr 80M
       BW_60MHZ   :  f_num_rb = 162;//nr 60M
       BW_20MHZ   :  f_num_rb = 100;
       BW_15MHZ   :  f_num_rb = 75;
       BW_10MHZ   :  f_num_rb = 50;
       BW_5MHZ    :  f_num_rb = 250;
      endcase
end
endfunction
 
virtual class rnd_sat_class#(parameter FULL, FRAC);
  static function logic [15:0] rnd_sat_comb(input logic [63:0] datain);
    logic [FULL-FRAC:0] rounded;
    logic        [15:0] dataout;
    rounded = {datain[FULL-1], datain[FULL-1:FRAC]} + datain[FRAC-1];
    if (&rounded[FULL-FRAC:15] || ~|rounded[FULL-FRAC:15])
      dataout = rounded[15:0];
    else if (rounded[FULL-FRAC])
      dataout = 16'h8000;
    else
      dataout = 16'h7fff;
    return dataout;
  endfunction
endclass
