`timescale 1ns / 1ps

module jb_prach_fft_mem_read #(
 parameter PRECISION = 16,
 parameter num_channels = 4
 )
 (
    input                           clk,                   // i clock  
    input                           clk_en,                // i clock enable           
    input                           reset,                 // i reset
    input [3:0]                     ch_bw,                 // i
    input		                    rfd,                   // i
    input                           sym_mrkr_4x,           // i
    input [2:0]                     sym_cnt_4x,            // i
    input     [2*PRECISION-1:0]     fifo_dout_data [num_channels-1:0],
    input     [num_channels-1:0]    fifo_full,
    input     [num_channels-1:0]    fifo_empty,
    output logic [num_channels-1:0] read_en,               // o  Aligns with output address
    output logic [13:0]             output_add,            // o
    output logic                    dv_mem = 0,            // o  Aligns with data read from memory outside
    output logic                    start_fft              // Hold FFT from starting until first bank 0 is ready
    );

logic bank = 1;
logic [2:0] sym_cnt_4x_d = 0;
logic [15:0] count_index = 0;
logic [15:0] count_index_d = 0;
logic [13:0] addr_incr = 0;
logic first = 0; 
logic dv = 0;
logic dv_d = 0;
logic bank_0_ready_to_read_d = 0;
logic start_int = 0;

logic bank_0_ready_to_read =1;
logic bank_1_ready_to_read =1;


always_ff @(posedge clk) begin
    if (clk_en) begin
	   sym_cnt_4x_d <=  sym_cnt_4x;
	   if(sym_cnt_4x && bank_0_ready_to_read) start_int <= 1;
    end
end

always_ff @(posedge clk) begin
    if (clk_en) begin
        if (bank_0_ready_to_read) bank <= 'b0;
        else if (bank_1_ready_to_read) bank <= 'b1;
    end
end

always_ff @(posedge clk) begin
    if (clk_en) begin
        if (bank_0_ready_to_read) first <= 'b1;
    end
end

// Count based on RFD.  Will change based on the FFT set in core
always @(posedge clk) begin
        if (clk_en) begin
            if (rfd) begin
               count_index <= count_index + 1; 
            end
            else begin
               count_index <= 0;
            end
       end
    end 
    
//always_ff @(posedge clk) begin  //as
//    if (clk_en) begin
//	   sym_cnt_4x_d <=  sym_cnt_4x;
//	   count_index_d <= count_index;
//    end
//end

// Calculate start of each memory location based on bank and sym/antenna
/*always_ff @(posedge clk) begin
    if (clk_en) begin
        case({bank, sym_cnt_4x_d})
            4'b0000 : addr_incr <= 'd0;
            4'b1000 : addr_incr <= 'd2048;
            4'b0001 : addr_incr <= 'd4096;
            4'b1001 : addr_incr <= 'd6144;
            4'b0010 : addr_incr <= 'd8192;
            4'b1010 : addr_incr <= 'd10240;
            4'b0011 : addr_incr <= 'd12288;
            4'b1011 : addr_incr <= 'd14336; 
            default : addr_incr <= 'd0;
        endcase                
    end
end*/

// Need to have address 1 clocks after RFD 
// FFT needs data 3 clocks after RFD
// Memory has 2 clock delays read
always @(*) begin
        case({bank, sym_cnt_4x_d})
            4'b0000 : addr_incr = 'd0;
            4'b1000 : addr_incr = 'd2048;
            4'b0001 : addr_incr = 'd4096;
            4'b1001 : addr_incr = 'd6144;
            4'b0010 : addr_incr = 'd8192;
            4'b1010 : addr_incr = 'd10240;
            4'b0011 : addr_incr = 'd12288;
            4'b1011 : addr_incr = 'd14336; 
            default : addr_incr = 'd0;
        endcase                
end

always_ff @(posedge clk) begin
    if (clk_en && rfd) begin
	   output_add <=  count_index + addr_incr;
    end
end

always_ff @(posedge clk) begin
    if (clk_en) begin
       read_en <= first & rfd;
	   dv <=  first & rfd;
	   dv_d <= dv;
	   dv_mem <= dv_d;
    end
end

assign start_fft = bank_0_ready_to_read || start_int; // used to hold off start of FFT  This way dv is accurate  

endmodule
