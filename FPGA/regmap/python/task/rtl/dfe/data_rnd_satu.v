`timescale 1ns/1ps
module data_rnd_satu
    #(  parameter   DIN_WIDTH  = 33,
        parameter   FRAC_WIDTH = 16,	
        parameter   DOUT_WIDTH = 16)
    (
    input                               i_rst       ,
    input                               i_clk       ,   
    input       [DIN_WIDTH-1:0]         i_data      ,
    
    output  reg [DOUT_WIDTH-1:0]        o_data      
    );
	
reg  [DIN_WIDTH-1:0]            s_data=0   ;	
wire [DIN_WIDTH-FRAC_WIDTH-1:0] s_rnd_dout ;
wire [DOUT_WIDTH-1:0]           s_satu_dout;  
  
always @(posedge i_clk)
begin
  s_data <= i_data;
  o_data <= s_satu_dout;
end


data_round
    #( .DIN_WIDTH  (DIN_WIDTH),
       .DOUT_WIDTH (DIN_WIDTH-FRAC_WIDTH))
    data_round_491_i
    ( 
    .i_rst_n     (!i_rst    ),
    .i_clk       (i_clk     ),   
    .i_data      (s_data    ),    
    .o_data      (s_rnd_dout)
    );
data_satu
    #(.DIN_WIDTH  (DIN_WIDTH-FRAC_WIDTH),
      .DOUT_WIDTH (DOUT_WIDTH))
    data_satu_491_i
    (
    .i_rst_n     (!i_rst     ),
    .i_clk       (i_clk      ),   
    .i_data      (s_rnd_dout ),
    .o_data      (s_satu_dout)
    );
	
	
	
endmodule