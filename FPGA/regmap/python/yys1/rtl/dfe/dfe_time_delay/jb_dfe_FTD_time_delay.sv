////////////////////////////////////////////////////////////////////
////  File Name : jb_dfe_FTD_time_delay.sv
///// Author    : Sharief Megeed
///// Date      : 10/31/2019
///// Description  : Time delay fractional 
///                 
///
////////////////////////////////////////////////////////////////////

 module jb_dfe_FTD_time_delay #(
      parameter  N_CARRIERS=2,
      parameter  N_ANTENNAS=4,
      parameter  PRECISION=16
   ) (

      input            clk_4x,  //491.52 MHz
      input            resetn,
      
      input signed [15:0]      frt_delay[N_ANTENNAS-1:0],
      jb_axi4_stream_if.slave  IFP_dfe_delay_in,
            //input tuser,tkeep,tdata,tvalid,tlast
            //output tready        
      jb_axi4_stream_if.master IFP_dfe_delay_out_FTD
            //input tready
            //output tuser,tkeep,tdata,tvalid,tlast
      );

     localparam USR_ID_BW = 2;

        //each carrier interface has 
        //logic [USER_SB_WIDTH-1:0] tuser; //USER_SB_WIDTH = 2  represents 4 antenna
        //logic [DATA_WIDTH-1:0]    tdata; //DATA_WIDTH = 32  {16 Q, 16 I}
        //logic                     tvalid;
        //logic                     tready; //SET to 1 on output

// Fractional Time Delay

    logic signed [15:0] mu  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_2d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_3d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_4d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_5d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_6d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_7d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_8d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_9d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_10d  [N_ANTENNAS-1:0] ='{default:0};
    logic signed [31:0] mu2_d [N_ANTENNAS-1:0] ='{default:0};
    logic signed [31:0] mu2_2d [N_ANTENNAS-1:0] ='{default:0};
    logic signed [31:0] mu2_3d [N_ANTENNAS-1:0] ='{default:0};
    logic signed [31:0] mu2_4d [N_ANTENNAS-1:0] ='{default:0};
    logic signed [31:0] mu2_5d [N_ANTENNAS-1:0] ='{default:0};
    logic signed [15:0] mu_correct [N_ANTENNAS-1:0];
    logic signed [15:0] mu2_correct [N_ANTENNAS-1:0];
    logic signed [15:0] mu3_correct [N_ANTENNAS-1:0];
    logic signed [31:0] mu2_ip [N_ANTENNAS-1:0];
    logic signed [31:0] mu3_ip [N_ANTENNAS-1:0];
    
    always_ff @(posedge clk_4x)  begin
        mu[0]  <= $signed(frt_delay[0]);
        mu[1]  <= $signed(frt_delay[1]);
        mu[2]  <= $signed(frt_delay[2]);
        mu[3]  <= $signed(frt_delay[3]);
        
        mu_d[0] <= mu[0];
        mu_d[1] <= mu[1];
        mu_d[2] <= mu[2];
        mu_d[3] <= mu[3];
    
        mu_2d[0] <= mu_d[0];
        mu_2d[1] <= mu_d[1];
        mu_2d[2] <= mu_d[2];
        mu_2d[3] <= mu_d[3];
        
        mu_3d[0] <= mu_2d[0];
        mu_3d[1] <= mu_2d[1];
        mu_3d[2] <= mu_2d[2];
        mu_3d[3] <= mu_2d[3];
        
        mu_4d[0] <= mu_3d[0];
        mu_4d[1] <= mu_3d[1];
        mu_4d[2] <= mu_3d[2];
        mu_4d[3] <= mu_3d[3];
        
        mu_5d[0] <= mu_4d[0];
        mu_5d[1] <= mu_4d[1];
        mu_5d[2] <= mu_4d[2];
        mu_5d[3] <= mu_4d[3];
        
        mu_6d[0] <= mu_5d[0];
        mu_6d[1] <= mu_5d[1];
        mu_6d[2] <= mu_5d[2];
        mu_6d[3] <= mu_5d[3];        

        mu_7d[0] <= mu_6d[0];
        mu_7d[1] <= mu_6d[1];
        mu_7d[2] <= mu_6d[2];
        mu_7d[3] <= mu_6d[3];        

        mu_8d[0] <= mu_7d[0];
        mu_8d[1] <= mu_7d[1];
        mu_8d[2] <= mu_7d[2];
        mu_8d[3] <= mu_7d[3];        

        mu_9d[0] <= mu_8d[0];
        mu_9d[1] <= mu_8d[1];
        mu_9d[2] <= mu_8d[2];
        mu_9d[3] <= mu_8d[3];        

        mu_10d[0] <= mu_9d[0];
        mu_10d[1] <= mu_9d[1];
        mu_10d[2] <= mu_9d[2];
        mu_10d[3] <= mu_9d[3];        

        mu2_d[0] <= mu2_ip[0];
        mu2_d[1] <= mu2_ip[1];
        mu2_d[2] <= mu2_ip[2];
        mu2_d[3] <= mu2_ip[3];
        
        mu2_2d[0] <= mu2_d[0];
        mu2_2d[1] <= mu2_d[1];
        mu2_2d[2] <= mu2_d[2];
        mu2_2d[3] <= mu2_d[3];

        mu2_3d[0] <= mu2_2d[0];
        mu2_3d[1] <= mu2_2d[1];
        mu2_3d[2] <= mu2_2d[2];
        mu2_3d[3] <= mu2_2d[3];
        
        mu2_4d[0] <= mu2_3d[0];
        mu2_4d[1] <= mu2_3d[1];
        mu2_4d[2] <= mu2_3d[2];
        mu2_4d[3] <= mu2_3d[3];
        
        mu2_5d[0] <= mu2_4d[0];
        mu2_5d[1] <= mu2_4d[1];
        mu2_5d[2] <= mu2_4d[2];
        mu2_5d[3] <= mu2_4d[3];
        
    end

  
    mult_16x16_5 i_mult_16x16_mu2_0 
    (
        .CLK(clk_4x),
        .A(mu[0]),
        .B(mu[0]),
        .P(mu2_ip[0])
    );
    mult_16x16_5 i_mult_16x16_mu2_1
    (
        .CLK(clk_4x),
        .A(mu[1]),
        .B(mu[1]),
        .P(mu2_ip[1])
    );
    mult_16x16_5 i_mult_16x16_mu2_2
    (
        .CLK(clk_4x),
        .A(mu[2]),
        .B(mu[2]),
        .P(mu2_ip[2])
    );
    mult_16x16_5 i_mult_16x16_mu2_3
    (
        .CLK(clk_4x),
        .A(mu[3]),
        .B(mu[3]),
        .P(mu2_ip[3])
    );
    
    mult_16x16_5 i_mult_16x16_mu3_0 
    (
        .CLK(clk_4x),
        .A($signed(mu2_ip[0][31:16])),
        .B(mu[0]),
        .P(mu3_ip[0])
    );
    mult_16x16_5 i_mult_16x16_mu3_1
    (
        .CLK(clk_4x),
        .A($signed(mu2_ip[1][31:16])),
        .B(mu[1]),
        .P(mu3_ip[1])
    );
    mult_16x16_5 i_mult_16x16_mu3_2
    (
        .CLK(clk_4x),
        .A($signed(mu2_ip[2][31:16])),
        .B(mu[2]),
        .P(mu3_ip[2])
    );
    mult_16x16_5 i_mult_16x16_mu3_3
    (
        .CLK(clk_4x),
        .A($signed(mu2_ip[3][31:16])),
        .B(mu[3]),
        .P(mu3_ip[3])
    );
 
    
    assign mu_correct[0] = $signed(mu_10d[0]);
    assign mu_correct[1] = $signed(mu_10d[1]);
    assign mu_correct[2] = $signed(mu_10d[2]);
    assign mu_correct[3] = $signed(mu_10d[3]); 
 
    assign mu2_correct[0] = $signed(mu2_5d[0][30:15]);
    assign mu2_correct[1] = $signed(mu2_5d[1][30:15]);
    assign mu2_correct[2] = $signed(mu2_5d[2][30:15]);
    assign mu2_correct[3] = $signed(mu2_5d[3][30:15]);

    assign mu3_correct[0] = $signed(mu3_ip[0][29:14]);
    assign mu3_correct[1] = $signed(mu3_ip[1][29:14]);
    assign mu3_correct[2] = $signed(mu3_ip[2][29:14]);
    assign mu3_correct[3] = $signed(mu3_ip[3][29:14]);
 
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out_fir0();
    logic [63:0] fir0_data_out;

    FTD_FIR_0 i_FTD_FIR_0
    ( 
        .aclk(clk_4x),                                        //Input Clock
        .s_axis_data_tvalid(IFP_dfe_delay_in.tvalid),         //Input Valid
        .s_axis_data_tready(IFP_dfe_delay_in.tready),         //Output Ready
        .s_axis_data_tuser(IFP_dfe_delay_in.tuser),           //Input User[1:0]
        .s_axis_data_tdata(IFP_dfe_delay_in.tdata),           //Input Data {[15:0],[15:0]}
        .m_axis_data_tvalid(IFP_dfe_delay_out_fir0.tvalid),   //Output Valid
        .m_axis_data_tuser(IFP_dfe_delay_out_fir0.tuser),     //Output User[1:0]
        .m_axis_data_tdata(fir0_data_out)                     //Output Data[63:0] True width TBD
    );

    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out_fir1();
    logic [63:0] fir1_data_out;

    FTD_FIR_1 i_FTD_FIR_1
    ( 
        .aclk(clk_4x),                                        //Input Clock
        .s_axis_data_tvalid(IFP_dfe_delay_in.tvalid),         //Input Valid
        .s_axis_data_tready(),                                //Output Ready
        .s_axis_data_tuser(IFP_dfe_delay_in.tuser),           //Input User[1:0]
        .s_axis_data_tdata(IFP_dfe_delay_in.tdata),           //Input Data {[15:0],[15:0]}
        .m_axis_data_tvalid(IFP_dfe_delay_out_fir1.tvalid),   //Output Valid
        .m_axis_data_tuser(IFP_dfe_delay_out_fir1.tuser),     //Output User[1:0]
        .m_axis_data_tdata(fir1_data_out)                     //Output Data[63:0] True width TBD
    );
    
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out_fir2();
    logic [63:0] fir2_data_out;

    FTD_FIR_2 i_FTD_FIR_2
    ( 
        .aclk(clk_4x),                                        //Input Clock
        .s_axis_data_tvalid(IFP_dfe_delay_in.tvalid),         //Input Valid
        .s_axis_data_tready(),                                //Output Ready
        .s_axis_data_tuser(IFP_dfe_delay_in.tuser),           //Input User[1:0]
        .s_axis_data_tdata(IFP_dfe_delay_in.tdata),           //Input Data {[15:0],[15:0]}
        .m_axis_data_tvalid(IFP_dfe_delay_out_fir2.tvalid),   //Output Valid
        .m_axis_data_tuser(IFP_dfe_delay_out_fir2.tuser),     //Output User[1:0]
        .m_axis_data_tdata(fir2_data_out)                     //Output Data[63:0] True width TBD
    );   
    
    jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(USR_ID_BW)) IFP_dfe_delay_out_fir3();
    logic [63:0] fir3_data_out;

    FTD_FIR_3 i_FTD_FIR_3
    ( 
        .aclk(clk_4x),                                        //Input Clock
        .s_axis_data_tvalid(IFP_dfe_delay_in.tvalid),         //Input Valid
        .s_axis_data_tready(),                                //Output Ready
        .s_axis_data_tuser(IFP_dfe_delay_in.tuser),           //Input User[1:0]
        .s_axis_data_tdata(IFP_dfe_delay_in.tdata),           //Input Data {[15:0],[15:0]}
        .m_axis_data_tvalid(IFP_dfe_delay_out_fir3.tvalid),   //Output Valid
        .m_axis_data_tuser(IFP_dfe_delay_out_fir3.tuser),     //Output User[1:0]
        .m_axis_data_tdata(fir3_data_out)                     //Output Data[63:0] True width TBD
    ); 
    
    logic signed [79:0] fir3_mult_out_q ='{default:0};
    logic signed [79:0] fir3_mult_out_i ='{default:0};
    logic signed [79:0] fir3_mult_out_q_test ='{default:0};
    logic signed [79:0] fir3_mult_out_i_test ='{default:0};
    logic signed [79:0] fir2_mult_out_q ='{default:0};
    logic signed [79:0] fir2_mult_out_i ='{default:0};
    logic signed [79:0] fir1_mult_out_q ='{default:0};
    logic signed [79:0] fir1_mult_out_i ='{default:0};
    logic signed [79:0] fir0_mult_out_q ='{default:0};
    logic signed [79:0] fir0_mult_out_i ='{default:0};
    logic signed [79:0] fir0_mult_out_q_test ='{default:0};
    logic signed [79:0] fir0_mult_out_i_test ='{default:0};
  
    always_ff @(posedge clk_4x)  begin
        fir3_mult_out_q <= $signed(mu3_correct[IFP_dfe_delay_out_fir3.tuser]) * $signed(fir3_data_out[63:32]);  // 48x32
        fir3_mult_out_i <= $signed(mu3_correct[IFP_dfe_delay_out_fir3.tuser]) * $signed(fir3_data_out[31:0]);  // 48x32
        fir2_mult_out_q <= $signed({mu2_correct[IFP_dfe_delay_out_fir2.tuser],16'd0}) * $signed(fir2_data_out[63:32]);  // 48x32
        fir2_mult_out_i <= $signed({mu2_correct[IFP_dfe_delay_out_fir2.tuser],16'd0}) * $signed(fir2_data_out[31:0]);  // 48x32
        fir1_mult_out_q <= $signed({mu_correct[IFP_dfe_delay_out_fir1.tuser],32'd0}) * $signed(fir1_data_out[63:32]);  // 48x32
        fir1_mult_out_i <= $signed({mu_correct[IFP_dfe_delay_out_fir1.tuser],32'd0}) * $signed(fir1_data_out[31:0]);  // 48x32
        fir0_mult_out_q <= 48'sh7FFF_FFFF_FFFF * $signed(fir0_data_out[63:32]); //48x32
        fir0_mult_out_i <= 48'sh7FFF_FFFF_FFFF * $signed(fir0_data_out[31:0]);  //48x32
    end
    
    
    logic signed [31:0] fir3_mult_out_q_ip;
    logic signed [31:0] fir3_mult_out_i_ip;
    logic signed [31:0] fir2_mult_out_q_ip;
    logic signed [31:0] fir2_mult_out_i_ip;
    logic signed [31:0] fir1_mult_out_q_ip;
    logic signed [31:0] fir1_mult_out_i_ip;
    logic signed [31:0] fir0_mult_out_q_ip;
    logic signed [31:0] fir0_mult_out_i_ip;    
    
    logic signed [15:0] mu3_inmult;
    logic signed [15:0] mu2_inmult;
    logic signed [15:0] mu_inmult;    
    
    assign mu3_inmult = $signed(mu3_correct[IFP_dfe_delay_out_fir3.tuser]);
    assign mu2_inmult = $signed(mu2_correct[IFP_dfe_delay_out_fir2.tuser]);
    assign mu_inmult = $signed(mu_correct[IFP_dfe_delay_out_fir1.tuser]); 


    mult_16x16_5 i_mult_16x16_3q //48x32 mult with 5 delay registers
    (
        .CLK(clk_4x),
        .A(mu3_inmult),
        .B(fir3_data_out[63:48]),
        .P(fir3_mult_out_q_ip)
    );
    mult_16x16_5 i_mult_16x16_3i
    (
        .CLK(clk_4x),
        .A(mu3_inmult),
        .B(fir3_data_out[31:16]),
        .P(fir3_mult_out_i_ip)
    );
    mult_16x16_5 i_mult_16x16_2q 
    (
        .CLK(clk_4x),
        .A(mu2_inmult),
        .B(fir2_data_out[63:48]),
        .P(fir2_mult_out_q_ip)
    );
    mult_16x16_5 i_mult_16x16_2i
    (
        .CLK(clk_4x),
        .A(mu2_inmult),
        .B(fir2_data_out[31:16]),
        .P(fir2_mult_out_i_ip)
    );
    mult_16x16_5 i_mult_16x16_1q 
    (
        .CLK(clk_4x),
        .A(mu_inmult),
        .B(fir1_data_out[63:48]),
        .P(fir1_mult_out_q_ip)
    );
    mult_16x16_5 i_mult_16x16_1i
    (
        .CLK(clk_4x),
        .A(mu_inmult),
        .B(fir1_data_out[31:16]),
        .P(fir1_mult_out_i_ip)
    );
    mult_16x16_5 i_mult_16x16_0q 
    (
        .CLK(clk_4x),
        .A(48'sh7FFF),
        .B(fir0_data_out[63:48]),
        .P(fir0_mult_out_q_ip)
    );
    mult_16x16_5 i_mult_16x16_0i
    (
        .CLK(clk_4x),
        .A(48'sh7FFF),
        .B(fir0_data_out[31:16]),
        .P(fir0_mult_out_i_ip)
    ); 

    //Sum
    logic signed [81:0] FTD_out_q ='{default:0};
    logic signed [81:0] FTD_out_i ='{default:0};
    logic signed [81:0] FTD_out_q_test ='{default:0};
    logic signed [81:0] FTD_out_i_test ='{default:0};
    logic       tvalid_delay = 'b0;
    logic [1:0] tuser_delay = 'd0;
    logic [1:0] tuser_delay_pre = 'd0;
    logic       tvalid_delay_pre = 'b0;
    logic [1:0] tuser_delay_pre_d = 'd0;
    logic       tvalid_delay_pre_d = 'b0;
    logic [1:0] tuser_delay_pre_2d = 'd0;
    logic       tvalid_delay_pre_2d = 'b0;
    logic [1:0] tuser_delay_pre_3d = 'd0;
    logic       tvalid_delay_pre_3d = 'b0;
    logic [1:0] tuser_delay_pre_4d = 'd0;
    logic       tvalid_delay_pre_4d = 'b0;
    
    
    always_ff @(posedge clk_4x)  begin
        FTD_out_q <= fir3_mult_out_q_ip + fir2_mult_out_q_ip + fir1_mult_out_q_ip + fir0_mult_out_q_ip;
        FTD_out_i <= fir3_mult_out_i_ip + fir2_mult_out_i_ip + fir1_mult_out_i_ip + fir0_mult_out_i_ip;
        tuser_delay_pre <= IFP_dfe_delay_out_fir0.tuser;
        tvalid_delay_pre <= IFP_dfe_delay_out_fir0.tvalid;
        tuser_delay_pre_d <= tuser_delay_pre;
        tvalid_delay_pre_d <= tvalid_delay_pre;
        tuser_delay_pre_2d <= tuser_delay_pre_d;
        tvalid_delay_pre_2d <= tvalid_delay_pre_d;
        tuser_delay_pre_3d <= tuser_delay_pre_2d;
        tvalid_delay_pre_3d <= tvalid_delay_pre_2d;
        tuser_delay_pre_4d <= tuser_delay_pre_3d;
        tvalid_delay_pre_4d <= tvalid_delay_pre_3d;
        tuser_delay <= tuser_delay_pre_4d;
        tvalid_delay <= tvalid_delay_pre_4d;
        IFP_dfe_delay_out_FTD.tuser  <= tuser_delay;
        IFP_dfe_delay_out_FTD.tvalid <= tvalid_delay; 
    end

    logic signed [32:0] fir32_Add_q;
    logic signed [32:0] fir10_Add_q;
    logic signed [33:0] fir3210_Add_q;
    logic signed [32:0] fir32_Add_i;
    logic signed [32:0] fir10_Add_i;
    logic signed [33:0] fir3210_Add_i;
    
    Add_32_32_33_1 i_Add_32_32_33_1_32q
    ( 
        .CLK(clk_4x),
        .CE(1'b1),
        .A(fir3_mult_out_q_ip),
        .B(fir2_mult_out_q_ip),
        .S(fir32_Add_q)
    );
 
    Add_32_32_33_1 i_Add_32_32_33_1_10q
    ( 
        .CLK(clk_4x),
        .CE(1'b1),
        .A(fir1_mult_out_q_ip),
        .B(fir0_mult_out_q_ip),
        .S(fir10_Add_q)
    );
    
    Add_33_33_34_1 i_Add_33_33_34_1_3210q
    ( 
        .CLK(clk_4x),
        .CE(1'b1),
        .A(fir32_Add_q),
        .B(fir10_Add_q),
        .S(fir3210_Add_q)
    );
    
    Add_32_32_33_1 i_Add_32_32_33_1_32i
    ( 
        .CLK(clk_4x),
        .CE(1'b1),
        .A(fir3_mult_out_i_ip),
        .B(fir2_mult_out_i_ip),
        .S(fir32_Add_i)
    );
 
    Add_32_32_33_1 i_Add_32_32_33_1_10i
    ( 
        .CLK(clk_4x),
        .CE(1'b1),
        .A(fir1_mult_out_i_ip),
        .B(fir0_mult_out_i_ip),
        .S(fir10_Add_i)
    );
    
    Add_33_33_34_1 i_Add_33_33_34_1_3210i
    ( 
        .CLK(clk_4x),
        .CE(1'b1),
        .A(fir32_Add_i),
        .B(fir10_Add_i),
        .S(fir3210_Add_i)
    );
    
    assign IFP_dfe_delay_out_FTD.tdata = {fir3210_Add_q[28:13],fir3210_Add_i[28:13]}; // Add 6db
    
    // For display only
    logic signed [15:0] Out_q = 'd0;
    logic signed [15:0] Out_i = 'd0;
    logic signed [31:0] fir0_data_out_q = 'd0;
    logic signed [31:0] fir0_data_out_i = 'd0;
    logic signed [31:0] fir1_data_out_q = 'd0;
    logic signed [31:0] fir1_data_out_i = 'd0;
    logic signed [31:0] fir2_data_out_q = 'd0;
    logic signed [31:0] fir2_data_out_i = 'd0;
    logic signed [31:0] fir3_data_out_q = 'd0;
    logic signed [31:0] fir3_data_out_i = 'd0;
    logic signed [79:0] fir3_mult_out_q_3 = 'd0;
    logic signed [79:0] fir3_mult_out_i_3 = 'd0;
    logic signed [79:0] fir2_mult_out_q_3 = 'd0;
    logic signed [79:0] fir2_mult_out_i_3 = 'd0;
    logic signed [79:0] fir1_mult_out_q_3 = 'd0;
    logic signed [79:0] fir1_mult_out_i_3 = 'd0;
    logic signed [79:0] fir0_mult_out_q_3 = 'd0;
    logic signed [79:0] fir0_mult_out_i_3 = 'd0;
    
    always@(posedge clk_4x) begin
        if (IFP_dfe_delay_out_FTD.tvalid && IFP_dfe_delay_out_FTD.tuser == 'd3) begin
            Out_q <= IFP_dfe_delay_out_FTD.tdata[31:16];
            Out_i <= IFP_dfe_delay_out_FTD.tdata[15:0];
        end
    end
    
    
    always@(posedge clk_4x) begin
        if (IFP_dfe_delay_out_fir3.tvalid && IFP_dfe_delay_out_fir3.tuser == 'd3) begin
            fir3_data_out_q <= $signed(fir3_data_out[62:32]);
            fir3_data_out_i <= $signed(fir3_data_out[31:0]);
            fir2_data_out_q <= $signed(fir2_data_out[63:32]);
            fir2_data_out_i <= $signed(fir2_data_out[31:0]);
            fir1_data_out_q <= $signed(fir1_data_out[63:32]);
            fir1_data_out_i <= $signed(fir1_data_out[31:0]);
            fir0_data_out_q <= $signed(fir0_data_out[63:32]);
            fir0_data_out_i <= $signed(fir0_data_out[31:0]);
        end
    end
    
    always@(posedge clk_4x) begin
        if (tvalid_delay && tuser_delay == 'd3) begin
            fir3_mult_out_q_3 <= fir3_mult_out_q;
            fir3_mult_out_i_3 <= fir3_mult_out_i;
            fir2_mult_out_q_3 <= fir2_mult_out_q;
            fir2_mult_out_i_3 <= fir2_mult_out_i;
            fir1_mult_out_q_3 <= fir1_mult_out_q;
            fir1_mult_out_i_3 <= fir1_mult_out_i;
            fir0_mult_out_q_3 <= fir0_mult_out_q;
            fir0_mult_out_i_3 <= fir0_mult_out_i;
        end
    end
    
endmodule
