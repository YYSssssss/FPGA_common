`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/23 10:37:01
// Design Name: 
// Module Name: cp_s1_write_ram
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
`include "rsp_common_defines.vh"
`include "rsp_s1_prep_defines.vh"

module rsp_s1_prep_write_ram #(
    parameter DELAY_DATA_RSP_S1_PREP_CORE = 2,
    parameter READ_RAM_WIDTH = 128,
    parameter SAMPLE_WIDTH = 32,
    parameter ADD_ADDR = 16
)(
   input                                       clk                ,
   input                                       rst_n              ,
   input      [`DATA_BURST_LEN_WIDTH-1:0]      CSR_BURST_LEN      ,
   input      [`SMP_CNT-1:0]                   CSR_EST_SMP_CNT    ,
   input      [`CHP_CNT-1:0]                   CSR_EST_CHP_CNT    ,
   input      [`FRM_CNT-1:0]                   CSR_EST_FRM_CNT    ,
   input      [`L1_ADDR_WIDTH-1:0]             CSR_WR_START_ADDR  ,
   input      [READ_RAM_WIDTH-1:0]             i_data             ,
   input                                       i_data_valid       ,
   input                                       i_data_last        ,
   output reg [READ_RAM_WIDTH-1:0]             o_m1_wr_data       ,            
   output reg [`L1_ADDR_WIDTH-1:0]             o_m1_wr_addr       ,
   output reg                                  o_m1_wr_en         ,
   output reg [`L1_STRB_WIDTH-1:0]             o_m1_wr_wea        ,
   output reg                                  o_finish
);

//********************  parameter  ********************//

//debug
localparam CNT_WR_WIDTH = 16;


//********************  reg & wire  ********************//
reg  i_data_valid_d0;
reg  i_data_valid_d1;
wire data_valid;
reg [READ_RAM_WIDTH-1:0] i_data_d0;
reg [READ_RAM_WIDTH-1:0] i_data_d1;


reg [`SMP_CNT-1:0]              cnt_smp;
reg [`CHP_CNT-1:0]              cnt_chp;

//debug
// wire [READ_RAM_WIDTH-1:0] s_data;
reg [CNT_WR_WIDTH:0] cnt_wr_en;

//********************  cnt  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_wr_en <= {CNT_WR_WIDTH{1'b0}};
  end
  else begin
    if(cnt_chp == CSR_EST_CHP_CNT-1 && cnt_smp == CSR_EST_SMP_CNT-1)
        cnt_wr_en <= {CNT_WR_WIDTH{1'b0}};
    else if(o_m1_wr_en)
        cnt_wr_en <= cnt_wr_en + 1'b1;
    else
        cnt_wr_en <= cnt_wr_en;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_smp <= {`SMP_CNT{1'b0}};
  end
  else if(cnt_smp == CSR_EST_SMP_CNT-1)
    cnt_smp <= {`SMP_CNT{1'b0}};
  else if(o_m1_wr_en)
    cnt_smp <= cnt_smp + 1'b1;
  else
    cnt_smp <= cnt_smp;
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_chp <= {`CHP_CNT{1'b0}};
  end
  else if(cnt_chp == CSR_EST_CHP_CNT-1 && cnt_smp == CSR_EST_SMP_CNT-1)
    cnt_chp <= {`CHP_CNT{1'b0}};
  else if(cnt_smp == CSR_EST_SMP_CNT-1)
    cnt_chp <= cnt_chp + 1'b1;
  else
    cnt_chp <= cnt_chp;
end


//******************** Indicative signal ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_data_valid_d0 <= 1'b0;
    i_data_valid_d1 <= 1'b0;
    i_data_d0       <= {READ_RAM_WIDTH{1'b0}};
    i_data_d1       <= {READ_RAM_WIDTH{1'b0}};
  end
  else begin
    i_data_valid_d0 <= i_data_valid;
    i_data_valid_d1 <= i_data_valid_d0;

    i_data_d0       <= i_data;
    i_data_d1       <= i_data_d0;
    o_m1_wr_data    <= i_data_d1;
  end
end
assign data_valid = i_data_valid_d0 & ~i_data_valid_d1;

//******************** output ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m1_wr_en <= 1'b0;
    o_m1_wr_wea <= {SAMPLE_WIDTH/2{1'b0}};
  end
  else begin
    o_m1_wr_en <= i_data_valid_d1;
    o_m1_wr_wea <= 16'hffff;
  end
end


// assign s_data = i_data_valid ? i_data : {READ_RAM_WIDTH{1'b0}};
// rsp_s1_prep_delay_data #(
//   .DEPTH      (DELAY_DATA_RSP_S1_PREP_CORE),
//   .DATA_WIDTH (READ_RAM_WIDTH)
// )u_delay_data(
//   .clk          (clk         ),
//   .rst_n        (rst_n       ),
//   .i_x0         (s_data      ),
//   .o_y0         (o_m1_wr_data)
// );

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m1_wr_addr <= CSR_WR_START_ADDR;
  end
  else begin
    if(cnt_chp == CSR_EST_CHP_CNT-1 && cnt_smp == CSR_EST_SMP_CNT-1)
        o_m1_wr_addr <= CSR_WR_START_ADDR;
    else if(o_m1_wr_en)
        o_m1_wr_addr <= o_m1_wr_addr + ADD_ADDR;
    else
        o_m1_wr_addr <= o_m1_wr_addr;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_finish <= 1'b0;
  end
  else begin
    if(cnt_chp == CSR_EST_CHP_CNT-1 && cnt_smp == CSR_EST_SMP_CNT-1)
        o_finish <= 1'b1;
    else
        o_finish <= 1'b0;
  end
end

endmodule

