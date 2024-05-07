`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/09/21 11:03:58
// Design Name: 
// Module Name: phase_generation
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


module rsp_s2_prep_phase_generation #(
    parameter RAM_DELAY          = 2,
    parameter RAM0_ADDR_WIDTH    = 11,
    parameter RAM1_ADDR_WIDTH    = 6,
    parameter RAM_DATA_WIDTH     = 64,
    parameter TWIDDLE_WIDTH      = 64,
    parameter DATA_NUM           = 1024,
    parameter ENTRY_NUM          = 32,
    parameter TWIDDLE_NUM        = 136
)(
  input                                           rst_n,
  input                                           hrst_n,
  input                                           clk,             //500Mram0_addra_d0
  input                                           hclk,            //100M
  
  input                                           i_start,
  input                                           i_data_valid,
  input                                           i_data_last,
              
  input                                           i_sel_16_32,
  input  [TWIDDLE_WIDTH-1:0]                      i_phase_w,
  input  [RAM_DATA_WIDTH-1:0]                     i_phase_coe,
  input  [RAM1_ADDR_WIDTH-1:0]                    i_phase_entry_select, //entry_select
              
  input  [RAM0_ADDR_WIDTH-1:0]                    i_phase_ram0_addra,
  input                                           i_phase_ram0_bwea,
  input                                           i_phase_ram0_ena,
  input  [RAM_DATA_WIDTH-1:0]                     i_phase_ram0_dina,
  output reg [RAM_DATA_WIDTH-1:0]                 o_phase_ram0_douta,
  input                                           i_phase_ram0_wena,
              
  input  [RAM1_ADDR_WIDTH-1:0]                    i_phase_ram1_addra,
  input                                           i_phase_ram1_bwea,
  input                                           i_phase_ram1_ena,
  input  [RAM_DATA_WIDTH/2-1:0]                   i_phase_ram1_dina,
  output [RAM_DATA_WIDTH/2-1:0]                   o_phase_ram1_douta,
  input                                           i_phase_ram1_wena,

  output reg [TWIDDLE_WIDTH-1:0]                  o_w [3:0],

  //debug
  output                                          debug_o_data_valid
);

//********************  parameter  ********************//
localparam DATA_NUM_WIDTH = $clog2(DATA_NUM);

//********************  reg & wire  ********************//
reg [TWIDDLE_WIDTH-1:0]                      s_phase_w [3:0];

reg [RAM1_ADDR_WIDTH-1:0]                    ram1_addra;
reg [RAM1_ADDR_WIDTH-1:0]                    s_ram1_addra;
wire [RAM_DATA_WIDTH/2-1:0]                   ram1_douta [3:0];
reg                                          ram1_ena;
reg [RAM_DATA_WIDTH/2-1:0]                   ram1_dina;
reg                                          ram1_wena;

reg [RAM_DATA_WIDTH-1:0]                   ram0_douta [3:0];

reg                                        start;
//debug

wire [3:0] s_debug_o_data_valid;


//********************  cnt  ********************//
reg [DATA_NUM_WIDTH:0]         cnt_wr_ram1;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_wr_ram1 <= {DATA_NUM_WIDTH{1'b0}};
  end
  else begin
    if(cnt_wr_ram1 == ENTRY_NUM - 1)
      cnt_wr_ram1 <= ENTRY_NUM - 1;
    else if(i_phase_ram1_wena)
      cnt_wr_ram1 <= cnt_wr_ram1 + 1'b1;
    else
      cnt_wr_ram1 <= cnt_wr_ram1;
  end
end

//******************** Indicative signal ********************//
//debug
delay #(8) delay_debug_o_data_valid(.clk(clk), .rst_n(rst_n), .din(i_data_valid), .dout(debug_o_data_valid));
//enddebug

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    ram1_addra <= {RAM1_ADDR_WIDTH{1'b0}};
    s_ram1_addra <= {RAM1_ADDR_WIDTH{1'b0}};
    ram1_dina  <= {RAM_DATA_WIDTH/2{1'b0}};
    ram1_ena   <= 1'b0;
    ram1_wena  <= 1'b0;
  end
  else begin
    if(i_phase_ram1_ena) begin
      ram1_addra <= ram1_addra + 1'b1;
      s_ram1_addra <= ram1_addra;
      ram1_dina  <= i_phase_ram1_dina;
      ram1_ena   <= i_phase_ram1_ena;
      ram1_wena  <= i_phase_ram1_wena;
    end
    else if(cnt_wr_ram1 == ENTRY_NUM - 1) begin
      ram1_addra <= i_phase_entry_select;
      s_ram1_addra <= i_phase_entry_select;
      ram1_ena   <= 1'b1;
      ram1_wena  <= 1'b0;
    end
    else begin

    end
  end
end

//******************** RAM ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    start <= 0;
  end
  else if(i_phase_ram1_ena) begin
    start <= 1;
  end
  else begin
    start <= 0;
  end
end

assign ram1_douta[0][31:16] = start ? 16'd0 : o_phase_ram1_douta[31:16];
assign ram1_douta[0][15:0]  = start ? 16'd0 : (i_sel_16_32==1'b1 ? o_phase_ram1_douta[15:0]<<1 : o_phase_ram1_douta[15:0] << 2);

assign ram1_douta[1][31:16] = start ? 16'd0 : o_phase_ram1_douta[31:16] + o_phase_ram1_douta[15:0];
assign ram1_douta[1][15:0]  = start ? 16'd0 : (i_sel_16_32==1'b1 ? o_phase_ram1_douta[15:0]<<1 : o_phase_ram1_douta[15:0] << 2);

assign ram1_douta[2][31:16] = start ? 16'd0 : (i_sel_16_32==1'b1 ? (o_phase_ram1_douta[31:16] + o_phase_ram1_douta[15:0]) : (o_phase_ram1_douta[31:16] + (o_phase_ram1_douta[15:0] << 1)));
assign ram1_douta[2][15:0]  = start ? 16'd0 : (i_sel_16_32==1'b1 ? o_phase_ram1_douta[15:0]<<1 : o_phase_ram1_douta[15:0] << 2);

assign ram1_douta[3][31:16] = start ? 16'd0 : (o_phase_ram1_douta[31:16] + (o_phase_ram1_douta[15:0] << 1) + o_phase_ram1_douta[15:0]);
assign ram1_douta[3][15:0]  = start ? 16'd0 : (i_sel_16_32==1'b1 ? o_phase_ram1_douta[15:0]<<1 : o_phase_ram1_douta[15:0] << 2);


genvar i;
generate
for (i=0; i<4; i=i+1) begin
  rsp_s2_prep_pg_select_ram_data #(
      .RAM_DELAY          (RAM_DELAY      ),
      .RAM0_ADDR_WIDTH    (RAM0_ADDR_WIDTH),
      .RAM1_ADDR_WIDTH    (RAM1_ADDR_WIDTH),
      .RAM_DATA_WIDTH     (RAM_DATA_WIDTH ),
      .TWIDDLE_WIDTH      (TWIDDLE_WIDTH  ),
      .DATA_NUM           (DATA_NUM       ),
      .TWIDDLE_NUM        (TWIDDLE_NUM    )
  ) u_pg_select_ram_data(
    .rst_n                        (rst_n),
    .hrst_n                       (),
    .clk                          (clk),
    .hclk                         (),
    .i_start                      (i_start),
    .i_data_valid                 (i_data_valid),
    .i_data_last                  (i_data_last),
    .i_phase_w                    (i_phase_w),
    .i_phase_coe                  (i_phase_coe),
    .i_phase_entry_select         (i_phase_entry_select),
    .i_phase_ram0_addra           (i_phase_ram0_addra  ),
    .i_phase_ram0_bwea            (i_phase_ram0_bwea   ),
    .i_phase_ram0_ena             (i_phase_ram0_ena    ),
    .i_phase_ram0_dina            (i_phase_ram0_dina   ),
    .o_phase_ram0_douta           (ram0_douta[i]),
    .i_phase_ram0_wena            (i_phase_ram0_wena   ),
    .i_phase_ram1_douta           (ram1_douta[i]),
    .s_phase_w                    (s_phase_w[i])
  );
end
endgenerate

spram #(
  .TYPE        ("RAM"),
  .VT          ("SVT"),
  .UHD         (),
  .CM          ("4"),
  .SEG         ("S"),
  .DATA_DEPTH  (32),
  .DATA_WIDTH  (32),
  .RD_DELAY    (),
  .ADDR_WIDTH  ()
) u_ram_entry(
  .addra    (s_ram1_addra[4:0]),//(i_phase_ram1_addra),
  .bwea     ({2{16'hFFFF}}),
  .ena      (ram1_ena     ),
  .clka     (clk),
  .dina     (ram1_dina    ),//(i_phase_ram1_dina),
  .douta    (o_phase_ram1_douta),
  .wena     (ram1_wena    ),//(i_phase_ram1_wena),
  .RTSEL    (2'b01),
  .WTSEL    (2'b00)
);


//******************** output ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_phase_ram0_douta <= {RAM_DATA_WIDTH{1'b0}};
  end
  else begin
    o_phase_ram0_douta <= ram0_douta[0];
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    o_w[0] <= {64{1'b0}};
    o_w[1] <= {64{1'b0}};
    o_w[2] <= {64{1'b0}};
    o_w[3] <= {64{1'b0}};
  end
  else begin
    o_w[0] <= s_phase_w[0];
    o_w[1] <= s_phase_w[1];
    o_w[2] <= s_phase_w[2];
    o_w[3] <= s_phase_w[3];
  end
end



endmodule
