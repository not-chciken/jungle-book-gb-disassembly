#!/usr/bin/python

# A script to extract assets from the Game Boy game "Thu Jungle Book".
# The PNG part is inspired from: https://github.com/mattcurrie/mgbdis

import os
import hashlib
import png
import re
import sys

if len(sys.argv) < 3:
  sys.exit("Need arguments! Usage: ./asset_extractor <path_to_symbol_file> <path_to_rom>")

SYMBOL_FILE_PATH = sys.argv[1]
ROM_FILE_PATH = sys.argv[2]
GEN_DIRECTORY = "gfx"
MD5_HASH_GOLDEN = "e5876720bf10345fb2150db6d68c1cfb"

def ConvertPaletteToRgb(palette, bpp):
    col0 = 255 - (((palette & 0x03)     ) << 6)
    col1 = 255 - (((palette & 0x0C) >> 2) << 6)
    col2 = 255 - (((palette & 0x30) >> 4) << 6)
    col3 = 255 - (((palette & 0xC0) >> 6) << 6)
    if bpp == 2:
        return [
            (col0, col0, col0),
            (col1, col1, col1),
            (col2, col2, col2),
            (col3, col3, col3)
        ]
    else:
        return [
            (col0, col0, col0),
            (col3, col3, col3)
        ]

def CoordinateToTileOffset(x, y, width, bpp):
    bytes_per_tile_row = bpp  # 8 pixels at 1 or 2 bits per pixel
    bytes_per_tile = bytes_per_tile_row * 8  # 8 rows per tile
    tiles_per_row = width // 8
    tile_y = y // 8
    tile_x = x // 8
    row_of_tile = y & 7
    return (tile_y * tiles_per_row * bytes_per_tile) + (tile_x * bytes_per_tile) + (row_of_tile * bytes_per_tile_row)

def ConvertToPixelData(data, width, height, bpp):
    result = []
    for y in range(0, height):
        row = []
        for x in range(0, width):
            offset = CoordinateToTileOffset(x, y, width, bpp)

            if offset < len(data):
                # extract the color from the one or two bytes of tile data at the offset
                shift = (7 - (x & 7))
                mask = (1 << shift)
                if bpp == 2:
                    color = ((data[offset] & mask) >> shift) + (((data[offset + 1] & mask) >> shift) << 1)
                else:
                    color = ((data[offset] & mask) >> shift)
            else:
                color = 0

            row.append(color)
        result.append(row)

    return result

# Returns a file index for a given ROM bank and address.
def ToFileInd(rom_bank: int, adr: int) -> int:
    adr = adr if adr < 0x4000 else adr - 0x4000
    return rom_bank * 0x4000 + adr

rf = open(ROM_FILE_PATH, "rb")
rom_data = bytearray(rf.read())
rf.close()
if hashlib.md5(rom_data).digest().hex() != MD5_HASH_GOLDEN:
  sys.exit(f"MD5 hash not matching! Did you provide the correct ROM?")

sf = open(SYMBOL_FILE_PATH, "r")

labels = []
data = []
images = []

for line in sf:
    line = line.strip()
    m = re.search("^([a-fA-F0-9]{2}:[a-fA-F0-9]{4})\s(\w+)$", line)
    if m is not None:
       labels.append(m.groups())

    m = re.search("^([a-fA-F0-9]{2}:[a-fA-F0-9]{4})\s\.data:(\w+)$", line)
    if m is not None:
       data.append(m.groups())

    m = re.search("^([a-fA-F0-9]{2}:[a-fA-F0-9]{4})\s\.image:(\w+):w([0-9]+)?,p([a-fA-F0-9]{2})?$", line)
    if m is not None:
       images.append(m.groups())

sf.close()

# Filter out data in RAM, VRAM, and other non-ROM locations.
data = [d for d in data if int(d[0].split(":")[1], 16) < 0x8000]

if not os.path.exists(GEN_DIRECTORY):
    os.makedirs(GEN_DIRECTORY)

data_to_extract = []
for d in data:
   for l in labels:
      if l[0] == d[0]:
        data_to_extract.append([*d, l[1]])

images_to_extract = []
for i in images:
   for l in labels:
      if l[0] == i[0]:
        images_to_extract.append([*i, l[1]])

for d in data_to_extract:
    a = d[0].split(":")
    ind = ToFileInd(int(a[0], 16), int(a[1], 16))
    length = int(d[1], 16)
    file = open(os.path.join(GEN_DIRECTORY, d[2] + ".bin"), 'w+b')
    file.write(rom_data[ind:ind+length])
    file.close()

for i in images_to_extract:
    a = i[0].split(":")
    ind = ToFileInd(int(a[0], 16), int(a[1], 16))
    length = int(i[1], 16)
    file = open(os.path.join(GEN_DIRECTORY, i[4] + ".2bpp"), 'w+b')
    data = rom_data[ind:ind+length]
    file.write(data)
    file.close()

    width = int(i[2], 16)
    palette = 0xe4 if i[3] is None else int(i[3], 16)
    bpp = 2
    num_tiles = len(data) // (bpp * 8)
    tiles_per_row = width // 8

    if num_tiles < tiles_per_row:
        tiles_per_row = num_tiles
        width = num_tiles * 8

    tile_rows = (num_tiles / tiles_per_row)
    if not tile_rows.is_integer():
        sys.exit('Invalid length or width for image block')

    height = int(tile_rows) * 8

    pixel_data = ConvertToPixelData(data, width, height, 2)
    rgb_palette = ConvertPaletteToRgb(palette, 2)

    f = open(os.path.join(GEN_DIRECTORY, i[4] + ".png"), 'wb')
    w = png.Writer(width, height, alpha=False, bitdepth=2, palette=rgb_palette)
    w.write(f, pixel_data)
    f.close()

print("Assets successfully extracted!")