# -*-coding:utf-8 -*-

# C:\Users\3007216\Desktop\python\yys

from fileinput import filename
from importlib.resources import path
from ntpath import join
import os
from tkinter import filedialog
import sys,os
import re
import fileinput

file_dir = "C:/Users/YYS/Desktop/python/yys"
# 导入路径
for root, dirs, files in os.walk(file_dir):
        # 获得当前路径下的路径,文件夹,文件(list)
    for i in files:
            # 循环文件列表
        if "jb_" in i:
            # 找到需要替换文件名的文件
            a = i.replace("jb_", '')
            # 替换文件名
            print(a)
            # 拼接路径
            i = os.path.join(root + "\\" + i)
            a = os.path.join(root + "\\" + a)
            print(a, i)
            # 重命名文件为替换后的文件名
            os.rename(i, a)


    # print('root_dir:', root)  # 当前目录路径
    # print('sub_dirs:', dirs)  # 当前路径下所有子目录
    # print('files:', files)  # 当前路径下所有非目录子文件

dir = "C:/Users/3007216/Desktop/python/yys/test\123.sv"
with open(dir,"r+",encoding="utf-8") as f:
    datas = f.readlines()
    j = 0
    for line in datas[:3]:
        if '//' in line:
            datas[j] = line.replace('//','')
        j += 1
    f.seek(0)
    f.truncate()
    f.writelines(datas)
    f.close()