from io import BufferedReader, TextIOWrapper

rom = open("rom.nes", "rb")
output: TextIOWrapper = None
indent = '\t'*3

address_buffer = set()

def convert_ptr(ptr):
    return 0x10 + ptr - 0x8000

def convert_number(number):
    return '$' + hex(number)[2:].rjust(2, '0')

def current_address(file: BufferedReader):
    return file.tell() - file_offset + music_address

def get_current_label(file: BufferedReader):
    address = current_address(file)
    result = set()
    for a in address_buffer:
        if a.value == address:
            result.add(a)
    return result

class Address:
    def __init__(self, address, name = None) -> None:
        if isinstance(address, tuple):
            self.value = address[0] | (address[1] << 8)
        else:
            self.value = address
        self.name = name

    def set_name(self, name: str):
        self.name = name
        return name
    
    def __repr__(self) -> str:
        return f"(Address, name: {self.name}, address: {convert_number(self.value)})"
    
    def __hash__(self) -> int:
        return hash(self.__repr__())
    
music_address = 0x8c13
file_offset = convert_ptr(music_address)

def setup_source(bank_address: int, output_file: str):
    global music_address
    global output
    global file_offset
    music_address = bank_address
    file_offset = convert_ptr(music_address)
    output = open(output_file, "w")
    return output

def reset_source_position():
    rom.seek(file_offset)