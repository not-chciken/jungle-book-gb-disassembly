#!/usr/bin/python

from PIL import Image, ImageColor, ImageOps
import os

def CreateFrame(image_path, output_path, x_size, y_size, index_list):
    original = Image.open(image_path)
    sprite_width = 8
    sprite_height = 16

    new_image = Image.new("L", (sprite_width * x_size, sprite_height * y_size))

    for j, index in enumerate(index_list):
        src_x = 0
        src_y = index * sprite_height
        sprite = original.crop((src_x, src_y, src_x + sprite_width, src_y + sprite_height))
        dest_x = (j % x_size) * sprite_width
        dest_y = (j // x_size) * sprite_height
        new_image.paste(sprite, (dest_x, dest_y))

    # Save result
    inverted_image = ImageOps.invert(new_image)
    pixels = inverted_image.load()
    for y in range(inverted_image.height):
        for x in range(inverted_image.width):
            if pixels[x, y] == 0:
                pixels[x, y] = 255  # Map black to white
    inverted_image.save(ANIM_BASE_PATH + output_path)

    print(f"Saved reorganized sprite sheet to {output_path}")


if not os.path.exists("animations"):
    os.makedirs("animations")

#CreateFrame("../assets/gfx/" + files[4] + ".png", "test.png", 2)
#CreateFrame("../assets/gfx/" + files[0] + ".png", "test.png", 4)
#CreateFrame("../assets/gfx/" + files[5] + ".png", "test.png", 3)
#CreateFrame("../assets/gfx/" + files[8] + ".png", "test.png", 3)
#CreateFrame("../assets/gfx/" + files[9] + ".png", "test.png", 3)

ROM_FILE_PATH = "../src/game.gb"
ANIM_BASE_PATH = "animations"

palettes = [0]*256
palettes[0x07] = "AssetSprites"
palettes[0x08] = "SittingMonkeySprites"
palettes[0x09] = "BoarSprites"
palettes[0x0a] = "WalkingMonkeySprites3"
palettes[0x0b] = "CobraSprites"
palettes[0x0c] = "EagleSprites"
palettes[0x0d] = "EagleSprites2"
palettes[0x0e] = "ElephantTrunkSprites"
palettes[0x0f] = "StoneSprites"
palettes[0x10] = "CrawlingSnakeSprites"
palettes[0x11] = "CrocodileSprites"
palettes[0x12] = "KaaSprites2"
palettes[0x13] = "KaaSprites"
palettes[0x14] = "BonusSprites"
palettes[0x15] = "FlyingBirdSprites"
palettes[0x16] = "FlyingBirdTurnSprites"
palettes[0x17] = "WalkingMonkeySprites"
palettes[0x18] = "WalkingMonkeySprites2"
palettes[0x19] = "FishSprites"
palettes[0x1a] = "HippoSprites"
palettes[0x1b] = "BatSprites"
palettes[0x1c] = "LizzardSprites"
palettes[0x1d] = "ScorpionSprites"
palettes[0x1e] = "FrogSprites"
palettes[0x1f] = "ArmdadilloSprites"
palettes[0x20] = "PorcupineSprites"
palettes[0x21] = "BalooBossDanceSprites"
palettes[0x22] = "BalooBossJumpSprites"
palettes[0x23] = "MonkeyBossSprites"
palettes[0x24] = "HangingMonkeySprites"
palettes[0x25] = "KingLouieHandSprites"
palettes[0x26] = "KingLouieSprites"
palettes[0x27] = "KingLouieActionSprites"
palettes[0x28] = "ShereKhanSprites"
palettes[0x29] = "ShereKhanActionSprites"
palettes[0x2a] = "ShereKhanHandSprites"
palettes[0x2b] = "VillageGirlSprites"


all_objects = [
    ["Boar",          0x01, 4, "BoarSprites"],
    ["WalkingMonkey", 0x05, 6, "WalkingMonkeySprites3"],
    ["Cobra",         0x0b, 4, "CobraSprites"],
    ["Eagle",         0x0f, 8, "EagleSprites"],
    # [0x17, 1, "ElephantTrunkSprites"],
    ["Mosquito",      0x24, 4, "MosquitoSprites"],
    ["Bat",           0x5c, 11, "BatSprites"],
    ["Lizzad",        0x85, 4, "LizzardSprites"],
    ["Hippo",         0x59, 3, "HippoSprites"],
    ["Scorpion",      0x67, 6, "ScorpionSprites"],
    ["Frog",          0x6d, 4, "FrogSprites"],
    ["Armadillo1",    0x71, 4, "ArmdadilloSprites"],
    ["Armadillo2",    0x75, 4, "ArmdadilloSprites"],
    ["Porcupine1",    0x79, 4, "PorcupineSprites"],
    ["Porcupine2",    0x7d, 4, "PorcupineSprites"],
    ["Bonus",         0x81, 3, "BonusSprites"],
]

# Returns a file index for a given ROM bank and address.
def ToFileInd(rom_bank: int, adr: int) -> int:
    adr = adr if adr < 0x4000 else adr - 0x4000
    return rom_bank * 0x4000 + adr

SpritePalettes = ToFileInd(4, 0x74e4)
ObjAnimationIndices = ToFileInd(4, 0x72b1)
ObjAnimationIndicesPtr = ToFileInd(4, 0x789a)
NumObjectSprites = ToFileInd(4, 0x7ae2)

rf = open(ROM_FILE_PATH, "rb")
rom_data = bytearray(rf.read())
rf.close()

for obj in all_objects:
    name = obj[0]
    id = obj[1]
    size = obj[2]
    print(f"######## {name} ########")
    if not os.path.exists(f"{ANIM_BASE_PATH}/{name}"):
        os.makedirs(f"{ANIM_BASE_PATH}/{name}")

    for i in range(size):
        print(f"Frame {i}")
        y_size = rom_data[NumObjectSprites + id + i] & 0xf
        x_size = rom_data[NumObjectSprites + id + i] >> 4
        total_sprites = x_size * y_size
        print("Size  ", x_size, y_size)
        ptr = ObjAnimationIndicesPtr + id * 2 + i * 2
        offset = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
        print("Offset", hex(offset))
        ptr = ObjAnimationIndices + offset
        index_list = []
        palette_list = []
        for j in range(total_sprites):
          print(hex(rom_data[ptr + j]))
          index_list.append((rom_data[ptr + j] - 4)/ 2 )
        CreateFrame("../assets/gfx/" + obj[3] + ".png", f"/{name}/frame{i}.png", x_size, y_size, index_list)

    file_list = [f"animations/{name}/frame{i}.png" for i in range(size)]
    images = [Image.open(f).convert("RGBA") for f in file_list]

    total_width = sum(img.width for img in images)
    max_height = max(img.height for img in images)
    combined_image = Image.new("RGBA", (total_width, max_height), (255, 255, 255, 255))

    x_offset = 0
    for img in images:
        y_offset = max_height - img.height
        combined_image.paste(img, (x_offset, y_offset))
        x_offset += img.width
    combined_image.save(f"animations/{name}/{name}.webp")

    # images[0].save(
    #     f"{obj[2]}.webp",
    #     save_all=True,
    #     append_images=images[1:],
    #     duration=350,      # duration per frame in milliseconds
    #     loop=0,            # 0 = loop forever, 1 = loop once
    #     format='WEBP'
    # )