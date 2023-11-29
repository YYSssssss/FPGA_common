//-----------------------------------------------------------------------------
// File: chirp_processing_top.v
// Author: Jade Yu
// Created by : Jade Yu
// Abstract: chirp_processing_top
// Modification history:
// $Log$
//   Jade Yu 7/27/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps


module rsp_s1_prep_top #(
  parameter READ_RAM_WIDTH   = 128,
  parameter SAMPLE_WIDTH     = 32,
  parameter DATA_NUM         = 1024,
  parameter PACKET_SELECT    = 3,
  parameter TWIDDLE_WIDTH    = 64
)
(
  input                             rst_n,
  input                             hrst_n,
  input                             clk,             //500M
  input                             hclk,            //100M
  input                             i_switch,        //switch-- 1:real_cal  0:complex_cal
  input                             i_start,
  input  [12:0]                     DC_DCEST_SMP_CNT  ,
  input  [9:0]                      DC_DCEST_CHP_CNT  ,
  input  [3:0]                      DC_DCEST_FRM_CNT  ,
  input  [SAMPLE_WIDTH/2:0]         DC_DCEST_SCALE    ,
  input  [3:0]                      DC_config_mode    ,
  input  [SAMPLE_WIDTH-1:0]         i_dc_u            ,
  output [SAMPLE_WIDTH-1:0]         o_dc_u            ,

  input  [12:0]                     INTF_DCEST_SMP_CNT,
  input  [9:0]                      INTF_DCEST_CHP_CNT,
  input  [3:0]                      INTF_DCEST_FRM_CNT,
  input  [SAMPLE_WIDTH/2:0]         INTF_DCEST_SCALE  ,
  input  [3:0]                      INTF_config_mode  ,
  input  [3:0]                      combination_config_mode  ,
  input  [SAMPLE_WIDTH-1:0]         i_intf_cmp        ,
  output [SAMPLE_WIDTH-1:0]         o_intf_cmp        ,

  //phase_gen: AHB to RAM
  input  [TWIDDLE_WIDTH-1:0]        i_phase_coe,
  input  [5:0]                      i_phase_entry_select  ,
  input  [TWIDDLE_WIDTH-1:0]        i_phase_w,
  input  [10:0]                     i_phase_ram0_addra,
  input                             i_phase_ram0_bwea,
  input                             i_phase_ram0_ena,
  input  [TWIDDLE_WIDTH-1:0]        i_phase_ram0_dina,
  output [TWIDDLE_WIDTH-1:0]        o_phase_ram0_douta,
  input                             i_phase_ram0_wena,

  input  [5:0]                      i_phase_ram1_addra,
  input                             i_phase_ram1_bwea,
  input                             i_phase_ram1_ena,
  input  [31:0]                     i_phase_ram1_dina,
  output [31:0]                     o_phase_ram1_douta,
  input                             i_phase_ram1_wena,

  input  [READ_RAM_WIDTH-1:0]       i_x0,            //input complex or real 128bit
  input                             i_x0_valid,      //input i_x0_valid
  input                             i_x0_last,       //input i_x0_last
  output [READ_RAM_WIDTH-1:0]       o_y0,            //output complex or real
  output                            o_y0_valid       //output complex or real
);

//******************** Description   ********************//
//This module is chirp_processing_top

//********************  parameter  ********************//
localparam BURST_LEN = 8; 
localparam ROW_DATA_NUM = 8;
localparam DATA_WIDTH = READ_RAM_WIDTH/BURST_LEN; //data width 128/8=16bit

localparam TOP_X0_VALID       = 1+1;
localparam TOP_BUFFER_VALID   = 2+1;
localparam TOP_X0_LAST        = 1+1;
localparam TOP_X0_DIFF_LAST   = 1;

localparam DIFF_X0_LAST_DATA  = 1;
localparam DIFF_X0_DIFF_VALID = 1;
localparam DIFF_X0_LAST       = 2;
localparam CNT_LEN            = 8;
localparam TOP_X0_DIFF_VALID  = 2;

localparam ABS_CMP_X1_RVALID  = 1;
localparam ABS_CMP_X1_CVALID  = 1;

localparam TOP_BUFFER_RD_EN      = 5;
localparam COMB_Y0_VALID         = 2;
localparam COMB_S_LF_REAL_CMP    = 5+5;
localparam COMB_S_HF_REAL_CMP    = 1+5;
localparam COMB_S_LF_COMPLEX_CMP = 5+5;
localparam COMB_S_HF_COMPLEX_CMP = 1+5;

localparam MUL_COMPLEX_VALID  = 6;
localparam MUL_REAL_VALID     = 1;




//********************  reg & wire  ********************//
wire [SAMPLE_WIDTH-1:0] DC_u;
// wire [SAMPLE_WIDTH-1:0] s_DC_u;

wire [SAMPLE_WIDTH/2-1:0] s_INTF_esti;
wire [SAMPLE_WIDTH/2-1:0] INTF_esti;

reg                           x0_valid;
reg                           x0_last;
reg signed [DATA_WIDTH:0]     x0_data [ROW_DATA_NUM-1:0];
reg signed [DATA_WIDTH-1:0]   x_u_data [ROW_DATA_NUM-1:0];

wire                          x0_diff_valid;
wire                          x0_diff_last;
wire signed [DATA_WIDTH-1:0]  x0_diff_data [ROW_DATA_NUM-1:0];

wire [ROW_DATA_NUM-1:0]                LF_real_cmp;
wire [ROW_DATA_NUM/2-1:0]              LF_complex_cmp;
wire                          LF_rcmp_valid;
wire                          LF_complex_valid;

wire [ROW_DATA_NUM-1:0]                HF_real_cmp;
wire [ROW_DATA_NUM/2-1:0]              HF_complex_cmp;
wire                          HF_rcmp_valid;
wire                          HF_complex_valid;

reg [READ_RAM_WIDTH-1:0]      s_x0_data;
reg [READ_RAM_WIDTH-1:0]      x0_delay_data;
wire                          buffer_empty;
wire                          buffer_full;
reg                           buffer_rd_en;
reg                           s_buffer_rd_en;
reg [READ_RAM_WIDTH-1:0]      s_x0_delay_data;

reg [READ_RAM_WIDTH-1:0]      comb_data;
reg                           comb_valid;
reg                           s_comb_valid;

reg  signed [SAMPLE_WIDTH-1:0]   s_comb_data [0:ROW_DATA_NUM/2-1];
reg  [TWIDDLE_WIDTH-1:0]      o_w [3:0];
reg  signed [SAMPLE_WIDTH-1:0]   y0_data [0:ROW_DATA_NUM/2-1];
wire        [0:0]             mul_valid[3:0];
wire                          buffer_valid;

//debug
logic                         LF_x1_rabs_rdy;
logic                         LF_x1_cabs_rdy;
logic       [DATA_WIDTH-1:0]  LF_x1_rabs_data [ROW_DATA_NUM-1:0];
logic       [DATA_WIDTH-1:0]  LF_x1_cabs_data [ROW_DATA_NUM/2-1:0];
logic                         LF_abd_valid;
logic       [DATA_WIDTH-1:0]  LF_a  [3:0];
logic       [DATA_WIDTH-1:0]  LF_b  [3:0];
logic       [DATA_WIDTH-1:0]  LF_c  [3:0];
logic       [DATA_WIDTH-1:0]  LF_d  [3:0];
logic                         LF_c_valid ;  
logic                         HF_x1_rabs_rdy;
logic                         HF_x1_cabs_rdy;
logic       [DATA_WIDTH-1:0]  HF_x1_rabs_data [ROW_DATA_NUM-1:0];
logic       [DATA_WIDTH-1:0]  HF_x1_cabs_data [ROW_DATA_NUM/2-1:0];
logic                         HF_abd_valid;
logic       [DATA_WIDTH-1:0]  HF_a  [3:0];
logic       [DATA_WIDTH-1:0]  HF_b  [3:0];
logic       [DATA_WIDTH-1:0]  HF_c  [3:0];
logic       [DATA_WIDTH-1:0]  HF_d  [3:0];
logic                         HF_c_valid ;  
logic                         phase_gen_valid;

//********************  DC estimation  ********************//0
rsp_s1_prep_estimation #(
  .READ_RAM_WIDTH  (128),
  .DATA_WIDTH      (16 )
) u_rsp_s1_prep_DC_estimation(
  .rst_n           (rst_n    ),
  .clk             (clk      ),
  .DCEST_SMP_CNT   (DC_DCEST_SMP_CNT),
  .DCEST_CHP_CNT   (DC_DCEST_CHP_CNT),
  .DCEST_FRM_CNT   (DC_DCEST_FRM_CNT),
  .DCEST_SCALE     (DC_DCEST_SCALE  ),
  .config_mode     (DC_config_mode  ),
  .i_switch        (i_switch ),
  .i_x0_data       (i_x0),
  .i_x0_valid      (i_x0_valid),
  .i_x0_last       (i_x0_last  ),
  .o_y0            (o_dc_u),
  .o_y0_valid      ()
);

// assign DC_u = {16'd118,16'd420};
// assign DC_u = {16'd538,16'd538};
assign DC_u = i_switch ? {i_dc_u[15:0],i_dc_u[15:0]} : i_dc_u;
//********************  INTF estimation  ********************//0
rsp_s1_prep_estimation #(
  .READ_RAM_WIDTH  (128),
  .DATA_WIDTH      (16 )
) u_rsp_s1_prep_INTF_estimation(
  .rst_n           (rst_n    ),
  .clk             (clk      ),
  .DCEST_SMP_CNT   (INTF_DCEST_SMP_CNT),
  .DCEST_CHP_CNT   (INTF_DCEST_CHP_CNT),
  .DCEST_FRM_CNT   (INTF_DCEST_FRM_CNT),
  .DCEST_SCALE     (INTF_DCEST_SCALE  ),
  .config_mode     (INTF_config_mode  ),
  .i_switch        (i_switch ),
  .i_x0_data       (i_x0),
  .i_x0_valid      (i_x0_valid ),
  .i_x0_last       (i_x0_last  ),
  .o_y0            (o_intf_cmp),
  .o_y0_valid      ()
);

// assign INTF_esti = 16'd512;
// assign INTF_esti = 16'd657;
assign INTF_esti = i_intf_cmp[15:0];

//********************  (x-u)  ********************//0
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    x0_data[0] <= {DATA_WIDTH{1'b0}};
    x0_data[1] <= {DATA_WIDTH{1'b0}};
    x0_data[2] <= {DATA_WIDTH{1'b0}};
    x0_data[3] <= {DATA_WIDTH{1'b0}};
    x0_data[4] <= {DATA_WIDTH{1'b0}};
    x0_data[5] <= {DATA_WIDTH{1'b0}};
    x0_data[6] <= {DATA_WIDTH{1'b0}};
    x0_data[7] <= {DATA_WIDTH{1'b0}};
  end
  else begin
    x0_data[0] <= {{2{i_x0[15]}},i_x0[14:0]}    - {{2{DC_u[15]}},DC_u[14:0]} ;
    x0_data[1] <= {{2{i_x0[31]}},i_x0[30:16]}   - {{2{DC_u[31]}},DC_u[30:16]};
    x0_data[2] <= {{2{i_x0[47]}},i_x0[46:32]}   - {{2{DC_u[15]}},DC_u[14:0]} ;
    x0_data[3] <= {{2{i_x0[63]}},i_x0[62:48]}   - {{2{DC_u[31]}},DC_u[30:16]};
    x0_data[4] <= {{2{i_x0[79]}},i_x0[78:64]}   - {{2{DC_u[15]}},DC_u[14:0]} ;
    x0_data[5] <= {{2{i_x0[95]}},i_x0[94:80]}   - {{2{DC_u[31]}},DC_u[30:16]};
    x0_data[6] <= {{2{i_x0[111]}},i_x0[110:96]}  - {{2{DC_u[15]}},DC_u[14:0]} ;
    x0_data[7] <= {{2{i_x0[127]}},i_x0[126:112]} - {{2{DC_u[31]}},DC_u[30:16]};
  end
end

genvar j;
generate
  for (j=0; j<ROW_DATA_NUM; j=j+1) begin
    always @(posedge clk or negedge rst_n) begin
      if(!rst_n) begin
        x_u_data[j] <= {DATA_WIDTH{1'b0}};
      end
      else begin
        if(~x0_data[j][DATA_WIDTH] && (|x0_data[j][DATA_WIDTH:DATA_WIDTH-1])) begin
          x_u_data[j] <= {(DATA_WIDTH-1){1'b1}};
        end
        else if(x0_data[j][DATA_WIDTH] && ~(&x0_data[j][DATA_WIDTH:DATA_WIDTH-1])) begin
          x_u_data[j] <= {{1'b1},{(DATA_WIDTH-2){1'b0}},{1'b1}};
        end
        else begin
          x_u_data[j] <= {x0_data[j][DATA_WIDTH],x0_data[j][DATA_WIDTH-2:0]};;
        end
      end
    end
  end
endgenerate

// assign x_u_data[0] = {x0_data[0][DATA_WIDTH],x0_data[0][DATA_WIDTH-2:0]};
// assign x_u_data[1] = {x0_data[1][DATA_WIDTH],x0_data[1][DATA_WIDTH-2:0]};
// assign x_u_data[2] = {x0_data[2][DATA_WIDTH],x0_data[2][DATA_WIDTH-2:0]};
// assign x_u_data[3] = {x0_data[3][DATA_WIDTH],x0_data[3][DATA_WIDTH-2:0]};
// assign x_u_data[4] = {x0_data[4][DATA_WIDTH],x0_data[4][DATA_WIDTH-2:0]};
// assign x_u_data[5] = {x0_data[5][DATA_WIDTH],x0_data[5][DATA_WIDTH-2:0]};
// assign x_u_data[6] = {x0_data[6][DATA_WIDTH],x0_data[6][DATA_WIDTH-2:0]};
// assign x_u_data[7] = {x0_data[7][DATA_WIDTH],x0_data[7][DATA_WIDTH-2:0]};

//********************  delay  ********************//0
delay #(TOP_X0_VALID) delay_i_x0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(x0_valid));
delay #(TOP_BUFFER_VALID) delay_buffer_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(buffer_valid));
delay #(TOP_X0_LAST) delay_i_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));
delay #(TOP_X0_DIFF_LAST) delay_diff_HF_clast(.clk(clk), .rst_n(rst_n), .din(x0_last), .dout(x0_diff_last));
delay #(TOP_BUFFER_RD_EN) delay_buffer_rd_en(.clk(clk), .rst_n(rst_n), .din(buffer_rd_en), .dout(s_buffer_rd_en));



//********************  abs_cmp(LF)  ********************//1
rsp_s1_prep_abs_cmp#(
  .READ_RAM_WIDTH     (READ_RAM_WIDTH),
  .SAMPLE_WIDTH       (SAMPLE_WIDTH  ),
  .DATA_WIDTH         (DATA_WIDTH    ),
  .NUM                (ROW_DATA_NUM  ),
  .ABS_CMP_X1_RVALID  (ABS_CMP_X1_RVALID),
  .ABS_CMP_X1_CVALID  (ABS_CMP_X1_CVALID)
)
u_LF_abs(
  .rst_n             (rst_n           ),
  .clk               (clk             ),
  .i_switch          (i_switch        ),
  .i_x0_valid        (x0_valid        ),
  .i_x0_last         (),
  .x0_data           (x_u_data),//(x0_data         ),
  .INTF_esti         (INTF_esti       ),
  .o_real_cmp        (LF_real_cmp     ),
  .o_complex_cmp     (LF_complex_cmp  ),
  .o_rcmp_valid      (LF_rcmp_valid   ),
  .o_ccmp_valid      (LF_complex_valid),

  //debug
  .x1_rabs_rdy       (LF_x1_rabs_rdy ),
  .x1_cabs_rdy       (LF_x1_cabs_rdy ),
  .x1_rabs_data      (LF_x1_rabs_data),
  .x1_cabs_data      (LF_x1_cabs_data),

  .abd_valid         (LF_abd_valid), 
  .a                 (LF_a        ), 
  .b                 (LF_b        ), 
  .c                 (LF_c        ), 
  .d                 (LF_d        ), 
  .c_valid           (LF_c_valid  )    
);

//********************  diff_abs_cmp(HF)  ********************//1
rsp_s1_prep_diff #(
  .READ_RAM_WIDTH      (READ_RAM_WIDTH),
  .SAMPLE_WIDTH        (SAMPLE_WIDTH  ),
  .DATA_NUM            (DATA_NUM),
  .BURST_LEN           (BURST_LEN)
)
u_diff(
  .rst_n      (rst_n           ),
  .clk        (clk             ),
  .i_switch   (i_switch        ),
  .i_x0_data  (x_u_data),//(x0_data         ),
  .i_x0_valid (x0_valid        ),
  .i_x0_last  (x0_last         ),
  .o_y0       (x0_diff_data    ),
  .o_y0_valid (x0_diff_valid   )
);

rsp_s1_prep_abs_cmp#(
  .READ_RAM_WIDTH     (READ_RAM_WIDTH),
  .SAMPLE_WIDTH       (SAMPLE_WIDTH  ),
  .DATA_WIDTH         (DATA_WIDTH    ),
  .NUM                (ROW_DATA_NUM  ),
  .ABS_CMP_X1_RVALID  (ABS_CMP_X1_RVALID),
  .ABS_CMP_X1_CVALID  (ABS_CMP_X1_CVALID)
)
u_HF_abs(
  .rst_n             (rst_n           ),
  .clk               (clk             ),
  .i_switch          (i_switch        ),
  .i_x0_valid        (x0_diff_valid   ),
  .i_x0_last         (x0_diff_last    ),
  .x0_data           (x0_diff_data    ),
  .INTF_esti         (INTF_esti       ),
  .o_real_cmp        (HF_real_cmp     ),
  .o_complex_cmp     (HF_complex_cmp  ),
  .o_rcmp_valid      (HF_rcmp_valid   ),
  .o_ccmp_valid      (HF_complex_valid),

  //debug
  .x1_rabs_rdy       (HF_x1_rabs_rdy ),
  .x1_cabs_rdy       (HF_x1_cabs_rdy ),
  .x1_rabs_data      (HF_x1_rabs_data),
  .x1_cabs_data      (HF_x1_cabs_data),

  .abd_valid         (HF_abd_valid), 
  .a                 (HF_a        ), 
  .b                 (HF_b        ), 
  .c                 (HF_c        ), 
  .d                 (HF_d        ), 
  .c_valid           (HF_c_valid  )  
);

//********************  buffer  ********************//1

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    s_x0_data <= {READ_RAM_WIDTH{1'b0}};
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
    x0_delay_data <= {READ_RAM_WIDTH{1'b0}};
  end
  else begin
    x0_delay_data <= s_x0_delay_data;
  end
end

//********************  comb  ********************//2
rsp_s1_prep_combination #(
  .READ_RAM_WIDTH         (READ_RAM_WIDTH),
  .NUM                    (ROW_DATA_NUM),
  .DATA_WIDTH             (DATA_WIDTH),
  .COMB_Y0_VALID          (COMB_Y0_VALID),
  .COMB_S_LF_REAL_CMP     (COMB_S_LF_REAL_CMP   ),
  .COMB_S_HF_REAL_CMP     (COMB_S_HF_REAL_CMP   ),
  .COMB_S_LF_COMPLEX_CMP  (COMB_S_LF_COMPLEX_CMP),
  .COMB_S_HF_COMPLEX_CMP  (COMB_S_HF_COMPLEX_CMP)
) u_combination(
  .clk             (clk             ),
  .rst_n           (rst_n           ),
  .i_switch        (i_switch        ),
  .i_config_mode   (combination_config_mode),
  .LF_real_cmp     (LF_real_cmp     ),
  .LF_complex_cmp  (LF_complex_cmp  ),
  .LF_rcmp_valid   (LF_rcmp_valid   ),
  .LF_complex_valid(LF_complex_valid),
  .HF_real_cmp     (HF_real_cmp     ),
  .HF_complex_cmp  (HF_complex_cmp  ),
  .HF_rcmp_valid   (HF_rcmp_valid   ),
  .HF_complex_valid(HF_complex_valid),
  .i_x0            (x0_delay_data   ),
  .i_x0_valid      (s_buffer_rd_en  ),
  .o_y0            (comb_data       ),
  .o_y0_valid      (comb_valid      )
);

//********************  multiplier(*w)  ********************//
delay #(20) delay_phase_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(phase_last));

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    buffer_rd_en <= 1'b0;
  end
  else begin
    buffer_rd_en <= (i_switch == 1'b1) ? HF_rcmp_valid : HF_complex_valid;
  end
end

rsp_s1_prep_phase_generation #(
  .RAM_DELAY          (2),
  .RAM0_ADDR_WIDTH    (11),
  .RAM1_ADDR_WIDTH    (6),
  .RAM_DATA_WIDTH     (64),
  .TWIDDLE_WIDTH      (64),
  .DATA_NUM           (1024)
) u_rsp_s1_prep_phase_generation(
  .rst_n                      (rst_n),
  .hrst_n                     (),
  .clk                        (clk),
  .hclk                       (),
  .i_start                    (i_start),
  .i_data_valid               (buffer_rd_en),
  .i_data_last                (phase_last),
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
      .TWIDDLE_WIDTH    (50),
      .SAMPLE_WIDTH     (SAMPLE_WIDTH),
      .NUM              (ROW_DATA_NUM),
      .MUL_COMPLEX_VALID(MUL_COMPLEX_VALID),
      .MUL_REAL_VALID   (MUL_REAL_VALID)
    )
    multiplier0(
      .rst_n      (rst_n       ),
      .clk        (clk         ),
      .i_switch   (i_switch    ),
      //.i_u        ('h02000200  ),
      .i_x0_data  (s_comb_data[i]),
      .i_w        ({o_w[i][56],o_w[i][55:32],o_w[i][24],o_w[i][23:0]}),
      .i_x0_valid (s_comb_valid),
      .o_y0       (y0_data[i]  ),
      .o_y0_valid (mul_valid[i])
    );
  end
endgenerate


assign o_y0 = {y0_data[3],y0_data[2],y0_data[1],y0_data[0]};
assign o_y0_valid = mul_valid[0];






//******************** debug ********************//
logic [39-15:0] debug_esti_data;
logic           debug_esti_valid;
logic [127:0] debug_LF_x1_cabs_data;
logic [127:0] debug_HF_x1_cabs_data;
logic [127:0] debug_diff_data;
logic [READ_RAM_WIDTH-1:0] debug_mul_c_data;
logic                      debug_y0_valid;
logic [127:0]   debug_x0_data;
logic           debug_x0_valid;

logic [ROW_DATA_NUM-1:0]   debug_LF_cmp  ;
logic [ROW_DATA_NUM-1:0]   s_debug_LF_cmp  ;
logic             debug_LF_valid;
logic [ROW_DATA_NUM-1:0]   debug_HF_cmp  ;
logic [ROW_DATA_NUM-1:0]   s_debug_HF_cmp  ;
logic             debug_HF_valid;

logic             debug_LF_abd_valid;
logic [READ_RAM_WIDTH-1:0]  debug_LF_a;
logic [READ_RAM_WIDTH-1:0]  debug_LF_b;
logic [READ_RAM_WIDTH-1:0]  debug_LF_c;
logic [READ_RAM_WIDTH-1:0]  debug_LF_d;
logic             debug_LF_c_valid;  

always @(posedge clk or negedge rst_n) begin
  if(!rst_n) begin
    debug_LF_x1_cabs_data <= 'd0;
    debug_HF_x1_cabs_data <= 'd0;
    debug_diff_data       <= 'd0;
    debug_x0_data         <= 'd0;
    debug_x0_valid        <= 'd0;
    debug_LF_a            <= 'd0;
    debug_LF_b            <= 'd0;
    debug_LF_c            <= 'd0;
    debug_LF_d            <= 'd0;
  end
  else begin
    debug_LF_x1_cabs_data <= {16'd0,LF_x1_cabs_data[3],16'd0,LF_x1_cabs_data[2],16'd0,LF_x1_cabs_data[1],16'd0,LF_x1_cabs_data[0]};
    debug_HF_x1_cabs_data <= {16'd0,HF_x1_cabs_data[3],16'd0,HF_x1_cabs_data[2],16'd0,HF_x1_cabs_data[1],16'd0,HF_x1_cabs_data[0]};
    debug_diff_data <= {x0_diff_data[7],x0_diff_data[6],x0_diff_data[5],x0_diff_data[4],x0_diff_data[3],x0_diff_data[2],x0_diff_data[1],x0_diff_data[0]};
    debug_x0_data  <= {x_u_data[7],x_u_data[6],x_u_data[5],x_u_data[4],x_u_data[3],x_u_data[2],x_u_data[1],x_u_data[0]};
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
  else if(i_switch == 1'b1) begin
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

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/X-u.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_X_u_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (x0_valid),
  .data     (debug_x0_data)
);

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (25),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/estimation_data.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_estimation_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (debug_esti_valid),
  .data     (debug_esti_data)
);

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/ABS1.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_save_file_lfcabs_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (LF_x1_cabs_rdy),
  .data     (debug_LF_x1_cabs_data)
);

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (8),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/cmp_array1_square.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_cmp_array1(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (debug_LF_valid),
  .data     (s_debug_LF_cmp)
);

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/ABS2.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_save_file_hfcabs_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (HF_x1_cabs_rdy),
  .data     (debug_HF_x1_cabs_data)
);

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (8),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/cmp_array2_square.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_cmp_array2(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (debug_HF_valid),
  .data     (s_debug_HF_cmp)
);

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/X_diff.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
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
  .DATA_WIDTH      (128),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/X_comp.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_comb_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (comb_valid),
  .data     (comb_data)
);

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/twiddle_1024x64_0.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_phase_gen0(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[0])
);
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/twiddle_1024x64_1.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_phase_gen1(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[1])
);
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/twiddle_1024x64_2.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_phase_gen2(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[2])
);
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (64),
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/twiddle_1024x64_3.txt"),
  .cnt_data        (DATA_NUM-1),
  .packet_select   (PACKET_SELECT)
) u_phase_gen3(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (phase_gen_valid),
  .data     (o_w[3])
);


endmodule