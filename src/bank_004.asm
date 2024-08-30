; Disassembly of "jb.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

    push bc

Call_004_4001:
    ld hl, $401a
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $cefe
    push de
    call DecompressTilesIntoVram
    pop hl
    pop bc
    ld a, [hl+]
    ld [$c113], a
    ld a, [hl]
    ld [$c114], a
    ret


    ld [hl-], a
    ld b, b
    jp nc, Jump_000_1e44

    ld c, c
    dec c
    ld c, l
    ret c

    ld d, c
    ld d, e
    ld d, [hl]
    db $10
    ld e, h
    sub c
    ld h, d
    bit 4, [hl]
    ld a, $6c
    ld b, $71
    ld a, a
    ld [hl], d

CompressedData4032::
    db $02, $06, $9c, $04, $00, $30, $08, $96, $80, $1d, $19, $98, $03, $71, $19, $8e
    db $87, $00, $00, $15, $03, $9d, $21, $46, $80, $08, $0a, $b3, $0d, $ac, $1a, $74
    db $14, $e0, $22, $10, $42, $c3, $c1, $9d, $98, $91, $31, $e2, $41, $10, $00, $c3
    db $08, $04, $48, $c5, $c8, $08, $80, $db, $62, $02, $c0, $72, $0f, $b0, $0e, $f2
    db $62, $81, $6a, $24, $09, $10, $04, $f5, $05, $64, $43, $8c, $00, $1c, $0f, $02
    db $70, $15, $16, $e2, $c2, $01, $62, $13, $19, $82, $80, $d1, $09, $00, $56, $25
    db $92, $c5, $9d, $80, $60, $54, $60, $58, $0c, $a8, $98, $d8, $71, $29, $0c, $d4
    db $25, $22, $c3, $02, $6c, $81, $8e, $b0, $90, $5b, $e3, $42, $2c, $50, $8d, $15
    db $81, $00, $29, $ec, $e0, $10, $00, $b0, $61, $00, $8e, $4b, $0a, $01, $68, $0c
    db $5d, $52, $74, $06, $01, $5e, $1e, $81, $60, $4e, $0c, $08, $08, $10, $05, $18
    db $2b, $24, $85, $3b, $01, $01, $ad, $1d, $17, $01, $a0, $10, $0e, $e8, $c5, $00
    db $75, $83, $af, $0a, $20, $e1, $a0, $23, $4c, $5c, $85, $85, $d7, $88, $02, $c0
    db $50, $90, $1b, $0b, $4a, $04, $00, $52, $78, $38, $0a, $0b, $22, $46, $47, $83
    db $c1, $0a, $42, $43, $43, $11, $e0, $35, $13, $10, $88, $42, $8c, $80, $10, $04
    db $44, $fb, $08, $04, $6a, $05, $b4, $c2, $8d, $09, $8b, $9d, $80, $82, $00, $5f
    db $4c, $20, $a0, $2e, $50, $53, $40, $20, $00, $09, $17, $1d, $e1, $80, $ae, $c0
    db $9d, $f8, $13, $24, $30, $86, $43, $93, $40, $80, $14, $ae, $c0, $ac, $b4, $e8
    db $04, $58, $64, $20, $02, $d1, $46, $30, $04, $40, $5b, $44, $01, $20, $18, $b0
    db $87, $17, $18, $02, $e0, $20, $c4, $08, $00, $89, $c4, $83, $20, $48, $69, $a4
    db $83, $e3, $82, $00, $a8, $88, $16, $16, $02, $e0, $bd, $80, $4e, $d8, $51, $51
    db $e1, $91, $52, $00, $90, $c3, $40, $e2, $b2, $20, $31, $20, $bc, $0a, $80, $35
    db $f8, $6e, $31, $1c, $06, $e4, $0b, $b8, $a5, $a1, $a1, $c1, $70, $35, $52, $81
    db $91, $91, $00, $b4, $ba, $c0, $78, $f9, $59, $32, $38, $38, $04, $31, $05, $04
    db $00, $aa, $46, $3c, $2e, $3c, $08, $81, $5a, $01, $da, $02, $42, $e2, $e0, $36
    db $c4, $82, $08, $e9, $98, $d8, $98, $d8, $f0, $48, $51, $00, $cf, $a1, $4e, $40
    db $40, $11, $43, $02, $82, $4e, $2b, $2d, $2c, $83, $00, $a3, $02, $ea, $b8, $00
    db $0e, $03, $88, $95, $e8, $08, $06, $a4, $3c, $02, $c1, $6d, $01, $0b, $29, $3a
    db $16, $3b, $3e, $07, $40, $42, $14, $d2, $b1, $08, $d0, $21, $19, $f1, $40, $0c
    db $41, $40, $09, $6c, $54, $a8, $28, $a0, $da, $02, $05, $c7, $c5, $4c, $21, $08
    db $02, $a8, $45, $2c, $08, $02, $d1, $70, $a0, $13, $4b, $e0, $00, $18, $0b, $83
    db $e1, $a0, $b7, $8b, $80, $13, $93, $9b, $02, $50, $1d, $c9, $48, $c0, $40, $f0
    db $2c, $a0, $45, $67, $00, $e8, $44, $1a, $00, $24, $44, $1d, $0b, $0b, $2c, $88
    db $0f, $8d, $43, $a0, $54, $20, $25, $4c, $09, $00, $4a, $c2, $ab, $81, $6a, $43
    db $47, $82, $60, $08, $bc, $86, $0f, $01, $09, $03, $c0, $24, $94, $08, $00, $41
    db $20, $a3, $05, $a8, $b8, $31, $29, $20, $80, $43, $e1, $00, $00, $16, $ca, $c2
    db $c5, $44, $06, $c9, $46, $47, $80, $8b, $22, $f0, $08, $0b, $42, $c3, $02, $f5
    db $d4, $10, $48, $88, $2a, $01, $a0, $a6, $08, $89, $0b, $0f, $02, $80, $5c, $cc
    db $38, $30, $5c, $15, $86, $a0, $f0, $13, $06, $14, $42, $a5, $00, $30, $1c, $5e
    db $c3, $46, $9f, $a2, $01, $21, $16, $45, $c5, $c4, $40, $00, $12, $37, $3c, $26
    db $07, $c2, $60, $78, $00, $ab, $90, $d4, $cc, $07, $c3, $d5, $ce, $c9, $c2, $42
    db $4a, $22, $10, $11, $4d, $0d, $7d, $2d, $80, $2d, $33, $0e, $40, $85, $18, $48
    db $6d, $81, $68, $e8, $88, $00, $8c, $f4, $10, $20, $03, $43, $18, $82, $81, $42
    db $38, $18, $0e, $d0, $e1, $00, $3c, $d7, $80, $80, $12, $0e, $04, $cb, $a9, $98
    db $d8, $08, $e8, $e0, $58, $98, $4c, $18, $c0, $e1, $42, $80, $40, $01, $01, $48
    db $6a, $30, $17, $0e, $ca, $c2, $42, $45, $00, $4e, $47, $c5, $65, $b0, $6f, $f0
    db $af, $65, $05, $08, $c3, $d5, $44, $82, $88, $7c, $36, $95, $8a, $0a, $0a, $c0
    db $51, $16, $31, $32, $30, $29, $2e, $0b, $0b, $43, $09, $41, $21, $4c, $10, $83
    db $db, $f0, $f0, $f5, $d3, $42, $29, $ca, $e0, $60, $81, $68, $c1, $66, $e1, $c2
    db $23, $00, $22, $40, $46, $93, $16, $c2, $03, $82, $28, $82, $00, $48, $44, $81
    db $9a, $85, $05, $04, $30, $17, $cf, $82, $20, $10, $ca, $63, $a1, $64, $72, $d8
    db $c2, $00, $2c, $b6, $20, $f1, $10, $e0, $31, $04, $d8, $10, $99, $aa, $00, $7e
    db $12, $28, $c0, $82, $70, $70, $70, $a0, $f1, $58, $18, $da, $24, $6c, $00, $0a
    db $61, $e1, $08, $00, $06, $6c, $11, $2c, $6c, $81, $69, $00, $80, $52, $6a, $f4
    db $21, $48, $1a, $10, $59, $58, $58, $08, $58, $50, $48, $98, $b4, $b0, $88, $08
    db $d1, $d3, $63, $80, $e3, $00, $18, $69, $20, $00, $94, $14, $50, $b3, $a0, $40
    db $00, $84, $1a, $38, $30, $19, $04, $02, $a1, $b0, $25, $90, $c4, $42, $00, $60
    db $ab, $e3, $e3, $64, $25, $25, $e8, $e3, $27, $62, $40, $84, $c2, $c1, $82, $82
    db $11, $c1, $a6, $aa, $a0, $21, $b0, $85, $30, $48, $84, $63, $f0, $9b, $af, $c5
    db $f0, $00, $00, $0b, $f4, $d1, $f1, $71, $d4, $42, $29, $69, $e0, $60, $21, $20
    db $21, $a8, $67, $12, $22, $80, $71, $e8, $29, $91, $58, $10, $8c, $14, $1a, $00
    db $88, $80, $46, $41, $e0, $51, $40, $00, $f0, $69, $32, $d8, $42, $f8, $d7, $32
    db $90, $80, $20, $c0, $91, $b5, $50, $51, $32, $b8, $f2, $70, $11, $f4, $31, $80
    db $c0, $a7, $91, $c0, $67, $73, $55, $55, $70, $b0, $58, $b8, $78, $24, $c3, $f1
    db $2b, $0c, $3c, $08, $34, $b2, $2c, $2d, $2d, $54, $2c, $0c, $af, $29, $f9, $10
    db $04, $f4, $14, $02, $e0, $80, $03, $04, $51, $be, $c0, $c3, $03, $60, $24, $d1
    db $40, $30, $91, $63, $20, $f0, $28, $60, $54, $00, $08, $15, $38, $6a, $d8, $52
    db $00, $48, $14, $10, $00, $4e, $1a, $b6, $14, $fe, $fd, $65, $3c, $5c, $0c, $48
    db $00, $c3, $a3, $a7, $23, $6b, $e9, $25, $b0, $f0, $ef, $b0, $22, $38, $0a, $1c
    db $15, $5b, $08, $5b, $58, $16, $2a, $1a, $22, $80, $8b, $26, $60, $09, $07, $02
    db $aa, $38, $3b, $2d, $2c, $7e, $87, $7f, $83, $87, $19, $13, $89, $19, $81, $44
    db $87, $94, $02, $42, $45, $12, $27, $0e, $82, $a0, $02, $27, $0d, $ff, $0a, $82
    db $94, $82, $7f, $87, $19, $09, $c2, $71, $60, $89, $38, $20, $28, $92, $16, $16
    db $03, $40, $23, $e2, $40, $90, $91, $a1, $c5, $b0, $30, $b0, $b0, $e5, $01, $08
    db $02, $44, $80, $85, $85, $c5, $a4, $45, $64, $22, $02, $18

    ld [de], a
    inc de
    adc c
    rlca
    ld [bc], a
    ld b, $48
    inc b
    nop
    inc bc

jr_004_44d8:
    ld c, b
    jr nc, jr_004_4553

    sub c
    ld bc, $51b4
    dec h
    db $10
    ld h, b
    ld d, h
    jr nc, jr_004_44fe

    dec sp
    ld [bc], a
    add c
    daa
    ld e, c
    ld l, c
    add hl, hl
    nop
    ld a, d
    ld c, d
    ld [hl], c
    ld c, c
    add hl, de
    db $10
    ret c

    dec b
    or $0a
    ldh a, [$91]
    ld bc, $848b
    inc bc
    add b

jr_004_44fe:
    or $18
    and e
    ld a, [c]
    and d
    ld b, d
    jr nz, jr_004_4566

    ld a, [bc]
    db $ec
    adc h
    ld bc, $3120
    ldh [rOBP1], a
    ld e, $7c
    ld l, e
    ldh [$84], a
    ld bc, $7140
    ld h, c
    ld b, c
    db $10
    ld c, b
    add h
    add c
    push de
    ld b, $97
    push hl
    ld [bc], a
    and [hl]
    jp $015d


    xor e
    jr nc, jr_004_44d8

    jp c, Jump_000_2fe0

    ld c, h
    jr nz, @-$7a

    dec bc
    db $76
    ld sp, $4c80
    ld e, d
    inc b
    add d
    add hl, bc
    ld sp, $1a80
    ld l, c
    xor c
    jp hl


    add hl, hl
    ld l, d
    xor d
    push bc
    add c

Jump_004_4542:
    add b
    add hl, de
    ld h, l
    ld [hl], l
    inc b

jr_004_4547:
    rlca
    ld a, h
    dec b
    sbc b
    ld [hl], c
    and b
    ld c, h

Jump_004_454e:
    cp [hl]
    xor [hl]
    ret nz

    ret nc

    ld [de], a

jr_004_4553:
    nop
    db $dd
    ld [de], a
    ldh a, [$5d]
    ld h, b
    add $41
    ld e, $59
    ld d, b
    ld l, e
    add b
    ld d, c
    ld [bc], a

jr_004_4562:
    ld h, [hl]
    inc e

jr_004_4564:
    inc c
    sub e

jr_004_4566:
    db $d3
    ld bc, $6040
    inc l
    xor b
    dec [hl]
    ret nz

    xor b
    add c
    ld b, b
    ld c, $38
    add $82
    or e
    add hl, sp
    ld l, c
    ld sp, $4010
    jp nz, Jump_004_5682

    ld a, b
    ret nz

    ld [de], a
    dec bc
    ld l, b
    ld hl, $6527

jr_004_4586:
    xor e
    dec hl
    ld hl, $6c80
    and b
    dec d
    ld b, $1a
    ret z

    ld [bc], a
    sub [hl]
    jr jr_004_4564

    rrca
    ld a, l
    inc bc

jr_004_4597:
    ret nz

    cp b
    ld hl, sp-$80
    ld c, h
    jr c, jr_004_459e

jr_004_459e:
    ret z

    or h
    ret nz

    ld [de], a
    rrca
    jr jr_004_4562

    cp b
    ld [$ba00], sp
    or b
    ld h, b
    db $d3
    nop
    ld c, e
    sub h
    add hl, bc
    nop
    cpl
    ld h, c
    inc bc
    or l
    call nz, Call_004_6867
    ld de, $5050
    rst $00
    ld b, e
    add h
    jr c, jr_004_45dc

Call_004_45c0:
    nop
    ld d, h

jr_004_45c2:
    jp nz, Jump_004_5a44

    jr c, jr_004_4547

    ld l, a
    nop
    reti


    add b
    add hl, hl
    inc h
    adc c
    sbc l
    ld bc, $8421
    inc e
    ld [hl], b
    ld [hl], l
    nop
    ld e, $27
    jr nc, jr_004_45de

    inc bc
    ld l, h

jr_004_45dc:
    jr jr_004_4586

jr_004_45de:
    ld a, [bc]
    dec l
    inc l
    inc b
    ld b, b
    xor d
    ld a, b
    nop
    ld hl, $1103
    ld h, d
    dec b
    add [hl]
    ld b, b
    jr nc, @+$10

    ld c, b
    db $e3
    jr nz, jr_004_4597

    ld [bc], a
    xor b
    ld [$2b1b], sp
    nop
    jr z, jr_004_45c2

    ld bc, $8359
    jp z, $3b06

    ld e, c
    ld e, b
    ld [$e004], sp
    ld e, h
    ld [bc], a
    ret nz

    ld h, h
    ld a, [hl+]
    add c
    ldh [$66], a
    sbc h
    ld [$4100], sp
    and b
    ld l, b
    inc c
    ld [hl], b
    add h

jr_004_4617:
    rlca
    cp h
    ld sp, $4586
    push bc
    ld b, d
    sbc b
    cp b
    cp b
    jr jr_004_4624

    and b

jr_004_4624:
    add l
    jr c, jr_004_4628

    and b

jr_004_4628:
    ld l, b
    inc c
    inc [hl]
    ld d, [hl]
    add b
    add hl, de
    rlca
    ld a, [bc]
    db $e3
    adc b
    add a
    nop
    ret nz

    jr z, jr_004_4617

    pop de
    adc e
    adc e
    ld b, b
    jr z, @+$1c

    dec bc
    add sp, -$5e

Call_004_4640:
    ld [hl], b
    ld [hl], d
    ld sp, $47b2
    ld bc, $6d48
    ld hl, $0020
    add [hl]
    add e
    and d
    or c
    add b
    ld d, c
    ld h, b
    ccf
    ld h, h
    ld l, d
    jp nc, Jump_004_5dbd

    adc b
    ld e, l
    ld [hl], b
    ld [hl], h
    ld c, h
    inc b
    or h
    pop hl
    ld [bc], a
    ld d, a
    adc h
    ld l, c
    ld de, $9100
    push hl
    sub $0a
    add b
    jp hl


    ld a, h
    ld a, l
    dec b
    ld bc, $e86d
    add sp, $28
    jr nz, @+$72

    push bc
    ld b, c
    jp nz, $02b8

    sub e
    and d
    ld b, e
    ld [$0b54], sp
    and b
    add [hl]
    cp [hl]
    ld bc, $af02
    ld a, [bc]
    inc c
    adc e
    ld b, c
    db $10
    inc b
    inc e
    push bc
    add c
    ld l, d
    rla
    dec e
    inc de
    inc bc
    ld [bc], a
    ld d, a
    ld l, h

jr_004_4698:
    ld d, c
    and c
    ld e, $00
    ld [bc], a
    ld [hl], d
    ld sp, $6ff1
    ld c, h
    ld b, c
    ld a, b
    add hl, bc
    ld d, l
    inc l
    ld h, d
    ld b, $01
    ld c, [hl]
    jr c, jr_004_46ed

    ld [$9a99], sp
    sbc b

jr_004_46b1:
    sbc d
    ld d, $24
    jr z, jr_004_46c4

    pop bc
    ld c, e
    ld a, b
    jr z, jr_004_46e7

    add b
    inc de
    ld b, $60
    ld [hl], d
    ld a, c
    dec d
    nop
    ld b, c

jr_004_46c4:
    and b
    ld d, c
    cp h
    ldh [$8a], a
    ret nc

    ld d, $3b
    ld l, $0b
    or b
    add [hl]
    nop
    jr nc, jr_004_46df

    ret z

    push af
    add hl, de
    jr jr_004_4748

    push bc
    ld [bc], a
    ld [hl], b
    inc h
    dec de
    ld e, $0b

jr_004_46df:
    dec bc
    cp h
    dec bc
    ld c, e
    cp c
    ret nc

    ld d, $d2

jr_004_46e7:
    jp Jump_000_0e16


    ld h, c
    inc l
    inc l

jr_004_46ed:
    ldh [$8a], a
    dec e
    add c
    ld b, c
    or l
    jp c, $0114

    and b
    ld d, d
    and c
    jr nc, jr_004_4754

    ld e, e
    ld b, c
    add b
    ld de, $c2c7
    jp nz, Jump_004_5040

    dec l
    ld b, l
    ld b, a

Jump_004_4707:
    nop
    ld e, b
    ld d, h
    jr z, jr_004_4698

    ld d, $57
    jr nz, @+$42

    add l
    or c
    add hl, hl
    ld a, [hl-]
    inc bc
    ld [hl+], a
    inc a
    adc h
    jr jr_004_46b1

    rst $10
    add l
    sub l
    ld d, $99
    sub [hl]
    ld b, h
    add b
    ld d, $1e
    ld h, $03
    ld e, l
    or [hl]
    or b
    ldh [$b8], a
    ret nz

    jr c, jr_004_472e

jr_004_472e:
    ld l, $05
    ld b, [hl]
    dec hl
    and b
    add l
    rlca
    ld c, $31
    sub h
    reti


    ld h, d
    ld h, h
    dec b
    and $a2
    and e
    ld [hl+], a
    ld de, $8928
    dec b
    ret z

    ld e, $03
    ld [bc], a

jr_004_4748:
    add a
    cp b
    add c
    ld sp, $c1e2
    ld d, d
    ld [$c3ac], sp
    rst $10

jr_004_4753:
    inc d

jr_004_4754:
    sbc l
    pop bc
    nop
    sbc c
    xor a
    xor a

jr_004_475a:
    nop
    ret nc

    inc c
    inc bc
    adc a
    ld a, c
    cp h
    ld e, d
    inc c
    add d
    adc l
    ld e, d
    ld [hl], h
    ld [hl], b
    ld a, [hl-]
    inc a
    ld a, [bc]
    ld [bc], a
    ld b, [hl]
    inc hl
    ld bc, $3340
    inc c
    ld e, b
    inc b
    or e
    jr nz, jr_004_4777

jr_004_4777:
    ld a, [de]
    jp nz, $4680

    inc bc
    and h
    nop
    sub $4b
    ld h, b
    ret nc

    inc c
    ld [hl], a
    ld e, h
    jr nc, @+$2e

    sbc h
    cpl
    dec hl
    dec l
    dec l
    ld [de], a
    ld bc, $8870
    adc c
    add e
    add e
    ld b, e
    inc sp
    inc c
    ld h, b
    add a
    ld d, $81
    and b
    scf
    inc c
    ld h, b
    scf
    xor d
    jr c, jr_004_475a

    ld c, c
    jr nc, jr_004_4753

    ld c, e
    add hl, bc
    ld [$f917], sp
    ld a, [bc]
    dec bc
    ld b, $ec
    jr c, @+$05

    add d
    inc sp
    ld de, $2400
    jp nc, Jump_000_0809

    pop bc
    ret nz

    ld [hl-], a
    inc l
    ldh [$84], a
    add c
    ld a, [$383a]
    ld l, $26
    ld [hl], $3c
    inc c
    ld [bc], a
    ld d, l
    ld [$001d], sp
    ld d, h
    ld a, [hl+]
    jr nz, jr_004_4754

    inc hl
    dec e
    ld [bc], a
    ldh [$99], a
    ld e, l
    stop

jr_004_47d8:
    ld b, $61
    ldh [$bc], a
    nop
    ld e, [hl]
    adc b
    ld d, e
    pop hl
    ld hl, $084b
    jr nc, jr_004_47d8

jr_004_47e6:
    ld a, b
    ld e, l
    ret nc

    ld e, l
    ld e, d
    cp d
    ld e, l
    cp b
    sbc l
    ld d, l
    nop
    ld d, l
    ld h, c
    ld b, a
    add l
    nop
    ret z

    ld l, b
    add c
    ld d, a
    db $10
    ld h, b
    or h
    jr nz, jr_004_486a

    dec sp

Jump_004_4800:
    nop
    add d
    and l
    nop
    add b
    ld d, c
    nop
    ld a, [hl-]
    db $dd
    db $dd
    dec bc
    adc h
    rla
    sub a
    rst $10
    ld b, e
    add b
    ld de, $2e6c
    ld l, [hl]
    ld l, [hl]
    dec l
    ld l, l
    db $ed
    jp nz, $92d2

    db $ed
    db $ed
    inc l
    ld l, a
    rst $28
    inc bc
    ld l, b
    jp hl


    dec h
    jr nz, jr_004_4827

jr_004_4827:
    rla
    jr nz, jr_004_487c

    ld [bc], a
    ret nz

    ld b, [hl]
    dec bc
    or h
    cp b
    ld c, e
    ld c, e
    cp l
    add hl, hl
    ld [hl-], a
    ld a, [hl-]
    ld d, $0a
    ldh [rP1], a
    ld e, h
    ld h, h
    inc e
    inc h
    nop
    ld b, h
    jr nz, jr_004_47e6

    sub a
    nop
    jr nc, @+$5c

    ld l, [hl]

Jump_004_4847:
    ld l, l
    adc d
    ld c, $01
    ld d, b
    sbc d
    inc hl
    daa
    ld bc, $451b
    rlca
    dec l
    db $10
    add [hl]
    ld c, b
    adc c
    pop de
    sbc h
    dec h
    add hl, hl
    rlca
    ld [bc], a
    ld l, d
    add e
    db $d3
    ld [bc], a
    dec hl
    ld h, c
    ld h, d
    ld c, [hl]
    ld c, $80
    ldh [$a0], a

jr_004_486a:
    ld e, b
    ld [bc], a
    dec [hl]
    rst $18
    db $e3
    ld c, a
    ld c, [hl]
    rst $08
    rst $18
    ld e, a
    jp z, Jump_004_4847

    ld c, h
    ld c, h
    call z, $8006

jr_004_487c:
    ld d, a
    xor e
    xor e
    nop
    add b
    add hl, hl
    ret nc

    sub $67
    add sp, -$50
    dec b
    ld bc, $0910
    jp $9857


    ld hl, sp-$09
    rst $10
    ld b, b
    ldh [$b5], a
    xor d
    ld a, [hl+]
    nop
    jp c, $d91a

    ret c

    add sp, -$40
    ld [hl], b
    cp c
    add sp, -$20
    sub b
    cp b
    add sp, -$40
    or b
    jr @-$0d

    add b
    adc b
    nop
    sub $48
    ld b, a
    add l
    rlca
    dec b
    rst $00
    jp nz, $8605

    inc c
    call z, $c482
    add d
    inc bc
    cp b
    jr z, @-$38

    ld b, l
    db $10
    ld h, b
    inc [hl]
    ret c

    ret z

    dec b
    ld [hl], $76
    and l
    ld b, l
    rst $00
    nop
    ld b, h
    inc b
    sub e
    ld [hl+], a
    db $10
    jr nz, jr_004_48ec

    ret nz

    inc [hl]
    ld b, b
    ld h, d
    ld h, h
    ld e, d
    ld e, b
    inc l
    ld a, [bc]
    ld [bc], a
    ld b, l
    sbc e
    sbc l
    sbc c
    sbc d
    adc [hl]
    adc [hl]
    add h
    add l
    add [hl]
    add a
    adc [hl]
    adc [hl]
    adc a
    sub b
    sub [hl]

jr_004_48ec:
    ld d, $16
    ld de, $3e01
    jp nz, $ccc4

    call nc, $f4e4
    inc [hl]
    inc b
    ret z

jr_004_48fa:
    nop
    and e
    ld h, c
    ld e, a

jr_004_48fe:
    ld e, a
    pop hl
    bit 0, a
    ld c, b
    adc e
    ld c, h
    call $dfdf
    rst $18
    ld h, c
    dec bc
    dec bc
    adc e
    adc b
    nop
    rlca
    ld h, b

jr_004_4911:
    and b
    ldh [$e0], a
    add [hl]
    rst $00
    dec b
    ld b, $02
    jr @+$2e

    ld a, h
    ld a, l
    rlca
    sub d
    ld b, $eb
    inc bc
    and b
    ld a, [hl+]
    and h
    xor b
    stop
    sub l
    ld h, h
    ld h, b
    ld d, [hl]
    ld e, d
    ld d, h
    ld a, [bc]
    ld bc, $8151
    sbc c
    ld [de], a
    ld h, h
    dec d
    sub d
    ld a, [hl+]
    xor h
    ld d, h
    jr jr_004_49ab

    dec b
    ld h, $45
    add l
    jr nz, jr_004_48fe

Jump_004_4942:
    ld d, [hl]
    ret nc

    ld l, b
    call nz, Call_004_6163
    ld d, b
    ld a, h
    adc b
    inc bc
    ld c, c
    pop af
    nop
    db $d3
    jr nz, jr_004_48fa

    nop
    ld d, e
    add c
    ret c

    ld [bc], a
    ld b, d
    cp c
    inc b
    inc b
    sub c
    ld [bc], a
    ld [bc], a
    ld b, c
    ld l, d
    add hl, de
    call nc, $120a
    dec c
    add h
    pop bc
    ld h, c
    sbc b
    and d
    ld [hl+], a
    ld [$2a36], sp
    and b
    ld d, $c8
    ld c, d

jr_004_4972:
    dec h
    jr nc, jr_004_4911

    and l
    inc de
    db $10
    ld d, b
    dec hl
    jr c, jr_004_4972

    or b
    ld [$3055], sp
    ld [bc], a
    inc l
    ld [$5680], sp
    inc l
    ld d, $02
    ld bc, $c7b2
    sub c
    ld e, b
    ret c

    db $10
    rrca
    ld l, h
    dec c
    cp b
    adc d
    reti


    pop de
    add hl, de
    inc c
    ld a, [bc]
    ld h, c
    ld h, c
    jr nz, jr_004_4a19

    add hl, bc
    inc c
    dec hl
    dec b
    ld l, [hl]
    sub d
    ld l, c
    ld de, $1418
    ld [c], a
    dec b
    add [hl]
    ld b, b

jr_004_49ab:
    ld [$476a], sp
    ld b, l
    db $10
    ld [$e2f5], sp
    sub d
    ld [c], a
    sub d
    and d
    ld h, d
    nop

jr_004_49b9:
    ld h, d
    adc d
    ld [hl], c
    ld e, c
    sub b
    jr nz, jr_004_49cc

    dec h
    ld h, c
    add e
    dec sp
    ld c, h
    sub c
    ld l, c
    ld [hl], c
    ld hl, $9908
    dec b

jr_004_49cc:
    sbc d
    jp nz, $0146

    ld bc, $20a1
    inc l
    pop de
    ld de, $4a04
    ldh [$b4], a
    nop
    ld c, l
    ld bc, $0acf
    adc [hl]
    cp c
    inc b
    inc c
    adc l
    ld [bc], a
    ld c, h
    pop hl
    sub l
    inc e
    ld [hl], c
    db $10
    ld [$a11e], sp

jr_004_49ee:
    ld c, e
    add b
    jr c, jr_004_4a04

    push af
    dec c
    cp [hl]
    ld a, [de]
    jr nz, jr_004_49ee

    ld [hl], c
    or e
    ld [hl], c
    ld h, e
    ld d, c
    db $10
    adc [hl]
    adc e
    dec de
    ld bc, $51a0

jr_004_4a04:
    adc b
    rlca
    pop de
    ld b, b
    cp b
    rrca
    inc h
    db $10
    xor h
    rla
    jr z, jr_004_49b9

    sub b
    ld e, h
    adc d
    adc [hl]
    push bc
    nop
    add sp, $2a
    and h

jr_004_4a19:
    and e
    and d
    inc bc
    add h
    pop hl
    jp z, $85e2

    dec h
    ld b, [hl]
    push bc
    ld [bc], a
    dec bc
    ld [c], a
    inc bc
    ld [hl+], a
    ld b, d
    ld c, a
    add l
    and l
    ldh a, [rNR10]
    inc b
    ret nz

jr_004_4a31:
    ld d, e
    or c
    ret c

    ldh a, [rNR41]
    nop
    dec hl
    dec d
    sbc d
    pop bc
    inc c
    ld sp, hl
    ld [de], a

jr_004_4a3e:
    jr nz, @+$12

    ld b, $33
    cp c
    or c
    or b
    jr nz, jr_004_4a47

jr_004_4a47:
    xor e
    ld hl, $c78e
    dec b
    ld [$a001], sp
    call z, Call_000_202a
    ld c, b
    db $e4
    ld de, $2c18
    jp nz, $7202

    ld e, b
    db $10
    ld [bc], a
    add b
    cpl
    ld a, [de]
    ld e, $41

jr_004_4a62:
    jr nc, jr_004_4a3e

jr_004_4a64:
    ld b, e
    add b
    add a
    jp nz, $4141

    ldh [$2f], a
    add b
    ld e, b
    ld bc, $82a5
    ld [de], a
    cp b
    adc b
    add d
    ld b, e
    db $10
    add h
    inc [hl]
    adc b
    adc c
    and d
    ld b, d
    nop
    xor b
    ld d, h
    sub b
    add hl, hl
    ld [hl], c
    push de
    add b
    jr jr_004_4aab

jr_004_4a87:
    rla
    ld [$2aea], sp
    ld b, d
    jr nc, @-$5e

    or $10
    jr nc, jr_004_4a64

    ld sp, $51b1
    add c
    ld de, $2110
    or c
    ret nz

    jr nz, jr_004_4a31

    xor h
    and l
    xor l
    dec b
    jp nz, Jump_000_1190

    ld d, [hl]
    jr nz, jr_004_4a87

    ld c, b
    ld b, c
    add h
    ld l, b

jr_004_4aab:
    nop
    ld l, b
    rla
    ld l, b
    inc e
    inc e
    inc e
    jr jr_004_4a62

    ld a, [bc]
    ld b, e
    ld b, l
    rla
    inc sp
    inc c
    ld d, [hl]
    db $10
    inc [hl]
    ld e, $07
    jr nz, @-$54

    add h
    ld h, a
    add e
    sub h
    ld b, $b5
    dec e
    inc b
    add b
    or h
    ld d, $16
    ld [bc], a
    ld [hl+], a
    sbc b
    sbc d
    sbc b
    sbc d
    ld l, h
    ld d, $14
    add b
    ld a, a
    ld b, [hl]
    add c
    ret nz

    inc hl
    inc a
    ld a, [hl-]
    ld b, b
    xor b
    ld d, c
    ld c, b
    jr nc, jr_004_4ae4

jr_004_4ae4:
    ld h, e
    dec h
    call nc, $0608
    dec h
    ld h, b
    sub c
    ld b, h
    ld b, b
    db $10
    ld l, e
    db $10
    ld d, e
    ldh [$a9], a
    add b
    ld c, d
    inc bc
    sbc c
    adc b
    ld [bc], a
    pop bc
    ld b, h
    add c
    or h
    xor d
    sub b
    ld b, h
    ld b, $00
    ld h, c
    inc de
    db $10
    add d
    ld a, [bc]
    db $10
    dec b
    and b
    ld [bc], a
    ld a, b
    ld d, $28
    jr c, jr_004_4b27

    ld l, $02
    ld d, $24
    inc d
    ld b, c
    ld c, d
    inc bc
    sub d
    or h

jr_004_4b1b:
    cp d
    cp b
    ld d, $16
    ld a, [bc]
    nop
    ld e, c
    add hl, bc
    ld b, $02
    add b
    inc hl

jr_004_4b27:
    add l
    inc b
    ld bc, $0c10
    ld d, b

jr_004_4b2d:
    ld a, [bc]
    db $f4
    dec [hl]
    ld d, b
    db $10
    inc c
    ld c, $88
    ld [$f1c1], sp
    db $10
    db $10

jr_004_4b3a:
    ld sp, $1408
    adc c
    nop
    add b
    inc b
    inc e

jr_004_4b42:
    ld [$6080], sp
    ld hl, $0800
    dec d
    ldh [rBCPS], a
    ret


    and b
    ld a, [bc]
    adc c
    nop
    ld l, h
    dec d
    cp b
    ld [$8880], a
    xor d
    jp z, Jump_000_28a7

    ld l, b
    inc sp
    jr nz, jr_004_4b5f

    adc b

jr_004_4b5f:
    and [hl]
    sub h
    inc d
    inc [hl]
    jr nc, jr_004_4b2d

    ld a, [bc]
    jr z, @-$7e

    ld bc, $0380
    ret nz

    and d
    jp nz, $0149

    ld bc, $a440
    sbc [hl]
    nop
    ldh a, [$d3]
    jr nz, jr_004_4b1b

    add c
    ld c, d
    ld bc, $9027
    ld d, [hl]
    ret nz

    dec hl
    and h
    xor d
    inc hl
    ld de, $2a85
    ld [bc], a
    add d
    nop
    inc h
    dec b
    jr nz, jr_004_4b5f

    add b
    add hl, bc
    and b
    ld [de], a
    nop
    ld c, $91
    ld b, d
    nop
    ld [de], a
    ld b, c

jr_004_4b99:
    add b
    xor c
    ld b, b
    ld [de], a
    ld d, l
    nop
    ld c, b
    add hl, hl
    jr nc, jr_004_4b3a

    ld b, $c3
    dec d
    ld bc, $9260
    ld b, c
    jr nc, jr_004_4b42

    add d
    ld a, d
    and [hl]
    sub d
    sub [hl]
    inc c
    ld c, $14
    or b
    jr nz, jr_004_4beb

    and [hl]
    ld a, h
    inc e
    ld b, b
    ld b, h
    rlca
    ld a, [bc]
    ld bc, $0a07
    rlca
    ld a, [bc]
    rlca
    nop
    and c
    or l
    ld [$45a8], sp
    xor d
    ld b, d
    xor d
    ld [$0049], a
    dec de
    ld [c], a
    ld d, h
    rst $08
    ld d, h
    adc a
    add l
    ld b, l
    and e
    ld c, a
    ld b, b

jr_004_4bdb:
    and e
    ld c, a
    ld c, a
    xor l
    ld c, a
    rst $08
    inc bc
    ld c, b
    ld c, $14
    dec h
    and h
    ld c, d
    sub b
    ld b, l
    ld a, [de]

jr_004_4beb:
    ld [$73c6], sp
    dec c
    inc b
    ld d, d
    dec b
    ld b, d
    ld a, [hl-]
    db $ec
    inc d
    db $10
    jr z, jr_004_4c1b

    ld a, [hl-]
    ld e, h
    push af
    ld hl, sp+$29

jr_004_4bfe:
    nop
    inc c
    and l
    ld b, [hl]
    ld b, c
    sub b
    ld d, c
    add b
    add l
    jr nz, jr_004_4b99

    jr z, jr_004_4bdb

    ld d, d
    nop
    xor l
    add l
    ld b, l

jr_004_4c10:
    xor l
    rrca
    ld l, l
    nop
    db $e4
    sub h
    ld b, d
    add b
    ld l, c
    jr nz, jr_004_4c2c

jr_004_4c1b:
    ld l, l
    jr nz, jr_004_4bfe

    adc b
    inc [hl]
    jr nz, @-$16

    db $76
    jr z, @+$6b

    xor d
    rlca
    ld [hl], d
    nop
    inc h
    ld d, e
    or h

jr_004_4c2c:
    ld d, e
    dec a
    ld bc, $e205
    and d
    jp c, $809e

    jp c, $da9e

    ld e, $0b
    ld c, b
    ld d, d
    add l
    jr nz, jr_004_4c10

    ld h, a
    ret nz

    jr jr_004_4c6f

    inc l
    jr nz, jr_004_4c4d

    add b
    ld c, d
    add hl, de
    adc d
    ld [hl+], a
    ld h, a
    dec h

jr_004_4c4d:
    sbc h
    ld a, [hl-]
    ld a, h
    dec d
    db $10

jr_004_4c52:
    ld hl, $9c1d
    ld c, d
    xor b
    ld d, h
    cp b
    ld l, d
    ld h, b
    ld e, a
    ld l, d
    add b
    ret z

    add hl, hl
    sub b
    inc [hl]
    ld [hl], b

Jump_004_4c63:
    ld a, [hl-]
    inc [hl]
    ld bc, $828e
    and e
    and a
    pop bc
    ld b, h
    and a
    adc d
    adc c

jr_004_4c6f:
    call nz, $a504
    and h
    inc bc
    ld c, b
    ld bc, $e101
    and d
    ld b, c
    ld de, $f8e0
    jr c, jr_004_4c7f

jr_004_4c7f:
    ld a, [de]
    ld d, l
    pop bc
    call nz, $e244
    call nz, $54c4
    add h
    ld sp, $7a3c
    ld a, [hl-]
    jp c, $0212

    and l
    ld c, $31
    call Call_000_070e
    rrca
    nop
    sbc c
    jr nc, jr_004_4c9e

    ld b, d
    ld c, c
    dec b

jr_004_4c9e:
    adc d
    ld b, $4e
    db $fd
    ld b, $03
    rlca
    rst $38
    ld h, d
    ld a, [de]
    add b
    inc h
    and b
    ld d, d
    jr nz, jr_004_4c52

    add [hl]
    ld c, d
    add a
    sbc a
    ld l, $81
    add l
    rlca
    nop
    ld d, [hl]
    rlca
    sbc d
    ld b, $41
    ld c, c
    ld b, $06
    sub l
    ld [bc], a
    ld b, a
    ld [c], a
    and h
    add e
    ld de, $a890
    add b
    sub c
    pop hl
    or b
    add l
    dec b
    or b
    add l
    ldh a, [$af]
    or b
    and $ed
    ld b, d
    jr z, @+$04

jr_004_4cd8:
    jp Jump_000_006d


    ld c, b
    adc b
    dec h
    dec b
    ret z

    ld b, l
    sub d
    or a
    or [hl]
    or a
    sub a
    jp $c3c0


    ld d, $c1
    sbc d
    or [hl]
    or a
    or [hl]
    sub c
    sub d
    or [hl]
    or a
    sub c
    adc c
    call nz, $89c4
    rla
    ld bc, $c68a
    ld h, e
    adc l
    and d
    ret nc

    ld d, a
    cp d
    add d
    adc c
    ld d, d
    jr nz, jr_004_4d67

jr_004_4d07:
    ld h, e
    ld h, l
    dec l
    inc l
    inc l
    inc c
    ld [bc], a
    ld [$04c7], sp
    nop
    ld hl, $5e02
    ld [$56c4], sp
    dec b
    ret nz

    ld b, $c5
    ld h, d
    rlca
    or b
    ret nz

    ld sp, $2f58
    ld d, b
    ld a, [de]
    adc [hl]
    jr z, jr_004_4cd8

    ret nz

    ld [hl], c
    inc l
    add c
    ld bc, $01ab
    ld c, e
    ld a, [hl-]
    add c
    ld b, b
    ld e, c
    add c
    ld de, $1500
    dec b
    inc b
    add d
    ret nz

    ld b, $42
    and e
    ld [hl], $4c
    add hl, bc
    inc c
    dec c
    pop hl
    ld hl, $00b0
    ld h, e
    ld a, [hl+]
    ld bc, $2001
    inc c
    ld l, h
    ld d, l
    cp b
    db $10
    rla
    inc h
    inc b
    ld b, b
    ld l, a
    ld e, b
    jr z, @+$18

    scf
    add b
    dec d
    and [hl]
    ld a, [hl+]
    ld h, h
    add a
    sbc e
    and b
    jr nz, @+$57

    ld c, h
    ld b, b

jr_004_4d67:
    jr jr_004_4dd4

    jr nc, jr_004_4d07

    ld c, e
    adc c
    adc $20
    add sp, $28
    or b
    inc h
    add $58
    ld e, b
    inc c
    add h
    db $d3
    ret nc

    dec h
    sub b
    jr c, @+$77

    ret c

    ld [$e807], sp
    dec c
    jr @-$3c

    inc d
    dec d
    add c
    ld b, b
    ld d, d
    jr nz, jr_004_4db7

    db $f4
    ld [$1704], sp
    ld [c], a
    adc [hl]
    adc e
    nop
    ld h, b
    ld a, [bc]
    inc bc
    ld e, h
    inc b
    ret nz

    ld c, e
    jr @+$03

    ld h, $c9
    inc e
    ld a, b
    rst $00
    ld [de], a
    jr jr_004_4e0b

    ei
    inc b
    add c
    sbc h
    ldh a, [rNR44]
    ld d, b
    inc a
    cpl
    ld e, $26
    inc bc
    ld h, b
    and l
    dec c
    rlca
    add a
    pop bc

jr_004_4db7:
    ld b, b
    inc de
    ld d, $34
    ld a, [hl-]
    add hl, bc
    db $10
    pop bc
    and b
    ld d, e
    cp h
    sbc b
    ld de, $1c08
    pop hl
    jr nz, jr_004_4dd1

    inc l
    and [hl]
    ld [de], a
    nop
    add d
    ld bc, $18c0

jr_004_4dd1:
    ld [$006c], sp

jr_004_4dd4:
    dec d
    ld b, $86
    dec bc
    call nz, $73b5
    ld [hl+], a
    nop
    ld l, [hl]
    jp Jump_000_0a8e


    sub b
    ld bc, $1411
    sub $b3
    add d
    db $10
    inc b
    db $e4

jr_004_4deb:
    pop de
    ld [hl], h
    ld d, h
    ld a, b
    stop
    cp a
    ld b, $8c
    dec c
    ld h, h
    call nz, $96c0
    jr @-$06

    ld a, [bc]
    dec hl
    ld d, e
    dec b
    ldh [$b8], a
    and h
    call c, $8c58
    ld a, b
    jr nz, @-$78

    and d
    ld c, $18

jr_004_4e0b:
    ld b, l
    ld a, [$5acb]
    jp c, Jump_000_081a

    dec c
    ld h, c
    ldh [rNR24], a
    inc [hl]
    add h
    dec e
    scf
    add d
    pop hl
    add hl, bc
    ld [$4d04], sp
    sbc c
    call c, $8208
    ld h, b
    ret nz

    inc d
    and d
    inc b
    adc b
    sub [hl]
    ld c, $02
    ld d, e
    db $d3
    add d
    adc c
    ld b, l
    ld b, b
    call nz, $f881
    jr z, jr_004_4ea8

    inc h
    jp nc, Jump_004_454e

    dec d
    stop
    ld d, b
    or c
    adc d
    db $76
    adc d
    sub [hl]
    db $10
    ld [$9936], sp
    ld a, [hl+]
    ld h, b
    ld e, e
    ld h, b
    ld a, [hl-]
    adc e
    rla
    sub a
    add c
    jr nc, jr_004_4deb

    ld c, h
    dec bc
    ld d, $84
    add [hl]
    inc bc
    adc l
    rlca
    ld [c], a
    nop
    ld c, e
    xor e
    adc e
    ld l, e
    jr nz, @-$72

    inc [hl]
    ret z

    ld l, [hl]
    ret nc

    db $10
    ld e, [hl]
    call z, $8408
    daa
    jr nz, jr_004_4e80

    jr nc, jr_004_4ee7

    ld [hl], d
    ld bc, $0032
    ld [bc], a
    add a
    ret nz

    ret nz

    inc d
    ld c, [hl]
    ld [hl], d
    jp $9815


jr_004_4e80:
    inc d
    sub l
    nop
    sub a
    add l
    dec b
    add h
    ldh a, [$57]
    nop
    ld d, c
    ld a, l
    inc c
    push af
    pop af
    pop af
    jp hl


    add hl, sp
    ld [$a39f], sp
    ld l, e
    nop
    ld e, b
    db $10
    rla
    inc bc
    pop hl
    add b
    xor d
    add b
    add b
    ld d, b
    add hl, hl
    xor $04
    add d
    cp a
    ld c, d
    ld [hl], h

jr_004_4ea8:
    inc l
    ld b, $40
    ld d, d
    jr c, @+$2a

    ld [bc], a
    ld [hl+], a
    ld c, b
    nop
    or [hl]
    ret z

    xor $00
    ld e, b
    ld [c], a
    add hl, bc
    ld [$3000], sp
    pop hl
    and b

jr_004_4ebe:
    ld [$b786], sp
    ld e, $02
    ld [bc], a
    ld e, c
    ld de, $52a5
    ld e, b
    ld h, d
    ld e, b
    inc l
    ld [bc], a
    ld e, [hl]
    ld c, [hl]
    db $10
    pop bc
    ld b, [hl]
    ld b, e
    sbc e
    ld [bc], a
    jr nz, jr_004_4f20

    ld c, h
    ld c, h
    inc d
    ld [$e3e1], sp
    and b
    ld c, d
    inc a
    ld a, h
    db $fd
    inc e
    nop
    xor b
    ld h, c
    add b

jr_004_4ee7:
    and h
    ld b, l
    ld h, e
    ld bc, $1c9b
    ld a, $68
    ld b, $c2
    ld h, d
    ld [hl], d
    ld h, e
    ld h, c
    ld de, $6380
    db $10
    cp $1a
    sub b
    ld [hl], a
    jr c, jr_004_4f6b

    ld [bc], a
    ld b, l
    ld d, e
    ret nz

    ld l, [hl]
    ld sp, $1617
    add h
    ld b, e
    adc b
    ld b, a
    ld bc, $2a38
    ldh [rHDMA5], a
    ld b, c
    ld h, b
    jr nz, @-$53

    and c
    ld d, h
    jr nz, @-$57

    adc d
    sbc c
    rrca
    add [hl]
    xor e
    ld de, $0594

jr_004_4f20:
    inc b
    nop
    push de
    ld h, [hl]
    jr nz, @+$4a

    ld [de], a
    add c
    ld a, a
    dec b
    inc b
    ret nz

    jr jr_004_4ebe

    rla
    add hl, de
    ld d, e
    rra
    ld e, l
    dec l
    and [hl]
    adc [hl]
    ld c, $c0
    ld l, d
    adc c
    sub e
    ld [hl+], a
    ld [bc], a
    rlca
    ld h, b
    rla
    jr nz, jr_004_4f4e

    ld d, a
    ld e, $0b
    ld b, $c1
    xor a
    call nz, Call_000_084d
    ld b, $22
    add e

jr_004_4f4e:
    jr nz, jr_004_4f58

    ld h, h
    dec d
    ld c, b
    ld l, e
    ld d, b
    jr nz, jr_004_4f74

    inc l

jr_004_4f58:
    inc c
    nop
    sub d
    db $10
    add hl, hl
    jr nz, @+$64

    jr nz, jr_004_4f8d

    dec d
    sbc b
    ld l, $60
    inc b
    jr nz, jr_004_4f70

    inc l
    dec l
    dec d

jr_004_4f6b:
    add b
    xor c
    ld c, $7d
    dec d

jr_004_4f70:
    inc b
    adc b
    sbc e
    inc a

jr_004_4f74:
    ld d, $04
    add c
    ld e, a
    add c
    cp a
    add d
    inc bc
    ret nz

    sub a
    ld a, b
    nop
    db $10
    add e
    dec l
    inc b
    add d
    ld b, b
    ld hl, sp-$08
    ld l, c
    and c
    ld b, h
    nop
    or h

jr_004_4f8d:
    ld a, [bc]
    ld h, b
    ld d, h
    or b
    or b
    db $10
    ld b, b
    ld [$4392], sp
    db $10
    ld h, b
    jp hl


    ld hl, $0040
    call nc, $f075
    res 4, a
    ret z

    ldh [rP1], a
    and c
    nop
    xor b
    inc [hl]
    adc b
    add hl, hl
    add b
    ld e, [hl]
    ret nz

    dec sp
    rra
    ld [bc], a
    jp c, $b001

    ld d, $60
    adc a
    ld b, l
    add b
    ld b, l
    add b
    ld bc, $28e8
    ret nc

    ld d, h
    ldh [rBCPD], a
    db $f4
    pop af
    add hl, bc
    and b
    or l
    sbc b
    adc d
    ld b, d
    nop
    ld b, c
    nop
    xor c
    add b
    ld l, [hl]
    ld d, c
    ld bc, $a620
    pop bc
    ld c, l
    ld a, [bc]
    ld d, l
    ld [bc], a
    ret nz

    cpl
    push de
    nop
    ldh a, [$57]
    ldh [$4e], a
    inc e
    or [hl]
    inc d
    nop
    sub b
    sub c
    ld c, [hl]
    ld c, $17
    inc de
    ld [bc], a
    cp c
    or b
    sub d
    ld [de], a
    db $f4
    pop de
    ld d, l
    add hl, hl
    add hl, hl
    adc b
    jr nz, jr_004_4ff9

    sub b

jr_004_4ff9:
    ld h, h
    ld [hl], b
    db $10
    ld [hl], b
    add b
    ld d, b
    nop
    adc [hl]
    add l
    dec b
    add l
    inc b
    add e
    add e
    dec b
    adc c
    add l
    nop
    ld [hl+], a
    add l
    add h
    add [hl]
    ld h, b
    db $d3
    pop hl
    jr nc, @-$5f

Call_004_5014:
    sbc [hl]
    xor c
    ld bc, $5310
    jp nz, Jump_004_52d2

    nop
    ld hl, $a920
    and b
    dec d
    ld c, $9e
    pop de
    nop
    ld b, c
    ret nc

    sub c
    ld c, a
    nop
    cp b
    ld l, d
    dec [hl]
    nop
    ldh a, [$36]
    add sp, $2d
    and b
    inc l
    dec l
    add hl, bc
    inc b
    and h
    sub h
    sub d
    sub [hl]
    inc c
    ld c, $14
    xor d

Jump_004_5040:
    ld [bc], a

Jump_004_5041:
    ld a, d
    jr nz, jr_004_5095

    dec e
    ld e, c
    dec b
    rlca
    rra
    inc bc
    ld [hl], h
    sub [hl]
    ld bc, $3200
    sub $49
    ld bc, $1401
    ld b, $02
    ld a, e
    db $fc
    inc h
    db $fd
    inc h
    inc b
    ld d, d
    ld c, l
    dec [hl]
    ld b, $d0
    ld c, [hl]
    dec h
    dec l
    dec e
    add b
    inc hl
    ret nz

    ld d, c
    ld d, d
    add c
    ld b, d
    ld b, d
    ld b, b
    ld d, b
    ld d, d
    ld d, b
    ld d, c
    ld d, b
    rst $08
    ld [hl+], a
    sub c
    dec c
    inc bc
    ld h, d
    push af
    ld c, h
    dec b
    ld e, b
    ld b, b
    sub d
    sbc [hl]
    ld a, [hl+]
    ld [hl+], a
    nop
    ld [hl+], a
    ld sp, $4010
    sub h
    jr jr_004_50da

    db $eb
    ld b, e
    ld c, e
    ld a, [$0169]
    cp c
    ld e, d
    cp d
    nop
    sbc h

jr_004_5095:
    jp nz, Jump_004_6f41

    add c
    sbc l
    ld a, h
    ld l, b
    dec b
    add d
    ld d, c
    add c
    sbc h
    ld a, h
    ld a, h
    ld l, b
    dec l
    ld [bc], a
    ld c, b
    dec e
    ld e, c
    ld de, $7300
    jp nz, Jump_004_6181

    add hl, sp
    bit 0, b
    nop
    reti


    ld h, h
    ld b, b
    xor b
    dec hl
    db $10
    ld e, a
    dec h
    ld h, l
    add hl, hl
    jr z, @+$6d

    add c
    ld a, b
    ld a, [hl+]
    ld h, b
    db $d3
    rst $20
    ld d, h
    ld d, d
    db $10
    ld l, l
    ld hl, $a648
    ld a, [de]
    ld a, e
    ld [bc], a
    jr nz, @+$2f

    inc c
    jp Jump_000_18f3


    ld [bc], a
    ld [bc], a
    and h
    ld b, l
    add b

jr_004_50da:
    and a
    xor d
    and b
    pop hl
    ld hl, $0228
    rst $38
    dec b
    ld e, d
    ld a, [bc]
    ld [hl], b
    inc d
    nop
    inc b
    add sp, -$5d
    inc hl
    ld l, e
    ld l, c
    ld bc, $2958
    jr nc, @+$61

    ld l, c

jr_004_50f4:
    add hl, hl
    add sp, -$80
    sub b
    ld [$5440], a
    ldh [$a6], a
    jp nc, Jump_004_4542

    ld b, e
    ld [bc], a
    ldh a, [rDIV]
    sub [hl]
    dec bc
    jr nz, jr_004_517d

    nop
    inc l
    ld d, b
    ld d, a
    and c
    cp a
    ld e, a

jr_004_510f:
    ld c, l
    db $db
    ld b, c
    pop de
    ret c

    ld h, b
    inc a
    ret nc

    nop
    ld b, b
    inc c
    sub d
    ld [bc], a
    ld b, [hl]
    inc bc
    ld h, e
    ldh a, [$8c]
    sub d
    ld a, [bc]
    adc d
    pop bc
    db $d3
    pop af
    pop de
    pop af
    ld sp, $50a0
    ld [hl], c
    jr nc, jr_004_5160

    inc d
    ld d, $c3
    ld d, $c1
    ld d, $05
    and b
    or l
    ld e, e
    ld e, e
    add c
    sub b
    call nc, $afe4
    push bc
    nop
    add b
    ret


    ld [hl], $30
    db $10
    add l
    and e
    ld b, $31
    ld b, l
    ld h, $26
    ld [de], a
    dec de
    ld d, $80
    ld bc, $5878
    nop
    inc c
    ld bc, $0ea5
    add b
    dec c
    jr nz, jr_004_510f

    ld [$b4b6], sp

jr_004_5160:
    nop
    or [hl]
    inc [hl]
    jr nz, jr_004_50f4

    add hl, bc
    ld e, e
    sbc $0e
    nop
    ld h, e
    ret nc

    inc d
    jr nc, jr_004_51b9

    sub h
    inc d
    inc d
    ld b, [hl]
    nop
    add hl, bc
    inc c
    or [hl]
    or [hl]
    or a
    or a
    or [hl]
    or a
    sub c

jr_004_517d:
    call nz, $c386

Jump_004_5180:
    cp a
    ld d, $8c
    and b
    jr jr_004_51b4

    or [hl]
    jr jr_004_5189

jr_004_5189:
    ld a, h
    dec c
    inc bc
    ld e, e
    ld c, $0a
    and a
    add h
    add a
    dec b
    nop
    ld b, h
    call nz, $0292
    ld hl, $a478
    ld d, h
    inc e
    nop
    or d
    ld a, [bc]
    or $15
    ld [$0d19], sp
    inc d
    res 0, b
    jr nc, jr_004_51fc

    ld h, h
    and d
    nop
    add b
    xor b
    ret c

    jp nc, $c2d7

    or d

jr_004_51b4:
    ld d, b
    and b
    ld b, h
    inc l
    ld l, c

jr_004_51b9:
    ld sp, $9e50
    ld c, c
    ldh [$61], a
    ld c, e

Jump_004_51c0:
    add d
    inc de
    inc c
    ld e, $0b
    dec bc
    ld h, b
    dec bc
    pop hl
    ld [bc], a
    ld [hl], b
    ld [$085b], sp
    ld e, e
    ld e, b
    ld b, h
    ld c, d
    ld e, $f6
    ld [de], a

jr_004_51d5:
    ld a, b
    ld a, e
    dec b
    ld [bc], a
    rlca
    ld [hl], a
    inc b
    ld [hl], b
    ld b, b
    ld c, d
    ld [hl], h
    ld [$7289], sp
    dec sp
    ld a, [hl-]
    ld [bc], a
    ld [bc], a
    and a
    push bc
    ld d, b
    ld bc, $b092
    pop bc
    dec d
    ld e, $84
    ret nz

    ld l, l
    inc bc
    push bc
    inc h
    jr nc, @+$4a

    ld [hl], $60
    dec d
    inc bc

jr_004_51fc:
    ld e, h
    pop hl
    add $8d
    push bc
    ld h, b
    pop bc
    jp hl


    inc h

jr_004_5205:
    ld h, b
    sub b
    add h
    ld l, $81
    and e
    ld h, h
    inc e
    jr z, jr_004_5212

    sub b
    ld [de], a
    ld [hl], e

jr_004_5212:
    ld [hl+], a
    adc e
    push bc
    adc b
    rst $00
    dec b
    ld b, [hl]
    ret nz

    pop bc
    ld [$2406], sp
    ld [hl+], a
    ld c, d
    nop
    jr nc, @+$0c

    rrca
    ld a, h
    dec b

jr_004_5226:
    ld d, $c3
    ld bc, $0898
    inc de
    jr nz, jr_004_5226

    jp nz, $d7c2

    jr c, jr_004_5283

    dec c
    rlca
    ld a, [hl]
    ld [c], a
    ldh [rNR44], a
    inc c
    ret nc

    adc c
    ld a, [de]
    scf
    inc de
    jr c, jr_004_5245

Call_004_5241:
    ld b, b
    ld d, [hl]
    inc c
    cp h

jr_004_5245:
    add h
    inc hl
    daa
    ld [bc], a
    jr nz, jr_004_5272

    adc h
    ld b, b
    jr nc, @+$56

    ld [hl+], a
    cp c
    sbc b
    jr jr_004_51d5

    ld d, b
    sbc a
    add [hl]
    add [hl]
    and b
    ld d, b
    dec c
    sbc c
    sbc d
    inc b
    add b
    or e
    jr jr_004_527f

    add hl, sp
    jr z, @+$3a

    ld b, $c2
    ld d, b
    ld bc, $06f0
    cp l
    add hl, sp
    ld a, h
    ld [$df00], sp
    ld [bc], a

jr_004_5272:
    ret


    dec b
    ld a, [hl-]
    call nz, $4e03
    inc hl
    dec de
    dec de
    add hl, hl
    ld [hl-], a
    jr nc, jr_004_5205

jr_004_527f:
    ld h, d
    ld l, c
    db $ec
    add h

jr_004_5283:
    adc e
    dec h
    dec h
    ret nz

    ld h, e
    ld b, b
    ldh [$34], a
    ldh a, [$6d]
    sub b
    ld d, $26
    ld [hl], b
    ld a, [c]
    and b
    ldh [$d0], a
    or c
    adc b
    ld [hl], c
    ld c, c
    sub c
    ld c, c
    nop
    set 4, e
    or b
    jp Jump_000_1862


    ld [$750b], sp
    ld [bc], a
    ld e, h
    ld b, $84
    ld [hl], l

jr_004_52aa:
    rra
    sbc h
    ld [bc], a
    dec l
    push bc
    add sp, $58
    inc c
    add d
    ld h, l
    dec b
    ld b, [hl]
    jr nz, jr_004_52d4

    ld [hl], $b8
    dec d
    inc bc
    ld a, [hl]
    jp hl


    inc b
    add h
    adc e
    db $76
    ld c, [hl]
    inc b
    ld b, $4e
    add l
    sub d
    ldh a, [$d0]
    ld l, $0e
    ldh [$2a], a
    or h
    inc d
    sub b
    adc h

Jump_004_52d2:
    and $46

jr_004_52d4:
    nop
    ret c

    sub a
    ld [de], a
    nop
    call nc, $dc1a
    adc d
    add c
    sbc h
    ld l, [hl]
    ld [bc], a
    ld [bc], a
    or e
    adc b
    add e
    ld [hl+], a
    jr nc, jr_004_52aa

    jp Jump_004_7881


    add c
    sub d
    ret nc

    ld hl, $5410
    ld [hl], h
    ret nz

    xor c
    jr nz, jr_004_534f

    adc d
    adc [hl]
    nop
    nop
    ld c, c
    rst $00
    ld b, c
    nop
    db $10
    adc b
    ld de, $a181
    xor b
    adc [hl]
    ld a, [bc]
    db $10
    add [hl]
    xor e
    jp nz, Jump_000_1600

    ld d, $b2
    ld a, [de]
    adc b
    rla
    ret c

    dec bc
    dec bc
    ld h, h
    dec e
    ld [hl-], a
    ld a, [hl+]
    ld c, b
    add $12
    ld [$4204], sp
    rrca
    and [hl]
    and [hl]
    add c
    pop bc
    inc d
    ld [bc], a
    jp nz, Jump_004_7247

    ld d, [hl]
    db $10
    ld c, $83
    add b
    ld b, h
    sub h
    ld [$380c], sp
    dec d
    ld [de], a
    dec bc
    add h
    add l
    dec b
    pop af
    ld b, c
    db $d3
    ld d, c
    pop hl
    ld [hl], c
    nop
    ld a, [$096a]
    db $10
    inc d
    call $2020
    ld e, h
    add c
    ld e, c
    add c
    ld hl, $c90c
    dec b

jr_004_534f:
    xor d
    ld h, e
    ld l, d
    ld [de], a
    inc d
    ld hl, $1815
    ld d, $0b
    ld b, c
    ldh a, [$5b]
    nop
    and a
    ld bc, $8170
    sub [hl]
    ld e, [hl]
    ld e, b
    ld h, d
    ld e, h
    ld [$7dc5], sp
    ld sp, $312c
    cpl
    inc b
    add d
    add hl, bc
    ld [$e901], sp
    ld d, $a8
    dec l
    xor $1b
    jr z, jr_004_53b0

    nop
    ld l, $c0
    rst $10
    and d
    add hl, bc
    inc c

Jump_004_5381:
    scf
    ld e, b
    ld c, $58
    pop hl
    ld c, d
    add b
    push bc
    ld h, b
    nop
    ld l, c
    add c
    db $d3
    ld b, c
    nop
    ld h, b
    ld a, $18
    xor [hl]
    ld b, $41
    ld d, b
    ld e, b
    ld l, a
    ret nz

jr_004_539a:
    ld e, [hl]
    ld b, c
    or [hl]
    ret nz

    ld c, l
    add e
    and c
    ld [bc], a
    ld h, e
    dec b
    add [hl]
    ld c, d
    ld h, c
    add hl, bc
    or b
    jr nz, jr_004_53b7

    jr nz, jr_004_53da

    ld [hl], b
    ld b, d
    inc c

jr_004_53b0:
    inc b
    cp c
    dec a
    inc b
    inc l
    inc c
    inc c

jr_004_53b7:
    or $0a
    ret nz

    ld hl, $ca0e
    ld b, d
    adc d
    adc d
    add l
    ld hl, $6a18
    jr nz, jr_004_539a

    ld h, b
    and l
    ld b, c
    ld c, b
    rra
    add c
    ld h, c
    ld hl, $282c
    xor [hl]
    adc b
    dec b
    dec bc
    ld [de], a
    add l
    nop
    and a
    ret z

    ld [hl], d

jr_004_53da:
    ld c, $21
    ld e, $0b
    dec h
    ld a, [hl-]
    add [hl]
    nop
    daa
    sbc c
    ld d, $97
    ld bc, $52b1
    ld b, b
    add h
    ret nz

    ret nz

    add hl, hl
    and b
    and h
    ret z

    cp h
    ld c, $00
    sbc l
    ld c, $16
    ld [bc], a
    ld d, $08
    ret z

    ld a, l
    add l
    adc e
    ld c, h
    ld l, [hl]
    inc b
    inc bc
    ld b, e
    cp b
    ld [hl], e
    or d
    jr nc, @+$0a

    ld d, [hl]
    ld h, d
    cp b
    ld [hl], d
    add hl, de
    nop
    ld hl, $702d
    ld c, d
    pop de
    or c
    ld h, b
    ld c, h
    ld a, l
    db $fc
    sbc h
    ld b, d
    ld a, [bc]
    ld d, b
    nop
    or a
    dec b
    or $2a
    inc l
    rla
    ret z

    ld c, c

jr_004_5425:
    ld [hl+], a
    nop
    jr nc, jr_004_5440

    inc sp
    ld c, $0c
    ld d, a
    ld d, $16
    cpl

Jump_004_5430:
    jr z, jr_004_543b

    and d
    and l
    rla
    rla
    pop bc
    pop bc
    add hl, de
    ld c, e
    nop

jr_004_543b:
    nop
    ld [de], a
    dec hl
    add hl, hl
    dec b

jr_004_5440:
    ret nz

    ld l, e
    ld bc, $3eb5
    ld a, $51
    dec b
    ld b, $a0
    or d
    nop
    ld a, e
    ld c, e
    dec b
    add d
    ld [bc], a
    and e
    add a
    nop
    ret nz

    reti


    adc b
    adc e
    add b
    jr nz, jr_004_5425

    ld [c], a
    push bc
    ld h, l
    add c
    ld [hl], b
    add h
    add h
    inc sp
    ld l, h
    ld d, c
    ld c, c
    nop
    jp nc, $080b

    nop
    rst $20
    add hl, hl
    dec h
    add hl, bc
    inc b
    push af
    inc d
    nop
    sbc h
    db $10
    sub a
    inc b
    add b
    ld d, h
    adc e
    push bc
    ld hl, $2850
    ld e, b
    db $10
    inc [hl]
    ld e, $04
    add h
    dec h
    adc d
    ld b, b
    sub b
    ld a, [de]
    ld h, e
    and d
    nop
    ld h, b
    db $ed
    dec [hl]
    nop
    add sp, $74
    ret nz

    add hl, bc
    ld [hl], c
    ld l, c
    ret


    ldh [rLCDC], a
    ld hl, $00a1
    ld hl, $8b2c
    sbc e
    ld [bc], a
    ld [hl+], a
    inc b
    add c
    ld c, h
    ld b, $07
    add d
    ld b, b
    or e
    add b
    inc b
    ld bc, $8201
    ld h, b
    ld [de], a
    ld c, $b6
    jp $080c


    ld a, [hl-]
    dec b
    ld [hl], b
    ld a, [bc]
    add sp, -$6c
    or h
    or h
    inc [hl]
    ld [$522a], sp
    ld [$0410], sp
    ld a, [hl-]
    dec e
    ld l, [hl]
    ld a, [bc]
    jr c, jr_004_54db

    inc b
    ld [hl-], a
    dec l
    dec l
    dec d
    jr nz, jr_004_54d6

    ld sp, hl
    inc b
    ret nc

    sub d

jr_004_54d6:
    ld a, d
    ld a, [hl+]
    ld [bc], a
    xor $0a

jr_004_54db:
    ld b, d

Jump_004_54dc:
    pop hl
    ld h, b
    cp l
    pop bc
    ld e, l
    ld bc, $4081
    and a
    xor c
    nop
    ret nc

    ld d, a
    ld d, d
    ld d, b
    ld c, a
    ld b, b
    sub d
    pop bc
    pop bc
    ld hl, $1608
    db $10
    sub [hl]
    ld [bc], a
    sub [hl]
    inc c
    ld [de], a
    add d
    ld a, d
    and [hl]
    inc d
    add b
    ld c, h
    add c
    sub b
    inc e
    ld e, c
    dec b
    adc e
    add hl, bc
    jp nz, Jump_000_3843

    inc e
    ld [$c28a], sp
    jp nz, $ae60

    ld bc, $90ae
    add h
    ld hl, $4808
    inc d
    nop
    add hl, sp
    sub l
    ld d, h
    or b
    or b
    and b
    sub b
    or b
    or h
    inc d
    ld d, b
    inc d
    call nc, Call_000_00f3
    ld l, d
    ld a, [hl+]
    call z, Call_004_5014
    xor b
    jr c, jr_004_5558

    ld e, h
    nop
    ld d, $c2
    jp $c07c


    jp $0316


    ld h, b
    jr nc, @-$2d

    nop
    ld d, c
    rst $00
    rst $00
    ld c, a
    adc e
    ld b, e
    nop
    sbc $aa
    ld h, e
    add b
    db $e3
    db $e3
    ld l, b
    dec l
    ld bc, $5141
    sub b
    ld c, a
    ld c, a
    add b
    add l
    dec b
    inc h
    xor c

jr_004_5558:
    and a
    db $e3
    and e
    inc hl
    ld l, e
    ld l, c
    inc h
    or c
    pop hl
    ld b, [hl]
    add b
    db $eb
    ld [bc], a
    rst $08
    ld e, c
    inc b
    ld [bc], a
    adc e
    ld [bc], a
    ld l, c

jr_004_556c:
    dec d
    ld e, e
    ld e, b
    jr nc, jr_004_5597

    ld d, $80
    ld b, l
    ld [de], a
    db $f4
    pop af
    sub e
    db $f4
    ld [hl], e
    dec [hl]
    ld [de], a
    ld hl, $0448
    ld a, [$0a38]
    ld c, c
    ld a, [hl-]
    ld a, [bc]
    add hl, de
    jr nc, @+$4c

    xor d
    ld e, d
    xor b
    ret c

    nop
    jp nc, Jump_004_5c3a

    inc d
    ld [$0558], sp
    ld a, h
    ld a, [de]
    ret nz

jr_004_5597:
    dec [hl]
    ld c, b
    dec hl
    ld b, b
    inc c
    rla
    dec bc
    add d
    or a
    inc l
    ld c, e
    dec b
    ld b, b
    inc bc
    jp z, $393a

    ld e, h
    ld l, h
    ld d, c
    call z, $b878
    ld e, b
    ld a, [bc]
    jp z, Jump_000_0a5a

    ld a, [de]
    ret nz

    ld e, d
    xor b
    ld l, b
    ld e, b
    inc l
    ld e, h
    ld l, h
    ld hl, $98cc
    cp b
    ld de, $3040
    ldh [rLY], a
    ld h, d
    ld c, c
    pop hl
    ld b, d
    nop
    sub a
    or b
    and l
    jr nz, jr_004_55ef

    ld b, $4e
    ld hl, $db31
    ld e, e
    db $db
    db $db
    ret


    ld b, d
    nop
    ld de, $30b0
    and [hl]
    xor l
    db $ed
    ld l, l
    ld h, h
    ld [hl+], a
    ld [hl], c
    and d
    ld hl, $0330
    jr nc, jr_004_556c

    inc bc
    ld b, [hl]
    ld c, c
    ret nz

jr_004_55ee:
    sub [hl]

jr_004_55ef:
    add d
    ret nz

    add hl, hl
    ld h, c
    dec bc
    rlc c
    ld h, b
    inc b
    sub h
    ld h, d
    adc e
    pop hl
    ld bc, $d3f0
    ld bc, $0b27
    dec bc
    ld bc, $d110
    nop
    and a
    pop bc
    ld d, c
    ret nz

    ld d, $bf
    inc bc
    and b
    and a
    ld b, b
    ld c, h
    pop bc
    add c
    nop
    and d
    call nz, $0160
    ld b, b
    ld de, $a4f0
    jr nc, jr_004_568f

    or b
    and l
    or b
    dec b
    ld b, d
    nop
    ld c, c
    jr c, jr_004_5628

jr_004_5628:
    inc e
    jp nz, Jump_000_1696

    add e
    ld h, b
    ld bc, $948e
    inc d
    or [hl]
    or b
    or b
    inc a
    nop
    call $b0e4
    add l
    push bc
    jr nc, jr_004_55ee

    ld b, l
    inc h
    or c
    and h
    add l
    add l
    add l
    or b
    push bc
    ld h, h
    or b
    ld b, l
    xor [hl]
    xor $6e
    ld b, l
    ld h, b
    ld [de], a
    ld a, d
    ld a, c
    dec b
    ld [bc], a
    ld [$05b9], sp
    add b
    ld b, b
    inc b
    ld [bc], a
    ld d, a
    add c
    jp $0f06


    inc hl
    ld b, l
    ld b, b
    ld a, b
    ld d, $31
    ld [bc], a
    add c
    add $19
    sbc b
    jr z, @+$62

    ld d, $06
    ld b, b
    add $40
    ld b, a
    add c
    ld e, a
    or e
    dec h
    ld b, b
    ld b, b
    ld [hl], $08
    rra
    ld l, c
    ld [hl], c
    dec b
    ret nz

    sub a
    ld e, b

Jump_004_5682:
    cp e
    or b
    ld [hl-], a
    nop
    sbc h

jr_004_5687:
    nop
    ld a, d
    xor b
    ld [de], a
    db $10
    cp b
    ld a, [hl+]
    ret z

jr_004_568f:
    sub [hl]
    ld bc, $f29d
    sub $56
    nop
    adc b
    add a
    inc bc
    and l
    ld c, $31
    ld [c], a
    ld h, c
    call nc, Call_004_7c0c
    adc [hl]
    add c
    sbc d
    jr nc, jr_004_5687

    add hl, sp
    ld c, $0c
    adc $80
    sub a
    jr jr_004_5706

    ld [$ce03], sp
    adc e
    res 1, d
    dec b
    ld h, c
    ld h, b
    add hl, sp
    rlca
    nop
    ld h, c
    add b
    db $d3
    inc c
    inc b
    sub [hl]
    ld a, [hl-]
    ld bc, $aa64
    jp nz, Jump_000_39a8

    add sp, $17
    inc de
    add b
    ld h, h
    ld hl, $0c2e
    inc b
    ld d, l
    ld [hl], b
    db $10
    rrca
    or b
    pop hl
    jr nz, jr_004_56e0

    ld e, b
    ld d, h
    db $10
    jp hl


    ldh a, [$2c]
    ld [hl], $a6

jr_004_56e0:
    ld a, d
    ld c, b
    adc c
    add e
    sbc d
    or b
    pop de
    ld [hl], $2e
    ld a, b
    jp z, Jump_004_5381

    ret nc

    ld d, $c3
    cp [hl]
    add h
    add b
    add [hl]
    inc l
    nop
    add h
    adc e
    ld h, b
    ld sp, $4255
    ld c, d
    inc e
    xor b
    adc b
    rst $08
    add c
    ld bc, $4c40
    inc c

jr_004_5706:
    adc c
    add l
    ld e, b
    or e
    ldh [$64], a
    add d
    ld e, d
    ld [$7a84], sp
    pop de
    db $e3
    ld b, d
    ld a, b
    jr nz, @+$3e

    add h
    add c
    sbc a
    ld sp, $31d0
    ld c, $46
    jp nz, Jump_004_5c41

    ld bc, $02ee
    add l
    ld h, [hl]
    add c
    xor c
    nop
    add b
    ld a, b
    add b
    ld l, [hl]
    ldh [rNR33], a
    ld [hl], $5b
    ld a, [bc]
    inc b
    and h
    ld [hl], c
    ret nc

    ld e, l
    xor b
    add l
    ld b, b
    xor b
    rla
    ld e, l
    ld [bc], a
    jp nz, Jump_000_1863

    ld h, b
    dec e
    ld a, a
    adc c
    daa
    ld b, $c1
    inc a
    ld e, c
    jr jr_004_5756

    ld [hl], l
    ld [bc], a
    inc bc
    ld b, l
    ld e, b
    ld de, $9808
    ld a, [bc]

jr_004_5756:
    call nc, Call_000_1384
    ld bc, $3bc3
    ld [hl], h
    cp [hl]
    inc d
    ld [$01aa], sp
    ld b, $08
    rst $20
    or d
    ldh a, [$34]
    ld d, $c4
    ld c, b
    sbc h
    ld b, b
    jr nc, @+$35

    ld [hl], d
    inc b
    ld [bc], a
    adc $71
    db $10
    scf
    ld e, $28
    jp nz, Jump_000_009d

    or b
    sub [hl]
    ld c, e
    nop
    or b
    add hl, bc
    ld [hl], a

Call_004_5782:
    add hl, hl
    inc b
    ld b, c
    ld a, e
    add e
    ld d, c
    ld sp, $2450
    ld c, $54
    ld c, e
    nop
    add a
    ld d, $16
    ld [bc], a
    db $e3
    ld l, c
    call nz, Call_000_10f1
    inc b
    inc de
    and e
    xor $ae
    xor h
    db $ed
    xor l
    xor l
    ld hl, $6a98
    ld b, b
    ld de, $d80e
    jp Jump_004_6a00


    ld c, b
    adc e
    db $db
    cp e
    ld b, b
    db $10
    inc a
    ld a, [hl+]
    nop
    adc [hl]
    ld a, [hl+]
    add c
    and b
    cp a
    ld bc, $187c
    ld c, b
    dec e
    dec sp
    jr c, jr_004_57c5

    jp Jump_000_38d3


    nop

jr_004_57c5:
    ld [hl+], a
    ld e, l
    ld d, [hl]
    inc b
    add b
    ld c, h
    or h
    cp b
    ld [bc], a
    jr nz, @+$5a

    ld a, [bc]
    ld [$6440], sp
    ld h, b
    cp c
    ld b, a
    ld c, b
    ld bc, $39f0
    ld e, $1e
    call nz, Call_004_5782
    jr c, @-$56

    dec h
    inc bc
    ld a, d
    ld h, h
    ld b, a
    nop
    ld l, b
    inc d
    inc bc
    ld c, [hl]
    ld b, b
    ld a, $0c
    ld c, h
    adc [hl]
    add e
    ld c, l
    ld [hl], d
    ldh a, [$58]
    ld b, c
    ld b, l
    inc c
    db $fc
    add l

jr_004_57fb:
    cp c
    cp b
    cp c
    cp b
    inc b
    ld h, b
    and d
    ld bc, $6857
    db $ec
    dec hl
    inc l
    ld c, c
    ld e, c
    ld l, c
    ld a, c
    ld [$c41e], sp
    add d
    ld b, a
    add l
    dec de
    pop de
    ld h, d
    ld b, h
    nop
    ld [hl], b
    add a
    inc d
    add c
    and b
    add e
    inc c
    add b
    sub c
    jr @+$03

    ldh [rNR24], a
    nop
    add h
    dec bc
    jr nz, jr_004_57fb

    ld [hl+], a
    ld b, [hl]
    db $10
    add sp, -$76
    add e
    sub c
    ld sp, $15a0
    ld d, $e8
    ret


    add b
    ld d, b
    sub l
    sub [hl]
    add d
    ld [bc], a
    or d
    pop bc
    adc l
    jr c, jr_004_5859

    ld a, [hl+]
    sub b
    ld de, $9c0e
    call nz, Call_000_1815
    ld bc, $2110

Jump_004_584c:
    cp [hl]
    xor b
    ld [$7108], sp
    ld a, [c]
    nop
    ld b, h
    xor $9c
    cp h
    and [hl]
    xor b

jr_004_5859:
    inc d
    add d
    jp hl


    or b
    ld [hl], b
    ld b, c
    ld d, $7e
    ld a, [bc]
    jr nz, jr_004_58b9

    add b
    xor h

jr_004_5866:
    jp nc, Jump_000_1052

    call c, $8988
    sub e

jr_004_586d:
    ld sp, $04e0
    ld h, d
    push bc
    nop
    ld h, e
    cp b
    sub b
    add hl, hl
    or b
    ld de, $e20e
    jp $1141


    nop
    cp a
    dec d
    ld h, d
    call nz, $84c0
    sbc b
    and d
    inc hl
    jr jr_004_58ae

    ld a, [hl-]
    ld b, b
    ld h, $7c
    add hl, hl
    nop
    sbc h
    ld a, [hl-]
    and b
    or [hl]

Call_004_5894:
    add sp, -$52
    jp nz, $1043

    nop
    add [hl]
    dec b
    sub c
    ld b, $b9
    ld [hl+], a
    ld b, [hl]
    nop
    sbc b
    rla
    rlca
    ld c, e
    ld h, d
    ld h, b
    inc a
    sbc l
    rla
    ld bc, $2760

jr_004_58ae:
    ld d, $82
    rst $00
    ld b, $a0
    jr jr_004_586d

    ld de, $8785
    dec l

jr_004_58b9:
    ld b, $00
    sub $38
    nop
    ld a, [bc]
    rrca
    jr nc, jr_004_5866

    res 0, d
    nop
    ld h, b
    ld a, [bc]
    ld e, c
    ld [bc], a
    ld [bc], a
    ld d, b
    inc bc
    di
    ld sp, $34c0
    ld l, $2c
    and h
    xor b
    db $10
    add b
    pop af
    ld d, $80
    ld e, l
    ld h, e
    and e
    and a
    inc de
    add d
    and l
    nop
    ld b, c
    ld e, $a6
    ld a, [bc]
    ld h, b
    adc l
    rlca
    ld hl, sp+$30
    ld d, b
    ld a, $c6
    inc b
    ld [bc], a
    sub b
    pop af
    nop
    ld e, h
    ld h, b
    inc sp
    sub [hl]
    ld b, b
    ld d, b
    ld a, [de]

jr_004_58f9:
    ld b, $40
    jp nz, $40e7

    jr nc, jr_004_593e

    ld e, $7e
    ld d, d
    ld e, a
    ld h, a
    rra
    inc c
    cp d
    db $e3
    and d
    dec h
    jp hl


    pop hl
    sub c
    adc [hl]
    adc d
    ld [bc], a
    ld h, b
    inc b
    ld a, [hl-]
    ld a, [bc]
    call z, Call_004_5894
    inc d
    ld e, e
    ld e, l
    dec b
    pop bc
    ld d, e
    xor b
    dec c
    inc bc
    jr nz, @+$63

    ld hl, $c4ae
    pop bc
    ret c

    xor $fe
    cp $49
    db $10
    ld d, [hl]
    push bc
    ld b, l
    ld c, e
    jr jr_004_5934

    ld [c], a

jr_004_5934:
    ld e, h
    inc a
    nop
    adc h
    ld bc, $30f8
    or b

jr_004_593c:
    jr z, jr_004_593c

jr_004_593e:
    ld b, $0b
    add d
    rlca
    pop af
    ld de, $7312
    and e
    jp Jump_000_3603


    or $e2
    ld b, [hl]
    ld de, $14c4
    ld h, b
    ld c, $07
    add h
    ld h, c
    ld sp, $eff1
    jr nc, @+$43

    ld l, b
    dec c
    dec de
    dec l
    ld h, c
    inc b
    add d
    ld [hl], e
    ld [hl], c
    nop
    jr nc, jr_004_597c

    ld a, [hl-]
    ld b, e
    ld h, c
    ld [c], a
    ld h, c
    ld e, a
    jp nz, $1620

    ld d, $0f

Call_004_5971:
    dec bc
    inc de
    ld a, e
    inc l
    jr jr_004_58f9

    daa
    ld d, c
    daa
    db $10
    ld c, h

jr_004_597c:
    inc d
    ret nc

    rrca
    ld h, l
    ld h, a
    cpl
    inc a
    ld d, $24
    inc c
    nop
    ld b, h
    ld bc, $f10d
    pop de
    ld d, d
    ld b, b
    cpl
    call z, $74d4
    ld [hl], h
    inc h
    inc c
    db $dd
    ld h, d
    rlca
    add a
    call nz, LoadRomBank
    dec bc
    scf
    ld a, [hl-]
    inc b
    pop bc
    ld [hl], e
    inc d
    inc e
    ld [de], a
    dec bc
    add hl, hl
    add l
    nop
    inc l
    or h
    inc c
    inc c
    ld d, e
    jp hl


    ld l, $2d
    dec c
    ld b, $96
    jr nc, jr_004_59b8

    add c
    add [hl]

jr_004_59b8:
    ld [$2018], sp
    ld e, d
    ld a, [de]
    or b
    dec h
    inc e
    ld [$c51c], sp
    add d
    sub e
    jr c, jr_004_5a27

    ld e, [hl]
    add hl, hl
    jr c, jr_004_5a29

    add hl, bc
    add c
    ld a, h
    xor a

jr_004_59cf:
    ld bc, $3520
    cp h
    ld [$6004], sp
    ld h, c
    ld h, c
    inc h
    ld [hl], h
    add c
    ld e, l
    ld e, d

jr_004_59dd:
    ld [$305d], a
    nop
    or c
    dec b
    inc e
    dec de
    inc e
    adc c
    adc e
    sub [hl]
    ld d, $4c
    ld l, [hl]
    ld a, [hl-]
    ld [$4c00], sp
    jr c, jr_004_5a62

    xor [hl]
    add e
    db $e3
    jp nz, $0565

    add $10
    call z, $1054
    add hl, bc
    ld e, l
    ld [bc], a
    ld b, b
    or b
    db $10
    ld [$c2c0], sp
    jp nz, $e848

    or c
    ld b, b
    ld e, e
    cp e
    ld d, b
    and d
    ld [hl], e
    ld [$7b1c], sp
    ld c, $00
    ld a, [de]
    ld h, d
    ld bc, $d7ba
    ld b, b
    ld d, b
    inc de
    and [hl]
    call nz, $0cb8
    nop
    sbc b
    jr nc, jr_004_5a5b

    stop

jr_004_5a27:
    add h
    xor a

jr_004_5a29:
    dec bc
    cpl
    ld sp, $8531
    add b
    or e

jr_004_5a30:
    add c
    ld e, b
    ret z

    ld a, [c]
    ld [c], a
    ld [bc], a
    ld a, e
    dec sp
    cp e
    ldh a, [$0a]
    dec de
    cp e

jr_004_5a3d:
    ld b, b
    pop bc
    jr @-$38

    ld b, d
    sbc b
    ld d, a

Jump_004_5a44:
    sub e
    dec de
    add d
    jr nc, jr_004_59dd

    xor a
    xor a
    xor a
    jr nc, jr_004_59cf

    ld l, b
    add hl, hl
    jr nz, jr_004_5a6e

    ld d, $d2
    ld c, d

jr_004_5a55:
    add hl, bc
    inc b
    nop
    pop hl
    ld [bc], a
    ld l, h

jr_004_5a5b:
    db $e4
    inc h
    ld hl, $0cc0
    dec bc
    nop

jr_004_5a62:
    ld h, c
    add b
    ld [hl-], a
    db $dd
    call c, $01da
    ld h, b
    ld d, $06
    jr c, jr_004_5a30

jr_004_5a6e:
    ret nz

    ld b, h
    inc bc
    add h
    ret nc

    ld h, l
    pop hl
    and d
    and e
    ld h, d
    jp nz, $f430

    add h
    ld bc, $3088
    inc l
    inc b
    add c
    ld [hl], b
    jr c, jr_004_5a55

    inc c
    db $d3
    ld d, d
    ld h, l
    nop
    jr c, jr_004_5a3d

    dec bc
    dec bc
    sub d
    sub h
    adc [hl]
    ret nc

    rlca
    ld b, b
    or l
    adc e
    nop
    ldh a, [rDIV]
    sub b
    db $eb
    ld c, l
    sub c
    ld d, c

jr_004_5a9e:
    ld hl, $1314
    ld h, c
    ld b, c
    ld hl, $1c0c
    or a
    stop
    ldh [$c2], a
    ld bc, $185a
    ldh a, [$e8]
    ld [bc], a
    jp $82c2


    nop
    inc b
    sbc b
    sbc a
    and c
    call nz, $ad97
    xor [hl]
    add a
    nop
    jr c, jr_004_5a9e

    adc e
    adc c
    ld b, c
    sub b
    sub l
    xor $ae
    nop
    db $10
    add hl, hl
    ld h, $00
    ld d, h
    and [hl]
    ld [de], a
    nop
    ld a, h
    ld e, d
    ld c, $00
    db $fc
    dec c
    ld h, d
    dec bc
    inc h
    add h
    inc hl
    jr @+$25

    ld e, $b2
    or [hl]
    or c
    inc d
    dec d
    dec e
    inc e
    cp d
    inc c
    nop
    and d
    sub h
    nop
    sub b
    db $10
    ld d, $23
    rla
    inc hl
    dec de
    ld a, e
    ld c, b
    ld e, h
    jr nz, @+$04

    add a
    ldh a, [rLY]
    ld [hl], a
    ld l, c
    nop
    ld a, h
    add [hl]
    jp $caf1


    db $db
    ld e, e
    stop
    jp nz, $43c3

    ret z

    inc a
    jp nc, $41c1

    nop
    ld h, $0a
    ret nc

    or l
    pop hl
    ld [hl], c
    pop hl
    ld bc, $5b9b
    cp e
    ld [bc], a
    inc bc
    dec de
    dec bc
    cp e
    call nc, $2000
    ld d, d
    add hl, bc
    nop
    inc h
    ld sp, $3135
    dec [hl]
    ld [hl], c
    inc l
    ld c, b
    inc l
    ld d, b
    inc h
    nop
    rlca
    add l
    scf
    ld [hl], a
    nop
    or h
    db $f4
    ld [c], a

jr_004_5b3a:
    ld [hl+], a
    nop
    ldh [rNR30], a
    inc a
    add e
    cp e
    ld b, d
    add a
    dec l
    ld b, [hl]
    inc a
    ld h, b
    ld l, a
    rrca
    ret nz

    ld b, h
    add e
    jp c, Jump_004_6360

    ld d, a
    ld e, d
    ld [$56c0], sp
    ld sp, $2d32
    ld l, $bc
    dec b
    nop
    and d
    ld l, [hl]
    rst $28
    ld l, a
    add hl, de
    jr jr_004_5b3a

    ld e, e
    db $db
    ret c

    rst $10
    dec b
    ret c

    ret c

    ld b, $00
    db $d3
    jp nz, $cac2

    jr nz, @+$6a

    jp hl


    dec h
    nop
    ret nz

    dec b
    ld e, b
    cp l
    xor d
    ld c, d
    ld [$2aee], sp
    ld d, h
    or h
    ret nz

    dec hl
    nop
    ld b, [hl]
    or d
    adc b
    sub c
    add c
    ld e, c
    ld l, c
    ld h, c
    add hl, sp
    ld [$40c1], sp
    xor c
    nop
    ld d, b
    ldh [$e1], a
    ld [c], a
    db $e3
    ld sp, $bc2e
    cp l
    add hl, hl
    ld l, $29
    ld [hl-], a
    dec l
    add b
    sub $83
    ld [hl-], a
    dec l
    inc l
    inc de
    ld bc, $da5a
    db $ec
    call z, Call_004_6cd4
    ld [hl], l
    xor l
    ld e, $1c
    or [hl]
    ld d, b
    inc c
    ld a, $4d
    cp h
    ret z

    ret nz

    db $10
    add [hl]
    sub c
    ld h, d
    ld e, b
    inc b
    add c
    ld c, a
    add e
    and l
    ld [bc], a
    ld c, c
    ret nz

    inc hl
    ld [hl], d
    di
    ld a, [c]
    ld bc, $9410
    ld c, e
    adc d
    jp z, $e820

    add hl, bc
    ld d, b
    ld d, c
    db $10
    jr c, @-$7d

    sub [hl]
    jr c, jr_004_5c17

    add a
    ld a, l
    add l
    ld bc, $07ab
    dec l
    ld [de], a
    ld b, c
    ld b, [hl]
    dec de
    dec e
    inc e
    inc d
    dec d
    inc de
    ld b, $61
    ld [hl+], a
    add sp, $00
    sub b
    add b
    ld a, [hl]
    add [hl]
    ld c, $fb
    ld a, [$585a]
    jr nz, jr_004_5bfa

jr_004_5bfa:
    daa
    nop
    sub c
    and e
    and e
    db $e3
    nop
    ld l, b
    ld e, [hl]
    ld d, h
    inc l
    inc l
    sbc [hl]
    dec e
    dec e
    add hl, bc
    rst $08
    rrca
    and c
    dec l
    inc l
    ld a, [de]
    ld [bc], a
    ld [$067d], sp
    nop
    db $10
    adc b

jr_004_5c17:
    nop
    ret z

    dec hl
    ld a, e
    inc bc
    jp nz, $8d73

    push af
    or d
    ld [hl], b
    rst $10
    ld h, b
    ld e, b
    inc e

Call_004_5c26:
    nop
    dec d
    ld a, b
    dec l
    inc bc

jr_004_5c2b:
    jp nc, $c4e4

    add [hl]
    nop
    ld [hl], b
    ld h, $07
    rra
    dec b
    ld [hl], h
    push bc
    add l
    ret nz

    ld [bc], a

Jump_004_5c3a:
    call nc, $aeab
    jr nz, jr_004_5c97

    db $eb
    ret nz

Jump_004_5c41:
    ld d, l

Jump_004_5c42:
    ld h, $f8
    push bc
    pop bc
    ld c, a
    add l
    call Call_000_2502
    pop hl
    and b

jr_004_5c4d:
    jr nz, jr_004_5c63

    ld c, $00
    push af
    ld h, c
    ld h, c
    ld e, h
    inc c
    sbc b
    sub c
    ld sp, $e001
    dec sp
    xor h
    nop
    dec d
    jr jr_004_5c63

    inc e
    dec b

jr_004_5c63:
    cp [hl]
    ld c, e
    ld d, c
    ld de, $0304
    ld h, d
    ret nz

    inc a
    inc c
    inc b
    inc bc
    dec a
    ld sp, $1b40
    ld c, $be
    jp $f841


    ld hl, sp-$1e
    ld [hl+], a
    jr jr_004_5c4d

    jp nz, Jump_004_54dc

    pop bc
    add b
    ld [hl-], a
    ld c, [hl]
    add b

jr_004_5c85:
    ld a, [bc]
    ld a, h
    inc d
    sbc b
    xor b
    jr c, jr_004_5c8c

jr_004_5c8c:
    adc [hl]
    jp z, $435e

    add c
    add b
    ld d, h
    add b
    ccf
    inc c
    nop

jr_004_5c97:
    dec d
    ld b, b
    inc l
    dec [hl]
    nop
    ldh a, [$86]
    ld bc, $02a6
    pop hl
    db $e3
    ld l, [hl]
    ld b, b
    ld [hl], b
    jr jr_004_5c2b

    add l
    dec b
    ld b, c
    ld c, e
    ld bc, $724d
    rst $20
    ld b, h
    sub b
    nop
    dec [hl]
    ret nz

    xor e
    ld d, b
    ld l, $7a
    ld b, $00
    ld a, h
    ld [hl-], a
    or b
    dec hl
    ld b, $02
    jp nz, Jump_004_6ec2

    ret c

    add hl, de
    nop
    ld [de], a
    dec bc
    inc c
    nop
    sub d
    add hl, de
    ld b, $82
    ret z

    ld sp, $15a0
    ld [hl], b
    jr nz, @+$2a

    ld c, [hl]
    inc sp
    nop
    ld b, h
    add [hl]
    cp e
    add c
    ld [hl+], a
    ld d, b
    inc a
    ld c, b
    rst $00
    add hl, de
    nop
    db $f4
    ld [hl], d
    ld e, h
    ld l, h
    or [hl]
    and h
    inc l
    nop
    adc $a8
    and a
    rst $00
    nop
    ld b, b
    ld l, c
    ld [hl], h
    ld d, h
    nop
    ld c, b
    adc b
    add [hl]
    and e
    add [hl]
    inc bc
    ld h, b
    jr z, jr_004_5d0b

    jr nz, jr_004_5c85

    add e
    cp c
    ld [hl], b
    jr nz, jr_004_5d65

    ret nz

    and h
    ld d, b
    ld d, c
    ld b, c

jr_004_5d0b:
    ld [hl], b
    ld e, e
    or $02
    ld a, [bc]
    ld b, $13
    add b
    sbc c
    ld b, $c1
    nop
    ret nc

    inc e
    jr @-$72

    rla
    add c
    and b
    ld [hl], h
    db $e4
    call c, $f5e5
    db $e4
    inc l
    inc b
    db $10
    ld h, d
    ld b, c
    ld b, d
    inc c
    add sp, -$72
    dec b
    ld [hl+], a
    ld [hl-], a
    dec h
    ld d, l
    db $10
    ret nc

    add h
    ld bc, $30ab
    db $10
    db $10
    adc d
    ld a, d
    ld a, [bc]
    add b
    dec h
    ret nc

    db $db
    and b
    sub h
    inc a
    dec c
    ld [$6336], sp
    ldh [$3a], a
    adc $60
    ld bc, $21e0
    ld b, $4c
    call nz, Call_004_45c0
    cp b
    pop hl
    pop af
    dec sp
    db $10
    jp nc, $81c3

    ld [hl], b
    jr c, @-$26

    inc d
    ld b, a
    ld [bc], a
    nop
    ld e, l
    ld a, [hl+]

jr_004_5d65:
    cp [hl]
    add d
    ret nz

    and a
    ret nz

    ld b, h
    inc bc
    cp $3a
    ld d, l
    dec b
    add d
    ld b, h
    dec b
    and e
    ld c, $36
    inc hl
    ld [hl], b
    xor d
    ld b, b
    ld l, b
    xor c
    db $f4
    ld d, h
    db $10
    sbc b
    adc b
    inc e
    add c
    ld [hl+], a
    dec a
    db $f4
    dec c
    inc b
    ld l, $63
    ld b, b
    ld h, [hl]
    db $f4
    db $10
    and $1c
    inc b
    ld a, $a5
    ld b, $82
    and h
    or c
    jr nz, @+$60

    ld hl, $2c3e
    ldh a, [$8d]
    add c
    ld h, b
    ld [hl], c
    ld [hl], b
    add hl, de
    ld a, d
    ld b, $00
    add $32
    ret nc

    ld d, d
    db $e3
    and d
    nop
    ldh [$0b], a
    ld a, a
    inc bc
    add e
    ld e, e
    ld e, b
    ret z

    ld l, d
    or b
    dec d
    dec b
    rst $00
    jp nz, $c020

Jump_004_5dbd:
    dec c
    ld b, $58
    nop
    jr c, @-$7b

    sbc c
    ld [hl], b
    add b
    ld [de], a
    ld a, d
    add [hl]
    adc d
    ld c, $82
    cp a
    ld b, $16
    push bc
    cp [hl]
    cp b
    inc c
    add d
    sub a
    ld a, $3d
    ld b, l
    add hl, sp
    ld a, c
    ld [hl], a
    rla
    add c
    add hl, sp
    ld a, a
    dec d
    add c
    adc a
    ld a, b
    jr c, jr_004_5df4

    dec bc
    ld b, b
    and c
    ld c, e
    ld b, b
    ret nz

    adc l
    ld [hl], e
    scf
    add $05
    ld hl, sp-$29
    nop
    ret nc

jr_004_5df4:
    add l
    inc bc
    jp c, $c102

    adc c
    ld b, $84
    or d
    ld sp, $9160
    ld l, a
    xor $eb
    nop
    ret z

    add sp, -$6c
    ld d, e
    nop
    inc b
    or l
    db $eb
    db $eb
    cp b
    jr jr_004_5e6c

    jr z, @+$7e

    call nz, Call_004_6e00
    jp nz, $a101

    ld l, l
    call c, Call_004_5971

jr_004_5e1c:
    jr jr_004_5e1e

jr_004_5e1e:
    ld c, a
    db $e3
    ld b, b
    ld l, $0c
    ld c, $08
    call nc, $04c1
    add b
    rst $00
    ld [bc], a
    xor c
    dec c
    jp c, $dfc5

    nop
    ld h, b
    pop de
    ld c, l
    and a
    ldh [rP1], a
    ld d, b
    ld a, [hl-]
    dec b
    dec b
    pop bc
    add hl, de
    jp hl


    ld h, c
    jr z, jr_004_5e41

jr_004_5e41:
    ld d, h
    add $83
    ld a, e
    dec b
    pop de
    add b
    inc sp
    cpl
    rlca
    ld b, b
    or h
    jr c, @-$36

    ld l, d
    ld [hl], b
    ld e, a
    nop
    and e
    add b
    ld e, c
    or d
    ld sp, $322d
    jr nc, jr_004_5e1c

    sbc h
    rlca
    add b
    and [hl]
    ld b, e
    ld [hl], b
    inc d
    dec d
    ld [bc], a
    ld bc, $3c30
    cp l
    ldh [rDIV], a
    db $fd

jr_004_5e6c:
    inc l
    inc b
    sub l
    ld h, c
    ld h, b
    cp c
    ld bc, $e893
    db $db
    dec hl
    ld [$44a4], sp
    ld c, l
    ld c, h
    rst $18
    ld e, [hl]
    ld [bc], a
    sub b
    push de
    ldh [$2f], a
    rst $08
    nop
    jr nc, jr_004_5e9f

    ld h, a
    xor a
    nop
    jr @+$04

    jp c, Jump_004_4c63

    nop
    add b
    dec bc
    inc bc
    pop hl
    dec b
    ld h, b
    jp Jump_004_4942


    add e
    jp c, $7390

    and c
    ld d, e

jr_004_5e9f:
    dec d
    or h
    nop
    ld [$d035], sp
    inc c
    ld d, e
    ld h, h
    ld d, h
    ld a, h
    add hl, bc
    ld b, b
    and l
    jr jr_004_5ee7

    dec hl
    sub b
    rla
    ld d, $56
    jp nz, $a741

    jr jr_004_5f21

    rrca
    rla
    ei
    ld h, e
    ld l, d
    nop
    add sp, $18
    ld [hl], a
    inc bc

jr_004_5ec3:
    ld bc, $186c
    ld [$8006], sp
    dec b
    xor h
    ld [bc], a
    ld c, $4e
    add hl, de
    nop
    inc h
    dec b
    ret nc

    ld a, [bc]
    db $f4
    ld [hl], l
    ld [hl], c

jr_004_5ed7:
    sub e
    ld a, c
    xor c
    adc c
    jp hl


    ld [hl], d
    nop
    nop
    call nz, Call_004_4640
    cp l
    ld bc, $a340
    add b

jr_004_5ee7:
    sbc a
    ld l, b
    jr z, jr_004_5ed7

    add hl, de
    ld c, d
    nop
    inc [hl]
    dec bc
    ld a, b
    or h
    cp h
    ld a, [hl+]
    nop
    add b
    jp $dc01


    jr jr_004_5f1b

    ld l, h
    pop de
    dec de
    ld b, $40
    ld e, e
    ld d, h
    adc c
    push hl
    dec h
    nop

jr_004_5f06:
    sbc [hl]
    ld [hl+], a
    and l
    and c
    nop
    add b
    ld c, h
    ld b, a
    inc de
    ld [hl], e
    nop
    inc a
    add e
    sub c
    ld l, $02
    add b
    add h
    jr jr_004_5f72

    ld l, l

jr_004_5f1b:
    dec h
    nop
    ld a, h
    inc d
    ld a, [hl+]
    ld a, [hl+]

jr_004_5f21:
    nop
    ld l, $4b
    reti


    dec d
    nop
    add b
    ld [hl], c
    ld b, $02
    and c
    jr c, jr_004_5fa1

    dec b
    ld b, b
    ld [hl], h
    jr z, jr_004_5f06

    ld [c], a
    or d
    ld b, b
    nop
    ld b, d
    ld a, [de]
    jr z, jr_004_5ec3

    adc e
    sbc h
    ld [bc], a
    nop
    cp d
    ld e, [hl]
    inc e
    inc d
    add hl, bc
    ld [bc], a
    nop
    jr @-$4f

    daa
    cpl
    daa
    ld l, a
    ld bc, $0b78
    inc bc
    rst $20
    ld [hl], c
    xor $ba
    inc c
    add b
    sbc [hl]
    sub b
    add l
    rst $10
    ret nc

    ld d, b
    ld [hl], h
    sub a
    rst $30
    push bc
    push hl
    and d
    ld h, e
    ld bc, $3600
    ld [c], a
    pop hl
    add hl, sp
    ld [$c2fc], sp
    ld b, d
    ld c, e
    add c
    add $02
    add hl, de

jr_004_5f72:
    ld h, c
    nop
    xor e
    push bc
    nop
    ret nc

    dec e
    ld c, $7e
    sub d
    ld [$8004], sp
    dec c
    sbc h
    ld b, d
    reti


    nop
    ldh a, [$78]
    inc b
    add b
    cp h
    inc a
    ld [bc], a
    add c
    ld a, a
    cp [hl]
    add c
    nop
    ld e, [hl]
    inc l
    db $fc
    inc [hl]
    nop
    adc $25
    push bc
    ld [hl], a
    jr nz, @+$16

    adc h
    cp l
    or d
    ld [bc], a
    add b
    and l

jr_004_5fa1:
    sub h
    add b
    ld d, b
    ld d, e
    rst $20
    ld h, d
    and d
    and d
    ldh [$88], a
    rst $00
    add c
    ld l, b
    res 6, a
    ld d, e
    ldh a, [rHDMA5]
    scf
    ld d, [hl]
    sub $17
    ld bc, $e4b0
    add hl, de
    inc l
    nop
    ld h, d
    jp nz, Jump_004_7a01

    ret c

    dec hl
    dec sp
    ld [c], a
    ld b, c
    nop
    ld h, [hl]
    inc bc
    ld h, h
    ld e, h
    ld l, h
    ld a, [hl]
    ld d, c
    pop hl
    inc a
    nop
    ccf
    ld c, c
    nop
    dec bc
    add d
    add d
    jr nc, jr_004_601e

    ld h, l
    rst $10
    add l
    nop
    call nc, $bc24
    ld a, [hl+]
    nop
    cp b
    jp $1717


    ld b, c
    pop de
    sub $80
    or l
    ret nz

    ld a, [hl]
    ld hl, sp+$2b
    pop af
    dec bc
    ld c, h
    nop
    sbc h
    ld bc, $bc54
    cp e
    or d
    dec sp
    daa
    dec bc
    rla
    rlca
    ret nz

    inc sp
    ld e, h
    inc c
    nop
    ld d, b
    ld [c], a
    ldh [rNR44], a
    sub h
    ld [$3e04], sp
    sub l
    add sp, -$38
    ld c, $80
    call nz, $0184
    inc bc
    rla
    dec sp
    dec bc
    add b
    sbc a
    jr @+$4a

    ld [$5c53], sp

jr_004_601e:
    add d
    cpl
    ld h, $36
    ld l, d
    ld b, a
    ld b, a
    dec a
    dec d
    add b
    ld b, [hl]
    dec bc
    ld [de], a
    add d
    ret nz

    reti


    dec c
    nop
    pop bc
    ld sp, hl
    or $ca
    jp z, $a0e2

    jr @-$7e

    xor b
    ld a, b
    dec e
    rla
    dec b
    add hl, bc
    ld b, c
    ld b, l
    ld l, $81
    ld hl, $9328
    dec de
    ld e, c
    ld e, c
    rst $18
    call nc, $c7c0
    pop bc
    ld b, l
    ret nz

    dec b

jr_004_6051:
    ret nz

    ld d, c
    ret nz

    and e
    db $db
    nop
    jr nc, jr_004_6075

    dec b
    add a
    nop
    jr nc, jr_004_6068

    sbc b
    inc bc
    ld a, b
    nop
    add sp, $15
    ld l, b
    ld d, h
    ld h, h
    dec a

jr_004_6068:
    rlca
    ld b, b
    ld b, h
    cp e
    jr jr_004_6091

    ld e, $0b
    dec bc
    add hl, hl
    ld [hl-], a
    sbc c
    sub a

jr_004_6075:
    adc d
    ret nz

    ld b, c
    ld c, h
    dec c
    inc d
    jr @+$43

    ld h, c
    ldh a, [rSC]
    ld b, $12
    add b
    rst $30
    or b
    ld d, e
    or b
    ld d, a
    or $c5
    dec h
    ld b, l
    ld b, $01
    ld [hl], h
    add h
    pop bc

jr_004_6091:
    jp nz, $c2c1

    sbc h
    cp a
    dec bc
    rlca
    nop
    xor l
    ld b, c
    ld h, h
    rla
    jr jr_004_6051

    cp h
    inc b
    ld b, b
    ld [hl], $f4
    cp b
    ldh a, [$58]
    db $10
    ld e, [hl]
    cp b
    ldh a, [$d4]
    call nz, $e5dc
    ld h, l
    inc b
    add a
    ld h, c
    ldh [$af], a
    add l
    add b
    ldh a, [rHDMA3]
    jr nz, @+$26

    rrca
    ld c, a
    jp Jump_000_0255


    ld h, b
    inc e
    cp [hl]
    ld [$a8be], a
    db $f4
    ld [hl], d
    ld a, [c]
    add d
    ld a, [bc]

Call_004_60cb:
    ld [hl], a
    ld a, [bc]
    ld l, $02
    adc b
    adc b
    ld d, $84
    rlca
    pop bc
    ld l, h
    pop bc
    rla
    dec e
    dec d
    cp h
    sbc h
    sbc [hl]
    pop bc
    ld [$a2c0], sp

Call_004_60e1:
    call z, Call_004_60cb
    ld c, [hl]
    ld [bc], a
    ld h, b
    call nc, $0785
    ldh a, [rNR41]
    jr c, @+$0e

    add e
    rla
    inc b
    add c
    ld e, l
    ld bc, $02a2
    ld sp, $2f01
    ld l, $0e
    nop
    inc hl
    di
    jp nc, Jump_000_1077

    db $f4
    add l
    sbc e

jr_004_6104:
    ld bc, $ab41
    xor h
    and l
    xor l
    ld c, [hl]
    push de
    ld d, l
    ld b, e
    ld b, e
    inc b

jr_004_6110:
    sub b
    sub c
    ld [hl], b
    jr nz, jr_004_615d

    ld c, l
    or b
    ret c

    ld e, b
    inc de

jr_004_611a:
    or e
    ld d, e
    ld d, b
    jr c, jr_004_6137

jr_004_611f:
    ld hl, sp+$77
    ld bc, $b7f8
    ld d, e
    jr nc, jr_004_611f

    ld d, a
    ld [hl+], a
    ld b, c
    ld c, [hl]
    ld [$8001], sp
    xor b
    inc bc
    add l
    add e
    add l
    push bc
    ld b, l
    rst $08
    ld e, [hl]

jr_004_6137:
    ld h, h
    call Call_000_05d2
    jr nc, @+$56

    and a
    ldh [$e9], a
    jr nz, jr_004_611a

    adc h
    ld c, b
    xor e
    adc e
    adc e
    ret z

    ld [hl], c
    pop af
    ld d, a
    ld h, d
    ld h, c
    ld bc, $53b8
    jr nc, @+$53

    ld sp, $d2f3
    ld [hl], e
    ld [hl+], a
    add b
    ld c, c
    jr jr_004_616b

    db $ec
    scf

jr_004_615d:
    nop
    inc b
    dec bc
    ld a, [bc]
    rlca
    ret nz

Call_004_6163:
    cp a
    jp nz, $07c2

    jr nz, jr_004_6110

    ret nz

    ld e, b

jr_004_616b:
    add c
    ld h, b
    ret


    ld h, b
    ld [hl], c
    pop af
    rst $30
    jp nz, $0143

    ld bc, $357c
    jr c, jr_004_6104

    di
    ret c

    db $d3
    ld [hl], b
    ld a, [bc]
    ld c, c
    inc b

Jump_004_6181:
    pop bc
    cp b
    ld a, b
    ld [hl], c
    ld b, c
    ld h, d
    ld b, c
    ld hl, $3881
    ld [hl+], a
    add b
    db $76
    sbc d

jr_004_618f:
    sbc b
    jp $c3c4


    sbc [hl]
    and b
    sbc a
    sbc [hl]
    dec b
    ld a, [bc]
    add hl, bc
    ld b, $09
    ld b, c
    ld c, c
    dec b
    ld a, [bc]
    ld [de], a
    ld bc, $f23c
    dec c
    inc b
    ld b, h
    ld c, l
    dec h
    add hl, bc
    add b
    sub d
    ld d, $17
    sub c
    xor d
    ld [$787a], sp
    dec sp
    rrca
    ld de, $5503
    add hl, sp
    scf
    ld [hl], e
    ld e, a
    add hl, sp
    inc hl
    ld [bc], a
    jr c, @+$37

    ld c, b
    call $4120
    jr nz, jr_004_618f

    daa
    adc c
    cp b
    ld d, e
    ld [hl], b
    jr c, @+$2a

    add hl, hl
    xor b
    ld bc, $06e4
    ld a, [$29d9]
    sbc b
    inc d
    call nc, $dbe3
    dec sp
    sub l
    ld h, h
    ret z

    nop
    add h
    ld a, [bc]
    inc l
    and l
    db $db
    dec hl
    ld [$5a3c], sp
    inc [hl]
    or h
    adc l
    adc l
    sub l
    sub l
    push af
    ld c, h
    ld d, h
    call c, $f595
    call z, $acbc
    dec [hl]
    or h
    push hl
    inc l
    db $ed
    ld d, h
    ld [hl], l
    ld e, h

Call_004_6200:
    inc c
    ld [$48d1], a
    add b
    ld c, h
    dec b

jr_004_6207:
    add b
    or c
    ld h, d
    ld h, l
    dec l
    ld h, d
    ld a, c
    dec sp
    dec b
    ld b, c
    ccf
    ld a, e
    ld a, l
    dec sp
    rra
    rlca
    inc bc
    dec b
    ld a, c
    ld [hl], a
    dec l
    add hl, hl
    dec h
    daa
    dec sp
    dec b
    dec a
    add hl, sp
    dec [hl]
    ld [de], a
    ld a, b
    inc [hl]
    cp b
    ld l, b
    ld d, b
    jr jr_004_6246

    cp [hl]
    ld [$6ad6], a
    ld h, d
    sub [hl]
    db $76
    ld a, [bc]
    xor $ca
    ld a, [c]
    ld [bc], a
    ld [hl], $2e
    ld b, $0a
    ld c, d
    and h
    or b
    ld [$14e0], a

Jump_004_6242:
    xor a
    daa
    xor b
    ld h, a

jr_004_6246:
    and a
    jr nz, jr_004_62aa

    and c
    ldh [$ae], a
    ld b, l
    db $ec
    add hl, hl
    and a
    ld b, e
    jr z, jr_004_629d

    ld [hl], d
    ld [de], a
    jr nc, jr_004_6207

    ld [hl], c
    ld d, c
    dec d
    db $10
    ld hl, $5488
    jp z, Jump_000_29d9

    ret z

Jump_004_6262:
    reti


    xor c
    jp z, $eb09

    xor d
    ld [$3244], sp
    inc e
    or l
    db $ed
    inc d
    inc b
    inc [hl]
    inc b
    adc c
    ld a, [hl+]
    ld h, b
    ldh [rP1], a
    and b
    ld c, b
    db $10
    jr nc, jr_004_62cc

    sub b
    nop
    jr jr_004_6281

    adc b

jr_004_6281:
    ld [bc], a
    ld b, e
    xor $ab
    ld l, [hl]
    and a
    ld h, b
    ld l, d
    and b
    xor d
    dec h
    and l
    ld [bc], a
    ld [$030c], sp
    ld hl, sp+$06
    ld [hl], $04
    ld b, b
    adc b
    call $05e2
    ld hl, $2980

jr_004_629d:
    dec bc
    sub a
    ld h, [hl]
    ld c, h
    nop
    and d
    db $e3
    ld [bc], a
    ld h, e
    dec l
    inc b
    adc h
    db $e3

jr_004_62aa:
    ld h, h
    inc bc
    ret nz

    ld [hl], c
    ld bc, $70cd
    ld [hl], d
    call c, Call_000_2420
    pop hl
    ld c, [hl]
    pop bc
    ldh a, [rNR33]
    adc [hl]
    add sp, -$48
    ld h, [hl]
    ld b, b
    add $c5
    push bc
    ld b, e
    call nz, $d003
    ld a, [hl-]
    ld d, $6e
    dec de
    dec c
    inc c

jr_004_62cc:
    ld c, c
    add d
    and d
    ld b, e
    ld b, h
    rst $08
    ld bc, $65f0
    ld a, [hl-]
    ld l, $2e
    ld c, $80
    ld h, a
    ld [hl], d
    ld e, h
    and d
    and d
    add b
    jr c, @+$30

    ld d, c
    ld d, c
    ret nc

    inc sp
    di
    jp nc, Jump_004_5430

    inc [hl]
    ld a, [hl-]
    ld a, [hl+]
    jr nz, @+$18

    call c, $dc5b
    ld e, e
    jp nz, $8c10

    jp c, $dad6

    sub $8e
    ld l, d
    ld e, $06
    xor e
    jr nc, jr_004_6379

    ld a, l
    dec sp
    add hl, bc
    jp $325c


    jr nc, jr_004_6334

    dec l
    inc l
    cp [hl]
    sbc h
    xor c
    ld [$2340], sp
    adc h
    dec c
    inc b

jr_004_6314:
    rst $18
    ld h, c
    pop hl
    ld a, a
    inc c
    ld b, $be
    ret nz

    add sp, $2c
    inc c
    ld [c], a
    ld h, e
    add b
    ld [hl-], a
    ld d, $59
    rst $18
    pop bc
    db $10
    sbc $80
    cp e
    ld c, h
    db $fc
    adc a
    jp nz, $4281

    xor l
    nop

jr_004_6333:
    ld e, c

jr_004_6334:
    reti


    ret nz

    add hl, de
    inc de
    pop af
    dec b
    adc d
    sbc e
    xor h
    sub e
    adc c
    add a
    jr nc, jr_004_6314

    inc [hl]
    cp [hl]
    xor b

Jump_004_6345:
    ld hl, sp+$0e
    inc b
    ld e, a

jr_004_6349:
    ld a, [c]
    sub c
    inc hl
    sbc [hl]
    ld b, $84
    and h
    ld [hl], d
    pop hl
    jr nz, jr_004_635a

    jp nz, Jump_000_0c1a

    sub d
    dec b
    or c

jr_004_635a:
    pop af
    scf
    nop
    adc b
    sub h
    ld d, b

Jump_004_6360:
    cpl
    sub b
    inc d
    db $76
    ld a, [bc]
    ld a, [bc]
    add [hl]
    ret nc

    jr nc, jr_004_63aa

    ld a, [hl+]
    ld l, $80
    jp Jump_000_0988


    add hl, sp
    ld [c], a
    ld hl, $2800
    ld a, [$080d]
    sub [hl]

jr_004_6379:
    ld h, c
    add b
    ld d, h
    ld c, h
    ld d, b
    adc c
    adc c
    ld a, [c]
    or c
    sub b
    ld d, $06
    sub [hl]
    jp nz, $6482

    jr jr_004_6333

    cpl
    ld h, b
    ld d, e
    and d
    inc sp
    ld c, h
    ld [hl], c
    ld de, $a300
    ld [hl+], a
    ld h, a
    ld h, b
    or b
    ld [$1f03], sp
    ld [hl], c
    ld b, $0b
    ld [bc], a
    cp d
    jr nc, jr_004_63e3

    push de
    and b
    or h
    ld b, e
    nop
    ld sp, hl

jr_004_63a9:
    ld [c], a

jr_004_63aa:
    ld [hl+], a
    nop
    inc h
    ld b, h
    sbc $40
    ld d, b
    inc l
    ld b, $4a
    jp $9b83


    jr jr_004_6349

    ld a, [bc]
    inc bc
    ld d, c
    ld [hl+], a
    ld h, b
    ld h, b
    ret nz

jr_004_63c0:
    jr jr_004_63c5

    ld a, [c]
    adc l
    ld h, b

jr_004_63c5:
    ld [$9200], sp
    or b
    pop de
    dec hl
    ld d, $10
    jp nz, Jump_000_00d8

    db $10
    add hl, hl
    ld h, $78
    call nz, Call_004_5241
    jr jr_004_63a9

    cpl
    jr nc, @+$17

    ld [hl], $38
    jp Jump_000_2341


    add hl, de
    sbc b

jr_004_63e3:
    add hl, hl
    ld h, c
    ld e, d
    jr nz, jr_004_640d

    inc c
    add sp, -$29
    pop de
    ld hl, $5c08
    ld a, [hl+]
    call nz, $8786
    ld hl, $14a1
    ld c, $44
    ld a, [de]
    cp b
    dec [hl]
    ld e, b
    ld l, c
    jr nc, jr_004_6410

    adc $89
    nop
    db $10
    ld l, c
    add c
    ld [de], a
    ld e, $f0
    dec bc
    inc c
    rst $30
    ld [hl+], a
    db $d3

jr_004_640d:
    ld [c], a
    ld [hl+], a
    ld e, h

jr_004_6410:
    nop
    ld c, d
    jp nz, Jump_004_4800

    jr c, jr_004_643f

    ld [bc], a
    nop
    ld e, [hl]
    db $e4
    inc c
    db $10
    jr z, jr_004_63c0

    ld h, b
    xor d
    jr nz, jr_004_6453

    ld l, a
    db $10
    ld e, b
    ldh [$a3], a
    inc bc
    ld [hl], e
    jr c, jr_004_643e

    ld [$c59e], sp
    ld b, $59

jr_004_6431:
    cp b
    ld e, b
    add hl, hl
    or b
    sub h
    ld h, a
    jr nz, jr_004_6431

    jr z, jr_004_648b

    rst $10
    adc e
    adc e

jr_004_643e:
    nop

jr_004_643f:
    and b
    inc d
    rlca
    and [hl]
    dec c
    adc [hl]
    sub d
    dec c

jr_004_6447:
    jr @+$1a

    ld sp, hl
    ld b, $02
    or a
    ld a, [bc]
    adc d
    ld h, c
    add c
    add hl, sp
    ld l, h

jr_004_6453:
    ld [hl], h
    add [hl]
    adc l
    jp z, $5030

    ld d, h
    pop hl
    ld b, e
    inc a
    inc d
    add h
    ld bc, $3087
    ld b, b
    pop de
    jr nz, jr_004_64ad

    inc c
    ld d, h
    dec d
    nop
    ld d, [hl]
    pop hl
    nop
    and h
    ld c, e
    ld h, d
    add l
    jp hl


    ld [bc], a
    ld b, h
    ld [c], a
    dec b
    add [hl]
    jr nz, jr_004_6479

jr_004_6479:
    ld a, [bc]
    ld h, l
    ld h, l
    dec b
    ret nz

    add c
    adc b
    add e
    jp nz, Jump_000_0839

    adc d
    jp Jump_004_6242


    inc bc
    or l
    ld a, [bc]

jr_004_648b:
    ld h, [hl]
    ld [c], a
    ld b, c
    xor b
    ret nz

    ld d, h
    inc bc
    rst $20
    or b
    ld b, c
    dec d
    ld c, $6a
    ld b, e
    ld e, [hl]
    ld c, [hl]

jr_004_649b:
    ld b, c
    and c
    ld e, l
    and b
    ld c, b
    inc c
    inc a
    cp d
    inc hl
    ld e, $03
    add b
    ld h, $3c
    inc b
    adc d

jr_004_64ab:
    inc bc
    add c

jr_004_64ad:
    ret nc

    ld [c], a
    ld b, l
    ld h, b
    add h
    add l
    add l
    sbc e
    ld d, $48
    ld h, c
    cpl
    cpl
    rst $20
    ld b, b
    jr c, jr_004_64ab

    ld d, l
    ld d, a
    ld d, b
    jr jr_004_6447

    ld bc, $7104
    pop af
    dec e
    ld b, $b8
    cp d
    ret c

    dec d
    nop
    ld c, b
    pop hl
    ld h, b
    ld d, b
    db $ec
    inc c
    jr nz, jr_004_64f9

    ld h, c
    add d
    xor d
    nop
    ld l, h
    ret nz

    add c
    jr nz, jr_004_650d

    reti


    add b
    ld d, b
    ld d, h
    ld b, c
    ld e, b
    db $fc
    dec b
    ld d, $08
    rla
    dec c
    ld d, h
    dec hl
    ret nc

    db $e4
    ld [de], a
    sbc h
    and d
    ld b, d
    nop
    ld c, h
    ld b, h
    ld e, a
    ld c, [hl]

jr_004_64f8:
    add c

jr_004_64f9:
    ld h, c
    push de
    ld b, d
    nop
    ld l, b
    ld l, c
    ld d, h
    ld d, l
    jr nz, jr_004_655b

    add [hl]
    add hl, hl
    ld [hl-], a
    dec l
    ld a, [hl+]
    cp h
    add l
    ld bc, $86b5

jr_004_650d:
    ld e, e
    jr jr_004_64f8

    adc d
    scf
    db $10
    jr z, jr_004_649b

    cp a
    pop bc
    ret nz

    sbc [hl]
    add hl, hl
    ld a, [hl+]
    cp l
    sbc l
    adc b
    db $e4
    ld a, [hl+]
    inc a
    inc d
    add h
    add hl, hl
    ld a, [hl+]
    or d
    add e
    nop
    and h
    add b
    ld h, a
    ld e, b
    and d
    inc hl
    nop
    add [hl]
    ret


    ld d, a
    sbc h
    ret nz

    sbc h
    inc bc
    ld h, c
    dec a
    rst $18
    add b
    and b
    jp c, $a7a8

    ret


    dec c
    cpl
    and b
    ld bc, $cc69
    di
    ld [hl], a
    ld hl, $b3a5
    jr nz, jr_004_64f8

    add a
    dec b
    adc l
    ld a, h
    ld a, e
    sbc e
    ld e, l
    ld l, $0a
    add [hl]
    ld d, e
    and h
    add d
    or c
    inc bc

jr_004_655b:
    ld h, b
    inc sp
    pop hl
    ld c, [hl]
    ld bc, $13b2
    ld c, $e6
    jp Jump_004_6e05


jr_004_6567:
    cp e
    add c
    ld hl, $4c3e
    inc h
    sub a
    ld l, b
    xor $c1
    db $db
    ld l, b
    nop
    ld [hl], b
    xor c
    ld h, b
    inc [hl]
    db $f4
    jp nz, $5c43

    ld e, b
    ld [hl], b
    ret


    ld [hl], e
    sub a
    ld [hl], e
    rla
    ld b, e
    sub $b7
    ld d, e
    ld [hl], l
    ld d, h
    ld d, c
    inc b
    or a
    dec hl
    rrc e
    jr jr_004_65e9

    nop
    ld a, $7a
    add hl, bc

jr_004_6595:
    ld [$0575], sp
    jr nc, @+$1c

    pop af
    cp b
    ret nz

    ldh [$2c], a
    db $10
    call nz, $0a8d
    ld l, [hl]
    db $76
    ld d, h
    ld h, b
    ld [hl], h
    ld a, [bc]
    ld [hl+], a
    add b
    ld hl, sp+$64
    ld h, l
    dec b
    pop bc
    ld d, b
    cp a
    rla
    jr jr_004_6567

    cpl
    ld l, $29
    ld a, [hl+]
    cp h
    inc hl
    ld e, $0b
    ld h, b
    xor b
    adc $40

jr_004_65c1:
    or b
    sub e
    jr nc, @-$17

    add l
    cpl
    ld hl, $08c8
    ld h, e
    ld b, a
    ld [bc], a
    ld d, l
    dec sp
    dec bc
    add b
    ld c, d
    rla
    sbc h
    cp l
    cpl
    cp [hl]
    sbc h
    cp l
    ld e, $0b
    add hl, bc
    nop
    and h
    ld b, c
    ld b, [hl]
    sbc h
    add c
    and b
    and e
    nop
    ld d, b
    ld bc, $7080

jr_004_65e9:
    jr nz, @-$2d

    and [hl]
    jr nc, jr_004_6595

    daa
    and a
    xor [hl]
    ld b, c
    db $10
    ld l, c
    ld bc, $53b8
    sub b
    sub b
    ld b, b
    inc d
    db $10
    ld l, d
    inc [hl]
    db $10
    ld l, h
    or h
    jr @+$2b

    ld a, b
    ld b, c
    ld a, b
    jr nc, jr_004_6644

    add h
    xor c
    ld bc, $a520
    adc $80
    or b
    ld e, d
    ldh [$a5], a
    add c
    ld l, h
    add [hl]
    add c
    add d
    add e
    jr nz, jr_004_65c1

    bit 0, h
    dec b
    di
    ld e, $c3
    ld h, e
    or e
    ld e, a
    ld h, b
    ld c, [hl]
    rst $08
    ld e, a
    ld c, [hl]
    inc bc
    ld de, $f11c
    or b
    ld b, b
    sub b
    add hl, hl
    adc b
    or e
    ld d, e
    ld d, b
    and b
    nop
    ret nc

    sub $29
    jr c, jr_004_6688

    cp h
    ld h, h
    ld h, b
    nop
    adc b
    add h
    nop
    ld d, b

jr_004_6644:
    inc b
    ld a, c
    ld a, [bc]
    nop
    adc b
    and [hl]
    ld a, d
    ld h, d
    ld h, l
    ld h, l
    dec a
    dec c
    ret nz

    or b
    dec hl
    dec de
    dec sp
    ld b, l
    nop
    ld l, [hl]
    ld a, [de]
    ld c, $4a
    ld a, [bc]
    ld c, d
    ld a, [hl+]
    nop
    inc d
    push af
    ldh a, [$ca]
    or $ca
    ld a, [c]
    ld a, [de]
    nop
    sub b
    jr c, @+$3f

    dec b
    add e
    ld c, l
    sbc l
    ld bc, $2bc0
    ld c, [hl]
    rst $08
    add hl, hl
    rst $08
    sbc [hl]
    ld c, [hl]
    pop bc
    ld d, c
    inc b
    nop
    ld d, c
    or e
    xor h
    ld l, h
    inc l
    and a
    ld l, h
    and a
    jr nz, jr_004_6688

    db $10
    ld c, d

jr_004_6688:
    dec [hl]
    db $10
    inc c
    adc e
    sub a
    ld a, d
    sbc e
    add hl, sp
    rlca
    nop
    sub e
    ld a, [de]
    db $10
    ld a, d
    ld [$d414], a
    dec e
    inc b
    ld b, l
    inc bc
    and e
    nop
    ld [hl-], a
    jp c, $e829

    jp c, $d829

    call z, $188b
    add [hl]
    ld b, h
    ld b, a
    add b
    add d
    and e
    add c
    add d
    sbc [hl]
    ld b, $80
    pop hl
    call z, $057d
    inc h
    inc b
    adc c
    ld h, b
    xor $ab
    ld l, [hl]
    ld l, d
    and b
    ldh [rSB], a
    jr nc, jr_004_66c5

jr_004_66c5:
    inc bc
    dec c
    ld bc, $5503
    dec c
    ld [bc], a
    ld [$056f], sp
    nop
    ld [bc], a
    ld bc, $2000
    inc c
    ld [de], a
    dec a
    adc b
    jp nz, Jump_004_7889

    ld e, b
    ld [$1c00], a
    ld e, $0a
    ret z

    ld b, e
    rst $38
    ld a, b
    jr z, jr_004_6700

    inc de
    ret c

    db $e3
    ld bc, $3c98
    ld c, b
    or h
    jr nz, @+$08

    db $db
    ld h, d
    ld h, b
    or e
    jp nz, $8552

    cp b
    ld d, $f5
    ld h, c
    ld h, c
    add a
    inc l
    sub h

jr_004_6700:
    adc d
    ld de, $31ec
    nop
    inc e
    ld d, $5a
    dec hl
    ld a, b
    sub h
    adc c
    call $cb06
    ld h, e
    ld h, c
    cp c
    pop bc
    ld c, h
    add a
    ld a, [$6070]
    ld e, e
    ld h, d
    add a
    inc c
    jr nc, jr_004_6725

    cp c
    ld [de], a
    rlca
    ld h, h
    ldh [$a9], a
    inc bc

jr_004_6725:
    ld b, b
    cp b
    inc hl
    db $d3
    ld [hl-], a
    db $10
    sbc d
    jp $bf41


    ld e, b
    ld e, b
    ld l, b
    nop
    ld h, [hl]
    ld b, $c5
    ld c, b
    ld l, $01
    ld hl, $5c68
    rrca
    inc c
    call z, Call_000_2ca1
    ld e, h
    sub b

jr_004_6743:
    adc h
    ld a, [de]
    add c
    ld b, d
    ld e, d
    inc a
    xor b
    or l
    ld hl, sp-$57
    nop
    ld c, b
    ld b, $06
    sbc e
    ld [$a308], sp
    ld h, d
    jp nz, Jump_000_0c6c

    sub h
    adc c
    inc bc
    sbc b
    ld sp, $3d81
    ld b, $00
    jp Jump_004_51c0


    adc a
    xor $30
    ld [hl], b
    db $d3
    ld b, c
    adc b
    inc e
    db $e4
    inc d
    stop
    jr @-$39

    add d
    rra
    add hl, de
    ldh [$0c], a
    inc bc
    ld [de], a
    dec e
    inc b
    add $19
    dec c
    adc l
    ld b, c
    ld d, b
    ld d, $0e
    ldh [rWY], a
    ld h, b
    add h
    ld bc, $10e0
    inc hl
    jr nz, jr_004_678e

jr_004_678e:
    add h
    ld d, $81
    pop bc
    ld c, a
    inc c
    sub h
    ld h, l
    ld de, $f008
    ld b, h
    adc [hl]
    nop

jr_004_679c:
    inc e
    inc d
    ld b, d
    ldh a, [rBGP]
    xor d
    rlca
    add b
    ld [hl], b
    or c
    ld d, b
    daa
    ld h, $06
    db $db
    ld [$130c], sp
    pop hl

jr_004_67af:
    ld b, c
    sub b
    inc l
    nop
    adc c
    add a
    ld l, $32
    db $10
    ld d, h
    ld b, b
    ld [hl], $3c
    jr nc, jr_004_6743

    dec b
    ld [hl], d
    ld sp, $4000
    ld b, $d8
    ret


    jp nz, Jump_000_38e2

    add hl, de
    dec bc
    ld [hl], e
    ld [bc], a
    jp nz, $b8a4

    ld de, $8200
    ld a, [de]
    ret nc

    add h
    inc bc
    jp nc, $d030

    ld d, l
    and b
    ld e, e
    call nz, RST_08
    ld b, e
    or c
    inc b
    nop
    rst $18
    jr c, jr_004_67e9

    ld [bc], a
    sub b

jr_004_67e9:
    ld a, b
    ld h, e
    ld de, $1833
    nop
    ret


    pop bc
    ld [c], a
    jr c, jr_004_679c

    add hl, bc
    rla
    ld b, c
    dec e
    ld h, $45
    sbc h
    nop
    ld [hl], b
    ld e, [hl]
    jr nz, @+$28

    adc c
    nop
    ld b, b
    ld d, c

jr_004_6804:
    nop
    jr z, @+$2e

    ld [hl], h
    ld [hl], l
    or b
    ld l, [hl]
    daa
    jr nz, jr_004_6872

    adc l
    dec l
    ld [hl-], a
    ld a, [hl-]
    inc bc
    ld h, b
    ld [hl], c
    add hl, bc
    inc d

jr_004_6817:
    or $0d
    nop
    call nz, Call_000_0c0b
    ld b, c
    ld hl, $061b
    adc d
    ld [bc], a
    ld c, h
    add c
    add sp, $06
    ret c

    dec b
    add b
    jp nz, $b743

    jr jr_004_67af

    ld l, e
    sub c
    dec [hl]
    ld l, $16
    push bc
    jp nz, $b8b3

    jr @+$0f

    inc de
    or d
    ld h, c
    ldh [$60], a
    inc e
    ret nz

    inc d
    inc de
    jr jr_004_67e9

    call nz, Call_004_4001
    cp b
    sub b
    ld a, [bc]
    inc bc
    ld [hl], c
    ld h, d
    nop
    and h
    ld b, h
    sbc [hl]
    jr c, @+$72

    jp hl


    and l
    and l
    add l
    add l
    ld b, b
    call nc, Call_000_0384
    ld l, c
    ld sp, $5de0
    ld b, a
    jr nz, jr_004_6804

    ld a, [de]
    inc bc
    push hl

Call_004_6867:
    dec d

jr_004_6868:
    ld h, $1b
    jr c, jr_004_687f

    ld d, $01
    inc bc
    nop
    jr nz, @+$3e

jr_004_6872:
    ld [hl], h
    adc e
    dec b
    xor b
    ld c, $7a
    ld [hl+], a
    ret nz

    add l
    jr nz, jr_004_68ed

    dec bc
    inc bc

jr_004_687f:
    ld h, b
    ld h, d
    ld [bc], a
    ld d, b
    inc e
    ld d, b
    inc d
    jr nc, jr_004_6817

    inc bc
    ld b, b
    jr nc, jr_004_6868

    adc [hl]
    add e
    adc c
    ld a, [bc]
    sbc d
    ld h, d
    ld h, b
    ccf

jr_004_6894:
    inc c
    nop
    add h
    scf
    add c
    nop
    or b
    add e
    ld c, e
    ret c

    nop
    inc c
    rlca
    ld e, e
    ld h, d
    pop hl
    ld b, a
    inc l
    adc h
    adc e
    add c
    scf
    or c
    ldh a, [rHDMA3]
    ld hl, $12a6
    sbc l
    add b
    ld bc, $d411
    add b
    ld a, [hl-]
    inc c
    nop
    adc b
    ld a, [hl-]
    ld bc, $a640
    ld b, c
    ld c, e
    jr jr_004_6912

    jp z, Jump_000_0025

    ld [$e681], sp
    ld h, h
    ld [bc], a
    nop
    ld c, e
    add c
    call Call_000_3030
    add hl, de
    ld d, $c6
    push bc
    nop
    ld d, b
    inc a
    add c
    inc bc
    jr z, jr_004_68ee

    adc h
    add b
    add c
    ret nc

    ld d, h

jr_004_68e0:
    ld hl, $c0a2
    ld d, c
    ret z

    ld [$2d03], sp
    pop hl
    ld b, [hl]
    jr nz, jr_004_6944

    dec l

jr_004_68ed:
    db $10

jr_004_68ee:
    inc b
    cp [hl]
    ld b, e
    dec c
    dec c
    dec c
    ld b, $ab
    ld [bc], a
    or b
    sbc l
    ld b, a
    ld b, b
    jr jr_004_6914

    ld d, e
    ld [bc], a
    nop
    ld d, b
    daa
    ld bc, $6820
    adc h
    ld [hl], $28
    ld l, l
    and h
    ld h, d
    ld h, [hl]
    db $10
    jr c, jr_004_6894

    ld bc, $f0a0

jr_004_6912:
    ret nc

    add hl, de

jr_004_6914:
    ld [c], a
    ld a, b
    ld [$6f82], sp
    ld [hl], c
    and e
    and e
    ld h, d
    nop
    inc c
    ld [hl], l
    ld e, b
    ld [$5d0b], sp
    dec h
    add $c3
    ld b, c
    ld bc, $2000
    inc b
    dec a
    dec b
    sbc [hl]
    ld a, [bc]
    inc d
    add l
    ld bc, $3a29
    add e
    jr nz, jr_004_68e0

    add c
    ld d, e
    ld hl, sp+$10
    ld h, b
    ld [hl], c
    ld sp, $1051
    cp d
    dec de
    add h

jr_004_6944:
    add [hl]
    add c
    and [hl]
    ldh a, [$e0]
    jr nz, jr_004_6959

    sub [hl]
    jp Jump_004_5041


    add e
    xor [hl]
    ld [bc], a
    ld d, b
    pop hl
    ld [$c00f], sp
    nop
    sbc b

jr_004_6959:
    dec bc
    rrca
    ld h, $cd
    inc b
    nop
    cp b
    ld d, b
    dec h
    jr nz, jr_004_69b0

    ld d, l
    cp b
    ld a, [hl+]
    nop
    jr jr_004_69af

    dec b
    add $00
    ret z

    db $eb
    dec h
    db $10
    db $e4
    rlca
    db $10
    jr nc, jr_004_69ae

    ld a, [de]
    add hl, bc
    cp b
    ret nz

    jr nz, jr_004_697c

jr_004_697c:
    ld l, $b1
    inc b
    add d
    reti


    ld [bc], a
    call c, Call_004_60e1
    ld l, $1c
    inc b
    add l

jr_004_6989:
    adc c
    or b
    jr nz, @+$36

    inc [hl]
    ld [$4bc0], sp
    jr z, @+$05

    or e
    jp nc, $0042

    nop
    ld b, d
    add b
    ld b, b
    sub b
    ld e, l
    ld bc, $44a8
    ld d, [hl]
    add l
    sub a
    inc a
    ld [bc], a
    ld d, d
    ld b, $c5
    ld c, a
    inc c
    ld d, a
    add d
    jr nz, @-$56

jr_004_69ae:
    ld [hl], h

jr_004_69af:
    add b

jr_004_69b0:
    ld [hl], l
    ld [hl], l
    add d
    and b
    ld d, e
    add hl, bc
    ld b, [hl]
    ret nz

    nop
    jr z, jr_004_69c3

    daa
    ld [hl], $04
    nop
    ld d, a
    ld sp, $8081

jr_004_69c3:
    or h
    add c
    ld c, d
    ld a, [hl+]
    add c
    jr nz, jr_004_6989

    add c
    ld h, [hl]
    dec l
    ld bc, $a2c0
    ret nz

    ld a, l
    ld a, [hl+]
    ld bc, $b5c0
    add d
    ld [hl], h
    dec b
    and b
    ld [bc], a
    ld d, b
    dec e
    add d
    ld b, b
    ld e, a
    ld l, $00
    ld h, $37
    ld bc, $2005
    inc [hl]
    adc a
    ld b, b
    ld d, b
    ld d, $ce
    adc l
    nop
    jr nz, jr_004_6a5e

    and b
    jp nc, $1608

    call nz, Call_000_0840
    inc e
    inc [hl]
    ld e, [hl]
    ld b, $c0
    ld c, c
    dec b
    jp hl


Jump_004_6a00:
    ld [bc], a
    inc l
    ld b, [hl]
    ld b, $c0
    ld a, e
    dec b
    rst $00
    or b
    jr nz, jr_004_6a69

    ld e, h
    nop
    ld a, [bc]
    ld [bc], a
    ld e, b
    dec l
    ld a, [hl+]
    add d
    add b
    xor c
    pop bc
    ld h, h
    ld l, $01
    jr nz, @-$25

    ldh a, [$b8]
    ret nz

    ld [$48b0], sp
    ld h, c
    ld b, c
    nop
    or l
    dec b
    ld b, h
    ld [$8102], sp
    xor c
    jp hl


    ld [bc], a
    db $e3
    and l
    nop
    ld l, h
    inc d
    ldh a, [$0b]
    inc hl
    ld h, b
    call nz, $a003
    jr nz, jr_004_6a43

    ld d, $00
    inc l
    ld d, b
    sub c
    inc c
    inc c
    nop

jr_004_6a43:
    ld b, b
    ld a, [bc]
    adc e
    ld hl, $6bc8
    ret nz

    inc d
    dec bc
    set 1, e
    jr nz, @+$4a

    ld [bc], a
    dec l
    ld h, c
    ld b, c
    xor b
    inc c
    add b
    and b
    ld e, h
    ld [bc], a
    ld e, h
    ld b, $41
    ld [hl], h

jr_004_6a5e:
    dec hl
    jr nc, @+$2b

    ld a, [hl+]
    sbc a
    ld d, $86
    and b
    inc h
    adc a
    adc e

jr_004_6a69:
    add b
    ld bc, $93c0
    ld a, d
    jr nz, @+$0a

    ld c, d

jr_004_6a71:
    add e
    pop hl
    ld l, d
    db $10
    jr nz, jr_004_6aa8

    ld l, $29
    ld a, [hl+]
    add h
    jr nz, jr_004_6aa5

    ret nz

    add l
    add l
    sbc e
    ld b, [hl]
    jr nc, jr_004_6ae2

    ld d, h
    ld [$4904], sp
    cpl
    ld bc, $2e2f

jr_004_6a8c:
    add hl, hl
    ld [hl-], a
    dec l
    ld sp, $2c2c
    adc d
    add b
    add hl, hl
    or h
    sbc b
    ldh a, [rNR23]
    ld [$9dcb], sp
    and e
    xor a
    inc bc
    db $10
    ld [bc], a
    call nz, Call_000_2c02
    inc b

jr_004_6aa5:
    pop bc
    ld d, b
    inc l

jr_004_6aa8:
    ld a, [hl+]
    ld d, $03
    ld b, b
    ld h, $b4
    ld [$5304], sp
    and c
    db $e3
    and e
    nop
    ld e, b
    ld a, [bc]
    inc bc
    adc $cc
    add a
    nop
    jr c, jr_004_6ae8

    ld h, [hl]
    ld a, $1c
    jr jr_004_6a71

    ld [hl], b
    inc a
    db $10
    ld bc, $0178
    cp [hl]
    jr nc, jr_004_6a8c

    inc d
    ld a, [hl]
    ld e, d
    sub h
    rrca
    ld [bc], a

jr_004_6ad2:
    or a
    sub $d3
    push de
    rlca
    ld b, e
    ld [hl], d
    ld e, b
    db $10
    ld c, $1f
    ld a, [de]
    ld d, $06
    nop
    xor b

jr_004_6ae2:
    nop
    ld b, l
    adc b
    xor h
    inc l
    db $10

jr_004_6ae8:
    and b
    jp nz, Jump_004_5180

    ret z

    inc de
    ld [$7a8c], sp
    ld [$19e0], sp
    inc b
    ld a, [hl-]
    dec a
    inc b
    ld a, b
    sbc h
    and e
    xor e
    dec de
    add d
    adc $a6
    rst $00
    cp l
    sbc l
    add hl, bc
    add b
    ld h, b
    push hl
    add c
    pop hl
    xor h
    call nz, $1158
    nop
    ld [de], a
    rla
    jr jr_004_6b28

    ld d, $07
    nop
    dec sp
    db $e3
    ld h, h
    ld b, c
    jr nz, jr_004_6b79

    add b
    dec hl
    rst $20
    rst $20
    jp c, $0224

    ld h, b
    inc b
    adc [hl]
    ret nz

    ld c, b
    add e

jr_004_6b28:
    adc [hl]
    jp nc, Jump_000_05d7

    jp nz, $d34f

    db $e4
    sbc $e1
    ret nc

    rst $08
    sbc a
    ld d, $53
    add hl, bc
    ld h, b
    add hl, hl
    inc [hl]
    ld d, a
    inc d
    db $10
    jr c, jr_004_6ad2

    nop
    cp b
    cp b
    ld hl, $de00
    add hl, de
    rra
    dec bc
    add d
    di
    cp h
    inc bc
    ret nz

    ld h, a
    db $e4
    ld bc, $b040
    xor c
    inc h
    add c
    ld [hl], c
    inc b
    nop
    ld [$af84], sp
    call z, $042d
    add d
    ld h, a
    ret nc

    reti


    xor h
    ld d, $01
    or l
    ld a, $3d
    or l
    ld c, c
    and $16
    ld d, $53
    ld b, l
    ld bc, $453e
    ld [de], a
    add hl, bc
    add [hl]
    ld [$c0a8], a

jr_004_6b79:
    xor b
    ld h, $08
    ld b, h
    dec b
    add d
    dec bc
    rrca
    nop
    ld b, c
    dec a
    rlca
    add d
    sub h
    ld [bc], a
    add d
    ld a, [de]
    adc e
    add d
    ld a, [de]
    ld a, e
    ld [bc], a
    sub d
    ld [de], a
    ld b, c
    ld e, b
    dec a
    ld d, $90
    db $d3
    pop hl
    db $dd
    db $e4
    pop hl
    rst $18
    add hl, bc
    ret nz

    xor h
    ret nz

    ld d, d
    ld bc, $02c5
    ld [bc], a
    and h
    ld b, l
    nop
    and h
    ld b, l
    add hl, sp
    ret nz

    ld hl, $ea00
    ld h, d
    ld a, [hl-]
    sbc h
    db $fc
    cp e
    nop
    sbc b
    dec d
    ret nc

    xor c
    sbc e
    inc e
    inc e
    ld a, [hl-]
    ei
    pop de
    ld h, d
    ld a, [hl+]
    nop
    jp nc, $d1f1

    jp nz, Jump_000_31f1

    ret nz

    ld h, d
    jp z, $c7a7

    jp nz, $d202

    ld [hl], c
    jp c, $235b

    ld bc, $dd51
    db $e3
    adc $03
    ld b, c
    dec h
    and $66
    ld d, l
    ld d, [hl]
    ld d, l
    sub $00
    ld d, l
    ld d, [hl]
    ret z

    ld a, [c]
    dec b
    stop
    inc b
    ld c, l
    rrca
    add b
    add b
    inc a
    nop
    db $f4
    call nc, Call_000_2e3d
    nop
    ld [hl-], a
    ld [$6686], a

jr_004_6bfa:
    ld l, [hl]
    or [hl]
    ld [$3c70], sp
    nop
    ld b, e
    ld h, b
    inc hl
    ld l, c
    dec bc
    dec bc
    adc e
    ld l, b
    ld l, c
    rst $00
    rst $00
    jp hl


    ld l, b
    jp hl


    ldh a, [rSVBK]
    ld l, [hl]
    ld l, a
    ld [hl], d
    ld a, [c]
    pop af
    ld [hl], b
    ld a, [c]

jr_004_6c17:
    ld [hl], b
    ld [hl], d
    ldh a, [$8b]
    nop
    rra
    dec l
    cpl
    adc e
    ld c, e
    ld e, e
    xor b
    or d
    sub [hl]
    inc bc
    inc b
    ld b, l
    ld c, e
    ld c, a
    add a
    ld b, a
    ld c, e
    sub e
    ld b, a
    inc b
    jr z, jr_004_6bfa

    jp $a9a7


    ret


    pop bc
    and e
    and l
    sbc l
    sub a
    push bc
    push bc
    add hl, de
    ld [bc], a
    ld [$04c4], sp
    add b
    ld b, b
    ld a, $3b
    add hl, bc
    ld b, d
    ld l, d
    sbc b
    ret z

    add hl, bc
    rlca
    inc h
    dec c
    ld c, d
    ld a, [de]
    call c, $8d86
    sub b
    ld [bc], a
    add c
    and a
    nop
    ldh a, [$d8]
    add hl, de
    jr nz, jr_004_6ccc

    jp nz, Jump_004_4707

    dec bc
    dec b
    ld sp, $4413
    ret z

    call nz, $cc81
    cp b
    nop
    ld [de], a
    dec de
    jp nz, Jump_000_0162

    and e
    ld bc, $1147
    dec b
    or c
    ld de, $2628
    ld a, [$486b]
    add h
    adc l
    sub h
    ld sp, $4c00
    ld d, $5e
    push bc
    ld [bc], a
    ld c, h
    add l
    ld e, l
    ld [hl-], a
    jr nz, @+$72

    jr z, jr_004_6c17

    add c
    cp e
    ld a, [bc]
    dec de
    db $e4
    add b
    jr nz, jr_004_6cc3

    cp b
    add [hl]
    inc bc

jr_004_6c9a:
    add hl, hl
    ld [hl], c
    pop de
    ld e, [hl]
    and b
    ld d, e
    inc e
    nop
    add h
    add a
    sub c
    ret nc

    jr nc, jr_004_6cd8

    ld [hl], h
    sub b
    dec b
    ret nz

    ldh a, [$a1]
    jr nz, jr_004_6c9a

    ld a, [hl]
    add d
    ld c, $02
    db $76
    pop af
    ldh a, [$29]
    ld b, $c4
    push bc
    db $dd
    dec hl
    pop bc
    add b
    ret c

    inc hl
    and h
    nop

jr_004_6cc3:
    nop
    dec hl
    inc [hl]
    jr nc, jr_004_6cc8

jr_004_6cc8:
    add h
    ld bc, $068e

jr_004_6ccc:
    cp b
    ld h, d
    and c
    ld [hl], b
    inc a
    nop
    adc c
    rlca

Call_004_6cd4:
    dec b
    ld [hl], c
    and b
    ld e, h

jr_004_6cd8:
    ret nz

    jr c, @-$32

    or l
    add sp, $14
    inc bc
    inc a
    ld l, c
    rlca
    ld [bc], a
    ld h, d
    add e
    and b
    jr nc, jr_004_6ce9

    db $10

jr_004_6ce9:
    ld h, $46
    jp nz, Jump_004_7543

    inc bc
    ld d, d
    ld sp, $21c0
    ld a, [de]
    ld b, $04
    ld d, $f1
    ld a, [c]
    ld b, a
    ld d, $b4
    jp nz, Jump_000_15e2

    db $10
    ld [hl], e
    ld h, e
    ld h, e
    ld b, b
    jr z, jr_004_6d1f

    inc bc
    ld b, h
    dec d
    nop
    jp nz, $8f84

    jr jr_004_6d29

    ld [$43b6], sp
    rst $00
    nop
    ldh [$da], a
    add d
    ld b, l
    ld e, h
    inc e
    adc e
    add l
    or d
    ld b, $5a

jr_004_6d1f:
    dec c
    nop
    ld b, l
    pop de
    ld b, b
    nop
    ld d, h
    ldh [$ac], a
    add h

jr_004_6d29:
    ld d, h
    adc c
    adc d
    add d
    and b
    jr z, jr_004_6d3c

    adc l
    rlca
    rra
    ld [hl-], a
    jr nz, jr_004_6da6

    call z, $a084
    ld bc, $58e1

jr_004_6d3c:
    inc c
    ld hl, sp+$14
    and b
    jr nz, jr_004_6d45

    ei
    ld h, d
    nop

jr_004_6d45:
    ld h, b
    inc e
    inc d
    adc d
    rlca
    ccf
    ld sp, $5292
    db $10
    db $e4
    add l
    adc b
    ld d, a
    sbc [hl]
    inc bc
    ld b, c
    ld a, $2c
    inc c
    adc l
    inc bc
    adc c
    jr nc, @-$1e

    ld a, [hl-]
    ld h, $02
    ret


    ret nz

    ld [hl], c
    add c
    push de
    jr nc, jr_004_6d88

    db $10
    ld a, [hl]
    db $76
    ld a, [bc]
    ld [bc], a
    and b
    ld [bc], a
    pop hl
    ld h, c
    nop
    ld h, b
    inc c
    cp b
    ld d, l
    ldh a, [rBCPD]
    ld [hl], b
    sub $41
    ld e, d
    inc e
    inc d
    add [hl]
    rlca
    ld b, c
    ld [hl-], a
    jr nz, jr_004_6dcc

    add h
    and e
    ld d, a
    sbc h

jr_004_6d88:
    sbc [hl]
    inc b
    pop bc
    cp e
    ret nz

    ld [hl], c
    ld bc, $7abe
    inc bc
    ld bc, $d842
    ld [$031b], sp
    ld d, d
    pop hl
    add c
    ld l, b
    inc l
    ld c, $00
    ld b, d
    ld b, l
    add b
    ld a, [de]
    ld [$c9c8], sp

jr_004_6da6:
    ld [bc], a
    ld [bc], a
    xor b
    jp $3864


    ld d, b
    ld l, [hl]
    or b
    dec d
    ld [hl], $40
    ld a, [bc]
    and h
    ld d, l
    nop
    ld d, $03
    ld b, h
    ld h, e
    nop
    ld e, e
    inc a
    ld [$0135], sp
    ld a, [bc]
    rrca
    db $fc
    ld [c], a
    pop bc
    dec h
    ld c, h
    ld b, b
    add [hl]
    sbc h
    sbc l
    ld [bc], a

jr_004_6dcc:
    ld b, d
    inc sp
    inc l
    nop
    add a
    ld bc, $2027
    nop
    ld a, h
    ld d, l
    jr nz, jr_004_6df3

    inc bc
    ret c

    ld [c], a
    ld hl, $1c6b
    ld c, b
    adc h
    dec bc
    xor a
    ld [hl], b
    pop hl
    ld [de], a
    ld c, $12
    jp Jump_004_5c42


    add sp, -$08
    jr z, jr_004_6e0f

    inc l
    jp Jump_004_70c2


jr_004_6df3:
    add c
    db $dd
    ld [bc], a
    ld [bc], a
    ret nz

    ld l, [hl]
    add c
    adc c
    ld b, $7e
    ld h, c
    ld b, b
    xor d

Call_004_6e00:
    add d
    ld d, h
    ret c

    jr jr_004_6e1d

Jump_004_6e05:
    add $c5
    jp nz, Jump_004_584c

    jr nz, jr_004_6e37

    nop
    sub d
    or [hl]

jr_004_6e0f:
    sub c
    db $10
    inc l
    add l
    push bc
    adc h
    sbc e
    cp d
    sub h
    sub e
    add [hl]
    pop bc
    cpl
    inc c

jr_004_6e1d:
    jr z, @-$79

    xor l
    db $10
    xor e
    inc d
    db $f4
    or e
    sub e
    inc de
    db $f4
    nop
    inc d
    add [hl]
    add hl, bc
    or a
    db $10
    pop de
    ld [$1070], a
    call z, $8185
    pop de

jr_004_6e36:
    ld [bc], a

jr_004_6e37:
    push bc
    pop hl
    ld [hl], $0c
    cp b
    add a
    add e
    xor a
    ld [hl], b
    jr nc, jr_004_6ea1

    ret nz

    xor e
    jp nz, $0371

    cp h
    ld a, [bc]
    ld b, $61
    ld b, b
    and b
    ld [hl], c

jr_004_6e4e:
    dec bc
    add hl, sp
    inc bc
    inc b
    ld bc, $0745
    adc c
    ld [hl], h
    add hl, hl
    ld b, c
    ld [hl], l
    ld [hl], l
    dec bc
    add b
    ld c, e
    ld a, b
    jr jr_004_6ecc

    ret nc

    ld e, [hl]
    ld b, c
    ld b, l
    inc e
    call nz, $9f85
    sbc [hl]
    ld [bc], a
    nop
    ld c, b
    inc e
    sub b
    adc b
    add hl, de
    or a
    jr nc, @+$24

    ld d, c
    ld b, b
    scf
    inc a
    ret c

    ld d, $01
    ld c, $13
    dec d
    dec b
    add e
    ld d, c
    ld e, b
    ld b, b
    ld l, a
    ldh [$59], a
    ld b, b
    add b
    db $10
    ld [$6e13], sp
    pop hl
    ld b, h
    and d
    inc bc
    ld h, a
    jr c, @-$1e

    ld a, [bc]
    rlca
    call nz, $e961
    inc c
    inc b
    ld b, [hl]
    and c
    db $e3
    and e
    ld b, b
    jr c, jr_004_6e4e

jr_004_6ea1:
    db $10
    ld a, [de]
    ld h, $00
    jp nz, Jump_004_6345

    ld bc, $30e5
    ld [hl+], a
    ld d, c
    nop
    add hl, de
    ld e, h
    inc d
    db $10
    jr nz, jr_004_6e36

    dec sp
    ret z

    and $18
    nop
    ld b, b
    dec de
    ret nz

    add a
    add l
    add a
    db $10
    jr nz, @+$42

Jump_004_6ec2:
    ld c, b
    add a
    add e
    add $0e
    nop
    ld hl, $e040
    sub b

jr_004_6ecc:
    xor b
    sub b
    ld e, h
    nop
    and h
    add b
    ld b, b
    ld de, $e79c
    and a
    jr nz, @+$4a

    ld a, $03
    ld b, b
    ld bc, $0940
    ld a, [hl-]
    db $10
    inc a
    db $db
    cp l
    ld [de], a
    ld [$1967], sp
    ld b, $02
    ret z

jr_004_6eeb:
    inc a
    inc bc
    ld b, b
    ld h, d
    add [hl]
    ld bc, $2000
    ld a, h
    ld c, b
    inc d
    jr nz, jr_004_6f62

    ld [hl], b
    ld e, b
    ld b, b
    nop
    sbc b
    jr z, jr_004_6f70

    db $10
    ld a, [hl-]
    ld a, $0a
    ld b, $ff

jr_004_6f05:
    ld b, h
    inc bc
    ld bc, $0170
    and b
    ld b, h
    inc bc
    inc b
    nop
    ld sp, $0e40
    add hl, sp
    ld [hl], c
    db $76
    or [hl]

jr_004_6f16:
    ld a, [hl-]
    ld [de], a
    nop
    adc c
    ld l, b
    inc bc
    jp nz, $8d5d

    ld bc, $b4a1
    ld b, b
    ld b, c
    jr jr_004_6f16

    jr z, jr_004_6f30

jr_004_6f28:
    adc b
    ld b, d
    ld sp, $2020
    ccf
    dec a
    rlca

jr_004_6f30:
    pop bc
    ld e, h
    jr jr_004_6f8c

    ret


    scf
    nop
    nop
    dec d
    ld [$2212], sp
    ld [c], a
    ret nz

    xor l
    add b
    ld c, [hl]

Jump_004_6f41:
    ld e, b
    add a
    ld [bc], a
    ld h, b
    jr nc, jr_004_6eeb

    inc b
    dec e
    nop
    ld [hl], e

jr_004_6f4b:
    ld a, l
    add [hl]
    add [hl]
    add [hl]
    ld a, d
    ld [hl], $26
    ld b, $7c
    ld h, $8c
    inc h
    ld b, b
    inc c
    inc c
    adc $4e
    adc $4e
    jp nz, $52b0

    add b

jr_004_6f62:
    db $e3
    ld [hl+], a
    inc hl
    ld hl, $0208
    rst $00
    dec b
    db $e4
    ld l, d
    add h
    and h
    and l
    dec c

jr_004_6f70:
    ld hl, sp-$14
    call c, Call_000_14dc
    ld d, l
    inc b
    ld b, b
    dec e
    jr nc, jr_004_6f05

    inc b
    ld [$2018], sp
    ld b, c
    jp Jump_000_02a6


    ld c, [hl]
    adc c
    adc c
    ld bc, $8490
    ret nz

    cp h
    ld b, b

jr_004_6f8c:
    ld c, d
    sub b
    sbc a
    and c
    sbc [hl]
    sub h
    sub e
    and b
    sub h
    and h
    ld d, a
    adc d
    ld h, d
    ld [hl+], a
    rst $18
    ld c, l
    ld bc, $5181
    ld b, b
    nop
    db $10
    ld a, [hl+]
    ld bc, $80d4
    jr c, jr_004_6f28

    ld [hl], l
    ret nz

    adc c
    ld [hl], $40
    db $10
    xor b
    add a
    ld a, [de]
    nop
    ld d, d
    ld a, [hl+]
    ld h, [hl]
    inc d
    nop
    add h
    ld l, a
    jr nz, jr_004_6f4b

    ld l, h
    db $10
    inc b
    and [hl]
    ld a, [bc]
    call z, $acd5
    ld l, d
    inc a
    ld [$0a4c], sp
    ld [$2500], sp
    dec e
    add d
    call $4040
    inc c
    ret nz

    ld e, d
    ld b, l
    dec c
    inc d
    xor h
    inc b
    nop
    nop
    ld b, b
    nop
    ld a, [c]
    ld de, $bb0b
    and [hl]
    ld [de], a
    add d
    sub h
    ld [bc], a
    dec e
    or l
    ld a, [$3ab6]
    ld a, $06
    inc l
    ld [hl-], a
    ld a, [hl-]
    ld a, $2a
    add b
    xor c
    ld d, [hl]
    ld d, l
    adc l
    add c
    sub a
    ld e, l
    ld e, e
    rrca
    add b
    ld c, c
    ld bc, $4001
    xor b
    ld b, l
    add $cd
    ld c, l
    rst $00
    rst $00
    push bc
    inc bc
    ret nc

    and b
    xor [hl]
    ld a, [bc]
    add b
    xor h
    add b
    inc bc
    add c
    ld a, d
    and a
    xor b
    xor e
    inc bc
    ld b, c
    ld a, $da
    ld d, a
    ld bc, $52b0
    add b
    and e
    ld b, b
    ld b, a
    adc a
    sub b
    nop
    ld bc, $8d00
    sub b
    add a
    add b
    ld a, [hl+]
    sub $63
    ld bc, $51a0
    ld h, l
    jr nz, @+$32

    ld l, $20
    db $10
    ld [$98d5], sp
    xor b
    ld [$0009], sp
    sub b
    sbc e
    db $eb
    sbc d
    jp z, $09ba

    db $db
    nop
    add $1a
    sub b
    sub h
    jp z, $598a

    ld l, b
    ld e, c
    ld l, c
    nop
    sub b
    inc hl
    inc d
    ld e, $1e
    nop
    ld e, [hl]
    dec c
    add h
    ld d, e
    push de
    nop
    ld d, l
    db $e3
    ld d, e
    ld d, l
    ld h, e
    sub $d6
    ld h, e
    ld h, l
    call z, $c006
    pop de
    and b
    and l
    nop

Jump_004_706e:
    ld d, a
    ld bc, $1420
    ld a, [hl+]
    nop
    ret nz

    xor d
    ld [$e029], a

jr_004_7079:
    ld b, c
    ld d, b
    ld a, [hl+]
    jr nc, jr_004_70d4

    add d
    inc h
    call z, $cc42
    ld c, e
    add d
    jr nz, @+$16

    or c
    ld [hl], b
    db $ec
    dec hl
    ld b, c
    jr c, jr_004_70f0

    inc bc
    ld e, h
    rlca
    nop
    inc bc
    sbc e
    ei
    dec de
    ld c, h
    nop
    and [hl]
    ld a, [hl+]
    jr @+$17

    or b
    jr z, jr_004_709f

jr_004_709f:
    ld d, h
    ld [$2aa9], a
    ld l, e
    ld l, e
    xor e
    ld b, c
    ld l, b
    dec hl
    jr nz, jr_004_7100

    add c
    xor c
    add b
    ld e, d
    sub [hl]
    ld bc, $ac60
    ld b, e
    ld d, l
    cp b
    add b

jr_004_70b7:
    ld [bc], a
    ldh [$90], a
    xor l
    and l
    or l
    xor h

jr_004_70be:
    and h
    or l
    xor l
    sub l

Jump_004_70c2:
    and l
    or l
    cp h
    dec l
    inc l
    ld [hl], h
    inc b
    ld d, $d9
    and $d6
    ld c, $00
    adc e
    ld c, $41
    xor e
    dec h

jr_004_70d4:
    ldh [rP1], a

jr_004_70d6:
    ld b, b
    ld [bc], a
    call nz, Call_000_0065
    sub b
    jr z, jr_004_713e

    inc b
    ld [de], a
    call z, $cbc2
    ld c, e
    ld b, d
    sub b
    ld d, c
    ld h, l
    nop
    add b
    jr z, @+$35

    nop
    inc c
    add c
    ld [hl+], a

jr_004_70f0:
    inc sp
    nop
    jr nc, jr_004_7079

    add b
    ld [bc], a
    ld hl, $b428
    inc d
    inc b
    ld bc, $e560
    push hl
    ld b, b

jr_004_7100:
    db $10
    ld l, d
    ld l, l
    ld sp, $090b
    ld [c], a
    ld bc, $0175
    nop
    inc c
    ld a, [bc]
    ld b, c
    add d
    ld de, $08d2
    ret nz

    jr nz, jr_004_70b7

    adc e
    ld a, [de]
    adc h
    ld b, [hl]
    nop
    ld [$6110], sp

jr_004_711d:
    db $e4
    ldh a, [rNR41]
    nop
    jr nc, jr_004_70be

    inc b
    dec c
    xor l
    sub d
    ld b, d
    ld b, h
    ld b, $42
    jr nc, jr_004_70d6

    adc b
    jp nz, Jump_004_6262

    nop
    call nz, $91e4
    or c
    ld sp, $8238
    nop
    ld d, a
    ld d, $18
    dec d

jr_004_713e:
    rla
    ld c, b
    ld c, d
    ld b, $60
    and d
    ret nz

    ld h, c
    add hl, de
    inc [hl]
    nop
    nop
    inc b
    ld [c], a
    and d
    ld b, b
    ld d, c
    ld b, d
    ld c, d
    ld c, c
    add e
    ld h, b
    ld [$a550], sp
    pop bc
    ld hl, $3200
    ld a, [hl+]
    ld e, h
    inc b
    ld de, $a421
    inc h
    inc h
    call nz, $8042
    nop
    ld e, b
    ld d, e
    ld a, [bc]
    nop
    ld e, e
    add hl, de
    ld a, c
    ld [hl], h
    inc c
    inc b
    add h
    ret nc

    ld h, d
    ld b, d
    nop
    ld e, h
    add h
    add h
    and d
    jr nc, jr_004_711d

    call nz, Call_000_3042
    ld [hl], h
    ld h, h
    sub h
    inc h
    call nz, Call_004_6200
    ld [bc], a
    nop
    adc b
    sub c
    ld hl, $4700
    ld b, b
    inc l
    adc l
    adc e
    inc h
    ld [hl+], a
    adc a
    inc b
    add e
    inc bc
    jr nz, jr_004_71f5

    ld [de], a
    ld d, d
    adc b
    ld [$8000], sp
    call z, $020c
    ld [$2509], sp
    nop
    db $10
    ld d, a
    inc h
    ld b, h
    inc h
    db $e4
    ld sp, $9491
    and h
    add h
    sub h
    ld h, h
    db $f4
    ld bc, $1102
    ld b, c
    and h
    sub h
    ld [hl], h
    and h
    pop bc
    add c
    ld sp, $9481
    ld [hl], h
    add h
    inc h
    sub h
    add h
    ld [de], a
    ld h, b
    ld h, b
    add h
    ld h, h
    inc d
    ld [hl+], a
    jp nc, $8480

    ld [de], a
    and b
    daa
    and l
    inc h
    and d
    ld bc, $2010
    dec b
    ld [bc], a
    sub l
    inc a
    jr nc, jr_004_7205

    adc h
    adc d
    sub b
    sub b
    ld b, [hl]
    ld a, [de]
    sub d
    adc h
    ld d, b
    inc b
    ld [$1e8c], sp
    ret nz

    ld c, h
    ld bc, $02a1
    ld a, [hl+]
    dec b
    ld d, [hl]
    cp d

jr_004_71f5:
    ld d, c
    ld sp, $0018
    jr jr_004_7218

    ld hl, $587d
    ld c, h
    jr @-$21

    ld hl, sp-$48
    jr jr_004_7226

jr_004_7205:
    dec l
    add b
    sub l
    add [hl]
    ld [bc], a
    ret nz

    ld c, a
    ld [hl], $1c
    inc de
    ld b, [hl]
    inc hl
    dec c
    ld c, d
    ld c, c
    ld [hl], $17
    ld c, b
    ld b, l

jr_004_7218:
    ld hl, $114e
    ld c, b
    ld b, a
    ld b, [hl]
    ld b, [hl]
    ld c, c
    ld b, [hl]
    ld c, b
    scf
    ld a, $04
    ld b, [hl]

jr_004_7226:
    ld c, c
    ld c, c
    inc hl
    rlca
    ld b, $49
    ld c, d
    ld b, [hl]
    ld b, [hl]
    ld b, a
    ld c, b
    ld c, c
    ld b, d
    ld b, d
    ld c, d
    ld b, [hl]
    ld c, b
    ld c, h
    ld c, e
    ld b, $36
    ld c, l
    inc de
    ld c, c
    ld b, d
    inc sp
    ld bc, $3a2e
    jr nc, jr_004_7275

    ld c, d
    ld a, [hl+]

Jump_004_7247:
    ld [hl-], a
    ld [hl-], a
    nop
    jp z, $9250

    sub d
    sub d
    ld b, [hl]
    ret nc

    add l
    sub c
    ld de, $1252
    ld a, [bc]
    inc hl
    cp b
    add sp, $40
    add b
    ld b, b
    jp hl


    add hl, bc
    adc d
    ld b, l
    dec h
    jr nz, jr_004_72a4

    add b
    ldh [$c8], a
    ld [$0849], sp
    adc c
    ld b, l
    dec h
    add l
    ld [hl+], a
    ld b, b
    jr nc, jr_004_72ba

    ld [de], a
    bit 0, b

jr_004_7275:
    add c
    jr nz, jr_004_7280

    ld [bc], a
    ld e, d
    ld d, [hl]
    nop
    nop
    nop
    inc c
    inc [hl]

jr_004_7280:
    nop
    ld l, $00
    nop
    add l
    ld [bc], a
    sbc [hl]
    add l
    add l
    dec bc
    adc h
    nop
    rrca
    xor l
    ld l, $2e
    sub c
    add l
    dec b
    and d
    adc e
    nop
    add l
    add h
    ld a, [de]
    add l
    ld b, [hl]
    ld [bc], a
    add d
    ld b, [hl]
    add d
    add b
    add $9e
    xor c
    ld b, [hl]

jr_004_72a4:
    sub b
    inc b
    add $63
    add b
    db $e3
    and e
    and a
    and e
    pop bc
    ld [$0312], sp
    ld [bc], a
    inc b
    ld b, $08
    ld a, [bc]
    inc d
    ld d, $18
    ld a, [de]

jr_004_72ba:
    inc c
    ld c, $08
    ld a, [bc]
    inc e
    ld e, $20
    ld [hl+], a
    ld [bc], a
    db $10
    ld [$240a], sp
    ld h, $28
    ld [hl+], a
    ld [bc], a
    ld [de], a
    ld [$2a0a], sp
    inc l
    ld l, $30
    ld [bc], a
    ld [$0c0a], sp
    jr jr_004_72f2

    inc e
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld [bc], a
    ld c, $10
    ld e, $20
    ld [bc], a
    ld [bc], a
    ld b, $02
    ld [bc], a
    ld [bc], a
    ld [de], a
    inc d
    ld d, $22
    inc h
    ld h, $02
    ld [bc], a
    jr z, jr_004_731c

jr_004_72f2:
    inc c
    jr jr_004_7329

    inc e
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld [bc], a
    inc l
    ld l, $1e
    ld [hl], $02
    ld [bc], a
    ld b, $02
    ld [bc], a
    ld [bc], a
    jr nc, @+$34

    ld d, $22
    jr c, jr_004_7345

    ld [bc], a
    ld a, [bc]
    inc c
    ld c, $02
    ld [bc], a
    jr nz, jr_004_7335

    inc h
    ld a, [bc]
    db $10
    ld [de], a
    ld [bc], a
    ld [bc], a
    jr nz, jr_004_733d

    inc h

jr_004_731c:
    ld [bc], a
    inc b
    ld b, $08
    ld [bc], a
    inc d
    ld d, $18
    jr nz, jr_004_734c

    jr z, jr_004_732a

    ld [bc], a

jr_004_7329:
    ld [bc], a

jr_004_732a:
    ld a, [de]
    inc e
    ld e, $2a
    inc l
    ld l, $02
    ld [bc], a
    inc b
    ld [bc], a
    ld [bc], a

jr_004_7335:
    ld [bc], a
    ld b, $0c
    ld c, $10
    ld [de], a
    inc d
    ld [bc], a

jr_004_733d:
    ld a, [hl+]
    inc l
    ld l, $02
    ld [$0202], sp
    ld [bc], a

jr_004_7345:
    ld a, [bc]
    ld d, $18
    ld a, [de]
    inc e
    ld e, $02

jr_004_734c:
    jr nc, @+$34

    inc [hl]
    ld [bc], a
    jr nz, jr_004_7374

    inc h
    ld h, $28
    ld [bc], a
    jr nc, jr_004_738e

    jr c, @+$04

    inc b
    ld b, $08
    ld a, [bc]
    ld [bc], a
    inc d
    ld d, $18
    ld a, [de]
    inc e
    inc c
    ld c, $10
    ld [de], a
    ld [bc], a
    ld e, $20
    jr jr_004_738f

    inc h
    ld h, $28
    ld a, [hl+]
    inc l
    ld l, $02

jr_004_7374:
    ld a, [hl-]
    jr jr_004_73b3

    ld [bc], a
    jr nc, @+$34

    inc [hl]
    ld [hl], $38
    ld [bc], a
    ld a, [hl-]
    jr jr_004_73bf

    ld [bc], a
    ld a, [hl-]
    inc a
    ld a, $40
    ld b, d
    ld [bc], a
    jr nc, jr_004_73bc

    ld b, h
    ld [bc], a
    ld [bc], a
    ld a, [bc]

jr_004_738e:
    inc c

jr_004_738f:
    ld c, $14
    ld d, $02
    ld [bc], a
    db $10
    ld [de], a
    jr jr_004_73b2

    inc e
    ld e, $04
    ld b, $08
    ld a, [bc]
    ld [bc], a
    ld h, $28
    ld [bc], a
    inc c
    ld c, $10
    ld [de], a
    ld [bc], a
    ld a, [hl+]
    inc l
    ld [bc], a
    inc d
    ld d, $18
    ld a, [de]
    inc e
    ld [bc], a
    ld l, $30

jr_004_73b2:
    ld [hl-], a

jr_004_73b3:
    ld [bc], a
    ld e, $20
    ld [hl+], a
    inc h
    inc [hl]
    ld [hl], $38
    ld a, [hl-]

jr_004_73bc:
    inc c
    ld c, $10

jr_004_73bf:
    ld [de], a
    ld [bc], a
    inc e
    ld e, $02
    inc b
    ld b, $02
    ld [bc], a
    inc d
    ld d, $18
    ld a, [de]
    ld [bc], a
    ld [bc], a
    ld [$140a], sp
    inc e
    ld e, $20
    ld [bc], a
    inc d
    ld d, $18
    ld a, [de]
    inc e
    ld e, $20
    ld [bc], a
    ld [bc], a
    inc b
    inc c
    ld b, $0e
    ld [$0a10], sp
    ld [de], a
    ld b, $08
    ld a, [bc]
    ld a, [de]
    ld [bc], a
    ld [bc], a
    inc b
    ld b, $08
    ld a, [bc]
    jr jr_004_740c

    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld b, $08
    ld a, [bc]
    inc e
    ld e, $1a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld b, $08
    ld a, [bc]
    inc d
    ld d, $18
    ld a, [de]
    ld [bc], a
    ld [bc], a
    ld [hl+], a
    ld [bc], a

jr_004_740c:
    jr z, jr_004_7438

    jr nz, jr_004_7432

    ld [bc], a
    ld h, $28
    ld a, [hl+]
    jr c, jr_004_7418

    ld [bc], a
    ld [bc], a

jr_004_7418:
    jr nz, jr_004_743c

    ld [bc], a
    ld a, $26
    jr z, jr_004_7449

    ld b, b
    jr c, jr_004_7424

    ld [bc], a
    ld [bc], a

jr_004_7424:
    jr nz, jr_004_7448

    ld [bc], a
    inc l
    ld l, $30
    ld [hl-], a
    ld [bc], a
    jr nz, jr_004_7450

    ld [bc], a
    inc h
    ld h, $28

jr_004_7432:
    ld a, [hl+]
    ld [bc], a
    jr nz, jr_004_7458

    ld [bc], a
    inc h

jr_004_7438:
    ld h, $28
    ld a, [hl+]
    ld a, [hl-]

jr_004_743c:
    inc a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    jr nz, jr_004_7465

    ld [bc], a
    ld [bc], a
    inc h
    ld h, $28

jr_004_7448:
    ld a, [hl+]

jr_004_7449:
    inc [hl]
    ld [hl], $38
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [hl+], a

jr_004_7450:
    inc h
    ld h, $28
    ld [hl-], a
    inc [hl]
    ld [hl], $38
    ld a, [hl-]

jr_004_7458:
    ld [bc], a
    ld [hl+], a
    inc h
    ld a, [hl+]
    inc l
    ld [hl-], a
    inc [hl]
    ld [hl], $38
    ld a, [hl-]
    ld [bc], a
    ld [hl+], a
    inc h

jr_004_7465:
    ld l, $30
    ld [hl-], a
    inc [hl]
    ld [hl], $38
    ld a, [hl-]
    ld [hl+], a
    inc h
    ld h, $28
    inc [hl]
    ld [hl], $38
    ld a, [hl-]
    ld [hl+], a
    inc h
    ld a, [hl+]
    inc l
    inc [hl]
    ld [hl], $38
    ld a, [hl-]
    ld [hl+], a
    inc h
    ld l, $30
    inc [hl]
    ld [hl], $38
    ld a, [hl-]
    ld [bc], a
    inc b
    ld b, $02
    inc c
    ld c, $10
    ld [de], a
    ld [bc], a
    ld [$020a], sp
    inc c
    inc d
    ld d, $12
    inc c
    jr @+$1c

    ld [de], a
    inc e
    inc h
    ld h, $22
    inc e
    inc l
    ld l, $22
    inc c
    jr nc, jr_004_74d5

    ld [de], a
    ld [bc], a
    jr z, jr_004_74d1

    ld [bc], a
    inc c
    inc [hl]
    db $10
    ld [de], a
    ld [bc], a
    inc b
    ld b, $02
    ld d, $18
    ld a, [de]
    inc e
    ld [bc], a
    ld [bc], a
    ld [$201e], sp
    ld [hl+], a
    ld [bc], a
    ld [bc], a
    ld a, [bc]
    inc h
    ld h, $28
    ld [bc], a
    inc c
    ld c, $10
    ld a, [hl+]
    inc l
    ld l, $30
    ld [bc], a
    ld [de], a
    inc d
    ld [bc], a
    ld [hl-], a
    inc [hl]
    ld [hl], $38
    inc b

jr_004_74d1:
    ld b, $02
    jr nz, jr_004_74f7

jr_004_74d5:
    inc h
    ld [$0c0a], sp
    ld h, $28
    ld [bc], a
    ld c, $10
    ld [de], a
    ld a, [hl+]
    inc l
    ld [bc], a
    inc d
    ld d, $18
    ld [bc], a
    ld l, $30
    ld a, [de]
    inc e
    ld e, $02
    ld [hl-], a
    inc [hl]
    ld [de], a
    inc d
    ld d, $18
    ld [bc], a
    inc b
    ld b, $08
    ld a, [bc]

jr_004_74f7:
    inc c
    ld c, $10
    inc e
    ld e, $20
    inc [hl]
    ld [hl], $38
    inc b
    ld b, $02
    ld [bc], a
    ld [$0c0a], sp
    ld c, $04
    ld b, $02
    ld [bc], a
    jr jr_004_7528

    inc e
    ld c, $10
    ld [de], a
    ld [bc], a
    ld [bc], a
    ld e, $20
    ld [hl+], a
    inc h
    inc d
    ld d, $02
    ld [bc], a
    ld h, $28
    ld a, [hl+]
    ld c, $10
    ld [de], a
    ld [bc], a
    ld [bc], a
    inc l
    ld l, $30
    inc h

jr_004_7528:
    inc b
    ld a, [bc]
    inc c
    inc b
    ld c, $10
    inc c
    inc e
    ld e, $20
    inc b
    ld b, $08
    ld a, [bc]
    db $10
    ld [de], a
    inc d
    ld d, $04
    ld b, $08
    inc c
    jr jr_004_755a

    inc e
    ld e, $04

Jump_004_7543:
    ld b, $08
    ld a, [bc]
    jr nz, @+$24

    inc h
    ld h, $04
    ld b, $08
    ld c, $28
    ld a, [hl+]
    inc l
    ld l, $18
    ld [bc], a
    jr jr_004_7558

    jr jr_004_755a

jr_004_7558:
    jr jr_004_755c

jr_004_755a:
    jr jr_004_7576

jr_004_755c:
    ld [bc], a
    inc e
    ld [bc], a
    ld e, $02
    jr nz, jr_004_75a1

    ld b, b
    ld a, $40
    inc b
    ld b, $14
    ld d, $0c
    ld c, $18
    ld a, [de]
    ld [de], a
    db $10
    inc c
    db $10
    inc d
    db $10
    ld [de], a
    ld a, [bc]

jr_004_7576:
    ld b, d
    ld b, h
    ld b, [hl]
    ld c, b
    ld l, $30
    ld [hl-], a
    inc [hl]
    ld [bc], a
    inc a
    ld a, $02
    ld h, $28
    ld a, [hl+]
    inc l
    ld [hl], $38
    ld a, [hl-]
    ld [bc], a
    ld b, b
    ld [bc], a
    ld [hl+], a
    ld [bc], a
    ld [hl], $38
    ld a, [hl-]
    ld b, b
    ld [bc], a
    ld [hl+], a
    ld [bc], a
    inc h
    ld [bc], a
    ld [bc], a
    ld h, $28
    ld a, [hl+]
    inc l
    ld [hl], $38
    ld a, [hl-]
    ld [bc], a
    ld b, b

jr_004_75a1:
    ld [bc], a
    ld [hl+], a
    ld [bc], a
    ld [bc], a
    inc h
    ld [bc], a
    ld [bc], a
    ld l, $30
    ld [hl-], a
    inc [hl]
    ld [bc], a
    inc a
    ld a, $02
    ld [bc], a
    inc b
    ld b, $0a
    inc c
    ld c, $10
    ld [de], a
    inc d
    ld d, $1e
    jr nz, @+$04

    ld [bc], a
    ld [$0202], sp
    jr jr_004_75dd

    inc e
    ld [bc], a
    ld [bc], a
    ld [hl+], a
    ld d, $18
    ld a, [de]
    ld a, [hl+]
    inc l
    ld l, $02
    inc e
    ld e, $20
    jr nc, jr_004_7605

    inc [hl]
    ld [bc], a
    ld [bc], a
    inc e
    ld [hl+], a
    inc h
    jr nc, @+$34

    inc [hl]
    ld [bc], a

jr_004_75dd:
    ld [bc], a
    inc e
    ld h, $28
    jr nc, jr_004_7615

    inc [hl]
    ld [bc], a
    ld [bc], a
    inc b
    ld b, $02
    inc d
    ld d, $18
    ld a, [de]
    jr nc, jr_004_7621

    inc [hl]
    ld [hl], $4e
    ld d, b
    ld d, d
    ld d, h
    ld l, b
    ld l, d
    ld l, h
    ld l, [hl]
    ld [bc], a
    ld [$1c0a], sp
    ld e, $20
    jr c, @+$3c

    inc a
    ld d, [hl]
    ld e, b
    ld d, d

jr_004_7605:
    ld e, d
    ld [hl], b
    ld [hl], d
    ld [hl], h
    db $76
    ld [bc], a
    inc c
    ld c, $02
    ld [hl+], a
    inc h
    ld h, $02
    ld a, $40
    ld b, d

jr_004_7615:
    ld b, h
    ld e, h
    ld d, d
    ld e, [hl]
    ld h, b
    ld a, b
    ld a, d
    ld a, h
    ld a, [hl]
    ld [bc], a
    db $10
    ld [de], a

jr_004_7621:
    ld [bc], a
    jr z, jr_004_764e

    inc l
    ld l, $46
    ld c, b
    ld c, d
    ld c, h
    ld h, d
    ld d, d
    ld h, h
    ld h, [hl]
    add b
    add d
    add h
    add [hl]
    inc b
    ld b, $02
    ld [bc], a
    ld [bc], a
    ld [$0c0a], sp
    ld c, $10
    inc l
    ld l, $30
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld l, b
    ld l, d
    add h
    add [hl]
    adc b
    adc d
    adc h
    adc [hl]
    sub b
    sub d
    ld [de], a

jr_004_764e:
    inc d
    ld d, $18
    ld a, [de]
    ld [bc], a
    ld [bc], a
    ld [hl-], a
    inc [hl]
    ld [hl], $38
    ld a, [hl-]
    ld d, b
    ld d, d
    ld d, h
    ld d, [hl]
    ld l, h
    ld l, [hl]
    ld [hl], b
    ld [hl], d
    inc e
    ld e, $20
    ld [hl+], a
    ld [bc], a
    inc a
    ld a, $40
    ld b, d
    ld b, h
    ld e, b
    ld e, d
    ld e, h
    ld e, [hl]
    ld [hl], h
    db $76
    ld a, b
    ld a, d
    inc h
    ld h, $28
    ld a, [hl+]
    ld [bc], a
    ld b, [hl]
    ld c, b
    ld c, d
    ld c, h
    ld c, [hl]
    ld h, b
    ld h, d
    ld h, h
    ld h, [hl]
    ld a, h
    ld a, [hl]
    add b
    add d
    inc b
    jr c, jr_004_7690

    ld [bc], a
    inc e
    ld e, $20
    ld [hl+], a
    ld l, [hl]
    ld [hl], b
    ld [hl], d

jr_004_7690:
    ld [hl], h
    adc b
    adc d
    adc h
    adc [hl]
    inc b
    ld b, $08
    ld [bc], a
    inc e
    ld e, $20
    ld [hl+], a
    ld a, [bc]
    inc c
    ld c, $02
    inc h
    ld h, $28
    ld a, [hl+]
    db $10
    ld [de], a
    inc d
    inc l
    ld l, $30
    ld d, $18
    ld a, [de]
    ld [hl-], a
    inc [hl]
    ld [hl], $3a
    inc a
    ld a, $40
    ld d, h
    ld d, [hl]
    ld e, b
    ld e, d
    ld b, d
    ld b, h
    ld b, [hl]
    ld c, b
    ld e, h
    ld e, [hl]
    ld h, b
    ld h, d
    ld c, d
    ld c, h
    ld c, [hl]
    ld h, h
    ld h, [hl]
    ld l, b
    ld d, $50
    ld d, d
    ld [hl-], a
    ld l, d
    ld l, h
    ld l, [hl]
    ld [hl], b
    ld [hl], d
    ld [hl], h
    sub b
    sub d
    sub h
    ld [bc], a
    db $76
    ld a, b
    ld a, d
    ld a, h
    ld [bc], a
    sub [hl]
    sbc b
    sbc d
    ld a, [hl]
    add b
    add d
    sbc h
    sbc [hl]
    and b
    ld d, $84
    add [hl]
    ld [hl-], a
    and d
    and h
    inc b
    ld b, $08
    ld a, [de]
    inc e
    ld e, $0a
    inc c
    ld [$1c1a], sp
    ld e, $0e
    db $10
    inc c
    ld [$1a02], sp
    inc e
    ld e, $12
    inc d
    inc c
    ld [$1a02], sp
    inc e
    ld e, $16
    jr jr_004_7714

    ld [$2220], sp
    inc e
    ld e, $6e
    ld [hl], b
    ld [hl], d
    ld [hl], h
    sub b
    sub d
    cp b

jr_004_7714:
    ld [bc], a
    ld l, [hl]
    ld [hl], b
    ld [hl], d
    ld [hl], h
    sub b
    cp d
    cp h
    ld [bc], a
    ld l, [hl]
    ld [hl], b
    ld [hl], d
    ld [hl], h
    sub b
    cp [hl]
    ret nz

    jp nz, Jump_004_706e

    ld [hl], d
    ld [hl], h
    sub b
    and [hl]
    xor b
    xor d
    ld l, [hl]
    ld [hl], b
    ld [hl], d
    ld [hl], h
    xor h
    xor [hl]
    or b
    or d
    ld l, [hl]
    ld [hl], b
    ld [hl], d
    ld [hl], h
    sub b
    or h
    or [hl]
    ld [bc], a
    ld [$0c0a], sp
    ld c, $12
    inc d
    ld [$100a], sp
    ld c, $12
    inc d
    inc b
    ld b, $08
    ld a, [bc]
    inc d
    ld d, $18
    ld [de], a
    ld [bc], a
    inc b
    ld b, $08
    ld a, [bc]
    ld c, $10
    ld [de], a
    inc d
    ld d, $02
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld b, $02
    inc c
    ld c, $10
    ld [de], a
    inc d
    ld d, $18
    ld h, $28
    ld [bc], a
    ld a, [hl+]
    inc l
    ld l, $02
    ld [hl-], a
    inc d
    ld [bc], a
    ld e, $20
    jr nc, @+$04

    inc [hl]
    ld [hl], $22
    ld a, [hl-]
    ld [$020a], sp
    ld [bc], a
    ld a, [de]
    inc e
    db $10
    ld [de], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld e, $04
    ld b, $02
    inc d
    ld d, $18
    jr nz, jr_004_77b1

    inc h
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld b, $08
    inc c
    jr @+$1c

    ld [bc], a
    inc e
    ld [de], a
    inc d
    ld d, $04
    ld b, $08
    ld a, [bc]
    inc c
    ld c, $10
    ld [de], a
    ld a, [de]
    inc e
    ld e, $20
    ld [hl+], a
    jr z, jr_004_77d7

    inc l
    ld l, $30
    ld [hl-], a

jr_004_77b1:
    inc [hl]
    ld [hl], $02
    inc b
    ld b, $08
    ld a, [bc]
    inc h
    ld h, $28
    ld a, [hl+]
    ld [bc], a
    ld c, d
    ld c, h
    ld c, [hl]
    ld l, h
    ld l, [hl]
    ld [bc], a
    ld [bc], a
    inc c
    ld c, $02
    inc l
    ld l, $30
    ld [hl-], a
    ld d, b
    ld d, d
    ld d, h
    ld d, [hl]
    ld [hl], b
    ld [hl], d
    ld [hl], h
    db $76
    ld a, b
    ld a, d
    db $10
    ld [de], a

jr_004_77d7:
    inc d
    ld d, $02
    inc [hl]
    ld [hl], $38
    ld [bc], a
    ld e, b
    ld e, d
    ld e, h
    ld [bc], a
    jr jr_004_77fe

    inc e
    ld a, [hl-]
    inc a
    ld a, $40
    ld [bc], a
    ld e, [hl]
    ld h, b
    ld h, d
    ld b, d
    ld b, h
    ld b, [hl]
    ld c, b
    ld h, h
    ld h, [hl]
    ld l, b
    ld l, d
    ld a, h
    ld a, [hl]
    add b
    add d
    adc h
    adc [hl]
    sub b
    sub d
    add h

jr_004_77fe:
    add [hl]
    adc b
    adc d
    sub h
    sub [hl]
    sbc b
    sbc d
    and d
    and h
    and [hl]
    xor b
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    inc b
    ld [$0c0a], sp
    ld c, $10
    ld [de], a
    inc d
    ld d, $02
    jr jr_004_7833

    inc [hl]
    ld [hl], $38
    ld a, [hl-]
    ld d, [hl]
    ld e, b
    ld e, d
    ld [bc], a
    inc a
    ld a, $40
    ld b, d
    ld e, h
    ld e, [hl]
    ld h, b
    ld h, d
    ld [bc], a
    ld b, $02
    ld [hl+], a
    inc h
    ld [bc], a
    ld b, h
    ld b, [hl]
    ld c, b
    ld h, h

jr_004_7833:
    ld h, [hl]
    ld l, b
    ld [bc], a
    ld c, d
    ld c, h
    ld c, [hl]
    ld l, d
    ld l, h
    ld l, [hl]
    ld [hl], b
    ld [bc], a
    ld [hl], d
    ld [hl], h
    ld [bc], a
    db $76
    ld a, b
    ld a, d
    ld a, h
    ld a, [hl]
    add b
    add d
    add h
    ld [bc], a
    inc c
    ld c, $02
    jr z, jr_004_7879

    inc l
    ld l, $52
    ld d, h
    ld d, [hl]
    ld e, b
    ld [hl], d
    ld [hl], h
    db $76
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    db $10
    ld [de], a
    jr nc, jr_004_7892

    inc [hl]
    ld [hl], $02
    ld e, d
    ld e, h
    ld e, [hl]
    ld h, b
    ld a, b
    ld a, d
    ld a, h
    ld a, [hl]
    ld [bc], a
    inc b
    ld b, $08
    ld [bc], a
    inc d
    ld d, $18
    jr c, jr_004_78af

    inc a
    ld a, $02
    ld h, d

jr_004_7879:
    ld h, h
    ld h, [hl]
    ld l, b
    add b
    add d
    add h
    ld [bc], a
    add [hl]

Jump_004_7881:
    ld a, [bc]
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld a, [de]
    inc e
    ld e, $18

Jump_004_7889:
    ld b, b
    ld b, d
    ld b, h
    ld b, [hl]
    ld l, d
    ld l, h
    ld l, [hl]
    ld [bc], a
    ld [hl], b

jr_004_7892:
    jr nz, jr_004_78b6

    inc h
    ld h, $4a
    ld c, h
    ld c, [hl]
    ld d, b
    nop
    nop
    ld bc, $0900
    nop
    ld de, $1900
    nop
    ld hl, $2900
    nop
    ld [hl-], a
    nop
    ld a, $00
    ld b, [hl]
    nop
    ld c, a

jr_004_78af:
    nop
    ld e, e
    nop
    ld h, e
    nop
    ld l, e
    nop

jr_004_78b6:
    ld [hl], a
    nop
    add c
    nop
    sub b
    nop
    sbc a
    nop
    xor c
    nop
    or e
    nop
    cp l
    nop
    rst $00
    nop
    pop de
    nop
    ld bc, $db00
    nop
    db $e3
    nop
    jp hl


    nop
    pop af
    nop
    ld sp, hl
    nop
    inc bc
    ld bc, $0001
    dec bc
    ld bc, $0001
    add [hl]
    nop
    dec b
    nop
    dec c
    nop
    dec d
    nop
    ccf
    nop
    ld e, $00
    ld d, h
    nop
    add [hl]
    nop
    inc de
    ld bc, $011b
    inc hl
    ld bc, $012d
    cpl
    ld bc, $0131
    inc sp
    ld bc, $0004
    inc bc
    nop
    dec [hl]
    ld bc, $013b
    add [hl]
    nop
    ld bc, $4300
    ld bc, HeaderComplementCheck
    dec e
    nop
    ld e, c
    ld bc, $015d
    ld h, [hl]
    ld bc, $000f
    ld [hl], d
    ld bc, $017a
    add d
    ld bc, $018e
    sbc l
    ld bc, $01a7
    or c
    ld bc, $01bb
    jp $cb01


    ld bc, $01d3
    db $db
    ld bc, $01e3
    dec c
    nop
    rst $20
    ld bc, $01eb
    rst $28
    ld bc, SkipMode
    ei
    ld bc, $0203
    add hl, bc
    ld [bc], a
    rrca
    ld [bc], a
    rla
    ld [bc], a
    rra
    ld [bc], a
    dec h
    ld [bc], a
    dec hl
    ld [bc], a
    ld sp, $3702
    ld [bc], a
    daa
    ld bc, $023d
    ld b, c
    ld [bc], a
    ld b, d
    ld [bc], a
    adc b
    nop
    ld b, $00
    ld c, c
    ld [bc], a
    ld a, [hl-]
    nop
    cp [hl]
    nop
    rst $38
    nop
    pop de
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld c, a
    ld [bc], a
    ld d, a
    ld [bc], a
    ld e, a
    ld [bc], a
    ld h, a
    ld [bc], a
    ld l, a
    ld [bc], a
    ld a, [hl-]
    nop
    ld bc, $7700
    ld [bc], a
    ld a, d
    ld [bc], a
    scf
    nop
    ld bc, $8600
    nop
    dec b
    nop
    ld a, l
    ld [bc], a
    ld a, [hl-]
    nop
    ld d, $00
    dec e
    nop
    rra
    nop
    add c
    ld [bc], a
    adc c
    ld [bc], a
    sub c
    ld [bc], a
    sbc c
    ld [bc], a
    ld d, h
    nop
    ret


    nop
    ld e, b
    nop
    jp nc, $a100

    ld [bc], a
    dec l
    nop
    scf
    nop
    or c
    ld [bc], a
    ld bc, $8600
    nop
    or l
    ld [bc], a
    cp c
    ld [bc], a
    ld bc, $0900
    nop
    dec b
    nop
    dec l
    nop
    cp l
    ld [bc], a
    cp a
    ld [bc], a
    pop bc
    ld [bc], a
    inc bc
    nop
    jp $0602


    nop
    rlca
    nop
    ld [$0d00], sp
    nop
    ld c, $00
    rrca
    nop
    push bc
    ld [bc], a
    rst $00
    ld [bc], a
    ld d, $00
    dec e
    nop
    ld a, [hl-]
    nop
    rra
    nop
    sbc h
    nop
    and [hl]
    nop
    ld e, c
    nop
    push bc
    nop
    ret


    ld [bc], a
    pop de
    ld [bc], a
    reti


    ld [bc], a
    db $dd
    ld [bc], a
    pop de
    ld [bc], a
    db $e3
    ld [bc], a
    di
    ld [bc], a
    rst $38
    ld [bc], a
    dec b
    inc bc
    dec c
    inc bc
    ld h, b
    nop
    nop
    nop
    db $d3
    nop
    ld d, $03
    inc e
    inc bc
    inc h
    inc bc
    inc l
    inc bc
    inc [hl]

Jump_004_7a01:
    inc bc
    ld b, b
    inc bc
    ld c, b
    inc bc
    ld d, c
    inc bc
    ld e, c
    inc bc
    ld h, l
    inc bc
    ld l, l
    inc bc
    ld a, c
    inc bc
    add c
    inc bc
    sub b
    inc bc
    sbc h
    inc bc
    xor b
    inc bc
    or b
    inc bc
    cp d
    inc bc
    jp nz, $cc03

    inc bc
    call nc, $dc03
    inc bc
    db $e4
    inc bc
    db $ec
    inc bc
    db $f4
    inc bc
    ld a, [$0003]
    inc b
    ld [$1004], sp
    inc b
    ld d, $04
    inc e
    inc b
    inc h
    inc b
    inc l
    inc b
    ld [hl-], a
    inc b
    jr c, jr_004_7a42

    ld a, $04
    ld b, h
    inc b

jr_004_7a42:
    ld c, h
    inc b
    ld d, h
    inc b
    ld e, h
    inc b
    ld h, h
    inc b
    ld l, h
    inc b
    ld [hl], h
    inc b
    ld a, h
    inc b
    add h
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
    ld bc, $8c00
    inc b
    sub d
    inc b
    sbc b
    inc b
    dec d
    nop
    and b
    inc b
    inc bc
    ld bc, $04aa
    inc bc
    ld bc, $04b8
    call nz, $ca04
    inc b
    sub $04
    rst $18
    inc b
    cp l
    nop
    db $ed
    inc b
    push af
    inc b
    ld a, [$0004]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    dec b
    inc c
    dec b
    ld [de], a
    dec b
    ld e, $05
    inc h
    dec b
    jr nc, jr_004_7aad

    ld c, $00
    inc a
    dec b
    ld b, h

jr_004_7aad:
    dec b
    cpl
    inc b
    ld c, h
    dec b
    ld d, h
    dec b
    ld e, b
    dec b
    rla
    dec b
    ld h, d
    dec b
    ld l, b
    dec b
    dec c
    nop
    ld [hl], b
    dec b
    ld a, b
    dec b
    cp l
    nop
    add h
    dec b
    nop
    nop
    nop
    nop
    adc h
    dec b
    nop
    nop
    sbc b
    dec b
    and b
    dec b
    xor b
    dec b
    or d
    dec b
    cp d
    dec b
    add $05
    ret nc

    dec b
    call c, $e105
    dec b
    ret z

    ld [bc], a
    ld de, $4242
    ld b, d
    ld b, d
    ld b, d
    inc sp
    ld b, e
    ld b, d
    inc sp
    ld b, e
    ld b, d
    ld b, d
    ld b, e
    ld d, d
    ld d, e
    ld d, e
    ld d, d
    ld d, d
    ld d, d
    ld d, d
    ld d, d
    ld d, d
    ld sp, $2342
    ld b, d
    ld b, d
    ld d, d
    ld b, d
    ld b, d
    ld b, d
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld hl, $2121
    ld hl, $4241
    ld b, d
    ld d, d
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld de, $3221
    ld b, d
    ld b, c
    ld b, c
    ld d, d
    ld h, d
    ld de, $3322
    ld b, e
    ld hl, $4242
    ld b, e
    ld d, e
    ld d, d
    ld d, d
    ld d, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, d
    ld b, d
    ld [hl-], a
    ld [hl-], a
    ld b, d
    ld b, d
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld b, c
    ld b, c
    ld b, d
    ld [hl-], a
    ld sp, $3231
    ld sp, $3131
    ld sp, $1111
    ld de, $4242
    ld b, d
    ld b, d
    ld b, d
    ld sp, $3131
    ld sp, $4121
    ld b, c
    ld b, c
    ld b, c
    ld hl, $2121
    ld hl, $4242
    ld b, d
    ld b, d
    ld hl, $2121
    ld hl, $2128
    ld hl, $4141
    ld b, c
    ld b, c
    ld b, c
    ld hl, $1111
    ld hl, $2121
    ld hl, $2121
    ld de, $1111
    ld de, $1111
    ld hl, $2121
    ld hl, $2121
    ld hl, $1121
    ld de, $4342
    ld sp, $4332
    ld b, h
    ld b, e
    ld [hl-], a
    ld b, d
    inc sp
    ld sp, $2111
    ld [hl-], a
    ld b, d
    ld b, d
    ld b, d
    ld b, e
    ld b, d
    inc sp
    ld b, d
    ld b, e
    ld b, d
    ld b, e
    ld b, d
    ld d, e
    ld b, e
    ld h, d
    ld b, d
    ld d, d
    ld b, d
    ld d, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld [hl-], a
    ld [hl-], a
    ld b, d
    ld b, d
    ld [hl-], a
    ld [hl-], a
    ld b, d
    ld b, d
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld [hl-], a
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld de, $1111
    ld de, $2111
    inc hl
    inc hl
    ld b, d
    ld hl, $4152
    ld [hl], d
    ld b, c
    inc [hl]
    inc hl
    ld b, e
    inc sp
    ld [hl], d
    ld d, c
    ld b, d
    ld d, c
    ld b, d
    ld de, $1111
    ld de, $1111
    ld de, $1111
    ld de, $1111
    ld de, $5211
    ld [hl-], a
    ld b, e
    ld [hl-], a
    ld b, e
    ld b, e
    ld sp, $4242
    ld sp, $4142
    ld d, d
    ld [hl-], a
    ld h, c
    ld b, d
    ld sp, $3442
    ld b, c
    ld b, d
    ld de, $4311
    ld de, $4242
    ld d, d
    ld b, d
    ld b, e
    ld d, d
    ld b, e
    ld d, c
    ld b, d
    ld de, $0000
    nop
    ld bc, $0300

Call_004_7c0c:
    nop
    ld bc, $0000
    nop
    db $fd
    db $fc
    ldh a, [rSB]
    xor $00
    db $fd
    db $fc
    ldh a, [rSB]
    xor $fd
    ld [bc], a
    db $fd
    ld [bc], a
    dec b
    ld a, [c]
    add hl, bc
    ld [bc], a
    nop
    ld hl, sp+$00
    ld hl, sp+$00
    ld b, $00
    dec b
    nop
    inc b
    nop
    dec b
    nop
    rlca
    nop
    ld [$10fb], sp
    rst $38
    rst $38
    rst $30
    ld hl, sp+$00
    ld b, $01
    inc bc
    inc bc
    ld [bc], a
    nop
    inc bc
    nop
    dec b
    nop
    ld [$1000], sp
    nop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    nop
    nop
    nop
    nop
    ld [bc], a
    nop
    nop
    nop
    nop
    rst $38
    nop
    rst $38
    nop
    db $f4
    ld bc, StartGame
    db $fc
    ld bc, $0100
    ld [$0819], sp
    ld de, $0904
    nop
    ld bc, $01f4
    ld hl, sp-$0f
    db $fc
    pop af
    db $fc
    pop af
    inc b
    db $10
    inc b
    ld [$0004], sp
    inc b
    ld hl, sp+$00
    pop af
    rst $38
    inc b
    rst $38
    inc b
    rst $38
    inc b
    nop
    inc b
    nop
    inc b
    nop
    inc b
    nop
    nop
    nop
    cp $00
    inc c
    nop
    dec c
    nop
    ld c, $00
    stop
    stop
    ld bc, $0000
    dec b
    nop
    dec b
    nop
    dec b
    ld bc, $0001
    nop
    nop
    nop
    ld [$0d00], sp
    nop
    ld a, [bc]
    nop
    ld [$1000], sp
    nop
    stop
    nop
    nop
    nop
    nop
    ld c, $00
    dec c
    nop
    dec c
    nop
    ld c, $00
    rrca
    nop
    stop
    dec c
    nop
    dec bc
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
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    nop
    nop
    ld bc, $0000
    nop
    ld bc, $1000
    nop
    stop
    stop
    stop
    nop
    nop
    stop
    stop
    ld de, $1000
    nop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    stop
    db $10
    inc bc
    db $10
    inc bc
    ld de, $f4fe
    cp $f4
    ld [bc], a
    db $f4
    ld [bc], a
    ld [$ea02], a
    nop
    nop
    inc c
    dec c
    add hl, bc
    nop
    nop
    stop
    stop
    stop
    rlca
    db $fc
    nop
    db $fc
    nop
    db $fc
    nop
    inc c
    nop
    inc b
    jr nc, jr_004_7d75

    nop
    nop
    jr nc, jr_004_7d75

jr_004_7d75:
    nop

jr_004_7d76:
    nop
    jr nc, jr_004_7d79

jr_004_7d79:
    nop
    nop
    jr nc, jr_004_7d76

    nop
    db $fd
    jr nz, jr_004_7d75

    rla
    db $fc
    scf
    db $f4
    db $10
    ld hl, sp+$30
    db $f4
    db $10
    ld hl, sp+$30
    nop
    nop
    nop
    ld b, $00
    nop
    inc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    cp $00
    nop
    nop
    nop
    nop
    nop
    ld b, $fe
    ld b, $00
    ld b, $00
    nop
    nop
    ld b, $00
    ld b, $fc
    ld b, $fc
    ld b, $fc
    ld b, $00
    ld b, $00
    ld b, $00
    ld b, $00
    ld b, $00
    ld b, $00
    ld b, $00
    ld b, $00
    inc bc
    nop
    ld [bc], a
    nop
    inc bc
    db $fc
    dec b
    nop
    stop
    ldh a, [rP1]
    ldh a, [rP1]
    ld sp, hl
    ldh a, [rNR24]
    db $fc
    rst $28
    ldh a, [rIF]
    db $f4
    rst $20
    nop
    rlca
    push af
    call nc, $e409
    add sp, -$19
    inc b
    rst $20
    db $f4
    rst $28
    db $ec
    rrca
    nop
    ld sp, hl
    db $f4
    add hl, de
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
    db $10
    inc c
    db $10
    inc b
    jr nc, jr_004_7e0d

jr_004_7e0d:
    ld hl, sp+$04
    jr z, jr_004_7e0d

    ld e, $ff
    add hl, de
    ld [bc], a
    add hl, de
    cp $29
    dec b
    rra
    add hl, bc
    ccf
    ld a, [bc]
    ld a, [de]
    ld a, [bc]
    ld a, [hl-]
    ld [bc], a
    ld a, [bc]
    ld [bc], a
    ld a, [hl+]
    ld b, $1a
    ld b, $2a
    db $fc
    jr jr_004_7e33

    jr z, @+$06

    ld [$1802], sp
    ld a, [$0028]

jr_004_7e33:
    dec de
    nop

jr_004_7e35:
    dec de
    nop
    dec de
    nop
    dec de
    cp $08
    ld b, $28
    nop

jr_004_7e3f:
    nop
    db $fc
    jr nz, jr_004_7e3f

    db $fd
    ld hl, sp+$2d
    db $fc
    inc d
    ld hl, sp+$44
    db $fc
    jr z, jr_004_7e35

    jr c, jr_004_7e56

    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    ld a, [bc]
    ld a, [bc]
    ld a, [bc]

jr_004_7e56:
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
    dec c
    dec c
    dec c
    dec c
    inc c
    ld c, $0e
    ld c, $17
    rla
    rla
    rla
    jr jr_004_7e86

    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    db $10
    ld de, $1111
    inc de
    inc de
    inc de
    inc de
    inc de
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a

jr_004_7e86:
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    ld [de], a
    inc de
    inc de
    inc de
    inc de
    inc de
    inc de
    dec d
    dec d
    dec d
    dec d
    dec d
    dec d
    dec d
    dec d
    ld d, $16
    ld d, $16
    ld d, $19
    add hl, de
    add hl, de
    add hl, de
    add hl, de
    ld a, [de]
    ld a, [de]
    ld a, [de]
    dec de
    dec de
    dec de
    dec de
    dec de
    dec de
    dec de
    dec de
    inc e
    inc e
    inc e
    dec e
    dec e
    dec e
    dec e
    dec e
    ld de, $1e1e
    ld e, $1e
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    rra
    jr nz, jr_004_7ee9

    jr nz, jr_004_7eeb

    jr nz, jr_004_7eed

    jr nz, jr_004_7eef

    rrca
    inc d
    inc d
    rlca
    inc e
    inc e
    inc e
    inc e
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca
    rlca

jr_004_7ee9:
    rlca
    rlca

jr_004_7eeb:
    rlca
    rlca

jr_004_7eed:
    rlca
    rlca

jr_004_7eef:
    rlca
    ld [$0808], sp
    ld [$0808], sp
    ld [$0808], sp
    ld [$0707], sp
    rlca
    ld e, $1e
    ld e, $1e
    ld hl, $2121
    ld hl, $2121
    ld hl, $2221
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    ld [hl+], a
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc h
    inc h
    inc h
    inc h
    inc h
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl
    inc h
    inc h
    inc h
    inc h
    inc h
    dec hl
    dec hl
    dec hl
    jr z, @+$2a

    add hl, hl
    add hl, hl
    ld a, [hl+]
    ld a, [hl+]
    ld a, [hl+]
    ld a, [hl+]
    ld a, [hl+]
    ld a, [hl+]
    add hl, hl
    add hl, hl
    jr z, @+$2a

    jr z, @+$28

    ld h, $26
    ld h, $27
    daa
    daa
    daa
    daa
    daa
    daa
    daa
    daa
    rlca
    dec h
    dec h
    dec h
    dec h
    dec h
    dec h
    dec h
    dec h
    dec h
    dec h
    dec h
    dec h
    ld h, $26
    ld h, $26
    ld h, $26
    ld h, $26
    ld h, $26
    ld h, $26
    ld h, $27
    daa
    daa
    daa
    daa
    daa
    daa
    daa
    daa
    daa
    call c, Call_000_3c00
    dec b
    inc e
    add hl, bc
    db $fc
    dec bc
    ld a, h
    rrca
    inc a
    ld [de], a
    ld e, h
    ld d, $1c
    ld a, [de]
    call c, $bc1b

jr_004_7f85:
    dec e
    cp h
    jr nz, jr_004_7f85

    ld [hl+], a
    call c, Call_004_5c26
    ld a, [hl+]
    ld a, h
    dec hl
    sbc h
    ld l, $fc
    ld sp, $357c
    inc a
    scf
    ld e, h
    ld a, [hl-]
    inc a
    inc a
    cp b
    ld b, h
    jr c, jr_004_7fe6

    jr @+$4b

    jr c, jr_004_7ff0

    jr jr_004_7ff5

    ret c

    ld d, d
    jr @+$5d

    jr @+$66

    jr @+$72

    jr @+$74

    ld a, l
    xor b
    sbc l
    or b
    db $dd
    cp b
    dec e
    cp h
    ld a, b
    ld a, h
    db $dd
    cp [hl]
    inc a
    ld [de], a
    ld e, h
    ld d, $1c
    ld a, [de]
    call c, $bc1b

jr_004_7fc5:
    dec e
    cp h
    jr nz, jr_004_7fc5

    ld [hl+], a
    call c, Call_004_5c26
    ld a, [hl+]
    ld a, h
    dec hl
    sbc h
    ld l, $fc
    ld sp, $357c
    inc a
    scf
    ld e, h
    ld a, [hl-]
    inc a
    inc a
    cp b
    ld b, h
    jr c, @+$48

    jr @+$4b

    jr c, @+$4e

    jr @+$51

jr_004_7fe6:
    ret c

    ld d, d
    jr @+$5d

    jr @+$66

    jr @+$72

    jr @+$74

jr_004_7ff0:
    ld a, l
    xor b
    sbc l
    or b
    db $dd

jr_004_7ff5:
    cp b
    dec e
    cp h
    ld a, b
    ld a, h
    db $dd
    cp [hl]
    rst $38
    rst $38
    rst $38
    inc b
