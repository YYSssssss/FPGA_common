////////////////////////////////////////////////////////////////////
////  File Name : jb_dl_dfe_cmbn.sv
///// Author    : Shehanaj Begum
///// Date      : 1/14/2018
///// Description  : DL_DFE TOP Block
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_prach_s2p  #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16,
      parameter USR_ID_BW=2
   ) (


            input clk_4x,
            input clk_1x,
            input clk_en,
            input resetn_1x,
            input resetn_4x,
//	    jb_prach_dfe_ctrl_if.prach_dfe IFP_prach_dfe_ctrl,
	    
	    input tvalid_in,
            input [2*PRECISION-1:0] tdata_in,
            input [USR_ID_BW-1:0] tuser_in,
	    
	    //DPD outputs 2 arrays of axi stream
	    output logic [N_ANTENNAS-1:0] tvalid_out,
	    output logic [2*PRECISION-1:0] tdata_out[N_ANTENNAS-1:0]
      
      
      );


   
   logic  	  ant_tvalid;
   logic [3:0] 	  ant_tvalid_d;
   logic 	  ant_tvalid_stretched;
   logic 	  ant_tvalid_stretched_d;

   logic 	  ant_tvalid_clk_1x;
   logic 	  ant_tvalid_clk_1x_d;
   logic [2*PRECISION-1:0] ant_tdata[N_ANTENNAS-1:0];
   logic [2*PRECISION-1:0] ant_tdata_d[N_ANTENNAS-1:0];
   logic [2*PRECISION-1:0] ant_tdata_dd[N_ANTENNAS-1:0];
   logic [2*PRECISION-1:0] ant_tdata_ddd[N_ANTENNAS-1:0];
   logic [2*PRECISION-1:0] ant_tdata_clk_1x[N_ANTENNAS-1:0];
   
   genvar 		   i;
   

   //////////////////////////////////////////////////////////////
 //// DMUX the Antennas /////////////////////////////////////
 ///////////////////////////////////////////////////////////

   //only one tvalid for every path
   always @(posedge clk_4x) begin
      if (!resetn_4x) begin
	 ant_tvalid   <= 0;
	 ant_tvalid_d   <= 0;
      end
      else begin
	 if (tvalid_in && (tuser_in==N_ANTENNAS-1) ) begin
	    ant_tvalid <= 1'b1;
	 end
	 else  begin
	    ant_tvalid <= 0;
	 end
	 ant_tvalid_d[0] <= ant_tvalid;
	 for (int i=1; i<4; i=i+1) begin
	  ant_tvalid_d[i] <= ant_tvalid_d[i-1];
	 end
      end
   end // always @ (posedge clk)
   
   assign ant_tvalid_stretched = ant_tvalid | (|ant_tvalid_d);
  
   generate
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: dl_dfe_dmux 
	 always @(posedge clk_4x) begin
	    if (!resetn_4x) begin
	       ant_tdata[i] <= 0;
	    end
	    else if (tvalid_in && (tuser_in==i) )begin
	       ant_tdata[i] <= tdata_in;
	    end
	 end // always @ (posedge clk)
	 
	 always @(posedge clk_4x) begin
	    if (!resetn_4x) begin
	       ant_tdata_d[i] <= 0;
	    end
	    else begin
	       if (ant_tvalid) begin
		  ant_tdata_d[i]<=ant_tdata[i];
	       end
	    end // else: !if(!resetn_4x)
	 end // always @ (posedge clk)
      end : dl_dfe_dmux
endgenerate

    always @(posedge clk_4x) begin
      if (!resetn_4x) begin //may need to syn with clk_1x
	 ant_tvalid_stretched_d <= 0;
      end
      else begin
	 ant_tvalid_stretched_d <= ant_tvalid_stretched; //clk_1x & clk_4x are from same clock source, should be synchonous, double syn not needed
      end // else: !if(!resetn)
   end // always @ (posedge clk)

   //////////////////////////////////////////////////////////
   //clk122p44 domain  
   always @(posedge clk_1x) begin
      if (!resetn_1x) begin //may need to syn with clk_1x
	 ant_tvalid_clk_1x <= 0;
      end
      else begin
	 ant_tvalid_clk_1x <= ant_tvalid_stretched_d; //clk_1x & clk_4x are from same clock source, should be synchonous, double syn not needed
      end // else: !if(!resetn_1x)
   end // always @ (posedge clk)
   
  
   generate
      for (i = 0; i <  N_ANTENNAS; i = i + 1) begin: dl_dfe_dmux_clk_1x 
	 /////////
	 //clk122044 domain
	 always @(posedge clk_1x) begin
	    if (!resetn_1x) begin //may need to sync with clk_1x
	       ant_tdata_clk_1x[i] <= 0;
	    end
	    else begin
	       ant_tdata_clk_1x[i]<=ant_tdata_d[i];
	    end // else: !if(!resetn_1x)
	 end // always @ (posedge clk)

    always @(posedge clk_1x) begin
      if (!resetn_1x) begin //may need to syn with clk_1x
	 tvalid_out[i] <= 0;
	 tdata_out[i] <= 0;
      end
      else begin
	 tvalid_out[i] <= ant_tvalid_clk_1x; //clk_1x & clk_4x are from same clock source, should be synchonous, double syn not needed
	 tdata_out[i] <= ant_tdata_clk_1x[i]; //clk_1x & clk_4x are from same clock source, should be synchonous, double syn not needed
      end // else: !if(!resetn_1x)
   end // always @ (posedge clk)

      end : dl_dfe_dmux_clk_1x
    endgenerate  
//////////////////////////////////////////////////////////////////////
   
endmodule // jb_dl_dfe_ant_s2p