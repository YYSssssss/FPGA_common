`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: iade Yu
// 
// Create Date: 2023/08/07 14:47:10
// Design Name: Jade Yu
// Module Name: abs_cmp
// Proiect Name: 
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


module rsp_s1_prep_abs_cmp#(
  parameter READ_RAM_WIDTH    = 128,
  parameter SAMPLE_WIDTH      = 32,
  parameter DATA_WIDTH        = 16,
  parameter NUM               = 8,
  parameter ABS_CMP_X1_RVALID = 1,
  parameter ABS_CMP_X1_CVALID = 1
)
(
  input                              rst_n            ,
  input                              clk              ,
  input                              i_sel_16_32      ,
  input                              i_switch         , //switch-- 1:real_cal  0:complex_cal
  input                              i_x0_valid       ,     
  input                              i_x0_last        ,     
  input         [DATA_WIDTH-1:0]     x0_data [NUM-1:0],
  input  [SAMPLE_WIDTH*2-1:0]        INTF_esti        ,
  output reg [NUM-1:0]               o_real_cmp       ,
  output reg [NUM/2-1:0]             o_complex_cmp    ,     
  output reg [NUM/4-1:0]             o_c64_cmp        ,     
  output reg                         o_rcmp_valid     ,     
  output reg                         o_ccmp_valid     ,
  output reg                         o_c64_valid      ,

    //debug
  output logic [SAMPLE_WIDTH-1:0]    debug_abs_32 [0:NUM/2-1],//32
  output logic [DATA_WIDTH-1:0]      debug_abs_16 [0:NUM-1],

  output logic                       x1_rabs_rdy  ,
  output logic                       x1_cabs_rdy  ,
  output logic                       abs_c_32_rdy  ,
  output logic [DATA_WIDTH-1:0]      x1_rabs_data [NUM-1:0],
  output logic [DATA_WIDTH-1:0]      x1_cabs_data [NUM/2-1:0],
  output logic [SAMPLE_WIDTH-1:0]    abs_c_32_data [NUM/4-1:0],

  output logic                       abd_valid,
  output logic [DATA_WIDTH-1:0]      a  [3:0],
  output logic [DATA_WIDTH-1:0]      b  [3:0],
  output logic [DATA_WIDTH-1:0]      c  [3:0],
  output logic [DATA_WIDTH-1:0]      d  [3:0],
  output logic                       c_valid     
);

//******************** Description   ********************//


//********************  reg & wire  ********************//
reg  signed [DATA_WIDTH-1:0]  x1_rdata [0:NUM-1];
reg  signed [SAMPLE_WIDTH-1:0]  x1_c_32bit [0:NUM/2-1];//32
reg  signed [DATA_WIDTH-1:0]  x1_cdata [0:NUM-1];//16
wire                          x1_rvalid; 
wire                          x1_cvalid; 
wire        [NUM-1:0]         s_x1_rabs_rdy;
wire        [NUM/2-1:0]       s_x1_cabs_rdy;
wire        [NUM/2-1:0]       s_abs_c_32_rdy;
wire        [NUM/2-1:0]       s_c_32_rdy;
// reg         [DATA_WIDTH-1:0]  x1_rabs_data [NUM-1:0];
// reg         [DATA_WIDTH-1:0]  x1_cabs_data [NUM/2-1:0];
wire        [NUM-1:0]         r_cmp;
wire        [NUM/2-1:0]       c_cmp;
wire        [NUM/4-1:0]       c64_cmp;

//********************  divert real or complex  ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    x1_rdata[0] <= {DATA_WIDTH{1'b0}};
    x1_rdata[1] <= {DATA_WIDTH{1'b0}};
    x1_rdata[2] <= {DATA_WIDTH{1'b0}};
    x1_rdata[3] <= {DATA_WIDTH{1'b0}};
    x1_rdata[4] <= {DATA_WIDTH{1'b0}};
    x1_rdata[5] <= {DATA_WIDTH{1'b0}};
    x1_rdata[6] <= {DATA_WIDTH{1'b0}};
    x1_rdata[7] <= {DATA_WIDTH{1'b0}};

    x1_c_32bit[0] <= {SAMPLE_WIDTH{1'b0}};
    x1_c_32bit[1] <= {SAMPLE_WIDTH{1'b0}};
    x1_c_32bit[2] <= {SAMPLE_WIDTH{1'b0}};
    x1_c_32bit[3] <= {SAMPLE_WIDTH{1'b0}};

    x1_cdata[0] <= {DATA_WIDTH{1'b0}};
    x1_cdata[1] <= {DATA_WIDTH{1'b0}};
    x1_cdata[2] <= {DATA_WIDTH{1'b0}};
    x1_cdata[3] <= {DATA_WIDTH{1'b0}};
    x1_cdata[4] <= {DATA_WIDTH{1'b0}};
    x1_cdata[5] <= {DATA_WIDTH{1'b0}};
    x1_cdata[6] <= {DATA_WIDTH{1'b0}};
    x1_cdata[7] <= {DATA_WIDTH{1'b0}};
  end
  else if(i_sel_16_32 == 1'b1) begin
    // x1_c_32bit[0] <= {x0_data[1][DATA_WIDTH-2:0]-x0_data[0][DATA_WIDTH-1],x0_data[0][DATA_WIDTH-2:0]};
    // x1_c_32bit[1] <= {x0_data[3][DATA_WIDTH-2:0]-x0_data[2][DATA_WIDTH-1],x0_data[2][DATA_WIDTH-2:0]};
    // x1_c_32bit[2] <= {x0_data[5][DATA_WIDTH-2:0]-x0_data[4][DATA_WIDTH-1],x0_data[4][DATA_WIDTH-2:0]};
    // x1_c_32bit[3] <= {x0_data[7][DATA_WIDTH-2:0]-x0_data[6][DATA_WIDTH-1],x0_data[6][DATA_WIDTH-2:0]};
    x1_c_32bit[0] <= {x0_data[1],x0_data[0]};
    x1_c_32bit[1] <= {x0_data[3],x0_data[2]};
    x1_c_32bit[2] <= {x0_data[5],x0_data[4]};
    x1_c_32bit[3] <= {x0_data[7],x0_data[6]};
  end
  else if(i_switch == 1'b1) begin
    // x1_rdata[0] <= {x0_data[0][DATA_WIDTH/2],x0_data[0][DATA_WIDTH/2-2:0]};
    // x1_rdata[1] <= {x0_data[1][DATA_WIDTH/2],x0_data[1][DATA_WIDTH/2-2:0]};
    // x1_rdata[2] <= {x0_data[2][DATA_WIDTH/2],x0_data[2][DATA_WIDTH/2-2:0]};
    // x1_rdata[3] <= {x0_data[3][DATA_WIDTH/2],x0_data[3][DATA_WIDTH/2-2:0]};
    // x1_rdata[4] <= {x0_data[4][DATA_WIDTH/2],x0_data[4][DATA_WIDTH/2-2:0]};
    // x1_rdata[5] <= {x0_data[5][DATA_WIDTH/2],x0_data[5][DATA_WIDTH/2-2:0]};
    // x1_rdata[6] <= {x0_data[6][DATA_WIDTH/2],x0_data[6][DATA_WIDTH/2-2:0]};
    // x1_rdata[7] <= {x0_data[7][DATA_WIDTH/2],x0_data[7][DATA_WIDTH/2-2:0]};
    x1_rdata[0] <= x0_data[0][SAMPLE_WIDTH/2-1:0];
    x1_rdata[1] <= x0_data[1][SAMPLE_WIDTH/2-1:0];
    x1_rdata[2] <= x0_data[2][SAMPLE_WIDTH/2-1:0];
    x1_rdata[3] <= x0_data[3][SAMPLE_WIDTH/2-1:0];
    x1_rdata[4] <= x0_data[4][SAMPLE_WIDTH/2-1:0];
    x1_rdata[5] <= x0_data[5][SAMPLE_WIDTH/2-1:0];
    x1_rdata[6] <= x0_data[6][SAMPLE_WIDTH/2-1:0];
    x1_rdata[7] <= x0_data[7][SAMPLE_WIDTH/2-1:0];
  end
  else begin
    // x1_cdata[0] <= {x0_data[0][DATA_WIDTH/2],x0_data[0][DATA_WIDTH/2-2:0]};
    // x1_cdata[1] <= {x0_data[1][DATA_WIDTH/2],x0_data[1][DATA_WIDTH/2-2:0]};
    // x1_cdata[2] <= {x0_data[2][DATA_WIDTH/2],x0_data[2][DATA_WIDTH/2-2:0]};
    // x1_cdata[3] <= {x0_data[3][DATA_WIDTH/2],x0_data[3][DATA_WIDTH/2-2:0]};
    // x1_cdata[4] <= {x0_data[4][DATA_WIDTH/2],x0_data[4][DATA_WIDTH/2-2:0]};
    // x1_cdata[5] <= {x0_data[5][DATA_WIDTH/2],x0_data[5][DATA_WIDTH/2-2:0]};
    // x1_cdata[6] <= {x0_data[6][DATA_WIDTH/2],x0_data[6][DATA_WIDTH/2-2:0]};
    // x1_cdata[7] <= {x0_data[7][DATA_WIDTH/2],x0_data[7][DATA_WIDTH/2-2:0]};
    x1_cdata[0] <= x0_data[0][SAMPLE_WIDTH/2-1:0];
    x1_cdata[1] <= x0_data[1][SAMPLE_WIDTH/2-1:0];
    x1_cdata[2] <= x0_data[2][SAMPLE_WIDTH/2-1:0];
    x1_cdata[3] <= x0_data[3][SAMPLE_WIDTH/2-1:0];
    x1_cdata[4] <= x0_data[4][SAMPLE_WIDTH/2-1:0];
    x1_cdata[5] <= x0_data[5][SAMPLE_WIDTH/2-1:0];
    x1_cdata[6] <= x0_data[6][SAMPLE_WIDTH/2-1:0];
    x1_cdata[7] <= x0_data[7][SAMPLE_WIDTH/2-1:0];
  end
end

//********************  abs  ********************//
delay #(ABS_CMP_X1_RVALID) delay_real_abs(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(x1_rvalid));
delay #(ABS_CMP_X1_CVALID) delay_complex_abs(.clk(clk), .rst_n(rst_n), .din(i_x0_valid), .dout(x1_cvalid));

genvar i;
generate //real
 for (i=0; i<NUM; i=i+1) begin
   rsp_s1_prep_abs_real #(
     .WIDTH (DATA_WIDTH)
   )
   u_abs_real(
    .rst_n      (rst_n           ),
    .clk        (clk             ),
    .input_vld  (x1_rvalid),
    .s_real     (x1_rdata[i]),
    .abs_rdy    (s_x1_rabs_rdy[i]),
    .abs_value  (x1_rabs_data[i])
   );
 end
endgenerate

genvar j;
generate //complex 16bit
 for (j=0; j<NUM; j=j+2) begin
   rsp_s1_prep_abs_complex #(
     .WIDTH (DATA_WIDTH)
   )
   u_rsp_s1_prep_abs_m2_complex(
    .rst_n      (rst_n           ),
    .clk        (clk             ),
    .input_vld  (x1_cvalid),
    .s_imag     (x1_cdata[j+1]),
    .s_real     (x1_cdata[j]),
    .abs_rdy    (s_x1_cabs_rdy[j/2]),
    .abs_value  (x1_cabs_data[j/2]),

      //debug
    .abd_valid  (),
    .a          (a[j/2]),
    .b          (b[j/2]),
    .c          (c[j/2]),
    .d          (d[j/2]),
    .c_valid    ()
   );
 end
endgenerate

genvar M;
generate //complex 32bit
 for (M=0; M<NUM/2; M=M+2) begin
   rsp_s1_prep_abs_complex #(
     .WIDTH (SAMPLE_WIDTH)
   )
   u_rsp_s1_prep_abs_32bit_complex(
     .rst_n      (rst_n           ),
     .clk        (clk             ),
     .input_vld  (x1_cvalid),
     .s_imag     (x1_c_32bit[M+1]),
     .s_real     (x1_c_32bit[M]),
     .abs_rdy    (s_abs_c_32_rdy[M/2]),
     .abs_value  (abs_c_32_data[M/2]),

      //debug
    .abd_valid  (),
    .a          (),
    .b          (),
    .c          (),
    .d          (),
    .c_valid    ()
   );
 end
endgenerate

assign x1_rabs_rdy = s_x1_rabs_rdy[0];
assign x1_cabs_rdy = s_x1_cabs_rdy[0];
assign abs_c_32_rdy = s_abs_c_32_rdy[0];

//********************  compare  ********************//
genvar k;
generate //real_compare
 for (k=0; k<NUM; k=k+1) begin
   assign r_cmp[k] = (x1_rabs_data[k] > INTF_esti[15:0]) ? 1'b0 : 1'b1; 
 end
endgenerate

genvar L;
generate //real_compare
 for (L=0; L<NUM/2; L=L+1) begin
   assign c_cmp[L] = (x1_cabs_data[L] > INTF_esti[31:0]) ? 1'b0 : 1'b1; 
 end
endgenerate

genvar N;
generate //real_compare
 for (N=0; N<NUM/4; N=N+1) begin
   assign c64_cmp[N] = (abs_c_32_data[N] > INTF_esti) ? 1'b0 : 1'b1; 
 end
endgenerate

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_real_cmp    <= {NUM{1'b0}};
    o_complex_cmp <= {NUM/2{1'b0}};
  end
  else if(i_sel_16_32 == 1'b1) begin
    o_c64_cmp <= c64_cmp;
  end
  else if(i_switch == 1'b0) begin
    o_complex_cmp <= c_cmp;
  end
  else begin
    o_real_cmp <= r_cmp;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_rcmp_valid <= 1'b0;
    o_ccmp_valid <= 1'b0;
  end
  else begin
    o_rcmp_valid <= x1_rabs_rdy;
    o_ccmp_valid <= x1_cabs_rdy;
    o_c64_valid <= abs_c_32_rdy;
  end
end


//********************  debug  ********************//


generate
  for (i=0; i<4; i=i+1) begin
    assign debug_abs_32[i] = x1_c_32bit[i];
  end
  // if(i_switch == 1'b1) begin
  //   for (i=0; i<8; i=i+1) begin
  //     assign debug_abs_16[i] = x1_rdata[i];
  //   end
  // end
  // else begin
  //   for (i=0; i<8; i=i+1) begin
  //     assign debug_abs_16[i] = x1_cdata[i];
  //   end
  // end
endgenerate

endmodule