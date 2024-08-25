# def raw_to_txt(raw_file, txt_file):
#     try:
#         with open(raw_file, 'rb') as f_raw:
#             raw_data = f_raw.read()
        
#         with open(txt_file, 'w') as f_txt:
#             for i in range(0, len(raw_data), 16):
#                 # Read 16 bytes from raw data
#                 line = raw_data[i:i+16]
#                 # Convert bytes to hex string and remove spaces
#                 hex_string = ''.join(f'{byte:02x}' for byte in line)
#                 # Reverse the hex string
#                 reversed_hex_string = ''.join([hex_string[j:j+2] for j in range(0, len(hex_string), 2)][::-1])
#                 # Write the hex string to txt file
#                 f_txt.write(reversed_hex_string + '\n')
                
#         print(f"Conversion complete: {raw_file} -> {txt_file}")
    
#     except FileNotFoundError:
#         print(f"File not found: {raw_file}")
#     except Exception as e:
#         print(f"An error occurred: {e}")

# 使用方法
# input_file = 'D:/FPGA_common/python/input_3840x2160_UYVY422_0001.raw'
# txt_file = 'D:/FPGA_common/python/input_3840x2160_UYVY422_0001.txt'
# input_file = 'D:/FPGA_common/python/map_3840x2160_U16_12Q4.raw'
# txt_file = 'D:/FPGA_common/python/map_3840x2160_U16_12Q4.txt'


# raw_to_txt(input_file, txt_file)








def raw_to_txt(raw_file, txt_file, bytes_per_line):
    try:
        with open(raw_file, 'rb') as f_raw:
            raw_data = f_raw.read()
        
        with open(txt_file, 'w') as f_txt:
            for i in range(0, len(raw_data), bytes_per_line):
                # Read 16 bytes from raw data
                line = raw_data[i:i+bytes_per_line]
                
                # Swap every 2 bytes
                swapped_line = bytearray()
                for j in range(0, len(line), 2):
                    if j + 1 < len(line):
                        swapped_line.append(line[j + 1])
                        swapped_line.append(line[j])
                    else:
                        swapped_line.append(line[j])
                
                # Convert swapped bytes to hex string
                hex_string = ''.join(f'{byte:02x}' for byte in swapped_line)
                
                # Reverse the hex string by every 2 characters (1 byte)
                reversed_hex_string = ''.join([hex_string[j:j+2] for j in range(0, len(hex_string), 2)][::-1])
                
                # Write the reversed hex string to txt file
                f_txt.write(reversed_hex_string + '\n')
                
        print(f"Conversion complete: {raw_file} -> {txt_file}")
    
    except FileNotFoundError:
        print(f"File not found: {raw_file}")
    except Exception as e:
        print(f"An error occurred: {e}")

# 使用方法
bytes_per_line = 4
input_file = 'D:/FPGA_common/python/input_3840x2160_UYVY422_BIT8.raw'
txt_file = 'D:/FPGA_common/python/input_3840x2160_UYVY422_BIT8_' + str(bytes_per_line) + 'bytes_per_line.txt'


raw_to_txt(input_file, txt_file, bytes_per_line)






