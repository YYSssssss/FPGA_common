
module jb_oran_monitor_spoof_verilog(
  aclk,
  aresetn,
  addrDataSeen,

  s0_awaddr,
  s0_awvalid,
  s0_awready,
  s0_wdata,
  s0_wstrb,
  s0_wvalid,
  s0_wready,
  s0_bresp,
  s0_bvalid,
  s0_bready,
  s0_araddr,
  s0_arvalid,
  s0_arready,
  s0_rdata,
  s0_rresp,
  s0_rvalid,
  s0_rready,

  m0_awaddr,
  m0_awvalid,
  m0_awready,
  m0_wdata,
  m0_wstrb,
  m0_wvalid,
  m0_wready,
  m0_bresp,
  m0_bvalid,
  m0_bready,
  m0_araddr,
  m0_arvalid,
  m0_arready,
  m0_rdata,
  m0_rresp,
  m0_rvalid,
  m0_rready
  );

  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite awaddr           "*) input  wire   [15:0]  s0_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite awvalid          "*) input  wire           s0_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite awready          "*) output wire           s0_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite wdata            "*) input  wire   [31:0]  s0_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite wstrb            "*) input  wire   [3:0]   s0_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite wvalid           "*) input  wire           s0_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite wready           "*) output wire           s0_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite bresp            "*) output wire   [1:0]   s0_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite bvalid           "*) output wire           s0_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite bready           "*) input  wire           s0_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite araddr           "*) input  wire   [15:0]  s0_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite arvalid          "*) input  wire           s0_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite arready          "*) output wire           s0_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite rdata            "*) output wire   [31:0]  s0_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite rresp            "*) output wire   [1:0]   s0_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite rvalid           "*) output wire           s0_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 s0_lite rready           "*) input  wire           s0_rready;
     
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite awaddr           "*) output wire   [15:0]  m0_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite awvalid          "*) output wire           m0_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite awready          "*) input  wire           m0_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite wdata            "*) output wire   [31:0]  m0_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite wstrb            "*) output wire   [3:0]   m0_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite wvalid           "*) output wire           m0_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite wready           "*) input  wire           m0_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite bresp            "*) input  wire   [1:0]   m0_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite bvalid           "*) input  wire           m0_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite bready           "*) output wire           m0_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite araddr           "*) output wire   [15:0]  m0_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite arvalid          "*) output wire           m0_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite arready          "*) input  wire           m0_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite rdata            "*) input  wire   [31:0]  m0_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite rresp            "*) input  wire   [1:0]   m0_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite rvalid           "*) input  wire           m0_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm_rtl:1.0 m0_lite rready           "*) output wire           m0_rready;

  input  wire           aclk;
  input  wire           aresetn;
  output reg            addrDataSeen;

  reg         s0_awvalid_0;
  reg         s0_awready_0;
  reg [15:0]  s0_awaddr_0;
  reg         s0_wvalid_0;
  reg         s0_wready_0;
  reg         s0_wdata_0;
  reg         s0_wstrb_0;
  
  reg         addr_seen;
  reg         data_seen;
  reg  [2:0]  watch_dog;
  reg         timeout;
  
  assign  m0_awaddr  = s0_awaddr;
  assign  m0_awvalid = s0_awvalid;
  assign  s0_awready = m0_awready;
  assign  m0_wdata   = s0_wdata;
  assign  m0_wstrb   = s0_wstrb;
  assign  m0_wvalid  = s0_wvalid;
  assign  s0_wready  = m0_wready;
  assign  s0_bresp   = m0_bresp;
  assign  s0_bvalid  = m0_bvalid;
  assign  m0_bready  = s0_bready;
  assign  m0_araddr  = s0_araddr;
  assign  m0_arvalid = s0_arvalid;
  assign  s0_arready = m0_arready;
  assign  s0_rdata   = m0_rdata;
  assign  s0_rresp   = m0_rresp;
  assign  s0_rvalid  = m0_rvalid;
  assign  m0_rready  = s0_rready;
  
  always@(posedge aclk) begin
    // Register inputs...
    s0_awvalid_0  <= s0_awvalid;
    s0_awready_0  <= s0_awready;
    s0_awaddr_0   <= s0_awaddr[15:0];
    s0_wvalid_0   <= s0_wvalid;
    s0_wready_0   <= s0_wready;
    s0_wdata_0    <= s0_wdata[0];
    s0_wstrb_0    <= s0_wstrb[0];
  
    if (~addr_seen && s0_awvalid_0 && s0_awready_0 && s0_awaddr_0 == 16'h6010)
      addr_seen <= 1;
    else if ((addr_seen && data_seen) || timeout)
      addr_seen <= 0;
    
    if (~data_seen && s0_wvalid_0 && s0_wready_0 && s0_wdata_0 && s0_wstrb_0)
      data_seen <= 1;
    else if ((addr_seen && data_seen) || timeout)
      data_seen <= 0;
    
    if (s0_awvalid_0 && s0_awready_0)
      watch_dog <= 3'd7;
    else if (watch_dog > 0)
      watch_dog <= watch_dog - 1;
      
    timeout <= 0;
    if (watch_dog == 1)
      timeout <= 1;
      
    addrDataSeen <= 0;
    if (addr_seen && data_seen)
      addrDataSeen <= 1;
      
    if (~aresetn) begin
      watch_dog     <= 0;
      addr_seen     <= 0;
      data_seen     <= 0;
    end
  end
endmodule
