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
parameter txt_input = "/home/ssm/Desktop/yys/sim/rs_sim/design/";


/////////////////////////// logic ////////////////////////////
//clk & rstn
logic rst_n;
logic clk_12p5m;
logic clk_25m;
logic clk_50m;
logic clk_60m;
logic clk_75m;
logic clk_100m;
logic clk_150m;
logic clk_200m;
logic clk_250m;
logic clk_300m;
logic clk_400m;
logic clk_500m;
logic clk;

logic [7:0] encoder_input_tdata             ;
logic       encoder_input_tvalid            ;
logic       encoder_input_tready            ;
logic       encoder_input_tlast             ;
logic [7:0] encoder_output_tdata            ;
logic       encoder_output_tvalid           ;
logic       encoder_output_tlast            ;
logic       encoder_s_input_tlast_missing   ;
logic       encoder_s_input_tlast_unexpected;

logic [7:0] decoder_input_tdata             ;
logic       decoder_input_tvalid            ;
logic       decoder_input_tlast             ;
logic       decoder_input_tready            ;
logic [7:0] decoder_output_tdata            ;
logic       decoder_output_tvalid           ;
logic       decoder_output_tready           ;
logic       decoder_output_tlast            ;
logic [7:0] decoder_stat_tdata              ;
logic       decoder_stat_tvalid             ;
logic       decoder_stat_tready             ;
logic       decoder_s_input_tlast_missing   ;
logic       decoder_s_input_tlast_unexpected;
logic       decoder_s_ctrl_tdata_invalid    ;

///////////////////////////////////////////////////////

initial begin
#0  
rst_n=0;
clk=0;
clk_12p5m=0;
clk_50m=0;
clk_60m=0;
clk_75m=0;
clk_100m=0;
clk_150m=0;
clk_200m=0;
clk_250m=0;
clk_300m=0;
clk_400m=0;
clk_500m=0;

#100
rst_n = 1;


#25000
// $stop;
$finish;
end

always #1    clk        = ~clk;        // 200M
always #40   clk_12p5m  = ~clk_12p5m;  // 12.5M
always #10   clk_50m    = ~clk_50m;    // 50M
always #8.33 clk_60m    = ~clk_60m;    // 50M
always #6.67 clk_75m    = ~clk_75m;    // 75M
always #5    clk_100m   = ~clk_100m;   // 100M
always #3.33 clk_150m   = ~clk_150m;   // 150M
always #2.5  clk_200m   = ~clk_200m;   // 200M
always #2    clk_250m   = ~clk_250m;   // 250M
always #1.67 clk_300m   = ~clk_300m;   // 300M
always #1.25 clk_400m   = ~clk_400m;   // 400M
always #1    clk_500m   = ~clk_500m;   // 500M


//******************** rs_encode ********************//

rs_encoder_0 u_rs_encoder_0 (
  .aclk                             (clk_60m                         ), // input wire aclk
  .s_axis_input_tdata               (encoder_input_tdata             ), // input wire [7 : 0] s_axis_input_tdata
  .s_axis_input_tvalid              (encoder_input_tvalid            ), // input wire s_axis_input_tvalid
  .s_axis_input_tready              (encoder_input_tready            ), // output wire s_axis_input_tready
  .s_axis_input_tlast               (encoder_input_tlast             ), // input wire s_axis_input_tlast
  .m_axis_output_tdata              (encoder_output_tdata            ), // output wire [7 : 0] m_axis_output_tdata
  .m_axis_output_tvalid             (encoder_output_tvalid           ), // output wire m_axis_output_tvalid
  .m_axis_output_tlast              (encoder_output_tlast            ), // output wire m_axis_output_tlast
  .event_s_input_tlast_missing      (encoder_s_input_tlast_missing   ), // output wire event_s_input_tlast_missing
  .event_s_input_tlast_unexpected   (encoder_s_input_tlast_unexpected)  // output wire event_s_input_tlast_unexpected
);
//******************** end_rs_encode ****************//


//******************** rs_decode ********************//
assign decoder_input_tdata   = encoder_output_tdata;
assign decoder_input_tvalid  = encoder_output_tvalid;
assign decoder_input_tlast   = encoder_output_tlast;
assign decoder_output_tready = 1'b1;
assign decoder_stat_tready   = 1'b1;


rs_decoder_0 u_rs_decoder_0 (
  .aclk                             (clk_60m                         ), // input wire aclk
  .s_axis_input_tdata               (decoder_input_tdata             ), // input wire [7 : 0] s_axis_input_tdata
  .s_axis_input_tvalid              (decoder_input_tvalid            ), // input wire s_axis_input_tvalid
  .s_axis_input_tlast               (decoder_input_tlast             ), // input wire s_axis_input_tlast
  .s_axis_input_tready              (decoder_input_tready            ), // output wire s_axis_input_tready
  .m_axis_output_tdata              (decoder_output_tdata            ), // output wire [7 : 0] m_axis_output_tdata
  .m_axis_output_tvalid             (decoder_output_tvalid           ), // output wire m_axis_output_tvalid
  .m_axis_output_tready             (decoder_output_tready           ), // input wire m_axis_output_tready
  .m_axis_output_tlast              (decoder_output_tlast            ), // output wire m_axis_output_tlast
  .m_axis_stat_tdata                (decoder_stat_tdata              ), // output wire [7 : 0] m_axis_stat_tdata
  .m_axis_stat_tvalid               (decoder_stat_tvalid             ), // output wire m_axis_stat_tvalid
  .m_axis_stat_tready               (decoder_stat_tready             ), // input wire m_axis_stat_tready
  .event_s_input_tlast_missing      (decoder_s_input_tlast_missing   ), // output wire event_s_input_tlast_missing
  .event_s_input_tlast_unexpected   (decoder_s_input_tlast_unexpected), // output wire event_s_input_tlast_unexpected
  .event_s_ctrl_tdata_invalid       (decoder_s_ctrl_tdata_invalid    )  // output wire event_s_ctrl_tdata_invalid
);
//******************** end_rs_decode ****************//




//******************** rd_txt_data_tb ********************//
rd_txt_data_tb #(
  .CODE_RUN_CNT     (50),
  .DATA_WIDTH       (8),
  .DATA_NUM         (1024),
  .FILE_ADDR        (txt_input),
  .DELAY_BIT_DEPTH  (0),
  .DELAY_DATA_DEPTH (0),
  .DELAY_ADDR_DEPTH (0),
  .AXIS_DATA_WIDTH     (8   ),
  .AXIS_COLUMN         (238 ),
  .AXIS_ROW            (512 ),
  .AXIS_ROW_INTERVAL   (16  ),
  .AXIS_RUN_CNT        (3   )
) u_rd_txt_data_tb(
  .clk        (clk_60m),
  .rst_n      (rst_n),
  
  .axis_tdata    (encoder_input_tdata ),
  .axis_tvalid   (encoder_input_tvalid),
  .axis_tready   (encoder_input_tready),
  .axis_tlast    (encoder_input_tlast ),
  
  .rd_en      (),
  .rd_data    (),
  .rd_valid   (),
  .rd_addr    ()
);

//******************** end_rd_txt_data_tb ********************//



//******************** save_file ********************//
save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (8),
  .FILE_ADDR       (32),
  .cnt_data        (1024),
  .packet_select   (1)
) u_save_encode_input(
  .rst_n    (rst_n),
  .clk      (clk_60m),
  .valid    (encoder_input_tready && encoder_input_tvalid),
  .data     (encoder_input_tdata)
);

save_file_tb #(
  .DELAY_VALID_NUM (0), 
  .DATA_WIDTH      (8),
  .FILE_ADDR       (32),
  .cnt_data        (1024),
  .packet_select   (1)
) u_save_decode_output(
  .rst_n    (rst_n),
  .clk      (clk_60m),
  .valid    (decoder_output_tvalid & decoder_output_tready),
  .data     (decoder_output_tdata)
);
//******************** end_save_file ********************//



endmodule