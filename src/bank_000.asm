SECTION "ROM Bank $000", ROM0[$0]

; $0: Loads the ROM bank "a".
LoadRomBank::
    ld [rROMB0], a
    ret

; Unreachable.
ds 4, $00

; $08: a = [hl + c]; Used to get an object's attribute.
GetAttr::
    push hl
    ld b, $00
    add hl, bc
    ld a, [hl]
    pop hl
    ret

; Unreachable.
db $00

; $10: [hl + c] = a; Used to set an object's attribute.
SetAttr::
    push hl
    ld b, $00
    add hl, bc
    ld [hl], a
    pop hl
    ret

; Unreachable.
db $00

; $18: [hl + c]++; Used to increment an object's attribute.
IncrAttr::
    push hl
    ld b, $00
    add hl, bc
    inc [hl]
    pop hl
    ret

; Unreachable.
db $00

; $20: [hl + c]--; Used to decrement an object'S attribute.
DecrAttr::
    push hl
    ld b, $00
    add hl, bc
    dec [hl]
    pop hl
    ret

; Unreachable.
db $ff

; $28: cp [hl+c]; Used to compare an object attribute.
CpAttr::
    push hl
    ld b, $00
    add hl, bc
    cp [hl]
    pop hl
    ret

; Unused padding data.
db $ff

; $30:: a = [hl + c] + a; Used to add "a" to an object attribute and return the result in "a".
AddToAttr::
    push hl
    ld b, $00
    add hl, bc
    add [hl]
    pop hl
    ret

; Unused padding data.
db $ff

; $38: Copies data from [hl] to [de] with a size of "bc". Changes "de" and "hl".
CopyData::
    ld a, c
    or a
    jr z, CopyData2
    inc b
    jr CopyData2

; Unused padding data.
db $7f

; $40: V-blank interrupt.
VBlankInterrupt::
    jp VBlankIsr

; Unused padding data.
ds 5, $00

; $48: LCDC interrupt.
LCDCInterrupt::
    jp LCDCIsr

; Unused padding data.
ds 5, $00

; $50: Timer overflow interrupt.
TimerOverflowInterrupt::
    jp TimerIsr

; Unused padding data.
ds 5, $00

; $58: Serial transfer complete interrupt. Not implemented.
SerialTransferCompleteInterrupt::
    reti

; Unused padding data.
ds 7, $00

; $60: Joy pad transition interrupt. Not implemented because the game polls the input. See "ReadJoyPad".
JoypadTransitionInterrupt::
    reti

; $61: Jumped to from entry.
Main::
    di
    ld sp, $fffe                    ; Set up the stack.
    call Transfer
    jp MainContinued

; $6b: Transfers 10 bytes from $79 into the high RAM.
Transfer::
    ld c, $80
    ld b, 10
    ld hl, OamTransfer
  : ld a, [hl+]
    ldh [c], a
    inc c
    dec b
    jr nz, :-
    ret

; $79: Copies data from $c000 (RAM) to OAM.
; This function is also copied into the high RAM.
OamTransfer:
    ld a, HIGH(SpriteToOamData)   ; Start address $c000.
    ldh [rDMA], a
    ld a, DMA_CYCLES / 4          ; Need to wait 160 machine cycles for DMA to finish.
  : dec a                         ; 1 cycle.
    jr nZ, :-                     ; 3 cycles.
    ret

; $83: Copies values given in [hl], to [de] with a length of "b"-1, "c".
; If you want a length of "bc" call it with "b"+1 if "c" is unequal to zero.
; Decrements "bc" and increments "de" and "hl".
CopyData2:
    ldi a, [hl]
    ld [de], a
    inc de
    dec c
    jr nZ, CopyData2
    dec b
    jr nZ, CopyData2
    ret

; $8d: Sets lower window tile map to zero.
ResetWndwTileMapLow::
    ld bc, TILEMAP_SIZE
    jr ResetWndwTileMapSize

; $92: Sets lower and upper window tile map to zero.
ResetWndwTileMap::
    ld bc, TILEMAP_SIZE * 2
ResetWndwTileMapSize:
    ld hl, _SCRN0
    jr MemsetZero

; $9a: Sets most of the RAM to 0.
ResetRam::
    ld bc, $00a0
    ld hl, _RAM
    call MemsetZero
    ld hl, _RAM
    ld bc, $1ff8

; $a9: Sets given memory range to zero. hl = start address, bc = length.
MemsetZero::
    ld [hl], $00
    inc hl
    dec bc
    ld a, b
    or c
    jr nz, MemsetZero
    ret

; $b2: Read joy pad and save result in $c100 and $c101.
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
    xor c                     ; Get changes from old to new.
    and c                     ; Only keep new buttons pressed.
    ld [JoyPadNewPresses], a  ; Save new joy pad data.
    ld a, c
    ld [JoyPadData], a        ; Save newly pressed buttons.
    ld a, $30
    ldh [rP1], a              ; Disable selection.
    ret

; $00e6: Only called for fishes.
; If object attribute ATR_12 is $54, attribute obj[ATR_Y_POSITION_LSB] is set to 0.
; Input: hl = pointer to fish object
Jump_000_00e6:
    set 1, [hl]
    GetAttribute ATR_12
    cp $54
    ret nz
    xor a
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = 0
    ret

; TODO: Is this unreachable code, normal data, or padding?
ds 3, $ff
ld a, [hl]
di
ds 2, $ff
xor a
ds 3, $ff
rst GetAttr
rst IncrAttr

; $100
Boot::
    nop
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
    db $01                          ; MBC1

HeaderROMSize::
    db $02

HeaderRAMSize::
    db $00

HeaderDestinationCode::
    db $01

HeaderOldLicenseeCode::
    db $61                          ; -> Virgin Entertainment. See: https://gbdev.gg8.se/wiki/articles/The_Cartridge_Header

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
    SwitchToBank 7
    call LoadSound0
    call SetUpScreen
    SwitchToBank 2
    call LoadFontIntoVram
    ld hl, NintendoLicenseString
    TilemapLow de,0,8               ; Window tile map
    call DrawString;                ; Draws "LICENSED BY NINTENDO"
    ld a, %11100100
    ldh [rBGP], a                   ; Classic BG and window palette.
    ld a, %00011100
    ldh [rOBP0], a
    ld a, $00
    ldh [rOBP1], a
    call SetUpInterruptsSimple
:   call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nz, :-                       ; Wait for a few seconds.

; $0189
VirginStartScreen::
    call StartTimer
    SwitchToBank 3
    call LoadVirginLogoData         ; Loads the big Virgin logo.
    SwitchToBank 2
    ld hl, PresentsString           ; "PRESENTS"
    TilemapLow de,6,16
    call DrawString
    call SetUpInterruptsSimple
:   call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nz, :-                       ; Wait for a few seconds...
    call StartTimer
    call ResetWndwTileMap
    SwitchToBank 3
    ld hl,CompressedJungleBookLogoTileMap
    call DecompressInto9800
    ld hl, CompressedJungleBookLogoData
    call DecompressInto9000         ; "The Jungle Book" logo has been loaded at this point.
    SwitchToBank 2
    ld hl, MenuString
    TilemapLow de,2,7
    call DrawString                 ; Prints "(C)1994 THE WAL..."
    call SetUpInterruptsSimple

; $01ce
StartScreen::
    call SoundAndJoypad             ; TODO: Probably something with sound
    ld a, [JoyPadNewPresses]        ; Get new joy pad presses to see if new mode is selected of if we shall start the level.
    push af
    bit BIT_IND_SELECT, a
    jr Z, SkipMode
    bit BIT_IND_SELECT, a
    jr Z, SkipMode
    ld a, [DifficultyMode]          ; If SELECT was pressed, continue here.
    inc a
    and 1                           ; Mod 2
    ld [DifficultyMode], a          ; Toggle practice and normal mode.
    ld hl, NormalString             ; Load "NORMAL" string.
    jr Z, :+
    ld l, LOW(PracticeString)       ; Load "PRACTICE" string.
  : TilemapLow de,10,17
    call DrawString

; $01f3
SkipMode::
    pop af
    and BIT_A | BIT_B | BIT_START
    jr z, StartScreen               ; Continue if A, B, or START was pressed.

; $01f8
StartGame::
    call StartTimer
    SwitchToBank 7
    call FadeOutSong                ; Sets up CurrentSong2 and CurrentSong.
    call ResetWndwTileMapLow
    ld a, %11100100
    ldh [rBGP], a
    SwitchToBank 2
    call LoadFontIntoVram
    ld hl, LevelString
    TilemapLow de,6,7
    call DrawString                 ; "LEVEL"
    ld a, [NextLevel2]
    ld c, a
    ld a, [CurrentLevel]
    cp c
    jr nz, LevelCompleted
    cp 9
    jr c, :+                        ; Reached level 10?
    ld a, $cf
    ld [de], a
    inc de
    ld a, $ff
:   add $cf                         ; Draw level number.
    ld [de], a
    inc de
    ld a, ":"
    ld [de], a                      ; Draw ":"
    ld b, 0
    sla c                           ; a = a * 2 because level string pointers are two bytes in size.
    ld hl, LevelStringPointers
    add hl, bc                      ; Add offset of corresponding level.
    ldi a, [hl]
    ld h, [hl]
    ld l, a                         ; Now we have the correct pointer to the level name.
    TilemapLow de,3,9
    call DrawString                 ; Print level name.
    ld hl, GetReadyString           ; "GET READY"
    TilemapLow de,5,11
    jr Continue260

; $024b
LevelCompleted:
    ld a, [NextLevel]
    ld [NextLevel2], a              ; Now NextLevel2 and NextLevel are equal.
    cp 10
    jr c, :+
    ld a, $cf
    ld [de], a
    inc de
    xor a
 :  add $ce
    ld [de], a
    TilemapLow de,5,9               ; "hl" points to CompletedString.

; $260
Continue260:
    call DrawString                 ; Either draws "GET READY" or "COMPLETED"
    SwitchToBank 1
    xor a
    ldh [rSCX], a                   ; = 0
    ldh [rSCY], a                   ; = 0 -> BG screen = (0,0).
    dec a
    ld [NextLevel], a               ; = $ff
    ld a, 128
    ld [TimeCounter], a             ; = 128
    ld a, [CurrentLevel]
    cp 11                           ; Level 11?
    jr nZ, :+
    ld a, [MaxDiamondsNeeded]
    ld [NumDiamondsMissing], a
    call UpdateDiamondNumber
:   call SetUpInterruptsSimple
:   call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nZ, :-                       ; Wait for a few seconds...

; $290
SetUpLevel:
    call StartTimer
    call ResetWndwTileMapLow
    ld a, [CurrentLevel]
    inc a
    ld [NextLevel], a
    ld hl, AssetSprites             ; Load sprites of projectiles, diamonds, etc.
    TileDataHigh de, 16             ; = $8900
    ld bc, $03e0
    cp 12                           ; Next level 12 (bonus)?
    jr nz, :+
    call InitBonusLevelInTransition
    ld hl, BonusSprites
    TileDataHigh de, 34             ; $8a20
    ld bc, $00a0
 :  push af
    SwitchToBank 5
    rst CopyData                    ; Copies sprites into VRAM.
    pop af
    jr z, :+
    push af
    SwitchToBank 1
    call InitObjects
    pop af
    call InitSprites
    SwitchToBank 2
    call InitStatusWindow
:   SwitchToBank 2                  ; Load ROM bank 2 in case it wasnt loaded.
    call LoadStatusWindowTiles
    SwitchToBank 5
    call InitStartPositions         ; Loads positions according to level and checkpoint.
    SwitchToBank 6
    ld a, [NextLevel]
    dec a
    add a                           ; a = CurrentLevel * 2; Guess we are accessing some pointer.
    ld b, $00
    ld c, a
    ld hl, GroundDataPtrBase
    add hl, bc                      ; hl = GroundDataPtrBase + CurrentLevel * 2
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = GroundDataX (X = level)
    push bc
    call InitGroundData
    pop bc
    SwitchToBank 4
    call InitBgDataIndices
    SwitchToBank 3
    call InitBackgroundTileData     ; Initializes layer 2 and layer 3 background data.
    ld a, [NextLevel]
    cp 12                           ; Next level 12?
    jr nz, .SkipHoleTiles           ; Jump if not level 12 (transition)
    SwitchToBank 2
    ld hl, CompressedHoleTiles
    TileDataHigh de, 238            ; = $96e0
    call DecompressData
.SkipHoleTiles: ; $311
    SwitchToBank 1
    ld hl, BgScrollXLsb
    ld e, [hl]                      ; e = BgScrollXLsb
    inc hl
    ld d, [hl]                      ; d = BgScrollXMsb
    call CalculateXScrolls
    ld hl, BgScrollYLsb
    ld e, [hl]                      ; e = BgScrollYLsb
    inc hl
    ld d, [hl]                      ; d = BgScrollYMsb
    call CalculateYScrolls
    call GetLvlMapStartIndex
    ld hl, Layer1BgPtrs
    add hl, de
    push hl
    call DrawInitBackground         ; Draws the initial background.
    pop hl
    call DrawInitBackgroundSpecial  ; Some special background things for certain levels.
    call CalculateBoundingBoxes
    call Lvl3Lvl5Setup              ; Some special background setting Level 3 and Level 5.
    SwitchToBank 3
    call Lvl4Lvl5Lvl10Setup
    SwitchToBank 1
    call Call_000_25a6
    xor a                           ; At this point, the background is already fully loaded.
    ld [IsJumping], a               ; Is $0f when flying upwards.
    ld [JumpStyle], a                   ; Is $01 when side jump; is $02 when side jump from slope.
    ld [UpwardsMomemtum], a         ; = 0
    ld [PlayerKnockUp], a           ; = 0
    ld [InvincibilityTimer], a      ; = 0
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld [InShootingAnimation], a     ; = 0
    ld [WeaponActive], a            ; = 0 (bananas)
    ld [WeaponSelect], a            ; = 0 (bananas)
    ld [PlayerOnLiana], a           ; = 0
    ld [NeedNewXTile], a            ; = 0
    ld [NeedNewYTile], a            ; = 0
    ld [$c1cf], a                   ; = 0
    ld [AnimationIndexNew], a       ; = 0 (STANDING_ANIM_IND)
    ld [$c1f1], a                   ; = 0
    ld [$c1f3], a                   ; = 0
    ld [BossMonkeyState], a         ; = 0
    ld [BossAnimation1], a          ; = 0
    ld [BossAnimation2], a          ; = 0
    dec a
    ld [MovementState], a                   ; = $ff
    ld [AnimationIndex], a          ; = $ff (since it's different to AnimationIndexNew, a sprite transfer will be triggered)
    ld [CurrentLianaIndex], a       ; = $ff (player not hanging on any liana)
    ld a, MAX_HEALTH
    ld [CurrentHealth], a
    ld a, [NextLevel]
    ld c, a
    cp 12
    jp z, Jump_000_0422             ; Next level 12?
    xor a
    ld [PlayerOnULiana], a          ; = 0
    ld [TransitionLevelState], a    ; = 0
    ld [EagleTransitionState], a    ; = 0
    ld [PlayerFreeze], a            ; = 0
    ld [ScreenLockX], a             ; = 0
    ld [ScreenLockY], a             ; = 0
    ld [FirstDigitSeconds], a       ; = 0
    ld [SecondDigitSeconds], a      ; = 0
    ld a, [IsPlayerDead]
    or a
    jr nz, jr_000_03de              ; Jump if player is dead.
    ld a, c
    cp 8                            ; Next level = 8?
    ld a, NUM_DIAMONDS_FALLING_RUINS ; Only one diamond for Level 8 (FALLING RUINS).
    jr z, .SaveDiamondNum
    ld a, c
    cp 11                           ; Next level = 11?
    ld a, 1                         ; Only one minute instead of 5.
    jr z, jr_000_03e8               ; Jump if NextLevel == 11.
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
    call DrawLivesLeft              ; TODO: Why is this called redundantly?
    call UpdateDiamondNumber
    call DrawScore1WoAdd
    xor a
    ld [CrouchingHeadTilted], a     ; = 0
    ld [IsPlayerDead], a            ; = 0
    ld c, a
    call SetPlayerIdle
 :  call PlayerSpriteVramTransfer
    ld a, [AnimationIndex]
    or a
    jr nz, :-
    ld c, $01
    ld a, [NextLevel]
    cp 4
    jr nz, :+                       ; Jump if next level not 4.
    ld a, [CheckpointReached]
    or a
    jr nz, :+
    ld c, $ff
 :  ld a, c
    ld [FacingDirection], a
    jr jr_000_0428
Jump_000_0422:
    ld a, [CurrentSong2]
    ld [CurrentSong], a
jr_000_0428:
    call SetupLianaStatus
    call UpdateWeaponNumber
    call LianaScrollAndSpriteColors
    call PrepOamTransferAllObjects
    call SetUpInterruptsAdvanced
PauseLoop: ; $0437
    call WaitForNextPhase
    ld a, [IsPaused]
    or a
    jr z, :+                        ; Jump if game is not paused.
    SwitchToBank 7
    call IncrementPauseTimer
    SwitchToBank 1
    jr PauseLoop
 :  ld a, [RunFinishTimer]
    or a
    jr z, :+                        ; Jump if run not yet finished.
    cp $ff
    jr z, :+                        ; Level succesfully completed.
    dec a                           ; You reach this point if the current run has ended (dies, timeout, fell down).
    ld [RunFinishTimer], a          ; Decrement the RunFinishTimer.
    jr nz, PauseLoop                ; Continue whe RunFinishTimer reaches 0.
    ld a, [CurrentLives]
    or a
    jr z, GameEnded                 ; End game if no lives left.
    ld a, [CurrentLevel]
    cp 10
    jp z, SetUpLevel                ; Jump if Level 10.
    cp 12
    jr z, GameEnded                 ; End game if Level 12.
    jp StartGame

 :  ld a, [JoyPadData]
    and BIT_START | BIT_SELECT | BIT_A | BIT_B
    cp BIT_START | BIT_SELECT | BIT_A | BIT_B
    jr nz, PauseLoop                ; Jump back to PauseLoop if not all buttons are pressed.
    jp MainContinued                ; You can restart the game by pressing START+SELECT+A+B.

; $047c: This is called when the game ends. E.g., no lives left or player decided not to continue.
GameEnded:
    call StartTimer
    ld a, SONG_07
    ld [CurrentSong], a       ; Load game over jingle.
    call ResetWndwTileMapLow
    ld a, $e4
    ldh [rBGP], a             ; Classic colour palette.
    SwitchToBank 2
    call LoadFontIntoVram
    ld hl, WellDoneString     ; Load "WELL DONE"
    ld a, [CurrentLevel]
    cp 12
    jr z, .Draw               ; Level 12?
    ld a, [NextLevel]
    inc a
    jr z, .GameOver
    ld hl, ContinueString     ; Load "CONTINUE?"
    ld a, [NumContinuesLeft]
    or a
    jr nz, .Continue
.GameOver:
    ld hl, GameOverString     ; Load "GAME OVER"
.Continue:
    ld [CanContinue], a
.Draw:
    TilemapLow de,5,8
    call DrawString
    xor a
    ldh [rSCX], a                   ; = 0
    ldh [rSCY], a                   ; = 0
    ld [TimeCounter], a             ; = 0
    dec a
    ld [NextLevel], a               ; = $ff
    ld a, 11
    ld [ContinueSeconds], a
    call SetUpInterruptsSimple

; $04ca
ContinueLoop:
    call SoundAndJoypad
    ld a, [CanContinue]
    or a
    jr z, CantContinue                  ; Jump if we cannot continue.
    SwitchToBank 1
    ld a, [JoyPadData]
    and BIT_START | BIT_A | BIT_B
    jr nz, UseContinue2                 ; Continue if A, B, or START was pressedn.
    ld a, [TimeCounter]
    and %111111
    ld [TimeCounter], a
    jr nz, ContinueLoop                 ; Wait a second.
    ld a, [ContinueSeconds]
    dec a
    ld [ContinueSeconds], a             ; Decrease number of seconds left to continue.
    jr z, GameEnded                     ; If zero end the game.
    TilemapLow de,15,8
    dec a
    call DrawNumber                     ; Draw number of seconds left.
    jr ContinueLoop

; $4f9 Called if we cant continue. This also happens at the end of the game.
CantContinue:
    ld a, [TimeCounter]
    or a
    jr nz, ContinueLoop
    ld a, [CurrentLevel]
    cp 12
    jr nz, BackToMain                   ; Jump if current level is not 12.
    call StartTimer
    call DrawCreditScreenString
    call SetUpInterruptsSimple

:   call SoundAndJoypad
    ld a, [TimeCounter]
    or a
    jr nz, :-

; $0518
BackToMain::
    jp MainContinued

; $051b: Use a continue.
UseContinue2:
    ld a, [NumContinuesLeft]
    dec a
    ld [NumContinuesLeft], a            ; Decrease number of continues.
    xor a
    ld [IsPlayerDead], a                ; = 0
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

; $0541: Blank Interrupt service routine. This is basically the main game loop.
VBlankIsr:
    push af
    ld a, [OldRomBank]
    push af
    push bc
    push de
    push hl
    ld a, [Phase]
    or a
    jp nz, HandlePhase2

HandlePhase1:
    inc a
    ld [Phase], a                   ; = 1
    rst LoadRomBank                 ; Load ROM bank 1.
    ldh a, [rIE]
    ld c, a
    xor a
    ldh [rIF], a
    ld a, c
    and IEF_STAT
    or IEF_VBLANK
    ldh [rIE], a
    ei
    call _HRAM                      ; This will call OAMTransfer.
    ld hl, TimeCounter
    inc [hl]
    ld a, [NextLevel]
    bit 7, a                        ; Bit is only set if level was started from the main menu.
    jr z, .SkipFirstInit            ; Jump if not coming from the main menu.
    xor a
    ldh [rSCX], a                   ; = 0
    ldh [rSCY], a                   ; = 0
    ldh a, [rLCDC]
    and %11110101                   ; Sprite display -> off, BG tile map select -> lower.
    ldh [rLCDC], a
    jp ResetPhaseAndReturn

.SkipFirstInit:
    ldh a, [rLCDC]
    bit 7, a
    jp z, ResetPhaseAndReturn              ; Jump if LCDC control stopped.
    call SetupScreen
    call AnimationSpriteTransfers
    call Call5372
    call ReadJoyPad
    ld a, [IsPaused]
    or a
    jp nz, CheckForPause            ; Jump to CheckForPause if game is currently paused.
    call UpdateMask
    SwitchToBank 7
    call SoundTODO
    SwitchToBank 1
    ld a, [PlayerFreeze]
    or a
    jr nz, .SkipInputsAndReactions

    ld a, [RunFinishTimer]
    or a
    jr nz, .SkipInputsAndReactions  ; Jump if end animation is playing.

    ld a, [JoyPadData]
    push af                         ; Push [JoyPadData]
    bit BIT_IND_RIGHT, a
    call nz, DpadRightPressed       ; Pressed right.
    pop af                          ; Pop [JoyPadData]
    push af                         ; Push [JoyPadData]
    bit BIT_IND_LEFT, a
    call nz, DpadLeftPressed        ; Pressed left.
    pop af                          ; Pop [JoyPadData]
    push af                         ; Push [JoyPadData]
    bit BIT_IND_UP, a
    call nz, DpadUpPressed          ; Pressed up.
    pop af                          ; Pop [JoyPadData]
    push af                         ; Push [JoyPadData]
    bit BIT_IND_DOWN, a             ; Pressed down.
    call nz, DpadDownPressed
    SwitchToBank 7
    call PlayerDirectionChange
    SwitchToBank 1
    ld a, [JoyPadDataNonConst]
    ld d, a                         ; d = [JoyPadDataNonConst]
    and BIT_A
    ld c, a                         ; c = [JoyPadDataNonConst] & BIT_A
    pop af                          ; Pop [JoyPadData]
    push af                         ; Push [JoyPadData]
    ld [JoyPadDataNonConst], a      ; [JoyPadDataNonConst] = [JoyPadData]
    ld b, a
    and BIT_A                       ; a = [JoyPadData] & BIT_A
    xor c                           ; (JoyPadDataNonConst] & BIT_A) ^ ([JoyPadData] & BIT_A)
    push de                         ; Push [JoyPadDataNonConst]
    call nz, AButtonPressed
    pop af                          ; Pop [JoyPadDataNonConst]
    and BIT_B
    ld c, a                         ; c = [JoyPadDataNonConst] & BIT_B
    pop af                          ; Pop [JoyPadData]
    push af                         ; Push [JoyPadData]
    ld b, a                         ; b = [JoyPadData]
    and BIT_B                       ; a = [JoyPadData] & BIT_B
    xor c
    call nz, ShootProjectile
    pop af
    push af
    call HandleWalkRunState
    pop af
    and %100
    call nz, HandleWeaponSelect
    call ShootingAnimation
    call CheckPlayerCollisions
    call CheckProjectileCollisions  ; Refers to player projectiles.

; 060d:
.SkipInputsAndReactions:
    call ScrollXFollowPlayer
    call UpdateBgScrollYOffset
    call HandleLvl345
    call HandlePlayerFall
    call CheckIfPlayerInWaterOrFire
    call ScrollYFollowPlayer
    call HandleScreenLockX
    call HandleScreenLockY
    call TransitionLevelSequence
    call HandlePlayerStateTransitions
    call CheckJump
    call HandlePlayerKnockUp
    call UpdateTeleport
    call LianaScrollAndSpriteColors
    call TODO4fd4
    call HandleULianaSwingTraverse
    call UpdateAllObjects
    call PrepOamTransferAllObjects
    call Call_000_25a6
    call PlayBossMusic

; $0649: Enables the pause screen in case START was pressed.
CheckForPause:
    ld a, [JoyPadData]
    cp BIT_START
    jr nz, ResetPhaseAndReturn  ; Jump if START is not pressed.
    ld a, [JoyPadNewPresses]
    cp BIT_START
    jr nz, jr_000_0676          ; Jump if START was not recently pressed.
.TogglePause:
    ld a, [IsPaused]
    xor %1
    ld [IsPaused], a            ; Toggle pause.
    jr nz, .Skip
    ld a, [CurrentSong2]
    ld [CurrentSong], a
    jr ResetPhaseAndReturn
.Skip:
    SwitchToBank 7
    xor a
    ld [ColorToggle], a         ; = 0
    ld [PauseTimer], a          ; = 0
    call LoadSound0

jr_000_0676:
    call LianaScrollAndSpriteColors

; $679: Sets [Phase] to 0 and returns from ISR.
ResetPhaseAndReturn:
    xor a
    ld [Phase], a                        ; = 0
    inc a
    ld [VBlankIsrFinished], a            ; = 1

; $0681: Returns from ISR.
ReturnFromVblankInterrupt:
    pop hl
    pop de
    pop bc
    pop af
    rst LoadRomBank
    pop af
    reti

HandlePhase2:
    call SetupScreen
    SwitchToBank 7
    call SoundTODO
    jr ReturnFromVblankInterrupt

; $0693: LCDC status interrupt service routine.
; For normal levels, this only handles the general settings of the status window.
; For Level 4 and Level 5, this also includes the water and baloo.
; The ISR is only called with the following LYC values: 119 to draw the status window, 103 to draw the water, 87 to draw Baloo.
LCDCIsr:
    push af
    push bc
    push de
    ldh a, [rLYC]
    cp WINDOW_Y_START - 1
    jp nc, DrawWindow               ; Jump if scanline is larger or equal than 118. Jump only happens in Level 4 and Level 5.

    ld a, [NextLevel]
    ld d, a
    call WaitForVram                ; Wait for VRAM and OAM to be accesible.
    ld a, d
    cp 4
    jr z, .NonBalooCase             ; Jump if Level 4: BY THE RIVER.

    ldh a, [rLCDC]
    or LCDCF_BG9C00
    ldh [rLCDC], a                  ; Use lower window tile data.
    ld a, [ScrollX]
    ldh [rSCX], a                   ; Set scroll x.
    ld a, [ScrollOffsetY]
    ld b, a
    ld a, [$c105]
    ld c, a
    or a
    jr z, :+                        ; Only zero if DrawWindow was previously called.
    ld b, 0
 :  ld a, [ScrollY]
    sub b                           ; Subtract offset.
    ldh [rSCY], a                   ; Set scroll y.
    ld a, c
    or a
    jr nz, :+                       ; Jump if [$c105] is non-zero.
    ld a, [BalooFreeze]
    or a
    jr z, :+                        ; Jump if Baloo is currently not hit by a hippo.

    dec a
    ld [BalooFreeze], a
    ld a, %00010011
    ldh [rBGP], a                   ; When Baloo collides with a hippo he is colored differently.

 :  ld a, [BgScrollYLsb]
    ld c, a
    ld a, d
    cp 5
    jr nz, .NonBalooCase              ; Jump if not in Level 5: IN THE RIVER.

    ld b, $00
    ld a, [$c105]
    or a
    jr z, :+

    cp WINDOW_Y_START
    jr nz, .NonBalooCase

 :  ld a, $ef
    sub c
    cp WINDOW_Y_START
    jr c, jr_000_06f8

    ld b, a

; $6f6
.NonBalooCase:
    ld a, WINDOW_Y_START

jr_000_06f8:
    ldh [rLYC], a
    ld [$c105], a                   ; = rLYC
    cp WINDOW_Y_START
    jr nz, ReturnFromInterrupt

    ld a, [NextLevel]
    cp 4
    jr z, :+                        ; Jump if Level 4: BY THE RIVER.
    cp 5
    jr nz, ReturnFromInterrupt      ; Jump if not Level 5: IN THE RIVER.

    ld a, b
    or a
    jr nz, ReturnFromInterrupt

 :  ldh a, [rLCDC]
    and ~LCDCF_OBJON
    ldh [rLCDC], a                  ; Turn off sprites.
    ld a, %00011011
    ldh [rBGP], a
    jr ReturnFromInterrupt

; $071c: Called from the LCDC status interrupt if scan line is beyond 117.
; Handles general settings for the status window at the bottom. Sprites and tiles are not set in this function.
DrawWindow:
    ldh a, [rLY]
    cp WINDOW_Y_START
    jr nz, DrawWindow               ; Loop until Line 119 is reached.
    call WaitForVram                ; Wait for OAM and VRAM to be accesible.
    xor a
    ldh [rSCX], a                   ; = 0
    ld [$c105], a                   ; = 0
    ld a, WINDOW_Y_SCROLL
    ldh [rSCY], a                   ; = 180
    ldh a, [rLCDC]
    and ~LCDCF_OBJON                ; Turn off sprite display.
    or LCDCF_BG9C00 | LCDCF_BGON    ; Turn on BG/window display, use upper tile map.
    ldh [rLCDC], a
    ld a, [IsPaused]
    or a
    jr z, :+                        ; Jump if game is not paused.

    ld a, [ColorToggle]
    or a
    jr z, ReturnFromInterrupt       ; Use a different palette when in pause mode toggle.

 :  ld a, WINDOW_PALETTE
    ldh [rBGP], a                   ; Color palette for the window.

; $0747
ReturnFromInterrupt:
    pop de
    pop bc
    pop af
    reti

; $074b: Waits for the PPU to get into Mode 00 (both OAM and VRAM are accesible in this mode).
WaitForVram:
    ldh a, [rSTAT]
    and STATF_LCD
    jr nz, WaitForVram
    ret

; $0752 : This function is called by the timer interrupt ~60 times a seconds.
TimerIsr:
    push af
    ld a, [OldRomBank]
    push af
    SwitchToBank 7
    push bc
    push de
    push hl
    call SoundTODO
    pop hl
    pop de
    pop bc
    pop af
    rst LoadRomBank
    pop af
    reti

; $0767: Sets up scrools, rLCDC, rBGP, rSCX, rSCY, rLYC.
SetupScreen:
    ldh a, [rLCDC]
    and ~LCDCF_BG9C00               ; Set BG tile map display select to $9800-$9bff.
    or LCDCF_OBJON                  ; Sprites enabled.
    ldh [rLCDC], a
    ld a, %00011011
    ldh [rBGP], a                   ; New palette.
    ld a, [BgScrollXLsb]
    ldh [rSCX], a                   ; Store X scroll.
    ld a, [BgScrollYOffset]
    ld c, a
    ld a, [BgScrollYLsb]
    sub c
    ldh [rSCY], a                   ; Store Y scroll.
    ld c, a
    ld a, [BgScrollYMsb]
    ld b, a
    ld a, [NextLevel]
    cp 3
    jr z, .Level3                   ; Jump if Level 3.
    cp 4
    jr z, .Level4                   ; Jump if Level 4.
    cp 5
    jr nz, jr_000_07b9              ; Jump if not Level 5.

.Level5:
    ld a, b
    cp 3
    jr nz, jr_000_07b9              ; Jump if BgScrollYMsb != 3.
    ld a, $df
    sub c
    jr c, jr_000_07b9
    cp $78
    jr c, jr_000_07bb
    jr jr_000_07b9

.Level4:
    ld a, b
    cp $01
    jr nz, jr_000_07b9

    ld a, 239
    sub c
    jr jr_000_07b5

.Level3:
    ld a, 31
    sub c
    jr nc, jr_000_07b9

jr_000_07b5:
    cp 120
    jr c, jr_000_07bb

; $07b9
jr_000_07b9:
    ld a, 119

jr_000_07bb:
    ldh [rLYC], a                   ; Setup coincidence interrupt.
    ld a, [ObjYWiggle]
    ld [ScrollOffsetY], a
    ld a, [$c129]
    ld [ScrollX], a
    ld a, [$c12a]
    ld [$c12c], a
    ld c, 24
    ld a, [NextLevel]
    cp 3
    jr z, :+                        ; Jump if Level == 3
    ld c, 216
 :  ld a, [BgScrollYLsb]
    sub c
    ld [ScrollY], a
    ret

; $07e2: Called when right button of D-pad is pressed.
DpadRightPressed:
    ld a, [PlayerOnLiana]
    cp 1
    jr nz, .DpadRightPressedContinue

.PlayerOnLiana:                     ; Reached when [PlayerOnLiana] is 1. Hence, player is just hanging.
    ld a, 1
    ld [FacingDirection], a         ; = 1 -> Player facing right.
    ld [LianaClimbSpriteDir], a     ; = 1 -> Player left arm up.
    ld a, [PlayerOnLianaYPosition]
    cp 4
    ret c                           ; Return if player is not at the liana's bottom part.
    jp LetPlayerSwing               ; Else let the player swing.

; $07fa
.DpadRightPressedContinue:
    and %1
    ret nz                          ; Return when player is swinging.
    ld a, [PlayerOnULiana]
    and $7f
    jp nz, Jump_000_09c9
    ld a, [CatapultTodo]
    or a
    ret nz                          ; Return if player is being catapulted.
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is currenly teleporting.
    ld a, [XAcceleration]
    and %1111
    ret nz                          ; Return if player is breaking.
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    ld a, 1
    ld [FacingDirection], a         ; = 1 (player facing right)
    ld a, [LandingAnimation]
    dec a
    and $80
    ret z
    ld a, [UpwardsMomemtum]
    cp 32
    ret nc
    ld a, [IsCrouching]
    or a
    ret nz
    ld a, [LookingUpDown]
    or a
    ret nz
    ld a, [InShootingAnimation]
    or a
    ret nz                          ; Return when in shooting animation.
    ld a, [JoyPadData]
    and BIT_UP | BIT_DOWN
    call nz, CheckBrake             ; Jump if player is pressing UP or DOWN down at the same time.
    ret nz
    ld a, [PlayerInWaterOrFire]
    or a
    jr nz, .PlayerSlowMove
    ld a, [CurrentGroundType]
    cp $02
    jr c, MovePlayerRight
    cp $04
    jr nc, MovePlayerRight

; $0855: Player is moving slower when in water/fire or on a slope.
.PlayerSlowMove:
    ld c, %100
    ld a, [TimeCounter]
    rra
    jp c, HandleWalkingOrRunning

; $085e: Moves player right if possible. Distance depends on factors like walking, running, or jumping.
MovePlayerRight:
    ld a, [LvlBoundingBoxXLsb]
    ld e, a
    ld a, [LvlBoundingBoxXMsb]
    ld d, a                         ; de = [LvlBoundingBoxX]
    ld a, [BgScrollXLsb]
    ld c, a                         ; c = [BgScrollXLsb]
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPositionX]
    ld a, h                         ; a = [PlayerPositionXMsb]
    cp d
    jr nz, .NotAtXend

    ld a, l
    cp e
    jp nc, CheckBrake              ; Jump if player reached the level's bounding box.

; $0879
.NotAtXend:
    ld a, l                         ; a = [PlayerPositionXLsb]
    sub c                           ; a = [PlayerPositionXLsb] - [BgScrollXLsb]
    cp 148
    jr nc, .End                     ; Jump if player would exceed the window.

    ld a, [WalkingState]
    inc a
    ld d, a
    jr nz, .PlayerNotRunning
    inc hl                          ; Increase position.

; $0887
.PlayerNotRunning:
    inc hl                          ; Increase position again.
    ld a, d
    or a
    jr z, .SetPlayerXpos            ; Jump if player is running.

    ld a, [JumpStyle]
    cp LIANA_JUMP
    jr z, .IncreaseXPos             ; Jump if liana jump.

    ld a, [IsJumping]
    or a
    jr z, .SetPlayerXpos

    ld a, [PlayerOnULiana]
    or a
    jr nz, .IncreaseXPos

    ld a, [JumpStyle]
    cp SLOPE_JUMP
    jr z, .SetPlayerXpos            ; Jump if jump from slope.

; $08a6
.IncreaseXPos:
    ld d, $00
    inc hl

; $08a9
.SetPlayerXpos:
    ld a, h
    ld [PlayerPositionXMsb], a
    ld a, l
    ld [PlayerPositionXLsb], a      ; [PlayerPositionX] = hl
    sub c                           ; [PlayerPositionXLsb] - [BgScrollXLsb]
    cp 40
    jr c, .End

    ld a, d
    or a
    jr nz, .IncScroll

    ld a, [BgScrollXLsb]
    and %1
    call z, IncrementBgScrollX

; $08c2
.IncScroll:
    call IncrementBgScrollX

; $08c5
.End:
    ld a, [MovementState]
    inc a
    ret z
    ld c, $06
    jp HandleWalkingOrRunning

; $08cf: Called when the left button of the D-pad is pressed.
DpadLeftPressed:
    ld a, [PlayerOnLiana]
    cp 1
    jr nz, .DpadLeftPressedContinue

.PlayerOnLiana:                     ; Reached when [PlayerOnLiana] is 1. Hence, player is just hanging.
    ld a, -1
    ld [FacingDirection], a         ; = -1 ($ff) -> Player facing left.
    ld [LianaClimbSpriteDir], a     ; = -1 ($ff) -> Player right arm up.
    ld a, [PlayerOnLianaYPosition]
    cp 4
    ret c                           ; Return if player is not at the liana's bottom part.
    jp LetPlayerSwing               ; Else let the player swing.

; $08e7
.DpadLeftPressedContinue:
    and $01
    ret nz

    ld a, [PlayerOnULiana]
    and $7f
    jp nz, Jump_000_0b07

    ld a, [CatapultTodo]
    or a
    ret nz

    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is currenly teleporting.

    ld a, [XAcceleration]
    and %1111
    ret nz                          ; Return if player is breaking.

    ld a, [PlayerKnockUp]
    or a
    ret nz

    ld a, OBJECT_FACING_LEFT
    ld [FacingDirection], a         ; = -1 ($ff) (facing left)
    ld a, [LandingAnimation]
    dec a
    and $80
    ret z

    ld a, [UpwardsMomemtum]
    cp 32
    ret nc                          ; Return when there is still a significant amount of upwards momentum.

    ld a, [IsCrouching]
    or a
    ret nz

    ld a, [LookingUpDown]
    or a
    ret nz

    ld a, [InShootingAnimation]
    or a
    ret nz

    ld a, [JoyPadData]
    and BIT_UP | BIT_DOWN
    call nz, CheckBrake
    ret nz

    ld a, [PlayerInWaterOrFire]
    or a
    jr nz, .PlayerSlowMove

    ld a, [CurrentGroundType]
    cp $0a
    jr c, MovePlayerLeft

    cp $0c
    jr nc, MovePlayerLeft

; $0942: Player is moving slower when in water/fire or on a slope.
.PlayerSlowMove:
    ld c, %100
    ld a, [TimeCounter]
    rra
    jr c, HandleWalkingOrRunning

; $094a
MovePlayerLeft:
    ld a, [LeftLvlBoundingBoxXLsb]
    ld e, a
    ld a, [LeftLvlBoundingBoxXMsb]
    ld d, a                         ; de = [LeftLvlBoundingBoxX]
    ld a, [BgScrollXLsb]
    ld c, a
    ld hl, PlayerPositionXLsb
    ld a, [hl+]                     ; a = PlayerPositionXLsb
    ld h, [hl]                      ; h = PlayerPositionXMsb
    ld l, a
    ld a, h                         ; hl = PlayerPositionX
    cp d
    jr nz, .NotAtXEnd               ; Continue if [LeftLvlBoundingBoxXMsb] and PlayerPositionXMsb match.
    ld a, l
    cp e
    jp c, CheckBrake                ; Jump if PlayerPositionXLsb - [LeftLvlBoundingBoxXLsb] < 0

 .NotAtXEnd:
    ld a, l
    sub c
    cp 12
    jr c, .End

    ld a, [WalkingState]
    inc a
    ld d, a
    jr nz, .NotRunning

    dec hl

; $0973
.NotRunning:
    dec hl
    ld a, d
    or a
    jr z, .SetPlayerXPos

    ld a, [JumpStyle]
    cp LIANA_JUMP
    jr z, .DecrementXPos

    ld a, [IsJumping]
    or a
    jr z, .SetPlayerXPos

    ld a, [PlayerOnULiana]
    or a
    jr nz, .DecrementXPos

    ld a, [JumpStyle]
    cp SLOPE_JUMP
    jr z, .SetPlayerXPos

; $0992
.DecrementXPos:
    ld d, $00
    dec hl

; $0995
.SetPlayerXPos:
    ld a, h
    ld [PlayerPositionXMsb], a
    ld a, l
    ld [PlayerPositionXLsb], a
    sub c
    cp $78
    jr nc, .End
    ld a, d
    or a
    jr nz, .DecScroll
    ld a, [BgScrollXLsb]
    and %1
    call z, DecrementBgScrollX

; $09ae
.DecScroll:
    call DecrementBgScrollX

; $09b1
.End:
    ld a, [MovementState]
    inc a
    ret z
    ld c, $06

; $09b8: Sets the player's state and the corresponding animation indices.
; Input: c = wraparound value for AnimationCounter (4 or 6)
HandleWalkingOrRunning:
    ld a, [XAcceleration]
    and %1111
    ret nz                          ; Return if player is breaking.
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    call SetPlayerStateWalking
    jp SetWalkingOrRunningAnimation

; $09c9
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
    call IsAtULiana
    jr c, jr_000_09e5

    ld a, [FacingDirection]
    and $80
    ret z

jr_000_09e5:
    ld a, [PlayerSwingAnimIndex]
    cp 3
    ret nz

    ld a, [ULianaTurn]
    or a
    jr z, jr_000_09fb

    ld a, [ULianaSwingDirection]
    dec a
    ret nz

    ld [ULianaTurn], a
    jr jr_000_0a00

jr_000_09fb:
    ld a, [ULianaSwingDirection]
    inc a
    ret nz

jr_000_0a00:
    ld a, PLAYER_TRAVERSING_ULIANA
    ld [PlayerOnULiana], a          ; = 2 (PLAYER_TRAVERSING_ULIANA)
    ld a, 1
    ld [ULianaCounter], a           ; = 1
    xor a
    ld [PlayerSwingAnimIndex], a    ; = 0 (player at left side)
    ld [$c162], a                   ; = 0
    inc a
    ld [FacingDirection], a         ; = $01 -> Player facing right.
    ret


jr_000_0a16:
    ld a, [FacingDirection]
    dec a
    ret nz

; $0a1b
ULianaLToRTurn:
    ld a, [ULianaCounter]
    dec a
    ld [ULianaCounter], a           ; -= 1
    ret nz                          ; Only continue if counter hits 0.
    ld a, 6
    ld [ULianaCounter], a           ; = 6
    ld a, [$c16a]
    cp $0b
    jr c, jr_000_0a58
    ld b, $e0
    ld c, $14
    call IsAtULiana
    jr c, jr_000_0a55
    ld a, [$c16a]
    cp $0f
    jr nz, jr_000_0a4b
    ld a, PLAYER_HANGING_ON_ULIANA
    ld [PlayerOnULiana], a          ; = 1 (PLAYER_HANGING_ON_ULIANA)
    ld [ULianaSwingDirection], a    ; = 1
    ld [PlayerSwingAnimIndex], a    ; = 1
    ret

jr_000_0a4b:
    ld c, a
    ld a, $0f
    sub c
    add a
    add a
    ld e, a
    ld a, c
    jr Jump_000_0aab

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
    ld hl, TODOData620f
    add hl, bc
    ld a, [$c162]
    ld d, a
    ld a, [PlayerSwingAnimIndex]
    inc a
    cp $06
    jr c, jr_000_0a94

    ld a, d
    xor $06
    ld d, a
    ld [$c162], a
    ld a, e
    ld [$c16d], a                   ; = -20
    GetAttribute ATR_Y_POSITION_MSB
    ld [$c16e], a                   ; = obj[ATR_Y_POSITION_MSB]
    ld a, [$c16a]
    bit 7, e
    jr nz, jr_000_0a8c

    add $05
    jr jr_000_0a8e

jr_000_0a8c:
    sub $05

jr_000_0a8e:
    and $0f
    ld [$c16a], a
    xor a

jr_000_0a94:
    ld [PlayerSwingAnimIndex], a
    ld c, a
    add TRAVERSE_ANIM_IND
    add d
    ld [AnimationIndexNew], a       ; = TRAVERSE_ANIM_IND + offset
    ld a, c
    sub 4
    ld c, a
    ld a, $00
    jr c, jr_000_0aa7

    rst GetAttr

jr_000_0aa7:
    ld [$c16b], a
    ret


Jump_000_0aab:
    ld c, a
    add a
    add c
    ld b, $00
    ld c, a
    ld hl, TODOData620f
    add hl, bc
    ld a, [$c162]
    ld d, a
    ld a, [PlayerSwingAnimIndex]
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
    rst GetAttr
    ld [$c16e], a
    xor a
    bit 7, e
    jr nz, jr_000_0ae7

    ld a, $0f

jr_000_0ae7:
    ld [$c16a], a
    xor a

jr_000_0aeb:
    ld [PlayerSwingAnimIndex], a
    ld c, a
    add TRAVERSE_ANIM_IND
    add d
    ld [AnimationIndexNew], a       ; = TRAVERSE_ANIM_IND + offset
    ld a, c
    sub $04
    ld c, a
    ld a, $00
    jr c, jr_000_0afe

    rst GetAttr

jr_000_0afe:
    ld [$c16b], a
    ld a, 3
    ld [ULianaCounter], a           ; = 3
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
    call IsAtULiana
    jr c, jr_000_0b22

    ld a, [FacingDirection]
    and $80
    ret nz

jr_000_0b22:
    ld a, [PlayerSwingAnimIndex]
    cp 3
    ret nz

    ld a, [ULianaTurn]

Call_000_0b2b:
    or a
    jr z, jr_000_0b38

    ld a, [ULianaSwingDirection]
    inc a
    ret nz

    ld [ULianaTurn], a
    jr jr_000_0b3d

jr_000_0b38:
    ld a, [ULianaSwingDirection]
    dec a
    ret nz

jr_000_0b3d:
    ld a, PLAYER_TRAVERSING_ULIANA
    ld [PlayerOnULiana], a          ; = 2 (PLAYER_TRAVERSING_ULIANA)
    ld a, 1
    ld [ULianaCounter], a           ; = 1
    xor a
    ld [$c162], a                   ; = 0
    ld [PlayerSwingAnimIndex], a    ; = 0 (player at left side)
    dec a
    ld [FacingDirection], a         ; = $ff -> Player facing left.
    ret

jr_000_0b53:
    ld a, [FacingDirection]
    inc a
    ret nz

; $0b58
ULianaRToLTurn:
    ld a, [ULianaCounter]
    dec a
    ld [ULianaCounter], a           ; -= 1
    ret nz                          ; Only continue if counter is zero.
    ld a, 6
    ld [ULianaCounter], a           ; = 6
    ld a, [$c16a]
    cp $05
    jr nc, jr_000_0b98
    ld b, $e0
    ld c, $ec
    call IsAtULiana
    jr c, jr_000_0b95
    ld a, [$c16a]
    or a
    jr nz, jr_000_0b8b
    ld a, PLAYER_HANGING_ON_ULIANA
    ld [PlayerOnULiana], a          ; = 1 (PLAYER_HANGING_ON_ULIANA)
    ld a, 4
    ld [PlayerSwingAnimIndex], a    ; = 4
    ld a, -1
    ld [ULianaSwingDirection], a    ; = -1
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
    ld e, -20
    ld c, a
    ld a, $0f
    sub c
    jp Jump_000_0a5a


; $0ba1: This function does the following things:
; - Sets PlayerWindowOffsetX and PlayerWindowOffsetY.
; - Handle screen scroll in case the player is on a liana.
; - Sets the correct sprite colors when using the mask or when being hit by damage.
; Quite a random composition, but ok.
LianaScrollAndSpriteColors:
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is currently teleporting.
    ld a, [PlayerYWiggle]
    ld b, a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c
    add b
    ld [PlayerWindowOffsetY], a     ; [PlayerWindowOffsetY] = [PlayerPositionYLsb] - [BgScrollYLsb] + [PlayerYWiggle]
    ld a, [BgScrollXLsb]
    ld c, a
    ld a, [PlayerPositionXLsb]
    sub c
    ld [PlayerWindowOffsetX], a     ; [PlayerWindowOffsetX] = [PlayerPositionXLsb] - [BgScrollXLsb]
    ld c, a
    ld a, [PlayerOnLiana]
    or a
    jr z, .SkipScrolls
    ld a, c                         ; a = [PlayerWindowOffsetX]
    push af
    cp 38
    call c, DecrementBgScrollX      ; Scroll screen left if [PlayerWindowOffsetX] < 38
    pop af
    cp 122
    call nc, IncrementBgScrollX     ; Scroll screen right if [PlayerWindowOffsetX] > 122

; $0bd5
.SkipScrolls:
    ld a, [AnimationIndex]
    inc a
    ret z

    ld a, [InvincibilityTimer]
    or a
    jr z, .SetPlayerSpriteFlags

.Invincible:
    ld c, a                         ; c = [InvincibilityTimer]
    ld a, [TimeCounter]
    and %11
    ld a, c                         ; a = [InvincibilityTimer]
    jr nz, .SkipDecrement

.DecrementInvTimer:
    dec a
    ld [InvincibilityTimer], a

; $0bed
.SkipDecrement:
    cp 16
    jr nc, .CheckBit0

    ld c, a                         ; a = [InvincibilityTimer]
    ld a, [WeaponSelect]
    cp WEAPON_MASK
    jr nz, .NoMask

.MaskSelected:
    ld a, [CurrentSecondsInvincibility]
    or a
    jr z, .NoMask                   ; Jump if mask has 0 seconds left.

    ld a, $ff
    ld [InvincibilityTimer], a      ; = $ff
    jr .CheckBit0

; $0c06
.NoMask:
    ld a, c                         ; a = [InvincibilityTimer]
    bit 1, a
    jr .CheckInvisibility

; $0c0b
.CheckBit0:
    bit 0, a

; $0c0d
.CheckInvisibility:
    jr z, .NotInvisible

    ld a, SPRITE_INVISIBLE_MASK     ; Player periodically turns white when using the mask.
    jr .SetPlayerSpriteFlags

; $0c13
.NotInvisible:
    xor a

; $0c14
.SetPlayerSpriteFlags:
    ld c, a                         ; c = SPRITE_INVISIBLE_MASK or $00
    ld a, [RedrawHealth]
    and SPRITE_WHITE_MASK           ; Player shortly turns white when losing HP.
    or c
    ld [PlayerSpriteFlags], a
    SwitchToBank 2
    call PrepPlayerSpriteOamTransfer
    SwitchToBank 1
    ret

; $0c28: Handles a D-pad up press.
DpadUpPressed:
    ld a, [LandingAnimation]
    or a
    ret nz                          ; Don't do anything if player is landing.
    ld a, [PlayerOnULiana]
    or a
    ret nz
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    ld b, -1
    call CheckPlayerGround
    ld a, [CurrentGroundType]
    bit 6, a                        ; Bit 6 is set if player stands at a portal.
    jp z, DpadUpContinued1

; $0c44
.HandlePortal:
    and %11
    jr z, .CheckTeleportConditions  ; Jump if CurrentGroundType is $40
    dec a
    jr nz, .GroundType42or43        ; Jump if CurrentGroundType is $42 or $43.

; $0c4b: Portal is not covering the whole 2x2 meta tile. Check where player is standing.
.GroundType41:
    ld a, [PlayerPositionXLsb]
    and %1111
    cp 8
    jp nc, DpadUpContinued1
    jr .CheckTeleportConditions

; $0c57: Portal is not covering the whole 2x2 meta tile. Check where player is standing.
.GroundType42or43:
    ld a, [PlayerPositionXLsb]
    and %1111
    cp 8
    jp c, DpadUpContinued1

; $0c61
.CheckTeleportConditions:
    ld a, [JoyPadDataNonConst]
    and BIT_UP
    ret nz                          ; Return if UP was held pressed.
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is already teleporting.

; $0c6c: If this is reached, player will be teleported.
HandleTeleport:
    ld hl, Level2PortalData
    ld b, 4
    ld c, $00
    ld a, [NextLevel]
    cp 2                            ; Level 2 has 4 portals/doors.
    jr z, CheckPortalLoop           ; Jump if Level 2: THE GREAT TREE.
    ld hl, DefaultPortalData
    cp 6
    jr nz, CheckPortalLoop          ; Jump if NOT Level 6: TREE VILLAGE.
    ld hl, Level6PortalData
    ld b, 14                        ; Level 6 has 14 portals/doors.

; $0c86: Compare portal data against "de". If "de" matches portal data, teleport is activated.
CheckPortalLoop:
    ld a, [hl+]
    cp e
    jr nz, :+
    ld a, [hl]
    cp d
    jr z, StartTeleport
 :  inc hl
    inc c                           ; Increase portal index.
    dec b
    jr nz, CheckPortalLoop
    ret

; $0c94: Called when a teleport is started.
; Input: "c" = index of the chosen portal
StartTeleport:
    ld a, [NextLevel]
    ld hl, Level2TeleportData       ; Teleport data Level 2.
    cp 2                            ; Level 2: THE GREAT TREE
    jr z, :+

    ld hl, Level6TeleportData       ; Teleport data Level 6.
    cp 6                            ; Level 6: TREE VILLAGE
    jr z, :+

    ld hl, DefaultTeleportData      ; Teleport data default.

 :  ld a, c
    add a
    add a
    add a
    add c
    ld c, a                         ; c = portal_index * 9 (9 bytes per portal)
    ld b, $00
    add hl, bc                      ; hl = portal_data of portal "c"
    ld a, [hl+]
    ld e, a                         ; e = data[0]
    ld a, [hl+]
    ld d, a                         ; de = FutureBgScrollX
    ld a, [hl+]
    ld [FutureBgScrollYLsb], a
    ld a, [hl+]
    ld [FutureBgScrollYMsb], a
    ld a, [hl+]
    ld [PlayerPositionXLsb], a
    ld a, [hl+]
    ld [PlayerPositionXMsb], a      ; Directly set player's X location to the other portal point.
    ld a, [hl+]
    ld [PlayerPositionYLsb], a      ; Directly set player's Y location to the other portal point.
    ld a, [hl+]
    ld [PlayerPositionYMsb], a
    ld a, [hl]
    ld [TeleportDirection], a
    ld h, d
    ld l, e                         ; hl = FutureBgScrollX
    ld a, h
    or l
    jr z, .SetFutureBgScrollX       ; Jump if FutureBgScrollX == 0

    ld bc, 36                       ; Add 36 to X scroll if facing right.
    ld a, [FacingDirection]
    and $80
    jr z, :+                        ; Jump if facing right.
    ld bc, -48                      ; Subtract 48 from X scroll if facing left.
 :  add hl, bc

; $0ce5
.SetFutureBgScrollX:
    ld a, l
    ld [FutureBgScrollXLsb], a
    ld a, h
    ld [FutureBgScrollXMsb], a
    ld hl, SpriteToOamData
    ld b, 6 * 4
    call MemsetZero2                ; Reset player sprites.
    ld a, EVENT_SOUND_TELEPORT_START
    ld [EventSound], a
    ret

; $0cfb: Handles player being in a teleport. Immediately returns if player is not teleporting.
UpdateTeleport:
    ld a, [TeleportDirection]
    or a
    ret z                           ; Return if no teleport active.
    ld c, a
    and %10001000                   ; Check sign of teleport direction.
    jr z, TeleportL2RB2T            ; Jump of if both directions are positive.
    call TeleportYDirectionDown
    ld a, c
    and $0f
    ret z                           ; Return if no movement in X direction.
    ld b, 4
.ScrollLoop:                        ; Loop 4 times at most, decrement x scroll with each iteration.
    call CheckTeleportEndX
    ret z
    push bc
    call DecrementBgScrollX
    pop bc
    jr z, CheckTeleportEndX2
    dec b
    jr nz, .ScrollLoop
    ret

; $0d1d
; Input: Teleport direction in "c"
TeleportYDirectionDown:
    ld a, c
    and $f0
    ret z                           ; Return if no movement in Y direction.
    ld b, 4
.ScrollLoop:                        ; Loop 4 times at most, increment y scroll with each iteration.
    call CheckTeleportEndSoundY     ; Play sound if end point was reached. Sets 0 flag.
    ret z                           ; Return if end point was reached-
    push bc
    call IncrementBgScrollY         ; Updates screen?
    pop bc
    jr z, CheckTeleportEndSoundY2
    dec b
    jr nz, .ScrollLoop
    ret

; $d32
TeleportL2RB2T:
    call TeleportYDirectionUp
    ld a, c
    and $0f
    ret z
    ld b, 4
.ScrollLoop:                        ; Loop 4 times at most, increment x scroll with each iteration.
    call CheckTeleportEndX
    ret z
    push bc
    call IncrementBgScrollX
    pop bc
    jr z, CheckTeleportEndX2
    dec b
    jr nz, .ScrollLoop
    ret

; $d4a
TeleportYDirectionUp:
    ld a, c
    and $f0
    ret z
    ld b, 4
.ScrollLoop:                        ; Loop 4 times at most, decrement y scroll with each iteration.
    call CheckTeleportEndSoundY
    ret z
    push bc
    call DecrementBgScrollY
    pop bc
    jr z, CheckTeleportEndSoundY2
    dec b
    jr nz, .ScrollLoop
    ret

; $d5f
CheckTeleportEndX:
    ld a, [BgScrollXLsb]
    ld d, a
    ld a, [FutureBgScrollXLsb]
    cp d
    ret nz

    ld a, [BgScrollXMsb]
    ld d, a
    ld a, [FutureBgScrollXMsb]
    cp d
    ret nz

; $0d71:
CheckTeleportEndX2:
    ld a, [TeleportDirection]
    and $f0
    ld [TeleportDirection], a
    jr nz, :+
    ld a, EVENT_SOUND_TELEPORT_END
    ld [EventSound], a
 :  xor a
    ret

; $0d82: Check if end point of teleport is reached. Plays end sound if end point is reached.
; Sets 0 flag in end point is reached. There is also another check for the X axis..
CheckTeleportEndSoundY:
    ld a, [BgScrollYLsb]
    ld d, a
    ld a, [FutureBgScrollYLsb]
    cp d
    ret nz                          ; Return if Y LSB end position not reached.

    ld a, [BgScrollYMsb]
    ld d, a
    ld a, [FutureBgScrollYMsb]
    cp d
    ret nz                          ; Return if Y MSB end position not reached.

; $0d94
CheckTeleportEndSoundY2:
    ld a, [TeleportDirection]
    and $0f
    ld [TeleportDirection], a
    jr nz, :+
    ld a, EVENT_SOUND_TELEPORT_END
    ld [EventSound], a
 :  xor a
    ret

; $0da5
DpadUpContinued1:
    ld a, [PlayerOnLiana]
    and %1
    jp z, DpadUpContinued2

.OnLiana:
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    ret nz                          ; Return if left or right button is pressed.
    ld hl, PlayerPositionYLianaLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld d, h
    ld e, l
    call TrippleRotateShiftRightHl
    ld a, [CurrentLianaYPos8]
    or a
    jr z, jr_000_0dc9

    dec a
    cp l
    jp nc, $4825

jr_000_0dc9:
    ld a, [PlayerOnLianaYPosition]
    cp 3
    jr nc, jr_000_0de7

    ld a, [PlayerOnLiana]
    dec a
    jr z, jr_000_0ddb

    ld a, $05
    ld [PlayerOnLiana], a                   ; = $05

jr_000_0ddb:
    ld a, [LianaXPositionLsb]
    ld [PlayerPositionXLsb], a
    ld a, [LianaXPositionMsb]
    ld [PlayerPositionXMsb], a

jr_000_0de7:
    ld hl, PlayerPositionYLianaLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, h
    or a
    jr nz, jr_000_0df7

    ld a, l
    cp $24
    jp c, SetPlayerClimbing

jr_000_0df7:
    dec hl
    ld a, h
    ld [PlayerPositionYLianaMsb], a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [PlayerPositionYLianaLsb], a
    push hl
    sub c
    cp $48
    jr nc, jr_000_0e0d

    call DecrementBgScrollY

jr_000_0e0d:
    call HandlePlayerOnLianaYPosition
    ld c, $01
    pop hl
    ld a, [PlayerOnLiana]
    cp $03
    jp z, CheckPlayerClimb

    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    jp CheckPlayerClimb


; $0e26: This lets a player fly 1 pixel upwards when jumping or being knocked up.
FlyUpwards1Pixel:
    ld a, [BgScrollYLsb]
    add 40
    ld e, a
    ld a, [BgScrollYMsb]
    adc 0
    ld d, a                         ; de = BgScrollY + 40
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]                      ; h = PlayerPositionYMsb
    ld l, a                         ; l = PlayerPositionYLsb
    ld a, h
    cp d                            ; PlayerPositionYMsb - MSB(BgScrollY + 40)
    jr nz, .UpdatePlayerPositionY
    ld a, l
    cp e                            ; PlayerPositionYLsb - LSB(BgScrollY + 40)
    ret c

; $0e3f
.UpdatePlayerPositionY:
    dec hl                          ; --PlayerPositionY
    ld a, h
    ld [PlayerPositionYMsb], a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [PlayerPositionYLsb], a      ; Save decremented player position.
    sub c                           ; a = [PlayerPositionYLsb] - [BgScrollYLsb]
    cp 72
    jr nc, .NoDecrement
    call DecrementBgScrollY

; $0e54
.NoDecrement:
    ld c, $01
    jp CheckPlayerClimb

; $0e59: Calculates PlayerOnLianaYPosition.
HandlePlayerOnLianaYPosition:
    ld hl, PlayerPositionYLianaLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPositionYLiana]
    and %111
    srl a
    srl a
    ld e, a                         ; e = Bit 2 of [PlayerPositionYLiana]
    ld bc, -32
    add hl, bc                      ; hl = [PlayerPositionYLiana] - 32
    call TrippleRotateShiftRightHl  ; hl = ([PlayerPositionYLiana] - 32) / 8
    ld d, l
    ld a, [CurrentLianaYPos8]
    ld c, a                         ; c = [CurrentLianaYPos8]
    ld a, d
    sub c                           ; a = LSB(hl) - [CurrentLianaYPos8]
    jr nc, .NoCarry                 ; Jump if player did not yet reach top.
    xor a                           ; Player reached top.
    jr .SetPlayerOnLianaYPosition

; $0e79
.NoCarry:
    add a
    or e
    cp 16
    jr c, .SetPlayerOnLianaYPosition
    ld a, 15

; $0e81
.SetPlayerOnLianaYPosition:
    ld [PlayerOnLianaYPosition], a  ; = [0..15]
    ld a, [PlayerOnLiana]
    cp 1
    ret z                           ; Return if player is not swinging.
    and %100
    ret nz                          ; Return if liana is swinging without player.
    jp SetPlayerOnLianaPositions

; $0e90
DpadDownPressed:
    ld a, [LandingAnimation]
    or a
    ret nz
    ld a, [PlayerOnULiana]
    or a
    ret nz
    ld a, [CatapultTodo]
    or a
    ret nz
    ld a, [InShootingAnimation]
    or a
    ret nz
    ld a, [XAcceleration]
    and %1111
    ret nz                          ; Return if player is breaking.

    ld b, 4
    call CheckPlayerGround
    ld a, [CurrentGroundType]
    or a
    jp nz, DpadDownContinued        ; Jump if player is standing on solid ground.

    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    ret nz                          ; Return if left or right button is pressed.

    ld a, [PlayerOnLiana]
    rra
    ret nc

    ld hl, PlayerPositionYLianaLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    call TrippleRotateShiftRightHl
    ld a, [CurrentLianaYPos8]
    add $0c
    cp l
    jr nz, jr_000_0eda

    ld a, [PlayerOnLiana]
    dec a
    ret nz

    jp SetPlayerClimbing2


jr_000_0eda:
    ld hl, PlayerPositionYLianaLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl
    ld a, h
    ld [PlayerPositionYLianaMsb], a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [PlayerPositionYLianaLsb], a
    push hl
    sub c
    cp $58
    jr c, jr_000_0ef6

    call IncrementBgScrollY

jr_000_0ef6:
    call HandlePlayerOnLianaYPosition
    ld c, $ff
    pop hl
    ld a, [PlayerOnLiana]
    cp $03
    jr z, CheckPlayerClimb

    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    jr CheckPlayerClimb

; $0f0d: Increments the player's Y position and scrolls the window if the player is too close to the bottom.
; Furthermore, handles player's climbing animation in case the player is on a straight liana.
IncrementPlayerYPosition:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    inc hl                          ; hl = [PlayerPositionY] + 1
    ld a, h
    ld [PlayerPositionYMsb], a      ; Save [PlayerPositionY] + 1.
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    ld [PlayerPositionYLsb], a      ; Save [PlayerPositionY] + 1.
    sub c                           ; [PlayerPositionYLsb] - [BgScrollYLsb]
    cp 80
    jr c, CheckPlayerClimbDown
    call IncrementBgScrollY         ; Scroll down if player is too close to the bottom.

; $0f28
CheckPlayerClimbDown:
    ld c, -1

; $0f2a: Sets the player's state to climbing and handles climbing animation in case ([PlayerOnLiana] % 11) is non-zero
; Input: c = climbing direction of player (1 or -1)
CheckPlayerClimb:
    ld a, [LandingAnimation]
    or a
    ret nz
    ld a, [IsJumping]
    or a
    ret nz                          ; Return if player is jumping.
    ld a, [PlayerOnLiana]
    and %11
    cp 1
    ret nz                          ; Return if player is not climbing on liana.

; $0f3c
.PlayerIsClimbing:
    call SetPlayerClimbing
    jp LianaClimbAnimation

; $f42: Makes sure the scroll follows the player in Y direction.
ScrollYFollowPlayer:
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is currently teleporting. UpdateTeleport handles the Y scroll in these cases.
    ld a, [LookingUpDown]
    or a
    jr nz, LookingUpDownScroll      ; Jump if player is looking up or down.
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c                           ; BgScrollYLsb - PlayerPositionYLsb
    cp 56
    jp c, DecrementBgScrollY        ; Scroll up if (BgScrollYLsb - PlayerPositionYLsb) < 56
    cp 96
    ret c                           ; Return if 56 <= (BgScrollYLsb - PlayerPositionYLsb) < 80
    jp IncrementBgScrollY           ; Scroll down if (BgScrollYLsb - PlayerPositionYLsb) >= 80

; $0f60: Handles scroll follow in case the player is looking up or down.
; Input: "a" = LookingUpDown
LookingUpDownScroll:
    and $80
    jr z, LookingDownScroll
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c                           ; PlayerPositionYLsb - BgScrollYLsb
    cp 112
    ret nc
    jp DecrementBgScrollY

; $0f72
LookingDownScroll:
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c                           ; PlayerPositionYLsb - BgScrollYLsb
    cp 40
    ret c
    jp IncrementBgScrollY

; $0f80: Makes sure the scroll follows player in X direction.
ScrollXFollowPlayer:
    ld a, [PlayerOnLiana]
    cp $03
    ret z
    ld a, [IsJumping]
    or a
    ret nz                          ; Return if player is jumping
    ld a, [LandingAnimation]
    or a
    ret nz                          ; Return if player is landing.
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is currently teleporting.
    ld a, [XAcceleration]
    and %1111
    ret nz                          ; Return if player is breaking.
    ld a, [BgScrollXLsb]
    ld c, a
    ld a, [PlayerPositionXLsb]
    sub c
    ld b, a                         ; b = PlayerPositionXLsb - BgScrollXLsb
    ld a, [FacingDirection]
    ld c, a
    ld a, b
    bit 7, c
    jr z, .RightScroll              ; Jump if player is facing right.
    cp 120                          ; 120 - (PlayerPositionXLsb - BgScrollXLsb)
    ret nc
    jp DecrementBgScrollX
.RightScroll
    cp 40                           ; 40 - (PlayerPositionXLsb - BgScrollXLsb)
    ret c
    jp IncrementBgScrollX

; $0fb9: Selects a new weapon if SELECT was pressed.
HandleWeaponSelect:
    SwitchToBank 2
    call CheckWeaponSelect
    SwitchToBank 1
    ret

; $0fc3: Switches weapon to default banana when called.
SelectDefaultBanana:
    SwitchToBank 2
    xor a                           ; = 0 (default banana)
    call SelectNewWeapon
    SwitchToBank 1
    ret

; $fce: Updates displayed weapon number and updates WeaponActive.
HandleNewWeapon::
    SwitchToBank 1
    call UpdateWeaponNumber
    ld a, [WeaponSelect]
    ld c, a
    cp WEAPON_MASK
    jr z, MaskSelected            ; Jump if mask selected.
    or a
    jr z, UpdateWeaponActive     ; Jump if banana selected.
    ld a, [hl]                    ; Get number of projectiles left.
    or a
    jr z, UpdateWeaponActive     ; Jump if zero projectiles left.
    ld a, c
UpdateWeaponActive:
    ld [WeaponActive], a         ; = weapon number if projectiles; = 0 if no projectiles left or mask selected.
    ld a, c
    or a
    ret nz
    ld [InvincibilityTimer], a    ; = 0
    ret

; $0fee
MaskSelected:
    ld a, [hl]
    or a
    jr z, UpdateWeaponActive
    ld a, $ff
    ld [InvincibilityTimer], a
    xor a
    jr UpdateWeaponActive

; $0ffa
HandleScreenLockX:
    ld a, [ScreenLockX]
    or a
    ret z                           ; Return is ScreenLockX is zero.
    ld c, a
    ld a, [BgScrollXLsb]
    cp c                            ; BgScrollXLsb - ScreenLockX
    ret z
    jp nc, DecrementBgScrollX2      ; Scroll left.
    jr IncrementBgScrollX2          ; Scroll right.

; $100a
IncrementBgScrollX:
    ld a, [ScreenLockX]
    or a
    ret nz

; $100f
IncrementBgScrollX2:
    ld hl, WndwBoundingBoxXLsb
    ld c, [hl]                    ; c = WndwBoundingBoxXLsb
    inc hl
    ld b, [hl]                    ; b = WndwBoundingBoxXMsb
    ld hl, BgScrollXLsb
    ld e, [hl]                    ; e = BgScrollXLsb
    inc hl
    ld d, [hl]                    ; s = BgScrollXMsb
    ld a, d
    cp b
    jr nz, :+
    ld a, e
    cp c
    ret z
 :  inc de
    ld a, e
    and %111                      ; Every 8 pixels we need a new tile.
    jr z, .LoadNewTileXRight      ; Jump if new tile is needed.
    ld [hl], d
    dec hl
    ld [hl], e
    ret

.LoadNewTileXRight:
    ld a, [NeedNewXTile]
    or a
    ret nz
    inc a
    ld [NeedNewXTile], a            ; = 1
    ld [hl], d
    dec hl
    ld [hl], e
    call CalculateXScrolls
    ld hl, $c117
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $000a
    add hl, bc
    srl h
    rr l
    ld bc, Layer1BgPtrs
    add hl, bc
    ld a, [LevelWidthDiv32]
    ld b, $00
    ld c, a
    ld a, [BgScrollYDiv8Lsb]
    and $01
    xor $01
    ld d, a
    ld a, [BgScrollYDiv16TODO]
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
    jr z, Jump_000_1077

    srl a
    jr z, Jump_000_1077

jr_000_1073:
    add hl, bc
    dec a
    jr nz, jr_000_1073

Jump_000_1077:
    ld de, $c3c0
    ld a, [BgScrollYDiv16TODO]
    ld c, a
    ld a, [BgScrollYDiv8Lsb]
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
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    inc hl
    ld a, [BgScrollXDiv8Lsb]
    and $01
    jr z, Jump_000_10bb

    inc hl

Jump_000_10bb:
    call Call_000_10c5
    pop hl
    pop bc
    bit 0, c
    ret nz

    jr jr_000_1102

Call_000_10c5:
    ld bc, Ptr2x2BgTiles1
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
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl    ; hl = 4 * a
    ld a, [BgScrollXDiv8Lsb]
    and %1
    jr z, Jump_000_10f2
    inc hl
Jump_000_10f2:
    ld bc, Ptr2x2BgTiles1      ; Pointer to generic stuff.
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
    ld a, [LevelWidthDiv32]
    add l
    ld l, a
    ret nc
    inc h
    ret

; $110a
DecrementBgScrollX:
    ld a, [ScreenLockX]
    or a
    ret nz

; $110f
DecrementBgScrollX2:
    ld hl, WndwBoundingBoxXBossLsb
    ld c, [hl]                      ; c = WndwBoundingBoxXBossLsb
    inc hl
    ld b, [hl]                      ; b = WndwBoundingBoxXBossMsb
    ld hl, BgScrollXLsb
    ld e, [hl]                      ; e = BgScrollXLsb
    inc hl
    ld d, [hl]                      ; d = BgScrollXMsb
    ld a, d                         ; a = BgScrollXMsb
    cp b                            ; BgScrollXMsb - WndwBoundingBoxXBossMsb
    jr nz, .BgScrollXNotAtEnd
    ld a, e
    cp c                            ; BgScrollXLsb - WndwBoundingBoxXBossLsb
    ret z                           ; Return if screen cannot scroll any further in left X direction.

; $1122
.BgScrollXNotAtEnd:
    dec de                          ; --BgScrollX
    ld a, e
    and %111
    jr z, .LoadNewTileXLeft
    ld [hl], d
    dec hl
    ld [hl], e                      ; Write back BgScrollX.
    ret

; $112c
.LoadNewTileXLeft:
    ld a, [NeedNewXTile]
    or a
    ret nz
    dec a
    ld [NeedNewXTile], a            ; = $ff
    ld [hl], d
    dec hl
    ld [hl], e                      ; Save BgScollX.
    call CalculateXScrolls
    ld a, [BgScrollXDiv8Lsb]
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

    ld [NeedNewXTile], a
    ret


jr_000_1156:
    dec b

jr_000_1157:
    ld hl, Layer1BgPtrs
    srl b
    rr c
    add hl, bc
    ld a, [LevelWidthDiv32]
    ld b, $00
    ld c, a
    ld a, [BgScrollYDiv8Lsb]
    and $01
    xor $01
    ld d, a
    ld a, [BgScrollYDiv16TODO]
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
    ld a, [BgScrollYDiv16TODO]
    ld c, a
    ld a, [BgScrollYDiv8Lsb]
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
    ld a, [BgScrollXLsbDiv8]
    ld [$c11e], a
    ld a, [BgScrollYLsbDiv8]
    ld [$c123], a
    SwitchToBank 1
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
    ld a, [BgScrollXDiv8Lsb]
    and $01
    ld c, a
    ld a, [$c117]
    and $01
    xor c
    jr nz, jr_000_11d0

    inc hl

jr_000_11d0:
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    inc hl
    ld a, [BgScrollXDiv8Lsb]
    and $01
    jr nz, :+
    inc hl
 :  jp Jump_000_10bb

Call_000_11e5:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr z, jr_000_11f2

    inc hl
    inc hl

jr_000_11f2:
    ld a, [BgScrollXDiv8Lsb]
    and $01
    ld c, a
    ld a, [$c117]
    and $01
    xor c
    jr nz, jr_000_1201

    inc hl

jr_000_1201:
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [BgScrollXDiv8Lsb]
    and $01
    jr nz, jr_000_1211

    inc hl

jr_000_1211:
    jp Jump_000_10f2


; $1214:
; Input: e = scroll lsb, d = scroll msb
CalculateXScrolls:
    ld a, e
    call TrippleShiftRightCarry
    ld [BgScrollXLsbDiv8], a        ; =  BgScrollXLsb / 8
    call TrippleRotateShiftRight
    ld a, e
    ld [BgScrollXDiv8Lsb], a        ; = LSB of (BgScrollX >>3)
    srl d                           ; Shift rest of "d" right.
    rra                             ; Rotate "a" right through carry, hence a[7] = d[0].
    ld [$c117], a
    ld a, d
    ld [$c118], a                   ; [$c118] =  scroll msb / 16
    ret

; $122d
HandleScreenLockY:
    ld a, [ScreenLockY]
    or a
    ret z                           ; Return if ScreenLockY is 0.
    ld c, a
    ld a, [BgScrollYLsb]
    cp c                            ; BgScrollYLsb - ScreenLockY
    ret z
    jp c, IncrementBgScrollY2
    jr DecrementBgScrollY2

; $123d
DecrementBgScrollY:
    ld a, [ScreenLockY]
    or a
    ret nz

; $1242
DecrementBgScrollY2:
    ld hl, BgScrollYLsb
    ld e, [hl]                      ; e = BgScrollYLsb
    inc hl
    ld d, [hl]                      ; d = BgScrollYMsb
    ld a, d
    or e
    ret z                           ; Return BgScrollY is zero.
    dec de
    ld a, e
    and %111
    jr z, .LoadNewTileYTop          ; Every 8 pixels we need a new Y tile.
    ld [hl], d
    dec hl
    ld [hl], e                      ; --BgScrollY
    ret

; $1255
.LoadNewTileYTop:
    ld a, [NeedNewYTile]
    or a
    ret nz
    dec a
    ld [NeedNewYTile], a                 ; = $ff
    ld [hl], d
    dec hl
    ld [hl], e
    call CalculateYScrolls
    ld a, [BgScrollYDiv8Lsb]
    and %1
    xor %1
    ld c, a
    ld a, [BgScrollYDiv16TODO]
    sub c
    cp $ff
    jr nz, jr_000_1279
    xor a
    ld [NeedNewYTile], a            ; = 0
    ret

jr_000_1279:
    srl a
    push af
    ld hl, Layer1BgPtrs
    ld a, [LevelWidthDiv32]
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
    ld a, [BgScrollXDiv8Lsb]
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
    ld a, [BgScrollXDiv8Lsb]
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
    ld a, [BgScrollYDiv8Lsb]
    and $01
    ld c, a
    ld a, [BgScrollYDiv16TODO]
    and $01
    xor c
    jr nz, jr_000_12f2

    inc hl
    inc hl

jr_000_12f2:
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    ld a, [BgScrollYDiv8Lsb]
    and $01
    jr nz, Jump_000_1304

    inc hl
    inc hl

Jump_000_1304:
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
    ld a, [BgScrollYDiv8Lsb]
    and $01
    ld c, a
    ld a, [BgScrollYDiv16TODO]
    and $01
    xor c
    jr nz, jr_000_132a

    inc hl
    inc hl

jr_000_132a:
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [BgScrollYDiv8Lsb]
    and $01
  jr nz, Jump_000_133b

    inc hl
    inc hl

Jump_000_133b:
    ld bc, Ptr2x2BgTiles1
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


; $134c: Increment the background scroll in Y direction (down).
; Sets 0 flag if screen cannot scroll further to the right side.
IncrementBgScrollY::
    ld a, [ScreenLockY]
    or a
    ret nz

; $1351
IncrementBgScrollY2:
    ld hl, WndwBoundingBoxYLsb
    ld c, [hl]                      ; c = WndwBoundingBoxYLsb
    inc hl
    ld b, [hl]                      ; b = WndwBoundingBoxYMsb
    ld hl, BgScrollYLsb
    ld e, [hl]                      ; e = BgScrollYLsb
    inc hl
    ld d, [hl]                      ; d = BgScrollYMsb
    ld a, d                         ; a = BgScrollYMsb
    cp b                            ; BgScrollYMsb - WndwBoundingBoxYMsb
    jr nz, .BgScrollYNotAtEnd       ; Jump if end not reached.
    ld a, e
    cp c                            ; BgScrollYLsb - WndwBoundingBoxYLsb
    ret z                           ; Return if screen cannot scroll further to the right side.
.BgScrollYNotAtEnd:
    inc de                          ; BgScrollY + 1
    ld a, e
    and %111
    jr z, .LoadNewTileY              ; Jump if BgScrollYMsb is 0 or 8 -> Have to load a new tile.
    ld [hl], d                      ; hl = BgScrollYMsb
    dec hl
    ld [hl], e                      ; BgScrollY = BgScrollY + 1
    ret
.LoadNewTileY:
    ld a, [NeedNewYTile]                   ; TODO: What is this?
    or a
    ret nz                          ; TODO: Return if [NeedNewYTile] is non-zero.
    inc a
    ld [NeedNewYTile], a                   ; [NeedNewYTile] += 1
    ld [hl], d
    dec hl
    ld [hl], e                      ; BgScrollY += 1
    call CalculateYScrolls
    ld a, [BgScrollYDiv16TODO]
    add $09
    srl a
    push af
    ld hl, Layer1BgPtrs
    ld a, [LevelWidthDiv32]
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
    ld a, [BgScrollXDiv8Lsb]
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
    ld a, [BgScrollXDiv8Lsb]
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
    ld a, [BgScrollXLsbDiv8]
    ld [$c11f], a
    ld a, [BgScrollYLsbDiv8]
    ld [$c124], a
    SwitchToBank 1
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
    ld a, [BgScrollYDiv16TODO]
    and $01
    jr nz, jr_000_1402

    inc hl
    inc hl

jr_000_1402:
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    inc hl
    ld a, [BgScrollYDiv8Lsb]
    and $01
    jr z, jr_000_1414
    inc hl
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
    ld a, [BgScrollYDiv16TODO]
    and $01
    jr nz, jr_000_142c

    inc hl
    inc hl

jr_000_142c:
    ld bc, Ptr4x4BgTiles1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [BgScrollYDiv8Lsb]
    and $01
    jr z, jr_000_143d

    inc hl
    inc hl

jr_000_143d:
    jp Jump_000_133b

; $1440: Calculate Y scrolls.
; Input: e = scroll lsb, d = scroll msb
CalculateYScrolls:
    ld a, e
    call TrippleShiftRightCarry
    ld [BgScrollYLsbDiv8], a        ; = BgYScroll / 8
    call TrippleRotateShiftRight
    ld a, e
    ld [BgScrollYDiv8Lsb], a        ; = LSB of (BgScrollY >> 3)
    srl a
    ld [BgScrollYDiv16TODO], a                   ; BgScrollYDiv8Lsb >> 1
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
; Manipulates "e" and "d".
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

; $147f: Sets up "de" and "hl" to the start index of level map based on BgScrollXMsb and BgScrollYMsb.
GetLvlMapStartIndex:
    ld a, [BgScrollXMsb]
    and %00001111
    swap a
    srl a
    ld e, a                         ; e = lower BgScrollXMsb nibble left-shifted by 3: [-321 0---]
    ld a, [BgScrollYMsb]
    and %00001111
    swap a
    srl a
    ld d, a                         ; d = lower BgScrollYMsb nibble left-shifted by 3: [-321 0---]
    ld b, $00
    ld a, [LevelWidthDiv32]
    ld c, a                         ; bc = $0 [LevelWidthDiv32]
    ld h, d
    ld l, b                         ; hl = BgScrollYMsb: [-321 0--- ---- ----]
    ld a, 8                         ; The following loop is executed 8 times. Shouldn't 5 be sufficient?
 :  add hl, hl
    jr nc, :+
    add hl, bc                      ; Add LevelWidthDiv32 if a bit in "hl" was set,
 :  dec a
    jr nz, :--                      ; The loop is a multiplication: hl = LevelWidthDiv32 * BgScrollYMsb[-321 0---]
    ld d, $00
    add hl, de                      ; Now add X offset,
    ld d, h
    ld e, l
    ret

; $14aa
SoundAndJoypad:
    ld a, [OldRomBank]
    push af                     ; Save ROM bank.
    SwitchToBank 7
    call SoundTODO
    pop af
    rst LoadRomBank             ; Restore old ROM bank.
    call ReadJoyPad

; $14b9: Waits for the next phase.
WaitForNextPhase:
.Loop:
    halt
    ld a, [VBlankIsrFinished]
    and a
    jr z, .Loop                 ; Jump back as long VBlankIsrFinished is 0.
    xor a
    ld [VBlankIsrFinished], a   ; = 0
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

; $14fa
SetUpInterruptsSimple::
    ld a, IEF_VBLANK        ; Enable VBLANK interrupt.
    ld b, $00               ; rSTAT = 0.
    ld c, b                 ; rLYC = 0
    jr SetUpInterrupts

; $1501
SetUpInterruptsAdvanced::
    ld c, WINDOW_Y_START         ; rLYC = 119.
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

; $151d: Sets the carry flag if the player will attach to a liana. Flag is not set if player is already attached.
IsLianaCloseM32:
    ld b, -32
    jr IsLianaClose

; $1521: Sets the carry flag if the player will attach to a liana. Flag is not set if player is already attached.
IsLianaCloseM16:
    ld b, -16

; $1523: Sets the carry flag if the player can attach to a liana. Flag is not set if player is already attached.
; Input: b = Y offset
; Ouput: c = index to current tile the player is in
IsLianaClose:
    ld a, [NextLevel]
    cp 11
    ret nc                          ; Return if in transition Level (Level 12)
    ld a, [RunFinishTimer]
    or a
    ret nz                          ; Return if level was finished.
    ld a, [PlayerOnLiana]
    and %1
    ret nz                          ; Return if player on straight liana.
    ld c, $00
    call IsPlayerBottom
    ccf                             ; Invert carry flag.
    ret nc                          ; Return if player is at bottom.
    call GetCurrent2x2Tile
    ld c, a                         ; c = index to current tile the player is in
    cp $1e                          ; Straigth liana.
    jr z, LianaOnRightSide
    cp $c1                          ; In Level 10 liana has a different index.
    jr z, jr_000_158a
    cp $3f
    jr c, jr_000_1566
    ld a, [PlayerOnULiana]
    or a
    ret nz                          ; Return if player on U-liana.
    ld a, c
    cp $43
    ret c
    cp $c7
    jr c, jr_000_1566
    cp $cb
    jr nc, jr_000_1566
    ld a, [NextLevel]
    cp 10
    jr nz, jr_000_1566
    ld a, c
    scf
    ret

jr_000_1566:
    dec hl
    ld a, [hl]
    ld c, a
    cp $1e
    jr z, LianaOnLeftSide
    cp $c1
    jr z, jr_000_1573
    and a
    ret

jr_000_1573:
    ld a, [NextLevel]
    cp 10
    jr z, LianaOnLeftSide
    and a
    ret

; 157c
LianaOnLeftSide:
    ld a, [MovementState]
    cp STATE_LIANA_DROP
    ret z
    ld a, [PlayerPositionXLsb]
    and %1111
    cp 8
    ret

jr_000_158a:
    ld a, [NextLevel]
    cp 10
    ccf
    ret nc                          ; Return if not Level 10.

; $1591
LianaOnRightSide:
    ld a, [MovementState]
    cp STATE_LIANA_DROP
    ret z                           ; Return if currently dropping from a liana.
    ld a, [PlayerPositionXLsb]
    and %1111
    cp 8
    ccf
    ret

; $15a0: Clears the carry flag if the current 4x4 meta tile is part of a U-shaped liana.
IsAtULiana:
    call IsPlayerBottom
    ld hl, Layer1BgPtrs
    add hl, de
    ld c, [hl]
    ld a, [NextLevel]
    cp 10
    ld a, c
    jr z, .Level10

.NotLevel10:
    cp $4c
    ccf                             ; Invert carry flag.
    ret nc
    cp $4e
    ret                             ; Carry bit is set if $4c <= tile < $4e.

; $15b7
.Level10:
    cp $c8                          ; Level 10 uses a different palette with different values.
    ccf                             ; Invert carry flag.
    ret nc
    cp $ca
    ret                             ; Carry bit is set if $c8 <= tile < $ca.

; $15be: Checks if the player is in water or fire and handles corresponding damage.
CheckIfPlayerInWaterOrFire:
    xor a
    ld [PlayerInWaterOrFire], a     ; = 0
    ld c, %1                        ; Mask for the damage counter. Interestingly, water in Level 4 hurts more.
    ld a, [NextLevel]
    cp 4
    jr z, .Level4or5
    cp 5
    jr nz, .NotLevel4Or5
.Level5:
    ld c, %11                       ; Mask for the damage counter. Interestingly, water in Level 5 hurts less.

; $15d1
.Level4or5:                         ; Check if player is standing in water.
    ld a, [PlayerPositionYMsb]
    cp c
    ret c                           ; Return if player is about a certain Y position.
    jr nz, TakeWaterDamage
    ld a, [PlayerPositionYLsb]
    cp $f4
    ret c
    jr TakeWaterDamage

; $15e0
.NotLevel4Or5:
    cp 10
    ret nz                          ; Return if not level 10.

.Level10:                           ; Check if player is standing in fire.
    ld bc, (-12) << 8 | 0
    call IsPlayerBottom
    call GetCurrent2x2Tile
    cp $bc
    ret c                           ; Return if tile type < $bc
    cp $be
    ret nc                          ; Return if tile type >= $be
    ld c, %111                      ; Mask for the damage counter.

; $15f4
; Input: c = time counter mask to determine how often damage is received
TakeWaterDamage:
    ld [PlayerInWaterOrFire], a     ; != 0
    ld a, [TimeCounter]
    and c                           ; [TimeCounter] & damage mask
    ret nz
    ld a, [RedrawHealth]
    or a
    ret nz
    dec a
    ld [RedrawHealth], a            ; = $ff
    ld c, WATER_FIRE_DAMAGE

; $1607: Reduce CurrentHealth by the value in "c".
ReduceHealth:
    ld a, [CurrentHealth]
    sub c
    jr nc, .SkipCarry
    xor a                   ; = 0 in case "a" went negative.
.SkipCarry:
    ld [CurrentHealth], a
    ret nz                  ; Return if some health is left. Otherwise player dies.

; $1612: Called when the player dies. There are 3 cases in which this function is called:
; Player runs out of time, player runs out of health, player falls off the map.
PlayerDies:
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is currently teleporting.
    ld a, [RunFinishTimer]
    or a
    ret nz
    ld [IsJumping], a               ; = 0
    ld [LandingAnimation], a        ; = 0
    ld [PlayerOnLiana], a           ; = 0
    ld [PlayerOnULiana], a          ; = 0
    ld [CurrentGroundType], a       ; = 0
    ld [InvincibilityTimer], a      ; = 0
    ld [DynamicGroundDataType], a   ; = 0
    ld [BossActive], a              ; = 0
    dec a
    ld [MovementState], a                   ; = $ff
    ld [IsPlayerDead], a            ; = $ff
    ld a, 60
    ld [RunFinishTimer], a          ; = 60
    ld a, 19
    ld [PlayerKnockUp], a           ; = 19
    ld a, DEATH_ANIM_IND
    ld [AnimationIndexNew], a       ; = 29 (DEATH_ANIM_IND)
    ld a, $4c
    ld [CurrentSong], a
    ld a, EVENT_SOUND_DIED
    ld [EventSound], a
    ld a, [CurrentLives]
    dec a
    ld [CurrentLives], a            ; Reduce number of lives left.
    jp DrawLivesLeft


; $165e: Checks if player is on ground. Also checks if the player fell into a trench and dies.
CheckPlayerGroundNoOffset:
    ld b, $00

; $1660: Checks if player is on ground. Also checks if the player fell into a trench and dies.
; Input: bc = XY offset for IsPlayerBottom
CheckPlayerGround:
    ld a, [CatapultTodo]
    or a
    ret nz                          ; Return if player is being launched?
    ld c, $00
    ld a, [PlayerFreeze]
    or a
    jr nz, .Continue
    ld a, [RunFinishTimer]
    or a
    ret nz                          ; Return if level was finished.

.Continue:
    call IsPlayerBottom             ; Sets carry bit in case player hits bottom.
    jr nc, .NotAtBottom

.AtBottom:
    ld a, [NextLevel]               ; You reach this point when falling off the map.
    cp 4
    jr c, PlayerDies                ; Player dies if NextLevel <= 3.
    cp 6
    jr nc, PlayerDies               ; Player dies if NextLevel >= 6.
    ld a, $11                       ; You only don't die for the river levels.
    ret

; $1685
.NotAtBottom:
    push de
    call GetCurrent2x2Tile
    pop de
    ld l, a                         ; l = Index to current 2x2 meta tile.
    SwitchToBank 6
    call CheckGround
    push af
    SwitchToBank 1
    pop af
    ret

; $1697 Checks if player stands on static or dynamic ground. Accesses the data in $c400 (GroundDataRam).
; Sets carry flag if player stands on ground. ROM 6 is loaded before calling.
; Input: l = index to current 2x2 meta tile
CheckGround:
    ld h, HIGH(GroundDataRam)
    ld a, [hl]                      ; Get ground type of current 2x2 meta tile.
    or a
    jr z, .NotOnGround              ; If data is 0, player is not standing on map ground.

.OnGround
    ld c, a
    xor a
    ld [DynamicGroundDataType], a   ; = 0
    ld a, c
    jr .Continue

; $16a5
.NotOnGround:
    ld a, [DynamicGroundDataType]   ; Load [DynamicGroundDataType], which may contain non-static ground (platforms, turtles, etc.).

; $16a8
.Continue:
    ld [CurrentGroundType], a       ; = GroundDataRam[MetaTileOffset]
    or a
    ret z                           ; Return if zero,
    bit 6, a
    ret nz                          ; Return if Bit 6 is not zero.
    dec a
    swap a
    ld b, a
    and %11110000
    ld c, a
    ld a, b
    and %00001111
    ld b, a                         ; bc = ([CurrentGroundType] - 1) * 16
    ld hl, MetaTileGroundData
    add hl, bc
    ld c, $00
    ld a, [NextLevel]
    cp 3
    jr z, .Level3
    cp 5
    jr nz, .Continue2

.Level5:
    ld a, [CurrentGroundType]
    cp $21                          ; See MetaTileGroundData.
    jr c, .Continue2
    cp $25                          ; See MetaTileGroundData.
    jr c, .ElephantBalooGround      ; Jump if $21 <= [CurrentGroundType] < $25.

    jr .Continue2

; $16d9
.Level3:
    ld a, [CurrentGroundType]
    cp $20                          ; See MetaTileGroundData.
    jr z, .ElephantBalooGround
    and %11111
    cp $14
    jr c, .Continue2

; $16e6
.ElephantBalooGround:
    ld a, [DawnPatrolLsb]
    ld c, a

; $16ea
.Continue2:
    ld a, [DynamicGroundDataType]
    or a
    jr z, .NoDynamicGround          ; Jump if player is not dynamic ground, such as hippos or crocodiles.

    ld a, [DynamicGroundPlayerPosition]
    jr .Continue3

; $16f5
.NoDynamicGround:
    ld a, [PlayerPositionXLsb]
    add c

; $16f9
.Continue3:
    and $0f
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]                      ; Get ground data for the pixel the player is standing on.
    ld b, a                         ; b = ground data
    or a
    ret z                           ; Return if this data is 0 (no ground).

    ld a, [DynamicGroundDataType]
    or a
    jr z, .StaticGround

.DynamicGround:
    ld c, a
    push bc
    ld a, [DynamicGroundYPosition]
    ld c, a
    ld a, [PlayerPositionYLsb]
    sub c
    pop bc
    ccf
    ret nc
    cp 8
    jr c, .YPosCheck
    push bc
    ld b, a
    ld a, c
    cp $30
    ld a, b
    pop bc
    ret nc
    jr .YPosCheck

; $1724
.StaticGround:
    ld a, [PlayerPositionYLsb]

; $1727
.YPosCheck:
    and $0f
    ld c, a                         ; c = [PlayerPositionYLsb] & $0f
    ld a, 16
    sub c                           ; c = player's feet Y position
    cp b
    ret nz                          ; Return if player's feet Y position doesn't match ground data
    scf                             ; Else set carry.
    ret

; $1731: Returns an index to the 2x2 meta tile the player is currently standing in/on.
; Input: de (index of 4x4 meta tile)
; Output: a (index to a 2x2 meta tile the player is currently standing on)
GetCurrent2x2Tile:
    ld a, [ObjXPosition4To12]
    ld c, a
    ld a, [ObjYPosition4To12]
    ld b, a
    ld hl, Layer1BgPtrs
    add hl, de
    ld a, [hl]                  ; Get index from data in [Layer1BgPtrs + de].
    ld d, 0
    add a
    rl d
    add a
    rl d                        ; Rotate upper 2 bits of "a" into lower bits of "d".
    ld e, a                     ; e = a << 2. So "de" is data times 4.
    ld hl, Ptr4x4BgTiles1
    srl c
    jr nc, :+                   ; Jump if Y LSB bit 0 is 0.
    inc hl
 :  srl b
    jr nc, :+                   ; Jump if Y MSB bit 0 is 0.
    inc hl
    inc hl
 :  add hl, de                  ; hl = $cb00 + (index * 4) #
    SwitchToBank 1
    ld a, [hl]                  ; Load index to a 2x2 meta tile
    ret

; $175b: This function sets the carry bit in case the player hits the map's bottom.
; Input: bc position offset (b = Y; c = X)
IsPlayerBottom:
    ld hl, PlayerPositionXLsb
    ld a, [hl+]                     ; PlayerPositionXLsb
    ld h, [hl]                      ; PlayerPositionXMsb
    ld l, a                         ; hl = PlayerPositionX
    push bc
    ld b, 0
    bit 7, c
    jr z, :+
    dec b                           ; Sign-extend if "c" is negative.
 :  add hl, bc
    ld bc, $0110
    ld d, $15
    ld a, [NextLevel]
    cp 3
    jr z, .Level3                   ; Jump if NextLevel == 3 (DAWN PATROL)
    cp 5
    jr nz, .NotLevel5               ; Jump if NextLevel != 5 (IN THE RIVER)

.Level5:
    ld bc, $03d0
    ld d, $07

.Level3:
    ld a, [PlayerPositionYMsb]
    cp b
    jr nz, .NotLevel5

    ld a, [PlayerPositionYLsb]
    cp c
    jr c, .NotLevel5

    ld a, [DawnPatrolLsb]
    ld c, a
    ld a, [DawnPatrolMsb]
    ld b, a
    add hl, bc
    ld a, h
    sub d
    jr c, .NotLevel5

    ld h, a

.NotLevel5:
    sla l
    rl h
    sla l
    rl h
    sla l
    rl h                            ; hl = 8 * hl
    ld d, $00
    ld e, h
    sla l
    rl h                            ; hl = 16 * (PlayerPositionX + offset)
    ld a, h
    ld [ObjXPosition4To12], a
    ld hl, PlayerPositionYLsb
    ld a, [hl+]                     ; a = PlayerPositionYLsb
    ld h, [hl]                      ; h = PlayerPositionYMsb
    ld l, a                         ; hl = PlayerPositionY
    pop bc
    ld c, b
    ld b, $00
    bit 7, c
    jr z, :+
    dec b                           ; Sign-extend if "c" was negative.
 :  add hl, bc                      ; hl = PlayerPositionY + offset
    ld b, d                         ; b = $15, $7, or other value.
    ld c, e
    ld a, l
    and $f0
    swap a
    ld d, a                         ; d = l >> 4 (Bit 4 to Bit 7 of Y position)
    ld a, h
    and $0f
    swap a                          ; a = h << 4 (Bit 8 to Bit 11 of Y position)
    or d
    ld d, a                         ; d = Bit 4 to Bit 11 of Y position.
    ld [ObjYPosition4To12], a
    srl d
    ld a, [LevelHeightDiv32]
    cp d
    ret c                           ; Return if player does not touch the deadly bottom.
    scf                             ; Else set carry flag.
    ret z                           ; Return if player exactly touches the ground.
    push bc                         ; Push weird value.
    ld b, $00
    ld a, [LevelWidthDiv32]
    ld c, a                         ; c = [LevelWidthDiv32]
    ld h, d                         ; h = player Y position Bit 5 to Bit 12
    ld l, b                         ; l = 0
    ld a, 8

; $17e6: Loop 8 times. hl = index of 4x4 meta tile
.Loop:
    add hl, hl
    jr nc, .SkipCarry
    add hl, bc
.SkipCarry:
    dec a
    jr nz, .Loop

    pop de
    add hl, de
    ld d, h
    ld e, l
    ret

; $17f2: Called for for the ball projectile thrown by monkeys.
; Input: hl = pointer to ball projectile object
; Output: Sets carry if ball collided with the ground.
CheckBallGroundCollision:
    push hl
    call GetCurrent4x4Tile
    call GetCurrent2x2Tile
    ld l, a
    SwitchToBank 6
    call IsBallCollision
    push af
    SwitchToBank 1
    pop af
    pop hl
    ret

; $1807: Checks if the ball projectile hit the ground.
; Input: Index to current 2x2 tile in "l".
IsBallCollision:
    ld h, HIGH(GroundDataRam)
    ld a, [hl]
    or a
    ret z                           ; Return if projectile is in the air.
    bit 6, a
    ret nz                          ; Return if Bit 6 is non-zero.
    dec a
    swap a
    ld b, a
    and $f0
    ld c, a
    ld a, b
    and $0f
    ld b, a
    ld hl, MetaTileGroundData
    add hl, bc
    ld a, [ObjXPosition0To7]
    and %1111                       ; a = [WindowScrollXLsb] & %1111
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]                      ; Load the ground data for the corresponding pixel.
    or a
    ret z                           ; Return if zero.
    ld b, a
    ld a, [ObjYPositionLsb]
    and %1111                       ; a = [ObjYPositionLsb] & %1111
    ld c, a
    ld a, 16                        ; Get bottom Y position of the ball.
    sub c
    cp b
    ret nz                          ; Return if no collision.
    scf                             ; Set carry flag if there was a collision.
    ret

; $1838 Called with object in "hl". Result ("de") should be an index to the 4x4 meta tile the object is currently in.
GetCurrent4x4Tile:
    GetAttribute ATR_X_POSITION_LSB
    ld [ObjXPosition0To7], a         ; [ObjXPositionLsb] = obj[ATR_X_POSITION_LSB]
    ld e, a                         ; e = obj[ATR_X_POSITION_LSB]
    inc c
    rst GetAttr
    ld d, a                         ; d = obj[ATR_X_POSITION_MSB]
    sla e
    rl d
    sla e
    rl d
    sla e
    rl d                            ; de = obj[ATR_X_POSITION] << 3
    ld c, d
    sla e
    rl d
    ld a, d                         ; de = obj[ATR_X_POSITION] << 4.
    ld [ObjXPosition4To12], a
    push bc                         ; push ((obj[ATR_X_POSITION] << 3) >> 8)
    GetAttribute ATR_Y_POSITION_LSB
    ld [ObjYPositionLsb], a         ; [ObjYPositionLsb] = obj[ATR_Y_POSITION_LSB]
    ld e, a
    inc c
    rst GetAttr                     ; a = obj[ATR_Y_POSITION_MSB]
    ld d, a                         ; d = obj[ATR_Y_POSITION_MSB]
    ld a, e
    and $f0                         ; obj[ATR_Y_POSITION_LSB] & 0xf0
    swap a
    ld b, a                         ; b = upper nibble of obj[ATR_Y_POSITION_LSB] in lower nibble
    ld a, d
    and $0f                         ; obj[ATR_Y_POSITION_MSB] & 0x0f
    swap a                          ; a = lower nibble of obj[ATR_Y_POSITION_MSB] in upper nibble
    or b                            ; b = (obj[ATR_Y_POSITION] & 0x0ff0) >> 4
    ld [WindowScrollYMsb], a
    srl a
    pop de
    ld h, a                         ; h = (obj[ATR_Y_POSITION] & 0x0ff0) >> 5
    ld b, $00                       ; b = 0
    ld a, [LevelWidthDiv32]
    ld c, a                         ; c = [LevelWidthDiv32]
    ld l, b                         ; l = 0
    ld a, 8

; Basically a multiplication loop that determines the offset in Y-direction.
.Loop:                              ; Loop 8 times.
    add hl, hl                      ; hl = hl << 1
    jr nc, :+                       ; Jump if last bit in hl wss not 1.
    add hl, bc                      ; hl += [LevelWidthDiv32]
 :  dec a
    jr nz, .Loop

    add hl, de                      ; Add X offset.
    ld d, h
    ld e, l
    ret

; $1889: Check if player collided into items or was hit by an enemy projectile.
CheckPlayerCollisions:
    ld a, [RunFinishTimer]
    or a
    ret nz                          ; Disable collisions when level is in finishing animation.
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Disable collisions when player is currently teleporting.
    ld hl, CollisionCheckObj
    push hl
    xor a
    ld [hl+], a                     ; = 0 -> Collision check for player.
    ld a, [PlayerWindowOffsetX]
    ld c, a
    sub 4
    ld [hl+], a                     ; ScreenOffsetXTLCheckObj = PlayerWindowOffsetX - 4
    ld d, 32                        ; Offset when standing.
    ld a, [IsCrouching]
    or a
    jr z, :+                        ; Jump if player is not crouching.
    ld d, 16                        ; Offset when crouching.
 :  ld a, [PlayerWindowOffsetY]
    ld b, a
    sub d
    ld [hl+], a                     ; ScreenOffsetYTLCheckObj = PlayerWindowOffsetY - (IsCrouching ? 16 : 32 )
    ld a, c
    add 4
    ld [hl+], a                     ; ScreenOffsetXBRCheckObj = PlayerWindowOffsetX + 4
    ld a, b
    sub 2
    ld [hl+], a                     ; ScreenOffsetYBRCheckObj = PlayerWindowOffsetY - 2
    pop de
    ld a, b
    cp 116                          ; ScreenOffsetYBRCheckObj - 116
    jp nc, NoPlatformGround

    call CheckEnemyProjectileCollisions
    jr c, CollisionDetected             ; Jump if player was hit by an enemy projectile.

    call CheckGeneralCollision
    ret nc                              ; Continue if player had a collision with an item or enemy.

; $18c8: This seems to be some kind of collision event between player and objects.
; Input: hl = pointer to object
CollisionDetected:
    ld a, [PlayerFreeze]
    or a
    jp nz, CollisionDuringFreeze
    ld c, ATR_HEALTH
    rst GetAttr
    inc a
    jp z, ReceiveSingleDamage       ; Jump if health was $ff
    ld c, ATR_ID
    rst GetAttr                     ; a = object id
    cp ID_DIAMOND                   ; $89: Diamond.
    jp z, DiamondCollected
    cp ID_MOSQUITO
    jr nz, :+
    set 1, [hl]                     ; Set Bit 1 if object is mosquito.
    jp ReceiveSingleDamage
 :  cp $97                          ; See object IDs.
    jr c, :+
    cp $a1
    jp c, ItemCollected             ; Called when a>=$97 && a<$a1. $97 = pineapple, $9a = grapes, $9b = extra life, $9c = mask, $9d = extra time, $9e = shovel, $9f double banana, $a0 = boomerang
 :  ld b, a
    cp ID_MONKEY_COCONUT
    jr z, ReceiveContinuousDamage   ; a=$92: Hit by a monkey's coconut (both flying and bouncing).
    cp ID_KING_LOUIE_COCONUT
    jr z, ReceiveContinuousDamage
    cp ID_SNAKE_PROJECTILE
    jr z, ReceiveContinuousDamage
    cp ID_CROCODILE
    jr z, ReceiveSingleDamage
    cp ID_HIPPO
    jr z, ReceiveSingleDamage
    cp ID_LIGHTNING
    jr z, ReceiveSingleDamage
    ld a, [LandingAnimation]
    or a
    jr z, ReceiveSingleDamage
    ld a, [FallingDown]
    cp 16
    jr c, ReceiveSingleDamage
    inc hl
    ld a, [hl-]                         ; a = ATR_Y_POSITION_LSB
    ld c, a
    ld a, [BgScrollYLsb]
    sub c
    ld c, a                             ; c = BgScrollYLsb - ATR_Y_POSITION_LSB
    ld a, [PlayerWindowOffsetY]
    add 8                               ; a = PlayerWindowOffsetY + 8
    cp c                                ; (PlayerWindowOffsetY + 8) - (BgScrollYLsb - ATR_Y_POSITION_LSB)
    jr nc, ReceiveSingleDamage          ; If objects is hit from the side or from below, receive single damage.
    ld a, b                             ; Player jumped on the object. Now check which kind of object,
    cp ID_FISH
    jr z, ReceiveSingleDamage           ; Hopped on a fish -> receive damage.
    cp ID_LIZZARD
    jr z, .FreezeEnemy                  ; Hopped on a lizzard -> freeze the lizzard.
    cp $71                              ; = ID_ARMADILLO_WALKING
    jr c, :+
    cp $81
    jr c, ReceiveSingleDamage           ; Hoppend on armadillo or porcupine -> receive damage.
 :  cp ID_CRAWLING_SNAKE
    jr nz, .HopKill

; $193b: When hopped on enemy that cannot be killed (snake, lizzard, etc.), the enemy freezes.
.FreezeEnemy:
    ld a, EVENT_SOUND_HOP_ON_ENEMY
    ld [EventSound], a
    ld a, ENEMY_FREEZE_TIME
    ld c, ATR_FREEZE
    rst SetAttr
    jr KillKnockUp

; $1947: Jumped to when an enemy was kill by hopping on it.
; Hop kills give 300 points which is way more than a projectile kill.
.HopKill:
    ld a, EVENT_SOUND_HOP_ON_ENEMY
    ld [EventSound], a
    ld a, SCORE_ENEMY_HOP_KILL
    call DrawScore3
    GetAttribute ATR_LOOT
    swap a
    and $0f
    jr z, .NoLootDrop               ; Jump if enemy doesn't drop loot.
    call DropLoot
    jr KillKnockUp

; $195f
.NoLootDrop:
    SafeDeleteObject
    SetAttribute ATR_PERIOD_TIMER0, $14
    SetAttribute ATR_09, $01
    jr KillKnockUp

; $196d: Reduces health by 1 and plays sound in case player is not invincible. Does not grant invicibility.
ReceiveContinuousDamage::
    DeleteObject                    ; Delete the projectile.
    ld c, 1
    jr ReceiveDamage

; $1973: Reduces health by 4/2 (practice/normal) and plays a sound in case player is not invincible.
; A hit grants invincibility for ~1.5 seconds.
ReceiveSingleDamage::
    ld c, ENEMY_HIT_DAMAGE          ; In normal mode you receive 4 damage.
    ld a, [DifficultyMode]
    or a
    jr z, ReceiveDamage
    dec c
    dec c                           ; In practice mode you receive 2 damage.

; $197d: Input: "c" = damage to receive.
ReceiveDamage::
    ld a, [InvincibilityTimer]
    or a
    ret nz                          ; Not receiving damage if invincible.
    ld a, [RedrawHealth]
    or a
    ret nz                          ; Not receiving damage if health wasn't redrawn in the meantime.
    dec a
    ld [RedrawHealth], a            ; = $ff
    ld a, EVENT_SOUND_DAMAGE_RECEIVED
    ld [EventSound], a              ; Play sound for receiving damange.
    ld a, c
    cp 2
    jr c, :+                        ; 1 damage is inflicted by stuff like water and does not grant invincibility.
    push bc
    call DamageKnockUp              ; Called when player received more than 1 damage.
    pop bc
    ld a, INVINCIBLE_AFTER_HIT_TIME
    ld [InvincibilityTimer], a      ; After receiving damage the player becomes invincible for ~1.5 second.
 :  jp ReduceHealth

; $19a2
KillKnockUp:
    ld a, [FacingDirection]
    ld [KnockUpDirection], a
    ld a, 12
    jr KnockUp

; $19ac: Player is knocked up when receiving more than 1 damage.
DamageKnockUp:
    ld a, [PlayerOnLiana]
    and %1
    ret nz
    ld a, [PlayerOnULiana]
    or a
    ret nz
    ld a, [DynamicGroundDataType]
    or a
    ret nz                          ; Return if player is standing on dynamic ground.
    GetAttribute ATR_FACING_DIRECTION
    and $0f
    jr z, .NoFacingDirection        ; Jump if object not facing any direction.
    bit 3, a
    jr z, .HasFacingDirection       ; Jump if object facing right.
    or $f0
    jr .HasFacingDirection

; $19cb
.NoFacingDirection:
    ld a, [FacingDirection]
    cpl
    inc a

; $19d0
.HasFacingDirection:
    ld [KnockUpDirection], a
    ld a, [LandingAnimation]
    or a
    jr nz, .jr_000_19e1
    ld a, [UpwardsMomemtum]
    or a
    jr z, .NoUpwardsMomentum
    cp 12

.jr_000_19e1:
    ld a, 11
    jr c, KnockUp

; $19e5
.NoUpwardsMomentum:
    ld a, 17

; $19e7
KnockUp:
    ld [PlayerKnockUp], a           ; = 11, 12, or 17
    ld a, FALL_VERT_ANIM_IND
    ld [AnimationIndexNew], a       ; = 68 (FALL_VERT_ANIM_IND)
    xor a
    ld [WalkingState], a            ; = 0
    ld [IsJumping], a               ; = 0
    ld [UpwardsMomemtum], a         ; = 0
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld [HeadTiltCounter], a         ; = 0
    ld [XAcceleration], a           ; = 0
    ld [LookingUpDown], a           ; = 0
    ret

; $1a09: Only called if collision between player and a dynamic ground (turtle, crocodile, hippo, sinking stone, falling platform) is detected.
DynamicGroundCollision:
    GetAttribute ATR_ID
    ld e, GROUND_TYPE_CROC
    cp ID_CROCODILE
    jr z, HippoCrocCollision

    ld e, GROUND_TYPE_HIPPO
    cp ID_HIPPO
    jr z, HippoCrocCollision

    cp ID_TURTLE
    jp z, TurtleCollision

    ld e, GROUND_TYPE_PLATFORM
    cp ID_FALLING_PLATFORM
    jr z, FallingPlatformCollision

    cp ID_SINKING_STONE
    ret nz

SinkingStoneCollision:
    ld e, GROUND_TYPE_STONE
    call CheckGroundXFlip
    ld a, [NextLevel]
    cp 4
    jp nz, CheckDynamicGround

    GetAttribute ATR_FALLING_TIMER
    or a
    jp nz, CheckDynamicGround

    bit 0, [hl]
    jp nz, CheckDynamicGround

    ObjMarkedSafeDelete
    jp nz, CheckDynamicGround

    ld a, 32
    rst SetAttr                     ; obj[ATR_FALLING_TIMER] = 32
    jr CheckDynamicGround

; $1a49: Only jumped to in case of a falling platform.
; Input: hl = pointer to falling platform object.
FallingPlatformCollision:
    ld a, [LandingAnimation]
    or a
    jr nz, FallingPlatformCollision2

    ld a, [IsJumping]
    or a
    jr nz, FallingPlatformCollision2

    ld a, l
    ld [FallingPlatformLowPtr], a
    ld a, [NextLevel]
    cp 10
    jr z, FallingPlatformCollision2               ; Jump if Level 10. I guess these are the falling platforms of Shere Khan.

    ld c, ATR_FALLING_TIMER
    rst GetAttr
    or a
    jr nz, FallingPlatformCollision2              ; Jump if timer is non-zero.

    ObjMarkedSafeDelete
    jr nz, FallingPlatformCollision2              ; Jump if object is in destructor.

    ld a, FALLING_PLATFORM_TIME
    rst SetAttr                                    ; Initializes timer of the falling platform.
    jr FallingPlatformCollision2

; $1a6f
HippoCrocCollision:
    ld a, e
    cp GROUND_TYPE_HIPPO
    jr nz, .HandleCroc

.HandleHippo:
    SetAttribute ATR_Y_POS_DELTA, 1 ; Let the crocodile sink.
    xor a
    ld c, ATR_PERIOD_TIMER0
    jr jr_000_1a8e

; $1a7e
.HandleCroc:
    GetAttribute ATR_09
    or a
    jr nz, FallingPlatformCollision2

    ld a, 2
    rst SetAttr
    GetAttribute ATR_PERIOD_TIMER0
    add a
    jr nc, jr_000_1a8e

    xor a

jr_000_1a8e:
    rst SetAttr

; $1a8f
FallingPlatformCollision2:
    ld a, [BgScrollXLsb]
    ld d, a
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    sub d                           ; d = ObjectWindowOffsetX = ATR_X_POSITION_LSB - BgScrollXLsb
    sub 16
    ld d, a                         ; d = ObjectWindowOffsetX - 16
    ld a, [PlayerWindowOffsetX]
    sub d                           ; a = PlayerWindowOffsetX - (ObjectWindowOffsetX - 16) = PlayerOffsetX from falling platform using left corner as anchor
    jr c, NoPlatformGround          ; Jump if player is still left to the platform.
    cp 32                           ; PlayerOffsetFallingPlatformX - 32
    jr nc, NoPlatformGround         ; Jump if player is right to the platform.
    cp 16                           ; PlayerOffsetFallingPlatformX - 16
    jr c, :+                        ; Jump if player is on the platforms left sprite.
    inc e                           ; e = $31. This point is reached if the player is standing on the platform's right side.
    and $0f
 :  ld [DynamicGroundPlayerPosition], a    ; = $1 if player on right side, = $30 if player on left side
    call CheckGroundXFlip
    jr SetDynGroundTypeAndYPos

; $1ab3: Toggles the ground data in case the object is not flipped.
; Input: e = ground data type
; Output: e = adjusted ground data type
CheckGroundXFlip:
    GetAttribute ATR_SPRITE_PROPERTIES
    and SPRITE_X_FLIP_MASK
    ret nz                          ; Return if sprite is X-flipped.
    ld a, e
    xor 1                           ; Toggle Bit 0.
    ld e, a
    ret

; $1abe:
TurtleCollision:
    ld e, GROUND_TYPE_TURTLE
    SetAttribute2 ATR_09, $02

; $1ac5
CheckDynamicGround:
    ld a, [BgScrollXLsb]
    ld d, a
    GetAttribute ATR_X_POSITION_LSB
    sub d
    sub 8
    ld d, a                         ; object window x posiition = obj[ATR_X_POSITION_LSB] - [BgScrollXLsb] - 8
    ld a, [PlayerWindowOffsetX]
    sub d                           ; Get X position difference between object and player.
    jr c, NoPlatformGround          ; Player too far left for ground.
    cp 16
    jr nc, NoPlatformGround         ; Player too far right for ground.
    ld [DynamicGroundPlayerPosition], a ; = X position difference between object and player in pixels

; $1add
SetDynGroundTypeAndYPos:
    GetAttribute ATR_Y_POSITION_LSB
    sub 16                          ; a = obj[ATR_Y_POSITION_LSB] - 16
    ld [DynamicGroundYPosition], a
    ld a, e
    ld [DynamicGroundDataType], a
    xor a
    ret

; $1aeb
NoPlatformGround:
    xor a
    ld [DynamicGroundDataType], a   ; = 0
    ld [DynamicGroundPlayerPosition], a  ; = 0
    ld [DynamicGroundYPosition], a  ; = 0
    dec a
    ld [FallingPlatformLowPtr], a   ; = $ff
    xor a
    ret

; $1afb: Called when an enemy was killed and drops its loot.
; Input: a = loot index, hl = object pointer to defeated enemy
; 1 = diamond, 2 = pineapple, 3 = health package, 4 = extra life,  5 = mask, 6 = extra time, 7 = shovel, 8 = double banana, 9 = boomerang
DropLoot:
    push af
    ld c, ATR_ID
    rst GetAttr
    cp ID_HANGING_MONKEY2
    jr nz, :+
    SafeDeleteObject
 :  pop af
    push hl
    dec a
    ld b, $00
    ld c, a                         ; bc = loot index.
    ld hl, LootIdToObjectId
    add hl, bc
    ld a, [hl]                      ; Get type ID of the loot.
    pop hl
    ld c, ATR_ID
    rst SetAttr                      ; Store type ID in defeated enemy object
    ld a, [hl]
    and $50
    ld [hl], a                      ; [obj] = $50 & [obj]
    inc c
    ld a, $90
    rst SetAttr                      ; [obj + 6] = $90
    inc c
    xor a
    rst SetAttr                      ; [obj + 7] = 0
    inc c
    rst SetAttr                      ; [obj + 8] = 0
    inc c
    inc c
    inc c
    rst SetAttr                      ; [obj + $b] = 0
    inc c
    rst SetAttr                      ; [obj + $c] = 0
    inc c
    rst SetAttr                      ; [obj + $d] = 0
    inc c
    rst SetAttr                      ; [obj + ATR_PERIOD_TIMER1_RESET] = 0
    inc c
    ld a, $02
    rst SetAttr                      ; [obj + $f] = 2 (pineapple hitbox)
    inc c
    rst GetAttr                      ; a = [obj + $10]
    push af
    inc c
    rst GetAttr                      ; a = [obj + ATR_OBJECT_DATA]
    srl a
    ld de, ActiveObjectsIds
    add e
    ld e, a
    xor a
    ld [de], a                       ; [ActiveObjectsIds + [obj + ATR_OBJECT_DATA]] = 0
    rst SetAttr                      ; [obj + ATR_OBJECT_DATA] = 0
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
    ld hl, StaticObjectData
    add hl, de
    add hl, bc
    ld d, h
    ld e, l
    pop hl
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData
    ret

; $1b5c: Called when all diamonds in a level were collected.
AllDiamondsCollected:
    call Add5kToScore
    ld a, EVENT_SOUND_LVL_COMPLETE
    ld [EventSound], a
    ld a, [NextLevel]
    bit 0, a
    ret z                       ; Return if level is even (boss level). 2 (Kaa), 4 (Baloo), 6 (monkeys), 8 (King Louie), 10 (Shere Khan).

; $1b6a: Reset variables. Called when a level is completed.
ResetVariables:
    xor a
    ld [BossActive], a              ; = 0
    ld [InvincibilityTimer], a      ; = 0
    ld [CheckpointReached], a       ; = 0
    ld [PlayerKnockUp], a           ; = 0
    ld c, a
    dec a
    ld [RunFinishTimer], a          ; = $ff
    ld [PlayerFreeze], a            ; = $ff
    ld a, [BgScrollXLsb]
    ld [ScreenLockX], a
    ld a, [BgScrollYLsb]
    ld [ScreenLockY], a
    jp SetPlayerIdle

; $1b8e
DiamondCollected:
    call MarkAsFound
    call DiamondFound
    jr z, AllDiamondsCollected           ; Jump if number of missing diamonds reaches zero.
    ld a, EVENT_SOUND_ITEM_COLLECTED
    ld [EventSound], a

; $1b9b: Called when diamond was collected. Adds 5000 points to the score.
Add5kToScore:
    ld a, SCORE_DIAMOND         ; Gives 5000 points
    call DrawScore2
    ld a, ID_5000LABEL

; $1ba2: Label ID needs to be in "a".
ChangeItemToLabel:
    ld c, ATR_ID
    rst SetAttr                  ; obj[ATR_ID] = a -> Changes object's ID.
    GetAttribute ATR_SPRITE_PROPERTIES
    and ~SPRITE_INVISIBLE_MASK
    rst SetAttr
    set 5, [hl]                  ; Set Bit 5 in object.

; $1bad
CollisionDuringFreeze:
    SetAttribute ATR_PERIOD_TIMER0, 23
    SetAttribute ATR_09, 1
    SetAttribute ATR_PERIOD_TIMER1_RESET, 0
    inc c
    rst SetAttr                     ; obj[ATR_HITBOX_PTR] = 0 -> Object has no hitbox.
    SafeDeleteObject
    ret

; $1bc0: Called when an item (weapon, life, checkpoint, ...) was collected.
; "a" determines the item.
; pineapple = $97, checkpoint = $98, health package = $9a, extra life = $9b,  mask = $9c
; extram time = $9d, showel = $9e, double banana = $9f, boomerang = $a0
ItemCollected:
    cp ID_PINEAPPLE
    jr nz, CheckHealthPackage
    ld a, [NextLevel]
    cp 10                          ; Next level 10?
    jp z, ReceiveContinuousDamage  ; In Level 10 (THE WASTELANDS), this is Shere Khan's flame projectile.
    jr Add1kScore                  ; Pineapple collected.

; $1bce
CheckHealthPackage:
    cp ID_GRAPES                    ; grapes/health package = $9a
    jr nz, CheckExtraLife
    ld a, HEALTH_ITEM_HEALTH        ; Health package was collected.
    ld [CurrentHealth], a           ; Fully restore CurrentHealth.
    ld a, $0f
    ld [RedrawHealth], a            ; = $0f
    jr Add1kScore

; $1bde
CheckExtraLife:
    cp ID_EXTRA_LIFE
    jr nz, CheckMask
    call MarkAsFound
    ld a, [CurrentLives]
    inc a
    cp MAX_LIFES
    jr nc, :+
    ld [CurrentLives], a
 :  call DrawLivesLeft
    ld a, ID_1UPLABEL
    jr ItemCollected2

; $1bf7: Usually medicine man mask. In the bonus level this is a leaf granting an additional continue.
CheckMask:
    cp ID_MASK_OR_LEAF
    jr nz, CheckExtraTime
    ld a, [NextLevel]
    cp 11                                       ; In Level 11 (Bonus) the numbers of continues is increased.
    jr nz, :+
    ld a, [NumContinuesLeft]
    inc a
    ld [NumContinuesLeft], a                    ; Increase number of continues left by one.
    jr UpdateWeaponNumberAndAdd1kScore
 :  ld a, [CurrentSecondsInvincibility]
    add MASK_SECONDS
    daa
    jr nc, :+
    ld a, $99                                   ; Overflow to 99s.
 :  ld [CurrentSecondsInvincibility], a

; $1c18
UpdateWeaponNumberAndAdd1kScore:
    push hl
    call UpdateWeaponNumber
    pop hl
; $1c1d
Add1kScore:
    ld a, SCORE_PINEAPPLE
    call DrawScore2
    ld a, ID_1000LABEL

; $1c24: First ItemCollected is called. Then ItemCollected2.
ItemCollected2:
    call ChangeItemToLabel
    xor a
    ld [ItemDespawnTimer], a                   ; = 0
    ld a, EVENT_SOUND_ITEM_COLLECTED
    ld [EventSound], a
    ld a, [NextLevel]
    cp 11
    ret nz                          ; Return if not bonus level.
.BonusLevel:
    ld a, [MissingItemsBonusLevel]
    dec a
    ld [MissingItemsBonusLevel], a  ; Reduce number of missing items.
    ret nz                          ; Return if there are still some missing items.
    jp FinishLevel                  ; Bonus level finished by collecting all items.

; $1c41
CheckExtraTime:
    cp ID_EXTRA_TIME
    jr nz, CheckBonusLevel
    ld a, [NextLevel]
    cp 11
    jr z, :+                        ; No extra time in Level 11.
    ld a, [DifficultyMode]
    ld c, a
    ld a, [DigitMinutes]            ; Add 1 minute in normal mode and 2 minutes in practice mode.
    inc a
    add c
    ld [DigitMinutes], a
    ld de, $9cd0
    call DrawBigNumber
 :  ld a, SCORE_EXTRA_TIME
    call DrawScore3
    ld a, ID_500LABEL
    jr ItemCollected2

; $1c67
CheckBonusLevel:
    cp ID_SHOVEL
    jr nz, CheckDoubleBanana
    ld [BonusLevel], a              ; = $9e
    call MarkAsFound
    jr Add1kScore

; $1c73
CheckDoubleBanana:
    cp ID_DOUBLE_BANANA
    jr nz, CheckBoomerang
    ld a, [NextLevel2]
    inc a
    cp 4
    jr c, :+                       ; Below Level 4 or in odd levels this gives a double banana.
    and %1
    jr nz, :+                      ; Jump if odd.
    ld a, WEAPON_STONES
    jr IncreaseWeaponBy20
 :  ld a, WEAPON_DOUBLE_BANANA

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
    ld a, ID_100LABEL
    jp ItemCollected2

; $1ca6
CheckBoomerang:
    cp ID_BOOMERANG
    jr nz, CheckCheckpoint
    ld a, WEAPON_BOOMERANG
    jr IncreaseWeaponBy20

; $1cae
CheckCheckpoint:
    cp ID_CHECKPOINT
    ret nz
    GetAttribute ATR_PERIOD_TIMER1_RESET
    dec a
    ret nz
    ld a, 3
    rst SetAttr                     ; [hl + ATR_PERIOD_TIMER1_RESET] = 3
    inc c
    xor a                           ; a = 0
    rst SetAttr                     ; [hl + ATR_HITBOX_PTR] = 0 -> no hitbox
    ld a, $08
    ld [CheckpointReached], a       ; Checkpoint reached.

; $1cc1: [$d726], [$d727] = $03, $00
; No inputs, changes "a".
PositionFromCheckpoint:
    push hl
    ld hl, StaticObjectData + $26
    ld [hl], 3                      ; [$d726] = 3. TODO: What is this used for?
    inc hl
    ld [hl], 0                      ; [$d727] = 0. TODO: What is this used for?
    pop hl
    ld a, EVENT_SOUND_ITEM_COLLECTED
    ld [EventSound], a
    ret

; $1cd1: [$c6:[hl + $10]] = a
MarkAsFound:
    push af
    ld c, ATR_STATUS_INDEX
    rst GetAttr
    ld d, HIGH(ObjectsStatus)
    ld e, a
    pop af
    ld [de], a                      ; [$c6:[hl + $10]] = $89 (in case of diamond)
    ret

; $1cdb: Checks collisions of the 4 player projectiles.
CheckProjectileCollisions:
    ld hl, ProjectileObjects
    ld b, NUM_PROJECTILE_OBJECTS

; $1ce0:
ProjectileCollisionLoop:
    IsObjEmpty
    jr nz, SkipProjectileCollision
    IsObjOnScreen
    jr z, SkipProjectileCollision
    push bc
    push hl
    call SetupCheckObjectHitbox             ; hl = projectile.
    call CheckCollisionGeneralObjects
    pop de
    pop bc
    jr c, HandleProjectileCollisionEvent    ; If carry bit is set, there was a collision.

; $1cf4: Jumped to if the projectile just flies through the object.
NoProjectileCollision:
    ld h, d
    ld l, e

; $1cf6
SkipProjectileCollision:
    ld a, l
    add SIZE_PROJECTILE_OBJECT
    ld l, a
    dec b
    jr nz, ProjectileCollisionLoop
    SwitchToBank 1
    ret

; $1d01: Called if there was a player's projectile collision. Let's figure out the details.
; Inputs: hl = pointer to item/enemy, de = pointer to projectile
HandleProjectileCollisionEvent:
    push bc
    ld c, ATR_ID
    rst GetAttr                     ; Get ID of hit object and determine the reaction.
    pop bc
    cp ID_CROCODILE
    jr z, NoProjectileCollision     ; Projectiles pass through crocodiles.
    cp ID_FISH
    jr z, NoProjectileCollision     ; Projectiles pass through fishes.
    cp ID_HIPPO
    jr z, NoProjectileCollision     ; Projectiles pass through hippos.
    cp ID_LIGHTNING
    jr z, NoProjectileCollision     ; Projectiles pass through lightnings.
    cp ID_FALLING_PLATFORM          ; Projectiles pass through falling platforms.
    jr z, NoProjectileCollision
    cp ID_TURTLE                    ; Projectiles pass through turtles.
    jr z, NoProjectileCollision
    cp ID_SINKING_STONE             ; Projectiles pass through sinking stones.
    jr z, NoProjectileCollision
    cp ID_MOSQUITO
    jr nz, :+
    set 1, [hl]                     ; Set Bit 1 in object[0] if a mosquito enemy is hit.
 :  cp $71                          ; ID_ARMADILLO_WALKING
    jr c, :+                        ; Jump if ID is less than $71.
    cp $81
    jr nc, :+                       ; Jump if ID is more than $81.
    bit 2, a                        ; Object is either an armadillo or a porcupine. Bit 2 tells if it is rolling.
    jp nz, DeleteProjectileObject   ; Delete projectile object if hit enemy is a rolling armadillo/porcupine. They are invulnerable when rolling.

 :  ld c, ATR_HEALTH
    rst GetAttr
    ld c, a
    inc a
    jr nz, EnemyHitByProjectile     ; Jump if health was not $ff. Health is only $ff for bosses.
    ld a, [BossActive]
    or a
    jp z, DeleteProjectileObject    ; Jump if no boss is currently active.

; $1d43
BossHitByProjectile:
    ld a, [BossDefeatBlinkTimer]
    or a
    jp nz, DeleteProjectileObject   ; Delete projectile if boss was defeated and is now in blinking state.
    ld a, [BossMonkeyState]
    or a
    jp nz, DeleteProjectileObject   ; State is only zero if the monkeys are in their vulnerable state.

; $1d51: This point is reached if a targetable enemy is hit by a projectile,
; Inputs: de = projectile pointer, hl pointer to enemy/item
EnemyHitByProjectile:
    ld a, EMPTY_OBJECT_VALUE
    ld [de], a                      ; This deletes the projectile.
    ld a, c
    cp ENEMY_INVULNERABLE           ; If the enemy has a health of $0f, you get no points.
    jr z, :+
    ld a, SCORE_ENEMY_HIT
    call DrawScore3
 :  ld a, EVENT_ENEMY_HIT
    ld [EventSound], a
    ld c, ATR_SPRITE_PROPERTIES
    rst GetAttr
    or SPRITE_WHITE_MASK
    rst SetAttr                     ; Let sprite blink.
    ld a, WHITEOUT_TIME
    ld [WhiteOutTimer], a           ; = 4
    ld a, [WeaponActive]            ; Glitch: Using the active weapon is not the shot weapon! Damage calculator is broken!
    add a                           ; a = 2 * a
    jr nz, .NonDefaultBanana
    ld a, DAMAGE_BANANA
.NonDefaultBanana:
    inc a
    ld d, a
    ld a, [DifficultyMode]
    or a
    jr z, .NormalMode
    sla d                           ; Projectiles deal 2x damage in practice mode.
; "d" contains the damage of the projectile: d = damage = (weapon_index * 2 + 1) * (NormalMode ? 1 : 2)
.NormalMode:
    ld c, ATR_HEALTH
    rst GetAttr                     ; a = health of enemy
    cp $ff                          ; Special value for bosses.
    jr z, BossHit
    ld b, a
    and $0f                         ; Only lower nibble is the health.
    jr z, Enemy0Hp
    cp ENEMY_INVULNERABLE
    jr z, InvulnerableEnemyHit
    sub d                           ; Reduce health of enemy.
    jr c, Enemy0Hp                  ; Defeated if negativ health.
    jr z, Enemy0Hp                  ; Defeated if exactly 0 health.
    ld e, a
    ld a, b
    and $f0
    or e
    rst SetAttr                     ; health = former health - d
    ret

; $1d9c: Invulnerable enemies hit by a projectile only freeze and don't lose health.
InvulnerableEnemyHit:
    ld a, ENEMY_FREEZE_TIME
    ld c, ATR_FREEZE
    rst SetAttr
    ret

; $1da2
Enemy0Hp:
    xor a
    ld [WhiteOutTimer], a           ; = 0
    inc a                           ; a = 1
    rst LoadRomBank                 ; Load ROM bank 1.
    ld a, b                         ; "b" contains object attribute $17 (health and loot).
    swap a
    and %1111                       ; Get the kind of loop the enemy drops.
    jr z, DropNoLoot                ; Jump if enemy doesn't drop anything.
    jp DropLoot

; $1db2
OneBossMonkeyDefeated:
    ld l, a
    ld a, MONKY_BOSS_FULL_HEALTH    ; 15 health for a single monkey of the monkey boss.
    ld [BossHealth], a              ; = 15
    xor a
    ld c, ATR_HEALTH
    rst SetAttr                     ; health = 0
    or $10
    ld [hl], a                      ; Setting Bit 7 in obj[0] deletes it.

; $1dbf: "hl" points to defeated object that does not drop any loot.
DropNoLoot:
    SafeDeleteObject
    SetAttribute ATR_PERIOD_TIMER0, 17
    SetAttribute2 ATR_09, $01
    GetAttribute ATR_SPRITE_PROPERTIES
    and $f0                         ; Retains upper nibble.
    ld b, a
    ld a, [FacingDirection]         ; Interesting: Object falls in player's facing direction when killed.
    and $0f
    or b
    rst SetAttr                     ; = Sprite properties | player's facing direction
    ret

; $1dd9: Deletes the projectile object residing in [de].
DeleteProjectileObject:
    ld a, EMPTY_OBJECT_VALUE
    ld [de], a
    ret

; $1ddd: Called when a boss was hit with a projectile.
; Input: d = damage of the projectile.
BossHit:
    call Call_000_3c60
    ld a, [BossHealth]
    sub d
    jr c, BossFinalHit
    ld [BossHealth], a              ; [BossHealth] -= damage
    ret nz

; $1dea: Final hit of the boss or a part of it (in case of the monkeys).
BossFinalHit:
    xor a
    ld [BossHealth], a              ; = 0
    ld a, [NextLevel]
    cp 6
    jr nz, BossDefeated             ; Jump if NOT Level 6: TREE VILLAGE

    ld a, [BossAnimation2]
    inc a
    jr z, SecondBossMonkeyIsDefeated

    ld a, $ff
    ld [BossAnimation2], a
    ld a, [BossObjectIndex2]
    jr OneBossMonkeyDefeated

; $1e05
SecondBossMonkeyIsDefeated:
    ld a, [BossAnimation1]
    inc a
    jr z, BossDefeated

    ld a, $ff
    ld [BossAnimation1], a
    ld a, [BossObjectIndex1]
    jr OneBossMonkeyDefeated

; $1e15: Jumped to if the boss (or all parts of it) was finally defeated.
BossDefeated:
    ld a, SCORE_BOSS_DEFEATED
    call DrawScore2
    SafeDeleteObject
    ld a, EVENT_SOUND_BOSS_DEFEATED
    ld [EventSound], a
    ld a, BOSS_DEFEAT_BLINK_TIME
    ld [BossDefeatBlinkTimer], a
    ld a, [NextLevel]
    cp 2
    ret nz                            ; Continue if in Level 2: THE GREAT TREE.

    SetAttribute $0d, $13
    inc c
    ld a, $19
    rst SetAttr
    ret


; $1e36: Calculates screen coordinates for the check object hitbox.
; Input: hl = check object pointer
SetupCheckObjectHitbox:
    ld a, [BgScrollYLsb]
    ld d, a
    ld a, [BgScrollXLsb]
    ld e, a
    ld c, ATR_Y_POSITION_LSB
    rst GetAttr
    sub d
    ld d, a
    inc c
    inc c
    rst GetAttr                      ; Get ATR_X_POSITION_LSB
    sub e
    ld e, a
    ld c, ATR_HITBOX_PTR
    rst GetAttr
    or a
    ret z                           ; Return if no hitbox.
    push af
    dec a
    add a
    add a                           ; a = (hitbox_ptr - 1) * 4
    ld hl, HitBoxData
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl+]                     ; a = hitbox x1
    add e
    ld c, a
    ld a, [hl+]                     ; a = hitbox y1
    add d
    ld b, a
    ld a, [hl+]                     ; a = hitbox x2
    add e
    ld e, a
    ld a, [hl+]                     ; a = hitbox y2
    add d
    ld d, a
    pop af
    ld hl, CollisionCheckObj
    push hl
    ld [hl+], a                     ; Store collision check object hitbox pointer.
    ld [hl], c                      ; ScreenOffsetXTLCheckObj
    inc hl
    ld [hl], b                      ; ScreenOffsetYTLCheckObj
    inc hl
    ld [hl], e                      ; ScreenOffsetXBRCheckObj
    inc hl
    ld [hl], d                      ; ScreenOffsetYBRCheckObj
    pop de
    ret

; $1e73: Checks for collisions for all general objects (items, enemies).
CheckGeneralCollision:
    call NoPlatformGround
    ld bc, (NUM_GENERAL_OBJECTS << 8) | SIZE_GENERAL_OBJECT;
    ld hl, GeneralObjects
.CollisionLoop:
    push bc
    call CheckObjectCollision       ; Calls collision detection.
    pop bc
    jr nc, .NoCollision
    bit 5, [hl]
    ret z                           ; Return if Bit 5 is not set.
    push bc
    push de
    call DynamicGroundCollision
    pop de
    pop bc
    scf
    ret nz
.NoCollision:
    ld a, l
    add c                           ; Add objects size of 32 bytes.
    ld l, a
    dec b                           ; Loop for 8 times.
    jr nz, .CollisionLoop
    and a
    ret

; $1e97: Checks collisions for one of four general objects.
CheckCollisionGeneralObjects:
    ld bc, SIZE_GENERAL_OBJECT
    ld hl, GeneralObjects
    ld a, [TimeCounter]             ; Object index (e [0,3]) is determined by TimeCounter.
    and %11
    jr z, :++

 :  add hl, bc
    dec a
    jr nz, :-

 :  call CheckObjectCollision
    ret c                           ; Return if there was a collision.

    ld a, l
    add SIZE_GENERAL_OBJECT * 4     ; Ok, which object is here?
    ld l, a
    jr CheckObjectCollision

; $1eb2: Checks if enemy projectiles are colliding with something.
CheckEnemyProjectileCollisions:
    ld hl, EnenemyProjectileObject0
    ld a, [TimeCounter]
    rra
    jr nc, CheckObjectCollision2        ; Enemy Projectile 0 is checked every even time. (30 times a second).

    ld hl, EnenemyProjectileObject1     ; Enemy Projectile 1 is checked every odd time. (30 times a second).
    and a
    jr CheckObjectCollision2

; $1ec1: Check if there is a collision for given object in "hl".
CheckObjectCollision:
    and a
    bit 5, [hl]
    jr nz, CheckObjectCollision2

    ObjMarkedSafeDelete
    jr nz, SkipCollisionDetection   ; Skip collision detection if object is in destructor.

; $1eca: Check if there is a collision for given object in "hl".
CheckObjectCollision2:
    IsObjOnScreen
    jr z, SkipCollisionDetection

    bit 7, [hl]
    jr nz, SkipCollisionDetection   ; Skip collision detection if object is being deleted.

    push de
    push hl
    call CollisionDetection
    pop hl
    pop de

; $1ed9
SkipCollisionDetection:
    SwitchToBank 1
    ret

; $1edd: Collision detection I guess. Called with ROM bank 1 loaded.
; Input: de = object we check collision against (Mowgli, or projectile), hl = acting object
; If b != 0 and item is object -> Skip!
CollisionDetection:
    ld c, ATR_SPRITE_PROPERTIES
    rst GetAttr
    and SPRITE_INVISIBLE_MASK
    ret nz
    GetAttribute ATR_12
    cp $ad
    ret z
    ld a, [de]                      ; Points to CollisionCheckObj.
    inc de
    push de
    push af
    ld a, [BgScrollYLsb]
    ld d, a                         ; d = BgScrollYLsb
    ld a, [BgScrollXLsb]
    ld e, a                         ; e = BgScrollXLsb
    ld c, ATR_Y_POSITION_LSB
    rst GetAttr
    sub d
    ld d, a                         ; Get Y screen offset of object: d = object_y_position_lsb - BgScrollYLsb
    inc c
    inc c
    rst GetAttr
    sub e
    ld e, a                         ; Get X screen offset of object: e = object_x_position_lsb - BgScrollXLsb
    GetAttribute ATR_HITBOX_PTR
    pop bc
    or a
    jr z, CollisionDetectionEnd     ; Jump to end if object does not have a hit box.
    cp $02
    jr nz, :+

    ld c, a
    ld a, b
    or a
    jr nz, CollisionDetectionEnd
    ld a, c

 :  dec a
    add a
    add a                           ; a = (hitbox_ptr - 1) * 4
    ld hl, HitBoxData
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl+]
    add e
    ld c, a                         ; c = data[0] + (object_x_position_lsb - BgScrollXLsb) -> Screen relative hit box x1
    ld a, [hl+]
    add d
    ld b, a                         ; b = data[1] + (object_y_position_lsb - BgScrollYLsb) -> Screen relative hit box y1
    ld a, [hl+]
    add e
    ld e, a                         ; e = data[2] + (object_x_position_lsb - BgScrollXLsb) -> Screen relative hit box x2
    ld a, [hl+]
    add d
    ld d, a                         ; d = data[3] + (object_y_position_lsb - BgScrollYLsb) -> Screen relative hit box y2

    bit 7, d                        ; Check for sign.
    jr nz, :+                       ; Jump if object out of screen in Y direction.
    bit 7, b                        ; Check for sign.
    jr z, :+                        ; Jump if object out of screen in Y direction.
    ld b, $00                       ; Set to 0 if object in screen in Y direction.
 :  bit 7, e                        ; Check for sign.
    jr nz, :+                       ; Jump if object out of screen in X direction.
    bit 7, c                        ; Check for sign.
    jr z, :+                        ; Jump if object out of screen in X direction.
    ld c, $00                       ; Set to 0 if object in screen in X direction.
 :  pop hl

    ld a, [hl+]                     ; a = [ScreenOffsetXTLCheckObj]
    cp e                            ; [ScreenOffsetXTLCheckObj] - (hitbox screen relative x2)
    ret nc                          ; Return if check object is on the right side of check box.
    ld a, [hl+]                     ; a = [ScreenOffsetYTLCheckObj]
    cp d                            ; [ScreenOffsetYTLCheckObj] - (hitbox screen relative y2)
    ret nc                          ; Return if check object is below.
    ld a, c
    cp [hl]                         ; (hitbox screen relative x1) - [ScreenOffsetXBRCheckObj
    ret nc                          ; Return if check object is on the left side of the object.
    inc hl
    ld a, b
    cp [hl]                         ; (hitbox screen relative y1) - [ScreenOffsetYBRCheckObj
    ret                             ; Result will be in carry bit.

; $1f48:
CollisionDetectionEnd:
    pop de
    ret

; $1f4a: Transfer's player sprites to the VRAM, handles fire/water animation, drawing of the health bar and a few other things.
AnimationSpriteTransfers:
    ld a, [NeedNewXTile]
    or a
    ret nz                          ; Return if new X tile of the map is needed.
    ld a, [NeedNewYTile]
    or a
    ret nz                          ; Return if new X tile of the map is needed.
    ld a, [$c1cf]
    or a
    ret nz
    ld a, [AnimationIndexNew]
    ld c, a
    ld a, [AnimationIndex]
    cp c
    jr nz, PlayerSpriteVramTransfer ; Jump if player switches to new animation.

    ld a, [CatapultTodo]
    and $80
    jp nz, CopyCatapultTiles

    call DrawHealthIfNeeded
    call WaterFireAnimation
    call CheckLianaTileMapRedraw
    ret c

    jp CopyObjectSpritesToVram

; $1f78
PlayerSpriteVramTransfer:
    SwitchToBank 2
    ld a, [AllPlayerSpritesCopied]
    or a
    call z, PrepPlayerSpriteVramTransfer
    ld a, [VramAnimationPointerLsb]
    ld e, a
    ld a, [VramAnimationPointerMsb]
    ld d, a
    ld hl, AnimationIndex2PointerLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = pointer to element in PlayerAnimationIndices
    ld b, 4
    ld a, [NumPlayerSpritesToDraw]
    ld c, a                         ; c = [NumPlayerSpritesToDraw]

; $1f96
.Loop:
    ld a, [hl+]                     ; a = PlayerAnimationIndices[i]
    sub 2
    jr nz, .NotTwo

; $1f9b
.WeirdLabel:
    dec c
    jr nz, .Loop
    jr .End

    ; Is this point reachable?!
    pop hl
    pop bc
    jr .WeirdLabel

; $1fa4
.NotTwo:
    push bc
    push hl
    sub 2
    swap a
    ld b, a
    and %11110000
    ld c, a
    ld a, b
    and %1111
    ld b, a                         ; bc = (PlayerAnimationIndices[i] - 4) * 16
    ld hl, PlayerSpritePointerMsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = pointer to sprite palette
    add hl, bc                      ; Add offset to load right subset
    call CopyToVram                 ; Copy one tile from PlayerSprites.
    pop hl
    pop bc
    dec c
    jr z, .End

    dec b
    jr nz, .Loop

; $1fc4
.End:
    SwitchToBank 1
    ld a, l
    ld [AnimationIndex2PointerLsb], a
    ld a, h
    ld [AnimationIndex2PointerMsb], a ; hl was currently pointing somewhere into PlayerAnimationIndices
    ld a, e
    ld [VramAnimationPointerLsb], a
    ld a, d
    ld [VramAnimationPointerMsb], a
    ld a, c
    ld [NumPlayerSpritesToDraw], a
    or a
    ret nz                          ; Can this be non-zero?
    ld [AllPlayerSpritesCopied], a  ; = 0
    ld a, [AnimationIndexNew3]
    ld [AnimationIndex], a          ; = [AnimationIndexNew3]
    ld a, [VramAnimationPointerToggle]
    ld [VramAnimationPointerToggle2], a ; Only set here.
    ld a, [$c16b]
    ld [PlayerSpriteYOffset], a     ; = [$c16b]
    ld a, [$c16d]
    ld c, a
    ld b, $00
    bit 7, c
    jr z, .IsPositive
    dec b                           ; = $ff in case "c" is negative
.IsPositive:
    xor a
    ld [$c16d], a                   ; = 0
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc                      ; hl = PlayerPositionX + [$c16d]
    ld a, l
    ld [PlayerPositionXLsb], a      ; [PlayerPositionXLsb] += bc
    ld a, h
    ld [PlayerPositionXMsb], a      ; [PlayerPositionXMsb] += bc
    ld a, [$c16e]
    ld c, a
    xor a
    ld [$c16e], a                   ; = 0
    ld a, [PlayerPositionYLsb]
    add c
    ld [PlayerPositionYLsb], a      ; [PlayerPositionYLsb] += [$c16e]
    ld a, [PlayerOnLiana]
    and %11
    cp $03
    ret nz
    ld a, [PlayerSwingAnimIndex]
    ld [PlayerSwingAnimIndex2], a   ; = [PlayerSwingAnimIndex]
    jp SetPlayerOnLianaPositions

; $2036: Copies 16 Bytes from [hl] to [de] with respect to the OAM flag.
CopyToVram16::
    ld c, LOW(rSTAT)
    ld b, STATF_OAM
    jr CopyToVramByte16

; $2036: Copies 32 Bytes from [hl] to [de] with respect to the OAM flag.
; Both "hl" and "de" are increased. Yes, the loop is unrolled.
CopyToVram::
    ld c, LOW(rSTAT)
    ld b, STATF_OAM
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 0.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 1.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 2.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 3.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 4.
    ld [de], a
    inc de
:   ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 5.
    ld [de], a
    inc de
:   ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 6
    ld [de], a
    inc de
:   ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 7.
    ld [de], a
    inc de
:   ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 8.
    ld [de], a
    inc de
:   ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 9.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 10.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 11.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 12.
    ld [de], a
    inc de
  : ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 13.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 14.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 15.
    ld [de], a
    inc de
CopyToVramByte16::
    ldh a,[c]
    and b
    jr nz, CopyToVramByte16   ; Wait for OAM.
    ld a, [hl+]              ; Byte 16.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 17.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 18.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 19.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 20.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 21.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 22.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 23.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 24.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 25.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 26.
    ld [de], a
    inc de
:   ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 27.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 28.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 29.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 30.
    ld [de], a
    inc de
 :  ldh a,[c]
    and b
    jr nz, :-                 ; Wait for OAM.
    ld a, [hl+]               ; Byte 31.
    ld [de], a
    inc de
    ret

; $211b: Copy object sprites to VRAM
CopyObjectSpritesToVram:
    ld hl, JumpTimer
    ld a, [hl]
    or a
    ret z
    ld c, a
    SwitchToBank 4
    ld a, c
    ld b, $00
    call Call_000_21dc
    ld a, [ObjSpriteVramPtrLsb]
    ld e, a
    ld a, [ObjSpriteVramPtrMsb]
    ld d, a
    ld hl, ObjAnimationIndexPtrLsb
    ld a, [hl+]
    ld h, [hl]                      ; a = [ObjAnimationIndexPtrMsb]
    ld l, a                         ; hl = ObjAnimationIndices + offset for the corresponding animation
    ld b, 4                         ; Maximum number of sprites to copy.
    ld a, [ObjNumSpritesToDraw]
    ld c, a                         ; c = [ObjNumSpritesToDraw]

.CopyLoop:
    ld a, [hl+]
    sub $02
    jr nz, .CopySprite              ; Skip values of 2.

.SkipSprite:
    dec c
    jr nz, .CopyLoop
    jr .DoneCopying

; $2149
.CopySprite:
    push bc
    push hl
    sub $02
    swap a
    ld b, a
    and $f0
    ld c, a
    ld a, b
    and $0f
    ld b, a                         ; bc = [ObjAnimationIndices + offset] * 16 (because a sprite is 16 byte in size)
    ld hl, ObjSpritePointerLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [ObjSpritePointer] (hl now points to the right sprite palette)
    add hl, bc                      ; Find right sprite in the palette.
    ld a, [ObjSpriteRomBank]
    add 5                           ; Offset of 5 (see ObjectSpritePointers).
    rst LoadRomBank
    call CopyToVram                 ; Copy sprites into VRAM.
    SwitchToBank 4
    pop hl
    pop bc
    dec c
    jr z, .DoneCopying

    dec b
    jr nz, .CopyLoop

.DoneCopying:
    SwitchToBank 1
    ld a, l
    ld [ObjAnimationIndexPtrLsb], a
    ld a, h
    ld [ObjAnimationIndexPtrMsb], a
    ld a, e
    ld [ObjSpriteVramPtrLsb], a
    ld a, d
    ld [ObjSpriteVramPtrMsb], a
    ld a, [JumpTimer]
    ld b, a
    ld a, c
    ld [ObjNumSpritesToDraw], a
    or a
    ret nz                          ; Return if there are sprites left to copy.

    ld [JumpTimer], a               ; = 0
    dec a
    ld [$c1a7], a                   ; = $ff
    ld a, b
    cp $80
    ret z

    ld h, HIGH(GeneralObjects)
    ld a, [ActionObject]
    ld l, a                         ; hl = pointer to object
    GetAttribute ATR_06
    cp $90
    jr nc, jr_000_21da

    GetAttribute $17
    inc a
    jr nz, jr_000_21c7

    ld a, [NextLevel]
    cp 2
    jr z, jr_000_21c7

    ld a, [$c1a6]
    ld c, $15
    rst SetAttr
    inc c
    ld a, [NumObjSpriteIndex]
    rst SetAttr
    bit 5, [hl]
    jr z, jr_000_21d8

    res 0, [hl]
    jr jr_000_21da

jr_000_21c7:
    GetAttribute ATR_06
    and $01
    ld b, a
    ld a, [$c1a6]
    or b
    rst SetAttr                     ; Sets ATR_06.
    ld a, [NumObjSpriteIndex]
    ld c, ATR_12
    rst SetAttr

jr_000_21d8:
    res 3, [hl]

jr_000_21da:
    inc a
    ret

; $21dc: Input: hl + 1 = offset to general object
Call_000_21dc:
    cp $80
    jr z, GetNumberOfSprites        ; TODO
    dec a
    ret nz                          ; Return if input was !=1
    dec a                           ; a = $ff
    ld [hl+], a                     ; = $ff
    ld a, [hl]
    ld h, HIGH(GeneralObjects)
    ld l, a                         ; hl = pointer to corresponding object
    GetAttribute ATR_OBJECT_DATA
    inc b
    bit 3, a
    jr z, jr_000_21f1

    inc b

jr_000_21f1:
    xor b
    rst SetAttr
    ld [$c1a7], a
    and %111
    add a
    add a
    ld c, a                         ; c = ([$c1a7] & %111) * 4
    add a
    add a
    add c
    add $18
    ld [$c1a6], a
    swap a
    ld b, a
    and $f0
    ld [ObjSpriteVramPtrLsb], a
    ld a, b
    and $0f
    or $80
    ld [ObjSpriteVramPtrMsb], a
    GetAttribute ATR_06
    and %1
    ld b, a

; $2219
GetNumberOfSprites:
    ld a, [NumObjSpriteIndex]
    ld c, a                         ; bc = (obj[ATR_06] % 1 << 8) | [NumObjSpriteIndex]
    ld hl, NumObjectSprites
    add hl, bc
    ld a, [hl]
    ld e, a
    and $0f
    ld d, a                         ; d = number of sprites to draw in X direction
    ld a, e
    swap a
    and $0f
    ld e, a                         ; e = number of sprites to draw in Y direction
    xor a

.Loop:
    add e
    dec d
    jr nz, .Loop

    ld [ObjNumSpritesToDraw], a
    ld hl, ObjectSpritePtrIndices
    add hl, bc
    ld a, [hl]                      ; a = offset for ObjectSpritePointers
    sub 7
    add a                           ; a = (a - 7) * 2 (little correction, for whatever reason 7 needs to subtracted)
    ld e, a
    ld hl, ObjectSpritePointers
    add hl, de
    ld a, [hl+]
    ld [ObjSpritePointerLsb], a
    ld a, [hl]
    ld d, a
    and %00111111
    add $40
    ld [ObjSpritePointerMsb], a     ; Replace upper two bits which are used for the ROM bank.
    ld a, d
    rlca
    rlca
    and %11                         ; Two upper bits determine ROM bank of the sprite.
    ld [ObjSpriteRomBank], a
    ld hl, ObjAnimationIndicesPtr
    add hl, bc
    add hl, bc                      ; Similar as before "bc" is used as an offset.
    ld e, [hl]
    inc hl
    ld d, [hl]                      ; de = [ObjAnimationIndicesPtr + offset]
    ld hl, ObjAnimationIndices
    add hl, de
    ld a, l
    ld [ObjAnimationIndexPtrLsb], a ; = LSB of ObjAnimationIndices + de
    ld a, h
    ld [ObjAnimationIndexPtrMsb], a ; = MSB of ObjAnimationIndices + de
    ret

; $226b: Draw health if RedrawHealth is true.
DrawHealthIfNeeded:
    ld a, [RedrawHealth]
    or a
    ret z                           ; Return if health didn't change.
    xor a
    ld [RedrawHealth], a            ; = 0
    SwitchToBank 2
    call DrawHealth                 ; Redraw health.
    SwitchToBank 1                 ; Load ROM bank 1
    ret

; $227e: ROM bank 3 is loaded before calling this function.
; Loads some data in the tile map for NextLevel 4,5, and 10.
; I guess this setups some dynamic background effects like water and fire.
Lvl4Lvl5Lvl10Setup:
    ld a, [NextLevel]
    cp 10
    jr nz, :+                       ; Jump if next level is not 10 (THE WASTELANDS).
    ld hl, CompressedFireData       ; Tile data of fire.
    ld de, $9e00                    ; The upper tile map is only used a buffer!
    jp DecompressData
 :  cp 4
    ret c                           ; Return if NextLevel < 4
    cp 6
    ret nc                          ; Return if NextLevel > 5
    ld hl, WaterData2               ; Only reaching this point for NextLevel 4 and 5.
    ld de, $9e00                    ; The upper tile map is only used a buffer!
    ld b, 32
 :  push bc                         ; Loop 32 times to copy 512 bytes of data to $9e00.
    ld a, [hl+]
    push hl
    swap a
    ld b, $00
    ld c, a                         ; bc = [WaterData2] * 16
    ld hl, WaterData
    add hl, bc
    ld c, 16
    rst CopyData                    ; Copy 16 bytes to $9e00 + de.
    pop hl
    pop bc
    dec b
    jr nz, :-
    ret

; $22b1: Used in conjunction with WaterData to create the water animation tiles.
; Weird obversation: The bytes get swapped (see Lvl4Lvl5Lvl10Setup). Why not directly store them swapped?
WaterData2::
    db $00, $02, $04, $02, $01, $01, $03, $03, $02, $00, $02, $04, $03, $01, $01, $03
    db $04, $02, $00, $02, $03, $03, $01, $01, $02, $04, $02, $00, $01, $03, $03, $01

; $22d1: Loads the right tiles for the fire and water animation. Only relevant for Level 4, Level 5, and Level 10.
; Is called once per frame and updates the animation tile every 8 calls.
WaterFireAnimation:
    ld a, [NextLevel]
    ld c, a
    cp 10
    jr z, .LevelWithAnimation       ; Jump if Level 10: THE WASTELANDS.
    cp 4
    ret c                           ; Return if below Level 4
    cp 6
    ret nc                          ; Return if above Level 5

.LevelWithAnimation:                ; Only reached for Level 4, Level 5, and Level 10.
    ld a, [WaterFireCounter]
    inc a
    and %111                        ; Mod 8.
    ld [WaterFireCounter], a        ; [WaterFireCounter] = ([WaterFireCounter] + 1) % 8
    ret nz                          ; Continue every 8 calls.
    TilemapHigh hl, 0, 16           ; hl = $9e00. Apparently the upper tile map is used a buffer for tile data.
    ld a, c
    cp 10
    ld a, [WaterFireIndex]
    jr z, .LevelWithFire            ; Jump if Level 10: THE WASTELANDS.

.LevelWithWater:
    inc a
    and %111
    ld [WaterFireIndex], a          ; [WaterFireIndex] = ([WaterFireIndex] + 1) % 8
    ld b, $00
    swap a
    sla a
    rl b
    sla a
    rl b
    ld c, a                         ; bc = [WaterFireIndex] * 64
    add hl, bc
    TileDataHigh de, 252            ; de = $97c0
    jr Copy64BytesToVram

.LevelWithFire:
    inc a
    and %11
    ld [WaterFireIndex], a
    ld b, a
    ld c, $00
    rr b
    rr c
    add hl, bc                      ; bc = [WaterFireIndex] * 128
    TileDataHigh de, 248            ; de = $9780
    call Copy64BytesToVram

; $2321: Copies 64 bytes starting from "hl" to "de". Sets a = 0.
Copy64BytesToVram:
    call CopyToVram                  ; Copy 32 Bytes to "de".
    call CopyToVram                  ; Copy another 32 Bytes to "de".
    xor a
    ret

; $2329: Sets up positions according to level and checkpoint.
; The positions are stored ROM bank 5 $4000.
; 16 bytes in total per level. Eight for the start, eight for the checkpoint.
InitStartPositions:
    ld a, [CheckpointReached]
    ld c, a                            ; = 8 if checkpoint was reached else = 0.
    or a
    call nz, PositionFromCheckpoint    ; Load from checkpoint if checkpoint was reached.
    ld a, [NextLevel]
    ld d, a
    dec a
    swap a
    add c                              ; = Upper 4 bits from the level, bit 3 is set if checkpoint was reached.
    ld b, 0
    ld c, a
    ld hl, StartingPositions
    add hl, bc                         ; hl = StartingPositions + level * 16 + 8 * CheckpointReached?
    ld a, [hl+]
    ld [BgScrollXLsb], a               ; Start position background scroll x LSB.
    ldh [rSCX], a
    ld a, [hl+]
    ld [BgScrollXMsb], a               ; Start position background scroll x MSB.
    ld a, [hl+]
    ld [BgScrollYLsb], a               ; Start position background scroll y LSB.
    ldh [rSCY], a
    ld a, [hl+]
    ld [BgScrollYMsb], a               ; Start position background scroll y MSB.
    ld a, d                            ; a = [NextLevel]
    cp 12                              ; Next level 12?
    jr z, :+
    ld a, [hl+]
    ld [PlayerPositionXLsb], a         ; Start position player X LSB.
    ld a, [hl+]
    ld [PlayerPositionXMsb], a         ; Start position player X MSB.
    ld a, [hl+]
    ld [PlayerPositionYLsb], a         ; Start position player Y LSB.
    ld a, [hl+]
    ld [PlayerPositionYMsb], a         ; Start position player Y MSB.
    ret
:   ld a, [BgScrollYLsb]
    ld [ScreenLockY], a
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

; $2382: Get Bit 2 of liana status for a given liana. Zero flag is set, if liana is not swinging without player.
; Input: a = liana index
IsLianaSwingingWOPlayer:
    push bc
    push hl
    add a
    add a
    add a                           ; a = 8 * a
    ld b, $00
    ld c, a
    ld hl, LianaStatus
    add hl, bc                      ; hl = LianaStatus + 8 * a
    ld a, [hl]
    and %100
    pop hl
    pop bc
    ret

; $2394: ROM bank 1 should be loaded at this point.
; Decompresses object data and initializes static objects.
InitObjects:
    ld a, [NextLevel]
    dec a
    ld b, 0
    ld c, a                           ; bc = level
    ld hl, NumObjectsBasePtr
    add hl, bc
    ld a, [hl]                        ; Load something from [01:6782 + level].
    ld [NumObjects], a                ; This is the only place where NumObjects is set.
    sla c
    ld hl, CompressedDataLvlPointers  ; Address to static object data.
    add hl, bc
    ld a, [hl+]
    ld h, [hl]                        ; Load pointer into hl.
    ld l, a
    ld de, StaticObjectData
    ld a, e
    ld [StaticObjectDataPtrLsb], a    ; = $00
    ld a, d
    ld [StaticObjectDataPtrMsb], a    ; = $d7
    call DecompressData               ; Decompress static object data into $d700.
    call EmptyInitProjectileObjects
    ld a, EMPTY_OBJECT_VALUE
    ld [EnenemyProjectileObject0], a  ; = empty ($80)
    ld [EnenemyProjectileObject1], a  ; = empty ($80)
    ld a, BOSS_FULL_HEALTH
    ld [BossHealth], a                ; = 30 ($1e)
    ld a, [IsPlayerDead]              ; Goes $ff when dead.
    or a
    jr z, InitGeneralObjectsAndStatus
    ld a, [NumObjects]
    ld hl, StaticObjectData
    ld de, ObjectsStatus

; $23d9: When starting the level for the first time, all slots in ObjectsStatus ($c600) are 0.
; When loading the level after dying, some objects transfer their status into the next round.
; E.g.: diamonds, extra lifes, and the shovel can only be collected once.
InitStaticObject:
    push af
    ld a, [de]                      ; Starting at de = $c600
    cp ID_DIAMOND
    jr z, :+
    cp ID_EXTRA_LIFE
    jr z, :+
    cp ID_SHOVEL
    jr z, :+
    and $08
    jr z, .ZeroInit
 :  ld c, ATR_ID
    rst CpAttr
    jr z, .SkipInit                 ; Skip for diamonds, extra, and shovel that have NOT been dropped by enemies.
    GetAttribute ATR_LOOT           ; Objects dropped by enemies continue here.
    and $0f
    or LOOT_HEALTH_PACKAGE
    rst SetAttr                     ; The loot is now set to health package.
    ld a, 8
    jr .Init
.ZeroInit:                          ; $23fc
    xor a
.Init:                              ; $23fd
    ld [de], a                      ; "a" is either 0 or 8. The latter is used for enenmies that drop sinlge-drop items.
.SkipInit:                      ; $23fe
    inc e
    ld bc, 24
    add hl, bc                      ; Point to the next object.
    pop af                          ; Hence every static object is 24 bytes in size?
    dec a
    jr nz, InitStaticObject         ; Loop [NumObjects] times.
    jr InitGeneralObjects

; $2409
InitGeneralObjectsAndStatus:
    ld a, [NumObjects]
    ld b, a
    inc b
    ld hl, ObjectsStatus
    call MemsetZero2                ; set [$c600] to [$c600 + [NumObjects] + 1] to zero.

; $2414
InitGeneralObjects:
    ld hl, GeneralObjects
    ld b, NUM_GENERAL_OBJECTS
.Loop:
    ld [hl], EMPTY_OBJECT_VALUE
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    dec b
    jr nz, .Loop
    ld hl, ActiveObjectsIds - 1
    ld b, 5
    jp MemsetZero2                  ; This function also returns.

; $242a
; Input: a = level
InitSprites:
    cp 4
    jr nz, .NotLevel4               ; Jump if not Level 4.

.Level4:
    ld a, $6c
    ld [NumObjSpriteIndex], a       ; = $6c
    ld a, $c0
    ld [ObjSpriteVramPtrLsb], a
    ld a, $8a
    ld [ObjSpriteVramPtrMsb], a     ; Copy sprite to $8ac0.
    ld a, $80
    ld [JumpTimer], a               ; $80
    call CopyObjectSpritesToVram
    jr .SinkingStone

.NotLevel4:
    ld c, $01
    cp 2
    jr z, .CopySprite2              ; Jump if Level 2.
    cp 5
    jr z, .SinkingStone             ; Jump if Level 5.
    cp 6
    jr z, .CopySprite2              ; Jump if Level 6.
    dec c
    cp 8
    jr z, .CopySprite2              ; Jump if Level 8.
    ld c, $5f
    cp 9
    jr z, .CopySprite2              ; Jump if Level 9.
    cp 10
    jr nz, InitItemSprites1         ; Jump if not Level 10.
.Level10:
    ld hl, FlameSprite
    TileDataHigh de, 44
    ld bc, SPRITE_SIZE * 2
    SwitchToBank 6
    rst CopyData

; $2471
.CopySprite2:
    ld a, $82
    add c
    jr .CopySprite

; $2476
.SinkingStone:
    ld a, $70

; $2478
.CopySprite:
    ld [NumObjSpriteIndex], a       ; = $70 or $82 + c
    ld a, $a0
    ld [ObjSpriteVramPtrLsb], a
    ld a, $8c
    ld [ObjSpriteVramPtrMsb], a     ; Copy sprites to $8ca0
    ld a, $80
    ld [JumpTimer], a               ; = $80
    call CopyObjectSpritesToVram

; $248d
InitItemSprites1:
    SwitchToBank 5
    ld a, [NextLevel2]
    inc a
    cp 4
    jr c, InitItemSprites2              ; Jump if level < 4.
    and %1
    jr nz, InitItemSprites2             ; Jump if level is odd.
    ld hl, StoneSprites
    TileDataHigh de, 66
    ld bc, SPRITE_SIZE * 4
    rst CopyData

; $24a6
InitItemSprites2:
    ld a, [NextLevel]
    cp 4
    ret z                               ; Return if Level 4 (BY THE RIVER). There is no mask in this level.
    cp 11
    jr z, InitBonusLevel                ; Jump if bonus level.
    ld hl, InvincibleMaskSprites
    TileDataHigh de, 46                 ; de = $8ae0
    ld bc, SPRITE_SIZE * 4              ; Load the invincible mask sprite into VRAM.
    rst CopyData
    ret

; $24bb: Inits pear sprites and some other sprites. Also determines random items. ROM 5 is loaded before jumping.
InitBonusLevel:
    ld hl, PearSprites
    TileDataHigh de, 50             ; = $8b20
    ld c, SPRITE_SIZE * 4
    rst CopyData                    ; Load the pear sprite into VRAM.
    ld e, $a0
    ld c, SPRITE_SIZE * 8
    rst CopyData                    ; Load the cherry and pear sprite into VRAM.
    inc a
    rst LoadRomBank                 ; Load ROM bank 1.
    ld b, NUM_ITEMS_BONUS_LEVEL
    ld a, b
    ld [MissingItemsBonusLevel], a
    ld h, HIGH(LootIdToObjectId + 1)                       ;
    ld de, StaticObjectData + SIZE_GENERAL_OBJECT - 8 + ATR_ID
.Loop:
    ldh a, [rDIV]
    add b
    and %111                        ; Get a random number between 0 and 7.
    add LOW(LootIdToObjectId + 1)   ; Use the LootIdToObjectId map for random objects.
    ld l, a                         ; hl = $63e2 + random number
    ld a, [hl]
    ld [de], a
    ld a, e
    add SIZE_GENERAL_OBJECT - 8
    ld e, a
    dec b
    jr nz, .Loop
    ret

; $24e8: Spawns the eagle that picks up the player when finishing level. The eagle also drops the player in the transition level.
SpawnEagle:
    ld hl, GeneralObjects
    ld b, NUM_GENERAL_OBJECTS

.Loop:
    ObjMarkedSafeDelete
    jr nz, .DeconstructObject

    IsObjOnScreen
    jr z, .DeconstructObject

    bit 5, [hl]
    jr z, .DeconstructObject

    bit 2, [hl]
    jr z, .Continue

.DeconstructObject:
    push bc
    call ObjectDestructor
    pop bc

.Continue:
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    dec b
    jr nz, .Loop

    call GetEmptyObjectSlot
    ret z                           ; Return if there is no empty slot.

    ld d, h
    ld e, l                         ; de = EmptyObject
    ld b, MAX_ACTIVE_OBJECTS
    ld c, $00
    ld hl, ActiveObjectsIds

.EmptyObjectLoop:
    ld a, [hl]
    or a
    jr z, .InsertEagleObject           ; Empty array entry found.
    inc l
    inc c
    dec b
    jr nz, .EmptyObjectLoop
    ld c, $00

; $2521
.InsertEagleObject:
    push de
    push bc
    ld hl, EagleObjectData
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData
    pop bc
    pop hl
    ld a, [$c1a7]
    srl a
    cp c
    jr nz, jr_000_253c

    xor a
    ld [JumpTimer], a               ; = 0
    dec a
    ld [$c1a7], a                   ; = $ff

jr_000_253c:
    ld a, c
    add a
    ld c, ATR_OBJECT_DATA
    rst SetAttr
    ld a, [PlayerPositionYLsb]
    sub 128
    ld e, a
    ld a, [PlayerPositionYMsb]
    sbc 0
    ld d, a                         ; de = [PlayerPositionY] - 128
    SetAttribute2 ATR_Y_POSITION_LSB, e
    inc c
    ld a, d
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = d
    ld a, [PlayerPositionXLsb]
    sub 2
    push af
    inc c
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] = [PlayerPositionXLsb] - 2
    pop af
    ld a, [PlayerPositionXMsb]
    sbc 0
    inc c
    rst SetAttr                     ; obj[ATR_X_POSITION_MSB] = [PlayerPositionXMsb] - carry
    ld a, $40 | SONG_0a
    ld [CurrentSong], a

; $2569: Starting from $c300, this function puts $80 into multiples of 32 for 4 times.
; Hence, {$c300, $c320, $c340, $c360} = $80 (EMPTY_OBJECT_VALUE)
; This corresponds to an empty-initialization of the 4 projectile objects.
EmptyInitProjectileObjects:
    ld hl, ProjectileObjects
    ld b, NUM_PROJECTILE_OBJECTS
 :  ld [hl], EMPTY_OBJECT_VALUE     ; Load $80 into $c300. Thus, the object is interpreted as empty/non-existent.
    ld a, l
    add SIZE_PROJECTILE_OBJECT
    ld l, a
    dec b
    jr nz, :-                       ; Loops for 4 times.
    ret

; $2578: ROM bank 1 is loaded before calling. Sets up stuff for the transition level.
InitBonusLevelInTransition:
    call InitGeneralObjectsAndStatus
    ld hl, EagleObjectData
    ld de, GeneralObjects
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData
    ld a, [NextLevel2]
    cp 10
    jr nz, :+                       ; Jump if not Level 10.
    ld de, GeneralObjects + SIZE_GENERAL_OBJECT
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData                    ; We copy another object if game was played through! "hl" points to VillageGirlObjectData.
 :  ld a, 40
    ld [PlayerPositionXLsb], a      ; = 40
    xor a
    ld [PlayerPositionXMsb], a      ; = 0
    ld [PlayerPositionYLsb], a      ; = 0
    ld [PlayerPositionYMsb], a      ; = 0
    ld [DynamicGroundDataType], a     ; = 0
    ret

Call_000_25a6:
    ld a, [PlayerFreeze]
    or a
    ret nz                          ; Return if in animation.
    ld a, [BossActive]
    or a
    ret nz                          ; Return if boss is active.
    ld a, [NumObjects]
    or a
    ret z                           ; Return if number of objects is zero. Only zero in transition level.
    ld c, a
    ld a, [BgScrollYLsb]
    add 80
    ld [WindowScrollYLsb], a        ; [BgScrollYLsb] + 80
    ld a, [BgScrollYMsb]
    adc 0
    ld [WindowScrollYMsb], a
    ld a, [BgScrollXLsb]
    add 80
    ld [WindowScrollXLsb], a
    ld a, [BgScrollXMsb]
    adc 0
    ld [WindowScrollXMsb], a
    ld a, [NextLevel]
    cp 5
    jr z, .Level5                   ; Next level 5?
    cp 3
    jr nz, .NotLevel3or5            ; Jump if next level is not 3.
    ld b, $15
    jr .Level3
.Level5:
    ld b, $07
.Level3:
    ld a, [$c129]
    add 80
    ld [SpritesYOffset], a                   ; [SpritesYOffset] = [$c129] + 80
    ld a, [$c12a]
    adc 0
    cp b
    jr c, .Carry
    sub b
.Carry:
    ld [$c10b], a
.NotLevel3or5:
    ld hl, StaticObjectDataPtrLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$c1a8]
    ld b, 4

; $2606
Loop2606:
    push bc
    push af
    ld c, a
    ld b, HIGH(ObjectsStatus)
    ld a, [bc]
    bit 7, a
    jr nz, jr_000_2615

    push hl
    call Call_000_2632
    pop hl

jr_000_2615:
    ld bc, SIZE_GENERAL_OBJECT - 8
    add hl, bc
    pop af
    inc a
    pop bc
    cp c
    jr c, jr_000_2623

    ld hl, StaticObjectData
    xor a

jr_000_2623:
    dec b
    jr nz, Loop2606

    ld [$c1a8], a
    ld a, l
    ld [StaticObjectDataPtrLsb], a
    ld a, h
    ld [StaticObjectDataPtrMsb], a
    ret

; $2632: Input: hl = pointer to static object data
Call_000_2632:
.CheckYPos:
    ld a, [WindowScrollYLsb]
    ld e, a
    ld a, [WindowScrollYMsb]
    ld d, a                         ; de = WindowScrollY
    ld a, [hl]
    ld [StaticObjectDataAttr0], a
    inc hl
    ld a, [hl+]                     ; Get statis object ATR_Y_POSITION_LSB
    sub e                           ; a = obj[ATR_Y_POSITION_LSB] - WindowScrollYLsb
    ld e, a
    ld a, [hl+]                     ; Get static object ATR_Y_POSITION_MSB
    sbc d                           ; a = obj[ATR_Y_POSITION_MSB] - WindowScrollYMsb - carry
    ld d, a
    inc a
    cp 2                            ; Object needs to be at most 1 away from WindowScrollYMsb.
    jp nc, DeleteActiveObject       ; Else it gets deleted.
    ld a, e
    xor d
    and %10000000
    jp nz, DeleteActiveObject

    ld a, [StaticObjectDataAttr0]
    and $27
    cp $26
    jr nz, .CheckXPos

    ld a, [SpritesYOffset]
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
    jp nc, DeleteActiveObject

    ld a, e
    xor d
    and $80
    jp nz, DeleteActiveObject

    jr jr_000_2695

.CheckXPos:
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
    cp 2                            ; Similar to as above but now with X coords.
    jp nc, DeleteActiveObject       ; Jump if object is too far away.

    ld a, e
    xor d
    and $c0
    cp $c0
    jp z, DeleteActiveObject

jr_000_2695:
    ld a, [bc]
    bit 4, a
    ret nz

    xor a                           ; a = 0
    ld de, GeneralObjects

.Loop:                              ; Loops over all general objects.
    push af
    ld a, [de]
    and %10000000
    jr nz, jr_000_26ae              ; Jump if free entry in array.
    ld a, e
    add SIZE_GENERAL_OBJECT
    ld e, a
    pop af
    inc a
    cp NUM_GENERAL_OBJECTS
    jr c, .Loop
    ret                             ; Return if no free entry was found.


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
    cp 6
    jr nz, jr_000_26da

    ld c, $08
    ld hl, ActiveObjectsId3
    jr CopyPrecToActiveObj

jr_000_26ce:
    ld hl, ActiveObjectsIds
    ld b, MAX_ACTIVE_OBJECTS

.Loop:
    cp [hl]
    jr z, ReturnPop4                ; Jump if empty entry in array ActiveObjectsIds was found.

    inc l
    dec b
    jr nz, .Loop

jr_000_26da:
    ld hl, ActiveObjectsIds
    ld b, MAX_ACTIVE_OBJECTS
    ld c, $00
.Loop:
    ld a, [hl]
    or a
    jr z, CopyPrecToActiveObj       ; Jump if empty entry in array ActiveObjectsIds was found.
    inc c
    inc c
    inc l
    dec b
    jr nz, .Loop

; $26eb
ReturnPop4:
    pop af
    pop hl
    pop bc
    pop af
    ret

; $26f0: Copies data from preconstructed objects to active objects.
; Input: hl = pointer to empty sloot in ActiveObjectsIds
;        a = 0
;        c = index in ActiveObjectsIds x 2
CopyPrecToActiveObj:
    pop af
    ld [hl], a
    pop hl
    ld a, c
    push af
    ld a, l
    sub $05
    ld l, a
    ld bc, SIZE_GENERAL_OBJECT - 8
    push de
    rst CopyData                    ; Copy 34 bytes of data from [hl] to [de]
    pop hl
    pop af
    ld c, ATR_OBJECT_DATA
    rst SetAttr                     ; obj[ATR_OBJECT_DATA] = index in ActiveObjectsIds
    pop bc
    pop af
    set 4, a
    ld d, a
    ld a, [bc]                      ; "bc" points to ObjectsStatus.
    or d
    ld [bc], a
    ld a, c
    ld c, ATR_STATUS_INDEX
    rst SetAttr
    ret

; $2710
jr_000_2710:
    ld a, [hl]
    cp $ac
    jr nz, jr_000_2734
    push bc
    push hl
    ld hl, GeneralObjects
    ld b, NUM_GENERAL_OBJECTS

; $271c
.ObjectLoop:
    IsObjEmpty
    jr nz, .SkipObject
    push hl
    ld a, l
    add ATR_ID
    ld l, a
    ld a, [hl]                    ; Load object type.
    cp ID_TURTLE
    jr z, ReturnPop4              ; Jump if object is a turtle.
    pop hl
; $272b
.SkipObject:
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    dec b
    jr nz, .ObjectLoop
    pop hl
    pop bc

jr_000_2734:
    ld a, l
    sub $05
    ld l, a
    push bc
    ld bc, SIZE_GENERAL_OBJECT - 8
    push de
    rst CopyData
    pop hl
    pop bc
    pop af
    set 4, a
    ld d, a
    ld a, [bc]
    or d
    ld [bc], a
    ld a, c
    ld c, ATR_STATUS_INDEX
    rst SetAttr
    ret

; $274c: Is iteratively called for all objects in the game.
; Input: bc = pointer to object in ObjectsStatus array
DeleteActiveObject:
    ld a, [bc]
    IsObjectActive
    ret z                           ; Return if object is not active.
    and %111                        ; Get lower three bit of entry in ObjectsStatus
    swap a                          ;
    add a                           ; a = a * 32 = a * SIZE_GENERAL_OBJECT
    ld d, HIGH(GeneralObjects)
    ld e, a                         ; de = get matching object in GeneralObjects.
    ld a, [de]                      ; a = obj[ATR_STATUS]
    and %10000
    ret nz
    ld a, [bc]
    and %1000
    ld [bc], a                      ; Just keep mark as found. The rest is reset.
    ld a, %10000000
    ld [de], a                      ; Mark object in GeneralObjects as deleted..
    ld a, e
    add $06
    ld e, a
    ld a, [de]                      ; a = obj[ATR_06]
    cp $90
    ret nc
    ld a, e
    add $0b
    ld e, a
    ld a, [de]                      ; a = obj[ATR_OBJECT_DATA]
    bit 3, a
    jr z, :+
    ld a, 6
 :  srl a
    ld b, 0
    ld c, a
    ld hl, ActiveObjectsIds
    add hl, bc
    ld [hl], b                      ; ActiveObjectsIds[obj[ATR_OBJECT_DATA]] = 0
    ret

; $2781: Updates general objects, player projectiles, enemy projectiles...
UpdateAllObjects:
    ld bc, (NUM_GENERAL_OBJECTS << 8) | SIZE_GENERAL_OBJECT
    ld hl, GeneralObjects

 :  push bc
    call UpdateGeneralObject
    pop bc
    ld a, l
    add c
    ld l, a
    dec b
    jr nz, :-                       ; Loop 8 times.

    ld hl, ProjectileObjects
    ld b, NUM_PROJECTILE_OBJECTS
    call UpdateAllProjectiles
    ld hl, EnenemyProjectileObjects
    ld b, NUM_ENEMY_PROJECTILE_OBJECTS

; $279f. Input: hl = object pointer, b = number of objects
UpdateAllProjectiles::
    push bc
    call UpdateProjectile
    pop bc
    ld a, l
    add c
    ld l, a
    dec b
    jr nz, UpdateAllProjectiles
    ret

; $27ab: Updates a single general object. Handles: boar, armadillo, porcupine, etc.
; Input: "hl" pointer to general object.
UpdateGeneralObject:
    IsObjEmpty
    ret nz
    call CheckEnemyAction
    call HandleObjects
    ld a, [PlayerFreeze]
    or a
    call nz, HandleObjectsInCutscene
    GetAttribute ATR_09
    or a
    ret z                           ; Return if obj[ATR_09] is zero.
    ld d, a
    inc c                           ; c = $0a (ATR_FREEZE)
    rst DecrAttr                    ; obj[ATR_FREEZE]--
    jr z, jr_000_27db
    GetAttribute ATR_ID
    cp ID_FISH
    jp z, Jump_000_29c3
    cp ID_FLYING_BIRD_TURN
    jp z, Jump_000_288d
    cp ID_FLYING_BIRD
    ret nz
.FlyingBird:
    bit 1, [hl]
    ret z
    jp Jump_000_288d


jr_000_27db:
    ld a, d
    rst SetAttr
    ld a, [PlayerFreeze]
    or a
    jr nz, jr_000_27e9

    call HandleObjectsInCutscene
    call FishFrogAction1

jr_000_27e9:
    GetAttribute ATR_FACING_DIRECTION
    and $0f
    jp z, Jump_000_29c3             ; Jump if object has no facing direction.
    bit 3, a
    jr z, .IsPositive
    or $f0                          ; Sign-extend facing direction.
.IsPositive:
    ld c, a                         ; c = facing direction of object
    push bc
    GetAttribute ATR_X_POSITION_LSB
    ld e, a
    inc c
    rst GetAttr
    ld d, a                         ; de = object's X position
    pop bc
    bit 7, c
    jr nz, .FacesLeft

.FacesRight:
    ld a, e
    add c
    ld e, a
    jr nc, .NoCarry
    inc d
.NoCarry:                           ; de = object's X position + 1
    ObjMarkedSafeDelete
    jr nz, SetXPos
    ld c, X_POS_LIM_RIGHT
    rst CpAttr
    call z, HandleDirectionChange   ; Change direction if right X limit is reached.
    bit 5, [hl]
    call nz, FloatObjPlayerRightMove
    jr .CheckId

.FacesLeft:
    ld a, e
    add c
    ld e, a
    jr c, .NoBorrow
    dec d
.NoBorrow:                          ; de = object's X position - 1
    ObjMarkedSafeDelete
    jr nz, SetXPos

    ld c, X_POS_LIM_LEFT
    rst CpAttr
    call z, HandleDirectionChange   ; Change direction if left X limit is reached.
    bit 5, [hl]
    call nz, FloatObjPlayerLeftMove

; $2831
.CheckId:
    GetAttribute ATR_ID
    cp ID_ARMADILLO_WALKING
    jr c, SetXPos
    cp ID_LIGHTNING
    jr nc, SetXPos

; Only reached for armadillos and porcupines. The rest jumps to SetXPos.
.ArmadilloOrPorcupine1:
    ld a, e
    ld c, ATR_WALK_ROLL_COUNTER
    rst CpAttr
    jr z, .RollingWalkingChange
    inc c
    rst CpAttr
    jr nz, SetXPos
    call NegateYPosDelta

; $2849: Switches from rolling to walking and vice versa.
.RollingWalkingChange:
    GetAttribute ATR_ID
    xor IS_ROLLING_MASK
    rst SetAttr
    and IS_ROLLING_MASK
    jr z, SetXPos                   ; Jump if new type is no rolling.
    SetAttribute ATR_FREEZE, $20

SetXPos:
    ld c, ATR_X_POSITION_LSB
    ld a, e
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] = e
    inc c
    ld a, d
    rst SetAttr                     ; obj[ATR_X_POSITION_MSB] = d
    ObjMarkedSafeDelete
    jp nz, Jump_000_29c3
    GetAttribute ATR_ID
    cp ID_FLYING_BIRD_TURN
    jr z, Jump_000_288d
    cp ID_ARMADILLO_WALKING
    jp c, Jump_000_29c3
    cp ID_LIGHTNING
    jp nc, Jump_000_29c3

; Only reached for aramdillos and porcupines.
.ArmadilloOrPorcupine2:
    and IS_ROLLING_MASK
    ret z                           ; Return if enemy is not rolling.
    ld c, 3
    ld a, [NextLevel]
    cp 2
    jr z, jr_000_2887
    cp 6
    jr z, jr_000_2887
    ld c, 1
jr_000_2887:
    ld a, e
    and c
    ret nz
    jp Jump_000_29c3


Jump_000_288d:
    push af
; $288e
HandleDirectionChange:
    GetAttribute ATR_ID
    cp ID_EAGLE
    jp z, EagleItemDrop

    cp ID_CROCODILE
    jp z, ClearFacingDirectionCroc

    cp ID_HIPPO
    ret z

    cp $cd                          ; TODO: Which object is that?
    ret z

    cp ID_TURTLE
    jr z, .CheckDirectionChange

    cp ID_ARMADILLO_WALKING
    jr z, .CheckDirectionChange

    cp ID_FLYING_BIRD
    jr nz, .Continue

.FlyingBird
    pop af
    IsObjOnScreen
    jr z, FlyingBirdDirectionChange

    bit 1, [hl]
    jr nz, jr_000_2922

    set 1, [hl]
    ld a, ID_FLYING_BIRD_TURN
    rst SetAttr                     ; obj[ATR_ID] = ID_FLYING_BIRD_TURN
    SetAttribute ATR_PERIOD_TIMER0_RESET, 16
    SetNextAttribute 1              ; ATR_PERIOD_TIMER0
    SetAttribute ATR_PERIOD_TIMER1, 7
    SetAttribute2 ATR_X_POSITION_LSB, e
    SetNextAttribute2 d             ; ATR_X_POSITION_MSB
    SetAttribute ATR_09, $02
    ret

; $28d6
.CheckDirectionChange:
    ld a, [BossActive]
    or a
    jr z, ChangeEnemyDirection
    jp ObjectDestructor             ; Delete object if boss is active (King Louie or Baloo).

; $8df
.Continue:
    cp ID_FLYING_BIRD_TURN
    jr nz, ChangeEnemyDirection

.FlyingBirdTurn
    pop af
    IsObjOnScreen
    jr z, jr_000_2919

    GetAttribute ATR_PERIOD_TIMER1
    ld d, a
    ld e, $02
    and $03
    jr z, jr_000_2909

    ld e, $03
    and $01
    jr nz, jr_000_2909

    ld e, $04
    dec c
    rst GetAttr
    cp $08
    jr nz, jr_000_2909

    GetAttribute ATR_SPRITE_PROPERTIES
    xor SPRITE_X_FLIP_MASK
    rst SetAttr
    call ChangeEnemyDirection

jr_000_2909:
    ld a, e
    ld c, ATR_09
    rst SetAttr
    ld a, d
    cp $04
    ret nz

    GetAttribute ATR_PERIOD_TIMER0
    cp $01
    ret nz

    inc c
    rst SetAttr

jr_000_2919:
    SetAttribute ATR_ID, ID_FLYING_BIRD
    IsObjOnScreen
    jr z, FlyingBirdDirectionChange

jr_000_2922:
    GetAttribute ATR_12
    cp $4f
    ret nc

; $2928
FlyingBirdDirectionChange:
    res 1, [hl]
    SetAttribute ATR_PERIOD_TIMER0_RESET, 6
    GetAttribute ATR_FACING_DIRECTION
    ld d, a
    and %1000
    rla
    rla
    ld e, a
    ld a, d
    and ~SPRITE_X_FLIP_MASK
    or e
    rst SetAttr
    SetAttribute ATR_09, $01
    IsObjOnScreen
    ret nz                          ; Return if object is on screen.

; $2945: Changes the direction of an enemy. Used for boars, porcupines, and armadillos.
ChangeEnemyDirection:
    GetAttribute ATR_FACING_DIRECTION
    ld b, a
    and $0f
    bit 3, a
    jr z, .IsPositive               ; Jump if object not facing left.
    or $f0                          ; Sign-extend facing direction.
.IsPositive:
    cpl
    inc a
    and $0f
    ld c, a
    ld a, b
    and $f0
    xor SPRITE_X_FLIP_MASK
    or c
    ld c, ATR_FACING_DIRECTION
    rst SetAttr
    GetAttribute ATR_ID
    cp ID_ARMADILLO_WALKING
    ret c
    cp ID_LIGHTNING
    ret nc
; Only continue for porcupines and aramdillos..

; $2968: Negates obj[ATR_Y_POS_DELTA]. Only called for porcupines and armadillos.
NegateYPosDelta:
    GetAttribute ATR_Y_POS_DELTA
    cpl
    inc a
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = -obj[ATR_Y_POS_DELTA]
    ret

; $96f
ClearFacingDirectionCroc:
    GetAttribute ATR_FACING_DIRECTION
    and $f0
    rst SetAttr                     ; Clears facing direction.
    ld a, [BossActive]
    or a
    ret z                           ; Return if no boss is active.
    jp ObjectDestructor

; $297d: Moves the player to the right if he's standing on a crocodile or turtle.
FloatObjPlayerRightMove:
    ld a, [DynamicGroundDataType]
    cp $29
    jr z, .MovePlayer               ; Jump if turtle.
    cp $2a
    jr z, .MovePlayer               ; Jump if crocodile.
    cp $2b
    ret nz

; $298b:
.MovePlayer:
    push de
    push hl
    ld a, [MovementState]
    push af
    ld a, $ff
    ld [MovementState], a           ; = $ff
    call MovePlayerRight
    pop af
    ld [MovementState], a           ; = [MovementState]
    pop hl
    pop de
    ret

; $29a0: Moves the player to the left if he's standing on a crocodile or turtle.
FloatObjPlayerLeftMove:
    ld a, [DynamicGroundDataType]
    cp $29
    jr z, .MovePlayer               ; Jump if turtle.
    cp $2a
    jr z, .MovePlayer               ; Jump if crocodile.
    cp $2b
    ret nz

; $29ae
.MovePlayer:
    push de
    push hl
    ld a, [MovementState]
    push af
    ld a, $ff
    ld [MovementState], a           ; = $ff
    call MovePlayerLeft
    pop af
    ld [MovementState], a           ; = [MovementState]
    pop hl
    pop de
    ret

; Related to objects falling out of the window when being deleted.
Jump_000_29c3:
    GetAttribute ATR_Y_POS_DELTA
    or a
    ret z

    ld c, a                         ; c = obj[ATR_Y_POS_DELTA]
    push bc
    GetAttribute ATR_Y_POSITION_LSB
    ld e, a                         ; e = obj[ATR_Y_POSITION_LSB]
    inc c
    rst GetAttr
    ld d, a                         ; d = obj[ATR_Y_POSITION_MSB]
    pop bc                          ; c = obj[ATR_Y_POS_DELTA]
    bit 7, c
    jr nz, .IsNegative

    ld a, e
    add c
    ld e, a
    jr nc, SkipCarry
    inc d
    jr SkipCarry

.IsNegative:
    ld a, e
    add c                           ; a = obj[ATR_Y_POSITION_LSB] + obj[ATR_Y_POS_DELTA]
    ld e, a
    jr c, SkipCarry
    dec d
SkipCarry:                          ; de = object's Y position + obj[ATR_Y_POS_DELTA]
    ld c, ATR_Y_POSITION_LSB
    ld a, e
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = e
    inc c
    ld a, d
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = d
    GetAttribute ATR_ID
    cp ID_HIPPO
    jr z, jr_000_2a42

    bit 5, [hl]
    jr nz, jr_000_29fe

    cp ID_SINKING_STONE
    jr z, jr_000_2a5a

    cp ID_EAGLE
    jr z, HandleEagle

jr_000_29fe:
    ObjMarkedSafeDelete
    jr nz, jr_000_2a15

    cp ID_CROCODILE
    jr z, jr_000_2a09

    cp ID_SINKING_STONE
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
    rst SetAttr
    ret

; e = obj[ATR_Y_POSITION_LSB]
jr_000_2a15:
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, e
    sub c
    cp 144
    ret c
    cp 192
    ret nc
    ld c, ATR_ID
    rst GetAttr                     ; a = obj[ATR_ID]
    cp ID_FISH
    ret z                           ; Return if fish.
    cp ID_FROG
    ret z                           ; Return if frog.
    cp ID_SINKING_STONE
    jr nz, .NotAsinkingStone        ; Jump if object is not a sinking stone.
.SinkingStone:
    ld a, d
    cp $02
    ret nz
    SetAttribute ATR_Y_POS_DELTA, 0
    res 6, [hl]                     ; Set object out of screen.
    ret

.NotAsinkingStone:
    ld c, ATR_HITBOX_PTR
    rst GetAttr
    cp $02
    ret z
    jp ObjectDestructor

jr_000_2a42:
    ld c, $08
    rst GetAttr
    and $80
    ld a, e
    ld c, $13
    jr nz, jr_000_2a4d

    inc c

jr_000_2a4d:
    rst CpAttr
    ret nz

    SetAttribute $08, 0
    ld a, e
    inc a
    ret nz

    ld c, ATR_PERIOD_TIMER0_RESET
    rst SetAttr
    ret


jr_000_2a5a:
    ld a, e
    ld c, $14
    rst CpAttr
    ret c

    rst GetAttr
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr
    SetAttribute $08, 0
    ld c, $0e
    rst SetAttr
    res 6, [hl]
    push hl
    call CatapultJump1
    pop hl
    ret

; $2a72: Called when eagle enters the screen.
; Input: de = eagle Y position
HandleEagle:
    ld a, e
    add 28
    ld e, a
    ld a, d
    adc 0
    ld d, a                         ; de = obj[ATR_Y_POSITION] + 28
    GetAttribute ATR_PERIOD_TIMER1
    ld c, a
    push hl
    ld hl, EaglePositions
    add hl, bc
    ld c, [hl]
    pop hl
    push bc
    GetAttribute ATR_Y_POS_DELTA
    pop bc
    and $80
    jr nz, .EagleRising              ; Jump if Y-delta is negative (eagle is rising).

.EagleDescending:
    ld a, [NextLevel]
    cp 12
    jp z, .InTransitionLevel
    ld a, [BgScrollXLsb]
    ld c, ATR_X_POSITION_LSB
    ld b, a
    push bc
    rst GetAttr                     ; a = obj[ATR_X_POSITION_LSB]
    pop bc
    sub b
    ld b, a                         ; b = eagle screen X position
    ld a, [PlayerWindowOffsetX]
    sub 2                           ; a = [PlayerWindowOffsetX] - 2
    cp b
    jr z, .CheckPositionMatch
    jr nc, .EagleLeftOfPlayer

.EagleRightOfPlayer:
    rst GetAttr
    dec a
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] -= 1
    inc a
    jr nz, .CheckPositionMatch
    inc c
    rst DecrAttr
    jr .CheckPositionMatch

; $2ab5
.EagleLeftOfPlayer:
    rst IncrAttr
    jr nz, .CheckPositionMatch
    inc c
    rst IncrAttr

; $2aba
.CheckPositionMatch:
    ld a, [PlayerPositionYMsb]
    cp d
    ret nz                          ; Return if eagle and player Y position doesn't match.
    ld a, [PlayerPositionYLsb]
    cp e
    ret nz                          ; Return if eagle and player Y position doesn't match.

.AttachPlayerToEagle:
    SetAttribute ATR_Y_POS_DELTA, -1
    xor a
    ld [PlayerSwingAnimIndex], a    ; = 0 (player at left side)
    ld [ObjYWiggle], a              ; = 0
    inc a
    ld [PlayerOnULiana], a          ; = 1 (PLAYER_HANGING_ON_ULIANA)
    ld [ULianaSwingDirection], a    ; = 1
    ld a, 32
    ld [ULianaCounter], a           ; = 32
    dec c
    rst SetAttr
    ld a, $3e
    ld [AnimationIndexNew], a
    ret

; $2ae4
.EagleRising:
    ld a, e
    sub c
    ld [PlayerPositionYLsb], a
    ld a, d
    sbc 0
    ld [PlayerPositionYMsb], a      ; Let player rise as well.
    ld a, [PlayerWindowOffsetY]
    cp 192
    ret c                           ; Continue when player is at bottom of the map.
    ld a, 10
    ld [RunFinishTimer], a          ; = 10
    ld a, 11
    ld [CurrentLevel], a            ; = 11
    SetAttribute ATR_Y_POS_DELTA, 0
    ret

; $2b04
.InTransitionLevel:
    ld a, e
    cp 80
    jr z, .DropPlayer               ; Drop player at Y LSB height of 80.
    sub c
    ld [PlayerPositionYLsb], a
    ld a, d
    sbc 0
    ld [PlayerPositionYMsb], a      ; Decrement player's Y position.
    ret

; $2b14: At a certain height the eagle drops the player.
.DropPlayer:
    ld a, OBJECT_FACING_RIGHT | SPRITE_X_FLIP_MASK
    ld c, ATR_SPRITE_PROPERTIES
    rst SetAttr
    xor a
    inc c
    rst SetAttr
    ld [PlayerOnULiana], a          ; = 0
    inc a
    ld [AnimationCounter], a        ; = 1
    ld a, 4
    ld [CrouchingHeadTilted], a     ; = 4
    ld a, $ff
    ld [LandingAnimation], a        ; = $ff
    ret

; 2b2e: Handles the eagle's item drop in the transition level.
EagleItemDrop:
    pop af
    ld a, [EagleTransitionState]
    or a
    ret nz
    ld a, [TransitionLevelState]
    and $ef
    jr nz, .Continue1

; $2b3b
.SpawnExtraTime
    ld d, ID_EXTRA_TIME
    jr .SpawnItem

; $2b3f
.Continue1:
    cp $02
    jr nz, .Continue2

; $2b43
.SpawnDiamond:
    ld d, ID_DIAMOND
    jr .SpawnItem

; 2b47
.Continue2:
    cp $04
    ret nz

; $SpawnShovel
.SpawnShovel:
    ld d, ID_SHOVEL
    ld b, a
    ld a, [BonusLevel]
    or a
    ld a, b
    jr nz, .SpawnItem
    inc a
    ld [TransitionLevelState], a                   ; = 1
    ret

; $2b59
.SpawnItem:
    inc a
    or $80
    ld [TransitionLevelState], a
    ld [EagleTransitionState], a
    push de
    push hl
    ld hl, DiamondObjectData
    ld de, GeneralObjects + 2 * SIZE_GENERAL_OBJECT
    ld bc, SIZE_GENERAL_OBJECT - 8
    push de
    rst CopyData
    pop de
    pop hl
    ld a, $40
    ld [de], a                      ; item[0] = $40
    inc e
    GetAttribute ATR_Y_POSITION_LSB
    add 8
    ld [de], a                      ; item[ATR_Y_POSITION_LSB] = obj[ATR_Y_POSITION_LSB] + 8
    inc e
    inc c
    rst GetAttr                     ; a = obj[ATR_Y_POSITION_MSB]
    ld [de], a                      ; item[ATR_Y_POSITION_MSB] = obj[ATR_Y_POSITION_MSB]
    inc e
    inc c
    rst GetAttr                     ; a = obj[ATR_X_POSITION_LSB]
    add 2
    ld [de], a                      ; item[ATR_X_POSITION_LSB] = obj[ATR_X_POSITION_LSB] + 2
    inc e
    inc c
    rst GetAttr                     ; a = obj[ATR_X_POSITION_MSB]
    ld [de], a                      ; item[ATR_X_POSITION_MSB] = obj[ATR_X_POSITION_MSB]
    inc e
    pop af
    ld [de], a                      ; item[ATR_ID] = ...
    ld a, e
    add $0f
    ld e, a
    ld a, $80
    ld [de], a                      ; item[ATR_14] = ...
    ret

; $2b94: This function handles despawning items, falling platforms, sinking stones, hippos, lightnings, and mosquito.
; Input: hl = pointer to object
HandleObjects:
    GetAttribute ATR_ID
    cp ID_FALLING_PLATFORM
    jr z, HandleSinkingStoneOrPlatform
    cp ID_SINKING_STONE
    jr z, HandleSinkingStoneOrPlatform
    cp ID_GRAPES
    jr c, :+
    cp ID_SHOVEL
    jp c, HandleItemDespawn         ; Jump if object is an item (but not shovel, double banana or stones).
 :  cp ID_HIPPO
    jp z, HandleHippo
    cp ID_LIGHTNING
    jp z, HandleLightning
    cp ID_MOSQUITO
    ret nz

; Handles the position of the mosquito enemy.
; Input: hl = pointer to mosquito object
HandleMosquito:
    GetAttribute ATR_MOSQUITO_TIMER
    inc a
    and %11111                      ; mod 32
    rst SetAttr
    ld c, a
    and (SPRITE_Y_FLIP_MASK | SPRITE_X_FLIP_MASK) >> 4
    swap a
    ld d, a                         ; d = sprite mask derived from obj[ATR_MOSQUITO_TIMER]
    push hl
    ld hl, MosquitoYPositions
    ld a, c
    srl c                           ; c = [0..16]
    add hl, bc
    rra
    ld a, [hl]
    jr c, .NoSwap
    swap a
.NoSwap:
    and $0f
    bit 3, a
    jr z, .IsPositive
    or $f0
.IsPositive:
    pop hl
    bit 1, [hl]
    jr z, .HitMode
    add a
.HitMode:
    ld c, ATR_Y_POSITION_LSB
    rst AddToAttr
    rst SetAttr                     ; Add "a" to obj[ATR_Y_POSITION_LSB]
    GetAttribute ATR_SPRITE_PROPERTIES
    and ~(SPRITE_X_FLIP_MASK | SPRITE_Y_FLIP_MASK)
    or d
    rst SetAttr                     ; obj[ATR_MOSQUITO_TIMER] determines sprite flips.
    bit 1, [hl]
    ret z                           ; Continue only if object was hit by a player's projectile.
    ld a, d
    or a
    ret nz                          ; Continue only if timer reaches 0.
    ld a, [PlayerWindowOffsetY]
    sub 16
    ld e, a
    ld a, [BgScrollYLsb]
    ld d, a
    ld c, ATR_Y_POSITION_LSB
    rst GetAttr
    sub d                           ; a = screen position of object
    cp 120
    ret nc                          ; Continue if object under 120.
    cp e
    ret z
    jr nc, .DecrementYPosition
.IncrementYPosition:
    rst GetAttr
    inc a
    rst SetAttr
    ret nz
    inc c
    rst IncrAttr
    ret
.DecrementYPosition:
    rst GetAttr
    dec a
    rst SetAttr
    inc a
    ret nz
    inc c
    rst DecrAttr
    ret

; $2c13
HandleSinkingStoneOrPlatform:
    bit 5, [hl]
    ret z
    cp ID_FALLING_PLATFORM
    jr z, CheckPlatformFallingTimer
.SinkingStone:
    ld c, ATR_FALLING_TIMER
    rst GetAttr                     ; a = obj[ATR_FALLING_TIMER]
    or a
    ret z
    rst DecrAttr                    ; obj[ATR_FALLING_TIMER]--
    ret nz                          ; Return if it is nonzero. Else the sinking stone is deleted.

; $2c21: DeleteFallingPlatform always ends with this.
DeleteFallingPlatform2:
    SafeDeleteObject
    SetAttribute ATR_09, $02
    ret

; $2c29: Reduces platform falling timer by 1.
; If timer falls below WIGGLE_THRESHOLD, the platform starts to wiggle.
CheckPlatformFallingTimer:
    ld c, ATR_FALLING_TIMER
    rst GetAttr
    or a
    jr z, PlatformIncomingBlink     ; Jump if timer is 0.
    dec a
    rst SetAttr                     ; Decrease timer value by 1.
    or a
    jr z, DeleteFallingPlatform     ; If timer goes 0, platform will be deleted.
    cp WIGGLE_THRESHOLD
    ret nc                          ; Below the threshold of 18, the platform wiggle starts.
    rra
    and %1
    ld [ObjYWiggle], a              ; ObjYWiggle = 2nd bit of timer. So every 2nd call it toggles.
    set 1, [hl]
    ld c, a
    ld a, [FallingPlatformLowPtr]
    cp l
    ret nz
    ld a, c
    ld [PlayerYWiggle], a           ; PlayerYWiggle = 2nd bit of timer. So every 2nd call it toggles.
    ret

; $2c4a: Toggles a platform's visibility. Only used for the platforms in Shere Khan's level afaik.
PlatformIncomingBlink:
    dec c                           ; = $15 (TODO: Find out what attribute $15 is used for)
    rst GetAttr
    or a
    ret z                           ; Return if [obj + ATR_PLATFORM_INCOMING_BLINK] is zero.
    dec a                           ; a -= 1
    rst SetAttr                      ; [obj + ATR_PLATFORM_INCOMING_BLINK] -= 1
    and %10                         ; a = %(1|0)0
    add a                           ; a = %(1|0)00
    add a                           ; a = %(1|0)000
    swap a                          ; a = %(1|0)0000000
    ld d, a                         ; d = %(1|0)0000000
    ld c, ATR_SPRITE_PROPERTIES
    rst GetAttr                      ; a = ATR_SPRITE_PROPERTIES
    and %01111111                   ; Turns off invisibility of the object's sprite.
    or d
    rst SetAttr                      ; Set invisibility.
    ret

; $2c5f: Safe delete of a falling platform. Will eventually lead to the platform falling down.
DeleteFallingPlatform:
    ld [ObjYWiggle], a                ; = 0
    ld [PlayerYWiggle], a             ; = 0
    jr DeleteFallingPlatform2

; $2c67: Checks whether the Hippo collides with Baloo.
; Input: hl = pointer to hippo object
HandleHippo:
    ld a, [BalooElephantXLsb]
    ld d, a
    GetAttribute ATR_X_POSITION_LSB
    sub d
    cp 110
    jr z, BalooCollision
    cp 174
    ret nz
    SetAttribute ATR_Y_POS_DELTA, -1
    ret

; $2c7c: Called when Baloo collides with a hippo.
; Input: hl = pointer to hippo object
BalooCollision:
    GetAttribute ATR_Y_POSITION_LSB
    cp 248
    ret nc
    SetAttribute ATR_Y_POS_DELTA, 1
    inc c
    rst SetAttr
    ld a, 8
    ld [BalooFreeze], a             ; = 8
    ret

; $2c8f Handles the appearance of a lightning object.
; Input: hl = pointer to lightning object
HandleLightning:
    GetAttribute ATR_LIGHNTING_TIMER
    dec a
    rst SetAttr                     ; Decrement obj[ATR_LIGHNTING_TIMER].
    ld d, a
    cp 12
    ret nc                          ; Return if timer above 11. Else let the lightning strike!
    and %10
    xor %10
    rrca
    rrca
    ld e, a
    GetAttribute ATR_SPRITE_PROPERTIES
    and ~SPRITE_INVISIBLE_MASK
    or e
    rst SetAttr                     ; Let lightning blink!
    SetAttribute ATR_FREEZE, 2
    ld a, d
    or a
    ret nz
    ld a, [BossActive]
    or a
    jr z, .NoBossActive

; Shere Khan is the only boss casting lightnings.
.BossActive
    DeleteObject
    ret

; $2c7b
.NoBossActive:
    ldh a, [rLY]
    and %01111111
    add 32
    ld c, ATR_LIGHNTING_TIMER
    rst SetAttr
    ret

; $2cc1: Only plays a role for the King Louie boss fight.
; Lets an item despawn after a certain period of time if ItemDespawnTimer is set.
; Input: hl = pointer to item object
HandleItemDespawn:
    ld a, [ItemDespawnTimer]
    or a
    ret z
    dec a
    ld [ItemDespawnTimer], a        ; -= 1
    jr nz, .TimerActive
    DeleteObject
    ret

; $2ccf
.TimerActive:
    cp 64
    ret nc
    and %100
    add a
    swap a
    ld d, a
    GetAttribute ATR_SPRITE_PROPERTIES
    and ~SPRITE_INVISIBLE_MASK
    or d
    rst SetAttr                     ; Let item blink!
    ret

; $2ce0: Related to periodic behavior of enemy objects like fishes or frogs.
; Only relevant for objects use obj[ATR_PERIOD_TIMER0_RESET].
; With every call, obj[ATR_PERIOD_TIMER0] is decremented.
; If it reaches 0, it is set to obj[ATR_PERIOD_TIMER0_RESET], obj[ATR_PERIOD_TIMER1] is increment.
; obj[ATR_PERIOD_TIMER1] is set to 0 once it exceeds obj[ATR_PERIOD_TIMER1_RESET].
; Input: "hl" pointer to object
CheckEnemyAction:
    GetAttribute ATR_PERIOD_TIMER0_RESET
    ld d, a                         ; d = obj[ATR_PERIOD_TIMER0_RESET]
    or a
    ret z                           ; return if obj[ATR_PERIOD_TIMER0_RESET] is zero.

    ld c, ATR_HEALTH
    rst GetAttr
    inc a
    jp z, CheckBossAction           ; Boss case (a was $ff which is only true for bosses).
    IsObjOnScreen
    ret z                           ; Return if object is not on screen.
    ObjMarkedSafeDelete
    ret nz                          ; Return if object was marked for safe delete-
    bit 3, [hl]
    jr nz, jr_000_2d12

    ld c, ATR_PERIOD_TIMER0
    rst DecrAttr
    ret nz                          ; Return if ATR_PERIOD_TIMER0 is not zero.

    ld a, d
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER0] = obj[ATR_PERIOD_TIMER0_RESET]
    inc c
    rst GetAttr                     ; a = obj[ATR_PERIOD_TIMER1]
    inc a
    inc c
    rst CpAttr                      ; Compare obj[ATR_PERIOD_TIMER1_RESET] against obj[ATR_PERIOD_TIMER1] + 1
    dec c
    jr c, :+
    xor a
 :  rst SetAttr                     ; obj[ATR_PERIOD_TIMER1]++ or obj[ATR_PERIOD_TIMER1] = 0 if obj[ATR_PERIOD_TIMER1_RESET] is exceeded.
    ld d, a
    GetAttribute ATR_06
    cp 144
    ret nc

    set 3, [hl]
    jr jr_000_2d16

jr_000_2d12:
    GetAttribute ATR_PERIOD_TIMER1
    ld d, a

jr_000_2d16:
    ld a, [JumpTimer]
    or a
    ret nz                          ; Return if JumpTimer is non-zero.

    inc a
    ld [JumpTimer], a               ; = 1
    GetAttribute ATR_ID
    ld e, a                         ; e = obj[ATR_ID]
    bit 2, [hl]
    jp nz, Jump_000_2dee

    add d
    ld [NumObjSpriteIndex], a       ; = obj[ATR_ID] + obj[ATR_PERIOD_TIMER1]
    ld a, l
    ld [ActionObject], a
    ld a, [hl]
    and %111
    jp nz, CheckMonkeyChangeAndScorpionShot

    ld a, d
    or a
    jr z, jr_000_2d51

    ld a, d
    add a
    add a
    add d
    ld c, $0c
    rst SetAttr
    ld a, d
    cp $01
    ret nz

    ld a, e
    cp $e2
    ret z

    cp ID_FROG
    jp z, ForwardToCheckFrogJump    ; This may trigger a frog jump.

    jp ShootEnemyProjectile


jr_000_2d51:
    ld c, ATR_ID
    rst GetAttr
    cp ID_FROG
    jp z, SetFrogFacingDirection    ; Jump if frog.
    cp ID_HANGING_MONKEY2
    ret z
    cp ID_VILLAGE_GIRL
    ret z

    ld c, ATR_Y_POSITION_LSB
    rst GetAttr
    ld b, a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, b
    sub c
    add $20
    ld b, a
    ld a, [PlayerWindowOffsetY]
    cp b
    push af
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    ld e, a
    inc c
    rst GetAttr
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
    ld a, ID_HANGING_MONKEY
    jr c, jr_000_2d94

jr_000_2d92:
    ld a, ID_SITTING_MONKEY

jr_000_2d94:
    ld c, ATR_ID
    rst SetAttr                     ; obj[ATR_ID] = ID_SITTING_MONKEY or ID_HANGING_MONKEY
    ld [NumObjSpriteIndex], a       ; = ID_SITTING_MONKEY or ID_HANGING_MONKEY
    ld e, $02
    cp ID_HANGING_MONKEY
    jr z, jr_000_2da7

    ld e, $03
    xor a
    bit 7, d
    jr z, jr_000_2da9

jr_000_2da7:
    ld a, $20

jr_000_2da9:
    ld d, a
    GetAttribute $07
    and $df
    or d
    rst SetAttr
    ld a, e
    ld c, $0e
    rst SetAttr
    GetAttribute $16
    or a
    ret z

    ld a, [TimeCounter]
    and $0f
    add $0c
    rst SetAttr
    set 0, [hl]
    SetAttribute ATR_ID, ID_WALKING_MONKEY
    ld [NumObjSpriteIndex], a       ; = ID_WALKING_MONKEY
    GetAttribute $07
    and $df
    ld b, a
    and $02
    swap a
    or b
    rst SetAttr
    SetAttribute ATR_09, $01
    ld c, $0c
    rst SetAttr
    ld a, $04
    dec c
    rst SetAttr
    SetAttribute ATR_PERIOD_TIMER1_RESET, 6
    ld a, $04
    inc c
    rst SetAttr
    ret


; $2dee
; Input: hl = pointer to object
;        d = obj[ATR_PERIOD_TIMER1] or obj[ATR_06]
;        e = obj[ATR_ID]
Jump_000_2dee:
    ld a, e
    cp ID_CHECKPOINT
    jr nz, .Continue

.HandleCheckpoint:
    ld a, d                         ; "d" is alwys 0 if checkpoint wasn't reached yet.
    or a
    jr z, .NoFlip
    ld a, SPRITE_X_FLIP_MASK        ; Flip the checkpoint's sprite

; $2df9
.NoFlip:
    ld c, ATR_SPRITE_PROPERTIES
    rst SetAttr
    ld a, d
    cp 2
    jr z, .Enabled

    ld c, ATR_ID
    rst AddToAttr
    ld [NumObjSpriteIndex], a
    ld a, l
    ld [ActionObject], a
    ret

.Enabled:
    xor a
    ld [JumpTimer], a               ; = 0
    res 3, [hl]
    ret

.Continue:
    cp ID_HIPPO
    jr nz, .Continue2

.HandleHippo:
    GetAttribute ATR_Y_POSITION_LSB
    cp $f0
    jr z, .Continue2

    SetAttribute ATR_SPRITE_INDEX, 0
    ld d, a

.Continue2:
    ld a, d
    add a
    ld b, a
    push de
    ld a, [hl]
    and %11
    add a
    ld d, $00
    ld e, a
    push hl
    ld hl, TODOData63ea
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
    ld a, [de]
    cp $0b
    jr nc, jr_000_2e45

    ld c, ATR_ID
    rst AddToAttr

jr_000_2e45:
    ld [NumObjSpriteIndex], a
    push af                     ; Push animation index.
    cp $0f
    jr nc, jr_000_2e7f

    ld a, b
    cp $05
    jr nc, jr_000_2e7f

    push de
    GetAttribute ATR_X_POSITION_LSB
    and $f0
    swap a
    srl a
    ld e, a
    inc c
    rst GetAttr
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
    ld a, SPRITE_X_FLIP_MASK
    jr c, .Carry
    xor a
.Carry:
    ld c, ATR_SPRITE_PROPERTIES
    rst SetAttr

jr_000_2e7f:
    inc de
    ld a, [de]
    ld c, $0c
    rst SetAttr
    ld a, l
    ld [ActionObject], a
    pop af                          ; Animation index.
    pop de
    cp ID_COBRA + 3
    jr z, ShootSnakeProjectile
    cp ID_ELEPHANT + 2
    jr z, ShootElephantProjectile
    ld a, e
    cp ID_CROCODILE
    jp z, HandleCrocAndHippo
    cp ID_HIPPO
    jp z, HandleCrocAndHippo
    ld a, d
    cp 6
    ret nz
    jp ShootEnemyProjectile

; $2ea4: Called when an elephant of the dawn patrol shoots a projectile.
; Input: hl = pointer to elephant object
ShootElephantProjectile:
    ld bc, ShotProjectileData
    call LoadEnemyProjectileIntoSlot
    ret z                           ; Return if no free slot for the projectile was found.
    ld a, EVENT_SOUND_ELEPHANT_SHOT
    ld [EventSound], a              ; Play the sound of the elephant shot.
    xor a
    ld [de], a                      ; projectile[ATR_STATUS] = 0
    inc e
    push hl
    inc l
    ld a, [ObjYWiggle]
    ld b, a
    ld a, [hl+]
    add b
    sub 30
    ld [de], a                      ; projectile[ATR_Y_POSITION_LSB] = obj[ATR_Y_POSITION_LSB] + wiggle - 30
    inc e
    ld a, [hl+]
    sbc 0
    ld [de], a                      ; projectile[ATR_Y_POSITION_MSB] = obj[ATR_Y_POSITION_MSB] + carry
    inc e
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = elephant[ATR_X_POSITION]
    ld a, [BalooElephantXLsb]
    ld c, a
    ld a, [BalooElephantXMsb]
    ld b, a                         ; bc = [BalooElephantX]
    add hl, bc
    ld a, h
    cp $15
    jr c, .Carry
    sub $15
    ld h, a

; $2ed8
.Carry:
    ld a, l
    sub 12
    jr nc, .NoCarry
    dec h

; $2ede
.NoCarry:
    ld [de], a                     ; projectile[ATR_X_POSITION_LSB] = a
    inc e
    ld a, h
    ld [de], a                     ; projectile[ATR_X_POSITION_MSB] = a
    inc e
    inc e
    inc e
    ld a, SPRITE_X_FLIP_MASK | ((-2) & %1111)
    ld [de], a                     ; Set projectile[ATR_POSITION_DELTA] and projectile[ATR_SPRITE_FLIP].
    xor a
    inc e
    ld [de], a                     ; projectile[ATR_BALL_VSPEED] = 0
    pop hl
    ret

; $2eed: Called when the cobra enemy shoots a projectile.
; Input: hl = pointer to cobra object
ShootSnakeProjectile:
    ld bc, ShotProjectileData
    call LoadEnemyProjectileIntoSlot
    ret z                           ; Return if no slot was found.
    ld a, EVENT_SOUND_SNAKE_SHOT
    ld [EventSound], a
    inc e
    push hl
    inc l
    ld a, [hl+]                     ; a = obj[ATR_Y_POSITION_LSB]
    sub 12
    ld [de], a                      ; projectile[ATR_Y_POSITION_LSB] = a
    inc e
    ld a, [hl+]                     ; a = obj[ATR_Y_POSITION_MSB]
    sbc 0
    ld [de], a                      ; projectile[ATR_Y_POSITION_MSB] = a
    inc e
    ld c, [hl]                      ; c = obj[ATR_X_POSITION_LSB]
    inc l
    ld b, [hl]                      ; b = obj[ATR_X_POSITION_MSB]
    inc l
    inc l
    inc l
    ld a, c
    bit 5, [hl]                     ; obj[ATR_SPRITE_PROPERTIES] (check if X-flip)
    jr nz, .ObjFacingLeft
    add 28                          ; Small X-offset so the projectile aligns with the animation.
    jr nc, .SetProjectileXPos
    inc b
    jr .SetProjectileXPos

; $2f18
.ObjFacingLeft:
    sub 28                          ; Small X-offset so the projectile aligns with the animation.
    jr nc, .SetProjectileXPos
    dec b

; $2f1d
.SetProjectileXPos:
    ld [de], a                      ; projectile[ATR_X_POSITION_LSB] = a
    inc e
    ld a, b
    ld [de], a                      ; projectile[ATR_X_POSITION_MSB] = a
    inc e
    inc e
    inc e
    ld a, [hl]
    ld b, (-2) & %1111
    bit 5, a
    jr nz, .SetXSpeed
    ld b, 2

; $2f2d
.SetXSpeed:
    or b
    ld [de], a                      ; projectile[ATR_POSITION_DELTA] = a; projectile[ATR_SPRITE_FLIP] = b
    ld a, e
    add $09
    ld e, a                         ; "de" now points to target attributes.
    ld c, PLAYER_HEIGHT / 2         ; Target is the middle of the player.
    jp SetPlayerPositionAsTarget

; $2f38: Checks if monkeys change their state and if scorpions shoot their projectile.
; Input: e = obj[ATR_ID]
CheckMonkeyChangeAndScorpionShot:
    ld a, e
    cp ID_STANDING_MONKEY
    jr z, CheckStandingToWalkingMonkey
    cp ID_SCORPION
    jp z, CheckScorpionShot
    cp ID_WALKING_MONKEY
    ret nz

; $2f45: Changes walking monkey to either sitting or standing monkey depending on conditions.
CheckWalkingMonkeyChange:
    ld c, ATR_16
    rst DecrAttr
    ret nz
    ld a, ATR_PERIOD_TIMER0
    rst SetAttr
    SetAttribute ATR_09, 0
    ld a, [PlayerWindowOffsetX]
    ld e, a                         ; e = [PlayerWindowOffsetX]
    ld a, [BgScrollXLsb]
    ld d, a
    GetAttribute ATR_X_POSITION_LSB
    sub d                           ; a = obj[ATR_X_POSITION_LSB] - [BgScrollXLsb]
    ld d, a                         ; d = screen coordinate of monkey
    GetAttribute ATR_FACING_DIRECTION
    ld b, a
    ld a, d
    cp e                            ; screen coordinate of monkey - [PlayerWindowOffsetX]
    jr c, .MonkeyLeftOfPlayer
    bit 3, b
    jr z, .MonkeyLookingAway
    jr .MonkeyLookingAtPlayer

; $2f6b
.MonkeyLeftOfPlayer:
    bit 3, b
    jr nz, .MonkeyLookingAway

; $2f6f: If the monkey looks at the player, it sits down and throws a coconut.
.MonkeyLookingAtPlayer:
    res 0, [hl]
    SetAttribute2 ATR_PERIOD_TIMER0_RESET, 8
    inc c
    ld a, 16
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER0] = 16
    SetAttribute2 ATR_PERIOD_TIMER1_RESET, 3
    inc c
    rst SetAttr                     ; obj[ATR_HITBOX_PTR] = 3
    ld a, ID_SITTING_MONKEY
    jr SetMonkeyId

; $2f85: If the monkey does not look at the player, it just turns into a standing monkey.
.MonkeyLookingAway:
    ld a, ID_STANDING_MONKEY

; $2f87
SetMonkeyId:
    ld c, ATR_ID
    rst SetAttr                     ; obj[ATR_ID] = ID_SITTING_MONKEY or ID_STANDING_MONKEY
    ld [NumObjSpriteIndex], a       ; = ID_SITTING_MONKEY or ID_STANDING_MONKEY
    SetAttribute ATR_PERIOD_TIMER1, 0
    ret

; $2f92: Turns a standing monkey into a walking monkey depending on conditions.
CheckStandingToWalkingMonkey:
    ld c, ATR_16
    rst DecrAttr
    ret nz                          ; Only continue if obj[ATR_16] = 0.
    ld a, [TimeCounter]
    and %1111
    add 12
    rst SetAttr                     ; obj[ATR_16] = random value + 12
    SetAttribute ATR_09, $01
    ld a, ID_WALKING_MONKEY
    jr SetMonkeyId

; $2fa7: Called for crocodiles and hippos. Handles opening the jaw and direction change.
; Input: hl = pointer to object
;        d = obj[ATR_PERIOD_TIMER1] or obj[ATR_06]
;        e = obj[ATR_ID]
HandleCrocAndHippo:
    ld a, d
    or a
    jr nz, .CheckAction
    set 5, [hl]                    ; Bit 5 is set when jaw is closed.
    ret

; $2fae
.CheckAction:
    res 5, [hl]                     ; Open the jaw.
    ld a, e
    cp ID_CROCODILE
    ret nz                          ; Return for hippo

.CrocodileJaw:
    ld a, d
    cp 2
    jr z, .CheckFacingDirection
    ld a, EVENT_SOUND_CROC_JAW
    ld [EventSound], a

; $2fbe
.CheckFacingDirection:
    GetAttribute ATR_FACING_DIRECTION
    ld b, a
    and $0f
    ret nz                          ; Return if object has a facing direction.
    ld a, 1                         ; a = object facing right
    bit 5, b                        ; Check X-flip.
    jr nz, .SetAndDirectionChange   ; Jump if sprite is flipped.
    cpl
    inc a
    and %1111                       ; a = %1111 (object facing left)

; $2fcf
.SetAndDirectionChange:
    or b
    rst SetAttr
    SetAttribute ATR_09, 0
    jp ChangeEnemyDirection

; $2fd8: Checks if the scorpion will shoot its projectile. If so, ShootScorpionProjectile is called.
; Input: hl = pointer to scorpion object
CheckScorpionShot:
    GetAttribute ATR_16
    or a
    jr z, ShootScorpionProjectile
    rst DecrAttr
    ret nz

; $2fe0: Lets the scorpion shoot a projectile.
; Input: hl = pointer to scorpion object
ShootScorpionProjectile:
    ld a, ATR_PERIOD_TIMER0
    rst SetAttr
    ld c, ATR_FREEZE
    rst SetAttr
    ld bc, ShotProjectileData
    call LoadEnemyProjectileIntoSlot
    ret z                           ; Return if no slot could be found.
    ld a, EVENT_SOUND_SNAKE_SHOT
    ld [EventSound], a              ; Load corresponding sound.
    xor a
    ld [de], a                      ; projectile[ATR_STATUS] = 0
    inc e
    push hl
    inc l
    ld a, [hl+]
    sub 10
    ld [de], a                      ; projectile[ATR_Y_POSITION_LSB] = obj[ATR_Y_POSITION_LSB] - 10
    inc e
    ld a, [hl+]
    sbc 0
    ld [de], a                      ; projectile[ATR_Y_POSITION_MSB] = obj[ATR_Y_POSITION_MSB] - carry
    inc e
    ld a, [hl+]
    ld [de], a                      ; projectile[ATR_X_POSITION_LSB] = obj[ATR_X_POSITION_LSB]
    inc e
    ld a, [hl+]
    ld [de], a                      ; projectile[ATR_X_POSITION_MSB] = obj[ATR_X_POSITION_MSB]
    inc e
    inc e
    inc e
    inc l
    inc l
    ld a, 2
    bit 5, [hl]
    jr z, .FacingRight
    ld a, SPRITE_X_FLIP_MASK | ((-2) & %1111)

; $3013
.FacingRight:
    ld [de], a                      ; Set ATR_SPRITE_PROPERTIES and ATR_FACING_DIRECTION.
    pop hl
    ret

; $3016:
; Input: hl = pointer to enenemy object
ShootEnemyProjectile:
    IsObjEmpty
    ret nz                          ; Return if object marked empty.
    ObjMarkedSafeDelete
    ret nz                          ; Rteurn if object marked for safe delete.
    ld bc, BallProjectileData
    call LoadEnemyProjectileIntoSlot
    ret z                           ; Return if no slot was found for the projectile.
    inc de                          ; e = 1
    ld b, 4
    push hl
    inc hl

; $3028
.Loop:                              ; This loop copies the enemy's position into the projectile position.
    ld a, [hl+]
    ld [de], a
    inc e
    dec b
    jr nz, .Loop

    pop hl
    inc e
    inc e                           ; e = 7
    GetAttribute ATR_ID
    ld c, ATR_SPRITE_PROPERTIES
    cp ID_SITTING_MONKEY
    jr z, .SittingMonkeyShot
    cp $c0
    jr nc, .BossShot                 ; Jump for monkey boss and Shere Khan.

; $303e
.HangingMonkeyShot:
    push af
    inc e                           ; e = 8
    ld a, 3
    ld [de], a                      ; projectile[ATR_BALL_VSPEED] = 3
    pop af                          ; a = obj[ATR_ID]
    cp ID_HANGING_MONKEY2
    ret nz                          ; Continue if hanging monkey 2.
    ld a, e
    sub 8
    ld e, a                         ; e = 0
    ld a, %10
    ld [de], a                      ; projectile[0] = %10
    ret

; $304f
.BossShot:
    rst GetAttr
    and SPRITE_X_FLIP_MASK
    ld a, 2
    jr nz, .SetProjectilePos
    jr .SetProjectilePosLeft

; $3058
.SittingMonkeyShot:
    rst GetAttr
    and SPRITE_X_FLIP_MASK
    ld a, 2
    jr z, .SetProjectilePos

; $305f
.SetProjectilePosLeft:
    ld a, SPRITE_X_FLIP_MASK | ((-2) & %1111)

; $3061
.SetProjectilePos:
    ld [de], a                      ; Set projectile X speed and sprite flip.
    inc e
    GetAttribute ATR_Y_POSITION_LSB
    ld b, a
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, b
    sub c
    add 32
    ld b, a                         ; b = obj[ATR_Y_POSITION_LSB] - [BgScrollYLsb] + 32
    ld a, [PlayerWindowOffsetY]
    cp b
    jr c, .PlayerAboveProjectile     ; Jump if player above enemey projectile.

  ; $3076
.PlayerBelowProjectile:
    ld a, 2
    ld [de], a                      ; obj[ATR_BALL_VSPEED] = 2
    dec e
    jr .SetPosition

; $307c
.PlayerAboveProjectile:
    xor a
    ld [de], a                      ; obj[ATR_BALL_VSPEED] = 0
    dec e
    ld a, [de]                      ; a = obj[ATR_POSITION_DELTA]
    bit 3, a
    ld a, 3
    jr z, .SetXSpeedAndXFlip
    ld a, SPRITE_X_FLIP_MASK | ((-3) & %1111)

; $3088
.SetXSpeedAndXFlip:
    ld [de], a                      ; Set projectile X speed and sprite flip.

; $3089
.SetPosition:
    ld a, [de]                      ; Get projectile X speed and sprite flip.
    ld c, a
    ld a, e
    sub 6
    ld e, a                         ; e = 1
    ld a, [BossActive]
    or a
    jr z, ProjectilePosDec16       ; Jump if boss is not active.

.BossActive:
    call ProjectilePosDec16        ; Decrement Y position.
    bit 3, c
    jr nz, ProjectilePosDec16      ; Decrement X position.

.IncrementXPos:
    ld a, [de]
    add 16
    ld [de], a
    ret

; $30a1: Decrements a projectile's position by 16. Increments "de".
; Input: de = pointer to projectile position (either X or Y)
ProjectilePosDec16:
    ld a, [de]                      ; a = projectile[ATR_Y_POSITION_LSB]
    sub 16
    ld [de], a                      ; projectile[ATR_Y_POSITION_LSB] -= 16
    inc e
    ld a, [de]
    sbc 0
    ld [de], a                      ; projectile[ATR_Y_POSITION_MSB] -= carry
    inc e
    ret

; $30ac
ForwardToCheckFrogJump:
    call CheckFrogJump

; $30af: This is called when a frog enemy shoots a projectile.
; Input: pointer to frog in "hl"
ShootProjectileFrog:
    ld bc, ShotProjectileData
    call LoadEnemyProjectileIntoSlot
    ret z
    ld a, EVENT_SOUND_SNAKE_SHOT
    ld [EventSound], a
    xor a
    ld [de], a                      ; projectile[0] = 0
    inc e
    push hl
    ld c, FROG_PROJECTILE_Y_OFFSET_DEFAULT
    bit 0, [hl]                     ; frog[0] & 1 (bit 0 is set if the frog is jumping)
    jr z, :+
    ld c, FROG_PROJECTILE_Y_OFFSET_JUMPING
 :  inc l
    ld a, [hl+]                     ; a = frog[ATR_Y_POSITION_LSB]
    sub c
    ld [de], a                      ; projectile[ATR_Y_POSITION_LSB] = frog[ATR_Y_POSITION_LSB] - offset
    inc e
    ld a, [hl+]
    sbc 0
    ld [de], a                      ; projectile[ATR_Y_POSITION_MSB] = frog[ATR_Y_POSITION_MSB] - carry
    inc e
    ld c, [hl]                      ; c = frog[ATR_X_POSITION_LSB]
    inc l
    ld b, [hl]                      ; b = frog[ATR_X_POSITION_MSB]
    inc l
    inc l
    inc l                           ; l = x7
    ld a, c                         ; a = frog[ATR_X_POSITION_LSB]
    bit 5, [hl]                     ; Bit 5 = frog facing direction
    jr nz, .FrogFacingLeft
.FrogFacingRight:
    add FROG_PROJECTILE_X_OFFSET
    jr nc, .Continue
    inc b
    jr .Continue
.FrogFacingLeft:
    sub FROG_PROJECTILE_X_OFFSET
    jr nc, .Continue
    dec b
.Continue:
    ld [de], a                      ; projectile[ATR_X_POSITION_LSB] +- offset
    inc e
    ld a, b
    ld [de], a                      ; projectile[ATR_X_POSITION_MSB] +- carry
    inc e
    inc e
    inc e
    ld a, [hl]                      ; a = frog[ATR_SPRITE_PROPERTIES]
    ld b, %1101
    bit 5, a
    jr nz, :+
    ld b, %11
 :  or b
    ld [de], a                      ; projectile[ATR_X_POSITION_MSB] = frog[ATR_SPRITE_PROPERTIES] | mask
    xor a
    inc e
    ld [de], a                      ; projectile[$8] = 0
    pop hl
    ld c, 4
    bit 6, [hl]
    jr nz, :+
    ld c, 16
 :  ldh a, [rLY]
    and %11111
    add c
    ld c, ATR_PERIOD_TIMER0_RESET
    rst SetAttr                     ; frog[$b] = (rLY & %11111) + offset
    ret

; $310f: Determines the frog's facing direction based on the player's location.
; This sets or resets Bit 5 in frog[0].
; Input: hl = pointer to frog object
SetFrogFacingDirection:
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    ld e, a                         ; e = frog[ATR_X_POSITION_LSB]
    inc c
    rst GetAttr
    ld d, a                         ; d = frog[ATR_X_POSITION_MSB]
    ld a, [PlayerPositionXLsb]
    sub e                           ; a = [PlayerPositionXLsb] - frog[ATR_X_POSITION_LSB]
    ld a, [PlayerPositionXMsb]
    sbc d                           ; a = [PlayerPositionXMsb] - frog[ATR_X_POSITION_MSB] - carry
    and %100000
    ld d, a                         ; d = a % 100000
    ld c, ATR_FACING_DIRECTION
    rst GetAttr
    and %11011111                   ; a = frog[$7] & %11011111
    or d
    rst SetAttr                     ; frog[$7] = a | d
    ret

; $3129: Checks if player is above frog and if so, triggers jump.
CheckFrogJump:
    ld c, ATR_Y_POSITION_LSB
    rst GetAttr
    ld b, a                         ; b = obj[ATR_Y_POSITION_LSB]
    ld a, [BgScrollYLsb]
    ld c, a                         ; c = [BgScrollYLsb]
    ld a, b
    sub c
    ld b, a                         ; b = obj[ATR_Y_POSITION_LSB] - [BgScrollYLsb]
    ld a, [PlayerWindowOffsetY]
    sub b                           ; a = [PlayerWindowOffsetY] - (obj[ATR_Y_POSITION_LSB] - [BgScrollYLsb])
    ret nc                          ; Return if player is below object.
    cp -48
    ret c
    pop bc
    set 6, [hl]
    set 0, [hl]
    SetAttribute ATR_FREEZE, $06
    SetAttribute ATR_Y_POS_DELTA, -4
    SetAttribute ATR_PERIOD_TIMER0, $11
    jr FishFrogAction2

; $3152: Pointer to object in "hl".
; Handles frog- and fish-related actions (jumping and shooting).
FishFrogAction1:
    ObjMarkedSafeDelete
    ret z
    ld c, ATR_ID
    rst GetAttr
    cp ID_FISH
    jr z, .IsFishOrFrog
    cp ID_FROG
    ret nz

.IsFishOrFrog:
    ld a, [JumpTimer]
    or a
    ret nz

; $3164
FishFrogAction2:
    ld a, [hl]
    and %1                          ; This bit is set if frog is jumping.
    add a                           ; (obj[0] & 1) << 1
    ld d, $00
    ld e, a
    push hl
    ld hl, FishFrogJumpData
    add hl, de
    ld e, [hl]
    inc hl
    ld d, [hl]                      ; de = [$6434 + (IsJumping ? 2 : 0)]
    pop hl
    GetAttribute ATR_Y_POS_DELTA   ; a = obj[$8] (is 0 if frog is sitting, else non-zero)
    bit 1, [hl]
    jr nz, :+                       ; Always 0 for frog.

    add 4
    ld b, a                         ; b = obj[$8] + 4

 :  ld a, e
    add b
    ld e, a                         ; de = [$6434 + (IsJumping ? 2 : 0)] + b
    ld a, [de]
    ld d, a
    ld e, b                         ; de = [de] << 8 | b
    ld c, ATR_PERIOD_TIMER1
    rst GetAttr
    cp d
    jr z, .Skip

    ld a, d
    rst SetAttr                     ; Change period timer.
    GetAttribute ATR_ID
    add d
    ld [NumObjSpriteIndex], a       ; [NumObjSpriteIndex] = obj[ATR_ID] + d
    ld a, l
    ld [ActionObject], a            ; [ActionObject] = LSB of pointer to frog/fish.
    ld a, 1
    ld [JumpTimer], a               ; = 1
    bit 0, [hl]
    ret z                           ; Always non-zero for jumping frog.

    ld a, e
    cp 4
    ret nz                          ; Frogs shoot a projectile if obj[$8] reaches $ff.

    jp ShootProjectileFrog

; $31a6
.Skip:
    bit 0, [hl]
    ret nz                          ; Always non-zero for jumping frog.
    ld c, ATR_FACING_DIRECTION
    rst GetAttr
    and $0f
    ret nz                          ; Return if object doesn't have a facing direction.
    jp Jump_000_00e6

; $31b2: I guess this is only called during the transition scene. For someone objects this is also called outside of cutscenes.
; Input: hl = pointer to object
HandleObjectsInCutscene:
    GetAttribute ATR_HEALTH
    inc a
    ret z                           ; Return if obj[ATR_HEALTH] was $ff (only for bosses).
    ObjMarkedSafeDelete
    ret z                           ; Return if object is marked for safe delete.
    GetAttribute ATR_PERIOD_TIMER0
    or a
    jr z, ObjTimerActionCutscene

; $31c0: Called to let an object rise. After a certain time, this turns an object into the "BONUS" sprites.
.LetObjectRise:
    dec a
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER0]--
    ld d, a                         ; d = obj[ATR_PERIOD_TIMER0]
    srl a
    srl a                           ; a = obj[ATR_PERIOD_TIMER0] / 4
    cpl
    inc a                           ; Negate number using two's complement.
    ld c, ATR_Y_POS_DELTA
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = -obj[ATR_PERIOD_TIMER0] / 4
    ld a, d                         ; a = obj[ATR_PERIOD_TIMER0]
    cp 9
    jr z, TurnIntoBonusObjects      ; Turn object into "BONUS" sprites after a certain point.
    SetAttribute ATR_PERIOD_TIMER1_RESET, 0
    ret

; $: This might turn an object into the "BONUS" objects in the transition level.
; Note that each character is one object.
TurnIntoBonusObjects:
    ld a, [TransitionLevelState]
    or a
    ret z                           ; Return when not in transition level.
    and $f0
    ret nz                          ; Return if TransitionLevelState > 15
    ld a, [TransitionLevelState]
    or %100000
    ld [TransitionLevelState], a
    push hl
    SetAttribute ATR_09, $02
    ld de, GeneralObjects + 3 * SIZE_GENERAL_OBJECT
    ld b, 5

; Copy the object 5 times because "BONUS" is 5 objects. Will turn it to the correct objects later.
.Loop:
    push bc
    push de
    push hl
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData
    pop hl
    pop de
    pop bc
    ld a, e
    add SIZE_GENERAL_OBJECT
    ld e, a
    dec b
    jr nz, .Loop

    pop hl
    push hl
    SetAttribute ATR_FACING_DIRECTION, $0d
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    ld d, ID_CHAR_B
    ld e, $ff
    ld b, 5                         ; Number of loop iterations.
    ld c, b

; Set the
.Loop2:
    push bc
    ld a, d
    rst SetAttr                     ; obj[ATR_ID] = $92 + i
    ld a, e
    and $0f
    inc c
    inc c
    rst SetAttr
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    inc d
    inc e
    pop bc
    dec b
    jr nz, .Loop2
    pop hl
    ret

; $3229: Called when Timer0 reaches 0. For cutscenes only.
ObjTimerActionCutscene:
    ld d, 17
    GetAttribute ATR_ID
    cp ID_SINKING_STONE
    jr nz, .NotASinkingStone
    ld d, 25
.NotASinkingStone:
    GetAttribute ATR_PERIOD_TIMER1_RESET
    inc a
    cp d
    jr nc, jr_000_32a6

.LetObjectFall:
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER1_RESET] += 1
    ld d, a
    srl a
    srl a
    ld c, ATR_Y_POS_DELTA
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = obj[ATR_PERIOD_TIMER1_RESET] / 4
    ld e, a
    bit 5, [hl]
    jr z, jr_000_325a

    GetAttribute ATR_ID
    cp ID_FISH
    jr z, jr_000_32c5
    ld a, d
    cp $06
    ret c
    SetAttribute ATR_09, $01
    ret

jr_000_325a:
    ld a, [TransitionLevelState]
    and $20
    jp nz, ResetObjAndReturn
    GetAttribute ATR_ID
    cp ID_DIAMOND
    ret c                           ; Return for all objects under diamond.
    cp ID_HANGING_MONKEY
    jr c, CheckItemLanding          ; Jump for all objects under hanging monkey.
    cp $af
    ret c
    cp $b3
    ret nc

; $3272
CheckItemLanding:
    GetAttribute ATR_Y_POSITION_LSB
    ld c, Y_POS_LIM_BOT
    rst CpAttr
    ret c                          ; Return if object did not reach its lower Y limit.
    rst GetAttr
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = obj[Y_POS_LIM_BOT]
    SetAttribute ATR_Y_POS_DELTA, 0
    ld a, e
    cp 3
    ld a, 7
    jp z, StopFallAndPlaySound

; $3289: Called when an item does its final landing after bouncing a bit.
.ItemFinalLanding:
    ld c, Y_POS_LIM_BOT
    rst SetAttr                     ; obj[Y_POS_LIM_BOT] = 7
    ld a, EVENT_SOUND_OUT_OF_TIME
    ld [EventSound], a
    res 6, [hl]
    ld a, [TransitionLevelState]
    and %01111111
    ld [TransitionLevelState], a    ; = [TransitionLevelState] & $7f
    ld a, [BossActive]
    or a
    ret z                           ; Return if no boss is active.
    ld a, 128
    ld [ItemDespawnTimer], a        ; = 128
    ret

jr_000_32a6:
    GetAttribute ATR_HITBOX_PTR
    or a
    jr nz, jr_000_32c5

.NoHitBox:
    bit 5, [hl]
    ret z
    DeleteObject
    inc c
    rst GetAttr                     ; a = obj[ATR_STATUS_INDEX]
    ld d, HIGH(ObjectsStatus)
    ld e, a
    ld a, [de]
    or $80
    ld [de], a                      ; Mark object as deleted in ObjectsStatus.
    ld a, [PlayerFreeze]
    or a
    ret z                           ; Return if not in a cut scene.
    push hl
    call SpawnEagle
    pop hl
    ret

jr_000_32c5:
    GetAttribute ATR_ID
    cp ID_FROG
    jr z, FrogLanding               ; Jump if frog.
    cp ID_FISH
    jr nz, jr_000_3330              ; Jump if not fish.

; $32d0
.HandleFishJump:
    GetAttribute ATR_Y_POSITION_LSB
    or a
    jr z, .FishWaterReached
    cp 128
    ret nc                          ; Return if Y LSB position above 128.
    cp 16
    ret c                           ; Return if Y LSB position below 16.
    GetAttribute ATR_FACING_DIRECTION
    ld b, a
    and $0f
    jr z, .FishWaterReached         ; Jump if fish has no facing direction.
    ld a, b
    and $f0
    rst SetAttr                     ; Clear facing direction.
    inc c
    xor a
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = 0
    jp ChangeEnemyDirection         ; Now fish jumps the other way.

; $32ee: Fish landed in water.
.FishWaterReached:
    ld c, ATR_FISH_TIMER
    rst DecrAttr
    ret nz                          ; Set off to new jump once this counter reaches 0.
    ld a, FISH_JUMP_PAUSE_TIME
    rst SetAttr
    dec c
    rst GetAttr                     ; a = obj[ATR_PERIOD_TIMER0_RESET]
    ld c, ATR_PERIOD_TIMER0
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER0] = obj[ATR_PERIOD_TIMER0_RESET]
    GetAttribute ATR_FACING_DIRECTION
    ld b, a
    ld a, 1
    bit 5, b                        ; Check for X flip.
    jr z, .SetXFlipAndFacingDir
    ld a, SPRITE_X_FLIP_MASK | $0f

; $3306
.SetXFlipAndFacingDir:
    rst SetAttr                     ; Set object X flip and facing direction.
    res 1, [hl]                     ; Resetting Bit 1 for the fish puts it in jumping mode.
    SetAttribute2 ATR_Y_POSITION_LSB, 16
    ld c, ATR_FREEZE
    rst SetAttr                     ; obj[ATR_FREEZE] = 16
    ret

; $3312: Checks if the frog is landing after a jump and changes corresponding settings.
FrogLanding:
    GetAttribute ATR_Y_POSITION_LSB
    ld c, Y_POS_LIM_BOT
    rst CpAttr
    ret c                          ; Return if frog not at bottom.
    rst GetAttr
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = obj[Y_POS_LIM_BOT]
    res 0, [hl]
    res 6, [hl]
    SetAttribute ATR_Y_POS_DELTA, 0
    SetAttribute ATR_PERIOD_TIMER0, 2
    inc c
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER1] = 2
    inc a
    inc c
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER1_RESET] = 3
    ret

jr_000_3330:
    bit 5, [hl]
    ret nz
    cp ID_DIAMOND
    ret c                           ; Return for everything below diamond.
    cp ID_HANGING_MONKEY
    jr c, CheckItemFirstLanding     ; Jump for everything below hanging monkey.
    cp $af
    ret c                           ; Return for everything below $af.
    cp $b3
    ret nc                          ; Return for everything above $b3.

; $3340: Called in the transition level when the eagle drops items.
; Called once per item for its first landing.
CheckItemFirstLanding:
    GetAttribute ATR_Y_POSITION_LSB
    ld c, Y_POS_LIM_BOT
    rst CpAttr
    ret c                           ; Return if bottom position is not reached yet.
    rst GetAttr
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = obj[Y_POS_LIM_BOT]
    ld a, 13

; $334d: Sets obj[ATR_PERIOD_TIMER0], zeroes vertical velocity, and plays a sound.
;        Called when a dropped item hits the bottom.
; Input: hl = pointer to object
;        a = value for obj[ATR_PERIOD_TIMER0]
StopFallAndPlaySound:
    ld c, ATR_PERIOD_TIMER0
    rst SetAttr
    SetAttribute ATR_Y_POS_DELTA, 0
    ld a, EVENT_SOUND_OUT_OF_TIME
    ld [EventSound], a
    ret

; $335a
ResetObjAndReturn:
    dec e
    dec e
    ret nz
    SetAttribute ATR_SPRITE_PROPERTIES, 0
    inc c
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = 0
    res 6, [hl]
    ret


; $3366: Copies enemy projectile in "bc" into next free enemy projectile slot.
; Zero flag is set if not slot was found. Returns pointer to copied object in "de".
LoadEnemyProjectileIntoSlot:
    ld de, EnenemyProjectileObjects
    ld a, [de]
    and EMPTY_OBJECT_VALUE
    jr nz, :+                       ; Jump if projectile is empty.

    ld a, e
    add SIZE_PROJECTILE_OBJECT
    ld e, a
    ld a, [de]
    and EMPTY_OBJECT_VALUE
    ret z                           ; Return if projectile is not empty.

 :  push hl
    push de
    ld h, b
    ld l, c
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData
    pop de
    pop hl
    inc a                           ; Increment value of last copied byte. It's always 0.
    ret

; Boss related things are handled in the following.
SECTION "Boss engines", ROM0

; $3382: Input: hl = pointer to boss object.
CheckBossAction:
    bit 5, [hl]
    ret z

    push de
    call Call_000_3c51
    call Call_000_3a21
    pop de
    bit 3, [hl]
    jr nz, jr_000_33a6

    ld c, $0c
    rst DecrAttr
    ret nz

    ld a, d
    rst SetAttr
    inc c
    rst GetAttr
    inc a
    inc c
    rst CpAttr
    dec c
    jr c, jr_000_33a0

    xor a

jr_000_33a0:
    rst SetAttr
    ld d, a
    set 3, [hl]
    jr jr_000_33aa

jr_000_33a6:
    inc c
    inc c
    rst GetAttr
    ld d, a

jr_000_33aa:
    ld a, [JumpTimer]
    or a
    ret nz

    inc a
    ld [JumpTimer], a                   ; = 1
    IsBossAwake
    jp nz, HandleBossAction

    ld a, [NextLevel]
    cp 4
    jr z, CheckBossWakeupBaloo      ; Jump if Level 4: BY THE RIVER (Baloo)
    cp 6
    jp z, CheckBossWakeupMonkeys    ; Jump if Level 6: TREE VILLAGE (Monkeys)
    cp 8
    jp z, CheckBossWakeupKingLouie  ; Jump if Level 8: FALLING RUINS (King Louie)
    cp 10
    jp z, CheckBossWakeupShereKhan  ; Jump if Level 10: THE WASTELANDS (Shere Khan)

CheckBossWakeupKaa:
    GetAttribute ATR_ID
    add d
    ld [NumObjSpriteIndex], a
    ld a, l
    ld [ActionObject], a
    IsObjOnScreen
    ret z
    ld a, [NumDiamondsMissing]
    or a
    ret nz                          ; Return if not all diamonds have been found.
    ld a, [PlayerPositionYMsb]
    or a
    ret nz                          ; Return if player in wrong Y position (MSB).
    ld a, [PlayerPositionXMsb]
    or a
    ret nz                          ; Return if player in wrong X position (MSB).
    ld a, [PlayerPositionXLsb]
    cp $d8
    ret c                           ; Return if player in wrong X position (LSB).
    ld a, $b0
    ld [ScreenLockX], a             ; = $b0
    ld a, $70
    ld [ScreenLockY], a             ; = $70
    ld a, $c0
    ld [LeftLvlBoundingBoxXLsb], a  ; = $c0
    ld a, $40
    ld [LvlBoundingBoxXLsb], a
    ld a, $01
    ld [LvlBoundingBoxXMsb], a
    ld a, $04
    ld d, a
    ld c, $0d
    rst SetAttr
    ld a, $14
    inc c
    rst SetAttr
    call WakeUpBoss
    jp HandleBossAction

; $341a: Check if boss fight with Baloo needs to start.
CheckBossWakeupBaloo:
    ld d, $01
    GetAttribute ATR_12
    or a
    jp z, HandleBalooBoss
    call SetupStatusAndJumpTimer
    ret z
    ld a, [NumDiamondsMissing]
    or a
    ret nz                          ; Return if not all diamonds have been found.
    ld a, [BgScrollYMsb]
    or a
    ret z                           ; Return if player in wrong position in Y direction (MSB).
    ld a, [PlayerPositionYLsb]
    cp $60                          ; Return if player in wrong position in Y direction (LSB).
    ret c
    ld a, [PlayerPositionXMsb]
    cp $0f
    ret nz                          ; Return if player in wrong position in X direction (MSB).
    ld a, [PlayerPositionXLsb]
    cp $90
    ret c                           ; Return if player in wrong position in X direction (LSB).
    ld a, $40
    ld [ScreenLockX], a             ; = $40
    ld a, $50
    ld [LeftLvlBoundingBoxXLsb], a  ; = $50
    ld a, $0f
    ld [LeftLvlBoundingBoxXMsb], a  ; = $4c
    ld a, $bc
    ld [LvlBoundingBoxXLsb], a      ; = $bc -> Lock window scroll right direction.
    xor a
    ld [ScrollOffsetY], a           ; = 0
    ld [ObjYWiggle], a              ; = 0
    ld a, d
    ld c, $0d
    rst SetAttr
    call WakeUpBoss
    ld c, $58
    ld d, $80
    ld e, $a8
    jp SetupBossPlatformsIndicies

; $346e: Check if boss fight with monkeys needs to start.
CheckBossWakeupMonkeys:
    ld d, $08
    GetAttribute ATR_12
    or a
    jp z, HandleMonkeyBoss
    call SetupStatusAndJumpTimer
    ret z
    ld a, [NumDiamondsMissing]
    or a
    ret nz                          ; Return if not all diamonds collected.
    ld a, [PlayerPositionYMsb]
    or a
    ret nz                          ; Return if Y position is wrong.
    ld a, [PlayerPositionXMsb]
    cp $07
    ret c                           ; Return if X position MSB is wrong.
    ld a, [PlayerPositionXLsb]
    cp $40
    ret c                           ; Return if X position LSB is wrong.

    ld a, $80
    ld [WndwBoundingBoxXBossLsb], a ; = $80
    ld a, $90
    ld [LeftLvlBoundingBoxXLsb], a  ; = $90
    ld a, $06
    ld [LeftLvlBoundingBoxXMsb], a  ; = $06
    ld [WndwBoundingBoxXBossMsb], a ; = $06
    call WakeUpBoss
    ld a, $01
    ld d, a
    ld c, $0d
    rst SetAttr
    ld [$c1f2], a
    jp HandleMonkeyBoss

; $34b2: Check if boss fight with King Louie needs to start.
CheckBossWakeupKingLouie:
    ld d, $07
    GetAttribute ATR_12
    or a
    jp z, HandleKingLouie
    call SetupStatusAndJumpTimer
    ret z
    ld a, [NumDiamondsMissing]
    or a
    ret nz                          ; Return if not all diamonds collected.
    ld a, [PlayerPositionYMsb]
    or a
    ret nz                          ; Return if player in wrong Y direction (MSB).
    ld a, [PlayerPositionXMsb]
    cp $03
    ret c                           ; Return if player in wrong X direction (MSB).
    ld a, [PlayerPositionXLsb]
    cp $90
    ret c                           ; Return if player in wrong X direction (LSB).
    ld a, $60
    ld [WndwBoundingBoxXBossLsb], a ; = $60 -> Locks screen in left X diretion (LSB).
    ld a, $70
    ld [LeftLvlBoundingBoxXLsb], a  ; = $70
    ld a, $c0
    ld [LvlBoundingBoxXLsb], a      ; = $c0 -> Locks screen in right X diretion (LSB).
    ld a, $03
    ld [LeftLvlBoundingBoxXMsb], a  ; = $03
    ld [LvlBoundingBoxXMsb], a      ; = $03 -> Locks screen in right X diretion (MSB).
    ld [WndwBoundingBoxXBossMsb], a ; = $03 -> Locks screen in left X diretion (MSB).
    call WakeUpBoss
    jp HandleKingLouie

; $34f5: Check if boss fight with Shere Khan needs to start.
CheckBossWakeupShereKhan:
    ld d, $07
    GetAttribute ATR_12
    or a
    jp z, HandleShereKhan
    call SetupStatusAndJumpTimer
    ret z
    ld a, [NumDiamondsMissing]
    or a
    ret nz                          ; Return if not all diamonds have been found.
    ld a, [PlayerPositionYMsb]
    cp $03
    ret nz                          ; Return if wrong Y position (MSB).
    ld a, [PlayerPositionXMsb]
    cp $07
    ret nz                          ; Return if wrong X position (MSB).
    ld a, [PlayerPositionXLsb]
    cp $90
    ret c                           ; Return if wrong X position (LSB).
; If this point is reached, all boss fight conditions are met.
    ld a, $88
    ld [ScreenLockY], a
    ld a, $30
    ld [WndwBoundingBoxXBossLsb], a ; = $30  -> Locks window scroll to the left side (LSB).
    ld a, $40
    ld [LeftLvlBoundingBoxXLsb], a  ; = $40
    ld a, $bc
    ld [LvlBoundingBoxXLsb], a      ; = $bc   -> Locks window scroll to the right side (LSB)
    ld a, $07
    ld [LeftLvlBoundingBoxXMsb], a  ; = $07
    ld [LvlBoundingBoxXMsb], a      ; = $07  -> Locks window scroll to the right side (MSB).
    ld [WndwBoundingBoxXBossMsb], a ; = $07  -> Locks window scroll to the left side (MSB).
    call WakeUpBoss
    push de
    push hl
    ld c, $40
    ld d, $70
    ld e, $a0
    call SetupBossPlatformsIndicies
    pop hl
    pop de
    jp HandleShereKhan

; $354b:
SetupStatusAndJumpTimer:
    xor a
    ld [JumpTimer], a                   ; = 0
    res 3, [hl]
    IsObjOnScreen
    ret

; $3554
HandleBossAction:
    ld a, [NextLevel]
    cp 4
    jp z, HandleBalooBoss           ; Jump if Level 4: BY THE RIVER
    cp 6
    jp z, HandleMonkeyBoss          ; Jump if Level 6: TREE VILLAGE
    cp 8
    jp z, HandleKingLouie           ; Jump if Level 8: FALLING RUINS
    cp 10
    jp z, HandleShereKhan           ; Jump if Level 10: THE WASTELANDS

HandleKaa:
    ld a, d
    or a
    jr nz, jr_000_35a5

    ObjMarkedSafeDelete
    jp nz, BossMarkedForSafeDelete  ; Jump if object is marked for safe delete,

    ld c, $13
    rst GetAttr                     ; a = obj[$13]
    inc a
    and $0f
    rst SetAttr
    ld c, a
    push hl
    ld hl, KaaPtrData
    add hl, bc
    ld a, [hl]
    add a
    add a                           ; a = a * 4
    ld c, a
    ld hl, KaaData
    add hl, bc                      ; hl = [$66b5 + a * 4]
    ld d, [hl]                      ; d = Y LSB position
    inc hl
    ld e, [hl]                      ; e = X LSB position
    inc hl
    ld b, [hl]
    inc hl
    ld c, [hl]
    pop hl
    push bc
    ld c, ATR_Y_POSITION_LSB
    ld a, d
    rst SetAttr
    ld c, ATR_X_POSITION_LSB
    ld a, e
    rst SetAttr
    pop de
    ld c, $07
    ld a, d
    rst SetAttr
    ld c, $14
    ld a, e
    rst SetAttr
    ld d, $00

jr_000_35a5:
    ld a, d
    add a
    ld c, $14
    rst AddToAttr
    ld de, KaaDataTODO3
    add e
    jr nc, jr_000_35b1

    inc d

jr_000_35b1:
    ld e, a
    ld a, [de]
    ld [NumObjSpriteIndex], a
    push af
    inc de
    ld a, [de]
    ld c, $0c
    rst SetAttr
    ld a, l
    ld [ActionObject], a
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

    ld c, ATR_SPRITE_PROPERTIES
    rst GetAttr
    and SPRITE_Y_FLIP_MASK
    jr z, jr_000_35e8

    ld b, $03

jr_000_35e8:
    ld a, e
    add b
    ld c, ATR_HITBOX_PTR
    rst SetAttr
    ld a, d
    cp $43
    jr z, jr_000_35f5

    cp $46
    ret nz

jr_000_35f5:
    ld bc, FireProjectileData
    call LoadEnemyProjectileIntoSlot
    ret z

    inc e
    push hl
    ld c, $07
    rst GetAttr
    ld c, a
    inc l
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
    ld c, 16
    jp SetPlayerPositionAsTarget

; $3625
HandleBalooBoss:
    ObjMarkedSafeDelete
    jr z, jr_000_3658

    xor a
    ld [JumpTimer], a                   ; = 0
    jp BossMarkedForSafeDelete


jr_000_3630:
    ld c, $13
    rst GetAttr
    inc a
    cp 35
    jr c, .SkipCarry
    xor a
.SkipCarry:
    rst SetAttr
    ld c, a
    push hl
    ld hl, BalooActionData
    add hl, bc
    ld a, [hl]
    ld e, a
    and $f0
    swap a
    ld [BossAction], a
    ld a, e
    and $0f
    ld c, a
    ld hl, BalooDataTODO
    add hl, bc
    ld a, [hl]
    pop hl
    ld c, $14
    rst SetAttr
    jr jr_000_366f

jr_000_3658:
    bit 1, [hl]
    jr nz, Jump_000_36bf

    ld a, d
    or a
    jr z, jr_000_3630

Call_000_3660:
    cp $02
    jr nz, jr_000_366f

    ld c, $14
    rst GetAttr
    or a
    jr z, jr_000_366f

    ld a, $11
    ld [$c1f1], a

jr_000_366f:
    ld a, d
    add a
    add a
    ld c, $14
    rst AddToAttr
    ld de, BalooDataTODO3
    add e
    jr nc, Jump_000_367c

    inc d

Jump_000_367c:
    ld e, a
    ld a, [de]
    ld [NumObjSpriteIndex], a
    inc de
    ld a, [de]
    ld c, $0c
    rst SetAttr
    ld a, l
    ld [ActionObject], a
    inc de
    ld a, [BossAnimation1]
    inc a
    jr nz, jr_000_369e
    rst GetAttr
    cp $05
    jr c, jr_000_36a2
    srl a
    jr nz, jr_000_369b
    inc a
jr_000_369b:
    rst SetAttr
    jr jr_000_36a2
jr_000_369e:
    ld a, [de]
    ld [BossAnimation1], a
jr_000_36a2:
    inc de
    ld a, [BossAnimation2]
    inc a
    jr nz, jr_000_36b6
    rst GetAttr
    cp $05
    jr c, jr_000_36ba
    srl a
    jr nz, jr_000_36b3
    inc a
jr_000_36b3:
    rst SetAttr
    jr jr_000_36ba
jr_000_36b6:
    ld a, [de]
    ld [BossAnimation2], a
jr_000_36ba:
    set 0, [hl]
    set 1, [hl]
    ret

; $36bf: This is related to bosses.
Jump_000_36bf:
    bit 0, [hl]
    ret nz
    GetAttribute ATR_STATUS_INDEX
    push hl
    inc a
    ld d, HIGH(ObjectsStatus)
    ld e, a                         ; de now points to the correct object in ObjectsStatus
    ld a, [BossAnimation1]
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
    ld h, HIGH(GeneralObjects)
    ld l, a
    push hl
    bit 3, [hl]
    jr nz, jr_000_3722
    ld a, [BossAnimation1]
    ld c, $16
    rst CpAttr
    jr z, jr_000_36f6
    ld [NumObjSpriteIndex], a
    ld a, l
    ld [ActionObject], a
    jr jr_000_3720

jr_000_36f6:
    ld a, [BossAnimation2]
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
    ld h, HIGH(GeneralObjects)
    ld l, a
    bit 3, [hl]
    jr nz, jr_000_3722

    ld a, [BossAnimation2]
    ld c, $16
    rst CpAttr
    jr z, jr_000_3725

    ld [NumObjSpriteIndex], a
    ld a, l
    ld [ActionObject], a
jr_000_3720:
    set 3, [hl]
jr_000_3722:
    pop hl
    pop hl
    ret


jr_000_3725:
    call Call_000_3a02
    ld a, l
    ld [BossObjectIndex2], a

jr_000_372c:
    pop hl
    call Call_000_3a02
    ld a, l
    ld [BossObjectIndex1], a

jr_000_3734:
    pop hl
    ld a, l
    ld [$c1ec], a
    res 1, [hl]
    res 3, [hl]
    xor a
    ld [JumpTimer], a                   ; = 0
    jp Call_000_3a02

; $3744
HandleMonkeyBoss:
    ObjMarkedSafeDelete
    jr z, jr_000_37aa

    xor a
    ld [JumpTimer], a                   ; = 0
    jp BossMarkedForSafeDelete


jr_000_374f:
    ld a, [$c1f3]
    or a
    ret nz

    ld c, $13
    rst GetAttr
    inc a
    cp 37
    jr c, .SkipCarry
    xor a
.SkipCarry:
    rst SetAttr
    ld c, a
    push hl
    ld hl, MonkeyBossData
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

    ld a, [BossAnimation2]
    inc a
    jr nz, jr_000_3785

    inc c

jr_000_3785:
    ld a, [BossAnimation1]
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
    ld hl, MonkeyBossDataTODO
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    pop hl
    ld c, $0e
    rst SetAttr
    ld a, e
    ld c, $14
    rst SetAttr
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
    rst GetAttr
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
    rst AddToAttr
    cp $28
    jr c, jr_000_37e0

    cp $64
    jr c, jr_000_37ef

jr_000_37e0:
    inc a
    ld [BossMonkeyState], a
    dec a

jr_000_37e5:
    ld de, MonkeyBossDataTODO3
    add e
    jr nc, jr_000_37ec

    inc d

jr_000_37ec:
    jp Jump_000_367c


jr_000_37ef:
    push af
    ld e, a
    xor a
    ld [BossMonkeyState], a         ; = 0
    ld a, d
    cp $03
    jr nz, jr_000_3811

    push hl
    ld a, e
    cp $50
    jr nc, jr_000_380d

    ld a, [BossObjectIndex1]
    ld l, a
    ld a, e
    cp $3c
    jr nc, jr_000_380d

    ld a, [BossObjectIndex2]
    ld l, a

jr_000_380d:
    call ShootEnemyProjectile
    pop hl

jr_000_3811:
    pop af
    jr jr_000_37e5

; $3814
HandleKingLouie:
    ObjMarkedSafeDelete
    jr z, Jump_000_3843

    xor a
    ld [JumpTimer], a                   ; = 0
    jp BossMarkedForSafeDelete


jr_000_381f:
    ld c, $13
    rst GetAttr
    inc a
    cp 32
    jr c, .SkipCarry
    xor a
.SkipCarry:
    rst SetAttr
    ld c, a
    push hl
    ld hl, KingLouieData
    add hl, bc
    ld a, [hl]
    add a
    ld c, a
    ld hl, KingLouieDataTODO
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    pop hl
    ld c, $0e
    rst SetAttr
    ld a, e
    ld c, $14
    rst SetAttr
    jr jr_000_384c

Jump_000_3843:
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
    rst AddToAttr
    cp $20
    jr c, jr_000_385c

    cp $3c
    jr c, jr_000_3866

    jr jr_000_3874

jr_000_385c:
    ld de, KingLouieDataTODO3
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
    call SpawnArmadillo
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
    ld a, 6
    ld [BgScrollYWiggle], a         ; = 6
    push hl
    call KingLouieItemSpawn
    pop hl

jr_000_3890:
    pop af
    jr jr_000_385c

; $3893
HandleShereKhan:
    ObjMarkedSafeDelete
    jr z, jr_000_38cd               ; Jump if boss not marked for safe delete.
    xor a
    ld [JumpTimer], a               ; = 0
    jp BossMarkedForSafeDelete

jr_000_389e:
    ld c, ATR_13
    rst GetAttr
    inc a
    cp 30
    jr c, .SkipReset
    xor a                           ; Reset every 31 calls.
.SkipReset:
    rst SetAttr                     ; obj[ATR_13] = (obj[ATR_13] + 1) or 0
    ld c, a
    push hl
    ld hl, ShereKhanActionData
    add hl, bc
    ld a, [hl]
    ld e, a
    and $f0
    swap a
    ld [BossAction], a              ; Upper nibble determines BossAction.
    ld a, e
    and $0f
    add a
    ld c, a
    ld hl, ShereKhanDataTODO2
    add hl, bc
    ld a, [hl+]
    ld e, a
    ld a, [hl]
    pop hl
    ld c, ATR_PERIOD_TIMER1_RESET
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER1_RESET] = ...
    ld a, e
    ld c, ATR_14                    ; obj[ATR_14] = ...
    rst SetAttr
    jr jr_000_38d6

jr_000_38cd:
    bit 1, [hl]
    jp nz, Jump_000_36bf
    ld a, d
    or a
    jr z, jr_000_389e

jr_000_38d6:
    ld a, d
    add a
    add a
    ld c, ATR_14
    rst AddToAttr
    cp $3c
    jr c, jr_000_38ec

    jr jr_000_38fa

Jump_000_38e2:
    ld de, ShereKhanDataTODO3
    add e
    jr nc, .SkipCarry
    inc d
.SkipCarry:
    jp Jump_000_367c


jr_000_38ec:
    push af
    ld a, d
    cp 6
    jr nz, jr_000_38f7

    push hl
    call ShereKhanPlatformAction
    pop hl

jr_000_38f7:
    pop af
    jr Jump_000_38e2

jr_000_38fa:
    push af
    ld a, d
    cp 5
    jr nz, jr_000_38f7

    push hl
    call SpawnHorizontalFlame
    pop hl
    jr jr_000_38f7

; $3907
SpawnHorizontalFlame:
    ld bc, ShotProjectileData
    call LoadEnemyProjectileIntoSlot
    ret z                           ; Return if no slot was found.
    ld h, d
    ld l, e
    ld a, 176
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = 176
    ld a, 3
    inc c
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = 3
    inc c
    ld a, 188
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] = 188
    inc c
    ld a, 7
    rst SetAttr                     ; obj[ATR_X_POSITION_MSB] = 7
    ld a, ID_FIRE_PROJECTILE
    ld c, ATR_ID
    rst SetAttr                     ; obj[ATR_ID] = ID_FIRE_PROJECTILE
    ld a, [PlayerPositionXLsb]
    cp 128
    jr nc, :+
    ld a, $0d
    ld c, $07
    rst SetAttr
 :  ld a, e
    add $10
    ld e, a                         ; de = pointer to object + $10
    push hl
    ld c, 32
    jp SetPlayerPositionAsTarget


; $393c: Sets zero flag if no empty object slot was found. Else returns free slot in "hl".
GetEmptyObjectSlot:
    ld hl, GeneralObjects
    ld b, NUM_GENERAL_OBJECTS
.Loop:
    IsObjEmpty
    ret nz
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    dec b
    jr nz, .Loop
    ret

; $394c: Armadillos spawned by King Louie.
SpawnArmadillo:
    call GetEmptyObjectSlot
    ret z
    ld d, h
    ld e, l
    push de                         ; de = empty object slot
    ld hl, ArmadilloObjectData
    ld c, ATR_ID
    rst GetAttr
    push af
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData                    ; Copy data from ArmadilloObjectData to empty object slot.
    ld hl, ActiveObjectsIds
    ld b, MAX_ACTIVE_OBJECTS
    ld c, 0

.Loop:
    ld a, [hl]
    or a
    jr z, .FreeSlotFound
    inc l
    inc c
    dec b
    jr nz, .Loop

.NoFreeSlotFound:
    pop af
    pop hl
    DeleteObject
    ret

.FreeSlotFound:
    pop af
    ld [hl], a                      ; = Armadillo ID.
    pop hl
    ld a, c
    add a
    ld c, ATR_OBJECT_DATA
    rst SetAttr
    ret

; $397c: Called when King Louie spawns an item or a coconut.
KingLouieItemSpawn:
    GetAttribute ATR_13
    ld c, 0
    cp $09
    jr z, .Skip
    inc c                           ; c = 1
    cp $10
    jr z, .Skip
    inc c                           ; c = 2
    cp $11
    jr z, .Skip
    inc c                           ; c = 3
    cp $16
    jr z, .Skip
    inc c                           ; c = 4
    cp $17
    jr z, .Skip
    inc c                           ; c = 5
    cp $1c
    jr z, .Skip
    inc c                           ; c = 6
    cp $1d
    ret nz

    ld a, [BonusLevel]
    or a
    jr nz, .Skip                    ; Jump if bonus level already collected.
    inc c                           ; c = 7
.Skip:
    ld hl, KingLouieItems
    add hl, bc
    add hl, bc
    ld a, [hl+]                     ; This is the ID.
    ld d, $03
    ld e, [hl]
    or a
    jr nz, .SpawnItem               ; Non-zero: Spawn an item. Else spawn falling balls.

.SpawnCoconut:
    push de
    ld bc, BallProjectileData
    call LoadEnemyProjectileIntoSlot
    ld h, d
    ld l, e
    pop de
    ret z                           ; Return if no slot was found.
    ld [hl], $02
    ld a, [BgScrollYLsb]
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = [BgScrollYLsb]
    ld c, ATR_X_POSITION_LSB
    ld a, e
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] = ...
    inc c
    ld a, d
    rst SetAttr                     ; obj[ATR_X_POSITION_MSB] = ...
    inc c
    ld a, ID_KING_LOUIE_COCONUT
    rst SetAttr                     ; obj[ATR_ID] = ID_KING_LOUIE_COCONUT
    ld a, $03
    ld c, $08
    rst SetAttr
    ret

.SpawnItem:
    push af
    push de
    call GetEmptyObjectSlot
    jr nz, .SlotFound               ; Jump if a slot was found.
    pop de                          ; Else pop and return.
    pop af
    ret

.SlotFound:
    ld d, h
    ld e, l
    ld hl, DiamondObjectData
    ld bc, SIZE_GENERAL_OBJECT - 8
    push de
    rst CopyData
    pop hl
    pop de
    ld c, ATR_X_POSITION_LSB
    ld a, e
    rst SetAttr
    inc c
    ld a, d
    rst SetAttr
    pop af
    ld c, ATR_ID                    ; Change ATR_ID!
    rst SetAttr
    SetAttribute2 X_POS_LIM_RIGHT, $a0
    SafeDeleteObject
    ret

Call_000_3a02:
    ld c, ATR_PLATFORM_INCOMING_BLINK
    rst GetAttr
    ld d, a
    GetAttribute ATR_06
    and %1
    or d
    rst SetAttr                     ; Sets ATR_06.
    GetAttribute ATR_16
    ld c, ATR_12
    rst SetAttr
    ret

; $3a14
BossMarkedForSafeDelete:
    ld a, [BossDefeatBlinkTimer]
    or a
    ret nz                          ; Return if boss was defeated and is blinking.
    push hl
    call SpawnEagle
    pop hl
    jp ResetVariables

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
    cp 4
    jr z, .Level4

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

.Level4:
    ld a, [$c1f3]
    or a
    ret z

    inc a
    cp $11
    jr c, jr_000_3a68

    call BalooPlatformAction
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
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
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
    rst SetAttr
    ld a, [BossAnimation1]
    or a
    ret z

    inc a
    ret z

    push hl
    ld a, [BossObjectIndex1]
    ld l, a
    ld a, e
    rst SetAttr
    pop hl
    ld a, [BossAnimation2]
    or a
    ret z

    inc a
    ret z

    push hl
    ld a, [BossObjectIndex2]
    ld l, a
    ld a, e
    rst SetAttr
    pop hl
    ret

; $3aa7: Sinks or raises stones during the boss fight with Baloo. Additionally spawns turtles and crocodiles.
BalooPlatformAction:
    ld a, 6
    ld [BgScrollYWiggle], a         ; = 6
    xor a                           ; a = 0
    ObjMarkedSafeDelete
    jr nz, .SkipBossAction
    ld a, [BossAction]
 .SkipBossAction:
    push hl
    ld e, a                         ; e = 0 or BossAction
    add a
    add e                           ; a = (0 or BossAction) * 3
    ld de, BalooPlatformData
    add e
    jr nc, .SkipCarry
    inc d
.SkipCarry:
    ld e, a
    ld c, $13
    rst GetAttr                     ; a = obj[$13]
    push af
    ld a, [BossPlatformIndex0]
    ld l, a
    ld c, ATR_Y_POS_DELTA
    ld a, [de]
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = [BalooPlatformData + offset]
    inc de
    ld a, [BossPlatformIndex1]
    ld l, a
    ld a, [de]
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = [BalooPlatformData + offset + 1]
    inc de
    ld a, [BossPlatformIndex2]
    ld l, a
    ld a, [de]
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = [BalooPlatformData + offset + 2]
    ld a, [$c1f7]
    ld l, a
    ld d, h
    ld e, a
    pop af
    cp $0b
    jr nz, .Continue1
.SpawnTurtle:
    ld hl, TurtleObjectData
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData
    jr .End
.Continue1:
    cp $1c
    jr nz, .Continue2
.SpawnCrocodile:
    ld hl, CrocodileObjectData
    call SpawnObject
    jr .End
.Continue2:
    cp $1d
    jr nz, .Continue3
    ld a, $0f                       ; Object faces left.
    ld c, ATR_FACING_DIRECTION
    rst SetAttr
    SetAttribute ATR_09, $02
    xor a
    ld c, $0c
    rst SetAttr
    jr .End
.Continue3:
    cp $1f
    jr z, .Continue4
    cp $20
    jr nz, .End
.Continue4:
    xor a
    ld c, $0d
    rst SetAttr
    inc a
    dec c
    rst SetAttr
.End:
    pop hl
    ret

; 3b1f: Called when Shere Khan lets the platforms fall/spawn or when he invokes lightning/fire balls.
; Also plays an explosion sound.
ShereKhanPlatformAction:
    ld a, 6
    ld [BgScrollYWiggle], a          ; = 6
    ld a, EVENT_SOUND_EXPLOSION
    ld [EventSound], a
    ld a, [BossAction]
    or a
    ret z                           ; Just an explosion but no action.
    ld de, 0                        ; de = 0 lets a platform fall.
    cp 1
    jr z, .RightPlatform            ; Drop right platform.
    cp 2
    jr z, .MiddlePlatform           ; Drop middle platform.
    cp 3
    jr nz, .Continue1

.SpawnMiddlePlatform:
    ld de, (248 << 8) | 96          ; Y | X (positions)
    jr .MiddlePlatform

.Continue1:
    cp 4
    jr nz, .Continue2

.SpawnRightPlatform:
    ld de, (232 << 8) | 144         ; Y | X (positions)
    jr .RightPlatform

.Continue2:
    cp 5
    jr z, .LeftPlatform             ; Drop left platform.
    cp 6
    jr nz, .Continue3

.SpawnMiddlePlatformHigh:
    ld de, (216 << 8) | 96          ; Y | X (positions)
    jr .LeftPlatform

.Continue3:
    cp 7
    jr nz, .Continue4
    ld de, (248 << 8) | 160         ; Y | X (positions)
    jr .RightPlatform

.Continue4:
    cp 8
    jr nz, .Continue5
    ld de, (216 << 8) | 64          ; Y | X (positions)
    call .LeftPlatform
    ld de, (232 << 8) | 112         ; Y | X (positions)
    jr .MiddlePlatform

.LeftPlatform:
    ld a, [BossPlatformIndex0]
    jr .DropOrSpawnPlatform

.MiddlePlatform:
    ld a, [BossPlatformIndex1]
    jr .DropOrSpawnPlatform

.RightPlatform:
    ld a, [BossPlatformIndex2]

.DropOrSpawnPlatform:
    ld l, a
    ld a, d
    or e
    jr z, .LetPlatformFall

.SpawnPlatform:
    ld [hl], $20
    ld c, ATR_Y_POSITION_LSB
    ld a, d
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = d
    inc c
    ld a, 3
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = 3
    inc c
    ld a, e
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] = e
    inc c
    ld a, 7
    rst SetAttr                     ; obj[ATR_X_POSITION_MSB] = 7
    ld c, ATR_Y_POS_DELTA
    xor a
    rst SetAttr                     ; obj[ATR_Y_POS_DELTA] = 0
    inc c
    ld a, $02
    rst SetAttr
    ld c, $0e
    xor a
    rst SetAttr
    ld c, $15
    ld a, $10
    rst SetAttr
    ret

.LetPlatformFall:
    ld c, ATR_FALLING_TIMER
    ld a, 20
    rst SetAttr
    ret

.Continue5:
    cp 13
    jr nc, .SpawnFlames

; 9 = lightning left
; 10 = lighnting middle
; 11 = lighnting middle-left
; 12 = lightning right
.SpawnLighnting:
    sub 9
    ld b, 0
    ld c, a                         ; c = [1..4]
    ld a, [$c1f7]
    ld d, h
    ld e, a
    ld hl, ShereKhanLightningPositions
    add hl, bc
    ld a, [hl]                      ; Get position of the correspondig lightning.
    push af
    ld hl, LightningObjectData
    call SpawnObject
    pop af
    ld c, ATR_X_POSITION_LSB        ; Set X position of the lightning.
    rst SetAttr
    ret

.SpawnFlames:
    sub 13
    ld b, $00
    add a
    add a
    add a                           ; a = a * 8
    ld c, a
    ld hl, ShereKhanFlameData
    add hl, bc
    ld d, h
    ld e, l
    call SpawnShereKhanFlame

; $3bdb: Spawns a jumping Shere Khan flame.
; Input: hl = pointer to flame data
SpawnShereKhanFlame:
    push de
    ld bc, BallProjectileData
    call LoadEnemyProjectileIntoSlot
    ld h, d
    ld l, e
    pop de
    ret z                           ; Return if no slot was found for the projectile.
    ld [hl], %10
    ld a, [de]
    inc de
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr
    ld a, 3
    inc c
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = 3
    inc c
    ld a, [de]
    inc de
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] = ...
    inc c
    ld a, 7
    rst SetAttr                     ; obj[ATR_X_POSITION_MSB] = 7
    ld a, ID_FIRE_PROJECTILE
    ld c, ATR_ID
    rst SetAttr                     ; obj[ID_FIRE_PROJECTILE] = ID_FIRE_PROJECTILE
    ld a, [de]
    inc de
    ld c, ATR_FACING_DIRECTION
    rst SetAttr                     ; obj[ATR_FACING_DIRECTION]
    ld a, [de]
    inc de
    ld c, $0c
    rst SetAttr
    ret

; $3c09: Input: pointer to static data in "hl".
SpawnObject:
    push de
    GetAttribute ATR_ID
    push af
    ld bc, SIZE_GENERAL_OBJECT - 8
    rst CopyData
    ld hl, ActiveObjectsIds
    ld a, [$c1f8]
    ld c, a
    add l
    ld l, a                         ; hl = ActiveObjectsIds + [$c1f8]
    pop af                          ; a = obj[ATR_ID]
    ld [hl], a                      ; [ActiveObjectsIds + [$c1f8]] = obj[ATR_ID]
    pop hl
    ld a, c
    add a
    ld c, ATR_OBJECT_DATA
    rst SetAttr                     ; obj[ATR_OBJECT_DATA] = [$c1f8] * 2
    ret

; $3c24: Sets up indicies for platforms/stones for Shere Khan/Baloo.
; Input: c = X position LSB of first platform
;        d = X position LSB of second platform
SetupBossPlatformsIndicies:
    push hl
    ld hl, GeneralObjects
    ld b, NUM_GENERAL_OBJECTS

.Loop:
    push bc
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    pop bc
    cp c
    jr nz, .NextObject1

    ld a, l
    ld [BossPlatformIndex0], a
    jr .End

.NextObject1:
    cp d
    jr nz, .NextObject2
    ld a, l
    ld [BossPlatformIndex1], a
    jr .End

.NextObject2:
    cp e
    jr nz, .End
    ld a, l
    ld [BossPlatformIndex2], a

.End:
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    dec b
    jr nz, .Loop
    pop hl
    ret

Call_000_3c51:
    ld a, [BossDefeatBlinkTimer]
    or a
    ret z                           ; Return if boss not in defeated blinking state.
    dec a
    ld [BossDefeatBlinkTimer], a    ; Decrement BossDefeatBlinkTimer.
    and %111                        ; Mod 8
    ret nz
    call TurnObjectWhite            ; Called every 8 ticks of BossDefeatBlinkTimer

Call_000_3c60:
    ld a, [BossAnimation1]
    or a
    jr z, jr_000_3c78

    inc a
    jr z, jr_000_3c78

    push hl
    ld a, [BossObjectIndex1]
    cp l
    jr nz, jr_000_3c73

    ld a, [$c1ec]

jr_000_3c73:
    ld l, a
    call TurnObjectWhite
    pop hl

jr_000_3c78:
    ld a, [BossAnimation2]
    or a
    ret z

    inc a
    ret z

    push hl
    ld a, [BossObjectIndex2]
    cp l
    jr nz, jr_000_3c89

    ld a, [$c1ec]

jr_000_3c89:
    ld l, a
    call TurnObjectWhite
    pop hl
    ret

; $3c8f: Turns an object white by setting the corresponding attribute and adding 2 to the whiteout timer.
TurnObjectWhite:
    ld c, ATR_SPRITE_PROPERTIES
    rst GetAttr
    or SPRITE_WHITE_MASK
    rst SetAttr                     ; Activate blink.
    ld a, [WhiteOutTimer]
    add 2
    ld [WhiteOutTimer], a           ; [WhiteOutTimer] += 2
    ret

; $3c9e Loops over all objects and performs action for object with ID_BOSS.
; This function is only called once when a boss is woken up.
WakeUpBoss:
    set 2, [hl]                     ; Setting Bit 2 wakes up the boss.
    push hl
    ld hl, GeneralObjects + ATR_ID
    ld b, NUM_GENERAL_OBJECTS
.Loop:
    ld a, [hl]
    cp ID_BOSS
    jr z, .BossFound
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    dec b
    jr nz, .Loop
    pop hl
    ret

.BossFound:
    ld a, l
    sub $05                         ; Now hl points to the base of the object.
    ld l, a
    push de
    call ObjectDestructor
    ld a, l
    ld [$c1f7], a
    ld a, b
    ld [$c1f8], a
    pop de
    pop hl
    ld a, 64
    ld [BossSongCounter], a         ; Play the boss music after ~1s.
    ld a, $ff
    ld [BossActive], a              ; = $ff (turns boss active)
    ld a, SONG_0b
    jr LoadCurrentSong

; $3cd4; Plays the boss music once [BossSongCounter] reaches 0. Except for King Louie.
PlayBossMusic:
    ld a, [BossSongCounter]
    or a
    ret z
    dec a
    ld [BossSongCounter], a
    ret nz
    ld a, [NextLevel]
    cp 8
    ld a, SONG_09
    jr nz, LoadCurrentSong          ; Level 8 boss uses "I wanna be like you".
    ld a, SONG_08                   ; The rest plays the boss music.

; $3ce9
LoadCurrentSong:
    ld [CurrentSong], a
    ld [CurrentSong2], a
    ret

; $3cf0: Prepares sprite transfer for general objects, player projectile objects, and enemy projectiles.
PrepOamTransferAllObjects:
    ld bc, (NUM_GENERAL_OBJECTS << 8) | SIZE_GENERAL_OBJECT
    ld hl, GeneralObjects
    ld de, ObjectSpritesOam
    call PrepOamTransferGivenObjects
    ret nc

    ld hl, ProjectileObjects
    ld b, NUM_PROJECTILE_OBJECTS
    call PrepOamTransferGivenObjects
    ret nc

    ld hl, EnenemyProjectileObjects
    ld b, NUM_ENEMY_PROJECTILE_OBJECTS
    call PrepOamTransferGivenObjects
    ret nc

    ld a, $a0
    sub e
    ret z

    ret c

    ld b, a
    ld h, d
    ld l, e

; $3d17: Set everything from [hl] to [hl + b -1] to zero.
MemsetZero2::
    xor a
 :  ld [hl+], a
    dec b
    jr nz, :-
    ret

; $3d1d: Input: hl = start pointer to objects, b = number of objects, c = size per object
PrepOamTransferGivenObjects:
    push bc
    IsObjEmpty
    jr nz, .NextObject              ; Skip empty objects.

    push hl
    call PrepObjectOamTransfer
    pop hl
    jr c, .NextObject

    res 4, [hl]                     ; Object is not on screen.

.NextObject:
    pop bc
    ld a, l
    add c                           ; = add size of object to pointer
    ld l, a                         ; hl = hl + size of object
    ld a, e
    cp $a0
    ret nc
    dec b                           ; Decrement number of objects to handle.
    jr nz, PrepOamTransferGivenObjects ; Handle next object if there is one.
    scf
    ret

; $3d38: Related to loading the sprites of an object into the RAM. These attributes are later transferred to the OAM.
; Input: hl = pointer to object
PrepObjectOamTransfer:
    set 4, [hl]                     ; Setting Bit 4 means that an object is on screen.
    GetAttribute ATR_HEALTH
    inc a
    ld a, [BgScrollYOffset]
    ld c, a
    jr z, .NoWiggle                 ; Jump if object is a boss (a was $ff).
    bit 5, [hl]
    jr z, .NoWiggle
    bit 1, [hl]
    jr z, .NoWiggle
    ld a, [ObjYWiggle]
    add c
.NoWiggle:
    ld [SpritesYOffset], a          ; [SpritesYOffset] = [BgScrollYOffset] (+ wiggle)
    push de
    GetAttribute ATR_Y_POSITION_LSB
    ld e, a                         ; e = y position lsb
    inc c
    rst GetAttr
    ld d, a                         ; d = y position msb
    push de                         ; Save y position on stack.
    inc c
    rst GetAttr
    ld e, a                         ; e = x position lsb
    inc c
    rst GetAttr
    ld d, a                         ; e = x position msb
    push de                         ; Save x position on stack.
    GetAttribute ATR_ID
    ld e, a                         ; e = object type
    GetAttribute ATR_06
    ld b, a                         ; b = obj[ATR_06]
    and %1
    ld d, a                         ; d = obj[ATR_06] & 1
    push de                         ; Save obj[ATR_06] & 1 and obj[ATR_ID]
    ld a, b
    and %11111110
    ld [SpriteVramIndex], a         ; [SpriteVramIndex] = obj[ATR_06] & %11111110
    ld d, a                         ; d = [SpriteVramIndex]
    inc c                           ; c = $07
    rst GetAttr
    bit 7, a                        ; Check if sprite is invisible.
    jr nz, SpriteInvisible

    ld b, a
    and $f0
    ld [SpriteFlags], a             ; Set up sprite flags.
    and SPRITE_WHITE_MASK
    jr z, .Continue                 ; Jump if sprite is normal.

    ld a, [WhiteOutTimer]
    or a
    jr z, .DefaultColor

    dec a
    ld [WhiteOutTimer], a           ; [WhiteOutTimer] -= 1
    jr nz, .Continue

.DefaultColor:
    ld a, b
    and ~SPRITE_WHITE_MASK
    rst SetAttr                     ; Use object's default color.

.Continue:
    ld a, d                         ; a = [SpriteVramIndex]
    cp $90
    jr nc, jr_000_3da5

jr_000_3d9b:
    GetAttribute ATR_PROJECTILE_12
    pop bc                          ; bc = obj[ATR_06] & 1 and obj[ATR_ID]
    jr jr_000_3dae

SpriteInvisible:
    pop de
    pop de
    jr NoOamTransferNeeded2

jr_000_3da5:
    bit 2, [hl]
    jr nz, jr_000_3d9b

    GetAttribute $0d
    pop bc                          ; bc = obj[ATR_06] & 1 and obj[ATR_ID]
    add c

jr_000_3dae:
    ld c, a                         ; c = obj[$12] or obj[ATR_ID] + a
    ld a, h                         ; Get high byte of object pointer.
    cp HIGH(GeneralObjects)
    jr nz, .SetUpXStartPos          ; Jump if object is a projectile.

    ld a, [NextLevel]
    cp 3
    jr nz, .SetUpXStartPos          ; Jump if not Level 3.

    ld a, [hl]
    and $27
    cp $26
    jr nz, .SetUpXStartPos

; Maybe the following is related to the dawn patrol.
    ld a, [$c129]
    ld e, a
    ld a, [$c12a]
    ld d, a
    pop hl
    ld a, l
    sub e
    ld l, a
    ld [SpriteXPosition], a
    ld a, h
    ld e, a
    sbc d
    ld h, a
    jr nc, CheckBounds
    ld a, d
    cp $14
    jr nz, CheckBounds
    ld h, e
    jr CheckBounds

.SetUpXStartPos:
    ld a, [BgScrollXLsb]
    ld e, a
    ld a, [BgScrollXMsb]
    ld d, a                         ; de = BG X scroll
    pop hl                          ; hl = X position of object
    ld a, l
    sub e
    ld l, a
    ld [SpriteXPosition], a         ; Set up starting X position of the sprite(s).
    ld a, h
    sbc d
    ld h, a                         ; hl = X position of object - BG X scroll

; $3df1
CheckBounds:
    ld de, 40
    add hl, de                      ; hl = X position of object - BG X scroll + 40
    ld a, h
    or a
    jr nz, NoOamTransferNeeded2     ; Jump if object is out of screen in X direction.
    ld a, l
    cp 220
    jr c, SetUpYStartPos

; $3dfe
NoOamTransferNeeded2:
    pop hl                          ; Pop Y position from stack.
    jr NoOamTransferNeeded

SetUpYStartPos:
    pop hl                          ; hl = Y position of object
    ld a, [BgScrollYLsb]
    ld e, a
    ld a, [BgScrollYMsb]
    ld d, a                         ; de = BG Y scroll
    ld a, l
    sub e
    ld l, a
    ld [SpriteYPosition], a         ; Set up starting Y position of the sprite(s).
    ld a, h
    sbc d
    ld h, a
    ld de, 32
    add hl, de                      ; hl = y position of object - BG Y scroll + 32
    ld a, h
    or a
    jr nz, NoOamTransferNeeded      ; Jump if object is out of screen in Y direction.
    ld a, l
    cp 208
    jr c, PrepObjectOamTransfer2

; $3e20
NoOamTransferNeeded:
    pop de
    and a
    ret

; $3e23: Continue here.
; Sets up object sprites for OAM transfer.
PrepObjectOamTransfer2:
    SwitchToBank 4
    ld hl, ObjAnimationIndicesPtr
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]                      ; de = [ObjAnimationIndicesPtr + 2 * bc]
    ld hl, ObjAnimationIndices
    add hl, de                      ; hl = ObjAnimationIndices + de
    push hl
    ld hl, NumObjectSprites
    add hl, bc
    ld a, [hl]                      ; a = [NumObjectSprites + bc]
    ld e, a
    and $0f
    ld d, a                         ; d = number of sprites in X direction
    ld a, e
    swap a
    and $0f
    ld e, a                         ; e = number of sprites in Y direction
    push de
    sla e
    sla e                           ; e = (number of sprites in Y direction) * 4
    ld hl, ObjSpritePixelOffsets
    add hl, bc
    add hl, bc                      ; hl = ObjSpritePixelOffsets + 2 * bc
    ld a, [SpriteFlags]
    ld c, a
    and SPRITE_X_FLIP_MASK
    jr z, .NoXFlip

.XFlip:
    ld a, [SpriteXPosition]
    add e
    sub [hl]                        ; Subtract X pixel offset.
    ld [SpriteXPosition], a
    jr .Continue

.NoXFlip:
    ld a, [SpriteXPosition]
    sub e
    add 8
    add [hl]                        ; Add X pixel offset.
    ld [SpriteXPosition], a

.Continue:
    inc hl
    ld a, [SpritesYOffset]          ; Seems to be some additional offset in Y direction.
    ld b, a
    ld a, [SpriteYPosition]
    bit 6, c                        ; Check if Y flip.
    jr z, .NoYFlip

.YFlip:
    add 16
    add b
    sub [hl]                        ; Subtract Y pixel offset.
    jr .Continue2

.NoYFlip:
    sub 16
    add b
    add [hl]                        ; Add Y pixel offset.

.Continue2:
    ld [SpriteYPosition], a         ; Update Y position of sprite.
    pop bc                          ; bc = number of sprites in XY direction
    pop hl                          ; hl = ObjAnimationIndices + de
    pop de                          ; de = pointer to RAM

.YLoop:
    push bc                         ; Push number of sprites in XY direction.
    ld a, [SpriteXPosition]
    push af
    ld b, c

.XLoop:
    push bc                         ; Push number of sprites in X direction.
    ld a, [SpriteFlags]
    ld b, a                         ; b = [SpriteFlags]
    ld a, [hl+]
    sub $02
    jr z, .SetXPos

    ld c, a                         ; c = [ObjAnimationIndices + de]
    ld a, [SpriteYPosition]
    ld [de], a
    inc e
    ld a, [SpriteXPosition]
    ld [de], a
    inc e
    ld a, [SpriteVramIndex]
    cp $90
    jr c, .Carry

.NoCarry
    sub $02
    add c                           ; a += [ObjAnimationIndices + de]
    ld [de], a                      ; [de] = VRAM index
    jr .SetSpriteFlags

.Carry:
    ld [de], a                      ; [de] = VRAM index
    add $02
    ld [SpriteVramIndex], a         ; Set up VRAM index for next sprite.

.SetSpriteFlags:
    inc e
    ld a, b
    ld [de], a                      ; [de] = [SpriteFlags]
    inc e

.SetXPos:
    ld c, SPRITE_WIDTH
    bit 5, b                        ; Check for X flip.
    jr z, .Continue3

    ld c, -SPRITE_WIDTH

.Continue3:
    ld a, [SpriteXPosition]
    add c                           ; Add width of a sprite.
    ld [SpriteXPosition], a         ; Position of the next sprite.
    ld a, b
    pop bc                          ; Get number of sprites in X direction.
    dec b
    jr nz, .XLoop                   ; Jump to next column.
    ld b, a
    pop af
    ld [SpriteXPosition], a         ; Go to next row.
    ld c, SPRITE_HEIGHT
    bit 6, b                        ; Check for Y flip.
    jr z, .Continue4

    ld c, -SPRITE_HEIGHT

.Continue4:
    ld a, [SpriteYPosition]
    add c                           ; Add height of the pixel.
    ld [SpriteYPosition], a         ; Set Y position of next sprite.
    pop bc
    ld a, e
    cp $a0
    jr nc, .End
    dec b
    jr nz, .YLoop

.End:
    SwitchToBank 1
    scf
    ret

; $3eec
LoadFontIntoVram::
    ld hl, CompressedFontTiles
    ld de, $8ce0

; The following section handles data decompression.
SECTION "Decompression", ROM0

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
DecompressData:
    ld a, e
    ld [AddressDecompTargetLsb], a
    ld a, d
    ld [AddressDecompTargetMsb], a  ; 2 Byte (V)RAM start address of decompression target in [$c109:$c10a].
    ld c, [hl]
    inc hl
    ld b, [hl]                      ; Length of decompressed data in "bc".
    inc hl
    push hl
    ld h, d
    ld l, e
    add hl, bc
    ld d, h
    ld e, l                         ; (V)RAM end address of decompressed data in "de".
    pop hl
    ld c, [hl]
    inc hl
    ld b, [hl]                      ; Length of compressed data in "bc".
    add hl, bc                      ; RAM end address of compressed data in "hl".
    ldd a, [hl]
    ld [$c106], a                   ; Store first compressed data byte in [$c106].
    push hl
    ld hl, $c106
    scf
    rl [hl]                         ; "hl" pointing to first data byte.
    jr C, .Skip                     ; Skip pattern if first bit is 1.
  .Start                            ; $3f16
    call Lz77GetItem                ; Number of bytes to process in "bc".
  : xor a                           ; Copy next byte of symbol data into a
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
    adc a                           ; Symbol now in a
    dec de
    ld [de], a                      ; Load symbol into VRAM
    dec bc
    ld a, b
    or c
    jr nZ, :-                       ; Continue if all bytes have been processed
    ld a, [AddressDecompTargetMsb]
    cp d
    jr nZ, .Skip
    ld a, [AddressDecompTargetLsb]
    cp e                            ; Stop if current pointer points to VRAM start
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
    ld [hl], b                      ; Offset in bc
    dec l
    dec l
    call Lz77GetItem
    push hl
    inc bc
    inc bc
    inc bc
    push bc                         ; Copy length in bc
    inc l
    ld c, [hl]
    inc l
    ld b, [hl]
    ld h, d
    ld l, e
    dec hl
    add hl, bc
    pop bc
  : ldd a, [hl]                     ; Uncompressed VRAM(!) data pointer in hl
    dec de
    ld [de], a                      ; VRAM pointer in de
    dec bc                          ; Number of loop iterations in bc
    ld a, b
    or c
    jr nZ, :-
    pop hl
    ld a, [AddressDecompTargetMsb]
    cp d
    jr nZ, .FirstBitCheck
    ld a, [AddressDecompTargetLsb]
    cp e
    jr C, .FirstBitCheck
; $3f83
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
