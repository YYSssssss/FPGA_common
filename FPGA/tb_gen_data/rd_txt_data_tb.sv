`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jade_Yu
// 
// Create Date: 2023/11/03 16:01
// Design Name: Jade_Yu
// Module Name: rd_txt_data
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


module rd_txt_data_tb #(
  parameter CODE_RUN_CNT     = 10 ,
  parameter DATA_WIDTH       = 128,
  parameter DATA_NUM         = 1024,
  parameter FILE_ADDR        = "/home/users/yuyushan/work/XXX.txt",
  parameter DELAY_BIT_DEPTH  = 0,
  parameter DELAY_DATA_DEPTH = 0,
  parameter DELAY_ADDR_DEPTH = 0,
  parameter CFG_X_NUM        = 3840,
  parameter CFG_Y_NUM        = 2160,
  parameter VEDIO_DATA_WIDTH = 64
)
(
  input                          clk        ,
  input                          rst_n      ,
  
  input                          rd_en      ,
  output                         rd_valid   ,
  output [DATA_WIDTH-1:0]        rd_data    ,
  output [31:0]                  rd_addr    ,
  
  output logic  [63 : 0]         video_tdata  ,
  output logic                   video_tvalid ,
  input  logic                   video_tready ,
  output logic                   video_tuser  ,
  output logic                   video_tlast  ,
  output logic                   video_clk
  
    
);

//********************  localparam  ********************//
localparam ADDRESS_WIDTH = 32;


//********************  logic  ********************//
logic [DATA_WIDTH-1:0]    mem [DATA_NUM-1:0];
logic [ADDRESS_WIDTH-1:0] s_rd_addr;
logic [DATA_WIDTH:0]      s_rd_data;
logic                     s_rd_valid;
logic [31:0]              cnt_rd_en;
logic [31:0]              cnt_run;

//******************** cnt ********************//
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    cnt_rd_en <= 0;
  end
  else begin
    if(cnt_rd_en == DATA_NUM) begin
      cnt_rd_en <= 0;
    end
    else if(rd_en == 1'b1)begin
      cnt_rd_en <= cnt_rd_en + 1;
    end
    else begin
      cnt_rd_en <= cnt_rd_en;
    end
  end
end



//******************** Indicative signal ********************//
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    cnt_run <= 0;
  end
  else begin
    if(cnt_run == CODE_RUN_CNT-1) begin
      cnt_run <= CODE_RUN_CNT-1;
    end
    else if(cnt_rd_en == DATA_NUM)begin
      cnt_run <= cnt_run + 1;
    end
    else begin
      cnt_run <= cnt_run;
    end
  end
end

initial begin
    $readmemh(FILE_ADDR, mem);
    // $readmemh("/home/users/yuyushan/work/rsp_s1_prep/rsp_s1_prep_sim/input_data/rsp_s1_op_mst_a_0.txt", mem_1024x128);
end

//********************  rd  ********************//
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    s_rd_data <= 128'b0;
    s_rd_valid <= 1'b0;
  end
  else begin
    if(cnt_run == CODE_RUN_CNT-1) begin
      s_rd_data <= 0;
      s_rd_valid <= 1'b0;
    end
    else if(rd_en == 1'b1 && s_rd_addr < DATA_NUM)begin
      s_rd_data <= mem[s_rd_addr];
      s_rd_valid <= 1'b1;
    end
    else begin
      s_rd_data <= s_rd_data;
      s_rd_valid <= 0;
    end
  end
end
always@(posedge clk or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    s_rd_addr <= 0;
  end
  else begin
    if(cnt_run == CODE_RUN_CNT-1) begin
      s_rd_addr <= 0;
    end
    else if(s_rd_addr == DATA_NUM) begin
      s_rd_addr <= 0;
    end
    else if(rd_en == 1'b1)begin
      s_rd_addr <= s_rd_addr + 1;
    end
    else begin
      s_rd_addr <= s_rd_addr;
    end
  end
end


delay_bit_tb #(
  .DELAY (DELAY_BIT_DEPTH)
) u_delay_valid(
  .clk    (clk), 
  .rst_n  (rst_n), 
  .din    (s_rd_valid), 
  .dout   (rd_valid)
);

delay_data_tb #(
  .DEPTH      (DELAY_DATA_DEPTH),
  .DATA_WIDTH (DATA_WIDTH)
) u_delay_txt_data(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (s_rd_data),
  .o_y0  (rd_data)
);
delay_data_tb #(
  .DEPTH      (DELAY_ADDR_DEPTH),
  .DATA_WIDTH (32)
) u_delay_txt_addr(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (s_rd_addr),
  .o_y0  (rd_addr)
);


//csi_to_axis #(
//    .CFG_X_NUM (CFG_X_NUM) ,
//    .CFG_Y_NUM (CFG_Y_NUM)  
//) u_csi_to_axis(
//    .clk                 (clk),
//    .rstn                (rst_n),
//    .m_axis_video_tdata  (video_tdata ),
//    .m_axis_video_tvalid (video_tvalid),
//    .m_axis_video_tready (video_tready),
//    .m_axis_video_tuser  (video_tuser ),
//    .m_axis_video_tlast  (video_tlast ),
//    .m_axis_video_clk    (video_clk   )
//);

debug_fifo_data_gen U_debug_fifo_data_gen(
  .aclk             (clk),
  .aresetn          (rst_n),
 
  .m_axis_tdata     (video_tdata), 
  .m_axis_tvalid    (video_tvalid),
  .m_axis_tready    (video_tready),
  .m_axis_tuser     (video_tuser),
  .m_axis_tlast     (video_tlast),
  .m_axis_tkeep     (),

  .done             ()
);

endmodule






/////////////////////////////////////delay bit or data/////////////////////////////////
module delay_bit_tb #(parameter DELAY = 1)
(
  input               clk,
  input               rst_n,
  
  input               din,
  output              dout
);
generate if (DELAY>=1) begin
  reg [DELAY-1:0]     shift_reg;
  
  always @(posedge clk or negedge rst_n)
    if (~rst_n)
      shift_reg <= {DELAY{1'b0}};
    else
      shift_reg <= {shift_reg[DELAY-1:0], din};

  assign dout = shift_reg[DELAY-1];
end else begin
  assign dout = din;
end
endgenerate
endmodule

module delay_data_tb #(
    parameter DEPTH = 2,
    parameter DATA_WIDTH = 16
)(
    input                   clk     ,
    input                   rst_n     ,
    //input                   i_data_valid,
    input [DATA_WIDTH-1:0]  i_x0    ,
    output[DATA_WIDTH-1:0]  o_y0

);
reg  [DATA_WIDTH-1:0] s_delay_data[DEPTH-1:0];
reg  [15:0]           gv_i;

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
	for (gv_i = 0; gv_i < DEPTH; gv_i = gv_i + 1) begin
        s_delay_data[gv_i] <= 16'h0000; // Initialize to 0
    end
  end
  else begin
    //s_delay_data[0] <= (i_data_valid == 1'b0) ? {DATA_WIDTH{1'b0}} : i_x0;
    s_delay_data[0] <= i_x0;
    for(gv_i=1; gv_i<DEPTH; gv_i = gv_i+1 )
      begin
        s_delay_data[gv_i]<=s_delay_data[gv_i-1];
      end
  end
end
assign o_y0 = (DEPTH==0) ? i_x0 : s_delay_data[DEPTH-1];

endmodule





module debug_fifo_data_gen #(
  parameter integer C_MASTER_ID = 0,
  parameter width            = 64,
  parameter CFG_X_NUM        = 3840 ,//屏幕X方向像素点数
  parameter CFG_Y_NUM        = 2320 ,//屏幕Y方向像素点数
  parameter WAIT_NUM         = 10
)
(
  /**************** Stream Signals ****************/
  output logic                            m_axis_tvalid ,
  input  logic                            m_axis_tready ,
  output logic [width-1:0]                m_axis_tdata  ,
  output logic [width/8-1:0]              m_axis_tkeep  ,
  output logic                            m_axis_tlast  ,
  output logic                            m_axis_tuser  ,
  /**************** System Signals ****************/
  input  logic                            aclk          ,
  input  logic                            aresetn       ,
  /**************** Done Signal ****************/
  output logic                            done
);

  /**************** Local Parameters ****************/
  localparam integer  P_M_TDATA_BYTES = width / 8;
  localparam integer  P_M_TUSER_BYTES = 1;
  localparam [8-1:0]  P_M_PACKET_SIZE = (16 - 1);
  localparam [16-1:0] P_M_PACKET_NUM = 16;
  localparam [16-1:0] P_M_SINGLES_NUM = 256;
  localparam [17-1:0] P_M_DONE_NUM = 255;

  /**************** Internal Wires/Regs ****************/
  genvar  i;
  reg [8*P_M_TDATA_BYTES-1:0]  tdata_i = {P_M_TDATA_BYTES{8'h00}};
  reg [16-1:0] pcnt_i = 16'h0000;
  reg [16-1:0] tcnt_i = 16'h0000;
  wire         done_i;
  wire         transfer_i;
  wire         areset = ~aresetn;
  reg [2-1:0]  areset_i = 2'b00;
  reg [31:0]   pixel_cnt = 0;
  reg [31:0]   line_cnt  = 0;
  reg [31:0]   wait_cnt  = 0;

  /**************** Assign Signals ****************/
  assign m_axis_tkeep = {P_M_TDATA_BYTES{1'b1}};
  assign m_axis_tdata = tdata_i;
  assign transfer_i = m_axis_tready && m_axis_tvalid;

    assign done_i = (transfer_i && (pcnt_i == P_M_DONE_NUM - 1'b1) && (tcnt_i == P_M_PACKET_SIZE));


  // Register Reset
  always @(posedge aclk) begin
    areset_i <= {areset_i[0], areset};
  end

  //**********************************************
  // TDATA
  //**********************************************

//  generate
//    for(i=0; i<P_M_DONE_NUM; i=i+1) begin: tdata_incr_g
 always @(posedge aclk) begin
   if(areset) begin
     tdata_i <= 'h00;
   end
   else if(tdata_i == 'd959) begin
     tdata_i <= 'h0;
   end
   else begin
     tdata_i <= (transfer_i) ? tdata_i + 1'b1 : tdata_i;
   end
 end
//    end
//  endgenerate

  //**********************************************
  // TUSER
  //**********************************************


assign m_axis_tuser = (line_cnt == 'b0 & pixel_cnt == 'b0 & m_axis_tvalid & m_axis_tready);

  //**********************************************
  // TVALID
  //**********************************************
  always @(posedge aclk) begin
    if(areset) begin
      m_axis_tvalid <= 1'b0;
    end
    else
    begin
      // TVALID
//      if(done_i) begin
//        m_axis_tvalid <= 1'b0;
//      end
//      else 
        if(areset == 'd0) begin
        m_axis_tvalid <= 1'b1;
      end
      else begin
        m_axis_tvalid <= m_axis_tvalid;
      end
    end
  end

  //**********************************************
  // TLAST
  //**********************************************
assign m_axis_tlast = (pixel_cnt == CFG_X_NUM/4 - 1) ? 1'b1 : 1'b0;


  //**********************************************
  // PCNT, TCNT, DONE
  //**********************************************
  always@(posedge aclk) begin
    if(areset)
        wait_cnt <= 0;
    else if(wait_cnt >= WAIT_NUM)
        wait_cnt <= wait_cnt;
    else
        wait_cnt <= wait_cnt + 1'b1;
end
  
  always@(posedge aclk) begin
    if(areset)
        pixel_cnt <= 0;
    else if(m_axis_tvalid & m_axis_tready)begin
        if(pixel_cnt < CFG_X_NUM/4 - 1)   
              pixel_cnt <= pixel_cnt +1;
        else
            pixel_cnt <= 'b0;
    end
 end
 
 always@(posedge aclk) begin
    if(areset)
        line_cnt <= 0;
    else if(m_axis_tvalid & m_axis_tready)begin
            if(pixel_cnt == CFG_X_NUM/4 - 1)begin
                if(line_cnt < CFG_Y_NUM - 1)
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;
            end
    end
end
  
  
  always @(posedge aclk) begin
    if(areset) begin
      pcnt_i <= 16'h0000;
      tcnt_i <= 16'h0000;
      done <= 1'b0;
    end
    else
    begin
      // DONE
      done <= (done_i) ? 1'b1 : done;

      // Increment counters
      tcnt_i <= (transfer_i) ? (m_axis_tlast ? 16'h0000 : (tcnt_i + 1'b1)) : tcnt_i;
      pcnt_i <= (transfer_i && m_axis_tlast) ? (pcnt_i + 1'b1) : pcnt_i;
    end
  end

endmodule












module csi_to_axis #(
    parameter CFG_X_NUM        = 3840 ,//屏幕X方向像素点数
    parameter CFG_Y_NUM        = 2160 , //屏幕Y方向像素点数
    parameter VEDIO_DATA_WIDTH = 64
)(
    input clk,
    input rstn,
//AXIS 接口，输出到video out IP核
    output logic  [VEDIO_DATA_WIDTH : 0]   m_axis_video_tdata  ,
    output logic             m_axis_video_tvalid ,
    input  logic             m_axis_video_tready ,
    output logic             m_axis_video_tuser  ,
    output logic             m_axis_video_tlast  ,
    output logic             m_axis_video_clk
    );

    parameter WAIT_NUM = 20;

    reg [31:0] pixel_cnt = 0;
    reg [31:0] line_cnt  = 0;
    reg [31:0] wait_cnt  = 0;
    reg tvalid;
    
    
assign m_axis_video_clk =    clk;  

always@(posedge clk) begin
    if(!rstn) begin
        tvalid <= 0;
        m_axis_video_tvalid <= 0;
    end
    else if(wait_cnt < WAIT_NUM || !m_axis_video_tready) begin
        tvalid <= 0;
        m_axis_video_tvalid <= 0;
    end
    else begin
        tvalid <= 1;
        m_axis_video_tvalid <= 1;
    end
 end

always@(posedge clk) begin
    if(!rstn)
        wait_cnt <= 0;
    else if(wait_cnt >= WAIT_NUM)
        wait_cnt <= wait_cnt;
    else
        wait_cnt <= wait_cnt + 1'b1;
end


always@(posedge clk) begin
    if(!rstn)
        m_axis_video_tdata <= 0;
    else if(wait_cnt < WAIT_NUM)
        m_axis_video_tdata <= 0;
    else if(pixel_cnt == CFG_X_NUM/4 - 1)
        m_axis_video_tdata <= 0;
    else if(tvalid & m_axis_video_tready)
        m_axis_video_tdata <= m_axis_video_tdata + 1;
end

always@(posedge clk) begin
    if(!rstn)
        pixel_cnt <= 0;
    else if(wait_cnt < WAIT_NUM)
        pixel_cnt <= 0;
    else if(tvalid & m_axis_video_tready)begin
        if(pixel_cnt < CFG_X_NUM/4 - 1)   
              pixel_cnt <= pixel_cnt +1;
        else
            pixel_cnt <= 'b0;
    end
 end
 
 always@(posedge clk) begin
    if(!rstn)
        line_cnt <= 0;
    else if(wait_cnt < WAIT_NUM)
        line_cnt <= 0;
    else if(tvalid & m_axis_video_tready)begin
            if(pixel_cnt == CFG_X_NUM/4 - 1)begin
                if(line_cnt < CFG_Y_NUM - 1)
                    line_cnt <= line_cnt + 1;
                else
                    line_cnt <= 0;
            end
    end
end

assign m_axis_video_tuser = (line_cnt == 'b0 & pixel_cnt == 'b0 & tvalid & m_axis_video_tready);
    
assign m_axis_video_tlast= (pixel_cnt == CFG_X_NUM/4 - 1) ? 1'b1 : 1'b0;

endmodule