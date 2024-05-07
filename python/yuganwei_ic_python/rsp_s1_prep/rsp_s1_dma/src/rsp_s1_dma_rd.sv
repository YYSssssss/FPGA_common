//-----------------------------------------------------------------------------
// File: rsp_s1_dma_rd.sv
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: RSP Stage1 DMA read core with virtual channels
// Modification history:
// $Log$
//   Jichen 10/12/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

`include "rsp_s1_op_info.svh"
`include "s1_dma_defines.vh"

`timescale 1ns/1ps

module rsp_s1_dma_rd #(
  parameter N_CH = 1,
  parameter RD_DELAY = 4,
  parameter RSP_S1_OP_IDX_OPNAME = 0,
  parameter N_CH_LOG2 = $clog2(N_CH) == 0? 1: $clog2(N_CH)
)(
  input                                             rst_n,
  input                                             clk,
  //CMD handshake
  input                                             i_cmd_req, // CDC
  input  rsp_s1_cmd_info_t                          i_cmd_info, // CDC
  output                                            o_cmd_ack,
  //Start handshake
  input  [`RSP_S1_OP_NUM-1:0]                       i_start_req_op, // CDC
  input  rsp_s1_start_info_t [`RSP_S1_OP_NUM-1:0]   i_start_info_op, // CDC
  output                                            o_start_ack,

  //Finish handshake
//  output                                            o_done,
  //Finish handshake
  output                                            o_finish_req,
  output rsp_s1_finish_info_t                       o_finish_info,
  input  [`RSP_S1_OP_NUM-1:0]                       i_finish_ack_op, // CDC
  //Debug
  input                                             i_init,
  input                                             i_reset,
  input                                             i_stop,
  input                                             i_rerun,
  //AHB config
  ahb_if_cfg.slave                                  ahb_cfg,
  input                                             hclk,
  input                                             hreset,
  //Memory request
  output reg                                        o_mem_req,
  output [`L1_BANK_NUM-1:0]                         o_mem_bm,
  input                                             i_mem_ack,
  //L1 input A
  input  [`L1_DATA_WIDTH-1:0]                       i_m0_rd_data_A,
  output                                            o_m0_rd_en_A,
  output [`L1_ADDR_WIDTH-1:0]                       o_m0_rd_addr_A,
  //L1 input B
  input  [`L1_DATA_WIDTH-1:0]                       i_m0_rd_data_B,
  output reg                                        o_m0_rd_en_B, 
  output reg [`L1_ADDR_WIDTH-1:0]                   o_m0_rd_addr_B,
  //L1 output A
  output [`L1_STRB_WIDTH-1:0]                       o_m1_wea_A,
  output [`L1_DATA_WIDTH-1:0]                       o_m1_wr_data_A,
  output                                            o_m1_wr_en_A,
  output [`L1_ADDR_WIDTH-1:0]                       o_m1_wr_addr_A,
  //L1 output B
  output reg [`L1_STRB_WIDTH-1:0]                   o_m1_wea_B,
  output reg [`L1_DATA_WIDTH-1:0]                   o_m1_wr_data_B,
  output reg                                        o_m1_wr_en_B, 
  output reg [`L1_ADDR_WIDTH-1:0]                   o_m1_wr_addr_B, 

  // AXI read
  axi_v4_rd_if.master                               axi_rd,

  output [`RSP_EVENT_BITS-1:0]                      o_event,
  output [`RSP_IRQ_BITS-1:0]                        o_irq
);

localparam N_CH_AHB = 5;

/*autodef*/
    //Start of automatic define
    //Start of automatic reg
    //Define flip-flop registers here
    wire                        ch_enable_clr                   ;

//    reg                         ch_update_clr                   ;
    //Define combination registers here
    //End of automatic reg
    //Start of automatic wire
    //Define assign wires here
    wire [1:0][`L1_BANK_NUM-1:0]         cfg_mem_bm_pp;
    //Define instance wires here
    wire                        sw_trig_clr2ahb                 ;
    wire                        ch_enable2core                  ;
//    wire                        ch_update2core                  ;
    wire                        ch_enable_clr2ahb               ;
//    wire                        ch_update_clr2ahb               ;
    //WIRE_DEL: Wire ch_enable_clr has been deleted.
    //WIRE_DEL: Wire ch_update_clr has been deleted.
    //End of automatic wire
    //End of automatic define

////`ifdef FPGA_ILA
////
////wire   [127:0]                   ila_o_m1_wr_data_A /* synthesis syn_keep=1 */;   
////wire                             ila_o_m1_wr_en_A /* synthesis syn_keep=1 */; 
////wire   [17:0]                    ila_o_m1_wr_addr_A /* synthesis syn_keep=1 */;   
////
////assign                      ila_o_m1_wr_data_A  = o_m1_wr_data_A  ;   
////assign                      ila_o_m1_wr_en_A    = o_m1_wr_en_A    ; 
////assign                      ila_o_m1_wr_addr_A  = o_m1_wr_addr_A  ;   
////
////ina_dmar ina_rsp_s1_dmar_top(
////.clk            (clk),
////
////.probe0         (rst_n),         
////.probe1         (ila_o_m1_wr_data_A),//(HREADYS0),       
////.probe2         (ila_o_m1_wr_en_A  ),//(HSELS0),         
////.probe3         (ila_o_m1_wr_addr_A)//,//(ila_HADDRS0),          //[31:0]     
////)/* synthesis syn_noprune=1 */;             
////
////`endif


//  wire                                            o_done; //TODO  to  interrupt
//FSM software signals
wire                                                    sw_cmd_req;
wire                                                    sw_cmd_req_clr, sw_cmd_req_clr2ahb;
wire [`RSP_S1_OP_OP_ID_WIDTH-1:0]                       sw_cmd_info_op_id;
wire [`RSP_S1_OP_TTL_WIDTH-1:0]                         sw_cmd_info_ttl;
wire [`RSP_S1_OP_NUM-1:0]                               sw_cmd_info_trig_in;
wire [`RSP_S1_OP_NUM-1:0]                               sw_cmd_info_trig_out;
wire                                                    sw_start;
wire                                                    sw_start_clr, sw_start_clr2ahb;
wire                                                    sw_start_info_ping_pong;
wire  [`RSP_S1_OP_FRM_WIDTH-1:0]                        sw_start_info_frame_type_id;
wire                                                    sw_finish_req_mask;
wire                                                    sw_finish_ack;
wire                                                    sw_finish_ack_clr, sw_finish_ack_clr2ahb;
wire                                                    sw_mem_alloc;
wire                                                    sw_mem_alloc_clr, sw_mem_alloc_clr2ahb;
//FSM status signals
wire [`RSP_S1_OP_OP_ID_WIDTH-1:0]    op_id;
wire [`RSP_S1_OP_TTL_WIDTH-1:0]      ttl;
wire [`RSP_S1_OP_NUM-1:0]            cmd_trig_in;
wire [`RSP_S1_OP_NUM-1:0]            cmd_trig_out;
wire [`RSP_S1_OP_TTL_WIDTH-1:0]      ttl_counter;
wire [2:0]                           cs;
//FSM core signals
wire                                                    core_start;
wire                                                    core_finish;
//FSM start info
reg                                                     ping_pong_in;
wire [`RSP_S1_OP_FRM_WIDTH-1:0]                         frame_type_id;

wire                                                    o_ping_pong;

// Declear port signals
wire [`L1_STRB_WIDTH-1:0] m1_wr_wea;
wire [`L1_DATA_WIDTH-1:0] m1_wr_data;
wire m1_wr_en;
wire [`L1_ADDR_WIDTH-1:0] m1_wr_addr;
assign o_m0_rd_en_A   = 1'b0;
assign o_m0_rd_addr_A = {`L1_ADDR_WIDTH{1'b0}};


assign o_m1_wea_A     = m1_wr_wea;
assign o_m1_wr_data_A = m1_wr_data;
assign o_m1_wr_en_A   = m1_wr_en;
assign o_m1_wr_addr_A = m1_wr_addr;

//-------- For rsp_s1_comp, address B is unused. B signals tied 0 -------
always @(posedge clk or negedge rst_n)begin
  if (rst_n == 1'b0) begin
    o_m0_rd_en_B   <= 1'b0;
    o_m0_rd_addr_B <= {`L1_ADDR_WIDTH{1'b0}};

    o_m1_wea_B     <= {`L1_STRB_WIDTH{1'b0}};
    o_m1_wr_data_B <= {`L1_DATA_WIDTH{1'b0}};
    o_m1_wr_en_B   <= 1'b0;
    o_m1_wr_addr_B <= {`L1_ADDR_WIDTH{1'b0}};  
  end
  else begin
    o_m0_rd_en_B   <= 1'b0;
    o_m0_rd_addr_B <= {`L1_ADDR_WIDTH{1'b0}};

    o_m1_wea_B     <= {`L1_STRB_WIDTH{1'b0}};
    o_m1_wr_data_B <= {`L1_DATA_WIDTH{1'b0}};
    o_m1_wr_en_B   <= 1'b0;
    o_m1_wr_addr_B <= {`L1_ADDR_WIDTH{1'b0}};  
  end
end

//AHB IC signals
wire [N_CH_AHB-1:0]               ch_hsel;
wire [N_CH_AHB*2-1:0]             ch_htrans;
wire [N_CH_AHB*`AHB_AW-1:0]       ch_haddr;
wire [N_CH_AHB*3-1:0]             ch_hburst;
wire [N_CH_AHB*3-1:0]             ch_hsize;
wire [N_CH_AHB*`AHB_DW-1:0]       ch_hwdata;
wire [N_CH_AHB-1:0]               ch_hwrite;
wire [N_CH_AHB-1:0]               ch_hreadyin;
wire [N_CH_AHB*`AHB_DW-1:0]       ch_hrdata;
wire [N_CH_AHB*2-1:0]             ch_hresp;
wire [N_CH_AHB-1:0]               ch_hready;

// Select frame_type_id
wire [`L1_BASE_ADDR_WIDTH-1:0] ping_daddr     ;
wire [`L1_BASE_ADDR_WIDTH-1:0] ping_saddr     ;
wire [`L1_BANK_NUM-1:0]        ping_used_bank =0  ;

wire [`L1_BASE_ADDR_WIDTH-1:0] pong_daddr     ;
wire [`L1_BASE_ADDR_WIDTH-1:0] pong_saddr     ;
wire [`L1_BANK_NUM-1:0]        pong_used_bank =0 ;

wire core_done;
//reg  core_done_flag;

//wire  ch_update_pulse ; 
//reg   ch_update_d ;

reg cmd_ack_pre;
//reg finish_pre;
reg mem_req_pre;
reg start_ack_pre;

//wire           ch_update;
//wire           ch_update_clr_pls;
wire           ch_enable;
wire           ch_enable_clr_pls;

wire [`RSP_EVENT_BITS-1:0]           dma_rd_core_status;
wire [`S1_DMA_RD_IRQ_BITS-1:0]       dma_rd_core_irq;
wire [`S1_DMA_RD_IRQ_BITS-1:0]       irq_status, irq_status_lat_pls, irq_mask, irq_enable;

wire                                 o_mem_free_ack  ;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        ping_pong_in <= 1'b1;
    end
    else if(~|cs) begin   //sw_start_info_ping_pong
        ping_pong_in <= sw_start_info_ping_pong ;
    end
    else if (o_mem_free_ack) begin
        ping_pong_in <= ~ping_pong_in ;
    end
end

//always @(posedge clk or negedge rst_n)
//  if (!rst_n) begin
//    core_done_flag <= 1'b0;
//  end else if (core_done) begin
//    core_done_flag <= 1'b1;
//  end else if (finish_pre) begin
//    core_done_flag <= 1'b0;
//  end

//delay #(1) u_delay_done(.clk(clk), .rst_n(rst_n), .din(core_done_flag & finish_pre), .dout(o_done));

//assign cfg_mem_bm_pp[0] = ping_used_bank;
//assign cfg_mem_bm_pp[1] = pong_used_bank;

//----------- Rsp_op FSM instance -------------

rsp_s1_op_fsm #(
  .RSP_S1_OP_IDX_OPNAME(RSP_S1_OP_IDX_OPNAME)
) u_rsp_s1_op_fsm(
  .rst_n(rst_n),
  .clk(clk),
  //Config
  .cfg_mem_bm_pp(cfg_mem_bm_pp),
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
  .i_ping_pong(ping_pong_in),       
  .i_frame_type_id(sw_start_info_frame_type_id),           
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
  //Memory request
  .o_mem_req(o_mem_req),
  .o_mem_bm(o_mem_bm),
  .i_mem_ack(i_mem_ack), // CDC
  //Core signal
  .o_core_start(core_start),
  .i_core_finish(core_finish),
  //Start info
  .o_ping_pong(o_ping_pong),
  .o_frame_type_id(frame_type_id),
//free
  .o_mem_free_ack(o_mem_free_ack),
  //Status
  .o_op_id(op_id),
  .o_ttl(ttl),
  .o_cmd_trig_in(cmd_trig_in),
  .o_cmd_trig_out(cmd_trig_out),
  .o_cs(cs),
  .o_ttl_counter(ttl_counter)
);

s1_rsp_dma_rd_common #(
    .RSP_S1_OP_IDX_OPNAME      (RSP_S1_OP_IDX_OPNAME),
    .S1_DMA_BURST_ADDR_BITS(`S1_DMA_BURST_ADDR_BITS),
    .S1_DMA_BURST_FIDX_BITS(`S1_DMA_BURST_FIDX_BITS),
    .S1_DMA_BURST_SIDX_BITS(`S1_DMA_BURST_SIDX_BITS),
    .RD_DELAY                  (RD_DELAY)
) u_s1_rsp_dma_rd_common (/*autoinst*/
    .rst_n(rst_n),      
    .clk(clk),    
    .ahb_cfg(ahb_cfg),        
    .hclk(hclk),     
    .hreset(hreset),       
    .axi_rd(axi_rd),       
    .i_start(core_start),        
    .o_done(core_finish), // switch with core_done
    .o_finish(core_done),   // switch with core_finish
    .ping_pong(o_ping_pong),          
    .frame_type_id(sw_start_info_frame_type_id),              
    .outs_empty(),
    .rd_ch_en(1'b1),
    .o_wr_data(m1_wr_data),          
    .o_wr_en(m1_wr_en),        
    .o_wr_addr(m1_wr_addr),          
    .o_wr_wea(m1_wr_wea),         

    .cfg_mem_bm_pp (cfg_mem_bm_pp),

    .cmd0_op_id(op_id),
    .cmd0_ttl(ttl),
    .cmd0_ttl_counter(ttl_counter),
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
    .ping_pong_rd(3'b0),
    .o_event(o_event),        
    .o_irq(o_irq) 
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

// TBD
//assign o_event              = {`RSP_EVENT_BITS{1'b0}};
//assign o_irq                = {{(`RSP_IRQ_BITS-1){1'b0}},1'b0};
//assign o_finish_info.dest_op = {`RSP_S1_OP_OP_ID_WIDTH{1'b0}};
//assign o_finish_info.ping_pong = 1'b0;
//assign o_finish_info.frame_type_id = {`RSP_S1_OP_FRM_WIDTH{1'b0}};

endmodule
//Local Variables:
//verilog-library-directories (".")
//verilog-library-directories ("../src")
//verilog-library-directories ("../reg")
//verilog-library-directories-recursive:0 
//End:

