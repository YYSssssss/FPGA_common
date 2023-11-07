
module jb_prach_oran_alarm #(
  parameter NA  = 4,  /*  Number of antennae...               */
  parameter NC  = 2,  /*  Number of carriers...               */
  parameter WA  = 2,  /*  Width of antenna fields...          */
  parameter WC  = 1,  /*  Width of carrier fields...          */
  parameter CB  = 4
  )(
  input  wire               clk,
  input  wire               rst,
  input  wire               clear,
  
  input  wire                     prach_oran_tvalid,             /*  A request is made, but TREADY is deasserted...  */
  input  wire                     prach_oran_tready,
  output logic          [CB-1:0]  vld_wo_rdy_err_cnt_o,
  
  input  wire                     cplane_fifo_overflow,      /*  A request arrives but the FIFO is full...   */
  output logic          [CB-1:0]  cplane_fifo_ovfl_err_cnt_o,

  input  wire   [NA-1:0]          prach_fifo_overflow,
  output logic  [NA-1:0][CB-1:0]  prach_fifo_ovfl_err_cnt_o
  );
  
  import jb_prach_oran_pkg::*;

  /*  Rising-edge detect and fanout for CLEAR inputs... */
  localparam
    FANOUT_DEPTH  = 4;
 
  logic                                clear_0;
  logic                                clear_1;
  logic                                clear_rise;
  logic   [NA-1:0][FANOUT_DEPTH-1:0]   clear_fan;
    
  always@(posedge clk) begin
    /* Detect rising-edge on these control signals... */
    clear_0     <= clear;
    clear_1     <= clear_0;
    clear_rise  <= (clear_0 && ~clear_1); 
      
    /* Duplicate and allow FANOUT_DEPTH stages for timing closure...  */
    for (int k=0; k<NA; k++) begin
      clear_fan[k]  <= {clear_fan[k][FANOUT_DEPTH-2:0], clear_rise};
    end
  end

  /*
    A request is made, but TREADY is deasserted...  
  */
  localparam
    VLD_WO_RDY_THRESH = integer'($floor(500)),
    VLD_WO_RDY_WIDTH  = integer'($clog2(VLD_WO_RDY_THRESH)),
    VLD_WO_RDY_MAX    = integer'(2**VLD_WO_RDY_WIDTH);
    
  logic                           prach_oran_tready_i;
  logic                           prach_oran_tvalid_i;
  logic   [VLD_WO_RDY_WIDTH-1:0]  vld_wo_rdy_count;
  logic                           vld_wo_rdy_hold;
  logic                           vld_wo_rdy_err;
  logic                           vld_wo_rdy_err_0;
  logic                           vld_wo_rdy_err_r;
  logic   [CB-1:0]                vld_wo_rdy_err_cnt;
  
  always@(posedge clk) begin
    /*  Register inputs for timing ease... */
    prach_oran_tready_i <= prach_oran_tready;
    prach_oran_tvalid_i <= prach_oran_tvalid;
    
    if (~prach_oran_tvalid_i)
      vld_wo_rdy_count <= 1'd0;
    else if (prach_oran_tvalid_i && ~prach_oran_tready_i && ~vld_wo_rdy_hold)
      vld_wo_rdy_count <= vld_wo_rdy_count + 1'd1;
  
    vld_wo_rdy_hold <= 1'd0;
    if (vld_wo_rdy_count >= VLD_WO_RDY_MAX-2)
      vld_wo_rdy_hold <= 1'd1;
      
    vld_wo_rdy_err <= 1'd0;
    if (vld_wo_rdy_count > VLD_WO_RDY_THRESH-1)
      vld_wo_rdy_err <= 1'd1;
  
    vld_wo_rdy_err_r <= 1'd0;
    vld_wo_rdy_err_0 <= vld_wo_rdy_err;
    if (vld_wo_rdy_err && ~vld_wo_rdy_err_0)
      vld_wo_rdy_err_r <= 1'd1;
    
    /*  Register outputs for timing ease... */
    vld_wo_rdy_err_cnt_o <= vld_wo_rdy_err_cnt;
  end
  
  jb_prach_oran_alarm_counter #(
    .COUNTER_WIDTH (CB)
    )
    jb_prach_oran_alarm_counter_inst1(
      .clk          (clk),
      .rst          (rst),
      .alarm        (vld_wo_rdy_err_r),
      .alarm_count  (vld_wo_rdy_err_cnt),
      .clear        (clear_fan[0][FANOUT_DEPTH-1])
      );

  /*  
    A request arrives but the PRACH FIFO is full...   
  */
  logic   [NA-1:0]          prach_fifo_overflow_i;
  logic   [NA-1:0][CB-1:0]  prach_fifo_ovfl_err_cnt;
  
  always@(posedge clk) begin
    for (int k=0; k<NA; k++) begin
      /*  Register inputs for timing ease... */
      prach_fifo_overflow_i[k]   <=  prach_fifo_overflow[k];
    
      /*  Register outputs for timing ease... */
      prach_fifo_ovfl_err_cnt_o[k] <= prach_fifo_ovfl_err_cnt[k];
    end
  end

  genvar k;
  generate
    for (k=0; k<NA; k++)
      jb_prach_oran_alarm_counter #(
        .COUNTER_WIDTH (CB)
        )
        jb_prach_oran_alarm_counter_inst2(
          .clk          (clk),
          .rst          (rst),
          .alarm        (prach_fifo_overflow_i[k]),
          .alarm_count  (prach_fifo_ovfl_err_cnt[k]),
          .clear        (clear_fan[k][FANOUT_DEPTH-1])
          );
  endgenerate

  /*  
    A Type3 message arrives but the CPLANE FIFO is full...   
  */
  logic             cplane_fifo_overflow_i;
  logic   [CB-1:0]  cplane_fifo_ovfl_err_cnt;
  
  always@(posedge clk) begin
    /*  Register inputs for timing ease... */
    cplane_fifo_overflow_i   <=  cplane_fifo_overflow;
  
    /*  Register outputs for timing ease... */
    cplane_fifo_ovfl_err_cnt_o <= cplane_fifo_ovfl_err_cnt;
  end

  jb_prach_oran_alarm_counter #(
    .COUNTER_WIDTH (CB)
    )
    jb_prach_oran_alarm_counter_inst2(
      .clk          (clk),
      .rst          (rst),
      .alarm        (cplane_fifo_overflow_i),
      .alarm_count  (cplane_fifo_ovfl_err_cnt),
      .clear        (clear_fan[0][FANOUT_DEPTH-1])
      );

endmodule
