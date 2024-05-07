`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jade_Yu
// 
// Create Date: 2023/08/29 10:32:37
// Design Name: Jade_Yu
// Module Name: axi4_master_write
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


module rsp_s2_prep_axi4_m_wr #(
    parameter DELAY_DATA_ARRIVE = 2,
    parameter READ_RAM_WIDTH    = 128,
    parameter SAMPLE_WIDTH      = 32,
    parameter WR_INTERVAL       = 50,
    parameter DATA_NUM          = 1024,
    parameter INIT_ADDR         = 0,
    parameter ADD_ADDR          = 16,
    parameter END_ADDR          = 16384,
    parameter BURST_LEN         = 8,
    parameter FIFO_CNT          = 7
)(
  input                                       clk,
  input                                       rst_n,
  input      [READ_RAM_WIDTH-1:0]             i_data         ,
  input                                       i_data_valid   ,
  input                                       fifo_empty     ,
  output                                      fifo_rd_en     ,
  input                                       fifo_afull     ,
  input      [FIFO_CNT:0]                     fifo_word_counter  ,
  output reg                                  o_finish       ,
  axi_v4_wr_if.master                         m_axi_wr
);
//********************  localparam  ********************//
localparam CNT_WR_WIDTH = $clog2(DATA_NUM);

//********************  reg&wire  ********************//
//write_address
reg [SAMPLE_WIDTH-1:0]                    m_axi_awaddr  ;         
reg [3-1:0]                               m_axi_awprot  ;
reg                                       m_axi_awvalid ;
wire                                      m_axi_awready ;  
wire                                      s_m_axi_awready ;  
reg [3-1:0]                               m_axi_awsize  ;
reg [2-1:0]                               m_axi_awburst ;
reg [4-1:0]                               m_axi_awcache ;
reg [8-1:0]                               m_axi_awlen   ;          
reg [1-1:0]                               m_axi_awlock  ;          
reg [4-1:0]                               m_axi_awid    ;    
          
//write_data
reg [READ_RAM_WIDTH-1:0]                  m_axi_wdata   ;          
reg [READ_RAM_WIDTH/8-1:0]                m_axi_wstrb   ;  
reg                                       m_axi_wvalid  ;      
wire                                      m_axi_wready  ;  
wire                                      m_axi_wlast   ;  
wire                                      awvalid_start ;

//write_response
wire [2-1:0]                              m_axi_bresp   ; 
wire                                      m_axi_bvalid  ;     
reg                                       m_axi_bready  ;
wire [4-1:0]                              m_axi_bid     ;

//cnt
reg [CNT_WR_WIDTH:0]                      cnt_awvalid  ;
reg [CNT_WR_WIDTH:0]                      cnt_wvalid  ;
reg [CNT_WR_WIDTH:0]                      cnt_wr_data ;
reg [FIFO_CNT:0]                          cnt_fifo_rd_en  ;

//fifo
wire                                      fifo_rd_start;
reg                                       fifo_wr_start;

//********************  assign  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_awid    <= 4'd1;
    m_axi_awlen   <= BURST_LEN-1;//
    m_axi_awburst <= 2'd1;//
    m_axi_awsize  <= 3'd4;//
    m_axi_awcache <= 4'd0;
    m_axi_awprot  <= 4'd0;
    m_axi_awlock  <= 1'b0;
    m_axi_wstrb   <= 16'hffff;
    m_axi_bready  <= 1'b1;
  end 
  else begin
    m_axi_awid    <= 4'd1;
    m_axi_awlen   <= BURST_LEN-1;
    m_axi_awburst <= 2'd1;
    m_axi_awsize  <= 3'd4;
    m_axi_awprot  <= 4'd0;
    m_axi_awlock  <= 1'b0;
    m_axi_wstrb   <= 16'hffff;
    m_axi_bready  <= 1'b1;
  end
end



assign m_axi_wr.awvalid = m_axi_awvalid;
assign m_axi_wr.awid    = m_axi_awid   ;
assign m_axi_wr.awaddr  = m_axi_awaddr ;
assign m_axi_wr.awlen   = m_axi_awlen  ;
assign m_axi_wr.awburst = m_axi_awburst;
assign m_axi_wr.awsize  = m_axi_awsize ;
assign m_axi_wr.awcache = m_axi_awcache;
assign m_axi_wr.awprot  = m_axi_awprot ;
assign m_axi_wr.awlock  = m_axi_awlock ;
assign m_axi_awready = m_axi_wr.awready; //input

assign m_axi_wr.wvalid  = m_axi_wvalid ;
assign m_axi_wr.wdata   = m_axi_wdata  ;
assign m_axi_wr.wlast   = m_axi_wlast  ;
assign m_axi_wr.wstrb   = m_axi_wstrb  ;
assign m_axi_wready = m_axi_wr.wready  ; //input

assign m_axi_bvalid = m_axi_wr.bvalid  ; //input
assign m_axi_bid    = m_axi_wr.bid     ; //input
assign m_axi_bresp  = m_axi_wr.bresp   ; //input
assign m_axi_wr.bready = m_axi_bready  ;


//********************  cnt  ********************//
  //cnt_wr_data
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_wr_data <= {CNT_WR_WIDTH{1'b0}};
  end 
  else begin
    if(cnt_wr_data == DATA_NUM-1) begin
      cnt_wr_data <= {CNT_WR_WIDTH{1'b0}};
    end
    else if(m_axi_wvalid && m_axi_wready) begin
      cnt_wr_data <= cnt_wr_data + 1'b1;
    end
    else begin
      cnt_wr_data <= cnt_wr_data;
    end
  end
end

  //cnt_awvalid
 always @(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
       cnt_awvalid <= {CNT_WR_WIDTH{1'b0}};
   end 
   else begin
       if(cnt_awvalid == BURST_LEN) begin
         cnt_awvalid <= {CNT_WR_WIDTH{1'b0}};
       end
       else if(awvalid_start)
         cnt_awvalid <= 1;
       else if(cnt_awvalid >= 1 && m_axi_wvalid && m_axi_wready)begin
         cnt_awvalid <= cnt_awvalid + 1'b1;
       end
   end
 end

  //cnt_wvalid
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_wvalid <= 11'b0;
  end 
  else begin
    if(cnt_wvalid == m_axi_awlen) begin
      if(m_axi_wready && m_axi_wvalid)
        cnt_wvalid <= 11'b0;
      else
        cnt_wvalid <= cnt_wvalid;
    end
    else if(m_axi_wvalid && m_axi_wready) begin
      cnt_wvalid <= cnt_wvalid + 1'b1;
    end
  end
end

//   //cnt_fifo_rd_en
// always @(posedge clk or negedge rst_n) begin
//   if(!rst_n) begin
//     cnt_fifo_rd_en <= {FIFO_CNT{1'b0}};
//   end 
//   else begin
//     if(cnt_fifo_rd_en == BURST_LEN-2) begin
//       cnt_fifo_rd_en <= {FIFO_CNT{1'b0}};
//     end
//     else if(fifo_rd_en) begin
//       cnt_fifo_rd_en <= cnt_fifo_rd_en + 1'b1;
//     end
//   end
// end

//******************** Indicative signal ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    fifo_wr_start <= 1'b0;
  end 
  else begin
    if(!fifo_empty)
      fifo_wr_start <= 1'b1;
    else if(o_finish)
      fifo_wr_start <= 1'b0;
  end
end
assign fifo_rd_en = m_axi_wvalid & m_axi_wready;

// always @(posedge clk or negedge rst_n) begin
//   if(!rst_n) begin
//     fifo_rd_en <= 1'b0;
//   end 
//   else begin
//       if(fifo_rd_start || ) begin  
//         fifo_rd_en <= 1'b1;
//       end
//       else begin
//         fifo_rd_en <= 1'b0;
//       end
//   end
// end

//delay #(1) delay_arready(.clk(clk), .rst_n(rst_n), .din(m_axi_awready), .dout(s_m_axi_awready));

//**********************************************
// Write Channel: AWVALID, AWADDR, WVALID, WLAST, BREADY
//**********************************************
  //AWVALID
assign awvalid_start = (m_axi_awready && !fifo_empty && cnt_awvalid==0);
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      m_axi_awvalid <= 1'b0;
  end 
  else begin
      if(awvalid_start) begin  
        m_axi_awvalid <= 1'b1;
      end
      else begin
        m_axi_awvalid <= 1'b0;
      end
  end
end 

  //AWADDR
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      m_axi_awaddr <= INIT_ADDR;
  end 
  else begin
    if(m_axi_awaddr == END_ADDR) begin
      m_axi_awaddr <= INIT_ADDR;
    end
    else if(m_axi_wlast && m_axi_wready && m_axi_wvalid) begin
      m_axi_awaddr <= m_axi_awaddr + ADD_ADDR;
    end
    else begin
      m_axi_awaddr <= m_axi_awaddr;
    end
  end
end

  //WVALID
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_wvalid <= 1'b0;
  end 
  else begin
    // if(cnt_wvalid == m_axi_awlen) begin
    //   m_axi_wvalid <= 1'b0;
    // end
    // else begin
    //   m_axi_wvalid <= 1'b1;
    // end
    if(m_axi_awvalid)
      m_axi_wvalid <= 1'b1;
    else if(m_axi_wlast && m_axi_wready)
      m_axi_wvalid <= 1'b0;
  end
end

  //WLAST

assign m_axi_wlast = cnt_wvalid == m_axi_awlen;

  //WDATA
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_wdata <= 128'b0;
  end 
  else begin
    m_axi_wdata <= i_data;//'h80;
  end
end


  //o_finish
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_finish <= 1'b0;
  end 
  else begin
    if(cnt_wr_data == DATA_NUM-1)
      o_finish <= 1'b1;
    else
      o_finish <= 1'b0;
  end
end

endmodule
