#!/usr/bin/python

# A script to extract frames and animation.

from PIL import Image, ImageColor, ImageOps, ImageSequence
import os

def ConcatenateImage(image_path1, image_path2, output_path):
    img1 = Image.open(image_path1)
    img2 = Image.open(image_path2)

    if img1.width != img2.width:
        img2 = img2.resize((img1.width, int(img2.height * img1.width / img2.width)))

    total_height = img1.height + img2.height
    new_img = Image.new("RGBA", (img1.width, total_height))
    new_img.paste(img1, (0, 0))
    new_img.paste(img2, (0, img1.height))
    new_img.save(output_path)
    print(f"Saved concatenated image to {output_path}")

def U8ToSigned(val):
    return val if val < 128 else (256 - val) * -1

def CreateFrame(image_path, output_path, x_size, y_size, index_list):
    original = Image.open(image_path)
    print(f"Using sprite palette {image_path}")
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

    inverted_image = ImageOps.invert(new_image)
    pixels = inverted_image.load()
    for y in range(inverted_image.height):
        for x in range(inverted_image.width):
            if pixels[x, y] == 0:
                pixels[x, y] = 255  # Map black to white
    inverted_image.save(ANIM_BASE_PATH + output_path)

    print(f"Saved frame to {output_path}")

def PadGifToFixedSize(input_path, output_path, target_size):
    target_width, target_height = target_size
    with Image.open(input_path) as im:
        frames = []

        for frame in ImageSequence.Iterator(im):
            frame = frame.convert("RGBA")  # Ensure alpha channel

            # Calculate padding
            x_pad = max((target_width - frame.width) // 2, 0)
            y_pad = max((target_height - frame.height) // 2, 0)

            # Create a white background image
            new_frame = Image.new("RGBA", target_size, (255, 255, 255, 255))
            new_frame.paste(frame, (x_pad, y_pad))

            frames.append(new_frame)

        # Save all frames back to a new GIF
        frames[0].save(
            output_path,
            save_all=True,
            append_images=frames[1:],
            duration=im.info.get("duration", 100),
            loop=im.info.get("loop", 0),
            disposal=2,
        )
        print(f"Padded GIF saved to {output_path}")

ROM_FILE_PATH = "../src/game.gb"
ANIM_BASE_PATH = "animations"

if not os.path.exists("../assets/"):
    print("Cannot find asset directory!")
    exit(1)

if not os.path.exists(ANIM_BASE_PATH):
    os.makedirs(ANIM_BASE_PATH)

ConcatenateImage("../assets/gfx/CrawlingSnakeSprites.png", "../assets/gfx/MosquitoSprites.png", "../assets/gfx/SnakeMosquitoSprites.png")

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
palettes[0x10] = "SnakeMosquitoSprites"
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
     ["Boar",           0x01, 4],
     ["WalkingMonkey",  0x05, 6],
     ["Cobra",          0x0b, 4],
     ["Eagle",          0x0f, 8],
     ["StandingMonkey", 0x1a, 6],
     ["CrawlingSnake",  0x20, 4],
     ["Crocodile",      0x28, 3],
     ["Kaa",            0x2b, 10],
     ["Mosquito",       0x24, 4],
     ["Fish",           0x54, 5],
     ["Hippo",          0x59, 3],
     ["Bat",            0x5c, 8],
     ["Lizzard",        0x85, 4],
     ["Scorpion",       0x67, 5],
     ["Frog",           0x6d, 3],
     ["Armadillo",      0x71, 8],
     ["Porcupine",      0x79, 8],
     ["JumpingFrog",    0xaf, 4],
    # ["Baloo",          0xb7, 12],
    # ["MonkeyBoss",    0xc3, 12],
     ["VillageGirl",    0xe2, 2],
    # ["ShereKhan",     0xe4, 12],
]

# Returns a file index for a given ROM bank and address.
def ToFileInd(rom_bank: int, adr: int) -> int:
    adr = adr if adr < 0x4000 else adr - 0x4000
    return rom_bank * 0x4000 + adr

PixelOffsets = ToFileInd(4, 0x7c06)
SpritePalettes = ToFileInd(4, 0x7e4e)
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
    print(f"################ {name} ################")
    if not os.path.exists(f"{ANIM_BASE_PATH}/{name}"):
        os.makedirs(f"{ANIM_BASE_PATH}/{name}")

    for i in range(size):
        print(f"Frame {i}")
        y_size = rom_data[NumObjectSprites + id + i] & 0xf
        x_size = rom_data[NumObjectSprites + id + i] >> 4
        total_sprites = x_size * y_size
        p = rom_data[SpritePalettes + id + i]
        p_name = palettes[p]
        print("Size  ", x_size, y_size)
        ptr = ObjAnimationIndicesPtr + id * 2 + i * 2
        offset = int.from_bytes((rom_data[ptr : ptr + 2]), "little")
        print("Offset", hex(offset))
        ptr = ObjAnimationIndices + offset
        index_list = []
        for j in range(total_sprites):
          index_list.append(int((rom_data[ptr + j] - 4)/ 2 ))
        print("Indices", index_list)
        CreateFrame("../assets/gfx/" + p_name + ".png", f"/{name}/frame{i}.png", x_size, y_size, index_list)

    print("Creating animation from frames")

    max_xo, min_xo = 0, 0
    max_yo, min_yo = 0, 0
    for i in range(size):
        xo = U8ToSigned(rom_data[PixelOffsets + id * 2 + i * 2])
        yo = U8ToSigned(rom_data[PixelOffsets + id * 2 + i * 2 + 1])
        max_xo = max(max_xo, xo)
        max_yo = max(max_yo, yo)
        min_xo = min(min_xo, xo)
        min_yo = min(min_yo, yo)

    max_xo += -min_xo
    max_yo += -min_yo

    file_list = [f"{ANIM_BASE_PATH}/{name}/frame{i}.png" for i in range(size)]
    images = [Image.open(f).convert("RGBA") for f in file_list]
    total_width = sum(max_xo + img.width for img in images)
    max_height = max(img.height for img in images)
    max_width = max(img.width for img in images)
    min_width = min(img.width for img in images)

    for ind, img in enumerate(images):
        corrected_image = Image.new("RGBA", (max_width + max_xo, max_height + max_yo), (255, 255, 255, 255))
        xo = U8ToSigned(rom_data[PixelOffsets + id * 2 + ind * 2])
        yo = U8ToSigned(rom_data[PixelOffsets + id * 2 + ind * 2 + 1])

        wo = 0
        if img.width != max_width:
            wo = (max_width - min_width) // 2

        print("Offsets:", xo - min_xo, yo - min_yo)
        corrected_image.paste(img, (xo - min_xo + wo, yo - min_yo))
        corrected_image.save(f"{ANIM_BASE_PATH}/{name}/frame{ind}_corrected.png")

    file_list = [f"{ANIM_BASE_PATH}/{name}/frame{i}_corrected.png" for i in range(size)]
    images = [Image.open(f).convert("RGBA") for f in file_list]

    images[0].save(
        f"{ANIM_BASE_PATH}/{name}/animation.webp",
        save_all=True,
        append_images=images[1:],
        duration=200,
        loop=0,                     # 0 = loop forever
        format='WEBP'
    )

    PadGifToFixedSize(f"{ANIM_BASE_PATH}/{name}/animation.webp", f"{ANIM_BASE_PATH}/{name}/fixed_size_animation.webp", target_size=(64, 64))
    print()
