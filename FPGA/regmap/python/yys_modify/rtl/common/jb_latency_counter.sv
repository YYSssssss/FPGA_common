`timescale 1ns / 1ps

module jb_latency_counter
 (
    input               clk,        // i clock  
    input               clk_en,     // i clock enable           
    input               start_cnt,  // i start count
    input               end_cnt,    // i end count
    output logic [31:0] count = 0,  // o count
    output logic        valid = 0   // o valid
    );
    
///////////////////////////////////////////////////////////////////////////////////////////////
// Block resets counter on start_cnt enable.  
// Count starts from 1.  So output count when valid is the actual latency.,
// start_cnt and end_cnt should be based on clk_en. Tie clk_en to one if you want just clk.
/////////////////////////////////////////////////////////////////////////////////////////////// 
     
logic [31:0] cnt = 0;
    
// Register with clock enable
always_ff @(posedge clk) begin    
    if(clk_en) begin 
        if (start_cnt) cnt <= 1;
        else cnt <= cnt + 1; 
    end
end

always_ff @(posedge clk) begin    
    if(clk_en) begin 
        if (end_cnt) begin
            count <= cnt;
            valid <= 1;
        end
        else begin
            valid <= 0;
        end
    end
end

endmodule
