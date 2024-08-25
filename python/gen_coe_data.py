# 生成 128-bit 的数据，每16-bit递增1，生成4096行

# 初始化变量
num_lines = 4096  # 行数
bits_per_line = 128  # 每行128 bit
bits_per_chunk = 16  # 每个块16 bit

# 开始值
start_value = 0

# 文件输出
with open("output_data.txt", "w") as file:
    for i in range(num_lines):
        line = []
        for j in range(bits_per_line // bits_per_chunk):
            # 格式化成16-bit的十六进制表示
            chunk = f"{start_value + j:04X}"
            line.append(chunk)

        # 翻转数据
        line.reverse()
        
        # 将块拼接成完整的128-bit行，并写入文件
        file.write("".join(line) + ",\n")
        
        # 递增起始值
        start_value += 1
