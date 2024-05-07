import struct
import math
import numpy as np
from fxpmath import Fxp

#复数值存在txt里面
def generate_result_data(result_complex,output_file,isOut32b,if_rfft):
    output_string = ""
    temp_string   = ""
    complex_array = []
    for complex_num in result_complex:
        # 添加实部、虚部、实部、虚部到结果数组
        complex_array.extend([complex_num.real, complex_num.imag])



    for i in range(len(result_complex)):
        # 从复数中提取实部和虚部
        real_value      = int(result_complex[i].real)
        imaginary_value = int(result_complex[i].imag)

        if isOut32b==0:
            # 将实部和虚部转换为16位有符号数

            if if_rfft:
                real_bytes = struct.pack("<l", real_value)
                real_bytes = int.from_bytes(real_bytes, byteorder='little', signed=True)
                # real_bytes >>= 10
                real_dec = Fxp(real_bytes, signed=True, n_word=16, n_frac=0, overflow='saturate', rounding='floor')
                real_bytes = struct.pack("<h", int(real_dec))

                byte_list = list(real_bytes)
                # 将前两个字节和后两个字节相互交换位置
                byte_list[0], byte_list[1] = byte_list[1], byte_list[0]
                real_bytes = bytes(byte_list)

                # 将实部和虚部的字节添加到结果字符串
                # output_string = imaginary_bytes.hex() + real_bytes.hex() + output_string
                temp_string =  real_bytes.hex() + temp_string
                # 每4个复数换一行
                if (i + 1) % 8 == 0:
                    output_string += temp_string + "\n"
                    temp_string = ""
            else:
                real_bytes = struct.pack("<l", real_value)
                real_bytes = int.from_bytes(real_bytes, byteorder='little', signed=True)
                # real_bytes >>= 10
                real_dec = Fxp(real_bytes, signed=True, n_word=16, n_frac=0, overflow='saturate',rounding='floor')
                real_bytes = struct.pack("<h", int(real_dec))

                imaginary_bytes = struct.pack("<l", imaginary_value)
                imaginary_bytes = int.from_bytes(imaginary_bytes, byteorder='little', signed=True)
                # imaginary_bytes >>= 10
                imaginary_dec = Fxp(imaginary_bytes, signed=True, n_word=16, n_frac=0, overflow='saturate', rounding='floor')
                imaginary_bytes = struct.pack("<h", int(imaginary_dec))

                byte_list = list(real_bytes)
                # 将前两个字节和后两个字节相互交换位置
                byte_list[0], byte_list[1] =  byte_list[1], byte_list[0]
                real_bytes = bytes(byte_list)

                byte_list = list(imaginary_bytes)
                # 将前两个字节和后两个字节相互交换位置
                byte_list[0], byte_list[1] = byte_list[1], byte_list[0]
                imaginary_bytes = bytes(byte_list)

                # 将实部和虚部的字节添加到结果字符串
               # output_string = imaginary_bytes.hex() + real_bytes.hex() + output_string
                temp_string = imaginary_bytes.hex() + real_bytes.hex() + temp_string
                # 每4个复数换一行
                if (i + 1) % 4 == 0:
                    output_string +=temp_string + "\n"
                    temp_string=""

        else:
        # 将实部和虚部转换为32位有符号数
            real_bytes = struct.pack("<l", real_value)
            imaginary_bytes = struct.pack("<l", imaginary_value)
            # 将实部和虚部的字节添加到结果字符串
            # 将字节流转换为整数列表
            byte_list = list(real_bytes)
            # 将前两个字节和后两个字节相互交换位置
            byte_list[0], byte_list[1], byte_list[2], byte_list[3] = byte_list[3], byte_list[2], byte_list[1], byte_list[0]
            # 将交换后的字节列表转换回字节流
            real_bytes = bytes(byte_list)

            byte_list = list(imaginary_bytes)
            # 将前两个字节和后两个字节相互交换位置
            byte_list[0], byte_list[1], byte_list[2], byte_list[3] = byte_list[3], byte_list[2], byte_list[1], byte_list[0]
            # 将交换后的字节列表转换回字节流
            imaginary_bytes = bytes(byte_list)


            temp_string = imaginary_bytes.hex() + real_bytes.hex() + temp_string

            # 每4个复数换一行
            if (i + 1) % 2 == 0:
                output_string += temp_string + "\n"
                temp_string = ""

    # 将结果字符串保存到txt文件
    with open(output_file, "w") as file:
        file.write(output_string)

def generate_comp_data(result_complex,output_file,if_rfft):
    real_part = np.real(result_complex[:]).astype(int)
    arr_list = real_part.astype(str).tolist()

    with open(output_file, 'w') as file:
        if if_rfft==1:
            for i in range(0, len(arr_list),8):
                # 获取四个元素并颠倒顺序
                temp_str = ''.join(reversed(arr_list[i:i + 8]))
                # 转换为十六进制并添加0
                hex_str = hex(int(temp_str, 2))[2:]
                file.write(hex_str + '\n')

        else:
            for i in range(0, len(arr_list), 4):
                # 获取四个元素并颠倒顺序
                temp_str = ''.join(reversed(arr_list[i:i + 4]))
                # 转换为十六进制并添加0
                hex_str = '0' + hex(int(temp_str, 2))[2:]
                file.write(hex_str + '\n')

#将复数值存在txt里面
def write_complex_data(complex_array, output_file):
    with open(output_file, "w") as file:
        for complex_number in complex_array:
            real_part = int(complex_number.real)
            imag_part = int(complex_number.imag)
            file.write(f"{real_part} {imag_part}\n")

def write_int_data(int_array, output_file):
    with open(output_file, "w") as file:
        for int_number in int_array:
            file.write(f"{int_number}\n")

#使用正确的方式读入txt文件
def read_complex_data(input_file,if_rfft):
    # 从txt文件中读取数据
    with open(input_file, "rb") as file:  # 以二进制模式打开文件
        lines = file.readlines()

    complex_list = []

    # 解析每行数据并将其保存为复数
    decimal_value_array = [];

    for i, line in enumerate(lines):
        hex_numbers = line.strip().split()  # 去除首尾空白字符，并拆分成十六进制数列表
        hex_numbers = hex_numbers[:32]  # 取每行前32个十六进制数
        hex_numbers_str = ''.join([num.decode() for num in hex_numbers])   # 将hex_numbers列表转换为字符串


        for i in range(0, len(hex_numbers_str), 4):
            group = hex_numbers_str[i:i + 4]  # 每4个字符为一组

            decimal_value = int(group, 16)
            if decimal_value > 32767:  # 如果超过正数的最大值
                decimal_value -= 65536
            decimal_value_array.append(decimal_value); #一行所有整数的值

        reversed_array = []

        # 使用循环迭代每8个数，并将其内部进行前后颠倒
        for i in range(0, len(decimal_value_array), 8):
            segment = decimal_value_array[i:i + 8]
            reversed_segment = segment[::-1]
            reversed_array.extend(reversed_segment)

    if if_rfft:
        # 使用循环迭代每8个数，并将其内部进行前后颠倒
        # 提取实部和虚部
        real_parts = reversed_array
        imaginary_parts = reversed_array

        # 构造复数并保存到列表中
        for real, imaginary in zip(real_parts, imaginary_parts):
            complex_list.append(complex(real, imaginary*0))

    else:
        # 提取实部和虚部
        real_parts = reversed_array[0::2]
        imaginary_parts = reversed_array[1::2]

        # 构造复数并保存到列表中
        for real, imaginary in zip(real_parts, imaginary_parts):
            complex_list.append(complex(real, imaginary))

    # 转换为NumPy数组
    complex_array = np.array(complex_list, dtype=np.complex64)

    return complex_array

#使用正确的方式读入txt文件
def read_complex32_data(input_file):
    # 从txt文件中读取数据
    with open(input_file, "rb") as file:  # 以二进制模式打开文件
        lines = file.readlines()

    complex_list = []

    # 解析每行数据并将其保存为复数
    decimal_value_array = [];

    for i, line in enumerate(lines):
        hex_numbers = line.strip().split()  # 去除首尾空白字符，并拆分成十六进制数列表
        hex_numbers = hex_numbers[:32]      # 取每行前32个十六进制数
        hex_numbers_str = ''.join([num.decode() for num in hex_numbers])   # 将hex_numbers列表转换为字符串


        for i in range(0, len(hex_numbers_str), 8):
            group = hex_numbers_str[i:i + 8]  # 每4个字符为一组

            decimal_value = int(group, 16)
            if decimal_value > 2**32 - 1:  # 如果超过正数的最大值
                decimal_value -= 2**32
            decimal_value_array.append(decimal_value); #一行所有整数的值

        reversed_array = []

        # 使用循环迭代每8个数，并将其内部进行前后颠倒
        for i in range(0, len(decimal_value_array), 8):
            segment = decimal_value_array[i:i + 8]
            reversed_segment = segment[::-1]
            reversed_array.extend(reversed_segment)


    # 提取实部和虚部
    real_parts = reversed_array[0::2]
    imaginary_parts = reversed_array[1::2]

    # 构造复数并保存到列表中
    for real, imaginary in zip(real_parts, imaginary_parts):
        complex_list.append(complex(real, imaginary))

    # 转换为NumPy数组
    complex_array = np.array(complex_list, dtype=np.complex64)
    complex_array = complex_array/2**16

    return complex_array

def read_complex32GPT_data(filename):
    complex_array = []
    with open(filename, "r") as file:
        contents = file.read()
        lines = contents.split("\n")
        for line in lines:
            if line.strip() != "":

                imaginary_hex = line[16:24]
                real_hex = line[24:32]

                bytes_data = bytes.fromhex(imaginary_hex)
                # Reverse the byte order
                #reversed_bytes = bytes_data[::-1]
                # Convert the reversed bytes back to a hexadecimal string
                imaginary_hex_reversed = bytes_data.hex()

                bytes_data = bytes.fromhex(real_hex)
                # Reverse the byte order
                #reversed_bytes = bytes_data[::-1]
                # Convert the reversed bytes back to a hexadecimal string
                real_hex_reversed = bytes_data.hex()

                imaginary_value = int(imaginary_hex_reversed, 16)
                real_value = int(real_hex_reversed, 16)

                if imaginary_value > 2 ** 31 - 1:  # 如果超过正数的最大值
                    imaginary_value -= 2 ** 32

                if real_value > 2 ** 31 - 1:  # 如果超过正数的最大值
                    real_value -= 2 ** 32

                # imaginary_value = np.floor(imaginary_value / 2 ** 16)
                # real_value = np.floor(real_value / 2 ** 16)

                complex_number = complex(real_value, imaginary_value)
                complex_array.append(complex_number)

                imaginary_hex = line[:8]
                real_hex = line[8:16]

                bytes_data = bytes.fromhex(imaginary_hex)
                # Reverse the byte order
                #reversed_bytes = bytes_data[::-1]
                # Convert the reversed bytes back to a hexadecimal string
                imaginary_hex_reversed = bytes_data.hex()

                bytes_data = bytes.fromhex(real_hex)
                # Reverse the byte order
                #reversed_bytes = bytes_data[::-1]
                # Convert the reversed bytes back to a hexadecimal string
                real_hex_reversed = bytes_data.hex()

                imaginary_value = int(imaginary_hex_reversed, 16)
                real_value = int(real_hex_reversed, 16)

                if imaginary_value > 2 ** 31 - 1:  # 如果超过正数的最大值
                    imaginary_value -= 2 ** 32

                if real_value > 2 ** 31 - 1:  # 如果超过正数的最大值
                    real_value -= 2 ** 32

                # imaginary_value = np.floor(imaginary_value / 2 ** 16)
                # real_value = np.floor(real_value / 2 ** 16)

                complex_number = complex(real_value, imaginary_value)
                complex_array.append(complex_number)


    return complex_array
