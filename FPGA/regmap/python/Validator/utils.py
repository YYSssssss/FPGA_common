import os
import pandas
from Logging import log_info

def xlsx_to_csv(xlsx_src, csv_dst, sheet_name):
    read_file = pandas.read_excel(xlsx_src, keep_default_na=False, sheet_name=sheet_name)
    read_file.to_csv(csv_dst, index=None, header=True)

def run_reg_map_builder(src_dir,board_name,list_file):
    perl_script = os.path.join(os.path.dirname(__file__), "regMapBuilder.pl")
    log_info([
        "Running registers map builder script...",
        "Path to the script: {}".format(perl_script),
        "Board name: {}".format(board_name),
        "Path to the list of files: {}".format(list_file)
    ])
    # output to console disabled, since perl script generates a log file with all the same information
    os.system("{} -d {} -n {} -f {} > /dev/null".format(perl_script, src_dir, board_name, list_file))

def run_duplication_script(dir_path):
    perl_script = os.path.join(os.path.dirname(__file__), "dupCsvFiles.pl")
    log_info([
        "Running registers duplication script...",
        "Path to the script: {}".format(perl_script),
        "Path to the tmp directory: {}".format(dir_path)
    ])
    # output to console disabled, since perl script generates a log file with all the same information
    os.system("{} {} > /dev/null".format(perl_script, dir_path))
