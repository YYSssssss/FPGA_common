
`timescale 1ns / 1ps

module jb_prach_fft_zero_data_removal # (
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16
)
 (
    input                 clk,               // i clock  
    input                 clk_en,            // i clock enable           
    input                 reset,             // i reset
 //   input                 ch_bw_update_done, // i 
    input [PRECISION-1:0] input_I, 
    input [PRECISION-1:0] input_Q,  
    input [9:0]          address,           // i Address associated with FFT output
    input                 dv,                // i 
  //  input  [4:0]          nfft_size,         // i
  //  input  [15:0]         nscs,              // i
    
    output logic [PRECISION-1:0] output_I = 0, // o
    output logic [PRECISION-1:0] output_Q = 0, // o
    output logic [9:0]          address_out,  // o  
    output logic [USR_ID_BW-1:0] antenna_out = 0, // o
    output logic                 tvalid = 0,      // o
    output logic                 tlast = 0,       // o
    output logic                 tfirst = 0          // o
    );
     

// Adding 3 clock input offset to allow for timing and CP insertion for ifft
logic [PRECISION-1:0] input_I_d = 0; 
logic [PRECISION-1:0] input_Q_d = 0; 
logic [9:0] space_upper = 'd592;
logic [9:0] space_lower= 'd432;
logic [10:0] calculation_1 = 'd1024; 
logic dont_write = 0;
logic [1:0] antenna = 0;
logic dv_d;
logic first = 0;
logic last = 0;
logic [9:0] address_d = 0;
logic [4:0] nfft_size = 5'd10;
logic [15:0] nscs = 864; //for prach

//    always @(posedge clk) begin
//        if (clk_en) begin
//            calculation_1 <= (2**nfft_size);
//            space_lower <= {1'b0, nscs[15:1]}; // take Half of the spacing.
//            space_upper <= calculation_1 - {1'b0, nscs[15:1]};
//        end
//    end 

   
    always @(posedge clk) begin
        if (clk_en) begin
            dv_d <= dv;
            input_I_d   <= input_I;
            input_Q_d   <= input_Q;   
            output_I    <= input_I_d;
            output_Q    <= input_Q_d;
            address_d   <= address; 
            address_out <= address_d; 
  //          address_out <= address; 
            tvalid      <= valid;  
            antenna_out <= antenna; 
            tlast       <= last;
        end
    end
 
// space_upper and lower set many clocks before by bw_update code 
    always @(posedge clk) begin
        if (clk_en) begin    
            if  ((address >= space_lower) && (address < space_upper)) begin
                dont_write <= 1;
            end
            else begin
                dont_write <= 0;
            end
        end
    end
     
  assign valid = dv_d && ~dont_write;
//assign valid = dv_d;

    always @(posedge clk) begin
    //    if (reset || ch_bw_update_done)  antenna <= 'd3;  // Start at 3 after bw update or reset.  First DV will make it a zero
         if (reset)  antenna <= 'd3;  // Start at 3 after bw update or reset.  First DV will make it a zero
        else if (clk_en) begin
            if (dv && ~dv_d) antenna <= antenna + 1;
        end
    end
    
    always @(posedge clk) begin
        if (clk_en) begin
            if (dv && ((calculation_1 - 1) == address)) last <= 1;
            else last <= 0;
            
            if (dv && ('d0 == address)) first <= 1;
            else first <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (clk_en) begin
            tfirst <= first && (antenna == 'd0);
        end
    end

endmodule
