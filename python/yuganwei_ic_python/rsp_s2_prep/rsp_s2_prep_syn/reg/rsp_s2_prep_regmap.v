// AUTO GENERATED. DO NOT EDIT
module rsp_s2_prep_regmap (
    i_dc_est_cmp_cnt_i_dc_est_cmp_cnt,
    i_dc_est_chp_cnt_i_dc_est_chp_cnt,
    i_dc_est_frm_cnt_i_dc_est_frm_cnt,
    i_dc_est_scale_i_dc_est_scale,
    i_dc_config_mode_i_dc_config_mode,
    i_dc_u_i_dc_u,
    o_dc_u_o_dc_u,
    i_intf_est_scale_i_intf_est_scale,
    i_intf_config_mode_i_intf_config_mode,
    i_intf_cmp_i_intf_cmp,
    o_intf_cmp_o_intf_cmp,
    i_combination_config_mode_i_combination_config_mode,
    i_phase_config_mode_i_phase_config_mode,
    i_phase_w_i_phase_w,
    i_phase_coe_i_phase_coe,
    i_data_formatter_i_data_formatter,
    i_frame_num_format_i_frame_num_format,
    s1_prep_debug_0_s1_prep_debug_0,
    s1_prep_debug_1_s1_prep_debug_1,
    s1_prep_debug_2_s1_prep_debug_2,
    s1_prep_debug_3_s1_prep_debug_3,
    s1_prep_debug_4_s1_prep_debug_4,
    s1_prep_debug_5_s1_prep_debug_5,
    s1_prep_debug_6_s1_prep_debug_6,
    s1_prep_debug_7_s1_prep_debug_7,
    s1_prep_debug_8_s1_prep_debug_8,
    s1_prep_debug_9_s1_prep_debug_9,
    s1_prep_debug_10_s1_prep_debug_10,
    s1_prep_debug_11_s1_prep_debug_11,
    s1_prep_debug_12_s1_prep_debug_12,
    s1_prep_debug_13_s1_prep_debug_13,
    s1_prep_debug_14_s1_prep_debug_14,
    s1_prep_debug_15_s1_prep_debug_15,
    s1_prep_debug_16_s1_prep_debug_16,

    last_register_last_register,


    hclk        ,
    hreset      ,
    hsel        ,
    htrans      ,
    haddr       ,
    //hburst      ,
    //hsize       ,
    hwdata      ,
    hwrite      ,
    hrdata      ,
    hreadyin    ,
    hresp       ,
    hready       

);
output [12:0]     i_dc_est_cmp_cnt_i_dc_est_cmp_cnt;
output [9:0]      i_dc_est_chp_cnt_i_dc_est_chp_cnt;
output [3:0]      i_dc_est_frm_cnt_i_dc_est_frm_cnt;
output [16:0]     i_dc_est_scale_i_dc_est_scale;
output [3:0]      i_dc_config_mode_i_dc_config_mode;
output [31:0]     i_dc_u_i_dc_u;
output [31:0]     o_dc_u_o_dc_u;
output [16:0]     i_intf_est_scale_i_intf_est_scale;
output [3:0]      i_intf_config_mode_i_intf_config_mode;
output [31:0]     i_intf_cmp_i_intf_cmp;
output [31:0]     o_intf_cmp_o_intf_cmp;
output [3:0]      i_combination_config_mode_i_combination_config_mode;
output [3:0]      i_phase_config_mode_i_phase_config_mode;
output [31:0]     i_phase_w_i_phase_w;
output [31:0]     i_phase_coe_i_phase_coe;
output [15:0]     i_data_formatter_i_data_formatter;
output [15:0]     i_frame_num_format_i_frame_num_format;
output [31:0]     s1_prep_debug_0_s1_prep_debug_0;
output [31:0]     s1_prep_debug_1_s1_prep_debug_1;
output [31:0]     s1_prep_debug_2_s1_prep_debug_2;
output [31:0]     s1_prep_debug_3_s1_prep_debug_3;
output [31:0]     s1_prep_debug_4_s1_prep_debug_4;
output [31:0]     s1_prep_debug_5_s1_prep_debug_5;
output [31:0]     s1_prep_debug_6_s1_prep_debug_6;
output [31:0]     s1_prep_debug_7_s1_prep_debug_7;
output [31:0]     s1_prep_debug_8_s1_prep_debug_8;
output [31:0]     s1_prep_debug_9_s1_prep_debug_9;
output [31:0]     s1_prep_debug_10_s1_prep_debug_10;
output [31:0]     s1_prep_debug_11_s1_prep_debug_11;
output [31:0]     s1_prep_debug_12_s1_prep_debug_12;
output [31:0]     s1_prep_debug_13_s1_prep_debug_13;
output [31:0]     s1_prep_debug_14_s1_prep_debug_14;
output [31:0]     s1_prep_debug_15_s1_prep_debug_15;
output [31:0]     s1_prep_debug_16_s1_prep_debug_16;

input  [31:0]     last_register_last_register;


input             hclk        ;
input             hreset      ;
input             hsel        ;
input  [1:0]      htrans      ;
input  [31:0]     haddr       ;
//input  [2:0]      hburst      ;
//input  [2:0]      hsize       ;
input  [31:0]     hwdata      ;
input             hwrite      ;
input             hreadyin    ;
output [31:0]     hrdata      ;
output [1:0]      hresp       ;
output            hready      ;

reg               write_i_dc_est_cmp_cnt_en_reg;
reg    [12:0]     i_dc_est_cmp_cnt_i_dc_est_cmp_cnt_reg;
reg               write_i_dc_est_chp_cnt_en_reg;
reg    [9:0]      i_dc_est_chp_cnt_i_dc_est_chp_cnt_reg;
reg               write_i_dc_est_frm_cnt_en_reg;
reg    [3:0]      i_dc_est_frm_cnt_i_dc_est_frm_cnt_reg;
reg               write_i_dc_est_scale_en_reg;
reg    [16:0]     i_dc_est_scale_i_dc_est_scale_reg;
reg               write_i_dc_config_mode_en_reg;
reg    [3:0]      i_dc_config_mode_i_dc_config_mode_reg;
reg               write_i_dc_u_en_reg;
reg    [31:0]     i_dc_u_i_dc_u_reg;
reg               write_o_dc_u_en_reg;
reg    [31:0]     o_dc_u_o_dc_u_reg;
reg               write_i_intf_est_scale_en_reg;
reg    [16:0]     i_intf_est_scale_i_intf_est_scale_reg;
reg               write_i_intf_config_mode_en_reg;
reg    [3:0]      i_intf_config_mode_i_intf_config_mode_reg;
reg               write_i_intf_cmp_en_reg;
reg    [31:0]     i_intf_cmp_i_intf_cmp_reg;
reg               write_o_intf_cmp_en_reg;
reg    [31:0]     o_intf_cmp_o_intf_cmp_reg;
reg               write_i_combination_config_mode_en_reg;
reg    [3:0]      i_combination_config_mode_i_combination_config_mode_reg;
reg               write_i_phase_config_mode_en_reg;
reg    [3:0]      i_phase_config_mode_i_phase_config_mode_reg;
reg               write_i_phase_w_en_reg;
reg    [31:0]     i_phase_w_i_phase_w_reg;
reg               write_i_phase_coe_en_reg;
reg    [31:0]     i_phase_coe_i_phase_coe_reg;
reg               write_i_data_formatter_en_reg;
reg    [15:0]     i_data_formatter_i_data_formatter_reg;
reg               write_i_frame_num_format_en_reg;
reg    [15:0]     i_frame_num_format_i_frame_num_format_reg;
reg               write_s1_prep_debug_0_en_reg;
reg    [31:0]     s1_prep_debug_0_s1_prep_debug_0_reg;
reg               write_s1_prep_debug_1_en_reg;
reg    [31:0]     s1_prep_debug_1_s1_prep_debug_1_reg;
reg               write_s1_prep_debug_2_en_reg;
reg    [31:0]     s1_prep_debug_2_s1_prep_debug_2_reg;
reg               write_s1_prep_debug_3_en_reg;
reg    [31:0]     s1_prep_debug_3_s1_prep_debug_3_reg;
reg               write_s1_prep_debug_4_en_reg;
reg    [31:0]     s1_prep_debug_4_s1_prep_debug_4_reg;
reg               write_s1_prep_debug_5_en_reg;
reg    [31:0]     s1_prep_debug_5_s1_prep_debug_5_reg;
reg               write_s1_prep_debug_6_en_reg;
reg    [31:0]     s1_prep_debug_6_s1_prep_debug_6_reg;
reg               write_s1_prep_debug_7_en_reg;
reg    [31:0]     s1_prep_debug_7_s1_prep_debug_7_reg;
reg               write_s1_prep_debug_8_en_reg;
reg    [31:0]     s1_prep_debug_8_s1_prep_debug_8_reg;
reg               write_s1_prep_debug_9_en_reg;
reg    [31:0]     s1_prep_debug_9_s1_prep_debug_9_reg;
reg               write_s1_prep_debug_10_en_reg;
reg    [31:0]     s1_prep_debug_10_s1_prep_debug_10_reg;
reg               write_s1_prep_debug_11_en_reg;
reg    [31:0]     s1_prep_debug_11_s1_prep_debug_11_reg;
reg               write_s1_prep_debug_12_en_reg;
reg    [31:0]     s1_prep_debug_12_s1_prep_debug_12_reg;
reg               write_s1_prep_debug_13_en_reg;
reg    [31:0]     s1_prep_debug_13_s1_prep_debug_13_reg;
reg               write_s1_prep_debug_14_en_reg;
reg    [31:0]     s1_prep_debug_14_s1_prep_debug_14_reg;
reg               write_s1_prep_debug_15_en_reg;
reg    [31:0]     s1_prep_debug_15_s1_prep_debug_15_reg;
reg               write_s1_prep_debug_16_en_reg;
reg    [31:0]     s1_prep_debug_16_s1_prep_debug_16_reg;

wire   [31:0]     last_register_last_register_reg;

wire              ahb_read_en;
reg    [31:0]     hrdata;

assign i_dc_est_cmp_cnt_i_dc_est_cmp_cnt = i_dc_est_cmp_cnt_i_dc_est_cmp_cnt_reg;
assign i_dc_est_chp_cnt_i_dc_est_chp_cnt = i_dc_est_chp_cnt_i_dc_est_chp_cnt_reg;
assign i_dc_est_frm_cnt_i_dc_est_frm_cnt = i_dc_est_frm_cnt_i_dc_est_frm_cnt_reg;
assign i_dc_est_scale_i_dc_est_scale  = i_dc_est_scale_i_dc_est_scale_reg;
assign i_dc_config_mode_i_dc_config_mode = i_dc_config_mode_i_dc_config_mode_reg;
assign i_dc_u_i_dc_u                  = i_dc_u_i_dc_u_reg;
assign o_dc_u_o_dc_u                  = o_dc_u_o_dc_u_reg;
assign i_intf_est_scale_i_intf_est_scale = i_intf_est_scale_i_intf_est_scale_reg;
assign i_intf_config_mode_i_intf_config_mode = i_intf_config_mode_i_intf_config_mode_reg;
assign i_intf_cmp_i_intf_cmp          = i_intf_cmp_i_intf_cmp_reg;
assign o_intf_cmp_o_intf_cmp          = o_intf_cmp_o_intf_cmp_reg;
assign i_combination_config_mode_i_combination_config_mode = i_combination_config_mode_i_combination_config_mode_reg;
assign i_phase_config_mode_i_phase_config_mode = i_phase_config_mode_i_phase_config_mode_reg;
assign i_phase_w_i_phase_w            = i_phase_w_i_phase_w_reg;
assign i_phase_coe_i_phase_coe        = i_phase_coe_i_phase_coe_reg;
assign i_data_formatter_i_data_formatter = i_data_formatter_i_data_formatter_reg;
assign i_frame_num_format_i_frame_num_format = i_frame_num_format_i_frame_num_format_reg;
assign s1_prep_debug_0_s1_prep_debug_0 = s1_prep_debug_0_s1_prep_debug_0_reg;
assign s1_prep_debug_1_s1_prep_debug_1 = s1_prep_debug_1_s1_prep_debug_1_reg;
assign s1_prep_debug_2_s1_prep_debug_2 = s1_prep_debug_2_s1_prep_debug_2_reg;
assign s1_prep_debug_3_s1_prep_debug_3 = s1_prep_debug_3_s1_prep_debug_3_reg;
assign s1_prep_debug_4_s1_prep_debug_4 = s1_prep_debug_4_s1_prep_debug_4_reg;
assign s1_prep_debug_5_s1_prep_debug_5 = s1_prep_debug_5_s1_prep_debug_5_reg;
assign s1_prep_debug_6_s1_prep_debug_6 = s1_prep_debug_6_s1_prep_debug_6_reg;
assign s1_prep_debug_7_s1_prep_debug_7 = s1_prep_debug_7_s1_prep_debug_7_reg;
assign s1_prep_debug_8_s1_prep_debug_8 = s1_prep_debug_8_s1_prep_debug_8_reg;
assign s1_prep_debug_9_s1_prep_debug_9 = s1_prep_debug_9_s1_prep_debug_9_reg;
assign s1_prep_debug_10_s1_prep_debug_10 = s1_prep_debug_10_s1_prep_debug_10_reg;
assign s1_prep_debug_11_s1_prep_debug_11 = s1_prep_debug_11_s1_prep_debug_11_reg;
assign s1_prep_debug_12_s1_prep_debug_12 = s1_prep_debug_12_s1_prep_debug_12_reg;
assign s1_prep_debug_13_s1_prep_debug_13 = s1_prep_debug_13_s1_prep_debug_13_reg;
assign s1_prep_debug_14_s1_prep_debug_14 = s1_prep_debug_14_s1_prep_debug_14_reg;
assign s1_prep_debug_15_s1_prep_debug_15 = s1_prep_debug_15_s1_prep_debug_15_reg;
assign s1_prep_debug_16_s1_prep_debug_16 = s1_prep_debug_16_s1_prep_debug_16_reg;
assign last_register_last_register_reg = last_register_last_register;
assign ahb_read_en                    = hsel & htrans[1] & !hwrite & hreadyin;
assign hready                         = 1'b1;
assign hresp                          = 2'b0;

always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_dc_est_cmp_cnt_en_reg    <= 1'b0;
    else 
        write_i_dc_est_cmp_cnt_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h0;
end


//SW can read and write 
// i_dc_est_cmp_cnt
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_dc_est_cmp_cnt_i_dc_est_cmp_cnt_reg    <= 13'h0;
    else if(write_i_dc_est_cmp_cnt_en_reg)
        i_dc_est_cmp_cnt_i_dc_est_cmp_cnt_reg    <= hwdata[12:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_dc_est_chp_cnt_en_reg    <= 1'b0;
    else 
        write_i_dc_est_chp_cnt_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1;
end


//SW can read and write 
// i_dc_est_chp_cnt
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_dc_est_chp_cnt_i_dc_est_chp_cnt_reg    <= 10'h0;
    else if(write_i_dc_est_chp_cnt_en_reg)
        i_dc_est_chp_cnt_i_dc_est_chp_cnt_reg    <= hwdata[9:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_dc_est_frm_cnt_en_reg    <= 1'b0;
    else 
        write_i_dc_est_frm_cnt_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h2;
end


//SW can read and write 
// i_dc_est_frm_cnt
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_dc_est_frm_cnt_i_dc_est_frm_cnt_reg    <= 4'h0;
    else if(write_i_dc_est_frm_cnt_en_reg)
        i_dc_est_frm_cnt_i_dc_est_frm_cnt_reg    <= hwdata[3:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_dc_est_scale_en_reg    <= 1'b0;
    else 
        write_i_dc_est_scale_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h3;
end


//SW can read and write 
// i_dc_est_scale
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_dc_est_scale_i_dc_est_scale_reg    <= 17'h0;
    else if(write_i_dc_est_scale_en_reg)
        i_dc_est_scale_i_dc_est_scale_reg    <= hwdata[16:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_dc_config_mode_en_reg    <= 1'b0;
    else 
        write_i_dc_config_mode_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h4;
end


//SW can read and write 
// i_dc_config_mode
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_dc_config_mode_i_dc_config_mode_reg    <= 4'h0;
    else if(write_i_dc_config_mode_en_reg)
        i_dc_config_mode_i_dc_config_mode_reg    <= hwdata[3:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_dc_u_en_reg    <= 1'b0;
    else 
        write_i_dc_u_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h5;
end


//SW can read and write 
// i_dc_u
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_dc_u_i_dc_u_reg    <= 32'h0;
    else if(write_i_dc_u_en_reg)
        i_dc_u_i_dc_u_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_o_dc_u_en_reg    <= 1'b0;
    else 
        write_o_dc_u_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h6;
end


//SW can read and write 
// o_dc_u
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        o_dc_u_o_dc_u_reg    <= 32'h0;
    else if(write_o_dc_u_en_reg)
        o_dc_u_o_dc_u_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_intf_est_scale_en_reg    <= 1'b0;
    else 
        write_i_intf_est_scale_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h7;
end


//SW can read and write 
// i_intf_est_scale
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_intf_est_scale_i_intf_est_scale_reg    <= 17'h0;
    else if(write_i_intf_est_scale_en_reg)
        i_intf_est_scale_i_intf_est_scale_reg    <= hwdata[16:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_intf_config_mode_en_reg    <= 1'b0;
    else 
        write_i_intf_config_mode_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h8;
end


//SW can read and write 
// i_intf_config_mode
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_intf_config_mode_i_intf_config_mode_reg    <= 4'h0;
    else if(write_i_intf_config_mode_en_reg)
        i_intf_config_mode_i_intf_config_mode_reg    <= hwdata[3:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_intf_cmp_en_reg    <= 1'b0;
    else 
        write_i_intf_cmp_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h9;
end


//SW can read and write 
// i_intf_cmp
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_intf_cmp_i_intf_cmp_reg    <= 32'h0;
    else if(write_i_intf_cmp_en_reg)
        i_intf_cmp_i_intf_cmp_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_o_intf_cmp_en_reg    <= 1'b0;
    else 
        write_o_intf_cmp_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'ha;
end


//SW can read and write 
// o_intf_cmp
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        o_intf_cmp_o_intf_cmp_reg    <= 32'h0;
    else if(write_o_intf_cmp_en_reg)
        o_intf_cmp_o_intf_cmp_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_combination_config_mode_en_reg    <= 1'b0;
    else 
        write_i_combination_config_mode_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'hb;
end


//SW can read and write 
// i_combination_config_mode
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_combination_config_mode_i_combination_config_mode_reg    <= 4'h0;
    else if(write_i_combination_config_mode_en_reg)
        i_combination_config_mode_i_combination_config_mode_reg    <= hwdata[3:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_phase_config_mode_en_reg    <= 1'b0;
    else 
        write_i_phase_config_mode_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'hc;
end


//SW can read and write 
// i_phase_config_mode
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_phase_config_mode_i_phase_config_mode_reg    <= 4'h0;
    else if(write_i_phase_config_mode_en_reg)
        i_phase_config_mode_i_phase_config_mode_reg    <= hwdata[3:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_phase_w_en_reg    <= 1'b0;
    else 
        write_i_phase_w_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'hd;
end


//SW can read and write 
// i_phase_w
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_phase_w_i_phase_w_reg    <= 32'h0;
    else if(write_i_phase_w_en_reg)
        i_phase_w_i_phase_w_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_phase_coe_en_reg    <= 1'b0;
    else 
        write_i_phase_coe_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'he;
end


//SW can read and write 
// i_phase_coe
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_phase_coe_i_phase_coe_reg    <= 32'h0;
    else if(write_i_phase_coe_en_reg)
        i_phase_coe_i_phase_coe_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_data_formatter_en_reg    <= 1'b0;
    else 
        write_i_data_formatter_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'hf;
end


//SW can read and write 
// i_data_formatter
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_data_formatter_i_data_formatter_reg    <= 16'h0;
    else if(write_i_data_formatter_en_reg)
        i_data_formatter_i_data_formatter_reg    <= hwdata[15:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_i_frame_num_format_en_reg    <= 1'b0;
    else 
        write_i_frame_num_format_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h10;
end


//SW can read and write 
// i_frame_num_format
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        i_frame_num_format_i_frame_num_format_reg    <= 16'h0;
    else if(write_i_frame_num_format_en_reg)
        i_frame_num_format_i_frame_num_format_reg    <= hwdata[15:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_0_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_0_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h11;
end


//SW can read and write 
// s1_prep_debug_0
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_0_s1_prep_debug_0_reg    <= 32'h0;
    else if(write_s1_prep_debug_0_en_reg)
        s1_prep_debug_0_s1_prep_debug_0_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_1_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_1_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h12;
end


//SW can read and write 
// s1_prep_debug_1
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_1_s1_prep_debug_1_reg    <= 32'h0;
    else if(write_s1_prep_debug_1_en_reg)
        s1_prep_debug_1_s1_prep_debug_1_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_2_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_2_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h13;
end


//SW can read and write 
// s1_prep_debug_2
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_2_s1_prep_debug_2_reg    <= 32'h0;
    else if(write_s1_prep_debug_2_en_reg)
        s1_prep_debug_2_s1_prep_debug_2_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_3_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_3_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h14;
end


//SW can read and write 
// s1_prep_debug_3
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_3_s1_prep_debug_3_reg    <= 32'h0;
    else if(write_s1_prep_debug_3_en_reg)
        s1_prep_debug_3_s1_prep_debug_3_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_4_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_4_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h15;
end


//SW can read and write 
// s1_prep_debug_4
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_4_s1_prep_debug_4_reg    <= 32'h0;
    else if(write_s1_prep_debug_4_en_reg)
        s1_prep_debug_4_s1_prep_debug_4_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_5_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_5_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h16;
end


//SW can read and write 
// s1_prep_debug_5
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_5_s1_prep_debug_5_reg    <= 32'h0;
    else if(write_s1_prep_debug_5_en_reg)
        s1_prep_debug_5_s1_prep_debug_5_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_6_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_6_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h17;
end


//SW can read and write 
// s1_prep_debug_6
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_6_s1_prep_debug_6_reg    <= 32'h0;
    else if(write_s1_prep_debug_6_en_reg)
        s1_prep_debug_6_s1_prep_debug_6_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_7_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_7_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h18;
end


//SW can read and write 
// s1_prep_debug_7
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_7_s1_prep_debug_7_reg    <= 32'h0;
    else if(write_s1_prep_debug_7_en_reg)
        s1_prep_debug_7_s1_prep_debug_7_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_8_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_8_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h19;
end


//SW can read and write 
// s1_prep_debug_8
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_8_s1_prep_debug_8_reg    <= 32'h0;
    else if(write_s1_prep_debug_8_en_reg)
        s1_prep_debug_8_s1_prep_debug_8_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_9_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_9_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1a;
end


//SW can read and write 
// s1_prep_debug_9
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_9_s1_prep_debug_9_reg    <= 32'h0;
    else if(write_s1_prep_debug_9_en_reg)
        s1_prep_debug_9_s1_prep_debug_9_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_10_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_10_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1b;
end


//SW can read and write 
// s1_prep_debug_10
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_10_s1_prep_debug_10_reg    <= 32'h0;
    else if(write_s1_prep_debug_10_en_reg)
        s1_prep_debug_10_s1_prep_debug_10_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_11_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_11_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1c;
end


//SW can read and write 
// s1_prep_debug_11
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_11_s1_prep_debug_11_reg    <= 32'h0;
    else if(write_s1_prep_debug_11_en_reg)
        s1_prep_debug_11_s1_prep_debug_11_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_12_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_12_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1d;
end


//SW can read and write 
// s1_prep_debug_12
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_12_s1_prep_debug_12_reg    <= 32'h0;
    else if(write_s1_prep_debug_12_en_reg)
        s1_prep_debug_12_s1_prep_debug_12_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_13_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_13_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1e;
end


//SW can read and write 
// s1_prep_debug_13
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_13_s1_prep_debug_13_reg    <= 32'h0;
    else if(write_s1_prep_debug_13_en_reg)
        s1_prep_debug_13_s1_prep_debug_13_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_14_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_14_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1f;
end


//SW can read and write 
// s1_prep_debug_14
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_14_s1_prep_debug_14_reg    <= 32'h0;
    else if(write_s1_prep_debug_14_en_reg)
        s1_prep_debug_14_s1_prep_debug_14_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_15_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_15_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h20;
end


//SW can read and write 
// s1_prep_debug_15
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_15_s1_prep_debug_15_reg    <= 32'h0;
    else if(write_s1_prep_debug_15_en_reg)
        s1_prep_debug_15_s1_prep_debug_15_reg    <= hwdata[31:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_s1_prep_debug_16_en_reg    <= 1'b0;
    else 
        write_s1_prep_debug_16_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h21;
end


//SW can read and write 
// s1_prep_debug_16
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        s1_prep_debug_16_s1_prep_debug_16_reg    <= 32'h0;
    else if(write_s1_prep_debug_16_en_reg)
        s1_prep_debug_16_s1_prep_debug_16_reg    <= hwdata[31:0];
end

    // no write to read only last_register_last_register_reg

always@(posedge hclk or posedge hreset) begin
    if(hreset)
        hrdata      <= 32'h0;
    else if(ahb_read_en) begin
        hrdata      <= 32'h0;
        case(haddr[31:2]) 
            30'h0 : begin
                hrdata[12:0 ]    <= i_dc_est_cmp_cnt_i_dc_est_cmp_cnt_reg;
            end
            30'h1 : begin
                hrdata[9:0  ]    <= i_dc_est_chp_cnt_i_dc_est_chp_cnt_reg;
            end
            30'h2 : begin
                hrdata[3:0  ]    <= i_dc_est_frm_cnt_i_dc_est_frm_cnt_reg;
            end
            30'h3 : begin
                hrdata[16:0 ]    <= i_dc_est_scale_i_dc_est_scale_reg;
            end
            30'h4 : begin
                hrdata[3:0  ]    <= i_dc_config_mode_i_dc_config_mode_reg;
            end
            30'h5 : begin
                hrdata[31:0 ]    <= i_dc_u_i_dc_u_reg;
            end
            30'h6 : begin
                hrdata[31:0 ]    <= o_dc_u_o_dc_u_reg;
            end
            30'h7 : begin
                hrdata[16:0 ]    <= i_intf_est_scale_i_intf_est_scale_reg;
            end
            30'h8 : begin
                hrdata[3:0  ]    <= i_intf_config_mode_i_intf_config_mode_reg;
            end
            30'h9 : begin
                hrdata[31:0 ]    <= i_intf_cmp_i_intf_cmp_reg;
            end
            30'ha : begin
                hrdata[31:0 ]    <= o_intf_cmp_o_intf_cmp_reg;
            end
            30'hb : begin
                hrdata[3:0  ]    <= i_combination_config_mode_i_combination_config_mode_reg;
            end
            30'hc : begin
                hrdata[3:0  ]    <= i_phase_config_mode_i_phase_config_mode_reg;
            end
            30'hd : begin
                hrdata[31:0 ]    <= i_phase_w_i_phase_w_reg;
            end
            30'he : begin
                hrdata[31:0 ]    <= i_phase_coe_i_phase_coe_reg;
            end
            30'hf : begin
                hrdata[15:0 ]    <= i_data_formatter_i_data_formatter_reg;
            end
            30'h10 : begin
                hrdata[15:0 ]    <= i_frame_num_format_i_frame_num_format_reg;
            end
            30'h11 : begin
                hrdata[31:0 ]    <= s1_prep_debug_0_s1_prep_debug_0_reg;
            end
            30'h12 : begin
                hrdata[31:0 ]    <= s1_prep_debug_1_s1_prep_debug_1_reg;
            end
            30'h13 : begin
                hrdata[31:0 ]    <= s1_prep_debug_2_s1_prep_debug_2_reg;
            end
            30'h14 : begin
                hrdata[31:0 ]    <= s1_prep_debug_3_s1_prep_debug_3_reg;
            end
            30'h15 : begin
                hrdata[31:0 ]    <= s1_prep_debug_4_s1_prep_debug_4_reg;
            end
            30'h16 : begin
                hrdata[31:0 ]    <= s1_prep_debug_5_s1_prep_debug_5_reg;
            end
            30'h17 : begin
                hrdata[31:0 ]    <= s1_prep_debug_6_s1_prep_debug_6_reg;
            end
            30'h18 : begin
                hrdata[31:0 ]    <= s1_prep_debug_7_s1_prep_debug_7_reg;
            end
            30'h19 : begin
                hrdata[31:0 ]    <= s1_prep_debug_8_s1_prep_debug_8_reg;
            end
            30'h1a : begin
                hrdata[31:0 ]    <= s1_prep_debug_9_s1_prep_debug_9_reg;
            end
            30'h1b : begin
                hrdata[31:0 ]    <= s1_prep_debug_10_s1_prep_debug_10_reg;
            end
            30'h1c : begin
                hrdata[31:0 ]    <= s1_prep_debug_11_s1_prep_debug_11_reg;
            end
            30'h1d : begin
                hrdata[31:0 ]    <= s1_prep_debug_12_s1_prep_debug_12_reg;
            end
            30'h1e : begin
                hrdata[31:0 ]    <= s1_prep_debug_13_s1_prep_debug_13_reg;
            end
            30'h1f : begin
                hrdata[31:0 ]    <= s1_prep_debug_14_s1_prep_debug_14_reg;
            end
            30'h20 : begin
                hrdata[31:0 ]    <= s1_prep_debug_15_s1_prep_debug_15_reg;
            end
            30'h21 : begin
                hrdata[31:0 ]    <= s1_prep_debug_16_s1_prep_debug_16_reg;
            end
            30'h22 : begin
                hrdata[31:0 ]    <= last_register_last_register_reg;
            end
        default:
            hrdata      <= 32'hdeadbeaf;
        endcase
    end
end

endmodule
