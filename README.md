![build badge](https://github.com/not-chciken/jungle-book-gb-disassembly/actions/workflows/build.yml/badge.svg)

# "The Jungle Book" Disassembly (Game Boy)

This is a disassembly of Game Boy game "The Jungle Book".
Additionally, this repository contains tools to understand and modify the game.

__This project does promote piracy and requires a copy of the original game to compile.__
For more information see "Building".
Note that this project is still work in progress with contributions being welcome :)

## Building

To avoid problems with copyright, this project just provides some kind of skeleton code without any assets, such as sprites and logos.
In the code, these assets are represented by external dependencies (`INCBIN <path_to_asset>`).
To get everything compiled, you need to extract the assets from an original copy of the game with the following script:
```bash
./utils/asset_extractor jb.sym <path_to_original_copy>
```
This will create a directory `assets` including the subdirectories of `bin` and `gfx`.
Subsequently, copy `bin` and `gfx` to `src`:
```bash
cp -r assets/bin src/bin
cp -r assets/gfx src/gfx
```
Now everything is in place and you can start the compilation using the [RGBDS](https://github.com/gbdev/rgbds) toolchain.
Assuming RGBDS is installed, the game can be compiled with:
```bash
cd  src
make all
```
The compiled game can then be found as `game.gb`.
If you didn't modify the source code of this repository, `game.gb` should be a bit-exact copy of the original game.
This can quickly be verified with an MD5 hash:
```bash
md5sum original_game.gb
md5sum built_game.gb
```
The result should be `e5876720bf10345fb2150db6d68c1cfb`.

## Progress
The project is still work in progress with the following status per file:

| File Name    | Labels identified |
|--------------|-------------------|
| bank_000.asm | 29.7% (218/733)   |
| bank_001.asm | 24.7% (112/453)   |
| bank_002.asm | 34.5% (68/197)    |
| bank_003.asm | 100.0% (40/40)    |
| bank_004.asm | 15.6% (14/90)     |
| bank_005.asm | 23.1% (28/121)    |
| bank_006.asm | 6.6% (13/196)     |
| bank_007.asm | 2.7% (14/528)     |

In total, the progress is 21.5% (507/2358).

## Tools & Assets

### Level Renderer
Initially, this project was started to extract the level maps from the game's ROM.
Because having a map with all gem locations is a significant aid to beat the game and also helps to plan speed runs.
I anticipated there would just be a memory location containing the map indices and map tiles.
It turns out I was wrong as the game uses way too many tricks to cram the 10+2 maps into the 128 kiB of the cartridge.
Nevertheless, after spending way too much time on reverse-engineering decompression algorithms and meta tiles the final product can be found under `utils/level_renderer.py`.
Provide the original game as an argument and execute it as:

```bash
./level_renderer.py <path_to_rom>
```

The maps can then be found in the directory `lr_tmp`.
For instance, the map of the first level looks like this:

![Map of Level 1](lvl1_map.png)

### Decompressor
Many assets of the game are LZ77 decompressed.
Use the `decompressor.py` script to decompress the binary data. Optionally, the data can be rendered as tiles.
For example, when decompressing and rendering the font data:

```bash
./decompressor.py CompressedFontTiles.bin
```

You get:

![Font data](font.png)

### Symbol File
The file `jb.sym` is a symbol file following the file format from [RGBDS](https://rgbds.gbdev.io/sym).
It can be loaded into many Game Boy tools, such as [Gearboy](https://github.com/drhelius/Gearboy), for an improved debugging experience.