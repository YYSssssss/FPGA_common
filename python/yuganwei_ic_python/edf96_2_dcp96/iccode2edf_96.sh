#!/bin/bash

remote_user="yuyushan"
remote_host="10.0.0.103"

#path
gen_synplify_edf_path="/data/yuyushan_97/gen_synplify_edf_96"
rsp_s1_top_filelist_fpga="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1_top/"
rsp_s1_filelist_fpga="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/"
rsp_s2_filelist_fpga="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s2/"
axi2ahb_async_filelist_fpga="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/cores/axi2ahb_async/"
rsp_transpose="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_transpose/"
rsp_top="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_top/"
rpss_top="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rpss_top/"
mipi_radar="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/cores/mipi_radar/"

file_list=$rsp_s1_top_filelist_fpga

echo "$file_list"







input_synplify_folder_path="/data/yuyushan_97/gen_synplify_edf_96/"

sub="/prj/chips/pvg/venus/yuyedf96_2_dcp96.shushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/sub"
vobs="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs"

#git pull
ssh $remote_user@$remote_host "bash /home/users/yuyushan/yuyushan_97/python/edf96_2_dcp96/git_pull_103.sh"

# 本地 Python 脚本信息
gen_synplify_project="/data/yuyushan_97/python/edf96_2_dcp96/gen_synplify_project.py"

#使用python生成路径
# python3 $gen_synplify_project $file_list $input_synplify_folder_path
python3 $gen_synplify_project $file_list $input_synplify_folder_path > /data/yuyushan_97/python/edf96_2_dcp96/gen_syn_prj_path_96.txt


# 读取文件中的目录路径
directory_path=$(cat /data/yuyushan_97/python/edf96_2_dcp96/gen_syn_prj_path_96.txt)

# # 切换到目录
cd "$directory_path" || exit 1

# pwd

sleep 5s

# pwd

synplify_premier -batch *.prj &&  echo 'successfully' || echo 'failed'

sleep 5s



