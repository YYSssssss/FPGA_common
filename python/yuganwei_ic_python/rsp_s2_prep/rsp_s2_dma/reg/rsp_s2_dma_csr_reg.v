// AUTO GENERATED. DO NOT EDIT Sun Mar 17 09:20:31 2024
module rsp_s2_dma_csr_reg (
    gm0_slen,
    gm1_scnt,
    gm2_fcnt,
    gm3_pcnt,
    gm4_outs_max,
    gm4_burst_len,
    gm5_base_addr,
    gm6_sidx,
    gm7_fidx,
    gm8_timeout_cnt,
    gm9_axi_id,
    lm0_slen,
    lm1_scnt,
    lm2_fcnt,
    lm3_pcnt,
    lm4_outs_max,
    lm4_burst_len,
    lm5_base_addr,
    lm6_sidx,
    lm7_fidx,
    lm8_timeout_cnt,
    lm9_axi_id,
    en_decomp,
    en_index,
    index_base_addr,
    fsm_mem_claim,
    fsm_mem_pipo_num_wr,
    fsm_mem_pipo_num_rd,
    fsm_mem_base_idx_wr,
    fsm_mem_base_idx_rd,

    hclk        ,
    hreset      ,
    hsel        ,
    htrans      ,
    haddr       ,
    //hburst      ,
    //hsize       ,
    hwdata      ,
    hwrite      ,
    hrdata      ,
    hreadyin    ,
    hresp       ,
    hready       

);
output [15:0]     gm0_slen;
output [13:0]     gm1_scnt;
output [13:0]     gm2_fcnt;
output [7:0]      gm3_pcnt;
output [7:0]      gm4_outs_max;
output [7:0]      gm4_burst_len;
output [31:0]     gm5_base_addr;
output [31:0]     gm6_sidx;
output [31:0]     gm7_fidx;
output [11:0]     gm8_timeout_cnt;
output [7:0]      gm9_axi_id;
output [15:0]     lm0_slen;
output [13:0]     lm1_scnt;
output [13:0]     lm2_fcnt;
output [7:0]      lm3_pcnt;
output [7:0]      lm4_outs_max;
output [7:0]      lm4_burst_len;
output [27:0]     lm5_base_addr;
output [27:0]     lm6_sidx;
output [27:0]     lm7_fidx;
output [11:0]     lm8_timeout_cnt;
output [7:0]      lm9_axi_id;
output            en_decomp;
output            en_index;
output [27:0]     index_base_addr;
output            fsm_mem_claim;
output [2:0]      fsm_mem_pipo_num_wr;
output [2:0]      fsm_mem_pipo_num_rd;
output [4:0]      fsm_mem_base_idx_wr;
output [4:0]      fsm_mem_base_idx_rd;

input             hclk        ;
input             hreset      ;
input             hsel        ;
input  [1:0]      htrans      ;
input  [31:0]     haddr       ;
//input  [2:0]      hburst      ;
//input  [2:0]      hsize       ;
input  [31:0]     hwdata      ;
input             hwrite      ;
input             hreadyin    ;
output [31:0]     hrdata      ;
output [1:0]      hresp       ;
output            hready      ;

reg               write_gm0_en_reg;
reg    [15:0]     gm0_slen_reg;
reg               write_gm1_en_reg;
reg    [13:0]     gm1_scnt_reg;
reg               write_gm2_en_reg;
reg    [13:0]     gm2_fcnt_reg;
reg               write_gm3_en_reg;
reg    [7:0]      gm3_pcnt_reg;
reg               write_gm4_en_reg;
reg    [7:0]      gm4_outs_max_reg;
reg    [7:0]      gm4_burst_len_reg;
reg               write_gm5_en_reg;
reg    [31:0]     gm5_base_addr_reg;
reg               write_gm6_en_reg;
reg    [31:0]     gm6_sidx_reg;
reg               write_gm7_en_reg;
reg    [31:0]     gm7_fidx_reg;
reg               write_gm8_en_reg;
reg    [11:0]     gm8_timeout_cnt_reg;
reg               write_gm9_en_reg;
reg    [7:0]      gm9_axi_id_reg;
reg               write_lm0_en_reg;
reg    [15:0]     lm0_slen_reg;
reg               write_lm1_en_reg;
reg    [13:0]     lm1_scnt_reg;
reg               write_lm2_en_reg;
reg    [13:0]     lm2_fcnt_reg;
reg               write_lm3_en_reg;
reg    [7:0]      lm3_pcnt_reg;
reg               write_lm4_en_reg;
reg    [7:0]      lm4_outs_max_reg;
reg    [7:0]      lm4_burst_len_reg;
reg               write_lm5_en_reg;
reg    [27:0]     lm5_base_addr_reg;
reg               write_lm6_en_reg;
reg    [27:0]     lm6_sidx_reg;
reg               write_lm7_en_reg;
reg    [27:0]     lm7_fidx_reg;
reg               write_lm8_en_reg;
reg    [11:0]     lm8_timeout_cnt_reg;
reg               write_lm9_en_reg;
reg    [7:0]      lm9_axi_id_reg;
reg               write_en_en_reg;
reg               en_decomp_reg;
reg               en_index_reg;
reg               write_index_en_reg;
reg    [27:0]     index_base_addr_reg;
reg               write_fsm_en_reg;
reg               fsm_mem_claim_reg;
reg    [2:0]      fsm_mem_pipo_num_wr_reg;
reg    [2:0]      fsm_mem_pipo_num_rd_reg;
reg    [4:0]      fsm_mem_base_idx_wr_reg;
reg    [4:0]      fsm_mem_base_idx_rd_reg;
wire              ahb_read_en,ahb_write_en;
wire              hready;
reg               last_write;
reg    [31:0]     hrdata;

assign gm0_slen                       = gm0_slen_reg;
assign gm1_scnt                       = gm1_scnt_reg;
assign gm2_fcnt                       = gm2_fcnt_reg;
assign gm3_pcnt                       = gm3_pcnt_reg;
assign gm4_outs_max                   = gm4_outs_max_reg;
assign gm4_burst_len                  = gm4_burst_len_reg;
assign gm5_base_addr                  = gm5_base_addr_reg;
assign gm6_sidx                       = gm6_sidx_reg;
assign gm7_fidx                       = gm7_fidx_reg;
assign gm8_timeout_cnt                = gm8_timeout_cnt_reg;
assign gm9_axi_id                     = gm9_axi_id_reg;
assign lm0_slen                       = lm0_slen_reg;
assign lm1_scnt                       = lm1_scnt_reg;
assign lm2_fcnt                       = lm2_fcnt_reg;
assign lm3_pcnt                       = lm3_pcnt_reg;
assign lm4_outs_max                   = lm4_outs_max_reg;
assign lm4_burst_len                  = lm4_burst_len_reg;
assign lm5_base_addr                  = lm5_base_addr_reg;
assign lm6_sidx                       = lm6_sidx_reg;
assign lm7_fidx                       = lm7_fidx_reg;
assign lm8_timeout_cnt                = lm8_timeout_cnt_reg;
assign lm9_axi_id                     = lm9_axi_id_reg;
assign en_decomp                      = en_decomp_reg;
assign en_index                       = en_index_reg;
assign index_base_addr                = index_base_addr_reg;
assign fsm_mem_claim                  = fsm_mem_claim_reg;
assign fsm_mem_pipo_num_wr            = fsm_mem_pipo_num_wr_reg;
assign fsm_mem_pipo_num_rd            = fsm_mem_pipo_num_rd_reg;
assign fsm_mem_base_idx_wr            = fsm_mem_base_idx_wr_reg;
assign fsm_mem_base_idx_rd            = fsm_mem_base_idx_rd_reg;
assign ahb_read_en                    = hsel & htrans[1] & !hwrite & hreadyin;
assign ahb_write_en                   = hsel & htrans[1] & hwrite & hreadyin;
assign hready                         = ~(last_write & hsel & htrans[1] & !hwrite);
assign hresp                          = 2'b0;

always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm0_en_reg    <= 1'b0;
    else 
        write_gm0_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h0;
end


//SW can read and write 
// GM SELN
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm0_slen_reg    <= 16'h0;
    else if(write_gm0_en_reg)
        gm0_slen_reg    <= hwdata[15:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm1_en_reg    <= 1'b0;
    else 
        write_gm1_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1;
end


//SW can read and write 
// GM SCNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm1_scnt_reg    <= 14'h0;
    else if(write_gm1_en_reg)
        gm1_scnt_reg    <= hwdata[13:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm2_en_reg    <= 1'b0;
    else 
        write_gm2_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h2;
end


//SW can read and write 
// GM FCNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm2_fcnt_reg    <= 14'h0;
    else if(write_gm2_en_reg)
        gm2_fcnt_reg    <= hwdata[13:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm3_en_reg    <= 1'b0;
    else 
        write_gm3_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h3;
end


//SW can read and write 
// GM PCNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm3_pcnt_reg    <= 8'h0;
    else if(write_gm3_en_reg)
        gm3_pcnt_reg    <= hwdata[7:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm4_en_reg    <= 1'b0;
    else 
        write_gm4_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h4;
end


//SW can read and write 
// GM OUTS MAX
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm4_outs_max_reg    <= 8'h0;
    else if(write_gm4_en_reg)
        gm4_outs_max_reg    <= hwdata[15:8];
end


//SW can read and write 
// GM BURST LEN
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm4_burst_len_reg    <= 8'h0;
    else if(write_gm4_en_reg)
        gm4_burst_len_reg    <= hwdata[7:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm5_en_reg    <= 1'b0;
    else 
        write_gm5_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h5;
end


//SW can read and write 
// GM BASE ADDRESS
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm5_base_addr_reg    <= 32'h0;
    else if(write_gm5_en_reg)
        gm5_base_addr_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm6_en_reg    <= 1'b0;
    else 
        write_gm6_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h6;
end


//SW can read and write 
// GM SIDX
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm6_sidx_reg    <= 32'h0;
    else if(write_gm6_en_reg)
        gm6_sidx_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm7_en_reg    <= 1'b0;
    else 
        write_gm7_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h7;
end


//SW can read and write 
// GM FIDX
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm7_fidx_reg    <= 32'h0;
    else if(write_gm7_en_reg)
        gm7_fidx_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm8_en_reg    <= 1'b0;
    else 
        write_gm8_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h8;
end


//SW can read and write 
// GM TIME OUT CNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm8_timeout_cnt_reg    <= 12'h7ff;
    else if(write_gm8_en_reg)
        gm8_timeout_cnt_reg    <= hwdata[11:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_gm9_en_reg    <= 1'b0;
    else 
        write_gm9_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h9;
end


//SW can read and write 
// GM AXI ID
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        gm9_axi_id_reg    <= 8'h0;
    else if(write_gm9_en_reg)
        gm9_axi_id_reg    <= hwdata[7:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm0_en_reg    <= 1'b0;
    else 
        write_lm0_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'hc;
end


//SW can read and write 
// LM SELN
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm0_slen_reg    <= 16'h0;
    else if(write_lm0_en_reg)
        lm0_slen_reg    <= hwdata[15:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm1_en_reg    <= 1'b0;
    else 
        write_lm1_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'hd;
end


//SW can read and write 
// LM SCNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm1_scnt_reg    <= 14'h0;
    else if(write_lm1_en_reg)
        lm1_scnt_reg    <= hwdata[13:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm2_en_reg    <= 1'b0;
    else 
        write_lm2_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'he;
end


//SW can read and write 
// LM FCNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm2_fcnt_reg    <= 14'h0;
    else if(write_lm2_en_reg)
        lm2_fcnt_reg    <= hwdata[13:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm3_en_reg    <= 1'b0;
    else 
        write_lm3_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'hf;
end


//SW can read and write 
// LM PCNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm3_pcnt_reg    <= 8'h0;
    else if(write_lm3_en_reg)
        lm3_pcnt_reg    <= hwdata[7:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm4_en_reg    <= 1'b0;
    else 
        write_lm4_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h10;
end


//SW can read and write 
// LM OUTS MAX
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm4_outs_max_reg    <= 8'h0;
    else if(write_lm4_en_reg)
        lm4_outs_max_reg    <= hwdata[15:8];
end


//SW can read and write 
// LM BURST LEN
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm4_burst_len_reg    <= 8'h0;
    else if(write_lm4_en_reg)
        lm4_burst_len_reg    <= hwdata[7:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm5_en_reg    <= 1'b0;
    else 
        write_lm5_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h11;
end


//SW can read and write 
// LM BASE ADDRESS
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm5_base_addr_reg    <= 28'h0;
    else if(write_lm5_en_reg)
        lm5_base_addr_reg    <= hwdata[27:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm6_en_reg    <= 1'b0;
    else 
        write_lm6_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h12;
end


//SW can read and write 
// LM SIDX
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm6_sidx_reg    <= 28'h0;
    else if(write_lm6_en_reg)
        lm6_sidx_reg    <= hwdata[27:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm7_en_reg    <= 1'b0;
    else 
        write_lm7_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h13;
end


//SW can read and write 
// LM FIDX
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm7_fidx_reg    <= 28'h0;
    else if(write_lm7_en_reg)
        lm7_fidx_reg    <= hwdata[27:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm8_en_reg    <= 1'b0;
    else 
        write_lm8_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h14;
end


//SW can read and write 
// LM TIME OUT CNT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm8_timeout_cnt_reg    <= 12'h7ff;
    else if(write_lm8_en_reg)
        lm8_timeout_cnt_reg    <= hwdata[11:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_lm9_en_reg    <= 1'b0;
    else 
        write_lm9_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h15;
end


//SW can read and write 
// LM AXI ID
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        lm9_axi_id_reg    <= 8'h0;
    else if(write_lm9_en_reg)
        lm9_axi_id_reg    <= hwdata[7:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_en_en_reg    <= 1'b0;
    else 
        write_en_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h16;
end


//SW can read and write 
// ENABLE DECOMPRESS
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        en_decomp_reg    <= 1'b0;
    else if(write_en_en_reg)
        en_decomp_reg    <= hwdata[8];
end


//SW can read and write 
// ENABLE INDEX
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        en_index_reg    <= 1'b0;
    else if(write_en_en_reg)
        en_index_reg    <= hwdata[0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_index_en_reg    <= 1'b0;
    else 
        write_index_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h17;
end


//SW can read and write 
// INDEX BASE ADDRESS
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        index_base_addr_reg    <= 28'h0;
    else if(write_index_en_reg)
        index_base_addr_reg    <= hwdata[27:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_fsm_en_reg    <= 1'b0;
    else 
        write_fsm_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h18;
end


//SW can read and write 
// MEM CLAIM
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        fsm_mem_claim_reg    <= 1'b0;
    else if(write_fsm_en_reg)
        fsm_mem_claim_reg    <= hwdata[16];
end


//SW can read and write 
// MEM PING PONG WR NUM
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        fsm_mem_pipo_num_wr_reg    <= 3'h0;
    else if(write_fsm_en_reg)
        fsm_mem_pipo_num_wr_reg    <= hwdata[15:13];
end


//SW can read and write 
// MEM PING PONG RD NUM
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        fsm_mem_pipo_num_rd_reg    <= 3'h0;
    else if(write_fsm_en_reg)
        fsm_mem_pipo_num_rd_reg    <= hwdata[12:10];
end


//SW can read and write 
// MEM PING PONG BASE WRITE
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        fsm_mem_base_idx_wr_reg    <= 5'h0;
    else if(write_fsm_en_reg)
        fsm_mem_base_idx_wr_reg    <= hwdata[9:5];
end


//SW can read and write 
// MEM PING PONG BASE READ
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        fsm_mem_base_idx_rd_reg    <= 5'h0;
    else if(write_fsm_en_reg)
        fsm_mem_base_idx_rd_reg    <= hwdata[4:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        last_write  <= 1'b0;
    else
        last_write  <= ahb_write_en;
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        hrdata      <= 32'h0;
    else if(ahb_read_en) begin
        hrdata      <= 32'h0;
        case(haddr[31:2]) 
            30'h0 : begin
                hrdata[15:0 ]    <= gm0_slen_reg;
            end
            30'h1 : begin
                hrdata[13:0 ]    <= gm1_scnt_reg;
            end
            30'h2 : begin
                hrdata[13:0 ]    <= gm2_fcnt_reg;
            end
            30'h3 : begin
                hrdata[7:0  ]    <= gm3_pcnt_reg;
            end
            30'h4 : begin
                hrdata[15:8 ]    <= gm4_outs_max_reg;
                hrdata[7:0  ]    <= gm4_burst_len_reg;
            end
            30'h5 : begin
                hrdata[31:0 ]    <= gm5_base_addr_reg;
            end
            30'h6 : begin
                hrdata[31:0 ]    <= gm6_sidx_reg;
            end
            30'h7 : begin
                hrdata[31:0 ]    <= gm7_fidx_reg;
            end
            30'h8 : begin
                hrdata[11:0 ]    <= gm8_timeout_cnt_reg;
            end
            30'h9 : begin
                hrdata[7:0  ]    <= gm9_axi_id_reg;
            end
            30'hc : begin
                hrdata[15:0 ]    <= lm0_slen_reg;
            end
            30'hd : begin
                hrdata[13:0 ]    <= lm1_scnt_reg;
            end
            30'he : begin
                hrdata[13:0 ]    <= lm2_fcnt_reg;
            end
            30'hf : begin
                hrdata[7:0  ]    <= lm3_pcnt_reg;
            end
            30'h10 : begin
                hrdata[15:8 ]    <= lm4_outs_max_reg;
                hrdata[7:0  ]    <= lm4_burst_len_reg;
            end
            30'h11 : begin
                hrdata[27:0 ]    <= lm5_base_addr_reg;
            end
            30'h12 : begin
                hrdata[27:0 ]    <= lm6_sidx_reg;
            end
            30'h13 : begin
                hrdata[27:0 ]    <= lm7_fidx_reg;
            end
            30'h14 : begin
                hrdata[11:0 ]    <= lm8_timeout_cnt_reg;
            end
            30'h15 : begin
                hrdata[7:0  ]    <= lm9_axi_id_reg;
            end
            30'h16 : begin
                hrdata[8    ]    <= en_decomp_reg;
                hrdata[0    ]    <= en_index_reg;
            end
            30'h17 : begin
                hrdata[27:0 ]    <= index_base_addr_reg;
            end
            30'h18 : begin
                hrdata[16   ]    <= fsm_mem_claim_reg;
                hrdata[15:13]    <= fsm_mem_pipo_num_wr_reg;
                hrdata[12:10]    <= fsm_mem_pipo_num_rd_reg;
                hrdata[9:5  ]    <= fsm_mem_base_idx_wr_reg;
                hrdata[4:0  ]    <= fsm_mem_base_idx_rd_reg;
            end
        default:
            hrdata      <= 32'hdeadbeaf;
        endcase
    end
end

endmodule
