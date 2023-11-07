module jb_top_TCS(
	input 	                	ptp_clk					,	//500MHz		2	
    input                   	ptp_reset				,
    input                   	s_tvalid                ,
    input 	                    clk						,	//491.52MHz		2.034
    input 	                    reset					, 
	input                       dl_frm_mrkr_from_lphy   ,
	input  [31:0]               dl_frm_mrkr_cntr_ns		,	//提前给
    input  [31:0]               ul_frm_mrkr_cntr_ns		,	//提前给
    input  [31:0]               prach_frm_mrkr_cntr_ns	,	//提前给 
    input  [2:0]                ant_sel                 ,
    jb_test_ctrl_if.test_dbg    IFP_test_ctrl           ,
    output  logic               dl_10ms_sel             ,
	output	logic			    DL_state        		,   
	output  logic               GP1_state        		, 
	output  logic               GP2_state        		, 
	output  logic               UL_state				,
    output  logic               Error_10ms              ,	
	output  logic           	dl_frm_mrkr_10ms		,	
    output  logic           	ul_frm_mrkr_10ms		,	
    output  logic           	prach_frm_mrkr_10ms	    , 	
	output  logic				syn_data_dl_ul_5ms_ddr  ,
							    
	output  logic               DAC_RF_output		    ,	
	output	logic  [8:1]        SW_RXFB_DV_EN			,
	output	logic  [2:1]        SW_PA_RXFB_VCTL		    ,
	output	logic  [2:1]        SW_RXFB_VCTL			,
	output	logic  [2:1]        SW_RXFB_VCTL_N			,
	output	logic  [2:1]        SW_PA_LNA_VCTL			,
	output	logic  [2:1]        PA_LNA_EN				,
	output	logic  [8:1]        PA_CTRL_EN				,
	output	logic  [4:1]        PrDrvEN_X				,
	output	logic		        RX_Gainblock_EN			,
	output	logic		        TX_Gainblock_EN			
);

logic 		 pulse_1s    				;
logic [31:0] systimer_ns         		;
logic        dl_frm_mrke_10ms_one_clk   ;
logic        s_tvalid_d0                ;
logic        s_tvalid_d1                ;
logic        s_tvalid_p                 ;
logic [31:0] delay_10ms_count = 32'd0;
logic		 start_delay  = 1'b0;
logic		 delayed_10ms = 1'b0;
assign       s_tvalid_p   = ~s_tvalid_d1 & s_tvalid_d0;

always_ff @ (posedge clk) begin
	if ( IFP_test_ctrl.debug_rw[1] == 0 )
		dl_10ms_sel <= delayed_10ms;
	else
		dl_10ms_sel <= dl_frm_mrke_10ms_one_clk;
end


always_ff @ (posedge ptp_clk) begin
	if(ptp_reset) begin
		s_tvalid_d0 <= 'd0;
		s_tvalid_d1 <= 'd0;		
	end             
	else begin      
		s_tvalid_d0 <= s_tvalid;
		s_tvalid_d1 <= s_tvalid_d0;
	end
end


always_ff @ (posedge ptp_clk) begin			//500
	if(ptp_reset) begin
		pulse_1s 	<= 0;
		systimer_ns <= 32'h0;
	end
	else begin
		if( s_tvalid_p ) begin
			pulse_1s <= 1;
			systimer_ns <= 32'd1;
		end
		else if(systimer_ns == 32'd500_0000) begin
			pulse_1s <= 1;
			systimer_ns <= 32'd1;
		end
		else if(systimer_ns >= 32'd1) begin
			pulse_1s<= 0;
			systimer_ns <= systimer_ns + 1'b1;
		end
	end
end

logic        pulse_10ms_500;
logic [31:0] count_10ms_500;
always_ff @ (posedge ptp_clk) begin				
	if(reset) begin
		pulse_10ms_500 <= 0;
		count_10ms_500 <= 32'd0;
	end
	else begin
		if( s_tvalid_p ) begin
			pulse_10ms_500 <= 1;	
			count_10ms_500 <= 32'd1;
		end
		else if(count_10ms_500 == 32'd500_0000) begin
			pulse_10ms_500 <= 1;
			count_10ms_500 <= 32'd1;
		end
		else if(count_10ms_500 >= 32'd1) begin
			pulse_10ms_500 <= 0;
			count_10ms_500 <= count_10ms_500 + 1'b1;
		end
	end
end

//delay_10ms
always_ff @ (posedge clk) begin
	if(start_delay && delay_10ms_count == IFP_test_ctrl.debug_rw[17])
		delayed_10ms <= 1'b1;
	else
		delayed_10ms <= 1'b0;
end

always_ff @ (posedge clk) begin
	if(dl_frm_mrkr_from_lphy)
		start_delay <= 1'b1;
	else if(delay_10ms_count == IFP_test_ctrl.debug_rw[17])
		start_delay <= 1'b0;
end

always_ff @ (posedge clk) begin
	if(start_delay)
		delay_10ms_count <= delay_10ms_count + 1'b1;
	else
		delay_10ms_count <= 32'd0;
end


jb_RF_switch_control switch(
	.clk						(clk					 ),
	.reset					    (reset					 ),
	
	.pulse_10ms					(dl_10ms_sel             ),
	.ant_sel                    (ant_sel                 ),													 
	.DL_state				    (DL_state				 ),
    .GP1_state				    (GP1_state				 ),
	.GP2_state                  (GP2_state				 ),
    .UL_state				    (UL_state				 ),
	.IFP_test_ctrl				(IFP_test_ctrl       	 ),													 
	.DAC_RF_output				(DAC_RF_output			 ),
    .SW_RXFB_DV_EN			    (SW_RXFB_DV_EN			 ),
    .SW_PA_RXFB_VCTL		    (SW_PA_RXFB_VCTL		 ),
    .SW_RXFB_VCTL			    (SW_RXFB_VCTL			 ),                   
    .SW_RXFB_VCTL_N			    (SW_RXFB_VCTL_N			 ),
    .SW_PA_LNA_VCTL			    (SW_PA_LNA_VCTL			 ),
    .PA_LNA_EN				    (PA_LNA_EN				 ),                      
    .PA_CTRL_EN				    (PA_CTRL_EN				 ),
    .PrDrvEN_X				    (PrDrvEN_X				 ),
    .RX_Gainblock_EN		    (RX_Gainblock_EN		 ),
    .TX_Gainblock_EN		    (TX_Gainblock_EN		 )
);                              

jb_control_state2 control_state2(
	.clk                        (clk           	         ),
	.reset                      (reset            	     ),
	.pulse_10ms                 (dl_10ms_sel             ),														  
	.IFP_test_ctrl				(IFP_test_ctrl			 ),														  
	.DL_state					(DL_state				 ),
	.GP1_state                  (GP1_state				 ),
	.UL_state                   (UL_state			     ),
	.GP2_state                  (GP2_state				 ),
	.Error_10ms                 (Error_10ms              )
);

jb_sys_frm_gen_tcs u_jb_sys_frm_gen_tcs(
	.ptp_clk					(ptp_clk				 ),
	.ptp_reset					(ptp_reset				 ),
	.one_pps					(pulse_1s				 ),														 
	.clk						(clk					 ),
	.reset						(reset					 ),														 
	.dl_frm_mrkr_cntr_ns		(dl_frm_mrkr_cntr_ns	 ),
	.ul_frm_mrkr_cntr_ns		(ul_frm_mrkr_cntr_ns	 ),
	.prach_frm_mrkr_cntr_ns		(prach_frm_mrkr_cntr_ns	 ),
	.syn_data_dl_ul_5ms			(syn_data_dl_ul_5ms_ddr  ),			
														 
	.frm_mrkr_gen_trigger		(pulse_10ms_500	         ),
	.frm_mrkr_gen_enable		(1'b1	                 ),	
	.systimer_ns				(systimer_ns			 ),
		
	.dl_frm_mrkr_10ms			(dl_frm_mrkr_10ms        ),
	.dl_frm_mrke_10ms_one_clk   (dl_frm_mrke_10ms_one_clk),
	.ul_frm_mrkr_10ms			(ul_frm_mrkr_10ms		 ),
	.prach_frm_mrkr_10ms	    (prach_frm_mrkr_10ms	 ) 
);

endmodule