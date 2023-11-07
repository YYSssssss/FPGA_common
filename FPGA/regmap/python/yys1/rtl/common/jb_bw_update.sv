`timescale 1ns / 1ps

module jb_bw_update # (
    parameter FFT_IFFT = 1
)
 (
    input        clk,                     // i clock  
    input        clk_en,                  // i clock enable           
    input        reset,                   // i reset
    input        car_en,                  // i carrier enable
    input        ch_bw_update_req,        // i
    
    output logic ch_bw_update_done = 0,   // o 
    input  [3:0] ch_bw,                   // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz
    output logic [4:0] nfft_size = 0,
    output logic [15:0] nscs =  0,
    output logic [11:0] scale_sch = 0,
    output logic nfft_we = 0,             // 0 symbol count
    output logic ctrl_we = 0,
    output logic [3:0] current_ch_bw = 0
    );
    
logic car_en_d = 0;
     
// look for rising edge of carrier enable
always_ff @(posedge clk) begin // always block to update state
    if (reset) begin
        car_en_d <= 0;
        end
    else if (clk_en) begin
        car_en_d <= car_en;
    end
end

// create fft size of ch
always_ff @(posedge clk) begin
    if (clk_en) begin
        case (ch_bw) 
            4'b0000 : nfft_size <= 5'd11;
            4'b0001 : nfft_size <= 5'd10;
            4'b0010 : nfft_size <= 5'd9;
            4'b0011 : nfft_size <= 5'd11;
            default : nfft_size <= 5'd11;        
        endcase
    end
end

// set scs
always_ff @(posedge clk) begin
    if (clk_en) begin  
        case (ch_bw) 
            4'b0000 : nscs <= 1200;
            4'b0001 : nscs <= 600;
            4'b0010 : nscs <= 300;
            4'b0011 : nscs <= 900;
            default : nscs <= 1200;       
        endcase
    end
end

// set scaling factor
always_ff @(posedge clk) begin
    if (clk_en) begin
        if (FFT_IFFT) begin   // FFT
            //scale_sch <= ((ch_bw == 4'b0010) || (ch_bw == 4'b0011)) ? 12'b00_00_01_01_01_10 : 12'b00_01_01_01_01_10; //5Mhz and 15Mhz is different than the rest.  
            scale_sch <= ((ch_bw == 4'b0010)) ? 12'b00_00_01_01_01_10 : 12'b00_01_01_01_01_10; //5Mhz is different than the rest.     
        end
        else begin              // IFFT
          //  scale_sch <= (ch_bw == 4'b0011) ? 12'b00_00_01_01_01_10 : 12'b00_01_01_01_01_10;  //15Mhz is different than the rest.
            scale_sch <= 12'b00_01_01_01_01_10;  
        end
    end
end
     
// state machine for control
logic [1:0] state, nextstate;
logic ch_bw_update_req_d = 0;
localparam state_idle = 0;
localparam state_nfft_we = 1;
localparam state_ctrl_we = 2;
logic ch_bw_done = 0;

always @(posedge clk) begin // always block to update state
    if (clk_en) begin
        ch_bw_update_req_d <= ch_bw_update_req;
    end
 end

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
       // if ((ch_bw_update_req == 1) && (ch_bw_update_req_d == 0) || (car_en && ~car_en_d)) nextstate = state_nfft_we;
         if (car_en && ~car_en_d) nextstate = state_nfft_we;
         end     
     state_nfft_we: begin
         nextstate = state_ctrl_we;
         end
     state_ctrl_we: begin
         nextstate = state_idle; 
         end
     default:
        nextstate = state_idle;
     endcase
    end

always @(posedge clk) begin // always block to update state
    if (clk_en) begin
        if (state == state_nfft_we) begin
             nfft_we <= 1;
             ctrl_we <= 0;
             ch_bw_done <= 0;
             current_ch_bw <= current_ch_bw;
             end
        else if (state == state_ctrl_we) begin
             nfft_we <= 0;
             ctrl_we <= 1;
             ch_bw_done <= 1;
             current_ch_bw <= ch_bw;
            end
        else begin
             nfft_we <= 0;
             ctrl_we <= 0;
             ch_bw_done <= 0;
             current_ch_bw <= current_ch_bw;
            end
    end
end

always @(posedge clk) begin // delay done by 1 clock to make sure ctrl is done
    if (clk_en) begin
        ch_bw_update_done <= ch_bw_done; 
    end
end

 
endmodule
