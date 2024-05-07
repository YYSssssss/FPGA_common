//-----------------------------------------------------------------------------
// File: rsp_s2_dma_ctrl.v
// Author: Jichen Wang
// Created by : Jichen Wang
// Abstract: DMA control
// Modification history:
// $Log$
//   Jichen 3/11/2024 original
// Version: 1.0
// Copyright (C) 2024 Sensemi Corp.
// All right reserved
//-----------------------------------------------------------------------------

module rsp_s2_dma_ctrl (
  clk,
  rst_n,

  start,
  pcnt_finish,
  ccnt_finish,
  update,
  resume
);

input                    clk;
input                    rst_n;

input                    start;
input                    pcnt_finish;
input                    ccnt_finish;
output                   update;
output                   resume;

localparam  [1:0]        IDLE    = 2'd0,
                         RUN     = 2'd1,
                         PAUSE   = 2'd2;
                         

reg  [1:0]               cs, ns;

reg                      update, update_next;
reg                      resume, resume_next;


always @(posedge clk or negedge rst_n)
  if (!rst_n) begin
    cs          <= IDLE;
    update      <= 1'b0;
    resume      <= 1'b0;
  end else begin
    cs          <= ns;
    update      <= update_next;
    resume      <= resume_next;
  end

always @(*) begin
  ns           = cs;
  update_next  = 1'b0;
  resume_next  = 1'b0;
  
  case (cs)
    IDLE: begin
      if (start) begin
        ns = RUN;
        update_next = 1'b1;
      end
    end
    
    RUN: begin
      if (ccnt_finish) begin
        ns = IDLE;
      end else if (pcnt_finish) begin
        ns = PAUSE;
      end
    end 

    PAUSE: begin
      if (start) begin
        ns = RUN;
        resume_next = 1'b1;
      end
    end
  endcase
end
   
endmodule