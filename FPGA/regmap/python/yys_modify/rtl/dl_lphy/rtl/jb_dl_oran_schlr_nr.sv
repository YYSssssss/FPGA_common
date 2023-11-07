
///// Description  : This module is an interface block between Radio IF IP and iFFT block   
////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps

module jb_dl_oran_schlr_nr #(
    parameter N_ANTENNAS= 4,
    parameter FH_DATA_WIDTH=64,
    parameter DEFM_TUSER_WIDTH=31,
    parameter INST = 1
) (
      input                    clk,
      input                    reset,
      input                    sym_mrkr,
      input                    pre_sym_mrkr,
      input                    sym_mrkr_4x,
      input [3:0]              car_bw,
      input                    oran_en,
      input [N_ANTENNAS-1:0]   ant_en, 
      output logic              dl_oran_ready,
      jb_axi4_stream_if.slave  IFP_dl_oran_in[N_ANTENNAS-1:0], //From Radio IF IP
      jb_ram_sp_if.host        IFP_dl_oran2mem
              
);

`include  "jb_common.svh"

   localparam N_ANTENNAS_BW=2;
   localparam N_CARRIERS_BW=1;
   

   logic [N_ANTENNAS-1:0] [FH_DATA_WIDTH-1:0] tdata_in;
   logic [N_ANTENNAS-1:0]  tvalid_in;
   logic [N_ANTENNAS-1:0]  [7:0] tkeep_in;
   logic [N_ANTENNAS-1:0]  tlast_in;
   logic [N_ANTENNAS-1:0]  tlast_in_dlyd;
   logic [N_ANTENNAS-1:0]  [DEFM_TUSER_WIDTH-1:0] tuser_in;
   logic [N_ANTENNAS-1:0] tready_out;
 

   
   logic [4:0]                section_cnt=0;
   logic [N_ANTENNAS_BW-1:0]   ant_cnt; //based N_ANTENNAS, $clog2 gave me trouble in synth before


   logic [N_ANTENNAS-1:0] [N_CARRIERS_BW-1:0] tuser_car_id;
   logic [N_ANTENNAS-1:0] 		      tuser_symb_mrkr;
   logic [N_ANTENNAS-1:0] 		      tuser_rb;
   logic [N_ANTENNAS-1:0] [3:0] 	      tuser_iq_signal_width;//16
   logic [N_ANTENNAS-1:0] [2:0] 	      tuser_compression_type;//0 [3:0]->2:0
   logic [N_ANTENNAS-1:0] [8:0] 	      tuser_num_rb; //100 [7:0]-> 8:0
   logic [N_ANTENNAS-1:0] [9:0] 	      tuser_start_rb; //0
   
   logic 				      rb;
   logic [8:0] 				      rb_scale;//add 1 bit to support 273
   logic [9:0] 				      rb_num_loc;//add 1 bit to support 1632
   logic [10:0] 				  rb_ptr;
   logic [10:0] 				  wr_ptr_per_bufer;//add 1 bit to support 1638
   logic [11:0] 			      wr_ptr;//add 1 bit to support pingpang
   logic [9:0] 				      start_rb;
   logic [8:0] 				      rb_cnt;//add 1 bit to support 273
   logic [2:0] 				      sc_ptr;
   logic 				      wr_en;
   logic [FH_DATA_WIDTH-1:0] 		      wr_data;
   logic 				      ping_pong;
   
   logic 				      sym_mrkr_by_4;
   logic [9:0] 				      n_rb_whole_sym;//273
   logic [9:0] 				      num_section_rb;//273
   logic 				      section_write_too_long_err;
   logic                      no_tlast_when_section_ended_err;
   
   logic 				      num_rb_mismatch_err;
   
   logic 				      unexpected_tvalid_sections_mismatch;
   logic 				      no_tvalid_err;
   logic 				      out_of_sync_err;
   logic [4:0] 				      n_section=5'd4;
   
      logic [3:0]              car_bw_d;
      logic                    oran_en_d;
      logic [N_ANTENNAS-1:0]   ant_en_d; 
   
   dl_oran_schlr_sm_t dl_oran_schlr_sm;
   dl_oran_schlr_sm_t dl_oran_schlr_sm_dlyd_ila;
   
   jb_axi4_stream_if   #(.DATA_WIDTH(FH_DATA_WIDTH), .USER_SB_WIDTH(DEFM_TUSER_WIDTH)) IFP_dl_oran_in_d [N_ANTENNAS-1:0] ();
   
      always @(posedge clk) begin
        IFP_dl_oran_in_d[0].tvalid <= IFP_dl_oran_in[0].tvalid; 
		IFP_dl_oran_in_d[0].tdata  <= IFP_dl_oran_in[0].tdata ; 
		IFP_dl_oran_in_d[0].tkeep  <= IFP_dl_oran_in[0].tkeep ; 
		IFP_dl_oran_in_d[0].tlast  <= IFP_dl_oran_in[0].tlast ; 
		IFP_dl_oran_in_d[0].tuser  <= IFP_dl_oran_in[0].tuser ; 
		
		IFP_dl_oran_in_d[1].tvalid <= IFP_dl_oran_in[1].tvalid; 
		IFP_dl_oran_in_d[1].tdata  <= IFP_dl_oran_in[1].tdata ; 
		IFP_dl_oran_in_d[1].tkeep  <= IFP_dl_oran_in[1].tkeep ; 
		IFP_dl_oran_in_d[1].tlast  <= IFP_dl_oran_in[1].tlast ; 
		IFP_dl_oran_in_d[1].tuser  <= IFP_dl_oran_in[1].tuser ; 
		
		IFP_dl_oran_in_d[2].tvalid <= IFP_dl_oran_in[2].tvalid; 
		IFP_dl_oran_in_d[2].tdata  <= IFP_dl_oran_in[2].tdata ; 
		IFP_dl_oran_in_d[2].tkeep  <= IFP_dl_oran_in[2].tkeep ; 
		IFP_dl_oran_in_d[2].tlast  <= IFP_dl_oran_in[2].tlast ; 
		IFP_dl_oran_in_d[2].tuser  <= IFP_dl_oran_in[2].tuser ; 
		
		IFP_dl_oran_in_d[3].tvalid <= IFP_dl_oran_in[3].tvalid; 
		IFP_dl_oran_in_d[3].tdata  <= IFP_dl_oran_in[3].tdata ; 
		IFP_dl_oran_in_d[3].tkeep  <= IFP_dl_oran_in[3].tkeep ; 
		IFP_dl_oran_in_d[3].tlast  <= IFP_dl_oran_in[3].tlast ; 
		IFP_dl_oran_in_d[3].tuser  <= IFP_dl_oran_in[3].tuser ; 
	end	 
   
    genvar                     i;
   generate
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin : fh_assign
       assign tvalid_in[i] = IFP_dl_oran_in_d[i].tvalid;
       assign tdata_in[i] =  IFP_dl_oran_in_d[i].tdata;
       assign tkeep_in[i] =  IFP_dl_oran_in_d[i].tkeep;
       assign tlast_in[i] =  IFP_dl_oran_in_d[i].tlast;
       assign tuser_in[i] =  IFP_dl_oran_in_d[i].tuser;
       //assign IFP_dl_oran_in[i].tready = ant_en_d[i] ? tready_out[i] : 1'b1;
       assign IFP_dl_oran_in[i].tready = tready_out[i];
       //tuser decode for debug
         assign tuser_car_id[i]           = IFP_dl_oran_in_d[i].tuser[29:28];
         assign tuser_symb_mrkr[i]        = IFP_dl_oran_in_d[i].tuser[27];
         assign tuser_rb[i]               = IFP_dl_oran_in_d[i].tuser[26];
         assign tuser_iq_signal_width[i]  = IFP_dl_oran_in_d[i].tuser[25:22]; 
         assign tuser_compression_type[i] = IFP_dl_oran_in_d[i].tuser[21:19];//IFP_dl_oran_in[i].tuser[21:18]; 
         assign tuser_num_rb[i]           = IFP_dl_oran_in[i].tuser[18:10];//IFP_dl_oran_in[i].tuser[17:10]; 
         assign tuser_start_rb[i]         = IFP_dl_oran_in[i].tuser[9:0];        
      end : fh_assign
      
  
   endgenerate


    always @(posedge clk) begin
      begin
	 car_bw_d<= car_bw;
	 oran_en_d<= oran_en;
	 ant_en_d<= ant_en;
      end
   end
   

   always @(posedge clk) begin
      //Remove reset since FPGA reset can take resources
      if (reset) begin
	   tlast_in_dlyd=0;
      end
      else begin
	    tlast_in_dlyd<= tlast_in;
      end
   end
   
   assign sym_mrkr_by_4= sym_mrkr_4x;
   assign n_rb_whole_sym = f_num_rb(car_bw_d);
   

   //
   assign IFP_dl_oran2mem.en=wr_en_3d;
   assign IFP_dl_oran2mem.wr_en={8{wr_en_3d}};
   assign IFP_dl_oran2mem.addr=wr_ptr;
   assign IFP_dl_oran2mem.wr_data=wr_data_3d;
   
   
   // assign rb_scale = rb ? {rb_cnt, 1'b0} : rb_cnt; // if rb not set rb_scale is same as rb_cnt, else 0, 2, 4

   // assign rb_num_loc = start_rb + rb_scale;

   // assign rb_ptr = {rb_num_loc, 3'b000} - {2'b00, rb_num_loc, 1'b0};   //n*6= n*8-n*2, 12 sub carrier in a rb, 6 64 bit width memory locations in a rb
   
   // assign wr_ptr_per_bufer =  rb_ptr + sc_ptr;
   // assign wr_ptr =  {ping_pong, wr_ptr_per_bufer};

   // assign ping_pong = ant_cnt[0];
   
//tyh change for timming  
  logic 	ping_pong_1d;
  logic 	ping_pong_2d;
  logic 	ping_pong_3d;
  
  logic [2:0] 	sc_ptr_1d;
  logic [2:0] 	sc_ptr_2d;
  logic     wr_en_1d;
  logic     wr_en_2d;
  logic     wr_en_3d;
  logic     wr_en_4d;

  logic [FH_DATA_WIDTH-1:0]   wr_data_1d ;
  logic [FH_DATA_WIDTH-1:0]   wr_data_2d ;
  logic [FH_DATA_WIDTH-1:0]   wr_data_3d ;



   always @(posedge clk) begin
            ping_pong <= ant_cnt[0];
			ping_pong_1d <= ping_pong;
			ping_pong_2d <= ping_pong_1d;
   end
   
   always @(posedge clk) begin
        if(rb==1'b1)  
		  rb_num_loc <= {rb_cnt, 1'b0} + start_rb ;
		else 
		  rb_num_loc <= rb_cnt + start_rb ;
   end
   
   always @(posedge clk) begin
          rb_ptr <=  {rb_num_loc, 3'b000} - {2'b00, rb_num_loc, 1'b0}; 
   end
   
   always @(posedge clk) begin
          sc_ptr_1d<= sc_ptr ;
		  sc_ptr_2d<= sc_ptr_1d ;
   end
   
   always @(posedge clk) begin
          wr_ptr_per_bufer <=  rb_ptr + sc_ptr_2d;
		  wr_ptr <=  {ping_pong_2d, wr_ptr_per_bufer};
   end
   
   always @(posedge clk) begin
          wr_en_1d<=wr_en ;
		  wr_en_2d<=wr_en_1d ;
		  wr_en_3d<=wr_en_2d ;
		  wr_en_4d<=wr_en_3d ;
		 
		  wr_data_1d<=wr_data ;
		  wr_data_2d<=wr_data_1d ;
		  wr_data_3d<=wr_data_2d ;
   end 
   
   //Note, todo, dont have to use pre sym marker, just look for oran_en in every state and then wait
   //assert tready_out and wait until cc_enable from radio ip goes low and then back to IDLE state
   always @(posedge clk) begin
      //Remove reset since FPGA reset can take resources
      if (reset) begin
	 dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE;
	 ant_cnt <= 0;
	 section_cnt <= 0;
	 start_rb <= 0;
	 rb_cnt <= 0;
	 sc_ptr <=0;
	 rb <= 1'b0; //alternate when set
	 wr_en <= 1'b0;
	 wr_data <= 0;
	 dl_oran_ready <= 1'b0;
         tready_out <= 0;
         no_tvalid_err <= 1'b0;
	 out_of_sync_err <= 1'b0;
	 num_rb_mismatch_err<= 1'b0;
         num_section_rb <= 0;
         unexpected_tvalid_sections_mismatch <= 1'b0;
         section_write_too_long_err<=1'b0;
	 no_tlast_when_section_ended_err<=1'b0;   	 
      end
      else begin
       case (dl_oran_schlr_sm)
         DL_ORAN_SCHLR_IDLE :  begin
            ant_cnt <= 0;
            section_cnt <= 0;
            start_rb <= 0;
            rb_cnt <= 0;
            sc_ptr <=0;
            rb <= 1'b0; //alternate when set
            wr_en <= 1'b0;
			wr_data <= 0; 
            tready_out <= 0;
            num_section_rb <= 0;
            unexpected_tvalid_sections_mismatch <= 1'b0;
            section_write_too_long_err<=1'b0;
	    no_tlast_when_section_ended_err<=1'b0; 
            num_rb_mismatch_err<= 1'b0;
            no_tvalid_err <= 1'b0;
	    out_of_sync_err <= 1'b0;
            if (oran_en_d & (|ant_en_d) & sym_mrkr) begin // oran_en should be enabled when carrier is enabled and radio_if is enable
    //           wr_en <= 1'b1;
               dl_oran_schlr_sm <= DL_ORAN_INIT_MEM;
            end            
         end
         DL_ORAN_INIT_MEM : begin //should never get sym markers in this state
	    num_rb_mismatch_err<= 1'b0;
            unexpected_tvalid_sections_mismatch <= 1'b0;
            section_write_too_long_err<=1'b0;
	    no_tlast_when_section_ended_err<=1'b0;  
            no_tvalid_err <= 1'b0; 
	    out_of_sync_err <= 1'b0;
            if ((rb_cnt == n_rb_whole_sym-1) && (sc_ptr == 5)) begin // Nn_rb_whole_symrb is extracted from ch_bw
             if (ant_en_d[ant_cnt]==1'b1) begin
                if (tvalid_in[ant_cnt]==1'b1) begin
                   dl_oran_schlr_sm <= DL_ORAN_WRITE_SECTIONS;
                   tready_out[ant_cnt] <= 1'b1;
                   start_rb <= tuser_start_rb[ant_cnt];
                   num_section_rb <=  tuser_num_rb[ant_cnt];
                   rb <= tuser_rb[ant_cnt]; //alternate when set
                   rb_cnt <= 0;
                   sc_ptr <=0;
                   section_cnt <= 0;
                   wr_en <= 1'b1;
                   wr_data <= tdata_in[ant_cnt]; 
                end
                else begin
                   dl_oran_schlr_sm <= DL_ORAN_WAIT_TVALID;
				   tready_out[ant_cnt] <= 1'b0;
                   wr_en <= 1'b0;
                end // else: !if(tvalid_in[ant_cnt]==1'b1)
             end
             else begin //antenna is not enabled, go and wait for symbol marker
		//ant_cnt <= ant_cnt+1;
                wr_en <= 1'b0;
                tready_out[ant_cnt] <= 1'b1;
                //if (ant_cnt == N_ANTENNAS -1) begin                   
                //   dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE;
               // end
                //else begin    //wait for 4x marker 
                   dl_oran_schlr_sm <= DL_ORAN_WAIT_SYMB_MRKR_BY4;
                //end
             end // else: !if(ant_en_d[ant_cnt]==1'b1)
            end // if (rb_cnt == n_rb-1)
            else begin //still initializing
             if (sc_ptr == 5) begin //for 64 bit data 6x2, still writing the data
                rb_cnt <= rb_cnt + 1;
                sc_ptr <=0;
             end
             else begin
                sc_ptr <= sc_ptr +1;
                if ((rb_cnt == n_rb_whole_sym-1) && (sc_ptr == 4) && (ant_en_d[ant_cnt]==1'b1)) begin
                       tready_out[ant_cnt] <= 1'b1; //Set tready out one cycle early, to save a cycle and remove complexity
                end   
             end
             wr_en <= 1'b1;
             wr_data<= 0;
             dl_oran_schlr_sm <= DL_ORAN_INIT_MEM;
            end // else: !if(wr_ptr == n_tones_by_2 -1)
         end // case: DL_ORAN_INIT_MEM
         DL_ORAN_WRITE_SECTIONS : begin
            if (pre_sym_mrkr) begin 
              dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE;
              section_write_too_long_err<=1'b1; //timeout while writing setions
              wr_en <= 1'b0;
              tready_out <= 0;
	       dl_oran_ready <= 1'b1;
              ant_cnt<= 0; //wraps around
           end
            else if (sym_mrkr_by_4) begin // should never happen error condition, sym maker is asserted 
              dl_oran_schlr_sm <= DL_ORAN_INIT_MEM;
	       dl_oran_ready <= 1'b1;
              tready_out <= 0;
              section_cnt <= 0;
              start_rb <= 0;
              rb_cnt <= 0;
              sc_ptr <=0;
              rb <= 1'b0; //alternate when set
              wr_en <= 1'b1;
              wr_data <= 0;
              section_write_too_long_err<=1'b1; // timeout while writing setions
              ant_cnt <= ant_cnt + 1; //wraps around
            end  
            else if ((section_cnt == n_section-1) &&  (rb_cnt == num_section_rb-1) && (sc_ptr ==5))  begin
	       if (tlast_in[ant_cnt]!=1) begin
		  no_tlast_when_section_ended_err <= 1'b1;
	       end
               dl_oran_ready <= 1'b1;
			   rb_cnt <= 0;
               sc_ptr <=0;
	       //ant_cnt <= ant_cnt + 1;
            //   wr_en <= 1'b0;
			   if(tvalid_in[ant_cnt])begin
			   wr_data <= tdata_in[ant_cnt];
			   wr_en <= 1'b1;
			   end
               tready_out <= 0;
               if (ant_cnt == N_ANTENNAS-1) begin //go back to idle and wait for sym count
                   dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE;
                end
                else begin // if antennas are not done    
                   dl_oran_schlr_sm <= DL_ORAN_WAIT_SYMB_MRKR_BY4;
                end
             end //all sections are done
            else if (tvalid_in[ant_cnt]) begin
	       if ((rb_cnt == num_section_rb-1) && (sc_ptr ==5)) begin
		  section_cnt <= section_cnt + 1;
		  rb_cnt <= 0;
          sc_ptr <=0;
		  if (tlast_in[ant_cnt]!=1) begin
		     no_tlast_when_section_ended_err <= 1'b1;
		  end
	       end
               dl_oran_schlr_sm <= DL_ORAN_WRITE_SECTIONS;             
               start_rb <= tuser_start_rb[ant_cnt];
               num_section_rb <=  tuser_num_rb[ant_cnt];
               rb <= tuser_rb[ant_cnt]; //alternate when set
               wr_en <= 1'b1;
               wr_data <= tdata_in[ant_cnt];
               if  ((rb_cnt == num_section_rb-1) && (sc_ptr ==5))  begin //for 64 bit data      			  
				  rb_cnt <= 0;
                  sc_ptr <=0;
               end
               else if(sc_ptr ==5) begin
			      rb_cnt <= rb_cnt + 1;
                  sc_ptr <=0;
			   end
			  else begin
                  sc_ptr <= sc_ptr +1;
               end
            end // if (tvalid_in[ant_cnt]
            else begin
               dl_oran_schlr_sm <= DL_ORAN_WRITE_SECTIONS;
			   start_rb <= tuser_start_rb[ant_cnt];
               num_section_rb <=  tuser_num_rb[ant_cnt];
               wr_en <= 1'b0;
	       if ((rb_cnt == num_section_rb-1) && (sc_ptr ==5)) begin
		  section_cnt <= section_cnt + 1;
		  if (tlast_in[ant_cnt]!=1) begin
		     no_tlast_when_section_ended_err <= 1'b1;
		  end
	       end
            end 
         end // case: DL_ORAN_WRITE_SECTIONS
         DL_ORAN_WAIT_TVALID : begin //revisit this state
           if (pre_sym_mrkr) begin 
              dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE;
              wr_en <= 1'b0;
              tready_out <= 0;               
	      ant_cnt <= 0;
              dl_oran_ready <= 1'b1;
              no_tvalid_err <= 1'b1; //timed out while waiting for tvalid, send 0s to iFFT
           end
           else if (sym_mrkr_by_4) begin // dont wait until marker, may be just before before marker, use sym_cnt
              no_tvalid_err <= 1'b1; //timed out while waiting for tvalid, send 0s to iFFT
	      dl_oran_ready <= 1'b1;
              if (ant_cnt == N_ANTENNAS-1) begin //go back to idle and wait for sym count
                 dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE;
                 wr_en <= 1'b0;
                 tready_out <= 0;                
	         ant_cnt <= ant_cnt + 1;
              end
              else begin // if antennas are not done                    
                 dl_oran_schlr_sm <= DL_ORAN_INIT_MEM;               
	         ant_cnt <= ant_cnt + 1;
		 section_cnt <= 0;
		 start_rb <= 0;
		 rb_cnt <= 0;
		 sc_ptr <=0;
		 rb <= 1'b0; //alternate when set
		 wr_data <= 0; 
		 tready_out <= 0;
		 num_section_rb <= 0;
		 unexpected_tvalid_sections_mismatch <= 1'b0;
		 section_write_too_long_err<=1'b0;
		 no_tlast_when_section_ended_err<=1'b0;   
		 num_rb_mismatch_err<= 1'b0;
                 wr_en <= 1'b1;
              end // else: !if(ant_cnt == N_ANTENNAS-1)
           end
           // else if (tvalid_in[ant_cnt]==1'b1) begin
              // dl_oran_schlr_sm <= DL_ORAN_WRITE_SECTIONS;
              // wr_en <= 1'b1;
              // tready_out[ant_cnt] <= 1'b1;
              // wr_data <= tdata_in[ant_cnt];             
              // start_rb <= tuser_start_rb[ant_cnt];
              // num_section_rb <=  tuser_num_rb[ant_cnt];
              // rb <= tuser_rb[ant_cnt]; //alternate when set
              // section_cnt <=0;
	      // rb_cnt <= 0;
	      // sc_ptr <=0;
	      // unexpected_tvalid_sections_mismatch <= 1'b0;
	      // section_write_too_long_err<=1'b0;
	      // no_tlast_when_section_ended_err<=1'b0;   
	      // num_rb_mismatch_err<= 1'b0;
	      // no_tvalid_err <= 1'b0;
	      // out_of_sync_err <= 1'b0;
           // end
           else begin
              dl_oran_schlr_sm <= DL_ORAN_WAIT_TVALID;
           end
         end // case: DL_ORAN_WAIT_TVALID
         DL_ORAN_WAIT_SYMB_MRKR_BY4 : begin	    
            section_cnt <= 0;
            start_rb <= 0;
            rb_cnt <= 0;
            sc_ptr <=0;
            rb <= 1'b0; //alternate when set
            wr_en <= 1'b0;
			wr_data <= 0; 
            num_section_rb <= 0;
            unexpected_tvalid_sections_mismatch <= 1'b0;
            section_write_too_long_err<=1'b0;
	    no_tlast_when_section_ended_err<=1'b0;
            num_rb_mismatch_err<= 1'b0;
            no_tvalid_err <= 1'b0;
	    out_of_sync_err <= 1'b0;
	    if (pre_sym_mrkr) begin
               dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE;
 //              wr_en <= 1'b0;
               tready_out <= 0;
	       ant_cnt <= 0;
	       if (ant_cnt != N_ANTENNAS -1) begin
		  out_of_sync_err <= 1'b1;
	       end
	    end
            else if (sym_mrkr_by_4) begin // oran_en should be enabled when carrier is enabled and radio_if is enable
	       ant_cnt <= ant_cnt + 1;
//               wr_en <= 1'b1;
               dl_oran_schlr_sm <= DL_ORAN_INIT_MEM;
               tready_out <= 0;
            end      
         end   
		 
       default : begin
          dl_oran_schlr_sm <= DL_ORAN_SCHLR_IDLE; 
	  ant_cnt <= 0;
	  section_cnt <= 0;
	  start_rb <= 0;
	  rb_cnt <= 0;
	  sc_ptr <=0;
	  rb <= 1'b0; //alternate when set
	  wr_en <= 1'b0;
	  wr_data <= 0;
	  dl_oran_ready <= 1'b0;
          tready_out <= 0;
          no_tvalid_err <= 1'b0;
	  out_of_sync_err <= 1'b0;
	  num_rb_mismatch_err<= 1'b0;
          num_section_rb <= 0;
          unexpected_tvalid_sections_mismatch <= 1'b0;
          section_write_too_long_err<=1'b0;
	  no_tlast_when_section_ended_err<=1'b0;      
       end
       endcase       
      end // else: !if(!resetn_3x)
  end // always @ (posedge clk)

 always @(posedge clk) begin
      //Remove reset since FPGA reset can take resources
      if (reset) begin
	   dl_oran_schlr_sm_dlyd_ila=DL_ORAN_SCHLR_IDLE;
      end
      else begin
	    dl_oran_schlr_sm_dlyd_ila<= dl_oran_schlr_sm;
      end
 end
 
 //  generate 
//if (INST == 0) begin 
//   ila_dl_oran_schr u_ila_dl_oran_schlr (
//	.clk(clk), // input wire clkdl_oran_schlr_sm
//	.probe0(tvalid_in), // input wire [3:0]  probe0  
//	.probe1(tdata_in[0]), // input wire [63:0]  probe1 
//	.probe2(tready_out), // input wire [3:0]  probe2 
//	.probe3(IFP_dl_oran_in[0].tuser), // input wire [31:0]  probe3 
//	.probe4(wr_en), // input wire [0:0]  probe4 
//	.probe5(wr_data), // input wire [63:0]  probe5 
//	.probe6(wr_ptr), // input wire [10:0]  probe6 
//	.probe7(dl_oran_schlr_sm), // input wire [2:0]  probe7 
//	.probe8(ant_cnt[1:0]), // input wire [1:0]  probe8 
//	.probe9(rb_cnt[7:0]), // input wire [7:0]  probe9 
//	.probe10(sc_ptr[2:0]), // input wire [2:0]  probe10
//	.probe11(dl_oran_schlr_sm_dlyd_ila), // input wire [1:0]  probe8 
//	.probe12({out_of_sync_err,no_tvalid_err,num_rb_mismatch_err,unexpected_tvalid_sections_mismatch,section_write_too_long_err,no_tlast_when_section_ended_err}), // input wire [7:0]  probe9 
//	.probe13(sym_mrkr_by_4), // input wire [2:0]  probe10
//	.probe14(sym_mrkr), // input wire [2:0]  probe10
//	.probe15(tdata_in[1]), // input wire [63:0]  probe1 
//	.probe16(tdata_in[2]), // input wire [63:0]  probe1 
//	.probe17(tdata_in[3]) // input wire [63:0]  probe1 
//);
//end
//endgenerate

endmodule // jb_dl_oran_schlr
