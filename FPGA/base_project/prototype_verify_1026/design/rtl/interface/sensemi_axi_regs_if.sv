// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.
// -------------------------------------------------------------------------- //
// Name         : M Faizan
// Date         : 5/28/20
// File         : jb_axi_regs_if.sv
// Design       : 
// Purpose      : 
// Device       : xczu47dr-fsve1156-2-i-es1
// -------------------------------------------------------------------------- //

interface sensemi_axi_regs_if #( 
    parameter   AXI_ADDR_WIDTH  = 13,
    parameter   AXI_DATA_WIDTH  = 32
);

    localparam  ADDR_LSB = (AXI_DATA_WIDTH/32) + 1;

    logic                                   wren;
    logic   [AXI_ADDR_WIDTH-ADDR_LSB-1:0]   wr_offset;
    logic   [AXI_DATA_WIDTH-1 : 0]          wdata;
    logic                                   rden;
    logic   [AXI_ADDR_WIDTH-ADDR_LSB-1:0]   rd_offset;
    logic   [AXI_DATA_WIDTH-1 : 0] 		    rdata;

modport master ( 
    input   rdata, 
    output  wren,
            wr_offset,
            wdata,
            rden,
            rd_offset
);

modport slave (
    input   wren,
            wr_offset,
            wdata,
            rden,
            rd_offset,
    output  rdata
);

endinterface
