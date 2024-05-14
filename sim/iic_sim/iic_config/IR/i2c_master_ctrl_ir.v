

module  i2c_master_ctrl_ir
#(
    parameter DIV_WIDTH    = 4,           // fre_clk/(2^DIV_WIDTH)
    parameter MAX_A_BYTE   = 2, 
    parameter MAX_D_BYTE   = 2
)( 
    input                           clk         ,
    input                           rst_n       ,

    inout                           scl         ,
    inout                           sda         ,
(*mark_debug = "true"*)    output  reg                     sda_oe      ,

    input                           i2c_en      ,      //1-cycle valid
(*mark_debug = "true"*)    input                           write_flag  ,
    input    [1:0]                  valid_a_bytes  ,
(*mark_debug = "true"*)    input    [1:0]                  valid_d_bytes  ,
    
    input       [6:0]               device_id          ,
    input       [MAX_A_BYTE*8-1:0]  i2c_reg_addr       ,
    input       [MAX_D_BYTE*8-1:0]  i2c_tx_data        ,
    output reg  [MAX_D_BYTE*8-1:0]  i2c_rx_data        ,
    output reg                      i2c_transfer_end   ,   //1-cycle valid
    output reg                      err_flag              
  	
  );


localparam      IDLE        = 4'b0000;    
localparam      START       = 4'b0001;    
localparam      WRITE_ID    = 4'b0010;    
localparam      WRITE_ADDR  = 4'b0011;    
localparam      WRITE_DATA  = 4'b0100;    
localparam      RE_START    = 4'b0101;    
localparam      RE_WRITE_ID = 4'b0110;    
localparam      READ_DATA   = 4'b0111;    
localparam      STOP        = 4'b1000;    
localparam      FINISH      = 4'b1001;    

//*****************************************************
//              signals declare
//*****************************************************
wire                    sdain;

reg                     r_scl;
reg                     r_sda;
reg                     sdain_dly1;
(*mark_debug = "true"*)reg                     sdain_dly2;

reg                     scl_dly1;
wire                    scl_rise;

(*mark_debug = "true"*)reg  [3             :0] next_state;
reg  [3             :0] current_state;
reg  [DIV_WIDTH     :0] div_cnt;
(*mark_debug = "true"*)reg  [3             :0] bit_cnt;
(*mark_debug = "true"*)reg  [5             :0] cycle_cnt;
wire                    cycle_cnt_en;

reg  [6             :0] shift_id;
reg  [MAX_D_BYTE*8-1:0] shift_datain;
reg  [MAX_A_BYTE*8-1:0] shift_addr;
reg  [MAX_D_BYTE*8-1:0] shift_dataout;

//*****************************************************
//              rtl body
//*****************************************************

always @(posedge clk)
begin
    sdain_dly1 <= sdain;
    sdain_dly2 <= sdain_dly1;
end
  
always @(posedge clk)
begin
    scl_dly1 <= r_scl;
end

assign scl_rise = r_scl && !scl_dly1;
 
always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        current_state <= IDLE;
    else
        current_state <= next_state;
end
 
always @(*)
begin
    if(!rst_n)
        next_state = IDLE;
    else case(current_state)
        IDLE:begin
            if(i2c_en)
                next_state = START;
            else
                next_state = IDLE;
        end
        START:begin
            if(div_cnt[DIV_WIDTH] == 1'b1)
                next_state = WRITE_ID;
            else
                next_state = START;
        end
        WRITE_ID:begin
            if(cycle_cnt == 4'ha)begin
                if(err_flag)
                    next_state = STOP;
                else
                    next_state = WRITE_ADDR;
            end
            else
                next_state = WRITE_ID;
        end
        WRITE_ADDR:begin
            if(cycle_cnt == valid_a_bytes * 10)
            begin
                if(write_flag)
                    next_state = WRITE_DATA;
                else
                    next_state = RE_START;
            end
            else
                next_state = WRITE_ADDR;
        end
        WRITE_DATA:begin
            if(cycle_cnt == valid_d_bytes * 10)
                next_state = STOP;
            else
                next_state = WRITE_DATA;
        end
        RE_START:begin
            if(div_cnt[DIV_WIDTH:DIV_WIDTH-2] == 3'b111)
                next_state = RE_WRITE_ID;
            else
                next_state = RE_START;
        end
        RE_WRITE_ID:begin
            if(cycle_cnt == 4'ha)begin
                if(err_flag)
                    next_state = STOP;
                else
                    next_state = READ_DATA;
            end
            else
                next_state = RE_WRITE_ID;
        end
        READ_DATA:begin
            if(cycle_cnt == (valid_d_bytes * 10))
                next_state = STOP;
            else
                next_state = READ_DATA;
        end
        STOP:begin
            if(div_cnt[DIV_WIDTH] == 1'b1)
                next_state = FINISH;
            else
                next_state = STOP;
        end
        FINISH:begin
                next_state = IDLE;
        end
        default:next_state = IDLE;
    endcase
end
  

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        div_cnt <= 0;
    else if(next_state != current_state)
        div_cnt <= 0;
    else case(next_state)
        START,WRITE_ID,WRITE_ADDR,WRITE_DATA,RE_START,RE_WRITE_ID,READ_DATA,STOP:
            div_cnt <= div_cnt + 1'b1;
        default:
            div_cnt <= 0;
    endcase
end

assign cycle_cnt_en = (div_cnt[DIV_WIDTH-1:0] == {(DIV_WIDTH){1'b1}});

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        bit_cnt <= 4'h0;
    else if(next_state != current_state)
        bit_cnt <= 4'h0;
    else case(next_state)
        WRITE_ID,WRITE_ADDR,WRITE_DATA,RE_WRITE_ID,READ_DATA:
        begin
            if(div_cnt[DIV_WIDTH-1:0] == {2'b00,{(DIV_WIDTH-2){1'b1}}})
            begin
                if(bit_cnt == 4'ha)
                    bit_cnt <= 4'h1;
                else
                    bit_cnt <= bit_cnt + 1'b1;
            end
            else
                bit_cnt <= bit_cnt;
        end
        default:
        begin
            bit_cnt <= 4'h0;
        end
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        cycle_cnt <= 0;
    else if(next_state != current_state)
        cycle_cnt <= 0;
    else case(next_state)
        WRITE_ID,RE_WRITE_ID:begin
            if(cycle_cnt_en)
            begin
                    cycle_cnt <= cycle_cnt + 1'b1;
            end
            else
                cycle_cnt <= cycle_cnt;
        end
        WRITE_ADDR:
        begin
            if(cycle_cnt_en)
            begin
                    cycle_cnt <= cycle_cnt + 1'b1;
            end
            else
                cycle_cnt <= cycle_cnt;
        end
        WRITE_DATA,READ_DATA:
        begin
            if(cycle_cnt_en)
            begin
                    cycle_cnt <= cycle_cnt + 1'b1;
            end
            else
                cycle_cnt <= cycle_cnt;
        end
        default:
        begin
            cycle_cnt <= 0;
        end
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        shift_id <= 0;
    else if(next_state == START || next_state == RE_START)
        shift_id <= device_id;
    else if(next_state == WRITE_ID || next_state == RE_WRITE_ID)
    begin
        if(cycle_cnt_en)
            shift_id <= {shift_id[5:0],1'b0};
        else
            shift_id <= shift_id;
    end
    else
        shift_id <= shift_id;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        shift_addr <= 0;
    else if(next_state == WRITE_ID || next_state == RE_WRITE_ID)
        shift_addr <= i2c_reg_addr;
    else if(next_state == WRITE_ADDR)
    begin
        if(cycle_cnt_en && (bit_cnt != 4'h9 && bit_cnt != 4'ha))
            shift_addr <= {shift_addr[MAX_A_BYTE*8-2:0],1'b0};
        else
            shift_addr <= shift_addr;
    end
    else
        shift_addr <= shift_addr;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        shift_dataout <= 0;
    else if(next_state == WRITE_ID || next_state == RE_WRITE_ID)
        shift_dataout <= i2c_tx_data;
    else if(next_state == WRITE_DATA)
    begin
        if(cycle_cnt_en && (bit_cnt != 4'h9 && bit_cnt != 4'ha))
            shift_dataout <= {shift_dataout[MAX_D_BYTE*8-2:0],1'b0};
        else
            shift_dataout <= shift_dataout;
    end
    else
        shift_dataout <= shift_dataout;
end


always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        r_scl <= 1'b1;
    else case(current_state)
        START:begin
            if(div_cnt[DIV_WIDTH-1] == 1'b1)
                r_scl <= 1'b0;
            else
                r_scl <= r_scl;
        end
        WRITE_ID,WRITE_ADDR,WRITE_DATA,RE_WRITE_ID,READ_DATA:begin
            if(bit_cnt != 4'ha)
                r_scl <= div_cnt[DIV_WIDTH-1];
            else
                r_scl <= 1'b0;
        end
        RE_START:begin
            if(div_cnt[DIV_WIDTH:DIV_WIDTH-1] == 2'b01)
                r_scl <= 1'b1;
            else if(div_cnt[DIV_WIDTH:DIV_WIDTH-1] == 2'b11)
                r_scl <= 1'b0;
            else
                r_scl <= r_scl;
        end
        default:r_scl <= 1'b1;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        r_sda <= 1'b1;
    else case(current_state)
        START:begin
            r_sda <= 1'b0;
        end
        WRITE_ID:begin
            if(div_cnt[DIV_WIDTH-1:DIV_WIDTH-2] == 2'b01)
                r_sda <= shift_id[6];
            else
                r_sda <= r_sda;
        end
        RE_WRITE_ID:begin
            if(div_cnt[DIV_WIDTH-1:DIV_WIDTH-2] == 2'b01)
            begin
                if(bit_cnt == 4'h8)
                begin
                    if(write_flag)
                        r_sda <= 1'b0;
                    else
                        r_sda <= 1'b1;
                end
                else
                    r_sda <= shift_id[6];
            end
            else
                r_sda <= r_sda;
        end
        WRITE_ADDR:begin
            if(div_cnt[DIV_WIDTH-1:DIV_WIDTH-2] == 2'b01)
            begin
                if(bit_cnt != 4'h9 && bit_cnt != 4'ha)
                    r_sda <= shift_addr[MAX_A_BYTE*8-1];
                else
                    r_sda <= 1'b0;
            end
            else
                r_sda <= r_sda;
        end
        WRITE_DATA:begin
            if(div_cnt[DIV_WIDTH-1:DIV_WIDTH-2] == 2'b01)
            begin
                if(bit_cnt != 4'h9 && bit_cnt != 4'ha)
                    r_sda <= shift_dataout[MAX_D_BYTE*8-1];
                else
                    r_sda <= 1'b0;
            end
            else
                r_sda <= r_sda;
        end
        RE_START:begin
            if(div_cnt[DIV_WIDTH] == 1'b1)
                r_sda <= 1'b0;
            else if(div_cnt == 0)
                r_sda <= 1'b1;
            else
                r_sda <= r_sda;
        end
        READ_DATA:begin
            if(bit_cnt == 4'h9)
            begin
                if(cycle_cnt == valid_d_bytes*10-2)
                    r_sda <= 1'b1;
                else
                    r_sda <= r_sda;
            end
            else
                r_sda <= 1'b0;
        end
        STOP:begin
            if(div_cnt[DIV_WIDTH-1] == 1'b1)
                r_sda <= 1'b1;
            else
                r_sda <= r_sda;
        end
        default:r_sda <= 1'b1;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        sda_oe <= 1'b1;
    else case(next_state)
        WRITE_ID,WRITE_ADDR,WRITE_DATA,RE_WRITE_ID:begin
            if(bit_cnt == 4'h9)
                sda_oe <= 1'b0;
            else
                sda_oe <= 1'b1;
        end
        READ_DATA:begin
            if(bit_cnt == 4'h9)
                sda_oe <= 1'b1;
            else
                sda_oe <= 1'b0;
        end
        default:sda_oe <= 1'b1;
    endcase
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        shift_datain <= 0;
    else if (next_state == IDLE)
        shift_datain <= 0;
    else if (next_state == READ_DATA)
    begin
        if(bit_cnt != 4'h9 && bit_cnt != 4'ha && scl_rise)
            shift_datain <= {shift_datain[MAX_D_BYTE*8-2:0],sdain_dly2};
        else
            shift_datain <= shift_datain;
    end
    else
        shift_datain <= shift_datain;
end

always @(posedge clk)
begin
    if(next_state == FINISH)
        i2c_rx_data <= shift_datain;
end

always @(posedge clk)
begin
    if(next_state == FINISH)
        i2c_transfer_end <= 1'b1;
    else
        i2c_transfer_end <= 1'b0;
end

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n)
        err_flag <= 1'b0;
    else case(current_state)
        FINISH:begin
            err_flag <= 1'b0;
        end
        WRITE_ID,WRITE_DATA,RE_WRITE_ID:begin
            if(scl_rise && sdain_dly2 && bit_cnt == 4'h9)
                err_flag <= 1'b1;
        end
        WRITE_ADDR:begin
            if(scl_rise && sdain_dly2 && bit_cnt == 4'h9 && cycle_cnt != (valid_a_bytes * 10-2))
                err_flag <= 1'b1;
        end
    endcase
end

assign sdaout = r_sda;
assign scl    = r_scl;

assign sdain = sda;
assign sda = sda_oe ? sdaout : 1'bz;
  
endmodule
