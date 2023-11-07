`timescale 1ns / 1ps
//-----------------------------------------------------------------------------
// Title      : led_driver
// Project    : NA
//-----------------------------------------------------------------------------
// File       : led_driver.v
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

module led_driver(

   input  wire       clk_75m               ,
   input  wire       clk_axi               ,
   input  wire       clk_eth_rx            ,
   input  wire       clk_eth_tx            ,
   input  wire       clk_gt_refclk         ,
   input  wire       rx_block_lock         ,

   input  wire       gpio_cdc_xxv_loopback , 
   input  wire       radio_cdc_loopback    ,
   input  wire       radio_cdc_enable      ,
   input  wire       radio_cdc_error       ,
   input  wire       radio_cdc_status      ,
   input  wire       defm_ant0_active_axi  ,

   input  wire       gpio_cdc_ledmode2     , 
   input  wire       dip_in_cdc_ledmode2   , 
   input  wire [1:0] gpio_cdc_ledgpio      , 

   // (* X_INTERFACE_INFO = "xilinx.com:interface:gpio:1.0 GPIO_I TRI_O" *)
   // (* X_INTERFACE_MODE = "slave GPIO_I" *) 
   // input  wire [7:0] gpio 

  (* X_INTERFACE_INFO = "xilinx.com:interface:gpio_rtl:1.0 LED_O TRI_O" *)
  (* X_INTERFACE_MODE = "master LED_O" *) 
   output wire [7:0] LED                   ,
   output wire       sfp_enable          

);
    
//-----------------------------------------------------------------------------
// Variables
//-----------------------------------------------------------------------------
reg [23:0] clk_75m_count      = 0;
reg [23:0] clk_axi_count      = 0;
reg [23:0] clk_eth_rx_count   = 0;
reg [23:0] clk_eth_tx_count   = 0;
reg [23:0] clk_gt_reclk_count = 0;
wire       led_mode2             ;
    
//-----------------------------------------------------------------------------
// Clock activity generators
//-----------------------------------------------------------------------------
always @(posedge clk_75m)
   clk_75m_count <= clk_75m_count + 'd1;

always @(posedge clk_axi)
   clk_axi_count <= clk_axi_count + 'd1;

always @(posedge clk_eth_rx)
   clk_eth_rx_count <= clk_eth_rx_count + 'd1;

always @(posedge clk_eth_tx)
   clk_eth_tx_count <= clk_eth_tx_count + 'd1;

always @(posedge clk_gt_refclk)
   clk_gt_reclk_count <= clk_gt_reclk_count + 'd1;

//-----------------------------------------------------------------------------
// Set high to enable SFP
//-----------------------------------------------------------------------------
assign sfp_enable = 1'd1;
assign led_mode2  = gpio_cdc_ledmode2 | dip_in_cdc_ledmode2;

//-----------------------------------------------------------------------------
// LED assignment
//-----------------------------------------------------------------------------
assign LED[0] = led_mode2 ? gpio_cdc_xxv_loopback : rx_block_lock          ; // 
assign LED[1] = led_mode2 ? radio_cdc_loopback    : gpio_cdc_ledgpio[0]    ; // 
assign LED[2] = led_mode2 ? radio_cdc_enable      : gpio_cdc_ledgpio[1]    ; // 
assign LED[3] = led_mode2 ? radio_cdc_error       : clk_gt_reclk_count[23] ; // 
assign LED[4] = led_mode2 ? radio_cdc_status      : clk_75m_count[23]      ; // 
assign LED[5] = led_mode2 ? defm_ant0_active_axi  : clk_axi_count[23]      ; // 
assign LED[6] = led_mode2 ? 1'd1                  : clk_eth_tx_count[23]   ; // 
assign LED[7] = led_mode2 ? 1'd1                  : clk_eth_rx_count[23]   ; // 

endmodule

//-----------------------------------------------------------------------------
// Replicate the AXIS signals for Out-Of_Band timestamp control
//-----------------------------------------------------------------------------
module axis_duplicate_master_out (

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TDATA"      *) output wire  [63:0] m0_data_tdata         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TKEEP"      *) output wire   [7:0] m0_data_tkeep         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TVALID"     *) output wire         m0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TLAST"      *) output wire         m0_data_tlast         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TUSER"      *) output  wire        m0_data_tuser         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TREADY"     *) input  wire         m0_data_tready        ,

  // (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 cpy_0 TDATA"      *) output wire  [63:0] c0_data_tdata         ,
  // (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 cpy_0 TKEEP"      *) output wire   [7:0] c0_data_tkeep         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 cpy_0 TVALID"     *) output wire         c0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 cpy_0 TLAST"      *) output wire         c0_data_tlast         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 cpy_0 TUSER"      *) output wire         c0_data_tuser         ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TDATA"     *) input  wire  [63:0] s0_data_tdata         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TKEEP"     *) input  wire   [7:0] s0_data_tkeep         ,  
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TVALID"    *) input  wire         s0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TLAST"     *) input  wire         s0_data_tlast         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TUSER"     *) input  wire         s0_data_tuser         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TREADY"    *) output wire         s0_data_tready        ,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_aresetn RST" *)
  input  wire         s_axis_aresetn     ,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axis_aclk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF slv_in:mas_0:cpy_0" *)
  input  wire         s_axis_aclk        

);

assign m0_data_tdata  = s0_data_tdata  ;
assign m0_data_tkeep  = s0_data_tkeep  ;
assign m0_data_tvalid = s0_data_tvalid ;
assign m0_data_tlast  = s0_data_tlast  ;
assign s0_data_tready = m0_data_tready ;
assign m0_data_tuser  = 1'd0           ; // Tie tuser to 0. The XXV used tuser
                                         // bit0 to mark as errored
                                         // and these will not be sent. 

// assign c0_data_tdata  = s0_data_tdata  ;
// assign c0_data_tkeep  = s0_data_tkeep  ;
assign c0_data_tvalid = s0_data_tvalid ;
assign c0_data_tlast  = s0_data_tlast  ;
assign c0_data_tuser  = s0_data_tuser  ;

endmodule

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
module debug_system_resets (
   input   wire       stat_rx_local_fault_0    ,
   input   wire       stat_tx_local_fault_0    ,
   input   wire       sys_reset                ,
   input   wire       user_rxtx_eth_resetn     ,
   input   wire       user_rx_resetn           ,
   input   wire       user_tx_resetn           ,
   input   wire       rx_block_lock            ,
  
   input   wire       clk_in_sel               ,
   input   wire       reset_to_synce           ,

   output  wire       r_stat_rx_local_fault_0  ,
   output  wire       r_stat_tx_local_fault_0  ,
   output  wire       r_sys_reset              ,
   output  wire       r_user_rxtx_eth_resetn   ,
   output  wire       r_user_rx_resetn         ,
   output  wire       r_user_tx_resetn         ,
   output  wire       r_clk_in_sel             ,
   output  wire       r_reset_to_synce         ,
   output  wire       r_rx_block_lock          ,

   output  wire [7:0] debug_resets_as_bus      ,
   input   wire       axi4_Lite_clk
);

  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_0_i ( .src_clk(), .src_in(stat_rx_local_fault_0), .dest_clk (axi4_Lite_clk), .dest_out (r_stat_rx_local_fault_0) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_1_i ( .src_clk(), .src_in(stat_tx_local_fault_0), .dest_clk (axi4_Lite_clk), .dest_out (r_stat_tx_local_fault_0) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_2_i ( .src_clk(), .src_in(sys_reset            ), .dest_clk (axi4_Lite_clk), .dest_out (r_sys_reset            ) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_3_i ( .src_clk(), .src_in(user_rxtx_eth_resetn ), .dest_clk (axi4_Lite_clk), .dest_out (r_user_rxtx_eth_resetn ) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_4_i ( .src_clk(), .src_in(user_rx_resetn       ), .dest_clk (axi4_Lite_clk), .dest_out (r_user_rx_resetn       ) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_5_i ( .src_clk(), .src_in(user_tx_resetn       ), .dest_clk (axi4_Lite_clk), .dest_out (r_user_tx_resetn       ) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_6_i ( .src_clk(), .src_in(clk_in_sel           ), .dest_clk (axi4_Lite_clk), .dest_out (r_clk_in_sel           ) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_7_i ( .src_clk(), .src_in(reset_to_synce       ), .dest_clk (axi4_Lite_clk), .dest_out (r_reset_to_synce       ) );
  xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_8_i ( .src_clk(), .src_in(rx_block_lock        ), .dest_clk (axi4_Lite_clk), .dest_out (r_rx_block_lock        ) );

  assign debug_resets_as_bus = {
                              r_stat_rx_local_fault_0,
                              r_stat_tx_local_fault_0,
                              r_sys_reset            ,
                              r_user_rxtx_eth_resetn ,
                              r_user_rx_resetn       ,
                              r_user_tx_resetn       ,
                              r_clk_in_sel           ,
                              r_reset_to_synce        
  };
    
endmodule

//-----------------------------------------------------------------------------
// IPI friendly block for adding tuser to AXI streams to identify ARM vs
// Framer traffic.
//-----------------------------------------------------------------------------
module axis_add_tuser (

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TDATA"      *) output wire  [63:0] m0_data_tdata         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TKEEP"      *) output wire   [7:0] m0_data_tkeep         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TVALID"     *) output wire         m0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TLAST"      *) output wire         m0_data_tlast         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TUSER"      *) output wire         m0_data_tuser         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TREADY"     *) input  wire         m0_data_tready        ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TDATA"     *) input  wire  [63:0] s0_data_tdata         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TKEEP"     *) input  wire   [7:0] s0_data_tkeep         ,  
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TVALID"    *) input  wire         s0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TLAST"     *) input  wire         s0_data_tlast         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TREADY"    *) output wire         s0_data_tready        ,

  input custom_t_user,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_aresetn RST" *)
  input  wire         s_axis_aresetn     ,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axis_aclk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF slv_in:mas_0" *)
  input  wire         s_axis_aclk        
);

assign m0_data_tdata  = s0_data_tdata  ;
assign m0_data_tkeep  = s0_data_tkeep  ;
assign m0_data_tvalid = s0_data_tvalid ;
assign m0_data_tlast  = s0_data_tlast  ;
assign m0_data_tuser  = custom_t_user  ;
assign s0_data_tready = m0_data_tready ;

endmodule

//-----------------------------------------------------------------------------
// IPI friendly block for adding tuser to AXI streams to identify ARM vs
// Framer traffic.
//-----------------------------------------------------------------------------
module axis_detect_sop (


  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TVALID"    *) input  wire         s0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TLAST"     *) input  wire         s0_data_tlast         ,
  output wire         sop_valid             ,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_aresetn RST" *)
  input  wire         s_axis_aresetn     ,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axis_aclk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF slv_in" *)
  input  wire         s_axis_aclk        
);

  reg sop_valid_reg;
  reg inframe;
  
  always @(posedge s_axis_aclk)
  begin
    if(s_axis_aresetn == 1'b0)
    begin
      inframe <= 1'b0;
      sop_valid_reg <= 1'b0;
    end
    else
    begin
      if(inframe == 1'b0)
      begin
        inframe <= s0_data_tvalid;
        sop_valid_reg <= s0_data_tvalid;
      end
      else
      begin
        inframe <= ~(s0_data_tlast & s0_data_tvalid);
        sop_valid_reg <= 1'b0;
      end
    end
  end
  assign sop_valid = sop_valid_reg;
  
endmodule

//-----------------------------------------------------------------------------
// Workaround block to supress the ARM grant when a ECPRI packet burst is
// in progress from the framer. This works by waiting for 8 cycles of the
// tvalid from the framer being low, this is enough to indicate that the
// framer has finished its current burst.
// s_req_suppress[C_NUM_SI_SLOTS-1:0] Input
// AXI4-Stream Switch only signal.
// Active-High signal to skip this bus on the
// next arbitration cycle. While the signal is
// asserted, this bus does not receive the next
// arbitration. If this bus already has
// arbitration granted, it remains granted until
// the arbitration cycle is completely normally.
//-----------------------------------------------------------------------------
module axis_tvalid_inhibit (

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TDATA"      *) output wire  [63:0] m0_data_tdata         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TKEEP"      *) output wire   [7:0] m0_data_tkeep         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TVALID"     *) output wire         m0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TLAST"      *) output wire         m0_data_tlast         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 mas_0 TREADY"     *) input  wire         m0_data_tready        ,

  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TDATA"     *) input  wire  [63:0] s0_data_tdata         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TKEEP"     *) input  wire   [7:0] s0_data_tkeep         ,  
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TVALID"    *) input  wire         s0_data_tvalid        ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TLAST"     *) input  wire         s0_data_tlast         ,
  (* X_INTERFACE_INFO = "xilinx.com:interface:axis:1.0 slv_in TREADY"    *) output wire         s0_data_tready        ,

  output reg s_req_suppress,

  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_aresetn RST" *)
  input  wire         s_axis_aresetn     ,
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 s_axis_aclk CLK" *)
  (* X_INTERFACE_PARAMETER = "ASSOCIATED_BUSIF slv_in:mas_0" *)
  input  wire         s_axis_aclk        
);

// Assign the slave to the master, we are not interrupting the data flow, 
// just using the control flags to generate the supress signal.
assign m0_data_tdata  = s0_data_tdata  ;
assign m0_data_tkeep  = s0_data_tkeep  ;
assign m0_data_tvalid = s0_data_tvalid ;
assign m0_data_tlast  = s0_data_tlast  ;
assign s0_data_tready = m0_data_tready ;

reg [3:0] s_req_suppress_counter=0;

// Create the suppress.
// Set high when there is tvalid is active
// only clear after 8 tvalid low cycles
always @(posedge s_axis_aclk) begin
   if(~s_axis_aresetn)
      s_req_suppress <= 1'd0;
   else
      if(s0_data_tvalid)
         s_req_suppress <= 1'd1;
      else
         if(s_req_suppress_counter == 'd8)
            s_req_suppress <= 1'd0;
         else
            s_req_suppress <= s_req_suppress;
end

// use to indicate when we have had multiple tvalid low cycles.
always @(posedge s_axis_aclk) begin
   if(~s_axis_aresetn)
      s_req_suppress_counter <= 'd0;
   else
      if(s0_data_tvalid)
         s_req_suppress_counter <= 'd0;
      else
         s_req_suppress_counter <= s_req_suppress_counter + 'd1;
end

endmodule

//-----------------------------------------------------------------------------
// Generate a pulse from a rising edge. Intended for use with RX Block Lock
// where we may want to reset logic as it becomes high, signalling a good link
//-----------------------------------------------------------------------------
module rising_edge_det_gen_pulse_n (

   input  wire       clk                   ,
   input  wire       signal_in             ,
   output reg        aresetn     = 1           

);
 
//-----------------------------------------------------------------------------
// Variables
//-----------------------------------------------------------------------------
reg  [9:0] shifter            = 0;
wire       signal_in_r           ;


//-----------------------------------------------------------------------------
// Retime the incoming signal
//-----------------------------------------------------------------------------
xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_axi2int_resetn_i ( 
  .src_clk  (), 
  .src_in   (signal_in), 
  .dest_clk (clk), 
  .dest_out (signal_in_r) 
);

//-----------------------------------------------------------------------------
// Create the pulse. 
//-----------------------------------------------------------------------------
always @(posedge clk) begin
   
   if(aresetn) begin

      // Look for the shift register full of 0's and 1 on the input
      if ((!(|shifter)) & (signal_in_r))
        aresetn <= 1'd0;

   end else begin

      // Look for the shift register full of 1's and 1 on the input
      if ((&shifter) & (signal_in_r))
        aresetn <= 1'd1;

   end

end
    
//-----------------------------------------------------------------------------
// free running shift register
//-----------------------------------------------------------------------------
always @(posedge clk)
   shifter <= {shifter[8:0],signal_in_r};

endmodule // rising_edge_det_gen_pulse_n

//-----------------------------------------------------------------------------
// 

// Clk(MHz):100  WatchDog Period
//   
// 15  32768     0.00032768
// 16  65536     0.00065536
// 17  131072    0.00131072
// 18  262144    0.00262144
// 19  524288    0.00524288
// 20  1048576   0.01048576
// 21  2097152   0.02097152
// 22  4194304   0.04194304
// 23  8388608   0.08388608
// 24  16777216  0.16777216

//-----------------------------------------------------------------------------
module low_signal_watchdog #(

  parameter counter_width      = 20,
  parameter zero_match_bit_low = 2

  ) (

   input  wire       clk                   ,
   input  wire       signal_in             ,
   input  wire       disable_wd            ,

   output reg        aresetn     = 1       ,    
   output reg        logic0      = 0       ,    
   output reg        logic1      = 1           

);
 
//-----------------------------------------------------------------------------
// Variables
//-----------------------------------------------------------------------------
reg  [counter_width - 1:0] counter = {counter_width{1'b1}};
wire                       signal_in_r ;

//-----------------------------------------------------------------------------
// Retime the incoming signal
//-----------------------------------------------------------------------------
xpm_cdc_single #( .SRC_INPUT_REG (0) ) xpm_cdc_axi2int_resetn_i ( 
  .src_clk  (1'd0       ), 
  .src_in   (signal_in  ), 
  .dest_clk (clk        ), 
  .dest_out (signal_in_r) 
);

//-----------------------------------------------------------------------------
// Create the pulse. 
//-----------------------------------------------------------------------------
always @(posedge clk) begin
   
   if(disable_wd) begin

      counter <= {counter_width{1'b1}};
      aresetn <= 1'd1;

   end else begin

      if (signal_in_r == 0)
        // If the signal is low, decrement
        counter <= counter - 'd1;
      else 
        // keep the counter at max value
        counter <= {counter_width{1'b1}};

      // Create a pulse as wide as the low parameter
      aresetn <= ~(counter[counter_width-1:zero_match_bit_low] == 'd0);

   end

end
    
endmodule // low_signal_watchdog

//-----------------------------------------------------------------------------
// Simple single bit mux
//-----------------------------------------------------------------------------
module xroe_mux (

   input  wire       a     ,
   input  wire       b     ,
   input  wire       sel_b ,
   output wire       mux_out   

);

assign mux_out = sel_b ? b : a;

endmodule
