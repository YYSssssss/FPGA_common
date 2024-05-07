import dpkt
import os

def split_pcap_by_packet(input_file, starting_packet):
    with open(input_file, 'rb') as f:
        pcap = dpkt.pcap.Reader(f)

        packet_count = 0
        file_counter = 1
        output_dir = os.path.dirname(input_file)

        # packet_per_file_sequence = [2048, 2048, 100]
        # packet_per_file_sequence = [2048, 2048]
        ############## packet_per_file_sequence = [2048, 1350 , 1350 ,50 ,50]
        packet_per_file_sequence = [3072,2025,2025,75,75]
        packet_sequence_index = 0
        packet_per_file = packet_per_file_sequence[packet_sequence_index]

        output_filename = f"{file_counter}.pcap"
        output_path = os.path.join(output_dir, output_filename)
        output_writer = dpkt.pcap.Writer(open(output_path, 'wb'))
        output_packet_count = 0

        for ts, buf in pcap:
            packet_count += 1

            if packet_count >= starting_packet:
                output_writer.writepkt(buf, ts)
                output_packet_count += 1

                if output_packet_count == packet_per_file:
                    output_writer.close()
                    file_counter += 1
                    output_filename = f"{file_counter}.pcap"
                    output_path = os.path.join(output_dir, output_filename)
                    output_writer = dpkt.pcap.Writer(open(output_path, 'wb'))
                    output_packet_count = 0

                    packet_sequence_index = (packet_sequence_index + 1) % len(packet_per_file_sequence)
                    packet_per_file = packet_per_file_sequence[packet_sequence_index]
            
        output_writer.close()
        print(f"Total packets processed: {packet_count}")
        print(f"Total output files created: {file_counter + 1}")

# 调用示例

# input_file = r"D:\work\lzf\datacapture\20240204\19\anshi19.pcap"
# input_file = r"E:\work\LZF\datacapture\20240205\qipan\32\qipan32.pcap"
# path = r'E:\work\LZF\datacapture\20240205\qipan\32'
# a_name = os.path.join(r'E:\work\LZF\datacapture\test_capture\2',str(i),file_name1)
# print(a_name)
        

import os
for i in range(1,14+1,1):    #range(1,n+1,1):从1到n每次增加1
    file_name1 = 'test%s.pcap' % (i)
    # input_file = os.path.join(r'D:\yuganwei\yys_test\test',str(i),file_name1)
    input_file = os.path.join(r'D:\yuganwei\yys_test\test',file_name1)
    starting_packet = 1  # 设置从第几个数据包开始检测
    split_pcap_by_packet(input_file, starting_packet)
print('successfully')



























# file_name = ['./camera','./ir']

# path = r'E:\work\LZF\datacapture\20240229\2\1'
# for name in file_name:
#     os.mkdir(path+name)






