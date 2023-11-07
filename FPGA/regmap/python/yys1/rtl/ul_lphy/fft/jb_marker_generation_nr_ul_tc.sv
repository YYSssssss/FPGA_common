`timescale 1ns / 1ps

module jb_marker_generation_nr_ul_tc #(
      parameter CLOCK_PERIOD = 8.13802083           //491.52 => 2.03450521  122.88 => 8.13802083  156.25 => 6.4 368.68Mhz => 2.7123793 245.76 => 4.06901042
) (
    input         clk,              // i clock  491.52Mhz
    input         reset,            // i reset
    input         car_en,           // i car_en
    input         frm_mrkr,         // i 10ms frm_mrkr on 491.52Mhz. Pulse
    input         extended_cp,      // i  nr -- 30k:not support , 60k:support
    
    // Real time signals
    output logic        frm_mrkr_out = 0,          // o frame marker aligned
    output logic [22:0] frm_mrkr_sample_cnt = 0,   // o framer marker sample count
    output logic        sub_frame_mrkr = 0,        // o sub frame marker every 1ms
    output logic [18:0] sub_frame_sample_cnt = 0,  // o sub frame sample count
    output logic [3:0]  sub_frame_cnt = 0,         // o sub frame count 0 to 9
    output logic        slot_mrkr = 0,             // o slot marker every 0.5ms
    output logic [17:0] slot_mrkr_sample_cnt = 0,  // o slot marker sample count
    output logic [4:0]  slot_cnt = 0,              // o slot count 0 to 19
    output logic        sym_mrkr = 0,              // o symbol marker 
    output logic        sym_mrkr_pre = 0,          // o pre symbol marker 1 clock earlier
    output logic [15:0] sym_mrkr_sample_cnt = 0,   // o symbol marker sample count
    output logic [3:0]  sym_cnt = 0,               // o symbol count
    output logic        cp_mrkr = 0,               // o CP marker
    output logic        sym_mrkr_4x = 0,            // o sym marker 4x rate 
	output logic [2:0]  sym_cnt_4x = 0 
    );
     
localparam [22:0] count_10ms_max    = (10000000/CLOCK_PERIOD) - 1;     //-400M  4000000-1
localparam [22:0] count_1ms_max     = (1000000/CLOCK_PERIOD) - 1;      //-400M  400000-1
localparam [22:0] count_0p5ms_max   = (500000/CLOCK_PERIOD) - 1;       //-400M  500000-1
logic [22:0] count_10ms             = count_10ms_max;  // For 491.52Mhz should be 4915199
logic [18:0] count_1ms              = count_1ms_max;   // For 491.52Mhz should be 491519 
logic [17:0] count_0p5ms            = count_0p5ms_max; // For 491.52Mhz should be 245759 

//localparam [15:0] symbol_size_first_real_value_ecp = (83333.33/CLOCK_PERIOD);
localparam [15:0] symbol_size_first_real_value = (36197.92/CLOCK_PERIOD) - 1;//(71875.00/CLOCK_PERIOD);
localparam [15:0] symbol_size_real_value = (35677.08/CLOCK_PERIOD) - 1;//(71354.17/CLOCK_PERIOD);

localparam [15:0] symbol_size_first_real_value_ori = (36197.92/CLOCK_PERIOD);//(71875.00/CLOCK_PERIOD);
localparam [15:0] symbol_size_real_value_ori = (35677.08/CLOCK_PERIOD) ;//(71354.17/CLOCK_PERIOD);

localparam [15:0] sym_1st_4x_2 = ((symbol_size_first_real_value_ori) >> 2)  ;
localparam [15:0] sym_1st_4x_3 = ((symbol_size_first_real_value_ori) >> 1)  ;
localparam [15:0] sym_1st_4x_4 = (((symbol_size_first_real_value_ori) >> 2) + ((symbol_size_first_real_value_ori) >> 1))  ;

localparam [15:0] sym_4x_2 = ((symbol_size_real_value_ori) >> 2)  ;
localparam [15:0] sym_4x_3 = ((symbol_size_real_value_ori) >> 1)  ;
localparam [15:0] sym_4x_4 = (((symbol_size_real_value_ori) >> 2) + ((symbol_size_real_value_ori) >> 1))  ;


//localparam [15:0] cp_size_first_real_value_ecp = (16666.66/CLOCK_PERIOD) - 1;
localparam [15:0] cp_size_first_real_value = (2864.58/CLOCK_PERIOD) ;//(5208.33/CLOCK_PERIOD) - 1;
localparam [15:0] cp_size_real_value = (2343.75/CLOCK_PERIOD) ;//(4687.50/CLOCK_PERIOD) - 1;
logic [15:0] symbol_size_first_real = 0;
logic [15:0] symbol_size_real       = 0;
logic [15:0] cp_size_first_real     = 0;
logic [15:0] cp_size_real           = 0;
logic [17:0] start_symbol_real      = 0; 
logic [17:0] prev_start_symbol_real = 0;
logic        frm_enable_markers = 0;
//typedef enum logic [2:0] {DL_ORAN_EGRS_IDLE, DL_ORAN_EGRS_DRIVE_FIRST_HALF_TONES,DL_ORAN_EGRS_ZERO_TONES,DL_ORAN_EGRS_DRIVE_SECOND_HALF_TONES,DL_ORAN_EGRS_FIRST_CYCLE} dl_oran_egress_sm_t;

/*
always_ff @(posedge clk) begin
    if (car_en && frm_mrkr)    enable_markers <= 1;
    else if (~car_en) enable_markers <= 0;
end
*/
always_ff @(posedge clk) begin
    if (car_en && frm_mrkr)    frm_enable_markers <= 1;
    else if (~car_en) frm_enable_markers <= 0;
end

always_ff @(posedge clk) begin  
    if (frm_mrkr) 
	         count_10ms <= 0;    
    else if (count_10ms == count_10ms_max) 
	         count_10ms <= 0;
	else if(frm_enable_markers==1)
	         count_10ms <= count_10ms + 1;
end

always_ff @(posedge clk) begin  
    if (frm_mrkr) 
	         count_1ms <= 0;  
    else if (count_1ms == count_1ms_max) 
	         count_1ms <= 0; 
	else if(frm_enable_markers==1)
	         count_1ms <= count_1ms + 1;
end

always_ff @(posedge clk) begin  
    if (frm_mrkr) 
	         count_0p5ms <= 0; 
    else if (count_0p5ms == count_0p5ms_max) 
	         count_0p5ms <= 0; 
	else if(frm_enable_markers==1)
	         count_0p5ms <= count_0p5ms + 1;     
end

// Count sub frames
always_ff @(posedge clk) begin
    if (count_10ms == 0) 
	         sub_frame_cnt <= 0;
    else if ((count_1ms == 0) && (frm_enable_markers==1))
	         sub_frame_cnt <= sub_frame_cnt + 1;
end

// Count slots
always_ff @(posedge clk) begin
    if (count_10ms == 0) 
	        slot_cnt <= 0;
    else if (count_0p5ms == 0) 
	        slot_cnt <= slot_cnt + 1;
end

// Register all outputs.
always_ff @(posedge clk) begin  
  if(frm_enable_markers==1)
   begin
    frm_mrkr_out <= (count_10ms == 0);
    frm_mrkr_sample_cnt <= count_10ms;
    sub_frame_mrkr <= (count_1ms == 0);
    sub_frame_sample_cnt <= count_1ms;
    slot_mrkr <= (count_0p5ms == 0);
    slot_mrkr_sample_cnt <= count_0p5ms;
   end
end

////////tyh change for timming
logic [15:0] sym_mrkr_sample_cnt_ind = 0; 
logic [3:0]  sym_cnt_ind = 0;      
logic        first_symbol_ind ;
logic        symbol_ind ;     
logic        first_cp_ind  ;
logic        cp_ind  ;

always_ff @(posedge clk) begin
      if(sym_mrkr_sample_cnt_ind==symbol_size_first_real_value - 1)
	    first_symbol_ind <= 1 ;
	  else
	    first_symbol_ind <= 0 ;
end

always_ff @(posedge clk) begin
      if(sym_mrkr_sample_cnt_ind==symbol_size_real_value - 1)
	    symbol_ind <= 1 ;
	  else
	    symbol_ind <= 0 ;
end


always_ff @(posedge clk) begin
    if (frm_mrkr) 
	       sym_mrkr_sample_cnt_ind <= 0;
	else if ((sym_cnt_ind==0)&&	(first_symbol_ind==1))  
           sym_mrkr_sample_cnt_ind <= 0;
	else if ((sym_cnt_ind!=0)&&	(symbol_ind==1))	
           sym_mrkr_sample_cnt_ind <= 0;
    else if(frm_enable_markers==1)
	       sym_mrkr_sample_cnt_ind <= sym_mrkr_sample_cnt_ind + 1;
end	
		   

always_ff @(posedge clk) begin
    if (frm_mrkr) 
	       sym_cnt_ind <= 0; 
	else if(frm_enable_markers==1)	   
		begin  
	      if ((sym_cnt_ind==13)&&(symbol_ind==1)) 
                 sym_cnt_ind <= 0;	   	   
          else if ((sym_cnt_ind==0)&&	(first_symbol_ind==1))  
                 sym_cnt_ind <= sym_cnt_ind + 1;
	      else if ((sym_cnt_ind!=0)&&	(symbol_ind==1)) 
                 sym_cnt_ind <= sym_cnt_ind + 1;
          else
	       sym_cnt_ind <= sym_cnt_ind ;
		end   
end

always_ff @(posedge clk) begin
    if((sym_mrkr_sample_cnt_ind==0)&&(frm_enable_markers==1))
       sym_mrkr <= 1 ;
    else 
       sym_mrkr <= 0 ;
end

always_ff @(posedge clk) begin
       sym_mrkr_sample_cnt <= sym_mrkr_sample_cnt_ind ;
       sym_cnt <= sym_cnt_ind ;
end

always_ff @(posedge clk) begin
    if (frm_mrkr) 
	       sym_mrkr_pre <= 1; 	   	   
    else if ((sym_cnt_ind==0)&&	(first_symbol_ind==1))  
           sym_mrkr_pre <= 1;
	else if ((sym_cnt_ind!=0)&&	(symbol_ind==1))  
           sym_mrkr_pre <= 1;
    else
	       sym_mrkr_pre <= 0 ;
end


always_ff @(posedge clk) begin
      if((sym_mrkr_sample_cnt_ind<=cp_size_first_real_value - 2)&&(frm_enable_markers==1))
	    first_cp_ind <= 1 ;
	  else
	    first_cp_ind <= 0 ;
end

always_ff @(posedge clk) begin
      if((sym_mrkr_sample_cnt_ind<=cp_size_real_value - 2)&&(frm_enable_markers==1))
	    cp_ind <= 1 ;
	  else
	    cp_ind <= 0 ;
end


always_ff @(posedge clk) begin
    if(sym_mrkr_pre==1)
	       cp_mrkr <= 1;
	else if((sym_cnt_ind==0)&& (first_cp_ind==1)) 
           cp_mrkr <= 1;
    else if((sym_cnt_ind!=0)&& (cp_ind==1))
           cp_mrkr <= 1;
    else 
	       cp_mrkr <= 0;
end


always_ff @(posedge clk) begin
    if (sym_mrkr_pre==1) 
           sym_mrkr_4x <= 1; 
    else if(sym_cnt==0)
	   begin
	    case(sym_mrkr_sample_cnt)     
//	        'd3618,
//			'd7238,
//			'd10857:
            sym_1st_4x_2,
            sym_1st_4x_3,
            sym_1st_4x_4:
	            sym_mrkr_4x <= 1;
	        default:
	            sym_mrkr_4x <= 0;
		endcase		
	   end		
	else 
	   begin
	    case(sym_mrkr_sample_cnt)     
//	        'd3565,
//			'd7133,
//			'd10700:
            sym_4x_2,
            sym_4x_3,
            sym_4x_4:
	            sym_mrkr_4x <= 1;
	        default:
	            sym_mrkr_4x <= 0;
		endcase		
	   end					
end	


always_ff @(posedge clk) begin
    if (sym_mrkr_pre==1) 
           sym_cnt_4x <= 0; 
    else if(sym_cnt==0)
	   begin
	    case(sym_mrkr_sample_cnt)     
            sym_1st_4x_2,
            sym_1st_4x_3,
            sym_1st_4x_4:
	            sym_cnt_4x <= sym_cnt_4x + 1;
	        default:
	            sym_cnt_4x <= sym_cnt_4x;
		endcase		
	   end		
	else 
	   begin
	    case(sym_mrkr_sample_cnt)     
            sym_4x_2,
            sym_4x_3,
            sym_4x_4:
	            sym_cnt_4x <= sym_cnt_4x + 1;
	        default:
	            sym_cnt_4x <= sym_cnt_4x;
		endcase		
	   end					
end	






/*
// symbol size symbol sizes include CP
always_ff @(posedge clk) begin
    
        symbol_size_first_real <= symbol_size_first_real_value;      // 491.52Mhz (71875.00/T) = 35328
        symbol_size_real <= symbol_size_real_value;                  // 491.52Mhz (71354.17/T) = 35072
        cp_size_first_real <= cp_size_first_real_value;              // 491.52Mhz (5208.33/T) - 1 = 2559
        cp_size_real <= cp_size_real_value;                          // 491.52Mhz (4687.50/T) - 1 - 2303     
end


// Create symbol marker real time
always_ff @(posedge clk) begin 
        if (count_0p5ms == 0) begin  // reset on slot marker
            start_symbol_real <= symbol_size_first_real;
            prev_start_symbol_real <= 0;
            sym_mrkr <= 1;
            sym_mrkr_sample_cnt <= 0;
            sym_cnt <= 0;
            cp_mrkr <= 1;
            end
        else if (count_0p5ms == start_symbol_real) begin
            start_symbol_real <= start_symbol_real + symbol_size_real;
            prev_start_symbol_real <= start_symbol_real - 1;
            sym_mrkr <= 1;
            sym_mrkr_sample_cnt <= 0;
            sym_cnt <= sym_cnt + 1;
            cp_mrkr <= 1;
            end
        else begin
            sym_mrkr <= 0;
            sym_mrkr_sample_cnt <= sym_mrkr_sample_cnt + 1;
            if ((count_0p5ms < symbol_size_first_real) && (sym_mrkr_sample_cnt < cp_size_first_real)) cp_mrkr <= 1;  // first symbol
            else if (sym_mrkr_sample_cnt < cp_size_real) cp_mrkr <= 1;
            else cp_mrkr <= 0;
            end  
end

// Create 4x symbol marker 
always_ff @(posedge clk) begin  
    if ((count_0p5ms == 0) || (count_0p5ms == start_symbol_real)) sym_mrkr_4x <= 1;                     // First marker
    else if (count_0p5ms < symbol_size_first_real) begin
        if ((count_0p5ms - prev_start_symbol_real) == (symbol_size_first_real >> 2)) sym_mrkr_4x <= 1;      // 1/4 of the symbol size
        else if ((count_0p5ms - prev_start_symbol_real) == (symbol_size_first_real >> 1)) sym_mrkr_4x <= 1;      // 1/2 of the symbol size
        else if ((count_0p5ms - prev_start_symbol_real) == ((symbol_size_first_real >> 2) + (symbol_size_first_real >> 1))) sym_mrkr_4x <= 1;  // 3/4 of the symbol size
        else sym_mrkr_4x <= 0;
        end
    else if ((count_0p5ms - prev_start_symbol_real) == (symbol_size_real >> 2)) sym_mrkr_4x <= 1;      // 1/4 of the symbol size
    else if ((count_0p5ms - prev_start_symbol_real) == (symbol_size_real >> 1)) sym_mrkr_4x <= 1;      // 1/2 of the symbol size
    else if ((count_0p5ms - prev_start_symbol_real) == ((symbol_size_real >> 2) + (symbol_size_real >> 1))) sym_mrkr_4x <= 1;  // 3/4 of the symbol size
    else sym_mrkr_4x <= 0;
end

// Create pre sym marker
always_ff @(posedge clk) begin 
    if (frm_mrkr) begin 
        if (count_0p5ms == count_0p5ms_max) begin  // reset on slot marker
            sym_mrkr_pre <= 1;       
            end
        else if (count_0p5ms == (start_symbol_real - 1)) begin
            sym_mrkr_pre <= 1;
            end
        else begin
            sym_mrkr_pre <= 0;
            end
    end
    else begin
        sym_mrkr_pre <= 0;
    end
end
*/
endmodule
