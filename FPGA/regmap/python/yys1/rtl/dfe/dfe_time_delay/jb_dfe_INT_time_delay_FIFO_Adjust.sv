////////////////////////////////////////////////////////////////////
////  File Name : jb_dfe_INT_time_delay_FIFO_Adjust.sv
///// Author    : Sharief Megeed
///// Date      : 10/31/2019
///// Description  : Time delay integer
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dfe_INT_time_delay_FIFO_Adjust #(
      parameter N_CARRIERS=2,
      parameter N_ANTENNAS=4,
      parameter PRECISION=16,
      parameter ANTENNA=0
   ) (

      input                    clk,  
      input                    resetn,
      
      input signed [6:0]       int_delay[N_ANTENNAS-1:0],
      jb_axi4_stream_if.slave  IFP_dfe_delay_in,
            //input tuser,tkeep,tdata,tvalid,tlast
            //output tready        
      jb_axi4_stream_if.master IFP_dfe_delay_out

            //input tready
            //output tuser,tkeep,tdata,tvalid,tlast
      );

     localparam USR_ID_BW = 2;
     
  logic signed [7:0] target_data_count = 'd63;  //SM 12/25/2019 set to center on startup
     
  // Register input
  logic [31:0] IFP_dfe_delay_in_tdata_reg = 'd0;
  logic [1:0]  IFP_dfe_delay_in_tuser_reg = 'd0;
  logic        IFP_dfe_delay_in_valid_reg = 'b0;
  logic        valid_antenna = 'b0;

    always_ff @(posedge clk)  begin
        valid_antenna <= (IFP_dfe_delay_in.tuser  == ANTENNA) & IFP_dfe_delay_in.tvalid;
        IFP_dfe_delay_in_tdata_reg <= IFP_dfe_delay_in.tdata;
        IFP_dfe_delay_in_tuser_reg <= IFP_dfe_delay_in.tuser;
        IFP_dfe_delay_in_valid_reg <= IFP_dfe_delay_in.tvalid;
    end
  
   // Fill regardless of valid SM 12/24/2019 // DIDNT work.  Need reset
/*  logic fill = 'b1;
  logic fill_done = 'b0;
  
  always_ff @(posedge clk) begin
    if (!resetn) begin
        fill_done <= 'b0;
        fill <= 'b1;
    end
    else if (fill_done == 'b0 && (data_count < (target_data_count - 1'b1)) ) begin // if less than target
            fill_done <= 'b0; // keep not done
            fill <= 'b1; // cfill
        end
    else  begin // Count is now = to targer
        fill_done <= 'b1; // Keep reset done
        fill <= 'b0; // Don't fill any more
        end
  end 
 */
 
 // Integer Delay
    
    logic signed [6:0] int_delay_d [N_ANTENNAS-1:0];
 
    always_ff @(posedge clk)  begin
        int_delay_d <= int_delay;
    end

 logic wr_en;
// logic rd_en = 'b0;
 logic rd_en;

 //jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out();
 logic full;
 logic empty;
 logic [7:0] data_count;
 logic  wr_adjust_en = 'b0;

 FIFO_Int_Delay i_FIFO_Int_Delay
    (
       .srst(~resetn),
       .clk(clk),
       .din(IFP_dfe_delay_in_tdata_reg),
       .wr_en(wr_en),
       .rd_en(rd_en),
       .dout(IFP_dfe_delay_out.tdata),
       .full(full),
       .empty(empty),
       .data_count(data_count)
  );
  
  assign wr_en = valid_antenna & ~wr_adjust_en;
  //assign wr_en = (valid_antenna & ~wr_adjust_en) | fill;  // SM 12/25/2019

  // Mid point of 128 FIFO (minimum size to accomodate +-48 in distributed RAM is 63
  // Desired delay is 63+ +-48(delay reg)
  
 // logic signed [7:0] target_data_count;
 // assign target_data_count = ( 7'sd63 + $signed(int_delay[ANTENNA]));
 

 always_ff @(posedge clk)  begin
    target_data_count <= ( 7'sd63 + $signed(int_delay[ANTENNA]));
 end
 
/*   always_ff @(posedge clk)  begin
   rd_en <= (IFP_dfe_delay_in.tuser == ANTENNA) & IFP_dfe_delay_in.tvalid & 
        (data_count >= target_data_count); // If read count is >= to the desired delay then read
   end
*/
 
   assign rd_en = valid_antenna & (data_count >= target_data_count); // If read count is >= to the desired delay then read
   //assign rd_en = fill ? 'b0 : (valid_antenna & (data_count >= target_data_count)); // If read count is >= to the desired delay then read  // SM 12/25/2019

   
   
   always_ff @(posedge clk)  begin
        if ($signed(int_delay[ANTENNA]) < $signed(int_delay_d[ANTENNA])) wr_adjust_en <= 'b1;
        else if (wr_adjust_en) begin
              if (data_count > target_data_count)  wr_adjust_en <= 'b1;
              else wr_adjust_en <= 'b0;
        end 
    end
   
// read enable
logic rd_en_hold = 'b0;
   always_ff @(posedge clk)  begin
        if (~resetn) rd_en_hold <= 'b0;
        else if (rd_en) rd_en_hold <= 'b1;
   end
   
   always_ff @(posedge clk)  begin
        //IFP_dfe_delay_out.tvalid <= (IFP_dfe_delay_in.tuser == ANTENNA) & IFP_dfe_delay_in.tvalid;
        IFP_dfe_delay_out.tvalid <= (IFP_dfe_delay_in_tuser_reg == ANTENNA) & rd_en_hold;
        IFP_dfe_delay_out.tuser <= ANTENNA;
    end
    
  /*	 ila_0 u_ila_ul_fifo_Adjust (
	   .clk(clk), // input wire clk
	   .probe0(wr_en), // input wire [0:0]  probe0  
	   .probe1({rd_en, wr_adjust_en}), // input wire [1:0]  probe1 
	   .probe2({24'd0,data_count}) // input wire [31:0]  probe2
        );  
*/
endmodule
