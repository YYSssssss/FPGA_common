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
`include "rsp_common_defines.vh"
`include "rsp_s1_prep_defines.vh"

module rsp_s1_prep_core #(
  parameter DELAY                = 2   ,
  parameter L1_DATA_WIDTH        = 128 ,
  parameter SAMPLE_WIDTH         = 32  ,
  parameter SMP_CNT              = 13  ,
  parameter CHP_CNT              =  9  ,
  parameter FRM_CNT              =  3  ,
  parameter TWIDDLE_ADDR         =  8  ,
  parameter TWIDDLE_WIDTH        =  64 ,
  parameter ENTRY_ADDR           =  6  ,
  parameter ENTRY_WIDTH          =  32 ,

  //DEBUG
  parameter DEBUG_PACKET_SELECT    = 3

)
(
  input                                   rst_n,
  input                                   hrst_n,
  input                                   clk,               
  input                                   hclk,              
  input                                   i_start,
  output                                  o_finish,
      
  //config      
  input [`DATA_BURST_LEN_WIDTH-1:0]       CSR_BURST_LEN         ,
  input [`L1_ADDR_WIDTH-1:0]              CSR_RD_START_ADDR     ,
  input [`L1_ADDR_WIDTH-1:0]              CSR_WR_START_ADDR     ,
  input [`DATA_FORMATTER_WIDTH-1:0]       CSR_SEL_DATA_FORMATTRT,
  input [SMP_CNT:0]                       CSR_EST_SMP_CNT    ,
  input [CHP_CNT:0]                       CSR_EST_CHP_CNT    ,
  input [FRM_CNT:0]                       CSR_EST_FRM_CNT    ,
  input [SAMPLE_WIDTH/2:0]                CSR_DC_EST_SCALE      ,
  input [SAMPLE_WIDTH/2:0]                CSR_INTF_EST_SCALE    ,
  input [`MODE_WIDTH-1:0]                 CSR_DC_CFG_MODE       ,
  input [`MODE_WIDTH-1:0]                 CSR_INTF_CFG_MODE     ,
  input [`MODE_WIDTH-1:0]                 CSR_COMB_CFG_MODE     ,
  input [`ENTRY_ADDR:0]                   CSR_PHASE_ENTRY_SEL   ,
      
  //DC_estimation      
  input  [SAMPLE_WIDTH*2-1:0]             CSR_DC_U,
  output [SAMPLE_WIDTH*2-1:0]             o_dc_u,
      
  //INTF_estimation      
  input  [SAMPLE_WIDTH*2-1:0]             CSR_INTF_CMP,
  output [SAMPLE_WIDTH*2-1:0]             o_intf_cmp,
      
  //phase_gen: AHB to RAM      
  input  [TWIDDLE_ADDR:0]                 i_phase_ram0_addra,
  input                                   i_phase_ram0_bwea,
  input                                   i_phase_ram0_ena,
  input  [TWIDDLE_WIDTH:0]                i_phase_ram0_dina,
  output [TWIDDLE_WIDTH:0]                o_phase_ram0_douta,
  input                                   i_phase_ram0_wena,
      
  input  [ENTRY_ADDR:0]                   i_phase_ram1_addra,
  input                                   i_phase_ram1_bwea,
  input                                   i_phase_ram1_ena,
  input  [ENTRY_WIDTH:0]                  i_phase_ram1_dina,
  output [ENTRY_WIDTH:0]                  o_phase_ram1_douta,
  input                                   i_phase_ram1_wena,
        
  input  [SAMPLE_WIDTH-1:0]               CSR_PHASE_W   ,
  input  [SAMPLE_WIDTH-1:0]               CSR_PHASE_COE ,
      
  //S1      
   output [L1_DATA_WIDTH-1:0]             o_m1_wr_data,            
   output [`L1_ADDR_WIDTH-1:0]            o_m1_wr_addr,
   output                                 o_m1_wr_en  ,
   output [`L1_STRB_WIDTH-1:0]            o_m1_wr_wea ,     
   input  [L1_DATA_WIDTH-1:0]             i_m0_rd_data,            
   output [`L1_ADDR_WIDTH-1:0]            o_m0_rd_addr,
   output                                 o_m0_rd_en

);


//********************  reg & wire  ********************//

wire [L1_DATA_WIDTH-1:0]  rd_data ;
reg                       rd_valid;
reg                       rd_last ;
wire [L1_DATA_WIDTH-1:0]  wr_data ;
reg                       wr_valid;


//********************  read_ram  ********************//
rsp_s1_prep_read_ram #(
  .DELAY_DATA_RSP_S1_PREP_CORE    (`DELAY_DATA_RSP_S1_PREP_CORE),         
  .READ_RAM_WIDTH       (L1_DATA_WIDTH),
  .SAMPLE_WIDTH         (SAMPLE_WIDTH  ),
  .RD_INTERVAL          (`INTERVAL     ),
  .ADD_ADDR             (`ADD_ADDR     )
)u_rsp_s1_prep_read_ram(
  .clk                 (clk),
  .rst_n               (rst_n),
  .CSR_BURST_LEN       (CSR_BURST_LEN),
  .CSR_EST_SMP_CNT     (CSR_EST_SMP_CNT),
  .CSR_EST_CHP_CNT     (CSR_EST_CHP_CNT),
  .CSR_EST_FRM_CNT     (CSR_EST_FRM_CNT),
  .CSR_RD_START_ADDR   (CSR_RD_START_ADDR),
  .i_start             (i_start),
  .i_m0_rd_data        (i_m0_rd_data),            
  .o_m0_rd_addr        (o_m0_rd_addr),
  .o_m0_rd_en          (o_m0_rd_en),
  .o_data              (rd_data ),
  .o_data_valid        (rd_valid),
  .o_data_last         (rd_last )
);


//********************  write_ram  ********************//
rsp_s1_prep_write_ram #(
  .DELAY_DATA_RSP_S1_PREP_CORE (`DELAY_DATA_ARRIVE_PREP_WR),
  .READ_RAM_WIDTH    (L1_DATA_WIDTH  ),
  .SAMPLE_WIDTH      (SAMPLE_WIDTH   ),
  .ADD_ADDR          (`ADD_ADDR      )
)u_rsp_s1_prep_write_ram(
  .clk                 (clk               ),
  .rst_n               (rst_n             ),

  .CSR_BURST_LEN       (CSR_BURST_LEN     ),
  .CSR_WR_START_ADDR   (CSR_WR_START_ADDR ),
  .CSR_EST_SMP_CNT     (CSR_EST_SMP_CNT   ),
  .CSR_EST_CHP_CNT     (CSR_EST_CHP_CNT   ),
  .CSR_EST_FRM_CNT     (CSR_EST_FRM_CNT   ),
  .i_data              (wr_data           ),
  .i_data_valid        (wr_valid          ),
  .i_data_last         (                  ),
  .o_m1_wr_data        (o_m1_wr_data      ),            
  .o_m1_wr_addr        (o_m1_wr_addr      ),
  .o_m1_wr_en          (o_m1_wr_en        ),
  .o_m1_wr_wea         (o_m1_wr_wea       ),
  .o_finish            (o_finish          )
);



//********************  top  ********************//
rsp_s1_prep_top #(
  .L1_DATA_WIDTH      (L1_DATA_WIDTH),
  .SAMPLE_WIDTH       (SAMPLE_WIDTH ),
  .SMP_CNT            (SMP_CNT      ),
  .CHP_CNT            (CHP_CNT      ),
  .FRM_CNT            (FRM_CNT      ),
  .TWIDDLE_ADDR       (TWIDDLE_ADDR ),
  .TWIDDLE_WIDTH      (TWIDDLE_WIDTH),
  .ENTRY_ADDR         (ENTRY_ADDR   ),
  .ENTRY_WIDTH        (ENTRY_WIDTH  ),
  .MODE_WIDTH         (`MODE_WIDTH  ),
  
  //DEBUG
  .DEBUG_PACKET_SELECT  (`DEBUG_PACKET_SELECT)


)
 u_rsp_s1_prep_top(
  .rst_n                    (rst_n                  ),
  .clk                      (clk                    ),
  .hrst_n                   (hrst_n                 ),
  .hclk                     (hclk                   ),
  .i_start                  (i_start                ),
  .i_sel_16_32              (CSR_SEL_DATA_FORMATTRT[1]),
  .i_is_real                (CSR_SEL_DATA_FORMATTRT[0]),
  .DC_DCEST_SMP_CNT         (CSR_EST_SMP_CNT     ),
  .DC_DCEST_CHP_CNT         (CSR_EST_CHP_CNT     ),
  .DC_DCEST_FRM_CNT         (CSR_EST_FRM_CNT     ),
  .DC_DCEST_SCALE           (CSR_DC_EST_SCALE       ),
  .DC_config_mode           (CSR_DC_CFG_MODE        ),
  .i_dc_u                   (CSR_DC_U),
  .o_dc_u                   (o_dc_u),
  .INTF_DCEST_SMP_CNT       (CSR_EST_SMP_CNT     ),
  .INTF_DCEST_CHP_CNT       (CSR_EST_CHP_CNT     ),
  .INTF_DCEST_FRM_CNT       (CSR_EST_FRM_CNT     ),
  .INTF_DCEST_SCALE         (CSR_INTF_EST_SCALE     ),
  .INTF_config_mode         (CSR_INTF_CFG_MODE      ),
  .i_intf_cmp               (CSR_INTF_CMP),
  .o_intf_cmp               (o_intf_cmp),
  .CSR_COMB_CFG_MODE        (CSR_COMB_CFG_MODE),
  
  .i_phase_w                (CSR_PHASE_W        ),
  .i_phase_entry_select     (CSR_PHASE_ENTRY_SEL),
  .i_phase_coe              (CSR_PHASE_COE      ),

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
