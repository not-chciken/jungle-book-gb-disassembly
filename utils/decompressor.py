#!/usr/bin/python

# A script to decompress and visualize LZ77-compressed data.

from bitstream import BitStream
from PIL import Image, ImageColor
import sys

if len(sys.argv) < 2:
    sys.exit("Need arguments! Usage: ./decompressor.py <path_to_data_file>")

INPUT_FILE_NAME = sys.argv[1]
OUTPUT_FILE_NAME = "output.png"
SAVE_AS_PNG = True
INVERT_COLORS = True
INVERT_OUTPUT_AXIS = True

def BoolListToUint(blist):
    sum = 0
    for i,v in enumerate(blist[::-1]):
        sum += int(v) * 2**i
    return sum

colors = [ImageColor.getcolor('#000000', 'L'), ImageColor.getcolor('#525252', 'L'), ImageColor.getcolor('#969696', 'L'), ImageColor.getcolor('#ffffff', 'L')]
if INVERT_COLORS:
    colors = colors[::-1]

def DrawTiles(vram, num_tiles):
    im = Image.new('L', (8 * num_tiles, 8) if INVERT_OUTPUT_AXIS else (8, 8 * num_tiles))
    row, col = 0, 0
    for b1, b2 in zip(vram[1::2],vram[0::2]):
        for i in range(8):
            val1 = ((int.from_bytes(b1,"little") >> i) & 1) * 2
            val2 = ((int.from_bytes(b2,"little") >> i) & 1) * 1
            im.putpixel((col + 7 - i, row), colors[val1 + val2])
        row += 1
        if row == 8 and INVERT_OUTPUT_AXIS:
            row = 0
            col += 8
    im.save(OUTPUT_FILE_NAME)

# Uses some sort of Lz77 algorithm to decompress the given data.
def Lz77Decompression(comp_data):
    decomp_data_size = int.from_bytes(comp_data[0:2], byteorder="little", signed=False)
    vram = [bytes(b"\00")] * (decomp_data_size + 256)
    ptr = decomp_data_size
    comp_data_size = int.from_bytes(comp_data[2:4], byteorder="little", signed=False)
    data = comp_data[4:4+comp_data_size]
    data = bytes(data[::-1])

    stream = BitStream()
    stream.write(data, bytes)

    try:
        while True:
            skip_pattern = stream.read(bool, 1)[0]
            if not skip_pattern:
                chunk_length_bits = stream.read(bool, 2)
                chunk_length_bits = BoolListToUint(chunk_length_bits)
                chunk_length_bits = chunk_length_bits * 4 + 4
                chunk_length = BoolListToUint(stream.read(bool, chunk_length_bits))

                for _ in range(chunk_length):
                    ptr -= 1
                    if ptr == -1:
                        return vram[:-256]
                    vram[ptr] = stream.read(bytes, 1)

            offset_bits = stream.read(bool, 2)
            offset_bits = BoolListToUint(offset_bits)
            offset_bits = offset_bits * 4 + 4
            offset = BoolListToUint(stream.read(bool, offset_bits))

            copy_length_bits = stream.read(bool, 2)
            copy_length_bits = BoolListToUint(copy_length_bits)
            copy_length_bits = copy_length_bits * 4 + 4
            copy_length = BoolListToUint(stream.read(bool, copy_length_bits)) + 3

            source = ptr + offset - 1
            for i in range(copy_length):
                ptr -= 1
                vram[ptr] = vram[source]
                source -= 1

            if ptr == -1:
                return vram[:-256]
    except:
        return vram[:-256]

input_file = open(INPUT_FILE_NAME, "rb")
input_data = bytearray(input_file.read())
input_file.close()
decompressed_data = Lz77Decompression(input_data)

if SAVE_AS_PNG:
    DrawTiles(decompressed_data, len(decompressed_data) // 16)
else:
    output_file = open(OUTPUT_FILE_NAME, "wb")
    for d in decompressed_data:
        output_file.write(d)
    output_file.close()
