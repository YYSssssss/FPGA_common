// AUTO GENERATED. DO NOT EDIT Sun Mar 17 09:20:31 2024
module rsp_s2_dma_glb_reg (

    irq_status_fcnt_finish,
    irq_status_fcnt_finish_lat_pls,

    irq_status_pcnt_finish,
    irq_status_pcnt_finish_lat_pls,
    irq_mask_fcnt_finish,
    irq_mask_pcnt_finish,
    irq_enable_fcnt_finish,
    irq_enable_pcnt_finish,

    cmd0_cs,


    cmd0_trig_cs,


    cmd0_trig_word_counter,


    cmd0_ttl,


    cmd0_op_id,


    cmd1_trig_in,


    cmd2_trig_out,

    sw0_cmd_ttl,
    sw0_cmd_op_id,
    sw0_cmd_req,
    sw0_cmd_req_clr_pls,

    sw1_cmd_trig_in,
    sw2_cmd_trig_out,
    sw3_mem_alloc,
    sw3_mem_alloc_clr_pls,

    sw3_finish_ack,
    sw3_finish_ack_clr_pls,

    sw3_finish_req_mask,
    sw3_start_fid,
    sw3_start_pipo,
    sw3_start,
    sw3_start_clr_pls,

    fidx_data,
    fidx_en,
    fidx_en_clr_pls,


    sts0_ttl_counter,


    sts1_rc_update,


    sts1_rc_resume,


    sts2_wc_update,


    sts2_wc_resume,


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

output            irq_status_fcnt_finish;
input             irq_status_fcnt_finish_lat_pls;


output            irq_status_pcnt_finish;
input             irq_status_pcnt_finish_lat_pls;

output            irq_mask_fcnt_finish;
output            irq_mask_pcnt_finish;
output            irq_enable_fcnt_finish;
output            irq_enable_pcnt_finish;

input  [3:0]      cmd0_cs;


input  [2:0]      cmd0_trig_cs;


input  [3:0]      cmd0_trig_word_counter;


input  [11:0]     cmd0_ttl;


input  [4:0]      cmd0_op_id;


input  [23:0]     cmd1_trig_in;


input  [23:0]     cmd2_trig_out;

output [11:0]     sw0_cmd_ttl;
output [4:0]      sw0_cmd_op_id;
output            sw0_cmd_req;
input             sw0_cmd_req_clr_pls;
output [23:0]     sw1_cmd_trig_in;
output [23:0]     sw2_cmd_trig_out;
output            sw3_mem_alloc;
input             sw3_mem_alloc_clr_pls;
output            sw3_finish_ack;
input             sw3_finish_ack_clr_pls;
output            sw3_finish_req_mask;
output [1:0]      sw3_start_fid;
output [2:0]      sw3_start_pipo;
output            sw3_start;
input             sw3_start_clr_pls;
output [7:0]      fidx_data;
output            fidx_en;
input             fidx_en_clr_pls;

input  [11:0]     sts0_ttl_counter;


input  [15:0]     sts1_rc_update;


input  [15:0]     sts1_rc_resume;


input  [15:0]     sts2_wc_update;


input  [15:0]     sts2_wc_resume;


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

reg               write_irq_status_en_reg;

reg               irq_status_fcnt_finish_reg;
wire              irq_status_fcnt_finish_reg_lat_pls;


reg               irq_status_pcnt_finish_reg;
wire              irq_status_pcnt_finish_reg_lat_pls;

reg               write_irq_mask_en_reg;
reg               irq_mask_fcnt_finish_reg;
reg               irq_mask_pcnt_finish_reg;
reg               write_irq_enable_en_reg;
reg               irq_enable_fcnt_finish_reg;
reg               irq_enable_pcnt_finish_reg;

wire   [3:0]      cmd0_cs_reg;


wire   [2:0]      cmd0_trig_cs_reg;


wire   [3:0]      cmd0_trig_word_counter_reg;


wire   [11:0]     cmd0_ttl_reg;


wire   [4:0]      cmd0_op_id_reg;


wire   [23:0]     cmd1_trig_in_reg;


wire   [23:0]     cmd2_trig_out_reg;

reg               write_sw0_en_reg;
reg    [11:0]     sw0_cmd_ttl_reg;
reg    [4:0]      sw0_cmd_op_id_reg;
reg               sw0_cmd_req_reg;
wire              sw0_cmd_req_reg_clr_pls;
reg               write_sw1_en_reg;
reg    [23:0]     sw1_cmd_trig_in_reg;
reg               write_sw2_en_reg;
reg    [23:0]     sw2_cmd_trig_out_reg;
reg               write_sw3_en_reg;
reg               sw3_mem_alloc_reg;
wire              sw3_mem_alloc_reg_clr_pls;
reg               sw3_finish_ack_reg;
wire              sw3_finish_ack_reg_clr_pls;
reg               sw3_finish_req_mask_reg;
reg    [1:0]      sw3_start_fid_reg;
reg    [2:0]      sw3_start_pipo_reg;
reg               sw3_start_reg;
wire              sw3_start_reg_clr_pls;
reg               write_fidx_en_reg;
reg    [7:0]      fidx_data_reg;
reg               fidx_en_reg;
wire              fidx_en_reg_clr_pls;

wire   [11:0]     sts0_ttl_counter_reg;


wire   [15:0]     sts1_rc_update_reg;


wire   [15:0]     sts1_rc_resume_reg;


wire   [15:0]     sts2_wc_update_reg;


wire   [15:0]     sts2_wc_resume_reg;

wire              ahb_read_en,ahb_write_en;
wire              hready;
reg               last_write;
reg    [31:0]     hrdata;

assign irq_status_fcnt_finish_reg_lat_pls = irq_status_fcnt_finish_lat_pls;
assign irq_status_fcnt_finish         = irq_status_fcnt_finish_reg;
assign irq_status_pcnt_finish_reg_lat_pls = irq_status_pcnt_finish_lat_pls;
assign irq_status_pcnt_finish         = irq_status_pcnt_finish_reg;
assign irq_mask_fcnt_finish           = irq_mask_fcnt_finish_reg;
assign irq_mask_pcnt_finish           = irq_mask_pcnt_finish_reg;
assign irq_enable_fcnt_finish         = irq_enable_fcnt_finish_reg;
assign irq_enable_pcnt_finish         = irq_enable_pcnt_finish_reg;
assign cmd0_cs_reg                    = cmd0_cs;
assign cmd0_trig_cs_reg               = cmd0_trig_cs;
assign cmd0_trig_word_counter_reg     = cmd0_trig_word_counter;
assign cmd0_ttl_reg                   = cmd0_ttl;
assign cmd0_op_id_reg                 = cmd0_op_id;
assign cmd1_trig_in_reg               = cmd1_trig_in;
assign cmd2_trig_out_reg              = cmd2_trig_out;
assign sw0_cmd_ttl                    = sw0_cmd_ttl_reg;
assign sw0_cmd_op_id                  = sw0_cmd_op_id_reg;
assign sw0_cmd_req_reg_clr_pls        = sw0_cmd_req_clr_pls;
assign sw0_cmd_req                    = sw0_cmd_req_reg;
assign sw1_cmd_trig_in                = sw1_cmd_trig_in_reg;
assign sw2_cmd_trig_out               = sw2_cmd_trig_out_reg;
assign sw3_mem_alloc_reg_clr_pls      = sw3_mem_alloc_clr_pls;
assign sw3_mem_alloc                  = sw3_mem_alloc_reg;
assign sw3_finish_ack_reg_clr_pls     = sw3_finish_ack_clr_pls;
assign sw3_finish_ack                 = sw3_finish_ack_reg;
assign sw3_finish_req_mask            = sw3_finish_req_mask_reg;
assign sw3_start_fid                  = sw3_start_fid_reg;
assign sw3_start_pipo                 = sw3_start_pipo_reg;
assign sw3_start_reg_clr_pls          = sw3_start_clr_pls;
assign sw3_start                      = sw3_start_reg;
assign fidx_data                      = fidx_data_reg;
assign fidx_en_reg_clr_pls            = fidx_en_clr_pls;
assign fidx_en                        = fidx_en_reg;
assign sts0_ttl_counter_reg           = sts0_ttl_counter;
assign sts1_rc_update_reg             = sts1_rc_update;
assign sts1_rc_resume_reg             = sts1_rc_resume;
assign sts2_wc_update_reg             = sts2_wc_update;
assign sts2_wc_resume_reg             = sts2_wc_resume;
assign ahb_read_en                    = hsel & htrans[1] & !hwrite & hreadyin;
assign ahb_write_en                   = hsel & htrans[1] & hwrite & hreadyin;
assign hready                         = ~(last_write & hsel & htrans[1] & !hwrite);
assign hresp                          = 2'b0;

always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_irq_status_en_reg    <= 1'b0;
    else 
        write_irq_status_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h0;
end


// SW can write 0/1, and it can also be set to 1 by external event
// FCNT_FINISH
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        irq_status_fcnt_finish_reg    <= 1'b0;
    else if(irq_status_fcnt_finish_reg_lat_pls)
        irq_status_fcnt_finish_reg    <= 1'b1;
    else if(write_irq_status_en_reg)
        irq_status_fcnt_finish_reg    <= hwdata[1];
end


// SW can write 0/1, and it can also be set to 1 by external event
// PCNT_FINISH
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        irq_status_pcnt_finish_reg    <= 1'b0;
    else if(irq_status_pcnt_finish_reg_lat_pls)
        irq_status_pcnt_finish_reg    <= 1'b1;
    else if(write_irq_status_en_reg)
        irq_status_pcnt_finish_reg    <= hwdata[0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_irq_mask_en_reg    <= 1'b0;
    else 
        write_irq_mask_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h1;
end


//SW can read and write 
// FCNT_FINISH
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        irq_mask_fcnt_finish_reg    <= 1'b0;
    else if(write_irq_mask_en_reg)
        irq_mask_fcnt_finish_reg    <= hwdata[1];
end


//SW can read and write 
// PCNT_FINISH
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        irq_mask_pcnt_finish_reg    <= 1'b0;
    else if(write_irq_mask_en_reg)
        irq_mask_pcnt_finish_reg    <= hwdata[0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_irq_enable_en_reg    <= 1'b0;
    else 
        write_irq_enable_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h2;
end


//SW can read and write 
// FCNT_FINISH
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        irq_enable_fcnt_finish_reg    <= 1'b0;
    else if(write_irq_enable_en_reg)
        irq_enable_fcnt_finish_reg    <= hwdata[1];
end


//SW can read and write 
// PCNT_FINISH
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        irq_enable_pcnt_finish_reg    <= 1'b0;
    else if(write_irq_enable_en_reg)
        irq_enable_pcnt_finish_reg    <= hwdata[0];
end

    // no write to read only cmd0_cs_reg
    // no write to read only cmd0_trig_cs_reg
    // no write to read only cmd0_trig_word_counter_reg
    // no write to read only cmd0_ttl_reg
    // no write to read only cmd0_op_id_reg
    // no write to read only cmd1_trig_in_reg
    // no write to read only cmd2_trig_out_reg

always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_sw0_en_reg    <= 1'b0;
    else 
        write_sw0_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h6;
end


//SW can read and write 
// SW CMD_TTL
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw0_cmd_ttl_reg    <= 12'h0;
    else if(write_sw0_en_reg)
        sw0_cmd_ttl_reg    <= hwdata[17:6];
end


//SW can read and write 
// SW CMD_OP_ID
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw0_cmd_op_id_reg    <= 5'h0;
    else if(write_sw0_en_reg)
        sw0_cmd_op_id_reg    <= hwdata[5:1];
end


// SW can write 1, and it turns to 0 after an event
// SW CMD REQ
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw0_cmd_req_reg    <= 1'b0;
    else if(write_sw0_en_reg)
        sw0_cmd_req_reg    <= hwdata[0];
    else if(sw0_cmd_req_reg_clr_pls)
        sw0_cmd_req_reg    <= 1'b0;
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_sw1_en_reg    <= 1'b0;
    else 
        write_sw1_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h7;
end


//SW can read and write 
// SW CMD_TRIG IN
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw1_cmd_trig_in_reg    <= 24'h0;
    else if(write_sw1_en_reg)
        sw1_cmd_trig_in_reg    <= hwdata[23:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_sw2_en_reg    <= 1'b0;
    else 
        write_sw2_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h8;
end


//SW can read and write 
// SW CMD_TRIG OUT
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw2_cmd_trig_out_reg    <= 24'h0;
    else if(write_sw2_en_reg)
        sw2_cmd_trig_out_reg    <= hwdata[23:0];
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_sw3_en_reg    <= 1'b0;
    else 
        write_sw3_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'h9;
end


// SW can write 1, and it turns to 0 after an event
// SW MEM_ALLOC
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw3_mem_alloc_reg    <= 1'b0;
    else if(write_sw3_en_reg)
        sw3_mem_alloc_reg    <= hwdata[8];
    else if(sw3_mem_alloc_reg_clr_pls)
        sw3_mem_alloc_reg    <= 1'b0;
end


// SW can write 1, and it turns to 0 after an event
// SW FINISH_ACK
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw3_finish_ack_reg    <= 1'b0;
    else if(write_sw3_en_reg)
        sw3_finish_ack_reg    <= hwdata[7];
    else if(sw3_finish_ack_reg_clr_pls)
        sw3_finish_ack_reg    <= 1'b0;
end


//SW can read and write 
// SW FINISH REQ MASK
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw3_finish_req_mask_reg    <= 1'b0;
    else if(write_sw3_en_reg)
        sw3_finish_req_mask_reg    <= hwdata[6];
end


//SW can read and write 
// SW START_FRAMID
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw3_start_fid_reg    <= 2'h0;
    else if(write_sw3_en_reg)
        sw3_start_fid_reg    <= hwdata[5:4];
end


//SW can read and write 
// SW START_PIPO
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw3_start_pipo_reg    <= 3'h0;
    else if(write_sw3_en_reg)
        sw3_start_pipo_reg    <= hwdata[3:1];
end


// SW can write 1, and it turns to 0 after an event
// SW START REQ
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        sw3_start_reg    <= 1'b0;
    else if(write_sw3_en_reg)
        sw3_start_reg    <= hwdata[0];
    else if(sw3_start_reg_clr_pls)
        sw3_start_reg    <= 1'b0;
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        write_fidx_en_reg    <= 1'b0;
    else 
        write_fidx_en_reg    <= hsel & htrans[1] & hwrite & hreadyin & haddr[31:2] == 30'ha;
end


//SW can read and write 
// FRAME IDX DATA
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        fidx_data_reg    <= 8'h0;
    else if(write_fidx_en_reg)
        fidx_data_reg    <= hwdata[15:8];
end


// SW can write 1, and it turns to 0 after an event
// FRAME IDX WR EN
always@(posedge hclk or posedge hreset) begin
    if(hreset)
        fidx_en_reg    <= 1'b0;
    else if(write_fidx_en_reg)
        fidx_en_reg    <= hwdata[0];
    else if(fidx_en_reg_clr_pls)
        fidx_en_reg    <= 1'b0;
end

    // no write to read only sts0_ttl_counter_reg
    // no write to read only sts1_rc_update_reg
    // no write to read only sts1_rc_resume_reg
    // no write to read only sts2_wc_update_reg
    // no write to read only sts2_wc_resume_reg

always@(posedge hclk or posedge hreset) begin
    if(hreset)
        last_write  <= 1'b0;
    else
        last_write  <= ahb_write_en;
end


always@(posedge hclk or posedge hreset) begin
    if(hreset)
        hrdata      <= 32'h0;
    else if(ahb_read_en) begin
        hrdata      <= 32'h0;
        case(haddr[31:2]) 
            30'h0 : begin
                hrdata[1    ]    <= irq_status_fcnt_finish_reg;
                hrdata[0    ]    <= irq_status_pcnt_finish_reg;
            end
            30'h1 : begin
                hrdata[1    ]    <= irq_mask_fcnt_finish_reg;
                hrdata[0    ]    <= irq_mask_pcnt_finish_reg;
            end
            30'h2 : begin
                hrdata[1    ]    <= irq_enable_fcnt_finish_reg;
                hrdata[0    ]    <= irq_enable_pcnt_finish_reg;
            end
            30'h3 : begin
                hrdata[27:24]    <= cmd0_cs_reg;
                hrdata[23:21]    <= cmd0_trig_cs_reg;
                hrdata[20:17]    <= cmd0_trig_word_counter_reg;
                hrdata[16:5 ]    <= cmd0_ttl_reg;
                hrdata[4:0  ]    <= cmd0_op_id_reg;
            end
            30'h4 : begin
                hrdata[23:0 ]    <= cmd1_trig_in_reg;
            end
            30'h5 : begin
                hrdata[23:0 ]    <= cmd2_trig_out_reg;
            end
            30'h6 : begin
                hrdata[17:6 ]    <= sw0_cmd_ttl_reg;
                hrdata[5:1  ]    <= sw0_cmd_op_id_reg;
                hrdata[0    ]    <= sw0_cmd_req_reg;
            end
            30'h7 : begin
                hrdata[23:0 ]    <= sw1_cmd_trig_in_reg;
            end
            30'h8 : begin
                hrdata[23:0 ]    <= sw2_cmd_trig_out_reg;
            end
            30'h9 : begin
                hrdata[8    ]    <= sw3_mem_alloc_reg;
                hrdata[7    ]    <= sw3_finish_ack_reg;
                hrdata[6    ]    <= sw3_finish_req_mask_reg;
                hrdata[5:4  ]    <= sw3_start_fid_reg;
                hrdata[3:1  ]    <= sw3_start_pipo_reg;
                hrdata[0    ]    <= sw3_start_reg;
            end
            30'ha : begin
                hrdata[15:8 ]    <= fidx_data_reg;
                hrdata[0    ]    <= fidx_en_reg;
            end
            30'hb : begin
                hrdata[11:0 ]    <= sts0_ttl_counter_reg;
            end
            30'hc : begin
                hrdata[31:16]    <= sts1_rc_update_reg;
                hrdata[15:0 ]    <= sts1_rc_resume_reg;
            end
            30'hd : begin
                hrdata[31:16]    <= sts2_wc_update_reg;
                hrdata[15:0 ]    <= sts2_wc_resume_reg;
            end
        default:
            hrdata      <= 32'hdeadbeaf;
        endcase
    end
end

endmodule
