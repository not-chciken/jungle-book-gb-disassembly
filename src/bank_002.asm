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
    ld a, [$c146]

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
    ld a, [$c13c]
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
    ld hl, $4593
    add hl, de
    ld a, [hl+]
    ld [$c199], a
    ld a, [hl]
    ld [$c19a], a
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
    sbc l
    ld b, l
    dec e
    ld d, c
    cp l
    ld e, h
    ld a, l
    ld h, [hl]
    dec a
    ld l, l

PlayerSprites::
    INCBIN "gfx/PlayerSprites.2bpp"

TODOSprites::
    INCBIN "gfx/TODOSprites.2bpp"

    nop
    nop
    rrca
    nop
    rra
    nop
    rra
    nop
    ld a, $01
    dec a
    ld [bc], a
    ld a, a
    inc bc
    ld a, [hl-]
    rlca
    dec bc
    inc b
    dec d
    ld c, $22
    rra
    ld l, l
    inc de
    ld h, e
    inc e
    sbc d
    ld l, h
    adc [hl]
    ld a, h
    ld d, [hl]
    inc l
    nop
    nop
    nop
    nop
    ret nz

    nop
    ldh [rP1], a
    ldh [rP1], a
    sbc b
    nop
    ld [hl], a
    sbc b
    xor l
    ld e, e
    rst $08
    jr nc, jr_002_4a18

    db $10
    ret nc

    jr nz, @-$6e

    ld h, b
    ld h, b
    ret nz

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
    ret nz

    nop
    ret nz

    add b
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

jr_002_4a18:
    nop
    nop
    nop
    nop
    nop

PlayerSprites2::
    INCBIN "gfx/PlayerSprites2.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    ld e, $00
    ccf
    nop
    ccf
    nop
    ld a, a
    nop
    ld [hl], e
    inc c
    ld a, l
    ld e, $3b
    inc c
    scf
    ld [$3f56], sp
    ld l, e
    ld [hl], $fb
    ld h, [hl]
    xor a
    ld b, a
    rst $38
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
    add b
    nop
    add b
    nop
    add b
    nop
    nop
    nop
    add b
    nop
    ret nz

    add b
    jr nz, @-$3e

    ret nc

    ld h, b
    add sp, $10
    ret z

    ld [hl], b

TODOSprites4::
    INCBIN "gfx/TODOSprites4.2bpp"

    ld [$ff77], a
    ld h, b
    ld a, b
    rlca
    dec bc
    inc b
    add hl, bc
    ld b, $0d
    ld b, $0f
    ld b, $0f
    ld b, $09
    ld b, $05
    ld [bc], a
    rlca
    ld [bc], a
    dec b
    ld [bc], a
    ld [bc], a
    ld bc, $0102
    inc b
    inc bc
    dec bc
    rlca
    sbc b
    ld h, b
    ldh [rP1], a
    ret nz

    nop
    jr nz, @-$3e

    db $10
    ldh [$a8], a
    ld [hl], b
    ld d, h
    jr c, jr_002_5758

    jr jr_002_5740

    inc c
    add hl, bc
    ld b, $06
    inc bc
    ld [bc], a
    ld bc, $0081
    add b
    nop
    add b
    nop
    add b
    nop
    nop
    nop
    nop

jr_002_5740:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ret nz

    add b
    cp b

jr_002_5758:
    ld b, b
    cp b
    ld [hl], b
    ret nc

    ld h, b

TODOSprites5::
    INCBIN "gfx/TODOSprites5.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    ldh [rP1], a
    ldh a, [rP1]

TODOSprites6::
    INCBIN "gfx/TODOSprites6.2bpp"

TODOSprites7::
    INCBIN "gfx/TODOSprites7.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    rlca
    nop
    add hl, bc
    rlca
    dec bc
    inc b
    dec e
    ld c, $3f
    inc d
    dec d
    ld c, $0a
    rlca
    rlca
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_5a1b:
    ld bc, $0f00
    nop
    rrca
    nop
    inc a
    inc bc
    rst $20
    add hl, sp
    or $f9
    pop af
    ld c, $2d
    ld e, $ff
    nop
    ld b, d

jr_002_5a2e:
    cp l
    rst $00
    jr c, jr_002_5a2e

    nop
    ld h, b
    add b
    sbc b
    ld h, b
    reti


    jr nc, @-$6d

    ld h, b
    ld h, b
    ret nz

    ld hl, sp+$00
    ld hl, sp+$00
    ret nc

    jr nz, @-$5e

    ret nz

    ret nc

    and b
    db $fc
    nop
    ld [hl], d
    inc a
    db $fd
    ld [bc], a
    ld [hl], $d8
    call z, Call_002_6830
    jr nc, @-$6e

    ld h, b
    and b
    ld b, b
    ld h, b
    add b
    jr nc, jr_002_5a1b

    add sp, $70

TODOSprites8::
    INCBIN "gfx/TODOSprites8.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc bc
    ld bc, $0103
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
    add b
    nop
    add b
    nop
    add b
    nop
    add b
    nop

TODOSprites9::
    INCBIN "gfx/TODOSprites9.2bpp"

    nop
    nop
    ld [$3c00], sp
    nop
    ld a, a
    nop
    ei
    inc b
    ld sp, hl
    ld b, $fd
    ld b, $7a
    inc b
    ld a, d
    inc b
    dec a
    ld b, $1d
    rrca
    dec a
    dec de
    ld e, [hl]
    ld sp, $2051
    ld [hl], b
    jr nz, jr_002_5c2c

    jr nz, jr_002_5bda

    ld [$1038], sp
    ret nc

    jr nz, @-$5e

    ret nz

    ld [hl], b
    ret nz

    add sp, $10
    inc d
    ld [$0c3a], sp
    sub $38
    jr @-$1e

    ld h, b
    add b
    and b
    ret nz

    ldh [$c0], a
    ld d, b
    ldh [$f0], a

jr_002_5bda:
    ld h, b
    ret nc

    ld h, b
    inc bc
    nop
    ld c, $03
    dec a
    inc bc
    ld a, [hl]
    ld bc, $04fb
    ld sp, hl
    ld b, $fd
    ld b, $7a
    inc b
    ld a, e
    inc b
    inc a
    rlca
    dec e
    rrca
    dec a
    dec de
    ld e, [hl]
    ld sp, $2051
    ld [hl], b
    jr nz, @+$72

    jr nz, @-$7e

    nop
    add b
    nop
    add b
    nop
    ret nz

    nop
    and b
    ld b, b
    ld d, b
    jr nz, @+$6a

    jr nc, @-$6e

    ld h, b
    ld h, b
    ret nz

    and b
    ld b, b
    ld h, b
    add b
    and b
    ret nz

    ldh [$c0], a
    ld d, b
    ldh [$f0], a
    ld h, b
    ret nc

    ld h, b
    cp $00
    rst $38
    nop
    and $18
    db $db
    inc a
    ld a, a
    sbc c
    cp $01
    ld d, l
    ld [c], a
    ld l, c

jr_002_5c2c:
    or [hl]
    adc d
    ld [hl], h
    call c, $a060
    ld b, b
    and b

Jump_002_5c34:
    ld b, b
    ld b, b
    add b
    ld h, b
    add b
    jr nc, @-$3e

    add sp, $70
    nop
    nop
    nop
    nop
    nop
    nop
    db $fc
    nop
    ld e, h
    cp b
    db $fc
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

TODOSprites10::
    INCBIN "gfx/TODOSprites10.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, $0d
    ld b, $0a
    inc b
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    inc e
    ld [$0814], sp

TODOSprites11::
    INCBIN "gfx/TODOSprites11.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_002_5d35

jr_002_5d35:
    ld [hl], $18
    dec sp
    inc e
    dec [hl]
    dec de
    ld [hl], $19
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300
    nop
    inc bc
    nop
    rlca
    nop
    rlca
    nop
    rrca
    nop
    rlca
    nop
    ld bc, $0200
    ld bc, $0304
    add a
    inc bc
    ld a, a
    add a
    and [hl]
    rst $18
    nop
    nop
    nop
    nop
    nop
    nop
    ldh [rP1], a
    ld sp, hl
    nop
    cp $01
    db $dd
    ld [hl+], a
    or [hl]
    ld c, h
    db $ec
    jr @-$56

    ld [hl], b
    db $10
    ldh [$a0], a
    ld b, b
    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    add b
    nop
    nop
    nop
    ld h, b
    nop
    or b
    ld h, b
    ret nc

    ld h, b
    ld h, b
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
    ld bc, $0300
    nop
    inc bc
    nop
    rlca
    nop
    rlca
    nop
    rrca
    nop
    ld b, $01
    dec b
    ld [bc], a
    ld a, [bc]

jr_002_5dbc:
    rlca
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
    ld [$fc04], a
    ld [$10fc], sp
    call z, $9830
    ld h, b
    xor b
    ret nc

    ld d, b
    and b
    ldh [rP1], a
    add b
    nop
    nop
    nop
    inc bc
    nop
    rlca
    nop
    rlca
    nop
    rrca
    nop
    rrca
    nop
    ld e, $01
    rrca
    ld bc, $0305
    dec b
    inc bc
    rlca
    inc bc
    rlca
    inc bc
    ld a, [bc]
    rlca
    scf
    ld c, $6d
    ld e, $92
    ld l, h
    jr z, jr_002_5e0f

    ld hl, sp+$10
    ret z

    jr nc, jr_002_5dbc

    ld h, b
    ld e, b
    ldh [$a0], a
    ret nz

    ld d, b
    and b
    and b
    ld b, b
    ret nz

    nop

jr_002_5e0f:
    add b
    nop
    add b
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

TODOSprites12::
    INCBIN "gfx/TODOSprites12.2bpp"

TODOSprites13::
    INCBIN "gfx/TODOSprites13.2bpp"

    dec [hl]
    jr jr_002_5fb8

    db $10
    jr z, @+$12

    jr z, @+$12

    ld e, b
    jr nc, @-$6e

    ld h, b
    rst $20
    nop
    dec bc
    rlca
    ld [hl], e
    inc c
    ld l, h
    jr nc, jr_002_5fe2

    jr nz, @+$72

    jr nz, @+$72

    jr nz, jr_002_5ff8

    nop
    nop
    nop
    nop
    nop
    ld c, l
    or [hl]
    jp z, Jump_002_5c34

    jr nz, jr_002_600c

    jr nc, @-$4e

    ld h, b
    ret nc

    ld h, b
    ldh [rLCDC], a
    ld h, b
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

jr_002_5fb8:
    nop
    nop
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

jr_002_5fc7:
    ld h, e
    ld bc, $227d
    ld [hl+], a
    inc e
    inc e
    ld [$0008], sp
    inc bc
    nop
    inc bc
    ld bc, $0102
    dec b
    ld [bc], a
    rlca
    ld [bc], a
    inc bc
    nop
    jr c, jr_002_5fdf

jr_002_5fdf:
    ld d, a
    jr c, @-$69

jr_002_5fe2:
    ld l, [hl]
    ld e, h
    db $e3
    db $e3
    add b
    add c
    nop
    ld [bc], a
    ld bc, $0103
    inc b
    inc bc
    dec sp
    ld b, $d7
    ld a, $be
    ret nz

    ret nz

    nop
    nop

jr_002_5ff8:
    nop
    nop
    nop
    nop
    nop
    scf
    ld c, $dd
    ld a, $32
    call c, $d824
    jr c, jr_002_5fc7

    ld h, b
    add b
    ld b, b
    add b
    add b

jr_002_600c:
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
    ld bc, $0600
    ld bc, $0609
    ld [hl], $08
    ld a, b
    jr nc, @+$2a

    db $10
    jr jr_002_6035

jr_002_6035:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300
    ld bc, $0305
    ld b, $03
    ld a, c
    ld b, $b6
    ld a, b
    ret z

    ldh a, [$f1]
    nop
    ld c, $01
    dec [hl]
    ld c, $3e
    db $10
    jr z, @+$12

    jr z, @+$12

    inc e
    ld [$000c], sp
    nop
    nop
    ld c, h
    or b
    ld a, b
    add b
    add sp, $10
    ret c

    jr nc, @+$5a

    jr nc, @+$2a

    db $10
    jr z, jr_002_607b

    add sp, $10
    ret z

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

jr_002_607b:
    nop
    nop

TODOSprites14::
    INCBIN "gfx/TODOSprites14.2bpp"

TODOSprites15::
    INCBIN "gfx/TODOSprites15.2bpp"

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_002_634f

jr_002_634f:
    inc [hl]
    jr jr_002_6378

    inc e
    dec a
    ld d, $3f
    ld [de], a
    dec l
    ld [de], a
    dec l
    ld [de], a
    ld a, [hl-]
    ld de, $0000
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    cp $00
    rst $38
    nop
    rst $38

jr_002_6378:
    nop
    sbc d
    ld h, h
    db $f4
    jr c, jr_002_637e

jr_002_637e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr c, jr_002_6397

jr_002_6397:
    ld e, a
    jr c, jr_002_63ef

    ld l, $6d
    ld [hl-], a

Jump_002_639d:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    cp $00
    rst $38
    nop
    rst $38
    nop
    sbc d
    ld h, h
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    cp $7f
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_63ef:
    nop
    nop
    nop
    nop
    ld a, $00
    ld a, a
    nop
    rst $38
    nop
    rst $38
    nop
    call $0032
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0f00
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
    rra
    nop
    ccf
    nop
    ld a, a
    nop
    rst $38
    nop
    ld h, [hl]
    sbc c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    rlca
    nop
    rrca
    nop
    rra

jr_002_6498:
    nop
    ccf
    nop
    reti


    ld h, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ldh a, [rP1]
    ldh a, [rP1]
    and b
    ld b, b
    ld e, a
    add hl, hl
    ld h, $19
    dec de
    inc b
    dec b
    ld [bc], a
    dec c
    ld [bc], a
    rra
    nop
    cpl
    add hl, de
    ld d, [hl]
    add hl, sp
    reti


    ld h, b
    or b
    ld b, b
    ld d, b
    jr nz, jr_002_653d

    jr nc, jr_002_650f

    db $10
    add hl, hl

jr_002_64d8:
    db $10
    ld a, d

jr_002_64da:
    ld de, $71ba
    ret c

    jr nc, jr_002_6498

jr_002_64e0:
    ret nz

    add h
    ld hl, sp+$32
    call z, $0cfe
    sub $0c
    ld a, c
    add [hl]
    add l
    ld a, [hl]
    cp $80
    add sp, $10
    or b
    ld b, b
    cp b
    ld b, b
    ld l, b
    ret nc

    ld l, b

jr_002_64f8:
    ret nc

    db $e4
    ld a, b
    db $f4
    jr c, jr_002_6538

    ld de, $112b
    rla
    add hl, bc
    ld d, $0d
    rla
    ld a, [bc]
    add hl, de
    ld b, $26
    add hl, de
    ld d, [hl]
    add hl, sp
    reti


    ld h, b

jr_002_650f:
    or c
    ld b, b
    ld d, c
    jr nz, jr_002_657c

    jr nc, jr_002_654f

    db $10
    add hl, hl
    db $10
    ld a, d
    ld de, $71bb
    db $f4
    jr c, jr_002_64f8

    jr nc, jr_002_64da

    ret nz

    add h
    ld hl, sp+$54

jr_002_6526:
    add sp, -$54
    ld e, b
    db $ec
    jr jr_002_64e0

    ld c, b
    db $ec
    jr jr_002_64d8

    ret nc

    ld a, b
    add b
    or b
    ld h, b
    ld [hl], b
    add b
    ld l, b

jr_002_6538:
    sub b
    xor $10
    ld e, d
    or h

jr_002_653d:
    cp [hl]
    ld b, c
    ld l, e
    ld sp, $112f
    rla
    add hl, bc
    ld e, $0d
    rla
    ld a, [bc]
    add hl, hl
    ld d, $57
    jr c, jr_002_6526

    ld h, b

jr_002_654f:
    or b
    ld b, b
    ld d, b
    jr nz, @+$6a

    jr nc, jr_002_658f

    db $10
    add hl, hl
    db $10
    ld a, d
    ld de, $71bb
    ld a, d
    sbc h
    ld l, h
    sbc b
    sbc h
    ldh [$c2], a
    db $fc
    ld d, [hl]
    db $ec
    ld [hl], $cc
    ld a, [$ce04]
    ld a, b
    sbc [hl]
    ld h, b
    db $f4
    ld [$649b], sp
    and [hl]
    ld b, e
    ld b, e
    add c
    ld b, c
    add b
    ret nz

    nop
    and b

jr_002_657c:
    ret nz

    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6584:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_658f:
    nop
    nop
    nop
    nop
    add b
    nop
    ld h, b
    add b
    db $10
    ldh [$e0], a
    nop
    nop
    nop
    ld [hl], $0f
    ld [hl], a
    jr c, jr_002_65f1

    jr nc, jr_002_65da

    add hl, de
    dec de
    inc b
    ld e, $03
    dec h
    ld a, [de]
    ld [hl], $1b
    ld l, e
    jr nc, jr_002_6608

    jr nz, jr_002_65fa

    jr nc, jr_002_65ec

    db $10
    jr c, jr_002_65c7

    add hl, hl
    db $10
    ld a, d
    ld de, $71bb
    ld a, l
    adc [hl]
    ld [hl], $cc
    adc $f0
    ld [c], a
    db $fc
    ld d, $ec

jr_002_65c7:
    ei
    inc b
    ld c, a
    or d
    ld a, [$d38d]
    inc l
    ld a, h
    nop
    ld c, b
    jr nc, jr_002_6584

    ld h, b
    and b
    ld b, b
    ld b, b
    add b
    ret nz

jr_002_65da:
    nop
    and b
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
    rst $38
    nop
    ld a, c

jr_002_65ec:
    cp [hl]
    cp $00
    nop
    nop

jr_002_65f1:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_65fa:
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0304
    dec c
    ld b, $09
    rlca
    rlca

jr_002_6608:
    nop
    add hl, bc
    ld b, $0d
    ld b, $1a
    inc c
    ld d, $08
    ld [de], a
    inc c
    ld a, [de]
    inc c
    inc e
    ld [$0814], sp
    inc a
    ld [$385d], sp
    ld e, a
    db $e3
    call $f3b3
    inc a
    call c, $763b
    adc c
    cpl
    ldh a, [$d5]
    ld a, [hl+]
    rst $28
    jr c, jr_002_666a

    inc bc
    rra
    nop
    ld [de], a
    inc c
    inc l
    jr jr_002_666e

    db $10
    ld d, b
    jr nz, jr_002_65da

    ld b, b
    ld e, b
    ldh [rLCDC], a
    add b
    add b
    nop
    add e
    nop
    add a
    inc bc
    ld hl, sp+$07
    or a
    ld l, b
    cp h
    jp $c033


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
    ret nz

    add b
    and b
    ret nz

    db $10
    ldh [rNR41], a
    ldh [$c0], a

jr_002_666a:
    ret nz

    nop
    nop
    nop

jr_002_666e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, $0b
    ld b, $0a
    inc b
    inc d
    ld [$0814], sp
    jr z, jr_002_66ad

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_66ad:
    jr jr_002_66af

jr_002_66af:
    inc [hl]
    jr jr_002_66de

    jr @+$2a

    db $10
    jr z, jr_002_66c7

    jr c, jr_002_66c9

    jr c, jr_002_66cb

    jr z, jr_002_66cd

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

jr_002_66c7:
    or b
    ld h, b

jr_002_66c9:
    and b
    ld b, b

jr_002_66cb:
    and b
    ld b, b

jr_002_66cd:
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    and b
    ld b, b
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    ld hl, sp+$00
    nop

jr_002_66de:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    ld a, [de]
    inc c
    ld d, $0c
    inc d
    ld [$0814], sp
    inc e
    ld [$081c], sp
    inc e
    ld [$0814], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    or b
    ld h, b
    ret nc

    ld h, b
    and b
    ld b, b
    and b
    ld b, b
    ld d, b
    jr nz, jr_002_678a

    jr nz, jr_002_6764

    jr nc, jr_002_672b

    inc bc
    inc c
    rlca
    dec b
    inc bc
    ld [bc], a
    ld bc, $0102
    ld bc, $0100
    nop

jr_002_672b:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    add a

jr_002_6742:
    nop
    add e
    nop
    add a
    nop
    rst $18
    add b
    ccf
    ret nz

    xor h
    ld [hl], e
    ld e, a
    dec sp
    dec hl
    rra
    dec e
    ld b, $1e
    inc b
    ld d, $0c
    ld e, $0c
    ld l, d
    inc e
    cp h
    ld e, b
    ld c, b
    jr nc, jr_002_67d0

    jr nz, jr_002_6742

    ld b, b
    and b

jr_002_6764:
    ld b, b
    ret nz

    nop
    ldh a, [rP1]
    ld d, b
    add b
    ret nz

    nop
    and b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_002_6789

jr_002_6789:
    inc h

jr_002_678a:
    jr jr_002_67a6

    inc c
    dec c
    ld [bc], a
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
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300

jr_002_67a6:
    nop
    inc bc
    nop
    rlca
    nop
    rlca
    nop
    rst $38
    nop
    db $76
    rst $38
    ld hl, sp+$07
    ld a, [bc]

jr_002_67b4:
    rlca
    dec bc
    ld b, $0f
    ld b, $17
    ld c, $2f
    ld d, $48
    jr nc, jr_002_6810

    jr nz, jr_002_6832

    jr nz, jr_002_67b4

    nop
    ldh a, [rP1]
    db $fc
    nop
    call c, $b020
    ld b, b
    ld l, b
    ldh a, [$d0]

jr_002_67d0:
    ld h, b
    ldh [rP1], a
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
    ld bc, $0100
    nop
    inc bc
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0103
    inc bc
    ld bc, $0307
    dec bc
    rlca
    rla
    dec bc
    ld [hl+], a
    dec e
    dec l
    ld [de], a
    dec [hl]
    ld a, [bc]
    cp $00
    rst $38
    nop
    rst $30
    ld [$10ec], sp
    ld a, [$341c]
    ret c

    ret c

    ldh [$f0], a
    ldh [$b8], a
    ldh a, [$dc]

jr_002_6810:
    cp b
    cp $8c
    ld c, l
    add [hl]
    add [hl]
    ld bc, $0081
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6821:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

Call_002_6830:
    nop
    nop

jr_002_6832:
    nop
    add b
    nop
    ld hl, sp-$80
    cp b
    ld [hl], b
    ld c, h
    jr c, jr_002_6878

    nop
    inc e
    ld [$081c], sp
    ld a, [de]
    inc c
    dec de
    inc c
    dec de
    inc c
    rla
    ld [$0817], sp
    rra
    nop
    ld d, $09
    dec de
    rlca
    ld d, $0f
    rra
    ld c, $2d
    ld e, $3e
    inc e
    ld e, d
    inc a
    or h
    ld e, b
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ld hl, sp+$00
    ret c

    jr nz, jr_002_6821

    ld b, b
    ei
    rlca
    rst $30
    ld hl, sp-$68
    ldh [$60], a
    add b
    add b
    nop
    nop
    nop
    nop

jr_002_6878:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    db $fc
    ld [$fc92], sp
    rst $30
    ld c, $0e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ccf
    db $10
    dec h
    jr jr_002_68d1

    jr jr_002_68c3

    ld [$001f], sp
    rra
    nop
    ld d, $09
    rrca
    ld bc, $030d
    ld a, [bc]
    rlca
    ld c, $07
    rrca
    rlca
    ld d, $0f
    rra
    ld c, $2d
    ld e, $52
    inc l
    ret nz

    nop
    ldh [rP1], a
    pop af
    nop

jr_002_68c3:
    cp $01
    ld sp, hl
    ld b, $7a
    db $fc
    db $ec
    ldh a, [$b0]
    ret nz

    ld b, b
    add b
    add b
    nop

jr_002_68d1:
    add b
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
    inc e
    nop
    ld a, [de]
    inc c
    di
    ld c, $ee
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
    jr jr_002_68ff

jr_002_68ff:
    inc l
    jr @+$36

    jr jr_002_692c

    db $10
    inc d
    ld [$040a], sp
    dec b
    ld [bc], a
    inc b
    inc bc
    inc bc
    ld bc, $0102
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
    sbc [hl]

jr_002_692c:
    nop
    ld c, a
    add b
    rst $18
    add b
    ld a, a
    add c
    ld a, a
    jp $47be


    ld e, l
    ld l, $6b
    inc e
    ld a, h
    jr jr_002_693e

jr_002_693e:
    nop
    inc bc
    nop
    dec b

jr_002_6942:
    inc bc

jr_002_6943:
    ld b, $03
    dec b
    ld [bc], a
    ld a, [bc]
    inc b
    inc [hl]
    ld [$3058], sp
    or b
    ld h, b
    ld h, b
    ret nz

    ret nz

    add b
    ld b, b
    add b
    ret nz

    nop
    add b

jr_002_6958:
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
    ldh [rP1], a
    ld hl, sp+$60
    and a
    ld e, b
    cp [hl]
    ld b, a
    push hl
    ld b, e
    jp LoadRomBank


jr_002_6972:
    nop
    ld bc, $0100
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc d
    add sp, $38
    ret nz

    ret z

    jr nc, jr_002_6958

    jr c, jr_002_6972

    jr jr_002_6942

    ld c, h
    xor $44
    cp c
    ld b, [hl]
    inc hl
    call c, $b05c
    sub b
    ld h, b
    ldh [$80], a
    and b
    ret nz

    and b
    ld b, b
    or b
    ld h, b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_002_69a5

jr_002_69a5:
    ld a, h
    jr jr_002_6943

    ld h, h
    push hl
    ld b, e
    jp nz, Entry

    nop
    nop
    nop
    rlca
    nop
    ld c, $07
    add hl, bc
    ld b, $05
    ld [bc], a
    ld b, $03
    inc bc
    nop
    ld b, l
    ld a, [hl-]
    ld d, d
    inc l
    ld l, d
    inc d
    ld h, [hl]
    jr @+$70

    jr @+$5c

    inc l
    or $2c
    sbc c
    and $a9
    ld d, [hl]
    sub $38
    ld e, b
    ldh [$e0], a
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    add b
    nop
    ld b, $00
    rra
    ld b, $26
    add hl, de
    add hl, sp
    db $10
    jr nc, jr_002_69e7

jr_002_69e7:
    inc bc
    nop
    rlca
    inc bc
    ld b, $03
    ld [bc], a
    ld bc, $0102
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
    ld [hl-], a
    inc c
    or [hl]
    inc c
    ld l, l
    sub [hl]
    ld l, e
    sub $b7
    ld c, d
    reti


    ld a, $3f
    ret nz

    ret nz

    nop
    add b
    nop
    ret nz

    add b
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
    ld bc, $0100
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
    ccf
    nop
    ld [hl], b
    ccf
    cpl
    db $10
    jr z, jr_002_6a45

    inc l
    jr @+$1a

    nop
    nop
    nop
    nop
    nop
    inc e
    ldh [rBCPS], a
    sub b
    ld e, b
    and b
    ld hl, sp+$20

jr_002_6a45:
    ld l, b
    jr nc, jr_002_6aa0

    jr nc, jr_002_6ac2

    db $10
    add sp, $10
    jr z, @-$2e

    add sp, -$10
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
    nop
    rra
    nop
    add hl, sp
    rra
    scf
    jr jr_002_6a84

    ld [$0814], sp
    rrca
    inc b
    rlca
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6a7c:
    nop
    adc [hl]
    ld [hl], b
    or h
    ld c, b
    xor h
    ld d, b
    ld l, h

jr_002_6a84:
    db $10
    ld h, [hl]
    jr jr_002_6ac7

    ld a, [bc]
    push af
    ld a, [bc]

jr_002_6a8b:
    push bc
    ld a, [$00fe]
    inc e
    ld [$10f8], sp
    sub b
    ldh [$e0], a
    ret nz

    ret nc

    jr nz, jr_002_6af2

    jr nc, jr_002_6ad4

    nop
    nop
    nop
    nop

jr_002_6aa0:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0102
    inc bc
    nop
    ld bc, $e100
    nop
    ret c

    ld h, b
    rst $20
    ld e, b
    cp d
    ld b, a
    and [hl]
    ld b, c
    pop hl
    ld b, b
    ld e, h
    jr c, jr_002_6b34

    jr c, jr_002_6b3a

jr_002_6ac2:
    jr nc, jr_002_6a7c

    ld [hl], b
    cp b
    ld [hl], b

jr_002_6ac7:
    ld c, b
    or b
    jr nc, jr_002_6a8b

    ld d, b
    and b
    or b
    ld b, b
    sbc b
    ld h, b
    ret c

    ld h, b
    db $f4

jr_002_6ad4:
    ld l, b
    or [hl]
    ld l, h
    cp d
    ld l, h
    inc d
    add sp, -$58
    ld d, b
    ld l, b
    db $10
    ret nc

    ld h, b
    ret c

    ld h, b
    ld l, h
    jr jr_002_6b02

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6af2:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6b02:
    nop
    ld h, b
    nop

jr_002_6b05:
    ret nc

    ld h, b
    or b
    ld h, b
    and b
    ld b, b
    and b
    ld b, b
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    and b
    ld b, b
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    ld hl, sp+$40
    add b
    nop
    add b
    nop
    add a

jr_002_6b22:
    nop
    add e
    nop
    add [hl]
    ld bc, $81df
    dec a
    jp Jump_002_639d


    ld c, h
    inc sp
    add hl, hl
    ld d, $1d
    ld b, $1e

jr_002_6b34:
    inc b
    ld d, $0c
    ld e, $0c
    ld l, d

jr_002_6b3a:
    inc e
    cp h
    ld e, b
    ld c, b
    jr nc, jr_002_6bb0

    jr nz, jr_002_6b22

    ld b, b
    jr nz, jr_002_6b05

    ldh [$80], a
    ldh a, [$80]
    ld d, b
    add b
    ret nz

    nop
    and b
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
    ld bc, $0300
    nop
    inc bc
    nop
    ld b, $01
    rlca
    ld bc, $01fe
    db $e4
    ei
    and $1b
    ld e, $03
    dec bc
    ld b, $0f
    ld b, $17
    ld c, $2f
    ld d, $48
    jr nc, @+$52

    jr nz, jr_002_6bf2

    jr nz, @-$1e

    ld b, b
    ld [hl], b
    ret nz

    cp h
    ret nz

    call c, $70a0
    add b
    ld l, b
    or b
    ret nc

    ld h, b
    ldh [rP1], a
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
    ld bc, $0100
    nop
    inc bc
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0103
    inc bc

jr_002_6bb0:
    ld bc, $0307
    dec bc
    rlca
    rla
    dec bc
    ld [hl+], a
    dec e
    add hl, sp
    ld b, $25
    ld a, [de]
    cp $40
    rst $38
    ld b, b
    scf
    ret z

    ld l, h
    sub b
    ld a, [$b49c]
    ret c

    cp b
    ret nz

    or b
    ret nz

    ret z

    or b
    call nz, $f6b8
    adc h
    ld c, c
    add [hl]
    add [hl]
    ld bc, $0081
    nop
    nop
    nop
    nop
    inc e
    ld [$081c], sp
    dec de
    inc c
    dec de
    inc c
    rra
    inc c
    rra
    inc c
    dec de
    inc c
    ld [de], a
    dec c
    inc e
    rrca
    dec e
    ld c, $1f

jr_002_6bf2:
    ld c, $1f
    ld c, $2d
    ld e, $3e
    inc e
    ld e, d
    inc a
    or h
    ld e, b
    nop
    nop
    nop
    nop
    ldh [rP1], a
    ldh a, [rP1]
    or b
    ld b, b
    ld h, b
    add b
    rst $10
    ldh [$bb], a
    rst $00
    rst $20
    jr jr_002_6c28

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
    ccf
    db $10
    dec h
    jr jr_002_6c51

    jr jr_002_6c3f

    inc c
    rra
    inc c
    rla

jr_002_6c28:
    inc c
    dec d
    ld c, $0b
    ld b, $0f
    ld b, $0e
    rlca
    rrca
    rlca
    rrca
    rlca
    ld d, $0f
    rra
    ld c, $35
    ld c, $4a
    inc [hl]
    ret nz

    nop

jr_002_6c3f:
    ldh [rP1], a
    pop af
    nop
    sbc $21
    or c
    ld c, [hl]
    ld [$5c74], a
    ldh [rSVBK], a
    add b
    ld b, b
    add b
    add b
    nop

jr_002_6c51:
    add b
    nop
    add b

jr_002_6c54:
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
    sbc [hl]
    nop
    ld c, a
    add b
    rst $18
    add b
    cp [hl]
    pop bc
    ld e, l
    ld [c], a
    rst $38
    ld h, e
    xor d
    ld [hl], a
    ld d, a
    jr c, jr_002_6cd8

    jr c, jr_002_6c7e

jr_002_6c7e:
    nop
    inc bc
    nop
    dec b
    inc bc
    ld b, $03
    dec b
    ld [bc], a
    ld a, [bc]
    inc b
    inc [hl]
    ld [$3058], sp
    ldh a, [rNR41]
    ldh [rP1], a
    ret nz

    nop
    ret nz

    nop
    ld b, b
    add b
    add b
    nop
    nop
    nop
    nop
    nop
    inc d
    add sp, $68
    sub b
    sbc b
    ld h, b
    sub h
    ld l, b
    call nc, $d268
    ld l, h
    xor $44
    cp c
    ld b, [hl]
    inc hl
    call c, $907c
    ret nc

    jr nz, jr_002_6c54

    ret nz

    and b
    ret nz

    and b
    ld b, b
    or b
    ld h, b
    ld [hl], b
    nop
    ld b, l
    ld a, [hl-]
    ld e, d
    inc h
    ld l, d
    inc d
    ld l, [hl]
    db $10
    ld e, d
    inc [hl]
    ld l, d
    inc [hl]
    or $2c
    cp l

jr_002_6ccc:
    and $99
    ld h, [hl]
    or $18
    ld e, b
    ldh [$e0], a
    nop
    nop
    nop
    nop

jr_002_6cd8:
    nop
    add b
    nop
    add b

jr_002_6cdc:
    nop
    ld l, $18
    cp [hl]
    jr @+$77

    sbc d
    ld a, e
    sub $bf
    ld d, d
    ret


    ld [hl], $7f
    add b

jr_002_6ceb:
    ret nz

    nop
    add b
    nop
    ret nz

    add b
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
    add [hl]
    ld a, b
    or h
    ld c, b
    xor h
    ld d, b
    ld h, h
    jr @+$40

    inc c
    dec hl
    ld d, $ed
    ld [de], a
    db $ed
    ld a, [c]
    or $0c
    inc e
    ld [$10f8], sp
    sub b
    ldh [$e0], a
    ret nz

    ret nc

    jr nz, @+$5a

    jr nc, @+$3a

    nop
    ld a, h
    jr c, @+$76

jr_002_6d20:
    jr c, @+$7a

    jr nc, jr_002_6cdc

    ld [hl], b
    xor b
    ld [hl], b
    ld d, b
    and b
    jr nc, jr_002_6ceb

    ret nc

    jr nz, @+$32

    ret nz

    jr z, @-$0e

    ret c

    jr nc, jr_002_6d20

    jr jr_002_6ccc

    ld l, h
    jp c, $146c

    add sp, -$58
    ld d, b

PlayerJumpSprites1::
    INCBIN "gfx/PlayerJumpSprites1.2bpp"

    nop
    nop
    nop
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
    ld bc, $0306
    inc b
    inc bc
    inc bc
    nop
    dec b
    ld [bc], a
    dec bc
    rlca
    rla
    rrca
    dec e
    ld c, $2f
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
    ld a, $00
    ld a, a
    nop
    ei
    inc b
    or $08
    cp l
    adc $ea
    inc e
    inc e
    ldh [$60], a
    add b
    ret nz

    nop
    jr jr_002_6e7b

jr_002_6e7b:
    db $ec
    db $18

PlayerJumpSprites2::
    INCBIN "gfx/PlayerJumpSprites2.2bpp"

TODOSprites18::
    INCBIN "gfx/TODOSprites18.2bpp"

    dec h
    dec de
    inc d
    dec bc
    rrca
    nop
    nop
    nop
    ld bc, $0300
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
    sub h
    add sp, -$38
    jr nc, @-$4e

    ld h, b
    ldh [rLCDC], a
    ld b, b
    add b
    jr c, @-$3e

    cp b
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
    nop
    nop
    nop

PlayerJumpLegSprites::
    INCBIN "gfx/PlayerJumpLegSprites.2bpp"

TODOSprites20::
    INCBIN "gfx/TODOSprites20.2bpp"

; $174fd: Loads the tiles of the status window.
LoadStatusWindowTiles::
    ld hl, CompressedStatusWindowData
    ld de, $8d80
    jp DecompressData

; $27506: Draws the initial status window including health, time, diamonds, etc.
InitStatusWindow:
    ld hl, $787f
    ld de, $9ca0    ; Window tile map.
    ld b, 4
    ld c, 20
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
    jp CopyToOam

; $27579: Loads two heart tiles into the VRAM
; Input: Offset in "a".
LoadTwoHeartTiles:
    push af
    add a                     ; a = a * 2
    call CreateOffsetPointer
    call CopyToOam            ; Copies 2 tiles.
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
    ld hl, $7ab1
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
    jr c, :+
    xor a                           ; a = 0
 :  ld [WeaponSelect], a
    ld b, $00
    ld c, a
    ld hl, $75ce                    ; Weapon tile ofssets $75ce + WeaponSelect ($1e,$1e,$1f,$20,$21)
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
    call CopyToOam16
    jp HandleNewWeapon

    ld e, $1e
    rra
    jr nz, @+$23

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

    ld hl, sp-$07
    ld sp, hl
    ld a, [$f9f8]
    ld sp, hl
    ld a, [$f9f8]
    ld sp, hl
    ld a, [$f9f8]
    ld sp, hl
    ld a, [$f9f8]
    ld sp, hl
    ld a, [$edec]
    ldh a, [$ce]
    nop
    adc $ce
    adc $ce
    adc $ce
    adc $fb
    db $f4
    push af
    nop
    adc $f0
    adc $ce
    xor $ef
    pop af
    adc $00
    ld a, [c]
    adc $ce
    nop
    di
    adc $ce
    nop
    or $f7
    nop
    adc $f1
    adc $ce
    db $fd
    cp $fe
    rst $38
    db $fd
    cp $fe
    rst $38
    db $fd
    cp $fe
    rst $38
    db $fd
    cp $fe
    rst $38
    db $fd
    cp $fe
    rst $38

; $78cf: Compressed tiles of the status window.
CompressedStatusWindowData::
    INCBIN "bin/CompressedStatusWindowData.bin"

    add c
    ld [$0200], sp
    rst $38
    add b
    rst $38
    ld b, b
    ld a, a
    jr nz, @+$41

    db $10
    rra
    ld [$040f], sp
    rlca
    ld [bc], a
    inc bc
    ld bc, $02fe
    cp $04
    db $fc
    ld [$10f8], sp
    ldh a, [rNR41]
    ldh [rLCDC], a
    ret nz

    add b
    add b
    nop
    rst $38
    add b
    rst $38
    ld b, b
    ld a, a
    jr nz, @+$41

    db $10
    rra
    ld [$040f], sp
    rlca
    inc bc
    inc bc
    ld bc, $02fe
    cp $04
    db $fc
    ld [$10f8], sp
    ldh a, [rNR41]
    ldh [rLCDC], a
    ret nz

    add b
    add b
    nop
    rst $38
    add b
    rst $38
    ld b, b
    ld a, a
    jr nz, @+$41

    db $10
    rra
    ld [$070f], sp
    rlca
    inc bc
    inc bc
    ld bc, $02fe
    cp $04
    db $fc
    ld [$10f8], sp
    ldh a, [rNR41]
    ldh [$c0], a
    ret nz

    add b
    add b
    nop
    rst $38
    add b
    rst $38
    ld b, b
    ld a, a
    jr nz, jr_002_7b57

    db $10
    rra
    rrca
    rrca
    rlca
    rlca
    inc bc
    inc bc
    ld bc, $02fe
    cp $04
    db $fc
    ld [$10f8], sp
    ldh a, [$e0]
    ldh [$c0], a
    ret nz

    add b
    add b
    nop
    rst $38
    add b
    rst $38
    ld b, b
    ld a, a
    jr nz, jr_002_7b77

    rra
    ld e, $0f
    rrca
    rlca
    rlca
    inc bc
    inc bc
    ld bc, $02fe
    cp $04
    db $fc
    ld [$f088], sp
    ret nc

    jr nz, @-$1e

jr_002_7b4c:
    ret nz

    ret nz

    add b
    add b
    nop
    rst $38
    add b
    rst $38
    ld b, b
    ld a, a
    ccf

jr_002_7b57:
    ccf
    rra
    ld e, $0f
    rrca
    rlca
    rlca
    inc bc
    inc bc
    ld bc, $02fe
    cp $04
    call c, $88e8
    ldh a, [$d0]
    jr nz, jr_002_7b4c

jr_002_7b6c:
    ret nz

    ret nz

    add b
    add b
    nop
    rst $38
    add b
    rst $38
    ld a, a
    ld a, a
    ccf

jr_002_7b77:
    ccf
    rra
    ld e, $0f
    rrca
    rlca
    rlca
    inc bc
    inc bc
    ld bc, $02fe
    xor $fc
    call c, $88e8
    ldh a, [$d0]
    jr nz, jr_002_7b6c

    ret nz

    ret nz

    add b
    add b
    nop
    nop
    nop
    ld a, h
    jr c, jr_002_7c13

    add d
    cp $01
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    nop
    nop
    ld a, h
    jr c, jr_002_7c22

    add d
    rst $38
    nop
    rst $38
    ld bc, $01ff
    rst $38
    ld bc, $00ff
    nop
    nop
    ld a, h
    jr c, jr_002_7c33

    add d
    cp $01
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    rst $38
    nop
    nop
    ld a, h
    jr c, jr_002_7c42

    add d
    rst $38
    nop
    rst $38
    ld bc, $01ff
    rst $38
    ld bc, $feff
    nop
    nop
    ld a, h
    jr c, jr_002_7c53

    add d
    cp $01
    rst $38
    nop
    rst $38
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    nop
    nop
    ld a, h
    jr c, jr_002_7c62

    add d
    rst $38
    nop
    rst $38
    ld bc, $01ff
    rst $38
    rst $38
    rst $38
    cp $00
    nop
    ld a, h
    jr c, jr_002_7c73

    add d
    cp $01
    rst $38
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    nop
    nop
    ld a, h
    jr c, @+$7e

    add d
    rst $38
    nop
    rst $38
    ld bc, $ffff
    rst $38
    rst $38
    rst $38
    cp $00
    nop

jr_002_7c13:
    ld a, h
    jr c, jr_002_7c93

    add d
    cp $01
    rst $28
    sbc a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    nop

jr_002_7c22:
    nop
    jr c, jr_002_7c5d

    ld a, h
    add d
    rst $38
    nop
    rst $28
    sbc a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    cp $00
    nop

jr_002_7c33:
    ld a, h
    jr c, @+$7f

    add d
    sbc [hl]
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

jr_002_7c42:
    nop
    ld a, h
    jr c, jr_002_7cc2

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

jr_002_7c53:
    ld a, h
    jr c, jr_002_7c33

    ld c, $9e
    adc a
    rst $28
    sbc a
    rst $38
    rst $38

jr_002_7c5d:
    rst $38
    rst $38
    rst $38
    rst $38
    nop

jr_002_7c62:
    nop
    ld a, h
    jr c, jr_002_7cc4

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

jr_002_7c73:
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
    ldh [rLCDC], a

jr_002_7c93:
    and b
    and b
    sbc [hl]
    ld c, $4d
    inc de
    ld b, h
    ld a, h
    ret z

    or [hl]
    and $a9
    add c
    add $e0
    ld [hl], b
    inc d
    jr z, jr_002_7cb2

    ld [de], a
    ld b, $09
    ld b, $09
    inc c
    ld [de], a
    inc b
    jr c, @+$2a

    stop

jr_002_7cb2:
    jr @+$16

    inc l
    inc d
    inc l
    inc a
    jr jr_002_7cba

jr_002_7cba:
    ld h, [hl]
    ld d, l
    cp e
    ld d, l
    cp e
    rst $38
    ld h, [hl]
    rst $20

jr_002_7cc2:
    add c
    and l

jr_002_7cc4:
    rst $38
    rst $38
    rst $38
    jp $db99


    ld b, d
    ld h, [hl]
    ld e, d
    ld h, [hl]
    inc h
    inc a
    db $18

; $7cd1: Compressed $24f. Decompressed 290$.
; Compressed tile data of the cartoonish font.
CompressedFontTiles::
    INCBIN "bin/CompressedFontTiles.bin"

; $7f20. Compressed $d7. Decompressed 120$. Not exactly sure what this is. Looks snakish.
CompressedTileData::
    db $20, $01, $d3, $00, $04, $40, $55, $e2, $61, $10, $0c, $00, $10, $0c, $e0, $1d
    db $00, $2d, $08, $a0, $1e, $00, $20, $c0, $e5, $f8, $0b, $fc, $07, $fc, $15, $02
    db $4c, $01, $d8, $e6, $1e, $90, $7e, $80, $7e, $00, $fe, $f6, $01, $c8, $07, $38
    db $01, $a4, $78, $c2, $23, $02, $08, $01, $fe, $02, $03, $05, $2c, $3f, $00, $a1
    db $1f, $42, $02, $d1, $0f, $00, $f8, $20, $10, $1e, $33, $05, $f0, $5a, $00, $15
    db $ed, $10, $ea, $11, $e4, $23, $f0, $ef, $1c, $df, $f1, $1f, $d0, $08, $88, $04
    db $5c, $f9, $07, $9c, $7f, $80, $7f, $00, $07, $03, $a6, $63, $80, $35, $f8, $4b
    db $bc, $0c, $82, $00, $80, $02, $80, $3e, $80, $22, $9c, $7d, $00, $fa, $01, $7e
    db $00, $75, $82, $f0, $8c, $00, $42, $b4, $83, $f4, $c3, $20, $9f, $21, $5f, $a1
    db $9f, $c0, $22, $10, $1a, $10, $fd, $01, $00, $02, $f8, $06, $f7, $1c, $04, $88
    db $06, $8b, $3f, $40, $00, $00, $ff, $80, $cf, $41, $80, $08, $f4, $23, $ec, $23
    db $e8, $27, $f4, $0f, $f0, $3f, $60, $01, $08, $00, $ff, $87, $78, $8f, $78, $8b
    db $78, $88, $40, $58, $c0, $7f, $c0, $2f, $c0, $07, $3f, $08, $42, $f8, $03, $fc
    db $43, $74, $01, $10, $a0, $1f, $04

; $7ff7: Probably 9 bytes of unused data at the end of Bank 2.
Bank2TailData::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff, $02
