`timescale 1ns / 1ps

module jb_sym_mrkr_gen 
 (
    input         clk,              // i clock  
    input         clk_en,           // i clock enable           
    input         reset,            // i reset
    input         clk_frm_mrkr,     // Input clock for frame marker.  491.52MHz expected.
    input         reset_frm_mrkr,   // Reset for frame marker clock
    input         car_en,           // i car_en
    input         frm_mrkr,         // i 10ms frm_mrkr
    input [3:0]   ch_bw,            // i
    input         extended_cp,      // i
    
    // Real time signals
    output logic        frm_mrkr_out = 0,        // o frame marker aligned          ***
    output logic        sub_frame_mrkr = 0,      // o sub frame marker every 1ms
    output logic        slot_mrkr = 0,           // o slot marker                   ***
    output logic        sym_mrkr = 0,            // o symbol marker 
    output logic        sym_mrkr_pre,            // o symbol marker 1 prior
    output logic [2:0]  sym_cnt = 0,             // o symbol count
    output logic        cp_mrkr = 0,             // o CP marker
    output logic [4:0]  slot_cnt = 0,            // o slot count
    output logic [15:0] sample_cnt_per_slot = 0, // o sample_cnt_per slot 
    output logic [15:0] sample_cnt_per_sym = 0,  // o sample count per symbol
    
    
    // x4 signals for each symbol in each sym_mrkr.
    output logic        sym_mrkr_4x = 0,              // o symbol marker to start IFFT    ***
    output logic [15:0] sample_cnt_per_sym_4x = 0,    // o sample counter per symbol 4x   ***
    output logic [2:0]  sym_cnt_4x = 0,               // 4x symbol count                  ***
    output logic [15:0] sample_cnt_4x_per_slot = 0    // o sample count per slot

    );
     
logic        frm_mrkr_out_int;          // o frame marker aligned
logic [22:0] frm_mrkr_sample_cnt_int;   // o framer marker sample count
logic        sub_frame_mrkr_int;        // o sub frame marker every 1ms
logic [18:0] sub_frame_sample_cnt_int;  // o sub frame sample count
logic [3:0]  sub_frame_cnt_int;         // o sub frame count 0 to 9
logic        slot_mrkr_int;             // o slot marker
logic [17:0] slot_mrkr_sample_cnt_int;  // o slot marker sample count
logic [4:0]  slot_cnt_int;              // o slot count 0 to 19
logic        sym_mrkr_int;              // o symbol marker 
logic [15:0] sym_mrkr_sample_cnt_int;   // o symbol marker sample count
logic [2:0]  sym_cnt_int;               // o symbol count
logic        cp_mrkr_int;               // o CP marker
logic [15:0] fft_size = 0;
logic [15:0] start_symbol_0 = 0;
logic [15:0] start_symbol_1 = 0;
logic [15:0] start_symbol_2 = 0;
logic [15:0] start_symbol_3 = 0;
logic frame_marker = 0;
logic slot_marker = 0;
logic sub_frame_marker = 0;
logic sym_marker = 0;
logic cp_marker = 0;
logic frame_marker_d = 0;
logic slot_marker_d = 0;
logic sub_frame_marker_d = 0;
logic sym_marker_d = 0;
logic frm_mrkr_s, frm_mrkr_p;
logic frm_mrkr_p_d = 0;
logic frm_mrkr_p_2d = 0;
logic slot_mrkr_s, slot_mrkr_p;
logic slot_mrkr_p_d = 0;
logic slot_mrkr_p_2d = 0;
logic sub_frame_mrkr_s, sub_frame_mrkr_p;
logic sub_frame_mrkr_p_d = 0;
logic sub_frame_mrkr_p_2d = 0;
logic cp_mrkr_s, cp_mrkr_p;
logic cp_mrkr_int_d = 0;
logic cp_mrkr_int_2d = 0;
logic cp_mrkr_int_3d = 0;
logic cp_mrkr_int_4d = 0;
logic sym_mrkr_s, sym_mrkr_p;
logic sym_mrkr_p_d = 0;
logic sym_mrkr_p_2d = 0;
logic sym_mrkr_4x_int = 0;
logic [2:0] sym_cnt_int_d;
logic [2:0] sym_cnt_int_2d;
logic [2:0] sym_cnt_int_3d;
logic [2:0] sym_cnt_int_4d;
logic [4:0] slot_cnt_int_d;
logic [4:0] slot_cnt_int_2d;
logic [4:0] slot_cnt_int_3d;
logic [4:0] slot_cnt_int_4d;
logic [15:0] sym_mrkr_sample_cnt_int_div = 0;
logic [15:0] sym_mrkr_sample_cnt_int_div_d = 0;
logic [15:0] sym_mrkr_sample_cnt_int_div_2d = 0;
logic [15:0] sym_mrkr_sample_cnt_int_div_3d = 0;
logic [15:0] slot_mrkr_sample_cnt_int_div = 0;
logic [15:0] slot_mrkr_sample_cnt_int_div_d = 0; 
logic [15:0] slot_mrkr_sample_cnt_int_div_2d = 0; 
logic [15:0] slot_mrkr_sample_cnt_int_div_3d = 0; 
logic [15:0] sym_mrkr_sample_cnt_4x_int_div = '{default:'1};
logic [15:0] sym_mrkr_sample_cnt_4x_int_div_d = '{default:'1};
logic [15:0] sym_mrkr_sample_cnt_4x_int_div_2d = '{default:'1};
logic [15:0] sym_mrkr_sample_cnt_4x_int_div_3d = '{default:'1};
logic [15:0] slot_mrkr_sample_cnt_4x_int_div = 0;
logic [15:0] slot_mrkr_sample_cnt_4x_int_div_d = 0; 
logic [15:0] slot_mrkr_sample_cnt_4x_int_div_2d = 0; 
logic [15:0] slot_mrkr_sample_cnt_4x_int_div_3d = 0; 


jb_marker_generation #(
    .CLOCK_PERIOD   (2.03450521)  //491.52 => 2.03450521  122.88 => 8.13802083  156.25 => 6.4 368.68Mhz => 2.7123793 245.76 => 4.06901042
) jb_marker_generation_inst (
    .clk(clk_frm_mrkr),
    .reset(reset_frm_mrkr),
    .car_en(car_en),
    .frm_mrkr(frm_mrkr),
    .extended_cp(extended_cp),    
    
     // real time indicators at clk input rate of 491.52Mhz
    .frm_mrkr_out(frm_mrkr_out_int),                 // o 10ms Frame Marker aligned
    .frm_mrkr_sample_cnt(frm_mrkr_sample_cnt_int),   // o framer marker sample count [22:0]
    .sub_frame_mrkr(sub_frame_mrkr_int),             // o sub frame marker every 1ms
    .sub_frame_sample_cnt(sub_frame_sample_cnt_int), // o sub frame sample count [18:0]
    .sub_frame_cnt(sub_frame_cnt_int),               // o sub frame count 0 to 9 [3:0]
    .slot_mrkr(slot_mrkr_int),                       // o slot marker 0.5ms
    .slot_mrkr_sample_cnt(slot_mrkr_sample_cnt_int), // o slot marker sample count [17:0]
    .slot_cnt(slot_cnt_int),                         // o slot count 0 to 19 [4:0]
    .sym_mrkr(sym_mrkr_int),                         // o symbol marker  
    .sym_mrkr_sample_cnt(sym_mrkr_sample_cnt_int),   // o symbol marker sample count [15:0]
    .sym_cnt(sym_cnt_int),                           // o symbol count [2:0]
    .cp_mrkr(cp_mrkr_int)                            // o cp marker
);   


// extend frame marker and double register.

//  For 20MHz or 15Mhz.  Need to extend it 4 times. clk is 491.52MHz with an enable every 4th clock. 
//  For 10MHz need to extend 8 enable is every 8th clock
//  For 5MHz  need to extend 16 enable is every 16th clock
jb_edge_det #(
        .SYNC_EN            (0),
        .SYNC_STAGES        (2),
        .EDGES              (1),
        .PULSE_WIDTH        (16),  // Largest length for clk_en for 5Mhz.  Every 16th clcok
        .PULSE_POLARITY     (1),
        .RETIME_OUTPUT      (1)
    ) fm_edge_det_over_range_u1 (
        .clk                (clk_frm_mrkr),
        .mask               (1'b0),
        .din                (frm_mrkr_out_int),
        .din_syncd          (frm_mrkr_s),
        .dout               (frm_mrkr_p)
    );

jb_edge_det #(
        .SYNC_EN            (0),
        .SYNC_STAGES        (2),
        .EDGES              (1),
        .PULSE_WIDTH        (16),  // Largest length for clk_en for 5Mhz.  Every 16th clcok
        .PULSE_POLARITY     (1),
        .RETIME_OUTPUT      (1)
    ) slm_edge_det_over_range_u1 (
        .clk                (clk_frm_mrkr),
        .mask               (1'b0),
        .din                (slot_mrkr_int),
        .din_syncd          (slot_mrkr_s),
        .dout               (slot_mrkr_p)
    );
    
jb_edge_det #(
        .SYNC_EN            (0),
        .SYNC_STAGES        (2),
        .EDGES              (1),
        .PULSE_WIDTH        (16),  // Largest length for clk_en for 5Mhz.  Every 16th clcok
        .PULSE_POLARITY     (1),
        .RETIME_OUTPUT      (1)
    ) sfm_edge_det_over_range_u1 (
        .clk                (clk_frm_mrkr),
        .mask               (1'b0),
        .din                (sub_frame_mrkr_int),
        .din_syncd          (sub_frame_mrkr_s),
        .dout               (sub_frame_mrkr_p)
    );

jb_edge_det #(
        .SYNC_EN            (0),
        .SYNC_STAGES        (2),
        .EDGES              (1),
        .PULSE_WIDTH        (16),  // Largest length for clk_en for 5Mhz.  Every 16th clcok
        .PULSE_POLARITY     (1),
        .RETIME_OUTPUT      (1)
    ) sym_edge_det_over_range_u1 (
        .clk                (clk_frm_mrkr),
        .mask               (1'b0),
        .din                (sym_mrkr_int),
        .din_syncd          (sym_mrkr_s),
        .dout               (sym_mrkr_p)
    );

jb_edge_det #(
        .SYNC_EN            (0),
        .SYNC_STAGES        (2),
        .EDGES              (1),
        .PULSE_WIDTH        (16),  // Largest length for clk_en for 5Mhz.  Every 16th clcok
        .PULSE_POLARITY     (1),
        .RETIME_OUTPUT      (1)
    ) cm_edge_det_over_range_u1 (
        .clk                (clk_frm_mrkr),
        .mask               (1'b0),
        .din                (cp_mrkr_int),
        .din_syncd          (cp_mrkr_s),
        .dout               (cp_mrkr_p)
    );
    
// Register with clock enable
always_ff @(posedge clk) begin
    if(clk_en) begin 
        frm_mrkr_p_d <= frm_mrkr_p;
        frm_mrkr_p_2d <= frm_mrkr_p_d;
        if (~frm_mrkr_p_2d && frm_mrkr_p_d) frame_marker <= 1;   // rising edge
        else frame_marker <= 0;    
    end
end

always_ff @(posedge clk) begin
    if(clk_en) begin 
        slot_mrkr_p_d <= slot_mrkr_p;
        slot_mrkr_p_2d <= slot_mrkr_p_d;
        if (~slot_mrkr_p_2d && slot_mrkr_p_d) slot_marker <= 1;   // rising edge
        else slot_marker <= 0;    
    end
end

always_ff @(posedge clk) begin
    if(clk_en) begin 
        sub_frame_mrkr_p_d <= sub_frame_mrkr_p;
        sub_frame_mrkr_p_2d <= sub_frame_mrkr_p_d;
        if (~sub_frame_mrkr_p_2d && sub_frame_mrkr_p_d) sub_frame_marker <= 1;   // rising edge
        else sub_frame_marker <= 0;    
    end
end

always_ff @(posedge clk) begin
    if(clk_en) begin 
        sym_mrkr_p_d <= sym_mrkr_p;
        sym_mrkr_p_2d <= sym_mrkr_p_d;
        if (~sym_mrkr_p_2d && sym_mrkr_p_d) sym_marker <= 1;   // rising edge
        else sym_marker <= 0;    
    end
end

always_ff @(posedge clk_frm_mrkr) begin
        cp_mrkr_int_d <= cp_mrkr_int;
        sym_cnt_int_d <= sym_cnt_int;
        slot_cnt_int_d <= slot_cnt_int;
end


// Create sym_mrkr_4x and sample_cnt_per_sym_4x
// Mark Symbol start  
always_ff @(posedge clk) begin
    if (clk_en) begin
        case (ch_bw) 
            4'b0000 : fft_size <= 16'd2048; //20MHz 
            4'b0001 : fft_size <= 16'd1024; //10Mhz 
            4'b0010 : fft_size <= 16'd512;  //5Mhz 
            4'b0011 : fft_size <= 16'd2048; //15MHz 
            default : fft_size <= 16'd2048;
        endcase 
    end
end

always_ff @(posedge clk_frm_mrkr) begin
        case (ch_bw) 
            4'b0000 : begin 
                      sym_mrkr_sample_cnt_4x_int_div <= sym_mrkr_sample_cnt_int >> 2; //20MHz
                      slot_mrkr_sample_cnt_4x_int_div <= slot_mrkr_sample_cnt_int >> 2;
                      slot_mrkr_sample_cnt_int_div <= slot_mrkr_sample_cnt_int >> 4;
                      sym_mrkr_sample_cnt_int_div <= sym_mrkr_sample_cnt_int >> 4;
                      end 
            4'b0001 : begin 
                      sym_mrkr_sample_cnt_4x_int_div <= sym_mrkr_sample_cnt_int >> 3; //10Mhz
                      slot_mrkr_sample_cnt_4x_int_div <= slot_mrkr_sample_cnt_int >> 3;
                      slot_mrkr_sample_cnt_int_div <= slot_mrkr_sample_cnt_int >> 5;
                      sym_mrkr_sample_cnt_int_div <= sym_mrkr_sample_cnt_int >> 5;
                      end 
            4'b0010 : begin
                      sym_mrkr_sample_cnt_4x_int_div <= sym_mrkr_sample_cnt_int >> 4; //5Mhz
                      slot_mrkr_sample_cnt_4x_int_div <= slot_mrkr_sample_cnt_int >> 4;
                      slot_mrkr_sample_cnt_int_div <= slot_mrkr_sample_cnt_int >> 6;
                      sym_mrkr_sample_cnt_int_div <= sym_mrkr_sample_cnt_int >> 6;
                      end 
            4'b0011 : begin 
                      sym_mrkr_sample_cnt_4x_int_div <= sym_mrkr_sample_cnt_int >> 2; //15MHz
                      slot_mrkr_sample_cnt_4x_int_div <= slot_mrkr_sample_cnt_int >> 2;
                      slot_mrkr_sample_cnt_int_div <= slot_mrkr_sample_cnt_int >> 4;
                      sym_mrkr_sample_cnt_int_div <= sym_mrkr_sample_cnt_int >> 4;
                      end 
            default : begin
                      sym_mrkr_sample_cnt_4x_int_div <= sym_mrkr_sample_cnt_int >> 2;
                      slot_mrkr_sample_cnt_4x_int_div <= slot_mrkr_sample_cnt_int >> 2;
                      slot_mrkr_sample_cnt_int_div <= slot_mrkr_sample_cnt_int >> 4;
                      sym_mrkr_sample_cnt_int_div <= sym_mrkr_sample_cnt_int >> 4;
                      end
        endcase 
end

always_ff @(posedge clk) begin  // adding the one sample  in between symbols  CP time is at the end.
    if (clk_en) begin // since CP is at after IFFT this should be the same regardless of extended or normal CP
        start_symbol_0 <= 'd0;
        start_symbol_1 <= (fft_size) + 'd1;
        start_symbol_2 <= {fft_size,1'd0} + 'd2;
        start_symbol_3 <= fft_size*3 + 'd3;
    end
end

always_ff @(posedge clk) begin
    if(clk_en) begin 
        if ((sym_mrkr_sample_cnt_4x_int_div_2d == start_symbol_0) || (sym_mrkr_sample_cnt_4x_int_div_2d == start_symbol_1) || (sym_mrkr_sample_cnt_4x_int_div_2d == start_symbol_2) || (sym_mrkr_sample_cnt_4x_int_div_2d == start_symbol_3))
             sym_mrkr_4x_int <= 1;
        else sym_mrkr_4x_int <= 0;
    end
end

always_ff @(posedge clk) begin
    if(clk_en) begin         
        frame_marker_d <= frame_marker;
        frm_mrkr_out <= frame_marker_d;
        slot_marker_d <= slot_marker; 
        slot_mrkr <= slot_marker_d; 
        sub_frame_marker_d <= sub_frame_marker;
        sub_frame_mrkr <= sub_frame_marker_d;        
        sym_marker_d <= sym_marker;
        sym_mrkr <= sym_marker_d;
        cp_mrkr_int_2d <= cp_mrkr_int_d;
        cp_mrkr_int_3d <= cp_mrkr_int_2d;
        cp_mrkr_int_4d <= cp_mrkr_int_3d;
        cp_mrkr <= cp_mrkr_int_4d;
        slot_mrkr_sample_cnt_int_div_d <= slot_mrkr_sample_cnt_int_div;
        slot_mrkr_sample_cnt_int_div_2d <= slot_mrkr_sample_cnt_int_div_d;
        slot_mrkr_sample_cnt_int_div_3d <= slot_mrkr_sample_cnt_int_div_2d;
        sample_cnt_per_slot <= slot_mrkr_sample_cnt_int_div_3d;
        sym_mrkr_sample_cnt_int_div_d <= sym_mrkr_sample_cnt_int_div;
        sym_mrkr_sample_cnt_int_div_2d <= sym_mrkr_sample_cnt_int_div_d;
        sym_mrkr_sample_cnt_int_div_3d <= sym_mrkr_sample_cnt_int_div_2d;
        sample_cnt_per_sym <= sym_mrkr_sample_cnt_int_div_3d;
        sym_mrkr_sample_cnt_4x_int_div_d <= sym_mrkr_sample_cnt_4x_int_div;
        sym_mrkr_sample_cnt_4x_int_div_2d <= sym_mrkr_sample_cnt_4x_int_div_d;
        sym_mrkr_sample_cnt_4x_int_div_3d <= sym_mrkr_sample_cnt_4x_int_div_2d;
        sample_cnt_per_sym_4x <= sym_mrkr_sample_cnt_4x_int_div_3d;
        slot_mrkr_sample_cnt_4x_int_div_d <= slot_mrkr_sample_cnt_4x_int_div;
        slot_mrkr_sample_cnt_4x_int_div_2d <= slot_mrkr_sample_cnt_4x_int_div_d;
        slot_mrkr_sample_cnt_4x_int_div_3d <= slot_mrkr_sample_cnt_4x_int_div_2d;
        sample_cnt_4x_per_slot <= slot_mrkr_sample_cnt_4x_int_div_3d;
        sym_mrkr_4x <= sym_mrkr_4x_int;
        sym_cnt_int_2d <= sym_cnt_int_d;
        sym_cnt_int_3d <= sym_cnt_int_2d;
        sym_cnt_int_4d <= sym_cnt_int_3d;
        sym_cnt <= sym_cnt_int_4d;
        slot_cnt_int_2d <= slot_cnt_int_d;
        slot_cnt_int_3d <= slot_cnt_int_2d;
        slot_cnt_int_4d <= slot_cnt_int_3d;
        slot_cnt <= slot_cnt_int_4d;
    end
end

assign sym_mrkr_pre = sym_marker_d;


//Count symbols 4x
always_ff @(posedge clk) begin
    if(clk_en) begin 
        if(sym_mrkr_4x_int & slot_marker_d) sym_cnt_4x <= 0;
        else if (sym_mrkr_4x_int && (sym_cnt_4x == 3)) sym_cnt_4x <= 0; 
        else if (sym_mrkr_4x_int) sym_cnt_4x <= sym_cnt_4x + 1;
    end
end

endmodule
