INCLUDE "hardware.inc"
INCLUDE "constants.asm"
INCLUDE "data.asm"

def JoyPadData EQU $c100 ; From MSB to LSB (1=pressed): down, up, left, right, start, select, B, A.
def JoyPadNewPresses EQU $c101
def TimeCounter EQU  $c103 ; 8-bit time register. Increments ~60 times per second.
; WARNING $c106 is also used differently in other contexts.
def WindowScrollYLsb EQU $c106 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollYMsb EQU $c107 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollXLsb EQU $c108 ; Window scroll in x direction. Increases from left to right.
def WindowScrollXMsb EQU $c109 ; Window scroll in x direction. Increases from left to right.
def BgScrollXLsb EQU $c125 ; Window scroll in x direction. Increases from left to right.
def BgScrollXMsb EQU $c126 ; Window scroll in x direction. Increases from left to right.
def BgScrollYLsb EQU $c136 ; Window scroll in y direction. Increases from top to bottom.
def BgScrollYMsb EQU $c137 ; Window scroll in y direction. Increases from top to bottom.

def NextLevel2 EQU $c10f ; Next level.
def PlayerPositionXLsb EQU $c13f ; Player's global x position on the map. LSB.
def PlayerPositionXMsb EQU $c140 ; Player's global x position on the map. MSB.
def PlayerPositionYLsb EQU $c141 ; Player's global y position on the map. LSB.
def PlayerPositionYMsb EQU $c142 ; Player's global y position on the map. MSB.

def CurrentLevel EQU $c110  ; Between 0-9.
def NextLevel EQU $c10e ; Can be $ff in the start menu.
def DifficultyMode EQU $c111 ; 0 = NORMAL, 1 =  PRACTICE
def CheckpointReached EQU $c112 ; 0 = no checkpoint, 8 = checkpoint

def WeaponSelect EQU $c183 ; 0 = banana, 1 = double banana, 2 = boomerang, 3 = stones, 4 = mask
def AmmoBase EQU $c184 ; Base address of the following array.
def CurrentNumDoubleBanana EQU $c185 ; Current number of super bananas you have. Each nibble represents one decimal digit.
def CurrentNumBoomerang EQU $c186 ; Current number of boomerangs you have. Each nibble represents one decimal digit.
def CurrentNumStones EQU $c187 ; Current number of stones you have. Each nibble represents one decimal digit.
def CurrentSecondsInvincibility EQU $c188 ; Current seconds of invincibility you have left. Each nibble represents one decimal digit.
def InvincibilityTimer EQU $c189 ; Decrements ~15 times per second.

def CurrentLives EQU $c1b7; Current number of lives.
def NumDiamondsMissing EQU $c1be ; Current number of diamonds you still need to complete the level.
def CurrentHealth EQU $c1b8 ; Current health.
def CurrentScore1 EQU $c1bb ; Leftmost two digits of the current score.
def CurrentScore2 EQU $c1bc ; Nex two digits of the current score.
def CurrentScore3 EQU $c1bd ; Righmost two digits of the current score.
def MaxDiamondsNeeded EQU $c1bf ; Maximum number of diamonds you still need. 7 in practice. 10 in normal.
def FirstDigitSeconds EQU $c1c3 ; First digit of remaining seconds.
def SecondDigitSeconds EQU $c1c4 ; Second digit of remaining seconds.
def DigitMinutes EQU $c1c5 ; Digit of remaining minutes.
def IsPaused EQU $c1c6 ; True if the game is paused.
def ColorToggle EQU $c1c7 ; Color toggle used for pause effect.
def PauseTimer EQU $c1c8 ; Timer that increases when game is paused. Used to toggle ColorToggle.
def CurrentSong2 EQU $c1cb ; TODO: There seem to be 11 songs.
def NumContinuesLeft EQU $c1fc ; Number of continues left.
def CanContinue EQU $c1fd ; Seems pretty much like NumContinuesLeft. If it reaches zero, the game starts over.
def ContinueSeconds EQU $c1fe ; Seconds left during "CONTINUE?" screen.
def CurrentSong EQU $c500 ; TODO: Still not sure. $c4 = fade out. $07 died sound.
def CurrentSoundVolume EQU $c5be ; There are 8 different sound volumes (0 = sound off, 7 = loud)

def OldRomBank EQU $7fff

def MAX_HEALTH EQU 52 ; Starting health.
def MINUTES_PER_LEVEL EQU 5 ; Number of minutes per level.
def NUM_CONTINUES_NORMAL EQU 4 ; Number of continues for the normal mode.
def NUM_CONTINUES_PRACTICE EQU 6 ; Number of continues for the practice mode.
def NUM_DIAMONDS_NORMAL EQU $10  ; Number of diamonds needed in normal mode. Note that each nibble represents one decimal digit.
def NUM_DIAMONDS_PRACTICE EQU 7 ; Number of diamonds needed in practice mode.
def NUM_LIVES EQU 6 ; Number of lives.
def NUM_BANANAS EQU $99 ; Number of bananas.

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
fcn00000033:
  add hl, bc
  add [hl]
  pop hl
  ret
  db $ff

SECTION "rst38", ROM0[$0038]
; $0038: Copies values given in [hl], to [de] with a length of bc.
; If c is 0, b is incremented by one before copying.
sym.rst_38:
  ld a, c
  or a
fcn0000003a:
  jr Z, CopyData
  inc b
  jr CopyData
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
; $61
Main:
  di
  ld sp, $fffe
  call Transfer
  jp MainContinued

; $6b: Transfers 10 bytes from $79 into the high RAM.
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

; $79: Copies data from $c000 (RAM) to OAM.
; This function is also copied into the high RAM.
OamTransfer:
  ld a, $c0      ; Start address $c000.
  ldh [rDMA], a
  ld a, 40
: dec a         ; Need to wait 40 cycles for DMA to finish.
  jr nZ, :-
  ret

; $83: Copies values given in [hl], to [de] with a length of bc.
CopyData:
  ldi a, [hl]
  ld [de], a
  inc de
  dec c
  jr nZ, CopyData
  dec b
  jr nZ, CopyData
  ret

; $8d: Sets lower window tile map to zero.
ResetWndwTileMapLow:
  ld bc, $400
  jr ResetWndwTileMapSize

; $92: Sets lower and upper window tile map to zero.
ResetWndwTileMap:
   ld bc, WNDW_TILE_MAP_SIZE
ResetWndwTileMapSize:
   ld hl, WNDW_TILE_MAP_LOW
   jr MemsetZero

; $9a:
ResetRam:
  ld bc, $a0
  ld hl, _RAM
  call MemsetZero
  ld hl, _RAM
  ld bc, $1ff8

; $a9: hl = start address, bc = length
MemsetZero:
  ld [hl], $00
  inc hl
  dec bc
  ld a, b
  or c
  jr nZ, MemsetZero
  ret

; $b2: Read joy pad and save result on $c100 and $c101.
; From MSB to LSB: down, up, left, right, start, select, B, A.
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
    ld a, [JoyPadData]        ; Read old joy pad data.
    xor c                     ; Get changes from old to new.
    and c                     ; Only keep new buttons pressed.
    ld [JoyPadNewPresses], a  ; Save new joy pad data.
    ld a, c
    ld [JoyPadData], a        ; Save newl pressed buttons.
    ld a, $30
    ldh [rP1], a              ; Disable selection.
    ret

fcn00e6:
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

; $100
SECTION "Header", ROM0[$100]
Entry:
  nop
	jp Main
	ds $150 - @, 0 ; Make room for the header. rgbfix will set it.

SECTION "MainContinued", ROM0[$150]
; $150: Main continues here.
MainContinued:
  call StopDisplay
  call ResetWndwTileMap
  call ResetRam
  ld a, 7
  rst 0                       ; Load ROM bank 7.
  call LoadSound0
  call SetUpScreen
  ld a, 2
  rst 0                       ; Load ROM bank 2.
  call LoadFontIntoVram
  ld hl, NintendoLicenseString
  ld de, $9900                ; Window tile map
  call DrawString;            ; Draws "LICENSED BY NINTENDO"
  ld a, %11100100
  ldh [rBGP], a               ; Classic BG and window palette.
  ld a, %00011100
  ldh [rOBP0], a
  ld a, $00
  ldh [rOBP1], a
  call SetUpInterruptsSimple  ; Enables VBLANK interrupt
: call fcn000014aa            ; TODO: Probably something with sound
  ld a, [TimeCounter]
  or a
  jr nZ, :-                   ; Wait for a few seconds...
.VirginStartScreen:           ; $0189
  call StartTimer
  ld a, 3
  rst 0                       ; Load ROM bank 3.
  call LoadVirginLogoData     ; Loads the big Virgin logo.
  ld a, 2
  rst 0                       ; Load ROM bank 2
  ld hl, PresentsString       ; "PRESENTS"
  ld de, $9a06
  call DrawString
  call SetUpInterruptsSimple
: call fcn000014aa            ; TODO: Probably something with sound
  ld a, [TimeCounter]
  or a
  jr nZ, :-                   ; Wait for a few seconds...
  call StartTimer
  call ResetWndwTileMap
  ld a, 3
  rst 0                       ; Load ROM bank 3
  ld hl,CompressedJungleBookLogoTileMap
  call DecompressInto9800
  ld hl, CompressedJungleBookLogoData
  call DecompressInto9000     ; "The Jungle Book" logo has been loaded at this point.
  ld a, 2
  rst 0                       ; Load ROM bank 2
  ld hl, MenuString
  ld de, $98e2
  call DrawString             ; Prints "(C)1994 THE WAL..."
  call SetUpInterruptsSimple
.StartScreen:                 ; $01ce
  call fcn000014aa            ; TODO: Probably something with sound
  ld a, [JoyPadNewPresses]    ; Get new joy pad presses to see if new mode is selected of if we shall start the level.
  push af
  bit 2, a
  jr Z, .SkipMode
  bit 2, a
  jr Z, .SkipMode
  ld a, [DifficultyMode]
  inc a
  and 1                       ; Mod 2
  ld [DifficultyMode], a      ; Toggle practice and normal mode.
  ld hl, $767e                ; Load "NORMAL" string.
  jr Z, :+
  ld l, $87                   ; Load "PRACTICE" string.
: ld de, $9a2a
  call DrawString
.SkipMode:                    ; $1f3
  pop af
  and $0b
  jr Z, .StartScreen          ; Start level if A, B, or START was pressed.
.StartGame:                   ; $01f8
  call StartTimer
  ld a, 7
  rst 0                       ; Load ROM bank 7
  call FadeOutSong            ; Sets up CurrentSong2 and CurrentSong
  call ResetWndwTileMapLow
  ld a, %00011100             ; Classic BG and window palette.
  ldh [rBGP], a
  ld a, 2
  rst 0                       ; Load ROM bank 2
  call LoadFontIntoVram
  ld hl, LevelString
  ld de, $98e6
  call DrawString             ; "LEVEL"
  ld a, [NextLevel2]
  ld c, a
  ld a, [CurrentLevel]
  cp c
  jr nZ, .Label10
  cp $09
  jr C, :+                    ; Reached level 10?
  ld a, $cf
  ld [de], a
  inc de
  ld a, $ff
: add $cf
  ld [de], a                  ; Draw level number.
  inc de
  ld a, ":"
  ld [de], a                  ; Draw ":"
  ld b, 0
  sla c                       ; a = a * 2 because level string pointers are two bytes in size.
  ld hl, LevelStringPointers
  add hl, bc                  ; Add offset of corresponding level.
  ldi a, [hl]
  ld h, [hl]
  ld l, a                     ; Now we have the correct pointer to the level name.
  ld de, $9923
  call DrawString             ; Print level name.
  ld hl, GetReadyString       ; "GET READY"
  ld de, $9965
  jr .Label11
.Label10
  ld a, [NextLevel]
  ld [NextLevel2], a
  cp $0a
  jr C, :+
  ld a, $cf
  ld [de], a
  inc de
  xor a
: add $ce
  ld [de], a
  ld de, $9925                ; TODO: Draw what number?
.Label11:
  call DrawString
  ld a, 1
  rst 0                       ; Load ROM bank 1
  xor a
  ldh [rSCX], a
  ldh [rSCY], a               ; BG screen = (0,0).
  dec a                       ; PC: $26b
  ld [NextLevel], a
  ld a, $80
  ld [TimeCounter], a
  ld a, [CurrentLevel]
  cp $0b
  jr nZ, :+
  ld a, [MaxDiamondsNeeded]
  ld [NumDiamondsMissing], a
  call UpdateDiamondNumber
: call SetUpInterruptsSimple
: call fcn000014aa
  ld a, [TimeCounter]
  or a
  jr nZ, :-                   ; Wait for a few seconds...
.Label290:
  call StartTimer
  call ResetWndwTileMapLow
  ld a, [CurrentLevel]
  inc a
  ld [NextLevel], a
  ld hl, AssetSprites         ; Load sprites of projectiles, diamonds, etc.
  ld de, $8900
  ld bc, $03e0
  cp $0c                      ; PC : $2a6
  jr nZ, :+
  call fcn00002578
  ld hl, TODOSprites
  ld de, $8a20
  ld bc, $00a0
: push af
  ld a, 5
  rst 0                       ; Load ROM bank 5.
  rst $38                     ; Copies sprites into VRAM.
  pop af
  jr Z, :+
  push af
  ld a, 1
  rst 0                       ; Load ROM bank 1
  call fcn00002394
  pop af
  call fcn0000242a
  ld a, 2
  rst 0                       ; Load ROM bank 2
  call InitStatusWindow
: ld a, 2
  rst 0                       ; Load ROM bank 2
  call LoadStatusWindowTiles
  ld a, 5
  rst 0                       ; Load ROM bank 5
  call fcn00002329
  ld a, 6
  rst 0                       ; Load ROM bank 6
  ld a, [NextLevel]
  dec a
  add a
  ld b, 0
  ld c, a
  ld hl, $401d
  add hl, bc
  ldi a, [hl]
  ld h, [hl]
  ld l, a
  push bc
  call fcn00054000
  pop bc
  ld a, 4
  rst 0                       ; Load ROM bank 4
  call fcn00034000
  ld a, 3
  rst 0                       ; Load ROM bank 3
  call fcn00024000
  ld a, [NextLevel]
  cp $0c
  jr nZ, :+
  ld a, 2
  rst 0                       ; Load ROM bank 2.
  ld hl, CompressedTODOData
  ld de, $96e0
  call DecompressTilesIntoVram
: ld a, 1
  rst 0                       ; Load ROM bank 1.
  ld hl, BgScrollXLsb
  ld e, [hl]
  inc hl
  ld d, [hl]
  call fcn00001214
  ld hl, BgScrollYLsb
  ld e, [hl]
  inc hl
  ld d, [hl]
  call fcn00001440
  call fcn0000147f
  ld hl, $cf00
  add hl, de
  push hl
  call fcn00004019
  pop hl
  call fcn00004000
  call fcn0000408e
  call fcn00005882
  ld a, 3
  rst 0                       ; Load ROM bank 3.
  call fcn0000227e
  ld a, 1
  rst 0                       ; Load ROM bank 1
  call fcn000025a6
  xor a
  ld [$c172], a
  ld [$c174], a
  ld [$c173], a
  ld [$c175], a
  ld [InvincibilityTimer], a
  ld [$c16f], a
  ld [$c170], a
  ld [$c181], a
  ld [$c182], a
  ld [WeaponSelect], a        ; = 0 (banana)
  ld [$c15b], a
  ld [$c1cd], a
  ld [$c1ce], a
  ld [$c1cf], a
  ld [$c18d], a
  ld [$c1f1], a
  ld [$c1f3], a
  ld [$c1f0], a
  ld [$c1ea], a
  ld [$c1eb], a               ; = 0
  dec a
  ld [$c149], a
  ld [$c190], a
  ld [$c15c], a               ; = $ff
  ld a, MAX_HEALTH
  ld [CurrentHealth], a
  ld a, [NextLevel]
  ld c, a                     ; PC = $396
  cp $0c
  jp Z, .Label422
  xor a
  ld [$c169], a
  ld [$c1e5], a
  ld [$c1e6], a
  ld [$c1ca], a
  ld [$c1c0], a
  ld [$c1c1], a
  ld [FirstDigitSeconds], a   ; = 0
  ld [SecondDigitSeconds], a  ; = 0
  ld a, [$c14a]
  or a
  jr nZ, .Label21
  ld a, c
  cp $08
  ld a, 1
  jr Z, .Label22
  ld a, c
  cp $0b
  ld a, 1
  jr Z, .Label20
  ld a, [DifficultyMode]
  or a
  ld a, NUM_DIAMONDS_NORMAL       ; In normal mode you need 10 diamonds.
  jr Z, .Label22
  ld a, NUM_CONTINUES_PRACTICE
  ld [NumContinuesLeft], a        ; In practice mode you have 6 continues.
  ld a, NUM_DIAMONDS_PRACTICE     ; In practice mode you only need 7 diamonds.
.Label22:
  ld [NumDiamondsMissing], a
  ld [MaxDiamondsNeeded], a
.Label21:
  ld a, [CurrentSong2]
  or $40
  ld [CurrentSong], a
  ld a, MINUTES_PER_LEVEL
.Label20:
  ld [DigitMinutes], a
  call fcn0000410c
  call fcn00004120
  call UpdateDiamondNumber
  call fcn00004229
  xor a
  ld [$c154], a
  ld [$c14a], a               ; = 0
  ld c, a
  call fcn000046cb            ; PC = $3ff
: call fcn00001f78
  ld a, [$c190]
  or a
  jr nZ, :-
  ld c, 1
  ld a, [NextLevel]
  cp 4
  jr nZ, :+
  ld a, [CheckpointReached]
  or a
  jr nZ, :+
  ld c, $ff
: ld a, c
  ld [$c146], a
  jr .Label428
.Label422: ; $422
  ld a, [CurrentSong2]
  ld [CurrentSong], a
.Label428: ; $428
  call fcn00004f21
  call UpdateWeaponNumber
  ld e, b
  ld b, c
  call fcn00000ba1
  call fcn00003cf0
  call SetUpInterruptsAdvanced
.PauseLoop: ; $437
  call fcn000014b9
  ld a, [IsPaused]
  or a
  jr Z, :+
  ld a, 7
  rst 0 ; Load ROM bank 7.
  call IncrementPauseTimer
  ld a, 1
  rst 0  ; Load ROM bank 1
  jr .PauseLoop
: ld a, [$c1c9]
  or a
  jr Z, .Label470
  cp $ff
  jr Z, .Label470
  dec a
  ld [$c1c9], a
  jr nZ, .PauseLoop
  ld a, [CurrentLives]
  or a
  jr Z, .Label47c          ; Mowgli reached 0 lives. Time to say good bye.
  ld a, [CurrentLevel]
  cp $0a
  jp Z, .Label290
  cp $0c
  jr Z, .Label47c
  jp .StartGame
.Label470:
  ld a, [JoyPadData]
  and $0f
  cp $0f                    ; Pressing A+B+START+SELECT?
  jr nZ, .PauseLoop
  jp MainContinued          ; Reset the game if the aforementioned buttons are pressed.
.Label47c:
  call StartTimer
  ld a, 7
  ld [CurrentSong], a         ; Load game over jingle.
  call ResetWndwTileMapLow
  ld a, $e4
  ld [rBGP], a                ; Classic colour palette.
  ld a, 2
  rst 0                       ; Load ROM bank 2.
  call LoadFontIntoVram
  ld hl, WellDoneString       ; Load "WELL DONE"
  ld a, [CurrentLevel]
  cp $0c
  jr Z, :+++
  ld a, [NextLevel]
  inc a
  jr Z, :+
  ld hl, ContinueString       ; Load "CONTINUE?"
  ld a, [NumContinuesLeft]
  or a
  jr nZ, :++
: ld hl, GameOverString       ; Load "GAME OVER"
: ld [CanContinue], a
: ld de, $9905
  call DrawString
  xor a
  ld [rSCX], a                ; = 0
  ld [rSCY], a                ; = 0
  ld [TimeCounter], a         ; = 0
  dec a
  ld [NextLevel], a
  ld a, $0b
  ld [ContinueSeconds], a
  call SetUpInterruptsSimple ; $4c7
.Label4ca:
  call fcn000014aa
  ld a, [CanContinue]
  or a
  jr Z, .Label4f9
  ld a, 1
  rst 0                       ; Load ROM bank 1.
  ld a, [JoyPadData]
  and $0b
  jr nZ, .UseContinue            ; Jump if A, START, or SELECT was pressed. Sets CanContinue to zero.
  ld a, [TimeCounter]
  and $3f                     ; Mod 64.
  ld [TimeCounter], a
  jr nZ, .Label4ca
  ld a, [ContinueSeconds]     ; Decreases every second.
  dec a
  ld [ContinueSeconds], a
  jr Z, .Label4ca
  ld de, $990f
  dec a
  call DrawNumber             ; Draws the number after "CONTINUE?"
  jr .Label4ca
.Label4f9:
  ld a, [TimeCounter]
  or a
  jr nZ, .Label4ca
  ld a, [CurrentLevel]
  cp $0c
  jr nZ, :++
  call StartTimer
  call fcn00007523
  call SetUpInterruptsSimple
: call fcn000014aa
  ld a, [TimeCounter]
  or a
  jr nZ, :-
: jp MainContinued
.UseContinue:                 ; $0518
  ld a, [NumContinuesLeft]
  dec a
  ld [NumContinuesLeft], a    ; Reduce the number of continues by one.
  xor a
  ld [$c14a], a               ; = 0.
  ld [CheckpointReached], a   ; = 0.
  ld [CanContinue], a         ; = 0.
  ld hl, CurrentScore1
  ldi [hl], a                 ; CurrentScore1 = 0
  ldi [hl], a                 ; CurrentScore2 = 0
  ld [hl], a                  ; CurrentScore3 = 0
  ld hl, CurrentNumDoubleBanana
  ldi [hl], a                 ; CurrentNumDoubleBanana = 0.
  ldi [hl], a                 ; CurrentNumBoomerang = 0.
  ldi [hl], a                 ; CurrentNumStones = 0.
  ld [hl], a                  ; CurrentSecondsInvincibility = 0.
  ld a, NUM_LIVES
  ld [CurrentLives], a
.Label53e:
  jp .StartGame
  push af
  ld a, [OldRomBank]
  push af
  push bc
  push de
  push hl
  ld a, [$c104]
  or a
  jp nZ, fcn0000688
  inc a
  ld [$c104], a
  rst 0             ; Load a ROM bank.
  ldh a, [rIE]
  ld c, a
  xor a
  ldh [rIF], a
  ld a, c
  and $02
  or $01
  ldh [rIE], a
  ei
  call $ff80
  ld hl, TimeCounter
  inc [hl]
  ld a, [NextLevel]
  bit 7, a ; $56d
  jr Z, :+
  xor a
  ld [rSCX], a               ; = 0.
  ld [rSCY], a               ; = 0.
  ld a, [rLCDC]
  and $f5
  ld [rLCDC], a
  jp fcn0000679
: ld a, [rLCDC]
  bit 7, a
  jp Z, fcn0000679
  call SetBgScroll
  call fcn00001f4a
  call fcn00005372
  call ReadJoyPad
  ld a, [$c1c6]
  or a
  jp nZ, fcn00000649
  call fcn00004184
  ld a, $07
  rst 0
  call fcn00004003
  ld a, $01
  rst 0
  ld a, [$c1ca]
  or a
  jr nZ, fcn0000060d
  ld a, [$c1c9]
  or a
  jr nZ, fcn0000060d
  ld a, [JoyPadData]
  push af
  bit 4, a
  call nZ, $07e2
  pop af
  push af
  bit 5, a
  call nZ, $08cf
  pop af
  push af
  bit 6, a
  call nZ, $0c28
  pop af
  push af
  bit 7, a
  call nZ, $0e90
  ld a, $07
  rst 0               ; Load ROM bank 7.
fcn000005d2:
  call fcn00006800
  ld a, $01
  rst 0               ; Load ROM bank 1.
  ld a, [$c155]
  ld d, a
  and $01
  ld c, a
  pop af
  push af
  ld [$c155], a
fcn000005e2:
  ld d, l
  pop bc
  ld b, a
  and $01
  xor c
  push de                     ; arg3
  call nZ, $47f5
  pop af
  and $02
  ld c, a
  pop af
  push af
  ld b, a
  and $02
  xor c
  call nZ, $423d
  pop af
  push af
  call fcn00004e83
  pop af
  and $04
  call nZ, $0fb9
  call fcn000042b1
  call fcn00001889
  call fcn00001cdb
fcn0000060d:
  call fcn00000f80
  call fcn00005f8f
  call fcn000058e5
  call fcn00004bf3
  call fcn000015be
  call fcn00000f42
  call fcn00000ffa
  call fcn0000122d
  call fcn000056f6
  call fcn00004645
  call fcn0000495a
  call fcn00004a49
  call fcn00000cfb
  call fcn00000ba1
  call fcn00004fd4
  call fcn000050ed
  call fcn00002781
  call fcn00003cf0
  call fcn000025a6
  call fcn00003cd4
fcn00000649:
  ld a, [JoyPadData]
  cp $08
  jr nZ, @ + $29
  ld a, [JoyPadNewPresses]
  cp $08
  jr nZ, @ + $1f
  ld a, [$c1c6]
  xor $01
  ld [$c1c6], a
  jr nZ, @ + $08
  ld a, [CurrentSong2]
  ld [CurrentSong], a
  jr @ + $10
  ld a, $07
  rst 0
  xor a
  ld [$c1c7], a
  ld [$c1c8], a
  call fcn00004000
  call fcn00000ba1
fcn0000679:
  xor a
  ld [$c104], a               ; = 0.
  inc a
  ld [$c102], a               ; = 1.
  pop hl
  pop de
  pop bc
  pop af
  rst 0                       ; Load ROM bank 1.
  pop af
  reti                        ; TODO: Always returns to $14aa?
fcn0000688:
  call SetBgScroll
; $688

.spin:
  jp .spin

; $0752 : This function is called by the timer interrupt ~60 times a seconds.
.TimerIsr:
  push af
  ld a, [OldRomBank]
  push af
  ld a, $07
  rst 0                       ; Load ROM bank 7.
  push bc
  push de
  push hl
  call fcn00064003
  pop hl
  pop de
  pop bc
  pop af
  rst 0                       ; Load old ROM bank.
  pop af
  reti

; $0767 : TODO
SetBgScroll:
  ldh a, [rLCDC]
  and %11110111
  or %10
  ldh [rLCDC], a              ; Select lower BG tile map. Sprite Display on.
  ld a, %00011011
  ld [rBGP], a
  ld a, [BgScrollXLsb]
  ldh [rSCX], a               ; Set background scroll X.
  ld a, [$c13c]               ; Seems to be 0 for most of the time.
  ld c, a
  ld a, [BgScrollYLsb]
  sub c
  ldh [rSCY], a               ; Set background scroll Y.
  ld c, a
  ld a, [BgScrollYMsb]
  ld b, a
  ld a, [NextLevel]
  cp $03
  jr Z, .Label2
  cp $04
  jr Z, .Label1
  cp $05
  jr nZ, .Label4
  ld a, b
  cp $03
  jr nZ, .Label4
  ld a, $df
  sub c
  jr C, .Label4
  cp 120
  jr C, .Label5
  jr .Label4
.Label1:
  ld a, b
  cp 1
  jr nZ, .Label4
  ld a, $ef
  sub c
  jr .Label3
.Label2:
  ld a, 31
  sub c
  jr nC, .Label4
.Label3:
  cp 120
  jr C, .Label4
.Label4:
  ld a, 119
.Label5:
  ldh [rLYC], a               ; Set coincidence value.
  ld a, [$c13b]               ; All these variables eems to be 0 most of the time.
  ld [$c13a], a
  ld a, [$c129]
  ld [$c12b], a
  ld a, [$c12a]
  ld [$c12c], a
  ld c, 40
  ld a, [NextLevel]
  cp $03
  jr Z, :+
  ld c, $d8
: ld a, [BgScrollYLsb]
  sub c
  ld [$c132], a               ; Some kinf of BG scroll Y with an offset that depends on the level.
  ret

; $0ba1:
fcn00000ba1:
  ld a, [$c1df]
  or a
  ret nZ
  ld a, [$c13e]
  ld b, a
  ld a, [BgScrollYLsb]
  ld c, a
  ld a, [PlayerPositionYLsb]
  sub c
  add b
  ld [$c145], a
  ld a, [BgScrollXLsb]
  ld c, a
  ld a, [PlayerPositionXLsb]
  sub c
  ld [$c144], a
  ld c, a
  ld a, [$c15b]
  or a
  jr Z, :+
  ld a, c
  push af
  cp $26
  call C, fcn0000110a
  pop af
  cp $7a
  call nC, fcn0000100a
: ld a, [$c190]
  inc a
  ret Z
  ld a, [InvincibilityTimer]
  or a
  jr Z, :+                    ; Nothing to do if no invincibility time is left.
  ld c, a
  ld a, [TimeCounter]
  and $03                     ; Mod 4
  ld a, c
  jr nZ, :+
  dec a                       ; Decrease invincibility timer every 4 time counter ticks.
  ld [InvincibilityTimer], a
: cp $10
  jr nC, .Labelc0b
  ld c, a
  ld a, [WeaponSelect]
  cp $04
  jr nZ,.Labelc06
  ld a, [CurrentSecondsInvincibility]
  or a
  jr Z, .Labelc06 ; Skip if Mowgli is not invincible.
  ld a, $ff
  ld [InvincibilityTimer], a
  jr .Labelc0b
.Labelc06:
  ld a, c
  bit 1, a
  jr .Labelc0d
.Labelc0b:
  bit 0, a
.Labelc0d:
  jr Z, .Labelc14
  ld a, $80
  jr .Labelc14
  xor a
.Labelc14;
  ld c, a
  ld a, [$c1ba]
  and $10
  or c
  ld [$c18a], a
  ld a, 2                  ; Load ROM bank 2.
  rst 0
  call fcn00014000
  ld a, 1
  rst 0                    ; Load ROM bank 1
  ret

; $0cfb : TODO
fcn00000cfb:
  ret

; $0f80 : TODO
fcn00000f80:
  ld a, [$c15b]
  cp $03
  ret Z
  ld a, [$c172]
  or a
  ret nZ
  ld a, [$c16f]
  or a
  ret nZ
  ld a, [$c1df]
  or a
  ret nZ
  ld a, [$c17f]
  and $0f
  ret nZ
  ld a, [BgScrollXLsb]
  ld c, a
  ld a, [$c13f]
  sub c
  ld b, a
  ld a, [$c146]
  ld c, a
  ld a, b
  bit 7, c
  jr Z, :+
  cp $78
  ret nC
  jp fcn0000110a
: cp $28
  ret C

; $100a: TODO
fcn0000100a:
  ret

; $110a : TODO
fcn0000110a:
  ret

SECTION "TODO00", ROM0[$1214]

; $1214: TODO
fcn00001214:
  ld a, e
  call TrippleShiftRightCarry
  ld [$c11d], a
  call TrippleRotateShiftRight
  ld a, e
  ld [$c115], a
  srl d
  rra
  ld [$c117], a
  ld a, d
  ld [$c118], a
  ret

; $1351: TODO
fcn00001351:
  ld hl, $c1d4
  ld c, [hl]
  inc hl
  ld b, [hl]
  ld hl, BgScrollYLsb
  ld e, [hl]
  inc hl
  ld d, [hl]
  ld a, d
  cp b
  jr nZ, :+
  ld a, e
  cp c
  ret Z
: inc de
  ld a, e
  and $07
  jr Z, :+
  ld [hl], d
  dec hl
  ld [hl], e
  ret
: ld a, [$c1ce]
  or a
  ret nZ
  inc a
  ld [$c1ce], a
  ld [hl], d
  dec hl
  ld [hl], e
  call fcn00001440
  ld a, [$c11c]
  add $09
  srl a
  push af
  ld hl, $cf00
  ld a, [$c113]
  ld b, $00
  ld c, a
  pop af
  or a
  jr Z, :++
  : add hl, bc
  dec a
  jr nZ, :-
  : ld a, [$c115]
  and $01
  xor $01
  ld d, a
  ld a, [$c118]
  ld b, a
  ld a, [$c117]
  ld c, a
  or a
  jr nZ, .Label2
  ld a, b
  or a
  jr nZ, .Label2
  ld a, d
  ld de, $c3d8
  or a
  jr Z, .Label1
  inc de
  jr .Label1
.Label2:
  ld a, c
  sub d
  ld c, a
  jr nC, :+
  dec b
  : srl b
  rr c
  add hl, bc
  ld de, $c3d8
  ld a, [$c117]
  ld c, a
  ld a, [$c115]
  and 1
  call Z, $13ed
.Label1:
  ld b, $0b
: push bc
  call fcn00001417
  pop bc
  inc c
  dec b
  jr nZ, :-
  ld a, [$c11d]
  ld [$c11f], a
  ld a, [$c122]
  ld [$c124], a
  ld a, 1
  rst 0                       ; Load ROM bank 1.
  or a
  ret

fcn00001417:
  ld a, [hl]
  push bc
  push hl
  call fcn00001454
  ld a, c
  and $01
  jr Z, :+
  inc hl
: ld a, [$c11c]
  and $01
  jr nZ, :+
  inc hl
  inc hl
: ld bc, $cb00
  add hl, bc
  ld a, [hl]
  call fcn00001454
  ld a, [$c11b]
  and $01
  jr Z, :+
  inc hl
  inc hl
: jp $133b

; $1440
fcn00001440:
  ld a, e
  call TrippleShiftRightCarry
  ld [$c122], a
  call TrippleRotateShiftRight
  ld a, e
  ld [$c11b], a
  srl a
  ld [$c11c], a
  ret

; $1454 : TODO
fcn00001454:
  ld h, 0
  add a
  rl h
  add a
  rl h
  ld l, a
  ret

; $145e: Shift value in "a" 3 times right.
TrippleShiftRightCarry:
  srl a
  srl a
  srl a
  ret

; $1465: Shift value in "d" 3 times right. Rotate value in "e" 3 times right.
TrippleRotateShiftRight:
  srl d
  rr e
  srl d
  rr e
  srl d
  rr e
  ret

; $1472
fcn00001472:
  srl h
  rr l
  srl h
  rr l
  srl h
  rr l
  ret

; $147f
fcn0000147f:
  ld a, [BgScrollXMsb]
  and $0f
  swap a
  srl a
  ld e, a
  ld a, [BgScrollYMsb]
  and $0f
  swap a
  srl a
  db $57,$06,$00,$fa,$13 ; TODO: What is this?
  ld a, [$c113]
  ld c, a
  ld h, d
  ld l, b
  ld a, 8
: add hl, hl
  jr nC, :+
  add hl, bc
: dec a
  jr nZ, :--
  ld d, 0
  add hl, de
  ld d, h
  ld e, l
  ret

SECTION "TODO050", ROM0[$14aa]
fcn000014aa:
  ld a, [OldRomBank]
  push af             ; Save ROM bank
  ld a, 7
  rst 0               ; Load ROM bank 7
  call fcn00064003   ; TODO: Continue here
  pop af              ; Restore old ROM bank
  rst 0
  call ReadJoyPad

; Waits for interrupt. Reads [$c102], waits for it to turn non-zero, and then continues.
; TODO: find out what $c102 is used for.
fcn000014b9:
: halt
  ld a, [$c102]
  and a
  jr Z, :-
  xor a
  ld [$c102], a
  ret

; $14c5: Generates timer interrupt ~62.06 times per second.
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

; $14e2: Waits for rLY 128 and then stops display operation
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

; $14fa:
SetUpInterruptsSimple:
  ld a, IEF_VBLANK              ; Enable VBLANK interrupt.
  ld b, 0                       ; rSTAT = 0.
  ld c, b                       ; rLYC = 0.
  jr SetUpInterrupts

; $1501:
SetUpInterruptsAdvanced:
  ld c, $77                     ; rLYC = 119.
  ld a, IEF_STAT | IEF_VBLANK   ; Enable VBLANK and STAT interrupt.
  ld b, $40                     ; rSTAT = $40.

; $1507: a = rIE, b = rSTAT, c = rLYC
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

; $1889 : TODO
fcn00001889:
  ld a, [$c1c9]
  or a
  ret nZ
  ld a, [$c1df]
  or a
  ret nZ
  ld hl, $c1b2
  push hl
  xor a
  ldi [hl], a
  ld a, [$c144]
  ld c, a
  sub $04
  ldi [hl], a
  ld d, $20
  ld a, [$c177]
  or a
  jr Z, :+
  ld d, $10
: ld a, [$c145]
  ld b, a
  sub d
  ldi [hl], a
  ld a, c
  add $04
  ldi [hl], a
  ld a, b
  sub $02
  ldi [hl], a
  pop de
  ld a, b
  cp $74
  jp nC, fcn00001aeb
  call fcn00001eb2
  jr C, :+
  call fcn00001e73
  ret nC
: ld a, [$c1ca]
  or a
  jp nZ, $1bad
  ld c, $17
  rst 8
  inc a
  jp Z, $1973
  ld c, $05
  rst sym.rst_8
  cp $89
  jp Z, $1b8e
  cp $24
  jr nZ, :+
  set 1, [hl]
  jp $1973
: cp $97
  jr C, :+
  cp $a1
  jp C, $1bc0
: ld b, a
  cp $92
  jr Z, $78
  cp $93
  jr Z, $74
  cp $a1
  jr Z, $70
  cp $28
  jr Z, $72
  cp $59
  jr Z, $6e
  cp $81
  jr Z, $6a
  ld a, [$c16f]
  or a
  jr Z, $64
  ld a, [$c170]
  cp $10
  jr C, $5d
  inc hl
  ldd a, [hl]
  ld c, a
  ld a, [$c136]
  sub c
  ld c, a
  ld a, [$c145]
  add $08
  cp c
  jr nC, $4d
  ld a, b
  cp $54
  jr Z, $48
  cp $85
  jr Z, $0c
  cp $71
  jr C, $04
  cp $81
  jr C, $3c
  cp $20
  jr nZ, $0c
  ld a, $0a
  ld [$c501], a
  ld a, $40
  ld c, $0a
  rst $10
  jr $5b
  ld a, $0a
  ld [$c501], a
  ld a, $30
  call fcn0000420f
  ld c, $17
  rst sym.rst_8
  swap a
  and $0f
  jr Z, $05
  call fcn00001afb
  jr $43
  set 6, [hl]
  ld a, $14
  ld c, $0c
  rst $10
  ld a, $01
  ld c, $09
  rst $10
  jr $35
  set 7, [hl]
  ld c, $01
  jr $0a
  ld c, $04
  ld a, [$c111]
  or a
  jr Z, $02
  dec c
  dec c
  ld a, [$c189]
  or a
  ret nZ
  ld a, [$c1ba]
  or a
  ret nZ
  dec a
  ld [$c1ba], a
  ld a, $07
  ld [$c501], a
  ld a, c
  cp $02
  jr C, $0a
  push bc
  call fcn000019ac
  pop bc
  ld a, $18
  ld [$c189], a
  jp $1607
  ld a, [$c146]
  ld [$c176], a
  ld a, $0c
  jr $3b
fcn000019ac:
  ld a, [$c15b]
  and $01
  ret nZ
  ld a, [$c169]
  or a
  ret nZ
  ld a, [$c158]
  or a
  ret nZ
  ld c, $07
  rst 8
  and $0f
  jr Z, $08
  bit 3, a
  jr Z, $09
  or $f0
  jr $05
  ld a, [$c146]
  cpl
  inc a
  ld [$c176], a
  ld a, [$c16f]
  or a
  jr nZ, $08
  ld a, [$c173]
  or a
  jr Z, $06
  cp $0c
  ld a, $0b
  jr C, $02
  ld a, $11
  ld [$c175], a ; = $11
  ld a, $44
  ld [$c18d], a ; = $44
  xor a
  ld [$c17d], a ; = 0
  ld [$c172], a ; = 0
  ld [$c173], a ; = 0
  ld [$c16f], a ; = 0
  ld [$c170], a ; = 0
  ld [$c17b], a ; = 0
  ld [$c17f], a ; = 0
  ld [$c178], a ; = 0
  ret


; $1cc1: TODO
fcn00001cc1:
  push hl
  ld hl, $d726
  ld [hl], $03
  inc hl
  ld [hl], $00
  pop hl
  ld a, $0d
  ld [$c501], a
  ret

; $1f4a
fcn00001f4a:
  ld a, [$c1cd]
  or a
  ret nZ
  ld a, [$c1ce]
  or a
  ret nZ
  ld a, [$c1cf]
  or a
  ret nZ
  ld a, [$c18d]
  ld c, a
  ld a, [$c190]
  cp c
  jr nZ, fcn00001f78
  ld a, [$c1dc]
  and $80
  jp nZ, $5325
  call fcn0000226b
  call fcn000022d1
  call fcn000051d9
  ret C
  jp fcn0000211b

; $1f78: TODO
fcn00001f78:
  ld a, 2
  rst 0             ; Load ROM bank 2.
  ld a, [$c18b]
  or a
  call Z, $40e8
  ld a, [$c193]
  ld e, a
  ld a, [$c194]
  ld d, a
  ld hl, $c195
  ldi a, [hl]
  ld h, [hl]
  ld l, a
  ld b, 4
  ld a, [$c18c]
  ld c, a
.Label4:
  ldi a, [hl]
  sub 2
  jr nZ, .Label2
.Label3:
  dec c
  jr nZ, .Label4
  jr .Label1
  pop hl
  pop bc
  jr .Label3
.Label2:
  push bc
  push hl
  sub $02
  swap a
  ld b, a
  and $f0
  ld c, a
  ld a, b
  and $0f
  ld b, a
  ld hl, $c199
  ldi a, [hl]
  ld h, [hl]
  ld l, a
  add hl, bc
  call CopyToOam
  pop hl
  pop bc
  dec c
  jr Z, .Label1
  dec b
  jr nZ, .Label4
.Label1:
  ld a, 1
  rst 0                       ; Load ROM bank 1.
  ld a, l
  ld [$c195], a
  ld a, h
  ld [$c196], a
  ld a, e
  ld [$c193], a
  ld a, d
  ld [$c194], a
  ld a, c
  ld [$c18c], a
  or a
  ret nZ

; $2036: Copies 32 Byte from [hl] to [de] with respect to the OAM flag. Yes, the loop is unrolled.
CopyToOam:
  ld c, $41                   ; STAT registers at $ff41
  ld b, STATF_OAM
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 0.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 1.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 2.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 3.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 4.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 5.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 6.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 7.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 8.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 9.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 10.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 11.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 12.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 13.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 14.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 15.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 16.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 17.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 18.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 19.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 20.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 21.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 22.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 23.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 24.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 25.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 26.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 27.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 28.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 29.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 30.
  ld [de], a
  inc de
: ld a, [$ff00 + c]
  and b
  jr nZ, :-                   ; Wait for OAM.
  ldi a, [hl]                 ; Byte 31.
  ld [de], a
  inc de
  ret

SECTION "TODO227e", ROM0[$227e]
fcn0000227e:
  ld a, [NextLevel]
  cp $0a
  jr nZ, :+
  ld hl, $6129                ; TODO: check if this is always ROM bank 3.
  ld de, $9e00
  jp DecompressTilesIntoVram
: cp $04
  ret C
  cp $06
  ret nC
  ld hl, $22b1
  ld de, $9e00
  ld b, $20
: push bc
  ldi a, [hl]
  push hl
  swap a
  ld b, $00
  ld c, a
  ld hl, $60d9
  add hl, bc
  ld c, $10
  rst $38
  pop hl
  pop bc
  dec b
  jr nZ, :-
  ret

SECTION "TODO54654", ROM0[$2329]
fcn00002329:
  ld a, [CheckpointReached]

fcn0000232c:
  ld c, a
  or a
  call nZ, fcn00001cc1
  ld a, [NextLevel]
  ld d, a
  dec a
  swap a
  add c
  ld b, 0
  ld c, a
  ld hl, $4000
  add hl, bc
  ldi a, [hl]
  ld [BgScrollXLsb], a
  ldh [rSCX], a
  ldi a, [hl]
  ld [BgScrollXMsb], a
  ldi a, [hl]
  ld [BgScrollYLsb], a
  ldh [rSCY], a
  ldi a, [hl]
  ld [BgScrollYMsb], a
  ld a, d
  cp $0c
  jr Z, :+
  ldi a, [hl]
  ld [PlayerPositionXLsb], a
  ldi a, [hl]
  ld [PlayerPositionXMsb], a
  ldi a, [hl]
  ld [PlayerPositionYLsb], a
  ldi a, [hl]
  ld [PlayerPositionYMsb], a
  ret
: ld a, [BgScrollYLsb]
  ld [$c1c1], a
  ret

; $2371
fcn00002371:
  ld a, [DigitMinutes]
  or a
  ret nZ                      ; Continue if zero.
  ld a, [SecondDigitSeconds]
  cp 2
  ret nC                      ; Continue if 10 seconds left.
  ld a, $15
  ld [$c501], a
  ret

; $2382
fcn00002382:
  push bc
  push hl
  add a
  add a
  add a
  ld b, 0
  ld c, a
  ld hl, $c660
  add hl, bc
  ld a, [hl]
  and $04
  pop hl
  pop bc
  ret

SECTION "TODO09", ROM0[$2394]
; TODO
fcn00002394:
  ret

; TODO
SECTION "TODO2409", ROM0[$2409]
fcn00002409:
  ld a, [$c1ad]
  ld b, a
  inc b
  ld hl, $c600
  call MemsetZero2
  ld hl, $c200
  ld b, $08
: ld [hl], $80
  ld a, l
  add $20
  ld l, a
  dec b
  jr nZ, :-
  ld hl, $c1a8
  ld b, $05
  jp MemsetZero2

SECTION "TODO10", ROM0[$242a]
; TODO
fcn0000242a:
  ret

; TODO
SECTION "TODO06", ROM0[$2578]
fcn00002578:
  call fcn00002409
  ld hl, $7f60
  ld de, $c200
  ld bc, $0018
  rst $38
  ld a, [NextLevel2]
  cp $0a
  jr nZ, :+
  ld de, $c220
  ld bc, $0018
  rst $38
  ld a, $28
: ld [PlayerPositionXLsb], a
  xor a
  ld [PlayerPositionXMsb], a ; = 0
  ld [PlayerPositionYLsb], a ; = 0
  ld [PlayerPositionYMsb], a ; = 0
  ld [$c158], a ; = 0
  ret


SECTION "TODO025a6", ROM0[$25a6]
; $25a6 : TODO
fcn000025a6:
  ld a, [$c1ca]
  or a
  ret nZ
  ld a, [$c1ef]
  or a
  ret nZ
  ld a, [$c1ad]
  or a
  ret Z
  ld c, a
  ld a, [BgScrollYLsb]
  add $50
  ld [WindowScrollYLsb], a
  ld a, [BgScrollYMsb]
  adc $00
  ld [WindowScrollYMsb], a
  ld a, [BgScrollXLsb]
  add $50
  ld [WindowScrollXLsb], a
  ld a, [BgScrollXMsb]
  adc $00
  ld [WindowScrollXMsb], a
  ld a, [NextLevel]
  cp $05
  jr Z, :+
  cp $03
  jr nZ, .Label25f8
  ld b, $15
  jr :++
: ld b, $07
: ld a, [$c129]
  add $50
  ld [$c10a], a
  ld a, [$c12a]
  adc $00
  cp b
  jr C, :+
  sub b
: ld [$c10b], a
.Label25f8:
  ld hl, $c1b0
  ldi a, [hl]
  ld h, [hl]
  ld l, a
  ld a, [$c1a8]
  ld b, $04
.Label2604:
  push bc                     ; arg2
  push af                     ; arg1
  ld c, a
  ld b, $c6
  ld a, [bc]                  ; arg2
  bit 7, a
  jr nZ, :+
  push hl
  call fcn00002632
  pop hl
: ld bc, $0018
  add hl, bc
  pop af
  inc a
  pop bc
  cp c
  jr C, :+
  ld hl, $d700
  xor a
: dec b
  jr nZ, .Label2604
  ld [$c1a8], a
  ld a, l
  ld [$c1b0], a
  ld a, h
  ld [$c1b1], a
  ret

; $ 2632 : TODO
fcn00002632:
  ret

fcn00002781:
  ld bc, $0820
  ld hl, $c200
: push bc
  call fcn000027ab
  pop bc
  ld a, l
  add c
  ld l, a
  dec b
  jr nZ, :-
  ld hl, $c300
  ld b, $04
  call $279f
  ld hl, $c380
  ld b, $02
: push bc
  call fcn00005bc4
  pop bc
  ld a, l
  add c
  ld l, a
  dec b
  jr nZ, :-
  ret

SECTION "TODO3cd4", ROM0[$3cd4]
fcn00003cd4:
  ld a, [$c1cc]
  or a
  ret Z
  dec a
  ld [$c1cc], a
  ret nZ
  ld a, [NextLevel]
  cp $08
  ld a, $09
  jr nZ, fcn00003ce9
  ld a, $08
fcn00003ce9:
  ld [$c500], a
  ld [$c1cb], a
  ret

SECTION "TODO3cf0", ROM0[$3cf0]
fcn00003cf0:
  ld bc, $0820
  ld hl, $c200
  ld de, $c018
  call fcn00003d1d
  ret nC
  ld hl, $c300
  ld b, $04
  call fcn00003d1d
  ret nC
  ld hl, $c380
  ld b, $02
  call fcn00003d1d
  ret nC
  ld a, $a0
  sub e
  ret Z
  ret C
  ld b, a
  ld h, d
  ld l, e
; §3d17 : Set [hl:hl+b-1] to zero.
MemsetZero2:
  xor a
: ldi [hl], a
  dec b
  jr nZ, :-
  ret

SECTION "TODO3d1d", ROM0[$3d1d]
; $3d1d : TODO
fcn00003d1d:
  push bc
  bit 7, [hl]
  jr nZ, :+
  push hl
  call fcn00003d38
  pop hl
  jr C, :+
  res 4, [hl]
: pop bc
  ld a, l
  add c
  ld l, a
  ld a, e
  cp $a0
  ret nC
  dec b
  jr nZ, fcn00003d1d
  scf
  ret

; $3d38 : TODO
fcn00003d38:
  ret

SECTION "LZ77Decompression", ROM0[$3eec]

  ; $3eec:
LoadFontIntoVram:
  ld hl, CompressedFontData
  ld de, $8ce0

; $3ef2: Implements an LZ77 decompression.
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
.Start                        ; $3f16
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

; $3f85: Gets one LZ77 item and stores it in bc. This can either be symbol length, offset, or length.
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

; $3fc9: Shift the compressed input bit stream by one bit.
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

; $3fdf: Shift the compressed input bit stream by one bit.
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

SECTION "bank1", ROMX, BANK[1]
; $4000: TODO
fcn00004000:
  ld bc, $05e8
fcn00004003:
  ld a, [NextLevel]
  cp 3
  jr Z, :+
  cp 5
  ret nZ
  ld bc, $0188
: add hl, bc
  ld de, $9c20
  ld bc, $0801
  jr fcn0000401f
fcn00004019:
  ld de, $9800
  ld b, 8
  ld c, b
fcn0000401f:
  push bc
  push de
  push hl
.Label1:
  push bc
  push de
  ldi a, [hl]
  push hl
  ld b, 0
  add a
  rl b
  add a
  rl b
  ld c, a
  ld hl, $cb00
  add hl, bc
  push de
  call fcn00004069
  inc de
  inc de
  call fcn00004069
  pop de
  ld a, e
  add $40
  ld b, b
  ld e, a
  jr nC, :+
  inc d
: call fcn00004069
  inc de
  inc de
  call fcn00004069
  pop hl
  pop de
  inc de
  inc de
  inc de
  inc de
  pop bc
  dec b
  jr nZ, .Label1
  pop hl
  ld a, [$c113]
  ld c, a
  add hl, bc
  pop de
  ld a, e
  add $80
  ld e, a
  jr nC, :+
  inc d
: pop bc
  dec c
  jr nZ, fcn0000401f
  ret

; $4069: TODO
fcn00004069:
  push de
  ldi a, [hl]
  push hl
  ld b, 0
  add a
  rl b
  add a
  rl b
  ld c, a
  ld hl, $c700
  add hl, bc
  ldi a, [hl]
  ld [de], a
  inc de
fcn0000407c:
  ldi a, [hl]
  ld [de], a
  dec de
  ld a, e
  add $20
  ld e, a
  jr nC, :+
  inc d
: ldi a, [hl]
  ld [de], a
  inc de
  ld a, [hl]
  ld [de], a
  pop hl
  pop de
  ret

; $408e: TODO
fcn0000408e:
  ld d, $0c
fcn0000408f:
  inc c
  ld a, [NextLevel]
  ld e, a
fcn00004094:
  cp $0b
  jr nZ, :+
  ld d, $20
: ld a, [$c113]
  ld b, 0
  add a
  rl b
  swap b
  swap a
  ld c, a
  and $0f
  or b
  ld b, a
  ld a, c
  and $f0
  ld c, a
  ld a, e
  cp $0a
  ld a, [bc]
  jr nZ, :+
  ld a, c
  sub $18
  ld c, a
  dec b
: ld a, c
  sub d
  ld [$c14d], a
  ld a, b
  sbc 0
  ld [$c14e], a
  ld a, e
  cp $0c

SECTION "TODO4151", ROMX[$4151], BANK[1]
; $4151 : Updates the number of diamonds displayed.
UpdateDiamondNumber:
  ld a, [NumDiamondsMissing]
  ld e, $e6
  jr fcn0000416a
; $4158 : Updates the number of ammo displayed for the current weapon.
UpdateWeaponNumber:
  ld a, [WeaponSelect]
  or a
  jr nZ, :+
  ld a, NUM_BANANAS
  jr :++
: ld hl, AmmoBase
  add l
  ld l, a
  ld a, [hl]
: ld e, $ea
fcn0000416a:
  ld d, $9c
  ld b, a
  and $f0
  swap a
  call DrawNumber
  inc e
  ld a, b
  and $0f
; Non-ASCII number in "a", tile map in "de".
DrawNumber:
  add $ce
  ld c, a
: ldh a, [rSTAT]
  and $02
  jr nZ, :-                   ; Don't write during OAM-RAM search.
  ld a, c
  ld [de], a
  ret

SECTION "TODO05", ROMX[$4f21], BANK[1]
; $4f21 : TODO
fcn00004f21:

SECTION "TODO54", ROMX[$5882], BANK[1]
; $5882: TODO
fcn00005882:
  ld a, [NextLevel]
  ld de, $06c8
  cp 5
  jr Z, :++
  cp 3
  ret nZ
  ld hl, $9c3f
  ld bc, $0020
  ld a, 4
: ld [hl], 2
  add hl, bc
  dec a
  jr nZ, :-
  ld de, $05e8
: ld a, e
  ld [$c134], a
  ld a, d
  ld [$c135], a
  ld hl, $9c00
  ld a, $20
: ld [hl], 2
  inc hl
  dec a
  jr nZ, :-
  ld hl, $c129
  ld a, [BgScrollXLsb]
  ldi [hl], a
  ld a, [BgScrollXMsb]
  ldi [hl], a
  ld b, $06
  xor a
: ldi [hl], a
  dec b
  jr nZ, :-
  ld [$c13a], a
  ld [$c13b], a
  ld [$c13e], a
  ld a, [NextLevel]
  cp $03
  jr Z, :+
  ld a, [CheckpointReached]
  or a
  ret nZ
: call fcn00001351
  push af
  call fcn0000556f
  pop af
  jr nZ, :-
  ret

SECTION "bank2", ROMX, BANK[2]

; $14000 : TODO
fcn00014000:
  ret


SECTION "TODO0232", ROMX[$74fd], BANK[2]

; $174fd: Loads the tiles of the status window.
LoadStatusWindowTiles:
  ld hl, CompressedStatusWindowData
  ld de, $8d80
  add b
  adc l
  jp DecompressTilesIntoVram

; $17506: Draws the initial status window including health, time, diamonds, etc.
InitStatusWindow:
  ld hl, $787f
  ld de, $9ca0    ; Window tile map.
  ld b, 4
  ld c, 20
: ldi a, [hl]
  ld [de], a
  inc de
  dec c
  jr nZ, :-       ; Copy 20 bytes of data to the window tile map.
  ld c, 20
  ld a, e
  add $0c
  ld e, a         ; e = e + 12 to head to next line.
  jr nC, :+
  inc d           ; Basically a 16-bit int increment of the address.
: dec b
  jr nZ, :--
  ret

SECTION "TODO02", ROMX[$7529], BANK[2]
; $17529:  Start address of ASCII string in hl. Address of window tile map in de.
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

SECTION "bank3", ROMX[$4000], BANK[3]
fcn00024000:
  push bc
  ld hl, $62ae
  add hl, bc
  push bc
  push hl
  ld hl, CompressedTODOData1
  ld a, c
  cp $14
  jr nZ, :+
  ld hl, CompressedTODOData2
: ld de, $c700
  call DecompressTilesIntoVram
  pop hl
  ldi a, [hl]
  ld h, [hl]
  ld l, a
  ld de, $c900
  call DecompressTilesIntoVram
  pop bc
  ld hl, $6b40
  add hl, bc
  push hl
  ld hl, $6b58
  ld a, c
  cp $14
  jr nZ, :+
  ld hl, $7226
: ld de, $cb00
  call DecompressTilesIntoVram
  pop hl
  ldi a, [hl]
  ld h, [hl]
  ld l, a
  ld de, $cd00
  call DecompressTilesIntoVram
  pop bc
  sla c
  sla c
  ld hl, $409a
  add hl, bc
  ld e, [hl]
  inc hl
  ld d, [hl]
  inc hl
  ldi a, [hl]
  push hl
  ld h, [hl]
  ld l, a
  ld a, [NextLevel]
  cp 9
  jr Z, :+
  ld a, d
  cp $90
  jr Z, :++
: push hl
  push de
  ld hl, $40fa
  call DecompressInto9000
  pop de
  pop hl
  call DecompressTilesIntoVram
  pop hl
  inc hl
  ld e, [hl]
  inc hl
  ld d, [hl]
  inc hl
  ld a, d
  or e
  ret Z

SECTION "TODO03", ROMX[$407c], BANK[3]
; $2407c: Decompresses and loads the Virgin logo.
LoadVirginLogoData:
  ld hl, CompressedVirginLogoData
  call DecompressInto9000
  ld hl, $9800
  ld de, $8800
  ld bc, $0200
  rst $38                     ; Copy data from [hl] into [de]
  ld hl, CompressedVirginLogoTileMap

; $2408f: Decompress data in [hl] into $9800 (window tile map).
DecompressInto9800:
  ld de, _SCRN0
  jr JumpToDecompress

; $24094: Decompress data in [hl] into $9000 (tile data table).
DecompressInto9000:
  ld de, $9000
; $24097
JumpToDecompress:
  jp DecompressTilesIntoVram

SECTION "TODO4897", ROMX[$4000], BANK[4]
fcn00034000:
  push bc
  ld hl, $401a
  add hl, bc
  ldi a, [hl]
  ld h, [hl]
  ld l, a
  ld de, $cefe
  push de
  call DecompressTilesIntoVram
  pop hl
  pop bc
  ldi a, [hl]
  ld [$c113], a
  ld a, [hl]
  ld [$c114], a
  ret

SECTION "TODO4582", ROMX[$4000], BANK[6]
fcn00054000:
 ld de, $c400
: ldi a, [hl]
 bit 7, a
 jr nZ, :+
 ld [de], a
 inc e
 jr nZ, :-
 ret
: and $7f
 jr nZ, :+
 or $80
: ld b, a
  xor a
  ld [de], a
  inc e
  ret Z

SECTION "bank7", ROMX, BANK[7]

; $64000:
LoadSound0:
  jp LoadSound1

fcn00064003:
  call fcn000663d4
  ld a, [$c506]
  and a
  jr Z, .Label7
  ld a, [CurrentSoundVolume]
  cp $01
  jr nZ, .Label6
.Label8:
  ld hl, $c500
  ld a, [hl]
  and $3f
  set 7, [hl]
  jp .Label1
.Label7:
  ld a, [CurrentSong]
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
  call fcn0006414b
  ld b, c
  call fcn00064418
  call fcn000646db
  call fcn00064a06
  call fcn00064c31
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
  ld a, [CurrentSoundVolume]    ; Load sound volume setting
  dec a                         ; Decrease it
  cp 1
  jr Z, .Label3                 ; Done if we reached setting 1
  ld [CurrentSoundVolume], a    ; Save old setting (although this is redundant)
  call SetVolume
  jr .Label2
.Label3:
  xor a
  ld [$c504], a
  ld [$c506], a   ; = 0
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

; $64118:
LoadSound1:
  ld a, $00
  ldh [rAUDENA], a
  ld a, $ff
  ld [CurrentSong], a
  push bc
  inc a          ; a = 0
  ld [$c504], a
  ld [$c506], a
  ld [CurrentSoundVolume], a  ; Sound volume setting = 0 (sound off)
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
fcn0006414b:
  ret

; TODO
fcn00064418:
  ret

; TODO
fcn000646db:
  ret

; TODO
fcn00064a06:

; TODO
fcn00064c31:
  ret


; $64dee
; Loads a sound volume setting (see VolumeSettings) from $4e00 + "a"
; Saves old "a" to CurrentSoundVolume. There are 8 volume settings in total.
SetVolume:
  ld [CurrentSoundVolume], a
  ld de, VolumeSettings
  add e
  ld e, a
  ld a, [de]
  ldh [rAUDVOL], a ; [rAUDVOL] = $4e00 + a
  ret

; $64dfa: I guess this is just non-occupied space.
TODO100:
  db $00,$00,$00,$00,$00,$00

SECTION "VolumeSettings", ROMX[$4e00], BANK[7]
; $64e00: Volume settings from quiet ($88 = no volume at all) to loud ($ff).
VolumeSettings:
  db $88,$99,$aa,$bb,$cc,$dd,$ee,$ff

; TODO
fcn00064e67:
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
fcn0006637a:
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

fcn000663d4:
  ld a, [$c501]
  bit 7, a
  call Z, fcn0006637a
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

SECTION "TODO681f", ROMX[$681f], BANK[7]
; $6681f : Increments pause timer. Every 16 calls, the color is toggled.
IncrementPauseTimer:
  ld a, [PauseTimer]
  inc a
  and $0f                     ; Mod 16
  ld [PauseTimer], a
  ret nZ
  ld a, [ColorToggle]
  inc a
  and $01
  ld [ColorToggle], a
  ret

SECTION "TODO01", ROMX[$6833], BANK[7]
; $66833:
SetUpScreen:
  xor a
  ld [CurrentSong], a  ; = 0
  ldh [rSCX], a  ; = 0
  ldh [rSCY], a  ; = 0
  ldh [rWY], a   ; = 0
  dec a
  ld [NextLevel], a  ; = =$ff
  ld a, 7
  ldh [rWX], a
  ld a, $0c
  ld [$c502], a
  ld a, $c0
  ld [$c503], a
  ld a, $a0
  ld [TimeCounter], a
  ld a, NUM_LIVES
  ld [CurrentLives], a
  ld a, NUM_CONTINUES_NORMAL
  ld [NumContinuesLeft], a
  ret

; $6685f: TODO
; Stores value from [$66871 + current level] into CurrentSong2
; Stores $4c into CurrentSong.
FadeOutSong:
  ld hl, LevelSongs
  ld a, [CurrentLevel]
  add l
  ld l, a
  ld a, [hl]
  ld [CurrentSong2], a
  ld a, $4c
  ld [CurrentSong], a  ; Fade out song.
  ret

SECTION "TODO066871", ROMX[$6881], BANK[7]
LevelSongs:
  db $08,$00,$01,$03,$04,$02,$00,$06,$02,$03,$05,$05,$00,$00,$00,$00