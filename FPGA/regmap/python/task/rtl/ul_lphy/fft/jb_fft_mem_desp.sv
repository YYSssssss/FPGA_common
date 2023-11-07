`timescale 1ns / 1ps

module jb_fft_mem_desp
 (
    input                       clk              ,
	input                       reset            ,
	input                       car_en           ,
	input                       frm_mrkr         ,
	input                       sym_mrkr         ,
	input                       sym_mrkr_4x      ,
	input [3:0]                 sym_cnt          ,
	input [2:0]                 sym_cnt_4x       ,
	
	jb_axi4_stream_if.slave     IFP_fft_mem_in   ,
											     
	output logic[31:0]          fft_data_in      ,
  	output logic                fft_start_in     ,
	output logic                frm_mrkr_mem_out
	
    );

localparam first_cp_size = 352;
localparam cp_size = 288;
localparam first_symbol_length= 352+4096 ;
localparam symbol_length= 288+4096 ;

jb_axi4_stream_if  #(.DATA_WIDTH(32), .USER_SB_WIDTH(2))  IFP_fft_mem_in_d();
jb_axi4_stream_if  #(.DATA_WIDTH(32), .USER_SB_WIDTH(2))  IFP_fft_mem_in_2d();

logic         sym_mrkr_d      ;
logic [3:0]   sym_cnt_d       ;	
logic [12:0]  sym_chip_cnt    ;
logic         ping_pang_ind   ;
logic         ping_pang_ind_d ;	
logic         cp_valid        ;

logic [11:0]  write_ping_addr;
logic [11:0]  write_pang_addr;

logic [63:0]  write_mem_data ;

logic [11:0]  write_ping_addr_d;
logic [11:0]  write_pang_addr_d;

logic         write_ping_en[1:0] ;
logic         write_pang_en[1:0] ;

logic [7:0]   write_ping_byte[1:0] ;
logic [7:0]   write_pang_byte[1:0] ;

logic         frm_mrkr_dly_en    ;
logic [14:0]  frm_mrkr_dly_cnt   ;
logic         frm_mrkr_dly       ;

logic [2:0]   sym_cnt_4x_rddly   ;
logic [3:0]   sym_cnt_rddly      ;
logic         sym_mrkr_4x_rddly  ;
logic         sym_mrkr_rddly     ;
logic         frm_mrkr_rddly     ;

logic [2:0]   sym_cnt_4x_rddly_1d ;
logic [2:0]   sym_cnt_4x_rddly_2d ;
logic [2:0]   sym_cnt_4x_rddly_3d ;
logic [2:0]   sym_cnt_4x_rddly_4d ; 

logic         rd_ping_pang_ind   ;

logic [11:0]  read_ping_addr[1:0] ;
logic [11:0]  read_pang_addr[1:0] ;

logic [63:0]  read_ping_data[1:0] ;
logic [63:0]  read_pang_data[1:0] ;

always @(posedge clk) begin 
        sym_cnt_d <= sym_cnt;     
 end
 
always @(posedge clk) begin 
        sym_mrkr_d <= sym_mrkr;     
 end

always_ff @(posedge clk) begin
    IFP_fft_mem_in_d.tdata   <= IFP_fft_mem_in.tdata ;
    IFP_fft_mem_in_d.tvalid  <= IFP_fft_mem_in.tvalid;
    IFP_fft_mem_in_d.tuser   <= IFP_fft_mem_in.tuser ;
    IFP_fft_mem_in_d.tkeep   <= IFP_fft_mem_in.tkeep ;
    IFP_fft_mem_in_d.tlast   <= IFP_fft_mem_in.tlast ;
    
	IFP_fft_mem_in_2d.tdata   <= IFP_fft_mem_in_d.tdata ;
    IFP_fft_mem_in_2d.tvalid  <= IFP_fft_mem_in_d.tvalid;
    IFP_fft_mem_in_2d.tuser   <= IFP_fft_mem_in_d.tuser ;
    IFP_fft_mem_in_2d.tkeep   <= IFP_fft_mem_in_d.tkeep ;
    IFP_fft_mem_in_2d.tlast   <= IFP_fft_mem_in_d.tlast ;
end

always_ff @(posedge clk) begin
          case(IFP_fft_mem_in_2d.tuser)
            2'b00,
			2'b10:
	            write_mem_data <= {32'b0,IFP_fft_mem_in_2d.tdata}  ;
	        2'b01,
			2'b11:
	            write_mem_data <= {IFP_fft_mem_in_2d.tdata,32'b0}  ;
	        default:
			    write_mem_data <= 64'd0 ;
          endcase
end


always @(posedge clk) begin 
	    if(sym_mrkr==1)
		   sym_chip_cnt <= 0 ;
		else if((IFP_fft_mem_in_d.tuser==3)&&(IFP_fft_mem_in_d.tvalid==1))
		   sym_chip_cnt <= sym_chip_cnt + 1 ;
		else 
		   sym_chip_cnt <= sym_chip_cnt ;	
 end

always @(posedge clk) begin 	   
		if(sym_cnt_d==0)
		   begin
		      if((0<=sym_chip_cnt)&&(sym_chip_cnt<first_cp_size))
                    cp_valid <= 1 ;
		      else 
			        cp_valid <= 0 ;
		   end		
		else  
           begin
		      if((0<=sym_chip_cnt)&&(sym_chip_cnt<cp_size))
                    cp_valid <= 1 ;
		      else 
			        cp_valid <= 0 ;
		   end
end

always @(posedge clk) begin 	   
		if(frm_mrkr==1)
		       ping_pang_ind <= 1 ;
	    else if(sym_mrkr==1)
		       ping_pang_ind <= ~ping_pang_ind ;
end   
                 
//// sync to cp_valid
always @(posedge clk) begin 	   
		       ping_pang_ind_d <= ping_pang_ind ;
end       

///////////////write ram 
always @(posedge clk) begin 	   
		if(sym_mrkr_d==1)
		       write_ping_addr <= 0 ;
	    else if((ping_pang_ind_d==1)&&(cp_valid==0)&&(IFP_fft_mem_in_2d.tuser==3))
		       write_ping_addr <= write_ping_addr + 1  ;
		else
               write_ping_addr <= write_ping_addr ;    					   
end  

always @(posedge clk) begin 	   
		if(sym_mrkr_d==1)
		       write_pang_addr <= 0 ;
	    else if((ping_pang_ind_d==0)&&(cp_valid==0)&&(IFP_fft_mem_in_2d.tuser==3))
		       write_pang_addr <= write_pang_addr + 1  ;
		else
               write_pang_addr <= write_pang_addr ;    					   
end  


always @(posedge clk) begin 
               write_ping_addr_d <= write_ping_addr ;	   
			   write_pang_addr_d <= write_pang_addr ;		   
end


always @(posedge clk) begin 	   
		  case ({ping_pang_ind_d,cp_valid,IFP_fft_mem_in_2d.tuser})
		    4'b1000,
			4'b1001:
			    begin  
				  write_ping_en[0]<= 1 ;
		          write_ping_en[1]<= 0 ;
		          write_pang_en[0]<= 0 ;
		          write_pang_en[1]<= 0 ;
		        end
			4'b1010,
			4'b1011:
			    begin  
				  write_ping_en[0]<= 0 ;
		          write_ping_en[1]<= 1 ;
		          write_pang_en[0]<= 0 ;
		          write_pang_en[1]<= 0 ;
		        end	
			4'b0000,
			4'b0001:
			    begin  
				  write_ping_en[0]<= 0 ;
		          write_ping_en[1]<= 0 ;
		          write_pang_en[0]<= 1 ;
		          write_pang_en[1]<= 0 ;
		        end		
			4'b0010,
			4'b0011:
			    begin  
				  write_ping_en[0]<= 0 ;
		          write_ping_en[1]<= 0 ;
		          write_pang_en[0]<= 0 ;
		          write_pang_en[1]<= 1 ;
		        end		
			default:
                begin  
				  write_ping_en[0]<= 0 ;
		          write_ping_en[1]<= 0 ;
		          write_pang_en[0]<= 0 ;
		          write_pang_en[1]<= 0 ;
		        end				
		  endcase
end  
			
				
always @(posedge clk) begin 	   
		  case ({ping_pang_ind_d,cp_valid,IFP_fft_mem_in_2d.tuser})
		    4'b1000:
			    begin  
				  write_ping_byte[0]<= 8'b0000_1111 ;
		          write_ping_byte[1]<= 0 ;
		          write_pang_byte[0]<= 0 ;
		          write_pang_byte[1]<= 0 ;
		        end
			4'b1001:
			    begin  
				  write_ping_byte[0]<= 8'b1111_0000 ;
		          write_ping_byte[1]<= 0 ;
		          write_pang_byte[0]<= 0 ;
		          write_pang_byte[1]<= 0 ;
		        end
			4'b1010:
			    begin  
				  write_ping_byte[0]<= 0 ;
		          write_ping_byte[1]<= 8'b0000_1111 ;
		          write_pang_byte[0]<= 0 ;
		          write_pang_byte[1]<= 0 ;
		        end
			4'b1011:
			    begin  
				  write_ping_byte[0]<= 0 ;
		          write_ping_byte[1]<= 8'b1111_0000 ;
		          write_pang_byte[0]<= 0 ;
		          write_pang_byte[1]<= 0 ;
		        end	
			4'b0000:
			    begin  
				  write_ping_byte[0]<= 0 ;
		          write_ping_byte[1]<= 0 ;
		          write_pang_byte[0]<= 8'b0000_1111 ;
		          write_pang_byte[1]<= 0 ;
		        end
			4'b0001:
			    begin  
				  write_ping_byte[0]<= 0 ;
		          write_ping_byte[1]<= 0 ;
		          write_pang_byte[0]<= 8'b1111_0000 ;
		          write_pang_byte[1]<= 0 ;
		        end
			4'b0010:
			    begin  
				  write_ping_byte[0]<= 0 ;
		          write_ping_byte[1]<= 0 ;
		          write_pang_byte[0]<= 0 ;
		          write_pang_byte[1]<= 8'b0000_1111 ;
		        end
			4'b0011:
			    begin  
				  write_ping_byte[0]<= 0 ;
		          write_ping_byte[1]<= 0 ;
		          write_pang_byte[0]<= 0 ;
		          write_pang_byte[1]<= 8'b1111_0000 ;
		        end	
			
			default:
                begin  
				  write_ping_byte[0]<= 0 ;
		          write_ping_byte[1]<= 0 ;
		          write_pang_byte[0]<= 0 ;
		          write_pang_byte[1]<= 0 ;
		        end				
		  endcase
end  

///////////read mem
always @(posedge clk) begin 
        if(frm_mrkr)
		    frm_mrkr_dly_en <=1 ;
end

always @(posedge clk) begin 
        if(frm_mrkr)
               frm_mrkr_dly_cnt <= 0;
		else if(frm_mrkr_dly_cnt==15'd17794)
		       frm_mrkr_dly_cnt <= 15'd17794;
		else if(frm_mrkr_dly_en==1)
		       frm_mrkr_dly_cnt <= frm_mrkr_dly_cnt + 15'd1;
end		

always @(posedge clk) begin 
       if(frm_mrkr_dly_cnt==15'd17793)
               frm_mrkr_dly <= 1'b1 ;
	   else 
          	   frm_mrkr_dly <= 1'b0 ;
end

jb_marker_generation_nr_ul_tc #(
    .CLOCK_PERIOD (2.03450521)           //491.52 => 2.03450521  122.88 => 8.13802083  156.25 => 6.4 368.68Mhz => 2.7123793 245.76 => 4.06901042
) jb_marker_generation_nr_ul_tc_fftmem_inst(
    .clk(clk),
    .reset(reset),
    .car_en(car_en),
    .frm_mrkr(frm_mrkr_dly),
    .extended_cp(1'b0),    
    
   // real time indicators
    .frm_mrkr_out(frm_mrkr_rddly),      
    .frm_mrkr_sample_cnt(),
	.sub_frame_mrkr(),  
    .sub_frame_sample_cnt(),
	.sub_frame_cnt(),
	.slot_mrkr (),           
    .slot_mrkr_sample_cnt(),
	.slot_cnt(),                      
	.sym_mrkr(sym_mrkr_rddly),              
    .sym_mrkr_pre(),                  
    .sym_mrkr_sample_cnt(),
	.sym_cnt(sym_cnt_rddly),                
    .cp_mrkr(),                       
    
   // 4x indicators
    .sym_mrkr_4x(sym_mrkr_4x_rddly),        
    .sym_cnt_4x (sym_cnt_4x_rddly )           
);     
	
always @(posedge clk) begin 	   
		if(frm_mrkr_rddly==1)
		       rd_ping_pang_ind <= 1 ;
	    else if(sym_mrkr_rddly==1)
		       rd_ping_pang_ind <= ~rd_ping_pang_ind ;
end   

always @(posedge clk) begin 
        if(sym_mrkr_rddly==1)
            read_ping_addr[0] <= 0;
		else if(sym_mrkr_4x_rddly==1)
		    read_ping_addr[0] <= 0;
		else if(read_ping_addr[0] == 12'd4095)
		    read_ping_addr[0] <= 12'd4095;
		else if((sym_cnt_4x_rddly[2:1]==2'b00)&&(rd_ping_pang_ind==1))
            read_ping_addr[0] <= read_ping_addr[0] + 1;
end

always @(posedge clk) begin 
        if(sym_mrkr_rddly==1)
            read_ping_addr[1] <= 0;
		else if(sym_mrkr_4x_rddly==1)
		    read_ping_addr[1] <= 0;
		else if(read_ping_addr[1] == 12'd4095)
		    read_ping_addr[1] <= 12'd4095;
		else if((sym_cnt_4x_rddly[2:1]==2'b01)&&(rd_ping_pang_ind==1))
            read_ping_addr[1] <= read_ping_addr[1] + 1;
end

always @(posedge clk) begin 
        if(sym_mrkr_rddly==1)
            read_pang_addr[0] <= 0;
		else if(sym_mrkr_4x_rddly==1)
		    read_pang_addr[0] <= 0;
		else if(read_pang_addr[0] == 12'd4095)
		    read_pang_addr[0] <= 12'd4095;
		else if((sym_cnt_4x_rddly[2:1]==2'b00)&&(rd_ping_pang_ind==0))
            read_pang_addr[0] <= read_pang_addr[0] + 1;
end

always @(posedge clk) begin 
        if(sym_mrkr_rddly==1)
            read_pang_addr[1] <= 0;
		else if(sym_mrkr_4x_rddly==1)
		    read_pang_addr[1] <= 0;
		else if(read_pang_addr[1] == 12'd4095)
		    read_pang_addr[1] <= 12'd4095;
		else if((sym_cnt_4x_rddly[2:1]==2'b01)&&(rd_ping_pang_ind==0))
            read_pang_addr[1] <= read_pang_addr[1] + 1;
end


always @(posedge clk) begin 
            sym_cnt_4x_rddly_1d <= sym_cnt_4x_rddly    ; 
            sym_cnt_4x_rddly_2d <= sym_cnt_4x_rddly_1d ; 
            sym_cnt_4x_rddly_3d <= sym_cnt_4x_rddly_2d ;
            sym_cnt_4x_rddly_4d <= sym_cnt_4x_rddly_3d ;
end

always @(posedge clk) begin 
        case({rd_ping_pang_ind,sym_cnt_4x_rddly_4d})
             4'b1_000:
			   fft_data_in <= read_ping_data[0][31:0]  ;
			 4'b1_001:
			   fft_data_in <= read_ping_data[0][63:32] ;  
			 4'b1_010:
			   fft_data_in <= read_ping_data[1][31:0]  ;
			 4'b1_011:
			   fft_data_in <= read_ping_data[1][63:32] ;    
			   
			 4'b0_000:
			   fft_data_in <= read_pang_data[0][31:0]  ;
			 4'b0_001:
			   fft_data_in <= read_pang_data[0][63:32] ;  
			 4'b0_010:
			   fft_data_in <= read_pang_data[1][31:0]  ;
			 4'b0_011:
			   fft_data_in <= read_pang_data[1][63:32] ;    
		     default :
			   fft_data_in <= 0 ;   
        endcase
end
	
always @(posedge clk) begin 	
	           fft_start_in <= sym_mrkr_4x_rddly    ;         
end	

always @(posedge clk) begin
              frm_mrkr_mem_out <= frm_mrkr_rddly ;
end

genvar  i;
generate
      for (i = 0; i < 2; i = i + 1) begin : fft_mem_desp

///////////ping_ram
 xpm_memory_sdpram #(
      .ADDR_WIDTH_A(12),               // DECIMAL
      .ADDR_WIDTH_B(12),               // DECIMAL
      .AUTO_SLEEP_TIME(0),            // DECIMAL
      .BYTE_WRITE_WIDTH_A(8),        // DECIMAL
      .CASCADE_HEIGHT(0),             // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      .ECC_MODE("no_ecc"),            // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_PRIMITIVE("ultra"),      // String
      .MEMORY_SIZE(4096*64),           // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_B(64),         // DECIMAL
      .READ_LATENCY_B(3),             // DECIMAL
      .READ_RESET_VALUE_B("0"),       // String
      .RST_MODE_A("SYNC"),            // String
      .RST_MODE_B("SYNC"),            // String
      .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(1),               // DECIMAL
      .WAKEUP_TIME("disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(64),        // DECIMAL
      .WRITE_MODE_B("write_first")      // String
   )
   xpm_memory_sdpram_ping_inst (
      .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port B.

      .doutb(read_ping_data[i]),  // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port B.

      .addra(write_ping_addr_d),   // ADDR_WIDTH_A-bit input: Address for port A write operations.
      .addrb(read_ping_addr[i]),    // ADDR_WIDTH_B-bit input: Address for port B read operations.
      .clka(clk),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                       // parameter CLOCKING_MODE is "common_clock".

      .clkb(clk),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                       // "independent_clock". Unused when parameter CLOCKING_MODE is
                                       // "common_clock".

      .dina(write_mem_data),           // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(write_ping_en[i]),          // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when write operations are initiated. Pipelined internally.

      .enb(1'b1),                         // 1-bit input: Memory enable signal for port B. Must be high on clock
                                       // cycles when read operations are initiated. Pipelined internally.

      .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regceb(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rstb(reset),                     // 1-bit input: Reset signal for the final port B output register stage.
                                       // Synchronously resets output port doutb to the value specified by
                                       // parameter READ_RESET_VALUE_B.

      .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(write_ping_byte[i])         // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                       // for port A input data port dina. 1 bit wide when word-wide writes are
                                       // used. In byte-wide write configurations, each bit controls the
                                       // writing one byte of dina to address addra. For example, to
                                       // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                       // is 32, wea would be 4'b0010.

   );


///////////pang_ram
 xpm_memory_sdpram #(
      .ADDR_WIDTH_A(12),               // DECIMAL
      .ADDR_WIDTH_B(12),               // DECIMAL
      .AUTO_SLEEP_TIME(0),            // DECIMAL
      .BYTE_WRITE_WIDTH_A(8),        // DECIMAL
      .CASCADE_HEIGHT(0),             // DECIMAL
      .CLOCKING_MODE("common_clock"), // String
      .ECC_MODE("no_ecc"),            // String
      .MEMORY_INIT_FILE("none"),      // String
      .MEMORY_INIT_PARAM("0"),        // String
      .MEMORY_OPTIMIZATION("true"),   // String
      .MEMORY_PRIMITIVE("ultra"),      // String
      .MEMORY_SIZE(4096*64),           // DECIMAL
      .MESSAGE_CONTROL(0),            // DECIMAL
      .READ_DATA_WIDTH_B(64),         // DECIMAL
      .READ_LATENCY_B(3),             // DECIMAL
      .READ_RESET_VALUE_B("0"),       // String
      .RST_MODE_A("SYNC"),            // String
      .RST_MODE_B("SYNC"),            // String
      .SIM_ASSERT_CHK(0),             // DECIMAL; 0=disable simulation messages, 1=enable simulation messages
      .USE_EMBEDDED_CONSTRAINT(0),    // DECIMAL
      .USE_MEM_INIT(1),               // DECIMAL
      .WAKEUP_TIME("disable_sleep"),  // String
      .WRITE_DATA_WIDTH_A(64),        // DECIMAL
      .WRITE_MODE_B("write_first")      // String
   )
   xpm_memory_sdpram_pang_inst (
      .dbiterrb(),             // 1-bit output: Status signal to indicate double bit error occurrence
                                       // on the data output of port B.

      .doutb(read_pang_data[i]),  // READ_DATA_WIDTH_B-bit output: Data output for port B read operations.
      .sbiterrb(),             // 1-bit output: Status signal to indicate single bit error occurrence
                                       // on the data output of port B.

      .addra(write_pang_addr_d),  // ADDR_WIDTH_A-bit input: Address for port A write operations.
      .addrb(read_pang_addr[i]),    // ADDR_WIDTH_B-bit input: Address for port B read operations.
      .clka(clk),                     // 1-bit input: Clock signal for port A. Also clocks port B when
                                       // parameter CLOCKING_MODE is "common_clock".

      .clkb(clk),                     // 1-bit input: Clock signal for port B when parameter CLOCKING_MODE is
                                       // "independent_clock". Unused when parameter CLOCKING_MODE is
                                       // "common_clock".

      .dina(write_mem_data),          // WRITE_DATA_WIDTH_A-bit input: Data input for port A write operations.
      .ena(write_pang_en[i]),         // 1-bit input: Memory enable signal for port A. Must be high on clock
                                       // cycles when write operations are initiated. Pipelined internally.

      .enb(1'b1),           // 1-bit input: Memory enable signal for port B. Must be high on clock
                                       // cycles when read operations are initiated. Pipelined internally.

      .injectdbiterra(1'b0), // 1-bit input: Controls double bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .injectsbiterra(1'b0), // 1-bit input: Controls single bit error injection on input data when
                                       // ECC enabled (Error injection capability is not available in
                                       // "decode_only" mode).

      .regceb(1'b1),                 // 1-bit input: Clock Enable for the last register stage on the output
                                       // data path.

      .rstb(reset),                     // 1-bit input: Reset signal for the final port B output register stage.
                                       // Synchronously resets output port doutb to the value specified by
                                       // parameter READ_RESET_VALUE_B.

      .sleep(1'b0),                   // 1-bit input: sleep signal to enable the dynamic power saving feature.
      .wea(write_pang_byte[i])         // WRITE_DATA_WIDTH_A/BYTE_WRITE_WIDTH_A-bit input: Write enable vector
                                       // for port A input data port dina. 1 bit wide when word-wide writes are
                                       // used. In byte-wide write configurations, each bit controls the
                                       // writing one byte of dina to address addra. For example, to
                                       // synchronously write only bits [15-8] of dina when WRITE_DATA_WIDTH_A
                                       // is 32, wea would be 4'b0010.

   );

end : fft_mem_desp
endgenerate


endmodule
