class Param:
    def __init__(self, param_name, shift, bit_width, access):
        self.name = param_name
        self.shift = shift
        self.bit_width = bit_width
        self.access = access

        self.max_value = pow(2, self.bit_width) - 1
        self.mask = self.max_value << self.shift
        self.is_buffer = ( self.shift == 0 ) and ( self.bit_width > 32 )
        self.is_get_needed = "READ" in self.access
        self.is_set_needed = "WRITE" in self.access
