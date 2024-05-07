import os

def gen_ram_dcp_python(source_folder_path):
    file_names = []
    for filename in os.listdir(source_folder_path):
        file_path = os.path.join(source_folder_path,filename)
        if os.path.isfile(file_path):
            name, extension = os.path.splitext(filename)
            file_names.append(name)
    return file_names

def update_gen_ram_dcp_tcl(gen_ram_dcp_tcl_path,write_num,write_data):
    with open(gen_ram_dcp_tcl_path,'a') as f2: 
        for i in range(len(write_data)):
        # for i in range(3):
            f2.write('\n' + 'set filelist_file ' + '"' + write_data[i] + '"' + '\n')
            f2.write('set _filelist_file_ "$filelist_path/$filelist_file$file_type"' + '\n')
            f2.write('set _write_checkpoint_file_ "file_ram_dcp/$filelist_file"' + '\n')
            f2.write('add_files "$_filelist_file_"' + '\n')
            if "xil_spram" in write_data[i]:
                f2.write('synth_design -top "xil_spram"' + '\n')
            elif "xil_tpram" in write_data[i]:
                f2.write('synth_design -top "xil_tpram"' + '\n')
            f2.write('write_checkpoint -force "$_write_checkpoint_file_"' + '\n')
            f2.write('remove_files "$_filelist_file_"' + '\n\n')

        f2.write('\n' + "close_project -delete" + '\n')

if __name__ == "__main__":
    current_path = os.getcwd()
    print(current_path)

    source_folder_path = "/data/yuyushan_97/synplify_xilinx_rtl/rtl/xil_ram/"
    gen_ram_dcp_tcl_path = "/data/yuyushan_97/synplify_xilinx_rtl/gen_ram_dcp_tcl.tcl"

    result = gen_ram_dcp_python(source_folder_path)
    # print(result)
    write_num = len(result)
    # print(write_num)
    update_gen_ram_dcp_tcl(gen_ram_dcp_tcl_path,write_num,result)