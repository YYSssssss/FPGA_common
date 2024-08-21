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
                # Write the hex string to txt file
                f_txt.write(hex_string + '\n')
                
        print(f"Conversion complete: {bin_file} -> {txt_file}")
    
    except FileNotFoundError:
        print(f"File not found: {bin_file}")
    except Exception as e:
        print(f"An error occurred: {e}")

# Usage
bin_file = 'D:/FPGA_common/python/map.bin'
txt_file = 'D:/FPGA_common/python/map.txt'
bin_to_txt(bin_file, txt_file)

