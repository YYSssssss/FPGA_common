// Y2R_PRAGMA_TP_REQUIRED topLevel            "" 
// Y2R_PRAGMA_TP_REQUIRED axiLite4_interface  "_axi"
//-----------------------------------------------------------------------------
// Title      : roe_radio_cfg
// Project    : NA
//-----------------------------------------------------------------------------
// File       : roe_radio_cfg.v
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
`timescale 1 ps / 1 ps

module roe_radio_cfg #(
   parameter integer                   C_S_AXI_ADDR_WIDTH   = 11
   )
(
   input                                  s_axi_aclk,
   input                                  s_axi_aresetn,
   
   // 
   output reg                             timeout_enable = 1'h0, // 0
   output reg  [11:0]                     timeout_value = 12'h80, // 128
   output reg                             gpio_cdc_ledmode2 = 1'h0, // 0
   output reg  [1:0]                      gpio_cdc_ledgpio = 2'h0, // 0
   input       [7:0]                      gpio_cdc_dipstatus,
   output reg                             sw_trigger = 1'h0, // 0
   output reg                             radio_cdc_enable = 1'h0, // 0
   input                                  radio_cdc_error,
   input                                  radio_cdc_status,
   output reg                             radio_cdc_loopback = 1'h0, // 0
   output reg                             radio_source_enable = 1'h1, // 1
   output reg                             radio_sink_enable = 1'h1, // 1
   input       [31:0]                     radio_cdc_error_31_0,
   input       [31:0]                     radio_cdc_error_63_32,
   input       [31:0]                     radio_cdc_error_95_64,
   input       [31:0]                     radio_cdc_error_127_96,
   input       [31:0]                     radio_cdc_status_31_0,
   input       [31:0]                     radio_cdc_status_63_32,
   input       [31:0]                     radio_cdc_status_95_64,
   input       [31:0]                     radio_cdc_status_127_96,
   output reg  [15:0]                     app_scratch_reg_0 = 16'h0, // 0
   output reg  [15:0]                     app_scratch_reg_1 = 16'h0, // 0
   output reg  [15:0]                     app_scratch_reg_2 = 16'h0, // 0
   output reg  [15:0]                     app_scratch_reg_3 = 16'h0, // 0

 
   // basic register interface
   input                                  slv_rden,
   input                                  slv_wren,
   input       [31:0]                     slv_wdata,
   input       [C_S_AXI_ADDR_WIDTH-1:2]   slv_addr,
   
   output reg                             slv_rd_done,
   output reg                             slv_wr_done,
   output reg  [31:0]                     slv_rdata
 
);

  localparam C_INT_ADDRWIDTH = C_S_AXI_ADDR_WIDTH - 2;

  //----------------------------------------------------------------------------
  // Internal reg/wire declarations
  //----------------------------------------------------------------------------
   wire        [31:0]                     radio_id;

  //----------------------------------------------------------------------------
  // constant wire asisgnments, ease readability instead of coding into the
  // register read statement
  //----------------------------------------------------------------------------
  assign  radio_id                                 = 32'd1179649;

  //----------------------------------------------------------------------------
  // Register write logic
  //----------------------------------------------------------------------------
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
        // set RW register defaults
         timeout_enable                           <= 1'h0; // 0
         timeout_value                            <= 12'h80; // 128
         gpio_cdc_ledmode2                        <= 1'h0; // 0
         gpio_cdc_ledgpio                         <= 2'h0; // 0
         sw_trigger                               <= 1'h0; // 0
         radio_cdc_enable                         <= 1'h0; // 0
         radio_cdc_loopback                       <= 1'h0; // 0
         radio_source_enable                      <= 1'h1; // 1
         radio_sink_enable                        <= 1'h1; // 1
         app_scratch_reg_0                        <= 16'h0; // 0
         app_scratch_reg_1                        <= 16'h0; // 0
         app_scratch_reg_2                        <= 16'h0; // 0
         app_scratch_reg_3                        <= 16'h0; // 0

      end
      else begin

         // Always assign the pulse signals here. These can be overidden in the
         // main write function. This is a valid verilog coding style 
         sw_trigger                               <= 1'd0;


         // on a write we write to the appropiate register 
         if (slv_wren) begin
            case (slv_addr)
            'h1     : begin // @ address = 'd4 'h4 in Memory @ 'h4    
                      timeout_enable                           <= slv_wdata[0];
                      end
            'h3     : begin // @ address = 'd12 'hc in Memory @ 'hc    
                      timeout_value                            <= slv_wdata[11:0];
                      end
            'h4     : begin // @ address = 'd16 'h10 in Memory @ 'h10   
                      gpio_cdc_ledmode2                        <= slv_wdata[0];
                      gpio_cdc_ledgpio                         <= slv_wdata[5:4];
                      end
            'h8     : begin // @ address = 'd32 'h20 in Memory @ 'h20   
                      sw_trigger                               <= slv_wdata[0];
                      end
            'h9     : begin // @ address = 'd36 'h24 in Memory @ 'h24   
                      radio_cdc_enable                         <= slv_wdata[0];
                      end
            'ha     : begin // @ address = 'd40 'h28 in Memory @ 'h28   
                      radio_cdc_loopback                       <= slv_wdata[0];
                      end
            'hb     : begin // @ address = 'd44 'h2c in Memory @ 'h2c   
                      radio_source_enable                      <= slv_wdata[0];
                      radio_sink_enable                        <= slv_wdata[1];
                      end
            'h14    : begin // @ address = 'd80 'h50 in Memory @ 'h50   
                      app_scratch_reg_0                        <= slv_wdata[15:0];
                      end
            'h15    : begin // @ address = 'd84 'h54 in Memory @ 'h54   
                      app_scratch_reg_1                        <= slv_wdata[15:0];
                      end
            'h16    : begin // @ address = 'd88 'h58 in Memory @ 'h58   
                      app_scratch_reg_2                        <= slv_wdata[15:0];
                      end
            'h17    : begin // @ address = 'd92 'h5c in Memory @ 'h5c   
                      app_scratch_reg_3                        <= slv_wdata[15:0];
                      end

            endcase
         end
      end
   end
   
   //---------------------------------------------------------------------------
   // Register read logic, non registered, 
   //---------------------------------------------------------------------------
   always @(*)
     begin
     slv_rdata = 'd0; // Zero all data
     case (slv_addr)
     'h0     : begin // @ address = 'd0 'h0
               slv_rdata[31:0]      = radio_id;
               end
     'h1     : begin // @ address = 'd4 'h4
               slv_rdata[0]         = timeout_enable;
               end
     'h3     : begin // @ address = 'd12 'hc
               slv_rdata[11:0]      = timeout_value;
               end
     'h4     : begin // @ address = 'd16 'h10
               slv_rdata[0]         = gpio_cdc_ledmode2;
               slv_rdata[5:4]       = gpio_cdc_ledgpio;
               end
     'h5     : begin // @ address = 'd20 'h14
               slv_rdata[7:0]       = gpio_cdc_dipstatus;
               end
     'h9     : begin // @ address = 'd36 'h24
               slv_rdata[0]         = radio_cdc_enable;
               slv_rdata[1]         = radio_cdc_error;
               slv_rdata[2]         = radio_cdc_status;
               end
     'ha     : begin // @ address = 'd40 'h28
               slv_rdata[0]         = radio_cdc_loopback;
               end
     'hb     : begin // @ address = 'd44 'h2c
               slv_rdata[0]         = radio_source_enable;
               slv_rdata[1]         = radio_sink_enable;
               end
     'hc     : begin // @ address = 'd48 'h30
               slv_rdata[31:0]      = radio_cdc_error_31_0;
               end
     'hd     : begin // @ address = 'd52 'h34
               slv_rdata[31:0]      = radio_cdc_error_63_32;
               end
     'he     : begin // @ address = 'd56 'h38
               slv_rdata[31:0]      = radio_cdc_error_95_64;
               end
     'hf     : begin // @ address = 'd60 'h3c
               slv_rdata[31:0]      = radio_cdc_error_127_96;
               end
     'h10    : begin // @ address = 'd64 'h40
               slv_rdata[31:0]      = radio_cdc_status_31_0;
               end
     'h11    : begin // @ address = 'd68 'h44
               slv_rdata[31:0]      = radio_cdc_status_63_32;
               end
     'h12    : begin // @ address = 'd72 'h48
               slv_rdata[31:0]      = radio_cdc_status_95_64;
               end
     'h13    : begin // @ address = 'd76 'h4c
               slv_rdata[31:0]      = radio_cdc_status_127_96;
               end
     'h14    : begin // @ address = 'd80 'h50
               slv_rdata[15:0]      = app_scratch_reg_0;
               end
     'h15    : begin // @ address = 'd84 'h54
               slv_rdata[15:0]      = app_scratch_reg_1;
               end
     'h16    : begin // @ address = 'd88 'h58
               slv_rdata[15:0]      = app_scratch_reg_2;
               end
     'h17    : begin // @ address = 'd92 'h5c
               slv_rdata[15:0]      = app_scratch_reg_3;
               end

     default   : slv_rdata = 'd0;
     endcase
     end
   
   //---------------------------------------------------------------------------
   // read/write done logic.
   // For the basic register bank these are fed directly back in as the reg
   // delay is known and fixed.
   //---------------------------------------------------------------------------
   always @(*)
     begin
     slv_rd_done = slv_rden;
     slv_wr_done = slv_wren;
     end

endmodule

//-----------------------------------------------------------------------------
// Title      : roe_radio_source
// Project    : NA
//-----------------------------------------------------------------------------
// File       : roe_radio_source.v
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
`timescale 1 ps / 1 ps

module roe_radio_source #(
   parameter integer                   C_S_AXI_ADDR_WIDTH   = 11
   )
(
   input                                  s_axi_aclk,
   input                                  s_axi_aresetn,

   input                                  clk2_clk,
   input                                  clk2_reset,
   
   // IO for bank 0 
   output reg  [6:0]                      packet_data_size_0 = 7'h0, // 0
   input wire  [6:0]                      packet_data_size_0_pdef,
   output reg  [6:0]                      pause_data_size_0 = 7'h0, // 0
   input wire  [6:0]                      pause_data_size_0_pdef,

 
   // basic register interface
   input                                  slv_rden,
   input                                  slv_wren,
   input       [31:0]                     slv_wdata,
   input       [C_S_AXI_ADDR_WIDTH-1:2]   slv_addr,
   
   output reg                             slv_rd_done,
   output reg                             slv_wr_done,
   output reg  [31:0]                     slv_rdata
 
);

  localparam C_INT_ADDRWIDTH = C_S_AXI_ADDR_WIDTH - 2;

  //----------------------------------------------------------------------------
  // Internal reg/wire declarations
  //----------------------------------------------------------------------------

  reg         slv_rden_r;            // Registered incoming read 
  wire        slv_rden_pls;          // Internally generated pulse
  reg         slv_access_valid_hold; // Flag indicates access in progress in axi domain
  wire        slv_wren_clear;        // Clears the held access valid signal
  reg         slv_access_is_read;    // High is access is a read
  reg  [31:0] slv_wdata_r_internal;  // Register the write data
  wire        slv_wren_clk2;         // Pulse on clk2 when rising edge of valid seen
  wire        slv_wren_done_pulse;   // Pulse on falling edge of clk1_ready
  wire        do_write_clk2;         // Use for debug

  //----------------------------------------------------------------------------
  // Create a held wr or rd signal. This is used to flag an access in progress
  // accross the clock domain.  This is reset when the signal has passed back
  // from the clk2 domain into the axi domain
  //----------------------------------------------------------------------------
  always @( posedge s_axi_aclk ) begin
    if ( ~s_axi_aresetn ) begin
      slv_access_valid_hold <= 'd0;
      slv_wdata_r_internal <= 'd0;
      end
    else begin
      if(slv_wren | slv_rden_pls) begin
        slv_access_valid_hold <= 'd1;
        // register the data locally for cross clock domain crossing
        slv_wdata_r_internal <= slv_wdata;
        end
      else begin
        if(slv_wren_clear) begin
          slv_access_valid_hold <= 'd0;
          end
        // Hold data
        slv_wdata_r_internal <= slv_wdata_r_internal;
        end
      end
    end

  //---------------------------------------------------------------------------
  // register the incoming read strobe, this will stay high, so we create a 
  // pulse to use. to generate the request across the clock domain.
  //---------------------------------------------------------------------------
  always @( posedge s_axi_aclk ) begin
    if ( ~s_axi_aresetn ) begin
      slv_rden_r <= 'd0; // Zero all data
      end
    else begin
      slv_rden_r <= slv_rden;
      end
    end
    
  assign slv_rden_pls = (!slv_rden_r) & slv_rden;

  //---------------------------------------------------------------------------
  //---------------------------------------------------------------------------
  // Clk2 clock domain handshake
  // 
  // This logic pass's the Clk2 access request across the clock domain.
  // On the DRP side, a pulse is generated to initialte the Clk2 access. When
  // The RDY pulse is received, a ready signal is passed back across the clock
  // boundary to the AXI clock domain. This causes the valid request to be
  // removed, and when seen on the DRP domain, the ready is lowered.
  // When the ready falling edge is seen in the AXI domain the AXI transaction
  // is finally completed.
  // Although this logic is slow, it minimises the logic required.
  // It also ensures if the Clk2 rate is very slow compared to the AXI rate
  // transactions will fully complete before another can be requested, though
  // in the case the user should probally set wait_for_drp low and poll for
  // the Clk2 completion
  //---------------------------------------------------------------------------
  //---------------------------------------------------------------------------
  roe_radio_ctrl_hshk_pls_gen clk2clk_handshake_pulse_gen_i(
   .clk1             (s_axi_aclk              ),
   .clk1_rst         (s_axi_aresetn           ),
   
   .clk1_valid       (slv_access_valid_hold   ), // Access in clk1 requested flag, pass to clk2
   .clk1_ready       (slv_wren_clear          ), // Access is complete in clk2, lower request in clk1
   .clk1_ready_pulse (slv_wren_done_pulse     ), // Pulsed on falling edge of clk1_ready, access complete in clk1 & clk2
   
   .clk2             (clk2_clk                ),
   .clk2_rst         (clk2_reset              ),
 
   .clk2_valid       ( ),
   .clk2_valid_pulse (slv_wren_clk2           ),
   .clk2_ready_pulse (slv_wren_clk2           )
    
  );
  
  // Gate the write strobe with the access type. In this case only the read enable
  // is high while we wait for the result
  assign do_write_clk2 = slv_wren_clk2 & (! slv_rden_r);

  //----------------------------------------------------------------------------
  // Register write logic
  //----------------------------------------------------------------------------
   always @( posedge clk2_clk )
   begin
      if (~clk2_reset) begin
        // set RW register defaults

         packet_data_size_0                       <= packet_data_size_0_pdef;
         pause_data_size_0                        <= pause_data_size_0_pdef;

 
      end 
      else begin    
         // on a write we write to the appropriate register
         // Not that slv_rden_r comes from the AXI clock domain, but will be stable
         // when the pulse arrives to register the data.
         if (slv_wren_clk2 & (~slv_rden_r)) begin
            case (slv_addr)
            // WRITE assignments for signal block 0
            'h0     : begin // @ address = 'd0 'h0 in Memory @ 'h0    
                      packet_data_size_0                       <= slv_wdata_r_internal[6:0];
                      end
            'h1     : begin // @ address = 'd4 'h4 in Memory @ 'h4    
                      pause_data_size_0                        <= slv_wdata_r_internal[6:0];
                      end


            endcase
         end   
      end
   end
   
  //----------------------------------------------------------------------------
  // Register read logic
  // All signal come from clk 2, however by design these should be RW signals,
  // originating in this block. Therefore we know these signals will be steady
  // on a read.
  //---------------------------------------------------------------------------
  always @( posedge s_axi_aclk ) begin
    if ( ~s_axi_aresetn ) begin
      end
    else begin
      slv_rdata <= 'd0; // Zero all data bits, individual bits may be modified in the case below
      case (slv_addr)
      // READ assignments for signal block 0
     'h0     : begin // @ address = 'd0 'h0
               slv_rdata[6:0]       <= packet_data_size_0;
               end
     'h1     : begin // @ address = 'd4 'h4
               slv_rdata[6:0]       <= pause_data_size_0;
               end

      default: slv_rdata            <= 'd0;
      endcase
      end
    end
   
   //---------------------------------------------------------------------------
   // read/write done logic.
   // Completed with the retruning pulse from the clk2 domain
   //---------------------------------------------------------------------------
   always @(*)
     begin
     slv_rd_done = slv_wren_done_pulse & (  slv_rden_r) ;
     slv_wr_done = slv_wren_done_pulse & (! slv_rden_r);
     end

endmodule

//-----------------------------------------------------------------------------
// Title      : roe_radio_ctrl_sync
// Project    : NA
//-----------------------------------------------------------------------------
// File       : roe_radio_ctrl_sync.v
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
`timescale 1 ps / 1 ps

//-----------------------------------------------------------------------------
// 5 flop Syncroniser
//-----------------------------------------------------------------------------
//(* dont_touch = "yes" *)
module roe_radio_ctrl_sync #(
  parameter INITIALISE = 1'b0
)
(
  input        clk,              // clock to be sync'ed to
  input        data_in,          // Data to be 'synced'
  output       data_out          // synced data
);

  // Use the new Xilinx CDC libraries. 
  xpm_cdc_single #(
  .DEST_SYNC_FF  (5), // Number of registers in the destination clock domain to account for MTBF
  .SRC_INPUT_REG (0)  // Determines whether there is an input register in src_clk domain.  
                      // SRC_INPUT_REG = 0, input register is not present
  ) cdc_i  (
  .src_clk  (1'd0     ), // We dont use this, but needs tied off to prevent elaboration warnings
  .dest_clk (clk      ),  
  .src_in   (data_in  ),
  .dest_out (data_out )
  );

endmodule


//-----------------------------------------------------------------------------
// Title      : roe_radio_ctrl_hshk_pls_gen
// Project    : NA
//-----------------------------------------------------------------------------
// File       : roe_radio_ctrl_hshk_pls_gen.v
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
`timescale 1 ps / 1 ps

//-----------------------------------------------------------------------------
// Pulse handshake
//-----------------------------------------------------------------------------
module roe_radio_ctrl_hshk_pls_gen (
  input       clk1,
  input       clk1_rst,
  
  input       clk1_valid,
  output      clk1_ready,
  output reg  clk1_ready_pulse,
 
  input       clk2,
  input       clk2_rst,
  
  output      clk2_valid,
  output reg  clk2_valid_pulse,
  input       clk2_ready_pulse
   
 );
 
//-----------------------------------------------------------------------------
// internal registers
//-----------------------------------------------------------------------------
reg clk2_valid_sync_r;
reg clk1_ready_sync_r;
reg clk2_ready;
       
//-----------------------------------------------------------------------------
// sync the valid signal. This should be held high by the clk1 domain until
// ready is seen back in the clk1 domain, when the transaction is complete
//-----------------------------------------------------------------------------
roe_radio_ctrl_sync axi_2_drp_valid_i (
  .clk      (clk2),
  .data_in  (clk1_valid),
  .data_out (clk2_valid) 
);
  
//-----------------------------------------------------------------------------
// Generate a vali pulse in clk2 domain when a rising edge is seen on valid
// When the returning ready pulse is seen the ready flag is raised and then
// passed to the clk1 domain. This signal is cleared when the valid signal
// goes low. It is the responsability of the clk 1 domain to clear this signal
//-----------------------------------------------------------------------------
always @(posedge clk2) begin
  if (~clk2_rst) begin
    clk2_valid_sync_r <= 1'd0;
    clk2_ready        <= 1'd0;
    clk2_valid_pulse  <= 1'd0;
    end
  else begin
    // register the sync output to create an pulse
    clk2_valid_sync_r <= clk2_valid;
    
    // create a pulse on a rising edge across the clock domain
    clk2_valid_pulse <= (~clk2_valid_sync_r) & clk2_valid;
    
    // Generate the ready signal, based on the incoming pulse
    if (clk2_ready_pulse) begin
      clk2_ready <= 1'd1;
      end
    else begin
      if(~clk2_valid) begin
        clk2_ready <= 1'd0;
        end
      end
    end
  end
 
//-----------------------------------------------------------------------------
// pass the ready signal between the two clock domains
//-----------------------------------------------------------------------------
roe_radio_ctrl_sync drp_2_axi_in_progress_i (
  .clk      (clk1),
  .data_in  (clk2_ready),
  .data_out (clk1_ready) 
);
 
//-----------------------------------------------------------------------------
// Generate a pulse on the falling edge of ready. 
//-----------------------------------------------------------------------------
always @(posedge clk1) begin
  if (~clk1_rst) begin
    clk1_ready_pulse  <= 1'd0;
    clk1_ready_sync_r <= 1'd0;
    end
  else begin
    // register the sync output to create an pulse
    clk1_ready_sync_r <= clk1_ready;
    
    // create a pulse on a FALLING edge across the clock domain
    // This is going to be really slow, but for a slow clk2, we need to ensure
    // we dont start another access before its done!
    clk1_ready_pulse <= (~clk1_ready) & (clk1_ready_sync_r);
    end
  end
 
endmodule


//-----------------------------------------------------------------------------
// Title      : roe_radio_ctrl
// Project    : NA
//-----------------------------------------------------------------------------
// File       : roe_radio_ctrl.v
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
`timescale 1 ps / 1 ps

module roe_radio_ctrl #(
 parameter integer  C_S_AXI_ADDR_WIDTH             = 16,
 parameter integer  BANK_DECODE_HIGH_BIT           = 15,
 parameter integer  BANK_DECODE_HIGH_LOW           = 12,
 parameter integer  C_S_TIMEOUT_WIDTH              = 12
) (
 
//-----------------------------------------------------------------------------
// Signal declarations for BANK roe_radio_cfg
//-----------------------------------------------------------------------------
   output                                 timeout_enable,
   output      [11:0]                     timeout_value,
   output                                 gpio_cdc_ledmode2,
   output      [1:0]                      gpio_cdc_ledgpio,
   input       [7:0]                      gpio_cdc_dipstatus,
   output                                 sw_trigger,
   output                                 radio_cdc_enable,
   input                                  radio_cdc_error,
   input                                  radio_cdc_status,
   output                                 radio_cdc_loopback,
   output                                 radio_source_enable,
   output                                 radio_sink_enable,
   input       [127:0]                    radio_cdc_error_bus,
   input       [127:0]                    radio_cdc_status_bus,

 
//-----------------------------------------------------------------------------
// Signal declarations for BANK roe_radio_source
//-----------------------------------------------------------------------------
   input       [6:0]                      packet_data_size_0_pdef,
   output      [6:0]                      packet_data_size_0,
   input       [6:0]                      pause_data_size_0_pdef,
   output      [6:0]                      pause_data_size_0,


//-----------------------------------------------------------------------------
// Other clock domain IO
//-----------------------------------------------------------------------------
// Secondary clock domain s_axis_fram_aclk
   input                                  s_axis_fram_aclk,
   (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 s_axis_fram_aresetn RST" *)
   (* X_INTERFACE_PARAMETER = "POLARITY ACTIVE_LOW" *)
   input                                  s_axis_fram_aresetn,

//-----------------------------------------------------------------------------
// Time out connections in
//-----------------------------------------------------------------------------
   input                                  timeout_enable_in,
   input       [C_S_TIMEOUT_WIDTH-1:0]    timeout_value_in,

//-----------------------------------------------------------------------------
// AXI Lite IO
//-----------------------------------------------------------------------------
   input                                  s_axi_aclk,
   input                                  s_axi_aresetn,
   input       [C_S_AXI_ADDR_WIDTH-1:0]   s_axi_awaddr,
   input                                  s_axi_awvalid,
   output                                 s_axi_awready,
   input       [31:0]                     s_axi_wdata,
   input                                  s_axi_wvalid,
   output                                 s_axi_wready,
   output      [1:0]                      s_axi_bresp,
   output                                 s_axi_bvalid,
   input                                  s_axi_bready,
   input       [C_S_AXI_ADDR_WIDTH-1:0]   s_axi_araddr,
   input                                  s_axi_arvalid,
   output                                 s_axi_arready,
   output      [31:0]                     s_axi_rdata,
   output      [1:0]                      s_axi_rresp,
   output                                 s_axi_rvalid,
   input                                  s_axi_rready

);

//-----------------------------------------------------------------------------
// internal register strobe declarations
//-----------------------------------------------------------------------------
   wire        [BANK_DECODE_HIGH_LOW-1:2] slv_addr;
   wire        [31:0]                     slv_wdata;   
   wire                                   slv_reg_rden;

   wire        [31:0]                     radio_slv_rdata;
   wire                                   radio_slv_wren;
   wire                                   radio_slv_rden;
   wire                                   radio_slv_wr_done;
   wire                                   radio_slv_rd_done;
  
   wire        [31:0]                     fram_slv_rdata;
   wire                                   fram_slv_wren;
   wire                                   fram_slv_rden;
   wire                                   fram_slv_wr_done;
   wire                                   fram_slv_rd_done;
  

//-----------------------------------------------------------------------------
// Signal bus wire declarations for BANK roe_radio_source
//-----------------------------------------------------------------------------


//-----------------------------------------------------------------------------
// Internal signal wire declarations
//-----------------------------------------------------------------------------
   wire        [31:0]                     radio_cdc_error_31_0;
   wire        [31:0]                     radio_cdc_error_63_32;
   wire        [31:0]                     radio_cdc_error_95_64;
   wire        [31:0]                     radio_cdc_error_127_96;
   wire        [31:0]                     radio_cdc_status_31_0;
   wire        [31:0]                     radio_cdc_status_63_32;
   wire        [31:0]                     radio_cdc_status_95_64;
   wire        [31:0]                     radio_cdc_status_127_96;
   wire        [15:0]                     app_scratch_reg_0;
   wire        [15:0]                     app_scratch_reg_1;
   wire        [15:0]                     app_scratch_reg_2;
   wire        [15:0]                     app_scratch_reg_3;

//-----------------------------------------------------------------------------
// Main AXI interface
//-----------------------------------------------------------------------------
roe_radio_ctrl_axi #(
.C_S_AXI_ADDR_WIDTH           (C_S_AXI_ADDR_WIDTH),
.BANK_DECODE_HIGH_BIT         (BANK_DECODE_HIGH_BIT),
.BANK_DECODE_HIGH_LOW         (BANK_DECODE_HIGH_LOW),
.C_S_TIMEOUT_WIDTH            (C_S_TIMEOUT_WIDTH)
) roe_radio_ctrl_axi4l_regif_i (

  .slv_reg_rden                             (slv_reg_rden                            ),
  .slv_addr                                 (slv_addr                                ),
  .slv_wdata                                (slv_wdata                               ),

  .radio_slv_rdata                          (radio_slv_rdata                         ),
  .radio_slv_wren                           (radio_slv_wren                          ),
  .radio_slv_rden                           (radio_slv_rden                          ),
  .radio_slv_rd_done                        (radio_slv_rd_done                       ),
  .radio_slv_wr_done                        (radio_slv_wr_done                       ),

  .fram_slv_rdata                           (fram_slv_rdata                          ),
  .fram_slv_wren                            (fram_slv_wren                           ),
  .fram_slv_rden                            (fram_slv_rden                           ),
  .fram_slv_rd_done                         (fram_slv_rd_done                        ),
  .fram_slv_wr_done                         (fram_slv_wr_done                        ),

  .timeout_enable_in                        (timeout_enable_in                       ),
  .timeout_value_in                         (timeout_value_in                        ),
 
  .s_axi_aclk                               (s_axi_aclk                              ),
  .s_axi_aresetn                            (s_axi_aresetn                           ),

  .s_axi_awaddr                             (s_axi_awaddr                            ),
  .s_axi_awvalid                            (s_axi_awvalid                           ),
  .s_axi_awready                            (s_axi_awready                           ),

  .s_axi_wdata                              (s_axi_wdata                             ),
  .s_axi_wvalid                             (s_axi_wvalid                            ),
  .s_axi_wready                             (s_axi_wready                            ),

  .s_axi_bresp                              (s_axi_bresp                             ),
  .s_axi_bvalid                             (s_axi_bvalid                            ),
  .s_axi_bready                             (s_axi_bready                            ),

  .s_axi_araddr                             (s_axi_araddr                            ),
  .s_axi_arvalid                            (s_axi_arvalid                           ),
  .s_axi_arready                            (s_axi_arready                           ),

  .s_axi_rdata                              (s_axi_rdata                             ),
  .s_axi_rresp                              (s_axi_rresp                             ),
  .s_axi_rvalid                             (s_axi_rvalid                            ),
  .s_axi_rready                             (s_axi_rready                            )

);

//-----------------------------------------------------------------------------
// roe_radio_cfg register bank
//-----------------------------------------------------------------------------
roe_radio_cfg #(
   .C_S_AXI_ADDR_WIDTH           (BANK_DECODE_HIGH_LOW)
) roe_radio_cfg_i (

  .timeout_enable                           (timeout_enable                          ),
  .timeout_value                            (timeout_value                           ),
  .gpio_cdc_ledmode2                        (gpio_cdc_ledmode2                       ),
  .gpio_cdc_ledgpio                         (gpio_cdc_ledgpio                        ),
  .gpio_cdc_dipstatus                       (gpio_cdc_dipstatus                      ),
  .sw_trigger                               (sw_trigger                              ),
  .radio_cdc_enable                         (radio_cdc_enable                        ),
  .radio_cdc_error                          (radio_cdc_error                         ),
  .radio_cdc_status                         (radio_cdc_status                        ),
  .radio_cdc_loopback                       (radio_cdc_loopback                      ),
  .radio_source_enable                      (radio_source_enable                     ),
  .radio_sink_enable                        (radio_sink_enable                       ),
  .radio_cdc_error_31_0                     (radio_cdc_error_31_0                    ),
  .radio_cdc_error_63_32                    (radio_cdc_error_63_32                   ),
  .radio_cdc_error_95_64                    (radio_cdc_error_95_64                   ),
  .radio_cdc_error_127_96                   (radio_cdc_error_127_96                  ),
  .radio_cdc_status_31_0                    (radio_cdc_status_31_0                   ),
  .radio_cdc_status_63_32                   (radio_cdc_status_63_32                  ),
  .radio_cdc_status_95_64                   (radio_cdc_status_95_64                  ),
  .radio_cdc_status_127_96                  (radio_cdc_status_127_96                 ),

  .app_scratch_reg_0                        (app_scratch_reg_0                       ),
  .app_scratch_reg_1                        (app_scratch_reg_1                       ),
  .app_scratch_reg_2                        (app_scratch_reg_2                       ),
  .app_scratch_reg_3                        (app_scratch_reg_3                       ),

  .slv_addr                                 (slv_addr                                ),
  .slv_wdata                                (slv_wdata                               ),
  .slv_rden                                 (radio_slv_rden                          ),
  .slv_wren                                 (radio_slv_wren                          ),

  .slv_wr_done                              (radio_slv_wr_done                       ),
  .slv_rd_done                              (radio_slv_rd_done                       ),
  .slv_rdata                                (radio_slv_rdata                         ),

  .s_axi_aclk                               (s_axi_aclk                              ),
  .s_axi_aresetn                            (s_axi_aresetn                           )

);
//-----------------------------------------------------------------------------
// roe_radio_source register bank, with replicated IO and internal select
//-----------------------------------------------------------------------------
roe_radio_source #(
   .C_S_AXI_ADDR_WIDTH           (BANK_DECODE_HIGH_LOW)
) roe_radio_source_i (


  .packet_data_size_0                       (packet_data_size_0                      ),
  .packet_data_size_0_pdef                  (packet_data_size_0_pdef                 ),
  .pause_data_size_0                        (pause_data_size_0                       ),
  .pause_data_size_0_pdef                   (pause_data_size_0_pdef                  ),

  .slv_addr                                 (slv_addr                                ),
  .slv_wdata                                (slv_wdata                               ),
  .slv_rden                                 (fram_slv_rden                           ),
  .slv_wren                                 (fram_slv_wren                           ),

  .slv_wr_done                              (fram_slv_wr_done                        ),
  .slv_rd_done                              (fram_slv_rd_done                        ),
  .slv_rdata                                (fram_slv_rdata                          ),

  .clk2_clk                                 (s_axis_fram_aclk                        ),
  .clk2_reset                               (s_axis_fram_aresetn                     ),

  .s_axi_aclk                               (s_axi_aclk                              ),
  .s_axi_aresetn                            (s_axi_aresetn                           )

);


assign {radio_cdc_error_127_96,radio_cdc_error_95_64,radio_cdc_error_63_32,radio_cdc_error_31_0} = radio_cdc_error_bus; 
assign {radio_cdc_status_127_96,radio_cdc_status_95_64,radio_cdc_status_63_32,radio_cdc_status_31_0} = radio_cdc_status_bus; 

endmodule


//-----------------------------------------------------------------------------
// Title      : roe_radio_ctrl_axi
// Project    : NA
//-----------------------------------------------------------------------------
// File       : roe_radio_ctrl_axi.v
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
`timescale 1 ps / 1 ps

//-----------------------------------------------------------------------------
// AMBA AXI and ACE Protocol Specification
// ARM IHI 0022D (ID102711)
// AMBA SPEC
// Note section's:
//                A3.3 Relationships between channels
//                B1   AMBA AXI4-Lite
//-----------------------------------------------------------------------------
module roe_radio_ctrl_axi #(
 
   parameter integer                   C_S_AXI_ADDR_WIDTH   = 16,
   parameter integer                   BANK_DECODE_HIGH_BIT = 15,
   parameter integer                   BANK_DECODE_HIGH_LOW = 12,
   parameter integer                   C_S_TIMEOUT_WIDTH = 12
     )
(
   input                                  s_axi_aclk,
   input                                  s_axi_aresetn,
   input       [C_S_AXI_ADDR_WIDTH-1:0]   s_axi_awaddr,
   input                                  s_axi_awvalid,
   output                                 s_axi_awready,
   input       [31:0]                     s_axi_wdata,
   input                                  s_axi_wvalid,
   output                                 s_axi_wready,
   output      [1:0]                      s_axi_bresp,
   output                                 s_axi_bvalid,
   input                                  s_axi_bready,
   input       [C_S_AXI_ADDR_WIDTH-1:0]   s_axi_araddr,
   input                                  s_axi_arvalid,
   output                                 s_axi_arready,
   output      [31:0]                     s_axi_rdata,
   output      [1:0]                      s_axi_rresp,
   output                                 s_axi_rvalid,
   input                                  s_axi_rready,
   
   // Strobes & data bank connections
   output                                 radio_slv_wren,
   output  reg                            radio_slv_rden,
   input                                  radio_slv_wr_done,
   input                                  radio_slv_rd_done,
   input        [31:0]                    radio_slv_rdata,

   output                                 fram_slv_wren,
   output  reg                            fram_slv_rden,
   input                                  fram_slv_wr_done,
   input                                  fram_slv_rd_done,
   input        [31:0]                    fram_slv_rdata,

   input                                  timeout_enable_in,
   input       [C_S_TIMEOUT_WIDTH-1:0]    timeout_value_in,

   output      [31:0]                     slv_wdata,
   output reg  [BANK_DECODE_HIGH_LOW-1:2] slv_addr,
   output reg                             slv_reg_rden

);

   localparam                             RADIO_BANK_SEL       = 'd0;
   localparam                             FRAM_BANK_SEL        = 'd1;
   localparam                             BANK_DECODE          = BANK_DECODE_HIGH_BIT - BANK_DECODE_HIGH_LOW;

   // AXI4LITE signals
   reg                                    axi_awready = 0;
   reg                                    axi_wready  = 0;
   reg         [1:0]                      axi_bresp   = 0;
   reg                                    axi_bvalid  = 0;
   reg                                    axi_arready = 0;
   reg         [31:0]                     axi_rdata   = 0;
   reg         [1:0]                      axi_rresp   = 0;
   reg                                    axi_rvalid  = 0;

   reg                                    valid_waddr = 0;

   reg                                    radio_axi_map_wready;
   wire                                   radio_axi_map_selected;
   reg                                    fram_axi_map_wready;
   wire                                   fram_axi_map_selected;
    
   wire                                   or_all_mapped_wready;
   
   reg         [BANK_DECODE:0]            slv_rd_addr = 0;
   reg                                    slv_reg_done; // correct read done indicator, muxed using read address
   
   // Timeout signals
   wire                                   load_timeout_timer;
   wire                                   clear_timeout_timer;
   wire                                   timeout;
   reg         [C_S_TIMEOUT_WIDTH:0]      timeout_timer_count;
      
   // Flags to stretch access response
   reg                                    read_in_progress;
   reg                                    write_in_progress;
         
   // I/O Connections assignments

   assign s_axi_awready                = axi_awready;                              
   assign s_axi_wready                 = axi_wready;                               
   assign s_axi_bresp                  = axi_bresp;                                
   assign s_axi_bvalid                 = axi_bvalid;                               
   assign s_axi_arready                = axi_arready;                              
   assign s_axi_rdata                  = axi_rdata;                                
   assign s_axi_rresp                  = axi_rresp;                                
   assign s_axi_rvalid                 = axi_rvalid;
   
   assign slv_wdata                    = s_axi_wdata;
   
//---------------------------------------------------------------------------
//---------------------------------------------------------------------------         
// WRITE LOGIC
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
   // Due the potential transaction stretching capabilites of the banks, 
   // we need to keep a track of an ongoing write transaction to prevent
   // reads starting
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         write_in_progress                   <= 1'b0;
      end 
      else begin    
         if ( (s_axi_bready && s_axi_bvalid) | 
               timeout
             ) begin
           // End of a valid write phase, i.e. the complete axi transaction
           // Note this may have been triggered by a timeout
           write_in_progress                <= 1'b0;
         end
         else begin
           if ((axi_awready && s_axi_awvalid)|(axi_wready && s_axi_wvalid)) begin
             // indicates that the slave has acceped the valid read address
             write_in_progress              <= 1'b1;
           end
         end
      end 
   end       
   
   // The axi spec states there is no relationship between the different interfaces.
   // this means the data can complete before the address or vice versa.  In either case we have to think
   // of the overall transaction as being complete if a full address and data set has completed and at this point
   // the resp should be output..  If a write address transaction occurs and it is not for this dut then 
   // it is not only ignored but cancels any pending write_data transaction..

   // Implement axi_awready generation
   // do not allow a new address to be accepted if a current transaction is ongoing
   // if a write and read are active at the same time then prioritise the read (as per axi-ipif)
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         axi_awready                   <= 1'b0;
      end 
      else begin
         // 
         if ((~s_axi_arvalid) & (~read_in_progress)) begin
            if (~axi_awready && s_axi_awvalid && ~valid_waddr) begin
               axi_awready             <= 1'b1;
            end
            else begin
               axi_awready             <= 1'b0;
            end
         end
      end 
   end          

   // the address phase is valid until both the address and data are valid but 
   // they can become valid at any point
   // Note that on a timeout, read_in_progress should be low on a write, but arvalid
   // may now be high. Therefore we need to clear this flag on the timeout condition
   // which will cause axi_bvalid to be set
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         valid_waddr                   <= 1'b0;
      end 
      else begin
         if ((~s_axi_arvalid) & (~read_in_progress) | timeout) begin
            if ((s_axi_bready && axi_bvalid) | timeout) begin
               valid_waddr             <= 1'b0;
            end
            else 
        if (~axi_awready && s_axi_awvalid) begin
                valid_waddr          <= 1'b1;
                end
         end
      end 
   end          

   // Implement slv_addr latching
   // This process is used to latch the address early i.e when awvalid is asserted
   // should then hold until it is used (i.e valid_waddr is low)
   // do we need to consider the case where the read and write addresses are valid together?
   // probably should as there is nothing to stop this happening - in  that case hold off the write
   // to allow the read to continue
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         slv_addr                    <= {(BANK_DECODE_HIGH_LOW-2){1'b0}};
         slv_rd_addr                 <= 'd0;
      end 
      else begin    
         // only allow a write to take the address bus if no read is ongoing
         if (~valid_waddr) begin
            if (s_axi_arvalid & (~read_in_progress)) begin
               // Read address latching
               slv_addr                <= s_axi_araddr[BANK_DECODE_HIGH_LOW-1:2];
               slv_rd_addr             <= s_axi_araddr[BANK_DECODE_HIGH_BIT:BANK_DECODE_HIGH_LOW];
            end
            else if (~axi_awready && s_axi_awvalid) begin
               // write address latching 
               slv_addr                <= s_axi_awaddr[BANK_DECODE_HIGH_LOW-1:2];
               slv_rd_addr             <= s_axi_awaddr[BANK_DECODE_HIGH_BIT:BANK_DECODE_HIGH_LOW];
            end
         end
      end 
   end       

   // Implement axi_wready generation
   // axi_wready is asserted for one s_axi_aclk clock cycle when both
   // s_axi_awvalid and s_axi_wvalid are asserted. axi_wready is 
   // de-asserted when reset is low.  
   // may be acceptable to hold the data transaction until we see the address - avoids the need to 
   // flop the data
   
   assign radio_axi_map_selected = slv_rd_addr == RADIO_BANK_SEL;

   always @( posedge s_axi_aclk )
     begin
        if (~s_axi_aresetn) begin
           radio_axi_map_wready                <= 1'b0;
        end 
        else begin    
           if (~s_axi_arvalid) begin
              if ((~radio_axi_map_wready) && s_axi_wvalid && valid_waddr  && radio_axi_map_selected) begin
                 radio_axi_map_wready          <= 1'b1;
              end
              else begin
                 radio_axi_map_wready          <= 1'b0;
              end
           end
        end 
     end

  
   assign fram_axi_map_selected = slv_rd_addr == FRAM_BANK_SEL;

   always @( posedge s_axi_aclk )
     begin
        if (~s_axi_aresetn) begin
           fram_axi_map_wready                <= 1'b0;
        end 
        else begin    
           if (~s_axi_arvalid) begin
              if ((~fram_axi_map_wready) && s_axi_wvalid && valid_waddr  && fram_axi_map_selected) begin
                 fram_axi_map_wready          <= 1'b1;
              end
              else begin
                 fram_axi_map_wready          <= 1'b0;
              end
           end
        end 
     end

  
   // We have this signal to sweep up out of band memory writes
   reg axi_wr_access;
   always @( posedge s_axi_aclk )
     begin
        if (~s_axi_aresetn) begin
           axi_wr_access                <= 1'b0;
        end 
        else begin    
           if (~s_axi_arvalid) begin
              if ((~axi_wr_access) && s_axi_wvalid && valid_waddr) begin
                 axi_wr_access          <= 1'b1;
              end
              else begin
                 axi_wr_access          <= 1'b0;
              end
           end
        end 
     end
   
   // create an OR of all the mapped ready's so we can see if there was a write request 
   // to a bank that did not exist.
   assign or_all_mapped_wready = radio_axi_map_wready || fram_axi_map_wready;

   always @(*)
   begin
      if (axi_wr_access) begin
         axi_wready                    = 1'b1;
      end
      else begin
         axi_wready                    = 1'b0;
      end
   end

   // Implement memory mapped register select and write logic generation
   // The write data is accepted and written to memory mapped registers when
   // axi_awready, s_axi_wvalid, axi_wready and s_axi_wvalid are asserted. Write strobes are used to
   // select byte enables of slave registers while writing.
   // These registers are cleared when reset (active low) is applied.
   // Slave register write enable is asserted when valid address and data are available
   // and the slave is ready to accept the write address and write data.
   assign radio_slv_wren                 = radio_axi_map_wready           && s_axi_wvalid;
   assign fram_slv_wren                  = fram_axi_map_wready            && s_axi_wvalid;
   
   // Implement write response logic generation
   // The write response and response valid signals are asserted by the slave 
   // when axi_wready, s_axi_wvalid, axi_wready and s_axi_wvalid are asserted.  
   // This marks the acceptance of address and indicates the status of 
   // write transaction. 
   wire bank_write_done;
   
   // If or_all_mapped_wready it indicates an invalid address was written to. We complete as it does
   // no harm, however, possible report a bad address
   assign bank_write_done = radio_slv_wr_done | fram_slv_wr_done;

   always @( posedge s_axi_aclk ) begin
      if (~s_axi_aresetn) begin
         axi_bvalid                    <= 1'b0;
         axi_bresp                     <= 2'b0;
         end 
      else begin    
         // The timeout is gated with s_axi_bready to ensure its only set when there is a valid write
         // The timeout is shared by the read and write logic and 
         if ((timeout & write_in_progress) | (~axi_bvalid && bank_write_done) | (axi_wr_access & ((or_all_mapped_wready == 'd0))) ) begin
            axi_bvalid                 <= 1'b1;
            if (~timeout) begin
              axi_bresp                  <= 2'b00; // 'OKAY' response
              end
            else begin
              axi_bresp                  <= 2'b10; // 'SLVERR' response
              end
           end // work error responses in future
         else begin
            //check if bready is asserted while bvalid is high) 
            //(there is a possibility that bready is always asserted high)   
            if (s_axi_bready && axi_bvalid) begin
               axi_bresp               <= 2'b00;
               axi_bvalid              <= 1'b0; 
               end  
            end
         end
      end   

//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
// READ LOGIC
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
   // Due the potential transaction stretching capabilites of the banks, 
   // we need to keep a track of an ongoing read transaction to prevent
   // writes starting and detecting a valid end condition. The master can
   // wait for rvalid before it asserts rready so we can not rely on an
   // external indicator
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         read_in_progress                   <= 1'b0;
      end 
      else begin    
         if ( (s_axi_rready && s_axi_rvalid) | 
               timeout
             ) begin
           // End of a valid read phase, i.e. the complete axi transaction
           // Note this may have been triggered by a timeout
           read_in_progress                <= 1'b0;
         end
         else begin
           if (axi_arready && s_axi_arvalid) begin
             // indicates that the slave has acceped the valid read address
             read_in_progress              <= 1'b1;
           end
         end
      end 
   end       

   // Implement axi_arready generation
   // axi_arready is asserted for one s_axi_aclk clock cycle when
   // s_axi_arvalid is asserted. axi_arready is 
   // de-asserted when reset (active low) is asserted. 
   // The read address is also latched when s_axi_arvalid is 
   // asserted. slv_addr is reset to zero on reset assertion.
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         axi_arready                   <= 1'b0;
      end 
      else begin    
         // if a read and write happen at the same time then prioritise the read
         // s_axi_arvalid must be low for write_in_progress to be set, so it cannot
         // go high this cycle as s_axi_arvalid is high
         if ((~axi_arready && s_axi_arvalid) & (~read_in_progress) & (~write_in_progress)) begin
            // indicates that the slave has acceped the valid read address
            axi_arready                <= 1'b1;
         end
         else begin
            axi_arready                <= 1'b0;
         end
      end 
   end       

   // Implement axi_arvalid generation
   // axi_rvalid is asserted for one s_axi_aclk clock cycle when both 
   // s_axi_arvalid and axi_arready are asserted. The slave registers 
   // data are available on the axi_rdata bus at this instance. The 
   // assertion of axi_rvalid marks the validity of read data on the 
   // bus and axi_rresp indicates the status of read transaction.axi_rvalid 
   // is deasserted on reset (active low). axi_rresp and axi_rdata are 
   // cleared to zero on reset (active low).  
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         axi_rvalid                    <= 1'b0;
         axi_rresp                     <= 2'b0;
      end 
      else begin
         // timeout should not be gated with (s_axi_rready) this is illegal in the spec!
         // It is gated with read_in_progress so as not to pulse rvalid on a write timeout.
         // read_in_progress is also reset by the timeout
         //
         // slv_reg_done is a muxed version of read done from the bank. This can simply
         // reflect the input read read request <...>_slv_rden (a register below) or be
         // a pulse that should happen at some point in the future to indicate the 
         // transaction is complete. The returning read_done signals are muxed into slv_reg_done
         //
         // Best case this this a registered signal set when (axi_arready && s_axi_arvalid && ~axi_rvalid)
         // A AXI slave is not allowed to raise rvalid until both arready & arvalid are set (A3.3.1)
         //
         // Worst case this is a DRP access that does not complete and the timout is used to complete
         // the AXI tranaction
         //
         if ((timeout & read_in_progress & (~axi_rvalid) ) | 
             (slv_reg_done & (~axi_rvalid) & read_in_progress)
       ) begin
            // Valid read data is available at the read data bus
            axi_rvalid                 <= 1'b1;
            if (~timeout) begin
              axi_rresp                  <= 2'b00; // 'OKAY' response
              end
            else begin
              axi_rresp                  <= 2'b10; // 'SLVERR' response
              end
         end   
         else if (axi_rvalid && s_axi_rready) begin
            // Read data is accepted by the master, we are done
            axi_rvalid <= 1'b0;
         end                
      end
   end    

   // Implement memory mapped register select and read logic generation
   // Slave register read enable is asserted when valid address is available
   // and the slave is ready to accept the read address.
   // bits [UPPER:LOWER] of the address bus are sampled to ensure that if a 
   // write access starts during the read that the correct data is returned
   always @( posedge s_axi_aclk ) begin
     if (~s_axi_aresetn) begin
       slv_reg_rden  <= 'b0;
       radio_slv_rden                 <= 'd0;
       fram_slv_rden                  <= 'd0;
       end
     else begin
       if (axi_arready && s_axi_arvalid && ~axi_rvalid) begin
          slv_reg_rden  <= 1'b1;
          radio_slv_rden                 <= s_axi_araddr[BANK_DECODE_HIGH_BIT:BANK_DECODE_HIGH_LOW] == 'd0;
          fram_slv_rden                  <= s_axi_araddr[BANK_DECODE_HIGH_BIT:BANK_DECODE_HIGH_LOW] == 'd1;
          end
       else begin
         if (slv_reg_done) begin
           slv_reg_rden   <= 1'b0;
           radio_slv_rden                 <= 'd0;
           fram_slv_rden                  <= 'd0;
           end
         else begin
           slv_reg_rden   <= slv_reg_rden;
           radio_slv_rden                 <= radio_slv_rden;
           fram_slv_rden                  <= fram_slv_rden;
           end
       end
     end
   end
      
   // Output register or memory read data
   always @( posedge s_axi_aclk )
   begin
      if (~s_axi_aresetn) begin
         axi_rdata                     <= 32'd0;
      end 
      else begin    
         // When there is a valid read address (s_axi_arvalid) with 
         // acceptance of read address by the slave (axi_arready), output the read data 
         if (slv_reg_rden) begin
            case (slv_rd_addr)
            RADIO_BANK_SEL       : axi_rdata <= radio_slv_rdata;
            FRAM_BANK_SEL        : axi_rdata <= fram_slv_rdata;
            default              : axi_rdata <= 'd0;
            endcase
         end   
      end
   end
   
   // Mux the correct read done flag onto the set, all values in should be from registers
   always @(*)
     begin
     case (slv_rd_addr)
     RADIO_BANK_SEL       : slv_reg_done = radio_slv_rd_done;
     FRAM_BANK_SEL        : slv_reg_done = fram_slv_rd_done;
     default              : slv_reg_done = 'd1; // Must be 1 so all reads to invalid addres's complete
     endcase 
     end
     
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         
// TIMEOUT LOGIC
//---------------------------------------------------------------------------         
//---------------------------------------------------------------------------         

  assign load_timeout_timer   = (s_axi_awvalid & s_axi_awready)   |
                                (s_axi_wvalid  & s_axi_wready)    |
                                (s_axi_arvalid & s_axi_arready);
                      
  assign clear_timeout_timer  = (s_axi_bvalid & s_axi_bready)     |
                                (s_axi_rvalid & s_axi_rready);
                                
  assign timeout              = timeout_timer_count[C_S_TIMEOUT_WIDTH];
  
  always @( posedge s_axi_aclk ) begin
    if (~s_axi_aresetn) begin
      timeout_timer_count <= 'd0;
      end
    else begin
      // clear the timeout at the end of AXI transactions or a timeout event 
      if (clear_timeout_timer | timeout) begin
        timeout_timer_count <= 'd0;
      end
      else begin
      // load the timer at the start of a RW access and only if the timeout is enabled
      if(load_timeout_timer & timeout_enable_in) begin
        timeout_timer_count <= {1'b0,(~timeout_value_in)};
        end
      else begin
        // if the timeout counter is greater than 0 and enabled we count
        if ((timeout_timer_count != 'd0 ) & timeout_enable_in) begin
          timeout_timer_count <= timeout_timer_count + 'd1;
          end
        end
      end
    end 
  end
     
endmodule

