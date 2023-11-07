import sys
from Logging import log_info
from DataHolder import DataHolder

# log_info("Initializing data holder for the registers map '{}'".format(str(sys.argv[1])))
# data = DataHolder(str(sys.argv[1]),"data")
target_file = 'Vernon_regmap_0_5_9_yys.xlsx'
data = DataHolder(target_file,"data")
log_info("Opening and parsing the registers map...")
data.initialize()
log_info("Comparison finished. Clearing environment...")
# data.cleanup()
