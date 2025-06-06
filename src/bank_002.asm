SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

Call24000::
    ld a, [$c190]
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
    ld hl, $438f
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld hl, $4145
    add hl, de
    ld a, l
    ld [$c197], a
    ld a, h
    ld [$c198], a
    ld hl, $443b
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

jr_002_40e3:
    ld [hl+], a
    dec b
    jr nz, jr_002_40e3
    ret

TODO00240e8:
    dec a
    ld [$c18b], a
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
    ld hl, $443b
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

jr_002_4114:
    add e
    dec d
    jr nz, jr_002_4114

    ld [$c18c], a
    ld hl, $453d
    add hl, bc
    ld a, [hl]
    dec a
    dec a
    add a
    ld e, a
    ld hl, SpritePointers
    add hl, de
    ld a, [hl+]
    ld [SpritePointerMsb], a
    ld a, [hl]
    ld [SpritePointerLsb], a
    ld hl, $438f
    add hl, bc
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld hl, $4145
    add hl, de
    ld a, l
    ld [$c195], a
    ld a, h
    ld [$c196], a
    ret


    ld a, [hl-]
    inc a
    ld c, h
    ld c, [hl]
    ld a, $40
    ld c, h
    ld c, [hl]
    inc d
    ld e, $18
    ld l, $30
    ld [hl-], a
    inc b
    ld b, $08
    jr nz, jr_002_417a

    inc h
    ld a, [bc]
    inc c
    ld c, $26
    jr z, jr_002_4189

    db $10
    ld [de], a
    inc l
    ld [bc], a
    inc d
    ld d, $18
    ld l, $30
    ld [hl-], a
    inc b
    ld a, [de]
    ld [$3420], sp
    inc h
    ld a, [bc]
    inc e
    ld c, $26
    ld [hl], $2a
    db $10
    ld [de], a
    jr c, jr_002_417b

    ld e, [hl]

jr_002_417a:
    ld h, b

jr_002_417b:
    ld h, d
    add b
    add d
    ld [bc], a
    ld h, h
    ld h, [hl]
    ld l, b
    add h
    add [hl]
    adc b
    ld l, d
    ld l, h
    ld l, [hl]
    adc d

jr_002_4189:
    adc h
    adc [hl]
    ld [hl], b
    ld [hl], d
    ld [hl], h
    sub b
    sub d
    sub h
    ld [bc], a
    sub [hl]
    sbc b
    db $76
    xor h
    ld a, d
    sbc d
    sbc h
    ld e, h
    xor [hl]
    or b
    ld [bc], a
    ld e, [hl]
    sbc [hl]
    ld h, d
    add b
    or d
    ld [bc], a
    ld h, h
    and b
    and d
    add h
    or h
    adc b
    ld l, d
    and h
    and [hl]
    adc d
    or [hl]
    adc [hl]
    ld [hl], b
    xor b
    xor d
    cp b
    cp d
    sub h
    ld [bc], a
    ld d, h
    ld d, [hl]
    db $76
    ld a, b
    ld a, d
    ld e, b
    ld e, d
    ld e, h
    ld a, h
    ld a, [hl]
    ld [bc], a
    inc b
    ld b, $08
    ld a, [hl+]
    inc l
    ld [bc], a
    ld [bc], a
    ld a, [bc]
    inc c
    ld c, $2e
    jr nc, jr_002_4200

    ld [bc], a
    ld [bc], a
    db $10
    ld [de], a
    inc d
    inc [hl]
    ld [hl], $38
    ld [bc], a
    ld [bc], a
    ld d, $18
    ld a, [de]
    ld a, [hl-]
    inc a
    ld a, $02
    ld [bc], a
    inc e
    ld e, $40
    ld b, d
    ld b, h
    ld [bc], a
    jr nz, jr_002_420a

    ld b, [hl]
    ld c, b
    ld c, d
    inc h
    ld h, $28
    ld c, h
    ld c, [hl]
    ld [bc], a
    ld d, h
    ld d, [hl]
    ld e, b
    ld h, b
    ld h, d
    ld h, h
    ld e, d
    ld e, h
    ld e, [hl]
    ld h, [hl]
    ld l, b
    ld l, d
    xor h
    xor [hl]
    sbc b

jr_002_4200:
    sbc d
    ld d, b
    ld d, d
    ld [bc], a
    ld e, h
    ld e, [hl]
    ld h, b
    ld d, h
    ld d, [hl]
    ld [bc], a

jr_002_420a:
    ld h, d
    ld h, h
    ld h, [hl]
    ld e, b
    ld e, d
    ld [bc], a
    ld l, b
    ld l, d
    ld l, h
    ld a, [bc]
    inc c
    ld c, $10
    jr nc, jr_002_424b

    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [de], a
    inc d
    db $10
    inc [hl]
    ld [hl], $38
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld [bc], a
    ld [bc], a
    ld d, $18
    ld a, [hl-]
    inc a
    ld a, $02
    ld [bc], a
    ld [bc], a
    ld b, $02
    ld [bc], a
    ld a, [de]
    ld b, b
    ld b, d
    ld b, h
    inc e
    ld e, $02
    ld [bc], a
    ld [bc], a
    ld b, [hl]
    ld c, b
    ld c, d
    ld [bc], a
    ld d, d
    ld [bc], a
    ld [bc], a
    jr nz, jr_002_426a

    inc h
    ld [bc], a
    ld [bc], a

jr_002_424b:
    ld [bc], a
    ld [bc], a
    ld c, h
    ld c, [hl]
    ld d, b
    ld [$0202], sp
    ld [bc], a
    ld [bc], a
    ld h, $28
    ld a, [hl+]
    inc l
    ld l, $a2
    and h
    or b
    or d
    sbc b
    sbc d
    ld [bc], a
    ld b, [hl]
    ld c, b
    ld c, d
    ld d, b
    ld d, d
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a

jr_002_426a:
    inc b
    ld c, $10
    ld [de], a
    ld [hl-], a
    inc [hl]
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld b, $14
    ld d, $18
    ld [hl], $38
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [$0202], sp
    ld a, [de]
    inc e
    ld e, $3a
    inc a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld a, [bc]
    ld [bc], a
    ld [bc], a
    ld [bc], a
    jr nz, jr_002_42af

    inc h
    ld a, $40
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc c
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld h, $28
    ld a, [hl+]
    ld b, d
    ld b, h
    ld [bc], a
    ld [bc], a
    inc l
    ld l, $30
    ld b, [hl]
    ld c, b
    ld [bc], a
    ld [bc], a
    ld c, d
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld c, $4e
    ld d, b
    ld [hl-], a
    ld h, [hl]

jr_002_42af:
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld b, $14
    ld d, d
    ld d, h
    ld [hl], $68
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld c, h
    ld [bc], a
    ld [bc], a
    ld d, [hl]
    ld e, b
    ld e, $3a
    ld l, d
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld a, [bc]
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld e, d
    ld e, h
    inc h
    ld a, $40
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc c
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld e, [hl]
    ld h, b
    ld a, [hl+]
    ld b, d
    ld l, h
    ld [bc], a
    ld [bc], a
    inc l
    ld h, d
    ld h, h
    ld b, [hl]
    ld l, [hl]
    ld [bc], a
    ld [bc], a
    ld c, d
    ld [bc], a
    ld [bc], a
    ld [bc], a
    db $76
    ld [bc], a
    adc h
    adc [hl]
    or h
    or [hl]
    ld [bc], a
    ld b, d
    ld b, h
    ld d, b
    ld d, d
    ld [bc], a
    ld [hl], d
    ld [hl], h
    ld [bc], a
    add [hl]
    adc b
    adc d
    ld [bc], a
    ld [bc], a
    db $76
    adc h
    adc [hl]
    sub b
    ld [bc], a
    ld a, b
    ld a, d
    sub d
    sub h
    sub [hl]
    and [hl]
    xor b
    cp b
    cp d
    ld a, h
    xor d
    sbc b
    cp h
    inc b
    ld [bc], a
    ld a, [bc]
    inc c
    inc h
    ld [bc], a
    ld b, $02
    ld c, $0c
    ld h, $02
    ld a, [hl-]
    ld [bc], a
    ld [$1002], sp
    ld [de], a
    jr z, @+$04

    inc d
    ld d, $2a
    inc l
    jr jr_002_4342

    ld l, $30
    inc e
    ld e, $32
    inc [hl]
    jr nz, jr_002_4352

    ld [hl], $38
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld a, h
    ld a, [hl]
    add b
    sbc b
    sbc d
    ld [bc], a
    ld l, [hl]
    ld [hl], b
    add d
    add h
    sbc b
    sbc d
    ld [bc], a

jr_002_4342:
    ld [bc], a
    db $76
    sbc h
    sbc [hl]
    and b
    inc a
    ld a, $5c
    ld e, [hl]
    ld [bc], a
    ld a, b
    ld b, b
    ld b, d
    ld b, h
    ld h, b
    ld h, d

jr_002_4352:
    ld h, h
    ld b, [hl]
    ld c, b
    ld c, d
    ld [bc], a
    ld [bc], a
    ld h, [hl]
    ld l, b
    ld l, d
    ld c, h
    ld c, [hl]
    ld d, b
    ld [bc], a
    ld l, h
    ld l, [hl]
    ld [bc], a
    ld a, d
    ld [bc], a
    ld d, d
    ld d, h
    ld d, [hl]
    ld [bc], a
    ld [hl], b
    ld [hl], d
    ld [bc], a
    ld a, h
    ld [bc], a
    ld e, b
    ld e, d
    ld [hl], h
    db $76
    ld a, [hl]
    ld [bc], a
    ld l, h
    ld l, [hl]
    add h
    add [hl]
    ld [hl], b
    ld [hl], d
    adc b
    adc d
    ld [hl], h
    db $76
    ld a, b
    adc h
    adc [hl]
    sub b
    ld a, d
    ld a, h
    ld a, [hl]
    sub d
    sub h
    sub [hl]
    ld [bc], a
    add b
    add d
    ld [bc], a
    sbc b
    sbc d
    sbc h
    sbc [hl]
    nop
    nop
    inc b
    nop
    ld [$0e00], sp
    nop
    inc d
    nop
    ld a, [de]
    nop
    ld e, $00
    inc h
    nop
    ld a, [hl+]
    nop
    jr nc, jr_002_43a3

jr_002_43a3:
    inc [hl]
    nop
    ld a, [hl-]
    nop
    ld b, b
    nop
    ld b, [hl]
    nop
    ld c, h
    nop
    ld d, d
    nop
    ld e, b
    nop
    ld e, [hl]
    nop
    ld h, h
    nop
    ld l, d
    nop
    ld [hl], b
    nop
    halt
    nop
    ld a, h
    nop
    add d
    nop
    adc d
    nop
    sub d
    nop
    sbc d
    nop
    and b
    nop
    and [hl]
    nop
    xor h
    nop
    or d
    nop
    cp b
    nop
    cp h
    nop
    jp nz, $c800

    nop
    adc $00
    sub $00
    ldh [rP1], a
    db $ec
    nop
    push af
    nop
    ld bc, $0b01
    ld bc, $0115
    dec de
    ld bc, $0123
    inc l
    ld bc, $0135
    ld b, c
    ld bc, HeaderComplementCheck
    ld e, c
    ld bc, $0162
    ld l, e
    ld bc, $0174
    add b
    ld bc, $018c
    sbc b
    ld bc, $001d
    and c
    ld bc, $01a9
    xor a
    ld bc, $01b5
    cp e
    ld bc, $01c1
    push bc
    ld bc, $01c9
    rst $08
    ld bc, $01d7
    db $dd
    ld bc, $01e1
    push hl
    ld bc, $01e9
    db $ed
    ld bc, $01f6
    dec e
    nop
    db $fc
    ld bc, $0202
    ld [$0e02], sp
    ld [bc], a
    ld d, $02
    rra
    ld [bc], a
    jr z, jr_002_4433

    ld l, $02

jr_002_4433:
    ld [hl-], a
    ld [bc], a
    ld [hl], $02
    inc a
    ld [bc], a
    ld b, d
    ld [bc], a
    ld [hl+], a
    ld [hl+], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl+], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl+], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld b, d
    ld b, d
    ld b, d
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl+], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld b, d
    ld d, d
    ld b, e
    inc sp
    ld b, e
    ld d, d
    ld d, d
    inc hl
    ld b, d
    inc sp
    inc sp
    ld b, e
    ld b, e
    ld b, e
    inc sp
    inc sp
    inc sp
    ld b, e
    ld b, e
    ld b, e
    inc sp
    ld de, $3242
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl+], a
    ld [hl+], a
    inc hl
    inc h
    inc hl
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    inc sp
    inc hl
    ld de, $2332
    ld [hl-], a
    ld b, d
    inc sp
    inc sp
    inc hl
    ld [hl+], a
    ld [hl+], a
    ld [hl-], a
    ld [hl-], a
    ld b, d
    db $fd
    nop
    db $fd
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
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
    inc b
    nop
    ld b, $0a
    nop
    nop
    nop
    ld a, [$fd04]
    ld [bc], a
    db $f4
    nop
    db $fd
    nop
    nop
    ld bc, $0100
    nop
    nop
    nop
    nop
    nop
    ld [bc], a
    nop
    ld [bc], a
    nop
    or $fb
    ld a, [c]
    ei
    ld a, [c]
    db $f4
    ld a, [$0ef4]
    db $fc
    inc c
    ld sp, hl
    rrca
    ldh a, [rP1]
    ldh a, [rTIMA]
    nop
    or $f3
    ld hl, sp-$0c
    cp $f9
    inc bc
    push af
    ld b, $f4
    ld [$f6fc], sp
    di
    ld hl, sp-$0c
    cp $f9
    inc bc
    push af
    ld b, $f4
    ld [$00fc], sp
    nop
    nop
    nop
    ld bc, $0200
    nop
    db $fc
    nop
    db $fc
    nop
    nop
    nop
    nop
    nop
    inc b
    ldh a, [rDIV]
    ldh a, [rTMA]
    ldh a, [rP1]
    nop
    ld bc, $0100
    nop
    nop
    nop
    inc b
    ldh a, [rP1]
    ldh a, [rP1]
    nop
    db $fc
    nop
    ld bc, $01fc
    nop
    ld bc, $fdfc
    db $fd
    cp $fb
    nop
    ei
    ld bc, $0100
    nop
    dec b
    nop
    dec b
    nop
    ld [$0200], sp
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    inc b
    inc b
    inc bc
    inc bc
    inc bc
    inc bc
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc b
    inc bc
    ld [bc], a
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    inc bc
    inc bc
    ld [bc], a
    inc bc
    inc bc
    inc bc
    inc bc
    inc bc
    ld b, $06
    ld b, $06
    ld b, $06
    ld b, $03
    inc bc
    inc bc
    inc bc
    ld b, $06
    ld b, $06
    ld b, $06
    inc b
    inc b
    inc b
    inc b
    inc b

; $4593
PlayerSpritePointers::
    dw PlayerSprites0               ; When standing or walking.
    dw PlayerSprites1               ; Crouching, or looking up, or jumping sideways.
    dw PlayerSprites2               ; Player dies or swings on a vine.
    dw PlayerSprites3
    dw PlayerSprites4               ; Jumping, hanging on a vine.

PlayerSprites0::
    INCBIN "gfx/PlayerSprites0.2bpp"

PlayerSprites1::
    INCBIN "gfx/PlayerSprites1.2bpp"

PlayerSprites2::
    INCBIN "gfx/PlayerSprites2.2bpp"

PlayerSprites3::
    INCBIN "gfx/PlayerSprites3.2bpp"

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
    TilemapLow de,0,0

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

    nop
    nop
    ld a, h
    jr c, @+$7e

    add d
    sbc a
    adc [hl]
    rst $28
    sbc a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    cp $00
    nop
    ld a, h
    jr c, @-$21

    ld c, $9e
    adc a
    rst $28
    sbc a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    nop
    nop
    ld a, h
    jr c, @+$60

    adc h
    sbc a
    adc [hl]
    rst $28
    sbc a
    rst $38

jr_002_7c6c:
    rst $38
    rst $38
    rst $38
    rst $38
    cp $ff
    rst $38
    rst $38
    ld a, a
    ld a, a
    ccf
    ccf
    rra
    ld e, $0f
    rrca
    rlca
    rlca
    inc bc
    inc bc
    ld bc, $fefe
    xor $fc
    call c, $88e8
    ldh a, [$d0]
    jr nz, jr_002_7c6c

    ret nz

    ret nz

    add b
    add b
    nop

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
