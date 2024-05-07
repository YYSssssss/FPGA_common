import re



def extract_verilog_info(file_path):
    # 读取 Verilog 代码文件，指定编码为 utf-8
    with open(file_path, "r", encoding="utf-8") as file:
        verilog_code = file.read()

    # 定义存储信息的列表
    modules_info = []

    # 定义正则表达式
    module_pattern = re.compile(r'\b(\w+)\s+(\w+)\s*\(', re.MULTILINE)
    signal_pattern = re.compile(r'\.(\w+)\((\w+)\)(?:.*\[(\d+):(\d+)\])?', re.MULTILINE)

    # 分割文本为模块实例化段落
    module_sections = verilog_code.split('\n\n')

    # 逐个处理每个模块实例化段落
    for section in module_sections:
        module_info = {}

        # 查找模块信息
        module_match = module_pattern.search(section)
        if module_match:
            module_info["Module Name"] = module_match.group(1)
            module_info["Instance Name"] = module_match.group(2)

        # 查找信号信息
        signal_matches = signal_pattern.findall(section)
        signals_info = []
        for signal_match in signal_matches:
            signal_info = {}
            signal_info["Signal Name"] = signal_match[0]
            signal_info["Signal Instance"] = signal_match[1]

            # 检查位宽是否为空
            signal_width_high = signal_match[2] if signal_match[2] else '0'
            signal_width_low = signal_match[3] if signal_match[3] else '0'

            # 转换为整数时检查非空
            signal_info["Signal Width"] = int(signal_width_high) - int(signal_width_low) + 1 if signal_width_high and signal_width_low else 1

            signals_info.append(signal_info)

        module_info["Signals"] = signals_info
        modules_info.append(module_info)

    return modules_info

if __name__ == "__main__":
    # 使用示例
    file_path = "C:/Users/yys/Desktop/test/verilog.v"
    result = extract_verilog_info(file_path)

    # 打印存储的信息
    # print(result.module_info)
    for module_info in result:
        print("Module Name:", module_info["Module Name"])
        print("Instance Name:", module_info["Instance Name"])

        for signal_info in module_info["Signals"]:
            print("Signal Name:", signal_info["Signal Name"])
            print("Signal Instance:", signal_info["Signal Instance"])
            print("Signal Width:", signal_info["Signal Width"])
            print("-----")
