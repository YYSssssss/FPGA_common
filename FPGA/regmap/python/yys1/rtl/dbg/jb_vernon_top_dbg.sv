///////////////////////////////////////////////////////////////////////////////////
////  File Name : jb_logan_top.sv
///// Author    : Shehanaj Begum
///// Date      : 1/04/2019
///// Description  : This module does the nco    
////////////////////////////////////////////////////////////////////////////////////

`timescale 1 ps / 1 ps


module jb_vernon_top_dbg #(
    parameter N_ANTENNAS= 4,
    parameter N_CARRIERS=2,
    parameter DBGBUF_ADDR_WIDTH=32,
    parameter DBGBUF_DATA_WIDTH=64,
    parameter DFE_PRECISION=16,
    parameter PRECISION =16,	
	parameter N_ANTS_SEL = 2
		      
) (
      input                               clk_3x                ,
      input                               clk_1x                ,
      input [N_ANTS_SEL-1:0][N_CARRIERS-1:0] dl_clk_x1en        ,	  
      input [N_ANTS_SEL-1:0][N_CARRIERS-1:0] ul_clk_x1en        ,
	  input                               syn_data_dl_ul_5ms    , 
      input                               resetn_3x             ,
      input                               resetn_1x             ,
      input                               rssi_load             ,
      input                               pa_odp_tssi_le        ,
      input                               ptp_clk               ,
      input                               ptp_align_pulse       ,
      input                               dbgbuf_porta_rst      ,
      input                               dbgbuf_porta_clk      ,
      input [N_CARRIERS-1:0]              dl_dfe_frm_mrkr       ,
	  input 					          IFP_iwavebuf_porta_rst,
      input                               IFP_iwavebuf_porta_clk,
      output logic  [(N_ANTS_SEL*N_ANTENNAS)-1:0][31:0] pa_odp_tssi,
      input        [31:0]                  s_tdata              , 
      input        [1:0]                   s_tuser              , 
      input                                s_tvalid             ,	  
      jb_ram_sp_if.mem                     IFP_iwavebuf_porta   ,    
      jb_test_ctrl_if.test_dbg             IFP_test_ctrl        ,  
      jb_test_ctrl_if.test_stat            IFP_test_stat        , 
      jb_hw_ctrl_if.hw_ctrl                IFP_hw_ctrl          ,	  
      jb_ram_sp_if.mem                     IFP_dbgbuf_porta     ,  	  
      jb_axi4_stream_if.slave              IFP_srx           [N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //incoming
      jb_axi4_stream_if.slave              IFP_adc           [N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //incoming
      jb_axi4_stream_if.slave              IFP_dl_dfe_out    [N_ANTS_SEL-1:0][N_ANTENNAS-1:0],	  
      jb_axi4_stream_if.slave              IFP_ul_dfe_out    [N_ANTS_SEL-1:0][N_CARRIERS-1:0],  
      jb_axi4_stream_if.slave              IFP_fh_dl         [N_ANTS_SEL-1:0][N_CARRIERS-1:0],
      jb_axi4_stream_if.master             IFP_dac           [N_ANTS_SEL-1:0][N_ANTENNAS-1:0], //drive         
      jb_axi4_stream_if.master             IFP_ul_dfe_in     [N_ANTS_SEL-1:0][N_ANTENNAS-1:0],     
      jb_axi4_stream_if.master             IFP_dl_dfe_in     [N_ANTS_SEL-1:0][N_CARRIERS-1:0],
      jb_axi4_stream_if.master             IFP_fh_ul         [N_ANTS_SEL-1:0][N_CARRIERS-1:0]
);

`include  "jb_common.svh"

localparam USER_ID_BW = 2;

jb_ram_sp_if #(.DATA_WIDTH(DBGBUF_DATA_WIDTH), .ADDR_WIDTH(DBGBUF_ADDR_WIDTH)) IFP_dbgbuf_portb();

jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(2))  IFP_dl_dfe_in_from_rfbuf      [N_ANTS_SEL-1:0][N_CARRIERS-1:0]();
jb_axi4_stream_if  #(.DATA_WIDTH(2*PRECISION), .USER_SB_WIDTH(2))  IFP_fh_ul_test_data_from_fhbuf[N_ANTS_SEL-1:0]()          ;
jb_axi4_stream_if  #(.DATA_WIDTH(2*32),        .USER_SB_WIDTH(1))  IFP_adc_hb_dout1              [N_ANTS_SEL-1:0][N_ANTENNAS-1:0]();
jb_axi4_stream_if  #(.DATA_WIDTH(2*32),        .USER_SB_WIDTH(1))  IFP_adc_hb_dout2              [N_ANTS_SEL-1:0][N_ANTENNAS-1:0]();
jb_axi4_stream_if  #(.DATA_WIDTH(2*16),        .USER_SB_WIDTH(1))  IFP_adc_iq                    [N_ANTS_SEL-1:0][N_ANTENNAS-1:0]();
jb_axi4_stream_if  #(.DATA_WIDTH(64),          .USER_SB_WIDTH(1))  IFP_dl_2_ul                   [1:0] [3:0](); //dac interface
	      
   logic                       dbgbuf_portb_rst ;
   logic                       dbgbuf_rsta_busy ;
   logic                       dbgbuf_rstb_busy ;
   logic                       s_first_cycle_acc;
   logic [63:0] 		       s_rd_data        ;
   
   assign dbgbuf_portb_rst = ~resetn_3x;

    localparam MAX_NUM_SAMPLES=32744;//15 bits
   
logic signed [32:0] s_adc_data491_i [N_ANTS_SEL-1:0] [N_ANTENNAS-1:0];
logic signed [32:0] s_adc_data491_q [N_ANTS_SEL-1:0] [N_ANTENNAS-1:0];
logic signed [16:0] s_rnd_data491_i [N_ANTS_SEL-1:0] [N_ANTENNAS-1:0];
logic signed [16:0] s_rnd_data491_q [N_ANTS_SEL-1:0] [N_ANTENNAS-1:0];
logic signed [15:0] s_satu_data491_i[N_ANTS_SEL-1:0] [N_ANTENNAS-1:0];
logic signed [15:0] s_satu_data491_q[N_ANTS_SEL-1:0] [N_ANTENNAS-1:0];   

//decimation from 983 to 491	
genvar band,ant;

generate
for (band = 0; band <  1; band = band + 1)begin
  for (ant = 0; ant <  4; ant = ant + 1) begin 
//    assign IFP_dl_2_ul[band][ant].tdata = {IFP_dl_dfe_out[band][ant].tdata[31],IFP_dl_dfe_out[band][ant].tdata[31:17],IFP_dl_dfe_out[band][ant].tdata[15],IFP_dl_dfe_out[band][ant].tdata[15:1]} ;
    assign IFP_dl_2_ul[band][ant].tdata  = IFP_dl_dfe_out[band][ant].tdata  ;
    assign IFP_dl_2_ul[band][ant].tuser  = IFP_dl_dfe_out[band][ant].tuser  ;
    assign IFP_dl_2_ul[band][ant].tvalid = IFP_dl_dfe_out[band][ant].tvalid ;
  end
end
endgenerate



generate
for (band = 0; band <  2; band = band + 1)begin
  for (ant = 0; ant <  4; ant = ant + 1) begin 
	
    //Q1I1Q0I0   
    hb_983to491_even hb_983to491_even_inst0 (
      .aresetn            (1'b1                              ),   // input wire aresetn
      .aclk               (clk_3x                            ),   // input wire aclk
      .aclken             (1'b1                              ),   // input wire aclken
      .s_axis_data_tvalid (IFP_adc[band][ant].tvalid         ),   // input wire s_axis_data_tvalid
//      .s_axis_data_tvalid (IFP_dl_2_ul[band][ant].tvalid         ),   // input wire s_axis_data_tvalid
      .s_axis_data_tready (                                  ),   // output wire s_axis_data_tready
      .s_axis_data_tdata  (IFP_adc[band][ant].tdata[31:0]    ),   // input wire [47 : 0] s_axis_data_tdata
//      .s_axis_data_tdata  (IFP_dl_2_ul[band][ant].tdata[31:0]    ),   // input wire [47 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (IFP_adc_hb_dout1[band][ant].tvalid),   // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (IFP_adc_hb_dout1[band][ant].tdata )    // output wire [63 : 0] m_axis_data_tdata
    ); 
    
    hb_983to491_odd hb_983to491_odd_inst0 (
      .aresetn            (1'b1                              ),   // input wire aresetn
      .aclk               (clk_3x                            ),   // input wire aclk
      .aclken             (1'b1                              ),   // input wire aclken
      .s_axis_data_tvalid (IFP_adc[band][ant].tvalid         ),   // input wire s_axis_data_tvalid
//      .s_axis_data_tvalid (IFP_dl_2_ul[band][ant].tvalid         ),   // input wire s_axis_data_tvalid
      .s_axis_data_tready (                                  ),   // output wire s_axis_data_tready
      .s_axis_data_tdata  (IFP_adc[band][ant].tdata[63:32]   ),   // input wire [47 : 0] s_axis_data_tdata
//      .s_axis_data_tdata  (IFP_dl_2_ul[band][ant].tdata[63:32]   ),   // input wire [47 : 0] s_axis_data_tdata
      .m_axis_data_tvalid (                                  ),   // output wire m_axis_data_tvalid
      .m_axis_data_tdata  (IFP_adc_hb_dout2[band][ant].tdata )    // output wire [63 : 0] m_axis_data_tdata
    ); 
    
    

    assign s_adc_data491_i[band][ant] = {IFP_adc_hb_dout1[band][ant].tdata[31],IFP_adc_hb_dout1[band][ant].tdata[31:0]} + {IFP_adc_hb_dout2[band][ant].tdata[31],IFP_adc_hb_dout2[band][ant].tdata[31:0]};
    assign s_adc_data491_q[band][ant] = {IFP_adc_hb_dout1[band][ant].tdata[63],IFP_adc_hb_dout1[band][ant].tdata[63:32]} + {IFP_adc_hb_dout2[band][ant].tdata[63],IFP_adc_hb_dout2[band][ant].tdata[63:32]};
    

 
data_rnd_satu
    #( .DIN_WIDTH  (33),
	   .FRAC_WIDTH (15),
       .DOUT_WIDTH (16))
    data_rnd_satu_491_i
    ( 
    .i_rst       (1'b0                       ),
    .i_clk       (clk_3x                     ),   
    .i_data      (s_adc_data491_i[band][ant] ),    
    .o_data      (s_satu_data491_i[band][ant])
    );  

 

data_rnd_satu
    #( .DIN_WIDTH  (33),
	   .FRAC_WIDTH (15),
       .DOUT_WIDTH (16))
    data_rnd_satu_491_q
    ( 
    .i_rst       (1'b0                       ),
    .i_clk       (clk_3x                     ),   
    .i_data      (s_adc_data491_q[band][ant] ),    
    .o_data      (s_satu_data491_q[band][ant])
    );  
    
    
    assign IFP_adc_iq[band][ant].tdata  = {s_satu_data491_q[band][ant],s_satu_data491_i[band][ant]};
    assign IFP_adc_iq[band][ant].tvalid = 1'b1;	
    end
end	
endgenerate

jb_rfbuf #(
    .N_ANTS_SEL       (N_ANTS_SEL       ),
    .N_ANTENNAS       (N_ANTENNAS       ),
    .N_CARRIERS       (N_CARRIERS       ),	
    .DFE_PRECISION    (DFE_PRECISION    ),
    .DBGBUF_ADDR_WIDTH(DBGBUF_ADDR_WIDTH),
    .DBGBUF_DATA_WIDTH(DBGBUF_DATA_WIDTH)	
) u_jb_rfbuf(
      .clk_3x                 (clk_3x           ),
      .clk_1x                 (clk_1x           ),
      .resetn_3x              (resetn_3x        ),
      .resetn_1x              (resetn_1x        ),
      .dl_clk_x1en            (dl_clk_x1en      ),	
      .ul_clk_x1en            (ul_clk_x1en      ),	
	  .syn_data_dl_ul_5ms     (syn_data_dl_ul_5ms),  
      .ptp_clk                (ptp_clk          ),
      .ptp_align_pulse        (ptp_align_pulse  ),
      .dbgbuf_porta_rst       (dbgbuf_porta_rst ),
      .dbgbuf_porta_clk       (dbgbuf_porta_clk ),
      .rssi_load              (rssi_load        ),
      .pa_odp_tssi_le         (pa_odp_tssi_le   ),  
      .pa_odp_tssi            (pa_odp_tssi      ),
	  .IFP_hw_ctrl            (IFP_hw_ctrl      ),
      .IFP_dbgbuf_porta       (IFP_dbgbuf_porta ),  
      .IFP_test_ctrl          (IFP_test_ctrl    ),     
      .IFP_test_stat          (IFP_test_stat    ),            // jb_test_ctrl_if.stat
      .IFP_srx                (IFP_srx                     ), //incoming
      .IFP_adc                (IFP_adc                     ), //incoming   
      .IFP_adc_iq             (IFP_adc_iq                  ), //incoming   
      .IFP_dac                (IFP_dac                     ), //drive         
      .IFP_fh_dl              (IFP_fh_dl                   ),
      .IFP_fh_ul              (IFP_fh_ul                   ),
      .IFP_fh_ul_test_data    (IFP_fh_ul_test_data_from_fhbuf),      
      .IFP_ul_dfe_in          (IFP_ul_dfe_in               ),     
      .IFP_dl_dfe_in          (IFP_dl_dfe_in_from_rfbuf    ),
      .IFP_ul_dfe_out         (IFP_ul_dfe_out              ),  
      .IFP_dl_dfe_out         (IFP_dl_dfe_out              )  		          				  				    

);


  jb_fhbuf #(
      .N_ANTS_SEL       (N_ANTS_SEL       ), 
      .N_CARRIERS       (N_CARRIERS       ),	  
      .N_ANTENNAS       (N_ANTENNAS       ),
      .MAX_NUM_SAMPLES  (MAX_NUM_SAMPLES  ),
      .PRECISION        (PRECISION        )
   ) u_jb_fhbuf (
      .clk_x1en               ((|dl_clk_x1en[0])|(|dl_clk_x1en[1])), // 5/15/21 - This is temporary. We need to find a better solution.
	  .dl_clk_x1en            (dl_clk_x1en            ),
      .clk_1x                 (clk_1x                 ),
      .resetn                 (resetn_1x              ),
	  .s_tdata                (s_tdata                ),
	  .s_tuser                (s_tuser                ),
	  .s_tvalid               (s_tvalid               ),
	  .IFP_iwavebuf_porta_rst (IFP_iwavebuf_porta_rst ),
	  .IFP_iwavebuf_porta_clk (IFP_iwavebuf_porta_clk ),
	  .IFP_iwavebuf_porta     (IFP_iwavebuf_porta     ),
      .dl_dfe_frm_mrkr        (dl_dfe_frm_mrkr[0]     ),
	  .IFP_test_ctrl          (IFP_test_ctrl          ),
      .IFP_dl_pre_dfe_out     (IFP_dl_dfe_in          ),
      .IFP_dl_dfe_in          (IFP_dl_dfe_in_from_rfbuf   ),
	  .IFP_test_data          (IFP_fh_ul_test_data_from_fhbuf)
	  	  
    );





 
	 
endmodule
	     
