
`timescale 1ns / 1ps

module jb_iq_slew_err_det #(
    IQ_PRECISION    = 16
) (
    input                                       clk,
    input                                       resetn,
    input           [IQ_PRECISION*2-1:0]        iq_current,             // {q,i}
    input           [IQ_PRECISION*2-1:0]        iq_previous,            // {q,i}
    input           [32:0]                      iq_slew_threshold,
    output  logic                               iq_slew_error
);

    // ------------------------------------------------------------------ //
    // Internal Signals                                                   //
    // ------------------------------------------------------------------ //
    logic   signed  [IQ_PRECISION-1:0]          q_curr=0,     i_curr=0;     // 16 bits
    logic   signed  [IQ_PRECISION-1:0]          q_prev=0,     i_prev=0;     // 16 bits
//    logic   signed  [IQ_PRECISION+1-1:0]        q_diff,     i_diff;     // 17 bits
    logic   signed  [IQ_PRECISION+1-1:0]        q_diff=0,     i_diff=0;     // 17 bits

    logic           [IQ_PRECISION-1:0]          q_diff_mag, i_diff_mag; // 16 bits
    logic                                       q_diff_sign,i_diff_sign;
    logic           [IQ_PRECISION*2-1:0]        q_diff_sq,  i_diff_sq;  // 32 bits
    logic           [IQ_PRECISION*2+1-1:0] 	    iq_diff_sq_sum=0;         // 33 bits
    logic           [IQ_PRECISION*2+1-1:0]      iq_slew_sq;             // 33 bits

    // ------------------------------------------------------------------ //
    // Slew Rate                                                          //
    // ------------------------------------------------------------------ //
    always_ff @(posedge clk) begin
//        if (!resetn) begin
//            i_curr  <= $signed (0);
//            q_curr  <= $signed (0);
//            i_prev  <= $signed (0);
//            q_prev  <= $signed (0);
//        end
//        else begin
            i_curr  <= $signed (iq_current  [IQ_PRECISION-1:0]);
            q_curr  <= $signed (iq_current  [IQ_PRECISION*2-1:IQ_PRECISION]);
            i_prev  <= $signed (iq_previous [IQ_PRECISION-1:0]);
            q_prev  <= $signed (iq_previous [IQ_PRECISION*2-1:IQ_PRECISION]);
//        end
    end

//    assign i_diff       = i_prev - i_curr;
//    assign q_diff       = q_prev - q_curr;

always @(posedge clk) begin
  i_diff <= i_prev - i_curr;
  q_diff <= q_prev - q_curr;
end

    assign i_diff_sign  = i_diff[IQ_PRECISION+1-1];
    assign q_diff_sign  = q_diff[IQ_PRECISION+1-1];
    assign i_diff_mag   = i_diff_sign ? -i_diff : i_diff;
    assign q_diff_mag   = q_diff_sign ? -q_diff : q_diff;


//    mult_16x16 i_diff_sq_u0 (
//        .A          (i_diff_mag),
//        .B          (i_diff_mag),
//        .CLK        (clk),
//        .P          (i_diff_sq)
//    );
//    
//    mult_16x16 q_diff_sq_u0 (
//        .A          (q_diff_mag),
//        .B          (q_diff_mag),
//        .CLK        (clk),
//        .P          (q_diff_sq)
//    );
    mult_16x16_timing i_diff_sq_u0 (
        .A          (i_diff_mag),
        .B          (i_diff_mag),
        .CLK        (clk),
        .P          (i_diff_sq)
    );
    
    mult_16x16_timing q_diff_sq_u0 (
        .A          (q_diff_mag),
        .B          (q_diff_mag),
        .CLK        (clk),
        .P          (q_diff_sq)
    );

    always_ff @(posedge clk) begin
//        if (!resetn)
//            iq_diff_sq_sum <= 0;
//        else
            iq_diff_sq_sum <= i_diff_sq + q_diff_sq;    // 34 + 1
    end

    assign iq_slew_sq = iq_diff_sq_sum;

    // When operands are of unequal bit length, the shorter operand is
    // zero-filled in the MSB position.
    assign iq_slew_error = (iq_slew_sq[IQ_PRECISION*2+1-1:16] > iq_slew_threshold[32:16]);


endmodule

