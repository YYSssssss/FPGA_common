`timescale 1ns/1ps

module data_satu
    #(  parameter   DIN_WIDTH  = 39,
        parameter   DOUT_WIDTH = 17)
    (
    input                           i_rst_n     ,
    input                           i_clk       ,   
    input   [DIN_WIDTH-1:0]         i_data      ,
    
    output  [DOUT_WIDTH-1:0]        o_data      
    );
//------------------------------------------------------------------------------
localparam SATU_WIDTH    = DIN_WIDTH - DOUT_WIDTH + 1   ;
//------------------------------------------------
//  Register input data
//------------------------------------------------
reg										OVF=1;
reg [DOUT_WIDTH-1:0]  data_out=0;

always@(posedge i_clk or negedge i_rst_n)
    if  (!i_rst_n)
        OVF <= 1'b1;
    else if((i_data[DIN_WIDTH-1:(DOUT_WIDTH-1)] == {{SATU_WIDTH}{1'b0}})||(i_data[DIN_WIDTH-1:(DOUT_WIDTH-1)] == {{SATU_WIDTH}{1'b1}}))
        OVF <= 1'b1;      
    else
        OVF <= 1'b0;        
        
always@(posedge i_clk or negedge i_rst_n)
    if  (!i_rst_n)
    	 	data_out <= {DOUT_WIDTH{1'b0}};      
    else if (OVF == 1'b1)
    	 	data_out <= i_data[DOUT_WIDTH-1:0];  
    else if (i_data[DIN_WIDTH-1] == 1'b0)
     	 	data_out <= {1'b0,{{DOUT_WIDTH-1}{1'b1}}};   
    else if (i_data[DIN_WIDTH-1] == 1'b1)
     	 	data_out <= {1'b1,{{DOUT_WIDTH-1}{1'b0}}};     
    else; 	 	   	 	 			 	     		 	  

assign o_data = data_out;
  
endmodule