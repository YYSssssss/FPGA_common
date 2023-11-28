//-----------------------------------------------------------------------------
// File: axi_ram.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: AXI write to /read from RAM interface
// Modification history:
// $Log$
//   Jichen 5/14/2023 original
//   Jichen 5/24/2023 original
//     add axi sv interface
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

/*
 * AXI4 RAM
 */
module axi_ram #
(
  // Width of data bus in bits
  parameter DATA_WIDTH = 32,
  // Width of address bus in bits
  parameter ADDR_WIDTH = 16,
  // Width of ID signal
  parameter ID_WIDTH = 1,
  // Read delay from on-chip Memory
  parameter RD_DELAY = 1,

  parameter STRB_WIDTH = (DATA_WIDTH/8),
  parameter VALID_ADDR_WIDTH = ADDR_WIDTH - $clog2(STRB_WIDTH)
)
(
  input  wire                         clk,
  input  wire                         rst_n,
  // Memory Read
  output reg                          rd_en,
  output wire [VALID_ADDR_WIDTH-1:0]  rd_addr,
  input  wire [DATA_WIDTH-1:0]        rd_data,
  // Memory Write
  output reg                          wr_en,
  output wire [VALID_ADDR_WIDTH-1:0]  wr_addr,
  output wire [DATA_WIDTH-1:0]        wr_data,
  output wire [STRB_WIDTH-1:0]        wr_strb,
  // AXI Write
  axi_v4_wr_if.slave                  s_axi_wr,
  // AXI Read
  axi_v4_rd_if.slave                  s_axi_rd
);

parameter WORD_WIDTH = STRB_WIDTH;
parameter WORD_SIZE = DATA_WIDTH/WORD_WIDTH;

//synopsys translate_off
// bus width assertions
initial begin
    if (WORD_SIZE * STRB_WIDTH != DATA_WIDTH) begin
        $error("Error: AXI data width not evenly divisble (instance %m)");
        $finish;
    end

    if (2**$clog2(WORD_WIDTH) != WORD_WIDTH) begin
        $error("Error: AXI word width must be even power of two (instance %m)");
        $finish;
    end
end
//synopsys translate_on

// AXI write signals
wire [ID_WIDTH-1:0]          s_axi_awid;
wire [ADDR_WIDTH-1:0]        s_axi_awaddr;
wire [7:0]                   s_axi_awlen;
wire [2:0]                   s_axi_awsize;
wire [1:0]                   s_axi_awburst;
wire                         s_axi_awlock;
wire [3:0]                   s_axi_awcache;
wire [2:0]                   s_axi_awprot;
wire                         s_axi_awvalid;
wire                         s_axi_awready;
wire [DATA_WIDTH-1:0]        s_axi_wdata;
wire [STRB_WIDTH-1:0]        s_axi_wstrb;
wire                         s_axi_wlast;
wire                         s_axi_wvalid;
wire                         s_axi_wready;
wire [ID_WIDTH-1:0]          s_axi_bid;
wire [1:0]                   s_axi_bresp;
wire                         s_axi_bvalid;
wire                         s_axi_bready;

assign s_axi_awid         =  s_axi_wr.awid;
assign s_axi_awaddr       =  s_axi_wr.awaddr;
assign s_axi_awlen        =  s_axi_wr.awlen;
assign s_axi_awsize       =  s_axi_wr.awsize;
assign s_axi_awburst      =  s_axi_wr.awburst;
assign s_axi_awlock       =  s_axi_wr.awlock;
assign s_axi_awcache      =  s_axi_wr.awcache;
assign s_axi_awprot       =  s_axi_wr.awprot;
assign s_axi_awvalid      =  s_axi_wr.awvalid;
assign s_axi_wr.awready   =  s_axi_awready;
assign s_axi_wdata        =  s_axi_wr.wdata;
assign s_axi_wstrb        =  s_axi_wr.wstrb;
assign s_axi_wlast        =  s_axi_wr.wlast;
assign s_axi_wvalid       =  s_axi_wr.wvalid;
assign s_axi_wr.wready    =  s_axi_wready;
assign s_axi_wr.bid       =  s_axi_bid;
assign s_axi_wr.bresp     =  s_axi_bresp;
assign s_axi_wr.bvalid    =  s_axi_bvalid;
assign s_axi_bready       =  s_axi_wr.bready;

// AXI read signals
wire [ID_WIDTH-1:0]          s_axi_arid;
wire [ADDR_WIDTH-1:0]        s_axi_araddr;
wire [7:0]                   s_axi_arlen;
wire [2:0]                   s_axi_arsize;
wire [1:0]                   s_axi_arburst;
wire                         s_axi_arlock;
wire [3:0]                   s_axi_arcache;
wire [2:0]                   s_axi_arprot;
wire                         s_axi_arvalid;
wire                         s_axi_arready;
wire [ID_WIDTH-1:0]          s_axi_rid;
wire [DATA_WIDTH-1:0]        s_axi_rdata;
wire [1:0]                   s_axi_rresp;
wire                         s_axi_rlast;
wire                         s_axi_rvalid;
wire                         s_axi_rread;

assign s_axi_arid          = s_axi_rd.arid;
assign s_axi_araddr        = s_axi_rd.araddr;
assign s_axi_arlen         = s_axi_rd.arlen;
assign s_axi_arsize        = s_axi_rd.arsize;
assign s_axi_arburst       = s_axi_rd.arburst;
assign s_axi_arlock        = s_axi_rd.arlock;
assign s_axi_arcache       = s_axi_rd.arcache;
assign s_axi_arprot        = s_axi_rd.arprot;
assign s_axi_arvalid       = s_axi_rd.arvalid;
assign s_axi_rd.arready    = s_axi_arready;
assign s_axi_rd.rid        = s_axi_rid;
assign s_axi_rd.rdata      = s_axi_rdata;
assign s_axi_rd.rresp      = s_axi_rresp;
assign s_axi_rd.rlast      = s_axi_rlast;
assign s_axi_rd.rvalid     = s_axi_rvalid;
assign s_axi_rready        = s_axi_rd.rready;



// AXI write RAM
localparam [1:0]
    WRITE_STATE_IDLE  = 2'd0,
    WRITE_STATE_BURST = 2'd1,
    WRITE_STATE_RESP  = 2'd2;

reg [1:0] write_state_reg, write_state_next;

reg [ID_WIDTH-1:0] write_id_reg, write_id_next;
reg [ADDR_WIDTH-1:0] write_addr_reg, write_addr_next;
reg [7:0] write_count_reg, write_count_next;
reg [2:0] write_size_reg, write_size_next;
reg [1:0] write_burst_reg, write_burst_next;

reg s_axi_awready_reg, s_axi_awready_next;
reg s_axi_wready_reg, s_axi_wready_next;
reg s_axi_bvalid_reg, s_axi_bvalid_next;

wire wr_data_last = s_axi_wlast & s_axi_wvalid & s_axi_wready;

assign wr_addr = write_addr_reg >> (ADDR_WIDTH - VALID_ADDR_WIDTH);
assign wr_data = s_axi_wdata;
assign wr_strb = s_axi_wstrb;

assign s_axi_awready = s_axi_awready_reg | (wr_data_last & s_axi_bvalid & s_axi_bready);
assign s_axi_wready  = s_axi_wready_reg;
assign s_axi_bid     = write_id_reg;
assign s_axi_bresp   = 2'b00;
assign s_axi_bvalid  = s_axi_bvalid_reg | wr_data_last;

// Write FSM
always @* begin
    write_state_next = WRITE_STATE_IDLE;

    wr_en = 1'b0;

    write_id_next    = write_id_reg;
    write_addr_next  = write_addr_reg;
    write_count_next = write_count_reg;
    write_size_next  = write_size_reg;
    write_burst_next = write_burst_reg;

    s_axi_awready_next = s_axi_awready_reg & !s_axi_awvalid;
    s_axi_wready_next  = 1'b0;
    s_axi_bvalid_next  = s_axi_bvalid_reg & !s_axi_bready;

    case (write_state_reg)
        WRITE_STATE_IDLE: begin
            s_axi_awready_next = 1'b1;

            if (s_axi_awready && s_axi_awvalid) begin
                write_id_next    = s_axi_awid;
                write_addr_next  = s_axi_awaddr;
                write_count_next = s_axi_awlen;
                write_size_next  = s_axi_awsize;
                write_burst_next = s_axi_awburst;

                s_axi_awready_next = 1'b0;       
                s_axi_wready_next  = 1'b1;
                write_state_next   = WRITE_STATE_BURST;
            end else begin
                write_state_next   = WRITE_STATE_IDLE;
            end
        end
        WRITE_STATE_BURST: begin
            s_axi_wready_next = 1'b1;

            if (s_axi_wready && s_axi_wvalid) begin
                wr_en = 1'b1;
                if (write_burst_reg != 2'b00) begin
                    write_addr_next = write_addr_reg + (1 << write_size_reg);
                end
                write_count_next = write_count_reg - 1;
                if (write_count_reg > 0) begin
                    write_state_next = WRITE_STATE_BURST;
                end else begin // write last
                    s_axi_bvalid_next  = 1'b1;
                    if (s_axi_awready && s_axi_awvalid) begin
                        write_state_next   = WRITE_STATE_BURST;
                        
                        write_id_next    = s_axi_awid;
                        write_addr_next  = s_axi_awaddr;
                        write_count_next = s_axi_awlen;
                        write_size_next  = s_axi_awsize;
                        write_burst_next = s_axi_awburst;

                        //RESP
                        s_axi_bvalid_next  = 1'b0;
                    end else begin
                        write_state_next   = WRITE_STATE_RESP;
                        s_axi_wready_next  = 1'b0;
                        if (s_axi_bready && s_axi_bvalid) begin
                            write_state_next   = WRITE_STATE_IDLE;
                            s_axi_bvalid_next  = 1'b0;
                        end
                    end
                end
            end else begin
                write_state_next = WRITE_STATE_BURST;
            end
        end
        WRITE_STATE_RESP: begin
            if (s_axi_bready && s_axi_bvalid) begin
                s_axi_bvalid_next = 1'b0;
                s_axi_awready_next = 1'b1;
                write_state_next  = WRITE_STATE_IDLE;
            end else begin
                write_state_next = WRITE_STATE_RESP;
            end
        end
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        write_state_reg   <= WRITE_STATE_IDLE;

        write_id_reg      <= {ID_WIDTH{1'b1}};
        write_addr_reg    <= {ADDR_WIDTH{1'b0}};
        write_count_reg   <= 8'd0;
        write_size_reg    <= 3'd0;
        write_burst_reg   <= 2'd0;

        s_axi_awready_reg <= 1'b0;
        s_axi_wready_reg  <= 1'b0;
        s_axi_bvalid_reg  <= 1'b0;
    end else begin
        write_state_reg   <= write_state_next;

        write_id_reg      <= write_id_next;
        write_addr_reg    <= write_addr_next;
        write_count_reg   <= write_count_next;
        write_size_reg    <= write_size_next;
        write_burst_reg   <= write_burst_next;

        s_axi_awready_reg <= s_axi_awready_next;
        s_axi_wready_reg  <= s_axi_wready_next;
        s_axi_bvalid_reg  <= s_axi_bvalid_next;
    end
end

// AXI read RAM
localparam [0:0]
    READ_STATE_IDLE  = 1'd0,
    READ_STATE_BURST = 1'd1;

reg read_last;
reg [0:0] read_state_reg, read_state_next;

reg [ADDR_WIDTH-1:0] read_addr_reg, read_addr_next;
reg [7:0] read_count_reg, read_count_next;
reg [2:0] read_size_reg, read_size_next;
reg [1:0] read_burst_reg, read_burst_next;

wire rd_fifo_cmd_push;
reg  rd_fifo_cmd_pop;
wire rd_fifo_cmd_empty, rd_fifo_cmd_full, rd_fifo_arlen_afull;
wire [ADDR_WIDTH-1:0]        rd_fifo_s_axi_araddr;
wire [7:0]                   rd_fifo_s_axi_arlen;
wire [2:0]                   rd_fifo_s_axi_arsize;
wire [1:0]                   rd_fifo_s_axi_arburst;

wire rd_fifo_data_push, rd_fifo_data_pop;
wire rd_fifo_data_empty, rd_fifo_data_full, rd_fifo_data_afull;
wire [DATA_WIDTH-1:0] rd_fifo_data;

reg [7:0] read_fifo_data_count;
wire [7:0] read_fifo_data_len;

assign rd_addr = read_addr_reg >> (ADDR_WIDTH - VALID_ADDR_WIDTH);
assign s_axi_rdata   = rd_fifo_data;
assign s_axi_rresp   = 2'b00;
assign s_axi_rvalid  = ~rd_fifo_data_empty;

// AXI read cmd
fifo_fwft #(.WIDTH(ADDR_WIDTH+8+3+2), .DEPTH_FULL(4))
u_rd_cmd_fifo(
        .clk(clk), .rst_n(rst_n), 
        .push(rd_fifo_cmd_push), .pop(rd_fifo_cmd_pop), 
        .din({s_axi_araddr, s_axi_arlen, s_axi_arsize, s_axi_arburst}), 
        .dout({rd_fifo_s_axi_araddr, rd_fifo_s_axi_arlen, rd_fifo_s_axi_arsize, rd_fifo_s_axi_arburst}), 
        .empty(rd_fifo_cmd_empty), .full(rd_fifo_cmd_full), .afull()
        );

fifo_fwft #(.WIDTH(ID_WIDTH+8), .DEPTH_FULL(4+RD_DELAY))
u_rd_arlen_fifo(
        .clk(clk), .rst_n(rst_n), 
        .push(rd_fifo_cmd_push), .pop(s_axi_rlast), 
        .din({s_axi_arid, s_axi_arlen}), 
        .dout({s_axi_rid, read_fifo_data_len}),
        .empty(), .full(rd_fifo_arlen_afull), .afull()
        );

assign rd_fifo_cmd_push = s_axi_arvalid & s_axi_arready;
assign s_axi_arready = ~rd_fifo_cmd_full & ~rd_fifo_arlen_afull;

// AXI read data
delay #(RD_DELAY) u_rd_delay(.clk(clk), .rst_n(rst_n), .din(rd_en), .dout(rd_fifo_data_push));

fifo_fwft #(.WIDTH(DATA_WIDTH), .DEPTH_FULL(4+RD_DELAY), .THRESH_FULL(4))
u_rd_data_fifo(
        .clk(clk), .rst_n(rst_n), 
        .push(rd_fifo_data_push), .pop(rd_fifo_data_pop), 
        .din(rd_data), .dout(rd_fifo_data), 
        .empty(rd_fifo_data_empty), .full(rd_fifo_data_full), .afull(rd_fifo_data_afull)
        );

assign rd_fifo_data_pop = s_axi_rready && s_axi_rvalid;

// Read FSM
always @* begin
    read_state_next = READ_STATE_IDLE;

    rd_en = 1'b0;

    rd_fifo_cmd_pop = 1'b0;

    read_last         = 1'b0;
    read_addr_next    = read_addr_reg;
    read_count_next   = read_count_reg;
    read_size_next    = read_size_reg;
    read_burst_next   = read_burst_reg;

    case (read_state_reg)
        READ_STATE_IDLE: begin
            if (~rd_fifo_cmd_empty) begin
                rd_fifo_cmd_pop = 1'b1;

                read_addr_next  = rd_fifo_s_axi_araddr;
                read_count_next = rd_fifo_s_axi_arlen;
                read_size_next  = rd_fifo_s_axi_arsize;
                read_burst_next = rd_fifo_s_axi_arburst;

                read_state_next = READ_STATE_BURST;
            end else begin
                read_state_next = READ_STATE_IDLE;
            end
        end
        READ_STATE_BURST: begin
            if (~rd_fifo_data_afull) begin
                rd_en             = 1'b1;
                read_last         = (read_count_reg == 8'd0);
                if (read_burst_reg != 2'b00) begin
                    read_addr_next = read_addr_reg + (1 << read_size_reg);
                end
                read_count_next = read_count_reg - 1;
                if (read_count_reg > 8'd0) begin
                    read_state_next = READ_STATE_BURST;
                end else begin // read last
                    if (~rd_fifo_cmd_empty) begin
                        rd_fifo_cmd_pop = 1'b1;

                        read_addr_next  = rd_fifo_s_axi_araddr;
                        read_count_next = rd_fifo_s_axi_arlen;
                        read_size_next  = rd_fifo_s_axi_arsize;
                        read_burst_next = rd_fifo_s_axi_arburst;

                        read_state_next = READ_STATE_BURST;
                    end else begin
                        read_state_next = READ_STATE_IDLE;
                    end
                end
            end else begin
                read_state_next = READ_STATE_BURST;
            end
        end
    endcase    
end 

always @(posedge clk or negedge rst_n) 
  if (~rst_n)
    read_fifo_data_count <= 8'd0;
  else if (s_axi_rlast)
    read_fifo_data_count <= 8'd0;
  else if (rd_fifo_data_pop)
    read_fifo_data_count <= read_fifo_data_count + 1'b1;

assign s_axi_rlast = (read_fifo_data_count==read_fifo_data_len) & rd_fifo_data_pop;

always @(posedge clk or negedge rst_n) begin
  if (~rst_n) begin
    read_state_reg    <= READ_STATE_IDLE;
                        
    read_addr_reg     <= {ADDR_WIDTH{1'b0}};
    read_count_reg    <= 8'b0;
    read_size_reg     <= 3'b0;
    read_burst_reg    <= 2'b0;
  end else begin
    read_state_reg    <= read_state_next;
                                           
    read_addr_reg     <= read_addr_next;
    read_count_reg    <= read_count_next;
    read_size_reg     <= read_size_next;
    read_burst_reg    <= read_burst_next;
  end
end

endmodule
