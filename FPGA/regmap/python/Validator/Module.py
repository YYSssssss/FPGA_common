import os

from Copyright import Copyright
from Logging import log_info

class Module:
    def __init__(self, name, namespace):
        self.registers = []
        self.name = name
        self.namespace = namespace

    def add_register(self, reg):
        for i in self.registers:
            if i.name == reg.name:
                return i
        self.registers.append(reg)
        return self.registers[-1]

    def find_register(self, name):
        for i in self.registers:
            if i.name == name:
                return i
        return None

    def get_offset(self):
        offset = 0xffffffff
        for i in self.registers:
            offset = offset & int(i.addr, 16)
        return offset

    def get_max_offset(self):
        max_offset = 0
        for i in self.registers:
            if i.get_max_offset() > max_offset:
                max_offset = i.get_max_offset()
        return max_offset

    def generate(self, dst_folder):
        if not self.registers:
            log_info( "{} section is empty".format( self.name ) )
            return
        path = dst_folder + "/" + self.name
        if not os.path.exists(path):
            os.makedirs(path)
        for reg in self.registers:
            reg.generate(path)
        res = ""
        res += Copyright.generate_copyright_header(self.name + ".h") + "\r\n"
        res += "#ifndef _FPGA_REGISTERS_" + self.name.upper() + "_ALL_\r\n"
        res += "#define _FPGA_REGISTERS_" + self.name.upper() + "_ALL_\r\n\r\n"
        for reg in self.registers:
            res += '#include "' + reg.name + '.h"\r\n'
        res += "\r\n\r\n#endif \r\n\r\n"
        f = open(path + "/" + self.name + ".h", "w")
        f.write(res)
        f.close()
