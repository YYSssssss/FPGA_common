`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/25 12:54:33
// Design Name:  Jade YU
// Module Name: debug_fifo_data_gen
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
`timescale 1ps/1ps

module
debug_fifo_data_gen #(
  parameter integer C_MASTER_ID = 0,
  parameter width = 32
)
(
  /**************** Stream Signals ****************/
  output reg                             m_axis_tvalid = 0,
  input  wire                            m_axis_tready,
  output wire [width-1:0]     m_axis_tdata,
  output reg  [width/8-1:0]   m_axis_tkeep,
  output reg                             m_axis_tlast = 0,
  output reg  [1-1:0]     m_axis_tuser,
  /**************** System Signals ****************/
  input  wire                            aclk,
  input  wire                            aresetn,
  /**************** Done Signal ****************/
  output reg                             done = 0
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
  reg [1-1:0]   tuser_i = {1{1'b1}};
  reg [16-1:0] pcnt_i = 16'h0000;
  reg [16-1:0] tcnt_i = 16'h0000;
  wire         done_i;
  wire         transfer_i;
  wire         areset = ~aresetn;
  reg [2-1:0]  areset_i = 2'b00;

  /**************** Assign Signals ****************/
  assign m_axis_tkeep = {P_M_TDATA_BYTES{1'b1}};
  assign m_axis_tdata = tdata_i;
  assign m_axis_tuser = tuser_i;
  assign transfer_i = m_axis_tready && m_axis_tvalid;

    assign done_i = (transfer_i && (pcnt_i == P_M_DONE_NUM - 1'b1) && (tcnt_i == P_M_PACKET_SIZE));


  // Register Reset
  always @(posedge aclk) begin
    areset_i <= {areset_i[0], areset};
  end

  //**********************************************
  // TDATA
  //**********************************************
  // generate
  //   for(i=0; i<P_M_TDATA_BYTES; i=i+1) begin: tdata_incr_g
  //     always @(posedge aclk) begin
  //       if(areset) begin
  //         tdata_i[8*i+:8] <= 8'h00;
  //       end
  //       else
  //       begin
  //         tdata_i[8*i+:8] <= (transfer_i) ? tdata_i[8*i+:8] + 1'b1 : tdata_i[8*i+:8];
  //       end
  //     end
  //   end
  // endgenerate

  generate
    for(i=0; i<P_M_DONE_NUM; i=i+1) begin: tdata_incr_g
      always @(posedge aclk) begin
        if(areset) begin
          tdata_i <= 'h00;
        end
        else
        begin
          tdata_i <= (transfer_i) ? tdata_i + 1'b1 : tdata_i;
        end
      end
    end
  endgenerate

  //**********************************************
  // TUSER
  //**********************************************
  generate
    for(i=0; (i<P_M_TUSER_BYTES); i=i+1) begin: tuser_incr_g
      if (i<P_M_TUSER_BYTES-1) begin: tuser_incr_g_full
        always @(posedge aclk) begin
          if(areset) begin
            tuser_i[8*i+:8] <= {8{1'b1}};
          end
          else
          begin
            tuser_i[8*i+:8] <= (transfer_i) ? tuser_i[8*i+:8] - 1'b1 : tuser_i[8*i+:8];
          end
        end
      end
      else                     begin : tuser_incr_g_remainder
        always @(posedge aclk) begin
          if(areset) begin
            tuser_i[8*i+:1-(8*i)] <= {(1 - (8*i)){1'b1}};
          end
          else
          begin
            tuser_i[8*i+:1-(8*i)] <= (transfer_i) ? tuser_i[8*i+:1-(8*i)] - 1'b1 : tuser_i[8*i+:1-(8*i)];
          end
        end
      end
    end
  endgenerate



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
  always @(posedge aclk) begin
    if(areset) begin
      m_axis_tlast <= 1'b0;
    end
    else
    begin
      // TLAST
      if(areset_i == 2'b10) begin
        m_axis_tlast <= 1'b1;
      end
      else if((pcnt_i >= (P_M_SINGLES_NUM - 1'b1)) && transfer_i && m_axis_tlast) begin
        m_axis_tlast <= 1'b0;
      end
      else if(tcnt_i == (P_M_PACKET_SIZE - 1'b1) && transfer_i) begin
        m_axis_tlast <= 1'b1;
      end
      else begin
        m_axis_tlast <= m_axis_tlast;
      end
    end
  end


  //**********************************************
  // PCNT, TCNT, DONE
  //**********************************************
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

