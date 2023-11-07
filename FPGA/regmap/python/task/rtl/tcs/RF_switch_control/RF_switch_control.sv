module jb_RF_switch_control(
	
	input				clk						,	 
	input				reset					,
	
	input				pulse_10ms				,
	
	input				DL_state				,
	input				GP1_state				,
	input				UL_state				,
	input				GP2_state				,
	
	jb_test_ctrl_if.test_dbg    IFP_test_ctrl   ,
	input	[2:0]		ant_sel					,

	output	logic  [8:1]PA_CTRL_EN				,
	output	logic		TX_Gainblock_EN			,
	output	logic		DAC_RF_output			,
	output	logic  [2:1]SW_PA_RXFB_VCTL		    ,
	output	logic  [8:1]SW_RXFB_DV_EN			,
	output	logic  [2:1]PA_LNA_EN				,
	output	logic		RX_Gainblock_EN			,
	output	logic  [2:1]SW_PA_LNA_VCTL			,
	output	logic       SW_RXFB_VCTL			,
	output	logic       SW_RXFB_VCTL_N			,	
	output	logic  [4:1]PrDrvEN_X				

);

parameter T_GP = 31'd70148;
logic [31:0] 	T_GP1;		//T_GP1 = T_GP - TA_offset	
logic [31:0]	T_GP2;		//according to 3GPP N_TA_offset	25600 or 39936

logic [31:0]	count_GP1;
logic [31:0]	count_GP2;
logic [31:0]	count_DLGP1_ULGP2;

//491.52MHz		2.034
logic	[31:0]		configure_SW_RXFB_DV_EN_GP2_ULtoDL		;
logic	[31:0]		configure_SW_RXFB_DV_EN_GP1_DLtoUL	 	;
logic	[31:0]		configure_SW_PA_RXFB_VCTL_GP2_ULtoDL	;
logic	[31:0]		configure_SW_PA_RXFB_VCTL_GP1_DLtoUL	;
logic	[31:0]		configure_SW_RXFB_VCTL_GP2_ULtoDL		;
logic	[31:0]		configure_SW_RXFB_VCTL_GP1_DLtoUL		;
logic	[31:0]		configure_SW_RXFB_VCTL_N_GP2_ULtoDL	 	;
logic	[31:0]		configure_SW_RXFB_VCTL_N_GP1_DLtoUL	 	;
logic	[31:0]		configure_SW_PA_LNA_VCTL_GP2_ULtoDL	 	;
logic	[31:0]		configure_SW_PA_LNA_VCTL_GP1_DLtoUL	 	;
logic	[31:0]		configure_PA_LNA_EN_GP2_ULtoDL			;
logic	[31:0]		configure_PA_LNA_EN_GP1_DLtoUL		 	;
logic	[31:0]		configure_PA_CTRL_EN_GP2_ULtoDL		 	;
logic	[31:0]		configure_PA_CTRL_EN_GP1_DLtoUL		 	;
logic	[31:0]		configure_PrDrvEN_X_GP2_ULtoDL			;
logic	[31:0]		configure_PrDrvEN_X_GP1_DLtoUL		 	;
logic	[31:0]		configure_RX_Gainblock_EN_GP2_ULtoDL	;
logic	[31:0]		configure_RX_Gainblock_EN_GP1_DLtoUL	;
logic	[31:0]		configure_TX_Gainblock_EN_GP2_ULtoDL	;
logic	[31:0]		configure_TX_Gainblock_EN_GP1_DLtoUL	;

logic	[31:0] 		DLGP1_duration						;
logic	[31:0]		DLGP1UL_duration					;

logic	[2:1]		TEM_SW_PA_LNA_VCTL					;
logic	[2:1]		Temp_PA_LNA_EN						;

always @ (posedge clk) begin
    if (reset)
		T_GP2 <= 32'd25600;		
	else if(IFP_test_ctrl.debug_rw[16][0] == 1'b0) begin
		T_GP2 <= 32'd25600;
	end          
	else begin   
		T_GP2 <= 32'd39936;
	end								//70148 - 25600 = 44548
end


always @ (posedge clk) begin
	if (reset)
		T_GP1 <= 'd0;
	else
		T_GP1 <= T_GP - T_GP2;     //70148 - 25600 = 44548
end

always_ff @ (posedge clk) begin
	if(reset)
		count_GP1 <= 32'd0;
	else if (pulse_10ms)
		count_GP1 <= 32'd0;
	else if(GP1_state) begin
		if(count_GP1 == 32'd44547)
			count_GP1 <= 1'b0;
		else 
			count_GP1 <= count_GP1 + 1'b1;
	end
end

always_ff @ (posedge clk) begin
	if(reset)
		count_GP2 <= 32'd0;
	else if (pulse_10ms)
		count_GP2 <= 32'd0;
	else if(GP2_state) begin
		if(count_GP2 == 32'd25599)
			count_GP2 <= 1'b0;
		else 
			count_GP2 <= count_GP2 + 1'b1;
	end
end

always_ff @ (posedge clk) begin
	if(reset)
		count_DLGP1_ULGP2 <= 32'd0;
	else if(IFP_test_ctrl.debug_rw[0][0] == 32'd0)
		count_DLGP1_ULGP2 <= 32'd0;
	else if(pulse_10ms)
		count_DLGP1_ULGP2 <= 32'd0;
	else if(count_DLGP1_ULGP2 == 32'd2457599)
		count_DLGP1_ULGP2 <= 32'd0;
	else if(DL_state || GP1_state || UL_state || GP2_state)
		count_DLGP1_ULGP2 <= count_DLGP1_ULGP2 + 1'd1;
end

always_ff @ (posedge clk) begin
	configure_PA_CTRL_EN_GP2_ULtoDL		<= T_GP2 - IFP_test_ctrl.debug_rw[6][31:16] - 2'd2;//2458	
	configure_PA_CTRL_EN_GP1_DLtoUL		<= IFP_test_ctrl.debug_rw[6][15:0];//491

	configure_TX_Gainblock_EN_GP2_ULtoDL<= T_GP2 - IFP_test_ctrl.debug_rw[7][31:16] - 2'd2;//737
	configure_TX_Gainblock_EN_GP1_DLtoUL<= IFP_test_ctrl.debug_rw[7][15:0];//245

	configure_SW_RXFB_DV_EN_GP2_ULtoDL	<= IFP_test_ctrl.debug_rw[8][31:16];
	configure_SW_RXFB_DV_EN_GP1_DLtoUL	<= T_GP1 - IFP_test_ctrl.debug_rw[8][15:0] - 2'd2;
	
	configure_RX_Gainblock_EN_GP2_ULtoDL<= IFP_test_ctrl.debug_rw[9][31:16];
	configure_RX_Gainblock_EN_GP1_DLtoUL<= T_GP1 - IFP_test_ctrl.debug_rw[9][15:0] - 2'd2;
	configure_PA_LNA_EN_GP2_ULtoDL		<= IFP_test_ctrl.debug_rw[10][31:16];
	configure_PA_LNA_EN_GP1_DLtoUL		<= T_GP1 - IFP_test_ctrl.debug_rw[10][15:0] - 2'd2;
																		
	configure_SW_PA_LNA_VCTL_GP2_ULtoDL	<= IFP_test_ctrl.debug_rw[11][31:16];
	configure_SW_PA_LNA_VCTL_GP1_DLtoUL	<= T_GP1 - IFP_test_ctrl.debug_rw[11][15:0] - 2'd2;
									
	configure_SW_RXFB_VCTL_N_GP2_ULtoDL	<= IFP_test_ctrl.debug_rw[12][31:16];
	configure_SW_RXFB_VCTL_N_GP1_DLtoUL	<= T_GP1 - IFP_test_ctrl.debug_rw[12][15:0] - 2'd2;
	configure_SW_PA_RXFB_VCTL_GP2_ULtoDL<= IFP_test_ctrl.debug_rw[13][31:16];
	configure_SW_PA_RXFB_VCTL_GP1_DLtoUL<= T_GP1 - IFP_test_ctrl.debug_rw[13][15:0] - 2'd2;
	configure_SW_RXFB_VCTL_GP2_ULtoDL	<= IFP_test_ctrl.debug_rw[14][31:16];
	configure_SW_RXFB_VCTL_GP1_DLtoUL	<= T_GP1 - IFP_test_ctrl.debug_rw[14][15:0] - 2'd2;
	
	configure_PrDrvEN_X_GP2_ULtoDL		<= IFP_test_ctrl.debug_rw[15][31:16];
	configure_PrDrvEN_X_GP1_DLtoUL		<= T_GP1 - IFP_test_ctrl.debug_rw[15][15:0] - 2'd2;
	
end

///////////////PA_CTRL_EN/////////////
always_ff @ (posedge clk) begin
	if(reset)
		PA_CTRL_EN	<=8'hff;
	else if(DL_state)				//DL
		PA_CTRL_EN	<=8'hff;
	else if(GP1_state && count_GP1 > configure_PA_CTRL_EN_GP1_DLtoUL)//DLtoUL
		PA_CTRL_EN 	<=8'd0;					//491
	else if(GP2_state && count_GP2 > configure_PA_CTRL_EN_GP2_ULtoDL)//ULtoDL	
		PA_CTRL_EN	<=8'hff;		 			//25600-2458 = 23142
	else if(UL_state)
		PA_CTRL_EN	<=8'd0;			//UL
end
///////////////TX_Gainblock_EN/////////////
always_ff @ (posedge clk) begin
	if(reset)
		TX_Gainblock_EN	<= 1'b0;
	else if(DL_state)				//DL
		TX_Gainblock_EN <= 1'b0;
	else if(GP1_state && count_GP1 > configure_TX_Gainblock_EN_GP1_DLtoUL)//DLtoUL	
		TX_Gainblock_EN	<= 1'b1;			//245
	else if(GP2_state && count_GP2 > configure_TX_Gainblock_EN_GP2_ULtoDL)//ULtoDL
		TX_Gainblock_EN	<= 1'b0;			//25600-737 = 24863
	else if(UL_state)
		TX_Gainblock_EN	<= 1'b1;	//UL
end
///////////////DAC_RF_output/////////////
always_ff @ (posedge clk) begin
	if(reset)
		DAC_RF_output <= 1'b1;
	else if(count_DLGP1_ULGP2 < 32'd1825783) //DLtoUL 
		DAC_RF_output <= 1'b1;
	else if(count_DLGP1_ULGP2 == 32'd2457599)//ULtoDL
		DAC_RF_output <= 1'b1;
	else
		DAC_RF_output <= 1'b0;				//UL
end
//////////////SW_RXFB_VCTL	   	///////////////////
//////////////SW_RXFB_VCTL_N	///////////////////
//////////////SW_PA_RXFB_VCTL 	///////////////////
always_ff @ (posedge clk) begin
	if(reset) begin
		SW_RXFB_VCTL		<= 1'b0;
	end
	else if(DL_state)begin				//DL
		SW_RXFB_VCTL		<= 1'b0;
	end
	else if (GP1_state && count_GP1 > configure_SW_RXFB_VCTL_GP1_DLtoUL) begin//DLtoUL
		SW_RXFB_VCTL		<= 1'b1;				//44548-491 = 44057
											//2431999+245-2 = 2432242
	end	
	else if (GP2_state && count_GP2 > configure_SW_RXFB_VCTL_GP2_ULtoDL)begin//ULtoDL
		SW_RXFB_VCTL		<= 1'b0;				//245
											//1870331-491 = 1869840
	end
	else if(UL_state) begin				
		SW_RXFB_VCTL		<= 1'b1;	//UL	
	end
end
always_ff @ (posedge clk) begin
	if(reset)
		SW_RXFB_VCTL_N		<= 1'b1;
	else if(DL_state)					//DL	
		SW_RXFB_VCTL_N		<= 1'b1;
	else if (GP1_state && count_GP1 > configure_SW_RXFB_VCTL_N_GP1_DLtoUL)//DLtoUL
		SW_RXFB_VCTL_N		<= 1'b0;		
	else if (GP2_state && count_GP2 > configure_SW_RXFB_VCTL_N_GP2_ULtoDL)//ULtoDL
		SW_RXFB_VCTL_N		<= 1'b1;								
	else if(UL_state) 				
        SW_RXFB_VCTL_N		<= 1'b0;	//UL
end
always_ff @ (posedge clk) begin
	if(reset)
		SW_PA_RXFB_VCTL		<= 2'b11;
	else if(DL_state) 					//DL	
		SW_PA_RXFB_VCTL		<= 2'b11;
	else if (GP1_state && count_GP1 > configure_SW_PA_RXFB_VCTL_GP1_DLtoUL)//DLtoUL				
		SW_PA_RXFB_VCTL		<= 2'b0;
	else if (GP2_state && count_GP2 > configure_SW_PA_RXFB_VCTL_GP2_ULtoDL)//ULtoDL				
		SW_PA_RXFB_VCTL		<= 2'b11;
	else if(UL_state)				
		SW_PA_RXFB_VCTL		<= 2'b0;	//UL
end	
///////////////SW_RXFB_DV_EN/////////////
always_ff @ (posedge clk) begin
	if(reset)
		SW_RXFB_DV_EN	<= 8'hff;
	else begin				//DL
		case(ant_sel) 
				3'd0:SW_RXFB_DV_EN	<= 8'b1111_1110;
				3'd1:SW_RXFB_DV_EN	<= 8'b1111_1101;
				3'd2:SW_RXFB_DV_EN	<= 8'b1111_1011;
				3'd3:SW_RXFB_DV_EN	<= 8'b1111_0111;
				3'd4:SW_RXFB_DV_EN	<= 8'b1110_1111;
				3'd5:SW_RXFB_DV_EN	<= 8'b1101_1111;
				3'd6:SW_RXFB_DV_EN	<= 8'b1011_1111;
				3'd7:SW_RXFB_DV_EN	<= 8'b0111_1111;
				default: SW_RXFB_DV_EN	<= 8'hff;
		endcase		
	end
end
///////////////RX_Gainblock_EN/////////////
///////////////PA_LNA_EN/////////////
always_ff @ (posedge clk) begin
	if(reset)
		RX_Gainblock_EN	<= 1'b1;
	else if(DL_state) begin		//DL
		RX_Gainblock_EN	<= 1'b1;
	end
	else if(GP1_state && count_GP1 > configure_RX_Gainblock_EN_GP1_DLtoUL) begin//DLtoUL
		 RX_Gainblock_EN <= 1'b0;			//44548-491 = 44057
											//2431999+245-2 = 2432242
	end
	else if(GP2_state && count_GP2 > configure_RX_Gainblock_EN_GP2_ULtoDL) begin//ULtoDL
		RX_Gainblock_EN	<= 1'b1;			//245
											//1870331-737 = 1869594
	end
	else if(UL_state) begin
		RX_Gainblock_EN  <= 1'b0;			//DL
		
	end
end

always_ff @ (posedge clk) begin
	if(reset)
		Temp_PA_LNA_EN		<= 2'b11;
	else if(DL_state)				//DL
		Temp_PA_LNA_EN		<= 2'b11;
	else if(GP1_state && count_GP1 > configure_PA_LNA_EN_GP1_DLtoUL)//DLtoUL		
		Temp_PA_LNA_EN		 <= 2'd0;
	else if(GP2_state && count_GP2 > configure_PA_LNA_EN_GP2_ULtoDL)//ULtoDL			
		Temp_PA_LNA_EN		<= 2'b11;                     
	else if(UL_state)									
		Temp_PA_LNA_EN		 <= 2'd0;	//UL
end

///////////////SW_PA_LNA_VCTL/////////////
always_ff @ (posedge clk) begin				
	if(reset)
		TEM_SW_PA_LNA_VCTL 	<= 2'b11;
	else if (DL_state)			//DL
		TEM_SW_PA_LNA_VCTL	<= 2'b11;
	else if (GP1_state && count_GP1 > configure_SW_PA_LNA_VCTL_GP1_DLtoUL)//DLtoUL  	 	
		TEM_SW_PA_LNA_VCTL 	<= 2'd0;			//44548-491 = 44057	//2431999+245-2 = 2432242
	else if (GP2_state && count_GP2 > configure_SW_PA_LNA_VCTL_GP2_ULtoDL)//ULtoDL		
		TEM_SW_PA_LNA_VCTL 	<= 2'b11;			//245				//1870331-491 = 1869840
	else if(UL_state)
		TEM_SW_PA_LNA_VCTL 	<= 2'd0;		//UL	
end

assign  SW_PA_LNA_VCTL = IFP_test_ctrl.pa_indicate[0] ? ~TEM_SW_PA_LNA_VCTL : TEM_SW_PA_LNA_VCTL;//data_sel<=0 vernon pa , data_sel<=1 mintaka pa
assign	PA_LNA_EN = IFP_test_ctrl.pa_indicate[0] ? ~Temp_PA_LNA_EN : Temp_PA_LNA_EN;

///////////////PrDrvEN_X/////////////
always_ff @ (posedge clk) begin
	if(reset)
		PrDrvEN_X <=4'b1111;
	else if(DL_state)				//DL
		PrDrvEN_X <= 4'b1111;
	else if(GP1_state && count_GP1 > configure_PrDrvEN_X_GP1_DLtoUL)//DLtoUL  
		PrDrvEN_X <= 4'd0;					//561668-3934=557734
	else if(GP2_state && count_GP2 > configure_PrDrvEN_X_GP2_ULtoDL)//ULtoDL		
		PrDrvEN_X <= 4'b1111;		 			//1825784+3934=1829718 
	else if(UL_state)
		PrDrvEN_X <= 4'd0;			//UL
end

endmodule