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

TodoData:
    rst $38
    nop
    cp [hl]
    ld a, a
    ld a, a
    rst $38
    cp [hl]
    ld a, a
    sbc l
    ld a, [hl]
    db $e3
    inc e
    adc a
    ld [hl], b
    add d
    ld a, l
    ld a, e
    db $fd
    sbc l
    ld a, a
    add [hl]
    ld a, c
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    cp [hl]
    ld a, a
    ld a, a
    rst $38
    ld e, a
    cp a
    ld [hl], b
    rst $38
    adc a
    ld [hl], b
    db $e3
    inc e
    nop
    rst $38
    cp $ff
    add c
    cp $7f
    add b
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    jp $3c3c


    rst $38
    ld a, a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ccf
    rst $38
    rra
    rst $38
    nop
    rst $38
    add b
    ld a, a
    ldh [$1f], a
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    db $e3
    inc e
    cp [hl]
    ld a, a
    ld a, a
    rst $38
    rst $38
    rst $38
    cp a
    rst $38
    rst $38
    rst $38
    cp a
    rst $38
    cp a
    rst $38
    sbc a
    rst $38
    ld c, $ff
    nop
    rst $38
    ld b, b
    cp a
    di
    inc c
    rst $38
    nop
    rst $38
    nop

jr_005_6b7c:
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
    add hl, bc
    nop
    dec b
    nop
    ld d, $01
    add hl, de
    rlca
    ld [$1407], sp
    rrca
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
    ld c, b
    nop
    ld e, b
    nop
    or b
    ld b, b
    db $10
    ldh [$a0], a
    ret nz

    jr nz, jr_005_6b7c

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
    add hl, bc
    nop
    dec b
    nop
    ld d, $01
    add hl, de
    rlca
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
    ld c, b
    nop
    ld e, b
    nop
    or b
    ld b, b
    db $10
    ldh [rP1], a
    nop

jr_005_6bfe:
    nop
    nop

jr_005_6c00:
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
    ld bc, $0200
    ld bc, $030c
    ld [hl], e
    inc c
    adc h
    ld [hl], b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [$1407], sp
    rrca
    ld a, [bc]
    rlca
    inc b
    inc bc

jr_005_6c24:
    dec e
    inc bc
    ld h, h
    dec de
    add [hl]
    ld a, c
    ld b, e
    db $fc
    add b
    rst $38
    nop

jr_005_6c2f:
    rst $38
    ret nz

    ccf
    ccf
    db $10
    ld a, b
    jr nc, jr_005_6c2f

    ld d, b
    ld hl, sp+$70
    ld [hl], b
    nop
    jr nz, jr_005_6bfe

    jr nz, jr_005_6c00

    inc hl
    ret nz

    inc e
    db $e3
    db $10
    rst $28
    db $10
    rst $28
    nop
    rst $38
    nop
    rst $38
    ld bc, $02fe
    db $fc
    inc a
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
    nop
    nop

jr_005_6c60:
    ret nz

    nop
    jr nz, jr_005_6c24

    ld [hl], b
    add b
    ldh a, [$60]
    ldh a, [rLCDC]
    ld l, b
    ldh a, [$78]
    ldh a, [$f8]
    jr nc, jr_005_6ca9

    db $10
    jr jr_005_6c74

jr_005_6c74:
    nop
    nop
    nop
    nop

Call_005_6c78:
    nop
    nop
    nop
    nop
    ld [$1407], sp
    rrca
    ld [$1407], sp
    rrca
    ld a, [de]
    rlca
    ld h, h
    dec de
    add l
    ld a, e
    ld b, e
    db $fc
    add b
    rst $38
    nop

jr_005_6c8f:
    rst $38
    ret nz

    ccf
    ccf
    db $10
    ld a, b
    jr nc, jr_005_6c8f

    ld d, b
    ld hl, sp+$70
    ld [hl], b
    nop
    and b
    ret nz

    jr nz, jr_005_6c60

    inc sp
    ret nz

    inc a
    jp $cf30


    db $10
    rst $28
    db $10

jr_005_6ca9:
    rst $28
    nop
    rst $38
    ld bc, $02fe
    db $fc
    inc a
    ret nz

    ret nz

    nop
    nop
    nop
    nop

jr_005_6cb7:
    nop
    nop
    nop
    nop
    nop
    add hl, bc
    nop
    dec b
    nop
    ld b, $01
    add hl, bc
    rlca
    ld [$7c07], sp
    rlca
    adc [hl]
    ld [hl], e
    ld b, [hl]
    ld sp, hl
    add b
    rst $38
    nop

jr_005_6ccf:
    rst $38
    ret nz

    ccf
    ccf
    db $10
    ld a, b
    jr nc, jr_005_6ccf

    ld d, b
    ld hl, sp+$70
    ld [hl], b
    nop
    ld c, b
    nop
    ld e, b
    nop
    or e
    ld b, b
    inc e
    db $e3
    or b
    rst $08
    jr nc, jr_005_6cb7

Call_005_6ce8:
    db $10
    rst $28
    nop
    rst $38
    ld bc, $02fe
    db $fc
    inc a
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $030c
    ld [hl], e
    inc c
    adc h
    ld [hl], b

jr_005_6d10:
    ld [hl], b
    nop

jr_005_6d12:
    nop
    nop

jr_005_6d14:
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
    inc bc
    nop

jr_005_6d20:
    inc e
    inc bc
    ld h, b
    rra
    add e
    ld a, h
    ld b, [hl]
    ld sp, hl
    add l
    ei
    inc b
    ei
    jp z, $3437

    rrca
    ld a, b
    daa
    db $f4
    ld c, a
    ld hl, sp+$67
    ld a, c
    rlca
    ld b, $01
    dec b
    nop
    inc bc
    nop
    db $fc
    inc bc
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    db $10
    rst $28
    ld de, $1aee
    db $e4
    inc a
    ret nz

    jr nc, jr_005_6d10

    jr nz, jr_005_6d12

    jr nz, jr_005_6d14

    and b
    ret nz

    db $10
    ldh [$b0], a
    ld b, b
    ld c, b
    nop
    ret nz

    nop
    jr nz, jr_005_6d20

    ld [hl], b
    add b
    ldh a, [$60]
    ldh a, [rLCDC]
    ld l, b
    ldh a, [$78]
    ldh a, [$f8]
    jr nc, jr_005_6da5

    db $10
    jr jr_005_6d70

jr_005_6d70:
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
    inc bc
    nop
    inc e
    inc bc
    ld h, b
    rra
    add e
    ld a, h
    ld b, h
    ei
    adc c
    rst $30
    db $10
    rst $28
    jp z, $3437

    rrca
    ld a, c
    scf
    cp $51
    db $fd
    ld [hl], b
    ld [hl], c
    nop
    nop
    nop

Call_005_6d9a:
    nop
    nop
    inc bc
    nop

Call_005_6d9e:
    db $fc
    inc bc
    nop
    rst $38
    nop
    rst $38
    nop

jr_005_6da5:
    rst $38
    db $10
    rst $28
    ld de, $3aee
    call nz, $c0fc
    and b
    ret nz

    db $10
    ldh [$b0], a
    ld b, b
    ld e, b
    nop
    ld c, b
    nop
    nop
    nop
    nop
    nop

jr_005_6dbc:
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
    stop
    ld a, [de]
    nop
    dec h
    ld a, [de]
    db $10
    rrca
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
    and b
    nop
    ld e, b
    and b
    jr nz, jr_005_6dbc

    nop
    nop
    inc bc
    nop
    inc e
    inc bc
    ld h, b
    rra
    adc d
    ld [hl], a
    ld c, h
    di
    add h
    ei
    dec bc

jr_005_6e0b:
    db $f4
    db $c2
    db $3d
    db $3f
    ;jp nz, Jump_000_3f3d

    db $10
    ld a, b
    jr nc, jr_005_6e0b

    ld d, b
    ld hl, sp+$70
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    db $fc
    inc bc
    nop
    rst $38
    ld h, b
    sbc a
    ret nc

    rst $28
    ld d, b
    rst $28
    adc c
    or $5a
    and h
    cp h
    ld b, b
    ret nz

    nop
    nop
    nop
    nop
    nop
    nop

jr_005_6e35:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rra
    nop
    inc b
    inc bc
    ld e, $01
    dec b
    ld [bc], a
    dec e
    inc bc
    ld h, h
    dec de
    add [hl]
    ld a, c
    ld b, e
    db $fc
    add b
    rst $38
    nop

jr_005_6e4f:
    rst $38
    ret nz

    ccf
    ccf
    db $10
    ld a, b
    jr nc, jr_005_6e4f

    ld d, b
    ld hl, sp+$70
    ld [hl], b
    nop
    ldh a, [rP1]
    ld l, b
    ldh a, [$8b]
    ld [hl], b
    ld l, h
    sub e
    jr nc, jr_005_6e35

    sub b
    rst $28
    nop
    rst $38
    nop
    rst $38
    ld bc, $02fe
    db $fc
    inc a
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
    ld [SetUpInterrupts], sp
    rrca
    ld a, [bc]
    rlca
    inc b
    inc bc
    dec e
    inc bc
    ld h, h
    dec de
    add [hl]
    ld a, c
    ld b, e
    db $fc
    add b
    rst $38
    nop

jr_005_6e8f:
    rst $38
    ret nz

    ccf
    ccf
    db $10
    ld a, b
    jr nc, jr_005_6e8f

    ld d, b

jr_005_6e98:
    ld hl, sp+$70

jr_005_6e9a:
    ld [hl], b
    nop

jr_005_6e9c:
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_6ea3:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add hl, bc
    nop
    dec b
    nop
    ld d, $01
    add hl, de
    rlca
    ld [$1407], sp
    rrca
    ld [$1407], sp
    rrca
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
    ld c, b
    nop
    ld e, b
    nop
    or b
    ld b, b
    db $10
    ldh [$a0], a
    ret nz

    jr nz, jr_005_6e98

    jr nz, jr_005_6e9a

    jr nz, jr_005_6e9c

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
    ld [$2d00], sp
    nop
    inc de
    inc c
    add hl, sp
    ld c, $65
    ld e, $1a
    inc b
    ld [hl+], a
    inc e
    inc [hl]
    ld [$384c], sp
    adc h
    ld a, b
    call nz, CopyData
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    stop
    ld a, [de]
    nop
    ld [hl], $08
    ld [de], a
    inc c
    ld a, [de]
    inc c
    inc d
    ld [$1824], sp
    jr z, jr_005_6f26

    ld e, b
    jr nc, jr_005_6f71

    jr nc, jr_005_6ea3

    ld [hl], b
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

jr_005_6f26:
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
    inc e
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
    ld [bc], a
    nop
    dec bc
    nop
    inc b
    inc bc
    ld c, $03
    add hl, de
    rlca
    ld b, $01
    ld [$0d07], sp
    ld [bc], a
    inc de
    ld c, $23
    ld e, $52
    inc l
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
    ld b, b
    nop
    ret nz

    nop
    ld b, b
    add b
    ld b, b
    add b
    add b

jr_005_6f71:
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
    ld [de], a
    nop
    ld a, [de]
    nop
    dec c
    ld [bc], a
    ld [$0507], sp
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
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
    nop
    nop
    sub b
    nop
    and b
    nop
    ld l, b
    add b
    sbc b
    ldh [rNR10], a
    ldh [$28], a
    ldh a, [rNR10]
    ldh [$28], a
    ldh a, [rP1]
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    ld a, h
    inc bc
    xor l
    ld a, e
    ld b, b
    ccf
    and b
    ld a, a
    ld b, e
    inc a
    adc h
    ld [hl], b

jr_005_6fd0:
    ld [hl], b
    nop

jr_005_6fd2:
    nop
    nop

jr_005_6fd4:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, [bc]
    rlca
    rlca
    nop

jr_005_6fe0:
    db $fc
    inc bc
    nop
    rst $38
    jp $06fc


    ld sp, hl
    dec b
    ei
    inc b
    ei
    jp z, $f437

    ld c, a
    ld hl, sp+$67
    ld [hl], h
    rrca
    jr jr_005_6ffd

    add hl, bc
    rlca
    ld b, $01
    dec b
    nop
    inc hl

jr_005_6ffd:
    ret nz

    db $fc
    inc bc
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    db $10
    rst $28
    ld de, $1aee
    db $e4
    inc a
    ret nz

    jr nc, jr_005_6fd0

    jr nz, jr_005_6fd2

    jr nz, jr_005_6fd4

    and b
    ret nz

    db $10
    ldh [$b0], a
    ld b, b
    ld c, b
    nop
    ret nz

    nop
    jr nz, jr_005_6fe0

    db $10
    ldh [rSVBK], a
    add b
    ldh a, [$60]
    add sp, $50
    ld a, b
    ldh a, [$f8]
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
    dec c
    nop
    ld a, [de]
    dec c
    ld h, $19
    jr nc, jr_005_7069

    dec h
    dec de
    ld e, $01
    ld bc, $0300
    ld bc, $0017
    ld a, b
    rlca
    ld h, $1f
    ld [hl], e
    inc c
    inc e
    nop
    inc bc
    nop
    inc a
    inc bc
    ret


    ld [hl], $53
    db $ec

jr_005_7064:
    sub a
    db $eb
    add a
    ei
    inc bc

jr_005_7069:
    db $fd
    ld b, c
    cp [hl]
    adc h

jr_005_706d:
    ld a, e
    ld c, a
    or b
    ld e, b
    ldh [rNR41], a
    ret nz

    ld b, b
    add b
    add b
    nop
    nop
    nop
    nop
    nop
    inc d
    ld hl, sp-$34
    jr nc, jr_005_706d

    ret nc

    db $f4
    add sp, $74
    xor b
    cp b
    ld [hl], b
    db $fc
    ld hl, sp+$3e
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
    ld bc, $0200
    ld bc, $033c
    dec e
    ld c, $26
    jr jr_005_70d3

    nop
    rlca
    nop
    add hl, bc
    ld b, $13
    dec c
    scf
    add hl, bc
    ld a, $07
    cpl
    ld d, $27
    dec de
    ld b, d
    dec a
    ld e, a
    jr nc, jr_005_7064

    ld h, d
    and d
    ret nz

    ld b, b

jr_005_70d3:
    add b
    add b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr z, @-$0e

    sbc b
    ld h, b
    call c, $eaa0
    call nc, $50ec
    ld a, h
    ret z

    db $fc
    add sp, $78
    ldh [$f0], a
    nop
    ldh [$c0], a
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
    dec b
    nop
    ld e, $01
    add hl, bc
    rlca
    inc e
    inc bc
    rlca
    nop
    dec hl
    inc e
    ld e, [hl]
    dec l
    xor h
    ld e, e
    db $fc
    ld a, e
    cp h
    ld h, e
    ld h, b
    rra

jr_005_7128:
    daa
    rra
    jr nz, @+$21

    ld b, e
    ld a, $53
    inc l
    sub $78
    ret z

jr_005_7133:
    jr nc, jr_005_7145

    ldh [$a0], a
    ret nz

    ret nz

    nop
    nop
    nop
    sub d
    ld a, h
    inc b
    ld hl, sp+$03
    db $fc
    ld b, $f9
    rrca

jr_005_7145:
    or $0f
    or $06
    ld sp, hl
    jr jr_005_7133

    ld a, $d9
    db $fd
    jr jr_005_7169

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
    add b
    nop
    ldh [rP1], a
    jr nz, jr_005_7128

    ld b, b

jr_005_7169:
    add b
    ld b, b
    add b
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
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    ld b, $01
    rrca
    ld b, $0f
    ld [bc], a
    ld c, $07
    rra
    rrca
    rra
    inc c
    inc e
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
    call nz, $3c03
    jp $ff00


    nop
    rst $38
    add b
    ld a, a
    nop
    rst $38
    sub b
    ld a, a
    ld c, h
    ccf
    ld a, $01
    dec c
    ld [bc], a
    inc b
    inc bc
    inc b
    inc bc
    dec b
    inc bc
    ld [$0d07], sp
    ld [bc], a
    ld [de], a
    nop
    ld d, b
    ldh [rNR41], a
    ret nz

    ccf
    ret nz

    nop
    rst $38
    rrca
    pop af
    rrca
    or $1f
    xor $1e
    pop hl
    rra
    add sp, -$01
    ld c, $1f
    and $2e
    ldh a, [rNR23]
    ldh [$90], a
    ldh [$60], a
    add b
    and b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ld a, $c0
    or l
    sbc $02
    db $fc
    dec b
    cp $c2
    inc a
    ld sp, $0e0e
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

TODOSprites71fc::
    INCBIN "gfx/TODOSprites71fc.2bpp"

TODOSprites729c::
    INCBIN "gfx/TODOSprites729c.2bpp"

    ldh [rP1], a
    ld a, h
    add b
    ret nc

    jr nz, @-$5e

    ld b, b
    ld b, b
    add b
    add b
    nop
    ret nz

    nop
    jr nz, @-$3e

    and b
    ret nz

    sub b
    ldh [$39], a
    ret nc

    ccf
    ret c

    ld bc, $07fe
    ld hl, sp+$18
    ldh [$e0], a
    nop
    nop
    nop
    nop
    dec b
