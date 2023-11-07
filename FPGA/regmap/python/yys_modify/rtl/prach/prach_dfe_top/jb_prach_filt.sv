`timescale 1ns / 1ps


module jb_prach_filt #(
    parameter  N_CARRIERS=2,
    parameter  N_ANTENNAS=4,
    parameter  PRECISION=16
) (
  //  input mux_sel_1, mux_sel_2, mux_sel_3, 
    input aclk,
    input srst,
    input aclken,
    input aclken_1x,
    input [3:0] ch_bw,
//    input [7:0] s_axis_config_tdata,
//    input s_axis_config_tvalid,
//    output s_axis_config_tready,
    jb_axi4_stream_if.slave     IFP_prach_in,
    jb_axi4_stream_if.master    IFP_prach_out
    
    );
    
    `include  "jb_common.svh"
    
//    localparam USER_ID_BW = $clog2(N_ANTENNAS);
      localparam USER_ID_BW = 2;
    
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) PRACH_fir_s_axis[5:0]();
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USER_ID_BW)) PRACH_fir_m_axis[5:0]();
    logic PRACH_fir_s_axis_0_tready;
    
    logic [31:0]   fir_U5_s_axis_tdata;
   
   logic [PRECISION-1:0] fir_dout_i [5:0];
   logic [PRECISION-1:0] fir_dout_q [5:0];
   logic [63:0] fir_dout_u6;
   logic [63:0] fir_dout_u5;
   logic [63:0] fir_dout_u3;
   logic [63:0] fir_dout_u2;
   logic [79:0] fir_dout_u1;
   logic [63:0] fir_U5_m_axis_tdata;
   logic [63:0] fir_U6_m_axis_tdata;
   logic [63:0] fir_U3_m_axis_tdata;
   logic [63:0] fir_U2_m_axis_tdata;
   logic [79:0] fir_U1_m_axis_tdata;
   logic [79:0] fir_U10_m_axis_tdata;
   logic [79:0] fir_U10_tdata;
   logic [PRECISION-1:0] IFP_in_q;
   logic [PRECISION-1:0] IFP_in_i;
   logic mux_sel_1, mux_sel_2, mux_sel_3;
   logic s_axis_config_tready;
   logic [7:0] s_axis_config_tdata;
   logic s_axis_config_tvalid;
   logic clk_en_d;
   
//   assign mux_sel_1=1'b1;  //  1 is mux input b, 20Mhz path
//   assign mux_sel_2=1'b0;  //  0 is mux input a, 20Mhz path
//   assign mux_sel_3=1'b0;  //  0 is mux input a, 20Mhz path
   
always_comb begin
    case (ch_bw) // b00: 20MHz  b01:10MHz b10: 5Mhz b11:15Mhz 
        4'b0000 : begin mux_sel_1='b1; mux_sel_2='b0; mux_sel_3='b0; end  
        4'b0001 : begin mux_sel_1='b1; mux_sel_2='b1; mux_sel_3='b0; end  
        4'b0010 : begin mux_sel_1='b0; mux_sel_2='b0; mux_sel_3='b1; end   
        4'b0011 : begin mux_sel_1='b1; mux_sel_2='b0; mux_sel_3='b0; end  
        default : begin mux_sel_1='b1; mux_sel_2='b0; mux_sel_3='b0; end       
    endcase
end

   (* dont_touch = "true" *) logic    [5:0] event_s_data_chanid_incorrect;
    
    assign PRACH_fir_s_axis[0].tready = IFP_prach_in.tready;
    assign PRACH_fir_s_axis[0].tvalid = IFP_prach_in.tvalid;
    assign PRACH_fir_s_axis[0].tuser  = IFP_prach_in.tuser;
    assign PRACH_fir_s_axis[0].tdata  = IFP_prach_in.tdata;
    assign IFP_in_q =  IFP_prach_in.tdata[31:16];
    assign IFP_in_i =  IFP_prach_in.tdata[15:0];
    
   ch2Rx_PRACH_15MHz_prachDnS_Decmt5_filt U5 (
  .aresetn                            (srst),                        // input wire aresetn
  .aclk                               (aclk),                              // input wire aclk
  .aclken                             (1'b1),                          // input wire aclken
  .s_axis_data_tvalid                 (PRACH_fir_s_axis[0].tvalid && aclken),  // input wire s_axis_data_tvalid
  .s_axis_data_tready                 (PRACH_fir_s_axis[0].tready),  // output wire s_axis_data_tready
  .s_axis_data_tuser                  (PRACH_fir_s_axis[0].tuser),    // input wire [1 : 0] s_axis_data_tuser
  .s_axis_data_tdata                  (PRACH_fir_s_axis[0].tdata),    // input wire [32 : 0] s_axis_data_tdata
  .m_axis_data_tvalid                 (PRACH_fir_m_axis[0].tvalid),   // output wire m_axis_data_tvalid
  .m_axis_data_tuser                  (PRACH_fir_m_axis[0].tuser),    // output wire [1 : 0] m_axis_data_tuser
  .m_axis_data_tdata                  (fir_U5_m_axis_tdata),    // output wire [63 : 0] m_axis_data_tdata
  .event_s_data_chanid_incorrect      (event_s_data_chanid_incorrect[0])  // output wire event_s_data_chanid_incorrect
);
   assign fir_dout_u5 =  fir_U5_m_axis_tdata;
   assign fir_dout_q[0] = fir_U5_m_axis_tdata[61:46];//66:51
   assign fir_dout_i[0] = fir_U5_m_axis_tdata[29:14];//30:15, 39:31  not used
   assign PRACH_fir_m_axis[0].tdata = {fir_dout_q[0],fir_dout_i[0]};
   
 always_comb begin
    case (ch_bw) 
        4'b0000 : s_axis_config_tdata = 8'b00000000;                 
        4'b0001 : s_axis_config_tdata = 8'b00000001;  
        4'b0010 : s_axis_config_tdata = 8'b00000000;  
        4'b0011 : s_axis_config_tdata = 8'b00000000;        
        default : s_axis_config_tdata = 8'b00000000;
    endcase
 end
  
 always_ff @(posedge aclk) begin 
   clk_en_d <= aclken;
 end
  
 always_ff @(posedge aclk) begin     //need ch_bw_update here
        if (srst==0) 
           s_axis_config_tvalid <= 1; 
        else if (clk_en_d==1)
         s_axis_config_tvalid  <= 0;    
 end

 
  ch3Rx_PRACH_20MHz_prachDnS_Decmt6_filt U6 (
  .aresetn                            (srst),                        // input wire aresetn
  .aclk                               (aclk),                              // input wire aclk
  .aclken                             (aclken),                          // input wire aclken
  .s_axis_data_tvalid                 (PRACH_fir_s_axis[0].tvalid),  // input wire s_axis_data_tvalid
  .s_axis_data_tready                 (PRACH_fir_s_axis_0_tready),  // output wire s_axis_data_tready
  .s_axis_data_tuser                  (PRACH_fir_s_axis[0].tuser),    // input wire [1 : 0] s_axis_data_tuser
  .s_axis_data_tdata                  (PRACH_fir_s_axis[0].tdata),    // input wire [31 : 0] s_axis_data_tdata
  .s_axis_config_tvalid               (s_axis_config_tvalid),  // input wire s_axis_config_tvalid
  .s_axis_config_tready               (s_axis_config_tready),  // output wire s_axis_config_tready
  .s_axis_config_tdata                (s_axis_config_tdata),    // input wire [7 : 0] s_axis_config_tdata
  .m_axis_data_tvalid                 (PRACH_fir_m_axis[1].tvalid),   // output wire m_axis_data_tvalid
  .m_axis_data_tuser                  (PRACH_fir_m_axis[1].tuser),    // output wire [1 : 0] m_axis_data_tuser
  .m_axis_data_tdata                  (fir_U6_m_axis_tdata),    // output wire [63 : 0] m_axis_data_tdata
  .event_s_data_chanid_incorrect     (event_s_data_chanid_incorrect[1])  // output wire event_s_data_chanid_incorrect
);
   assign fir_dout_u6 =  fir_U6_m_axis_tdata;
   assign fir_dout_q[1] = fir_U6_m_axis_tdata[61:46];//66:51
   assign fir_dout_i[1] = fir_U6_m_axis_tdata[29:14];//30:15, 39:31 not used
   assign PRACH_fir_m_axis[1].tdata = {fir_dout_q[1],fir_dout_i[1]};
   
  
  assign PRACH_fir_s_axis[1].tvalid= (mux_sel_1) ? PRACH_fir_m_axis[1].tvalid : PRACH_fir_m_axis[0].tvalid;     
  assign PRACH_fir_s_axis[1].tuser= (mux_sel_1) ? PRACH_fir_m_axis[1].tuser : PRACH_fir_m_axis[0].tuser;     
  assign PRACH_fir_s_axis[1].tdata= (mux_sel_1) ? PRACH_fir_m_axis[1].tdata : PRACH_fir_m_axis[0].tdata;       

    
    
    ch3Rx_PRACH_20MHz_prachDnS_Decmt3_filt U3 (
  .aresetn                            (srst),                      // input wire aresetn
  .aclk                               (aclk),                // input wire aclk
  .aclken                             (1'b1),                    // input wire aclken
  .s_axis_data_tvalid                 (PRACH_fir_s_axis[1].tvalid),  // input wire s_axis_data_tvalid
  .s_axis_data_tready                 (PRACH_fir_s_axis[1].tready),  // output wire s_axis_data_tready
  .s_axis_data_tuser                  (PRACH_fir_s_axis[1].tuser),   // input wire [1 : 0] s_axis_data_tuser
  .s_axis_data_tdata                  (PRACH_fir_s_axis[1].tdata),   // input wire [31 : 0] s_axis_data_tdata
  .m_axis_data_tvalid                 (PRACH_fir_m_axis[2].tvalid),  // output wire m_axis_data_tvalid
  .m_axis_data_tuser                  (PRACH_fir_m_axis[2].tuser),   // output wire [1 : 0] m_axis_data_tuser
  .m_axis_data_tdata                  (fir_U3_m_axis_tdata),   // output wire [63 : 0] m_axis_data_tdata
  .event_s_data_chanid_incorrect     (event_s_data_chanid_incorrect[2])  // output wire event_s_data_chanid_incorret
);  
   assign fir_dout_u3 =  fir_U3_m_axis_tdata;
   assign fir_dout_q[2] = fir_U3_m_axis_tdata[62:47];//66:51
   assign fir_dout_i[2] = fir_U3_m_axis_tdata[30:15];//30:15, 39:31 not used
   assign PRACH_fir_m_axis[2].tdata = {fir_dout_q[2],fir_dout_i[2]};

    assign PRACH_fir_s_axis[2].tvalid= (mux_sel_2) ? PRACH_fir_s_axis[1].tvalid: PRACH_fir_m_axis[2].tvalid; 
    assign PRACH_fir_s_axis[2].tuser= (mux_sel_2) ? PRACH_fir_s_axis[1].tuser: PRACH_fir_m_axis[2].tuser;                                                                                                         
    assign PRACH_fir_s_axis[2].tdata= (mux_sel_2) ? PRACH_fir_s_axis[1].tdata: PRACH_fir_m_axis[2].tdata;                                                    
                                                        
                                            
 
 
 ch3Rx_PRACH_20MHz_prachDnS_Decmt2_filt U2 (
   .aresetn                            (srst),                      // input wire aresetn
  .aclk                               (aclk),                // input wire aclk
  .aclken                             (1'b1),                    // input wire aclken
  .s_axis_data_tvalid                 (PRACH_fir_s_axis[2].tvalid && aclken),  // input wire s_axis_data_tvalid
  .s_axis_data_tready                 (PRACH_fir_s_axis[2].tready),  // output wire s_axis_data_tready
  .s_axis_data_tuser                  (PRACH_fir_s_axis[2].tuser),   // input wire [1 : 0] s_axis_data_tuser
  .s_axis_data_tdata                  (PRACH_fir_s_axis[2].tdata),   // input wire [31 : 0] s_axis_data_tdata
  .m_axis_data_tvalid                 (PRACH_fir_m_axis[3].tvalid),  // output wire m_axis_data_tvalid
  .m_axis_data_tuser                  (PRACH_fir_m_axis[3].tuser),   // output wire [1 : 0] m_axis_data_tuser
  .m_axis_data_tdata                  (fir_U2_m_axis_tdata),   // output wire [63 : 0] m_axis_data_tdata
  .event_s_data_chanid_incorrect     (event_s_data_chanid_incorrect[3])  // output wire event_s_data_chanid_incorrect
);        
   assign fir_dout_u2 =  fir_U2_m_axis_tdata;
   assign fir_dout_q[3] = fir_U2_m_axis_tdata[62:47];// was 62:47  ,66:51
   assign fir_dout_i[3] = fir_U2_m_axis_tdata[30:15];//30:15, 39:31 not used
   assign PRACH_fir_m_axis[3].tdata = {fir_dout_q[3],fir_dout_i[3]};
 
 
  assign PRACH_fir_s_axis[3].tvalid= (mux_sel_3) ? PRACH_fir_s_axis[1].tvalid: PRACH_fir_m_axis[3].tvalid;                                                   
  assign PRACH_fir_s_axis[3].tuser= (mux_sel_3) ? PRACH_fir_s_axis[1].tuser: PRACH_fir_m_axis[3].tuser;                                                                                                           
  assign PRACH_fir_s_axis[3].tdata= (mux_sel_3) ? PRACH_fir_s_axis[1].tdata: PRACH_fir_m_axis[3].tdata;                                                   
                                                        
  
 
 
 ch3Rx_PRACH_20MHz_prachDnS_Decmt1_filt U1 (
  .aresetn                            (srst),                      // input wire aresetn
  .aclk                               (aclk),                // input wire aclk
  .aclken                             (1'b1),                    // input wire aclken
  .s_axis_data_tvalid                 (PRACH_fir_s_axis[3].tvalid && aclken),  // input wire s_axis_data_tvalid
  .s_axis_data_tready                 (PRACH_fir_s_axis[3].tready),  // output wire s_axis_data_tready
  .s_axis_data_tuser                  (PRACH_fir_s_axis[3].tuser),   // input wire [1 : 0] s_axis_data_tuser
  .s_axis_data_tdata                  (PRACH_fir_s_axis[3].tdata),   // input wire [31 : 0] s_axis_data_tdata
  .m_axis_data_tvalid                 (PRACH_fir_m_axis[4].tvalid),  // output wire m_axis_data_tvalid
  .m_axis_data_tuser                  (PRACH_fir_m_axis[4].tuser),   // output wire [1 : 0] m_axis_data_tuser
  .m_axis_data_tdata                  (fir_U1_m_axis_tdata),   // output wire [79 : 0] m_axis_data_tdata
  .event_s_data_chanid_incorrect     (event_s_data_chanid_incorrect[4])  // output wire event_s_data_chanid_incorrect
);

   assign fir_dout_u1 =  fir_U1_m_axis_tdata;
   assign fir_dout_q[4] = fir_U1_m_axis_tdata[70:55];// was 70:55 truncate [54:40]
   assign fir_dout_i[4] = fir_U1_m_axis_tdata[30:15];//30:15, 39:31 not used
   assign PRACH_fir_m_axis[4].tdata = {fir_dout_q[4],fir_dout_i[4]};



ACS_prach_filt U10 (
  .aresetn                              (srst),                                              // input wire aresetn
  .aclk                                 (aclk),                                                    // input wire aclk
  .aclken                               (1'b1),                                                // input wire aclken
  .s_axis_data_tvalid                   (PRACH_fir_m_axis[4].tvalid),                        // input wire s_axis_data_tvalid
  .s_axis_data_tready                   (PRACH_fir_s_axis[4].tready),                        // output wire s_axis_data_tready
  .s_axis_data_tuser                    (PRACH_fir_m_axis[4].tuser),                          // input wire [1 : 0] s_axis_data_tuser
  .s_axis_data_tdata                    (PRACH_fir_m_axis[4].tdata),                          // input wire [31 : 0] s_axis_data_tdata
  .m_axis_data_tvalid                   (PRACH_fir_m_axis[5].tvalid),                        // output wire m_axis_data_tvalid
  .m_axis_data_tuser                    (PRACH_fir_m_axis[5].tuser),                          // output wire [1 : 0] m_axis_data_tuser
  .m_axis_data_tdata                    (fir_U10_m_axis_tdata),                          // output wire [79 : 0] m_axis_data_tdata
  .event_s_data_chanid_incorrect        (event_s_data_chanid_incorrect[5])  // output wire event_s_data_chanid_incorrect
);



   assign fir_U10_tdata = fir_U10_m_axis_tdata;
   assign fir_dout_q[5] = fir_U10_m_axis_tdata[70:55];// was 66:51  70:55 truncate [54:40]
   assign fir_dout_i[5] = fir_U10_m_axis_tdata[30:15];//26:11  30:15, 39:31 not used
   assign PRACH_fir_m_axis[5].tdata = {fir_dout_q[5],fir_dout_i[5]};
                                             
  assign    IFP_prach_out.tvalid    = PRACH_fir_m_axis[5].tvalid;       
  assign    IFP_prach_out.tuser     = PRACH_fir_m_axis[5].tuser;         
  assign    IFP_prach_out.tdata     = PRACH_fir_m_axis[5].tdata; 
  
//  assign    IFP_prach_out.tvalid    = PRACH_fir_m_axis[4].tvalid;       
//  assign    IFP_prach_out.tuser     = PRACH_fir_m_axis[4].tuser;         
//  assign    IFP_prach_out.tdata     = PRACH_fir_m_axis[4].tdata;    

//ila_prach_filter ila_prach_U6_inst (
//	.clk(aclk), // input wire clk


//	.probe0(aclken), // input wire [0:0]  probe0  
//	.probe1(PRACH_fir_s_axis[2].tdata[31:16]), // input wire [15:0]  probe1 
//	.probe2(PRACH_fir_s_axis[2].tdata[15:0]), // input wire [15:0]  probe2 
//	.probe3(PRACH_fir_s_axis[2].tvalid), // input wire [0:0]  probe3 
//	.probe4(PRACH_fir_s_axis[2].tuser), // input wire [1:0]  probe4 
//	.probe5(fir_dout_q[3]), // input wire [15:0]  probe5 
//	.probe6(fir_dout_i[3]), // input wire [15:0]  probe6 
//	.probe7(PRACH_fir_m_axis[3].tvalid), // input wire [0:0]  probe7 
//	.probe8(PRACH_fir_m_axis[3].tuser), // input wire [1:0]  probe8
//	.probe9(event_s_data_chanid_incorrect[3]) // input wire [0:0]  probe9
//);  

//ila_prach_filter ila_prach_filter_inst (
//	.clk(aclk), // input wire clk


//	.probe0(aclken), // input wire [0:0]  probe0  
//	.probe1(PRACH_fir_m_axis[1].tvalid), // input wire [0:0]  probe1 
//	.probe2(PRACH_fir_m_axis[1].tuser), // input wire [1:0]  probe2 
//	.probe3(fir_dout_q[1]), // input wire [15:0]  probe3 
//	.probe4(event_s_data_chanid_incorrect[1]), // input wire [0:0]  probe4 
//	.probe5(PRACH_fir_m_axis[3].tvalid), // input wire [0:0]  probe5 
//	.probe6(PRACH_fir_m_axis[3].tuser), // input wire [1:0]  probe6 
//	.probe7(fir_dout_q[3]), // input wire [15:0]  probe7 
//	.probe8(event_s_data_chanid_incorrect[3]), // input wire [0:0]  probe8 
//	.probe9(PRACH_fir_m_axis[4].tvalid), // input wire [0:0]  probe9 
//	.probe10(PRACH_fir_m_axis[4].tuser), // input wire [1:0]  probe10 
//	.probe11(fir_dout_q[4]), // input wire [15:0]  probe11 
//	.probe12(event_s_data_chanid_incorrect[4]), // input wire [0:0]  probe12 
//	.probe13(PRACH_fir_m_axis[5].tvalid), // input wire [0:0]  probe13 
//	.probe14(PRACH_fir_m_axis[5].tuser), // input wire [1:0]  probe14 
//	.probe15(fir_dout_q[5]), // input wire [15:0]  probe15 
//	.probe16(event_s_data_chanid_incorrect[5]) // input wire [0:0]  probe16
//);


endmodule



