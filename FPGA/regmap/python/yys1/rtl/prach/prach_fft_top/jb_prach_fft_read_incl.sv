
  
  //////////////////
  // state machine for control

logic [3:0] state, nextstate;
logic data_valid_d = 0;
logic reset_d = 0;
parameter state_idle = 0;
parameter state_ctrl_0_we = 1;
parameter state_fifo_0_wr = 2;
parameter state_fifo_0_wait = 3;
parameter state_ctrl_1_we = 4;
parameter state_fifo_1_wr = 5;
parameter state_fifo_1_wait = 6;
parameter state_ctrl_2_we = 7;
parameter state_fifo_2_wr = 8;
parameter state_fifo_2_wait = 9;
parameter state_ctrl_3_we = 10;
parameter state_fifo_3_wr = 11;
parameter state_fifo_3_wait = 12;

always @(posedge clk_dfe) begin // always block to update state
    if (clk_en_dfe) begin
        data_valid_d <= clk_en_dfe; 
        reset_d <= reset_dfe;
    end
 end

always @(posedge clk_dfe) begin // always block to update state
    if (reset_dfe)
        state <= state_idle;
    else if (clk_en_dfe) begin
        state <= nextstate; 
        end
 end
 
 always @(*) // always block to compute both output & nextstate
    begin
     case(state)
     state_idle : begin         
        if (fifo_1st_prog_full_data[0]) nextstate = state_ctrl_0_we;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[0] = 0;
         output_I_from_mem <= fifo_1st_dout_data_I[0];
         output_Q_from_mem <= fifo_1st_dout_data_Q[0];
         end     

     state_ctrl_0_we: begin
         nextstate = state_fifo_0_wr; 
         ctrl_we = 1;
         start = 1;
         rd_en_1st_data[0] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[0];
         output_Q_from_mem <= fifo_1st_dout_data_Q[0];
         end
     state_fifo_0_wr: begin
         if (fifo_1st_empty_data[0]) nextstate = state_fifo_0_wait;
 //        else if ((data_valid == 0 && data_valid_d == 1)) nextstate = state_idle;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[0] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[0];
         output_Q_from_mem <= fifo_1st_dout_data_Q[0];
         end
     state_fifo_0_wait: begin
         if (done) nextstate = state_ctrl_1_we;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[0] = 0;
         output_I_from_mem <= fifo_1st_dout_data_I[1];
         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
     state_ctrl_1_we: begin
         nextstate = state_fifo_1_wr; 
         ctrl_we = 1;
         start = 1;
         rd_en_1st_data[1] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[1];
         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
      state_fifo_1_wr: begin
         if (fifo_1st_empty_data[1]) nextstate = state_fifo_1_wait;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[1] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[1];
         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
      state_fifo_1_wait: begin
         if (done) nextstate = state_ctrl_2_we;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[1] = 0;
         output_I_from_mem <= fifo_1st_dout_data_I[2];
         output_Q_from_mem <= fifo_1st_dout_data_Q[2];
         end
      state_ctrl_2_we: begin
         nextstate = state_fifo_2_wr; 
         ctrl_we = 1;
         start = 1;
         rd_en_1st_data[2] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[2];
         output_Q_from_mem <= fifo_1st_dout_data_Q[2];
         end
     state_fifo_2_wr: begin
         if (fifo_1st_empty_data[2]) nextstate = state_fifo_2_wait;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[2] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[2];
         output_Q_from_mem <= fifo_1st_dout_data_Q[2];
         end
      state_fifo_2_wait: begin
         if (done) nextstate = state_ctrl_3_we;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[2] = 0;
         output_I_from_mem <= fifo_1st_dout_data_I[3];
         output_Q_from_mem <= fifo_1st_dout_data_Q[3];
         end
      state_ctrl_3_we: begin
         nextstate = state_fifo_3_wr; 
         ctrl_we = 1;
         start = 1;
         rd_en_1st_data[3] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[3];
         output_Q_from_mem <= fifo_1st_dout_data_Q[3];
         end
      state_fifo_3_wr: begin
         if (fifo_1st_empty_data[3]) nextstate = state_fifo_3_wait;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[3] = 1;
         output_I_from_mem <= fifo_1st_dout_data_I[3];
         output_Q_from_mem <= fifo_1st_dout_data_Q[3];
         end
      state_fifo_3_wait: begin
         if (done) nextstate = state_idle;
         ctrl_we = 0;
         start = 0;
         rd_en_1st_data[3] = 0;
         output_I_from_mem <= fifo_1st_dout_data_I[1];
         output_Q_from_mem <= fifo_1st_dout_data_Q[1];
         end
     default:
        nextstate = state_idle;
     endcase
    end
      
 