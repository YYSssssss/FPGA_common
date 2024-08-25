///////////////////////////////////////////////////////////////////////////////
//
// AXI4-Lite Master
//
////////////////////////////////////////////////////////////////////////////
//
// Structure:
//   axi_lite_master
//
// Last Update:
//   08/08/2024
////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module axi_lite_master #
   (
    parameter integer C_M_AXI_ADDR_WIDTH = 32,
    parameter integer C_M_AXI_DATA_WIDTH = 32,
    parameter         C_NUM_COMMANDS = 16,
    parameter         READ_WRITE_ADDR = 32'h00000000
    )
   (
    // System Signals
    input wire m_axi_aclk,
    input wire m_axi_aresetn,

    // Master Interface Write Address
    output wire [C_M_AXI_ADDR_WIDTH-1:0]  m_axi_awaddr,
    output wire [3-1:0]                   m_axi_awprot,
    output wire                           m_axi_awvalid,
    input  wire                           m_axi_awready,

    // Master Interface Write Data
    output wire [C_M_AXI_DATA_WIDTH-1:0]    m_axi_wdata,
    output wire [C_M_AXI_DATA_WIDTH/8-1:0]  m_axi_wstrb,
    output wire                             m_axi_wvalid,
    input  wire                             m_axi_wready,

    // Master Interface Write Response
    input  wire [2-1:0]           m_axi_bresp,
    input  wire                   m_axi_bvalid,
    output wire                   m_axi_bready,

    // Master Interface Read Address
    output wire [C_M_AXI_ADDR_WIDTH-1:0]  m_axi_araddr,
    output wire [3-1:0]                   m_axi_arprot,
    output wire                           m_axi_arvalid,
    input  wire                           m_axi_arready,

    // Master Interface Read Data
    input  wire [C_M_AXI_DATA_WIDTH-1:0]  m_axi_rdata,
    input  wire [2-1:0]                   m_axi_rresp,
    input  wire                           m_axi_rvalid,
    output wire                           m_axi_rready,

    //Example Output
    output wire                           done_success,
    input  wire                           i_frame_start,
    input  wire                           i_start_input_gpio,
    input  wire [15:0]                    i_cnt_m_axis_mm2s_tlast_pos,
    output wire                           dma_done_irq
    
);


//******************** reg wire logic assign********************//
reg frame_start_d0;
reg frame_start_d1;
wire frame_start_pos;
reg start_input_gpio_d0;
reg start_input_gpio_d1;
wire start_input_gpio_pos;
  // AXI4 signals
  logic 		      awvalid;
  logic 		      awready;
  logic 		      wvalid;
  logic 		      wready;
  logic 		      push_write;
  logic 		      pop_read;
  logic           arvalid;
  logic           rready;
  logic           bready;
  logic [31:0] 	  awaddr;
  logic [31:0] 	  wdata;
  logic [31:0] 	  araddr;
  logic 	        write_resp_error;
  logic          read_resp_error;

  logic [31:0]		rdata;



  //Example-specific design signals
  logic         writes_done;
  logic         reads_done;
  logic         error_reg;
  logic[31:0] 	write_index;
  logic[31:0] 	read_index;
  logic[31:0] 	check_rdata;
  logic         done_success_int;
  logic         read_mismatch;
  logic 	last_write;
  logic 	last_read;




//******************** assign ********************//

////////////////////
//Write Address (AW)
////////////////////
assign m_axi_awaddr = awaddr;

assign m_axi_wdata = wdata;
assign m_axi_awprot = 3'h0;
assign m_axi_awvalid = awvalid;
assign awready = m_axi_awready;

///////////////
//Write Data(W)
///////////////
assign m_axi_wvalid = wvalid;
assign wready = m_axi_wready;

//Set all byte strobes in this example
assign m_axi_wstrb = -1;

////////////////////
//Write Response (B)
////////////////////
assign m_axi_bready = bready;

///////////////////
//Read Address (AR)
///////////////////
assign m_axi_araddr = araddr;
assign m_axi_arvalid = arvalid;
assign m_axi_arprot = 3'b0;

////////////////////////////
//Read and Read Response (R)
////////////////////////////
assign m_axi_rready = rready;

////////////////////
//Example design I/O
////////////////////
assign done_success = 0;

//assign reset_start = m_axi_aresetn && (i_frame_start || i_start_input_gpio) ;


//******************** instruct ********************//

always@(posedge m_axi_aclk or negedge m_axi_aresetn)begin
    if(!m_axi_aresetn) begin
        frame_start_d0 <= 1'b0;
        frame_start_d1 <= 1'b0;
    end
    else begin
        frame_start_d0 <= i_frame_start;
        frame_start_d1 <= frame_start_d0;
    end
end
assign frame_start_pos = frame_start_d0 && ~frame_start_d1;

always@(posedge m_axi_aclk or negedge m_axi_aresetn)begin
    if(!m_axi_aresetn) begin
        start_input_gpio_d0 <= 1'b0;
        start_input_gpio_d1 <= 1'b0;
    end
    else begin
        start_input_gpio_d0 <= i_start_input_gpio;
        start_input_gpio_d1 <= start_input_gpio_d0;
    end
end
assign start_input_gpio_pos = start_input_gpio_d0 && ~start_input_gpio_d1;




//******************** main ********************//
///////////////////////
//Write Address Channel
///////////////////////
always @(posedge m_axi_aclk) begin
     if (frame_start_pos == 1'b1 || start_input_gpio_pos == 1'b1)
       awvalid <= 1'b0;
     else if (m_axi_awready && awvalid)
       awvalid <= 1'b0;
     else if (push_write)
       awvalid <= 1'b1;
     else
       awvalid <= awvalid;
  end

////////////////////
//Write Data Channel
////////////////////
always @(posedge m_axi_aclk) begin
  if (frame_start_pos == 1'b1 || start_input_gpio_pos == 1'b1)
    wvalid <= 1'b0;
  //Data accepted by interconnect/slave
  else if (m_axi_wready && wvalid)
    wvalid <= 1'b0;
  //Signal a new address/data command is available by user logic
  else if (push_write)
    wvalid <= 1'b1;
  else
    wvalid <= wvalid;
end

////////////////////////////
//Write Response (B) Channel
////////////////////////////
//Always accept write responses
always @(posedge m_axi_aclk) begin
  if (frame_start_pos == 1'b1 || start_input_gpio_pos == 1'b1)
    bready <= 1'b0;
  else
    bready <= 1'b1;
end

//Flag write errors
assign write_resp_error = bready & m_axi_bvalid & m_axi_bresp[1];

//////////////////////
//Read Address Channel
//////////////////////
//always @(posedge m_axi_aclk) begin
//  if (frame_start_pos == 1'b1 || start_input_gpio_pos == 1'b1)
//    arvalid <= 1'b0;
//  else if (m_axi_arready && arvalid)
//    arvalid <= 1'b0;
//  else if (pop_read)
//    arvalid <= 1'b1;
//  else
//    arvalid <= arvalid;
//  end

//////////////////////////////////
//Read Data (and Response) Channel
//////////////////////////////////
//always @(posedge m_axi_aclk) begin
//     if (frame_start_pos == 1'b1 || start_input_gpio_pos == 1'b1)
//     rready <= 1'b0;
//      else
//     rready <= 1'b1;
//end

//Flag write errors
//assign read_resp_error = rready & m_axi_rvalid & m_axi_rresp[1];




////////////
//User Logic
////////////
axi_lite_user_logic u_axi_lite_user_logic(
    .clk                         (m_axi_aclk),
    .rstn                        (m_axi_aresetn),
    .i_frame_start               (i_frame_start),
    .i_start_input_gpio          (i_start_input_gpio),                    
    .awvalid                     (awvalid),
    .awready                     (awready),
    .awaddr                      (awaddr),
    .wvalid                      (wvalid),
    .wready                      (wready),
    .wdata                       (wdata),
    .push_write                  (push_write),
    .pop_read                    (pop_read),
    .i_cnt_m_axis_mm2s_tlast_pos (i_cnt_m_axis_mm2s_tlast_pos),
    .dma_done_irq                (dma_done_irq)
);




endmodule