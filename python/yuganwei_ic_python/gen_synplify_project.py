import os
import sys
import datetime
import re

def add_run_parameter():
    if len(sys.argv) != 3:
        print("Usage: python3 gen_synplify_project <file_path> <gen_synplify_folder_name>")
        # print("Usage: python3 gen_synplify_project <file_path>")

    file_path = sys.argv[1]
    create_synplify_folder = sys.argv[2]

    return file_path,create_synplify_folder

def find_filelist_fpga(filelist_fpga_path):
    files = [f for f in os.listdir(filelist_fpga_path) if os.path.isfile(os.path.join(filelist_fpga_path,f))]

    matching_files = [f for f in files if f.lower().endswith('filelist_fpga')]

    if len(matching_files) == 1:
        return matching_files[0],matching_files[0].rsplit('filelist_fpga',1)[0].strip('_')
    elif len(matching_files) == 0:
        raise FileNotFoundError("No filelist file")
    else:
        raise ValueError("Multiple filelist files found in the specified path")

def extract_time():
    current_datetime = datetime.datetime.now()

    formatted_datetime = current_datetime.strftime("%Y%m%d_%H%M%S")

    return formatted_datetime

def create_folder(folder_path):
    if not os.path.exists(folder_path):
        os.makedirs(folder_path)
    else:
        print("Error:folder already exists")

def gen_synplify_project(vobs_path,filelist_path,file_syn_tcl_path,synplify_project_name,
                         ram_stub_v_path,mul_stub_v_path,ila_stub_v_path,
                         iceng_mem,top_module,input_synplify_folder_path):
    filetype_verilog = " -verilog "
    filetype_systemverilog = " -verilog -vlog_std sysv " 
    need_delate_word0 = "+incdir+"
    need_delate_word1 = "+incdir+"
    need_delate_word2 = "+define+FPGA"
    header0 = "header files are defined in"
    need_operate_words = [need_delate_word0,need_delate_word1,need_delate_word2]

    file_rtl = os.path.join(filelist_path)

    with open(file_rtl,'r') as obj:
        data = obj.read()

    with open(file_syn_tcl_path,'w') as f2: 
        f2.write("""
#--  Synopsys, Inc.
#--  Version Q-2020.03-SP1
#--  Project file /home/users/yuyushan/work/LGV1R3C01_B002/synplify/""" + synplify_project_name + '.prj \n')

        f2.write('\n\n\nset vobs'     + vobs_path + '\n')
        # f2.write('set ahb2ahb_async' + vobs_path + '/cores/ahb2ahb_async \n')
        # f2.write('set aamba_if'      + vobs_path + '/cores/amba_if \n')
        # f2.write('set cdc_demet'     + vobs_path + '/cores/cdc_demet \n')
        # f2.write('set dsp_lib'       + vobs_path + '/cores/dsp_lib \n')
        # f2.write('set dw'            + vobs_path + '/ip/dw \n')
        # f2.write('set fifos'         + vobs_path + '/cores/fifos \n')
        # f2.write('set ram /iceng/lib/tsmcn28/memory/0.1/wrapper \n')
        # f2.write('set rsp_amba'      + vobs_path + '/cores/amba_if \n')
        # f2.write('set rsp_cdc'       + vobs_path + '/cores/cdc_demet \n')
        # f2.write('set rsp_dsp_lib'   + vobs_path + '/ip/rsp/design/rsp_common/rsp_dsp_lib \n')
        # f2.write('set rsp_header'    + vobs_path + '/ip/rsp/design/rsp_common/header \n')
        # f2.write('set rsp_s1'        + vobs_path + '/ip/rsp/design/rsp_s1 \n')
        # f2.write('set rsp_s1_atb'    + vobs_path + '/ip/rsp/design/rsp_s1/sub/rsp_s1_atb \n')
        # f2.write('set rsp_s1_comp'   + vobs_path + '/ip/rsp/design/rsp_s1/sub/rsp_s1_comp \n')
        # f2.write('set rsp_s1_data_format' + vobs_path + '/cores/rsp_s1_data_format \n')
        # f2.write('set rsp_s1_dispatch'    + vobs_path + '/ip/rsp/design/rsp_s1/sub/rsp_s1_dispatch \n')
        # f2.write('set rsp_s1_dma'         + vobs_path + '/ip/rsp/design/rsp_s1/sub/rsp_s1_dma \n')
        # f2.write('set rsp_s1_fft'         + vobs_path + '/ip/rsp/design/rsp_s1/sub/rsp_s1_fft \n')
        # f2.write('set rsp_s1_ram_banks'   + vobs_path + '/ip/rsp/design/rsp_s1/sub/rsp_s1_ram_banks \n')
        # f2.write('set s1_dma_common'      + vobs_path + '/ip/rsp/design/rsp_common/s1_dma_common \n')
        # f2.write('set t28_mem'            + vobs_path + '/iceng/lib/tsmcn28/memory/0.1/VERILOG \n')
        # f2.write('set t28_mem_wrap'       + vobs_path + '/iceng/lib/tsmcn28/memory/0.1/t28_mem_wrap \n')
        f2.write('set_option -include_path' + vobs_path + '/ip/rsp/design/rsp_common/header \n')
        f2.write('set_option -include_path' + vobs_path + '/ip/rsp/design/rsp_common/s1_dma_common/src/ \n')
        f2.write('set_option -hdl_define -set FPGA=1 \n\n\n')
        f2.write('set_option -hdl_define -set FPGA_ILA=1 \n\n\n')
        
        
        for root,dirs,files in os.walk(iceng_mem):
            for file in files:
                if ".v" in file and "dpram" not in file and ".t" not in file:
                    file_path = os.path.join(root,file)
                    f2.write("add_file " + file_path + '\n')

        f2.write('\n\n')

        for root,dirs,files in os.walk(ram_stub_v_path):
            for file in files:
                name,extension = os.path.splitext(file)
                if "stub" in name and extension == ".v":
                    file_path = os.path.join(root,file)
                    f2.write("add_file " + file_path + '\n')

        f2.write('\n\n')

        for root,dirs,files in os.walk(mul_stub_v_path):
            for file in files:
                name,extension = os.path.splitext(file)
                if "stub" in name and extension == ".v":
                    file_path = os.path.join(root,file)
                    f2.write("add_file " + file_path + '\n')

        f2.write('\n\n')

        for root,dirs,files in os.walk(ila_stub_v_path):
            for file in files:
                name,extension = os.path.splitext(file)
                if "stub" in name and extension == ".v":
                    file_path = os.path.join(root,file)
                    f2.write("add_file " + file_path + '\n')

        f2.write('\n\n')


        for line in data.split('\n'):
            for i in (range(len(need_operate_words))):
                if header0 in line:
                    index_header0 = line.find(need_delate_word0)
                    line ="set_option -include_path " + "{" + line[index_header0+len(need_delate_word0):] + "}"
                elif need_operate_words[i] in line:
                    index_delate_words = line.find(need_operate_words[i])
                    line = line[index_delate_words+len(need_operate_words[i]):]

            if line == '\n' or line.startswith('//'):
                f2.write(line + "\n")
            elif "iceng" in line:
                f2.write("")
            elif ".v" in line:
                f2.write("add_file" + filetype_verilog + line + "\n")
            elif ".sv" in line:
                f2.write("add_file" + filetype_systemverilog + line + "\n")
            elif '${vobs}/cores/' and 'verilog' in line :
                f2.write('set_option -include_path '  + line + "\n")
            else:
                f2.write(line + "\n")
        
        f2.write("""
#implementation: "rev_1"
impl -add rev_1 -type fpga

#
#implementation attributes

set_option -vlog_std sysv
set_option -project_relative_includes 1
set_option -hdl_define -set FPGA=1
set_option -hdl_define -set FPGA_ILA=1
# set_option -include_path {/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_common/header;/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_common/s1_dma_common/src/;${vobs}/cores/ahb2ahb_async/src;${vobs}/cores/amba_if/src;${vobs}/cores/rsp_s1_data_format/src;${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_atb/src;${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_comp/src;${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_dma/src;${vobs}/ip/rsp/design/rsp_s1/sub/rsp_s1_fft/src;/home/tools/synopsys/syn/R-2020.09-SP4/dw/sim_ver;/prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs/ip/rsp/design/rsp_common/}

#device options
set_option -technology ZYNQ-ULTRASCALEPLUS-FPGAS
set_option -part XCZU15EG
set_option -package FFVB1156
set_option -speed_grade -2-i
set_option -part_companion ""

#compilation/mapping options
set_option -use_fsm_explorer 0 \n""")
        
        f2.write('set_option -top_module "' + top_module + '" \n')
        f2.write("""
# hdl_compiler_options
set_option -distributed_compile 0
set_option -hdl_strict_syntax 0

# mapper_without_write_options
set_option -frequency 200.000000
set_option -srs_instrumentation 1

# mapper_options
set_option -write_verilog 1
set_option -write_vhdl 0

# xilinx_options
set_option -rw_check_on_ram 1
set_option -optimize_ngc 1

# Xilinx Virtex2
set_option -run_prop_extract 1
set_option -maxfan 10000
set_option -disable_io_insertion 1
set_option -pipe 0
set_option -update_models_cp 0
set_option -retiming 0
set_option -no_sequential_opt 0
set_option -no_sequential_opt_bram_mapping both
set_option -fix_gated_and_generated_clocks 1

# Xilinx Zynq UltraScale+ FPGAs
set_option -enable_prepacking 1
set_option -use_vivado 1
set_option -support_xpm 1

# sequential_optimization_options
set_option -symbolic_fsm_compiler 1

# Compiler Options
set_option -compiler_compatible 0
set_option -resource_sharing 1
set_option -multi_file_compilation_unit 1

# Compiler Options
set_option -auto_infer_blackbox 0

#automatic place and route (vendor) options
set_option -write_apr_constraint 1

#set result format/file last
""" + 'project -result_file "rev_1/' + synplify_project_name + '.edf" \n' + 'impl -active "rev_1" \n')

    print(input_synplify_folder_path + synplify_project_name)



##################################################################################
if __name__ == "__main__":
    # current_path = os.getcwd()
    # file_rtl = os.path.join(current_path,"rsp_s1_top_filelist_fpga")
    
    
    input_filelist_path,input_synplify_folder_path = add_run_parameter()
    filelist_fullname,extract_filelist_name = find_filelist_fpga(input_filelist_path)
    filelist_path = input_filelist_path + filelist_fullname
    datetime = extract_time()
    # datetime = "test"
    vobs_path = " /prj/chips/pvg/venus/yuyushan/jade_venus_3/vobs"

    ram_stub_v_path = input_synplify_folder_path + "../synplify_xilinx_rtl/ip/ram_ip"
    mul_stub_v_path = input_synplify_folder_path + "../synplify_xilinx_rtl/ip/mul"
    ila_stub_v_path = input_synplify_folder_path + "../synplify_xilinx_rtl/ip/ila"
    iceng_mem = "/iceng/lib/tsmcn28/memory/0.1/wrapper/src"
    synplify_project_name = "syn_" + extract_filelist_name + "_" + datetime

    # print(input_synplify_folder_path + synplify_project_name)
    # print(ram_stub_v_path)
    # print(mul_stub_v_path)
    # print(ila_stub_v_path)

    create_folder(input_synplify_folder_path + synplify_project_name)
    file_syn_tcl_path = input_synplify_folder_path + synplify_project_name + "/" + "file_syn_tcl.prj"
    top_module = extract_filelist_name


    gen_synplify_project(vobs_path,filelist_path,file_syn_tcl_path,synplify_project_name,
                         ram_stub_v_path,mul_stub_v_path,ila_stub_v_path,
                         iceng_mem,top_module,input_synplify_folder_path)