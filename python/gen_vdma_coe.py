# data = ["0000000000000000,", "0000000000000003,", "0000001400000000,", "0000002800000000,", "0000005400001000,", "0000005800004000,", "0000005C00000000,", "0000005000000004,"]
# data = ["000000AC00000000,", "000000A400002000,", "000000A800004000,", "000000A000000004,"]
# data = ["000000AC00000000,"]

data = ["0000000000000000,", 
        "0000000000000003,",
        "0000001400000000,",
        "0000002800000000,",
        "0000005400001000,",
        "0000005800004000,",
        "0000005000000004,"]

# 读取要插入的文件内容
with open("top_pixel_addr.txt", "r") as insert_file:
    insert_lines = insert_file.readlines()

with open("vdma_coe.txt", "w") as file:
    insert_index = 0  # 用于记录当前插入行的索引
    for _ in range(1152):
        for item in data:
            file.write(f"{item}\n")
            if item == "0000005800004000,":
                if insert_index < len(insert_lines):
                    # 写入插入文件的当前行
                    file.write(insert_lines[insert_index].strip() + "\n")
                    # 更新插入行的索引
                    insert_index += 1
                else:
                    # 如果插入文件中的行已经全部插入完，停止插入
                    print("No more lines to insert from insert_file.txt.")
                    break
