import binascii

def image_to_hex(image_path, output_path):
    with open(image_path, 'rb') as image_file:
        image_data = image_file.read()
        
    hex_data = binascii.hexlify(image_data).decode('utf-8')
    
    with open(output_path, 'w') as output_file:
        for i in range(0, len(hex_data), 16):
            output_file.write(hex_data[i:i+16] + '\n')

# 示例用法
image_to_hex("20240513-153909.png", "output_hex.txt")
