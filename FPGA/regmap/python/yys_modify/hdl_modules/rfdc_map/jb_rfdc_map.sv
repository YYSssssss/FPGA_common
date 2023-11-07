`timescale 1 ps / 1 ps

module jb_rfdc_map #(
    parameter   N_ANTENNAS              = 4,
    parameter   N_ADC                   = 8,
    parameter   N_DAC                   = 8
) (
    input                               axis_clk,
    input                               axis_aresetn,
    input                               axil_clk,
    input                               axil_aresetn,

    jb_hw_ctrl_if.hw_ctrl_rfdc          IFP_ctrl,

    jb_axi4_stream_if.slave             IFP_adc         [N_ADC-1:0],
    jb_axi4_stream_if.master            IFP_dac         [N_DAC-1:0],

    jb_axi4_stream_if.master            IFP_dfe_ul      [N_ANTENNAS-1:0],
    jb_axi4_stream_if.slave             IFP_dfe_dl      [N_ANTENNAS-1:0],

    jb_axi4_stream_if.master            IFP_orx         [N_ANTENNAS-1:0]
);

    // ------------------------------------------------------------------ //
    // Parameters:                                                        //
    // ------------------------------------------------------------------ //
    localparam  USER_ID_BW = $clog2(N_ANTENNAS); // $clog2(N_ADC);

    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //
    genvar i;
    jb_axi4_stream_if  #(.DATA_WIDTH(32), .USER_SB_WIDTH(USER_ID_BW)) IFP_adc_copy      [N_ADC-1:0]();
    jb_axi4_stream_if  #(.DATA_WIDTH(64), .USER_SB_WIDTH(USER_ID_BW)) IFP_dfe_dl_copy   [N_ANTENNAS-1:0]();

    // ------------------------------------------------------------------ //
    //                                                                    //
    // ------------------------------------------------------------------ //

    // tready (DFE --> ADC)
    generate
    for (i=0; i<=N_ADC-1; i=i+1)
    begin : gen_adc_tready
        assign IFP_adc[i].tready   = 1'b1;
        // Following assignments to avoid multi-dreven net with tready
        assign IFP_adc_copy[i].tdata  = IFP_adc[i].tdata;
        assign IFP_adc_copy[i].tvalid = IFP_adc[i].tvalid;
    end
    endgenerate

    // tready (DAC --> DFE)
    generate
    for (i=0; i<=N_ANTENNAS-1; i=i+1)
    begin : gen_dfe_tready
        //assign IFP_dfe_dl[i].tready   = 1'b1;
        // For now, tie [i] to [i]. This needs to be updated for fully flexible
        // DAC mapping. The issue is that one DFE can be assigned to multiple DACs.
        // So, which DAC's tready is to be used?
        assign IFP_dfe_dl[i].tready   = IFP_dac[i].tready;
        // Following assignments to avoid multi-dreven net with tready
        assign IFP_dfe_dl_copy[i].tdata = IFP_dfe_dl[i].tdata;
        assign IFP_dfe_dl_copy[i].tvalid = IFP_dfe_dl[i].tvalid;
    end
    endgenerate


    // ------------------------------------------------------------------ //
    // ORX ADC Map                                                        //
    // ------------------------------------------------------------------ //
    generate
    for (i=0; i<=N_ANTENNAS-1; i=i+1)
    begin : gen_orx_adc_map
        jb_adc_mux #(
            .N_ADC                  (N_ADC)
        ) jb_orx_adc_mux_u (
            .axis_clk               (axis_clk),             // i
            .axis_aresetn           (axis_aresetn),         // i
            .adc_sel                (IFP_ctrl.ul_dfe_orx_adc_sel[i]), // i [2:0]
            .IFP_adc                (IFP_adc_copy),         // jb_axi4_stream_if.slave [N_ADC-1:0]
            .IFP_dfe                (IFP_orx[i])            // jb_axi4_stream_if.master
        );
    end
    endgenerate

    // ------------------------------------------------------------------ //
    // RX ADC Map                                                         //
    // ------------------------------------------------------------------ //
    generate
    for (i=0; i<=N_ANTENNAS-1; i=i+1)
    begin : gen_rx_adc_map
        jb_adc_mux #(
            .N_ADC                  (N_ADC)
        ) jb_rx_adc_mux_u (
            .axis_clk               (axis_clk),             // i
            .axis_aresetn           (axis_aresetn),         // i
            .adc_sel                (IFP_ctrl.ul_dfe_rx_adc_sel[i]), // i [2:0]
            .IFP_adc                (IFP_adc_copy),         // jb_axi4_stream_if.slave [N_ADC-1:0]
            .IFP_dfe                (IFP_dfe_ul[i])         // jb_axi4_stream_if.master
        );
    end
    endgenerate

    // ------------------------------------------------------------------ //
    // TX DAC Map                                                         //
    // ------------------------------------------------------------------ //

    generate
    for (i=0; i<=N_ANTENNAS-1; i=i+1)
    begin : gen_tx_dac_map
        jb_dac_mux #(
            .N_ANTENNAS             (N_ANTENNAS)
        ) jb_tx_dac_mux_u (
            .axis_clk               (axis_clk),             // i
            .axis_aresetn           (axis_aresetn),         // i
            .dfe_sel                (IFP_ctrl.dac_dl_dfe_sel[i]), // i [1:0]
            .IFP_dfe                (IFP_dfe_dl_copy),     // jb_axi4_stream_if.slave [N_ANTENNAS-1:0]
            .IFP_dac                (IFP_dac[i])            // jb_axi4_stream_if.master
        );
    end
    endgenerate


endmodule
