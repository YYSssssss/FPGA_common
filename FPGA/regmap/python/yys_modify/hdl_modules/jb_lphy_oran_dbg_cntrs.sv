

module jb_lphy_oran_dbg_cntrs(
  input  wire           clkin,
  input  wire           rstin,
  input  wire           clkout,
  input  wire           rstout,
  input  wire           CounterClick,
  input  wire  [4:0]    CounterNames,
  input  wire  [31:0]   CounterValues,
  
  jb_oran_lphy_stat_if.cnts  IFP_oran_lphy_stat
  );
  
  logic unsigned [4:0]     CounterNames_0;
  logic unsigned [31:0]    CounterValues_0;
  
  logic unsigned [4:0]     CounterNames_1;
  logic unsigned [31:0]    CounterValues_1;
  
  logic unsigned [31:0]    
    in_lphy_oran_runt_type0_cnt,
    in_lphy_oran_runt_type2_cnt,
    in_lphy_oran_win_t2_t1_dl_cnt,
    in_lphy_oran_win_t2_t1_ul_cnt,
    in_lphy_oran_win_t2_t3_ul_cnt,
    in_lphy_oran_win_t0_dl_cnt,
    in_lphy_oran_other_t0_err_cnt,
    in_lphy_oran_other_t2_err_cnt,
    in_lphy_oran_other_t1_ul_err_cnt,
    in_lphy_oran_other_t1_dl_err_cnt,
    in_lphy_oran_other_t3_err_cnt,
    in_lphy_oran_t1_data_dl_cnt,
    in_lphy_oran_t1_ctrl_ul_cnt,
    in_lphy_oran_t1_ctrl_dl_cnt,
    in_lphy_oran_t3_ctrl_ul_cnt,
    in_lphy_oran_t1_reqs_ul0_cnt,
    in_lphy_oran_t1_data_ul0_cnt,
    in_lphy_oran_t1_reqs_ul1_cnt,
    in_lphy_oran_t1_data_ul1_cnt,
    in_lphy_oran_t1_reqs_ul2_cnt,
    in_lphy_oran_t1_data_ul2_cnt,
    in_lphy_oran_t1_reqs_ul3_cnt,
    in_lphy_oran_t1_data_ul3_cnt,
    in_lphy_oran_t3_reqs_ul_cnt,
    in_lphy_oran_t3_data_ul_cnt;
        
  logic unsigned [1:0]
    sequenceCount;
    
  logic
    sequenceDone,
    sequenceDone_0,
    sequenceDone_1,
    sequenceDone_2,
    sequenceDone_3,
    sequenceDone_x;
  
  logic unsigned [31:0]    
    out_lphy_oran_runt_type0_cnt,
    out_lphy_oran_runt_type2_cnt,
    out_lphy_oran_win_t2_t1_dl_cnt,
    out_lphy_oran_win_t2_t1_ul_cnt,
    out_lphy_oran_win_t2_t3_ul_cnt,
    out_lphy_oran_win_t0_dl_cnt,
    out_lphy_oran_other_t0_err_cnt,
    out_lphy_oran_other_t2_err_cnt,
    out_lphy_oran_other_t1_ul_err_cnt,
    out_lphy_oran_other_t1_dl_err_cnt,
    out_lphy_oran_other_t3_err_cnt,
    out_lphy_oran_t1_data_dl_cnt,
    out_lphy_oran_t1_ctrl_ul_cnt,
    out_lphy_oran_t1_ctrl_dl_cnt,
    out_lphy_oran_t3_ctrl_ul_cnt,
    out_lphy_oran_t1_reqs_ul0_cnt,
    out_lphy_oran_t1_data_ul0_cnt,
    out_lphy_oran_t1_reqs_ul1_cnt,
    out_lphy_oran_t1_data_ul1_cnt,
    out_lphy_oran_t1_reqs_ul2_cnt,
    out_lphy_oran_t1_data_ul2_cnt,
    out_lphy_oran_t1_reqs_ul3_cnt,
    out_lphy_oran_t1_data_ul3_cnt,
    out_lphy_oran_t3_reqs_ul_cnt,
    out_lphy_oran_t3_data_ul_cnt;
    
  logic         CounterClick_0;
  logic         CounterClick_1;
  logic         click_rise;
  logic         click_hold;
  logic [3:0]   click_fan;
  
  

  always@(posedge clkin) begin
    // Register inputs...
    CounterNames_0    <= CounterNames;
    CounterValues_0   <= CounterValues;  
    CounterNames_1    <= CounterNames_0;
    CounterValues_1   <= CounterValues_0;  
    
    if (sequenceCount == 0)
      case (CounterNames_1)
        5'd0  : in_lphy_oran_runt_type0_cnt        <= CounterValues_1;
        5'd1  : in_lphy_oran_runt_type2_cnt        <= CounterValues_1;
        5'd2  : in_lphy_oran_win_t2_t1_dl_cnt      <= CounterValues_1;
        5'd3  : in_lphy_oran_win_t2_t1_ul_cnt      <= CounterValues_1;
        5'd4  : in_lphy_oran_win_t2_t3_ul_cnt      <= CounterValues_1;
        5'd5  : in_lphy_oran_win_t0_dl_cnt         <= CounterValues_1;
        5'd6  : in_lphy_oran_other_t0_err_cnt      <= CounterValues_1;
        5'd7  : in_lphy_oran_other_t2_err_cnt      <= CounterValues_1;
        5'd8  : in_lphy_oran_other_t1_ul_err_cnt   <= CounterValues_1;
        5'd9  : in_lphy_oran_other_t1_dl_err_cnt   <= CounterValues_1;
        5'd10 : in_lphy_oran_other_t3_err_cnt      <= CounterValues_1;
        5'd11 : in_lphy_oran_t1_data_dl_cnt        <= CounterValues_1;
        5'd12 : in_lphy_oran_t1_ctrl_ul_cnt        <= CounterValues_1;
        5'd13 : in_lphy_oran_t1_ctrl_dl_cnt        <= CounterValues_1;
        5'd14 : in_lphy_oran_t3_ctrl_ul_cnt        <= CounterValues_1;
        5'd15 : in_lphy_oran_t1_reqs_ul0_cnt       <= CounterValues_1;
        5'd16 : in_lphy_oran_t1_data_ul0_cnt       <= CounterValues_1;
        5'd17 : in_lphy_oran_t1_reqs_ul1_cnt       <= CounterValues_1;
        5'd18 : in_lphy_oran_t1_data_ul1_cnt       <= CounterValues_1;
        5'd19 : in_lphy_oran_t1_reqs_ul2_cnt       <= CounterValues_1;
        5'd20 : in_lphy_oran_t1_data_ul2_cnt       <= CounterValues_1;
        5'd21 : in_lphy_oran_t1_reqs_ul3_cnt       <= CounterValues_1;
        5'd22 : in_lphy_oran_t1_data_ul3_cnt       <= CounterValues_1;
        5'd23 : in_lphy_oran_t3_reqs_ul_cnt        <= CounterValues_1;
        5'd24 : in_lphy_oran_t3_data_ul_cnt        <= CounterValues_1;
      endcase
      
    if (CounterNames_1 == 5'd24)
      sequenceCount <= sequenceCount + 1;
      
    if (CounterNames_1 == 5'd24 && sequenceCount == 0)
      sequenceDone  <= ~sequenceDone;

    if (rstin) begin
      sequenceDone    <= 0;
      sequenceCount   <= 0;
    end
  end

  always@(posedge clkout) begin
    // Clock-crossing, detect any edge
    sequenceDone_0  <= sequenceDone;
    sequenceDone_1  <= sequenceDone_0;
    sequenceDone_2  <= sequenceDone_1;
    sequenceDone_3  <= sequenceDone_2;
    sequenceDone_x  <= sequenceDone_3 ^ sequenceDone_2;
    
    // Detect a rising edge on the CLICK signal, and take a snapshot of the counters...
    CounterClick_0  <= CounterClick;
    CounterClick_1  <= CounterClick_0;
    click_rise      <= CounterClick_0 && ~CounterClick_1;
    
    if (~click_hold && click_rise)
      click_hold  <= 1;
    else if (click_hold && sequenceDone_x)
      click_hold  <= 0;
    
    if (click_hold && sequenceDone_x)
      click_fan <= 4'd1;
    else
      click_fan <= {click_fan[2:0], 1'd0};
    
    // Capture when safe (not changing)...
    if (click_fan[3]) begin
      out_lphy_oran_runt_type0_cnt        <= in_lphy_oran_runt_type0_cnt;
      out_lphy_oran_runt_type2_cnt        <= in_lphy_oran_runt_type2_cnt;
      out_lphy_oran_win_t2_t1_dl_cnt      <= in_lphy_oran_win_t2_t1_dl_cnt;
      out_lphy_oran_win_t2_t1_ul_cnt      <= in_lphy_oran_win_t2_t1_ul_cnt;
      out_lphy_oran_win_t2_t3_ul_cnt      <= in_lphy_oran_win_t2_t3_ul_cnt;
      out_lphy_oran_win_t0_dl_cnt         <= in_lphy_oran_win_t0_dl_cnt;
      out_lphy_oran_other_t0_err_cnt      <= in_lphy_oran_other_t0_err_cnt;
      out_lphy_oran_other_t2_err_cnt      <= in_lphy_oran_other_t2_err_cnt;
      out_lphy_oran_other_t1_ul_err_cnt   <= in_lphy_oran_other_t1_ul_err_cnt;
      out_lphy_oran_other_t1_dl_err_cnt   <= in_lphy_oran_other_t1_dl_err_cnt;
      out_lphy_oran_other_t3_err_cnt      <= in_lphy_oran_other_t3_err_cnt;
      out_lphy_oran_t1_data_dl_cnt        <= in_lphy_oran_t1_data_dl_cnt;
      out_lphy_oran_t1_ctrl_ul_cnt        <= in_lphy_oran_t1_ctrl_ul_cnt;
      out_lphy_oran_t1_ctrl_dl_cnt        <= in_lphy_oran_t1_ctrl_dl_cnt;
      out_lphy_oran_t3_ctrl_ul_cnt        <= in_lphy_oran_t3_ctrl_ul_cnt;
      out_lphy_oran_t1_reqs_ul0_cnt       <= in_lphy_oran_t1_reqs_ul0_cnt;
      out_lphy_oran_t1_data_ul0_cnt       <= in_lphy_oran_t1_data_ul0_cnt;
      out_lphy_oran_t1_reqs_ul1_cnt       <= in_lphy_oran_t1_reqs_ul1_cnt;
      out_lphy_oran_t1_data_ul1_cnt       <= in_lphy_oran_t1_data_ul1_cnt;
      out_lphy_oran_t1_reqs_ul2_cnt       <= in_lphy_oran_t1_reqs_ul2_cnt;
      out_lphy_oran_t1_data_ul2_cnt       <= in_lphy_oran_t1_data_ul2_cnt;
      out_lphy_oran_t1_reqs_ul3_cnt       <= in_lphy_oran_t1_reqs_ul3_cnt;
      out_lphy_oran_t1_data_ul3_cnt       <= in_lphy_oran_t1_data_ul3_cnt;
      out_lphy_oran_t3_reqs_ul_cnt        <= in_lphy_oran_t3_reqs_ul_cnt;
      out_lphy_oran_t3_data_ul_cnt        <= in_lphy_oran_t3_data_ul_cnt;
    end
    
    if (rstout) begin
      click_hold  <= 0;
    end
  end
  
  assign IFP_oran_lphy_stat.lphy_oran_runt_type0_cnt          = out_lphy_oran_runt_type0_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_runt_type2_cnt          = out_lphy_oran_runt_type2_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_win_t2_t1_dl_cnt        = out_lphy_oran_win_t2_t1_dl_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_win_t2_t1_ul_cnt        = out_lphy_oran_win_t2_t1_ul_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_win_t2_t3_ul_cnt        = out_lphy_oran_win_t2_t3_ul_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_win_t0_dl_cnt           = out_lphy_oran_win_t0_dl_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_other_t0_err_cnt        = out_lphy_oran_other_t0_err_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_other_t2_err_cnt        = out_lphy_oran_other_t2_err_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_other_t1_ul_err_cnt     = out_lphy_oran_other_t1_ul_err_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_other_t1_dl_err_cnt     = out_lphy_oran_other_t1_dl_err_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_other_t3_err_cnt        = out_lphy_oran_other_t3_err_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_data_dl_cnt          = out_lphy_oran_t1_data_dl_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_ctrl_ul_cnt          = out_lphy_oran_t1_ctrl_ul_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_ctrl_dl_cnt          = out_lphy_oran_t1_ctrl_dl_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t3_ctrl_ul_cnt          = out_lphy_oran_t3_ctrl_ul_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul0_cnt         = out_lphy_oran_t1_reqs_ul0_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_data_ul0_cnt         = out_lphy_oran_t1_data_ul0_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul1_cnt         = out_lphy_oran_t1_reqs_ul1_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_data_ul1_cnt         = out_lphy_oran_t1_data_ul1_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul2_cnt         = out_lphy_oran_t1_reqs_ul2_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_data_ul2_cnt         = out_lphy_oran_t1_data_ul2_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_reqs_ul3_cnt         = out_lphy_oran_t1_reqs_ul3_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t1_data_ul3_cnt         = out_lphy_oran_t1_data_ul3_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t3_reqs_ul_cnt          = out_lphy_oran_t3_reqs_ul_cnt;
  assign IFP_oran_lphy_stat.lphy_oran_t3_data_ul_cnt          = out_lphy_oran_t3_data_ul_cnt;
  
endmodule
