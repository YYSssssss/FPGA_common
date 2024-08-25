def bin_to_txt(bin_file, txt_file):
    try:
        with open(bin_file, 'rb') as f_bin:
            bin_data = f_bin.read()
        
        with open(txt_file, 'w') as f_txt:
            for i in range(0, len(bin_data), 16):
                # Read 16 bytes from bin data
                line = bin_data[i:i+16]
                # Convert bytes to hex string and remove spaces
                hex_string = ''.join(f'{byte:02x}' for byte in line)
                # 翻转十六进制字符串
                reversed_hex_string = ''.join([hex_string[j:j+2] for j in range(0, len(hex_string), 2)][::-1])
                # 将翻转后的字符串写入文件
                f_txt.write(reversed_hex_string + '\n')
                
        print(f"Conversion complete: {bin_file} -> {txt_file}")
    
    except FileNotFoundError:
        print(f"File not found: {bin_file}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage
bin_file = 'D:/FPGA_common/python/bMap12Q4.bin'
txt_file = 'D:/FPGA_common/python/bMap12Q4.txt'
bin_to_txt(bin_file, txt_file)

