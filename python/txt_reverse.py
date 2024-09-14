#txt_reverse
def reorder_lines(input_file, output_file):
    with open(input_file, 'r') as f_in, open(output_file, 'w') as f_out:
        for line in f_in:
            # 去掉行末的换行符
            line = line.strip()

            # 确保每行是256bit（32字节）的长度
            if len(line) == 64:  # 每个字符代表4 bit，所以64个字符是256 bit
                # 将字符串按8bit（2个字符）为一组，分割成列表
                chunks = [line[i:i+2] for i in range(0, len(line), 2)]

                # 将这些8bit（2字符）块进行翻转
                reordered_line = ''.join(reversed(chunks))

                # 将翻转后的行写入输出文件，并加上换行符
                f_out.write(reordered_line + '\n')
            else:
                print(f"Warning: Line length mismatch, skipping line: {line}")

# 使用示例
input_file = 'E:/Sensemi_Jade/YYS_GDC/Luke/20240914/result/bMapLinearPixLogTxtAll.txt'  # 输入文件路径
output_file = 'E:/Sensemi_Jade/YYS_GDC/Luke/20240914/result/bMapLinearPixLogTxtAll_reverse.txt'  # 输出文件路径
reorder_lines(input_file, output_file)
