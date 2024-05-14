//==============================================================
//      Description
//==============================================================
//==================================================================
// synopsys translate_off
`timescale 1ns/1ps
// synopsys translate_on
module if_ddc #(
    parameter DDC_IF_FRAME_NUM = 10,//
    parameter DATA_WIDTH = 32
)
    (
    input   wire    i_sys_clk,
    input   wire    i_sys_rstn,
    input   wire    i_fv,
    input   wire    i_lv,
    input   wire    [DATA_WIDTH-1:0]i_data,
    //
    output  wire    o_fv,
    output  wire    o_lv,
    output  wire    [DATA_WIDTH-1:0]o_data    
);

reg r_fv_d1;
reg r_lv_d1;
reg [DATA_WIDTH-1:0]r_data_d1;
reg r_fv_d2;
reg r_lv_d2;
reg [DATA_WIDTH-1:0]r_data_d2;
reg [5:0]r_if_frame;
always @ (posedge i_sys_clk)
begin
    if(!i_sys_rstn)
    begin
        r_fv_d1    <= 'd0;
        r_if_frame <= 'd0;
    end
    else
    begin
        if({r_fv_d1,i_fv}==2'b01)
        begin
            if(r_if_frame == 6'd49)
            begin
                r_if_frame <= 'd0;                
            end
            else
            begin
                r_if_frame <= r_if_frame + 1'b1;   
            end 
        end
        r_fv_d1  <= i_fv;
        r_lv_d1  <= i_lv;
        r_data_d1<= i_data;
    end
end
//
always @ (posedge i_sys_clk)
begin
    if(DDC_IF_FRAME_NUM == 10)
    begin
        case(r_if_frame) 
        6'd1,6'd6,6'd11,6'd16,6'd21,6'd26,6'd31,6'd36,6'd41,6'd46 :begin
            r_fv_d2     <= r_fv_d1  ;
            r_lv_d2     <= r_lv_d1  ;
            r_data_d2   <= r_data_d1;
        end
        default:begin
            r_fv_d2     <= 'd0;
            r_lv_d2     <= 'd0;
            r_data_d2   <= 'd0;
        end
    endcase
    end
    else if(DDC_IF_FRAME_NUM == 16)
    begin
        case(r_if_frame)   
        6'd1,6'd4,6'd7,6'd10,6'd13,6'd16,6'd19,6'd22,6'd25,6'd28,6'd31,6'd34,6'd37,6'd40,6'd43,6'd47 :begin
            r_fv_d2     <= r_fv_d1  ;
            r_lv_d2     <= r_lv_d1  ;
            r_data_d2   <= r_data_d1;
        end
        default:begin
            r_fv_d2     <= 'd0;
            r_lv_d2     <= 'd0;
            r_data_d2   <= 'd0;    
        end     
    endcase
    end
end
assign o_fv     = r_fv_d2  ;
assign o_lv     = r_lv_d2  ;
assign o_data   = r_data_d2;
endmodule