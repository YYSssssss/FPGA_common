def extract_blocks(txt1_file, txt2_file, txt3_file, block_size_lines, bytes_per_line, total_blocks, image_width):
    try:
        # 读取txt1文件的所有行
        with open(txt1_file, 'r') as f_txt1:
            txt1_lines = f_txt1.readlines()
        
        # 读取txt2文件中的x和y坐标，并计算起始点行号
        with open(txt2_file, 'r') as f_txt2:
            start_points = []
            for line in f_txt2.readlines():
                x, y = map(int, line.strip().split())
                start_line = int((x + y * image_width) * 2 / bytes_per_line)  # 减去1以便从1开始计数
                start_points.append(start_line)
        
        # 确保起始点数量与总块数匹配
        if len(start_points) != total_blocks:
            print(f"Error: The number of start points in {txt2_file} does not match the total number of blocks.")
            return
        
        with open(txt3_file, 'w') as f_txt3:
            for block_index in range(total_blocks):
                start_line = start_points[block_index]
                
                for i in range(block_size_lines):  # 62 次
                    block_start_line = start_line + i * 480  # 每次间隔 480 行
                    # 判断 start_line 是否大于 1036800
                    if block_start_line > 1036800:
                        # 如果大于 1036800，block_lines 填充 128 位 (16 字节) 的 0
                        block_lines = ["0" * 32 + "\n"] * 18  # 每行 128bit (16 字节) 的 0，填充 18 行
                    else:
                        block_lines = txt1_lines[block_start_line:block_start_line + 18]  # 每次提取 18 行
                        # block_lines = txt1_lines[block_start_line:block_start_line + 16]  # 每次提取 16 行
                        # block_lines = txt1_lines[block_start_line:block_start_line + 30]  # 每次提取 16 行

                    # 将提取的 16 行数据写入 txt3

                    for line in block_lines:
                        f_txt3.write(line)
        
        print(f"Block extraction complete: {txt1_file} -> {txt3_file}")
    
    except FileNotFoundError as e:
        print(f"File not found: {e.filename}")
    except Exception as e:
        print(f"An error occurred: {e}")

# 使用方法
txt1_file = 'input_3840x2160_UYVY422_BIT8_16bytes_per_line.txt'
# txt1_file = 'input_3840x2160_UYVY422_BIT8_16bytes_per_line.txt'
# txt2_file = 'topMap.txt'
# txt3_file = 'output_gdc_block_all.txt'
txt2_file = 'C:/Users/yys/Downloads/result/topMap.txt'
txt3_file = 'C:/Users/yys/Downloads/result/output_gdc_block_all.txt'

block_size_lines = 68        # 每个block包含62次
bytes_per_line = 16          # 每行16字节
# bytes_per_line = 8          # 每行16字节
total_blocks = 1152          # 总共1152个block
image_width = 3840           # 图像宽度

extract_blocks(txt1_file, txt2_file, txt3_file, block_size_lines, bytes_per_line, total_blocks, image_width)