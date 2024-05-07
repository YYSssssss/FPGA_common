//-----------------------------------------------------------------------------
// File: rsp_s2_dma_ahb_mux.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: rsp ahbic
// Modification history:
// $Log$
//   Jichen 4/20/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

module  rsp_s2_dma_ahb_mux #(
  parameter N_CH = 5,
  parameter AHB_DW = 32,
  parameter AHB_AW = 32
)
(
  input                            hclk,
  input                            hreset,
                                         
  input                            hsel,
  input  [1:0]                     htrans,
  input  [AHB_AW-1:0]              haddr,
  input  [2:0]                     hburst,
  input  [2:0]                     hsize,
  input  [AHB_DW-1:0]              hwdata,
  input                            hwrite,
  input                            hreadyin,
  output [AHB_DW-1:0]              hrdata,
  output [1:0]                     hresp,
  output                           hready,
                                        
  output [N_CH-1:0]                ch_hsel,
  output [N_CH*2-1:0]              ch_htrans,
  output [N_CH*AHB_AW-1:0]         ch_haddr,
  output [N_CH*3-1:0]              ch_hburst,
  output [N_CH*3-1:0]              ch_hsize,
  output [N_CH*AHB_DW-1:0]         ch_hwdata,
  output [N_CH-1:0]                ch_hwrite,
  output [N_CH-1:0]                ch_hreadyin,
  input  [N_CH*AHB_DW-1:0]         ch_hrdata,
  input  [N_CH*2-1:0]              ch_hresp,
  input  [N_CH-1:0]                ch_hready
);
 
localparam [AHB_AW-1:0] AHB_ADDR_MASK = 'h000003FF;

wire [N_CH*AHB_AW-1:0] ch_haddr_unmask;

generate if (N_CH==5) begin: inst_rsp_ahbic_ch5
rsp_s2_dma_ahbic u_rsp_s2_dma_ahbic (
  // Common AHB signals
  .HCLK          (hclk),
  .HRESETn       (~hreset),

  // System address remapping control
  .REMAP         (),

  // Input port SI0 (inputs from master 0)
  .HSELS0        (hsel),
  .HADDRS0       (haddr),
  .HTRANSS0      (htrans),
  .HWRITES0      (hwrite),
  .HSIZES0       (hsize),
  .HBURSTS0      (hburst),
  .HPROTS0       (4'b0),
  .HMASTERS0     (4'b0),
  .HWDATAS0      (hwdata),
  .HMASTLOCKS0   (1'b0),
  .HREADYS0      (hreadyin),

  // Output port MI0 (inputs from slave 0)
  .HRDATAM0      (ch_hrdata[0+:AHB_DW]),
  .HREADYOUTM0   (ch_hready[0]),
  .HRESPM0       (ch_hresp[0+:2]),

  // Output port MI1 (inputs from slave 1)
  .HRDATAM1      (ch_hrdata[AHB_DW+:AHB_DW]),
  .HREADYOUTM1   (ch_hready[1]),
  .HRESPM1       (ch_hresp[2+:2]),

  // Output port MI2 (inputs from slave 2)
  .HRDATAM2      (ch_hrdata[AHB_DW*2+:AHB_DW]),
  .HREADYOUTM2   (ch_hready[2]),
  .HRESPM2       (ch_hresp[2*2+:2]),

  // Output port MI3 (inputs from slave 3)
  .HRDATAM3      (ch_hrdata[AHB_DW*3+:AHB_DW]),
  .HREADYOUTM3   (ch_hready[3]),
  .HRESPM3       (ch_hresp[2*3+:2]),

  // Output port MI4 (inputs from slave 4)
  .HRDATAM4      (ch_hrdata[AHB_DW*4+:AHB_DW]),
  .HREADYOUTM4   (ch_hready[4]),
  .HRESPM4       (ch_hresp[2*4+:2]),

  // Scan test dummy signals; not connected until scan insertion
  .SCANENABLE    (),   // Scan Test Mode Enable
  .SCANINHCLK    (),   // Scan Chain Input


  // Output port MI0 (outputs to slave 0)
  .HSELM0        (ch_hsel[0]),
  .HADDRM0       (ch_haddr_unmask[0+:AHB_AW]),
  .HTRANSM0      (ch_htrans[0+:2]),
  .HWRITEM0      (ch_hwrite[0]),
  .HSIZEM0       (ch_hsize[0+:3]),
  .HBURSTM0      (ch_hburst[0+:3]),
  .HPROTM0       (),
  .HMASTERM0     (),
  .HWDATAM0      (ch_hwdata[0+:AHB_DW]),
  .HMASTLOCKM0   (),
  .HREADYMUXM0   (ch_hreadyin[0]),

  // Output port MI1 (outputs to slave 1)
  .HSELM1        (ch_hsel[1]),
  .HADDRM1       (ch_haddr_unmask[AHB_AW+:AHB_AW]),
  .HTRANSM1      (ch_htrans[2+:2]),
  .HWRITEM1      (ch_hwrite[1]),
  .HSIZEM1       (ch_hsize[3+:3]),
  .HBURSTM1      (ch_hburst[3+:3]),
  .HPROTM1       (),
  .HMASTERM1     (),
  .HWDATAM1      (ch_hwdata[AHB_DW+:AHB_DW]),
  .HMASTLOCKM1   (),
  .HREADYMUXM1   (ch_hreadyin[1]),

  // Output port MI2 (outputs to slave 2)
  .HSELM2        (ch_hsel[2]),
  .HADDRM2       (ch_haddr_unmask[AHB_AW*2+:AHB_AW]),
  .HTRANSM2      (ch_htrans[2*2+:2]),
  .HWRITEM2      (ch_hwrite[2]),
  .HSIZEM2       (ch_hsize[3*2+:3]),
  .HBURSTM2      (ch_hburst[3*2+:3]),
  .HPROTM2       (),
  .HMASTERM2     (),
  .HWDATAM2      (ch_hwdata[AHB_DW*2+:AHB_DW]),
  .HMASTLOCKM2   (),
  .HREADYMUXM2   (ch_hreadyin[2]),

  // Output port MI3 (outputs to slave 3)
  .HSELM3        (ch_hsel[3]),
  .HADDRM3       (ch_haddr_unmask[AHB_AW*3+:AHB_AW]),
  .HTRANSM3      (ch_htrans[2*3+:2]),
  .HWRITEM3      (ch_hwrite[3]),
  .HSIZEM3       (ch_hsize[3*3+:3]),
  .HBURSTM3      (ch_hburst[3*3+:3]),
  .HPROTM3       (),
  .HMASTERM3     (),
  .HWDATAM3      (ch_hwdata[AHB_DW*3+:AHB_DW]),
  .HMASTLOCKM3   (),
  .HREADYMUXM3   (ch_hreadyin[3]),

  // Output port MI4 (outputs to slave 4)
  .HSELM4        (ch_hsel[4]),
  .HADDRM4       (ch_haddr_unmask[AHB_AW*4+:AHB_AW]),
  .HTRANSM4      (ch_htrans[2*4+:2]),
  .HWRITEM4      (ch_hwrite[4]),
  .HSIZEM4       (ch_hsize[3*4+:3]),
  .HBURSTM4      (ch_hburst[3*4+:3]),
  .HPROTM4       (),
  .HMASTERM4     (),
  .HWDATAM4      (ch_hwdata[AHB_DW*4+:AHB_DW]),
  .HMASTLOCKM4   (),
  .HREADYMUXM4   (ch_hreadyin[4]),

  // Input port SI0 (outputs to master 0)
  .HRDATAS0      (hrdata),
  .HREADYOUTS0   (hready),
  .HRESPS0       (hresp),

  // Scan test dummy signals; not connected until scan insertion
  .SCANOUTHCLK   ()   // Scan Chain Output
  );
end else begin: inst_no_rsp_s2_power_ahbic
//synopsys translate_off
initial begin
  $display("Error: No rsp_s2_power_ahbic is inferred, please check your parameters"); 
end
//synopsys translate_on
end
endgenerate
   
generate for(genvar i=0; i<N_CH; i=i+1) begin: asgn_ch_haddr
assign ch_haddr[AHB_AW*i+:AHB_AW] = ch_haddr_unmask[AHB_AW*i+:AHB_AW] & AHB_ADDR_MASK;
end
endgenerate

endmodule