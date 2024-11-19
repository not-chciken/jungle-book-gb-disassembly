SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

; $4000: Initializes some special background features for next Level 3, and for next Level 5.
DrawInitBackgroundSpecial:
    ld bc, $05e8
    ld a, [NextLevel]
    cp 3                       ; Next level = 3?
    jr z, :+
    cp 5                       ; Next level = 5?
    ret nz
    ld bc, $0188
 :  add hl, bc
    ld de, $9c20
    ld bc, $0801               ; I guess this draws one line at the bottom.
    jr DrawInitBackgroundLoop

; $4019: Draws the initial background when starting a level.
DrawInitBackground::
    ld de, _SCRN0
    ld b, 8                       ; Draw 8 lines with a height of 4 tiles each.
    ld c, b

; $401f
DrawInitBackgroundLoop::
    push bc
    push de
    push hl

; $4022: Draws the initial background for the game.
; Order of the tiles is: 1 2 5 6
;                        3 4 7 8
; Each [Layer1BgPtrs] pointer handles 16 tiles. (may also start in the middle or so)
; Each [$cb00] pointer handles 4 tiles.
; Each [$c700] pointer handles 1 tile.
Draw4xLineLoop::
    push bc                        ; Init is $0808
    push de
    ld a, [hl+]                    ; E.g.  a = [$d200]
    push hl
    ld b, 0
    add a
    rl b
    add a
    rl b                           ; Put upper 2 bits of "a" into lower 2 bits of "b".
    ld c, a                        ; bc = a *4
    ld hl, Layer2BgPtrs1
    add hl, bc                     ; hl = $cb00 + a * 4
    push de
    call WriteBgIndexIntoTileMap   ; Writes 4 indices into the tile map (two in one line).
    inc de
    inc de                         ; Hence, increase pointer by 2. Two tiles to the right.
    call WriteBgIndexIntoTileMap
    pop de
    ld a, e
    add 64                          ; Skip two lines by adding 64 to tile map pointer "de".
    ld e, a
    jr nc, :+
    inc d                           ; Carry case.
 :  call WriteBgIndexIntoTileMap    ; Writes 4 indices into the tile map (two in one line).
    inc de
    inc de                          ; Hence, increase pointer by 2. Two tiles to the right.
    call WriteBgIndexIntoTileMap
    pop hl
    pop de                          ; Reset to starting line in y-direction.
    inc de
    inc de
    inc de
    inc de                          ; Go 4 tiles to the right.
    pop bc
    dec b
    jr nz, Draw4xLineLoop           ; Jumps back 8 times. Hence We draw one line with a height of 4 tiles from left to right in a snake pattern.

    pop hl
    ld a, [LevelWidthDiv16]
    ld c, a
    add hl, bc                      ; hl = hl + [LevelWidthDiv16] (b is zero)
    pop de
    ld a, e
    add $80
    ld e, a                         ; Lower the tile map pointer by 4 lines.
    jr nc, :+
    inc d                           ; Carry case.
 :  pop bc
    dec c
    jr nz, DrawInitBackgroundLoop   ; Jump back in case we are not at the bottom.
    ret

; $14069 Sets tile map for the background.
; Writes squarish into 4 tiles : XX
;                                XX
; Data for offset in hl. Tile map pointer in de.
; Data resides at $c700 + modified offset.
WriteBgIndexIntoTileMap:
    push de
    ld a, [hl+]             ; "hl" (=$cb00 + offfset). Points to the RAM
    push hl
    ld b, $00
    add a
    rl b
    add a
    rl b                    ; Put upper 2 bits of "a" into lower 2 bits of "b".
    ld c, a                 ; bc = a * 4
    ld hl, Layer3BgPtrs1    ; Address in the RAM.
    add hl, bc              ; hl = hl * (a * 4)
    ld a, [hl+]
    ld [de], a              ; Write index into tile map.
    inc de
    ld a, [hl+]
    ld [de], a              ; Write index into tile map.
    dec de
    ld a, e
    add 32                  ; Add 32. Switches to the next row.
    ld e, a
    jr nc, :+
    inc d                   ; If addition overflows, add carry to d.
 :  ld a, [hl+]             ; "hl" points to the RAM.
    ld [de], a              ; Write index into tile map.
    inc de
    ld a, [hl]
    ld [de], a              ; Write index into tile map.
    pop hl                  ; "hl" (=$cb00 + offfset) + 1
    pop de
    ret

; $408e: Calculates the bounding box of the player and the window from the level's width and height.
; TODO: Plus some other things I don't understand yet.
CalculateBoundingBoxes::
    ld d, $0c
    ld a, [NextLevel]
    ld e, a
    cp 11
    jr nz, :+
    ld d, $20                 ; d = $20 if Level 11
 :  ld a, [LevelWidthDiv16]
    ld b, 0
    add a                     ; a = a << 1
    rl b                      ; b[0] = LevelWidthDiv16[7]
    swap b                    ; b[4] = LevelWidthDiv16[7]
    swap a
    ld c, a
    and %1111                 ; a = LevelWidthDiv16[6:2]
    or b
    ld b, a
    ld a, c
    and %11110000
    ld c, a
    ld a, e
    cp 10
    jr nz, :+
    ld a, c
    sub $18
    ld c, a
    dec b
 :  ld a, c
    sub d
    ld [LvlBoundingBoxXLsb], a
    ld a, b
    sbc $00
    ld [LvlBoundingBoxXMsb], a
    ld a, e
    cp $0c
    jr nz, jr_001_40cd
    xor a
    ld b, a
    jr jr_001_40d3
jr_001_40cd:
    ld a, c
    sub $a0
    jr nc, jr_001_40d3
    dec b
jr_001_40d3:
    ld [WndwBoundingBoxXLsb], a
    ld a, b
    ld [WndwBoundingBoxXMsb], a
    ld a, [LevelHeightDiv16]
    add a
    swap a
    ld c, a
    and $0f
    ld b, a
    ld a, c
    and $f0
    ld c, a
    ld [LvlBoundingBoxYLsb], a    ; These values are never used I think.
    ld a, b
    ld [LvlBoundingBoxYMsb], a    ; These values are never used I think.
    ld a, c
    sub $78
    jr nc, :+
    dec b
 :  ld [WndwBoundingBoxYLsb], a
    ld a, b
    ld [WndwBoundingBoxYMsb], a
    ld a, d
    inc a
    ld [$c14b], a                 ; TODO: What is this? Something seems to happen when the player reaches this point.
    xor a
    ld [$c14c], a                 ; = 0
    ld [$c1d2], a                 ; = 0
    ld [$c1d3], a                 ; = 0
    ret

; $1410c: Draws number of lives and time left.
DrawLivesAndTimeLeft::
    ld hl, DigitMinutes
    ld a, [hl-]
    ld e, $d0               ; Lower tile map index pointer.
    call DrawBigNumber      ; Draw minutes.
    ld a, [hl-]
    ld e, $d2               ; Lower tile map index pointer.
    call DrawBigNumber      ; Draw seconds second digit.
    ld a, [hl]
    ld e, $d3               ; Lower tile map index pointer.
    jr DrawBigNumber        ; Draw seconds first digit.
; $14120
DrawLivesLeft::
    ld a, [CurrentLives]
    ld e, $c3               ; Draw lives left.

; $14125: Draws a number that spans over two tiles.
; Used to display the time left and lives left.
; Number in "a", lower tile map index pointer in "e".
DrawBigNumber:
    ld d, $9c
    add $d8
    ld c, a
    call WriteBigNumberIntoVram
    add $0a
    ld c, a
    ld a, e
    add 32                      ; Next line
    ld e, a
    jr nc, WriteBigNumberIntoVram
    inc d                       ; Handle lower byte "de" overflow.
WriteBigNumberIntoVram:
    ldh a, [rSTAT]
    and STATF_OAM
    jr nz, WriteBigNumberIntoVram ; Don't write during OAM search.
    ld a, c
    ld [de], a                    ; Set corresponding tile map index.
    ret

; $14140: Called when diamond found.
DiamondFound::
    ld a, [NumDiamondsMissing]
    or a
    jr z, .NoDaa
    dec a
    daa
    ld [NumDiamondsMissing], a
.NoDaa:
    push af
    call UpdateDiamondNumber
    pop af
    ret

; $14151 : Updates the number of diamonds displayed.
UpdateDiamondNumber::
    ld a, [NumDiamondsMissing]
    ld e, $e6                   ; Lower byte of the tile map index pointer.
    jr DrawTwoNumbers

; $14158 : Updates the number of ammo displayed for the current weapon.
UpdateWeaponNumber::
    ld a, [WeaponSelect]
    or a
    jr nz, .NonDefaultWeapon
    ld a, NUM_BANANAS           ; We have infinite bananas. Thus, display 99.
    jr .DefaultWeapon
.NonDefaultWeapon:
    ld hl, AmmoBase
    add l
    ld l, a
    ld a, [hl]                  ; Get the number of projectiles left for the corresponding weaping in "l"
.DefaultWeapon:
    ld e, $ea

; $1416a Draws two single-tile numbers from the two nibbles in "a".
; Lower byte of the tile map index pointer "e" has to be set before call.
DrawTwoNumbers:
    ld d, $9c                   ; Upper byte of the tile map index pointer.
    ld b, a
    and $f0
    swap a
    call DrawNumber             ; Draw most significant digit
    inc e
    ld a, b
    and $0f                    ; Follow up with the least significant digit.

; $14178 Draws a single-tile number.
; Non-ASCII number in "a", tile map in "de".
DrawNumber::
    add $ce                     ; Add offset.
    ld c, a
  : ldh a, [rSTAT]
    and STATF_OAM
    jr nZ, :-                   ; Don't write during OAM-RAM search.
    ld a, c
    ld [de], a
    ret

    ld a, [PlayerFreeze]
    or a
    ret nz

    ld a, [IsPlayerDead]
    or a
    ret nz

    ld a, [$c1c2]
    inc a
    cp $3c
    jr c, jr_001_41e6

; $14196: Draws and also updates time if any digit reaches 0.
; Numbers that reach 0 are set to $ff.
DrawTime::
    ld a, [FirstDigitSeconds]
    dec a
    bit 7, a                    ; Only set if a was 0.
    jr z, .DrawFirstDigitSeconds
    ld a, [SecondDigitSeconds]
    dec a
    bit 7, a                    ; Only set if a was 0.
    jr z, .DrawSecondDigitSeconds
    ld a, [DigitMinutes]
    dec a
    bit 7, a                    ; Only set if a was 0.
    jr z, .DrawMinutes
    ld a, [$c1e5]               ; TODO: What is this?
    or a
    ret nz
    ld a, [NextLevel]
    cp 11                       ; Next level 11?
    jp z, Jump_001_5fbd         ; This jump if Level 11.
    jp PlayerDies               ; You ran out of time. Player has to die.
.DrawMinutes:
    ld [DigitMinutes], a
    ld e, $d0
    call DrawBigNumber
    ld a, 5
.DrawSecondDigitSeconds:
    ld [SecondDigitSeconds], a  ; = 5 or = $ff depending on the case.
    ld e, $d2
    call DrawBigNumber
    ld a, 9
.DrawFirstDigitSeconds:
    ld [FirstDigitSeconds], a   ; = 9 or = $ff depending on the case.
    ld e, $d3
    call DrawBigNumber
    ld a, [$c1e5]
    or a
    jr z, jr_001_41e2
    xor a
    ret

jr_001_41e2:
    call CheckIfTimeRunningOut
    xor a                           ; = 0
jr_001_41e6:
    ld [$c1c2], a
    ret nz
    ld a, [WeaponSelect]
    cp WEAPON_MASK
    ret nz                                  ; Continue if the mask is selected.
    ld a, [CurrentSecondsInvincibility]
    or a
    ret z                                   ; Return if mask has 0 seconds left.
    dec a                                   ; Reduce seconds by one.
    daa                                     ; Get correct decimal representation.
    ld [CurrentSecondsInvincibility], a
    jr z, LastInvincibleSecond
    ld a, [InvincibilityTimer]
    or a
    jp nz, UpdateWeaponNumber               ; End of function here.

    ld a, $ff
    jr jr_001_4209

LastInvincibleSecond:
    ld a, $0f

jr_001_4209:
    ld [InvincibilityTimer], a ; =$f or =$ff
    jp UpdateWeaponNumber

; $1420f: Adds "a" to CurrentScore3 and draws it
; Input: "a"
DrawScore3::
    push hl
    ld hl, CurrentScore3
    ld b, 3
    jr DrawScore1
; $14217 Adds "a" to CurrentScore2 and draws it
; Input: "a"
DrawScore2::
    push hl
    ld hl, CurrentScore2
    ld b, 2
; $1421d Adds "a" to CurrentScore1 and draws it
; Input: "a"
DrawScore1::
    and a                       ; Resets the carry flag I guess?
 :  adc [hl]                    ; a = a + CurrentScoreX
    daa
    ld [hl-], a                 ; Save current score.
    jr nc, :+
    ld a, 0
    dec b
    jr nz, :-
 :  pop hl
; $14229 Draws CurrentScore1.
DrawScore1WoAdd::
    push hl
    ld hl, CurrentScore1
    ld e, $c5                    ; Set tile map index pointer.
    ld b, $03
 :  ld a, [hl+]
    push bc
    call DrawTwoNumbers
    pop bc
    inc e                       ; Next tile.
    dec b
    jr nz, :-                   ; Draw all 6 digits of the score.
    pop hl
    ret

fnc1423d::
    bit 1, b
    ret z
    bit 2, b
    ret nz
    ld a, [$c17f]
    and $0f
    jp nz, Jump_001_449c
    ld a, [ProjectileFlying]
    or a
    ret nz                      ; Return if projectile is currently flying.
    ld [CrouchingAnimation], a
    ld a, [LookingUp]
    dec a
    jr nz, :+
    ld [LookingUp], a
 :  ld a, [WeaponSelect2]
    cp 3                        ; Check for stones.
    ld a, EVENT_SOUND_STONE     ; Stone sound is different.
    jr z, :+
    xor a                       ; = EVENT_SOUND_PROJECTILE
 :  ld [EventSound], a
    ld a, b
    and $f0
    swap a
    ld [AmmoBase], a
    ld c, a
    and $0c
    jr nz, :+
    ld [LookingUpAnimation], a
    ld [IsCrouching], a
 :  ld a, [MovementState]
    or a
    jr nz, jr_001_42eb          ; Jump if walking or falling.
    ld a, [IsJumping]
    or a
    jp nz, Jump_001_42eb        ; Jump if jumping.
    ld a, [LandingAnimation]
    or a
    jp nz, Jump_001_42eb        ; Jump if landing.
    ld a, [$c169]
    or a
    jp nz, Jump_001_42eb        ; TODO: Find out what c169 is used for.
    ld a, [$c15b]
    and $01
    jp nz, Jump_001_42eb        ; TODO: Find out what c15b is used for.
    xor a
    ld [CrouchingHeadTilted], a ; = 0
    ld [$c151], a               ; = 0
    dec a
    ld [ProjectileFlying], a    ; = $ff
    ld a, [HeadSpriteIndex]
    ld [HeadSpriteIndex2], a
    ret

    ld a, [ProjectileFlying]
    or a
    ret z

    ld a, [$c151]
    inc a
    and $07
    ld [$c151], a
    ret nz

    ld a, [CrouchingHeadTilted]
    inc a
    and $01
    ld [CrouchingHeadTilted], a
    jr nz, jr_001_42d4

    ld [ProjectileFlying], a
    ld a, [HeadSpriteIndex2]
    jp Jump_001_44f2


; Not jumped to if player is walking.
jr_001_42d4:
    ld a, [AmmoBase]        ; = 0 doing nothing, 4 up, 8 down
    ld b, 0
    ld c, a
    ld hl, HeadSpriteIndices
    ld a, [WeaponSelect2]
    cp WEAPON_STONES
    jr nz, :+
    ld l, $77               ; When shooting stones the player uses a pipe.
 :  add hl, bc              ; hl = [$676c + [AmmoBase]] or [$6777 + [AmmoBase]]
    ld a, [hl]              ; [HeadSpriteData + [AmmoBase]]
    ld [HeadSpriteIndex], a

Jump_001_42eb:
jr_001_42eb:
    ld a, [WeaponSelect2]
    cp 1
    jr nz, jr_001_4322        ; Jump if weapon is not double banana.
    ld hl, $c300
    bit 7, [hl]
    jr nz, jr_001_4300
    ld l, $40
    bit 7, [hl]
    jp z, Jump_001_449c

jr_001_4300:
    ld de, $6735
    ld a, [AmmoBase]
    add a
    add a
    add e
    ld e, a
    ld b, $02
    ld c, $00

jr_001_430e:
    push bc
    call Call_001_43d8
    ld a, l
    add $20
    ld l, a
    pop bc
    ld c, $02
    dec b
    jr nz, jr_001_430e

    ld hl, CurrentNumDoubleBanana
    jp Jump_001_43cc


jr_001_4322:
    ld de, $6741
    ld c, $00
    ld hl, $c300
    bit 7, [hl]
    jr nz, jr_001_4335

    ld l, $20
    bit 7, [hl]
    jp z, Jump_001_449c

jr_001_4335:
    or a
    jp z, Jump_001_43d8

    cp $02
    jr z, jr_001_434e

    call Call_001_43d8
    ld [hl], $00
    ld a, $94
    rst $10
    ld c, $0b
    xor a
    rst $10
    ld hl, CurrentNumStones
    jr jr_001_43cc

jr_001_434e:
    call Call_001_43d8
    set 0, [hl]
    push hl
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [AmmoBase]
    cp $04
    jr z, jr_001_436f

    ld a, [$c146]
    ld bc, $0050
    and $80
    jr z, jr_001_436e

    ld bc, $ffb0

jr_001_436e:
    add hl, bc

jr_001_436f:
    ld d, h
    ld e, l
    pop hl
    ld a, e
    ld c, $13
    rst $10
    ld a, d
    inc c
    rst $10
    ld a, [AmmoBase]
    cp $08
    jr nz, jr_001_4381

    xor a

jr_001_4381:
    ld c, $15
    rst $10
    push hl
    ld hl, $6761
    ld b, $00
    ld c, a
    add hl, bc
    ld c, [hl]
    bit 7, c
    jr z, jr_001_4392

    dec b

jr_001_4392:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld d, h
    ld e, l
    pop hl
    ld a, e
    ld c, $10
    rst $10
    ld a, d
    inc c
    rst $10
    ld a, $44
    ld c, $0e
    rst $10
    ld c, $15
    rst $08
    cp $04
    jr nc, jr_001_43bb

    ld a, $01
    ld c, $08
    rst $10
    ld a, $88
    ld c, $0a
    rst $10
    jr jr_001_43c9

jr_001_43bb:
    cp $04
    jr nz, jr_001_43c9

    ld a, $0f
    ld c, $07
    rst $10
    ld a, $88
    ld c, $09
    rst $10

jr_001_43c9:
    ld hl, CurrentNumBoomerang

Jump_001_43cc:
jr_001_43cc:
    ld a, [hl]
    dec a
    daa
    ld [hl], a
    jr nz, jr_001_43d5

    ld [WeaponSelect2], a

jr_001_43d5:
    jp UpdateWeaponNumber


Call_001_43d8:
Jump_001_43d8:
    ld [hl], $04
    ld a, c
    ld c, $0d
    rst $10
    dec c
    ld a, $01
    rst $10
    ld c, $0f
    rst $10
    ld c, $01
    ld a, [$c17d]
    or a
    jr z, jr_001_43f2

    inc c
    inc a
    jr nz, jr_001_43f2

    inc c

jr_001_43f2:
    ld a, [AmmoBase]
    ld b, a
    and $03
    jr nz, jr_001_43fe

    bit 2, b
    jr nz, jr_001_440a

jr_001_43fe:
    ld a, [$c146]
    add a
    bit 7, a
    jr nz, jr_001_4409

    add c
    jr jr_001_440a

jr_001_4409:
    sub c

jr_001_440a:
    ld c, $07
    push af
    and $0f
    push bc
    rst $10
    pop bc
    ld a, b
    and $04
    jr z, jr_001_4420

    ld a, b
    and $03
    ld a, $fd
    jr z, jr_001_4420

    ld a, $fe

jr_001_4420:
    push bc
    inc c
    rst $10
    ld a, $11
    inc c
    rst $10
    inc c
    rst $10
    inc c
    ld a, $02
    rst $10
    pop bc
    bit 2, b
    ld b, $18
    jr nz, jr_001_443e

    ld b, $04
    ld a, [$c177]
    or a
    jr nz, jr_001_443e

    ld b, $10

jr_001_443e:
    ld a, [de]
    inc de
    add b
    ld b, a

Call_001_4442:
    ld a, [PlayerPositionYLsb]
    sub b
    push af
    ld c, $01
    rst $10
    pop af
    ld a, [PlayerPositionYMsb]
    sbc $00
    inc c
    rst $10
    pop af
    or a
    jr z, jr_001_445e

    ld b, $fc
    bit 7, a
    jr nz, jr_001_445e

    ld b, $04

jr_001_445e:
    ld a, [de]
    inc de
    add b
    ld b, a
    ld a, [PlayerPositionXLsb]
    add b
    bit 7, b
    jr z, jr_001_446b

    ccf

jr_001_446b:
    ld b, $00
    jr nc, jr_001_4475

    ld b, $01
    jr z, jr_001_4475

    ld b, $ff

jr_001_4475:
    inc c
    push bc
    rst $10
    pop bc
    ld a, [PlayerPositionXMsb]
    add b
    inc c
    rst $10
    inc c
    ld a, $95
    rst $10
    inc c
    ld a, $90
    rst $10
    dec c
    ld a, [WeaponSelect2]
    or a
    ret nz

    ld a, [WeaponSelect]
    cp $04
    jr nz, jr_001_4499

    ld a, [CurrentSecondsInvincibility]
    or a
    ret nz

jr_001_4499:
    jp Jump_000_0fc3


Jump_001_449c:
    ld a, [$c155]
    and $fd
    ld [$c155], a
    ret


    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [IsJumping]
    or a
    ret nz

    ld a, [$c17d]
    inc a
    jr z, jr_001_44d4

    ld a, [$c151]
    inc a
    cp c
    jr c, jr_001_44bd

    xor a

jr_001_44bd:
    ld [$c151], a
    ret nz

    ld a, [CrouchingHeadTilted]
    cp $02
    jr c, jr_001_44cd

    inc a
    cp $0a
    jr c, jr_001_44cf

jr_001_44cd:
    ld a, $02

jr_001_44cf:
    ld [CrouchingHeadTilted], a
    jr jr_001_44f2

jr_001_44d4:
    ld a, [$c151]
    inc a
    cp $04
    jr c, jr_001_44dd

    xor a

jr_001_44dd:
    ld [$c151], a
    ret nz

    ld a, [CrouchingHeadTilted]
    cp $0a
    jr c, jr_001_44ed

    inc a
    cp $16
    jr c, jr_001_44ef

jr_001_44ed:
    ld a, $0a

jr_001_44ef:
    ld [CrouchingHeadTilted], a

Jump_001_44f2:
jr_001_44f2:
    ld [HeadSpriteIndex], a
    ret


    ld a, [$c151]
    inc a
    and $03
    ld [$c151], a
    ret nz

    ld a, [CrouchingHeadTilted]
    add c
    bit 7, a
    jr z, jr_001_450c

    ld a, $0b
    jr jr_001_4511

jr_001_450c:
    cp $0c
    jr c, jr_001_4511

    xor a

jr_001_4511:
    ld [CrouchingHeadTilted], a
    ld c, a
    cp $06
    jr c, jr_001_451b

    sub $06

jr_001_451b:
    add $4b
    ld [HeadSpriteIndex], a
    ld a, c
    cp $06
    ld a, $01
    jr c, jr_001_4529

    ld a, $ff

jr_001_4529:
    ld [$c147], a
    ret


    ld a, [$c177]
    or a
    ret nz

    ld a, [IsJumping]
    or a
    ret nz

    ld a, [$c17f]
    and $0f
    ret nz

    ld a, [LookingUp]
    or a
    jr nz, jr_001_454a

    ld [LookingUpAnimation], a
    dec a
    ld [LookingUp], a

jr_001_454a:
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_455b

    ld a, [LookingUpAnimation]
    cp $07
    ret z

    ld a, $07
    jr jr_001_4562

jr_001_455b:
    ld a, [LookingUpAnimation]
    inc a
    cp $10
    ret nc

jr_001_4562:
    ld [LookingUpAnimation], a
    call TrippleShiftRightCarry
    ld hl, $633a
    jr jr_001_45e1

Jump_001_456d:
    ld a, [JoyPadData]
    and $40
    ret nz

    ld a, [LookingUp]
    dec a
    ret z

    ld a, [LookingUpAnimation]
    or a
    jr z, jr_001_4581

    dec a
    jr nz, jr_001_4562

jr_001_4581:
    jp Jump_001_463b


    ld a, [$c175]
    or a
    ret nz

    ld a, [$c177]
    or a
    jr nz, jr_001_45a3

    ld a, [JoyPadData]
    and $30
    ret nz

    ld [CrouchingHeadTilted], a
    ld [IsCrouching], a
    ld [CrouchingHeadTiltTimer], a
    dec a
    ld [$c177], a
    ret


jr_001_45a3:
    ld a, [IsCrouching]
    ld c, a
    inc a
    cp $10
    jr c, jr_001_45e9
    ld a, [CrouchingAnimation]
    inc a
    ld [CrouchingAnimation], a
    cp $0c
    ld a, c
    jr c, jr_001_45e9
    ld a, $0c
    ld [CrouchingAnimation], a
    ld a, [LookingUp]
    or a
    jr nz, jr_001_45ca
    ld [CrouchingHeadTiltTimer], a
    inc a
    ld [LookingUp], a

jr_001_45ca:
    ld a, [CrouchingHeadTiltTimer]
    inc a
    and $1f
    ld [CrouchingHeadTiltTimer], a    ; Reset CrouchingHeadTiltTimer every 32 iterations.
    ret nz                            ; Continue every 32 iterations.
    ld a, [CrouchingHeadTilted]
    inc a
    and $1
    ld [CrouchingHeadTilted], a       ; Toggle CrouchingHeadTilted
    inc a
    ld hl, $6337
jr_001_45e1:
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [hl]
    jp Jump_001_44f2


jr_001_45e9:
    ld [IsCrouching], a
    call TrippleShiftRightCarry
    ld b, $00
    ld c, a
    ld hl, $6335
    add hl, bc
    ld a, [hl]
    ld [HeadSpriteIndex], a
    cp $3c
    ret nz

    ld b, $30
    call Call_000_1523
    ret nc

    ld a, c

Jump_001_4604:
    cp $1e
    jr z, jr_001_4612

    ld a, [NextLevel]
    cp $0a
    ret nz

    ld a, c
    cp $c1
    ret nz

jr_001_4612:
    ld a, [PlayerPositionYLsb]
    add $20
    ld [PlayerPositionYLsb], a
    ld a, [PlayerPositionYMsb]
    adc $00
    ld [PlayerPositionYMsb], a
    ld de, $0014
    call Call_001_4ae0
    ret


jr_001_4629:
    ld a, [JoyPadData]
    and $80
    ret nz

    ld a, [IsCrouching]
    or a
    jr z, jr_001_4638

    dec a
    jr nz, jr_001_45e9

jr_001_4638:
    ld [$c177], a

Jump_001_463b:
    ld [LookingUp], a
    ld [CrouchingAnimation], a
    ld c, a
    jp Jump_001_46cb


    ld a, [$c15b]
    and $01
    ret nz

    ld a, [$c1e5]
    and $df
    cp $06
    ret z

    and $01
    ret nz

    ld a, [$c169]
    or a
    ret nz

    ld a, [ProjectileFlying]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [$c177]
    or a
    jr nz, jr_001_4629

    ld a, [LookingUp]
    or a
    jp nz, Jump_001_456d

    ld a, [JoyPadData]
    and $30
    jr z, jr_001_468c

    ld a, [PlayerFreeze]
    or a
    jr nz, jr_001_468c

    ld a, [$c17f]
    and $0f
    jp nz, Jump_001_471f

    xor a
    ld [$c17b], a
    ret


jr_001_468c:
    ld a, [IsJumping]
    or a
    jp nz, Jump_001_4739

    ld a, [LandingAnimation]
    or a
    jp nz, Jump_001_4739

    call Call_001_46a0
    xor a
    inc a
    ret


Call_001_46a0:
    call Call_000_165e
    ld a, [$c156]
    cp $02
    jr z, jr_001_470e

    cp $03
    jr z, jr_001_470e

    cp $0a
    jr z, jr_001_470a

    cp $0b
    jr z, jr_001_470a

    ld a, [$c17f]
    or a
    jr nz, jr_001_471f

    ld a, [$c17d]
    and $80
    jr nz, jr_001_471f

    ld c, $00
    ld a, [$c149]
    or a
    jr z, jr_001_46ed

Call_001_46cb:
Jump_001_46cb:
jr_001_46cb:
    xor a
    ld [$c149], a        ; = 0
    ld [$c151], a        ; = 0
    ld [$c17d], a        ; = 0
    ld [$c17e], a        ; = 0
    ld [$c17f], a        ; = 0
    ld [$c169], a        ; = 0
    ld [$c173], a        ; = 0
    ld [$c174], a        ; = 0
    dec a
    ld [$c15c], a        ; = $ff
    xor a
    add c
    jp Jump_001_44f2

jr_001_46ed:
    ld c, $01
    ld a, [TimeCounter]
    and $7f
    ret nz

    ld a, [$c17b]
    inc a
    ld [$c17b], a
    cp $02
    jr z, jr_001_46cb

    cp $03
    ret nz

    xor a
    ld [$c17b], a
    ld c, a
    jr jr_001_46cb

jr_001_470a:
    ld a, $01
    jr jr_001_4710

jr_001_470e:
    ld a, $ff

jr_001_4710:
    ld [$c180], a
    ld [$c146], a
    ld a, $0c
    ld [$c17f], a
    ld a, $03
    jr jr_001_4741

Jump_001_471f:
jr_001_471f:
    ld a, [$c17f]
    dec a
    ld [$c17f], a
    call TrippleShiftRightCarry
    ld c, $00
    jr nz, jr_001_4741

    ld a, [IsJumping]
    or a
    jr nz, jr_001_4739

    ld a, [LandingAnimation]
    or a
    jr z, jr_001_46cb

Jump_001_4739:
jr_001_4739:
    xor a
    ld [$c17d], a
    ld [$c17f], a
    ret


jr_001_4741:
    ld b, $00
    ld c, a
    ld a, [IsJumping]
    or a
    jr nz, jr_001_476d

    ld a, [LandingAnimation]
    or a
    jr nz, jr_001_476d

    ld a, [TimeCounter]
    rra
    jr nc, jr_001_475b

    ld a, $10
    ld [$c501], a

jr_001_475b:
    ld hl, $638a
    ld a, [JoyPadData]
    and $30
    jr nz, jr_001_4768

    ld hl, $638e

jr_001_4768:
    add hl, bc
    ld a, [hl]
    ld [HeadSpriteIndex], a

jr_001_476d:
    ld a, c
    cp $02
    jr nz, jr_001_4779

    ld a, $80
    ld [$c17d], a
    jr jr_001_4782

jr_001_4779:
    cp $01
    jr nz, jr_001_4782

    ld a, [TimeCounter]
    rra
    ret c

jr_001_4782:
    ld a, [$c180]
    and $80
    jp nz, Jump_000_094a

    jp Jump_000_085e


    ld a, [IsJumping]
    or a
    ret nz

    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [$c149]
    cp $01
    ret z

    xor a
    ld [$c151], a
    ld [$c17e], a
    inc a
    ld [$c17d], a
    ld [$c149], a
    inc a
    ld [CrouchingHeadTilted], a
    jp Jump_001_44f2


Call_001_47b2:
Jump_001_47b2:
    xor a
    ld [$c170], a
    ld [$c169], a
    ld [$c13e], a
    dec a
    ld [LandingAnimation], a
    ld a, $02
    ld [$c149], a
    dec a
    ld [$c151], a
    jp Jump_000_1aeb


Jump_001_47cc:
    ld a, [LandingAnimation]
    or a
    ret z

    inc a
    ret z

    xor a
    ld [LandingAnimation], a
    ld [$c170], a
    ld c, a
    jp Jump_001_46cb


    ld a, [$c149]
    cp $03
    ret z

    xor a
    ld [$c151], a
    ld [CrouchingHeadTilted], a
    ld a, $03
    ld [$c149], a
    ld a, $4b
    jp Jump_001_44f2


    bit 0, b
    ret z

    ld a, [$c1e2]
    or a
    ret z

    ld a, [$c1df]
    or a
    ret nz

Call_001_4802:
    ld a, [PlayerFreeze]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [IsJumping]
    or a
    jr nz, jr_001_4878

    ld a, [LandingAnimation]
    or a
    jr nz, jr_001_4878

    ld a, [$c15b]
    rra
    jp c, Jump_001_48a0

    ld a, [$c169]
    or a
    jr nz, jr_001_48a0

    ld a, [$c15b]
    and $04
    ld [$c15b], a
    ld a, $02
    ld [$c501], a
    ld a, $0f
    ld [IsJumping], a
    ld a, $2b
    call Call_001_4896
    ld [$c156], a
    ld [$c13e], a
    ld [IsCrouching], a
    ld [CrouchingHeadTiltTimer], a
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_486c

    ld a, [$c17d]
    inc a
    jr z, jr_001_4864

    ld a, [$c17c]
    or a
    jr z, jr_001_486a

jr_001_485b:
    cp $02
    jr z, jr_001_486c

    inc a
    ld [$c174], a
    ret


jr_001_4864:
    ld a, [$c17c]
    or a
    jr nz, jr_001_485b

jr_001_486a:
    ld a, $01

jr_001_486c:
    ld [$c174], a
    cp $01
    ret nz

    ld a, $1f
    ld [$c173], a
    ret


jr_001_4878:
    ld a, [$c155]
    and $fe
    ld [$c155], a
    ret


Call_001_4881:
    ld a, $f0
    ld [IsJumping], a
    ld a, $04
    ld [$c501], a
    ld a, [NextLevel]
    cp $0b
    ld a, $39
    jr z, jr_001_4896

    ld a, $49

Call_001_4896:
jr_001_4896:
    ld [$c173], a
    xor a
    ld [$c149], a
    jp Jump_001_4ba9


Jump_001_48a0:
jr_001_48a0:
    ld a, [$c169]
    or a
    jr z, jr_001_48b4

    ld a, $80
    ld [$c169], a
    xor a
    ld [$c16b], a
    ld [$c16c], a
    ld c, $05

jr_001_48b4:
    ld a, [$c146]
    ld d, a
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_4917

    ld b, a
    ld d, $01
    bit 4, b
    jr nz, jr_001_48c8

    ld d, $ff

jr_001_48c8:
    ld a, [$c169]
    or a
    jr nz, jr_001_48dd

    ld a, [$c15b]
    cp $03
    jr nz, jr_001_4917

    ld a, [$c164]
    sub $04
    jr c, jr_001_4917

    ld c, a

jr_001_48dd:
    ld a, [$c15e]
    bit 4, b
    jr nz, jr_001_48ea

    cp $03
    jr nc, jr_001_4917

    jr jr_001_48ee

jr_001_48ea:
    cp $04
    jr c, jr_001_4917

jr_001_48ee:
    ld a, [$c169]
    or a
    jr nz, jr_001_48f9

    ld a, $04
    ld [$c15b], a

jr_001_48f9:
    ld a, $0f
    ld [IsJumping], a
    ld a, $03
    ld [$c174], a
    xor a
    ld [$c149], a
    ld b, a
    ld hl, $6127
    add hl, bc
    ld a, [hl]
    ld [$c173], a
    ld a, [$c169]
    or a
    ret nz

    jr jr_001_4931

jr_001_4917:
    xor a
    ld [$c170], a
    dec a
    ld [LandingAnimation], a
    ld a, $06
    ld [$c149], a
    ld a, [$c15b]
    or a
    ret z

    inc a
    and $04
    ld [$c15b], a
    jr z, jr_001_4937

jr_001_4931:
    ld a, [$c164]
    cp $04
    ret nc

jr_001_4937:
    ld a, [$c169]
    or a
    ret nz

    ld hl, $c165
    ld a, [hl+]
    ld h, [hl]
    and $f8
    ld l, a
    dec hl
    dec hl
    dec hl
    dec hl
    ld bc, $0014
    ld a, d
    and $80
    jr nz, jr_001_4951

    add hl, bc

jr_001_4951:
    ld a, l
    ld [PlayerPositionXLsb], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ret


    ld a, [IsJumping]
    and $0f
    jp z, Jump_001_4a03

    ld a, [JoyPadData]
    ld c, a
    ld a, [$c173]
    ld b, a
    ld a, [$c17c]
    or a
    ld a, b
    jr nz, jr_001_497e

    cp $20
    jr nz, jr_001_497e

    bit 0, c
    jr nz, jr_001_497e

    ld a, $0c
    ld [$c173], a

jr_001_497e:
    srl a
    ld c, a
    ld a, $15
    sub c
    ld b, $00
    ld c, a
    ld a, [$c174]
    add a
    ld d, $00
    ld e, a
    ld hl, $633c
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, [hl]
    ld [HeadSpriteIndex], a
    ld hl, $6344
    srl e
    add hl, de
    ld a, [$c173]
    or a
    jp z, Jump_001_4a43

    dec a
    ld [$c173], a
    srl a
    cp [hl]
    ret nc

    srl a
    srl a
    jr nz, jr_001_49be

    ld a, [$c174]
    or a
    jp z, Jump_001_4a43

    ld a, $01

jr_001_49be:
    cp $05
    jr c, jr_001_49c4

    ld a, $04

jr_001_49c4:
    call Call_001_4a3a
    call Call_000_1aeb
    ld a, [$c15b]
    or a
    ret nz

    ld a, [$c173]
    cp $12
    ret nc

    ld a, [PlayerPositionYMsb]
    or a
    jr nz, jr_001_49e1

    ld a, [PlayerPositionYLsb]
    cp $20
    ret c

jr_001_49e1:
    call Call_000_151d
    ld de, $ffe0
    jr c, jr_001_49ff

    call Call_000_1521
    ret nc

    ld a, c
    cp $1e
    jr z, jr_001_49fc

    ld a, [NextLevel]
    cp $0a
    ret nz

    ld a, c
    cp $c1
    ret nz

jr_001_49fc:
    ld de, $fff0

jr_001_49ff:
    call Call_001_4a6d
    ret


Jump_001_4a03:
    ld a, [IsJumping]
    and $f0
    ret z

    ld a, [$c173]
    srl a
    srl a
    ld c, a
    ld a, $15
    sub c
    ld b, $00
    ld c, a
    ld hl, $6348
    add hl, bc
    ld a, [hl]
    ld [HeadSpriteIndex], a
    ld a, [$c173]
    or a
    jr z, jr_001_4a43

    dec a
    ld [$c173], a
    srl a
    srl a
    cp $12
    ret nc

    srl a
    inc a
    inc a
    cp $09
    jr c, jr_001_4a3a

    ld a, $08

Call_001_4a3a:
jr_001_4a3a:
    push af
    call Call_000_0e26
    pop af
    dec a
    jr nz, jr_001_4a3a

    ret


Jump_001_4a43:
jr_001_4a43:
    ld [IsJumping], a
    jp Jump_001_47b2


    ld a, [$c175]
    or a
    ret z

    dec a
    ld [$c175], a
    srl a
    srl a
    jr z, jr_001_4a62

    call Call_001_4a3a
    ld a, [$c1c9]
    or a
    jp nz, Jump_001_4e4e

jr_001_4a62:
    ld a, [$c176]
    and $80
    jp nz, Jump_000_094a

    jp Jump_000_085e


Call_001_4a6d:
    ld a, c
    cp $1e
    jr z, jr_001_4ae0

    cp $c1
    jr z, jr_001_4ae0

    ld c, $3f
    cp $c7
    jr c, jr_001_4a7e

    ld c, $c7

jr_001_4a7e:
    sub c
    add a
    add a
    ld c, a
    ld d, a
    xor a
    call Call_001_4ba0
    ld b, a
    dec a
    ld [$c15c], a
    ld a, $01
    ld [$c169], a
    ld hl, $61ff
    add hl, bc
    ld a, [PlayerPositionXLsb]
    ld e, a
    ld c, $02
    and $0f
    cp $04
    jr c, jr_001_4ab5

    inc b
    ld c, $06
    inc hl
    cp $08
    jr c, jr_001_4ab5

    inc b
    ld c, $0a
    inc hl
    cp $0c
    jr c, jr_001_4ab5

    inc b
    ld c, $0e
    inc hl

jr_001_4ab5:
    ld a, e
    and $f0
    add c
    ld [PlayerPositionXLsb], a
    ld a, [PlayerPositionYLsb]
    and $f0
    add [hl]
    ld [PlayerPositionYLsb], a
    ld a, d
    add b
    ld [$c16a], a
    ld a, $26
    ld [HeadSpriteIndex], a
    ld a, $03
    ld [$c15e], a
    inc a
    ld [$c15f], a
    ld a, [$c146]
    ld [$c160], a
    pop bc
    ret


Call_001_4ae0:
jr_001_4ae0:
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $fff8
    add hl, bc
    ld a, l
    and $f0
    bit 4, a
    ret nz

    add $0e
    ld l, a
    ld [PlayerPositionXLsb], a
    ld [$c165], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ld [$c166], a
    push hl
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld [$c167], a
    ld a, h
    ld [$c168], a
    add hl, de
    ld a, h
    and $0f
    swap a
    ld d, a
    ld a, l
    and $f0
    swap a
    or d
    ld d, a
    pop hl
    srl h
    rr l
    ld a, h
    and $0f
    swap a
    ld e, a
    ld a, l
    and $f0
    swap a
    or e
    ld e, a
    ld hl, $c1da
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$c1d6]
    ld b, a
    ld c, a

jr_001_4b39:
    ld a, [hl+]
    cp e
    jr nz, jr_001_4b48

    ld a, [hl]
    cp d
    jr z, jr_001_4b4d

    jr nc, jr_001_4b48

    add $05
    cp d
    jr nc, jr_001_4b4d

jr_001_4b48:
    inc hl
    dec b
    jr nz, jr_001_4b39

    ret


jr_001_4b4d:
    ld a, c
    sub b
    ld c, a
    ld a, [$c15c]
    cp c
    ret z

    ld a, c
    call Call_000_2382
    ret nz

    ld a, c
    ld [$c15c], a
    call Call_001_4b96
    inc a
    ld [$c15b], a
    pop bc
    ld a, [PlayerPositionYLsb]
    and $0f
    srl a
    srl a
    ld e, a
    ld a, [hl]
    add a
    ld [$c15d], a
    ld a, d
    sub [hl]
    jr c, jr_001_4b8c

    add a
    add a
    or e
    cp $10
    jr c, jr_001_4b82

    ld a, $0f

jr_001_4b82:
    ld [$c164], a
    ld a, [JoyPadData]
    and $30
    jr nz, jr_001_4bb9

jr_001_4b8c:
    ld a, $03
    ld [$c149], a
    ld a, $4b
    jp Jump_001_44f2


Call_001_4b96:
    xor a
    ld [$c15b], a
    ld [$c169], a
    ld [$c164], a

Call_001_4ba0:
    ld [$c17f], a
    ld [$c17d], a
    ld [IsJumping], a

Jump_001_4ba9:
    ld [$c174], a
    ld [LandingAnimation], a
    ld [$c170], a
    ld [$c177], a
    ld [LookingUp], a
    ret


jr_001_4bb9:
    ld a, [$c15c]
    add a
    add a
    add a
    ld b, $00
    ld c, a
    ld a, $03
    ld [$c15b], a
    ld [$c15e], a
    ld [$c163], a
    inc a
    ld [$c149], a
    ld a, [$c1d7]
    inc a
    and $01
    ld [$c1d7], a
    ld de, $c1d8
    add e
    ld e, a
    ld hl, $c660
    add hl, bc
    ld a, l
    ld [de], a
    set 7, [hl]
    inc l
    inc l
    inc l
    ld a, [$c146]
    ld [hl], a
    ld a, $26
    jp Jump_001_44f2


    ld a, [$c145]
    cp $c8
    ret nc

    ld a, [$c1e5]
    or a
    ret nz

    ld a, [IsJumping]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [$c15b]
    and $01
    ret nz

    ld a, [$c169]
    and $7f
    ret nz

    ld a, [PlayerPositionYMsb]
    or a
    jr nz, jr_001_4c21

    ld a, [PlayerPositionYLsb]
    cp $20
    jr c, jr_001_4c4b

jr_001_4c21:
    ld a, [LandingAnimation]
    inc a
    jr nz, jr_001_4c4b

    call Call_000_151d
    ld de, $ffe0
    jr c, jr_001_4c48

    call Call_000_1521
    jr nc, jr_001_4c4b

    ld a, c
    cp $1e
    jr z, jr_001_4c45

    ld a, [NextLevel]
    cp $0a
    jr nz, jr_001_4c4b

    ld a, c
    cp $c1
    jr nz, jr_001_4c4b

jr_001_4c45:
    ld de, $fff0

jr_001_4c48:
    call Call_001_4a6d

jr_001_4c4b:
    call Call_000_165e
    jp nc, Jump_001_4d5d

    cp $11
    jr z, jr_001_4c63

    ld c, a
    ld a, [$c158]
    or a
    jr nz, jr_001_4c63

    ld a, b
    sub c
    cp $08
    jp nc, Jump_001_4dbb

jr_001_4c63:
    ld a, [LandingAnimation]
    or a
    jp z, Jump_001_4cf1

    inc a
    jr nz, jr_001_4c79

    ld a, [$c170]
    cp $08
    jr c, jr_001_4c79

    ld a, $03
    ld [$c501], a

jr_001_4c79:
    ld a, [$c156]
    cp $0c
    jr nz, jr_001_4c88

    ld a, $02
    ld [$c1dc], a
    jp Jump_001_4d5d


jr_001_4c88:
    ld a, [$c1dc]
    or a
    jp nz, Jump_001_4d5d

    ld a, [$c170]
    ld [LandingAnimation], a
    or a
    jr z, jr_001_4cf1

    ld c, a
    ld b, $06
    ld a, [$c17d]
    or a
    jr z, jr_001_4cd8

    inc a
    jr nz, jr_001_4ca6

    ld b, $0e

jr_001_4ca6:
    ld a, c
    dec a
    ld [$c170], a
    cp $1b
    jr c, jr_001_4cb3

    ld a, $16
    jr jr_001_4cb4

jr_001_4cb3:
    ld a, b

jr_001_4cb4:
    ld [HeadSpriteIndex], a

jr_001_4cb7:
    xor a
    ld [LandingAnimation], a
    ld [$c170], a
    ld [$c173], a
    ld [$c174], a
    ld [$c169], a
    inc a
    ld [$c149], a
    jr jr_001_4cf1

jr_001_4ccd:
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_4cb7

    ld a, $06
    jr jr_001_4cb4

Jump_001_4cd8:
jr_001_4cd8:
    ld a, c
    dec a
    ld [$c170], a
    call TrippleShiftRightCarry
    jr z, jr_001_4ccd

    dec a
    jr z, jr_001_4ccd

    dec a
    ld b, $00
    ld c, a
    ld hl, $6388
    add hl, bc
    ld c, [hl]
    call Call_001_46cb

Jump_001_4cf1:
jr_001_4cf1:
    ld c, $00
    ld a, [$c156]
    cp $02
    jr c, jr_001_4d0c

    ld c, $02
    cp $04
    jr c, jr_001_4d0c

    cp $0b
    jr z, jr_001_4d0c

    cp $0a
    jr z, jr_001_4d0c

    dec c
    jr c, jr_001_4d0c

    dec c

jr_001_4d0c:
    ld a, c
    ld [$c17c], a

jr_001_4d10:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    dec hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    push hl
    call Call_000_165e
    jr c, jr_001_4d31

jr_001_4d26:
    pop de
    pop hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ret


jr_001_4d31:
    ld c, a
    ld a, [$c158]
    or a
    jr nz, jr_001_4d49

    ld a, [$c156]
    cp $0c
    jr c, jr_001_4d49

    cp $10
    jr nc, jr_001_4d49

    ld a, b
    sub c
    cp $04
    jr nc, jr_001_4d26

jr_001_4d49:
    pop hl
    pop de
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    sub c
    ld [$c145], a
    cp $48
    jr nc, jr_001_4d10

    call Call_000_123d
    jr jr_001_4d10

Jump_001_4d5d:
    ld a, [LandingAnimation]
    inc a
    jr z, jr_001_4dcf

    ld a, [$c158]
    or a
    jr nz, jr_001_4d7a

    ld b, $04
    call Call_000_1660
    jr c, jr_001_4d7a

    ld a, [$c156]
    or a
    jr z, jr_001_4dc1

    ld a, b
    or a
    jr z, jr_001_4dc1

jr_001_4d7a:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    inc hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    push hl
    ld b, $ff
    call Call_000_1660
    jr nc, jr_001_4da7

    pop de
    pop hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ld a, [$c170]
    or a
    jp z, Jump_001_47cc

    ld c, a
    jp Jump_001_4cd8


jr_001_4da7:
    pop hl
    pop de
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    sub c
    ld [$c145], a
    cp $58
    jr c, jr_001_4d7a

    call Call_000_134c
    jr jr_001_4d7a

Jump_001_4dbb:
    ld a, [LandingAnimation]
    or a
    jr nz, jr_001_4dcf

jr_001_4dc1:
    call Call_001_47b2
    ld a, [$c1c9]
    or a
    jr nz, jr_001_4dcf

    ld a, $45
    ld [HeadSpriteIndex], a

jr_001_4dcf:
    ld a, [$c170]
    inc a
    cp $20
    jr nc, jr_001_4dda

    ld [$c170], a

jr_001_4dda:
    call TrippleShiftRightCarry
    ret z

    push af
    inc a
    ld b, a
    call Call_000_1660
    pop bc
    ld c, b
    jr nc, jr_001_4dea

    ld b, $01

jr_001_4dea:
    push bc
    call Call_000_0f0d
    pop bc
    dec b
    jr nz, jr_001_4dea

    ld a, [NextLevel]
    cp $0b
    jr z, jr_001_4e05

    ld a, [PlayerFreeze]
    or a
    jr nz, jr_001_4e4e

    ld a, [$c1c9]
    or a
    jr nz, jr_001_4e4e

jr_001_4e05:
    ld a, [$c1dc]
    or a
    jr nz, jr_001_4e38

    ld a, [$c174]
    cp $01
    jr z, jr_001_4e32

    dec c
    jr nz, jr_001_4e1b

    ld a, [HeadSpriteIndex]
    cp $45
    ret z

jr_001_4e1b:
    ld hl, $6378

jr_001_4e1e:
    add hl, bc
    ld a, [hl]
    ld [HeadSpriteIndex], a
    ld a, [$c174]
    cp $03
    ret nz

    ld a, c
    cp $03
    ret c

    xor a
    ld [$c174], a
    ret


jr_001_4e32:
    dec c
    ld hl, $637d
    jr jr_001_4e1e

jr_001_4e38:
    ld c, $da
    ld a, [NextLevel]
    dec a
    jr z, jr_001_4e42

    ld c, $5a

jr_001_4e42:
    ld a, [PlayerPositionYLsb]
    cp c
    ret c

    ld a, c
    ld [PlayerPositionYLsb], a
    jp Jump_001_52ce


Jump_001_4e4e:
jr_001_4e4e:
    ld a, [$c151]
    or a
    jr z, jr_001_4e59

    dec a
    ld [$c151], a
    ret nz

jr_001_4e59:
    ld a, $04
    ld [$c151], a
    ld a, [CrouchingHeadTilted]
    inc a
    cp $06
    jr c, jr_001_4e67

    xor a

jr_001_4e67:
    ld [CrouchingHeadTilted], a
    ld b, $00
    ld c, a
    ld hl, $6382
    add hl, bc
    ld a, [hl]
    and $1f
    ld [HeadSpriteIndex], a
    ld a, $01
    bit 7, [hl]
    jr z, jr_001_4e7f

    ld a, $ff

jr_001_4e7f:
    ld [$c146], a
    ret


    ld c, a
    ld a, [$c149]
    or a
    ret z

    ld a, [$c169]
    or a
    ret nz

    ld a, [$c15b]
    and $01
    ret nz

    ld a, [IsJumping]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [LookingUp]
    or a
    ret nz

    ld a, [$c157]
    or a
    jr nz, jr_001_4ec8

    ld a, [$c146]
    ld b, a
    ld a, [$c156]
    or a
    jr z, jr_001_4ed2

    cp $0c
    jr nc, jr_001_4ed2

    cp $07
    jr nc, jr_001_4eec

    cp $02
    jr c, jr_001_4ed2

    bit 7, b
    jr nz, jr_001_4ef0

jr_001_4ec8:
    ld a, $01
    ld [$c17d], a
    xor a
    ld [$c17f], a
    ret


jr_001_4ed2:
    ld a, [$c17d]
    inc a
    jr nz, jr_001_4ede

    ld a, [$c17e]
    or a
    jr z, jr_001_4ec8

jr_001_4ede:
    bit 1, c
    jr nz, jr_001_4ef6

    ld a, [$c17e]
    or a
    ret z

    dec a
    ld [$c17e], a
    ret


jr_001_4eec:
    bit 7, b
    jr nz, jr_001_4ec8

jr_001_4ef0:
    ld a, c
    and $30
    ret z

    jr jr_001_4f06

jr_001_4ef6:
    ld a, c
    and $30
    ret z

    ld a, [$c17e]
    inc a
    cp $0a
    jr nc, jr_001_4f06

    ld [$c17e], a
    ret


jr_001_4f06:
    ld a, [$c17d]
    inc a
    ret z

    ld a, $ff
    ld [$c17d], a
    ld a, $09
    ld [$c17e], a
    ld a, $10
    ld [$c17f], a
    ld a, [$c146]
    ld [$c180], a
    ret


    ld a, [NextLevel]
    dec a
    ld b, $00
    ld c, a
    ld hl, $6133
    add hl, bc
    ld a, [hl]
    ld [$c1d6], a
    sla c
    ld hl, $613f
    add hl, bc
    ld a, [hl+]
    ld [$c1da], a
    ld a, [hl]
    ld [$c1db], a
    ld hl, $c660
    ld b, $80
    jp MemsetZero2


Call_001_4f46:
    ld a, [$c118]
    ld b, a
    ld a, [$c117]
    srl b
    rra
    ld c, a
    ld a, [$c11c]
    ld b, a
    ld a, [hl+]
    sub c
    add a
    bit 7, a
    jr z, jr_001_4f62

    cp $fd
    jr c, jr_001_4fd1

    jr jr_001_4f66

jr_001_4f62:
    cp $0d
    jr nc, jr_001_4fd1

jr_001_4f66:
    dec a
    ld c, a
    ld a, [$c117]
    and $01
    xor $01
    add c
    add a
    ld c, a
    ld a, [$c11d]
    and $01
    xor $01
    add c
    ld c, a
    ld a, [hl]
    sub b
    bit 7, a
    jr z, jr_001_4f87

    cp $fd
    jr c, jr_001_4fd1

    jr jr_001_4f8b

jr_001_4f87:
    cp $0b
    jr nc, jr_001_4fd1

jr_001_4f8b:
    add a
    push af
    ld a, [$c122]
    and $01
    ld b, a
    pop af
    sub b
    ld b, a
    ld a, [de]
    bit 4, a
    ret nz

    or $10
    ld [de], a
    inc e
    ld a, $04
    ld [de], a
    dec a
    inc e
    ld [de], a
    inc e
    inc e
    xor a
    ld [de], a
    inc e
    ld a, $06
    ld [de], a
    inc e
    ld a, [$c11d]
    add c
    and $1f
    ld c, a
    ld a, [$c122]
    add b
    and $1f
    ld b, a
    xor a
    srl b
    rra
    srl b
    rra
    srl b
    rra
    add c
    ld c, a
    ld hl, $9800
    add hl, bc
    ld a, l
    ld [de], a
    inc e
    ld a, h
    ld [de], a
    ret


jr_001_4fd1:
    xor a
    ld [de], a
    ret


    ld a, [$c15b]
    or a
    ret z

    ld hl, $c660
    ld a, [$c1d6]
    or a
    ret z

    ld b, a
    ld c, $00

jr_001_4fe4:
    push bc
    push hl
    ld a, c
    ld [WindowScrollYLsb], a
    ld a, [$c15c]
    cp c
    jr nz, jr_001_5004

    ld a, [$c15b]
    and $0f
    ld b, a
    ld a, [hl]
    and $f0
    jr nz, jr_001_500f

    ld a, [hl]
    or a
    jr z, jr_001_500f

    ld [$c15b], a
    jr jr_001_5011

jr_001_5004:
    ld a, [hl]

Call_001_5005:
    and $fe
    bit 7, a
    jr z, jr_001_5010

    or $04
    jr jr_001_5010

jr_001_500f:
    or b

jr_001_5010:
    ld [hl], a

jr_001_5011:
    push hl
    ld b, $00
    sla c
    ld hl, $c1da
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    pop de
    push de
    call Call_001_4f46
    pop hl
    call Call_001_5031
    pop hl
    pop bc
    ld a, l
    add $08
    ld l, a
    inc c
    dec b
    jr nz, jr_001_4fe4

    ret


Call_001_5031:
    bit 7, [hl]
    ret z

    ld c, $01
    rst $08
    or a
    jr z, jr_001_503c

    rst $20
    ret nz

jr_001_503c:
    bit 6, [hl]
    ret nz

    set 6, [hl]
    inc c
    rst $08
    ld d, a
    inc c
    rst $08
    ld e, a
    ld a, d
    and $0f
    add e
    ld b, a
    ld a, d
    and $0f
    swap a
    or b
    ld d, b
    dec c
    rst $10
    ld a, d
    ld c, $04
    bit 7, e
    jr nz, jr_001_505d

    inc c

jr_001_505d:
    rst $28
    jr nz, jr_001_509f

    ld c, $03
    rst $08
    cpl
    inc a
    rst $10
    ld a, [hl]
    and $04
    jr z, jr_001_509f

    inc c
    rst $08
    cp $03
    jr z, jr_001_5080

    inc a
    rst $10
    inc c
    rst $08
    cp $03
    jr z, jr_001_5080

    dec a
    rst $10
    ld c, $01
    ld a, c
    rst $10
    ret


jr_001_5080:
    ld c, $04
    xor a
    rst $10
    inc c
    ld a, $06
    rst $10
    ld c, $01
    rst $10
    ld a, [hl]
    ld b, a
    and $71
    ld [hl], a
    and $01
    jr nz, jr_001_509b

    ld a, [$c15b]
    and $01
    ret nz

    xor a

jr_001_509b:
    ld [$c15b], a
    ret


jr_001_509f:
    push hl
    ld b, $00
    ld c, d
    ld hl, $6005
    add hl, bc
    ld a, [hl]
    pop hl
    ld c, $01
    rst $10
    ld a, [hl]
    and $03
    cp $03
    ret nz

    ld c, d
    ld a, c
    cp $03
    jr nz, jr_001_50d6

    ld a, [JoyPadData]
    and $30
    jr z, jr_001_50d6

    ld b, a
    ld a, [$c146]
    bit 7, a
    jr z, jr_001_50cd

    bit 4, b
    jr z, jr_001_50d6

    jr jr_001_50d1

jr_001_50cd:
    bit 5, b
    jr z, jr_001_50d6

jr_001_50d1:
    cpl
    inc a
    ld [$c146], a

Jump_001_50d6:
jr_001_50d6:
    ld a, [$c146]
    and $80
    jr nz, jr_001_50e0

    ld a, c
    jr jr_001_50e3

jr_001_50e0:
    ld a, $06
    sub c

jr_001_50e3:
    add $23
    ld [HeadSpriteIndex], a
    ld a, c
    ld [$c15e], a
    ret


    ld a, [$c169]
    cp $01
    jr z, jr_001_5136

    cp $02
    ret nz

    ld a, [$c146]
    and $02
    rra
    ld c, a
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_510f

    swap a
    dec a
    cp c
    ret z

    cpl
    inc a
    jr nz, jr_001_510f

    inc a

jr_001_510f:
    ld [$c161], a
    ld a, [$c15e]
    or a
    jr z, jr_001_5123

    ld a, [$c146]
    and $80
    jp z, Jump_000_0a1b

    jp Jump_000_0b58


jr_001_5123:
    ld a, $01
    ld [$c169], a
    ld [$c15f], a
    ld a, $03
    ld [$c15e], a
    ld a, [$c146]
    ld [$c160], a

jr_001_5136:
    ld hl, $c15f
    dec [hl]
    ret nz

    ld a, [PlayerFreeze]
    or a
    jr nz, jr_001_514b

    ld de, $0205
    ld a, [JoyPadData]
    and $30
    jr nz, jr_001_514e

jr_001_514b:
    ld de, $0304

jr_001_514e:
    ld a, [$c160]
    ld b, a
    ld a, [$c15e]
    add b
    ld c, a
    bit 7, b
    jr z, jr_001_5163

    cp d
    jr nc, jr_001_516c

    ld a, b
    cpl
    inc a
    jr jr_001_5169

jr_001_5163:
    cp e
    jr c, jr_001_516c

    ld a, b
    cpl
    inc a

jr_001_5169:
    ld [$c160], a

jr_001_516c:
    ld b, $00
    ld hl, $6005
    ld a, d
    cp $02
    jr z, jr_001_5179

    ld hl, $600c

jr_001_5179:
    add hl, bc
    ld a, [hl]
    ld [$c15f], a
    jp Jump_001_50d6


    ld a, [$c163]
    ld b, $00
    ld c, a
    push bc
    ld hl, $60b7
    swap a
    and $f0
    ld c, a
    add hl, bc
    ld a, [$c164]
    ld c, a
    add hl, bc
    ld d, $00
    ld e, [hl]
    bit 7, e
    jr z, jr_001_519e

    dec d

jr_001_519e:
    ld hl, $c165
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, de
    ld a, l
    ld [PlayerPositionXLsb], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ld a, c
    sub $0d
    jr c, jr_001_51d5

    ld c, a
    ld hl, $60a2
    add a
    ld d, a
    add a
    add d
    add c
    ld c, a
    add hl, bc
    pop bc
    add hl, bc
    ld c, [hl]
    bit 7, c
    jr z, jr_001_51c5

    dec b

jr_001_51c5:
    ld hl, $c167
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ret


jr_001_51d5:
    pop bc
    ld c, b
    jr jr_001_51c5

    ld h, $c6
    ld a, [$c1d8]
    ld l, a
    ld a, [hl]
    and $50
    cp $50
    jr z, jr_001_51f3

    ld a, [$c1d9]
    ld l, a
    ld a, [hl]
    and $50
    cp $50
    jr z, jr_001_51f3

    and a
    ret


jr_001_51f3:
    res 6, [hl]
    inc l
    inc l
    ld c, [hl]
    ld a, l
    add $04
    ld l, a
    ld e, [hl]
    ld a, e
    inc l
    ld d, [hl]
    push bc
    push de
    ld a, c
    swap a
    and $0f
    add a
    ld c, a
    ld b, $00
    ld hl, $6013
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld b, [hl]
    dec b
    ld a, e
    add $20
    ld e, a
    inc hl
    inc hl
    inc hl
    inc hl

jr_001_521c:
    ld c, [hl]
    inc hl
    inc hl
    bit 7, c
    jr z, jr_001_522c

    ld a, e
    add c
    ld c, e
    ld e, a
    jr c, jr_001_5233

    dec d
    jr jr_001_5233

jr_001_522c:
    ld a, e
    add c
    ld c, e
    ld e, a
    jr nc, jr_001_5233

    inc d

jr_001_5233:
    ld a, c
    xor e
    and $10
    jr z, jr_001_5253

    ld a, e
    bit 4, c
    jr nz, jr_001_5249

    bit 3, c
    jr nz, jr_001_5253

    add $20
    jr nc, jr_001_5252

    inc d
    jr jr_001_5252

jr_001_5249:
    bit 3, c
    jr z, jr_001_5253

    sub $20
    jr nc, jr_001_5252

    dec d

jr_001_5252:
    ld e, a

jr_001_5253:
    ld a, d
    cp $9c
    jr c, jr_001_525a

    ld d, $98

jr_001_525a:
    ld c, $03
    ld a, [NextLevel]
    cp $0a
    jr nz, jr_001_5265

    ld c, $01

jr_001_5265:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5265

    ld a, c
    ld [de], a
    dec b
    jr nz, jr_001_521c

    pop de
    pop bc
    ld a, c
    and $0f
    add a
    ld c, a
    ld b, $00
    ld hl, $6013
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld b, [hl]
    inc hl

jr_001_5282:
    ld a, [hl+]
    push af
    ld c, [hl]
    inc hl
    bit 7, c
    jr z, jr_001_5293

    ld a, e
    add c
    ld c, e
    ld e, a
    jr c, jr_001_529a

    dec d
    jr jr_001_529a

jr_001_5293:
    ld a, e
    add c
    ld c, e
    ld e, a
    jr nc, jr_001_529a

    inc d

jr_001_529a:
    ld a, c
    xor e
    and $10
    jr z, jr_001_52ba

    ld a, e
    bit 4, c
    jr nz, jr_001_52b0

    bit 3, c
    jr nz, jr_001_52ba

    add $20
    jr nc, jr_001_52b9

    inc d
    jr jr_001_52b9

jr_001_52b0:
    bit 3, c
    jr z, jr_001_52ba

    sub $20
    jr nc, jr_001_52b9

    dec d

jr_001_52b9:
    ld e, a

jr_001_52ba:
    ld a, d
    cp $9c
    jr c, jr_001_52c1

    ld d, $98

jr_001_52c1:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_52c1

    pop af
    ld [de], a
    dec b
    jr nz, jr_001_5282

    scf
    ret


Jump_001_52ce:
    ld a, [$c1dc]
    and $01
    ret nz

    ld a, $05
    ld [HeadSpriteIndex], a
    ld hl, $c200
    ld c, $05

jr_001_52de:
    rst $08
    cp $ae
    jr z, jr_001_52ea

    ld a, l
    add $20
    ld l, a
    jr nc, jr_001_52de

    ret


jr_001_52ea:
    set 6, [hl]
    ld bc, $000c
    add hl, bc
    ld [hl], $1b
    ld a, $81
    jr jr_001_5306

    ld a, [$c1dc]
    and $01
    ret z

    ld a, $0f
    ld [$c501], a
    call Call_001_4881
    ld a, $80

jr_001_5306:
    ld [$c1dc], a
    ld hl, $9938
    ld a, [PlayerPositionXMsb]
    or a
    jr z, jr_001_531c

    ld hl, $9b36
    cp $02
    jr z, jr_001_531c

    ld hl, $9b32

jr_001_531c:
    ld a, l
    ld [$c1dd], a
    ld a, h
    ld [$c1de], a
    ret


    ld a, [$c1dc]
    and $01
    ld [$c1dc], a
    ld c, $1b
    ld hl, $c1dd
    ld de, $5366
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jr nz, jr_001_533d

    ld de, $535a

jr_001_533d:
    ld b, $06
    call Call_001_5353
    add hl, bc
    ld a, [de]
    ld [hl+], a
    inc hl
    inc hl
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    add hl, bc
    call Call_001_5351
    inc hl
    inc hl

Call_001_5351:
    ld b, $02

Call_001_5353:
jr_001_5353:
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_001_5353

    ret


    ld [hl], b
    ld [hl], c
    ld [hl], d
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [hl], e
    ld [bc], a
    ld [bc], a
    ld [hl], h
    ld [hl], l
    ld [bc], a
    ld [bc], a
    ld [bc], a
    db $76
    ld [hl], a
    ld a, b
    ld a, c
    ld [bc], a
    ld a, d
    ld a, e
    ld [bc], a
    ld [bc], a
    call DrawNewHorizontalTiles
    ret nz
    call DrawNewVerticalTiles
    ret nz

    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5384

    cp $05
    ret nz

jr_001_5384:
    ld a, [$c1cf]
    or a
    ret z

    ld hl, $9c20
    and $80
    jr nz, jr_001_5397

    ld a, [$c121]
    add $14
    jr jr_001_539b

jr_001_5397:
    ld a, [$c121]
    dec a

jr_001_539b:
    ld b, $00
    and $1f
    ld c, a
    add hl, bc
    ld a, h
    cp $a0
    jr c, jr_001_53ab

    sub $a0
    add $9c
    ld h, a

jr_001_53ab:
    ld de, $c3f0
    ld bc, $0020
    ld a, $04

jr_001_53b3:
    push af

jr_001_53b4:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_53b4

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    pop af
    dec a
    jr nz, jr_001_53b3

    ld [$c1cf], a
    ret

; $153c6:: Copies 20 bytes/tiles from $c3c0 to the corresponding position in tile map.
; The position is given by the pointer in "hl".
; The copied tiles form a vertical line from top to bottom.
; Returns 0 if no tiles were copied. Returns 1 if tiles were copied.
; See also: DrawNewHorizontalTiles.
DrawNewVerticalTiles:
    ld a, [NeedNewVerticalTiles]       ; Need to draw new tiles?
    or a
    ret z                              ; Return if no tiles needed
    push af
    ld hl, _SCRN0                      ; Tile map base.
    ld a, [$c123]
    dec a
    and %11111
    ld c, 0
    srl a                              ; Shift bit 0 into carry.
    rr c                               ; Rotate carry into bit 7.
    srl a                              ; Shift bit 0 into carry.
    rr c                               ; Rotate carry into bit 7.
    srl a                              ; Shift bit 0 into carry.
    rr c                               ; Rotate carry into bit 7.
    ld b, a                            ; b = (([$c123] - 1) & %11000) >> 3; c = (([$c123] - 1) & %111) << 5
    add hl, bc
    ld a, h
    cp $9c                             ; Check if index would wrap around.
    jr c, :+
    sub $9c
    add $98                            ; Wraparound to start of tile map.
    ld h, a
:   pop af
    and $80
    jr nz, jr_001_53fb
    ld a, [$c11e]
    add $14
    jr jr_001_53ff
jr_001_53fb:
    ld a, [$c11e]
    dec a
jr_001_53ff:
    ld b, 0
    and $1f
    ld c, a
    add hl, bc
    ld a, h
    cp $9c                      ; Check if index would wrap around.
    jr c, :+
    sub $9c
    add $98                     ; Wraparound to start of tile map.
    ld h, a
 :  ld de, $c3c0                ; Source memory region.
    ld bc, $0020                ; Line width
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 0).
    add hl, bc                  ; Next tile in Y-direction.
    ld a, h
    cp $9c                      ; Check if we exceed tile map ($9c00 is behind tile map).
    jr c, :+
    ld h, $98                   ; Wraparound if exceeded ($9800) is the first tile.
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 1).
    add hl, bc                  ; Next tile in Y-direction.
    ld a, h
    cp $9c                      ; Check if we exceed tile map ($9c00 is behind tile map).
    jr c, :+
    ld h, $98                   ; Wraparound if exceeded ($9800) is the first tile.
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 2).
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 3)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 4)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 5)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 6)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 7)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 8)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                   ; Write into background tile index map (Tile 9)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 10)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 11)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 12)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 13)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 14)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]                  ; Write into background tile index map (Tile 15)
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 16)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 17)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 18)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 19)
    add hl, bc
    ld a, h
    cp $9c
    jr c, :+
    ld h, $98
 :  xor a
    ld [NeedNewVerticalTiles], a  ; = 0
    inc a                         ; a = 1
    ret

; $1556f:: Copies bytes/tiles from $c3d8 to the corresponding position in tile map.
; The position is given by the pointer in "hl".
; The copied tiles form a horizontal line.
; Returns 0 if no tiles were copied. Returns 1 if tiles were copied.
; See also: DrawNewVerticalTiles.
DrawNewHorizontalTiles:
    ld a, [NeedNewHorizontalTiles]
    or a
    ret z
    push af
    ld h, $98
    ld a, [$c11f]
    dec a
    and $1f
    ld l, a
    pop af
    and $80
    jr nz, jr_001_558a
    ld a, [$c124]
    add $12
    jr jr_001_558e
jr_001_558a:
    ld a, [$c124]
    dec a
jr_001_558e:
    and $1f
    ld c, $00
    srl a
    rr c
    srl a
    rr c
    srl a
    rr c
    ld b, a
    add hl, bc
    ld de, $c3d8
    ld bc, $ffe0
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 0.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 1.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 2.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 3.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 4.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 5.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 6.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 7.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 8.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 9.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 10.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 11.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 12.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 13.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 14.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 15.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 16.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 17.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 18.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 19.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 20.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl+], a                 ; Copy Tile 21.
    ld a, l
    and $1f
    jr nz, :+
    add hl, bc
:   xor a
    ld [NeedNewHorizontalTiles], a  ; = 0.
    inc a
    ret
    ld a, [$c1e5]
    or a
    ret z

    and $df
    cp $01
    jr z, jr_001_5712

    cp $03
    jr z, jr_001_574c

    cp $05
    jr nz, jr_001_5768

    ld b, a
    ld a, [$c1e8]
    or a
    jp z, Jump_001_5848

    ld a, b

jr_001_5712:
    push af
    call Call_000_085e
    call Call_000_1889
    pop bc
    ld a, [PlayerPositionXLsb]
    cp $7c
    ret c

    xor a
    ld [HeadSpriteIndex], a
    ld a, b
    cp $05
    jr z, jr_001_5735

    ld a, $ff
    ld [$c146], a
    ld a, $01
    ld [$c1e7], a
    jr jr_001_5760

jr_001_5735:
    ld a, $08
    ld [$c151], a
    xor a
    ld [CrouchingHeadTilted], a
    ld [IsCrouching], a
    dec a
    ld [CrouchingHeadTiltTimer], a
    ld a, $3e
    ld [HeadSpriteIndex], a
    jr jr_001_5760

jr_001_574c:
    call Call_000_094a
    call Call_000_1889
    ld a, [PlayerPositionXLsb]
    cp $28
    ret nc

    xor a
    ld [HeadSpriteIndex], a
    inc a
    ld [$c146], a

jr_001_5760:
    ld a, [$c1e5]
    inc a
    ld [$c1e5], a
    ret


jr_001_5768:
    cp $02
    jr nz, jr_001_5781

    call DrawTime
    push af
    ld a, [DifficultyMode]
    or a
    ld a, $10
    jr z, jr_001_577a

    swap a

jr_001_577a:
    call DrawScore3
    pop af
    ret z

    jr jr_001_57c1

jr_001_5781:
    bit 6, a
    jr z, jr_001_57a4

    ld hl, $c240
    bit 4, [hl]
    ret nz

    ld a, $06
    ld bc, $0020

jr_001_5790:
    ld [hl], $80
    add hl, bc
    dec a
    jr nz, jr_001_5790

    ld [$c1e6], a
    ld a, [$c1e5]
    and $0f
    or $10
    ld [$c1e5], a
    ret


jr_001_57a4:
    cp $04
    jr nz, jr_001_57df
    ld hl, $c1e7
    dec [hl]
    ret nz
    ld [hl], $04
    call DiamondFound
    push af
    ld a, [DifficultyMode]
    ld c, a
    ld a, $02
    sub c
    swap a                   ; a = $20 in normal and $10 in practice mode.
    call DrawScore3
    pop af
    ret nz
jr_001_57c1:
    ld a, [$c1e5]
    and $df
    or $40
    ld [$c1e5], a
    ld hl, $c247
    ld b, $06
    ld c, $02
 :  ld [hl], c
    inc l
    inc l
    ld [hl], $01
    ld a, l
    add $1e
    ld l, a
    dec b
    jr nz, :-
    ret

jr_001_57df:
    cp $06
    ret nz

    ld hl, $c151
    dec [hl]
    ret nz

    ld [hl], $08
    ld a, [CrouchingHeadTilted]
    inc a
    cp $07
    jr c, jr_001_57f2

    xor a

jr_001_57f2:
    ld [CrouchingHeadTilted], a
    ld hl, $6392
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [HeadSpriteIndex], a
    cp $53
    ret nz

    ld a, [IsCrouching]
    inc a
    and $01
    ld [IsCrouching], a
    ret z

    ld a, [PlayerPositionYLsb]
    cp $98
    jr nc, jr_001_5848

    add $04
    ld [PlayerPositionYLsb], a
    ld hl, $6399
    ld a, [CrouchingHeadTiltTimer]
    inc a
    ld [CrouchingHeadTiltTimer], a
    cp $04
    ret nc

    add a
    add a
    add a
    ld c, a
    add hl, bc
    ld de, $9a0e
    ld b, $02
    ld c, $04

jr_001_5832:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5832

    ld a, [hl+]
    ld [de], a
    inc e
    dec c
    jr nz, jr_001_5832

    ld a, e
    add $1c
    ld e, a
    ld c, $04
    dec b
    jr nz, jr_001_5832

    ret


Jump_001_5848:
jr_001_5848:
    ld a, [$c1c9]
    or a
    ret nz

    ld a, [NextLevel2]
    cp $0a
    jr nz, jr_001_586f

    xor a
    ld [$c1c0], a
    ld a, $a0
    ld [$c1d0], a
    ld a, [PlayerPositionXLsb]
    cp $dc
    jp c, Jump_000_07e2

    xor a
    ld [HeadSpriteIndex], a
    ld b, $fe
    ld a, $0c
    jr jr_001_587a

jr_001_586f:
    ld a, [$c1e8]
    or a
    jp z, Jump_001_5fbd

    ld b, $01
    ld a, $0a

jr_001_587a:
    ld [CurrentLevel], a
    ld a, b
    ld [$c1c9], a
    ret

; $5882: Some special setups for Level 3 (Dawn Patrol), and Level 5 (In The River).
Lvl3Lvl5Setup:
    ld a, [NextLevel]
    ld de, $06c8
    cp 5                    ; Next level 5 (In The River)?
    jr z, jr_001_58a0
    cp 3
    ret nz                  ; Return if next level is not 3 (Dawn Patrol).
    ld hl, $9c3f
    ld bc, 32
    ld a, 4
; Loop 4 times. [$9c3f] = 2, [$9c5f] = 2, [$9c7f] = 2, [$9c9f] = 2,
 :  ld [hl], 2
    add hl, bc
    dec a
    jr nz, :-
    ld de, $05e8
jr_001_58a0:
    ld a, e
    ld [$c134], a
    ld a, d
    ld [$c135], a
    ld hl, $9c00
    ld a, 32
; Loop 32 times. [$9c00] = 2, [$9c01] = 2. , ...
 :  ld [hl], 2
    inc hl
    dec a
    jr nz, :-

    ld hl, $c129
    ld a, [BgScrollXLsb]
    ld [hl+], a
    ld a, [BgScrollXMsb]
    ld [hl+], a
    ld b, 6
    xor a
; Loop 6 times.
 :  ld [hl+], a
    dec b
    jr nz, :-

    ld [$c13a], a               ; = 0
    ld [$c13b], a               ; = 0
    ld [$c13e], a               ; = 0
    ld a, [NextLevel]
    cp 3
    jr z, :+                    ; Jump if next level is 3.
    ld a, [CheckpointReached]
    or a
    ret nz
 :  call Call_000_1351
    push af
    call DrawNewHorizontalTiles
    pop af
    jr nz, :-
    ret


    ld a, [PlayerFreeze]
    or a
    ret nz

    ld a, [NextLevel]
    ld d, a
    ld hl, $63b9
    cp $03
    ret c

    jr z, jr_001_5919

    cp $06
    ret nc

    ld hl, $63c1
    ld a, [$c13b]
    cp $03
    jr c, jr_001_5919

    ld c, a
    ld a, [TimeCounter]
    and $07
    jr nz, jr_001_593a

    ld a, c
    dec a
    ld [$c13b], a
    cp $03
    jr nc, jr_001_593a

    ld a, $0a
    ld [$c131], a

jr_001_5919:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_593a

    ld b, a
    ld a, [$c131]
    inc a
    and $0f
    ld [$c131], a
    ld c, a
    srl c
    add hl, bc
    bit 0, a
    ld a, [hl]
    jr nz, jr_001_5935

    swap a

jr_001_5935:
    and $0f
    ld [$c13b], a

jr_001_593a:
    ld a, d
    cp $04
    jp z, Jump_001_5a3a

    cp $05
    call z, Call_001_5a3a
    ld hl, $c12d
    ld e, [hl]
    inc hl
    ld d, [hl]
    push hl
    push de
    call Call_001_59ba
    pop de
    pop hl
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5996

    ld a, [$c1e9]
    or a
    jr nz, jr_001_5996

    ld bc, $1500
    ld a, [NextLevel]
    cp $03
    jr nz, jr_001_5975

    ld a, d
    cp $03
    jr nz, jr_001_5981

    ld a, e
    cp $68
    jr z, jr_001_5996

    jr jr_001_5981

jr_001_5975:
    ld bc, $0700
    ld a, d
    or a
    jr nz, jr_001_5981

    ld a, e
    cp $a0
    jr z, jr_001_5996

jr_001_5981:
    ld a, d
    or e
    jr nz, jr_001_5987

    ld d, b
    ld e, c

jr_001_5987:
    dec de
    ld [hl], d
    dec hl
    ld [hl], e
    ld hl, $c12f
    ld a, e
    cpl
    inc a
    ld [hl+], a
    dec b
    ld a, b
    sub d
    ld [hl], a

jr_001_5996:
    ld a, [$c129]
    ld b, a
    ld a, [BgScrollXLsb]
    ld c, a
    ld a, e
    add c
    sub b
    ret z

    bit 7, a
    jr z, jr_001_59b1

    cpl
    inc a

jr_001_59a8:
    push af
    call Call_001_5a6e
    pop af
    dec a
    jr nz, jr_001_59a8

    ret


jr_001_59b1:
    push af
    call Call_001_5b15
    pop af
    dec a
    jr nz, jr_001_59b1

    ret


Call_001_59ba:
    ld b, $01
    push de
    call Call_000_1660
    pop de
    ld a, [NextLevel]
    cp $03
    jr nz, jr_001_59d6

    ld a, [$c156]
    cp $20
    jr z, jr_001_59ea

    and $1f
    cp $14
    ret c

    jr jr_001_59ea

jr_001_59d6:
    ld a, [$c156]
    cp $21
    ret c

    cp $25
    ret nc

    ld a, [LandingAnimation]
    or a
    jr z, jr_001_59ea

    ld a, $06
    ld [$c13b], a

jr_001_59ea:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5a20

    ld [$c13e], a
    ld a, [NextLevel]
    cp $03
    jr nz, jr_001_5a07

    ld a, d
    cp $03
    jr nz, jr_001_5a10

    ld a, e
    cp $68
    jr z, jr_001_5a20

    jr jr_001_5a10

jr_001_5a07:
    ld a, d
    or a
    jr nz, jr_001_5a10

    ld a, e
    cp $a0
    jr z, jr_001_5a20

jr_001_5a10:
    ld a, [$c149]
    push af
    ld a, $ff
    ld [$c149], a
    call Call_000_085e
    pop af
    ld [$c149], a

jr_001_5a20:
    ld a, [IsJumping]
    or a
    ret nz

    ld a, [$c13b]
    ld [$c13e], a
    ld a, [$c1e9]
    or a
    ret z

    ld a, $ff
    ld [$c176], a
    ld c, $04
    jp ReceiveSingleDamage


Call_001_5a3a:
Jump_001_5a3a:
    ld a, [$c158]
    cp $29
    ret c

    cp $2c
    jr c, jr_001_5a4d

    cp $2e
    jr z, jr_001_5a58

    cp $2f
    jr z, jr_001_5a58

    ret


jr_001_5a4d:
    ld a, [LandingAnimation]
    or a
    jr z, jr_001_5a58

    ld a, $06
    ld [$c13b], a

jr_001_5a58:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5a62

    ld [$c13e], a

jr_001_5a62:
    ld a, [IsJumping]
    or a
    ret nz

    ld a, [$c13b]
    ld [$c13e], a
    ret


Call_001_5a6e:
    ld hl, $c129
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, d
    or e
    jr nz, jr_001_5a85

    ld de, $1500
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5a85

    ld de, $0700

jr_001_5a85:
    dec de
    ld [hl], d
    dec hl
    ld [hl], e
    ld a, e
    and $07
    ret nz

    dec a
    ld [$c1cf], a
    call Call_001_5bab
    ld a, [$c116]
    and $01
    xor $01
    ld c, a
    ld a, [$c11a]
    ld b, a
    ld a, [$c119]
    sub c
    ld c, a
    jr nc, jr_001_5abb

    ld a, b
    or a
    jr nz, jr_001_5aba

    ld bc, $014f
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5abb

    ld bc, $006f
    jr jr_001_5abb

jr_001_5aba:
    dec b

jr_001_5abb:
    srl b
    rr c
    ld hl, Layer1BgPtrs
    ld a, [$c134]
    ld e, a
    ld a, [$c135]
    ld d, a
    add hl, de
    add hl, bc
    ld de, $c3f0
    ld b, $02
    ld c, $00

jr_001_5ad3:
    push bc
    call Call_001_5ae6
    pop bc
    inc c
    dec b
    jr nz, jr_001_5ad3

Jump_001_5adc:
    ld a, [$c120]
    ld [$c121], a
    ld a, $01
    rst $00
    ret


Call_001_5ae6:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr z, jr_001_5af3

    inc hl
    inc hl

jr_001_5af3:
    ld a, [$c116]
    and $01
    ld c, a
    ld a, [$c119]
    and $01
    xor c
    jr nz, jr_001_5b02

    inc hl

jr_001_5b02:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [$c116]
    and $01
    jr nz, jr_001_5b12

    inc hl

jr_001_5b12:
    jp Jump_000_10f2


Call_001_5b15:
    ld hl, $c129
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld b, $15
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5b26

    ld b, $07

jr_001_5b26:
    inc de
    ld a, d
    cp b
    jr nz, jr_001_5b2e

    ld de, $0000

jr_001_5b2e:
    ld [hl], d
    dec hl
    ld [hl], e
    ld a, e
    and $07
    ret nz

    inc a
    ld [$c1cf], a
    call Call_001_5bab
    ld de, MainContinued
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5b49

    ld de, $0070

jr_001_5b49:
    ld a, [$c119]
    add $0a
    ld c, a
    ld a, [$c11a]
    adc $00
    ld b, a
    cp d
    jr nz, jr_001_5b5f

    ld a, c
    sub e
    jr c, jr_001_5b5f

    ld c, a
    ld b, $00

jr_001_5b5f:
    srl b
    rr c
    ld hl, Layer1BgPtrs
    ld a, [$c134]
    ld e, a
    ld a, [$c135]
    ld d, a
    add hl, de
    add hl, bc
    ld de, $c3f0
    ld b, $02
    ld c, $00

jr_001_5b77:
    push bc
    call Call_001_5b83
    pop bc
    inc c
    dec b
    jr nz, jr_001_5b77

    jp Jump_001_5adc


Call_001_5b83:
    ld a, [hl]
    push bc
    push hl
    call AMul4IntoHl
    ld a, c
    and $01
    jr z, jr_001_5b90

    inc hl
    inc hl

jr_001_5b90:
    ld a, [$c119]
    and $01
    jr z, jr_001_5b98

    inc hl

jr_001_5b98:
    ld bc, Layer2BgPtrs1
    add hl, bc
    ld a, [hl]
    call AMul4IntoHl
    ld a, [$c116]
    and $01
    jr z, jr_001_5ba8

    inc hl

jr_001_5ba8:
    jp Jump_000_10f2


Call_001_5bab:
    ld a, e
    call TrippleShiftRightCarry
    ld [$c120], a
    call TrippleRotateShiftRight
    ld a, e
    ld [$c116], a
    srl d
    rra
    ld [$c119], a
    ld a, d
    ld [$c11a], a
    ret


    bit 7, [hl]
    ret nz

    call Call_001_5c80
    call Call_001_5cb1
    call Call_001_5d5f
    call Call_001_5d1c
    call Call_001_5cc0
    ld c, $09
    rst $08
    dec a
    rst $10
    ld b, a
    and $0f
    jr nz, jr_001_5c31

    ld a, b
    swap a
    or b
    rst $10
    ld c, $07
    rst $08
    and $0f
    jr z, jr_001_5c31

    bit 3, a
    jr z, jr_001_5bf2

    or $f0

jr_001_5bf2:
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
    jr nz, jr_001_5c08

    ld a, e
    add c
    ld e, a
    jr nc, jr_001_5c0e

    inc d
    jr jr_001_5c0e

jr_001_5c08:
    ld a, e
    add c
    ld e, a
    jr c, jr_001_5c0e

    dec d

jr_001_5c0e:
    ld c, $03
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    bit 0, [hl]
    jr z, jr_001_5c20

    ld c, $15
    rst $08
    cp $0c
    jr nz, jr_001_5c31

jr_001_5c20:
    ld a, [BgScrollXLsb]
    ld c, a
    ld a, e
    sub c
    cp $b8
    jr c, jr_001_5c31

    cp $e8
    jr nc, jr_001_5c31

    set 7, [hl]
    ret


jr_001_5c31:
    ld c, $0a
    rst $08
    dec a
    rst $10
    ld b, a
    and $0f
    ret nz

    ld a, b
    swap a
    or b
    rst $10
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
    jr nz, jr_001_5c5a

    ld a, e
    add c
    ld e, a
    jr nc, jr_001_5c60

    inc d
    jr jr_001_5c60

jr_001_5c5a:
    ld a, e
    add c
    ld e, a
    jr c, jr_001_5c60

    dec d

jr_001_5c60:
    ld c, $01
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    bit 0, [hl]
    jr z, jr_001_5c71

    ld c, $15
    rst $08
    cp $0c
    ret nz

jr_001_5c71:
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, e
    sub c
    cp $90
    ret c

    cp $e0
    ret nc

    set 7, [hl]
    ret


Call_001_5c80:
    ld c, $0b
    rst $08
    or a
    ret z

    ld d, a
    inc c
    rst $20
    ret nz

    ld a, d
    rst $10
    inc c
    rst $08
    inc a
    bit 2, [hl]
    jr nz, jr_001_5c96

    and $01
    rst $10
    ret


jr_001_5c96:
    and $03
    rst $10
    ld de, $672d
    add a
    add e
    ld e, a
    jr nc, jr_001_5ca2

    inc d

jr_001_5ca2:
    ld a, [de]
    ld c, $12
    rst $10
    inc de
    ld a, [de]
    ld d, a
    ld c, $07
    rst $08
    and $0f
    or d
    rst $10
    ret


Call_001_5cb1:
    bit 2, [hl]
    ret nz

    ld c, $12
    rst $08
    or a
    ret z

    dec a
    rst $10
    or a
    ret nz

    set 7, [hl]
    ret


Call_001_5cc0:
    ld a, [hl]
    and $03
    cp $02
    ret nz

    ld c, $0c
    rst $08
    or a
    jr z, jr_001_5cdc

    dec a
    rst $10
    srl a
    srl a
    cpl
    inc a
    ld c, $08
    rst $10
    xor a
    ld c, $0e
    rst $10
    ret


jr_001_5cdc:
    ld c, $0e
    rst $08
    inc a
    cp $11
    jr nc, jr_001_5cec

    rst $10
    srl a
    srl a
    ld c, $08
    rst $10

jr_001_5cec:
    call Call_000_17f2
    ret nc

    ld a, $14
    ld c, $0c
    rst $10
    ld a, $0b
    ld [$c501], a
    bit 3, [hl]
    ret nz

    set 3, [hl]
    ld a, [$c1ef]
    or a
    jr nz, jr_001_5d16

    ld a, [BgScrollXLsb]
    ld e, a
    ld c, $03
    rst $08
    sub e
    ld c, a
    ld a, [$c144]
    cp c
    ld a, $01
    jr nc, jr_001_5d18

jr_001_5d16:
    ld a, $0f

jr_001_5d18:
    ld c, $07
    rst $10
    ret


Call_001_5d1c:
    ld a, [hl]
    and $37
    cp $37
    ret nz

    ld c, $01
    rst $08
    ld c, a
    ld a, [BgScrollYLsb]
    ld b, a
    ld a, c
    sub b
    ld c, a
    ld b, $04
    ld a, [$c177]
    or a
    jr nz, jr_001_5d37

    ld b, $0c

jr_001_5d37:
    ld a, [$c145]
    sub b
    sub c
    bit 7, a
    jr z, jr_001_5d42

    cpl
    inc a

jr_001_5d42:
    cp b
    ret nc

    ld c, $03
    rst $08
    ld c, a
    ld a, [BgScrollXLsb]
    ld b, a
    ld a, c
    sub b
    ld c, a
    ld a, [$c144]
    sub c
    bit 7, a
    jr z, jr_001_5d59

    cpl
    inc a

jr_001_5d59:
    cp $08
    ret nc

    set 7, [hl]
    ret


Call_001_5d5f:
    bit 0, [hl]
    ret z

    bit 1, [hl]
    jr nz, jr_001_5d91

    ld c, $13
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld a, [$c146]
    and $80
    jr nz, jr_001_5d81

    ld a, [$c17d]
    or a
    jr z, jr_001_5d8c

    inc de
    inc a
    jr nz, jr_001_5d8c

    inc de
    jr jr_001_5d8c

jr_001_5d81:
    ld a, [$c17d]
    or a
    jr z, jr_001_5d8c

    dec de
    inc a
    jr nz, jr_001_5d8c

    dec de

jr_001_5d8c:
    ld a, d
    rst $10
    dec c
    ld a, e
    rst $10

jr_001_5d91:
    ld c, $15
    rst $08
    cp $04
    jr c, jr_001_5da8

    jp z, Jump_001_5e95

    cp $08
    jp z, Jump_001_5e95

    cp $0c
    jp z, Jump_001_5e95

    call Call_001_5e95

jr_001_5da8:
    ld c, $0e
    rst $08
    dec a
    rst $10
    ld b, a
    and $0f
    ret nz

    ld a, b
    or $04
    rst $10

Jump_001_5db5:
    ld c, $03
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld c, $13
    rst $08
    sub e
    ld e, a
    push af
    inc c
    rst $08
    ld b, a
    pop af
    ld a, b
    sbc d
    ld d, a
    bit 1, [hl]
    jr nz, jr_001_5de6

    ld c, $07
    rst $08
    swap a
    xor d
    and $80
    ret z

    set 1, [hl]
    set 3, [hl]
    ld c, $15
    rst $08
    cp $04
    jr nc, jr_001_5de6

    set 5, [hl]
    call Call_001_5f7a

jr_001_5de6:
    ld a, [PlayerPositionXLsb]
    add $08
    ld c, $13
    push af
    rst $10
    pop af
    ld a, [PlayerPositionXMsb]
    adc $00
    inc c
    rst $10
    bit 3, [hl]
    jr nz, jr_001_5e3f

    ld c, $07
    rst $08
    swap a
    xor d
    and $80
    jr z, jr_001_5e09

    set 3, [hl]
    jr jr_001_5e3f

jr_001_5e09:
    ld c, $09
    rst $08
    ld b, a
    and $f0
    cp $10
    jr z, jr_001_5e1f

    srl a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $09
    rst $10
    jr jr_001_5e8d

jr_001_5e1f:
    ld c, $07
    rst $08
    ld b, a
    and $0f
    bit 3, a
    jr nz, jr_001_5e30

    cp $03
    jr z, jr_001_5e8d

    inc a
    jr jr_001_5e35

jr_001_5e30:
    cp $0d
    jr z, jr_001_5e8d

    dec a

jr_001_5e35:
    ld c, a
    ld a, b
    and $f0
    or c
    ld c, $07
    rst $10
    jr jr_001_5e8d

jr_001_5e3f:
    ld c, $07
    rst $08
    ld b, a
    and $0f
    bit 3, a
    jr nz, jr_001_5e4e

    dec a
    jr z, jr_001_5e5d

    jr jr_001_5e53

jr_001_5e4e:
    cp $0f
    jr z, jr_001_5e5d

    inc a

jr_001_5e53:
    ld c, a
    ld a, b
    and $f0
    or c
    ld c, $07
    rst $10
    jr jr_001_5e8d

jr_001_5e5d:
    ld c, $09
    rst $08
    ld b, a
    and $f0
    cp $40
    jr nc, jr_001_5e73

    sla a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $09
    rst $10
    jr jr_001_5e8d

jr_001_5e73:
    res 3, [hl]
    ld c, $07
    rst $08
    ld b, a
    and $0f
    bit 3, a
    jr z, jr_001_5e81

    or $f0

jr_001_5e81:
    cpl
    inc a
    and $0f
    ld c, a
    ld a, b
    and $f0
    or c
    ld c, $07
    rst $10

jr_001_5e8d:
    ld c, $15
    rst $08
    cp $04
    ret nc

    jr jr_001_5eaa

Call_001_5e95:
Jump_001_5e95:
    ld c, $05
    rst $08
    cp $97
    jr z, jr_001_5eaa

    ld c, $0e
    rst $08
    sub $10
    rst $10
    ld b, a
    and $f0
    ret nz

    ld a, b
    or $40
    rst $10

jr_001_5eaa:
    ld c, $01
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld c, $10
    rst $08
    sub e
    ld e, a
    push af
    inc c
    rst $08
    ld b, a
    pop af
    ld a, b
    sbc d
    ld d, a
    bit 5, [hl]
    jr nz, jr_001_5edc

    ld c, $08
    rst $08
    xor d
    and $80
    ret z

    set 5, [hl]
    set 6, [hl]
    ld c, $15
    rst $08
    cp $04
    jr z, jr_001_5ed8

    cp $08
    jr nz, jr_001_5edc

jr_001_5ed8:
    set 1, [hl]
    set 3, [hl]

jr_001_5edc:
    ld b, $08
    ld a, [$c177]
    or a
    jr nz, jr_001_5eef

    ld c, $15
    rst $08
    ld b, $10
    cp $0c
    jr z, jr_001_5eef

    ld b, $14

jr_001_5eef:
    ld a, [PlayerPositionYLsb]
    sub b
    ld c, $10
    push af
    rst $10
    pop af
    ld a, [PlayerPositionYMsb]
    sbc $00
    inc c
    rst $10
    bit 6, [hl]
    jr nz, jr_001_5f4b

    ld c, $08
    rst $08
    xor d
    and $80
    jr z, jr_001_5f0f

    set 6, [hl]
    jr jr_001_5f4b

jr_001_5f0f:
    ld c, $0a
    rst $08
    ld b, a
    and $f0
    cp $10
    jr z, jr_001_5f25

    srl a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $0a
    rst $10
    jr jr_001_5f82

jr_001_5f25:
    ld c, $05
    rst $08
    ld d, $03
    cp $97
    jr z, jr_001_5f36

    ld c, $15
    rst $08
    cp $0c
    ret z

    ld d, $02

jr_001_5f36:
    ld c, $08
    rst $08
    bit 7, a
    jr nz, jr_001_5f43

    cp d
    jr z, jr_001_5f82

    inc a
    jr jr_001_5f48

jr_001_5f43:
    cp $fe
    jr z, jr_001_5f82

    dec a

jr_001_5f48:
    rst $10
    jr jr_001_5f82

jr_001_5f4b:
    ld c, $05
    rst $08
    cp $97
    jr z, jr_001_5f82

    ld c, $08
    rst $08
    bit 7, a
    jr nz, jr_001_5f5e

    dec a
    jr z, jr_001_5f64

    jr jr_001_5f61

jr_001_5f5e:
    inc a
    jr z, jr_001_5f64

jr_001_5f61:
    rst $10
    jr jr_001_5f82

jr_001_5f64:
    ld c, $0a
    rst $08
    ld b, a
    and $f0
    cp $80
    jr z, jr_001_5f7a

    sla a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $0a
    rst $10
    jr jr_001_5f82

Call_001_5f7a:
jr_001_5f7a:
    res 6, [hl]
    ld c, $08
    rst $08
    cpl
    inc a
    rst $10

jr_001_5f82:
    ld c, $15
    rst $08
    cp $04
    jr z, jr_001_5f8c

    cp $08
    ret nz

jr_001_5f8c:
    jp Jump_001_5db5


    ld a, [$c13d]
    or a
    ret z

    dec a
    ld [$c13d], a
    jr z, jr_001_5fa0

    ld c, a
    ldh a, [rLY]
    add c
    and $07

jr_001_5fa0:
    ld [$c13c], a
    ret


    ld a, [PlayerPositionYLsb]
    sub c
    ld [de], a
    inc e
    ld a, [PlayerPositionYMsb]
    sbc $00
    ld [de], a
    inc e
    inc e
    ld a, [PlayerPositionXLsb]
    ld [de], a
    inc e
    ld a, [PlayerPositionXMsb]
    ld [de], a
    pop hl
    ret


Jump_001_5fbd:
    ld a, [NextLevel2]
    or a
    ret z

    ld a, [$c1c9]
    or a
    ret nz

    ld [$c1e8], a
    dec a
    ld [PlayerFreeze], a
    ld a, [NextLevel2]
    ld [CurrentLevel], a
    ld a, $20
    ld [$c1c9], a
    ld a, $4c
    ld [CurrentSong], a
    ret


    set 7, [hl]
    ld c, $10
    rst $08
    ld d, $c6
    ld e, a
    ld a, [de]
    or $80
    ld [de], a
    ld c, $06
    rst $08
    cp $90
    ret nc

    ld c, $11
    rst $08
    bit 3, a
    jr z, jr_001_5ffa

    ld a, $06

jr_001_5ffa:
    srl a
    ld b, a
    ld de, $c1a9
    add e
    ld e, a
    xor a
    ld [de], a
    ret


    inc d
    inc c
    ld [$0804], sp
    inc c
    inc d
    inc d
    inc c
    inc d
    inc c
    inc d
    inc c
    inc d
    ld hl, $3660
    ld h, b
    ld c, c
    ld h, b
    ld e, d
    ld h, b
    ld l, e
    ld h, b
    ld a, h
    ld h, b
    sub c
    ld h, b
    ld a, [bc]
    dec b
    jr nz, jr_001_602d

    jr nz, jr_001_602b

    rra
    ld a, [bc]
    jr nz, jr_001_6034

jr_001_602b:
    rst $38
    ld a, [bc]

jr_001_602d:
    jr nz, jr_001_6038

    rst $38
    ld a, [bc]
    jr nz, jr_001_6038

    rst $38

jr_001_6034:
    add hl, bc
    rst $38
    add hl, bc
    inc b

jr_001_6038:
    jr nz, jr_001_6042

    jr nz, jr_001_6046

    jr nz, @+$0b

    rst $38
    dec b
    jr nz, jr_001_604c

jr_001_6042:
    jr nz, jr_001_604d

    rst $38
    dec b

jr_001_6046:
    jr nz, jr_001_6055

    rra
    ld [$2004], sp

jr_001_604c:
    inc b

jr_001_604d:
    jr nz, jr_001_6057

    jr nz, jr_001_6059

    jr nz, jr_001_6057

    rra
    dec b

jr_001_6055:
    jr nz, @+$0c

jr_001_6057:
    jr nz, jr_001_6062

jr_001_6059:
    rst $38
    rlca
    inc b
    jr nz, jr_001_6062

    jr nz, jr_001_6064

    jr nz, jr_001_6066

jr_001_6062:
    jr nz, jr_001_6068

jr_001_6064:
    jr nz, jr_001_606a

jr_001_6066:
    jr nz, jr_001_606c

jr_001_6068:
    jr nz, @+$06

jr_001_606a:
    jr nz, jr_001_6074

jr_001_606c:
    inc b
    jr nz, @+$06

    jr nz, jr_001_6079

    ld hl, $2008

jr_001_6074:
    inc b
    jr nz, jr_001_607d

    jr nz, jr_001_6080

jr_001_6079:
    ld bc, $200b
    ld a, [bc]

jr_001_607d:
    inc b
    jr nz, @+$0a

Call_001_6080:
jr_001_6080:
    ld hl, $200b
    ld b, $20
    rlca
    ld bc, $200b
    ld b, $20
    rlca
    ld bc, $2006
    ld a, [bc]
    ld bc, $0608
    jr nz, @+$09

    ld bc, $2008
    inc b
    jr nz, jr_001_60a6

    ld hl, $210b
    dec c
    ld hl, $010c
    db $fc
    nop
    nop
    nop

jr_001_60a6:
    nop
    nop
    db $fc
    db $fc
    nop
    nop
    nop
    nop
    nop
    db $fc
    ld hl, sp-$04
    nop
    nop
    nop
    db $fc
    ld hl, sp+$00
    nop
    nop
    db $fc
    db $fc
    db $fc
    ld hl, sp-$08
    db $f4
    ldh a, [$ec]
    add sp, -$1c
    ldh [$dc], a
    ret c

    nop
    nop
    nop
    nop
    db $fc
    db $fc
    db $fc
    ld hl, sp-$08
    db $f4
    db $f4
    ldh a, [$f0]
    db $ec
    add sp, -$1c
    nop
    nop
    nop
    nop
    nop
    nop
    db $fc
    db $fc
    db $fc
    db $fc
    ld hl, sp-$08
    ld hl, sp-$0c
    db $f4
    ldh a, [rP1]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    inc b
    inc b
    inc b
    ld [$0808], sp
    inc c
    inc c
    stop
    nop
    nop
    nop
    inc b
    inc b
    inc b
    ld [$0c08], sp
    inc c
    db $10
    db $10
    inc d
    jr jr_001_6133

    nop
    nop
    nop
    inc b
    inc b
    inc b
    ld [$0c08], sp
    db $10
    inc d
    jr jr_001_6140

    jr nz, jr_001_614a

    jr z, @+$0c

    inc c
    ld c, $10
    ld [de], a
    inc d
    ld d, $18
    ld a, [de]
    inc e
    ld e, $20

jr_001_6133:
    dec c
    inc b
    ld de, $0b09
    ld b, $09
    nop
    add hl, bc
    ld [$0000], sp
    ld d, e

jr_001_6140:
    ld h, c
    ld l, l
    ld h, c
    ld [hl], l
    ld h, c
    sub a
    ld h, c
    xor c
    ld h, c
    cp a

jr_001_614a:
    ld h, c
    bit 4, c
    nop
    nop
    db $dd
    ld h, c
    rst $28
    ld h, c
    inc bc
    ld b, $08
    inc d
    dec de
    ld d, $1f
    db $10
    daa
    ld [$0c2b], sp
    ld sp, $350a
    inc c
    ld b, [hl]
    inc c
    ld c, c
    ld b, $4c
    nop
    ld d, b
    nop
    ld d, h
    nop
    inc bc
    ld [hl], h
    ld b, $2e
    dec d
    ld l, $16
    inc a
    stop
    ld a, [de]
    nop
    ld h, $06
    ld l, $06
    dec [hl]
    ld b, $38
    nop
    dec a
    ld b, $43
    nop
    ld d, b
    ld b, $54
    ld b, $5f
    ld b, $63
    nop
    ld l, b
    nop
    ld l, h
    nop
    ld [hl], b
    nop
    adc b
    nop
    sub h
    ld b, $03
    db $10
    rlca
    inc c
    ld a, [bc]
    nop
    dec d
    ld [$1020], sp
    ld b, d
    ld b, $4e
    ld c, $57
    db $10
    db $76
    ld a, [bc]
    ld [bc], a
    ld [de], a
    inc b
    ld e, $08
    jr jr_001_61bc

    ld [$2215], sp
    ld a, [de]
    ld [$141b], sp
    ld [hl+], a
    ld e, $25
    ld a, [bc]
    inc l

jr_001_61bc:
    jr nz, @+$31

    ld [de], a
    ld [bc], a
    inc e
    ld [bc], a
    jr z, jr_001_61d3

    ld c, $0e
    jr z, @+$24

    ld h, $37
    inc [hl]
    ld [bc], a
    ld a, [bc]
    ld [$1622], sp
    jr z, @+$1a

    inc [hl]

jr_001_61d3:
    dec e
    nop
    ld [hl-], a
    ld h, $3c
    inc c
    dec a
    jr jr_001_6219

    inc h
    ld [bc], a
    inc [hl]
    dec bc
    nop
    rrca
    nop
    inc de
    nop
    rra
    inc e
    dec h
    inc [hl]
    ld l, $18
    ld a, [hl-]
    ld c, $3c
    ld [hl-], a
    ld [bc], a
    ld e, $0b
    ld [de], a
    ld c, $2a
    rra
    ld [hl-], a
    jr nz, @+$20

    jr z, jr_001_6203

    inc l
    ld l, $30
    inc d
    ld [$100c], sp
    db $10

jr_001_6203:
    inc b
    inc b
    ld [$0808], sp
    ld [$0404], sp
    db $10
    db $10
    inc c
    ld [$0b04], sp
    inc c
    inc b
    dec bc
    inc c
    nop
    ld [$0008], sp

jr_001_6219:
    ld [$0008], sp
    inc b
    inc b
    nop
    nop
    nop
    nop
    nop
    db $fc
    nop
    nop
    ld hl, sp+$00
    nop
    ld hl, sp+$00
    nop
    db $f4
    nop
    nop
    db $f4
    nop
    nop
    db $f4
    nop
    nop
    db $fc
    nop
    nop
    nop
    nop
    inc b
    inc b
    inc b
    dec bc
    inc c
    db $fc
    ld hl, sp-$08
    db $f4
    inc bc
    dec b
    sbc e
    inc bc
    inc l
    inc b
    db $f4
    ld [bc], a
    add d
    nop
    sub h
    nop
    inc e
    ld [bc], a
    sbc $00
    add c
    rlca
    xor [hl]
    rlca
    ld h, d
    inc b
    jr nc, jr_001_625e

    ld h, a
    dec b
    rst $20

jr_001_625e:
    nop
    sbc b
    rlca
    ret c

    inc bc
    cp e
    rlca
    cp e
    inc b
    xor l
    rlca
    cp [hl]
    dec b
    xor [hl]
    rlca
    cp a
    dec b
    inc h
    ld bc, $0488
    ld [hl], h
    ld bc, $04e0
    db $10
    inc h
    ld bc, $0668
    ld [hl], h
    ld bc, $06c0
    ldh a, [rLY]
    ld bc, $03a8
    adc h
    ld bc, $0400
    db $10
    ld b, h
    ld bc, $0548
    adc h
    ld bc, $05a0
    ldh a, [rLY]
    ld [bc], a
    stop
    adc h
    ld [bc], a
    ld h, b
    nop
    ld bc, $0004
    stop
    ld c, h
    nop
    ld h, b
    nop
    rrca
    add h
    inc bc
    jr nc, jr_001_62a9

jr_001_62a9:
    call z, $8003
    nop
    ld de, $0344
    ret nc

    nop
    adc h
    inc bc
    jr nz, jr_001_62b7

    rst $38

jr_001_62b7:
    add h
    dec b
    adc b
    inc bc
    call z, $e005
    inc bc
    ld bc, $0000
    adc b
    inc bc
    inc l
    nop
    ldh [$03], a
    rrca
    call nz, Call_001_5005
    ld bc, $060c
    and b
    ld bc, $0411
    inc b
    ldh [rSB], a
    ld c, h
    inc b
    jr nc, jr_001_62dc

    rst $38
    and h

jr_001_62dc:
    inc b
    jr nc, jr_001_62df

jr_001_62df:
    db $ec
    inc b
    add b
    nop
    db $10
    and h
    inc b
    ld [hl], b
    ld [bc], a
    db $ec
    inc b
    ret nz

    ld [bc], a
    ldh a, [$c4]
    ld [bc], a
    or b
    ld bc, $030c
    nop
    ld [bc], a
    db $10
    call nz, $8802
    inc bc
    inc c
    inc bc
    ldh [$03], a
    ldh a, [rNR50]
    rlca
    db $10
    ld [bc], a
    ld l, h
    rlca
    ld h, b
    ld [bc], a
    db $10
    inc h
    rlca
    adc b
    inc bc
    ld l, h
    rlca
    ldh [$03], a
    ldh a, [$90]
    rlca
    sub b
    ld [bc], a
    ldh [rTAC], a
    ldh [rSC], a
    ld de, $0570
    adc b
    inc bc
    ret nz

    dec b
    ldh [$03], a
    rst $38
    sub b
    rlca
    sub b
    ld [bc], a
    ldh [rTAC], a
    ldh [rSC], a
    ld de, $0570
    adc b
    inc bc
    ret nz

    dec b
    ldh [$03], a
    rst $38
    dec sp
    inc a
    dec sp
    inc a
    dec a
    ld a, $3f
    ld c, b
    ld h, e
    ld h, b
    ld h, e
    ld h, b
    ld h, e
    ld c, b
    ld h, e
    dec d
    inc c
    ld [de], a
    inc d
    ld d, $16
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, e
    ld b, e
    ld d, $16
    ld d, $16
    ld d, $16
    ld d, $16
    ld d, $16
    rla
    rla
    jr jr_001_6386

    jr @+$1a

    add hl, de
    add hl, de
    add hl, de
    add hl, de
    ld a, [de]
    ld a, [de]
    ld a, [de]
    ld a, [de]
    ld b, h
    ld b, l
    ld b, [hl]
    ld b, [hl]
    ld b, [hl]
    dec de
    dec de
    inc e
    inc e
    inc e
    dec e
    ld e, $9e
    sbc l

jr_001_6386:
    sbc [hl]
    ld e, $05
    ld d, $00
    ld [hl+], a
    ld hl, $0020
    jr nz, jr_001_63b1

    jr nz, jr_001_63e4

    ld d, d
    ld d, e
    ld d, h
    ld d, l
    ld d, h
    ld d, e
    ld l, [hl]
    ld l, a
    ld [hl], b
    ld [hl], c
    ld h, c
    ld e, d
    ld h, c
    ld e, d
    ld [hl], d
    ld [hl], e
    ld [hl], h
    ld [hl], l
    ld h, c
    db $76
    ld [hl], a
    ld e, d
    ld a, b
    ld bc, $7901
    ld a, d
    ld a, e
    ld a, h
    ld a, l

jr_001_63b1:
    ld a, b
    ld bc, $7901
    ld a, [hl]
    ld bc, $7f01
    nop
    ld bc, $3312
    ld b, h
    ld b, e
    ld [hl-], a
    ld de, $0000
    ld bc, $2211
    ld [hl+], a
    ld hl, $0011
    nop
    nop
    nop
    ld bc, $2111
    ld de, $0000
    nop
    nop
    rrca
    rst $38
    rst $28
    rst $38
    nop
    ld bc, $0503
    ld b, $05
    inc bc
    ld bc, $9789
    sbc d

jr_001_63e4:
    sbc e
    sbc h
    sbc l
    sbc [hl]
    sbc a
    and b
    ld a, [c]
    ld h, e
    ld [$2064], sp
    ld h, h
    inc l
    ld h, h
    and h
    ld b, $a5
    ld [$0aa6], sp
    and a
    inc c
    xor b
    ld e, $a7
    inc b
    and a
    inc h
    and [hl]
    ld a, [bc]
    and l
    ld [$06a4], sp
    xor l
    ld a, b
    inc c
    inc d
    dec bc
    inc d
    inc c
    inc d
    dec bc
    inc d
    inc c
    ld a, [bc]
    dec c
    inc b
    ld c, $14
    dec c
    ld [$0a0c], sp
    dec c
    inc b
    ld c, $14
    dec c
    ld [$0a17], sp
    jr jr_001_642e

    add hl, de
    ld [hl-], a
    jr @+$0c

    rla
    ld a, [bc]
    xor l
    sub [hl]
    nop
    or h

jr_001_642e:
    ld bc, $0208
    jr z, @+$03

    ld [$6438], sp
    ld b, d
    ld h, h
    nop
    nop
    ld bc, $0201
    inc bc
    inc b
    inc b
    inc b
    inc b
    ld b, d
    ld b, e
    ld b, e
    ld b, h
    ld b, l
    ld b, h
    ld b, e
    ld b, e
    ld b, d
    xor l
    jr @+$36

    ld [$0835], sp
    ld [hl], $08
    scf
    jr nc, jr_001_6497

    db $10
    ld b, d
    ld [$1043], sp
    ld b, d
    ld [$0841], sp
    ld b, c
    ld [$0842], sp
    ld b, e
    db $10
    ld b, d
    ld [$1041], sp
    scf
    jr @+$38

    ld [$0835], sp
    inc [hl]
    ld [$18ad], sp
    ld b, b
    ld h, b
    ccf
    db $10
    ld a, $10
    dec a
    db $10
    inc a
    db $10
    xor l
    jr jr_001_64b0

    ld [$0831], sp
    ld [hl-], a
    ld [$1833], sp
    ld b, h
    db $10
    ld b, l
    ld [$1046], sp
    ld b, l
    ld [$0844], sp
    ld b, h
    ld [$0845], sp
    ld b, [hl]
    db $10

jr_001_6497:
    ld b, l
    ld [$1044], sp
    inc sp
    jr jr_001_64d0

    ld [$0831], sp
    jr nc, jr_001_64ab

    xor l
    jr @+$3d

    ld h, b
    ld a, [hl-]
    db $10
    add hl, sp
    db $10

jr_001_64ab:
    jr c, jr_001_64bd

    xor l
    db $10
    cp c

jr_001_64b0:
    ld a, [bc]
    cp d
    nop
    or a
    dec b
    cp b
    nop
    or l
    dec b
    or [hl]
    nop
    or e
    ld a, [bc]

jr_001_64bd:
    or h
    nop
    or l
    dec b
    or [hl]
    nop
    or a
    dec b
    cp b
    nop
    cp e
    ld a, [bc]
    cp h
    nop
    cp l
    dec b
    cp [hl]
    nop
    cp a

jr_001_64d0:
    inc d
    ret nz

    nop
    pop bc
    dec b
    jp nz, $bb00

    dec b
    cp h
    nop
    cp l
    ld a, [bc]
    cp [hl]
    nop
    call $c910
    push bc
    adc $04
    jp z, $cfc6

    inc b
    set 0, a
    ret nc

    inc b
    call z, $d1c8
    inc b
    pop de
    pop de
    pop de
    db $10
    pop de
    pop de
    ret nc

    inc b
    call z, $cfc8
    inc b
    set 0, a
    adc $04
    jp z, $cdc6

    ld [$c5c9], sp
    pop de
    db $10
    pop de
    pop de
    pop de
    inc b
    pop de
    jp nc, Jump_000_04d1

    pop de
    db $d3
    pop de
    inc b
    pop de
    call nc, Call_000_04d1
    pop de
    push de
    pop de
    db $10
    pop de
    pop de
    pop de
    inc b
    jp nc, $d1d1

    inc b
    db $d3
    pop de
    pop de
    inc b
    call nc, $d1d1
    inc b
    push de
    pop de
    pop de
    db $10
    pop de
    pop de
    jp nc, $d104

    pop de
    db $d3
    inc b
    pop de
    pop de
    call nc, $d104
    pop de
    push de
    inc b
    pop de
    pop de
    call $c908
    push bc
    sub $02
    ret


    push bc
    rst $10
    ld [bc], a
    ret


    push bc
    ret c

    ld [bc], a
    ret


    push bc
    reti


    ld [bc], a
    ret


    push bc
    jp c, $c902

    push bc
    db $db
    ld [bc], a
    ret


    push bc
    call $c908
    push bc
    call nz, $c914
    jp Jump_000_0409


    ld a, [bc]
    nop
    dec bc
    inc b
    inc c
    nop
    ld bc, $0204
    nop
    inc bc
    inc b
    inc b
    nop
    dec b
    inc b
    nop
    nop
    ld b, $04
    nop
    nop
    rlca
    inc b
    ld [$1800], sp
    ld [$0000], sp
    add hl, bc
    inc b
    ld a, [bc]
    nop
    dec bc
    inc b
    inc c
    nop
    dec c
    inc b
    ld c, $00
    rrca
    inc b
    stop
    ld de, $1204
    nop
    inc de
    inc b
    nop
    nop
    inc d
    inc c
    dec d
    nop
    add hl, bc
    inc b
    ld a, [bc]
    nop
    dec bc
    inc b
    inc c
    nop
    ld a, [de]
    inc b
    dec de
    nop
    inc e
    inc b
    dec e
    nop
    ld e, $04
    rra
    nop
    jr nz, jr_001_65bd

    ld hl, $2200
    inc c

jr_001_65bd:
    inc hl
    nop
    jr nz, @+$0a

    ld hl, $2200
    db $10
    inc hl
    nop
    db $e4
    ld b, $e5
    nop
    and $06
    rst $20
    nop
    add sp, $06
    jp hl


    nop
    ld [$eb06], a
    nop
    db $ec
    ld b, $ed
    nop
    xor $06
    rst $28
    nop
    db $e4
    inc c
    push hl
    nop
    ld a, [c]
    ld [$0000], sp

jr_001_65e7:
    db $e4
    ld b, $e5
    nop
    and $06
    rst $20
    nop
    add sp, $06
    jp hl


    nop
    ld [$eb06], a
    nop
    db $ec
    ld b, $ed
    nop
    xor $06
    rst $28
    nop
    db $e4
    jr nz, jr_001_65e7

    nop

jr_001_6603:
    and $06
    rst $20
    nop
    add sp, $06
    jp hl


    nop
    ld [$eb06], a
    nop
    db $ec
    ld b, $ed
    nop
    xor $06
    rst $28
    nop
    ldh a, [$0c]
    pop af
    nop
    db $e4
    jr nz, jr_001_6603

    nop
    nop
    ld [bc], a
    ld bc, $0103
    nop
    ld [bc], a
    inc bc
    ld [bc], a
    nop
    inc bc
    ld bc, $0302
    nop
    ld bc, $0000
    nop
    ld de, $2100
    nop
    ld sp, $0041
    ld d, c
    ld bc, $0000
    ld h, c
    nop
    ld [hl], c
    nop
    nop
    add c
    nop
    nop
    ld de, $3121
    ld b, c
    nop
    ld d, c
    ld bc, $0061
    ld [hl], c
    ld bc, $9141
    dec b
    dec b
    dec b
    nop
    ld [bc], a
    inc bc
    inc b
    ld bc, $8585
    add l
    nop
    inc bc
    inc b
    ld [bc], a
    ld bc, $0005
    inc b
    ld [bc], a
    inc bc
    ld bc, $8585
    add l
    nop
    ld [bc], a
    inc b
    inc bc
    ld bc, $0505
    nop
    inc bc
    ld [bc], a
    inc b
    ld bc, $0000
    ld bc, $0000
    ld bc, $0000
    ld bc, $0002
    nop
    ld bc, $0000
    ld bc, $0302
    ld bc, $0000
    ld bc, $0202
    ld bc, $0000
    ld bc, $0302
    nop
    ld bc, $1080
    jr nz, @+$05

    ld [bc], a
    inc bc
    jr nc, jr_001_66df

    ld d, b
    jr nz, jr_001_6703

    ld [bc], a
    inc bc
    ret nc

    ldh [rP1], a
    ldh a, [rP1]
    ldh [$d1], a
    ld [bc], a
    inc bc
    sub b
    and b
    or b
    pop bc
    db $10
    ld [hl], b
    ld d, c
    ld bc, $24e0
    jr nz, jr_001_66b9

jr_001_66b9:
    ret nz

    jr nc, jr_001_66dc

    ld [hl-], a
    xor h
    jr nc, jr_001_66e0

    ld [hl-], a
    add b
    inc h
    ld h, b
    nop
    nop
    jr jr_001_66c8

jr_001_66c8:
    dec b
    inc d

jr_001_66ca:
    dec b
    jr z, jr_001_66d2

    inc a
    dec b
    ld d, b
    dec b
    ld h, h

jr_001_66d2:
    ld [$0700], sp
    jr nz, @+$09

    inc a
    rlca
    ld e, b
    ld [bc], a
    nop

jr_001_66dc:
    rlca
    jr nz, jr_001_66e6

jr_001_66df:
    inc a

jr_001_66e0:
    ld b, $3c
    rlca
    ld c, b
    ld a, b
    ld e, b

jr_001_66e6:
    sub b
    ld hl, sp-$80
    ld bc, $fc13
    and b
    rrca
    ld de, $50fe
    ld bc, $f817
    ld [hl], b
    rrca
    dec d
    ld hl, sp+$50
    ld bc, $f815
    and b
    rrca
    inc de
    sbc d
    ld a, b
    nop
    ret nc

jr_001_6703:
    nop
    ret nz

    sbc h
    sbc b
    nop
    ret c

    nop
    cp b
    nop
    ret z

    sbc [hl]
    adc b
    nop
    nop
    nop
    ld bc, $0000
    rst $38
    ld bc, $0000
    rst $38
    ld bc, $0000
    rst $38
    ld bc, $0100
    nop
    ld bc, $0000
    rst $38
    nop
    rst $38
    nop
    rst $38
    rst $38
    nop
    nop
    sub l
    nop
    sub [hl]
    nop
    sub l
    jr nz, jr_001_66ca

    ld b, b
    inc b
    nop
    db $fc
    nop
    inc b
    nop
    db $fc
    nop
    inc b
    nop
    db $fc
    nop
    nop
    nop
    nop
    nop
    nop
    db $fc
    nop
    inc b
    inc bc
    db $fd
    db $fd
    inc bc
    inc bc
    inc bc
    db $fd
    db $fd
    nop
    nop
    nop
    nop
    inc b
    nop
    db $fc
    nop
    db $fd
    db $fd
    inc bc
    inc bc
    inc bc
    db $fd
    db $fd
    inc bc
    ldh a, [$f0]
    ldh a, [rP1]
    or b
    ret nz

    ret nz

    nop
    ldh a, [$30]
    db $30

; $676c: Indices for the head sprite.
HeadSpriteIndices::
    db $3a, $3a, $3a, $00, $48, $47, $47, $00, $4a, $4a, $4a, $2b, $2b, $2b, $00, $2a
    db $1f, $1f, $00, $39, $39, $39

TODOData6782::
    db $2a, $2b, $2a, $42, $3d, $31, $39, $48, $2b, $2d, $09, $00

CompressedDataLvlPointers::
    db $a6, $67, $7f, $69, $8d, $6b, $4f, $6d, $13, $70, $cd, $72, $37, $75, $e7, $77
    db $d5, $79, $ff, $7b, $43, $7e, $00, $00

CompressedDataLvl1::
    db $f0, $03, $d5, $01, $10, $60, $06, $60, $00, $14, $0c, $8c, $06, $02, $46, $46
    db $04, $d8, $01, $20, $06, $98, $06, $01, $42, $1c, $64, $75, $40, $17, $0f, $18
    db $71, $0b, $08, $1a, $8c, $0a, $13, $05, $f0, $2e, $b8, $12, $04, $5c, $b1, $d1
    db $2b, $6a, $07, $80, $89, $02, $18, $01, $06, $08, $10, $8c, $12, $48, $0d, $b0
    db $44, $98, $01, $01, $20, $44, $30, $82, $87, $05, $00, $a0, $2c, $00, $40, $22
    db $74, $41, $c0, $40, $80, $0c, $21, $00, $40, $66, $10, $08, $b0, $44, $28, $00
    db $00, $1a, $02, $00, $13, $ce, $80, $60, $22, $98, $b0, $02, $10, $61, $64, $17
    db $00, $8a, $43, $26, $10, $3c, $18, $59, $14, $80, $06, $a0, $25, $18, $1e, $8c
    db $6c, $0a, $04, $c0, $46, $b8, $b0, $00, $00, $42, $00, $30, $f2, $08, $00, $60
    db $28, $28, $10, $f0, $99, $05, $40, $0e, $80, $be, $46, $84, $11, $54, $00, $50
    db $22, $18, $15, $f0, $3a, $60, $04, $6b, $20, $80, $08, $a6, $80, $4c, $c0, $08
    db $82, $05, $23, $38, $78, $01, $80, $51, $00, $3e, $40, $05, $12, $80, $97, $c2
    db $80, $11, $81, $82, $20, $48, $2d, $80, $1d, $42, $00, $48, $00, $44, $21, $c1
    db $68, $10, $1c, $50, $00, $80, $29, $00, $16, $40, $a0, $c1, $08, $28, $10, $00
    db $07, $16, $00, $bc, $c3, $08, $46, $05, $f3, $30, $00, $5c, $e0, $00, $12, $10
    db $3c, $90, $d1, $04, $80, $01, $00, $12, $18, $10, $8c, $12, $08, $21, $49, $00
    db $40, $0d, $ae, $40, $c0, $a0, $06, $1a, $00, $c0, $0a, $60, $04, $47, $20, $40
    db $30, $3a, $74, $07, $20, $42, $80, $42, $00, $50, $fb, $80, $25, $45, $80, $1a
    db $00, $5c, $60, $40, $90, $3a, $d4, $07, $20, $19, $00, $08, $00, $64, $70, $58
    db $30, $02, $01, $13, $00, $dd, $05, $44, $82, $3c, $10, $2c, $30, $41, $40, $08
    db $00, $b0, $08, $10, $02, $40, $0f, $48, $01, $0e, $01, $58, $40, $01, $00, $0b
    db $13, $05, $20, $08, $34, $05, $20, $13, $00, $0a, $00, $68, $60, $30, $02, $02
    db $17, $04, $18, $81, $07, $00, $0d, $18, $8c, $a0, $21, $01, $20, $48, $02, $80
    db $00, $80, $11, $0a, $00, $02, $1a, $00, $46, $04, $01, $00, $06, $04, $05, $60
    db $22, $28, $18, $00, $08, $0a, $00, $20, $00, $40, $00, $45, $44, $18, $81, $01
    db $80, $0c, $10, $24, $c2, $28, $00, $2f, $61, $10, $11, $46, $a0, $00, $d0, $0b
    db $89, $85, $88, $90, $02, $80, $20, $e0, $24, $48, $84, $11, $3c, $81, $e6, $40
    db $22, $a4, $60, $04, $04, $11, $61, $04, $1e, $00, $b5, $b0, $59, $80, $08, $23
    db $60, $00, $a8, $83, $ce, $c2, $83, $51, $e0, $40, $17, $f8, $84, $04, $00, $08
    db $08, $40, $04, $85, $40, $80, $08, $00, $02

CompressedDataLvl2::
    db $08, $04, $0a, $02, $10, $40, $1f, $80, $00, $14, $0c, $8c, $16, $f1, $05, $94
    db $43, $bc, $00, $92, $00, $cc, $82, $80, $13, $0e, $04, $80, $f5, $1e, $18, $81
    db $1e, $00, $04, $10, $24, $c2, $e8, $00, $56, $10, $11, $46, $01, $a8, $10, $5c
    db $40, $10, $11, $46, $e0, $05, $b0, $83, $89, $30, $22, $80, $10, $3c, $18, $0d
    db $14, $c4, $01, $10, $80, $44, $c8, $42, $80, $5a, $01, $aa, $06, $46, $4f, $04
    db $30, $00, $84, $06, $a3, $c1, $70, $f8, $7d, $00, $2b, $40, $08, $69, $08, $4c
    db $1a, $14, $15, $01, $e3, $62, $d4, $35, $00, $09, $10, $2d, $14, $48, $09, $04
    db $0c, $b0, $02, $20, $0e, $20, $01, $0a, $08, $46, $03, $5c, $11, $38, $00, $60
    db $14, $00, $39, $00, $29, $50, $60, $28, $40, $45, $03, $02, $41, $80, $28, $a2
    db $03, $40, $50, $00, $c0, $0a, $80, $23, $20, $02, $4b, $08, $c0, $4a, $80, $20
    db $60, $d4, $01, $0b, $25, $00, $62, $20, $11, $46, $a0, $00, $80, $03, $88, $90
    db $92, $00, $40, $3e, $80, $2f, $40, $84, $91, $1c, $00, $b4, $01, $70, $01, $22
    db $b0, $04, $00, $08, $0b, $90, $01, $0c, $00, $46, $1b, $a4, $00, $02, $00, $87
    db $18, $22, $8c, $c4, $00, $c0, $05, $c0, $03, $52, $01, $00, $12, $0c, $46, $92
    db $00, $8e, $01, $b6, $02, $a9, $07, $01, $26, $a0, $00, $80, $81, $81, $02, $81
    db $91, $4c, $01, $c8, $01, $74, $80, $01, $22, $a4, $0a, $c0, $0b, $20, $01, $0a
    db $11, $61, $74, $4e, $00, $1e, $b0, $00, $00, $72, $60, $30, $32, $29, $00, $1a
    db $c0, $01, $58, $38, $08, $80, $a1, $47, $00, $00, $43, $41, $81, $40, $0b, $6d
    db $02, $00, $46, $20, $01, $06, $23, $10, $10, $a0, $01, $80, $11, $e8, $01, $f0
    db $00, $c0, $e8, $e5, $5f, $80, $c0, $04, $14, $08, $10, $42, $b0, $00, $f0, $00
    db $02, $80, $d1, $04, $26, $50, $00, $58, $ac, $00, $c0, $00, $60, $80, $3c, $80
    db $00, $06, $82, $11, $10, $3a, $30, $3c, $42, $00, $81, $00, $96, $40, $1f, $c0
    db $4b, $40, $40, $80, $41, $44, $00, $8c, $0c, $02, $00, $46, $c0, $58, $e0, $60
    db $08, $01, $c0, $06, $b0, $89, $06, $26, $8c, $00, $80, $51, $80, $41, $0d, $30
    db $18, $41, $40, $0b, $02, $8c, $c0, $09, $30, $07, $01, $52, $1d, $b0, $c0, $06
    db $00, $06, $0c, $52, $d0, $81, $01, $26, $01, $28, $80, $c1, $82, $11, $0a, $9e
    db $20, $c0, $08, $44, $00, $22, $80, $00, $88, $15, $c1, $08, $1d, $47, $10, $60
    db $04, $5a, $00, $17, $00, $02, $f0, $72, $20, $c0, $4a, $08, $00, $18, $21, $e1
    db $02, $00, $3c, $04, $40, $0d, $00, $0a, $90, $00, $bc, $34, $10, $8c, $60, $c0
    db $05, $00, $46, $01, $20, $03, $80, $00, $24, $00, $01, $08, $00, $23, $82, $00
    db $00, $93, $42, $00, $c0, $08, $0c, $04, $00, $00, $01, $04, $1c, $80, $24, $60
    db $05, $00, $a4, $31, $60, $14, $e0, $20, $20, $2e, $fa, $0f, $40, $06, $80, $08
    db $60, $39, $00, $49, $40, $00, $42, $00, $00, $81, $a1, $08, $00, $02

CompressedDataLvl3::
    db $f0, $03, $be, $01, $80, $00, $20, $00, $07, $a0, $60, $60, $34, $10, $30, $32
    db $22, $c0, $07, $00, $4c, $c0, $34, $0c, $32, $63, $60, $29, $3c, $60, $74, $98
    db $0f, $41, $00, $3c, $07, $0d, $46, $07, $99, $50, $42, $53, $30, $11, $58, $03
    db $01, $8a, $30, $2a, $08, $4c, $84, $11, $a0, $81, $60, $22, $8c, $a0, $15, $04
    db $0a, $46, $0d, $8b, $80, $29, $12, $21, $09, $82, $90, $08, $10, $00, $40, $0a
    db $04, $87, $19, $11, $36, $00, $e0, $16, $c1, $68, $00, $1c, $78, $20, $c0, $08
    db $23, $40, $60, $11, $46, $03, $01, $8a, $30, $32, $08, $50, $84, $51, $42, $20
    db $22, $8c, $60, $00, $20, $1c, $8e, $0a, $00, $42, $18, $58, $0e, $03, $00, $10
    db $28, $08, $01, $4e, $08, $07, $00, $20, $40, $00, $f0, $82, $05, $10, $20, $18
    db $0d, $70, $c2, $04, $46, $d0, $01, $02, $04, $a3, $42, $54, $78, $00, $0b, $8e
    db $40, $b0, $60, $04, $12, $00, $90, $a2, $09, $04, $48, $21, $04, $18, $8c, $02
    db $48, $51, $06, $00, $98, $a0, $1c, $04, $0c, $46, $c0, $01, $00, $a3, $00, $42
    db $08, $03, $21, $40, $30, $1a, $20, $84, $80, $01, $00, $a3, $00, $70, $00, $a0
    db $89, $02, $80, $00, $44, $80, $5a, $00, $21, $24, $08, $00, $0e, $30, $18, $00
    db $04, $45, $21, $c0, $28, $21, $f0, $60, $24, $15, $00, $30, $82, $5f, $10, $40
    db $84, $11, $01, $0a, $00, $dc, $04, $a9, $41, $10, $0e, $28, $00, $60, $61, $a2
    db $10, $40, $06, $04, $00, $20, $43, $00, $30, $02, $0d, $10, $2c, $30, $a1, $c0
    db $0a, $06, $8c, $c0, $0f, $40, $00, $02, $0a, $08, $46, $b0, $10, $82, $00, $23
    db $20, $00, $60, $09, $90, $82, $80, $11, $42, $00, $c0, $28, $21, $00, $60, $04
    db $09, $0f, $00, $f0, $50, $00, $30, $02, $2d, $10, $2c, $18, $81, $81, $0b, $06
    db $8c, $20, $0d, $04, $0b, $46, $50, $d0, $82, $00, $23, $58, $00, $28, $05, $02
    db $82, $d1, $c0, $24, $d0, $00, $80, $51, $00, $18, $00, $48, $04, $09, $c0, $0b
    db $22, $d0, $2b, $00, $80, $40, $81, $00, $38, $e0, $60, $00, $00, $08, $85, $00
    db $35, $80, $80, $01, $d9, $05, $a6, $80, $c0, $44, $90, $21, $06, $08, $26, $82
    db $0c, $41, $40, $60, $40, $76, $c1, $4b, $20, $50, $60, $44, $10, $50, $30, $42
    db $1a, $10, $14, $18, $15, $04, $14, $8c, $d0, $25, $04, $05, $46, $00, $01, $05
    db $23, $b4, $09, $41, $81, $51, $40, $40, $c1, $08, $25, $60, $60, $24, $10, $38
    db $30, $32, $01, $0a, $40, $a5, $b8, $30, $08, $49, $40, $c0, $80, $01, $a1, $08
    db $00, $02

CompressedDataLvl4::
    db $30, $06, $c0, $02, $04, $b8, $01, $e0, $01, $05, $02, $a3, $c0, $b2, $98, $08
    db $02, $01, $22, $66, $00, $40, $0d, $33, $20, $60, $8f, $03, $01, $80, $52, $3c
    db $40, $94, $05, $8c, $02, $66, $64, $04, $a6, $01, $9c, $08, $18, $10, $30, $0a
    db $e0, $90, $01, $98, $42, $84, $11, $50, $81, $00, $41, $6a, $00, $1e, $02, $05
    db $02, $8c, $02, $78, $21, $04, $10, $8c, $0a, $78, $25, $30, $62, $08, $00, $30
    db $85, $08, $23, $90, $06, $01, $02, $d3, $a0, $2c, $90, $c0, $80, $11, $4c, $00
    db $c0, $28, $20, $d0, $60, $24, $02, $1f, $00, $ed, $c0, $0a, $f9, $02, $00, $a0
    db $10, $90, $5a, $08, $04, $c0, $23, $74, $20, $c0, $28, $00, $56, $00, $a3, $90
    db $40, $83, $d1, $49, $00, $80, $c9, $00, $05, $e0, $81, $10, $9c, $8b, $01, $9c
    db $90, $22, $10, $c0, $8c, $b0, $81, $01, $23, $28, $01, $01, $00, $d3, $88, $90
    db $12, $08, $4c, $04, $13, $c4, $80, $60, $22, $98, $e0, $06, $04, $13, $c1, $04
    db $7b, $20, $00, $60, $1a, $11, $52, $0b, $81, $89, $60, $02, $5f, $10, $00, $30
    db $85, $08, $23, $b0, $06, $01, $00, $d3, $02, $a3, $06, $02, $09, $1f, $00, $da
    db $e0, $0a, $69, $00, $9c, $c6, $0e, $46, $58, $81, $00, $a6, $10, $61, $04, $18
    db $00, $30, $02, $08, $34, $18, $85, $c0, $07, $a0, $3e, $b8, $42, $82, $00, $10
    db $28, $02, $80, $31, $81, $da, $20, $37, $44, $0e, $00, $b6, $62, $04, $a3, $81
    db $bb, $08, $1c, $08, $30, $82, $0a, $00, $f8, $e1, $05, $23, $f0, $40, $80, $51
    db $00, $3c, $04, $29, $10, $20, $18, $0d, $12, $42, $b0, $40, $80, $11, $4c, $00
    db $84, $02, $a1, $81, $69, $80, $11, $58, $00, $a4, $02, $01, $c1, $68, $e0, $2e
    db $02, $05, $00, $8c, $02, $87, $21, $b8, $03, $09, $c0, $4b, $21, $00, $0c, $03
    db $60, $e3, $00, $23, $50, $10, $00, $00, $84, $02, $80, $11, $86, $80, $60, $22
    db $8c, $60, $0b, $04, $0f, $46, $05, $a4, $0e, $02, $13, $61, $04, $90, $20, $98
    db $08, $26, $98, $04, $81, $03, $13, $44, $20, $c0, $08, $2c, $00, $60, $14, $10
    db $68, $30, $02, $83, $10, $00, $67, $a0, $02, $78, $01, $18, $08, $00, $98, $f8
    db $07, $50, $80, $88, $00, $d6, $04, $08, $c0, $00, $c0, $08, $7e, $40, $00, $11
    db $4c, $01, $8c, $00, $0e, $04, $0f, $46, $32, $20, $c0, $01, $10, $0e, $6d, $07
    db $01, $23, $a0, $00, $80, $01, $85, $42, $80, $51, $a0, $23, $89, $02, $30, $00
    db $40, $02, $c3, $83, $91, $65, $00, $c0, $08, $c0, $40, $00, $c0, $d4, $c1, $08
    db $18, $00, $d8, $60, $01, $00, $e0, $c0, $60, $64, $51, $00, $08, $00, $fb, $60
    db $80, $08, $a3, $02, $20, $00, $00, $87, $05, $00, $10, $04, $80, $91, $47, $00
    db $00, $43, $41, $81, $40, $08, $6d, $02, $c0, $01, $a0, $00, $0c, $0d, $46, $05
    db $98, $02, $7e, $e1, $88, $60, $02, $03, $00, $1a, $20, $20, $18, $0d, $ec, $03
    db $0e, $10, $60, $11, $04, $20, $02, $6b, $00, $d3, $41, $a0, $81, $29, $80, $57
    db $00, $30, $00, $2c, $81, $c1, $08, $0e, $1e, $00, $82, $28, $00, $30, $00, $2c
    db $41, $b1, $60, $04, $03, $09, $00, $41, $18, $60, $00, $90, $ca, $60, $04, $01
    db $07, $00, $41, $53, $00, $30, $02, $5c, $10, $30, $18, $c1, $02, $40, $90, $05
    db $00, $02, $40, $3a, $14, $00, $04, $30, $00, $8c, $08, $02, $00, $76, $83, $83
    db $10, $0a, $1a, $00, $82, $12, $00, $34, $00, $08, $40, $73, $11, $11, $5e, $01
    db $bb, $46, $84, $11, $58, $00, $54, $00, $61, $22, $8c, $80, $0b, $04, $11, $61
    db $04, $1c, $00, $93, $40, $88, $08, $23, $40, $00, $e0, $07, $82, $44, $18, $01
    db $c0, $37, $24, $12, $0e, $8c, $1a, $43, $01, $05, $c0, $3f, $78, $42, $1a, $0a
    db $98, $04, $02, $c5, $4a, $20, $81, $00, $a3, $db, $80, $80, $51, $c0, $22, $03
    db $0b, $41, $81, $11, $00, $64, $00, $f4, $03, $ae, $41, $c0, $28, $10, $34, $32
    db $fa, $0f, $60, $0c, $30, $7e, $60, $39, $00, $49, $40, $40, $43, $00, $00, $81
    db $a1, $08, $00, $02

CompressedDataLvl5::
    db $b8, $05, $b6, $02, $04, $c8, $03, $50, $00, $05, $02, $a3, $c0, $5c, $8d, $58
    db $92, $00, $6b, $00, $d4, $00, $d3, $20, $e0, $87, $03, $01, $60, $4a, $5c, $60
    db $92, $03, $8c, $00, $01, $04, $14, $c1, $04, $10, $98, $08, $23, $a0, $00, $80
    db $d1, $4b, $00, $22, $8c, $80, $03, $04, $13, $61, $04, $3b, $20, $98, $08, $23
    db $10, $02, $01, $44, $18, $81, $41, $10, $80, $16, $50, $01, $1c, $80, $80, $30
    db $00, $60, $e2, $9f, $40, $80, $93, $13, $20, $82, $00, $23, $80, $00, $01, $45
    db $48, $a5, $08, $23, $78, $01, $c1, $44, $18, $41, $12, $08, $26, $c2, $08, $a8
    db $40, $00, $11, $46, $27, $ff, $03, $60, $06, $59, $00, $20, $08, $c0, $a4, $80
    db $00, $00, $27, $0e, $30, $82, $ff, $17, $04, $b1, $c1, $0e, $00, $0b, $10, $10
    db $8c, $0a, $50, $e1, $00, $23, $f0, $80, $03, $13, $04, $a0, $20, $c0, $08, $78
    db $00, $9c, $80, $80, $60, $34, $c8, $ab, $80, $11, $c8, $00, $e0, $00, $01, $22
    db $8c, $02, $54, $c1, $18, $08, $1a, $98, $06, $18, $c1, $05, $40, $07, $10, $10
    db $8c, $06, $90, $81, $05, $06, $e4, $10, $ba, $e0, $68, $00, $20, $87, $05, $20
    db $11, $81, $42, $10, $00, $07, $1e, $00, $60, $c3, $00, $4c, $20, $00, $82, $88
    db $60, $02, $0d, $00, $48, $63, $06, $26, $d0, $40, $80, $11, $e0, $00, $a4, $40
    db $5b, $c1, $40, $ea, $80, $1c, $06, $30, $02, $01, $1a, $00, $09, $68, $33, $18
    db $50, $61, $01, $36, $0c, $00, $86, $12, $01, $00, $39, $84, $2e, $10, $30, $a8
    db $81, $00, $40, $50, $00, $00, $09, $80, $00, $24, $1e, $f8, $84, $02, $00, $5e
    db $90, $81, $04, $a3, $41, $52, $c0, $01, $00, $af, $80, $00, $00, $27, $02, $04
    db $18, $c8, $80, $03, $00, $6a, $01, $60, $00, $30, $01, $85, $05, $26, $70, $48
    db $00, $08, $aa, $02, $80, $14, $24, $80, $a0, $41, $6a, $00, $19, $80, $00, $a0
    db $00, $61, $c1, $08, $28, $20, $20, $05, $1c, $00, $31, $48, $f0, $1a, $00, $07
    db $05, $00, $41, $48, $80, $02, $00, $35, $40, $aa, $28, $90, $5a, $98, $10, $0c
    db $cd, $21, $80, $54, $00, $78, $00, $5c, $c1, $01, $c1, $68, $80, $1a, $6c, $00
    db $40, $2a, $70, $80, $18, $08, $16, $98, $a0, $e1, $00, $20, $28, $01, $80, $02
    db $80, $0a, $52, $01, $00, $1a, $0c, $4c, $32, $01, $80, $00, $c0, $04, $05, $00
    db $01, $89, $01, $26, $03, $02, $01, $80, $11, $24, $3c, $00, $04, $41, $01, $90
    db $0e, $d8, $20, $75, $20, $c0, $07, $14, $00, $30, $30, $50, $00, $82, $02, $40
    db $18, $80, $09, $14, $40, $80, $60, $34, $40, $0d, $3a, $10, $60, $04, $1b, $00
    db $5a, $8b, $60, $34, $f0, $ae, $80, $14, $8c, $00, $18, $01, $01, $c1, $68, $d0
    db $19, $82, $06, $02, $8c, $a0, $01, $80, $06, $08, $09, $46, $83, $8b, $06, $18
    db $41, $06, $c0, $17, $90, $00, $bc, $1c, $00, $8b, $08, $02, $00, $46, $03, $c0
    db $10, $10, $08, $00, $80, $10, $60, $04, $3a, $20, $58, $60, $82, $83, $02, $07
    db $47, $08, $00, $1a, $00, $10, $50, $00, $18, $fd, $07, $0e, $8c, $a0, $a0, $00
    db $01, $b0, $02, $40, $05, $a0, $01, $f2, $00, $18, $40, $10, $60, $10, $00, $40
    db $60, $60, $10, $2c, $03, $05, $45, $28, $00, $18, $80, $08, $58, $00, $00, $58
    db $34, $18, $15, $00, $09, $40, $0e, $2c, $00, $80, $20, $00, $8c, $3c, $02, $00
    db $18, $0a, $0a, $04, $46, $36, $01, $00, $23, $e8, $00, $c1, $44, $18, $c1, $16
    db $68, $0e, $20, $c2, $08, $78, $00, $78, $e0, $b3, $00, $11, $46, $38, $02, $10
    db $00, $84, $89, $60, $02, $04, $10, $40, $84, $51, $e0, $80, $13, $48, $1c, $48
    db $84, $14, $b8, $41, $e2, $20, $22, $98, $04, $80, $0d, $12, $09, $08, $46, $8d
    db $8b, $06, $c0, $0d, $3a, $09, $08, $46, $8b, $8b, $c0, $00, $e0, $04, $3c, $21
    db $01, $00, $02, $02, $14, $41, $21, $10, $28, $30, $02, $81, $1f, $40, $36, $70
    db $85, $04, $41, $10, $88, $42, $80, $08, $00, $02

CompressedDataLvl6::
    db $98, $04, $66, $02, $10, $60, $0f, $20, $00, $14, $08, $8c, $02, $d8, $35, $22
    db $47, $02, $bc, $00, $90, $02, $4c, $83, $80, $dd, $40, $00, $58, $ef, $00, $39
    db $0e, $92, $03, $1e, $80, $07, $20, $28, $48, $05, $38, $03, $03, $47, $1c, $00
    db $4a, $c1, $05, $08, $02, $8c, $22, $30, $05, $ec, $c2, $09, $80, $12, $00, $02
    db $30, $00, $18, $fd, $07, $0e, $8c, $50, $40, $c1, $c0, $b0, $02, $40, $01, $00
    db $03, $14, $0a, $46, $01, $18, $11, $14, $1c, $27, $00, $24, $00, $74, $20, $0e
    db $20, $60, $81, $c0, $04, $06, $06, $0e, $8e, $58, $00, $b0, $44, $d0, $82, $b8
    db $01, $00, $12, $26, $30, $1a, $c0, $89, $10, $20, $20, $38, $01, $c0, $01, $20
    db $07, $71, $00, $2f, $01, $0d, $00, $2a, $0c, $20, $84, $06, $81, $c0, $66, $04
    db $04, $00, $c0, $02, $00, $1e, $00, $08, $48, $48, $04, $96, $00, $5c, $c0, $e0
    db $01, $4b, $26, $00, $32, $00, $a6, $a0, $60, $14, $20, $0e, $0b, $00, $82, $32
    db $00, $de, $00, $58, $74, $41, $0a, $09, $57, $10, $80, $15, $40, $8a, $20, $00
    db $11, $58, $01, $38, $11, $6a, $20, $15, $00, $a0, $d0, $20, $15, $c0, $09, $01
    db $02, $09, $46, $03, $9c, $10, $14, $00, $82, $2c, $00, $10, $00, $a2, $a0, $00
    db $20, $80, $31, $20, $65, $40, $20, $08, $f0, $02, $07, $80, $20, $04, $00, $0d
    db $80, $32, $48, $3c, $18, $49, $00, $60, $0c, $40, $1c, $a4, $1e, $04, $d4, $80
    db $02, $00, $06, $06, $0a, $04, $6a, $72, $01, $d0, $02, $70, $00, $06, $04, $a3
    db $02, $52, $01, $8c, $02, $c2, $c1, $07, $08, $16, $8c, $40, $81, $04, $01, $46
    db $90, $03, $10, $06, $24, $05, $01, $23, $82, $00, $80, $9a, $42, $20, $70, $0e
    db $03, $d8, $21, $04, $c0, $0b, $00, $0a, $18, $22, $c2, $08, $50, $00, $90, $80
    db $d0, $60, $34, $10, $0a, $a1, $00, $00, $0b, $8e, $00, $5e, $0e, $00, $46, $06
    db $01, $00, $3f, $a4, $08, $08, $e5, $61, $40, $25, $2c, $00, $1e, $00, $24, $28
    db $44, $84, $11, $70, $00, $f0, $01, $01, $22, $8c, $0a, $60, $06, $80, $0c, $16
    db $00, $40, $10, $00, $46, $1e, $01, $00, $0c, $05, $05, $02, $3e, $9b, $00, $c0
    db $00, $98, $00, $03, $03, $1c, $5c, $60, $c0, $08, $0c, $40, $c0, $40, $06, $19
    db $10, $f0, $02, $00, $17, $18, $2c, $18, $c1, $05, $04, $8c, $00, $04, $04, $0f
    db $46, $07, $b0, $40, $06, $04, $0b, $46, $d0, $50, $02, $01, $a9, $00, $b8, $82
    db $01, $82, $d1, $c0, $38, $d8, $40, $80, $11, $b0, $00, $3c, $01, $61, $c1, $08
    db $16, $48, $10, $60, $04, $26, $20, $68, $30, $82, $80, $16, $00, $18, $05, $80
    db $0f, $00, $1e, $80, $00, $04, $20, $08, $90, $30, $21, $00, $4c, $04, $0f, $0b
    db $00, $f0, $00, $f2, $3e, $00, $39, $a0, $40, $30, $6a, $64, $f4, $08, $00, $61
    db $40, $08, $69, $00, $3c, $2a, $60, $54, $01, $20, $30, $1e, $1b, $80, $03, $18
    db $44, $84, $11, $d0, $00, $d0, $00, $21, $22, $8c, $c0, $03, $60, $07, $12, $c1
    db $04, $33, $00, $66, $40, $88, $08, $23, $40, $00, $e8, $02, $02, $82, $51, $e3
    db $2e, $48, $01, $18, $81, $44, $48, $43, $01, $93, $40, $a0, $f8, $0a, $04, $5c
    db $00, $60, $d4, $1c, $10, $30, $0a, $58, $84, $10, $10, $30, $22, $0b, $04, $18
    db $19, $07, $00, $8c, $92, $03, $0f, $46, $00, $ac, $00, $88, $07, $c3, $06, $01
    db $a3, $41, $71, $11, $20, $2e, $fa, $0f, $c0, $04, $c0, $3b, $60, $39, $00, $49
    db $40, $00, $42, $00, $00, $81, $a1, $08, $00, $02

    db $58, $05, $ac, $02, $00, $02, $3c, $00, $0a, $80, $02, $81, $51, $00, $a6, $46

CompressedDataLvl7::
    db $46, $04, $d8, $03, $98, $05, $98, $06, $01, $51, $1c, $08, $00, $e3, $62, $03
    db $a2, $0c, $68, $86, $50, $01, $89, $70, $45, $d0, $00, $c0, $3e, $4e, $60, $0a
    db $70, $8f, $98, $e0, $20, $58, $01, $10, $01, $00, $08, $01, $27, $9c, $80, $05
    db $0a, $8a, $30, $00, $b4, $03, $26, $10, $20, $30, $0d, $d0, $42, $60, $50, $50
    db $2c, $02, $00, $1c, $58, $20, $00, $ab, $83, $11, $90, $00, $98, $01, $01, $c1
    db $6e, $00, $18, $82, $01, $02, $0d, $00, $98, $02, $e8, $62, $00, $a3, $09, $7c
    db $f0, $40, $80, $03, $00, $63, $1c, $80, $32, $18, $34, $18, $81, $81, $0b, $02
    db $c8, $e0, $0a, $e2, $06, $0a, $58, $50, $30, $80, $03, $00, $3b, $b0, $01, $f0
    db $81, $b8, $c2, $82, $11, $4c, $20, $40, $0a, $33, $00, $56, $80, $10, $11, $46
    db $f8, $01, $c0, $6e, $bc, $80, $05, $0b, $01, $04, $44, $00, $a0, $c5, $00, $60
    db $80, $3a, $02, $a0, $57, $04, $29, $8c, $80, $80, $d4, $00, $74, $c0, $00, $c0
    db $28, $02, $13, $1c, $04, $20, $30, $42, $00, $b0, $00, $58, $81, $62, $81, $09
    db $02, $00, $08, $10, $b1, $20, $c0, $8c, $75, $00, $01, $ff, $04, $02, $a3, $01
    db $58, $c0, $01, $00, $48, $0c, $80, $87, $30, $03, $71, $00, $2f, $01, $06, $00
    db $57, $0c, $60, $64, $10, $00, $30, $82, $07, $04, $02, $c2, $2c, $04, $78, $01
    db $04, $1a, $bc, $06, $18, $c1, $09, $00, $04, $10, $16, $8c, $80, $41, $04, $01
    db $46, $d0, $02, $c0, $02, $04, $05, $a3, $80, $53, $05, $8c, $06, $40, $06, $06
    db $0b, $46, $e0, $60, $02, $00, $a3, $00, $9c, $08, $1a, $60, $30, $02, $03, $17
    db $04, $e0, $21, $3c, $00, $d8, $01, $09, $c0, $cb, $61, $00, $8e, $40, $41, $10
    db $a0, $88, $a0, $01, $80, $b7, $00, $46, $b0, $04, $82, $88, $30, $02, $04, $40
    db $2d, $20, $48, $84, $14, $00, $9a, $c1, $00, $80, $e9, $83, $51, $00, $fc, $c0
    db $20, $22, $98, $c0, $01, $50, $01, $08, $00, $4c, $1d, $8c, $80, $05, $30, $02
    db $08, $00, $7c, $1b, $8c, $00, $c0, $06, $e0, $03, $0a, $11, $81, $05, $28, $00
    db $04, $40, $40, $30, $2a, $60, $57, $00, $4b, $00, $5a, $60, $f0, $20, $45, $14
    db $00, $30, $43, $78, $01, $01, $02, $d3, $01, $3b, $08, $4a, $00, $f0, $01, $78
    db $03, $44, $60, $49, $04, $80, $08, $40, $17, $12, $8c, $06, $c0, $05, $60, $a2
    db $09, $00, $0b, $80, $2c, $30, $18, $a1, $e1, $02, $40, $90, $14, $04, $e0, $0a
    db $02, $05, $52, $06, $04, $82, $01, $38, $08, $3a, $01, $20, $1c, $c4, $41, $2a
    db $00, $48, $81, $c1, $48, $06, $00, $34, $00, $88, $20, $f5, $20, $80, $84, $40
    db $01, $00, $03, $03, $05, $02, $24, $14, $09, $00, $78, $c1, $09, $08, $18, $8c
    db $f0, $00, $00, $b0, $02, $00, $01, $80, $08, $12, $0c, $58, $58, $01, $01, $29
    db $01, $f0, $80, $41, $03, $d3, $00, $29, $f0, $01, $60, $01, $c2, $82, $11, $6a
    db $00, $80, $09, $33, $00, $78, $00, $1e, $c0, $b0, $60, $84, $8c, $01, $00, $80
    db $18, $00, $0a, $00, $78, $70, $06, $10, $d0, $00, $30, $22, $08, $00, $28, $48
    db $00, $30, $00, $04, $3e, $00, $00, $42, $00, $0c, $00, $e0, $40, $22, $22, $8c
    db $a0, $04, $00, $03, $08, $11, $61, $04, $29, $00, $68, $40, $88, $08, $23, $d8
    db $00, $c0, $03, $02, $44, $18, $05, $80, $0c, $00, $12, $1c, $01, $bc, $20, $00
    db $8c, $0c, $02, $00, $10, $28, $0a, $81, $59, $e0, $01, $00, $ab, $02, $f0, $00
    db $58, $82, $02, $00, $53, $07, $23, $c0, $00, $f0, $01, $80, $11, $48, $a0, $c1
    db $a8, $00, $74, $00, $02, $60, $01, $e0, $10, $60, $e4, $11, $00, $c0, $50, $50
    db $20, $30, $b2, $01, $00, $05, $00, $3a, $48, $3c, $20, $18, $2d, $2e, $02, $11
    db $00, $20, $e8, $84, $04, $00, $08, $08, $50, $04, $85, $40, $80, $08, $00, $02

CompressedDataLvl8::
    db $c0, $06, $ea, $01, $40, $80, $6a, $40, $43, $38, $30, $1a, $08, $18, $49, $26
    db $01, $a6, $00, $e8, $0b, $31, $03, $02, $a4, $39, $10, $00, $c0, $4c, $81, $c0
    db $81, $25, $1a, $40, $02, $0c, $28, $42, $0d, $20, $30, $11, $58, $30, $01, $82
    db $89, $c0, $82, $0f, $10, $4c, $04, $16, $4c, $60, $22, $b0, $d1, $00, $5a, $60
    db $20, $11, $ea, $68, $00, $21, $98, $08, $32, $03, $28, $c1, $44, $60, $19, $40
    db $0f, $0c, $24, $02, $09, $0d, $e0, $07, $06, $13, $41, $06, $41, $20, $90, $08
    db $3f, $2c, $80, $1c, $18, $50, $04, $dc, $89, $50, $c4, $02, $88, $81, $81, $44
    db $98, $61, $01, $9c, $60, $22, $b4, $d0, $00, $42, $60, $30, $11, $4c, $90, $81
    db $89, $c0, $c6, $02, $a8, $80, $81, $44, $c0, $63, $01, $2c, $c0, $40, $22, $e0
    db $0a, $e0, $04, $13, $81, $55, $10, $a0, $08, $78, $2c, $80, $03, $18, $4c, $04
    db $1c, $4c, $60, $22, $80, $91, $00, $0a, $60, $20, $11, $a8, $48, $00, $07, $30
    db $98, $08, $38, $68, $00, $81, $44, $f0, $11, $40, $08, $26, $42, $14, $09, $60
    db $02, $06, $12, $21, $87, $05, $a0, $82, $89, $20, $c4, $02, $20, $81, $44, $18
    db $01, $14, $40, $0f, $26, $02, $09, $09, $40, $04, $13, $e1, $45, $00, $3b, $30
    db $90, $08, $4e, $24, $80, $1f, $18, $48, $04, $21, $12, $40, $10, $0c, $28, $42
    db $0e, $07, $02, $13, $81, $05, $1b, $90, $08, $23, $d8, $01, $a8, $01, $45, $18
    db $41, $0c, $08, $26, $42, $0b, $01, $03, $12, $61, $04, $3a, $00, $36, $90, $08
    db $23, $b0, $01, $48, $01, $82, $44, $c8, $e1, $00, $b8, $60, $22, $d4, $02, $48
    db $95, $08, $3b, $01, $48, $81, $44, $18, $01, $0a, $c0, $0d, $10, $26, $42, $0a
    db $6a, $40, $20, $11, $7c, $02, $d0, $02, $03, $89, $90, $12, $80, $14, $48, $84
    db $11, $90, $00, $8c, $00, $21, $22, $8c, $c0, $05, $e0, $03, $08, $12, $e1, $84
    db $03, $d0, $02, $89, $30, $82, $1b, $80, $0d, $20, $4c, $04, $13, $4c, $80, $20
    db $22, $8c, $a0, $07, $a0, $07, $13, $a1, $36, $00, $27, $98, $08, $ac, $81, $c0
    db $44, $48, $41, $0c, $40, $0d, $26, $42, $4d, $20, $40, $11, $58, $02, $30, $02
    db $89, $30, $82, $12, $80, $1a, $48, $84, $11, $8c, $80, $60, $22, $8c, $80, $03
    db $20, $07, $12, $61, $04, $19, $00, $37, $90, $08, $23, $90, $00, $e0, $41, $82
    db $51, $03, $26, $78, $00, $70, $00, $42, $48, $03, $40, $14, $30, $aa, $08, $18
    db $3f, $01, $01, $40, $04, $24, $42, $1a, $00, $a4, $0a, $14, $09, $04, $8a, $93
    db $40, $02, $01, $46, $18, $01, $01, $a3, $00, $4c, $01, $18, $82, $02, $23, $00
    db $2c, $00, $fa, $81, $d6, $80, $03, $11, $34, $32, $fa, $0f, $80, $03, $60, $1f
    db $60, $39, $00, $49, $40, $00, $42, $00, $00, $81, $a1, $08, $00, $02

CompressedDataLvl9::
    db $08, $04, $26, $02, $00, $18, $41, $00, $08, $0c, $8c, $16, $89, $62, $e0, $3d
    db $ec, $01, $e8, $03, $cc, $82, $80, $28, $0e, $04, $00, $97, $b0, $01, $36, $0e
    db $a0, $42, $80, $00, $81, $d1, $02, $27, $0c, $a0, $85, $94, $01, $20, $03, $00
    db $69, $0c, $08, $08, $60, $21, $04, $02, $90, $70, $00, $30, $06, $44, $46, $92
    db $02, $01, $80, $34, $06, $04, $22, $c2, $08, $78, $00, $c8, $80, $00, $11, $46
    db $05, $60, $00, $80, $04, $0b, $06, $01, $3f, $f4, $08, $00, $60, $28, $28, $10
    db $f8, $a1, $4d, $00, $e4, $00, $80, $0a, $1f, $18, $15, $90, $02, $0d, $04, $18
    db $41, $0e, $40, $12, $10, $16, $8c, $80, $02, $02, $46, $70, $03, $a0, $07, $24
    db $85, $01, $a3, $00, $64, $0a, $81, $00, $35, $f0, $40, $00, $1c, $bc, $00, $68
    db $00, $01, $c1, $a8, $80, $57, $01, $29, $01, $f0, $81, $c1, $82, $11, $14, $94
    db $20, $c0, $08, $3c, $00, $88, $37, $22, $8c, $a0, $02, $c0, $92, $c8, $05, $f0
    db $32, $70, $30, $02, $09, $00, $05, $57, $a0, $40, $0a, $41, $41, $00, $60, $04
    db $08, $08, $00, $40, $10, $00, $3c, $00, $36, $a0, $40, $30, $1a, $74, $89, $20
    db $80, $c0, $88, $01, $e0, $03, $c0, $07, $79, $00, $2f, $ff, $01, $01, $06, $10
    db $01, $5c, $42, $83, $40, $00, $13, $3c, $28, $28, $56, $00, $b8, $01, $b0, $eb
    db $82, $11, $1c, $b4, $00, $60, $0a, $03, $aa, $41, $06, $12, $8c, $0a, $78, $05
    db $5a, $0a, $40, $06, $6b, $20, $40, $30, $1a, $80, $85, $1f, $00, $c8, $c2, $00
    db $30, $00, $98, $81, $33, $43, $81, $51, $41, $82, $20, $40, $0d, $0b, $00, $00
    db $93, $00, $c0, $04, $06, $20, $60, $10, $42, $cc, $40, $00, $1f, $a8, $00, $d0
    db $a0, $81, $09, $16, $00, $82, $2c, $00, $64, $00, $16, $91, $40, $36, $30, $0c
    db $03, $48, $11, $05, $00, $07, $80, $04, $18, $18, $8c, $e0, $00, $20, $08, $09
    db $00, $5e, $40, $02, $02, $04, $a3, $81, $49, $08, $1c, $08, $b0, $03, $18, $80
    db $1c, $30, $78, $a1, $05, $04, $c8, $40, $05, $e0, $08, $08, $00, $64, $1d, $ec
    db $00, $05, $60, $0f, $08, $00, $70, $1f, $bc, $02, $00, $08, $06, $0b, $46, $c8
    db $01, $00, $23, $ba, $00, $b0, $00, $f8, $02, $03, $16, $2a, $8e, $00, $c0, $2b
    db $00, $3c, $60, $d0, $60, $84, $10, $08, $30, $0a, $00, $06, $80, $3b, $28, $2c
    db $30, $a1, $e0, $02, $40, $90, $00, $00, $02, $c0, $1f, $88, $02, $80, $34, $1a
    db $a4, $02, $40, $01, $c0, $0b, $0a, $0b, $46, $88, $38, $00, $10, $34, $01, $80
    db $00, $50, $00, $05, $00, $01, $0d, $00, $23, $82, $00, $00, $03, $82, $02, $e0
    db $40, $60, $02, $40, $50, $14, $80, $03, $12, $40, $14, $80, $10, $60, $04, $14
    db $00, $20, $30, $50, $20, $30, $92, $08, $00, $30, $41, $08, $08, $22, $c2, $08
    db $78, $00, $ca, $80, $10, $11, $46, $e0, $03, $f0, $07, $84, $04, $a3, $c5, $45
    db $60, $00, $90, $04, $89, $05, $00, $a3, $80, $00, $80, $51, $40, $a2, $06, $46
    db $6f, $01, $10, $07, $04, $88, $30, $02, $79, $04, $80, $09, $20, $84, $04, $00
    db $10, $08, $58, $04, $45, $45, $80, $08, $00, $02

CompressedDataLvl10::
    db $38, $04, $40, $02, $00, $80, $11, $04, $80, $80, $c0, $28, $c0, $1c, $00, $80
    db $a0, $38, $08, $31, $07, $30, $0d, $30, $0b, $02, $f6, $38, $10, $00, $30, $12
    db $08, $18, $c0, $23, $52, $00, $40, $0e, $2f, $18, $a1, $e1, $0a, $02, $8c, $d0
    db $06, $60, $09, $08, $08, $46, $03, $38, $11, $3b, $10, $60, $84, $33, $00, $63
    db $10, $08, $10, $78, $00, $5c, $02, $0a, $00, $1b, $a1, $46, $00, $c0, $08, $05
    db $08, $00, $08, $a0, $00, $60, $04, $19, $20, $40, $60, $1a, $80, $85, $09, $08
    db $88, $18, $00, $34, $00, $24, $10, $07, $10, $c0, $28, $30, $1a, $e0, $87, $a0
    db $60, $60, $83, $00, $2a, $04, $1c, $10, $2c, $18, $c1, $42, $82, $83, $61, $06
    db $80, $0d, $00, $18, $c4, $01, $bc, $04, $04, $04, $18, $44, $04, $c0, $09, $0d
    db $02, $01, $84, $08, $01, $0e, $8e, $43, $00, $a0, $42, $e0, $40, $02, $59, $01
    db $39, $1c, $60, $04, $38, $20, $78, $60, $2a, $60, $34, $00, $58, $30, $88, $08
    db $2c, $18, $01, $00, $02, $42, $44, $18, $41, $06, $00, $a1, $30, $82, $d1, $c0
    db $3f, $04, $0c, $04, $18, $41, $03, $00, $15, $10, $10, $8c, $06, $2e, $22, $70
    db $20, $c0, $08, $2e, $00, $30, $80, $0b, $e0, $e5, $30, $60, $84, $a0, $20, $20
    db $60, $43, $82, $00, $f0, $01, $78, $01, $c3, $81, $51, $01, $35, $8c, $00, $40
    db $13, $06, $c0, $02, $23, $10, $1c, $18, $15, $c0, $c2, $0b, $00, $30, $05, $80
    db $03, $0a, $20, $30, $15, $c0, $0a, $40, $86, $19, $00, $1e, $00, $64, $60, $38
    db $30, $2a, $40, $16, $10, $0a, $71, $02, $04, $00, $5a, $08, $70, $26, $28, $30
    db $2a, $08, $04, $18, $41, $c1, $00, $00, $60, $15, $00, $8c, $20, $01, $04, $0b
    db $46, $48, $d8, $02, $00, $a3, $80, $64, $30, $02, $02, $04, $a3, $01, $7c, $58
    db $c0, $08, $60, $00, $82, $80, $c0, $60, $84, $15, $00, $30, $0a, $20, $05, $12
    db $60, $30, $42, $c6, $13, $04, $18, $81, $02, $c0, $1c, $14, $16, $06, $8c, $02
    db $98, $61, $42, $00, $c0, $08, $1a, $16, $00, $e0, $21, $00, $50, $00, $30, $40
    db $b1, $60, $04, $03, $2d, $10, $30, $0a, $d8, $95, $01, $0b, $36, $30, $60, $04
    db $3c, $20, $40, $30, $1a, $f8, $05, $14, $08, $60, $02, $0e, $80, $26, $20, $2c
    db $18, $21, $22, $00, $40, $10, $05, $00, $0b, $80, $24, $18, $8c, $40, $41, $05
    db $01, $46, $20, $01, $a0, $05, $84, $05, $23, $08, $08, $00, $08, $8a, $00, $30
    db $00, $08, $83, $02, $80, $80, $06, $80, $11, $41, $00, $80, $01, $21, $78, $0f
    db $12, $12, $00, $82, $0c, $00, $70, $00, $4c, $40, $11, $11, $46, $40, $01, $d0
    db $07, $04, $89, $60, $0a, $18, $35, $22, $8c, $c0, $07, $a0, $0c, $08, $11, $61
    db $04, $08, $00, $3f, $90, $58, $38, $30, $6a, $dc, $05, $1c, $00, $26, $a0, $09
    db $69, $00, $ae, $0a, $60, $14, $90, $a8, $81, $11, $f6, $00, $d0, $40, $22, $8c
    db $d0, $07, $e0, $06, $09, $46, $0d, $98, $f0, $07, $40, $0f, $08, $21, $01, $00
    db $04, $02, $14, $41, $51, $11, $10, $82, $41, $82, $3b, $80, $7c, $c0, $52, $00
    db $92, $80, $00, $01, $80, $11, $41, $c0, $38, $09, $24, $10, $60, $24, $1f, $10
    db $14, $84, $00, $80, $80, $8c, $42, $81, $11, $00, $f0, $00, $f6, $41, $ab, $a1
    db $09, $00, $fe, $05

CompressedDataLvl11::
    db $d8, $00, $59, $00, $00, $a0, $25, $c0, $0e, $e0, $6a, $10, $30, $6a, $74, $a4
    db $15, $10, $f0, $12, $00, $13, $28, $18, $35, $2e, $0a, $e0, $75, $19, $80, $08
    db $23, $f8, $00, $28, $01, $cd, $42, $44, $48, $05, $c0, $08, $6c, $12, $20, $c2
    db $08, $3a, $00, $22, $80, $b3, $00, $11, $46, $40, $01, $f0, $00, $9d, $05, $88
    db $30, $02, $13, $80, $0f, $f0, $2c, $20, $18, $2d, $2e, $82, $0c

    add b
    ld c, $e0
    add h
    inc b
    nop
    ld [$5008], sp
    inc b
    add l
    ld b, b
    add b
    ld [$0200], sp
    nop
    nop
    nop
    nop
    nop
    sub d
    sub b
    nop
    ld bc, $1111
    nop
    nop
    nop
    inc d
    rlca
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc hl
    nop
    nop
    nop
    nop
    and c
    sub b
    ld c, $01
    ld de, $0088
    nop
    nop
    ld b, h
    ld [$0000], sp
    nop
    nop
    nop
    inc c
    nop
    nop
    ld bc, $0000
    nop
    nop
    sub d
    sub b
    ld c, $01
    ld de, $0288
    ld bc, $4400
    rlca
    nop
    nop
    add b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc c
    sub b
    nop
    nop
    ld bc, $0001
    nop
    nop
    nop
    ld [bc], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [hl+], a
    ldh a, [rSB]
    db $10
    db $10
    xor h
    sub b
    cpl
    nop
    ld [bc], a
    ld bc, $0000
    nop
    nop
    dec bc
    nop
    nop
    nop
    db $10
    jr nz, jr_001_7f16

jr_001_7f16:
    nop
    nop
    daa
    nop
    ld [bc], a
    xor b
    rrca
    jr z, jr_001_7f1f

jr_001_7f1f:
    nop
    rst $38
    inc b
    ld bc, Entry
    inc bc
    inc b
    inc d
    nop
    nop
    nop
    db $10
    jr nz, jr_001_7f2e

jr_001_7f2e:
    nop
    nop
    ld bc, $0080
    ldh [$03], a
    ld [hl], l
    nop
    cpl
    ld bc, Entry
    inc b
    ld bc, $0400
    ld b, $00
    nop
    nop
    ld d, b
    nop
    sbc a
    sbc a
    ld a, [bc]
    ld bc, $0388
    nop
    rlca
    add c
    nop
    add b
    nop
    ld bc, $4001
    ld bc, $0100
    ld a, [de]
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    inc bc
    nop
    nop
    ld h, $00
    rrca
    nop
    jr nz, jr_001_7f6a

    ld [bc], a

jr_001_7f6a:
    ld bc, $0108
    nop
    ld [$0000], sp
    nop
    nop
    nop
    ld d, b
    nop
    nop
    nop
    nop
    add b
    nop
    inc d
    ld bc, $00e2
    nop
    nop
    ld bc, $4001
    ld bc, $0200
    nop
    ld bc, $0002
    nop
    nop
    nop
    nop
    nop
    db $fc
    db $f4
    inc b
    db $fc
    ld a, [$06f4]
    nop
    ld hl, sp-$10
    ld [$f800], sp
    and $08
    nop
    or $e0
    ld a, [bc]
    nop
    db $f4
    xor $0c
    nop
    db $fd
    ld hl, sp+$03
    cp $fc
    or $04
    ld a, [$f4f4]
    inc c
    nop
    ld hl, sp-$10
    ld [$f000], sp
    ldh a, [rNR10]
    nop
    ldh a, [$f4]
    stop
    nop
    ldh [$08], a
    add sp, -$08
    ldh [rP1], a
    add sp, -$0c
    add sp, -$04
    ldh a, [$f8]
    add sp, $00
    ldh a, [$f8]
    ld [$1000], sp
    db $f4
    nop
    db $fc
    ld [$e0f8], sp
    ld [$f0f0], sp

jr_001_7fdd:
    ldh a, [rNR10]
    nop
    ldh a, [$ec]
    stop
    db $f4
    ldh a, [$0c]
    jr nc, jr_001_7fdd

    add sp, $0c
    nop
    db $f4
    nop
    inc c
    jr @-$0e

    ldh [rNR10], a
    ld hl, sp-$04
    ldh [rDIV], a
    ld h, b
    ldh [rDIV], a
    ld h, b
    ldh [rDIV], a
    ld h, b
    add h
    db $01
