`timescale 1ns / 1ps

module rssi_load #(
    parameter PLACEHOLDER       = 0
) (
    input                               clk_15p36,
    input                               resetn_15p36,
    jb_cmn_ctrl_if.xssi                 IFP_regs,
    output  logic                       rssi_load
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
    //localparam MAX_RSSI_TICS = 21'h177000; //CLK15P36 in 100ms
    localparam                  MAX_RSSI_TICS_BW = 21;
    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    logic [MAX_RSSI_TICS_BW-1:0] rssi_cntr;
    logic [MAX_RSSI_TICS_BW-1:0] rssi_window;
    logic 	rssi_enable;


   assign rssi_enable = (IFP_regs.xssi_num_15p36_tics!=0) ? 1'b1 :1'b0;
   assign rssi_window = rssi_enable ? IFP_regs.xssi_num_15p36_tics : 0;   
   assign rssi_load = (rssi_cntr == rssi_window-1) ? 1'b1 : 1'b0;

    jb_cntr #(
        .COUNT_WIDTH        (MAX_RSSI_TICS_BW)
    ) u_jb_gen_rssi_cntr (
      .clk                  (clk_15p36),
      .resetn               (resetn_15p36),
      .enable               (rssi_enable),
      .max_value            (rssi_window), 
      .cntr                 (rssi_cntr)
    );


endmodule
	     
