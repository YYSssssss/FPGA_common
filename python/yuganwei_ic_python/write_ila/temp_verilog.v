`ifdef FPGA_ILA 

wire    [1-1:0]    ila_1’b1 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_hreset /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HREADYS0 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HSELS0 /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HADDRS0 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HWRITES0 /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HRDATAS0 /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HWDATAS0 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HREADYOUTS0 /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_HRESPS0 /* synthesis syn_keep=1 */;  
wire    [3-1:0]    ila_HSIZES0 /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_HTRANSS0 /* synthesis syn_keep=1 */;  
assign ila_1’b1 = 1’b1;  
assign ila_hreset = hreset;  
assign ila_HREADYS0 = HREADYS0;  
assign ila_HSELS0 = HSELS0;  
assign ila_HADDRS0 = HADDRS0;  
assign ila_HWRITES0 = HWRITES0;  
assign ila_HRDATAS0 = HRDATAS0;  
assign ila_HWDATAS0 = HWDATAS0;  
assign ila_HREADYOUTS0 = HREADYOUTS0;  
assign ila_HRESPS0 = HRESPS0;  
assign ila_HSIZES0 = HSIZES0;  
assign ila_HTRANSS0 = HTRANSS0;  

ina_2 u_ina_2 ( 
    .clk (clk) //hclk
    .probe0 (1’b1), //[1-1:0]
    .probe1 (hreset), //[1-1:0]
    .probe2 (HREADYS0), //[1-1:0]
    .probe3 (HSELS0), //[1-1:0]
    .probe4 (HADDRS0), //[32-1:0]
    .probe5 (HWRITES0), //[1-1:0]
    .probe6 (HRDATAS0), //[32-1:0]
    .probe7 (HWDATAS0), //[32-1:0]
    .probe8 (HREADYOUTS0), //[1-1:0]
    .probe9 (HRESPS0), //[2-1:0]
    .probe10 (HSIZES0), //[3-1:0]
    .probe11 (HTRANSS0) //[2-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

`ifdef FPGA_ILA 

wire    [1-1:0]    ila_1’b1 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_hreset /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HADDRS_BRG /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HWRITES_BRG /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HRDATAS_BRG /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HWDATAS_BRG /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HREADYOUTS_BRG /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_HTRANSS_BRG /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_HRESPS_BRG /* synthesis syn_keep=1 */;  
assign ila_1’b1 = 1’b1;  
assign ila_hreset = hreset;  
assign ila_HADDRS_BRG = HADDRS_BRG;  
assign ila_HWRITES_BRG = HWRITES_BRG;  
assign ila_HRDATAS_BRG = HRDATAS_BRG;  
assign ila_HWDATAS_BRG = HWDATAS_BRG;  
assign ila_HREADYOUTS_BRG = HREADYOUTS_BRG;  
assign ila_HTRANSS_BRG = HTRANSS_BRG;  
assign ila_HRESPS_BRG = HRESPS_BRG;  

ina_3 u_ina_3 ( 
    .clk (clk) //clk
    .probe0 (1’b1), //[1-1:0]
    .probe1 (hreset), //[1-1:0]
    .probe2 (HADDRS_BRG), //[32-1:0]
    .probe3 (HWRITES_BRG), //[1-1:0]
    .probe4 (HRDATAS_BRG), //[32-1:0]
    .probe5 (HWDATAS_BRG), //[32-1:0]
    .probe6 (HREADYOUTS_BRG), //[1-1:0]
    .probe7 (HTRANSS_BRG), //[2-1:0]
    .probe8 (HRESPS_BRG) //[2-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

`ifdef FPGA_ILA 

wire    [1-1:0]    ila_1’b1 /* synthesis syn_keep=1 */;  
wire    [128-1:0]    ila_i_m0_rd_data_A /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_o_m0_rd_en_A /* synthesis syn_keep=1 */;  
wire    [18-1:0]    ila_o_m0_rd_addr_A /* synthesis syn_keep=1 */;  
wire    [16-1:0]    ila_o_m1_wea_A /* synthesis syn_keep=1 */;  
wire    [128-1:0]    ila_o_m1_wr_data_A /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_o_m1_wr_en_A /* synthesis syn_keep=1 */;  
wire    [18-1:0]    ila_o_m1_wr_addr_A /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_mon_core_start_pls /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_mon_core_finish /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_atb_core_start /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_core_finish /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_ctrl_mon_sel /* synthesis syn_keep=1 */;  
assign ila_1’b1 = 1’b1;  
assign ila_i_m0_rd_data_A = i_m0_rd_data_A;  
assign ila_o_m0_rd_en_A = o_m0_rd_en_A;  
assign ila_o_m0_rd_addr_A = o_m0_rd_addr_A;  
assign ila_o_m1_wea_A = o_m1_wea_A;  
assign ila_o_m1_wr_data_A = o_m1_wr_data_A;  
assign ila_o_m1_wr_en_A = o_m1_wr_en_A;  
assign ila_o_m1_wr_addr_A = o_m1_wr_addr_A;  
assign ila_mon_core_start_pls = mon_core_start_pls;  
assign ila_mon_core_finish = mon_core_finish;  
assign ila_atb_core_start = atb_core_start;  
assign ila_core_finish = core_finish;  
assign ila_ctrl_mon_sel = ctrl_mon_sel;  

ina_4 u_ina_4 ( 
    .clk (clk) //clk
    .probe0 (1’b1), //[1-1:0]
    .probe1 (i_m0_rd_data_A), //[128-1:0]
    .probe2 (o_m0_rd_en_A), //[1-1:0]
    .probe3 (o_m0_rd_addr_A), //[18-1:0]
    .probe4 (o_m1_wea_A), //[16-1:0]
    .probe5 (o_m1_wr_data_A), //[128-1:0]
    .probe6 (o_m1_wr_en_A), //[1-1:0]
    .probe7 (o_m1_wr_addr_A), //[18-1:0]
    .probe8 (mon_core_start_pls), //[1-1:0]
    .probe9 (mon_core_finish), //[1-1:0]
    .probe10 (atb_core_start), //[1-1:0]
    .probe11 (core_finish), //[1-1:0]
    .probe12 (ctrl_mon_sel) //[1-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

`ifdef FPGA_ILA 

wire    [32-1:0]    ila_HRDATAM1 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HREADYOUTM1 /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_HRESPM1 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HSELM1 /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HADDRM1 /* synthesis syn_keep=1 */;  
wire    [2-1:0]    ila_HTRANSM1 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HWRITEM1 /* synthesis syn_keep=1 */;  
wire    [3-1:0]    ila_HSIZEM1 /* synthesis syn_keep=1 */;  
wire    [3-1:0]    ila_HBURSTM1 /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HWDATAM1 /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_HREADYMUXM1 /* synthesis syn_keep=1 */;  
wire    [32-1:0]    ila_HADDRM1_less /* synthesis syn_keep=1 */;  
wire    [1-1:0]    ila_ctrl_mon_sel /* synthesis syn_keep=1 */;  
assign ila_HRDATAM1 = HRDATAM1;  
assign ila_HREADYOUTM1 = HREADYOUTM1;  
assign ila_HRESPM1 = HRESPM1;  
assign ila_HSELM1 = HSELM1;  
assign ila_HADDRM1 = HADDRM1;  
assign ila_HTRANSM1 = HTRANSM1;  
assign ila_HWRITEM1 = HWRITEM1;  
assign ila_HSIZEM1 = HSIZEM1;  
assign ila_HBURSTM1 = HBURSTM1;  
assign ila_HWDATAM1 = HWDATAM1;  
assign ila_HREADYMUXM1 = HREADYMUXM1;  
assign ila_HADDRM1_less = HADDRM1_less;  
assign ila_ctrl_mon_sel = ctrl_mon_sel;  

ina_5 u_ina_5 ( 
    .clk (clk) //hclk
    .probe0 (HRDATAM1), //[32-1:0]
    .probe1 (HREADYOUTM1), //[1-1:0]
    .probe2 (HRESPM1), //[2-1:0]
    .probe3 (HSELM1), //[1-1:0]
    .probe4 (HADDRM1), //[32-1:0]
    .probe5 (HTRANSM1), //[2-1:0]
    .probe6 (HWRITEM1), //[1-1:0]
    .probe7 (HSIZEM1), //[3-1:0]
    .probe8 (HBURSTM1), //[3-1:0]
    .probe9 (HWDATAM1), //[32-1:0]
    .probe10 (HREADYMUXM1), //[1-1:0]
    .probe11 (HADDRM1_less), //[32-1:0]
    .probe12 (ctrl_mon_sel) //[1-1:0]
)/* synthesis syn_noprune=1 */; 

`endif 

