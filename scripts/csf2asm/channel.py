from defs import *
import header

# -------------------------------------------------
notes = {
    0x0f: 'NB0',
    0x10: 'NC1',
    0x4b: 'NB5',
    0x4d: 'NC6S',
    0x4e: 'ND6',
    0x52: 'NF6',
    0x55: 'NA6',
    0x58: 'NC7',
    0x5b: 'ND7',
    0x5e: 'NF7',
}

note_id = 0x17
for note in [
    'g1', 'g1s', 'a1',
    'a1s', 'b1', 'c2', 'c2s', 'd2',
    'd2s', 'e2', 'f2', 'f2s', 'g2',
    'g2s', 'a2', 'a2s', 'b2', 'c3',
    'c3s', 'd3', 'd3s', 'e3', 'f3',
    'f3s', 'g3', 'g3s', 'a3', 'a3s',
    'b3', 'c4', 'c4s', 'd4', 'd4s',
    'e4', 'f4', 'f4s', 'g4', 'g4s',
    'a4', 'a4s', 'b4', 'c5', 'c5s',
    'd5', 'd5s', 'e5', 'f5', 'f5s',
    'g5', 'g5s', 'a5',
]:
    # print('N'+note.upper(), convert_number(note_id))
    notes[note_id] = 'N'+note.upper()
    note_id += 1

# -------------------------------------------------
# Byte buffer

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
    return loop_arg(file, skip=True) + '\n' # Additional newline

def CSF_Stop(file: BufferedReader):
    return ""

def CSF_Nop(file: BufferedReader):
    return ""

def CSF_SetVoice(file: BufferedReader):
    return one_value_arg(file)

def CSF_PlaySound(file: BufferedReader):
    return one_value_arg(file) + " ; TODO: that's a sound id, turn it into a label later"

def CSF_SetLoopCount(file: BufferedReader):
    return one_value_arg(file, skip=True)

def CSF_Command(file: BufferedReader):
    file.seek(file.tell()-1)

    return convert_number(file.read(1)[0]) + ", " + convert_number(file.read(1)[0]) \
        + " ; Undocumented command"

cmd9c_counter = 0
def CSF_Cmd9C(file: BufferedReader):
    global cmd9c_counter
    y = convert_number(file.read(1)[0])
    address = Address((file.read(1)[0], file.read(1)[0]),
                      current_channel + "_cmd9c_" + str(cmd9c_counter))
    cmd9c_counter += 1
    address_buffer.add(address)
    return address.name + ', ' + y

commands = {
    0x80: CSF_Jump,
    0x81: CSF_Loop,
    0x82: CSF_Stop,
    0x83: CSF_Command, # undocumented command
    0x88: CSF_SetVoice,
    0x89: CSF_Command, # undocumented command
    0x8a: CSF_Command, # undocumented command
    0x8b: CSF_PlaySound,
    0x8c: CSF_Nop,
    0x8d: CSF_SetLoopCount,
    0x91: CSF_Command, # undocumented command
    0x96: CSF_Command, # undocumented command
    0x9c: CSF_Cmd9C,
    0x9d: CSF_Command, # undocumented command
    0xa0: CSF_Command, # undocumented command
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
    address = current_address(file)
    for a in header.channel_labels:
        if a.value == address:
            global current_channel
            current_channel = a.name

            global loop_id
            loop_id = 1

            global cmd9c_counter
            cmd9c_counter = 1
            return True
    return False

def parse_channel(file: BufferedReader, ending_address):
    result = ""
    
    while True:
        if check_channel_label(file):
            result += '\n'
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
            command_result = command(file)
            result += indent + command.__name__
            if command_result:
                result += ' ' + command_result
            result += '\n'
        elif byte & 0xe0 == 0xe0:
            result += flush_byte_buffer()
            byte_buffer.append("cDelay(" + convert_number(byte & ~0xe0) + ")")
        elif byte >= 0x80 and byte <= 0xA0:
            result += flush_byte_buffer()
            result += indent + ".byte " + convert_number(byte) + " ; Unknown command\n"
        elif byte in notes:
            byte_buffer.append(notes[byte])
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