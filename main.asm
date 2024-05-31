SECTION "bank0", ROM0[$0]

INCLUDE "constants.asm"

; a = ROM bank index
LoadRomBank:
  ld [ROM_BANK_SELECT], a
  ret
  nop
  nop
  nop
  nop

; Sets lower and upper window tile map to zero.
ResetWndwTileMapLow:
   ld bc, WNDW_TILE_MAP_SIZE
   ld hl, WNDW_TILE_MAP_LOW
   jr MemsetZero

ResetRam:
  ld bc, $a0
  ld hl, INTERNAL_RAM_LOW
  call MemsetZero
  ld hl, INTERNAL_RAM_LOW
  ld bc, $1ff8

; hl = start address, bc = length
MemsetZero:
  ld [hl], $00
  inc hl
  dec bc
  ld a, b
  or c
  jr nZ, MemsetZero
  ret

Main:
  di
  ld sp, $fffe
  call Transfer
  jp MainContinued

; Transfers 10 bytes from 0x79 into the high RAM.
Transfer:
  ld c, $80
  ld b, $0a
  ld hl, $79
: ldi a, [hl]
  ld [$ff00 + c], a
  inc c
  dec b
  jr nZ, :-
  ret

MainContinued:
  call StopDisplay
  call ResetTileMapLow
  call ResetRam
  ld a, 7
  rst $00
  call LoadSound0;
  call SetupScreen;
  ld a, 7
  rst $00
  ret ; CONTINUE HERE

SECTION "Header", ROM0[$100]
	jp Entry
	ds $150 - @, 0 ; Make room for the header

; Waits for RegLY 128 and then stops display operation
StopDisplay:
  di
  ld a, [rIE]
  ld c, a
  res 0, a
  ld [rIE], a
: ld a, [rLY]
  cp $91
  jr nZ, :-
  ld a, [rLCDC]
  and $7f
  ld [rLCDC], a
  ld a, c
  ld [rIE], a
  ret

Lz77GetItem:
  xor a
  ld b, a
  ld c, a
  call CompressedDataShift1
  adc a
  call CompressedDataShift1
  adc a
  jr Z, .Load4Bit
  dec a
  jr Z, .Load8Bit
  dec a
  jr Z, .Load12Bit
.Load16Bit:
  ld a, $04
: call CompressedDataShift1
  rl c
  rl b
  dec a
  jr nZ, :-
.Load12Bit:
  ld a, $04
: call CompressedDataShift1
  rl c
  rl b
  dec a
  jr nZ, :-
.Load8Bit:
  ld a, $04
: call CompressedDataShift1
  rl c
  rl b
  dec a
  jr nZ, :-
.Load4Bit:
  ld a, $04
: call CompressedDataShift1
  rl c
  rl b
  dec a
  jr nZ, :-
  ret

Lz77ShiftBitstream2:
  sla [hl]
  ret nZ
  di
  push af
  push hl
  add sp, $06
  pop hl
  ldd a, [hl]
  ld [$c106], a
  push hl
  add sp, $fa
  pop hl
  pop af
  rl [hl]
  ei
  ret

Lz77ShiftBitstream1:
  sla [hl]
  ret nZ
  di
  push af
  push hl
  add sp, $8
  pop hl
  ldd a, [hl]
  ld [$c106], a
  push hl
  add sp, $f8
  pop hl
  pop af
  rl [hl]
  ei
  ret
  add sp, $f8
  pop hl
  pop af
  rl [hl]
  ei
  ret
  ld d, $fb
  ret

SECTION "bank7", ROMX, BANK[7]

LoadSound1:
  jp LoadSound2

LoadSound2:
  ld a, $00
  ld [rAUDENA], a
  ld a, $ff
  ld [$c500], a
  push bc
  inc a
  ld [$c504], a
  ld [$c506], a
  ld [$c5be], a
  ld [$c5a6], a
  ld a, $ff
  ld [$c5c3], a
  ld [$c501], a
  inc a
  ld [$c5c5], a
  ld [$c5cb], a
  ld [$c5c4], a
  ld a, $8f
  ld [rAUDENA], a
  ld a, $ff
  ld [rAUDVOL], a
  ld [rAUDTERM], a
  ret

SetUpScreen:
  xor a
  ld [$c500], a
  ld [rSCX], a
  ld [rSCY], a
  ld [rWY], a
  dec a
  ld [$c10e], a
  ld a, $07
  ld [rWX], a
  ld a, $0c
  ld [$c502], a
  ld a, $c0
  ld [$c503], a
  ld a, $a0
  ld [$c103], a
  ld a, $06
  ld [$c1b7], a
  ld a, $04
  ld [$c1fc], a
  ret
