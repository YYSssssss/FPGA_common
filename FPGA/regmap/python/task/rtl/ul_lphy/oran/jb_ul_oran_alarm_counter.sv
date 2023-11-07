

module jb_ul_oran_alarm_counter #(
  parameter COUNTER_WIDTH  = 8
  )(
  input  wire                         clk,
  input  wire                         rst,
  input  wire                         alarm,
  output logic  [COUNTER_WIDTH-1:0]   alarm_count,
  input  wire                         clear
  );
  
  localparam 
    COUNTER_MAXIMUM  = 2**COUNTER_WIDTH;
 
  logic             alarm_hold;
  
  always@(posedge clk) begin
    if (alarm && ~alarm_hold)
      if (clear)
        alarm_count <= 1'd1;
      else
        alarm_count <= alarm_count + 1'd1;
    else if (clear)
      alarm_count <= 1'd0;
  
    alarm_hold <= 1'd0;
    if (alarm_count >= COUNTER_MAXIMUM-2)
      alarm_hold <= 1'd1;
      
    if (rst) begin
      alarm_count <= 1'd0;
    end
  end

endmodule
