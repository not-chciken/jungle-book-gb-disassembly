SECTION "bank0", ROM0[$0]

INCLUDE "hardware.inc"
INCLUDE "constants.asm"
INCLUDE "data.asm"

DEF LICENSE_STRING EQU $75d3 ; bank 02
DEF COMPRESSED_FONT_DATA EQU $7cd1 ; bank 02

; a = ROM bank index
LoadRomBank:
  ld [rROMB0], a
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
  ld hl, _RAM
  call MemsetZero
  ld hl, _RAM
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

; Transfers 10 bytes from $79 into the high RAM.
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
  call ResetWndwTileMapLow
  call ResetRam
  ld a, 7
  rst $00
  call LoadSound0
  call SetUpScreen
  ld a, 2
  rst $00
  call LoadFontIntoVram
  ld hl, LICENSE_STRING
  ld de, $9900              ; Window tile map
  call DrawString;          ; Draws "LICENSED BY NINTENDO"

  ; TODO: Continue here
.spin:
  jp .spin

SECTION "Header", ROM0[$100]
	jp Main
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

LoadFontIntoVram:
  ld hl, COMPRESSED_FONT_DATA
  ld de, $8ce0

; Implements an LZ77 decompression.
;
; Data is constructed as follows:
; byte[0] = length of compressed data
; byte[1] = length of uncompressed data
; byten[N] = set of LZ77 3-tuples
;
; LZ77 3-tuples are constructed as follows:
; bit[0] = skip symbol if 1
; bit[1:2] = symbol length bits (0b00 = 4 bits, 0b01 = 8 bits, ...) (skipped if bit[0] = 1)
; bit[3:3+length_bits] = symbol length in bytes                     (skipped if bit[0] = 1)
; bit[N:N+symbol_length] = symbol data                              (skipped if bit[0] = 1)
; bit[M:M+1] = offset length bits
; bit[M+2:M+2+length_bits-1] = offset in bytes
; bit[O:O+1] = copy length bits
; bit[O+2:O+2+length_bits-1] = copy length - 3 in bytes (i.e. a value of 0 corresponds to a length of 3)
;
; hl = pointer to compressed data, de = destination of decompressed data
DecompressTilesIntoVram:
  ld a, e
  ld [$c109], a
  ld a, d
  ld [$c10a], a               ; VRAM start address of tiles in $c109.
  ld c, [hl]
  inc hl
  ld b, [hl]                  ; Length of decompressed data in bc.
  inc hl
  push hl
  ld h, d
  ld l, e
  add hl, bc
  ld d, h
  ld e, l                     ; VRAM end address of sprite tiles in de
  pop hl
  ld c, [hl]
  inc hl
  ld b, [hl]                  ; Length of compressed data in bc.
  add hl, bc                  ; RAM end address of compressed data in hl.
  ldd a, [hl]
  ld [$c106], a               ; First compressed data byte in $c106.
  push hl
  ld hl, $c106
  scf
  rl [hl]                     ; hl pointing to first data byte.
  jr C, .Skip
.Start
  call Lz77GetItem            ; Number of bytes to process in bc
: xor a                       ; Copy next byte of symbol data into a
  call Lz77ShiftBitstream0
  adc a
  call Lz77ShiftBitstream0
  adc a
  call Lz77ShiftBitstream0
  adc a
  call Lz77ShiftBitstream0
  adc a
  call Lz77ShiftBitstream0
  adc a
  call Lz77ShiftBitstream0
  adc a
  call Lz77ShiftBitstream0
  adc a
  call Lz77ShiftBitstream0
  adc a                       ; Symbol now in a
  dec de
  ld [de], a                  ; Load symbol into VRAM
  dec bc
  ld a, b
  or c
  jr nZ, :-                   ; Continue if all bytes have been processed
  ld a, [$c10a]
  cp d
  jr nZ, .Skip
  ld a, [$c109]
  cp e                        ; Stop if current pointer points to VRAM start
  jr C, .Skip
  jr .Skip
.FirstBitCheck
  call Lz77ShiftBitstream0
  jr nC, .Start
.Skip
  call Lz77GetItem
  inc l
  ld [hl], c
  inc l
  ld [hl], b                  ; Offset in bc
  dec l
  dec l
  call Lz77GetItem
  push hl
  inc bc
  inc bc
  inc bc
  push bc                     ; Copy length in bc
  inc l
  ld c, [hl]
  inc l
  ld b, [hl]
  ld h, d
  ld l, e
  dec hl
  add hl, bc
  pop bc
: ldd a, [hl]                 ; Uncompressed VRAM(!) data pointer in hl
  dec de
  ld [de], a                  ; VRAM pointer in de
  dec bc                      ; Number of loop iterations in bc
  ld a, b
  or c
  jr nZ, :-
  pop hl
  ld a, [$c10a]
  cp d
  jr nZ, .FirstBitCheck
  ld a, [$c109]
  cp e
  jr C, .FirstBitCheck
  pop hl
  ret

; Gets one LZ77 item and stores it in bc.
; This can either be symbo length, offset, or length.
Lz77GetItem:
  xor a
  ld b, a
  ld c, a
  call Lz77ShiftBitstream1
  adc a
  call Lz77ShiftBitstream1
  adc a
  jr Z, .Load4Bit
  dec a
  jr Z, .Load8Bit
  dec a
  jr Z, .Load12Bit
.Load16Bit:
  ld a, $04
: call Lz77ShiftBitstream1
  rl c
  rl b
  dec a
  jr nZ, :-
.Load12Bit:
  ld a, $04
: call Lz77ShiftBitstream1
  rl c
  rl b
  dec a
  jr nZ, :-
.Load8Bit:
  ld a, $04
: call Lz77ShiftBitstream1
  rl c
  rl b
  dec a
  jr nZ, :-
.Load4Bit:
  ld a, $04
: call Lz77ShiftBitstream1
  rl c
  rl b
  dec a
  jr nZ, :-
  ret

; Shift the compressed input bit stream by one bit.
; Depending on the call stack you either call Lz77ShiftBitstream0 or Lz77ShiftBitstream1.
Lz77ShiftBitstream0:
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

; Shift the compressed input bit stream by one bit.
; Depending on the call stack you either call Lz77ShiftBitstream0 or Lz77ShiftBitstream1.
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

SECTION "bank2", ROMX, BANK[2]

; Start address of ASCII string in hl.
; Address of window tile map in de.
DrawString:
  ldi a, [hl]      ; Load ASCII character into a.
  or a
  ret Z            ; Return at end of string.
  cp $0d
  jr Z, .LineBreak ; Check for carriage return.
  bit 7, a
  jr nZ, .Label1   ; Check for extended ASCII.
  sub $20          ; Normalize.
  jr Z, .Label1
  sub $10
  cp $0a
  jr C, .Label1
  sub $07
  add $ce
.Label1:
  ld [de], a
  inc e
  jr DrawString
.LineBreak:
  ld a, e
  and $e0         ; Round down to next multiple of 32 (a line has 32 tiles).
  add $20         ; Add 32. So, ultimately we rounded up to the next multiple of 32.
  ld e, a
  jr nC, DrawString
  inc d
  jr DrawString

SECTION "bank7", ROMX, BANK[7]

LoadSound0:
  jp LoadSound1

LoadSound1:
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
