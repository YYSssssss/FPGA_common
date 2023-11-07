

`timescale 1ps/1ps

module jb_eth_core_lpbk	(

  input   eth_core_lpbk,
			 

  input  logic  [63:0] oran_if_tx_tdata            ,
  input  logic   [7:0] oran_if_tx_tkeep            ,  
  input  logic         oran_if_tx_tvalid           ,
  input  logic         oran_if_tx_tlast            ,
  output logic         oran_if_tx_tready           ,
  input  logic  [30:0] oran_if_tx_tuser            ,

  
  input  logic  [63:0] eth_core_rx_tdata            ,
  input  logic   [7:0] eth_core_rx_tkeep            ,  
  input  logic         eth_core_rx_tvalid           ,
  input  logic         eth_core_rx_tlast            ,
  output logic         eth_core_rx_tready           ,
  input  logic  [30:0] eth_core_rx_tuser            ,	

  output  logic  [63:0] eth_core_tx_tdata            ,
  output  logic   [7:0] eth_core_tx_tkeep            ,  
  output  logic         eth_core_tx_tvalid           ,
  output  logic         eth_core_tx_tlast            ,
  input   logic         eth_core_tx_tready           ,
  output  logic  [30:0] eth_core_tx_tuser            			 
			 );


   assign eth_core_tx_tdata = eth_core_lpbk ? eth_core_rx_tdata : oran_if_tx_tdata;
   assign eth_core_tx_tkeep = eth_core_lpbk ? eth_core_rx_tkeep : oran_if_tx_tkeep;
   assign eth_core_tx_tvalid = eth_core_lpbk ? eth_core_rx_tvalid : oran_if_tx_tvalid;
   assign eth_core_tx_tlast = eth_core_lpbk ? eth_core_rx_tlast : oran_if_tx_tlast;
   assign eth_core_tx_tuser = eth_core_lpbk ? eth_core_rx_tuser : oran_if_tx_tuser;
   assign oran_if_tx_tready  = eth_core_tx_tready;
   assign eth_core_rx_tready = eth_core_tx_tready;
   
   

endmodule // jb_eth_core_lpbk
