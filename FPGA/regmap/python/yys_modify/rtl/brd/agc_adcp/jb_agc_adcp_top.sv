

`timescale 1ns / 1ps

module jb_agc_adcp_top  (
    input                       axi_clk,
    input                       axi_resetn,
    input           [7:0]       adc_over_range,
    input           [7:0]       adc_over_voltage,
    input           [7:0]       adcp_disable,

    input           [7:0] [6:0] ps_rxdsa,
    output  logic   [7:0] [6:0] pl_rxdsa ,
    output  logic   [6:0]       rx_dsa_d,
    output  logic   [8:1]       rx_dsa_le,
    input           [7:0]       ps_bypass_lna,
    output  logic   [7:0]       rx_lna_bypass
);

    logic   [6:0]       rx_dsa_d_agc [8:1];
    logic   [8:1]       rx_dsa_le_agc; 
    logic   [8:1]       service;
    logic   [8:1]       service_done;
    genvar i;
    
    
	logic [1:0] enable_count = 0;
	
	always_ff @(posedge axi_clk) begin
	   enable_count <= enable_count + 1'b1;
	end
	
	logic enable;
	
	assign enable = enable_count == 'd3;
   
    
 generate
        for (i=0; i<=7; i=i+1)
        begin : gen_adcp
            jb_agc_adcp u_agc_adcp (
                .axi_clk                (axi_clk),                  // i
                .clk_en                 (enable),                   // i
                .axi_reset              (~axi_resetn),              // i
                .adc_over_range         (adc_over_range[i]),        // i [7:0]
                .adc_over_voltage       (adc_over_voltage[i]),      // i [7:0]
                .adcp_disable           (adcp_disable[i]),          // i
                .ps_rxdsa               (ps_rxdsa[i]),              // i [6:0]
                .pl_rxdsa               (pl_rxdsa[i]),              // o [6:0]
                .rx_dsa_d               (rx_dsa_d_agc[i+1]),        // o [6:0]
                .rx_dsa_le              (rx_dsa_le_agc[i+1]),       // o [8:1]
		        .service		        (service[i+1]),		        // o
		        .service_done		    (service_done[i+1]),        // i
                .ps_bypass_lna          (ps_bypass_lna[i]),         // i
                .rx_lna_bypass          (rx_lna_bypass[i])          // o
            );
        end
    endgenerate
    

    // Round Robin State Machine
	parameter [3:0] IDLE	     = 0;
	parameter [3:0] SERVICE_DSA1 = 1;
	parameter [3:0] SERVICE_DSA2 = 2;
	parameter [3:0] SERVICE_DSA3 = 3;
    parameter [3:0] SERVICE_DSA4 = 4;
    parameter [3:0] SERVICE_DSA5 = 5;
	parameter [3:0] SERVICE_DSA6 = 6;
    parameter [3:0] SERVICE_DSA7 = 7;
    parameter [3:0] SERVICE_DSA8 = 8;
    logic [3:0] state = IDLE;
	logic [3:0] next_state = IDLE;
	

	always_ff @(posedge axi_clk) begin
        if (!axi_resetn) state <= IDLE;
		else if (enable) state <= next_state;
    end
    
    logic [8:1] service_dsa = 0;

	always @(*) begin
		case(state)
			IDLE: begin 
			          next_state = SERVICE_DSA1;
			       end                
            SERVICE_DSA1: if (service[1] && !service_done[1]) begin
                      next_state = SERVICE_DSA1;
                      end
                  else begin 
                      next_state = SERVICE_DSA2;
                      end
            SERVICE_DSA2: if (service[2] && !service_done[2]) begin
                      next_state = SERVICE_DSA2;
                      end
                  else begin
                      next_state = SERVICE_DSA3;
                      end
            SERVICE_DSA3: if (service[3] && !service_done[3]) begin
                      next_state = SERVICE_DSA3;
                      end
                  else begin 
                      next_state = SERVICE_DSA4;
                      end										  
            SERVICE_DSA4: if (service[4] && !service_done[4]) begin
                      next_state = SERVICE_DSA4;
                      end
                  else begin 
                      next_state = SERVICE_DSA5;
                      end
            SERVICE_DSA5: if (service[5] && !service_done[5]) begin
                      next_state = SERVICE_DSA5;
                      end
                  else begin 
                      next_state = SERVICE_DSA6;
                      end
            SERVICE_DSA6: if (service[6] && !service_done[6]) begin
                      next_state = SERVICE_DSA6;
                      end
                  else begin 
                      next_state = SERVICE_DSA7;
                      end
            SERVICE_DSA7: if (service[7] && !service_done[7]) begin
                      next_state = SERVICE_DSA7;
                      end
                  else begin 
                      next_state = SERVICE_DSA8;
                      end
            SERVICE_DSA8: if (service[8] && !service_done[8]) begin
                      next_state = SERVICE_DSA8;
                      end
                  else begin 
                      next_state = SERVICE_DSA1;
                      end
            default: begin 
                      next_state = IDLE;
                      end
        endcase 
    end
    
    always_ff @(posedge axi_clk) begin
        if (enable) begin
            if ((state == SERVICE_DSA1) && service[1] && !service_done[1]) service_dsa <= 8'b00000001;
            else if ((state == SERVICE_DSA2) && service[2] && !service_done[2]) service_dsa <= 8'b00000010;
            else if ((state == SERVICE_DSA3) && service[3] && !service_done[3]) service_dsa <= 8'b00000100;
            else if ((state == SERVICE_DSA4) && service[4] && !service_done[4]) service_dsa <= 8'b00001000;
            else if ((state == SERVICE_DSA5) && service[5] && !service_done[5]) service_dsa <= 8'b00010000;
            else if ((state == SERVICE_DSA6) && service[6] && !service_done[6]) service_dsa <= 8'b00100000;
            else if ((state == SERVICE_DSA7) && service[7] && !service_done[7]) service_dsa <= 8'b01000000;
            else if ((state == SERVICE_DSA8) && service[8] && !service_done[8]) service_dsa <= 8'b10000000;				
            else service_dsa <= 8'b00000000;
            end
    end
    
	// Service state machine
	// Need data 10 ns (1 clock) prior to latch enable
	// Data needs to stay 10 ns (1 clock after latch enable
	parameter [1:0] IDLE_SERVICE = 2'd0;
	parameter [1:0] SET_DATA     = 2'd1;
	parameter [1:0] SET_LE       = 2'd2;
	parameter [1:0] REMOVE_LE    = 2'd3;    
	logic [1:0] state_service = IDLE_SERVICE;
	logic [1:0] next_state_service = IDLE_SERVICE;
	

	always_ff @(posedge axi_clk) begin
        if (!axi_resetn) state_service <= IDLE_SERVICE;
		else if (enable) state_service <= next_state_service;
    end			
    
    always @(*) begin
		case(state_service)
			IDLE_SERVICE: next_state_service =  SET_DATA; // if (|service_dsa) next_state_service =  SET_DATA; //  not idle             
            SET_DATA:     if (|service_dsa) next_state_service =  SET_LE; else next_state_service = SET_DATA; // next_state_service = SET_LE;
            SET_LE:       next_state_service = REMOVE_LE;
            REMOVE_LE:    next_state_service = SET_DATA; // next_state_service = IDLE_SERVICE;
            default: next_state_service = IDLE_SERVICE;
        endcase 
    end
    

logic [8:1] rx_dsa_le_next;
logic [8:1] service_done_next;
logic [6:0] rx_dsa_d_next;
genvar j;
    
generate
        for (j=1; j<=8; j=j+1) begin
            assign rx_dsa_le_next[j] = service_dsa[j] & (state_service == SET_LE);
            assign service_done_next[j] = service_dsa[j] & (state_service == SET_LE);
        end
endgenerate 

always_comb begin
    if (service_dsa == 8'b00000001) rx_dsa_d_next <= rx_dsa_d_agc[1];
    else if (service_dsa == 8'b00000010) rx_dsa_d_next <= rx_dsa_d_agc[2];
    else if (service_dsa == 8'b00000100) rx_dsa_d_next <= rx_dsa_d_agc[3];
    else if (service_dsa == 8'b00001000) rx_dsa_d_next <= rx_dsa_d_agc[4];
	else if (service_dsa == 8'b00010000) rx_dsa_d_next <= rx_dsa_d_agc[5];
	else if (service_dsa == 8'b00100000) rx_dsa_d_next <= rx_dsa_d_agc[6];
	else if (service_dsa == 8'b01000000) rx_dsa_d_next <= rx_dsa_d_agc[7];
	else if (service_dsa == 8'b10000000) rx_dsa_d_next <= rx_dsa_d_agc[8];
    else rx_dsa_d_next <= 'd0;
end



logic [8:1] rx_dsa_le_ila;
logic [8:1] service_done_ila;
logic [6:0] rx_dsa_d_ila;

always_ff @(posedge axi_clk) begin
        if (enable) begin
            rx_dsa_le_ila <= rx_dsa_le_next;
            service_done_ila <= service_done_next;
            rx_dsa_d_ila <= rx_dsa_d_next;
        end
end 
/*

ila_ADCP ila_ADCP_inst (
	.clk(axi_clk), // input wire clk
	.probe0(enable), // input wire [0:0]  probe0  
	.probe1(service_done_ila), // input wire [3:0]  probe1 
	.probe2(rx_dsa_le_ila), // input wire [3:0]  probe2 
	.probe3(rx_dsa_d_ila) // input wire [6:0]  probe3
);
*/


always_ff @(posedge axi_clk) begin
        if (enable) begin
            rx_dsa_le <= rx_dsa_le_next;
            //rx_dsa_le <= {rx_dsa_le_next[3],rx_dsa_le_next[3],rx_dsa_le_next[3],rx_dsa_le_next[3]} ;
            service_done <= service_done_next;
            rx_dsa_d <= rx_dsa_d_next;
        end
end


/*vio_rxdsa vio_rxdsa_inst (
  .clk(axi_clk),            // input wire clk
  .probe_out0(rx_dsa_le),  // output wire [3 : 0] probe_out0
  .probe_out1(rx_dsa_d)  // output wire [6 : 0] probe_out1
);
*/
/*logic [5:0] mux_casestate;
    
assign mux_casestate = {service_dsa,state_service};    
    always_ff @(posedge axi_clk) begin
        if (enable) begin
            case (mux_casestate) 
                {4'b0001,SET_DATA} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[1];
                    service_done <= 4'b0000;
                    end
                {4'b0001,SET_LE} : begin
                    rx_dsa_le <= 4'b0001;
                    rx_dsa_d <= rx_dsa_d_agc[1];
                    service_done <= 4'b0001;                   
                    end
                {4'b0001,REMOVE_LE} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[1];
                    service_done <= 4'b0000;
                    end    
                {4'b0010,SET_DATA} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[2];
                    service_done <= 4'b0000;
                    end
                {4'b0010,SET_LE} : begin
                    rx_dsa_le <= 4'b0010;
                    rx_dsa_d <= rx_dsa_d_agc[2];
                    service_done <= 4'b0010;
                    end
                {4'b0010,REMOVE_LE} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[2];
                    service_done <= 4'b0000;
                    end 
                {4'b0100,SET_DATA} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[3];
                    service_done <= 4'b0000;
                    end
                {4'b0100,SET_LE} : begin
                    rx_dsa_le <= 4'b0100;
                    rx_dsa_d <= rx_dsa_d_agc[3];
                    service_done <= 4'b0100;
                    end
                {4'b0100,REMOVE_LE} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[3];
                    service_done <= 4'b0000;
                    end    
                {4'b1000,SET_DATA} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[4];
                    service_done <= 4'b0000;
                    end
                {4'b1000,SET_LE} : begin
                    rx_dsa_le <= 4'b1000;
                    rx_dsa_d <= rx_dsa_d_agc[4];
                    service_done <= 4'b1000;
                    end
                {4'b1000,REMOVE_LE} : begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= rx_dsa_d_agc[4];
                    service_done <= 4'b0000;
                    end     
                default: begin
                    rx_dsa_le <= 4'b0000;
                    rx_dsa_d <= 0;
                    service_done <= 4'b0000;
                    end
             endcase    
          end    
        end
 */   
    //assign service_done = rx_dsa_le;
    
endmodule

