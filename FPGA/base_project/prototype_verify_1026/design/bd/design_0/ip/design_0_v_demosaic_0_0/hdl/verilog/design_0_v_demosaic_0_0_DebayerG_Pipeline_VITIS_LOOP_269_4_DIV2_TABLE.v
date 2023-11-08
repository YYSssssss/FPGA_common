// ==============================================================
// Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1 ns / 1 ps
module design_0_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_269_4_DIV2_TABLE (
address0, ce0, q0, address1, ce1, q1, address2, ce2, q2, address3, ce3, q3, reset,clk);

parameter DataWidth = 18;
parameter AddressWidth = 12;
parameter AddressRange = 4096;

input[AddressWidth-1:0] address0;
input ce0;
output reg[DataWidth-1:0] q0;
input[AddressWidth-1:0] address1;
input ce1;
output reg[DataWidth-1:0] q1;
input[AddressWidth-1:0] address2;
input ce2;
output reg[DataWidth-1:0] q2;
input[AddressWidth-1:0] address3;
input ce3;
output reg[DataWidth-1:0] q3;
input reset;
input clk;

reg [DataWidth-1:0] ram0[0:AddressRange-1];
reg [DataWidth-1:0] ram1[0:AddressRange-1];

initial begin
    $readmemh("./design_0_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_269_4_DIV2_TABLE.dat", ram0);
    $readmemh("./design_0_v_demosaic_0_0_DebayerG_Pipeline_VITIS_LOOP_269_4_DIV2_TABLE.dat", ram1);
end



always @(posedge clk)  
begin 
    if (ce0) 
    begin
        q0 <= ram0[address0];
    end
end



always @(posedge clk)  
begin 
    if (ce1) 
    begin
        q1 <= ram0[address1];
    end
end



always @(posedge clk)  
begin 
    if (ce2) 
    begin
        q2 <= ram1[address2];
    end
end



always @(posedge clk)  
begin 
    if (ce3) 
    begin
        q3 <= ram1[address3];
    end
end



endmodule

