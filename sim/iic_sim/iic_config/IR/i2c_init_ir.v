

module  i2c_init_ir( 
    input                           clk                     ,
    input                           rst_n                   ,

    inout                           scl                     ,
    inout                           sda                     ,
    
    input                           set_wr                  ,
    input  [7 :0]                   set_wrdev               ,
    input  [15:0]                   set_wraddr              ,
    input  [15:0]                   set_wrdata              ,

    output                          sda_oe                  ,
    output  reg                     init_done               ,
(*mark_debug = "true"*)    output                          i2c_transfer_end         
);

localparam INIT_DELAY_CYCLES = 16'hc000;
localparam I2C_NUM           = 60;//1105;

localparam IDLE             = 3'h0; 
localparam SET_EN           = 3'h1; 
localparam WAIT_END         = 3'h2; 
localparam DELAY_ST         = 3'h3;
localparam FINISH           = 3'h4;

//=====================================================
//              signals declare
//=====================================================

reg   [15:0]                    init_delay_cnt      ;
(*mark_debug = "true"*)reg   [ 2:0]                    main_state          ;
reg   [23:0]                    delay_cnt           ;

(*mark_debug = "true"*)wire                            i2c_en               ;      //1-cycle valid
(*mark_debug = "true"*)reg                             i2c_init_en          ;      //1-cycle valid
wire                            i2c_wr_flag          ;     
reg     [1:0]                   valid_d_bytes        ;
wire    [6:0]                   device_id            ;
wire    [15:0]                  i2c_reg_addr         ;
wire    [15:0]                  i2c_tx_data          ;

(*mark_debug = "true"*)reg     [10:0]                  lut_index           ;
wire    [39:0]                  lut_data            ;

wire                            err_flag            ;
reg                             err_flag_dly1       ;
(*mark_debug = "true"*)reg  [15:0]                     err_cnt             ;
(*mark_debug = "true"*)wire[15:0] i2c_rx_data;

//=====================================================
//              rtl body
//=====================================================



i2c_master_ctrl_ir
#(
    .DIV_WIDTH    (9),           // fre_clk/(2^DIV_WIDTH)
    .MAX_A_BYTE   ( 2), 
    .MAX_D_BYTE   ( 2)
)i2c_master_ctr_ir( 
    .clk                (clk),
    .rst_n              (rst_n),
    .scl                (scl),
    .sda                (sda),
    .sda_oe             (sda_oe),
    .i2c_en             (i2c_en             ),      //1-cycle valid
    .write_flag         (i2c_wr_flag        ),
    .valid_a_bytes      (2'h2               ),
    .valid_d_bytes      (valid_d_bytes      ),
    .device_id          (device_id          ),
    .i2c_reg_addr       (i2c_reg_addr       ),
    .i2c_tx_data        (i2c_tx_data        ),
    .i2c_rx_data        (i2c_rx_data),
    .i2c_transfer_end   (i2c_transfer_end   ),   //1-cycle valid
    .err_flag           (err_flag           )  
);

lut_sensor_36fps_ir lut_sensor_ir(
    .lut_index(lut_index),
    .lut_data (lut_data)
);


//init_done在lut_sra051中寄存器数据写入sensor后置1，然后将以太网传输过来的set_*数据写入到sensor�?
assign i2c_en       = init_done ? set_wr : i2c_init_en;
assign i2c_wr_flag  = init_done ? !set_wrdev[0] : !lut_data[32];
assign device_id    = init_done ? set_wrdev[7:1] : lut_data[39:33];
assign i2c_reg_addr = init_done ? set_wraddr : lut_data[31:16];
assign i2c_tx_data  = init_done ? set_wrdata : lut_data[15:0];

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        init_delay_cnt <= 0;
    else if(init_delay_cnt == INIT_DELAY_CYCLES)
        init_delay_cnt <= init_delay_cnt;
    else
        init_delay_cnt <= init_delay_cnt + 1'b1;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        main_state <= IDLE;
    else case(main_state)
        IDLE:begin
            if(init_delay_cnt == INIT_DELAY_CYCLES)
                main_state <= SET_EN;
            else
                main_state <= IDLE;
        end
        SET_EN:begin
            if(init_done)
                main_state <= FINISH;
            else 
                main_state <= WAIT_END;
        end
        WAIT_END:begin
            if(i2c_transfer_end)
            begin
                if(lut_index == I2C_NUM)
                    main_state <= FINISH;
                else if(lut_index == 2 || lut_index == 3 )
                    main_state <= DELAY_ST;
                else
                    main_state <= SET_EN;
            end
            else
                main_state <= WAIT_END;
        end
        DELAY_ST:begin
            if(delay_cnt == 24'h30000)
                main_state <= SET_EN;
            else
                main_state <= DELAY_ST;
        end
        FINISH:begin
            if(read_trigger && !read_trigger_dly1)
                main_state <= SET_EN;
            else
                main_state <= FINISH;
        end
        default:main_state <= FINISH;
    endcase
end

always @(posedge clk)
begin
    i2c_init_en <= (main_state == SET_EN);
end

always @(posedge clk)
begin
    if(main_state == DELAY_ST)
        delay_cnt <= delay_cnt + 1'b1;
    else
        delay_cnt <= 0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        lut_index <= 0;
    else if(i2c_transfer_end)
        lut_index <= lut_index + 1'b1;
end

always @(posedge clk)
begin
    //if(lut_index <= 17 || lut_index > I2C_NUM)
//    if(lut_index <= 17)
//        valid_d_bytes <= 2'h1;
//    else
//        valid_d_bytes <= 2'h2;
    if(device_id == 7'h6c)
        valid_d_bytes <= 2'h1;
    else
        valid_d_bytes <= 2'h1;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        init_done <= 1'b0;
    else if(main_state == FINISH)
        init_done <= 1'b1;
end


//====clk
wire read_trigger;
(*mark_debug = "true"*)reg read_trigger_dly1;

always @(posedge clk)
begin
    read_trigger_dly1 <= read_trigger;
end

always @(posedge clk)
begin
    err_flag_dly1 <= err_flag;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        err_cnt <= 16'h0;
    else if(err_flag && !err_flag_dly1)
        err_cnt <= err_cnt + 1'b1;
end


endmodule

