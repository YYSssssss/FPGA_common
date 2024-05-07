import os
import subprocess
from gen_synplify_project import gen_synplify_project
from gen_link_design_tcl import gen_link_design_tcl_python


def terminal_in_out(command):
    result = subprocess.run(command,shell=True,stdout=subprocess.PIPE,stderr=subprocess.PIPE,universal_newlines=True)
    print("output:",result.stdout)
    print("error:",result.stderr)
    print("return:",result.returncode)
    print("\n")









if __name__ == "__main__":
    command_ls_l = "ls -l"
    command_pwd = "pwd"
    command_ssh = "ssh -X yuyushan@10.0.0.103"
    current_path = os.getcwd()
    print(current_path)
    # terminal_in_out(command_ls_l)
    # print("\n")
    # terminal_in_out(command_pwd)
    # print("\n")
    xci_file_path = "/data/yuyushan_97/synplify_xilinx_rtl/ip/"

    synplify_edf_name = "syn_LGV1R3C01B023"
    vivado_project_name = "link_" + synplify_edf_name
    gen_link_design_tcl_name = "/data/yuyushan_97/synplify_vivado/" + synplify_edf_name + ".tcl"
    synplify_edf_path = "/data/yuyushan_97/gen_synplify_edf/synplify_rpu/rev_1/" + synplify_edf_name + ".edf"
    write_dcp_file    = "/data/yuyushan_97/synplify_xilinx_rtl/edf/" + synplify_edf_name + ".dcp"
    
    # gen_link_design_tcl_python(gen_link_design_tcl_name,vivado_project_name,xci_file_path,synplify_edf_path,synplify_edf_name,write_dcp_file)
    
    try:
        subprocess.run("pwd")
        # subprocess.Popen("ssh -X yuyushan@10.0.0.103",shell=True)
        # subprocess.Popen("cd /home/users/yuyushan/yuyushan_97/gen_synplify_edf",shell=True)
        # subprocess.Popen("synplify_pro &",shell=True)
        open_vivado = subprocess.run("vivado -mode tcl",shell=True)
        open_vivado.wait()
    except Exception as e:
        print(f"Error: {e}")