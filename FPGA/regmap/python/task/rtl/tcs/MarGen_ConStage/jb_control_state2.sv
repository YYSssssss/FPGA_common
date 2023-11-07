module jb_control_state2(
	input					clk									,
	input					reset								,
	input					pulse_10ms							,//frm_mrkr_out

    jb_test_ctrl_if.test_dbg    IFP_test_ctrl                   ,//0:100%DL	;	1:70%DL	;	2:50%DL	;	3:100%UL
	
	output	logic			DL_state                            ,
	output	logic			GP1_state                           ,
	output	logic			UL_state							,
	output  logic			GP2_state                           ,
	output	logic			Error_10ms	
);

logic [31:0] 	count_10ms;
logic [4:0] 	current_state;
logic [4:0] 	next_state	;

parameter       T_GP = 17'd70148;
logic [16:0] 	T_GP1;		//T_GP1 = T_GP - TA_offset	
logic [16:0]	T_GP2;		//according to 3GPP N_TA_offset	25600 or 39936
logic [31:0]	temp_TGP1;
logic [31:0]	temp_TGP2;
logic [31:0]	temp_GP_7030_DLtoUL;
logic [31:0]	temp_UL_7030;
logic			BackToIdle;
logic [31:0]	debug_rw_0_1;
logic [31:0]	debug_rw_0_2;
parameter       IDLE 		    = 5'd0;
parameter       DL_100	 		= 5'd1;
parameter       DL_7030	 		= 5'd2;
parameter       GP_7030_DLtoUL	= 5'd3;
parameter       UL_7030	 		= 5'd4;
parameter       GP_7030_ULtoDL	= 5'd5;
parameter       FAULT		 	= 5'd6;

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
	if(reset)begin
		T_GP1 <= 32'd0;
		temp_GP_7030_DLtoUL <= 32'd0;
		temp_UL_7030		<= 32'd0;
	end
	else begin
		T_GP1 <= T_GP - T_GP2;
		temp_GP_7030_DLtoUL <= 32'd1825783 + T_GP1;
		temp_UL_7030		<=  32'd1825783 + T_GP1 + 32'd561668;
	end
end

always @ (posedge clk) begin
	if(reset)
		count_10ms <= 32'd0;
	else if(pulse_10ms)
		count_10ms <= 32'd0;
	else if(count_10ms == 32'd2457599)
		count_10ms <= 32'd0;
	else
		count_10ms <= count_10ms + 1'b1;
end

always @ (posedge clk) begin
	debug_rw_0_1 <= IFP_test_ctrl.debug_rw[0]; 
	debug_rw_0_2 <= debug_rw_0_1;
end

assign BackToIdle = (debug_rw_0_1 != debug_rw_0_2);


always @ (posedge clk) begin
	if(reset) 
		current_state <= IDLE;
	else if(BackToIdle == 1'b1)
		current_state <= IDLE;
	else 
		current_state <= next_state;	
end

always @ (*) begin
	if(reset) 
		next_state = IDLE;
	else begin
		case(current_state) 
			IDLE: begin
					if(pulse_10ms == 1'b1 && IFP_test_ctrl.debug_rw[0][0]=='d0)		next_state = DL_100;
					else if(pulse_10ms == 1'b1 && IFP_test_ctrl.debug_rw[0][0]=='d1) next_state= DL_7030;
					else next_state = IDLE;						
				end
			DL_100: begin
					if(pulse_10ms && count_10ms < 32'd2457599) next_state = FAULT;
					else if ( IFP_test_ctrl.debug_rw[0][0] == 'd1 ) next_state = IDLE;
					else next_state = DL_100;							
				end
			DL_7030: begin
					if(pulse_10ms && count_10ms < 32'd2457599) next_state = FAULT;
					else if(count_10ms == 32'd1825783) 	next_state = GP_7030_DLtoUL;
					else if(count_10ms < 32'd1825783)		next_state = DL_7030;
					else						next_state = DL_7030;
				end
			
			GP_7030_DLtoUL: begin
					if(pulse_10ms && count_10ms < 32'd2457599) next_state = FAULT;
					else if(count_10ms == temp_GP_7030_DLtoUL) 	next_state = UL_7030;
					else if(count_10ms < temp_GP_7030_DLtoUL)		next_state = GP_7030_DLtoUL;
					else						next_state = GP_7030_DLtoUL;
				end
				
			UL_7030: begin
					if(pulse_10ms && count_10ms < 32'd2457599) next_state = FAULT;
					else if(count_10ms == temp_UL_7030) 	next_state = GP_7030_ULtoDL;
					else if(count_10ms < temp_UL_7030) next_state = UL_7030;
					else						next_state = UL_7030;
				end
				
			GP_7030_ULtoDL: begin
					if(pulse_10ms && count_10ms < 32'd2457599) next_state = FAULT;
					else if(count_10ms == 32'd2457599)	next_state = DL_7030;
					else						next_state = GP_7030_ULtoDL;
			end
				
			FAULT: begin
					next_state = IDLE;
				end
			
			default: begin
					next_state = IDLE;
				end
		endcase
	end
end

always @ (posedge clk) begin
    if(reset)
		Error_10ms = 1'b0;
	else if(next_state == FAULT)
		Error_10ms <= 1'b1;
	else if(pulse_10ms)
		Error_10ms <= 1'b0;
	else
		;
end


always_ff @ (posedge clk) begin
	if(reset) begin
		DL_state <= 1'b0;
		GP1_state <= 1'b0;
		UL_state <= 1'b0;
		GP2_state<= 1'b0;
	end
	else begin
		case(next_state)
			DL_100:begin
				DL_state <= 1'b1;
			end
			DL_7030: begin
				GP2_state <= 1'b0;
				DL_state <= 1'b1;
			end
			GP_7030_DLtoUL: begin
				DL_state <= 1'b0;
				GP1_state <= 1'b1;
			end
			UL_7030: begin
				GP1_state <= 1'b0;
				UL_state <= 1'b1;
			end
			GP_7030_ULtoDL:begin
				UL_state <= 1'b0;
				GP2_state <= 1'b1;
			end
			default: begin
				DL_state <= 1'b0;
				GP1_state <= 1'b0;
				UL_state <= 1'b0;
				GP2_state <= 1'b0;
			end
		endcase
	end
end

endmodule