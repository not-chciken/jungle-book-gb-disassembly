#!/usr/bin/python

from bitstream import BitStream
from PIL import Image, ImageColor
import os

colors = [ImageColor.getcolor('#000000', 'L'), ImageColor.getcolor('#525252', 'L'), ImageColor.getcolor('#969696', 'L'), ImageColor.getcolor('#ffffff', 'L')]

# Returns a file index for a given ROM bank and address.
def ToFileInd(rom_bank: int, adr: int) -> int:
    adr = adr if adr < 0x4000 else adr - 0x4000
    return rom_bank * 0x4000 + adr

def bool_list_to_uint(blist):
  sum = 0
  for i,v in enumerate(blist[::-1]):
    sum += int(v) * 2**i
  return sum

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
                chunk_length_bits = bool_list_to_uint(chunk_length_bits)
                chunk_length_bits = chunk_length_bits * 4 + 4
                chunk_length = bool_list_to_uint(stream.read(bool, chunk_length_bits))

                for _ in range(chunk_length):
                    ptr -= 1
                    if ptr == -1:
                        return vram
                    vram[ptr] = stream.read(bytes, 1)

            offset_bits = stream.read(bool, 2)
            offset_bits = bool_list_to_uint(offset_bits)
            offset_bits = offset_bits * 4 + 4
            offset = bool_list_to_uint(stream.read(bool, offset_bits))

            copy_length_bits = stream.read(bool, 2)
            copy_length_bits = bool_list_to_uint(copy_length_bits)
            copy_length_bits = copy_length_bits * 4 + 4
            copy_length = bool_list_to_uint(stream.read(bool, copy_length_bits)) + 3

            source = ptr + offset - 1
            for i in range(copy_length):
                ptr -= 1
                vram[ptr] = vram[source]
                source -= 1

            if ptr == -1:
                return vram
    except:
        return vram

# Creates a tile palette from the given data and saves it as an image.
def CreateTilePalette(tile_data, num_tiles, file_name):
    im = Image.new('L', (8, 8 * num_tiles)) # create the Image of size 1 pixel
    row = 0
    tmp = tile_data[0:-256]
    for b1, b2 in zip(tmp[1::2],tmp[0::2]):
        for i in range(8):
            val1 = ((int.from_bytes(b1,"little") >> i) & 1) * 2
            val2 = ((int.from_bytes(b2,"little") >> i) & 1) * 1
            im.putpixel((7 - i, row), colors[val1 + val2])
        row += 1
    im.save(file_name)

ROM_FILE = "jb.gb"
TILE_BASE_PTR = ToFileInd(3, 0x409A) # Base address of the tile pointer array
TXT_BASE_PTR = ToFileInd(3, 0x62AE) # Base address of the 2x2 pointer array
TXT_LOWER_DATA_PTR = ToFileInd(3, 0x62C6) # Address of the lower data for the 2x2 pointer array
FXF_BASE_PTR = ToFileInd(3, 0x6B40) # Base address of the 4x4 pointer array
FXF_LOWER_DATA_PTR = ToFileInd(3, 0x6b58) # Address of the lower data for the 4x4 pointer array
MAP_BASE_PTR = ToFileInd(4, 0x401A)
NUM_LEVELS = 12
LVL_NAMES = [
    "JUNGLE BY DAY",
    "THE GREAT TREE",
    " DAWN PATROL",
    "BY THE RIVER",
    "IN THE RIVER",
    "TREE VILLAGE",
    "ANCIENT RUINS",
    "FALLING RUINS",
    "JUNGLE BY NIGHT",
    "THE WASTELANDS",
    "BONUS",  # Doesn't really have a name.
    "TRANSITIOn",  # Doesn't really have a name.
]
BYTES_PER_TILE = 16

print(f"Reading ROM file '{ROM_FILE}'")
rf = open(ROM_FILE, "rb")
rom_data = bytearray(rf.read())
print(f"Size is {len(rom_data)} bytes\n")
assert len(rom_data) == 131072, "Size of ROM seems to be wrong"

print("Extracting tile base pointers:")
print("Level XX: VRAM address of basic data, ROM address of basic data, VRAM address of special data, ROM address of special data")
lvl_tile_ptrs = []
for l in range(NUM_LEVELS):
    ptr = TILE_BASE_PTR + l * 8
    vram_adr0 = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    rom_adr0 = int.from_bytes((rom_data[ptr + 2 : ptr + 4]), "little")
    vram_adr1 = int.from_bytes((rom_data[ptr + 4 : ptr + 6]), "little")
    rom_adr1 = int.from_bytes((rom_data[ptr + 6 : ptr + 8]), "little")
    lvl_tile_ptrs.append([vram_adr0, rom_adr0, vram_adr1, rom_adr1])

for i, l in enumerate(lvl_tile_ptrs, 1):
    print(f"Level {i:02}: ", end="")
    for a in l:
        print(f"0x{a:04x}", end=" ")
    print()
print()

if not os.path.exists("lr_tmp"):
    os.makedirs("lr_tmp")

print("Creating tile palettes:")
for i, l in enumerate(lvl_tile_ptrs, 1):
    print(f"Level {i:02}:")
    basic_offset = l[0] - 0x9000
    special_offset = l[2] - 0x9000

    ptr = ToFileInd(3, l[1])
    decomp_size = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    comp_size = int.from_bytes((rom_data[ptr + 2 : ptr + 4]), "little")
    print(f"  Basic palette: compressed {comp_size} bytes, decompressed {decomp_size} bytes, offset {basic_offset}")

    lvl_data_basic = Lz77Decompression(rom_data[ptr:-1])
    CreateTilePalette(lvl_data_basic, int(decomp_size / BYTES_PER_TILE), f"lr_tmp/lvl{i}_basic.png")

    if l[3] == 0:
        CreateTilePalette(lvl_data_basic, int(len(lvl_data_basic) / BYTES_PER_TILE), f"lr_tmp/lvl{i}_basic_and_special.png")
        continue

    ptr = ToFileInd(3, l[3])
    decomp_size = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    comp_size = int.from_bytes((rom_data[ptr + 2 : ptr + 4]), "little")
    print(f"  Special palette: compressed {comp_size} bytes, decompressed {decomp_size} bytes, offset {special_offset}")

    lvl_data_special = Lz77Decompression(rom_data[ptr:-1])
    CreateTilePalette(lvl_data_special, int(decomp_size / BYTES_PER_TILE), f"lr_tmp/lvl{i}_special.png")
    # TODO: Combine basic and special.

    lvl_data = lvl_data_basic + lvl_data_special
    CreateTilePalette(lvl_data, int(len(lvl_data) / BYTES_PER_TILE), f"lr_tmp/lvl{i}_basic_and_special.png")
print()

print("Extracting 2x2 pointers:")
print("Level XX: 2x2 pointer")
lvl_txt_ptrs = []
for l in range(NUM_LEVELS):
    ptr = TXT_BASE_PTR + l * 2
    rom_adr = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    lvl_txt_ptrs.append(rom_adr)

for i, p in enumerate(lvl_txt_ptrs, 1):
    print(f"Level {i:02}: 0x{p:04x}")
print()


print("Creating 2x2 palettes:")
print("Level XX: number of 2x2 tiles")
txt_lower_data = Lz77Decompression(rom_data[TXT_LOWER_DATA_PTR:-1])
for ind, ptr in enumerate(lvl_txt_ptrs, 1):
    ptr = ToFileInd(3, ptr)
    txt_upper_data = Lz77Decompression(rom_data[ptr:-1])
    txt_data = txt_lower_data + txt_upper_data
    print(f"Level {ind:02}:", int(len(txt_data)/4))

    input_tiles = Image.open(f"lr_tmp/lvl{ind}_basic_and_special.png")
    in_width, in_height = input_tiles.size
    input_tiles_arr = []
    for i in range(int(in_height/8)):
        cropped_im = input_tiles.crop((0,i*8,8,i*8+8))
        input_tiles_arr.append(cropped_im)
    i, j, k = 0, 0, 0
    result_image = Image.new('L', (int(16*len(txt_data)/4), 16))
    for ld in txt_data:
        ld2 = int.from_bytes(ld, "little")
        if not ld2 >= len(input_tiles_arr):
            result_image.paste(im=input_tiles_arr[ld2], box=(16*k + 8*i, 8*j))
        else:
            pass
        i += 1
        if (i == 2):
            j += 1
            i = 0
        if (j == 2):
            i, j = 0, 0
            k += 1
    result_image.save(f"lr_tmp/lvl{ind}_2x2.png")
print()

print("Extracting 4x4 pointers:")
print("Level XX: 4x4 pointer")
lvl_fxf_ptrs = []
for l in range(NUM_LEVELS):
    ptr = FXF_BASE_PTR + l * 2
    rom_adr = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    lvl_fxf_ptrs.append(rom_adr)

for i, p in enumerate(lvl_fxf_ptrs, 1):
    print(f"Level {i:02}: 0x{p:04x}")
print()

print("Creating 4x4 palettes:")
print("Level XX: number of 4x4 tiles")
fxf_lower_data = Lz77Decompression(rom_data[FXF_LOWER_DATA_PTR:-1])
for ind, ptr in enumerate(lvl_fxf_ptrs, 1):
    ptr = ToFileInd(3, ptr)
    fxf_upper_data = Lz77Decompression(rom_data[ptr:-1])
    fxf_data = fxf_lower_data + fxf_upper_data
    print(f"Level {ind:02}:", int(len(fxf_data)/4))
    input_tiles = Image.open(f"lr_tmp/lvl{ind}_2x2.png")
    result_image = Image.new('L', (int(32*len(fxf_data)/4), 32))

    in_width, in_height = input_tiles.size
    print("Number of input tiles (4x4):", int(in_width/16))

    input_tiles_arr = []
    for i in range(int(in_width/16)):
        cropped_im = input_tiles.crop((i*16,0,i*16+16,16))
        input_tiles_arr.append(cropped_im)

    i, j, k = 0, 0, 0
    for l in fxf_data:
        l2 = int.from_bytes(l, "little")
        if not l2 >= len(input_tiles_arr):
            result_image.paste(im=input_tiles_arr[l2], box=(32*k + 16*i, 16*j))
        i += 1
        if (i == 2):
            j += 1
            i = 0
        if (j == 2):
            i, j = 0, 0
            k += 1

    result_image.save(f"lr_tmp/lvl{ind}_4x4.png")
print()

print("Extracting map pointers:")
print("Level XX: map pointer")
lvl_map_ptrs = []
for l in range(NUM_LEVELS):
    ptr = MAP_BASE_PTR + l * 2
    rom_adr = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    lvl_map_ptrs.append(rom_adr)
    print(f"Level {i:02}: 0x{ptr:04x}")


print("Extracting maps:")
print("Level XX: width, height")
for ind, ptr in enumerate(lvl_map_ptrs, 1):
    ptr = ToFileInd(4, ptr)
    map_data = Lz77Decompression(rom_data[ptr:-1])
    width = int.from_bytes(map_data[0], "little")
    height = int.from_bytes(map_data[1], "little")
    print(f"Level {ind:02}: {width} {height}")
    result_image = Image.new('L', (width * 32, height * 32))
    input_tiles = Image.open(f"lr_tmp/lvl{ind}_4x4.png")
    in_width, in_height = input_tiles.size
    print("Number of input tiles:", int(in_width/32))
    input_tiles_arr = []
    for i in range(int(in_width/32)):
        cropped_im = input_tiles.crop((i*32,0,i*32+32,32))
        input_tiles_arr.append(cropped_im)

    for i,t in enumerate(input_tiles_arr):
        result_image.paste(im=t, box=(i*32, 0))

    i = 0
    for h in range(int(height)):
        for w in range(int(width)):
            e = int.from_bytes(map_data[i + 2], "little")
            i += 1
            result_image.paste(im=input_tiles_arr[e], box=(32*w, 32*h))

    result_image.save(f"lr_tmp/lvl{ind}_map.png")
print()
