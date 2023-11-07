from Copyright import Copyright
from Logging import log_info, log_error

class Register:
    def __init__(self, reg_name, reg_addr, namespace):
        self.name = reg_name
        self.addr = hex(reg_addr)
        self.parameters = []
        self.namespace = namespace
        self.is_get_needed = False
        self.is_set_needed = False

    def add_parameter(self, param):
        for i in self.parameters:
            if i.name == param.name:
                log_error("Parameter '{}' is duplicated in '{}' register".format(i.name, self.name))
                return
            if i.mask & param.mask != 0:
                log_error("Parameter '{}' overlaps with parameter '{}' or register '{}'".format(i.name, param.name, self.name))

        if "READ" in param.access:
            self.is_get_needed = True
        if "WRITE" in param.access:
            self.is_set_needed = True
        self.parameters.append(param)

    def find_parameter(self, name):
        for i in self.parameters:
            if i.name == name:
                return i
        return None

    def get_max_offset(self):
        max_offset = 0
        for i in self.parameters:
            temp = int(self.addr, 16) + max(4, int(i.bit_width/8))
            max_offset = max(max_offset, temp)
        return max_offset

    def generate_get_methods_declarations(self):
        res = ""
        for i in self.parameters:
            if not i.is_get_needed:
                continue
            if "READ" in i.access:
                if not i.is_buffer:
                    res += "                static inline Error get" + i.name + "( uint32_t & value )\r\n"
                    res += "                {\r\n"
                    res += "                    return FPGA::getRegisterField( {}, {}, {}, value );\r\n".format( self.addr, i.bit_width, i.shift )
                    res += "                }\r\n\r\n"
                else:
                    res += "                static inline Error get" + i.name + "( char ** data, uint32_t & size )\r\n"
                    res += "                {\r\n"
                    res += "                    if( !data )\r\n"
                    res += "                    {\r\n"
                    res += "                        size = 0;\r\n"
                    res += "                        return Error::BADARG;\r\n"
                    res += "                    }\r\n"
                    res += "                    *data = new char[ " + hex(int(i.bit_width/8)) + " ];\r\n"
                    res += "                    if( !( *data ) )\r\n"
                    res += "                    {\r\n"
                    res += "                        size = 0;\r\n"
                    res += "                        return Error::FAILURE;\r\n"
                    res += "                    }\r\n"
                    res += "                    Error ret = FPGA::readBuffer( " + self.addr + ", *data, " + hex(int(i.bit_width/8)) + " );\r\n"
                    res += "                    size = ( ret == Error::SUCCESS ) ? " + hex(int(i.bit_width/8)) + " : 0;\r\n"
                    res += "                    return ret;\r\n"
                    res += "                }\r\n\r\n"
        return res

    def generate_set_methods_declarations(self):
        res = ""
        for i in self.parameters:
            if not i.is_set_needed:
                continue
            if "WRITE" in i.access:
                if not i.is_buffer:
                    if "READ" in i.access:
                        res += "                static inline Error set" + i.name + "( uint32_t value )\r\n"
                        res += "                {\r\n"
                        res += "                    return FPGA::setRegisterField( {}, {}, {}, value );\r\n".format( self.addr, i.bit_width, i.shift )
                        res += "                }\r\n\r\n"
                    else:
                        log_info(["Parameter '{}' of register '{}' is write-only.".format(i.name,self.name),
                                  "Setting of register field cannot be done, since it require read access."])
                elif ( i.bit_width % 32 == 0 ):
                    res += "                static inline Error set" + i.name + "( char * data, uint32_t size )\r\n"
                    res += "                {\r\n"
                    res += "                    if( ( size > " + hex(int(i.bit_width/8)) + " ) || ( !data ) )\r\n"
                    res += "                    {\r\n"
                    res += "                        return Error::BADARG;\r\n"
                    res += "                    }\r\n"
                    res += "                    return FPGA::writeBuffer( " + self.addr + ", data, size );\r\n"
                    res += "                }\r\n\r\n"
        return res

    def generate(self, dst_folder):
        res = ""
        res += Copyright.generate_copyright_header(self.name + ".h") + "\r\n"
        res += "#ifndef _" + self.namespace.upper() + "_FPGA_REGISTERS_" + self.name.upper() + "_\r\n"
        res += "#define _" + self.namespace.upper() + "_FPGA_REGISTERS_" + self.name.upper() + "_\r\n\r\n"
        res += '#include "Libs/HALBase/FPGA/FPGA.h"\r\n\r\n'
        res += "namespace jabil\r\n"
        res += "{\r\n"
        res += "    namespace " + self.namespace + "\r\n"
        res += "    {\r\n"
        res += "        class " + self.name + "\r\n"
        res += "        {\r\n"
        res += "            public:\r\n"
        if self.is_get_needed:
            res += "                static inline Error get( uint32_t & value )\r\n"
            res += "                {\r\n"
            res += "                    return FPGA::readRegister( " + self.addr + ", value );\r\n"
            res += "                }\r\n\r\n"
        if self.is_set_needed:
            res += "                static inline Error set( uint32_t value )\r\n"
            res += "                {\r\n"
            res += "                    return FPGA::writeRegister( " + self.addr + ", value );\r\n"
            res += "                }\r\n\r\n"

        res += self.generate_get_methods_declarations()
        res += self.generate_set_methods_declarations()
        res = res[:-2]
        res += "        };\r\n"
        res += "    }\r\n"
        res += "}\r\n\r\n"
        res += "#endif\r\n"

        f = open("{}/{}.h".format(dst_folder,self.name), "w")
        f.write(res)
        f.close()
