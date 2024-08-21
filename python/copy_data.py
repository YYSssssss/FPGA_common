# data = ["0000000000000000,", "0000000000000003,", "0000001400000000,", "0000002800000000,", "0000005400001000,", "0000005800004000,", "0000005C00000004,", "0000005000000004,"]
data = ["000000AC00000000,", "000000A400002000,", "000000A800004000,", "000000A000000004,"]
# data = ["000000AC00000000,"]
ADD_ADDR = 0x100  # 每次累加的值
BASE_ADDR = 0xF0000  # 配置的基地址值，可以修改为其他16进制值
count_ac = 0  # 记录“000000AC”出现的次数
block_cycle = 30  # 每个增量周期的次数

with open("output.txt", "w") as file:
    for _ in range(510):
        for item in data:
            if "000000AC" in item:
                # 计算当前的增量基地址
                base_increment = (count_ac // block_cycle) * BASE_ADDR

                # if count_ac % block_cycle == 0 and count_ac != 0:
                    # 每当到达block_cycle倍数时，调整基地址
                    # file.write(f"Switching to new base increment: {base_increment:#x}\n")

                # 提取"000000AC"后面的数字部分
                prefix = item[:8]  # 前8位"000000AC"
                number_part = item[8:-1]  # 去掉逗号，取数字部分
                number_part_int = int(number_part, 16)  # 将数字部分转换为整数

                # 根据计数器增加相应的值
                increment = base_increment + (count_ac % block_cycle) * ADD_ADDR
                new_number_part_int = number_part_int + increment  # 增加n或2n等

                # 将增加后的值转换为16进制字符串，保持长度一致
                new_number_part = f"{new_number_part_int:08x}"

                # 重新拼接字符串
                item = prefix + new_number_part + ","

                # 增加计数器
                count_ac += 1

                # 将结果写入文件
                file.write(f"{item}\n")
            else:
                # 如果没有检测到"000000AC"，直接写入文件
                file.write(f"{item}\n")
