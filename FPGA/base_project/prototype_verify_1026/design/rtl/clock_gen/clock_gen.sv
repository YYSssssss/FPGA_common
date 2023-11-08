`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/26 22:18:48
// Design Name: 
// Module Name: clock_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_gen(
    input i_fpga_clk,
    
    output logic o_clk_10m,
    output logic o_clk_100m,
    output logic o_clk_200m,
    output logic o_clk_300m,
    
    output logic o_aresetn_10m,
    output logic o_aresetn_100m,
    output logic o_aresetn_200m,
    output logic o_aresetn_300m
    );
    
logic locked;

clk_wiz_0 u_clk_wiz (
  .clk_in1     (i_fpga_clk    ),
  .clk_out1    (o_clk_200m      ),   // For IDEALY
  .clk_out2    (o_clk_10m       ),   // For UDP KSZ9031_phy rst
  .clk_out3    (o_clk_100m      ),   // For LVDS init delay
  .clk_out4    (o_clk_300m      ),   // For LVDS ILA
   .locked     (locked)
);

proc_sys_reset_0 areset_10m (
  .slowest_sync_clk(o_clk_10m),          // input wire slowest_sync_clk
  .ext_reset_in(1'b0),                  // input wire ext_reset_in
  .aux_reset_in(1'b0),                  // input wire aux_reset_in
  .mb_debug_sys_rst(1'b0),          // input wire mb_debug_sys_rst
  .dcm_locked(locked),                      // input wire dcm_locked
  .mb_reset(),                          // output wire mb_reset
  .bus_struct_reset(),          // output wire [0 : 0] bus_struct_reset
  .peripheral_reset(),          // output wire [0 : 0] peripheral_reset
  .interconnect_aresetn(),  // output wire [0 : 0] interconnect_aresetn
  .peripheral_aresetn(o_aresetn_10m)      // output wire [0 : 0] peripheral_aresetn
);

proc_sys_reset_0 areset_100m (
  .slowest_sync_clk(o_clk_100m),          // input wire slowest_sync_clk
  .ext_reset_in(1'b0),                  // input wire ext_reset_in
  .aux_reset_in(1'b0),                  // input wire aux_reset_in
  .mb_debug_sys_rst(1'b0),          // input wire mb_debug_sys_rst
  .dcm_locked(locked),                      // input wire dcm_locked
  .mb_reset(),                          // output wire mb_reset
  .bus_struct_reset(),          // output wire [0 : 0] bus_struct_reset
  .peripheral_reset(),          // output wire [0 : 0] peripheral_reset
  .interconnect_aresetn(),  // output wire [0 : 0] interconnect_aresetn
  .peripheral_aresetn(o_aresetn_100m)      // output wire [0 : 0] peripheral_aresetn
);

proc_sys_reset_0 areset_200m (
  .slowest_sync_clk(o_clk_200m),          // input wire slowest_sync_clk
  .ext_reset_in(1'b0),                  // input wire ext_reset_in
  .aux_reset_in(1'b0),                  // input wire aux_reset_in
  .mb_debug_sys_rst(1'b0),          // input wire mb_debug_sys_rst
  .dcm_locked(locked),                      // input wire dcm_locked
  .mb_reset(),                          // output wire mb_reset
  .bus_struct_reset(),          // output wire [0 : 0] bus_struct_reset
  .peripheral_reset(),          // output wire [0 : 0] peripheral_reset
  .interconnect_aresetn(),  // output wire [0 : 0] interconnect_aresetn
  .peripheral_aresetn(o_aresetn_200m)      // output wire [0 : 0] peripheral_aresetn
);

proc_sys_reset_0 areset_300m (
  .slowest_sync_clk(o_clk_300m),          // input wire slowest_sync_clk
  .ext_reset_in(1'b0),                  // input wire ext_reset_in
  .aux_reset_in(1'b0),                  // input wire aux_reset_in
  .mb_debug_sys_rst(1'b0),          // input wire mb_debug_sys_rst
  .dcm_locked(locked),                      // input wire dcm_locked
  .mb_reset(),                          // output wire mb_reset
  .bus_struct_reset(),          // output wire [0 : 0] bus_struct_reset
  .peripheral_reset(),          // output wire [0 : 0] peripheral_reset
  .interconnect_aresetn(),  // output wire [0 : 0] interconnect_aresetn
  .peripheral_aresetn(o_aresetn_300m)      // output wire [0 : 0] peripheral_aresetn
);

//ila_reset u_ila_reset (
//	.clk(clk_300m), // input wire clk

//	.probe0(locked), // input wire [0:0]  probe0  
//	.probe1(aresetn_200m), // input wire [0:0]  probe1 
//	.probe2(aresetn_300m) // input wire [0:0]  probe2
//);

endmodule
