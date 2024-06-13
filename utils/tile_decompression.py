#!/usr/bin/python

from bitstream import BitStream

INPUT_FILE_NAME = "font.data"
OUTPUT_FILE_NAME = "font.png"

def bool_list_to_uint(blist):
  sum = 0
  for i,v in enumerate(blist[::-1]):
    sum += int(v) * 2**i
  return sum


from PIL import Image, ImageColor

colors = [ImageColor.getcolor('#000000', 'L'), ImageColor.getcolor('#525252', 'L'), ImageColor.getcolor('#969696', 'L'), ImageColor.getcolor('#ffffff', 'L')]

def draw_tiles(vram, num_tiles):
  im = Image.new('L', (8, 8 * num_tiles)) # create the Image of size 1 pixel
  row = 0
  tmp = vram[0:-256]
  for b1, b2 in zip(tmp[1::2],tmp[0::2]):
    for i in range(8):
        val1 = ((int.from_bytes(b1,"little") >> i) & 1) * 2
        val2 = ((int.from_bytes(b2,"little") >> i) & 1) * 1
        im.putpixel((7 - i, row), colors[val1 + val2])
    row += 1
  im.save(OUTPUT_FILE_NAME)

with open(INPUT_FILE_NAME, 'rb') as f:
  decomp_data_size = int.from_bytes(f.read(2), byteorder='little', signed=False)
  print("decompressed data size:", decomp_data_size)
  vram = [bytes(b'\00')] * (decomp_data_size + 256)
  ptr = decomp_data_size

  comp_data_size = int.from_bytes(f.read(2), byteorder='little', signed=False)
  print("compressed data size:", comp_data_size)

  exit()

  data = bytearray(f.read(comp_data_size))
  data = bytes(data[::-1])

  stream = BitStream()
  stream.write(data, bytes)

  while True:
    skip_pattern = stream.read(bool, 1)[0]
    if not skip_pattern:
      chunk_length_bits = stream.read(bool, 2)
      chunk_length_bits = bool_list_to_uint(chunk_length_bits)
      chunk_length_bits = chunk_length_bits * 4 + 4
      print("Chunk length bits:", chunk_length_bits)
      chunk_length = bool_list_to_uint(stream.read(bool, chunk_length_bits))
      print("Chunk length:", chunk_length)

      for _ in range(chunk_length):
        ptr -= 1
        vram[ptr] = stream.read(bytes, 1)
        #print(vram[ptr].hex())
    else:
      print("Skipping!")

    assert(chunk_length != 0)

    offset_bits = stream.read(bool, 2)
    offset_bits = bool_list_to_uint(offset_bits)
    offset_bits = offset_bits * 4 + 4
    print("Offset bits:", offset_bits)
    offset = bool_list_to_uint(stream.read(bool, offset_bits))
    print("Offset:", offset)

    copy_length_bits = stream.read(bool, 2)
    copy_length_bits = bool_list_to_uint(copy_length_bits)
    copy_length_bits = copy_length_bits * 4 + 4
    print("Copy length bits:", copy_length_bits)
    copy_length = bool_list_to_uint(stream.read(bool, copy_length_bits)) + 3
    print("Copy length:", copy_length)

    source = ptr + offset - 1
    for i in range(copy_length):
      ptr -= 1
      vram[ptr] = vram[source]
      source -= 1

    if ptr == 0:
      draw_tiles(vram, int(decomp_data_size / 16))
      exit()
    print()






# End address of tiles 0x8f70
#
# 1c 0c 1c 0c 3c 18 38 30
#
# 1c 0c 1c 0c 3c 18 38 30
# 00 00 7e 3c 7e 66 0e 06
# 1e 0c 1c 18 08 00 18 18
# 00 00 00 00 00 00 0e 0c
# 00 00 1c 18 00 00 00 00

# Wrong:
# 00 0e 0c 3c 18 38 18 30
# 3c 18 30 3c 18 3c 1c 00
# 00 1c 38 30 3c 18 3c 1c
# 0c 3c 1c 0c 3c 18 38 30
# 00 00 7e 3c 7e 66 0e 06
# 1e 0c 1c 18 08 00 18 00 <- wrong
# 00 00 00 00 00 00 0e 0c
# 00 00 1c 18 00 00 00 00

# pattern length
# 0x01
# 0x06

# pattern
# 1 0x00
# 2 0x18
# 2 0x1c
# ...

# offsets
# 1, 10, 12, 2, 40, 8, 2, 24, 52
# 1, 64, 80, 16, 68, 70, 92, 16,
# 160, 4, 3, 150, 96, 16, 16,
# 32, 32, 149, 80, 30, 224, 64
# 144, 1, 48, 1, 0, 48
#         |
#         this is 304 but should be 48
# copy length
# 0 + 3
# 1 + 3

# CompressedDatashiftbytes
# Note that first byte is set without this function
# (02) 00 08 01 86 07
