
 module jb_dl_dfe_time_delay #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16
   ) (

      input                          clk_4x,  //491.52 MHz
      input                          clk_1x,  //122.88 MHz
      input                          resetn_1x,
      input                          resetn_4x,
      
      input signed [15:0]            frt_delay[N_ANTENNAS-1:0],
      input signed [6:0]             int_delay[N_ANTENNAS-1:0],
      input                          time_reg_trigger,
      jb_axi4_stream_if.slave        IFP_dfe_delay_in,
            //input tuser,tkeep,tdata,tvalid,tlast
            //output tready        
      output logic [N_ANTENNAS-1:0]  tvalid_s2p2nco,
      output logic [2*PRECISION-1:0] tdata_s2p2nco [N_ANTENNAS-1:0]

      );

     localparam USR_ID_BW = 2;

        //each carrier interface has 
        //logic [USER_SB_WIDTH-1:0] tuser; //USER_SB_WIDTH = 2  represents 4 antenna
        //logic [DATA_WIDTH-1:0]    tdata; //DATA_WIDTH = 32  {16 Q, 16 I}
        //logic                     tvalid;
        //logic                     tready; //SET to 1 on output

// Trigger for Delay to change at same time
logic signed [15:0] frt_delay_keep [N_ANTENNAS-1:0]='{default:0};
logic signed [6:0]  int_delay_keep [N_ANTENNAS-1:0]='{default:0};
logic        time_reg_trigger_d = 'b0;
logic        time_reg_trigger_2d = 'b0;
logic        time_reg_trigger_3d = 'b0;
logic        time_reg_delta = 'b0;
logic        time_reg_delta_d = 'b0;
logic        time_reg_delta_4x = 'b0;

 always_ff @(posedge clk_1x)  begin  // Double reg into 1x domain
    time_reg_trigger_d <= time_reg_trigger;
    time_reg_trigger_2d <= time_reg_trigger_d;
    time_reg_trigger_3d <= time_reg_trigger_2d;
    time_reg_delta <= time_reg_trigger_3d && ~time_reg_trigger_2d;
 end
 
  always_ff @(posedge clk_4x)  begin  // Double reg into 4x domain
    time_reg_delta_d <=  time_reg_delta;
    time_reg_delta_4x <=  time_reg_delta_d;
  end
 
  always_ff @(posedge clk_4x)  begin  // Double reg into 4x domain
    if (time_reg_delta_4x) begin
        frt_delay_keep <= frt_delay;
        int_delay_keep <= int_delay;
    end
 end

// Fractional Time Delay
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out_FTD();

  jb_dfe_FTD_time_delay  #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION  (PRECISION)
      ) u_dl_dfe_FTD_time_delay  (
       .clk_4x                (clk_4x),
       .resetn                (resetn_4x), 
       .frt_delay             (frt_delay_keep),
       .IFP_dfe_delay_in      (IFP_dfe_delay_in),
       .IFP_dfe_delay_out_FTD (IFP_dfe_delay_out_FTD)
   );
   
   
 // Integer Delay
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out_ant_dummy();
   
   jb_dfe_INT_time_delay  #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION  (PRECISION)
      ) u_dl_dfe_INT_time_delay  (
       .clk_4x            (clk_4x),
       .clk_1x            (clk_1x),
       .resetn_1x            (resetn_1x), 
       .resetn_4x            (resetn_4x), 
       .int_delay         (int_delay_keep),
       .IFP_dfe_delay_in  (IFP_dfe_delay_out_FTD),
       .tvalid_s2p2nco    (tvalid_s2p2nco),             // On 1X Domain
       .tdata_s2p2nco     (tdata_s2p2nco),
       .IFP_dfe_delay_out (IFP_dfe_delay_out_ant_dummy) // Not used in DL // ON 4X Domain
   );
    

 
endmodule
