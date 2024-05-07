#!/bin/bash

# source 

#path
gen_synplify_edf_path="/home/users/yuyushan/yuyushan_97/gen_synplify_edf_103/"


rsp_s1_top_filelist_fpga="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1_top/"
rsp_s1_filelist_fpga="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/"
rsp_transpose="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_transpose/"
rsp_s3="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s3/"
rsp_top="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_top/"

file_list=$rsp_s1_top_filelist_fpga








sub="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/sub"
vobs="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs"
input_synplify_folder_path="/home/users/yuyushan/yuyushan_97/gen_synplify_edf_103/"

cd $vobs
git pull
cd $sub
git pull

# 本地 Python 脚本信息
gen_synplify_project="/home/users/yuyushan/yuyushan_97/python/edf103_2_dcp97/gen_synplify_project.py"

#使用python生成路径
python3 $gen_synplify_project $file_list $input_synplify_folder_path > /home/users/yuyushan/yuyushan_97/python/edf103_2_dcp97/gen_syn_prj_path.txt


# 读取文件中的目录路径
directory_path=$(cat /home/users/yuyushan/yuyushan_97/python/edf103_2_dcp97/gen_syn_prj_path.txt)
echo $directory_path

# 切换到目录
cd "$directory_path" || exit 1

########################synplify_pro *.prj &

sleep 5s

pwd

synplify_pro -batch *.prj &&  echo 'successfully' || echo 'failed'

sleep 5s