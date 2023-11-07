`timescale 1ns / 1ps

module jb_ifft_zero_data_ins_nr # (
    parameter PRECISION = 16
)
 (
    input        clk,       // i clock  
    input        clk_en,    // i clock enable           
    input        reset,     // i reset
    input [PRECISION-1:0] input_I, 
    input [PRECISION-1:0] input_Q,  
    input        rfd,       // i 
    input  [4:0] nfft_size, // i
    input  [15:0] nscs,     // i
    
    output logic [PRECISION-1:0] output_I, 
    output logic [PRECISION-1:0] output_Q,  
    output logic rd_en_data  
    );
     

// Adding 3 clock input offset to allow for timing and CP insertion for ifft
logic [PRECISION-1:0] input_I_d = 0; 
logic [PRECISION-1:0] input_Q_d = 0; 
logic [PRECISION-1:0] input_I_2d = 0; 
logic [PRECISION-1:0] input_Q_2d = 0; 
logic [PRECISION-1:0] input_I_3d = 0; 
logic [PRECISION-1:0] input_Q_3d = 0; 
logic [15:0] space_upper;
logic [15:0] space_lower;
logic [15:0] space_upper_minus_1;
logic [15:0] space_lower_minus_1;
logic [15:0] count_index = 0;
logic [15:0] count_index_d = 0;
logic [15:0] count_index_2d = 0;
logic [15:0] calculation_1 = 0; 
logic dont_read = 0;
logic data_zero = 0;

    always @(posedge clk) begin
        if (clk_en) begin
            calculation_1 <= (2**nfft_size);
            space_upper_minus_1 <= space_upper - 1;
            space_lower_minus_1 <= space_lower - 1;
        end
    end

    always @(posedge clk) begin
        if (clk_en) begin
            space_lower <= {1'b0, nscs[15:1]}-1; // take Half of the spacing.
            //space_lower <= {1'b0, nscs[15:1]}; // take Half of the spacing.  USE this for TB_IFFT simulation to not fail
            space_upper <= calculation_1 - {1'b0, nscs[15:1]};
        end
    end 

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
    
    always @(posedge clk) begin
        if (clk_en) begin
            count_index_d <= count_index;            
            count_index_2d <= count_index_d;    
        end
    end

//tyh change for timming	
(* KEEP="TRUE" *) logic data_zero_ind ;
(* KEEP="TRUE" *) logic data_zero_ind_d ;


	always @(posedge clk) begin
        if  ((count_index > 'd1637) && (count_index < 'd2458)) 
             data_zero_ind <= 1'b1 ;
		else 
		     data_zero_ind <= 1'b0 ;
    end
	
	always @(posedge clk) begin     
             data_zero_ind_d <= data_zero_ind ;
    end	
 
    always @(posedge clk) begin
        if (clk_en) begin    
 //           if  ((count_index_2d > space_lower) && (count_index_2d < space_upper)) begin
              if  (data_zero_ind_d==1) begin
                output_I <= data_zero; 
                output_Q <= data_zero; 
            end
            else begin
                output_I <= input_I; 
                output_Q <= input_Q;
            end
        end
    end
     
    always @(posedge clk) begin
        if (clk_en) begin        
            if  ((count_index >= space_lower_minus_1) && (count_index < space_upper_minus_1)) begin //needs to be early to account for 3 clock offset
                dont_read <= 1;
            end
            else begin
                dont_read <= 0;
            end
        end
     end
     
   // assign rd_en_data = rfd && ~dont_read;
    always @(posedge clk) begin
        if (clk_en)  rd_en_data <= rfd && ~dont_read;
    end



 
endmodule
