from defs import *

channel_count = 0
channel_labels = set()

def parse_channel_header(file: BufferedReader):
    result = ""
    bytearr = file.read(10)
    channel_type = bytearr[-3]
    channel_types = ["Pulse 1", "Pulse 2", "Triangle", "Noise"]

    result += indent + "; " + channel_types[channel_type] + '\n'
    result += indent + "CSF_HeaderChID " + convert_number(bytearr[0]) + '\n'
    result += indent + "CSF_HeaderInitLoop " + convert_number(bytearr[1]) + '\n'
    
    byte = bytearr[2]
    result += indent
    match channel_type:
        case 0 | 1: # Pulse setup
            result += "CSF_HeaderPulseSetup "
            result += convert_number((byte & 3 << 6) >> 6) + ', ' # duty
            result += convert_number((byte & 1 << 5) >> 5) + ', ' # env_loop
            result += convert_number((byte & 1 << 4) >> 4) + ', ' # cvolume
            result += convert_number(byte & 15) # volume
        case 2: # Triangle setup
            result += "CSF_HeaderTriSetup "
            result += convert_number((byte & 1 << 7) >> 7) + ', ' # c_flag
            result += convert_number(byte & 0x7f) + ', ' # linear_load
            result += convert_number(bytearr[4]) # unk
        case 3: # Noise setup
            result += "CSF_HeaderNoiseSetup "
            result += convert_number((byte & 1 << 5) >> 5) + ', ' # env_loop
            result += convert_number((byte & 1 << 4) >> 4) + ', ' # cvolume
            result += convert_number(byte & 0xf) + ', ' # volume
            result += convert_number(bytearr[4]) # unk
    result += '\n'

    result += indent + "CSF_HeaderInitVoice " + convert_number(bytearr[3]) + '\n'

    if channel_type == 0 or channel_type == 1:
        byte = bytearr[4]
        result += indent + "CSF_HeaderPulseSweep "
        result += convert_number((byte & 1 << 7) >> 7) + ', ' # enable
        result += convert_number((byte & 7 << 4) >> 4) + ', ' # period
        result += convert_number((byte & 1 << 3) >> 3) + ', ' # negate
        result += convert_number(byte & 7) + '\n' # shift_count

    result += indent + "CSF_HeaderPitch " + convert_number(bytearr[5]) + '\n'
    result += indent + "CSF_HeaderTempo " + convert_number(bytearr[6]) + '\n'
    address = Address((bytearr[8], bytearr[9]))
    
    result += indent
    match channel_type:
        case 0 | 1:
            result += "CSF_HeaderPulse " + str(channel_type+1) + ', '
            result += address.set_name("_pulse" + str(channel_type+1))
        case 2:
            result += "CSF_HeaderTriangle " + address.set_name("_triangle")
        case 3:
            result += "CSF_HeaderNoise " + address.set_name("_noise")
    result += '\n'

    address_buffer.add(address)
    channel_labels.add(address)

    return result

def parse_header(file: BufferedReader, music_address: int):
    global channel_count
    global channel_labels
    channel_labels = set()
    channel_count = file.read(1)[0]
    header_end = Address(channel_count * 10 + 1 + music_address, "_HeaderEnd")
    result = indent + "CSF_HeaderStart " + header_end.name + '\n\n'

    for i in range(channel_count):
        result += parse_channel_header(file) + '\n'
    result += header_end.name + '\n'
    return result