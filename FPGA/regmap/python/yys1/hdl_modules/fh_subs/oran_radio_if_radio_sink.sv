// ----------------------------------------------------------------------------
//  Title   : ROE-Framer
//  Project : Radio Over Ethernet Subsystem.
// ----------------------------------------------------------------------------
//  File    : oran_radio_if_radio_sink.sv
// ----------------------------------------------------------------------------
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
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
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 
//
// ----------------------------------------------------------------------------
`timescale 1ps/1ps

module oran_radio_if_0_ba_radio_sink	(

  input  wire  [63:0] s_sink_tdata            ,
  input  wire   [7:0] s_sink_tkeep            ,  
  input  wire         s_sink_tvalid           ,
  input  wire         s_sink_tlast            ,
  output wire         s_sink_tready           ,
  input  wire  [30:0] s_sink_tuser            ,

  input  wire   [7:0] slot                    ,
  output reg          status=0                ,
  output reg          error_seen=0            ,
  output reg          tlast_seen=0            ,
  output reg   [15:0] data_error_count=0      ,

  input  wire         radio_sink_enable       ,

  // This signal is provided as an optional input so tready patterns can be
  // driven by external text logic. For normal operation it should simply be 
  // tied to 1'b1
  input  wire         radio_sink_drive_tready ,

  // Clocks
  input  wire         s_sink_aresetn          ,
  input  wire         s_sink_aclk             
  
);

//-----------------------------------------------------------------------------
// declare TB signals
//-----------------------------------------------------------------------------
reg          data_test_in_prog = 0; // 
reg   [15:0] data_content_cnt  = 0; // 
wire  [63:0] dataTestValue        ; // 
reg    [7:0] tlast_counter     = 0; // Count tlasts

//-----------------------------------------------------------------------------
// Assignments
//-----------------------------------------------------------------------------
assign s_sink_tready = radio_sink_drive_tready;
assign dataTestValue = {4'hA, slot[7:0], 4'hA, 
                        data_content_cnt, 
                        data_content_cnt, 
                        data_content_cnt};

//-----------------------------------------------------------------------------
// 
// 
//
// [2:0] [30:28]    CC
//   [1]    [27]    sosy Start of Symbol
//   [1]    [26]    rb 
// [3:0] [25:22]    udcomphdr_iqwidth  (only when dynamic compression is supported)
// [3:0] [21:18]    udcomphdr_compmeth (only when dynamic compression is supported)
// [7:0] [17:10]    NumPrbu
// [9:0]   [9:0]    StartPrbu
// & the SS from slot
//
//-----------------------------------------------------------------------------
always @(posedge s_sink_aclk) begin

  tlast_seen <= (s_sink_tlast && s_sink_tready && s_sink_tvalid);

  if ((~s_sink_aresetn) | (~radio_sink_enable)) begin
    data_error_count      <= 16'd0;
    data_test_in_prog     <= 1'b0;
    tlast_counter         <= 'd0;
  end else begin

    // We only check when valid & ready are high
    if (s_sink_tready & s_sink_tvalid) begin
    
      if(s_sink_tlast)
        tlast_counter <= tlast_counter + 'd1;
     
      // if we are not locked, lock in the counter value from the incomoing data
      //
      if (data_test_in_prog == 'd0) begin

        data_test_in_prog <= 1'd1;
        data_content_cnt  <= s_sink_tdata[15:0] + 'd1;

      end else begin

        // Do the data check
        if (((s_sink_tdata[ 7: 0] != dataTestValue[ 7: 0]) && s_sink_tkeep[0]) ||
            ((s_sink_tdata[15: 8] != dataTestValue[15: 8]) && s_sink_tkeep[1]) ||
            ((s_sink_tdata[23:16] != dataTestValue[23:16]) && s_sink_tkeep[2]) ||
            ((s_sink_tdata[31:24] != dataTestValue[31:24]) && s_sink_tkeep[3]) ||
            ((s_sink_tdata[39:32] != dataTestValue[39:32]) && s_sink_tkeep[4]) ||
            ((s_sink_tdata[47:40] != dataTestValue[47:40]) && s_sink_tkeep[5]) ||
            ((s_sink_tdata[55:48] != dataTestValue[55:48]) && s_sink_tkeep[6]) ||
            ((s_sink_tdata[63:56] != dataTestValue[63:56]) && s_sink_tkeep[7]) ) begin

          if (data_error_count[15] == 1'd0) begin
            data_error_count <= data_error_count + 'd1;
          end
          // reset the data so we can see when there is a data resync
          data_test_in_prog <= 1'd0;

        end else begin
          data_content_cnt <= data_content_cnt + 'd1;         

        end

      end
    end

  end 
end

// Error flag
always @(posedge s_sink_aclk) begin

  status <= data_test_in_prog;

  if ((~s_sink_aresetn) | (~radio_sink_enable)) begin
    error_seen <= 1'd0;
  end else begin
    error_seen <= |data_error_count;
  end

end

endmodule


