module jb_pre_dfe(
   input             i_clk_122,
   input             i_clk_491,
   input      [31:0] i_tdata  ,
   input             i_tvalid ,
   output reg [31:0] o_tdata  ,
   output reg [1:0]  o_tuser  ,
   output reg        o_tvalid
);

logic  [31:0] s_tdata_d1  =0;
logic         s_tvalid_d1 =0;
logic  [31:0] s_tdata_d2  =0;
logic         s_tvalid_d2 =0;
logic  [3:0]  s_waddr     =0;
logic  [1:0]  s_cnt4      =0;
logic  [1:0]  s_cnt4_d1   =0;
logic  [3:0]  s_raddr     =0;
logic         s_rd_flag   =0;
logic         s_rd_flag_d1=0;
logic         s_rd_flag_d2=0;
logic         s_rd_flag_d3=0;
logic         s_rd_flag_d4=0;
logic [31:0]  s_dout;

always @(posedge i_clk_122)begin
   s_tdata_d1  <= i_tdata  ;
   s_tvalid_d1 <= i_tvalid ;
   s_tdata_d2  <= s_tdata_d1  ;
   s_tvalid_d2 <= s_tvalid_d1 ;
end

always @(posedge i_clk_122)begin
  if(s_tvalid_d1)
    s_waddr <= s_waddr +1;
  else
    s_waddr <= s_waddr;  
end

always @(posedge i_clk_122)begin
  if(s_tvalid_d1)begin
    if(s_waddr==4'd1)
      s_rd_flag <= 1'b1;
  end
  else 
    s_rd_flag <= 1'b0;  
end

always @(posedge i_clk_491)begin
  s_rd_flag_d1 <= s_rd_flag;
  s_rd_flag_d2 <= s_rd_flag_d1;
  s_rd_flag_d3 <= s_rd_flag_d2;
  s_rd_flag_d4 <= s_rd_flag_d3;
  
end

always @(posedge i_clk_491)begin
  if((s_rd_flag_d2)&&(s_cnt4 == 2'd3))
   s_cnt4 <= 0;
  else if((s_rd_flag_d2)&&(s_cnt4 != 2'd3))
   s_cnt4 <= s_cnt4 +1;
end

always @(posedge i_clk_491)begin
  if(s_cnt4 == 2'd3)
    s_raddr <= s_raddr +1;
  else
    s_raddr <= s_raddr;
end

always @(posedge i_clk_491)begin
   s_cnt4_d1 <= s_cnt4;
end


dpram_32x16 u_dpram_32x16 (
  .a        (s_waddr    ),
  .d        (s_tdata_d1 ),
  .clk      (i_clk_122  ),
  .we       (s_tvalid_d1),
  .qdpo_clk (i_clk_491  ),
  .dpra     (s_raddr    ),  
  .qdpo     (s_dout     )
);

always @(posedge i_clk_491)begin
  o_tdata  <= s_dout;
  o_tuser  <= s_cnt4_d1;
  o_tvalid <= s_rd_flag_d3;
end


/* ila_1_for_dma u0_ila1_for_dma(
  .clk   (i_clk_122),
  .probe0(s_tdata_d2),
  .probe1(s_waddr),
  .probe2(s_tvalid_d2)

);


ila_1_for_dma u1_ila1_for_dma(
  .clk   (i_clk_491),
  .probe0(s_dout),
  .probe1(s_raddr),
  .probe2(1'b0)
); */

endmodule