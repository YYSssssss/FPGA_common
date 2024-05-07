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


module rsp_s2_prep_pg_select_ram_data #(
    parameter RAM_DELAY          = 2,
    parameter RAM0_ADDR_WIDTH    = 11,
    parameter RAM1_ADDR_WIDTH    = 6,
    parameter RAM_DATA_WIDTH     = 64,
    parameter TWIDDLE_WIDTH      = 64,
    parameter DATA_NUM           = 1024,
    parameter TWIDDLE_NUM        = 136
)(
  input                                           rst_n,
  input                                           hrst_n,
  input                                           clk,             //500Mram0_addra_d0
  input                                           hclk,            //100M
              
  input                                           i_start,
  input                                           i_data_valid,
  input                                           i_data_last,
              
  input  [TWIDDLE_WIDTH-1:0]                      i_phase_w,
  input  [RAM_DATA_WIDTH-1:0]                     i_phase_coe,
  input  [RAM1_ADDR_WIDTH-1:0]                    i_phase_entry_select, //entry_select
              
  input  [RAM0_ADDR_WIDTH-1:0]                    i_phase_ram0_addra,
  input                                           i_phase_ram0_bwea,
  input                                           i_phase_ram0_ena,
  input  [RAM_DATA_WIDTH-1:0]                     i_phase_ram0_dina,
  output [RAM_DATA_WIDTH-1:0]                     o_phase_ram0_douta,
  input                                           i_phase_ram0_wena,
              
  input [RAM_DATA_WIDTH/2-1:0]                    i_phase_ram1_douta,

  output reg [TWIDDLE_WIDTH-1:0]                  s_phase_w
);

//********************  parameter  ********************//
localparam DATA_NUM_WIDTH = $clog2(DATA_NUM);

//********************  reg & wire  ********************//

reg [RAM0_ADDR_WIDTH-1:0]                    ram0_addra;
reg [RAM0_ADDR_WIDTH-1:0]                    s_ram0_addra;
reg [RAM0_ADDR_WIDTH-2:0]                    ram0_addra_d0;
reg                                          ram0_ena;
reg [RAM_DATA_WIDTH-1:0]                     ram0_dina;
reg [RAM_DATA_WIDTH-1:0]                     ram0_douta;
reg                                          ram0_wena;

reg                                          semecircle0;
reg [RAM0_ADDR_WIDTH-2:0]                    semecircle0_addr;
reg                                          semecircle1;
reg [RAM0_ADDR_WIDTH-2:0]                    semecircle1_addr;
reg                                          quadrant0;
reg [RAM0_ADDR_WIDTH-2:0]                    quadrant0_addr;
reg                                          quadrant1;
reg [RAM0_ADDR_WIDTH-2:0]                    quadrant1_addr;
reg                                          quadrant2;
reg [RAM0_ADDR_WIDTH-2:0]                    quadrant2_addr;
reg                                          quadrant3;
reg [RAM0_ADDR_WIDTH-2:0]                    quadrant3_addr;
reg                                          region0;
reg                                          s_region0;
reg [RAM0_ADDR_WIDTH-2:0]                    region0_addr;
reg                                          region1;
reg                                          s_region1;
reg [RAM0_ADDR_WIDTH-2:0]                    region1_addr;
reg                                          region2;
reg                                          s_region2;
reg [RAM0_ADDR_WIDTH-2:0]                    region2_addr;
reg                                          region3;
reg                                          s_region3;
reg [RAM0_ADDR_WIDTH-2:0]                    region3_addr;
reg                                          region4;
reg                                          s_region4;
reg [RAM0_ADDR_WIDTH-2:0]                    region4_addr;
reg                                          region5;
reg                                          s_region5;
reg [RAM0_ADDR_WIDTH-2:0]                    region5_addr;
reg                                          region6;
reg                                          s_region6;
reg [RAM0_ADDR_WIDTH-2:0]                    region6_addr;
reg                                          region7;
reg                                          s_region7;
reg [RAM0_ADDR_WIDTH-2:0]                    region7_addr;
reg [RAM0_ADDR_WIDTH-1:0]                    ram0_addra_d1;

reg                                          s0_data_valid;
//********************  cnt  ********************//
reg [DATA_NUM_WIDTH:0]         cnt_valid;
reg [DATA_NUM_WIDTH:0]         cnt_wr_ram0;

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_valid <= {DATA_NUM_WIDTH{1'b0}};
  end
  else begin
    if(cnt_valid == DATA_NUM-1)
      cnt_valid <= {DATA_NUM_WIDTH{1'b0}};
    else if(i_data_valid)
      cnt_valid <= cnt_valid + 1'b1;
    else
      cnt_valid <= cnt_valid;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    cnt_wr_ram0 <= {DATA_NUM_WIDTH{1'b0}};
  end
  else begin
    if(cnt_wr_ram0 == TWIDDLE_NUM - 1)
      cnt_wr_ram0 <= TWIDDLE_NUM - 1;
    else if(i_phase_ram0_wena)
      cnt_wr_ram0 <= cnt_wr_ram0 + 1'b1;
    else
      cnt_wr_ram0 <= cnt_wr_ram0;
  end
end

//******************** Indicative signal ********************//

delay #(4) delay_i_x0_valid(.clk(clk), .rst_n(rst_n), .din(i_data_valid), .dout(s0_data_valid));
delay #(4) delay_i_data_last(.clk(clk), .rst_n(rst_n), .din(i_data_last), .dout(s0_data_last));
delay #(3) delay_region0(.clk(clk), .rst_n(rst_n), .din(region0), .dout(s_region0));
delay #(3) delay_region1(.clk(clk), .rst_n(rst_n), .din(region1), .dout(s_region1));
delay #(3) delay_region2(.clk(clk), .rst_n(rst_n), .din(region2), .dout(s_region2));
delay #(3) delay_region3(.clk(clk), .rst_n(rst_n), .din(region3), .dout(s_region3));
delay #(3) delay_region4(.clk(clk), .rst_n(rst_n), .din(region4), .dout(s_region4));
delay #(3) delay_region5(.clk(clk), .rst_n(rst_n), .din(region5), .dout(s_region5));
delay #(3) delay_region6(.clk(clk), .rst_n(rst_n), .din(region6), .dout(s_region6));
delay #(3) delay_region7(.clk(clk), .rst_n(rst_n), .din(region7), .dout(s_region7));

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    ram0_addra_d0 <= {RAM0_ADDR_WIDTH{1'b0}};
  end
  else if(i_start)
    ram0_addra_d0 <= i_phase_ram1_douta[31:16];
  else if(s0_data_last)
    ram0_addra_d0 <= {RAM0_ADDR_WIDTH{1'b0}}; //k(n-1) + k
  else if(i_data_valid)
    ram0_addra_d0 <= ram0_addra_d0 + i_phase_ram1_douta[9:0]; //k(n-1) + k
  else
    ram0_addra_d0 <= ram0_addra_d0;
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    semecircle0_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    semecircle0      <= 1'b0;
    semecircle1_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    semecircle1      <= 1'b0;
  end
  else if(ram0_addra_d0 > 10'd512) begin
    semecircle1      <= 1'b1;
    semecircle1_addr <= ram0_addra_d0;
    semecircle0      <= 1'b0;
  end
  else begin
    semecircle0      <= 1'b1;
    semecircle0_addr <= ram0_addra_d0;
    semecircle1      <= 1'b0;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    quadrant0      <= 1'b0;
    quadrant0_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    quadrant1      <= 1'b0;
    quadrant1_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    quadrant2      <= 1'b0;
    quadrant2_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    quadrant3      <= 1'b0;
    quadrant3_addr <= {RAM0_ADDR_WIDTH{1'b0}};
  end
  else if(semecircle0 == 1'b1) begin
    if(semecircle0_addr > 10'd256) begin
        quadrant1      <= 1'b1;
        quadrant1_addr <= semecircle0_addr;
        quadrant0      <= 1'b0;
        quadrant2      <= 1'b0;
        quadrant3      <= 1'b0;
    end
    else begin
        quadrant0      <= 1'b1;
        quadrant0_addr <= semecircle0_addr;
        quadrant1      <= 1'b0;
        quadrant2      <= 1'b0;
        quadrant3      <= 1'b0;
    end
  end
  else if(semecircle1 == 1'b1) begin
    if(semecircle1_addr > 10'd768) begin
        quadrant3      <= 1'b1;
        quadrant3_addr <= semecircle1_addr;
        quadrant2      <= 1'b0;
        quadrant0      <= 1'b0;
        quadrant1      <= 1'b0;
    end
    else begin
        quadrant2      <= 1'b1;
        quadrant2_addr <= semecircle1_addr;
        quadrant3      <= 1'b0;
        quadrant0      <= 1'b0;
        quadrant1      <= 1'b0;
    end
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    region0      <= 1'b0;
    region0_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    region1      <= 1'b0;
    region1_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    region2      <= 1'b0;
    region2_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    region3      <= 1'b0;
    region3_addr <= {RAM0_ADDR_WIDTH{1'b0}};
  end
  else if(quadrant0 == 1'b1) begin
    if(quadrant0_addr > 10'd128) begin
        region1      <= 1'b1;
        region1_addr <= quadrant0_addr;
        region0      <= 1'b0;
        region2  <= 1'b0;
        region3  <= 1'b0;
    end
    else begin
        region0      <= 1'b1;
        region0_addr <= quadrant0_addr;
        region1      <= 1'b0;
        region2  <= 1'b0;
        region3  <= 1'b0;
    end
  end
  else if(quadrant1 == 1'b1) begin
    if(quadrant1_addr > 10'd384) begin
        region3      <= 1'b1;
        region3_addr <= quadrant1_addr;
        region0  <= 1'b0;
        region1  <= 1'b0;
        region2      <= 1'b0;
    end
    else begin
        region2      <= 1'b1;
        region2_addr <= quadrant1_addr;
        region0  <= 1'b0;
        region1  <= 1'b0;
        region3      <= 1'b0;
    end
  end
  else begin
    region0  <= 1'b0;
    region1  <= 1'b0;
    region2  <= 1'b0;
    region3  <= 1'b0;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    region4      <= 1'b0;
    region4_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    region5      <= 1'b0;
    region5_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    region6      <= 1'b0;
    region6_addr <= {RAM0_ADDR_WIDTH{1'b0}};
    region7      <= 1'b0;
    region7_addr <= {RAM0_ADDR_WIDTH{1'b0}};
  end
  else if(quadrant2 == 1'b1) begin
    if(quadrant2_addr > 10'd640) begin
        region5      <= 1'b1;
        region5_addr <= quadrant2_addr;
        region4      <= 1'b0;
        region6  <= 1'b0;
        region7  <= 1'b0;
    end
    else begin
        region4      <= 1'b1;
        region4_addr <= quadrant2_addr;
        region5      <= 1'b0;
        region6  <= 1'b0;
        region7  <= 1'b0;
    end
  end
  else if(quadrant3 == 1'b1) begin
    if(quadrant3_addr > 10'd896) begin
        region7      <= 1'b1;
        region7_addr <= quadrant3_addr;
        region6      <= 1'b0;
        region4  <= 1'b0;
        region5  <= 1'b0;
    end
    else begin
        region6      <= 1'b1;
        region6_addr <= quadrant3_addr;
        region7      <= 1'b0;
        region4  <= 1'b0;
        region5  <= 1'b0;
    end
  end
  else begin
    region4  <= 1'b0;
    region5  <= 1'b0;
    region6  <= 1'b0;
    region7  <= 1'b0;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    ram0_addra_d1 <= {RAM0_ADDR_WIDTH{1'b0}};
  end
  else if(region0 == 1'b1) begin
    ram0_addra_d1 <= region0_addr;
  end
  else if(region1 == 1'b1) begin
    ram0_addra_d1 <= 10'd256 - region1_addr;
  end
  else if(region2 == 1'b1) begin
    ram0_addra_d1 <= region2_addr - 10'd256;
  end
  else if(region3 == 1'b1) begin
    ram0_addra_d1 <= 10'd512 - region3_addr;
  end
  else if(region4 == 1'b1) begin
    ram0_addra_d1 <= region4_addr - 10'd512;
  end
  else if(region5 == 1'b1) begin
    ram0_addra_d1 <= 10'd768 - region5_addr;
  end
  else if(region6 == 1'b1) begin
    ram0_addra_d1 <= region6_addr - 10'd768;
  end
  else if(region7 == 1'b1) begin
    ram0_addra_d1 <= 11'd1024 - region7_addr;
  end
  else begin
    ram0_addra_d1 <= ram0_addra_d1;
  end
end

always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    ram0_addra <= {RAM0_ADDR_WIDTH{1'b0}};
    s_ram0_addra <= {RAM0_ADDR_WIDTH{1'b0}};
    ram0_ena   <= 1'b1;
    ram0_douta <= {RAM_DATA_WIDTH{1'b0}};
    ram0_wena  <= 1'b1;
    ram0_dina  <= {RAM_DATA_WIDTH{1'b0}};
  end
  else begin
    if(cnt_wr_ram0 < TWIDDLE_NUM - 1 && i_phase_ram0_ena) begin
      ram0_addra   <= ram0_addra + 1'b1;
      s_ram0_addra <= ram0_addra;
      ram0_dina  <= i_phase_ram0_dina;
      ram0_ena   <= i_phase_ram0_ena;
      ram0_wena  <= i_phase_ram0_wena;
    end
    else if(cnt_wr_ram0 == TWIDDLE_NUM - 1) begin //need adjust delay_i_x0_valid
      ram0_addra <= ram0_addra_d1;//
      s_ram0_addra <= ram0_addra_d1;
      ram0_ena   <= 1'b1;
      ram0_wena  <= 1'b0;
    end
    else begin

    end
  end
end

//******************** RAM ********************//
spram_136x64 
//#(
//  .TYPE        ("RAM"),
//  .VT          ("SVT"),
//  .UHD         (),
//  .CM          ("2"),
//  .SEG         ("S"),
//  .DATA_DEPTH  (136),
//  .DATA_WIDTH  (64),
//  .RD_DELAY    (),
//  .ADDR_WIDTH  ()
//) 
u_ram0(
  .addra    (s_ram0_addra[7:0]),
  .bwea     ({4{16'hFFFF}}),
  .ena      (ram0_ena),  
  .clka     (clk),
  .dina     (ram0_dina),
  .douta    (o_phase_ram0_douta),
  .wena     (ram0_wena),
  .RTSEL    (2'b01),
  .WTSEL    (2'b00)
);

//******************** s_phase_w ********************//
always @(posedge clk or negedge rst_n) begin
  if (!rst_n) begin
    s_phase_w <= {TWIDDLE_WIDTH{1'b0}};
  end
  else if(s_region0 == 1'b1) begin
    s_phase_w <= o_phase_ram0_douta;
  end
  else if(s_region1 == 1'b1) begin
    s_phase_w[63:32] <= ~o_phase_ram0_douta[31:0] + 1;
    s_phase_w[31:0] <= ~o_phase_ram0_douta[63:32] + 1;
  end
  else if(s_region2 == 1'b1) begin
    s_phase_w[63:32] <= ~o_phase_ram0_douta[31:0] + 1;
    s_phase_w[31:0] <= o_phase_ram0_douta[63:32];
  end
  else if(s_region3 == 1'b1) begin
    s_phase_w[63:32] <= o_phase_ram0_douta[63:32];
    s_phase_w[31:0] <= ~o_phase_ram0_douta[31:0] + 1;
  end
  else if(s_region4 == 1'b1) begin
    s_phase_w[63:32] <= ~o_phase_ram0_douta[63:32] + 1;
    s_phase_w[31:0] <= ~o_phase_ram0_douta[31:0] + 1;
  end
  else if(s_region5 == 1'b1) begin
    s_phase_w[63:32] <= o_phase_ram0_douta[31:0];
    s_phase_w[31:0] <= o_phase_ram0_douta[63:32];
  end
  else if(s_region6 == 1'b1) begin
    s_phase_w[63:32] <= o_phase_ram0_douta[31:0];
    s_phase_w[31:0] <= ~o_phase_ram0_douta[63:32] + 1;
  end
  else if(s_region7 == 1'b1) begin
    s_phase_w[63:32] <= ~o_phase_ram0_douta[63:32] + 1;
    s_phase_w[31:0] <= o_phase_ram0_douta[31:0];
  end
  else begin
    
  end
end


endmodule
