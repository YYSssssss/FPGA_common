`timescale 1ns / 1ps

module shreg #(
    parameter integer DATA_WIDTH            = 9                 ,
    parameter integer DEPTH                 = 8                             
    )
    (
 
    //write port
    input  logic                                             clk           ,
    input  logic[DATA_WIDTH-1:0]                             din           ,                          
    output logic[DATA_WIDTH-1:0]                             dout       
       
    );
    //***************logic Declarations***************************

    logic [DATA_WIDTH-1:0] shreg_tmp [0 : DEPTH -1] ;

    //***************logic Declarations***************************


    always_ff @(posedge clk ) begin
        shreg_tmp[0] <= din ;
        for (int i = 0; i <= DEPTH-2; i++) begin
            shreg_tmp[i+1] <= shreg_tmp[i] ;
        end
    end

    assign dout = shreg_tmp[DEPTH-1] ;
    
endmodule
