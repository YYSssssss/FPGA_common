
`timescale 1 ps / 1 ps


module jb_rfbuf_input #(
    parameter N_ANTS_SEL   =2,
    parameter N_ANTENNAS   =4,
    parameter N_CARRIERS   =2,
    parameter DFE_PRECISION=16
) (
      input                      clk_3x                 ,
      input                      clk_1x                 ,
      input                      resetn_3x              ,
      input                      resetn_1x              ,
      input                      ptp_clk                ,
      input                      ptp_align_pulse        ,
      output                     o_first_cycle_acc      ,
      output [63:0] 		     o_rd_data               ,	  
      jb_test_ctrl_if.test_dbg   IFP_dbg_ctrl           ,  
//      jb_dl_dfe_ctrl_if.dl_dfe   IFP_dl_dfe_ctrl[1:0]   ,   
      jb_axi4_stream_if.slave    IFP_srx[N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //incoming
      jb_axi4_stream_if.slave    IFP_adc[N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //incoming   
      jb_axi4_stream_if.slave    IFP_dl_dfe_out[N_ANTS_SEL-1:0][N_ANTENNAS-1:0],     
      jb_ram_sp_if.host          IFP_bram_dbgbuf
	  		   
       				   
				    

);

     `include  "jb_common.svh"

  // 3'b000: Test mode disable (normal operation), 3'b001: dbgbuf_to_dac, 3'b010: dldfe_to_dbgbuf, 3'b011:adc_to_dbgbuf, 3'b100: dbgbuf_to_uldfe, 3'b101:dldfe_to_uldfe (before DPD)

   localparam MAX_NUM_SAMPLES_BW = 19; //2x samples
   
   localparam DBGBUF_DISABLE  = 3'b000;
   localparam DBGBUF_TO_DAC   = 3'b001;
   localparam DLDFE_TO_DBGBUF = 3'b010;
   localparam ADC_TO_DBGBUF   = 3'b011;
   localparam DBGBUF_TO_ULDFE = 3'b100;
   localparam ULDFE_TO_DBGBUF = 3'b101;

   localparam RD_LATENCY                = 4+1-2; //orig 4   
   localparam MAX_NUM_ADCDAC_SAMPLES_BW = 19;   
   
   
   
   logic [MAX_NUM_SAMPLES_BW-1:0]    test_num_of_2x_samples; //config
   logic 			                 test_mode             ; //debug mode
   logic [2:0] 		                 test_path_select      ; //debug mode
   logic                             start_pulse           ;
   logic 			                 rd_data_valid         ;
   logic [N_ANTS_SEL-1:0][N_ANTENNAS-1:0] [2*16-1:0] orx_uldfe_tdata       ;
   logic [N_ANTS_SEL-1:0][N_ANTENNAS-1:0]            orx_uldfe_tvalid      ;

  

   
   
   logic [RD_LATENCY-1:0]         en_dly               ;
   logic [RD_LATENCY-1:0]         first_half_data_valid;
   logic                          first_cycle_acc;
   logic 			              en              ;
   logic [MAX_NUM_SAMPLES_BW-2:0] addr            ; //2x sample addr
   logic [7:0] 			          wr_en           ;
   logic [63:0] 		          wr_data         ;
   logic 			              en_reg          ;
   logic [31:0]                   addr_reg        ; //2x sample addr
   logic [7:0] 			          wr_en_reg       ;
   logic [63:0] 		          wr_data_reg     ;
   logic [63:0] 		          rd_data         ;
   logic [31:0]			          rd_data_half    ;
   logic 			              wr_data_valid   ;
   logic [2:0]			          test_trigger_dly;
   
   logic [N_CARRIERS-1:0]         uldfe_to_dldfe_lpbk_enable        ;
   logic [N_CARRIERS-1:0]         uldfe_to_dldfe_lpbk_enable_latched;
   
   logic signed [N_ANTS_SEL-1:0][N_ANTENNAS-1:0][DFE_PRECISION-1:0] adc_q;
   logic signed [N_ANTS_SEL-1:0][N_ANTENNAS-1:0][DFE_PRECISION-1:0] adc_i;
   
   dbgbuf_sm_t dbg_sm;
   
   logic  [3:0][31:0]           ant_tssi        ;
   logic  [3:0][31:0]           pa_odp_tssi_temp;
   logic  [63:0]                s_rfbuf_data    ; 
   


   jb_axi4_stream_if  #(.DATA_WIDTH(2*16), .USER_SB_WIDTH(2))            IFP_ul_dfe_lpbk [N_CARRIERS-1:0] ();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*DFE_PRECISION), .USER_SB_WIDTH(1)) IFP_adc_reg[N_ANTS_SEL-1:0][N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*DFE_PRECISION), .USER_SB_WIDTH(1)) IFP_adc_lcl[N_ANTS_SEL-1:0][N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*DFE_PRECISION), .USER_SB_WIDTH(1)) IFP_adc_mux_in(); //SM 2020_05_14
    

   
   
   
   //////////////////////////////////////////////////////////////////////////////////////
   //////////////////////// DBGBUFFER PATH //////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////////

   assign test_mode              = IFP_dbg_ctrl.dfe_adcdac_test_mode; //cont, onshot
   assign test_path_select       = IFP_dbg_ctrl.dfe_adcdac_test_path_select;
   assign test_num_of_2x_samples = (IFP_dbg_ctrl.dfe_adcdac_test_num_samples!=0) ? IFP_dbg_ctrl.dfe_adcdac_test_num_samples[MAX_NUM_ADCDAC_SAMPLES_BW-1:1] : 0;   


   always_ff @(posedge clk_3x) begin
        if (!resetn_3x)
		   s_rfbuf_data <= 0;
		else 
		   casex({IFP_dbg_ctrl.rx_antenna_dgb_sel})
		   5'b0_0000: s_rfbuf_data <= IFP_dl_dfe_out[0][0].tdata;
		   5'b0_0001: s_rfbuf_data <= IFP_dl_dfe_out[0][1].tdata;
		   5'b0_0010: s_rfbuf_data <= IFP_dl_dfe_out[0][2].tdata;
		   5'b0_0011: s_rfbuf_data <= IFP_dl_dfe_out[0][3].tdata;
		   5'b0_0100: s_rfbuf_data <= IFP_dl_dfe_out[1][0].tdata;
		   5'b0_0101: s_rfbuf_data <= IFP_dl_dfe_out[1][1].tdata;
		   5'b0_0110: s_rfbuf_data <= IFP_dl_dfe_out[1][2].tdata;
		   5'b0_0111: s_rfbuf_data <= IFP_dl_dfe_out[1][3].tdata;
		   endcase
	end	   
		   

/*
    jb_edge_det #(
        .SYNC_EN            (1),
	.SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1),//pos
	.RETIME_OUTPUT      (0)
    ) u_dfe_adcdac_start_pulse (
        .clk                (clk_3x),
        .mask               (1'b0),
        .din                (IFP_dbg_ctrl.dfe_adcdac_test_trigger),
        .dout               (start_pulse)
    );
*/

    // ------------------------------------------------------------------ //
    // Trigger Alignment                                                  //
    // ------------------------------------------------------------------ //
    // Faizan: 12/16/20                                                   //
    // Following logic aligns the Debug Buffer trigger from the PS (reg)  //
    // with a pulse generated using the PTP clock.                        //
    // Once the PS trigger is asserted, it's held until the ptp_align_x3  //
    // pulse is detected or a reset is requested.                         //
    // ------------------------------------------------------------------ //
    
    logic   ptp_align_stretched;
    logic   ptp_align_x3;
    logic   rfbuf_trig_hold;
    logic   rfbuf_trig;
    logic   rfbuf_trig_aligned;

    jb_pulse_stretch #(
        .PULSE_WIDTH        (6)
    ) pulse_stretch_trig (
        .clk                (ptp_clk),
        .din                (ptp_align_pulse),
        .dout               (ptp_align_stretched)
    );
    
    always_ff @(posedge clk_3x) begin
        if (!resetn_3x)     ptp_align_x3 <= 0;
        else                ptp_align_x3 <= ptp_align_stretched;
    end
    
    // Hold trigger. Release ptp_align_x3 pulse or with reset
/*
    always_ff @(posedge clk_3x) begin
        if (!resetn_3x)
            rfbuf_trig_hold <= 0;   // reset            
        else if (IFP_dbg_ctrl.dfe_adcdac_test_trigger)
            rfbuf_trig_hold <= 1;   // set
        else if (ptp_align_x3 | IFP_dbg_ctrl.dfe_adcdac_test_reset)
            rfbuf_trig_hold <= 0;   // clear
    end
    
    assign rfbuf_trig_aligned = ptp_align_x3 & rfbuf_trig_hold;
*/

    always_ff @(posedge clk_3x) begin
        if      (!resetn_3x)                                rfbuf_trig_aligned <= 0;
        else if (IFP_dbg_ctrl.dfe_adcdac_test_trigger == 0) rfbuf_trig_aligned <= 0;
        else if (ptp_align_x3)                              rfbuf_trig_aligned <= 1; // IFP_dbg_ctrl.dfe_adcdac_test_trigger;
    end

    assign rfbuf_trig = IFP_dbg_ctrl.rfbuf_trig_align_en ? rfbuf_trig_aligned : IFP_dbg_ctrl.dfe_adcdac_test_trigger;
    // ------------------------------------------------------------------ //
   
  always_ff @(posedge clk_3x) begin
      if (!resetn_3x) begin
	 test_trigger_dly <= 0;
      end
      else begin
         test_trigger_dly <= {test_trigger_dly[1:0],rfbuf_trig};
      end
  end


   assign start_pulse = test_trigger_dly[1] & ~test_trigger_dly[2];
   
		       
   always_ff @(posedge clk_3x) begin
      if (!resetn_3x) begin
	 en_dly <= 0;
	 first_half_data_valid <= 0;
      end
      else begin
         en_dly <= {en_dly[RD_LATENCY-2:0],IFP_bram_dbgbuf.en};
	     first_half_data_valid <= {first_half_data_valid[RD_LATENCY-2:0],first_cycle_acc};
      end
   end

//   assign rd_data_valid = en_dly[RD_LATENCY-1];

   
   always_ff @(posedge clk_3x) begin //SM 2020_05_14
        case (IFP_dbg_ctrl.rx_antenna_dgb_sel)
            5'h00 : begin
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[0][0].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[0][0].tvalid;
                   end
            5'h01 : begin
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[0][1].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[0][1].tvalid;
                   end
            5'h02 : begin 
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[0][2].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[0][2].tvalid;
                   end
            5'h03 : begin 
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[0][3].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[0][3].tvalid;
                   end
            5'h04 : begin
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[N_ANTS_SEL-1][0].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[N_ANTS_SEL-1][0].tvalid;
                   end
            5'h05 : begin
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[N_ANTS_SEL-1][1].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[N_ANTS_SEL-1][1].tvalid;
                   end
            5'h06 : begin 
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[N_ANTS_SEL-1][2].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[N_ANTS_SEL-1][2].tvalid;
                   end
            5'h07 : begin 
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[N_ANTS_SEL-1][3].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[N_ANTS_SEL-1][3].tvalid;
                   end				   
            5'h10 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [0][0];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[0][0];
                   end
            5'h11 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [0][1];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[0][1];
                   end
            5'h12 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [0][2];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[0][2];
                   end
            5'h13 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [0][3];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[0][3];
                   end
            5'h14 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [N_ANTS_SEL-1][0];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[N_ANTS_SEL-1][0];
                   end
            5'h15 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [N_ANTS_SEL-1][1];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[N_ANTS_SEL-1][1];
                   end
            5'h16 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [N_ANTS_SEL-1][2];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[N_ANTS_SEL-1][2];
                   end
            5'h17 : begin 
                    IFP_adc_mux_in.tdata  <= orx_uldfe_tdata [N_ANTS_SEL-1][3];
                    IFP_adc_mux_in.tvalid <= orx_uldfe_tvalid[N_ANTS_SEL-1][3];
                    end				   
            default: begin
                    IFP_adc_mux_in.tdata  <= IFP_adc_lcl[0][0].tdata;
                    IFP_adc_mux_in.tvalid <= IFP_adc_lcl[0][0].tvalid;
                    end
        endcase
   end


  always @(posedge clk_3x) begin
      //Remove reset since FPGA reset can take resources
      if (!resetn_3x | IFP_dbg_ctrl.dfe_adcdac_test_reset) begin
	 addr <= 0;
	 wr_en <= 0;
	 en <= 1'b0;
	 first_cycle_acc<=1'b0;
	 rd_data <= 0;
	 dbg_sm <= DBGBUF_IDLE;	 
      end
      else begin
	 case (dbg_sm)
	   DBGBUF_IDLE :  begin
	      if (start_pulse) begin
		 if ((test_path_select == DBGBUF_TO_DAC) || (test_path_select == DBGBUF_TO_ULDFE)) begin
		    wr_en <= 0;
		    en <= 1'b1;
		    addr <= 0;
		    dbg_sm <= READ_DBGBUF;
		    first_cycle_acc <= 1'b1;
		 end
		 else if ((test_path_select == DLDFE_TO_DBGBUF) || (test_path_select == ADC_TO_DBGBUF)) begin
		    dbg_sm <= WRITE_DBGBUF_WAIT_DATA;
	
		   
		 end //else if
	      end //if (start_pulse)
	   end
	   READ_DBGBUF : begin
	      rd_data <= IFP_bram_dbgbuf.rd_data; //data us available after 2 cycles
	      first_cycle_acc <= !first_cycle_acc;
	      if (test_path_select == DBGBUF_TO_DAC) begin
		 if (addr == test_num_of_2x_samples-1) begin
		    if (test_mode==0) begin //single shot, wait for trigger
		       dbg_sm <= DBGBUF_IDLE;
		       en <= 0;		       
		    end
		    else begin
		       addr <= 0;
		    end
		 end
		 else begin
		    addr <= addr + 1; 
		 end // else: !if(addr == test_num_of_2x_samples-1)
	      end
	      else begin 
		 if ((addr == test_num_of_2x_samples-1) && (first_cycle_acc==1'b0)) begin
		    if (test_mode==0) begin //single shot, wait for trigger
		       dbg_sm <= DBGBUF_IDLE;
		       en <= 0;
		    end
		    else begin
		       addr <= 0;
		    end
		 end
		 else begin
		    if (first_cycle_acc==0) begin
		       addr <= addr + 1;
		    end
		 end
	      end // else: !if(test_path_select == DBGBUF_TO_DAC)
	   end
	  WRITE_DBGBUF_WAIT_DATA  : begin
		    if (wr_data_valid) begin //tvalid from dl_dfe or adc
		       en <= 1'b1;
		       addr <= 0;
		       dbg_sm <= WRITE_DBGBUF;
		       first_cycle_acc <= 1'b1;
		       if (test_path_select == DLDFE_TO_DBGBUF) begin
			     wr_en <= 8'hFF; 
//			     wr_data <= b0_IFP_dl_dfe_out[0].tdata;
                 wr_data <= s_rfbuf_data;
		       end
		       else begin
			     wr_en <= 8'h0F; 
			     //wr_data[31:0] <= IFP_adc_lcl[0].tdata[31:0];
			     wr_data[31:0] <= IFP_adc_mux_in.tdata[31:0]; //SM 2020_05_14
		       end
		    end
	  end
	 WRITE_DBGBUF : begin
	    if (wr_data_valid) begin
	       first_cycle_acc <= !first_cycle_acc;
	       if (test_path_select == DLDFE_TO_DBGBUF) begin 
//		  wr_data <= b0_IFP_dl_dfe_out[0].tdata;
		  wr_data <= s_rfbuf_data;
		  if (addr == test_num_of_2x_samples-1) begin
		     if (test_mode==0) begin //single shot, wait for trigger
			dbg_sm <= DBGBUF_IDLE;
			en <= 0;	
			wr_en <= 8'h00;	       
		     end
		     else begin
			addr <= 0;
			wr_en <= 8'hFF;
		     end
		  end
		  else begin
		     addr <= addr + 1; 
		     wr_en <= 8'hFF;
		  end // else: !if(addr == test_num_of_2x_samples-1)
	       end
	       else begin 
		  if ((addr == test_num_of_2x_samples-1) && (first_cycle_acc==1'b0)) begin
		     if (test_mode==0) begin //single shot, wait for trigger
			dbg_sm <= DBGBUF_IDLE;
			en <= 0;
			wr_en <= 8'h00;
		     end
		     else begin
			addr <= 0;
		     end
		  end
		  else begin
		     if (first_cycle_acc==1) begin
			//wr_data [63:32]<= IFP_adc_lcl[0].tdata; 
			wr_data [63:32]<= IFP_adc_mux_in.tdata; //SM 2020_05_14		
			wr_en <= 8'hF0;  
		     end
		     else begin	
			addr <= addr + 1;	       
			//wr_data[31:0] <= IFP_adc_lcl[0].tdata;
			wr_data[31:0] <= IFP_adc_mux_in.tdata; //SM 2020_05_14
			wr_en <= 8'h0F;  
		     end
		  end // else: !if((addr == test_num_of_2x_samples-1) && (first_cycle_acc==1'b0))
	       end // else: !if(test_path_select == DLDFE_TO_DBGBUF)
	    end // if (wr_data_valid)
	 end // case: WRITE_DBGBUF
	 default :begin
	    addr <= 0;
	    wr_en <= 0;
	    en <= 1'b0;
	    first_cycle_acc<=1'b0;
	    dbg_sm <= DBGBUF_IDLE;	 
	 end
	 endcase	 
      end // else: !if(!resetn_3x)
  end // always @ (posedge clk)
   
assign o_first_cycle_acc = first_cycle_acc;
assign o_rd_data         = rd_data;


//   assign rd_data_half = first_half_data_valid[RD_LATENCY-1] ? rd_data[31:0] : rd_data[63:32];
   //assign wr_data_valid = (test_path_select == DLDFE_TO_DBGBUF) ? IFP_dl_dfe_out[0].tvalid : IFP_adc_lcl[0].tvalid;
   assign wr_data_valid = (test_path_select == DLDFE_TO_DBGBUF) ? IFP_dl_dfe_out[0][0].tvalid : IFP_adc_mux_in.tvalid;  //SM 2020_05_14

    always @(posedge clk_3x) begin
       //for timing
       wr_data_reg <= wr_data;
       wr_en_reg <= wr_en;
       en_reg <= en;
       addr_reg <= {{(32-(MAX_NUM_SAMPLES_BW-1+3)){1'b0}},addr[MAX_NUM_SAMPLES_BW-2:0],3'b000};
       
       IFP_bram_dbgbuf.wr_data <= wr_data;
       IFP_bram_dbgbuf.wr_en <= wr_en;
       IFP_bram_dbgbuf.en <= en;
       IFP_bram_dbgbuf.addr <= {{(32-(MAX_NUM_SAMPLES_BW-1+3)){1'b0}},addr[MAX_NUM_SAMPLES_BW-2:0],3'b000};

    end
   
   
    // retime data from orx to ease timing
    always_ff @(posedge clk_3x) begin
        orx_uldfe_tvalid[0][0] <= IFP_srx[0][0].tvalid;
        orx_uldfe_tdata [0][0] <= IFP_srx[0][0].tdata;    // {q,i}
        orx_uldfe_tvalid[0][1] <= IFP_srx[0][1].tvalid;
        orx_uldfe_tdata [0][1] <= IFP_srx[0][1].tdata;
        orx_uldfe_tvalid[0][2] <= IFP_srx[0][2].tvalid;
        orx_uldfe_tdata [0][2] <= IFP_srx[0][2].tdata;
        orx_uldfe_tvalid[0][3] <= IFP_srx[0][3].tvalid;
        orx_uldfe_tdata [0][3] <= IFP_srx[0][3].tdata;
        orx_uldfe_tvalid[N_ANTS_SEL-1][0] <= IFP_srx[N_ANTS_SEL-1][0].tvalid;
        orx_uldfe_tdata [N_ANTS_SEL-1][0] <= IFP_srx[N_ANTS_SEL-1][0].tdata;    // {q,i}
        orx_uldfe_tvalid[N_ANTS_SEL-1][1] <= IFP_srx[N_ANTS_SEL-1][1].tvalid;
        orx_uldfe_tdata [N_ANTS_SEL-1][1] <= IFP_srx[N_ANTS_SEL-1][1].tdata;
        orx_uldfe_tvalid[N_ANTS_SEL-1][2] <= IFP_srx[N_ANTS_SEL-1][2].tvalid;
        orx_uldfe_tdata [N_ANTS_SEL-1][2] <= IFP_srx[N_ANTS_SEL-1][2].tdata;
        orx_uldfe_tvalid[N_ANTS_SEL-1][3] <= IFP_srx[N_ANTS_SEL-1][3].tvalid;
        orx_uldfe_tdata [N_ANTS_SEL-1][3] <= IFP_srx[N_ANTS_SEL-1][3].tdata;		
    end
     
   genvar   j,k;
   generate
    for (k = 0; k <  N_ANTS_SEL; k = k + 1) begin
      for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: mem_rd_route
        assign adc_i[k][j]                 =  $signed(IFP_adc_reg[k][j].tdata[15:0]);
        assign adc_q[k][j]                 = -$signed(IFP_adc_reg[k][j].tdata[31:16]);
		
        assign IFP_adc_lcl[k][j].tdata     = IFP_dbg_ctrl.adc_invert_q ? {adc_q[k][j], adc_i[k][j]} : IFP_adc_reg[k][j].tdata;
        assign IFP_adc_lcl[k][j].tvalid    = IFP_adc_reg[k][j].tvalid;
		
        assign IFP_adc[k][j].tready        = 1'b1;
	    always_ff @(posedge clk_3x) begin
	       if (!resetn_3x) begin
	    
	          
	          IFP_adc_reg[k][j].tdata    <= 0; //not adding reset 
              IFP_adc_reg[k][j].tvalid   <= 0;
	       end
	       else begin
	    
              IFP_adc_reg[k][j].tdata     <= IFP_adc[k][j].tdata[31:0]; //not adding reset 
              IFP_adc_reg[k][j].tvalid    <= IFP_adc[k][j].tvalid;
	          end
	    end
      end : mem_rd_route
	end
    endgenerate
	
	
//   ila_dbg dbg_ila (
//	.clk    (clk_3x                              ), // input wire clk
//	.probe0 (test_mode                           ), // input wire [0:0]  probe0  
//	.probe1 (test_path_select                    ), // input wire [0:0]  probe1 
//	.probe2 (dbg_sm                              ), // input wire [1:0]  probe2 
//	.probe3 (IFP_bram_dbgbuf.en                  ), // input wire [0:0]  probe3 
//	.probe4 (IFP_bram_dbgbuf.addr[19:0]          ), // input wire [19:0]  probe4 
//	.probe5 (rfbuf_trig                          ), // input wire [0:0]  probe5 
//	.probe6 ({rd_data[47:32],rd_data[15:0]}      ), // input wire [31:0]  probe6 
//	.probe7 (IFP_dbg_ctrl.dfe_adcdac_test_trigger), // input wire [0:0]  probe7 
//	.probe8 (first_cycle_acc                     ), // input wire [0:0]  probe8 
//	.probe9 (IFP_bram_dbgbuf.wr_en               ), // input wire [0:0]  probe9
//	.probe10(start_pulse                         ), // input wire [0:0]  probe10 
//	.probe11(resetn_3x                           ), // input wire [0:0]  probe11
//	.probe12(test_num_of_2x_samples[7:0]         ) // input wire [0:0]  probe11
//    );

 
endmodule
	     
