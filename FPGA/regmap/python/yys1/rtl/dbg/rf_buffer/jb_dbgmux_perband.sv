
`timescale 1 ps / 1 ps


module jb_dbgmux_perband #(
    parameter N_ANTS_SEL   =0,
    parameter N_ANTENNAS   =4,
    parameter N_CARRIERS   =2,
    parameter DFE_PRECISION=16
) (
      input                      clk_3x           ,
      input                      clk_1x           ,
      input [N_CARRIERS-1:0]     dl_clk_x1en      ,
      input [N_CARRIERS-1:0]     ul_clk_x1en      ,
      input                      resetn_3x        ,
      input                      resetn_1x        ,
	  input                      syn_data_dl_ul_5ms,
      input                      rssi_load        ,
      input                      pa_odp_tssi_le   ,
      output logic  [3:0] [31:0] pa_odp_tssi      ,
      input [63:0] 		         i_rd_data        ,
      input                      i_first_cycle_acc,
      input                      i_en             ,
      output logic  [3:0] [31:0] ant_tssi         ,
      output logic  [3:0] [31:0] ul_ant_wrssi     ,
      output logic  [3:0] [31:0] orx_wrssi        ,
      jb_test_ctrl_if.test_dbg   IFP_test_ctrl    , 
      jb_hw_ctrl_if.hw_ctrl      IFP_hw_ctrl      ,  	  
      jb_axi4_stream_if.slave    IFP_srx[N_ANTENNAS-1:0]       , //incoming
      jb_axi4_stream_if.slave    IFP_adc[N_ANTENNAS-1:0]       , //incoming
      jb_axi4_stream_if.slave    IFP_adc_iq[N_ANTENNAS-1:0]       , //incoming	  
      jb_axi4_stream_if.master   IFP_dac[N_ANTENNAS-1:0]       , //drive       
      jb_axi4_stream_if.slave    IFP_dl_dfe_out[N_ANTENNAS-1:0],
      jb_axi4_stream_if.master   IFP_ul_dfe_in[N_ANTENNAS-1:0] ,    
      jb_axi4_stream_if.master   IFP_dl_dfe_in[N_CARRIERS-1:0] ,
      jb_axi4_stream_if.slave    IFP_ul_dfe_out[N_CARRIERS-1:0],   
      jb_axi4_stream_if.slave    IFP_fh_dl[N_CARRIERS-1:0]    ,
      jb_axi4_stream_if.master   IFP_fh_ul[N_CARRIERS-1:0]     ,
      jb_axi4_stream_if.slave    IFP_fh_ul_test_data    

				   
       				   
				    

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

   localparam RD_LATENCY=4+1-2; //orig 4
   
   
   
   
   logic [2:0] 			             test_path_select      ; //debug mode
   logic 			                 rd_data_valid         ;
   logic                             orx_to_uldfe_en       ;
   logic [N_ANTENNAS-1:0] [2*16-1:0] orx_uldfe_tdata       ;
   logic [N_ANTENNAS-1:0]            orx_uldfe_tvalid      ;   
   logic [RD_LATENCY-1:0] 	         en_dly                ;
   logic [RD_LATENCY-1:0]            first_half_data_valid ;
   logic [7:0] 			             wr_en                 ;





   logic [31:0] rd_data_half ;
   logic        wr_data_valid;

   
   logic  [N_CARRIERS-1:0] uldfe_to_dldfe_lpbk_enable        ;
   logic  [N_CARRIERS-1:0] uldfe_to_dldfe_lpbk_enable_latched;
   logic signed [N_ANTENNAS-1:0] [DFE_PRECISION-1:0] adc_q;
   logic signed [N_ANTENNAS-1:0] [DFE_PRECISION-1:0] adc_i;
   
   logic              rx0_to_all_ul_paths;   
//   logic  [3:0][31:0] ant_tssi_i           ;
   logic  [3:0][31:0] pa_odp_tssi_temp   ;

   localparam MAX_NUM_ADCDAC_SAMPLES_BW = 19;

   jb_axi4_stream_if  #(.DATA_WIDTH(2*16), .USER_SB_WIDTH(2))            IFP_ul_dfe_lpbk [N_CARRIERS-1:0] ();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*DFE_PRECISION), .USER_SB_WIDTH(1)) IFP_adc_reg[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*DFE_PRECISION), .USER_SB_WIDTH(1)) IFP_adc_lcl[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(2*DFE_PRECISION), .USER_SB_WIDTH(1)) IFP_adc_mux_in(); //SM 2020_05_14
   jb_axi4_stream_if  #(.DATA_WIDTH(2*DFE_PRECISION), .USER_SB_WIDTH(1)) IFP_orx_reg[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(64), .USER_SB_WIDTH(1)) IFP_dac_reg[N_ANTENNAS-1:0]();
   jb_axi4_stream_if  #(.DATA_WIDTH(64), .USER_SB_WIDTH(1)) IFP_ul_dfe_in_reg[N_ANTENNAS-1:0]();
    
   logic             lpbk_fifo_rst   [N_CARRIERS-1:0];
   logic             lpbk_fifo_we    [N_CARRIERS-1:0];
   logic             lpbk_fifo_re    [N_CARRIERS-1:0];
   logic [33:0]      lpbk_fifo_din   [N_CARRIERS-1:0];
   logic [33:0]      lpbk_fifo_dout  [N_CARRIERS-1:0];
   logic             lpbk_fifo_full  [N_CARRIERS-1:0];
   logic             lpbk_fifo_empty [N_CARRIERS-1:0];
   logic             lpbk_fifo_valid [N_CARRIERS-1:0];
   logic [3:0] [63:0]s_adc_data;
   
   genvar 			  i;
   generate
      for (i = 0; i <  N_CARRIERS; i = i + 1) begin: ul_to_dl_lpbk


    // ------------------------------------------------------------------ //
    // For Loopback - Clocks from UL and DL are async
    // ------------------------------------------------------------------ //
    // FIFO to loopback UL data
    assign lpbk_fifo_rst[i] = ~IFP_test_ctrl.uldfe_to_dldfe_lpbk[N_ANTS_SEL] | ~resetn_1x;
    assign lpbk_fifo_we[i]  = ul_clk_x1en[i] & IFP_ul_dfe_out[i].tvalid;
    assign lpbk_fifo_din[i] = {IFP_ul_dfe_out[i].tuser, IFP_ul_dfe_out[i].tdata};
    assign lpbk_fifo_re[i]  = dl_clk_x1en[i] & ~lpbk_fifo_empty[i];
    
//    fifo_native_cclk_32x16 fifo_ul2dl_lpbk (
//        .clk                            (clk_1x),                       // i
//        .rst                            (lpbk_fifo_rst[i] ),             // i
//        .din                            (lpbk_fifo_din[i] ),             // i [33 : 0]
//        .wr_en                          (lpbk_fifo_we[i]  ),              // i
//        .rd_en                          (lpbk_fifo_re[i]  ),              // i
//        .dout                           (lpbk_fifo_dout[i]),            // o [33 : 0]
//        .full                           (lpbk_fifo_full[i]),            // o
//        .empty                          (lpbk_fifo_empty[i]),           // o
//        .valid                          ()                              // o
//    );

    always_ff @(posedge clk_1x) begin
        if (lpbk_fifo_rst[i])
            lpbk_fifo_valid[i] <= 0;
        else if (dl_clk_x1en[i])
            lpbk_fifo_valid[i] <= lpbk_fifo_re[i];
    end

    assign IFP_ul_dfe_lpbk[i].tdata    = lpbk_fifo_dout[i][31:0];
    assign IFP_ul_dfe_lpbk[i].tuser    = lpbk_fifo_dout[i][33:32];
    assign IFP_ul_dfe_lpbk[i].tvalid   = lpbk_fifo_valid[i];
    // ------------------------------------------------------------------ //
    
      
      //Data is interleaved, switch the data at the start user id=0, switch back when usr-id=3
       always_comb begin
       if (IFP_test_ctrl.uldfe_to_dldfe_lpbk[N_ANTS_SEL] & (!IFP_ul_dfe_lpbk[i].tvalid || IFP_ul_dfe_lpbk[i].tuser==0)) begin
         uldfe_to_dldfe_lpbk_enable[i] = 1'b1;
        end
        else if (uldfe_to_dldfe_lpbk_enable_latched[i]==1'b1 && !IFP_test_ctrl.uldfe_to_dldfe_lpbk[N_ANTS_SEL] && (!IFP_ul_dfe_lpbk[i].tvalid || IFP_ul_dfe_lpbk[i].tuser== 0)) begin
          uldfe_to_dldfe_lpbk_enable[i] = 1'b0;
        end
        else begin
         uldfe_to_dldfe_lpbk_enable[i] = uldfe_to_dldfe_lpbk_enable_latched;
        end
       end
       
       always_ff @(posedge clk_1x) begin
        if (!resetn_1x) begin
	      uldfe_to_dldfe_lpbk_enable_latched[i] <= 1'b0;
        end
        else if (dl_clk_x1en[i]) begin 
           uldfe_to_dldfe_lpbk_enable_latched[i] <= uldfe_to_dldfe_lpbk_enable[i];
        end
       end
       always_ff @(posedge clk_1x) begin 
        if (!resetn_1x) begin
            IFP_dl_dfe_in[i].tvalid <= '0;
            IFP_dl_dfe_in[i].tdata <= '0;
            IFP_dl_dfe_in[i].tuser <= '0;
        end
		//zle comment: the ecpri data or the output of ul dfe can be used as the input of dl dfe
        else if (dl_clk_x1en[i]) begin
            //IFP_dl_dfe_in[i].tvalid <= uldfe_to_dldfe_lpbk_enable[i] ? IFP_ul_dfe_lpbk[i].tvalid : IFP_fh_dl[i].tvalid;
            //IFP_dl_dfe_in[i].tdata  <= uldfe_to_dldfe_lpbk_enable[i] ? IFP_ul_dfe_lpbk[i].tdata  : IFP_fh_dl[i].tdata;	 
            //IFP_dl_dfe_in[i].tuser  <= uldfe_to_dldfe_lpbk_enable[i] ? IFP_ul_dfe_lpbk[i].tuser  : IFP_fh_dl[i].tuser;
			
            IFP_dl_dfe_in[i].tvalid <=  IFP_fh_dl[i].tvalid;
            IFP_dl_dfe_in[i].tdata  <=  IFP_fh_dl[i].tdata;	 
            IFP_dl_dfe_in[i].tuser  <=  IFP_fh_dl[i].tuser;
        end
	   end

       always_ff @(posedge clk_1x) begin 
        if (!resetn_1x) begin
            IFP_fh_ul[i].tvalid <= '0;
            IFP_fh_ul[i].tdata  <= '0;
            IFP_fh_ul[i].tuser  <= '0;
        end
		//zle comment: IFP_fh_ul_test_data is equal to the output of fh buffer in dl
		//there are three data source which can be used as input of ul ecpri: fh buffer in dl, the output of ul dfe, the output of dl ecpri
        else if (ul_clk_x1en[i]) begin
            IFP_fh_ul[i].tvalid <= (IFP_test_ctrl.fh_dbg_mode==2'b01) ? IFP_fh_ul_test_data.tvalid : ((IFP_test_ctrl.fh_dbg_mode==2'b10) ? IFP_fh_dl[i].tvalid : IFP_ul_dfe_out[i].tvalid);
            IFP_fh_ul[i].tdata  <= (IFP_test_ctrl.fh_dbg_mode==2'b01) ? IFP_fh_ul_test_data.tdata : ((IFP_test_ctrl.fh_dbg_mode==2'b10) ? IFP_fh_dl[i].tdata : IFP_ul_dfe_out[i].tdata);
            IFP_fh_ul[i].tuser  <= (IFP_test_ctrl.fh_dbg_mode==2'b01) ? IFP_fh_ul_test_data.tuser: ((IFP_test_ctrl.fh_dbg_mode==2'b10) ? IFP_fh_dl[i].tuser : IFP_ul_dfe_out[i].tuser);	 


        end
	   end
	 assign IFP_ul_dfe_out[i].tready = 1'b1;
	 assign IFP_fh_dl[i].tready = 1'b1;	 
      end : ul_to_dl_lpbk
   endgenerate
   


   
   
   //////////////////////////////////////////////////////////////////////////////////////
   //////////////////////// DBGBUFFER PATH //////////////////////////////////////////////
   ////////////////////////////////////////////////////////////////////////////////////
   assign orx_to_uldfe_en = IFP_test_ctrl.orx_to_uldfe_en[N_ANTS_SEL];
   assign rx0_to_all_ul_paths= IFP_test_ctrl.rx0_to_all_ul_paths[N_ANTS_SEL];
   assign test_path_select=IFP_test_ctrl.dfe_adcdac_test_path_select;
   logic  overiride_tcs_mode_control_rx_tx;	
   assign overiride_tcs_mode_control_rx_tx = (IFP_test_ctrl.debug_rw[0] == 'd0 ? IFP_hw_ctrl.rx_tx_mode_sel : syn_data_dl_ul_5ms);
	       
   always_ff @(posedge clk_3x) begin
      if (!resetn_3x) begin
	    en_dly <= 0;
	    first_half_data_valid <= 0;
      end
      else begin
//         en_dly <= {en_dly[RD_LATENCY-2:0],IFP_bram_dbgbuf_mem.en};
        en_dly <= {en_dly[RD_LATENCY-2:0],i_en};
//         first_half_data_valid <= {first_half_data_valid[RD_LATENCY-2:0],first_cycle_acc};
	    first_half_data_valid <= {first_half_data_valid[RD_LATENCY-2:0],i_first_cycle_acc};
      end
   end

   assign rd_data_valid = en_dly[RD_LATENCY-1];
   

   
//zle modify
//   assign rd_data_half = first_half_data_valid[RD_LATENCY-1] ? rd_data[31:0] : rd_data[63:32];
   assign rd_data_half = first_half_data_valid[RD_LATENCY-1] ? i_rd_data[31:0] : i_rd_data[63:32];
   //assign wr_data_valid = (test_path_select == DLDFE_TO_DBGBUF) ? IFP_dl_dfe_out[0].tvalid : IFP_adc_lcl[0].tvalid;
   assign wr_data_valid = (test_path_select == DLDFE_TO_DBGBUF) ? IFP_dl_dfe_out[0].tvalid : IFP_adc_mux_in.tvalid;  //SM 2020_05_14


   
   
    // retime data from orx to ease timing
    always_ff @(posedge clk_3x) begin
        orx_uldfe_tvalid[0] <= IFP_srx[0].tvalid;
        orx_uldfe_tdata [0] <= IFP_srx[0].tdata;    // {q,i}
        orx_uldfe_tvalid[1] <= IFP_srx[1].tvalid;
        orx_uldfe_tdata [1] <= IFP_srx[1].tdata;
        orx_uldfe_tvalid[2] <= IFP_srx[2].tvalid;
        orx_uldfe_tdata [2] <= IFP_srx[2].tdata;
        orx_uldfe_tvalid[3] <= IFP_srx[3].tvalid;
        orx_uldfe_tdata [3] <= IFP_srx[3].tdata;
    end
     
   genvar   j;
   generate
      for (j = 0; j <  N_ANTENNAS; j = j + 1) begin: mem_rd_route
        assign adc_i[j]              = $signed(IFP_adc_reg[j].tdata[15:0]);
        assign adc_q[j]              = -$signed(IFP_adc_reg[j].tdata[31:16]);
        assign IFP_adc_lcl[j].tdata  = IFP_test_ctrl.adc_invert_q ? {adc_q[j], adc_i[j]} : IFP_adc_reg[j].tdata;
        assign IFP_adc_lcl[j].tvalid = IFP_adc_reg[j].tvalid;
        assign IFP_adc[j].tready     = 1'b1;
		assign IFP_dac_reg[j].tdata  =  IFP_dac[j].tdata;
		assign IFP_dac_reg[j].tvalid =  IFP_dac[j].tvalid;
		assign IFP_ul_dfe_in_reg[j].tdata  = IFP_ul_dfe_in[j].tdata;
		assign IFP_ul_dfe_in_reg[j].tvalid = IFP_ul_dfe_in[j].tvalid;
	 always_ff @(posedge clk_3x) begin
	    if (!resetn_3x) begin
	        IFP_dac[j].tdata       <= 0;
	       IFP_dac[j].tvalid       <= 0;	 
	       IFP_ul_dfe_in[j].tdata  <= 0;
	       IFP_ul_dfe_in[j].tvalid <= 0;
	       IFP_ul_dfe_in[j].tuser  <= 0;	       
	       IFP_adc_reg[j].tdata    <= 0; //not adding reset 
           IFP_adc_reg[j].tvalid   <= 0;
		   IFP_orx_reg[j].tdata    <= 0;
		   IFP_orx_reg[j].tvalid   <= 0;		   
	    end
		//zle comment: the data from adc or feedback adc can be used as the input of ul dfe, IFP_ul_dfe_in
		//the output of dl dfe or ecpri data or output of 1/4 fs in ul can be used as the input of dac, IFP_dac
	    else begin
//zle modify		
//	       IFP_dac[j].tdata <=  (test_path_select == DBGBUF_TO_DAC) ? rd_data : IFP_dl_dfe_out[j].tdata;

		   //IFP_dac[j].tdata       <=  (test_path_select == DBGBUF_TO_DAC)   ? i_rd_data : IFP_adc[j].tdata;
		   
		   
		   s_adc_data[j]          <= { {IFP_adc[j].tdata[63],IFP_adc[j].tdata[57:48],5'd0}, {IFP_adc[j].tdata[47],IFP_adc[j].tdata[41:32],5'd0}, 
		                               {IFP_adc[j].tdata[31],IFP_adc[j].tdata[25:16],5'd0}, {IFP_adc[j].tdata[15],IFP_adc[j].tdata[9:0],5'd0} };									   
           //IFP_dac[j].tdata       <= (test_path_select == DBGBUF_TO_DAC)  ? i_rd_data : s_adc_data[j];		   
	       //IFP_dac[j].tvalid      <=  (test_path_select == DBGBUF_TO_DAC)   ? rd_data_valid : IFP_adc[j].tvalid;
	       IFP_dac[j].tdata       <=  (test_path_select == DBGBUF_TO_DAC)   ? s_adc_data[j]     : IFP_dl_dfe_out[j].tdata;
	       IFP_dac[j].tvalid      <=  (test_path_select == DBGBUF_TO_DAC)   ? IFP_adc[j].tvalid : IFP_dl_dfe_out[j].tvalid;			   
	       
	       IFP_ul_dfe_in[j].tdata  <= IFP_adc_iq[j].tdata[31:0];
	       IFP_ul_dfe_in[j].tvalid <= IFP_adc_iq[j].tvalid;
	       IFP_ul_dfe_in[j].tuser  <= 0;	       
	       //Don't connect tvalid Since ADC tvalid is high, if the tvalid from ADC are not in sync then fir ourput is not in sync      
//	       IFP_adc_reg[j].tdata    <= IFP_adc[j].tdata[31:0]; //not adding reset 
//         IFP_adc_reg[j].tvalid   <= IFP_adc[j].tvalid;

	       IFP_adc_reg[j].tdata    <= IFP_adc_iq[j].tdata[31:0]; //not adding reset 
           IFP_adc_reg[j].tvalid   <= IFP_adc_iq[j].tvalid;
		   
		   IFP_orx_reg[j].tdata    <= (overiride_tcs_mode_control_rx_tx == 1'b1) ? IFP_adc[j].tdata[31:0] : 'b0; //not adding reset 
           IFP_orx_reg[j].tvalid   <= (overiride_tcs_mode_control_rx_tx == 1'b1) ? IFP_adc[j].tvalid      : 'b0;
	       end
	 end
     end : mem_rd_route
 endgenerate 

jb_powermeter #(
    .N_ANTS_SEL   (N_ANTS_SEL   ),
    .N_ANTENNAS   (N_ANTENNAS   ),
    .N_CARRIERS   (N_CARRIERS   ),
    .DFE_PRECISION(DFE_PRECISION)
) u_jb_powermeter(

      .clk_3x            (clk_3x            ),
      .resetn_3x         (resetn_3x         ),
	  .syn_data_dl_ul_5ms(syn_data_dl_ul_5ms),
      .rssi_load         (rssi_load         ),
  	  .IFP_hw_ctrl       (IFP_hw_ctrl       ),
      .IFP_test_ctrl     (IFP_test_ctrl     ),	  
      .ant_tssi          (ant_tssi          ),
      .ul_ant_wrssi      (ul_ant_wrssi      ),
      .orx_wrssi         (orx_wrssi         ),	  
      .pa_odp_tssi_le    (pa_odp_tssi_le    ),
      .pa_odp_tssi       (pa_odp_tssi       ),	  
      .IFP_dac           (IFP_dac_reg       ),//(IFP_dac)      , 
      .IFP_ul_dfe_in     (IFP_adc_reg       ),//(IFP_ul_dfe_in),
      .IFP_srx           (IFP_orx_reg       ) 
);	  


//ila_0_for_dbg u_ila_0_for_dbg (
//	.clk   (clk_3x          ), 
//	.probe0(IFP_dac[0].tdata), // 64bits 
//	.probe1(IFP_dac[1].tdata), // 64bits 
//	.probe2(IFP_dac[2].tdata), // 64bits 
//	.probe3(IFP_dac[3].tdata)  // 64bits
//);
// 
// 
// 
//ila_1_for_dbg u_ila_1_for_dbg (
//	.clk   (clk_3x          ), 
//	.probe0(IFP_adc[0].tdata), // 64bits  
//	.probe1(IFP_adc[1].tdata), // 64bits 
//	.probe2(IFP_adc[2].tdata), // 64bits 
//	.probe3(IFP_adc[3].tdata)  // 64bits 
//); 

 
endmodule
	     
