INCLUDE "hardware.inc"
INCLUDE "constants.asm"
INCLUDE "data.asm"

SECTION "rst0", ROM0[$0000]
; a = ROM bank index
LoadRomBank:
  ld [rROMB0], a
  ret
  nop
  nop
  nop
  nop

SECTION "rst8", ROM0[$0008]
sym.rst_8;
  push hl
  ld b, 0
  add hl, bc
  ld a, [hl]
  pop hl
  ret
  nop

SECTION "rst10", ROM0[$0010]
sym.rst_10:
  push hl
  ld b, 0
  add hl, bc
  ld [hl], a
  pop hl
  ret
  nop

SECTION "rst18", ROM0[$0018]
sym.rst_18:
  push hl
  ld b, 0
  add hl, bc
  inc [hl]
  pop hl
  ret
  nop

SECTION "rst20", ROM0[$0020]
sym.rst_20:
  push hl
  ld b, 0
  add hl, bc
  dec [hl]
  pop hl
  ret
  db $ff

SECTION "rst28", ROM0[$0028]
sym.rst_28:
  push hl
  ld b, 0
  add hl, bc
  cp [hl]
  pop hl
  ret
  db $ff

SECTION "rst30", ROM0[$0030]
sym.rst_30:
  push hl
  ld b, 0
fcn.00000033:
  add hl, bc
  add [hl]
  pop hl
  ret
  db $ff

SECTION "rst38", ROM0[$0038]
sym.rst_38:
  ld a, c
  or a
fcn.0000003a:
  jr Z, MemsetValue
  inc b
  jr MemsetValue
  ld a, a

SECTION "InterruptVblank", ROM0[$0040]
InterruptVblank:
  db $c3,$41,$05,$00
  nop
  nop
  nop
  nop

SECTION "InterruptLCDC", ROM0[$0048]
InterruptLCDC:
  jp $693
  nop
  nop
  nop
  nop
  nop

SECTION "InterruptTimer", ROM0[$0050]
Interrupt_Timer:
  jp $752
  nop
  nop
  nop
  nop
  nop

SECTION "InterruptSerial", ROM0[$0058]
InterruptSerial:
  reti
  nop
  nop
  nop
  nop
  nop
  nop
  nop

SECTION "InterruptJoypad", ROM0[$0060]
InterruptJoypad:
  reti

SECTION "ROM0", ROM0[$0061]
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
  ld hl, OamTransfer
: ldi a, [hl]
  ld [$ff00 + c], a
  inc c
  dec b
  jr nZ, :-
  ret

; 0x79: Copies data from 0xc000 (RAM) to OAM.
; This function is also copied into the high RAM.
OamTransfer:
  ld a, $c0      ; Start address 0xc000.
  ldh [rDMA], a
  ld a, 40
: dec a         ; Need to wait 40 cycles for DMA to finish.
  jr nZ, :-
  ret

; 0x83: Transfers a value given in [hl], to [de] with a length of bc. Works downwards!
MemsetValue:
  ldi a, [hl]
  ld [de], a
  inc de
  dec c
  jr nZ, MemsetValue
  dec b
  jr nZ, MemsetValue
  ret

; 0x8d: Sets lower window tile map to zero.
ResetWndwTileMapLow:
  ld bc, $400
  jr ResetWndwTileMapSize

; 0x92: Sets lower and upper window tile map to zero.
ResetWndwTileMap:
   ld bc, WNDW_TILE_MAP_SIZE
ResetWndwTileMapSize:
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
; Also "c" has new buttons.
ReadJoyPad:
    ld a, $20
    ldh [rP1], a     ; Select direction keys.
    ldh a, [rP1]     ; Wait.
    ldh a, [rP1]     ; Read keys.
    cpl             ; Invert, so button press becomes 1.
    and $0f         ; Select lower 4 bits.
    swap a
    ld b, a         ; Direction key buttons now in upper nibble of b.
    ld a, $10
    ldh [rP1], a     ; Select button keys.
    ldh a, [rP1]     ; Wait.
    ldh a, [rP1]     ; Wait.
    ldh a, [rP1]     ; Wait.
    ldh a, [rP1]     ; Wait.
    ldh a, [rP1]     ; Wait.
    ldh a, [rP1]     ; Read keys.
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
    ldh [rP1], a    ; Disable selection.
    ret

fcn.00e6:
  set 1, [hl]
  ld c, $12
  rst sym.rst_8
  cp $54
  ret nZ
  xor a
  ld c, 1
  rst sym.rst_10
  ret

db $ff,$ff,$ff,$7e,$f3,$ff,$ff,$af,$ff,$ff,$ff,$cf,$df

; 0x100
SECTION "Header", ROM0[$100]
Entry:
  nop
	jp Main
	ds $150 - @, 0 ; Make room for the header. rgbfix will set it.

SECTION "MainContinued", ROM0[$150]
; 0x150: Main continues here.
MainContinued:
  call StopDisplay
  call ResetWndwTileMap
  call ResetRam
  ld a, 7
  rst 0
  call LoadSound0
  call SetUpScreen
  ld a, 2
  rst $00
  call LoadFontIntoVram
  ld hl, NintendoLicenseString
  ld de, $9900                ; Window tile map
  call DrawString;            ; Draws "LICENSED BY NINTENDO"
  ld a, $e4
  ldh [rBGP], a
  ld a, $1c
  ldh [rOBP0], a
  ld a, $00
  ldh [rOBP1], a
  call SetUpInterruptsSimple  ; Enables VBLANK interrupt
: call fcn.000014aa           ; TODO: Probably something with sound
  ld a, [$c103]
  or a
  jr nZ, :-                   ; Loop until $c103 is non-zero.
  call StartTimer
  ld a, $03
  rst 0                       ; Load ROM bank 3.
  ; call fcn.0002407c
  ; ld a, 2
  ; rst 0                    ; Load ROM bank 2
  ; ld hl, PresentsString    ; "PRESENTS"
  ; ld de, 0x9a06
  ; call DrawString
  ; call SetUpInterruptsSimple
  ;:call fcn.000014aa
  ; ld a, [0xc103]
  ; or a
  ; jr nZ, :-
  ; call StartTimer
  ; call ResetWndwTileMap
  ; ld a, 3
  ; rst 0                   ; Load ROM bank 3
  ; ld hl,CompressedJungleBookLogoTileMap
  ; call fcn.0002408f
  ; ld hl, CompressedJungleBookLogoData
  ; call fcn.00024094
  ; ld a, $02
  ; rst sym.rst_0           ; Load ROM bank 2
  ; ld hl, MenuString
  ; ld de, $98e2
  ; call DrawString
  ; call SetUpInterruptsSimple
  ; call fcn.000014aa

  ; .Label1:
  ; ld a, [JoyPadNewPresses]
  ; push af
  ; bit 2, a
  ; jr Z, .SkipMode
  ; bit 2, a
  ; jr Z, .SkipMode
  ; ld a, [DifficultyMode]
  ; inc a
  ; and 1                  ; Mod 2
  ; ld [DifficultyMode], a ; Toggle practice and normal mode.
  ; ld hl, $767e           ; Load "NORMAL" string.
  ; jr Z, :+
  ; ld l, $87              ; Load "PRACTICE" string.
  ; : ld de, $9a2a
  ; call DrawString
  ; .SkipMode:
  ; pop af
  ; and $0b
  ; jr Z, $d6
  ; call StartTimer
  ; ld a, 7                ; Load ROM bank 7
  ; rst sym.rst_0
  ; call fcn.0000685f
  ; call ResetWndwTileMapLow
  ; ld a,$e4
  ; ld [rBGP], a


.spin:
  jp .spin

SECTION "TODO00", ROM0[$14aa]
fcn.000014aa:
  ld a, [$7fff]
  push af             ; Save ROM bank
  ld a, 7
  rst 0               ; Load ROM bank 7
  call fcn.00064003   ; TODO: Continue here
  pop af              ; Restore old ROM bank
  rst 0
  call ReadJoyPad

; Waits for interrupt. Reads [$c102], waits for it to turn non-zero, and then continues.
; TODO: find out what $c102 is used for.
fcn.000014b9:
: halt
  ld a, [$c102]
  and a
  jr Z, :-
  xor a
  ld [$c102], a
  ret

; 0x14c5: Generates timer interrupt ~62.06 times per second.
StartTimer:
  ldh a, [rLCDC]
  and $80
  ret Z              ; Return if display is turned of.
  call StopDisplay
  xor a
  ldh [rIF], a       ; Interrupt flags to zero.
  ld a, $04
  ldh [rIE], a       ; Enable timer interrupt.
  ld a, $ff
  ldh [rTIMA], a     ; Timer counter to 255. Will overflow with the next increase.
  ld a, $be
  ldh [rTMA], a      ; Timer modulo to 190. Overflow every 66 increases.
  ld a, $04
  ldh [rTAC], a      ; Start timer with 4096kHz.
  ei
  ret

; 0x14e2: Waits for rLY 128 and then stops display operation
StopDisplay:
  di
  ldh a, [rIE]
  ld c, a
  res 0, a
  ldh [rIE], a
: ldh a, [rLY]
  cp $91
  jr nZ, :-
  ldh a, [rLCDC]
  and $7f
  ldh [rLCDC], a
  ld a, c
  ldh [rIE], a
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
  ldh [rIF], a       ; Reset interrupt flags.
  pop af
  ldh [rIE], a       ; Enable given interrupts.
  ld a, %10000111   ; BG on. Sprites on. Large sprites. Tile map low. Tile data high. WNDW off. LCDC on.
  ldh [rLCDC], a
  ld a, b
  ldh [rSTAT], a
  ld a, c
  ldh [rLYC], a
  xor a
  ldh [rTAC], a      ; Stop timer.
  ei
  ret

SECTION "LZ77Decompression", ROM0[$3eec]

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

SECTION "TODO02", ROMX[$7529], BANK[2]
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

fcn.00064003:
  call fcn.000663d4
  ld a, [$c506]
  and a
  jr Z, .Label7
  ld a, [$c5be]
  cp $01
  jr nZ, .Label6
.Label8:
  ld hl, $c500
  ld a, [hl]
  and $3f
  set 7, [hl]
  jp .Label1
.Label7:
  ld a, [$c500]
  bit 7, a
  jr nZ, .Label6
  bit 6, a
  jr Z, .Label8
  ld a, [$c504]
  and $07
  jr Z, .Label8
  ld a, [$c502]
  ld [$c506], a
.Label6:
  ld a, [$c5c0]
  dec a
  ld [$c5c0], a
  call fcn.0006414b
  ld b, c
  call fcn.00064418
  call fcn.000646db
  call fcn.00064a06
  call fcn.00064c31
  ld a, [$c5c0]
  or a
  jr nZ, .Label5
  ld a, $09
.Label5:
  ld [$c5c0], a
  ld a, [$c506]
  or a
  ret Z
  dec a
  jr Z, .Label4
  ld [$c506], a
  ret
.Label4:
  ld a, [$c5be]    ; Load sound volume setting
  dec a            ; Decrease it
  cp 1
  jr Z, .Label3    ; Done if we reached setting 1
  ld [$c5be], a    ; Save old setting (although this is redundant)
  call SetVolume
  jr .Label2
.Label3:
  xor a
  ld [$c504], a
  ld [$c506], a
  ret
.Label2:
  ld a, [$c502]
  ld [$c506], a
  ret
.Label1:
  ld hl, $c503
  bit 7, [hl]
  ret Z
  ld [$c505], a
  ld b, $00
  ld c, a
  sla c

; 0x64118:
LoadSound1:
  ld a, $00
  ldh [rAUDENA], a
  ld a, $ff
  ld [$c500], a
  push bc
  inc a          ; a = 0
  ld [$c504], a
  ld [$c506], a
  ld [$c5be], a  ; Sound volume setting = 0
  ld [$c5a6], a
  ld a, $ff
  ld [$c5c3], a
  ld [$c501], a
  inc a
  ld [$c5c5], a
  ld [$c5cb], a
  ld [$c5c4], a
  ld a, $8f
  ldh [rAUDENA], a
  ld a, $ff
  ldh [rAUDVOL], a
  ldh [rAUDTERM], a
  ret

; TODO
fcn.0006414b:
  ret

; TODO
fcn.00064418
  ret

; TODO
fcn.000646db:
  ret

; TODO
fcn.00064a06:

; TODO
fcn.00064c31:
  ret

; $64dee
; Loads a sound volume setting (see VolumeSettings) from $4e00 + "a"
; Saves old "a" to $c5be. There are 8 volume settings in total.
SetVolume:
  ld [$c5be], a
  ld de, $4e00     ; TODO: Is this only bank 7?
  add e
  ld e, a
  ld a, [de]
  ldh [rAUDVOL], a ; [rAUDVOL] = $4e00 + a
  ret

; $64dfa: I guess this is just non-occupied space.
TODO100:
  db $00,$00,$00,$00,$00,$00

; $64e00: Volume settings from quiet ($88 = no volume at all) to loud.
VolumeSettings:
  db $88,$99,$aa,$bb,$cc,$dd,$ee,$ff

SECTION "TODO01", ROMX[$6833], BANK[7]
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

; [$c5cb] = data0[N+1]
; [$c5c7] = data1[N+1]
; [$c5c6] = data1[N]
; [$c5c5] = 0
; [$c5c4] = data0[N]
; [$c5c3] = ?
; [$c504] = read
; [$c503] = read
; offset = mod64(a) * 2
fcn.0006637a:
  ld hl, $c503
  bit 6, [hl]
  ret Z           ; Return if bit 6 in [$c503] was set
  ld e, a
  ld a, [$c506]
  and a
  ret nZ          ; Return if [$c506] is non-zero.
  ld a, e
  and $3f         ; a = mod64(a).
  ld b, 0
  sla a           ; a = a * 2
  ld c, a         ; bc = a * 2
  ld hl, $67cf    ; Get some base address.
  add hl, bc      ; Add some length.
  ld a, [$c5c4]
  cp [hl]
  jr C, :+        ; Jump if [data_ptr] value exceeds [$c5c4]
  ret nZ          ; Return if [data_ptr] == [$c5c4]
  bit 6, e
  ret nZ          ; Return if bit 6 is non zero
: ldi a, [hl]     ; Get data, data_ptr++
  ld [$c5c4], a   ; [$c5c4] = data0[N]
  ld a, [hl]
  ld [$c5cb], a   ; [$c5c4] = data0[N+1]
  ld hl, $67a3    ; Get some base address.
  add hl, bc      ; Add same length.
  ldi a, [hl]     ; Get data, data_ptr++
  ld [$c5c6], a   ; [$c5c6] = data1[N]
  ld a, [hl]
  ld [$c5c7], a   ; [$c5c7] = data1[N+1]
  ld a, e
  and $3f         ; Mod 64.
  ld [$c5c3], a   ; [$c5c3] = ?
  ld a, [$c504]
  and $1f         ; Mod 32.
  ld a, 0
  ld [$c5c5], a   ; [$c5c5] = 0
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
