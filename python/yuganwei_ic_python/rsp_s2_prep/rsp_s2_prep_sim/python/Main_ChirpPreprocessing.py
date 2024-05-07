import struct
import math
import numpy as np
import argparse
import read_txt
#import matplotlib.pyplot as plt
# from fxpmath import Fxp

if_rfft=0;


#将能量过高的数据变成0

appro_abs=True



def fix_point(InDataUpper, fixed_point):
    # if isinstance(InDataUpper, complex):
    #     real_sign =np.sign(np.real(InDataUpper))
    #     abs_real_part = abs(np.real(InDataUpper))
    #     real_part = (abs_real_part / (2 ** fixed_point) - np.trunc(abs_real_part / (2 ** fixed_point))) * (2 ** fixed_point) * real_sign
    #
    #     imag_sign = np.sign(np.imag(InDataUpper))
    #     abs_imag_part=abs(np.imag(InDataUpper))
    #     imag_part = (abs_imag_part / (2 ** fixed_point) - np.trunc(abs_imag_part / (2 ** fixed_point))) * (2 ** fixed_point)* imag_sign
    #     temp2 = complex(real_part, imag_part)
    #
    #     return temp2
    # else:
    #     real_sign = np.sign(InDataUpper)
    #     abs_real_part = abs(InDataUpper)
    #     real_part = (abs_real_part / (2 ** fixed_point) - np.trunc(abs_real_part / (2 ** fixed_point))) * (2 ** fixed_point)* real_sign
    #     return real_part

    if isinstance(InDataUpper, complex):
        real_sign = np.sign(np.real(InDataUpper))
        abs_real_part = abs(np.real(InDataUpper))
        real_part = (abs_real_part / (2 ** fixed_point) - np.trunc(abs_real_part / (2 ** fixed_point ))) * (2 ** fixed_point ) * real_sign
        if np.real(InDataUpper)<-2 ** fixed_point and  real_part ==0 and real_sign==-1:
            real_part=-2 ** fixed_point

        imag_sign = np.sign(np.imag(InDataUpper))
        abs_imag_part = abs(np.imag(InDataUpper))
        imag_part = (abs_imag_part / (2 ** fixed_point ) - np.trunc(abs_imag_part / (2 ** fixed_point ))) * (2 ** fixed_point ) * imag_sign
        if np.imag(InDataUpper) < -2 ** fixed_point and imag_part == 0 and imag_sign==-1:
            imag_part = -2 ** fixed_point

        temp2 = complex(real_part, imag_part)

        return temp2
    else:
        sign = np.sign(InDataUpper)
        abs_part = abs(InDataUpper)
        value = (abs_part / (2 ** fixed_point )) - np.floor(abs_part / (2 ** fixed_point ))
        a=abs_part / (2 ** fixed_point );
        b=abs_part / (2 ** fixed_point );
        fixed_point_value = value * (2 ** fixed_point ) * sign
        if InDataUpper<-2 ** fixed_point and  fixed_point_value ==0 and sign==-1:
            fixed_point_value=-2 ** fixed_point

        return fixed_point_value

def generate_result_data(result_complex, output_file, isOut32b):
    output_string = ""
    temp_string = ""
    complex_array = []
    for complex_num in result_complex:
        # 添加实部、虚部、实部、虚部到结果数组
        complex_array.extend([complex_num.real, complex_num.imag])

    for i in range(len(result_complex)):
        # 从复数中提取实部和虚部
        real_value = int(result_complex[i].real)
        imaginary_value = int(result_complex[i].imag)

        if isOut32b == 0:
            # 将实部和虚部转换为16位有符号数
            real_bytes = struct.pack("<l", real_value)
            real_bytes = int.from_bytes(real_bytes, byteorder='little', signed=True)
            imaginary_bytes = struct.pack("<l", imaginary_value)
            imaginary_bytes = int.from_bytes(imaginary_bytes, byteorder='little', signed=True)

            real_dec = fix_point(real_bytes, 16)
            imaginary_dec = fix_point(imaginary_bytes, 16)
            # real_dec = Fxp(real_bytes, signed=True, n_word=16, n_frac=0, overflow='saturate', rounding='floor')
            # imaginary_dec = Fxp(imaginary_bytes, signed=True, n_word=16, n_frac=0, overflow='saturate',rounding='floor')
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
            # output_string = imaginary_bytes.hex() + real_bytes.hex() + output_string
            temp_string = temp_string + imaginary_bytes.hex() + real_bytes.hex()

            # 每4个复数换一行
            if (i + 1) % 4 == 0:
                output_string += temp_string + ",\n"
                temp_string = ""

        else:
            # 将实部和虚部转换为32位有符号数
            real_bytes = struct.pack("<l", real_value)
            imaginary_bytes = struct.pack("<l", imaginary_value)
            # 将实部和虚部的字节添加到结果字符串
            # 将字节流转换为整数列表
            byte_list = list(real_bytes)
            # 将前两个字节和后两个字节相互交换位置
            byte_list[0], byte_list[1], byte_list[2], byte_list[3] = byte_list[3], byte_list[2], byte_list[1], \
            byte_list[0]
            # 将交换后的字节列表转换回字节流
            real_bytes = bytes(byte_list)

            byte_list = list(imaginary_bytes)
            # 将前两个字节和后两个字节相互交换位置
            byte_list[0], byte_list[1], byte_list[2], byte_list[3] = byte_list[3], byte_list[2], byte_list[1], \
            byte_list[0]
            # 将交换后的字节列表转换回字节流
            imaginary_bytes = bytes(byte_list)

            temp_string = imaginary_bytes.hex() + real_bytes.hex() + temp_string

            # 每4个复数换一行
            if (i + 1) % 2 == 0:
                output_string += temp_string + ",\n"
                temp_string = ""

    # 将结果字符串保存到txt文件
    with open(output_file, "w") as file:
        file.write(output_string)


# def generate_data():
#     array = []
#
#     for i in range(1, 1025):
#         array += [i] * 4
#
#     complex_array = [complex(num, 0) for num in array]
#
#     generate_result_data(complex_array, "output.txt", 0,if_rfft)
#
#     return array


def complex_shift(current_frame,shift_num):
    frame_real = np.real(current_frame)
    frame_imag = np.imag(current_frame)

    shift_real = int(frame_real) >> shift_num
    shift_imag = int(frame_imag) >> shift_num

    average_current_shifted = np.complex(shift_real, shift_imag)

    return average_current_shifted


def ADC_Offset_Calculation_and_Compensation(X, average_previous_frame, if_rfft):

    # fix_point_vectorized = np.vectorize(fix_point)
    # X = fix_point_vectorized(X, 15)
    # X = np.array(X)

    fix_point_numpy = np.frompyfunc(fix_point, 2, 1)
    X = fix_point_numpy(X, 15)

    # sum_real = np.sum(X_real, dtype=np.int64)
    # total_sum2 = 0.0
    # for element in X:
    #     total_sum2 += abs(element)

    total_sum = np.sum(X, dtype=np.complex128)

    total_sum_real = np.sum(np.abs(X.real), dtype=np.int64)
    total_sum_imag = np.sum(np.abs(X.imag), dtype=np.int64)

    total_sum4 = total_sum_real + total_sum_imag

    golden_average=total_sum/len(X)


    total_sum_40 = fix_point(total_sum, 39)
    intfest_scale = 2**16;

    if if_rfft:
        Y=X-np.real(average_previous_frame)
    else:
        Y = X - average_previous_frame

    average_current_frame = total_sum * intfest_scale  #乘以INTFEST_SCALAE后

    average_current_frame_56=fix_point(average_current_frame, 56)  #定点化56

    average_current_frame_40=complex_shift(average_current_frame_56,16)  #移位16

    programemable_right_shift=8;

    average_current_frame_out = complex_shift(average_current_frame_40, programemable_right_shift)  #自定义移位

    result = fix_point_numpy(average_current_frame_out, 15)      #输出定点化为16位

    # average_shift=[];
    #
    # for i in range(6,28):
    #     average_current_shift_temp = int(average_current_shift_40) >> i
    #     new_bit=40-i;
    #     modify_bit=16-new_bit;
    #     average_current_shift_temp2 =average_current_shift_temp*2**modify_bit;
    #     average_shift.append(average_current_shift_temp2)
    #
    # average_error=abs(average_shift-golden_average)
    #
    # plt.figure()
    # plt.plot(range(6, 28), average_error)
    # plt.legend(['Self-defined', 'Standard'])
    # plt.title('Self-defined Log2( )')
    # fix_point_vectorized = np.vectorize(fix_point)
    # Y = fix_point_vectorized(Y, 15)

    return Y, result
#数组相减

def custom_diff(numbers):
    if len(numbers) < 2:
        return numbers  # 如果列表包含少于2个元素，则直接返回

    result = []
    for i in range(len(numbers) - 1):
        result.append(numbers[i+1] - numbers[i])

    result.append(result[-1])  # 复制前一个差分值作为最后一个元素的值

    return result

def RX_Path_Compensation(X, factor,if_rfft): #复数乘法器
    # the ADC samples after RX path compensation


    data_length = len(X)
    InData = np.zeros(data_length, dtype=complex)  # 创建长度为len的复数数组，初始值为0

    IndexUpper=0
    
    for num in X:
        if if_rfft:
            a = np.real(num);
            b = np.real(factor);

            a = fix_point(a, 15);
            b = fix_point(b, 15);

            t7=a*b;

            InData[IndexUpper] = fix_point(t7 , 15)

            IndexUpper = IndexUpper + 1

        else:
            #  需要测试的值 a= -320   b= -512    看结果是 80 还是 00
            a   = np.real(num);
            b   = np.imag(num);

            # a = -320;
            # b = -512;

            c   = np.real(factor);
            d   = np.imag(factor);

            a = fix_point(a, 15)
            b = fix_point(b, 15)
            c = fix_point(c, 15)
            d = fix_point(d, 15)

            t1 = a + b
            t2 = c - d

            t3 = a * d
            t4 = b * c
            t5 = t1 * t2

            # t3 = math.floor(a * d)
            # t4 = math.floor(b * c)
            # t5 = math.floor(t1 * t2)
            # t3 = (t3 / (2 ** 23) - math.trunc(t3 / (2 ** 23))) * (2 ** 23)
            # t4 = (t4 / (2 ** 23) - math.trunc(t4 / (2 ** 23))) * (2 ** 23)
            # t5 = (t5 / (2 ** 24) - math.trunc(t5 / (2 ** 24))) * (2 ** 24)
            #

            t6 = t3 - t4
            t7 = t5 + t6
            t8 = t3 + t4

            # Fxp(t7 + 1j * t8, signed=True, n_word=26, n_frac=0, overflow='saturate', rounding='floor')

            temp_real=fix_point(t7, 15)
            temp_imag = fix_point(t8, 15)
            InData[IndexUpper] = fix_point(t7 + 1j * t8, 15)

            IndexUpper = IndexUpper + 1

    # imaginary_bytes >>= 10
    # imaginary_dec = Fxp(imaginary_bytes, signed=True, n_word=16, n_frac=0, overflow='saturate', rounding='floor')
    # Y = real_part + 1j * imag_part

    return InData

def Non_Linear_Filter_2(X, b,if_rfft):
    # the ADC samples after non-linear filter 2

    fix_point_vectorized = np.vectorize(fix_point)
    X = fix_point_vectorized(X, 15)

    Z = X.copy()
    X_a = X.copy()
    X_b = X.copy()
    X_c = X.copy()
    X_d = X.copy()

    X_temp = X.copy()
    # the magnitude of the derivative of input X
    # the dimension of Y is one smaller than the dimension of X

    X_diff=custom_diff(Z)

    X_diff = fix_point_vectorized(X_diff, 15)
    read_txt.generate_result_data(X_diff, "X_diff.txt", 0,if_rfft);
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


            #X_diff[idx] = max(U + V / 8, U / 8 * 7 + V / 2)

        Y = X_diff
    else:
        Y = np.abs(np.diff(Z))


    Y = fix_point_vectorized(Y, 15)
    read_txt.generate_result_data(Y, "ABS2.txt", 0,if_rfft);
    read_txt.generate_result_data(X_a, "ABS2_a.txt", 0,if_rfft);
    read_txt.generate_result_data(X_b, "ABS2_b.txt", 0,if_rfft);
    read_txt.generate_result_data(X_c, "ABS2_c.txt", 0,if_rfft);
    read_txt.generate_result_data(X_d, "ABS2_d.txt", 0,if_rfft);
    txt_modify = read_txt.read_complex_data("ABS2.txt", if_rfft)
    read_txt.write_complex_data(txt_modify, "ABS2_read.txt")


    # the mean of the magnitude of derivative of input X for the
    v = np.mean(Y)

    # For physical RX channel j within a chirp
    N_samples_per_chirp = len(X)

    # threshold = b * v
    threshold = 1000

    X_array = np.ones(len(X_temp))
    for ith_sample in range(N_samples_per_chirp - 1):
        if Y[ith_sample] > threshold:
            X_temp[ith_sample] = 0
            X_array[ith_sample] = 0

    X_temp[-1] = X_temp[-2]
    X_array[-1] = X_array[-2]
    fix_point_vectorized = np.vectorize(fix_point)
    X_temp2 = fix_point_vectorized(X_temp, 15)

    return X_temp,X_array
#取绝对值 然后比较阈值

def Non_Linear_Filter_1(X, a,if_rfft):
    # the ADC samples after non-linear filter 1

    fix_point_vectorized = np.vectorize(fix_point)
    X = fix_point_vectorized(X, 15)
    Z = X.copy()
    X_a = X.copy()
    X_b = X.copy()
    X_c = X.copy()
    X_d = X.copy()
    X_temp = X.copy()

    # For physical RX channel j within a chirp
    N_samples_per_chirp = len(X)

    # the magnitude of input X
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

            # Z[idx] = max(U +V/8, U/8 * 7 + V / 2)
        Y =   Z

    else:
        Y = np.abs( Z)

    Y = fix_point_vectorized(Y, 15)
    read_txt.generate_result_data(Y, "ABS1.txt", 0,if_rfft);
    read_txt.generate_result_data(X_a, "ABS1_a.txt", 0,if_rfft);
    read_txt.generate_result_data(X_b, "ABS1_b.txt", 0,if_rfft);
    read_txt.generate_result_data(X_c, "ABS1_c.txt", 0,if_rfft);
    read_txt.generate_result_data(X_d, "ABS1_d.txt", 0,if_rfft);
    txt_modify = read_txt.read_complex_data("ABS1.txt", if_rfft)
    read_txt.write_complex_data(txt_modify, "ABS1_read.txt")

    Y =  Z
    # the mean of the magnitude of input X
    v = np.mean(Y)

    # threshold = a * v
    threshold = 1000


    X_array = np.ones(len(X_temp))
    for ith_sample in range(N_samples_per_chirp):
        if Y[ith_sample] > threshold:
            X_temp[ith_sample] = 0
            X_array[ith_sample] = 0

    fix_point_vectorized = np.vectorize(fix_point)
    X_temp = fix_point_vectorized(X_temp, 15)

    return X_temp,X_array
#取绝对值 然后比较阈值

def main(args):

    is_generating=0;
    is_reading=1;
    if_rfft=1;

    value = 1.75
    data_length=4096*(1+if_rfft)
    # the number of Rx channels
    N_Rx_Channel = 1
    # the number of chirps per frame
    N_chirps_per_frame = 1
    # the number of ADC samples per chirp per RX channel is 256 complex values
    N_samples_per_chirp = data_length
    # Complex Data, 16s
    DataBitWidth = 16
    # The minimum value of signed fixed-point
    Min = -(2**(DataBitWidth - 1))
    # The maximum value of signed fixed-point
    Max = (2**(DataBitWidth - 1)) - 1
    DataRe = np.full((N_Rx_Channel, N_chirps_per_frame, N_samples_per_chirp), 1000)
    DataIm = np.full((N_Rx_Channel, N_chirps_per_frame, N_samples_per_chirp), 1000)
    DataIn = DataRe + 1j * DataIm
    DataADCOffsetCompensation = np.zeros_like(DataIn)
    DataRxPathCompensation = np.zeros_like(DataIn)
    DataNonLinearFiltered = np.zeros_like(DataIn)

    # Average of previous frame
    Average_Previous_Frame = np.zeros((1, N_Rx_Channel), dtype=complex)
    # Average of current frame for next frame
    Average_Current_Frame = np.zeros((1, N_Rx_Channel), dtype=complex)

    # scalar RX path compensation factors
    C = np.array([512+512*1j, 1.875, 1.5, 1.25])

    # input threshold of non-linear filter 1 for the j-th RX channel
    A = np.array([10000, 3, 5, 4])

    # input threshold of non-linear filter 2 for the j-th RX channel
    B = np.array([10000, 3, 5, 4])

    # Boolean for which non-linear filter
    NonLinearFilter1Enable = 0

    input_txt = args.input_txt
    data = read_txt.read_complex_data(input_txt, if_rfft);

    read_txt.generate_result_data(data, "X-data.txt", 0,if_rfft);
    txt_modify = read_txt.read_complex_data("X-data.txt", 0)
    read_txt.write_complex_data(txt_modify, "X-data_read.txt")

    for jth_RX in range(N_Rx_Channel):

        # ADC offset calculation and compensation

        # a_fa=DataIn[jth_RX, :, :]
        # b_fa=Average_Previous_Frame[0, jth_RX]

        a_fa=data;
        b_fa=512+512*1j;
        #b_fa=0;

        a_ra, b_ra = ADC_Offset_Calculation_and_Compensation(a_fa,b_fa, if_rfft)    #求a_fa减去b_fa的值，还有a_fa的平均值

        if b_fa != 0:
            read_txt.generate_result_data(a_ra, "X-u.txt", 0,if_rfft);
            txt_modify = read_txt.read_complex_data("X-u.txt", 0)
            read_txt.write_complex_data(txt_modify, "X-u_read.txt")

        DataADCOffsetCompensation[jth_RX, :, :]  =a_ra.reshape(1, data_length)
        Average_Current_Frame    [0, jth_RX]     =b_ra

        for mth_Chirp in range(N_chirps_per_frame):
            # RX path compensation

            data_temp2 = DataADCOffsetCompensation[jth_RX, mth_Chirp, :];

            NonLinearFilter1Enable = 1
            NonLinearFilter2Enable = 1

            if b_fa != 0:
                if NonLinearFilter1Enable == 1:
                    # Non_Linear Filter 1
                    DataNonLinearFiltered[jth_RX, mth_Chirp, :],cmp_array1= Non_Linear_Filter_1(data_temp2,A[jth_RX], if_rfft)  # 取绝对值 将高于阈值的变成0

                if NonLinearFilter2Enable == 1:
                    # Non_Linear Filter 2
                    DataNonLinearFiltered[jth_RX, mth_Chirp, :],cmp_array2 = Non_Linear_Filter_2(data_temp2,B[jth_RX], if_rfft)  # 取差分绝对值 将高于阈值的变成0



            for i in range(len(cmp_array1)):
                cmp_array1[i]=int(cmp_array1[i])
                cmp_array2[i]=int(cmp_array2[i])

            # 将01数组转换为字符串
            str_array = ''.join([str(int(x)) for x in cmp_array1])

            # 保存字符串到txt文件
            with open('cmp_array1.txt', 'w') as file:
                file.write(str_array)

            # 将01数组转换为字符串
            str_array = ''.join([str(int(x)) for x in cmp_array2])

            # 保存字符串到txt文件
            with open('cmp_array2.txt', 'w') as file:
                file.write(str_array)


            cmp_and=cmp_array1[:]+1-1;
            for i in range(len(cmp_array1)):
                cmp_and[i]=int(cmp_array1[i]*cmp_array2[i])


            read_txt.generate_comp_data(cmp_array1,"cmp_array1_square.txt",if_rfft);
            read_txt.generate_comp_data(cmp_array2, "cmp_array2_square.txt",if_rfft);
            read_txt.generate_comp_data(cmp_and, "cmp_and_square.txt",if_rfft);

            data_comp=a_ra[:]+1-1
            for i in range(len(cmp_and)):
                if  cmp_and[i] ==0:
                    data_comp[i] =0;

            read_txt.generate_result_data(data_comp, "X_comp.txt", 0,if_rfft);
            txt_modify = read_txt.read_complex_data("X_comp.txt", if_rfft)
            read_txt.write_complex_data(txt_modify, "X_comp_read.txt")



            multi_sub=1; #为0就乘以原来的X，为1就乘以X-U

            if multi_sub==1:
                data_temp1 = data_comp
                DataRxPathCompensation[jth_RX, mth_Chirp, :] = RX_Path_Compensation(data_temp1, C[jth_RX],if_rfft) +1 -1  #将复数数据矩阵乘以复数系数
            else:
                data_temp1 = a_ra
                DataRxPathCompensation[jth_RX, mth_Chirp, :] = RX_Path_Compensation(data_temp1, C[jth_RX],if_rfft) +1 -1

            data_temp2=DataRxPathCompensation[0, 0, :]
            read_txt.generate_result_data(data_temp2, "XW.txt", 0,if_rfft);
            txt_modify = read_txt.read_complex_data("XW.txt",if_rfft)
            read_txt.write_complex_data(txt_modify, "XW_read.txt")


if __name__ == '__main__':

    parser = argparse.ArgumentParser()

    # 可以
    # parser.add_argument('--input_txt', type=str   , default="input_simple.txt", help='读入文件路径')
    parser.add_argument('--input_txt', type=str, default="input5.txt", help='读入文件路径')

    # 可以
    parser.add_argument('--FFT_Hex_Output_txt', type=str, default="FFT_Hex_Output.txt", help='FFT结果文件输出路径')

    parser.add_argument('--in_out_width',type=int, default=1,help='FFT输入输出数据位宽 0: 输出16 1: 输出32 注：i_fft_points为11时，i_in_out_width不能为1')

    args = parser.parse_args()

    main(args)

