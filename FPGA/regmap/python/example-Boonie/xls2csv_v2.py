import os
import sys

from xlrd import open_workbook
import csv

import platform

"""
# Reading an excel file using Python 
import xlrd 
  
# Give the location of the file 
loc = ("path of file") 
  
# To open Workbook 
wb = xlrd.open_workbook(loc) 
sheet = wb.sheet_by_index(0) 
  
# For row 0 and column 0 
sheet.cell_value(0, 0)

for f in *.xls ; xls2csv -x "$f" -w sheetName -c "${f%.xls}.csv";done
for f in *.xls ; do xls2csv -x "$f" -f -n 14 -c "${f%.xls}.csv" 
"""


def parse_file(xlsFile):
    wb = open_workbook(xlsFile)
    for i in range(0, wb.nsheets):
        sheet = wb.sheet_by_index(i)
        print(sheet.name)
        if (platform.system()=='Linux'):
            yes_Linux =1
            with open("csv/%s.csv" %(sheet.name.replace(" ","")), "w") as file:
                writer = csv.writer(file, delimiter = ",")        
                #print(sheet+" "+sheet.name+" "+sheet.ncols+" "+sheet.nrows)
                header = [cell.value for cell in sheet.row(0)]
                writer.writerow(header)
                for row_idx in range(1, sheet.nrows):
                    row = [int(cell.value) if isinstance(cell.value, float) else cell.value
                           for cell in sheet.row(row_idx)]
                    writer.writerow(row)
        elif (platform.system()=='Windows'):
            yes_win =1 
            with open("csv/%s.csv" % (sheet.name.replace(" ", "")), "w", newline="",encoding = 'utf-8') as file:
            # with open("%s.csv" % (sheet.name.replace(" ", "")), "w", newline="") as file:
            # with open('yys.csv', "w", newline="") as file:
                writer = csv.writer(file, delimiter=",")
                # print(sheet+" "+sheet.name+" "+sheet.ncols+" "+sheet.nrows)
                header = [cell.value for cell in sheet.row(0)]
                writer.writerow(header)
                for row_idx in range(1, sheet.nrows):
                    row = [int(cell.value) if isinstance(cell.value, float) else cell.value
                           for cell in sheet.row(row_idx)]
                    writer.writerow(row)
        # with open("csv/%s.csv" % (sheet.name.replace(" ", "")), "w", newline="") as file:
            # writer = csv.writer(file, delimiter=",")
            # # print(sheet+" "+sheet.name+" "+sheet.ncols+" "+sheet.nrows)
            # header = [cell.value for cell in sheet.row(0)]
            # writer.writerow(header)
            # for row_idx in range(1, sheet.nrows):
                # row = [int(cell.value) if isinstance(cell.value, float) else cell.value
                       # for cell in sheet.row(row_idx)]
                # writer.writerow(row)

def main(xlsFile):
    """
    Function which prints counts of spaces, tabs and lines in a file.

    :arg path: Path of the text file to parse
    :return: True if the file exits or False.
    """
    if os.path.exists(xlsFile):
        print("Parsing the File")
        parse_file(xlsFile)
        print("Parsing Done")
        return True
    else:
        return False


if __name__ == '__main__':
    # main('LoganSub6Registers.xlsx')
    # main('yys.xlsx')
    if len(sys.argv) > 1:
        main(sys.argv[1])
    else:
        sys.exit(-1)
    sys.exit(0)
