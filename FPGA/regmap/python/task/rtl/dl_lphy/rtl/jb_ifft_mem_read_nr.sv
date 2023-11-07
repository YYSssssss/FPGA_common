`timescale 1ns / 1ps

module jb_ifft_mem_read_nr 
 (
    input                        clk,                   // i clock  
    input                        clk_en,                // i clock enable           
    input                        reset,                 // i reset
     
    input                        ch_bw_update_done,     // i 
    input [3:0]                  ch_bw,                 // i
    input                        car_en,                // i
    input                        extended_cp,           // i
    input                        first_symbol,          // i
    input                        bank_0_ready_to_read,  // i
    input                        bank_1_ready_to_read,  // i
    output logic                 read_en,               // o  Aligns with output address
    output logic [14:0]          output_add,            // o add 1 bit for nr
    output logic                 dv_mem = 0,            // o  Aligns with data read from memory outside
    output logic                 cp_mrkr = 0,           // o  Aligns with data read from memory outside
    output logic [1:0]           antenna_out            // o  Aligns with data read from memory outside
    );

logic [15:0] cp_size;
logic [15:0] cp_size_first;
logic [15:0] cp_size_current = 0;
logic [15:0] max_size_current = 0;
logic [15:0] fft_size_current = 0;
logic [15:0] cp_start_current = 0;
logic slot_marker;
logic [15:0] max_size_first = 0;
logic [15:0] max_size       = 0;
logic [15:0] count_add_sym = 0;
logic [15:0] count_add_cp = 0;
logic [15:0] count_add_fft = 0;
logic bank_0_ready_to_read_d = 0;
logic bank_1_ready_to_read_d = 0;
logic first_symbol_d = 0;
logic bank;
logic cp_time;
logic cp_time_d = 0;
logic cp_time_2d = 0;
logic [1:0] antenna = 0;
logic [1:0] antenna_d = 0;
logic [1:0] antenna_2d = 0;
logic [1:0] antenna_3d = 0;
logic [15:0] count_cp;
logic [15:0] count_fft;
logic [15:0] read_address = 0;
logic read_enable = 0;
logic read_enable_d = 0;
logic read_enable_2d = 0;
logic bank_change_0;
logic bank_change_1;


// Setup
// symbol size
always_ff @(posedge clk) begin
    if (clk_en) begin
        if (extended_cp) begin
            case (ch_bw) 
                4'b0000 : begin 
                            max_size_first <= 16'd10239;
                            max_size <= 16'd10239; //20MHz
                            cp_size_first <= 16'd2047;
                            cp_size <= 16'd2047;
                          end 
                4'b0001 : begin
                            max_size_first <= 16'd5119;
                            max_size <= 16'd5119;  //10Mhz
                            cp_size_first <= 16'd1023;
                            cp_size <= 16'd1023;
                          end 
                4'b0010 : begin 
                            max_size_first <= 16'd2559;
                            max_size <= 16'd2559;  //5Mhz
                            cp_size_first <= 16'd511;
                            cp_size <= 16'd511;
                          end 
                4'b0011 : begin
                            max_size_first <= 16'd10239;
                            max_size <= 16'd10239; //15MHz
                            cp_size_first <= 16'd2047;
                            cp_size <= 16'd2047;
                          end 
                default : begin 
                            max_size_first <= 16'd10239;
                            max_size <= 16'd10239;
                            cp_size_first <= 16'd2047;
                            cp_size <= 16'd2047;
                          end
            endcase 
        end
        else begin
            case (ch_bw) 
                4'b0000 : begin 
                            max_size_first <= 16'd8831; //20MHz
                            max_size <= 16'd8767; 
                            cp_size_first <= 16'd639;
                            cp_size <= 16'd575;
                          end 
                4'b0001 : begin
                            max_size_first <= 16'd4415;  //10Mhz
                            max_size <= 16'd4383; 
                            cp_size_first <= 16'd319;
                            cp_size <= 16'd287;
                          end 
                4'b0010 : begin 
                            max_size_first <= 16'd2207;  //5Mhz
                            max_size <= 16'd2191; 
                            cp_size_first <= 16'd159;
                            cp_size <= 16'd143;
                          end 
                4'b0011 : begin 
                            max_size_first <= 16'd8831; //15MHz
                            max_size <= 16'd8767; 
                            cp_size_first <= 16'd639;
                            cp_size <= 16'd575;
                          end 
                //nr          
                4'b0100 : begin 
                            max_size_first <= 16'd17791; //100MHz
                            max_size <= 16'd17535; 
                            cp_size_first <= 16'd1407;
                            cp_size <= 16'd1151;
                          end                           
             
                default : begin 
                            max_size_first <= 16'd8831;
                            max_size <= 16'd8767; //20MHz
                            cp_size_first <= 16'd639;
                            cp_size <= 16'd575;
                          end
            endcase 
        end
    end
end   

// capture first symbol indicator when bank 0 is ready.  First symbol should always happen when bank is 0
always @(posedge clk) begin // always block to update state
    if (clk_en) begin
        bank_0_ready_to_read_d <= bank_0_ready_to_read;
        bank_1_ready_to_read_d <= bank_1_ready_to_read;
    end
end

assign bank_change_0 = bank_0_ready_to_read && ~bank_0_ready_to_read_d;
assign bank_change_1 = bank_1_ready_to_read && ~bank_1_ready_to_read_d;

always @(posedge clk) begin // Hold on to first_symbol marker
    if (clk_en) begin
        if (bank_change_0 || bank_change_1) first_symbol_d <= first_symbol;
    end
end

    
// state machine for control
logic [1:0] state, nextstate;
localparam state_idle      = 0;
localparam state_cp_read   = 1;
localparam state_data_read = 2;

always @(posedge clk) begin // always block to update state
    if (reset)
        state <= state_idle;
    else if (clk_en) begin
        state <= nextstate; 
        end
 end
 
 always @(*) // always block to compute both output & nextstate
    begin
     case(state)
     state_idle : begin  
         nextstate = state_idle;
         if (~car_en) nextstate = state_idle;       
        // else if ((first_symbol) && (bank_0_ready_to_read)) nextstate = state_cp_read;
         else if ((bank_0_ready_to_read) || (bank_1_ready_to_read)) nextstate = state_cp_read;
         else if (~car_en) nextstate = state_idle;
         end     
     state_cp_read: begin
         nextstate = state_cp_read;
         if (ch_bw_update_done || ~car_en) nextstate = state_idle;
         else if(count_add_sym == cp_size_current) nextstate = state_data_read;
         end
     state_data_read: begin
         nextstate = state_data_read;
         if (ch_bw_update_done || ~car_en) nextstate = state_idle;
//         else if(count_add_sym == max_size_current) nextstate = state_cp_read; 
         else if(bank_change_0 || bank_change_1) nextstate = state_cp_read;  // To stay insync with frame marker, only change when bank is ready.
         end
     default:
        nextstate = state_idle;
     endcase
    end

always @(posedge clk) begin // always block to update state
    if (clk_en) begin
        if (state == state_idle) begin
            cp_size_current <= cp_size_first;
            max_size_current <= max_size_first;
            fft_size_current <= max_size_first - cp_size_first - 1;
            cp_start_current <= (max_size_first >> 2) - (cp_size_first >> 1);
            count_add_sym <= 0;
            count_add_cp <= 0;
            count_add_fft <= 0;
            antenna <= 0;
            read_enable <= 0;
        end
        else if (state == state_cp_read) begin
            if (first_symbol_d) begin
                cp_size_current <= cp_size_first;  // set current cp_size
                max_size_current <= max_size_first; // set current size
                fft_size_current <= max_size_first - cp_size_first - 1;
                cp_start_current <= (max_size_first >> 2) - (cp_size_first >> 1);
            end
            else begin
                cp_size_current <= cp_size;
                max_size_current <= max_size;
                fft_size_current <= max_size - cp_size - 1;
                cp_start_current <= (max_size >> 2) - (cp_size >> 1);
            end            
            
            if (bank_change_0 || bank_change_1) begin
                antenna <= 0;
                count_add_sym <= 0;
                count_add_cp <= 0;
                end 
            else begin
                antenna <= antenna + 1;
                count_add_sym <= count_add_sym + 1;
                count_add_cp <= count_add_cp + 1;
            end             
            
            read_enable <= 1;
        end
        else if (state == state_data_read) begin
            if (bank_change_0 || bank_change_1) begin
                antenna <= 0;
                count_add_sym <= 0;
                count_add_cp <= 0;
                count_add_fft <= 0;
                end 
            else begin
                antenna <= antenna + 1;
                count_add_sym <= count_add_sym + 1; 
                count_add_fft <= count_add_fft + 1;               
            end             
        
            read_enable <= 1;
        end
    end
end

/*assign bank = bank_1_ready_to_read_d;
assign cp_time = (state == state_cp_read);
assign count_cp = count_add_cp >> 2;  
assign count_fft = count_add_fft >> 2;*/
always @(posedge clk) begin 
    if (clk_en) begin
         bank <= bank_1_ready_to_read_d;
         cp_time <= (state == state_cp_read);
         count_cp <= count_add_cp >> 2;  
         count_fft <= count_add_fft >> 2;
    end
end

// CP is at counter for cp + cp_start location + allocation start (set to 2048 sizes) + bank location (another 2048)
// It's possible to pipeline this if it can't meet timing.  delay cp_time, antenna and bank.  Then do register for each calculation below. 
// Assign those calculations to read_address.
always @(posedge clk) begin // always block to update state
    if (clk_en) begin
        if (cp_time) begin
            if (bank == 0) begin
                case(antenna_d)
                    'd0 :     read_address <= count_cp + cp_start_current + 'd0;
                    'd1 :     read_address <= count_cp + cp_start_current + 'd8192;
                    'd2 :     read_address <= count_cp + cp_start_current + 'd16384;
                    'd3 :     read_address <= count_cp + cp_start_current + 'd24576;
                    default : read_address <= count_cp + cp_start_current + 'd0;
                endcase
            end
            else begin  // bank 1
                case(antenna_d)
                    'd0 :     read_address <= count_cp + cp_start_current + 'd0       + 'd4096;
                    'd1 :     read_address <= count_cp + cp_start_current + 'd8192    + 'd4096;
                    'd2 :     read_address <= count_cp + cp_start_current + 'd16384   + 'd4096;
                    'd3 :     read_address <= count_cp + cp_start_current + 'd24576   + 'd4096;
                    default : read_address <= count_cp + cp_start_current + 'd0       + 'd4096;
                endcase
            end
        end
     else begin  // data time
            if (bank == 0) begin
                case(antenna_d)
                    'd0 :     read_address <= count_fft + 'd0    ;
                    'd1 :     read_address <= count_fft + 'd8192 ;
                    'd2 :     read_address <= count_fft + 'd16384;
                    'd3 :     read_address <= count_fft + 'd24576;
                    default : read_address <= count_fft + 'd0    ;
                endcase
            end
            else begin  // bank 1
            case(antenna_d)
                    'd0 :     read_address <= count_fft + 'd0       + 'd4096;
                    'd1 :     read_address <= count_fft + 'd8192    + 'd4096;
                    'd2 :     read_address <= count_fft + 'd16384   + 'd4096;
                    'd3 :     read_address <= count_fft + 'd24576   + 'd4096;
                    default : read_address <= count_fft + 'd0       + 'd4096;
                endcase
            end
        end
     end
end

// delay read_en to become data valid from memory
// delay antenna to become align with data.
// Memory currently has 2 clock delay reads
always @(posedge clk) begin 
    if (clk_en) begin
        cp_time_d <= cp_time;
        cp_time_2d <= cp_time_d;
        cp_mrkr_d <= cp_time_2d;
        read_enable_d <= read_enable;
        read_enable_2d <= read_enable_d;
        dv_mem_d <= read_enable_2d;
        antenna_d <= antenna;
        antenna_2d <= antenna_d;
        antenna_3d <= antenna_2d;
        antenna_4d <= antenna_3d;
    end
end

assign read_en = read_enable;

//tyh change for timming
 logic [14:0]          output_add_d; 
 logic                 dv_mem_d; 
 logic                 dv_mem_2d; 
 logic                 cp_mrkr_d;
 logic                 cp_mrkr_2d;
 logic [1:0]           antenna_4d; 
 logic [1:0]           antenna_5d; 

always @(posedge clk) begin
         output_add_d <= read_address[14:0];
		 output_add <= output_add_d;
		 
		 dv_mem_2d <= dv_mem_d;
		 dv_mem    <= dv_mem_2d;
		 
		 cp_mrkr_2d <= cp_mrkr_d;
		 cp_mrkr <= cp_mrkr_2d;
		 
		 antenna_5d <= antenna_4d;
		 antenna_out <= antenna_5d;		 
end

endmodule
