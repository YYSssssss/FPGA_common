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
`include "rsp_common_defines.vh"
`include "rsp_s1_prep_defines.vh"
`include "rsp_s1_op_info.svh"

`timescale 1ns / 1ps

module rsp_s1_prep #(
  parameter RSP_S1_OP_IDX_OPNAME = 0
)(
  // Global signals
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
  output                                            o_finish_req,
  output rsp_s1_finish_info_t                       o_finish_info,
  input  [`RSP_S1_OP_NUM-1:0]                       i_finish_ack_op, // CDC
  //Debug
  input                                             i_init,
  input                                             i_reset,
  input                                             i_stop,
  input                                             i_rerun,
  //Memory request
  output                                            o_mem_req,
  output [`L1_BANK_NUM-1:0]                         o_mem_bm,
  input                                             i_mem_ack, // CDC
  //AHB config
  ahb_if_cfg.slave                                  ahb_cfg,
  input                                             hclk,
  input                                             hreset,
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

  output [`RSP_EVENT_BITS-1:0]                      o_event,
  output [`RSP_IRQ_BITS-1:0]                        o_irq
);

//********************  localparam  ********************//


//********************  reg & wire  ********************//
//AHB IC signals
wire [`N_CH-1:0]                      ch_hsel;
wire [`N_CH*2-1:0]                    ch_htrans;
wire [`N_CH*`AHB_AW-1:0]              ch_haddr;
wire [`N_CH*3-1:0]                    ch_hburst;
wire [`N_CH*3-1:0]                    ch_hsize;
wire [`N_CH*`AHB_DW-1:0]              ch_hwdata;
wire [`N_CH-1:0]                      ch_hwrite;
wire [`N_CH-1:0]                      ch_hreadyin;
wire [`N_CH*`AHB_DW-1:0]              ch_hrdata;
wire [`N_CH*2-1:0]                    ch_hresp;
wire [`N_CH-1:0]                      ch_hready;

//FSM config signals
wire [1:0][`L1_BANK_NUM-1:0]         cfg_mem_bm_pp;
//FSM software signals
wire                                 sw_cmd_req;
wire                                 sw_cmd_req_clr, sw_cmd_req_clr2ahb;
wire [`RSP_S1_OP_OP_ID_WIDTH-1:0]    sw_cmd_info_op_id;
wire [`RSP_S1_OP_TTL_WIDTH-1:0]      sw_cmd_info_ttl;
wire [`RSP_S1_OP_NUM-1:0]            sw_cmd_info_trig_in;
wire [`RSP_S1_OP_NUM-1:0]            sw_cmd_info_trig_out;
wire                                 sw_start;
wire                                 sw_start_clr, sw_start_clr2ahb;
wire                                 sw_start_info_ping_pong;
wire [`RSP_S1_OP_FRM_WIDTH-1:0]      sw_start_info_frame_type_id;
wire                                 sw_finish_req_mask;
wire                                 sw_finish_ack;
wire                                 sw_finish_ack_clr, sw_finish_ack_clr2ahb;
wire                                 sw_mem_alloc;
wire                                 sw_mem_alloc_clr, sw_mem_alloc_clr2ahb;
//FSM status signals
wire [`RSP_S1_OP_OP_ID_WIDTH-1:0]    op_id;
wire [`RSP_S1_OP_TTL_WIDTH-1:0]      ttl;
wire [`RSP_S1_OP_NUM-1:0]            cmd_trig_in;
wire [`RSP_S1_OP_NUM-1:0]            cmd_trig_out;
wire [`RSP_S1_OP_TTL_WIDTH-1:0]      ttl_counter;
wire [2:0]                           cs;
//FSM core signals  
wire                                 core_start;
wire                                 core_finish;
//FSM start info signals  
wire                                 ping_pong;
wire [`RSP_S1_OP_FRM_WIDTH-1:0]      frame_type_id;

//config signals
wire                                 change_cfg;

// Status signals

// IRQ signals
wire [`RSP_IRQ_BITS-1:0]      prep_core_irq;
wire [`RSP_IRQ_BITS-1:0]      irq_status, irq_status_lat_pls, irq_mask, irq_enable;


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



//--------- Core to FSM -----------

wire prep_r;
wire prep_i;
wire prep_l;
wire prep_h;
wire prep_f;
wire prep_t;

wire [`L1_BASE_ADDR_WIDTH-1:0] dcindx    ;
wire [`L1_BASE_ADDR_WIDTH-1:0] scindx    ;
wire [12:0]                    sscnt     ;
wire                           channel_num;

wire [`L1_BASE_ADDR_WIDTH-1:0] ping_daddr_arr[0:`RSP_S1_OP_FRM_NUM-1]     ;
wire [`L1_BASE_ADDR_WIDTH-1:0] ping_saddr_arr[0:`RSP_S1_OP_FRM_NUM-1]     ;
wire [`L1_BANK_NUM-1:0]        ping_used_bank_arr[0:`RSP_S1_OP_FRM_NUM-1] ;

wire [`L1_BASE_ADDR_WIDTH-1:0] pong_daddr_arr[0:`RSP_S1_OP_FRM_NUM-1]     ;
wire [`L1_BASE_ADDR_WIDTH-1:0] pong_saddr_arr[0:`RSP_S1_OP_FRM_NUM-1]     ;
wire [`L1_BANK_NUM-1:0]        pong_used_bank_arr[0:`RSP_S1_OP_FRM_NUM-1] ;


// Select frame_type_id
wire [`L1_BASE_ADDR_WIDTH-1:0] ping_daddr     ;
wire [`L1_BASE_ADDR_WIDTH-1:0] ping_saddr     ;
wire [`L1_BANK_NUM-1:0]        ping_used_bank ;

wire [`L1_BASE_ADDR_WIDTH-1:0] pong_daddr     ;
wire [`L1_BASE_ADDR_WIDTH-1:0] pong_saddr     ;
wire [`L1_BANK_NUM-1:0]        pong_used_bank ;

assign ping_daddr     = ping_daddr_arr[frame_type_id];
assign ping_saddr     = ping_saddr_arr[frame_type_id];
assign ping_used_bank = ping_used_bank_arr[frame_type_id];

assign pong_daddr     = pong_daddr_arr[frame_type_id];
assign pong_saddr     = pong_saddr_arr[frame_type_id];
assign pong_used_bank = pong_used_bank_arr[frame_type_id];


// Configuration signals to core, select ping_pong
wire [`L1_BASE_ADDR_WIDTH-1:0] core_daddr     ;// Destination base address
wire [`L1_BASE_ADDR_WIDTH-1:0] core_saddr     ;// Source base address

assign core_daddr     = (ping_pong == 1'b0)? ping_daddr: pong_daddr;
assign core_saddr     = (ping_pong == 1'b0)? ping_saddr: pong_daddr;

assign cfg_mem_bm_pp[0] = ping_used_bank;
assign cfg_mem_bm_pp[1] = pong_used_bank;

//core
  //phase_gen: AHB to RAM
wire                            wr_en_tw  ;
wire [`TWIDDLE_WIDTH-1:0]       wr_data_tw;
wire                            rd_vld_tw ;
wire [`TWIDDLE_WIDTH-1:0]       rd_data_tw;
wire [10:0]                     addra_tw  ;
wire                            bwea_tw   ;
wire                            ena_tw    ;
wire [64-1:0]                   dina_tw   ;
wire [64-1:0]                   douta_tw  ;
wire                            wena_tw   ;

wire                            wr_en_et  ;
wire [`ENTRY_WIDTH:0]           wr_data_et;
wire                            rd_vld_et ;
wire [`ENTRY_WIDTH:0]           rd_data_et;
wire [5:0]                      addra_et  ;
wire                            bwea_et   ;
wire                            ena_et    ;
wire [`ENTRY_WIDTH:0]           dina_et   ;
wire [`ENTRY_WIDTH:0]           douta_et  ;
wire                            wena_et   ;



//********************  assign  ********************//
assign o_event       = 16'b0;
assign o_irq         = 4'b0;


//----------- Rsp_op FSM instance -------------
rsp_s1_op_fsm #(
    .RSP_S1_OP_IDX_OPNAME    (`RSP_S1_OP_IDX_OPNAME)
)u_rsp_s1_prep_fsm(
    .rst_n                   (rst_n),
    .clk                     (clk),
    
    .cfg_mem_bm_pp           (cfg_mem_bm_pp),
    
    .sw_cmd_req              (sw_cmd_req),
    .sw_cmd_req_clr          (sw_cmd_req_clr),
    .sw_cmd_info_op_id       (sw_cmd_info_op_id),
    .sw_cmd_info_ttl         (sw_cmd_info_ttl),
    .sw_cmd_info_trig_in     (sw_cmd_info_trig_in),
    .sw_cmd_info_trig_out    (sw_cmd_info_trig_out),

    .sw_start                (sw_start),
    .sw_start_clr            (sw_start_clr),
    .sw_start_info_ping_pong (sw_start_info_ping_pong),
    .sw_start_info_frame_type_id(sw_start_info_frame_type_id),
    .sw_finish_req_mask      (sw_finish_req_mask),
    .sw_finish_ack           (sw_finish_ack),
    .sw_finish_ack_clr       (sw_finish_ack_clr),
    .sw_mem_alloc            (sw_mem_alloc),
    .sw_mem_alloc_clr        (sw_mem_alloc_clr),

    .i_cmd_req               (i_cmd_req), // CDC
    .i_cmd_info              (i_cmd_info), // CDC
    .o_cmd_ack               (o_cmd_ack),
    
    .i_start_req_op          (i_start_req_op), // CDC
    .i_start_info_op         (i_start_info_op), // CDC
    .o_start_ack             (o_start_ack),
    
    .o_finish_req            (o_finish_req),
    .o_finish_info           (o_finish_info),
    .i_finish_ack_op         (i_finish_ack_op), // CDC
    
    .i_init                  (i_init),
    .i_reset                 (i_reset),
    .i_stop                  (i_stop),
    .i_rerun                 (i_rerun),
    
    .o_mem_req               (o_mem_req),
    .o_mem_bm                (o_mem_bm),
    .i_mem_ack               (i_mem_ack), // CDC
    
    .o_core_start            (core_start),
    .i_core_finish           (core_finish),

    .i_ping_pong             (1'b0),
    .i_frame_type_id         ({`RSP_S1_OP_FRM_WIDTH{1'b0}}),

    .o_ping_pong             (ping_pong),
    .o_frame_type_id         (frame_type_id),

    .o_op_id                 (op_id),
    .o_ttl                   (ttl),
    .o_cmd_trig_in           (cmd_trig_in),
    .o_cmd_trig_out          (cmd_trig_out),
    .o_cs                    (cs),
    .o_ttl_counter           (ttl_counter),

    .o_mem_free_ack          ()
);



//******************** ahb_bridge ********************//
rsp_s1_prep_ahb_mux #(
  .N_CH(`N_CH),
  .AHB_DW(`AHB_DW),
  .AHB_AW(`AHB_AW)
) u_rsp_s1_prep_ahb_mux(
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

wire                HSELM_FIFO_0;     
wire [`AHB_AW-1:0]  HADDRM_FIFO_0;    
wire [1:0]          HTRANSM_FIFO_0;   
wire                HWRITEM_FIFO_0;   
wire [2:0]          HSIZEM_FIFO_0;    
wire [2:0]          HBURSTM_FIFO_0;   
wire [`AHB_DW-1:0]  HWDATAM_FIFO_0;   
wire                HREADYMUXM_FIFO_0;

wire [`AHB_DW-1:0]  HRDATAM_FIFO_0;
wire                HREADYOUTM_FIFO_0;
wire [1:0]          HRESPM_FIFO_0;

//AHB Bridge Slave
wire [`AHB_AW-1:0]  HADDRS_FIFO_0;
wire [1:0]          HTRANSS_FIFO_0;     
wire                HWRITES_FIFO_0;
wire [2:0]          HSIZES_FIFO_0;      
wire [2:0]          HBURSTS_FIFO_0;     
wire [`AHB_DW-1:0]  HWDATAS_FIFO_0;

wire [`AHB_DW-1:0]  HRDATAS_FIFO_0;   
wire                HREADYOUTS_FIFO_0;
wire [1:0]          HRESPS_FIFO_0;


assign HSELM_FIFO_0      = ch_hsel[5];   
assign HADDRM_FIFO_0     = ch_haddr[5*`AHB_AW+:`AHB_AW];  
assign HTRANSM_FIFO_0    = ch_htrans[5*2+:2]; 
assign HWRITEM_FIFO_0    = ch_hwrite[5]; 
assign HSIZEM_FIFO_0     = ch_hsize[5*3+:3];         
assign HBURSTM_FIFO_0    = ch_hburst[5*3+:3];
assign HWDATAM_FIFO_0    = ch_hwdata[5*`AHB_DW+:`AHB_DW];        
assign HREADYMUXM_FIFO_0 = ch_hreadyin[5];     

assign ch_hrdata[5*`AHB_DW+:`AHB_DW] = 0;//HRDATAM_FIFO_0;
assign ch_hready[5]                  = 1;//HREADYOUTM_FIFO_0;
assign ch_hresp[5*2+:2]              = 0;//HRESPM_FIFO_0;


ahb2ahb_async_DW_ahb_h2h #(
  .SAW(`AHB_AW),
  .SDW(`AHB_DW),
  .SBE(0),
  .MAW(`AHB_AW),
  .MDW(`AHB_DW),
  .MBE(0)
) u_ahb2ahb_async_DW_ahb_h2h_twiddle (
  // Outputs
  .shrdata(HRDATAM_FIFO_0), 
  .shready_resp(HREADYOUTM_FIFO_0), 
  .shresp(HRESPM_FIFO_0), 
  .shsplit(), 
  .mhaddr(HADDRS_FIFO_0), 
  .mhburst(HBURSTS_FIFO_0),
  .mhbusreq(), 
  .mhlock(), 
  .mhprot(), 
  .mhsize(HSIZES_FIFO_0), 
  .mhtrans(HTRANSS_FIFO_0), 
  .mhwdata(HWDATAS_FIFO_0), 
  .mhwrite(HWRITES_FIFO_0),
  .bus_id(),
  // Inputs  
  .shclk(hclk), 
  .shclken(1'b1), 
  .shresetn(~hreset), 
  .shaddr(HADDRM_FIFO_0), 
  .shburst(HBURSTM_FIFO_0), 
  .shmaster(4'b0), 
  .shmastlock(1'b0), 
  .shprot(4'b0), 
  .shready(HREADYMUXM_FIFO_0), 
  .shsel(HSELM_FIFO_0), 
  .shsize(HSIZEM_FIFO_0), 
  .shtrans(HTRANSM_FIFO_0), 
  .shwdata(HWDATAM_FIFO_0), 
  .shwrite(HWRITEM_FIFO_0),
  .mhclk(clk), 
  .mhclken(1'b1), 
  .mhresetn(rst_n), 
  .mhgrant(1'b1), 
  .mhrdata(HRDATAS_FIFO_0), 
  .mhready(HREADYOUTS_FIFO_0), 
  .mhresp(HRESPS_FIFO_0), 
  .mttick(1'b0), 
  //spyglass disable_block Topology_02
  //SMD: Found a direct connection from input port to output port
  //SJ: Connections are made as per the definition of the port 
  .sync_bypass(1'b0), 
  //spyglass enable_block Topology_02
  .shsel_id(1'b1)
);

ahb2fifo #(
  .SAW(`AHB_AW),
  .SDW(`AHB_AW),
  .DW(`TWIDDLE_WIDTH)
) u_ahb2fifo_twiddle (
  .rst_n     (rst_n),
  .clk       (clk),
  //AHB slave
  .shready   (HREADYOUTS_FIFO_0),
  .shtrans   (HTRANSS_FIFO_0),
  .shwdata   (HWDATAS_FIFO_0),
  .shwrite   (HWRITES_FIFO_0),
  .shrdata   (HRDATAS_FIFO_0),
  .shresp    (HRESPS_FIFO_0),
  //write
  .wr_en     (wr_en_tw),
  .wr_data   (wr_data_tw),
  //read
  .rd_en     (),//(rd_en_tw),
  .rd_vld    (1'b0),//(rd_vld_tw),
  .rd_data   (phase_ram0_rd_data)//(rd_data_tw)
);


//AHB Bridge Master
wire                HSELM_FIFO_1;     
wire [`AHB_AW-1:0]  HADDRM_FIFO_1;    
wire [1:0]          HTRANSM_FIFO_1;   
wire                HWRITEM_FIFO_1;   
wire [2:0]          HSIZEM_FIFO_1;    
wire [2:0]          HBURSTM_FIFO_1;   
wire [`AHB_DW-1:0]  HWDATAM_FIFO_1;   
wire                HREADYMUXM_FIFO_1;

wire [`AHB_DW-1:0]  HRDATAM_FIFO_1;
wire                HREADYOUTM_FIFO_1;
wire [1:0]          HRESPM_FIFO_1;

//AHB Bridge Slave
wire [`AHB_AW-1:0]  HADDRS_FIFO_1;      
wire [1:0]          HTRANSS_FIFO_1;     
wire                HWRITES_FIFO_1;
wire [2:0]          HSIZES_FIFO_1;      
wire [2:0]          HBURSTS_FIFO_1;     
wire [`AHB_DW-1:0]  HWDATAS_FIFO_1;

wire [`AHB_DW-1:0]  HRDATAS_FIFO_1;   
wire                HREADYOUTS_FIFO_1;
wire [1:0]          HRESPS_FIFO_1;

assign HSELM_FIFO_1      = ch_hsel[6];   
assign HADDRM_FIFO_1     = ch_haddr[6*`AHB_AW+:`AHB_AW];  
assign HTRANSM_FIFO_1    = ch_htrans[6*2+:2]; 
assign HWRITEM_FIFO_1    = ch_hwrite[6]; 
assign HSIZEM_FIFO_1     = ch_hsize[6*3+:3];         
assign HBURSTM_FIFO_1    = ch_hburst[6*3+:3];
assign HWDATAM_FIFO_1    = ch_hwdata[6*`AHB_DW+:`AHB_DW];        
assign HREADYMUXM_FIFO_1 = ch_hreadyin[6];     

assign ch_hrdata[6*`AHB_DW+:`AHB_DW] = 0;//HRDATAM_FIFO_1;
assign ch_hready[6]                  = 1;//HREADYOUTM_FIFO_1;
assign ch_hresp[6*2+:2]              = 0;//HRESPM_FIFO_1;


ahb2ahb_async_DW_ahb_h2h #(
  .SAW(`AHB_AW),
  .SDW(`AHB_DW),
  .SBE(0),
  .MAW(`AHB_AW),
  .MDW(`AHB_DW),
  .MBE(0)
) u_ahb2ahb_async_DW_ahb_h2h_entry (
  // Outputs
  .shrdata(HRDATAM_FIFO_1), 
  .shready_resp(HREADYOUTM_FIFO_1), 
  .shresp(HRESPM_FIFO_1), 
  .shsplit(), 
  .mhaddr(HADDRS_FIFO_1), 
  .mhburst(HBURSTS_FIFO_1),
  .mhbusreq(), 
  .mhlock(), 
  .mhprot(), 
  .mhsize(HSIZES_FIFO_1), 
  .mhtrans(HTRANSS_FIFO_1), 
  .mhwdata(HWDATAS_FIFO_1), 
  .mhwrite(HWRITES_FIFO_1),
  .bus_id(),
  // Inputs  
  .shclk(hclk), 
  .shclken(1'b1), 
  .shresetn(~hreset), 
  .shaddr(HADDRM_FIFO_1), 
  .shburst(HBURSTM_FIFO_1), 
  .shmaster(4'b0), 
  .shmastlock(1'b0), 
  .shprot(4'b0), 
  .shready(HREADYMUXM_FIFO_1), 
  .shsel(HSELM_FIFO_1), 
  .shsize(HSIZEM_FIFO_1), 
  .shtrans(HTRANSM_FIFO_1), 
  .shwdata(HWDATAM_FIFO_1), 
  .shwrite(HWRITEM_FIFO_1),
  .mhclk(clk), 
  .mhclken(1'b1), 
  .mhresetn(rst_n), 
  .mhgrant(1'b1), 
  .mhrdata(HRDATAS_FIFO_1), 
  .mhready(HREADYOUTS_FIFO_1), 
  .mhresp(HRESPS_FIFO_1), 
  .mttick(1'b0), 
  //spyglass disable_block Topology_02
  //SMD: Found a direct connection from input port to output port
  //SJ: Connections are made as per the definition of the port 
  .sync_bypass(1'b0), 
  //spyglass enable_block Topology_02
  .shsel_id(1'b1)
);

ahb2fifo #(
  .SAW(`AHB_AW),
  .SDW(`AHB_DW),
  .DW(`ENTRY_WIDTH)
) u_ahb2fifo1 (
  .rst_n     (rst_n),
  .clk       (clk),
  //AHB slave
  .shready   (HREADYOUTS_FIFO_1),
  .shtrans   (HTRANSS_FIFO_1),
  .shwdata   (HWDATAS_FIFO_1),
  .shwrite   (HWRITES_FIFO_1),
  .shrdata   (HRDATAS_FIFO_1),
  .shresp    (HRESPS_FIFO_1),
  //write
  .wr_en     (wr_en_et),
  .wr_data   (wr_data_et),
  //read
  .rd_en     (),
  .rd_vld    (1'b0),
  .rd_data   (phase_ram1_rd_data)
);
//********************  CSR & GLB  ********************//
generate for (genvar i=0; i<`RSP_S1_OP_FRM_NUM; i=i+1) begin: inst_rsp_s1_prep_csr_reg
rsp_s1_prep_csr_reg u_rsp_s1_prep_csr_reg(
  .r1_prep_cfg_shift_switch_array      (),                  
  .r1_prep_cfg_round_num               (),               
  .r1_prep_cfg_if_iprep                (),                 
  .r1_prep_cfg_if_rprep                (),                 
  .r1_prep_cfg_if_padding              (),                    
  .r1_prep_cfg_in_out_width            (),                      
  .r1_prep_cfg_shift_array             (),                     
  .r1_prep_cfg_pts                     (),             
  .r1_prep_pad_mask                    (),              
  .r1_prep_pad_addr                    (),              
  .r1_prep_addr_ping_base_wr           (),                       
  .r1_prep_addr_ping_base_rd           (),                       
  .r1_prep_addr_pong_base_wr           (),                       
  .r1_prep_addr_pong_base_rd           (),                       
  .r1_fsm_mem_bm_pong                  (),                
  .r1_fsm_mem_bm_ping                  (),                
  .r1_win_idx                          (),                         
  .r1_win_enable                       (),                            
  .r2_prep_cfg_shift_switch_array      (),                            
  .r2_prep_cfg_round_num               (),                   
  .r2_prep_cfg_if_iprep                (),                  
  .r2_prep_cfg_if_rprep                (),                  
  .r2_prep_cfg_if_padding              (),                    
  .r2_prep_cfg_in_out_width            (),                      
  .r2_prep_cfg_shift_array             (),                     
  .r2_prep_cfg_pts                     (),             
  .r2_prep_pad_mask                    (),              
  .r2_prep_pad_addr                    (),              
  .r2_prep_addr_ping_base_wr           (),                       
  .r2_prep_addr_ping_base_rd           (),                       
  .r2_prep_addr_pong_base_wr           (),                       
  .r2_prep_addr_pong_base_rd           (),                       
  .r2_fsm_mem_bm_pong                  (),                
  .r2_fsm_mem_bm_ping                  (),                
  .r2_win_idx                          (),        
  .r2_win_enable                       (),           
  .i_smp_cnt_i_smp_cnt                 (),                 
  .i_chirp_cnt_i_chirp_cnt             (),                     
  .i_frm_cnt_i_frm_cnt                 (),                 
  .i_sel_lf_d2est_i_sel_lf_d2est       (),                           
  .i_sel_hf_d2est_i_sel_hf_d2est       (),                           
  .i_sel_16_32_i_sel_16_32             (),                     
  .i_is_real_i_is_real                 (),                 
  .i_dc_est_scale_i_dc_est_scale       (),                           
  .i_dc_u_shift_i_dc_u_shift           (),                       
  .i_dc_u_l_i_dc_u_l                   (),               
  .i_dc_u_h_i_dc_u_h                   (),               

  .o_dc_u_l_o_dc_u_l                   (),    


  .o_dc_u_h_o_dc_u_h                   (),    

  .i_lf_intf_est_scale_i_lf_intf_est_scale      (),                             
  .i_hf_intf_est_scale_i_hf_intf_est_scale      (),                             
  .i_lf_intf_est_shift_i_lf_intf_est_shift      (),                             
  .i_hf_intf_est_shift_i_hf_intf_est_shift      (),                             
  .i_lf_intf_cmp_l_i_lf_intf_cmp_l              (),                     
  .i_lf_intf_cmp_h_i_lf_intf_cmp_h              (),                     

  .o_lf_intf_cmp_l_o_lf_intf_cmp_l              (),                      


  .o_lf_intf_cmp_h_o_lf_intf_cmp_h              (),                       

  .i_hf_intf_cmp_l_i_hf_intf_cmp_l              (),   
  .i_hf_intf_cmp_h_i_hf_intf_cmp_h              (),   

  .o_hf_intf_cmp_l_o_hf_intf_cmp_l              (),   


  .o_hf_intf_cmp_h_o_hf_intf_cmp_h              (),    

  .i_combination_config_mode_i_comb_config_mode (),                                 
  .i_phase_config_mode_i_phase_config_mode      (),                             
  .i_phase_w_i_phase_w                          (),                          
  .i_phase_entry_select_i_phase_entry_select    (),                               

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

rsp_s1_prep_glb_reg u_rsp_s1_prep_glb_reg(
  .irq_status_core_finish(irq_status[0]),
  .irq_status_core_finish_lat_pls(irq_status_lat_pls[0]),
  .irq_mask_core_finish(irq_mask[0]),
  .irq_enable_core_finish(irq_enable[0]),

  .status_pts_not_match(fft_core_sts[0]),
  .status_out_width_error(fft_core_sts[1]),

  .cmd0_ttl_counter(ttl_counter),
  .cmd0_cs(cs),
  .cmd0_op_id(op_id),
  .cmd0_ttl(ttl),
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

  .change_cfg(change_cfg),

  .mem_cnt_rd_a(mem_cnt_rd_A),
  .mem_cnt_rd_b(mem_cnt_rd_B),
  .mem_cnt_wr_a(mem_cnt_wr_A),
  .mem_cnt_wr_b(mem_cnt_wr_B),
  .counter_tw(counter_tw_download),
  .counter_win(counter_win_download),

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


//******************** PE ********************//

rsp_s1_prep_core #(
  .DELAY              (`DELAY_DATA_RSP_S1_PREP_CORE ),
  .L1_DATA_WIDTH      (`L1_DATA_WIDTH               ),
  .SAMPLE_WIDTH       (`SAMPLE_WIDTH                ),
  .SMP_CNT            (`SMP_CNT                     ),
  .CHP_CNT            (`CHP_CNT                     ),
  .FRM_CNT            (`FRM_CNT                     ),
  .TWIDDLE_ADDR       (`TWIDDLE_ADDR                ),
  .TWIDDLE_WIDTH      (`TWIDDLE_WIDTH               ),
  .ENTRY_ADDR         (`ENTRY_ADDR                  ),
  .ENTRY_WIDTH        (`ENTRY_WIDTH                 ),
  
  //DEBUG
  .DEBUG_PACKET_SELECT  (`DEBUG_PACKET_SELECT       )
) u_rsp_s1_prep_core(
  .rst_n                (rst_n),
  .hrst_n               (~hreset),
  .clk                  (clk),
  .hclk                 (hclk),
  .i_start              (core_start),
  .o_finish             (core_finish),

  //config
  .CSR_BURST_LEN            ('d8),
  .CSR_RD_START_ADDR        (18'd0),
  .CSR_WR_START_ADDR        (18'd0),

  .CSR_SEL_DATA_FORMATTRT   (2'b10), //complex 16
  // .CSR_SEL_DATA_FORMATTRT              (2'b00),//complex 32
  // .CSR_SEL_DATA_FORMATTRT              (2'b01),//real 16
  .CSR_EST_SMP_CNT          ('d256),
  .CSR_EST_CHP_CNT          ('d4),
  .CSR_EST_FRM_CNT          (4'd0),
  .CSR_DC_EST_SCALE         (17'd65536),
  .CSR_DC_CFG_MODE          (4'd0),
  .CSR_INTF_EST_SCALE       (17'd80000),
  .CSR_INTF_CFG_MODE        (4'd0),
  .CSR_COMB_CFG_MODE        (4'd0),
  .CSR_PHASE_ENTRY_SEL      (6'h10),

  //DC_estimation
  // .CSR_DC_U                 ({32'd0,16'd538,16'd538}),
  // .CSR_DC_U                 ({32'd0,16'd118,16'd420}),//complex
  .CSR_DC_U                 ({32'd118,32'd420}),//complex
  .o_dc_u                 (),

  //INTF_estimation
  // .CSR_INTF_CMP             (16'd657),
  // .CSR_INTF_CMP             (64'd1700000000),//complex
  .CSR_INTF_CMP             ({64'd1700000000}),//complex
  .o_intf_cmp             (),


  .CSR_PHASE_W              (64'h02000200),
  .CSR_PHASE_COE            (64'h0),
  .i_phase_ram0_addra       (   ),
  .i_phase_ram0_bwea        (    ),
  .i_phase_ram0_ena         (wr_en_tw),
  .i_phase_ram0_dina        (wr_data_tw),
  .o_phase_ram0_douta       ( ),
  .i_phase_ram0_wena        (wr_en_tw),

  .i_phase_ram1_addra       (   ),
  .i_phase_ram1_bwea        (    ),
  .i_phase_ram1_ena         (wr_en_et),
  .i_phase_ram1_dina        (wr_data_et),
  .o_phase_ram1_douta       ( ),
  .i_phase_ram1_wena        (wr_en_et),

  .o_m1_wr_data             (o_m1_wr_data_A ),
  .o_m1_wr_addr             (o_m1_wr_addr_A ),
  .o_m1_wr_en               (o_m1_wr_en_A   ),
  .o_m1_wr_wea              (o_m1_wea_A     ),
  .i_m0_rd_data             (i_m0_rd_data_A ),
  .o_m0_rd_addr             (o_m0_rd_addr_A ),
  .o_m0_rd_en               (o_m0_rd_en_A   )
 
);

endmodule