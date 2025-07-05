SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

; $4000: Starting posiitions for the player and the background scroll for every level.
; Tuples are as follows:
; (BgScrollXLsb, BgScrollXMsb, BgScrollYLsb, BgScrollYMsb, PlayerPositionXLsb, PlayerPositionXMsb, PlayerPositionYLsb, PlayerPositionYMsb)
; Each level has two tuples: One for the start, and one for the checkpoint.
StartingPositions::
    db $00, $00, $58, $01, $10, $00, $a0, $01 ; Level 1 "JUNGLE BY DAY": Start.
    db $10, $06, $88, $01, $34, $06, $e0, $01 ; Level 1 "JUNGLE BY DAY": Checkpoint.
    db $00, $00, $88, $07, $10, $00, $d0, $07 ; Level 2 "THE GREAT TREE": Start.
    db $10, $01, $38, $01, $34, $01, $80, $01 ; Level 2 "THE GREAT TREE": Checkpoint.
    db $00, $00, $00, $00, $24, $00, $00, $01 ; Level 3 "DAWN PATROL": Start.
    db $50, $09, $00, $00, $74, $09, $00, $01 ; Level 3 "DAWN PATROL": Checkpoint.
    db $50, $01, $88, $01, $c8, $01, $c0, $01 ; Level 4 "BY THE RIVER": Start.
    db $18, $0e, $68, $01, $3c, $0e, $a0, $01 ; Level 4 "BY THE RIVER": Checkpoint.
    db $00, $00, $88, $03, $34, $00, $e4, $03 ; Level 5 "IN THE RIVER": Start.
    db $60, $06, $18, $03, $b0, $06, $60, $03 ; Level 5 "IN THE RIVER": Checkpoint.
    db $00, $00, $80, $03, $24, $00, $e0, $03 ; Level 6 "TREE VILLAGE": Start.
    db $10, $05, $38, $01, $34, $05, $80, $01 ; Level 6 "TREE VILLAGE": Checkpoint.
    db $00, $00, $30, $00, $24, $00, $80, $00 ; Level 7 "ANICENT RUINS": Start.
    db $50, $05, $88, $03, $84, $05, $e0, $03 ; Level 7 "ANICENT RUINS": Checkpoint.
    db $20, $00, $48, $06, $46, $00, $a1, $06 ; Level 8 "FALLING RUINS": Start.
    db $00, $00, $48, $00, $10, $00, $a0, $00 ; Level 8 "FALLING RUINS": Checkpoint.
    db $00, $00, $88, $03, $24, $00, $e0, $03 ; Level 9 "JUNGLE BY NIGHT": Start.
    db $60, $07, $88, $03, $e0, $07, $e0, $03 ; Level 9 "JUNGLE BY NIGHT": Checkpoint.
    db $00, $00, $58, $03, $24, $00, $a0, $03 ; Level 10 "THE WASTELANDS": Start.
    db $58, $06, $68, $03, $84, $06, $a0, $03 ; Level 10 "THE WASTELANDS": Checkpoint.
    db $40, $01, $00, $00, $90, $01, $20, $00 ; Level 11 "Bonus": Start.
    db $40, $01, $00, $00, $90, $01, $20, $00 ; Level 11 "Bonus": Checkpoint.
    db $00, $00, $18, $00, $00, $00, $00, $00 ; Level 12 "Transition": Start.
    db $00, $00, $18, $00, $00, $00, $00, $00 ; Level 12 "Transition": Checkpoint.

; $40c0: Seemingly unused data.
.UnusedData40c0:
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00

AssetSprites::

; $40dc: Sprite of the diamonds you have to collect in a level.
DiamondSprite::
  INCBIN "gfx/DiamondSprite.2bpp"

; $411c: Projectiles, score numbers, etc.
AssetSprites2::
  INCBIN "gfx/AssetSprites2.2bpp"

; $429c: Pineapple giving bonus points.
PineappleSprite::
    INCBIN "gfx/PineappleSprite.2bpp"

; $42bc: Leaf from the bonus level.
LeafSprites::
    INCBIN "gfx/LeafSprites.2bpp"

; $42fc: Grape-like health package.
HealthPackageSprites::
    INCBIN "gfx/HealthPackageSprites.2bpp"

; $433c: Mowgli-icon giving an extra life.
ExtraLifeSprites::
    INCBIN "gfx/ExtraLifeSprites.2bpp"

; $437c: Clock giving extra time.
ExtraTimeSprites::
    INCBIN "gfx/ExtraTimeSprites.2bpp"

; $43bc: Shovel providing access to the bonus level.
ShovelSprites::
    INCBIN "gfx/ShovelSprites.2bpp"

; $43fc: Double banana item as dropped by enemies.
DoubleBananaSprites::
    INCBIN "gfx/DoubleBananaSprites.2bpp"

; $443c: Boomerang weapon item as dropped by enemies.
BoomerangItemSprite::
    INCBIN "gfx/BoomerangItemSprite.2bpp"

; $445c: Projectile shot by snakes.
SnakeProjectileSprite::
    INCBIN "gfx/SnakeProjectileSprite.2bpp"

; $447c: Sprite of the catapult boulder.
BoulderSprite::
    INCBIN "gfx/BoulderSprite.2bpp"

; $44bc: Sprite of the rotating checkpoint flower.
CheckpointSprite::
    INCBIN "gfx/CheckpointSprite.2bpp"

EnemySprites1::

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
    ld [hl], b
    nop
    cp b
    ld [hl], b
    add sp, $30
    cp h
    ld b, b
    ld d, [hl]
    jr c, jr_005_45c8

    ld c, $0d
    ld [bc], a

jr_005_455a:
    ld [bc], a
    ld bc, $0000
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
    nop
    nop
    nop
    ldh [rP1], a
    jr jr_005_455a

    add h
    ld a, b
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

jr_005_4587:
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
    ld b, $00
    dec c
    ld b, $79
    ld b, $90
    ld l, a
    ld bc, $0200
    ld bc, $0205
    inc bc
    inc b
    dec b
    nop
    ld bc, $0200
    ld bc, $0102
    ld [bc], a
    ld bc, $0304
    dec b
    ld [bc], a
    dec b
    ld [bc], a
    ld b, $03
    inc b
    inc bc
    inc bc
    nop
    nop
    nop
    ld [c], a
    ld bc, $e314
    db $ec
    inc de
    ld e, h
    db $e3
    inc bc
    db $fc
    ld [hl], b
    adc a

jr_005_45c8:
    ld l, h
    sub e
    xor b
    rla
    reti


    ld h, $d2
    dec l
    ld h, h
    dec de
    ret nz

    ccf
    jp nz, $e47d

    ld a, e
    ld sp, hl
    ld b, $29
    rra
    db $fc
    add b
    db $fc
    or b
    ld a, [c]
    inc l
    ld l, a
    cp h
    ld e, [hl]
    cp a
    dec a
    sbc $2b
    call c, $807e
    or [hl]
    ld l, h
    ld [de], a
    db $ec
    inc h
    ret c

    ld c, b
    or b
    ret nc

    jr nz, jr_005_4587

    ld h, b
    ld hl, sp+$00
    or h
    ret c

    ld b, $00
    dec c
    ld b, $78
    rlca
    sub b
    ld l, a
    ld [hl], d
    adc l
    and [hl]
    add hl, de
    dec hl
    inc d
    ld e, e
    inc h
    sbc e
    ld h, h
    xor e
    ld b, h
    sub $69
    sbc h
    ld h, e
    ld [hl], b
    rrca
    jr nz, jr_005_4637

    ld h, d
    dec a
    db $76
    add hl, sp
    nop
    nop
    nop
    nop
    adc [hl]
    nop
    pop de
    ld c, $28
    rst $10
    cpl
    ret c

    ld c, a
    cp e
    ld c, a
    or d
    ld b, [hl]
    cp e
    dec [hl]
    swap e
    call $b15e
    adc e
    db $76
    ld [de], a

jr_005_4637:
    db $ec
    inc h
    ret c

    ld c, b
    or b
    nop
    nop
    nop
    nop
    inc bc
    nop
    adc l
    inc bc
    ld [hl], c
    adc [hl]
    add $38
    ret z

    jr nc, jr_005_467b

    ret nz

    ldh a, [$c0]
    ldh [$f0], a
    ret nc

    ldh [$b0], a
    ret nz

    ret nz

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
    ld hl, sp+$00
    ld b, $f8
    di
    ld c, $14
    dec bc
    ld e, $01
    inc bc
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

jr_005_4679:
    nop
    nop

jr_005_467b:
    nop
    ld h, h
    sbc e
    xor [hl]
    ld de, $255a
    sbc d
    ld h, l
    xor e
    ld b, h
    db $db
    ld h, h

jr_005_4688:
    sub [hl]
    ld l, c
    db $fc
    inc bc
    ld [hl], b
    rrca
    ld b, e
    inc a
    ret nz

    ld a, a
    db $ec
    ld [hl], e
    ld a, b
    rlca
    add hl, bc
    ld b, $33
    inc c
    ld d, e
    ccf
    adc [hl]
    nop
    ld d, c
    adc [hl]
    jr z, jr_005_4679

    cpl
    ret c

    ld c, a
    cp e
    ld c, a
    or d
    ld b, [hl]
    cp e
    dec [hl]
    set 4, e
    dec e
    sbc [hl]
    ld h, c
    scf
    db $ec
    inc h
    ret c

    ret c

    jr nz, jr_005_46d7

    ret nz

    ldh a, [rP1]
    ld l, b
    or b
    nop
    nop
    add b
    nop
    ld b, b
    add b
    ret nz

    nop
    ret nz

    nop
    jr nz, jr_005_4688

    ldh a, [$c0]
    add sp, -$10
    call nc, $b2e8
    call z, $06fb
    add hl, bc
    ld b, $05
    ld [bc], a
    dec b

jr_005_46d7:
    ld [bc], a
    dec b
    ld [bc], a
    dec b
    ld [bc], a
    inc a
    inc bc
    add hl, de
    ld b, $29
    rra
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
    nop
    nop
    nop
    nop
    nop
    sub b
    ld h, b
    ld hl, sp+$00
    or h
    ret c

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
    nop
    nop
    nop
    nop
    nop

; $471c
EnemySprites::
    INCBIN "gfx/EnemySprites.2bpp"

; $521c
SnakeAnimationSprites::
    INCBIN "gfx/SnakeAnimationSprites.2bpp"

EagleSprites::
    INCBIN "gfx/EagleSprites.2bpp"

TODOSprites565c::
    INCBIN "gfx/TODOSprites565c.2bpp"

; $5a1c
FloatingBalooSprites::
    INCBIN "gfx/FloatingBalooSprites.2bpp"

StoneSprites::
    INCBIN "gfx/StoneSprites.2bpp"

PearSprites::
    INCBIN "gfx/PearSprites.2bpp"

CherrySprite::
    INCBIN "gfx/CherrySprite.2bpp"

EggSprite::
    INCBIN "gfx/EggSprite.2bpp"

InvincibleMaskSprites::
    INCBIN "gfx/InvincibleMaskSprites.2bpp"

TODOSprites5d1c::
    INCBIN "gfx/TODOSprites5d1c.2bpp"

FloaterSprites::
    INCBIN "gfx/FloaterSprites.2bpp"

TODOSprites60bc::
    INCBIN "gfx/TODOSprites60bc.2bpp"

BonusSprites::
    INCBIN "gfx/BonusSprites.2bpp"

TODOSprites6afc::
    INCBIN "gfx/TODOSprites6afc.2bpp"

FlyingBirdSprites::
    INCBIN "gfx/FlyingBirdSprites.2bpp"

FlyingBirdTurnSprites::
    INCBIN "gfx/FlyingBirdTurnSprites.2bpp"

WalkingMonkeySprites::
    INCBIN "gfx/WalkingMonkeySprites.2bpp"

WalkingMonkeySprites2::
    INCBIN "gfx/WalkingMonkeySprites2.2bpp"

FishSprites::
    INCBIN "gfx/FishSprites.2bpp"

HippoSprites::
    INCBIN "gfx/HippoSprites.2bpp"

BatSprites::
    INCBIN "gfx/BatSprites.2bpp"

Bank5TailData::
    db $00, $00, $00, $05
