

## Commands for radare2
```
# Functions
f LoadRomBank @ 0x0
f Main @ 0x61
f Transfer @ 0x6b
f OamTransfer @ 0x79
f ResetWndwTileMap @ 0x92
f ResetRam @ 0x9a
f MemsetZero @ 0xa9
f ReadJoyPad @ 0xb2
f Entry @ 0x101
f GameTitle 14 @ 0x132
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
f LoadSound1.Function @ 0x64118
f SetVolume @ 0x64dee
f SetUpScreen.Function @ 0x66833

# Data
f Font.Data @ 0x17cd1
Cd 591 @ 0x17cd1
f VirginLogo.Data @ 0x2740a
Cd 1207 @ 0x2740a
f JoyPadData @ 0xc100
f JoyPadNewPresses @ 0xc101
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