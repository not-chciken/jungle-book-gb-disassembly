#!/usr/bin/python

# Returns a file index for a given ROM bank and address.
def ToFileInd(rom_bank: int, adr: int) -> int:
    adr = adr if adr < 0x4000 else adr - 0x4000
    return rom_bank * 0x4000 + adr

ROM_FILE = "jb.gb"
TILE_BASE_PTR = ToFileInd(3, 0x409A)
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


print("Creating tile palettes:")
for i, l in enumerate(lvl_tile_ptrs, 1):
    print(f"Level {i:02}:")
    data0_offset = l[0] - 0x9000
    data1_offset = l[2] - 0x9000

    ptr = ToFileInd(3, l[1])
    decomp_size = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    comp_size = int.from_bytes((rom_data[ptr + 2 : ptr + 4]), "little")
    print(f"  Basic palette: compressed {comp_size} bytes, decompressed {decomp_size} bytes")

    ptr = ToFileInd(3, l[3])
    decomp_size = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
    comp_size = int.from_bytes((rom_data[ptr + 2 : ptr + 4]), "little")
    print(f"  Special palette: compressed {comp_size} bytes, decompressed {decomp_size} bytes")
print()