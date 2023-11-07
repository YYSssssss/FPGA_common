////////////////////////////////////////////////////////////////////
////  File Name : jb_dfe_INT_time_delay.sv
///// Author    : Sharief Megeed
///// Date      : 10/31/2019
///// Description  : Time delay integer
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dfe_INT_time_delay #(
      parameter N_CARRIERS=2,
      parameter N_ANTENNAS=4,
      parameter PRECISION=16
   ) (

      input                          clk_4x,  //491.52 MHz
      input                          clk_1x,  //122.88 MHz
      input                          resetn_1x,
      input                          resetn_4x,
      
      input signed [6:0]             int_delay[N_ANTENNAS-1:0],
      jb_axi4_stream_if.slave        IFP_dfe_delay_in,
            //input tuser,tkeep,tdata,tvalid,tlast
            //output tready        
      output logic [N_ANTENNAS-1:0]  tvalid_s2p2nco,   // In 1x Clk Domain
      output logic [2*PRECISION-1:0] tdata_s2p2nco [N_ANTENNAS-1:0],
      jb_axi4_stream_if.master       IFP_dfe_delay_out  // Mux out 4x clk domain

            //input tready
            //output tuser,tkeep,tdata,tvalid,tlast
      );

     localparam USR_ID_BW = 2;

        //each carrier interface has 
        //logic [USER_SB_WIDTH-1:0] tuser; //USER_SB_WIDTH = 2  represents 4 antenna
        //logic [DATA_WIDTH-1:0]    tdata; //DATA_WIDTH = 32  {16 Q, 16 I}
        //logic                     tvalid;
        //logic                     tready; //SET to 1 on output


   jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out2FIFO[3:0]();
   
  genvar i;
  generate
   for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: INT_time_delay_FIFO_adjust
   jb_dfe_INT_time_delay_FIFO_Adjust  #(
       .N_CARRIERS (N_CARRIERS),
       .N_ANTENNAS (N_ANTENNAS),
       .PRECISION  (PRECISION),
       .ANTENNA    (i)
      ) u_dl_dfe_INT_time_delay_FIFO_Adjust  (
       .clk               (clk_4x),
       .resetn            (resetn_4x), 
       .int_delay         (int_delay),
       .IFP_dfe_delay_in  (IFP_dfe_delay_in),
       .IFP_dfe_delay_out (IFP_dfe_delay_out2FIFO[i]) // Not used in UL // ON 4X Domain
   );
     end : INT_time_delay_FIFO_adjust
  endgenerate

// Generate Valids

logic       ant_tvalid = 0;
logic [2:0] ant_tvalid_d = '{default:0};
logic 	    ant_tvalid_stretched;
logic       ant_tvalid_clk_1x = 0;

 always_ff @(posedge clk_4x) begin
   if (!resetn_4x) begin
	 ant_tvalid <= 0;
   end
//   else if (IFP_dfe_delay_out2FIFO[0].tvalid | IFP_dfe_delay_out2FIFO[1].tvalid | IFP_dfe_delay_out2FIFO[2].tvalid | IFP_dfe_delay_out2FIFO[3].tvalid) begin
   else if (IFP_dfe_delay_out2FIFO[0].tvalid) //[zle]modify for mintaka
     ant_tvalid <= 1; 
   else
	 ant_tvalid <= 0;       
 end
 
 always_ff @(posedge clk_4x) begin
   if (!resetn_4x) begin
	 ant_tvalid_d <= 0;
   end
   else begin
     ant_tvalid_d[0] <= ant_tvalid; 
     ant_tvalid_d[1] <= ant_tvalid_d[0]; 
     ant_tvalid_d[2] <= ant_tvalid_d[1];   
   end
 end

 //assign ant_tvalid_stretched = ant_tvalid | (|ant_tvalid_d);  
 assign ant_tvalid_stretched = ant_tvalid;  
  
   //clk122p44 domain  
   always_ff @(posedge clk_1x) begin
     if (!resetn_1x) begin //may need to syn with clk_1x
	    ant_tvalid_clk_1x <= 0;
     end
     else begin
	    ant_tvalid_clk_1x <= ant_tvalid_stretched; //clk_1x & clk_4x are from same clock source, should be synchonous, double syn not needed
     end // else: !if(!resetn)
   end // always @ (posedge clk)   
 // Move over to to 122 domain.

logic rd_en;
logic [N_ANTENNAS-1:0]  fifo_empty; 
      
  genvar j;
  generate
   for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: INT_time_delay_FIFO_122
   FIFO_491_122_32bit  u_dl_dfe_FIFO_491_122_32bit  (
       .rst(~resetn_1x), //slow clock
       .wr_clk(clk_4x),
       .rd_clk(clk_1x),
       .din(IFP_dfe_delay_out2FIFO[j].tdata),
       .wr_en(IFP_dfe_delay_out2FIFO[j].tvalid),
       .rd_en(rd_en),
       .dout(tdata_s2p2nco[j]),
       .full(),
       .empty(fifo_empty[j])
   );
    
   assign tvalid_s2p2nco[j] = ant_tvalid_clk_1x;
   //assign tvalid_s2p2nco[j] = 'b1;
   
   end : INT_time_delay_FIFO_122
  endgenerate
  
assign rd_en =  !fifo_empty[3] && !fifo_empty[2] && !fifo_empty[1] && !fifo_empty[0];  // Start reading when they all have data.  This should align the outputs
   
 
// Mux 4 4x streams into 1

 always_ff @(posedge clk_4x)  begin
    if (IFP_dfe_delay_out2FIFO[0].tvalid) begin   
        IFP_dfe_delay_out.tdata  <= IFP_dfe_delay_out2FIFO[0].tdata;
        IFP_dfe_delay_out.tuser  <= 'd0;
        IFP_dfe_delay_out.tvalid <= 'b1;
    end
    else if (IFP_dfe_delay_out2FIFO[1].tvalid) begin   
        IFP_dfe_delay_out.tdata  <= IFP_dfe_delay_out2FIFO[1].tdata;
        IFP_dfe_delay_out.tuser  <= 'd1;
        IFP_dfe_delay_out.tvalid <= 'b1;
    end
    else if (IFP_dfe_delay_out2FIFO[2].tvalid) begin   
        IFP_dfe_delay_out.tdata  <= IFP_dfe_delay_out2FIFO[2].tdata;
        IFP_dfe_delay_out.tuser  <= 'd2;
        IFP_dfe_delay_out.tvalid <= 'b1;
    end
    else if (IFP_dfe_delay_out2FIFO[3].tvalid) begin   
        IFP_dfe_delay_out.tdata  <= IFP_dfe_delay_out2FIFO[3].tdata;
        IFP_dfe_delay_out.tuser  <= 'd3;
        IFP_dfe_delay_out.tvalid <= 'b1;
    end
 end

endmodule
