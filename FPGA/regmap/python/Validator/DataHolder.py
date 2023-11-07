from Document import Document
from Logging import log_error
import os
import pandas
import shutil
from utils import *

class DataHolder:
    def __init__(self, base_file, tag):
        self.base_file = base_file
        self.board_name = os.path.basename(self.base_file).replace(".xlsx", "")
        self.tmp_dir = "/tmp/comparator/{}".format(tag)
        # self.tmp_dir = "C:/yys/{}".format(tag)
        self.target_file = "{}/{}.csv".format(self.tmp_dir,self.board_name)
        self.list_file = "{}/files.txt".format(self.tmp_dir)
        self.doc = Document(self.target_file,"")

    def initialize(self):
        os.makedirs(self.tmp_dir, exist_ok=True)

        version = 1
        if len(pandas.ExcelFile(self.base_file).sheet_names) == 1:
            version = 1
        else:
            version = 2

        if version == 1:
            xlsx_to_csv(self.base_file, self.target_file, 0)
        elif version == 2:
            xlsx = pandas.ExcelFile(self.base_file)
            f = open(self.list_file, "a+")
            for page in xlsx.sheet_names:
                file_name = "{}/{}.csv".format(self.tmp_dir, page)
                xlsx_to_csv(self.base_file,file_name,page)
                f.write("{}\r\n".format(os.path.basename(file_name)))
            f.close()

            run_duplication_script(self.tmp_dir)
            run_reg_map_builder(self.tmp_dir,self.board_name,self.list_file)
        else:
            log_error("Unknown version")
        self.doc.parse()

    def cleanup(self):
        shutil.rmtree(self.tmp_dir)

    def compare(old, new):
        Document.compare(old.doc,new.doc)
