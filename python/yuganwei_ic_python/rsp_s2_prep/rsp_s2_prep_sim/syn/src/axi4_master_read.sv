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


module axi4_master_read(
    input                   clk,
    input                   rst_n,
    input                   i_start,
    input                   i_last,
    output reg [127:0]      o_data,
    output reg              o_valid,
    axi_v4_rd_if.master     m_axi_rd
);
//********************  localparam  ********************//


//********************  reg&wire  ********************//
//write_address
reg [32-1:0]                    m_axi_araddr  ;         
reg [3-1:0]                     m_axi_arprot  ;
reg                             m_axi_arvalid ;
wire                            m_axi_arready ;  
reg                             s_m_axi_arready;  
reg [3-1:0]                     m_axi_arsize  ;
reg [2-1:0]                     m_axi_arburst ;
reg [4-1:0]                     m_axi_arcache ;
reg [8-1:0]                     m_axi_arlen   ;          
reg [1-1:0]                     m_axi_arlock  ;          
reg [4-1:0]                     m_axi_arid    ;    

//read_data
wire                            m_axi_rvalid  ; 
wire[4-1:0]                     m_axi_rid     ;
wire[128-1:0]                   m_axi_rdata   ;   
wire                            m_axi_rlast   ;     
wire [2-1:0]                    m_axi_rresp   ; 
reg                             m_axi_rready  ;    


//cnt
reg [11-1:0]    cnt_arvalid ;
reg [11-1:0]    cnt_rvalid  ;

//debug
reg [15:0] cnt_all_rvalid;
wire       stop_r_data;


//********************  assign  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_arid    <= 4'd1;
    m_axi_arlen   <= 8'd7;//
    m_axi_arburst <= 2'd1;//
    m_axi_arsize  <= 3'd4;//
    m_axi_arcache <= 4'd0;
    m_axi_arprot  <= 4'd0;
    m_axi_arlock  <= 1'b0;
    m_axi_rready  <= 1'b1;
  end 
  else begin
    m_axi_arid    <= 4'd1;
    m_axi_arlen   <= 8'd7;
    m_axi_arburst <= 2'd1;
    m_axi_arsize  <= 3'd4;
    m_axi_arprot  <= 4'd0;
    m_axi_arlock  <= 1'b0;
    m_axi_rready  <= 1'b1;
  end
end

logic s_m_axi_arvalid;
assign s_m_axi_arvalid = m_axi_arvalid & m_axi_arready;
assign m_axi_rd.arvalid = s_m_axi_arvalid;
assign m_axi_rd.arid    = m_axi_arid   ;
assign m_axi_rd.araddr  = m_axi_araddr ;
assign m_axi_rd.arlen   = m_axi_arlen  ;
assign m_axi_rd.arburst = m_axi_arburst;
assign m_axi_rd.arsize  = m_axi_arsize ;
assign m_axi_rd.arcache = m_axi_arcache;
assign m_axi_rd.arprot  = m_axi_arprot ;
assign m_axi_rd.arlock  = m_axi_arlock ;
assign m_axi_arready = m_axi_rd.arready; //input

assign m_axi_rvalid = m_axi_rd.rvalid  ;//input
assign m_axi_rdata  = m_axi_rd.rdata   ;//input
assign m_axi_rlast  = m_axi_rd.rlast   ;//input
assign m_axi_rid    = m_axi_rd.rid     ;//input
assign m_axi_rresp  = m_axi_rd.rresp   ;//input
assign m_axi_rd.rready = m_axi_rready  ; 

//********************  delay  ********************//
delay #(2) delay_arready(.clk(clk), .rst_n(rst_n), .din(m_axi_arready), .dout(s_m_axi_arready));

//**********************************************
// Write Channel: ARVALID, ARADDR, RVALID, RLAST, RREADY
//**********************************************
  //ARVALID
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      m_axi_arvalid <= 1'b0;
  end 
  else begin
      if(cnt_arvalid == m_axi_arlen) begin
        m_axi_arvalid <= 1'b0;
      end
      else if(i_start & s_m_axi_arready & !stop_r_data) begin  
        m_axi_arvalid <= 1'b1;
      end
      else begin
        m_axi_arvalid <= 1'b0;
      end
  end
end

  //cnt_arvalid
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      cnt_arvalid <= 11'b0;
  end 
  else begin
      if(cnt_arvalid == m_axi_arlen) begin
        cnt_arvalid <= 11'b0;
      end
      else if(m_axi_arready && m_axi_arvalid) begin
        cnt_arvalid <= cnt_arvalid + 1'b1;
      end
      else begin
        cnt_arvalid <= cnt_arvalid;
      end
  end
end

  //ARADDR 16*m_axi_awlen
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      m_axi_araddr <= 32'b0;
  end 
  else begin
      if(m_axi_araddr == 32'd8064 && m_axi_rlast) begin
        m_axi_araddr <= 32'b0;
      end
      else if(m_axi_rlast) begin
        m_axi_araddr <= m_axi_araddr + 32'd128;//16*m_axi_awlen
      end
      else begin
        m_axi_araddr <= m_axi_araddr;
      end
  end
end

  //cnt_rvalid
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_rvalid <= 11'b0;
  end 
  else begin
    if(cnt_rvalid == m_axi_arlen) begin
      cnt_rvalid <= 1'b0;
    end
    else if(m_axi_rvalid && m_axi_rready) begin
      cnt_rvalid <= cnt_rvalid + 1'b1;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_data <= 128'b0;
    o_valid<= 1'b0;
  end 
  else begin
    o_data  <= m_axi_rdata;
    o_valid <= m_axi_rvalid;
  end
end



//********************  debug  ********************//


always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_all_rvalid <= 16'b0;
  end 
  else if(cnt_all_rvalid == 16'd1096) begin
    cnt_all_rvalid <= 16'b0;
  end
  else if(cnt_all_rvalid >= 16'd1023) begin
    cnt_all_rvalid <= cnt_all_rvalid + 1'b1;
  end
  else if(m_axi_rvalid) begin
    cnt_all_rvalid <= cnt_all_rvalid + 1'b1;
  end
  else begin
    cnt_all_rvalid <= cnt_all_rvalid;
  end
end

assign stop_r_data = (cnt_all_rvalid < 16'd1023) ? 1'b0 : 1'b1;

endmodule
