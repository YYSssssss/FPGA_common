`timescale 1ns / 1ps

module jb_fft_alignment_nr # (
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16
)
 (
    input                        clk,                   // i clock  
    input                        clk_en,                // i clock enable           
    input                        reset,                 // i reset
     
    input                        ch_bw_update_done,     // i 
    input [3:0]                  ch_bw,                 // i
    input                        extended_cp,           // i
    input                        dv,                    // i
    input                        frm_mrkr,              // i
    input                        subfrm_mrkr,           // i
    input                        slot_mrkr,             // i
    input                        sym_mrkr,              // i
    input                        sym_mrkr_4x,           // i
    input [3:0]                  sym_cnt,               // i 
    input [2:0]                  sym_cnt_4x,            // i
    jb_axi4_stream_if.slave      IFP_fft_in,            // i
    output logic                 frm_mrkr_out,          // o
    output logic                 subfrm_mrkr_out,       // o
    output logic                 slot_mrkr_out,         // o
    output logic                 sym_mrkr_out,          // o
    output logic                 sym_mrkr_4x_out,       // o
    output logic [3:0]           sym_cnt_out,           // o 
    output logic [2:0]           sym_cnt_4x_out,        // o 
    jb_axi4_stream_if.master     IFP_fft_out            // o
    
    );


jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_in_d();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_in_2d();

logic                 frm_mrkr_d = 0;   
logic                 subfrm_mrkr_d = 0;          
logic                 slot_mrkr_d = 0;          
logic                 sym_mrkr_d = 0;      
logic                 sym_mrkr_4x_d = 0;      
logic [2:0]           sym_cnt_d = 0; 
logic [2:0]           sym_cnt_4x_d = 0;             
logic [1:0]           alignment = 0;
logic                 aligned = 0;

always_ff @(posedge clk) begin
     frm_mrkr_out   <= frm_mrkr;
     subfrm_mrkr_out<= subfrm_mrkr;
     slot_mrkr_out  <= slot_mrkr;
     sym_mrkr_out   <= sym_mrkr;
     sym_mrkr_4x_out<= sym_mrkr_4x;
     sym_cnt_out    <= sym_cnt;
     sym_cnt_4x_out <= sym_cnt_4x;
    IFP_fft_in_d.tdata   <= IFP_fft_in.tdata;
    IFP_fft_in_d.tvalid  <= IFP_fft_in.tvalid;
    IFP_fft_in_d.tuser   <= IFP_fft_in.tuser;
    IFP_fft_in_d.tkeep   <= IFP_fft_in.tkeep;
    IFP_fft_in_d.tlast   <= IFP_fft_in.tlast;
    IFP_fft_in_2d.tdata  <= IFP_fft_in_d.tdata;
    IFP_fft_in_2d.tvalid <= IFP_fft_in_d.tvalid;
    IFP_fft_in_2d.tuser  <= IFP_fft_in_d.tuser;
    IFP_fft_in_2d.tkeep  <= IFP_fft_in_d.tkeep;
    IFP_fft_in_2d.tlast  <= IFP_fft_in_d.tlast;
	
end    


always_ff @(posedge clk) begin
                    IFP_fft_out.tdata  <= IFP_fft_in_2d.tdata  ;
                    IFP_fft_out.tvalid <= IFP_fft_in_2d.tvalid ;
                    IFP_fft_out.tuser  <= IFP_fft_in_2d.tuser  ;
                    IFP_fft_out.tkeep  <= IFP_fft_in_2d.tkeep  ;
                    IFP_fft_out.tlast  <= IFP_fft_in_2d.tlast  ;
end
  

ul_fft_alignment_nr
  ul_fft_alignment_nr_inst (
    .clk      (clk),
    .probe0   (frm_mrkr),
    .probe1   (subfrm_mrkr),
    .probe2   (slot_mrkr),
    .probe3   (sym_mrkr),
    .probe4   (sym_mrkr_4x),
    .probe5   (sym_cnt),
    .probe6   (sym_cnt_4x),
    .probe7   (IFP_fft_in.tdata),
    .probe8   (IFP_fft_in.tvalid),
    .probe9   (IFP_fft_in.tuser)
	
	);


  

endmodule
