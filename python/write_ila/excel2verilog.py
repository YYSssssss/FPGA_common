import os
import pandas as pd

def gen_rsp_ila_tcl(module_name,signals,ila_ip_path,gen_rsp_ila_tcl_path):
    
    with open(gen_rsp_ila_tcl_path,'w') as f2:
        f2.write("""
#set project parameters

set origin_dir "."
set orig_proj_dir "[file normalize "$origin_dir/"]"
set _xil_proj_name_ "gen_rsp_ila"
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
        
    for i in range(len(module_name)):
        file_name = 'ila_' + module_name[i]
        folder_list = os.listdir(ila_ip_path)
        if file_name in folder_list:
            continue
        else:
            f2.write('create_ip -name ila -vendor xilinx.com -library ip -version 6.2 -module_name ' + file_name + ' -dir ' + ila_ip_path + '\n')
            for j in len(signals[i][j]):
                if j == len(signals[i][j])-1:
                    ('CONFIG.Component_Name {' + file_name + '}] [get_ips ' + file_name + '] \n')
                elif j == 0:
                        set_property -dict [list CONFIG.C_PROBE4_WIDTH {18} CONFIG.C_PROBE3_WIDTH {16} CONFIG.C_PROBE1_WIDTH {16} CONFIG.C_NUM_OF_PROBES {5} CONFIG.Component_Name {test_ila_0}] [get_ips test_ila_0]
                    f2.write('set_property -dict [list CONFIG.C_PROBE' + j + '_WIDTH {' + signals[i][j] + '} ')
                else:
                    f2.write('CONFIG.C_PROBE' + j + '_WIDTH {' + signals[i][j] + '} ') 
            f2.write('generate_target {instantiation_template} [get_files ' + ila_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
            # f2.write('update_compile_order -fileset sources_1 \n')
            f2.write('generate_target all [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
            f2.write('catch { config_ip_cache -export [get_ips -all ' + file_name + '] }  \n')
            f2.write('export_ip_user_files -of_objects [get_files ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] -no_script -sync -force -quiet  \n')
            f2.write('create_ip_run [get_files -of_objects [get_fileset sources_1] ' + gen_ram_ip_path + '/' + file_name + '/' + file_name + '.xci] \n')
            f2.write('launch_runs ' + file_name + '_synth_1 -jobs 12 \n\n\n\n')


def extract_info_from_excel(excel_file):
 # 
    df = pd.read_excel(excel_file, header=None)

    # 
    total_rows,total_columns = df.shape
    total_groups = int(total_columns/2)

    # 
    info_list_per_group = []
    for group_index in range(total_groups):
        non_empty_rows_per_column = df[group_index*2].count()

        # 
        start_col = group_index * 2
        end_col = min((group_index + 1) * 2, total_columns)
        start_row = 2
        end_row = non_empty_rows_per_column-1

        # 
        module = df.iloc[0, start_col]
        signal = df.iloc[1, start_col]
        width = df.iloc[1, start_col + 1]
        true_names = df.iloc[2:end_row, start_col].values.tolist()
        true_widths = df.iloc[2:end_row, start_col + 1].values.tolist()
        file_path = df.iloc[end_row, group_index * 2]

        # signals = [f"[{int(w)-1}:0]" if str(w).isdigit() else f"{w}" for name, w in zip(true_names, true_widths)]
        signals = ["[{0}-1:0]".format(int(w)) if str(w).isdigit() else "{0}".format(w) for name,w in zip(true_names,true_widths)]

        info_list_per_group.append({
            'module': module,
            'signal': signal,
            'width': width,
            'true_names': true_names,
            'true_widths': true_widths,
            'file_path': file_path,
            'signals': signals
        })

    return info_list_per_group

def write_ila2file(excel_file_path,temp_file_path,module_name,true_names,signals):
    with open(temp_file_path, "w") as file:
        file.write("\n")

    for i in range(len(excel_file_path)):
        if i==0:
            with open(temp_file_path,'w') as tf:
                tf.write("`ifdef FPGA_ILA" + " \n\n")
                for j in range(len(true_names[i])):
                    if j == 0:
                        continue
                    else:
                        tf.write("wire    " + str(signals[i][j]) + "    ila_" + str(true_names[i][j]) + " /* synthesis syn_keep=1 */;  \n")
                
                for j in range(len(true_names[i])):
                    if j == 0:
                        continue
                    else:
                        tf.write("assign " + "ila_" + str(true_names[i][j]) + " = " + str(true_names[i][j]) + ";  \n")
                
                tf.write("\n" + str(module_name[i]) + " u_" + str(module_name[i]) + " ( \n")
                for j in range(len(true_names[i])):
                    if j == 0:
                        tf.write("    .clk" + " ("+ str(true_names[i][j]) + ") " + "//" + str(signals[i][j]) + "\n")
                    elif j == len(true_names[i])-1:
                        tf.write("    .probe" + str(j-1) + " ("+ str(true_names[i][j]) + ") " + "//" + str(signals[i][j]) + "\n")
                        tf.write(')/* synthesis syn_noprune=1 */; \n\n')
                        tf.write("`endif \n\n")
                    else:
                        tf.write("    .probe" + str(j-1) + " ("+ str(true_names[i][j]) + "), " + "//" + str(signals[i][j]) + "\n")
        elif excel_file_path[i] == excel_file_path[i-1]:
            with open(temp_file_path,'a') as tf:
                tf.write("`ifdef FPGA_ILA" + " \n\n")
                for j in range(len(true_names[i])):
                    if j == 0:
                        continue
                    else:
                        tf.write("wire    " + str(signals[i][j]) + "    ila_" + str(true_names[i][j]) + " /* synthesis syn_keep=1 */;  \n")
                
                for j in range(len(true_names[i])):
                    if j == 0:
                        continue
                    else:
                        tf.write("assign " + "ila_" + str(true_names[i][j]) + " = " + str(true_names[i][j]) + ";  \n")
                
                tf.write("\n" + str(module_name[i]) + " u_" + str(module_name[i]) + " ( \n")
                for j in range(len(true_names[i])):
                    if j == 0:
                        tf.write("    .clk" + " ("+ str(true_names[i][j]) + ") " + "//" + str(signals[i][j]) + "\n")
                    elif j == len(true_names[i])-1:
                        tf.write("    .probe" + str(j-1) + " ("+ str(true_names[i][j]) + ") " + "//" + str(signals[i][j]) + "\n")
                        tf.write(')/* synthesis syn_noprune=1 */; \n\n')
                        tf.write("`endif \n\n")
                    else:
                        tf.write("    .probe" + str(j-1) + " ("+ str(true_names[i][j]) + "), " + "//" + str(signals[i][j]) + "\n")
        else:
            with open(temp_file_path,'w') as tf:
                tf.write("`ifdef FPGA_ILA" + " \n\n")
                for j in range(len(true_names[i])):
                    if j == 0:
                        continue
                    else:
                        tf.write("wire    " + str(signals[i][j]) + "    ila_" + str(true_names[i][j]) + " /* synthesis syn_keep=1 */;  \n")
                
                for j in range(len(true_names[i])):
                    if j == 0:
                        continue
                    else:
                        tf.write("assign " + "ila_" + str(true_names[i][j]) + " = " + str(true_names[i][j]) + ";  \n")
                
                tf.write("\n" + str(module_name[i]) + " u_" + str(module_name[i]) + " ( \n")
                for j in range(len(true_names[i])):
                    if j == 0:
                        tf.write("    .clk" + " ("+ str(true_names[i][j]) + ") " + "//" + str(signals[i][j]) + "\n")
                    elif j == len(true_names[i])-1:
                        tf.write("    .probe" + str(j-1) + " ("+ str(true_names[i][j]) + ") " + "//" + str(signals[i][j]) + "\n")
                        tf.write(')/* synthesis syn_noprune=1 */; \n\n')
                        tf.write("`endif \n\n")
                    else:
                        tf.write("    .probe" + str(j-1) + " ("+ str(true_names[i][j]) + "), " + "//" + str(signals[i][j]) + "\n")

        with open(excel_file_path[i],'r',encoding="utf-8") as wf:
            content = wf.read()

        content = content.replace('\r\n', '\n').replace('\r', '\n')
        content1 = content.splitlines()

        ifdef_line_numbers = [i for i, line in enumerate(content1) if "`ifdef" in line]
        endif_line_numbers = [i for i, line in enumerate(content1) if "`endif" in line]

        delete_complete = False
        for ifdef_start in reversed(ifdef_line_numbers):
            
            corresponding_endif = next((i for i in endif_line_numbers if i > ifdef_start), None)
            if corresponding_endif is not None:
                content1 = content1[:ifdef_start] + content1[corresponding_endif + 1:]
                while ifdef_start < corresponding_endif and ifdef_start < len(content1) and content1[ifdef_start].strip() == '':
                    content1.pop(ifdef_start)

        # delete_complete = not any("ifdef FPGA_ILA" in line or "endif" in line for line in content1)
        delete_complete = not any("ifdef FPGA_ILA" in line for line in content1)
        

        # Remove empty lines
        # content1 = [line for line in content1 if line.strip() != '']

        #
        line_number = next((i for i, line in enumerate(content1) if "endmodule" in line.strip()), None)
        

        if line_number is not None and delete_complete:
            with open(temp_file_path,"r",encoding="utf-8") as temp_tf:
                content2 = temp_tf.read()

            new_content = '\n'.join(content1[:line_number] + [content2] + content1[line_number:])

            with open(excel_file_path[i],"w",encoding="utf-8") as file:
                file.writelines(new_content)

            print(f'add ila {module_name[i]}')
        else:
            print(f'no "endmodule" in {excel_file_path[i]}')

# def gen_ila_tcl():



if __name__ == "__main__":

    #
    # for group_index, info_list in enumerate(info_lists):
    #     print(f"Group {group_index + 1} Information:")
    #     print(f"Module: {info_list['module']}")
    #     print(f"Signal: {info_list['signal']}")
    #     print(f"Width: {info_list['width']}")
    #     print(f"True Names: {info_list['true_names']}")
    #     print(f"True Widths: {info_list['true_widths']}")
    #     print(f"File Path: {info_list['file_path']}")
    #     print(f"Signals: {info_list['signals']}")
    #     print("\n")
    #

    current_path = os.getcwd()
    print(current_path)
    
    
    
    excel_file_path = "/home/users/yuyushan/yuyushan_97/python/write_ila/ila_test.xlsx"
    info_lists = extract_info_from_excel(excel_file_path)

    module_name = [w['module'] for w in info_lists]
    excel_file_path = [w['file_path'] for w in info_lists]
    true_names = [w['true_names'] for w in info_lists]
    signals = [w['signals'] for w in info_lists]

    temp_file_path = "/home/users/yuyushan/yuyushan_97/python/write_ila/temp_verilog.v"
    # write_ila2file(excel_file_path,temp_file_path,module_name,true_names,signals)





    /data/yuyushan_97/synplify_xilinx_rtl/ip/ila




