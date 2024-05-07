# #   _*_ coding:utf-8 _*_

import pytesseract
from PIL import Image

__author__ = 'admin'

im = Image.open("20240104220844.png","r")
print(pytesseract.image_to_string(im))

