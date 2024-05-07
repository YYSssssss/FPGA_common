debImport "-f" "tb.f" \
          "+incdir+/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_common/header" \
          "+incdir+/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/sub/rsp_s1_prep/src" \
          "-sverilog"
debLoadSimResult \
           /home/users/yuyushan/work/rsp_s1_prep/rsp_s1_prep_sim/sim/tb_common_wave.fsdb
wvCreateWindow
wvRestoreSignal -win $_nWave2 "signal.rc" -overWriteAutoAlias on -appendSignals \
           on
srcHBSelect "commmon_tb" -win $_nTrace1
srcSetScope -win $_nTrace1 "commmon_tb" -delim "."
srcHBSelect "commmon_tb" -win $_nTrace1
srcHBSelect "commmon_tb.u_rsp_s1_prep" -win $_nTrace1
srcHBSelect "commmon_tb.u_rsp_s1_prep" -win $_nTrace1
srcHBSelect "commmon_tb.u_rsp_s1_prep" -win $_nTrace1
srcSetScope -win $_nTrace1 "commmon_tb.u_rsp_s1_prep" -delim "."
srcHBSelect "commmon_tb.u_rsp_s1_prep" -win $_nTrace1
srcHBSelect "commmon_tb.u_rsp_s1_prep.u_rsp_s1_prep_core" -win $_nTrace1
srcSetScope -win $_nTrace1 "commmon_tb.u_rsp_s1_prep.u_rsp_s1_prep_core" -delim \
           "."
srcHBSelect "commmon_tb.u_rsp_s1_prep.u_rsp_s1_prep_core" -win $_nTrace1
srcHBSelect "commmon_tb.u_rsp_s1_prep.u_rsp_s1_prep_core.u_rsp_s1_prep_top" -win \
           $_nTrace1
srcSetScope -win $_nTrace1 \
           "commmon_tb.u_rsp_s1_prep.u_rsp_s1_prep_core.u_rsp_s1_prep_top" \
           -delim "."
srcHBSelect "commmon_tb.u_rsp_s1_prep.u_rsp_s1_prep_core.u_rsp_s1_prep_top" -win \
           $_nTrace1
wvSelectGroup -win $_nWave2 {G2}
wvSelectGroup -win $_nWave2 {G2}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1/ahb_cfg(slave)" 27)}
wvSelectGroup -win $_nWave2 {G3}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1/ahb_cfg(slave)" 27)}
wvSetPosition -win $_nWave2 {("G1/ahb_cfg(slave)" 27)}
wvSelectGroup -win $_nWave2 {G2}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvMoveSelected -win $_nWave2
wvSelectGroup -win $_nWave2 {G2}
wvSelectGroup -win $_nWave2 {G1}
wvSelectGroup -win $_nWave2 {G2}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcSelect -signal "o_w" -line 596 -pos 2 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
srcDeselectAll -win $_nTrace1
srcSelect -signal "s_comb_data\[i\]" -line 634 -pos 1 -win $_nTrace1
srcAddSelectedToWave -clipboard -win $_nTrace1
wvDrop -win $_nWave2
wvSetCursor -win $_nWave2 14599.798849 -snap {("G2" 2)}
wvSetCursor -win $_nWave2 14607.685019 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14599.526912 -snap {("G2" 2)}
srcHBSelect \
           "commmon_tb.u_rsp_s1_prep.u_rsp_s1_prep_core.u_rsp_s1_prep_top.u_combination" \
           -win $_nTrace1
wvSetCursor -win $_nWave2 14600.342722 -snap {("G2" 1)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvSetCursor -win $_nWave2 14601.430470 -snap {("G2" 2)}
wvZoomOut -win $_nWave2
wvSelectGroup -win $_nWave2 {G1}
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvScrollDown -win $_nWave2 1
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvScrollUp -win $_nWave2 20
wvSelectGroup -win $_nWave2 {G1}
wvSetCursor -win $_nWave2 14599.254975 -snap {("G2" 2)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSetPosition -win $_nWave2 {("G2" 1)}
wvExpandBus -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 6)}
wvSelectGroup -win $_nWave2 {G2}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectGroup -win $_nWave2 {G2}
wvSetCursor -win $_nWave2 14510.875482 -snap {("G2" 6)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomIn -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoom -win $_nWave2 14219.036723 16172.631426
srcDeselectAll -win $_nTrace1
srcSelect -signal "clk" -line 631 -pos 2 -win $_nTrace1
wvSetPosition -win $_nWave2 {("G1/ahb_cfg(slave)" 27)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvAddSignal -win $_nWave2 \
           "/commmon_tb/u_rsp_s1_prep/u_rsp_s1_prep_core/u_rsp_s1_prep_top/clk"
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSetPosition -win $_nWave2 {("G2" 1)}
wvZoom -win $_nWave2 14433.386863 15141.306407
wvSetCursor -win $_nWave2 14979.486492 -snap {("G2" 3)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 14525.709383 -snap {("G2" 7)}
wvZoom -win $_nWave2 13849.813149 17131.180350
wvZoom -win $_nWave2 14298.277194 15659.460316
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomIn -win $_nWave2
wvZoom -win $_nWave2 12086.190860 15932.614003
wvZoom -win $_nWave2 13703.983847 14777.576447
wvZoom -win $_nWave2 14330.160089 14630.332034
wvSetCursor -win $_nWave2 14511.014408 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14504.658505 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14492.957866 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14480.390514 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14474.467968 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14468.978779 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14462.478425 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14456.700331 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14450.344429 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14444.855240 -snap {("G2" 1)}
wvSetCursor -win $_nWave2 14438.788242 -snap {("G2" 1)}
wvSetMarker -win $_nWave2 14439.000000
wvSetCursor -win $_nWave2 14362.806316 -snap {("G2" 2)}
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSetCursor -win $_nWave2 15361.061971 -snap {("G2" 4)}
wvZoom -win $_nWave2 14039.034235 14843.344816
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
debReload
wvSetCursor -win $_nWave2 14436.544806 -snap {("G2" 4)}
wvSetMarker -win $_nWave2 15321.000000
wvSetCursor -win $_nWave2 14512.408557 -snap {("G2" 6)}
wvDisplayGridCount -win $_nWave2 -off
wvGetSignalClose -win $_nWave2
wvReloadFile -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectGroup -win $_nWave2 {G2}
wvSelectGroup -win $_nWave2 {G2}
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectGroup -win $_nWave2 {G2}
srcHBSelect "commmon_tb.u_rsp_s1_prep.u_ahb2ahb_async_DW_ahb_h2h_entry" -win \
           $_nTrace1
wvSelectSignal -win $_nWave2 {( "G2" 1 )} 
wvSelectSignal -win $_nWave2 {( "G2" 1 2 3 4 5 6 7 )} 
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectGroup -win $_nWave2 {G3}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G2" 0)}
wvSelectGroup -win $_nWave2 {G2}
wvCut -win $_nWave2
wvSetPosition -win $_nWave2 {("G1/ahb_cfg(slave)" 27)}
wvSetPosition -win $_nWave2 {("G1/ahb_cfg(slave)" 27)}
wvSelectGroup -win $_nWave2 {G2}
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
srcDeselectAll -win $_nTrace1
debExit
