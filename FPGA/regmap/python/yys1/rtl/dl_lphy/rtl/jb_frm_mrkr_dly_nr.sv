///////////////////////////////////////////////////////////////////////////////////
////  File Name : jb_sub6_beta_top.sv
///// Author    : Shehanaj Begum
///// Date      : 1/04/2019
///// Description  : This module is the Lgan Top    
////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ns / 1 ps

module jb_frm_mrkr_dly_nr  #(
   parameter DELAY_1024_UNITS=2,
   parameter DELAY_ONE_CYCLE_UNITS=1
) (
  input  clk,

  input  frm_mrkr_10ms,
  output frm_mrkr_10ms_dlyd			    
 
);

   

   localparam N_INST=DELAY_1024_UNITS;
   
		    
   logic [N_INST-1:0] data_in;
   logic [N_INST-1:0] data_out;
   logic [DELAY_ONE_CYCLE_UNITS:0] data_in_one_cycle_units;
   
  
   genvar i,j;
   

   assign data_in[0] = frm_mrkr_10ms;
   assign frm_mrkr_10ms_dlyd =  data_in_one_cycle_units[DELAY_ONE_CYCLE_UNITS];

   generate
    for (i = 1; i < N_INST; i = i + 1) begin : gen_delay_connect
        assign data_in[i] = data_out[i-1];
    end : gen_delay_connect
endgenerate
   
   generate
    for (j = 0; j < N_INST; j = j + 1) begin : frm_delay_1024
        shift_delay_1x1024 u_shift_delay (
          .D(data_in[j]),      // input wire [3 : 0] D
          .CLK(clk),           // input wire CLK
          .Q(data_out[j])      // output wire [3 : 0] Q
        );
    end : frm_delay_1024
  endgenerate


  assign data_in_one_cycle_units[0] = data_out[N_INST-1];
    
    generate
        for (i=1; i<=DELAY_ONE_CYCLE_UNITS; i=i+1)
        begin : stretch_stage
            always_ff @(posedge clk) begin
                data_in_one_cycle_units[i] <= data_in_one_cycle_units[i-1];
            end
        end
    endgenerate


endmodule // jb_frm_mrkr_dly
