//-----------------------------------------------------------------------------
// File: rsp_s2_dma_rd_core.sv
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: RSP Stage2 DMA read core
// Modification history:
// $Log$
//   Jichen 3/13/2024 original
// Version: 1.0
// Copyright (C) 2024 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

`include "rsp_s2_dma_defines.vh"

`timescale 1ns/1ps

module rsp_s2_dma_rd_core (
  input                                       rst_n,
  input                                       clk,
  input                                       i_start,
  output                                      o_pcnt_finish,
  output                                      o_ccnt_finish,
  input                                       i_fidx_en,
  input [7:0]                                 i_fidx_data,
  output                                      o_fidx_clr,
  //fidx
  //config
  input [`S2_DMA_SLEN_BITS-1:0]               cfg_gm_slen,
  input [`S2_DMA_SCNT_BITS-1:0]               cfg_gm_scnt,
  input [`S2_DMA_FCNT_BITS-1:0]               cfg_gm_fcnt,
  input [`S2_DMA_PCNT_BITS-1:0]               cfg_gm_pcnt,
  input [7:0]                                 cfg_gm_burst_len,
  input [`S2_DMA_GM_BASE_BITS-1:0]            cfg_gm_base_addr,
  input [`S2_DMA_GM_BASE_BITS-1:0]            cfg_gm_sidx,
  input [`S2_DMA_GM_BASE_BITS-1:0]            cfg_gm_fidx,
  input [`S2_DMA_OUT_BITS-1:0]                cfg_gm_outs_max,
  input [`S2_DMA_TIMEOUT_BITS-1:0]            cfg_gm_timeout_cnt,
  input [`RSP_AXI_ID_WIDTH-1:0]               cfg_gm_axi_id,
  input [`S2_DMA_SLEN_BITS-1:0]               cfg_lm_slen,
  input [`S2_DMA_SCNT_BITS-1:0]               cfg_lm_scnt,
  input [`S2_DMA_FCNT_BITS-1:0]               cfg_lm_fcnt,
  input [7:0]                                 cfg_lm_burst_len,
  input [`S2_DMA_LM_BASE_BITS-1:0]            cfg_lm_base_addr,
  input [`S2_DMA_LM_BASE_BITS-1:0]            cfg_lm_sidx,
  input [`S2_DMA_LM_BASE_BITS-1:0]            cfg_lm_fidx,
  input [`S2_DMA_OUT_BITS-1:0]                cfg_lm_outs_max,
  input [`S2_DMA_TIMEOUT_BITS-1:0]            cfg_lm_timeout_cnt,
  input [`RSP_AXI_ID_WIDTH-1:0]               cfg_lm_axi_id,
  input                                       cfg_index_en,
  input [`S2_DMA_LM_BASE_BITS-1:0]            cfg_index_addr,
  input                                       cfg_decomp_en,
  // Status
  output [15:0]                               rc_update,
  output [15:0]                               rc_resume,
  output [15:0]                               wc_update,
  output [15:0]                               wc_resume,
  // Event
  output                                      e_rd_outs_timeout,
  output                                      e_wr_outs_timeout,
  // AXI global memory
  axi_v4_rd_if.master                         axi_rd_gm,
  // AXI local memory
  axi_v4_wr_if.master                         axi_wr_lm
);

localparam DMA_GM_BUFF_DELAY = 1;
localparam DMA_GM_BUFF_EXT = (DMA_GM_BUFF_DELAY+3) + 1;

localparam FIDX_BITS = 8;
localparam RIDX_BITS = 16;
localparam ALEN_INFO = 4;

//rd signals
wire                               rd_update;
wire                               rd_resume;
wire                               rd_pcnt_finish;
wire                               rd_ccnt_finish;
wire                               rd_outs_timeout;
//read burst len fifo
wire                               arlen_fifo_pop;
wire                               arlen_fifo_empty;
wire [ALEN_INFO+7:0]               arlen_fifo_dout;
//read fifo
wire                               rfifo_pop;
wire [`L2_DATA_WIDTH-1:0]          rfifo_dout;
wire                               rfifo_empty;
//wr signals
wire                               wr_update;
wire                               wr_resume;
wire                               wr_pcnt_finish;
wire                               wr_ccnt_finish;
wire                               wr_outs_timeout;
//write burst len fifo
wire                               awlen_fifo_pop;
wire                               awlen_fifo_empty;
wire [ALEN_INFO+7:0]               awlen_fifo_dout;
//write fifo
wire                               wfifo_push;
wire [`L2_DATA_WIDTH-1:0]          wfifo_din;
wire                               wfifo_afull;

reg                                wait_ccnt_finish;

wire                               arvalid;
wire                               arready;
wire [7:0]                         arlen;
wire [`S2_DMA_GM_ADDR_BITS-1:0]    araddr;
wire                               rvalid;
wire                               rready;
wire                               rlast;
wire [`L2_DATA_WIDTH-1:0]          rdata;
wire [1:0]                         rresp;

wire                               awvalid;
wire                               awready;
wire [7:0]                         awlen;
wire [`S2_DMA_LM_ADDR_BITS-1:0]    awaddr;
wire                               wvalid;
wire                               wready;
wire [`L2_DATA_WIDTH-1:0]          wdata;
wire [`L2_STRB_WIDTH-1:0]          wstrb;
wire                               wlast;
wire                               bvalid;
wire                               bready;
wire [1:0]                         bresp;

assign axi_rd_gm.arid    = cfg_gm_axi_id;
assign axi_rd_gm.arsize  = $clog2(`L2_STRB_WIDTH);
assign axi_rd_gm.arprot  = 3'd0;
assign axi_rd_gm.arlock  = 1'b0;
assign axi_rd_gm.arcache = 4'd0;
assign axi_rd_gm.arburst = 2'd1;
assign axi_rd_gm.arvalid = arvalid;
assign axi_rd_gm.araddr  = araddr;
assign axi_rd_gm.arlen   = arlen;
assign axi_rd_gm.rready  = rready;
assign arready = axi_rd_gm.arready;
assign rvalid  = axi_rd_gm.rvalid;
assign rlast   = axi_rd_gm.rlast;
assign rdata   = axi_rd_gm.rdata;
assign rresp   = axi_rd_gm.rresp;

assign axi_wr_lm.awid    = cfg_lm_axi_id;
assign axi_wr_lm.awsize  = $clog2(`L2_STRB_WIDTH);
assign axi_wr_lm.awprot  = 3'd0;
assign axi_wr_lm.awlock  = 1'b0;
assign axi_wr_lm.awcache = 4'd0;
assign axi_wr_lm.awburst = 2'd1;
assign axi_wr_lm.awvalid = awvalid;
assign axi_wr_lm.awlen   = awlen;
assign axi_wr_lm.awaddr  = awaddr;
assign axi_wr_lm.wstrb   = wstrb;
assign axi_wr_lm.wvalid  = wvalid;
assign axi_wr_lm.wdata   = wdata;
assign axi_wr_lm.wlast   = wlast;
assign axi_wr_lm.bready  = bready;
assign awready = axi_wr_lm.awready;
assign wready  = axi_wr_lm.wready;
assign bvalid  = axi_wr_lm.bvalid;
assign bresp   = axi_wr_lm.bresp;

assign wfifo_din  = rfifo_dout;
assign wfifo_push = (~rfifo_empty & ~wfifo_afull);
assign rfifo_pop  = wfifo_push;

always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    wait_ccnt_finish <= 1'b0;
  end else if (rd_ccnt_finish) begin
    wait_ccnt_finish <= 1'b1;
  end else if (wr_ccnt_finish) begin
    wait_ccnt_finish <= 1'b0;
  end

assign o_pcnt_finish = ~wait_ccnt_finish & wr_ccnt_finish;
assign o_ccnt_finish = wait_ccnt_finish & wr_ccnt_finish;

/////////////////////////////////////////
/* DMA Read Channel*/
/////////////////////////////////////////
rsp_s2_dma_ctrl u_rsp_s2_dma_ctrl_rd (
  .clk               (clk),
  .rst_n             (rst_n),

  .start             (i_start),
  .pcnt_finish       (rd_pcnt_finish),
  .ccnt_finish       (rd_ccnt_finish),
  .update            (rd_update),
  .resume            (rd_resume)
  );

rsp_s2_dma_axi_alen #(
  .SLEN_BITS         (`S2_DMA_SLEN_BITS),
  .SCNT_BITS         (`S2_DMA_SCNT_BITS),
  .FCNT_BITS         (`S2_DMA_FCNT_BITS),
  .PCNT_BITS         (`S2_DMA_PCNT_BITS),
  .BASE_ADDR_BITS    (`S2_DMA_GM_BASE_BITS),
  .ADDR_BITS         (`S2_DMA_GM_ADDR_BITS),
  .SIDX_BITS         (`S2_DMA_GM_BASE_BITS),
  .FIDX_BITS         (`S2_DMA_GM_BASE_BITS),
  .STRB_WIDTH        (`L2_STRB_WIDTH)
) u_rsp_s2_dma_axi_arlen(
  .clk               (clk),
  .rst_n             (rst_n),
  .update            (rd_update),
  .resume            (rd_resume),
  //config
  .SLEN              (cfg_gm_slen),
  .SCNT              (cfg_gm_scnt),
  .FCNT              (cfg_gm_fcnt),
  .PCNT              (cfg_gm_pcnt),
  .BASE_ADDR         (cfg_gm_base_addr),
  .SIDX              (cfg_gm_sidx),
  .FIDX              (cfg_gm_fidx),
  .BUSRT_LEN         (cfg_gm_burst_len),
  //fifo
  .alen_fifo_pop     (arlen_fifo_pop),
  .alen_fifo_empty   (arlen_fifo_empty),
  .alen_fifo_dout    (arlen_fifo_dout)
);

rsp_s2_dma_axi_rd #(
  .BASE_ADDR_BITS    (`S2_DMA_GM_BASE_BITS),
  .ADDR_BITS         (`S2_DMA_GM_ADDR_BITS),
  .SIDX_BITS         (`S2_DMA_GM_BASE_BITS),
  .FIDX_BITS         (`S2_DMA_GM_BASE_BITS),
  .BUFF_DEPTH        (`S2_DMA_GM_BUFFER_DEPTH+DMA_GM_BUFF_EXT),
  .DATA_WIDTH        (`L2_DATA_WIDTH)
) u_rsp_s2_dma_axi_rd(
  .clk               (clk),
  .rst_n             (rst_n),
  .update            (rd_update),
  .resume            (rd_resume),
  .pcnt_finish       (rd_pcnt_finish),
  .ccnt_finish       (rd_ccnt_finish),
  .outs_timeout      (rd_outs_timeout),
  .rc_update         (rc_update),
  .rc_resume         (rc_resume),
  //config
  .BASE_ADDR         (cfg_gm_base_addr),
  .SIDX              (cfg_gm_sidx),
  .FIDX              (cfg_gm_fidx),
  .OUTS_MAX          (cfg_gm_outs_max),
  .TIMEOUT_CNT       (cfg_gm_timeout_cnt),
  //alen fifo
  .alen_fifo_pop     (arlen_fifo_pop),
  .alen_fifo_empty   (arlen_fifo_empty),
  .alen_fifo_dout    (arlen_fifo_dout),
  //data fifo
  .rfifo_pop         (rfifo_pop),
  .rfifo_empty       (rfifo_empty),
  .rfifo_dout        (rfifo_dout),
  //axi rd signals
  .arvalid           (arvalid),
  .arready           (arready),
  .arlen             (arlen),
  .araddr            (araddr),
  .rvalid            (rvalid),
  .rready            (rready),
  .rdata             (rdata),
  .rlast             (rlast)
);

/////////////////////////////////////////
/* DMA Write Channel*/
/////////////////////////////////////////
rsp_s2_dma_ctrl u_rsp_s2_dma_ctrl_wr (
  .clk               (clk),
  .rst_n             (rst_n),

  .start             (i_start),
  .pcnt_finish       (wr_pcnt_finish),
  .ccnt_finish       (wr_ccnt_finish),
  .update            (wr_update),
  .resume            (wr_resume)
  );

rsp_s2_dma_axi_alen #(
  .SLEN_BITS         (`S2_DMA_SLEN_BITS),
  .SCNT_BITS         (`S2_DMA_SCNT_BITS),
  .FCNT_BITS         (`S2_DMA_FCNT_BITS),
  .PCNT_BITS         (`S2_DMA_PCNT_BITS),
  .BASE_ADDR_BITS    (`S2_DMA_LM_BASE_BITS),
  .ADDR_BITS         (`S2_DMA_LM_ADDR_BITS),
  .SIDX_BITS         (`S2_DMA_LM_BASE_BITS),
  .FIDX_BITS         (`S2_DMA_LM_BASE_BITS),
  .STRB_WIDTH        (`L2_STRB_WIDTH)
) u_rsp_s2_dma_axi_awlen(
  .clk               (clk),
  .rst_n             (rst_n),
  .update            (wr_update),
  .resume            (wr_resume),
  //config
  .SLEN              (cfg_lm_slen),
  .SCNT              (cfg_lm_scnt),
  .FCNT              (cfg_lm_fcnt),
  .PCNT              ({`S2_DMA_PCNT_BITS{1'b1}}),
  .BASE_ADDR         (cfg_lm_base_addr),
  .SIDX              (cfg_lm_sidx),
  .FIDX              (cfg_lm_fidx),
  .BUSRT_LEN         (cfg_lm_burst_len),
  //fifo
  .alen_fifo_pop     (awlen_fifo_pop),
  .alen_fifo_empty   (awlen_fifo_empty),
  .alen_fifo_dout    (awlen_fifo_dout)
);

rsp_s2_dma_axi_wr #(
  .BASE_ADDR_BITS    (`S2_DMA_LM_BASE_BITS),
  .ADDR_BITS         (`S2_DMA_LM_ADDR_BITS),
  .SIDX_BITS         (`S2_DMA_LM_BASE_BITS),
  .FIDX_BITS         (`S2_DMA_LM_BASE_BITS),
  .BUFF_DEPTH        (`S2_DMA_LM_BUFFER_DEPTH),
  .DATA_WIDTH        (`L2_DATA_WIDTH)
) u_rsp_s2_dma_axi_wr(       
  .clk               (clk),
  .rst_n             (rst_n),
  .update            (wr_update),
  .resume            (wr_resume),
  .pcnt_finish       (wr_pcnt_finish),
  .ccnt_finish       (wr_ccnt_finish),
  .outs_timeout      (wr_outs_timeout),
  .wc_update         (wc_update),
  .wc_resume         (wc_resume),
  //fidx
  .i_fidx_en         (i_fidx_en),
  .i_fidx_data       (i_fidx_data),
  .o_fidx_clr        (o_fidx_clr),
  .i_fidx_update     (rd_update),
  //config
  .BASE_ADDR         (cfg_lm_base_addr),
  .SIDX              (cfg_lm_sidx),
  .FIDX              (cfg_lm_fidx),
  .OUTS_MAX          (cfg_lm_outs_max),
  .TIMEOUT_CNT       (cfg_lm_timeout_cnt),
  .INDEX_EN          (cfg_index_en),
  .INDEX_ADDR        (cfg_index_addr),
  //alen fifo
  .alen_fifo_pop     (awlen_fifo_pop),
  .alen_fifo_empty   (awlen_fifo_empty),
  .alen_fifo_dout    (awlen_fifo_dout),
  //data fifo
  .wfifo_push        (wfifo_push),
  .wfifo_din         (wfifo_din),
  .wfifo_afull       (wfifo_afull),
  //axi wr signals
  .awvalid           (awvalid),
  .awready           (awready),
  .awlen             (awlen),
  .awaddr            (awaddr),
  .wvalid            (wvalid),
  .wready            (wready),
  .wdata             (wdata),
  .wstrb             (wstrb),
  .wlast             (wlast),
  .bvalid            (bvalid),
  .bready            (bready)
);


// Events
assign e_rd_outs_timeout = rd_outs_timeout;
assign e_wr_outs_timeout = wr_outs_timeout;
//synopsys translate_off
always @(posedge clk) begin
  if (rd_outs_timeout) begin
    $display("[WARNINIG] rsp_s2_dma_rd_core: read standing time out.");
  end

  if (wr_outs_timeout) begin
    $display("[WARNINIG] rsp_s2_dma_rd_core: write standing time out.");
  end
end
//synopsys translate_on

// Interrupt



endmodule
