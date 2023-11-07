/*  Simple FIFO */

module jb_ul_oran_request_fifo(
  input  wire           clk,
  input  wire           rst,
  input  wire           write,
  input  wire   [23:0]  write_data,
  input  wire           read,
  output logic  [23:0]  read_data,
  output logic          full,
  output logic          almost_full,
  output logic          empty,
  output logic          almost_empty,
  output logic          overflow,
  output logic          underflow
  );
  
  localparam
    FULL_COUNT  = 6'd32,
    EMPTY_COUNT = 6'd0;
    
  logic   [5:0] count;
  logic   [4:0] waddr;
  logic   [4:0] raddr;
  
  always@(posedge clk) begin
    // Maintain occupancy counter...
    if (write && ~read && count < FULL_COUNT)
      count <= count + 1'd1;
    else if (~write && read && count > EMPTY_COUNT)
      count <= count - 1'd1;
    
    // Drive the FULL output flags...
    if (write && ~read && count == FULL_COUNT - 2'd2)
      almost_full <= 1'd1;
    else if (almost_full && ~write && read && count == FULL_COUNT - 2'd1)
      almost_full <= 1'd0;
      
    if (write && ~read && count == FULL_COUNT - 1'd1)
      full <= 1'd1;
    else if (full && read)
      full <= 1'd0;
      
    // Drive the EMPTY output flags...
    if (~write && read && count == EMPTY_COUNT + 2'd2)
      almost_empty <= 1'd1;
    else if (almost_empty && write && ~read && count == EMPTY_COUNT + 2'd1)
      almost_empty <= 1'd0;
    
    if (~write && read && count == EMPTY_COUNT + 1'd1)
      empty <= 1'd1;
    else if (empty && write)
      empty <=  1'd0;
    
    // Drive the output error flags...
    overflow <= 1'd0;
    if (full && write && ~read)
      overflow <= 1'd1;
    
    underflow <= 1'd0;
    if (empty && read)
      underflow <= 1'd1;
    
    // Maintain read/write address pointers...
    if (write && ~full)
      waddr <= waddr + 5'd1;
      
    if (read && ~empty)
      raddr <= raddr + 5'd1;
        
    if (rst) begin
      full          <= 1'd0;
      almost_full   <= 1'd0;
      empty         <= 1'd1;
      almost_empty  <= 1'd1;
      overflow      <= 1'd0;
      underflow     <= 1'd0;
      count         <= 6'd0;
      waddr         <= 5'd0;
      raddr         <= 5'd0;
    end
  end

  ul_oran_dmem_24x32
  ul_oran_dmem_24x32_inst(
    .a          (waddr),
    .d          (write_data),
    .dpra       (raddr),
    .clk        (clk),
    .we         (write),
    .dpo        (read_data)
  );
  
  
endmodule