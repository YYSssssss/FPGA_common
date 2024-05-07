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


module rsp_s1_prep_core #(
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
  input      [15:0]                 DATA_NUM       ,
  input      [17:0]                 RD_START_ADDR  ,
  input      [17:0]                 RD_END_ADDR    ,
  input      [17:0]                 WR_START_ADDR  ,
  input      [17:0]                 WR_END_ADDR    ,
  input                             i_sel_16_32    ,
  input                             i_is_real,         //switch-- 1:real_cal  0:complex_cal
  input  [12:0]                     i_dc_est_cmp_cnt  ,
  input  [9:0]                      i_dc_est_chp_cnt  ,
  input  [3:0]                      i_dc_est_frm_cnt  ,
  input  [32/2:0]                   i_dc_est_scale    ,
  input  [32/2:0]                   i_intf_est_scale  ,
  input  [3:0]                      i_dc_config_mode    ,
  input  [3:0]                      i_intf_config_mode  ,
  input  [3:0]                      i_combination_config_mode  ,
  input  [5:0]                      i_phase_entry_select  ,

  //DC_estimation
  input  [64-1:0]                   i_dc_u,
  output [64-1:0]                   o_dc_u,

  //INTF_estimation
  input  [64-1:0]                   i_intf_cmp,
  output [64-1:0]                   o_intf_cmp,

  //phase_gen: AHB to RAM
  input  [10:0]                     i_phase_ram0_addra,
  input                             i_phase_ram0_bwea,
  input                             i_phase_ram0_ena,
  input  [64-1:0]                   i_phase_ram0_dina,
  output [64-1:0]                   o_phase_ram0_douta,
  input                             i_phase_ram0_wena,

  input  [5:0]                      i_phase_ram1_addra,
  input                             i_phase_ram1_bwea,
  input                             i_phase_ram1_ena,
  input  [31:0]                     i_phase_ram1_dina,
  output [31:0]                     o_phase_ram1_douta,
  input                             i_phase_ram1_wena,
  
  input  [64-1:0]                   i_phase_w,
  input  [64-1:0]                   i_phase_coe,

  //S1
   output [128-1:0]                 o_m1_wr_data,            
   output [18-1:0]                  o_m1_wr_addr,
   output                           o_m1_wr_en,
   output [16-1:0]                  o_m1_wr_wea,     
   input  [128-1:0]                 i_m0_rd_data,            
   output [18-1:0]                  o_m0_rd_addr,
   output                           o_m0_rd_en

  //S2
  //axi_v4_rd_if.master               m_axi_rd,
  //axi_v4_wr_if.master               m_axi_wr

);
//********************  parameter  ********************//
localparam READ_RAM_WIDTH = 128;
localparam SAMPLE_WIDTH   = 32;
localparam INTERVAL       = 50;
localparam ADD_ADDR       = 16;//16;
localparam PACKET_SELECT   = 3;


//********************  reg & wire  ********************//

wire [READ_RAM_WIDTH-1:0] rd_data ;
reg                       rd_valid;
reg                       rd_last ;
wire [READ_RAM_WIDTH-1:0] wr_data ;
reg                       wr_valid;

//********************  AHB2RAM  ********************//

//********************  read_ram  ********************//
rsp_s1_prep_read_ram #(
  .DELAY_DATA_ARRIVE    (2        ),
  .READ_RAM_WIDTH       (READ_RAM_WIDTH),
  .SAMPLE_WIDTH         (SAMPLE_WIDTH  ),
  .RD_INTERVAL          (INTERVAL      ),
  .ADD_ADDR             (ADD_ADDR      )
)u_rsp_s1_prep_read_ram(
  .clk            (clk),
  .rst_n          (rst_n),
  .DATA_NUM       (DATA_NUM),
  .RD_START_ADDR  (RD_START_ADDR),
  .RD_END_ADDR    (RD_END_ADDR),
  .i_start        (i_start),
  .i_m0_rd_data   (i_m0_rd_data),            
  .o_m0_rd_addr   (o_m0_rd_addr),
  .o_m0_rd_en     (o_m0_rd_en),
  .o_data         (rd_data ),
  .o_data_valid   (rd_valid),
  .o_data_last    (rd_last )
);


//********************  write_ram  ********************//
rsp_s1_prep_write_ram #(
  .DELAY_DATA_ARRIVE (1           ),
  .READ_RAM_WIDTH    (READ_RAM_WIDTH  ),
  .SAMPLE_WIDTH      (SAMPLE_WIDTH    ),
  .ADD_ADDR          (ADD_ADDR        )
)u_rsp_s1_prep_write_ram(
  .clk            (clk),
  .rst_n          (rst_n),

  .DATA_NUM       (DATA_NUM),
  .WR_START_ADDR  (WR_START_ADDR),
  .WR_END_ADDR    (WR_END_ADDR),

  .i_data         (wr_data),
  .i_data_valid   (wr_valid),
  .i_data_last    (),
  .o_m1_wr_data   (o_m1_wr_data),            
  .o_m1_wr_addr   (o_m1_wr_addr),
  .o_m1_wr_en     (o_m1_wr_en  ),
  .o_m1_wr_wea    (o_m1_wr_wea ),
  .o_finish       (o_finish    )
);



//********************  top  ********************//
rsp_s1_prep_top #(
  .READ_RAM_WIDTH (READ_RAM_WIDTH),
  .SAMPLE_WIDTH   (SAMPLE_WIDTH),
  .DATA_NUM       (1024),
  .PACKET_SELECT  (PACKET_SELECT)
)
 u_rsp_s1_prep_top(
  .rst_n                    (rst_n                  ),
  .clk                      (clk                    ),
  .hrst_n                   (hrst_n                 ),
  .hclk                     (hclk                   ),
  .i_start                  (i_start                ),
  .i_sel_16_32              (i_sel_16_32            ),
  .i_is_real                (i_is_real              ),
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
  
  .i_phase_w                (i_phase_w),
  .i_phase_entry_select     (i_phase_entry_select),
  .i_phase_coe              (i_phase_coe        ),
  .i_phase_ram0_addra       (i_phase_ram0_addra ),
  .i_phase_ram0_bwea        (i_phase_ram0_bwea  ),
  .i_phase_ram0_ena         (i_phase_ram0_ena   ),
  .i_phase_ram0_dina        (i_phase_ram0_dina  ),
  .o_phase_ram0_douta       (o_phase_ram0_douta ),
  .i_phase_ram0_wena        (i_phase_ram0_wena  ),
  .i_phase_ram1_addra       (i_phase_ram1_addra ),
  .i_phase_ram1_bwea        (i_phase_ram1_bwea  ),
  .i_phase_ram1_ena         (i_phase_ram1_ena   ),
  .i_phase_ram1_dina        (i_phase_ram1_dina  ),
  .o_phase_ram1_douta       (o_phase_ram1_douta ),
  .i_phase_ram1_wena        (i_phase_ram1_wena  ),

  .i_x0                     (rd_data                ),
  .i_x0_valid               (rd_valid               ),
  .i_x0_last                (rd_last                ),
  .o_y0                     (wr_data                ),
  .o_y0_valid               (wr_valid               )
);

endmodule
