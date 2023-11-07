`timescale 1ns / 1ps

module jb_prach_fft_alignment # (
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16
)
 (
    input                        clk,                   // i clock  
    input                        clk_en,                // i clock enable           
    input                        reset,                 // i reset
    input                        car_en,
     
    input                        ch_bw_update_done,     // i 
    input [3:0]                  ch_bw,                 // i
    input                        extended_cp,           // i
    input                        dv,                    // i
    input                        frm_mrkr,              // i
    input                        subfrm_mrkr,           // i
    input                        slot_mrkr,             // i
    input                        sym_mrkr,              // i
    input                        sym_mrkr_4x,           // i
    input [2:0]                  sym_cnt,               // i 
    input [2:0]                  sym_cnt_4x,            // i
    jb_axi4_stream_if.slave      IFP_fft_in,            // i
    output logic                 frm_mrkr_out,          // o
    output logic                 subfrm_mrkr_out,       // o
    output logic                 slot_mrkr_out,         // o
    output logic                 sym_mrkr_out,          // o
    output logic                 sym_mrkr_4x_out,       // o
    output logic [2:0]           sym_cnt_out,           // o 
    output logic [2:0]           sym_cnt_4x_out,        // o 
    jb_axi4_stream_if.master     IFP_fft_out            // o
    
    );

/*
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_in_d();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_in_2d();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_in_3d();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW))  IFP_fft_in_4d();


logic                 frm_mrkr_d = 0;   
logic                 subfrm_mrkr_d = 0;          
logic                 slot_mrkr_d = 0;          
logic                 sym_mrkr_d = 0;      
logic                 sym_mrkr_4x_d = 0;      
logic [2:0]           sym_cnt_d = 0; 
logic [2:0]           sym_cnt_4x_d = 0;             
logic [1:0]           alignment = 0;
logic                 aligned = 0;
logic                 frm_mrkr_extended;

always_ff @(posedge clk) begin
    if (clk_en) begin
        frm_mrkr_d <= frm_mrkr;
        subfrm_mrkr_d <= subfrm_mrkr;
        slot_mrkr_d <= slot_mrkr;
        sym_mrkr_d <= sym_mrkr;
        sym_mrkr_4x_d <= sym_mrkr_4x;
        sym_cnt_d <= sym_cnt;
        sym_cnt_4x_d <= sym_cnt_4x;
        IFP_fft_in_d.tvalid  <= IFP_fft_in.tvalid;
        IFP_fft_in_2d.tvalid <= IFP_fft_in_d.tvalid;
        IFP_fft_in_3d.tvalid <= IFP_fft_in_2d.tvalid;
        IFP_fft_in_4d.tvalid <= IFP_fft_in_3d.tvalid;   
        if (IFP_fft_in.tvalid) begin
            IFP_fft_in_d.tdata   <= IFP_fft_in.tdata;
            IFP_fft_in_d.tuser   <= IFP_fft_in.tuser;
            IFP_fft_in_d.tkeep   <= IFP_fft_in.tkeep;
            IFP_fft_in_d.tlast   <= IFP_fft_in.tlast;
            IFP_fft_in_2d.tdata  <= IFP_fft_in_d.tdata;
            IFP_fft_in_2d.tuser  <= IFP_fft_in_d.tuser;
            IFP_fft_in_2d.tkeep  <= IFP_fft_in_d.tkeep;
            IFP_fft_in_2d.tlast  <= IFP_fft_in_d.tlast;
            IFP_fft_in_3d.tdata  <= IFP_fft_in_2d.tdata;
            IFP_fft_in_3d.tuser  <= IFP_fft_in_2d.tuser;
            IFP_fft_in_3d.tkeep  <= IFP_fft_in_2d.tkeep;
            IFP_fft_in_3d.tlast  <= IFP_fft_in_2d.tlast;
            IFP_fft_in_4d.tdata  <= IFP_fft_in_3d.tdata;
            IFP_fft_in_4d.tuser  <= IFP_fft_in_3d.tuser;
            IFP_fft_in_4d.tkeep  <= IFP_fft_in_3d.tkeep;
            IFP_fft_in_4d.tlast  <= IFP_fft_in_3d.tlast;
          end
    end
end    

jb_pulse_stretch #(
        .PULSE_WIDTH        (23)
    ) pulse_stretch_frm_mrkr (
        .clk                (clk),
        .din                (frm_mrkr),
        .dout               (frm_mrkr_extended)
    );

 

// Align with Antenna 0
always_ff @(posedge clk) begin
    if (clk_en) begin
        if (ch_bw_update_done) begin
            aligned <= 0;
            alignment <= 0;
            end
        else if(frm_mrkr_extended & IFP_fft_in.tvalid) begin
            aligned <= 1;
            alignment <= IFP_fft_in.tuser;
        end
    end
end

always_ff @(posedge clk) begin
    if (clk_en) begin
        frm_mrkr_out <= frm_mrkr_d;
        subfrm_mrkr_out <= subfrm_mrkr_d;
        slot_mrkr_out <= slot_mrkr_d;
        sym_mrkr_out <= sym_mrkr_d;
        sym_mrkr_4x_out <= sym_mrkr_4x_d;
        sym_cnt_out <= sym_cnt_d;
        sym_cnt_4x_out <= sym_cnt_4x_d;
    end
end

always_ff @(posedge clk) begin
    if (clk_en) begin
        if (aligned) begin
            case (alignment)
                0 : begin
                    IFP_fft_out.tdata  <= IFP_fft_in_d.tdata;
                    IFP_fft_out.tvalid <= IFP_fft_in_d.tvalid;
                    IFP_fft_out.tuser  <= IFP_fft_in_d.tuser;
                    IFP_fft_out.tkeep  <= IFP_fft_in_d.tkeep;
                    IFP_fft_out.tlast  <= IFP_fft_in_d.tlast;
                    end
                1 : begin
                    IFP_fft_out.tdata  <= IFP_fft_in_2d.tdata;
                    IFP_fft_out.tvalid <= IFP_fft_in_2d.tvalid;
                    IFP_fft_out.tuser  <= IFP_fft_in_2d.tuser;
                    IFP_fft_out.tkeep  <= IFP_fft_in_2d.tkeep;
                    IFP_fft_out.tlast  <= IFP_fft_in_2d.tlast;
                    end
                2 : begin
                    IFP_fft_out.tdata  <= IFP_fft_in_3d.tdata;
                    IFP_fft_out.tvalid <= IFP_fft_in_3d.tvalid;
                    IFP_fft_out.tuser  <= IFP_fft_in_3d.tuser;
                    IFP_fft_out.tkeep  <= IFP_fft_in_3d.tkeep;
                    IFP_fft_out.tlast  <= IFP_fft_in_3d.tlast;
                    end
                3 : begin
                    IFP_fft_out.tdata  <= IFP_fft_in_4d.tdata;
                    IFP_fft_out.tvalid <= IFP_fft_in_4d.tvalid;
                    IFP_fft_out.tuser  <= IFP_fft_in_4d.tuser;
                    IFP_fft_out.tkeep  <= IFP_fft_in_4d.tkeep;
                    IFP_fft_out.tlast  <= IFP_fft_in_4d.tlast;
                    end
                default : begin
                    IFP_fft_out.tdata  <= IFP_fft_in_d.tdata;
                    IFP_fft_out.tvalid <= IFP_fft_in_d.tvalid;
                    IFP_fft_out.tuser  <= IFP_fft_in_d.tuser;
                    IFP_fft_out.tkeep  <= IFP_fft_in_d.tkeep;
                    IFP_fft_out.tlast  <= IFP_fft_in_d.tlast;
                    end
            endcase
        end
    end
end

 */


 //localparam  PRACH_ALIGN_IDLE=0;
 //localparam PRACH_ALIGN_DRIVE=1;
// localparam PRACH_WAIT_TUSER0=2;////
  
typedef enum logic [1:0] {PRACH_ALIGN_IDLE, PRACH_ALIGN_DRIVE,PRACH_WAIT_TUSER0} prach_fft_align_t;


prach_fft_align_t  prach_fft_align;

 //logic [1:0] prach_fft_align;
  
always @(posedge clk) begin
      //Remove reset since FPGA reset can take resources
   if (reset) begin
      prach_fft_align <= PRACH_ALIGN_IDLE;
      subfrm_mrkr_out <= 1'b0;
      frm_mrkr_out <= 1'b0;     
      IFP_fft_out.tdata  <= 0;
      IFP_fft_out.tvalid <= 0;
      IFP_fft_out.tuser  <= 0;
      IFP_fft_out.tkeep  <= 0;
      IFP_fft_out.tlast  <= 0;
   end
   else if (clk_en) begin
      subfrm_mrkr_out <= subfrm_mrkr;
      frm_mrkr_out <= frm_mrkr;
      IFP_fft_out.tdata  <= IFP_fft_in.tdata;
      IFP_fft_out.tuser  <= IFP_fft_in.tuser;
      IFP_fft_out.tkeep  <= IFP_fft_in.tkeep;
      IFP_fft_out.tlast  <= IFP_fft_in.tlast;     
      case (prach_fft_align)
        PRACH_ALIGN_IDLE :  begin
           if (frm_mrkr & car_en) begin // car_en is static high when enabled, frm_mrkr is a pulse
	      if (IFP_fft_in.tvalid & IFP_fft_in.tuser==0) begin
                 IFP_fft_out.tvalid <= IFP_fft_in.tvalid;
	         prach_fft_align <= PRACH_ALIGN_DRIVE;
	      end
	      else begin
	         prach_fft_align <= PRACH_WAIT_TUSER0;
                 IFP_fft_out.tvalid <= 1'b0;
	      end	 
	   end
	   else begin
	      
        end
        end
	PRACH_ALIGN_DRIVE : begin
	   if (!car_en) begin
	      prach_fft_align <= PRACH_ALIGN_IDLE;
              IFP_fft_out.tvalid <= 1'b0;
	   end
	   else begin
              IFP_fft_out.tvalid <= IFP_fft_in.tvalid;
	      prach_fft_align <= PRACH_ALIGN_DRIVE;
	   end // else: !if(!car_en)
	end
	PRACH_WAIT_TUSER0 : begin
	   if (!car_en) begin
	      prach_fft_align <= PRACH_ALIGN_IDLE;
              IFP_fft_out.tvalid <= 1'b0;
	   end
	   else if (IFP_fft_in.tvalid & IFP_fft_in.tuser==0) begin
              IFP_fft_out.tvalid <= IFP_fft_in.tvalid;
	      prach_fft_align <= PRACH_ALIGN_DRIVE;
	   end
	   else begin
              IFP_fft_out.tvalid <= 1'b0;
	      prach_fft_align <= PRACH_WAIT_TUSER0;
	   end
	end // case: PRACH_WAIT_TUSER0
      endcase // case (prach_fft_align)
   end // if (clk_en)
end // always @ (posedge clk)
   
	      

endmodule
