`ifdef FPGA_ILA 

wire    [1-1:0]    ila_name0 /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_name1 /* synthesis syn_keep=1 */;  
wire    [3-1:0]    ila_name2 /* synthesis syn_keep=1 */;  
wire    [4-1:0]    ila_name3 /* synthesis syn_keep=1 */;  
wire    [5-1:0]    ila_name4 /* synthesis syn_keep=1 */;  
wire    [6-1:0]    ila_name5 /* synthesis syn_keep=1 */;  
assign ila_name0 = name0;  
assign ila_name1 = name1;  
assign ila_name2 = name2;  
assign ila_name3 = name3;  
assign ila_name4 = name4;  
assign ila_name5 = name5;  

ILA_NAME1 u_ILA_NAME1 ( 
    .probe0 (clk), //clk
    .probe1 (name0), //[1-1:0]
    .probe2 (name1), //[2-1:0]
    .probe3 (name2), //[3-1:0]
    .probe4 (name3), //[4-1:0]
    .probe5 (name4), //[5-1:0]
    .probe6 (name5) //[6-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

`ifdef FPGA_ILA 

wire    [1-1:0]    ila_name0 /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_name1 /* synthesis syn_keep=1 */;  
wire    [3-1:0]    ila_name2 /* synthesis syn_keep=1 */;  
wire    [4-1:0]    ila_name3 /* synthesis syn_keep=1 */;  
wire    [5-1:0]    ila_name4 /* synthesis syn_keep=1 */;  
wire    [6-1:0]    ila_name5 /* synthesis syn_keep=1 */;  
assign ila_name0 = name0;  
assign ila_name1 = name1;  
assign ila_name2 = name2;  
assign ila_name3 = name3;  
assign ila_name4 = name4;  
assign ila_name5 = name5;  

test2 u_test2 ( 
    .probe0 (clk), //clk
    .probe1 (name0), //[1-1:0]
    .probe2 (name1), //[2-1:0]
    .probe3 (name2), //[3-1:0]
    .probe4 (name3), //[4-1:0]
    .probe5 (name4), //[5-1:0]
    .probe6 (name5) //[6-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

