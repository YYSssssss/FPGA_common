import os

def rename_files(folder_path):
    # 获取文件夹中所有文件的列表
    files = os.listdir(folder_path)

    # 遍历文件列表
    for file_name in files:
        # 判断文件名中是否包含 "rsp_s1_prep"
        if "rsp_s1_prep" in file_name:
            # 构造新的文件名，将 "rsp_s1_prep" 替换为 "rsp_s2_prep"
            new_file_name = file_name.replace("rsp_s1_prep", "rsp_s2_prep")

            # 构造完整的文件路径
            old_file_path = os.path.join(folder_path, file_name)
            new_file_path = os.path.join(folder_path, new_file_name)

            # 重命名文件
            os.rename(old_file_path, new_file_path)
            print(f'Renamed: {file_name} to {new_file_name}')

# 指定文件夹路径
folder_path = '/home/users/yuyushan/work/rsp_s2_prep/src1'

# 调用函数进行文件重命名
rename_files(folder_path)
