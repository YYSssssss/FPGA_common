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


module RSP_S2_prep_core #(
  parameter DELAY = 2
)
(
  input                             rst_n,
  input                             hrst_n,
  input                             clk,               //500M
  input                             hclk,              //100M
  input                             i_start,
  output                            o_finish,

  //config
  input                             i_is_real,         //switch-- 1:real_cal  0:complex_cal
  input  [12:0]                     i_dc_est_cmp_cnt  ,
  input  [9:0]                      i_dc_est_chp_cnt  ,
  input  [3:0]                      i_dc_est_frm_cnt  ,
  input  [32/2:0]                   i_dc_est_scale    ,
  input  [32/2:0]                   i_intf_est_scale  ,
  input  [3:0]                      i_dc_config_mode    ,
  input  [3:0]                      i_intf_config_mode  ,
  input  [3:0]                      i_combination_config_mode  ,
  input  [3:0]                      i_phase_config_mode  ,

  //DC_estimation
  input  [32-1:0]                   i_dc_u,
  output [32-1:0]                   o_dc_u,

  //INTF_estimation
  input  [32-1:0]                   i_intf_cmp,
  output [32-1:0]                   o_intf_cmp,

  //phase_gen: AHB to RAM
  input  [31:0]                     i_phase_ram_addra,
  input                             i_phase_ram_bwea,
  input                             i_phase_ram_ena,
  input  [31:0]                     i_phase_ram_dina,
  output [31:0]                     o_phase_ram_douta,
  input                             i_phase_ram_wena,
  input  [32-1:0]                   i_phase_w,
  input  [32-1:0]                   i_phase_coe,

  input  [64-1:0]                   i_data_formatter,

  //S1
  // output [128-1:0]                 o_m1_wr_data,            
  // output [32-1:0]                  o_m1_wr_addr,
  // output                           o_m1_wr_en,
  // output                           o_m1_wr_wea,     
  // input  [128-1:0]                 i_m0_rd_data,            
  // output [32-1:0]                  o_m0_rd_addr,
  // output                           o_m0_rd_en

  //S2
  axi_v4_rd_if.master               m_axi_rd,
  axi_v4_wr_if.master               m_axi_wr

);
//********************  parameter  ********************//
localparam READ_RAM_WIDTH = 128;
localparam SAMPLE_WIDTH   = 32;
localparam INTERVAL       = 50;
localparam DATA_NUM       = 1024;
localparam RD_INIT_ADDR   = 0;
localparam WR_INIT_ADDR   = 16384;
localparam ADD_ADDR       = 128;
localparam RD_END_ADDR    = 16384;
localparam WR_END_ADDR    = 32768;
localparam PACKET_SELECT  = 3;
localparam BURST_LEN      = 8;
localparam FIFO_CNT       = 7;


//********************  reg & wire  ********************//
wire [READ_RAM_WIDTH-1:0] rd_data ;
reg                       rd_valid;
reg                       rd_last ;
wire [READ_RAM_WIDTH-1:0] wr_data ;
reg                       wr_valid;

//fifo
wire                      fifo_empty;
wire [READ_RAM_WIDTH-1:0] s_wr_data ;
wire                      fifo_rd_en;
wire                      fifo_afull;
wire [5:0]                fifo_word_counter;

//********************  AXI  ********************//
axi4_master_read #(
  .DELAY_DATA_ARRIVE    (DELAY         ),
  .READ_RAM_WIDTH       (READ_RAM_WIDTH),
  .SAMPLE_WIDTH         (SAMPLE_WIDTH  ),
  .RD_INTERVAL          (INTERVAL      ),
  .DATA_NUM             (DATA_NUM      ),
  .INIT_ADDR            (RD_INIT_ADDR  ),
  .ADD_ADDR             (ADD_ADDR      ),
  .END_ADDR             (RD_END_ADDR   ),
  .BURST_LEN            (BURST_LEN     )
)u_axi4_master_read(
  .clk          (clk      ),  
  .rst_n        (rst_n    ),
  .i_start      (i_start  ),
  .m_axi_rd     (m_axi_rd ),
  .o_data       (rd_data  ),
  .o_data_valid (rd_valid ),
  .o_data_last  (rd_last  ),
  .fifo_afull   (fifo_afull),
  .fifo_word_counter   (fifo_word_counter)
);


fifo_cp u_fifo_cp(
  .clk            (clk),
  .rst_n          (rst_n),
  .din            (wr_data), 
  .push           (wr_valid),
  .dout           (s_wr_data),
  .pop            (fifo_rd_en),
  .full           (),
  .afull          (fifo_afull),
  .empty          (fifo_empty),
  .word_counter   (fifo_word_counter)
);
axi4_master_write #(
  .DELAY_DATA_ARRIVE (DELAY         ),
  .READ_RAM_WIDTH    (READ_RAM_WIDTH),
  .SAMPLE_WIDTH      (SAMPLE_WIDTH  ),
  .WR_INTERVAL       (INTERVAL      ),
  .DATA_NUM          (DATA_NUM      ),
  .INIT_ADDR         (WR_INIT_ADDR  ),
  .ADD_ADDR          (ADD_ADDR      ),
  .END_ADDR          (WR_END_ADDR   ),
  .BURST_LEN         (BURST_LEN     ),
  .FIFO_CNT          (FIFO_CNT      )
)u_axi4_master_write(
  .clk                (clk),  
  .rst_n              (rst_n),  
  .i_data             (s_wr_data),  
  .i_data_valid       (wr_valid),  

  .fifo_empty         (fifo_empty),
  .fifo_rd_en         (fifo_rd_en),
  .fifo_afull         (fifo_afull),
  .fifo_word_counter  (fifo_word_counter),

  .o_finish           (o_finish),
  .m_axi_wr           (m_axi_wr)
);


//********************  AHB2RAM  ********************//



//********************  top  ********************//
chirp_processing_top #(
  .READ_RAM_WIDTH (READ_RAM_WIDTH),
  .SAMPLE_WIDTH   (SAMPLE_WIDTH),
  .DATA_NUM       (DATA_NUM),
  .PACKET_SELECT  (PACKET_SELECT)
)
 u_chirp_processing_top(
  .rst_n                    (rst_n                  ),
  .clk                      (clk                    ),
  .i_switch                 (i_is_real              ),
  .DC_DCEST_SMP_CNT         (i_dc_est_cmp_cnt       ),
  .DC_DCEST_CHP_CNT         (i_dc_est_chp_cnt       ),
  .DC_DCEST_FRM_CNT         (i_dc_est_frm_cnt       ),
  .DC_DCEST_SCALE           (i_dc_est_scale         ),
  .DC_config_mode           (i_dc_config_mode       ),
  .i_dc_u                   (i_dc_u),
  .o_dc_u                   (o_dc_u),
  .INTF_DCEST_SMP_CNT       (i_dc_est_cmp_cnt       ),
  .INTF_DCEST_CHP_CNT       (i_dc_est_chp_cnt       ),
  .INTF_DCEST_FRM_CNT       (i_dc_est_frm_cnt       ),
  .INTF_DCEST_SCALE         (i_intf_est_scale       ),
  .INTF_config_mode         (i_intf_config_mode     ),
  .i_intf_cmp               (i_intf_cmp),
  .o_intf_cmp               (o_intf_cmp),
  .combination_config_mode  (i_combination_config_mode),
  .i_x0                     (rd_data                ),
  .i_x0_valid               (rd_valid               ),
  .i_x0_last                (rd_last                ),
  .i_w                      (i_phase_w              ),
  .o_y0                     (wr_data                ),
  .o_y0_valid               (wr_valid               )
);

endmodule
