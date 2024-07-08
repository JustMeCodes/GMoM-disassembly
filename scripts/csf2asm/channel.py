from defs import *
import header

byte_buffer = []
current_channel = ""

def get_byte_buffer_element():
    global byte_buffer
    element = byte_buffer.pop(0)
    if isinstance(element, str):
        return element
    else:
        return convert_number(element)

def flush_byte_buffer():
    global byte_buffer
    if len(byte_buffer) == 0:
        return ""
    
    result = ""
    while len(byte_buffer) > 0:
        result += indent + ".byte " + get_byte_buffer_element()
        for i in range(3):
            if len(byte_buffer) > 0:
                result += ", " + get_byte_buffer_element()
        result += '\n'
    return result

# -------------------------------------------------
# Commands

def handle_unk(file, skip=False):
    skipped = ""
    if skip:
        unk = file.read(1)[0]
        if unk != 0x70:
            skipped = ", " + convert_number(unk)
    return skipped

def one_value_arg(file: BufferedReader, skip=False):
    skipped = handle_unk(file, skip)
    return convert_number(file.read(1)[0]) + skipped

loop_id = 1
def loop_arg(file: BufferedReader, skip=False):
    skipped = handle_unk(file, skip)

    global loop_id
    address = Address((file.read(1)[0], file.read(1)[0]), current_channel + "_loop" + str(loop_id))
    loop_id += 1

    address_buffer.add(address)
    return address.name + skipped

def CSF_Jump(file: BufferedReader):
    return loop_arg(file)

def CSF_Loop(file: BufferedReader):
    return loop_arg(file, skip=True)

def CSF_Stop(file: BufferedReader):
    return ""

def CSF_SetVoice(file: BufferedReader):
    return one_value_arg(file)

def CSF_SetLoopCount(file: BufferedReader):
    return one_value_arg(file, skip=True)

def CSF_Command(file: BufferedReader):
    file.seek(file.tell()-1)

    return convert_number(file.read(1)[0]) + ", " + convert_number(file.read(1)[0])

commands = {
    0x80: CSF_Jump,
    0x81: CSF_Loop,
    0x82: CSF_Stop,
    0x88: CSF_SetVoice,
    0x8a: CSF_Command, # unknown command
    0x8d: CSF_SetLoopCount,
    0x96: CSF_Command, # unknown command
    0x9d: CSF_Command, # unknown command
}

# -------------------------------------------------

def check_label(file: BufferedReader):
    if get_current_label(file):
        result = ""
        labels_set = set()
        for label in get_current_label(file):
            if label.name not in labels_set:
                labels_set.add(label.name)
                result += label.name + ':\n'
        return result
    return ""

def check_channel_label(file: BufferedReader):
    global current_channel
    global loop_id

    address = current_address(file)
    for a in header.channel_labels:
        if a.value == address:
            current_channel = a.name
            loop_id = 1
            break

def parse_channel(file: BufferedReader, ending_address):
    result = ""
    
    while True:
        check_channel_label(file)
        if current_address(file) >= ending_address:
            break
        label_check = check_label(file)
        if label_check:
            result += flush_byte_buffer()
            result += label_check

        byte = file.read(1)[0]
        if byte in commands:
            result += flush_byte_buffer()
            command = commands[byte]
            result += indent + command.__name__ + ' ' + command(file) + '\n'
        elif byte & 0xe0 == 0xe0:
            result += flush_byte_buffer()
            byte_buffer.append("cDelay(" + convert_number(byte & ~0xe0) + ")")
        elif byte >= 0x80 and byte <= 0xA0:
            result += flush_byte_buffer()
            result += indent + ".byte " + convert_number(byte) + " ; Unknown command\n"
        else:
            byte_buffer.append(byte)

    result += flush_byte_buffer()
    result += '\n'
    return result

def parse_channels(file: BufferedReader, channel_count, ending_address):
    result = ""

    for i in range(channel_count):
        result += parse_channel(file, ending_address)

    return result