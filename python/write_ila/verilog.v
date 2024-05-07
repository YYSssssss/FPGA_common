module asdhi();




fjdisifjidsffjdsfjidsj

fidfjdisdjfidsjfidsj

fdisfjidsjfidsjfids




`ifdef FPGA_ILA 

wire    clk    ila_clk /* synthesis syn_keep=1 */;  
wire    [125-1:0]    ila_dsa0 /* synthesis syn_keep=1 */;  
wire    [126-1:0]    ila_dsa1 /* synthesis syn_keep=1 */;  
wire    [127-1:0]    ila_dsa2 /* synthesis syn_keep=1 */;  
wire    [128-1:0]    ila_dsa3 /* synthesis syn_keep=1 */;  
wire    [129-1:0]    ila_dsa4 /* synthesis syn_keep=1 */;  
assign ila_clk = clk;  
assign ila_dsa0 = dsa0;  
assign ila_dsa1 = dsa1;  
assign ila_dsa2 = dsa2;  
assign ila_dsa3 = dsa3;  
assign ila_dsa4 = dsa4;  

ILA_NAME_test u_ILA_NAME_test ( 
    .clk (clk) //clk
    .probe0 (clk), //clk
    .probe1 (dsa0), //[125-1:0]
    .probe2 (dsa1), //[126-1:0]
    .probe3 (dsa2), //[127-1:0]
    .probe4 (dsa3), //[128-1:0]
    .probe5 (dsa4) //[129-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 


endmodule