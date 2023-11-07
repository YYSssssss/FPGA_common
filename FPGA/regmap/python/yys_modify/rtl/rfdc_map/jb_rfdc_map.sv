`timescale 1 ps / 1 ps

module jb_rfdc_map #(
    parameter   N_ANTENNAS              = 8,
    parameter   N_ADC                   = 8,
    parameter   N_DAC                   = 8,
	parameter   N_ANT_SEL               = 2
) (
    input                                              axis_clk,
    input                                              axis_aresetn,

    jb_hw_ctrl_if.hw_ctrl_rfdc         				   IFP_ctrl,
    jb_axi4_stream_if.slave                            IFP_adc         [N_ANT_SEL-1:0][N_ANTENNAS/2-1:0], //incoming
    jb_axi4_stream_if.master            			   IFP_srx         [N_ANTENNAS-1:0],
    jb_axi4_stream_if.master                           IFP_srx_copy    [N_ANT_SEL-1:0][N_ANTENNAS/2-1:0]
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
    localparam  USER_ID_BW = $clog2(N_ANTENNAS); // $clog2(N_ADC);
	
    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    genvar i;
    jb_axi4_stream_if  #(.DATA_WIDTH(32), .USER_SB_WIDTH(USER_ID_BW)) IFP_adc_copy      [N_ANT_SEL-1:0][N_ADC/2-1:0]();
	
    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
	
    // tready (DFE --> ADC)
	genvar band;
    generate
	for (band = 0; band < N_ANT_SEL;band = band + 1) begin
    for (i=0; i<=N_ADC/2-1; i=i+1)
    begin : gen_adc_tready
        assign IFP_adc[band][i].tready   = 1'b1;
        // Following assignments to avoid multi-dreven net with tready
        assign IFP_adc_copy[band][i].tdata  = IFP_adc[band][i].tdata;
        assign IFP_adc_copy[band][i].tvalid = IFP_adc[band][i].tvalid;
    end
	end
    endgenerate	
    // ------------------------------------------------------------------ //
    // ORX ADC Map                                                        //
    // ------------------------------------------------------------------ //
  //generate
  //for (i=0; i<=N_ANTENNAS-1; i=i+1)
  //begin : gen_orx_adc_map
  //    jb_adc_mux #(
  //        .N_ADC                  (N_ADC),
	//        .N_ANT_SEL              (2)
  //    ) jb_orx_adc_mux_u (
  //        .axis_clk               (axis_clk),             // i
  //        .axis_aresetn           (axis_aresetn),         // i
  //        .adc_sel                (IFP_ctrl.ul_dfe_orx_adc_sel[i]), // i [2:0]
  //        .IFP_adc                (IFP_adc_copy),         // jb_axi4_stream_if.slave [N_ADC-1:0]
  //        .IFP_dfe                (IFP_srx[i])            // jb_axi4_stream_if.master
  //    );
  //end
  //endgenerate
    
	assign IFP_srx_copy[0][0].tdata  = IFP_srx[0].tdata;
	assign IFP_srx_copy[0][0].tvalid = IFP_srx[0].tvalid;
	
	assign IFP_srx_copy[0][1].tdata  = IFP_srx[1].tdata;
	assign IFP_srx_copy[0][1].tvalid = IFP_srx[1].tvalid;	

	assign IFP_srx_copy[0][2].tdata  = IFP_srx[2].tdata;
	assign IFP_srx_copy[0][2].tvalid = IFP_srx[2].tvalid;	

	assign IFP_srx_copy[0][3].tdata  = IFP_srx[3].tdata;
	assign IFP_srx_copy[0][3].tvalid = IFP_srx[3].tvalid;

	assign IFP_srx_copy[1][0].tdata  = IFP_srx[4].tdata;
	assign IFP_srx_copy[1][0].tvalid = IFP_srx[4].tvalid;
	
	assign IFP_srx_copy[1][1].tdata  = IFP_srx[5].tdata;
	assign IFP_srx_copy[1][1].tvalid = IFP_srx[5].tvalid;	

	assign IFP_srx_copy[1][2].tdata  = IFP_srx[6].tdata;
	assign IFP_srx_copy[1][2].tvalid = IFP_srx[6].tvalid;	

	assign IFP_srx_copy[1][3].tdata  = IFP_srx[7].tdata;
	assign IFP_srx_copy[1][3].tvalid = IFP_srx[7].tvalid;
	


	assign  IFP_srx[0].tdata  = IFP_adc[0][0].tdata ;
	assign  IFP_srx[0].tvalid = IFP_adc[0][0].tvalid;
	
	assign  IFP_srx[1].tdata  = IFP_adc[0][1].tdata ;
	assign  IFP_srx[1].tvalid = IFP_adc[0][1].tvalid;
							    
	assign  IFP_srx[2].tdata  = IFP_adc[0][2].tdata ;
	assign  IFP_srx[2].tvalid = IFP_adc[0][2].tvalid;
							    
	assign  IFP_srx[3].tdata  = IFP_adc[0][3].tdata ;
	assign  IFP_srx[3].tvalid = IFP_adc[0][3].tvalid;
							    
	assign  IFP_srx[4].tdata  = IFP_adc[1][0].tdata ;
	assign  IFP_srx[4].tvalid = IFP_adc[1][0].tvalid;
							    
	assign  IFP_srx[5].tdata  = IFP_adc[1][1].tdata ;
	assign  IFP_srx[5].tvalid = IFP_adc[1][1].tvalid;
							    
	assign  IFP_srx[6].tdata  = IFP_adc[1][2].tdata ;
	assign  IFP_srx[6].tvalid = IFP_adc[1][2].tvalid;
							    
	assign  IFP_srx[7].tdata  = IFP_adc[1][3].tdata ;
	assign  IFP_srx[7].tvalid = IFP_adc[1][3].tvalid;










	
endmodule
