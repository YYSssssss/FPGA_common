//-----------------------------------------------------------------------------
// File: common_tb.sv
// Author: Jade Yu
// Created by : Jade Yu
// Abstract: abs with JPL
// Modification history:
// $Log$
//   yuyushan 7/25/2023 original
// Version: 1.0
// Copyright (C) 2023 Sensemi Crop.
// All right reserved
//-----------------------------------------------------------------------------

`timescale 1ns / 1ps
module commmon_tb;

/////////////////////////// parameter ////////////////////////////
parameter debug_fifo_data_gen_width = 16;
parameter abs_width = 16;
parameter READ_RAM_WIDTH = 128;
parameter SAMPLE_WIDTH   = 32;
parameter READ_DATA_NUM  = 1024;
parameter NUM  = 8;
parameter DATA_WIDTH  = 16;
parameter CNT_DATA = 1024-1; 
parameter PACKET_SELECT = 3;

localparam DELAY          = 2;
localparam INTERVAL       = 50;
localparam DATA_NUM       = 1024;
localparam INIT_ADDR      = 0;
localparam ADD_ADDR       = 1;
localparam END_ADDR       = 1024;

/////////////////////////// logic ////////////////////////////
//clk & rstn
logic rst_n;
logic clk_50m;
logic clk_75m;
logic clk_100m;
logic clk_150m;
logic clk_200m;
logic clk_250m;
logic clk_300m;
logic clk_400m;
logic clk_500m;
logic clk;




///////////////////////////////////////////////////////

initial begin
#0  
rst_n=0;
clk=0;
clk_50m=0;
clk_75m=0;
clk_100m=0;
clk_150m=0;
clk_200m=0;
clk_250m=0;
clk_300m=0;
clk_400m=0;
clk_500m=0;
#100 
rst_n=1;

// #5700
// #18000
#24000
$stop;

end

always #2.5  clk      = ~clk; // 200M
always #10   clk_50m  = ~clk_50m;  // 50M
always #6.67 clk_75m  = ~clk_75m;  // 75M
always #5    clk_100m = ~clk_100m; // 100M
always #3.33 clk_150m = ~clk_150m; // 150M
always #2.5  clk_200m = ~clk_200m; // 200M
always #2    clk_250m = ~clk_250m; // 250M
always #1.67 clk_300m = ~clk_300m; // 300M
always #1.25 clk_400m = ~clk_400m; // 400M
always #1    clk_500m = ~clk_500m; // 500M


 
//******************** chirp_processing_top ********************//
logic [128-1:0]                 o_m1_wr_data  ;
logic [32-1:0]                  o_m1_wr_addr ;
logic                           o_m1_wr_en    ;
logic                           o_m1_wr_wea   ;

logic [128-1:0]                 i_m0_rd_data  ;
logic [32-1:0]                  o_m0_rd_addr  ;
logic                           o_m0_rd_en   ;

logic [128-1:0]                 rd_data1  ;
logic [32-1:0]                  rd_addr1  ;
logic                           rd_en1   ;

logic [128-1:0]                 rd_ram_data;
logic                           rd_ram_valid;

// tpram_1024x128 gen_data (
//   .clka   (clk_200m),      // input wire clka
//   .ena    ('b0),      // input wire ena
//   .wea    ('b0),      // input wire [0 : 0] wea
//   .addra  ('b0),      // input wire [9 : 0] addra
//   .dina   ('d0      ),      // input wire [127 : 0] dina
//   .clkb   (clk_200m ),      // input wire clkb
//   .enb    (o_m0_rd_en),      // input wire enb
//   .addrb  (o_m0_rd_addr),      // input wire [9 : 0] addrb
//   .doutb  (i_m0_rd_data)       // output wire [127 : 0] doutb
// );

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (READ_RAM_WIDTH),
  .FILE_ADDR       (),//("D:/IC-DD/ChirpPreprocessing_s1/txt_file1/input_data.txt"),
  .cnt_data        (CNT_DATA),
  .packet_select   (PACKET_SELECT)
) u_save_file_cabs_data(
  .rst_n    (rst_n),
  .clk      (clk_200m),
  .valid    (o_m0_rd_en),
  .data     (i_m0_rd_data)
);

chirp_processing_core #(
  .DELAY   (2)
) u_chirp_processing_core(
  .rst_n                (rst_n),
  .hrst_n               (),
  .clk                  (clk_200m),
  .hclk                 (),
  .i_start              (1'b1),
  .o_finish             (),

  //config
  .i_is_real                (1'b0),
  .i_dc_est_cmp_cnt         ('d511),
  .i_dc_est_chp_cnt         ('d63),
  .i_dc_est_frm_cnt         ('d0),
  .i_dc_est_scale           ('d65536),
  .i_dc_config_mode         ('h00),
  .i_intf_est_scale         ('d80000),
  .i_intf_config_mode       ('h00),
  .i_combination_config_mode('h00),
  .i_phase_config_mode      ('h00),

  //DC_estimation
  .i_dc_u                 (),
  .o_dc_u                 (),

  //INTF_estimation
  .i_intf_cmp             (),
  .o_intf_cmp             (),

  .i_phase_w                ('h02000200),
  .i_phase_coe              (),
  .i_phase_ram_addra        (),
  .i_phase_ram_bwea         (),
  .i_phase_ram_ena          (),
  .i_phase_ram_dina         (),
  .o_phase_ram_douta        (),
  .i_phase_ram_wena         (),

  .i_data_formatter         ('d0),

  .o_m1_wr_data          (o_m1_wr_data),
  .o_m1_wr_addr          (o_m1_wr_addr),
  .o_m1_wr_en            (o_m1_wr_en  ),
  .o_m1_wr_wea           (o_m1_wr_wea ),
  .i_m0_rd_data          (i_m0_rd_data),
  .o_m0_rd_addr          (o_m0_rd_addr),
  .o_m0_rd_en            (o_m0_rd_en  )

//   .m_axi_rd             (m_axi_rd),
//   .m_axi_wr             (m_axi_wr)
);

save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       (),//("D:/IC-DD/ChirpPreprocessing_s1/txt_file1/XW.txt"),
  .cnt_data        (CNT_DATA),
  .packet_select   (PACKET_SELECT)
) u_mul_c_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (o_m1_wr_en),
  .data     (o_m1_wr_data)
);




// tpram_1024x128 wr_ram (
//   .clka   (clk_200m),      // input wire clka
//   .ena    (o_m1_wr_en),      // input wire ena
//   .wea    (o_m1_wr_wea),      // input wire [0 : 0] wea
//   .addra  (o_m1_wr_addr),      // input wire [9 : 0] addra
//   .dina   (o_m1_wr_data),      // input wire [127 : 0] dina
//   .clkb   (clk_200m ),      // input wire clkb
//   .enb    (rd_en1),      // input wire enb
//   .addrb  (rd_addr1),      // input wire [9 : 0] addrb
//   .doutb  (rd_data1)       // output wire [127 : 0] doutb
// );
cp_s1_read_ram #(
  .DELAY_DATA_ARRIVE    (DELAY        ),
  .READ_RAM_WIDTH       (READ_RAM_WIDTH),
  .SAMPLE_WIDTH         (SAMPLE_WIDTH  ),
  .RD_INTERVAL          (INTERVAL      ),
  .DATA_NUM             (DATA_NUM      ),
  .INIT_ADDR            (INIT_ADDR     ),
  .ADD_ADDR             (ADD_ADDR      ),
  .END_ADDR             (END_ADDR      )
)u_test_read_ram(
  .clk            (clk),
  .rst_n          (rst_n),
  .i_start        (1'b1),
  .i_m0_rd_data   (rd_data1),            
  .o_m0_rd_addr   (rd_addr1),
  .o_m0_rd_en     (rd_en1),
  .o_data         (rd_ram_data ),
  .o_data_valid   (rd_ram_valid),
  .o_data_last    ( )
);
save_file_tb #(
  .DELAY_VALID_NUM (1), 
  .DATA_WIDTH      (128),
  .FILE_ADDR       (),//("D:/IC-DD/ChirpPreprocessing_s1/txt_file1/wr_ram_data.txt"),
  .cnt_data        (CNT_DATA),
  .packet_select   (PACKET_SELECT)
) u_wr_ram_rd_data(
  .rst_n    (rst_n),
  .clk      (clk),
  .valid    (rd_ram_valid),
  .data     (rd_ram_data)
);


//******************** End_chirp_processing_top ********************//














//******************** phase_ram ********************//
parameter ADDRESS_NUM  = 1024;
logic [READ_RAM_WIDTH-1:0] mem[ADDRESS_NUM-1:0];
logic [ADDRESS_NUM-1:0] address;
logic [31:0] data1;
logic        data1_vld;

initial begin
    $readmemh("D:/IC-DD/ChirpPreprocessing_s1/txt_file1/phase_coe.txt", mem);
end

always@(posedge clk_200m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    data1 <= 128'b0;
    address <= 0;
    data1_vld <= 1'b0;
  end
  else begin
    if(address<ADDRESS_NUM)begin
      data1 <= mem[address];
      address <= address+1;
      data1_vld <= 1'b1;
    end
    else begin
        data1 <= data1;
        data1_vld <= 0;
    end
  end
end

//******************** End_phase_ram ********************//



//fsdbDump
// initial begin 
//     $fsdbDumpfile("tb_common_wave.fsdb");
//     $fsdbDumpvars(0,commmon_tb);
//     $fsdbDumpMDA();
// end

endmodule