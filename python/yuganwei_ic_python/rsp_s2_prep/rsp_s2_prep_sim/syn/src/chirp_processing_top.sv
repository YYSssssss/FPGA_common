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


module chirp_processing_top #(
  parameter READ_RAM_WIDTH = 128,
  parameter SAMPLE_WIDTH = 32
)
(
  input                             rst_n,
  input                             clk,
  input                             i_switch,        //switch-- 1:real_cal  0:complex_cal
  input  [12:0]                     DC_DCEST_SMP_CNT  ,
  input  [9:0]                      DC_DCEST_CHP_CNT  ,
  input  [3:0]                      DC_DCEST_FRM_CNT  ,
  input  [SAMPLE_WIDTH/2:0]         DC_DCEST_SCALE    ,
  input  [1:0]                      DC_config_mode    ,
  input  [12:0]                     INTF_DCEST_SMP_CNT,
  input  [9:0]                      INTF_DCEST_CHP_CNT,
  input  [3:0]                      INTF_DCEST_FRM_CNT,
  input  [SAMPLE_WIDTH/2:0]         INTF_DCEST_SCALE  ,
  input  [1:0]                      INTF_config_mode  ,
  input  [1:0]                      combination_config_mode  ,
  input  [READ_RAM_WIDTH-1:0]       i_x0,            //input complex or real 128bit
  input                             i_x0_valid,      //input i_x0_valid
  input                             i_x0_last,       //input i_x0_last
  input  [SAMPLE_WIDTH-1:0]         i_w,             //i_W
  output [READ_RAM_WIDTH-1:0]       o_y0,            //output complex or real
  output                            o_y0_valid       //output complex or real
);

//******************** Description   ********************//
//This module is chirp_processing_top

//********************  parameter  ********************//
localparam NUM = 8; //A row(128bit) of Ram represents 8 data(16bit)
localparam DATA_WIDTH = READ_RAM_WIDTH/NUM; //data width 128/8=16bit
localparam SWITCH_AXI_DELAY = 0;

localparam TOP_X0_VALID       = 3;
localparam TOP_BUFFER_VALID   = 4;
localparam TOP_X0_LAST        = 1;
localparam TOP_X0_DIFF_LAST   = 1;

localparam DIFF_X0_LAST_DATA  = 1;
localparam DIFF_X0_DIFF_VALID = 1;
localparam DIFF_X0_LAST       = 2;
localparam CNT_LEN            = 8;
localparam TOP_X0_DIFF_VALID  = 2;

localparam ABS_CMP_X1_RVALID  = 1;
localparam ABS_CMP_X1_CVALID  = 1;

localparam COMB_Y0_VALID         = 2;
localparam COMB_S_LF_REAL_CMP    = 3;
localparam COMB_S_HF_REAL_CMP    = 1;
localparam COMB_S_LF_COMPLEX_CMP = 3;
localparam COMB_S_HF_COMPLEX_CMP = 1;

localparam MUL_COMPLEX_VALID  = 6;
localparam MUL_REAL_VALID     = 3;


//********************  reg & wire  ********************//
wire [SAMPLE_WIDTH-1:0] DC_u;
wire [SAMPLE_WIDTH-1:0] s_DC_u;

wire [SAMPLE_WIDTH/2-1:0] s_INTF_esti;
wire [SAMPLE_WIDTH/2-1:0] INTF_esti;

reg                           x0_valid;
reg                           x0_last;
reg signed [DATA_WIDTH-1:0]   x0_data [NUM-1:0];

wire                          x0_valid1;
wire signed [DATA_WIDTH-1:0]   x0_data1 [NUM-1:0];

wire                          x0_diff_valid;
wire                          x0_diff_last;
wire signed [DATA_WIDTH-1:0]  x0_diff_data [NUM-1:0];

wire [NUM-1:0]                LF_real_cmp;
wire [NUM/2-1:0]              LF_complex_cmp;
wire                          LF_rcmp_valid;
wire                          LF_complex_valid;

wire [NUM-1:0]                HF_real_cmp;
wire [NUM/2-1:0]              HF_complex_cmp;
wire                          HF_rcmp_valid;
wire                          HF_complex_valid;

reg [READ_RAM_WIDTH-1:0]      s_x0_data;
reg [READ_RAM_WIDTH-1:0]      x0_delay_data;
wire                          buffer_empty;
wire                          buffer_full;
reg                           buffer_rd_en;
reg [READ_RAM_WIDTH-1:0]      s_x0_delay_data;

reg [READ_RAM_WIDTH-1:0]      comb_data;
reg                           comb_valid;
reg                           s_comb_valid;

reg  signed [SAMPLE_WIDTH-1:0]   s_comb_data [0:NUM/2-1];
reg  signed [SAMPLE_WIDTH-1:0]   y0_data [0:NUM/2-1];
wire        [0:0]             mul_valid[3:0];
wire                          buffer_valid;

//debug
logic                         LF_x1_rabs_rdy;
logic                         LF_x1_cabs_rdy;
logic       [DATA_WIDTH-1:0]  LF_x1_rabs_data [NUM-1:0];
logic       [DATA_WIDTH-1:0]  LF_x1_cabs_data [NUM/2-1:0];
logic                         LF_abd_valid;
logic       [DATA_WIDTH-1:0]  LF_a  [3:0];
logic       [DATA_WIDTH-1:0]  LF_b  [3:0];
logic       [DATA_WIDTH-1:0]  LF_c  [3:0];
logic       [DATA_WIDTH-1:0]  LF_d  [3:0];
logic                         LF_c_valid ;  
logic                         HF_x1_rabs_rdy;
logic                         HF_x1_cabs_rdy;
logic       [DATA_WIDTH-1:0]  HF_x1_rabs_data [NUM-1:0];
logic       [DATA_WIDTH-1:0]  HF_x1_cabs_data [NUM/2-1:0];
logic                         HF_abd_valid;
logic       [DATA_WIDTH-1:0]  HF_a  [3:0];
logic       [DATA_WIDTH-1:0]  HF_b  [3:0];
logic       [DATA_WIDTH-1:0]  HF_c  [3:0];
logic       [DATA_WIDTH-1:0]  HF_d  [3:0];
logic                         HF_c_valid ;  

//********************  DC estimation  ********************//0
estimation #(
  .READ_RAM_WIDTH  (128),
  .DATA_WIDTH      (16 )
) u_DC_estimation(
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
  .i_x0_last       (x0_last  ),
  .o_y0            (s_DC_u),
  .o_y0_valid      ()
);

// assign DC_u = {16'd118,16'd420};
// assign DC_u = {16'd538,16'd538};
assign DC_u = i_switch ? {s_DC_u[15:0],s_DC_u[15:0]} : s_DC_u;
//********************  INTF estimation  ********************//0
estimation #(
  .READ_RAM_WIDTH  (128),
  .DATA_WIDTH      (16 )
) u_INTF_estimation(
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
  .i_x0_last       (x0_last  ),
  .o_y0            (s_INTF_esti),
  .o_y0_valid      ()
);

// assign INTF_esti = 16'd512;
// assign INTF_esti = 16'd657;
assign INTF_esti = s_INTF_esti[15:0];

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
    x0_data[0] <= i_x0[15:0]    - DC_u[15:0] ;
    x0_data[1] <= i_x0[31:16]   - DC_u[31:16];
    x0_data[2] <= i_x0[47:32]   - DC_u[15:0] ;
    x0_data[3] <= i_x0[63:48]   - DC_u[31:16];
    x0_data[4] <= i_x0[79:64]   - DC_u[15:0] ;
    x0_data[5] <= i_x0[95:80]   - DC_u[31:16];
    x0_data[6] <= i_x0[111:96]  - DC_u[15:0] ;
    x0_data[7] <= i_x0[127:112] - DC_u[31:16];
  end
  // else begin
  //   x0_data[0] <= i_x0[15:0]   ;
  //   x0_data[1] <= i_x0[31:16]  ;
  //   x0_data[2] <= i_x0[47:32]  ;
  //   x0_data[3] <= i_x0[63:48]  ;
  //   x0_data[4] <= i_x0[79:64]  ;
  //   x0_data[5] <= i_x0[95:80]  ;
  //   x0_data[6] <= i_x0[111:96] ;
  //   x0_data[7] <= i_x0[127:112];
  // end
end

//********************  delay  ********************//0
delay #(TOP_X0_VALID) delay_i_x0_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(x0_valid));
delay #(TOP_BUFFER_VALID) delay_buffer_valid(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(buffer_valid));
delay #(TOP_X0_LAST) delay_i_x0_last(.clk(clk), .rst_n(rst_n), .din(i_x0_last), .dout(x0_last));

delay #(TOP_X0_DIFF_LAST) delay_diff_HF_clast(.clk(clk), .rst_n(rst_n), .din(x0_last), .dout(x0_diff_last));



//********************  abs_cmp(LF)  ********************//1
buffer_8data #(
    .READ_RAM_WIDTH (READ_RAM_WIDTH),
    .SAMPLE_WIDTH   (SAMPLE_WIDTH  ),
    .NUM            (NUM           )
)u_buffer_8data(
    .clk          (clk),
    .rst_n        (rst_n),
    .i_x0_data    (x0_data),
    .i_x0_valid   (x0_valid),
    .i_x0_last    (x0_last),
    .o_y0_data    (x0_data1),
    .o_y0_valid   (x0_valid1)
);

abs_cmp#(
  .READ_RAM_WIDTH     (READ_RAM_WIDTH),
  .SAMPLE_WIDTH       (SAMPLE_WIDTH  ),
  .DATA_WIDTH         (DATA_WIDTH    ),
  .NUM                (NUM           ),
  .ABS_CMP_X1_RVALID  (ABS_CMP_X1_RVALID),
  .ABS_CMP_X1_CVALID  (ABS_CMP_X1_CVALID)
)
u_LF_abs(
  .rst_n             (rst_n           ),
  .clk               (clk             ),
  .i_switch          (i_switch        ),
  .i_x0_valid        (x0_valid1       ),
  .i_x0_last         (),
  .x0_data           (x0_data1        ),
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
diff #(
  .READ_RAM_WIDTH      (READ_RAM_WIDTH),
  .SAMPLE_WIDTH        (SAMPLE_WIDTH),
  .NUM                 (NUM),
  .DIFF_X0_LAST_DATA   (DIFF_X0_LAST_DATA),
  .DIFF_X0_DIFF_VALID  (DIFF_X0_DIFF_VALID),
  .DIFF_X0_LAST        (DIFF_X0_LAST),
  .TOP_X0_DIFF_VALID   (TOP_X0_DIFF_VALID),
  .CNT_LEN             (CNT_LEN)
)
u_diff(
  .rst_n      (rst_n           ),
  .clk        (clk             ),
  .i_switch   (i_switch        ),
  .i_x0_data  (x0_data         ),
  .i_x0_valid (x0_valid        ),
  .i_x0_last  (x0_last         ),
  .o_y0       (x0_diff_data    ),
  .o_y0_valid (x0_diff_valid   )
);

abs_cmp#(
  .READ_RAM_WIDTH     (READ_RAM_WIDTH),
  .SAMPLE_WIDTH       (SAMPLE_WIDTH  ),
  .DATA_WIDTH         (DATA_WIDTH    ),
  .NUM                (NUM           ),
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
    s_x0_data <= {x0_data[7],x0_data[6],x0_data[5],x0_data[4],x0_data[3],x0_data[2],x0_data[1],x0_data[0]};
  end
end

fifo_cp #(
  .WIDTH       (128)
  // .DEPTH_FULL  (2)
) u_fifo(
  .clk     (clk),
  .rst_n   (rst_n),
  .push    (buffer_valid),
  .pop     (buffer_rd_en),
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
combination #(
  .READ_RAM_WIDTH         (READ_RAM_WIDTH),
  .NUM                    (NUM),
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
  .i_x0_valid      (buffer_rd_en    ),
  .o_y0            (comb_data       ),
  .o_y0_valid      (comb_valid      )
);

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    buffer_rd_en <= 1'b0;
  end
  else begin
    buffer_rd_en <= (i_switch == 1'b1) ? HF_rcmp_valid : HF_complex_valid;
  end
end


//********************  multiplier(*w)  ********************//

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
    chirp_processing_multiplier0 #(
      .SAMPLE_WIDTH     (SAMPLE_WIDTH),
      .MUL_COMPLEX_VALID(MUL_COMPLEX_VALID),
      .MUL_REAL_VALID   (MUL_REAL_VALID)
    )
    multiplier0(
      .rst_n      (rst_n       ),
      .clk        (clk         ),
      .i_switch   (i_switch    ),
      //.i_u        ('h02000200       ),
      .i_x0_data  (s_comb_data[i]  ),
      .i_w        (i_w  ),
      .i_x0_valid (s_comb_valid),
      .o_y0       (y0_data[i]  ),
      .o_y0_valid (mul_valid[i])
    );
  end
endgenerate

assign o_y0 = {y0_data[3],y0_data[2],y0_data[1],y0_data[0]};
assign o_y0_valid = mul_valid[0];


endmodule
