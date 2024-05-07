interface axi_v4_rd_if #(
  DATA_WIDTH      = 128,
  ADDR_WIDTH      = 32,
  ID_WIDTH        = 4
);

logic                       arvalid;
logic   [ID_WIDTH-1:0]      arid;
logic   [ADDR_WIDTH-1:0]    araddr;
logic   [8-1:0]             arlen;
logic   [1:0]               arburst;
logic   [2:0]               arsize;
logic                       arready;
logic   [3:0]               arcache;
logic   [2:0]               arprot;
logic                       arlock;

logic                       rvalid;
logic   [ID_WIDTH-1:0]      rid;
logic   [DATA_WIDTH-1:0]    rdata;
logic                       rlast;
logic   [1:0]               rresp;
logic                       rready;

modport master (
    output              arvalid,
    output              arid,
    output              araddr,
    output              arlen,
    output              arburst,
    output              arsize,
    output              arcache,
    output              arprot,
    output              arlock,
    input               arready,
    
    input               rvalid,
    input               rid,
    input               rdata,
    input               rlast,
    input               rresp,
    output              rready      
);

modport slave (
    input               arvalid,
    input               arid,
    input               araddr,
    input               arlen,
    input               arburst,
    input               arsize,
    input               arcache,
    input               arprot,
    input               arlock,
    output              arready,

    output              rvalid,
    output              rid,
    output              rdata,
    output              rlast,
    output              rresp,
    input               rready      
);

endinterface