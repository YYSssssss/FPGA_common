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
//`include "rsp_s1_prep_define.svh"
//`include "rsp_s1_prep_op_info.svh"

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
logic start;
logic finish;
logic mem_req;
logic mem_req_ack;
logic done;
logic done_ack;



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

#25000
$stop;

end

always #1  clk      = ~clk; // 200M
always #10   clk_50m  = ~clk_50m;  // 50M
always #6.67 clk_75m  = ~clk_75m;  // 75M
always #5    clk_100m = ~clk_100m; // 100M
always #3.33 clk_150m = ~clk_150m; // 150M
always #2.5  clk_200m = ~clk_200m; // 200M
always #2    clk_250m = ~clk_250m; // 250M
always #1.67 clk_300m = ~clk_300m; // 300M
always #1.25 clk_400m = ~clk_400m; // 400M
always #1    clk_500m = ~clk_500m; // 500M

always @(posedge clk or negedge rst_n) begin
  if(rst_n == 1'b0)begin
    start <= 0;
  end
  else begin
    if(address == 'd130)
      start <= 1;
    else if(finish || o_finish)
      start <= 1;
    else
      start <= 0;
  end
end
 
//******************** chirp_processing_top ********************//
logic [128-1:0]                 o_m1_wr_data  ;
logic [32-1:0]                  o_m1_wr_addr ;
logic                           o_m1_wr_en    ;
logic                           o_m1_wr_wea   ;

logic [128-1:0]                 i_m0_rd_data  ;
logic [128-1:0]                 s_m0_rd_data  ;
logic [32-1:0]                  o_m0_rd_addr  ;
logic                           o_m0_rd_en   ;

logic [128-1:0]                 rd_data1  ;
logic [32-1:0]                  rd_addr1  ;
logic                           rd_en1   ;

logic [128-1:0]                 rd_ram_data;
logic                           rd_ram_valid;

tpram_1024x128 gen_data (
  .clka   (clk_500m),      // input wire clka
  .ena    ('b0),      // input wire ena
  .wea    ('b0),      // input wire [0 : 0] wea
  .addra  ('b0),      // input wire [9 : 0] addra
  .dina   ('d0      ),      // input wire [127 : 0] dina
  .clkb   (clk_500m ),      // input wire clkb
  .enb    (o_m0_rd_en),      // input wire enb
  .addrb  (o_m0_rd_addr),      // input wire [9 : 0] addrb
  .doutb  (s_m0_rd_data)       // output wire [127 : 0] doutb
);

rsp_s1_prep_delay_data #(
  .DEPTH      (3),
  .DATA_WIDTH (READ_RAM_WIDTH)
) u_delay_t8(
  .clk   (clk_500m  ),
  .rst_n (rst_n),
  .i_x0  (s_m0_rd_data ),
  .o_y0  (i_m0_rd_data )
);

// save_file_tb #(
//   .DELAY_VALID_NUM (1), 
//   .DATA_WIDTH      (READ_RAM_WIDTH),
//   .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/input_data.txt"),
//   .cnt_data        (CNT_DATA),
//   .packet_select   (PACKET_SELECT)
// ) u_save_file_cabs_data(
//   .rst_n    (rst_n),
//   .clk      (clk_500m),
//   .valid    (o_m0_rd_en),
//   .data     (i_m0_rd_data)
// );

rsp_s1_prep_core #(
  .DELAY   (2)
) u_rsp_s1_prep_core(
  .rst_n                (rst_n),
  .hrst_n               (),
  .clk                  (clk_500m),
  .hclk                 (),
  .i_start              (start),
  .o_finish             (finish),

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

  //DC_estimation
  // .i_dc_u                 ({16'd538,16'd538}),
  .i_dc_u                 ({16'd118,16'd420}),//complex
  .o_dc_u                 (),

  //INTF_estimation
  // .i_intf_cmp             (16'd657),
  .i_intf_cmp             (32'd657),//complex
  .o_intf_cmp             (),

  //phase_gen: AHB to RAM
  .i_phase_entry_select     ('h10),
  .i_phase_w                ('h02000200),
  .i_phase_coe              (),
  
  .i_phase_ram0_addra       (s_addr),
  .i_phase_ram0_bwea        (),
  .i_phase_ram0_ena         (data1_vld),
  .i_phase_ram0_dina        (data1),
  .o_phase_ram0_douta       (),
  .i_phase_ram0_wena        (data1_vld),

  .i_phase_ram1_addra       (s_addr2),
  .i_phase_ram1_bwea        (),
  .i_phase_ram1_ena         (data2_vld),
  .i_phase_ram1_dina        (data2),
  .o_phase_ram1_douta       (),
  .i_phase_ram1_wena        (data2_vld), 

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
  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/XW.txt"),
  .cnt_data        (CNT_DATA),
  .packet_select   (PACKET_SELECT)
) u_XW(
  .rst_n    (rst_n),
  .clk      (clk_500m),
  .valid    (o_m1_wr_en),
  .data     (o_m1_wr_data)
);



tpram_1024x128 wr_ram (
  .clka   (clk_500m),      // input wire clka
  .ena    (o_m1_wr_en),      // input wire ena
  .wea    (o_m1_wr_wea),      // input wire [0 : 0] wea
  .addra  (o_m1_wr_addr),      // input wire [9 : 0] addra
  .dina   (o_m1_wr_data),      // input wire [127 : 0] dina
  .clkb   (clk_500m ),      // input wire clkb
  .enb    (rd_en1),      // input wire enb
  .addrb  (rd_addr1),      // input wire [9 : 0] addrb
  .doutb  (rd_data1)       // output wire [127 : 0] doutb
);
rsp_s1_prep_read_ram #(
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
//save_file_tb #(
//  .DELAY_VALID_NUM (1), 
//  .DATA_WIDTH      (128),
//  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/wr_ram_data.txt"),
//  .cnt_data        (CNT_DATA),
//  .packet_select   (PACKET_SELECT)
//) u_wr_ram_rd_data(
//  .rst_n    (rst_n),
//  .clk      (clk),
//  .valid    (rd_ram_valid),
//  .data     (rd_ram_data)
//);


//******************** End_chirp_processing_top ********************//


//******************** wrapper ********************//
// ahb_if_cfg #(.AHB_WDW(32), .AHB_RDW(32), .AHB_AW(32)) ahb_if_cfg();
//logic [`RSP_S1_PREP_DATA_WIDTH-1:0]    i_m0_rd_data_A;
//logic                         o_m0_rd_en_A;
//logic [`RSP_S1_PREP_ADDR_WIDTH-1:0]    o_m0_rd_addr_A;

//logic [`RSP_S1_PREP_STRB_WIDTH-1:0]    o_m1_wea_A;
//logic [`RSP_S1_PREP_DATA_WIDTH-1:0]    o_m1_wr_data_A;
//logic                         o_m1_wr_en_A;
//logic [`RSP_S1_PREP_ADDR_WIDTH-1:0]    o_m1_wr_addr_A;

logic                         o_finish;

always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    mem_req_ack <= 0;
  end
  else begin
    if(mem_req)
      mem_req_ack <= 1;
    else
      mem_req_ack <= 0;
  end
end
always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    done_ack <= 0;
  end
  else begin
    if(done)
      done_ack <= 1;
    else
      done_ack <= 0;
  end
end

tpram_1024x128 wrapper_rd (
  .clka   (clk_500m),      // input wire clka
  .ena    ('b0),      // input wire ena
  .wea    ('b0),      // input wire [0 : 0] wea
  .addra  ('b0),      // input wire [9 : 0] addra
  .dina   ('d0      ),      // input wire [127 : 0] dina
  .clkb   (clk_500m ),      // input wire clkb
  .enb    (o_m0_rd_en_A),    // input wire enb
  .addrb  (o_m0_rd_addr_A),      // input wire [9 : 0] addrb
  .doutb  (i_m0_rd_data_A)     // output wire [127 : 0] doutb
);
// chirp_processing_s1_wrapper u_chirp_processing_s1_wrapper(
//   .rst_n               (rst_n),
//   .clk                 (clk_500m),

//   .i_cmd_valid         (start),
//   .i_cmd_info          (),
//   .o_cmd_ack           (),

//   .i_start             (start),
//   .i_start_info        (),
//   .o_start_ack         (),
  
//   .o_finish            (o_finish),
//   .o_finish_info       (),
//   .i_finish_ack        (),
  
//   .i_init              (),
//   .i_reset             (),
//   .i_stop              (),
//   .i_rerun             (),
  
//   // .ahb_cfg             (),
//   .hclk                (clk_500m),
//   .hreset              (rst_n),
  
//   .o_mem_req           (mem_req),
//   .o_mem_bm            (),
//   .i_mem_ack           (mem_req_ack),
  
//   .i_m0_rd_data_A      (i_m0_rd_data_A),
//   .o_m0_rd_en_A        (o_m0_rd_en_A  ),
//   .o_m0_rd_addr_A      (o_m0_rd_addr_A),
  
//   .i_m0_rd_data_B      (),
//   .o_m0_rd_en_B        (),
//   .o_m0_rd_addr_B      (),
  
//   .o_m1_wea_A          (o_m1_wea_A    ),
//   .o_m1_wr_data_A      (o_m1_wr_data_A),
//   .o_m1_wr_en_A        (o_m1_wr_en_A  ),
//   .o_m1_wr_addr_A      (o_m1_wr_addr_A),
  
//   .o_m1_wea_B          (),
//   .o_m1_wr_data_B      (),
//   .o_m1_wr_en_B        (),
//   .o_m1_wr_addr_B      (),
  
//   .o_status            (),
//   .o_irq               ()    
// );
tpram_1024x128 wrapper_wr (
  .clka   (clk_500m),      // input wire clka
  .ena    (o_m1_wr_en_A),      // input wire ena
  .wea    (o_m1_wea_A),      // input wire [0 : 0] wea
  .addra  (o_m1_wr_addr_A),      // input wire [9 : 0] addra
  .dina   (o_m1_wr_data_A),      // input wire [127 : 0] dina
  .clkb   (clk_500m ),      // input wire clkb
  .enb    (),//(mem_intf.enb),      // input wire enb
  .addrb  (),//(mem_intf.addrb),      // input wire [9 : 0] addrb
  .doutb  ()//(mem_intf.dina)       // output wire [127 : 0] doutb
);

//save_file_tb #(
//  .DELAY_VALID_NUM (1), 
//  .DATA_WIDTH      (128),
//  .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/XW.txt"),
//  .cnt_data        (CNT_DATA),
//  .packet_select   (PACKET_SELECT)
//) u_mul_c_data(
//  .rst_n    (rst_n),
//  .clk      (clk_500m),
//  .valid    (o_m1_wr_en_A),
//  .data     (o_m1_wr_data_A)
//);
// save_file_tb #(
//   .DELAY_VALID_NUM (1), 
//   .DATA_WIDTH      (128),
//   .FILE_ADDR       ("D:/yuganwei/rsp_s1_prep/txt_file1/wr_ram_data.txt"),
//   .cnt_data        (CNT_DATA),
//   .packet_select   (PACKET_SELECT)
// ) u_wr_ram_rd_data(
//   .rst_n    (rst_n),
//   .clk      (clk_500m),
//   .valid    (o_m1_wea_A[0]),
//   .data     (o_m1_wr_data_A)
// );

//******************** end_wrapper ********************//









//******************** phase_ram ********************//
parameter ADDRESS_NUM  = 1024;
localparam ADDRESS_WIDTH = 32;
logic [READ_RAM_WIDTH-1:0] mem_1024x64[ADDRESS_NUM-1:0];
logic [READ_RAM_WIDTH-1:0] mem_32x32[ADDRESS_NUM-1:0];
logic [ADDRESS_WIDTH-1:0] address;
logic [ADDRESS_WIDTH-1:0] s_addr;
logic [ADDRESS_WIDTH-1:0] address2;
logic [ADDRESS_WIDTH-1:0] s_addr2;
logic [63:0] data1;
logic [31:0] data2;
logic        data1_vld;
logic        data2_vld;

initial begin
    $readmemh("D:/yuganwei/rsp_s1_prep/twiddle/twiddle_1024x64.txt", mem_1024x64);
end
initial begin
    $readmemh("D:/yuganwei/rsp_s1_prep/twiddle/twiddle_32x32.txt", mem_32x32);
end

always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    data1 <= 128'b0;
    address <= 0;
    data1_vld <= 1'b0;
  end
  else begin
    if(address == 'd130)
      address <= address + 1'b1;
    else if(address < 'd130)begin
      data1 <= mem_1024x64[address];
      address <= address+1;
      data1_vld <= 1'b1;
    end
    else begin
        data1 <= data1;
        data1_vld <= 0;
    end
  end
end
assign s_addr = address - 1;

always@(posedge clk_500m or negedge rst_n)begin
  if(rst_n == 1'b0)begin
    data1 <= 128'b0;
    address2 <= 0;
    data1_vld <= 1'b0;
  end
  else begin
    if(address2 < 'd32)begin
      data2 <= mem_32x32[address];
      address2 <= address2 + 1;
      data2_vld <= 1'b1;
    end
    else begin
        data2 <= data2;
        data2_vld <= 0;
    end
  end
end
assign s_addr2 = address2 - 1;

//******************** End_phase_ram ********************//



//fsdbDump
// initial begin 
//     $fsdbDumpfile("tb_common_wave.fsdb");
//     $fsdbDumpvars(0,commmon_tb);
//     $fsdbDumpMDA();
// end

endmodule