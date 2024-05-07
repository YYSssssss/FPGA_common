module tpram_syn #(
  parameter TYPE = "RAM",
  parameter VT = "LVT",
  parameter UHD = "",
  parameter CM = "4",
  parameter SEG = "F",
  parameter DATA_DEPTH = 16,
  parameter DATA_WIDTH = 64,
  parameter RD_DELAY = 1,
  parameter ADDR_WIDTH = (DATA_DEPTH>1)? $clog2(DATA_DEPTH): 1
)(
  input  [ADDR_WIDTH-1:0]  addra,    
  input  [ADDR_WIDTH-1:0]  addrb, 
  input  [DATA_WIDTH-1:0]  bwea,
  input                    clka,
  input                    clkb,
  input  [DATA_WIDTH-1:0]  dina,
  output [DATA_WIDTH-1:0]  doutb,
  input                    enb,  
  input                    wena
);

integer i;

reg [DATA_WIDTH-1:0] register[DATA_DEPTH-1:0];

reg [DATA_WIDTH-1:0] data_rd_r[0:RD_DELAY-1];

//Data Write
always @(posedge clka)
  if (wena) begin
    for (i=0; i<DATA_WIDTH; i=i+1) begin
      if (bwea[i]) begin
        register[addra][i] <= dina[i];
      end
    end
  end

//Data Read, RD_DELAY clk delay
always @(posedge clkb)
  if (enb) begin
    data_rd_r[0] <= register[addrb];
  end

always @(posedge clkb)
  begin
    for(i=0; i<RD_DELAY-1;i=i+1)
      data_rd_r[i+1] <= data_rd_r[i];
  end

assign doutb = data_rd_r[RD_DELAY-1];

endmodule