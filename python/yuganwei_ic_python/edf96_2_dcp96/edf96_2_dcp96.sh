#!/bin/bash

# cd /data/yuyushan_97/python || exit 1

bash /data/yuyushan_97/python/edf96_2_dcp96/iccode2edf_96.sh

# 读取文件中的目录路径 
directory_path=$(cat /data/yuyushan_97/python/edf96_2_dcp96/gen_syn_prj_path_96.txt)
last_part=$(basename "$directory_path")
second_last_part=$(dirname "$directory_path" | xargs basename)


#used for test edf_dir_path="/data/yuyushan_97/gen_synplify_edf_96/syn_rsp_s1_20240119_104819"
edf_dir_path="/data/yuyushan_97/$second_last_part/$last_part"
# echo "$edf_dir_path/rev1"

python3 /data/yuyushan_97/python/edf96_2_dcp96/gen_link_design_tcl.py $edf_dir_path/rev_1

cd /data/yuyushan_97/link_synplify_vivado/ || exit 1

sleep 3s

pwd

vivado -mode tcl -source *.tcl

sleep 5s

rm -rf *.tcl
rm -rf vivado.jou
rm -rf vivado.log
