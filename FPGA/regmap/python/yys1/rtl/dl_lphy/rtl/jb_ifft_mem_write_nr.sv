`timescale 1ns / 1ps

module jb_ifft_mem_write_nr # (
    parameter PRECISION = 16
)
 (
    input                        clk,              // i clock  
    input                        clk_en,           // i clock enable           
    input                        reset,            // i reset
     
    input [3:0]                  ch_bw,            // i
    input                        car_en,           // i
    input                        dv,               // i
    input                        frm_mrkr,         // i
    input                        slot_mrkr,        // i
    input                        sym_mrkr,         // i
    input                        cp_mrkr,          // i
	input [3:0]                  sym_cnt,
    input [2:0]                  sym_cnt_4x,          // i 
    input [PRECISION-1:0]        input_I,          // i
    input [PRECISION-1:0]        input_Q,          // i
    input [11:0]                 input_add,        // i add 1 bit for nr
    output logic                 dv_out,           // o
    output logic [PRECISION-1:0] output_I,         // o 
    output logic [PRECISION-1:0] output_Q,         // o 
    output logic [14:0]          output_add,       // o add 1 bit for nr
    output logic                 first_symbol = 0, // o
    output logic bank_0_ready_to_read = 0,         // o
    output logic bank_1_ready_to_read = 0          // o

    );
    
logic bank = 0;
logic [PRECISION-1:0] input_I_d = 0;
logic [PRECISION-1:0] input_Q_d = 0;
logic [11:0] input_add_d = 0;
logic [PRECISION-1:0] input_I_2d = 0;
logic [PRECISION-1:0] input_Q_2d = 0;
logic [11:0] input_add_2d = 0;
logic dv_d = 0;
logic dv_2d = 0;
logic [2:0] sym_cnt_4x_d = 0;
logic [14:0] addr_incr = 0;
logic [14:0] last_bank0 = 0;
logic [14:0] last_bank1 = 0;

/*
always_ff @(posedge clk) begin
    if (clk_en) begin
        if (frm_mrkr && dv) bank <= 'b0;
        else if (sym_mrkr && dv && sym_cnt_4x == 'd0) bank <= ~bank;
    end
end
*/
//tyh change for timming
logic [PRECISION-1:0] input_I_3d ;
logic [PRECISION-1:0] input_Q_3d ;
logic [PRECISION-1:0] input_I_4d ;
logic [PRECISION-1:0] input_Q_4d ;
logic dv_3d ;
logic dv_4d ;

logic [14:0]   output_add_d;
logic [14:0]   output_add_2d;

logic          sym_mrkr_read ;
logic [3:0]    sym_cnt_read  ;


always_ff @(posedge clk) begin
        if (frm_mrkr) bank <= 'b0;
        else if (sym_mrkr) bank <= ~bank;
end


// Align with bank
always_ff @(posedge clk) begin
    if (clk_en) begin
        input_I_d <= input_I;
        input_Q_d <= input_Q;
        input_I_2d <= input_I_d;
        input_Q_2d <= input_Q_d;
		input_I_3d <= input_I_2d;
        input_Q_3d <= input_Q_2d;
		input_I_4d <= input_I_3d;
        input_Q_4d <= input_Q_3d;				
		
        dv_d <= dv;
        dv_2d <= dv_d;
		dv_3d <= dv_2d;
		dv_4d <= dv_3d;
		
        input_add_d <= input_add;
        input_add_2d <= input_add_d;
		
        sym_cnt_4x_d <= sym_cnt_4x;
    end
end

// Calculate start of each memory location based on bank and sym/antenna
always_ff @(posedge clk) begin
    if (clk_en) begin
        case({bank, sym_cnt_4x_d})
            4'b0000 : addr_incr <= 'd0;
            4'b1000 : addr_incr <= 'd4096;
            4'b0001 : addr_incr <= 'd8192;
            4'b1001 : addr_incr <= 'd12288;
            4'b0010 : addr_incr <= 'd16384;
            4'b1010 : addr_incr <= 'd20480;
            4'b0011 : addr_incr <= 'd24576;
            4'b1011 : addr_incr <= 'd28672; 
            default : addr_incr <= 'd0;
        endcase                
    end
end

// calculate address and align all outputs
always_ff @(posedge clk) begin
    if (clk_en) begin
        output_I   <= input_I_4d;
        output_Q   <= input_Q_4d;
        dv_out     <= dv_4d;
        output_add_d <= input_add_2d + addr_incr;
		output_add_2d <= output_add_d  ;
		output_add <= output_add_2d ;
    end
end


//tyh change for addcp
shreg
    #(
        .DATA_WIDTH(1  ),
        .DEPTH     (13605 + 2609 ) //               
    )
    u_delay_sym_mrkr_read
    (
        .clk (clk),
        .din (sym_mrkr),
        .dout(sym_mrkr_read)
    );     


shreg
    #(
        .DATA_WIDTH(4  ),
        .DEPTH     (13605 + 2609  ) //               
    )
    u_delay_sym_cnt_read
    (
        .clk (clk),
        .din (sym_cnt),
        .dout(sym_cnt_read)
    ); 

always_ff @(posedge clk) begin
    if (clk_en) begin
        if (~car_en) begin  //reset
            bank_0_ready_to_read <= 0;
            bank_1_ready_to_read <= 0;
        end
        else if ((sym_cnt_read==0) && (sym_mrkr_read==1)&&(sym_cnt_4x==3)) begin 
            bank_0_ready_to_read <= 1;
            bank_1_ready_to_read <= 0;
        end
        else if ((sym_mrkr_read==1)&&(sym_cnt_4x==3)) begin
            bank_0_ready_to_read <= bank_0_ready_to_read + 1;
            bank_1_ready_to_read <= bank_1_ready_to_read + 1;		
        end
		else  begin
            bank_0_ready_to_read <= bank_0_ready_to_read ;
            bank_1_ready_to_read <= bank_1_ready_to_read ;		
        end
		
		
		
    end
end

always_ff @(posedge clk) begin
        if((sym_cnt==0)&&(sym_mrkr==1))
            first_symbol <= 1 ;
		else if(sym_cnt!=0)
		    first_symbol <= 0 ;
end


//ready to read when the last antenna last location is written
//Take location above and add FFT size -1 to get last location
// always_ff @(posedge clk) begin
    // if (clk_en) begin
        // case (ch_bw) 
            // 4'b0000 : begin
                      // last_bank0 <= 'd14335;   // 20Mhz
                      // last_bank1 <= 'd16383;
                      // end
            // 4'b0001 : begin
                      // last_bank0 <= 'd13311;   // 10Mhz 
                      // last_bank1 <= 'd15359;
                      // end
            // 4'b0010 : begin 
                      // last_bank0 <= 'd12799;   //  5Mhz To be verified 
                      // last_bank1 <= 'd14847;
                      // end
            // 4'b0011 : begin
                      // last_bank0 <= 'd14335;  // 20Mhz 
                      // last_bank1 <= 'd16383;
                      // end
  //           nr         
             // 4'b0100 : begin
                      // last_bank0 <= 'd28671;   // 100Mhz
                      // last_bank1 <= 'd32767;
                      // end         
                                                              
            // default : begin
                      // last_bank0 <= 'd14335;
                      // last_bank1 <= 'd16383;
                      // end        
        // endcase
    // end
// end


// always_ff @(posedge clk) begin
    // if (clk_en) begin
//        if(sym_mrkr && slot_mrkr && dv) first_symbol <= 1;
        // if(sym_mrkr && slot_mrkr) first_symbol_d <= 1;
        // else if (sym_mrkr && dv && sym_cnt_4x == 'd0) first_symbol_d <= 0;
    // end
// end

// always_ff @(posedge clk) begin
       // first_symbol_2d <= first_symbol_d;
       // first_symbol_3d <= first_symbol_2d;
       // first_symbol_4d <= first_symbol_3d;
       // first_symbol <= first_symbol_4d;
// end


// always_ff @(posedge clk) begin
    // if (clk_en) begin
        // if (~car_en) begin  //reset
            // bank_0_ready_to_read <= 0;
            // bank_1_ready_to_read <= 0;
        // end
        // else if (dv_2d && (input_add_2d + addr_incr) == last_bank0) begin 
            // bank_0_ready_to_read <= 1;
            // bank_1_ready_to_read <= 0;
        // end
        // else if (dv_2d && (input_add_2d + addr_incr) == last_bank1) begin
            // bank_0_ready_to_read <= 0;
            // bank_1_ready_to_read <= 1;
        // end
    // end
// end

endmodule
