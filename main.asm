INCLUDE "hardware.inc"
INCLUDE "constants.asm"
INCLUDE "data2.asm"

DEF LICENSE_STRING EQU $75d3 ; bank 02

SECTION "bank0", ROM0[$0]

; 0x00: a = ROM bank index
LoadRomBank:
  ld [rROMB0], a
  ret
  nop
  nop
  nop
  nop

; 0x61
Main:
  di
  ld sp, $fffe
  call Transfer
  jp MainContinued

; 0x6b: Transfers 10 bytes from $79 into the high RAM.
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

; 0x92: Sets lower and upper window tile map to zero.
ResetWndwTileMapLow:
   ld bc, WNDW_TILE_MAP_SIZE
   ld hl, WNDW_TILE_MAP_LOW
   jr MemsetZero

; 0x9a:
ResetRam:
  ld bc, $a0
  ld hl, _RAM
  call MemsetZero
  ld hl, _RAM
  ld bc, $1ff8

; 0xa9: hl = start address, bc = length
MemsetZero:
  ld [hl], $00
  inc hl
  dec bc
  ld a, b
  or c
  jr nZ, MemsetZero
  ret

; 0xb2: Read joy pad and save result on 0xc100 and 0xc101.
ReadJoyPad;
    ld a, $20
    ld [rP1], a     ; Select direction keys.
    ld a, [rP1]     ; Wait.
    ld a, [rP1]     ; Read keys.
    cpl             ; Invert, so button press becomes 1.
    and $0f         ; Select lower 4 bits.
    swap a
    ld b, a         ; Direction key buttons now in upper nibble of b.
    ld a, $10
    ld [rP1], a     ; Select button keys.
    ld a, [rP1]     ; Wait.
    ld a, [rP1]     ; Wait.
    ld a, [rP1]     ; Wait.
    ld a, [rP1]     ; Wait.
    ld a, [rP1]     ; Wait.
    ld a, [rP1]     ; Read keys.
    cpl             ; Same procedure as before...
    and $0f
    or b            ; Button keys now in lower nibble of a.
    ld c, a
    ld a, [$c100]   ; Read old joy pad data.
    xor c           ; Get changes from old to new.
    and c           ; Only keep new buttons pressed.
    ld [$c101], a   ; Save new joy pad data.
    ld a, c
    ld [$c100], a   ; Save newl pressed buttons.
    ld a, $30
    ld [rP1], a     ; Disable selection.
    ret

; 0x150: Main continues here.
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
  ld de, $9900                ; Window tile map
  call DrawString;            ; Draws "LICENSED BY NINTENDO"
  ld a, $e4
  ld [rBGP], a
  ld a, $1c
  ld [rOBP0], a
  ld a, $00
  ld [rOBP1], a
  call SetUpInterruptsSimple  ; Enables VBLANK interrupt
: call fcn.000014aa
  ld a, [$c103]
  or a
  jr nZ, :-
  ; TODO: Continue here
.spin:
  jp .spin

SECTION "Header", ROM0[$100]
	jp Main
	ds $150 - @, 0 ; Make room for the header

fcn.000014aa:
  ld a, [$7fff]
  push af
  ld a, 7
  rst sym.rst_0       ; Load ROM bank 7
  call fcn.00064003   ; TODO: Continue here
  pop af
  rst sym.rst_0
  call ReadJoyPad

fcn.000014b9:         ; TODO: Continue here
  halt
  ld a, [$c102]
  and a
  jr Z, $f9
  xor a
  ld [$c102], a
  ret

; 0x14e2: Waits for rLY 128 and then stops display operation
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

; 0x14fa:
SetUpInterruptsSimple:
  ld a, IEF_VBLANK              ; Enable VBLANK interrupt.
  ld b, 0                       ; rSTAT = 0.
  ld c, b                       ; rLYC = 0.
  jr SetUpInterrupts

; 0x1501:
SetUpInterruptsAdvanced:
  ld c, $77                     ; rLYC = 119.
  ld a, IEF_STAT | IEF_VBLANK   ; Enable VBLANK and STAT interrupt.
  ld b, $40                     ; rSTAT = $40.

; 0x1507: a = rIE, b = rSTAT, c = rLYC
SetUpInterrupts:
  push af
  xor a
  ld [rIF], a       ; Reset interrupt flags.
  pop af
  ld [rIE], a       ; Enable given interrupts.
  ld a, %10000111   ; BG on. Sprites on. Large sprites. Tile map low. Tile data high. WNDW off. LCDC on.
  ld [rLCDC], a
  ld a, b
  ld [rSTAT], a
  ld a, c
  ld [rLYC], a
  xor a
  ld [rTAC], a      ; Stop timer.
  ei
  ret

  ; 0x3eec:
LoadFontIntoVram:
  ld hl, CompressedFontData
  ld de, $8ce0

; 0x3ef2: Implements an LZ77 decompression.
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

; 0x3f85: Gets one LZ77 item and stores it in bc. This can either be symbol length, offset, or length.
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

; 0x3fc9: Shift the compressed input bit stream by one bit.
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

; 0x3fdf: Shift the compressed input bit stream by one bit.
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

; 0x17529:  Start address of ASCII string in hl. Address of window tile map in de.
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

; 0x64000:
LoadSound0:
  jp LoadSound1

; 0x64118:
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

; 0x66833:
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

fcn.00064e67;
  ld de, $5147
  ld a, b
  add e
  ld e, a
  jr nC, :+
  inc d
: ld a, [de]
  add c
  ld c, a
  ldi a, [hl]
  inc [hl]
  xor [hl]
  ret nZ
  ldi [hl], a
  inc b
  ld a, b
  cp [hl]
  inc hl
  jr nZ, :+
  ld b, [hl]
: inc hl
  ld [hl], b
  ret

fcn.0006637a:
  ld hl, $c503
  bit 6, [hl]
  ret Z
  ld e, a
  ld a, [$c506]
  and a
  ret nZ
  ld a, e
  and $3f
  ld b, $00
  sla a
  ld c, a
  ld hl, $67cf
  add hl, bc
  ld a, [$c5c4]
  cp [hl]
  jr C, :+
  ret nZ
  bit 6, e
  ret nZ
: ldi a, [hl]
  ld [$c5c4], a
  ld a, [hl]
  ld [$c5cb], a
  ld hl, $67a3
  add hl, bc
  ldi a, [hl]
  ld [$c5c6], a
  ld a, [hl]
  ld [$c5c7], a
  ld a, e
  and $3f
  ld [$c5c3], a
  ld a, [$c504]
  and $1f
  ld a, $00
  ld [$c5c5], a
  ret
  ld a, $ff
  ld [$c5c3], a
  ld [$c501], a
  inc a
  ld [$c5c5], a
  ld [$c5cb], a
  ld [$c5c4], a
  ret

fcn.000663d4:
  ld a, [$c501]
  bit 7, a
  call Z, fcn.0006637a
  ld a, $ff
  ld [$c501], a
  ld a, [$c5c3]
  cp $ff
  ret Z
  ld a, [$c5c5]
  and a
  jr Z, :+
  dec a
  ld [$c5c5], a
  ret
: ld a, [$c5c6]
  ld l, a
  ld a, [$c5c7]
  ld h, a
.Label4:
  ldi a, [hl]
  and a
  jr nZ, :+
  ld a, $ff
  ld [$c5c3], a
  xor a
  ld [$c5c4], a
  ret
: bit 7, a
  jr Z, .Label2
  bit 5, a
  jr Z, .Label1
  and $1f
  jr Z, .Label3
  ld [$c5c8], a
  ld a, l
  ld [$c5c9], a
  ld a, h
  ld [$c5ca], a
  jr .Label4
.Label3:
  ld a, [$c5c8]
  and a
  jr Z, .Label4
  dec a
  ld [$c5c8], a
  ld a, [$c5c9]
  ld l, a
  ld a, [$c5ca]
  ld h, a
  jr .Label4
.Label2:
  ld c, a
  ldi a, [hl]
  ld [$ff00 + c], a
  jr .Label4
.Label1:
  ldi a, [hl]
  ld [$c5c5], a
  ld a, l
  ld [$c5c6], a
  ld a, h
  ld [$c5c7], a
  ret
