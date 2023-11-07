

`timescale 1ps/1ps

module jb_eth_core_lpbk	(

  input   wire eth_core_lpbk,
			 

  input  wire  [63:0] oran_if_tx_tdata            ,
  input  wire   [7:0] oran_if_tx_tkeep            ,  
  input  wire         oran_if_tx_tvalid           ,
  input  wire         oran_if_tx_tlast            ,
  output wire         oran_if_tx_tready           ,
  input  wire         oran_if_tx_tuser            ,
  
  output  wire  [63:0] oran_if_rx_tdata            ,
  output  wire   [7:0] oran_if_rx_tkeep            ,  
  output  wire         oran_if_rx_tvalid           ,
  output  wire         oran_if_rx_tlast            ,
  input wire           oran_if_rx_tready           ,
  output  wire         oran_if_rx_tuser            ,

  
  input  wire  [63:0] eth_core_rx_tdata            ,
  input  wire   [7:0] eth_core_rx_tkeep            ,  
  input  wire         eth_core_rx_tvalid           ,
  input  wire         eth_core_rx_tlast            ,
  output wire         eth_core_rx_tready           ,
  input  wire         eth_core_rx_tuser            ,	

  output  wire  [63:0] eth_core_tx_tdata            ,
  output  wire   [7:0] eth_core_tx_tkeep            ,  
  output  wire         eth_core_tx_tvalid           ,
  output  wire         eth_core_tx_tlast            ,
  input   wire         eth_core_tx_tready           ,
  output  wire         eth_core_tx_tuser            			 
			 );
 
   //not sure if we need cdc here, may need to add bram
   assign eth_core_tx_tdata = eth_core_lpbk ? eth_core_rx_tdata : oran_if_tx_tdata;
   assign eth_core_tx_tkeep = eth_core_lpbk ? eth_core_rx_tkeep : oran_if_tx_tkeep;
   assign eth_core_tx_tvalid = eth_core_lpbk ? eth_core_rx_tvalid : oran_if_tx_tvalid;
   assign eth_core_tx_tlast = eth_core_lpbk ? eth_core_rx_tlast : oran_if_tx_tlast;
   assign eth_core_tx_tuser = eth_core_lpbk ? eth_core_rx_tuser : oran_if_tx_tuser;
   assign oran_if_tx_tready  = eth_core_tx_tready;
   assign eth_core_rx_tready = eth_core_lpbk ? eth_core_tx_tready : oran_if_rx_tready;

   assign oran_if_rx_tdata = eth_core_rx_tdata ;
   assign oran_if_rx_tkeep = eth_core_rx_tkeep ;
   assign oran_if_rx_tvalid = eth_core_rx_tvalid ;
   assign oran_if_rx_tlast = eth_core_rx_tlast ;
   assign oran_if_rx_tuser = eth_core_rx_tuser ;

   
   
   

endmodule // jb_eth_core_lpbk
