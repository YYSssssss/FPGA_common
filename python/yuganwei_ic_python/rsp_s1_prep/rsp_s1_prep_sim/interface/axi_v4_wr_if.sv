interface axi_v4_wr_if #(
  DATA_WIDTH          = 128,
  ADDR_WIDTH          = 32,
  ID_WIDTH            = 4,
  STRB_WIDTH          = DATA_WIDTH/8 
);

logic                       awvalid;
logic   [ID_WIDTH-1:0]      awid;
logic   [ADDR_WIDTH-1:0]    awaddr;
logic   [8-1:0]             awlen;
logic   [1:0]               awburst;
logic   [2:0]               awsize;
logic                       awready;
logic   [3:0]               awcache;
logic   [2:0]               awprot;
logic                       awlock;

logic                       wvalid;
logic   [DATA_WIDTH-1:0]    wdata;
logic                       wlast;
logic                       wready;
logic   [STRB_WIDTH-1:0]    wstrb;

logic                       bvalid;
logic   [ID_WIDTH-1:0]      bid;
logic   [1:0]               bresp;
logic                       bready;

modport master (
  output              awvalid,
  output              awid,
  output              awaddr,
  output              awlen,
  output              awburst,
  output              awsize,
  output              awcache,
  output              awprot,
  output              awlock,
  input               awready,

  output              wvalid,
  output              wdata,
  output              wlast,
  output              wstrb,
  input               wready,

  input               bvalid,
  input               bid,
  input               bresp,
  output              bready
);

modport slave (
  input               awvalid,
  input               awid,
  input               awaddr,
  input               awlen,
  input               awburst,
  input               awsize,
  input               awcache,
  input               awprot,
  input               awlock,
  output              awready,

  input               wvalid,
  input               wdata,
  input               wlast,
  input               wstrb,
  output              wready,

  output              bvalid,
  output              bid,
  output              bresp,
  input               bready
);

endinterface

