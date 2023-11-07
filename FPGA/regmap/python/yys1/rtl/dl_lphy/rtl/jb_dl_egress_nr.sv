
///////////////////////////////////////////////////////////////////////////////////
////  File Name : jb_dl_egress.sv
///// Author    : Shehanaj Begum
///// Date      : 10/20/2020
///// Description  : This module 
////////////////////////////////////////////////////////////////////////////////////
`timescale 1ns / 1ps


module jb_dl_egress_nr # (
    parameter N_ANTENNAS = 4,
    parameter IFFT_DATA_WIDTH = 32,
    parameter RD_ADDR_WIDTH = 12,
    parameter INST = 1
) (   
      input                    clk,
      input                    reset,
      input                    clk_en,

      input                    dl_oran_ready,
      input                    dl_oran_en,
 
      input [3:0]              dl_car_bw,
      input                    dl_swap_ifft,
      input                    dl_iq_endianness,     
      input                    dl_pre_sym_mrkr,    
      input                    dl_sym_mrkr,
      input                    dl_sym_mrkr_4x_ifft,
      
      jb_ram_sp_if.host        IFP_dl_mem2ifft,
      jb_axi4_stream_if.master IFP_dl_oran_out 
 );
 `include "jb_common.svh"
 
   localparam IFFT_DATA_LATENCY=2;
   localparam MEM_LATENCY=3;

   logic [MEM_LATENCY-1:0] [1:0]   ant_id_egress_dly;
   logic [N_MAX_TONE_BW-1:0] 	   n_tones;//15:0 1200->3276
   logic [N_MAX_TONE_BW-1:0] 	   n_half_tones;//600->1638
   logic [N_MAX_TONE_BW-1:0] 	   n_zero_tones;
   logic [N_MAX_TONE_BW-1:0]       tone_cnt;
   
   
   logic [1:0]   ant_id_egress;

   logic [IFFT_DATA_WIDTH-1:0] rd_data;
   logic [RD_ADDR_WIDTH-2:0]   rd_ptr;
   logic [RD_ADDR_WIDTH-2:0]   rd_ptr_mux;
   logic [RD_ADDR_WIDTH-2:0]   rd_ptr_swap_fft;//1200->3276 
   logic                       rd_ping_pong;
   
   logic                       ifft_tvalid;
   logic [IFFT_DATA_WIDTH-1:0] ifft_tdata;
   logic [1:0]                 ifft_tuser;
   logic  [IFFT_DATA_LATENCY-1:0] sym_4x_mrkr_dlyd;
   logic 			  last_read;
   logic [MEM_LATENCY-1:0]       last_read_dlyd;
   logic  	               ifft_tlast;
   logic [IFFT_DATA_WIDTH-1:0] 		    rd_data_mapped;
   logic [15:0]                         rd_data_mapped_i;
   logic [15:0]                         rd_data_mapped_q;
   logic first_read;
   logic [MEM_LATENCY-1:0] first_read_dlyd;
   
   dl_oran_egress_sm_t dl_oran_egress_sm;

  
   
  //IO assignmnt
   assign IFP_dl_mem2ifft.en=rd_en;
   assign IFP_dl_mem2ifft.wr_en=1'b0;
   assign IFP_dl_mem2ifft.addr={rd_ping_pong,rd_ptr_mux};
   assign IFP_dl_mem2ifft.wr_data=0;
   assign rd_data=IFP_dl_mem2ifft.rd_data;
   

   assign IFP_dl_oran_out.tvalid=ifft_tvalid;
   assign IFP_dl_oran_out.tdata=ifft_tdata;
   assign IFP_dl_oran_out.tuser=ifft_tuser;
   assign IFP_dl_oran_out.tkeep=8'hFF;
   assign IFP_dl_oran_out.tlast=ifft_tlast;
   assign ifft_tready = IFP_dl_oran_out.tready;

   assign ifft_tuser = ifft_tuser_2d;
   assign n_tones=f_num_tones(dl_car_bw);
   assign n_half_tones = n_tones[N_MAX_TONE_BW-1:1];
   assign n_zero_tones = f_num_guard_tones(dl_car_bw);
   //
   /*
   assign rd_en = dl_oran_en & dl_oran_ready & clk_en;
   assign rd_ping_pong = ant_id_egress[0];

   assign n_tones=f_num_tones(dl_car_bw);
   //assign n_tones=1200;
   assign n_half_tones = n_tones[N_MAX_TONE_BW-1:1];
   assign n_zero_tones = f_num_guard_tones(dl_car_bw);
   //assign n_zero_tones = 848;
   
   assign rd_ptr_swap_fft = (rd_ptr < n_half_tones) ? (n_half_tones + rd_ptr) : (rd_ptr - n_half_tones );
   assign rd_ptr_mux = dl_swap_ifft ? rd_ptr_swap_fft : rd_ptr;
   
   assign last_read = (rd_ptr == n_tones-1) ? 1'b1 : 1'b0;
   
   assign first_read = ( dl_oran_egress_sm== DL_ORAN_EGRS_FIRST_CYCLE) ? 1'b1 : 1'b0;
    //If precision changes, update this
   assign rd_data_mapped_i = dl_iq_endianness ? rd_data[31:16] : {rd_data[7:0], rd_data[15:8]};
   assign rd_data_mapped_q = dl_iq_endianness ? rd_data[15:0] :  {rd_data[23:16], rd_data[31:24]};
   assign rd_data_mapped =  {rd_data_mapped_q,rd_data_mapped_i};
   */
   //tyh change for timing
  logic rd_en ;
  
    always @(posedge clk) begin
           rd_en <= (dl_oran_en & dl_oran_ready & clk_en);
    end

    always @(posedge clk) begin
           rd_ping_pong <= ant_id_egress_dly[MEM_LATENCY-1];
    end

    always @(posedge clk) begin
            if(dl_swap_ifft)
		     begin 
			    if(rd_ptr < n_half_tones)
			      rd_ptr_mux <= n_half_tones + rd_ptr ;
			    else 
		          rd_ptr_mux <= rd_ptr - n_half_tones ;
		     end
		    else 
			      rd_ptr_mux <= rd_ptr ;		   
    end

    always @(posedge clk) begin
            if(rd_ptr == n_tones-1)
			   last_read <= 1'b1 ;
			else
			   last_read <= 1'b0 ;
    end
     
    always @(posedge clk) begin
            if( dl_oran_egress_sm== DL_ORAN_EGRS_FIRST_CYCLE)
			   first_read <= 1'b1 ;
			else
			   first_read <= 1'b0 ;
    end

    always @(posedge clk) begin
            if(dl_iq_endianness== 1'b1)
			   rd_data_mapped   <= {rd_data[15:0],rd_data[31:16]} ;
			else
			   rd_data_mapped   <= {{rd_data[23:16], rd_data[31:24]},{rd_data[7:0], rd_data[15:8]}} ;
    end

//tyh add for timming
logic   ifft_tuser_1d ;
logic   ifft_tuser_2d ;

always @(posedge clk) begin
            ifft_tuser_1d <= ant_id_egress_dly[MEM_LATENCY-1];
			ifft_tuser_2d <= ifft_tuser_1d;
    end

///////////////////////////////////////


 always @(posedge clk) begin
      if (reset) begin
	 ant_id_egress_dly <= '{default:0};
	 first_read_dlyd <= 0;
	 last_read_dlyd <= 0;
	 ifft_tdata <= 0;
	 ifft_tvalid <=0;
	 ifft_tlast<=1'b0;
      end
      else if (clk_en) begin
	 ant_id_egress_dly[0] <= ant_id_egress;
	 last_read_dlyd[0] <= last_read;
	 first_read_dlyd[0] <= first_read;
//	 ifft_tdata <= first_read_dlyd[MEM_LATENCY-1] ? 0 : rd_data_mapped;
     ifft_tdata <=  rd_data_mapped;
	 ifft_tlast<=last_read_dlyd[MEM_LATENCY-1];
//	 if ((ifft_tlast) && (ifft_tuser==N_ANTENNAS-1))  begin
//	    ifft_tvalid <= 1'b0;
//	 end
//	 else if (ifft_tready) begin
//	    ifft_tvalid <= 1'b1;
//	 end	    
	 ifft_tvalid <=dl_oran_en & dl_oran_ready & ifft_tready;
	 for(int i=1;i<MEM_LATENCY;i=i+1) begin //+1 is for the pipeline stage I added before MULT
	    ant_id_egress_dly[i] <= ant_id_egress_dly[i-1];
	    last_read_dlyd[i] <= last_read_dlyd[i-1];
	    first_read_dlyd[i] <= first_read_dlyd[i-1];
	 end 	 
      end // else: !if(!resetn)
     end // always @ (posedge clk)


always @(posedge clk) begin
      //Remove reset since FPGA reset can take resources
   if (reset) begin
      dl_oran_egress_sm <= DL_ORAN_EGRS_IDLE;
      ant_id_egress <=0;
      rd_ptr <= 0; 
      tone_cnt <= 0;
   end
   else if (clk_en) begin
      case (dl_oran_egress_sm)
        DL_ORAN_EGRS_IDLE :  begin
           if (dl_oran_en & dl_oran_ready & dl_pre_sym_mrkr) begin // oran_en should be enabled when carrier is enabled and radio_if is enable
	      ant_id_egress <=0;
	      rd_ptr <= 0;
	      tone_cnt <=0;
	      dl_oran_egress_sm <= DL_ORAN_EGRS_FIRST_CYCLE;
	   end
        end
	DL_ORAN_EGRS_FIRST_CYCLE : begin	
	  if(dl_sym_mrkr_4x_ifft)
	     begin
	      rd_ptr <= 0;
	      tone_cnt <=0; 
	      dl_oran_egress_sm <= DL_ORAN_EGRS_DRIVE_FIRST_HALF_TONES;
	     end
	  else
	     begin
	      rd_ptr <= 0;
	      tone_cnt <=0; 
	      dl_oran_egress_sm <= DL_ORAN_EGRS_FIRST_CYCLE;
	     end 
	end
	DL_ORAN_EGRS_DRIVE_FIRST_HALF_TONES : begin
	   if (tone_cnt ==n_half_tones-1) begin
	      rd_ptr <= rd_ptr + 1;
	      tone_cnt <= 0;
	      dl_oran_egress_sm <= DL_ORAN_EGRS_ZERO_TONES;
	   end
	   else begin
	      rd_ptr <= rd_ptr + 1;
	      dl_oran_egress_sm <= DL_ORAN_EGRS_DRIVE_FIRST_HALF_TONES;
	      tone_cnt <= tone_cnt + 1;
	   end
	end
	DL_ORAN_EGRS_ZERO_TONES : begin
	   if (tone_cnt == n_zero_tones-1) begin
	      rd_ptr <= rd_ptr;
	      tone_cnt <= 0;
	      dl_oran_egress_sm <= DL_ORAN_EGRS_DRIVE_SECOND_HALF_TONES;
	   end
	   else begin //no change in rd_ptr
	      dl_oran_egress_sm <= DL_ORAN_EGRS_ZERO_TONES;
	      tone_cnt <= tone_cnt + 1;
	   end
	end 
	DL_ORAN_EGRS_DRIVE_SECOND_HALF_TONES : begin
	   if ((ant_id_egress==N_ANTENNAS-1) && (tone_cnt==n_half_tones-1)) begin
	      rd_ptr <= 0;
	      tone_cnt <= 0;
	      ant_id_egress<= 0;
	      dl_oran_egress_sm <= DL_ORAN_EGRS_IDLE;
	   end
	   else if (tone_cnt==n_half_tones-1) begin
	      rd_ptr <= 0;
	      ant_id_egress<= ant_id_egress+1;
	      tone_cnt <= 0;
	      dl_oran_egress_sm <= DL_ORAN_EGRS_FIRST_CYCLE;
	   end
	   else begin
	      rd_ptr <= rd_ptr + 1;
	      dl_oran_egress_sm <= DL_ORAN_EGRS_DRIVE_SECOND_HALF_TONES;
	      tone_cnt <= tone_cnt + 1;
	   end
	end
	default : begin
	   dl_oran_egress_sm <= DL_ORAN_EGRS_IDLE;
	   ant_id_egress <=0;
	   rd_ptr <= 0; 
	   tone_cnt <= 0;
	end
      endcase // case (dl_oran_egress_sm)
   end // if (clk_en)
end // always @ (posedge clk)
/* 
generate 
if (INST == 0) begin  

  ila_dl_oran_egress ila_egress (
	.clk(clk), // input wire clk
	.probe0(rd_en), // input wire [0:0]  probe0  
	.probe1({rd_ping_pong,rd_ptr_mux}), // input wire [11:0]  probe1 
	.probe2(rd_data), // input wire [31:0]  probe2 
	.probe3(ifft_tvalid), // input wire [0:0]  probe3 
	.probe4(ifft_tdata), // input wire [31:0]  probe4 
	.probe5(ifft_tuser), // input wire [1:0]  probe5 
	.probe6(tone_cnt[11:0]), // input wire [11:0]  probe6 
	.probe7(dl_pre_sym_mrkr), // input wire [0:0]  probe7 
	.probe8(last_read), // input wire [0:0]  probe8 
	.probe9(rd_en), // input wire [0:0]  probe9
	.probe10(dl_oran_egress_sm), // input wire [0:0]  probe9
	.probe11(ifft_tready), // input wire [0:0]  probe9
	.probe12(clk_en), // input wire [0:0]  probe9
	.probe13(ifft_tlast) // input wire [0:0]  probe9
); 
end
endgenerate
  */  
endmodule // jb_dl_egress

