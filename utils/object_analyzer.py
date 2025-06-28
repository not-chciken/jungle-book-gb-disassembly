#!/usr/bin/python

# A script to analyze the objects in each level.

from bitstream import BitStream
import sys

if len(sys.argv) < 2:
    sys.exit("Need arguments! Usage: ./object.py <path_to_rom>")

INPUT_FILE_NAME = sys.argv[1]

# Returns a file index for a given ROM bank and address.
def ToFileInd(rom_bank: int, adr: int) -> int:
    adr = adr if adr < 0x4000 else adr - 0x4000
    return rom_bank * 0x4000 + adr

def BoolListToUint(blist):
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


LEVEL_OBJS_PTR_LIST = ToFileInd(1, 0x678E)
NUM_OBJ_LIST = ToFileInd(1, 0x6782)
NUM_LEVEL = 12

input_file = open(INPUT_FILE_NAME, "rb")
input_data = bytearray(input_file.read())
input_file.close()

ATR_Y_POSITION_LSB  = 0x01
ATR_Y_POSITION_MSB  = 0x02
ATR_X_POSITION_LSB  = 0x03
ATR_X_POSITION_MSB  = 0x04
ATR_ID = 0x05
ATR_FACING_DIRECTION = 0x07
ATR_FREEZE = 0x0a
ATR_HITBOX_PTR = 0x0f
ATR_STATUS_INDEX = 0x10
ATR_X_POS_LIM_LEFT = 0x13
ATR_X_POS_LIM_RIGHT = 0x14
ATR_LOOT = 0x17

type_arr = ["UNKNOWN"]*256
type_arr[0x01] = "BOAR"
type_arr[0x05] = "WALKING_MONKEY"
type_arr[0x0b] = "COBRA"
type_arr[0x0e] = "EAGLE"
type_arr[0x17] = "ELEPHANT"
type_arr[0x18] = "KING_LOUIE_SLEEP"
type_arr[0x1a] = "STANDING_MONKEY"
type_arr[0x20] = "CRAWLING_SNAKE"
type_arr[0x24] = "FLYING_STONES"
type_arr[0x28] = "CROCODILE"
type_arr[0x2B] = "KAA"
type_arr[0x2C] = "BOSS"
type_arr[0x47] = "FLYING_BIRD"
type_arr[0x54] = "FISH"
type_arr[0x59] = "HIPPO"
type_arr[0x5c] = "BAT"
type_arr[0x67] = "SCORPION"
type_arr[0x6d] = "FROG"
type_arr[0x71] = "ARMADILLO_WALKING"
type_arr[0x75] = "ARMADILLO_ROLLING"
type_arr[0x79] = "PORCUPINE_WALKING"
type_arr[0x7d] = "PORCUPINE_ROLLING"
type_arr[0x81] = "LIGHTNING"
type_arr[0x84] = "FALLING_PLATFORM"
type_arr[0x85] = "LIZZARD"
type_arr[0x89] = "DIAMOND"
type_arr[0x92] = "MONKEY_COCONUT"
type_arr[0x93] = "KING_LOUIE_COCONUT"
type_arr[0x97] = "PINEAPPLE"
type_arr[0x98] = "CHECKPOINT"
type_arr[0x9a] = "GRAPES"
type_arr[0x9b] = "EXTRA_LIFE"
type_arr[0x9c] = "MASK_OR_LEAF"
type_arr[0x9d] = "EXTRA_TIME"
type_arr[0x9e] = "SHOVEL"
type_arr[0x9f] = "DOUBLE_BANANA"
type_arr[0x9f] = "STONES"
type_arr[0xa0] = "BOOMERANG"
type_arr[0xa1] = "SNAKE_PROJECTILE"
type_arr[0xa2] = "HANGING_MONKEY"
type_arr[0xa4] = "HANGING_MONKEY2"
type_arr[0xa9] = "SITTING_MONKEY"
type_arr[0xac] = "TURTLE"
type_arr[0xae] = "SINKING_STONE"
type_arr[0xb7] = "BALOO"
type_arr[0xc3] = "MONKEY_BOSS_TOP"
type_arr[0xc9] = "MONKEY_BOSS_MIDDLE"
type_arr[0xc9] = "MONKEY_BOSS_BOTTOM"
type_arr[0xf2] = "SHERE_KHAN"

def LootIndToStr(ind, level):
    loot_arr = ["-"]*16
    loot_arr[1] = "DIAMOND"
    loot_arr[2] = "PINEAPPLE"
    loot_arr[3] = "GRAPES"
    loot_arr[4] = "EXTRA_LIFE"
    loot_arr[5] = "MASK"
    loot_arr[6] = "EXTRA_TIME"
    loot_arr[7] = "SHOVEL"
    loot_arr[9] = "BOOMERANG"
    if ind == 8:
        return "DOUBLE_BANANA" if level < 4 or level & 1 else "STONES"
    return loot_arr[ind]

def GetLimitStr(x_limit_left, x_limit_right, id):
    if id not in [0x01,0x05, 0x20, 0x24, 0x47, 0x67, 0x5c, 0x59, 0x6d, 0x71, 0x75, 0x79, 0x7d, 0x81, 0x85]:
        return "-"
    return f"{x_limit_left}-{x_limit_right}"


print("Number of objects:")
num_objects = [0]*12
for i in range(NUM_LEVEL):
    num_objects[i] = input_data[NUM_OBJ_LIST + i]
    print(f"Level {i+1}: {num_objects[i]}")
print()

print("Objects per level:")
for i in range(NUM_LEVEL):
    ptr = LEVEL_OBJS_PTR_LIST + i * 2
    compressed_data_ptr = int.from_bytes((input_data[ptr : ptr + 2]), "little")
    compressed_data_ptr = ToFileInd(1, compressed_data_ptr)
    obj_data = Lz77Decompression(input_data[compressed_data_ptr:-1])
    print(f"Level {i+1}")
    print("{:>5}  {:>5}  {:>17}  {:>13}  {:>10}".format("X pos", "Y pos", "Type", "Loot", "X limits"))
    print("------------------------------------------------------------")
    for j in range(num_objects[i]):
        obj = b''.join(obj_data[j*24:j*24+24])
        y_position = int.from_bytes((obj[ATR_Y_POSITION_LSB : ATR_Y_POSITION_LSB + 2]), "little")
        x_position = int.from_bytes((obj[ATR_X_POSITION_LSB : ATR_X_POSITION_LSB + 2]), "little")
        id = int.from_bytes((obj[ATR_ID : ATR_ID + 1]), "little")
        loot_ind = int.from_bytes((obj[ATR_LOOT : ATR_LOOT + 1]), "little") >> 4
        x_limit_left = int.from_bytes((obj[ATR_X_POS_LIM_LEFT : ATR_X_POS_LIM_LEFT + 1]), "little")
        x_limit_right = int.from_bytes((obj[ATR_X_POS_LIM_RIGHT : ATR_X_POS_LIM_RIGHT + 1]), "little")

        x_pos_msb = x_position & ~0xff
        offset = 256 if (x_limit_left + x_pos_msb) >= x_position else 0
        x_limit_left =  x_pos_msb - offset + x_limit_left
        offset = 256 if (x_limit_right + x_pos_msb) <= x_position else 0
        x_limit_right =  x_pos_msb + offset + x_limit_right

        x_limit_str = GetLimitStr(x_limit_left, x_limit_right, id)
        print("{:>5}  {:>5}  {:>17}  {:>13}  {:>10}".format(x_position, y_position, type_arr[id], LootIndToStr(loot_ind, i+1), x_limit_str))
    print()

