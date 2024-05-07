`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/22 23:27:25
// Design Name: 
// Module Name: cp_read_ram
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

module rsp_s1_prep_read_ram #(
    parameter DELAY_DATA_RSP_S1_PREP_CORE = 5,
    parameter READ_RAM_WIDTH = 128,
    parameter SAMPLE_WIDTH = 32,
    parameter RD_INTERVAL = 50,
    parameter ADD_ADDR = 16
)(
   input                                       clk                  ,
   input                                       rst_n                ,
   input      [`DATA_BURST_LEN_WIDTH-1:0]      CSR_BURST_LEN        ,
   input      [`SMP_CNT-1:0]                   CSR_EST_SMP_CNT      ,
   input      [`CHP_CNT-1:0]                   CSR_EST_CHP_CNT      ,
   input      [`FRM_CNT-1:0]                   CSR_EST_FRM_CNT      ,
   input      [`L1_ADDR_WIDTH:0]               CSR_RD_START_ADDR    ,
   input                                       i_start          ,
   input      [READ_RAM_WIDTH-1:0]             i_m0_rd_data     ,            
   output reg [`L1_ADDR_WIDTH-1:0]             o_m0_rd_addr     ,
   output reg                                  o_m0_rd_en       ,
   output reg [READ_RAM_WIDTH-1:0]             o_data           ,
   output                                      o_data_valid     ,
   output                                      o_data_last

   //debug


);

//********************  parameter  ********************//


//********************  reg & wire & assign ********************//
reg  i_start_d0;
reg  i_start_d1;
wire start_p;
reg  op_work;
reg  s_data_last;
reg pipeline_vld;

reg [`DATA_BURST_LEN_WIDTH-1:0] cnt_burst_len;
reg [`SMP_CNT-1:0]              cnt_smp;
reg [`CHP_CNT-1:0]              cnt_chp;

//debug
reg [16-1:0]          cnt_rd_en;


//******************** Indicative signal ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_start_d0 <= 1'b0;
    i_start_d1 <= 1'b0;
  end
  else begin
    i_start_d0 <= i_start;
    i_start_d1 <= i_start_d0;
  end
end
assign start_p = i_start_d0 & ~i_start_d1; //posedge

always @(posedge clk or negedge rst_n) begin
  if(!rst_n)
    op_work <= 1'b0;
  else if (o_data_last)
    op_work <= 1'b0;
  else if(start_p == 1'b1)
    op_work <= 1'b1;
  else
    op_work <= op_work;
end

//********************  cnt  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_rd_en <= {16{1'b0}};
  end
  else if(op_work) begin
    if(s_data_last)
      cnt_rd_en <= {16{1'b0}};
    else if(o_m0_rd_en)
      cnt_rd_en <= cnt_rd_en + 1'b1;
    else
      cnt_rd_en <= cnt_rd_en;
  end
  else begin
    cnt_rd_en <= {16{1'b0}};
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_burst_len <= {`DATA_BURST_LEN_WIDTH{1'b0}};
  end
  else if(op_work) begin
    if(CSR_BURST_LEN == {`DATA_BURST_LEN_WIDTH{1'b0}})
      cnt_burst_len <= {`DATA_BURST_LEN_WIDTH{1'b0}};
    else if(cnt_burst_len == CSR_BURST_LEN -1)
      cnt_burst_len <= {`DATA_BURST_LEN_WIDTH{1'b0}};
    else
      cnt_burst_len <= cnt_burst_len + 1'b1;
  end
  else begin
    cnt_burst_len <= {`DATA_BURST_LEN_WIDTH{1'b0}};
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    pipeline_vld <= 1'b1;
  end
  else if(CSR_BURST_LEN == {`DATA_BURST_LEN_WIDTH{1'b0}})
    pipeline_vld <= 1'b1;
  else if(cnt_burst_len == CSR_BURST_LEN -1)
    pipeline_vld <= ~pipeline_vld;
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_smp <= {`SMP_CNT{1'b0}};
  end
  else if(cnt_smp == CSR_EST_SMP_CNT-1)
    cnt_smp <= {`SMP_CNT{1'b0}};
  else if(o_m0_rd_en)
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

//******************** output ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m0_rd_en <= 1'b0;
  end
  else begin
    if(cnt_chp == CSR_EST_CHP_CNT-1 && cnt_smp == CSR_EST_SMP_CNT-1)
      o_m0_rd_en <= 1'b0;
    else if(op_work && pipeline_vld)
      o_m0_rd_en <= 1'b1;
    else
      o_m0_rd_en <= 1'b0;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_m0_rd_addr <= CSR_RD_START_ADDR;
  end
  else begin
    if(cnt_chp == CSR_EST_CHP_CNT-1 && cnt_smp == CSR_EST_SMP_CNT-1)
      o_m0_rd_addr <= CSR_RD_START_ADDR;
    else if(o_m0_rd_en == 1'b1)
      o_m0_rd_addr <= o_m0_rd_addr + ADD_ADDR;
    else
      o_m0_rd_addr <= o_m0_rd_addr;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_data <= {READ_RAM_WIDTH{1'b0}};
  end
  else begin
    o_data <= i_m0_rd_data;
  end
end

delay #(DELAY_DATA_RSP_S1_PREP_CORE) delay_rd_en(.clk(clk), .rst_n(rst_n), .din(o_m0_rd_en), .dout(o_data_valid));

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    s_data_last <= 1'b0;
  end
  else begin
    if(cnt_chp == CSR_EST_CHP_CNT-1 && cnt_smp == CSR_EST_SMP_CNT-1-1)
      s_data_last <= 1'b1;
    else
      s_data_last <= 1'b0;
  end
end
delay #(DELAY_DATA_RSP_S1_PREP_CORE) delay_data_last(.clk(clk), .rst_n(rst_n), .din(s_data_last), .dout(o_data_last));

endmodule
