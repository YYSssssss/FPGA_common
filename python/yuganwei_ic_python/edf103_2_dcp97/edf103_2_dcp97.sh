#!/bin/bash

# 远程服务器信息
remote_user="yuyushan"
remote_host="10.0.0.103"
#remote_script_path="/path/to/your/python_script.py"

#path
#gen_synplify_edf_path="/home/users/yuyushan/yuyushan_97/gen_synplify_edf"
#rsp_s1_filelist_fpga="/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_s1/"

# 本地 Python 脚本信息
#gen_synplify_project="/home/users/yuyushan/yuyushan_97/python/gen_synplify_project.py"

# 本地执行的 synplify 命令（如果需要传递参数，可以在这里添加）

#local_command2="synplify_pro -batch /home/users/yuyushan/yuyushan_97/gen_synplify_edf/synplify_axi2ahb_async/syn_axi2ahb.prj"



# 使用 ssh 连接到远程服务器，并在远程服务器上执行 Python 脚本
#ssh $remote_user@$remote_host " "python3 $gen_synplify_project $rsp_s1_filelist_fpga" > /home/users/yuyushan/synplify.txt"


#ssh $remote_user@$remote_host "cd `cat /home/users/yuyushan/synplify.txt`"
#ssh $remote_user@$remote_host "pwd"


# ssh $remote_user@$remote_host "$local_command2" &&  echo 'successfully' || echo 'failed'

########################
# cd /data/yuyushan_97/python
# python3 gen_link_design_tcl.py
# cd /data/yuyushan_97/link_synplify_vivado/test
# vivado -mode tcl -source syn_LGV1R3C01B023_ila.tcl
########################

ssh $remote_user@$remote_host "bash /home/users/yuyushan/yuyushan_97/python/edf103_2_dcp97/iccode2edf_103.sh"

cd /data/yuyushan_97/python/edf103_2_dcp97 || exit 1

# 读取文件中的目录路径 
directory_path=$(cat /data/yuyushan_97/python/edf103_2_dcp97/gen_syn_prj_path.txt)
last_part=$(basename "$directory_path")
second_last_part=$(dirname "$directory_path" | xargs basename)

edf_dir_path="/data/yuyushan_97/$second_last_part/$last_part"
# echo "$edf_dir_path/rev1"

python3 /data/yuyushan_97/python/edf103_2_dcp97/gen_link_design_tcl.py $edf_dir_path/rev_1

cd /data/yuyushan_97/link_synplify_vivado/ || exit 1

sleep 3s

pwd

vivado -mode tcl -source *.tcl

sleep 5s

rm -rf *.tcl