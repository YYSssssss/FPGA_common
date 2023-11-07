//--  File          : data_round.v  
//--
//--  Author(s)     : zhaojun
//--  number        : cv0028315
//--  function      : 
//--------------------------------------------------------------------------------
//--                               Copyright
//--------------------------------------------------------------------------------
//--
//--           Copyright (C) Lucent Technologies
//--           Lucent Technologies - PROPRIETARY
//--
//--  Disclosure to third parties or reproduction in any form what-
//--  soever, without prior written consent, is strictly forbidden
//--
//---------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//--  RCSId: $Id: data_round.v ,v 1.1 2013/01/24 10:17:59 dg19 Exp $
//------------------------------------------------------------------------------
//--
//------------------------------------------------------------------------------
//--                          History
//------------------------------------------------------------------------------
//--  $Log: data_round.v,v $
//--  Revision 1.1  2013/01/24 10:17:59  zj
//--  First HDL Author 2013 check in
//--
//------------------------------------------------------------------------------
`timescale 1ns/1ps

module data_round
    #(  parameter   DIN_WIDTH  = 39,
        parameter   DOUT_WIDTH = 17)
    (
    input                           i_rst_n     ,
    input                           i_clk       ,   
    input   [DIN_WIDTH-1:0]         i_data      ,
    
    output  [DOUT_WIDTH-1:0]        o_data      
    );
//------------------------------------------------------------------------------
localparam ROUND_WIDTH    = DIN_WIDTH - DOUT_WIDTH   ;
localparam POS_CONSTANT = {1'b1,{{ROUND_WIDTH-1}{1'b0}}};
localparam NEG_CONSTANT = {1'b0,{{ROUND_WIDTH-1}{1'b1}}};

//------------------------------------------------
//  Internal signals
//------------------------------------------------
reg [DIN_WIDTH-1:0]    data_int=0;         

always@(posedge i_clk or negedge i_rst_n)
    if  (!i_rst_n)
        data_int <= {DIN_WIDTH{1'b0}};  
    else if(i_data[DIN_WIDTH-1] == 1'b0)
        data_int <= i_data + {{(DIN_WIDTH-ROUND_WIDTH){1'b0}},POS_CONSTANT};
    else if(i_data[DIN_WIDTH-1] == 1'b1)        
        data_int <= i_data + {{(DIN_WIDTH-ROUND_WIDTH){1'b0}},NEG_CONSTANT};
    else;
    
//------------------------------------------------
//  Register output data
//------------------------------------------------
reg [DOUT_WIDTH-1:0] data_out=0;

always@(posedge i_clk or negedge i_rst_n)
    if  (!i_rst_n)
        data_out <= {DOUT_WIDTH{1'b0}};
    else
        data_out <= data_int[DIN_WIDTH-1:ROUND_WIDTH];    

assign o_data = data_out;
  
endmodule