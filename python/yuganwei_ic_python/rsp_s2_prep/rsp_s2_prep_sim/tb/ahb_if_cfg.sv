interface ahb_if_cfg #(
  AHB_WDW=32,
  AHB_RDW=32,
  AHB_AW =32
);

logic                                hbusreq;
logic                                hgrant;
logic [ 3:0]                         hprot;
logic [AHB_AW-1:0]                   haddr;
logic [ 1:0]                         htrans;
logic [ 2:0]                         hsize;
logic [ 2:0]                         hburst;
logic                                hwrite;
logic [AHB_WDW-1:0]                  hwdata;
logic [AHB_RDW-1:0]                  hrdata;
logic                                hreadyin;
logic                                hready;
logic [ 1:0]                         hresp;
logic                                hsel;

modport master (
  output                             hsel,
  output                             htrans,
  output                             haddr,
  output                             hburst,
  output                             hsize,
  output                             hwdata,
  output                             hwrite,
  output                             hreadyin,
  input                              hrdata,
  input                              hresp,
  input                              hready
);

modport slave (
  input                              hsel,
  input                              htrans,
  input                              haddr,
  input                              hburst,
  input                              hsize,
  input                              hwdata,
  input                              hwrite,
  input                              hreadyin,
  output                             hrdata,
  output                             hresp,
  output                             hready
);

endinterface