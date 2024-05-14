import binascii

def hex_to_image(hex_path, output_image_path):
    with open(hex_path, 'r') as hex_file:
        hex_data = ''.join(line.strip() for line in hex_file.readlines())

    binary_data = binascii.unhexlify(hex_data)
    
    with open(output_image_path, 'wb') as output_image:
        output_image.write(binary_data)

# 示例用法
hex_to_image("output_hex.txt", "output_image.png")
