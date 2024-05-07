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


module rsp_s2_prep_axi4_m_rd #(
  parameter DELAY_DATA_ARRIVE = 2,
  parameter READ_RAM_WIDTH = 128,
  parameter SAMPLE_WIDTH = 32,
  parameter RD_INTERVAL = 50,
  parameter DATA_NUM = 1024,
  parameter INIT_ADDR = 0,
  parameter ADD_ADDR = 16,
  parameter END_ADDR = 16384,
  parameter BURST_LEN = 8,
  parameter FIFO_CNT          = 7
)(
  input                           clk            ,
  input                           rst_n          ,
  input                           i_start        ,
  axi_v4_rd_if.master             m_axi_rd       ,
  output reg [READ_RAM_WIDTH-1:0] o_data         ,
  output reg                      o_data_valid   ,
  output reg                      o_data_last    ,
  input                           fifo_afull     ,
  input  [5:0]                    fifo_word_counter     
);
//********************  localparam  ********************//
localparam CNT_RD_WIDTH = $clog2(DATA_NUM);
localparam RD_INTERVAL_WIDTH = $clog2(RD_INTERVAL);

//********************  reg&wire  ********************//
//write_address
reg [SAMPLE_WIDTH/2-1:0]                    m_axi_araddr  ;         
reg [3-1:0]                                 m_axi_arprot  ;
wire                                        m_axi_arvalid ;
wire                                        m_axi_arready ;  
reg                                         s_m_axi_arready;  
reg [3-1:0]                                 m_axi_arsize  ;
reg [2-1:0]                                 m_axi_arburst ;
reg [4-1:0]                                 m_axi_arcache ;
reg [8-1:0]                                 m_axi_arlen   ;          
reg [1-1:0]                                 m_axi_arlock  ;          
reg [4-1:0]                                 m_axi_arid    ;    

//read_data
wire                                        m_axi_rvalid  ; 
wire[4-1:0]                                 m_axi_rid     ;
wire[READ_RAM_WIDTH-1:0]                    m_axi_rdata   ;   
wire                                        m_axi_rlast   ;     
wire [2-1:0]                                m_axi_rresp   ; 
reg                                         m_axi_rready  ;    


//cnt
reg [CNT_RD_WIDTH:0]    cnt_arvalid ;
reg [CNT_RD_WIDTH:0]    cnt_rvalid  ;
reg [CNT_RD_WIDTH:0] cnt_rd_en;
reg [RD_INTERVAL_WIDTH:0] cnt_rd_interval;

//
reg i_start_d0;
reg i_start_d1;
wire start_p;
reg start;

//********************  assign  ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    m_axi_arid    <= 4'd1;
    m_axi_arlen   <= BURST_LEN-1;//
    m_axi_arburst <= 2'd1;//
    m_axi_arsize  <= 3'd4;//
    m_axi_arcache <= 4'd0;
    m_axi_arprot  <= 4'd0;
    m_axi_arlock  <= 1'b0;
    m_axi_rready  <= 1'b1;
  end 
  else begin
    m_axi_arid    <= 4'd1;
    m_axi_arlen   <= BURST_LEN-1;
    m_axi_arburst <= 2'd1;
    m_axi_arsize  <= 3'd4;
    m_axi_arprot  <= 4'd0;
    m_axi_arlock  <= 1'b0;
    m_axi_rready  <= 1'b1;
  end
end

assign m_axi_rd.arvalid = m_axi_arvalid;
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

//********************  cnt  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_rd_en <= {CNT_RD_WIDTH{1'b0}};
  end
  else begin
    if(cnt_rd_en == DATA_NUM-1)
      cnt_rd_en <= {CNT_RD_WIDTH{1'b0}};
    else if(m_axi_rd.rvalid)
      cnt_rd_en <= cnt_rd_en + 1'b1;
    else
      cnt_rd_en <= cnt_rd_en;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_rd_interval <= {RD_INTERVAL_WIDTH{1'b0}};
  end
  else begin
    if(cnt_rd_interval == RD_INTERVAL-1)
      cnt_rd_interval <= {RD_INTERVAL_WIDTH{1'b0}};
    else if(cnt_rd_en == DATA_NUM-1)
      cnt_rd_interval <= 1'b1;
    else if(cnt_rd_interval >= 1'b1)
      cnt_rd_interval <= cnt_rd_interval + 1'b1;
  end
end

  //cnt_arvalid
 always @(posedge clk or negedge rst_n) begin
   if(!rst_n) begin
       cnt_arvalid <= {CNT_RD_WIDTH{1'b0}};
   end 
   else begin
       if(cnt_arvalid == BURST_LEN) begin
         cnt_arvalid <= {CNT_RD_WIDTH{1'b0}};
       end
       else if(m_axi_arvalid)
         cnt_arvalid <= 1;
       else if(cnt_arvalid >= 1)begin
         cnt_arvalid <= cnt_arvalid + 1'b1;
       end
   end
 end


  //cnt_rvalid
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    cnt_rvalid <= {CNT_RD_WIDTH{1'b0}};
  end 
  else begin
    if(cnt_rvalid == m_axi_arlen) begin
      cnt_rvalid <= {CNT_RD_WIDTH{1'b0}};
    end
    else if(m_axi_rvalid && m_axi_rready) begin
      cnt_rvalid <= cnt_rvalid + 1'b1;
    end
  end
end

//******************** Indicative signal ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_start_d0 <= 1'b0;
    i_start_d1 <= 1'b0;
  end
  else begin
    i_start_d0 <= i_start;
    i_start_d1 <= i_start_d0;
  end
end
assign start_p = ~i_start_d0 & i_start_d1;
// assign start_p1 = (cnt_rd_interval < (RD_INTERVAL-1)) ? 0 : 1;
assign start_p1 = 0;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) 
    start <= 1'b0;
  else if(cnt_rd_en == DATA_NUM - BURST_LEN || m_axi_araddr == END_ADDR)
    start <= 1'b0;
  else if(start_p || start_p1)
    start <= 1'b1;
  else 
    start <= start;
end

delay #(1) delay_arready(.clk(clk), .rst_n(rst_n), .din(m_axi_arready), .dout(s_m_axi_arready));

//**********************************************
// Write Channel: ARVALID, ARADDR, RVALID, RLAST, RREADY
//**********************************************
  //ARVALID
assign m_axi_arvalid = start && cnt_arvalid == 0 && !fifo_afull;
//always @(posedge clk or negedge rst_n) begin
//  if(!rst_n) begin
//      m_axi_arvalid <= 1'b0;
//  end 
//  else begin
//     if(cnt_arvalid == m_axi_arlen) begin
//      m_axi_arvalid <= 1'b0;
//     end
//     else if(start && cnt_arvalid == 0 && !fifo_afull) begin   
//       m_axi_arvalid <= 1'b1;
//     end
//     else begin
//       m_axi_arvalid = 1'b0;
//     end

    //if(cnt_rd_en == DATA_NUM - BURST_LEN) begin
    //  m_axi_arvalid <= 1'b0;
    //end
    //else if(start && !fifo_afull) begin  
    //  m_axi_arvalid <= 1'b1;
    //end
    //else begin
    //  m_axi_arvalid <= 1'b0;
    //end
//  end
//end

  //ARADDR
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
      m_axi_araddr <= INIT_ADDR;
  end 
  else begin
      if(m_axi_araddr == END_ADDR) begin
        m_axi_araddr <= INIT_ADDR;
      end
      else if(m_axi_rlast && m_axi_rvalid) begin
        m_axi_araddr <= m_axi_araddr + ADD_ADDR;
      end
      else begin
        m_axi_araddr <= m_axi_araddr;
      end
  end
end




//******************** AXI2common ********************//
always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_data <= {READ_RAM_WIDTH{1'b0}};
    o_data_valid<= 1'b0;
  end 
  else begin
    o_data  <= m_axi_rdata;
    o_data_valid <= m_axi_rvalid;
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    o_data_last <= 1'b0;
  end 
  else begin
    if(cnt_rd_en == DATA_NUM-1)
      o_data_last <= 1'b1;
    else 
      o_data_last <= 1'b0;
  end
end


endmodule
