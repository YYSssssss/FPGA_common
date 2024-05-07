`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Jade_Yu
// 
// Create Date: 2023/08/28 12:03:43
// Design Name: Jade_Yu
// Module Name: chirp_processing_core
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


module chirp_processing_core #(
  parameter DEALAY = 2
)
(
  input                             rst_n,
  input                             clk,
  input                             clk1,
  input                             i_switch,        //switch-- 1:real_cal  0:complex_cal
  input  [12:0]                     DC_EST_SMP_CNT  ,
  input  [9:0]                      DC_EST_CHP_CNT  ,
  input  [3:0]                      DC_EST_FRM_CNT  ,
  input  [32/2:0]                   DC_EST_SCALE    ,
  input  [12:0]                     INTF_EST_SMP_CNT,
  input  [9:0]                      INTF_EST_CHP_CNT,
  input  [3:0]                      INTF_EST_FRM_CNT,
  input  [32/2:0]                   INTF_EST_SCALE  ,
  input  [3:0]                      DC_config_mode    ,
  input  [3:0]                      INTF_config_mode  ,
  input  [3:0]                      combination_config_mode  ,
  input  [3:0]                      phase_config_mode  ,
  input                             phase_rom_sel,
  input  [31:0]                     phase_rom_addra,
  input  [31:0]                     phase_rom_addrb,
  input                             phase_rom_bwea,
  input  [31:0]                     phase_rom_dina,
  input  [31:0]                     phase_rom_doutb,
  input                             phase_rom_enb,
  input                             phase_rom_wena,
  input  [32-1:0]                   phase_w,             //i_W
  input  [32-1:0]                   phase_coe,
  // output [128-1:0]                 o_y0,            //output complex or real
  // output                           o_y0_valid       //output complex or real
  // input  [128-1:0]                 i_x0,            //input complex or real 128bit
  // input  [128-1:0]                 i_x0_valid,
  input                             i_start,
  output                            o_end,
  axi_v4_rd_if.master               m_axi_rd,
  axi_v4_wr_if.master               m_axi_wr

);
//********************  parameter  ********************//
localparam READ_RAM_WIDTH = 128;
localparam SAMPLE_WIDTH = 32;


//********************  reg & wire  ********************//
reg [15:0] cnt_valid;
reg        x0_last;

reg [READ_RAM_WIDTH-1:0] i_s_x0       ;
reg                      i_s_x0_valid ;
reg [READ_RAM_WIDTH-1:0] m_rd_data  ;
reg [READ_RAM_WIDTH-1:0] s_m_rd_data;
reg                      m_rd_valid ;
reg [READ_RAM_WIDTH-1:0] s_y0       ;
reg [READ_RAM_WIDTH-1:0] s_y0_out   ;
reg                      s_y0_valid ;

reg                      buffer_empty;
reg                      buffer_full;

wire       s_x0_last;


//********************  cnt & x0_last  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_valid <= {16{1'b0}};
    x0_last   <= 1'b0;
  end
  else if(cnt_valid == 16'd1023) begin
    cnt_valid <= 16'b0;
    x0_last   <= 1'b1;
  end
  else if(i_s_x0_valid) begin
    cnt_valid <= cnt_valid + 1'b1;
    x0_last   <= 1'b0;
  end
  else begin
    cnt_valid <= cnt_valid;
    x0_last   <= 1'b0;
  end
end

//********************  delay  ********************//
delay #(1) delay_i_x0_valid(.clk(clk), .rst_n(rst_n), .din(x0_last), .dout(s_x0_last));

//********************  AXI  ********************//
axi4_master_read u_axi4_master_read(
  .clk          (clk),  
  .rst_n        (rst_n),
  .i_start      (i_start),
  .i_last       (s_x0_last),
  .o_data       (s_m_rd_data),
  .o_valid      (m_rd_valid),
  .m_axi_rd     (m_axi_rd)
);

delay_data #(
  .DEPTH      (2),
  .DATA_WIDTH (128)
) u_master_read(
  .clk   (clk  ),
  .rst_n (rst_n),
  .i_x0  (s_m_rd_data),
  .o_y0  (m_rd_data)
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    i_s_x0        <= 128'b0;
    i_s_x0_valid  <= 1'b0;
  end
  else begin
    i_s_x0       <= m_rd_data ;
    i_s_x0_valid <= m_rd_valid;
  end
end








fifo_cp #(
  .WIDTH       (128)
  // .DEPTH_FULL  (2)
) u_core_fifo(
  .clk     (clk),
  .rst_n   (rst_n),
  .push    (s_y0_valid),
  .pop     (fifo_pop_en),
  .din     (s_y0),
  .dout    (s_y0_out),
  .empty   (buffer_empty),
  .full    (buffer_full),
  .afull   ()
);


axi4_master_write u_axi4_master_write(
  .clk          (clk),  
  .rst_n        (rst_n),
  .i_start      (!buffer_empty),
  .i_last       (1'b0),
  .i_x0         (s_y0_out),
  .o_start      (fifo_pop_en),
  .o_end        (),
  .m_axi_wr     (m_axi_wr)
);

//********************  top  ********************//
chirp_processing_top #(
  .READ_RAM_WIDTH (READ_RAM_WIDTH),
  .SAMPLE_WIDTH   (SAMPLE_WIDTH)
)
 u_chirp_processing_top(
  .rst_n                    (rst_n                  ),
  .clk                      (clk                    ),
  .i_switch                 (i_switch               ),
  .DC_DCEST_SMP_CNT         (DC_EST_SMP_CNT       ),
  .DC_DCEST_CHP_CNT         (DC_EST_CHP_CNT       ),
  .DC_DCEST_FRM_CNT         (DC_EST_FRM_CNT       ),
  .DC_DCEST_SCALE           (DC_EST_SCALE         ),
  .DC_config_mode           (         ),
  .INTF_DCEST_SMP_CNT       (INTF_EST_SMP_CNT     ),
  .INTF_DCEST_CHP_CNT       (INTF_EST_CHP_CNT     ),
  .INTF_DCEST_FRM_CNT       (INTF_EST_FRM_CNT     ),
  .INTF_DCEST_SCALE         (INTF_EST_SCALE       ),
  .INTF_config_mode         (       ),
  .combination_config_mode  (),
  .i_x0                     (i_s_x0                   ),
  .i_x0_valid               (i_s_x0_valid             ),
  .i_x0_last                (s_x0_last              ),
  .i_w                      (phase_w                ),
  .o_y0                     (s_y0                   ),
  .o_y0_valid               (s_y0_valid             )
);

endmodule
