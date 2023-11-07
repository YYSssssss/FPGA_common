//-----------------------------------------------------------------------------
// Title      : xxv_ts_routing
// Project    : NA
//-----------------------------------------------------------------------------
// File       : xxv_ts_routing.v
// Author     : Xilinx Inc.
//-----------------------------------------------------------------------------
// (c) Copyright 2018 Xilinx, Inc. All rights reserved.
//
// This file contains confidential and proprietary information
// of Xilinx, Inc. and is protected under U.S. and
// international copyright and other intellectual property
// laws.
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE 'AS IS' AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
//
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, 'Critical
// Applications'). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
//
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES.
//-----------------------------------------------------------------------------

module xxv_ts_routing (
  
  // 1588 TX 2 step control
  output wire  [1:0]  tx_ptp_1588op                 ,
  output reg   [15:0] tx_ptp_tag_field =0           ,
  output wire         packet_is_from_arm            ,

  // 1588 TX 2 step control FIFO interface
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_eth  TUSER"  *)  input  wire         tx_eth_tuser                 ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_eth  TVALID" *)  input  wire         tx_eth_tvalid                ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_eth  TLAST"  *)  input  wire         tx_eth_tlast                 ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_ctrl TDATA"  *) input  wire  [31:0] tx_ptp_ctrl_tdata             ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_ctrl TVALID" *) input  wire         tx_ptp_ctrl_tvalid            ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_ctrl TLAST"  *) input  wire         tx_ptp_ctrl_tlast             ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_ctrl TREADY" *) output reg          tx_ptp_ctrl_tready = 0        ,

  // 1588 TX timestamp XXV -> FIFO interface
  input  wire         tx_ptp_tstamp_valid_in        ,
  input  wire  [15:0] tx_ptp_tstamp_tag_in          ,
  input  wire  [79:0] tx_ptp_tstamp_in              ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_ts TDATA"  *)   output reg   [95:0] tx_ptp_ts_tdata    = 0        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_ts TVALID" *)   output reg          tx_ptp_ts_tvalid   = 0        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 tx_ts TLAST"  *)   output reg          tx_ptp_ts_tlast    = 0        ,
   
  // 1588 RX timestamp XXV -> FIFO interface
  input  wire  [79:0] rx_ptp_tstamp_in              ,
  input  wire         rx_ptp_tstamp_valid_in        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 rx_ts TDATA"  *)   output reg   [95:0] rx_ptp_ts_tdata    = 0        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 rx_ts TVALID" *)   output reg          rx_ptp_ts_tvalid   = 0        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 rx_ts TLAST"  *)   output reg          rx_ptp_ts_tlast    = 0        ,

  // 1588 XXV stats
  input  wire         stat_tx_ptp_fifo_read_error_0 ,
  input  wire         stat_tx_ptp_fifo_write_error_0,
 
  // Clock control
  output wire         rx_out_clk_locked             ,
  output wire         tx_eth_clk_locked             ,
 
  input  wire         systemtimer_clk               ,
  output wire  [1:0]   state,
  
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 internal_clk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF rx_ts" *)
  input  wire         internal_clk                  ,
  
  input  wire         rx_out_clk                    ,
  
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 tx_eth_clk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF tx_ts:tx_ctrl:tx_eth" *)
  input  wire         tx_eth_clk                    ,
  input  wire         tx_eth_aresetn 

);

//-----------------------------------------------------------------------------
// Build the RX time stamp fifo interface
//-----------------------------------------------------------------------------
always @(posedge internal_clk) begin
   rx_ptp_ts_tdata  <= {16'd0,rx_ptp_tstamp_in};
   rx_ptp_ts_tvalid <= rx_ptp_tstamp_valid_in;
   rx_ptp_ts_tlast  <= rx_ptp_tstamp_valid_in;
end

//-----------------------------------------------------------------------------
// Build the TX time stamp fifo interface
//-----------------------------------------------------------------------------
always @(posedge tx_eth_clk) begin
   tx_ptp_ts_tdata  <= {tx_ptp_tstamp_tag_in, tx_ptp_tstamp_in};
   tx_ptp_ts_tvalid <= tx_ptp_tstamp_valid_in;
   tx_ptp_ts_tlast  <= tx_ptp_tstamp_valid_in;
end

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------

localparam PTPCTRL_IDLE     = 2'd0;
localparam PTPCTRL_WAITDATA = 2'd1;
localparam PTPCTRL_WAITLAST = 2'd2;
localparam PTPCTRL_RETURN   = 2'd3;

reg   [1:0] ptp_tag_wait          = 0; // Clear when tlast & tvalid seen, other wise sticky on a tvalid
reg  [31:0] tx_ptp_ctrl_tdata_r   = 0; // 

always @(*) begin
  tx_ptp_tag_field = tx_ptp_ctrl_tdata[31:16];
end

//-----------------------------------------------------------------------------
// Simple SM to control the presentation of the OP control work to the XXV
// MAC
//-----------------------------------------------------------------------------
assign state = ptp_tag_wait;
always @(posedge tx_eth_clk) begin
   if (~tx_eth_aresetn) begin
      ptp_tag_wait        <= PTPCTRL_IDLE;
      tx_ptp_ctrl_tready  <= 1'd0;
      tx_ptp_ctrl_tdata_r <= 32'd0;
   end else begin
      tx_ptp_ctrl_tdata_r <= tx_ptp_ctrl_tdata_r; // Always keep last value
      case(ptp_tag_wait)
      PTPCTRL_IDLE     : begin
                            // Step one, we need to wait until we get a TS from the ARM
                            // Due to the LinuxDriver sequencing this will always happen
                            // before the data is packet is DMAed.
                            if (tx_ptp_ctrl_tvalid) begin
                               ptp_tag_wait        <= PTPCTRL_WAITDATA;
                               tx_ptp_ctrl_tready  <= 1'd0;
                               tx_ptp_ctrl_tdata_r <= tx_ptp_ctrl_tdata;
                            end else begin
                               tx_ptp_ctrl_tready  <= 1'd1;
                               ptp_tag_wait        <= PTPCTRL_IDLE;
                            end
                         end
      PTPCTRL_WAITDATA : begin
                            // Wait for the next packed from the ARM(tuser high) this is the 
                            // corresponding TS packet. This is the cycle we need to apply
                            // the TAG & TYPE to the MAC, then we wait for the packet to clear
                            if (tx_eth_tuser & tx_eth_tvalid) begin


                               if (tx_ptp_ctrl_tdata_r[1:0]==0) begin
                                  // Code was a NOOP which means there will be no timestamp
                                  // Let buffer pop
                                  ptp_tag_wait       <= PTPCTRL_RETURN;
                                  tx_ptp_ctrl_tready <= 1'd1;
                               end else begin
                                  tx_ptp_ctrl_tready <= 1'd0;
                                  ptp_tag_wait       <= PTPCTRL_WAITLAST;
                               end



                            end else begin
                               tx_ptp_ctrl_tready <= 1'd0;
                               ptp_tag_wait       <= PTPCTRL_WAITDATA;
                            end
                         end
      PTPCTRL_WAITLAST : begin
                            // look for the last to clear the buffer and reapply tready
                            // tready is most important as we dont want to take another TS 
                            // before we are ready for it
                            if (tx_ptp_tstamp_valid_in) begin
                            // if (tx_eth_tlast & tx_eth_tvalid) begin
                               ptp_tag_wait        <= PTPCTRL_RETURN;
                               tx_ptp_ctrl_tready  <= 1'd1;
                               // tx_ptp_ctrl_tdata_r <= 32'd0;
                            end else begin
                               tx_ptp_ctrl_tready <= 1'd0;
                               ptp_tag_wait       <= PTPCTRL_WAITLAST;
                            end
                         end
      PTPCTRL_RETURN   : begin
                            ptp_tag_wait        <= PTPCTRL_IDLE;
                            tx_ptp_ctrl_tdata_r <= 32'd0;
                         end
      default          : begin
                            // should not be here, drop to idle
                            ptp_tag_wait        <= PTPCTRL_IDLE;
                            tx_ptp_ctrl_tready  <= 1'd1;
                            tx_ptp_ctrl_tdata_r <= 32'd0;
                         end
      endcase
   end
end

//-----------------------------------------------------------------------------
// Create the OP code
//-----------------------------------------------------------------------------
//assign tx_ptp_1588op = ((ptp_tag_wait == PTPCTRL_WAITDATA) & (tx_eth_tvalid & tx_eth_tuser)) ? tx_ptp_ctrl_tdata_r[1:0] : 2'd0;
//assign tx_ptp_1588op = (((ptp_tag_wait == PTPCTRL_WAITDATA) | (ptp_tag_wait == PTPCTRL_WAITLAST) ) & (tx_eth_tvalid & tx_eth_tuser)) ? tx_ptp_ctrl_tdata_r[1:0] : 2'd0;
assign tx_ptp_1588op      = tx_eth_tuser ? tx_ptp_ctrl_tdata_r[1:0] : 2'd0;
assign packet_is_from_arm = tx_eth_tuser;

//-----------------------------------------------------------------------------
// Generate clock locked signals. Technically there are more clock avaiable
// but should be effective in this case
//-----------------------------------------------------------------------------
xpm_cdc_sync_rst #(

  //Common module parameters
  .DEST_SYNC_FF   (4), // integer; range: 2-10
  .INIT           (0), // integer; 0=initialize synchronization registers to 0,
                       //          1=initialize synchronization registers to 1
  .INIT_SYNC_FF   (0), // integer; 0=disable simulation init values, 1=enable simulation init values
  .SIM_ASSERT_CHK (0)  // integer; 0=disable simulation messages, 1=enable simulation messages

) rx_out_clk_locked_i (

  .src_rst  (1'd1             ),
  .dest_clk (rx_out_clk       ),
  .dest_rst (rx_out_clk_locked)

);

xpm_cdc_sync_rst #(

  //Common module parameters
  .DEST_SYNC_FF   (4), // integer; range: 2-10
  .INIT           (0), // integer; 0=initialize synchronization registers to 0,
                       //          1=initialize synchronization registers to 1
  .INIT_SYNC_FF   (0), // integer; 0=disable simulation init values, 1=enable simulation init values
  .SIM_ASSERT_CHK (0)  // integer; 0=disable simulation messages, 1=enable simulation messages

) tx_eth_clk_locked_i (

  .src_rst  (1'd1             ),
  .dest_clk (tx_eth_clk       ),
  .dest_rst (tx_eth_clk_locked)

);

endmodule
