; Disassembly of "jb.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

    ld de, $c400

jr_006_4003:
    ld a, [hl+]
    bit 7, a
    jr nz, jr_006_400d

    ld [de], a
    inc e
    jr nz, jr_006_4003

    ret


jr_006_400d:
    and $7f
    jr nz, jr_006_4013

    or $80

jr_006_4013:
    ld b, a
    xor a

jr_006_4015:
    ld [de], a
    inc e
    ret z

    dec b
    jr nz, jr_006_4015

    jr jr_006_4003

    dec [hl]
    ld b, b
    ld l, d
    ld b, b
    sbc h
    ld b, b
    dec [hl]
    ld b, b
    ld sp, hl
    ld b, b
    ld [hl-], a
    ld b, c
    ld h, l
    ld b, c
    ld h, l
    ld b, c
    dec [hl]
    ld b, b
    ld [hl], a
    ld b, c
    adc [hl]
    ld b, c
    dec [hl]
    ld b, b
    sub e
    dec h
    ld h, $27
    jr z, jr_006_403c

    sbc a

jr_006_403c:
    ld bc, $02cc
    inc bc
    ld bc, $0604
    dec b
    rlca
    ld [$0900], sp
    ld a, [bc]
    dec bc
    add a
    ld bc, $8501
    inc b
    nop
    add hl, bc
    dec bc
    dec bc
    dec b
    inc b
    inc c
    dec c
    ld c, $0f
    adc c
    ld [bc], a
    add d
    ld a, [bc]
    and d
    ld b, $00
    add hl, bc
    dec bc
    add d
    dec bc
    add hl, bc
    ld b, $03
    sbc c
    inc bc
    add h
    ld b, b
    add b
    and a
    ld b, $82
    ld bc, $1101
    ld bc, $1312
    nop
    nop
    inc d
    dec d
    db $10
    db $10
    rlca
    db $10
    ld [$1610], sp
    rla
    db $10
    db $10
    jr jr_006_409e

    nop
    nop
    dec b
    db $10
    inc b
    nop
    add a
    ld b, c
    add l
    ld b, d
    add d
    ld bc, $1a01
    nop
    ld bc, $1091
    nop
    nop
    nop
    ld [$938e], sp
    dec h

jr_006_409e:
    ld h, $27
    jr z, jr_006_40a3

    sbc a

jr_006_40a3:
    ld bc, $02cc
    inc bc
    ld bc, $0604
    dec b
    rlca
    ld [$0900], sp
    ld a, [bc]
    dec bc
    add a
    ld bc, $8501
    inc b
    nop
    add hl, bc
    dec bc
    dec bc
    dec b
    inc b
    inc c
    dec c
    ld c, $0f
    adc c
    ld [bc], a
    add d
    ld a, [bc]
    add [hl]
    dec de
    inc e
    inc d
    dec e
    ld e, $1f
    jr nz, @+$12

    db $10
    ld de, $93ba
    dec h
    ld h, $27
    jr z, jr_006_40d7

    sbc a

jr_006_40d7:
    ld bc, $02cc
    inc bc
    ld bc, $0604
    dec b
    rlca
    ld [$0900], sp
    ld a, [bc]
    dec bc
    add a
    ld bc, $8501
    inc b
    nop
    add hl, bc
    dec bc
    dec bc
    dec b
    inc b
    inc c
    dec c
    ld c, $0f
    adc c
    ld [bc], a
    add d
    ld a, [bc]
    jp z, Jump_000_2593

    ld h, $27
    jr z, jr_006_4100

    sbc a

jr_006_4100:
    ld bc, $02cc
    inc bc
    ld bc, $0604
    dec b
    rlca
    ld [$0900], sp
    ld a, [bc]
    dec bc
    add a
    ld bc, $8501
    inc b
    nop
    add hl, bc
    dec bc
    dec bc
    dec b
    inc b
    inc c
    dec c
    ld c, $0f
    adc c
    ld [bc], a
    add d
    ld a, [bc]
    add [hl]
    dec de
    inc e
    inc d
    dec e
    ld e, $1f
    jr nz, @+$12

    db $10
    ld de, $2285
    ld hl, $2423
    or c
    ld b, b
    jp z, $dc41

    ld b, $82
    ld bc, $1101
    ld bc, $1312
    nop
    nop
    inc d
    dec d
    db $10
    db $10
    rlca
    db $10
    ld [$1610], sp
    rla
    db $10
    db $10
    jr jr_006_4167

    nop
    nop
    dec b
    db $10
    inc b
    nop
    add a
    ld b, c
    add l
    ld b, d
    add d
    ld bc, $1a01
    nop
    ld bc, $1091
    nop
    nop
    nop
    ld [$408e], sp
    add b

jr_006_4167:
    adc d
    ld bc, $9d01
    rlca
    ld [$1009], sp
    dec b
    inc b
    ld b, $0a
    dec bc
    ld [bc], a
    inc bc
    res 0, b
    ld bc, $0500
    inc b
    inc b
    ld bc, $0807
    add hl, bc
    ld bc, $2625
    and c
    ld bc, $0100
    nop
    sub c
    dec b
    add e
    ld [$00b9], sp
    ld bc, $0b82
    rlca
    nop
    ld [$0009], sp
    ld a, [bc]
    dec bc
    or [hl]
    inc bc
    add e
    ld [bc], a
    inc bc
    nop
    dec b
    inc b
    ld b, $d9
    inc c
    dec c
    ld c, $0f
    rst $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    ld bc, $0302
    inc b
    dec b
    ld b, $07
    ld [$0a09], sp
    dec bc
    inc c
    dec c
    ld c, $0f
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    add hl, bc
    add hl, bc
    ld a, [bc]
    ld a, [bc]
    dec bc
    dec bc
    inc c
    inc c
    dec c
    dec c
    ld c, $0e
    rrca
    rrca
    db $10
    db $10
    ld bc, $0201
    ld [bc], a
    inc bc
    inc bc
    inc b
    inc b
    dec b
    dec b
    ld b, $06
    rlca
    rlca
    ld [$1008], sp
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    stop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    db $10
    db $10
    rrca
    rrca
    ld c, $0e
    dec c
    dec c
    inc c
    inc c
    dec bc
    dec bc
    ld a, [bc]
    ld a, [bc]
    add hl, bc
    add hl, bc
    ld [$0708], sp
    rlca
    ld b, $06
    dec b
    dec b
    inc b
    inc b
    inc bc
    inc bc
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
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    rrca
    ld c, $0d
    inc c
    dec bc
    ld a, [bc]
    add hl, bc
    ld [$0607], sp
    dec b
    inc b
    inc bc
    ld [bc], a
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    nop
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    stop
    nop
    nop
    nop
    nop
    nop
    ld [$0708], sp
    rlca
    ld b, $06
    dec b
    dec b
    inc b
    inc b
    inc bc
    inc bc
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
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    rrca
    rrca
    ld c, $0e
    dec c
    dec c
    inc c
    inc c
    dec bc
    dec bc
    ld a, [bc]
    ld a, [bc]
    add hl, bc
    add hl, bc
    ld [$0708], sp
    rlca
    ld b, $06
    dec b
    dec b
    nop
    nop
    nop
    nop
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    stop
    nop
    nop
    nop
    db $10
    db $10
    db $10
    db $10

Jump_006_42bc:
    rrca

Jump_006_42bd:
    rrca
    rrca
    rrca
    ld c, $0e
    ld c, $0e
    dec c
    dec c
    dec c
    dec c
    inc c
    inc c
    inc c
    inc c
    dec bc
    dec bc
    dec bc
    dec bc
    ld a, [bc]
    ld a, [bc]
    ld a, [bc]
    ld a, [bc]
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    ld [$0808], sp
    ld [$0707], sp
    rlca
    rlca
    ld b, $06
    ld b, $06
    dec b
    dec b
    dec b
    dec b
    inc b
    inc b
    inc b
    inc b
    inc bc
    inc bc
    inc bc
    inc bc
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld bc, Entry
    ld bc, Entry
    ld bc, $0201
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc bc
    inc bc
    inc bc
    inc bc
    inc b
    inc b
    inc b
    inc b
    dec b
    dec b
    dec b
    dec b
    ld b, $06
    ld b, $06
    rlca
    rlca
    rlca
    rlca
    ld [$0808], sp
    ld [$0909], sp
    add hl, bc
    add hl, bc
    ld a, [bc]
    ld a, [bc]
    ld a, [bc]
    ld a, [bc]
    dec bc
    dec bc
    dec bc
    dec bc
    inc c
    inc c
    inc c
    inc c
    dec c
    dec c
    dec c
    dec c
    ld c, $0e
    ld c, $0e
    rrca
    rrca
    rrca
    rrca
    db $10
    db $10
    db $10
    stop
    nop
    nop
    nop
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
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
    ld bc, $0302
    inc b
    inc b
    inc b
    dec b
    dec b
    ld b, $06
    ld b, $06
    rlca
    rlca
    rlca
    rlca
    ld [$0808], sp
    ld [$0404], sp
    inc b
    inc bc
    ld [bc], a
    ld bc, $0503
    rlca
    add hl, bc
    dec bc
    dec c
    rrca
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    rrca
    rrca
    rrca
    ld c, $0d
    inc c
    dec bc
    ld a, [bc]
    add hl, bc
    ld [$0607], sp
    rlca
    ld b, $05
    inc b
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
    nop
    nop
    nop
    nop
    nop
    ld a, [bc]
    dec bc
    inc c
    dec c
    ld c, $0f
    db $10
    db $10
    db $10
    db $10
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    ld [bc], a
    inc bc
    inc bc
    inc b
    dec b
    ld b, $07
    ld [$0909], sp
    ld a, [bc]
    ld a, [bc]
    dec bc
    dec bc
    dec bc
    inc c
    inc c
    inc c
    inc c
    dec bc
    dec bc
    dec bc
    ld a, [bc]
    ld a, [bc]
    ld a, [bc]
    add hl, bc
    add hl, bc
    ld [$0808], sp
    rlca
    rlca
    ld b, $06
    ld b, $07
    rlca
    rlca
    ld [$0908], sp
    add hl, bc
    add hl, bc
    ld a, [bc]
    ld a, [bc]
    add hl, bc
    ld b, $05
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    add hl, bc
    ld a, [bc]
    dec bc
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    inc c
    dec bc
    ld a, [bc]
    add hl, bc
    inc bc
    dec b
    ld [$0909], sp
    ld a, [bc]
    dec bc
    inc c
    dec c
    dec c
    inc c
    inc c
    dec c
    dec c
    inc c
    dec bc
    ld [$0808], sp
    ld [$0708], sp
    rlca
    rlca
    rlca
    ld [$0909], sp
    ld [$0909], sp
    ld [$0403], sp
    dec b
    dec b
    ld b, $06
    ld b, $07
    ld [$0808], sp
    rlca
    ld b, $05
    inc b
    inc bc
    inc bc
    inc b
    dec b
    ld b, $07
    ld [$0808], sp
    rlca
    ld b, $06
    ld b, $05
    dec b
    inc b
    inc bc
    add hl, bc
    ld a, [bc]
    ld a, [bc]
    dec bc
    inc c
    inc c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    dec c
    inc c
    dec bc
    ld a, [bc]
    ld a, [bc]
    add hl, bc
    nop
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
    rrca
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
    ld bc, $0f00
    ld bc, $00ff
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $0f30
    ld c, h
    dec sp
    cp a
    ld [hl], b
    ld [hl], c
    add b
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
    rst $38
    nop
    ld [hl], b
    adc a
    ld c, $f5
    ld c, [hl]
    or l
    cp [hl]
    ld b, c
    sbc [hl]
    ld h, c
    ld a, [c]
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

jr_006_4526:
    nop
    nop
    jr c, jr_006_452a

jr_006_452a:
    sbc $28
    add hl, de
    and $ab
    ld a, [hl]
    cp $60
    ldh [rP1], a
    ldh [rP1], a
    ld b, b
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
    rlca
    nop
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
    nop
    nop
    nop
    nop
    nop
    ld bc, $0e00
    ld bc, $0f10
    inc l
    dec de
    rst $38
    jr nc, jr_006_4526

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
    rst $38
    nop
    nop
    rst $38
    db $76
    adc l
    ld c, $f5
    adc $31
    cp d
    ld b, c
    sbc c
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
    ld hl, sp+$00
    ld e, $e8
    sbc c
    ld h, [hl]
    xor e
    ld a, [hl]
    cp $00
    ld b, b
    add b

jr_006_45b6:
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
    nop
    rst $38
    nop
    nop
    rst $38
    push af
    ld e, $1f
    xor $9f
    ld h, b
    ld a, a
    add b
    inc sp
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
    jr c, jr_006_45ea

jr_006_45ea:
    sbc $28
    add hl, de
    and $6b
    cp [hl]
    ld a, [hl]
    and b
    ld h, b
    add b
    jr nz, jr_006_45b6

    ret nz

    nop

jr_006_45f8:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ldh [$1f], a
    dec d
    xor $9f
    ld l, [hl]
    ld a, a
    add b
    inc sp
    ret nz

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
    ld hl, sp+$00
    ld e, $e8
    ld e, c
    and [hl]
    ld l, e
    cp [hl]
    ld a, [hl]
    add b
    ld b, b
    add b
    jr nz, jr_006_45f8

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc c
    inc bc
    rla
    inc c
    inc d
    ld [$0000], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld hl, sp-$46
    ld a, h
    srl h
    ld a, $00
    nop
    nop
    inc a
    nop
    jr c, jr_006_468c

    jr z, jr_006_468e

    ld c, b
    jr nc, jr_006_46f5

    ld [$3c5b], sp
    ld c, l
    ld a, $26
    dec e
    inc hl
    dec e
    inc de
    dec c

jr_006_468c:
    ld c, $01

jr_006_468e:
    inc bc
    ld bc, $0103
    inc bc
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
    ccf
    nop
    adc $3f
    ld e, l
    xor $ee
    ld d, l
    cp e
    ld d, l
    cp e
    ld d, l
    xor d
    ld d, l
    rst $38
    ld de, $11bb
    cp e
    ld de, $11aa
    cp e
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
    rst $28
    ldh a, [$d6]
    rst $28
    db $ec
    ld d, e
    cp e
    ld d, h
    cp d
    ld d, l
    xor d
    ld d, l
    cp $11
    cp c
    db $10
    cp b
    db $10
    xor b
    db $10
    cp b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr jr_006_46e4

jr_006_46e4:
    db $fc
    db $10
    cp h
    ld e, b
    sbc b
    ld h, b
    adc b
    ld [hl], b
    ldh a, [rP1]
    cp $00
    ld a, l
    cp [hl]
    cp a
    ld h, b
    ld e, d

jr_006_46f5:
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
    inc c
    inc bc
    dec de
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
    ld hl, sp+$00
    sub h
    ld a, b
    ld a, [$cb3c]
    inc a
    ld a, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc c
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
    ldh a, [rP1]
    inc c
    ldh a, [$ba]
    ld a, h
    jp z, Jump_000_3c3c

    nop
    jr c, jr_006_478c

    jr z, @+$12

    ld c, b
    jr nc, jr_006_47f5

    ld [$3c5b], sp
    ld c, [hl]
    dec a
    daa
    dec e
    inc hl
    dec e
    ld [de], a
    dec c

jr_006_478c:
    rrca
    ld bc, $0103
    inc bc
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
    ccf
    nop
    rst $28
    ld d, $fe
    ld d, l
    rst $38
    ld d, l
    xor e
    ld d, l
    cp d
    ld d, l
    cp e
    ld d, l
    rst $38
    ld de, $11ab
    cp d
    ld bc, $0083
    nop
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
    rst $28
    ldh a, [$d6]
    ld l, a
    db $ec
    ld d, e
    cp e
    ld d, h
    cp d
    ld d, l
    xor d
    ld d, l
    cp $11
    cp c
    db $10
    cp b
    db $10
    xor b
    db $10
    jr c, jr_006_47d8

jr_006_47d8:
    inc [hl]
    ld [$103c], sp
    jr z, @+$12

    ld c, b
    jr nc, jr_006_4836

    jr z, @+$7c

    dec e
    ld c, a
    dec a
    daa
    dec e
    ld [hl+], a
    dec e
    inc de
    dec c
    rrca
    ld bc, $0103
    ld [bc], a
    ld bc, $0003
    nop

jr_006_47f5:
    nop
    nop
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

jr_006_4801:
    nop
    sbc $2f
    db $ed
    ld d, [hl]
    cp $55
    cp e
    ld d, l
    xor e
    ld d, l
    cp d
    ld d, l
    rst $38
    ld de, $11bb
    xor e
    ld de, $013a
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
    ldh a, [rP1]
    rst $38
    ldh [$ee], a
    rst $10
    db $fc
    ld d, e
    cp e
    ld d, h
    xor d
    ld d, l
    cp d
    ld d, l
    cp $11
    cp c
    db $10
    xor b
    db $10
    cp b
    nop

jr_006_4836:
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
    jr jr_006_4842

jr_006_4842:
    db $fc
    jr jr_006_4801

    ld d, b
    sbc b
    ld h, b
    adc b
    ld [hl], b
    ldh a, [rP1]
    add b
    nop
    cp $00
    ld a, l
    cp [hl]
    cp a
    ld h, b
    ld e, d
    inc a
    inc a
    nop
    rla
    inc c
    inc d
    ld [$102c], sp
    inc [hl]
    jr jr_006_488d

    db $10
    ld d, e
    inc l
    ld l, [hl]
    dec e
    ld b, a
    dec a
    inc hl
    dec e
    ld [hl+], a
    dec e
    inc de
    dec c
    rrca
    ld bc, $0103
    ld [bc], a
    ld bc, $0003
    nop
    nop
    ccf
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ccf
    nop
    rst $08
    ld a, $de
    ld l, l
    rst $28
    ld d, l
    cp e
    ld d, l
    cp d
    ld d, l
    xor e

jr_006_488d:
    ld d, l
    rst $38
    ld de, $11bb
    cp d
    ld de, $10ab
    jr c, jr_006_4898

jr_006_4898:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    rst $28
    ret nc

    cp $57
    db $fc
    ld d, e
    xor e
    ld d, h
    cp d
    ld d, l
    cp d
    ld d, l
    cp $11
    xor c
    db $10
    cp b
    nop
    add b
    nop
    nop
    nop
    inc [hl]
    ld [$103c], sp
    jr z, jr_006_48ce

    ld c, b
    jr nc, @+$56

    jr z, jr_006_493e

    inc e
    ld c, l
    ld a, $26
    dec e
    inc hl
    dec e
    inc de
    dec c
    ld a, [bc]
    dec b

jr_006_48ce:
    rlca
    ld bc, $0103
    inc bc
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
    ccf
    nop
    sbc $2d
    ld l, a
    push de
    rst $38
    ld d, l
    cp d
    ld d, l
    xor e
    ld d, l
    cp e
    ld d, l
    rst $38
    ld de, $11ba
    xor e
    db $10
    cp b
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
    ldh a, [rP1]
    rst $38
    ld h, b
    xor $57
    db $fc
    ld d, e
    cp e
    ld d, h
    xor d
    ld d, l
    cp d
    ld d, l
    cp $11
    cp c
    db $10
    xor b
    db $10
    jr c, jr_006_4916

jr_006_4916:
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0600
    ld bc, $0708
    rla
    rrca
    jr z, jr_006_4945

    ld e, b
    ccf
    ld l, b
    scf
    sub b
    ld l, a
    and b
    ld e, a
    push bc
    dec sp
    swap a

jr_006_4932:
    cp a
    ld b, h
    adc $3f
    rst $38
    nop
    nop
    nop
    inc bc
    nop
    rst $38
    ld [bc], a

jr_006_493e:
    rlca
    ei
    db $e3
    db $fc
    ld hl, sp-$01
    dec de

jr_006_4945:
    db $fc
    jr nc, @+$01

    add b
    ld a, a
    ld b, b
    cp a
    ld d, c
    xor [hl]
    ld e, a
    and b
    rst $18
    jr nz, jr_006_4932

    jr nz, @+$08

    ei
    rst $38
    nop
    nop
    nop
    ldh a, [rP1]
    ldh a, [$80]
    ld [$94f0], sp
    ld a, b
    ld a, d
    db $fc
    ld [bc], a
    db $fc
    cp $00
    inc b
    ld hl, sp-$08
    nop
    ldh [rP1], a
    ret nz

    add b
    ldh a, [$80]

jr_006_4972:
    db $ec
    sub b
    sub $ac
    rst $38
    nop
    nop
    nop
    inc bc
    nop
    rst $38
    ld [bc], a
    rlca
    ei
    db $e3
    db $fc
    ld hl, sp-$01
    add hl, de
    cp $30
    rst $38
    add b
    ld a, a
    ld b, b
    cp a
    ld d, c
    xor [hl]
    ld e, a
    and b
    rst $18
    jr nz, jr_006_4972

    jr nz, @+$08

    ei
    rst $38
    nop
    nop
    nop
    ldh [rP1], a
    ld hl, sp-$80
    or h
    ld a, b
    ld [c], a
    ld a, h
    ld e, $e0
    cp $00
    db $f4
    ld [$f804], sp
    ld hl, sp+$00
    ldh [rP1], a
    ret nz

    add b
    ldh a, [$80]

jr_006_49b2:
    db $ec
    sub b
    sub $ac
    rst $38
    nop
    nop
    nop
    rlca
    nop
    rst $38
    ld bc, $fb07
    db $e3
    db $fc
    ld hl, sp-$01
    add hl, de
    cp $30
    rst $38
    add b
    ld a, a
    ld b, b
    cp a
    ld d, c
    xor [hl]
    ld e, a
    and b
    rst $18
    jr nz, jr_006_49b2

    jr nz, @+$08

    ei
    rst $38
    nop
    ret nz

    nop
    ld hl, sp+$00
    and h
    ld a, b
    or h
    ld a, b
    ld c, h
    ldh a, [$38]
    ret nz

    db $f4
    ld [$04fa], sp
    inc b
    ld hl, sp-$08
    nop
    ldh [rP1], a
    ret nz

    add b
    ldh a, [$80]
    db $ec
    sub b
    sub $ac
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
    rlca
    nop
    ld [$1207], sp
    rrca
    inc sp
    inc c
    ld a, l
    ld b, $7b
    daa
    db $dd
    inc sp
    rst $20
    jr jr_006_4a19

jr_006_4a19:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    adc h
    ldh a, [$da]
    ld a, h
    dec c
    cp $99
    cp $39
    adc $00
    nop
    nop
    nop
    ld bc, $0600
    ld bc, $0708
    rla
    rrca
    inc l
    rra
    ld e, b
    ccf
    ld h, b
    ccf
    add b
    ld a, a
    add b
    ld a, a
    sbc a
    ld h, b
    sbc [hl]
    ld a, a
    add e
    ld a, a
    ld b, b
    ccf
    inc a
    inc bc
    nop
    nop
    inc bc
    nop
    rst $38
    ld [bc], a
    rlca
    ei
    db $e3
    db $fc
    ld hl, sp-$01
    dec de
    db $fc
    jr nc, @+$01

    nop
    rst $38
    nop
    rst $38
    ld de, $1fee
    ldh [$9f], a
    ld h, b
    ld e, a
    and b
    ld d, [hl]
    xor c
    ld e, [hl]
    and c
    nop
    nop
    ldh a, [rP1]
    ldh a, [$80]
    ld [$94f0], sp
    ld a, b
    ld a, d
    db $fc
    ld [bc], a
    db $fc
    cp $00
    inc b
    ld hl, sp-$08
    nop
    ldh [rP1], a
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
    nop
    nop
    nop
    nop
    ld bc, $0600
    ld bc, $0708
    rla
    rrca
    inc l
    rra
    ld e, b
    ccf
    ld h, b
    ccf
    add b
    ld a, a
    add b
    ld a, a
    add b
    ld a, a
    sbc b
    ld [hl], a
    sub h
    ld a, e
    sbc a
    ld a, b
    sbc l
    ld a, d
    nop
    nop
    inc bc
    nop
    rst $38
    ld [bc], a
    rlca
    ei
    db $e3
    db $fc
    ld hl, sp-$01
    dec de
    db $fc
    jr nc, @+$01

    nop
    rst $38
    nop
    rst $38
    ld de, $1fee
    ldh [$5d], a
    and d
    ld e, a
    and d
    cp [hl]
    ld b, h
    ld [hl], $cc
    nop
    nop
    ldh a, [rP1]
    ldh a, [$80]
    ld [$94f0], sp
    ld a, b
    ld a, d
    db $fc
    ld [bc], a
    db $fc
    cp $00
    inc b
    ld hl, sp-$08
    nop
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
    inc bc
    nop
    rst $38
    ld [bc], a
    rlca
    ei
    db $e3
    db $fc
    ld hl, sp-$01
    add hl, de
    cp $30
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld de, $1fee
    ldh [$5d], a
    and d
    ld e, a
    and d
    cp [hl]
    ld b, h
    ld [hl], $cc
    nop
    nop
    ldh [rP1], a
    ld hl, sp-$80
    or h
    ld a, b
    ld [c], a
    ld a, h
    ld e, $e0
    cp $00
    db $f4
    ld [$f804], sp
    ld hl, sp+$00
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
    rlca
    nop
    rst $38
    ld bc, $fb07
    db $e3
    db $fc
    ld hl, sp-$01
    add hl, de
    cp $30
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld de, $1fee
    ldh [$5d], a
    and d
    ld e, a
    and d
    cp [hl]
    ld b, h
    ld [hl], $cc
    ret nz

    nop
    ld hl, sp+$00
    and h
    ld a, b
    or h
    ld a, b
    ld c, h
    ldh a, [$38]
    ret nz

    db $f4
    ld [$04fa], sp
    inc b
    ld hl, sp-$08
    nop
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
    add hl, bc
    rlca
    inc de
    ld c, $26
    inc e
    inc h
    jr jr_006_4bad

    jr jr_006_4b99

    inc c
    dec bc
    ld b, $04
    inc bc
    inc bc
    nop
    nop
    nop

jr_006_4b8c:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    sub e

jr_006_4b99:
    ld l, h
    ld h, h
    jr @-$76

    ld [hl], b
    sub b
    ld h, b
    sub b
    ld h, b
    ld c, b
    jr nc, jr_006_4b8c

    jr jr_006_4bb7

    rst $28
    rst $38
    nop
    nop
    nop
    nop

jr_006_4bad:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_4bb5:
    nop
    nop

jr_006_4bb7:
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
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0305
    inc b
    inc bc
    rlca
    ld [bc], a
    add hl, bc
    ld b, $0e
    inc b
    ld a, [bc]
    inc b
    ld a, [bc]

jr_006_4bf3:
    inc b
    inc d

jr_006_4bf5:
    ld [$0018], sp
    inc d
    ei
    jr c, jr_006_4bf3

    jr z, jr_006_4bf5

    ld e, b
    rst $20
    ld sp, $52ce
    adc h
    ld d, d
    adc h
    and h
    jr jr_006_4bad

    jr jr_006_4c33

    db $10
    ld c, b
    jr nc, jr_006_4c5f

    jr nz, jr_006_4c61

    jr nz, jr_006_4c63

    jr nz, jr_006_4bb5

    ld b, b
    ret nz

    nop
    db $fc
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_4c33:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_4c40:
    ld bc, $0300
    nop
    ld [bc], a
    ld bc, $0304
    dec b
    inc bc
    dec b
    inc bc
    inc b
    inc bc
    rlca
    nop
    ld [$f907], sp
    ld c, $26
    ld hl, sp-$08
    nop
    nop
    nop
    nop
    nop
    rra

jr_006_4c5d:
    nop
    ld [c], a

jr_006_4c5f:
    dec e
    ld a, [bc]

jr_006_4c61:
    db $fd
    ld l, c

jr_006_4c63:
    sbc [hl]
    cp d
    ld a, l
    ld [hl], d
    adc l

jr_006_4c68:
    ld e, c
    cp [hl]
    xor d
    db $dd
    cp d
    push bc

jr_006_4c6e:
    ld hl, $ffde
    nop
    db $fd
    nop
    add [hl]
    ld a, b
    or e
    ld a, h
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr c, jr_006_4c40

    call z, $93f0
    ld l, h
    rst $10
    xor $cd
    ld a, [c]
    sub a
    ld l, [hl]
    rst $10
    xor $cd
    ld a, [c]
    ld de, $feee
    nop
    cp $00
    ld e, c
    ld a, $7c
    nop
    jr jr_006_4c9a

jr_006_4c9a:
    ld h, $18
    ld e, l
    ld a, $5f
    jr nc, jr_006_4c5d

    ld h, b
    sbc a
    ld h, b
    inc a
    ret nz

    jr nc, jr_006_4c68

    ld a, b
    or b
    ld a, b
    and b
    jr c, jr_006_4c6e

    jr z, @-$0e

    or h
    ld a, b
    ld [hl], h
    jr c, jr_006_4cf1

    jr jr_006_4cd3

    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_4cbe:
    ld bc, $0300
    nop
    ld [bc], a
    ld bc, $0304
    dec b
    inc bc
    dec b
    inc bc
    inc b
    inc bc
    rlca
    nop
    inc b
    inc bc
    ld [$7507], sp

jr_006_4cd3:
    ld c, $16
    ld a, b
    ld a, b
    nop
    nop
    nop
    rra
    nop
    ld [c], a
    dec e
    ld a, [bc]
    db $fd
    ld l, c
    sbc [hl]
    cp d
    ld a, l
    ld [hl], d
    adc l
    ld e, c
    cp [hl]
    xor d
    db $dd
    cp d
    push bc
    ld hl, $ffde
    nop
    db $fd

jr_006_4cf1:
    nop
    add h
    ld a, b
    or d
    ld a, h
    ccf
    nop
    nop
    nop
    ret nz

    nop
    jr c, jr_006_4cbe

    call z, $93f0
    ld l, h
    rst $10
    xor $cd
    ld a, [c]
    sub a
    ld l, [hl]
    rst $10
    xor $cd
    ld a, [c]
    ld de, $ffee
    nop
    cp $00
    ld c, a
    jr nc, jr_006_4d57

    inc a
    ld e, c
    ld a, $00
    nop
    rlca
    nop
    ld a, [hl-]
    rlca
    ld b, a
    inc a
    or [hl]
    ld a, b
    ld a, $c0
    scf
    ret nz

    ld a, b
    or b
    ld a, b
    and b
    inc [hl]
    ret z

    inc a
    ld hl, sp-$66
    ld a, h
    ld c, [hl]
    inc a
    ld [hl], $0c
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

jr_006_4d40:
    ld bc, $0300
    nop
    ld [bc], a
    ld bc, $0304
    dec b
    inc bc
    dec b
    inc bc
    inc b
    inc bc
    rlca
    nop
    ld [$3507], sp
    ld c, $0a
    inc a
    inc a

jr_006_4d57:
    nop
    nop
    nop
    nop
    nop
    rra
    nop
    ld [c], a
    dec e
    ld a, [bc]
    db $fd
    ld l, c
    sbc [hl]
    cp d
    ld a, l

jr_006_4d66:
    ld [hl], d
    adc l
    ld e, c
    cp [hl]
    xor d
    db $dd
    cp d
    push bc
    ld hl, $ffde
    nop
    rst $38
    nop
    or $0f
    ld sp, hl
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr c, jr_006_4d40

    call z, $93f0
    ld l, h
    rst $10
    xor $cd
    ld a, [c]
    sub a
    ld l, [hl]
    rst $10
    xor $cd
    ld a, [c]
    ld de, $feee
    nop
    cp $00
    rrca
    ldh a, [$64]
    ld hl, sp+$00
    nop
    nop
    nop
    nop
    nop

jr_006_4d9e:
    inc a
    nop
    jp Jump_000_1f3c


    rst $38
    jr nc, jr_006_4d66

    ld a, b
    or b
    ld a, b
    and b
    inc [hl]
    ret z

    ld a, [hl-]
    db $fc
    sbc [hl]
    ld a, h
    ld h, l
    ld e, $1b
    ld b, $06
    nop
    nop
    nop
    nop
    nop
    rra
    nop

jr_006_4dbc:
    ld [c], a
    dec e
    ld a, [bc]
    db $fd
    ld l, c
    sbc [hl]
    cp d
    ld a, l
    ld [hl], d
    adc l
    ld e, c
    cp [hl]
    xor d
    db $dd
    cp d
    push bc
    ld hl, $ffde
    nop
    rst $38
    nop
    ld [hl], e
    inc c
    ld [hl], b
    rrca
    ld d, $0f
    nop
    nop
    ret nz

    nop
    jr c, jr_006_4d9e

    call z, $93f0
    ld l, h
    rst $10
    xor $cd
    ld a, [c]
    sub a
    ld l, [hl]
    rst $10
    xor $cd
    ld a, [c]
    ld de, $ffee
    nop
    cp $00
    ld h, h
    ld hl, sp-$62
    nop
    ld e, a
    add b
    nop
    nop
    jr nc, jr_006_4dfc

jr_006_4dfc:
    ld c, b
    jr nc, jr_006_4e75

    jr c, jr_006_4dbc

    ld l, h
    ld sp, $30c0
    ret nz

    ld a, b
    or b
    ld a, b
    and b
    inc [hl]
    ret z

    inc a
    ld hl, sp-$66
    ld a, h
    ld c, [hl]
    inc a
    ld [hl], $0c
    inc c
    nop
    nop
    nop
    rlca
    nop
    inc e
    inc bc
    ld [hl+], a
    dec e
    ld d, [hl]
    add hl, sp
    ld c, c
    ld [hl], $a3
    ld a, h
    cp d
    ld a, l
    adc h
    ld a, a
    db $ed
    ld [de], a
    sub d
    ld l, l
    ld d, l
    ld l, $56
    add hl, sp
    dec h
    ld a, [de]
    add hl, de
    rlca
    rlca
    nop
    nop
    nop
    call nz, $3a00
    call nz, $f6cd
    rst $30
    ld a, [$fa57]
    daa
    jp c, Jump_006_42bd

    xor l
    ld d, d
    jp nc, $b22c

    ld l, h
    ld l, h
    ldh a, [$3c]
    ret z

    add sp, $30
    or b
    ret nz

    ret nz

    nop
    nop
    nop
    inc bc
    nop
    dec c
    ld [bc], a

jr_006_4e5c:
    ld de, $2e0e
    add hl, de
    ld hl, $5d1e
    ld h, $4a
    dec [hl]
    ld [hl], l
    ld a, [hl+]
    ld [hl], e
    inc l
    ld d, l
    ld l, $3e
    rla
    dec hl
    inc d
    inc e
    dec bc
    inc c
    inc bc
    inc bc

jr_006_4e75:
    nop
    nop
    nop
    ldh [rP1], a
    jr jr_006_4e5c

    ld h, h
    ld hl, sp+$4a
    db $fc
    jp nc, $8bec

    db $f4
    ld l, l
    sub d
    ld sp, $cdce
    ld a, $1d
    cp $ea
    inc e
    ld e, d
    cp h
    add $38
    db $fd
    ld b, $3a
    db $fc

jr_006_4e96:
    db $fc
    nop
    nop
    nop
    inc bc
    nop
    dec c

jr_006_4e9d:
    inc bc
    rla
    inc c
    inc a
    inc de
    ld [hl], $0f
    ld c, l
    ld [hl], $4b
    inc [hl]
    or l
    ld c, d
    cp l
    ld b, d
    db $e4
    ld e, e
    ld [$ef5f], a
    ld e, a
    or e
    ld l, a
    ld e, h
    inc hl
    inc hl
    nop
    nop
    nop
    ldh [rP1], a
    sbc b
    ldh [$a4], a
    ld e, b
    ld l, d
    sbc h
    xor d
    ld [hl], h
    ld c, c
    or [hl]
    or a
    ld c, b
    ld sp, $5dfe
    cp [hl]
    push bc
    ld a, $92
    ld l, h

jr_006_4ed0:
    ld l, d
    sbc h
    ld b, h
    cp b
    jr c, jr_006_4e96

    ldh [rP1], a
    ccf
    nop
    ld e, h
    ccf
    cp a
    ld h, b
    ld h, e
    inc e
    ld e, d
    dec a
    ld d, a
    jr c, jr_006_4e9d

    ld a, a
    or e
    ld a, h
    adc h
    ld [hl], e
    or [hl]
    ld c, c
    pop de
    cpl
    ld c, e
    scf
    ld d, d
    ccf
    ld h, $1f
    jr @+$09

    rlca
    nop
    nop
    nop
    ret nz

    nop
    jr nc, @-$3e

    jr c, jr_006_4ed0

    call nc, Call_006_7c28
    add sp, -$56
    ld [hl], h
    adc $34
    xor [hl]
    ld d, h
    ld d, d
    xor h
    cp d
    ld h, h
    add h
    ld a, b
    ld [hl], h
    sbc b
    adc b
    ld [hl], b
    or b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld l, [hl]
    nop
    reti


    ld h, $e6
    add hl, de
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    or b
    nop
    db $ec
    sub b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz, jr_006_4f98

jr_006_4f98:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [$0000], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld d, b
    nop
    inc b
    inc bc
    rrca
    nop
    add hl, sp
    rlca
    rra
    nop
    ld a, e
    rlca
    ld h, $19
    ld a, d
    rlca
    ld d, [hl]
    add hl, bc
    dec a
    inc bc
    dec l
    ld [bc], a
    dec de
    inc b
    dec de
    inc b
    dec c
    nop
    ld [$0000], sp
    nop
    nop
    nop
    reti


    and $ec
    rra
    call z, $81f3
    ld a, [hl]
    sub b
    rst $38
    add hl, hl

jr_006_5003:
    rst $10
    ld d, c
    cp [hl]
    and b
    rst $18
    ld e, c
    cp [hl]
    sbc a
    ld h, b
    ld a, b
    add a
    add e
    ld a, a
    sbc a
    ld h, b
    sbc a
    ld h, b
    and [hl]
    ld a, b
    or e
    ld a, h
    or d
    ld l, h
    dec de
    or $a4
    db $db
    ld d, b
    rst $28
    add e
    ld a, h
    ld [hl+], a
    db $fd
    or c
    sbc $00
    rst $38
    inc bc
    rst $38
    add $3f
    add hl, bc
    cp $9d
    ld [c], a
    rst $08
    jr nc, jr_006_5003

    ccf
    rst $18
    inc a
    ld c, h
    jr nc, jr_006_5085

    nop
    ret nc

    nop
    cp $00
    ret z

    jr nc, jr_006_5045

    ld hl, sp+$3c
    ret nz

    cp h

jr_006_5045:
    ld d, b
    ld e, d
    db $e4
    ld a, c
    cp $3d
    ld a, [$3edd]
    ld h, $18
    sbc h
    nop
    add b
    nop
    nop
    nop
    nop
    nop
    inc b
    inc bc
    rra
    nop
    ld de, $2f0f
    db $10
    dec de
    rlca
    ld h, $19
    ld a, [de]
    rlca
    ld [hl], $09
    dec e
    inc bc
    dec c
    ld [bc], a
    dec de
    inc b
    dec bc
    inc b
    dec b
    nop
    ld bc, $0000
    nop
    nop
    nop
    reti


    and $ed
    rra
    call z, $81f3
    ld a, [hl]
    sub d
    rst $38
    add hl, hl
    rst $10
    ld d, b

jr_006_5085:
    cp a
    and b
    rst $18
    ld e, c
    cp [hl]
    sbc a
    ld h, b
    ld a, b
    add a
    add e
    ld a, a
    ld e, a
    ldh [$cf], a
    ldh a, [$c6]
    jr c, jr_006_5097

jr_006_5097:
    nop
    sub $68
    dec hl
    or $a4
    db $db
    db $10
    rst $28
    jp Jump_000_227c


    db $fd
    ld hl, $00de
    rst $38
    ld [bc], a
    rst $38
    add $3f
    add hl, bc
    cp $9d
    ld [c], a
    rst $08
    jr nc, jr_006_5105

    inc a
    ld e, c
    ld a, $00
    nop
    stop
    xor $00
    ld hl, sp+$00
    call z, $8630
    ld a, b
    inc a
    ret nz

    cp h

jr_006_50c5:
    ld d, b
    ld e, d
    db $e4
    ld a, d
    db $fc
    ld a, d
    db $f4
    sbc d
    ld a, h
    ld c, h
    jr nc, jr_006_5109

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc b
    inc bc
    rrca
    nop
    add hl, sp
    rlca
    rra
    nop
    ld a, e
    rlca
    ld h, $19
    ld a, d
    rlca
    ld d, [hl]
    add hl, bc
    dec a
    inc bc
    dec l
    ld [bc], a
    dec de
    inc b
    dec de
    inc b
    dec c
    nop
    add hl, bc
    nop
    nop
    nop
    nop
    nop
    reti


    and $ec
    rra
    call z, $81f3
    ld a, [hl]
    sub b
    rst $38
    add hl, hl
    rst $10
    ld d, c

jr_006_5105:
    cp [hl]
    and b
    rst $18
    ld e, c

jr_006_5109:
    cp [hl]
    sbc a
    ld h, b
    ld a, b
    add a
    add e
    ld a, a
    ld c, c
    or $67
    ld hl, sp-$07
    nop
    cp $00
    or [hl]
    ld l, h
    dec de
    or $a4
    db $db
    ld d, b
    rst $28
    add e
    ld a, h
    ld [hl+], a
    db $fd
    or c
    sbc $00
    rst $38
    ld [bc], a
    rst $38
    add $3f
    dec b
    cp $81
    cp $26
    ret c

    ld e, a
    ldh [$ef], a
    ld [hl], b
    ld h, h
    jr jr_006_5185

    nop
    ret nc

    nop
    ld a, [hl]
    add b
    ret z

    jr nc, jr_006_50c5

    ld a, b
    inc a
    ret nz

    cp h
    ld d, b
    ld e, d
    db $e4
    ld a, c
    cp $3d
    ld a, [$3edd]
    ld h, $18
    inc e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [$1e07], sp
    ld bc, $0f71
    ccf
    nop

jr_006_5160:
    scf
    rrca
    ld h, [hl]
    add hl, de
    xor d
    rla
    db $76
    add hl, bc
    sub l
    dec bc
    dec a
    ld [bc], a
    ld e, e
    inc b
    ld d, a
    nop
    ld bc, $0000
    nop
    nop
    nop
    nop
    nop
    reti


    and $6c
    sbc a
    call $81f3
    ld a, [hl]
    jr nc, @+$01

    add hl, hl
    rst $10
    ld d, c

jr_006_5185:
    cp [hl]
    and b
    rst $18
    ld e, c
    cp [hl]
    sbc a
    ld h, b
    ld [hl], b
    adc a
    rst $00
    jr c, jr_006_5160

    ld a, $e6
    jr jr_006_520d

    nop
    nop
    nop
    sub d
    ld l, h
    dec hl
    or $24
    db $db
    sub b
    rst $28
    add e
    ld a, h
    ld [hl+], a
    db $fd
    or c
    sbc $00
    rst $38
    rlca
    rst $38
    call Call_000_0d3e
    ld a, [c]
    sub e
    db $fc
    reti


    ld a, $fc
    nop
    cp $00
    nop
    nop
    ld d, h
    nop
    add sp, $00
    ld hl, sp+$00
    adc b
    ld [hl], b
    sbc h
    ld h, b
    ld a, [hl]
    sub b
    cp c
    ld b, [hl]
    ld a, l
    ld a, [$fe7d]
    rst $18
    inc a
    ld a, $00
    nop
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

jr_006_51d9:
    nop
    inc c
    inc bc
    inc sp
    inc c
    ld l, h
    rra
    ld [hl], a
    rrca
    sbc c
    ld h, a
    or a
    ld c, l
    rst $28
    dec e
    ld e, d
    dec a
    ld l, h
    inc de
    dec sp
    ld b, $25
    ld a, [de]
    ld a, [de]
    dec b
    ld l, $01
    rlca
    nop
    ld a, [bc]
    nop
    ldh [rP1], a
    sbc $e0
    push hl
    jr jr_006_51d9

    db $e4
    db $76
    adc b
    ld l, e
    db $f4
    push af
    adc d
    adc e
    db $f4
    or a
    ret z

    ld e, l
    xor b
    ld a, [hl]

jr_006_520d:
    xor b
    or $a8
    call nc, $bca8
    ld b, b
    db $e4
    nop
    adc b
    nop
    nop
    nop
    inc bc
    nop
    ld l, $01
    dec d
    dec bc
    or a
    add hl, bc
    ld l, d
    dec d
    push af
    ld c, $4c
    inc sp
    ld sp, hl
    rra
    ld e, [hl]
    ld hl, $1e6d
    ccf
    nop
    and [hl]
    rra
    ld a, a
    nop
    dec c
    nop
    inc bc
    nop
    ldh [rP1], a
    sbc h
    ld h, b
    call c, Call_006_7620
    adc b
    xor d
    call c, $fcdb
    push de
    ld a, [hl-]
    push af
    ld a, [$facf]
    ld a, a
    xor d
    ld [hl], l
    xor d
    ld e, d
    and h
    xor d
    ld d, h
    ld d, [hl]
    xor b
    cp [hl]
    ld b, b
    db $e4
    nop
    ld de, $2700
    nop
    dec a
    ld [bc], a
    dec hl
    dec d
    ld l, a
    dec d
    ld a, [hl]
    dec d
    cp d
    dec d
    db $ed
    inc de
    pop de
    cpl
    xor a
    ld d, c
    sub $2f
    ld l, [hl]
    ld de, $275b
    and a
    jr jr_006_52f0

    rlca
    rlca
    nop
    ld d, b
    nop
    ldh [rP1], a
    ld [hl], h
    add b
    ld e, b
    and b
    and h
    ld e, b
    call c, Call_000_3660
    ret z

    ld e, d
    cp h
    rst $30
    cp b
    db $ed
    or d
    sbc c
    and $ee
    ldh a, [$36]
    ld hl, sp-$34
    jr nc, jr_006_52c5

    ret nz

    ret nz

    nop
    daa
    nop
    ld e, l
    ld [bc], a
    ld l, d
    dec d
    ld d, l
    ld a, [hl+]
    ld e, d
    dec h
    xor [hl]
    ld d, l
    cp $55
    di
    ld e, a
    xor a
    ld e, a
    xor e
    ld e, h
    ld e, e
    ccf
    ld d, l
    dec sp
    ld l, $11
    dec sp
    inc b
    add hl, de
    ld b, $07
    nop
    ret nz

    nop
    or b
    nop
    cp $00
    ld h, l
    ld hl, sp-$04
    nop
    or [hl]
    ld a, b
    ld a, d

jr_006_52c5:
    add h
    sbc a
    ld hl, sp+$32
    call z, Call_006_70af
    ld d, [hl]
    xor b
    db $ed
    sub b
    xor b
    ret nc

    ld [hl], h
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
    nop
    nop
    nop

jr_006_52e3:
    nop
    nop
    nop
    inc c
    nop
    inc de
    inc c
    inc e
    inc bc
    db $10
    rrca
    db $10
    rrca

jr_006_52f0:
    db $10
    rrca
    db $10
    rrca
    dec e
    rrca
    dec e
    ld b, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nc, jr_006_5308

jr_006_5308:
    ret z

    jr nc, jr_006_533f

    ret z

    inc d
    add sp, $08
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$84]
    ld hl, sp-$7c
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
    nop
    nop
    nop
    jr jr_006_532e

jr_006_532e:
    daa
    jr jr_006_5359

    rla
    db $10
    rrca
    db $10
    rrca
    jr nz, jr_006_5357

    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_533f:
    nop
    nop
    nop
    nop
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
    ldh [$d0], a
    jr nz, jr_006_52e3

    ld h, b

jr_006_5354:
    jr nz, @-$3e

    db $10

jr_006_5357:
    ldh [rP1], a

jr_006_5359:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld sp, $4e00
    ld sp, $2e51
    ld hl, $201e
    rra
    ld b, b
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
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nz, @-$3e

    and b
    ld b, b
    jr nz, jr_006_5354

jr_006_5394:
    ld b, b
    add b

jr_006_5396:
    jr nz, @-$3e

jr_006_5398:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, c
    nop
    sbc [hl]
    ld h, c
    pop hl
    ld e, $80
    ld a, a
    add b
    ld a, a
    add b
    ld a, a
    add b
    ld a, a
    db $ec
    ld a, a
    ld l, h
    scf
    ld a, h
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
    add b
    nop
    ld b, b
    add b
    and b
    ld b, b
    and b
    ld b, b
    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    jr nz, jr_006_5394

    jr nz, jr_006_5396

    jr nz, jr_006_5398

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $001f
    rla
    rrca
    cpl
    rra
    ld a, e
    rlca
    ld a, e
    rlca
    ld b, a
    ccf
    ld e, a
    ccf
    ccf
    nop
    ld a, $19
    ld a, $1d

jr_006_540c:
    rra
    ld c, $1f
    ld c, $7f
    nop
    sub c
    ld l, [hl]
    ld de, $11ee
    xor $84
    ld a, b
    ld b, h
    cp b
    and d
    call c, $dce2
    ld [c], a
    call c, $dea1
    ld b, b
    cp a
    add b
    ld a, a
    nop
    rst $38
    ldh a, [rIF]
    ld l, d
    push af
    ld a, [$f4f5]
    ei
    db $f4
    ei
    add sp, -$09
    ldh a, [$ef]
    nop
    nop
    nop
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
    add b
    jr nz, jr_006_540c

    jr nz, @-$3e

    jr nz, @-$3e

    db $10
    ldh [rNR10], a
    ldh [rNR10], a
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
    nop
    nop
    nop
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
    jr nz, jr_006_5499

    db $10
    rrca
    rra
    rrca
    rra
    dec b
    rrca
    nop
    ld d, $0f
    cpl
    rra
    ld [hl], a
    rrca
    ld [hl], a
    rrca
    ld l, a
    rra
    ld [hl], $0f
    ld l, a
    db $10
    and b
    ld e, a
    ld a, $c1
    dec l
    sbc $3f
    sbc $10

jr_006_5499:
    ldh [rNR10], a
    ldh [rNR10], a
    ldh [rNR10], a
    ldh [rNR10], a
    ldh [$90], a
    ld h, b
    ld c, b
    or b
    ret z

    or b
    ld c, b
    or b
    adc b
    ld [hl], b
    adc b
    ld [hl], b
    inc b
    ld hl, sp+$04
    ld hl, sp-$7c
    ld a, b
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    nop
    nop

jr_006_54ba:
    nop
    nop

jr_006_54bc:
    nop
    nop

jr_006_54be:
    nop
    nop

jr_006_54c0:
    nop
    nop

jr_006_54c2:
    nop
    nop

jr_006_54c4:
    nop
    nop
    nop
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
    ld [$4007], sp
    ccf
    jr nz, @+$21

    ld a, $1f
    ld a, $0b
    ld e, $01
    dec l
    ld e, $5e
    ccf
    rst $28
    rra
    xor $1f
    rst $18
    ld a, $6d
    ld e, $de
    ld hl, $bf40
    ld a, l
    add d
    ld e, d
    cp l
    ld a, [hl]
    cp l
    jr nz, jr_006_54ba

    jr nz, jr_006_54bc

    jr nz, jr_006_54be

    jr nz, jr_006_54c0

    jr nz, jr_006_54c2

    jr nz, jr_006_54c4

    sub b
    ld h, b
    sub b
    ld h, b
    sub b
    ld h, b
    db $10
    ldh [rNR10], a
    ldh [$08], a
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$00
    nop

jr_006_551a:
    ld bc, $0300
    nop
    inc bc
    nop
    ld [bc], a
    ld bc, $0102
    ld bc, $0100
    nop
    inc bc
    nop
    inc b
    inc bc
    ld [$1007], sp
    rrca
    db $10
    rrca
    daa
    jr jr_006_5580

    ld [hl], $97
    ld l, [hl]
    cp d
    ld a, l
    ld a, l
    cp $df
    ld a, $df
    ld a, $3d
    cp $fa
    db $fd
    db $fc
    inc bc
    ldh [$df], a
    db $fc
    ld h, e
    ld a, [c]
    dec c
    adc l
    db $76
    adc [hl]
    ld [hl], a
    adc a
    ld [hl], a
    add a
    ld a, b

jr_006_5554:
    add b
    ld a, a

jr_006_5556:
    ret nz

    ccf

jr_006_5558:
    jr nz, jr_006_551a

    db $10
    ldh [rNR10], a
    ldh [rNR10], a
    ldh [$08], a
    ldh a, [rDIV]
    ld hl, sp+$02
    db $fc
    ld bc, $61fe
    sbc [hl]
    add b
    ld a, a
    add b
    ld a, a
    add b
    ld a, a
    sbc b
    ld h, a
    ldh [$1f], a
    nop
    rst $38
    nop
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_5580:
    nop
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
    ld b, b
    add b
    jr nz, jr_006_5554

    jr nz, jr_006_5556

    jr nz, jr_006_5558

    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0102
    inc bc
    ld bc, $0305
    ld [hl+], a
    db $dd
    ld h, e
    sbc l
    and e
    ld e, l
    ld hl, $20de
    rst $18
    db $10
    rst $28
    db $10
    rst $28
    ld hl, sp+$07
    or h
    ld a, e
    ld a, [$7e7d]
    db $fd

jr_006_55ce:
    db $fd
    cp $fe
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ret nc

    rst $28
    ldh [$df], a
    and b
    rst $18
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
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    add b
    ld a, a
    ld b, c
    cp [hl]
    cp [hl]
    pop bc
    or $f9
    ld [$08f0], sp
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [rNR10]
    ldh [rNR10], a
    ldh [rNR10], a
    ldh [rNR41], a
    ret nz

    jr nz, jr_006_55ce

    ld b, b
    add b
    ret nz

    nop
    ld b, b
    add b
    add b
    nop
    add b
    nop
    ld [$1007], sp
    rrca
    jr nz, jr_006_563d

    ld h, $19
    ld b, a
    ld a, [hl-]
    ld b, a
    dec sp
    ld b, e
    dec a
    inc hl
    dec e
    inc hl
    inc e
    ld [de], a
    dec c
    ld c, $01
    ld [bc], a
    ld bc, $0102
    inc bc
    nop
    inc b
    inc bc
    rlca
    inc bc
    ccf
    sbc $3f
    sbc $5f

jr_006_563d:
    cp [hl]
    ld e, l
    cp [hl]
    db $dd
    ld a, $de
    dec a
    ld a, [$f4bd]
    dec sp
    ld l, b
    or a
    ld d, b
    xor a
    ld h, b
    sbc a
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ldh a, [rIF]
    rst $08
    ldh a, [rSC]
    db $fc
    ld [bc], a
    db $fc
    ld bc, $01fe
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $02
    db $fc
    ld [bc], a
    db $fc
    ld b, $f8
    ld b, $f8
    ld a, [bc]
    db $f4
    ld [hl-], a
    call z, Call_000_1ce2
    db $10
    rrca
    jr nz, jr_006_569b

    ld b, b
    ccf
    ld c, h
    inc sp
    adc a
    ld [hl], h
    adc a
    db $76
    add a
    ld a, e
    ld b, a
    ld a, [hl-]
    ld b, [hl]
    add hl, sp
    inc h
    dec de
    inc e
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld b, $01
    add hl, bc
    ld b, $0f
    rlca
    ld a, [hl]
    cp l
    ld a, [hl]

jr_006_569b:
    cp l
    cp [hl]
    ld a, l
    cp d
    ld a, l
    cp d
    ld a, l
    cp h
    ld a, e
    db $f4
    ld a, e
    add sp, $77
    ret nc

    ld l, a
    and b
    ld e, a
    ret nz

    ccf
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ldh [$1f], a
    sbc a
    ldh [rDIV], a
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc bc
    db $fc
    dec b
    ld a, [$fa05]
    add hl, bc
    or $09
    or $18
    rst $20
    ld l, b
    sub a
    adc b
    ld [hl], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    sbc a

jr_006_56f9:
    ld h, b
    sub c
    ld l, [hl]
    ld b, c
    ld a, $41
    ld a, $41
    ld a, $22
    dec e
    ld e, $01
    inc bc
    ld bc, $0103
    dec b
    inc bc
    dec b
    inc bc
    rlca
    inc bc
    rlca
    inc bc
    dec bc
    rlca
    dec bc
    rlca
    rrca
    rlca
    jr nz, jr_006_56f9

jr_006_571a:
    ret nc

    rst $28
    add sp, -$09
    db $f4
    ei
    ei
    db $fc
    cp $ff
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld bc, $c3fe
    inc a
    cp l
    jp nz, $eed1

    jp hl


    or $e9
    or $f9
    or $f9
    or $f5
    ld a, [$faf5]
    push af
    ld a, [$fafd]
    jr nz, jr_006_571a

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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
    inc bc
    inc b
    inc bc
    ld [$0807], sp
    rlca
    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    dec b
    inc bc
    rlca
    inc bc
    dec bc
    rlca
    dec de
    rlca
    ld l, a
    rla
    sub a
    ld l, a
    rla
    rst $28
    rla
    rst $28
    rra
    rst $28
    rra
    rst $28
    rra
    rst $28
    rra
    rst $28
    rra
    rst $28
    rla
    rst $28
    scf
    rst $08
    rla
    rst $28
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    db $fd
    ld a, [$fafd]
    push af
    ld a, [$faf5]
    ld sp, hl
    or $f9
    or $ea
    db $f4
    ld [$f2f4], a
    db $ec
    ld a, [c]
    db $ec
    jp nc, $d2ec

    db $ec
    ld [c], a
    call c, $dca2
    and d
    call c, $b8c4
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    rlca
    inc bc
    rlca
    inc bc
    dec bc
    rlca
    dec bc
    rlca
    rrca
    rlca
    rla
    rrca
    rla
    rrca
    ccf
    rrca
    ccf
    rrca
    ld e, a
    cpl
    ld e, a
    cpl
    sbc a
    ld l, a
    rra
    rst $28
    rra
    rst $28
    rra
    rst $28
    rra
    rst $28
    and d
    call c, $dca2
    ld [c], a
    call c, $dce2
    ld [c], a
    call c, $dce2
    jp nc, $d1ec

    xor $f1
    xor $f1
    xor $f1
    xor $f1
    xor $f1
    xor $f1
    xor $f1
    xor $d1
    xor $0f
    rlca
    rla
    rrca
    rla
    rrca
    rla
    rrca

jr_006_5860:
    rra
    rrca

jr_006_5862:
    rra
    rrca
    rra
    rrca
    rla
    rrca
    rla
    rrca
    rla
    rrca
    rra
    rlca
    dec de
    rlca
    dec de
    rlca
    rla
    dec bc
    dec d
    dec bc
    dec d
    dec bc
    ld hl, sp-$09
    db $f4
    ei
    db $f4
    ei
    db $fc
    ei
    db $fc
    ei
    db $fc
    ei
    ld a, [$fafd]
    db $fd
    cp $fd
    cp $fd
    cp $fd
    cp $fd
    db $fd
    cp $fd
    cp $fd
    cp $ff
    cp $80
    nop
    ld b, b
    add b
    ld b, b
    add b
    jr nz, jr_006_5860

    jr nz, jr_006_5862

    db $10
    ldh [rNR10], a
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld bc, $0ffe
    rlca
    rla
    rrca
    rla
    rrca
    rla
    rrca
    rra
    rrca
    rra
    rrca
    rra
    rrca
    rra
    rrca
    rra
    rrca

jr_006_58ca:
    rra
    rrca
    rla
    rrca
    rla
    rrca
    rla
    rrca
    rra
    rlca
    dec de
    rlca
    dec de
    rlca
    db $fc
    ei
    db $fc
    ei
    ld a, [$fafd]
    db $fd
    ld a, [$fefd]
    db $fd
    cp $fd
    cp $fd
    cp $fd
    cp $fd
    cp $fd
    cp $fd
    ld a, [$fafd]
    db $fd
    ld a, [$fcfd]
    ei
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
    ld b, b
    add b
    ld b, b
    add b
    jr nz, jr_006_58ca

    db $10
    ldh [rNR10], a
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$10
    rrca
    db $10
    rrca
    ld [$0807], sp
    rlca
    ld [$0607], sp
    ld bc, $0003
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0007
    rrca
    rlca
    rra
    ld c, $1f
    ld c, $1e
    inc c
    inc e
    nop
    rrca
    rst $30
    dec bc
    rst $30
    dec bc
    rst $30
    rlca
    ei
    rlca
    ei
    dec c
    di
    adc d
    ld [hl], c
    ld de, $10e0
    ldh [rNR41], a
    ret nz

    ld b, b
    add b
    add b
    nop

jr_006_5950:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    cp $ff
    rst $38
    cp $fd
    cp $fa
    db $fd
    db $ec
    di
    ldh a, [rIF]
    ld b, b
    ccf
    ld b, b
    ccf
    jr nz, jr_006_598d

    jr nz, @+$21

    db $10
    rrca
    db $10
    rrca
    ld [$0f07], sp
    nop
    ld b, h
    cp b
    add h
    ld a, b
    add h
    ld a, b
    inc b
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$08
    ldh a, [$08]
    ldh a, [rNR10]
    ldh [rNR10], a
    ldh [rNR41], a

jr_006_598d:
    ret nz

    jr nz, jr_006_5950

    ld a, h
    add b
    ld a, $dc
    ld a, a
    cp [hl]
    rst $38
    nop
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $0102
    ld bc, $0300
    nop
    inc a
    inc bc
    ld a, h
    dec sp
    rst $38
    ld a, h
    db $fc
    nop
    rla
    rst $28
    rla
    rst $28
    rrca
    rst $30
    rrca
    rst $30
    dec bc
    rst $30
    dec bc
    rst $30
    rlca
    ei
    dec b
    ei
    ld [bc], a
    db $fd
    ld bc, $00fe
    rst $38
    adc a
    ld [hl], b
    ld [$04f0], sp
    ld hl, sp-$04
    nop
    nop
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    cp $ff
    db $fd
    cp $ba
    ld a, l
    ld a, h
    add e
    ld hl, sp+$07
    ld [$0807], sp
    rlca
    inc b
    inc bc
    rlca
    nop
    pop de
    xor $e1
    sbc $a2
    call c, $dca2
    jp nz, Jump_006_42bc

    cp h
    add h
    ld a, b
    add h
    ld a, b
    inc b
    ld hl, sp+$08
    ldh a, [$08]
    ldh a, [rNR10]
    ldh [rNR32], a
    ldh [$3e], a
    call c, $be7f
    rst $38
    nop
    inc de
    dec c
    ld a, [bc]
    dec b
    add hl, bc
    ld b, $08
    rlca
    ld [$0407], sp
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $0102
    ld bc, $0000
    nop
    rra
    nop
    ld a, h
    dec de
    cp $7d
    rst $38
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, a
    rst $38
    rst $38
    ld a, a
    cp a
    ld a, a
    ld e, a
    cp a
    cpl
    rst $18
    rla
    rst $28
    dec bc
    rst $30
    ld b, $f9
    ld bc, $8ffe
    ld [hl], b
    ret z

    jr nc, jr_006_5a5b

    ldh a, [rDIV]
    ld hl, sp-$04
    nop
    rst $38
    cp $ff

jr_006_5a5b:
    cp $ff
    cp $fd
    cp $fd
    cp $fe
    db $fd
    ld a, [$fafd]
    db $fd
    db $f4
    ei
    ret z

    rst $30
    ldh a, [rIF]
    cp $01
    ld [bc], a
    ld bc, $0304
    inc b
    inc bc
    rlca
    nop
    ld bc, $01fe
    cp $01
    cp $01
    cp $01
    cp $01
    cp $02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$04
    ld hl, sp+$08
    ldh a, [rNR32]
    ldh [$3e], a
    call c, $be7f
    rst $38
    nop
    rla
    dec bc
    dec d
    dec bc
    ld [de], a
    dec c
    ld de, $100e
    rrca
    db $10
    rrca
    ld [$0807], sp
    rlca
    ld [$0407], sp
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $001f
    ld a, h
    dec de
    cp $7d
    rst $38
    nop
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, a
    rst $38
    cp a
    ld a, a
    ld l, a
    sbc a
    add hl, de
    rst $20
    rlca
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$08
    ldh a, [$08]
    ldh a, [$88]
    ld [hl], b
    ld [$04f0], sp
    ld hl, sp-$04
    nop
    db $f4
    ei
    db $f4
    ei
    ld hl, sp-$09
    add sp, -$09
    ldh a, [$ef]
    ret nc

    rst $28
    and b
    rst $18
    ret nz

    ccf
    jr nz, jr_006_5b09

    jr nz, jr_006_5b0b

    ld de, $110e
    ld c, $08
    rlca
    ld [$0407], sp
    inc bc
    inc bc
    nop
    inc b
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$08
    ldh a, [$08]
    ldh a, [rIF]
    ldh a, [$1f]
    and $3f
    adc $4f

jr_006_5b09:
    or [hl]
    add a

jr_006_5b0b:
    ld a, d
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$08
    ldh a, [rNR10]
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
    ld [$0007], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_5b51:
    nop
    ld [hl], b
    nop
    adc b
    ld [hl], b
    rst $28
    db $10
    ld [$1007], sp
    rrca
    db $10
    rrca
    db $10
    rrca
    ld d, $0f
    ld c, $03
    ld c, $01
    ld de, $2f0e
    rra
    ld e, a
    ccf
    rst $28
    rra
    rst $38
    rrca
    ld a, [hl]
    rrca
    ld sp, $cf0e
    nop
    and h
    ld b, e
    jr z, jr_006_5b51

    db $10
    rst $28
    nop
    rst $38
    nop
    rst $38

jr_006_5b80:
    nop
    rst $38

jr_006_5b82:
    nop
    rst $38
    nop
    rst $38
    ret nz

    ccf
    and b
    rst $18
    ld h, b
    rst $18
    ldh [$5f], a
    cp b
    ld b, a
    db $e4
    dec de
    ld [c], a
    dec e
    ld [hl+], a
    dec e
    jp $ff3c


    nop
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld b, b
    cp a
    ld b, b
    cp a
    nop
    rst $38
    add b
    ld a, a
    add b
    ld a, a
    add b
    ld a, a
    add b
    ld a, a
    and b
    ld e, a
    ret nz

    ccf
    add b
    ld a, a
    nop
    rst $38
    nop
    nop
    add b
    nop
    ld b, b
    add b
    jr nz, jr_006_5b80

    jr nz, jr_006_5b82

    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld bc, $00fe
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, b
    add b
    nop
    nop
    ld bc, $0200
    ld bc, $0304
    inc b
    inc bc
    rlca
    inc bc
    rrca
    ld bc, $0c13
    ld l, $1f
    ld e, a
    ccf
    rst $28
    rra
    rst $38
    rrca
    ld a, l
    ld c, $33
    dec c
    inc e
    inc bc
    rlca
    nop
    nop
    nop
    ld hl, sp+$00
    rlca
    ld hl, sp+$01
    cp $06
    ld sp, hl
    ld [bc], a
    db $fd
    ld bc, $06fe
    ld sp, hl
    ret nz

    ccf
    and b
    rst $18
    ldh [$df], a
    ld h, b
    rst $18
    and b

jr_006_5c31:
    rst $18
    ld [hl], b

jr_006_5c33:
    adc a
    adc b

jr_006_5c35:
    rlca
    ld [$0007], sp
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
    jr nz, @-$3e

    rra
    ldh [rP1], a
    rst $38
    nop
    rst $38
    nop
    rst $38
    db $10
    rst $28
    jr nz, jr_006_5c31

    jr nz, jr_006_5c33

    jr nz, jr_006_5c35

    ld b, b
    cp a

jr_006_5c58:
    nop
    nop
    nop
    nop
    nop
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
    db $10
    ldh [$08], a
    ldh a, [rDIV]
    ld hl, sp+$02
    db $fc
    ld bc, $00fe
    rst $38
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nc, jr_006_5c58

    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld c, c
    ld [hl], $96
    ld l, c
    add d
    ld a, l
    add c
    ld a, [hl]
    add e
    ld a, h
    add c
    ld a, [hl]
    add c
    ld a, [hl]
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_5cbf:
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc c
    inc bc

jr_006_5cc8:
    ldh a, [rIF]
    nop
    rst $38
    add b
    ld a, a
    add b
    ld a, a

jr_006_5cd0:
    add b
    ld a, a

jr_006_5cd2:
    ld b, b
    cp a
    and c
    sbc $d2
    db $ed
    nop
    nop
    nop
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
    jr jr_006_5cc8

    inc b
    ld hl, sp+$03
    db $fc
    nop
    rst $38
    jr nc, jr_006_5cbf

    ld b, b
    cp a
    add b
    ld a, a
    nop
    rst $38
    nop
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
    add b
    nop
    ld b, b
    add b
    jr nz, jr_006_5cd0

    jr nz, jr_006_5cd2

    db $10
    ldh [rNR10], a
    ldh [rNR23], a
    ldh [rP1], a
    nop
    nop
    nop
    rrca
    nop
    ld [de], a
    dec c
    inc hl
    inc e
    ld b, c
    ld a, $40
    ccf
    add b
    ld a, a
    add b
    ld a, a
    or b
    ld a, a
    or b
    ld e, a
    ld a, [hl]
    ld bc, $3e5d
    ld a, [hl]
    ccf
    cp l
    ld a, a
    rst $18
    dec a
    nop
    nop
    nop
    nop
    add b
    nop
    ld [hl], b
    add b
    ld c, a
    or b
    ld b, b
    cp a
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
    ld [bc], a
    db $fd
    inc b
    ei

jr_006_5d52:
    add h
    ld a, e

jr_006_5d54:
    add h
    ld a, e
    add h
    ld a, e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh [rP1], a
    inc e
    ldh [rSC], a
    db $fc
    ld [bc], a
    db $fc
    ld bc, $01fe
    cp $00
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    jr nz, jr_006_5d52

    jr nz, jr_006_5d54

    db $10
    ldh [rNR10], a
    ldh [rIE], a
    ld b, c
    db $e3
    ld e, l
    and d
    ld e, l
    ld h, e
    inc e
    jr nc, jr_006_5db1

    inc c

jr_006_5da3:
    inc bc
    ld [bc], a

jr_006_5da5:
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

jr_006_5db1:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    and h
    db $db
    ld e, b
    and a
    add b
    ld a, a
    add b
    ld a, a
    ret nz

    ccf
    jr nz, jr_006_5da3

    jr nz, jr_006_5da5

    rra
    ldh [$c3], a
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
    inc bc
    db $fc
    db $fc
    inc bc
    rst $18
    ccf
    ld e, a
    ccf
    ld e, a
    ccf
    ccf
    rra
    ccf
    rra
    ccf
    rra
    ccf
    rra
    ccf
    rra
    inc b
    inc bc
    inc b
    inc bc
    rlca
    nop
    ld b, h
    inc bc
    ld h, e
    ld bc, $2172
    ld a, [hl]
    ld hl, $2c73
    ld sp, $180e
    rlca
    rst $38
    nop
    db $fc
    ld a, e
    ld a, b
    scf
    jr c, jr_006_5e1b

    ld b, $01
    ld bc, $4000
    cp a
    ld b, b

jr_006_5e1b:
    cp a
    ld b, b
    cp a
    ret nz

    ccf
    ld h, b
    sbc a
    and b
    rst $18
    ret nc

    rst $28
    ret nc

    rst $28
    ld l, b
    rst $30
    add sp, $77
    sub b
    ld l, a
    ldh [$1f], a
    ld b, b
    cp a
    nop
    rst $38
    nop
    rst $38
    rlca
    ld hl, sp+$00
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38

jr_006_5e42:
    ld [$08f7], sp
    rst $30
    ld [$08f7], sp
    rst $30
    ld [$0cf7], sp
    di
    inc c
    di
    ld [de], a
    db $ed
    dec l

jr_006_5e53:
    sbc $de
    ccf
    ld a, a
    rst $38
    inc c
    ldh a, [rSC]
    db $fc
    ld bc, $00fe
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
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    jr nz, jr_006_5e53

    ret nz

    ccf
    ld b, b
    cp a
    nop
    nop
    nop
    nop
    add b
    nop
    ld b, b
    add b
    jr nz, jr_006_5e42

    db $10
    ldh [rNR10], a
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld bc, $99fe
    ld a, [hl]
    sbc b
    ld l, a
    ld a, b
    rlca
    daa
    jr jr_006_5ee0

    rra
    ccf
    rra
    ld a, $1f
    cpl
    ld e, $37
    ld c, $3b
    ld b, $3f
    nop
    inc a
    inc bc
    ld [$0407], sp
    inc bc
    inc bc
    nop
    nop
    nop
    ld [hl], d
    db $ed
    call c, $a463
    ld e, e
    ret nz

    ccf
    ld b, b
    cp a
    and b
    rst $18
    and b
    rst $18
    ldh a, [$8f]
    ld c, b
    or a
    ld [hl], a
    cp b
    rst $38
    ccf
    ld e, a

jr_006_5ecf:
    cp a
    ccf
    rst $18
    cpl
    rst $18
    rla
    rst $28
    db $fc
    inc bc
    nop
    rst $38
    nop
    rst $38
    nop

jr_006_5edd:
    rst $38
    nop
    rst $38

jr_006_5ee0:
    ld bc, $02fe
    db $fd
    inc b
    ei
    jr jr_006_5ecf

    ld hl, sp+$07
    ld [hl], a
    ld hl, sp-$02
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    inc d
    add sp, $13
    db $ec
    jr nz, jr_006_5edd

    ld b, b
    cp a
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
    add b
    ld a, a
    ld [hl], b
    adc a
    add sp, -$09
    ld hl, sp-$09
    db $f4
    ei
    db $f4
    ei
    db $f4
    ei
    nop
    nop
    nop
    nop
    ret nz

    nop
    jr nz, jr_006_5ee0

    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld bc, $01fe
    cp $fb
    rlca
    db $f4
    ld a, e
    cp a
    ld [hl], b
    jp nc, $e32c

    inc e
    and d
    ld e, l
    and b
    ld e, a
    and b
    ld e, a
    sub b
    ld l, a
    ld d, b
    cpl
    ld c, b
    scf
    ld h, $19
    add hl, de
    ld b, $07
    nop
    nop
    nop
    nop
    nop
    adc b
    ld [hl], a
    adc b
    ld [hl], a
    sub b
    ld l, a
    and b
    ld e, a
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
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    rst $38
    nop
    rst $10
    rrca
    rrca
    rlca
    dec bc
    rlca
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld bc, $01fe
    cp $01
    cp $02
    db $fd
    ld [bc], a
    db $fd
    inc b
    ei
    ld a, [bc]
    push af
    dec d
    xor $6e
    sbc a
    cp a
    ld a, a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld [$04f0], sp
    ld hl, sp+$03
    db $fc
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
    rst $38
    nop
    rst $38
    nop
    rst $38
    add b
    ld a, a
    ld b, b
    cp a
    and b
    rst $18
    ldh [$df], a
    ret nc

    rst $28
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

    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    db $fd
    inc bc
    rrca
    inc bc
    rla
    dec bc
    daa
    dec de
    daa
    dec de
    ld b, a
    dec sp
    ld b, a
    dec sp
    ld b, l
    dec sp
    ld b, l
    dec sp
    ld b, e
    dec a
    ld b, d
    dec a
    ld b, d
    dec a
    ld hl, $211e
    ld e, $10
    rrca
    ld [$ff07], sp
    rst $38
    rst $38
    rst $38
    cp $ff
    db $fd
    cp $fe
    db $fd
    ld a, [$fcfd]
    ei
    db $f4
    ei
    db $f4
    ei
    ld hl, sp-$09
    add sp, -$09
    add sp, -$09
    ldh a, [$ef]
    ld [hl], b
    rst $28
    or b
    ld l, a
    ld d, b
    xor a
    ld b, b
    cp a
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
    rst $38
    nop
    rst $38
    ld bc, $01fe
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$03
    nop
    inc bc
    nop
    inc bc
    nop
    dec b
    ld [bc], a
    dec b
    ld [bc], a
    dec b
    ld [bc], a
    add hl, bc
    ld b, $09
    ld b, $09
    ld b, $11
    ld c, $11
    ld c, $10
    rrca
    jr nz, jr_006_6091

    jr nz, jr_006_6093

    jr nz, jr_006_6095

    jr nz, jr_006_6097

    di
    rrca
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    cp $ff
    rst $38
    cp $7f
    cp $7d
    cp $7d
    cp $fd
    ld a, [hl]
    db $fd

jr_006_6091:
    ld a, [hl]
    cp l

jr_006_6093:
    ld a, [hl]
    cp a

jr_006_6095:
    ld a, [hl]
    cp a

jr_006_6097:
    ld a, [hl]
    add sp, -$09
    ldh a, [$ef]
    ret nc

    rst $28
    and b
    rst $18
    ld b, b
    cp a
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
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld bc, $01fe
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $07
    inc bc
    dec b
    inc bc
    inc bc
    ld bc, $0102
    ld [bc], a
    ld bc, $0205
    dec b
    ld [bc], a
    add hl, bc
    ld b, $09
    ld b, $09
    ld b, $09
    ld b, $11
    ld c, $10
    rrca
    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, [hl]
    rst $38
    ld a, [hl]
    rst $38
    rst $38
    ld a, [hl]
    cp a
    ld a, [hl]
    cp a
    ld a, [hl]
    ld a, a
    cp [hl]
    ldh a, [$ef]
    ldh a, [$ef]
    ldh a, [$ef]
    ret nc

    rst $28
    ldh [$df], a
    and b
    rst $18
    and b
    rst $18
    ret nz

    cp a
    ld b, b
    cp a
    add b
    ld a, a
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
    ld [bc], a
    db $fc

jr_006_613a:
    ld bc, $01fe

jr_006_613d:
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $02
    db $fc
    ld [bc], a
    db $fc
    db $10
    rst $28
    jr nz, @-$1f

    jr nz, jr_006_613d

    ld b, b
    cp a
    ld b, b
    cp a
    add b
    ld a, a
    nop
    rst $38
    add b
    ld a, a
    ld b, b
    cp a
    and b
    rst $18
    ldh [$df], a
    ret nc

    rst $28
    ret nc

    rst $28
    ldh a, [$ef]
    add sp, -$09
    add sp, -$09
    jr nz, jr_006_613a

    jr nz, @-$3e

    db $10
    ldh [rNR10], a
    ldh [rNR10], a

jr_006_6181:
    ldh [$08], a
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
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

jr_006_61a3:
    nop
    rlca
    nop
    dec bc
    rlca
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
    jr c, jr_006_6181

    jr jr_006_61a3

    adc h
    ld [hl], e
    ld c, h
    inc sp
    ld b, a
    jr c, @-$6f

    ld [hl], b
    db $76
    adc l
    cp [hl]
    ld a, l
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
    rst $38
    nop
    rst $38
    nop
    rst $38

Call_006_61de:
    nop
    rst $38
    nop
    rst $38
    ldh [$1f], a
    inc bc
    db $fc
    ld [bc], a
    db $fc
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
    inc b
    ld hl, sp+$08
    ldh a, [$08]
    ldh a, [rNR10]
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
    nop
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
    rrca
    db $10
    rrca
    ld [$0807], sp
    rlca
    inc b
    inc bc
    inc bc
    nop
    inc b
    inc bc
    ld [$1e07], sp
    ld bc, $0e1d
    ld e, $0f
    dec hl
    inc e
    inc l
    db $10
    jr nc, jr_006_6234

jr_006_6234:
    nop
    nop
    nop
    nop
    ld a, [hl]
    cp a
    ld e, a
    cp a
    cpl
    rst $18
    rla
    rst $28
    add hl, bc
    rst $30
    rlca
    ld hl, sp+$0c
    ldh a, [rNR10]
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
    nop
    nop
    nop
    nop
    nop
    nop
    add b
    ld a, a
    add b
    ld a, a
    ld b, b
    cp a
    and b
    rst $18
    ret nc

    rst $28
    inc c
    di
    rst $38
    nop
    ld b, $01
    ld [$1007], sp
    rrca
    inc a
    inc bc
    ld a, [hl-]
    dec e
    dec a
    ld e, $56
    jr c, jr_006_62cd

    jr nz, jr_006_62d7

    nop
    ld bc, $01fe
    cp $02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$08
    ldh a, [$08]
    ldh a, [rNR23]
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
    nop
    nop
    nop
    nop
    db $10
    rrca
    ld [$0807], sp
    rlca
    inc b
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $0102
    ld bc, $0700
    nop

jr_006_62aa:
    rra
    rlca
    ccf
    ld e, $1e
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    ld e, a
    cp [hl]
    cpl
    sbc $16
    rst $28
    inc c
    di
    inc bc
    db $fc
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    rst $08
    jr nc, jr_006_62aa

    ld l, $3e

jr_006_62cd:
    db $dd
    ld a, $c5
    add a
    ld a, b
    ld h, c
    ld e, $1e
    nop
    nop

jr_006_62d7:
    nop
    nop
    rst $38
    nop
    rst $38
    add b
    ld a, a
    add b
    ld a, a
    ret nz

    ccf
    ret nz

    ccf
    ld h, b
    sbc a
    sub b
    rrca
    ld hl, sp+$07
    inc b
    ei
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ret nz

    ccf
    jr c, jr_006_62fd

    rlca
    nop
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a

jr_006_62fd:
    db $fc
    inc b
    ld hl, sp+$04
    ld hl, sp+$08
    ldh a, [rNR10]
    ldh [rNR10], a
    ldh [rNR41], a
    ret nz

    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
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
    nop
    nop
    nop
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
    ld bc, $0304
    ld [$0807], sp
    rlca
    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    ccf
    rra
    ccf
    rra
    ccf
    rra
    ld e, a
    ccf
    ld e, a
    ccf
    rst $18
    ccf
    rst $38
    ccf
    ld a, a
    cp a
    ld a, a
    cp a
    cp [hl]
    ld a, a
    cp a
    ld a, [hl]
    db $fd
    ld a, [hl]
    cp $7d
    cp $7d
    ld a, [$ba7d]
    ld a, l
    add sp, -$09
    add sp, -$09
    add sp, -$09
    ldh a, [$ef]
    ret nc

    rst $28
    ret nc

    rst $28
    ldh [$df], a
    and b
    rst $18
    ld b, b
    cp a
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
    rst $38
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld bc, $01fe
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $01
    cp $02
    db $fc
    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    ld [$0807], sp
    rlca
    inc b
    inc bc
    ld [bc], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    dec c
    ld [bc], a
    ld d, $0d
    rra
    nop
    cp h
    ld a, e
    ld a, h
    cp e
    ld e, h
    cp e
    inc l
    db $db
    inc d
    db $eb
    inc c
    di
    inc b
    ei
    inc b
    ei
    inc b
    ei
    add d
    ld a, l
    add d
    ld a, l
    ld b, c
    ld a, $ff
    nop
    cp b
    ld [hl], a
    ld hl, sp-$09
    rst $38
    nop
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
    rst $38
    add b
    ld a, a
    inc bc
    db $fc
    ld [bc], a
    db $fc
    cp $00
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$04
    ld hl, sp+$08
    ldh a, [$08]
    ldh a, [rNR10]
    ldh [rNR10], a
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
    ld b, $03

jr_006_6424:
    rlca
    ld [bc], a
    ld b, $01
    dec b
    ld [bc], a
    dec c
    ld [bc], a
    rla
    ld [$1a25], sp
    ld c, [hl]
    ld sp, $60d1
    sub c
    ld h, b
    ld c, l
    jr nc, jr_006_6439

jr_006_6439:
    nop
    nop
    nop
    ld [hl], b
    nop
    adc [hl]
    ld [hl], b
    ld bc, $cffe
    jr nc, jr_006_6424

    ld hl, sp-$25
    xor l
    ld [hl], a
    reti


    rst $38
    ld sp, hl
    db $76
    ld sp, hl
    xor a
    ld d, e
    ld [hl], a
    adc h
    ld a, a
    or b
    cp $41
    ld a, l
    add e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_6464:
    add b
    nop
    add b
    nop
    cp $00
    add l
    ld a, [hl]
    cp c
    ld b, [hl]
    push hl
    add d
    db $dd
    ld h, d
    ld sp, hl
    ld d, $f9
    ld b, $7f
    add b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0600
    ld bc, $030c
    dec de
    inc c
    rra
    dec bc
    dec de
    ld b, $15
    dec bc
    scf
    dec bc

jr_006_6490:
    ld e, l
    inc hl
    ld d, [hl]
    add hl, hl
    ld e, a
    jr nz, @+$74

    dec c
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
    jr c, jr_006_6464

    ld c, $f0
    ld a, $c4
    ld a, [hl]
    db $e4
    ld l, [hl]
    or h
    db $db
    ld h, h
    rst $38
    call z, $b3de
    rst $38
    ld b, b
    rst $38
    add b
    di
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
    ret nz

    nop
    jr nc, jr_006_6490

    xor b
    ld [hl], b
    ret z

    or b
    add sp, $50
    ret c

    jr nz, jr_006_64d9

jr_006_64d9:
    nop
    nop
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
    ld bc, $030c
    dec de
    inc c
    rra
    dec bc
    dec de
    ld b, $15
    dec bc
    scf
    dec bc
    ld e, l
    ld [hl+], a
    ld d, [hl]
    add hl, hl
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    adc $00
    ld a, $c4
    ld c, $f4
    ld a, $c4
    ld a, d
    db $e4
    ld a, a
    and h
    xor $1b
    rst $38
    jr nz, jr_006_6590

    and h
    cp a
    ld b, h
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ret nz

    add b
    and b
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
    ld bc, $0600
    ld bc, $030c
    ld e, $09
    ld e, $07
    ld c, $05
    dec bc
    ld b, $0f
    rlca
    rrca
    rlca
    ld a, [bc]
    dec b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    db $e3
    nop
    dec de
    pop hl
    rrca
    pop af
    rst $10
    add hl, sp
    or $d9
    rst $00
    ld a, c
    add a
    ld hl, sp-$31
    ld a, [c]
    sub l
    ld [$946f], a
    nop
    nop
    nop
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
    add b
    nop
    ret nz

    add b

jr_006_6590:
    ret nz

    nop
    ldh [rLCDC], a
    and b
    ld b, b
    ld [hl], b
    and b
    inc hl
    dec e
    inc de
    inc c
    rrca
    nop
    ld a, [bc]
    dec b
    ld e, $09
    ccf
    db $10
    dec l
    ld [de], a
    ld e, [hl]
    inc hl
    ld a, a
    inc hl
    ld a, a
    inc hl
    ld e, a
    inc hl
    cp a
    ld b, e
    rst $38
    ld b, e
    rst $38
    ld b, e
    rst $38
    ld b, e
    rst $38
    nop
    ei
    rlca
    or a
    ld c, a
    dec de
    rst $20
    dec c
    di
    ld b, $f9
    inc bc
    db $fc
    add c
    ld a, [hl]
    ret nz

    ccf
    ld h, b
    sbc a
    or b
    rst $08
    ret c

    rst $20
    db $ec
    di
    ld d, [hl]
    cp c
    ei
    inc e
    ld e, l
    cp [hl]
    rst $38
    nop
    cp a
    pop bc
    db $db
    db $e4
    or c
    adc $60
    sbc a
    ret nz

    ccf
    add c
    ld a, [hl]
    inc bc
    db $fc
    ld b, $f9
    dec c
    di
    dec de
    rst $20
    scf
    rst $08
    ld l, a
    sbc a
    push de
    dec sp
    cp a
    ld [hl], c
    ld [hl], l
    ei
    rst $38
    nop
    add b
    nop
    ret nz

    add b
    ldh [rLCDC], a
    and b
    ld b, b
    ldh a, [rNR41]
    ld hl, sp+$10
    ld l, b
    sub b
    db $f4
    adc b
    db $fc
    adc b
    db $fc
    adc b
    db $f4
    adc b
    ld a, [$fe84]
    add h
    cp $84
    cp $84
    cp $00
    add a
    ld a, d
    ld a, a
    inc b
    ld c, $05
    inc e
    dec bc
    inc e
    dec bc
    ld a, $11
    dec hl
    inc d
    ld e, l
    ld h, $7e
    daa
    ld a, a
    daa
    ld e, a
    daa
    cp a
    ld b, a
    cp $47
    rst $38
    ld b, [hl]
    cp $47
    rst $38
    nop
    db $ed
    ld e, $5e
    cp a
    ld l, l
    sbc [hl]
    inc sp
    call z, $e11e
    inc c
    di
    nop
    rst $38
    add b
    ld a, a
    add b
    ld a, a
    ld b, b
    cp a
    pop hl
    sbc [hl]
    or e
    call z, Call_006_61de
    xor l
    ld [hl], e
    di
    ld a, a
    rst $38
    nop
    ld hl, sp+$10
    cp h
    ld c, b
    sbc h
    ld l, b
    ld c, $f4
    ld c, $f4
    rra
    ld [c], a
    dec [hl]
    jp z, $996e

    ld e, a
    cp c
    cp a
    ld a, c
    cp $79
    ld a, a
    ld hl, sp-$21
    cp b
    ld a, a
    sbc b
    rst $18
    cp b
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
    add b
    nop
    add b
    nop
    add b
    nop
    add b
    nop
    ld b, b
    add b
    ret nz

    add b
    ret nz

    add b
    ret nz

    add b
    ret nz

    nop
    sbc l
    ld h, d
    add a
    ld a, d
    ld l, a
    dec [hl]
    ld a, [hl-]
    dec b
    rrca
    dec b
    rra
    ld a, [bc]
    dec d
    ld a, [bc]
    rra
    ld a, [bc]
    rra
    ld a, [bc]
    rra
    ld a, [bc]
    dec d
    ld a, [bc]
    dec hl
    inc d

jr_006_66b0:
    ccf
    inc d

jr_006_66b2:
    ccf
    inc d
    ccf
    inc d
    ccf
    nop
    ld [hl], l
    adc [hl]
    xor $9f
    sub l
    ld l, [hl]
    sbc a
    ld h, h
    adc d
    ld [hl], l
    add h
    ld a, e
    ld b, h
    cp e
    ret nz

    cp a
    and b
    rst $18
    ldh [$df], a
    pop de
    xor $fb
    db $e4
    adc d
    push af
    push af
    sbc e
    sbc a
    ei
    rst $38
    nop
    ret nc

    jr nz, @-$0e

jr_006_66db:
    jr nz, jr_006_6715

    ret nc

    jr z, jr_006_66b0

    jr c, jr_006_66b2

    inc a
    ret z

    ld d, h
    xor b
    ld a, h
    xor b
    cp h
    ld l, b
    db $fc
    ld l, b
    ld [hl], h
    add sp, -$06
    db $e4
    ld a, $e4
    cp $24
    ld a, $e4
    cp $00
    rlca
    nop
    inc b
    inc bc
    rlca
    ld bc, $0205
    inc b
    inc bc
    ld [$0907], sp
    ld b, $19
    ld c, $12
    inc c
    ld [de], a

jr_006_670b:
    inc c
    ld [de], a
    inc c
    ld a, [bc]
    inc b
    ld a, [bc]
    inc b
    ld a, c
    ld b, $a3

jr_006_6715:
    ld a, [hl]

jr_006_6716:
    cp $00
    cp [hl]
    ld d, l
    ld a, [hl+]
    push de
    ld a, e
    xor h
    ld hl, sp+$2f
    ld a, c
    xor [hl]
    ld a, b
    xor a
    call nc, $ac2b
    ld d, e
    db $fc
    ld d, e
    ld a, [$ff55]
    ld d, h
    db $fd
    ld d, [hl]

jr_006_6730:
    ld a, [$fb57]
    ld d, l
    xor e
    ld d, a
    rst $38
    nop
    or b
    ldh [$90], a
    ldh [$58], a
    or b
    jr jr_006_6730

    ret c

    jr nc, jr_006_66db

    ld [hl], b
    jr z, jr_006_6716

    inc [hl]
    ret z

    inc a
    ret z

    ld e, h
    xor b
    db $fc
    jr z, jr_006_670b

    ld l, b
    ld e, h
    add sp, $5c
    xor b
    ld d, h
    add sp, -$04
    nop
    nop
    nop
    nop
    nop
    ld [hl], b
    nop
    adc [hl]
    ld [hl], b
    ld bc, $dffe
    jr nz, jr_006_676c

    ld hl, sp-$25
    dec h
    ld [hl], a
    reti


    rst $38
    ld sp, hl

jr_006_676c:
    db $76
    ld sp, hl
    xor a
    ld d, e
    ld [hl], a
    adc h
    ld a, a
    or b
    cp $41
    ld a, l
    add e
    nop
    nop
    nop
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
    cp a
    ld e, a
    rst $38
    ld e, a
    rst $38
    ld e, a
    rst $38
    ld e, a
    cp a
    ld e, a
    rst $38
    ld e, a
    cp $59
    db $fd
    ld e, d
    cp $5b
    nop
    nop
    nop
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
    ld a, a
    add b
    cp a
    ld a, a
    rst $38
    ld a, a
    db $ed
    ld [hl], e
    rst $38
    ld l, l
    rst $38
    ld l, l
    rst $38
    ld a, l
    cp a
    ld a, l
    db $fd
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
    rst $38
    nop
    db $fd
    inc bc
    ei
    db $fd
    rst $38
    db $fd
    ld l, a
    sbc l
    rst $38
    ld l, l
    rst $38
    ld l, l
    cp $7d
    ei
    ld a, h
    ld a, [hl]
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
    cp $00
    ld a, [$fef4]
    db $f4
    cp $f4
    cp $f4
    cp $f4
    ld a, [$fef4]
    inc [hl]
    ld a, [hl]
    or h
    cp $b4
    nop
    nop
    nop
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
    ld [bc], a
    ld bc, $0103
    inc bc
    ld bc, $0103
    ld [bc], a
    ld bc, $0103
    inc bc
    ld bc, $0103
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
    rst $38
    nop
    ei
    ld a, h
    db $fd
    ld a, e
    rst $38
    ld a, e
    cp $7b
    rst $38
    ld a, d
    rst $38
    ld a, d
    rst $30
    ld l, e
    db $ed
    ld [hl], e
    rst $20
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
    nop
    rst $38
    nop
    rst $38
    nop
    cp $ff
    rst $38
    rst $38
    call $ff33
    call $cdff
    rst $38
    rst $08
    cp $cf
    rst $08
    jr nc, jr_006_6859

jr_006_6859:
    nop
    nop
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
    ld a, l
    ld a, [$7aff]
    rst $38
    ld a, d
    rst $38
    ld a, d
    rst $38
    ld a, d
    db $fd
    ld a, d
    cp a
    ld e, d
    rst $18
    ld a, [hl-]
    sbc a
    ld a, d
    nop
    nop
    nop
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
    dec hl
    dec d
    ccf
    dec d
    ccf
    dec d
    ccf
    dec d
    dec hl
    dec d
    ccf
    dec d
    ccf
    dec d
    ld a, a
    dec d
    ld a, a
    dec d
    nop
    nop
    nop
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
    cp a
    ret nz

    rst $38
    cp a
    rst $38
    cp a
    rst $38
    and h
    ld [$eabf], a
    cp a
    ei
    ccf
    ld a, e
    cp a
    ld a, e
    add h
    nop
    nop
    nop
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
    cp d
    ld [hl], h
    cp $b4
    cp $b4
    cp $b4
    cp $b4
    ld a, [$feb4]
    sub h
    sbc $b4
    sbc $34
    nop
    nop
    nop
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
    xor e
    ld e, h
    db $eb
    ld e, a
    db $eb
    ld e, a
    db $eb
    ld e, [hl]
    xor d
    ld e, a

jr_006_68f0:
    ld [$eb5f], a
    ld d, a
    rst $28

jr_006_68f5:
    ld d, e
    db $eb
    ld d, h
    nop
    nop
    nop
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
    db $ec
    jr jr_006_68f5

    ld hl, sp-$14
    ld hl, sp+$6c
    cp b
    inc l
    ld hl, sp+$2c
    ld hl, sp+$6c
    ldh a, [$7c]
    ldh [$64], a
    sbc b
    cp a
    ld e, e
    rst $38
    ld e, e
    db $fd
    ld e, e

jr_006_691e:
    db $fd
    ld e, e
    cp $59
    rst $28
    ld e, [hl]
    ei
    ld b, a
    cp l
    ld b, e
    rst $38
    ld b, c
    rst $38
    ld b, c
    rst $38
    ld b, c
    db $fd
    ld b, e
    db $fd
    ld b, e
    rst $38
    ld b, e
    cp a
    ld b, e
    rst $38
    nop
    ld a, e
    add a
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, a
    rst $38
    cp a
    ld a, a
    rst $08
    ccf
    rst $38
    nop
    rst $38
    jr nc, @+$01

    jr nc, jr_006_691e

    jr nc, jr_006_68f0

    ld h, b
    rst $38
    ld h, b
    rst $38
    ld h, b
    rst $38
    nop
    cp l
    jp $ffff


    rst $38
    rst $38
    rst $38
    rst $38
    cp $ff
    db $fd
    cp $fb
    db $fd
    rst $20
    ld sp, hl
    rst $38
    ld bc, $19ff
    rst $38
    add hl, de
    rst $20
    add hl, de
    di
    dec c
    rst $38
    dec c
    rst $38
    dec c
    rst $38
    nop
    cp $b4
    cp $b4
    ld a, d
    or h
    ld a, [hl]
    or h
    cp $34
    xor $f4
    cp [hl]
    call nz, $847e
    cp $04
    ld a, [$fe04]
    inc b
    ld a, [hl]
    add h
    ld a, [hl]
    add h
    cp $84
    ld a, [$fe84]
    nop
    ld [bc], a
    ld bc, $0103
    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0102
    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0103
    ld [bc], a
    ld bc, $0003
    db $eb
    ld a, h
    rst $28
    ld a, a
    rst $28
    ld a, a
    rst $28
    ld a, a
    rst $30
    ld l, a
    cp e
    ld [hl], a
    db $dd
    dec sp
    xor $19
    rst $38
    ld [$09ff], sp
    rst $38
    add hl, bc
    xor $19
    db $ec
    dec de
    cp $1b
    cp $1b
    rst $38
    nop
    or a
    ld a, b
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    cp $ff
    db $fd
    cp $ff
    nop
    ld a, e
    add [hl]
    ld a, e
    add [hl]
    ld a, c
    add [hl]
    db $fc
    inc bc
    db $fd
    inc bc
    db $fd
    inc bc
    rst $38
    nop
    ld e, a
    ld a, [$fadf]
    db $dd
    ld a, [$fadf]
    cp a
    jp c, $ba77

    rst $28
    ld [hl], d
    rst $18
    ld h, d
    rst $38
    ld b, d
    db $fd
    ld b, d
    rst $38
    ld b, d
    rst $18
    ld h, d
    rst $18
    ld h, d
    rst $38
    ld h, d
    db $fd
    ld h, d
    rst $38
    nop
    dec hl
    dec d
    ccf
    dec d
    ccf
    dec d
    ccf
    dec d
    ccf
    dec d
    ccf
    dec d
    ld a, $15
    dec hl
    inc d
    ccf
    inc d
    ccf
    inc d
    ccf
    inc d
    ccf
    inc d
    ccf
    inc d
    ccf
    inc d
    dec hl
    inc d
    ccf
    nop
    dec [hl]
    adc $7f
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    rst $38
    ld a, a
    cp a
    rst $38
    rst $38
    cp a
    ld e, a
    cp a
    ld a, a
    add b
    ld a, a
    and b
    ld a, a
    and b
    ld e, a
    and b
    ld e, a
    and b
    rst $38
    and b
    rst $38
    and b
    rst $38
    nop
    sbc [hl]
    ld [hl], h
    sbc $f4
    jp c, $def4

    db $f4
    cp $d4
    cp [hl]
    db $f4
    xor $b4
    ld e, [hl]
    and h
    sbc $24
    jp c, $dea4

    and h
    ld e, [hl]
    and h
    ld e, [hl]
    and h
    cp $a4
    ld a, [$fea4]
    nop
    xor h
    ld d, a
    rst $28
    ld d, a
    rst $28
    ld d, a
    rst $28
    ld d, a
    db $eb
    ld d, a
    rst $28
    ld e, e
    rst $30
    ld c, a
    cp l
    ld b, a
    rst $38
    ld b, h
    rst $38

jr_006_6a8b:
    ld b, [hl]
    rst $38

jr_006_6a8d:
    ld b, [hl]
    db $fd
    ld b, [hl]
    db $fd
    ld b, [hl]
    rst $38
    ld b, [hl]
    cp a
    ld b, [hl]
    rst $38
    nop
    add h
    ld hl, sp-$1c
    ld hl, sp-$1c
    ld hl, sp-$1c
    ld hl, sp-$1c
    ld hl, sp-$04
    add sp, -$0c
    ld hl, sp-$24
    ldh a, [$fc]

jr_006_6aa9:
    db $10
    db $fc
    jr nc, jr_006_6aa9

    jr nc, jr_006_6a8b

jr_006_6aaf:
    jr nc, jr_006_6a8d

jr_006_6ab1:
    jr nc, jr_006_6aaf

jr_006_6ab3:
    jr nc, jr_006_6ab1

    jr nc, jr_006_6ab3

    nop
    rst $38
    nop
    rst $38
    ld b, a
    rst $38
    ld b, a
    rst $38
    ld b, a
    cp a
    ld b, a
    ld e, e
    daa
    ld a, e
    daa
    ld a, a
    inc hl
    ld e, l
    inc hl
    cpl
    ld de, $113e
    rra
    ld [$040b], sp
    rrca
    inc b
    rlca
    ld [bc], a
    inc bc
    ld bc, $00ff
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    di
    inc c
    rst $28
    inc e
    ld e, a
    cp h
    rst $20
    db $fc
    ei
    db $e4
    xor $f1
    ld a, a
    rst $38
    cp a
    ld a, a
    rst $28
    rra
    rst $38
    nop
    db $e3
    inc e
    rst $38
    nop
    rst $38
    ld bc, $01ff
    rst $38
    ld bc, $01ff
    sbc a
    ld h, c
    rst $28
    ld [hl], c
    push af
    ld a, e
    rst $08
    ld a, a
    cp a
    ld c, a
    xor $1f
    db $fd
    cp $fb
    db $fc
    rst $28
    ldh a, [rIE]
    nop
    adc a
    ld [hl], c
    cp $00
    cp $c4
    cp $c4
    cp $c4
    ld a, [$b4c4]
    ret z

    cp h
    ret z

    db $fc
    adc b
    ld [hl], h
    adc b
    add sp, $10
    ld hl, sp+$10
    ldh a, [rNR41]
    and b
    ld b, b
    ldh [rLCDC], a
    ret nz

    add b
    add b
    nop
    inc bc
    nop
    inc bc
    ld bc, $0103
    inc bc
    ld bc, $0102
    ld bc, $0100
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
    rst $38
    nop
    rst $38
    jr @+$01

    jr @+$01

    jr @+$01

    jr jr_006_6be2

    sbc b
    cp $99
    jp hl


    sbc a
    ld l, [hl]
    sbc a
    cp a
    ld c, [hl]
    or $4f
    ei
    daa
    xor l
    ld d, e
    xor [hl]
    ld d, c
    ld a, a
    db $10
    ld a, $09
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
    inc sp
    call z, $cefd
    cp $cf
    ld a, c
    rst $08
    or a
    ld c, c
    call $ff33
    rst $38
    cp $ff
    db $fd
    cp $ff
    nop
    ld sp, $ffce
    nop
    rst $38
    ld [hl], d
    rst $38
    ld [hl], d
    rst $38
    ld [hl], d
    db $fd
    ld [hl], d
    ld [$ee74], a
    ld [hl], h
    ld a, [hl]
    db $e4
    jp c, $f4e4

    ret z

    or h
    ret z

    ld a, h
    adc b
    add sp, $10
    ld hl, sp+$10
    ldh a, [rNR41]
    ldh [rLCDC], a
    ccf
    nop
    ccf
    dec d
    ccf
    dec d
    ccf
    dec d
    dec hl
    dec d
    inc d
    dec bc
    ld a, $0b
    ccf
    ld a, [bc]
    ld e, a
    ld a, [hl+]
    ld c, a
    dec [hl]
    ccf
    dec d
    ld a, [de]
    dec b
    dec b
    ld [bc], a
    rlca
    ld [bc], a
    rlca
    ld [bc], a
    dec bc
    dec b
    rst $38
    nop
    rst $38
    add b
    rst $38
    add b
    rst $38
    add b
    rst $38
    add b

jr_006_6be2:
    push af
    adc d
    xor $9b
    sbc a
    ei
    ld l, [hl]
    ei
    push af
    ld l, d
    ldh [$7f], a
    cp a
    ld a, a
    ld e, a

jr_006_6bf1:
    cp a
    xor $9f
    rst $38
    add b
    db $e4
    ld e, e
    cp $00
    cp $34
    cp $34
    cp $34
    ld a, [$e434]
    jr c, jr_006_6bf1

    jr c, jr_006_6c43

    add sp, -$24
    add sp, -$08
    ret nc

    ld hl, sp-$30
    xor b
    ret nc

    ld d, b
    and b
    ldh a, [rNR41]
    ldh a, [rNR41]
    ldh [rLCDC], a
    nop
    nop
    nop
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
    rst $28
    ld e, b
    rst $28
    ld e, b
    rst $28
    ld e, b
    xor a
    ld e, b
    sub $29
    push af
    xor e
    ei
    and a
    push af
    xor a
    db $76
    xor l
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_6c43:
    nop
    db $fc
    nop
    db $fc
    db $10
    db $fc
    db $10
    db $fc
    db $10
    db $fc
    db $10
    add sp, $10
    xor b
    ld d, b
    ret z

    ld [hl], b
    xor b
    ld [hl], b
    ld hl, sp+$20
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0162
    or l
    ld h, d
    ld e, e
    inc h
    ld e, h
    daa
    ld e, l
    ld [hl+], a
    ld h, l
    ld a, [hl-]
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
    ld [hl], c
    adc [hl]
    ld hl, sp+$47
    ld a, [hl]
    or c
    or a
    inc c
    rra
    inc bc
    sub [hl]
    dec c
    rst $30
    dec c
    add e
    db $fd
    inc bc
    db $fd
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
    dec e
    ld [c], a
    ccf
    call nz, $1bfc
    jp c, $f161

    add b
    db $d3
    ld h, b
    sbc $61
    add e
    ld a, [hl]
    add c
    ld a, [hl]
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
    add b
    nop
    adc h
    nop
    ld e, d
    adc h
    or h
    ld c, b
    ld [hl], h
    ret z

    ld [hl], h
    adc b
    ld c, h
    cp b
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
    nop
    nop
    nop
    nop
    nop
    ld [hl], c
    adc [hl]
    ld hl, sp+$47
    ld a, [hl]
    ld sp, $0c37
    rra
    inc bc
    ld a, [bc]
    dec b
    dec bc
    dec b
    ld a, e
    dec b
    and e
    ld a, l
    rst $38

jr_006_6d0b:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec e
    ld [c], a
    ld a, $c4
    cp $18
    call c, $e460
    sbc b
    xor b
    db $10
    xor b
    db $10
    rst $08
    jr nc, jr_006_6d0b

    ccf
    cp a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec hl
    inc d
    scf
    ld a, [de]
    daa
    add hl, de
    dec d
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
    nop
    nop
    nop
    nop
    nop
    inc bc
    db $fc
    add [hl]
    ld a, c
    rst $28
    ld [de], a
    ld a, d
    call z, Call_000_30fc
    jr z, jr_006_6d74

    jr c, jr_006_6d76

    ccf
    db $10
    ld a, [hl-]
    rla
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

jr_006_6d74:
    nop
    nop

jr_006_6d76:
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
    ld de, $330e
    inc e
    inc h
    jr jr_006_6db3

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

jr_006_6db3:
    nop
    nop
    nop
    nop
    nop
    db $e4
    cp e
    ld [hl], c
    xor [hl]
    cp e
    ld d, l
    ld l, [hl]
    dec de
    ccf
    inc b
    ld a, [hl+]
    inc d
    ld l, $14
    ld c, a
    inc [hl]
    ld l, [hl]
    dec [hl]
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

    add b
    ret nz

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

jr_006_6de6:
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
    call nc, $eb2f
    rla
    ccf
    db $d3
    db $fd
    inc de
    xor e

jr_006_6e01:
    call nc, $eb1c
    sub $29
    dec [hl]
    ld a, [bc]
    rra
    inc b
    dec de
    dec b
    dec h
    ld a, [de]
    ld a, [hl+]
    ld de, $112b
    ld c, a
    ld sp, $3d63
    ccf
    nop
    jr c, @-$1e

    ret nc

    ldh [$f0], a
    ret nz

    or b
    ret nz

    ldh a, [rP1]
    and b
    ld b, b
    jr nz, jr_006_6de6

    ld h, b
    add b
    ret nz

    nop
    ret nz

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
    ld [hl], c
    adc [hl]
    ld hl, sp+$47
    ld l, [hl]
    ld sp, $0c37
    ld l, a
    inc sp
    ld c, [hl]
    ld sp, $314b
    dec hl
    ld de, $112b
    daa
    jr jr_006_6e73

    inc e
    ld c, h
    jr nc, jr_006_6e01

    ld h, b
    and b
    ld b, b
    ret nz

    nop
    nop
    nop
    dec e
    ld [c], a
    ccf
    call nz, $1aed
    reti


    ld h, [hl]
    ld sp, hl
    add [hl]
    adc c
    ld b, $8a
    inc b
    adc d
    inc b
    adc e
    inc b
    adc d
    dec b
    db $10
    rrca
    dec de
    inc c
    inc c
    nop
    nop

Call_006_6e73:
jr_006_6e73:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc bc
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
    ld [hl], c
    adc [hl]
    ld hl, sp+$47
    ld a, [hl]
    ld sp, $0c77
    ld c, a
    inc sp
    ld d, d
    ld hl, $2153
    db $d3
    ld hl, $a153
    dec bc
    ldh a, [$d8]
    jr nc, jr_006_6eff

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    dec e
    ld [c], a
    ld a, $c4
    db $fc
    jr @-$22

    ld h, b
    and $9c
    sub d
    inc c
    sub d
    inc c
    adc d
    inc b
    adc d
    inc b
    adc e
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
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_6eff:
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
    ld [hl], c
    adc [hl]
    ld hl, sp+$47
    ld a, [hl]
    ld sp, $0c37
    ld c, a
    inc sp
    ld h, $19
    daa
    add hl, de
    rst $10
    add hl, bc
    ld [hl], a
    ret


    add e
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
    dec e
    ld [c], a
    ld a, $c4
    db $fc
    jr @-$22

    ld h, b
    and $9c
    sub d
    inc c
    sub h
    ld [$18a4], sp
    xor b
    db $10
    rst $08
    jr nc, jr_006_6faf

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
    dec e
    ld [c], a
    ld a, $c4
    cp $18
    call c, $e460
    sbc b
    xor b
    db $10
    call z, $e330
    inc a
    cp [hl]
    inc bc
    add e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [hl], c
    adc [hl]
    ld hl, sp+$47
    ld a, [hl]
    ld sp, $0c77
    cpl
    inc de
    ld h, $19
    rla
    add hl, bc
    rla
    add hl, bc
    rla
    add hl, bc
    inc sp
    inc c
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
    dec e
    ld [c], a
    ld a, $c4
    db $fc
    jr @-$22

    ld h, b
    add sp, -$70
    call z, $e330
    inc a
    cp [hl]
    inc bc
    add e
    nop
    add b
    nop
    nop
    nop
    nop

jr_006_6faf:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [hl], c
    adc [hl]
    ld hl, sp+$47
    ld a, [hl]
    ld sp, $0c37
    rra
    inc bc
    ld [de], a
    dec c
    dec bc
    dec b
    dec bc
    dec b
    dec bc
    dec b
    dec bc
    inc b
    ld [de], a
    inc c
    inc a
    db $10
    ld d, b
    jr nz, jr_006_7033

    nop
    nop
    nop
    nop
    nop
    dec e
    ld [c], a
    ccf
    call nz, $1afd
    call c, $e767
    add b
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
    nop
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
    ld d, b
    ldh [$d0], a
    jr nz, jr_006_7023

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld [$0f07], sp
    nop

jr_006_7020:
    rlca
    inc bc
    rlca

jr_006_7023:
    ld bc, $030f
    rla
    rrca
    rra
    rrca
    rra
    rlca
    rrca
    nop
    ld b, $01
    dec b
    ld [bc], a
    inc b

jr_006_7033:
    inc bc
    inc b
    inc bc
    ld [$8007], sp
    nop
    ld h, b
    add b
    db $10
    ldh [$50], a
    ldh [$c8], a
    ld [hl], b
    ld [$8ef0], sp
    ldh a, [$93]
    xor $bd
    jp nz, $936c

    jp z, $7f31

    add b
    add d
    rst $38
    db $fc
    inc bc
    scf
    ldh [$08], a
    ldh a, [$e0]
    nop
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    and b
    ld b, b
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    and b
    ld b, b
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    dec de
    nop
    inc l
    inc de
    jr z, jr_006_7095

    ld c, a
    jr nc, jr_006_7020

    ld [hl], e
    rst $10
    ld hl, $235f
    ld d, a
    cpl
    ld e, a
    cpl
    ld a, a
    daa
    ccf
    nop
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b

jr_006_7095:
    inc bc
    ld [$8007], sp
    nop
    ld h, b
    add b
    db $10
    ldh [$50], a
    ldh [$c8], a
    ld [hl], b
    ld [$8ef0], sp
    ldh a, [$93]
    xor $bd
    jp nz, $936c

    ld [$7631], a

Call_006_70af:
    pop hl
    ld [hl], l
    db $e3
    ld [hl], e
    ldh [$30], a
    ldh [$08], a
    ldh a, [rSVBK]
    nop
    ld c, h
    jr nc, jr_006_70e7

    inc e
    dec d
    ld a, [bc]
    ld d, $09
    dec c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld [$8f07], sp
    nop
    ld h, a
    add e
    rla
    pop hl
    adc a
    ld [hl], e
    ld [hl], a

jr_006_70e7:
    cpl
    ccf
    rrca
    rra
    rlca
    rrca
    nop
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [$0007], sp
    nop
    nop
    nop
    nop
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
    rra
    add a

jr_006_710b:
    ld a, b
    db $f4
    ld [$000c], sp
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
    ld [$0f07], sp
    nop
    rlca
    inc bc
    rlca
    ld bc, $030f
    rst $30
    rrca
    rra
    rst $28
    rst $38
    daa
    ccf
    nop
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [$0007], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
    inc bc
    ld [$0f07], sp
    nop
    rlca
    inc bc
    rlca
    ld bc, $030f
    rla
    rrca
    rra
    rrca
    ccf
    rlca
    ld c, a
    jr nc, jr_006_710b

    ld [hl], e
    sub h
    ld h, e
    inc h
    jp $8344


    adc b
    rlca
    add hl, bc
    ld b, $19
    ld c, $12
    inc c
    ld [de], a
    inc c
    ld [de], a
    inc c
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
    jr z, jr_006_71b4

    jr z, jr_006_71b6

    ld c, a
    jr nc, @+$64

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

jr_006_71b4:
    nop
    nop

jr_006_71b6:
    nop
    nop
    and b
    ld b, b
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
    and b
    ld b, b
    ldh [rLCDC], a
    ldh [rLCDC], a
    ldh [rLCDC], a
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
    dec b
    ld [bc], a
    ld b, $03
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
    nop
    nop
    ret


    ld b, $59
    adc [hl]
    sub d
    inc c
    sub d
    inc c
    sub d
    inc c
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
    inc bc
    ld [$0807], sp
    rlca
    ld [$0807], sp
    rlca
    jr nc, jr_006_7247

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_7247:
    nop
    add b
    nop
    ld [hl], b
    add b
    inc c
    ldh a, [rSC]
    db $fc
    ld bc, $01fe
    cp $01
    cp $01
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
    rrca
    nop
    db $10
    rrca
    jr nz, jr_006_728d

    ld b, d
    dec a
    ld b, e
    inc a
    add h
    ld a, b
    ld [$08f0], sp
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
    ldh a, [rP1]
    inc c
    ldh a, [$fa]

jr_006_728d:
    inc a
    db $ed
    ld a, [$0ef3]
    dec c
    ld [bc], a
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
    inc bc
    nop
    rlca
    inc bc
    rlca
    ld bc, $0003
    inc b
    inc bc
    add hl, bc
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
    ret nz

    nop
    or b
    ret nz

    ld e, $e0
    db $fd
    ld c, $6f
    ldh a, [$f2]
    inc c
    rrca
    nop
    ld [hl], $0f
    ld d, b
    ccf
    ld a, b
    rlca
    ret nc

    ld l, a
    ldh [$1f], a
    ret nc

jr_006_72e5:
    ld l, a
    ldh [$1f], a
    ret nc

    ld l, a
    ldh [$1f], a
    ld d, a
    jr c, jr_006_7327

    nop
    nop
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
    cp h
    nop
    ld b, e
    cp h
    jr nz, jr_006_72e5

    db $10
    rst $28
    ld [$07f7], sp
    ld hl, sp-$80
    ld a, a
    ld b, b
    ccf
    jr nz, jr_006_7331

    db $10
    rrca
    db $10
    rrca
    ld [$0007], sp
    nop
    nop
    nop
    nop
    nop
    ld a, $00
    ld hl, $fc1e
    inc bc
    ld a, $f9
    ld a, [hl-]

jr_006_7327:
    push de
    rst $38
    nop
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop

jr_006_7331:
    rst $38
    nop
    rst $38
    nop
    rst $38
    cp $01
    nop
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
    ldh a, [rP1]
    ld [$04f0], sp
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
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

jr_006_7367:
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    dec b
    ld [bc], a
    dec de
    inc b

jr_006_7372:
    inc hl
    dec e
    ld b, e
    inc a
    ld b, l
    ld a, [hl-]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ldh a, [rP1]
    rst $38
    ld h, c
    sbc [hl]
    ld [hl], d
    call $b34c
    jr nc, jr_006_7367

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    jr nz, jr_006_7372

    db $10
    ldh [rNR10], a
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
    dec b
    rla
    dec bc

jr_006_73d4:
    daa
    dec de
    ld c, e
    scf
    nop
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
    ld b, d
    inc a
    pop hl
    ld e, $b8
    ld b, a
    xor h
    di
    and h
    ld e, a
    db $e4
    rra
    add h
    ld a, e
    ldh [$df], a
    and b
    rst $18
    ld h, b
    cp a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld b, b
    add b
    ld b, b
    add b
    jr nz, jr_006_73d4

    db $10
    ldh [rNR10], a
    ldh [rP1], a
    nop
    ld bc, $0300
    nop
    rrca
    ld bc, $0f36
    ld c, a
    ccf
    ld a, l
    inc bc
    dec hl
    inc e
    dec de
    rlca
    rrca
    ld bc, $0e1d
    cpl
    rra
    cpl
    rra
    inc sp
    rrca
    ld c, l
    ld a, $7e
    dec a
    ret z

    scf
    ld b, h
    cp e
    call nz, $84bb
    ld a, e
    ld c, h
    di
    adc b
    rst $30
    ret nz

    cp a
    add b
    ld a, a
    add b
    rst $38
    ret nz

    cp a
    add b
    ld a, a
    ret nz

    rst $38
    ret nz

    rst $38
    pop hl
    cp $b7
    ld a, b
    reti


    or [hl]
    ld a, $c1
    ld c, h
    add e
    ld [hl], b
    adc a
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld bc, $1efe
    ldh [rNR41], a
    ret nz

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
    db $10
    ldh [rNR10], a
    ldh [rNR23], a
    ldh [rNR50], a
    ret c

    inc a
    ret c

    ld e, d
    cp h
    ld e, [hl]
    cp h
    cp d
    inc e
    inc l
    db $10
    stop
    nop
    nop

jr_006_748e:
    nop
    nop

jr_006_7490:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
    inc bc
    ld [$0807], sp
    rlca
    db $10
    rrca
    db $10
    rrca
    jr nz, jr_006_74d7

    ld [de], a
    rrca
    cpl
    rra
    ld c, a
    ccf
    add e
    ld a, a
    add a
    ld a, b
    ld [$08f0], sp
    ldh a, [rNR10]
    ldh [rNR10], a
    ldh [rNR41], a
    ret nz

    jr nz, jr_006_748e

    jr nz, jr_006_7490

    ld b, b
    add b
    ld b, b
    add b
    add b
    nop
    add b

jr_006_74d7:
    nop
    pop de
    ld a, $f1
    ld e, [hl]
    ld [hl], b
    adc a
    ret nc

    adc a
    ret nc

    rrca
    ld [$0807], sp
    rlca
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [bc], a
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
    add b
    nop
    add b
    nop
    ld b, b
    add b
    ld b, b
    add b
    jr nz, @-$3e

    jr nz, @-$3e

    db $10
    ldh [rNR10], a
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp-$7e
    ld a, h
    add d
    ld a, h
    rlca
    nop
    ld [bc], a
    ld bc, $0304
    dec b
    inc bc
    dec bc
    rlca
    rrca
    rlca
    rla
    rrca
    rla
    rrca
    rra
    rrca
    rra
    rrca
    rra
    rrca
    rra
    rrca
    rla
    rrca
    rla
    rrca
    rrca
    rlca
    dec bc
    rlca
    ld a, c
    cp $fe
    rst $38
    scf
    rst $38
    pop af
    rst $38
    ld a, [c]
    rst $38
    or $f9
    xor c
    sub $da
    and a
    ei
    and a
    ret c

    and a
    xor d
    rst $10
    pop af
    sbc $fb
    sbc $ff
    sbc $ff
    sbc $af
    sbc $04
    ld hl, sp-$78
    ld [hl], b
    ld [$48f0], sp
    or b
    ld c, b
    or b
    ld [$08f0], sp
    ldh a, [$b8]
    ld b, b
    call nz, $8238

jr_006_756b:
    ld a, h
    add d
    ld a, h
    add d
    ld a, h
    adc d
    ld [hl], h
    adc d
    ld [hl], h
    add d
    ld a, h
    inc b
    ld hl, sp+$00
    nop
    ld bc, $0200
    ld bc, $0102
    inc b
    inc bc
    ld [$3007], sp
    rrca
    ld b, c
    ld a, $7a
    inc h
    adc $38
    or l
    ld e, [hl]
    ret c

    ld h, a
    ldh [$7f], a
    ld e, b
    ccf
    jr nc, jr_006_75a5

    rrca
    nop
    adc e
    ld [hl], a
    dec c
    or $0e
    push af
    ld [de], a
    db $ed
    inc d
    db $eb
    jr c, jr_006_756b

jr_006_75a4:
    ld c, b

jr_006_75a5:
    add a

jr_006_75a6:
    sub b
    rrca

jr_006_75a8:
    jr nz, jr_006_75c9

jr_006_75aa:
    ld b, b
    ccf
    add e
    ld a, h
    dec c
    di
    rla
    rst $28
    ld l, $df
    ld e, l
    cp [hl]
    cp [hl]
    dec e
    ret nz

    ccf
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    inc bc
    db $fc
    inc b
    ei
    rra
    ldh [rNR52], a
    rst $18
    dec e

jr_006_75c9:
    cp $c2
    dec a
    dec a
    cp $7f
    cp [hl]
    or a
    ld c, [hl]
    db $eb
    ld d, h
    db $f4
    ld e, e
    or h
    ld e, e
    ld [$08f0], sp
    ldh a, [rNR10]
    ldh [rNR10], a
    ldh [$a0], a
    ld b, b
    jr nz, jr_006_75a4

    jr nz, jr_006_75a6

    jr nz, jr_006_75a8

    jr nz, jr_006_75aa

    db $10
    ldh [rNR10], a
    ldh [$08], a
    ldh a, [$08]
    ldh a, [$88]
    ld [hl], b
    ld c, b
    or b
    ld [$00f0], sp
    nop
    ld bc, $0200
    ld bc, $0102
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [$0807], sp
    rlca
    ld [$0807], sp
    rlca
    ld [$0407], sp
    inc bc
    inc b
    inc bc
    adc c
    db $76
    ld c, $f1
    dec bc
    db $f4
    rlca
    ei

Call_006_7620:
    rra
    rst $28
    db $10
    rst $28
    rla
    rst $28
    cpl
    rst $18
    cpl
    rst $18
    ld a, a
    sbc a
    ld a, a
    sbc a
    rst $38
    rra
    cp a
    rra
    cp a
    rra
    rst $38
    rra
    rst $28
    rra
    ldh [$5f], a
    ret nz

    ccf
    ld [hl], b
    rst $38
    ld hl, sp-$01
    db $fc
    ei
    db $fc
    ei
    and $f9
    cp $f9
    ld a, [$fefd]
    db $fd
    or $f9
    ld [$f2f5], a
    db $ed
    db $f4
    db $eb
    ld hl, sp-$19
    ldh a, [$8f]
    ld [$08f0], sp
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [rNR14]
    add sp, $14
    add sp, $14
    add sp, $14
    add sp, $14
    add sp, $14
    add sp, $28
    ret nc

    cp e
    ld a, l
    cp d
    ld a, l
    cp a
    ld a, h
    cp a
    ld a, [hl]
    cp [hl]
    ld a, a
    cp a
    ld a, a
    ld a, a
    ld a, $5f
    ld a, $5e
    ccf
    ccf
    rra
    cpl
    rra
    rla
    rrca
    dec de
    rlca
    inc a
    inc bc
    scf
    ld [$0e11], sp
    ld l, b
    sub a
    sbc b
    ld h, a
    ld l, d
    push af
    sbc c
    or $c9
    ld [hl], $91
    ld a, [hl]
    ld sp, hl
    ld a, [hl]
    cp $e9
    db $fc
    dec sp
    sub h
    ei
    ld hl, sp-$39
    ldh [$df], a
    ret nc

    rst $28
    reti


    and $8e
    ld [hl], b
    ld hl, sp+$00
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
    add b

jr_006_76c4:
    ld b, b
    add b

jr_006_76c6:
    ld b, b
    add b
    ld b, b
    add b
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
    jr nz, jr_006_76f9

    jr nz, jr_006_76fb

    jr nz, jr_006_76fd

    jr nz, jr_006_76ff

    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    ld [$0807], sp
    rlca
    ld [$0407], sp
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $0102
    ld bc, $0000
    nop
    add b

jr_006_76f9:
    nop
    add b

jr_006_76fb:
    nop
    ld b, b

jr_006_76fd:
    add b
    ld b, b

jr_006_76ff:
    add b
    ld b, b
    add b
    jr nz, jr_006_76c4

    jr nz, jr_006_76c6

    db $10
    ldh [rNR10], a
    ldh [rIF], a
    ldh a, [$03]
    db $fc
    rlca
    ei

jr_006_7710:
    rrca
    pop af
    inc d
    db $eb
    inc a
    rst $18
    rst $18
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
    ld bc, $ee00
    ld bc, $ef10
    ld [$88f7], sp
    ld [hl], a
    ret nz

    cp a
    ldh [$9f], a
    jr nz, @+$01

    and b
    ld a, a
    add c
    ld a, [hl]
    add c
    ld a, [hl]
    ld b, c
    ld a, $41
    ld a, $42
    inc a
    add d
    ld a, h
    add h
    ld a, b
    inc b
    ld hl, sp+$08
    ldh a, [rNR10]
    ldh [rNR41], a
    ret nz

    jr nz, jr_006_7710

    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    add b
    nop
    dec c
    inc bc
    ld e, $01
    add hl, de
    ld b, $10
    rrca
    db $10
    rrca
    ld c, $01
    ld bc, $0f00
    nop
    ld e, $0f
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
    ld e, a

jr_006_7779:
    cp [hl]
    db $fd
    ld a, [hl]
    di
    inc c
    cp $01
    ccf
    ret nz

    ld [$c4f0], sp
    jr c, jr_006_7779

    inc c
    ld a, c
    cp $ff
    nop
    nop
    nop
    nop
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
    add sp, $28
    ret nc

    ret z

    jr nc, jr_006_77cf

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
    ccf
    dec e
    dec l
    ld e, $1b
    ld b, $1c
    inc bc
    rra
    nop

jr_006_77c2:
    add hl, de
    ld b, $10
    rrca
    add hl, bc
    ld b, $05
    ld [bc], a
    ld [bc], a
    ld bc, $0003
    inc bc

jr_006_77cf:
    nop
    ld a, h
    inc bc
    cp h
    ld a, a
    rst $38
    nop
    nop
    nop
    ld h, h
    db $db
    call nc, $04fb
    ei
    call nc, $fc7b
    ld a, e
    sbc h
    ld a, e
    db $fc
    dec sp
    db $ed
    ld a, [$748a]
    ld a, h
    add b
    adc b
    ld [hl], b
    inc b
    ld hl, sp+$04
    ld hl, sp-$58
    ld [hl], b
    ld [hl], b
    nop
    nop
    nop
    ld [$10f0], sp
    ldh [rNR10], a
    ldh [rNR41], a
    ret nz

    jr nz, jr_006_77c2

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
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    rlca
    nop
    rrca
    ld [bc], a
    dec d
    ld c, $1a
    dec c
    rrca
    inc bc
    rlca
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
    sbc a
    ld l, a
    adc e
    ld [hl], a
    add a
    ld a, b
    add e
    ld a, h
    ld b, c
    cp [hl]
    ld [c], a
    dec e
    cp h
    jp $ff00


    add b
    rst $38

jr_006_784a:
    nop
    rst $38
    add e
    ld a, h
    dec a
    di
    db $fd
    rlca
    dec bc
    rlca
    rlca
    inc bc
    inc bc
    nop
    sub b
    ld l, a
    and b
    ld e, a
    ret nz

    ccf
    add b
    ld a, a
    ld bc, $02fe
    db $fc
    inc b
    ld hl, sp+$08
    ldh a, [$30]
    ret nz

    ret nz

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
    jr z, jr_006_784a

    ld c, b
    or b
    ld d, b
    and b
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
    nop
    nop
    nop
    nop
    nop
    nop
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
    rrca
    ld [$6507], sp
    ld [bc], a
    sub $61
    reti


    ld [hl], $b8
    ld c, a
    ld l, e
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
    ld b, b
    add b
    ret nz

    nop
    ld b, b
    add b
    ld b, b
    add b
    and b
    ld b, b
    and b
    ld b, b
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
    cp l

jr_006_78d9:
    ld a, [hl]
    and [hl]
    ld a, c
    ld a, a
    rlca
    ld e, a
    jr nz, jr_006_7901

    rra
    ccf
    rra
    ld e, a
    ccf
    ld c, [hl]
    ccf
    ld e, a
    ccf
    cp a
    ld a, a
    cp a
    ld a, a

jr_006_78ee:
    rst $38
    ld a, a

jr_006_78f0:
    rst $38
    ld a, a

jr_006_78f2:
    rst $38
    ld a, a

jr_006_78f4:
    cp $7f
    rst $38
    ld a, [hl]
    jr nz, jr_006_78d9

    nop
    rst $38
    add b
    ld a, a
    nop
    rst $38
    nop

jr_006_7901:
    rst $38
    add b
    rst $38
    ret nz

    rst $38
    inc e
    db $e3
    ld [c], a
    db $dd
    and $dd
    cp $dd
    or $dd
    cp $c5
    xor e
    call nc, Call_000_3dda
    jp c, $80bd

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
    add b
    nop
    ld b, b
    add b
    ld b, b
    add b
    jr nz, jr_006_78ee

jr_006_792e:
    jr nz, jr_006_78f0

jr_006_7930:
    jr nz, jr_006_78f2

jr_006_7932:
    jr nz, jr_006_78f4

    ret nz

    nop
    ld b, b
    add b
    cp a
    ld a, [hl]
    cp a
    ld a, [hl]

jr_006_793c:
    ld a, [hl]
    ccf

jr_006_793e:
    ld e, [hl]
    ccf

jr_006_7940:
    rst $38
    rra

jr_006_7942:
    rst $28
    rra
    cp a
    ld c, a
    sbc e
    ld h, a
    adc h
    ld [hl], e
    ld l, a
    db $10
    ld e, $01
    ld c, $01
    ld c, c
    ld b, $b0
    ld c, a
    rst $08
    ld a, a
    rst $38
    nop
    call z, $3cbb
    ei
    db $fc
    ld a, e
    call nc, $887b
    ld [hl], a
    ld [hl], c
    adc [hl]
    xor [hl]
    pop de
    ldh [$df], a
    and b
    rst $18
    rst $38
    nop
    jr nz, jr_006_792e

    jr nz, jr_006_7930

    jr nz, jr_006_7932

    db $10
    ldh [$f0], a
    ldh [$f0], a
    nop
    ld b, b
    add b
    jr nz, jr_006_793c

    jr nz, jr_006_793e

    jr nz, jr_006_7940

    jr nz, jr_006_7942

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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $070b
    rrca
    nop
    rlca
    inc bc
    inc bc
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    rlca
    nop
    jr jr_006_79c3

    jr c, jr_006_79c5

    ld a, b
    rla
    or d
    ld a, l
    db $db

jr_006_79c3:
    cp $e3

jr_006_79c5:
    cp $aa
    ld [hl], l
    ld [hl], b
    adc a
    ld [hl], b
    rst $38
    adc b
    ld [hl], a
    cp $7f
    ld a, [hl]
    rst $38
    rst $38
    rst $38

jr_006_79d4:
    rst $38
    rst $38
    ld c, h
    rst $38
    nop
    nop
    add b
    nop
    add b
    nop
    sbc b
    nop
    ld h, h
    sbc b
    inc b
    ld hl, sp+$02
    db $fc
    ld bc, $01fe
    cp $01
    cp $00
    rst $38
    nop
    rst $38
    nop
    rst $38
    add b
    ld a, a
    nop
    rst $38

jr_006_79f6:
    ldh [$9f], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    jr nz, jr_006_79d4

    jr jr_006_79f6

    inc b
    ld hl, sp+$00
    nop
    ld bc, $0000
    ld bc, $0107
    dec c
    ld [bc], a
    ld a, $0f
    ld e, a
    ccf
    ld a, c
    rlca
    scf
    jr @+$81

    rlca
    sub a
    ld l, c
    xor c
    ld e, [hl]
    cp a
    ld e, a
    ld a, a
    rra
    ld l, b
    rra
    daa
    rra
    ld [hl], b
    nop
    adc b
    ld [hl], b
    adc b
    ld [hl], b
    add h
    ld a, b
    inc d
    add sp, $15
    ld hl, sp+$16
    ld sp, hl
    sub h
    ld l, e
    nop
    rst $38
    ld b, b
    cp a
    add b
    ld a, a
    add b
    ld a, a
    nop
    rst $38

jr_006_7a52:
    and b
    rst $18
    ret nc

    rst $28
    ld a, b
    rst $30
    nop
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
    add b
    jr nz, @-$3e

    db $10
    ldh [$0c], a
    ldh a, [$03]
    db $fc
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    jr nz, jr_006_7a52

    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rP1]
    nop
    nop
    nop
    ld bc, $0f00
    nop
    rra
    nop
    inc hl
    inc e
    inc hl
    inc e
    ld hl, $111e
    ld c, $0f
    nop
    rra
    rrca
    cpl
    rra
    inc h
    rra
    dec sp
    inc b
    inc h
    nop
    nop
    nop
    cp a
    ld a, a
    rst $38
    ld a, a
    ld a, a
    cp $7d
    cp $fe
    db $fd
    cp $fd
    ld [hl], d
    db $fd
    ld a, l
    ld [c], a
    db $e3
    ld e, h
    cp h
    ld e, a
    ld l, a
    sub e
    db $fc
    add e
    cp e
    rst $00
    ld sp, hl
    rst $20
    xor h
    ld [hl], e
    db $eb
    ld d, b
    db $10
    rst $28
    db $ec
    inc de
    rla
    add sp, $08
    rst $30
    inc b
    ei
    ld [$00f7], sp
    rst $38
    inc b
    ei
    inc b
    ei
    inc b
    ei
    add h
    ld a, e
    nop
    rst $38
    cp c
    add $bf
    ret nz

    ld b, [hl]
    cp b
    add h
    ld a, b
    inc b
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    add d
    ld a, h
    ld b, d
    cp h
    ld b, d
    cp h
    ld b, c
    cp [hl]
    ld b, c
    cp [hl]
    ld b, c
    cp [hl]
    ld h, c
    sbc [hl]
    and c
    ld e, $a1
    ld e, $21
    ld e, $11
    ld c, $11
    ld c, $11
    ld c, $2e
    rra
    ld e, a
    ccf
    ld a, a
    ccf
    ld a, a
    ccf
    ld a, a
    ccf
    ld a, a
    ccf
    ld a, a
    ccf
    ld e, a
    ccf
    cpl
    rra
    dec de
    inc c
    inc a
    dec bc
    ccf
    rlca
    ld c, [hl]
    ld sp, $3a45

jr_006_7b34:
    ld b, a
    add hl, sp
    ld b, d
    dec a
    cp [hl]
    ld sp, hl
    ld c, a
    cp $93
    db $fc
    ldh [rIE], a
    rst $38
    cp $fd
    cp $ff
    ldh a, [$d0]
    rst $28
    ldh [$df], a
    ret nz

    rst $38
    add b
    ld a, a
    ld b, b
    cp a
    ld b, b
    cp a
    and h
    db $db
    and d
    db $dd
    ld h, l
    jp c, $ff00

    db $fc
    inc bc
    sub d
    ld h, c
    ld de, $10e0
    ldh [rNR10], a
    ldh [$90], a
    ld h, b
    ld d, b
    and b
    db $10
    ldh [rNR10], a
    ldh [rNR10], a
    ldh [rNR41], a
    ret nz

    jr nz, @-$3e

    jr nz, jr_006_7b34

    ld b, b
    add b
    ret nz

    nop
    ld [$08f0], sp
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$84]
    ld a, b
    add h
    ld a, b
    ld b, d
    inc a
    ld b, d
    inc a
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [de], a
    inc c
    ld [de], a
    inc c
    ld [de], a
    inc c
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld h, d
    inc a
    sub b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld a, b
    add [hl]
    ld a, a
    add e
    ld a, h
    ld b, d
    inc a
    ld b, e
    inc a
    ld b, [hl]
    ccf
    add hl, hl
    rra
    rla
    ld c, $09
    ld b, $07
    nop
    nop
    nop
    nop
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
    ld b, $89
    ld b, $19
    ld b, $2f
    ld e, $7f
    ld a, [de]
    or a
    ld a, d
    db $fd
    ld h, d
    inc hl
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
    ld hl, $231e
    inc e

jr_006_7bfc:
    inc de
    dec c
    ld de, $380e
    rlca
    ld l, b
    scf
    call c, Call_006_6e73
    add hl, sp
    jr nc, jr_006_7c29

    jr jr_006_7c1b

    inc c
    rlca
    rlca
    ld [bc], a
    rlca
    ld [bc], a
    inc bc
    nop
    nop
    nop
    nop
    nop
    ret nz

    rst $38
    ret z

jr_006_7c1b:
    rst $30
    db $ec
    db $d3
    ld [hl], d
    pop bc
    pop hl
    nop
    ld b, b
    add b
    add b
    nop
    add b
    nop

Call_006_7c28:
    add b

jr_006_7c29:
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
    ret nz

    jr nc, jr_006_7bfc

    ld [$34f0], sp
    ld hl, sp+$49
    ldh a, [$c9]
    jr nc, jr_006_7c78

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

jr_006_7c53:
    nop
    nop
    nop
    nop
    nop
    sub d
    ld a, h
    db $f4
    jr jr_006_7c91

    jr jr_006_7c53

    jr jr_006_7cb9

    or b
    xor b
    ld [hl], b
    ldh a, [$80]
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

jr_006_7c78:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_006_7c91:
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld e, $e0
    nop

jr_006_7cb9:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld [bc], a
    ld b, $04
    ld c, $0c
    ld c, $0c
    inc e
    inc e
    inc e
    inc e
    dec a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    jr nz, jr_006_7ce5

jr_006_7ce5:
    ld b, b
    nop
    add b
    nop
    nop
    nop
    ld [$1010], sp
    nop
    jr nz, jr_006_7cf1

jr_006_7cf1:
    ld h, b
    ld b, b
    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0e00
    ld bc, $0d13
    inc a
    rra
    ld e, l
    ld a, $a7
    ld e, a
    db $eb
    ld [hl], a
    or h
    ld a, e
    db $fc
    ccf
    ld h, e
    rra
    adc [hl]
    ld a, a
    cp h
    ld a, a
    ld a, a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    pop hl
    nop
    sbc $e1
    db $ec
    di
    ld h, h
    ei
    db $db
    ld a, h
    rra
    rst $38
    ld a, [hl]
    rst $38
    cp $ff
    rst $28
    ldh a, [$9c]
    rst $38
    ld c, a
    ldh a, [$f0]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rrca
    nop
    ld a, [c]

jr_006_7d3f:
    dec c
    ld [hl+], a
    db $dd
    nop
    rst $38
    nop
    rst $38
    ret nz

    ccf
    ldh a, [rIE]
    ldh [rIE], a
    or b
    rst $08
    cp a
    ld b, b
    ldh [rP1], a
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    ld a, h
    inc bc
    sbc b
    ld h, a
    jr nz, jr_006_7d3f

    ret nz

    ccf
    add b
    ld a, a
    and b
    ld e, a
    ld [hl], b
    adc a
    ld sp, $3dce
    jp nc, $d629

    ldh [$1f], a
    inc d
    dec bc
    inc d
    dec bc
    inc c
    inc bc
    rlca
    nop
    add b
    ld a, a
    nop
    rst $38
    ld bc, $03fe
    db $fc
    add hl, de
    and $5d
    cp d
    push de
    ld a, [hl-]
    xor b
    ld [hl], a
    inc sp
    call z, Call_006_7fbf
    rst $38
    ccf
    ld e, [hl]
    cp a
    ld l, a
    sbc a
    ld l, h
    sbc a
    cp $1d
    db $fd
    inc bc
    dec [hl]
    jp z, $9669

    reti


    ld h, $c0
    ccf
    ld b, h
    cp e
    ld e, d
    cp l
    db $dd
    ld a, $be
    ld a, a
    ld a, [hl]
    rst $38
    cp [hl]
    rst $38
    cp l
    cp $ce
    ccf
    rst $30
    ld a, c
    ld l, l
    or e
    or e
    rst $08
    rst $30
    rst $08
    add b
    nop
    ldh [rP1], a
    ld a, h
    add b
    dec sp
    call nz, $d629
    add hl, hl
    sub $18
    rst $20
    sub h
    ld l, e
    sub h
    ld l, e
    inc d
    db $eb
    inc d
    db $eb
    add h
    ld a, e
    ld b, h
    cp e
    call nz, $a0bb
    rst $18
    ret c

    rst $20
    dec e
    ccf
    dec a
    ccf
    ccf
    ccf
    ccf
    ld a, [hl]
    ld a, $71
    ld [hl], e
    ld l, l
    ld a, h
    ld e, a
    ld e, l
    ld a, $a7
    ld e, a
    db $eb
    ld [hl], a
    or h
    ld a, e
    db $fc
    ccf
    ld h, e
    rra
    adc [hl]
    ld a, a
    cp h
    ld a, a
    ld a, a
    nop
    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    ret nz

    pop hl
    nop
    sbc $e1
    db $ec
    di
    ld h, h
    ei
    db $db
    ld a, h
    rra
    rst $38
    ld a, [hl]
    rst $38
    cp $ff
    rst $28
    ldh a, [$9c]
    rst $38
    ld c, a
    ldh a, [$f0]
    nop
    nop
    nop
    ld [bc], a
    ld bc, $0001
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
    rst $10
    rst $28
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, c
    cp $ce
    jr nc, jr_006_7e73

    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    db $db
    rst $20
    sbc $e1
    and c
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

jr_006_7e73:
    nop
    nop
    nop
    nop
    nop
    db $ec
    di
    ei
    db $fc
    sbc h
    ld a, a
    ld [hl], c
    ld c, $0f
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    dec de
    inc c
    cp $0d
    add hl, sp
    rst $18
    sub l
    ei
    db $db
    rst $30
    ld h, e
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
    ret nz

    add b
    and b
    ret nz

    and b
    ret nz

    ld [hl], b
    add b
    xor b
    ld [hl], b
    cp b
    ld a, a
    adc [hl]
    ld a, a
    ld d, a
    cpl
    dec hl
    rla
    inc hl
    rra
    dec l
    dec de
    dec de
    dec b
    ld a, [bc]
    dec b
    ld a, [bc]
    dec b
    add hl, bc
    ld b, $04
    inc bc
    ld b, $01
    ld [bc], a
    ld bc, $0001
    nop
    nop
    nop
    nop
    cp b
    ld [hl], b
    ld a, b
    ldh a, [$38]
    ldh a, [$c8]
    ldh a, [$d8]
    ldh [$b8], a
    ret nz

    db $e4
    ret c

    ld h, d
    call c, $dce3
    inc h
    db $db
    ret nz

    ccf
    nop
    rst $38
    ld [$09f7], sp
    or $8c
    ld [hl], e
    ld h, h
    dec de
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    and b
    ld b, b
    jr nc, @-$3e

    ld a, $c0
    rst $38
    nop
    ld a, a
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
    db $fc
    nop
    rrca
    ldh a, [rNR22]
    ld [$030c], sp
    jr jr_006_7f65

    jr nz, jr_006_7f7f

    ret nz

    ccf
    add b
    ld a, a
    and b

jr_006_7f65:
    ld e, a
    ld [hl], b
    rrca
    ld sp, $3d0e
    ld [de], a
    add hl, hl
    ld d, $20
    rra
    inc d
    dec bc
    inc d
    dec bc
    inc c
    inc bc
    rlca
    nop
    dec [hl]
    jp z, $926d

    ret c

    daa
    ret nz

jr_006_7f7f:
    ccf
    ld e, d
    cp l
    ld e, l
    cp [hl]
    db $fd
    ld a, $fd
    ld a, [hl]
    ld a, e
    db $fc
    cp e
    db $fd
    cp c
    rst $38
    rst $08
    ccf
    push af
    ld a, e
    ld l, e
    or a
    or e
    rst $08
    rst $30
    rst $08
    ldh [rP1], a
    inc a
    ret nz

    ccf
    ret nz

    rla
    add sp, $15
    ld [$ea15], a
    dec d
    ld [$ea15], a
    ld d, l
    xor d
    ld d, h
    xor d
    call nz, $a4ba
    jp c, $dae4

    ret nc

    xor $f0
    xor $e8
    or $00
    nop
    ld [bc], a
    nop
    ld [bc], a
    nop
    ld b, d

Call_006_7fbf:
    nop
    ld b, l
    ld [bc], a
    and l
    ld b, d
    and l
    ld b, d
    reti


    ld h, [hl]
    ld c, d
    rst $30
    ld h, [hl]
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, [hl]

jr_006_7fd1:
    rst $38
    rst $38
    ld a, [hl]
    cp l
    ld a, [hl]
    ld h, [hl]
    jr jr_006_7fd1

    or $f8
    or $74
    ld a, [$7abc]
    ld e, [hl]
    jr c, @+$2a

    ld e, $1a
    inc b
    ld c, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    db $06
