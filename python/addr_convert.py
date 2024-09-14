def convert_and_write(input_file, output_file):
    try:
        with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
            for line in f_in:
                # 去除行尾换行符并拆分成 x 和 y
                x_str, y_str = line.strip().split()
                x = int(x_str)  # 将 x 转换为整数
                y = int(y_str)  # 将 y 转换为整数
                
                # 计算公式 x*2 + y * 7680
                result = x * 2 + y * 7680
                
                # 转换结果为十六进制，并写入输出文件
                f_out.write(f'0000005C{result:08X},\n ')
        
        print(f"Conversion complete: {input_file} -> {output_file}")
    
    except FileNotFoundError:
        print(f"File not found: {input_file}")
    except Exception as e:
        print(f"An error occurred: {e}")

# 使用示例
input_file = 'E:/Sensemi_Jade/YYS_GDC/Luke/20240914/result/topMap.txt'  # 输入文件路径
output_file = 'E:/Sensemi_Jade/YYS_GDC/Luke/20240914/result/top_pixel_addr.txt'  # 输出文件路径
convert_and_write(input_file, output_file)
