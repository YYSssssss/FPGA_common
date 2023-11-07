`timescale 1ns / 1ps

module jb_prach_fft_mem_write # (
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16
)
 (
    input                        clk,                   // i clock  
    input                        clk_en,                // i clock enable           
    input                        reset,                 // i reset
     
  //  input                        ch_bw_update_done,     // i 
    input [3:0]                  format,                 // i
    input  [9:0]                prach_cp,
 //   input                        extended_cp,           // i
    input                        dv,                    // i
//    input                        frm_mrkr,              // i
//    input                        slot_mrkr,             // i
//    input                        sym_mrkr,              // i
    input                        sub_frame_mrkr,
//    input [2:0]                  sym_cnt,               // i 
    input [19:0]                 wait_time,
    jb_axi4_stream_if.slave      IFP_fft_in,            // i
 //   output logic [13:0]          output_add,            // o
    jb_axi4_stream_if.master     IFP_fft_out,           // o
    output logic                 cp_mrkr = 0,           // o  Aligns with data read from memory outside
 //   output logic                 bank_0_ready = 0,      // o
 //   output logic                 bank_1_ready = 0       // o
    output   logic                 fifo_wren
    );

logic [19:0] cp_size;
logic [19:0] cp_size_first;
logic [19:0] cp_size_current = 0;
logic [19:0] max_size_current = 0;
logic [19:0] fft_size_current = 0;
logic [19:0] cp_start_current = 0;
logic [19:0] max_size_first = 0;
logic [19:0] max_size       = 0;
logic [19:0] count_add_sym = 0;
logic [19:0] count_add_cp = 0;
logic [19:0] count_add_fft = 0;
logic bank = 0;
logic cp_time;
logic cp_time_d = 0;
logic [USR_ID_BW-1:0] antenna_d = 0;
logic [USR_ID_BW-1:0] antenna_2d = 0;
logic [USR_ID_BW-1:0] antenna_3d = 0;
logic [USR_ID_BW-1:0] antenna_4d = 0;
logic [15:0] count_cp;
logic [15:0] count_fft;
logic [15:0] write_address = 0;
logic write_enable = 0;
logic write_enable_d = 0;
logic write_enable_2d = 0;
logic write_enable_3d = 0;
logic write_enable_4d = 0;
logic first_symbol = 0;
logic bank_d = 0;
logic bank_2d = 0;
logic [2*PRECISION-1:0] data_d;
logic [2*PRECISION-1:0] data_2d;
logic [2*PRECISION-1:0] data_3d;
logic [2*PRECISION-1:0] data_4d;
logic [13:0] last_bank0 = 0;
logic [13:0] last_bank1 = 0;
logic  valid_d = 0;
logic  valid_2d = 0;
logic  valid_3d = 0;
logic  valid_4d = 0;
logic first_symbol_pulse = 0;
logic [19:0] prach_cp_cnt;

assign prach_cp_cnt = {prach_cp[9:0],5'd0} + {prach_cp[9:0],6'd0}; //{x[*:5],5'd0} + {x[*:6],6'd0}
// Setup
// symbol size
always_ff @(posedge clk) begin
    if (clk_en) begin
        
            case (format)                                              // 9260 is filter delay of 9260CLKS based on count_add_cp
                4'b0000 : begin 
                         //   max_size_first <= 20'd110976 + wait_time;    // + 20'd9260;  //1024 samples at 122.88 is 98304 + cp_size 12672 =110976, at  491.52 = 20'd393216
                           max_size_first <= prach_cp_cnt + 20'd98304;
                        //    max_size <= 20'd110976 + wait_time;         // + 20'd9260; 
                           max_size <= prach_cp_cnt + 20'd98304;; 
                         //   cp_size_first <= 20'd12672 + wait_time;     // + 20'd9260;  // 12672 is 132 samples at 122.88,  at  491.52=20'd50688
                           cp_size_first <= prach_cp_cnt;
                       //     cp_size <= 20'd12672 + wait_time;           // + 20'd9260;
                           cp_size <= prach_cp_cnt;
                          end 
                4'b0001 : begin
                             max_size_first <= 20'd110976 + wait_time;
                            max_size <= 20'd110976 + wait_time;  
                            cp_size_first <= 20'd12672 + wait_time;
                            cp_size <= 20'd12672 + wait_time; 
                          end 
                4'b0010 : begin 
                             max_size_first <= 20'd110976 + wait_time;
                            max_size <= 20'd110976 + wait_time;   
                            cp_size_first <= 20'd12672 + wait_time;
                            cp_size <= 20'd12672 + wait_time; 
                          end 
                4'b0011 : begin
                             max_size_first <= 20'd110976 + wait_time;
                            max_size <= 20'd110976 + wait_time;  
                            cp_size_first <= 20'd12672 + wait_time;
                            cp_size <= 20'd12672 + wait_time; 
                          end 
                4'b0100 : begin
                             max_size_first <= 20'd110976 + wait_time;
                            max_size <= 20'd110976 + wait_time;  
                            cp_size_first <= 20'd12672 + wait_time;
                            cp_size <= 20'd12672 + wait_time; 
                          end           
                default : begin 
                            max_size_first <= 20'd110976 + wait_time;;
                            max_size <= 20'd110976 + wait_time; ;
                            cp_size_first <= 20'd12672 + wait_time;
                            cp_size <= 20'd12672 + wait_time; 
                          end
            endcase 
     end
        
        
end   

//always_ff @(posedge clk) begin
//    if (clk_en) begin
//        if (frm_mrkr && dv) bank <= 'b0;
//        else if (sym_mrkr && dv) bank <= ~bank;
//    end
//end

// logic [2:0] sub_frm_marker_d;
//logic sub_frm_marker_extended;
//logic release_input_d;
     
//always_ff @(posedge clk) begin  // Use internal signal to align DFE input.  moved to jb_prach_fft_top
//    sub_frm_marker_d[0] <= sub_frame_mrkr;
//    sub_frm_marker_d[1] <= sub_frm_marker_d[0];
//    sub_frm_marker_d[2] <= sub_frm_marker_d[1];
//end

//assign sub_frm_marker_extended = |sub_frm_marker_d  || sub_frame_mrkr;   


//always_ff @(posedge clk) begin
//    if (clk_en) begin
//        if(sub_frame_mrkr && dv) first_symbol <= 1;
//        else if (sub_frame_mrkr && sym_cnt == 'd1) first_symbol <= 0;
//    end
//end

always_ff @(posedge clk) begin
    if (clk_en) begin
        if(sub_frame_mrkr) first_symbol <= 1;
        else if (first_symbol && dv == 'd1) first_symbol <= 0;
    end
end

always_ff @(posedge clk) begin
    if (clk_en) begin
      //  if(sub_frame_mrkr && dv) first_symbol_pulse <= 1;
       if(first_symbol && dv) first_symbol_pulse <= 1;
        else first_symbol_pulse <= 0;
    end
end
    
// state machine for control
logic [1:0] state, nextstate;
localparam state_idle      = 0;
localparam state_cp_ignore   = 1;
localparam state_data_write = 2;

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
         if ((first_symbol)) nextstate = state_cp_ignore;
         end     
     state_cp_ignore: begin
         nextstate = state_cp_ignore;
         if(count_add_sym == cp_size_current) nextstate = state_data_write;
 //        else if (ch_bw_update_done) nextstate = state_idle;
           else if (first_symbol_pulse) nextstate = state_cp_ignore;
         end
     state_data_write: begin
         nextstate = state_data_write;
         if(count_add_sym == max_size_current) nextstate = state_idle; 
 //        else if (ch_bw_update_done) nextstate = state_idle;
           else if (first_symbol_pulse) nextstate = state_cp_ignore;
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
            write_enable <= 0;
        end
        else if (state == state_cp_ignore) begin
            if (first_symbol) begin
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
            
            count_add_sym <= count_add_sym + 1;
            if (count_add_cp == cp_size_current) count_add_cp <= 0; else count_add_cp <= count_add_cp + 1;
            write_enable <= 0;
        end
        else if (state == state_data_write) begin
            if(count_add_sym == max_size_current) count_add_sym <= 0; else count_add_sym <= count_add_sym + 1;
            if(count_add_fft == fft_size_current) count_add_fft <= 0; else count_add_fft <= count_add_fft + 1;
              write_enable <= 1;  

        end
    end
end


always @(posedge clk) begin 
    if (clk_en) begin
         cp_time <= (state == state_cp_ignore);
         count_cp <= count_add_cp >> 2;  
         count_fft <= count_add_fft >> 2;
    end
end

// CP is at counter for cp + cp_start location + allocation start (set to 2048 sizes) + bank location (another 2048)
// It's possible to pipeline this if it can't meet timing.  delay cp_time, antenna and bank.  Then do register for each calculation below. 
// Assign those calculations to write_address.
//always @(posedge clk) begin // always block to update state
//    if (clk_en) begin
//        if (~cp_time) begin  // data time         
//            if (bank_2d == 0) begin
//                case(antenna_3d)
//                    'd0 :     write_address <= count_fft + 'd0;
//                    'd1 :     write_address <= count_fft + 'd4096;
//                    'd2 :     write_address <= count_fft + 'd8192;
//                    'd3 :     write_address <= count_fft + 'd12288;
//                    default : write_address <= count_fft + 'd0;
//                endcase
//            end
//            else begin  // bank 1
//            case(antenna_3d)
//                    'd0 :     write_address <= count_fft + 'd0      + 'd2048;
//                    'd1 :     write_address <= count_fft + 'd4096   + 'd2048;
//                    'd2 :     write_address <= count_fft + 'd8192   + 'd2048;
//                    'd3 :     write_address <= count_fft + 'd12288  + 'd2048;
//                    default : write_address <= count_fft + 'd0      + 'd2048;
//                endcase
//            end
//        end
//     end
//end

always @(posedge clk) begin 
    if (clk_en) begin
//        bank_d <= bank;
//        bank_2d <= bank_d;
        cp_mrkr <= cp_time;
//        antenna_d <= IFP_fft_in.tuser;
//        antenna_2d <= antenna_d;
//        antenna_3d <= antenna_2d;
//        antenna_4d <= antenna_3d;
//        data_d <= IFP_fft_in.tdata;
//        data_2d <= data_d;
//        data_3d <= data_2d;  
//        data_4d <= data_3d;
//        valid_d <= IFP_fft_in.tvalid;
//        valid_2d <= valid_d;
//        valid_3d <= valid_2d;  
//        valid_4d <= valid_3d;
//        write_enable_d <= write_enable;
//        write_enable_2d <= write_enable_d;
//        write_enable_3d <= write_enable_2d;  
//        write_enable_4d <= write_enable_3d;
    end
end


//assign output_add = write_address[13:0];
assign IFP_fft_out.tuser =  IFP_fft_in.tuser; //antenna_2d;
//assign IFP_fft_out.tvalid = write_enable_d;
assign IFP_fft_out.tvalid = IFP_fft_in.tvalid; //valid_2d;
assign IFP_fft_out.tdata =  IFP_fft_in.tdata; //data_2d;
assign fifo_wren = write_enable;

// ready to read when the last antenna last location is written
// Take location above and add FFT size -1 to get last location
// remove one more location to align with sym_mrk_4x  This will compencate for the dealy
always_ff @(posedge clk) begin
    if (clk_en) begin
        case (format) 
            3'b000 : begin
                      last_bank0 <= 'd14334;   // 20Mhz Delay based on IFFT/FFT core is 2195
                      last_bank1 <= 'd16382;
                      end
            3'b001 : begin
                      last_bank0 <= 'd13311;   // 10Mhz Delay based on IFFT/FFT core is 1100 TBD
                      last_bank1 <= 'd15359;
                      end
            3'b010 : begin 
                      last_bank0 <= 'd12798;   //  5Mhz Delay based on IFFT/FFT core is 550 TBD
                      last_bank1 <= 'd14846;
                      end
            3'b011 : begin
                      last_bank0 <= 'd14334;  // 20Mhz Delay based on IFFT/FFT core is 2195
                      last_bank1 <= 'd16382;
                      end
             3'b100 : begin
                      last_bank0 <= 'd14334;  // 20Mhz Delay based on IFFT/FFT core is 2195
                      last_bank1 <= 'd16382;
                      end
            default : begin
                      last_bank0 <= 'd14334;
                      last_bank1 <= 'd16382;
                      end        
        endcase
    end
end
//// assign fifo_wr_en  = clk_x2_en & IFP_s_axis.tvalid;

//always_ff @(posedge clk) begin
//    if (clk_en) begin
//        if (write_enable_d && write_address == last_bank0) begin 
//            bank_0_ready <= 1;
//            bank_1_ready <= 0;
//        end
//        else if (write_enable_d && write_address == last_bank1) begin
//            bank_0_ready <= 0;
//            bank_1_ready <= 1;
//        end
//    end
//end

endmodule