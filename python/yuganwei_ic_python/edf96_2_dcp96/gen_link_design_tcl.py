import os
import sys
import datetime

def add_run_parameter():
    if len(sys.argv) != 2:
        print("Usage: python3 gen_link_design_tcl <file_path>")

    file_path = sys.argv[1]

    return file_path

def find_edf_file(edf_file_path):
    files = [f for f in os.listdir(edf_file_path) if os.path.isfile(os.path.join(edf_file_path,f))]

    edf_files = [f for f in files if f.lower().endswith('.edf')]

    if len(edf_files) == 1:
        return os.path.splitext(edf_files[0])[0]
    elif len(edf_files) == 0:
        raise FileNotFoundError("No edf file")
    else:
        raise ValueError("Multiple .edf files found in the specified path")

def extract_time():
    current_datetime = datetime.datetime.now()

    formatted_datetime = current_datetime.strftime("%Y%m%d_%H%M%S")

    return formatted_datetime
    

def gen_link_design_tcl_python(gen_link_design_tcl_name,vivado_project_name,
                               xci_file_path,synplify_edf_path,synplify_edf_name,
                               write_dcp_file,write_dcp_file_path,current_datetime):
    print("read synplify edf path: \n" + synplify_edf_path + "\n")
    print("generate link tcl path: \n" + gen_link_design_tcl_name + "\n")

    with open(gen_link_design_tcl_name,'w') as f2: 
        f2.write('set origin_dir "." \n')
        f2.write('set orig_proj_dir "[file normalize "$origin_dir/"]" \n')
        f2.write('set _xil_proj_name_ "' + vivado_project_name + '" \n' +  '\n')
        f2.write('# set _top_ "xil_spram" \n\n\n')


        f2.write("""
#create_project
create_project -force ${_xil_proj_name_} ./${_xil_proj_name_} -part xczu15eg-ffvb1156-2-i
set proj_dir [get_property directory [current_project]]
set obj [current_project]
set_property -name "compxlib.vcs_compiled_library_dir" -value "/home/ssm/Desktop/work/mipi_dphy_0_ex" -objects $obj
set_property -name "default_lib" -value "xil_defaultlib" -objects $obj
set_property -name "enable_vhdl_2008" -value "1" -objects $obj
set_property -name "ip_cache_permissions" -value "read write" -objects $obj
set_property -name "ip_output_repo" -value "$proj_dir/${_xil_proj_name_}.cache/ip" -objects $obj
set_property -name "mem.enable_memory_map_generation" -value "1" -objects $obj
set_property -name "part" -value "xczu15eg-ffvb1156-2-i" -objects $obj
set_property -name "revised_directory_structure" -value "1" -objects $obj
set_property -name "sim.central_dir" -value "$proj_dir/${_xil_proj_name_}.ip_user_files" -objects $obj
set_property -name "sim.ip.auto_export_scripts" -value "1" -objects $obj
set_property -name "simulator_language" -value "Mixed" -objects $obj 
""")
        f2.write("\n\n\nadd_files -norecurse " + synplify_edf_path + '\n')

        for root,dirs,files in os.walk(xci_file_path):
            for file in files:
                if ".xci" in file:
                    file_path = os.path.join(root,file)
                    f2.write("add_files -norecurse " + file_path + '\n')
        
        f2.write('\n\n\nlink_design -top ' + synplify_edf_name + '\n')

        # f2.write('read_checkpoint -cell u_xil_spram /home/ssm/Desktop/work/synplify_test/xilinx_stub/xil_spram_bb.dcp' + '\n')
        f2.write('write_checkpoint -force ' + write_dcp_file + '\n')
        print("generate dcp file path : \n" + write_dcp_file_path + synplify_edf_name + "_" + current_datetime + ".dcp")
        
        f2.write('quit' + '\n')










######################################################################################################
if __name__ == "__main__":
    current_path = os.getcwd()
    # print(current_path)

    xci_file_path = "/data/yuyushan_97/synplify_xilinx_rtl/ip/"
    
    
    # vivado_project_name = "link_synplify_vivado"
    # synplify_edf_name = "syn_LGV1R3C01"
    # gen_link_design_tcl_name = "link_synplify_vivado/" + synplify_edf_name + ".tcl"
    # synplify_edf_path = current_path + "/gen_synplify_edf/synplify_rpu/rev_1/" + synplify_edf_name + ".edf"
    # write_dcp_file = current_path + "/synplify_xilinx_rtl/edf/" + synplify_edf_name + ".dcp"
    
    

    # synplify_edf_name = "syn_axi2ahb"
    # vivado_project_name = "link_" + synplify_edf_name
    # gen_link_design_tcl_name = "link_synplify_vivado/" + synplify_edf_name + ".tcl"
    # synplify_edf_path = current_path + "../gen_synplify_edf/synplify_axi2ahb_async/rev_1/" + synplify_edf_name + ".edf"
    # write_dcp_file    = current_path + "../synplify_xilinx_rtl/edf/" + synplify_edf_name + ".dcp"

    edf_file_path = add_run_parameter()
    synplify_edf_name = find_edf_file(edf_file_path)
    current_datetime = extract_time()
    vivado_project_name = "link_" + synplify_edf_name
    print(synplify_edf_name)
    gen_link_design_tcl_name = "/data/yuyushan_97/link_synplify_vivado/" + synplify_edf_name + "_" + current_datetime + ".tcl"
    # synplify_edf_path = "/data/yuyushan_97/gen_synplify_edf/synplify_rpu_ila2/rev_1/" + synplify_edf_name + ".edf"
    synplify_edf_path = "/data/yuyushan_97/gen_synplify_edf_96/" + synplify_edf_name + "/rev_1/" + synplify_edf_name + ".edf"
    write_dcp_file    = "/data/yuyushan_97/synplify_xilinx_rtl/edf/" + synplify_edf_name + "_" + current_datetime + ".dcp"
    write_dcp_file_path = "/data/yuyushan_97/synplify_xilinx_rtl/edf/"
    
    
    gen_link_design_tcl_python(gen_link_design_tcl_name,vivado_project_name,
                            xci_file_path,synplify_edf_path,synplify_edf_name,
                            write_dcp_file,write_dcp_file_path,current_datetime)