def combine_lines(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        buffer = []
        for line in infile:
            buffer.append(line.strip())
            if len(buffer) == 4:
                combined_line = ''.join(buffer)
                outfile.write(combined_line + '\n')
                buffer = []

        # Handle any remaining lines that don't make up a full set of 4
        if buffer:
            combined_line = ''.join(buffer)
            outfile.write(combined_line + '\n')

# Example usage
input_file = '//192.168.20.3/share_folder/New_GDC/testImages/3840x2160_20240624/inputYUV422/input_3840x2160_UYVY422_0001.raw'
output_file = 'D:/FPGA_common/python'
combine_lines(input_file, output_file)
