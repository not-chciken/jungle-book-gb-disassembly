; Disassembly of "jb.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $002", ROMX[$4000], BANK[$2]

    ld a, [$c190]
    ld b, $00
    ld c, a
    ld a, [$c149]
    cp $03
    jr nz, jr_002_4018

    ld a, [$c18d]
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
    ld a, [$c144]
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
    ld a, [$c145]
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

Jump_002_4487:
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $0102
    dec b
    ld [bc], a
    ld c, $07
    inc bc
    nop
    ld bc, $0300
    nop
    rlca
    nop
    rra
    nop
    rrca
    nop
    rlca
    nop
    ld b, $01
    ld b, $01
    dec a
    ld [bc], a
    db $db
    ld a, $bd
    add $54
    adc a
    xor [hl]
    dec e
    dec hl
    inc e
    jp c, $802c

    nop
    ret nz

    nop
    ldh [rP1], a
    ld hl, sp+$00
    xor b
    ld b, b
    ld h, b
    add b
    ret nc

    ldh [$a0], a
    ret nz

    ret nz

    nop
    nop
    nop
    nop
    nop
    add b
    nop
    add b
    nop
    adc $80
    ld [hl], l
    adc $ea
    ld a, h
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    dec bc
    rlca
    nop
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
    ld c, $01
    ld b, $01
    ld b, $01
    add hl, de
    ld b, $6d
    ld e, $a9
    db $76
    or a
    ld c, h
    db $eb
    sbc h
    call Call_000_003a
    nop
    nop
    nop
    add b
    nop
    ldh [rP1], a
    ld hl, sp+$00
    cp b
    ld b, b
    ld h, b
    add b
    ret nc

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
    rlca
    nop
    ld bc, $0200
    ld bc, $0205
    ld c, $05
    dec de
    dec c
    dec e
    dec bc
    dec [hl]
    ld a, [bc]
    ld a, [hl]
    ld [$0000], sp
    ldh [rP1], a

Jump_002_4681:
    ld hl, sp+$00
    db $fc
    nop
    call c, $b020
    ld b, b
    add sp, $70
    ld d, b
    ldh [$60], a
    add b
    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    ld b, b

jr_002_4696:
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
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0307
    ld b, $03
    inc bc
    nop
    ld bc, $0300
    nop
    rlca
    nop
    rrca
    nop
    rrca
    nop
    rlca
    nop
    ld b, $01
    inc e
    inc bc
    ld h, h
    dec de
    ret


    ld [hl], a
    ld [hl], a
    adc l
    sbc $8d
    xor l
    ld e, $ba
    inc b
    call z, $c030
    nop
    ldh [rP1], a
    ldh a, [rP1]
    ret c

    jr nz, jr_002_4696

    ld b, b
    add sp, $70
    ld d, b
    ldh [$60], a
    add b
    add b
    nop
    add b
    nop
    add b
    nop
    add b
    nop
    ldh [rP1], a
    ld e, b
    ldh [$e4], a
    jr jr_002_4728

    jr @+$05

    nop
    ld bc, $0300
    nop
    rlca
    nop
    rra
    nop
    rrca
    nop
    rlca
    nop
    ld b, $01
    ld b, $01
    dec a
    ld [bc], a
    swap h
    or c
    adc $55
    adc e
    xor [hl]
    dec e
    dec hl
    inc e
    jp nc, Jump_000_002c

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

jr_002_4728:
    nop
    rrca
    nop
    ld c, $01
    ld b, $01
    ld b, $01
    dec de
    inc b
    ld l, c
    ld d, $b5
    ld l, [hl]
    or a
    ld c, h
    db $eb
    sub h
    jp hl


    ld d, $03
    nop
    ld bc, $0300
    nop
    rlca
    nop
    rrca
    nop
    rrca
    nop
    rlca
    nop
    ld b, $01
    inc e
    inc bc
    ld l, h
    rra
    call z, Call_002_7173
    adc [hl]
    db $dd
    adc [hl]
    xor l
    ld e, $ba
    inc b
    call z, $0d30
    ld b, $0e
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld bc, $0200
    ld bc, $0106
    dec c
    ld b, $1a
    inc c
    inc d
    ld [$1028], sp
    jr c, jr_002_4789

    ld h, $18
    dec d
    ld c, $8c
    ld [hl], b
    sbc h
    ld h, b
    db $e4
    jr @-$52

    ld e, b
    ld [hl-], a
    call z, $ccb6

jr_002_4789:
    res 0, [hl]
    ld b, l
    add d
    add d
    ld bc, $0103
    ld [bc], a
    ld bc, $0001
    ld bc, $0100
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
    add b
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
    call z, $7480
    adc b
    add sp, $70
    or b
    ld b, b
    ld b, $01
    ld bc, $0000
    nop
    nop

jr_002_47c4:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cpl
    db $10
    ld sp, $2f1f
    db $10
    jr c, jr_002_47e5

    jr c, @+$12

    jr jr_002_47d9

jr_002_47d9:
    nop
    nop
    nop
    nop
    or $0b
    adc d
    ld [hl], c
    cp c
    ld b, b
    add sp, $10

jr_002_47e5:
    ld [hl], h
    jr jr_002_4854

    jr jr_002_483e

    jr z, @+$7c

    inc b
    ld a, [c]
    inc c
    jp c, $fcec

    ld [$0814], sp
    jr z, jr_002_4807

    jr c, jr_002_4809

    scf
    jr jr_002_4835

    rra
    add b
    nop
    ldh [rP1], a
    ld d, b
    ldh [$a0], a
    ld b, b
    nop
    nop

jr_002_4807:
    nop
    nop

jr_002_4809:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld e, h
    jr z, @+$56

    jr z, jr_002_48a0

    inc c
    ld a, d
    inc c
    ld l, $10
    dec d
    ld a, [bc]
    dec e
    ld a, [bc]
    ld a, [hl+]
    inc d
    inc a
    db $10
    ld l, b
    jr nc, jr_002_48a2

    jr nz, jr_002_47c4

    ld h, b

jr_002_4835:
    db $ec
    ld d, b
    xor h
    ld e, b
    ret c

    ld h, b
    call nz, Call_000_0778

jr_002_483e:
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld bc, $0200
    ld bc, $0305
    ld b, $03
    add hl, bc
    ld b, $0e
    inc b
    ld [de], a

jr_002_4854:
    inc c
    inc e
    ld [$0814], sp
    dec de
    inc c
    add hl, de
    rrca
    add h
    ld a, b
    xor d

jr_002_4860:
    ld d, h
    push af
    ld c, $2d
    jp $c0a3


    jp Jump_002_4681


    add e
    adc c
    ld b, $9a
    inc b
    inc [hl]
    jr jr_002_4888

    ld [$0e15], sp
    rrca
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    jr c, jr_002_487f

jr_002_487f:
    nop
    nop
    nop
    nop
    add b
    nop
    ld b, b
    add b
    ld b, b

jr_002_4888:
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
    adc h
    ld [hl], b
    xor h

jr_002_48a0:
    ld d, b
    db $e4

jr_002_48a2:
    jr jr_002_4860

    ld b, b
    ld d, d
    db $ec
    or [hl]
    call z, $86cb
    ld b, l
    add d
    add d
    ld bc, $0103
    ld [bc], a
    ld bc, $0001
    ld bc, $0100
    nop
    nop
    nop
    nop
    nop
    sub [hl]
    ld l, e
    adc d
    ld [hl], c
    cp c
    ld b, b
    add sp, $10
    ld e, h
    jr nc, @+$7e

    jr nc, @+$5e

    jr nc, jr_002_4936

    inc d
    ld a, [$d214]
    db $fc
    db $fc
    ld [$0814], sp
    jr z, jr_002_48e7

    jr c, @+$12

    scf
    jr jr_002_4915

    rra
    ld e, h
    jr z, @+$56

    jr z, jr_002_4960

    inc c
    ld a, d
    inc c
    ld l, $10

jr_002_48e7:
    add hl, de
    ld b, $15
    ld c, $3a
    inc c
    inc h
    jr jr_002_4958

    db $10
    ld d, b
    jr nz, @-$2e

    ld h, b
    db $ec

jr_002_48f6:
    db $10
    xor h
    ld e, b
    ret c

    ld h, b
    call nz, Call_000_0078
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    inc bc
    nop
    ld bc, $0000
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0305

jr_002_4915:
    dec bc
    ld b, $0a
    rlca
    ld b, $01
    ld bc, $7800
    nop
    cp $00
    rst $38
    nop
    rst $30
    ld [$10ec], sp
    ld a, [$d41c]
    jr c, jr_002_4984

    jr nz, jr_002_48f6

    jr nc, @+$76

    add sp, -$0e
    cp h
    ld [$ad34], a

jr_002_4936:
    ld [hl], d
    cp l
    ld [hl], d
    ld a, [$4cb4]
    or b
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
    ld bc, $0200
    ld bc, $0305
    dec bc
    ld b, $0a

jr_002_4958:
    rlca
    ld b, $01
    ld bc, $7800
    nop
    db $fc

jr_002_4960:
    nop
    db $fc
    nop
    cp $00
    adc $30
    or $78
    db $ec
    jr nc, jr_002_49c4

    jr nz, jr_002_4936

    jr nc, @+$76

    add sp, -$0e
    cp h
    ld [$ad34], a
    ld [hl], d
    cp l
    ld [hl], d
    ld a, [$4cb4]
    or b
    nop
    nop
    rrca
    nop
    rra
    nop
    rra

jr_002_4984:
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
    ld d, $0c
    dec h
    ld e, $6f
    ld [de], a
    ld h, [hl]
    dec de
    sub c
    ld l, a
    adc [hl]
    ld a, l
    ld d, a
    inc l
    nop
    nop
    nop
    nop
    ret nz

    nop
    ldh [rP1], a
    ldh [rP1], a
    add b
    nop
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
    add [hl]
    nop
    ei
    ld b, $65
    cp $fe
    nop
    nop
    nop
    rrca
    nop
    rra
    nop
    rra

jr_002_49c4:
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

    jr nz, jr_002_4984

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
    ld [bc], a
    ld bc, $0103
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0102
    ld bc, $0100
    nop
    ld bc, $0200
    ld bc, $80fc
    jp c, Jump_002_5c24

    and b
    xor b
    ret nc

    xor b
    ret nc

    sbc b
    ldh a, [$98]
    ldh a, [$28]
    ret nc

    ld l, b
    sub b
    ld d, b
    and b
    ldh a, [$a0]
    ret nc

    and b
    ld d, b
    and b
    ld d, b
    and b
    ret z

    or b
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

jr_002_4a66:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_4a72:
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0103
    rlca
    inc bc
    ld a, [hl-]

jr_002_4a7e:
    inc b
    ld [hl+], a
    inc e
    ld l, $10
    ld [hl-], a
    inc c
    ld a, [de]
    inc c
    ld e, $0c
    ld e, $0c
    ld a, [de]
    inc c
    ld h, $18
    ld l, d
    inc [hl]
    call c, Call_000_3868
    ret nc

    ld l, b
    sub b
    ret nc

    jr nz, jr_002_4a66

    jr nc, jr_002_4af6

    cp h
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    inc bc
    nop
    inc bc
    nop
    inc bc
    nop
    ld bc, $0300
    nop
    rrca
    nop
    ld [de], a
    dec c
    ld l, $11
    ld d, l
    inc hl
    ld c, e
    scf
    ld e, [hl]
    daa
    ld l, e
    ld d, $00
    nop
    ldh [rP1], a
    ld hl, sp+$00
    cp $00
    xor $10
    ret c

    jr nz, jr_002_4a7e

    ld a, b
    xor b
    ld [hl], b
    or b
    ld b, b
    ld b, e
    add b
    push hl
    jp $63f4


    ld e, a
    or h
    db $e4
    jr jr_002_4a72

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_4aed:
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100

jr_002_4af6:
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $000f
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
    inc e
    ld [$186c], sp
    call nc, Call_002_6438
    cp b
    cp b
    ld h, b
    ld hl, sp+$20
    ld c, b
    or b
    jr c, jr_002_4aed

    nop
    nop
    ret nz

    nop
    ldh [rP1], a
    ldh [rP1], a
    add b
    nop
    ld b, b
    add b
    add b
    nop
    nop
    nop
    nop

jr_002_4b2e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $0007
    dec bc
    ld b, $09
    ld b, $07
    nop
    ld [bc], a
    ld bc, $0007
    rrca
    nop
    rra
    nop
    ld e, $01
    ccf
    ld bc, $031d
    ld a, c
    ld b, $b6
    ld a, h
    cp d
    call nz, $8c72
    xor [hl]
    jr jr_002_4be8

    jr c, jr_002_4b2e

    ld [hl], b
    ld l, a
    ldh a, [$eb]
    rla
    inc [hl]
    jp Jump_000_00c0


    ldh [rP1], a
    ld h, b
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

jr_002_4b92:
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

jr_002_4bad:
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
    inc b
    inc bc
    inc bc
    nop
    nop
    nop
    ld bc, $0000
    nop
    ld bc, $0300
    nop
    rlca
    nop
    rlca

jr_002_4bc8:
    nop
    inc bc
    nop
    ld e, $01
    cpl
    rra
    ld e, h
    inc sp
    cp [hl]
    ld b, c
    ld c, d
    add a
    sub a
    ld c, $b5
    ld c, $5a
    inc h
    adc [hl]

jr_002_4bdc:
    ld [hl], b
    ldh [rP1], a
    ldh a, [rP1]
    ld hl, sp+$00
    db $ec
    db $10
    ret c

    jr nz, jr_002_4bdc

jr_002_4be8:
    jr c, jr_002_4b92

    ld [hl], b
    jr nc, jr_002_4bad

    ld b, b
    add b
    ld b, b
    add b
    ret nz

jr_002_4bf2:
    nop
    and b
    ld b, b
    ld [hl+], a
    ret nz

    or l
    ld b, d
    cp e
    db $76
    ld a, [hl]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $060b
    add hl, bc
    ld b, $06
    nop
    nop
    nop
    ld bc, $0000
    nop
    ld bc, $0700
    nop
    inc bc
    nop
    inc bc
    nop
    ld bc, $1e00
    ld bc, $1f6f
    sub c
    ld a, a
    ld a, h
    add e
    adc e
    rlca
    ld e, $07
    scf

jr_002_4c38:
    ld c, $5e
    jr nz, jr_002_4bc8

jr_002_4c3c:
    ld [hl], b
    ldh [rP1], a
    db $fc
    nop
    cp $00
    add sp, $10
    ret c

    jr nz, jr_002_4c3c

    jr c, jr_002_4bf2

    ld [hl], b
    ld sp, $c2c0
    add c
    inc sp
    pop bc
    ld e, l
    or d
    and $18
    sbc b

jr_002_4c56:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add hl, de

jr_002_4c78:
    nop
    add hl, hl
    db $10
    ld d, h
    jr c, jr_002_4c7e

jr_002_4c7e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0700
    nop
    inc bc
    nop
    nop
    nop
    inc bc
    nop
    rra
    inc bc
    inc l
    rra
    ld e, a
    jr nz, jr_002_4c38

    ld b, c
    ld h, l
    jp $c33f


    db $e4
    dec de

jr_002_4c9d:
    nop
    nop
    ldh [rP1], a
    ld [hl], b
    nop
    ld hl, sp+$00
    cp $00
    ld [$d810], a
    jr nz, @-$0a

    jr c, jr_002_4c56

    ld [hl], b
    or e
    ret nz

    db $f4
    jp $b37e


    db $eb
    sbc h
    ld d, h
    adc b
    adc b
    nop
    add b
    nop
    nop
    nop
    jr nc, jr_002_4cc1

jr_002_4cc1:
    ld c, b
    jr nc, jr_002_4c78

    ld a, b
    cp e
    ld b, h
    ld b, [hl]
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

jr_002_4cdd:
    ld c, [hl]
    jr nc, jr_002_4d46

    jr @+$58

    jr z, jr_002_4c9d

    ld h, [hl]
    db $db
    ld h, [hl]
    push hl
    add e
    add e
    ld bc, $0103
    inc bc
    ld bc, $0102
    ld [bc], a
    ld bc, $0205
    dec b
    ld [bc], a
    rlca
    ld [bc], a
    rlca
    inc bc
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
    add b
    nop
    add b
    nop
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
    ret nz

    nop
    jr nc, jr_002_4cdd

    inc bc
    nop
    ld [bc], a
    ld bc, $0102
    inc bc
    ld bc, $0102
    ld bc, $0700
    nop
    dec sp
    rlca
    scf

jr_002_4d2e:
    jr jr_002_4d5d

jr_002_4d30:
    ld [de], a
    ld d, l
    ld [hl+], a
    cp d
    ld h, h
    xor $04
    ld d, $0c
    dec bc
    ld b, $04
    inc bc
    or [hl]
    ld c, b
    ld l, c
    add [hl]
    db $ed
    add [hl]
    and [hl]
    ret nz

    and b

jr_002_4d46:
    ret nz

    ret nz

    add b
    ld b, b
    add b
    ld b, b
    add b
    add b
    nop
    nop
    nop

jr_002_4d51:
    nop

jr_002_4d52:
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

jr_002_4d5d:
    ld [bc], a
    ld bc, $0003
    ld [bc], a
    ld bc, $0305
    rlca
    ld [bc], a
    dec c
    ld b, $0a
    inc b
    inc d
    ld [$0019], sp
    add hl, hl
    db $10
    ld sp, $5300
    ld hl, $61b2
    ld [hl], e
    jr nz, jr_002_4dd2

    jr nc, jr_002_4da0

    jr jr_002_4d51

    jr nz, @-$56

    ld [hl], b
    ret c

    jr nc, jr_002_4d30

    jr jr_002_4d98

    inc c
    ld a, [de]
    inc c
    inc [hl]
    jr jr_002_4de4

    jr nz, jr_002_4d2e

    ld b, b
    ld b, b
    add b
    ret nz

    add b
    add b
    nop
    add b
    nop
    nop

jr_002_4d98:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_4da0:
    nop
    ld bc, $0200
    ld bc, $0106
    ld a, [bc]
    rlca
    rla
    inc c
    inc d
    ld [$1028], sp
    ld d, b
    jr nz, jr_002_4d52

    ld b, b
    ld h, b
    ret nz

    and b
    ld b, b
    ldh [rLCDC], a
    ret nc

    ld h, b
    ld [hl], b
    nop
    sbc l
    ld l, [hl]
    ld a, [c]
    rrca
    dec a
    jp $c1a3


    ld b, e
    add c
    add h
    inc bc
    rlca
    ld [bc], a
    dec b
    ld [bc], a
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    dec c

jr_002_4dd2:
    ld b, $05
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
    add b
    nop
    ld b, b
    add b
    ld b, b

jr_002_4de4:
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
    add b
    nop
    ld b, b
    add b
    ret nz

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
    db $dd
    ld h, b
    ld l, e
    sbc h
    jp c, Jump_002_4487

    add e
    jp LoadRomBank


    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld c, h
    db $fd
    ld e, $7a
    add a
    and [hl]
    pop bc
    ld b, c
    add b
    add e
    ld bc, $0103
    inc bc
    ld bc, $0102
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
    nop

jr_002_4e40:
    nop
    add b
    nop
    ld b, b
    add b
    ret nz

    add b
    ld b, b
    add b
    add b
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
    ld hl, sp-$80
    xor b
    ld [hl], b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, [hl-]
    ld b, h
    ld c, d
    inc b
    dec b
    ld [bc], a
    ld [bc], a
    ld bc, $0102
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
    ld d, a
    jr z, jr_002_4efe

    nop
    db $e4
    jr jr_002_4e40

    ld e, b
    ld a, [hl+]
    call c, $0cd6
    add hl, bc
    ld b, $07
    ld [bc], a
    dec b
    ld [bc], a
    ld [bc], a
    ld bc, $0103
    ld [bc], a
    ld bc, $0001
    ld bc, $0000
    nop
    nop
    nop
    nop

jr_002_4e9e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld c, h
    add b
    db $fc
    adc b
    ret z

    ld [hl], b
    sub b
    ld h, b
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    inc bc
    nop
    inc bc
    nop
    inc bc
    nop
    ld bc, $0300
    nop
    rrca
    inc bc
    dec d
    rrca
    ld l, $11
    ld d, l
    inc hl
    ld c, e
    scf
    ld l, [hl]
    scf
    ld a, e
    ld b, $00
    nop
    ldh [rP1], a
    ld hl, sp+$00
    cp $00
    xor $10
    ret c

    jr nz, jr_002_4e9e

    ld a, b
    xor b
    ld [hl], b
    or b
    ld b, b
    ld b, e
    add b
    and l
    jp $a354


    ld e, a
    or h
    db $e4
    jr @-$66

    nop
    nop
    nop
    nop

jr_002_4efe:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_4f07:
    nop

jr_002_4f08:
    nop
    nop
    nop
    nop
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
    ld bc, $0300
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
    inc e
    ld [$182c], sp
    ld d, h

jr_002_4f32:
    jr c, jr_002_4f08

    ld l, b
    jr z, jr_002_4f07

    ret z

    or b
    ret c

    and b
    ld a, b
    add b
    rlca
    nop
    rrca
    nop
    rra
    nop
    ld e, $01
    ccf
    ld bc, $031d
    ld a, c
    ld b, $b6
    ld l, h

jr_002_4f4d:
    or [hl]
    call z, $9c62
    cp d
    inc d
    ld a, h
    db $10
    xor b
    ld d, b
    ld d, a
    add sp, -$15
    rla
    inc [hl]
    jp $0001


    nop
    nop
    ld bc, $0300
    nop
    rlca
    nop
    rlca
    nop
    inc bc
    nop
    ld e, $01
    dec hl
    dec e
    ld c, l
    inc sp
    cp h

jr_002_4f72:
    ld b, e
    ld c, e
    add [hl]
    sub a
    ld c, $b5
    ld c, $5a
    inc h
    adc [hl]

jr_002_4f7c:
    ld [hl], b
    ldh [rP1], a
    ldh a, [rP1]
    ld hl, sp+$00
    db $ec
    db $10
    ret c

    jr nz, jr_002_4f7c

    jr c, jr_002_4f32

    ld [hl], b
    jr nc, jr_002_4f4d

    ld b, b
    add b
    ret nz

    add b
    ret nz

    add b
    and b
    ret nz

    ld h, d
    ret nz

    or l
    ld b, d
    cp e
    db $76
    ld a, [hl]
    nop
    ld bc, $0000
    nop
    ld bc, $0700
    nop
    inc bc
    nop
    inc bc
    nop
    ld bc, $1f00
    nop
    ld l, d
    dec e
    sub l
    ld a, e
    ld a, h
    add e
    adc e
    rlca
    ld e, $07
    scf
    ld c, $5e
    jr nz, @-$72

jr_002_4fbc:
    ld [hl], b

jr_002_4fbd:
    ldh [rP1], a
    db $fc
    nop
    cp $00
    add sp, $10
    ret c

    jr nz, jr_002_4fbc

    jr c, jr_002_4f72

    ld [hl], b
    ld sp, $42c0
    add c
    or e
    pop bc
    ld l, l
    ld a, [c]
    or $18
    sbc b
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc bc
    nop
    nop
    nop
    inc bc
    nop
    dec e
    ld [bc], a
    add hl, hl
    ld e, $5e
    ld hl, $41a2
    ld h, l
    jp $c33f


    db $e4
    dec de
    nop
    nop
    ldh [rP1], a
    ld [hl], b
    nop
    ld hl, sp+$00
    cp $00
    ld [$d810], a
    jr nz, @-$0a

    jr c, @-$56

    ld [hl], b
    inc sp
    ret nz

    ld [hl], h
    jp $b37e


    db $eb
    sbc h
    ld d, h
    adc b
    adc b
    nop
    add b
    nop
    ld l, [hl]
    db $10
    ld b, [hl]
    jr c, jr_002_5088

    jr jr_002_4fbd

    ld h, [hl]
    db $db
    ld h, [hl]
    push hl
    add e
    add e
    ld bc, $0103
    inc bc

jr_002_502e:
    ld bc, $0102
    ld [bc], a
    ld bc, $0205
    dec b
    ld [bc], a
    rlca
    ld [bc], a
    rlca
    inc bc
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0003
    inc bc
    nop
    inc bc
    nop
    ld [bc], a
    ld bc, $0107
    ld a, [hl-]
    dec b
    dec [hl]
    ld a, [de]
    cpl
    ld [de], a
    ld d, l
    ld [hl+], a
    cp d
    ld h, h
    xor $04
    ld d, $0c
    dec bc

jr_002_505a:
    ld b, $04
    inc bc
    or [hl]
    ret z

    ld l, c
    add [hl]
    db $ed
    ld b, $26
    ret nz

    and b
    ret nz

    ret nz

    add b
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
    add b
    nop
    ld b, b
    add b
    ld [hl], e
    add b
    ret z

    jr nc, jr_002_505a

    jr nc, @-$52

    jr jr_002_5098

    inc c
    ld a, [de]

jr_002_5088:
    inc c
    inc [hl]
    jr jr_002_50e4

    jr nz, jr_002_502e

    ld b, b
    ld b, b
    add b
    ret nz

    add b
    add b
    nop
    add b
    nop
    nop

jr_002_5098:
    nop
    nop
    nop
    nop
    nop
    adc l

jr_002_509e:
    ld [hl], d
    ld hl, sp+$07
    dec a
    jp $c1a3


    ld b, e
    add c
    add h
    inc bc
    rlca
    ld [bc], a
    dec b
    ld [bc], a
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    dec c
    ld b, $05
    inc bc
    inc bc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc [hl]
    ld [hl], b
    jp hl


    ld d, $78
    add a
    and [hl]
    pop bc
    ld b, c
    add b
    add e
    ld bc, $0103
    inc bc
    ld bc, $0102
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
    ld a, [hl-]
    ld b, h
    ld c, d
    inc b
    dec b
    ld [bc], a
    inc bc

jr_002_50e4:
    ld bc, $0102
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
    ld b, a
    jr c, jr_002_5166

    jr jr_002_509e

    ld h, b
    ld e, h
    ldh [$32], a
    call z, $0cd6
    add hl, bc
    ld b, $07
    ld [bc], a
    dec b
    ld [bc], a
    ld [bc], a
    ld bc, $0103
    ld [bc], a
    ld bc, $0001
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
    rlca
    nop
    add hl, bc
    ld b, $0d
    inc bc
    ld [hl], $0f
    ld c, c
    ld [hl], $8e
    ld [hl], b
    or a
    ld c, b
    ld l, d
    dec e
    dec l
    ld e, $76
    rrca
    xor e
    ld [hl], a
    inc e
    nop
    ccf
    nop
    ccf
    nop
    ld a, l
    ld [bc], a
    ld a, e
    inc b
    or $0f
    or l
    ld c, [hl]
    adc $f0
    db $f4
    jr c, jr_002_517b

    inc e
    add hl, de
    rlca
    rlca
    nop
    add b
    nop
    ld b, b
    add b
    ldh [rLCDC], a
    ld h, b
    add b
    nop
    nop
    nop
    nop
    ret nz

    nop
    ret nz

    nop
    nop

jr_002_5166:
    nop
    add b
    nop
    nop
    nop
    nop
    nop
    jr nc, jr_002_516f

jr_002_516f:
    ret c

    jr nc, jr_002_51aa

    ldh a, [$f0]
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_517b:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    add hl, bc
    ld b, $05
    ld [bc], a
    inc bc
    nop
    ld [bc], a
    ld bc, $0205
    ld e, $00
    ccf
    nop
    ccf
    nop
    ld a, l
    ld [bc], a
    ld a, e
    inc b
    cp $07
    ld sp, hl

jr_002_51aa:
    ld b, $ef
    rra
    ld e, b
    cp a
    ld l, a
    or b
    or b
    ld h, b
    ldh a, [$60]
    ld d, b
    ldh [$50], a
    ldh [$a0], a
    ret nz

    db $fc
    nop
    nop
    nop
    add b
    nop
    add $00
    rst $08
    ld b, $0b
    ld b, $b6
    ld [$30d8], sp
    ldh a, [$c0]
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

jr_002_51de:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    rlca
    nop
    rrca
    nop
    rra
    nop
    ld e, $01
    ccf
    ld bc, $031d
    dec hl
    inc e
    rst $08
    ccf
    or h
    ld a, e
    ei
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
    ret nz

    nop
    ldh [rP1], a
    ld h, [hl]
    add b
    rst $08
    ld b, $ab
    add $56
    adc b
    add sp, $10
    ret nc

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
    ld bc, $0100
    nop
    nop
    nop
    inc bc
    nop
    inc b
    inc bc
    dec bc
    rlca
    ld d, $0f
    dec hl
    inc e
    ld e, a
    jr nz, jr_002_51de

    ld a, e
    call nz, $003b
    nop
    ld a, b
    nop
    inc a
    nop
    ld a, [hl]
    nop
    ei
    inc b
    or $08
    db $fd
    ld c, $ea
    inc e
    inc a

jr_002_526e:
    ret nz

    ret nc

    ldh [rSVBK], a
    ldh [$d8], a
    jr nc, jr_002_529d

    jr jr_002_526e

    rrca
    rst $08
    ldh a, [rOBP0]
    or b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_528f:
    nop
    nop
    nop
    nop
    ld h, b
    nop
    or b
    ld h, b
    ld [hl], b
    ldh [$e0], a
    nop
    nop
    nop

jr_002_529d:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0000
    nop
    ld bc, $0700
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_52d0:
    nop
    ldh [rP1], a
    db $fc
    nop
    cp $00
    add sp, $10
    ret c

    jr nz, jr_002_52d0

    jr c, jr_002_52e5

    nop
    inc bc
    nop
    rlca
    nop
    rrca
    nop

jr_002_52e5:
    ccf
    nop
    ld e, $01
    rlca
    ld bc, $031d
    dec l
    ld a, [de]
    ld d, [hl]
    jr c, jr_002_534e

    jr nc, jr_002_5362

    jr nc, @-$03

    inc h
    db $ed
    inc sp
    rst $38
    jr jr_002_528f

    ld l, a
    nop
    nop
    add b
    nop
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
    ldh [rP1], a
    db $10
    ldh [$b0], a
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
    ld bc, $0e00
    ld bc, $0f37
    ld d, [hl]
    add hl, sp
    ld a, c
    rla
    dec hl
    rla
    ld h, $19
    dec e
    ld c, $1f
    inc c
    rra
    nop
    inc d
    dec bc
    jr c, jr_002_533f

jr_002_533f:
    ld a, [hl]
    nop
    ld a, a
    nop
    ei
    inc b
    or $08
    db $ed
    ld e, $6a
    sbc h
    inc e
    ldh [$a0], a

jr_002_534e:
    ret nz

    ld [hl], b
    add b
    rst $28
    db $10
    and a
    rra

jr_002_5355:
    rra
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

jr_002_5362:
    nop
    add b
    nop
    nop
    nop
    nop

jr_002_5368:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, b
    nop
    ldh a, [$60]
    jr nc, jr_002_5355

    ldh [rP1], a
    nop
    nop
    nop
    nop
    nop
    nop
    ld d, l
    ld l, $36
    ld [$1068], sp
    ret c

    ld h, b
    ld h, [hl]
    jr c, jr_002_53b5

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
    nop
    nop
    nop
    nop
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

jr_002_53a8:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_53b0:
    nop
    nop
    nop
    nop
    nop

jr_002_53b5:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $030e
    inc de
    inc c
    inc l
    db $10
    ld d, b
    jr nz, jr_002_5446

    jr nz, jr_002_5368

    ld h, b
    ld c, b
    jr nc, jr_002_5430

    jr c, jr_002_53e6

    rlca
    inc c
    inc bc
    ld [de], a
    dec c
    dec hl
    inc e
    inc [hl]

jr_002_53e6:
    jr jr_002_53b0

    jr nc, jr_002_541d

    ldh [$a3], a
    pop bc
    jp $0501


    ld [bc], a
    ld b, $00
    nop
    nop
    nop
    nop

jr_002_53f7:
    nop
    nop
    nop
    nop
    nop
    nop
    cp d
    ld a, h
    jp c, $e224

    inc e
    ld c, h
    jr nc, jr_002_5456

    jr nz, jr_002_53a8

    ld b, b
    ld b, b
    add b
    ld b, b
    add b
    add b
    nop
    nop
    nop
    nop

jr_002_5412:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_541c:
    nop

jr_002_541d:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    rst $20

jr_002_5430:
    rra
    rst $18
    ldh [$a0], a
    ret nz

    jr nz, jr_002_53f7

    ld b, b
    add b
    ret nz

    add b
    ret nz

    nop
    ld bc, $0202
    ld bc, $0205
    add hl, bc
    ld b, $14

jr_002_5446:
    dec bc
    dec l
    ld a, [de]
    ld a, $18
    ld d, h
    jr c, jr_002_5446

    jr nc, jr_002_5480

    ldh [$e0], a
    nop

jr_002_5453:
    nop
    nop
    nop

jr_002_5456:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld l, b
    ldh a, [$d8]
    ldh [$ec], a
    sbc b
    sub b
    ld l, h
    db $ec
    jr jr_002_541c

    jr jr_002_54c2

    jr nc, jr_002_54d4

    jr nc, jr_002_54de

    jr nz, jr_002_54c0

jr_002_5470:
    jr nz, jr_002_5412

    ld b, b
    sbc h
    ld h, b
    call z, $fc7c
    nop
    nop
    nop
    nop
    nop
    ld [hl], b
    jr nz, jr_002_5470

jr_002_5480:
    ld h, b
    jr z, jr_002_5453

    ld d, l
    adc b
    adc a
    inc b

jr_002_5487:
    dec b
    ld [bc], a
    ld b, $03
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
    or a
    ld c, b
    ret c

    ld h, b
    ldh a, [$60]
    ld d, b
    ldh [$61], a
    ret nz

    ld h, c
    ret nz

    ld b, c
    add b
    ld b, c
    add b
    add c
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
    ret nc

    jr nz, jr_002_5470

jr_002_54c0:
    ld h, b
    ret nc

jr_002_54c2:
    ld h, b
    ldh [rLCDC], a
    jr nz, jr_002_5487

    ld c, b
    add b
    ld a, b
    adc b
    ld d, b
    cp b
    cp b
    ret nz

    ret nz

    nop
    nop
    nop
    nop

jr_002_54d4:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_54de:
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
    ld bc, $1d00
    ld [$183d], sp
    dec bc
    inc [hl]
    dec d
    ld [hl+], a
    ld [hl+], a
    ld bc, $0001

jr_002_54f9:
    nop
    nop
    nop
    nop
    rrca
    nop
    dec [hl]
    ld c, $5e
    ccf
    cp e
    ld a, a
    db $ed
    ld [hl], e
    ld a, [hl]
    add c
    inc de
    xor $51
    xor [hl]
    cp [hl]
    ld b, c
    ld h, d
    pop bc
    ld h, c
    ret nz

    and b
    ld b, b
    ldh a, [$a0]
    jr nc, jr_002_54f9

    sub b
    ld h, b
    ld h, b
    nop
    xor [hl]
    ld [hl], b
    ld [hl], c
    adc [hl]
    adc l
    ld [bc], a
    add d
    nop
    add b
    nop
    ld b, b
    add b
    ret nz

    add b
    ld h, $c0
    sbc $66
    call nc, $7ebe
    ret nz

    call nc, Call_000_2222
    inc e
    inc e
    ld [$0814], sp
    ld [$0000], sp
    nop
    nop
    nop
    ld b, $00

jr_002_5543:
    rrca
    ld b, $12
    dec c
    dec a
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
    xor e
    ld d, a
    sbc $21
    ld l, a
    jr nc, jr_002_5543

    ld [hl], $73
    rst $18
    rst $18
    jr c, jr_002_559f

    ld [$0009], sp
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
    ldh [rP1], a
    add b
    nop
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
    ret nz

    add b
    ret nz

    add b
    ret nz

    add b
    inc l
    ret nz

    cp h
    ld c, b
    xor b
    ld d, b
    ld l, b
    jr nc, jr_002_560a

    jr nz, jr_002_55fc

    nop
    dec hl
    rla

jr_002_559f:
    inc l
    inc de
    rra
    nop
    inc sp
    rrca
    ld l, a
    jr nc, @+$57

    ld [hl+], a
    ld d, h
    inc hl
    ld [c], a
    ld b, c
    jp Jump_000_0301


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
    ld h, b
    add b
    ret nc

    ldh [$a8], a
    ld d, b
    add sp, -$10
    ldh a, [rP1]
    nop
    nop
    add b
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
    add $80
    xor [hl]
    ld b, h
    ld d, d
    inc l
    ld d, h
    jr c, jr_002_5612

    db $10
    jr nc, jr_002_55dd

jr_002_55dd:
    nop
    nop
    nop
    nop
    nop
    nop
    ld c, $00
    rra
    nop
    ccf
    nop
    ccf
    nop
    ld a, [hl-]
    dec b
    ccf
    rlca
    ld a, [hl-]
    rlca
    dec e
    ld b, $15
    rrca
    dec l
    dec de
    scf
    add hl, de
    ld e, c
    jr nz, jr_002_566c

jr_002_55fc:
    jr nz, jr_002_55fe

jr_002_55fe:
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

jr_002_560a:
    nop
    ret nz

    nop
    ld b, b
    add b
    add b
    nop
    add b

jr_002_5612:
    nop
    ld b, b
    add b
    and b
    ret nz

jr_002_5617:
    ret nc

    ldh [$6f], a
    ldh a, [$a8]
    ld [hl], a
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
    jr nz, jr_002_5617

    ret nc

    ld h, b
    add sp, $10
    ret z

    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    rlca
    nop
    rra
    nop
    ccf
    nop
    ccf
    nop
    dec [hl]

jr_002_566c:
    ld a, [bc]
    cpl
    ld e, $15
    ld c, $19
    ld b, $13
    rrca
    daa
    rra
    dec sp
    rla
    dec h
    dec de
    ld d, a
    add hl, hl
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

jr_002_568a:
    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    add b
    nop
    ld h, b
    add b

jr_002_5695:
    ld d, b
    ldh [$bc], a
    ld [hl], b
    db $76
    adc h
    reti


    ld h, [hl]

jr_002_569d:
    ld [hl], b
    jr nz, @+$52

    jr nz, jr_002_571a

    jr nc, jr_002_571c

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

jr_002_56b1:
    nop
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0305
    rlca
    inc bc
    sbc d
    ld h, l
    call $9830
    ld h, b
    db $f4
    ld [$344a], sp
    ld d, c
    ld a, $2e
    dec de
    ld a, [de]
    dec c
    daa
    inc e
    ld d, l
    jr c, jr_002_568a

    ld h, b
    jr nz, jr_002_5695

    ld b, b
    add b
    add b
    nop
    ret nz

    nop
    jr nc, jr_002_569d

    add b
    nop
    add b
    nop
    nop
    nop
    nop
    nop

jr_002_56e5:
    nop
    nop
    nop

jr_002_56e8:
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
    jr nz, jr_002_56b1

    ldh [rLCDC], a
    and b
    ld b, b
    ld d, e
    jr nz, jr_002_5757

    ld [hl+], a
    ld [hl-], a
    inc e
    inc [hl]
    jr jr_002_56e8

    ld [hl], a
    rst $38
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

jr_002_571a:
    inc bc
    dec bc

jr_002_571c:
    rlca
    sbc b
    ld h, b
    ldh [rP1], a
    ret nz

    nop
    jr nz, jr_002_56e5

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

jr_002_5757:
    cp b

jr_002_5758:
    ld b, b
    cp b
    ld [hl], b
    ret nc

    ld h, b
    ld a, [$d361]
    ld h, b
    ld h, d
    ld bc, $0205
    ld b, $03
    ld a, [bc]
    rlca
    dec c
    ld b, $16
    inc c
    dec bc
    ld b, $06

jr_002_5770:
    inc bc
    dec b
    inc bc
    ld [bc], a
    ld bc, $0001
    ld bc, $0100
    nop
    ld b, $01
    ld l, l
    cp $9f
    ld h, b
    ld h, b
    add b
    sub b
    ld h, b
    xor b
    ld [hl], b
    ld e, h
    jr c, jr_002_57c4

    inc e
    ld d, $0c
    add hl, bc
    ld b, $85
    inc bc
    add d
    ld bc, $0081
    ld b, b
    add b
    ld b, b
    add b
    and b
    ret nz

    ret nc

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
    add b
    nop
    ret nz

    add b
    jr nz, @-$3e

    and b
    ld b, b
    ld d, b
    jr nz, jr_002_5822

    jr nc, jr_002_5770

    ld a, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_57c4:
    nop
    nop
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
    ld bc, $0103
    ld [bc], a
    ld bc, $0102
    inc bc
    ld bc, $0103
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

    add b
    ld b, b
    add b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc c
    inc bc
    nop
    nop
    nop
    nop
    nop

jr_002_5822:
    nop
    nop
    nop
    nop
    nop
    nop
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
    db $f4
    jr c, jr_002_583e

jr_002_583e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr c, jr_002_585b

jr_002_585b:
    db $fc
    nop
    nop

jr_002_585e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop

jr_002_589e:
    nop
    ld [$3c00], sp
    nop
    ld a, [hl]
    nop
    ld a, [$f904]
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
    jr nz, jr_002_592c

    jr nz, jr_002_58be

jr_002_58be:
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0205
    ld a, [de]
    inc b
    inc l
    jr jr_002_5914

    jr nc, jr_002_585e

    ld h, b
    ld h, b
    add b
    ld b, b
    add b
    and b
    ret nz

    ldh [$c0], a
    ld d, b
    ldh [$f0], a
    ld h, b
    ret nc

    ld h, b
    ret nz

    nop
    ldh [$c0], a
    and b
    ret nz

    ret nz

    nop
    nop
    nop

jr_002_58e7:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $010a
    ld a, $01
    ld a, a
    ld bc, $05fa
    ld sp, hl
    ld b, $fd
    ld b, $7a
    dec b
    ld a, d
    dec b
    inc a
    rlca
    dec e

jr_002_5912:
    rrca
    dec a

jr_002_5914:
    dec de
    ld e, [hl]
    ld sp, $2051
    ld [hl], b
    jr nz, jr_002_598c

    jr nz, jr_002_589e

    nop
    add b
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    ld b, b

jr_002_592c:
    add b
    ld b, b
    add b
    ret nz

    nop
    ld b, b
    add b
    and b
    ret nz

    ldh [$c0], a
    ld d, b
    ldh [$f0], a
    ld h, b
    ret nc

    ld h, b
    ld d, $0f
    daa
    jr jr_002_599b

    jr nz, jr_002_58e7

    ld b, b
    or $61
    sbc d
    ld h, l
    ld a, l
    ld c, $3a
    inc e
    ld l, h
    jr nc, @+$26

    jr jr_002_5986

    jr jr_002_5970

    ld [$040a], sp
    ld a, [bc]
    inc b
    ld e, $04
    ld l, [hl]
    inc e
    jp c, Jump_000_3234

    call z, $f26d
    add hl, de
    and $f5
    ld [bc], a
    dec hl
    pop de
    add $39

jr_002_596b:
    ld l, e
    inc e
    ld e, $04
    ld [de], a

jr_002_5970:
    inc c
    inc e
    ld [$1038], sp
    ld d, b
    jr nz, jr_002_59c8

    jr nz, jr_002_5912

    ld h, b
    or h
    ld a, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add b

jr_002_5986:
    nop
    ret nz

    add b
    ld b, b
    add b
    add b

jr_002_598c:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_599b:
    nop
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
    ld bc, $0e1d
    ccf
    ld [de], a
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

jr_002_59bb:
    ld bc, $0100
    nop
    ld bc, $3f00
    nop
    call $fe3e
    rst $38
    ld sp, hl

jr_002_59c8:
    ld b, $b3
    ld a, h

jr_002_59cb:
    db $fd
    inc bc
    add hl, bc
    or $9e
    ld h, b
    ldh a, [rP1]
    ld h, b
    add b
    sbc c
    ld h, b
    reti


    jr nc, jr_002_596b

    ld h, b
    ld h, b
    ret nz

    cp $00
    rst $38
    nop
    and $18
    jp c, Jump_002_7c3c

    sbc b
    ret c

    ld h, b
    or h
    ld c, b
    ld l, h
    or b
    adc d
    ld [hl], h
    sbc $64
    and h
    ld b, b
    and b
    ld b, b
    ld b, b
    add b
    ld h, b
    add b
    jr nc, jr_002_59bb

    add sp, $70
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

jr_002_5a19:
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


    jr nc, jr_002_59cb

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
    ld d, c
    jr nz, jr_002_5a19

    ld [hl], b
    ld hl, sp+$40
    ret nz

    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_5a6b:
    nop
    nop
    ld bc, $0200
    ld bc, $0307
    dec c

jr_002_5a74:
    ld b, $0b
    inc b
    dec d
    ld [$1835], sp
    ld a, e
    inc a
    cp b
    ld b, b
    ld [$c8f0], sp
    jr nc, @-$42

    ld b, b
    sbc h
    ld h, b
    call nc, $f468
    ld l, b
    call nc, $3468
    ret z

    add sp, -$70
    ret nc

    jr nz, jr_002_5a74

    ld b, b
    ld b, b
    add b
    ld b, b
    add b
    ld h, b
    add b
    ld e, b
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
    inc e
    nop
    inc hl
    inc e
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

jr_002_5abb:
    ld bc, $0100
    nop
    ld bc, $1f00
    nop
    dec l
    ld e, $3e
    rra
    ld c, a
    inc a
    or l
    ld l, [hl]
    ld a, e
    add [hl]
    inc c
    di
    sbc [hl]
    ld h, c
    pop af
    nop
    ld h, b
    add b
    sbc c
    ld h, b
    reti


    jr nc, jr_002_5a6b

    ld h, b
    ld h, b
    ret nz

    cp $00
    rst $38
    nop
    and $18
    jp c, Jump_002_7c3c

    sbc b
    ret c

    ld h, b
    or h
    ld c, b
    ld l, [hl]
    or b
    ei
    ld b, $e5
    cp $fe
    nop
    and b
    ld b, b
    ld b, b
    add b
    ld h, b
    add b
    jr nc, jr_002_5abb

    add sp, $70
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

jr_002_5b2f:
    nop
    nop

jr_002_5b31:
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
    ld b, $00
    rrca
    nop
    rra
    nop
    dec a
    ld [bc], a
    ld a, $01
    dec a
    inc bc
    ld e, $01
    ld c, $01
    ld c, $01
    rlca
    inc bc
    rlca
    inc bc
    dec c
    ld b, $0b
    inc b
    ld [de], a
    inc c
    ld c, $04
    dec b
    ld [bc], a
    nop
    nop
    nop
    nop
    add b
    nop
    ret nz

jr_002_5b64:
    nop
    ld b, b
    add b
    ret nz

    add b
    ret nz

    nop
    ret nz

    nop
    jr nz, jr_002_5b2f

    jr nz, jr_002_5b31

    ld d, b
    ldh [$58], a
    ldh [$78], a
    ldh [$f8], a
    ld h, b
    ld hl, sp+$60
    sub h
    ld l, b
    nop

jr_002_5b7e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ldh [$fe], a
    ld h, b
    reti


jr_002_5b9c:
    ld h, [hl]
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

    jr nz, jr_002_5b64

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
    jr nz, jr_002_5c6c

    jr nz, jr_002_5b7e

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
    jr nz, jr_002_5c72

    jr nc, jr_002_5b9c

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

Jump_002_5c24:
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

jr_002_5c32:
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

jr_002_5c5b:
    nop
    nop
    rlca
    inc bc
    dec bc

jr_002_5c60:
    ld b, $07
    nop
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    ld [bc], a

jr_002_5c6c:
    ld bc, $0305
    ld b, $03
    dec b

jr_002_5c72:
    ld [bc], a
    ld a, [bc]
    inc b
    dec bc
    inc b
    rrca
    inc b
    dec de
    inc c
    dec a
    ld e, $70
    adc h
    adc h
    ld [hl], b
    ret c

    jr nz, @+$2a

    ret nc

    xor b
    ret nc

    ret c

    ldh a, [$d8]
    ldh a, [rBCPS]
    sub b
    ld d, b
    and b
    ret nc

    jr nz, jr_002_5c32

    ld b, b
    ldh [rLCDC], a
    ld b, b
    add b
    ld b, b
    add b
    jr nz, jr_002_5c5b

    ret c

    ldh [$bd], a
    ld b, d
    ld a, [bc]
    ldh a, [$c8]
    jr nc, jr_002_5c60

    ld b, b
    sbc h
    ld h, b
    call nc, $f468
    ld l, b
    call nc, $3468
    ret z

    add sp, -$70
    ret nc

    jr nz, @-$1e

    ld b, b
    ld b, b
    add b
    ld b, b
    add b
    ld h, b
    add b
    ld e, b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    or b
    ld h, b
    ld d, b
    jr nz, jr_002_5d1e

    db $10
    jr c, jr_002_5d09

    jr c, jr_002_5d0b

    jr z, jr_002_5d0d

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_5d09:
    nop
    nop

jr_002_5d0b:
    nop
    nop

jr_002_5d0d:
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

jr_002_5d18:
    inc c
    ld d, $0c
    dec c
    ld [bc], a
    nop

jr_002_5d1e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    jr jr_002_5d18

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
    inc d
    ld [$083e], sp
    ld a, a
    ld [$0c7b], sp
    ei
    inc c
    ld a, [$fb0c]
    inc c
    ld a, [c]
    inc c
    ld de, $090e
    ld b, $0d
    ld b, $0f
    ld b, $0f
    ld b, $1f
    ld b, $2d
    ld d, $49
    ld [hl], $60
    nop
    ret nc

    ld h, b
    or b
    ld h, b
    ld d, b
    jr nz, jr_002_5e6e

    db $10
    jr z, @+$12

    dec d
    ld [$081f], sp
    rrca
    inc b
    rlca
    ld [bc], a
    inc b
    inc bc
    rrca
    ld bc, $0007
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
    ldh [rP1], a
    ld hl, sp+$00
    db $fc

jr_002_5e6e:
    nop
    call c, $b020
    ld b, b
    ld l, b
    or b
    sub b
    ldh [$8c], a
    ld [hl], b
    ld e, d
    inc a
    dec a
    ld e, $00
    nop
    nop
    nop
    nop
    nop
    ld bc, $0300
    ld bc, $0102
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
    add b
    nop
    ld b, b
    add b
    ret nz

    add b
    ld b, b
    add b
    and b
    ld b, b
    ld d, e
    jr nz, jr_002_5f1f

    jr nc, jr_002_5ee9

    jr jr_002_5ecb

    ld [$040b], sp
    dec e
    ld b, $0e
    inc bc
    inc bc
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

jr_002_5ecb:
    nop
    nop
    ret nz

    nop
    ldh a, [rP1]
    ld hl, sp+$00
    cp b
    ld b, b
    ld h, b
    add b
    ld d, b
    ldh [$a0], a
    ld b, b
    db $10
    ldh [rSC], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_5ee9:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add a
    nop
    rst $08
    add b
    rst $38
    ld b, b
    ld c, a
    jr nc, jr_002_5f3c

    add hl, de
    ccf
    inc c
    inc e
    rlca
    inc b
    inc bc
    inc bc
    nop
    nop

jr_002_5f10:
    nop
    nop
    nop
    nop
    nop

jr_002_5f15:
    nop
    nop
    nop

jr_002_5f18:
    nop
    nop
    nop
    nop
    nop
    add b
    nop

jr_002_5f1f:
    ldh [rP1], a
    ldh a, [rP1]
    ld [hl], b
    add b
    ret nz

    nop
    and b
    ret nz

    ld h, b
    add b
    db $10
    ldh [$c8], a
    ldh a, [$b6]
    ld a, b
    ld e, c
    ld a, $2d
    ld e, $19
    ld b, $06
    ld bc, $0003
    nop

jr_002_5f3c:
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop

jr_002_5f43:
    inc e
    inc bc
    dec sp
    inc e
    inc l
    db $10
    ld e, b
    jr nc, jr_002_5fa4

    jr nc, jr_002_5fb6

    jr nc, @-$6e

    ld h, b
    ld [hl], b
    add b
    jr nz, jr_002_5f15

    ld a, b

jr_002_5f56:
    add b
    and a
    ld a, b
    reti


    ccf
    ccf
    nop
    ld d, b
    jr nz, jr_002_5f10

    ld h, b
    jr nc, jr_002_5f43

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
    jr c, jr_002_5f77

jr_002_5f77:
    adc $38
    or c
    adc $cf
    ld [bc], a
    dec [hl]
    jr jr_002_5fb8

    db $10
    jr z, @+$12

    jr z, @+$12

    ld e, b
    jr nc, jr_002_5f18

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

jr_002_5fa4:
    jr nc, jr_002_5f56

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

jr_002_5fb6:
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
    jr c, jr_002_5f77

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

    jr nc, jr_002_60be

    jr nc, jr_002_6090

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
    nop

jr_002_607e:
    nop
    nop
    nop
    nop
    nop
    nop
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
    dec bc

jr_002_6090:
    inc b
    inc e
    ld [$183c], sp
    jr c, jr_002_6097

jr_002_6097:
    nop
    nop
    nop
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
    ld b, $01
    ld a, [hl-]
    rlca
    reti


    ld a, $1e
    ldh [$e1], a
    nop
    ld b, $01
    dec bc
    inc b
    inc d
    ld [$081c], sp
    inc e
    ld [$0018], sp
    ld h, [hl]

jr_002_60be:
    jr jr_002_607e

    ld h, b
    ld [$5a74], a
    db $e4
    or h
    ret z

    ld l, h
    sbc b
    xor h
    jr jr_002_6100

    ld [$38c4], sp
    ld e, b
    ldh [$e0], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_60da:
    nop
    nop
    nop
    dec d
    ld c, $19
    ld b, $0e
    ld bc, $0708
    rrca
    nop
    dec bc
    ld b, $06
    inc bc
    dec b
    inc bc
    inc bc
    ld bc, $0102
    inc bc
    nop
    ld [bc], a
    ld bc, $0103
    ld [bc], a
    ld bc, $0205
    dec b
    ld [bc], a
    nop
    nop
    add b

jr_002_6100:
    nop
    ldh [rP1], a
    ret c

    jr nz, jr_002_60da

    jr c, jr_002_6136

    inc e
    sub [hl]
    inc c
    sbc d
    inc b
    ld d, [hl]
    adc h
    adc $84
    ld c, [hl]
    add h
    ld c, d
    add h
    add l
    ld [bc], a
    add l
    ld [bc], a
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

jr_002_6129:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6136:
    nop
    ret nz

    nop
    ld h, b
    ret nz

    ldh [rP1], a
    ld [$a6f0], sp
    ld a, b
    ld l, l
    ld e, $16
    rrca
    ld [$0707], sp
    nop
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
    dec bc
    inc b
    ld a, [hl-]
    rrca
    push de
    dec sp
    db $eb
    db $10
    or b
    ld b, b
    jr nz, jr_002_6129

    ret nc

    jr nz, jr_002_61bc

    ldh [$a8], a
    ld [hl], b
    ld [hl], h
    jr @+$19

    ld [$070b], sp
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
    add b
    nop
    ld h, b
    add b
    ld d, e
    ldh [$cf], a
    ld [hl-], a
    dec [hl]
    ld c, $0a
    inc b
    inc b
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    ld h, b
    add b
    sbc b
    ld h, b
    ld c, h
    jr c, jr_002_61c2

    db $10
    jr z, jr_002_61ad

    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    dec c
    ld b, $0d
    ld b, $07
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_61ad:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_61bc:
    nop
    nop
    nop
    ld bc, $0100

jr_002_61c2:
    nop
    inc bc
    nop
    inc bc
    nop
    inc bc
    nop
    ld bc, $0000
    nop
    nop
    nop
    inc bc
    nop
    dec b
    inc bc
    dec c
    ld b, $1e
    ld [$102e], sp
    ld e, a
    ld h, $dc
    ld h, a
    ldh a, [rP1]
    ld hl, sp+$00
    ld hl, sp+$00
    db $fc
    nop
    sbc h
    ld h, b
    db $ec

jr_002_61e8:
    ldh a, [$d8]
    ld h, b
    ld l, a
    db $10
    swap a
    ld l, $ff
    ld e, e
    cp h
    jp c, $7a3c

    inc a
    ld a, [hl]
    jr c, jr_002_61e8

    db $10
    and e
    call c, LoadRomBank
    nop
    nop
    ld b, $00
    dec b
    ld [bc], a
    rlca
    inc bc
    dec bc
    inc b
    inc [hl]
    ld [$30c8], sp
    ret nc

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
    ld bc, $0100
    nop
    ld bc, $0000
    nop
    ld bc, $0600
    ld bc, $071b
    dec hl
    inc e
    call c, $e020
    ret nz

    ld b, b
    add b
    adc a
    nop

jr_002_623b:
    dec de
    rrca
    ld a, b
    nop
    db $fc
    nop
    db $fc
    nop
    cp $00
    adc $30
    or $78
    db $ec
    jr nc, jr_002_623b

    db $10
    xor $ff
    ld a, a
    rst $38
    or a
    ld a, b
    or h
    ld a, b
    cp h
    ld [hl], b

jr_002_6257:
    adc h
    ld [hl], b
    xor $10
    ld b, l
    cp d
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
    rlca
    ld [bc], a
    ld b, $03
    dec de
    inc b
    db $ec
    jr @-$46

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
    ldh [rP1], a
    ld l, c
    add [hl]
    sub e
    inc c
    sub h
    ld [$88d4], sp
    jr z, jr_002_6257

    ret z

    jr nc, jr_002_62e2

    jr nc, jr_002_62bc

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc h
    db $db
    push af
    dec bc
    ld e, $01
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
    ld bc, $0100
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_62bc:
    nop
    add b
    nop
    ld b, b
    add b
    and b
    ret nz

    ldh a, [$60]
    ldh a, [rNR41]
    sub b
    ld h, b
    or b
    ld h, b
    ret nc

    ld h, b
    ldh [rLCDC], a
    and b
    ld b, b
    and b
    ret nz

    call c, Call_002_6c60
    jr jr_002_62f0

    nop
    nop
    nop

jr_002_62db:
    nop
    nop
    jr @+$11

    daa
    jr jr_002_6316

jr_002_62e2:
    jr jr_002_631c

    db $10
    xor b
    db $10
    add sp, -$70
    jr jr_002_62db

    ld hl, sp+$30
    jr nc, jr_002_62ef

jr_002_62ef:
    nop

jr_002_62f0:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c, e
    or a
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
    nop
    nop

jr_002_6316:
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_631c:
    nop
    ldh a, [$e0]
    sub b
    ld h, b
    or b
    ld h, b
    or b
    ld h, b
    ld [hl], b
    jr nz, jr_002_6378

    jr nz, jr_002_637a

    jr nz, jr_002_63aa

    jr nz, jr_002_6394

    inc a
    ld a, h
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

jr_002_637a:
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

jr_002_6394:
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

jr_002_63aa:
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

Call_002_6438:
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
    call z, Call_000_0cfe
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

    call c, Call_002_70a0
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

Call_002_6c60:
    nop
    nop
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
    jr jr_002_6d57

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
    jr jr_002_6d44

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

    jr nz, jr_002_6d72

    jr nc, jr_002_6d54

    nop
    ld a, h
    jr c, jr_002_6d94

jr_002_6d20:
    jr c, jr_002_6d9a

    jr nc, jr_002_6cdc

    ld [hl], b
    xor b
    ld [hl], b
    ld d, b
    and b
    jr nc, jr_002_6ceb

    ret nc

    jr nz, jr_002_6d5e

    ret nz

    jr z, @-$0e

    ret c

jr_002_6d32:
    jr nc, jr_002_6d20

    jr jr_002_6ccc

    ld l, h
    jp c, $146c

    add sp, -$58
    ld d, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6d44:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6d54:
    nop
    ld h, b
    nop

jr_002_6d57:
    or b
    ld h, b
    adc $70
    ld [hl], l
    ld c, $00

jr_002_6d5e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [$1400], sp

jr_002_6d72:
    ld [$183c], sp
    inc e
    ld [$0814], sp
    inc d
    ld [$040a], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6d94:
    nop
    jr nc, jr_002_6d97

jr_002_6d97:
    ld [hl], b
    jr nz, jr_002_6d32

jr_002_6d9a:
    ld h, b
    add sp, $70
    inc c
    inc bc
    ld b, $03
    ld b, $03
    rrca
    inc bc
    rrca
    inc bc
    ld e, $03
    inc c
    inc bc
    ld [bc], a
    ld bc, $0103
    inc bc
    ld bc, $0102
    ld [bc], a
    ld bc, $0106
    ld b, $01
    add hl, bc
    ld b, $0c

jr_002_6dbc:
    inc bc
    ret nz

    nop
    ldh a, [rP1]
    ld hl, sp+$00
    cp b
    ld b, b
    ldh [rP1], a
    ret nc

    ld h, b
    and b
    ld b, b
    ld b, b
    add b
    ld b, b
    add b
    ret nz

    add b
    ret nz

    add b
    ret nz

    add b
    ret nz

    add b
    ret nz

    add b
    ld b, b
    add b
    add b
    nop
    rrca
    inc b
    rrca
    inc b
    dec c
    ld b, $0b
    ld b, $0e
    inc bc
    rra
    inc bc
    ld c, $03
    ld [bc], a
    ld bc, $0103
    inc bc
    ld bc, $0102
    ld [bc], a
    ld bc, $0106
    ld b, $01
    add hl, bc
    ld b, $0c
    inc bc
    ld d, b
    jr nz, jr_002_6e5f

    jr nz, jr_002_6e81

    jr nz, jr_002_6e81

    ld [hl+], a
    ld c, e
    inc [hl]
    xor $37
    ld l, l
    ld [hl], $46
    jr c, jr_002_6e72

    jr jr_002_6e64

    jr c, jr_002_6e8a

    jr nc, jr_002_6dbc

    ld [hl], b
    add sp, $70
    xor b
    ld [hl], b
    ldh a, [rP1]
    sbc b
    ld h, b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

jr_002_6e5f:
    nop
    nop
    nop
    nop
    nop

jr_002_6e64:
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

jr_002_6e72:
    inc e
    inc e
    ldh [$60], a
    add b
    ret nz

    nop
    jr jr_002_6e7b

jr_002_6e7b:
    db $ec
    jr jr_002_6e7e

jr_002_6e7e:
    nop
    nop
    nop

jr_002_6e81:
    nop
    nop
    nop
    nop
    ld bc, $0300
    nop
    dec bc

jr_002_6e8a:
    nop
    dec e
    dec bc
    ld l, $1b
    ld [hl+], a
    dec e
    ld e, $01
    ld [de], a
    rrca
    rra
    ld c, $2d
    ld e, $2d
    ld e, $3f
    nop
    nop
    nop
    ldh a, [rP1]
    ld a, b
    nop
    db $fc
    nop
    or $08
    db $ec
    db $10
    ld a, [$541c]
    cp b
    ld a, b
    add b
    and b
    ld b, b
    ldh [rP1], a
    add b
    nop
    jr jr_002_6eb7

jr_002_6eb7:
    ld l, h
    jr @-$4a

    ld l, b
    db $e4
    ret c

    ld bc, $0000
    nop
    ld bc, $0700
    nop
    inc bc
    nop
    inc bc
    nop
    rlca
    nop
    ld a, [bc]
    rlca
    inc d
    rrca
    add hl, de
    ld c, $3d
    ld [de], a
    dec a
    ld d, $29
    ld d, $36
    add hl, de
    dec a
    ld a, [de]
    ld a, $00
    ldh [rP1], a
    db $fc
    nop
    cp $00
    add sp, $10
    ret c

    jr nz, @-$0a

    jr c, @-$56

    ld [hl], b
    ldh a, [rP1]
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
    add b
    nop
    nop
    nop
    nop
    nop
    ld bc, $0000
    nop
    ld bc, $0300
    nop
    rrca

jr_002_6f08:
    nop
    rlca
    nop
    inc bc
    nop
    rlca
    nop
    ld a, [bc]
    rlca
    ld c, $05
    inc de
    dec c
    dec e
    dec bc
    dec e
    dec bc
    inc e
    dec bc
    rla
    ld [$0000], sp
    ret nz

    nop
    ldh [rP1], a
    ldh a, [rP1]
    db $fc
    nop
    call nc, $b020
    ld b, b
    add sp, $70
    ld d, b
    ldh [$e0], a
    nop
    add b
    nop
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
    dec bc
    inc b
    dec c
    ld b, $0d
    ld b, $0d
    ld b, $12
    inc c
    inc e
    ld [$1824], sp
    jr z, @+$12

    jr c, jr_002_6f5f

    jr c, @+$12

    jr z, @+$12

    ld d, b
    jr nz, jr_002_6fc6

    jr nz, jr_002_6f08

    ld h, b
    ld e, b
    jr nc, jr_002_6f80

    jr jr_002_6f69

    inc b

jr_002_6f5f:
    dec c
    ld b, $0d
    ld b, $0d
    ld b, $09
    ld b, $05
    ld [bc], a

jr_002_6f69:
    dec bc
    ld b, $0f
    ld b, $0d
    ld b, $09
    ld b, $05

jr_002_6f72:
    ld [bc], a
    dec c
    ld [bc], a
    ld a, [bc]
    inc b
    ld c, $04
    dec c
    ld b, $09
    ld b, $a8
    ld d, b
    ld d, h

jr_002_6f80:
    jr c, jr_002_6fc0

    inc c
    dec bc
    ld b, $05
    ld [bc], a
    dec c
    ld b, $12
    inc c
    inc e
    ld [$1028], sp
    ld d, b
    jr nz, jr_002_7002

    jr nz, jr_002_6fdc

    jr nc, jr_002_6fd2

    jr jr_002_6fb4

    nop
    nop
    nop
    nop
    nop
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

jr_002_6fb4:
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

jr_002_6fc0:
    jr nc, jr_002_6f72

    ld h, b
    ldh [rLCDC], a
    ld b, b

jr_002_6fc6:
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

jr_002_6fd2:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_6fdc:
    nop
    daa
    add hl, de
    ld [de], a
    dec c
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
    nop
    ld a, b
    sub b
    cp b
    db $10
    dec hl

jr_002_7002:
    db $10
    dec d
    ld a, [bc]
    dec de
    ld c, $1e
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
    cpl
    db $10
    inc h
    dec de
    dec e
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
    or b
    ret nz

    cp b
    ld [hl], b
    ld l, b
    db $10
    jr c, jr_002_7059

    jr c, jr_002_705b

jr_002_704b:
    dec hl
    db $10
    dec d
    ld a, [bc]
    dec de
    ld c, $1e
    ld [$0018], sp
    nop
    nop
    nop
    nop

jr_002_7059:
    nop
    nop

jr_002_705b:
    nop
    nop
    dec a
    ld c, $3f
    inc c
    ld e, $01
    dec c
    inc bc
    ld [bc], a
    ld bc, $0001
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
    add b
    nop
    add b
    nop
    ld b, b
    add b
    ret nz

    add b
    jr nz, jr_002_704b

    ldh [rLCDC], a
    and b
    ld b, b
    ld d, b
    jr nz, @+$72

    jr nz, jr_002_70dc

    jr nc, jr_002_70c1

    db $10
    dec a
    ld [de], a
    inc de
    ld c, $1e
    ld [$0205], sp
    inc bc

Call_002_70a0:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_70a8:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

jr_002_70c1:
    dec b
    inc bc
    inc bc

jr_002_70c4:
    nop
    nop
    nop
    nop
    nop
    rrca
    nop
    rra
    nop
    rra
    nop
    ccf
    nop
    ccf
    nop
    ccf
    nop
    rra
    nop
    cpl
    rra
    ld e, l
    ccf
    ld c, l

jr_002_70dc:
    inc sp
    nop
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
    or b
    ld b, b
    ld c, b
    jr nc, jr_002_710e

jr_002_70ea:
    jr jr_002_70a8

    ld [$18a4], sp
    db $f4
    jr jr_002_70ea

    db $10
    ret c

    jr nc, @-$56

    ld [hl], b
    ld [hl], b
    ldh [rSVBK], a
    ldh [$d0], a
    ldh [rP1], a
    nop
    nop
    nop
    ld bc, $0100
    nop
    inc bc
    nop

jr_002_7107:
    inc bc
    nop
    inc bc
    nop
    inc bc
    nop
    dec c

jr_002_710e:
    inc bc
    scf
    rrca
    ld c, a
    jr nc, jr_002_70c4

    ld b, b
    sub b
    ld h, b
    ld h, b
    nop
    ld bc, $0e00
    ld bc, $0030
    db $fc
    nop
    ei
    inc b
    db $fc
    inc bc
    rst $38
    nop
    rst $38
    nop
    rst $28
    rra

jr_002_712b:
    db $dd
    ld a, $da
    db $fc

jr_002_712f:
    call c, $7cf8
    ld hl, sp-$0c
    ld a, b
    or h
    ld a, b
    ld c, a
    jr nc, jr_002_712f

    dec bc
    ld b, h
    cp e
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nz, jr_002_7107

    sub b
    ld h, b
    jr nc, jr_002_712b

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
    ldh a, [rP1]
    sbc b
    ldh a, [$e8]
    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld d, b
    nop
    add sp, $50
    sbc b
    ld [hl], b
    ld l, b
    db $10
    inc d
    ld [$040f], sp
    ld b, $03

Call_002_7173:
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
    rrca
    nop
    rra
    nop
    rra
    nop
    ccf
    nop
    ccf
    nop
    ccf
    nop
    rst $38
    nop
    call z, $bbf3
    ld a, a
    ld c, d
    ccf
    cpl
    rra
    rla
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
    add b
    nop
    add b
    nop
    ret nz

    nop
    ldh [rP1], a
    call c, $ea20
    inc e
    di
    cp $df
    ldh [$e9], a
    ld b, $93
    ld c, $9b
    ld c, $50
    nop
    add sp, $50
    ld e, b
    jr nc, jr_002_71f8

    ld [$040b], sp
    ld b, $03
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
    rlca
    nop
    rrca
    nop
    adc a
    nop
    rst $18
    add b
    ld a, a
    ret nz

    cp a
    ld h, b
    ld l, a
    jr nc, jr_002_7249

    jr c, jr_002_722d

    rra
    dec hl
    rra
    ld a, [de]

jr_002_71f8:
    rrca
    rla
    rrca
    rrca
    rlca
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
    ldh [rP1], a
    ldh [rP1], a
    ldh [rP1], a
    ret nz

    nop
    rst $38
    nop
    ei
    cp $9e
    ldh [$e8], a
    db $10
    ld a, b
    sub b
    ld e, b
    or b
    inc b
    nop
    rrca
    inc b
    ld a, [bc]
    rlca
    dec b
    ld [bc], a
    dec b
    ld [bc], a
    rlca
    ld [bc], a
    rlca
    ld [bc], a
    inc b
    inc bc

jr_002_722d:
    ld [bc], a
    ld bc, $0103
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

jr_002_7249:
    rrca
    nop
    sbc a
    nop
    sbc a
    nop
    ld a, a
    add b
    cp a
    ret nz

    ld a, a
    ret nz

    rst $18
    ld h, b
    xor a
    ld [hl], b
    ld [hl], a
    ccf
    ld e, [hl]
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
    nop
    add b
    nop
    add b
    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    add b
    nop
    db $fc
    nop
    or $fc
    ld a, $c0
    inc e
    nop
    inc l
    jr @+$36

    jr jr_002_72ac

    db $10
    ld d, b
    jr nz, jr_002_72f8

    jr nz, jr_002_72da

    jr nz, @-$5b

    ld b, b
    rst $10
    ld h, b
    sub a
    ld h, b
    ld l, a
    jr nc, @+$61

    jr nc, jr_002_72cd

    jr jr_002_72c3

    inc e
    dec e
    rrca
    rra
    rrca
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_72a3:
    nop
    nop
    nop
    nop

jr_002_72a7:
    nop
    nop
    nop
    nop
    ret nz

jr_002_72ac:
    nop
    ldh [rP1], a
    ldh [rP1], a
    ldh a, [rP1]
    ldh a, [rP1]
    ldh a, [rP1]
    ldh [rP1], a
    ret c

    ldh [$f6], a
    ld hl, sp-$6b
    ld h, e
    ei
    ld bc, $7996

jr_002_72c3:
    ld d, l
    ld a, [hl+]
    ld c, h
    inc sp
    ld h, $19
    dec d
    ld [$041a], sp

jr_002_72cd:
    inc sp
    ld e, $3e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_72da:
    nop
    nop
    nop
    ret nc

    ldh [$e0], a
    ret nz

    jr nz, jr_002_72a3

    ldh [rP1], a
    jr nz, jr_002_72a7

    ld d, b
    and b
    or b
    ld h, b
    or b
    ld h, b
    or b
    ld h, b
    ld l, b
    jr nc, jr_002_733a

    jr nc, jr_002_731c

    db $10
    jr z, @+$12

    ld e, b

jr_002_72f8:
    jr nc, jr_002_7352

    jr nc, jr_002_7334

    db $10
    inc de
    rrca
    inc de
    inc c
    dec c
    ld b, $06
    inc bc
    ld [bc], a
    ld bc, $0001
    ld c, $01
    inc c
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

jr_002_731c:
    nop
    ld c, a
    or b
    ldh a, [rP1]
    nop
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
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

jr_002_7334:
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_733a:
    nop
    nop
    nop
    ld e, b
    jr nc, jr_002_7398

    jr nc, jr_002_736a

    db $10
    add hl, hl
    db $10
    rla
    add hl, bc
    ld de, $1e0e
    ld [$0008], sp
    nop
    nop
    nop
    nop
    nop

jr_002_7352:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec bc
    rlca
    dec b
    inc bc
    rlca
    nop
    inc b
    inc bc
    ld a, [de]
    dec b
    ld l, c
    ld e, $b6

jr_002_736a:
    ld a, b
    sbc b
    ld h, b
    ld l, b
    jr nc, jr_002_73a4

    jr jr_002_7396

    jr jr_002_7388

    ld [$040a], sp
    ld [hl], e
    ld c, $66
    jr c, jr_002_73b4

    nop
    ld l, h
    sbc e
    rst $10
    add hl, sp
    ld a, [hl+]
    pop de
    ld sp, $41c0
    add b
    add c

jr_002_7388:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_7396:
    nop
    nop

jr_002_7398:
    nop
    nop
    nop
    nop
    nop
    add b
    nop
    add b
    nop
    sbc b
    nop
    ld a, b

jr_002_73a4:
    sub b
    sub b
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

jr_002_73b4:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec bc
    rlca
    rlca
    nop
    inc b
    inc bc
    ld b, $01
    add hl, bc
    ld b, $0d
    ld b, $16
    inc c
    inc l
    jr jr_002_73fa

    db $10
    ld a, [de]
    inc c
    ld d, $0c
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    dec b
    ld [bc], a
    dec b
    inc bc
    add hl, bc
    ld b, $fb
    db $10
    cpl
    jp nc, $ce31

    ld e, [hl]
    adc b
    sbc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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

jr_002_73fa:
    nop
    nop
    nop
    ld d, a

jr_002_73fe:
    ld a, $3f
    ld e, $2d
    ld e, $16
    dec c
    inc e
    inc bc
    ld de, $190e
    ld b, $16
    ld [$0c1a], sp
    inc l
    jr jr_002_7446

    jr jr_002_743c

    db $10
    ld e, b
    jr nz, jr_002_7460

    jr nc, jr_002_7452

    db $10
    inc h
    jr jr_002_73fe

    nop
    ld h, b
    ret nz

    ld h, b
    ret nz

    cp h
    ld b, b
    adc h
    ld a, b
    ld hl, sp+$40
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

jr_002_743c:
    nop
    dec d
    rrca
    rla
    rrca
    rrca
    rlca
    ld c, $07
    dec bc

jr_002_7446:
    inc b
    inc c
    inc bc
    ld [$0d07], sp
    ld [bc], a
    dec bc
    inc b
    dec c
    ld b, $0d

jr_002_7452:
    ld b, $16
    inc c
    ld [de], a
    inc c
    ld d, $08
    ld a, [de]
    inc c
    ld d, $0c
    push hl
    ld e, $f9

jr_002_7460:
    ld b, $92
    ld l, h
    or h
    ld l, b
    cp b
    ld h, b
    sbc $20
    add $3c
    ld a, h
    jr nz, jr_002_74ce

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr c, jr_002_748f

    jr z, jr_002_7491

    jr z, jr_002_7493

    daa
    jr jr_002_74b7

    rra
    ccf
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_002_748f:
    nop
    nop

jr_002_7491:
    nop
    nop

jr_002_7493:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, [de]
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
    nop
    nop

jr_002_74b7:
    nop
    nop
    nop
    nop
    nop
    nop
    inc e
    ld [$0814], sp
    ld a, [bc]
    inc b
    dec bc
    ld b, $12
    inc c
    inc [hl]
    jr jr_002_74e2

    nop
    nop
    nop
    nop

jr_002_74ce:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c, $04
    ld c, $04
    ld a, [bc]

jr_002_74e2:
    inc b
    ld a, [bc]
    inc b
    dec bc
    ld b, $12
    inc c
    inc a
    db $10
    jr nc, jr_002_74ed

jr_002_74ed:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

LoadStatusWindowTiles::
    ld hl, CompressedStatusWindowData
    ld de, $8d80
    jp DecompressTilesIntoVram


InitStatusWindow::
    ld hl, $787f
    ld de, $9ca0
    ld b, $04
    ld c, $14

jr_002_7510:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, jr_002_7510

    ld c, $14
    ld a, e
    add $0c
    ld e, a
    jr nc, jr_002_751f

    inc d

jr_002_751f:
    dec b
    jr nz, jr_002_7510

    ret


    ld hl, CreditScreenString
    ld de, $9800

DrawString::
    ld a, [hl+]
    or a
    ret z

    cp $0d
    jr z, jr_002_7546

    bit 7, a
    jr nz, jr_002_7542

    sub $20
    jr z, jr_002_7542

    sub $10
    cp $0a
    jr c, jr_002_7540

    sub $07

jr_002_7540:
    add $ce

jr_002_7542:
    ld [de], a
    inc e
    jr DrawString

jr_002_7546:
    ld a, e
    and $e0
    add $20
    ld e, a
    jr nc, DrawString

    inc d
    jr DrawString

    ld a, [CurrentHealth]
    srl a
    srl a
    ld de, $8f40
    cp $07
    jr nc, jr_002_756d

    push af
    ld a, [$c1b9]
    cp $07
    ld a, $07
    call nc, Call_002_7579
    pop af
    ld e, $60

jr_002_756d:
    call Call_002_7579
    ld [$c1b9], a
    cp $0d
    ret c

    jp CopyToOam


Call_002_7579:
    push af
    add a
    call Call_002_7583
    call CopyToOam
    pop af
    ret


Call_002_7583:
    swap a
    ld c, a
    and $0f
    ld b, a
    ld a, c
    and $f0
    ld c, a
    ld hl, $7ab1
    add hl, bc
    ret


    ld a, [JoyPadNewPresses]
    and $04
    ret z

    ld a, [JoyPadData]
    and $c0
    ret nz

    ld a, [WeaponSelect]
    inc a
    cp $05
    jr c, jr_002_75a7

    xor a

jr_002_75a7:
    ld [WeaponSelect], a
    ld b, $00
    ld c, a
    ld hl, $75ce
    add hl, bc
    ld de, $9ce8

jr_002_75b4:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_002_75b4

    ld a, $fc
    dec c
    jr z, jr_002_75c0

    xor a

jr_002_75c0:
    ld [de], a
    ld de, $8f30
    ld a, [hl]
    call Call_002_7583
    call Call_000_2030
    jp Jump_000_0fce


    ld e, $1e
    rra
    jr nz, @+$23

NintendoLicenseString::
    db "LICENSED BY NINTENDO", $00

PresentsString::
    db "PRESENTS", $00

MenuString::
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
    db "  LEVEL : NORMAL  ",0

PracticeString::
    db "PRACTICE", $00

JungleByDayString::
    db "JUNGLE BY DAY", $00

TheGreatTreeString::
    db "THE GREAT TREE", $00

DawnPatrolString::
    db " DAWN PATROL", $00

ByTheRiverString::
    db "BY THE RIVER", $00

InTheRiverString::
    db "IN THE RIVER", $00

TreeVillageString::
    db "TREE VILLAGE", $00

AncientRuinsString::
    db "ANCIENT RUINS", $00

FallingRuinsString::
    db "FALLING RUINS", $00

JungleByNightString::
    db "JUNGLE BY NIGHT", $00

TheWastelandsString::
    db "THE WASTELANDS", $00

LevelStringPointers::
    dw JungleByDayString, TheGreatTreeString, DawnPatrolString, ByTheRiverString
    dw InTheRiverString, TreeVillageString, AncientRuinsString, FallingRuinsString
    dw JungleByNightString, TheWastelandsString

CreditScreenString::
    db "EUROCOM DEVELOPMENTS", $0d, $0d, "DESIGN", $f6, " MAT SNEAP", $0d, "        DAVE LOOKER", $0d, "        JON WILLIAMS", $0d, "CODING", $f6, " DAVE LOOKER", $0d, "GRAPHX", $f6, " MAT SNEAP", $0d, "        COL GARRATT", $0d, "SOUNDS", $f6, " NEIL BALDWIN", $0d, "UTILS ", $f6, " TIM ROGERS", $0d, $0d, "     VIRGIN US", $0d, $0d, "PRODUCER", $f6, " ROBB ALVEY", $0d, "ASSISTANT", $f6, "KEN LOVE", $0d, "QA", $f6, "       MIKE MCCAA", $0d, $0d, "DISNEY", $f6, "   P GILMORE", $00

LevelString::
    db "LEVEL ", $00

CompletedString::
    db "COMPLETED", $00

GetReadyString::
    db "GET READY", $00

GameOverString::
    db "GAME OVER", $00

WellDoneString::
    db "WELL DONE", $00

ContinueString::
    db "CONTINUE", $f5, $00

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

CompressedStatusWindowData::
    db $80, $02, $de, $01, $00, $01, $31, $04, $e3, $41, $43, $25, $00, $fa, $19, $13
    db $19, $13, $13, $06, $a8, $02, $01, $61, $02, $b3, $07, $44, $ee, $44, $42, $c6
    db $00, $c6, $06, $01, $22, $18, $2c, $18, $3e, $34, $34, $63, $01, $63, $03, $c5
    db $00, $14, $18, $08, $18, $28, $10, $30, $10, $30, $13, $31, $d3, $22, $80, $88
    db $c7, $1c, $cb, $19, $18, $10, $0c, $18, $07, $9c, $07, $83, $31, $80, $84, $82
    db $01, $03, $03, $07, $82, $06, $c2, $87, $a6, $08, $20, $c2, $f1, $d7, $33, $36
    db $30, $30, $20, $30, $20, $70, $20, $60, $0c, $10, $d1, $60, $f0, $b1, $b8, $13
    db $39, $19, $1b, $30, $2b, $80, $20, $b0, $11, $0f, $06, $9e, $89, $b8, $91, $21
    db $b1, $01, $b1, $33, $31, $33, $11, $33, $12, $3b, $12, $0e, $12, $0e, $18, $04
    db $18, $00, $80, $46, $06, $01, $03, $02, $01, $02, $a1, $00, $80, $15, $80, $29
    db $00, $15, $46, $00, $68, $0e, $04, $0c, $cb, $99, $c7, $1c, $00, $c0, $82, $c3
    db $83, $c1, $81, $d8, $8c, $98, $8f, $8c, $0b, $06, $a1, $22, $00, $48, $c4, $c8
    db $7c, $de, $3e, $ca, $0c, $08, $04, $08, $04, $0c, $00, $0c, $0e, $40, $27, $24
    db $00, $30, $10, $30, $70, $20, $e6, $43, $c7, $52, $08, $10, $0d, $44, $12, $0e
    db $20, $20, $31, $10, $30, $20, $30, $14, $02, $90, $10, $20, $30, $06, $81, $5c
    db $f0, $6c, $ee, $44, $c0, $46, $8e, $c4, $3c, $c8, $78, $0b, $01, $22, $77, $22
    db $3e, $16, $16, $04, $0e, $04, $0c, $0c, $14, $18, $00, $18, $47, $21, $1f, $c5
    db $40, $c0, $47, $cc, $47, $c0, $47, $c8, $87, $22, $58, $09, $11, $4e, $80, $1f
    db $e2, $1f, $f0, $bf, $db, $4e, $94, $0f, $e4, $63, $c8, $07, $22, $80, $e0, $17
    db $c0, $81, $c0, $01, $c0, $00, $00, $c0, $a6, $14, $6b, $e0, $3f, $61, $bb, $94
    db $6d, $a3, $4f, $11, $21, $a8, $58, $84, $00, $80, $31, $00, $20, $82, $01, $81
    db $00, $20, $20, $68, $41, $00, $30, $01, $38, $02, $c0, $3b, $c0, $31, $c0, $20
    db $40, $00, $80, $03, $81, $82, $7a, $3a, $34, $4d, $10, $f1, $21, $db, $9a, $a7
    db $06, $1a, $7b, $24, $80, $a8, $db, $c1, $f3, $91, $30, $40, $34, $80, $8a, $0f
    db $c7, $8b, $f1, $d3, $f1, $fd, $f3, $ff, $5f, $01, $10, $fe, $01, $40, $a7, $bf
    db $bf, $9f, $9f, $0f, $8f, $87, $87, $83, $83, $81, $81, $00, $7f, $7f, $77, $7e
    db $6e, $74, $44, $78, $68, $10, $70, $60, $60, $40, $40, $8e, $18, $c1, $95, $90
    db $0a, $00, $10, $0c, $41, $40, $80, $c8, $48, $81, $03, $c0, $40, $82, $01, $00
    db $c3, $c3, $03, $00, $00, $f7, $f8, $11, $78, $fc, $5b, $22, $07, $44, $ff, $01
    db $60, $f8, $ff, $07, $00, $20, $14, $8e, $43, $3c, $7e, $c0, $78, $bf

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

Jump_002_7c3c:
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

CompressedFontData::
    db $90, $02, $4b, $02, $00, $80, $c4, $73, $f7, $32, $46, $00, $48, $23, $31, $b3
    db $63, $e1, $c1, $01, $00, $60, $60, $50, $18, $02, $42, $20, $00, $4b, $27, $10
    db $40, $34, $36, $e1, $c0, $82, $81, $67, $00, $20, $c4, $03, $5c, $67, $43, $0f
    db $0e, $67, $43, $7f, $07, $00, $32, $3c, $40, $84, $76, $26, $74, $66, $75, $7f
    db $07, $07, $06, $06, $00, $00, $73, $7f, $60, $40, $7e, $7c, $0b, $06, $17, $63
    db $6f, $17, $01, $e0, $0a, $40, $86, $01, $f9, $d0, $0e, $e4, $cd, $ec, $6e, $ec
    db $ce, $07, $11, $80, $f5, $f7, $27, $00, $86, $81, $01, $83, $01, $00, $52, $c0
    db $b5, $01, $60, $37, $1b, $73, $33, $7f, $1e, $37, $63, $7f, $66, $7e, $3c, $8c
    db $00, $26, $dc, $99, $19, $9b, $f9, $f2, $71, $30, $30, $48, $00, $ca, $61, $01
    db $3c, $9b, $b9, $b1, $bf, $bf, $39, $03, $00, $9c, $99, $99, $40, $00, $cf, $e6
    db $6e, $ec, $cf, $ef, $6c, $ec, $cd, $c8, $8f, $0f, $00, $e0, $c5, $e3, $67, $66
    db $0e, $04, $0c, $6c, $6c, $6c, $0f, $23, $00, $5c, $01, $d0, $90, $ef, $ce, $6c
    db $10, $f0, $74, $66, $e4, $c7, $c4, $87, $67, $00, $a0, $4b, $40, $04, $17, $00
    db $24, $fa, $f3, $03, $00, $c8, $f9, $81, $3b, $00, $62, $f1, $e1, $81, $81, $11
    db $80, $d0, $80, $00, $00, $3e, $1c, $76, $62, $e0, $40, $de, $14, $00, $5d, $7f
    db $32, $82, $00, $a6, $b1, $b1, $b3, $31, $b3, $b1, $2f, $b7, $23, $33, $a2, $85
    db $00, $10, $1e, $08, $18, $18, $10, $00, $38, $18, $38, $24, $82, $20, $00, $13
    db $0e, $04, $08, $80, $60, $e0, $60, $e0, $cc, $c0, $cf, $c6, $87, $03, $00, $20
    db $4c, $e8, $6c, $ec, $c9, $cc, $89, $0f, $8b, $cf, $8a, $ed, $cd, $2c, $23, $00
    db $64, $30, $70, $30, $60, $30, $70, $60, $70, $08, $00, $a8, $01, $78, $75, $62
    db $7f, $77, $3d, $7f, $17, $6b, $6a, $09, $c0, $a3, $b1, $00, $00, $95, $98, $d9
    db $9d, $d8, $de, $dc, $d7, $de, $53, $db, $d1, $02, $a8, $ec, $00, $52, $5c, $00
    db $00, $e9, $4c, $cc, $cd, $86, $07, $c3, $00, $40, $c4, $73, $37, $b3, $67, $e6
    db $c7, $07, $05, $06, $04, $06, $06, $06, $00, $e0, $c3, $f1, $27, $53, $37, $16
    db $36, $76, $67, $f6, $76, $f3, $b3, $d1, $11, $00, $22, $9f, $bd, $99, $37, $39
    db $1f, $be, $17, $33, $b1, $b3, $37, $06, $00, $d6, $8f, $c7, $de, $00, $b0, $ec
    db $c2, $e1, $60, $e0, $c3, $cc, $8b, $07, $00, $e0, $ed, $87, $01, $0c, $0c, $0c
    db $02, $80, $80, $c0, $10, $04, $a0, $c1, $04, $04, $88, $c6, $c6, $ee, $c4, $cc
    db $7c, $78, $30, $10, $00, $5c, $10, $73, $31, $73, $63, $77, $26, $3e, $34, $38
    db $1c, $1c, $0c, $c0, $a8, $91, $81, $b9, $19, $99, $31, $a7, $35, $af, $bf, $bf
    db $bb, $bb, $31, $00, $80, $b3, $b1, $31, $33, $37, $1a, $1e, $0c, $bb, $8c, $00
    db $58, $99, $99, $09, $00, $88, $60, $66, $c2, $e6, $c6, $de, $64, $6c, $38, $38
    db $18, $70, $18, $00, $54, $40, $3f, $07, $03, $0f, $05, $00, $28, $1a, $0c, $24
    db $98, $b9, $3f, $00, $00, $03, $02, $06, $04, $c6, $10, $1c, $68, $1a, $60, $34
    db $10, $0a, $48, $00, $25, $1c, $18, $1e, $0c, $42, $20, $70, $30, $f0, $60, $e0
    db $c0, $00, $00, $f8, $f1, $f8, $99, $39, $18, $78, $30, $70, $60, $20, $00, $60
    db $54, $04, $60, $06, $8a, $03, $03, $00, $00, $07, $86

    ld bc, $0008
    ld [bc], a

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
    db $43, $74, $01

    db $10
    and b
    rra
    inc b
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld [bc], a
