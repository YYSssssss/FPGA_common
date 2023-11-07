
`timescale 1ns / 1ps

module jb_fft_zero_data_removal_nr # (
    parameter USR_ID_BW = 2,
    parameter PRECISION = 16
)
 (
    input                 clk,               // i clock  
    input                 clk_en,            // i clock enable           
    input                 reset,             // i reset
    input                 ch_bw_update_done, // i 
    input                 frm_mrkr,          // i
    input                 subfrm_mrkr,       // i
    input                 slot_mrkr,         // i
    input                 sym_mrkr,          // i
    input [PRECISION-1:0] input_I, 
    input [PRECISION-1:0] input_Q,  
    input [11:0]          address,           // i Address associated with FFT output
    input                 dv,                // i 
	input                 fft_done,
//    input  [4:0]          nfft_size,         // i
//    input  [15:0]         nscs,              // i
    input                 test_mode ,
    
    output logic [PRECISION-1:0] output_I = 0,    // o
    output logic [PRECISION-1:0] output_Q = 0,    // o
    output logic [11:0]          address_out,     // o  
    output logic [USR_ID_BW-1:0] antenna_out = 0, // o
    output logic                 tvalid = 0,      // o
    output logic                 tlast = 0,       // o
    output logic                 tfirst = 0,      // o
    output logic frm_mrkr_out = 0,         // o
    output logic subfrm_mrkr_out = 0,      // o
    output logic slot_mrkr_out = 0,        // o
	output logic sym_mrkr_out
    );

localparam calculation_1 = 4096 ;
localparam space_lower = 1638 ;
localparam space_upper = 2458 ;

// Adding 3 clock input offset to allow for timing and CP insertion for ifft
logic [PRECISION-1:0] input_I_d = 0; 
logic [PRECISION-1:0] input_Q_d = 0; 

logic [PRECISION-1:0] input_I_2d = 0; 
logic [PRECISION-1:0] input_Q_2d = 0; 
 
logic dont_write = 0;
logic [1:0] antenna = 0;
logic [1:0] antenna_d = 0;

logic dv_d;
logic fft_done_1d;
logic valid;
logic first = 0;
logic first_d = 0;
logic last = 0;
logic last_d = 0;
logic [11:0] address_d = 0;
logic [11:0] address_2d = 0;

logic frm_mrkr_d = 0;         
logic subfrm_mrkr_d = 0;      
logic slot_mrkr_d = 0;   
logic sym_mrkr_d = 0;

logic frm_mrkr_2d = 0;         
logic subfrm_mrkr_2d = 0;      
logic slot_mrkr_2d = 0;       
logic sym_mrkr_2d = 0;

logic [PRECISION-1:0] output_I_d = 0;    // o
logic [PRECISION-1:0] output_Q_d = 0;    // o
logic [11:0]          address_out_d;     // o  
logic [USR_ID_BW-1:0] antenna_out_d = 0; // o
logic                 tvalid_d = 0;      // o
logic                 tlast_d = 0;       // o
logic                 tfirst_d = 0;      // o
logic frm_mrkr_out_d = 0;         // o
logic subfrm_mrkr_out_d = 0;      // o
logic slot_mrkr_out_d = 0;        // o
logic sym_mrkr_out_d ;

logic [PRECISION-1:0]  test_data_i = 0 ;
logic [PRECISION-1:0]  test_data_q = 0  ;

    // always @(posedge clk) begin
        // if (clk_en) begin
            // calculation_1 <= (2**nfft_size);
            // space_lower <= {1'b0, nscs[15:1]}; // take Half of the spacing.
            // space_upper <= calculation_1 - {1'b0, nscs[15:1]};
        // end
    // end 
   
    always @(posedge clk) begin
        if (clk_en) begin
            dv_d <= dv;
            input_I_d   <= input_I;
            input_Q_d   <= input_Q;   
			input_I_2d  <= input_I_d;
			input_Q_2d  <= input_Q_d; 
            output_I_d    <= input_I_2d;
            output_Q_d   <= input_Q_2d;
			
            address_d   <= address; 
			address_2d  <= address_d; 
            address_out_d <= address_2d;  
			
            tvalid_d      <= valid;  
			antenna_d   <= antenna;
            antenna_out_d <= antenna_d; 
            last_d       <= last;
			tlast_d        <= last_d;
			tfirst_d       <= first_d ;
            
			frm_mrkr_d     <= frm_mrkr;
            subfrm_mrkr_d  <= subfrm_mrkr;
            slot_mrkr_d    <= slot_mrkr;
			sym_mrkr_d     <= sym_mrkr ;
							  
			frm_mrkr_2d    <= frm_mrkr_d    ;
			subfrm_mrkr_2d <= subfrm_mrkr_d ;
			slot_mrkr_2d   <= slot_mrkr_d   ;
			sym_mrkr_2d     <= sym_mrkr_d   ;
			
            frm_mrkr_out_d  <= frm_mrkr_2d;
            subfrm_mrkr_out_d <= subfrm_mrkr_2d;
            slot_mrkr_out_d <= slot_mrkr_2d;
			sym_mrkr_out_d <=  sym_mrkr_2d;
			
			fft_done_1d <= fft_done;
			
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
     
//assign valid = dv_d && ~dont_write;

always @(posedge clk) begin
        if (clk_en)   
                valid <= dv_d && ~dont_write ;
        else
		        valid <= 0 ;
end


    always @(posedge clk) begin
        if (reset || ch_bw_update_done)  antenna <= 'd3;  // Start at 3 after bw update or reset.  First DV will make it a zero
        else if (clk_en) begin
            if (sym_mrkr) antenna <= 0;
            else if (dv && ~dv_d) antenna <= antenna + 1;
        end
    end
    
    always @(posedge clk) begin
        if (clk_en) begin
            if (dv && (address == (calculation_1 - 1))) last <= 1;
            else last <= 0;
            
            if (dv && (address == 'd0)) first <= 1;
            else first <= 0;
        end
    end
    
    always @(posedge clk) begin
        if (clk_en) begin
            first_d <= first && (antenna == 'd0);
        end
    end


    always @(posedge clk) begin
           test_data_i <= address_2d ;
    end
	
	always @(posedge clk) begin
        if(fft_done_1d==1'b1)
           test_data_q <= test_data_q + 16'd1 ;
        else
		   test_data_q <= test_data_q ;
	end	 


    always @(posedge clk) begin
        if(test_mode==1'b1)
		 begin
           output_I <= test_data_i ;
           output_Q <= test_data_q ;
		 end
		else 
  		 begin
           output_I <= output_I_d ;
           output_Q <= output_Q_d ;
		 end	   
	end
	
	always @(posedge clk) begin
	      address_out         <=  address_out_d      ;
          antenna_out         <=  antenna_out_d      ;
          tvalid              <=  tvalid_d           ;
          tlast               <=  tlast_d            ;
          tfirst              <=  tfirst_d           ;
          frm_mrkr_out        <=  frm_mrkr_out_d     ;
          subfrm_mrkr_out     <=  subfrm_mrkr_out_d  ;
          slot_mrkr_out       <=  slot_mrkr_out_d    ;
	      sym_mrkr_out        <=  sym_mrkr_out_d     ;
	end
	
	
	

endmodule
