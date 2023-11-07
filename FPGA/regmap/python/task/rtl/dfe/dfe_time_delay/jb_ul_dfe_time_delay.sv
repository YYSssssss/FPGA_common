////////////////////////////////////////////////////////////////////
////  File Name : jb_ul_dfe_time_delay.sv
///// Author    : Sharief Megeed
///// Date      : 10/31/2019
///// Description  : Time delay integer and fractional 
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_ul_dfe_time_delay #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16
   ) (
      input                         clk_1x,  //122.88 MHz
      input                         clk_4x,  //491.52 MHz

      input                         resetn_1x,  
      input                         resetn_4x,
      
      input signed [15:0]           frt_delay[N_ANTENNAS-1:0],
      input signed [6:0]            int_delay[N_ANTENNAS-1:0],
      input                         time_reg_trigger,
      input logic [N_ANTENNAS-1:0]  tvalid_p2s,
      input logic [2*PRECISION-1:0] tdata_p2s [N_ANTENNAS-1:0],
      jb_axi4_stream_if.master      IFP_dfe_delay_out
            //input tuser,tkeep,tdata,tvalid,tlast
            //output tready        
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

logic signed [15:0] frt_delay_keep_1x [N_ANTENNAS-1:0] = '{default:0};
logic signed [6:0]  int_delay_keep_1x [N_ANTENNAS-1:0] = '{default:0};
 
  always_ff @(posedge clk_1x)  begin  // Double reg into 1x domain
    if (time_reg_delta) begin
        frt_delay_keep_1x <= frt_delay;
        int_delay_keep_1x <= int_delay;
    end
  end

   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out2FIFO[3:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_in[3:0] ();

  genvar i;
  generate
   for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: INT_time_delay_FIFO_adjust
   
   assign IFP_dfe_delay_in[i].tdata = tdata_p2s[i];
   //assign IFP_dfe_delay_in[i].tvalid = tvalid_p2s[i];
   assign IFP_dfe_delay_in[i].tvalid = &tvalid_p2s; // SM 12/25/2019 Try to wait till all valids are ready.  Don't know what the valids do because of lack of reset 
   assign IFP_dfe_delay_in[i].tuser = i;
  
   jb_dfe_INT_time_delay_FIFO_Adjust  #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION  (PRECISION),
       .ANTENNA    (i)
      ) u_dl_dfe_INT_time_delay_FIFO_Adjust  (
       .clk               (clk_1x),
       .resetn            (resetn_1x), 
       .int_delay         (int_delay_keep_1x),
       .IFP_dfe_delay_in  (IFP_dfe_delay_in[i]),
       .IFP_dfe_delay_out (IFP_dfe_delay_out2FIFO[i]) 
   );
   end : INT_time_delay_FIFO_adjust
  endgenerate
  /*
	 ila_0 u_ila_ul_INT_Delay_out (
	   .clk(clk_1x), // input wire clk
	   .probe0(IFP_dfe_delay_out2FIFO[0].tvalid), // input wire [0:0]  probe0  
	   .probe1(IFP_dfe_delay_out2FIFO[0].tuser), // input wire [1:0]  probe1 
	   .probe2(IFP_dfe_delay_out2FIFO[0].tdata) // input wire [31:0]  probe2
        ); 
  */
  logic [2*PRECISION-1:0] fifo_data_out_491[N_ANTENNAS-1:0];
  logic fifo_491_rd_en[N_ANTENNAS-1:0];
  logic rd_valid[N_ANTENNAS-1:0];
  logic [1:0] clk_4x_cntr;
  logic fifo_empty[N_ANTENNAS-1:0];
  
  logic p2s_cntr_enable;
  assign p2s_cntr_enable = (|tvalid_p2s) ;
  
  jb_cntr #(
      .COUNT_WIDTH(2)
   ) u_jb_4x_cntr (
      .clk       (clk_4x),
      .resetn    (resetn_4x),
      .enable    (p2s_cntr_enable), //connect enable based ondivide every 4 cycles
      .max_value (2'b11),
      .cntr      (clk_4x_cntr)
    );
     
  
  genvar j;
  generate
   for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: INT_time_delay_FIFO_491
   FIFO_122_491_32bit  u_ul_dfe_FIFO_122_491_32bit  (
       .rst    (~resetn_1x),
       .wr_clk (clk_1x),
       .rd_clk (clk_4x),
       .din    (IFP_dfe_delay_out2FIFO[j].tdata),
       .wr_en  (IFP_dfe_delay_out2FIFO[j].tvalid),
       .rd_en  (fifo_491_rd_en[j]),
       .dout   (fifo_data_out_491[j]),
       .valid  (rd_valid[j]),
       .full   (),
       .empty  (fifo_empty[j])
   );
   
   assign fifo_491_rd_en[j] = (clk_4x_cntr == j);
   
   end: INT_time_delay_FIFO_491
   endgenerate
   
    
/*	 ila_0 u_ila_ul_FIFO_122_491 (
	   .clk(clk_4x), // input wire clk
	   .probe0(rd_valid[0]), // input wire [0:0]  probe0  
	   .probe1({fifo_empty[0],fifo_491_rd_en[0]}), // input wire [1:0]  probe1 
	   .probe2(fifo_data_out_491[0]) // input wire [31:0]  probe2
        ); 
 */       

   logic tvalid_out = 0;
   logic [2*PRECISION-1:0] tdata_out = 0;
   logic [USR_ID_BW-1:0] tuser_out = 0;
   logic [2*PRECISION-1:0] tdata_out_d = 0;
   logic [USR_ID_BW-1:0] tuser_out_d = 0;
   
   always_ff @(posedge clk_4x) begin
      if(~resetn_4x) begin
         tvalid_out <= 'b0;
      end
   else if (rd_valid[0]) begin
	     tvalid_out <= 'b1;
      end
   end // always @ (posedge clk)
   
   always_ff @(posedge clk_4x) begin
     if(~resetn_4x) begin
       tdata_out_d <= 'd0;
       tuser_out_d <= 'd0;
     end
   else  if (tvalid_out || rd_valid[0]) begin
	   tdata_out_d <= fifo_data_out_491[clk_4x_cntr];
       tuser_out_d <= clk_4x_cntr;
     end
   end // always @ (posedge clk) 
  
   always_ff @(posedge clk_4x) begin
     if(~resetn_4x) begin
       tdata_out <= 'd0;
       tuser_out <= 'd0;
     end
   else  begin
	   tdata_out <= tdata_out_d;
       tuser_out <= tuser_out_d;
     end
   end // always @ (posedge clk) 
   
// Fractional Time Delay
  jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_in_FTD();
  
  assign IFP_dfe_delay_in_FTD.tdata = tdata_out;
  assign IFP_dfe_delay_in_FTD.tvalid = tvalid_out;
  assign IFP_dfe_delay_in_FTD.tuser = tuser_out;
  /*
  ila_0 u_ila_ul_IFP_dfe_delay_in_FTD (
	   .clk(clk_4x), // input wire clk
	   .probe0(IFP_dfe_delay_in_FTD.tvalid), // input wire [0:0]  probe0  
	   .probe1(IFP_dfe_delay_in_FTD.tuser), // input wire [1:0]  probe1 
	   .probe2(IFP_dfe_delay_in_FTD.tdata) // input wire [31:0]  probe2
        ); 
*/
  jb_dfe_FTD_time_delay  #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION  (PRECISION)
      ) u_dl_dfe_FTD_time_delay  (
       .clk_4x                (clk_4x),
       .resetn                (resetn_4x), 
       .frt_delay             (frt_delay_keep),
       .IFP_dfe_delay_in      (IFP_dfe_delay_in_FTD),
       .IFP_dfe_delay_out_FTD (IFP_dfe_delay_out)
   );
   
 /* ila_0 u_ila_ul_FTD_time_delay_out (
	   .clk(clk_4x), // input wire clk
	   .probe0(IFP_dfe_delay_out.tvalid), // input wire [0:0]  probe0  
	   .probe1(IFP_dfe_delay_out.tuser), // input wire [1:0]  probe1 
	   .probe2(IFP_dfe_delay_out.tdata) // input wire [31:0]  probe2
        ); 
 */   
endmodule
