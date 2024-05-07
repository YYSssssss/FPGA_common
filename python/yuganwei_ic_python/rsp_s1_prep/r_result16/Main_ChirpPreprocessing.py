import struct
import math
import numpy as np
import argparse
import read_txt
#import matplotlib.pyplot as plt
# from fxpmath import Fxp

if_test=1;

appro_abs=True

#去掉前面的符号位扩展bit

# def clip_data_list(data,left_num):
#
#
#     real_parts = np.real(data)
#     imaginary_parts = np.imag(data)
#
#     data_list = []
#
#     for i in range(len(real_parts)):
#
#         mask = hex(left_num)
#
#         # 将前 6 位移除，保留后 26 位
#         InDataReal = int(real_parts[i]) & mask
#
#         # 如果最高位为 1，将其转换为负值
#         if InDataReal & 2^left_num != 0:
#             InDataReal = -((InDataReal ^ mask) + 1)
#
#         # 将前 6 位移除，保留后 26 位
#         InDataImag = int(imaginary_parts[i]) & mask
#
#         # 如果最高位为 1，将其转换为负值
#         if InDataImag & 2^left_num != 0:
#             InDataImag = -((InDataImag ^ mask) + 1)
#
#         InDataComplex0 = float(InDataReal) + 1j * float(InDataImag)
#         data_list.append(InDataComplex0)
#
#     return data_list

def clip_data(data, left_num):
    mask = (1 << left_num) - 1

    # 将前 6 位移除，保留后 26 位
    InDataReal = int(data) & mask

    # 如果最高位为 1，将其转换为负值
    if InDataReal & (1 << (left_num - 1)) != 0:
        InDataReal = -((InDataReal ^ mask) + 1)

    return InDataReal

def fix_point(InDataUpper, fixed_point):
    if isinstance(InDataUpper, complex):
        real_sign = np.sign(np.real(InDataUpper))
        abs_real_part = abs(np.real(InDataUpper))
        real_part = (abs_real_part / (2.0 ** fixed_point) - np.trunc(abs_real_part / (2.0  ** fixed_point))) * (2.0  ** fixed_point) * real_sign

        if np.real(InDataUpper) > (2.0 ** fixed_point - 1.0):
            real_part = 2.0 ** fixed_point - 1.0

        if np.real(InDataUpper) <  -2 **  (fixed_point )   :
            real_part =  -2 **  (fixed_point)  +1

        imag_sign = np.sign(np.imag(InDataUpper))
        abs_imag_part = abs(np.imag(InDataUpper))
        imag_part = (abs_imag_part / (2.0 ** fixed_point) - np.trunc(abs_imag_part / (2.0 ** fixed_point))) * (2.0 ** fixed_point) * imag_sign

        if np.imag(InDataUpper) > 2 ** fixed_point - 1.0 :
            imag_part = 2 ** fixed_point - 1.0

        if np.imag(InDataUpper) < -2.0 ** (fixed_point )  :
            imag_part = -2 **  (fixed_point) +1.0

        temp2 = complex(real_part, imag_part)

        return temp2

    else:
        sign = np.sign(InDataUpper)
        abs_part = abs(InDataUpper)
        value = (abs_part / (2.0 ** fixed_point)) - np.trunc(abs_part / (2.0 ** fixed_point))
        fixed_point_value = value * (2.0 ** fixed_point) * sign

        if InDataUpper > 2.0 ** fixed_point - 1.0 :
            fixed_point_value = 2.0 ** fixed_point - 1.0

        if InDataUpper < -2.0 **  (fixed_point )   :
            fixed_point_value =  -2.0 **  (fixed_point) + 1.0

        return fixed_point_value


#打印结果
def generate_result_data(result_complex, output_file, isOut32b):
    output_string = ""
    temp_string = ""
    complex_array = []
    for complex_num in result_complex:

        complex_array.extend([complex_num.real, complex_num.imag])

    for i in range(len(result_complex)):

        real_value = int(result_complex[i].real)
        imaginary_value = int(result_complex[i].imag)

        if isOut32b == 0:

            real_bytes = struct.pack("<l", real_value)
            real_bytes = int.from_bytes(real_bytes, byteorder='little', signed=True)
            imaginary_bytes = struct.pack("<l", imaginary_value)
            imaginary_bytes = int.from_bytes(imaginary_bytes, byteorder='little', signed=True)

            real_dec = fix_point(real_bytes, 16)
            imaginary_dec = fix_point(imaginary_bytes, 16)

            real_bytes = struct.pack("<h", int(real_dec))
            imaginary_bytes = struct.pack("<h", int(imaginary_dec))

            byte_list = list(real_bytes)
            # 将前两个字节和后两个字节相互交换位置
            byte_list[0], byte_list[1] = byte_list[1], byte_list[0]
            real_bytes = bytes(byte_list)

            byte_list = list(imaginary_bytes)
            # 将前两个字节和后两个字节相互交换位置
            byte_list[0], byte_list[1] = byte_list[1], byte_list[0]
            imaginary_bytes = bytes(byte_list)

            # 将实部和虚部的字节添加到结果字符串
            temp_string = temp_string + imaginary_bytes.hex() + real_bytes.hex()

            # 每4个复数换一行
            if (i + 1) % 4 == 0:
                output_string += temp_string + ",\n"
                temp_string = ""

        else:

            real_bytes = struct.pack("<l", real_value)
            imaginary_bytes = struct.pack("<l", imaginary_value)

            byte_list = list(real_bytes)

            byte_list[0], byte_list[1], byte_list[2], byte_list[3] = byte_list[3], byte_list[2], byte_list[1], \
            byte_list[0]

            real_bytes = bytes(byte_list)

            byte_list = list(imaginary_bytes)

            byte_list[0], byte_list[1], byte_list[2], byte_list[3] = byte_list[3], byte_list[2], byte_list[1], \
            byte_list[0]

            imaginary_bytes = bytes(byte_list)

            temp_string = imaginary_bytes.hex() + real_bytes.hex() + temp_string

            # 每4个复数换一行
            if (i + 1) % 2 == 0:
                output_string += temp_string + ",\n"
                temp_string = ""

    # 将结果字符串保存到txt文件
    with open(output_file, "w") as file:
        file.write(output_string)

def complex_shift(current_frame,shift_num):
    frame_real = np.real(current_frame)
    frame_imag = np.imag(current_frame)

    shift_real = int(frame_real) >> shift_num
    shift_imag = int(frame_imag) >> shift_num

    average_current_shifted = complex(shift_real, shift_imag)

    return average_current_shifted

def ADC_Offset_Calculation_and_Compensation(X, average_previous_frame, if_rfft,is_32):

    fix_point_numpy = np.frompyfunc(fix_point, 2, 1)

    if is_32:
        X = fix_point_numpy(X, 31)
    else:
        X = fix_point_numpy(X, 15)

    if if_rfft:
        Y=X-np.real(average_previous_frame)-np.imag(average_previous_frame)
    else:
        Y = X - average_previous_frame

    if is_32:
        Y = fix_point_numpy(Y, 31)
    else:
        Y = fix_point_numpy(Y, 15)

    return Y

def custom_diff(numbers):
    if len(numbers) < 2:
        return numbers

    result = []
    for i in range(len(numbers) - 1):
        result.append(numbers[i+1] - numbers[i])

    result.insert(0, result[0])

    return result


#10月19日更改位宽
def RX_Path_Compensation(X,read_array_txt , if_rfft,is_32):
    data_length = len(X)
    InData = np.zeros(data_length, dtype=complex)

    loaded_complex_array = np.load(read_array_txt, allow_pickle=True)

    IndexUpper = 0
    count = 0  # 添加计数器
    count_big = 0  # 添加计数器

    X_Size = len(X)
    phase_array = phase_gen(X_Size, 1, 0)


    t1_list = X.copy()
    t2_list = X.copy()
    t3_list = X.copy()
    t4_list = X.copy()
    t5_list = X.copy()

    t3_clip_list = X.copy()
    t4_clip_list = X.copy()
    t5_clip_list = X.copy()

    for num in X:


        factor_count = phase_array[count_big]
        index = (factor_count - 1) % 1024
        factor = loaded_complex_array[index];
        # factor /= 2 ** 23;

        if if_rfft:
            a = np.real(num)
            b = np.real(factor)

            if is_32:
                a = fix_point(a, 31)
            else:
                a = fix_point(a, 15)

            b = fix_point(b, 23)

            t7 = a * b

            if is_32:
                InData[IndexUpper] = fix_point(t7, 31)
            else:
                InData[IndexUpper] = fix_point(t7, 15)

        else:
            a = np.real(num)
            b = np.imag(num)

            c = np.real(factor)
            d = np.imag(factor)

            if is_32:
                a = fix_point(a, 31)
                b = fix_point(b, 31)
            else:
                a = fix_point(a, 15)
                b = fix_point(b, 15)

            c = fix_point(c, 23)
            d = fix_point(d, 23)

            t1 = a + b
            t2 = c - d

            t3 = a * d
            t4 = b * c
            t5 = t1 * t2

            t1_list[IndexUpper] = t1;
            t2_list[IndexUpper] = t2;


            t3 = int(t3) >> 23;
            t4 = int(t4) >> 23;
            t5 = int(t5) >> 23;

            t3_list[IndexUpper] = t3;
            t4_list[IndexUpper] = t4;
            t5_list[IndexUpper] = t5;

            if is_32:
                t3 = clip_data(t3, 30);
                t4 = clip_data(t4, 30);
                t5 = clip_data(t5, 31);
            else:
                t3 = clip_data(t3, 14);
                t4 = clip_data(t4, 14);
                t5 = clip_data(t5, 15);

            t3_clip_list[IndexUpper] = t3;
            t4_clip_list[IndexUpper] = t4;
            t5_clip_list[IndexUpper] = t5;

            t6 = t3 - t4
            t7 = t5 + t6
            t8 = t3 + t4

            # temp_real = fix_point(t7, 16)
            # temp_imag = fix_point(t8, 16)

            if is_32:
                InData[IndexUpper] = fix_point(t7 + 1j * t8, 31)
            else:
                InData[IndexUpper] = fix_point(t7 + 1j * t8, 15)

        count += 1  # 增加计数器
        IndexUpper +=1
        if count == 1:  # 在每4轮后增加IndexUpper
            count_big += 1
            count = 0

    if if_test:
        read_txt.write_complex_data(loaded_complex_array, "twiddle_complex.txt");
        read_txt.write_complex_data(t1_list, "t1_list.txt");
        read_txt.write_complex_data(t2_list, "t2_list.txt");
        read_txt.write_complex_data(t3_list, "t3_list.txt");
        read_txt.write_complex_data(t4_list, "t4_list.txt");
        read_txt.write_complex_data(t5_list, "t5_list.txt");
        read_txt.generate_result_data(t3_clip_list, "t3_clip_list.txt", is_32, if_rfft);
        read_txt.generate_result_data(t4_clip_list, "t4_clip_list.txt", is_32, if_rfft);
        read_txt.generate_result_data(t5_clip_list, "t5_clip_list.txt", is_32, if_rfft);



    return InData



#以绝对值作为标准，通过阈值进行筛选
def Non_Linear_Filter_1(X,INTF1,if_rfft,is_32):


    fix_point_vectorized = np.vectorize(fix_point)

    if is_32:
        X = fix_point_vectorized(X, 31);
    else:
        X = fix_point_vectorized(X, 15);

    Z = X.copy()
    X_a = X.copy()
    X_b = X.copy()
    X_c = X.copy()
    X_d = X.copy()
    X_temp = X.copy()

    N_samples_per_chirp = len(X)

    if appro_abs:
        shape =  Z.shape
        for idx in range(shape[0]):

            U = max(abs(Z[idx].real), abs(Z[idx].imag));
            V = min(abs(Z[idx].real), abs(Z[idx].imag));
            a=U;
            b=math.floor(V/8);
            c=U-math.floor(U/8);
            d=math.floor(V/2);

            X_a[idx] = a;
            X_b[idx] = b;
            X_c[idx] = c;
            X_d[idx] = d;
            Z[idx] = max(a+b, c+d);

        Y = Z

    else:
        Y = np.abs( Z)

    if is_32:
        Y = fix_point_vectorized(Y, 32);
    else:
        Y = fix_point_vectorized(Y, 16);

    if if_test:
        read_txt.generate_result_data(Y  , "ABS1.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_a, "ABS1_a.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_b, "ABS1_b.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_c, "ABS1_c.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_d, "ABS1_d.txt", is_32,if_rfft);

        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("ABS1.txt")
        else:
            txt_modify = read_txt.read_complex_data("ABS1.txt", if_rfft)
        read_txt.write_complex_data(txt_modify, "ABS1_read.txt")

        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("ABS1_a.txt")
        else:
            txt_modify = read_txt.read_complex_data("ABS1_a.txt", if_rfft)
        read_txt.write_complex_data(txt_modify, "AABS1_a_read.txt")

        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("ABS1_b.txt")
        else:
            txt_modify = read_txt.read_complex_data("ABS1_b.txt", if_rfft)
        read_txt.write_complex_data(txt_modify, "AABS1_b_read.txt")

        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("ABS1_c.txt")
        else:
            txt_modify = read_txt.read_complex_data("ABS1_c.txt", if_rfft)
        read_txt.write_complex_data(txt_modify, "AABS1_c_read.txt")

        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("ABS1_d.txt")
        else:
            txt_modify = read_txt.read_complex_data("ABS1_d.txt", if_rfft)
        read_txt.write_complex_data(txt_modify, "AABS1_d_read.txt")



    Y =  Z

    v = np.mean(Y)


    print(f"绝对值的平均值是 {v}")



    X_array = np.ones(len(X_temp))
    for ith_sample in range(N_samples_per_chirp):
        if Y[ith_sample] > INTF1:
            X_temp[ith_sample] = 0
            X_array[ith_sample] = 0

    fix_point_vectorized = np.vectorize(fix_point)

    if is_32:
        X_temp = fix_point_vectorized(X_temp, 31);
    else:
        X_temp = fix_point_vectorized(X_temp, 15);



    return X_temp,X_array

#以差分作为标准，通过阈值进行筛选
def Non_Linear_Filter_2(X, INTF2,if_rfft,is_32):

    fix_point_vectorized = np.vectorize(fix_point)


    if is_32:
        X = fix_point_vectorized(X, 31);
    else:
        X = fix_point_vectorized(X, 15);


    Z   = X.copy()
    X_a = X.copy()
    X_b = X.copy()
    X_c = X.copy()
    X_d = X.copy()

    X_temp = X.copy()
    X_diff=custom_diff(Z)

    if is_32:
        X_diff = fix_point_vectorized(X_diff, 31);
    else:
        X_diff = fix_point_vectorized(X_diff, 15);

    if if_test:
        read_txt.generate_result_data(X_diff, "X_diff.txt", is_32,if_rfft);
        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("X_diff.txt")
        else:
            txt_modify = read_txt.read_complex_data("X_diff.txt", if_rfft)
        read_txt.write_complex_data(X_diff, "X_diff_read.txt")

    if  appro_abs:
        shape = X_diff.shape
        for idx in range(shape[0]):
            U=max(abs(X_diff[idx].real),abs(X_diff[idx].imag));
            V=min(abs(X_diff[idx].real),abs(X_diff[idx].imag));

            a = U;
            b = math.floor(V / 8);
            c = U - math.floor(U / 8);
            d = math.floor(V / 2);

            X_a[idx] = a ;
            X_b[idx] = b ;
            X_c[idx] = c ;
            X_d[idx] = d ;
            X_diff[idx] = max(a+b, c+d);

        Y = X_diff
    else:
        Y = np.abs(np.diff(Z))

    if is_32:
        Y = fix_point_vectorized(Y, 32)
    else:
        Y = fix_point_vectorized(Y, 16)

    if if_test:
        read_txt.generate_result_data(Y, "ABS2.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_a, "ABS2_a.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_b, "ABS2_b.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_c, "ABS2_c.txt", is_32,if_rfft);
        read_txt.generate_result_data(X_d, "ABS2_d.txt", is_32,if_rfft);
        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("ABS2.txt")
        else:
            txt_modify = read_txt.read_complex_data("ABS2.txt", if_rfft)
        read_txt.write_complex_data(txt_modify, "ABS2_read.txt")



    # the mean of the magnitude of derivative of input X for the
    v = np.mean(Y)

    # For physical RX channel j within a chirp
    N_samples_per_chirp = len(X)

    # threshold = b * v

    X_array = np.ones(len(X_temp))
    for ith_sample in range(N_samples_per_chirp):
        if Y[ith_sample] > INTF2:
            X_temp[ith_sample] = 0
            X_array[ith_sample] = 0

    # X_temp[-1] = X_temp[-2]
    # X_array[-1] = X_array[-2]
    fix_point_vectorized = np.vectorize(fix_point)

    if is_32:
        X_temp = fix_point_vectorized(X_temp, 31)
    else:
        X_temp = fix_point_vectorized(X_temp, 15)

    return X_temp,X_array

#求平均值后乘以系数，作为阈值
def process_data(X, scale,is_32):

    total_sum = np.sum(X, dtype=np.complex128)
    # total_sum_real = np.sum(np.abs(X.real), dtype=np.int64)
    # total_sum_imag = np.sum(np.abs(X.imag), dtype=np.int64)

    # total_sum4 = total_sum_real + total_sum_imag
    # golden_average = total_sum / len(X)
    # total_sum_40 = fix_point(total_sum, 39)

    average_current_frame = total_sum * scale

    average_current_frame_56 = fix_point(average_current_frame, 56)
    average_current_frame_40 = complex_shift(average_current_frame_56, 16)

    programemable_right_shift = 8

    average_current_frame_out = complex_shift(average_current_frame_40, programemable_right_shift)

    if is_32:
        result = fix_point(average_current_frame_out, 31);
    else:
        result = fix_point(average_current_frame_out, 15);

    # 返回 result 作为函数的结果
    return result


#phase_gen对应的相位生成模块
def phase_gen(array_size,k, b):
    x_values = list(range(1, array_size+1))  # 生成 x 值，从 1 到 1024
    y_values = [k * x + b for x in x_values]  # 使用给定的 k 和 b 计算 y 值
    return y_values

def main(args):


    input_txt = args.input_txt;
    read_array_txt= args.read_array_txt;
    data_num= args.data_num;

    if_rfft=args.i_is_real;
    threshold=args.i_intf_cmp;
    dc_est_scale=args.i_dc_est_scale
    intf_est_scale = args.i_intf_est_scale
    FFT_Hex_Output_txt = args.FFT_Hex_Output_txt
    is_32=args.i_is_32

    U_complex = args.i_dc_u[1] + 1j * args.i_dc_u[0] #送入的直流分量

    hex_str = args.i_phase_w

    if is_32:
        data_length = data_num*4*(1+if_rfft)/2
    else:
        data_length = data_num*4* (1 + if_rfft)

    data_length=int(data_length)

    # the number of Rx channels
    N_Rx_Channel = 1
    # the number of chirps per frame
    N_chirps_per_frame = 1
    # the number of ADC samples per chirp per RX channel is 256 complex values
    N_samples_per_chirp = data_length
    # Complex Data, 16s


    #Allocate array size
    DataRe = np.full((N_Rx_Channel, N_chirps_per_frame, int(N_samples_per_chirp)), 1000)
    DataIm = np.full((N_Rx_Channel, N_chirps_per_frame, int(N_samples_per_chirp)), 1000)
    DataIn = DataRe + 1j * DataIm
    DataADCOffsetCompensation = np.zeros_like(DataIn)
    DataRxPathCompensation = np.zeros_like(DataIn)
    DataNonLinearFiltered = np.zeros_like(DataIn)

    #read in data
    if is_32:
        data = read_txt.read_complex32GPT_data(input_txt);
    else:
        data = read_txt.read_complex_data(input_txt, if_rfft);


    #如果脚本是测试模式，那么打印中间结果
    if if_test:
        read_txt.generate_result_data(data, "X-data.txt", is_32,if_rfft);
        if is_32:
            txt_modify = read_txt.read_complex32GPT_data("X-data.txt")
        else:
            txt_modify = read_txt.read_complex_data("X-data.txt", 0)
        read_txt.write_complex_data(txt_modify, "X-data_read.txt")



    for jth_RX in range(N_Rx_Channel):

        #利用平均值来算阈值的模块
        is_INTF_computed=False;
        a_fa=data; #赋给另一个值 防止中途对data进行篡改

        if is_INTF_computed:
            U_complex =process_data(a_fa, dc_est_scale,is_32)  #求平均值 乘以系数
            INTF1_complex     = process_data(a_fa, intf_est_scale,is_32)
            INTF2_complex     = process_data(a_fa, intf_est_scale,is_32)
            INTF1 = np.real(INTF1_complex)
            INTF2 = np.real(INTF2_complex)
        else:
            INTF1 = 1700000000;
            INTF2 = 1700000000;


        b_fa=U_complex;

        # 检查 result 的类型
        if isinstance(U_complex, complex):
            # 如果 result 是复数
            print("U is a complex number:", U_complex)
        else:
            # 如果 result 是实数
            print("U is a real number:", U_complex)

            # 检查 result 的类型
        if isinstance(U_complex, complex):
            # 如果 result 是复数
            print("INTF1 is a complex number:", INTF1)
        else:
            # 如果 result 是实数
            print("INTF1 is a real number:", INTF1)


        #去除直流分量
        a_ra = ADC_Offset_Calculation_and_Compensation(a_fa,U_complex, if_rfft,is_32)


        if if_test:
            if b_fa != 0:
                read_txt.generate_result_data(a_ra, "X-u.txt", is_32,if_rfft);

                if is_32:
                    txt_modify = read_txt.read_complex32GPT_data("X-u.txt")
                else:
                    txt_modify = read_txt.read_complex_data("X-u.txt", if_rfft)

                read_txt.write_complex_data(txt_modify, "X-u_read.txt")


        #数据加入对应的通道中
        DataADCOffsetCompensation[jth_RX, :, :]  =a_ra.reshape(1, data_length)



        for mth_Chirp in range(N_chirps_per_frame):

            #从某个通道和chirp中拿出数据
            data_temp2 = DataADCOffsetCompensation[jth_RX, mth_Chirp, :];

            NonLinearFilter1Enable = 1
            NonLinearFilter2Enable = 1


            if b_fa != 0:
                if NonLinearFilter1Enable == 1:
                    # Non_Linear Filter 1   输出处理后的数据和记录被清理的位置的数组cmp_array
                    DataNonLinearFiltered[jth_RX, mth_Chirp, :], cmp_array1 = Non_Linear_Filter_1(data_temp2,INTF1,
                                                                                                  if_rfft,is_32)

                if NonLinearFilter2Enable == 1:
                    # Non_Linear Filter 2  输出处理后的数据和记录被清理的位置的数组cmp_array
                    DataNonLinearFiltered[jth_RX, mth_Chirp, :], cmp_array2 = Non_Linear_Filter_2(data_temp2,INTF2,
                                                                                                  if_rfft,is_32)

            for i in range(len(cmp_array1)):
                cmp_array1[i]=int(cmp_array1[i])
                cmp_array2[i]=int(cmp_array2[i])


            str_array = ''.join([str(int(x)) for x in cmp_array1])

            if if_test:
                with open('cmp_array1.txt', 'w') as file:
                    file.write(str_array)

                str_array = ''.join([str(int(x)) for x in cmp_array2])

                with open('cmp_array2.txt', 'w') as file:
                    file.write(str_array)


            cmp_and=cmp_array1[:]+1-1;
            for i in range(len(cmp_array1)):
                cmp_and[i]=int(cmp_array1[i]*cmp_array2[i])   #两个数组相乘，只要其中一个数组位置是0，那么相乘结果cmp_and就是0。

            if if_test:
                read_txt.generate_comp_data(cmp_array1,"cmp_array1_square.txt",if_rfft,is_32);
                read_txt.generate_comp_data(cmp_array2, "cmp_array2_square.txt",if_rfft,is_32);
                read_txt.generate_comp_data(cmp_and, "cmp_and_square.txt",if_rfft,is_32);

            data_comp=a_ra[:]+1-1
            for i in range(len(cmp_and)):
                if  cmp_and[i] ==0:
                    data_comp[i] =0;  #根据两个数组相乘结果，把cmp_and是0位置上的复数值清零

            if if_test:
                read_txt.generate_result_data(data_comp, "X_comp.txt", is_32,if_rfft);
                if is_32:
                    txt_modify = read_txt.read_complex32GPT_data("X_comp.txt")
                else:
                    txt_modify = read_txt.read_complex_data("X_comp.txt", if_rfft)
                read_txt.write_complex_data(txt_modify, "X_comp_read.txt")

            multi_sub=1;

            # 用multi_sub选择是要清零后的结果乘以W，还是直接仅仅去直流的结果乘以W
            if multi_sub==1:
                data_temp1 = data_comp
                DataRxPathCompensation[jth_RX, mth_Chirp, :] = RX_Path_Compensation(data_temp1,read_array_txt,if_rfft,is_32) +1 -1
            else:
                data_temp1 = a_ra
                DataRxPathCompensation[jth_RX, mth_Chirp, :] = RX_Path_Compensation(data_temp1,read_array_txt,if_rfft,is_32) +1 -1

            data_temp2=DataRxPathCompensation[jth_RX, mth_Chirp, :]; #这是模块的整体计算结果

            read_txt.generate_result_data(data_temp2, "XW.txt", is_32, if_rfft);
            read_txt.generate_result_data(data_temp2, FFT_Hex_Output_txt, is_32, if_rfft);


            if if_test:
                if is_32:
                    txt_modify = read_txt.read_complex32GPT_data("XW.txt")
                else:
                    txt_modify = read_txt.read_complex_data("XW.txt",if_rfft)
                read_txt.write_complex_data(txt_modify, "XW_read.txt")

if __name__ == '__main__':

    parser = argparse.ArgumentParser()

    #input文件的地址
    parser.add_argument('--input_txt', type=str, default="rsp_s1_op_mst_a_1.txt", help='Path of the input file')
    # output文件的地址
    parser.add_argument('--FFT_Hex_Output_txt', type=str, default="rsp_s1_op_mst_a_1_Output.txt",help='Path for result file output')
    # 旋转因子W文件的地址
    parser.add_argument('--read_array_txt', type=str, default="complex_array.npy",help='Path for result file output')
    # 整个 op 每次要读写总的数据量
    parser.add_argument('--data_num', type=int, default=1024, help='')
    # 求直流时乘以的系数
    parser.add_argument('--i_dc_est_scale', type=int, default=65536, help='')
    # 求阈值时乘以的系数
    parser.add_argument('--i_intf_est_scale', type=int, default=80000, help='')
    # 直流固定值
    parser.add_argument('--i_dc_u', type=int, nargs=2, default=[118, 420],
                        help='Subtract U, the first is the imaginary part, and the second is the real part, both are 16-bit decimal numbers')
    # 阈值固定值
    parser.add_argument('--i_intf_cmp', type=int, default=657, help='Threshold INTF')
    # W固定值
    parser.add_argument('--i_phase_w', type=str, default="02000200", help='Coefficient W')
    # 是否处理的是实数
    parser.add_argument('--i_is_real', type=int, default=1,
                        help='Fill in 1 for real operation, and 0 for complex operation')

    # 是否处理的32位
    parser.add_argument('--i_is_32', type=int, default=0,
                        help='Fill in 1 for 32, and 0 for 16')

    args = parser.parse_args()

    main(args)

