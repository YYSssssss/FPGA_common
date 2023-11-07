
module jb_sys_frm_gen_tcs (

    input 	                	ptp_clk					,
    input                       ptp_reset				,
    input                       one_pps					,
    input 	                	clk						,
    input 	                	reset					, 

    input  [31:0]               dl_frm_mrkr_cntr_ns		,
    input  [31:0]               ul_frm_mrkr_cntr_ns		,
    input  [31:0]               prach_frm_mrkr_cntr_ns	,

    input 	                	frm_mrkr_gen_trigger	,
    input                       frm_mrkr_gen_enable		,
    
    input  [31:0]  	        	systimer_ns				,
	
    output                      dl_frm_mrkr_10ms		,
	output                      dl_frm_mrke_10ms_one_clk,
    output                      ul_frm_mrkr_10ms		,
    output                      prach_frm_mrkr_10ms		,

	output		logic			syn_data_dl_ul_5ms		
);

   

   `include "jb_common.svh"
   localparam PTP_TO_INTERNAL_CLOCK_RATIO=5; //500/122.88 
   //localparam CYCLES_10MS = 1228800;
   localparam CYCLES_10MS = 4915200;
   localparam CYCLES_10MS_BW = 24;	
   

   logic [31:0] 		systimer_ns_d=0;
   logic                one_pps_d=0;
   
   logic                frm_mrkr_trigger_pulse;
   logic 				dl_frm_mrkr_10ms_ptpclk=0;
   logic 				ul_frm_mrkr_10ms_ptpclk=0;
   logic 				prach_frm_mrkr_10ms_ptpclk=0;
   logic 				dl_frm_mrkr_10ms_ptpclk_stretch;
   logic 				ul_frm_mrkr_10ms_ptpclk_stretch;
   logic 				prach_frm_mrkr_10ms_ptpclk_stretch;
   logic [31:0] 		mrkr_cnt;
   logic [2:0]          test_state;
   assign               test_state = stage;
   logic                tmp_dl_frm_mrkr_10ms;

   localparam    WAIT_FOR_1PPS_AFTER_TRIGGER_FOR_DL=0;
   
   typedef enum logic [2:0] {DL=0, UL=1, PRACH=2} stage_t;
   
   sys_frm_mrkr_gen_sm_t  frm_sm=SYSFRM_MRKR_GEN_IDLE;
   stage_t stage=DL;


  

   jb_edge_det #(
        .SYNC_EN            (1),
	.SYNC_STAGES        (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (1),
        .PULSE_POLARITY     (1),//pos
	.RETIME_OUTPUT      (1)
    ) u_frm_mrkr_trigger_gen (
        .clk                (ptp_clk),
        .mask               (1'b0),
        .din                (frm_mrkr_gen_trigger),
        .din_syncd          (),
        .dout               (frm_mrkr_trigger_pulse)
    );


   //to ease timing 
   always @(posedge ptp_clk) begin
      systimer_ns_d <= systimer_ns;
      one_pps_d <= one_pps;
   end

always @(posedge ptp_clk) begin
  //Remove reset since FPGA reset can take resources
  if (ptp_reset) begin
    frm_sm <= SYSFRM_MRKR_GEN_IDLE;		
    dl_frm_mrkr_10ms_ptpclk <= 1'b0;		
    ul_frm_mrkr_10ms_ptpclk <= 1'b0;		
    prach_frm_mrkr_10ms_ptpclk <= 1'b0;
    mrkr_cnt  <=0;
    stage <= DL;	 
  end
  else begin
    case (frm_sm)
    SYSFRM_MRKR_GEN_IDLE :  begin
      if (frm_mrkr_gen_enable & frm_mrkr_trigger_pulse) begin
	    stage    <= DL;
	    mrkr_cnt <= dl_frm_mrkr_cntr_ns;
	    frm_sm   <= SYSFRM_MRKR_SYSCNT_MATCH;
      end
      else begin		
	    //dl_frm_mrkr_10ms_ptpclk    <= 1'b0;		
	    ul_frm_mrkr_10ms_ptpclk    <= 1'b0;		
	    prach_frm_mrkr_10ms_ptpclk <= 1'b0;
	    frm_sm                     <= SYSFRM_MRKR_GEN_IDLE;
      end
    end // case: SYSFRM_MRKR_GEN_IDLE
    SYSFRM_MRKR_SYSCNT_MATCH: begin
        if (!frm_mrkr_gen_enable) begin		
	        dl_frm_mrkr_10ms_ptpclk    <= 1'b0;		
	        ul_frm_mrkr_10ms_ptpclk    <= 1'b0;		
	        prach_frm_mrkr_10ms_ptpclk <= 1'b0;
	        frm_sm                     <= SYSFRM_MRKR_GEN_IDLE;
        end
        else begin	      
            if (mrkr_cnt == systimer_ns_d) begin
	            if (stage==DL) begin
	               dl_frm_mrkr_10ms_ptpclk <= 1'b1;
	               ////////////////////////
	               // If DL, UL, PRACH are all 0 counts for debug, loopback
	               if (ul_frm_mrkr_cntr_ns == systimer_ns_d) begin
	                  ul_frm_mrkr_10ms_ptpclk <= 1'b1;
	                  if (prach_frm_mrkr_cntr_ns== systimer_ns_d) begin
	  	           prach_frm_mrkr_10ms_ptpclk <= 1'b1;
	  	           frm_sm <= SYSFRM_MRKR_WAIT_DIS;
	                  end
	                  else begin //DL=0, UL=0, PRACH!=0, prach frm mrkr is in same as UL or later not before UL
	  	           stage <= PRACH;
	  	           mrkr_cnt <= prach_frm_mrkr_cntr_ns;
	  	           frm_sm <= SYSFRM_MRKR_SYSCNT_MATCH;
	                  end
	               end // if (ul_frm_mrkr_cntr_ns==0)
	               else begin  // UL!=0, pps already arrived just mact the counter
	                  stage <= UL;
	                  mrkr_cnt <= ul_frm_mrkr_cntr_ns;
	                  frm_sm <= SYSFRM_MRKR_SYSCNT_MATCH;
	               end // else: !if(ul_frm_mrkr_cntr_ns==0)
	            end
	            else if (stage ==UL) begin //normal scenorio or 
	               ul_frm_mrkr_10ms_ptpclk <= 1'b1;
	               if (prach_frm_mrkr_cntr_ns== systimer_ns_d) begin
	                  prach_frm_mrkr_10ms_ptpclk <= 1'b1;
	                  frm_sm <= SYSFRM_MRKR_WAIT_DIS;
	               end
	               else begin //DL=0, UL=0, PRACH!=0, prach frm mrkr is in same as UL or later not before UL
	                  stage <= PRACH;
	                  mrkr_cnt <= prach_frm_mrkr_cntr_ns;
	                  frm_sm <= SYSFRM_MRKR_SYSCNT_MATCH;
	               end
	            end
	            else begin //stage ==PRACH
	               prach_frm_mrkr_10ms_ptpclk <= 1'b1;
	               frm_sm <= SYSFRM_MRKR_WAIT_DIS;
	            end
            end // if (mrkr_cnt == systimer_ns_d)
        end // else: !if(frm_mrkr_gen_enable)	      
    end // case: SYSFRM_MRKR_SYSCNT_MATCH
    SYSFRM_MRKR_WAIT_DIS :	begin
        if (frm_mrkr_gen_enable) begin	
            //dl_frm_mrkr_10ms_ptpclk    <= 1'b0;		
            //ul_frm_mrkr_10ms_ptpclk    <= 1'b0;		
            //prach_frm_mrkr_10ms_ptpclk <= 1'b0;
            if(input_change) begin
				frm_sm 					   <= SYSFRM_MRKR_GEN_IDLE;
				dl_frm_mrkr_10ms_ptpclk    <= 1'b0;
			end
       end  
    end
    default : begin	
        dl_frm_mrkr_10ms_ptpclk    <= 1'b0;		
        ul_frm_mrkr_10ms_ptpclk    <= 1'b0;		
        prach_frm_mrkr_10ms_ptpclk <= 1'b0;
        frm_sm                     <= SYSFRM_MRKR_GEN_IDLE;
    end
    endcase // case (frm_sm)
  end // else: !if(ptp_reset)
end // always @ (posedge ptp_clk)


    jb_sys_frm_sync #(
       .CYCLES_10MS(CYCLES_10MS),
       .CYCLES_10MS_BW(CYCLES_10MS_BW)
   ) u_dl_sys_frm_sync (
         .clk (clk),
	 .reset(reset),
	 .frm_mrkr_start(dl_frm_mrkr_10ms_ptpclk),
	 .frm_mrkr(tmp_dl_frm_mrkr_10ms)
		     
    );


   jb_edge_det #(
        .SYNC_EN            (1),
	.SYNC_STAGES            (2),
        .EDGES              (1),//pos
        .PULSE_WIDTH        (200),
        .PULSE_POLARITY     (1),//pos
	.RETIME_OUTPUT          (1)
    ) u_frm_mrkr_trigger_gen_out (
        .clk                (clk),
        .mask               (1'b0),
        .din                (tmp_dl_frm_mrkr_10ms),
        .din_syncd          (),
        .dout               (dl_frm_mrkr_10ms)
    );
	

    jb_sys_frm_sync #(
       .CYCLES_10MS(CYCLES_10MS),
       .CYCLES_10MS_BW(CYCLES_10MS_BW)
   ) u_ul_sys_frm_sync (
         .clk (clk),
	 .reset(reset),
	 .frm_mrkr_start(ul_frm_mrkr_10ms_ptpclk),
	 .frm_mrkr(ul_frm_mrkr_10ms)
		     
    );

     jb_sys_frm_sync #(
       .CYCLES_10MS(CYCLES_10MS),
       .CYCLES_10MS_BW(CYCLES_10MS_BW)
   ) u_prach_sys_frm_sync (
         .clk (clk),
	 .reset(reset),
	 .frm_mrkr_start(prach_frm_mrkr_10ms_ptpclk),
	 .frm_mrkr(prach_frm_mrkr_10ms)
		     
    );

////////////////////////////////////////add two signals////////////////////////////////////////
logic [31:0]	count_10ms = 32'd0;

logic			start = 0;

logic [31:0] data1; 
logic [31:0] data2;

logic input_change;

logic dl_frm_mrkr_10ms_ptpclk_1;

always @ (posedge ptp_clk) begin
	data1 <= dl_frm_mrkr_cntr_ns;
	data2 <= data1;
end
always @ (posedge ptp_clk) begin
	if(data1 != data2) begin
		input_change <= 1'b1;
	end
	else if(frm_mrkr_trigger_pulse) begin
		input_change <= 1'b0;
	end
end
///////////////////////////////////////////////////////////////////////
always @ (posedge clk) begin
	if(tmp_dl_frm_mrkr_10ms) begin
		count_10ms <= 32'd0;
	end
	else if(count_10ms == 32'd4915199)
		count_10ms <= 32'd0;
	else
		count_10ms <= count_10ms + 1'd1;
end

always @ (posedge clk) begin
	if(tmp_dl_frm_mrkr_10ms) begin
		start = 1;
	end
end
always @ (posedge clk) begin
	if(reset) begin
		syn_data_dl_ul_5ms <= 0;
	end
	if(start) begin
		if(count_10ms < 32'd1843199) begin
			syn_data_dl_ul_5ms <= 1;
		end
		else if(count_10ms < 32'd2457599) begin
			syn_data_dl_ul_5ms <= 0;
		end
		else if(count_10ms < 32'd4300799)begin
			syn_data_dl_ul_5ms <= 1;
		end
		else if(count_10ms < 32'd4915199)
			syn_data_dl_ul_5ms <= 0;
		else
			syn_data_dl_ul_5ms <= 1;;
	end
end


assign dl_frm_mrke_10ms_one_clk = tmp_dl_frm_mrkr_10ms;

   
endmodule

