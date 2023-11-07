// ----------------------------------------------------------------------------
//  Title   : ROE-Framer
//  Project : Radio Over Ethernet Subsystem.
// ----------------------------------------------------------------------------
//  File    : oran_radio_if_radio_source.sv
// ----------------------------------------------------------------------------
//
// DISCLAIMER
// This disclaimer is not a license and does not grant any
// rights to the materials distributed herewith. Except as
// otherwise provided in a valid license issued to you by
// Xilinx, and to the maximum extent permitted by applicable
// law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
// WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
// AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
// BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
// INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
// (2) Xilinx shall not be liable (whether in contract or tort,
// including negligence, or under any other theory of
// liability) for any loss or damage of any kind or nature
// related to, arising under or in connection with these
// materials, including for any direct, or any indirect,
// special, incidental, or consequential loss or damage
// (including loss of data, profits, goodwill, or any type of
// loss or damage suffered as a result of any action brought
// by a third party) even if such damage or loss was
// reasonably foreseeable or Xilinx had been advised of the
// possibility of the same.
// 
// CRITICAL APPLICATIONS
// Xilinx products are not designed or intended to be fail-
// safe, or for use in any application requiring fail-safe
// performance, such as life-support or safety devices or
// systems, Class III medical devices, nuclear facilities,
// applications related to the deployment of airbags, or any
// other applications that could lead to death, personal
// injury, or severe property or environmental damage
// (individually and collectively, "Critical
// Applications"). Customer assumes the sole risk and
// liability of any use of Xilinx products in Critical
// Applications, subject only to applicable laws and
// regulations governing limitations on product liability.
// 
// THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
// PART OF THIS FILE AT ALL TIMES. 
//
// ----------------------------------------------------------------------------
`timescale 1ps/1ps

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
module oran_radio_if_0_ba_radio_source (

  // AXIS ports
  output wire   [63:0] m_src_tdata    ,
  output wire    [7:0] m_src_tkeep    ,
  output wire          m_src_tvalid   ,
  output wire          m_src_tlast    ,
  input  wire          m_src_tready    ,
  input logic  [24:0]  m_src_tuser           , // Request message to the BF

  input  wire    [7:0] slot                  ,
  input  wire   [15:0] ifg_clocks_minus1     , // interframe gap. Min is 2 cycles
  input  wire   [15:0] pkt_size_bytes        , // Packet size in (bytes - 8)
  input  wire          radio_source_enable   , // Optional enable for source

  // Clocks
  input  wire          m_src_aresetn         ,
  input  wire          m_src_aclk            ,
  output reg           fram_radio_start      ,
  output reg           defm_radio_start
  
);


logic  [7:0][3:0]     cc_ul_ud_iq_width  ;
logic  [7:0][3:0]     cc_ul_ud_comp_meth ;

assign cc_ul_ud_iq_width [0]    = 4'd9;
assign cc_ul_ud_comp_meth[0]    = 4'd0;
assign cc_ul_ud_iq_width [1]    = 4'd9;
assign cc_ul_ud_comp_meth[1]    = 4'd0;
assign cc_ul_ud_iq_width [2]    = 4'd9;
assign cc_ul_ud_comp_meth[2]    = 4'd0;
assign cc_ul_ud_iq_width [3]    = 4'd9;
assign cc_ul_ud_comp_meth[3]    = 4'd0;
assign cc_ul_ud_iq_width [4]    = 4'd9;
assign cc_ul_ud_comp_meth[4]    = 4'd0;
assign cc_ul_ud_iq_width [5]    = 4'd9;
assign cc_ul_ud_comp_meth[5]    = 4'd0;
assign cc_ul_ud_iq_width [6]    = 4'd9;
assign cc_ul_ud_comp_meth[6]    = 4'd0;
assign cc_ul_ud_iq_width [7]    = 4'd9;
assign cc_ul_ud_comp_meth[7]    = 4'd0;

oran_radio_if_bf_buf_model #(

    .max_num_cc      (8  ),
    .req_depth       (10 )

) oran_radio_if_bf_buf_model_i(
  // 
  .s_fram_data_tdata        (m_src_tdata        ),
  .s_fram_data_tkeep        (m_src_tkeep        ),
  .s_fram_data_tvalid       (m_src_tvalid       ),
  .s_fram_data_tready       (m_src_tready       ),
  .s_fram_data_tlast        (m_src_tlast        ),
                            
  .s_fram_data_tuser        (m_src_tuser        ),
                            
  .clk                      (m_src_aclk         ),
  .aresetn                  (m_src_aresetn      ),

  .cc_ul_ud_iq_width        (cc_ul_ud_iq_width ),  
  .cc_ul_ud_comp_meth       (cc_ul_ud_comp_meth)
  );

endmodule

//-----------------------------------------------------------------------------                   
// 
//-----------------------------------------------------------------------------                   
module oran_radio_if_bf_buf_model #(
  parameter max_num_cc      = 8             ,
  parameter req_depth       = 5
  ) (

  // internal bus
  input logic           clk                 ,
  input logic           aresetn             ,
  
  // CC configuration interface
  input  logic [max_num_cc-1:0][3:0]        cc_ul_ud_iq_width , 
  input  logic [max_num_cc-1:0][3:0]        cc_ul_ud_comp_meth, 
  
                             
  // Input SS data from the BF Buffer       
  output logic [63:0]   s_fram_data_tdata   ,
  output logic [7:0]    s_fram_data_tkeep   ,
  output logic          s_fram_data_tvalid  ,
  output logic          s_fram_data_tlast   ,
  input  logic          s_fram_data_tready  ,

  input  logic [24:0]   s_fram_data_tuser     // Request message to the BF
  
);

// tuser description
//         [24]     : Insert Request            (1bit)
// RB      [23:15]  : Position of first RB      (9bit)
// numPrb  [14:7]   : Number of requested RBs   (8bit)
// cc      [6:4]    : Component Carrier         (3bit)
// ss      [3:0]    : Spatial Stream            (4bit)

logic  [8:0]  tu_rb        =0; // [23:15]
logic  [7:0]  tu_num_rb    =0; // [14:7] 
logic  [2:0]  tu_cc        =0; // [6:4]  
logic  [3:0]  tu_ss        =0; // [3:0]  
                
logic  [7:0]  tu_num_rb_m1 =0; // [14:7] 

localparam req_width = 24; // when the Insert Request is active, store all the remaining bits
logic [req_depth:0][req_width-1:0] req_mem;

logic [$clog2(req_depth) - 1: 0]  req_mem_rd =0;
logic [$clog2(req_depth) - 1: 0]  req_mem_wr =0;
logic [$clog2(req_depth) - 1: 0]  req_mem_cnt=0;

enum {IDLE, PREL0, PREL, READ, LAST} ul_service_fsm;

logic [5:0] byte_cnt;
logic [7:0] rb_cnt;
logic [5:0] rb_size;    // bytes required per RB
logic [5:0] rb_size_r;    // bytes required per RB
logic [5:0] rb_size_rm8;
logic [5:0] bytes_left;
logic [5:0] byte_rem;   // bytes belonging to the RB in the last word

logic [2:0] cc_id;

logic [3:0] nibble_0;
logic [3:0] nibble_2;
logic [3:0] nibble_4;
logic [3:0] nibble_6;

logic [8:0] rb_ord;
logic [8:0] rb_ord_i;
logic [63:0] radio_data_word;
logic [63:0] radio_data_word_i;

logic [24:0]   s_fram_data_tuser_pl=0;


// at the moment just uncompressed and block floating point methods are supported
assign cc_id        = req_mem[req_mem_rd][6:4];
assign rb_size      = (cc_ul_ud_comp_meth[cc_id] == 4'd1) ? (cc_ul_ud_iq_width[cc_id] * 3 + 1) : 6'd48;
assign byte_rem     = rb_size - byte_cnt;

assign nibble_0     = byte_cnt[5:2];
assign nibble_2     = byte_cnt[5:2] + 4'd2;
assign nibble_4     = byte_cnt[5:2] + 4'd4;
assign nibble_6     = byte_cnt[5:2] + 4'd6;

assign rb_ord       = tu_rb + rb_cnt;
assign rb_ord_i     = rb_ord + 9'd1;

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
always @(posedge clk) begin
  s_fram_data_tkeep    <= 8'hff;
  s_fram_data_tlast    <= 1'b0;
  rb_size_r            <= rb_size;
  rb_size_rm8          <= rb_size_r -'d8; // We can live with this as its not needed until 2nd RB
     
  radio_data_word      <= { cc_id, rb_ord, nibble_6,
                            cc_id, rb_ord, nibble_4,
                            cc_id, rb_ord, nibble_2,
                            cc_id, rb_ord, nibble_0};
  radio_data_word_i    <= { cc_id, rb_ord_i, 4'd6,  
                            cc_id, rb_ord_i, 4'd4,  
                            cc_id, rb_ord_i, 4'd2,  
                            cc_id, rb_ord_i, 4'd0}; 

  s_fram_data_tuser_pl <= s_fram_data_tuser;
  
  // Register these to improve timing
  tu_rb                <= req_mem[req_mem_rd][23:15] ; // 
  tu_num_rb            <= req_mem[req_mem_rd][14:7]  ; // 
  tu_cc                <= req_mem[req_mem_rd][6:4]   ; // 
  tu_ss                <= req_mem[req_mem_rd][3:0]   ; // 
  tu_num_rb_m1         <= tu_num_rb - 'd1;

  if(~aresetn) begin
    
    req_mem_rd          <= 'd0;
    req_mem_wr          <= 'd0;
    req_mem_cnt         <= 'd0;
    s_fram_data_tvalid  <= 1'b0;
    s_fram_data_tdata   <= 64'h0;
    byte_cnt            <= 6'h0;
    rb_cnt              <= 8'h0;
    ul_service_fsm      <= IDLE;
  end else begin
    // load new request
    if(s_fram_data_tuser_pl[24]) begin
        req_mem[req_mem_wr] <= s_fram_data_tuser_pl;
        if (req_mem_wr == req_depth)
          req_mem_wr        <= 'd0;                    
        else                    
          req_mem_wr        <= req_mem_wr + 'd1;

        if (s_fram_data_tlast && s_fram_data_tready)
            if (req_mem_rd == req_depth)
                req_mem_rd  <= 'd0;
            else                
                req_mem_rd  <= req_mem_rd + 'd1;
        else
            req_mem_cnt     <= req_mem_cnt + 'd1;
    end
    else if (s_fram_data_tlast && s_fram_data_tready) begin
        req_mem_cnt         <= req_mem_cnt - 'd1;
        if (req_mem_rd == req_depth)                    
            req_mem_rd  <= 'd0;                    
        else                                    
            req_mem_rd  <= req_mem_rd + 'd1;                    
    end    

    // generation of AXI Stream output
    case (ul_service_fsm)
      IDLE  :
        if (req_mem_cnt != 0) begin
            byte_cnt       <= 6'd8;
            ul_service_fsm <= PREL0;
        end
        else begin
            byte_cnt    <= 6'h0; 
            rb_cnt      <= 8'h0;  
        end
      PREL0  : begin
        ul_service_fsm      <= PREL;
      end
      PREL  : begin
        s_fram_data_tvalid  <= 1'b1;
        s_fram_data_tdata   <= radio_data_word;
        bytes_left          <= rb_size_r -'d8;
        ul_service_fsm      <= READ;
      end
      READ  :
        if (s_fram_data_tready)
            // if (byte_rem <= 'd8)
            if (bytes_left <= 'd8) // Updated, this now comes direct from a register
            // generate the last word of RB
                // if (rb_cnt == (req_mem[req_mem_rd][14:7] - 8'd1)) begin
                if (rb_cnt == tu_num_rb_m1) begin
                // end of AXI Stream message
                    s_fram_data_tdata   <= radio_data_word;
                    s_fram_data_tlast   <= 1'b1;
                    //case (byte_rem[2:0])
                    case (bytes_left[2:0])
                      3'h1 : s_fram_data_tkeep  <= 8'h01;
                      3'h2 : s_fram_data_tkeep  <= 8'h03;
                      3'h3 : s_fram_data_tkeep  <= 8'h07;
                      3'h4 : s_fram_data_tkeep  <= 8'h0f;
                      3'h5 : s_fram_data_tkeep  <= 8'h1f;
                      3'h6 : s_fram_data_tkeep  <= 8'h3f;
                      3'h7 : s_fram_data_tkeep  <= 8'h7f;
                    endcase
                    
                    ul_service_fsm      <= LAST;
                end
                else begin
                // end current RB and maybe start the following one
                    rb_cnt      <= rb_cnt + 8'h1;
                    //byte_cnt    <= 6'd8 - byte_rem;
                    byte_cnt    <= 6'd8 - bytes_left;        // Updateed with registered num of bytes left
                    bytes_left  <= rb_size_rm8 + bytes_left; // Registered version of number of bytes left

                    //if (byte_rem == 'd8)
                    if (bytes_left == 'd8)
                    // there are still exactly 8 bytes for the current RB
                        s_fram_data_tdata       <= radio_data_word;
                    else
                        for (int X = 0; X < 8; X++)
                        //if (X < byte_rem)
                        if (X < bytes_left)
                            s_fram_data_tdata[(8*X + 7)-:8]  <= radio_data_word[(8*X + 7)-:8];
                        else
                            //s_fram_data_tdata[(8*X + 7)-:8]  <= radio_data_word_i[(8*(X-byte_rem) + 7)-:8];
                            s_fram_data_tdata[(8*X + 7)-:8]  <= radio_data_word_i[(8*(X-bytes_left) + 7)-:8];
                end
            else begin
            // go on with the same RB
                s_fram_data_tdata   <= radio_data_word;
                byte_cnt            <= byte_cnt   + 5'd8;
                bytes_left          <= bytes_left - 'd8;
            end
            
      LAST  :
        if (s_fram_data_tready) begin
            s_fram_data_tvalid  <= 1'b0;
            byte_cnt            <= 6'h0;
            rb_cnt              <= 8'h0;
            ul_service_fsm      <= IDLE;
        end
        else
            s_fram_data_tlast   <= 1'b1;
      default: begin
        byte_cnt       <= 6'h0;
        rb_cnt         <= 8'h0;
        ul_service_fsm <= IDLE;
      end
    endcase
  end    
end      

endmodule

//-----------------------------------------------------------------------------
// Simple push/pull fifo to manage data messages 
//-----------------------------------------------------------------------------
module push_pull_buf #(
  parameter C_DEPTH   = 20     , // 
  parameter C_WIDTH   = 1      , // 
  parameter C_DEPTH_W = $clog2(C_DEPTH)
) ( 

  input  logic [C_WIDTH-1:0]   in_data    ,
  input  logic                 in_valid   ,
  output logic                 in_overflow=0,

  output logic [C_WIDTH-1:0]   out_data   =0,
  output logic [C_DEPTH_W:0]   out_count  =0, // Extra bit for max value
  input  logic                 out_pop    ,
  output logic                 out_avial  =0,

  input  wire                  clk        ,
  input  wire                  resetn    

);

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
logic [C_DEPTH-1:0][C_WIDTH-1:0]  data_store;
logic [C_DEPTH_W-1:0]             read_addr=0;
logic [C_DEPTH_W-1:0]             write_addr=0;

always @(posedge clk) begin
  
  if (~resetn) begin

    read_addr   <= 'd0;
    write_addr  <= 'd0;
    out_count   <= 'd0;
    in_overflow <= 'd0;

  end else begin
    
    case ({out_pop,in_valid})

    2'b11 : begin

              out_count              <= out_count;
              out_data               <= data_store[read_addr];
              data_store[write_addr] <= in_data;
              out_avial              <= 1'b1;
  
              if (read_addr == (C_DEPTH-1))
                read_addr <= 'd0;
              else
                read_addr <= read_addr + 'd1;
  
              if (write_addr == (C_DEPTH-1))
                write_addr <= 'd0;
              else
                write_addr <= write_addr + 'd1;

            end


    2'b10 : begin

              out_count <= out_count - 'd1;

              if (out_count == 1)
                out_avial  <= 1'b0;
              else
                out_avial  <= 1'b1;

              out_data  <= data_store[read_addr];
              if (read_addr == (C_DEPTH-1))
                read_addr <= 'd0;
              else
                read_addr <= read_addr + 'd1;

            end

    2'b01 : begin

              data_store[write_addr] <= in_data;
              out_count <= out_count + 'd1;
              out_avial <= 1'b1;
  
              if (write_addr == (C_DEPTH-1))
                write_addr <= 'd0;
              else
                write_addr <= write_addr + 'd1;

            end

    2'b00 : begin

              write_addr <= write_addr;
              read_addr  <= read_addr;

            end

    endcase

  end

end

endmodule

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
module ul_prach_gen  #(

   parameter C_ETH_PKT_MAX         = 1048  , // Fram_Eth_Pkt_Max
   parameter C_PRACH_SECTION_DEPTH = 8       // 8, 16, 32, 64
) ( 

  // Data interface
  output logic [63:0] m_fram_prach_tdata        =0,
  output logic [ 7:0] m_fram_prach_tkeep        =0,  
  output logic        m_fram_prach_tvalid       =0,  
  output logic        m_fram_prach_tlast        =0,  
  output logic [31:0] m_fram_prach_tuser        =0,
  input  logic        m_fram_prach_tready       ,

  output logic        s_prach_tready            =1,
  input  logic        s_prach_tvalid            ,
  input  logic [11:0] s_prach_section_id        ,
  input  logic [7 :0] s_prach_udcomphdr         ,
  input  logic [7 :0] s_prach_num_prbc          ,
  input  logic [7:0]  s_prach_ss                ,
  input  logic [3:0]  s_prach_cc                ,

  input               clk                       ,
  input               resetn                    
);

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
localparam C_PRACH_SECTION_DEPTH_W = $clog2(C_PRACH_SECTION_DEPTH);
localparam C_ETH_PKT_MAX_W         = $clog2(C_ETH_PKT_MAX);

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
enum { IDLE, HOLD, LOAD, CALC0, CALC1, SEND, DONE }  data_state;

logic  [11:0]                       o_prach_section_id  ;
logic   [7:0]                       o_prach_udcomphdr   ;
logic   [7:0]                       o_prach_num_prbc    ;

logic   [3:0]                       o_prach_cc    ;
logic   [7:0]                       o_prach_ss    ;

logic                               out_pop             =0;
logic   [C_PRACH_SECTION_DEPTH_W:0] out_count           ;

logic   [C_ETH_PKT_MAX_W-1:0]       data_cycles         = 0;
logic   [C_ETH_PKT_MAX_W-1:0]       data_cycles_m       = 0;
logic   [C_ETH_PKT_MAX_W-1:0]       data_bytesPerRb     = 48;     // Leave as 10 bit for now

logic   [7:0]                       data_tlast          = 'hff;
logic   [7:0]                       hold_off_cycles     = 0;
logic   [7:0][7:0]                  data_word           ;
integer                             i                   ;

logic                               sr_prach_tvalid     =0;
logic  [11:0]                       sr_prach_section_id =0;
logic  [7 :0]                       sr_prach_udcomphdr  =0;
logic  [7 :0]                       sr_prach_num_prbc   =0;
logic  [7 :0]                       sr_prach_ss         =0;
logic  [3 :0]                       sr_prach_cc         =0;

//-----------------------------------------------------------------------------
// Register the inputs for minimal impact
//-----------------------------------------------------------------------------
always @(posedge clk) begin
  sr_prach_tvalid     <= s_prach_tvalid    ;
  sr_prach_section_id <= s_prach_section_id;
  sr_prach_udcomphdr  <= s_prach_udcomphdr ;
  sr_prach_num_prbc   <= s_prach_num_prbc  ;
  sr_prach_ss         <= s_prach_ss        ;
  sr_prach_cc         <= s_prach_cc        ;
end

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------
push_pull_buf #(
   .C_DEPTH   (8), // 
   .C_WIDTH   (8+4+12+8+8)  // 
) prach_req_i ( 

  .in_data         ({sr_prach_ss, sr_prach_cc,sr_prach_section_id,sr_prach_udcomphdr,sr_prach_num_prbc}) ,
  .in_valid        (sr_prach_tvalid  ) ,
  .in_overflow     (  ) ,
  .out_data        ({o_prach_ss,o_prach_cc,o_prach_section_id ,o_prach_udcomphdr ,o_prach_num_prbc }) ,
  .out_count       (out_count ) , // Extra bit for max value
  .out_pop         (out_pop   ) ,
  .out_avial       (  ),
  .clk             (clk       ) ,
  .resetn          (resetn    ) 

);

//-----------------------------------------------------------------------------
// 
//-----------------------------------------------------------------------------

always @(posedge clk) begin

  // May need to m cycle this?
  data_cycles_m <= (o_prach_num_prbc * data_bytesPerRb);

  if (~resetn)
    data_state <= IDLE;
  else
    case(data_state)
      IDLE  : begin
                if (out_count != 0) begin
                  // out_pop    <= 1'd1;
                  data_state <= HOLD;
                  hold_off_cycles <= 'hff;
                end 
              end

      HOLD  : begin
                if (hold_off_cycles == 0) begin
                  data_state <= LOAD;
                  out_pop    <= 1'd1;
                end else begin
                  hold_off_cycles <= hold_off_cycles - 'd1;
                end
              end              

      LOAD  : begin
                out_pop <= 1'd0;
                data_state <= CALC0;
                for (i=0;i<8;i++)
                  data_word[i] <= i;
              end

      CALC0 : begin
                data_state <= CALC1;
                // data_cycles_m is being calculated during this cycle. It must be sampled
                // on the next cycle.
              end

      CALC1 : begin
                data_cycles <= data_cycles_m >> 3;
                data_state <= SEND;
              end

      SEND  : begin

                if ((data_cycles != 0) & m_fram_prach_tready ) begin

                  m_fram_prach_tdata  <= data_word;
                  m_fram_prach_tkeep  <= 'hff;
                  m_fram_prach_tuser  <= {o_prach_num_prbc  , 
                                          o_prach_cc        ,
                                          o_prach_ss        ,
                                          o_prach_section_id}; // Num PRB, Section Id
                  
                  if (m_fram_prach_tvalid) begin
                    data_cycles <= data_cycles - 'd1;

                    if ( (data_cycles == 1) ) begin
                      m_fram_prach_tkeep  <= 'hff;
                      m_fram_prach_tlast  <= 'd1;
                      data_state <= DONE;
                    end else begin
                      m_fram_prach_tkeep  <= 'hff;
                      m_fram_prach_tlast  <= 'd0;
                    end
  
                    for (i=0;i<8;i++)
                      data_word[i] <= data_word[i] + 8;

                  end else begin

                    m_fram_prach_tvalid <= 'd1;
                    for (i=0;i<8;i++)
                      data_word[i] <= data_word[i] + 8;

                  end

                end else begin
                  m_fram_prach_tvalid <= 'd1; // We keep this high!
                end 
              end

      DONE  : begin
                m_fram_prach_tvalid <= 'd0;
                m_fram_prach_tlast  <= 'd0;
                data_state <= IDLE;
              end

    endcase
end

endmodule
