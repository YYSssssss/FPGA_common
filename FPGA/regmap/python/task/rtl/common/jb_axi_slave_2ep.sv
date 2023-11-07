// -------------------------------------------------------------------------- //
// Copyright Jabil Inc.                                                       //
// -------------------------------------------------------------------------- //
// Name         : Shenanaj                                                    //
// Date         :                                                             //
// File         : jb_axi_slave.sv                                             //
// Design       :                                                             //
// Purpose      :                                                             //
// Device       :                                                             //
// -------------------------------------------------------------------------- //

module jb_axi_slave_2ep #(
    parameter   AXI_ADDR_WIDTH  = 13,
    parameter   AXI_DATA_WIDTH  = 32

) (
    input                       clk,
    input                       srst,
    jb_axi4_lite_if.slave       IFP_axi4_lite,
    jb_axi_regs_if.master       IFP_axi_rw [1:0]
);

    localparam  ADDR_LSB = (AXI_DATA_WIDTH/32) + 1;


   // AXI4LITE signals
   logic [AXI_ADDR_WIDTH-1 : 0]                 axi_awaddr;
   logic 					axi_awready;
   logic 					axi_wready;
   logic [1 : 0] 				axi_bresp;
   logic 					axi_bvalid;
   logic [AXI_ADDR_WIDTH-1 : 0] 		axi_araddr;
   logic 					axi_arready;
   logic [AXI_DATA_WIDTH-1 : 0] 		axi_rdata;
   logic [1 : 0] 				axi_rresp;
   logic 					axi_rvalid;

  
   logic                    aw_en;
  
   
   // I/O Connections assignments

   assign IFP_axi4_lite.awready	= axi_awready;
   assign IFP_axi4_lite.wready	= axi_wready;
   assign IFP_axi4_lite.bresp	= axi_bresp;
   assign IFP_axi4_lite.bvalid	= axi_bvalid;
   assign IFP_axi4_lite.arready	= axi_arready;
   assign IFP_axi4_lite.rdata	= axi_rdata;
   assign IFP_axi4_lite.rresp	= axi_rresp;
   assign IFP_axi4_lite.rvalid	= axi_rvalid;


   // Assert axi_awready  when awvalid & wvalid is high

   always @( posedge clk ) begin
      if ( srst == 1'b1 ) begin
	 axi_awready <= 1'b0;
	 aw_en <= 1'b1;
      end 
      else begin    
	 if (~axi_awready && IFP_axi4_lite.awvalid && IFP_axi4_lite.wvalid && aw_en) begin
	    // Assumption no outstanding transaction
	    axi_awready <= 1'b1;
	    aw_en <= 1'b0;
	 end
	 else if ( IFP_axi4_lite.bready && axi_bvalid) begin
	    aw_en <= 1'b1;
	    axi_awready <= 1'b0;
	 end
	 else begin
	    axi_awready <= 1'b0;
	 end
      end 
   end      

   //Latch the address based on valid
   always @( posedge clk )  begin
	if ( srst == 1'b1 )  begin
	     axi_awaddr <= 0;
	  end 
	else begin    
	   if (~axi_awready && IFP_axi4_lite.awvalid && IFP_axi4_lite.wvalid && aw_en) begin
	      // Write Address latching 
	      axi_awaddr <= IFP_axi4_lite.awaddr;
	   end
	end 
   end       
   
   //Assert wreaddy for a clock cycle when awvalid and wvalid is asserted aw_en is set
   always @( posedge clk ) begin
      if ( srst == 1'b1 )  begin
	 axi_wready <= 1'b0;
      end 
      else begin    
	 if (~axi_wready && IFP_axi4_lite.awvalid && IFP_axi4_lite.wvalid && aw_en ) begin
	    // 
	    axi_wready <= 1'b1;
	 end
	 else begin
	    axi_wready <= 1'b0;
	 end
      end 
   end       


    logic write_en;
    assign write_en = axi_wready &&  IFP_axi4_lite.awvalid && IFP_axi4_lite.wvalid && axi_awready;
    assign IFP_axi_rw[0].wren = (axi_awaddr[AXI_ADDR_WIDTH-1] == 0) & write_en;
    assign IFP_axi_rw[1].wren = (axi_awaddr[AXI_ADDR_WIDTH-1] == 1) & write_en;

   //BVALID AND BRESP SETTINGS
   always @( posedge clk ) begin								  
      if ( srst == 1'b1 )  begin
	 axi_bvalid  <= 0;
	 axi_bresp   <= 2'b0;
      end 
      else begin    
	 if (axi_awready && IFP_axi4_lite.awvalid  && ~axi_bvalid && axi_wready && IFP_axi4_lite.wvalid)  begin
	    // indicates a valid write response is available
	    axi_bvalid <= 1'b1;
	    axi_bresp  <= 2'b0; // 'OKAY' response 
	 end                   // work error responses in future
	 else begin
	    if (IFP_axi4_lite.bready && axi_bvalid) begin 
	       //check if bready is asserted while bvalid is high) 
	       //(there is a possibility that bready is always asserted high)
	       axi_bvalid <= 1'b0; 
	    end  
	 end
      end
   end 

  ////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////// READ LOGIC /////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////
   always @( posedge clk ) begin 
      if ( srst == 1'b1 ) begin
	 axi_arready <= 1'b0;
	 axi_araddr  <= 32'b0;
      end 
      else begin 
	 if (~axi_arready && IFP_axi4_lite.arvalid) begin
	    // indicates that the slave has acceped the valid read address
	    axi_arready <= 1'b1;
	    // Latch Read address
	    axi_araddr  <= IFP_axi4_lite.araddr;
	 end
	 else begin
	    axi_arready <= 1'b0;
	 end
      end 
   end 


   //Latch the address based on valid
   always @( posedge clk ) begin
      if ( srst == 1'b1 ) begin
	 axi_rvalid <= 0;
	 axi_rresp  <= 0;
      end 
      else begin    
	 if (axi_arready && IFP_axi4_lite.arvalid && ~axi_rvalid) begin
	    // Valid read data is available at the read data bus
	    axi_rvalid <= 1'b1;
	    axi_rresp  <= 2'b0; // 'OKAY' response
	 end   
	 else if (axi_rvalid && IFP_axi4_lite.rready)   begin
	    // Read data is accepted by the master
	    axi_rvalid <= 1'b0;
	 end                
      end
   end 

    logic read_en;
    assign read_en = axi_arready & IFP_axi4_lite.arvalid & ~axi_rvalid;
    assign IFP_axi_rw[0].rden = read_en;
    assign IFP_axi_rw[1].rden = read_en;

   // Output register or memory read data
   //Latch the address based on valid
    always @( posedge clk ) begin
        if ( srst == 1'b1 ) begin
            axi_rdata  <= 0;
        end 
        else begin    
            if (read_en) begin
                if (axi_araddr[AXI_ADDR_WIDTH-1] == 0)
                    axi_rdata <= IFP_axi_rw[0].rdata;
                else
                    axi_rdata <= IFP_axi_rw[1].rdata;
            end
        end
    end 

  


///////////////////WRITE LOGIC ////////////////
  assign IFP_axi_rw[0].wr_offset = {1'b0,axi_awaddr[AXI_ADDR_WIDTH-2:ADDR_LSB]};
  assign IFP_axi_rw[1].wr_offset = {1'b0,axi_awaddr[AXI_ADDR_WIDTH-2:ADDR_LSB]};

///////////////////READ LOGIC ////////////////
  assign IFP_axi_rw[0].rd_offset = {1'b0,axi_araddr[AXI_ADDR_WIDTH-2:ADDR_LSB]};
  assign IFP_axi_rw[1].rd_offset = {1'b0,axi_araddr[AXI_ADDR_WIDTH-2:ADDR_LSB]};


  assign IFP_axi_rw[0].wdata = IFP_axi4_lite.wdata;
  assign IFP_axi_rw[1].wdata = IFP_axi4_lite.wdata;





endmodule
   


