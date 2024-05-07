import os
import shutil



def gen_xil_ram(sourcefile_spram_path,gen_ram_file_path,set_spram_TYPE,set_spram_DATA_DEPTH,set_spram_DATA_WIDTH,set_spram_RD_DELAY):
    with open(sourcefile_spram_path,'r') as obj:
        data = obj.read()

    with open(gen_ram_file_path,'w') as f2: 
        for line in data.split('\n'):
            if line == '\n' or line.startswith('//'):
                f2.write(line + "\n")
            elif "xil_spram" in line:
                f2.write("module " + "xil_spram_" + set_spram_DATA_DEPTH + "x" + set_spram_DATA_WIDTH + "_ip # \n")
            elif "parameter TYPE =" in line:
                f2.write("  parameter TYPE = " + '"' + set_spram_TYPE + '"' + "," + '\n')
            elif "parameter DATA_DEPTH =" in line:
                f2.write("  parameter DATA_DEPTH =" + set_spram_DATA_DEPTH + "," + "\n")
            elif "parameter DATA_WIDTH =" in line:
                f2.write("  parameter DATA_WIDTH =" + set_spram_DATA_WIDTH + "," + "\n")
            elif "parameter RD_DELAY =" in line:
                f2.write("  parameter RD_DELAY =" + set_spram_RD_DELAY + "," + "\n")
            elif "parameter ADDR_WIDTH" in line:
                num = int(set_spram_DATA_DEPTH)
                f2.write("  parameter ADDR_WIDTH = " + str(num.bit_length()-1)  + "\n")
            else:
                f2.write(line + "\n")










def gen_ram_ip(gen_ram_ip_path,source_create_ram_ip_tcl,
               set_spram_DATA_DEPTH,set_spram_DATA_WIDTH,
               set_tpram_DATA_DEPTH,set_tpram_DATA_WIDTH):
    with open(source_create_ram_ip_tcl,'w') as f2: 
        f2.write("""
#set project parameters

set origin_dir "."
set orig_proj_dir "[file normalize "$origin_dir/"]"
set _xil_proj_name_ "gen_ram_dcp"
# set _top_ "xil_spram"


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
set_property -name "simulator_language" -value "Mixed" -objects $obj \n\n
""")
        for i in range(len(set_spram_DATA_DEPTH)):
            file_name = 'xil_spram_' + set_spram_DATA_DEPTH[i] + 'x' + set_spram_DATA_WIDTH[i]
            folder_list = os.listdir(gen_ram_ip_path)
            if file_name in folder_list:
                # print(folder_name)
                continue
            else:
                f2.write('create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name ' + file_name + ' -dir ' + gen_ram_ip_path + '\n')
                if int(set_spram_DATA_WIDTH[i]) % 8 == 0 :
                    f2.write('set_property -dict [list CONFIG.Use_Byte_Write_Enable {true} CONFIG.Byte_Size {8} CONFIG.Write_Width_A {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Write_Depth_A {' + set_spram_DATA_DEPTH[i] + '} CONFIG.Read_Width_A {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Write_Width_B {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Read_Width_B {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Register_PortA_Output_of_Memory_Primitives {false}] [get_ips ' + file_name + '] \n')
                else:
                    f2.write('set_property -dict [list CONFIG.Write_Width_A {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Write_Depth_A {' + set_spram_DATA_DEPTH[i] + '} CONFIG.Read_Width_A {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Write_Width_B {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Read_Width_B {' + set_spram_DATA_WIDTH[i] + '} CONFIG.Register_PortA_Output_of_Memory_Primitives {false}] [get_ips ' + file_name + '] \n')
                    
                f2.write('generate_target {instantiation_template} [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
                f2.write('update_compile_order -fileset sources_1 \n')
                f2.write('generate_target all [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
                f2.write('catch { config_ip_cache -export [get_ips -all ' + file_name + '] }  \n')
                f2.write('export_ip_user_files -of_objects [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] -no_script -sync -force -quiet  \n')
                f2.write('create_ip_run [get_files -of_objects [get_fileset sources_1] ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
                f2.write('launch_runs ' + file_name + '_synth_1 -jobs 30 \n\n\n\n')
                # f2.write('export_simulation -of_objects [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] -directory /home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.ip_user_files/sim_scripts -ip_user_files_dir /home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.ip_user_files -ipstatic_source_dir /home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/modelsim} {questa=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/questa} {ies=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/ies} {xcelium=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/xcelium} {vcs=/home/ssm/Desktop/work/mipi_dphy_0_ex} {riviera=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet \n\n\n\n')


        for i in range(len(set_tpram_DATA_DEPTH)):
            file_name = 'xil_tpram_' + set_tpram_DATA_DEPTH[i] + 'x' + set_tpram_DATA_WIDTH[i]
            folder_list = os.listdir(gen_ram_ip_path)
            if file_name in folder_list:
                # print(folder_name)
                continue
            else:
                f2.write('create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name ' + file_name + ' -dir ' + gen_ram_ip_path + '\n')
                if int(set_tpram_DATA_WIDTH[i]) % 8 == 0 :
                    f2.write('set_property -dict [list CONFIG.Use_Byte_Write_Enable {true} CONFIG.Byte_Size {8} CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Write_Width_A {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Write_Depth_A {' + set_tpram_DATA_DEPTH[i] + '} CONFIG.Read_Width_A {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Read_Width_B {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips ' + file_name + '] \n')
                else:
                    f2.write('set_property -dict [list CONFIG.Memory_Type {Simple_Dual_Port_RAM} CONFIG.Write_Width_A {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Write_Depth_A {' + set_tpram_DATA_DEPTH[i] + '} CONFIG.Read_Width_A {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Operating_Mode_A {NO_CHANGE} CONFIG.Write_Width_B {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Read_Width_B {' + set_tpram_DATA_WIDTH[i] + '} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortA_Output_of_Memory_Primitives {false} CONFIG.Register_PortB_Output_of_Memory_Primitives {false} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Enable_Rate {100}] [get_ips ' + file_name + '] \n')
                f2.write('generate_target {instantiation_template} [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
                f2.write('update_compile_order -fileset sources_1 \n')
                f2.write('generate_target all [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
                f2.write('catch { config_ip_cache -export [get_ips -all ' + file_name + '] }  \n')
                f2.write('export_ip_user_files -of_objects [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] -no_script -sync -force -quiet  \n')
                f2.write('create_ip_run [get_files -of_objects [get_fileset sources_1] ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
                f2.write('launch_runs ' + file_name + '_synth_1 -jobs 30 \n\n\n\n')
                # f2.write('export_simulation -of_objects [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] -directory /home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.ip_user_files/sim_scripts -ip_user_files_dir /home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.ip_user_files -ipstatic_source_dir /home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.ip_user_files/ipstatic -lib_map_path [list {modelsim=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/modelsim} {questa=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/questa} {ies=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/ies} {xcelium=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/xcelium} {vcs=/home/ssm/Desktop/work/mipi_dphy_0_ex} {riviera=/home/ssm/Desktop/work/LGV1R3C01B011/synplify_vivado/gen_ram_dcp/gen_ram_dcp.cache/compile_simlib/riviera}] -use_ip_compiled_libs -force -quiet \n\n\n\n')


def check_dcp_files(user_ram_ip_path):
    # for root,dirs,files in os.walk(user_ram_ip_path):
    #     dcp_files = [file for file in files if file.endswith('.dcp')]

    #     if not dcp_files:
    #         print(f"{root} does not have dcp file")
        # else:
        #     print("success generate ram ip" + root)
    
    if not os.listdir(user_ram_ip_path):
        print("empty dir path")
    else:
        for folder_name in os.listdir(user_ram_ip_path):
            folder_path = os.path.join(user_ram_ip_path,folder_name)
            if os.path.isdir(folder_path):
                if any(file.endswith('.dcp') for file in os.listdir(folder_path)):
                    continue
                print("folder without .dcp file:",folder_name)
  


def find_copy_to_specify_path(source_ram_directory,destination_ram_directory):
    if not os.path.exists(source_ram_directory):
        print("not found source ram directory")
        return

    if not os.path.exists(destination_ram_directory):
        # os.mkdirs(destination_ram_directory)
        # print('mkdir destination_ram_directory')
        print("not found destination_ram_directory")
        return
    
    for root,dirs,files in os.walk(source_ram_directory):
        for file in files:
            if "stub.v" in file and file.endswith(".v"):
                source_path = os.path.join(root,file)
                destination_path = os.path.join(destination_ram_directory,file)
                shutil.copy2(source_path,destination_path)
                print("copy file '{}' to '{}' ".format(file,destination_ram_directory))



# def check_dcp




#######################################################################################################
if __name__ == "__main__":

#copy stub.v -> folder_path
    # source_ram_directory = current_path + 'synplify_xilinx_rtl/ip/ram_ip'
    # destination_ram_directory = current_path + 'synplify_xilinx_rtl/rtl/ram_ip_rtl'

    # find_copy_to_specify_path(source_ram_directory,destination_ram_directory)


    set_spram_TYPE = "block"
    set_spram_DATA_DEPTH = [
                            "1024","1024","1024","1024","1024","1024",
                            "128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,
                            "136" ,
                            "144" ,"144" ,"144" ,"144" ,"144" ,"144" ,"144" ,"144" ,
                            "160" ,"160" ,
                            "16"  ,"16"  ,
                            "2048","2048",
                            "256" ,"256" ,"256" ,"256" ,"256" ,"256" ,
                            "288" ,"288" ,"288" ,
                            "2"   ,
                            "32"  ,"32"  ,"32"  ,"32"  ,"32"  ,
                            "4"   ,
                            "512" ,"512" ,"512" ,"512" ,"512" ,
                            "64"  ,"64"  ,"64"  ,"64"  ,
                            "72"  ,"72"  ,"72"  ,
                            "8192",
                            "8"   ,
                            "192"
                            ]
    set_spram_DATA_WIDTH = [
                            "128" ,"13"  ,"32"  ,"39"  ,"64"  ,"8"   ,
                            "12"  ,"16"  ,"31"  ,"32"  ,"38"  ,"48"  ,"50"  ,"59"  ,"60"  ,"9"   ,"128" ,
                            "64"  ,
                            "31"  ,"32"  ,"38"  ,"48"  ,"50"  ,"59"  ,"64"  ,"9"   ,
                            "117" ,"64"  ,
                            "128" ,"48"  ,
                            "128" ,"84"  ,
                            "128" ,"12"  ,"13"  ,"32"  ,"48"  ,"64"  ,
                            "12"  ,"13"  ,"32"  ,
                            "48"  ,
                            "128" ,"12"  ,"32"  ,"48"  ,"8"   ,
                            "48"  ,
                            "128" ,"32"  ,"38"  ,"64"  ,"13"  ,
                            "128" ,"12"  ,"48"  ,"8"  ,
                            "128" ,"12"  ,"48"  ,
                            "72"  ,
                            "48"  ,
                            "8"
                            ]
    set_spram_RD_DELAY = ["1"]

    set_tpram_TYPE = "block"
    set_tpram_DATA_DEPTH = [
                            "128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,"128" ,
                            "16"  ,"16"  ,"16"  ,"16"  ,"16"  ,
                            "256" ,"256" ,"256" ,"256" ,
                            "2"   ,
                            "32"  ,"32"  ,"32"  ,"32"  ,"32"  ,
                            "48"  ,
                            "4"   ,
                            "512" ,"512" ,"512" ,"512" ,"512" ,
                            "64"  ,"64"  ,"64"  ,"64"  ,"64"  ,"64"  ,
                            "72"  ,
                            "80"  ,
                            "8"   ,
                            "96"  ,
                            "128" ,"128" ,"128" ,
                            "16"
                            ]
    set_tpram_DATA_WIDTH = [
                            "104" ,"108" ,"128" ,"138" ,"142" ,"144" ,"16"  ,"32"  ,"47"  ,
                            "104" ,"108" ,"128" ,"38"  ,"54"  ,
                            "104" ,"128" ,"52"  ,"64"  ,
                            "104" ,
                            "104" ,"108" ,"128" ,"52"  ,"54"  ,
                            "16"  ,
                            "104" ,
                            "104" ,"128" ,"32"  ,"64"  ,"52" ,
                            "104" ,"108" ,"128" ,"16"  ,"52" ,"54"  ,
                            "16"  ,
                            "16"  ,
                            "104" ,
                            "16"  ,
                            "52"  ,"22"  ,"54"  ,
                            "52"
                            ]
    set_tpram_RD_DELAY = ["1"]

    set_sp_uram_TYPE = "ultra"
    set_sp_uram_DATA_DEPTH = [
                            "8192",
                            "4096"
                        ]
    set_sp_uram_DATA_WIDTH = [
                            "72",
                            "72"
                        ]
    set_sp_uram_RD_DELAY = ["1"]

    current_path = "/data/yuyushan_97/"





##### gen_ram_ip_tcl
    source_create_ram_ip_tcl = current_path + "link_synplify_vivado//create_ram_ip_tcl.tcl"
    gen_ram_ip_path = current_path + "synplify_xilinx_rtl/ip/ram_ip"
    gen_spram_ip_num = len(set_spram_DATA_DEPTH)
    gen_tpram_ip_num = len(set_tpram_DATA_DEPTH)
    print(gen_spram_ip_num+gen_tpram_ip_num)
    gen_ram_ip(gen_ram_ip_path,source_create_ram_ip_tcl,
               set_spram_DATA_DEPTH,set_spram_DATA_WIDTH,
               set_tpram_DATA_DEPTH,set_tpram_DATA_WIDTH)

    ##### check whether gen ram ip success
    # gen_ram_ip_path = current_path + "synplify_xilinx_rtl/ip/test"
    # check_dcp_files(gen_ram_ip_path)




#### gen_uram
    # current_path = os.getcwd()
    # print(current_path)
    sourcefile_spram_path = "/data/yuyushan_97/synplify_xilinx_rtl/rtl/xil_uram/xil_spram.v"
    sourcefile_tpram_path = "/data/yuyushan_97/synplify_xilinx_rtl/rtl/xil_uram/xil_tpram.v"
    temp_ram_file_path = "/data/yuyushan_97/synplify_xilinx_rtl/rtl/xil_uram/"

    ###### generate spram + xilinx_xpm   &   tpram + xilinx_xpm  (not used now)
    # for i in (range(len(set_spram_DATA_DEPTH))):
    #     for j in (range(len(set_spram_RD_DELAY))):
    #         gen_ram_filename = "xil_spram_" + set_spram_TYPE + set_spram_DATA_DEPTH[i] + "x" + set_spram_DATA_WIDTH[i] + "_d" + set_spram_RD_DELAY[j] + ".v"
    #         gen_ram_file_path = os.path.join(current_path,temp_ram_file_path,gen_ram_filename)
    #         # print(gen_ram_file_path)
    #         gen_xil_ram(sourcefile_spram_path,gen_ram_file_path,set_spram_TYPE,set_spram_DATA_DEPTH[i],set_spram_DATA_WIDTH[i],set_spram_RD_DELAY[j])

    # for i in (range(len(set_tpram_DATA_DEPTH))):
    #     for j in (range(len(set_tpram_RD_DELAY))):
    #         gen_ram_filename = "xil_tpram_" + set_tpram_TYPE + set_tpram_DATA_DEPTH[i] + "x" + set_tpram_DATA_WIDTH[i] + "_d" + set_tpram_RD_DELAY[j] + ".v"
    #         gen_ram_file_path = os.path.join(current_path,temp_ram_file_path,gen_ram_filename)
    #         # print(gen_ram_file_path)
    #         gen_xil_ram(sourcefile_tpram_path,gen_ram_file_path,set_tpram_TYPE,set_tpram_DATA_DEPTH[i],set_tpram_DATA_WIDTH[i],set_tpram_RD_DELAY[j])

    # for i in (range(len(set_sp_uram_DATA_DEPTH))):
    #     for j in (range(len(set_sp_uram_RD_DELAY))):
    #         gen_ram_filename = "xil_spram_" + set_sp_uram_DATA_DEPTH[i] + "x" + set_sp_uram_DATA_WIDTH[i] + "_ip.v"
    #         gen_ram_file_path = os.path.join(current_path,temp_ram_file_path,gen_ram_filename)
    #         # print(gen_ram_file_path)
    #         gen_xil_ram(sourcefile_spram_path,gen_ram_file_path,set_sp_uram_TYPE,set_sp_uram_DATA_DEPTH[i],set_sp_uram_DATA_WIDTH[i],set_sp_uram_RD_DELAY[j])



