/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_common/header/rsp_s1_op_info.svh
/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_common/header/rsp_common_defines.vh
/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/rsp_s1_prep_defines.vh

+incdir+${vobs}/cores/amba_if/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/cores/amba_if/src/ahb2fifo.v
+incdir+${vobs}/cores/amba_if/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/cores/amba_if/src/axi_v4_wr_if.sv
+incdir+${vobs}/cores/amba_if/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/cores/amba_if/src/ahb_if_cfg.sv
+incdir+${vobs}/cores/amba_if/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/cores/amba_if/src/axi_v4_rd_if.sv
+incdir+${vobs}/cores/amba_if/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/cores/amba_if/src/axi_v4_if.sv
-sverilog +define+ASIC ${vobs}/cores/cdc_demet/src/cdc_demet_ares.sv
-sverilog +define+ASIC ${vobs}/cores/cdc_demet/src/pulse_sync.sv
-sverilog +define+ASIC ${vobs}/cores/cdc_demet/src/cdc_demet_aset_m.sv
-sverilog +define+ASIC ${vobs}/cores/cdc_demet/src/cdc_demet_aset.sv
-sverilog +define+ASIC ${vobs}/cores/cdc_demet/src/cdc_demet_ares_m.sv
+incdir+/home/tools/synopsys/syn/R-2020.09-SP4/dw/sim_ver +define+ASIC /home/tools/synopsys/syn/R-2020.09-SP4/dw/sim_ver/DW02_mult_6_stage.v
+incdir+/home/tools/synopsys/syn/R-2020.09-SP4/dw/sim_ver +define+ASIC /home/tools/synopsys/syn/R-2020.09-SP4/dw/sim_ver/DW02_mult_3_stage.v
+incdir+/home/tools/synopsys/syn/R-2020.09-SP4/dw/sim_ver +define+ASIC /home/tools/synopsys/syn/R-2020.09-SP4/dw/sim_ver/DW02_mult_5_stage.v
+define+ASIC ${vobs}/cores/dsp_lib/src/data_delay.v
+define+ASIC ${vobs}/cores/dsp_lib/src/mult.v
+define+ASIC ${vobs}/cores/dsp_lib/src/adder.v
+define+ASIC ${vobs}/cores/dsp_lib/src/data_delay_ce.v
# +define+ASIC ${vobs}/cores/dsp_lib/src/delay.v
+define+ASIC ${vobs}/cores/dsp_lib/src/handshake_pipe_forward.v
+define+ASIC ${vobs}/cores/dsp_lib/src/complex_multiplier_3mult.v
+define+ASIC ${vobs}/cores/dsp_lib/src/tcbn28hpcplusbwp35p140hvt.v
+define+ASIC ${vobs}/cores/dsp_lib/src/delay_ce.v
+define+ASIC ${vobs}/cores/dsp_lib/src/handshake_pipe_backward.v
+define+ASIC ${vobs}/cores/dsp_lib/src/interpolation.sv
+define+ASIC ${vobs}/cores/dsp_lib/src/rsp_s1_op_fsm.sv
+define+ASIC ${vobs}/cores/dsp_lib/src/demux.sv
+define+ASIC ${vobs}/cores/dsp_lib/src/log2.sv
+define+ASIC ${vobs}/cores/dsp_lib/src/abs.sv
+define+ASIC ${vobs}/cores/dsp_lib/src/data_select_2d.sv
+define+ASIC ${vobs}/cores/dsp_lib/src/frac_divider.sv
+define+ASIC ${vobs}/cores/dsp_lib/src/mux.sv
-sverilog +define+ASIC ${vobs}/cores/fifos/src/fifo_fwft_small.v
-sverilog +define+ASIC ${vobs}/cores/fifos/src/fifo_standard_small.v
-sverilog +define+ASIC ${vobs}/cores/fifos/src/fifo_fwft_with_update.v
-sverilog +define+ASIC ${vobs}/cores/fifos/src/fifo_fwft_large.v
-sverilog +define+ASIC ${vobs}/cores/fifos/src/fifo_standard_large.v
-sverilog +define+ASIC ${vobs}/cores/fifos/src/fifo_fwft.v
-sverilog +define+ASIC ${vobs}/cores/fifos/src/fifo_standard.v
-sverilog +define+ASIC ${vobs}/cores/fifos/src/reg_sfifo.sv
-sverilog +define+ASIC ${vobs}/cores/fifos/src/afifo_ctrl.sv
-sverilog +define+ASIC ${vobs}/cores/fifos/src/reg_afifo.sv
-sverilog +define+ASIC ${vobs}/cores/fifos/src/sfifo_ctrl.sv
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/radix2_3mul.v
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/radix2_opt.v
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/rsp_irq.v
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/rsp_s2_op_fsm.sv
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/radix2_shared_tw.sv
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/pipelined_radix2_shared_tw.sv
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/radix2_shared_tw_ce.sv
+define+ASIC ${vobs}/ip/rsp/design/rsp_common/rsp_dsp_lib/src/rsp_s3_op_fsm.sv
+incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_cc_constants.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_constants.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm_params.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm02.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_sfsm.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_sbiu.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_begen.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_dreg.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_mfsm.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_mbiu.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_core.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm21.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_bcm99.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h_sync.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h.v
 +incdir+${vobs}/cores/ahb2ahb_async/src +define+ASIC ${vobs}/cores/ahb2ahb_async/src/ahb2ahb_async_DW_ahb_h2h-undef.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../ahb_ic/src/rsp_s1_prep_ahbic_out.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../ahb_ic/src/rsp_s1_prep_ahbic_default_slave.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../ahb_ic/src/rsp_s1_prep_ahbic_lite.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../ahb_ic/src/rsp_s1_prep_ahbic_arb.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../ahb_ic/src/rsp_s1_prep_ahbic_decS0.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../ahb_ic/src/rsp_s1_prep_ahbic.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../ahb_ic/src/rsp_s1_prep_ahbic_in.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../reg/rsp_s1_prep_csr_reg.v
+incdir+${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src +incdir+${vobs}/ip/rsp/design/rsp_common/header/ +define+ASIC ${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src/../reg/rsp_s1_prep_glb_reg.v



../src1/rsp_s1_prep_ahb_mux.v
../src1/rsp_s1_prep_mult.v
../src1/rsp_s1_prep_fifo.v
../src1/rsp_s1_prep_estimation.sv
../src1/rsp_s1_prep_pg_select_ram_data.sv
../src1/rsp_s1_prep_abs_cmp.sv
../src1/rsp_s1_prep_combination.sv
../src1/rsp_s1_prep_delay_data.sv
../src1/rsp_s1_prep_read_ram.sv
../src1/rsp_s1_prep_core.sv
../src1/rsp_s1_prep_diff.sv
../src1/rsp_s1_prep_multiplier0.sv
../src1/rsp_s1_prep_top.sv
../src1/rsp_s1_prep_abs_real.sv
../src1/rsp_s1_prep_write_ram.sv
../src1/rsp_s1_prep_phase_generation.sv
../src1/rsp_s1_prep_abs_complex.sv
../src1/rsp_s1_prep_add_u.sv
../src1/rsp_s1_prep.sv



../tb1/spram.v
../tb1/tpram.v
../tb1/spram_136x64.v
../tb1/delay.v
../tb1/common_tb.sv
../tb1/save_file_tb.sv
../tb1/rd_txt_data_tb.sv
