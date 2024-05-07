import pandas as pd

def extract_info_from_excel(excel_file):
 # 读取Excel文件
    df = pd.read_excel(excel_file, header=None)

    # 计算总组数
    total_rows,total_columns = df.shape
    total_groups = int(total_columns/2)

    # 分组并提取信息
    info_list_per_group = []
    for group_index in range(total_groups):
        non_empty_rows_per_column = df[group_index*2].count()

        # 计算每组的列范围
        start_col = group_index * 2
        end_col = min((group_index + 1) * 2, total_columns)
        start_row = 2
        end_row = non_empty_rows_per_column-1

        # 提取信息
        module = df.iloc[0, start_col]
        signal = df.iloc[1, start_col]
        width = df.iloc[1, start_col + 1]
        true_names = df.iloc[2:end_row, start_col].values.tolist()
        true_widths = df.iloc[2:end_row, start_col + 1].values.tolist()
        file_path = df.iloc[end_row, group_index * 2]

        signals = [f"[{int(w)-1}:0]" if str(w).isdigit() else f"{w}" for name, w in zip(true_names, true_widths)]

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
    for i in range(len(excel_file_path)):
        
        with open(excel_file_path[i],'r',encoding="utf-8") as wf:
            content = wf.read()

        if i==0:
            with open(temp_file_path,'w') as tf:
                tf.write("`ifdef FPGA_ILA" + " \n")
                tf.write(str(module_name[i]) + " u_" + str(module_name[i]) + " ( \n")
        else:
            with open(temp_file_path,'a') as tf:
                tf.write("`ifdef FPGA_ILA" + " \n")
                tf.write(str(module_name[i]) + " u_" + str(module_name[i]) + " ( \n")
                for j in range(len(true_names[i])):
                    for k in len
                    # if j == len(true_names):
                    #     tf.write("    ." + str(true_names[j]) + " ("+ str(signals[j]) + ") \n")
                    #     tf.write("`endif \n")
                    # else:
                    #     tf.write("    ." + str(true_names[j]) + " ("+ str(signals[j]) + "), \n")



if __name__ == "__main__":
    # 示例用法
    excel_file_path = "D:\FPGA_common_0\python\脚本插入ila_instance\提取ila_code信息\ila_table.xlsx"
    info_lists = extract_info_from_excel(excel_file_path)

    module_name = [w['module'] for w in info_lists]
    excel_file_path = [w['file_path'] for w in info_lists]
    true_names = [w['true_names'] for w in info_lists]
    signals = [w['signals'] for w in info_lists]

    temp_file_path = "D:/FPGA_common_0/python/脚本插入ila_instance/提取ila_code信息/temp_verilog.v"
    write_ila2file(excel_file_path,temp_file_path,module_name,true_names,signals)

    # 打印提取的信息
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