SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

Call24000::
    ld a, [AnimationIndex]
    ld b, $00
    ld c, a
    ld a, [$c149]
    cp $03
    jr nz, jr_002_4018

    ld a, [HeadSpriteIndex]
    cp c
    jr nz, jr_002_401e

    ld a, [$c147]
    jr jr_002_401b

jr_002_4018:
    ld a, [FacingDirection]

jr_002_401b:
    ld [$c148], a

jr_002_401e:
    ld hl, AnimationPointersTODO    ; Probably some array of pointers. Offset given by [AnimationIndex]
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]                      ; de = pointer from array at $438f
    ld hl, AnimationPointers2TODO
    add hl, de
    ld a, l
    ld [$c197], a
    ld a, h
    ld [$c198], a
    ld hl, AnimationPointers3TODO

    add hl, bc
    ld a, [hl]
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
    ld hl, $4491
    add hl, bc
    add hl, bc
    ld a, [$c148]
    and $80
    ld a, [PlayerWindowOffsetX]
    jr z, jr_002_4059

    add e
    sub [hl]
    jr jr_002_405d

jr_002_4059:
    sub e
    add $08
    add [hl]

jr_002_405d:
    ld [WindowScrollYMsb], a
    inc hl
    ld a, [BgScrollYOffset]
    ld b, a
    ld a, [$c16c]
    ld c, a
    ld a, [PlayerWindowOffsetY]
    sub $10
    add [hl]
    add c
    add b
    ld [WindowScrollYLsb], a
    ld hl, $c197
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    pop bc
    ld de, $c000
    ld a, [$c192]
    ld [WindowScrollXLsb], a
    ld a, [$c18a]
    and $80
    jr nz, jr_002_40da

jr_002_408b:
    push bc
    ld a, [WindowScrollYMsb]
    push af
    ld b, c

jr_002_4091:
    push bc
    ld a, [$c148]
    and $20
    ld b, a
    ld a, [hl+]
    sub $02
    jr z, jr_002_40b7

    ld a, [WindowScrollYLsb]
    ld [de], a
    inc e
    ld a, [WindowScrollYMsb]
    ld [de], a
    inc e
    ld a, [WindowScrollXLsb]
    ld [de], a
    add $02
    ld [WindowScrollXLsb], a
    inc e
    ld a, [$c18a]
    or b
    ld [de], a
    inc e

jr_002_40b7:
    ld c, $08
    bit 5, b
    jr z, jr_002_40bf

    ld c, $f8

jr_002_40bf:
    ld a, [WindowScrollYMsb]
    add c
    ld [WindowScrollYMsb], a
    pop bc
    dec b
    jr nz, jr_002_4091

    pop af
    ld [WindowScrollYMsb], a
    ld a, [WindowScrollYLsb]
    add $10
    ld [WindowScrollYLsb], a
    pop bc
    dec b
    jr nz, jr_002_408b

jr_002_40da:
    ld a, $18
    sub e
    ret c

    ret z

    ld b, a
    ld h, d
    ld l, e
    xor a

.Loop:
    ld [hl+], a
    dec b
    jr nz, .Loop
    ret

; $40e8: Input: a = 0
TODO00240e8:
    dec a
    ld [$c18b], a                   ; $ff
    ld a, c
    ld [$c18f], a
    ld a, [$c191]
    xor $0c
    ld [$c191], a
    swap a
    ld [$c193], a
    ld a, $80
    ld [$c194], a
    ld b, $00
    ld hl, AnimationPointers3TODO

    add hl, bc
    ld a, [hl]
    ld e, a
    and %1111
    ld d, a
    ld a, e
    swap a
    and %1111
    ld e, a
    xor a

.Loop:
    add e
    dec d
    jr nz, .Loop

    ld [$c18c], a
    ld hl, AnimationPointers5TODO
    add hl, bc
    ld a, [hl]
    dec a
    dec a
    add a
    ld e, a
    ld hl, PlayerSpritePointers
    add hl, de
    ld a, [hl+]
    ld [SpritePointerMsb], a
    ld a, [hl]
    ld [SpritePointerLsb], a
    ld hl, AnimationPointersTODO
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld hl, AnimationPointers2TODO
    add hl, de
    ld a, l
    ld [TodoPointerLsb], a
    ld a, h
    ld [TodoPointerMsb], a
    ret

; $4145
AnimationPointers2TODO::
    db $3a, $3c, $4c, $4e, $3e, $40, $4c, $4e, $14, $1e, $18, $2e, $30, $32, $04, $06
    db $08, $20, $22, $24, $0a, $0c, $0e, $26, $28, $2a, $10, $12, $2c, $02, $14, $16
    db $18, $2e, $30, $32, $04, $1a, $08, $20, $34, $24, $0a, $1c, $0e, $26, $36, $2a
    db $10, $12, $38, $02, $5e, $60, $62, $80, $82, $02, $64, $66, $68, $84, $86, $88
    db $6a, $6c, $6e, $8a, $8c, $8e, $70, $72, $74, $90, $92, $94, $02, $96, $98, $76
    db $ac, $7a, $9a, $9c, $5c, $ae, $b0, $02, $5e, $9e, $62, $80, $b2, $02, $64, $a0
    db $a2, $84, $b4, $88, $6a, $a4, $a6, $8a, $b6, $8e, $70, $a8, $aa, $b8, $ba, $94
    db $02, $54, $56, $76, $78, $7a, $58, $5a, $5c, $7c, $7e, $02, $04, $06, $08, $2a
    db $2c, $02, $02, $0a, $0c, $0e, $2e, $30, $32, $02, $02, $10, $12, $14, $34, $36
    db $38, $02, $02, $16, $18, $1a, $3a, $3c, $3e, $02, $02, $1c, $1e, $40, $42, $44
    db $02, $20, $22, $46, $48, $4a, $24, $26, $28, $4c, $4e, $02, $54, $56, $58, $60
    db $62, $64, $5a, $5c, $5e, $66, $68, $6a, $ac, $ae, $98, $9a, $50, $52, $02, $5c
    db $5e, $60, $54, $56, $02, $62, $64, $66, $58, $5a, $02, $68, $6a, $6c, $0a, $0c
    db $0e, $10, $30, $32, $02, $02, $02, $02, $12, $14, $10, $34, $36, $38, $02, $02
    db $02, $02, $02, $04, $02, $02, $16, $18, $3a, $3c, $3e, $02, $02, $02, $06, $02
    db $02, $1a, $40, $42, $44, $1c, $1e, $02, $02, $02, $46, $48, $4a, $02, $52, $02
    db $02, $20, $22, $24, $02, $02, $02, $02, $4c, $4e, $50, $08, $02, $02, $02, $02
    db $26, $28, $2a, $2c, $2e, $a2, $a4, $b0, $b2, $98, $9a, $02, $46, $48, $4a, $50
    db $52, $02, $02, $02, $02, $04, $0e, $10, $12, $32, $34, $02, $02, $02, $06, $14
    db $16, $18, $36, $38, $02, $02, $02, $08, $02, $02, $1a, $1c, $1e, $3a, $3c, $02
    db $02, $02, $0a, $02, $02, $02, $20, $22, $24, $3e, $40, $02, $02, $02, $0c, $02
    db $02, $02, $26, $28, $2a, $42, $44, $02, $02, $2c, $2e, $30, $46, $48, $02, $02
    db $4a, $02, $02, $02, $04, $0e, $4e, $50, $32, $66, $02, $02, $02, $06, $14, $52
    db $54, $36, $68, $02, $02, $02, $4c, $02, $02, $56, $58, $1e, $3a, $6a, $02, $02
    db $02, $0a, $02, $02, $02, $5a, $5c, $24, $3e, $40, $02, $02, $02, $0c, $02, $02
    db $02, $5e, $60, $2a, $42, $6c, $02, $02, $2c, $62, $64, $46, $6e, $02, $02, $4a
    db $02, $02, $02, $76, $02, $8c, $8e, $b4, $b6, $02, $42, $44, $50, $52, $02, $72
    db $74, $02, $86, $88, $8a, $02, $02, $76, $8c, $8e, $90, $02, $78, $7a, $92, $94
    db $96, $a6, $a8, $b8, $ba, $7c, $aa, $98, $bc, $04, $02, $0a, $0c, $24, $02, $06
    db $02, $0e, $0c, $26, $02, $3a, $02, $08, $02, $10, $12, $28, $02, $14, $16, $2a
    db $2c, $18, $1a, $2e, $30, $1c, $1e, $32, $34, $20, $22, $36, $38, $02, $02, $02
    db $7c, $7e, $80, $98, $9a, $02, $6e, $70, $82, $84, $98, $9a, $02, $02, $76, $9c
    db $9e, $a0, $3c, $3e, $5c, $5e, $02, $78, $40, $42, $44, $60, $62, $64, $46, $48
    db $4a, $02, $02, $66, $68, $6a, $4c, $4e, $50, $02, $6c, $6e, $02, $7a, $02, $52
    db $54, $56, $02, $70, $72, $02, $7c, $02, $58, $5a, $74, $76, $7e, $02, $6c, $6e
    db $84, $86, $70, $72, $88, $8a, $74, $76, $78, $8c, $8e, $90, $7a, $7c, $7e, $92
    db $94, $96

    ld [bc], a
    add b
    add d
    ld [bc], a
    sbc b
    sbc d
    sbc h
    sbc [hl]

; $438f
AnimationPointersTODO::
    dw $0000, $0004, $0008, $000e, $0014, $001a, $001e, $0024
    dw $002a, $0030, $0034, $003a, $0040, $0046, $004c, $0052
    dw $0058, $005e, $0064, $006a, $0070, $0076, $007c, $0082
    dw $008a, $0092, $009a, $00a0, $00a6, $00ac, $00b2, $00b8
    dw $00bc, $00c2, $00c8, $00ce, $00d6, $00e0, $00ec, $00f5
    dw $0101, $010b, $0115, $011b, $0123, $012c, $0135, $0141
    dw $014d, $0159, $0162, $016b, $0174, $0180, $018c, $0198
    dw $001d, $01a1, $01a9, $01af, $01b5, $01bb, $01c1, $01c5
    dw $01c9, $01cf, $01d7, $01dd, $01e1, $01e5, $01e9, $01ed
    dw $01f6, $001d, $01fc, $0202, $0208, $020e, $0216, $021f
    dw $0228, $022e, $0232, $0236, $023c, $0242

; $443b
AnimationPointers3TODO:
    dw $2222, $3232, $2232, $3232, $2232, $3232, $3232, $3232,
    dw $3232, $3232, $3232, $4232, $4242, $3232, $3232, $2232,
    dw $3232, $4232, $4352, $4333, $5252, $4223, $3333, $4343,
    dw $3343, $3333, $4343, $3343, $4211, $3232, $3232, $2222,
    dw $2423, $2223, $2222, $3322, $1123, $2332, $4232, $3333,
    dw $2223, $3222, $4232

AnimationPointers4TODO::
    db $fd, $00, $fd, $00, $00, $00, $00, $00, $00, $00, $03, $00, $00, $00, $00, $00
    db $00, $00, $03, $00, $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $00
    db $03, $00, $00, $00, $00, $00, $00, $00, $00, $00, $04, $00, $06, $0a, $00, $00
    db $00, $fa, $04, $fd, $02, $f4, $00, $fd, $00, $00, $01, $00, $01, $00, $00, $00
    db $00, $00, $02, $00, $02, $00, $f6, $fb, $f2, $fb, $f2, $f4, $fa, $f4, $0e, $fc
    db $0c, $f9, $0f, $f0, $00, $f0, $05, $00, $f6, $f3, $f8, $f4, $fe, $f9, $03, $f5
    db $06, $f4, $08, $fc, $f6, $f3, $f8, $f4, $fe, $f9, $03, $f5, $06, $f4, $08, $fc
    db $00, $00, $00, $00, $01, $00, $02, $00, $fc, $00, $fc, $00, $00, $00, $00, $00
    db $04, $f0, $04, $f0, $06, $f0, $00, $00, $01, $00, $01, $00, $00, $00, $04, $f0
    db $00, $f0, $00, $00, $fc, $00, $01, $fc, $01, $00, $01, $fc, $fd, $fd, $fe, $fb
    db $00, $fb, $01, $00, $01, $00, $05, $00, $05, $00, $08, $00

; $453d
AnimationPointers5TODO::
    db $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02, $02
    db $02, $02, $02, $02, $02, $02, $03, $03, $03, $03, $03, $03, $03, $04, $04, $03
    db $03, $03, $03, $04, $04, $04, $04, $04, $04, $04, $03, $02, $05, $05, $05, $05
    db $05, $05, $05, $05, $05, $05, $05, $05, $03, $03, $02, $03, $03, $03, $03, $03
    db $06, $06, $06, $06, $06, $06, $06, $03, $03, $03, $03, $06, $06, $06, $06, $06
    db $06, $04, $04, $04, $04, $04

; $4593
PlayerSpritePointers::
    dw PlayerSprites0               ; When standing or walking.
    dw PlayerSprites1               ; Crouching, or looking up, or jumping sideways.
    dw PlayerSprites2               ; Player dies or swings on a vine.
    dw PlayerSprites3
    dw PlayerSprites4               ; Jumping, hanging on a vine.

; $459d
PlayerSprites0::
    INCBIN "gfx/PlayerSprites0.2bpp"

; $511d
PlayerSprites1::
    INCBIN "gfx/PlayerSprites1.2bpp"

; $5cbd
PlayerSprites2::
    INCBIN "gfx/PlayerSprites2.2bpp"

; $667d
PlayerSprites3::
    INCBIN "gfx/PlayerSprites3.2bpp"

; $6d3d
PlayerSprites4::
    INCBIN "gfx/PlayerSprites4.2bpp"

; $174fd: Loads the tiles of the status window.
LoadStatusWindowTiles::
    ld hl, CompressedStatusWindowData
    ld de, $8d80
    jp DecompressData

; $27506: Draws the initial status window including health, time, diamonds, etc.
InitStatusWindow:
    ld hl, WindowTileMap
    ld de, $9ca0    ; Window tile map.
    ld b, 4         ; Number of lines.
    ld c, 20        ; Number of tiles per line.
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

; $27523: Draws the credit string at the end of the game.
DrawCreditScreenString::
    ld hl, CreditScreenString
    TilemapLow de, 0, 0

; $27529:  Start address of ASCII string in hl. Address of window tile map in de.
DrawString::
    ldi a, [hl]      ; Load ASCII character into a.
    or a
    ret Z            ; Return at end of string.
    cp $0d
    jr Z, .LineBreak ; Check for carriage return.
    bit 7, a
    jr nZ, .Label2   ; Check for extended ASCII.
    sub $20          ; Normalize.
    jr Z, .Label2
    sub $10
    cp $0a
    jr C, .Label1
    sub $07
.Label1:
    add $ce
.Label2:
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

; $27551: Draws the 4 heart tiles according to current health.
DrawHealth::
    ld a, [CurrentHealth]
    srl a
    srl a                 ; a = a / 4
    ld de, $8f40          ; VRAM tile data pointer for the 4 heart tiles.
    cp 7
    jr nc, HealthIsHigh   ; Jump if health is more than 28.
    push af               ; Else we have two redraw the lower parts of the heart.
    ld a, [CurrentHealthDiv4]
    cp 7
    ld a, 7
    call nc, LoadTwoHeartTiles
    pop af
    ld e, $60             ; Next row.

; $2756d
HealthIsHigh:
    call LoadTwoHeartTiles
    ld [CurrentHealthDiv4], a   ;  = a / 4
    cp 13                       ; Aren't we always returning?
    ret c
    jp CopyToVram

; $27579: Loads two heart tiles into the VRAM
; Input: Offset in "a".
LoadTwoHeartTiles:
    push af
    add a                     ; a = a * 2
    call CreateOffsetPointer
    call CopyToVram            ; Copies 2 tiles.
    pop af
    ret

; $27583: Creates a pointer into "hl" from offset in "a".
; Basically is "a" is shifted left by 4 to create 16 byte aligned offsets.
; This offset is added to $7ab1.
; Lower hearts: $7b71, $7b51, $7b31, $7b11, $7af1, $7ad1, $7ab1
; Upper hearts: $7c31, $7c11, $7bf1, $7bd1, $7bb1, $7b91
; Banana / Double Banana: $7c91
; Boomerang:              $7ca1
; Stones:                 $7cb1
; Mask:                   $7cc1
CreateOffsetPointer::
    swap a
    ld c, a
    and $0f
    ld b, a          ; b = 0 0 0 0 a7 a6 a5 a4
    ld a, c
    and $f0
    ld c, a          ; c = a3 a2 a1 a0 0 0 0 0
    ld hl, WindowSpritesBase
    add hl, bc       ; bc = 0 0 0 0 a7 a6 a5 a4 a3 a2 a1 a0 0 0 0 0
    ret

; $27592: CheckWeaponSelect
; Selects the next weapon if SELECT was pressed.
CheckWeaponSelect::
    ld a, [JoyPadNewPresses]
    and BIT_SELECT
    ret z                           ; Return if SELECT wasn't pressed.
    ld a, [JoyPadData]
    and BIT_UP | BIT_DOWN
    ret nz                          ; Return if UP or DOWN is pressed at the same time.
    ld a, [WeaponSelect]
    inc a
    cp NUM_WEAPONS
    jr c, SelectNewWeapon           ; Jump if increase was ok.
    xor a                           ; Otherwise, wrap around (a = 0).

 ; $75a7: Selects new weapon given in "a".
 SelectNewWeapon:
    ld [WeaponSelect], a
    ld b, $00
    ld c, a
    ld hl, WeaponTileOffsets        ; Weapon tile ofssets $75ce + WeaponSelect ($1e,$1e,$1f,$20,$21)
    add hl, bc
    ld de, $9ce8                    ; Upper tile map pointer.
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                       ; Don't copy during OAM search.
    ld a, $fc                       ; Corresponds to a little "2" needed for the double bananas.
    dec c
    jr z, :+
    xor a                           ; = 0 if weapon is not double banana
 :  ld [de], a                      ; Set first tile (= $fc for double banana which needs two tiles; = 0 else).
    ld de, $8f30                    ; Pointer to tile data in VRAM.
    ld a, [hl]                      ; a = [weapon sprite offset]
    call CreateOffsetPointer        ; Puts the right pointer into "hl".
    call CopyToVram16
    jp HandleNewWeapon

; $75ce
WeaponTileOffsets::
    db $1e                          ; Default banana.
    db $1e                          ; Double banana.
    db $1f                          ; Boomerang.
    db $20                          ; Stone.
    db $21                          ; Mask.

NintendoLicenseString:: ; $175d3
    db "LICENSED BY NINTENDO",0

PresentsString::  ; $175e8
    db "PRESENTS",0

MenuString:: ; $175f1
    db "(C)1994 THE WALT\r"
    db "   DISNEY COMPANY\r",
    db "\r"
    db "   (C)1994 VIRGIN\r",
    db "    INTERACTIVE\r",
    db "   ENTERTAINMENT\r",
    db "\r"
    db "DEVELOPED BY EUROCOM\r"
    db "\r"
    db "PRESS START TO BEGIN\r"
    db "  LEVEL : "

NormalString::
    db "NORMAL  ",0

PracticeString::
    db "PRACTICE",0

; Level 1
JungleByDayString::
    db "JUNGLE BY DAY",0

; Level 2
TheGreatTreeString::
    db "THE GREAT TREE",0

; Level 3
DawnPatrolString::
    db " DAWN PATROL",0

; Level 4
ByTheRiverString::
    db "BY THE RIVER",0

; Level 5
InTheRiverString::
    db "IN THE RIVER",0

; Level 6
TreeVillageString::
    db "TREE VILLAGE",0

; Level 7
AncientRuinsString::
    db "ANCIENT RUINS",0

; Level 8
FallingRuinsString::
    db "FALLING RUINS",0

; Level 9
JungleByNightString::
    db "JUNGLE BY NIGHT",0

; Level 10
TheWastelandsString::
    db "THE WASTELANDS",0

; $2771c: Pointers to the level strings from above.
LevelStringPointers::
  dw JungleByDayString, TheGreatTreeString, DawnPatrolString, ByTheRiverString
  dw InTheRiverString, TreeVillageString, AncientRuinsString, FallingRuinsString
  dw JungleByNightString, TheWastelandsString

; $17730: The credits you see at the end of the game.
CreditScreenString::
  db "EUROCOM DEVELOPMENTS"
  db "\r\r"
  db "DESIGN: MAT SNEAP\r"
  db "        DAVE LOOKER\r"
  db "        JON WILLIAMS\r"
  db "CODING: DAVE LOOKER\r"
  db "GRAPHX: MAT SNEAP\r"
  db "        COL GARRATT\r"
  db "SOUNDS: NEIL BALDWIN\r"
  db "UTILS : TIM ROGERS\r"
  db "\r"
  db "     VIRGIN US\r"
  db "\r"
  db "PRODUCER: ROBB ALVEY\r"
  db "ASSISTANT:KEN LOVE\r"
  db "QA:       MIKE MCCAA\r"
  db "\r"
  db "DISNEY:   P GILMORE", 0

; $7846
LevelString::
    db "LEVEL ",0

; $784d
CompletedString::
    db "COMPLETED",0

; $7857
GetReadyString::
    db "GET READY",0

; $7861
GameOverString::
    db "GAME OVER",0

; $786b
WellDoneString::
    db "WELL DONE",0

; $27875
ContinueString::
  db "CONTINUE?", 0

; $787f
WindowTileMap::
    db $f8, $f9, $f9, $fa, $f8, $f9, $f9, $fa, $f8, $f9, $f9, $fa, $f8, $f9, $f9, $fa, $f8, $f9, $f9, $fa, ; Line 1.
    db $ec, $ed, $f0, $ce, $00, $ce, $ce, $ce, $ce, $ce, $ce, $ce, $fb, $f4, $f5, $00, $ce, $f0, $ce, $ce, ; Line 2.
    db $ee, $ef, $f1, $ce, $00, $f2, $ce, $ce, $00, $f3, $ce, $ce, $00, $f6, $f7, $00, $ce, $f1, $ce, $ce, ; Line 3.
    db $fd, $fe, $fe, $ff, $fd, $fe, $fe, $ff, $fd, $fe, $fe, $ff, $fd, $fe, $fe, $ff, $fd, $fe, $fe, $ff  ; Line 4.

; $78cf: Compressed tiles of the status window.
CompressedStatusWindowData::
    INCBIN "bin/CompressedStatusWindowData.bin"

; $7ab1
WindowSpritesBase::

; $7ab1
LowerHeartsSprites::
    INCBIN "gfx/LowerHeartsSprites.2bpp"

; $7b91
UpperHeartsSprites::
    INCBIN "gfx/UpperHeartsSprites.2bpp"

; $7c71
LowerHeartsSprites2:
    INCBIN "gfx/LowerHeartsSprites2.2bpp"

; $7c91
BananaWindowSprite::
    INCBIN "gfx/BananaWindowSprite.2bpp"

; $7ca1
BoomerangWindowSprite::
    INCBIN "gfx/BoomerangWindowSprite.2bpp"

; $7cb1
StonesWindowSprite::
    INCBIN "gfx/StonesWindowSprite.2bpp"

; $7cc1
MaskWindowSprite::
    INCBIN "gfx/MaskWindowSprite.2bpp"

; $7cd1: Compressed $24f. Decompressed 290$.
; Compressed tile data of the cartoonish font.
CompressedFontTiles::
    INCBIN "bin/CompressedFontTiles.bin"

; $7f20. Compressed $d7. Decompressed 120$. These tiles are used for the hole the player digs when collecting the shovel.
; Only loaded in transition level to $96e0.
CompressedHoleTiles::
    INCBIN "bin/CompressedHoleTiles.bin"

; $7ff7: Probably 9 bytes of unused data at the end of Bank 2.
Bank2TailData::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $02
