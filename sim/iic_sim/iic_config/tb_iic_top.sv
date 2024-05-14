`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/04/12 14:29:34
// Design Name: 
// Module Name: tb_iic_top
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


module tb_iic_top(
inout sda,
inout scl,
inout sda_camera,
inout scl_camera
);

logic rst_n;
logic clk_50m;
logic clk_75m;
logic clk_100m;
logic clk_150m;
logic clk_200m;
logic clk_250m;
logic clk_300m;
logic clk_400m;
logic clk_500m;
logic clk;
//logic scl;
//inout sda;
logic iic_config_start;



///////////////////////////////////////////////////////

initial begin
#0  
iic_config_start = 0;
rst_n=0;
clk=0;
clk_50m=0;
clk_75m=0;
clk_100m=0;
clk_150m=0;
clk_200m=0;
clk_250m=0;
clk_300m=0;
clk_400m=0;
clk_500m=0;
#10000
rst_n=1;
#10000
iic_config_start = 1;

//#800000
//$stop;

end

always #1  clk      = ~clk; // 200M
always #10   clk_50m  = ~clk_50m;  // 50M
always #6.67 clk_75m  = ~clk_75m;  // 75M
always #5    clk_100m = ~clk_100m; // 100M
always #3.33 clk_150m = ~clk_150m; // 150M
always #2.5  clk_200m = ~clk_200m; // 200M
always #2    clk_250m = ~clk_250m; // 250M
always #1.67 clk_300m = ~clk_300m; // 300M
always #1.25 clk_400m = ~clk_400m; // 400M
always #1    clk_500m = ~clk_500m; // 500M





IR_IIC_top u_ir_IIC_top(
.clk               (clk_50m),
.rst_n             (rst_n),
.iic_config_start  (iic_config_start),
.scl               (scl),
.sda               (sda)
);

CAMERA_IIC_top u_camera_IIC_top(
.clk               (clk_50m),
.rst_n             (rst_n),
.iic_config_start  (iic_config_start),
.scl               (scl_camera),
.sda               (sda_camera)
);





endmodule
