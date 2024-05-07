//-----------------------------------------------------------------------------
// File: rsp_s1_prep_top.v
// Author: Jade Yu
// Created by : Jade Yu
// Abstract: rsp_s1_prep_top
// Modification history:
// $Log$
//   Jade Yu 7/27/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------
`include "rsp_s1_prep_defines.vh"

`timescale 1ns / 1ps


module rsp_s1_prep_top #(
  parameter L1_DATA_WIDTH        = 128 ,
  parameter SAMPLE_WIDTH         = 32  ,
  parameter PREP_DATA_NUM        = 1024,
  parameter SMP_CNT              = 13  ,
  parameter CHP_CNT              =  9  ,
  parameter FRM_CNT              =  3  ,
  parameter TWIDDLE_ADDR         =  8  ,
  parameter TWIDDLE_WIDTH        =  64 ,
  parameter ENTRY_ADDR           =  6  ,
  parameter ENTRY_WIDTH          =  32 ,
  parameter MODE_WIDTH           =  4  ,

  //DEBUG
  parameter DEBUG_PACKET_SELECT    = 3
)
(
  input                                      rst_n,
  input                                      hrst_n,
  input                                      clk,             //500M
  input                                      hclk,            //100M
  input                                      i_sel_16_32,
  input                                      i_is_real,        //switch-- 1:real_cal  0:complex_cal
  input                                      i_start,
  input  [SMP_CNT-1:0]                       DC_DCEST_SMP_CNT  ,
  input  [CHP_CNT-1:0]                       DC_DCEST_CHP_CNT  ,
  input  [FRM_CNT-1:0]                       DC_DCEST_FRM_CNT  ,
  input  [SAMPLE_WIDTH/2:0]                  DC_DCEST_SCALE    ,
  input  [MODE_WIDTH-1:0]                    DC_config_mode    ,
  input  [SAMPLE_WIDTH*2-1:0]                i_dc_u            ,
  output [SAMPLE_WIDTH*2-1:0]                o_dc_u            ,

  input  [SMP_CNT-1:0]                       INTF_DCEST_SMP_CNT,
  input  [CHP_CNT-1:0]                       INTF_DCEST_CHP_CNT,
  input  [FRM_CNT-1:0]                       INTF_DCEST_FRM_CNT,
  input  [SAMPLE_WIDTH/2:0]                  INTF_DCEST_SCALE  ,
  input  [MODE_WIDTH-1:0]                    INTF_config_mode  ,
  input  [MODE_WIDTH-1:0]                    CSR_COMB_CFG_MODE ,
  input  [SAMPLE_WIDTH*2-1:0]                i_intf_cmp        ,
  output [SAMPLE_WIDTH*2-1:0]                o_intf_cmp        ,

  //phase_gen: AHB to RAM
  input  [TWIDDLE_WIDTH-1:0]                 i_phase_coe,
  input  [ENTRY_ADDR-1:0]                    i_phase_entry_select  ,
  input  [TWIDDLE_WIDTH-1:0]                 i_phase_w,
  input  [10:0]                              i_phase_ram0_addra,
  input                                      i_phase_ram0_bwea,
  input                                      i_phase_ram0_ena,
  input  [TWIDDLE_WIDTH-1:0]                 i_phase_ram0_dina,
  output [TWIDDLE_WIDTH-1:0]                 o_phase_ram0_douta,
  input                                      i_phase_ram0_wena,

  input  [ENTRY_ADDR-1:0]                    i_phase_ram1_addra,
  input                                      i_phase_ram1_bwea,
  input                                      i_phase_ram1_ena,
  input  [ENTRY_WIDTH-1:0]                   i_phase_ram1_dina,
  output [ENTRY_WIDTH-1:0]                   o_phase_ram1_douta,
  input                                      i_phase_ram1_wena,

  input  [L1_DATA_WIDTH-1:0]        i_x0,            //input complex or real 128bit
  input                             i_x0_valid,      //input i_x0_valid
  input                             i_x0_last,       //input i_x0_last
  output [L1_DATA_WIDTH-1:0]        o_y0,            //output complex or real
  output                            o_y0_valid       //output complex or real
);

//******************** Description   ********************//
//This module is chirp_processing_top

//********************  parameter  ********************//
// localparam TOP_X0_VALID       = 1+1;
// localparam TOP_X0_LAST        = 1+1;
// localparam TOP_I_DIFF_VALID   = 1+1;
// localparam TOP_BUFFER_VALID   = 2+1;
// localparam TOP_X0_DIFF_LAST   = 1+1;
// localparam DIFF_X0_LAST_DATA  = 1;
// localparam DIFF_X0_DIFF_VALID = 1;
// localparam DIFF_X0_LAST       = 2;
// localparam TOP_X0_DIFF_VALID  = 2;
// localparam ABS_CMP_X1_RVALID  = 1;
// localparam ABS_CMP_X1_CVALID  = 1;
// localparam TOP_BUFFER_RD_EN      = 5  ;

// localparam COMB_Y0_VALID         = 2  ;
// localparam COMB_S_LF_REAL_CMP    = 5+5;
// localparam COMB_S_HF_REAL_CMP    = 1+5;
// localparam COMB_S_LF_COMPLEX_CMP = 5+5;
// localparam COMB_S_HF_COMPLEX_CMP = 1+5;

//localparam MUL16_COMPLEX_VALID  = 7;
//localparam MUL16_REAL_VALID     = 1;
//localparam MUL32_COMPLEX_VALID  = 7;
//localparam MUL32_REAL_VALID     = 1;




//********************  reg & wire  ********************//
wire [SAMPLE_WIDTH/2-1:0] DC_u [`ROW_DATA_NUM-1:0];
wire [SAMPLE_WIDTH*2-1:0] INTF_esti;

reg                           x0_valid;
reg                           x0_last;
wire [SAMPLE_WIDTH/2-1:0]     x0_L_data [`ROW_DATA_NUM-1:0];
wire [SAMPLE_WIDTH/2:0]       x0_H_data [`ROW_DATA_NUM-1:0];
reg  [SAMPLE_WIDTH/2-1:0]     x0_data1 [`ROW_DATA_NUM-1:0];
reg  [SAMPLE_WIDTH/2:0]       x0_16_data [`ROW_DATA_NUM-1:0];
reg  [SAMPLE_WIDTH/2-1:0]     x_u_data [`ROW_DATA_NUM-1:0];
wire [0:0]                    o_L_carry[15:0];
wire [0:0]                    o_H_carry[15:0];

wire                          x0_diff_valid;
wire                          x0_diff_last;
wire [SAMPLE_WIDTH/2-1:0]     x0_diff_data [`ROW_DATA_NUM-1:0];
reg  [SAMPLE_WIDTH/2-1:0]     s_diff_data [`ROW_DATA_NUM-1:0];

wire [`ROW_DATA_NUM-1:0]                LF_real_cmp;
wire [`ROW_DATA_NUM/2-1:0]              LF_complex_cmp;
wire [`ROW_DATA_NUM/4-1:0]              LF_c64_cmp;
wire                          LF_rcmp_valid;
wire                          LF_complex_valid;
wire                          LF_c64_valid;

wire [`ROW_DATA_NUM-1:0]                HF_real_cmp;
wire [`ROW_DATA_NUM/2-1:0]              HF_complex_cmp;
wire [`ROW_DATA_NUM/4-1:0]              HF_c64_cmp;
wire                          HF_rcmp_valid;
wire                          HF_complex_valid;
wire                          HF_c64_valid;

reg [L1_DATA_WIDTH-1:0]       s_x0_data;
reg [L1_DATA_WIDTH-1:0]       x0_delay_data;
wire                          buffer_empty;
wire                          buffer_full;
reg                           buffer_rd_en;
reg                           s_buffer_rd_en;
reg [L1_DATA_WIDTH-1:0]       s_x0_delay_data;

reg [L1_DATA_WIDTH-1:0]      comb_data;
reg                           comb_valid;
reg                           s_comb_valid;

reg  [SAMPLE_WIDTH-1:0]   s_comb_data [0:`ROW_DATA_NUM/2-1];
reg  [TWIDDLE_WIDTH-1:0]      o_w [3:0];
reg  [SAMPLE_WIDTH-1:0]   y0_data [0:`ROW_DATA_NUM/2-1];
reg  [SAMPLE_WIDTH*2-1:0]   y0_64_data [0:`ROW_DATA_NUM/4-1];
wire        [0:0]             mul_valid[3:0];
wire        [0:0]             mul64_valid[1:0];
wire                          buffer_valid;

//debug
logic [SAMPLE_WIDTH-1:0]      debug_abs_32 [0:`ROW_DATA_NUM/2-1];//32
logic [SAMPLE_WIDTH/2-2:0]    debug_abs_16 [0:`ROW_DATA_NUM-1];
logic                         LF_x1_rabs_rdy;
logic                         LF_x1_cabs_rdy;
logic                         LF_abs_c_32_rdy;
logic [SAMPLE_WIDTH/2-1:0]    LF_x1_rabs_data [`ROW_DATA_NUM-1:0];
logic [SAMPLE_WIDTH/2-1:0]    LF_x1_cabs_data [`ROW_DATA_NUM/2-1:0];
logic [SAMPLE_WIDTH-1:0]      LF_abs_c_32_data [`ROW_DATA_NUM/4-1:0];
logic                         LF_abd_valid;
logic [SAMPLE_WIDTH/2-1:0]  LF_a  [3:0];
logic [SAMPLE_WIDTH/2-1:0]  LF_b  [3:0];
logic [SAMPLE_WIDTH/2-1:0]  LF_c  [3:0];
logic [SAMPLE_WIDTH/2-1:0]  LF_d  [3:0];
logic                         LF_c_valid ;  
logic                         HF_x1_rabs_rdy;
logic                         HF_x1_cabs_rdy;
logic                         HF_abs_c_32_rdy;
logic [SAMPLE_WIDTH/2-1:0]    HF_x1_rabs_data [`ROW_DATA_NUM-1:0];
logic [SAMPLE_WIDTH/2-1:0]    HF_x1_cabs_data [`ROW_DATA_NUM/2-1:0];
logic [SAMPLE_WIDTH-1:0]      HF_abs_c_32_data [`ROW_DATA_NUM/4-1:0];
logic                         HF_abd_valid;
logic [SAMPLE_WIDTH/2-1:0]    HF_a  [3:0];
logic [SAMPLE_WIDTH/2-1:0]    HF_b  [3:0];
logic [SAMPLE_WIDTH/2-1:0]    HF_c  [3:0];
logic [SAMPLE_WIDTH/2-1:0]    HF_d  [3:0];
logic                         HF_c_valid ;  
logic                         phase_gen_valid;

//********************  DC estimation  ********************//0
rsp_s1_prep_estimation #(
  .READ_RAM_WIDTH  (L1_DATA_WIDTH),
  .DATA_WIDTH      (SAMPLE_WIDTH/2)
) u_rsp_s1_prep_DC_estimation(
  .rst_n           (rst_n    ),
  .clk             (clk      ),
  .DCEST_SMP_CNT   (DC_DCEST_SMP_CNT),
  .DCEST_CHP_CNT   (DC_DCEST_CHP_CNT),
  .DCEST_FRM_CNT   (DC_DCEST_FRM_CNT),
  .DCEST_SCALE     (DC_DCEST_SCALE  ),
  .config_mode     (DC_config_mode  ),
  .i_sel_16_32     (i_sel_16_32     ),
  .i_is_real       (i_is_real       ),
  .i_shift         (),
  .i_x0_data       (i_x0),
  .i_x0_valid      (i_x0_valid),
  .i_x0_last       (i_x0_last  ),
  .o_y0            (o_dc_u[31:0]),
  .o_y0_valid      ()
);
assign DC_u[0] = i_sel_16_32 ? (~i_dc_u[15:0]+1 ) : i_dc_u[15:0 ]  ;
assign DC_u[1] = i_sel_16_32 ? (~i_dc_u[31:16]  ) : i_dc_u[31:16]  ;
assign DC_u[2] = i_sel_16_32 ? (~i_dc_u[47:32]+1) : i_dc_u[15:0 ]  ;
assign DC_u[3] = i_sel_16_32 ? (~i_dc_u[63:48]  ) : i_dc_u[31:16]  ;
assign DC_u[4] = i_sel_16_32 ? (~i_dc_u[15:0]+1 ) : i_dc_u[15:0 ]  ;
assign DC_u[5] = i_sel_16_32 ? (~i_dc_u[31:16]  ) : i_dc_u[31:16]  ;
assign DC_u[6] = i_sel_16_32 ? (~i_dc_u[47:32]+1) : i_dc_u[15:0 ]  ;
assign DC_u[7] = i_sel_16_32 ? (~i_dc_u[63:48]  ) : i_dc_u[31:16]  ;
//********************  INTF estimation  ********************//0
rsp_s1_prep_estimation #(
  .READ_RAM_WIDTH  (L1_DATA_WIDTH),
  .DATA_WIDTH      (SAMPLE_WIDTH)
) u_LF_INTF_estimation(
  .rst_n           (rst_n    ),
  .clk             (clk      ),
  .DCEST_SMP_CNT   (INTF_DCEST_SMP_CNT),
  .DCEST_CHP_CNT   (INTF_DCEST_CHP_CNT),
  .DCEST_FRM_CNT   (INTF_DCEST_FRM_CNT),
  .DCEST_SCALE     (INTF_DCEST_SCALE  ),
  .config_mode     (INTF_config_mode  ),
  .i_sel_16_32     (i_sel_16_32     ),
  .i_is_real       (i_is_real       ),
  .i_shift         (),
  .i_x0_data       (i_x0),
  .i_x0_valid      (i_x0_valid ),
  .i_x0_last       (i_x0_last  ),
  .o_y0            (o_intf_cmp[31:0]),
  .o_y0_valid      ()
);

rsp_s1_prep_estimation #(
  .READ_RAM_WIDTH  (L1_DATA_WIDTH),
  .DATA_WIDTH      (SAMPLE_WIDTH)
) u_HF_INTF_estimation(
  .rst_n           (rst_n    ),
  .clk             (clk      ),
  .DCEST_SMP_CNT   (INTF_DCEST_SMP_CNT),
  .DCEST_CHP_CNT   (INTF_DCEST_CHP_CNT),
  .DCEST_FRM_CNT   (INTF_DCEST_FRM_CNT),
  .DCEST_SCALE     (INTF_DCEST_SCALE  ),
  .config_mode     (INTF_config_mode  ),
  .i_sel_16_32     (i_sel_16_32     ),
  .i_is_real       (i_is_real       ),
  .i_shift         (),
  .i_x0_data       (i_x0),
  .i_x0_valid      (i_x0_valid ),
  .i_x0_last       (i_x0_last  ),
  .o_y0            (),
  .o_y0_valid      ()
);

assign INTF_esti = i_intf_cmp;
// assign INTF_LF_esti = i_intf_LF_cmp;
// assign INTF_HF_esti = i_intf_HF_cmp;

//********************  (x-u)  ********************//0
generate
  for (genvar i=0; i<`ROW_DATA_NUM; i=i+2) begin
    rsp_s1_prep_add_u #(
      .DATA_WIDTH (SAMPLE_WIDTH/2)
    ) u_add_u_L16_0(
      .num1      (i_x0[16*i+15:16*i]),
      .num2      (DC_u[i]),
      .out_num   (x0_L_data[i]),
      .i_c       (1'b0),
      .o_c       (o_L_carry[i])
    );
    rsp_s1_prep_add_u #(
      .DATA_WIDTH (SAMPLE_WIDTH/2+1)
    ) u_add_u_H16_0(
      .num1      ({i_x0[16*(i+1)+15],i_x0[16*(i+1)+15:16*(i+1)]}),
      .num2      ({DC_u[i+1][15],DC_u[i+1]}), //don't need add 1
      .out_num   (x0_H_data[i+1]),
      .i_c       (o_L_carry[i]),
      .o_c       (o_H_carry[i])
    );
  end
endgenerate

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    for (integer i = 0;i < `ROW_DATA_NUM ;i = i + 1) begin
      x0_data1[i] <= {(SAMPLE_WIDTH/2){1'b0}};
      x0_16_data[i] <= {(SAMPLE_WIDTH/2+1){1'b0}};
    end
  end
  else if(i_sel_16_32 == 1'b1) begin
    for (integer i = 0;i < `ROW_DATA_NUM ;i = i + 2) begin
      if(~x0_H_data[i+1][SAMPLE_WIDTH/2] && (|{x0_H_data[i+1][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1]})) begin
        x0_data1[i+1] <= {(SAMPLE_WIDTH/2-1){1'b1}};
        x0_data1[i]   <= {(SAMPLE_WIDTH/2){1'b1}};
      end
      else if(x0_H_data[i+1][SAMPLE_WIDTH/2] && ~(&{x0_H_data[i+1][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1]})) begin
        x0_data1[i+1] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
        x0_data1[i]   <= {{(SAMPLE_WIDTH/2-1){1'b0}},{1'b1}};
      end
      else begin
        x0_data1[i+1] <= x0_H_data[i+1][SAMPLE_WIDTH/2-1:0];
        x0_data1[i]   <= x0_L_data[i][SAMPLE_WIDTH/2-1:0];
      end
    end
  end
  else begin
    for (integer i = 0;i < `ROW_DATA_NUM ;i = i + 1) begin
      x0_16_data[i] <= {i_x0[i*16+15],i_x0[i*16+15-:16]} - {DC_u[i][SAMPLE_WIDTH/2-1],DC_u[i]};
    end
    // x0_16_data[0] <= {i_x0[0*16+15],i_x0[0*16+15:0*16]} - {DC_u[0][SAMPLE_WIDTH/2],DC_u[0]};
    // x0_16_data[1] <= {i_x0[1*16+15],i_x0[1*16+15:1*16]} - {DC_u[1][SAMPLE_WIDTH/2],DC_u[1]};
    // x0_16_data[2] <= {i_x0[2*16+15],i_x0[2*16+15:2*16]} - {DC_u[2][SAMPLE_WIDTH/2],DC_u[2]};
    // x0_16_data[3] <= {i_x0[3*16+15],i_x0[3*16+15:3*16]} - {DC_u[3][SAMPLE_WIDTH/2],DC_u[3]};
    // x0_16_data[4] <= {i_x0[4*16+15],i_x0[4*16+15:4*16]} - {DC_u[4][SAMPLE_WIDTH/2],DC_u[4]};
    // x0_16_data[5] <= {i_x0[5*16+15],i_x0[5*16+15:5*16]} - {DC_u[5][SAMPLE_WIDTH/2],DC_u[5]};
    // x0_16_data[6] <= {i_x0[6*16+15],i_x0[6*16+15:6*16]} - {DC_u[6][SAMPLE_WIDTH/2],DC_u[6]};
    // x0_16_data[7] <= {i_x0[7*16+15],i_x0[7*16+15:7*16]} - {DC_u[7][SAMPLE_WIDTH/2],DC_u[7]};
  end
end

// logic [16:0] test_data;
// assign test_data = {i_x0[2*16+15],i_x0[2*16+15:2*16]};

generate
  for (genvar i=0; i<`ROW_DATA_NUM; i=i+1) begin
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        x_u_data[i] <= {SAMPLE_WIDTH/2{1'b0}};
      end
      else if(i_sel_16_32==1'b1 ) begin //&& i<`ROW_DATA_NUM/2
        // for (genvar j=0 ;j<`ROW_DATA_NUM; j=j+2) begin
        //   if(~x0_data1[j+1][SAMPLE_WIDTH/2] && (|x0_data1[j+1][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
        //     x_u_data[j] <= {(SAMPLE_WIDTH/2){1'b1}};
        //     x_u_data[j+1] <= {(SAMPLE_WIDTH/2-1){1'b1}};
        //   end
        //   else if(x0_data1[j+1][SAMPLE_WIDTH] && ~(&x0_data1[j+1][SAMPLE_WIDTH:SAMPLE_WIDTH-1])) begin
        //     x_u_data[j] <= {{(SAMPLE_WIDTH/2-1){1'b0}},{1'b1}};
        //     x_u_data[j+1] <= {{1'b1},{(SAMPLE_WIDTH/2-1){1'b0}}};
        //   end
        //   else begin
        //     x_u_data[j] <= x0_data1[j][15:0];
        //     x_u_data[j+1] <= x0_data1[j+1][31:16];
        //   end
        // end
        x_u_data[i] <= x0_data1[i];
      end
      else begin
        if(~x0_16_data[i][SAMPLE_WIDTH/2] && (|x0_16_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
          x_u_data[i] <= {(SAMPLE_WIDTH/2-1){1'b1}};
        end
        else if(x0_16_data[i][SAMPLE_WIDTH/2] && ~(&x0_16_data[i][SAMPLE_WIDTH/2:SAMPLE_WIDTH/2-1])) begin
          x_u_data[i] <= {{1'b1},{(SAMPLE_WIDTH/2-2){1'b0}},{1'b1}};
        end
        else begin
          x_u_data[i] <= {x0_16_data[i][SAMPLE_WIDTH/2],x0_16_data[i][SAMPLE_WIDTH/2-2:0]};;
          // x_u_data[i] <= {x0_16_data[i][SAMPLE_WIDTH/2-1:0]};;
        end
        // x_u_data[i] <= x0_16_data[i];
      end
    end
  end
endgenerate

//********************  delay  ********************//0
delay #(`DELAY_TOP_X0_VALID) delay_i_x0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(x0_valid));
delay #(`DELAY_TOP_I_DIFF_VALID) delay_i_diff_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(i_diff_valid));
delay #(`DELAY_TOP_BUFFER_VALID) delay_buffer_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(buffer_valid));
delay #(`DELAY_TOP_X0_LAST) delay_i_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));
delay #(`DELAY_TOP_X0_DIFF_LAST) delay_diff_HF_clast(.clk(clk), .rst_n(rst_n), .din(x0_last), .dout(x0_diff_last));
delay #(`DELAY_TOP_BUFFER_RD_EN) delay_buffer_rd_en(.clk(clk), .rst_n(rst_n), .din(buffer_rd_en), .dout(s_buffer_rd_en));



//********************  abs_cmp(LF)  ********************//1
rsp_s1_prep_abs_cmp#(
  .READ_RAM_WIDTH     (L1_DATA_WIDTH),
  .SAMPLE_WIDTH       (SAMPLE_WIDTH  ),
  .DATA_WIDTH         (SAMPLE_WIDTH/2    ),
  .NUM                (`ROW_DATA_NUM  )
)
u_LF_abs(
  .rst_n             (rst_n           ),
  .clk               (clk             ),
  .i_sel_16_32       (i_sel_16_32     ),
  .i_switch          (i_is_real       ),
  .i_x0_valid        (x0_valid        ),
  .i_x0_last         (),
  .x0_data           (x_u_data        ),
  .INTF_esti         (INTF_esti       ),
  .o_real_cmp        (LF_real_cmp     ),
  .o_complex_cmp     (LF_complex_cmp  ),
  .o_c64_cmp         (LF_c64_cmp      ),
  .o_rcmp_valid      (LF_rcmp_valid   ),
  .o_ccmp_valid      (LF_complex_valid),
  .o_c64_valid       (LF_c64_valid    ),

  //debug
  .debug_abs_32      (debug_abs_32),
  .debug_abs_16      (),
  .x1_rabs_rdy       (LF_x1_rabs_rdy  ),
  .x1_cabs_rdy       (LF_x1_cabs_rdy  ),
  .abs_c_32_rdy      (LF_abs_c_32_rdy ),
  .x1_rabs_data      (LF_x1_rabs_data ),
  .x1_cabs_data      (LF_x1_cabs_data ),
  .abs_c_32_data     (LF_abs_c_32_data),

  .abd_valid         (LF_abd_valid), 
  .a                 (LF_a        ), 
  .b                 (LF_b        ), 
  .c                 (LF_c        ), 
  .d                 (LF_d        ), 
  .c_valid           (LF_c_valid  )    
);

//********************  diff_abs_cmp(HF)  ********************//1
rsp_s1_prep_diff #(
  .READ_RAM_WIDTH      (L1_DATA_WIDTH),
  .SAMPLE_WIDTH        (SAMPLE_WIDTH  ),
  .DATA_NUM            (`PREP_DATA_NUM),
  .BURST_LEN           (`PREP_BURST_LEN)
)
u_diff(
  .rst_n      (rst_n           ),
  .clk        (clk             ),
  .i_sel_16_32(i_sel_16_32     ),
  .i_switch   (i_is_real       ),
  .i_x0_data  (x_u_data        ),
  .i_x0_valid (i_diff_valid    ),
  .i_x0_last  (x0_last         ),
  .o_y0       (x0_diff_data    ),
  .o_y0_valid (x0_diff_valid   )
);

rsp_s1_prep_abs_cmp#(
  .READ_RAM_WIDTH     (L1_DATA_WIDTH),
  .SAMPLE_WIDTH       (SAMPLE_WIDTH  ),
  .DATA_WIDTH         (SAMPLE_WIDTH/2    ),
  .NUM                (`ROW_DATA_NUM  )
)
u_HF_abs(
  .rst_n             (rst_n           ),
  .clk               (clk             ),
  .i_sel_16_32       (i_sel_16_32     ),
  .i_switch          (i_is_real       ),
  .i_x0_valid        (x0_diff_valid   ),
  .i_x0_last         (x0_diff_last    ),
  .x0_data           (x0_diff_data    ),
  .INTF_esti         (INTF_esti       ),
  .o_real_cmp        (HF_real_cmp     ),
  .o_complex_cmp     (HF_complex_cmp  ),
  .o_c64_cmp         (HF_c64_cmp      ),
  .o_rcmp_valid      (HF_rcmp_valid   ),
  .o_ccmp_valid      (HF_complex_valid),
  .o_c64_valid       (HF_c64_valid    ),

  //debug
  .debug_abs_32      (),
  .debug_abs_16      (),
  .x1_rabs_rdy       (HF_x1_rabs_rdy ),
  .x1_cabs_rdy       (HF_x1_cabs_rdy ),
  .abs_c_32_rdy      (HF_abs_c_32_rdy ),
  .x1_rabs_data      (HF_x1_rabs_data),
  .x1_cabs_data      (HF_x1_cabs_data),
  .abs_c_32_data     (HF_abs_c_32_data),

  .abd_valid         (HF_abd_valid), 
  .a                 (HF_a        ), 
  .b                 (HF_b        ), 
  .c                 (HF_c        ), 
  .d                 (HF_d        ), 
  .c_valid           (HF_c_valid  )  
);

//********************  buffer  ********************

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    s_x0_data <= {L1_DATA_WIDTH{1'b0}};
  end
  else begin
    s_x0_data <= {x_u_data[7],x_u_data[6],x_u_data[5],x_u_data[4],x_u_data[3],x_u_data[2],x_u_data[1],x_u_data[0]};
  end
end

rsp_s1_prep_fifo #(
  .WIDTH       (128)
  // .DEPTH_FULL  (2)
) u_fifo(
  .clk     (clk),
  .rst_n   (rst_n),
  .push    (buffer_valid),
  .pop     (s_buffer_rd_en),
  .din     (s_x0_data),
  .dout    (s_x0_delay_data),
  .empty   (buffer_empty),
  .full    (buffer_full),
  .afull   ()
);


always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    x0_delay_data <= {L1_DATA_WIDTH{1'b0}};
  end
  else begin
    x0_delay_data <= s_x0_delay_data;
  end
end

//********************  comb  ********************
rsp_s1_prep_combination #(
  .READ_RAM_WIDTH         (L1_DATA_WIDTH),
  .NUM                    (`ROW_DATA_NUM),
  .DATA_WIDTH             (SAMPLE_WIDTH/2)
) u_combination(
  .clk             (clk              ),
  .rst_n           (rst_n            ),
  .i_sel_16_32     (i_sel_16_32      ),
  .i_switch        (i_is_real        ),
  .i_config_mode   (CSR_COMB_CFG_MODE),
  .LF_real_cmp     (LF_real_cmp      ),
  .LF_complex_cmp  (LF_complex_cmp   ),
  .LF_rcmp_valid   (LF_rcmp_valid    ),
  .LF_complex_valid(LF_complex_valid ),
  .LF_c64_cmp      (LF_c64_cmp       ),
  .LF_c64_valid    (LF_c64_valid     ),
  .HF_real_cmp     (HF_real_cmp      ),
  .HF_complex_cmp  (HF_complex_cmp   ),
  .HF_rcmp_valid   (HF_rcmp_valid    ),
  .HF_complex_valid(HF_complex_valid ),
  .HF_c64_cmp      (HF_c64_cmp       ),
  .HF_c64_valid    (HF_c64_valid     ),
  .i_x0            (x0_delay_data    ),
  .i_x0_valid      (s_buffer_rd_en   ),
  .o_y0            (comb_data        ),
  .o_y0_valid      (comb_valid       )
);

//********************  multiplier(*w)  ********************
delay #(20) delay_phase_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(phase_last));

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    buffer_rd_en <= 1'b0;
  end
  else begin
    buffer_rd_en <= (i_is_real == 1'b1) ? HF_rcmp_valid : HF_complex_valid;
  end
end

rsp_s1_prep_phase_generation #(
  .RAM_DELAY          (2),
  .RAM0_ADDR_WIDTH    (11),
  .RAM1_ADDR_WIDTH    (6),
  .RAM_DATA_WIDTH     (64),
  .TWIDDLE_WIDTH      (64),
  .DATA_NUM           (`PREP_DATA_NUM)
) u_rsp_s1_prep_phase_generation(
  .rst_n                      (rst_n),
  .hrst_n                     (),
  .clk                        (clk),
  .hclk                       (),
  .i_start                    (i_start),
  .i_data_valid               (buffer_rd_en),
  .i_data_last                (phase_last),
  .i_sel_16_32                (i_sel_16_32),
  .i_phase_w                  (i_phase_w),
  .i_phase_coe                (i_phase_coe),
  .i_phase_entry_select       (i_phase_entry_select),
  .i_phase_ram0_addra         (i_phase_ram0_addra  ),
  .i_phase_ram0_bwea          (i_phase_ram0_bwea   ),
  .i_phase_ram0_ena           (i_phase_ram0_ena    ),
  .i_phase_ram0_dina          (i_phase_ram0_dina   ),
  .o_phase_ram0_douta         (o_phase_ram0_douta  ),
  .i_phase_ram0_wena          (i_phase_ram0_wena   ),
  .i_phase_ram1_addra         (i_phase_ram1_addra  ),
  .i_phase_ram1_bwea          (i_phase_ram1_bwea   ),
  .i_phase_ram1_ena           (i_phase_ram1_ena    ),
  .i_phase_ram1_dina          (i_phase_ram1_dina   ),
  .o_phase_ram1_douta         (o_phase_ram1_douta  ),
  .i_phase_ram1_wena          (i_phase_ram1_wena   ),
  .o_w                        (o_w                 ),

  //debug
  .debug_o_data_valid         (phase_gen_valid)
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    s_comb_data[0] <= {SAMPLE_WIDTH{1'b0}};
    s_comb_data[1] <= {SAMPLE_WIDTH{1'b0}};
    s_comb_data[2] <= {SAMPLE_WIDTH{1'b0}};
    s_comb_data[3] <= {SAMPLE_WIDTH{1'b0}};
    s_comb_valid   <= 1'b0;
  end
  else begin
    s_comb_data[0] <= comb_data[31:0];
    s_comb_data[1] <= comb_data[63:32];
    s_comb_data[2] <= comb_data[95:64];
    s_comb_data[3] <= comb_data[127:96];
    s_comb_valid   <= comb_valid;
  end
end

genvar i;
generate
  for (i=0; i<4; i=i+1) begin
    rsp_s1_prep_multiplier0 #(
      .TWIDDLE_WIDTH    (48),
      .SAMPLE_WIDTH     (SAMPLE_WIDTH),
      .NUM              (`ROW_DATA_NUM),
      .DELAY_MUL_COMPLEX_VALID(`DELAY_MUL16_COMPLEX_VALID),
      .DELAY_MUL_REAL_VALID   (`DELAY_MUL16_REAL_VALID)
    )
    multiplier0(
      .rst_n      (rst_n       ),
      .clk        (clk         ),
      .i_sel_16_32(            ),
      .i_switch   (i_is_real   ),
      .i_x0_data  (s_comb_data[i]),
      // .i_w        ({o_w[i][56],o_w[i][55:32],o_w[i][24],o_w[i][23:0]}),
      .i_w        ({o_w[i][55:32],o_w[i][23:0]}),
      .i_x0_valid (s_comb_valid),
      .o_y0       (y0_data[i]  ),
      .o_y0_valid (mul_valid[i])
    );
  end
endgenerate

genvar k;
generate
  for (k=0; k<4; k=k+2) begin
    rsp_s1_prep_multiplier0 #(
      .TWIDDLE_WIDTH    (48),
      .SAMPLE_WIDTH     (SAMPLE_WIDTH*2),
      .NUM              (`ROW_DATA_NUM),
      .DELAY_MUL_COMPLEX_VALID(`DELAY_MUL32_COMPLEX_VALID),
      .DELAY_MUL_REAL_VALID   (`DELAY_MUL32_REAL_VALID   )
    )
    multiplier1(
      .rst_n      (rst_n       ),
      .clk        (clk         ),
      .i_sel_16_32(            ),
      .i_switch   (i_is_real   ),
      .i_x0_data  ({s_comb_data[k+1],s_comb_data[k]}),
      // .i_w        ({o_w[k][56],o_w[k][55:32],o_w[k][24],o_w[k][23:0]}),
      .i_w        ({o_w[k][55:32],o_w[k][23:0]}),
      .i_x0_valid (s_comb_valid),
      .o_y0       (y0_64_data[k/2]),
      .o_y0_valid (mul64_valid[k/2])
    );
  end
endgenerate


assign o_y0 = (i_sel_16_32==1'b1) ? {y0_64_data[1],y0_64_data[0]} : {y0_data[3],y0_data[2],y0_data[1],y0_data[0]};
assign o_y0_valid = (i_sel_16_32==1'b1) ? mul64_valid[0] : mul_valid[0];






//******************** debug ********************//
logic [39-15:0] debug_esti_data;
logic           debug_esti_valid;
logic [L1_DATA_WIDTH-1:0]  debug_LF_x1_cabs_data;
logic [L1_DATA_WIDTH-1:0]  debug_HF_x1_cabs_data;
logic [L1_DATA_WIDTH-1:0]  debug_diff_data;
logic [L1_DATA_WIDTH-1:0]  debug_mul_c_data;
logic                      debug_y0_valid;
logic                      debug_x0_valid;

logic [`ROW_DATA_NUM-1:0]   debug_LF_cmp  ;
logic [`ROW_DATA_NUM-1:0]   s_debug_LF_cmp  ;
logic             debug_LF_valid;
logic [`ROW_DATA_NUM-1:0]   debug_HF_cmp  ;
logic [`ROW_DATA_NUM-1:0]   s_debug_HF_cmp  ;
logic             debug_HF_valid;

logic             debug_LF_abd_valid;
logic [L1_DATA_WIDTH-1:0]  debug_LF_a;
logic [L1_DATA_WIDTH-1:0]  debug_LF_b;
logic [L1_DATA_WIDTH-1:0]  debug_LF_c;
logic [L1_DATA_WIDTH-1:0]  debug_LF_d;
logic             debug_LF_c_valid;  

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    debug_LF_x1_cabs_data <= 'd0;
    debug_HF_x1_cabs_data <= 'd0;
    debug_diff_data       <= 'd0;
    debug_x0_valid        <= 'd0;
    debug_LF_a            <= 'd0;
    debug_LF_b            <= 'd0;
    debug_LF_c            <= 'd0;
    debug_LF_d            <= 'd0;
  end
  else begin
    debug_LF_x1_cabs_data <= i_is_real ? {LF_x1_rabs_data[7],LF_x1_rabs_data[6],LF_x1_rabs_data[5],LF_x1_rabs_data[4],LF_x1_rabs_data[3],LF_x1_rabs_data[2],LF_x1_rabs_data[1],LF_x1_rabs_data[0]} : {16'd0,LF_x1_cabs_data[3],16'd0,LF_x1_cabs_data[2],16'd0,LF_x1_cabs_data[1],16'd0,LF_x1_cabs_data[0]};
    debug_HF_x1_cabs_data <= i_is_real ? {HF_x1_rabs_data[7],HF_x1_rabs_data[6],HF_x1_rabs_data[5],HF_x1_rabs_data[4],HF_x1_rabs_data[3],HF_x1_rabs_data[2],HF_x1_rabs_data[1],HF_x1_rabs_data[0]} : {16'd0,HF_x1_cabs_data[3],16'd0,HF_x1_cabs_data[2],16'd0,HF_x1_cabs_data[1],16'd0,HF_x1_cabs_data[0]};
    debug_diff_data <= {x0_diff_data[7],x0_diff_data[6],x0_diff_data[5],x0_diff_data[4],x0_diff_data[3],x0_diff_data[2],x0_diff_data[1],x0_diff_data[0]};
    debug_x0_valid <= x0_valid;
    debug_LF_a <= {16'd0,LF_a[3],16'd0,LF_a[2],16'd0,LF_a[1],16'd0,LF_a[0]};
    debug_LF_b <= {16'd0,LF_b[3],16'd0,LF_b[2],16'd0,LF_b[1],16'd0,LF_b[0]};
    debug_LF_c <= {16'd0,LF_c[3],16'd0,LF_c[2],16'd0,LF_c[1],16'd0,LF_c[0]};
    debug_LF_d <= {16'd0,LF_d[3],16'd0,LF_d[2],16'd0,LF_d[1],16'd0,LF_d[0]};
  end
end

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    debug_LF_cmp    <= 'd0;
    debug_LF_valid  <= 'd0;
    debug_HF_cmp    <= 'd0;
    debug_HF_valid  <= 'd0;
  end
  else if(i_is_real == 1'b1) begin
    debug_LF_cmp    <= LF_real_cmp;
    s_debug_LF_cmp    <= debug_LF_cmp;
    debug_LF_valid  <= LF_rcmp_valid;
    debug_HF_cmp    <= HF_real_cmp;
    s_debug_HF_cmp    <= debug_HF_cmp;
    debug_HF_valid  <= HF_rcmp_valid;
  end
  else begin
    debug_LF_cmp    <= LF_complex_cmp;
    s_debug_LF_cmp    <= debug_LF_cmp;
    debug_LF_valid  <= LF_complex_valid;
    debug_HF_cmp    <= HF_complex_cmp;
    s_debug_HF_cmp    <= debug_HF_cmp;
    debug_HF_valid  <= HF_complex_valid;
  end
end


`ifdef debug_sel_16_32
    save_file_tb #(
      .DELAY_VALID_NUM (0),
      .DATA_WIDTH      (L1_DATA_WIDTH),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/X-u.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_X_u_data(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (x0_valid),
      .data     ({x_u_data[7],x_u_data[6],x_u_data[5],x_u_data[4],x_u_data[3],x_u_data[2],x_u_data[1],x_u_data[0]})
    );
   
`else
    save_file_tb #(
      .DELAY_VALID_NUM (0), 
      .DATA_WIDTH      (L1_DATA_WIDTH),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/X-u.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_X_u_data(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (x0_valid),
      .data     ({x_u_data[7],x_u_data[6],x_u_data[5],x_u_data[4],x_u_data[3],x_u_data[2],x_u_data[1],x_u_data[0]})
    );
`endif

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (25),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/estimation_data.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (DEBUG_PACKET_SELECT)
) u_estimation_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (debug_esti_valid),
  .data     (debug_esti_data)
);

`ifdef debug_sel_16_32
    save_file_tb #(
      .DELAY_VALID_NUM (0), 
      .DATA_WIDTH      (L1_DATA_WIDTH),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/ABS1.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_save_file_lfc32_data(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (LF_abs_c_32_rdy),
      .data     ({32'b0,LF_abs_c_32_data[1],32'b0,LF_abs_c_32_data[0]})
    );

    save_file_tb #(
      .DELAY_VALID_NUM (0), 
      .DATA_WIDTH      (L1_DATA_WIDTH),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/ABS2.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_save_file_hfc32_data(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (HF_abs_c_32_rdy),
      .data     ({32'b0,HF_abs_c_32_data[1],32'b0,HF_abs_c_32_data[0]})
    );

    save_file_tb #(
      .DELAY_VALID_NUM (0), 
      .DATA_WIDTH      (8),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/cmp_array1_square.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_cmp_array3(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (LF_c64_valid),
      .data     ({6'b0,LF_c64_cmp})
    );
    save_file_tb #(
      .DELAY_VALID_NUM (0), 
      .DATA_WIDTH      (8),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/cmp_array2_square.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_cmp_array4(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (HF_c64_valid),
      .data     ({6'b0,HF_c64_cmp})
    );
`else
    save_file_tb #(
      .DELAY_VALID_NUM (1), 
      .DATA_WIDTH      (L1_DATA_WIDTH),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/ABS1.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_save_file_lfcabs_data(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (LF_x1_cabs_rdy),
      .data     (debug_LF_x1_cabs_data)
    );

    save_file_tb #(
      .DELAY_VALID_NUM (0), 
      .DATA_WIDTH      (8),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/cmp_array1_square.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_cmp_array1(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (debug_LF_valid),
      .data     (s_debug_LF_cmp)
    );

    save_file_tb #(
      .DELAY_VALID_NUM (1), 
      .DATA_WIDTH      (L1_DATA_WIDTH),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/ABS2.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_save_file_hfcabs_data(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (HF_x1_cabs_rdy),
      .data     (debug_HF_x1_cabs_data)
    );

    save_file_tb #(
      .DELAY_VALID_NUM (1), 
      .DATA_WIDTH      (8),
      .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/cmp_array2_square.txt"),
      .cnt_data        (`PREP_DATA_NUM-1),
      .packet_select   (DEBUG_PACKET_SELECT)
    ) u_cmp_array2(
      .rst_n    (rst_n),
      .clk      (clk),
      .valid    (debug_HF_valid),
      .data     (s_debug_HF_cmp)
    );
`endif

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (L1_DATA_WIDTH),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/X_diff.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (DEBUG_PACKET_SELECT)
) u_diff_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (x0_diff_valid),
  .data     (debug_diff_data)
);

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    debug_mul_c_data <= 'd0;
  end
  else begin
    debug_mul_c_data <= o_y0;
  end
end

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (L1_DATA_WIDTH),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/X_comp.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (DEBUG_PACKET_SELECT)
) u_comb_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (comb_valid),
  .data     (comb_data)
);

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/twiddle_1024x64_0.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (DEBUG_PACKET_SELECT)
) u_phase_gen0(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[0])
);
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/twiddle_1024x64_1.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (DEBUG_PACKET_SELECT)
) u_phase_gen1(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[1])
);
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/twiddle_1024x64_2.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (DEBUG_PACKET_SELECT)
) u_phase_gen2(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[2])
);
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("/home/users/yuyushan/work/rsp_s1_prep/txt_file1/twiddle_1024x64_3.txt"),
  .cnt_data        (`PREP_DATA_NUM-1),
  .packet_select   (DEBUG_PACKET_SELECT)
) u_phase_gen3(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[3])
);

// genvar j;
// generate
//   for (j=0; j<`ROW_DATA_NUM; j=j+1) begin
//     always @(posedge clk or negedge rst_n) begin
//       if(!rst_n) begin
//         x_u_data[j] <= {DATA_WIDTH{1'b0}};
//       end
//       else begin
//         x_u_data[j] <= i_x0[j*16+15:j*16];
//       end
//     end
//   end
// endgenerate


endmodule