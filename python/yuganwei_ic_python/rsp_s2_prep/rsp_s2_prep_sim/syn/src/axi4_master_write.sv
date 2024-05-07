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


module axi4_master_write(
  input                   clk,
  input                   rst_n,
  input                   i_start,
  input                   i_last,
  input [127:0]           i_x0,
  output reg              o_start,
  output reg              o_end,
  axi_v4_wr_if.master     m_axi_wr
);
//********************  localparam  ********************//


//********************  reg&wire  ********************//
//write_address
reg [32-1:0]                    m_axi_awaddr  ;         
reg [3-1:0]                     m_axi_awprot  ;
reg                             m_axi_awvalid ;
wire                            m_axi_awready ;  
reg [3-1:0]                     m_axi_awsize  ;
reg [2-1:0]                     m_axi_awburst ;
reg [4-1:0]                     m_axi_awcache ;
reg [8-1:0]                     m_axi_awlen   ;          
reg [1-1:0]                     m_axi_awlock  ;          
reg [4-1:0]                     m_axi_awid    ;    

//write_data
reg [128-1:0]                   m_axi_wdata   ;          
reg [128/8-1:0]                 m_axi_wstrb   ;  
reg                             m_axi_wvalid  ;      
wire                            m_axi_wready  ;  
reg                             m_axi_wlast   ;  

//write_response
wire [2-1:0]                    m_axi_bresp   ; 
wire                            m_axi_bvalid  ;     
reg                             m_axi_bready  ;
wire [4-1:0]                    m_axi_bid     ;

//cnt
reg [11:0]      cnt_wvalid  ;
reg [3:0]       cnt_o_start ;

//
wire s_m_axi_awvalid;
reg [16-1:0] cnt_data;
reg wr_start;
reg [3:0] cnt_wr_start;

integer cnt_i;


//********************  assign  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_awid    <= 4'd1;
    m_axi_awlen   <= 8'd7;//
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
    m_axi_awlen   <= 8'd7;
    m_axi_awburst <= 2'd1;
    m_axi_awsize  <= 3'd4;
    m_axi_awprot  <= 4'd0;
    m_axi_awlock  <= 1'b0;
    m_axi_wstrb   <= 16'hffff;
    m_axi_bready  <= 1'b1;
  end
end


//assign s_m_axi_awvalid = m_axi_awvalid & m_axi_awready;
assign m_axi_wr.awvalid = 0;//m_axi_awready;
assign m_axi_wr.awid    = m_axi_awid   ;
assign m_axi_wr.awaddr  = m_axi_awaddr ;
assign m_axi_wr.awlen   = m_axi_awlen  ;
assign m_axi_wr.awburst = m_axi_awburst;
assign m_axi_wr.awsize  = m_axi_awsize ;
assign m_axi_wr.awcache = m_axi_awcache;
assign m_axi_wr.awprot  = m_axi_awprot ;
assign m_axi_wr.awlock  = m_axi_awlock ;
assign m_axi_awready = 1'b1;//m_axi_wr.awready; //input

assign m_axi_wr.wvalid  = m_axi_wvalid ;
assign m_axi_wr.wdata   = m_axi_wdata  ;
assign m_axi_wr.wlast   = m_axi_wlast  ;
assign m_axi_wr.wstrb   = m_axi_wstrb  ;
assign m_axi_wready = m_axi_wr.wready  ; //input

assign m_axi_bvalid = m_axi_wr.bvalid  ; //input
assign m_axi_bid    = m_axi_wr.bid     ; //input
assign m_axi_bresp  = m_axi_wr.bresp   ; //input
assign m_axi_wr.bready = m_axi_bready  ;


//**********************************************
// Write Channel: AWVALID, AWADDR, WVALID, WLAST, BREADY
//**********************************************
  //o_start
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_start <= 1'b0;
  end 
  else begin
    if(cnt_o_start == 4'd7) begin
      o_start <= 1'b0;
    end
    else if(wr_start) begin  
      o_start <= 1'b1;
    end
    else begin
      o_start <= 1'b0;
    end
  end
end

  //AWVALID
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      m_axi_awvalid <= 1'b0;
  end 
  else begin
      if(wr_start & m_axi_awready) begin  
        m_axi_awvalid <= 1'b1;
      end
      else begin
        m_axi_awvalid <= 1'b0;
      end
  end
end

  //AWADDR 16*m_axi_awlen
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      m_axi_awaddr <= 32'b0;
  end 
  else begin
      if(m_axi_awaddr == 16'd16384) begin
        m_axi_awaddr <= 32'b0;
      end
      else if(m_axi_wlast) begin
        m_axi_awaddr <= m_axi_awaddr + 32'd128;//32(one data address width)*m_axi_awlen
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
    if(cnt_wvalid == m_axi_awlen) begin
      m_axi_wvalid <= 1'b0;
    end
    // else if(m_axi_awready) begin
    //   m_axi_wvalid <= 1'b1;
    // end
    else begin
      m_axi_wvalid <= 1'b1;
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
      cnt_wvalid <= 1'b0;
    end
    else if(m_axi_wvalid && m_axi_wready) begin
      cnt_wvalid <= cnt_wvalid + 1'b1;
    end
  end
end

  //WLAST
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_wlast <= 1'b0;
  end 
  else begin
    if(cnt_wvalid == m_axi_awlen-1) begin
        m_axi_wlast <= 1'b1;
    end
    else begin
        m_axi_wlast <= 1'b0;
    end
  end
end

  //WDATA
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_wdata <= 128'b0;
  end 
  else begin
    m_axi_wdata <= i_x0;
  end
end
// assign m_axi_wdata = (m_axi_wvalid && m_axi_wready) ? wdata : m_axi_wdata;

//**********************************************
// Data cnt: cnt_data
//**********************************************
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_data <= 16'b0;
  end 
  else begin
    if(cnt_data == 16'd1023) begin
      cnt_data <= 16'b0;
    end
    else if(m_axi_wvalid && m_axi_wready) begin
      cnt_data <= cnt_data + 1'b1;
    end
    else begin
      cnt_data <= cnt_data;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      o_end <= 1'b0;
  end 
  else begin
    if(cnt_data == 16'd1023) begin
      o_end <= 1'b1;
    end
    else begin
      o_end <= 1'b0;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      cnt_o_start <= 4'b0;
  end 
  else begin
    if(cnt_o_start == 4'd7)
      cnt_o_start <= 4'd0;
    else if(o_start)
      cnt_o_start <= cnt_o_start + 1'b1;
    else 
      cnt_o_start <= cnt_o_start;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      cnt_i <= 0;
  end 
  else begin
    if(cnt_i == 4'd7)
      cnt_i <= 4'd0;
    else if(o_start)
      cnt_i <= cnt_i + 1'b1;
    else 
      cnt_i <= cnt_i;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    wr_start <= 1'b0;
  end 
  else begin
    if(cnt_wr_start == 4'd7)
      wr_start <= 1'b0;
    else if(i_start && m_axi_awready)
      wr_start <= 1'b1;
    else
      wr_start <= wr_start; 
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_wr_start <= 4'b0;
  end 
  else begin
    if(cnt_wr_start == 4'd7)
      cnt_wr_start <= 4'b0;
    else if(wr_start)
      cnt_wr_start <= cnt_wr_start + 1'b1;
    else
      cnt_wr_start <= cnt_wr_start;
  end
end

endmodule
