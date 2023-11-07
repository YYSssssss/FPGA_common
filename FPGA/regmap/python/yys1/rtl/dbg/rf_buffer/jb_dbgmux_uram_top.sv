
module jb_dbgmux_uram_top #(
  parameter unsigned NUM = 45
  )(
  input  wire           clk,
  input  wire           rst,
  
  input  wire           ena,    
  input  wire    [7:0]  wea,   
  input  wire   [19:0]  addra,
  input  wire   [63:0]  dina,
  output logic  [63:0]  douta,
  
  input  wire           enb,    
  input  wire    [7:0]  web,   
  input  wire   [19:0]  addrb,
  input  wire   [63:0]  dinb,
  output logic  [63:0]  doutb
  );

xilinx_ultraram_true_dual_port_bytewrite  #(
  .AWIDTH (18),   // Address Width
  .NUM_COL(8 ),  // Number of columns
  .DWIDTH (64),  // Data Width, (Byte * NUM_COL) 
  .NBPIPE (5 )   // Number of pipeline Registers
 ) u1_uram_dbgbuf( 
    .clk(clk),                    // Clock
    // Port A
    .rsta   (rst),                   // Reset
    .wea    (wea),      // Write Enable
    .regcea (1'b1),                 // Output Register Enable
    .mem_ena(ena),                // Memory Enable
    .dina   (dina),      // Data Input  
    .addra  (addra[17:0]),     // Address Input
    .douta  (douta),// Data Output

    // Port B
    .rstb   (rst),                   // Reset
    .web    (web),      // Write Enable
    .regceb (1'b1),                 // Output Register Enable
    .mem_enb(enb),                // Memory Enable
    .dinb   (dinb),      // Data Input  
    .addrb  (addrb[17:0]),     // Address Input
    .doutb  (doutb)// Data Output
   );
  
endmodule