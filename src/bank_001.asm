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
    ld [LeftLvlBoundingBoxXLsb], a
    xor a
    ld [LeftLvlBoundingBoxXMsb], a  ; = 0
    ld [WndwBoundingBoxXBossLsb], a ; = 0
    ld [WndwBoundingBoxXBossMsb], a ; = 0
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
    ld [CrouchingHeadTiltDelay], a
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
    ld [CrouchingAnim], a
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
    jr nz, SetShootAnimInds
    ld [InShootingAnimation], a     ; = 0
    ld a, [AnimationIndexNew2]
    jp SetAnimationIndexNew


; $42d4: Not jumped to if player is walking.
; Bug when pressing LEFT, RIGHT, and DOWN at the same time, you can shoot bananas through a pipe
SetShootAnimInds:
    ld a, [PlayerDirection]         ; = 0 doing nothing, 4 up, 8 down
    ld b, 0
    ld c, a
    ld hl, ShootAnimInds
    ld a, [WeaponActive]
    cp WEAPON_STONES
    jr nz, .SetAnimationIndex
    ld l, LOW(PipeAnimInds)          ; When shooting stones the player uses a pipe.

.SetAnimationIndex
    add hl, bc                       ; hl = [$676c + [PlayerDirection]] or [$6777 + [PlayerDirection]]
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
    ld de, StartOffsetProjectiles   ; Start offsets for non-double banana projectiles.
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
    ld a, [IsCrouching]
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
    ld a, [IsCrouching]
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
    ld hl, LookingUpAnimInds
    jr LoadAndSetAnimationIndex

; $456d: Called if the player is looking up. Decrements [LookingUpAnimation] if player is not pressing UP anymore.
HandleUpToIdleAnimation:
    ld a, [JoyPadData]
    and BIT_UP
    ret nz                          ; Return if up is pressed.
    ld a, [LookingUpDown]
    dec a
    ret z                           ; Return if player is looking down.
    ld a, [LookingUpAnimation]
    or a
    jr z, .AnimationDone
    dec a                           ; Decrement [LookingUpAnimation] and set the new animation index.
    jr nz, SetLookingUpAnimation

; $4581
.AnimationDone:
    jp SetPlayerAnimInd

; $4584
DpadDownContinued::
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    ld a, [IsCrouching]
    or a
    jr nz, PlayerAlreadyCrouching   ; Jump if player is crouching.
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    ret nz                          ; Return if left or right button is pressed.
    ld [CrouchingHeadTilted], a     ; = 0
    ld [CrouchingAnim], a             ; = 0
    ld [CrouchingHeadTiltTimer], a  ; = 0
    dec a
    ld [IsCrouching], a            ; = $ff
    ret

; $45a3:
PlayerAlreadyCrouching:
    ld a, [CrouchingAnim]
    ld c, a
    inc a
    cp 16
    jr c, HandleCrouchingAnim       ; Jump for the first calls when crouching.
    ld a, [CrouchingHeadTiltDelay]
    inc a
    ld [CrouchingHeadTiltDelay], a
    cp 12
    ld a, c
    jr c, HandleCrouchingAnim       ; Jump if [CrouchingHeadTiltDelay] is below 12.
    ld a, 12
    ld [CrouchingHeadTiltDelay], a
    ld a, [LookingUpDown]
    or a
    jr nz, .SetHeadTilt
    ld [CrouchingHeadTiltTimer], a
    inc a
    ld [LookingUpDown], a

; $45ca
.SetHeadTilt:
    ld a, [CrouchingHeadTiltTimer]
    inc a
    and %11111
    ld [CrouchingHeadTiltTimer], a    ; Reset CrouchingHeadTiltTimer every 32 iterations.
    ret nz                            ; Continue every 32 iterations.
    ld a, [CrouchingHeadTilted]
    inc a
    and %1
    ld [CrouchingHeadTilted], a       ; Toggle CrouchingHeadTilted
    inc a
    ld hl, CrouchingAnimInds

; $45e1
; Input: hl = base pointer to animation indices
;        c = offset
LoadAndSetAnimationIndex:
    ld b, 0
    ld c, a
    add hl, bc
    ld a, [hl]
    jp SetAnimationIndexNew

; $45e9
HandleCrouchingAnim:
    ld [CrouchingAnim], a
    call TrippleShiftRightCarry
    ld b, $00
    ld c, a
    ld hl, CrouchingAnimInds2
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a       ; = [CrouchingAnimInds2 + offset]
    cp $3c
    ret nz                          ; Return for the first index.

.CheckLiana:
    ld b, 48
    call IsLianaClose              ; Check if there is a liana 48 pixels below the player.
    ret nc                          ; Return if player is not going to get attached to a liana.
    ld a, c
    cp $1e                          ; Check if player is the correct tile type.
    jr z, .HandleLianaAttach
    ld a, [NextLevel]
    cp 10
    ret nz                          ; Return if not Level 10.
    ld a, c
    cp $c1                          ; Check if player is the correct tile type (Level 10 is different).
    ret nz

; $ 4612
.HandleLianaAttach:
    ld a, [PlayerPositionYLsb]
    add 32
    ld [PlayerPositionYLsb], a
    ld a, [PlayerPositionYMsb]
    adc 0
    ld [PlayerPositionYMsb], a      ; [PlayerPositionY] += 32
    ld de, $0014
    call AttachToStraightLiana
    ret

; $4629: Handles the player standing up after crouching.
HandleStandUp:
    ld a, [JoyPadData]
    and BIT_DOWN
    ret nz                          ; Return if down button is pressed.
    ld a, [CrouchingAnim]
    or a
    jr z, .PlayerStanding           ; Return player is not crouching.
    dec a
    jr nz, HandleCrouchingAnim      ; Decrement [CrouchingAnim].

; $4638
.PlayerStanding:
    ld [IsCrouching], a            ; = 0

; $463b
SetPlayerAnimInd:
    ld [LookingUpDown], a
    ld [CrouchingHeadTiltDelay], a
    ld c, a
    jp SetPlayerIdle

; $4645: Handles the playing standing up after crouching, handles braking, and handles the player going back to idle after looking up.
HandlePlayerStateTransitions::
    ld a, [PlayerOnLiana]
    and %1
    ret nz                          ; Return if player on liana.
    ld a, [TransitionLevelState]
    and %11011111
    cp %110
    ret z
    and %1
    ret nz
    ld a, [PlayerOnULiana]
    or a
    ret nz                          ; Return if player on U-liana.
    ld a, [InShootingAnimation]
    or a
    ret nz                          ; Return if player is in shooting animation.
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    ld a, [IsCrouching]
    or a
    jr nz, HandleStandUp            ; Check standing up if player is crouching.
    ld a, [LookingUpDown]
    or a
    jp nz, HandleUpToIdleAnimation
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, CheckBrake
    ld a, [PlayerFreeze]
    or a
    jr nz, CheckBrake
    ld a, [XAcceleration]
    and %1111
    jp nz, HandleBrake              ; Jump if player is breaking.
    xor a
    ld [HeadTiltCounter], a         ; = 0
    ret

; $468c:
CheckBrake:
    ld a, [IsJumping]
    or a
    jp nz, SetStateAndAccelToZero            ; Jump if player is jumping.
    ld a, [LandingAnimation]
    or a
    jp nz, SetStateAndAccelToZero            ; Jump if player is landing.
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
    ld [WalkRunAccel], a            ; = 0
    ld [XAcceleration], a           ; = 0
    ld [PlayerOnULiana], a          ; = 0
    ld [UpwardsMomemtum], a         ; = 0
    ld [JumpStyle], a               ; = 0
    dec a
    ld [CurrentLianaIndex], a       ; = $ff (player not hanging on any liana)
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
    ld a, 3
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
    jr nz, SetStateAndAccelToZero
    ld a, [LandingAnimation]
    or a
    jr z, SetPlayerIdle

; $4739
SetStateAndAccelToZero:
    xor a
    ld [WalkingState], a            ; = 0
    ld [XAcceleration], a           ; = 0
    ret

; $4741: Handles braking animation, braking sound, and non-controllable X-translation.
; Input: a = index for the brake animation
BrakeAnimation:
    ld b, $00
    ld c, a
    ld a, [IsJumping]
    or a
    jr nz, .Continue1               ; Jump if player is jumping.
    ld a, [LandingAnimation]
    or a
    jr nz, .Continue1               ; Jump if player is landing.
    ld a, [TimeCounter]
    rra
    jr nc, .NoCarry
    ld a, EVENT_SOUND_BRAKE
    ld [EventSound], a              ; = EVENT_SOUND_BRAKE

; $475b
.NoCarry:
    ld hl, BrakeAnimInds1
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr nz, .ButtonPressed
    ld hl, BrakeAnimInds2

; $4768
.ButtonPressed:
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a

; $476d
.Continue1:
    ld a, c
    cp 2
    jr nz, .Continue2
    ld a, $80
    ld [WalkingState], a            ; = $80
    jr .MovePlayer

; $4779
.Continue2:
    cp 1
    jr nz, .MovePlayer
    ld a, [TimeCounter]
    rra
    ret c                           ; Return every 2nd call.

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
    ld [WalkRunAccel], a            ; = 0
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
    ld [PlayerYWiggle], a           ; = 0
    dec a
    ld [LandingAnimation], a        ; = $ff
    ld a, STATE_FALLING
    ld [MovementState], a           ; = 2 (STATE_FALLING)
    dec a
    ld [AnimationCounter], a        ; = 1
    jp NoPlatformGround

; $47cc
SetIdleIfNotFalling:
    ld a, [LandingAnimation]
    or a
    ret z                           ; Return if player is landing.
    inc a
    ret z                           ; "a" was $ff. Hence, return when player is falling down.
    xor a
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld c, a                         ; = 0 (STANDING_ANIM_IND)
    jp SetPlayerIdle

; $47de: Sets the player's state to climbing if he is not already doing. Animation counters are reset if state change happens.
SetPlayerClimbing:
    ld a, [MovementState]
    cp STATE_CLIMBING
    ret z                           ; Return if player is already climbing.

; $47e4
SetPlayerClimbing2::
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
    ld [PlayerYWiggle], a
    ld [CrouchingAnim], a
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
    ld hl, JumpAnimIndPtrs
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
    cp 18
    ret nc
    ld a, [PlayerPositionYMsb]
    or a
    jr nz, .YSpaceLeft
    ld a, [PlayerPositionYLsb]
    cp 32
    ret c                           ; Return if player cannot go higher.

; $49e1
.YSpaceLeft:
    call IsLianaCloseM32           ; Check if there is a liana 32 pixel above the player.
    ld de, -32
    jr c, .LianaFound
    call IsLianaCloseM16           ; Check if there is a liana 16 pixel above the player.
    ret nc
    ld a, c
    cp $1e
    jr z, .LianaFound16
    ld a, [NextLevel]
    cp 10
    ret nz
    ld a, c
    cp $c1
    ret nz

; $49fc
.LianaFound16:
    ld de, -16

; $49ff
.LianaFound:
    call HandleFoundLiana
    ret

; $4a03
CheckCatapultJump:
    ld a, [IsJumping]
    and JUMP_CATAPULT
    ret z                           ; Return if not a catapult jump.

; $4a09
HandleCatapultJump:
    ld a, [UpwardsMomemtum]
    srl a
    srl a
    ld c, a                         ; c = [UpwardsMomemtum] >> 2
    ld a, 21
    sub c
    ld b, $00
    ld c, a                         ; c = 21 - ([UpwardsMomemtum] >> 2)
    ld hl, JumpVertAnimInds
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a       ; = [JumpVertAnimInds + offset]
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
    ld [PlayerKnockUp], a           ; [PlayerKnockUp] -= 1
    srl a
    srl a                           ; a = a >> 2
    jr z, .MovePlayerXDir

; $4a58
.MovePlayerYDir:
    call LetPlayerFlyUpwards
    ld a, [RunFinishTimer]
    or a
    jp nz, HandleDeathKnockUp

; $4a62
.MovePlayerXDir:
    ld a, [KnockUpDirection]
    and $80
    jp nz, MovePlayerLeft
    jp MovePlayerRight

; $4a6d
HandleFoundLiana:
    ld a, c
    cp $1e
    jr z, AttachToStraightLiana
    cp $c1
    jr z, AttachToStraightLiana
    ld c, $3f
    cp $c7
    jr c, AttachToULiana
    ld c, $c7

; $4a7e: Called when the player is attached to a U-liana.
AttachToULiana:
    sub c
    add a
    add a
    ld c, a
    ld d, a
    xor a
    call ResetLiana2
    ld b, a                         ; = 0
    dec a
    ld [CurrentLianaIndex], a       ; = $ff (currently not hanging on a straight liana)
    ld a, PLAYER_HANGING_ON_ULIANA
    ld [PlayerOnULiana], a          ; = 1 (PLAYER_HANGING_ON_ULIANA)
    ld hl, ULianaYPositions
    add hl, bc
    ld a, [PlayerPositionXLsb]
    ld e, a                         ; e = [PlayerPositionXLsb]
    ld c, 2
    and %1111
    cp 4
    jr c, .SetPosition
    inc b
    ld c, 6
    inc hl
    cp 8
    jr c, .SetPosition
    inc b
    ld c, 10
    inc hl
    cp 12
    jr c, .SetPosition
    inc b
    ld c, 14
    inc hl

; $4ab5
.SetPosition:
    ld a, e                         ; a = [PlayerPositionXLsb]
    and %11110000                   ; a = FLOOR([PlayerPositionXLsb], 16)
    add c
    ld [PlayerPositionXLsb], a
    ld a, [PlayerPositionYLsb]
    and %11110000
    add [hl]
    ld [PlayerPositionYLsb], a      ; [PlayerPositionYLsb] = [ULianaYPositions + offset]
    ld a, d
    add b
    ld [$c16a], a                   ; = d + b
    ld a, SWING_ANIM_IND + 3
    ld [AnimationIndexNew], a       ; = 38 (SWING_ANIM_IND + 3)
    ld a, 3
    ld [PlayerSwingAnimIndex], a    ; = 3
    inc a
    ld [$c15f], a                   ; = 4
    ld a, [FacingDirection]
    ld [ULianaSwingDirection], a    ; = [FacingDirection]
    pop bc
    ret

; $4ae0: Called when the player is attached to a straight liana.
; Input: de = ...
AttachToStraightLiana:
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPositionX]
    ld bc, -8
    add hl, bc                      ; hl = [PlayerPositionX] - 8
    ld a, l
    and %11110000                   ; FLOOR(l, 16)
    bit 4, a
    ret nz                          ; Return if Bit 4 of [PlayerPositionXLsb] was set.
    add 14
    ld l, a                         ; l = FLOOR([PlayerPositionXLsb] - 8, 16) + 14
    ld [PlayerPositionXLsb], a      ; = ...
    ld [LianaXPositionLsb], a       ; = ...
    ld a, h
    ld [PlayerPositionXMsb], a      ; [PlayerPositionX] = [PlayerPositionX] + 6
    ld [LianaXPositionMsb], a       ; = [PlayerPositionXMsb]
    push hl                         ; Push [PlayerPositionX].
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPositionY]
    ld [PlayerPositionYLianaLsb], a ; = [PlayerPositionYLsb]
    ld a, h
    ld [PlayerPositionYLianaMsb], a ; = [PlayerPositionYMsb]
    add hl, de                      ; hl = [PlayerPositionY] + de
    ld a, h
    and $0f
    swap a
    ld d, a                         ; d = h << 4
    ld a, l
    and $f0
    swap a
    or d
    ld d, a                         ; d = (h << 4) | (l >> 4); d = [PlayerPositionY] * 16
    pop hl                          ; Pop [PlayerPositionX].
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
    ld e, a                         ;  e = [PlayerPositionX] * 16
    ld hl, LianaPositionPtrLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = LianaPositionPtr
    ld a, [NumLianas]
    ld b, a                         ; b = [NumLianas]
    ld c, a                         ; c = [NumLianas]

; $4b39
.Loop:
    ld a, [hl+]
    cp e
    jr nz, .Next
    ld a, [hl]
    cp d
    jr z, .LianaFound
    jr nc, .Next
    add 5
    cp d
    jr nc, .LianaFound

; $4b48
.Next:
    inc hl
    dec b
    jr nz, .Loop
    ret

; $4b4d
.LianaFound:
    ld a, c
    sub b                           ; a = [NumLianas] - loop counter
    ld c, a
    ld a, [CurrentLianaIndex]
    cp c
    ret z                           ; Current liana index matches the already set ones.
    ld a, c
    call Call_000_2382
    ret nz
    ld a, c
    ld [CurrentLianaIndex], a       ; = index of newly found liana
    call ResetLiana1
    inc a
    ld [PlayerOnLiana], a           ; = 01
    pop bc
    ld a, [PlayerPositionYLsb]
    and %1111
    srl a
    srl a
    ld e, a                         ; ([PlayerPositionYLsb] & %1111) >> 2
    ld a, [hl]                      ; a = liana Y position / 16
    add a                           ; a = liana Y position / 8
    ld [CurrentLianaYPos8], a       ; = liana Y position / 8
    ld a, d
    sub [hl]                        ; [PlayerPositionY] * 16 - liana Y position / 16
    jr c, .PlayerClimbing           ; Jump if player came from above.
    add a
    add a                           ; [PlayerPositionY] * 64
    or e
    cp 16
    jr c, .PlayerSwinging
    ld a, 15

; $4b82
.PlayerSwinging:
    ld [PlayerOnLianaYPosition], a
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr nz, LetPlayerSwing

; $4b8c
.PlayerClimbing:
    ld a, STATE_CLIMBING
    ld [MovementState], a           ; = 3 (STATE_CLIMBING)
    ld a, CLMBING_ANIM_IND          ; = $4b (start of climbing animation)
    jp SetAnimationIndexNew

; $4b96
ResetLiana1:
    xor a
    ld [PlayerOnLiana], a           ; = 0
    ld [PlayerOnULiana], a          ; = 0
    ld [PlayerOnLianaYPosition], a  ; = 0

; $4ba0
ResetLiana2:
    ld [XAcceleration], a           ; = 0
    ld [WalkingState], a            ; = 0
    ld [IsJumping], a               ; = 0

; $4ba9
SetVerticalJump:
    ld [JumpStyle], a               ; = 0 (VERTICAL_JUMP)
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld [IsCrouching], a            ; = 0
    ld [LookingUpDown], a           ; = 0
    ret

; $4bb9
LetPlayerSwing:
    ld a, [CurrentLianaIndex]
    add a
    add a
    add a
    ld b, $00
    ld c, a                         ; c = [CurrentLianaIndex] * 8
    ld a, %11
    ld [PlayerOnLiana], a           ; = %11 (player is on liana and swinging)
    ld [PlayerSwingAnimIndex], a    ; = 3
    ld [PlayerSwingAnimIndex2], a   ; = 3
    inc a
    ld [MovementState], a           ; = 4 (STATE_SWINGING)
    ld a, [LianaToggleTodo]
    inc a
    and %1
    ld [LianaToggleTodo], a
    ld de, $c1d8
    add e
    ld e, a                         ; e = $c1d8 + (1 or 0)
    ld hl, LianaStatus
    add hl, bc
    ld a, l
    ld [de], a                      ; [$c1d8 + (1 or 0)] = LSB(LianaStatus + liana offset)
    set 7, [hl]                     ; Set Byte 0, Bit 7.
    inc l
    inc l
    inc l
    ld a, [FacingDirection]
    ld [hl], a                      ; Set liana facing direction.
    ld a, SWING_ANIM_IND + 3
    jp SetAnimationIndexNew

; $4bf3: This probably handles falling and landing.
HandlePlayerFall::
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
    and %01111111
    ret nz                          ; Return when player on a U-liana.
    ld a, [PlayerPositionYMsb]
    or a
    jr nz, .SkipYLsb
    ld a, [PlayerPositionYLsb]
    cp 32
    jr c, .GroundCheck               ; Jump if player reached top of the map.

; $4c21
.SkipYLsb:
    ld a, [LandingAnimation]
    inc a
    jr nz, .GroundCheck              ; Only continue if player is falling.

.PlayerFalling
    call IsLianaCloseM32
    ld de, -32
    jr c, .LianaFound               ; Jump if liana is close.
    call IsLianaCloseM16
    jr nc, .GroundCheck              ; Jump if no liana is close.
    ld a, c
    cp $1e
    jr z, .LianaFoundM16
    ld a, [NextLevel]
    cp 10
    jr nz, .GroundCheck

.Level10:
    ld a, c
    cp $c1
    jr nz, .GroundCheck

; $4c45
.LianaFoundM16:
    ld de, -16

; $4c48
.LianaFound:
    call HandleFoundLiana

; $4c4b
.GroundCheck:
    call CheckPlayerGroundNoOffset
    jp nc, Jump_001_4d5d
    cp $11
    jr z, .HandleGround
    ld c, a
    ld a, [DynamicGroundDataType]
    or a
    jr nz, .HandleGround
    ld a, b
    sub c
    cp $08
    jp nc, Jump_001_4dbb

; $4c63
.HandleGround:
    ld a, [LandingAnimation]
    or a
    jp z, SetPlayerOnSlope
    inc a
    jr nz, .CheckCatapult

.FirstContact:                      ; Reached if [LandingAnimation] was $ff.
    ld a, [FallingDown]
    cp 8
    jr c, .CheckCatapult

.PlaySound:                         ; Sound is only played if player fell from a certain height.
    ld a, EVENT_SOUND_LAND
    ld [EventSound], a              ; = EVENT_SOUND_LAND

; $4c79
.CheckCatapult:
    ld a, [CurrentGroundType]
    cp $0c                          ; Left part of the catapult.
    jr nz, .NotACatapult

.LandedOnCatapult:
    ld a, $02
    ld [CatapultTodo], a            ; = 2
    jp Jump_001_4d5d

.NotACatapult:
    ld a, [CatapultTodo]
    or a
    jp nz, Jump_001_4d5d

    ld a, [FallingDown]
    ld [LandingAnimation], a        ; Start the landing animation.
    or a
    jr z, SetPlayerOnSlope
    ld c, a                         ; c = [FallingDown]
    ld b, WALK_ANIM_IND + 4
    ld a, [WalkingState]
    or a
    jr z, HandleLandingAnimation     ; Jump if player is doing nothing or braking.
    inc a
    jr nz, .DecrementFallingDown    ; Jump if player previously walking.
    ld b, RUN_ANIM_IND + 5

;$4ca6
.DecrementFallingDown:
    ld a, c                         ; a = [FallingDown]
    dec a
    ld [FallingDown], a             ; -= 1
    cp 27
    jr c, .SetAnimIndFromB
    ld a, LAND_JUMP_ANIM_IND
    jr SetAnimIndFinishedLanding

; 4cb3
.SetAnimIndFromB:
    ld a, b

; $4cb4
SetAnimIndFinishedLanding:
    ld [AnimationIndexNew], a

; $4cb7
PlayerFinishedLanding:
    xor a
    ld [LandingAnimation], a        ; = 0
    ld [FallingDown], a             ; = 0
    ld [UpwardsMomemtum], a         ; = 0
    ld [JumpStyle], a               ; = 0
    ld [PlayerOnULiana], a          ; = 0
    inc a
    ld [MovementState], a           ; = 1 (STATE_WALKING)
    jr SetPlayerOnSlope

; 4ccd: If the player doesn't fall from great heights and if LEFT or RIGHT are pressed, the player performs a smooth landing.
; That means no landing animation is used.
SmoothLanding:
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, PlayerFinishedLanding
    ld a, WALK_ANIM_IND + 4
    jr SetAnimIndFinishedLanding

; $4cd8: Handles the player's landing animation. In some cases, a smooth landing is performed (see SmoothLanding).
HandleLandingAnimation:
    ld a, c
    dec a
    ld [FallingDown], a
    call TrippleShiftRightCarry
    jr z, SmoothLanding
    dec a
    jr z, SmoothLanding
    dec a
    ld b, $00
    ld c, a                         ; c = ([FallingDown] << 3) - 2
    ld hl, LandingInds
    add hl, bc
    ld c, [hl]
    call SetPlayerIdle

; $4cf1: Sets the slope type (PlayerOnSlope) the player is currently standing on.
SetPlayerOnSlope:
    ld c, $00
    ld a, [CurrentGroundType]
    cp $02
    jr c, .SetSlope                 ; Player not on a slope.
    ld c, 2
    cp $04
    jr c, .SetSlope                 ; Player on steep slope.
    cp $0b
    jr z, .SetSlope                 ; Player on steep slope.
    cp $0a
    jr z, .SetSlope                 ; Player on steep slope.
    dec c
    jr c, .SetSlope                 ; Player on slope.
    dec c

; $4d0c
.SetSlope:
    ld a, c
    ld [PlayerOnSlope], a

; $4d10
GroundLoop:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPositionY]
    push hl                         ; Push [PlayerPositionY]
    dec hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a      ; [PlayerPositionY] -= 1
    push hl
    call CheckPlayerGroundNoOffset
    jr c, StandingOnGround

; $4d26: Sets the player's Y position from the stack.
SetPlayerYPosition:
    pop de
    pop hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ret

; $4d31
StandingOnGround:
    ld c, a
    ld a, [DynamicGroundDataType]
    or a
    jr nz, .NotACatapult
    ld a, [CurrentGroundType]
    cp $0c
    jr c, .NotACatapult
    cp $10
    jr nc, .NotACatapult

.StandingOnCatapult:
    ld a, b
    sub c
    cp 4
    jr nc, SetPlayerYPosition

; $4d49
.NotACatapult:
    pop hl
    pop de
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    sub c
    ld [PlayerWindowOffsetY], a
    cp 72
    jr nc, GroundLoop
    call DecrementBgScrollY
    jr GroundLoop

; $4d5d: Called every frame when the player is falling or walking down a slope.
Jump_001_4d5d:
    ld a, [LandingAnimation]
    inc a
    jr z, IncrementFallingDown      ; Jump if player is landing.
    ld a, [DynamicGroundDataType]
    or a
    jr nz, jr_001_4d7a              ; Jump if player is standing on dynamic ground.
    ld b, 4
    call CheckPlayerGround
    jr c, jr_001_4d7a
    ld a, [CurrentGroundType]
    or a
    jr z, jr_001_4dc1               ; Jump if player is not standing on ground.
    ld a, b
    or a
    jr z, jr_001_4dc1

; $4d7a
jr_001_4d7a:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [PlayerPositionY]
    push hl
    inc hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a      ; [PlayerPositionY]  += 1
    push hl
    ld b, -1
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
    jp z, SetIdleIfNotFalling
    ld c, a
    jp HandleLandingAnimation

; $4da7
jr_001_4da7:
    pop hl
    pop de
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    sub c
    ld [PlayerWindowOffsetY], a
    cp 88
    jr c, jr_001_4d7a
    call IncrementBgScrollY
    jr jr_001_4d7a

Jump_001_4dbb:
    ld a, [LandingAnimation]
    or a
    jr nz, IncrementFallingDown     ; Jump if player landing or falling down.

jr_001_4dc1:
    call LetPlayerFall
    ld a, [RunFinishTimer]
    or a
    jr nz, IncrementFallingDown
    ld a, FALL_VERT_ANIM_IND + 1
    ld [AnimationIndexNew], a       ; = FALL_VERT_ANIM_IND + 1

; $4dcf
IncrementFallingDown:
    ld a, [FallingDown]
    inc a
    cp 32
    jr nc, IncYPos
    ld [FallingDown], a             ; [FallingDown]++

; $4dda
IncYPos:
    call TrippleShiftRightCarry
    ret z
    push af
    inc a
    ld b, a                         ; = ([FallingDown] << 3) + 1
    call CheckPlayerGround
    pop bc
    ld c, b
    jr nc, IncYPosLoop
    ld b, 1

; $4dea
IncYPosLoop:
    push bc
    call IncrementPlayerYPosition
    pop bc
    dec b
    jr nz, IncYPosLoop
    ld a, [NextLevel]
    cp 11
    jr z, jr_001_4e05
    ld a, [PlayerFreeze]
    or a
    jr nz, HandleDeathKnockUp
    ld a, [RunFinishTimer]
    or a
    jr nz, HandleDeathKnockUp

; $4e05: Only called in the bonus level.
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
    cp FALL_VERT_ANIM_IND + 1
    ret z

jr_001_4e1b:
    ld hl, VerticalFallAnimInds

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
    ld hl, SidewayFallAnimInds
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
    ld [PlayerPositionYLsb], a      ; = 90 or 218
    jp CheckCatapultLaunch

; $4e4e: Called when then player dies to handle the death knock up animation.
HandleDeathKnockUp:
    ld a, [AnimationCounter]
    or a
    jr z, .ContinueAnimation
    dec a
    ld [AnimationCounter], a        ; -= 1
    ret nz

; $4e59
.ContinueAnimation:
    ld a, 4
    ld [AnimationCounter], a        ; = 4
    ld a, [CrouchingHeadTilted]
    inc a
    cp 6
    jr c, .SetAnimationInd
    xor a

; $4e67
.SetAnimationInd:
    ld [CrouchingHeadTilted], a
    ld b, $00
    ld c, a
    ld hl, DeathKnockAnimInds
    add hl, bc
    ld a, [hl]
    and %00011111
    ld [AnimationIndexNew], a       ; = [DeathKnockAnimInds + offset] % 00011111
    ld a, OBJECT_FACING_RIGHT
    bit 7, [hl]
    jr z, .SetFacingDirection
    ld a, OBJECT_FACING_LEFT

; $4e7f
.SetFacingDirection:
    ld [FacingDirection], a
    ret

; $4e83: Determines the correct walking state based on slope, water/fire, and B press. Also handles acceleratio and state transition.
; Input: c = [JoyPadDataNonConst] & BIT_B
HandleWalkRunState::
    ld c, a
    ld a, [MovementState]
    or a
    ret z                           ; Return if player not moving.
    ld a, [PlayerOnULiana]
    or a
    ret nz                          ; Return if player on U-liana.
    ld a, [PlayerOnLiana]
    and %1
    ret nz                          ; Return if player on liana.
    ld a, [IsJumping]
    or a
    ret nz                          ; Return if player is jumping.
    ld a, [PlayerKnockUp]
    or a
    ret nz                          ; Return if player is being knocked up.
    ld a, [LandingAnimation]
    or a
    ret nz
    ld a, [LookingUpDown]
    or a
    ret nz
    ld a, [PlayerInWaterOrFire]
    or a
    jr nz, .SetStateWalking         ; Jump if player is slowed down by water or fire.
    ld a, [FacingDirection]
    ld b, a
    ld a, [CurrentGroundType]
    or a
    jr z, .NormalCase               ; Jump if no ground.
    cp $0c
    jr nc, .NormalCase              ; Jump if greater than $0c
    cp $07
    jr nc, .NegativeSlope           ; Jump if greater than $07. Hence, steep \-slope
    cp $02
    jr c, .NormalCase               ; Jump if ground type 1.

; Reach if player is walking on a /-slope.
.PositiveSlope:
    bit 7, b                        ; Check facing direction to determine if player goes up- or downhill
    jr nz, .GoingDowhill

; $4ec8
.SetStateWalking:
    ld a, STATE_WALKING
    ld [WalkingState], a            ; = $1
    xor a
    ld [XAcceleration], a           ; = $0
    ret

; $4ed2: The non-slope case.
.NormalCase:
    ld a, [WalkingState]
    inc a
    jr nz, .IsRunningOrWalking

    ld a, [WalkRunAccel]
    or a
    jr z, .SetStateWalking

; $4ede
.IsRunningOrWalking:
    bit 1, c                        ; Check if B-button is pressed.
    jr nz, .IncreaseWalkRunAccel

.StoppedBPress:
    ld a, [WalkRunAccel]
    or a
    ret z                           ; Return if [WalkRunAccel] is zero.
    dec a
    ld [WalkRunAccel], a            ; [WalkRunAccel] -= 1
    ret

; $4eec: Jumped to if player is walking on a \-slope.
.NegativeSlope:
    bit 7, b                        ; Check facing direction.
    jr nz, .SetStateWalking         ; We are going uphill. Player can only walk.

; $4ef0
.GoingDowhill:
    ld a, c
    and %110000
    ret z
    jr .End

; $4ef6
.IncreaseWalkRunAccel:
    ld a, c
    and %110000
    ret z
    ld a, [WalkRunAccel]
    inc a
    cp 10
    jr nc, .End
    ld [WalkRunAccel], a
    ret

; $4f06
.End:
    ld a, [WalkingState]
    inc a
    ret z                           ; Return if player is standing.
    ld a, $ff
    ld [WalkingState], a            ; = $ff (running)
    ld a, 9
    ld [WalkRunAccel], a            ; = 9
    ld a, $10
    ld [XAcceleration], a           ; = $10
    ld a, [FacingDirection]
    ld [FacingDirection3], a
    ret

; $4f21: Sets up NumLianas and LianaPositionPtr.
SetupLianaStatus:
    ld a, [NextLevel]
    dec a
    ld b, $00
    ld c, a
    ld hl, NumLianasPerLevel
    add hl, bc                      ; hl = NumLianasPerLevel + level - 1
    ld a, [hl]
    ld [NumLianas], a               ; Set up the correct number for the current level.
    sla c
    ld hl, LianaPositionPtrs
    add hl, bc
    ld a, [hl+]
    ld [LianaPositionPtrLsb], a
    ld a, [hl]
    ld [LianaPositionPtrMsb], a
    ld hl, LianaStatus
    ld b, 16 * 8
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
    ret z                           ; Return if player not on liana.
    ld hl, LianaStatus
    ld a, [NumLianas]
    or a
    ret z                           ; Return if [NumLianas] is zero.
    ld b, a                         ; Loop for [NumLianas] times.
    ld c, $00

Loop4fe4:
    push bc                         ; Push [NumLianas].
    push hl                         ; Push LianaStatus.
    ld a, c
    ld [WindowScrollYLsb], a        ; = 0
    ld a, [CurrentLianaIndex]
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
    ld hl, LianaPositionPtrLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    pop de
    push de
    call Call_001_4f46
    pop hl
    call HandleSwingingLiana
    pop hl
    pop bc
    ld a, l
    add $08
    ld l, a
    inc c
    dec b
    jr nz, Loop4fe4
    ret

; $5031: Handles swinging lianas.
; Input: hl = pointer object in LianaStatus
HandleSwingingLiana:
    bit 7, [hl]
    ret z                           ; Return if liana is not swinging.
    GetAttribute ATR_LIANA_TIMER    ; a = obj[ATR_LIANA_TIMER]
    or a
    jr z, .DoAction
    rst DecrAttr                    ; obj[ATR_LIANA_TIMER]--
    ret nz                          ; Return if obj[ATR_LIANA_TIMER] is non-zero.

; $503c: Liana timer reached zero. Maybe an action has to be performed.
.DoAction:
    bit 6, [hl]
    ret nz
    set 6, [hl]
    inc c
    rst GetAttr
    ld d, a                         ; d = obj[ATR_LIANA_2]
    inc c
    rst GetAttr
    ld e, a                         ; e = obj[ATR_LIANA_FACING_DIR]
    ld a, d                         ; a = obj[ATR_LIANA_2]
    and %1111
    add e
    ld b, a                         ; b = (obj[ATR_LIANA_2] + obj[ATR_LIANA_FACING_DIR]) >> 4
    ld a, d                         ; a = obj[ATR_LIANA_2]
    and %1111
    swap a                          ; a = obj[ATR_LIANA_2] << 4
    or b                            ; a = (obj[ATR_LIANA_2] << 4) | ((obj[ATR_LIANA_2] + obj[ATR_LIANA_FACING_DIR]) >> 4)
    ld d, b                         ; d = ((obj[ATR_LIANA_2] + obj[ATR_LIANA_FACING_DIR]) >> 4)
    dec c
    rst SetAttr                     ; obj[ATR_LIANA_TIMER] = a
    ld a, d
    ld c, ATR_LIANA_LEFT_LIM
    bit 7, e                        ; Check facing direction.
    jr nz, .CheckLimits
    inc c                           ; = 5 (ATR_LIANA_RIGHT_LIM)

; $505d
.CheckLimits:
    rst CpAttr                      ; Compare either ATR_LIANA_4 (facing left) or ATR_LIANA_5 (facing right)
    jr nz, .SwingWithPlayer

; $5060: Player reached the peak of a swing.
.SwingPeakReached:
    GetAttribute ATR_LIANA_FACING_DIR
    cpl
    inc a
    rst SetAttr                   ; Reverse facing direction.
    ld a, [hl]
    and %100
    jr z, .SwingWithPlayer

; Player does not swing with the liana. Let's give it a few more minor swings before it comes to rest.
.PlayerNotSwinging:
    inc c
    rst GetAttr                     ; a = obj[ATR_LIANA_LEFT_LIM]
    cp 3
    jr z, .ResetLimits
    inc a
    rst SetAttr                     ; obj[ATR_LIANA_LEFT_LIM] += 1
    inc c
    rst GetAttr                     ; a = obj[ATR_LIANA_RIGHT_LIM]
    cp 3
    jr z, .ResetLimits

; $5079
.ReduceLimits:
    dec a
    rst SetAttr                     ; obj[ATR_LIANA_RIGHT_LIM] -= 1
    ld c, ATR_LIANA_TIMER
    ld a, c
    rst SetAttr                     ; obj[ATR_LIANA_TIMER] = 1
    ret

; $5080: Liana swang its last swing. Reset the limits.
.ResetLimits:
    ld c, ATR_LIANA_LEFT_LIM
    xor a
    rst SetAttr                     ; obj[ATR_LIANA_LEFT_LIM] = 0
    inc c
    ld a, 6
    rst SetAttr                     ; obj[ATR_LIANA_LEFT_LIM] = 6
    ld c, ATR_LIANA_TIMER
    rst SetAttr                     ; obj[ATR_LIANA_TIMER] = 6
    ld a, [hl]
    ld b, a
    and %01110001                   ; Reset anything swing-related.
    ld [hl], a
    and %1
    jr nz, .SetPlayerOnLiana
    ld a, [PlayerOnLiana]
    and %1
    ret nz
    xor a

; $509b
.SetPlayerOnLiana:
    ld [PlayerOnLiana], a
    ret

; $509f
.SwingWithPlayer:
    push hl
    ld b, $00
    ld c, d
    ld hl, LianaTimerData
    add hl, bc
    ld a, [hl]
    pop hl
    ld c, ATR_LIANA_TIMER
    rst SetAttr                     ; obj[ATR_LIANA_TIMER] = ...
    ld a, [hl]
    and %11
    cp 3
    ret nz
    ld c, d
    ld a, c
    cp 3
    jr nz, CheckPlayerOnLianaFacingDir
    ld a, [JoyPadData]
    and BIT_LEFT | BIT_RIGHT
    jr z, CheckPlayerOnLianaFacingDir
    ld b, a
    ld a, [FacingDirection]
    bit 7, a
    jr z, .FacingLeft1
    bit 4, b
    jr z, CheckPlayerOnLianaFacingDir
    jr .PlayerTurn

; $50cd
.FacingLeft1:
    bit 5, b
    jr z, CheckPlayerOnLianaFacingDir

; $50d1
.PlayerTurn:
    cpl
    inc a
    ld [FacingDirection], a                   ; Reverse [FacingDirection].

; $50d6
CheckPlayerOnLianaFacingDir:
    ld a, [FacingDirection]
    and $80
    jr nz, .FacingLeft2
    ld a, c
    jr .SetAnimInd

; $50e0
.FacingLeft2:
    ld a, 6
    sub c

; $50e3
.SetAnimInd:
    add SWING_ANIM_IND
    ld [AnimationIndexNew], a
    ld a, c
    ld [PlayerSwingAnimIndex], a
    ret

; $50ed
TODO50ed::
    ld a, [PlayerOnULiana]
    cp 1
    jr z, jr_001_5136
    cp 2
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
    ld [$c15f], a                   ; = 1
    ld a, 3
    ld [PlayerSwingAnimIndex], a    ; = 3
    ld a, [FacingDirection]
    ld [ULianaSwingDirection], a    ; = [FacingDirection]

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
    ld a, [ULianaSwingDirection]
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
    ld [ULianaSwingDirection], a

jr_001_516c:
    ld b, $00
    ld hl, LianaTimerData
    ld a, d
    cp $02
    jr z, jr_001_5179

    ld hl, TODOData600c

jr_001_5179:
    add hl, bc
    ld a, [hl]
    ld [$c15f], a
    jp CheckPlayerOnLianaFacingDir

; $5181: Sets [PlayerPositionX] and [PlayerPositionY] when player is swinging on a liana.
SetPlayerOnLianaPositions:
    ld a, [PlayerSwingAnimIndex2]
    ld b, $00
    ld c, a
    push bc                         ; Push [PlayerSwingAnimIndex2].
    ld hl, PlayerOnLianaXPositions
    swap a
    and %11110000
    ld c, a                         ; = [PlayerSwingAnimIndex2] * 16
    add hl, bc                      ; Select row in PlayerOnLianaXPositions.
    ld a, [PlayerOnLianaYPosition]
    ld c, a                         ; c = [PlayerOnLianaYPosition] (is between 0 and 15)
    add hl, bc                      ; Select column in PlayerOnLianaXPositions.
    ld d, $00
    ld e, [hl]
    bit 7, e
    jr z, .IsPositive
    dec d
.IsPositive:
    ld hl, LianaXPositionLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; hl = [LianaXPosition]
    add hl, de                      ; Add offset from PlayerOnLianaXPositions.
    ld a, l
    ld [PlayerPositionXLsb], a      ; Set player's X position LSB.
    ld a, h
    ld [PlayerPositionXMsb], a      ; Set player's X position MSB.
    ld a, c                         ; a = [PlayerOnLianaYPosition] (is between 0 and 15)
    sub 13                          ; [PlayerOnLianaYPosition] - 13
    jr c, .YPosFromSwingAnim
    ld c, a                         ; = [PlayerOnLianaYPosition] - 13
    ld hl, PlayerOnLianaYPositions
    add a                           ; = ([PlayerOnLianaYPosition] - 13) * 2
    ld d, a
    add a                           ; = ([PlayerOnLianaYPosition] - 13) * 4
    add d                           ; = ([PlayerOnLianaYPosition] - 13) * 6
    add c                           ; = ([PlayerOnLianaYPosition] - 13) * 7
    ld c, a
    add hl, bc
    pop bc                          ; Pop [PlayerSwingAnimIndex2].
    add hl, bc
    ld c, [hl]
    bit 7, c
    jr z, .SetPlayerYPos
    dec b

; $51c5
.SetPlayerYPos:
    ld hl, PlayerPositionYLianaLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ret

; $51d5
.YPosFromSwingAnim:
    pop bc                          ; Pop [PlayerSwingAnimIndex2].
    ld c, b
    jr .SetPlayerYPos

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
    ld hl, TODOData6013
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
    ld hl, TODOData6013
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

    ld a, WALK_ANIM_IND + 3         ; Parts of the walking animation are used for the catapult launch animation.
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
    ld [AnimationIndexNew], a       ; = 0 (STANDING_ANIM_IND)
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
    ld [CrouchingAnim], a             ; = 0
    dec a
    ld [CrouchingHeadTiltTimer], a  ; = $ff
    ld a, LOOK_UP_SIDE_ANIM_IND
    ld [AnimationIndexNew], a       ; = 62 (LOOK_UP_SIDE_ANIM_IND)
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
    ld [AnimationIndexNew], a       ; = 0 (STANDING_ANIM_IND)
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
    ld hl, ShovelingAnimInds
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [AnimationIndexNew], a
    cp $53
    ret nz

    ld a, [CrouchingAnim]
    inc a
    and %1
    ld [CrouchingAnim], a
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
    ld [AnimationIndexNew], a       ; = 0 (STANDING_ANIM_IND)
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
    ld [ObjYWiggle], a            ; = 0
    ld [PlayerYWiggle], a         ; = 0
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
    ld hl, TODOData63b9
    cp 3
    ret c                           ; Return if level < 3.
    jr z, jr_001_5919               ; Jump if dawn patrol.
    cp 6
    ret nc                          ; Return if level >= 6.

    ld hl, TODOData63c1
    ld a, [ObjYWiggle]
    cp 3
    jr c, jr_001_5919

    ld c, a
    ld a, [TimeCounter]
    and %111
    jr nz, jr_001_593a

.DecrementObjYWiggle:
    ld a, c
    dec a
    ld [ObjYWiggle], a                 ; -= 1
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
    and %1111
    ld [ObjYWiggle], a

jr_001_593a:
    ld a, d
    cp 4
    jp z, FloatingObjYOffset
    cp 5
    call z, FloatingObjYOffset
.Level3:
    ld hl, DawnPatrolLsb
    ld e, [hl]                      ; e = DawnPatrolLsb
    inc hl                          ; hl = DawnPatrolMsb
    ld d, [hl]                      ; d = DawnPatrolMsb
    push hl
    push de
    call HandlePlayerOnBalooOrDawnPat
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


; $59ba: Checks if the player is on Baloo or the dawn patrol. If so, moves the player and handles sprite offset.
HandlePlayerOnBalooOrDawnPat:
    ld b, $01
    push de
    call CheckPlayerGround
    pop de
    ld a, [NextLevel]
    cp 3
    jr nz, .CheckFloatingBaloo

; $59c8
.CheckDawnPatrol:
    ld a, [CurrentGroundType]
    cp $20
    jr z, .Continue
    and %11111
    cp $14
    ret c
    jr .Continue

; $59d6
.CheckFloatingBaloo:
    ld a, [CurrentGroundType]
    cp $21
    ret c                           ; Return if below $21.
    cp $25
    ret nc                          ; Return if above $24.
    ld a, [LandingAnimation]
    or a
    jr z, .Continue                 ; Jump if player is currently not landing.

; $59e5
.LandedOnBaloo:
    ld a, 6
    ld [ObjYWiggle], a              ; = 6 (dip Baloo 6 pixels into the water when player lands on him)

; $59ea
.Continue:
    ld a, [TimeCounter]
    and %11
    jr nz, .End                     ; Only continue every 4th call.
    ld [PlayerYWiggle], a           ; = 0
    ld a, [NextLevel]
    cp 3
    jr nz, .HandleBaloo

; $59fb
.HandleDawnPatrol:
    ld a, d
    cp $03
    jr nz, .MovePlayer
    ld a, e
    cp $68
    jr z, .End
    jr .MovePlayer

; $5a07
.HandleBaloo:
    ld a, d
    or a
    jr nz, .MovePlayer
    ld a, e
    cp $a0
    jr z, .End

; $5a10
.MovePlayer:
    ld a, [MovementState]
    push af
    ld a, $ff
    ld [MovementState], a           ; = $ff
    call MovePlayerRight            ; Player is standing on Baloo or the dawn patrol. Move him right to follow their movement.
    pop af
    ld [MovementState], a           ; = [MovementState]

; $5a20
.End:
    ld a, [IsJumping]
    or a
    ret nz
    ld a, [ObjYWiggle]
    ld [PlayerYWiggle], a           ; Player inherits wiggle from Baloo/dawn patrol.
    ld a, [BalooFreeze]
    or a
    ret z
    ld a, -1
    ld [KnockUpDirection], a        ; = -1 (left)
    ld c, 4                         ; Wtf: Is this? "c" is immediately overwritten.
    jp ReceiveSingleDamage

; $5a3a: Handles the Y offset of floating objects and the player.
; Turtles and crocodiles both dip into the water when being jumped on.
FloatingObjYOffset:
    ld a, [DynamicGroundDataType]
    cp $29
    ret c                           ; Return for everything below turtle.
    cp $2c
    jr c, .CheckDip                 ; Jump if turtle and crocodile.
    cp $2e
    jr z, .Continue                 ; Jump if hippo.
    cp $2f
    jr z, .Continue
    ret

; $5a4d
.CheckDip:
    ld a, [LandingAnimation]
    or a
    jr z, .Continue

; $5a53
.Dip:
    ld a, 6                         ; When landing on a turtle, it dips 6 pixels deep into the water.
    ld [ObjYWiggle], a              ; = 6

; $5a58
.Continue:
    ld a, [TimeCounter]
    and %11
    jr nz, .SetYOffset
    ld [PlayerYWiggle], a

; $5a62
.SetYOffset:
    ld a, [IsJumping]
    or a
    ret nz                          ; Return if player is jumping.
    ld a, [ObjYWiggle]
    ld [PlayerYWiggle], a           ; Player stands on object, so inherit ObjYWiggle.
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
    ld a, [IsCrouching]
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
    GetAttribute ATR_X_POSITION_LSB
    ld e, a                         ; e = obj[ATR_X_POSITION_LSB]
    inc c
    rst GetAttr
    ld d, a                         ; d = obj[ATR_X_POSITION_MSB]
    GetAttribute ATR_TARGET_X_LSB
    sub e
    ld e, a                         ; e = obj[ATR_TARGET_X_LSB] - obj[ATR_X_POSITION_LSB]
    push af
    inc c
    rst GetAttr
    ld b, a                         ; b = obj[ATR_TARGET_X_MSB]
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
    ld c, ATR_TARGET_DIRECTION
    rst GetAttr
    cp $04
    jr nc, jr_001_5de6

    set 5, [hl]
    call Call_001_5f7a

jr_001_5de6:
    ld a, [PlayerPositionXLsb]
    add 8
    ld c, ATR_TARGET_X_LSB
    push af
    rst SetAttr                     ; obj[ATR_TARGET_X_LSB] = [PlayerPositionXLsb] + 8
    pop af
    ld a, [PlayerPositionXMsb]
    adc 0
    inc c
    rst SetAttr                     ; obj[ATR_TARGET_X_MSB] = [PlayerPositionXMsb] + carry
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
    GetAttribute ATR_ID
    cp ID_PINEAPPLE
    jr z, jr_001_5eaa

    ld c, ATR_PERIOD_TIMER1_RESET
    rst GetAttr
    sub 16
    rst SetAttr
    ld b, a
    and $f0
    ret nz

    ld a, b
    or $40
    rst SetAttr

jr_001_5eaa:
    GetAttribute ATR_Y_POSITION_LSB
    ld e, a                         ; e = obj[ATR_Y_POSITION_LSB]
    inc c
    rst GetAttr
    ld d, a                         ; d = obj[ATR_Y_POSITION_MSB]
    GetAttribute ATR_STATUS_INDEX
    sub e
    ld e, a
    push af
    inc c
    rst GetAttr
    ld b, a                         ; b = obj[ATR_X_POSITION_LSB]
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
    ld a, [IsCrouching]
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

; $6005
LianaTimerData::
    db 20, 12, 8, 4, 8, 12, 20

; $600c
TODOData600c::
    db $14, $0c, $14, $0c, $14, $0c, $14

; $6013
TODOData6013::
    db $21, $60, $36, $60, $49, $60, $5a, $60, $6b, $60, $7c, $60, $91, $60, $0a, $05
    db $20, $08, $20, $04, $1f, $0a, $20, $09, $ff, $0a, $20, $09, $ff, $0a, $20, $05
    db $ff, $09, $ff, $09, $04, $20, $08, $20, $0a, $20, $09, $ff, $05, $20, $0a, $20
    db $09, $ff, $05, $20, $0d, $1f, $08, $04, $20, $04, $20, $08, $20, $08, $20, $04
    db $1f, $05, $20, $0a, $20, $09, $ff, $07, $04, $20, $04, $20, $04, $20, $04, $20
    db $04, $20, $04, $20, $04, $20, $04, $20, $08, $04, $20, $04, $20, $08, $21, $08
    db $20, $04, $20, $06, $20, $07, $01, $0b, $20, $0a, $04, $20, $08, $21, $0b, $20
    db $06, $20, $07, $01, $0b, $20, $06, $20, $07, $01, $06, $20, $0a, $01, $08, $06
    db $20, $07, $01, $08, $20, $04, $20, $0b, $21, $0b, $21, $0d, $21, $0c, $01

; $60a2: Y position offsets for the player when swinging on a liana. These offsets are only used if player reaches the lower end of the liana.
PlayerOnLianaYPositions::
    db -4,  0,  0,  0,  0,  0, -4
    db -4,  0,  0,  0,  0,  0, -4
    db -8, -4,  0,  0,  0, -4, -8

; $60b7: X position offsets for the player when swinging on a liana. The positions are added to [PlayerPositionX].
; A row is selected by [PlayerSwingAnimIndex2]. A column by [PlayerOnLianaYPosition].
PlayerOnLianaXPositions::
    db   0,   0,   0,  -4,  -4,  -4,  -8,  -8, -12, -16, -20, -24, -28, -32, -36, -40
    db   0,   0,   0,   0,  -4,  -4,  -4,  -8,  -8, -12, -12, -16, -16, -20, -24, -28
    db   0,   0,   0,   0,   0,   0,  -4,  -4,  -4,  -4,  -8,  -8,  -8, -12, -12, -16
    db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    db   0,   0,   0,   0,   0,   0,   4,   4,   4,   4,   8,   8,   8,  12,  12,  16
    db   0,   0,   0,   0,   4,   4,   4,   8,   8,  12,  12,  16,  16,  20,  24,  28
    db   0,   0,   0,   4,   4,   4,   8,   8,  12,  16,  20,  24,  28,  32,  36,  40

; $6127: Used by JumpFromLiana to determine how high the player launches from a liana.
LianaJumpMomentum::
    db 10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30, 32

; $6133: Number of straight lianas per level.
NumLianasPerLevel::
    db 13                           ; Level 1: JUNGLE BY DAY
    db 4                            ; Level 2: THE GREAT TREE
    db 17                           ; Level 3: DAWN PATROL
    db 9                            ; Level 4: BY THE RIVER
    db 11                           ; Level 5: IN THE RIVER
    db 6                            ; Level 6: TREE VILLAGE
    db 9                            ; Level 7: ANCIENT RUINS
    db 0                            ; Level 8: FALLING RUINS
    db 9                            ; Level 9: JUNGLE BY NIGHT
    db 8                            ; Level 10: THE WASTELANDS
    db 0                            ; Level 11: Bonus
    db 0                            ; Level 12: Transition and credit screen

; $613f: Array of pointers to the straight liana positions for each level.
LianaPositionPtrs::
    dw Level1LianaPositions         ; Level 1: JUNGLE BY DAY
    dw Level2LianaPositions         ; Level 2: THE GREAT TREE
    dw Level3LianaPositions         ; Level 3: DAWN PATROL
    dw Level4LianaPositions         ; Level 4: BY THE RIVER
    dw Level5LianaPositions         ; Level 5: IN THE RIVER
    dw Level6LianaPositions         ; Level 6: TREE VILLAGE
    dw Level7LianaPositions         ; Level 7: ANCIENT RUINS
    dw $0000                        ; Level 8: FALLING RUINS
    dw Level9LianaPositions         ; Level 9: JUNGLE BY NIGHT
    dw Level10LianaPositions        ; Level 10: THE WASTELANDS

; $6153: Positions of the 13 lianas in Level 1. Positions stored as (X position / 16, Y position / 16).
Level1LianaPositions::
    db $03, $06
    db $08, $14
    db $1b, $16
    db $1f, $10
    db $27, $08
    db $2b, $0c
    db $31, $0a
    db $35, $0c
    db $46, $0c
    db $49, $06
    db $4c, $00
    db $50, $00
    db $54, $00

; $616d: Positions of the 4 lianas in Level 1. Positions stored as (X position / 16, Y position / 16).
Level2LianaPositions::
    db $03, $74
    db $06, $2e
    db $15, $2e
    db $16, $3c

; $6175: Positions of the 17 lianas in Level 3. Positions stored as (X position / 16, Y position / 16).
Level3LianaPositions::
    db $10, $00
    db $1a, $00
    db $26, $06
    db $2e, $06
    db $35, $06
    db $38, $00
    db $3d, $06
    db $43, $00
    db $50, $06
    db $54, $06
    db $5f, $06
    db $63, $00
    db $68, $00
    db $6c, $00
    db $70, $00
    db $88, $00
    db $94, $06

; $6197: Positions of the 9 lianas in Level 4. Positions stored as (X position / 16, Y position / 16).
Level4LianaPositions::
    db $03, $10
    db $07, $0c
    db $0a, $00
    db $15, $08
    db $20, $10
    db $42, $06
    db $4e, $0e
    db $57, $10
    db $76, $0a

; $61a9: Positions of the 11 lianas in Level 5. Positions stored as (X position / 16, Y position / 16).
Level5LianaPositions::
    db $02, $12
    db $04, $1e
    db $08, $18
    db $0c, $08
    db $15, $22
    db $1a, $08
    db $1b, $14
    db $22, $1e
    db $25, $0a
    db $2c, $20
    db $2f, $12

; $61bf: Positions of the 6 lianas in Level 6. Positions stored as (X position / 16, Y position / 16).
Level6LianaPositions::
    db $02, $1c
    db $02, $28
    db $0f, $0e
    db $0e, $28
    db $22, $26
    db $37, $34

; $61cb: Positions of the 9 lianas in Level 7. Positions stored as (X position / 16, Y position / 16).
Level7LianaPositions::
    db $02, $0a
    db $08, $22
    db $16, $28
    db $18, $34
    db $1d, $00
    db $32, $26
    db $3c, $0c
    db $3d, $18
    db $3d, $24

; $61dd: Positions of the 9 lianas in Level 9. Positions stored as (X position / 16, Y position / 16).
Level9LianaPositions::
    db $02, $34
    db $0b, $00
    db $0f, $00
    db $13, $00
    db $1f, $1c
    db $25, $34
    db $2e, $18
    db $3a, $0e
    db $3c, $32

; $61ef: Positions of the 8 lianas in Level 10. Positions stored as (X position / 16, Y position / 16).
Level10LianaPositions::
    db $02, $1e
    db $0b, $12
    db $0e, $2a
    db $1f, $32
    db $20, $1e
    db $28, $08
    db $2c, $2e
    db $30, $14

; $61ff
ULianaYPositions::
    db $08, $0c, $10, $10, $04, $04, $08, $08, $08, $08, $04, $04, $10, $10, $0c, $08

; $620f
TODOData620f::
    db $04, $0b, $0c, $04, $0b, $0c, $00, $08, $08, $00, $08, $08, $00, $04, $04, $00
    db $00, $00, $00, $00, $fc, $00, $00, $f8, $00, $00, $f8, $00, $00, $f4, $00, $00
    db $f4, $00, $00, $f4, $00, $00, $fc, $00, $00, $00, $00, $04, $04, $04, $0b, $0c

; $623f
TODOData623f::
    db $fc, $f8, $f8, $f4

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
CrouchingAnimInds2::
    db CROUCH_ANIM_IND
    db CROUCH_ANIM_IND + 1

; $6337: Animation indices when the player is crouching.
CrouchingAnimInds::
    db CROUCH_ANIM_IND
    db CROUCH_ANIM_IND + 1
    db CROUCH_ANIM_IND + 2

; $633a: Animation indices when the player looks up.
LookingUpAnimInds::
    db LOOK_UP_SIDE_ANIM_IND
    db LOOK_UP_VERT_ANIM_IND

; $633c
JumpAnimIndPtrs::
    dw JumpVertAnimInds             ; Used when jumping vertically.
    dw JumpSideAnimInds             ; Used when jumping sideways.
    dw JumpSideAnimInds             ; Used when jumping from a slope.
    dw JumpVertAnimInds             ; Used when jumping from a liana.

; $6344
LiftoffLimits::
    db 21                           ; Used when jumping vertically.
    db 12                           ; Used when jumping sideways.
    db 18                           ; Used when jumping from a slope.
    db 20                           ; Used when jumping from a liana.

; $6348: Animation indices when the player does a vertical jump. Includes jumping from a liana.
JumpVertAnimInds::
    ds 2, LAND_JUMP_ANIM_IND
    ds 8, JUMP_VERT_ANIM_IND
    ds 8, JUMP_VERT_ANIM_IND + 1
    ds 4, JUMP_VERT_ANIM_IND + 2
    ds 2, JUMP_VERT_ANIM_IND + 3

; $6360: Animation indices when the player does a sideway jump. Includes jumping from a slop.
JumpSideAnimInds::
    ds 10, LAND_JUMP_ANIM_IND
    ds 2, JUMP_SIDE_ANIM_IND
    ds 4, JUMP_SIDE_ANIM_IND + 1
    ds 4, JUMP_SIDE_ANIM_IND + 2
    ds 4, JUMP_SIDE_ANIM_IND + 3

; $6378: Animation indices used when the player falls after a vertical jump.
VerticalFallAnimInds::
    db FALL_VERT_ANIM_IND
    db FALL_VERT_ANIM_IND + 1
    db FALL_VERT_ANIM_IND + 2
    db FALL_VERT_ANIM_IND + 2
    db FALL_VERT_ANIM_IND + 2

; $637d: Animation indices used when the player falls after a sideway jump.
SidewayFallAnimInds::
    db FALL_SIDE_IND
    db FALL_SIDE_IND
    db FALL_SIDE_IND + 1
    db FALL_SIDE_IND + 1
    db FALL_SIDE_IND + 1

; $6382: Animation indices when the player dies.
DeathKnockAnimInds::
    db DEATH_ANIM_IND
    db DEATH_ANIM_IND + 1
    db (DEATH_ANIM_IND + 1) | $80   ; Let player face left
    db DEATH_ANIM_IND       | $80   ; Let player face left
    db (DEATH_ANIM_IND + 1) | $80   ; Let player face left
    db DEATH_ANIM_IND + 1

; $6388: Animation indices when the player is landing.
LandingInds:
    db WALK_ANIM_IND + 3
    db LAND_JUMP_ANIM_IND

; $638a: Animation indices for braking.
BrakeAnimInds1::
    db STANDING_ANIM_IND
    db BRAKE_ANIM_IND + 2           ; Player does λ and looks left.
    db BRAKE_ANIM_IND + 1           ; Player does λ and looks at screen.
    db BRAKE_ANIM_IND               ; Player does λ and looks right.

; $638e: Animation indices for braking.
BrakeAnimInds2::
    db STANDING_ANIM_IND
    db BRAKE_ANIM_IND               ; Player does λ and looks right.
    db BRAKE_ANIM_IND               ; Player does λ and looks right.
    db BRAKE_ANIM_IND               ; Player does λ and looks right.

; $6392: Animation indices for the shoveling animation in the transition level.
ShovelingAnimInds::
    db SHOVELING_ANIM_IND
    db SHOVELING_ANIM_IND + 1
    db SHOVELING_ANIM_IND + 2
    db SHOVELING_ANIM_IND + 3
    db SHOVELING_ANIM_IND + 4
    db SHOVELING_ANIM_IND + 3
    db SHOVELING_ANIM_IND + 2

; $6399: Tile map for the whole dug by the player in the transition level.
HoleTileMapData::
    db $6e, $6f, $70, $71, $61, $5a, $61, $5a, $72, $73, $74, $75, $61, $76, $77, $5a
    db $78, $01, $01, $79, $7a, $7b, $7c, $7d, $78, $01, $01, $79, $7e, $01, $01, $7f

; $63b9
TODOData63b9::
    db $00, $01, $12, $33, $44, $43, $32, $11

; $63c1
TODOData63c1::
    db $00, $00, $01, $11, $22, $22, $21, $11

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

; $6741
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

; $676c: Animation indices when the player shoots a projectile. Except for stones/pipe, which is handled below.
ShootAnimInds::
    db SHOOT_SIDE_ANIM_IND          ;  0: Doing nothing.
    db SHOOT_SIDE_ANIM_IND          ;  1: Walking right.
    db SHOOT_SIDE_ANIM_IND          ;  2: Walking left.
    db $00                          ;  3: Shouldn't be reachable (left and right pressed at the same time).
    db SHOOT_VERT_ANIM_IND          ;  4: Looking up.
    db SHOOT_45DEG_ANIM_IND         ;  5: Looking up right.
    db SHOOT_45DEG_ANIM_IND         ;  6: Looking up left.
    db $00                          ;  7: Shouldn't be reachable (up, left, and right pressed at the same time).
    db SHOOT_CROUCH_ANIM_IND        ;  8: Pressing down.
    db SHOOT_CROUCH_ANIM_IND        ;  9: Pressing down and right.
    db SHOOT_CROUCH_ANIM_IND        ;  10: Pressing down and left.

; $$676c: Animation indices when the player shoots from his pipe.
PipeAnimInds:
    db PIPE_SIDE_ANIM_IND           ; 0: Doing nothing.
    db PIPE_SIDE_ANIM_IND           ; 1: Walking right.
    db PIPE_SIDE_ANIM_IND           ; 2: Walking left.
    db $00                          ; 3: Shouldn't be reachable (left and right pressed at the same time).
    db PIPE_VERT_ANIM_IND           ; 4: Looking up.
    db PIPE_45DEG_ANIM_IND          ; 5: Looking up right.
    db PIPE_45DEG_ANIM_IND          ; 6: Looking up left.
    db $00                          ; 7: Shouldn't be reachable (up, left, and right pressed at the same time).
    db PIPE_CROUCH_ANIM_IND         ; 8: Pressing down.
    db PIPE_CROUCH_ANIM_IND         ; 9: Pressing down and right.
    db PIPE_CROUCH_ANIM_IND         ; 10: Pressing down and left.

; $6782: Holds the number of objects per level.
NumObjectsBasePtr::
    db 42                           ; Level 1: JUNGLE BY DAY
    db 43                           ; Level 2: THE GREAT TREE
    db 42                           ; Level 3: DAWN PATROL
    db 66                           ; Level 4: BY THE RIVER
    db 61                           ; Level 5: IN THE RIVER
    db 49                           ; Level 6: TREE VILLAGE
    db 57                           ; Level 7: ANCIENT RUINS
    db 72                           ; Level 8: FALLING RUINS
    db 43                           ; Level 9: JUNGLE BY NIGHT
    db 45                           ; Level 10: THE WASTELANDS
    db 9                            ; Level 11: Bonus
    db 0                            ; Level 12: Transition and credit screen

; $678e: Data for static objects.
CompressedDataLvlPointers::
    dw CompressedDataLvl1           ; Level 1: JUNGLE BY DAY
    dw CompressedDataLvl2           ; Level 2: THE GREAT TREE
    dw CompressedDataLvl3           ; Level 3: DAWN PATROL
    dw CompressedDataLvl4           ; Level 4: BY THE RIVER
    dw CompressedDataLvl5           ; Level 5: IN THE RIVER
    dw CompressedDataLvl6           ; Level 6: TREE VILLAGE
    dw CompressedDataLvl7           ; Level 7: ANCIENT RUINS
    dw CompressedDataLvl8           ; Level 8: FALLING RUINS
    dw CompressedDataLvl9           ; Level 9: JUNGLE BY NIGHT
    dw CompressedDataLvl10          ; Level 10: THE WASTELANDS
    dw CompressedDataLvl11          ; Level 11: Bonus
    dw $0000                        ; Level 12: Transition and credit screen

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

