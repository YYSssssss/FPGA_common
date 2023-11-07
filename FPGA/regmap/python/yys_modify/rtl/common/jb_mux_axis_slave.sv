`timescale 1ns / 1ps

module jb_mux_axi4_streams #(
    parameter   IF_TYPE         = 0         // Interface Type (0 = Slaves, 1 = Masters)
) (
    input                       sel,
    jb_axi4_stream_if.slave     s0,
    jb_axi4_stream_if.slave     s1,
    jb_axi4_stream_if.master    m
);

    localparam BAND_25 = 0;
    localparam BAND_66 = 0;
    
    // ------------------------------------------------------------------ //
    // Slave mux logic                                                    //
    // ------------------------------------------------------------------ //

    assign  s0.tready   = (sel == 0) ? m.tready : 0;
    assign  s1.tready   = (sel == 1) ? m.tready : 0;
    
    assign  m.tuser     = (sel == 0) ? s0.tuser     : s1.tuser;
    assign  m.tkeep     = (sel == 0) ? s0.tkeep     : s1.tkeep;
    assign  m.tdata     = (sel == 0) ? s0.tdata     : s1.tdata;
    assign  m.tvalid    = (sel == 0) ? s0.tvalid    : s1.tvalid;
    assign  m.tlast     = (sel == 0) ? s0.tlast     : s1.tlast;
    
endmodule

