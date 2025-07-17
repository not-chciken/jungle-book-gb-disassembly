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
    ld hl, Ptr4x4BgTiles1
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
    ld a, [LevelWidthDiv32]
    ld c, a
    add hl, bc                      ; hl = hl + [LevelWidthDiv32] (b is zero)
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
    ld hl, Ptr2x2BgTiles1    ; Address in the RAM.
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
    ld e, a                   ; e = [NextLevel]
    cp 11
    jr nz, :+
    ld d, $20                 ; d = $20 if Level 11
 :  ld a, [LevelWidthDiv32]
    ld b, 0
    add a                     ; a = a << 1
    rl b                      ; b[0] = LevelWidthDiv32[7]
    swap b                    ; b[4] = LevelWidthDiv32[7]
    swap a
    ld c, a
    and %1111                 ; a = LevelWidthDiv32[6:2]
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
    ld a, [LevelHeightDiv32]
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
    ld [LeftLvlBoundingBoxXLsb], a  ; TODO: What is this? Something seems to happen when the player reaches this point.
    xor a
    ld [LeftLvlBoundingBoxXMsb], a  ; = 0
    ld [$c1d2], a                   ; = 0
    ld [$c1d3], a                   ; = 0
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

; $4184: Updates displayed mask time.
UpdateMask::
    ld a, [PlayerFreeze]
    or a
    ret nz
    ld a, [IsPlayerDead]
    or a
    ret nz
    ld a, [Mask60HzTimer]
    inc a
    cp 60
    jr c, UpdateMaskTime

; $14196: Draws and also updates time (minus one second).
; Numbers that reach 0 are set to $ff.
DrawTime::
    ld a, [FirstDigitSeconds]
    dec a
    bit 7, a                    ; Only set if "a" was 0.
    jr z, .DrawFirstDigitSeconds
    ld a, [SecondDigitSeconds]
    dec a
    bit 7, a                    ; Only set if "a" was 0.
    jr z, .DrawSecondDigitSeconds
    ld a, [DigitMinutes]
    dec a
    bit 7, a                    ; Only set if "a" was 0.
    jr z, .DrawMinutes
.NoTimeLeft:
    ld a, [TransitionLevelState]
    or a
    ret nz                      ; Return when in transition level.
    ld a, [NextLevel]
    cp 11                       ; Next level 11?
    jp z, FinishLevel           ; Jump if Level 11 (bonus). Level finished by running out of time.
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
    ld a, [TransitionLevelState]
    or a
    jr z, CheckBeepBeep             ; Jump when not in transition level. There's no "beep beep" in transition level.
    xor a
    ret

; $41e2: Plays "beep beep" if time is running out and reduces invincibility by one second if mask is selected.
CheckBeepBeep:
    call CheckIfTimeRunningOut
    xor a                           ; = 0

; $41e6
UpdateMaskTime:
    ld [Mask60HzTimer], a
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
    jr LastInvincibleSecond2

LastInvincibleSecond:
    ld a, $0f

; $4209
LastInvincibleSecond2:
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

; $423d: Shoots a projectile if player state and number of free projectile slots allow it.
; Input: b = [JoyPadData]
ShootProjectile::
    bit BIT_IND_B, b
    ret z                           ; Return if "B" is not pressed.
    bit BIT_IND_SELECT, b
    ret nz                          ; Return if "SELECT" is pressed.
    ld a, [XAcceleration]
    and %1111
    jp nz, ResetBFlag               ; Jump when player is breaking.
    ld a, [InShootingAnimation]
    or a
    ret nz                          ; Return if projectile is currently flying.
    ld [CrouchingAnimation], a
    ld a, [LookingUpDown]
    dec a
    jr nz, :+
    ld [LookingUpDown], a
 :  ld a, [WeaponActive]
    cp WEAPON_STONES            ; Check for stones.
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
    jr nz, InsertNewProjectile      ; Jump if walking or falling.
    ld a, [IsJumping]
    or a
    jp nz, InsertNewProjectile      ; Jump if jumping.
    ld a, [LandingAnimation]
    or a
    jp nz, InsertNewProjectile      ; Jump if landing.
    ld a, [PlayerOnULiana]
    or a
    jp nz, InsertNewProjectile      ; TODO: Find out what c169 is used for.
    ld a, [PlayerOnLiana]
    and $01
    jp nz, InsertNewProjectile
    xor a
    ld [CrouchingHeadTilted], a     ; = 0
    ld [AnimationCounter], a        ; = 0
    dec a
    ld [InShootingAnimation], a     ; = $ff
    ld a, [AnimationIndexNew]
    ld [AnimationIndexNew2], a
    ret

; $42b1: Does nothing if player not in shooting animation, Else counts down [AnimationCounter] and sets head sprite indices.
ShootingAnimation::
    ld a, [InShootingAnimation]
    or a
    ret z                           ; Return if player is not in shooting animation.
    ld a, [AnimationCounter]
    inc a
    and %111
    ld [AnimationCounter], a        ; = [AnimationCounter] & %111
    ret nz                          ; Continue every 8th call.
    ld a, [CrouchingHeadTilted]
    inc a
    and %1
    ld [CrouchingHeadTilted], a     ; Toglle Bit 0 of [CrouchingHeadTilted].
    jr nz, SetHeadSpriteIndices
    ld [InShootingAnimation], a     ; = 0
    ld a, [AnimationIndexNew2]
    jp SetAnimationIndexNew


; $42d4: Not jumped to if player is walking.
; Bug when pressing LEFT, RIGHT, and DOWN at the same time, you can shoot bananas through a pipe
SetHeadSpriteIndices:
    ld a, [PlayerDirection]         ; = 0 doing nothing, 4 up, 8 down
    ld b, 0
    ld c, a
    ld hl, HeadSpriteIndices
    ld a, [WeaponActive]
    cp WEAPON_STONES
    jr nz, :+
    ld l, LOW(HeadSpriteIndicesPipe) ; When shooting stones the player uses a pipe.
 :  add hl, bc                       ; hl = [$676c + [PlayerDirection]] or [$6777 + [PlayerDirection]]
    ld a, [hl]                       ; [HeadSpriteData + [AmmoBase]]
    ld [AnimationIndexNew], a

; $42eb: Inserts a new projectile object into the RAM if there is a free slot.
; [WeaponActive] determines which kind of object is inserted.
InsertNewProjectile:
    ld a, [WeaponActive]
    cp WEAPON_DOUBLE_BANANA
    jr nz, NotADoubleBanana         ; Jump if weapon is not double banana.
    ld hl, ProjectileObject0
    IsObjEmpty
    jr nz, CreateDoubleBanana       ; Jump if first projectile slot is empty.
    ld l, LOW(ProjectileObject2)
    IsObjEmpty
    jp z, ResetBFlag                ; Jump if second projectile slot is not empty.

; $4300
CreateDoubleBanana:
    ld de, StartOffsetDoubleBananaProjectile
    ld a, [PlayerDirection]
    add a
    add a
    add e
    ld e, a                         ; de += ([PlayerDirection] << 2)
    ld b, 2
    ld c, $00

.Loop:
    push bc
    call CreateProjectileObject
    ld a, l
    add SIZE_PROJECTILE_OBJECT
    ld l, a
    pop bc
    ld c, $02
    dec b
    jr nz, .Loop

    ld hl, CurrentNumDoubleBanana
    jp DecrementProjectileCount

; $4322
NotADoubleBanana:
    ld de, $6741                    ; Start offsets for non-double banana projectiles.
    ld c, $00
    ld hl, ProjectileObject0
    IsObjEmpty
    jr nz, :+                       ; Jump if first projectile slot is empty.
    ld l, LOW(ProjectileObject1)
    IsObjEmpty
    jp z, ResetBFlag                ; Jump if second projectile slot not is empty.

 :  or a                            ; a = [ActiveWeapon]
    jp z, CreateProjectileObject    ; Jump if object to be created is a default banana.

    cp WEAPON_BOOMERANG
    jr z, CreateBoomerangBanana     ; Jump if object to be created is a boomerang banana.

    call CreateProjectileObject
    ld [hl], $00
    ld a, ID_PROJECTILE_STONES
    rst SetAttr                     ; obj[ATR_ID] = ID_PROJECTILE_STONES
    ld c, ATR_BANANA_SHAPED
    xor a
    rst SetAttr                     ; obj[$b] = 0
    ld hl, CurrentNumStones
    jr DecrementProjectileCount

; $434e: Creates a boomerang banana in the given empty projectile slot in "hl".
; Bug: When shooting downwards and sideways at the same time, boomerang never returns.
CreateBoomerangBanana:
    call CreateProjectileObject
    set 0, [hl]
    push hl
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPosition]
    ld a, [PlayerDirection]
    cp PLAYER_FACING_UP_MASK
    jr z, .NotFacingUp              ; Jump if not facing up.
    ld a, [FacingDirection]
    ld bc, 80
    and $80
    jr z, .FacingRight              ; Jump if facing right.
    ld bc, -80
.FacingRight:
    add hl, bc                      ; hl = [PlayerPositionX] + FacingRight ? 80 : -80
.NotFacingUp:
    ld d, h
    ld e, l                         ; de = PlayerPositionX + offset
    pop hl
    ld a, e
    ld c, ATR_TARGET_X_LSB
    rst SetAttr                     ; obj[ATR_TARGET_X_LSB] = PlayerPositionXLsb + offset
    ld a, d
    inc c
    rst SetAttr                     ; obj[ATR_TARGET_X_MSB] = PlayerPositionXMsb + carry
    ld a, [PlayerDirection]
    cp $08
    jr nz, .IsLookingDown           ; Jump if player is looking down.
    xor a                           ; a = 0
.IsLookingDown:
    ld c, ATR_TARGET_DIRECTION
    rst SetAttr                     ; obj[ATR_TARGET_DIRECTION] = [PlayerDirection] or 0 if player is looking down. Bug when looking down sideways!
    push hl
    ld hl, BoomerangOffsetData
    ld b, $00
    ld c, a
    add hl, bc
    ld c, [hl]                      ; c = [BoomerangOffsetData + obj[ATR_TARGET_DIRECTION]]
    bit 7, c                        ; Check if number is negative.
    jr z, :+
    dec b                           ; b = $$ (for negative values)
 :  ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = PlayerPositionY
    add hl, bc
    ld d, h
    ld e, l                         ; de = PlayerPositionY + some other offset
    pop hl
    ld a, e
    ld c, ATR_TARGET_Y_LSB
    rst SetAttr                     ; obj[ATR_TARGET_Y_LSB] = PlayerPositionYLSb + some other offset
    ld a, d
    inc c
    rst SetAttr                     ; obj[ATR_TARGET_Y_MSB] = PlayerPositionYMSb + carry
    ld a, $44
    ld c, ATR_PROJECTILE_0E
    rst SetAttr                     ; obj[ATR_PROJECTILE_0E] = $44
    ld c, ATR_TARGET_DIRECTION
    rst GetAttr                     ; a = obj[ATR_TARGET_DIRECTION]
    cp $04
    jr nc, .Not45Degrees

    SetAttribute ATR_Y_POS_DELTA, 1
    SetAttribute ATR_FREEZE, $88
    jr .End

.Not45Degrees:
    cp $04
    jr nz, .End
    SetAttribute ATR_POSITION_DELTA, $0f
    SetAttribute ATR_09, $88

.End:
    ld hl, CurrentNumBoomerang

; $43cc: Called with pointer to number of projectiles in "hl".
DecrementProjectileCount:
    ld a, [hl]
    dec a
    daa
    ld [hl], a                      ; Reduce number by one.
    jr nz, :+
    ld [WeaponActive], a            ; Change to default banana if number of projectiles reaches 0.
 :  jp UpdateWeaponNumber

; $43d8: Called once when a banana (including boomerang banana) projectile is fired by the player.
; "hl": pointer to empty projectile slot
; "de": pointer to start position offset data of the object.
CreateProjectileObject:
    ld [hl], %100
    ld a, c
    ld c, ATR_PERIOD_TIMER1
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER1] = c (0 most of the time)
    dec c
    ld a, 1
    rst SetAttr                     ; obj[ATR_PERIOD_TIMER0] = 1
    ld c, ATR_HITBOX_PTR
    rst SetAttr                     ; obj[ATR_HITBOX_PTR] = 1
    ld c, PROJECTILE_BASE_SPEED
    ld a, [WalkingState]
    or a
    jr z, :+                        ; Jump if player is standing still.

    inc c                           ; Increase projectile speed by 1 if player is walking.
    inc a
    jr nz, :+                       ; Continue if player is running.

    inc c                           ; Increas projectile speed again if player is running.

 :  ld a, [PlayerDirection]
    ld b, a
    and PLAYER_FACING_RIGHT_MASK | PLAYER_FACING_LEFT_MASK
    jr nz, .Walking                 ; Jump if player is walking left or right.

    bit 2, b
    jr nz, .SetSpeed                ; Jump if player is looking up.

.Walking:
    ld a, [FacingDirection]
    add a                           ; a <<= 1
    bit 7, a
    jr nz, .NegateSpeed             ; Jump if player is facing left.

    add c
    jr .SetSpeed

.NegateSpeed:
    sub c

.SetSpeed:
    ld c, ATR_POSITION_DELTA
    push af
    and %1111                       ; Only lower nibble for speed.
    push bc
    rst SetAttr                     ; = +-3 for default banana, stones, and double banana when standing. +-4 when walking. +-5 when running.
    pop bc
    ld a, b                         ; a = [PlayerDirection]
    and PLAYER_FACING_UP_MASK
    jr z, .SetVerticalSpeed         ; Jump if player is not facing up.

    ld a, b
    and PLAYER_FACING_RIGHT_MASK | PLAYER_FACING_LEFT_MASK
    ld a, -3
    jr z, .SetVerticalSpeed         ; Jump if player is looking straight up.
    ld a, -2

 .SetVerticalSpeed:
    push bc                         ; Push [PlayerDirection] and ATR_POSITION_DELTA
    inc c
    rst SetAttr                     ; obj[ATR_BALL_VSPEED] = $fd when shooting up, $fe when shooting diagonal, 0$ else
    ld a, $11
    inc c
    rst SetAttr                     ; obj[9] = 11 (related to boomerang behavior)
    inc c
    rst SetAttr                     ; obj[$a] = 11 (related to boomerang behavior)
    inc c
    ld a, $02
    rst SetAttr                     ; obj[ATR_BANANA_SHAPED] = 2
    pop bc
    bit 2, b                        ; Test if facing up.
    ld b, PROJECTILE_Y_OFFSET_UP
    jr nz, :+                       ; Jump if facing up.

    ld b, PROJECTILE_Y_OFFSET_CROUCH
    ld a, [IsCrouching2]
    or a
    jr nz, :+                       ; Jump if crouching.

    ld b, PROJECTILE_Y_OFFSET_NORMAL

 :  ld a, [de]
    inc de
    add b
    ld b, a
    ld a, [PlayerPositionYLsb]
    sub b
    push af
    ld c, ATR_Y_POSITION_LSB
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = [PlayerPositionYLsb] - ([de] + offset)
    pop af
    ld a, [PlayerPositionYMsb]
    sbc 0
    inc c
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = ...
    pop af                          ; Pop [PlayerDirection] and ATR_POSITION_DELTA
    or a
    jr z, .CalculateProjectileXPos  ; Jump if player is doing nothing.
    ld b, -4
    bit 7, a
    jr nz, .CalculateProjectileXPos  ; Jump if player is looking down.
    ld b, 4

; $445e
.CalculateProjectileXPos:
    ld a, [de]                      ; Get projectile X offset.
    inc de
    add b                           ; a = projectile X offset +- 4
    ld b, a
    ld a, [PlayerPositionXLsb]
    add b
    bit 7, b
    jr z, .NotNegativ
    ccf

; $446b
.NotNegativ:
    ld b, 0
    jr nc, .SetProjectileXPos
    ld b, 1
    jr z, .SetProjectileXPos
    ld b, -1

; $4475
.SetProjectileXPos:
    inc c
    push bc
    rst SetAttr                     ; obj[ATR_X_POSITION_LSB] = ...
    pop bc
    ld a, [PlayerPositionXMsb]
    add b
    inc c
    rst SetAttr                     ; obj[ATR_X_POSITION_MSB] = ...
    inc c
    ld a, ID_PROJECTILE_BANANA
    rst SetAttr                     ; obj[ATR_ID] = ID_PROJECTILE_BANANA (stones change it after the function was called!)
    inc c
    ld a, $90
    rst SetAttr                     ; obj[ATR_06] = $90
    dec c
    ld a, [WeaponActive]
    or a
    ret nz                          ; Continue if default banana is active.
    ld a, [WeaponSelect]
    cp WEAPON_MASK
    jr nz, :+                       ; Jump if mask is currently not selected.
    ld a, [CurrentSecondsInvincibility]
    or a
    ret nz                          ; Return if some invicibility seconds are left.
 :  jp SelectDefaultBanana

; $449c
ResetBFlag:
    ld a, [JoyPadDataNonConst]
    and ~BIT_B
    ld [JoyPadDataNonConst], a                   ; Set Bit 1 to 0.
    ret

; $44a5
; Input: c = 4 or 6
SetWalkingOrRunningAnimation:
    ld a, [LandingAnimation]
    or a
    ret nz                          ; Return if player is landing.
    ld a, [IsJumping]
    or a
    ret nz                          ; Return if player is jumping.
    ld a, [WalkingState]
    inc a
    jr z, SetRunningAnimation       ; Return if player is running.
    ld a, [AnimationCounter]
    inc a
    cp c
    jr c, .Carry
    xor a
.Carry:
    ld [AnimationCounter], a        ; = [0..3] or [0..5]
    ret nz                          ; Only continue every 4 or 6 calls.
    ld a, [CrouchingHeadTilted]
    cp 2
    jr c, .ResetToTwo
    inc a
    cp 10
    jr c, .SetAnimation

; $44cd
.ResetToTwo:
    ld a, 2

; $44cf
.SetAnimation:
    ld [CrouchingHeadTilted], a
    jr SetAnimationIndexNew

; $44d4
SetRunningAnimation:
    ld a, [AnimationCounter]
    inc a
    cp 4
    jr c, .Carry
    xor a
.Carry:
    ld [AnimationCounter], a        ; = [0..3]
    ret nz                          ; Only continue every 4 calls.
    ld a, [CrouchingHeadTilted]
    cp 10
    jr c, .ResetToTen
    inc a
    cp 22
    jr c, .SetAnimation

; $44ed
.ResetToTen:
    ld a, 10

; $44ef
.SetAnimation:
    ld [CrouchingHeadTilted], a

; $44f2: Set AnimationIndexNew to "a" and return.
SetAnimationIndexNew:
    ld [AnimationIndexNew], a
    ret

; $44f6: Changes the player's sprites when climbing a liana straight up or down. Sprites are changed every 4th call.
; Input: c = direction change (1 or -1)
LianaClimbAnimation:
    ld a, [AnimationCounter]
    inc a
    and %11
    ld [AnimationCounter], a        ; = [AnimationCounter] % 11
    ret nz                          ; Only continue every 4th call.
    ld a, [CrouchingHeadTilted]
    add c
    bit 7, a
    jr z, .NoUnderflow

.Underflow:
    ld a, 11                        ; When [CrouchingHeadTilted] + -1 reaches -1, set it to 11.
    jr .SetAnimationCounter

; $450c
.NoUnderflow:
    cp NUM_CLIMBING_ANIM_FRAMES * 2
    jr c, .SetAnimationCounter
    xor a                           ; When [CrouchingHeadTilted] + 1 reaches 12, set it to 0.

; $4511
.SetAnimationCounter:
    ld [CrouchingHeadTilted], a     ; [CrouchingHeadTilted] in [0:11]
    ld c, a
    cp NUM_CLIMBING_ANIM_FRAMES
    jr c, .SetAnimationIndexNew     ; There are
    sub NUM_CLIMBING_ANIM_FRAMES

; $451b
.SetAnimationIndexNew:
    add CLMBING_ANIM_IND
    ld [AnimationIndexNew], a       ; There are 6 animations for the climbing motion. If you include the flipping it's 12.
    ld a, c
    cp NUM_CLIMBING_ANIM_FRAMES
    ld a, 1                         ; Move left arm up.
    jr c, .SetClimbSpriteDirection
    ld a, -1                        ; Move right arm up.

; $4529
.SetClimbSpriteDirection:
    ld [LianaClimbSpriteDir], a     ; = 1 or -1
    ret

; $452d
DpadUpContinued2:
    ld a, [IsCrouching2]
    or a
    ret nz
    ld a, [IsJumping]
    or a
    ret nz
    ld a, [XAcceleration]
    and %1111
    ret nz                          ; Return if player is breaking.
    ld a, [LookingUpDown]
    or a
    jr nz, .PlayerAlreadyLookingUp

.StartLookingUpAnimation:
    ld [LookingUpAnimation], a      ; = 0
    dec a
    ld [LookingUpDown], a           ; = $ff

; $454a
.PlayerAlreadyLookingUp:
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, .StraightLookUp

.SidewayLookUp:
    ld a, [LookingUpAnimation]
    cp 7
    ret z
    ld a, 7
    jr SetLookingUpAnimation

; $455b
.StraightLookUp:
    ld a, [LookingUpAnimation]
    inc a
    cp 16                           ; 16 calls to reach animation end.
    ret nc

; $4562
SetLookingUpAnimation:
    ld [LookingUpAnimation], a
    call TrippleShiftRightCarry
    ld hl, LookingUpInds
    jr LoadAndSetAnimationIndex

Jump_001_456d:
    ld a, [JoyPadData]
    and BIT_UP
    ret nz

    ld a, [LookingUpDown]
    dec a
    ret z

    ld a, [LookingUpAnimation]
    or a
    jr z, jr_001_4581

    dec a
    jr nz, SetLookingUpAnimation

jr_001_4581:
    jp Jump_001_463b

; $4584
DpadDownContinued::
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    ld a, [IsCrouching2]
    or a
    jr nz, PlayerAlreadyCrouching   ; Jump if player is crouching.
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    ret nz                          ; Return if left or right button is pressed.
    ld [CrouchingHeadTilted], a     ; = 0
    ld [IsCrouching], a             ; = 0
    ld [CrouchingHeadTiltTimer], a  ; = 0
    dec a
    ld [IsCrouching2], a            ; = $ff
    ret

; $45a3: TODO: Continue here.
PlayerAlreadyCrouching:
    ld a, [IsCrouching]
    ld c, a
    inc a
    cp 16
    jr c, jr_001_45e9               ; Jump for the first calls when crouching.
    ld a, [CrouchingAnimation]
    inc a
    ld [CrouchingAnimation], a
    cp 12
    ld a, c
    jr c, jr_001_45e9
    ld a, 12
    ld [CrouchingAnimation], a
    ld a, [LookingUpDown]
    or a
    jr nz, jr_001_45ca
    ld [CrouchingHeadTiltTimer], a
    inc a
    ld [LookingUpDown], a

jr_001_45ca:
    ld a, [CrouchingHeadTiltTimer]
    inc a
    and %11111
    ld [CrouchingHeadTiltTimer], a    ; Reset CrouchingHeadTiltTimer every 32 iterations.
    ret nz                            ; Continue every 32 iterations.
    ld a, [CrouchingHeadTilted]
    inc a
    and $1
    ld [CrouchingHeadTilted], a       ; Toggle CrouchingHeadTilted
    inc a
    ld hl, CrouchingInds

; $45e1
; Input: hl = base pointer to animation indices
;        c = offset
LoadAndSetAnimationIndex:
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [hl]
    jp SetAnimationIndexNew

jr_001_45e9:
    ld [IsCrouching], a
    call TrippleShiftRightCarry
    ld b, $00
    ld c, a
    ld hl, CrouchingInds2
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a
    cp $3c
    ret nz                          ; Return for the first index.
    ld b, $30
    call AttachToLiana
    ret nc                          ; Return if player is not going to get attached to a liana.
    ld a, c

Jump_001_4604:
    cp $1e
    jr z, jr_001_4612

    ld a, [NextLevel]
    cp 10
    ret nz                          ; Return if not Level 10.

    ld a, c
    cp $c1
    ret nz

jr_001_4612:
    ld a, [PlayerPositionYLsb]
    add 32
    ld [PlayerPositionYLsb], a
    ld a, [PlayerPositionYMsb]
    adc 0
    ld [PlayerPositionYMsb], a      ; [PlayerPositionY] += 32
    ld de, $0014
    call Call_001_4ae0
    ret


jr_001_4629:
    ld a, [JoyPadData]
    and BIT_DOWN
    ret nz                          ; Return if down button is pressed.

    ld a, [IsCrouching]
    or a
    jr z, jr_001_4638

    dec a
    jr nz, jr_001_45e9

jr_001_4638:
    ld [IsCrouching2], a

Jump_001_463b:
    ld [LookingUpDown], a
    ld [CrouchingAnimation], a
    ld c, a
    jp SetPlayerIdle

; $4645:
TODO4645::
    ld a, [PlayerOnLiana]
    and %1
    ret nz

    ld a, [TransitionLevelState]
    and %11011111
    cp %110
    ret z

    and %1
    ret nz

    ld a, [PlayerOnULiana]
    or a
    ret nz

    ld a, [InShootingAnimation]
    or a
    ret nz

    ld a, [PlayerKnockUp]
    or a
    ret nz

    ld a, [IsCrouching2]
    or a
    jr nz, jr_001_4629

    ld a, [LookingUpDown]
    or a
    jp nz, Jump_001_456d

    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, CheckBrake

    ld a, [PlayerFreeze]
    or a
    jr nz, CheckBrake

    ld a, [XAcceleration]
    and %1111
    jp nz, HandleBrake            ; Jump if player is breaking.
    xor a
    ld [HeadTiltCounter], a       ; = 0
    ret

; $468c:
CheckBrake:
    ld a, [IsJumping]
    or a
    jp nz, Jump_001_4739            ; Jump if player is jumping.
    ld a, [LandingAnimation]
    or a
    jp nz, Jump_001_4739            ; Jump if player is landing.
    call CheckBrakeAndIdleAnim
    xor a
    inc a
    ret

; $46a0: Checks if player needs to brake and handles the head-tilt idle animation.
CheckBrakeAndIdleAnim:
    call CheckPlayerGroundNoOffset
    ld a, [CurrentGroundType]
    cp $02
    jr z, LetPlayerBrakeLeft        ; Steep /-slope
    cp $03
    jr z, LetPlayerBrakeLeft
    cp $0a
    jr z, LetPlayerBrakeRight       ; Steep \-slope
    cp $0b
    jr z, LetPlayerBrakeRight
    ld a, [XAcceleration]
    or a
    jr nz, HandleBrake              ; Jump if player is breaking.
    ld a, [WalkingState]
    and $80
    jr nz, HandleBrake              ; Jump if player running.
    ld c, $00
    ld a, [MovementState]
    or a
    jr z, SetPlayerHeadTilt         ; Call if player if not moving.

; $46cb: Called to let the player idle.
; Input: c = new animation index.
SetPlayerIdle:
    xor a
    ld [MovementState], a           ; = 0 (STATE_IDLE)
    ld [AnimationCounter], a        ; = 0
    ld [WalkingState], a            ; = 0
    ld [$c17e], a                   ; = 0
    ld [XAcceleration], a           ; = 0
    ld [PlayerOnULiana], a          ; = 0
    ld [UpwardsMomemtum], a         ; = 0
    ld [JumpStyle], a               ; = 0
    dec a
    ld [$c15c], a                   ; = $ff
    xor a
    add c                           ; a = c (Why not ld a, c ?!)
    jp SetAnimationIndexNew

; $46ed: This toggles the player's head titlt every few seconds if the player is standing still for a longer period.
SetPlayerHeadTilt:
    ld c, HEAD_TILT_ANIM_IND
    ld a, [TimeCounter]
    and %01111111
    ret nz                          ; Continue every 128th call.
    ld a, [HeadTiltCounter]
    inc a
    ld [HeadTiltCounter], a
    cp 2
    jr z, SetPlayerIdle
    cp 3
    ret nz                          ; Continue if [HeadTiltCounter] reached 3.
    xor a
    ld [HeadTiltCounter], a         ; = 0
    ld c, a                         ; = 0 (STANDING_ANIM_IND)
    jr SetPlayerIdle

; $470a
LetPlayerBrakeRight:
    ld a, OBJECT_FACING_RIGHT
    jr LetPlayerBrake

; $470e
LetPlayerBrakeLeft:
    ld a, OBJECT_FACING_LEFT

; $4710
LetPlayerBrake:
    ld [FacingDirection3], a        ; = 1 or $ff
    ld [FacingDirection], a         ; = 1 or $ff
    ld a, 12
    ld [XAcceleration], a           ; = 12 -> lets player brake
    ld a, $03
    jr BrakeAnimation

; $471f: Reduces [XAcceleration] and sets corresponding animation index for braking.
HandleBrake:
    ld a, [XAcceleration]
    dec a
    ld [XAcceleration], a           ; -= 1
    call TrippleShiftRightCarry
    ld c, $00
    jr nz, BrakeAnimation

.FinishedBraking:
    ld a, [IsJumping]
    or a
    jr nz, Jump_001_4739

    ld a, [LandingAnimation]
    or a
    jr z, SetPlayerIdle

; $4739
Jump_001_4739:
    xor a
    ld [WalkingState], a            ; = 0
    ld [XAcceleration], a           ; = 0
    ret

; $4741: Handles braking animation, braking sound, and non-controllable X-translation.
BrakeAnimation:
    ld b, $00
    ld c, a
    ld a, [IsJumping]
    or a
    jr nz, .jr_001_476d              ; Jump if player is jumping.
    ld a, [LandingAnimation]
    or a
    jr nz, .jr_001_476d              ; Jump if player is landing.
    ld a, [TimeCounter]
    rra
    jr nc, .NoCarry
    ld a, EVENT_SOUND_BRAKE
    ld [EventSound], a               ; = EVENT_SOUND_BRAKE

; $475b
.NoCarry:
    ld hl, BrakingAnimation1
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr nz, .ButtonPressed
    ld hl, BrakingAnimation2

; $4768
.ButtonPressed:
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a

.jr_001_476d:
    ld a, c
    cp $02
    jr nz, .jr_001_4779

    ld a, $80
    ld [WalkingState], a                   ; = $80
    jr .MovePlayer

.jr_001_4779:
    cp $01
    jr nz, .MovePlayer

    ld a, [TimeCounter]
    rra
    ret c

; $4782: Move the player in braking direction as braking implies a non-controllable X translation.
.MovePlayer:
    ld a, [FacingDirection3]
    and $80
    jp nz, MovePlayerLeft
    jp MovePlayerRight

; $478d
SetPlayerStateWalking:
    ld a, [IsJumping]
    or a
    ret nz                          ; Return if player is jumping.
    ld a, [LandingAnimation]
    or a
    ret nz                          ; Return if player is landing.
    ld a, [MovementState]
    cp STATE_WALKING
    ret z                           ; Return if player is walking.
    xor a
    ld [AnimationCounter], a        ; = 0
    ld [$c17e], a                   ; = 0
    inc a
    ld [WalkingState], a            ; = 1 (walking)
    ld [MovementState], a           ; = 1 (STATE_WALKING)
    inc a
    ld [CrouchingHeadTilted], a     ; = 2
    jp SetAnimationIndexNew

; $47b2
LetPlayerFall:
    xor a
    ld [FallingDown], a             ; = 0
    ld [PlayerOnULiana], a          ; = 0
    ld [Wiggle2], a                 ; = 0
    dec a
    ld [LandingAnimation], a        ; = $ff
    ld a, STATE_FALLING
    ld [MovementState], a           ; = 2 (STATE_FALLING)
    dec a
    ld [AnimationCounter], a        ; = 1
    jp NoPlatformGround

Jump_001_47cc:
    ld a, [LandingAnimation]
    or a
    ret z

    inc a
    ret z

    xor a
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld c, a
    jp SetPlayerIdle

; $47de: Sets the player's state to climbing if he is not already doing. Animation counters are reset if state change happens.
SetPlayerClimbing:
    ld a, [MovementState]
    cp STATE_CLIMBING
    ret z                           ; Return if player is already climbing.
    xor a
    ld [AnimationCounter], a        ; = 0
    ld [CrouchingHeadTilted], a     ; = 0
    ld a, STATE_CLIMBING
    ld [MovementState], a           ; = 3 (STATE_CLIMBING)
    ld a, CLMBING_ANIM_IND          ; = $4b (start of climbing animation)
    jp SetAnimationIndexNew

; $47f5: Called when A button was pressed.
; Input: b = [JoyPadData]
AButtonPressed::
    bit 0, b
    ret z                           ; Return if "A" is not pressed
    ld a, [BossHealth]
    or a
    ret z                           ; Return if boss health is zero.
    ld a, [TeleportDirection]
    or a
    ret nz                          ; Return if player is teleporting.
    ld a, [PlayerFreeze]
    or a
    ret nz                          ; Return if player is in cutscene.
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    ld a, [IsJumping]
    or a
    jr nz, ResetAFlag
    ld a, [LandingAnimation]
    or a
    jr nz, ResetAFlag
    ld a, [PlayerOnLiana]
    rra
    jp c, JumpFromLiana             ; Jump if player on liana.
    ld a, [PlayerOnULiana]
    or a
    jr nz, JumpFromLiana            ; Jump if player on U-liana.
    ld a, [PlayerOnLiana]
    and %100
    ld [PlayerOnLiana], a           ; [PlayerOnLiana] = [PlayerOnLiana] & %100 (let liana swing for a bit in case player was hanging on one)
    ld a, EVENT_SOUND_JUMP
    ld [EventSound], a              ; = EVENT_SOUND_JUMP
    ld a, JUMP_DEFAULT
    ld [IsJumping], a
    ld a, DEFAULT_JUMP_MOMENTUM
    call SetUpMomentumVertJump
    ld [CurrentGroundType], a       ; = 0
    ld [Wiggle2], a
    ld [IsCrouching], a
    ld [CrouchingHeadTiltTimer], a
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, .SetJumpStyleAndMomentum
    ld a, [WalkingState]
    inc a
    jr z, .CheckSlope2              ; Jump if player is not walking.
    ld a, [PlayerOnSlope]
    or a
    jr z, .SetSidewayJump           ; Jump if player is not on a slopw.

; $485b
.CheckSlope1:
    cp 2
    jr z, .SetJumpStyleAndMomentum
    inc a
    ld [JumpStyle], a               ; = 2 (SLOPE_JUMP)
    ret

; $4864
.CheckSlope2:
    ld a, [PlayerOnSlope]
    or a
    jr nz, .CheckSlope1

; $486a
.SetSidewayJump:
    ld a, SIDEWAYS_JUMP

; $486c
.SetJumpStyleAndMomentum:
    ld [JumpStyle], a               ; = [1..2]
    cp 1
    ret nz
    ld a, LOW_JUMP_MOMENTUM
    ld [UpwardsMomemtum], a
    ret

; $4878: Resets A-button flag in [JoyPadDataNonConst].
ResetAFlag:
    ld a, [JoyPadDataNonConst]
    and ~BIT_A
    ld [JoyPadDataNonConst], a     ; Set Bit 0 to 0.
    ret

; $4881: Called when catapult is about to yeet the player.
CatapultJump2:
    ld a, JUMP_CATAPULT
    ld [IsJumping], a
    ld a, EVENT_SOUND_CATAPULT
    ld [EventSound], a
    ld a, [NextLevel]
    cp 11
    ld a, CATAPULT_MOMENTUM_BONUS
    jr z, SetUpMomentumVertJump     ; Jump if bonus level.
    ld a, CATAPULT_MOMENTUM_DEFAULT

; $4896: Set upwards momentum for a vertical jump and reset a few other things.
SetUpMomentumVertJump:
    ld [UpwardsMomemtum], a
    xor a
    ld [MovementState], a           ; = 0 (STATE_IDLE) (also applies for jumps)
    jp SetVerticalJump

; $48a0 Called when player is on any type of liana and "A" is pressed.
; Determines also if and how far the player jumps up when jumping off a liana.
JumpFromLiana:
    ld a, [PlayerOnULiana]
    or a
    jr z, .CheckJoypad              ; Jump if player is not on a U-liana.

; $48a6
.ULianaCase:
    ld a, $80
    ld [PlayerOnULiana], a          ; = $80
    xor a
    ld [$c16b], a                   ; = 0
    ld [PlayerSpriteYOffset], a     ; = 0
    ld c, 5

; $48b4
.CheckJoypad:
    ld a, [FacingDirection]
    ld d, a                         ; d = [FacingDirection]
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, .SetPlayerAndLianaState   ; Jump if player does a simple drop.

; $48bf
.CheckLeftRight:
    ld b, a                         ; b = [JoyPadData] & (BIT_LEFT | BIT_RIGHT)
    ld d, 1                         ; d = 1 if player presses right
    bit 4, b
    jr nz, .CheckLianaType          ; Jump if player presses right.
    ld d, -1                        ; d = -1 if player presses left

; $48c8
.CheckLianaType:
    ld a, [PlayerOnULiana]
    or a
    jr nz, .CheckSwingAnimIndex     ; Jump if player is on a U-liana.
    ld a, [PlayerOnLiana]
    cp 3
    jr nz, .SetPlayerAndLianaState  ; Jump if player is not swinging on a straight liana.

; $48d5
.PlayerIsSwinging:
    ld a, [PlayerOnLianaYPosition]
    sub 4
    jr c, .SetPlayerAndLianaState   ; Jump if player at top of the liana.
    ld c, a

; $48dd
.CheckSwingAnimIndex:
    ld a, [PlayerSwingAnimIndex]
    bit 4, b
    jr nz, .CheckPlayerXPos          ; Jump if player presses right.
    cp 3
    jr nc, .SetPlayerAndLianaState
    jr .SetLianaState

; $48ea
.CheckPlayerXPos:
    cp 4
    jr c, .SetPlayerAndLianaState   ; Jump if player is currently swinging on the right side.

; $48ee
.SetLianaState:
    ld a, [PlayerOnULiana]
    or a
    jr nz, .SetMoveStateAndMomemtun ; Jump if player is on a U-liana.
    ld a, 4
    ld [PlayerOnLiana], a           ; = 4

; $48f9: Player gets a proper jump when conditions align.
.SetMoveStateAndMomemtun:
    ld a, JUMP_DEFAULT
    ld [IsJumping], a               ; = JUMP_DEFAULT
    ld a, 3
    ld [JumpStyle], a               ; = 3 (jump from liana)
    xor a
    ld [MovementState], a           ; = 0 (STATE_IDLE, includes jumping)
    ld b, a                         ; b = 0
    ld hl, LianaJumpMomentum
    add hl, bc
    ld a, [hl]
    ld [UpwardsMomemtum], a
    ld a, [PlayerOnULiana]
    or a
    ret nz
    jr .CheckPlayerYPos

; $4917
.SetPlayerAndLianaState:
    xor a
    ld [FallingDown], a             ; = 0
    dec a
    ld [LandingAnimation], a        ; = $ff
    ld a, STATE_LIANA_DROP
    ld [MovementState], a           ; = 6 (STATE_LIANA_DROP)
    ld a, [PlayerOnLiana]
    or a
    ret z                           ; Return if player is not on a straight liana.
    inc a
    and %100
    ld [PlayerOnLiana], a           ; = 0 when simple drop, = 4 when jump from swinging
    jr z, .CalcPlayerXPos

; $4931
.CheckPlayerYPos:
    ld a, [PlayerOnLianaYPosition]
    cp 4
    ret nc

; $4937
.CalcPlayerXPos:
    ld a, [PlayerOnULiana]
    or a
    ret nz                          ; Return if player jumped from a U-liana.
    ld hl, LianaXPositionLsb
    ld a, [hl+]
    ld h, [hl]
    and %11111000
    ld l, a                         ; hl = FLOOR(hl, 8)
    dec hl
    dec hl
    dec hl
    dec hl                          ; hl = FLOOR(hl, 8) - 4
    ld bc, 20                       ; X offset in case the player jumpf off right.
    ld a, d                         ; a = 1 if player presses right, -1 if player presses left
    and $80
    jr nz, .SetPlayerXPos           ; Jump if player presses left.
    add hl, bc

; $4951: New player location is either a bit right or left of the liana.
.SetPlayerXPos:
    ld a, l
    ld [PlayerPositionXLsb], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ret

; $495a
CheckJump::
    ld a, [IsJumping]
    and JUMP_DEFAULT
    jp z, CheckCatapultJump         ; Jump if player is not doing a non-catapult jump.
    ld a, [JoyPadData]
    ld c, a                         ; c = [JoyPadData]
    ld a, [UpwardsMomemtum]
    ld b, a                         ; b = [UpwardsMomemtum]
    ld a, [PlayerOnSlope]
    or a
    ld a, b
    jr nz, .NormalJump              ; Jump if player is on a slope. Weird: Cannot do short jumps on a slope.
    cp 32
    jr nz, .NormalJump              ; Jump if UpwardsMomemtum is not 32.
    bit BIT_IND_A, c
    jr nz, .NormalJump              ; Jump if "A" is currently pressed.

.ShortJump:
    ld a, 12
    ld [UpwardsMomemtum], a

.NormalJump:
    srl a
    ld c, a                         ; [UpwardsMomemtum] >> 1
    ld a, 21
    sub c                           ; a = 21 - ([UpwardsMomemtum] >> 1)
    ld b, $00
    ld c, a                         ; c = 21 - ([UpwardsMomemtum] >> 1)
    ld a, [JumpStyle]
    add a                           ; a  = [JumpStyle] * 2
    ld d, $00
    ld e, a
    ld hl, JumpSpriteIndPtrs
    add hl, de                      ; hl = $633c + [JumpStyle] * 2
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [$633c + [JumpStyle] * 2]]
    add hl, bc                      ; hl += 21 - ([UpwardsMomemtum] >> 1)
    ld a, [hl]
    ld [AnimationIndexNew], a
    ld hl, LiftoffLimits
    srl e                           ; e = [JumpStyle]
    add hl, de                      ; hl = [$6344 + ...]
    ld a, [UpwardsMomemtum]
    or a
    jp z, JumpPeakReached           ; Peak reached when momentum is 0.

    dec a
    ld [UpwardsMomemtum], a         ; [UpwardsMomemtum]--
    srl a                           ; [UpwardsMomemtum] >> 1
    cp [hl]
    ret nc                          ; Return as long as the player is not leaving the ground.

    srl a
    srl a                           ; [UpwardsMomemtum] >> 3
    jr nz, .MomentumLeft

    ld a, [JumpStyle]
    or a
    jp z, JumpPeakReached

    ld a, 1                         ; Weird: Is this reachable?!

; $49be
.MomentumLeft:
    cp 5
    jr c, .ChangYPos

    ld a, 4                         ; Move player 4 pixel upwards.

; $49c4
.ChangYPos:
    call LetPlayerFlyUpwards        ; Amount of upwards movement given by [UpwardsMomemtum] or constant above.
    call NoPlatformGround
    ld a, [PlayerOnLiana]
    or a
    ret nz
    ld a, [UpwardsMomemtum]
    cp $12
    ret nc
    ld a, [PlayerPositionYMsb]
    or a
    jr nz, .YSpaceLeft
    ld a, [PlayerPositionYLsb]
    cp 32
    ret c                           ; Return if player cannot go higher.

; $49e1
.YSpaceLeft:
    call Call_000_151d
    ld de, $ffe0
    jr c, jr_001_49ff

    call Call_000_1521
    ret nc

    ld a, c
    cp $1e
    jr z, jr_001_49fc

    ld a, [NextLevel]
    cp 10
    ret nz

    ld a, c
    cp $c1
    ret nz

jr_001_49fc:
    ld de, $fff0

jr_001_49ff:
    call Call_001_4a6d
    ret

; $4a03
CheckCatapultJump:
    ld a, [IsJumping]
    and JUMP_CATAPULT
    ret z

    ld a, [UpwardsMomemtum]
    srl a
    srl a
    ld c, a                         ; c = [UpwardsMomemtum] >> 2
    ld a, 21
    sub c
    ld b, $00
    ld c, a                         ; c = 21 - ([UpwardsMomemtum] >> 2)
    ld hl, JumpSpriteIndsVert
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a
    ld a, [UpwardsMomemtum]
    or a
    jr z, JumpPeakReached

    dec a
    ld [UpwardsMomemtum], a         ; [UpwardsMomemtum] -= 1
    srl a
    srl a
    cp 18
    ret nc

    srl a
    inc a
    inc a
    cp 9
    jr c, LetPlayerFlyUpwards
    ld a, 8                         ; Move player 8 pixel upwards.

; $4a3a: Lets the player fly upwards.
; Input: a = number of pixels to fly
LetPlayerFlyUpwards:
    push af
    call FlyUpwards1Pixel
    pop af
    dec a
    jr nz, LetPlayerFlyUpwards      ; Loop "a" times.
    ret

; $4a43: Called when the peak of a jump is reached and the player starts to fall.
JumpPeakReached:
    ld [IsJumping], a               ; = 0
    jp LetPlayerFall

; $4a49
HandlePlayerKnockUp::
    ld a, [PlayerKnockUp]
    or a
    ret z                           ; Return if player is not being knocked up.

    dec a
    ld [PlayerKnockUp], a             ; [PlayerKnockUp] -= 1
    srl a
    srl a                           ; a = a >> 2
    jr z, jr_001_4a62

    call LetPlayerFlyUpwards
    ld a, [RunFinishTimer]
    or a
    jp nz, Jump_001_4e4e

jr_001_4a62:
    ld a, [$c176]
    and $80
    jp nz, MovePlayerLeft

    jp MovePlayerRight


Call_001_4a6d:
    ld a, c
    cp $1e
    jr z, Call_001_4ae0

    cp $c1
    jr z, Call_001_4ae0

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
    ld a, PLAYER_HANGING_ON_ULIANA
    ld [PlayerOnULiana], a          ; = 1 (PLAYER_HANGING_ON_ULIANA)
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
    ld [AnimationIndexNew], a       ; = $26
    ld a, $03
    ld [PlayerSwingAnimIndex], a                   ; = 3
    inc a
    ld [$c15f], a                   ; = 4
    ld a, [FacingDirection]
    ld [$c160], a
    pop bc
    ret


Call_001_4ae0:
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPositionX]
    ld bc, -8
    add hl, bc                      ; hl = [PlayerPositionX] - 8
    ld a, l
    and %11110000                   ; ROUND(l, 16)
    bit 4, a
    ret nz                          ; Return if Bit 4 of [PlayerPositionXLsb] was set.
    add 14
    ld l, a
    ld [PlayerPositionXLsb], a
    ld [LianaXPositionLsb], a       ; = [PlayerPositionXLsb]
    ld a, h
    ld [PlayerPositionXMsb], a      ; [PlayerPositionX] = [PlayerPositionX] + 6
    ld [LianaXPositionMsb], a       ; = [PlayerPositionXMsb]
    push hl
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld [$c167], a                   ; = [PlayerPositionYLsb]
    ld a, h
    ld [$c168], a                   ; = [PlayerPositionYMsb]
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
    ld [PlayerOnLiana], a
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
    cp 16
    jr c, jr_001_4b82

    ld a, 15

jr_001_4b82:
    ld [PlayerOnLianaYPosition], a
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr nz, jr_001_4bb9

jr_001_4b8c:
    ld a, STATE_CLIMBING
    ld [MovementState], a           ; = 3 (STATE_CLIMBING)
    ld a, CLMBING_ANIM_IND          ; = $4b (start of climbing animation)
    jp SetAnimationIndexNew

Call_001_4b96:
    xor a
    ld [PlayerOnLiana], a           ; = 0
    ld [PlayerOnULiana], a          ; = 0
    ld [PlayerOnLianaYPosition], a  ; = 0

Call_001_4ba0:
    ld [XAcceleration], a           ; = 0
    ld [WalkingState], a            ; = 0
    ld [IsJumping], a               ; = 0

; $4ba9
SetVerticalJump:
    ld [JumpStyle], a               ; = 0 (VERTICAL_JUMP)
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld [IsCrouching2], a            ; = 0
    ld [LookingUpDown], a           ; = 0
    ret

jr_001_4bb9:
    ld a, [$c15c]
    add a
    add a
    add a
    ld b, $00
    ld c, a
    ld a, $03
    ld [PlayerOnLiana], a           ; = $03
    ld [PlayerSwingAnimIndex], a                   ; = $03
    ld [$c163], a                   ; = $03
    inc a
    ld [MovementState], a           ; = 4 (STATE_SWINGING)
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
    ld a, [FacingDirection]
    ld [hl], a
    ld a, $26
    jp SetAnimationIndexNew

; $4bf3
TODO4bf3::
    ld a, [PlayerWindowOffsetY]
    cp 200
    ret nc
    ld a, [TransitionLevelState]
    or a
    ret nz                          ; Return when in transition level sequence.
    ld a, [IsJumping]
    or a
    ret nz                          ; Return when player is jumping.
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return when player is being knocked up.
    ld a, [PlayerOnLiana]
    and %1
    ret nz                          ; Return when player is attached to a liana.

    ld a, [PlayerOnULiana]
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
    cp 10
    jr nz, jr_001_4c4b

    ld a, c
    cp $c1
    jr nz, jr_001_4c4b

jr_001_4c45:
    ld de, $fff0

jr_001_4c48:
    call Call_001_4a6d

jr_001_4c4b:
    call CheckPlayerGroundNoOffset
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

    ld a, [FallingDown]
    cp 8
    jr c, jr_001_4c79

    ld a, EVENT_SOUND_LAND
    ld [EventSound], a

jr_001_4c79:
    ld a, [CurrentGroundType]
    cp $0c
    jr nz, jr_001_4c88

    ld a, $02
    ld [CatapultTodo], a            ; = 2
    jp Jump_001_4d5d


jr_001_4c88:
    ld a, [CatapultTodo]
    or a
    jp nz, Jump_001_4d5d

    ld a, [FallingDown]
    ld [LandingAnimation], a
    or a
    jr z, Jump_001_4cf1

    ld c, a
    ld b, $06
    ld a, [WalkingState]
    or a
    jr z, Jump_001_4cd8

    inc a
    jr nz, jr_001_4ca6

    ld b, $0e

jr_001_4ca6:
    ld a, c
    dec a
    ld [FallingDown], a
    cp $1b
    jr c, jr_001_4cb3

    ld a, $16
    jr jr_001_4cb4

jr_001_4cb3:
    ld a, b

jr_001_4cb4:
    ld [AnimationIndexNew], a

jr_001_4cb7:
    xor a
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld [UpwardsMomemtum], a         ; = 0
    ld [JumpStyle], a               ; = 0
    ld [PlayerOnULiana], a          ; = 0
    inc a
    ld [MovementState], a           ; = 1 (STATE_WALKING)
    jr Jump_001_4cf1

jr_001_4ccd:
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, jr_001_4cb7

    ld a, $06
    jr jr_001_4cb4

Jump_001_4cd8:
    ld a, c
    dec a
    ld [FallingDown], a
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
    call SetPlayerIdle

Jump_001_4cf1:
    ld c, $00
    ld a, [CurrentGroundType]
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
    ld [PlayerOnSlope], a

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
    call CheckPlayerGroundNoOffset
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

    ld a, [CurrentGroundType]
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
    ld [PlayerWindowOffsetY], a
    cp $48
    jr nc, jr_001_4d10

    call DecrementBgScrollY
    jr jr_001_4d10

Jump_001_4d5d:
    ld a, [LandingAnimation]
    inc a
    jr z, jr_001_4dcf

    ld a, [$c158]
    or a
    jr nz, jr_001_4d7a

    ld b, $04
    call CheckPlayerGround
    jr c, jr_001_4d7a

    ld a, [CurrentGroundType]
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
    call CheckPlayerGround
    jr nc, jr_001_4da7

    pop de
    pop hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ld a, [FallingDown]
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
    ld [PlayerWindowOffsetY], a
    cp $58
    jr c, jr_001_4d7a

    call IncrementBgScrollY
    jr jr_001_4d7a

Jump_001_4dbb:
    ld a, [LandingAnimation]
    or a
    jr nz, jr_001_4dcf

jr_001_4dc1:
    call LetPlayerFall
    ld a, [RunFinishTimer]
    or a
    jr nz, jr_001_4dcf

    ld a, $45
    ld [AnimationIndexNew], a

jr_001_4dcf:
    ld a, [FallingDown]
    inc a
    cp 32
    jr nc, jr_001_4dda

    ld [FallingDown], a             ; [FallingDown]++

jr_001_4dda:
    call TrippleShiftRightCarry
    ret z

    push af
    inc a
    ld b, a
    call CheckPlayerGround
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
    jr nz, Jump_001_4e4e

    ld a, [RunFinishTimer]
    or a
    jr nz, Jump_001_4e4e

jr_001_4e05:
    ld a, [CatapultTodo]
    or a
    jr nz, jr_001_4e38

    ld a, [JumpStyle]
    cp SIDEWAYS_JUMP
    jr z, jr_001_4e32

    dec c
    jr nz, jr_001_4e1b

    ld a, [AnimationIndexNew]
    cp $45
    ret z

jr_001_4e1b:
    ld hl, $6378

jr_001_4e1e:
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a
    ld a, [JumpStyle]
    cp LIANA_JUMP
    ret nz

    ld a, c
    cp $03
    ret c

    xor a
    ld [JumpStyle], a               ; = 0
    ret


jr_001_4e32:
    dec c
    ld hl, $637d
    jr jr_001_4e1e

jr_001_4e38:
    ld c, 218
    ld a, [NextLevel]
    dec a
    jr z, :+

    ld c, 90

 :  ld a, [PlayerPositionYLsb]
    cp c
    ret c

    ld a, c
    ld [PlayerPositionYLsb], a
    jp CheckCatapultLaunch


Jump_001_4e4e:
    ld a, [AnimationCounter]
    or a
    jr z, jr_001_4e59

    dec a
    ld [AnimationCounter], a        ; = $ff
    ret nz

jr_001_4e59:
    ld a, 4
    ld [AnimationCounter], a        ; = 4
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
    ld [AnimationIndexNew], a
    ld a, $01
    bit 7, [hl]
    jr z, jr_001_4e7f

    ld a, $ff

jr_001_4e7f:
    ld [FacingDirection], a                   ; = $01 or $ff
    ret

TODO4e83::
    ld c, a
    ld a, [MovementState]
    or a
    ret z

    ld a, [PlayerOnULiana]
    or a
    ret nz

    ld a, [PlayerOnLiana]
    and $01
    ret nz

    ld a, [IsJumping]
    or a
    ret nz

    ld a, [PlayerKnockUp]
    or a
    ret nz

    ld a, [LandingAnimation]
    or a
    ret nz

    ld a, [LookingUpDown]
    or a
    ret nz

    ld a, [PlayerInWaterOrFire]
    or a
    jr nz, jr_001_4ec8

    ld a, [FacingDirection]
    ld b, a
    ld a, [CurrentGroundType]
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
    ld [WalkingState], a            ; = $1
    xor a
    ld [XAcceleration], a           ; = $0
    ret


jr_001_4ed2:
    ld a, [WalkingState]
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
    ld a, [WalkingState]
    inc a
    ret z

    ld a, $ff
    ld [WalkingState], a            ; = $ff
    ld a, $09
    ld [$c17e], a                   ; = $09
    ld a, $10
    ld [XAcceleration], a           ; = $10
    ld a, [FacingDirection]
    ld [FacingDirection3], a
    ret

TODO14f21:
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
    ld a, [BgScrollYDiv16TODO]
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
    ld a, [BgScrollYLsbDiv8]
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
    ld a, [BgScrollYLsbDiv8]
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

; $4fd4
TODO4fd4::
    ld a, [PlayerOnLiana]
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

    ld a, [PlayerOnLiana]
    and $0f
    ld b, a
    ld a, [hl]
    and $f0
    jr nz, jr_001_500f

    ld a, [hl]
    or a
    jr z, jr_001_500f

    ld [PlayerOnLiana], a
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
    IsObjEmpty
    ret z                           ; Return if object is not deleted.
    ld c, ATR_Y_POSITION_LSB
    rst GetAttr                     ; a = obj[ATR_Y_POSITION_LSB]
    or a
    jr z, .SkipDecr
    rst DecrAttr                    ; obj[ATR_Y_POSITION_LSB]--
    ret nz
.SkipDecr:
    ObjMarkedSafeDelete
    ret nz
    SafeDeleteObject
    inc c
    rst GetAttr
    ld d, a                         ; d = obj[ATR_Y_POSITION_MSB]
    inc c
    rst GetAttr
    ld e, a                         ; e = obj[ATR_X_POSITION_LSB]
    ld a, d                         ; a = obj[ATR_Y_POSITION_MSB]
    and $0f
    add e
    ld b, a
    ld a, d
    and $0f
    swap a
    or b
    ld d, b
    dec c
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = ...
    ld a, d
    ld c, $04
    bit 7, e
    jr nz, jr_001_505d

    inc c

jr_001_505d:
    rst CpAttr
    jr nz, jr_001_509f

    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    cpl
    inc a
    rst SetAttr
    ld a, [hl]
    and $04
    jr z, jr_001_509f

    inc c
    rst GetAttr
    cp $03
    jr z, jr_001_5080

    inc a
    rst SetAttr
    inc c
    rst GetAttr
    cp $03
    jr z, jr_001_5080

    dec a
    rst SetAttr
    ld c, $01
    ld a, c
    rst SetAttr
    ret


jr_001_5080:
    ld c, $04
    xor a
    rst SetAttr
    inc c
    ld a, $06
    rst SetAttr
    ld c, $01
    rst SetAttr
    ld a, [hl]
    ld b, a
    and $71
    ld [hl], a
    and $01
    jr nz, jr_001_509b

    ld a, [PlayerOnLiana]
    and $01
    ret nz

    xor a

jr_001_509b:
    ld [PlayerOnLiana], a
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
    rst SetAttr
    ld a, [hl]
    and $03
    cp $03
    ret nz

    ld c, d
    ld a, c
    cp $03
    jr nz, Jump_001_50d6

    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, Jump_001_50d6

    ld b, a
    ld a, [FacingDirection]
    bit 7, a
    jr z, jr_001_50cd

    bit 4, b
    jr z, Jump_001_50d6

    jr jr_001_50d1

jr_001_50cd:
    bit 5, b
    jr z, Jump_001_50d6

jr_001_50d1:
    cpl
    inc a
    ld [FacingDirection], a                   ; [FacingDirection]++

Jump_001_50d6:
    ld a, [FacingDirection]
    and $80
    jr nz, jr_001_50e0

    ld a, c
    jr jr_001_50e3

jr_001_50e0:
    ld a, $06
    sub c

jr_001_50e3:
    add $23
    ld [AnimationIndexNew], a
    ld a, c
    ld [PlayerSwingAnimIndex], a
    ret

; $50ed
TODO50ed::
    ld a, [PlayerOnULiana]
    cp $01
    jr z, jr_001_5136

    cp $02
    ret nz

    ld a, [FacingDirection]
    and $02
    rra
    ld c, a
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
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
    ld a, [PlayerSwingAnimIndex]
    or a
    jr z, jr_001_5123

    ld a, [FacingDirection]
    and $80
    jp z, Jump_000_0a1b

    jp Jump_000_0b58


jr_001_5123:
    ld a, 1
    ld [PlayerOnULiana], a          ; = 1 (PLAYER_HANGING_ON_ULIANA)
    ld [$c15f], a
    ld a, $03
    ld [PlayerSwingAnimIndex], a
    ld a, [FacingDirection]
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
    and BIT_LEFT | BIT_RIGHT
    jr nz, jr_001_514e

jr_001_514b:
    ld de, $0304

jr_001_514e:
    ld a, [$c160]
    ld b, a
    ld a, [PlayerSwingAnimIndex]
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

Jump_001_5181:
    ld a, [$c163]
    ld b, $00
    ld c, a
    push bc
    ld hl, $60b7
    swap a
    and $f0
    ld c, a
    add hl, bc
    ld a, [PlayerOnLianaYPosition]
    ld c, a
    add hl, bc
    ld d, $00
    ld e, [hl]
    bit 7, e
    jr z, .IsPositive
    dec d
.IsPositive:
    ld hl, LianaXPositionLsb
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

jr_001_51d9:
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
    cp 10
    jr nz, jr_001_5265

    ld c, $01

jr_001_5265:
    ldh a, [rSTAT]
    and STATF_OAM
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
    and STATF_OAM
    jr nz, jr_001_52c1

    pop af
    ld [de], a
    dec b
    jr nz, jr_001_5282

    scf
    ret


; $52ce: Loops over all objects and handles a catapult launch if there is one.
CheckCatapultLaunch:
    ld a, [CatapultTodo]
    and $01
    ret nz                          ; Return if launching process in progress.

    ld a, $05
    ld [AnimationIndexNew], a
    ld hl, GeneralObjects
    ld c, ATR_ID

.Loop:
    rst GetAttr
    cp ID_CATAPULT
    jr z, PrepareCatapultLaunch
    ld a, l
    add SIZE_GENERAL_OBJECT
    ld l, a
    jr nc, .Loop

    ret

; $52ea: Handle catapult object. Is called when player jumps on the catapult.
PrepareCatapultLaunch:
    set 6, [hl]
    ld bc, ATR_PERIOD_TIMER0
    add hl, bc
    ld [hl], $1b
    ld a, $81
    jr SetupCatapultTileMap

; $52f6: Is called when the catapult launches the player.
CatapultJump1:
    ld a, [CatapultTodo]
    and $01
    ret z                           ; Return if no launching process in progress.

    ld a, EVENT_SOUND_EXPLOSION
    ld [EventSound], a
    call CatapultJump2
    ld a, $80

; $5306
SetupCatapultTileMap:
    ld [CatapultTodo], a            ; =$80 (if player was launched) or =$81 (if launch in progress)
    TilemapLow hl, 24, 9
    ld a, [PlayerPositionXMsb]
    or a
    jr z, :+
    TilemapLow hl, 22, 25
    cp 2
    jr z, :+
    TilemapLow hl, 18, 25
 :  ld a, l
    ld [CatapultTilemapPtrLsb], a   ; LSB pointer to tile map.
    ld a, h
    ld [CatapultTilemapPtrMsb], a   ; MSB pointer to tile map.
    ret

; $5306: Copies the catapult's tile map into the VRAM.
CopyCatapultTiles:
    ld a, [CatapultTodo]
    and %1
    ld [CatapultTodo], a            ; [CatapultTodo] = [CatapultTodo] & 1
    ld c, 27
    ld hl, CatapultTilemapPtrLsb
    ld de, CatapultTilemap2
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = pointer to tile map
    jr nz, :+

    ld de, CatapultTilemap1

 :  ld b, 6
    call CopyDataFromDeToHl
    add hl, bc                      ; hl += $1b
    ld a, [de]
    ld [hl+], a
    inc hl
    inc hl
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    add hl, bc
    call Copy2BytesFromDeToHl
    inc hl
    inc hl

; $5351
Copy2BytesFromDeToHl:
    ld b, 2

; $5353: Copies data from "de" to "hl" of size "b". All "de", "hl", and "b" are changed.
CopyDataFromDeToHl:
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, CopyDataFromDeToHl
    ret

; $535a
CatapultTilemap1::
    db $70, $71, $72, $02, $02, $02, $02, $73, $02, $02, $74, $75

; $5366
CatapultTilemap2::
    db $02, $02, $02, $76, $77, $78, $79, $02, $7a, $7b, $02, $02

Call5372:
    call DrawNewHorizontalTiles
    ret nz
    call DrawNewVerticalTiles
    ret nz

    ld a, [NextLevel]
    cp 3
    jr z, .Level3or5
    cp 5
    ret nz
.Level3or5:
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
    ld a,4

jr_001_53b3:
    push af

.OamLoop:
    ldh a, [rSTAT]
    and STATF_OAM
    jr nz, .OamLoop

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    pop af
    dec a
    jr nz, jr_001_53b3

    ld [$c1cf], a                   ; = 0
    ret

; $153c6:: Copies 20 bytes/tiles from $c3c0 to the corresponding position in tile map.
; The position is given by the pointer in "hl".
; The copied tiles form a vertical line from top to bottom.
; Returns 0 if no tiles were copied. Returns 1 if tiles were copied.
; See also: DrawNewHorizontalTiles.
DrawNewVerticalTiles:
    ld a, [NeedNewXTile]               ; Need to draw new tiles?
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
    cp HIGH(_SCRN1)             ; Check if we exceed tile map ($9c00 is behind tile map).
    jr c, :+
    ld h, HIGH(_SCRN0)          ; Wraparound if exceeded ($9800) is the first tile.
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-                   ; Don't write during OAM search.
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 1).
    add hl, bc                  ; Next tile in Y-direction.
    ld a, h
    cp HIGH(_SCRN1)             ; Check if we exceed tile map ($9c00 is behind tile map).
    jr c, :+
    ld h, HIGH(_SCRN0)          ; Wraparound if exceeded ($9800) is the first tile.
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 2).
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 3)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 4)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 5)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 6)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 7)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 8)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                   ; Write into background tile index map (Tile 9)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 10)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 11)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 12)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 13)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 14)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]                  ; Write into background tile index map (Tile 15)
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 16)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 17)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 18)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  ldh a, [rSTAT]
    and STATF_OAM
    jr nz, :-
    ld a, [de]
    inc e
    ld [hl], a                  ; Write into background tile index map (Tile 19)
    add hl, bc
    ld a, h
    cp HIGH(_SCRN1)
    jr c, :+
    ld h, HIGH(_SCRN0)
 :  xor a
    ld [NeedNewXTile], a  ; = 0
    inc a                         ; a = 1
    ret

; $1556f:: Copies bytes/tiles from $c3d8 to the corresponding position in tile map.
; The position is given by the pointer in "hl".
; The copied tiles form a horizontal line.
; Returns 0 if no tiles were copied. Returns 1 if tiles were copied.
; See also: DrawNewVerticalTiles.
DrawNewHorizontalTiles:
    ld a, [NeedNewYTile]
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
    ld [NeedNewYTile], a            ; = 0.
    inc a
    ret

; $56f6: Handles the sequence in the transition level.
TransitionLevelSequence::
    ld a, [TransitionLevelState]
    or a
    ret z                           ; Return if not in transition level;

    and %11011111
    cp 1
    jr z, CollectTimeSequence

    cp 3
    jr z, CollectDiamondSequence

    cp 5
    jr nz, OtherScene1

CollectShovelSequence:
    ld b, a
    ld a, [BonusLevel]
    or a
    jp z, LoadNextLevel             ; Jump if bonus level item was not collected.

    ld a, b

; $5712: Sequence 1: Also called for the collection of the shovel in case it was collected.
CollectTimeSequence:
    push af
    call MovePlayerRight
    call CheckPlayerCollisions
    pop bc
    ld a, [PlayerPositionXLsb]
    cp 124
    ret c                           ; Return if player behind 124.

.PlayerReachesRightSide:            ; After walking from left to right, the player finally reached the end point.
    xor a
    ld [AnimationIndexNew], a       ; = 0
    ld a, b
    cp 5
    jr z, ShovelingSequence

    ld a, OBJECT_FACING_LEFT
    ld [FacingDirection], a         ; = $ff (turns player left)
    ld a, 1
    ld [DiamondConvertTicks], a     ; = 1
    jr GoIntoNextSequenceState

; $5735: Sequence 6: Called when the player had collected the shovel.
ShovelingSequence:
    ld a, 8
    ld [AnimationCounter], a        ; = 8
    xor a
    ld [CrouchingHeadTilted], a     ; = 0
    ld [IsCrouching], a             ; = 0
    dec a
    ld [CrouchingHeadTiltTimer], a  ; = $ff
    ld a, $3e
    ld [AnimationIndexNew], a       ; = $3e
    jr GoIntoNextSequenceState

; $574c: Sequence 3
CollectDiamondSequence:
    call MovePlayerLeft
    call CheckPlayerCollisions
    ld a, [PlayerPositionXLsb]
    cp 40
    ret nc                          ; Return if player is right of this point.

.PlayerReachesLeftSide:
    xor a
    ld [AnimationIndexNew], a       ; = 0
    inc a
    ld [FacingDirection], a         ; = 1

; $5760
GoIntoNextSequenceState:
    ld a, [TransitionLevelState]
    inc a
    ld [TransitionLevelState], a                   ; += 1
    ret

; $5768
OtherScene1:
    cp 2
    jr nz, OtherScene2

; Sequence 2: Reduces time by one adds points to the score.
ConvertTimeToScore::
    call DrawTime
    push af
    ld a, [DifficultyMode]
    or a
    ld a, SCORE_TIME                ; You will get 100 points in normal and 10 points in practice mode for each remaining second.
    jr z, :+                        ; Jump if normal mode.
    swap a                          ; Less points in practice mode.
 :  call DrawScore3                 ; One second gives 10 points in practice and 100 in normal.
    pop af
    ret z                           ; Return if still some time left.

    jr KickoffBonusString           ; Point reached if time is 0.

; $5781
OtherScene2:
    bit 6, a
    jr z, OtherScene3

    ld hl, GeneralObjects + $40
    IsObjOnScreen
    ret nz

    ld a, 6
    ld bc, SIZE_GENERAL_OBJECT

.Loop:
    ld [hl], EMPTY_OBJECT_VALUE
    add hl, bc
    dec a
    jr nz, .Loop

    ld [$c1e6], a                   ; = 0
    ld a, [TransitionLevelState]
    and $0f
    or $10
    ld [TransitionLevelState], a    ; = $10 | ($0f & [TransitionLevelState])
    ret

; $_57a4
OtherScene3:
    cp 4
    jr nz, OtherScene4              ; Taken for $81, for example.

; $57a8: Sequence 4: Get points for every diamond.
ConvertDiamondsToScore::
    ld hl, DiamondConvertTicks
    dec [hl]
    ret nz
    ld [hl], 4                      ; Every 4 frames one diamond is added to the score.
    call DiamondFound
    push af
    ld a, [DifficultyMode]
    ld c, a
    ld a, SCORE_DIAMOND_TRANSITION
    sub c
    swap a                          ; a = 20 in normal and 10 in practice mode.
    call DrawScore3
    pop af
    ret nz                          ; Kick off bonus string if number reaches 0.

; $57c1: After this function the "BONUS" strings shifts out.
KickoffBonusString:
    ld a, [TransitionLevelState]
    and %11011111
    or $40
    ld [TransitionLevelState], a    ; [TransitionLevelState] |= $40
    ld hl, GeneralObjects + SIZE_GENERAL_OBJECT * 2 + 7
    ld b, 6                         ; "BONUS" string plus 1 object are 6 objects.
    ld c, $02
.Loop:                              ; Loop 6 times.
    ld [hl], c                      ; obj[ATR_FACING_DIRECTION] = 2
    inc l
    inc l
    ld [hl], $01                    ; obj[$9] = 1
    ld a, l
    add SIZE_GENERAL_OBJECT - 2
    ld l, a
    dec b
    jr nz, .Loop
    ret

; $57df
OtherScene4:
    cp 6
    ret nz

DiggingAnimation:
    ld hl, AnimationCounter
    dec [hl]
    ret nz                          ; Continue every eigth call.
    ld [hl], 8                      ; Set [$151] to 8.
    ld a, [CrouchingHeadTilted]
    inc a
    cp 7
    jr c, :+
    xor a
 :  ld [CrouchingHeadTilted], a     ; a = [0..7]
    ld hl, ShovelingAnimHeadSpriteInds
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a
    cp $53
    ret nz

    ld a, [IsCrouching]
    inc a
    and %1
    ld [IsCrouching], a
    ret z

    ld a, [PlayerPositionYLsb]
    cp 152
    jr nc, LoadNextLevel

    add 4
    ld [PlayerPositionYLsb], a      ; Player descends 4 pixels.
    ld hl, HoleTileMapData
    ld a, [CrouchingHeadTiltTimer]
    inc a
    ld [CrouchingHeadTiltTimer], a
    cp 4
    ret nc                          ; Return if "a" greater than 3.

    add a
    add a
    add a
    ld c, a                         ; c = 8 * a
    add hl, bc
    TilemapLow de, 14, 16
    ld b, 2
    ld c, 4

.Loop:                              ; This loops transfers the tile map for the hole, which the player is digging.
    ldh a, [rSTAT]
    and STATF_OAM
    jr nz, .Loop                    ; Wait for OAM to be accessible.
    ld a, [hl+]
    ld [de], a
    inc e
    dec c
    jr nz, .Loop                    ; 4 iterations inner loop
    ld a, e
    add 28
    ld e, a
    ld c, 4
    dec b                           ; 2 iterations outer loop
    jr nz, .Loop
    ret

; $5848: Loads next level after transition scene or plays end scene if Level 10 was finished before.
LoadNextLevel:
    ld a, [RunFinishTimer]
    or a
    ret nz
    ld a, [NextLevel2]
    cp 10
    jr nz, .NotFinalLevel

.FinalLevel:
    xor a
    ld [ScreenLockX], a             ; = 0
    ld a, 160
    ld [WndwBoundingBoxXLsb], a     ; = 160
    ld a, [PlayerPositionXLsb]
    cp 220
    jp c, DpadRightPressed          ; Let player walk right to the village girl.
.EndPosition:
    xor a
    ld [AnimationIndexNew], a       ; = 0
    ld b, $fe
    ld a, 12
    jr .End

; $586f
.NotFinalLevel:
    ld a, [BonusLevel]
    or a
    jp z, FinishLevel               ; Jump if no shovel was collected.
    ld b, 1
    ld a, 10

; $587a
.End:
    ld [CurrentLevel], a            ; = 10 or 12
    ld a, b
    ld [RunFinishTimer], a
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

    ld [ScrollOffsetY], a         ; = 0
    ld [Wiggle1], a               ; = 0
    ld [Wiggle2], a               ; = 0
    ld a, [NextLevel]
    cp 3
    jr z, :+                    ; Jump if next level is 3.
    ld a, [CheckpointReached]
    or a
    ret nz
 :  call IncrementBgScrollY2
    push af
    call DrawNewHorizontalTiles
    pop af
    jr nz, :-
    ret

; $58e5: Only does things for Level 3, Level 4, Level 5. All of these levels have something moving on the ground (water and dawn patrol).
HandleLvl345::
    ld a, [PlayerFreeze]
    or a
    ret nz

    ld a, [NextLevel]
    ld d, a                         ; d = [NextLevel]
    ld hl, $63b9
    cp 3
    ret c                           ; Return if level < 3.
    jr z, jr_001_5919               ; Jump if dawn patrol.
    cp 6
    ret nc                          ; Return if level >= 6.

    ld hl, $63c1
    ld a, [Wiggle1]
    cp 3
    jr c, jr_001_5919

    ld c, a
    ld a, [TimeCounter]
    and %111
    jr nz, jr_001_593a

    ld a, c
    dec a
    ld [Wiggle1], a
    cp 3
    jr nc, jr_001_593a

    ld a, $0a
    ld [$c131], a

jr_001_5919:
    ld a, [TimeCounter]
    and %11
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
    ld [Wiggle1], a

jr_001_593a:
    ld a, d
    cp 4
    jp z, Call_001_5a3a
    cp 5
    call z, Call_001_5a3a
.Level3:
    ld hl, DawnPatrolLsb
    ld e, [hl]                      ; e = DawnPatrolLsb
    inc hl                          ; hl = DawnPatrolMsb
    ld d, [hl]                      ; d = DawnPatrolMsb
    push hl
    push de
    call Call_001_59ba
    pop de
    pop hl
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5996

    ld a, [BalooFreeze]
    or a
    jr nz, jr_001_5996

    ld bc, $1500
    ld a, [NextLevel]
    cp 3
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
    ld hl, BalooElephantXLsb
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
    call CheckPlayerGround
    pop de
    ld a, [NextLevel]
    cp 3
    jr nz, jr_001_59d6

    ld a, [CurrentGroundType]
    cp $20
    jr z, jr_001_59ea

    and $1f
    cp $14
    ret c

    jr jr_001_59ea

jr_001_59d6:
    ld a, [CurrentGroundType]
    cp $21
    ret c

    cp $25
    ret nc

    ld a, [LandingAnimation]
    or a
    jr z, jr_001_59ea

    ld a, $06
    ld [Wiggle1], a

jr_001_59ea:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5a20

    ld [Wiggle2], a
    ld a, [NextLevel]
    cp 3
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
    ld a, [MovementState]
    push af
    ld a, $ff
    ld [MovementState], a           ; = $ff
    call MovePlayerRight
    pop af
    ld [MovementState], a           ; = [MovementState]

jr_001_5a20:
    ld a, [IsJumping]
    or a
    ret nz

    ld a, [Wiggle1]
    ld [Wiggle2], a
    ld a, [BalooFreeze]
    or a
    ret z

    ld a, $ff
    ld [$c176], a                   ; $ff
    ld c, $04
    jp ReceiveSingleDamage


Call_001_5a3a:
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
    ld [Wiggle1], a

jr_001_5a58:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5a62

    ld [Wiggle2], a

jr_001_5a62:
    ld a, [IsJumping]
    or a
    ret nz

    ld a, [Wiggle1]
    ld [Wiggle2], a
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
    cp 3
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
    cp 3
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
    ld bc, Ptr4x4BgTiles1
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
    cp 3
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
    cp 3
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
    ld bc, Ptr4x4BgTiles1
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

; $5bc4: Input: hl = pointer to projectile object.
UpdateProjectile::
    IsObjEmpty
    ret nz                          ; Return if Bit 7 is set. Thus, there is no active projectile object in [hl].
    call RotateBanana               ; Rotates projectile if it is a banana.
    call Call_001_5cb1
    call Call_001_5d5f
    call CheckBoomerangDelete
    call UpdateBallProjectile
    GetAttribute ATR_PROJECTILE_09
    dec a
    rst SetAttr                     ; obj[ATR_PROJECTILE_09] = obj[ATR_PROJECTILE_09] - 1
    ld b, a
    and %1111
    jr nz, jr_001_5c31              ; Jump if lower nibble of obj[ATR_PROJECTILE_09] was not 1. Jump only for boomerang.

    ld a, b
    swap a
    or b
    rst SetAttr                     ; Copy upper nibble of obj[ATR_PROJECTILE_09] into lower nibble.
    GetAttribute ATR_POSITION_DELTA
    and %1111                       ; Get the lower nibble which is the position delta.
    jr z, jr_001_5c31               ; Jump if it has 0 speed.
    bit 3, a
    jr z, :+
    or $f0
 :  ld c, a
    push bc
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    ld e, a                         ; e = [obj + x_position_lsb]
    inc c
    rst GetAttr
    ld d, a                         ; d = [obj + x_position_msb]
    pop bc
    bit 7, c
    jr nz, .IsNegative              ; Jump if delta is negative.
    ld a, e
    add c
    ld e, a                         ; e = [obj + x_position_lsb] + delta
    jr nc, .Continue                ; Jump if no carry.
    inc d                           ; Increase "d" if "e" overflows.
    jr .Continue

; $5c08
.IsNegative:
    ld a, e
    add c
    ld e, a                         ; e = [obj + x_position_lsb] + delta
    jr c, .Continue
    dec d                           ; Decrement "d" if "e" underflows.

; $5c0e
.Continue:
    ld c, ATR_X_POSITION_LSB
    ld a, e
    rst SetAttr                      ; [obj + x_position_lsb] = a
    inc c
    ld a, d
    rst SetAttr                      ; [obj + x_position_msb] = d
    bit 0, [hl]
    jr z, jr_001_5c20

    ld c, $15
    rst GetAttr
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

; $5c31:
jr_001_5c31:
    ld c, $0a
    rst GetAttr
    dec a
    rst SetAttr                     ; obj[$a]--
    ld b, a
    and $0f
    ret nz                          ; Return if lower nibble of obj[$a] was non-zero.

    ld a, b
    swap a
    or b
    rst SetAttr
.HandleVSpeed:
    GetAttribute ATR_BALL_VSPEED
    or a
    ret z                           ; Return if vertical speed is zero.
    ld c, a                         ; c = obj[ATR_BALL_VSPEED]
    push bc
    GetAttribute ATR_Y_POSITION_LSB
    ld e, a                         ; e = obj[ATR_Y_POSITION_LSB]
    inc c
    rst GetAttr
    ld d, a                         ; d = obj[ATR_Y_POSITION_MSB]
    pop bc
    bit 7, c                        ; Check if value is signed.
    jr nz, .VSpeedNegative
.VSpeedPositive:
    ld a, e
    add c                           ; a = obj[ATR_Y_POSITION_LSB] + obj[ATR_BALL_VSPEED]
    ld e, a
    jr nc, .ChangeYPos
    inc d
    jr .ChangeYPos
.VSpeedNegative:
    ld a, e
    add c
    ld e, a
    jr c, .ChangeYPos
    dec d
.ChangeYPos:
    ld c, ATR_Y_POSITION_LSB
    ld a, e
    rst SetAttr                     ; obj[ATR_Y_POSITION_LSB] = e
    inc c
    ld a, d
    rst SetAttr                     ; obj[ATR_Y_POSITION_MSB] = d
    bit 0, [hl]
    jr z, jr_001_5c71

    ld c, $15
    rst GetAttr
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

; $5c80: This function is called when any kind projectile (from player or enemy) is fired.
; However, only for banana-ish items (default banana, double banana, and boomerang) it does immediately return.
; It sets the correctly rotated sprites for the flying banana-like projectiles.
RotateBanana:
    ld c, ATR_BANANA_SHAPED
    rst GetAttr
    or a
    ret z                           ; Return if [obj + $b] is zero. It's 2 for banana-ish projectiles.
    ld d, a
    inc c                           ; c = $0c
    rst DecrAttr                    ; [obj + $c]--
    ret nz                          ; Return if [obj + $c] is non-zero. So, basically returns at every 2nd call.
    ld a, d
    rst SetAttr                     ; obj[ATR_ANIMATION_COUNTER] = objATR_BANANA_SHAPED] = 2
    inc c                           ; c = ATR_SPRITE_INDEX
    rst GetAttr                     ; Get current sprite index.
    inc a                           ; Increment sprite index.
    bit 2, [hl]
    jr nz, :+                       ; Continue if Bit 2 of the first attribute is not set.
    and %1
    rst SetAttr                     ; Only keep Bit 0 of sprite index.
    ret                             ; And return.
 :  and %11
    rst SetAttr                     ; obj[ATR_SPRITE_INDEX] = [0..3]
    ld de, BananaAnimationIndices
    add a
    add e
    ld e, a                         ; de = 2 * a + de
    jr nc, :+
    inc d
 :  ld a, [de]                      ; a = [BananaAnimationIndices + 2 * sprite_index]
    ld c, ATR_PROJECTILE_12
    rst SetAttr                     ; [obj + $12] = [BananaAnimationIndices + 2 * sprite_index]
    inc de
    ld a, [de]                      ; a = [BananaAnimationIndices + 2 * sprite_index + 1] : loads the flip setting.
    ld d, a
    ld c, ATR_POSITION_DELTA
    rst GetAttr                     ; a = [obj + delta]
    and %1111
    or d
    rst SetAttr                     ; [obj + delta] = ([obj + delta] & $f) |  [BananaAnimationIndices + 2 * sprite_index + 1]
    ret

; $5cb1: Bug: This also gets called for the stone shooter and may accidentally delete the projectile in case obj[$12] was not zero before.
Call_001_5cb1:
    bit 2, [hl]
    ret nz
    ld c, ATR_PROJECTILE_12
    rst GetAttr
    or a
    ret z                           ; Return if obj[$12] is zero.
    dec a
    rst SetAttr                     ; [obj + $12] = [obj + $12] - 1
    or a
    ret nz                          ; Return as long as obj[$12] is non-zero.
    DeleteObject                    ; Delete object if obj[$12] turned zero.
    ret

; $5cc0: Updates a ball projectile's behavior and checks for ground collisions.
; Input: hl = pointer to ball projecitle.
UpdateBallProjectile:
    ld a, [hl]
    and %11
    cp 2
    ret nz
    ld c, ATR_BALL_UP_COUNTER
    rst GetAttr
    or a
    jr z, .BallGoingDown
.BallGoingUp:
    dec a
    rst SetAttr                     ; obj[ATR_BALL_UP_COUNTER]--
    srl a
    srl a                           ; obj[ATR_BALL_UP_COUNTER] >> 2
    cpl
    inc a
    ld c, ATR_BALL_VSPEED
    rst SetAttr                     ; obj[ATR_BALL_VSPEED] = ...
    xor a
    ld c, ATR_BALL_DOWN_COUNTER
    rst SetAttr                     ; obj[ATR_BALL_DOWN_COUNTER] = 0
    ret
.BallGoingDown:
    ld c, ATR_BALL_DOWN_COUNTER
    rst GetAttr
    inc a
    cp 17
    jr nc, .MaximumVspeed           ; Jump if ball reached its maximum vertical speed.
    rst SetAttr
    srl a
    srl a                           ; obj[ATR_BALL_DOWN_COUNTER] >> 2
    ld c, ATR_BALL_VSPEED
    rst SetAttr
.MaximumVspeed:
    call CheckBallGroundCollision
    ret nc                          ; Return if ball did not the hit the ground.
    ld a, 20
    ld c, ATR_BALL_UP_COUNTER       ; obj[ATR_BALL_UP_COUNTER] = 20 (now ball is going up again)
    rst SetAttr
    ld a, EVENT_SOUND_BALL
    ld [EventSound], a              ; Play sound if ball collides with the ground.
    bit 3, [hl]
    ret nz                          ; Return if a direction was already determined.
    set 3, [hl]                     ; Setting Bit 3 says that a direction of the ball is determined.
    ld a, [BossActive]
    or a
    jr nz, .BallLeft                ; They only boss with ball projectiles is King Louie. He always throws his balls left.
    ld a, [BgScrollXLsb]
    ld e, a
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    sub e
    ld c, a
    ld a, [PlayerWindowOffsetX]
    cp c
    ld a, $01                       ; = 1 if ball is hopping right
    jr nc, .BallRight
.BallLeft:
    ld a, $0f                       ; = $0f if ball is hopping left
.BallRight:
    ld c, ATR_POSITION_DELTA
    rst SetAttr
    ret

; $5d1c: Deletes the boomerang once it comes back to the player.
CheckBoomerangDelete:
    ld a, [hl]
    and %110111
    cp %110111
    ret nz

.CheckObjYCoord:
    ld c, ATR_Y_POSITION_LSB
    rst GetAttr
    ld c, a
    ld a, [BgScrollYLsb]
    ld b, a
    ld a, c
    sub b                           ; obj[ATR_Y_POSITION_LSB] - [BgScrollYLsb]
    ld c, a                         ; c = object's window coordinates
    ld b, 4
    ld a, [IsCrouching2]
    or a
    jr nz, :+
    ld b, 12
 :  ld a, [PlayerWindowOffsetY]
    sub b
    sub c                          ; [PlayerWindowOffsetY] - (12 or 4) - (objects' window coordinates)
    bit 7, a
    jr z, :+                       ; Jump if coordinate is positive.
    cpl
    inc a
 :  cp b                            ; "b" is 12 or 4
    ret nc

.CheckObjXCoord:
    ld c, ATR_X_POSITION_LSB
    rst GetAttr
    ld c, a                         ; c = obj[ATR_X_POSITION_LSB]
    ld a, [BgScrollXLsb]
    ld b, a
    ld a, c
    sub b                           ; a = obj[ATR_X_POSITION_LSB] - [BgScrollXLsb]
    ld c, a
    ld a, [PlayerWindowOffsetX]
    sub c                           ; [PlayerWindowOffsetX] - (object's window coordinates)
    bit 7, a
    jr z, :+                        ; Jump if coordinate is positive.
    cpl
    inc a
 :  cp 8
    ret nc
    DeleteObject
    ret


Call_001_5d5f:
    bit 0, [hl]
    ret z

    bit 1, [hl]
    jr nz, jr_001_5d91

    ld c, $13
    rst GetAttr
    ld e, a
    inc c
    rst GetAttr
    ld d, a
    ld a, [FacingDirection]
    and $80
    jr nz, jr_001_5d81

    ld a, [WalkingState]
    or a
    jr z, jr_001_5d8c

    inc de
    inc a
    jr nz, jr_001_5d8c

    inc de
    jr jr_001_5d8c

jr_001_5d81:
    ld a, [WalkingState]
    or a
    jr z, jr_001_5d8c

    dec de
    inc a
    jr nz, jr_001_5d8c

    dec de

jr_001_5d8c:
    ld a, d
    rst SetAttr
    dec c
    ld a, e
    rst SetAttr

jr_001_5d91:
    ld c, $15
    rst GetAttr
    cp $04
    jr c, jr_001_5da8

    jp z, Call_001_5e95

    cp $08
    jp z, Call_001_5e95

    cp $0c
    jp z, Call_001_5e95

    call Call_001_5e95

jr_001_5da8:
    ld c, $0e
    rst GetAttr
    dec a
    rst SetAttr
    ld b, a
    and $0f
    ret nz

    ld a, b
    or $04
    rst SetAttr

Jump_001_5db5:
    ld c, $03
    rst GetAttr
    ld e, a
    inc c
    rst GetAttr
    ld d, a
    ld c, $13
    rst GetAttr
    sub e
    ld e, a
    push af
    inc c
    rst GetAttr
    ld b, a
    pop af
    ld a, b
    sbc d
    ld d, a
    bit 1, [hl]
    jr nz, jr_001_5de6

    ld c, $07
    rst GetAttr
    swap a
    xor d
    and $80
    ret z

    set 1, [hl]
    set 3, [hl]
    ld c, $15
    rst GetAttr
    cp $04
    jr nc, jr_001_5de6

    set 5, [hl]
    call Call_001_5f7a

jr_001_5de6:
    ld a, [PlayerPositionXLsb]
    add $08
    ld c, $13
    push af
    rst SetAttr
    pop af
    ld a, [PlayerPositionXMsb]
    adc $00
    inc c
    rst SetAttr
    bit 3, [hl]
    jr nz, jr_001_5e3f

    ld c, $07
    rst GetAttr
    swap a
    xor d
    and $80
    jr z, jr_001_5e09

    set 3, [hl]
    jr jr_001_5e3f

jr_001_5e09:
    ld c, $09
    rst GetAttr
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
    rst SetAttr
    jr jr_001_5e8d

jr_001_5e1f:
    ld c, $07
    rst GetAttr
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
    rst SetAttr
    jr jr_001_5e8d

jr_001_5e3f:
    ld c, $07
    rst GetAttr
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
    rst SetAttr
    jr jr_001_5e8d

jr_001_5e5d:
    ld c, $09
    rst GetAttr
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
    rst SetAttr
    jr jr_001_5e8d

jr_001_5e73:
    res 3, [hl]
    ld c, $07
    rst GetAttr
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
    rst SetAttr

jr_001_5e8d:
    ld c, $15
    rst GetAttr
    cp $04
    ret nc

    jr jr_001_5eaa

Call_001_5e95:
    ld c, ATR_ID
    rst GetAttr
    cp ID_PINEAPPLE
    jr z, jr_001_5eaa

    ld c, $0e
    rst GetAttr
    sub $10
    rst SetAttr
    ld b, a
    and $f0
    ret nz

    ld a, b
    or $40
    rst SetAttr

jr_001_5eaa:
    ld c, $01
    rst GetAttr
    ld e, a
    inc c
    rst GetAttr
    ld d, a
    ld c, ATR_STATUS_INDEX
    rst GetAttr
    sub e
    ld e, a
    push af
    inc c
    rst GetAttr
    ld b, a
    pop af
    ld a, b
    sbc d
    ld d, a
    bit 5, [hl]
    jr nz, jr_001_5edc

    ld c, $08
    rst GetAttr
    xor d
    and $80
    ret z

    set 5, [hl]
    set 6, [hl]
    ld c, $15
    rst GetAttr
    cp $04
    jr z, jr_001_5ed8

    cp $08
    jr nz, jr_001_5edc

jr_001_5ed8:
    set 1, [hl]
    set 3, [hl]

jr_001_5edc:
    ld b, $08
    ld a, [IsCrouching2]
    or a
    jr nz, jr_001_5eef

    ld c, $15
    rst GetAttr
    ld b, $10
    cp $0c
    jr z, jr_001_5eef

    ld b, $14

jr_001_5eef:
    ld a, [PlayerPositionYLsb]
    sub b
    ld c, ATR_STATUS_INDEX
    push af
    rst SetAttr
    pop af
    ld a, [PlayerPositionYMsb]
    sbc $00
    inc c
    rst SetAttr
    bit 6, [hl]
    jr nz, jr_001_5f4b

    ld c, $08
    rst GetAttr
    xor d
    and $80
    jr z, jr_001_5f0f

    set 6, [hl]
    jr jr_001_5f4b

jr_001_5f0f:
    ld c, ATR_FREEZE
    rst GetAttr
    ld b, a
    and $f0
    cp $10
    jr z, jr_001_5f25

    srl a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, ATR_FREEZE
    rst SetAttr
    jr jr_001_5f82

jr_001_5f25:
    ld c, ATR_ID
    rst GetAttr
    ld d, $03
    cp ID_PINEAPPLE
    jr z, jr_001_5f36

    ld c, $15
    rst GetAttr
    cp $0c
    ret z

    ld d, $02

jr_001_5f36:
    ld c, $08
    rst GetAttr
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
    rst SetAttr
    jr jr_001_5f82

jr_001_5f4b:
    ld c, ATR_ID
    rst GetAttr
    cp ID_PINEAPPLE
    jr z, jr_001_5f82

    ld c, $08
    rst GetAttr
    bit 7, a
    jr nz, jr_001_5f5e

    dec a
    jr z, jr_001_5f64

    jr jr_001_5f61

jr_001_5f5e:
    inc a
    jr z, jr_001_5f64

jr_001_5f61:
    rst SetAttr
    jr jr_001_5f82

jr_001_5f64:
    ld c, ATR_FREEZE
    rst GetAttr
    ld b, a
    and $f0
    cp $80
    jr z, Call_001_5f7a

    sla a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, ATR_FREEZE
    rst SetAttr
    jr jr_001_5f82

Call_001_5f7a:
    res 6, [hl]
    ld c, $08
    rst GetAttr
    cpl
    inc a
    rst SetAttr

jr_001_5f82:
    ld c, $15
    rst GetAttr
    cp $04
    jr z, jr_001_5f8c

    cp $08
    ret nz

jr_001_5f8c:
    jp Jump_001_5db5

; $5f8f Decrements BgScrollYWiggle and updates BgScrollYOffset.
UpdateBgScrollYOffset::
    ld a, [BgScrollYWiggle]
    or a
    ret z                         ; Nothing to do if BgScrollYWiggle is 0.
    dec a
    ld [BgScrollYWiggle], a       ; Decrement BgScrollYWiggle.
    jr z, .IsZero
    ld c, a
    ldh a, [rLY]
    add c
    and %111                      ; Determine new offset.
.IsZero:
    ld [BgScrollYOffset], a
    ret

; $5fa4: Sets the player position as a target for a projectile object.
; Input: de = projectile pointer with offset
SetPlayerPositionAsTarget::
    ld a, [PlayerPositionYLsb]
    sub c
    ld [de], a                    ; [de] = [PlayerPositionYLsb] - c
    inc e
    ld a, [PlayerPositionYMsb]
    sbc 0
    ld [de], a                    ; [de + 1] = [PlayerPositionYLsb] - carry
    inc e
    inc e
    ld a, [PlayerPositionXLsb]
    ld [de], a                    ; [de + 2] = [PlayerPositionXLsb]
    inc e
    ld a, [PlayerPositionXMsb]
    ld [de], a                    ; [de + 3] = [PlayerPositionXMsb]
    pop hl
    ret

; $5fbd
FinishLevel:
    ld a, [NextLevel2]
    or a
    ret z                           ; Return if [NextLevel2] is zero.
    ld a, [RunFinishTimer]
    or a
    ret nz                          ; Return if [RunFinishTimer] is not zero.
    ld [BonusLevel], a
    dec a
    ld [PlayerFreeze], a
    ld a, [NextLevel2]
    ld [CurrentLevel], a
    ld a, 32
    ld [RunFinishTimer], a          ; = 32. Happens in the fade out of the transition level.
    ld a, $4c
    ld [CurrentSong], a             ; = $4c
    ret

; Input: hl = pointer to object
ObjectDestructor:
    DeleteObject
    ld c, ATR_STATUS_INDEX
    rst GetAttr
    ld d, HIGH(ObjectsStatus)
    ld e, a                         ; de = ObjectsStatus + offset
    ld a, [de]
    or $80
    ld [de], a                      ; [ObjectsStatus + offset] |= $80 -> Object is deleted.
    GetAttribute ATR_06
    cp $90
    ret nc
    ld c, ATR_OBJECT_DATA
    rst GetAttr
    bit 3, a
    jr z, :+
    ld a, 6
 :  srl a                           ; a = (obj[ATR_OBJECT_DATA] or 6) >> 1
    ld b, a
    ld de, ActiveObjectsIds
    add e
    ld e, a                         ; de = ActiveObjectsIds + offset
    xor a
    ld [de], a                      ; = 0
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

    jr nz, Call_001_6080

jr_001_6079:
    ld bc, $200b
    ld a, [bc]

jr_001_607d:
    inc b
    jr nz, @+$0a

Call_001_6080:
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
    jr @+$1e

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

    db $28

; $6127: Used by JumpFromLiana to determine how high the player launches from a liana.
LianaJumpMomentum::
    db 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32, 13, 4, 17, 9

    dec bc
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
    rst CpAttr
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

; $6243: Position data. 2 byte per portal.
Level2PortalData::
    db $03, $05,
    db $9b, $03,
    db $2c, $04,
    db $f4, $02

; $624b: Position data. 2 byte per portal.
Level6PortalData::
    db $82, $00,
    db $94, $00,
    db $1c, $02,
    db $de, $00,
    db $81, $07,
    db $ae, $07,
    db $62, $04,
    db $30, $03,
    db $67, $05,
    db $e7, $00,
    db $98, $07,
    db $d8, $03,
    db $bb, $07,
    db $bb, $04

; $6267: Position data. 2 byte per portal.
DefaultPortalData::
    db $ad, $07,
    db $be, $05,
    db $ae, $07,
    db $bf, $05


; Teleport data of the individual portals. Each portal comprises the following 9 bytes:
; Byte 0-1: X end point of teleportation.
; Byte 2-3: Y end point of teleportation.
; Byte 4-5: Future X position of player.
; Byte 6-7: Future Y position of player.
; Byte 8: Loaded into TeleportDirection.

; $626f: 4 portals. 9 byte per portal.
Level2TeleportData::
    db $24, $01, $88, $04, $74, $01, $e0, $04, $10
    db $24, $01, $68, $06, $74, $01, $c0, $06, $f0
    db $44, $01, $a8, $03, $8c, $01, $00, $04, $10
    db $44, $01, $48, $05, $8c, $01, $a0, $05, $f0

; $6293: 14 portals. 9 byte per portal.
Level6TeleportData::
    db $44, $02, $10, $00, $8c, $02, $60, $00, $01
    db $04, $00, $10, $00, $4c, $00, $60, $00, $0f
    db $84, $03, $30, $00, $cc, $03, $80, $00, $11
    db $44, $03, $d0, $00, $8c, $03, $20, $01, $ff
    db $84, $05, $88, $03, $cc, $05, $e0, $03, $01
    db $00, $00, $88, $03, $2c, $00, $e0, $03, $0f
    db $c4, $05, $50, $01, $0c, $06, $a0, $01, $11
    db $04, $04, $e0, $01, $4c, $04, $30, $02, $ff
    db $a4, $04, $30, $00, $ec, $04, $80, $00, $10
    db $a4, $04, $70, $02, $ec, $04, $c0, $02, $f0
    db $c4, $02, $b0, $01, $0c, $03, $00, $02, $10
    db $c4, $02, $88, $03, $0c, $03, $e0, $03, $f0
    db $24, $07, $10, $02, $6c, $07, $60, $02, $10
    db $24, $07, $88, $03, $6c, $07, $e0, $03, $f0

; $6311: 4 portals. 9 byte per portal.
DefaultTeleportData::
    db $90, $07, $90, $02, $e0, $07, $e0, $02, $11
    db $70, $05, $88, $03, $c0, $05, $e0, $03, $ff
    db $90, $07, $90, $02, $e0, $07, $e0, $02, $11
    db $70, $05, $88, $03, $c0, $05, $e0, $03, $ff

; $6335: TODO
CrouchingInds2::
    db $3b, $3c

; $6337: Animation indices for the when the player is crouching.
CrouchingInds::
    db $3b, $3c, $3d

; $633a: Animation indices for the when the player looks up.
LookingUpInds::
    db $3e, $3f

; $633c
JumpSpriteIndPtrs::
    dw JumpSpriteIndsVert       ; Used when jumping vertically.
    dw JumpSpriteIndsHori       ; Used when jumping sideways.
    dw JumpSpriteIndsHori       ; Used when jumping from a slope.
    dw JumpSpriteIndsVert       ; Used when jumping from a liana.

; $6344
LiftoffLimits::
    db 21                           ; Used when jumping vertically.
    db 12                           ; Used when jumping sideways.
    db 18                           ; Used when jumping from a slope.
    db 20                           ; Used when jumping from a liana.

; $6348
JumpSpriteIndsVert::
    db $16, $16, $40, $40, $40, $40, $40, $40, $40, $40, $41, $41, $41, $41, $41, $41
    db $41, $41, $42, $42, $42, $42, $43, $43

; $6360
JumpSpriteIndsHori::
    db $16, $16, $16, $16, $16, $16, $16, $16, $16, $16, $17, $17, $18, $18, $18, $18
    db $19, $19, $19, $19, $1a, $1a, $1a, $1a

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
    sbc [hl]
    ld e, $05
    db $16

; $638a
BrakingAnimation1::
    db $00, $22, $21, $20

; $638e
BrakingAnimation2::
    db $00, $20, $20, $20

; $6392: Head sprite indices for the shoveling animation in the transition level.
ShovelingAnimHeadSpriteInds::
    db $51, $52, $53, $54, $55, $54, $53

; $6399
HoleTileMapData::
    db $6e, $6f, $70, $71, $61, $5a, $61, $5a, $72, $73, $74, $75, $61, $76, $77, $5a
    db $78, $01, $01, $79, $7a, $7b, $7c, $7d, $78, $01, $01, $79, $7e, $01, $01, $7f

    nop
    ld bc, $3312
    ld b, h
    ld b, e
    ld [hl-], a
    ld de, $0000
    ld bc, $2211
    ld [hl+], a
    db $21
    db $11

; $63c9
MosquitoYPositions::
    db $00, $00, $00, $00, $01, $11, $21, $11, $00, $00, $00, $00, $0f, $ff, $ef, $ff

; $63d9
EaglePositions::
    db $00, $01, $03, $05, $06, $05, $03, $01

; $63e1: Lookup table to map loot IDs to object IDs.
; This is also used for the random items in the bonus level.
LootIdToObjectId::
    db ID_DIAMOND
    db ID_PINEAPPLE
    db ID_GRAPES
    db ID_EXTRA_LIFE
    db ID_MASK_OR_LEAF
    db ID_EXTRA_TIME
    db ID_SHOVEL
    db ID_DOUBLE_BANANA
    db ID_BOOMERANG

; $63ea
TODOData63ea::
    dw Data63f2
    dw Data6408
    dw Data6420
    dw Data642c

; 63f2
Data63f2::
    db $a4, $06, $a5, $08, $a6, $0a, $a7, $0c, $a8, $1e, $a7, $04, $a7, $24, $a6, $0a
    db $a5, $08, $a4, $06, $ad, $78

; 6408
Data6408::
    db $0c, $14, $0b, $14, $0c, $14, $0b, $14, $0c, $0a, $0d, $04, $0e, $14, $0d, $08
    db $0c, $0a, $0d, $04, $0e, $14, $0d, $08

; $6420
Data6420::
    db $17, $0a, $18, $0a, $19, $32, $18, $0a, $17, $0a, $ad, $96

; $642c
Data642c::
    db $00, $b4, $01, $08, $02, $28, $01, $08

; $6434
FishFrogJumpData::
    db $38, $64,
    db $42, $64

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

KaaDataTODO3::
    db $ad, $18, $34, $08, $35, $08, $36, $08, $37, $30, $41, $10, $42, $08, $43, $10
    db $42, $08, $41, $08, $41, $08, $42, $08, $43, $10, $42, $08, $41, $10, $37, $18
    db $36, $08, $35, $08, $34, $08, $ad, $18, $40, $60, $3f, $10, $3e, $10, $3d, $10
    db $3c, $10, $ad, $18, $30, $08, $31, $08, $32, $08, $33, $18, $44, $10, $45, $08
    db $46, $10, $45, $08, $44, $08, $44, $08, $45, $08, $46, $10, $45, $08, $44, $10
    db $33, $18, $32, $08, $31, $08, $30, $08, $ad, $18, $3b, $60, $3a, $10, $39, $10
    db $38, $10, $ad, $10

BalooDataTODO3::
    db $b9, $0a, $ba, $00, $b7, $05, $b8, $00, $b5, $05, $b6, $00, $b3, $0a, $b4, $00
    db $b5, $05, $b6, $00, $b7, $05, $b8, $00, $bb, $0a, $bc, $00, $bd, $05, $be, $00
    db $bf, $14, $c0, $00, $c1, $05, $c2, $00, $bb, $05, $bc, $00, $bd, $0a, $be, $00

MonkeyBossDataTODO3::
    db $cd, $10, $c9, $c5, $ce, $04, $ca, $c6, $cf, $04, $cb, $c7, $d0, $04, $cc, $c8
    db $d1, $04, $d1, $d1, $d1, $10, $d1, $d1, $d0, $04, $cc, $c8, $cf, $04, $cb, $c7
    db $ce, $04, $ca, $c6, $cd, $08, $c9, $c5, $d1, $10, $d1, $d1, $d1, $04, $d1, $d2
    db $d1, $04, $d1, $d3, $d1, $04, $d1, $d4, $d1, $04, $d1, $d5, $d1, $10, $d1, $d1
    db $d1, $04, $d2, $d1, $d1, $04, $d3, $d1, $d1, $04, $d4, $d1, $d1, $04, $d5, $d1
    db $d1, $10, $d1, $d1, $d2, $04, $d1, $d1, $d3, $04, $d1, $d1, $d4, $04, $d1, $d1
    db $d5, $04, $d1, $d1, $cd, $08, $c9, $c5, $d6, $02, $c9, $c5, $d7, $02, $c9, $c5
    db $d8, $02, $c9, $c5, $d9, $02, $c9, $c5, $da, $02, $c9, $c5, $db, $02, $c9, $c5
    db $cd, $08, $c9, $c5, $c4, $14, $c9, $c3

KingLouieDataTODO3::
    db $09, $04, $0a, $00, $0b, $04, $0c, $00, $01, $04, $02, $00, $03, $04, $04, $00
    db $05, $04, $00, $00, $06, $04, $00, $00, $07, $04, $08, $00, $18, $08, $00, $00
    db $09, $04, $0a, $00, $0b, $04, $0c, $00, $0d, $04, $0e, $00, $0f, $04, $10, $00
    db $11, $04, $12, $00, $13, $04, $00, $00, $14, $0c, $15, $00, $09, $04, $0a, $00
    db $0b, $04, $0c, $00, $1a, $04, $1b, $00, $1c, $04, $1d, $00, $1e, $04, $1f, $00
    db $20, $04, $21, $00, $22, $0c, $23, $00, $20, $08, $21, $00, $22, $10, $23, $00

ShereKhanDataTODO3::
    db $e4, $06, $e5, $00, $e6, $06, $e7, $00, $e8, $06, $e9, $00, $ea, $06, $eb, $00
    db $ec, $06, $ed, $00, $ee, $06, $ef, $00, $e4, $0c, $e5, $00, $f2, $08, $00, $00
    db $e4, $06, $e5, $00, $e6, $06, $e7, $00, $e8, $06, $e9, $00, $ea, $06, $eb, $00
    db $ec, $06, $ed, $00, $ee, $06, $ef, $00, $e4, $20, $e5, $00, $e6, $06, $e7, $00
    db $e8, $06, $e9, $00, $ea, $06, $eb, $00, $ec, $06, $ed, $00, $ee, $06, $ef, $00
    db $f0, $0c, $f1, $00, $e4, $20, $e5, $00

; $661f
KaaPtrData::
    db $00, $02, $01, $03, $01, $00, $02, $03, $02, $00, $03, $01, $02, $03, $00, $01

; $662f
BalooActionData::
    db $00, $00, $00, $11, $00, $21, $00, $31, $41, $00, $51, $01, $00, $00, $61, $00
    db $71, $00, $00, $81, $00, $00, $11, $21, $31, $41, $00, $51, $01, $61, $00, $71
    db $01, $41, $91

; $6652
MonkeyBossData::
    db $05, $05, $05, $00, $02, $03, $04, $01, $85, $85, $85, $00, $03, $04, $02, $01
    db $05, $00, $04, $02, $03, $01, $85, $85, $85, $00, $02, $04, $03, $01, $05, $05
    db $00, $03, $02, $04, $01

; $6677
KingLouieData::
    db $00, $00, $01, $00, $00, $01, $00, $00, $01, $02, $00, $00, $01, $00, $00, $01
    db $02, $03, $01, $00, $00, $01, $02, $02, $01, $00, $00, $01, $02, $03, $00, $01

; $6697: Upper nibble sets BossAction, lower nibble times two is and index for ShereKhanDataTODO2.
ShereKhanActionData::
    db $80
    db $10                          ; Drop platform right.
    db $20                          ; Drop platform middle.
    db $03                          ; Shoot fire ball.
    db $02                          ; Shoot fire ball.
    db $03                          ; Shoot fire ball.
    db $30                          ; Spawn platform middle.
    db $40                          ; Spawn platform right.
    db $50                          ; Drop platform left.
    db $20                          ; Drop platform middle.
    db $61                          ; Spawn platform middle.
    db $02                          ; Shoot fire ball.
    db $03                          ; Shoot fire ball.
    db $d0                          ; Vertical fire balls right.
    db $e0                          ; Vertical fire balls middle.
    db $00                          ; Do nothing.
    db $f0                          ; Vertical fire balls right and middle.
    db $00                          ; Do nothing.
    db $e0                          ; Vertical fire balls middle.
    db $d1                          ; Vertical fire balls right.
    db $02                          ; Shoot fire ball.
    db $03                          ; Shoot fire ball.
    db $90                          ; Lightning left.
    db $a0                          ; Lightning middle.
    db $b0                          ; Lightning left-middle.
    db $c1                          ; Lightning right.
    db $10                          ; Drop platform right.
    db $70                          ; Spawn platform right.
    db $51                          ; Drop platform middle?
    db $01                          ; Do nothing.

; $66b5: Y position, X position, ATR_07, ATR_14
KaaData::
    db 224, 36, $20, $00
    db 192, 48, $20, $32
    db 172, 48, $20, $32
    db 128, 36, $60, $00

; $66c5
BalooDataTODO::
    db $00, $18

; $66c7
MonkeyBossDataTODO::
    db $00, $05, $14, $05, $28, $05, $3c, $05, $50, $05, $64, $08

; $66d3
KingLouieDataTODO::
    db $00, $07, $20, $07, $3c, $07, $58, $02

; $66db: Sets (ATR_PERIOD_TIMER1_RESET, ATR_14)
ShereKhanDataTODO2::
    db 0,  $07
    db 32, $07
    db 60, $06
    db 60, $07

; $66e3: X positions of the lightnings invoked by Shere Khan.
ShereKhanLightningPositions::
    db 72                           ; Lighnting left.
    db 120                          ; Lighnting middle.
    db 88                           ; Lighnting left-middle.
    db 144                          ; Lighnting right.

; $66e7: Data of the jumping flames spawned by Shere Khan.
; Y position, X position, facing direction, TODO
ShereKhanFlameData::
    db 248, 128, $01, $13
    db 252, 160, $0f, $11
    db 254, 80,  $01, $17
    db 248, 112, $0f, $15
    db 248, 80,  $01, $15
    db 248, 160, $0f, $13

; $66ff: Items dropped by King Louie. 0 = coconut.
KingLouieItems::
    db ID_GRAPES,       $78
    db $00,             $d0
    db $00,             $c0
    db ID_MASK_OR_LEAF, $98
    db $00,             $d8
    db $00,             $b8
    db $00,             $c8
    db ID_SHOVEL,       $88

; $670f: Platform data for Baloo's stones during the boss fight.
; 0 -> do nothing, 1 -> sink, -1 -> raise.
BalooPlatformData::
    db  0,  0,  0
    db  1,  0,  0                ; Sink left stone.
    db -1,  1,  0                ; Sink middle stone, raise left stone.
    db  0, -1,  1                ; Sink right stone, raise middle stone.
    db  0,  0, -1                ; Raise right stone.
    db  1,  0,  1                ; Sink left and right stone.
    db  0,  1,  0                ; Sink middle stone. At that time there should be a turtle or a crocodile.
    db  0, -1,  0                ; Raise middle stone.
    db -1,  0, -1                ; Raise left and right stone.
    db -1,  0,  0                ; I guess this one is unused.

; $672d: Used for animating the banana projectile.
; db sprite_index, flip_setting
BananaAnimationIndices::
    db $95, $00,
    db $96, $00,
    db $95, $20,
    db $96, $40

; $6735
StartOffsetDoubleBananaProjectile::
    db 4
    db 0
    db -4
    db 0
    db 4
    db 0
    db -4
    db 0
    db 4
    db 0
    db -4
    db 0

StartOffsetProjectiles::
    db $00, $00, $00, $00, $00, $fc, $00, $04, $03, $fd, $fd, $03, $03, $03, $fd, $fd
    db $00, $00, $00, $00, $04, $00, $fc, $00, $fd, $fd, $03, $03, $03, $fd, $fd, $03

; $6761
BoomerangOffsetData::
    db -16                          ; 0: Doing nothing.
    db -16                          ; 1: Walking right.
    db -16                          ; 2: Walking left.
    db 0                            ; 3: Unreachable.
    db -80                          ; 4: Looking up.
    db -64                          ; 5: Looking up right.
    db -64                          ; 6: Looking up left.
    db 0                            ; 7: Unreachable
    db -16                          ; 8: Looking down.
    db 48                           ; 9: Looking down right.
    db 48                           ; 10: Looking down left.

; $676c: Indices for the head sprite.
HeadSpriteIndices::
    db $3a, $3a, $3a, $00, $48, $47, $47, $00, $4a, $4a, $4a

; $$676c
HeadSpriteIndicesPipe:
    db $2b, $2b, $2b, $00, $2a, $1f, $1f, $00, $39, $39, $39

; $6782: Holds the number of objects per level.
NumObjectsBasePtr::
    db 42 ; Level 1: JUNGLE BY DAY
    db 43 ; Level 2: THE GREAT TREE
    db 42 ; Level 3: DAWN PATROL
    db 66 ; Level 4: BY THE RIVER
    db 61 ; Level 5: IN THE RIVER
    db 49 ; Level 6: TREE VILLAGE
    db 57 ; Level 7: ANCIENT RUINS
    db 72 ; Level 8: FALLING RUINS
    db 43 ; Level 9: JUNGLE BY NIGHT
    db 45 ; Level 10: THE WASTELANDS
    db 9  ; Level 11: Bonus
    db 0  ; Level 12: Transition and credit screen

; $678e: Data for static objects.
CompressedDataLvlPointers::
    dw CompressedDataLvl1
    dw CompressedDataLvl2
    dw CompressedDataLvl3
    dw CompressedDataLvl4
    dw CompressedDataLvl5
    dw CompressedDataLvl6
    dw CompressedDataLvl7
    dw CompressedDataLvl8
    dw CompressedDataLvl9
    dw CompressedDataLvl10
    dw CompressedDataLvl11
    dw $0000

; Compressed: $1d9. Decompressed: $3f0.
CompressedDataLvl1::
    INCBIN "bin/CompressedDataLvl1.bin"

; Compressed: $20e. Decompressed: $408.
CompressedDataLvl2::
    INCBIN "bin/CompressedDataLvl2.bin"

; Compressed: $2c4. Decompressed: $3f0.
CompressedDataLvl3::
    INCBIN "bin/CompressedDataLvl3.bin"

; Compressed: $2c4. Decompressed: $630.
CompressedDataLvl4::
    INCBIN "bin/CompressedDataLvl4.bin"

; Compressed: $2ba. Decompressed: $5b8.
CompressedDataLvl5::
    INCBIN "bin/CompressedDataLvl5.bin"

; Compressed: $26a. Decompressed: $498.
CompressedDataLvl6::
    INCBIN "bin/CompressedDataLvl6.bin"

; Compressed: $2b0. Decompressed: $558.
CompressedDataLvl7::
    INCBIN "bin/CompressedDataLvl7.bin"

; Compressed: $1ee. Decompressed: $6c0.
CompressedDataLvl8::
    INCBIN "bin/CompressedDataLvl8.bin"

; Compressed: $22a. Decompressed: $408.
CompressedDataLvl9::
    INCBIN "bin/CompressedDataLvl9.bin"

; Compressed: $24a. Decompressed: $438.
CompressedDataLvl10::
    INCBIN "bin/CompressedDataLvl10.bin"

; Compressed: $5d. Decompressed: $d8.
CompressedDataLvl11::
    INCBIN "bin/CompressedDataLvl11.bin"

; $7ea0: Ball projectile thrown by monkeys.
BallProjectileData::
    db $00, $00, $00, $00, $00, $92, $90, $00, $01, $11, $11, $00, $00, $00, $14, $07
    db $00, $00, $00, $00, $00, $00, $00, $00

; $7eb8: Drop-like projectile shot by Snakes and Elephants.
ShotProjectileData::
    db $23, $00, $00, $00, $00, $a1, $90, $0e, $01, $11, $88, $00, $00, $00, $44, $08
    db $00, $00, $00, $00, $00, $0c, $00, $00

; $7ed0: Fire projecile shot by Sheere Khan.
FireProjectileData::
    db $01, $00, $00, $00, $00, $92, $90, $0e, $01, $11, $88, $02, $01, $00, $44, $07
    db $00, $00, $80, $00, $00, $00, $00, $00

; $7ee8: Item dropped by King Louie. Note: ATR_ID will be changed!
DiamondObjectData::
    db $00                          ; 0:   Status
    db $00, $00                     ; 1-2: Y position
    db $00, $00                     ; 3-4: X position
    db ID_DIAMOND                   ; 5:   Type
    db $90                          ; 6:
    db $00                          ; 7:    ATR_SPRITE_PROPERTIES
    db $00                          ; 8:
    db $01                          ; 9:
    db $01                          ; a:
    db $00                          ; b:
    db $00                          ; c:
    db $00                          ; d:
    db $00                          ; e:
    db $02                          ; f:    Hitbox 2: See HitBoxData
    db $00                          ; 10:
    db $00                          ; 11:
    db $00                          ; 12:
    db $00                          ; 13:
    db $00                          ; 14:
    db $00                          ; 15:
    db $00                          ; 16:
    db $00                          ; 17: Drops no loot, has no health.

; $7f00
TurtleObjectData::
    db $22                          ; 0:   Status
    db $f0, $01                     ; 1-2: Y position
    db $10, $10                     ; 3-4: X position
    db ID_TURTLE                    ; 5:   Type
    db $90                          ; 6:
    db $2f                          ; 7:    ATR_SPRITE_PROPERTIES
    db $00                          ; 8:
    db $02                          ; 9:
    db $01                          ; a:
    db $00                          ; b:
    db $00                          ; c:
    db $00                          ; d:
    db $00                          ; e:
    db $0b                          ; f:    Hitbox b: See HitBoxData
    db $00                          ; 10:
    db $00                          ; 11:
    db $00                          ; 12:
    db $10                          ; 13:
    db $20                          ; 14:
    db $00                          ; 15:
    db $00                          ; 16:
    db $00                          ; 17: Drops no loot, has no health.

; $7f18
CrocodileObjectData::
    db $27                          ; 0:   Status
    db $00, $02                     ; 1-2: Y position
    db $a8, $0f                     ; 3-4: X position
    db ID_CROCODILE                 ; 5:   Type
    db $00                          ; 6:
    db $00                          ; 7:    ATR_SPRITE_PROPERTIES
    db $ff                          ; 8:
    db $04                          ; 9:
    db $01                          ; a:
    db $01                          ; b:
    db $01                          ; c:
    db $03                          ; d:
    db $04                          ; e:
    db $14                          ; f:    Hitbox $14: See HitBoxData
    db $00                          ; 10:
    db $00                          ; 11:
    db $00                          ; 12:
    db $10                          ; 13:
    db $20                          ; 14:
    db $00                          ; 15:
    db $00                          ; 16:
    db $00                          ; 17: Drops no loot, has no health.

; $7f30
ArmadilloObjectData::
    db $01                          ; 0:   Status
    db $80, $00                     ; 1-2: Y position
    db $e0, $03                     ; 3-4: X position
    db ID_ARMADILLO_ROLLING         ; 5:   Type
    db $00                          ; 6:
    db $2f                          ; 7:    ATR_SPRITE_PROPERTIES
    db $01                          ; 8:
    db $01                          ; 9:
    db $01                          ; a:
    db $04                          ; b:
    db $01                          ; c:
    db $00                          ; d:
    db $04                          ; e:
    db $06                          ; f:    Hitbox 6: See HitBoxData
    db $00                          ; 10:
    db $00                          ; 11:
    db $00                          ; 12:
    db $50                          ; 13:
    db $00                          ; 14:
    db $9f                          ; 15:
    db $9f                          ; 16:
    db $0a                          ; 17: Drops no loot, has 10 health.

; $7f48
LightningObjectData::
    db $01                          ; 0:   Status
    db $88, $03                     ; 1-2: Y position
    db $00, $07                     ; 3-4: X position
    db ID_LIGHTNING                 ; 5:   Type
    db $00                          ; 6:
    db $80                          ; 7:    ATR_SPRITE_PROPERTIES
    db $00                          ; 8:
    db $01                          ; 9:
    db $01                          ; a:
    db $40                          ; b:
    db $01                          ; c:
    db $00                          ; d:
    db $01                          ; e:
    db $1a                          ; f:    Hitbox 1a: See HitBoxData
    db $00                          ; 10:
    db $00                          ; 11:
    db $00                          ; 12:
    db $00                          ; 13:
    db $00                          ; 14:
    db $00                          ; 15:
    db $0c                          ; 16:
    db $00                          ; 17: Drops no loot, has no health.

; $7f60: Object data of the eagle that picks up the player.
EagleObjectData::
    db $03                          ; 0:   Status
    db $00, $00                     ; 1-2: Y position
    db $26, $00                     ; 3-4: X position
    db ID_EAGLE                     ; 5:   Type
    db $00                          ; 6:
    db SPRITE_X_FLIP_MASK           ; 7: ATR_SPRITE_PROPERTIES
    db $01                          ; 8:
    db $02                          ; 9:
    db $01                          ; a:
    db $08                          ; b:
    db $01                          ; c:
    db $00                          ; d:
    db $08                          ; e:
    db $00                          ; f: No hitbox
    db $00                          ; 10:
    db $00                          ; 11:
    db $00                          ; 12:
    db $00                          ; 13:
    db $50                          ; 14:
    db $00                          ; 15:
    db $00                          ; 16:
    db $00                          ; 17: Drops no loot, has no health.

; $7f78: Object data of the village girl that is seen in the end scene.
VillageGirlObjectData::
    db $00,                         ; 0: Status
    db $80, $00,                    ; 1-2: Y position
    db $14, $01,                    ; 3-4: X-position
    db ID_VILLAGE_GIRL,             ; 5:   Type
    db $00                          ; 6:
    db $00                          ; 7: ATR_SPRITE_PROPERTIES
    db $00                          ; 8:
    db $01                          ; 9:
    db $01                          ; a:
    db $40                          ; b:
    db $01                          ; c:
    db $00                          ; d:
    db $02                          ; e:
    db $00                          ; f: No hitbox
    db $01                          ; 10:
    db $02                          ; 11:
    db $00                          ; 12:
    db $00                          ; 13:
    db $00                          ; 14:
    db $00                          ; 15:
    db $00                          ; 16:
    db $00                          ; 17: Drops no loot, has no health.

; $7f90: Hit box coordinate tuples: (x1,y1),(x2,y2).
; Accessed with ATR_HITBOX_PTR.
HitBoxData::
    db  -4, -12,  4,  -4   ;  $1 = Projectiles
    db  -6, -12,  6,   0   ;  $2 = Pineapple, diamond, ...
    db  -8, -16,  8,   0   ;  $3 = Sitting monkey
    db  -8, -26,  8,   0   ;  $4 = Walking monkey, standing monkey
    db -10, -32, 10,   0   ;  $5 = Cobra
    db -12, -18, 12,   0   ;  $6 = Boar, porcupine, armadillo
    db  -3,  -8,  3,  -2   ;  $7 = ?
    db  -4, -10,  4,  -6   ;  $8 = ?
    db -12, -12, 12,   0   ;  $9 = Crawling snake, lizzard, scorpion
    db  -8, -16,  8,   0   ;  $a = Mosquito, bat, frog, fish
    db -16, -16, 16,   0   ;  $b = Turtle
    db -16, -12, 16,   0   ;  $c = ?
    db   0, -32,  8, -24   ;  $d = ?
    db  -8, -32,  0, -24   ;  $e = Kaa
    db -12, -24, -4, -16   ;  $f = ?
    db  -8, -24,  0, -16   ; $10 = ?
    db  -8,   8,  0,  16   ; $11 = ?
    db -12,   0, -4,   8   ; $12 = ?
    db  -8, -32,  8, -16   ; $13 = ?
    db -16, -16, 16,   0   ; $14 = Crocodile, flying bird, hippo
    db -16, -20, 16,   0   ; $15 = Falling platform
    db -12, -16, 12,  48   ; $16 = ?
    db -12, -24, 12,   0   ; $17 = Monkey boss
    db -12, 0,   12,  24   ; $18 = Baloo
    db -16, -32, 16,  -8   ; $19 = ?
    db -4,  -32, 4,   96   ; $1a = Lightning
    db -32, 4,   96,  -32  ; $1b = ?
    db $04, $60, $84, $01  ; $1c = ?

