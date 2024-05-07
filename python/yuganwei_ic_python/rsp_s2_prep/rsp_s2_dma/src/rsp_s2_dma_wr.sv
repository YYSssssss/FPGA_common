//-----------------------------------------------------------------------------
// File: rsp_s2_dma_wr.sv
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: RSP Stage2 DMA read core with virtual channels
// Modification history:
// $Log$
//   Jichen 10/12/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

`include "rsp_s2_op_info.svh"
`include "rsp_s2_dma_defines.vh"

module rsp_s2_dma_wr #(
  parameter RSP_S2_OP_IDX_OPNAME = 0   
)(
  input                                                     clk,
  input                                                     rst_n,
  //CMD handshake
  input                                                     i_cmd_req, // CDC
  input  rsp_s2_cmd_info_t                                  i_cmd_info, // CDC
  output                                                    o_cmd_ack,
  //Start handshake
  input  [`RSP_S2_OP_NUM-1:0]                               i_start_req_op, // CDC
  input  rsp_s2_start_info_t [`RSP_S2_OP_NUM-1:0]           i_start_info_op, // CDC
  output                                                    o_start_ack,
  //Finish handshake
  output                                                    o_finish_req,
  output rsp_s2_finish_info_t                               o_finish_info,
  input  [`RSP_S2_OP_NUM-1:0]                               i_finish_ack_op, // CDC
  //Memory claim
  output                                                    o_mem_claim_req,
  output [$clog2(`L2_BANK_NUM)-1:0]                         o_mem_claim_idx,
  input                                                     i_mem_claim_ack, // CDC
  //Memory allocate
  output                                                    o_mem_rd_req,
  output [$clog2(`L2_BANK_NUM)-1:0]                         o_mem_idx_rd,
  input                                                     i_mem_rd_ack, // CDC
  output                                                    o_mem_wr_req,
  output [$clog2(`L2_BANK_NUM)-1:0]                         o_mem_idx_wr,
  input                                                     i_mem_wr_ack, // CDC
  //Memory free
  output                                                    o_mem_free_req,
  input                                                     i_mem_free_ack, // CDC
  //Debug
  input                                                     i_init,
  input                                                     i_reset,
  input                                                     i_stop,
  input                                                     i_rerun,
  //AHB config
  ahb_if_cfg.slave                                          ahb_cfg,
  input                                                     hclk,
  input                                                     hreset,
  // AXI read from local memory
  axi_v4_rd_if.master                                       axi_rd_lm,
  // AXI write to global memory
  axi_v4_wr_if.master                                       axi_wr_gm,
  //Events & IRQ
  output [`RSP_EVENT_BITS-1:0]                              o_event,
  output [`RSP_IRQ_BITS-1:0]                                o_irq
);
                  


//********************  localparam  ********************//
localparam N_CH = 5;
localparam RSP_S2_BASE_IDX_RD_NUM = 1; // support multiple read bank
localparam TRIG_FIFO_DEPTH = 8;

//FSM config signals
wire [RSP_S2_BASE_IDX_RD_NUM*$clog2(`L2_BANK_NUM)-1:0]  cfg_mem_base_idx_rd, cfg_mem_base_idx_rd_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [$clog2(`L2_BANK_NUM)-1:0]                         cfg_mem_base_idx_wr, cfg_mem_base_idx_wr_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`RSP_S2_OP_PING_PONG_WIDTH-1:0]                   cfg_mem_pipo_num_rd, cfg_mem_pipo_num_rd_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`RSP_S2_OP_PING_PONG_WIDTH-1:0]                   cfg_mem_pipo_num_wr, cfg_mem_pipo_num_wr_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire                                                    cfg_mem_claim, cfg_mem_claim_arr[0:`RSP_S2_OP_FRM_NUM-1];
//FSM software signals
wire                                                    sw_cmd_req;
wire                                                    sw_cmd_req_clr, sw_cmd_req_clr2ahb;
wire [`RSP_S2_OP_OP_ID_WIDTH-1:0]                       sw_cmd_info_op_id;
wire [`RSP_S2_OP_TTL_WIDTH-1:0]                         sw_cmd_info_ttl;
wire [`RSP_S2_OP_NUM-1:0]                               sw_cmd_info_trig_in;
wire [`RSP_S2_OP_NUM-1:0]                               sw_cmd_info_trig_out;
wire                                                    sw_start;
wire                                                    sw_start_clr, sw_start_clr2ahb;
wire  [`RSP_S2_OP_PING_PONG_WIDTH-1:0]                  sw_start_info_ping_pong;
wire  [`RSP_S2_OP_FRM_WIDTH-1:0]                        sw_start_info_frame_type_id;
wire                                                    sw_finish_req_mask;
wire                                                    sw_finish_ack;
wire                                                    sw_finish_ack_clr, sw_finish_ack_clr2ahb;
wire                                                    sw_mem_alloc;
wire                                                    sw_mem_alloc_clr, sw_mem_alloc_clr2ahb;
//FSM status signals
wire [$clog2(TRIG_FIFO_DEPTH):0]                        trig_word_counter;
wire [`RSP_S2_OP_OP_ID_WIDTH-1:0]                       op_id;
wire [`RSP_S2_OP_TTL_WIDTH-1:0]                         ttl;
wire [`RSP_S2_OP_NUM-1:0]                               cmd_trig_in;
wire [`RSP_S2_OP_NUM-1:0]                               cmd_trig_out;
wire [2:0]                                              trig_cs;
wire [3:0]                                              cs;
wire [`RSP_S2_OP_TTL_WIDTH-1:0]                         ttl_counter;
//FSM core signals
wire                                                    core_start;
wire                                                    core_finish;
//FSM start info
wire [`RSP_S2_OP_PING_PONG_WIDTH-1:0]                   ping_pong_wr, ping_pong_rd;
wire [`RSP_S2_OP_FRM_WIDTH-1:0]                         frame_type_id;

//AHB IC signals
wire [N_CH-1:0]                  ch_hsel;
wire [N_CH*2-1:0]                ch_htrans;
wire [N_CH*`AHB_AW-1:0]          ch_haddr;
wire [N_CH*3-1:0]                ch_hburst;
wire [N_CH*3-1:0]                ch_hsize;
wire [N_CH*`AHB_DW-1:0]          ch_hwdata;
wire [N_CH-1:0]                  ch_hwrite;
wire [N_CH-1:0]                  ch_hreadyin;
wire [N_CH*`AHB_DW-1:0]          ch_hrdata;
wire [N_CH*2-1:0]                ch_hresp;
wire [N_CH-1:0]                  ch_hready;


wire [`S2_DMA_SLEN_BITS-1:0]     cfg_gm_slen, cfg_gm_slen_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_SCNT_BITS-1:0]     cfg_gm_scnt, cfg_gm_scnt_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_FCNT_BITS-1:0]     cfg_gm_fcnt, cfg_gm_fcnt_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_PCNT_BITS-1:0]     cfg_gm_pcnt, cfg_gm_pcnt_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [7:0]                       cfg_gm_burst_len, cfg_gm_burst_len_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_GM_BASE_BITS-1:0]  cfg_gm_base_addr, cfg_gm_base_addr_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_GM_BASE_BITS-1:0]  cfg_gm_sidx, cfg_gm_sidx_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_GM_BASE_BITS-1:0]  cfg_gm_fidx, cfg_gm_fidx_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_OUT_BITS-1:0]      cfg_gm_outs_max, cfg_gm_outs_max_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_TIMEOUT_BITS-1:0]  cfg_gm_timeout_cnt, cfg_gm_timeout_cnt_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`RSP_AXI_ID_WIDTH-1:0]     cfg_gm_axi_id, cfg_gm_axi_id_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_SLEN_BITS-1:0]     cfg_lm_slen, cfg_lm_slen_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_SCNT_BITS-1:0]     cfg_lm_scnt, cfg_lm_scnt_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_FCNT_BITS-1:0]     cfg_lm_fcnt, cfg_lm_fcnt_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [7:0]                       cfg_lm_burst_len, cfg_lm_burst_len_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_LM_BASE_BITS-1:0]  cfg_lm_base_addr, cfg_lm_base_addr_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_LM_BASE_BITS-1:0]  cfg_lm_sidx, cfg_lm_sidx_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_LM_BASE_BITS-1:0]  cfg_lm_fidx, cfg_lm_fidx_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_OUT_BITS-1:0]      cfg_lm_outs_max, cfg_lm_outs_max_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`S2_DMA_TIMEOUT_BITS-1:0]  cfg_lm_timeout_cnt, cfg_lm_timeout_cnt_arr[0:`RSP_S2_OP_FRM_NUM-1];
wire [`RSP_AXI_ID_WIDTH-1:0]     cfg_lm_axi_id, cfg_lm_axi_id_arr[0:`RSP_S2_OP_FRM_NUM-1];

wire [`S2_DMA_LM_BASE_BITS-1:0]  cfg_lm_base_offset_addr;

//Status signals
wire [15:0]                      rc_update;
wire [15:0]                      rc_resume;
wire [15:0]                      wc_update;
wire [15:0]                      wc_resume;
//Event signals
wire                             rd_outs_timeout;
wire                             wr_outs_timeout;

//IRQ signals
wire [`RSP_IRQ_BITS-1:0]        irq_status, irq_status_lat_pls, irq_mask, irq_enable;

//FSM
rsp_s2_op_fsm #(
  .RSP_S2_OP_IDX_OPNAME(RSP_S2_OP_IDX_OPNAME),
  .RSP_S2_BASE_IDX_RD_NUM(RSP_S2_BASE_IDX_RD_NUM),
  .TRIG_FIFO_DEPTH(TRIG_FIFO_DEPTH)
) u_rsp_s2_op_fsm(
  .rst_n(rst_n),
  .clk(clk),
  //config
  .cfg_mem_base_idx_rd(cfg_mem_base_idx_rd),
  .cfg_mem_base_idx_wr(cfg_mem_base_idx_wr),
  .cfg_mem_pipo_num_rd(cfg_mem_pipo_num_rd),
  .cfg_mem_pipo_num_wr(cfg_mem_pipo_num_wr),
  .cfg_mem_claim(cfg_mem_claim),
  //Software control
  .sw_cmd_req(sw_cmd_req),
  .sw_cmd_req_clr(sw_cmd_req_clr),
  .sw_cmd_info_op_id(sw_cmd_info_op_id),
  .sw_cmd_info_ttl(sw_cmd_info_ttl),
  .sw_cmd_info_trig_in(sw_cmd_info_trig_in),
  .sw_cmd_info_trig_out(sw_cmd_info_trig_out),
  .sw_start(sw_start),
  .sw_start_clr(sw_start_clr),
  .sw_start_info_ping_pong(sw_start_info_ping_pong),
  .sw_start_info_frame_type_id(sw_start_info_frame_type_id),
  .sw_finish_req_mask(sw_finish_req_mask),
  .sw_finish_ack(sw_finish_ack),
  .sw_finish_ack_clr(sw_finish_ack_clr),
  .sw_mem_alloc(sw_mem_alloc),
  .sw_mem_alloc_clr(sw_mem_alloc_clr),
  //CMD handshake
  .i_cmd_req(i_cmd_req), // CDC
  .i_cmd_info(i_cmd_info), // CDC
  .o_cmd_ack(o_cmd_ack),
  //Start handshake
  .i_start_req_op(i_start_req_op), // CDC
  .i_start_info_op(i_start_info_op), // CDC
  .o_start_ack(o_start_ack),
  //Finish handshake
  .o_finish_req(o_finish_req),
  .o_finish_info(o_finish_info),
  .i_finish_ack_op(i_finish_ack_op), // CDC
  //Debug
  .i_init(i_init),
  .i_reset(i_reset),
  .i_stop(i_stop),
  .i_rerun(i_rerun),
  //Memory claim
  .o_mem_claim_req(o_mem_claim_req),
  .o_mem_claim_idx(o_mem_claim_idx),
  .i_mem_claim_ack(i_mem_claim_ack), // CDC
  //Memory allocate
  .o_mem_rd_req(o_mem_rd_req),
  .o_mem_idx_rd(o_mem_idx_rd),
  .i_mem_rd_ack(i_mem_rd_ack), // CDC
  .o_mem_wr_req(o_mem_wr_req),
  .o_mem_idx_wr(o_mem_idx_wr),
  .i_mem_wr_ack(i_mem_wr_ack), // CDC
  //Memory free
  .o_mem_free_req(o_mem_free_req),
  .i_mem_free_ack(i_mem_free_ack), // CDC
  //Core signal
  .o_core_start(core_start),
  .i_core_finish(core_finish),
  //Start info
  .o_ping_pong_wr(ping_pong_wr),
  .o_ping_pong_rd(ping_pong_rd),
  .o_frame_type_id(frame_type_id),
  //Status
  .o_trig_word_counter(trig_word_counter),
  .o_op_id(op_id),
  .o_ttl(ttl),
  .o_cmd_trig_in(cmd_trig_in),
  .o_cmd_trig_out(cmd_trig_out),
  .o_trig_cs(trig_cs),
  .o_cs(cs),
  .o_ttl_counter(ttl_counter),
  //Start info in (from 1st op)
  .i_ping_pong_rd(sw_start_info_ping_pong),
  .i_frame_type_id(sw_start_info_frame_type_id), 
  // finish ack
  .o_mem_free_ack()
);

assign cfg_mem_claim         = cfg_mem_claim_arr[frame_type_id];
assign cfg_mem_pipo_num_rd   = cfg_mem_pipo_num_rd_arr[frame_type_id];
assign cfg_mem_pipo_num_wr   = cfg_mem_pipo_num_wr_arr[frame_type_id];
assign cfg_mem_base_idx_wr   = cfg_mem_base_idx_wr_arr[frame_type_id];
assign cfg_mem_base_idx_rd   = cfg_mem_base_idx_rd_arr[frame_type_id];

assign cfg_gm_slen        =  cfg_gm_slen_arr[frame_type_id];
assign cfg_gm_scnt        =  cfg_gm_scnt_arr[frame_type_id];
assign cfg_gm_fcnt        =  cfg_gm_fcnt_arr[frame_type_id];
assign cfg_gm_pcnt        =  cfg_gm_pcnt_arr[frame_type_id];
assign cfg_gm_burst_len   =  cfg_gm_burst_len_arr[frame_type_id];
assign cfg_gm_base_addr   =  cfg_gm_base_addr_arr[frame_type_id];
assign cfg_gm_sidx        =  cfg_gm_sidx_arr[frame_type_id];
assign cfg_gm_fidx        =  cfg_gm_fidx_arr[frame_type_id];
assign cfg_gm_outs_max    =  cfg_gm_outs_max_arr[frame_type_id];
assign cfg_gm_timeout_cnt =  cfg_gm_timeout_cnt_arr[frame_type_id];
assign cfg_gm_axi_id      =  cfg_gm_axi_id_arr[frame_type_id];
assign cfg_lm_slen        =  cfg_lm_slen_arr[frame_type_id];
assign cfg_lm_scnt        =  cfg_lm_scnt_arr[frame_type_id];
assign cfg_lm_fcnt        =  cfg_lm_fcnt_arr[frame_type_id];
assign cfg_lm_burst_len   =  cfg_lm_burst_len_arr[frame_type_id];
assign cfg_lm_base_addr   =  cfg_lm_base_addr_arr[frame_type_id];
assign cfg_lm_sidx        =  cfg_lm_sidx_arr[frame_type_id];
assign cfg_lm_fidx        =  cfg_lm_fidx_arr[frame_type_id];
assign cfg_lm_outs_max    =  cfg_lm_outs_max_arr[frame_type_id];
assign cfg_lm_timeout_cnt =  cfg_lm_timeout_cnt_arr[frame_type_id];
assign cfg_lm_axi_id      =  cfg_lm_axi_id_arr[frame_type_id];

assign cfg_lm_base_offset_addr = cfg_lm_base_addr + (ping_pong_wr << `L2_BANK_ADDR_WIDTH);


//-----------------------------------AHB_MATRIX----------------------------------------
rsp_s2_dma_ahb_mux #(
  .N_CH(N_CH),
  .AHB_DW(`AHB_DW),
  .AHB_AW(`AHB_AW)
) u_rsp_s2_dma_ahb_mux(
  .hclk(hclk),
  .hreset(hreset),
                                         
  .hsel(ahb_cfg.hsel),
  .htrans(ahb_cfg.htrans),
  .haddr(ahb_cfg.haddr),
  .hburst(ahb_cfg.hburst),
  .hsize(ahb_cfg.hsize),
  .hwdata(ahb_cfg.hwdata),
  .hwrite(ahb_cfg.hwrite),
  .hreadyin(ahb_cfg.hreadyin),
  .hrdata(ahb_cfg.hrdata),
  .hresp(ahb_cfg.hresp),
  .hready(ahb_cfg.hready),
                                        
  .ch_hsel(ch_hsel),
  .ch_htrans(ch_htrans),
  .ch_haddr(ch_haddr),
  .ch_hburst(ch_hburst),
  .ch_hsize(ch_hsize),
  .ch_hwdata(ch_hwdata),
  .ch_hwrite(ch_hwrite),
  .ch_hreadyin(ch_hreadyin),
  .ch_hrdata(ch_hrdata),
  .ch_hresp(ch_hresp),
  .ch_hready(ch_hready)
);

//dma CSR
generate for (genvar i=0; i<`RSP_S2_OP_FRM_NUM; i=i+1) begin: inst_rsp_s2_dma_csr_reg
rsp_s2_dma_csr_reg u_rsp_s2_dma_csr_reg(
  .gm0_slen(cfg_gm_slen_arr[i]),
  .gm1_scnt(cfg_gm_scnt_arr[i]),
  .gm2_fcnt(cfg_gm_fcnt_arr[i]),
  .gm3_pcnt(cfg_gm_pcnt_arr[i]),
  .gm4_outs_max(cfg_gm_outs_max_arr[i]),
  .gm4_burst_len(cfg_gm_burst_len_arr[i]),
  .gm5_base_addr(cfg_gm_base_addr_arr[i]),
  .gm6_sidx(cfg_gm_sidx_arr[i]),
  .gm7_fidx(cfg_gm_fidx_arr[i]),
  .gm8_timeout_cnt(cfg_gm_timeout_cnt_arr[i]),
  .gm9_axi_id(cfg_gm_axi_id_arr[i]),
  .lm0_slen(cfg_lm_slen_arr[i]),
  .lm1_scnt(cfg_lm_scnt_arr[i]),
  .lm2_fcnt(cfg_lm_fcnt_arr[i]),
  .lm4_outs_max(cfg_lm_outs_max_arr[i]),
  .lm4_burst_len(cfg_lm_burst_len_arr[i]),
  .lm5_base_addr(cfg_lm_base_addr_arr[i]),
  .lm6_sidx(cfg_lm_sidx_arr[i]),
  .lm7_fidx(cfg_lm_fidx_arr[i]),
  .lm8_timeout_cnt(cfg_lm_timeout_cnt_arr[i]),
  .lm9_axi_id(cfg_lm_axi_id_arr[i]),

  .fsm_mem_claim                 (cfg_mem_claim_arr[i]),
  .fsm_mem_pipo_num_rd           (cfg_mem_pipo_num_rd_arr[i]),
  .fsm_mem_pipo_num_wr           (cfg_mem_pipo_num_wr_arr[i]),
  .fsm_mem_base_idx_wr           (cfg_mem_base_idx_wr_arr[i]),
  .fsm_mem_base_idx_rd           (cfg_mem_base_idx_rd_arr[i]),

  .hclk    (hclk),
  .hreset  (hreset),
  .hsel    (ch_hsel[i]),
  .htrans  (ch_htrans[i*2+:2]),
  .haddr   (ch_haddr[i*`AHB_AW+:`AHB_AW]),
  .hwdata  (ch_hwdata[i*`AHB_DW+:`AHB_DW]),
  .hwrite  (ch_hwrite[i]),
  .hrdata  (ch_hrdata[i*`AHB_DW+:`AHB_DW]),
  .hreadyin(ch_hreadyin[i]),
  .hresp   (ch_hresp[i*2+:2]),
  .hready  (ch_hready[i])
);
end
endgenerate

rsp_s2_dma_glb_reg u_rsp_s2_dma_glb_reg(
  .irq_status_pcnt_finish(irq_status[0]),
  .irq_status_pcnt_finish_lat_pls(irq_status_lat_pls[0]),
  .irq_mask_pcnt_finish(irq_mask[0]),
  .irq_enable_pcnt_finish(irq_enable[0]),

  .irq_status_fcnt_finish(irq_status[1]),
  .irq_status_fcnt_finish_lat_pls(irq_status_lat_pls[1]),
  .irq_mask_fcnt_finish(irq_mask[1]),
  .irq_enable_fcnt_finish(irq_enable[1]),

  .cmd0_trig_word_counter(trig_word_counter),
  .cmd0_op_id(op_id),
  .cmd0_ttl(ttl),
  .cmd0_trig_cs(trig_cs),
  .cmd0_cs(cs),
  .cmd1_trig_in(cmd_trig_in),
  .cmd2_trig_out(cmd_trig_out),

  .sw0_cmd_req(sw_cmd_req),
  .sw0_cmd_req_clr_pls(sw_cmd_req_clr2ahb),
  .sw0_cmd_op_id(sw_cmd_info_op_id),
  .sw0_cmd_ttl(sw_cmd_info_ttl),
  .sw1_cmd_trig_in(sw_cmd_info_trig_in),
  .sw2_cmd_trig_out(sw_cmd_info_trig_out),
  .sw3_start(sw_start),
  .sw3_start_clr_pls(sw_start_clr2ahb),
  .sw3_start_pipo(sw_start_info_ping_pong),
  .sw3_start_fid(sw_start_info_frame_type_id),
  .sw3_finish_req_mask(sw_finish_req_mask),
  .sw3_finish_ack(sw_finish_ack),
  .sw3_finish_ack_clr_pls(sw_finish_ack_clr2ahb),
  .sw3_mem_alloc(sw_mem_alloc),
  .sw3_mem_alloc_clr_pls(sw_mem_alloc_clr2ahb),

  .fidx_en_clr_pls(1'b0),

  .sts0_ttl_counter(ttl_counter),
  .sts1_rc_update(rc_update),
  .sts1_rc_resume(rc_resume),
  .sts2_wc_update(wc_update),
  .sts2_wc_resume(wc_resume),

  .hclk    (hclk),
  .hreset  (hreset),
  .hsel    (ch_hsel[4]),
  .htrans  (ch_htrans[4*2+:2]),
  .haddr   (ch_haddr[4*`AHB_AW+:`AHB_AW]),
  .hwdata  (ch_hwdata[4*`AHB_DW+:`AHB_DW]),
  .hwrite  (ch_hwrite[4]),
  .hrdata  (ch_hrdata[4*`AHB_DW+:`AHB_DW]),
  .hreadyin(ch_hreadyin[4]),
  .hresp   (ch_hresp[4*2+:2]),
  .hready  (ch_hready[4])
);


pulse_sync u_pulse_sync_sw_cmd_req_clr(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .pulse_a(sw_cmd_req_clr),
  .pulse_b(sw_cmd_req_clr2ahb)
  );

pulse_sync u_pulse_sync_sw_start_clr(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .pulse_a(sw_start_clr),
  .pulse_b(sw_start_clr2ahb)
  );

pulse_sync u_pulse_sync_sw_finish_ack_clr(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .pulse_a(sw_finish_ack_clr),
  .pulse_b(sw_finish_ack_clr2ahb)
  );

pulse_sync u_pulse_sync_sw_mem_alloc_clr(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .pulse_a(sw_mem_alloc_clr),
  .pulse_b(sw_mem_alloc_clr2ahb)
  );

rsp_irq u_rsp_irq0(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .irq_a_pls(pcnt_finish),
  .irq_b_status(irq_status[0]),
  .irq_b_mask(irq_mask[0]),
  .irq_b_enable(irq_enable[0]),
  .irq_b_status_pls(irq_status_lat_pls[0]),
  .irq_b_lat(o_irq[0])
);

rsp_irq u_rsp_irq1(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .irq_a_pls(ccnt_finish),
  .irq_b_status(irq_status[1]),
  .irq_b_mask(irq_mask[1]),
  .irq_b_enable(irq_enable[1]),
  .irq_b_status_pls(irq_status_lat_pls[1]),
  .irq_b_lat(o_irq[1])
);


assign core_finish = pcnt_finish | ccnt_finish;

rsp_s2_dma_wr_core u_rsp_s2_dma_wr_core(
  .rst_n(rst_n),
  .clk(clk),
  .i_start(core_start),
  .o_pcnt_finish(pcnt_finish),
  .o_ccnt_finish(ccnt_finish),
  //cfg
  .cfg_gm_slen(cfg_gm_slen),
  .cfg_gm_scnt(cfg_gm_scnt),
  .cfg_gm_fcnt(cfg_gm_fcnt),
  .cfg_gm_pcnt(cfg_gm_pcnt),
  .cfg_gm_burst_len(cfg_gm_burst_len),
  .cfg_gm_base_addr(cfg_gm_base_addr),
  .cfg_gm_sidx(cfg_gm_sidx),
  .cfg_gm_fidx(cfg_gm_fidx),
  .cfg_gm_outs_max(cfg_gm_outs_max),
  .cfg_gm_timeout_cnt(cfg_gm_timeout_cnt),
  .cfg_gm_axi_id(cfg_gm_axi_id),
  .cfg_lm_slen(cfg_lm_slen),
  .cfg_lm_scnt(cfg_lm_scnt),
  .cfg_lm_fcnt(cfg_lm_fcnt),
  .cfg_lm_burst_len(cfg_lm_burst_len),
  .cfg_lm_base_addr(cfg_lm_base_addr),
  .cfg_lm_sidx(cfg_lm_sidx),
  .cfg_lm_fidx(cfg_lm_fidx),
  .cfg_lm_outs_max(cfg_lm_outs_max),
  .cfg_lm_timeout_cnt(cfg_lm_timeout_cnt),
  .cfg_lm_axi_id(cfg_lm_axi_id),
  // Status
  .rc_update(rc_update),   
  .rc_resume(rc_resume),   
  .wc_update(wc_update),   
  .wc_resume(wc_resume),
  // Event
  .e_rd_outs_timeout(rd_outs_timeout),
  .e_wr_outs_timeout(wr_outs_timeout),

  .axi_rd_lm(axi_rd_lm),
  .axi_wr_gm(axi_wr_gm)
);

assign o_event[0] = rd_outs_timeout;
assign o_event[1] = wr_outs_timeout;
assign o_event[`RSP_EVENT_BITS-1:2] = {`RSP_EVENT_BITS-2{1'b0}};

assign o_irq[`RSP_IRQ_BITS-1:2] = {`RSP_IRQ_BITS-2{1'b0}};

endmodule
