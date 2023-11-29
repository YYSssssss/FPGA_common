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
`include "rsp_s1_prep_define.svh"
`include "rsp_s1_prep_op_info.svh"
//synopsys translate_off
//`include "rsp_s1_comp_idle_assert.v"
//synopsys translate_on
module rsp_s1_prep #(
  parameter DELAY = 2
)(
  input                              rst_n,
  input                              clk,
  //CMD handshake
  input                              i_cmd_valid,
  input  cmd_info_t                  i_cmd_info,
  output reg                         o_cmd_ack,
  //Start handshake
  input                              i_start,
  input  start_info_t                i_start_info,
  output reg                         o_start_ack,
  //Finish handshake
  output reg                         o_finish,
  output finish_info_t               o_finish_info,
  input                              i_finish_ack,
  //Debug
  input                              i_init,
  input                              i_reset,
  input                              i_stop,
  input                              i_rerun,
  //AHB config
  ahb_if_cfg.slave                   ahb_cfg,
  input                              hclk,
  input                              hreset,
  //Memory request
  output reg                         o_mem_req,
  output [`RSP_S1_PREP_BANK_NUM-1:0]          o_mem_bm,
  input                              i_mem_ack,
  //RSP_S1_PREP input A
  input  [`RSP_S1_PREP_DATA_WIDTH-1:0]        i_m0_rd_data_A,
  output reg                         o_m0_rd_en_A,
  output reg [`RSP_S1_PREP_ADDR_WIDTH-1:0]    o_m0_rd_addr_A,
  //RSP_S1_PREP input B
  input  [`RSP_S1_PREP_DATA_WIDTH-1:0]        i_m0_rd_data_B,
  output reg                         o_m0_rd_en_B, 
  output reg [`RSP_S1_PREP_ADDR_WIDTH-1:0]    o_m0_rd_addr_B,
  //RSP_S1_PREP output A
  output reg [`RSP_S1_PREP_STRB_WIDTH-1:0]    o_m1_wea_A,
  output reg [`RSP_S1_PREP_DATA_WIDTH-1:0]    o_m1_wr_data_A,
  output reg                         o_m1_wr_en_A,
  output reg [`RSP_S1_PREP_ADDR_WIDTH-1:0]    o_m1_wr_addr_A,
  //RSP_S1_PREP output B
  output reg [`RSP_S1_PREP_STRB_WIDTH-1:0]    o_m1_wea_B,
  output reg [`RSP_S1_PREP_DATA_WIDTH-1:0]    o_m1_wr_data_B,
  output reg                         o_m1_wr_en_B, 
  output reg [`RSP_S1_PREP_ADDR_WIDTH-1:0]    o_m1_wr_addr_B, 

  output [15:0]                      o_event,
  output [3:0]                       o_irq
    );

//********************  localparam  ********************//
//triggers
localparam TRIG_WIDTH    = 4;

//state
localparam IDLE          = 6'b000000;
localparam WAIT_FOR_OP   = 6'b000001;
localparam WAIT_FOR_TRIG = 6'b000010;
localparam MEM_REQ       = 6'b000100;
localparam PE_PROC       = 6'b001000;
localparam MEM_REL       = 6'b010000;
localparam DONE_REQ      = 6'b100000;

//********************  reg & wire  ********************//
wire                    core_rst_n;
reg  [TRIG_WIDTH-1:0]   triggers;

//
reg  [32-1:0]           arg_ram[5-1:0];

//FSM
reg  [5:0]              state;
reg  [5:0]              next_state;
wire                    op_ready;

//
wire                    start;
wire                    s_finish;

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
assign core_rst_n    = rst_n;
assign op_ready      = 1;
//assign o_cmd_ack     = 0;
assign o_finish_info = 8'b0;
assign o_mem_bm      = 14'b0;
assign o_event       = 16'b0;
assign o_irq         = 4'b0;

assign o_m0_rd_en_B   = 1'b0;
assign o_m0_rd_addr_B = 18'b0;
assign o_m1_wea_B     = 16'b0;
assign o_m1_wr_data_B = 128'b0;
assign o_m1_wr_en_B   = 1'b0;
assign o_m1_wr_addr_B = 18'b0;

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

//********************  triggers  ********************//
// always @(posedge clk or negedge rst_n) begin
//   if (!rst_n) begin
//     triggers <= {TRIG_WIDTH{1'b0}};
//   end
//   else begin
//     if(start)
//       triggers <= {triggers[TRIG_WIDTH-1],1'b1};
//     else if(done)
//       triggers <= {1'b0,triggers[TRIG_WIDTH-1]};
//     else
//       triggers <= triggers;
//   end
// end

//********************  arg_ram  ********************//
always @(posedge hclk or posedge hreset) begin
  if (hreset) begin
    arg_ram[0] <= 32'b0;
    arg_ram[1] <= 32'b0;
    arg_ram[2] <= 32'b0;
    arg_ram[3] <= 32'b0;
    arg_ram[4] <= 32'b0;
  end
//  else if(ahb_if_cfg.slave.haddr == 'h0)
//    arg_ram[0] <= 1; // H:1  I:1  L:1  R:1  F:1  T:1  -:26
//  else if(haddr == 'h4)
//    arg_ram[1] <= 1; // DCINDX0:8  DADDR0:8  SCINDX0:8  SADDR0:8 
//  else if(haddr == 'h8)
//    arg_ram[2] <= 1; // USED_BANKS0:16  -:3  SSCNT0:13
//  else if(haddr == 'hc)
//    arg_ram[3] <= 1; // DCINDX1:8  DADDR1:8  SCINDX1:8  SADDR1:8 
//  else if(haddr == 'h10)
//    arg_ram[4] <= 1; // USED_BANKS1:16  -:3  SSCNT1:13
 else
   ;
end

//********************  state_machine  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    state <= 10'b0;
  end
  else begin
    state <= next_state;
  end
end

always @(*) begin
  case(state)
    IDLE : begin
        if(i_cmd_valid)
          next_state = WAIT_FOR_OP;
        else
          next_state = IDLE;
      end
    WAIT_FOR_OP : begin
        if(i_stop)
          next_state = DONE_REQ;
        else if(op_ready)
          next_state = WAIT_FOR_TRIG;
        else
          next_state = WAIT_FOR_OP;
      end
    WAIT_FOR_TRIG : begin
        if(i_stop)
          next_state = DONE_REQ;
        else if(i_start)
          next_state = MEM_REQ;
        else
          next_state = WAIT_FOR_TRIG;
      end
    MEM_REQ : begin
        if(i_mem_ack)
          next_state = PE_PROC;
        else
          next_state = MEM_REQ;
      end
    PE_PROC : begin
        if(s_finish || i_stop)
          next_state = MEM_REL;
        else 
          next_state = PE_PROC;
      end
    MEM_REL : begin
        if(!i_mem_ack)
          next_state = DONE_REQ;
        else
          next_state = MEM_REL;
      end
    DONE_REQ : begin
        if(i_finish_ack)
          next_state = IDLE;
        else
          next_state = DONE_REQ;
      end
    default : next_state = IDLE;
  endcase
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_mem_req   <= 0;
    o_finish    <= 0;
    o_start_ack <= 0;
    o_cmd_ack   <= 0;
    //start       <= 0;
  end
  else begin
    case(state)
      IDLE : begin
          o_mem_req <= 0;
          o_cmd_ack <= 1;
          o_start_ack <= 0;
        end
      WAIT_FOR_OP : begin
          o_cmd_ack <= 0;
        end
      WAIT_FOR_TRIG : begin
          o_start_ack <= (i_start==1'b1) ? 1'b1 : o_start_ack;
          o_mem_req <= 1'b1;
        end
      MEM_REQ : begin
          o_start_ack <= 1'b1;
          if(i_mem_ack)
            o_mem_req <= 1'b0;
          else 
            o_mem_req <= 1'b1;
        end
      PE_PROC : begin
        o_mem_req <= 0;
        o_start_ack <= 1'b0;
       // start <= 1;
        end
      MEM_REL : begin
          //start <= 0;
        end
      DONE_REQ : begin
          o_finish <= 1;
        end
      default : ;
    endcase
  end
end

assign start = o_mem_req & i_mem_ack;

//******************** ahb_bridge ********************//
rsp_s1_prep_ahbic u_rsp_s1_prep_ahbic(
  // Common AHB signals
  .HCLK          (hclk),
  .HRESETn       (~hreset),
  // System Address Remap control
  .REMAP         (4'b0),
  // Input port SI0 (inputs from master 0)
  .HSELS0        (HSELS0),
  .HADDRS0       (HADDRS0),
  .HTRANSS0      (HTRANSS0),
  .HWRITES0      (HWRITES0),
  .HSIZES0       (HSIZES0),
  .HBURSTS0      (HBURSTS0),
  .HPROTS0       (HPROTS0),
  .HMASTERS0     (HMASTERS0),
  .HWDATAS0      (HWDATAS0),
  .HMASTLOCKS0   (HMASTLOCKS0),
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
  .HRDATAM3      (HRDATAM3),
  .HREADYOUTM3   (HREADYOUTM3),
  .HRESPM3       (HRESPM3),
  // Scan test dummy signals; not connected until scan insertion
  .SCANENABLE    (SCANENABLE),   // Scan Test Mode Enable
  .SCANINHCLK    (SCANINHCLK),   // Scan Chain Input
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
  .SCANOUTHCLK   (SCANOUTHCLK)   // Scan Chain Output
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
ahb2en #(
  .SAW(32),
  .SDW(32),
  .DW(64)
) u_ahb2en1 (
  .rst_n     (rst_n),
  .clk       (clk),
  //AHB slave
  .shclken   (1'b1),
  .shaddr    (HADDRS_RAM0),
  .shburst   (HBURSTS_RAM0),
  .shprot    (),//(HPROTS_RAM0),
  .shready   (HREADYOUTS_RAM0),
  .shsize    (HSIZES_RAM0),
  .shtrans   (HTRANSS_RAM0),
  .shwdata   (HWDATAS_RAM0),
  .shwrite   (HWRITES_RAM0),
  .shrdata   (HRDATAS_RAM0),
  .shresp    (HRESPS_RAM0),
  //read, write
  .wr_en     (phase_ram0_wr_en),
  .wr_data   (phase_ram0_wr_data),
  .rd_en     (),
  .rd_vld    (phase_ram0_rd_vld),
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
ahb2en #(
  .SAW(32),
  .SDW(32),
  .DW(32)
) u_ahb2en2 (
  .rst_n     (rst_n),
  .clk       (clk),
  //AHB slave
  .shclken   (1'b1),
  .shaddr    (HADDRS_RAM1),
  .shburst   (HBURSTS_RAM1),
  .shprot    (HPROTS_RAM1),
  .shready   (HREADYOUTS_RAM1),
  .shsize    (HSIZES_RAM1),
  .shtrans   (HTRANSS_RAM1),
  .shwdata   (HWDATAS_RAM1),
  .shwrite   (HWRITES_RAM1),
  .shrdata   (HRDATAS_RAM1),
  .shresp    (HRESPS_RAM1),
  //read, write
  .wr_en     (phase_ram1_wr_en),
  .wr_data   (phase_ram1_wr_data),
  .rd_en     (),
  .rd_vld    (phase_ram1_rd_vld),
  .rd_data   (phase_ram1_rd_data)
);
//********************  CSR  ********************//
rsp_s1_prep_reg u_rsp_s1_prep_reg(
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

rsp_s1_prep_core #(
  .DELAY   (2)
) u_rsp_s1_prep_core(
  .rst_n                (core_rst_n),
  .hrst_n               (~hreset),
  .clk                  (clk),
  .hclk                 (hclk),
  .i_start              (start),
  .o_finish             (s_finish),

  //config
  .DATA_NUM                 (16'd1024),
  .RD_START_ADDR            (18'd0),
  .RD_END_ADDR              (18'd1024),
  .WR_START_ADDR            (18'd0),
  .WR_END_ADDR              (18'd1024),
  .i_is_real                (1'b0),
  .i_dc_est_cmp_cnt         (13'd511),
  .i_dc_est_chp_cnt         (10'd63),
  .i_dc_est_frm_cnt         (4'd0),
  .i_dc_est_scale           (17'd65536),
  .i_dc_config_mode         (4'h0),
  .i_intf_est_scale         (17'd80000),
  .i_intf_config_mode       (4'h0),
  .i_combination_config_mode(4'h0),
  .i_phase_entry_select     (6'h0),

  //DC_estimation
  // .i_dc_u                 ({16'd538,16'd538}),
  .i_dc_u                 ({16'd118,16'd420}),//complex
  .o_dc_u                 (),

  //INTF_estimation
  // .i_intf_cmp             (16'd657),
  .i_intf_cmp             (32'd512),//complex
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

  .i_data_formatter         (64'h0),

  .o_m1_wr_data          (o_m1_wr_data_A),
  .o_m1_wr_addr          (o_m1_wr_addr_A),
  .o_m1_wr_en            (o_m1_wr_en_A),
  .o_m1_wr_wea           (o_m1_wea_A),
  .i_m0_rd_data          (i_m0_rd_data_A),
  .o_m0_rd_addr          (o_m0_rd_addr_A),
  .o_m0_rd_en            (o_m0_rd_en_A)

  // .m_axi_rd             (axi_intf.master_rd),
  // .m_axi_wr             (axi_intf.master_wr)
 
);

endmodule