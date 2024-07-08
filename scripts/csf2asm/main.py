from defs import *
import header
from channel import parse_channels

# TODO: More commands

file_prefix = "data/sound/music/"
file_suffix = ".asm"

music_list = [
    (0x8c13, "japantitle"),
    (0x8dfb, "theearth"),
    (0x916c, "mainmenu"),
    (0x9202, "gameover"),
    (0x932b, "death"),
    (0x93eb, "unused1"),
    (0x948a, "unused2"),
    (0x9510, "interntitle_planetx"),
    (0x999d, "mars"),
    (0x9c16, "neptune"),
    (0x9e2a, "saturn"),
    (0xa05a, "jupiter"),
    (0xa28f, "pluto"),
    (0xa458, "uranus"),
    (0xa62b, "moguera_baragon"),
    (0xa6ec, "hedorah"),
    (0xa906, "gigan"),
    (0xab76, "mechagodzilla"),
    (0xacab, "gezora"),
    (0xae02, "ghidorah"),
    (0xaf44, "bossdefeat"),
    (0xb015, "unused3"),
    (0xb190, "credits"),
    (0xb3a7, "unused4_gh1d0ra"),
    (0xb510, "password"),
    (0xb5ac, "japansolar"),
    (0xb9c6, "varan"),
    (0xba7e, ""), # not a file, just to mark the end of the last track
]

for i in range(len(music_list)-1):
    music = music_list[i]
    end_address = music_list[i+1][0]

    output = setup_source(music[0], file_prefix + music[1] + file_suffix)

    # pass 1
    reset_source_position()
    header.parse_header(rom, music_address)
    parse_channels(rom, header.channel_count, end_address)

    # pass 2
    reset_source_position()
    output.write(header.parse_header(rom, music_address) + '\n')
    output.write(parse_channels(rom, header.channel_count, end_address).strip())
    address_buffer.clear()

    output.close()