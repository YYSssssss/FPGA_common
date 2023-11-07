
module jb_dbgmux_mem #(
  parameter unsigned BD_LATENCY_SETTING  = 15   // This needs to be at least 12
  )(
  input  wire           axi_clk,
  input  wire           axi_rst,
  input  wire           axi_en,
  input  wire    [7:0]  axi_we,
  input  wire   [19:0]  axi_addr,
  input  wire   [63:0]  axi_din,
  output logic  [63:0]  axi_dout,
  
  
  input  wire           dbg_clk,
  input  wire           dbg_rst,
  input  wire           dbg_en,
  input  wire    [7:0]  dbg_we,
  input  wire   [19:0]  dbg_addr,
  input  wire   [63:0]  dbg_din,
  output logic  [63:0]  dbg_dout
  );
  
  localparam
    DELAY = BD_LATENCY_SETTING - 1;

  typedef enum logic[1:0]{
    IDLE,
    READ,
    WAIT
    } arb_states_t;
    
  logic   [DELAY-1:0] axi_pipe;
  logic               axi_rd;
  logic        [63:0] axi_dout_q;
  
  logic               fifo_rd;
  logic        [91:0] fifo_dout;
  logic               fifo_empty;
  logic        [91:0] fifo_dout_0;
  logic               fifo_empty_0;
        
  arb_states_t        arb_state;
  logic               arb_en   ;
  logic         [7:0] arb_we   ;
  logic        [19:0] arb_addr ;
  logic        [63:0] arb_din  ;
  
  logic               temp_arb_en  ;
  logic         [7:0] temp_arb_we  ;
  logic        [19:0] temp_arb_addr;
  logic        [63:0] temp_arb_din ;

  logic               temp_dbg_en  ;
  logic         [7:0] temp_dbg_we  ;
  logic        [19:0] temp_dbg_addr;
  logic        [63:0] temp_dbg_din ;
  
  logic        [63:0] arb_dout ;
  
  logic        [63:0] fifo_din;
  logic        [63:0] fifo_din_temp;
  logic               fifo_wr ; 
  logic         [9:0] arb_pipe;

  // Delay AXI_EN to aligh with where read data must be available...
  // Read data on AXI_DOUT must be available BD_LATENCY_SETTING cycles after the AXI_EN
  // This BD_LATENCY_SETTING is set in the BRAM Controller in the Block Design, and should be at least 12.
  always@(posedge axi_clk) begin
    axi_pipe <= {axi_pipe[DELAY-2:0], axi_en};
    //if (axi_rd)
    //  axi_dout <= axi_dout_q;
  end
	
  assign axi_rd   = axi_pipe[DELAY-1];
  assign axi_dout = axi_dout_q;
  
  dbgmux_fifo_90x16
  dbgmux_fifo_90x16_inst (
    .wr_clk (axi_clk),
    .rd_clk (dbg_clk),
    .din    ({axi_din, axi_addr, axi_we}),
    .wr_en  (axi_en),
    .rd_en  (fifo_rd),
    .dout   (fifo_dout),
    .full   (),
    .empty  (fifo_empty)
    );
  
  dbgmux_fifo_64x16
  dbgmux_fifo_64x16_inst (
    .wr_clk (dbg_clk),
    .rd_clk (axi_clk),
    .din    (fifo_din),
    .wr_en  (fifo_wr),
    .rd_en  (axi_rd),
    .dout   (axi_dout_q),
    .full   (),
    .empty  ()
    );
  
  always@(posedge dbg_clk) begin
  
    fifo_dout_0   <= fifo_dout;
    fifo_empty_0  <= fifo_empty;
    
    // Check for reads/writes in the FIFO...
    case (arb_state)
      IDLE: begin
          arb_en  <= 0;
          fifo_rd <= 0;
          if (~fifo_empty_0) begin
            fifo_rd   <= 1 ;
            arb_en    <= 1 ;
            arb_we    <= fifo_dout_0[7:0];
            arb_addr  <= fifo_dout_0[27:8];
            arb_din   <= fifo_dout_0[91:28];
            arb_state <= READ;
          end
        end
      READ: begin
          arb_en    <= 0;
          fifo_rd   <= 0;
          arb_state <= WAIT;
        end
      WAIT: begin
          arb_state <= IDLE;
        end
      default:
        arb_state <= IDLE;
    endcase
    
    // Mark valid outputs from the URAM...
    arb_pipe  <= {arb_pipe[8:0], arb_en};
    
    fifo_wr   <= 0;
    if (arb_pipe[9] & temp_arb_we == 'd0) begin
      fifo_wr   <= 1;
      fifo_din  <= fifo_din_temp;
    end
   
    if (dbg_rst) begin
      arb_state <= IDLE;
    end
  end


  always@(posedge dbg_clk) begin
      fifo_din_temp  <= arb_dout;	
  end

  always@(posedge dbg_clk) begin
	  temp_arb_en   <= arb_en  ;   
	  temp_arb_we   <= arb_we  ;
	  temp_arb_addr <= arb_addr;
	  temp_arb_din  <= arb_din ;
  end

  always@(posedge dbg_clk) begin
	  temp_dbg_en   <= dbg_en  ;   
	  temp_dbg_we   <= dbg_we  ;
	  temp_dbg_addr <= dbg_addr;
	  temp_dbg_din  <= dbg_din ;
  end
    
  jb_dbgmux_uram_top #(
  .NUM  (45)
  ) 
  jb_dbgmux_uram_top_inst (
    .clk    (dbg_clk       ),
    .rst    (dbg_rst       ),
    .ena    (temp_arb_en   ),    
    .wea    (temp_arb_we   ),   
    .addra  (temp_arb_addr ),
    .dina   (temp_arb_din  ),
    .douta  (arb_dout      ),
    .enb    (temp_dbg_en   ),    
    .web    (temp_dbg_we   ),   
    .addrb  (temp_dbg_addr ),
    .dinb   (temp_dbg_din  ),
    .doutb  (dbg_dout      )
    );



endmodule
