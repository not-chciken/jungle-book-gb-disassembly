## Compiling

This project depends on [RGBDS](https://github.com/gbdev/rgbds) toolchain.
Assuming RGBDS is installed, the game can be compiled with:

```bash
cd  src
make all
```

## Validation
```bash
md5sum original_game.gb
md5sum built_game.gb
```
The result should be: e5876720bf10345fb2150db6d68c1cfb.

## How The Game Works
Start in `Entry`.
Directly jump to `Main`

Main:
- Disable interrupts.
- Setup stack pointer
- Transfers 10 bytes from $79 into the high RAM.
- Then go to `MainContinued`

MainContinued:
 - Stop display operation (`StopDisplay`).
 - Set lower and upper tile map to zero (`ResetWndwTileMap`).
 - Set RAM to zero (`ResetRam`).
 - Setup sound.
 - Setup screen, lives, timer counter (`SetUpScreen`).
 - Draw "LICENSED BY NINTENDO".
 - Setup interrupts (`SetUpInterruptsSimple`)
 - SoundAndJoypad
 - Wait for a few seconds.
 - Enable timer interrupt (`StartTimer`)
 - Draw virgin logo with "PRESENTS"
 - Reset screen, draw jungle book logo.
 - Draw the menu string.
 - Loop: StartScreen and SkipMode. Allow the player to toggle difficulty by pressing SELECT.
 - Continue if player presses A, B, or START.
 - Start game (`StartGame`)
 - Start 60hz timer.
 - Fade out the song.
 - Draw level name and "GET READY"


## Commands for radare2
```
# Functions
f LoadRomBank @ 0x0
f Main @ 0x61
f Transfer @ 0x6b
f OamTransfer @ 0x79
f CopyData @ 0x83
f ResetWndwTileMapLow @ 0x8d
f ResetWndwTileMap @ 0x92
f ResetRam @ 0x9a
f MemsetZero @ 0xa9
f ReadJoyPad @ 0xb2
f Entry @ 0x101
f GameTitle 14 @ 0x132
f TrippleShiftRightCarry @ 0x145e
f TrippleRotateShiftRight @ 0x1465
f StartTimer @ 0x14c5
f StopDisplay @ 0x14e2
f SetUpInterruptsSimple @ 0x14fa
f SetUpInterruptsAdvanced @ 0x1501
f SetUpInterrupts@ 0x1507
f LoadFontIntoVram @ 0x3eec
f DecompressTilesIntoVram @ 0x3ef2
f Lz77GetItem @ 0x3f85
f Lz77ShiftBitstream0 @ 0x3fc9
f Lz77ShiftBitstream1 @ 0x3fdf

f DrawString @ 0x17529

f LoadSound0.Function @ 0x64000
f InitSound.Function @ 0x64118
f SetVolume @ 0x64dee
f SetUpScreen.Function @ 0x66833

# Data
f Font.Data @ 0x17cd1
Cd 591 @ 0x17cd1
f VirginLogo.Data @ 0x2740a
Cd 1207 @ 0x2740a

f JoyPadData @ 0xc100
f JoyPadNewPresses @ 0xc10
f TimeCounter @ 0x$c103
f CurrentLevel @ 0xc110
f NextLevel @ 0xc10e
f DifficultyMode @ 0xc111
f WeaponSelect @ 0xc183
f CurrentNumDoubleBanana @ 0xc185
f CurrentNumBoomerang @ 0xc186
f CurrentNumStones @ 0xc187
f CurrentSecondsInvincibility @ 0xc188
f InvincibilityTimer @ 0xc189
f CurrentLives @ 0xc1b7
f NumberDiamondsMissing @ 0xc1be
f CurrentHealth @ 0xc1b8
f CurrentScore1 @ 0xc1bb
f CurrentScore2 @ 0xc1bc
f CurrentScore3 @ 0xc1bd
f MaxDiamondsNeeded @ 0xc1bf
f FirstDigitSeconds @ 0xc1c3
f SecondDigitSeconds @ 0xc1c4
f DigitMinutes @ 0xc1c5
f IsPaused @ 0xc1c6
f ColorToggle @ 0xc1c7
f PauseTimer @ 0xc1c8
f CurrentSoundVolume @ 0xc5be

f OldRomBank @ 0x7fff
f VolumeSettings @ 0x64e00
Cd 8 @ 0x64e00

CC Writing into read-only bits... @ 0x00064142
CC "hl = compressed data + meta information in RAM; bc = start address of tiles in VRAM" @ 0x00003ef1
CC VRAM start address of tiles in 0xc109 @ 0x00003ef7
CC length of decompressed data in bc @ 0x00003efc
CC VRAM end address of sprite tiles in de @ 0x00003f03
CC length of compressed data in bc @ 0x00003f07
CC RAM end address of compressed data in hl @0x00003f08
CC first data byte in 0xc106 @0x00003f0a
CC hl pointing to first data byte @0x00003f12
CC VRAM pointer in de @0x00003f70
CC Number of bytes to process in bc @0x00003f16
CC Copy next byte of data into a @0x00003f19
CC Result now in a @0x00003f39
CC Load a into VRAM @0x00003f3b
CC Continue if all bytes have been processed @0x00003f3f
CC Stop if current pointer points to VRAM start @0x00003f4a
CC Uncompressed VRAM(!) data pointer in hl @0x00003f6e
CC Number of loop iterations in bc @0x00003f71
CC Length of next chunk in bc @0x00003f5a

aaa
```

## Writing a decompressor
Font at 0x7cd1 (bank 02). Length 0x0290.
Logo at 0x740a (bank 03). Length 0x07a0.
```radare2
s 0x17cd1 # Font.
pv 1 @ 0x17cd1 # Decompressed data length.
pv 1 @ 0x17cd3 # Compressed data length =0x24b
pr 591 > font.data

s 0x2740a
pv 1 @ 0x2740a # Decompressed data length.
pv 1 @ 0x2740c # Compressed data length.
pr 1207 > logo.data

s 0x26129
pv 1 @ 0x26129 # Decompressed length: 0x200
pv 1 @ 0x2612b # Compressed length: 0x181
pr 289 > todo5.data
```
MD5 checksum of the original file:
e5876720bf10345fb2150db6d68c1cfb

Memory map
0x0000-0x3fff ROM bank 0
0x4000-0x7fff ROM bank N
0x8000-0x9fff VRAM
    0x8000-0x8fff tile data
    0x8800-0x97ff tile data
    0x9800-0x9bff tile map 0
    0x9c00-0x9fff tile map 1
0xa000-0xbfff RAM bank
0xc000-0xdfff internal RAM

ROM1 0x67a6 to 0xd700 comp. length: 0x1d5 decomp. length: 0x3f0 RAM
ROM2 0x78cf to 0x8d80 comp. length: 0x1de decomp. length: 0x280 tile data
ROM3 0x40fa to 0x9000 comp. length: 0x4db decomp. length: 0x6c0 tile data
ROM3 0x49da to 0x96c0 comp. length: 0xd1  decomp. length: 0x140 tile data
ROM3 0x62c6 to 0xc700 comp. length: 0x122 decomp. length: 0x200 RAM
ROM3 0x63ec to 0xc900 comp. length: 0x1c3 decomp. length: 0x1f0 RAM
ROM3 0x6b58 to 0xcb00 comp. length: 0x170 decomp. length: 0x200 RAM
ROM3 0x6ccc to 0xcd00 comp. length: 0x199 decomp. length: 0x1b0 RAM
ROM4 0x4032 to 0xcefe comp. length: 0x49c decomp. length: 0x620 RAM

## How The Backgground Is Rendered
First there seems to be some difference between generic background and other stuff in the background like plants or stones.
The generic stuff sits in the RAM at $c700.

The specific stuff sits in the RAM at $cefe/$cf00.
It is unpacked from data residing in bank 4.

Tiles are added in vertical and horizontal fashions.
For vertical see `DrawNewVerticalTiles` which copies indices residing at $c3c0 into the tile map.
The data is copied from $c700 into $c3c0 in function `Jump_000_10f2`. Always 2 bytes at a time.
The data in $c700 seems to be squarish (12)
                                       (34)

For horizontal see `DrawNewHorizontalTiles` which copies indices residing at $c3d8 into the tile map.
The data is copied from $c700 into $c3cd in function `Jump_000_133b`. Always 2 bytes at a time.

The instructions of what data to copy from $c700 to XX seems to reside in $cb00.
The information in $cb00 is set in Bank 3 in `jr_003_4033`.

There also some difference between loading tiles during the game and an initial rendering phase.

First level width: 96
First level height: 16
Total 16-tile pointers: 1536
First level data: 1538 (first two bytes are level width and height)