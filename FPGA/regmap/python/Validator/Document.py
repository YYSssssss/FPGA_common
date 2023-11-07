import pandas
import os

from Logging import log_info, log_error
from Module import Module
from Param import Param
from Register import Register
from Copyright import Copyright

def to_camel_case(inp_str):
    res = ""
    arr = inp_str.replace(" ", "").split("_")
    for i in arr:
        res += i.lower().capitalize()
    return res

class Document:
    def __init__(self, src_file, tar_dir):
        self.modules = []
        self.offset = 0
        self.max_offset = 0
        self.namespace = ""
        self.src_file = src_file
        self.tar_dir = tar_dir

    def parse(self):
        excel = None
        # get namespace name
        try:
            if ".csv" in self.src_file:
                log_info("open {}".format(self.src_file))
                excel = pandas.read_csv(self.src_file, usecols=[0, 1, 2, 3, 4, 5, 6, 7], header=None)
            elif ".xlsx" in self.src_file:
                log_info("open {}".format(self.src_file))
                excel = pandas.read_excel(self.src_file, usecols=[0, 1, 2, 3, 4, 5, 6, 7], header=None)
            else:
                log_error("Wrong format of file {}".format(self.src_file))
                return False
        except:
            log_error("Parse of {} failed".format(self.src_file))
            return False
        # get namespace name
        self.namespace = self.src_file.split('/')[-1].split('\\')[-1].split('.')[0]
        # parse registers map
        module = None
        for i in range(int(excel.size / 8)):
            name = str(excel.iloc[i][0]).replace("REGISTERS", "").replace(" ", "")
            if name not in ["", "nan", "Base_addr_name"] and "REGISTERS" in str(excel.iloc[i][0]):
                module = self.add_module(to_camel_case(name))
                continue
            if not self.check_line(excel.iloc[i]):
                continue
            if module:
                # get register name
                reg_name = to_camel_case(str(excel.iloc[i][1]))
                if not reg_name:
                    log_error("Empty register name: '{}' '{}' '{}' '{}'".format(excel.iloc[i][0], excel.iloc[i][1], excel.iloc[i][3], excel.iloc[i][4]))
                    continue
                # get parameter name
                param_name = to_camel_case(str(excel.iloc[i][4]))
                if not param_name:
                    log_error("Empty parameter name: '{}' '{}' '{}' '{}'".format(excel.iloc[i][0], excel.iloc[i][1], excel.iloc[i][3]))
                    continue
                # get address
                reg = 0
                try:
                    reg = int(str(excel.iloc[i][3]), 16)
                except ValueError:
                    log_error("Address value '{}' of {} parameter of {} register is not HEX".format(excel.iloc[i][3], param_name, reg_name))
                    continue
                if int( reg ) % 4 != 0:
                    log_error("Address value '{}' of {} parameter of {} register of {} module is not a multiple of 4".format(hex(reg), param_name, reg_name, module.name))
                    continue
                else:
                    reg_already_exists = False
                    for mod in self.modules:
                        for reg_item in mod.registers:
                            if (int(reg_item.addr,16) == int(reg)) and (reg_item.name != reg_name):
                                reg_already_exists = True
                                log_error("Register '{}' has the same address({}) as register '{}'".format(reg_name, hex(reg), reg_item.name))
                    # TODO: uncomment, when all errors fixed
                    # if reg_already_exists:
                    #     continue
                # get shift
                shift = 0
                try:
                    shift = int(excel.iloc[i][5])
                except ValueError:
                    log_error("Shift value '{}' of {} parameter of {} register is not int".format(excel.iloc[i][5], param_name, reg_name))
                    continue
                if shift > 31:
                    log_error("Shift value '{}' of {} parameter of {} register is > than 31".format(hex(shift), param_name, reg_name))
                    continue
                # get bit_width
                bit_width = 0
                try:
                    bit_width = int(excel.iloc[i][6])
                except ValueError:
                    log_error("Bit width value '{}' of {} parameter of {} register is not int".format(excel.iloc[i][6], param_name, reg_name))
                    continue
                if bit_width <= 0:
                    log_error("Bit width value '{}' of {} parameter of {} register is <= 0".format(hex(bit_width), param_name, reg_name))
                    continue
                # get access level
                access = excel.iloc[i][7].replace(" ", "")
                if "NONE" in access:
                    continue
                elif "READ" not in access and "WRITE" not in access:
                    log_error("Incorrect access level '{}' of {} parameter of {} register".format(access, param_name, reg_name))
                    continue
                # check whether such address is already in use
                reg_already_exist = False
                for mod in self.modules:
                    reg_obj = mod.find_register(reg_name)
                    if reg_obj:
                        if int(reg_obj.addr,16) != reg:
                            log_error("Register '{}' already exists in module '{}' with a different address {}, not {}".format(reg_name, module.name, reg_obj.addr, hex(reg)))
                            reg_already_exist = True
                # TODO: uncomment, when all errors fixed
                # if reg_already_exist:
                #     continue
                # add register and parameter
                module.add_register(Register(reg_name, reg, self.namespace)).add_parameter(Param(param_name, shift, bit_width, access))

        # get offset
        self.offset = 0xffffffff
        for i in self.modules:
            self.offset = self.offset & i.get_offset()
        self.offset = self.offset - ( self.offset & 0xfff )
        for module in self.modules:
            for reg in module.registers:
                reg.addr = hex(int(reg.addr, 16) - self.offset)

        # get maximum offset
        self.max_offset = 0
        for i in self.modules:
            if i.get_max_offset() > self.max_offset:
                self.max_offset = i.get_max_offset()
        return True

    def check_line(self, line):
        for i in range(7):
            if str(line[i]) in ["nan","Base_addr_name"]:
                return False
        return True

    def add_module(self, name):
        for i in self.modules:
            if i.name == name:
                return i
        self.modules.append(Module(name, self.namespace))
        return self.modules[-1]

    def find_module(self,name):
        for i in self.modules:
            if i.name == name:
                return i
        return None

    def generate(self):
        res = ""
        res += Copyright.generate_copyright_header(self.namespace + "FPGA.h") + "\r\n"
        res += "#ifndef _" + self.namespace.upper() + "_FPGA_COMMON_\r\n"
        res += "#define _" + self.namespace.upper() + "_FPGA_COMMON_\r\n\r\n"
        for i in self.modules:
            if i.registers:
                res += "#include " + '"' + "./" + i.name + "/" + i.name + ".h" + '"' + "\r\n"
        res += "\r\n"
        res += "namespace jabil\r\n"
        res += "{\r\n"
        res += "    namespace " + self.namespace + "\r\n"
        res += "    {\r\n"
        res += "        const uint32_t offset = " + hex( self.offset ) + ";\r\n"
        res += "        const uint32_t maxOffset = " + hex( self.max_offset + 4 ) + ";\r\n"
        res += "    }\r\n"
        res += "}\r\n\r\n"
        res += "#endif\r\n"

        if not os.path.exists(self.tar_dir):
            os.makedirs(self.tar_dir)
        dst_file = self.tar_dir + "/" + self.namespace + "FPGA.h"

        f = open(dst_file, "w")
        f.write(res)
        f.close()
        for module in self.modules:
            module.generate(self.tar_dir)

    @staticmethod
    def compare(old, new):
        # check whether new modules added
        # if new module found, print all newly added registers
        for new_module in new.modules:
            old_module = old.find_module(new_module.name)
            if old_module:
                for new_register in new_module.registers:
                    if not old_module.find_register(new_register.name):
                        log_array = ["Register '{}', which contains following parameters added:".format(new_register.name)]
                        for new_param in new_register.parameters:
                            log_array.append("parameter '{}': bitwidth = {}, shift = {}, access = '{}'".format(new_param.name,new_param.bit_width,new_param.shift,new_param.access))
                        log_info(log_array)
            else:
                log_array = ["Module '{}', which contains following registers added:".format(new_module.name)]
                for new_reg in new_module.registers:
                    log_array.append("Register '{}' at address {}".format(new_reg.name,new_reg.addr))
                log_info(log_array)
        # compare already existing modules against of module in the new registers map
        for old_module in old.modules:
            # check whether module is still in the registers map or not
            new_module = new.find_module(old_module.name)
            if not new_module:
                log_array = ["Module '{}', which contained following registers removed:".format(old_module.name)]
                for old_reg in old_module.registers:
                    log_array.append("register '{}' at address {}".format(old_reg.name,old_reg.addr))
                log_info(log_array)
                continue
            # compare old registers against of registers in the new regsiters map
            for old_register in old_module.registers:
                new_register = new_module.find_register(old_register.name)
                # check whether registers got removed from the new registers map
                if not new_register:
                    log_array = ["Register '{}', which contained following parameters removed:".format(old_register.name)]
                    for old_param in old_register.parameters:
                        log_array.append("parameter '{}': bitwidth = {}, shift = {}, access = '{}'".format(old_param.name,old_param.bit_width,old_param.shift,old_param.access))
                    log_info(log_array)
                # check whether address of the register changed
                elif ( old.offset + int(old_register.addr,16) ) != ( new.offset + int(new_register.addr,16) ):
                    log_info("Register '{}' changed its address from {} to {}".format(old_register.name,
                                                                                      hex( old.offset + int(old_register.addr,16) ),
                                                                                      hex( new.offset + int(new_register.addr,16)) ) )
                # compare all parameters of the register, if it is still there
                else:
                    # compare all parameters agains of the set of new parameters
                    for old_param in old_register.parameters:
                        new_param = new_register.find_parameter(old_param.name)
                        # check whether parameter is still there
                        if not new_param:
                            log_info("Parameter '{}' removed from register {}".format(old_param.name,old_register.name))
                        else:
                            # compare old and new parameters and print a difference, if they are different
                            if not all([(old_param.shift     == new_param.shift),
                                        (old_param.bit_width == new_param.bit_width),
                                        (old_param.access    == new_param.access)]):
                                log_info([
                                    "Parameter '{}' of register '{}' changed:".format(new_param.name,new_register.name),
                                    "old data: bitwidth = {}, shift = {}, access = '{}'".format(old_param.bit_width,old_param.shift,old_param.access),
                                    "new data: bitwidth = {}, shift = {}, access = '{}'".format(new_param.bit_width,new_param.shift,new_param.access)
                                ])
                    # check whether register has new parameters added
                    for new_param in new_register.parameters:
                        old_param = old_register.find_parameter(new_param.name)
                        if not old_param:
                            log_info([
                                "Parameter '{}' added to register '{}'".format(new_param.name,new_register.name),
                                "bitwidth = {}, shift = {}, access = '{}'".format(new_param.bit_width,new_param.shift,new_param.access)
                            ])
