read_file -type sourcelist ../../../rsp_s1_dma_filelist
#read_file -type sgdc cn/rsp_s1_dma.sgdc
set_option top rsp_s1_dma_rd
set_option enableSV yes
current_goal lint/lint_rtl -top rsp_s1_dma_rd
run_goal
current_goal lint/lint_rtl -top rsp_s1_dma_rd                          

