///////////////////////////////////////////////////////////////////////////////
//
// AXI4-Lite Master
//
////////////////////////////////////////////////////////////////////////////
//
// Structure:
//   axi_lite_master
//
// Last Update:
//   08/08/2024
////////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps

module axi_lite_user_logic #
  (
  parameter         C_M_AXI_ADDR_WIDTH   = 32,
  parameter         C_M_AXI_DATA_WIDTH   = 32,
  parameter         INIT_CONFIG_PARA_NUM = 8,
  parameter         COMMANDS_NUM         = 9224,
  parameter         COMMANDS_BURSTLEN    = 8
  )
(
  input                                       clk,
  input                                       rstn,

  input                                       i_frame_start,
  input                                       i_start_input_gpio,


  output    logic [C_M_AXI_ADDR_WIDTH-1:0] 	  awaddr,
  input     logic                        	  awvalid,
  input     logic        	                  awready,
  output    logic [C_M_AXI_DATA_WIDTH-1:0] 	  wdata,
  input     logic                        	  wvalid,
  input     logic        	                  wready,


  output    logic                             push_write,
  output    logic                             pop_read,
  inout     logic [15:0]                      i_cnt_m_axis_mm2s_tlast_pos,
  output    logic                             dma_done_irq
  );

//******************** parameter ********************//
localparam VDMA_IRQ_NUM = 'd4;
localparam INIT_TIME          = 16'd50;
localparam INIT               = 5'b00000;
localparam IDLE               = 5'b00001;
localparam CONFIG_PARAMETER   = 5'b00010;
localparam COMMAND_WRITE      = 5'b00100;
localparam CONFIG_WAIT        = 5'b01000;
localparam COMMAND_WAIT       = 5'b10000;
reg [5-1:0] c_state;
reg [5-1:0] n_state;
localparam CFG_WAIT_NUM       = 3;

localparam MAP_MUX_INIT_TIME_WIDTH = $clog2(INIT_TIME);
localparam INIT_CONFIG_PARA_NUM_WIDTH = $clog2(INIT_CONFIG_PARA_NUM);
localparam COMMANDS_NUM_WIDTH = $clog2(COMMANDS_NUM);
localparam CFG_WAIT_NUM_WIDTH = $clog2(CFG_WAIT_NUM);

//******************** reg wire logic assign********************//
reg [MAP_MUX_INIT_TIME_WIDTH : 0]   cnt_init_time;
reg [INIT_CONFIG_PARA_NUM_WIDTH : 0]   cnt_init_cfg_para_num;
reg [COMMANDS_NUM_WIDTH : 0]   cnt_config_cmd_num;
reg [COMMANDS_NUM_WIDTH : 0]   cnt_all_cmd_num;
reg [CFG_WAIT_NUM_WIDTH : 0]   cnt_cfg_wait;
reg [CFG_WAIT_NUM_WIDTH : 0]   cnt_cmd_wait;

reg frame_start_d0;
reg frame_start_d1;
wire frame_start_pos;
reg start_input_gpio_d0;
reg start_input_gpio_d1;
wire start_input_gpio_pos;
//reg start_cmd_cfg;

reg aw_done;
reg w_done;
//wire dma_done_irq;

reg           bram_rd_en;
reg [64-1:0]  bram_douta;
reg [64-1:0]  bram_addra;

assign pop_read = 1'b0;


//******************** instruct ********************//
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_init_time <= {MAP_MUX_INIT_TIME_WIDTH{1'b0}};
    end
    else begin
        if(cnt_init_time == INIT_TIME - 1'b1)
            cnt_init_time <= cnt_init_time;
        else
            cnt_init_time <= cnt_init_time + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        frame_start_d0 <= 1'b0;
        frame_start_d1 <= 1'b0;
    end
    else begin
        frame_start_d0 <= i_frame_start;
        frame_start_d1 <= frame_start_d0;
    end
end
assign frame_start_pos = frame_start_d0 && ~frame_start_d1;

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        start_input_gpio_d0 <= 1'b0;
        start_input_gpio_d1 <= 1'b0;
    end
    else begin
        start_input_gpio_d0 <= i_start_input_gpio;
        start_input_gpio_d1 <= start_input_gpio_d0;
    end
end
assign start_input_gpio_pos = start_input_gpio_d0 && ~start_input_gpio_d1;

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_init_cfg_para_num <= {INIT_CONFIG_PARA_NUM_WIDTH{1'b0}};
    end
    else begin
        if(frame_start_pos == 1'b1)
            cnt_init_cfg_para_num <= {INIT_CONFIG_PARA_NUM_WIDTH{1'b0}};
        else if(push_write == 1'b1)
            cnt_init_cfg_para_num <= cnt_init_cfg_para_num + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_config_cmd_num <= {COMMANDS_NUM_WIDTH{1'b0}};
    end
    else begin
        if(start_input_gpio_pos == 1'b1)
            cnt_config_cmd_num <= {COMMANDS_NUM_WIDTH{1'b0}};
        else if(push_write == 1'b1)
            cnt_config_cmd_num <= cnt_config_cmd_num + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        cnt_all_cmd_num <= {COMMANDS_NUM_WIDTH{1'b0}};
    end
    else begin
        if(frame_start_pos == 1'b1)
            cnt_all_cmd_num <= {COMMANDS_NUM_WIDTH{1'b0}};
        else if(push_write == 1'b1)
            cnt_all_cmd_num <= cnt_all_cmd_num + 1'b1;
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        aw_done <= 1'b0;
    end
    else begin
        if(c_state == CONFIG_PARAMETER || c_state == COMMAND_WRITE)
            aw_done <= 1'b0;
        else if(awvalid && awready)
            aw_done <= 1'b1;
    end
end
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        w_done <= 1'b0;
    end
    else begin
        if(c_state == CONFIG_PARAMETER || c_state == COMMAND_WRITE)
            w_done <= 1'b0;
        else if(wvalid && wready)
            w_done <= 1'b1;
    end
end


always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        dma_done_irq <= 1'b0;
    end
    else begin
        if(i_frame_start == 1'b1)
            dma_done_irq <= 1'b0;
//        else if(cnt_all_cmd_num == 'd4055 && i_cnt_m_axis_mm2s_tlast_pos == VDMA_IRQ_NUM)
        else if(cnt_all_cmd_num == COMMANDS_NUM)
            dma_done_irq <= 1'b1;
    end
end


//******************** state machine ********************//
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        c_state <= 'd0;
    end
    else begin
        c_state <= n_state;  
    end
end

always@(*)begin
    if(!rstn) begin
        n_state = INIT;
    end
    else begin
        case (c_state) 
            INIT : begin
                if(cnt_init_time == INIT_TIME - 1'b1)
                    n_state = IDLE;
                else
                    n_state = INIT;
            end
            IDLE : begin
                    if(dma_done_irq == 1'b1)
                        n_state = IDLE;
                    else if(frame_start_pos == 1'b1)
                        n_state = CONFIG_PARAMETER;
                    else if(start_input_gpio_pos == 1'b1)
                        n_state = COMMAND_WRITE;
                    else
                        n_state = IDLE;
                end
            CONFIG_PARAMETER : begin
                    n_state = CONFIG_WAIT;
                end
            COMMAND_WRITE : begin
                    n_state = COMMAND_WAIT;
                end
            CONFIG_WAIT : begin
                    if(cnt_init_cfg_para_num == INIT_CONFIG_PARA_NUM)
                        n_state = IDLE;
                    else if(cnt_cfg_wait == CFG_WAIT_NUM - 1'b1 && aw_done && w_done)
                        n_state = CONFIG_PARAMETER;
                    else
                        n_state = CONFIG_WAIT;
                end
            COMMAND_WAIT : begin
                    if(cnt_all_cmd_num == COMMANDS_NUM)
                        n_state = IDLE;
                    else if(cnt_config_cmd_num == COMMANDS_BURSTLEN)
                        n_state = IDLE;
                    else if(cnt_cmd_wait == CFG_WAIT_NUM - 1'b1 && aw_done && w_done)
                        n_state = COMMAND_WRITE;
                    else
                        n_state = COMMAND_WAIT;
                end
            default : ;
        endcase
    end
end
always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
      cnt_cfg_wait <= 'd0;
      cnt_cmd_wait <= 'd0;
      bram_rd_en <= 1'b0;
    end
    else begin
        case (n_state) 
            INIT : begin
                  
                end
            IDLE : begin
                  cnt_cfg_wait <= 'd0;
                  cnt_cmd_wait <= 'd0;
                  bram_rd_en <= 1'b0;
                end
            CONFIG_PARAMETER : begin
                  cnt_cfg_wait <= 'd0;
                  bram_rd_en <= 1'b1;
                  
                end
            COMMAND_WRITE : begin
                  cnt_cmd_wait <= 'd0;
                  bram_rd_en <= 1'b1;
                end
            CONFIG_WAIT : begin
                  cnt_cfg_wait <= cnt_cfg_wait + 1'b1;
                  bram_rd_en <= 1'b0;
                end
            COMMAND_WAIT : begin
                  cnt_cmd_wait <= cnt_cmd_wait + 1'b1;
                  bram_rd_en <= 1'b0;
                end
            default : ;
        endcase
    end
end

always@(posedge clk or negedge rstn)begin
    if(!rstn) begin
        bram_addra <= 'd0;
    end
    else begin
        if(frame_start_pos == 1'b1 )
            bram_addra <= 'd0;
        else if(bram_rd_en)
            bram_addra <= bram_addra + 1'b1;
    end
end

//******************** ram ********************//
blk_mem_gen_1 u_blk_mem_gen_1 (
  .clka     (clk),    // input wire clka
  .ena      (bram_rd_en),         // input wire ena
  .wea      ('d0),      // input wire [7 : 0] wea
  .addra    (bram_addra),  // input wire [3 : 0] addra
  .dina     (64'd0),    // input wire [63 : 0] dina
  .douta    (bram_douta)  // output wire [63 : 0] douta
);


//******************** output ********************//
delay_bit #(.DELAY (1)) u_push_write( .clk(clk), .rst_n(rstn), .din(bram_rd_en), .dout(push_write));

assign awaddr = bram_douta[63:32];
assign wdata  = bram_douta[31:0];


endmodule