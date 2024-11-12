SECTION "ROM Bank $000", ROM0[$0]

LoadRomBank::
    ld [rROMB0], a
    ret
    nop
    nop
    nop
    nop

; a = [hl + c]
RST_08::
    push hl
    ld b, $00
    add hl, bc
    ld a, [hl]
    pop hl
    ret
    nop

RST_10::
    push hl
    ld b, $00
    add hl, bc
    ld [hl], a
    pop hl
    ret
    nop

RST_18::
    push hl
    ld b, $00
    add hl, bc
    inc [hl]

Call_000_001d:
    pop hl
    ret
    nop

RST_20::
    push hl
    ld b, $00
    add hl, bc
    dec [hl]

Jump_000_0025:
    pop hl
    ret


    rst $38

RST_28::
    push hl
    ld b, $00
    add hl, bc
    cp [hl]
    pop hl
    ret


    rst $38

RST_30::
    push hl
    ld b, $00
    add hl, bc
    add [hl]

Call_000_0035:
    pop hl
    ret


    rst $38

; Calls CopyData. b is incremented if c == 0.
RST_38::
    ld a, c
    or a
    jr z, CopyData
    inc b
    jr CopyData
    ld a, a

VBlankInterrupt::
    jp Jump_000_0541
    nop
    nop
    nop
    nop
    nop

LCDCInterrupt::
    jp Jump_000_0693
    nop
    nop
    nop
    nop
    nop

TimerOverflowInterrupt::
    jp TimerIsr
    nop
    nop
    nop
    nop
    nop

SerialTransferCompleteInterrupt::
    reti
    nop
    nop
    nop
    nop
    nop
    nop
    nop

JoypadTransitionInterrupt::
    reti

Main::
    di
    ld sp, $fffe
Call_000_0065:
    call Transfer
    jp MainContinued

; $6b: Transfers 10 bytes from $79 into the high RAM.
Transfer::
    ld c, $80
Jump_000_006d: ; TODO: Maybe remove.
    ld b, $0a
    ld hl, OamTransfer
  : ld a, [hl+]
    ld [c], a
    inc c
    dec b
    jr nz, :-
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

; $83: Copies values given in [hl], to [de] with a length of "bc".
; Decrements "bc" and increments "de".
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
ResetWndwTileMapLow::
    ld bc, $0400
    jr ResetWndwTileMapSize

; $92: Sets lower and upper window tile map to zero.
ResetWndwTileMap::
    ld bc, $0800
ResetWndwTileMapSize:
    ld hl, _SCRN0
    jr MemsetZero

; $9a:
ResetRam::
    ld bc, $00a0
Jump_000_009d: ; TODO: Maybe remove.
    ld hl, _RAM
    call MemsetZero
    ld hl, _RAM
    ld bc, $1ff8

; $a9: hl = start address, bc = length
MemsetZero::
    ld [hl], $00
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, MemsetZero
    ret

; $b2: Read joy pad and save result on $c100 and $c101.
; From MSB to LSB: down, up, left, right, start, select, B, A.
; Also "c" has new buttons.
ReadJoyPad:
    ld a, $20
    ldh [rP1], a              ; Select direction keys.
    ldh a, [rP1]              ; Wait.
    ldh a, [rP1]              ; Read keys.
    cpl                       ; Invert, so button press becomes 1.
    and $0f                   ; Select lower 4 bits.
    swap a
    ld b, a                   ; Direction key buttons now in upper nibble of b.
    ld a, $10
    ldh [rP1], a              ; Select button keys.
    ldh a, [rP1]              ; Wait.
    ldh a, [rP1]              ; Wait.
    ldh a, [rP1]              ; Wait.
    ldh a, [rP1]              ; Wait.
    ldh a, [rP1]              ; Wait.
    ldh a, [rP1]              ; Read keys.
    cpl                       ; Same procedure as before...
    and $0f
    or b                      ; Button keys now in lower nibble of a.
    ld c, a
    ld a, [JoyPadData]        ; Read old joy pad data.
Jump_000_00d8:                ; TODO: Maybe remove.
    xor c                     ; Get changes from old to new.
    and c                     ; Only keep new buttons pressed.
    ld [JoyPadNewPresses], a  ; Save new joy pad data.
    ld a, c
    ld [JoyPadData], a        ; Save newl pressed buttons.
    ld a, $30
Jump_000_00e3:                ; TODO: Maybe remove.
    ldh [rP1], a              ; Disable selection.
    ret

Jump_000_00e6:
    set 1, [hl]
Jump_000_00e8:
    ld c, $12
    rst $08
    cp $54
    ret nz
    xor a
Jump_000_00ef:
    ld c, $01
    rst $10
    ret
Call_000_00f3:
    rst $38
    rst $38
    rst $38
    ld a, [hl]
    di
    rst $38
    rst $38
    xor a
    rst $38
    rst $38
    rst $38
    rst $08
    rst $18

Boot::
    nop

; $100
Entry::
    jp Main


HeaderLogo::
    db $ce, $ed, $66, $66, $cc, $0d, $00, $0b, $03, $73, $00, $83, $00, $0c, $00, $0d
    db $00, $08, $11, $1f, $88, $89, $00, $0e, $dc, $cc, $6e, $e6, $dd, $dd, $d9, $99
    db $bb, $bb, $67, $63, $6e, $0e, $ec, $cc, $dd, $dc, $99, $9f, $bb, $b9, $33, $3e

HeaderTitle::
    db "JUNGLE BOOK", $00, $00, $00, $00, $00

HeaderNewLicenseeCode::
    db $00, $00

HeaderSGBFlag::
    db $00

HeaderCartridgeType::
    db $01

HeaderROMSize::
    db $02

HeaderRAMSize::
    db $00

HeaderDestinationCode::
    db $01

HeaderOldLicenseeCode::
    db $61

HeaderMaskROMVersion::
    db $00

HeaderComplementCheck::
    db $72

HeaderGlobalChecksum::
    db $a2, $14

MainContinued::
    call StopDisplay
    call ResetWndwTileMap
    call ResetRam
    ld a, 7
    rst 0                       ; Load ROM bank 7.
    call LoadSound0
    call SetUpScreen

Jump_000_0162:
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
    call SetUpInterruptsSimple
:   call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nz, :-                   ; Wait for a few seconds.

VirginStartScreen::
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
:   call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nz, :-                   ; Wait for a few seconds...
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

StartScreen::
    call SoundAndJoypad         ; TODO: Probably something with sound
    ld a, [JoyPadNewPresses]    ; Get new joy pad presses to see if new mode is selected of if we shall start the level.
    push af
    bit BIT_IND_SELECT, a
    jr Z, SkipMode
    bit BIT_IND_SELECT, a
    jr Z, SkipMode
    ld a, [DifficultyMode]      ; If SELECT was pressed, continue here.
    inc a
    and 1                       ; Mod 2
    ld [DifficultyMode], a      ; Toggle practice and normal mode.
    ld hl, $767e                ; Load "NORMAL" string.
    jr Z, :+
    ld l, $87                   ; Load "PRACTICE" string.
  : ld de, $9a2a
    call DrawString

SkipMode::
    pop af
    and BIT_A | BIT_B | BIT_START
    jr z, StartScreen           ; Continue if A, B, or START was pressed.

StartGame::
    call StartTimer
    ld a, 7
    rst 0                       ; Load ROM bank 7
    call FadeOutSong            ; Sets up CurrentSong2 and CurrentSong
    call ResetWndwTileMapLow
    ld a, %11100100
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
    jr nz, jr_000_024b
    cp $09
    jr c, :+                    ; Reached level 10?
    ld a, $cf
    ld [de], a
    inc de
    ld a, $ff
:   add $cf                     ; Draw level number.
    ld [de], a
    inc de
    ld a, ":"
    ld [de], a                  ; Draw ":"

Call_000_0232:
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
    jr jr_000_0260

jr_000_024b:
    ld a, [NextLevel]
    ld [NextLevel2], a
    cp $0a
    jr c, jr_000_025a

Jump_000_0255:
    ld a, $cf
    ld [de], a
    inc de
    xor a

jr_000_025a:
    add $ce
    ld [de], a
    ld de, $9925

jr_000_0260:
    call DrawString
    ld a, 1
    rst 0                       ; Load ROM bank 1
    xor a
    ldh [rSCX], a
    ldh [rSCY], a               ; BG screen = (0,0).
    dec a
    ld [NextLevel], a           ; = $ff
    ld a, 128
    ld [TimeCounter], a         ; = 128
    ld a, [CurrentLevel]
    cp $0b                      ; Level 11?
    jr nZ, :+
    ld a, [MaxDiamondsNeeded]
    ld [NumDiamondsMissing], a
    call UpdateDiamondNumber
:   call SetUpInterruptsSimple
:   call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nZ, :-                   ; Wait for a few seconds...
Jump_000_0290:
    call StartTimer
    call ResetWndwTileMapLow
    ld a, [CurrentLevel]
    inc a
    ld [NextLevel], a
    ld hl, AssetSprites         ; Load sprites of projectiles, diamonds, etc.
    ld de, $8900
    ld bc, $03e0
Jump_000_02a6:
    cp $0c                       ; Next level 12?
    jr nz, :+
    call Call_000_2578
    ld hl, BonusSprites
    ld de, $8a20
    ld bc, $00a0
 :  push af
    ld a, 5
    rst $00                     ; Load ROM bank 5.
    rst $38                     ; Copies sprites into VRAM.
    pop af
    jr z, :+
    push af
    ld a, 1
    rst $00                     ; Load ROM bank 1.
    call TODOFunc
    pop af
    call Call_000_242a
    ld a, 2
    rst $00                     ; Load ROM bank 2.
    call InitStatusWindow
:   ld a, 2
    rst $00                     ; Load ROM bank 2 in case it wasnt loaded.
    call LoadStatusWindowTiles
    ld a, 5
    rst $00                     ; Load ROM bank 5.
    call InitStartPositions     ; Loads positions according to level and checkpoint.
    ld a, 6
    rst $00                     ; Load ROM bank 6.
    ld a, [NextLevel]
    dec a
    add a                       ; a = CurrentLevel * 2; Guess we are accessing some pointer.
    ld b, $00
    ld c, a
    ld hl, $401d
    add hl, bc                  ; hl = $401d + CurrentLevel * 2
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push bc
    call TODOFunc6400           ; Calls $6400
    pop bc
    ld a, 4
    rst $00                     ; Load ROM bank 4.
    call InitBgDataIndices
    ld a, 3
    rst $00                         ; Load ROM bank 3.
    call InitBackgroundTileData     ; Initializes layer 2 and layer 3 background data.
    ld a, [NextLevel]
    cp 12                           ; Next level 12?
    jr nz, jr_000_0311
    ld a, 2
    rst $00                         ; Load ROM bank 2.
    ld hl, CompressedTileData
    ld de, $96e0
    call DecompressTilesIntoVram
jr_000_0311:
    ld a, 1
    rst $00                     ; Load ROM bank 1
    ld hl, BgScrollXLsb
    ld e, [hl]                  ; e = BgScrollXLsb
    inc hl
    ld d, [hl]                  ; d = BgScrollXMsb
    call CalculateXScrolls
    ld hl, BgScrollYLsb
    ld e, [hl]                  ; e = BgScrollYLsb
    inc hl
    ld d, [hl]                  ; d = BgScrollYMsb
    call CalculateYScrolls
    call Call_000_147f
    ld hl, Layer1BgPtrs
    add hl, de
    push hl
    call fcn00014019
    pop hl
    call fcn00014000
    call fcn1408e
    call $5882
    ld a, 3
    rst $00                      ; Load ROM bank 3.
    call Call_000_227e
    ld a, 1
    rst $00                      ; Load ROM bank 1.
    call Call_000_25a6
    xor a                        ; At this point, the background is already fully loaded.
    ld [IsJumping], a                ; Is $0f when flying upwards.
    ld [$c174], a                ; Is $01 when side jump; is $02 when side jump from slope.
    ld [$c173], a                ; I thinks holds the player pose when flying.
    ld [$c175], a                ; Somehow related to upwards momentum.
    ld [InvincibilityTimer], a   ; = 0
    ld [LandingAnimation], a
    ld [$c170], a
    ld [ProjectileFlying], a
    ld [WeaponSelect2], a        ; = 0 (bananas)
    ld [WeaponSelect], a         ; = 0 (bananas)
    ld [$c15b], a
    ld [$c1cd], a
    ld [$c1ce], a
    ld [$c1cf], a
    ld [HeadSpriteIndex], a      ; = 0 (default head)
    ld [$c1f1], a
    ld [$c1f3], a
    ld [$c1f0], a
    ld [$c1ea], a
    ld [$c1eb], a

Call_000_0384:
    dec a
    ld [$c149], a
    ld [$c190], a
    ld [$c15c], a
    ld a, MAX_HEALTH
    ld [CurrentHealth], a
    ld a, [NextLevel]
    ld c, a
    cp 12
    jp z, Jump_000_0422             ; Next level 12?
    xor a
    ld [$c169], a                   ; = 0
    ld [$c1e5], a                   ; = 0
    ld [$c1e6], a                   ; = 0
    ld [PlayerFreeze], a            ; = 0
    ld [$c1c0], a                   ; = 0
    ld [$c1c1], a                   ; = 0
    ld [FirstDigitSeconds], a       ; = 0
    ld [SecondDigitSeconds], a      ; = 0
    ld a, [$c14a]                   ; = 0
    or a
    jr nz, jr_000_03de
    ld a, c
    cp $08                      ; Next level = 8?
    ld a, $01                   ; Only one diamond.
    jr z, .SaveDiamondNum
    ld a, c
    cp $0b
    ld a, $01
    jr z, jr_000_03e8
    ld a, [DifficultyMode]
    or a
    ld a, NUM_DIAMONDS_NORMAL       ; In normal mode 10 diamonds must be found.
    jr z, .SaveDiamondNum
    ld a, NUM_CONTINUES_PRACTICE
    ld [NumContinuesLeft], a
    ld a, NUM_DIAMONDS_PRACTICE     ; In practice only 7 diamonds must be found.
.SaveDiamondNum:
    ld [NumDiamondsMissing], a
    ld [MaxDiamondsNeeded], a
jr_000_03de:
    ld a, [CurrentSong2]
    or $40
    ld [CurrentSong], a
    ld a, MINUTES_PER_LEVEL
jr_000_03e8:
    ld [DigitMinutes], a
    call DrawLivesAndTimeLeft
    call DrawLivesLeft          ; TODO: Why is this called redundantly?
    call UpdateDiamondNumber
    call $4229
    xor a
    ld [CrouchingHeadTilted], a               ; = 0
    ld [$c14a], a               ; = 0
Jump_000_03fe:
    ld c, a
    call $46cb
jr_000_0402:
    call Call_000_1f78
    ld a, [$c190]
    or a
Jump_000_0409:
    jr nz, jr_000_0402
    ld c, $01
    ld a, [NextLevel]
    cp $04
    jr nz, jr_000_041c
    ld a, [CheckpointReached]
    or a
    jr nz, jr_000_041c
    ld c, $ff
jr_000_041c:
    ld a, c
    ld [$c146], a
    jr jr_000_0428
Jump_000_0422:
    ld a, [CurrentSong2]
    ld [CurrentSong], a
jr_000_0428:
    call $4f21
    call UpdateWeaponNumber
    call Call_000_0ba1
    call Call_000_3cf0
    call SetUpInterruptsAdvanced
PauseLoop:
    call WaitForNextPhase
    ld a, [IsPaused]
    or a
    jr z, :+                  ; Jump if game is not paused.
    ld a, 7
    rst 0                     ; Load ROM bank 7.
    call IncrementPauseTimer
    ld a, 1
    rst 0                     ; Load ROM bank 1.
    jr PauseLoop
 :  ld a, [$c1c9]
    or a
    jr z, jr_000_0470
    cp $ff
    jr z, jr_000_0470
    dec a
    ld [$c1c9], a
    jr nz, PauseLoop
    ld a, [CurrentLives]
    or a
    jr z, GameEnded             ; End game if no lives left.
    ld a, [CurrentLevel]
    cp 10
    jp z, Jump_000_0290         ; Jump if Level 10.
    cp 12
    jr z, GameEnded             ; End game if Level 12.
    jp StartGame

jr_000_0470:
    ld a, [JoyPadData]
    and $0f
    cp BIT_START | BIT_SELECT | BIT_A | BIT_B
    jr nz, PauseLoop
    jp MainContinued

; $047c: This is called when the game ends. E.g., no lives left or player decided no to continue.
GameEnded:
    call StartTimer
    ld a, 7
    ld [CurrentSong], a       ; Load game over jingle.
    call ResetWndwTileMapLow
    ld a, $e4
    ldh [rBGP], a             ; Classic colour palette.
    ld a, 2
    rst 0                     ; Load ROM bank 2.
    call LoadFontIntoVram
    ld hl, WellDoneString     ; Load "WELL DONE"
    ld a, [CurrentLevel]
    cp 12
    jr z, jr_000_04b0         ; Level 12?
    ld a, [NextLevel]
    inc a
    jr z, jr_000_04aa
    ld hl, ContinueString     ; Load "CONTINUE?"
    ld a, [NumContinuesLeft]
    or a
    jr nz, jr_000_04ad
jr_000_04aa:
    ld hl, GameOverString     ; Load "GAME OVER"
jr_000_04ad:
    ld [CanContinue], a
jr_000_04b0:
    ld de, $9905
    call DrawString
    xor a
    ldh [rSCX], a             ; = 0
    ldh [rSCY], a             ; = 0
    ld [TimeCounter], a       ; = 0
    dec a
    ld [NextLevel], a         ; = $ff
    ld a, $0b
Call_000_04c4:
    ld [ContinueSeconds], a
    call SetUpInterruptsSimple
ContinueLoop:                           ; $04ca
    call SoundAndJoypad
    ld a, [CanContinue]
    or a
Call_000_04d1:                          ; TODO: maybe remove
Jump_000_04d1:                          ; TODO: maybe remove
    jr z, jr_000_04f9                   ; Jump if we cannot continue.
    ld a, 1
    rst $00                             ; Load ROM bank 1.
    ld a, [JoyPadData]
    and BIT_START | BIT_A | BIT_B
    jr nz, UseContinue2                 ; Continue if A, B, or START was pressedn.
    ld a, [TimeCounter]
    and $3f
    ld [TimeCounter], a
    jr nz, ContinueLoop                 ; Wait a second.
    ld a, [ContinueSeconds]
    dec a
    ld [ContinueSeconds], a             ; Decrease number of seconds left to continue.
    jr z, GameEnded                     ; If zero end the game.
    ld de, $990f
    dec a
    call DrawNumber                     ; Draw number of seconds left.
    jr ContinueLoop

jr_000_04f9:
    ld a, [TimeCounter]
    or a
    jr nz, ContinueLoop
    ld a, [CurrentLevel]
    cp 12
    jr nz, UseContinue                   ; Jump if current level is not 12.
    call StartTimer
    call DrawCreditScreenString
    call SetUpInterruptsSimple

jr_000_050f:
    call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nz, jr_000_050f

UseContinue::
    jp MainContinued

; $051b: Use a continue.
UseContinue2:
    ld a, [NumContinuesLeft]
    dec a
    ld [NumContinuesLeft], a            ; Decrease number of continues.
    xor a
    ld [$c14a], a                       ; = 0
    ld [CheckpointReached], a           ; = 0
    ld [CanContinue], a                 ; = 0
    ld hl, CurrentScore1
    ld [hl+], a                         ; CurrentScore1 = 0
    ld [hl+], a                         ; CurrentScore2 = 0
    ld [hl], a                          ; CurrentScore3 = 0
    ld hl, CurrentNumDoubleBanana
    ld [hl+], a                         ; CurrentNumDoubleBanana = 0
    ld [hl+], a                         ; CurrentNumBoomerang = 0
    ld [hl+], a                         ; CurrentNumStones = 0
    ld [hl], a                          ; CurrentSecondsInvincibility = 0
    ld a, NUM_LIVES
    ld [CurrentLives], a                ; CurrentLives = 6
    jp StartGame

Jump_000_0541:
    push af
    ld a, [$7fff]
    push af
    push bc
    push de
    push hl
    ld a, [$c104]
    or a
    jp nz, Jump_000_0688

    inc a
    ld [$c104], a
    rst $00
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
    bit 7, a
    jr z, jr_000_057f

    xor a
    ldh [rSCX], a               ; = 0
    ldh [rSCY], a               ; = 0
    ldh a, [rLCDC]
    and $f5
    ldh [rLCDC], a
    jp Jump_000_0679


jr_000_057f:
    ldh a, [rLCDC]
    bit 7, a
    jp z, Jump_000_0679

    call Call_000_0767
    call Call_000_1f4a
    call $5372
    call ReadJoyPad
    ld a, [IsPaused]
    or a
    jp nz, CheckForPause

    call $4184
    ld a, $07
    rst $00
    call $4003
    ld a, $01
    rst $00
    ld a, [PlayerFreeze]
    or a
    jr nz, jr_000_060d

    ld a, [$c1c9]
    or a
    jr nz, jr_000_060d

    ld a, [JoyPadData]
    push af
    bit 4, a
    call nz, Call_000_07e2
    pop af
    push af
    bit 5, a
    call nz, Call_000_08cf
    pop af
    push af
    bit 6, a
    call nz, Call_000_0c28
    pop af
    push af
    bit 7, a
    call nz, Call_000_0e90
    ld a, $07
    rst $00

Call_000_05d2:
    call $6800
    ld a, $01

Jump_000_05d7:
    rst $00
    ld a, [$c155]
    ld d, a
    and $01
    ld c, a
    pop af
    push af
    ld [$c155], a
    ld b, a
    and $01
    xor c
    push de
    call nz, $47f5
    pop af
    and $02
    ld c, a
    pop af
    push af
    ld b, a
    and $02
    xor c
    call nz, $423d
    pop af
    push af
    call $4e83
    pop af
    and $04
    call nz, Call_000_0fb9
    call $42b1
    call Call_000_1889
    call Call_000_1cdb

jr_000_060d:
    call Call_000_0f80
    call $5f8f
    call $58e5
    call $4bf3
    call Call_000_15be
    call Call_000_0f42
    call Call_000_0ffa
    call Call_000_122d
    call $56f6
    call $4645
    call $495a
    call $4a49
    call Call_000_0cfb
    call Call_000_0ba1
    call $4fd4
    call $50ed
    call Call_000_2781
    call Call_000_3cf0
    call Call_000_25a6
    call Call_000_3cd4

; $0649: TODO: Something with paus.
CheckForPause:
    ld a, [JoyPadData]
    cp BIT_START
    jr nz, jr_000_0679
    ld a, [JoyPadNewPresses]
    cp BIT_START
    jr nz, jr_000_0676
    ld a, [IsPaused]
    xor $01
    ld [IsPaused], a            ; Toggle pause.
    jr nz, jr_000_0669
    ld a, [CurrentSong2]
    ld [CurrentSong], a
    jr jr_000_0679

jr_000_0669:
    ld a, 7
    rst $00                     ; Load ROM bank 7.
    xor a
    ld [ColorToggle], a         ; = 0
    ld [PauseTimer], a          ; = 0
    call LoadSound0

jr_000_0676:
    call Call_000_0ba1

Jump_000_0679:
jr_000_0679:
    xor a
    ld [$c104], a       ; = 0
    inc a
    ld [PhaseTODO], a       ; = 1

jr_000_0681:
    pop hl
    pop de
    pop bc
    pop af
    rst $00
    pop af
    reti

Jump_000_0688:
    call Call_000_0767
    ld a, $07
    rst $00
    call $4003
    jr jr_000_0681

Jump_000_0693:
    push af
    push bc
    push de
    ldh a, [rLYC]
    cp $76
    jp nc, Jump_000_071c

    ld a, [NextLevel]
    ld d, a
    call Call_000_074b
    ld a, d
    cp $04
    jr z, jr_000_06f6

    ldh a, [rLCDC]
    or $08
    ldh [rLCDC], a
    ld a, [$c12b]
    ldh [rSCX], a
    ld a, [$c13a]
    ld b, a
    ld a, [$c105]
    ld c, a
    or a
    jr z, jr_000_06c1

    ld b, $00

jr_000_06c1:
    ld a, [$c132]
    sub b
    ldh [rSCY], a
    ld a, c
    or a

Call_000_06c9:
    jr nz, jr_000_06d9

    ld a, [$c1e9]
    or a
    jr z, jr_000_06d9

    dec a
    ld [$c1e9], a
    ld a, $13
    ldh [rBGP], a

jr_000_06d9:
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, d
    cp $05
    jr nz, jr_000_06f6

    ld b, $00
    ld a, [$c105]
    or a
    jr z, jr_000_06ee

    cp $77
    jr nz, jr_000_06f6

jr_000_06ee:
    ld a, $ef
    sub c
    cp $77
    jr c, jr_000_06f8

    ld b, a

jr_000_06f6:
    ld a, $77

jr_000_06f8:
    ldh [rLYC], a
    ld [$c105], a
    cp $77
    jr nz, jr_000_0747

    ld a, [NextLevel]
    cp $04
    jr z, jr_000_0710

    cp $05
    jr nz, jr_000_0747

    ld a, b
    or a

Call_000_070e:
    jr nz, jr_000_0747

jr_000_0710:
    ldh a, [rLCDC]
    and $fd
    ldh [rLCDC], a
    ld a, $1b
    ldh [rBGP], a
    jr jr_000_0747

Jump_000_071c:
jr_000_071c:
    ldh a, [rLY]
    cp $77
    jr nz, jr_000_071c

    call Call_000_074b
    xor a
    ldh [rSCX], a
    ld [$c105], a
    ld a, $b4
    ldh [rSCY], a
    ldh a, [rLCDC]
    and $fd
    or $09
    ldh [rLCDC], a
    ld a, [IsPaused]
    or a
    jr z, jr_000_0743

    ld a, [ColorToggle]
    or a
    jr z, jr_000_0747

jr_000_0743:
    ld a, %11100100
    ldh [rBGP], a

jr_000_0747:
    pop de
    pop bc
    pop af
    reti


Call_000_074b:
jr_000_074b:
    ldh a, [rSTAT]
    and $03
    jr nz, jr_000_074b

    ret

; $0752 : This function is called by the timer interrupt ~60 times a seconds.
TimerIsr:
    push af
    ld a, [OldRomBank]
    push af
    ld a, 7
    rst 0                     ; Load ROM bank 7.
    push bc
    push de
    push hl
    call $4003
    pop hl
    pop de
    pop bc
    pop af
    rst $00
    pop af
    reti

Call_000_0767:
    ldh a, [rLCDC]
    and $f7
    or $02
    ldh [rLCDC], a
    ld a, $1b
    ldh [rBGP], a
    ld a, [BgScrollXLsb]
    ldh [rSCX], a
    ld a, [$c13c]
    ld c, a
    ld a, [BgScrollYLsb]
    sub c
    ldh [rSCY], a
    ld c, a
    ld a, [BgScrollYMsb]
    ld b, a
    ld a, [NextLevel]
    cp $03
    jr z, jr_000_07b0

    cp $04
    jr z, jr_000_07a6

    cp $05
    jr nz, jr_000_07b9

    ld a, b
    cp $03
    jr nz, jr_000_07b9

    ld a, $df
    sub c
    jr c, jr_000_07b9

    cp $78
    jr c, jr_000_07bb

    jr jr_000_07b9

jr_000_07a6:
    ld a, b
    cp $01
    jr nz, jr_000_07b9

    ld a, $ef
    sub c
    jr jr_000_07b5

jr_000_07b0:
    ld a, $1f
    sub c
    jr nc, jr_000_07b9

jr_000_07b5:
    cp $78
    jr c, jr_000_07bb

jr_000_07b9:
    ld a, $77

jr_000_07bb:
    ldh [rLYC], a
    ld a, [$c13b]
    ld [$c13a], a
    ld a, [$c129]
    ld [$c12b], a
    ld a, [$c12a]
    ld [$c12c], a
    ld c, $18
    ld a, [NextLevel]
    cp $03
    jr z, jr_000_07da

    ld c, $d8

jr_000_07da:
    ld a, [BgScrollYLsb]
    sub c
    ld [$c132], a
    ret


Call_000_07e2:
Jump_000_07e2:
    ld a, [$c15b]
    cp $01
    jr nz, jr_000_07fa

    ld a, $01
    ld [$c146], a
    ld [$c147], a
    ld a, [$c164]
    cp $04
    ret c

    jp $4bb9


jr_000_07fa:
    and $01
    ret nz

    ld a, [$c169]
    and $7f
    jp nz, Jump_000_09c9

    ld a, [$c1dc]
    or a

Jump_000_0809:
    ret nz

    ld a, [$c1df]
    or a
    ret nz

    ld a, [$c17f]
    and $0f
    ret nz

    ld a, [$c175]
    or a
    ret nz

Jump_000_081a:
    ld a, $01
    ld [$c146], a

Call_000_081f:
    ld a, [LandingAnimation]

Call_000_0822:
    dec a
    and $80
    ret z

    ld a, [$c173]
    cp $20
    ret nc

    ld a, [$c177]
    or a
    ret nz

    ld a, [LookingUp]
    or a
    ret nz

    ld a, [ProjectileFlying]

Jump_000_0839:
    or a
    ret nz

    ld a, [JoyPadData]
    and $c0

Call_000_0840:
    call nz, $468c
    ret nz

    ld a, [$c157]
    or a
    jr nz, jr_000_0855

    ld a, [$c156]

Call_000_084d:
    cp $02
    jr c, jr_000_085e

    cp $04
    jr nc, jr_000_085e

jr_000_0855:
    ld c, $04
    ld a, [TimeCounter]
    rra
    jp c, Jump_000_09b8

Call_000_085e:
Jump_000_085e:
jr_000_085e:
    ld a, [$c14d]
    ld e, a
    ld a, [$c14e]
    ld d, a
    ld a, [BgScrollXLsb]
    ld c, a
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    cp d
    jr nz, jr_000_0879

    ld a, l
    cp e
    jp nc, $468c

jr_000_0879:
    ld a, l
    sub c
    cp $94
    jr nc, jr_000_08c5

    ld a, [$c17d]
    inc a
    ld d, a
    jr nz, jr_000_0887

    inc hl

jr_000_0887:
    inc hl
    ld a, d
    or a
    jr z, jr_000_08a9

    ld a, [$c174]
    cp $03
    jr z, jr_000_08a6

    ld a, [IsJumping]
    or a
    jr z, jr_000_08a9

    ld a, [$c169]
    or a
    jr nz, jr_000_08a6

    ld a, [$c174]
    cp $02
    jr z, jr_000_08a9

jr_000_08a6:
    ld d, $00
    inc hl

jr_000_08a9:
    ld a, h
    ld [PlayerPositionXMsb], a
    ld a, l
    ld [PlayerPositionXLsb], a
    sub c
    cp $28
    jr c, jr_000_08c5

    ld a, d
    or a
    jr nz, jr_000_08c2

    ld a, [BgScrollXLsb]
    and $01
    call z, Call_000_100a

jr_000_08c2:
    call Call_000_100a

jr_000_08c5:
    ld a, [$c149]
    inc a
    ret z

    ld c, $06
    jp Jump_000_09b8


Call_000_08cf:
    ld a, [$c15b]
    cp $01
    jr nz, jr_000_08e7

    ld a, $ff
    ld [$c146], a
    ld [$c147], a
    ld a, [$c164]
    cp $04
    ret c

    jp $4bb9


jr_000_08e7:
    and $01
    ret nz

    ld a, [$c169]
    and $7f
    jp nz, Jump_000_0b07

    ld a, [$c1dc]
    or a
    ret nz

    ld a, [$c1df]
    or a
    ret nz

    ld a, [$c17f]
    and $0f
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, $ff
    ld [$c146], a
    ld a, [LandingAnimation]
    dec a
    and $80
    ret z

    ld a, [$c173]
    cp $20
    ret nc

    ld a, [$c177]
    or a
    ret nz

    ld a, [LookingUp]
    or a
    ret nz

    ld a, [ProjectileFlying]
    or a
    ret nz

    ld a, [JoyPadData]
    and $c0
    call nz, $468c
    ret nz

    ld a, [$c157]
    or a
    jr nz, jr_000_0942

    ld a, [$c156]
    cp $0a
    jr c, jr_000_094a

    cp $0c
    jr nc, jr_000_094a

jr_000_0942:
    ld c, $04
    ld a, [TimeCounter]
    rra
    jr c, jr_000_09b8

Call_000_094a:
Jump_000_094a:
jr_000_094a:
    ld a, [$c14b]
    ld e, a
    ld a, [$c14c]
    ld d, a
    ld a, [BgScrollXLsb]
    ld c, a
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    cp d
    jr nz, jr_000_0965

    ld a, l
    cp e
    jp c, $468c

jr_000_0965:
    ld a, l
    sub c
    cp $0c
    jr c, jr_000_09b1

    ld a, [$c17d]
    inc a
    ld d, a
    jr nz, jr_000_0973

    dec hl

jr_000_0973:
    dec hl
    ld a, d
    or a
    jr z, jr_000_0995

    ld a, [$c174]
    cp $03
    jr z, jr_000_0992

    ld a, [IsJumping]
    or a
    jr z, jr_000_0995

    ld a, [$c169]

Jump_000_0988:
    or a
    jr nz, jr_000_0992

    ld a, [$c174]
    cp $02
    jr z, jr_000_0995

jr_000_0992:
    ld d, $00
    dec hl

jr_000_0995:
    ld a, h
    ld [PlayerPositionXMsb], a
    ld a, l
    ld [PlayerPositionXLsb], a
    sub c
    cp $78
    jr nc, jr_000_09b1

    ld a, d
    or a
    jr nz, jr_000_09ae

    ld a, [BgScrollXLsb]
    and $01
    call z, Call_000_110a

jr_000_09ae:
    call Call_000_110a

jr_000_09b1:
    ld a, [$c149]
    inc a
    ret z

    ld c, $06

Jump_000_09b8:
jr_000_09b8:
    ld a, [$c17f]
    and $0f
    ret nz

    ld a, [$c175]
    or a
    ret nz

    call $478d
    jp $44a5


Jump_000_09c9:
    or a
    ret z

    cp $02
    jr z, jr_000_0a16

    ld a, [$c16a]
    cp $0f
    jr c, jr_000_09e5

    ld b, $e0
    ld c, $14
    call Call_000_15a0
    jr c, jr_000_09e5

    ld a, [$c146]
    and $80
    ret z

jr_000_09e5:
    ld a, [$c15e]
    cp $03
    ret nz

    ld a, [$c161]
    or a
    jr z, jr_000_09fb

    ld a, [$c160]
    dec a
    ret nz

    ld [$c161], a
    jr jr_000_0a00

jr_000_09fb:
    ld a, [$c160]
    inc a
    ret nz

jr_000_0a00:
    ld a, $02
    ld [$c169], a
    ld a, $01
    ld [$c15f], a
    xor a
    ld [$c15e], a
    ld [$c162], a
    inc a
    ld [$c146], a
    ret


jr_000_0a16:
    ld a, [$c146]
    dec a
    ret nz

Jump_000_0a1b:
    ld a, [$c15f]
    dec a
    ld [$c15f], a
    ret nz

    ld a, $06
    ld [$c15f], a
    ld a, [$c16a]
    cp $0b
    jr c, jr_000_0a58

    ld b, $e0
    ld c, $14
    call Call_000_15a0
    jr c, jr_000_0a55

    ld a, [$c16a]
    cp $0f
    jr nz, jr_000_0a4b

    ld a, $01
    ld [$c169], a
    ld [$c160], a
    ld [$c15e], a
    ret


jr_000_0a4b:
    ld c, a
    ld a, $0f
    sub c
    add a
    add a
    ld e, a
    ld a, c
    jr jr_000_0aab

jr_000_0a55:
    ld a, [$c16a]

jr_000_0a58:
    ld e, $14

Jump_000_0a5a:
    ld c, a
    add a
    add c
    ld b, $00
    ld c, a
    ld hl, $620f
    add hl, bc
    ld a, [$c162]
    ld d, a
    ld a, [$c15e]
    inc a
    cp $06
    jr c, jr_000_0a94

    ld a, d
    xor $06
    ld d, a
    ld [$c162], a
    ld a, e
    ld [$c16d], a
    ld c, $02
    rst $08
    ld [$c16e], a
    ld a, [$c16a]
    bit 7, e
    jr nz, jr_000_0a8c

    add $05
    jr jr_000_0a8e

jr_000_0a8c:
    sub $05

Jump_000_0a8e:
jr_000_0a8e:
    and $0f
    ld [$c16a], a
    xor a

jr_000_0a94:
    ld [$c15e], a
    ld c, a
    add $2c
    add d
    ld [HeadSpriteIndex], a
    ld a, c
    sub $04
    ld c, a
    ld a, $00
    jr c, jr_000_0aa7

    rst $08

jr_000_0aa7:
    ld [$c16b], a
    ret


Jump_000_0aab:
jr_000_0aab:
    ld c, a
    add a
    add c
    ld b, $00
    ld c, a
    ld hl, $620f
    add hl, bc
    ld a, [$c162]
    ld d, a
    ld a, [$c15e]
    inc a
    cp $06
    jr c, jr_000_0aeb

    ld a, d
    xor $06
    ld d, a
    ld [$c162], a
    ld a, e
    ld [$c16d], a
    ld hl, $623f
    ld a, [$c16a]
    dec a
    cp $0a
    jr c, jr_000_0adb

    sub $0a
    xor $03

jr_000_0adb:
    ld c, a
    rst $08
    ld [$c16e], a

Jump_000_0ae0:
    xor a
    bit 7, e
    jr nz, jr_000_0ae7

    ld a, $0f

jr_000_0ae7:
    ld [$c16a], a
    xor a

jr_000_0aeb:
    ld [$c15e], a
    ld c, a
    add $2c
    add d
    ld [HeadSpriteIndex], a
    ld a, c
    sub $04
    ld c, a
    ld a, $00
    jr c, jr_000_0afe

    rst $08

jr_000_0afe:
    ld [$c16b], a

Call_000_0b01:
    ld a, $03
    ld [$c15f], a
    ret


Jump_000_0b07:
    or a
    ret z

    cp $02
    jr z, jr_000_0b53

    ld a, [$c16a]
    or a
    jr nz, jr_000_0b22

    ld b, $e0
    ld c, $ec
    call Call_000_15a0
    jr c, jr_000_0b22

    ld a, [$c146]
    and $80
    ret nz

jr_000_0b22:
    ld a, [$c15e]
    cp $03
    ret nz

    ld a, [$c161]

Call_000_0b2b:
    or a
    jr z, jr_000_0b38

    ld a, [$c160]
    inc a
    ret nz

    ld [$c161], a
    jr jr_000_0b3d

jr_000_0b38:
    ld a, [$c160]
    dec a
    ret nz

jr_000_0b3d:
    ld a, $02
    ld [$c169], a
    ld a, $01
    ld [$c15f], a
    xor a
    ld [$c162], a
    ld [$c15e], a
    dec a
    ld [$c146], a
    ret


jr_000_0b53:
    ld a, [$c146]
    inc a
    ret nz

Jump_000_0b58:
    ld a, [$c15f]
    dec a
    ld [$c15f], a
    ret nz

    ld a, $06
    ld [$c15f], a
    ld a, [$c16a]
    cp $05
    jr nc, jr_000_0b98

    ld b, $e0
    ld c, $ec
    call Call_000_15a0
    jr c, jr_000_0b95

    ld a, [$c16a]
    or a
    jr nz, jr_000_0b8b

    ld a, $01
    ld [$c169], a
    ld a, $04
    ld [$c15e], a
    ld a, $ff
    ld [$c160], a
    ret


jr_000_0b8b:
    ld c, a
    add a
    add a
    cpl
    inc a
    ld e, a
    ld a, c
    jp Jump_000_0aab


jr_000_0b95:
    ld a, [$c16a]

jr_000_0b98:
    ld e, $ec
    ld c, a
    ld a, $0f
    sub c
    jp Jump_000_0a5a


Call_000_0ba1:
    ld a, [$c1df]
    or a
    ret nz

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
    jr z, jr_000_0bd5

    ld a, c
    push af
    cp $26
    call c, Call_000_110a
    pop af
    cp $7a
    call nc, Call_000_100a

jr_000_0bd5:
    ld a, [$c190]
    inc a
    ret z

    ld a, [InvincibilityTimer]
    or a
    jr z, jr_000_0c14

    ld c, a
    ld a, [TimeCounter]
    and $03
    ld a, c
    jr nz, jr_000_0bed

    dec a
    ld [InvincibilityTimer], a

jr_000_0bed:
    cp $10
    jr nc, jr_000_0c0b

    ld c, a
    ld a, [WeaponSelect]
    cp $04
    jr nz, jr_000_0c06

    ld a, [CurrentSecondsInvincibility]
    or a
    jr z, jr_000_0c06

    ld a, $ff
    ld [InvincibilityTimer], a
    jr jr_000_0c0b

jr_000_0c06:
    ld a, c
    bit 1, a

Jump_000_0c09:
    jr jr_000_0c0d

Call_000_0c0b:
jr_000_0c0b:
    bit 0, a

jr_000_0c0d:
    jr z, jr_000_0c13

    ld a, $80
    jr jr_000_0c14

jr_000_0c13:
    xor a

jr_000_0c14:
    ld c, a
    ld a, [$c1ba]
    and $10

Jump_000_0c1a:
    or c
    ld [$c18a], a
    ld a, $02

Call_000_0c20:
    rst $00
    call $4000
    ld a, $01
    rst $00
    ret


Call_000_0c28:
    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [$c169]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld b, $ff
    call Call_000_1660
    ld a, [$c156]
    bit 6, a
    jp z, Jump_000_0da5

    and $03
    jr z, jr_000_0c61

    dec a
    jr nz, jr_000_0c57

    ld a, [PlayerPositionXLsb]
    and $0f
    cp $08
    jp nc, Jump_000_0da5

    jr jr_000_0c61

jr_000_0c57:
    ld a, [PlayerPositionXLsb]
    and $0f
    cp $08
    jp c, Jump_000_0da5

jr_000_0c61:
    ld a, [$c155]
    and $40
    ret nz

    ld a, [$c1df]
    or a
    ret nz

Jump_000_0c6c:
    ld hl, $6243
    ld b, $04
    ld c, $00
    ld a, [NextLevel]
    cp $02
    jr z, jr_000_0c86

    ld hl, $6267
    cp $06
    jr nz, jr_000_0c86

    ld hl, $624b
    ld b, $0e

jr_000_0c86:
    ld a, [hl+]
    cp e
    jr nz, jr_000_0c8e

    ld a, [hl]
    cp d
    jr z, jr_000_0c94

jr_000_0c8e:
    inc hl
    inc c
    dec b
    jr nz, jr_000_0c86

    ret


jr_000_0c94:
    ld a, [NextLevel]
    ld hl, $626f
    cp $02
    jr z, jr_000_0ca8

    ld hl, $6293
    cp $06
    jr z, jr_000_0ca8

    ld hl, $6311

jr_000_0ca8:
    ld a, c
    add a
    add a
    add a
    add c
    ld c, a
    ld b, $00
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld d, a
    ld a, [hl+]
    ld [$c138], a
    ld a, [hl+]
    ld [$c139], a
    ld a, [hl+]
    ld [PlayerPositionXLsb], a
    ld a, [hl+]
    ld [PlayerPositionXMsb], a
    ld a, [hl+]
    ld [PlayerPositionYLsb], a
    ld a, [hl+]
    ld [PlayerPositionYMsb], a
    ld a, [hl]
    ld [$c1df], a
    ld h, d
    ld l, e
    ld a, h
    or l
    jr z, jr_000_0ce5

    ld bc, $0024
    ld a, [$c146]
    and $80
    jr z, jr_000_0ce4

    ld bc, $ffd0

jr_000_0ce4:
    add hl, bc

jr_000_0ce5:
    ld a, l
    ld [$c127], a
    ld a, h
    ld [$c128], a
    ld hl, $c000
    ld b, $18
    call MemsetZero2
    ld a, EVENT_SOUND_ITEM_COLLECTED
    ld [EventSound], a
    ret


Call_000_0cfb:
    ld a, [$c1df]

Call_000_0cfe:
    or a
    ret z

    ld c, a
    and $88
    jr z, jr_000_0d32

    call Call_000_0d1d
    ld a, c
    and $0f
    ret z

    ld b, $04

jr_000_0d0e:
    call Call_000_0d5f
    ret z

    push bc
    call Call_000_110a
    pop bc
    jr z, jr_000_0d71

    dec b
    jr nz, jr_000_0d0e

    ret


Call_000_0d1d:
    ld a, c
    and $f0
    ret z

    ld b, $04

jr_000_0d23:
    call Call_000_0d82
    ret z

    push bc
    call Call_000_134c
    pop bc
    jr z, jr_000_0d94

    dec b
    jr nz, jr_000_0d23

    ret


jr_000_0d32:
    call Call_000_0d4a
    ld a, c
    and $0f
    ret z

    ld b, $04

jr_000_0d3b:
    call Call_000_0d5f

Call_000_0d3e:
    ret z

    push bc
    call Call_000_100a
    pop bc
    jr z, jr_000_0d71

    dec b
    jr nz, jr_000_0d3b

    ret


Call_000_0d4a:
    ld a, c
    and $f0
    ret z

    ld b, $04

jr_000_0d50:
    call Call_000_0d82
    ret z

    push bc
    call Call_000_123d
    pop bc
    jr z, jr_000_0d94

    dec b
    jr nz, jr_000_0d50

    ret


Call_000_0d5f:
    ld a, [BgScrollXLsb]
    ld d, a
    ld a, [$c127]
    cp d
    ret nz

    ld a, [BgScrollXMsb]
    ld d, a
    ld a, [$c128]
    cp d
    ret nz

jr_000_0d71:
    ld a, [$c1df]
    and $f0
    ld [$c1df], a
    jr nz, jr_000_0d80
    ld a, $05
    ld [EventSound], a

jr_000_0d80:
    xor a
    ret


Call_000_0d82:
    ld a, [BgScrollYLsb]
    ld d, a
    ld a, [$c138]
    cp d
    ret nz

    ld a, [BgScrollYMsb]
    ld d, a
    ld a, [$c139]
    cp d
    ret nz

jr_000_0d94:
    ld a, [$c1df]
    and $0f
    ld [$c1df], a
    jr nz, jr_000_0da3
    ld a, $05
    ld [EventSound], a

jr_000_0da3:
    xor a
    ret


Jump_000_0da5:
    ld a, [$c15b]
    and $01
    jp z, $452d

    ld a, [JoyPadData]
    and $30
    ret nz

    ld hl, $c167
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld d, h
    ld e, l
    call TrippleRotateShiftRightHl
    ld a, [$c15d]
    or a
    jr z, jr_000_0dc9

    dec a
    cp l
    jp nc, $4825

jr_000_0dc9:
    ld a, [$c164]
    cp $03
    jr nc, jr_000_0de7

    ld a, [$c15b]
    dec a
    jr z, jr_000_0ddb

    ld a, $05
    ld [$c15b], a

jr_000_0ddb:
    ld a, [$c165]
    ld [PlayerPositionXLsb], a
    ld a, [$c166]
    ld [PlayerPositionXMsb], a

jr_000_0de7:
    ld hl, $c167
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    or a
    jr nz, jr_000_0df7

    ld a, l
    cp $24
    jp c, $47de

jr_000_0df7:
    dec hl
    ld a, h
    ld [$c168], a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [$c167], a
    push hl
    sub c
    cp $48
    jr nc, jr_000_0e0d

    call Call_000_123d

jr_000_0e0d:
    call Call_000_0e59
    ld c, $01
    pop hl
    ld a, [$c15b]

Jump_000_0e16:
    cp $03
    jp z, Jump_000_0f2a

    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    jp Jump_000_0f2a


Call_000_0e26:
    ld a, [BgScrollYLsb]
    add $28
    ld e, a
    ld a, [BgScrollYMsb]
    adc $00
    ld d, a
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    cp d
    jr nz, jr_000_0e3f

    ld a, l
    cp e
    ret c

jr_000_0e3f:
    dec hl
    ld a, h
    ld [PlayerPositionYMsb], a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [PlayerPositionYLsb], a
    sub c
    cp $48
    jr nc, jr_000_0e54

    call Call_000_123d

jr_000_0e54:
    ld c, $01
    jp Jump_000_0f2a


Call_000_0e59:
    ld hl, $c167
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    and $07
    srl a
    srl a
    ld e, a
    ld bc, $ffe0
    add hl, bc
    call TrippleRotateShiftRightHl
    ld d, l
    ld a, [$c15d]
    ld c, a
    ld a, d
    sub c
    jr nc, jr_000_0e79

    xor a
    jr jr_000_0e81

jr_000_0e79:
    add a
    or e
    cp $10
    jr c, jr_000_0e81

    ld a, $0f

jr_000_0e81:
    ld [$c164], a
    ld a, [$c15b]
    cp $01
    ret z

    and $04
    ret nz

    jp $5181


Call_000_0e90:
    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [$c169]
    or a
    ret nz

    ld a, [$c1dc]
    or a
    ret nz

    ld a, [ProjectileFlying]
    or a
    ret nz

    ld a, [$c17f]
    and $0f
    ret nz

    ld b, $04
    call Call_000_1660
    ld a, [$c156]
    or a
    jp nz, $4584

    ld a, [JoyPadData]
    and $30
    ret nz

    ld a, [$c15b]
    rra
    ret nc

    ld hl, $c167
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call TrippleRotateShiftRightHl
    ld a, [$c15d]
    add $0c
    cp l
    jr nz, jr_000_0eda

    ld a, [$c15b]
    dec a
    ret nz

    jp $47e4


jr_000_0eda:
    ld hl, $c167
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    ld a, h
    ld [$c168], a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [$c167], a
    push hl
    sub c
    cp $58
    jr c, jr_000_0ef6

    call Call_000_134c

jr_000_0ef6:
    call Call_000_0e59
    ld c, $ff
    pop hl
    ld a, [$c15b]
    cp $03
    jr z, jr_000_0f2a

    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    jr jr_000_0f2a

Call_000_0f0d:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    ld a, h
    ld [PlayerPositionYMsb], a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [PlayerPositionYLsb], a
    sub c
    cp $50
    jr c, jr_000_0f28

    call Call_000_134c

jr_000_0f28:
    ld c, $ff

Jump_000_0f2a:
jr_000_0f2a:
    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [IsJumping]
    or a

Call_000_0f33:
    ret nz

    ld a, [$c15b]
    and $03
    cp $01
    ret nz

    call $47de
    jp $44f6


Call_000_0f42:
    ld a, [$c1df]
    or a
    ret nz

    ld a, [LookingUp]
    or a
    jr nz, jr_000_0f60

    ld a, [BgScrollYLsb]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c
    cp $38
    jp c, Jump_000_123d

    cp $60
    ret c

    jp Jump_000_134c


jr_000_0f60:
    and $80
    jr z, jr_000_0f72

    ld a, [BgScrollYLsb]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c
    cp $70
    ret nc

    jp Jump_000_123d


jr_000_0f72:
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c
    cp $28
    ret c

    jp Jump_000_134c


Call_000_0f80:
    ld a, [$c15b]
    cp $03
    ret z

    ld a, [IsJumping]
    or a
    ret nz

    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [$c1df]
    or a
    ret nz

    ld a, [$c17f]
    and $0f
    ret nz

    ld a, [BgScrollXLsb]
    ld c, a
    ld a, [PlayerPositionXLsb]
    sub c
    ld b, a
    ld a, [$c146]
    ld c, a
    ld a, b
    bit 7, c
    jr z, jr_000_0fb3

    cp $78
    ret nc

    jp Jump_000_110a


jr_000_0fb3:
    cp $28
    ret c

    jp Jump_000_100a


Call_000_0fb9:
    ld a, $02
    rst $00
    call $7592
    ld a, $01
    rst $00
    ret


Jump_000_0fc3:
    ld a, $02
    rst $00
    xor a
    call $75a7
    ld a, $01
    rst $00
    ret

; $fce: Updates displayed weapon number and updates WeaponSelect2.
HandleNewWeapon::
    ld a, 1
    rst $00                       ; Load ROM bank 1.
    call UpdateWeaponNumber
    ld a, [WeaponSelect]
    ld c, a
    cp WEAPON_MASK
    jr z, MaskSelected            ; Jump if mask selected.
    or a
    jr z, UpdateWeaponSelect2     ; Jump if banana selected.
    ld a, [hl]                    ; Get number of projectiles left.
    or a
    jr z, UpdateWeaponSelect2     ; Jump if zero projectiles left.
    ld a, c
UpdateWeaponSelect2:
    ld [WeaponSelect2], a         ; = weapon number if projectiles; = 0 if no projectiles left or mask selected.
    ld a, c
    or a
    ret nz
    ld [InvincibilityTimer], a    ; = 0
    ret

MaskSelected:
    ld a, [hl]
    or a
    jr z, UpdateWeaponSelect2

Call_000_0ff2:
    ld a, $ff
    ld [InvincibilityTimer], a
    xor a
    jr UpdateWeaponSelect2

Call_000_0ffa:
    ld a, [$c1c0]
    or a
    ret z

    ld c, a
    ld a, [BgScrollXLsb]
    cp c
    ret z

    jp nc, Jump_000_110f

    jr jr_000_100f

Call_000_100a:
Jump_000_100a:
    ld a, [$c1c0]
    or a
    ret nz

jr_000_100f:
    ld hl, $c1d0
    ld c, [hl]
    inc hl
    ld b, [hl]
    ld hl, BgScrollXLsb
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, d

Call_000_101c:
    cp b
    jr nz, jr_000_1022

    ld a, e
    cp c
    ret z

jr_000_1022:
    inc de
    ld a, e
    and $07
    jr z, jr_000_102c

    ld [hl], d
    dec hl
    ld [hl], e
    ret


jr_000_102c:
    ld a, [$c1cd]
    or a
    ret nz

    inc a
    ld [$c1cd], a
    ld [hl], d
    dec hl
    ld [hl], e
    call CalculateXScrolls
    ld hl, $c117
    ld a, [hl+]

Call_000_103f:
    ld h, [hl]
    ld l, a
    ld bc, $000a
    add hl, bc
    srl h
    rr l
    ld bc, Layer1BgPtrs
    add hl, bc
    ld a, [LevelWidthDiv16]
    ld b, $00

Jump_000_1052:
    ld c, a
    ld a, [$c11b]
    and $01
    xor $01
    ld d, a
    ld a, [$c11c]
    or a
    jr nz, jr_000_106c

    ld c, a
    ld a, d
    ld de, $c3c0
    or a
    jr z, jr_000_1086

    inc de
    jr jr_000_1086

jr_000_106c:
    sub d
    jr z, jr_000_1077

    srl a
    jr z, jr_000_1077

jr_000_1073:
    add hl, bc
    dec a
    jr nz, jr_000_1073

Jump_000_1077:
jr_000_1077:
    ld de, $c3c0
    ld a, [$c11c]
    ld c, a
    ld a, [$c11b]
    and $01
    call z, Call_000_1094

jr_000_1086:
    ld b, $0a

jr_000_1088:
    push bc
    call Copy2TilesToNewTilesVertical
    pop bc
    inc c
    dec b
    jr nz, jr_000_1088

    jp Jump_000_11a3


Call_000_1094:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr nz, jr_000_10a1

    inc hl
    inc hl

jr_000_10a1:
    ld a, [$c117]
    and $01
    jr z, jr_000_10a9

    inc hl

jr_000_10a9:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    inc hl
    ld a, [$c115]
    and $01
    jr z, jr_000_10bb

    inc hl

Jump_000_10bb:
jr_000_10bb:
    call Call_000_10c5
    pop hl
    pop bc
    bit 0, c
    ret nz

    jr jr_000_1102

Call_000_10c5:
    ld bc, Layer3BgPtrs1
    add hl, bc
    ld a, [hl]
    ld [de], a
    inc de
    ret

; 10cd: Related to background tiles.
; Copies two tile indices from c700 + offset to NewTilesVertical.
Copy2TilesToNewTilesVertical:
    ld a, [hl] ; Accesses BG tiles at Layer1BgPtrs
    push bc
    push hl
    call AMul4IntoHl    ; hl = 4 * a
    ld a, c
    and %1
    jr z, jr_000_10da
    inc hl
    inc hl
jr_000_10da:
    ld a, [$c117]
    and %1
    jr z, jr_000_10e2
    inc hl
jr_000_10e2:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl    ; hl = 4 * a
    ld a, [$c115]
    and %1
    jr z, jr_000_10f2
    inc hl
Jump_000_10f2:
jr_000_10f2:
    ld bc, Layer3BgPtrs1      ; Pointer to generic stuff.
    add hl, bc
    ld a, [hl+]
    ld [de], a        ; Copy to NewTilesVertical.
    inc de
    inc hl
    ld a, [hl]
    ld [de], a        ; Copy to NewTilesVertical.
    inc de
    pop hl
    pop bc
    bit 0, c
    ret z

jr_000_1102:
    ld a, [LevelWidthDiv16]
    add l
    ld l, a
    ret nc
    inc h
    ret


Call_000_110a:
Jump_000_110a:
    ld a, [$c1c0]
    or a
    ret nz

Jump_000_110f:
    ld hl, $c1d2
    ld c, [hl]
    inc hl
    ld b, [hl]
    ld hl, BgScrollXLsb
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, d
    cp b
    jr nz, jr_000_1122

    ld a, e
    cp c
    ret z

jr_000_1122:
    dec de
    ld a, e
    and $07
    jr z, jr_000_112c

    ld [hl], d
    dec hl
    ld [hl], e
    ret


jr_000_112c:
    ld a, [$c1cd]
    or a
    ret nz

    dec a
    ld [$c1cd], a
    ld [hl], d
    dec hl
    ld [hl], e
    call CalculateXScrolls
    ld a, [$c115]
    and $01
    xor $01
    ld c, a
    ld a, [$c118]
    ld b, a
    ld a, [$c117]
    sub c
    ld c, a
    jr nc, jr_000_1157

    ld a, b
    or a
    jr nz, jr_000_1156

    ld [$c1cd], a
    ret


jr_000_1156:
    dec b

jr_000_1157:
    ld hl, Layer1BgPtrs
    srl b
    rr c
    add hl, bc
    ld a, [LevelWidthDiv16]
    ld b, $00
    ld c, a
    ld a, [$c11b]
    and $01
    xor $01
    ld d, a
    ld a, [$c11c]
    or a
    jr nz, jr_000_117e

    ld c, a
    ld a, d
    ld de, $c3c0
    or a
    jr z, jr_000_1198

    inc de
    jr jr_000_1198

jr_000_117e:
    sub d
    jr z, jr_000_1189

    srl a
    jr z, jr_000_1189

jr_000_1185:
    add hl, bc
    dec a
    jr nz, jr_000_1185

jr_000_1189:
    ld de, $c3c0
    ld a, [$c11c]
    ld c, a

Jump_000_1190:
    ld a, [$c11b]
    and $01
    call z, Call_000_11b4

jr_000_1198:
    ld b, $0a

jr_000_119a:
    push bc
    call Call_000_11e5
    pop bc
    inc c
    dec b
    jr nz, jr_000_119a

Jump_000_11a3:
    ld a, [$c11d]
    ld [$c11e], a
    ld a, [$c122]
    ld [$c123], a
    ld a, $01
    rst $00
    or a
    ret


Call_000_11b4:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr nz, jr_000_11c1

    inc hl
    inc hl

jr_000_11c1:
    ld a, [$c115]
    and $01
    ld c, a
    ld a, [$c117]
    and $01
    xor c
    jr nz, jr_000_11d0

    inc hl

jr_000_11d0:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    inc hl
    ld a, [$c115]

Jump_000_11dd:
    and $01
    jr nz, jr_000_11e2

    inc hl

jr_000_11e2:
    jp Jump_000_10bb


Call_000_11e5:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl

Call_000_11eb:
    ld a, c
    and $01
    jr z, jr_000_11f2

    inc hl
    inc hl

jr_000_11f2:
    ld a, [$c115]
    and $01
    ld c, a
    ld a, [$c117]
    and $01
    xor c
    jr nz, jr_000_1201

    inc hl

jr_000_1201:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [$c115]
    and $01
    jr nz, jr_000_1211

    inc hl

jr_000_1211:
    jp Jump_000_10f2


; $1214: e = scroll lsb, d = scroll msb
CalculateXScrolls:
    ld a, e
    call TrippleShiftRightCarry
    ld [$c11d], a                   ; [$c11d] =  scroll msb / 8
    call TrippleRotateShiftRight
    ld a, e
    ld [$c115], a                   ; [$c115] = msb and lsb interleaved
    srl d                           ; shift rest of right
    rra                             ; Rotate a right through carry, hence a[7] = d[0].
    ld [$c117], a
    ld a, d
    ld [$c118], a                   ; [$c118] =  scroll msb / 16
    ret

Call_000_122d:
    ld a, [$c1c1]
    or a
    ret z

    ld c, a
    ld a, [BgScrollYLsb]
    cp c
    ret z

    jp c, Jump_000_1351

    jr jr_000_1242

Call_000_123d:
Jump_000_123d:
    ld a, [$c1c1]
    or a
    ret nz

jr_000_1242:
    ld hl, BgScrollYLsb
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, d
    or e
    ret z

    dec de
    ld a, e
    and $07
    jr z, jr_000_1255

    ld [hl], d
    dec hl
    ld [hl], e
    ret


jr_000_1255:
    ld a, [$c1ce]
    or a
    ret nz

    dec a
    ld [$c1ce], a
    ld [hl], d
    dec hl
    ld [hl], e
    call CalculateYScrolls
    ld a, [$c11b]
    and $01
    xor $01
    ld c, a
    ld a, [$c11c]
    sub c
    cp $ff
    jr nz, jr_000_1279

    xor a
    ld [$c1ce], a
    ret


jr_000_1279:
    srl a
    push af
    ld hl, Layer1BgPtrs
    ld a, [LevelWidthDiv16]
    ld b, $00
    ld c, a
    pop af
    or a
    jr z, jr_000_128d

jr_000_1289:
    add hl, bc
    dec a
    jr nz, jr_000_1289

jr_000_128d:
    ld a, [$c115]
    and $01
    xor $01
    ld d, a
    ld a, [$c118]
    ld b, a
    ld a, [$c117]
    ld c, a
    or a
    jr nz, jr_000_12ae

    ld a, b

Call_000_12a1:
    or a
    jr nz, jr_000_12ae

    ld a, d
    ld de, $c3d8
    or a
    jr z, jr_000_12c8

    inc de
    jr jr_000_12c8

jr_000_12ae:
    ld a, c
    sub d
    ld c, a
    jr nc, jr_000_12b4

    dec b

jr_000_12b4:
    srl b
    rr c
    add hl, bc
    ld de, $c3d8
    ld a, [$c117]
    ld c, a
    ld a, [$c115]
    and $01
    call z, Call_000_12d6

jr_000_12c8:
    ld b, $0b

jr_000_12ca:
    push bc
    call Call_000_130e
    pop bc
    inc c
    dec b
    jr nz, jr_000_12ca

    jp Jump_000_13dc


Call_000_12d6:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr nz, jr_000_12e2

    inc hl

jr_000_12e2:
    ld a, [$c11b]
    and $01
    ld c, a
    ld a, [$c11c]
    and $01
    xor c
    jr nz, jr_000_12f2

    inc hl
    inc hl

jr_000_12f2:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    ld a, [$c11b]
    and $01
    jr nz, jr_000_1304

    inc hl
    inc hl

Jump_000_1304:
jr_000_1304:
    call Call_000_10c5
    pop hl
    pop bc
    bit 0, c
    ret nz

    inc hl
    ret


Call_000_130e:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr z, jr_000_131a

    inc hl

jr_000_131a:
    ld a, [$c11b]
    and $01
    ld c, a

GameTitle::
    ld a, [$c11c]
    and $01
    xor c
    jr nz, jr_000_132a

    inc hl
    inc hl

jr_000_132a:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [$c11b]
    and $01
    jr nz, jr_000_133b

    inc hl
    inc hl

Jump_000_133b:
jr_000_133b:
    ld bc, Layer3BgPtrs1
    add hl, bc
    ld a, [hl+]
    ld [de], a        ; Copy to NewTilesHorizontal.
    inc de
    ld a, [hl]
    ld [de], a        ; Copy to NewTilesHorizontal.
    inc de
    pop hl
    pop bc
    bit 0, c
    ret z

    inc hl
    ret


Call_000_134c:
Jump_000_134c:
    ld a, [$c1c1]
    or a
    ret nz

Call_000_1351:
Jump_000_1351:
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
    jr nz, jr_000_1364

    ld a, e
    cp c
    ret z

jr_000_1364:
    inc de
    ld a, e
    and $07
    jr z, jr_000_136e

    ld [hl], d
    dec hl
    ld [hl], e
    ret


jr_000_136e:
    ld a, [$c1ce]
    or a
    ret nz

    inc a
    ld [$c1ce], a
    ld [hl], d
    dec hl
    ld [hl], e
    call CalculateYScrolls
    ld a, [$c11c]
    add $09
    srl a

Call_000_1384:
    push af
    ld hl, Layer1BgPtrs
    ld a, [LevelWidthDiv16]
    ld b, $00
    ld c, a
    pop af
    or a
    jr z, jr_000_1396

jr_000_1392:
    add hl, bc
    dec a
    jr nz, jr_000_1392

jr_000_1396:
    ld a, [$c115]
    and $01
    xor $01
    ld d, a
    ld a, [$c118]
    ld b, a
    ld a, [$c117]
    ld c, a
    or a
    jr nz, jr_000_13b7

    ld a, b
    or a
    jr nz, jr_000_13b7

    ld a, d
    ld de, $c3d8
    or a
    jr z, jr_000_13d1

    inc de
    jr jr_000_13d1

jr_000_13b7:
    ld a, c
    sub d
    ld c, a
    jr nc, jr_000_13bd

    dec b

jr_000_13bd:
    srl b
    rr c
    add hl, bc
    ld de, $c3d8
    ld a, [$c117]
    ld c, a
    ld a, [$c115]
    and $01
    call z, Call_000_13ed

jr_000_13d1:
    ld b, $0b

jr_000_13d3:
    push bc
    call Call_000_1417
    pop bc
    inc c
    dec b
    jr nz, jr_000_13d3

Jump_000_13dc:
    ld a, [$c11d]
    ld [$c11f], a
    ld a, [$c122]
    ld [$c124], a
    ld a, $01
    rst $00
    or a
    ret


Call_000_13ed:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr nz, jr_000_13f9

    inc hl

jr_000_13f9:
    ld a, [$c11c]

Call_000_13fc:
    and $01
    jr nz, jr_000_1402

    inc hl
    inc hl

jr_000_1402:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    ld a, [$c11b]
    and $01
    jr z, jr_000_1414

    inc hl

Call_000_1413:
    inc hl

jr_000_1414:
    jp Jump_000_1304


Call_000_1417:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr z, jr_000_1423

    inc hl

jr_000_1423:
    ld a, [$c11c]
    and $01
    jr nz, jr_000_142c

    inc hl
    inc hl

jr_000_142c:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [$c11b]
    and $01
    jr z, jr_000_143d

    inc hl
    inc hl

jr_000_143d:
    jp Jump_000_133b

; $1440: Calculate Y scrolls.
CalculateYScrolls:
    ld a, e
    call TrippleShiftRightCarry
    ld [$c122], a
    call TrippleRotateShiftRight
    ld a, e
    ld [$c11b], a
    srl a
    ld [$c11c], a
    ret

; $1454: Calculates a * 4 and stores the result in hl.
; h[1] = a[7]
; h[0] = a[6]
; l = a << 2
AMul4IntoHl::
    ld h, 0
    add a       ; a = 2 * a
    rl h        ; h[0] = a[7]
    add a
    rl h
    ld l, a
    ret

; $145e: Shift value in "a" 3 times right into carry.
TrippleShiftRightCarry::
    srl a
    srl a
    srl a
    ret

; $1465: Shift lower 3 bits of "d" into upper 3 bits of "e"
TrippleRotateShiftRight::
    srl d
    rr e
    srl d
    rr e
    srl d
    rr e
    ret

; $1472: Shift lower 3 bits of "h" into upper 3 bits of "l"
TrippleRotateShiftRightHl:
    srl h
    rr l
    srl h
    rr l
    srl h
    rr l
    ret

; Sets up de and hl
Call_000_147f:
    ld a, [BgScrollXMsb]
    and $0f
    swap a
    srl a
    ld e, a                 ; e = lower BgScrollXMsb nibble left-shifted by 3.
    ld a, [BgScrollYMsb]
    and $0f
    swap a
    srl a
    ld d, a                 ; d = lower BgScrollYMsb nibble left-shifted by 3.
    ld b, $00
    ld a, [LevelWidthDiv16]
    ld c, a                 ; bc = $0 [LevelWidthDiv16]
    ld h, d
    ld l, b                 ; = 0
    ld a, $08
 :  add hl, hl
    jr nc, :+
    add hl, bc              ; add "bc" if a bit in "hl" was set,
 :  dec a
    jr nz, :--              ; This loop is executed 8 times.
    ld d, $00
    add hl, de
    ld d, h
    ld e, l
    ret

SoundAndJoypad:
    ld a, [OldRomBank]
    push af                     ; Save ROM bank.
    ld a, 7
    rst $00                     ; Load ROM bank 7.
    call SoundTODO
    pop af
    rst $00                     ; Restore old ROM bank.
    call ReadJoyPad

; $14b9: Waits for the next phase.
WaitForNextPhase:
:   db $76                      ; Halt.
    ld a, [PhaseTODO]
    and a
    jr z, :-
    xor a
    ld [PhaseTODO], a           ; = 0
    ret

; $14c5: Generates timer interrupt ~62.06 (4096/66) times per second.
StartTimer::
    ldh a, [rLCDC]
    and $80
    ret z                     ; Return if display is turned off.
    call StopDisplay
    xor a
    ldh [rIF], a              ; Interrupt flags = 0.
    ld a, $04
    ldh [rIE], a              ; Enable timer interrupt.
    ld a, $ff
    ldh [rTIMA], a            ; Timer counter to 255. Will overflow with the next increase.
    ld a, $be
    ldh [rTMA], a             ; Timer modulo to 190. Overflow every 66 increases.
Call_000_14dc:
    ld a, $04
    ldh [rTAC], a             ; Start timer with 4096 Hz.
    ei
    ret

; $14e2: Waits for rLY 145 and then stops display operation.
StopDisplay::
    di
    ldh a, [rIE]
    ld c, a                   ; Save interrupt settings.
    res 0, a
    ldh [rIE], a              ; Disable V-blank interrupt.
 :  ldh a, [rLY]
    cp 145
    jr nz, :-                 ; Wait for rLY to reach 145.
    ldh a, [rLCDC]
    and $7f
    ldh [rLCDC], a            ; Stop display operation.
    ld a, c
    ldh [rIE], a              ; Restore old interrupt settings.
    ret

SetUpInterruptsSimple::
    ld a, IEF_VBLANK        ; Enable VBLANK interrupt.
    ld b, $00               ; rSTAT = 0.
    ld c, b                 ; rLYC = 0
    jr SetUpInterrupts

SetUpInterruptsAdvanced::
    ld c, $77                    ; rLYC = 119.
    ld a, IEF_STAT | IEF_VBLANK  ; Enable VBLANK and STAT interrupt.
    ld b, $40                    ; rSTAT = $40.

; $1507: a = rIE, b = rSTAT, c = rLYC
SetUpInterrupts::
    push af
    xor a
    ldh [rIF], a              ; Reset interrupt flags.
    pop af
    ldh [rIE], a              ; Enable given interrupts.
    ld a, %10000111           ; BG on. Sprites on. Large sprites. Tile map low. Tile data high. WNDW off. LCDC on.
    ldh [rLCDC], a
    ld a, b
    ldh [rSTAT], a
    ld a, c
    ldh [rLYC], a
    xor a
    ldh [rTAC], a
    ei
    ret


Call_000_151d:
    ld b, $e0
    jr jr_000_1523

Call_000_1521:
    ld b, $f0

Call_000_1523:
jr_000_1523:
    ld a, [NextLevel]
    cp $0b
    ret nc

    ld a, [$c1c9]
    or a
    ret nz

    ld a, [$c15b]
    and $01
    ret nz

    ld c, $00
    call Call_000_175b
    ccf
    ret nc

    call Call_000_1731
    ld c, a
    cp $1e
    jr z, jr_000_1591

    cp $c1
    jr z, jr_000_158a

    cp $3f
    jr c, jr_000_1566

    ld a, [$c169]
    or a
    ret nz

    ld a, c
    cp $43
    ret c

    cp $c7
    jr c, jr_000_1566

    cp $cb
    jr nc, jr_000_1566

    ld a, [NextLevel]
    cp $0a
    jr nz, jr_000_1566

    ld a, c
    scf
    ret


jr_000_1566:
    dec hl
    ld a, [hl]
    ld c, a
    cp $1e
    jr z, jr_000_157c

    cp $c1
    jr z, jr_000_1573

    and a
    ret


jr_000_1573:
    ld a, [NextLevel]
    cp $0a
    jr z, jr_000_157c

    and a
    ret


jr_000_157c:
    ld a, [$c149]
    cp $06
    ret z

    ld a, [PlayerPositionXLsb]
    and $0f
    cp $08
    ret


jr_000_158a:
    ld a, [NextLevel]
    cp $0a
    ccf
    ret nc

jr_000_1591:
    ld a, [$c149]
    cp $06
    ret z

    ld a, [PlayerPositionXLsb]
    and $0f
    cp $08
    ccf
    ret


Call_000_15a0:
    call Call_000_175b
    ld hl, Layer1BgPtrs
    add hl, de
    ld c, [hl]
    ld a, [NextLevel]
    cp $0a
    ld a, c
    jr z, jr_000_15b7

    cp $4c
    ccf
    ret nc

    cp $4e
    ret


jr_000_15b7:
    cp $c8
    ccf
    ret nc

    cp $ca
    ret


Call_000_15be:
    xor a
    ld [$c157], a
    ld c, $01
    ld a, [NextLevel]
    cp $04
    jr z, jr_000_15d1

    cp $05
    jr nz, jr_000_15e0

    ld c, $03

jr_000_15d1:
    ld a, [PlayerPositionYMsb]
    cp c
    ret c

    jr nz, jr_000_15f4

    ld a, [PlayerPositionYLsb]
    cp $f4
    ret c

    jr jr_000_15f4

jr_000_15e0:
    cp $0a

Jump_000_15e2:
    ret nz

    ld bc, $f400
    call Call_000_175b
    call Call_000_1731
    cp $bc
    ret c

    cp $be
    ret nc

    ld c, $07

jr_000_15f4:
    ld [$c157], a
    ld a, [TimeCounter]
    and c
    ret nz

    ld a, [$c1ba]
    or a

Jump_000_1600:
    ret nz

    dec a
    ld [$c1ba], a
    ld c, $01

; $1607: Reduce CurrentHealth by the value in "c".
ReduceHealth:
    ld a, [CurrentHealth]
    sub c
    jr nc, .SkipCarry
    xor a                   ; = 0 in case "a" went negative.
.SkipCarry:
    ld [CurrentHealth], a
    ret nz                  ; Return if some health is left.

Jump_000_1612:
jr_000_1612:
    ld a, [$c1df]
    or a
    ret nz
    ld a, [$c1c9]
    or a
    ret nz
    ld [IsJumping], a               ; = 0
    ld [LandingAnimation], a        ; = 0
    ld [$c15b], a                   ; = 0
    ld [$c169], a                   ; = 0
    ld [$c156], a                   ; = 0
    ld [InvincibilityTimer], a      ; = 0
    ld [$c158], a                   ; = 0
    ld [$c1ef], a                   ; = 0
    dec a
    ld [$c149], a                   ; = $ff
    ld [$c14a], a                   ; = $ff
    ld a, $3c
    ld [$c1c9], a                   ; = $3c
    ld a, $13
    ld [$c175], a                   ; = $13
    ld a, $1d
    ld [HeadSpriteIndex], a         ; = $1d
    ld a, $4c
    ld [CurrentSong], a
    ld a, EVENT_SOUND_DIED
    ld [EventSound], a
    ld a, [CurrentLives]
    dec a
    ld [CurrentLives], a
    jp DrawLivesLeft

Call_000_165e:
    ld b, $00

Call_000_1660:
    ld a, [$c1dc]
    or a
    ret nz

    ld c, $00
    ld a, [PlayerFreeze]
    or a
    jr nz, jr_000_1672

    ld a, [$c1c9]
    or a
    ret nz

jr_000_1672:
    call Call_000_175b
    jr nc, jr_000_1685

    ld a, [NextLevel]
    cp $04
    jr c, jr_000_1612

    cp $06
    jr nc, jr_000_1612

    ld a, $11
    ret


jr_000_1685:
    push de
    call Call_000_1731
    pop de
    ld l, a
    ld a, 6
    rst $00                 ; Load ROM bank 6.
    call Call_000_1697
    push af
    ld a, $01
    rst $00
    pop af

Jump_000_1696:
    ret


Call_000_1697:
    ld h, $c4
    ld a, [hl]
    or a
    jr z, jr_000_16a5

    ld c, a
    xor a
    ld [$c158], a
    ld a, c
    jr jr_000_16a8

jr_000_16a5:
    ld a, [$c158]

jr_000_16a8:
    ld [$c156], a
    or a
    ret z

    bit 6, a
    ret nz

    dec a
    swap a
    ld b, a
    and $f0
    ld c, a
    ld a, b
    and $0f
    ld b, a
    ld hl, $41a8
    add hl, bc
    ld c, $00
    ld a, [NextLevel]
    cp $03
    jr z, jr_000_16d9

    cp $05
    jr nz, jr_000_16ea

    ld a, [$c156]
    cp $21
    jr c, jr_000_16ea

    cp $25
    jr c, jr_000_16e6

    jr jr_000_16ea

jr_000_16d9:
    ld a, [$c156]
    cp $20
    jr z, jr_000_16e6

    and $1f
    cp $14
    jr c, jr_000_16ea

jr_000_16e6:
    ld a, [$c12d]
    ld c, a

jr_000_16ea:
    ld a, [$c158]
    or a
    jr z, jr_000_16f5

    ld a, [$c159]
    jr jr_000_16f9

jr_000_16f5:
    ld a, [PlayerPositionXLsb]
    add c

jr_000_16f9:
    and $0f
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    ld b, a
    or a
    ret z

    ld a, [$c158]
    or a
    jr z, jr_000_1724

    ld c, a
    push bc
    ld a, [$c15a]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c
    pop bc
    ccf
    ret nc

    cp $08
    jr c, jr_000_1727

    push bc
    ld b, a
    ld a, c
    cp $30
    ld a, b
    pop bc
    ret nc

    jr jr_000_1727

jr_000_1724:
    ld a, [PlayerPositionYLsb]

jr_000_1727:
    and $0f
    ld c, a
    ld a, $10
    sub c
    cp b
    ret nz

    scf
    ret

; This is related to the background tile indices.
; Input: de
; Output: a
Call_000_1731:
    ld a, [WindowScrollYLsb]
    ld c, a
    ld a, [WindowScrollYMsb]
    ld b, a
    ld hl, Layer1BgPtrs
    add hl, de
    ld a, [hl]                  ; Get index from data in [Layer1BgPtrs + de].
    ld d, $00
    add a
    rl d
    add a
    rl d                        ; Rotate upper 2 bits of "a" into lower bits of "d".
    ld e, a                     ; e = a << 2. So "de" is data times 4.
    ld hl, Layer2BgPtrs1
    srl c
    jr nc, jr_000_174f          ; Jump if Y LSB bit 0 is 0.
    inc hl
jr_000_174f:
    srl b
    jr nc, jr_000_1755          ; Jump if Y MSB bit 0 is 0.
    inc hl
    inc hl
jr_000_1755:
    add hl, de                  ; hl = $cb00 + (index * 4) #
    ld a, 1
    rst $00                     ; Load ROM bank 1
    ld a, [hl]
    ret

Call_000_175b:
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push bc
    ld b, $00
    bit 7, c
    jr z, jr_000_1769

    dec b

jr_000_1769:
    add hl, bc
    ld bc, $0110
    ld d, $15
    ld a, [NextLevel]
    cp $03
    jr z, jr_000_177f

    cp $05
    jr nz, jr_000_1799

    ld bc, $03d0
    ld d, $07

jr_000_177f:
    ld a, [PlayerPositionYMsb]
    cp b
    jr nz, jr_000_1799

    ld a, [PlayerPositionYLsb]
    cp c
    jr c, jr_000_1799

    ld a, [$c12d]
    ld c, a
    ld a, [$c12e]
    ld b, a
    add hl, bc
    ld a, h
    sub d
    jr c, jr_000_1799

    ld h, a

jr_000_1799:
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h
    ld d, $00
    ld e, h
    sla l
    rl h
    ld a, h
    ld [WindowScrollYLsb], a
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    pop bc
    ld c, b
    ld b, $00
    bit 7, c
    jr z, jr_000_17bf

    dec b

jr_000_17bf:
    add hl, bc
    ld b, d
    ld c, e
    ld a, l
    and $f0
    swap a
    ld d, a
    ld a, h
    and $0f
    swap a
    or d
    ld d, a
    ld [WindowScrollYMsb], a
    srl d
    ld a, [LevelHeightDiv16]
    cp d
    ret c

    scf
    ret z

    push bc
    ld b, $00
    ld a, [LevelWidthDiv16]
    ld c, a
    ld h, d
    ld l, b
    ld a, $08

jr_000_17e6:
    add hl, hl
    jr nc, jr_000_17ea

    add hl, bc

jr_000_17ea:
    dec a
    jr nz, jr_000_17e6

    pop de
    add hl, de
    ld d, h
    ld e, l
    ret


Call_000_17f2:
    push hl
    call Call_000_1838
    call Call_000_1731
    ld l, a
    ld a, 6
    rst $00                 ; Load ROM bank 6.
    call Call_000_1807
    push af
    ld a, 1
    rst $00                 ; Load ROM bank 1.
    pop af
    pop hl
    ret


Call_000_1807:
    ld h, $c4
    ld a, [hl]
    or a
    ret z

    bit 6, a
    ret nz

    dec a
    swap a
    ld b, a
    and $f0

Call_000_1815:
    ld c, a
    ld a, b
    and $0f
    ld b, a
    ld hl, $41a8
    add hl, bc
    ld a, [WindowScrollXLsb]
    and $0f
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    or a
    ret z

    ld b, a
    ld a, [WindowScrollXMsb]
    and $0f
    ld c, a
    ld a, $10
    sub c
    cp b
    ret nz

    scf
    ret


Call_000_1838:
    ld c, $03
    rst $08
    ld [WindowScrollXLsb], a
    ld e, a
    inc c
    rst $08
    ld d, a
    sla e
    rl d
    sla e
    rl d
    sla e
    rl d
    ld c, d
    sla e
    rl d
    ld a, d
    ld [WindowScrollYLsb], a
    push bc
    ld c, $01
    rst $08
    ld [WindowScrollXMsb], a
    ld e, a
    inc c
    rst $08
    ld d, a

Jump_000_1862:
    ld a, e

Jump_000_1863:
    and $f0
    swap a
    ld b, a
    ld a, d
    and $0f
    swap a
    or b
    ld [WindowScrollYMsb], a
    srl a
    pop de
    ld h, a
    ld b, $00
    ld a, [LevelWidthDiv16]
    ld c, a
    ld l, b
    ld a, $08

jr_000_187e:
    add hl, hl
    jr nc, jr_000_1882

    add hl, bc

jr_000_1882:
    dec a
    jr nz, jr_000_187e

    add hl, de
    ld d, h
    ld e, l
    ret


Call_000_1889:
    ld a, [$c1c9]
    or a
    ret nz

    ld a, [$c1df]
    or a
    ret nz

    ld hl, $c1b2
    push hl
    xor a
    ld [hl+], a
    ld a, [$c144]
    ld c, a
    sub $04
    ld [hl+], a
    ld d, $20
    ld a, [$c177]
    or a
    jr z, jr_000_18aa

    ld d, $10

jr_000_18aa:
    ld a, [$c145]
    ld b, a
    sub d
    ld [hl+], a
    ld a, c
    add $04
    ld [hl+], a
    ld a, b
    sub $02
    ld [hl+], a
    pop de
    ld a, b
    cp $74
    jp nc, Jump_000_1aeb

    call Call_000_1eb2
    jr c, jr_000_18c8

    call Call_000_1e73
    ret nc

; This seems to be some kind of collision event.
jr_000_18c8:
    ld a, [PlayerFreeze]
    or a
    jp nz, Jump_000_1bad
    ld c, $17
    rst RST_08
    inc a
    jp z, ReceiveSingleDamage
    ld c, $05
    rst RST_08
    cp ID_DIAMOND                       ; $89: Diamond.
    jp z, DiamondCollected
    cp ID_FLYING_STONES
    jr nz, :+
    set 1, [hl]
    jp ReceiveSingleDamage
 :  cp $97                              ; See object IDs.
    jr c, :+
    cp $a1
    jp c, ItemCollected                 ; Called when a>=$97 && a<$a1. $97 = pineapple, $9a = grapes, $9b = extra life, $9c = mask, $9d = extra time, $9e = shovel, $9f double banana, $a0 = boomerang
 :  ld b, a
    cp ID_MONKEY_COCONUT
    jr z, ReceiveContinuousDamage       ; a=$92: Hit by a monkey's coconut (both flying and bouncing).
    cp $93
    jr z, ReceiveContinuousDamage
    cp ID_SNAKE_PROJECTILE
    jr z, ReceiveContinuousDamage
    cp $28
    jr z, ReceiveSingleDamage
    cp $59
    jr z, ReceiveSingleDamage
    cp $81
    jr z, ReceiveSingleDamage
    ld a, [LandingAnimation]
    or a
    jr z, ReceiveSingleDamage
    ld a, [$c170]
    cp $10
    jr c, ReceiveSingleDamage
    inc hl
    ld a, [hl-]
    ld c, a
    ld a, [BgScrollYLsb]
    sub c
    ld c, a
    ld a, [$c145]
    add 8
    cp c
    jr nc, ReceiveSingleDamage
    ld a, b
    cp ID_FISH
    jr z, ReceiveSingleDamage
    cp $85
    jr z, jr_000_193b
    cp $71
    jr c, :+
    cp $81
    jr c, ReceiveSingleDamage
 :  cp ID_CRAWLING_SNAKE
    jr nz, jr_000_1947

jr_000_193b:
    ld a, EVENT_SOUND_HOP_ON_ENEMY
    ld [EventSound], a
    ld a, $40
    ld c, $0a
    rst $10
    jr jr_000_19a2

jr_000_1947:
    ld a, EVENT_SOUND_HOP_ON_ENEMY
    ld [EventSound], a
    ld a, $30
    call DrawScore3
    ld c, $17
    rst $08
    swap a
    and $0f
    jr z, jr_000_195f

    call Call_000_1afb
    jr jr_000_19a2

jr_000_195f:
    set 6, [hl]
    ld a, $14
    ld c, $0c
    rst $10
    ld a, $01
    ld c, $09
    rst $10
    jr jr_000_19a2

; $196d: Reduces health by 1 and plays sound in case player is not invincible. Does not grant invicibility.
ReceiveContinuousDamage::
    set 7, [hl]
    ld c, 1
    jr ReceiveDamage
; $1973: Reduces health by 4/2 (practice/normal) and plays a sound in case player is not invincible.
; A hit grants invincibility for ~1.5 seconds.
ReceiveSingleDamage::
    ld c, 4                      ; In normal mode you receive 4 damage.
    ld a, [DifficultyMode]
    or a
    jr z, ReceiveDamage
    dec c
    dec c                        ; In practice mode you receive 2 damage.
ReceiveDamage::
    ld a, [InvincibilityTimer]
    or a
    ret nz                       ; Not receiving damage if invincible.
    ld a, [$c1ba]
    or a
    ret nz
    dec a
    ld [$c1ba], a
    ld a, EVENT_SOUND_DAMAGE_RECEIVED
    ld [EventSound], a          ; Play sound for receiving damange.
    ld a, c
    cp 2
    jr c, :+                    ; 1 damage is inflicted by stuff like water and does not grant invincibility.
    push bc
    call Call_000_19ac
    pop bc
    ld a, 24
    ld [InvincibilityTimer], a  ; After receiving damage the player becomes invincible for ~1.5 second.
 :  jp ReduceHealth

jr_000_19a2:
    ld a, [$c146]
    ld [$c176], a
    ld a, $0c
    jr jr_000_19e7

Call_000_19ac:
    ld a, [$c15b]
    and $01
    ret nz
    ld a, [$c169]
    or a
    ret nz
    ld a, [$c158]
    or a
    ret nz
    ld c, $07
    rst $08
    and $0f
    jr z, jr_000_19cb
    bit 3, a
    jr z, jr_000_19d0
    or $f0
    jr jr_000_19d0

jr_000_19cb:
    ld a, [$c146]
    cpl
    inc a

jr_000_19d0:
    ld [$c176], a
    ld a, [LandingAnimation]
    or a
    jr nz, jr_000_19e1

    ld a, [$c173]
    or a
    jr z, jr_000_19e5

    cp $0c

jr_000_19e1:
    ld a, $0b
    jr c, jr_000_19e7

jr_000_19e5:
    ld a, $11

jr_000_19e7:
    ld [$c175], a
    ld a, $44
    ld [HeadSpriteIndex], a
    xor a
    ld [$c17d], a
    ld [IsJumping], a
    ld [$c173], a
    ld [LandingAnimation], a
    ld [$c170], a
    ld [$c17b], a
    ld [$c17f], a
    ld [LookingUp], a
    ret

Call_000_1a09:
    ld c, $05
    rst $08
    ld e, $2a
    cp $28
    jr z, jr_000_1a6f

    ld e, $2e
    cp $59
    jr z, jr_000_1a6f

    cp $ac
    jp z, Jump_000_1abe

    ld e, $30
    cp $84
    jr z, jr_000_1a49

    cp $ae
    ret nz

    ld e, $2c
    call Call_000_1ab3
    ld a, [NextLevel]
    cp $04
    jp nz, Jump_000_1ac5

    ld c, $16
    rst $08
    or a
    jp nz, Jump_000_1ac5

    bit 0, [hl]
    jp nz, Jump_000_1ac5

    bit 6, [hl]
    jp nz, Jump_000_1ac5

    ld a, $20
    rst $10
    jr jr_000_1ac5

jr_000_1a49:
    ld a, [LandingAnimation]
    or a
    jr nz, jr_000_1a8f

    ld a, [IsJumping]
    or a
    jr nz, jr_000_1a8f

    ld a, l
    ld [$c1fa], a
    ld a, [NextLevel]
    cp $0a
    jr z, jr_000_1a8f

    ld c, $16
    rst $08
    or a
    jr nz, jr_000_1a8f

    bit 6, [hl]
    jr nz, jr_000_1a8f

    ld a, $30
    rst $10
    jr jr_000_1a8f

jr_000_1a6f:
    ld a, e
    cp $2e
    jr nz, jr_000_1a7e

    ld a, $01
    ld c, $08
    rst $10
    xor a
    ld c, $0c
    jr jr_000_1a8e

jr_000_1a7e:
    ld c, $09
    rst $08
    or a
    jr nz, jr_000_1a8f

    ld a, $02
    rst $10
    ld c, $0c
    rst $08
    add a
    jr nc, jr_000_1a8e

    xor a

jr_000_1a8e:
    rst $10

jr_000_1a8f:
    ld a, [BgScrollXLsb]
    ld d, a
    ld c, $03
    rst $08
    sub d
    sub $10
    ld d, a
    ld a, [$c144]
    sub d
    jr c, jr_000_1aeb

    cp $20
    jr nc, jr_000_1aeb

    cp $10
    jr c, jr_000_1aab

    inc e
    and $0f

jr_000_1aab:
    ld [$c159], a
    call Call_000_1ab3
    jr jr_000_1add

Call_000_1ab3:
    ld c, $07
    rst $08
    and $20
    ret nz

    ld a, e
    xor $01
    ld e, a
    ret


Jump_000_1abe:
    ld e, $29
    ld c, $09
    ld a, $02
    rst $10

Jump_000_1ac5:
jr_000_1ac5:
    ld a, [BgScrollXLsb]
    ld d, a
    ld c, $03
    rst $08
    sub d
    sub $08
    ld d, a
    ld a, [$c144]
    sub d
    jr c, jr_000_1aeb

    cp $10
    jr nc, jr_000_1aeb

    ld [$c159], a

jr_000_1add:
    ld c, $01
    rst $08
    sub $10
    ld [$c15a], a
    ld a, e
    ld [$c158], a
    xor a
    ret


Call_000_1aeb:
Jump_000_1aeb:
jr_000_1aeb:
    xor a
    ld [$c158], a
    ld [$c159], a
    ld [$c15a], a
    dec a
    ld [$c1fa], a
    xor a
    ret


Call_000_1afb:
Jump_000_1afb:
    push af
    ld c, $05
    rst $08
    cp $a4
    jr nz, jr_000_1b05

    set 6, [hl]

jr_000_1b05:
    pop af
    push hl
    dec a
    ld b, $00
    ld c, a
    ld hl, $63e1
    add hl, bc
    ld a, [hl]
    pop hl
    ld c, $05
    rst $10
    ld a, [hl]
    and $50
    ld [hl], a
    inc c
    ld a, $90
    rst $10
    inc c
    xor a
    rst $10
    inc c
    rst $10
    inc c
    inc c
    inc c
    rst $10
    inc c
    rst $10
    inc c
    rst $10
    inc c
    rst $10
    inc c
    ld a, $02
    rst $10
    inc c
    rst $08
    push af
    inc c
    rst $08
    srl a
    ld de, $c1a9
    add e
    ld e, a
    xor a
    ld [de], a
    rst $10
    pop af
    add a
    rl b
    add a
    rl b
    add a
    rl b
    ld c, a
    ld d, b
    add a
    rl d
    ld e, a
    push hl
    ld hl, $d700
    add hl, de
    add hl, bc
    ld d, h
    ld e, l
    pop hl
    ld bc, $0018
    rst $38
    ret


jr_000_1b5c:
    call Call_000_1b9b
    ld a, $0e
    ld [EventSound], a
    ld a, [NextLevel]
    bit 0, a
    ret z

Jump_000_1b6a:
    xor a
    ld [$c1ef], a               ; = 0
    ld [InvincibilityTimer], a  ; = 0
    ld [CheckpointReached], a   ; = 0
    ld [$c175], a               ; = 0
    ld c, a
    dec a
    ld [$c1c9], a               ; = $ff
    ld [PlayerFreeze], a               ; = $ff
    ld a, [BgScrollXLsb]
    ld [$c1c0], a
    ld a, [BgScrollYLsb]
    ld [$c1c1], a
    jp $46cb

; $1b8e
DiamondCollected:
    call Call_000_1cd1
    call DiamondFound
    jr z, jr_000_1b5c
    ld a, EVENT_SOUND_CHECKPOINT
    ld [EventSound], a

Call_000_1b9b:
    ld a, $05
    call DrawScore2
    ld a, $8f

Call_000_1ba2:
    ld c, $05
    rst $10
    ld c, $07
    rst $08
    and $7f
    rst $10
    set 5, [hl]

Jump_000_1bad:
    ld a, $17
    ld c, $0c
    rst $10
    ld a, $01
    ld c, $09
    rst $10
    xor a
    ld c, $0e
    rst $10
    inc c
    rst $10
    set 6, [hl]
    ret

; $1bc0: Called when an item (weapon, life, checkpoint, ...) was collected.
; "a" determines the item.
; pineapple = $97, checkpoint = $98, health package = $9a, extra life = $9b,  mask = $9c
; extram time = $9d, showel = $9e, double banana = $9f, boomerang = $a0
ItemCollected:
    cp $97
    jr nz, CheckHealthPackage
    ld a, [NextLevel]
    cp 10
    jp z, ReceiveContinuousDamage
    jr jr_000_1c1d                  ; Pineapple collected.

; $1bce
CheckHealthPackage:
    cp $9a                          ; health package = 9a
    jr nz, CheckExtraLife
    ld a, HEALTH_ITEM_HEALTH        ; Health package was collected.
    ld [CurrentHealth], a           ; Fully restore CurrentHealth.
    ld a, $0f
    ld [$c1ba], a                   ; TODO: $c1ba somehow related to health.
    jr jr_000_1c1d

; $1bde
CheckExtraLife:
    cp $9b
    jr nz, CheckMask
    call Call_000_1cd1
    ld a, [CurrentLives]
    inc a
    cp MAX_LIFES
    jr nc, :+
    ld [CurrentLives], a
 :  call DrawLivesLeft
    ld a, $90
    jr jr_000_1c24

; $1bf7
CheckMask:
    cp $9c
    jr nz, CheckExtraTime
    ld a, [NextLevel]
    cp 11                       ; In level 11 the numbers of continues is increased.
    jr nz, jr_000_1c0b
    ld a, [NumContinuesLeft]
    inc a
    ld [NumContinuesLeft], a    ; Increase number of continues left by one.
    jr jr_000_1c18

jr_000_1c0b:
    ld a, [CurrentSecondsInvincibility]
    add MASK_SECONDS

Jump_000_1c10:
    daa
    jr nc, :+
    ld a, $99                                   ; Overflow to 99s.
 :  ld [CurrentSecondsInvincibility], a

jr_000_1c18:
    push hl
    call UpdateWeaponNumber
    pop hl

jr_000_1c1d:
    ld a, SCORE_PINEAPPLE
    call DrawScore2
    ld a, $8e

Jump_000_1c24:
jr_000_1c24:
    call Call_000_1ba2
    xor a
    ld [$c1f9], a
    ld a, EVENT_SOUND_CHECKPOINT
    ld [EventSound], a
    ld a, [NextLevel]
    cp $0b
    ret nz

    ld a, [$c1ff]
    dec a
    ld [$c1ff], a
    ret nz
    jp $5fbd

; $1c41
CheckExtraTime:
    cp $9d
    jr nz, CheckBonusLevel
    ld a, [NextLevel]
    cp $0b
    jr z, jr_000_1c5e
    ld a, [DifficultyMode]
    ld c, a
    ld a, [DigitMinutes]            ; Add 1 minute in normal mode and 2 minutes in practice mode.
    inc a
    add c
    ld [DigitMinutes], a
    ld de, $9cd0
    call DrawBigNumber

jr_000_1c5e:
    ld a, $50
    call DrawScore3
    ld a, $8d
    jr jr_000_1c24

; $1c67
CheckBonusLevel:
    cp $9e
    jr nz, CheckDoubleBanana
    ld [BonusLevel], a
    call Call_000_1cd1
    jr jr_000_1c1d

; $1c73
CheckDoubleBanana:
    cp $9f
    jr nz, CheckBoomerang
    ld a, [NextLevel2]
    inc a
    cp $04
    jr c, jr_000_1c87
    and $01
    jr nz, jr_000_1c87
    ld a, WEAPON_STONES
    jr IncreaseWeaponBy20

jr_000_1c87:
    ld a, WEAPON_DOUBLE_BANANA
; $1c89
IncreaseWeaponBy20:
    push hl
    ld hl, AmmoBase
    add l                           ; Weapon offset in "a"
    ld l, a
    ld a, [hl]
    add $20                         ; Add 20 to weapon.
    daa
    jr nc, :+
    ld a, $99                       ; Overflow to 99.
 :  ld [hl], a
    call UpdateWeaponNumber         ; Update currently displayed weapon.
    pop hl
    ld a, SCORE_WEAPON_COLLECTED
    call DrawScore3
    ld a, $8c
    jp Jump_000_1c24

; $1ca6
CheckBoomerang:
    cp $a0
    jr nz, CheckCheckpoint
    ld a, WEAPON_BOOMERANG
    jr IncreaseWeaponBy20

; $1cae
CheckCheckpoint:
    cp $98
    ret nz
    ld c, $0e
    rst $08
    dec a
    ret nz
    ld a, $03
    rst $10
    inc c
    xor a                           ; a = 0
    rst $10
    ld a, $08
    ld [CheckpointReached], a       ; Checkpoint reached.

; $1cc1: [$d726], [$d727] = $03, $00
PositionFromCheckpoint:
    push hl
    ld hl, $d726
    ld [hl], $03
    inc hl
    ld [hl], $00
    pop hl
    ld a, EVENT_SOUND_CHECKPOINT
    ld [EventSound], a
    ret

Call_000_1cd1:
    push af
    ld c, $10
    rst $08
    ld d, $c6
    ld e, a
    pop af
    ld [de], a
    ret


Call_000_1cdb:
    ld hl, $c300
    ld b, $04

jr_000_1ce0:
    bit 7, [hl]

Call_000_1ce2:
    jr nz, jr_000_1cf6

    bit 4, [hl]
    jr z, jr_000_1cf6

    push bc
    push hl
    call Call_000_1e36
    call Call_000_1e97
    pop de
    pop bc
    jr c, jr_000_1d01

jr_000_1cf4:
    ld h, d
    ld l, e

jr_000_1cf6:
    ld a, l
    add $20
    ld l, a
    dec b
    jr nz, jr_000_1ce0

    ld a, $01
    rst $00
    ret


jr_000_1d01:
    push bc
    ld c, $05
    rst $08
    pop bc
    cp $28
    jr z, jr_000_1cf4

    cp $54
    jr z, jr_000_1cf4

    cp $59
    jr z, jr_000_1cf4

    cp $81
    jr z, jr_000_1cf4

    cp $84
    jr z, jr_000_1cf4

    cp $ac
    jr z, jr_000_1cf4

    cp $ae
    jr z, jr_000_1cf4

    cp $24
    jr nz, jr_000_1d28

    set 1, [hl]

jr_000_1d28:
    cp $71
    jr c, jr_000_1d35

    cp $81
    jr nc, jr_000_1d35

    bit 2, a
    jp nz, Jump_000_1dd9

jr_000_1d35:
    ld c, $17
    rst $08
    ld c, a
    inc a
    jr nz, jr_000_1d51

    ld a, [$c1ef]
    or a
    jp z, Jump_000_1dd9

    ld a, [$c1e3]
    or a
    jp nz, Jump_000_1dd9

    ld a, [$c1f0]
    or a
    jp nz, Jump_000_1dd9

jr_000_1d51:
    ld a, $80
    ld [de], a
    ld a, c
    cp $0f
    jr z, jr_000_1d5e
    ld a, $05
    call DrawScore3

jr_000_1d5e:
    ld a, $09
    ld [EventSound], a
    ld c, $07
    rst $08
    or $10
    rst $10
    ld a, $04
    ld [$c1e4], a
    ld a, [WeaponSelect2]
    add a
    jr nz, jr_000_1d76

    ld a, $02

jr_000_1d76:
    inc a
    ld d, a
    ld a, [DifficultyMode]
    or a
    jr z, jr_000_1d80

    sla d

jr_000_1d80:
    ld c, $17
    rst $08
    cp $ff
    jr z, jr_000_1ddd

    ld b, a
    and $0f
    jr z, jr_000_1da2

    cp $0f
    jr z, jr_000_1d9c

    sub d
    jr c, jr_000_1da2

    jr z, jr_000_1da2

    ld e, a
    ld a, b
    and $f0
    or e
    rst $10
    ret


jr_000_1d9c:
    ld a, $40
    ld c, $0a
    rst $10
    ret


jr_000_1da2:
    xor a
    ld [$c1e4], a
    inc a
    rst $00
    ld a, b
    swap a
    and $0f
    jr z, jr_000_1dbf

    jp Jump_000_1afb


jr_000_1db2:
    ld l, a
    ld a, $0f
    ld [$c1e2], a
    xor a
    ld c, $17
    rst $10
    or $10
    ld [hl], a

jr_000_1dbf:
    set 6, [hl]
    ld a, $11
    ld c, $0c
    rst $10
    ld c, $09
    ld a, $01
    rst $10
    ld c, $07
    rst $08
    and $f0
    ld b, a
    ld a, [$c146]
    and $0f
    or b
    rst $10
    ret


Jump_000_1dd9:
    ld a, $80
    ld [de], a
    ret


jr_000_1ddd:
    call Call_000_3c60
    ld a, [$c1e2]
    sub d
    jr c, jr_000_1dea

    ld [$c1e2], a
    ret nz

jr_000_1dea:
    xor a
    ld [$c1e2], a
    ld a, [NextLevel]
    cp $06
    jr nz, jr_000_1e15

    ld a, [$c1eb]
    inc a
    jr z, jr_000_1e05

    ld a, $ff
    ld [$c1eb], a
    ld a, [$c1ee]
    jr jr_000_1db2

jr_000_1e05:
    ld a, [$c1ea]
    inc a
    jr z, jr_000_1e15

    ld a, $ff
    ld [$c1ea], a
    ld a, [$c1ed]
    jr jr_000_1db2

jr_000_1e15:
    ld a, $01
    call DrawScore2
    set 6, [hl]
    ld a, $0c
    ld [EventSound], a
    ld a, $60
    ld [$c1e3], a
    ld a, [NextLevel]
    cp $02
    ret nz

    ld a, $13
    ld c, $0d
    rst $10
    inc c
    ld a, $19
    rst $10
    ret


Call_000_1e36:
    ld a, [BgScrollYLsb]
    ld d, a
    ld a, [BgScrollXLsb]
    ld e, a
    ld c, $01
    rst $08
    sub d
    ld d, a
    inc c

Jump_000_1e44:
    inc c
    rst $08
    sub e
    ld e, a
    ld c, $0f
    rst $08
    or a
    ret z

    push af
    dec a
    add a
    add a
    ld hl, $7f90
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl+]
    add e
    ld c, a
    ld a, [hl+]
    add d
    ld b, a
    ld a, [hl+]
    add e
    ld e, a
    ld a, [hl+]
    add d
    ld d, a
    pop af
    ld hl, $c1b2
    push hl
    ld [hl+], a
    ld [hl], c
    inc hl
    ld [hl], b
    inc hl
    ld [hl], e
    inc hl
    ld [hl], d
    pop de
    ret


Call_000_1e73:
    call Call_000_1aeb
    ld bc, $0820
    ld hl, $c200

jr_000_1e7c:
    push bc
    call Call_000_1ec1
    pop bc
    jr nc, jr_000_1e8f

    bit 5, [hl]
    ret z

    push bc
    push de

Call_000_1e88:
    call Call_000_1a09
    pop de
    pop bc
    scf
    ret nz

jr_000_1e8f:
    ld a, l
    add c
    ld l, a
    dec b
    jr nz, jr_000_1e7c

    and a
    ret


Call_000_1e97:
    ld bc, $0020
    ld hl, $c200
    ld a, [TimeCounter]
    and $03
    jr z, jr_000_1ea8

jr_000_1ea4:
    add hl, bc
    dec a
    jr nz, jr_000_1ea4

jr_000_1ea8:
    call Call_000_1ec1
    ret c

    ld a, l
    add $80
    ld l, a
    jr jr_000_1ec1

Call_000_1eb2:
    ld hl, $c380
    ld a, [TimeCounter]
    rra
    jr nc, jr_000_1eca

    ld hl, $c3a0
    and a
    jr jr_000_1eca

Call_000_1ec1:
jr_000_1ec1:
    and a
    bit 5, [hl]
    jr nz, jr_000_1eca

    bit 6, [hl]
    jr nz, jr_000_1ed9

jr_000_1eca:
    bit 4, [hl]
    jr z, jr_000_1ed9

    bit 7, [hl]
    jr nz, jr_000_1ed9

    push de
    push hl
    call Call_000_1edd
    pop hl
    pop de

jr_000_1ed9:
    ld a, $01
    rst $00
    ret


Call_000_1edd:
    ld c, $07
    rst $08
    and $80

Jump_000_1ee2:
    ret nz

    ld c, $12
    rst $08
    cp $ad
    ret z

    ld a, [de]
    inc de
    push de
    push af
    ld a, [BgScrollYLsb]
    ld d, a
    ld a, [BgScrollXLsb]
    ld e, a
    ld c, $01
    rst $08
    sub d
    ld d, a
    inc c
    inc c
    rst $08
    sub e
    ld e, a
    ld c, $0f
    rst $08
    pop bc
    or a
    jr z, jr_000_1f48

    cp $02
    jr nz, jr_000_1f10

    ld c, a
    ld a, b
    or a
    jr nz, jr_000_1f48

    ld a, c

jr_000_1f10:
    dec a
    add a
    add a
    ld hl, $7f90
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl+]
    add e
    ld c, a
    ld a, [hl+]
    add d
    ld b, a
    ld a, [hl+]
    add e
    ld e, a
    ld a, [hl+]
    add d
    ld d, a
    bit 7, d
    jr nz, jr_000_1f30

    bit 7, b
    jr z, jr_000_1f30

    ld b, $00

jr_000_1f30:
    bit 7, e
    jr nz, jr_000_1f3a

    bit 7, c
    jr z, jr_000_1f3a

    ld c, $00

jr_000_1f3a:
    pop hl
    ld a, [hl+]

Jump_000_1f3c:
    cp e
    ret nc

    ld a, [hl+]
    cp d
    ret nc

    ld a, c
    cp [hl]
    ret nc

    inc hl
    ld a, b
    cp [hl]
    ret


jr_000_1f48:
    pop de
    ret


Call_000_1f4a:
    ld a, [$c1cd]
    or a
    ret nz

    ld a, [$c1ce]
    or a
    ret nz

    ld a, [$c1cf]
    or a
    ret nz

    ld a, [HeadSpriteIndex]
    ld c, a
    ld a, [$c190]
    cp c
    jr nz, jr_000_1f78

    ld a, [$c1dc]
    and $80
    jp nz, $5325

    call Call_000_226b
    call $22d1
    call $51d9
    ret c

    jp Jump_000_211b


Call_000_1f78:
jr_000_1f78:
    ld a, $02
    rst $00
    ld a, [$c18b]
    or a
    call z, $40e8
    ld a, [$c193]
    ld e, a
    ld a, [$c194]
    ld d, a
    ld hl, $c195
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld b, $04
    ld a, [$c18c]
    ld c, a

jr_000_1f96:
    ld a, [hl+]
    sub $02
    jr nz, jr_000_1fa4

jr_000_1f9b:
    dec c
    jr nz, jr_000_1f96

    jr jr_000_1fc4

    pop hl
    pop bc
    jr jr_000_1f9b

jr_000_1fa4:
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
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    call CopyToOam
    pop hl
    pop bc
    dec c
    jr z, jr_000_1fc4

    dec b
    jr nz, jr_000_1f96

jr_000_1fc4:
    ld a, 1
    rst $00             ; Load ROM bank 1.
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
    ret nz
    ld [$c18b], a
    ld a, [$c18f]
    ld [$c190], a
    ld a, [$c191]
    ld [$c192], a
    ld a, [$c16b]
    ld [$c16c], a
    ld a, [$c16d]
    ld c, a
    ld b, $00
    bit 7, c
    jr z, jr_000_1ffd
    dec b
jr_000_1ffd:
    xor a
    ld [$c16d], a
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, l
    ld [PlayerPositionXLsb], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ld a, [$c16e]
    ld c, a
    xor a
    ld [$c16e], a
    ld a, [PlayerPositionYLsb]
    add c
    ld [PlayerPositionYLsb], a
    ld a, [$c15b]
    and $03
    cp $03
    ret nz

    ld a, [$c15e]

Call_000_202a:
    ld [$c163], a
    jp $5181


; $2036: Copies 16 Bytes from [hl] to [de] with respect to the OAM flag.
CopyToOam16::
    ld c, $41
    ld b, STATF_OAM
    jr CopyToOamByte16

; $2036: Copies 32 Bytes from [hl] to [de] with respect to the OAM flag.
; Both "hl" and "de" are increased. Yes, the loop is unrolled.
CopyToOam::
    ld c, $41
    ld b, STATF_OAM
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 0.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 1.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 2.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 3.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 4.
    ld [de], a
    inc de
:   ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 5.
    ld [de], a
    inc de
:   ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 6
    ld [de], a
    inc de
:   ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 7.
    ld [de], a
    inc de
:   ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 8.
    ld [de], a
    inc de
:   ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 9.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 10.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 11.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 12.
    ld [de], a
    inc de
  : ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 13.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 14.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 15.
    ld [de], a
    inc de
CopyToOamByte16::
    ld a, [c]
    and b
    jr nz, CopyToOamByte16   ; Wait for OAM.
    ld a, [hl+]              ; Byte 16.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 17.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 18.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 19.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 20.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 21.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 22.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 23.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 24.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 25.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 26.
    ld [de], a
    inc de
:   ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 27.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
Jump_000_2102:                ; TODO: Maybe remove.
    ld a, [hl+]               ; Byte 28.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 29.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 30.
    ld [de], a
    inc de
 :  ld a, [c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 31.
    ld [de], a
    inc de
    ret

Call_000_211b:
Jump_000_211b:
    ld hl, $c19b
    ld a, [hl]
    or a
    ret z
    ld c, a
    ld a, $04
    rst $00
    ld a, c
    ld b, $00
    call Call_000_21dc
    ld a, [$c19f]
    ld e, a
    ld a, [$c1a0]
    ld d, a
    ld hl, $c1a1
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld b, $04
    ld a, [$c19d]
    ld c, a

jr_000_213f:
    ld a, [hl+]
    sub $02
    jr nz, jr_000_2149

    dec c
    jr nz, jr_000_213f

    jr jr_000_2172

jr_000_2149:
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
    ld hl, $c1a3
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, [$c1a5]
    add $05
    rst $00
    call CopyToOam
    ld a, $04
    rst $00
    pop hl
    pop bc
    dec c
    jr z, jr_000_2172

    dec b
    jr nz, jr_000_213f

jr_000_2172:
    ld a, $01
    rst $00
    ld a, l
    ld [$c1a1], a
    ld a, h
    ld [$c1a2], a
    ld a, e
    ld [$c19f], a
    ld a, d
    ld [$c1a0], a
    ld a, [$c19b]
    ld b, a
    ld a, c
    ld [$c19d], a
    or a
    ret nz

    ld [$c19b], a
    dec a
    ld [$c1a7], a
    ld a, b
    cp $80
    ret z

    ld h, $c2
    ld a, [$c19c]
    ld l, a
    ld c, $06
    rst $08
    cp $90
    jr nc, jr_000_21da

    ld c, $17
    rst $08
    inc a
    jr nz, jr_000_21c7

    ld a, [NextLevel]
    cp $02
    jr z, jr_000_21c7

    ld a, [$c1a6]
    ld c, $15
    rst $10
    inc c
    ld a, [$c19e]
    rst $10
    bit 5, [hl]
    jr z, jr_000_21d8

    res 0, [hl]
    jr jr_000_21da

jr_000_21c7:
    ld c, $06
    rst $08
    and $01
    ld b, a
    ld a, [$c1a6]
    or b
    rst $10
    ld a, [$c19e]
    ld c, $12
    rst $10

jr_000_21d8:
    res 3, [hl]

jr_000_21da:
    inc a
    ret


Call_000_21dc:
    cp $80
    jr z, jr_000_2219

    dec a
    ret nz

    dec a
    ld [hl+], a
    ld a, [hl]
    ld h, $c2
    ld l, a
    ld c, $11
    rst $08
    inc b
    bit 3, a
    jr z, jr_000_21f1

    inc b

jr_000_21f1:
    xor b
    rst $10
    ld [$c1a7], a
    and $07
    add a
    add a
    ld c, a
    add a
    add a
    add c
    add $18
    ld [$c1a6], a
    swap a
    ld b, a
    and $f0
    ld [$c19f], a
    ld a, b
    and $0f
    or $80
    ld [$c1a0], a
    ld c, $06
    rst $08
    and $01
    ld b, a

jr_000_2219:
    ld a, [$c19e]
    ld c, a
    ld hl, $7ae2
    add hl, bc
    ld a, [hl]
    ld e, a
    and $0f
    ld d, a
    ld a, e
    swap a
    and $0f
    ld e, a
    xor a

jr_000_222d:
    add e
    dec d
    jr nz, jr_000_222d

    ld [$c19d], a
    ld hl, $7e4e
    add hl, bc
    ld a, [hl]
    sub $07
    add a
    ld e, a
    ld hl, $7f72
    add hl, de
    ld a, [hl+]
    ld [$c1a3], a
    ld a, [hl]
    ld d, a
    and $3f
    add $40
    ld [$c1a4], a
    ld a, d
    rlca
    rlca
    and $03
    ld [$c1a5], a
    ld hl, $789a
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld hl, $72b1
    add hl, de
    ld a, l
    ld [$c1a1], a
    ld a, h
    ld [$c1a2], a
    ret


Call_000_226b:
    ld a, [$c1ba]
    or a
    ret z
    xor a
    ld [$c1ba], a
    ld a, 2
    rst $00                 ; Load ROM bank 2.
    call DrawHealth         ; Redraw health.
    ld a, $01

Jump_000_227c:
    rst $00
    ret

; ROM bank 3 is loaded before calling this function.
Call_000_227e:
    ld a, [NextLevel]
    cp $0a                      ; Level 10?
    jr nz, :+
    ld hl, CompressedTODOData26129
    ld de, $9e00
    jp DecompressTilesIntoVram
 :  cp $04
    ret c
    cp $06
    ret nc
    ld hl, $22b1
    ld de, $9e00
    ld b, $20
 :  push bc
    ld a, [hl+]
    push hl
    swap a
    ld b, $00
    ld c, a
    ld hl, TODOData60d9
    add hl, bc
    ld c, $10
    rst RST_38
    pop hl
    pop bc
    dec b
    jr nz, :-
    ret

    nop
    ld [bc], a
    inc b
    ld [bc], a
    ld bc, $0301
    inc bc
    ld [bc], a
    nop
    ld [bc], a
    inc b
    inc bc
    ld bc, $0301
    inc b
    ld [bc], a
    nop
    ld [bc], a
    inc bc
    inc bc
    ld bc, $0201
    inc b
    ld [bc], a
    nop
    ld bc, $0303
    ld bc, $0efa
    pop bc
    ld c, a
    cp $0a
    jr z, jr_000_22df

    cp $04
    ret c

    cp $06
    ret nc

jr_000_22df:
    ld a, [$c1e0]
    inc a
    and $07
    ld [$c1e0], a
    ret nz

    ld hl, $9e00
    ld a, c
    cp $0a
    ld a, [$c1e1]
    jr z, jr_000_230d

    inc a
    and $07
    ld [$c1e1], a
    ld b, $00
    swap a
    sla a
    rl b
    sla a
    rl b
    ld c, a
    add hl, bc
    ld de, $97c0
    jr jr_000_2321

jr_000_230d:
    inc a
    and $03
    ld [$c1e1], a
    ld b, a
    ld c, $00
    rr b
    rr c
    add hl, bc
    ld de, $9780
    call Call_000_2321

Call_000_2321:
jr_000_2321:
    call CopyToOam
    call CopyToOam
    xor a
    ret

; $2329: Sets up positions according to level and checkpoint.
; The positions are stored ROM bank 5 $4000.
; 8 bytes in total per level.
InitStartPositions:
    ld a, [CheckpointReached]
    ld c, a
    or a
    call nz, PositionFromCheckpoint      ; Load from checkpoint.
    ld a, [NextLevel]
    ld d, a
    dec a
    swap a
    add c
    ld b, 0
    ld c, a
Jump_000_233c:                  ; TODO: maybe remove.
    ld hl, $4000
    add hl, bc
    ld a, [hl+]
Jump_000_2341:                  ; TODO: maybe remove.
    ld [BgScrollXLsb], a        ; Start position background scroll x LSB.
    ldh [rSCX], a
    ld a, [hl+]
    ld [BgScrollXMsb], a        ; Start position background scroll x MSB.
    ld a, [hl+]
    ld [BgScrollYLsb], a        ; Start position background scroll y LSB.
    ldh [rSCY], a
    ld a, [hl+]
    ld [BgScrollYMsb], a        ; Start position background scroll y MSB.
    ld a, d
    cp $0c                      ; Next level 12?
    jr z, jr_000_236a
    ld a, [hl+]
    ld [PlayerPositionXLsb], a  ; Start position player X LSB.
    ld a, [hl+]
    ld [PlayerPositionXMsb], a  ; Start position player X MSB.
    ld a, [hl+]
    ld [PlayerPositionYLsb], a  ; Start position player Y LSB.
    ld a, [hl+]
    ld [PlayerPositionYMsb], a  ; Start position player Y MSB.
    ret

jr_000_236a:
    ld a, [BgScrollYLsb]
    ld [$c1c1], a
    ret

; $2371: Check if less than 20 seconds are left. If yes, play out of time sound.
CheckIfTimeRunningOut:
    ld a, [DigitMinutes]
    or a
    ret nz                        ; Continue if no minutes left.
    ld a, [SecondDigitSeconds]
    cp 2
    ret nc                        ; Continue if less than 20 seconds left.
    ld a, EVENT_SOUND_OUT_OF_TIME
    ld [EventSound], a            ; Play beep beep.
    ret

Call_000_2382:
    push bc
    push hl
    add a
    add a
    add a
    ld b, $00
    ld c, a
    ld hl, $c660
    add hl, bc
    ld a, [hl]
    and $04
    pop hl
    pop bc
    ret


; $2394
; ROM bank 1 should be loaded at this point.
; TODO: 12 bytes from $6782 for [$c1ad]
; TODO: 12 tile data pointers (24 bytes) from $678e:
; [$67a6, $697f, $6b8d, $6d4f, $7013, $72cd, $7537, $77e7, $79d5, $7bff, $7e43, $0000]
TODOFunc:
    ld a, [NextLevel]
    dec a
    ld b, 0
    ld c, a
    ld hl, TODOData6782
    add hl, bc
    ld a, [hl]                        ; Load something from [01:6782 + level].
    ld [$c1ad], a                     ; Store this in [$c1ad]
    sla c
    ld hl, CompressedDataLvlPointers  ; Load something from [01:678e + level * 2].
    add hl, bc
    ld a, [hl+]
    ld h, [hl]                        ; Load pointer into ah.
    ld l, a
    ld de, $d700
    ld a, e
    ld [$c1b0], a                     ; [$c1b0] = 0
    ld a, d
    ld [$c1b1], a                     ; [$c1b1] = $d7
    call DecompressTilesIntoVram      ; hl = [$678e + level * 2], de = $d700
    call Call_000_2569
    ld a, $80
    ld [$c380], a                     ; = $80 Seems to be related to ball projectiles from enemies.
    ld [$c3a0], a                     ; = $80
    ld a, $1e
    ld [$c1e2], a                     ; = $1e
    ld a, [$c14a]                     ; Usually 0. Goes $ff when dead.
    or a
    jr z, jr_000_2409
    ld a, [$c1ad]
    ld hl, $d700
    ld de, $c600

jr_000_23d9:
    push af
    ld a, [de]
    cp $89
    jr z, jr_000_23eb
    cp $9b
Jump_000_23e1:
    jr z, jr_000_23eb
    cp $9e
    jr z, jr_000_23eb
    and $08
    jr z, jr_000_23fc
jr_000_23eb:
    ld c, $05
    rst $28
    jr z, jr_000_23fe
    ld c, $17
    rst $08
    and $0f
    or $30
    rst $10
    ld a, $08
    jr jr_000_23fd
jr_000_23fc:
    xor a
jr_000_23fd:
    ld [de], a
jr_000_23fe:
    inc e
    ld bc, $0018
    add hl, bc
    pop af
    dec a
    jr nz, jr_000_23d9
    jr jr_000_2414

Call_000_2409:
jr_000_2409:
    ld a, [$c1ad]
    ld b, a
    inc b
    ld hl, $c600
    call MemsetZero2
jr_000_2414:
    ld hl, $c200
    ld b, $08
jr_000_2419:
    ld [hl], $80
    ld a, l
    add $20
    ld l, a
    dec b

Call_000_2420:
    jr nz, jr_000_2419
    ld hl, $c1a8
    ld b, $05
    jp MemsetZero2

Call_000_242a:
    cp $04
    jr nz, jr_000_2447
    ld a, $6c
    ld [$c19e], a
    ld a, $c0
    ld [$c19f], a
    ld a, $8a
    ld [$c1a0], a
    ld a, $80
    ld [$c19b], a
    call Call_000_211b
    jr jr_000_2476

jr_000_2447:
    ld c, $01
    cp $02
    jr z, jr_000_2471

    cp $05
    jr z, jr_000_2476

    cp $06
    jr z, jr_000_2471

    dec c
    cp $08
    jr z, jr_000_2471

    ld c, $5f
    cp $09
    jr z, jr_000_2471

    cp $0a
    jr nz, jr_000_248d

    ld hl, $7fb8
    ld de, $8ac0
    ld bc, $0020
    ld a, $06
    rst $00
    rst $38

jr_000_2471:
    ld a, $82
    add c
    jr jr_000_2478

jr_000_2476:
    ld a, $70

jr_000_2478:
    ld [$c19e], a
    ld a, $a0
    ld [$c19f], a
    ld a, $8c
    ld [$c1a0], a
    ld a, $80
    ld [$c19b], a
    call Call_000_211b

jr_000_248d:
    ld a, $05
    rst $00
    ld a, [NextLevel2]
    inc a
    cp $04
    jr c, jr_000_24a6

    and $01
    jr nz, jr_000_24a6

    ld hl, $5bdc
    ld de, $8c20
    ld bc, $0040
    rst $38

jr_000_24a6:
    ld a, [NextLevel]
    cp $04
    ret z

    cp $0b
    jr z, jr_000_24bb

    ld hl, $5cdc
    ld de, $8ae0
    ld bc, $0040
    rst $38
    ret


jr_000_24bb:
    ld hl, $5c1c
    ld de, $8b20
    ld c, $40
    rst $38
    ld e, $a0
    ld c, $80
    rst $38
    inc a
    rst $00
    ld b, $08
    ld a, b
    ld [$c1ff], a
    ld h, $63
    ld de, $d71d

jr_000_24d6:
    ldh a, [rDIV]
    add b
    and $07
    add $e2
    ld l, a
    ld a, [hl]
    ld [de], a
    ld a, e
    add $18
    ld e, a

Jump_000_24e4:
    dec b
    jr nz, jr_000_24d6

    ret


Call_000_24e8:
    ld hl, $c200
    ld b, $08

jr_000_24ed:
    bit 6, [hl]
    jr nz, jr_000_24fd

    bit 4, [hl]
    jr z, jr_000_24fd

    bit 5, [hl]
    jr z, jr_000_24fd

    bit 2, [hl]
    jr z, jr_000_2502

jr_000_24fd:
    push bc
    call $5fdf
    pop bc

Call_000_2502:
jr_000_2502:
    ld a, l
    add $20
    ld l, a
    dec b
    jr nz, jr_000_24ed

    call Call_000_393c
    ret z

    ld d, h
    ld e, l
    ld b, $03
    ld c, $00
    ld hl, $c1a9

jr_000_2516:
    ld a, [hl]
    or a
    jr z, jr_000_2521

    inc l
    inc c
    dec b
    jr nz, jr_000_2516

    ld c, $00

jr_000_2521:
    push de
    push bc
    ld hl, $7f60
    ld bc, $0018
    rst $38
    pop bc
    pop hl
    ld a, [$c1a7]
    srl a
    cp c
    jr nz, jr_000_253c

    xor a
    ld [$c19b], a
    dec a
    ld [$c1a7], a

jr_000_253c:
    ld a, c
    add a
    ld c, $11
    rst $10
    ld a, [PlayerPositionYLsb]
    sub $80
    ld e, a
    ld a, [PlayerPositionYMsb]
    sbc $00
    ld d, a
    ld c, $01
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    ld a, [PlayerPositionXLsb]
    sub $02
    push af
    inc c
    rst $10
    pop af
    ld a, [PlayerPositionXMsb]
    sbc $00
    inc c
    rst $10
    ld a, $4a
    ld [CurrentSong], a

; Starting from $c300, this function puts $80 into multiples of 32 for 4 times.
; Hence, {$c300, $c320, $c340, $c360} = $80
Call_000_2569:
    ld hl, $c300
    ld b, 4
 :  ld [hl], $80                ; Load $80 into $c300
    ld a, l
    add 32
    ld l, a                     ; hl = $c320
    dec b
    jr nz, :-                   ; Loops for 5 times.
    ret

Call_000_2578:
    call Call_000_2409
    ld hl, $7f60
    ld de, $c200
    ld bc, $0018
    rst $38
    ld a, [NextLevel2]
    cp $0a
    jr nz, jr_000_2593

    ld de, $c220
    ld bc, $0018
    rst $38

Jump_000_2593:
jr_000_2593:
    ld a, $28
    ld [PlayerPositionXLsb], a
    xor a
    ld [PlayerPositionXMsb], a
    ld [PlayerPositionYLsb], a
    ld [PlayerPositionYMsb], a
    ld [$c158], a
    ret


Call_000_25a6:
    ld a, [PlayerFreeze]
    or a
    ret nz

    ld a, [$c1ef]
    or a
    ret nz

    ld a, [$c1ad]
    or a
    ret z

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
    cp 5
    jr z, jr_000_25e5           ; Next level 5?
    cp 3
    jr nz, jr_000_25fb          ; Next level 3?
    ld b, $15
    jr jr_000_25e7
jr_000_25e5:
    ld b, $07
jr_000_25e7:
    ld a, [$c129]
    add $50
    ld [$c10a], a
    ld a, [$c12a]
    adc $00
    cp b
    jr c, jr_000_25f8
    sub b
jr_000_25f8:
    ld [$c10b], a
jr_000_25fb:
    ld hl, $c1b0
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$c1a8]
    ld b, $04
jr_000_2606:
    push bc
    push af
    ld c, a
    ld b, $c6
    ld a, [bc]
    bit 7, a
    jr nz, jr_000_2615

    push hl
    call Call_000_2632
    pop hl

jr_000_2615:
    ld bc, $0018
    add hl, bc
    pop af
    inc a
    pop bc
    cp c
    jr c, jr_000_2623

    ld hl, $d700
    xor a

jr_000_2623:
    dec b
    jr nz, jr_000_2606

    ld [$c1a8], a
    ld a, l
    ld [$c1b0], a
    ld a, h
    ld [$c1b1], a
    ret


Call_000_2632:
    ld a, [WindowScrollYLsb]
    ld e, a
    ld a, [WindowScrollYMsb]
    ld d, a
    ld a, [hl]
    ld [$c10c], a
    inc hl
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl+]
    sbc d
    ld d, a
    inc a
    cp $02
    jp nc, Jump_000_274c

    ld a, e
    xor d
    and $80
    jp nz, Jump_000_274c

    ld a, [$c10c]
    and $27
    cp $26
    jr nz, jr_000_2678

    ld a, [$c10a]
    ld e, a
    ld a, [$c10b]
    ld d, a
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl+]
    sbc d
    ld d, a
    inc a
    cp $02
    jp nc, Jump_000_274c

    ld a, e
    xor d
    and $80
    jp nz, Jump_000_274c

    jr jr_000_2695

jr_000_2678:
    ld a, [WindowScrollXLsb]
    ld e, a
    ld a, [WindowScrollXMsb]
    ld d, a
    ld a, [hl+]
    sub e
    ld e, a
    ld a, [hl+]
    sbc d
    ld d, a
    inc a
    cp $02
    jp nc, Jump_000_274c

    ld a, e
    xor d
    and $c0
    cp $c0
    jp z, Jump_000_274c

jr_000_2695:
    ld a, [bc]
    bit 4, a
    ret nz

    xor a
    ld de, $c200

jr_000_269d:
    push af
    ld a, [de]
    and $80
    jr nz, jr_000_26ae

    ld a, e
    add $20
    ld e, a
    pop af
    inc a
    cp $08
    jr c, jr_000_269d

    ret


jr_000_26ae:
    inc hl
    ld a, [hl-]
    cp $90
    jr nc, jr_000_2710

    ld a, [hl]
    push bc
    push hl
    push af
    cp $28
    jr z, jr_000_26ce

    cp $2c
    jr nz, jr_000_26da

    ld a, [NextLevel]
    cp $06
    jr nz, jr_000_26da

    ld c, $08
    ld hl, $c1ac
    jr jr_000_26f0

jr_000_26ce:
    ld hl, $c1a9
    ld b, $03

jr_000_26d3:
    cp [hl]
    jr z, jr_000_26eb

    inc l
    dec b
    jr nz, jr_000_26d3

jr_000_26da:
    ld hl, $c1a9
    ld b, $03
    ld c, $00

jr_000_26e1:
    ld a, [hl]
    or a
    jr z, jr_000_26f0

    inc c
    inc c
    inc l
    dec b
    jr nz, jr_000_26e1

jr_000_26eb:
    pop af
    pop hl
    pop bc
    pop af
    ret


jr_000_26f0:
    pop af
    ld [hl], a
    pop hl
    ld a, c
    push af
    ld a, l
    sub $05
    ld l, a
    ld bc, $0018
    push de
    rst $38
    pop hl
    pop af
    ld c, $11
    rst $10
    pop bc
    pop af
    set 4, a
    ld d, a
    ld a, [bc]
    or d
    ld [bc], a
    ld a, c
    ld c, $10
    rst $10
    ret


jr_000_2710:
    ld a, [hl]
    cp $ac
    jr nz, jr_000_2734

    push bc
    push hl
    ld hl, $c200
    ld b, $08

jr_000_271c:
    bit 7, [hl]
    jr nz, jr_000_272b

    push hl
    ld a, l
    add $05
    ld l, a
    ld a, [hl]
    cp $ac
    jr z, jr_000_26eb

    pop hl

jr_000_272b:
    ld a, l
    add $20
    ld l, a
    dec b
    jr nz, jr_000_271c

    pop hl
    pop bc

jr_000_2734:
    ld a, l
    sub $05
    ld l, a
    push bc
    ld bc, $0018
    push de
    rst $38
    pop hl
    pop bc
    pop af
    set 4, a
    ld d, a
    ld a, [bc]
    or d
    ld [bc], a
    ld a, c
    ld c, $10
    rst $10
    ret


Jump_000_274c:
    ld a, [bc]
    bit 4, a
    ret z

    and $07
    swap a
    add a
    ld d, $c2
    ld e, a
    ld a, [de]
    and $10
    ret nz

    ld a, [bc]
    and $08
    ld [bc], a
    ld a, $80
    ld [de], a
    ld a, e
    add $06
    ld e, a
    ld a, [de]
    cp $90
    ret nc

    ld a, e
    add $0b
    ld e, a
    ld a, [de]
    bit 3, a
    jr z, jr_000_2776

    ld a, $06

jr_000_2776:
    srl a
    ld b, $00
    ld c, a
    ld hl, $c1a9
    add hl, bc
    ld [hl], b
    ret


Call_000_2781:
    ld bc, $0820
    ld hl, $c200

jr_000_2787:
    push bc
    call Call_000_27ab
    pop bc
    ld a, l
    add c
    ld l, a
    dec b
    jr nz, jr_000_2787

    ld hl, $c300
    ld b, $04
    call Call_000_279f
    ld hl, $c380
    ld b, $02

Call_000_279f:
jr_000_279f:
    push bc
    call $5bc4
    pop bc
    ld a, l
    add c
    ld l, a
    dec b
    jr nz, jr_000_279f

    ret


Call_000_27ab:
    bit 7, [hl]
    ret nz

    call Call_000_2ce0
    call Call_000_2b94
    ld a, [PlayerFreeze]
    or a
    call nz, Call_000_31b2
    ld c, $09
    rst $08
    or a
    ret z

    ld d, a
    inc c
    rst $20
    jr z, jr_000_27db

    ld c, $05
    rst $08
    cp $54
    jp z, Jump_000_29c3

    cp $4f
    jp z, Jump_000_288d

    cp $47
    ret nz

    bit 1, [hl]
    ret z

    jp Jump_000_288d


jr_000_27db:
    ld a, d
    rst $10
    ld a, [PlayerFreeze]
    or a
    jr nz, jr_000_27e9

    call Call_000_31b2
    call Call_000_3152

jr_000_27e9:
    ld c, $07
    rst $08
    and $0f
    jp z, Jump_000_29c3

    bit 3, a
    jr z, jr_000_27f7

    or $f0

jr_000_27f7:
    ld c, a
    push bc
    ld c, $03
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    pop bc
    bit 7, c
    jr nz, jr_000_281c

    ld a, e
    add c
    ld e, a
    jr nc, jr_000_280b

    inc d

jr_000_280b:
    bit 6, [hl]
    jr nz, jr_000_2858

    ld c, $14
    rst $28
    call z, Call_000_288e
    bit 5, [hl]
    call nz, Call_000_297d
    jr jr_000_2831

jr_000_281c:
    ld a, e
    add c
    ld e, a
    jr c, jr_000_2822

    dec d

jr_000_2822:
    bit 6, [hl]
    jr nz, jr_000_2858

    ld c, $13
    rst $28
    call z, Call_000_288e
    bit 5, [hl]
    call nz, Call_000_29a0

jr_000_2831:
    ld c, $05
    rst $08
    cp $71
    jr c, jr_000_2858

    cp $81
    jr nc, jr_000_2858

    ld a, e
    ld c, $15
    rst $28
    jr z, jr_000_2849

    inc c
    rst $28
    jr nz, jr_000_2858

    call Call_000_2968

jr_000_2849:
    ld c, $05
    rst $08
    xor $04
    rst $10
    and $04
    jr z, jr_000_2858

    ld a, $20
    ld c, $0a
    rst $10

jr_000_2858:
    ld c, $03
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    bit 6, [hl]
    jp nz, Jump_000_29c3

    ld c, $05
    rst $08
    cp $4f
    jr z, jr_000_288d

    cp $71
    jp c, Jump_000_29c3

    cp $81
    jp nc, Jump_000_29c3

    and $04
    ret z

    ld c, $03
    ld a, [NextLevel]
    cp $02
    jr z, jr_000_2887

    cp $06
    jr z, jr_000_2887

    ld c, $01

jr_000_2887:
    ld a, e
    and c
    ret nz

    jp Jump_000_29c3


Jump_000_288d:
jr_000_288d:
    push af

Call_000_288e:
    ld c, $05
    rst $08
    cp $0f
    jp z, Jump_000_2b2e

    cp $28
    jp z, Jump_000_296f

    cp $59
    ret z

    cp $cd
    ret z

    cp $ac
    jr z, jr_000_28d6

    cp $71

Jump_000_28a7:
    jr z, jr_000_28d6

    cp $47
    jr nz, jr_000_28df

    pop af
    bit 4, [hl]
    jr z, jr_000_2928

    bit 1, [hl]
    jr nz, jr_000_2922

    set 1, [hl]
    ld a, $4f
    rst $10
    ld a, $10
    ld c, $0b
    rst $10
    ld a, $01
    inc c
    rst $10
    ld a, $07
    ld c, $0d
    rst $10
    ld c, $03
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    ld a, $02
    ld c, $09
    rst $10
    ret


jr_000_28d6:
    ld a, [$c1ef]
    or a
    jr z, jr_000_2945

    jp $5fdf


jr_000_28df:
    cp $4f
    jr nz, jr_000_2945

    pop af
    bit 4, [hl]
    jr z, jr_000_2919

    ld c, $0d
    rst $08
    ld d, a
    ld e, $02
    and $03
    jr z, jr_000_2909

    ld e, $03
    and $01
    jr nz, jr_000_2909

    ld e, $04
    dec c
    rst $08
    cp $08
    jr nz, jr_000_2909

    ld c, $07
    rst $08
    xor $20
    rst $10
    call Call_000_2945

jr_000_2909:
    ld a, e
    ld c, $09
    rst $10
    ld a, d
    cp $04
    ret nz

    ld c, $0c
    rst $08
    cp $01
    ret nz

    inc c
    rst $10

jr_000_2919:
    ld a, $47
    ld c, $05
    rst $10
    bit 4, [hl]
    jr z, jr_000_2928

jr_000_2922:
    ld c, $12
    rst $08
    cp $4f
    ret nc

jr_000_2928:
    res 1, [hl]
    ld a, $06
    ld c, $0b
    rst $10
    ld c, $07
    rst $08
    ld d, a
    and $08
    rla
    rla
    ld e, a
    ld a, d
    and $df
    or e
    rst $10
    ld a, $01
    ld c, $09
    rst $10
    bit 4, [hl]
    ret nz

Call_000_2945:
Jump_000_2945:
jr_000_2945:
    ld c, $07
    rst $08
    ld b, a
    and $0f
    bit 3, a
    jr z, jr_000_2951

    or $f0

jr_000_2951:
    cpl
    inc a
    and $0f
    ld c, a
    ld a, b
    and $f0
    xor $20
    or c
    ld c, $07
    rst $10
    ld c, $05
    rst $08
    cp $71
    ret c

    cp $81
    ret nc

Call_000_2968:
    ld c, $08
    rst $08
    cpl
    inc a
    rst $10
    ret


Jump_000_296f:
    ld c, $07
    rst $08
    and $f0
    rst $10
    ld a, [$c1ef]
    or a
    ret z

    jp $5fdf


Call_000_297d:
    ld a, [$c158]
    cp $29
    jr z, jr_000_298b

    cp $2a
    jr z, jr_000_298b

    cp $2b
    ret nz

jr_000_298b:
    push de
    push hl
    ld a, [$c149]
    push af
    ld a, $ff
    ld [$c149], a
    call Call_000_085e
    pop af
    ld [$c149], a
    pop hl
    pop de
    ret


Call_000_29a0:
    ld a, [$c158]
    cp $29
    jr z, jr_000_29ae

    cp $2a
    jr z, jr_000_29ae

    cp $2b
    ret nz

jr_000_29ae:
    push de
    push hl
    ld a, [$c149]
    push af
    ld a, $ff
    ld [$c149], a
    call Call_000_094a
    pop af
    ld [$c149], a
    pop hl
    pop de
    ret


Jump_000_29c3:
    ld c, $08
    rst $08
    or a
    ret z

    ld c, a
    push bc
    ld c, $01
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    pop bc
    bit 7, c
    jr nz, jr_000_29de

    ld a, e
    add c
    ld e, a

Jump_000_29d9:
    jr nc, jr_000_29e4

    inc d
    jr jr_000_29e4

jr_000_29de:
    ld a, e
    add c
    ld e, a
    jr c, jr_000_29e4

    dec d

jr_000_29e4:
    ld c, $01
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    ld c, $05
    rst $08
    cp $59
    jr z, jr_000_2a42

    bit 5, [hl]
    jr nz, jr_000_29fe

    cp $ae
    jr z, jr_000_2a5a

    cp $0f
    jr z, jr_000_2a72

jr_000_29fe:
    bit 6, [hl]
    jr nz, jr_000_2a15

    cp $28
    jr z, jr_000_2a09

    cp $ae
    ret nz

jr_000_2a09:
    ld a, e
    cp $f0
    jr z, jr_000_2a10

    or a
    ret nz

jr_000_2a10:
    xor a
    ld c, $08
    rst $10
    ret


jr_000_2a15:
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, e
    sub c
    cp $90
    ret c

    cp $c0
    ret nc

    ld c, $05
    rst $08
    cp $54
    ret z

    cp $6d
    ret z

    cp $ae
    jr nz, jr_000_2a39

    ld a, d
    cp $02
    ret nz

    xor a
    ld c, $08
    rst $10
    res 6, [hl]

Call_000_2a38:
    ret


jr_000_2a39:
    ld c, $0f
    rst $08
    cp $02
    ret z

    jp $5fdf


jr_000_2a42:
    ld c, $08
    rst $08
    and $80
    ld a, e
    ld c, $13
    jr nz, jr_000_2a4d

    inc c

jr_000_2a4d:
    rst $28
    ret nz

    xor a
    ld c, $08
    rst $10
    ld a, e
    inc a
    ret nz

    ld c, $0b
    rst $10
    ret


jr_000_2a5a:
    ld a, e
    ld c, $14
    rst $28
    ret c

    rst $08
    ld c, $01
    rst $10
    xor a
    ld c, $08
    rst $10
    ld c, $0e
    rst $10
    res 6, [hl]
    push hl
    call $52f6
    pop hl
    ret


jr_000_2a72:
    ld a, e
    add $1c
    ld e, a
    ld a, d
    adc $00
    ld d, a
    ld c, $0d
    rst $08
    ld c, a
    push hl
    ld hl, $63d9
    add hl, bc
    ld c, [hl]
    pop hl
    push bc
    ld c, $08
    rst $08
    pop bc
    and $80
    jr nz, jr_000_2ae4

    ld a, [NextLevel]
    cp $0c
    jp z, Jump_000_2b04

    ld a, [BgScrollXLsb]
    ld c, $03
    ld b, a
    push bc
    rst $08
    pop bc
    sub b
    ld b, a
    ld a, [$c144]
    sub $02
    cp b
    jr z, jr_000_2aba

    jr nc, jr_000_2ab5

    rst $08
    dec a
    rst $10
    inc a
    jr nz, jr_000_2aba

    inc c
    rst $20
    jr jr_000_2aba

jr_000_2ab5:
    rst $18
    jr nz, jr_000_2aba

    inc c
    rst $18

jr_000_2aba:
    ld a, [PlayerPositionYMsb]
    cp d
    ret nz

    ld a, [PlayerPositionYLsb]
    cp e
    ret nz

    ld a, $ff
    ld c, $08
    rst $10
    xor a
    ld [$c15e], a
    ld [$c13b], a
    inc a
    ld [$c169], a
    ld [$c160], a
    ld a, $20
    ld [$c15f], a
    dec c
    rst $10
    ld a, $3e
    ld [HeadSpriteIndex], a
    ret


jr_000_2ae4:
    ld a, e
    sub c
    ld [PlayerPositionYLsb], a
    ld a, d
    sbc $00
    ld [PlayerPositionYMsb], a
    ld a, [$c145]
    cp $c0
    ret c

    ld a, $0a
    ld [$c1c9], a
    ld a, $0b
    ld [CurrentLevel], a
    xor a
    ld c, $08
    rst $10
    ret


Jump_000_2b04:
    ld a, e
    cp $50
    jr z, jr_000_2b14

    sub c
    ld [PlayerPositionYLsb], a
    ld a, d
    sbc $00
    ld [PlayerPositionYMsb], a
    ret


jr_000_2b14:
    ld a, $21
    ld c, $07
    rst $10
    xor a
    inc c
    rst $10
    ld [$c169], a
    inc a
    ld [$c151], a
    ld a, 4
    ld [CrouchingHeadTilted], a         ; = 4
    ld a, $ff
    ld [LandingAnimation], a            ; = $ff
    ret


Jump_000_2b2e:
    pop af
    ld a, [$c1e6]
    or a
    ret nz

    ld a, [$c1e5]
    and $ef
    jr nz, jr_000_2b3f

    ld d, $9d
    jr jr_000_2b59

jr_000_2b3f:
    cp $02
    jr nz, jr_000_2b47

    ld d, $89
    jr jr_000_2b59

jr_000_2b47:
    cp $04
    ret nz

    ld d, $9e
    ld b, a
    ld a, [BonusLevel]
    or a
    ld a, b
    jr nz, jr_000_2b59

    inc a
    ld [$c1e5], a
    ret


jr_000_2b59:
    inc a
    or $80
    ld [$c1e5], a
    ld [$c1e6], a
    push de
    push hl
    ld hl, $7ee8
    ld de, $c240
    ld bc, $0018
    push de
    rst $38
    pop de
    pop hl
    ld a, $40
    ld [de], a
    inc e
    ld c, $01
    rst $08
    add $08
    ld [de], a
    inc e
    inc c
    rst $08
    ld [de], a
    inc e
    inc c
    rst $08
    add $02
    ld [de], a
    inc e
    inc c
    rst $08
    ld [de], a
    inc e
    pop af
    ld [de], a
    ld a, e
    add $0f
    ld e, a
    ld a, $80
    ld [de], a
    ret


Call_000_2b94:
    ld c, $05
    rst $08
    cp $84
    jr z, jr_000_2c13

    cp $ae
    jr z, jr_000_2c13

    cp $9a
    jr c, jr_000_2ba8

    cp $9e
    jp c, Jump_000_2cc1

jr_000_2ba8:
    cp $59
    jp z, Jump_000_2c67

    cp $81
    jp z, Jump_000_2c8f

    cp $24
    ret nz

    ld c, $16
    rst $08
    inc a
    and $1f
    rst $10
    ld c, a
    and $06
    swap a
    ld d, a
    push hl
    ld hl, $63c9
    ld a, c
    srl c
    add hl, bc
    rra
    ld a, [hl]
    jr c, jr_000_2bd0

    swap a

jr_000_2bd0:
    and $0f
    bit 3, a
    jr z, jr_000_2bd8

    or $f0

jr_000_2bd8:
    pop hl
    bit 1, [hl]
    jr z, jr_000_2bde

    add a

jr_000_2bde:
    ld c, $01
    rst $30
    rst $10
    ld c, $07
    rst $08
    and $9f
    or d
    rst $10
    bit 1, [hl]
    ret z

    ld a, d
    or a
    ret nz

    ld a, [$c145]
    sub $10
    ld e, a
    ld a, [BgScrollYLsb]
    ld d, a
    ld c, $01
    rst $08
    sub d
    cp $78
    ret nc

    cp e
    ret z

Call_000_2c02:
    jr nc, jr_000_2c0b

    rst $08
    inc a
    rst $10
    ret nz

    inc c
    rst $18
    ret


jr_000_2c0b:
    rst $08
    dec a
    rst $10
    inc a
    ret nz

    inc c
    rst $20
    ret


jr_000_2c13:
    bit 5, [hl]
    ret z

    cp $84
    jr z, jr_000_2c29

    ld c, $16
    rst $08
    or a
    ret z

    rst $20
    ret nz

jr_000_2c21:
    set 6, [hl]
    ld a, $02
    ld c, $09
    rst $10
    ret


jr_000_2c29:
    ld c, $16
    rst $08
    or a
    jr z, jr_000_2c4a

    dec a
    rst $10
    or a
    jr z, jr_000_2c5f

    cp $18
    ret nc

    rra
    and $01
    ld [$c13b], a
    set 1, [hl]
    ld c, a
    ld a, [$c1fa]
    cp l
    ret nz

    ld a, c
    ld [$c13e], a
    ret


jr_000_2c4a:
    dec c
    rst $08
    or a
    ret z

    dec a
    rst $10
    and $02
    add a
    add a
    swap a
    ld d, a
    ld c, $07
    rst $08
    and $7f
    or d
    rst $10
    ret


jr_000_2c5f:
    ld [$c13b], a
    ld [$c13e], a
    jr jr_000_2c21

Jump_000_2c67:
    ld a, [$c12f]
    ld d, a
    ld c, $03
    rst $08
    sub d
    cp $6e
    jr z, jr_000_2c7c

    cp $ae
    ret nz

    ld a, $ff
    ld c, $08
    rst $10
    ret


jr_000_2c7c:
    ld c, $01
    rst $08
    cp $f8
    ret nc

    ld a, $01
    ld c, $08
    rst $10
    inc c
    rst $10
    ld a, $08
    ld [$c1e9], a
    ret


Jump_000_2c8f:
    ld c, $16
    rst $08
    dec a
    rst $10
    ld d, a
    cp $0c
    ret nc

    and $02
    xor $02
    rrca
    rrca
    ld e, a
    ld c, $07

Call_000_2ca1:
    rst $08
    and $7f
    or e
    rst $10
    ld a, $02
    ld c, $0a
    rst $10
    ld a, d
    or a
    ret nz

    ld a, [$c1ef]
    or a
    jr z, jr_000_2cb7

    set 7, [hl]
    ret


jr_000_2cb7:
    ldh a, [rLY]
    and $7f
    add $20
    ld c, $16
    rst $10
    ret


Jump_000_2cc1:
    ld a, [$c1f9]
    or a
    ret z

    dec a
    ld [$c1f9], a
    jr nz, jr_000_2ccf

    set 7, [hl]
    ret


jr_000_2ccf:
    cp $40
    ret nc

    and $04
    add a
    swap a
    ld d, a
    ld c, $07
    rst $08
    and $7f
    or d
    rst $10
    ret


Call_000_2ce0:
    ld c, $0b
    rst $08
    ld d, a
    or a
    ret z

    ld c, $17
    rst $08
    inc a
    jp z, Jump_000_3382

    bit 4, [hl]
    ret z

    bit 6, [hl]
    ret nz

    bit 3, [hl]
    jr nz, jr_000_2d12

    ld c, $0c
    rst $20
    ret nz

    ld a, d
    rst $10
    inc c
    rst $08
    inc a
    inc c
    rst $28
    dec c
    jr c, jr_000_2d06

    xor a

jr_000_2d06:
    rst $10
    ld d, a
    ld c, $06
    rst $08
    cp $90
    ret nc

    set 3, [hl]
    jr jr_000_2d16

jr_000_2d12:
    ld c, $0d
    rst $08
    ld d, a

jr_000_2d16:
    ld a, [$c19b]
    or a
    ret nz

    inc a
    ld [$c19b], a
    ld c, $05
    rst $08
    ld e, a
    bit 2, [hl]
    jp nz, Jump_000_2dee

    add d
    ld [$c19e], a
    ld a, l
    ld [$c19c], a
    ld a, [hl]
    and $07
    jp nz, Jump_000_2f38

    ld a, d
    or a
    jr z, jr_000_2d51

    ld a, d
    add a
    add a
    add d
    ld c, $0c
    rst $10
    ld a, d
    cp $01
    ret nz

    ld a, e
    cp $e2
    ret z

    cp $6d
    jp z, Jump_000_30ac

    jp Jump_000_3016


jr_000_2d51:
    ld c, $05
    rst $08
    cp $6d
    jp z, Jump_000_310f

    cp $a4
    ret z

    cp $e2
    ret z

    ld c, $01
    rst $08
    ld b, a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, b
    sub c
    add $20
    ld b, a
    ld a, [$c145]
    cp b
    push af
    ld c, $03
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld a, [PlayerPositionXLsb]
    sub e
    ld e, a
    ld a, [PlayerPositionXMsb]
    sbc d
    ld d, a
    pop af
    jr c, jr_000_2d92

    ld a, e
    bit 7, d
    jr z, jr_000_2d8c

    cpl
    inc a

jr_000_2d8c:
    cp $20
    ld a, $a2
    jr c, jr_000_2d94

jr_000_2d92:
    ld a, $a9

jr_000_2d94:
    ld c, $05
    rst $10
    ld [$c19e], a
    ld e, $02
    cp $a2
    jr z, jr_000_2da7

    ld e, $03
    xor a
    bit 7, d
    jr z, jr_000_2da9

jr_000_2da7:
    ld a, $20

jr_000_2da9:
    ld d, a
    ld c, $07
    rst $08
    and $df
    or d
    rst $10
    ld a, e
    ld c, $0e
    rst $10
    ld c, $16
    rst $08
    or a
    ret z

    ld a, [TimeCounter]
    and $0f
    add $0c
    rst $10
    set 0, [hl]
    ld a, $05
    ld c, $05
    rst $10
    ld [$c19e], a
    ld c, $07
    rst $08
    and $df
    ld b, a
    and $02
    swap a
    or b
    rst $10
    ld a, $01
    ld c, $09
    rst $10
    ld c, $0c
    rst $10
    ld a, $04
    dec c
    rst $10
    ld a, $06
    ld c, $0e
    rst $10
    ld a, $04
    inc c
    rst $10
    ret


Jump_000_2dee:
    ld a, e
    cp $98
    jr nz, jr_000_2e13

    ld a, d
    or a
    jr z, jr_000_2df9

    ld a, $20

jr_000_2df9:
    ld c, $07
    rst $10
    ld a, d
    cp $02
    jr z, jr_000_2e0c

    ld c, $05
    rst $30
    ld [$c19e], a
    ld a, l
    ld [$c19c], a
    ret


jr_000_2e0c:
    xor a
    ld [$c19b], a
    res 3, [hl]
    ret


jr_000_2e13:
    cp $59
    jr nz, jr_000_2e23

    ld c, $01
    rst $08
    cp $f0
    jr z, jr_000_2e23

    xor a
    ld c, $0d
    rst $10
    ld d, a

jr_000_2e23:
    ld a, d
    add a
    ld b, a
    push de
    ld a, [hl]
    and $03
    add a
    ld d, $00
    ld e, a
    push hl
    ld hl, $63ea
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]
    pop hl
    ld a, e
    add b
    jr nc, jr_000_2e3c

    inc d

jr_000_2e3c:
    ld e, a

Call_000_2e3d:
    ld a, [de]
    cp $0b
    jr nc, jr_000_2e45

    ld c, $05
    rst $30

jr_000_2e45:
    ld [$c19e], a
    push af
    cp $0f
    jr nc, jr_000_2e7f

    ld a, b
    cp $05
    jr nc, jr_000_2e7f

    push de
    ld c, $03
    rst $08
    and $f0
    swap a
    srl a
    ld e, a
    inc c
    rst $08
    add a
    add a
    add a
    or e
    ld b, a
    pop de
    ld a, [PlayerPositionXLsb]
    and $f0
    swap a
    srl a
    ld c, a
    ld a, [PlayerPositionXMsb]
    add a
    add a
    add a
    or c
    cp b
    ld a, $20
    jr c, jr_000_2e7c

    xor a

jr_000_2e7c:
    ld c, $07
    rst $10

jr_000_2e7f:
    inc de
    ld a, [de]
    ld c, $0c
    rst $10
    ld a, l
    ld [$c19c], a
    pop af
    pop de
    cp $0e
    jr z, jr_000_2eed

    cp $19
    jr z, jr_000_2ea4

    ld a, e
    cp $28
    jp z, Jump_000_2fa7

    cp $59
    jp z, Jump_000_2fa7

    ld a, d
    cp $06
    ret nz

    jp Jump_000_3016


jr_000_2ea4:
    ld bc, $7eb8
    call Call_000_3366
    ret z
    ld a, EVENT_SOUND_ELEPHANT_SHOT
    ld [EventSound], a
    xor a
    ld [de], a
    inc e
    push hl
    inc l
    ld a, [$c13b]
    ld b, a
    ld a, [hl+]
    add b
    sub $1e
    ld [de], a
    inc e
    ld a, [hl+]
    sbc $00
    ld [de], a
    inc e
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$c12f]
    ld c, a
    ld a, [$c130]
    ld b, a
    add hl, bc
    ld a, h
    cp $15
    jr c, jr_000_2ed8

    sub $15
    ld h, a

jr_000_2ed8:
    ld a, l
    sub $0c
    jr nc, jr_000_2ede

    dec h

jr_000_2ede:
    ld [de], a
    inc e
    ld a, h
    ld [de], a
    inc e
    inc e
    inc e
    ld a, $2e
    ld [de], a
    xor a
    inc e
    ld [de], a
    pop hl
    ret


jr_000_2eed:
    ld bc, $7eb8
    call Call_000_3366
    ret z

    ld a, $11
    ld [EventSound], a
    inc e
    push hl
    inc l
    ld a, [hl+]
    sub $0c
    ld [de], a
    inc e
    ld a, [hl+]
    sbc $00
    ld [de], a
    inc e
    ld c, [hl]
    inc l
    ld b, [hl]
    inc l
    inc l
    inc l
    ld a, c
    bit 5, [hl]
    jr nz, jr_000_2f18

    add $1c
    jr nc, jr_000_2f1d

    inc b
    jr jr_000_2f1d

jr_000_2f18:
    sub $1c
    jr nc, jr_000_2f1d

    dec b

jr_000_2f1d:
    ld [de], a
    inc e
    ld a, b
    ld [de], a
    inc e
    inc e
    inc e
    ld a, [hl]
    ld b, $0e
    bit 5, a
    jr nz, jr_000_2f2d

    ld b, $02

jr_000_2f2d:
    or b
    ld [de], a
    ld a, e
    add $09
    ld e, a
    ld c, $10
    jp $5fa4


Jump_000_2f38:
    ld a, e
    cp $1a
    jr z, jr_000_2f92

    cp $67
    jp z, Jump_000_2fd8

    cp $05
    ret nz

    ld c, $16
    rst $20
    ret nz

    ld a, $0c
    rst $10
    xor a
    ld c, $09
    rst $10
    ld a, [$c144]
    ld e, a
    ld a, [BgScrollXLsb]
    ld d, a
    ld c, $03
    rst $08
    sub d
    ld d, a
    ld c, $07
    rst $08
    ld b, a
    ld a, d
    cp e
    jr c, jr_000_2f6b

    bit 3, b
    jr z, jr_000_2f85

    jr jr_000_2f6f

jr_000_2f6b:
    bit 3, b
    jr nz, jr_000_2f85

jr_000_2f6f:
    res 0, [hl]
    ld c, $0b
    ld a, $08
    rst $10
    inc c
    ld a, $10
    rst $10
    ld c, $0e
    ld a, $03
    rst $10
    inc c
    rst $10
    ld a, $a9
    jr jr_000_2f87

jr_000_2f85:
    ld a, $1a

jr_000_2f87:
    ld c, $05
    rst $10
    ld [$c19e], a
    xor a
    ld c, $0d
    rst $10
    ret


jr_000_2f92:
    ld c, $16
    rst $20
    ret nz

    ld a, [TimeCounter]
    and $0f
    add $0c
    rst $10
    ld a, $01
    ld c, $09
    rst $10
    ld a, $05
    jr jr_000_2f87

Jump_000_2fa7:
    ld a, d
    or a
    jr nz, jr_000_2fae

    set 5, [hl]
    ret


jr_000_2fae:
    res 5, [hl]
    ld a, e
    cp $28
    ret nz

    ld a, d
    cp $02
    jr z, jr_000_2fbe

    ld a, $13
    ld [EventSound], a

jr_000_2fbe:
    ld c, $07
    rst $08
    ld b, a
    and $0f
    ret nz

    ld a, $01
    bit 5, b
    jr nz, jr_000_2fcf

    cpl
    inc a
    and $0f

jr_000_2fcf:
    or b
    rst $10
    xor a
    ld c, $09
    rst $10
    jp Jump_000_2945


Jump_000_2fd8:
    ld c, $16
    rst $08
    or a
    jr z, jr_000_2fe0

    rst $20
    ret nz

Jump_000_2fe0:
jr_000_2fe0:
    ld a, $0c
    rst $10
    ld c, $0a
    rst $10
    ld bc, $7eb8
    call Call_000_3366
    ret z

    ld a, EVENT_SOUND_SNAKE_SHOT
    ld [EventSound], a
    xor a
    ld [de], a
    inc e
    push hl
    inc l
    ld a, [hl+]
    sub $0a
    ld [de], a
    inc e
    ld a, [hl+]
    sbc $00
    ld [de], a

Jump_000_3000:
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    inc e
    inc e
    inc l
    inc l
    ld a, $02
    bit 5, [hl]
    jr z, jr_000_3013

    ld a, $2e

jr_000_3013:
    ld [de], a
    pop hl
    ret


Call_000_3016:
Jump_000_3016:
    bit 7, [hl]
    ret nz

    bit 6, [hl]
    ret nz

    ld bc, $7ea0
    call Call_000_3366
    ret z

    inc de
    ld b, $04
    push hl
    inc hl

jr_000_3028:
    ld a, [hl+]
    ld [de], a
    inc e
    dec b
    jr nz, jr_000_3028

    pop hl
    inc e

Call_000_3030:
    inc e
    ld c, $05
    rst $08
    ld c, $07
    cp $a9
    jr z, jr_000_3058

    cp $c0
    jr nc, jr_000_304f

    push af
    inc e
    ld a, $03

Call_000_3042:
    ld [de], a
    pop af
    cp $a4
    ret nz

    ld a, e
    sub $08
    ld e, a
    ld a, $02
    ld [de], a
    ret


jr_000_304f:
    rst $08
    and $20
    ld a, $02
    jr nz, jr_000_3061

    jr jr_000_305f

jr_000_3058:
    rst $08
    and $20
    ld a, $02
    jr z, jr_000_3061

jr_000_305f:
    ld a, $2e

jr_000_3061:
    ld [de], a
    inc e
    ld c, $01
    rst $08
    ld b, a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, b
    sub c
    add $20
    ld b, a
    ld a, [$c145]
    cp b
    jr c, jr_000_307c

    ld a, $02
    ld [de], a
    dec e
    jr jr_000_3089

jr_000_307c:
    xor a
    ld [de], a
    dec e
    ld a, [de]
    bit 3, a
    ld a, $03
    jr z, jr_000_3088

    ld a, $2d

jr_000_3088:
    ld [de], a

jr_000_3089:
    ld a, [de]
    ld c, a
    ld a, e
    sub $06
    ld e, a
    ld a, [$c1ef]
    or a
    jr z, jr_000_30a1

    call Call_000_30a1
    bit 3, c
    jr nz, jr_000_30a1

    ld a, [de]
    add $10
    ld [de], a
    ret


Call_000_30a1:
jr_000_30a1:
    ld a, [de]
    sub $10
    ld [de], a
    inc e
    ld a, [de]
    sbc $00
    ld [de], a
    inc e
    ret


Jump_000_30ac:
    call Call_000_3129

Jump_000_30af:
    ld bc, $7eb8
    call Call_000_3366
    ret z
    ld a, EVENT_SOUND_SNAKE_SHOT
    ld [EventSound], a
    xor a
    ld [de], a
    inc e
    push hl
    ld c, $02
    bit 0, [hl]
    jr z, jr_000_30c7

    ld c, $12

jr_000_30c7:
    inc l
    ld a, [hl+]
    sub c
    ld [de], a
    inc e
    ld a, [hl+]
    sbc $00
    ld [de], a
    inc e
    ld c, [hl]
    inc l
    ld b, [hl]
    inc l
    inc l
    inc l
    ld a, c
    bit 5, [hl]
    jr nz, jr_000_30e3

    add $0a
    jr nc, jr_000_30e8

    inc b
    jr jr_000_30e8

jr_000_30e3:
    sub $0a
    jr nc, jr_000_30e8

    dec b

jr_000_30e8:
    ld [de], a
    inc e
    ld a, b
    ld [de], a
    inc e
    inc e
    inc e
    ld a, [hl]
    ld b, $0d
    bit 5, a
    jr nz, jr_000_30f8

    ld b, $03

jr_000_30f8:
    or b
    ld [de], a
    xor a
    inc e

Call_000_30fc:
    ld [de], a
    pop hl
    ld c, $04
    bit 6, [hl]
    jr nz, jr_000_3106

    ld c, $10

jr_000_3106:
    ldh a, [rLY]
    and $1f
    add c
    ld c, $0b
    rst $10
    ret


Jump_000_310f:
    ld c, $03
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld a, [PlayerPositionXLsb]
    sub e
    ld a, [PlayerPositionXMsb]
    sbc d
    and $20
    ld d, a
    ld c, $07
    rst $08
    and $df
    or d
    rst $10
    ret


Call_000_3129:
    ld c, $01
    rst $08
    ld b, a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, b
    sub c
    ld b, a
    ld a, [$c145]
    sub b
    ret nc

    cp $d0
    ret c

    pop bc
    set 6, [hl]
    set 0, [hl]
    ld a, $06
    ld c, $0a
    rst $10
    ld a, $fc
    ld c, $08
    rst $10
    ld a, $11
    ld c, $0c
    rst $10
    jr jr_000_3164

Call_000_3152:
    bit 6, [hl]
    ret z

    ld c, $05
    rst $08
    cp $54
    jr z, jr_000_315f

    cp $6d
    ret nz

jr_000_315f:
    ld a, [$c19b]
    or a
    ret nz

jr_000_3164:
    ld a, [hl]
    and $01
    add a
    ld d, $00
    ld e, a
    push hl
    ld hl, $6434
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]
    pop hl
    ld c, $08
    rst $08
    bit 1, [hl]
    jr nz, jr_000_317e

    add $04
    ld b, a

jr_000_317e:
    ld a, e
    add b
    ld e, a
    ld a, [de]
    ld d, a
    ld e, b
    ld c, $0d
    rst $08
    cp d
    jr z, jr_000_31a6

    ld a, d
    rst $10
    ld c, $05
    rst $08
    add d
    ld [$c19e], a
    ld a, l
    ld [$c19c], a
    ld a, $01
    ld [$c19b], a
    bit 0, [hl]
    ret z

    ld a, e
    cp $04
    ret nz

    jp Jump_000_30af


jr_000_31a6:
    bit 0, [hl]
    ret nz

    ld c, $07
    rst $08
    and $0f
    ret nz

    jp Jump_000_00e6


Call_000_31b2:
    ld c, $17
    rst $08
    inc a
    ret z

    bit 6, [hl]
    ret z

    ld c, $0c
    rst $08
    or a
    jr z, jr_000_3229

    dec a
    rst $10
    ld d, a
    srl a
    srl a
    cpl
    inc a
    ld c, $08
    rst $10
    ld a, d
    cp $09
    jr z, jr_000_31d6

    xor a
    ld c, $0e
    rst $10
    ret


jr_000_31d6:
    ld a, [$c1e5]
    or a
    ret z

    and $f0
    ret nz

    ld a, [$c1e5]
    or $20
    ld [$c1e5], a
    push hl
    ld a, $02
    ld c, $09
    rst $10
    ld de, $c260
    ld b, $05

Jump_000_31f1:
jr_000_31f1:
    push bc
    push de
    push hl
    ld bc, $0018
    rst $38
    pop hl
    pop de
    pop bc
    ld a, e
    add $20
    ld e, a
    dec b
    jr nz, jr_000_31f1

    pop hl
    push hl
    ld a, $0d
    ld c, $07
    rst $10
    ld a, l
    add $20
    ld l, a
    ld d, $92
    ld e, $ff
    ld b, $05
    ld c, b

jr_000_3214:
    push bc
    ld a, d
    rst $10
    ld a, e
    and $0f
    inc c
    inc c
    rst $10
    ld a, l
    add $20
    ld l, a
    inc d
    inc e
    pop bc
    dec b
    jr nz, jr_000_3214

    pop hl
    ret


jr_000_3229:
    ld d, $11
    ld c, $05
    rst $08
    cp $ae
    jr nz, jr_000_3234

    ld d, $19

jr_000_3234:
    ld c, $0e
    rst $08
    inc a
    cp d
    jr nc, jr_000_32a6

    rst $10
    ld d, a
    srl a
    srl a
    ld c, $08
    rst $10
    ld e, a
    bit 5, [hl]
    jr z, jr_000_325a

    ld c, $05
    rst $08
    cp $54
    jr z, jr_000_32c5

    ld a, d
    cp $06
    ret c

    ld a, $01
    ld c, $09
    rst $10
    ret


jr_000_325a:
    ld a, [$c1e5]
    and $20
    jp nz, Jump_000_335a

    ld c, $05
    rst $08
    cp $89
    ret c

    cp $a2
    jr c, jr_000_3272

    cp $af
    ret c

    cp $b3
    ret nc

jr_000_3272:
    ld c, $01
    rst $08
    ld c, $14
    rst $28
    ret c

    rst $08
    ld c, $01
    rst $10
    xor a
    ld c, $08
    rst $10
    ld a, e
    cp $03
    ld a, $07
    jp z, Jump_000_334d

    ld c, $14
    rst $10
    ld a, EVENT_SOUND_OUT_OF_TIME
    ld [EventSound], a
    res 6, [hl]
    ld a, [$c1e5]
    and $7f
    ld [$c1e5], a
    ld a, [$c1ef]
    or a
    ret z

    ld a, $80
    ld [$c1f9], a
    ret


jr_000_32a6:
    ld c, $0f
    rst $08
    or a
    jr nz, jr_000_32c5

    bit 5, [hl]
    ret z

    set 7, [hl]
    inc c
    rst $08
    ld d, $c6
    ld e, a
    ld a, [de]
    or $80
    ld [de], a
    ld a, [PlayerFreeze]
    or a
    ret z

    push hl
    call Call_000_24e8
    pop hl
    ret


jr_000_32c5:
    ld c, $05
    rst $08
    cp $6d
    jr z, jr_000_3312

    cp $54
    jr nz, jr_000_3330

    ld c, $01
    rst $08
    or a
    jr z, jr_000_32ee

    cp $80
    ret nc

    cp $10
    ret c

    ld c, $07
    rst $08
    ld b, a
    and $0f
    jr z, jr_000_32ee

    ld a, b
    and $f0
    rst $10
    inc c
    xor a
    rst $10
    jp Jump_000_2945


jr_000_32ee:
    ld c, $16
    rst $20
    ret nz

    ld a, $0c
    rst $10
    dec c
    rst $08
    ld c, $0c
    rst $10
    ld c, $07
    rst $08
    ld b, a
    ld a, $01
    bit 5, b
    jr z, jr_000_3306

    ld a, $2f

jr_000_3306:
    rst $10
    res 1, [hl]
    ld c, $01
    ld a, $10
    rst $10
    ld c, $0a
    rst $10
    ret


jr_000_3312:
    ld c, $01
    rst $08
    ld c, $14
    rst $28
    ret c

    rst $08
    ld c, $01
    rst $10
    res 0, [hl]
    res 6, [hl]
    xor a
    ld c, $08
    rst $10
    ld a, $02
    ld c, $0c
    rst $10
    inc c
    rst $10
    inc a
    inc c
    rst $10
    ret


jr_000_3330:
    bit 5, [hl]
    ret nz

    cp $89
    ret c

    cp $a2
    jr c, jr_000_3340

    cp $af
    ret c

    cp $b3
    ret nc

jr_000_3340:
    ld c, $01
    rst $08
    ld c, $14
    rst $28
    ret c

    rst $08
    ld c, $01
    rst $10
    ld a, $0d

Jump_000_334d:
    ld c, $0c
    rst $10
    xor a
    ld c, $08
    rst $10
    ld a, EVENT_SOUND_OUT_OF_TIME
    ld [EventSound], a
    ret


Jump_000_335a:
    dec e
    dec e
    ret nz

    xor a
    ld c, $07
    rst $10
    inc c
    rst $10
    res 6, [hl]
    ret


Call_000_3366:
    ld de, $c380
    ld a, [de]
    and $80
    jr nz, jr_000_3376

    ld a, e
    add $20
    ld e, a
    ld a, [de]
    and $80
    ret z

jr_000_3376:
    push hl
    push de
    ld h, b
    ld l, c
    ld bc, $0018
    rst $38
    pop de
    pop hl
    inc a
    ret


Jump_000_3382:
    bit 5, [hl]
    ret z

    push de
    call Call_000_3c51
    call Call_000_3a21
    pop de
    bit 3, [hl]
    jr nz, jr_000_33a6

    ld c, $0c
    rst $20
    ret nz

    ld a, d
    rst $10
    inc c
    rst $08
    inc a
    inc c
    rst $28
    dec c
    jr c, jr_000_33a0

    xor a

jr_000_33a0:
    rst $10
    ld d, a
    set 3, [hl]
    jr jr_000_33aa

jr_000_33a6:
    inc c
    inc c
    rst $08
    ld d, a

jr_000_33aa:
    ld a, [$c19b]
    or a
    ret nz

    inc a
    ld [$c19b], a
    bit 2, [hl]
    jp nz, Jump_000_3554

    ld a, [NextLevel]
    cp $04
    jr z, jr_000_341a

    cp $06
    jp z, Jump_000_346e

    cp $08
    jp z, Jump_000_34b2

    cp $0a
    jp z, Jump_000_34f5

    ld c, $05
    rst $08
    add d
    ld [$c19e], a
    ld a, l
    ld [$c19c], a
    bit 4, [hl]
    ret z

    ld a, [NumDiamondsMissing]
    or a
    ret nz

    ld a, [PlayerPositionYMsb]
    or a
    ret nz

    ld a, [PlayerPositionXMsb]
    or a
    ret nz

    ld a, [PlayerPositionXLsb]
    cp $d8
    ret c

    ld a, $b0
    ld [$c1c0], a
    ld a, $70
    ld [$c1c1], a
    ld a, $c0
    ld [$c14b], a
    ld a, $40
    ld [$c14d], a
    ld a, $01
    ld [$c14e], a
    ld a, $04
    ld d, a
    ld c, $0d
    rst $10
    ld a, $14
    inc c
    rst $10
    call Call_000_3c9e
    jp Jump_000_3554


jr_000_341a:
    ld d, $01
    ld c, $12
    rst $08
    or a
    jp z, Jump_000_3625

    call Call_000_354b
    ret z

    ld a, [NumDiamondsMissing]
    or a
    ret nz

    ld a, [BgScrollYMsb]
    or a
    ret z

    ld a, [PlayerPositionYLsb]
    cp $60
    ret c

Jump_000_3437:
    ld a, [PlayerPositionXMsb]
    cp $0f
    ret nz

    ld a, [PlayerPositionXLsb]
    cp $90
    ret c

    ld a, $40
    ld [$c1c0], a
    ld a, $50
    ld [$c14b], a
    ld a, $0f
    ld [$c14c], a
    ld a, $bc
    ld [$c14d], a
    xor a
    ld [$c13a], a
    ld [$c13b], a
    ld a, d
    ld c, $0d
    rst $10
    call Call_000_3c9e
    ld c, $58
    ld d, $80
    ld e, $a8
    jp Jump_000_3c24


Jump_000_346e:
    ld d, $08
    ld c, $12
    rst $08
    or a
    jp z, Jump_000_3744

    call Call_000_354b
    ret z

    ld a, [NumDiamondsMissing]
    or a
    ret nz

    ld a, [PlayerPositionYMsb]
    or a
    ret nz

    ld a, [PlayerPositionXMsb]
    cp $07
    ret c

    ld a, [PlayerPositionXLsb]
    cp $40
    ret c

    ld a, $80
    ld [$c1d2], a
    ld a, $90
    ld [$c14b], a
    ld a, $06
    ld [$c14c], a
    ld [$c1d3], a
    call Call_000_3c9e
    ld a, $01
    ld d, a
    ld c, $0d
    rst $10
    ld [$c1f2], a
    jp Jump_000_3744


Jump_000_34b2:
    ld d, $07
    ld c, $12
    rst $08
    or a
    jp z, Jump_000_3814

    call Call_000_354b
    ret z

    ld a, [NumDiamondsMissing]
    or a
    ret nz

    ld a, [PlayerPositionYMsb]
    or a
    ret nz

    ld a, [PlayerPositionXMsb]
    cp $03
    ret c

    ld a, [PlayerPositionXLsb]
    cp $90
    ret c

    ld a, $60
    ld [$c1d2], a
    ld a, $70
    ld [$c14b], a
    ld a, $c0
    ld [$c14d], a
    ld a, $03
    ld [$c14c], a
    ld [$c14e], a
    ld [$c1d3], a
    call Call_000_3c9e
    jp Jump_000_3814


Jump_000_34f5:
    ld d, $07
    ld c, $12
    rst $08
    or a
    jp z, Jump_000_3893

    call Call_000_354b
    ret z

    ld a, [NumDiamondsMissing]
    or a
    ret nz

    ld a, [PlayerPositionYMsb]
    cp $03
    ret nz

    ld a, [PlayerPositionXMsb]
    cp $07
    ret nz

    ld a, [PlayerPositionXLsb]
    cp $90
    ret c

    ld a, $88
    ld [$c1c1], a
    ld a, $30
    ld [$c1d2], a
    ld a, $40
    ld [$c14b], a
    ld a, $bc
    ld [$c14d], a
    ld a, $07
    ld [$c14c], a
    ld [$c14e], a
    ld [$c1d3], a
    call Call_000_3c9e
    push de
    push hl
    ld c, $40
    ld d, $70
    ld e, $a0
    call Call_000_3c24
    pop hl
    pop de
    jp Jump_000_3893


Call_000_354b:
    xor a
    ld [$c19b], a
    res 3, [hl]
    bit 4, [hl]
    ret


Jump_000_3554:
    ld a, [NextLevel]
    cp $04
    jp z, Jump_000_3625

    cp $06
    jp z, Jump_000_3744

    cp $08
    jp z, Jump_000_3814

    cp $0a
    jp z, Jump_000_3893

    ld a, d
    or a
    jr nz, jr_000_35a5

    bit 6, [hl]
    jp nz, Jump_000_3a14

    ld c, $13
    rst $08
    inc a
    and $0f
    rst $10
    ld c, a
    push hl
    ld hl, $661f
    add hl, bc
    ld a, [hl]
    add a
    add a
    ld c, a
    ld hl, $66b5
    add hl, bc
    ld d, [hl]
    inc hl
    ld e, [hl]
    inc hl
    ld b, [hl]
    inc hl
    ld c, [hl]
    pop hl
    push bc
    ld c, $01
    ld a, d
    rst $10
    ld c, $03
    ld a, e
    rst $10
    pop de
    ld c, $07
    ld a, d
    rst $10
    ld c, $14
    ld a, e
    rst $10
    ld d, $00

jr_000_35a5:
    ld a, d
    add a
    ld c, $14
    rst $30
    ld de, $644b
    add e
    jr nc, jr_000_35b1

    inc d

jr_000_35b1:
    ld e, a
    ld a, [de]
    ld [$c19e], a
    push af
    inc de
    ld a, [de]
    ld c, $0c
    rst $10
    ld a, l
    ld [$c19c], a
    pop af
    ld d, a
    ld e, $0d
    cp $33
    jr z, jr_000_35db

    inc e
    cp $37
    jr z, jr_000_35db

    inc e
    cp $41
    jr c, jr_000_35d9

    cp $44
    jr c, jr_000_35db

    inc e
    jr jr_000_35db

jr_000_35d9:
    ld e, $00

jr_000_35db:
    ld a, e
    or a
    jr z, jr_000_35e8

    ld c, $07
    rst $08
    and $40
    jr z, jr_000_35e8

    ld b, $03

jr_000_35e8:
    ld a, e
    add b
    ld c, $0f
    rst $10
    ld a, d
    cp $43
    jr z, jr_000_35f5

    cp $46
    ret nz

jr_000_35f5:
    ld bc, $7ed0
    call Call_000_3366
    ret z

    inc e
    push hl
    ld c, $07
    rst $08
    ld c, a
    inc l

Jump_000_3603:
    ld a, [hl+]
    bit 6, c
    jr z, jr_000_360c

    add $08
    jr jr_000_360e

jr_000_360c:
    sub $12

jr_000_360e:
    ld [de], a
    inc e
    ld a, [hl+]
    ld [de], a
    inc e
    ld a, [hl+]
    sub $08
    ld [de], a
    inc e
    ld a, [hl]
    sbc $00
    ld [de], a
    ld a, e
    add $0c
    ld e, a
    ld c, $10
    jp $5fa4


Jump_000_3625:
    bit 6, [hl]
    jr z, jr_000_3658

    xor a
    ld [$c19b], a
    jp Jump_000_3a14


jr_000_3630:
    ld c, $13
    rst $08
    inc a
    cp $23
    jr c, jr_000_3639

    xor a

jr_000_3639:
    rst $10
    ld c, a
    push hl
    ld hl, $662f
    add hl, bc
    ld a, [hl]
    ld e, a
    and $f0
    swap a
    ld [$c1fb], a
    ld a, e
    and $0f
    ld c, a
    ld hl, $66c5
    add hl, bc
    ld a, [hl]
    pop hl
    ld c, $14
    rst $10
    jr jr_000_366f

jr_000_3658:
    bit 1, [hl]
    jr nz, jr_000_36bf

    ld a, d
    or a
    jr z, jr_000_3630

Call_000_3660:
    cp $02
    jr nz, jr_000_366f

    ld c, $14
    rst $08
    or a
    jr z, jr_000_366f

    ld a, $11
    ld [$c1f1], a

jr_000_366f:
    ld a, d
    add a
    add a
    ld c, $14
    rst $30
    ld de, $64af
    add e
    jr nc, jr_000_367c

    inc d

Jump_000_367c:
jr_000_367c:
    ld e, a
    ld a, [de]
    ld [$c19e], a
    inc de
    ld a, [de]
    ld c, $0c
    rst $10
    ld a, l
    ld [$c19c], a
    inc de
    ld a, [$c1ea]
    inc a
    jr nz, jr_000_369e

    rst $08
    cp $05
    jr c, jr_000_36a2

    srl a
    jr nz, jr_000_369b

    inc a

jr_000_369b:
    rst $10
    jr jr_000_36a2

jr_000_369e:
    ld a, [de]
    ld [$c1ea], a

jr_000_36a2:
    inc de
    ld a, [$c1eb]
    inc a
    jr nz, jr_000_36b6

    rst $08
    cp $05
    jr c, jr_000_36ba

    srl a
    jr nz, jr_000_36b3

    inc a

jr_000_36b3:
    rst $10
    jr jr_000_36ba

jr_000_36b6:
    ld a, [de]
    ld [$c1eb], a

jr_000_36ba:
    set 0, [hl]
    set 1, [hl]
    ret


Jump_000_36bf:
jr_000_36bf:
    bit 0, [hl]
    ret nz

    ld c, $10
    rst $08
    push hl
    inc a
    ld d, $c6
    ld e, a
    ld a, [$c1ea]
    or a
    jr z, jr_000_3734

    inc a
    jr z, jr_000_3734

    ld a, [de]
    bit 4, a
    jr z, jr_000_3734

    and $07
    swap a
    add a
    ld h, $c2
    ld l, a
    push hl
    bit 3, [hl]
    jr nz, jr_000_3722

    ld a, [$c1ea]
    ld c, $16
    rst $28
    jr z, jr_000_36f6

    ld [$c19e], a
    ld a, l
    ld [$c19c], a
    jr jr_000_3720

jr_000_36f6:
    ld a, [$c1eb]
    or a
    jr z, jr_000_372c

    inc a
    jr z, jr_000_372c

    inc e
    ld a, [de]
    bit 4, a
    jr z, jr_000_372c

    and $07
    swap a
    add a
    ld h, $c2
    ld l, a
    bit 3, [hl]
    jr nz, jr_000_3722

    ld a, [$c1eb]
    ld c, $16
    rst $28
    jr z, jr_000_3725

    ld [$c19e], a
    ld a, l
    ld [$c19c], a

jr_000_3720:
    set 3, [hl]

jr_000_3722:
    pop hl
    pop hl
    ret


jr_000_3725:
    call Call_000_3a02
    ld a, l
    ld [$c1ee], a

jr_000_372c:
    pop hl
    call Call_000_3a02
    ld a, l
    ld [$c1ed], a

jr_000_3734:
    pop hl
    ld a, l
    ld [$c1ec], a
    res 1, [hl]
    res 3, [hl]
    xor a
    ld [$c19b], a
    jp Jump_000_3a02


Jump_000_3744:
    bit 6, [hl]
    jr z, jr_000_37aa

    xor a
    ld [$c19b], a
    jp Jump_000_3a14


jr_000_374f:
    ld a, [$c1f3]
    or a
    ret nz

    ld c, $13
    rst $08
    inc a
    cp $25
    jr c, jr_000_375d

    xor a

jr_000_375d:
    rst $10
    ld c, a
    push hl
    ld hl, $6652
    add hl, bc
    ld a, [hl]
    ld e, $01
    bit 7, a
    jr z, jr_000_376d

    ld e, $ff

jr_000_376d:
    and $0f
    cp $05
    jr z, jr_000_3775

    ld e, $00

jr_000_3775:
    ld c, a
    cp $02
    jr c, jr_000_3793

    cp $04
    jr nc, jr_000_3793

    ld a, [$c1eb]
    inc a
    jr nz, jr_000_3785

    inc c

jr_000_3785:
    ld a, [$c1ea]
    inc a
    jr nz, jr_000_3793

    inc c
    ld a, c
    cp $05
    jr c, jr_000_3793

    ld c, $04

jr_000_3793:
    sla c
    ld a, e
    ld [$c1f2], a
    ld hl, $66c7
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    pop hl
    ld c, $0e
    rst $10
    ld a, e
    ld c, $14
    rst $10
    jr jr_000_37d2

jr_000_37aa:
    bit 1, [hl]
    jp nz, Jump_000_36bf

    ld a, d
    or a
    jr z, jr_000_374f

    cp $03
    jr nz, jr_000_37d2

    ld c, $14
    rst $08
    cp $64
    jr nz, jr_000_37d2

    ld a, [$c1f2]
    or a
    jr z, jr_000_37d2

    ld a, $0c
    ld [$c1f1], a
    ld a, [$c1f2]
    and $0f
    ld e, a
    call Call_000_3a74

jr_000_37d2:
    ld a, d
    add a
    add a
    ld c, $14
    rst $30
    cp $28
    jr c, jr_000_37e0

    cp $64
    jr c, jr_000_37ef

jr_000_37e0:
    inc a
    ld [$c1f0], a
    dec a

jr_000_37e5:
    ld de, $64df
    add e
    jr nc, jr_000_37ec

    inc d

jr_000_37ec:
    jp Jump_000_367c


jr_000_37ef:
    push af
    ld e, a
    xor a
    ld [$c1f0], a
    ld a, d
    cp $03
    jr nz, jr_000_3811

    push hl
    ld a, e
    cp $50
    jr nc, jr_000_380d

    ld a, [$c1ed]
    ld l, a
    ld a, e
    cp $3c
    jr nc, jr_000_380d

    ld a, [$c1ee]
    ld l, a

jr_000_380d:
    call Call_000_3016
    pop hl

jr_000_3811:
    pop af
    jr jr_000_37e5

Jump_000_3814:
    bit 6, [hl]
    jr z, jr_000_3843

    xor a
    ld [$c19b], a
    jp Jump_000_3a14


jr_000_381f:
    ld c, $13
    rst $08
    inc a
    cp $20
    jr c, jr_000_3828

    xor a

jr_000_3828:
    rst $10
    ld c, a
    push hl
    ld hl, $6677
    add hl, bc
    ld a, [hl]
    add a
    ld c, a
    ld hl, $66d3
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    pop hl
    ld c, $0e
    rst $10
    ld a, e
    ld c, $14
    rst $10
    jr jr_000_384c

Jump_000_3843:
jr_000_3843:
    bit 1, [hl]
    jp nz, Jump_000_36bf

    ld a, d
    or a
    jr z, jr_000_381f

jr_000_384c:
    ld a, d
    add a
    add a
    ld c, $14
    rst $30
    cp $20
    jr c, jr_000_385c

    cp $3c
    jr c, jr_000_3866

    jr jr_000_3874

jr_000_385c:
    ld de, $6567
    add e
    jr nc, jr_000_3863

    inc d

jr_000_3863:
    jp Jump_000_367c


jr_000_3866:
    push af
    ld a, d
    cp $06
    jr nz, jr_000_3871

    push hl
    call Call_000_394c
    pop hl

jr_000_3871:
    pop af
    jr jr_000_385c

jr_000_3874:
    push af
    ld c, $06
    cp $58
    jr c, jr_000_387d

    ld c, $01

jr_000_387d:
    ld a, d
    cp c
    jr nz, jr_000_3890

    ld a, EVENT_SOUND_EXPLOSION
    ld [EventSound], a
    ld a, $06
    ld [$c13d], a
    push hl
    call Call_000_397c
    pop hl

jr_000_3890:
    pop af
    jr jr_000_385c

Jump_000_3893:
    bit 6, [hl]
    jr z, jr_000_38cd

    xor a
    ld [$c19b], a
    jp Jump_000_3a14


jr_000_389e:
    ld c, $13
    rst $08
    inc a
    cp $1e
    jr c, jr_000_38a7

    xor a

jr_000_38a7:
    rst $10
    ld c, a
    push hl
    ld hl, $6697
    add hl, bc
    ld a, [hl]
    ld e, a
    and $f0
    swap a
    ld [$c1fb], a
    ld a, e
    and $0f
    add a
    ld c, a
    ld hl, $66db
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    pop hl
    ld c, $0e
    rst $10
    ld a, e
    ld c, $14
    rst $10
    jr jr_000_38d6

jr_000_38cd:
    bit 1, [hl]
    jp nz, Jump_000_36bf

    ld a, d

Jump_000_38d3:
    or a

Jump_000_38d4:
    jr z, jr_000_389e

jr_000_38d6:
    ld a, d
    add a
    add a
    ld c, $14
    rst $30
    cp $3c
    jr c, jr_000_38ec

    jr jr_000_38fa

Jump_000_38e2:
jr_000_38e2:
    ld de, $65c7
    add e
    jr nc, jr_000_38e9

    inc d

jr_000_38e9:
    jp Jump_000_367c


jr_000_38ec:
    push af
    ld a, d
    cp $06
    jr nz, jr_000_38f7

    push hl
    call Call_000_3b1f
    pop hl

jr_000_38f7:
    pop af
    jr jr_000_38e2

jr_000_38fa:
    push af
    ld a, d
    cp $05
    jr nz, jr_000_38f7

    push hl
    call Call_000_3907
    pop hl
    jr jr_000_38f7

Call_000_3907:
    ld bc, $7eb8
    call Call_000_3366
    ret z

    ld h, d
    ld l, e
    ld a, $b0
    ld c, $01
    rst $10
    ld a, $03
    inc c
    rst $10
    inc c
    ld a, $bc
    rst $10
    inc c
    ld a, $07
    rst $10
    ld a, $97
    ld c, $05
    rst $10
    ld a, [PlayerPositionXLsb]
    cp $80
    jr nc, jr_000_3932

    ld a, $0d
    ld c, $07
    rst $10

jr_000_3932:
    ld a, e
    add $10
    ld e, a
    push hl
    ld c, $20
    jp $5fa4


Call_000_393c:
    ld hl, $c200
    ld b, $08

jr_000_3941:
    bit 7, [hl]
    ret nz

    ld a, l
    add $20
    ld l, a
    dec b
    jr nz, jr_000_3941

    ret


Call_000_394c:
    call Call_000_393c
    ret z

    ld d, h
    ld e, l
    push de
    ld hl, $7f30
    ld c, $05
    rst $08
    push af
    ld bc, $0018
    rst $38
    ld hl, $c1a9
    ld b, $03
    ld c, $00

jr_000_3965:
    ld a, [hl]
    or a
    jr z, jr_000_3973

    inc l
    inc c
    dec b
    jr nz, jr_000_3965

    pop af
    pop hl
    set 7, [hl]
    ret


jr_000_3973:
    pop af
    ld [hl], a
    pop hl
    ld a, c
    add a
    ld c, $11
    rst $10
    ret


Call_000_397c:
    ld c, $13
    rst $08
    ld c, $00
    cp $09
    jr z, jr_000_39a9

    inc c
    cp $10
    jr z, jr_000_39a9

    inc c
    cp $11
    jr z, jr_000_39a9

    inc c
    cp $16
    jr z, jr_000_39a9

    inc c
    cp $17
    jr z, jr_000_39a9

    inc c
    cp $1c
    jr z, jr_000_39a9

    inc c
    cp $1d
    ret nz

    ld a, [BonusLevel]
    or a
    jr nz, jr_000_39a9

Jump_000_39a8:
    inc c

jr_000_39a9:
    ld hl, $66ff
    add hl, bc
    add hl, bc
    ld a, [hl+]
    ld d, $03
    ld e, [hl]
    or a
    jr nz, jr_000_39d9

    push de
    ld bc, $7ea0
    call Call_000_3366
    ld h, d
    ld l, e
    pop de
    ret z

    ld [hl], $02
    ld a, [BgScrollYLsb]
    ld c, $01
    rst $10
    ld c, $03
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    inc c
    ld a, $93
    rst $10
    ld a, $03
    ld c, $08
    rst $10
    ret


jr_000_39d9:
    push af
    push de
    call Call_000_393c
    jr nz, jr_000_39e3

    pop de
    pop af
    ret


jr_000_39e3:
    ld d, h
    ld e, l
    ld hl, $7ee8
    ld bc, $0018
    push de
    rst $38
    pop hl
    pop de
    ld c, $03
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    pop af
    ld c, $05
    rst $10
    ld c, $14
    ld a, $a0

Jump_000_39fe:
    rst $10
    set 6, [hl]
    ret


Call_000_3a02:
Jump_000_3a02:
    ld c, $15
    rst $08
    ld d, a
    ld c, $06
    rst $08
    and $01
    or d
    rst $10
    ld c, $16
    rst $08
    ld c, $12
    rst $10
    ret


Jump_000_3a14:
    ld a, [$c1e3]
    or a
    ret nz

    push hl
    call Call_000_24e8
    pop hl
    jp Jump_000_1b6a


Call_000_3a21:
    ld a, [$c1f1]
    or a
    jr z, jr_000_3a3a

    dec a
    ld [$c1f1], a
    srl a
    srl a
    cpl
    inc a
    ld e, a
    ld a, $01
    ld [$c1f3], a
    ld a, e
    jr jr_000_3a70

jr_000_3a3a:
    ld a, [NextLevel]
    cp $04
    jr z, jr_000_3a55

    ld a, [$c1f3]
    or a
    ret z

    inc a
    cp $0c
    jr c, jr_000_3a68

    xor a
    ld [$c1f2], a
    ld e, a
    call Call_000_3a74
    jr jr_000_3a67

jr_000_3a55:
    ld a, [$c1f3]
    or a
    ret z

    inc a
    cp $11
    jr c, jr_000_3a68

    call Call_000_3aa7
    ld a, EVENT_SOUND_EXPLOSION
    ld [EventSound], a

jr_000_3a67:
    xor a

jr_000_3a68:
    ld [$c1f3], a
    srl a
    srl a
    ld e, a

jr_000_3a70:
    ld c, $08
    jr jr_000_3a87

Call_000_3a74:
    ld c, $03
    rst $08
    ld c, $00
    ld b, a
    ld a, [PlayerPositionXLsb]
    cp b
    jr c, jr_000_3a82

    ld c, $20

jr_000_3a82:
    ld a, e
    or c
    ld e, a
    ld c, $07

jr_000_3a87:
    rst $10
    ld a, [$c1ea]
    or a
    ret z

    inc a
    ret z

    push hl
    ld a, [$c1ed]
    ld l, a
    ld a, e
    rst $10
    pop hl
    ld a, [$c1eb]
    or a
    ret z

    inc a
    ret z

    push hl
    ld a, [$c1ee]
    ld l, a
    ld a, e
    rst $10
    pop hl
    ret


Call_000_3aa7:
    ld a, $06
    ld [$c13d], a
    xor a
    bit 6, [hl]
    jr nz, jr_000_3ab4

    ld a, [$c1fb]

jr_000_3ab4:
    push hl
    ld e, a
    add a
    add e
    ld de, $670f
    add e
    jr nc, jr_000_3abf

    inc d

jr_000_3abf:
    ld e, a
    ld c, $13
    rst $08
    push af
    ld a, [$c1f4]
    ld l, a
    ld c, $08
    ld a, [de]
    rst $10
    inc de
    ld a, [$c1f5]
    ld l, a
    ld a, [de]
    rst $10
    inc de
    ld a, [$c1f6]
    ld l, a
    ld a, [de]
    rst $10

Jump_000_3ada:
    ld a, [$c1f7]
    ld l, a
    ld d, h
    ld e, a
    pop af
    cp $0b
    jr nz, jr_000_3aee

    ld hl, $7f00
    ld bc, $0018
    rst $38
    jr jr_000_3b1d

jr_000_3aee:
    cp $1c
    jr nz, jr_000_3afa

    ld hl, $7f18
    call Call_000_3c09
    jr jr_000_3b1d

jr_000_3afa:
    cp $1d
    jr nz, jr_000_3b0e

    ld a, $0f
    ld c, $07
    rst $10
    ld a, $02
    ld c, $09
    rst $10
    xor a
    ld c, $0c
    rst $10
    jr jr_000_3b1d

jr_000_3b0e:
    cp $1f
    jr z, jr_000_3b16

    cp $20
    jr nz, jr_000_3b1d

jr_000_3b16:
    xor a
    ld c, $0d
    rst $10
    inc a
    dec c
    rst $10

jr_000_3b1d:
    pop hl
    ret


Call_000_3b1f:
    ld a, $06
    ld [$c13d], a
    ld a, EVENT_SOUND_EXPLOSION
    ld [EventSound], a
    ld a, [$c1fb]
    or a
    ret z

    ld de, $0000
    cp $01
    jr z, jr_000_3b7a

    cp $02
    jr z, jr_000_3b75

    cp $03
    jr nz, jr_000_3b42

    ld de, $f860
    jr jr_000_3b75

jr_000_3b42:
    cp $04
    jr nz, jr_000_3b4b

    ld de, $e890
    jr jr_000_3b7a

jr_000_3b4b:
    cp $05
    jr z, jr_000_3b70

    cp $06
    jr nz, jr_000_3b58

    ld de, $d860
    jr jr_000_3b70

jr_000_3b58:
    cp $07
    jr nz, jr_000_3b61

    ld de, $f8a0
    jr jr_000_3b7a

jr_000_3b61:
    cp $08
    jr nz, jr_000_3bab

    ld de, $d840
    call Call_000_3b70
    ld de, $e870
    jr jr_000_3b75

Call_000_3b70:
jr_000_3b70:
    ld a, [$c1f4]
    jr jr_000_3b7d

jr_000_3b75:
    ld a, [$c1f5]
    jr jr_000_3b7d

jr_000_3b7a:
    ld a, [$c1f6]

jr_000_3b7d:
    ld l, a
    ld a, d
    or e
    jr z, jr_000_3ba5

    ld [hl], $20
    ld c, $01
    ld a, d
    rst $10
    inc c
    ld a, $03
    rst $10
    inc c
    ld a, e
    rst $10
    inc c
    ld a, $07
    rst $10
    ld c, $08
    xor a
    rst $10
    inc c
    ld a, $02
    rst $10
    ld c, $0e
    xor a
    rst $10
    ld c, $15
    ld a, $10
    rst $10
    ret


jr_000_3ba5:
    ld c, $16
    ld a, $14
    rst $10
    ret


jr_000_3bab:
    cp $0d
    jr nc, jr_000_3bca

    sub $09
    ld b, $00
    ld c, a
    ld a, [$c1f7]
    ld d, h
    ld e, a
    ld hl, $66e3
    add hl, bc
    ld a, [hl]
    push af
    ld hl, $7f48
    call Call_000_3c09
    pop af
    ld c, $03
    rst $10
    ret


jr_000_3bca:
    sub $0d
    ld b, $00
    add a
    add a
    add a
    ld c, a
    ld hl, $66e7
    add hl, bc
    ld d, h
    ld e, l
    call Call_000_3bdb

Call_000_3bdb:
    push de
    ld bc, $7ea0
    call Call_000_3366
    ld h, d
    ld l, e
    pop de
    ret z

    ld [hl], $02
    ld a, [de]
    inc de
    ld c, $01
    rst $10
    ld a, $03
    inc c
    rst $10
    inc c
    ld a, [de]
    inc de
    rst $10
    inc c
    ld a, $07
    rst $10
    ld a, $97
    ld c, $05
    rst $10
    ld a, [de]
    inc de

Call_000_3c00:
    ld c, $07
    rst $10

Call_000_3c03:
    ld a, [de]
    inc de
    ld c, $0c
    rst $10
    ret


Call_000_3c09:
    push de
    ld c, $05
    rst $08
    push af
    ld bc, $0018
    rst $38
    ld hl, $c1a9
    ld a, [$c1f8]
    ld c, a
    add l
    ld l, a
    pop af
    ld [hl], a
    pop hl
    ld a, c
    add a

Call_000_3c20:
    ld c, $11
    rst $10
    ret


Call_000_3c24:
Jump_000_3c24:
    push hl
    ld hl, $c200
    ld b, $08

jr_000_3c2a:
    push bc
    ld c, $03
    rst $08
    pop bc
    cp c
    jr nz, jr_000_3c38

    ld a, l
    ld [$c1f4], a
    jr jr_000_3c48

jr_000_3c38:
    cp d
    jr nz, jr_000_3c41

    ld a, l

Jump_000_3c3c:
    ld [$c1f5], a
    jr jr_000_3c48

jr_000_3c41:
    cp e
    jr nz, jr_000_3c48

    ld a, l
    ld [$c1f6], a

jr_000_3c48:
    ld a, l
    add $20
    ld l, a
    dec b
    jr nz, jr_000_3c2a

    pop hl
    ret


Call_000_3c51:
    ld a, [$c1e3]
    or a
    ret z

    dec a
    ld [$c1e3], a
    and $07
    ret nz

    call Call_000_3c8f

Call_000_3c60:
    ld a, [$c1ea]
    or a
    jr z, jr_000_3c78

    inc a
    jr z, jr_000_3c78

    push hl
    ld a, [$c1ed]
    cp l
    jr nz, jr_000_3c73

    ld a, [$c1ec]

jr_000_3c73:
    ld l, a
    call Call_000_3c8f
    pop hl

jr_000_3c78:
    ld a, [$c1eb]
    or a
    ret z

    inc a
    ret z

    push hl
    ld a, [$c1ee]
    cp l
    jr nz, jr_000_3c89

    ld a, [$c1ec]

jr_000_3c89:
    ld l, a
    call Call_000_3c8f
    pop hl
    ret


Call_000_3c8f:
    ld c, $07
    rst $08
    or $10
    rst $10
    ld a, [$c1e4]
    add $02
    ld [$c1e4], a
    ret


Call_000_3c9e:
    set 2, [hl]
    push hl
    ld hl, $c205
    ld b, $08

jr_000_3ca6:
    ld a, [hl]
    cp $2c
    jr z, jr_000_3cb4

    ld a, l
    add $20
    ld l, a
    dec b
    jr nz, jr_000_3ca6

    pop hl
    ret


jr_000_3cb4:
    ld a, l
    sub $05
    ld l, a
    push de
    call $5fdf
    ld a, l
    ld [$c1f7], a
    ld a, b
    ld [$c1f8], a
    pop de
    pop hl
    ld a, $40
    ld [$c1cc], a
    ld a, $ff
    ld [$c1ef], a
    ld a, $0b
    jr jr_000_3ce9

Call_000_3cd4:
    ld a, [$c1cc]
    or a
    ret z

    dec a
    ld [$c1cc], a
    ret nz

    ld a, [NextLevel]
    cp $08
    ld a, $09
    jr nz, jr_000_3ce9

    ld a, $08

jr_000_3ce9:
    ld [CurrentSong], a
    ld [CurrentSong2], a
    ret


Call_000_3cf0:
    ld bc, $0820
    ld hl, $c200
    ld de, $c018
    call Call_000_3d1d
    ret nc

    ld hl, $c300
    ld b, $04
    call Call_000_3d1d
    ret nc

    ld hl, $c380
    ld b, $02
    call Call_000_3d1d
    ret nc

    ld a, $a0
    sub e
    ret z

    ret c

    ld b, a
    ld h, d
    ld l, e

MemsetZero2::
    xor a

jr_000_3d18:
    ld [hl+], a
    dec b
    jr nz, jr_000_3d18
    ret

Call_000_3d1d:
jr_000_3d1d:
    push bc
    bit 7, [hl]
    jr nz, jr_000_3d2b

    push hl
    call Call_000_3d38
    pop hl
    jr c, jr_000_3d2b

    res 4, [hl]

jr_000_3d2b:
    pop bc
    ld a, l
    add c
    ld l, a
    ld a, e
    cp $a0
    ret nc

    dec b
    jr nz, jr_000_3d1d

    scf
    ret


Call_000_3d38:
    set 4, [hl]
    ld c, $17
    rst $08
    inc a
    ld a, [$c13c]
    ld c, a
    jr z, jr_000_3d50

    bit 5, [hl]
    jr z, jr_000_3d50

    bit 1, [hl]
    jr z, jr_000_3d50

    ld a, [$c13b]
    add c

jr_000_3d50:
    ld [$c10a], a
    push de
    ld c, $01
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    push de
    inc c
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    push de
    ld c, $05
    rst $08
    ld e, a
    ld c, $06
    rst $08
    ld b, a
    and $01
    ld d, a
    push de
    ld a, b
    and $fe
    ld [WindowScrollXLsb], a
    ld d, a
    inc c
    rst $08
    bit 7, a
    jr nz, jr_000_3da1

    ld b, a
    and $f0
    ld [WindowScrollXMsb], a
    and $10
    jr z, jr_000_3d96

    ld a, [$c1e4]
    or a
    jr z, jr_000_3d92

    dec a
    ld [$c1e4], a
    jr nz, jr_000_3d96

jr_000_3d92:
    ld a, b
    and $ef
    rst $10

jr_000_3d96:
    ld a, d
    cp $90
    jr nc, jr_000_3da5

jr_000_3d9b:
    ld c, $12
    rst $08
    pop bc
    jr jr_000_3dae

jr_000_3da1:
    pop de
    pop de
    jr jr_000_3dfe

jr_000_3da5:
    bit 2, [hl]
    jr nz, jr_000_3d9b

    ld c, $0d
    rst $08
    pop bc
    add c

jr_000_3dae:
    ld c, a
    ld a, h
    cp $c2
    jr nz, jr_000_3ddf

    ld a, [NextLevel]
    cp $03
    jr nz, jr_000_3ddf

    ld a, [hl]
    and $27
    cp $26
    jr nz, jr_000_3ddf

    ld a, [$c129]
    ld e, a
    ld a, [$c12a]
    ld d, a
    pop hl
    ld a, l
    sub e
    ld l, a
    ld [WindowScrollYMsb], a
    ld a, h
    ld e, a
    sbc d
    ld h, a
    jr nc, jr_000_3df1

    ld a, d
    cp $14

Call_000_3dda:
    jr nz, jr_000_3df1

    ld h, e
    jr jr_000_3df1

jr_000_3ddf:
    ld a, [BgScrollXLsb]
    ld e, a
    ld a, [BgScrollXMsb]
    ld d, a
    pop hl
    ld a, l
    sub e
    ld l, a
    ld [WindowScrollYMsb], a
    ld a, h
    sbc d
    ld h, a

jr_000_3df1:
    ld de, $0028
    add hl, de
    ld a, h
    or a
    jr nz, jr_000_3dfe

    ld a, l
    cp $dc
    jr c, jr_000_3e01

jr_000_3dfe:
    pop hl
    jr jr_000_3e20

jr_000_3e01:
    pop hl
    ld a, [BgScrollYLsb]
    ld e, a
    ld a, [BgScrollYMsb]
    ld d, a
    ld a, l
    sub e
    ld l, a
    ld [WindowScrollYLsb], a
    ld a, h
    sbc d
    ld h, a
    ld de, $0020
    add hl, de
    ld a, h
    or a
    jr nz, jr_000_3e20

    ld a, l
    cp $d0
    jr c, jr_000_3e23

jr_000_3e20:
    pop de
    and a
    ret

; TODO: Continue here.
jr_000_3e23:
    ld a, 4
    rst $00                 ; Load ROM bank 4.
    ld hl, $789a
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]              ; de = [$789a + 2 * bc]
    ld hl, $72b1
    add hl, de              ; hl = $72b1 + de
    push hl
    ld hl, $7ae2
    add hl, bc
    ld a, [hl]              ; a = [$7ae2 + bc]
    ld e, a
    and $0f
    ld d, a
    ld a, e
    swap a
    and $0f
    ld e, a
    push de
    sla e
    sla e
    ld hl, $7c06
    add hl, bc
    add hl, bc
    ld a, [WindowScrollXMsb]
    ld c, a
    and $20
    jr z, jr_000_3e5e

    ld a, [WindowScrollYMsb]
    add e
    sub [hl]
    ld [WindowScrollYMsb], a
    jr jr_000_3e68

jr_000_3e5e:
    ld a, [WindowScrollYMsb]
    sub e
    add $08
    add [hl]
    ld [WindowScrollYMsb], a

jr_000_3e68:
    inc hl
    ld a, [$c10a]
    ld b, a
    ld a, [WindowScrollYLsb]
    bit 6, c
    jr z, jr_000_3e7a

    add $10
    add b
    sub [hl]
    jr jr_000_3e7e

jr_000_3e7a:
    sub $10
    add b
    add [hl]

jr_000_3e7e:
    ld [WindowScrollYLsb], a
    pop bc
    pop hl
    pop de

jr_000_3e84:
    push bc
    ld a, [WindowScrollYMsb]
    push af
    ld b, c

jr_000_3e8a:
    push bc
    ld a, [WindowScrollXMsb]
    ld b, a
    ld a, [hl+]
    sub $02
    jr z, jr_000_3eb6

    ld c, a
    ld a, [WindowScrollYLsb]
    ld [de], a
    inc e
    ld a, [WindowScrollYMsb]
    ld [de], a
    inc e
    ld a, [WindowScrollXLsb]
    cp $90
    jr c, jr_000_3eac

    sub $02
    add c
    ld [de], a
    jr jr_000_3eb2

jr_000_3eac:
    ld [de], a
    add $02
    ld [WindowScrollXLsb], a

jr_000_3eb2:
    inc e
    ld a, b
    ld [de], a
    inc e

jr_000_3eb6:
    ld c, $08
    bit 5, b
    jr z, jr_000_3ebe

    ld c, $f8

jr_000_3ebe:
    ld a, [WindowScrollYMsb]
    add c
    ld [WindowScrollYMsb], a
    ld a, b
    pop bc
    dec b
    jr nz, jr_000_3e8a
    ld b, a
    pop af
    ld [WindowScrollYMsb], a
    ld c, $10
    bit 6, b
    jr z, jr_000_3ed7
    ld c, $f0

jr_000_3ed7:
    ld a, [WindowScrollYLsb]
    add c
    ld [WindowScrollYLsb], a
    pop bc
    ld a, e
    cp $a0
    jr nc, jr_000_3ee7
    dec b
    jr nz, jr_000_3e84

jr_000_3ee7:
    ld a, 1
    rst $00                     ; Load ROM bank 1.
    scf
    ret

LoadFontIntoVram::
    ld hl, CompressedFontData
    ld de, $8ce0

; $3ef2: Implements an LZ77 decompression.
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
    ld [$c10a], a             ; 2 Byte (V)RAM start address of decompression target in [$c109:$c109].
    ld c, [hl]
    inc hl
    ld b, [hl]                ; Length of decompressed data in "bc".
    inc hl
    push hl
    ld h, d
    ld l, e
    add hl, bc
    ld d, h
    ld e, l                   ; (V)RAM end address of decompressed data in "de".
    pop hl
    ld c, [hl]
    inc hl
    ld b, [hl]                ; Length of compressed data in "bc".
    add hl, bc                ; RAM end address of compressed data in "hl".
    ldd a, [hl]
    ld [$c106], a             ; Store first compressed data byte in [$c106].
    push hl
    ld hl, $c106
    scf
    rl [hl]                   ; "hl" pointing to first data byte.
    jr C, .Skip               ; Skip pattern if first bit is 1.
  .Start                      ; $3f16
    call Lz77GetItem          ; Number of bytes to process in "bc".
  : xor a                     ; Copy next byte of symbol data into a
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
    adc a                     ; Symbol now in a
    dec de
    ld [de], a                ; Load symbol into VRAM
    dec bc
    ld a, b
    or c
    jr nZ, :-                 ; Continue if all bytes have been processed
    ld a, [$c10a]
    cp d
    jr nZ, .Skip
    ld a, [$c109]
    cp e                      ; Stop if current pointer points to VRAM start
    jr C, .Skip
    jr .End
  .FirstBitCheck
    call Lz77ShiftBitstream0
    jr nC, .Start
  .Skip
    call Lz77GetItem
    inc l
    ld [hl], c
    inc l
    ld [hl], b                ; Offset in bc
    dec l
    dec l
    call Lz77GetItem
    push hl
    inc bc
    inc bc
    inc bc
    push bc                   ; Copy length in bc
    inc l
    ld c, [hl]
    inc l
    ld b, [hl]
    ld h, d
    ld l, e
    dec hl
    add hl, bc
    pop bc
  : ldd a, [hl]               ; Uncompressed VRAM(!) data pointer in hl
    dec de
    ld [de], a                ; VRAM pointer in de
    dec bc                    ; Number of loop iterations in bc
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
  .End
    pop hl
    ret

; $3f85: Gets one LZ77 item and stores it in bc. This can either be symbol length, offset, or length.
; The fist two data bits of the stream determine the length of the item (4 bit (00), 8 bit (01), 12 bit (10), or 16 bit).
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
    ld a, 4
 : call Lz77ShiftBitstream1
    rl c
    rl b
    dec a
    jr nZ, :-
.Load12Bit:
    ld a, 4
 : call Lz77ShiftBitstream1
    rl c
    rl b
    dec a
    jr nZ, :-
.Load8Bit:
    ld a, 4
 : call Lz77ShiftBitstream1
    rl c
    rl b
    dec a
    jr nZ, :-
.Load4Bit:
    ld a, 4
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
