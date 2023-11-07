

module pl_sysref (
    (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pl_sysref CLK_P" *)
    input   wire    pl_sysref_p,
    (* X_INTERFACE_INFO = "xilinx.com:interface:diff_clock:1.0 pl_sysref CLK_N" *)
    input   wire    pl_sysref_n,

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pl_refclk_i CLK" *)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 368640000" *)
    input   wire    pl_refclk_i,

    (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 pl_refclk_m CLK" *)
    (* X_INTERFACE_PARAMETER = "FREQ_HZ 368640000" *)
    input   wire    pl_refclk_m,

    output  wire    user_sysref_dac,
    output  wire    user_sysref_adc
  );       

    wire    pl_sysref_i;
    (* dont_touch = "true" *) reg   pl_sysref_r;
    (* dont_touch = "true" *) reg   ff_dac;
    (* dont_touch = "true" *) reg   ff_adc;


   IBUFDS #(.DQS_BIAS("FALSE")) IBUFDS_pl_sysref (
      .I    (pl_sysref_p),
      .IB   (pl_sysref_n),
      .O    (pl_sysref_i));

    always @(posedge pl_refclk_i) begin
        pl_sysref_r <= pl_sysref_i;
    end
    
    always @(posedge pl_refclk_m) begin
        ff_dac <= pl_sysref_r;
        ff_adc <= pl_sysref_r;
    end
    
    assign user_sysref_dac = ff_dac;
    assign user_sysref_adc = ff_adc;

    
endmodule

