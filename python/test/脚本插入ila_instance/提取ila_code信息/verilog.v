module asdhi();




fjdisifjidsffjdsfjidsj

fidfjdisdjfidsjfidsj

fdisfjidsjfidsjfids




`ifdef FPGA_ILA 

wire    [1-1:0]    ila_name0 /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_name1 /* synthesis syn_keep=1 */;  
wire    [3-1:0]    ila_name2 /* synthesis syn_keep=1 */;  
wire    [4-1:0]    ila_name3 /* synthesis syn_keep=1 */;  
wire    [5-1:0]    ila_name4 /* synthesis syn_keep=1 */;  
assign ila_name0 = name0;  
assign ila_name1 = name1;  
assign ila_name2 = name2;  
assign ila_name3 = name3;  
assign ila_name4 = name4;  

ILA_NAME0 u_ILA_NAME0 ( 
    .probe0 (clk), //clk
    .probe1 (name0), //[1-1:0]
    .probe2 (name1), //[2-1:0]
    .probe3 (name2), //[3-1:0]
    .probe4 (name3), //[4-1:0]
    .probe5 (name4) //[5-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

`ifdef FPGA_ILA 

wire    [125-1:0]    ila_dsa0 /* synthesis syn_keep=1 */;  
wire    [126-1:0]    ila_dsa1 /* synthesis syn_keep=1 */;  
wire    [127-1:0]    ila_dsa2 /* synthesis syn_keep=1 */;  
wire    [128-1:0]    ila_dsa3 /* synthesis syn_keep=1 */;  
wire    [129-1:0]    ila_dsa4 /* synthesis syn_keep=1 */;  
assign ila_dsa0 = dsa0;  
assign ila_dsa1 = dsa1;  
assign ila_dsa2 = dsa2;  
assign ila_dsa3 = dsa3;  
assign ila_dsa4 = dsa4;  

q123 u_q123 ( 
    .probe0 (clk), //clk
    .probe1 (dsa0), //[125-1:0]
    .probe2 (dsa1), //[126-1:0]
    .probe3 (dsa2), //[127-1:0]
    .probe4 (dsa3), //[128-1:0]
    .probe5 (dsa4) //[129-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

`ifdef FPGA_ILA 

wire    [125-1:0]    ila_dsa0 /* synthesis syn_keep=1 */;  
wire    [126-1:0]    ila_dsa1 /* synthesis syn_keep=1 */;  
wire    [127-1:0]    ila_dsa2 /* synthesis syn_keep=1 */;  
wire    [128-1:0]    ila_dsa3 /* synthesis syn_keep=1 */;  
wire    [129-1:0]    ila_dsa4 /* synthesis syn_keep=1 */;  
assign ila_dsa0 = dsa0;  
assign ila_dsa1 = dsa1;  
assign ila_dsa2 = dsa2;  
assign ila_dsa3 = dsa3;  
assign ila_dsa4 = dsa4;  

ILA_NAME_test u_ILA_NAME_test ( 
    .probe0 (clk), //clk
    .probe1 (dsa0), //[125-1:0]
    .probe2 (dsa1), //[126-1:0]
    .probe3 (dsa2), //[127-1:0]
    .probe4 (dsa3), //[128-1:0]
    .probe5 (dsa4) //[129-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 


endmodule