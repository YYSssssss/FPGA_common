/*  Simple FIFO */

module jb_prach_oran_request_fifo(
  input  wire           clk,
  input  wire           rst,
  input  wire           write,
  input  wire   [27:0]  write_data,
  input  wire           read,
  output logic  [27:0]  read_data,
  output logic          full,
  output logic          empty,
  output logic          overflow
  );
  
  localparam
    FULL_COUNT  = 5'd16,
    EMPTY_COUNT = 5'd0;
    
  logic   [4:0] count;
  logic   [3:0] waddr;
  logic   [3:0] raddr;
  
  always@(posedge clk) begin
    // Maintain occupancy counter...
    if (write && ~read && count < FULL_COUNT)
      count <= count + 1'd1;
    else if (~write && read && count > EMPTY_COUNT)
      count <= count - 1'd1;
    
    // Drive the FULL output flags...      
    if (write && ~read && count == FULL_COUNT - 1'd1)
      full <= 1'd1;
    else if (full && read)
      full <= 1'd0;
      
    // Drive the EMPTY output flags... 
    if (~write && read && count == EMPTY_COUNT + 1'd1)
      empty <= 1'd1;
    else if (empty && write)
      empty <=  1'd0;
    
    // Drive the output error flags...
    overflow <= 1'd0;
    if (full && write && ~read)
      overflow <= 1'd1;
        
    // Maintain read/write address pointers...
    if (write && ~full)
      waddr <= waddr + 4'd1;
      
    if (read && ~empty)
      raddr <= raddr + 4'd1;
        
    if (rst) begin
      full          <= 1'd0;
      empty         <= 1'd1;
      overflow      <= 1'd0;
      count         <= 5'd0;
      waddr         <= 4'd0;
      raddr         <= 4'd0;
    end
  end

  prach_oran_dmem_28x16
  prach_oran_dmem_28x16_inst(
    .a          (waddr),
    .d          (write_data),
    .dpra       (raddr),
    .clk        (clk),
    .we         (write),
    .dpo        (read_data)
  );
  
  
endmodule