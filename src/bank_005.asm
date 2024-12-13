SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

; $4000: Starting posiitions for the player and the background scroll for every level.
; Tuples are as follows:
; (BgScrollXLsb, BgScrollXMsb, BgScrollYLsb, BgScrollYMsb, PlayerPositionXLsb, PlayerPositionXMsb, PlayerPositionYLsb, PlayerPositionYMsb)
; Each level has two tuples: One for the start, and one for the checkpoint.
StartingPositions::
    db $00, $00, $58, $01, $10, $00, $a0, $01 ; Level 0: Start.
    db $10, $06, $88, $01, $34, $06, $e0, $01 ; Level 0: Checkpoint.
    db $00, $00, $88, $07, $10, $00, $d0, $07 ; Level 1: Start.
    db $10, $01, $38, $01, $34, $01, $80, $01 ; Level 1: Checkpoint.
    db $00, $00, $00, $00, $24, $00, $00, $01 ; Level 2: Start.
    db $50, $09, $00, $00, $74, $09, $00, $01 ; Level 2: Checkpoint.
    db $50, $01, $88, $01, $c8, $01, $c0, $01 ; Level 3: Start.
    db $18, $0e, $68, $01, $3c, $0e, $a0, $01 ; Level 3: Checkpoint.
    db $00, $00, $88, $03, $34, $00, $e4, $03 ; Level 4: Start.
    db $60, $06, $18, $03, $b0, $06, $60, $03 ; Level 4: Checkpoint.
    db $00, $00, $80, $03, $24, $00, $e0, $03 ; Level 5: Start.
    db $10, $05, $38, $01, $34, $05, $80, $01 ; Level 5: Checkpoint.
    db $00, $00, $30, $00, $24, $00, $80, $00 ; Level 6: Start.
    db $50, $05, $88, $03, $84, $05, $e0, $03 ; Level 6: Checkpoint.
    db $20, $00, $48, $06, $46, $00, $a1, $06 ; Level 7: Start.
    db $00, $00, $48, $00, $10, $00, $a0, $00 ; Level 7: Checkpoint.
    db $00, $00, $88, $03, $24, $00, $e0, $03 ; Level 8: Start.
    db $60, $07, $88, $03, $e0, $07, $e0, $03 ; Level 8: Checkpoint.
    db $00, $00, $58, $03, $24, $00, $a0, $03 ; Level 9: Start.
    db $58, $06, $68, $03, $84, $06, $a0, $03 ; Level 9: Checkpoint.
    db $40, $01, $00, $00, $90, $01, $20, $00 ; Level 10: Start.
    db $40, $01, $00, $00, $90, $01, $20, $00 ; Level 10: Checkpoint.
    db $00, $00, $18, $00, $00, $00, $00, $00 ; Level 11: Start.
    db $00, $00, $18, $00, $00, $00, $00, $00 ; Level 11: Checkpoint.

; $40c0: Seemingly unused data.
.UnusedData40c0:
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00

AssetSprites::
    INCBIN "gfx/AssetSprites.2bpp"

; $44bc: Sprite of the rotation checkpoint flower.
CheckpointSprite::
    INCBIN "gfx/CheckpointSprite.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

EnemySprites::
    INCBIN "gfx/EnemySprites.2bpp"

SnakeAnimationSprites::
    INCBIN "gfx/SnakeAnimationSprites.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz, jr_005_5258

jr_005_5258:
    ld e, b
    jr nz, jr_005_527f

    jr jr_005_525d

jr_005_525d:
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_5263:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_005_5278

jr_005_5278:
    ld h, h
    jr @-$66

    ld h, b
    nop
    nop
    nop

jr_005_527f:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz, jr_005_5298

jr_005_5298:
    ld d, b
    jr nz, jr_005_5263

    jr nc, jr_005_529d

jr_005_529d:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [$3400], sp
    ld [$2856], sp
    ld b, d
    inc a
    ld a, [hl-]
    inc b
    dec b
    ld [bc], a
    ld [bc], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld d, b
    and b
    db $fc
    ld b, b
    ld d, e
    inc a
    ld l, l
    ld [hl-], a
    ld sp, $261e
    add hl, de
    inc d
    dec bc
    ld c, $03
    ld c, $01
    dec b
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
    ld b, e
    nop
    cp h
    ld b, e
    ld h, a
    ld hl, sp-$2c
    dec sp
    ld a, [hl+]
    db $dd
    sbc [hl]
    ld l, l
    adc a
    db $fc
    ei
    ld c, h
    ld l, [hl]
    ret c

    or [hl]
    ld e, b
    jp z, $0134

    nop
    inc bc

jr_005_531f:
    nop
    dec c
    ld [bc], a
    ld a, [hl-]
    inc b
    ld d, h
    jr z, jr_005_531f

    db $10
    ret nc

    and b
    ld d, b
    ldh [$e0], a
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
    add b
    nop
    inc b
    ld hl, sp+$78
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc b
    ld [hl], b
    ld l, h
    db $10
    cpl
    db $10
    add hl, de
    ld b, $05
    ld [bc], a
    ld [bc], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ld a, h
    ret nz

    dec sp
    call c, $bdc2
    dec h
    jp c, $36e9

    ld d, [hl]
    add hl, sp
    inc [hl]
    dec bc
    ld c, $03
    ld b, $01
    dec b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    sbc l
    inc bc
    db $f4
    dec bc
    ld l, d
    push af
    rst $10
    jr c, jr_005_53d7

    db $dd
    sbc [hl]
    ld l, l
    adc a
    db $fc
    ld a, [$6e4c]
    ret c

    or [hl]
    ld e, b
    jp z, $f334

    inc c
    nop
    nop
    nop
    nop
    ccf
    nop
    call nc, $c43b
    cp e
    dec de
    db $ec
    ld h, h
    sbc b
    ld e, b
    ldh [$a0], a
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

jr_005_53d7:
    nop
    nop
    nop
    add b
    nop
    ld b, d
    inc a
    call z, $d030
    jr nz, jr_005_5443

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

jr_005_53ee:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300
    nop
    ld b, l
    ld [bc], a
    and h
    ld b, e
    dec e
    ld [c], a
    call nc, Call_000_0b2b
    db $f4
    db $fc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc a
    nop
    rst $30
    jr c, jr_005_53ee

    cp d
    rrca
    ldh a, [rNR52]
    reti


    or h
    ld a, e
    cp [hl]
    jp $01c6


    dec b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_5443:
    nop
    inc bc
    nop
    cp $01
    ld l, d
    push af
    rst $10
    jr c, @+$2c

    db $dd
    sbc [hl]
    ld l, l
    adc a
    db $fc
    ld a, [$6a4c]
    call c, Call_005_58b6
    jp z, $eb34

    inc d
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ld hl, sp-$40
    inc a
    ret c

    ld b, $f8
    ld h, l
    sbc d
    ret z

    rst $30
    db $ec
    dec de
    add hl, de
    ld b, $06
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop
    adc e
    inc b
    pop af
    ld c, $a6
    ld e, b
    ld b, c
    cp [hl]
    cp $00
    nop
    nop
    nop
    nop
    inc bc
    nop
    ld [bc], a
    ld bc, $0306
    inc a
    inc bc
    dec l
    ld a, [de]
    ld d, e
    inc a
    ld a, [hl-]
    rlca
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
    di
    inc c
    inc b
    ei
    xor h
    ld e, e
    ei
    inc b
    ccf
    inc d
    ld de, $970f
    inc c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    add b
    ld b, b
    add b
    add b
    nop
    nop
    nop
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
    nop
    nop
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
    ld bc, $0306
    inc a
    inc bc
    dec l
    ld a, [de]
    ld d, e
    inc a
    ld a, [hl-]
    rlca
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
    inc b
    ei
    xor h
    ld e, e
    ei
    inc b
    ccf
    inc d
    ld de, $970f
    inc c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    add b
    ld b, b
    add b
    add b
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc d
    db $eb
    xor h
    ld e, e
    ei
    inc b
    ccf
    inc d
    ld de, $970f
    inc c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_5578:
    nop
    nop
    nop
    nop
    add b
    nop
    ld b, b
    add b
    ld b, b
    add b
    add b
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
    inc a
    nop
    ld b, a
    jr c, jr_005_5615

    dec bc
    inc hl
    inc e
    dec l
    db $10
    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, b
    add b
    ldh [rLCDC], a
    pop de
    jr nz, jr_005_5578

    ld [hl], b
    ld [hl], e
    inc e
    db $76
    add hl, bc
    ld d, h
    dec hl
    ld a, $03
    ld e, $01
    dec b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, b
    nop
    and b
    ld b, b
    ret c

    ld h, b
    ld h, a
    ld hl, sp-$24
    dec sp
    ld a, [hl+]
    db $dd
    sbc [hl]
    ld l, l
    adc a
    db $fc
    ei
    ld c, h
    ld l, [hl]
    ret c

    or [hl]
    ld e, b
    jp z, $f334

    inc c
    ld bc, $0600
    ld bc, $0609
    scf
    ld [$305c], sp
    cp b
    ld b, b
    ld l, b
    ret nc

    ldh a, [$80]
    ldh a, [rP1]
    and b
    ld b, b
    ret nz

    nop
    add b
    nop
    nop

jr_005_5615:
    nop
    nop
    nop
    add b
    nop
    ld b, b
    add b
    ld hl, sp+$00
    add h
    ld a, b
    cp h
    ld b, b
    ld [$d0f0], sp
    jr nz, jr_005_5647

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    add b
    add b
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    nop

jr_005_5647:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0003
    inc bc
    nop
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
    rra
    nop
    daa
    jr @+$50

    ld sp, $5ba4
    sub [hl]
    ld a, e
    cp [hl]
    ld h, c
    xor l
    ld b, e
    db $e4
    ld b, e
    ld b, h
    add e
    ld b, e
    add b
    jp nz, $0001

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ld l, a
    ldh a, [$d6]
    add hl, sp
    dec hl
    call c, Call_005_6d9a
    adc [hl]
    db $fd
    rst $38
    ld c, h
    ld l, e
    call c, Call_005_58b6
    jp c, $eb34

    inc d
    inc d
    db $eb
    nop
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
    ld b, b
    add b
    jr nz, @-$3e

    ld d, b
    and b
    adc b
    ldh a, [$cc]
    ld [hl], b
    ld e, h
    jr nz, jr_005_570f

    inc d
    ld d, $08
    ld d, $08
    adc e
    inc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0102
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
    ld bc, $0300
    nop
    ld e, $01
    ld h, h
    dec de
    or [hl]

jr_005_570f:
    ld a, e
    cp $81
    ld a, l
    add e
    add h
    inc bc
    add h
    inc bc
    add e
    nop
    add d
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ld l, b
    ldh a, [$d4]
    jr c, jr_005_5756

    call c, Call_005_6d9e
    adc [hl]
    db $fd
    ei
    ld c, h
    ld l, e
    call c, Call_005_58b6
    jp z, $eb34

    inc d
    inc d
    db $eb
    nop
    nop
    nop
    nop
    nop
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
    ld [hl], b
    add b
    call z, $fcf0
    ld [$0cd2], sp
    ld a, [bc]
    inc b

jr_005_5756:
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    adc d
    inc b
    ld c, $01
    add hl, bc
    ld b, $11
    ld c, $0a
    inc b
    inc d
    ld [$0018], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add [hl]
    inc bc
    cp h
    inc bc
    dec l
    ld a, [de]
    ld d, e
    inc a
    ld a, [hl-]
    rlca
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
    xor h
    ld e, e
    ei
    inc b
    ccf
    inc d
    ld de, $970f
    inc c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c, d
    add l
    ld c, h
    add e
    add h
    inc bc
    add d
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ld b, b
    add b
    and b
    ld b, b
    ld b, b
    add b
    and b
    ld b, b
    ld h, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld [bc], a
    inc b
    inc bc
    ld a, [bc]
    dec b
    dec bc
    inc b
    dec b
    ld [bc], a
    ld [bc], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add [hl]
    inc bc
    cp h
    inc bc
    db $ed
    ld a, [de]
    ld d, e
    cp h
    cp d
    rlca
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
    ld c, l
    add d
    ld c, b
    add a
    adc d
    dec b
    sub [hl]
    add hl, bc
    dec c
    ld [bc], a
    ld [bc], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, b
    add b
    ret nz

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
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0205
    dec bc
    inc b
    dec bc
    inc b
    ld d, $08
    inc e
    nop
    inc h
    jr jr_005_58b9

    jr jr_005_58a9

    inc c

jr_005_5898:
    inc d
    ld [$000c], sp
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ld h, b
    ret nz

    pop de
    jr nz, jr_005_5898

jr_005_58a9:
    jr nc, jr_005_5921

    sbc c
    or h
    ld c, e
    cp $03
    ld c, [hl]
    ld sp, $033d
    inc b
    inc bc

Call_005_58b6:
    inc b
    inc bc
    inc bc

jr_005_58b9:
    nop
    ld [bc], a
    ld bc, $0000
    nop
    nop
    nop

jr_005_58c1:
    nop
    ld b, b
    nop
    cp b
    ld b, b
    ld h, h
    ld hl, sp-$29
    jr c, jr_005_58f5

    db $dd
    sbc [hl]
    ld l, l
    adc a
    db $fc
    ei
    ld c, h
    ld l, a
    ret c

jr_005_58d4:
    or [hl]
    ld e, b

jr_005_58d6:
    jp z, $f334

    inc c
    inc b
    ei
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_005_58e4

jr_005_58e4:
    inc [hl]
    jr jr_005_58c1

    inc h
    ld a, l
    jp nz, $89f6

    xor $11
    ei
    nop
    ld sp, $c1c0
    nop
    ld [bc], a

jr_005_58f5:
    ld bc, $0205
    add e
    nop
    ld b, d
    add c

jr_005_58fc:
    nop
    nop
    nop
    nop
    nop
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
    add b
    nop
    ld b, b
    add b
    ret nz

    nop
    jr nz, jr_005_58d4

    jr nz, jr_005_58d6

    ld b, b
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

jr_005_5921:
    nop
    rlca
    nop
    jr jr_005_592d

jr_005_5926:
    scf
    ld [$314e], sp
    sub c
    ld h, b
    ret nc

jr_005_592d:
    jr nz, jr_005_595f

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_593d:
    nop
    nop
    nop
    ret nz

    nop
    ld h, b
    ret nz

    ret nc

    jr nz, jr_005_5926

    jr nc, jr_005_58fc

    ld e, h
    or [hl]
    ld c, c
    ld [hl], h
    dec bc
    ld e, [hl]
    inc hl
    ld c, [hl]
    ld sp, $033d
    inc b
    inc bc
    inc b
    inc bc
    inc bc
    nop
    ld [bc], a
    ld bc, $0000
    nop

jr_005_595f:
    nop
    ld b, b
    nop
    and b
    ld b, b
    ret c

    ld h, b
    ld h, a
    ld hl, sp-$2c
    dec sp
    ld a, [hl+]
    db $dd
    sbc [hl]
    ld l, l
    adc a
    db $fc
    ei
    ld c, h
    ld l, a
    ret c

    or [hl]
    ld e, b
    jp z, $f334

    inc c
    inc b
    ei
    nop
    nop
    nop
    nop
    jr c, jr_005_5982

jr_005_5982:
    ld h, a
    jr c, jr_005_593d

    ld b, a
    cp a
    ret nz

    db $eb
    sub h
    call z, $f030
    nop
    and b
    ld b, b
    jr nz, @-$3e

    ret nz

    nop
    nop
    nop
    add b
    nop
    ld b, b
    add b
    ld b, b
    add b
    nop
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    ld h, b
    add b
    cp b
    ld b, b
    call nz, Call_000_2a38
    inc d
    ld l, $10
    jr z, jr_005_59c0

    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, $03
    inc a
    inc bc

jr_005_59c0:
    dec l
    ld a, [de]
    ld d, e
    inc a
    ld a, [hl-]
    rlca
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
    ld b, c
    add b
    add b
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add e
    nop
    db $fc
    inc bc

jr_005_5a22:
    add b
    ld a, a
    add b
    ld a, a
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ld b, b
    nop
    nop
    nop
    nop
    ccf
    nop
    ret nz

    ccf
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld e, $e1
    ld hl, $40de
    cp a
    ld b, h
    dec sp
    ld b, e
    inc a
    ld b, c
    ld a, $20
    rra
    jr nz, jr_005_5a77

    db $10
    rrca
    ld [$0007], sp
    nop
    ret nz

    nop
    jr nc, jr_005_5a22

    ld [$04f0], sp
    ld hl, sp+$02
    db $fc
    jp nz, $a1fc

    ld a, [hl]
    pop de
    ld a, $f1
    ld e, $41
    ld a, $a1
    ld a, [hl]
    ld b, d
    db $fc
    ld [bc], a

jr_005_5a77:
    db $fc
    inc b
    ld hl, sp+$08
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

jr_005_5a88:
    ld bc, $0200
    ld bc, $0304
    ld [$0807], sp
    rlca
    db $10
    rrca
    jr nz, jr_005_5ab5

    ld b, c
    ccf
    ld b, c
    ccf
    add d
    ld a, a
    nop
    nop
    nop
    nop
    nop
    nop
    rra
    nop
    ld h, b
    rra
    add b
    ld a, a
    nop
    rst $38
    ld b, $f9
    inc e
    di
    inc l
    di
    ld d, e
    ldh [$a0], a
    ret nz

    ret nz

jr_005_5ab5:
    add b
    ld b, b
    add b
    add b
    nop
    add b
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_5ac2:
    nop
    nop
    ret nz

    nop
    jr nz, jr_005_5a88

    db $10
    ldh [rNR10], a
    ldh [rNR10], a
    ldh [rNR41], a
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
    rlca
    nop
    ld [$0e07], sp
    ld bc, $030c
    ld [$0407], sp
    inc bc
    ld [bc], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nz, jr_005_5ac2

    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp-$74
    ld a, b
    adc d
    ld a, h
    add [hl]
    ld a, h
    add [hl]
    ld a, h
    add [hl]
    ld a, h
    add l
    ld a, [hl]
    add l
    ld a, [hl]
    add a
    ld a, [hl]
    add a
    ld a, [hl]
    inc bc
    nop
    inc c
    inc bc
    ldh a, [rIF]
    add b
    ld a, a
    add b
    ld a, a
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
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ld b, b
    nop
    nop
    inc bc
    cp $05
    cp $06
    db $fc
    ld a, [bc]
    db $fc
    inc d
    ld hl, sp+$18
    ldh a, [$28]
    ldh a, [rSVBK]
    ldh [$50], a
    ldh [$e0], a
    ret nz

    jr nz, @+$42

    ld b, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0102
    inc b
    inc bc
    jr jr_005_5b75

    ldh [$1f], a
    add b
    ld a, a
    add b
    ld a, a
    nop

jr_005_5b75:
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    add a
    ld a, [hl]
    add l
    ld a, [hl]
    add l
    ld a, [hl]
    ld b, $fc
    ld b, $fc
    ld c, $fc
    ld a, [bc]
    db $fc
    inc c
    ld hl, sp+$1c
    ld hl, sp+$14
    ld hl, sp+$18
    ldh a, [$38]
    ldh a, [$28]
    ldh a, [rSVBK]
    ldh [$50], a
    ldh [$e0], a
    ret nz

    nop
    rst $38
    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ld b, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ret nz

    ld b, b
    nop
    ld b, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_5bc8:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, $03
    dec b
    inc bc
    ld a, [bc]
    dec b

jr_005_5bec:
    rrca
    inc b
    ccf
    nop
    ld h, e
    inc a
    ld e, d
    inc a
    and e
    ld e, [hl]
    ld sp, hl
    ld b, [hl]
    ld a, d
    inc b
    inc a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nz, jr_005_5bc8

    and b
    ret nz

    jr nc, jr_005_5bec

    sub b
    ld h, b
    cp h
    ld b, b
    ld [c], a
    inc a
    ld e, d
    inc a
    and e
    ld e, [hl]
    ld sp, hl
    ld b, [hl]
    ld a, d
    inc b
    inc a
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
    dec bc
    ld b, $06
    nop
    ld bc, $0200
    ld bc, $0102
    inc b
    inc bc
    ld [$0807], sp
    rlca
    ld [$0407], sp

jr_005_5c39:
    inc bc
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
    jr nc, jr_005_5c46

jr_005_5c46:
    ld d, b
    jr nz, jr_005_5c39

    nop
    add b
    nop
    ld b, b
    add b
    ld b, b
    add b
    and b

jr_005_5c51:
    ret nz

    db $10
    ldh [rNR10], a
    ldh [$50], a
    ldh [$a0], a
    ret nz

    ret nz

    nop
    nop
    nop
    inc c
    nop
    ld [bc], a
    inc c
    rrca
    ld [bc], a
    inc bc
    nop
    ld bc, $0200
    ld bc, $0103
    ld [bc], a
    ld bc, $0007
    dec bc
    rlca
    add hl, bc
    rlca
    ld [$0707], sp
    nop

jr_005_5c78:
    ld bc, $0000
    nop
    nop
    nop
    ld [hl], b
    nop
    or b
    ld h, b
    ld d, b
    ldh [$60], a
    add b
    add b
    nop
    ret nz

    ld b, b
    ld h, b
    jr nz, @+$62

    jr nz, @+$42

    jr nz, jr_005_5c51

    nop
    ldh [rP1], a
    ldh a, [$60]
    jr nc, jr_005_5c78

    db $10
    ldh [$e0], a
    nop
    nop
    nop
    nop
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
    ld bc, $0304
    inc b
    inc bc
    ld [$0907], sp
    rlca
    ld a, [bc]
    dec b
    ld a, [bc]
    dec b
    rlca
    nop
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
    add b
    nop
    ld b, b
    add b
    and b
    ret nz

    ldh [$c0], a
    ld d, b
    ldh [$50], a
    ldh [$50], a
    ldh [$90], a
    ld h, b
    and b
    ld b, b
    ret nz

    nop

InvincibleMaskSprites::
    INCBIN "gfx/InvincibleMaskSprites.2bpp"

    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh a, [$f0]
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ldh [$e0], a
    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
    add b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca
    nop
    ld e, $07
    daa
    jr @+$5a

    jr nz, jr_005_5e3b

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_5df0:
    nop
    nop
    add c
    nop
    ld a, [hl]
    add c

jr_005_5df6:
    and $7f
    push bc
    ld a, $3f
    nop
    nop
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
    dec b
    inc bc
    dec bc
    rlca
    ld a, [bc]
    dec b
    dec bc
    inc b
    ld a, h
    inc bc
    ld [c], a
    ld a, l
    ld h, [hl]
    rst $38
    ld a, d
    add a
    add [hl]
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ld hl, sp+$40
    ld b, h
    cp b
    db $fc
    db $10
    ret nc

    nop
    jr nz, jr_005_5df0

    ldh [rP1], a
    ld b, b
    add b
    jr nz, jr_005_5df6

    ld h, b
    ret nz

    ldh [$c0], a
    ret nz

jr_005_5e3b:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_5e4b:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc a
    nop
    ld c, a
    inc a
    ld a, b
    rlca
    rlca
    nop
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
    ld bc, $0600
    ld bc, $0708

jr_005_5e74:
    inc a
    rrca

jr_005_5e76:
    srl h
    call z, $f0f0
    nop
    nop
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
    ld bc, $0305
    dec b
    ld [bc], a
    push af
    ld [bc], a
    call z, $cef3
    db $fd
    db $f4
    rrca
    add hl, de
    rlca
    dec b
    inc bc
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
    ld h, b
    nop
    db $fc
    jr nz, jr_005_5e4b

    call c, $88fe
    ld l, b
    add b
    sub b
    ld h, b
    ld [hl], b
    add b
    jr nz, jr_005_5e74

    jr nz, jr_005_5e76

    ret nz

    add b
    ret nz

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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jp $bc00


    ld b, e
    ld c, a
    inc a
    inc a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld e, $00
    ld l, l
    ld e, $8c
    ld a, a

jr_005_5ef4:
    db $fc
    jp $8063


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
    ld bc, $0200
    ld bc, $0102
    ld [bc], a
    ld bc, $0182
    ld h, d
    add c
    call c, $4ce3
    rst $38
    call $3e3e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc, jr_005_5f26

jr_005_5f26:
    cp $10
    ld d, c
    xor $ff
    call nz, $40b4
    ret z

    jr nc, jr_005_5f69

    ret nz

    jr nz, jr_005_5ef4

    ret nz

    add b
    ret nz

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
    nop
    nop
    nop

jr_005_5f4b:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc c
    inc bc
    rst $38
    inc c
    adc [hl]
    ld [hl], b
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
    nop
    nop
    nop
    nop

jr_005_5f69:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld hl, sp+$00
    rst $00
    ld hl, sp-$34
    rst $38
    db $f4
    rrca
    rrca
    nop
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
    ld bc, $0200
    ld bc, $0305
    dec b
    ld [bc], a
    dec b
    ld [bc], a
    inc b
    inc bc
    ld e, $01
    db $ec
    rra
    call z, $3cff
    jp $e3


    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, b
    nop
    db $fc
    jr nz, jr_005_5f4b

    call c, $88fe
    ld l, b
    add b
    sub b
    ld h, b
    ld [hl], b
    add b
    jr nz, @-$3e

    ldh [$c0], a
    ret nz

    add b
    ld b, b
    add b
    add b
    nop

FloaterSprites::
    INCBIN "gfx/FloaterSprites.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, b
    nop
    ret nc

    ld h, b
    ret c

    jr nz, @+$76

    ret c

    cp h
    ld l, b
    call c, Call_005_6c78
    jr jr_005_6131

    inc e
    nop
    nop
    nop
    nop
    nop
    nop
    rrca
    nop
    rrca
    dec b
    ld c, $05
    rla
    inc c
    ld c, $07
    dec bc
    dec b
    rrca
    ld b, $16
    inc c
    ld c, $04
    ld a, [bc]
    inc b
    ld d, $0c
    ld de, $110e
    ld c, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    add b
    nop
    nop
    nop
    add b
    nop
    add b
    nop
    nop
    nop
    nop

jr_005_6131:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld l, h
    nop
    sub $6c
    rst $38
    ld a, [bc]
    ei
    ld a, a
    xor $11
    ld a, a
    pop de
    cp a
    ld a, a
    ld a, a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld bc, $1e00
    ld bc, $1ee1
    and e
    rst $38
    push bc
    dec sp
    rst $38
    ld b, h
    cp $ff
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, [hl]
    nop
    sbc c
    ld h, [hl]
    db $76
    adc c
    xor $dd
    rst $18
    inc h
    cp a
    ret nz

    ld e, h
    cp a
    ccf
    db $fc
    ld l, d
    sbc l
    db $f4
    dec hl
    add b
    rst $38
    ret nz

    ccf
    rst $38
    nop
    nop
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
    ret nz

    nop
    jr nc, @-$3e

    adc b
    ld [hl], b
    ld c, b
    ldh a, [$a8]
    ld [hl], b
    cp h
    ld h, b
    ld e, h
    and b
    ld [hl], a
    adc b
    db $e3
    ld e, $91
    ld l, [hl]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    db $ed
    ld [de], a
    ld a, a
    pop de
    cp a
    ld a, a
    ld a, a
    nop
    nop
    nop
    dec de
    ld b, $05
    inc bc
    inc b
    inc bc
    inc bc
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc e
    nop
    ld [hl], a
    adc b
    rst $38
    ld b, h
    cp $ff
    rst $38
    nop
    nop
    nop
    add b
    nop
    ld b, b
    add b
    dec sp
    ret nz

    inc a
    jp Jump_005_72dd


    db $eb
    ld [hl], a
    ld b, a
    add hl, sp
    ld a, e
    inc e
    ld l, a
    ld e, $fc
    rrca
    rst $30
    ld [$01fe], sp
    db $fc
    inc hl
    add b
    rst $38
    ret nz

    ccf
    rst $38
    nop
    nop
    nop
    nop
    nop

jr_005_6220:
    nop
    nop
    add b
    nop
    ld b, b
    add b
    ret nz

    nop
    and b
    ld b, b
    or b
    ld b, b
    adc b
    ld [hl], b
    jr z, jr_005_6220

    xor b
    ld [hl], b
    cp h
    ld h, b
    ld e, h
    and b
    ld [hl], a
    adc b
    db $e3
    ld e, $91
    ld l, [hl]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc e
    nop
    ld [hl], a
    adc b
    rst $38
    ld b, h
    cp $ff
    rst $38
    nop
    nop
    nop
    add hl, bc
    ld b, $15
    ld c, $1e
    dec c
    ld de, $1a0f
    dec b
    dec a
    ld b, $37
    ld c, $3f
    ld c, $74
    rrca
    rst $30
    ld [$00ff], sp
    cp $01
    db $fc
    inc hl
    add b

jr_005_6277:
    rst $38
    ret nz

    ccf
    rst $38
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    and b
    ld b, b
    ret nc

    jr nz, jr_005_6277

    ret nz

    ldh a, [rLCDC]
    ret c

    jr nz, jr_005_6295

    ldh a, [$28]
    ldh a, [$a8]
    ld [hl], b
    cp h
    ld h, b
    ld e, h

jr_005_6295:
    and b
    ld [hl], a
    adc b
    db $e3
    ld e, $91
    ld l, [hl]
    nop
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
    dec b
    ld [bc], a
    ld a, [bc]
    rlca
    ld d, $0f
    inc d
    rrca
    add hl, hl
    ld d, $57
    jr c, jr_005_630e

    ld [hl], $aa
    ld [hl], a
    or a
    ld l, a
    sub [hl]
    ld l, a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $38
    nop
    ld a, b
    rst $38
    or c
    ld a, [hl]
    ld a, [hl]
    add c
    add c
    ld a, [hl]
    or c
    ld a, [hl]
    ld [hl], b
    rst $38
    ld [hl], b
    rst $38
    rst $38
    nop
    db $10
    rst $28
    ld d, $ef
    ld d, $ef
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    and b
    ld b, b
    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [$94]
    ld l, b
    ld [c], a
    inc e
    sub d
    ld l, h
    ld de, $09ee
    or $09
    or $01
    nop
    ld bc, $0100
    nop

jr_005_6302:
    rlca
    nop
    add hl, de
    ld b, $60
    rra
    add b
    ld a, a
    add e
    ld a, h
    adc l
    ld [hl], e

jr_005_630e:
    ld e, a
    cpl
    ld e, a
    inc l
    dec [hl]

jr_005_6313:
    rrca
    cpl
    rla
    dec de
    rlca
    ld d, $0b
    rrca
    inc bc
    inc [hl]
    jp Jump_005_738c


    ld h, e
    sbc h
    ld l, b
    or a
    ld e, [hl]
    cp c
    ccf
    ret nz

    ret nz

    ccf
    inc sp
    call z, $f3ed
    ei
    ccf
    cp a
    rst $18
    db $db
    db $ec
    db $fd
    di
    rst $38
    rst $38
    db $dd
    rst $38
    rst $28
    ldh a, [$80]
    nop
    ld b, b
    add b
    jr nz, jr_005_6302

    sub b
    ld h, b
    cpl
    ret nc

    call nz, $c03b
    ccf
    jr c, jr_005_6313

    ld [hl], a
    ld hl, sp-$02
    rst $38
    db $db
    rst $38
    ld a, a
    rst $38
    or a
    ld a, a
    db $76
    adc a
    rst $28
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
    rst $38
    nop
    ld bc, $67fe
    sbc d
    ld d, c
    xor [hl]
    adc $34
    cp d
    call z, $f8f4
    ld hl, sp-$20
    and b
    ret nz

    ret nz

    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld bc, $0700
    nop
    add hl, de
    ld b, $60
    rra
    add b
    ld a, a
    add e
    ld a, h
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_6393:
    nop
    nop
    nop
    nop

Jump_005_6397:
    nop
    nop
    nop
    nop
    nop
    inc [hl]
    jp Jump_005_738c


    ld h, e
    sbc h
    ld l, b
    or a
    ld e, [hl]
    cp c
    ccf
    ret nz

    ret nz

    ccf
    inc sp
    call z, LoadRomBank
    nop
    nop
    nop
    nop
    nop
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
    ld b, b
    add b
    jr nz, @-$3e

    sub b
    ld h, b
    cpl
    ret nc

    call nz, $c03b
    ccf
    jr c, jr_005_6393

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $38
    nop
    ld bc, $67fe
    sbc d
    ld d, c
    xor [hl]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $0304
    add hl, bc
    ld b, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_6422:
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0205
    ld a, [bc]
    dec b
    dec [hl]
    dec bc
    ld c, e
    scf
    xor a
    ld e, a
    ld c, a
    cp a
    cp l
    ld a, a
    ld a, h
    rst $38
    nop
    nop
    rrca
    inc bc
    ld a, [bc]
    rlca
    rla
    rrca
    ccf
    rrca
    ld h, a
    rra
    call c, $9e3f
    ld a, a
    ld a, a
    cp $71
    cp $fa
    db $fc
    cp h
    ld hl, sp-$38
    ldh a, [$d0]
    ldh [$a0], a
    ret nz

    ret nz

    nop
    nop
    nop
    or b
    ret nz

    ldh [$c0], a
    jr nz, jr_005_6422

    ret nz

    add b
    ld b, b
    add b
    add b
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
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0205
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca
    inc bc
    ld a, [bc]
    rlca
    rla
    rrca
    ccf
    rrca
    ld h, a
    rra
    call c, $9e3f
    ld a, a
    ld a, a
    cp $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_64bc:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc, jr_005_64d8

jr_005_64d8:
    ld a, c
    nop
    add $39
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_64f1:
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ld h, b
    add b
    jr nz, jr_005_64bc

    nop
    nop
    ld bc, $0100
    nop
    inc bc
    nop
    dec c
    ld [bc], a
    inc de
    inc c
    dec hl
    rla
    scf
    rrca
    ccf
    rrca
    dec l
    rra
    dec l
    ld e, $13
    inc c
    inc c
    inc bc
    ld b, $01
    ld bc, $0000
    nop
    add d
    ld a, l
    dec e
    ld [c], a
    ld l, [hl]
    sbc l
    cp a
    ld a, b
    ld a, l
    ld a, [$7887]
    dec sp
    rst $00
    rst $38
    rst $38
    rst $28
    rst $38
    jp nz, $f4ff

    dec bc
    ld h, e
    db $fc
    db $ed
    cp $ff
    rst $38
    db $76
    rst $38
    db $db
    inc a
    db $10
    ldh [$d0], a
    jr nz, jr_005_64f1

    ret nz

    ld d, b
    ldh [rIE], a
    nop
    add b
    ld a, a
    ld a, [hl]
    add c
    ld [hl], c
    cp $f6
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld l, a
    rst $38
    rst $08
    ccf
    cp a
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
    db $fc
    nop
    inc bc
    db $fc
    cpl
    ret nc

    or c
    ld c, [hl]
    cpl
    call c, $bc7a
    db $f4

jr_005_6571:
    ld hl, sp-$18
    ldh a, [$30]
    ret nz

    ret nz

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    inc bc
    nop
    dec c
    ld [bc], a
    inc de
    inc c
    dec hl
    rla
    scf
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
    add d
    ld a, l
    dec e
    ld [c], a
    ld l, [hl]
    sbc l
    cp a
    ld a, b
    ld a, l
    ld a, [$7887]
    dec sp
    rst $00
    rst $38
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    db $10
    ldh [$d0], a
    jr nz, jr_005_6571

    ret nz

    ld d, b
    ldh [rIE], a
    nop
    add b
    ld a, a
    ld a, [hl]
    add c
    ld [hl], c
    cp $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    db $fc
    nop
    inc bc
    db $fc
    cpl
    ret nc

    or c
    ld c, [hl]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
    inc bc
    ld a, [de]
    dec b
    inc h
    dec de
    ld c, e
    scf
    sub a
    ld l, a
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300
    nop
    ld b, $01
    dec e
    inc bc
    add hl, hl
    rla
    ld d, a
    cpl
    and a
    ld e, a
    ld e, a
    cp a
    cp e
    ld a, a
    db $fc
    rst $38
    db $fd
    cp $da
    db $fc
    call z, $00f0
    nop
    cp d
    ld a, h
    xor [hl]
    ld a, h
    ld [hl], d
    db $fc
    db $fc
    ld hl, sp+$74
    ld hl, sp-$38
    ldh a, [$e8]
    ldh a, [$f0]
    ldh [rNR10], a
    ldh [$a0], a
    ret nz

    ret nz

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
    ld bc, $0300
    nop
    ld b, $01
    dec e
    inc bc
    add hl, hl
    rla
    ld d, a
    cpl
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cp d
    ld a, h
    xor [hl]
    ld a, h
    ld [hl], d
    db $fc
    db $fc
    ld hl, sp+$74
    ld hl, sp-$38
    ldh a, [$e8]
    ldh a, [$f0]
    ldh [rP1], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    inc bc
    nop
    dec c
    ld [bc], a
    inc bc
    inc c
    dec bc
    rlca
    rlca
    rrca
    rrca
    rrca
    dec c
    rrca
    dec c
    ld c, $03
    inc c
    inc c
    inc bc
    ld b, $01
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300
    nop
    ld b, $01
    dec c
    inc bc
    add hl, bc
    rlca
    rlca
    rrca
    rlca
    rrca
    rrca
    rrca
    dec bc
    rrca
    inc c
    rrca
    dec c
    ld c, $0a
    inc c
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, b
    nop
    nop
    nop
    nop
    nop
    inc e
    nop
    ld [$1c00], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc a
    nop
    ld [$1000], sp
    nop
    inc a
    nop
    nop
    nop
    add b
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld e, $00
    inc b
    nop
    ld [$1e00], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    nop
    nop
    inc c
    nop
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca
    nop
    ld [bc], a
    nop
    inc b
    nop
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
    jr nc, jr_005_6742

jr_005_6742:
    jr nc, jr_005_6744

jr_005_6744:
    nop
    nop
    nop
    nop
    nop
    nop
    ld c, $00
    inc b
    nop
    ld c, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc a
    nop
    ld [$0000], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [hl], b
    nop
    jr nz, jr_005_6768

jr_005_6768:
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    inc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    jr nz, jr_005_6784

jr_005_6784:
    ld b, b
    nop
    ldh a, [rP1]
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc, jr_005_6790

jr_005_6790:
    jr nc, jr_005_6792

jr_005_6792:
    nop
    nop
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    ld a, b
    nop
    stop
    jr nz, jr_005_67a2

jr_005_67a2:
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
    jr nc, jr_005_67ae

jr_005_67ae:
    jr nc, jr_005_67b0

jr_005_67b0:
    nop
    nop
    nop
    nop
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    stop
    inc a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr c, jr_005_67ca

jr_005_67ca:
    stop
    jr c, jr_005_67ce

jr_005_67ce:
    nop
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
    nop
    nop
    nop
    nop
    nop
    ld bc, $1f00
    nop
    ld hl, $5e1e
    ld hl, $1f6e
    ld e, a
    ccf
    ld a, e
    ccf
    ld l, $19
    ld d, $0f
    dec bc
    rlca
    rlca
    ld bc, $0001
    ld bc, $0000
    nop
    nop
    nop
    ldh a, [rP1]
    dec c
    ldh a, [$df]
    jr nz, jr_005_6809

    ei
    inc bc
    db $fc
    adc h

jr_005_6809:
    ld [hl], e
    ld l, a
    sbc a
    sbc a
    rst $38
    db $ed
    sbc a
    push de
    ld l, a
    db $ed
    di
    ei
    db $fc
    db $fd
    cp $7d
    cp $ba
    ld a, h
    nop
    nop
    ldh [rP1], a
    db $10
    ldh [$7f], a
    add b
    nop
    rst $38
    rst $38
    nop
    rst $20
    rst $38
    rst $28
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    sbc $ff
    inc e
    rst $38
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cp $00
    ld c, $f0
    or d
    ld c, h
    ld a, [hl+]
    call c, $bcda
    cp h
    ld hl, sp+$74
    ld hl, sp-$18
    ldh a, [$d0]
    ldh [$60], a
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
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc b
    inc bc
    ld a, [de]
    dec b
    inc h
    dec de
    ld c, e
    scf
    sub a
    ld l, a
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300
    nop
    ld b, $01
    dec e
    inc bc
    add hl, hl
    rla
    ld d, a
    cpl
    and a
    ld e, a
    ld e, a
    cp a
    cp e
    ld a, a
    db $fc
    rst $38
    db $fd
    cp $da
    db $fc
    call z, $00f0
    nop
    nop
    nop
    xor [hl]
    ld a, h
    ld [hl], d
    db $fc
    db $fc
    ld hl, sp+$74
    ld hl, sp-$38
    ldh a, [$e8]
    ldh a, [$f0]
    ldh [rNR10], a
    ldh [$a0], a
    ret nz

    ret nz

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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0700
    nop
    inc c
    inc bc
    ccf
    rlca
    ld [hl], a
    rrca
    cp a
    ld e, a
    nop
    nop
    ld bc, $0300
    nop
    ld [bc], a
    ld bc, $0305
    rlca
    inc bc
    dec bc
    rlca
    rra
    rlca
    ld l, $17
    ld [hl], l
    rrca
    rst $08
    ccf
    ld a, a
    rst $38
    ld a, e
    rst $38

jr_005_68f6:
    db $e3
    rst $38
    ld e, $e1
    ld h, c
    add b
    sbc b
    ld h, b
    ld c, e
    ldh a, [$7d]
    sub d
    jp c, $ed35

    or e
    ld l, e
    or a
    rst $38
    ld h, a
    cp a
    ld h, a
    ld l, e
    or a
    ld a, h
    or e
    rst $30
    cp b
    jp c, $c9bd

    cp [hl]
    rst $18
    cp a
    cp a
    rst $18
    ld l, a
    rst $18
    ret nz

    nop
    jr nz, @-$3e

jr_005_6920:
    and b
    ld b, b
    ld h, b
    add b
    ldh [$80], a
    ld h, b
    add b
    ret nz

    nop
    ld b, b
    add b
    ld b, b
    add b
    ret nz

    nop
    ret nz

    nop
    ld b, b
    add b
    jr nz, jr_005_68f6

jr_005_6936:
    ld d, b
    and b
    xor b
    ret nc

    sbc h
    ldh [$98], a
    ld h, b
    ld c, e
    ldh a, [$7d]
    sub d
    db $db
    inc [hl]
    xor $b1
    ld l, h
    or e
    ld hl, sp+$67
    cp b
    ld h, a
    ld l, h
    or e
    ld a, a
    or b
    rst $30
    cp b
    jp c, $c9bd

    cp [hl]
    rst $18
    cp a
    cp a
    rst $18
    ld l, a
    rst $18
    ret nz

    nop
    jr nz, jr_005_6920

jr_005_6960:
    and b
    ld b, b
    ldh [rP1], a
    ld h, b
    add b
    ldh [rP1], a
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ld b, b
    add b
    jr nz, jr_005_6936

jr_005_6976:
    ld d, b
    and b
    xor b
    ret nc

    sbc h
    ldh [$98], a
    ld h, b
    ld c, e
    ldh a, [$7d]
    sub d
    db $db
    inc [hl]
    rst $28
    or b
    ld l, a
    or b
    rst $38
    ld h, b
    cp a
    ld h, b
    ld l, a
    or b
    ld a, a
    or b
    rst $30
    cp b
    jp c, $c9bd

    cp [hl]
    rst $18
    cp a
    cp a
    rst $18
    ld l, a
    rst $18
    ret nz

    nop
    jr nz, jr_005_6960

    and b
    ld b, b
    ldh [rP1], a
    ldh [rP1], a
    ldh [rP1], a
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    ld b, b
    add b
    jr nz, jr_005_6976

    ld d, b
    and b
    xor b
    ret nc

    sbc h
    ldh [rSB], a
    nop
    ld [bc], a
    ld bc, $0205
    ld a, [bc]
    dec b
    ld [de], a
    dec c
    dec h
    dec de
    dec hl
    rla
    ld c, c
    scf
    ld d, a
    cpl
    sbc a
    ld l, a
    xor a
    ld e, a
    and [hl]
    ld e, a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld e, h
    cp a
    sbc l
    ld a, [hl]
    ld [hl], d
    db $fc
    db $f4
    ld hl, sp+$68
    ldh a, [$d0]
    ldh [$d0], a
    ldh [$e0], a
    ret nz

    and b
    ret nz

    ld b, b
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
    nop
    nop
    nop
    nop
    nop
    nop
    and e
    ld e, a
    ld d, l
    cpl
    dec sp
    rlca
    dec c
    inc bc
    ld b, $01
    inc bc
    nop
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
    xor $f0
    rst $30
    ld hl, sp-$0d
    db $fc
    db $dd
    cp $7e
    rst $38
    cp c
    ld a, [hl]
    cp $00
    and b
    ld b, b
    ld h, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

BonusSprites::
    INCBIN "gfx/BonusSprites.2bpp"

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
    jp Jump_000_3c3c


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
    jp z, Jump_000_3437

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
    jp z, Jump_000_3437

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
    call nz, RST_38
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
    call nz, Call_000_3c03
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

    inc bc
    nop
    inc c
    inc bc
    jr jr_005_72a9

    ld [hl], $19
    ld a, $17
    or $0d
    dec hl

jr_005_72a9:
    sub $2f
    rst $10
    ei
    rlca
    dec l
    ld [de], a
    inc de
    inc c
    dec bc
    rlca
    dec bc
    rlca
    dec bc
    rlca
    add hl, bc
    rlca
    db $10
    rrca
    add b
    nop
    ld [hl], b
    add b
    ld [$78f0], sp
    add b
    ld hl, sp-$30
    rst $18
    ld h, b
    xor b
    rst $10
    jp hl


    sub $be
    ret nz

    ld l, b
    sub b
    sub b
    ld h, b
    and b
    ret nz

    and b
    ret nz

    cp h
    ret nz

    ld b, $fc
    ld a, [bc]
    db $f4
    nop

Jump_005_72dd:
    nop
    nop

jr_005_72df:
    nop
    nop
    nop
    nop
    nop
    ldh [rP1], a
    ld d, b
    ldh [$50], a
    and b
    ret z

    jr nc, jr_005_7315

    db $10
    jr z, jr_005_7300

    inc d
    ld [$0834], sp
    ld b, h
    jr c, jr_005_72df

    db $10
    sbc b
    ld [hl], b
    ldh a, [rP1]
    nop
    nop
    nop
    nop

jr_005_7300:
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    ld b, $03
    add hl, bc
    ld b, $12
    inc c
    inc d
    ld [$1028], sp
    ld d, b
    jr nz, @-$6e

jr_005_7315:
    ld h, b
    ret nc

    ld h, b
    or b
    ld b, b
    and b
    ld b, b
    nop
    nop
    inc bc
    nop
    ld b, $01
    dec c
    ld b, $0f
    dec b
    call $3a03
    push bc
    adc e
    ld [hl], l
    ld l, [hl]
    ld de, $041b
    inc b
    inc bc
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0102
    inc b
    inc bc

jr_005_733c:
    ldh [rP1], a
    inc e
    ldh [rSC], a
    db $fc
    sbc [hl]
    ld h, b
    cp [hl]
    db $f4
    or [hl]
    ld e, b
    db $eb
    or h
    ld a, [$eef5]
    pop af
    ld e, e
    and h
    rst $20
    jr jr_005_733c

    rst $30
    ldh [rIE], a

jr_005_7356:
    db $e4
    ei
    ld c, h
    di
    dec [hl]
    jp nz, LoadRomBank

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, b
    nop
    adc h
    ld a, b
    ld [hl-], a
    call z, Call_000_06c9
    dec b
    ld [bc], a
    ld [bc], a
    ld bc, $0081
    add c
    nop
    add c
    nop
    add c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

Jump_005_738c:
    nop
    nop
    nop
    nop
    add b
    nop
    ld b, b
    add b
    jr nz, jr_005_7356

    ld h, b
    ret nz

    and b
    ld b, b
    and b
    ld b, b
    nop
    nop
    nop
    nop

jr_005_73a0:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca
    nop
    inc d
    rrca
    inc de
    inc c
    inc d
    ld [$0814], sp
    inc d
    ld [$1028], sp
    ld l, b
    db $10
    ret z

    ld [hl], b
    sub b
    ld h, b
    ld bc, $0600
    ld bc, $030c
    dec de

jr_005_73c3:
    inc c
    rra
    dec bc
    dec de
    ld b, $f5
    dec bc
    rla
    db $eb
    sbc l
    ld h, e
    db $76
    add hl, bc
    add hl, bc
    ld b, $05
    inc bc
    dec b
    inc bc
    dec b
    inc bc
    inc c
    inc bc
    jr nc, jr_005_73eb

    ret nz

    nop
    jr c, jr_005_73a0

    inc b
    ld hl, sp+$3c
    ret nz

    ld a, h
    add sp, $6c
    or b
    rst $10
    ld l, b
    db $f4

jr_005_73eb:
    db $eb
    call c, $b7e3
    ld c, b
    ret z

    jr nc, jr_005_73c3

    ldh [$d0], a
    ldh [$d8], a
    ldh [$86], a
    ld hl, sp+$03
    cp $00
    nop
    nop
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
    inc d
    ld hl, sp-$1c
    jr jr_005_7423

    ld [$0814], sp
    inc d
    ld [$040a], sp
    dec bc
    inc b
    add hl, bc
    rlca
    inc b
    inc bc
    ld de, $320e
    inc e
    inc h
    jr jr_005_7437

jr_005_7423:
    ld [$0c12], sp
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    ld a, c
    ld b, $a3
    ld a, [hl]
    cp $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7437:
    nop
    nop
    nop
    nop
    nop
    call nz, $2638
    inc e
    ld [de], a
    inc c
    inc d
    ld [$1824], sp
    jr z, jr_005_7458

    ld c, h
    jr nc, @+$65

    inc a
    ld a, $03
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

jr_005_7458:
    nop
    nop
    nop
    nop
    ld de, $220e
    inc e
    ld h, h
    jr c, jr_005_74ab

    jr nc, jr_005_748d

    db $10
    inc h
    jr jr_005_747d

    ld [$0814], sp
    inc d
    ld [$0c32], sp
    add $3c
    ld a, h
    ret nz

    ret nz

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, [c]

jr_005_747d:
    inc c
    ld [de], a
    inc c
    inc d
    ld [$1824], sp
    jr z, jr_005_7496

    ld c, h
    jr nc, jr_005_74ec

    inc a
    ld a, $03
    inc bc

jr_005_748d:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7496:
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    inc bc
    ld [$1907], sp
    ld c, $12
    inc c
    ld [de], a
    inc c
    ld [de], a
    inc c
    ld a, [bc]
    inc b
    ld a, [bc]

jr_005_74ab:
    inc b
    add hl, bc
    ld b, $0b
    ld b, $12
    inc c
    inc a
    db $10
    ld d, b
    jr nz, jr_005_7517

    nop
    nop
    nop
    nop
    nop
    ld b, l
    add d
    add l
    ld [bc], a
    add hl, bc
    ld b, $0c
    rlca
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

jr_005_74dd:
    nop
    nop
    nop
    ldh [rP1], a
    ld d, b
    ldh [$d0], a
    jr nz, jr_005_7507

    nop
    nop
    nop
    nop
    nop

jr_005_74ec:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, b
    ret nz

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7507:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7517:
    nop
    nop
    nop
    nop
    nop
    ld h, c
    ld a, $4e
    jr nc, jr_005_7569

    jr nc, jr_005_754b

    db $10
    jr z, jr_005_7536

    inc h
    jr jr_005_754f

    inc e
    ld c, h
    jr nc, jr_005_74dd

    ld h, b
    and b
    ld b, b
    ret nz

    nop
    nop
    nop
    nop
    nop

jr_005_7536:
    nop
    nop
    nop
    nop
    nop
    nop
    ld sp, hl
    ld b, $09
    ld b, $0a
    inc b
    ld a, [bc]
    inc b
    dec bc
    inc b
    ld a, [bc]
    dec b
    db $10
    rrca
    dec de

jr_005_754b:
    inc c
    inc c
    nop
    nop

jr_005_754f:
    nop
    nop
    nop
    nop
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
    ld bc, $0001
    nop
    nop
    nop
    nop
    ret nz

    nop
    and b
    ret nz

    ret nz

jr_005_7569:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7580:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0e00
    ld bc, $0f14
    inc de
    inc c
    inc d
    ld [$0814], sp
    jr z, @+$12

    jr z, jr_005_75aa

    ld e, b
    jr nz, jr_005_759e

    nop

jr_005_759e:
    ld b, $01
    inc c
    inc bc
    dec de

jr_005_75a3:
    inc c
    rra
    dec bc
    dec de
    ld b, $15
    dec bc

jr_005_75aa:
    rst $30
    dec bc
    dec e
    db $e3

jr_005_75ae:
    ld b, $f9
    ld sp, hl
    ld b, $05
    inc bc
    dec b
    inc bc
    dec b
    inc bc
    inc a
    inc bc
    ld h, b
    ccf
    ret nz

    nop
    jr c, jr_005_7580

    inc b
    ld hl, sp+$3c
    ret nz

    ld a, h
    add sp, $6c

jr_005_75c7:
    or b
    call nc, $f768
    add sp, -$24
    db $e3
    or b
    ld c, a
    rst $08
    jr nc, jr_005_75a3

    ldh [$d0], a
    ldh [$d0], a
    ldh [$90], a
    ldh [$08], a
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
    ret nz

    nop
    jr c, jr_005_75ae

    inc d
    ld hl, sp-$1c
    jr jr_005_7607

    ld [$0814], sp
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    dec c
    ld [bc], a
    nop
    nop
    nop
    nop

jr_005_7600:
    ld b, $00
    dec c
    ld b, $10
    rrca
    inc de

jr_005_7607:
    inc c
    inc h
    jr jr_005_7633

    db $10
    ld d, b
    jr nz, jr_005_75c7

    ld b, b
    ret z

    ld [hl], b
    ld d, b
    jr nz, jr_005_7665

    jr nz, jr_005_7647

    nop
    nop
    nop
    nop
    nop
    ld bc, $0600
    ld bc, $030c
    sbc e

jr_005_7623:
    inc c
    ld a, a
    adc e
    dec de
    and $95
    ld l, e
    ld [hl], a
    dec bc
    dec e
    inc bc
    ld c, $01
    add hl, bc
    ld b, $05

jr_005_7633:
    inc bc
    dec b
    inc bc
    dec a
    inc bc
    ld h, b
    ccf
    ld c, b
    scf
    ret nz

    nop
    jr c, jr_005_7600

    inc b
    ld hl, sp+$3c
    ret nz

    ld a, a
    add sp, $6c

jr_005_7647:
    or e
    call nc, $f76b
    add sp, -$24
    ldh [$b8], a
    ld b, b
    ret z

    jr nc, jr_005_7623

    ldh [$d0], a
    ldh [$d0], a
    ldh [$88], a
    ldh a, [rDIV]
    ld hl, sp+$00
    nop
    nop
    nop
    jr nc, jr_005_7662

jr_005_7662:
    ret c

    jr nc, jr_005_7669

jr_005_7665:
    ld hl, sp+$64
    sbc b
    sub d

jr_005_7669:
    inc c
    ld a, [bc]
    inc b
    dec b
    ld [bc], a
    ld c, $01
    add hl, bc
    rlca
    dec b
    ld [bc], a
    dec b

jr_005_7675:
    ld [bc], a
    ld b, $00
    nop
    nop
    nop
    nop
    sub b
    ld h, b
    ret nc

    ld h, b
    or b
    ld b, b
    and b
    ld b, b
    ld b, e
    nop
    dec b
    inc bc
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
    nop
    nop
    nop
    ld c, c
    ld [hl], $4e
    jr nc, jr_005_76f1

    jr nz, jr_005_76f3

    jr nz, jr_005_7675

    jr nz, jr_005_76f7

    and b
    ld [$d8f0], sp
    jr nc, jr_005_76dd

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call nz, $2638
    inc e
    ld [de], a
    inc c
    ld [de], a
    inc c
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    dec bc
    inc b
    db $10
    rrca
    add hl, de
    ld c, $0e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_76d7:
    nop
    nop
    nop
    nop
    nop
    inc b

jr_005_76dd:
    inc bc
    dec b
    inc bc
    ld b, $01
    ld [bc], a
    ld bc, $0001
    ldh [rP1], a
    and b
    ret nz

    ld b, b
    add b
    add b
    nop
    nop
    nop
    nop

jr_005_76f1:
    nop
    nop

jr_005_76f3:
    nop
    nop
    nop
    nop

jr_005_76f7:
    nop
    nop
    nop
    nop
    nop
    ld c, a
    jr nc, @+$26

    jr @+$26

    jr jr_005_76d7

    ld [$c874], sp
    add d
    ld a, h
    ld h, [hl]
    inc e
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
    and $1c
    ld [de], a
    inc c
    inc d
    ld [$1824], sp
    jr z, jr_005_7736

    ld c, a
    jr nc, jr_005_778b

    ccf
    ccf
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7736:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $0205
    dec bc
    rlca
    rra
    ld bc, $122f
    dec sp
    ld e, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_005_776e

jr_005_776e:
    sub h
    ld [$0894], sp
    jp nc, $ca8c

    add h
    ld l, c
    add $bd
    ld [c], a
    db $fd
    sbc [hl]
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc b
    inc bc
    ld a, $07
    ld l, a
    rla

jr_005_778a:
    rst $30

jr_005_778b:
    cpl
    db $f4
    ld l, a
    adc $77
    adc a
    ld [hl], a
    di
    rrca
    rrca

jr_005_7795:
    rlca
    rst $00
    inc bc
    inc a
    jp $f4cb


    rra
    nop
    ld a, b
    rlca
    rst $38
    ld h, d
    xor a
    ld a, e
    cp h
    ld e, e
    cp a
    ld h, a
    rst $20
    db $fd
    rst $30
    ld sp, hl
    rst $18

jr_005_77ad:
    db $fd
    adc a
    cp $dd
    cp $bc
    ei
    jr c, jr_005_77ad

    add [hl]
    ld sp, hl
    ld bc, $6ffe
    sub b
    ret nz

    nop
    ld b, b
    add b
    ld b, b
    add b
    sbc h
    nop
    or h
    ld [$10ac], sp
    xor b
    db $10
    ret z

    jr nc, jr_005_7795

    or b
    ret nc

    ldh [$a0], a
    ret nz

    ldh [rP1], a
    ld b, b
    add b
    ret nz

    nop
    add b
    nop
    nop
    nop
    rlca
    nop
    dec bc
    rlca
    ld d, $0f
    add hl, de
    ld b, $86
    ld bc, $8147
    and l
    jp Jump_005_6397


    rst $10
    inc hl
    bit 6, a
    adc c
    ld [hl], a
    ld l, h
    inc de
    add [hl]
    ld a, c
    ld c, c
    jr nc, jr_005_778a

    ld h, b
    ld h, a
    add b
    add b
    nop
    ld a, b
    add b
    rst $10
    jr c, jr_005_7875

    db $fd
    db $fd
    ei
    sbc e
    cp $9f
    cp $fd
    rst $38
    db $e4
    rst $38
    dec h
    cp $3e
    rst $38
    ld a, a
    cp $1b
    push hl
    inc hl
    db $dd
    sub c
    ld l, [hl]

jr_005_781a:
    pop hl
    ld e, $00
    nop
    nop
    nop
    ret nz

    nop
    and b
    ret nz

    ldh a, [$80]
    ld l, b
    sub b
    db $f4
    ret c

    ld a, [$de34]
    ld hl, sp-$48
    ld h, b
    ldh [rLCDC], a
    rst $08
    add b
    pop af
    adc [hl]
    add $b8
    jr jr_005_781a

    ldh [rP1], a
    ld bc, $0100
    nop
    inc bc
    nop
    rlca
    nop
    inc b
    inc bc
    ld c, $01
    ld a, b
    rlca
    pop bc
    ld a, $7f
    nop
    nop
    nop
    inc c
    nop
    inc de
    inc c
    add hl, de
    ld c, $18
    rlca
    dec c
    ld [bc], a
    rlca
    nop
    xor a
    ret nz

    xor e
    rst $00
    ld c, c
    add a
    ld c, c
    add [hl]
    sub $09
    ld [hl], a
    sbc a
    cp [hl]
    ld a, a
    cp h
    ld a, a
    cpl
    rst $38
    add l
    ld a, a
    sbc b
    ld a, a
    dec e
    rst $38
    sbc a

jr_005_7875:
    ld l, a
    xor a
    ld d, a
    and e
    ld e, [hl]
    rst $00
    add hl, sp
    add b
    nop
    ret nz

    nop
    ldh [$80], a
    and b
    ld b, b
    ld h, b
    add b
    ldh a, [$e0]
    add sp, -$10
    ret z

    ldh a, [$fc]
    ret nz

    add $fc
    cp $ec
    or a
    ret c

    ccf
    ret c

    db $fd
    ld h, d
    db $ed
    ld a, $ed
    ld a, [$0001]
    nop
    nop

jr_005_78a0:
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0306
    inc b
    inc bc
    inc b
    inc bc
    dec b
    ld [bc], a
    inc bc
    nop
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    ld bc, $5700
    add b
    xor e
    ld d, [hl]
    adc b
    ld [hl], a
    ld b, c
    ld a, $2e
    db $10
    sbc c
    ld b, $93
    rrca
    rst $20
    rra
    pop bc
    ccf
    adc c
    ld a, a
    xor a
    ld e, a
    ld e, h
    xor a
    inc e
    rst $28
    rrca
    rst $38
    inc a
    rst $08
    ld a, [$d035]
    ld h, b
    jr nz, jr_005_78a0

    ld b, b
    add b
    adc h
    nop
    ld a, [bc]
    inc b
    push af
    ld c, $b7
    adc $eb
    or $f5
    ld a, [$f89e]
    sbc d
    db $fc
    cp $fc
    ld a, [c]
    db $fc
    call nc, Call_005_6ce8
    ldh a, [$f4]
    sbc b
    cpl
    add hl, de
    ld [hl], $0f
    dec hl
    rla
    ld c, a
    ccf
    ld a, a
    ccf
    ld e, c
    ccf
    ld a, c
    rra
    xor a
    ld e, a

jr_005_790c:
    rst $10
    ld l, a

jr_005_790e:
    db $ed
    ld [hl], e
    xor a
    ld [hl], b
    ld d, b
    jr nz, jr_005_7946

    nop
    ld [bc], a
    ld bc, $0304
    dec bc

jr_005_791b:
    ld b, $5f
    xor h
    inc a
    di
    ldh a, [rIE]
    jr c, jr_005_791b

    ld a, [hl-]
    push af
    push af
    ld a, [$fe91]
    add e
    db $fc
    rst $20
    ld hl, sp-$37
    ldh a, [$99]
    ld h, b
    ld [hl], h
    ld [$7c82], sp
    ld de, $d5ee
    ld l, d
    ld [$8001], a
    nop
    add b
    nop
    add b
    nop
    add b
    nop
    add b
    nop

jr_005_7946:
    ret nz

    nop
    and b
    ld b, b
    jr nz, jr_005_790c

    jr nz, jr_005_790e

    ld h, b
    ret nz

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
    add b
    nop
    pop af
    ld c, $34
    dec bc
    inc e
    inc bc
    ld b, $01
    ld [bc], a
    ld bc, $0102
    inc bc
    nop
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
    sbc e
    inc b
    sub c
    ld c, $a3
    inc e
    xor [hl]
    jr @-$62

    nop
    add b
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
    adc b
    rlca
    ld b, $03
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, a
    add b
    jr nz, @-$3e

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
    ld l, a
    rla
    dec sp
    ld b, $0c
    inc bc
    ld [bc], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld sp, hl
    ld b, $87
    nop
    ld [hl], b
    add b
    jr @-$1e

    add sp, $10
    jr c, jr_005_7a08

jr_005_7a08:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cp a
    ld a, c
    cp l
    ld b, a
    sub [hl]
    ld h, e
    ld d, e
    ld hl, $314b
    add hl, hl
    db $10
    add hl, hl
    db $10
    jr jr_005_7a2c

jr_005_7a2c:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    call c, $f478
    ld c, b
    ld hl, sp-$80
    ret nc

    ldh [$a0], a
    ld b, b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
    inc bc
    ld [$1007], sp
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
    rra
    nop
    ldh [$1f], a
    ld b, $ff
    dec bc
    db $fc
    rrca
    ld hl, sp+$06
    ld sp, hl
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    inc a
    ret nz

    ld a, [de]
    db $e4
    add [hl]
    ld a, b
    ld b, d
    db $fc
    add d
    db $fc
    nop
    nop
    ld bc, $0700
    ld bc, $060b
    dec bc
    dec b
    dec bc
    dec b
    dec bc
    inc b
    db $10
    rrca
    jr nc, jr_005_7aed

    jr c, jr_005_7aef

    inc d
    rrca
    inc l
    rra
    jr z, jr_005_7af5

jr_005_7ad6:
    ld e, b
    ccf
    ld d, b
    ccf
    add b
    ld a, a
    db $10
    rrca
    and b
    rra
    ld b, b
    cp a
    add b
    ld a, a
    pop bc
    ccf
    jp nz, $88bf

    ld [hl], a
    rra
    ldh [$2f], a

jr_005_7aed:
    ldh a, [$5f]

jr_005_7aef:
    or b
    ccf
    ret nc

    daa
    ret c

    inc e

jr_005_7af5:
    db $eb
    ld e, $e9
    ld [de], a
    db $ed
    ld c, $f5
    ld a, [bc]
    db $fd
    jr @+$01

    inc a
    rst $38
    ld [hl], b
    rst $38
    add e
    db $fc
    rra
    ldh [$f8], a
    nop
    ldh a, [rP1]
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    jr c, jr_005_7ad6

    ret c

    ldh [$e8], a
    ldh a, [$e8]
    ldh a, [rSB]
    cp $01
    cp $07
    ld hl, sp+$7e
    add b
    sub h
    ld l, b
    or h
    ld l, b
    or h
    ld l, b
    cp b
    ld h, b
    ld h, b
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
    xor b
    ld d, b
    add sp, $50
    nop
    nop
    nop
    nop
    ld bc, $0700
    ld bc, $060d
    rrca
    dec b
    inc sp
    dec c
    ld [hl], c
    ld a, $60
    ccf
    jr nc, jr_005_7b5f

    inc d
    rrca
    inc l
    rra
    jr z, jr_005_7b75

    ld e, b
    ccf
    ld d, b
    ccf
    add b
    ld a, a
    nop
    nop
    nop

jr_005_7b5f:
    nop
    ei
    nop
    cp h
    db $d3
    pop bc
    ccf
    jp nz, $c0bf

    ccf
    sub a
    ld l, a
    ld sp, $4cef
    or e
    daa
    ret c

    rlca
    db $fc
    dec bc

jr_005_7b75:
    or $05
    ei
    ld [bc], a
    db $fd
    ld bc, $1ffe
    nop
    ld hl, sp+$1f
    inc a
    rst $38
    ld [hl], c
    cp $83
    db $fc

jr_005_7b86:
    ld [bc], a
    db $fd
    add hl, bc
    rst $38
    ret z

    rst $38
    db $fc
    rst $38
    ccf
    rst $38
    ret nz

    ccf
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    ld c, a
    or b
    daa
    ret c

    ldh a, [rP1]
    ld c, $f0
    dec b
    ld a, [$3cc3]
    and c
    ld a, [hl]
    pop bc
    cp $01
    cp $01
    cp $02
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp-$08
    nop
    jr z, jr_005_7b86

    ld l, b
    ret nc

    ld l, b
    ret nc

    ld hl, sp+$00
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0205
    ccf
    ld bc, $3d73
    ld h, c
    ld a, $30
    rrca
    db $10
    rrca
    inc d
    rrca
    inc l
    rra
    jr z, @+$21

    ld e, b
    ccf
    ld d, b
    ccf
    add b
    ld a, a
    nop
    nop
    nop
    nop
    db $fc
    nop
    ei
    db $ec

jr_005_7be4:
    call z, $c033
    cp a
    ret nz

    ccf
    add b
    ld a, a
    nop
    rst $38
    ld b, e
    cp a
    cp h
    jp $fc63


    ld a, $cf
    rlca
    ld sp, hl
    ld bc, $00fe
    rst $38
    nop
    nop
    nop
    nop
    ccf
    nop
    ret nz

    ccf
    nop
    rst $38
    nop
    rst $38
    ld c, $f1
    dec e
    db $e3
    ld d, [hl]
    rst $28
    ret z

    rst $38
    ret nz

    rst $38
    ld h, b
    rst $38
    sbc b
    ld a, a
    ld h, b
    sbc a
    rra
    ldh [$c0], a
    ccf
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nc, jr_005_7be4

    ld [$06f0], sp
    ld hl, sp+$05
    ld a, [$fc03]
    inc bc
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp-$04
    nop
    ld [$00f0], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $38
    nop
    ld hl, $171e
    rrca
    rla
    rrca
    daa
    rra
    ld a, b
    rlca
    rla
    rrca
    rla
    rrca
    jr c, jr_005_7c63

    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7c63:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ld c, $f0
    ld sp, hl
    cp $fe
    rst $38
    ld bc, $fefe
    rst $38
    add c
    cp $7e
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld h, h
    add b
    db $f4
    nop
    ld a, b
    add b
    ret nc

    jr nz, @-$5e

    ld b, b
    ld [hl], a
    rrca
    rla
    rrca
    dec bc
    rlca
    dec b
    inc bc

jr_005_7ca4:
    dec b
    inc bc
    inc bc
    nop
    ld bc, $1e00
    ld bc, $1f60
    db $fc
    inc bc
    ld b, e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    db $fd
    cp $fa
    db $fd
    push af
    ld a, [$faf5]
    push af
    ld a, [$fa75]
    ret


    ld [hl], $09
    or $00
    rst $38
    nop
    rst $38
    ret nz

    ccf
    ccf
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
    add b
    add b
    nop
    ret nz

    nop
    jr nz, jr_005_7ca4

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
    nop
    nop
    nop
    nop
    nop
    rst $38
    nop
    jr nz, jr_005_7d1f

    cpl
    rra
    ld a, b
    rlca
    rla
    rrca
    jr c, jr_005_7d0f

    ld [hl], c
    rrca
    ld e, $01
    ld h, b
    rra
    db $fc

jr_005_7d0f:
    inc bc
    ld b, e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    rrca

jr_005_7d1f:
    ldh a, [$f9]
    cp $07
    ld hl, sp-$03
    cp $7f
    cp $fe
    ld sp, hl
    add hl, bc
    or $00
    rst $38
    nop
    rst $38
    ret nz

    ccf
    ccf
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    ldh [rP1], a
    call nc, Call_000_3c20
    ret nz

    ld sp, hl
    db $10
    ccf
    ret c

    ld bc, $07fe
    ld hl, sp+$18
    ldh [$e0], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7d62:
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
    rst $38
    nop
    jr nz, jr_005_7d8f

    ld a, a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld bc, $7f00
    nop
    add h
    ld a, e
    ld a, $c1
    ld bc, $fffe
    nop
    nop

jr_005_7d8f:
    rst $38
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nz, jr_005_7d62

    and b
    ret nz

    sub b
    ldh [$39], a
    ret nc

    cp a
    ld e, b
    ld b, c
    cp [hl]
    rst $20
    jr jr_005_7e27

    add b
    add sp, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7dc0:
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc e
    inc bc
    ld h, e
    inc e
    db $fc
    inc bc
    ld b, h
    inc bc
    ld [$1007], sp
    rrca
    ld [hl], b
    rrca
    ccf
    nop
    db $10
    rrca
    db $10
    rrca
    ld a, a
    nop
    ld bc, $0100
    nop
    ld bc, $7f00
    nop
    adc b
    ld [hl], a
    ld [$05f7], sp
    ld a, [$fa05]
    dec b
    ld a, [$fa05]
    ld [bc], a
    db $fd
    ld bc, $80fe
    ld a, a
    ld a, a
    add b
    nop
    rst $38
    rst $38
    nop
    ret nz

    nop
    jr nz, jr_005_7dc0

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
    add b
    nop
    ld b, b
    add b
    and b
    ld b, b
    ret nc

    jr nz, jr_005_7e91

    add b
    db $f4
    nop
    nop
    nop
    nop
    nop

jr_005_7e20:
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc e

jr_005_7e27:
    inc bc
    ld h, b
    rra
    ldh a, [rIF]
    ld a, a
    nop
    db $10
    rrca
    db $10
    rrca
    ld a, a
    nop
    jr nz, jr_005_7e55

    db $10
    rrca
    db $10
    rrca
    ld a, a
    nop
    ld bc, $0100
    nop
    ld bc, $7f00
    nop
    adc b
    ld [hl], a
    add hl, bc
    or $04
    ei
    inc bc
    db $fc
    add b
    ld a, a
    ld a, a
    add b
    nop
    rst $38
    rst $38
    nop
    nop

jr_005_7e55:
    rst $38
    ld bc, $1efe
    ldh [$e0], a
    nop
    ret nz

    nop
    jr nz, jr_005_7e20

    and b
    ret nz

    sub b
    ldh [$39], a
    ret nc

    ccf
    ret c

    add c
    ld a, [hl]
    ld b, a
    cp b
    cp b
    ld b, b
    ret nc

    jr nz, @+$7a

    add b
    db $f4
    nop
    ld h, h
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
    rra
    nop
    ld [hl], b
    rrca
    ccf
    nop
    db $10
    rrca
    db $10
    rrca
    ld a, a
    nop
    ldh [$1f], a
    ld d, b
    rrca
    db $10

jr_005_7e91:
    rrca
    ld hl, $7f1e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $ff00
    nop
    ld bc, $80fe
    ld a, a
    ld a, a
    add b
    nop
    rst $38
    rst $38
    nop
    nop
    rst $38
    ld bc, $0efe
    ldh a, [$f0]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    and b
    ld b, b
    ld h, b
    add b
    or b
    ld b, b
    cp c
    ld b, b
    ld e, a
    and b
    pop af
    ld c, $67
    sbc b
    ld hl, sp+$00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $38
    nop
    inc a
    inc bc

jr_005_7ee4:
    dec b
    inc bc
    inc bc
    nop
    ld bc, $1e00
    ld bc, $1f60
    db $fc
    inc bc
    ld b, e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, a
    nop
    db $e3
    inc e
    dec d
    ld a, [$faf5]
    ld [hl], l
    ld a, [$36c9]
    add hl, bc
    or $00
    rst $38
    nop
    rst $38
    ret nz

    ccf
    ccf
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, h
    nop
    ldh [rP1], a
    ret nz

    nop
    jr nz, jr_005_7ee4

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
    nop
    nop
    nop
    nop
    nop
    jr nz, jr_005_7f5d

    db $10
    rrca
    db $10
    rrca
    ld hl, $7f1e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_005_7f5d:
    rst $38
    ld bc, $0efe
    ldh a, [$f0]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, h
    add b
    add b
    nop
    nop
    nop
    nop

jr_005_7f83:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca
    nop
    ld hl, sp+$07
    ccf
    nop
    ld [hl], b
    rrca
    rla
    rrca
    dec bc
    rlca
    dec b
    inc bc

jr_005_7fac:
    dec b
    inc bc
    inc bc
    nop
    ld bc, $1e00
    ld bc, $1f60
    db $fc
    inc bc
    ld b, e
    nop
    nop
    nop
    rra
    nop
    ldh [$1f], a
    ccf
    ret nz

    add $3f
    ld a, l
    cp $fa
    db $fd
    push af
    ld a, [$faf5]
    push af
    ld a, [$fa75]
    ret


    ld [hl], $09
    or $00
    rst $38
    nop
    rst $38
    ret nz

    ccf
    ccf
    nop
    ldh [rP1], a
    ld a, h
    add b
    ret nc

    jr nz, jr_005_7f83

    ld b, b
    ld b, b
    add b
    add b
    nop
    ret nz

    nop
    jr nz, jr_005_7fac

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
