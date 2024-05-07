`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/10/04 16:08:08
// Design Name: 
// Module Name: chirp_processing_s2_wrapper
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

`include "rsp_s2_op_info.svh"

module rsp_s2_prep #(
    parameter  RSP_S2_OP_IDX_OPNAME = 0
)(
  input                                                     rst_n,
  input                                                     clk,
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
  //AXI interface
  axi_v4_if.master                                          axi_if,
  //Events & IRQ
  output [`RSP_EVENT_BITS-1:0]                              o_event,
  output [`RSP_IRQ_BITS-1:0]                                o_irq
);

//********************  localparam  ********************//
localparam DELAY = 2;

//********************  reg & wire  ********************//
//FSM config signals
wire [RSP_S2_BASE_IDX_RD_NUM*$clog2(`L2_BANK_NUM)-1:0]  cfg_mem_base_idx_rd;
wire [$clog2(`L2_BANK_NUM)-1:0]                         cfg_mem_base_idx_wr;
wire [`RSP_S2_OP_PING_PONG_WIDTH-1:0]                   cfg_mem_pipo_num_wr;
wire                                                    cfg_mem_claim;
//FSM software trigger signals
wire                                                    sw_trig;
wire                                                    sw_trig_clr, sw_trig_clr2ahb;
//FSM status signals
wire [$clog2(TRIG_FIFO_DEPTH):0]                        trig_word_counter;
//FSM core signals
wire                                                    core_start;
wire                                                    core_finish;
//FSM start info
wire [`RSP_S2_OP_PING_PONG_WIDTH-1:0]                   ping_pong;
wire [`RSP_S2_OP_FRM_WIDTH-1:0]                         frame_type_id;

//Status signals
wire [16-1:0]   prep_core_sts;
//IRQ signals
wire [4-1:0]        prep_core_irq, prep_core_irq2ahb;

//core
  //phase_gen: AHB to RAM
wire                            phase_ram0_wr_en;
wire [64-1:0]                   phase_ram0_wr_data;
wire                            phase_ram0_rd_vld;
wire [64-1:0]                   phase_ram0_rd_data;
wire [10:0]                     phase_ram0_addra;
wire                            phase_ram0_bwea;
wire                            phase_ram0_ena;
wire [64-1:0]                   phase_ram0_dina;
wire [64-1:0]                   phase_ram0_douta;
wire                            phase_ram0_wena;

wire                            phase_ram1_wr_en;
wire [31:0]                     phase_ram1_wr_data;
wire                            phase_ram1_rd_vld;
wire [31:0]                     phase_ram1_rd_data;
wire [5:0]                      phase_ram1_addra;
wire                            phase_ram1_bwea;
wire                            phase_ram1_ena;
wire [31:0]                     phase_ram1_dina;
wire [31:0]                     phase_ram1_douta;
wire                            phase_ram1_wena;

//AXI signals
axi_v4_rd_if #(.DATA_WIDTH(128),.ADDR_WIDTH(32),.ID_WIDTH(4)) m_axi_rd();
axi_v4_wr_if #(.DATA_WIDTH(128),.ADDR_WIDTH(32),.ID_WIDTH(4)) m_axi_wr();


// Input Port SI0
wire         HSELS0;          // Slave Select
wire  [31:0] HADDRS0;         // Address bus
wire   [1:0] HTRANSS0;        // Transfer type
wire         HWRITES0;        // Transfer direction
wire   [2:0] HSIZES0;         // Transfer size
wire   [2:0] HBURSTS0;        // Burst type
wire   [3:0] HPROTS0;         // Protection control
wire   [3:0] HMASTERS0;
wire  [31:0] HWDATAS0;        // Write data
wire         HMASTLOCKS0;     // Locked Sequence
wire         HREADYS0;        // Transfer done

wire  [31:0] HRDATAS0;        // Read data bus
wire         HREADYOUTS0;     // HREADY feedback
wire   [1:0] HRESPS0;         // Transfer response

// Output Port MI0
wire         HSELM0;          // Slave Select
wire  [31:0] HADDRM0;         // Address bus
wire   [1:0] HTRANSM0;        // Transfer type
wire         HWRITEM0;        // Transfer direction
wire   [2:0] HSIZEM0;         // Transfer size
wire   [2:0] HBURSTM0;        // Burst type
wire   [3:0] HPROTM0;         // Protection control
wire   [3:0] HMASTERM0;       // Master select
wire  [31:0] HWDATAM0;        // Write data
wire         HMASTLOCKM0;     // Locked Sequence
wire         HREADYMUXM0;     // Transfer done

wire  [31:0] HRDATAM0;        // Read data bus
wire         HREADYOUTM0;     // HREADY feedback
wire   [1:0] HRESPM0;         // Transfer response


// Output Port MI1
wire         HSELM1;          // Slave Select
wire  [31:0] HADDRM1;         // Address bus
wire   [1:0] HTRANSM1;        // Transfer type
wire         HWRITEM1;        // Transfer direction
wire   [2:0] HSIZEM1;         // Transfer size
wire   [2:0] HBURSTM1;        // Burst type
wire   [3:0] HPROTM1;         // Protection control
wire   [3:0] HMASTERM1;       // Master select
wire  [31:0] HWDATAM1;        // Write data
wire         HMASTLOCKM1;     // Locked Sequence
wire         HREADYMUXM1;     // Transfer done

wire  [31:0] HRDATAM1;        // Read data bus
wire         HREADYOUTM1;     // HREADY feedback
wire   [1:0] HRESPM1;         // Transfer response

// Output Port MI2
wire         HSELM2;          // Slave Select
wire  [31:0] HADDRM2;         // Address bus
wire   [1:0] HTRANSM2;        // Transfer type
wire         HWRITEM2;        // Transfer direction
wire   [2:0] HSIZEM2;         // Transfer size
wire   [2:0] HBURSTM2;        // Burst type
wire   [3:0] HPROTM2;         // Protection control
wire   [3:0] HMASTERM2;       // Master select
wire  [31:0] HWDATAM2;        // Write data
wire         HMASTLOCKM2;     // Locked Sequence
wire         HREADYMUXM2;     // Transfer done

wire  [31:0] HRDATAM2;        // Read data bus
wire         HREADYOUTM2;     // HREADY feedback
wire   [1:0] HRESPM2;         // Transfer response

// Output Port MI3
wire         HSELM3;          // Slave Select
wire  [31:0] HADDRM3;         // Address bus
wire   [1:0] HTRANSM3;        // Transfer type
wire         HWRITEM3;        // Transfer direction
wire   [2:0] HSIZEM3;         // Transfer size
wire   [2:0] HBURSTM3;        // Burst type
wire   [3:0] HPROTM3;         // Protection control
wire   [3:0] HMASTERM3;       // Master select
wire  [31:0] HWDATAM3;        // Write data
wire         HMASTLOCKM3;     // Locked Sequence
wire         HREADYMUXM3;     // Transfer done

wire  [31:0] HRDATAM3;        // Read data bus
wire         HREADYOUTM3;     // HREADY feedback
wire   [1:0] HRESPM3;         // Transfer response



wire         SCANOUTHCLK;     // Scan Chain Output
wire         SCANINHCLK;
wire         SCANENABLE;

// Output Port AHB Bridge Slave
wire         HSELS_RAM0;   
wire  [31:0] HADDRS_RAM0;      
wire   [1:0] HTRANSS_RAM0;     
wire         HWRITES_RAM0;     
wire   [2:0] HSIZES_RAM0;      
wire   [2:0] HBURSTS_RAM0;     
wire   [3:0] HPROTS_RAM0;      
wire  [31:0] HWDATAS_RAM0;     
wire         HMASTLOCKS_RAM0;  
wire         HREADYMUXS_RAM0;  

wire  [31:0] HRDATAS_RAM0;   
wire         HREADYOUTS_RAM0;
wire   [1:0] HRESPS_RAM0;

wire         HSELS_RAM1;   
wire  [31:0] HADDRS_RAM1;      
wire   [1:0] HTRANSS_RAM1;     
wire         HWRITES_RAM1;     
wire   [2:0] HSIZES_RAM1;      
wire   [2:0] HBURSTS_RAM1;     
wire   [3:0] HPROTS_RAM1;      
wire  [31:0] HWDATAS_RAM1;     
wire         HMASTLOCKS_RAM1;  
wire         HREADYMUXS_RAM1;  

wire  [31:0] HRDATAS_RAM1;   
wire         HREADYOUTS_RAM1;
wire   [1:0] HRESPS_RAM1;


//********************  assign  ********************//
assign o_event       = 16'b0;
assign o_irq         = 4'b0;

//AXI read cmd
assign axi_if.arvalid = m_axi_rd.arvalid;
assign axi_if.arid    = m_axi_rd.arid;
assign axi_if.araddr  = m_axi_rd.araddr;
assign axi_if.arlen   = m_axi_rd.arlen;
assign axi_if.arburst = m_axi_rd.arburst;
assign axi_if.arsize  = m_axi_rd.arsize;
assign axi_if.arcache = m_axi_rd.arcache;
assign axi_if.arprot  = m_axi_rd.arprot;
assign axi_if.arlock  = m_axi_rd.arlock;
assign m_axi_rd.arready = axi_if.arready;
//AXI read data
assign m_axi_rd.rvalid  = axi_if.rvalid;
assign m_axi_rd.rid     = axi_if.rid;
assign m_axi_rd.rdata   = axi_if.rdata;
assign m_axi_rd.rlast   = axi_if.rlast;
assign m_axi_rd.rresp   = axi_if.rresp;
assign axi_if.rready  = m_axi_rd.rready;
//AXI write cmd
assign axi_if.awvalid = m_axi_wr.awvalid;
assign axi_if.awid    = m_axi_wr.awid;
assign axi_if.awaddr  = m_axi_wr.awaddr;
assign axi_if.awlen   = m_axi_wr.awlen;
assign axi_if.awburst = m_axi_wr.awburst;
assign axi_if.awsize  = m_axi_wr.awsize;
assign axi_if.awcache = m_axi_wr.awcache;
assign axi_if.awprot  = m_axi_wr.awprot;
assign axi_if.awlock  = m_axi_wr.awlock;
assign m_axi_wr.awready = axi_if.awready;
//AXI write data
assign axi_if.wvalid  = m_axi_wr.wvalid;
assign axi_if.wdata   = m_axi_wr.wdata;
assign axi_if.wlast   = m_axi_wr.wlast;
assign axi_if.wstrb   = m_axi_wr.wstrb;
assign m_axi_wr.wready  = axi_if.wready;
//AXI write response
assign m_axi_wr.bvalid  = axi_if.bvalid;
assign m_axi_wr.bid     = axi_if.bid;
assign m_axi_wr.bresp   = axi_if.bresp;
assign axi_if.bready  = m_axi_wr.bready;

assign HREADYS0 = ahb_cfg.hreadyin;
assign HSELS0   = ahb_cfg.hsel;
assign HADDRS0  = ahb_cfg.haddr;
assign HTRANSS0 = ahb_cfg.htrans;
assign HWRITES0 = ahb_cfg.hwrite;
assign HSIZES0  = ahb_cfg.hsize;
assign HBURSTS0 = ahb_cfg.hburst;
assign HWDATAS0 = ahb_cfg.hwdata;
assign ahb_cfg.hrdata = HRDATAS0;
assign ahb_cfg.hready = HREADYOUTS0;
assign ahb_cfg.hresp  = HRESPS0;

//********************  state_machine  ********************//
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
  .cfg_mem_pipo_num_wr(cfg_mem_pipo_num_wr),
  .cfg_mem_claim(cfg_mem_claim),
  //Software trigger
  .sw_trig(sw_trig),
  .sw_trig_clr(sw_trig_clr),
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
  .o_ping_pong(ping_pong),
  .o_frame_type_id(frame_type_id),
  //Status
  .o_trig_word_counter(trig_word_counter)
);

pulse_sync u_pulse_sync_power_core_irq0(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .pulse_a(prep_core_irq[0]),
  .pulse_b(prep_core_irq2ahb[0])
  );

pulse_sync u_pulse_sync_sw_trig_clr(
  .clka(clk),
  .rst_n_a(rst_n),
  .clkb(hclk),
  .rst_n_b(~hreset),

  .pulse_a(sw_trig_clr),
  .pulse_b(sw_trig_clr2ahb)
  );

//******************** ahb_bridge ********************//
rsp_s2_prep_ahbic u_rsp_s2_prep_ahbic(
  // Common AHB signals
  .HCLK          (hclk),
  .HRESETn       (~hreset),
  // System Address Remap control
  .REMAP         (),
  // Input port SI0 (inputs from master 0)
  .HSELS0        (HSELS0),
  .HADDRS0       (HADDRS0),
  .HTRANSS0      (HTRANSS0),
  .HWRITES0      (HWRITES0),
  .HSIZES0       (HSIZES0),
  .HBURSTS0      (HBURSTS0),
  .HPROTS0       (4'b0),
  .HMASTERS0     (4'b0),
  .HWDATAS0      (HWDATAS0),
  .HMASTLOCKS0   (1'b0),
  .HREADYS0      (HREADYS0),
  // Output port MI0 (inputs from slave 0)
  .HRDATAM0      (HRDATAM0),
  .HREADYOUTM0   (HREADYOUTM0),
  .HRESPM0       (HRESPM0),
  // Output port MI1 (inputs from slave 1)
  .HRDATAM1      (HRDATAM1),
  .HREADYOUTM1   (HREADYOUTM1),
  .HRESPM1       (HRESPM1),
  // Output port MI2 (inputs from slave 2)
  .HRDATAM2      (HRDATAM2),
  .HREADYOUTM2   (HREADYOUTM2),
  .HRESPM2       (HRESPM2),
  // Output port MI3 (inputs from slave 1)
  .HRDATAM3      (32'b0),//(HRDATAM3),
  .HREADYOUTM3   (1'b0),//(HREADYOUTM3),
  .HRESPM3       (2'b0),//(HRESPM3),
  // Scan test dummy signals; not connected until scan insertion
  .SCANENABLE    (),   // Scan Test Mode Enable
  .SCANINHCLK    (),   // Scan Chain Input
  // Output port MI0 (outputs to slave 0)
  .HSELM0        (HSELM0),
  .HADDRM0       (HADDRM0),
  .HTRANSM0      (HTRANSM0),
  .HWRITEM0      (HWRITEM0),
  .HSIZEM0       (HSIZEM0),
  .HBURSTM0      (HBURSTM0),
  .HPROTM0       (HPROTM0),
  .HMASTERM0     (HMASTERM0),
  .HWDATAM0      (HWDATAM0),
  .HMASTLOCKM0   (HMASTLOCKM0),
  .HREADYMUXM0   (HREADYMUXM0),
  // Output port MI1 (outputs to slave 1)
  .HSELM1        (HSELM1),
  .HADDRM1       (HADDRM1),
  .HTRANSM1      (HTRANSM1),
  .HWRITEM1      (HWRITEM1),
  .HSIZEM1       (HSIZEM1),
  .HBURSTM1      (HBURSTM1),
  .HPROTM1       (HPROTM1),
  .HMASTERM1     (HMASTERM1),
  .HWDATAM1      (HWDATAM1),
  .HMASTLOCKM1   (HMASTLOCKM1),
  .HREADYMUXM1   (HREADYMUXM1),
  // Output port MI2 (outputs to slave 2)
  .HSELM2        (HSELM2),
  .HADDRM2       (HADDRM2),
  .HTRANSM2      (HTRANSM2),
  .HWRITEM2      (HWRITEM2),
  .HSIZEM2       (HSIZEM2),
  .HBURSTM2      (HBURSTM2),
  .HPROTM2       (HPROTM2),
  .HMASTERM2     (HMASTERM2),
  .HWDATAM2      (HWDATAM2),
  .HMASTLOCKM2   (HMASTLOCKM2),
  .HREADYMUXM2   (HREADYMUXM2),
  // Output port MI3 (outputs to slave 3)
  .HSELM3        (HSELM3),
  .HADDRM3       (HADDRM3),
  .HTRANSM3      (HTRANSM3),
  .HWRITEM3      (HWRITEM3),
  .HSIZEM3       (HSIZEM3),
  .HBURSTM3      (HBURSTM3),
  .HPROTM3       (HPROTM3),
  .HMASTERM3     (HMASTERM3),
  .HWDATAM3      (HWDATAM3),
  .HMASTLOCKM3   (HMASTLOCKM3),
  .HREADYMUXM3   (HREADYMUXM3),
  // Input port SI0 (outputs to master 0)
  .HRDATAS0      (HRDATAS0),
  .HREADYOUTS0   (HREADYOUTS0),
  .HRESPS0       (HRESPS0),
  // Scan test dummy signals; not connected until scan insertion
  .SCANOUTHCLK   ()   // Scan Chain Output
  );

ahb2ahb_async_DW_ahb_h2h #(
  .SAW(32),
  .SDW(32),
  .SBE(0),
  .MAW(32),
  .MDW(32),
  .MBE(0)
) u_ahb2ahb_async_DW_ahb_h2h_ram0 (
  // Outputs
  .shrdata(HRDATAM1), 
  .shready_resp(HREADYOUTM1), 
  .shresp(HRESPM1), 
  .shsplit(), 
  .mhaddr(HADDRS_RAM0), 
  .mhburst(HBURSTS_RAM0),
  .mhbusreq(), 
  .mhlock(HMASTLOCKS_RAM0), 
  .mhprot(HPROTS_RAM0), 
  .mhsize(HSIZES_RAM0), 
  .mhtrans(HTRANSS_RAM0), 
  .mhwdata(HWDATAS_RAM0), 
  .mhwrite(HWRITES_RAM0),
  .bus_id(),
  // Inputs  
  .shclk(hclk), 
  .shclken(1'b1), 
  .shresetn(~hreset), 
  .shaddr(HADDRM1), 
  .shburst(HBURSTM1), 
  .shmaster(4'b0), 
  .shmastlock(1'b1), 
  .shprot(4'b0), 
  .shready(HREADYMUXM1), 
  .shsel(HSELM1), 
  .shsize(HSIZEM1), 
  .shtrans(HTRANSM1), 
  .shwdata(HWDATAM1), 
  .shwrite(HWRITEM1),
  .mhclk(clk), 
  .mhclken(1'b1), 
  .mhresetn(rst_n), 
  .mhgrant(1'b1), 
  .mhrdata(HRDATAS_RAM0), 
  .mhready(HREADYOUTS_RAM0), 
  .mhresp(HRESPS_RAM0), 
  .mttick(1'b0), 
  //spyglass disable_block Topology_02
  //SMD: Found a direct connection from input port to output port
  //SJ: Connections are made as per the definition of the port 
  .sync_bypass(1'b0), 
  //spyglass enable_block Topology_02
  .shsel_id(1'b1)
);
ahb2fifo #(
  .SAW(32),
  .SDW(32),
  .DW(64)
) u_ahb2fifo0 (
  .rst_n     (rst_n),
  .clk       (clk),
  //AHB slave
  .shready   (HREADYOUTS_RAM0),
  .shtrans   (HTRANSS_RAM0),
  .shwdata   (HWDATAS_RAM0),
  .shwrite   (HWRITES_RAM0),
  .shrdata   (HRDATAS_RAM0),
  .shresp    (HRESPS_RAM0),
  //read, write
  .wr_en     (phase_ram0_wr_en),
  .wr_data   (phase_ram0_wr_data),
  .rd_en     (),
  .rd_vld    (1'b0),
  .rd_data   (phase_ram0_rd_data)
);




ahb2ahb_async_DW_ahb_h2h #(
  .SAW(32),
  .SDW(32),
  .SBE(0),
  .MAW(32),
  .MDW(32),
  .MBE(0)
) u_ahb2ahb_async_DW_ahb_h2h_ram1 (
  // Outputs
  .shrdata(HRDATAM2), 
  .shready_resp(HREADYOUTM2), 
  .shresp  (HRESPM2), 
  .shsplit (), 
  .mhaddr  (),//(HADDRS_RAM1), 
  .mhburst (HBURSTS_RAM1),
  .mhbusreq(), 
  .mhlock(HMASTLOCKS_RAM1), 
  .mhprot(HPROTS_RAM1), 
  .mhsize(HSIZES_RAM1), 
  .mhtrans(HTRANSS_RAM1), 
  .mhwdata(HWDATAS_RAM1), 
  .mhwrite(HWRITES_RAM1),
  .bus_id(),
  // Inputs  
  .shclk(hclk), 
  .shclken(1'b1), 
  .shresetn(rst_n), 
  .shaddr(HADDRM2), 
  .shburst(HBURSTM2), 
  .shmaster(4'b0), 
  .shmastlock(1'b0), 
  .shprot(4'b0), 
  .shready(HREADYMUXM2), 
  .shsel(HSELM2), 
  .shsize(HSIZEM2), 
  .shtrans(HTRANSM2), 
  .shwdata(HWDATAM2), 
  .shwrite(HWRITEM2),
  .mhclk(clk), 
  .mhclken(1'b1), 
  .mhresetn(rst_n), 
  .mhgrant(1'b1), 
  .mhrdata(HRDATAS_RAM1), 
  .mhready(HREADYOUTS_RAM1), 
  .mhresp(HRESPS_RAM1), 
  .mttick(1'b0), 
  //spyglass disable_block Topology_02
  //SMD: Found a direct connection from input port to output port
  //SJ: Connections are made as per the definition of the port 
  .sync_bypass(1'b0), 
  //spyglass enable_block Topology_02
  .shsel_id(1'b1)
);
ahb2fifo #(
  .SAW(32),
  .SDW(32),
  .DW(32)
) u_ahb2fifo1 (
  .rst_n     (rst_n),
  .clk       (clk),
  //AHB slave
  .shready   (HREADYOUTS_RAM1),
  .shtrans   (HTRANSS_RAM1),
  .shwdata   (HWDATAS_RAM1),
  .shwrite   (HWRITES_RAM1),
  .shrdata   (HRDATAS_RAM1),
  .shresp    (HRESPS_RAM1),
  //read, write
  .wr_en     (phase_ram1_wr_en),
  .wr_data   (phase_ram1_wr_data),
  .rd_en     (),
  .rd_vld    (1'b0),
  .rd_data   (phase_ram1_rd_data)
);
//******************** CSR ********************//
rsp_s2_prep_regmap u_rsp_s2_prep_regmap(
    .i_dc_est_cmp_cnt_i_dc_est_cmp_cnt                    (),
    .i_dc_est_chp_cnt_i_dc_est_chp_cnt                    (),
    .i_dc_est_frm_cnt_i_dc_est_frm_cnt                    (),
    .i_dc_est_scale_i_dc_est_scale                        (),
    .i_dc_config_mode_i_dc_config_mode                    (),
    .i_dc_u_i_dc_u                                        (), 
    .o_dc_u_o_dc_u                                        (),
    .i_intf_est_scale_i_intf_est_scale                    (),
    .i_intf_config_mode_i_intf_config_mode                (),
    .i_intf_cmp_i_intf_cmp                                (),
    .o_intf_cmp_o_intf_cmp                                (),
    .i_combination_config_mode_i_combination_config_mode  (),
    .i_phase_config_mode_i_phase_config_mode              (),
    .i_phase_w_i_phase_w                                  (), 
    .i_phase_coe_i_phase_coe                              (), 
    .i_data_formatter_i_data_formatter                    (), 
    .i_frame_num_format_i_frame_num_format                (), 
    .s1_prep_debug_0_s1_prep_debug_0                      (), 
    .s1_prep_debug_1_s1_prep_debug_1                      (),   
    .s1_prep_debug_2_s1_prep_debug_2                      (), 
    .s1_prep_debug_3_s1_prep_debug_3                      (),   
    .s1_prep_debug_4_s1_prep_debug_4                      (),       
    .s1_prep_debug_5_s1_prep_debug_5                      (),    
    .s1_prep_debug_6_s1_prep_debug_6                      (),  
    .s1_prep_debug_7_s1_prep_debug_7                      (), 
    .s1_prep_debug_8_s1_prep_debug_8                      (),  
    .s1_prep_debug_9_s1_prep_debug_9                      (),  
    .s1_prep_debug_10_s1_prep_debug_10                    (), 
    .s1_prep_debug_11_s1_prep_debug_11                    (), 
    .s1_prep_debug_12_s1_prep_debug_12                    (), 
    .s1_prep_debug_13_s1_prep_debug_13                    (), 
    .s1_prep_debug_14_s1_prep_debug_14                    (), 
    .s1_prep_debug_15_s1_prep_debug_15                    (), 
    .s1_prep_debug_16_s1_prep_debug_16                    (),  
    .last_register_last_register                          (32'h6666),   

    .hclk(hclk),
    .hreset(hreset),
    .hsel(HSELM0),
    .htrans(HTRANSM0),
    .haddr(HADDRM0),
    .hwdata(HWDATAM0),
    .hwrite(HWRITEM0),
    .hrdata(HRDATAM0),
    .hreadyin(HREADYMUXM0),
    .hresp(HRESPM0),
    .hready(HREADYOUTM0)
);

//******************** PE ********************//
 rsp_s2_prep_core #(
   .DELAY   (DELAY)
 ) u_rsp_s2_prep_core(
  .rst_n                (rst_n),
  .hrst_n               (~hreset),
  .clk                  (clk),
  .hclk                 (hclk),
  .i_start              (core_start),
  .o_finish             (core_finish),

  //config
  //.DATA_NUM                 (16'd1024),
  //.RD_START_ADDR            (18'd0),
  //.RD_END_ADDR              (18'd16384),
  //.WR_START_ADDR            (18'd0),
  //.WR_END_ADDR              (18'd16384),
  .i_phase_entry_select     (6'h10),
  .i_sel_16_32              (1'b1),
  // .i_sel_16_32              (1'b0),
  // .i_is_real                (1'b1),
  .i_is_real                (1'b0),
  .i_dc_est_cmp_cnt         (13'd511),
  .i_dc_est_chp_cnt         (10'd63),
  .i_dc_est_frm_cnt         (4'd0),
  .i_dc_est_scale           (17'd65536),
  .i_dc_config_mode         (4'd0),
  .i_intf_est_scale         (17'd80000),
  .i_intf_config_mode       (4'd0),
  .i_combination_config_mode(4'd0),

  //DC_estimation
  // .i_dc_u                 ({32'd0,16'd538,16'd538}),
  // .i_dc_u                 ({32'd0,16'd118,16'd420}),//complex
  .i_dc_u                 ({32'd118,32'd420}),//complex
  .o_dc_u                 (),

  //INTF_estimation
  // .i_intf_cmp             (16'd657),
  // .i_intf_cmp             (64'd1700000000),//complex
  .i_intf_cmp             ({64'd1700000000}),//complex
  .o_intf_cmp             (),


  .i_phase_w                (64'h02000200),
  .i_phase_coe              (64'h0),
  .i_phase_ram0_addra       (phase_ram0_addra),
  .i_phase_ram0_bwea        (phase_ram0_bwea),
  .i_phase_ram0_ena         (phase_ram0_wr_en),
  .i_phase_ram0_dina        (phase_ram0_wr_data),
  .o_phase_ram0_douta       (phase_ram0_rd_data),
  .i_phase_ram0_wena        (phase_ram0_wr_en),

  .i_phase_ram1_addra       (phase_ram1_addra),
  .i_phase_ram1_bwea        (phase_ram1_bwea),
  .i_phase_ram1_ena         (phase_ram1_wr_en ),
  .i_phase_ram1_dina        (phase_ram1_wr_data),
  .o_phase_ram1_douta       (phase_ram1_rd_data),
  .i_phase_ram1_wena        (phase_ram1_wr_en),

   //o_m1_wr_data          (),
   //o_m1_wr_addr          (),
   //o_m1_wr_en            (),
   //o_m1_wr_wea           (),
   //i_m0_rd_data          (),
   //o_m0_rd_addr          (),
   //o_m0_rd_en            (),

   .m_axi_rd             (m_axi_rd),
   .m_axi_wr             (m_axi_wr)
   
 );

endmodule
