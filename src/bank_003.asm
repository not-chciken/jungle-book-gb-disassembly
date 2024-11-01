SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

    push bc

Call_003_4001:
    ld hl, $62ae
    add hl, bc
    push bc
    push hl
    ld hl, Layer3PtrBackground1
    ld a, c
    cp $14
    jr nz, jr_003_4012

    ld hl, CompressedTODOData26a07

jr_003_4012:
    ld de, Layer3BgPtrs1

Jump_003_4015:
    call DecompressTilesIntoVram
    pop hl
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, Layer3BgPtrs2
    call DecompressTilesIntoVram
    pop bc
    ld hl, $6b40
    add hl, bc
    push hl
    ld hl, Layer2PtrBackground1
    ld a, c
    cp $14
    jr nz, jr_003_4033

    ld hl, $7226

jr_003_4033:
    ld de, Layer2BgPtrs1
    call DecompressTilesIntoVram
    pop hl
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, Layer2BgPtrs2

Jump_003_4040:
    call DecompressTilesIntoVram
    pop bc
    sla c
    sla c
    ld hl, $409a
    add hl, bc
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    ld a, [hl+]
    push hl
    ld h, [hl]
    ld l, a
    ld a, [NextLevel]
    cp $09
    jr z, jr_003_4060

    ld a, d
    cp $90
    jr z, jr_003_406a

jr_003_4060:
    push hl
    push de
    ld hl, MapBackgroundTileData
    call DecompressInto9000
    pop de
    pop hl

jr_003_406a:
    call DecompressTilesIntoVram
    pop hl
    inc hl
    ld e, [hl]
    inc hl
    ld d, [hl]
    inc hl
    ld a, d
    or e
    ret z

    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jp DecompressTilesIntoVram


LoadVirginLogoData::
    ld hl, CompressedVirginLogoData
    call DecompressInto9000
    ld hl, $9800
    ld de, $8800
    ld bc, $0200
    rst $38
    ld hl, CompressedVirginLogoTileMap

DecompressInto9800::
    ld de, $9800
    jr JumpToDecompress

; $4094: Decompresses data into tile map.
DecompressInto9000::
    ld de, $9000

; $03:4097 Simply jumps to DecompressTilesIntoVram
JumpToDecompress::
    jp DecompressTilesIntoVram


    nop
    sub b
    ld a, [$c040]
    sub [hl]
    jp c, $0049

    sub b
    reti


    ld b, l
    ret nc

    sub [hl]
    xor a
    ld c, d
    nop
    sub b
    ld a, [$c040]
    sub [hl]
    add [hl]
    ld c, e
    nop
    sub b
    ld a, [$c040]
    sub [hl]
    and l
    ld c, h
    nop
    sub b
    ld a, [$c040]
    sub [hl]
    and l
    ld c, h

Jump_003_40c2:
    nop
    sub b
    reti


    ld b, l
    ret nc

    sub [hl]
    ld a, c
    ld c, l
    ret nc

    sub d
    adc [hl]
    ld c, [hl]
    ld h, b
    sub l
    dec sp
    ld c, a
    ret nc

    sub d
    adc [hl]
    ld c, [hl]
    ld h, b
    sub l
    dec sp
    ld c, a
    nop
    sub b
    ld l, [hl]
    ld d, c
    ret nz

    sub [hl]
    ld [de], a
    ld d, h
    nop
    sub b
    inc c
    ld d, l
    nop
    nop
    nop
    nop
    nop
    sub b
    ld d, c
    ld e, d
    nop
    nop
    nop
    nop
    nop
    sub b
    ld a, [$c040]
    sub [hl]
    db $da
    ld c, c

; $40fa Tile data for map background. Reused across levels.
; Compressed $4df; Decompressed: $6c0
MapBackgroundTileData::
    db $c0, $06, $db, $04, $00, $26, $e8, $94, $87, $19, $ea, $30, $13, $2c, $20, $5a
    db $40, $b5, $80, $68, $01, $52, $02, $a7, $f8, $40, $13, $2c, $20, $5a, $80, $94
    db $c0, $e8, $31, $50, $04, $0b, $90, $16, $10, $45, $30, $fa, $fc, $7f, $f8, $ff
    db $28, $00, $48, $7e, $00, $88, $0b, $f1, $03, $47, $d0, $40, $66, $03, $80, $10
    db $f1, $bf, $39, $20, $82, $02, $e2, $10, $2f, $18, $90, $03, $7c, $01, $c0, $51
    db $fe, $03, $fc, $43, $7c, $01, $10, $2f, $ff, $05, $fe, $07, $ff, $c7, $90, $c0
    db $14, $b0, $ed, $20, $30, $b0, $56, $00, $6e, $24, $10, $d0, $76, $60, $ae, $00
    db $1c, $71, $20, $a0, $6d, $42, $55, $c0, $36, $f0, $40, $40, $25, $4e, $60, $2a
    db $30, $89, $ab, $01, $01, $48, $bc, $0a, $04, $10, $15, $d8, $44, $f7, $80, $00
    db $26, $d6, $ff, $0b, $06, $2a, $b1, $2e, $90, $f0, $84, $01, $8c, $08, $02, $0a
    db $4c, $2a, $ff, $15, $ff, $22, $ff, $01, $87, $00, $a0, $2c, $40, $84, $fa, $4f
    db $35, $10, $08, $c0, $c0, $80, $04, $2c, $03, $0a, $24, $10, $05, $34, $32, $08
    db $28, $30, $fd, $04, $00, $b1, $70, $24, $00, $08, $03, $ff, $07, $03, $01, $22
    db $fe, $00, $60, $17, $f1, $3f, $f0, $00, $30, $aa, $10, $17, $06, $dc, $8a, $44
    db $86, $11, $88, $68, $02, $80, $d0, $d8, $10, $03, $4a, $59, $04, $00, $21, $b0
    db $1f, $06, $54, $fa, $f8, $77, $18, $00, $7c, $a3, $ce, $7f, $df, $00, $80, $09
    db $38, $40, $30, $e5, $f0, $2f, $08, $16, $83, $f8, $47, $fc, $c7, $29, $00, $64
    db $c1, $05, $00, $a6, $38, $02, $80, $f2, $f5, $ff, $32, $00, $90, $c8, $86, $00
    db $60, $95, $df, $3f, $ff, $3f, $fe, $3f, $fc, $01, $70, $10, $02, $80, $4c, $2b
    db $ff, $57, $03, $00, $b4, $f8, $40, $e0, $51, $80, $51, $f8, $e7, $18, $00, $38
    db $f1, $fc, $83, $0c, $84, $a4, $a8, $fe, $1d, $ff, $9d, $0a, $00, $71, $18, $1e
    db $00, $d4, $47, $e0, $00, $30, $33, $52, $fc, $83, $fe, $13, $fd, $9b, $1f, $00
    db $c1, $39, $00, $08, $86, $01, $a0, $24, $a0, $00, $80, $1d, $de, $3f, $df, $00
    db $10, $7c, $fe, $3d, $06, $0a, $31, $a0, $0e, $ff, $20, $df, $80, $90, $00, $e7
    db $11, $30, $02, $4c, $80, $6f, $48, $80, $46, $f8, $07, $e0, $1f, $c0, $3f, $43
    db $a1, $27, $02, $07, $80, $b2, $b8, $47, $f8, $07, $40, $56, $f8, $07, $82, $00
    db $ac, $7b, $80, $e1, $01, $a0, $d3, $fd, $ff, $f8, $3f, $c3, $fc, $fd, $01, $d8
    db $1a, $31, $0f, $74, $0b, $58, $07, $5c, $03, $18, $07, $34, $0b, $b0, $0f, $b8
    db $07, $94, $7e, $05, $fe, $95, $7e, $51, $bf, $02, $fe, $57, $bf, $04, $3b, $02
    db $a0, $84, $ef, $01, $40, $f9, $09, $00, $c2, $de, $ff, $cb, $ff, $6b, $01, $d0
    db $a9, $37, $00, $10, $f1, $fe, $ab, $fc, $b9, $fe, $e9, $fe, $fd, $fe, $f9, $fe
    db $03, $fc, $03, $fc, $3b, $c4, $3f, $c0, $14, $09, $c4, $c2, $85, $55, $f8, $00
    db $3f, $30, $00, $24, $c4, $05, $50, $fc, $03, $1d, $03, $c0, $a4, $ff, $00, $c0
    db $13, $ec, $ff, $03, $fc, $07, $f8, $27, $d8, $7f, $02, $09, $69, $00, $d3, $eb
    db $ff, $d5, $ff, $ea, $ff, $dd, $01, $f0, $e8, $ef, $1f, $0f, $90, $78, $00, $e4
    db $03, $20, $71, $04, $06, $f0, $03, $8c, $4b, $00, $30, $fa, $ff, $ff, $fd, $6f
    db $f8, $87, $7f, $50, $fd, $af, $5a, $08, $84, $fa, $7f, $f5, $bf, $ff, $7f, $ff
    db $01, $48, $ea, $00, $1f, $e3, $9c, $65, $da, $68, $b7, $ca, $57, $fe, $81, $68
    db $9f, $7f, $40, $a0, $bf, $48, $d7, $31, $ce, $23, $7c, $8a, $ff, $1c, $3f, $ca
    db $dd, $23, $c1, $8d, $28, $d0, $5f, $b0, $9f, $60, $5f, $f1, $6e, $b2, $5d, $e4
    db $fb, $07, $c8, $38, $a7, $fa, $7d, $f5, $fb, $f2, $7f, $f5, $ce, $3e, $ff, $07
    db $af, $d2, $11, $40, $4a, $74, $fe, $89, $77, $20, $14, $10, $a9, $06, $00, $8c
    db $72, $fd, $8e, $71, $fe, $0b, $46, $7b, $d8, $f9, $f7, $03, $7c, $f9, $b7, $f3
    db $cf, $f7, $ff, $e3, $cf, $f9, $87, $7f, $70, $8d, $af, $fc, $e3, $10, $ef, $fe
    db $7f, $fe, $bf, $7e, $5f, $b5, $ef, $91, $a1, $28, $04, $fa, $05, $fd, $82, $78
    db $47, $bd, $a7, $db, $75, $fd, $ba, $fe, $11, $fd, $43, $bf, $7b, $80, $ff, $01
    db $b6, $48, $10, $1a, $f2, $0f, $d4, $3f, $a0, $7f, $d0, $7f, $a8, $7f, $e0, $1f
    db $04, $fb, $40, $fe, $3d, $c0, $47, $b8, $83, $7f, $94, $7d, $0e, $fc, $47, $fe
    db $a9, $fc, $77, $f9, $ff, $03, $f8, $07, $e0, $1f, $c4, $3f, $a8, $7f, $14, $ff
    db $2c, $ff, $5c, $bf, $04, $80, $0e, $a3, $7c, $21, $de, $91, $ee, $0d, $f7, $2d
    db $fa, $7f, $fd, $7d, $1a, $05, $5c, $18, $a8, $0a, $7f, $80, $3f, $c0, $1f, $e1
    db $54, $bb, $ab, $55, $e2, $17, $02, $50, $eb, $14, $e7, $03, $40, $ae, $5b, $a4
    db $63, $9c, $75, $8e, $7b, $86, $7d, $02, $c5, $00, $93, $4a, $7f, $d3, $fc, $e1
    db $fe, $d0, $ff, $e2, $fd, $d1, $ff, $e5, $7b, $c5, $bb, $eb, $ff, $d1, $bf, $e4
    db $7b, $f6, $b9, $6b, $fc, $33, $fc, $39, $fe, $01, $be, $f3, $8f, $f9, $c7, $bc
    db $43, $fe, $49, $00, $a9, $0e, $40, $f9, $fe, $f5, $ff, $e1, $fe, $e5, $ff, $f1
    db $ee, $5d, $e6, $39, $c7, $f8, $07, $3c, $c1, $de, $60, $1f, $e2, $4f, $b3, $8f
    db $f3, $ff, $d3, $cf, $f3, $d7, $e9, $fb, $3e, $7d, $bf, $bd, $7e, $fd, $7f, $f9
    db $7e, $f5, $7a, $ed, $73, $dc, $63, $fc, $03, $7c, $80, $ff, $02, $ff, $00, $ff
    db $01, $ea, $64, $30, $2a, $c7, $ff, $9b, $a7, $dd, $a3, $de, $61, $df, $a0, $5f
    db $80, $11, $3c, $83, $7c, $82, $01, $b6, $05, $6b, $0d, $03, $c2, $01, $31, $c0
    db $0c, $f0, $88, $c1, $ab, $02, $78, $e0, $df, $38, $37, $0e, $09, $07, $02, $01
    db $70, $00, $0c, $70, $0d, $42, $18, $8c, $04, $fe, $89, $77, $e2, $01, $f0, $7f
    db $58, $60, $9b, $08, $4b, $80, $23, $c4, $13, $e4, $0b, $f4, $03, $f8, $07, $fc
    db $73, $00, $60, $01, $fe, $03, $ff, $82, $7d, $c1, $bc, $60, $5c, $32, $2c, $19
    db $86, $0c, $43, $84, $23, $c0, $13, $e0, $0b, $f0, $07, $f8, $07, $f8, $6f, $24
    db $00, $29, $d0, $d1, $40, $bf, $81, $3e, $03, $3d, $46, $3a, $8c, $74, $18, $c1
    db $b0, $f2, $61, $e4, $43, $c8, $47, $d0, $4f, $e0, $df, $45, $06, $ae, $10, $0f
    db $20, $1e, $40, $3e, $0c, $83, $50, $03, $a0, $0e, $9a, $01, $04, $8c, $64, $20
    db $0c, $6e, $1a, $20, $f9, $1e, $a4, $78, $ff, $01, $fe, $07, $fb, $1c, $e4, $78
    db $90, $e0, $43, $80, $0c, $03, $31, $0f, $90, $60, $43, $00, $0c, $03, $70, $0f
    db $40, $3f, $40, $3f, $00, $21, $01, $bc, $0a, $fe, $09, $f8, $27, $08, $3c, $0d
    db $70, $1a, $4c, $04, $f0, $f7, $ff, $f9, $87, $71, $70, $08, $20, $fa, $03, $00
    db $fa, $21, $00, $23, $fd, $83, $ff, $73, $80, $17, $80, $20, $90, $51, $80, $3f
    db $e0, $1f, $c8, $1f, $d4, $0f, $c8, $07, $e4, $03, $f2, $0d, $c0, $bf, $50, $bf
    db $44, $00, $90, $02, $02, $c0, $bf, $c0, $7f, $81, $bf, $02, $bd, $c5, $3b, $e8
    db $1f, $f1, $0e, $d6, $21, $d9, $27, $d4, $2f, $45, $02, $01, $f0, $2f, $e0, $3f
    db $e0, $1f, $e2, $fd, $02, $7f, $80, $9f, $c0, $7f, $c0

    ld e, a
    ldh [$5f], a
    ld [hl+], a
    ret nc

    ld b, $fd
    inc bc
    sbc b
    nop
    jr nz, @-$2e

    adc h
    add a
    add hl, de
    ld [$8330], a
    db $d3
    ld [bc], a
    and d
    dec b
    ld d, h
    dec bc
    adc b
    ld d, $20
    dec e
    ld [hl], b
    ld [hl], d
    adc l
    rla
    inc [hl]
    db $10
    pop hl
    ld [bc], a
    and d
    dec b
    ld c, b
    rlca

jr_003_45fd:
    adc h
    db $f4
    rra
    dec b
    dec b
    ld b, [hl]
    dec bc
    sub b
    ld d, $10
    ld b, l
    jr @-$3c

    rst $08
    ld a, [$f507]
    adc a
    ld [bc], a
    ld b, b
    ld e, l
    cp $17
    db $fc
    dec hl
    ld a, [hl]
    pop hl
    ld b, b
    ld l, h
    add c
    cp b
    rst $08
    cp $47
    cp b
    ld b, a
    call nc, $226d
    ld a, [bc]
    or [hl]
    db $ec
    inc bc
    ld [bc], a
    ld e, a
    add hl, de
    rrca
    ld h, b
    ccf
    nop
    ld a, [hl+]
    cp d
    rlca
    ret nz

    rlca
    jr nz, jr_003_463a

    adc b
    ld b, e
    inc a
    ret nz

jr_003_463a:
    cp a
    ld b, c
    cp $03
    db $fc
    ld bc, $42be
    or c
    ld l, a
    ret nz

    call c, $be01
    ld [bc], a
    ld [hl], b
    ld bc, $8081
    or [hl]
    inc bc
    ld [hl], e
    dec b
    ldh [$88], a
    ld [bc], a
    ld bc, $076d
    and c
    add c
    dec e
    ld d, b
    jr nz, jr_003_45fd

    ld l, d
    ld [bc], a
    ld d, e
    add c
    xor c
    push de
    ld b, b
    nop
    call nc, $a681
    ld bc, $0153
    sub b
    or b
    ld a, [hl-]
    db $10
    ld d, b
    sub l
    and b
    xor c
    ld l, $90
    db $10
    dec d
    sbc b
    ld e, h
    rst $38
    xor a
    ld b, $02
    ld b, h
    xor a
    ld bc, $b980
    push de
    rst $38
    cp e
    ld b, c
    jr nz, jr_003_46b7

    ld c, $20
    ld a, [de]
    db $10
    ld bc, $aa8a
    inc bc
    nop
    ld l, e
    db $fd
    ld bc, $5083
    db $fd
    xor a
    ld a, [de]
    nop
    ret c

    push de
    rlca
    nop
    adc h
    ld [$0902], sp
    ld c, h
    ld bc, $2ac8
    cp $45
    cp $03
    ld a, [bc]
    nop
    ld c, e
    dec b
    ld bc, $2201
    call nc, $aa7f
    add c
    ld b, b
    nop

jr_003_46b7:
    ld b, $08
    inc b
    db $f4
    rra
    ld l, b
    jr nz, jr_003_46c7

    inc de
    ld [hl], h
    ld d, c
    jr nz, jr_003_46c4

jr_003_46c4:
    ld b, b
    add h
    inc de

jr_003_46c7:
    nop
    ld d, h
    jp nz, Jump_000_0c09

jr_003_46cc:
    db $e3
    dec b
    ld hl, sp-$5e
    ld hl, sp+$77
    jr jr_003_46d4

jr_003_46d4:
    sub h
    add hl, sp
    inc b
    nop
    adc c
    ld a, h
    ld [bc], a
    ld [bc], a
    cp c
    ld e, b
    stop
    jr z, jr_003_46cc

    ei
    rst $00
    rra
    nop
    ld b, b
    ld bc, $0004
    add h
    daa
    nop
    jr nz, jr_003_46f9

    rst $38
    db $10
    rst $38
    jr c, jr_003_46f9

    ret nz

    ld c, d
    call nz, $c7fd

jr_003_46f9:
    dec de
    nop
    jr @-$3d

    dec b
    nop
    and $2f
    nop
    ld hl, sp-$78
    rra
    ld bc, $a400
    adc [hl]
    ld a, a
    sbc a
    pop bc
    nop
    ld b, h
    ld d, $38
    ld b, e
    sub l
    rst $38
    xor e
    rst $38
    rst $30
    ld [bc], a
    nop
    jp nc, Jump_003_7ffc

    db $fc
    ld b, b
    nop
    ld c, c
    ldh [rIE], a
    ld h, c
    nop
    ld d, b
    adc d
    rra
    ld bc, $2600
    sbc b
    add b
    ld d, b
    sub a
    rst $28
    cp a
    rst $38
    nop
    and b
    add sp, -$02
    ld a, a
    db $fc
    rra
    cp h
    nop
    ld [hl], b
    add h
    ret nz

    rst $38
    jr nz, @+$01

    ld [hl], h
    rst $38
    ld [$e4ff], a
    rst $38
    xor $ff
    adc $ff
    adc [hl]
    rst $38
    add [hl]
    ld de, $0809
    call nz, $747f
    ld bc, $3680
    ld a, [$0004]
    and d
    pop de
    rst $20
    rst $18
    ld h, e
    jr nc, jr_003_4763

    ld de, $f097
    ld [hl+], a

jr_003_4763:
    nop
    inc bc
    ldh [rNR32], a
    db $10
    ld [bc], a
    add b
    ldh a, [$27]
    nop
    db $10
    add h
    ld bc, $02fe
    and d
    add hl, bc
    ldh a, [$0b]
    ld [bc], a
    push bc
    nop
    rst $18
    ld bc, $0bde
    call nc, $5f00
    add b
    ld e, a
    ld h, c
    ld [$e203], sp
    pop de
    nop
    rst $38
    ld h, b
    db $10
    ldh [$8c], a
    rlca
    ld hl, sp-$7e
    ld b, b
    jr c, jr_003_47bf

    add h
    rla
    ld bc, $eff0
    ld h, e
    nop
    jr z, @+$09

    rst $38
    nop
    add e
    ld b, d
    cp a
    add h
    call c, Call_000_1e88
    nop
    call nc, Call_000_0ff2
    ld [$e366], sp
    ldh [$2f], a
    call nz, Call_000_103f
    inc b
    ret nc

    ld [hl], c
    adc a
    ld [$a202], sp
    ld [de], a
    ld b, d
    ld bc, $e711
    rla
    db $e4

jr_003_47bf:
    rst $18
    cpl
    inc c
    ld h, d
    dec c
    or h
    ld a, [hl+]
    ld a, b
    ld [hl], l
    ld de, $00c0
    ld e, $00
    ld [$5581], sp
    ld a, $01
    ld a, $01
    inc a
    inc bc

jr_003_47d6:
    add [hl]
    add b
    xor b
    adc e
    nop
    db $fc
    inc hl
    jr z, @-$5e

    ld [bc], a
    rst $38
    rst $00
    rra
    ld [$8944], sp
    rlca
    db $10
    ld b, c
    sbc [hl]
    ld a, a
    sub h
    ld a, a
    sbc d
    ld a, a
    db $fc
    nop
    jr jr_003_47d6

    db $fc
    ld b, e
    db $fc
    add h
    pop bc
    ld h, $9e
    ld bc, $019e
    sbc a
    nop
    adc a
    add b
    rrca
    add b
    adc a
    dec b
    add b
    ld l, $fa
    dec b
    db $fc
    inc c
    ld b, $ca
    ld a, [de]
    sub b
    pop af
    rlca
    ld [bc], a
    sbc a
    ld a, [bc]
    ld b, $fc
    ccf
    cp $00
    or b
    ld l, c
    ld a, $40
    ld [$fcfb], sp
    ld [hl], c
    cp $c1
    cp $e1
    cp $88
    add b
    pop hl
    dec bc
    ld [$ff02], sp
    add b
    ld e, a
    nop
    rst $18
    ret nz

    rst $00
    rst $38
    ld b, b
    ld [bc], a
    ret nz

    dec bc
    ccf
    ld [bc], a
    add c
    ld d, b
    or b
    ld a, [bc]
    ld sp, hl
    inc bc
    ld [bc], a
    sbc d
    jr @+$12

    inc l
    pop hl
    db $d3
    add b
    adc b
    rrca
    jr jr_003_488e

    cp [hl]
    cp a
    nop
    ccf
    ld [bc], a
    inc a
    inc b
    jr c, @+$0a

    jr nc, jr_003_4867

    jr nz, jr_003_4869

    jr nz, jr_003_487b

    nop
    jr nz, jr_003_485e

jr_003_485e:
    ret nc

    rrca
    call nz, $c203
    ld bc, $80c1
    ld b, b

jr_003_4867:
    add b
    ld b, b

jr_003_4869:
    ld b, b
    nop
    ld b, b
    nop
    add b
    rra
    ret nz

    jr nc, jr_003_4881

    rst $08
    ccf
    ld c, d
    nop
    adc b
    ld [de], a
    ld b, b
    ld a, c
    nop

jr_003_487b:
    adc h
    ld [hl], e
    ld hl, sp+$16
    ld [bc], a
    cp d

jr_003_4881:
    ldh a, [$c0]
    ld e, c
    ld bc, $8e31
    ld a, a
    ret nz

    ld bc, $d600
    ccf
    ret nz

jr_003_488e:
    rst $00
    nop
    nop
    db $eb
    di
    rst $18
    ldh [$1f], a
    and b
    nop
    sub b
    dec d
    rst $28
    ldh a, [rIF]
    ldh [$09], a
    db $10
    ld b, $80
    jr z, jr_003_48f4

    ld c, d
    ld h, b
    push de
    and b
    jr z, @-$7d

    push de
    add e
    and d
    add d
    ld l, b
    ld a, l
    cp $82
    ld h, h
    ld a, [hl+]
    add d
    nop
    ldh [$d8], a
    ld [bc], a
    and l
    dec b
    ld d, d

jr_003_48bc:
    dec bc
    sub h
    ld d, $48
    ld sp, hl
    rlca
    add d
    jr nz, @+$22

    db $fc
    dec b
    inc b
    cp a
    ld c, $ff

jr_003_48cb:
    inc b
    ld sp, hl
    ld a, d
    ld a, [bc]
    add b
    ld d, c
    cp a
    ld bc, $ad81
    rst $08
    nop
    ret nz

    ld d, [hl]
    add b
    and d
    ld a, [bc]
    ld c, h
    ld a, b
    and b
    ld [$603c], sp

Jump_003_48e2:
    ld a, b
    push hl
    ldh a, [rIF]
    db $f4
    ld c, e
    ld [$fa6c], sp
    dec b
    ld hl, sp+$06
    add b
    cpl
    nop
    inc de
    ld b, c
    inc a

jr_003_48f4:
    ret nc

    rrca
    jr nc, jr_003_48bc

    set 6, c
    rst $30
    ei
    dec hl
    ld [bc], a
    sbc h
    ldh a, [$2f]
    ld h, b
    call c, $f404
    ld b, e
    inc a
    ret nz

    rra
    jr nz, jr_003_48cb

    rst $38

jr_003_490c:
    rst $30
    rst $38
    or e
    nop
    jr z, jr_003_490c

    db $fc
    dec sp
    cp $01
    rst $38
    add b
    ld a, e
    ldh [rNR33], a
    add sp, -$0b
    rst $30
    ld l, l
    nop
    ld l, b
    db $fd
    cp $ff
    db $fc
    ld a, a
    db $fc
    ccf
    db $fc
    rra
    db $fd
    cp [hl]
    inc bc
    db $ec
    inc bc
    ld hl, sp+$3f
    sub b
    adc l
    ret nz

    ccf

jr_003_4935:
    ldh [$1f], a
    ld a, h
    ld [bc], a
    cp [hl]
    ld bc, $01e6
    db $fc
    rla
    ld b, $6c
    inc de
    ld h, $71
    ret c

    ld [bc], a
    and e
    ld b, c
    ld a, c
    dec b
    ld h, [hl]

jr_003_494b:
    add c
    ld de, $2044
    ld d, b
    db $ec
    db $e3
    ei
    ld h, a
    ld d, b
    ld h, b
    inc b
    ld a, [c]
    pop hl
    db $fd
    di
    di
    rst $28
    ld [hl], a
    jr nc, @+$32

    ld a, [bc]
    ldh a, [rHDMA5]
    ld [$1816], sp
    dec e
    jr nz, jr_003_494b

    ei
    rla

jr_003_496b:
    inc d
    jr jr_003_496b

    rlca
    inc b
    or e
    ldh [$fe], a
    dec b
    dec b
    ld b, [hl]
    jr c, @+$01

    ld bc, $c003
    xor h
    ld b, e
    inc a
    ld b, c
    pop bc
    inc c
    or h
    sbc d

jr_003_4983:
    jr nc, jr_003_4983

    nop
    inc bc
    nop
    rst $38
    dec b
    inc b
    xor h
    ld b, l
    ld d, l
    ld bc, $11fe
    ldh [$1f], a
    ret nz

    jr nz, jr_003_4935

    inc b
    ld hl, sp+$17
    ldh [rNR23], a
    rst $00
    daa
    sbc a
    ld e, a
    ccf
    cp a
    ld a, a
    cp a
    dec d
    ld bc, $af0c
    rra
    rst $18
    cp a
    cp a
    ld a, a
    cp a
    add e
    ret nz

    ldh [rTAC], a
    nop
    push hl
    ccf
    nop
    ld [$fffe], sp
    db $fc
    rst $38
    ld [hl], c
    cp $86
    ret nz

    ldh a, [rP1]
    rra
    ldh [$3f], a
    ret nz

    rst $30
    ld bc, $07ee
    jr c, @+$09

    ld hl, sp+$05
    ld hl, sp+$7b
    nop
    ld c, b
    ld a, $c0
    dec sp
    ret nz

    ld c, a
    pop bc
    db $10
    cp $01
    inc b

; $49da: Also contains background tile data. Unpacked into $9700. Compressed $140, Uncompressed $d5.
MapBackgroundTileData2::
    db $40, $01, $d1, $00, $fc, $fd, $bf, $7c, $00, $00, $1b, $0e, $88, $fc, $ff, $e9
    db $f1, $01, $06, $0c, $87, $4b, $fc, $00, $05, $03, $84, $04, $bc, $1f, $00, $54
    db $60, $42, $02, $1e, $40, $bf, $20, $d0, $68, $82, $11, $d8, $3f, $ce, $9f, $c7
    db $a7, $01, $40, $09, $3f, $b0, $a0, $04, $f4, $8f, $71, $60, $10, $6e, $30, $30
    db $fa, $03, $f9, $c3, $f8, $75, $f8, $3e, $38, $0f, $c8, $07, $f0, $6f, $1c, $12
    db $01, $fe, $83, $ff, $63, $fd, $00, $0d, $22, $1c, $98, $fe, $05, $fe, $31, $c0
    db $c1, $0e, $03, $fe, $0d, $fe, $39, $fc, $f1, $f2, $1f, $00, $4e, $1f, $01, $c1
    db $f8, $0d, $24, $32, $3d, $50, $0a, $f0, $27, $f0, $c7, $e8, $87, $db, $0f, $f8
    db $3f, $f8, $d7, $e0, $17, $08, $86, $48, $e1, $80, $9f, $03, $7e, $02, $fc, $19
    db $0a, $01, $e0, $9f, $00, $bf, $62, $fc, $e2, $d9, $ed, $73, $e3, $f7, $fe, $c7
    db $e7, $af, $ed, $0f, $e4, $03, $f5, $18, $7d, $de, $32, $0f, $b9, $7f, $9e, $1d
    db $d4, $8f, $c9, $d6, $af, $ad, $c5, $cf, $fc, $87, $62, $37, $cd, $33, $e2, $99
    db $62, $9c, $00, $1f, $cb, $16, $d0, $6f, $82, $1d, $b4, $db, $30, $0f, $61, $1e
    db $e5

    jr @-$1a
    ld b, e
    jr z, jr_003_4ae0
    ld bc, $00d3
    ld b, b
    add b
    rst $38
    ld [bc], a
    db $fc
    inc bc
    ld hl, sp+$77
    jr nc, @+$42

    ld [bc], a
    cp $39
    nop
    sbc b
    ld a, c
    inc b
    ld bc, $1446
    jr nz, @-$7d

    ld a, h
    ret nc

    rrca
    ldh a, [rTAC]
    ld hl, sp+$1f
    inc c
    and b
    ld b, $f8
    pop hl
    ld bc, $e398
    add hl, bc
    ld b, $10
    ld b, l
    ld c, d
    rlca
    rst $28
    ld a, [hl]

jr_003_4ae0:
    add b
    ld a, a
    add b
    ld [hl], a
    adc b
    rlca
    ld hl, sp+$07
    ld hl, sp+$01
    nop
    sbc $01
    inc e
    add e
    ldh a, [rSB]
    db $fc
    ld [bc], a
    adc h
    ld bc, $486e
    cp h
    ld a, [hl-]
    db $e4
    ld [hl], h
    rrca
    jr nz, jr_003_4b16

    inc b
    db $fc
    ld bc, $01fa
    adc h
    inc bc
    add e
    nop
    ld d, d
    dec b
    and d
    add a
    nop
    nop
    jp nc, Jump_000_24e4

    ld a, b
    add b
    rst $38
    ld a, a
    add b
    ld [bc], a

jr_003_4b16:
    ld a, [c]
    inc e
    nop
    db $fc
    db $fd
    inc de
    adc h
    jr nz, jr_003_4b40

    inc e
    xor h
    ld a, [$fb04]
    nop
    rst $38
    push af
    di
    cp $31
    rst $38
    ret nz

    ccf
    sbc b
    push hl
    jp $9ffb


    rst $20
    rst $38
    ld b, $df
    pop hl
    rst $38
    jp $c3bf


    ld a, a
    add c
    rst $28
    db $f4
    di

jr_003_4b40:
    ld sp, hl
    rst $38
    ld sp, hl

jr_003_4b43:
    rst $38
    cp $c1
    ccf
    ld b, b
    ccf
    add hl, bc
    jr nz, @-$2c

    cp a
    ld e, a
    cp a
    rst $38
    ld a, $ff
    dec a
    cp $3b
    inc a
    db $e4
    sbc e
    pop hl
    rst $18
    db $db
    rst $38
    db $fd
    rst $38
    cp $bd
    ld a, a
    db $fc
    dec sp
    db $fc
    scf

jr_003_4b65:
    jr c, jr_003_4b65

    add c
    rst $38
    add e
    ei
    add a
    rst $30
    ld c, a
    cp a
    rst $08
    dec sp
    adc h
    ld c, c
    ld [bc], a
    pop hl
    rra
    ldh [$03], a
    db $fc
    inc c
    ld a, a
    adc a
    cp a
    rst $10
    rst $28
    rst $10
    rst $28
    rst $18
    rst $20
    rst $18
    inc bc
    ld [hl+], a
    ld b, b
    ld bc, $011b
    nop
    call nz, $c839
    inc sp
    call z, $d033
    daa
    ret z

    daa
    ldh [rSC], a
    db $10
    add b
    ld a, [hl]
    ret nz

    ld c, $11
    ldh [rTIMA], a
    ld a, [$e413]
    dec h
    ret z

    ld bc, $01da
    cp $09
    ldh a, [rNR51]
    ld [de], a
    ld c, b
    dec b
    ld a, [c]
    adc h
    ld [hl], c
    ld c, [hl]
    jr nc, jr_003_4b43

    jr nc, @+$31

    sub b
    ld c, a
    sub [hl]
    pop bc
    jr jr_003_4b40

    add c
    ld [hl+], a
    ret nz

    ld c, a
    sub b
    adc a
    jr nc, jr_003_4bd3

    ldh a, [$1f]
    ldh [$8f], a
    nop
    ld c, a
    inc [hl]
    ld [$01f2], sp
    sub c
    ld b, c
    add c
    nop
    ld h, a

jr_003_4bd3:
    jr jr_003_4bd5

jr_003_4bd5:
    db $fc
    inc sp
    inc e
    db $10
    ld hl, $c41c
    nop
    inc de
    nop
    jp nz, Jump_000_03fe

    add hl, bc
    ld b, l
    jr nz, jr_003_4c05

jr_003_4be6:
    ld b, h
    add e
    ld [$01f0], sp
    cp $88
    ld b, c
    jr c, jr_003_4c10

    dec b
    add sp, $07
    pop de
    nop
    ld [hl-], a
    ld l, h
    nop
    xor b
    cp d
    adc e
    jr nc, jr_003_4c00

    ld [hl], b
    add e
    ld [hl], b

jr_003_4c00:
    jr jr_003_4be6

    inc hl

jr_003_4c03:
    ret z

    rlca

jr_003_4c05:
    inc e
    jr nz, jr_003_4c03

    ld l, e
    nop
    nop
    rlca
    rrca
    ld [hl], d
    ld b, $78

jr_003_4c10:
    ld b, $78
    rlca
    ld a, b
    adc a
    ld [hl], b
    rlca
    ei
    db $fc
    adc b
    and b
    pop de
    rra
    ldh [rIF], a
    ldh [rTAC], a
    jp z, $c511

    jr c, @+$43

    ld a, [hl-]
    jp nz, $c439

    inc sp
    ret z

    daa
    ret nc

    rrca
    ldh [$5f], a
    ld b, l
    ld [bc], a
    ld bc, $9fe0
    rst $28
    rrca
    rst $20

jr_003_4c39:
    rrca
    ld h, a
    rrca
    db $76
    adc a
    ld [hl], a
    ld c, $ee
    ld c, $ee
    ld c, $fe
    ld c, $e4
    add hl, de
    ldh [rNR34], a
    ld h, b
    rra
    and b
    ld e, a
    add b
    rra
    and b
    inc hl
    add b
    db $10
    ldh [$1f], a
    jp nz, $804d

    cpl
    nop
    rrca
    pop hl
    ld c, $e0
    rrca
    add sp, -$19
    nop
    ld l, h
    ld a, [c]
    adc e
    ld bc, $7a18
    inc b

jr_003_4c6a:
    add b
    rlca
    and b
    rrca
    sbc b
    ld e, a
    cp b
    rrca
    ret c

    rla
    ldh [$8f], a
    ld c, b
    jr nz, jr_003_4c39

    dec b
    nop
    ld bc, $1efe
    db $fd
    ld e, $f8
    dec e
    db $e4
    inc hl
    ret nz

    cpl
    ret nz

    cpl
    ret z

    rlca
    db $e4
    inc bc
    pop hl
    jr z, jr_003_4c9b

    sbc [hl]
    rst $18
    rst $38
    rst $38
    rra
    ldh a, [rIF]
    ret nz

    rrca
    and b
    cpl
    ld h, b

jr_003_4c9b:
    ld c, a
    ld [c], a
    call z, $a1c8
    jp $bf07


    rra
    dec h
    ld b, b
    ld bc, $00d0
    add b
    ld [bc], a
    and d
    nop
    ld e, [hl]
    ldh a, [rIF]
    rst $00
    ccf
    add h
    inc bc
    xor b
    add b
    ld e, l
    dec d
    adc b
    ld c, $76
    dec d
    add h
    inc bc
    ld c, a
    ldh [$03], a
    db $fc
    ldh a, [rIE]
    cp $06
    dec b
    and d
    ccf
    ret nz

    adc a
    ld b, c
    jr nz, jr_003_4d12

jr_003_4cce:
    jr jr_003_4cce

    ret nz

    jr nz, @+$16

    sub h
    ld [hl], e
    adc h
    ld bc, $01f4
    add b
    rst $38
    inc bc
    or b
    pop de
    rlca
    ret c

    inc de
    call c, $4d08
    jr nz, @+$4d

    jr nz, jr_003_4ceb

    jr nc, jr_003_4c6a

    ld a, a

jr_003_4ceb:
    nop
    rst $38
    ld b, b
    cp $c1
    db $fc
    jp Jump_000_0039


    ldh [$1f], a
    ld b, [hl]
    ld [bc], a
    adc b
    cp $02
    add l
    inc sp
    nop
    ret nz

jr_003_4cff:
    rrca
    ldh a, [$5f]
    ld d, b
    jr nz, jr_003_4cff

    ld a, c
    nop
    ld b, $20
    nop
    pop bc
    and h
    pop af
    ld [$4118], sp
    ld b, b
    daa

jr_003_4d12:
    ld a, b
    ldh a, [$67]
    nop
    ldh a, [rSTAT]
    ld a, d
    ldh a, [$7d]
    ld hl, sp+$7e
    db $fc
    ld a, [hl]
    db $fc
    ld a, l
    ld hl, sp+$33
    add b
    ld c, a
    add b
    ld bc, $0ff0
    add b
    ld [hl], b
    add b
    ld l, a
    adc a
    rst $18
    sub a
    cp $ac
    inc l
    jr nz, jr_003_4d63

    inc l
    db $ec
    ld bc, $01fc
    cp $00
    ld d, [hl]
    nop
    ld a, e
    db $10
    ld c, e
    ld b, b
    sbc $40
    jp z, VBlankInterrupt

    ld e, a
    cp a
    sbc e
    nop
    ld h, $c1
    inc b
    nop
    adc c
    ld e, b
    and [hl]
    rst $38
    nop
    rst $38
    ld bc, $0d0c
    ld c, b
    ld bc, $0882
    nop
    nop
    add b
    ld d, l
    db $eb
    rst $38
    rst $38

jr_003_4d63:
    ld a, a
    ld hl, sp+$1f
    db $e3
    inc e
    nop
    ld [bc], a
    add b
    adc c
    pop hl
    rst $18
    rst $38
    ld a, a
    cp $1f
    ldh [$bf], a
    ld d, h
    db $eb
    rra
    and b
    inc hl
    jr nc, @+$03

    ld de, $8001
    nop
    ld a, a
    nop
    ld a, [hl]
    ld bc, $02fc
    cp b
    rlca
    ld [hl], b
    dec bc
    ldh [$27], a
    ret nz

    dec c
    nop
    ret nc

    rrca
    ldh [rTAC], a
    add sp, $03
    db $f4
    ld bc, $00de
    ld l, l
    ld b, b
    ld a, $00
    ei
    ld b, a
    add h
    sbc b
    ld a, h
    nop
    jr nc, jr_003_4daa

    ld b, [hl]
    jr nc, jr_003_4dc7

    ld c, h
    add h
    inc bc

jr_003_4daa:
    inc bc
    nop
    nop
    jr nz, jr_003_4dc7

    ldh [rNR32], a
    add b
    ld h, e
    sbc h
    ld sp, $f778
    inc bc
    db $fc
    inc bc
    cp h
    ld b, e
    inc a
    ret nz

    ccf
    ret nz

    xor a
    jr @-$3e

    ld a, [bc]
    ldh a, [$2f]
    ret nz

jr_003_4dc7:
    cp a
    nop
    rst $38
    nop
    cp $05
    db $10
    ldh [$9f], a
    nop
    rst $38
    ld [bc], a
    db $fc
    adc e
    adc b
    ld d, b
    sub c
    ld a, a
    nop
    rst $38
    nop
    ld b, b

Call_003_4ddd:
    ld bc, $e658
    add hl, de
    add b
    ld a, a
    ldh [$1f], a
    ret nz

    ccf
    db $10
    add b
    db $10
    add b
    ld [$41fe], sp
    ldh [$bf], a
    ldh [$5f], a
    ld [c], a
    rst $38
    ldh a, [$5f]
    push hl
    rst $38
    ld [c], a
    rra
    nop
    ld h, b
    add b
    rra
    push af
    cp a
    xor $df
    rst $38
    ld a, a
    ccf
    inc hl
    ld b, c
    ldh a, [rIF]
    db $f4
    add e
    ld a, h
    and b
    rla
    add sp, $01
    ld a, [hl]
    adc b
    rra
    db $e4
    adc a
    ld a, [$0d0f]
    ld de, $2222
    ret nz

    ccf
    ret nc

    rrca
    db $f4
    inc bc
    db $fc
    add c
    ld a, $40
    push bc

jr_003_4e26:
    jr nz, jr_003_4e44

    xor h
    ld a, [$fb04]
    nop
    rst $38
    push af
    di
    cp $31
    rst $38
    ret nz

    ccf

jr_003_4e35:
    sbc b
    push hl
    jp $9ffb


    rst $20
    rst $38
    ld b, $df
    pop hl
    rst $38
    jp $c3bf


    ld a, a

jr_003_4e44:
    add c
    rst $28
    db $f4
    di
    ld sp, hl
    rst $38
    ld sp, hl
    rst $38
    cp $c1
    ccf
    ld b, b
    ccf
    add hl, bc
    jr nz, jr_003_4e26

    cp a
    ld e, a
    cp a
    rst $38
    ld a, $ff
    dec a
    cp $3b
    inc a
    db $e4
    sbc e
    pop hl
    rst $18
    db $db
    rst $38
    db $fd
    rst $38
    cp $bd

jr_003_4e68:
    ld a, a
    db $fc
    dec sp
    db $fc
    scf

jr_003_4e6d:
    jr c, jr_003_4e6d

    add c
    rst $38
    add e
    ei
    add a
    rst $30
    ld c, a
    cp a
    rst $08
    dec sp
    adc h
    ld c, c
    ld [bc], a
    pop hl
    rra
    ldh [$03], a
    db $fc
    inc c
    ld a, a
    adc a
    cp a
    rst $10
    rst $28
    rst $10
    rst $28
    rst $18
    rst $20
    rst $18
    inc bc
    ld [hl+], a
    ldh a, [rP1]
    xor c
    nop
    rst $38
    nop
    di
    rrca
    jp hl


    ld e, $c0
    ccf
    adc b
    nop
    add hl, hl
    add b
    nop
    jr nz, jr_003_4e35

    db $fd
    jp Jump_000_00ef


    nop
    adc c
    ld h, b
    ld e, a
    ld d, b
    ld [hl], h
    ld b, $1c
    nop
    jp z, Jump_000_1ee2

    pop hl
    rra
    nop
    ld e, c
    pop hl
    rra
    ld [$b002], sp
    xor $1f
    ld a, h
    rst $38
    rst $38
    nop
    ld c, a
    or b
    inc bc
    db $fc
    ld b, e
    cp h
    inc bc
    db $fc
    ld bc, $fbfe
    db $fd
    db $fd
    cp $ed
    rra
    ld [hl], $cf
    ld b, $fe
    inc de
    xor $39
    ld [de], a
    ld d, b
    ld [hl], h
    ld de, $ff00
    inc b
    adc e
    db $10
    ldh a, [$1f]
    ld bc, $4846
    inc b
    jr nc, jr_003_4e68

    ld bc, $01fe
    cp $1d
    ld [c], a
    rra
    ldh [$1f], a
    ldh [rIF], a
    ld [hl], b
    ld b, a
    nop
    jp nc, $1fe2

    ret nc

    rrca
    ret c

    rlca
    ret c

    add c
    db $10
    ret nz

    ccf
    ld b, b
    ld b, $c0
    add d
    ld a, [$f907]
    ld d, a
    ld hl, sp+$07
    cp $81
    ld [$0f90], sp
    ldh a, [rVBK]
    jr nc, @+$44

    or d
    sub c
    ld [$d57f], a
    rst $38
    db $eb
    rst $38
    push de
    rst $38
    ld [$ddff], a
    rst $38
    rst $28
    rst $38
    rst $18
    inc bc
    ld de, $c606
    ccf
    nop
    ret nz

    ccf
    ld hl, $0020
    cp $05
    ld a, [$fa05]
    rrca
    ldh a, [rIE]
    ld bc, $a014
    ld [bc], a
    cpl
    ld [bc], a
    inc b
    inc b
    add d
    or a
    ld a, [bc]
    ld b, d

jr_003_4f45:
    ld b, b
    nop
    ret nz

    dec c
    rst $20
    add hl, de
    nop
    nop
    jr jr_003_4f55

    inc l
    db $10
    ld a, [hl]
    ld [de], a
    add d
    ld c, d

jr_003_4f55:
    rst $38
    ld bc, $2480
    add h
    add e
    jr nz, jr_003_4fbc

    ld b, b
    nop
    db $ec
    inc bc
    ld b, b
    ld a, b
    inc bc
    ld hl, sp+$0f
    nop
    and c
    ld c, $5a
    dec c
    and b
    ld a, [hl-]
    rst $00

jr_003_4f6e:
    ccf
    call nz, $06f7
    ld sp, $c22c
    rra
    add b
    ld h, b
    ld de, $03fc
    cp [hl]
    ld b, c
    cp $01
    xor [hl]
    ld d, b
    sbc $20
    db $f4
    ld a, [bc]
    ld a, $00
    nop
    ld e, $01
    ld c, h
    dec b
    ld [c], a
    ccf
    nop
    ld [$00fd], sp
    ld hl, sp+$03
    nop
    inc h
    ld hl, sp-$01
    ld [hl], a
    ld hl, sp+$75
    ld a, [$fe71]
    pop af
    add h
    jr nz, jr_003_4f6e

    di
    dec bc
    ld c, $01
    inc c
    nop
    ld [$1080], sp
    adc b
    add h
    rst $30
    rst $18
    scf
    db $10
    adc b
    cp $80
    ld [hl], b
    ld de, $0040
    add sp, -$18
    cpl
    nop

jr_003_4fbc:
    adc h
    add a
    ld e, h
    ccf
    ld [hl-], a
    nop
    rst $08
    jr nc, jr_003_4f45

    ld a, a
    nop
    add hl, bc
    jp nz, $8439

    rst $38

jr_003_4fcc:
    rst $28
    rlca
    db $10
    rst $28
    nop
    jr c, jr_003_4fdb

    jp z, Jump_000_23e1

    inc e
    call c, $80c0
    ret z

jr_003_4fdb:
    rst $38
    cp a
    ld b, b
    rst $18
    rra
    nop
    jp hl


    db $10
    inc b
    dec b
    and b
    sbc b
    nop
    or $09
    ld h, d
    sbc l
    jr nz, jr_003_4fcc

    inc bc
    db $fd
    inc d
    add c
    ld [hl], c
    nop
    rst $38
    add b
    ccf
    add sp, -$39
    add [hl]
    nop
    and e
    ld bc, $f34a
    rrca
    inc a
    jp $f708


    nop
    rst $38
    ld [$d8f7], sp
    daa
    cp h
    inc bc
    db $ec
    jp $f1fa


    cp $fc
    ld b, l

Call_003_5013:
    dec d
    ld bc, $e230
    db $fc
    dec sp
    ld a, [$18e9]
    jr @+$3a

    ld [$fd28], sp
    db $fd
    ld a, a
    rst $38
    call z, Call_003_723d
    adc h
    rla
    db $e3
    rst $08
    ldh a, [$33]
    cp $c9
    dec a
    nop
    ld b, [hl]
    inc b
    db $10
    adc d
    ld c, $d0
    ld a, [bc]
    call nc, Call_000_3e01
    ret


    ld [hl], $c0
    rra
    pop hl
    cp [hl]
    ld b, c
    ld b, b
    ldh [rNR42], a
    ret nz

    ld b, $0c
    add b
    inc c
    ret nz

    ld b, $b8
    ld b, c
    ld c, [hl]
    or h
    inc bc
    ld hl, sp+$4b
    cp l
    call z, $6e3e
    rla
    xor a
    sbc e

jr_003_505a:
    rst $10
    call $e6e3
    ld a, c
    di
    cp h
    ld [hl], h
    ld e, a
    cp b
    ld b, a
    sub c
    or a
    call nz, $f243
    and c
    ld [hl], b
    ld d, b
    jr nc, jr_003_508f

    jr @+$12

    ld [$0a00], sp
    nop
    rlca
    ld [$4a05], sp
    ld bc, $04ee
    sbc e
    ld h, b
    cpl
    jp nz, $d01d

    cp a
    ld [hl-], a
    ld a, l

jr_003_5085:
    ld [hl], e
    db $ec
    or $d8
    push hl
    sbc c
    bit 4, e
    sub a
    rst $10

jr_003_508f:
    ld a, $2f
    db $fd
    ld e, [hl]
    ld [$c6ad], a
    ld c, c
    adc l
    add e
    ld [$0507], sp
    ld c, $02
    inc e
    inc b
    jr jr_003_505a

    dec d
    ld b, b
    add hl, hl
    add [hl]
    nop
    add l
    ld [bc], a
    sub l
    ld [bc], a
    cp b
    rlca
    add sp, $17
    adc b
    ld [hl], a
    add b
    ld a, a
    adc b
    rst $30
    dec c
    ld a, [c]
    ld e, $e0
    sbc e
    ld h, c
    adc e
    inc b
    ld c, b
    nop
    rst $38
    push bc
    ld hl, sp-$29
    db $e3
    rst $18
    rrca
    and d
    ld b, b
    ld hl, sp-$01
    db $e3
    ld sp, hl
    rst $18
    pop hl
    ld [hl], c
    adc a
    rst $00
    ccf
    sbc h
    ld a, a
    db $76
    ld hl, sp-$63
    pop hl
    rst $00
    dec a
    sub b

jr_003_50db:
    ld a, l
    ld l, h
    ldh a, [$99]
    pop hl

jr_003_50e0:
    ld [hl], c
    add b

jr_003_50e2:
    pop bc
    ld bc, $3b00
    ld [bc], a
    jr z, @+$1a

    ldh [$e0], a
    add e
    jr nz, jr_003_50ee

jr_003_50ee:
    ld [$6800], sp
    nop
    ret nc

    jr z, jr_003_5085

    ld l, a
    ld [$5800], sp
    nop
    ret nc

    ld [$8b70], sp
    jr nz, jr_003_50db

    jr nz, jr_003_50e0

    ld bc, $21fe
    ret c

    rlca
    nop
    ld [hl], b
    nop
    add sp, -$38
    ld bc, $c0d2
    and e
    ld a, [de]
    add a
    inc c
    inc bc
    or a
    add d
    ret nz

    sub b
    inc b

jr_003_5119:
    nop
    push bc
    and $81
    db $ec
    inc hl
    jp nz, $edc1

    inc hl
    jp $c4a0


    jp $c3ed


    db $ed
    jp Jump_003_4015


    ld [hl], l
    ld [hl+], a
    add b
    ldh [$0e], a
    ld h, b
    dec a
    nop
    inc e
    db $dd
    add b
    jr nz, jr_003_50e2

    inc bc
    xor b
    ld [bc], a
    ld hl, sp+$02
    ret c

    inc bc
    ld d, b
    inc bc
    or b
    inc bc
    cp b
    ld [bc], a
    ret nc

    inc hl
    inc l
    cp e
    inc h
    ld c, $a5
    inc b
    pop hl
    dec b
    add hl, hl
    add l
    push bc
    ei
    nop
    ld [bc], a
    ld a, b
    inc h
    db $10
    ld b, $04
    ld hl, sp+$07
    ld sp, hl
    add $3f
    ld b, b
    ld b, $00
    jp nz, $fe08

    rst $38
    cp $3f
    cp $e7
    add hl, de
    ld c, $60
    inc b
    and b
    ld [bc], a
    ret nc

    jr z, jr_003_51cb

    db $fc
    ld e, b
    add a
    sub a
    ld h, b
    ld bc, $02d1
    xor d
    dec b
    ld b, h
    dec bc
    sub b
    ld [de], a
    jr c, @+$3b

    inc b
    sbc d
    ld h, b
    ld bc, $02d1
    and h
    inc b
    ld b, [hl]
    ld [hl], b
    add c
    ld [hl+], a
    ld e, b

jr_003_5192:
    add b
    or h
    add b
    jr z, jr_003_5119

    ld de, $0058
    jr nz, jr_003_51a6

    inc a
    nop
    jr nz, jr_003_51a6

    nop
    rrca
    nop
    rlca
    add l
    inc hl

jr_003_51a6:
    ld l, b
    jr nz, jr_003_51f5

    nop
    xor $03
    nop
    ld [hl+], a
    or d
    ld b, b
    ld de, $2024
    adc d
    rlca
    or b
    rra
    db $10
    db $10
    reti


    rlca
    nop
    call nz, Call_000_001d
    ld e, $40
    ld e, $e0
    db $fd
    nop
    db $10
    adc b
    ld hl, sp-$7f
    inc b

Call_003_51ca:
    and [hl]

jr_003_51cb:
    add b
    ld e, l
    ld hl, sp-$7f
    add c
    or l
    ld [bc], a
    ld h, b
    call c, $8081
    xor [hl]
    inc bc
    ld h, e
    dec b
    ret nz

    db $76
    ld [bc], a
    ld bc, $135d
    xor d
    ld [bc], a
    db $76
    ld a, l
    inc b
    ld [$0294], sp
    nop
    inc b
    ld [bc], a
    inc d
    ld [$0e30], sp
    nop
    ld c, e
    nop
    ld bc, $a9c0

jr_003_51f5:
    ld [bc], a
    ld bc, $01e6
    ld [hl], b
    ld [de], a
    ld [de], a
    inc c
    ld [$0404], sp
    nop
    inc h
    jr jr_003_5205

    ld a, [hl]

jr_003_5205:
    and c
    ld b, b
    ld b, b
    add e
    ld c, c
    ld a, [bc]
    ld bc, $0003
    ld b, [hl]
    jr nc, jr_003_5192

Call_003_5211:
    nop
    ld c, c
    call c, Call_003_5013
    ld bc, $f28d
    inc bc
    add hl, bc
    ld c, h
    ld bc, $1801
    add b
    dec de
    add b
    cp a
    nop
    ldh a, [$87]
    rra
    ld [$0a20], sp
    ld [$0003], sp
    dec sp
    nop
    ccf
    dec b
    add b
    scf
    db $fc
    ld [$c808], sp
    rlca
    ret nz

    rst $20
    nop
    ld de, $101e
    dec l
    db $d3
    inc e
    db $e3
    inc e
    db $e3
    jr jr_003_5252

    push af
    db $10
    jp nc, $e22d

    dec e
    ld a, [bc]
    add c
    ld a, [hl]
    jr @-$12

    inc bc

jr_003_5252:
    cp $11
    rst $28
    ldh [$1f], a
    ld d, b
    xor h
    inc hl
    ret c

    rst $30
    nop
    rst $38
    inc bc
    inc c
    sub c
    add c
    xor c
    ld a, b
    add a
    ld a, h
    add e
    ld a, a
    add b
    ld [hl], a
    adc b
    dec sp
    call nz, $9c63
    ld b, e
    cp h
    ld b, a
    cp b
    cpl
    ret nc

    ld [hl], c
    adc [hl]
    ld h, b
    rra
    ret nc

    cpl
    add sp, -$69
    ld a, [hl]
    ld bc, $86f9

jr_003_5281:
    ld h, b
    sbc a
    ld b, b
    cp a
    ld bc, $03fe
    db $fc
    rlca
    ld hl, sp+$0f
    ldh a, [$7b]
    add h
    ld e, l
    ld [hl+], a
    ld [$d415], a
    dec hl
    adc [hl]
    ld [hl], c
    add a
    ld a, b
    sbc e
    inc b
    ld e, $fd
    inc bc
    call nc, $8c2b
    ld [hl], e
    add h
    ld a, e
    inc c
    di
    ld a, h
    add e
    jr nc, @-$7c

    and d
    ld d, [hl]
    xor c
    ld [c], a
    inc e
    ld h, e
    sbc l
    jr nc, jr_003_5281

    dec a
    jp nz, $c03f

    ld a, a
    add b
    rst $38
    nop
    rst $10
    add hl, hl
    cp [hl]
    ld b, b
    ld [hl], a
    adc c
    ld [hl-], a
    call z, $9c63
    ld h, e
    sbc h
    di
    inc c
    di
    inc c
    rst $38
    ld bc, $817e
    sbc [hl]
    ld h, b
    rrca
    pop af
    ld b, $f9
    add d
    ld a, l
    add d
    ld a, l
    jp nz, $603d

    jp nc, $9b04

    ret z

    inc a
    ld [bc], a
    add $01
    ld hl, sp+$0b
    ld a, [bc]
    ld b, a
    ldh a, [rIF]
    ret nz

    ccf
    add h
    ld b, b
    nop
    db $fc
    inc bc
    ld hl, sp+$07
    db $fc
    inc sp
    inc [hl]
    ld h, b
    db $dd
    inc bc
    inc c
    rrca
    nop
    sbc l
    xor $ff
    rst $00
    rst $38
    add hl, de
    and $ef
    rrca
    add b
    ld l, b
    sbc b
    rlca
    cp d
    dec b
    xor h
    inc bc
    xor [hl]
    ld bc, $038c
    sbc d

Jump_003_5312:
    dec b
    ret c

    rlca
    call c, $4a03
    cp a
    ld [bc], a
    rst $38

jr_003_531b:
    ld c, d
    cp a
    xor b
    ld e, a
    ld bc, $abff
    ld e, a
    add d
    ld a, a
    ld b, b
    cp a
    rst $28
    ld hl, $9401
    sbc a
    nop
    jr nz, jr_003_531b

    db $fd
    cp a
    db $fc
    cp a
    ld d, $00
    sbc l
    ld a, d
    inc bc
    nop
    ld de, $bfef
    jp z, $eb9f

    sbc a
    xor $df
    rst $28
    sbc a
    rst $28
    rst $08
    ld c, b
    add h
    dec b
    ld a, l
    rrca
    ldh a, [$03]
    db $fc
    ld bc, $86fe
    ld [c], a
    daa
    cp $81
    adc [hl]
    ld bc, $d440
    ld a, a
    nop
    ldh [$09], a
    or $ff
    ld bc, $209e
    ld [$9011], sp
    ld a, [hl+]
    ld b, c
    ld b, b

jr_003_5368:
    inc hl
    inc a
    ret nz

    ld h, e
    add b
    rra
    nop
    add e
    ld hl, $2058
    and d
    rra
    ld h, b
    call c, $feff
    rst $38
    rst $38
    rst $38
    rst $18
    rst $38
    add [hl]
    ld a, a

Jump_003_5380:
    ld hl, sp+$07
    add b
    rlca
    ret nz

    inc b
    db $10
    inc b
    dec d
    ld c, $00
    inc b
    inc b
    nop
    nop
    add h
    and b
    inc d
    cp $01
    ei
    add h
    pop af
    ld c, [hl]
    or l
    adc a
    db $fc
    inc bc
    pop de
    ld [bc], a
    add b
    ld l, e
    add b
    cp a
    ld c, b
    rst $10
    ld sp, $23ce
    ld a, h
    adc d
    rst $38
    inc e

jr_003_53ab:
    ccf
    jp z, Jump_000_11dd

    and b
    db $e4
    rra
    ret nc

    ccf
    sub b
    ld l, a
    ld d, b
    rst $38
    ld h, b
    cp [hl]
    ld d, c
    db $ec
    di
    rrca

jr_003_53be:
    ret nz

    jr c, jr_003_5368

    ld a, [$f57d]
    ei
    ld a, [c]
    ld a, a
    push af
    adc $3e
    rst $38
    rlca
    xor a
    ld a, [c]
    rst $38
    ld sp, hl
    rst $20
    db $fc
    inc de
    rst $28
    ld b, b
    sub d
    ld [bc], a
    ld [hl+], a
    push de

jr_003_53d9:
    nop
    add b
    ld d, c
    xor [hl]
    rst $18
    ld sp, $210e
    db $10
    ld c, $24
    ld [hl], l
    cp $fd
    nop
    ld e, a
    cp $ed
    db $fc
    di
    db $fd
    rst $38
    ld hl, sp+$73
    cp $fd
    inc bc
    ld e, h
    db $e3
    dec hl
    rst $38
    jr c, jr_003_53be

    cp e
    rst $38
    sbc a
    rst $38
    xor a
    rst $18
    ld d, a
    db $ed
    ld a, e
    inc h
    db $10
    cp $01
    cp $00
    ld a, a
    add c
    ld a, $c0
    ld e, a
    pop hl
    rst $28
    ld [hl], b
    add hl, de
    ld b, b
    ld bc, $00f6

jr_003_5416:
    ld b, l
    jr nc, jr_003_53d9

    ld a, [hl+]
    ld h, b
    ldh [$e0], a
    add b
    jr nc, jr_003_5460

    sub h
    ld [hl], b
    ldh a, [$f5]
    di
    ld d, a
    ld b, b
    jr nz, jr_003_53ab

    inc b
    rst $10
    rst $20
    rst $30
    cpl
    ld [$1558], sp
    add d
    add h
    ld h, l
    add b
    ret nz

    ldh [$e0], a
    rrca
    rrca
    rrca
    rra

jr_003_543c:
    ccf
    rra
    rra
    ccf
    ld a, a
    ccf
    ld c, $c0
    or d
    ret nz

    ld c, h
    ldh a, [$f0]
    ldh a, [$f8]
    db $fc
    ld hl, sp-$08
    db $fc
    cp $fc
    db $fc
    cp $fe
    cp $ff
    cp $00
    ld de, $b401
    dec hl
    jr jr_003_5416

    ld a, b
    ret nz

jr_003_5460:
    ld hl, sp-$47
    pop bc
    ld h, e
    add a
    ld b, e
    add d
    rlca
    nop
    nop
    ld b, $80
    ld b, $47
    add b
    rst $20
    rlca
    db $10
    cp b
    adc b
    ret nz

    db $d3
    rst $18
    cp a
    ld b, b
    ld l, b
    ld [bc], a
    ld b, d
    and b
    ld hl, sp-$05
    ei
    dec de
    inc e
    ld h, b
    ld sp, hl
    rst $38
    rst $20
    rst $38
    db $db
    rla
    nop
    xor [hl]
    xor $ff
    cp c
    rst $38
    ld h, a
    ld sp, hl

jr_003_5491:
    reti


    ldh [rNR11], a
    add c
    ld bc, $0c02
    dec b
    ld c, $0a
    inc c
    ld b, $08

jr_003_549e:
    sbc b
    jr nc, @-$4a

    ld b, d
    jr c, jr_003_543c

    ld a, b
    ldh [rNR24], a
    jr @+$3c

    inc b
    ld b, [hl]
    pop bc
    jr z, @+$42

    nop
    ld d, b
    ld h, b
    ld h, b
    ld [hl], b
    inc [hl]
    ld a, b
    ld d, d
    cp h
    ld e, h
    cp a
    and e
    sbc a
    cp h
    add e
    sbc a
    cp a
    cp a
    sbc a
    adc a
    sbc a
    add a
    adc a
    add a
    add a
    add e
    add e

jr_003_54c9:
    add b
    ld h, c
    ldh [rSVBK], a
    sub b
    jr nz, jr_003_5491

    ccf
    rst $38
    ld a, a
    sbc $3f
    ld a, [$36bf]
    ccf
    dec [hl]
    ld a, $2a
    inc a
    jr nz, jr_003_551b

    inc d
    jr c, @+$36

    jr c, jr_003_54e8

    jr c, jr_003_549e

    ld b, l
    adc [hl]

jr_003_54e8:
    and b
    nop
    sub c
    ld e, b
    db $fc
    ld [$d51d], a
    rst $08
    ld a, [bc]
    rlca
    dec b
    ld [bc], a
    ld b, $00
    ld b, b
    inc bc
    add b
    ld c, b
    ldh [$3f], a
    call c, $835f
    sbc a
    call c, $8343
    ldh [rP1], a
    jr nz, jr_003_5508

jr_003_5508:
    nop
    nop
    nop
    ld [hl+], a
    nop
    ld [$0541], sp
    jr nc, jr_003_5553

    rlca
    xor e
    call z, $8b51
    and b
    ld bc, $5e7b

jr_003_551b:
    ld h, b
    ld e, e
    ld b, b
    or h
    nop
    jp hl


    add b
    db $d3
    ld b, a
    add d
    ld e, h
    ld b, b
    or h
    nop
    jp hl


    add b
    pop de
    inc hl
    sbc h
    and b
    db $10
    ld d, $20
    dec e
    jr nz, @-$64

    jr nz, jr_003_54c9

    sbc a
    ld h, b
    rrca
    ldh a, [$1f]
    ldh [$86], a
    ld [bc], a
    xor b
    add a
    or h
    cp b
    ld b, b
    ld h, [hl]
    sbc c
    ld [hl+], a
    call c, $dc23
    scf
    ret


    db $10
    call nz, $054f
    ld h, h
    ld [hl], b
    ld c, h

jr_003_5553:
    ld b, $e6
    push bc
    add a
    nop
    sub b
    ld de, $9016
    add c
    ldh [$98], a
    ld l, a
    nop
    rst $38
    ld b, b
    ld [$cbe0], sp

jr_003_5566:
    or a
    adc a
    db $e3
    rst $30
    ld [hl], h
    ld a, b
    adc h
    cp $84
    inc b

jr_003_5570:
    ld b, b
    push de
    nop
    ccf
    ld [bc], a
    db $fc
    inc l
    or b
    rst $00
    rst $28
    rst $28
    rra
    db $fc
    add d
    sub b
    ld [$3ec1], sp
    sub $0e
    pop bc
    dec bc
    add d
    nop
    ld de, $a020
    ld [bc], a
    db $fc
    inc bc
    ld e, $00
    ld [bc], a
    ld d, b
    nop
    and b
    jr z, jr_003_5566

    cpl
    ret nz

    rla
    sub $5b
    sub h
    db $db
    db $10
    jr jr_003_5570

    cp e
    rst $00
    dec de
    ld [c], a
    rla
    db $fc
    rrca
    ld hl, sp+$0f
    ldh [rIF], a
    inc d
    add b
    dec d
    cp d
    jp c, $e57d

    ld e, [hl]
    inc hl
    ld e, $81
    ld e, a
    ld h, c
    inc h
    add b
    ld [hl], l
    add hl, bc
    call nz, $1011
    inc d
    jr jr_003_55d0

    add b
    ld e, $5f
    add e
    rra
    and b
    rst $18
    inc [hl]
    ld a, b
    adc h
    ld e, [hl]
    db $e4
    ld a, $e2

jr_003_55d0:
    ld e, $e3
    cp [hl]
    ld [hl+], a
    nop
    ld [hl], b
    rst $38
    dec c
    cp $03
    nop
    and d
    ld a, a
    ldh [$1f], a
    ldh a, [rVBK]
    ret nz

    ld l, a
    ret nz

    ld l, a
    and b
    rst $28
    add b
    ld a, a
    ld bc, $4007
    sbc b
    ld b, c
    ld a, $c1
    ld a, $61
    ld [hl], b
    call z, RST_28
    xor h

jr_003_55f7:
    add h
    and b
    rra
    add b
    rst $18
    ld d, b
    rst $28
    jr z, jr_003_55f7

    inc b
    ei
    ld a, [bc]
    db $fd

jr_003_5604:
    adc h
    inc b

jr_003_5606:
    cp h
    and h
    jr jr_003_5662

    cp e
    ld hl, $4004
    ld d, l
    inc l
    xor h
    db $dd
    ret c

    ld a, $21
    cp $00
    db $fd
    ld [bc], a
    db $fd
    ld [hl-], a
    inc b
    ld [$bc02], a
    inc hl
    ld a, h
    ld h, b
    and b
    db $10
    inc sp
    db $10
    pop bc
    rlca
    jr jr_003_5604

    ldh a, [rNR42]
    jr nz, jr_003_5606

    sub l
    inc bc
    ld bc, $2b00
    ld a, h
    nop
    ld hl, sp+$19
    ld [$d51d], sp
    dec a
    ld h, a
    db $fd
    ld [de], a
    add b
    ldh [rSC], a
    ld b, $a5
    ld b, b
    nop
    ld hl, sp-$73
    ld h, b
    rra
    add sp, -$29
    ld hl, $f816
    add a
    scf
    ld h, c
    xor h
    add h
    ld [hl], c
    nop
    ld a, b
    db $fd
    ld a, [bc]
    db $fd
    dec bc
    db $fc
    ld bc, $05fc
    ei
    ld [$10f7], sp

jr_003_5662:
    rst $28
    db $10
    add hl, de
    ld d, d
    inc bc
    ld sp, hl
    nop
    ld hl, sp+$06
    rst $38
    add $3a
    rlca
    ld sp, hl
    scf
    ld e, b
    nop
    ld b, d
    ld b, c
    cp a
    ld b, b
    ld a, a
    add b
    rst $38
    add b
    cp a
    sub b
    cp a
    xor a
    ld e, a
    sub b
    cpl
    ld h, a
    ldh [rBCPS], a
    and a
    ld d, c
    ld l, a
    and b
    rst $18
    add b
    cp a
    ld b, b
    ld b, [hl]
    add b
    ei
    ld a, [$8201]
    nop
    add hl, hl
    pop bc
    xor d
    ld b, l
    call z, $ce23
    ld hl, $1bee
    nop
    pop de
    xor b
    ld c, a
    ret nc

    cpl
    ldh [$1f], a
    ldh a, [$03]
    add b
    ld [$2f84], sp
    ret nz

    ld c, a
    jr nz, jr_003_56b0

jr_003_56b0:
    nop
    ld l, b
    nop
    dec d
    ld h, d
    ld [$7191], a
    ld [$07fa], sp
    jr nz, @-$2a

    rlca
    ld [$0088], sp
    inc bc
    add d
    ld [hl], c
    ld [$f4f0], sp
    ld [$c584], sp
    sbc c
    and h
    jr @+$13

    inc c
    add $64
    add l
    ret z

    ld [de], a
    pop bc
    rrca
    ret nz

    rst $28
    ld bc, $4890
    or c
    ret z

    inc h
    jp $d827


    db $10
    ld h, b
    call nc, Call_000_081f
    ld d, h
    ld b, d
    add b
    ld e, a
    add b
    ld b, d
    add b
    rra
    add b
    ld h, c
    sbc [hl]
    call nz, Call_000_0c20
    inc h
    di
    inc bc
    add sp, $01
    sbc b
    inc bc
    ret c

    ld bc, $4868
    ld [$dd90], sp
    inc bc
    inc c
    rrca
    nop
    sbc l
    xor $ff
    rst $00
    rst $38
    add hl, de
    and $ef
    rrca
    add b
    ld e, b
    sbc b
    rlca
    cp d
    dec b
    xor h
    inc bc
    xor [hl]
    ld bc, $038c
    sbc d
    dec b
    ret c

    rlca
    call c, $4a03
    cp a
    ld [bc], a
    rst $38

jr_003_5725:
    ld c, d
    cp a
    xor b
    ld e, a
    ld bc, $abff
    ld e, a
    add d
    ld a, a
    ld b, b
    cp a
    rst $28
    ld hl, $9401
    sbc a
    nop
    jr nz, jr_003_5725

    db $fd
    cp a
    db $fc
    cp a
    ld d, $00
    sbc l
    ld a, d
    inc bc
    nop
    ld de, $bfef
    jp z, $eb9f

    sbc a
    ld a, [hl]
    nop
    ld c, h
    ret


    ld a, h
    rst $38
    ld l, a
    add b
    cp a
    ld b, d
    pop bc
    ld d, e
    add b
    ld c, b
    inc a
    ld [$5404], sp

jr_003_575c:
    ld h, c
    ld b, c
    ldh a, [rIF]
    nop
    add h
    push bc
    inc bc
    nop
    rrca
    inc b
    sub a
    or c
    inc hl
    nop
    db $10
    push af
    rra
    nop
    ld a, b
    add d
    db $fd
    ld a, a
    add b
    daa
    nop
    jp nz, Main

    ld [hl], b
    inc b
    add hl, bc
    inc b
    ld c, h
    ld [hl], l
    ld b, b
    add $80
    rst $38
    ld e, $7f

jr_003_5785:
    inc a
    ld b, b
    ldh [$c3], a
    ld [de], a
    inc b
    ld b, b
    jp $effd


    rra
    nop
    inc h
    db $e4
    rst $28
    ld a, a
    jp $a13f


    ld [hl], b
    xor $1e
    pop hl
    add hl, de
    and $0b
    call c, $8000
    ld b, $c4
    cpl
    nop
    ld d, b
    ld b, a
    ld a, b
    nop
    ldh [rSB], a
    ld h, b
    ld b, b
    nop
    jr @+$0e

    nop
    sbc h
    ld a, [hl]
    add b
    cp [hl]
    ld b, b
    ld e, $60
    ld d, [hl]
    jr c, @+$2e

    ld e, $08
    ld b, $18
    add b
    xor h
    ret c

    ld d, b
    db $ec
    ld c, $71
    sbc l
    sbc a
    xor $61
    pop hl

jr_003_57cc:
    nop
    ld d, c
    sub b
    or l
    ld c, a
    ld d, b
    ld a, $00
    ret c

    push bc
    ld [hl], b
    ld a, a
    pop bc
    nop
    jr jr_003_575c

    add e
    jp Jump_000_1c10


    inc h
    rst $00
    rst $38
    add h
    inc bc
    ld h, d
    jp nz, Jump_003_5bc1

    ld bc, $fc27
    ld b, $ff
    ld [bc], a

jr_003_57ef:
    ld a, a
    add h
    ld a, e
    add c
    cp e
    jp nz, $e2d9

    ld b, c
    ld sp, hl
    or b
    ld a, b
    jr z, jr_003_5785

    ld [$3480], sp
    ld h, $34
    dec hl
    sbc b
    add h
    cp a
    ret nz

    ld e, a
    ldh [$6f], a
    ldh a, [$b3]
    ld a, h
    ld e, h
    add hl, bc
    add b
    or e
    ld bc, $f85d
    ldh a, [$ea]
    rla
    ld e, b

jr_003_5818:
    jr nc, jr_003_5872

    ld d, $ef
    jr nz, jr_003_586e

    add h
    add d
    ld d, d
    jr c, jr_003_57ef

    inc bc
    rst $38
    ld b, b
    ld d, b
    ld a, h
    jp $44c0


    ld a, b
    adc b
    daa
    jr z, jr_003_57cc

    ld [hl], e
    adc h
    inc b
    ld a, e
    sbc [hl]
    ld h, c
    jp $d261


    inc a
    jp $00c3


    nop
    ld [de], a
    inc hl
    ld [de], a
    dec c
    adc h
    ld b, e
    or b

jr_003_5845:
    ld h, e
    sbc h
    pop bc
    jp nz, Jump_000_38d4

    rlca
    jp Jump_003_4040


    ld bc, $1291
    add c
    nop
    cp [hl]
    ret nz

    sbc a
    ldh [$df], a
    pop hl
    ld l, [hl]
    ldh a, [$30]
    ld a, [hl]
    ld l, $1e
    ld a, [bc]
    ld b, $02
    nop
    cp $27
    sub d
    ld a, b
    add a
    rst $38
    sbc a
    ld [bc], a
    inc bc
    inc h

jr_003_586e:
    inc a
    call nz, Call_000_11eb

jr_003_5872:
    ld h, $24
    jr nc, jr_003_58d7

    cp a
    ret nz

    dec a
    jp nz, $b807

    pop hl
    nop
    ld [$1e01], a
    cp $81
    ld [hl], b
    ldh [$85], a
    pop af
    ld c, $c7
    jr c, @+$06

    ld b, b
    ld [hl], $1c
    jr nz, jr_003_5818

    rlca
    cp a
    ld b, b
    ld a, l
    add d
    db $fc
    inc bc
    cp $01
    adc c
    ld [bc], a
    ld sp, $081c
    inc bc
    or b
    ld a, $c0
    add e
    ld a, l
    ld [$7787], sp
    ccf
    ret nz

    add e
    ld a, h
    ldh [$1f], a
    db $fc
    inc bc
    jr jr_003_58b1

jr_003_58b1:
    inc bc
    dec bc
    add c

Call_003_58b4:
    dec a
    inc d
    ld [$0a10], sp
    inc bc
    nop
    ld hl, sp+$40
    ld [$9702], sp
    ld hl, $8780
    jr nz, jr_003_5845

    rrca
    nop
    ld a, [bc]

jr_003_58c8:
    db $e4
    inc b
    inc bc
    pop hl
    nop
    ld [$6801], sp
    adc b
    ld c, $00
    nop
    add e
    ld b, $aa

jr_003_58d7:
    inc e
    add c
    call nz, $681f
    ld h, b
    jp c, $8540

    dec b
    ld h, c
    ret nz

    ld e, e
    ld bc, $20be
    ld h, b
    dec bc
    ld sp, hl
    ld [bc], a
    add d
    ld c, c
    cp a
    ld b, b
    rst $38
    inc bc
    nop
    xor a
    cpl
    db $10
    call z, $8183
    ld [bc], a
    ld hl, $340c
    ld a, [hl-]
    push bc
    jp Jump_000_39fe


    db $fc
    inc sp
    inc d
    inc e
    cp l
    ld b, e
    ld e, h
    db $e3
    xor h
    ldh a, [$57]
    cp e
    rst $38
    inc bc
    ld a, h
    add e
    cp h
    ld b, e
    db $fc
    inc hl
    db $f4
    dec de
    db $f4
    rrca
    ld d, b
    inc b
    ld de, $e806
    ld bc, $fe63
    pop hl
    rra
    ld hl, sp+$07
    ldh [$1f], a
    db $ec
    rra

jr_003_5929:
    add sp, $1f
    call nz, $d03b
    dec sp
    xor b
    ld [hl], e
    ld h, b
    di
    nop
    db $fd
    ld b, e
    add d
    add e
    nop
    ld l, a
    db $e4
    ldh a, [$cd]
    add sp, $71
    ldh [$80], a
    sub b
    jr z, jr_003_58c8

    ld a, a
    add b
    sbc a
    ldh [rIE], a
    rst $38
    ret c

    ccf
    rrca
    adc c
    ld hl, $8808
    inc d
    db $ec
    ld b, e
    add b
    rra
    inc bc
    ld l, h
    jr nz, jr_003_59ba

    adc d
    ld [$b307], sp
    cp $01
    ld hl, sp+$07
    ld a, [$f407]
    rrca
    db $ec
    rra
    sbc d
    ld a, l
    ld [hl], h
    ld hl, sp-$27
    pop hl
    add hl, hl
    ldh a, [$d1]
    ldh [rNR42], a
    pop bc
    add c
    ld l, $52
    ld [hl], b
    push de
    sub b
    jp hl


    inc bc
    inc e
    ld hl, sp+$07
    rst $38
    ret nz

    nop
    ld l, b
    ld [hl], l
    jr nz, @+$01

    ld [hl], b
    rst $28
    ret nc

    xor $b1
    pop bc
    rst $38
    ld c, $ff
    inc bc
    db $fc
    rrca
    add b
    inc bc
    adc h
    cpl
    ld de, $2980
    ld [hl], b
    adc b
    ld a, b
    add b
    ld l, c
    db $10
    ld h, e
    db $10
    ld e, h
    jr nz, jr_003_5929

    ld hl, $4c04
    ld a, [de]
    ld hl, sp+$0f
    ldh a, [rIE]
    rlca
    ldh a, [rIF]
    add sp, $1f
    ret c

    scf
    ld [hl], b
    rst $20
    ret nz

    add l
    inc bc
    dec b
    sub [hl]

jr_003_59ba:
    ld [$0060], sp
    inc bc
    inc bc
    ld [bc], a
    ld [de], a
    adc [hl]
    jr nz, jr_003_5a24

    pop de
    cpl
    ret nc

    dec sp
    ld b, h
    cp [hl]
    pop bc
    ccf
    add b
    ld a, $c1
    ld b, $38

jr_003_59d1:
    ld [hl], b
    ld b, e
    ld b, b
    ret nz

    ld bc, $01fe
    ldh a, [$0b]
    adc d
    ld c, b
    xor $01
    pop bc
    ld a, b
    dec bc
    ld [$010e], sp
    nop
    ret c

    ld b, b
    db $10
    add hl, bc
    daa
    jr nz, jr_003_59f0

    rrca
    adc b
    ld b, $00

jr_003_59f0:
    ld c, $06
    inc b
    ld [bc], a
    inc c
    ld b, d
    ld d, b
    ld d, b
    ld [bc], a
    nop
    inc b
    inc bc
    ld h, d
    ld a, [bc]
    add d
    add e
    ld bc, $83c0
    ld b, c
    add d
    pop bc
    nop
    nop
    sbc b
    ld [$8082], sp
    jr nz, jr_003_5a0e

jr_003_5a0e:
    add b
    jr nz, jr_003_59d1

    jr nz, @-$4e

    ld h, c
    ld h, b
    or $e1
    ld sp, hl
    rla
    nop
    nop
    nop
    nop
    ld [bc], a
    jr nc, jr_003_5a23

    ret nz

    ld [hl-], a
    ld d, c

jr_003_5a23:
    or l

jr_003_5a24:
    or e
    ei
    rst $30
    rst $38
    rrca
    dec b
    ld [bc], a
    ld a, [bc]
    add a
    rlca
    cp $07
    sbc [hl]
    ld a, [hl]
    ld a, a
    ld a, a
    ld [de], a
    add c
    adc c
    nop
    ld [hl], b
    adc c
    adc b
    cp $d9
    add hl, sp
    inc d
    pop bc
    rst $38
    sbc a
    ld a, a
    ccf
    ld bc, $f640
    ld sp, hl
    push af
    ld sp, hl
    di
    db $fd
    ei
    db $fd
    rst $38
    rst $38
    dec d
    nop
    ld [$0684], sp
    ld c, d
    ld d, b
    add b
    ld e, $9f
    pop bc
    di
    pop bc
    db $db
    db $fd
    cp a
    db $fd
    dec a
    cp $15
    ld bc, $58d9
    ld de, $021e
    ld h, a
    ret nz

    ld l, e
    cp h
    rlca
    xor b
    push bc
    db $d3
    db $e3
    rst $38
    inc bc
    ld hl, sp+$4d
    nop
    adc [hl]
    rst $20
    dec a
    ld hl, sp+$3f
    db $fc
    ld e, $7c
    dec l
    sbc [hl]
    inc sp
    call z, $c738
    ld e, a
    inc bc
    ldh [$0a], a
    ld de, $10e1
    pop hl
    or b
    ld b, c
    db $ec
    rrca
    add b
    ld h, b
    ld hl, $e0de
    ld e, $f2
    inc c
    ld a, $00
    ld h, h
    adc c
    add b
    or e
    nop
    xor b
    add sp, $0d
    ret nc

    db $ec
    rst $28
    rst $38
    rst $28
    rst $38
    rst $28
    db $fd
    rst $28
    pop af
    rst $08
    ldh a, [$1f]
    db $ec
    ld d, e
    add d
    and c
    db $dd
    or e
    db $db
    sub a
    di
    cpl
    db $d3
    ld a, a
    adc b
    scf

jr_003_5abf:
    rst $08
    db $10
    ld [c], a
    call Call_000_13fc
    db $e4
    inc sp
    add $f1
    add hl, bc
    or $08
    sub a
    ld [$df97], sp
    ld [de], a
    ld b, b
    ld e, b
    sbc h
    pop hl
    rlca
    db $fc
    dec hl
    sbc $e9
    add hl, de
    sub [hl]
    ld l, c
    ld d, [hl]
    inc b
    ret z

    ld [c], a
    ld b, b
    ld e, b
    inc a
    ld c, $00
    jp nz, $cff3

    ret


    scf
    call nz, $07fb
    ld hl, sp+$3d
    ret nz

    rst $28
    ld [bc], a
    or b
    inc sp
    ccf
    inc bc
    add b
    add a
    ld a, b
    add hl, bc
    ld a, $83
    cp a
    rst $00
    rst $28
    set 6, a
    ld b, $60
    or b
    jr jr_003_5abf

    call nz, $4401
    ld e, b
    nop
    daa
    rst $28
    ld [bc], a
    inc b
    ld h, b
    add b
    ld bc, $5c81
    or h
    dec bc
    inc c
    ldh a, [$15]

Jump_003_5b1a:
    ld [$c0c3], sp
    call nz, Call_003_7018
    ld [de], a
    db $fd
    inc bc
    ld [bc], a
    sub c
    ret z

    rrca
    add b
    scf

jr_003_5b29:
    ld [$0ba8], sp
    ld a, b
    ld [hl], $0d
    ld a, [c]
    inc c
    db $d3
    daa
    add b
    ld [hl], b
    ret nz

    jr nc, @+$72

jr_003_5b38:
    or b
    nop
    ld [hl], h
    ld l, d
    rst $30
    sub b
    ld l, h
    dec hl
    ret c

    daa
    ret c

    ld [hl], a
    adc h
    di
    rrca
    ld h, b
    ld e, $60
    ld e, $78
    adc b

jr_003_5b4d:
    ld [$18a0], sp
    ld a, [de]
    rlca
    db $10
    cp l
    sub b
    scf
    jr nz, jr_003_5b38

    add [hl]
    inc bc
    ld bc, $3840
    dec bc
    ld [$dd1a], sp
    ld bc, $c324
    jr nz, jr_003_5b29

    call nz, $6c01
    ld [bc], a
    db $fc
    ld l, $00
    sub b
    ld [hl-], a
    ld [bc], a
    dec b
    ld a, [hl]
    jr c, @+$0a

    ld a, [bc]
    add h
    ld h, c
    ld h, b
    nop
    add b
    ld hl, $03bd
    ld h, h
    dec de
    ld h, [hl]
    jr jr_003_5b8e

    nop
    ld d, d
    jr c, @+$22

    inc hl
    ld a, a
    ld [bc], a
    db $fc
    ld b, a
    cp c
    ld a, c
    add a

jr_003_5b8e:
    sbc c
    ld h, [hl]
    inc de
    ld bc, $48b6
    adc b
    scf
    jp $c82f


    ld h, a
    adc h
    sub e
    ld l, a
    db $10
    rst $28
    db $10
    jp hl


    ldh a, [$09]
    ldh a, [rSB]
    jr nz, jr_003_5bb8

    ld bc, $80b4
    ld [hl], l
    ld sp, Entry
    xor l
    or b
    nop
    ld b, b
    daa
    sbc [hl]
    ld h, e
    inc e
    db $e3
    sbc b

jr_003_5bb8:
    ld h, a
    ld hl, sp+$06
    jr jr_003_5be4

    nop
    adc b
    ldh a, [rNR10]

Jump_003_5bc1:
    ldh [$d3], a
    rst $28
    db $d3
    adc a
    pop hl
    nop
    jr jr_003_5b4d

    push hl
    or c
    rst $00
    ld e, a
    sub b
    adc a
    db $10
    ld e, b
    add a
    call nz, Call_003_4001
    ld [hl], b
    nop
    jr nz, jr_003_5bf2

    ld [$a1c6], sp
    ld b, c
    ld b, b
    ret nc

    ret


    ld h, $10
    ld [hl], b

jr_003_5be4:
    dec d
    or b

jr_003_5be6:
    ld a, [bc]
    jr nz, jr_003_5be9

jr_003_5be9:
    ld a, b
    adc b
    ld a, a
    ld bc, $4281
    db $fc
    add hl, bc
    nop

jr_003_5bf2:
    ld c, $58
    jr nz, jr_003_5be6

    db $10
    inc bc
    jp nz, $8500

    db $f4
    ld [$ac10], sp
    ld h, c
    ld e, b
    ld b, b
    db $10
    ld b, $02
    add b
    ld h, d
    ld a, b
    db $10
    db $10
    ld e, h
    ld [hl-], a
    rrca
    or b
    rrca
    ld hl, sp+$07
    ld h, b
    sbc [hl]
    ld b, c
    cp [hl]
    pop bc
    dec sp
    ld h, b
    inc e
    ld [$007c], sp
    nop
    and e
    db $10
    ld l, a
    or a
    adc a
    rst $10
    xor a
    jp $887f


    or a
    dec e
    ld h, d
    cp e
    rlca
    nop
    ld b, b
    ld c, h
    ld b, h
    nop
    ld hl, $102f
    ldh [rRP], a
    and b
    cpl
    ccf
    nop
    or b
    add [hl]
    call nz, $c83b
    scf
    inc b
    add b
    xor a
    inc bc

Call_003_5c44:
    adc [hl]
    ld bc, $80bf
    ld l, a
    sbc a
    rrca
    ld a, a
    ld b, $ff
    ld a, d
    db $fc
    ld a, a
    db $fc
    ld a, l
    db $fc
    ld a, c
    db $fc
    rrca
    ldh a, [rP1]
    adc e
    nop
    ret nz

    call $0404
    ld a, [c]
    ld h, [hl]
    ld [bc], a
    ld [bc], a
    ld l, [hl]
    add [hl]
    ld bc, $a780
    inc b
    inc bc
    ld b, l
    ld [bc], a
    ld e, [hl]
    nop
    ld [hl], $08
    ld h, e
    inc e
    dec b
    jr nz, jr_003_5ca9

    ld b, $a8
    adc e
    ld [hl], h
    inc bc
    rst $38
    ld h, b
    ld a, [hl+]
    nop
    add d
    rst $30
    rst $08
    or a
    adc a
    scf
    ld c, a
    ld l, $df
    rra
    cp $1e
    db $fc
    dec l
    ret nc

    scf
    nop

jr_003_5c8f:
    ld b, h
    nop
    and b
    ld [hl+], a
    db $10
    and c
    ld sp, $33c0
    ret nz

    ld b, e
    ld hl, $0a20
    inc bc
    ld e, $e1
    inc c
    add e
    ld l, h
    add e
    ld [hl], a
    add b
    ld hl, $1400

jr_003_5ca9:
    call $c832
    ld [hl], $f2
    rrca
    ld [hl-], a
    adc $11
    xor $19
    and $23
    call c, $3ddb
    xor $00
    ld e, a
    add c
    rst $18
    add c
    rst $38
    add c
    ccf
    inc sp
    ld [bc], a
    ld l, b
    add [hl]
    cp a
    ld bc, $a800
    inc b
    ld e, b
    add hl, bc
    sbc l
    ld de, $2030
    ldh [$94], a
    ld h, [hl]
    sub b
    ld l, a
    ld h, b
    ld e, a
    nop
    ld l, b
    rst $00
    jr c, @-$7e

    db $fd
    ld bc, $3580
    add [hl]
    ld a, e
    add h
    ld a, b

jr_003_5ce5:
    adc b
    ld [hl], h
    call nz, $f43f
    rrca
    ret z

    inc [hl]
    rla
    ld hl, sp+$77
    ld a, [$f129]
    xor a
    jp $57df


    inc b
    jr nz, jr_003_5ce5

    inc de
    ld e, b
    nop
    jr z, jr_003_5c8f

    ld bc, $6092
    nop
    ldh a, [rTMA]
    add b
    ld h, e
    inc bc
    ldh a, [$30]
    nop
    ld [$803b], sp
    add a
    ld bc, $d100
    add b
    ccf
    inc h
    rst $00
    jr nz, @-$37

    ldh a, [rTAC]
    sbc b
    ld h, e
    jr nc, jr_003_5d1e

jr_003_5d1e:
    jr nc, @+$5a

    ld [$0d6c], sp
    inc b
    nop
    pop hl
    jr nz, jr_003_5d28

jr_003_5d28:
    ld hl, sp-$7b
    rra
    nop
    adc b
    jp nz, $b844

    ld b, a
    cp b
    ld c, a
    or b
    ld sp, $208e
    rra
    and $9f
    sub b
    ld b, $20
    add h
    ld a, e
    ret z

    inc [hl]
    rst $30
    inc c
    rla
    rst $28
    nop
    cp $cd
    ldh a, [$7b]
    cp $79
    cp $79
    db $fc
    ld a, a
    ei
    or a
    ei
    rst $20
    add e
    ccf
    add e
    ld a, a
    inc bc
    add sp, -$0f
    rst $10
    ld [c], a
    db $dd
    add a
    inc b
    ldh [$ae], a
    and b
    ld a, $0e
    jr nz, jr_003_5d71

    ld [Entry], sp
    ld [bc], a
    ld [hl], $74
    rrca
    nop
    db $fc
    dec d

jr_003_5d71:
    ret nz

    jp nz, Jump_003_5380

    inc c
    ld bc, $5001
    or h
    rrca
    inc e
    ld b, c
    ld b, b
    ld b, l
    sbc h
    rrca
    nop
    ld c, h
    ld bc, $0006
    ld b, $24
    nop
    ld [$0070], sp
    inc hl
    nop
    inc bc
    dec b
    ld b, b
    xor d
    rst $28
    add b
    ld b, b
    sub d
    add hl, bc
    ld b, $1f
    ret nz

    inc de
    call z, $1e01
    pop hl
    sbc $ff
    ld [bc], a
    and b
    ld de, $0837
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld a, [hl]
    rrca
    nop
    ld l, e
    rst $00
    jr c, jr_003_5db3

    add b
    inc hl

jr_003_5db3:
    inc c
    ld b, b
    db $f4
    inc bc
    ld [hl], b
    add d
    ld [hl], c
    add d
    pop af
    rlca
    ldh [$0c], a
    inc bc
    nop
    ret nz

    ret nc

    ld [$c398], sp
    inc b
    ld b, b
    add sp, $06
    add b
    add hl, bc
    ret nz

    ld e, a
    nop
    call c, $ecc4
    nop
    and b
    rra
    ld c, [hl]
    jr nc, jr_003_5e24

    ld [hl-], a
    cp b
    rla
    ld [bc], a
    sub e
    jr nc, jr_003_5dff

    sbc b
    inc bc
    nop
    rrca
    inc b
    db $fc
    or b
    rlca
    add b
    ld [hl], b
    rst $28
    add hl, de
    ld h, $dc
    add e
    jp hl


    sub a
    di
    cp a
    db $db
    ld [hl], a
    adc e
    sub a
    inc d
    ld h, e
    sub b
    rrca
    and $1f
    rst $28
    ld a, a
    cpl

jr_003_5dff:
    inc hl
    add b
    ldh a, [$f7]
    ccf
    ei
    or a
    rlca
    ld h, b
    nop
    ld [hl], h
    jp $6e00


    ret z

    inc [hl]
    srl e
    inc a
    jp z, $e01d

    rst $08
    db $fc
    di
    ld bc, $09f0
    db $10
    ld sp, hl
    nop
    ld [hl], b
    call nz, $037c
    ld h, e
    inc e

jr_003_5e24:
    ld b, c
    cp [hl]
    add hl, de
    cp $19
    ldh [rNR24], a
    ldh [$3f], a
    ret nz

    jr c, jr_003_5e77

    sub b
    ld l, a
    ret nc

    rst $28
    inc h
    db $db
    ld e, e
    cp h
    db $ec
    adc h
    nop
    ret z

    pop bc
    nop
    ld b, e
    add b
    ei
    ld [bc], a
    call $2c33
    inc de
    jr jr_003_5e4a

    ld a, b
    db $fd

jr_003_5e4a:
    or h
    ld a, d
    cp h
    inc bc
    ld c, b
    db $e4
    and b
    inc de
    rlca
    xor h
    ld hl, $ffde
    cp $df
    db $ed
    rst $18
    rst $20
    pop bc
    db $fc
    pop bc
    ld a, $40
    sbc a
    adc a
    rst $30
    rrca
    di
    ld b, a
    ld a, [$7dc1]
    ld b, l
    ld b, $af
    ld [bc], a
    ld a, d
    ld hl, $01fe
    jp nz, $f93d

    cp $3c

jr_003_5e77:
    rst $38
    inc a
    rst $38
    jr c, @+$01

    ld hl, $1cde
    ld b, e
    xor e
    add a
    rst $30
    jp $c3ff


    ei
    ld b, c
    db $fd
    add b
    ld b, [hl]
    ld [bc], a
    and b
    or $f9
    ldh a, [rTAC]
    add b
    ld l, c
    xor a
    rra
    rst $38
    rra
    rst $18
    rra
    rst $08
    rra
    ld hl, sp+$07
    sbc a
    nop
    db $e3
    inc e
    inc hl
    call c, $ec13
    ld [de], a
    ld bc, $0258
    rst $00
    ld bc, $03f6
    inc b
    nop
    ld h, b
    ld b, h
    nop
    add d
    ld h, a
    nop
    or b
    ld [$6603], sp
    dec b
    ld h, h
    ld [hl], d
    rrca
    xor b
    rra
    cp b
    rra
    ld hl, sp+$1f
    ret z

    rra
    ldh a, [rIF]
    add sp, $6f
    nop
    jp nc, $6199

    sbc d
    ld h, b
    ld a, a
    add d
    ld h, e
    sbc [hl]
    ld b, e
    cp h
    jp Jump_000_233c


    sbc $dd
    ld [c], a
    pop hl
    ld bc, $4ff0
    inc b
    ldh [$0c], a
    sbc c
    ld h, c
    sbc d
    ld h, b
    rst $30
    nop
    add a
    ld bc, $1302
    ld bc, $057b
    pop de
    add b
    inc bc
    ld bc, $0163
    sub l

jr_003_5ef6:
    ld l, [hl]
    pop af

jr_003_5ef8:
    call c, Call_000_0822
    rst $30
    ldh [$fe], a
    push af
    ld a, [$f977]
    add h
    ld a, d
    call z, Call_000_0232
    ld bc, $8062
    dec a
    ret nz

    daa
    ret c

    ld h, a
    sbc b
    rst $38
    ld bc, $00de
    rst $08
    nop
    pop hl
    ld b, e
    ld [bc], a
    cp b
    dec b
    ld e, $00
    ret nc

    ld [bc], a
    ld c, $04
    jr z, jr_003_5f28

    ld b, h
    ld a, [bc]
    ld a, [c]
    pop hl
    dec e

jr_003_5f28:
    nop
    add d
    rst $38
    rra
    rst $28
    rra
    call z, $be5f
    ld e, a
    cp [hl]
    ld e, a
    jr c, jr_003_5ef6

    jr nc, jr_003_5ef8

    jr @+$62

    rra
    ldh [rNR24], a
    and $38
    rst $00
    add hl, sp
    add $2f
    add b
    pop hl
    ld b, [hl]
    nop
    ld bc, $8018

jr_003_5f4a:
    ld [hl], c
    nop
    and b
    db $e4
    add hl, bc
    ret nz

    ld [$5000], sp
    db $10
    inc l
    ld a, [bc]
    ld [hl], b
    db $76
    ldh [$2d], a
    add e
    jp c, $c43b

    rst $30
    nop
    db $10
    inc a
    nop
    sbc b
    rlca
    add b
    nop
    ld c, $c0
    inc c
    ret nz

    nop
    nop
    ld [$0f00], sp
    jr nc, @+$11

    jr nc, jr_003_5f4a

    jr c, jr_003_5ef8

    ld [bc], a

jr_003_5f77:
    ld b, a
    sbc b
    ccf
    jr nc, @+$81

    ldh a, [$7e]
    ld [hl], b
    db $fd
    jr nz, jr_003_5f77

    sub e
    db $eb
    rlca
    ld a, [$34c7]
    ei
    dec bc
    db $fc
    ld [$844f], sp
    ld c, e
    adc b
    ld [hl], a
    adc b
    rst $30
    inc c
    di
    dec c
    ldh [$08], a
    ld h, b
    ld [$06f0], sp
    ldh a, [$09]
    ld h, [hl]
    ld a, c
    ld [de], a
    nop
    ld [hl-], a
    ld [hl], $80
    add b
    ld bc, $f040
    nop
    ld h, b
    inc c
    add d
    jr nz, jr_003_5fcf

    add b
    dec b
    ld b, $97
    ld [bc], a
    ld c, d
    push hl
    inc bc
    cp h
    inc bc
    or h
    ld a, d
    ld a, b
    db $fd
    db $ec
    inc bc
    call z, $7c1f
    ld e, $dc
    cp $ed
    rst $38
    pop hl
    db $fd
    rst $20
    ld sp, hl
    rst $20
    ld sp, hl
    rst $18
    inc hl

jr_003_5fcf:
    cp h
    ld l, a
    ld b, h
    ld d, b
    and $19
    add $19

jr_003_5fd7:
    adc $0b
    rlca
    ld d, [hl]
    rlca
    adc c
    ld d, $5c
    dec c
    ldh [rIF], a
    db $e4
    inc bc
    inc a
    jp $c23c


    ld a, h
    ld a, [hl+]
    nop
    add $fa
    ld bc, $01f6
    jp c, $bc05

    rra
    db $fc
    ccf
    ld a, [hl-]
    ld a, l
    or $78
    or $f9
    or $f8
    rst $30
    ld hl, sp+$65
    ld hl, sp+$0f
    ldh a, [rNR13]
    db $ed
    ld [c], a
    dec e
    ld [c], a
    dec e
    and $19
    add $38
    ld l, h
    db $10
    ld a, d
    nop
    and d
    ld b, b
    jr nz, jr_003_5fd7

    ldh [rSB], a
    jp nz, $fe00

    cp $5f
    ld a, $80
    ld h, a
    sub d
    jr nz, @-$07

    ld c, a
    adc a
    ccf
    ld b, b
    ld d, b
    ret nz

    dec hl
    ld [$e030], sp
    add c
    ld b, $14
    ldh a, [$f8]
    inc bc
    add c
    ld d, b
    rla
    adc h
    ret nz

    ld a, a
    ldh a, [$3e]
    add hl, bc
    ld bc, $004a
    add c
    dec b
    and l
    ccf
    ldh [rTAC], a
    adc b
    di
    add d
    ld h, c
    pop de
    rra
    ldh [rIF], a
    ret c

    daa
    adc $b3
    rst $00
    ld sp, hl
    ld b, c
    ld a, [hl]
    add b
    ld a, a
    inc hl
    sub c
    ld [$1ff0], sp
    db $fc
    dec bc
    ld h, a
    ret c

    ret nc

    ld [$6403], sp
    nop
    ld e, $e1
    inc e
    ldh [$3f], a
    ret nz

    rst $38
    add b
    rst $18
    inc hl
    rra
    xor a
    ld bc, $04e0
    db $10
    ld [$9f8c], sp
    ld b, b
    ld [hl+], a
    ld d, e
    inc b
    dec h
    rst $38
    nop
    ld a, [hl]
    add e
    ld a, h
    adc [hl]
    ld a, c
    cp h
    rst $38
    add b
    rst $38
    inc bc
    ld a, l
    adc [hl]
    pop hl
    add a
    pop hl
    sbc h
    add e
    ld a, a
    ld [bc], a
    cp $15
    inc c
    pop hl
    rra
    add b
    rra
    and b
    ld a, [hl]
    ldh [$fa], a
    pop bc
    db $fd
    ld h, e
    di
    rst $20
    cp $c7
    rst $20
    xor a
    db $ed
    rst $28
    rlca
    ldh [$15], a
    ld a, b
    dec e
    cp $12
    cpl
    sbc c
    ld a, a
    sbc [hl]
    dec e
    call nc, $c98f
    sub $af
    xor l
    push bc
    rst $08
    db $fc
    add a
    ld [hl], d
    daa
    db $dd
    inc hl
    ld a, [$7e81]
    add b
    rra
    nop
    rl [hl]
    ret nc

    ld l, a
    add d
    dec a
    sub h
    ei
    db $10
    ld l, a
    ld bc, $05fe
    ld hl, sp+$07
    ld b, b
    jr z, jr_003_60da

jr_003_60da:
    cp [hl]
    ld a, [hl]
    rst $38
    rst $38
    rst $38
    jr nc, @+$01

    nop
    rst $38
    inc l
    db $d3
    ld a, a
    add b
    rst $38
    nop
    nop
    ld h, h
    ld h, b
    rst $38
    cp $ff
    db $d3
    rst $38
    nop
    rst $38
    ld c, b
    or a
    ei
    inc b
    rst $38
    nop
    nop
    stop
    ld c, h
    inc c
    rst $38
    cp $ff
    di
    rst $38
    nop
    rst $38
    and l
    ld e, d
    rst $38
    nop
    nop
    ld [bc], a
    nop
    jr jr_003_610e

jr_003_610e:
    and a
    ld e, d
    rst $38
    rst $38
    rst $38
    set 7, a
    nop
    rst $38
    rst $30
    ld [$0000], sp
    nop
    ld b, h
    nop
    nop
    nop
    xor h
    ld e, d
    rst $38
    rst $38
    rst $38
    jp Jump_000_18ff


    rst $20

CompressedTODOData26129::
    db $00, $02, $81, $01, $20, $81, $c8, $08, $e0, $c1, $00, $a0, $a0, $f0, $17, $80
    db $2b, $21, $18, $b2, $60, $60, $f1, $98, $60, $70, $02, $0c, $24, $00, $ac, $08
    db $02, $02, $5c, $08, $02, $81, $01, $83, $05, $63, $f1, $90, $70, $60, $b0, $00
    db $ae, $42, $97, $80, $ad, $93, $d3, $02, $90, $d1, $e1, $c0, $92, $a1, $11, $e0
    db $20, $60, $73, $02, $00, $08, $07, $0b, $20, $c0, $0f, $c0, $f0, $cf, $df, $c1
    db $00, $8c, $16, $0f, $6f, $00, $08, $fd, $01, $c1, $af, $0b, $40, $38, $00, $70
    db $30, $20, $10, $60, $48, $fc, $12, $0c, $88, $19, $00, $c1, $c0, $2f, $1e, $0c
    db $12, $0c, $06, $00, $40, $00, $c4, $21, $15, $81, $c0, $86, $81, $d9, $87, $e7
    db $5f, $40, $02, $f8, $09, $04, $60, $06, $80, $65, $a2, $6a, $67, $37, $01, $00
    db $06, $05, $02, $0a, $87, $07, $fe, $07, $9e, $7e, $7f, $bf, $10, $98, $08, $00
    db $97, $88, $e8, $9f, $9f, $83, $e1, $d7, $8f, $7f, $af, $3f, $bf, $bf, $3e, $bf
    db $3c, $3f, $be, $3f, $23, $01, $4c, $00, $a0, $40, $40, $a0, $30, $04, $09, $8a
    db $26, $00, $d0, $20, $e0, $c1, $00, $00, $30, $00, $48, $30, $30, $1a, $41, $10
    db $80, $ab, $24, $20, $44, $95, $60, $60, $f0, $e0, $f1, $f0, $e2, $c1, $ea, $a1
    db $c7, $09, $02, $10, $05, $12, $03, $a0, $10, $51, $b2, $b1, $75, $11, $01, $30
    db $78, $30, $30, $c0, $40, $00, $c0, $00, $a6, $c1, $db, $e7, $e7, $06, $80, $68
    db $96, $c1, $bd, $bb, $17, $82, $20, $01, $18, $25, $3e, $14, $28, $78, $01, $e0
    db $0b, $02, $9c, $1c, $bf, $bf, $00, $00, $96, $08, $12, $08, $19, $00, $c0, $40
    db $90, $08, $0c, $00, $0a, $04, $a4, $00, $08, $01, $00, $38, $00, $10, $85, $20
    db $00, $80, $00, $c0, $83, $a9, $c7, $6b, $87, $1f, $00, $58, $30, $b8, $70, $b0
    db $40, $c0, $01, $00, $07, $00, $01, $06, $04, $60, $02, $50, $20, $a8, $70, $70
    db $f9, $f8, $f9, $f8, $fa, $f9, $fd, $fb, $ff, $27, $18, $78, $38, $b8, $78, $18
    db $fe, $78, $fd, $fe, $a6, $89, $e0, $c8, $02, $83, $01, $c6, $01, $3a, $c7, $e7
    db $27, $86, $e0, $1f, $00, $00, $18, $00, $0a, $9c, $1e, $1f, $9f, $5f, $9f, $3f
    db $df

    rst $38
    rst $38
    ccf
    ld [hl+], a
    db $ec
    ld h, e
    or e
    ld h, l
    db $ec
    ld h, e
    db $ec
    ld h, e
    db $ec
    ld h, e
    or e
    ld h, l
    sbc a
    ld h, a
    sbc a
    ld h, a
    db $ec
    ld h, e
    push hl
    ld l, b
    db $ec
    ld h, e
    db $ec
    ld h, e

; $362c6 First Layer 3 pointers for the background. This is loaded into $c700. 512 Bytes decompressed. $126 compressed.
Layer3PtrBackground1::
    db $00, $02, $22, $01, $02, $9e, $30, $10, $04, $c4, $08, $00, $a2, $66, $68, $66
    db $68, $30, $32, $0c, $01, $46, $18, $19, $19, $2b, $02, $19, $2b, $1a, $1a, $89
    db $80, $d9, $d0, $d8, $10, $10, $28, $04, $5b, $ad, $ac, $68, $64, $50, $54, $18
    db $02, $8a, $28, $2a, $2a, $06, $00, $63, $01, $da, $02, $88, $c5, $85, $c5, $00
    db $40, $6e, $50, $d4, $8e, $4c, $8c, $cc, $0d, $8c, $8e, $00, $cc, $8e, $40, $cb
    db $cc, $cd, $0c, $0d, $0c, $8c, $44, $00, $b6, $04, $4a, $4c, $44, $08, $00, $5d
    db $02, $24, $29, $2a, $84, $40, $a9, $40, $b0, $12, $00, $84, $8a, $08, $00, $02
    db $41, $20, $b0, $48, $40, $40, $50, $b8, $04, $11, $11, $31, $40, $10, $0c, $89
    db $40, $b0, $0c, $04, $00, $a1, $63, $20, $62, $80, $00, $10, $1d, $03, $03, $1e
    db $1f, $03, $06, $00, $a8, $95, $00, $60, $11, $48, $00, $08, $04, $42, $04, $04
    db $24, $26, $06, $06, $24, $12, $00, $01, $11, $31, $30, $00, $44, $5a, $a9, $10
    db $39, $11, $10, $10, $21, $11, $50, $11, $11, $38, $01, $59, $91, $58, $19, $10
    db $18, $39, $41, $81, $81, $11, $70, $10, $20, $09, $51, $89, $18, $58, $19, $a8
    db $b0, $c0, $c8, $a8, $b0, $d0, $d8, $18, $b0, $b0, $d0, $10, $70, $80, $78, $10
    db $70, $90, $78, $40, $18, $30, $60, $68, $60, $18, $18, $60, $68, $18, $18, $18
    db $20, $60, $50, $58, $b9, $58, $59, $e1, $59, $19, $e0, $19, $b0, $18, $e0, $59
    db $c9, $c9, $19, $a8, $18, $c8, $19, $58, $c9, $59, $19, $30, $fa, $0a, $80, $18
    db $c5, $01, $10, $11, $00, $21, $c0, $c8, $ac, $00, $d4, $ac, $ec, $04, $04, $08
    db $08, $28, $80, $0b, $00, $02

; $63ec Second Layer 3 pointers for the background. This is loaded into $c900. $1f0 decompressed. $1c7 compressed.
Layer3PtrBackground2::
    db $f0, $01, $c3, $01, $80, $22, $01, $a6, $17, $8d, $8d, $1e, $9f, $18, $99, $00
    db $96, $19, $9a, $97, $9a, $80, $88, $00, $b8, $81, $05, $80, $cd, $02, $44, $a5
    db $05, $00, $ae, $ca, $c8, $ca, $04, $04, $02, $02, $c4, $c6, $b0, $b2, $ac, $ae
    db $02, $02, $b0, $b2, $04, $b4, $04, $28, $12, $30, $a5, $c5, $15, $b0, $c5, $55
    db $00, $98, $d2, $fa, $11, $00, $78, $35, $39, $05, $4c, $09, $08, $f4, $f8, $20
    db $00, $c6, $92, $9e, $a0, $a8, $02, $86, $88, $94, $96, $a2, $a4, $02, $aa, $cc
    db $ce, $c2, $b4, $cc, $ce, $d0, $b4, $d4, $2c, $02, $20, $02, $01, $00, $01, $13
    db $40, $13, $00, $5b, $13, $38, $04, $0c, $a1, $40, $20, $c0, $48, $4d, $0b, $4d
    db $c0, $ea, $ca, $00, $20, $5d, $68, $5a, $02, $5d, $02, $69, $6a, $02, $62, $63
    db $62, $63, $64, $69, $0f, $02, $2c, $01, $be, $3e, $bf, $bf, $39, $01, $ba, $ba
    db $00, $05, $00, $14, $cb, $4b, $40, $40, $0d, $4e, $c0, $41, $80, $e9, $45, $20
    db $e0, $25, $09, $c8, $e8, $48, $40, $80, $e5, $85, $01, $84, $84, $23, $50, $23
    db $80, $53, $e3, $e5, $f5, $95, $08, $2c, $0a, $12, $0a, $48, $e2, $82, $da, $e2
    db $0a, $12, $42, $0a, $78, $0a, $a0, $7a, $04, $10, $d5, $d4, $04, $04, $04, $0c
    db $29, $29, $2d, $2d, $05, $30, $05, $34, $00, $9c, $de, $04, $04, $e0, $e2, $04
    db $04, $e4, $10, $04, $4c, $02, $76, $02, $02, $77, $02, $6f, $78, $6c, $02, $6c
    db $79, $7c, $7d, $02, $7a, $02, $02, $7b, $02, $7e, $15, $01, $64, $72, $b1, $71
    db $b1, $11, $10, $30, $08, $41, $80, $b6, $00, $64, $73, $02, $6c, $74, $75, $6d
    db $6e, $76, $77, $6f, $70, $78, $79, $71, $72, $7a, $7b, $7c, $7c, $01, $01, $7d
    db $7d, $01, $01, $7e, $7e, $01, $01, $7f, $7f, $01, $01, $6b, $68, $69, $6a, $25
    db $01, $78, $12, $10, $10, $04, $3c, $09, $04, $02, $a2, $04, $d4, $c8, $ca, $58
    db $58, $0c, $80, $c1, $12, $00, $28, $d2, $0a, $00, $8c, $16, $cb, $1a, $4b, $9a
    db $9a, $01, $80, $88, $a5, $8b, $25, $cd, $ea, $8a, $25, $8d, $ac, $0c, $6d, $01
    db $a0, $85, $c6, $e2, $62, $c3, $c2, $62, $48, $28, $7a, $30, $6a, $2c, $2c, $6b
    db $69, $6a, $69, $2c, $6b, $68, $6b, $68, $2c, $6a, $00, $1e, $1e, $02, $1d, $00
    db $02, $1d, $16, $01, $02, $01, $00, $00, $1e, $00, $b6, $36, $b8, $1c, $b7, $b7
    db $9c, $38, $00, $00, $bc, $3c, $ba, $1c, $bd, $bd, $3a, $3b, $3e, $00, $bf, $bf
    db $8d, $0c, $0c, $45, $05, $00, $80, $c5, $05, $00, $c0, $1d, $00, $00, $00, $4b
    db $03, $20, $c0, $58, $58, $58, $08

Layer3PtrBackground3::
    db $00, $02, $e8, $01, $00, $4b, $cb, $0d, $8e, $4b, $0b, $0c, $8e, $00, $8c, $80
    db $0b, $03, $80, $08, $65, $66, $62, $74, $08, $00, $44, $28, $b3, $b2, $52, $b3
    db $b2, $23, $63, $23, $c3, $73, $b3, $00, $10, $73, $e9, $71, $09, $ca, $f1, $89
    db $11, $fa, $c9, $19, $8a, $f1, $59, $11, $5a, $59, $01, $5a, $21, $f2, $b1, $11
    db $b2, $19, $c8, $c8, $58, $d1, $18, $58, $d1, $a8, $58, $19, $a8, $58, $b1, $b0
    db $18, $18, $18, $c0, $c8, $c0, $c8, $70, $49, $60, $0c, $0c, $ac, $ac, $50, $54
    db $18, $02, $63, $60, $40, $63, $63, $65, $c5, $e2, $c2, $e2, $62, $60, $00, $00
    db $80, $e5, $31, $10, $00, $2e, $41, $03, $40, $32, $97, $20, $81, $18, $21, $97
    db $80, $a1, $98, $18, $01, $a1, $15, $01, $97, $15, $a2, $1c, $17, $21, $1b, $b9
    db $39, $bc, $bb, $39, $3a, $bc, $bb, $36, $3a, $b7, $3a, $b9, $37, $3b, $b8, $30
    db $93, $00, $70, $05, $e8, $0a, $78, $ea, $61, $09, $2a, $00, $0c, $d4, $11, $52
    db $d4, $ca, $51, $cb, $0a, $ce, $11, $52, $92, $d2, $12, $d3, $13, $54, $93, $53
    db $94, $54, $c0, $54, $40, $00, $55, $55, $c0, $9f, $80, $c0, $12, $93, $80, $40
    db $93, $d3, $13, $54, $c0, $54, $94, $14, $55, $55, $4b, $06, $c5, $2f, $00, $a0
    db $64, $75, $85, $95, $a5, $b5, $25, $20, $c0, $d5, $25, $20, $e0, $f5, $05, $16
    db $46, $56, $26, $36, $66, $16, $c0, $d5, $05, $16, $e6, $f5, $25, $36, $46, $56
    db $e6, $17, $60, $36, $12, $60, $2f, $01, $01, $c1, $60, $9c, $a1, $a5, $a9, $11
    db $00, $ce, $fe, $02, $05, $48, $01, $a1, $56, $72, $04, $62, $60, $8a, $00, $0e
    db $40, $46, $3e, $00, $42, $31, $30, $39, $2e, $00, $32, $00, $32, $31, $32, $39
    db $3e, $33, $31, $35, $39, $02, $45, $30, $00, $00, $46, $00, $00, $30, $39, $31
    db $31, $30, $00, $2e, $00, $39, $31, $25, $09, $82, $9c, $98, $23, $a4, $95, $b0
    db $23, $24, $31, $25, $99, $23, $99, $15, $9f, $31, $21, $1b, $b0, $95, $30, $b5
    db $b8, $3c, $01, $81, $97, $8d, $00, $28, $f1, $e9, $05, $f8, $ed, $fd, $f5, $05
    db $e8, $ed, $f9, $f5, $31, $82, $60, $e0, $d2, $40, $a6, $38, $3f, $01, $81, $be
    db $80, $b8, $bc, $80, $be, $17, $9a, $3f, $1a, $07, $40, $92, $03, $c4, $c3, $0b
    db $8d, $c4, $44, $5c, $1e, $44, $c4, $8b, $83, $c4, $c3, $8b, $83, $c0, $c3, $1a
    db $5b, $00, $0d, $8d, $80, $80, $80, $d6, $56, $5c, $80, $40, $9c, $80, $40, $1c
    db $8d, $d5, $d5, $49, $00, $e1, $41, $40, $ae, $2d, $60, $8e, $8e, $26, $a2, $ee
    db $28, $63, $c5, $ee, $6e, $45, $03, $4f, $20, $ce, $4d, $a0, $4d, $e0, $2d, $e0
    db $e5, $ed, $4d, $a0, $03, $0e, $8e, $a2, $02, $0e, $ce, $e2, $02, $0e, $ce, $23
    db $0f, $ee, $cd, $4d, $e0, $4d, $e0, $06, $87, $25, $a8, $26

Layer3PtrBackground4::
    db $80, $01, $42, $01, $d0, $12, $73, $63, $d5, $02, $73, $73, $08, $90, $1b, $17
    db $18, $1d, $42, $c0, $95, $4c, $20, $c0, $ae, $c5, $e5, $46, $07, $26, $66, $c7
    db $2a, $46, $c6, $ea, $86, $01, $40, $57, $c0, $2e, $2c, $00, $10, $62, $62, $63
    db $64, $84, $20, $f8, $20, $37, $a0, $2d, $00, $51, $01, $e9, $db, $db, $03, $e0
    db $03, $d8, $e3, $e3, $db, $53, $04, $28, $61, $e9, $75, $e5, $e9, $c1, $e4, $ed
    db $c4, $b4, $58, $8d, $c1, $34, $02, $22, $86, $6c, $ac, $05, $86, $6c, $07, $0b
    db $af, $2b, $0f, $2f, $26, $cf, $ea, $4a, $8f, $2b, $6f, $22, $01, $47, $34, $36
    db $5f, $7e, $60, $5e, $7f, $59, $2e, $58, $3a, $5d, $2d, $58, $37, $5d, $2e, $58
    db $02, $01, $02, $01, $3a, $17, $11, $36, $33, $3b, $43, $4b, $83, $89, $31, $3b
    db $53, $5b, $bb, $d9, $41, $4b, $53, $5b, $6b, $71, $91, $9b, $93, $9b, $a3, $ab
    db $a3, $ab, $b3, $bb, $63, $13, $68, $63, $73, $6b, $13, $70, $13, $78, $7b, $83
    db $83, $8b, $8b, $13, $68, $71, $71, $09, $10, $08, $ec, $58, $0d, $00, $88, $04
    db $ec, $ee, $76, $ac, $04, $0c, $00, $d3, $e2, $22, $23, $00, $13, $23, $30, $23
    db $23, $70, $a3, $23, $30, $b3, $63, $d5, $12, $23, $33, $23, $33, $73, $63, $85
    db $91, $22, $58, $00, $55, $56, $76, $a3, $53, $56, $b6, $63, $05, $90, $00, $04
    db $ad, $c0, $c0, $74, $01, $08, $00, $8c, $ae, $00, $b8, $06, $00, $45, $5c, $00
    db $31, $00, $56, $5a, $00, $00, $01, $00, $31, $5a, $56, $5c, $01, $00, $5d, $11
    db $11, $12, $01, $81, $1e, $1f, $42, $81, $d1, $0f, $90, $d1, $51, $90, $10, $52
    db $d2, $10, $91, $d2, $52, $91, $00, $d3, $0b, $44, $82, $60, $00, $51, $93, $53
    db $c0, $d4, $13, $14, $55, $40, $94, $54, $40, $15, $03, $08, $00, $58, $5e, $02
    db $02, $6a, $70, $02, $02, $12

Layer3PtrBackground5::
    db $2c, $01, $1e, $01, $00, $da, $24, $02, $40, $10, $e0, $6d, $83, $43, $10, $10
    db $1b, $1c, $21, $1a, $19, $1a, $02, $02, $88, $c0, $00, $00, $a8, $b0, $b8, $c0
    db $10, $10, $80, $81, $01, $00, $b8, $81, $d1, $01, $80, $d9, $01, $08, $42, $4a
    db $4a, $8a, $52, $4a, $92, $9a, $e2, $ea, $02, $00, $d8, $e2, $02, $00, $58, $62
    db $a2, $aa, $6a, $0a, $b0, $ba, $ea, $f2, $02, $00, $f8, $02, $03, $00, $a0, $09
    db $10, $04, $52, $ca, $e1, $e9, $f1, $01, $00, $f8, $01, $0a, $12, $0a, $08, $18
    db $0a, $20, $2a, $02, $70, $32, $3a, $7a, $82, $02, $c0, $02, $00, $c8, $d2, $e2
    db $48, $00, $97, $d8, $58, $40, $00, $59, $99, $01, $50, $6d, $2d, $c0, $8c, $ad
    db $ed, $0c, $0d, $00, $20, $4d, $0d, $00, $c0, $ed, $2d, $4e, $0e, $0e, $60, $0e
    db $a0, $ce, $0e, $00, $e0, $0e, $60, $23, $81, $4a, $71, $72, $1d, $1e, $04, $80
    db $09, $08, $1d, $0e, $01, $0f, $1f, $20, $01, $01, $88, $00, $29, $88, $08, $01
    db $13, $81, $12, $01, $13, $88, $88, $09, $09, $0a, $81, $09, $01, $88, $04, $38
    db $0d, $0c, $00, $80, $14, $95, $13, $94, $80, $00, $00, $80, $15, $96, $15, $96
    db $16, $97, $16, $17, $89, $04, $06, $00, $40, $40, $c0, $4b, $4d, $40, $80, $0d
    db $8e, $cd, $02, $20, $09, $2f, $8f, $af, $4f, $6f, $cf, $ef, $0f, $00, $e0, $03
    db $04, $00, $a0, $c3, $a3, $c3, $23, $87, $27, $e0, $21, $e0, $e1, $05, $67, $83
    db $23, $00, $07, $07, $e0, $05, $07, $00, $e0, $25, $00, $e0, $e5, $05, $a7, $c2
    db $02, $21, $c0, $80, $a1, $81, $21, $20, $80, $a1, $21, $20, $20, $80, $80, $41
    db $81, $27

CompressedTODOData26a07::
    db $00, $02, $35, $01, $02, $9e, $0e, $10, $0a, $0c, $1e, $20, $7a, $00, $1a, $1c
    db $00, $00, $12, $14, $28, $2a, $20, $52, $28, $02, $02, $01, $03, $09, $0a, $0f
    db $10, $00, $13, $00, $00, $04, $02, $0b, $0c, $11, $12, $14, $15, $00, $1d, $00
    db $00, $18, $01, $f8, $5b, $f9, $12, $00, $40, $55, $5e, $42, $0d, $80, $90, $0d
    db $0e, $91, $91, $83, $f1, $17, $49, $0d, $4b, $89, $49, $8b, $cb, $01, $a0, $a8
    db $86, $a4, $84, $a5, $c5, $44, $c0, $45, $20, $45, $45, $46, $e0, $04, $05, $26
    db $26, $22, $00, $f3, $12, $28, $94, $00, $b3, $32, $43, $63, $73, $83, $93, $23
    db $20, $90, $10, $82, $00, $6c, $83, $9d, $7c, $7e, $04, $00, $73, $00, $81, $c0
    db $30, $3a, $e2, $01, $00, $0a, $52, $5a, $12, $10, $30, $3a, $52, $5a, $02, $00
    db $e8, $01, $10, $1a, $42, $4a, $62, $6a, $12, $70, $7a, $82, $92, $9a, $8a, $02
    db $a0, $aa, $12, $78, $12, $90, $82, $8a, $9a, $a2, $02, $00, $a8, $6a, $89, $d1
    db $93, $d5, $55, $96, $16, $16, $c0, $d6, $41, $c0, $ea, $ac, $4b, $00, $54, $85
    db $76, $76, $26, $80, $66, $26, $70, $d6, $85, $a6, $08, $8e, $b3, $b3, $2e, $01
    db $01, $34, $01, $33, $04, $d0, $53, $d7, $59, $83, $83, $ce, $4e, $98, $18, $90
    db $97, $c2, $08, $06, $0c, $58, $9a, $5a, $98, $d8, $9a, $d7, $18, $22, $a0, $48
    db $80, $ac, $8c, $ac, $0c, $23, $03, $23, $e3, $03, $e4, $03, $e4, $0b, $e0, $0b
    db $22, $80, $4d, $02, $67, $66, $68, $02, $5c, $02, $02, $88, $80, $18, $03, $d0
    db $d9, $01, $b0, $e8, $01, $b0, $b8, $e8, $f1, $60, $00, $81, $40, $83, $03, $50
    db $50, $83, $03, $55, $15, $d4, $0f, $51, $51, $83, $43, $0d, $8b, $4f, $09, $51
    db $11, $40, $47, $0f, $46

    ld [hl+], a
    dec bc
    nop
    ld [bc], a
    call z, $696c
    ld l, [hl]
    call z, $cc6c
    ld l, h
    call z, $696c
    ld l, [hl]
    ld [$0870], sp
    ld [hl], b
    call z, $096c
    ld [hl], c
    call z, $cc6c
    ld l, h

; $6b58: First Layer 2 pointers for background data. Decompressed to $cb00. Compressed $174. Decompressed $200.
Layer2PtrBackground1::
    db $00, $02, $70, $01, $80, $00, $2f, $14, $08, $00, $58, $21, $43, $04, $42, $01
    db $43, $c3, $02, $87, $c3, $03, $41, $82, $83, $04, $87, $03, $43, $83, $44, $02
    db $86, $a1, $41, $00, $b0, $c7, $11, $00, $e8, $e3, $08, $00, $e8, $45, $48, $08
    db $00, $a2, $f0, $a2, $42, $41, $e1, $a0, $00, $8c, $14, $c0, $6c, $c3, $65, $43
    db $42, $82, $c2, $00, $a0, $24, $02, $23, $31, $00, $04, $0f, $09, $10, $05, $42
    db $60, $48, $48, $60, $64, $bc, $7c, $28, $1c, $00, $e5, $03, $43, $e2, $03, $44
    db $c1, $10, $18, $05, $a2, $70, $71, $41, $08, $4c, $1a, $18, $12, $12, $19, $1a
    db $23, $2f, $1a, $23, $23, $12, $0a, $00, $09, $10, $3e, $1b, $37, $17, $3d, $1d
    db $12, $2b, $0c, $31, $0a, $21, $0a, $1a, $0e, $20, $a3, $10, $09, $12, $89, $12
    db $89, $0f, $09, $92, $13, $09, $13, $89, $11, $89, $13, $09, $89, $92, $92, $0c
    db $0c, $85, $8b, $04, $14, $a1, $94, $64, $c8, $28, $28, $a0, $a4, $64, $c8, $98
    db $48, $64, $98, $28, $cc, $40, $04, $80, $4c, $c2, $04, $65, $00, $a0, $a4, $60
    db $82, $22, $93, $71, $71, $d1, $b1, $71, $71, $21, $d2, $e1, $b0, $c2, $11, $23
    db $b1, $22, $b1, $42, $a3, $80, $01, $a2, $60, $13, $a2, $f1, $52, $23, $b1, $92
    db $21, $43, $a3, $20, $93, $a1, $80, $a3, $91, $33, $b2, $82, $90, $a0, $a0, $10
    db $13, $80, $a5, $04, $93, $87, $0c, $03, $09, $89, $06, $04, $00, $17, $42, $82
    db $03, $0f, $41, $86, $c4, $c3, $c3, $81, $84, $04, $44, $83, $03, $80, $69, $01
    db $22, $82, $e3, $80, $a1, $c1, $80, $83, $a1, $81, $a0, $80, $83, $e3, $01, $98
    db $64, $a0, $a0, $30, $00, $02, $8e, $1f, $09, $09, $20, $09, $a1, $20, $89, $21
    db $85, $9e, $0d, $85, $a1, $8d, $1e, $85, $21, $85, $21, $0e, $0e, $03, $0e, $80
    db $f2, $23, $73, $82, $02, $05, $05, $89, $15, $88, $21, $88, $08, $84, $84, $09
    db $95, $00, $c8, $c4, $80, $c0, $80, $80, $85, $c0, $80, $c4, $83, $04, $91, $44
    db $91, $84, $84, $83, $84, $91, $c4, $91, $84, $84, $04, $07, $07, $11, $12, $47
    db $08, $0b, $00, $02

; $6ccc: Second Layer 2 pointers for background data. Decompressed to $cd00. Compressed $1b4. Decompressed $199.
Layer2PtrBackground2::
    db $b0, $01, $99, $01, $00, $87, $07, $82, $40, $04, $1d, $05, $49, $04, $00, $11
    db $16, $16, $0a, $00, $46, $60, $40, $70, $30, $35, $d5, $00, $48, $14, $38, $69
    db $20, $91, $01, $87, $82, $c1, $e5, $a5, $82, $42, $e2, $21, $a2, $02, $23, $40
    db $08, $19, $1b, $15, $14, $10, $0a, $00, $68, $90, $01, $00, $a9, $4a, $40, $cb
    db $54, $85, $02, $c0, $12, $e6, $65, $a6, $c2, $a5, $a1, $82, $66, $66, $02, $80
    db $c8, $31, $f5, $d1, $51, $e1, $d1, $00, $28, $a5, $a9, $a0, $b9, $49, $00, $e0
    db $62, $04, $55, $d0, $4c, $51, $31, $00, $88, $a8, $82, $e6, $81, $82, $82, $a4
    db $42, $a9, $82, $82, $a9, $c2, $29, $aa, $02, $ab, $ea, $ea, $44, $00, $9e, $24
    db $5d, $27, $23, $29, $15, $0c, $0e, $00, $4d, $aa, $a9, $a9, $0a, $0a, $aa, $af
    db $0a, $0a, $b0, $ab, $0b, $20, $48, $8d, $25, $94, $2d, $84, $5d, $4d, $3c, $4c
    db $00, $3e, $cd, $3a, $d2, $3e, $d6, $42, $da, $46, $de, $2a, $28, $00, $44, $77
    db $d7, $32, $f5, $00, $17, $37, $57, $41, $a1, $55, $21, $b5, $55, $71, $91, $b7
    db $57, $58, $c1, $f7, $57, $61, $18, $38, $98, $b8, $b8, $53, $21, $53, $01, $21
    db $41, $41, $92, $a0, $40, $41, $32, $d5, $f8, $58, $c1, $d8, $d8, $25, $00, $47
    db $c8, $01, $00, $22, $e5, $68, $e9, $65, $e6, $67, $e8, $66, $e7, $04, $80, $28
    db $3c, $43, $2b, $28, $44, $4b, $2b, $4c, $27, $82, $63, $5a, $81, $5a, $41, $a1
    db $00, $1c, $01, $27, $a0, $54, $5b, $53, $2b, $5c, $5e, $56, $5b, $2b, $28, $28
    db $5c, $a7, $12, $12, $ee, $ef, $47, $04, $40, $52, $53, $05, $80, $11, $48, $2a
    db $f1, $10, $7b, $00, $70, $a5, $af, $2f, $08, $8c, $d4, $54, $c5, $c5, $6c, $6d
    db $7d, $7d, $c7, $d4, $6d, $47, $fd, $6d, $7d, $7d, $cc, $cb, $6e, $fd, $4b, $43
    db $7d, $ee, $ee, $8c, $00, $48, $c0, $e1, $0e, $17, $00, $04, $b8, $7e, $b7, $7e
    db $f6, $b7, $3e, $b7, $be, $b7, $3e, $b7, $23, $ed, $76, $6d, $aa, $b1, $b8, $be
    db $b1, $b1, $45, $82, $62, $70, $4c, $eb, $8f, $0f, $82, $8b, $c8, $03, $80, $53
    db $ae, $af, $6f, $7e, $8e, $ae, $7f, $79, $99, $ae, $be, $00, $88, $f5, $00, $10
    db $e8, $b7, $03, $b8, $b7, $03, $b0, $b3, $bb, $bf, $c3, $cb, $cf, $c7, $03, $d0
    db $db, $03, $d4, $03, $00, $bc, $5b, $24, $08, $00, $ee, $f1, $07, $c0, $01, $9b
    db $01, $00, $03, $11, $13, $05, $07, $05, $15, $09, $0b, $17, $19, $0d, $0f, $1b
    db $1d, $5d, $5d, $37


Data6e65:
    db $3b, $5d, $5d, $3d, $3f
    db $5d, $5d, $41, $43, $5d, $5d, $45, $47, $05, $8f, $05, $95, $91, $4b, $02, $d0
    db $84, $00, $ce, $00, $ce, $82, $cf, $d1, $d2, $d0, $85, $d3, $8c, $d4, $00, $d4
    db $00, $ae, $ae, $de, $df, $14, $09, $94, $81, $a3, $a0, $f0, $0a, $0b, $2e, $6b
    db $08, $5c, $9b, $a5, $ad, $b5, $25, $2f, $37, $04, $c6, $40, $bb, $00, $7a, $05
    db $ed, $06, $ca, $c0, $51, $50, $d8, $e5, $ed, $f5, $35, $04, $9a, $fd, $02, $07
    db $83, $73, $77, $1b, $02, $43, $21, $10, $a8, $66, $6c, $7e, $5e, $5d, $68, $cd
    db $28, $d8, $2c, $d8, $ac, $60, $aa, $a0, $40, $5a, $ba, $d9, $49, $5a, $ea, $f9
    db $49, $5a, $0a, $1a, $4a, $5a, $2a, $3a, $7a, $0a, $12, $e0, $b9, $6b, $ec, $60
    db $61, $c3, $ec, $46, $ed, $6d, $d4, $54, $f0, $55, $d6, $58, $d9, $d6, $40, $d5
    db $c4, $47, $c8, $48, $c9, $49, $ca, $4a, $cb, $4b, $4c, $8f, $0c, $8e, $84, $c4
    db $25, $66, $a5, $a5, $84, $04, $02, $90, $48, $62, $92, $92, $83, $e3, $12, $f3
    db $00, $04, $1c, $95, $96, $1c, $1c, $99, $9a, $12, $8f, $8f, $1c, $90, $12, $1c
    db $90, $91, $1c, $12, $91, $1c, $92, $92, $12, $dc, $dd, $0a, $0a, $1b, $01, $50
    db $ea, $0e, $07, $07, $17, $07, $0f, $1f, $07, $27, $57, $00, $30, $05, $18, $05
    db $ef, $6f, $f4, $f4, $02, $c0, $a4, $9b, $9f, $2b, $68, $70, $77, $0f, $17, $7b
    db $7f, $ab, $af, $7b, $7f, $73, $b3, $83, $2b, $88, $2b, $0c, $17, $13, $b7, $9b
    db $bb, $2b, $28, $dc, $e6, $be, $eb, $c2, $97, $2b, $28, $b8, $ba, $92, $97, $bb
    db $ba, $9a, $9f, $e3, $ea, $92, $77, $13, $1b, $73, $9f, $df, $c6, $e3, $ea, $e6
    db $04, $10, $e4, $15, $0a, $15, $18, $15, $92, $97, $99, $15, $e6, $f1, $f3, $e9
    db $eb, $f5, $f7, $23, $c2, $04, $00, $01, $20, $a3, $79, $05, $05, $fa, $7a, $05
    db $05, $fb, $7b, $fc, $7c, $85, $7f, $fd, $fd, $e5, $24, $fe, $fe, $65, $25, $7f
    db $8b, $00, $81, $02, $a0, $02, $22, $53, $13, $63, $23, $c0, $92, $22, $f0, $c8
    db $29, $d4, $fe, $9e, $bf, $5f, $41, $c1, $5f, $41, $e1, $5f, $01, $70, $39, $09
    db $60, $69, $59, $89, $a9, $49, $01, $d1, $d5, $15, $60

    ret


    push de
    sub l
    or c
    pop de
    push de
    ld d, l
    inc h
    jr c, jr_003_700b

    db $fd

jr_003_700b:
    nop
    add b
    add c
    add [hl]
    add a
    add d
    add e
    add b
    add c
    add h
    add l
    adc b
    adc c

Call_003_7018:
    sbc l
    sbc [hl]
    nop
    and b
    and c
    nop
    sbc c
    nop
    nop
    sbc d
    nop
    sbc d
    jr jr_003_7027

    add b

jr_003_7027:
    sub e
    inc c
    nop
    jr nz, @+$4f

    db $76
    ld a, d
    ld d, d
    add d
    add [hl]
    ld d, [hl]
    add [hl]
    ld e, [hl]
    ld e, d
    ld l, d
    ld e, d
    ld l, d
    adc [hl]
    sub d
    adc [hl]
    sub d
    ld a, [bc]
    sub [hl]
    ld [bc], a
    sbc d
    ld [de], a
    sbc [hl]
    ld [hl+], a
    and d
    ld [bc], a
    sbc d
    ld b, $96
    ld l, [hl]
    ld [hl], d
    ld a, [hl]
    add d
    ld b, h
    adc b
    ld c, e
    ld a, l
    dec a
    sub d
    sbc l
    db $10
    jr jr_003_700b

    add a
    xor d
    xor e
    xor h
    xor l
    add [hl]
    ret nz

    xor b
    dec a
    inc [hl]
    or h
    dec b
    inc b
    inc [hl]
    inc e
    adc d
    db $eb
    dec hl
    inc l
    ld l, [hl]
    xor $a1
    ld bc, $6e60
    ld [hl], l
    ld [hl], a
    ld a, c
    ld a, e
    ld a, l
    dec c
    ld a, a
    dec c
    ld bc, $0015
    ld c, d
    or c
    or a
    or d
    or c
    cp c
    or d
    add [hl]
    or [hl]
    or l
    or e
    or e
    or h
    or h
    or [hl]
    cp c
    add a
    adc e
    adc h
    call nz, $c6c5
    add [hl]
    rst $00
    add [hl]
    add b
    add b
    ret z

    ret


    add b
    jp z, $8786

    jr nz, jr_003_70a6

    ld [$065b], sp
    inc [hl]
    inc a
    inc b
    inc c
    ld b, h
    ld c, [hl]

jr_003_70a6:
    ld h, [hl]
    ld l, [hl]
    db $76
    ld a, [hl]
    ld e, [hl]
    ld h, h
    inc e
    dec h
    add l
    ld c, b
    ld b, c
    rla
    ld [hl], l
    or l
    or $b6
    push af
    dec [hl]
    ld [hl], a
    nop
    ld [bc], a
    ld b, b
    jp hl


    ld e, e
    ld b, c
    nop
    ret nz

    dec [hl]
    jr z, @+$0b

    ld a, [de]
    ld e, d
    ld a, d
    sbc d
    jr nc, jr_003_712a

    and l
    db $10
    ld [$8510], sp
    ld b, l
    ld b, [hl]
    add hl, bc
    ret


    ld [bc], a
    ret nz

    sub h
    inc b
    ld [hl], l
    dec [hl]
    ldh [$b6], a
    add d
    add d
    scf
    ld h, b
    ld [bc], a
    add hl, hl
    ld [bc], a
    add c
    ld [bc], a
    and b
    nop
    add hl, hl
    ld [bc], a
    add c
    inc b
    and b
    nop
    add hl, hl
    ld [bc], a
    ld bc, $6007
    xor [hl]
    inc l
    and b
    ld [bc], a
    ldh [$b2], a
    pop hl
    and c
    add d
    ld [$1600], sp
    add hl, de
    dec h
    ld c, l
    db $d3
    push de
    rst $10
    reti


    ld bc, $1415
    and d
    dec de
    jr c, jr_003_710c

    add hl, de

jr_003_710c:
    ld bc, $0100
    inc bc
    rlca
    nop
    ld [hl+], a
    ld c, b
    jr z, jr_003_714e

    nop
    ld hl, sp+$03
    nop
    jr nc, jr_003_7158

    inc [hl]
    inc a
    inc c
    ld b, h
    ld b, h
    inc b
    ret


    dec h
    ld h, $0a
    nop
    ld [$cc12], a

jr_003_712a:
    ld sp, $3a36
    ld a, $42
    ld b, [hl]
    ld c, d
    ld c, [hl]
    ld d, [hl]
    ld d, d
    ld e, d
    ld e, [hl]
    ld d, d

jr_003_7137:
    ld d, d
    ld h, d
    ld d, d
    ld h, [hl]
    ld l, d
    ld l, [hl]
    ld [hl], d
    ld d, d
    ld d, d
    ld a, [hl]
    add d
    db $76
    ld a, d
    add [hl]
    adc d
    adc [hl]
    sub d
    sub [hl]
    sbc d
    sbc [hl]
    ld [bc], a
    sub h
    sbc d

jr_003_714e:
    sub d
    inc b
    ret nz

    add hl, hl
    dec [hl]
    ld sp, $7551
    dec [hl]
    pop de

jr_003_7158:
    nop
    db $10
    dec b
    ret c

    ld a, [de]
    add sp, -$06
    ld a, [bc]
    ld l, b
    db $10
    db $10
    ld d, a
    ld e, b
    ld b, c
    ld h, b
    cp b
    ld b, $06
    jp nz, $1606

    ld [bc], a
    cp h
    ld [bc], a
    jr jr_003_7137

    ld d, d
    ld d, d
    or d
    xor [hl]
    ld d, d
    ld a, [de]
    nop
    sbc d
    ld d, b
    ld h, e
    ld bc, $0800
    nop
    ld b, h
    ld bc, $7c8c
    ld a, a
    add hl, hl
    add hl, hl
    ld d, c
    ld d, a
    add hl, hl
    add hl, hl
    inc de
    rla
    ld e, c
    ld d, a
    inc de
    rla
    ld d, c
    ld h, e
    dec d
    inc de
    ld e, c
    ld d, a

jr_003_7197:
    dec d
    inc de
    ld d, c
    ld h, e
    ld sp, $1812
    nop
    nop
    or d
    or e
    sub h
    or h
    sub h
    sub h
    adc b
    ret nz

    nop
    nop
    xor b
    or l

jr_003_71ac:
    cp l
    dec l
    db $10
    ld b, c
    add b
    and l
    ld e, h
    ld e, h
    ld bc, $1700
    dec h
    and l
    xor $ae
    xor $2e
    nop
    ret nz

    ld l, e
    xor e
    ld [hl+], a
    db $10
    ld h, b
    ld e, l
    ld bc, $0106
    ld d, [hl]
    cp e
    cp h
    cp l
    cp b
    cp c
    cp h
    cp l
    add l
    ld [$0820], sp
    ld b, h
    inc c
    inc c
    and h
    and h
    call nz, Call_003_4ddd
    ld c, h
    nop
    ld c, b
    ld [c], a
    ld [hl+], a
    nop
    add b
    ld h, d
    ld [hl+], a
    nop
    nop
    ld [hl], b
    ld [bc], a
    nop
    add hl, hl
    sbc b
    ld [hl-], a
    ld a, b
    jr nz, @+$1a

    or a
    ld bc, $2380
    ld h, c
    jp nz, Jump_003_40c2

    ld b, d
    ld h, b
    ld d, b
    ld d, d
    ld d, $53
    ld a, [de]
    ld a, [de]
    rlca
    ld [hl+], a
    or d
    xor [hl]
    ld e, d
    ld e, [hl]
    jp z, Jump_000_3ada

    add d
    add b
    ld [hl], d
    ld hl, sp-$68
    sub d
    ld [de], a
    sbc c
    ld d, d
    add hl, sp
    sbc c
    ld [hl], d
    jr jr_003_7197

    or a
    ld d, a
    scf
    rla
    nop
    ld h, b
    cp b
    jr jr_003_7220

jr_003_7220:
    ld h, b
    sub h
    or h
    sub $56
    inc hl
    ld b, h
    ld bc, $010d
    jr nz, jr_003_71ac

    ld l, h
    ld h, b
    rst $18
    ld b, c
    ld bc, $e800
    pop af
    add hl, hl
    jr c, jr_003_7267

    ld b, b
    nop
    ld c, b
    ld d, b
    ret nz

    ld h, c

Call_003_723d:
    inc c
    and d
    dec c
    ld b, b
    inc de
    jr nz, jr_003_72ac

    pop de
    ld e, d
    ld l, d
    ld [hl], b
    ld [$2aa1], sp
    and l
    and d
    ld h, d
    nop
    dec c
    ld hl, $c4aa

jr_003_7253:
    add h
    call nz, $0144
    ret nz

    ld [$e2c3], sp
    ld [hl+], a
    ld b, e
    inc bc
    ret nz

    ld [bc], a
    inc hl
    db $e3
    ld [c], a
    ld c, c
    inc hl
    and a
    ld b, c

jr_003_7267:
    ld hl, sp-$1b
    inc b
    nop
    jr nc, jr_003_7285

    inc c
    nop
    db $10
    adc a
    sub b
    rrca
    ld de, $1da7
    ld b, h
    jr nz, jr_003_7253

    ld b, c
    ret


    ld bc, $0002
    jr c, jr_003_7281

    ld b, b

jr_003_7281:
    ld c, c
    ld d, c
    ld e, c
    ld d, c

jr_003_7285:
    inc c
    ld e, [hl]

jr_003_7287:
    push hl
    cp b
    cp h
    ret nz

    call nz, Call_000_00c8
    nop
    call z, $fc00
    cp h
    ldh [$c4], a
    ret nz

    nop
    ret z

    call z, $dcd8
    ret c

    call c, $4458
    ld [$5012], sp
    dec c
    dec b
    nop
    adc b
    db $76
    ld [bc], a
    add h
    ld c, a
    dec b
    dec h

jr_003_72ac:
    ld d, b
    sub c
    adc $4e
    sub d
    jp nc, Jump_003_5312

    db $d3
    ld bc, $4a00
    pop bc
    ld h, a
    ld b, c
    add c
    ld h, c
    ld bc, $0180
    ld hl, $d48c
    pop de
    pop bc
    pop bc
    or c
    or c
    ld h, c
    nop
    or b
    ld [bc], a
    nop
    ld h, b
    ld bc, $6168
    ld [hl], c
    ld l, c
    ld sp, hl
    ld [hl], c
    ret


    ld bc, $0062
    ld b, b
    add hl, de
    add hl, de
    dec e
    dec e
    ld hl, $1921
    add b
    ld h, b
    ld h, b
    pop de
    add h
    rst $08
    call nz, $8e93
    call $cd8f
    dec c
    ret nz

    dec c
    ld b, b
    ld c, $4e
    ld b, b
    ret nz

    ret nz

    add b
    ld b, h
    add b
    nop
    add b
    add h
    call nz, Call_000_04c4
    ret z

    jp hl


    db $10
    jr z, jr_003_7287

    ld h, d
    ld b, b
    add sp, -$14
    ldh [$e4], a
    db $10
    add b
    add b
    ld a, [bc]
    add a
    ld b, a
    add a
    xor d
    ld h, a
    add a
    jp z, $ea87

    ret


    add hl, hl
    rst $20
    add a
    ld a, [hl+]
    rlca
    jr z, @+$22

    jr nz, @+$2a

    ld l, b
    rst $00
    ret z

    ld c, b
    ld [$4aa5], sp
    ld h, l
    push bc
    ld a, [bc]
    db $eb
    ld a, [hl+]
    xor e
    call nc, $ea94
    sub h
    ld [$d509], a
    add hl, hl
    dec h

CompressedVirginLogoTileMap::
    db $40, $02, $cf, $00, $c0, $a5, $e0, $44, $80, $e1, $00, $41, $81, $c1, $01, $82
    db $80, $40, $82, $82, $22, $22, $a0, $70, $81, $a1, $c1, $e1, $01, $22, $42, $62
    db $82, $42, $21, $11, $50, $68, $71, $81, $21, $20, $90, $a1, $21, $20, $b0, $c1
    db $d1, $c1, $88, $08, $24, $8f, $0f, $01, $01, $90, $10, $43, $10, $9a, $c8, $88
    db $20, $22, $d0, $48, $04, $4a, $04, $4c, $04, $04, $4e, $50, $52, $04, $54, $18
    db $10, $01, $b6, $c2, $62, $d1, $e2, $f2, $02, $13, $23, $33, $43, $53, $63, $73
    db $e3, $78, $40, $c2, $c9, $d1, $d9, $e1, $e9, $f1, $f9, $01, $0a, $12, $1a, $22
    db $2a, $72, $3c, $20, $19, $1d, $21, $25, $29, $2d, $31, $35, $39, $3d, $09, $08
    db $40, $45, $39, $20, $02, $49, $4a, $60, $8a, $aa, $ca, $ea, $4a, $00, $01, $7c
    db $84, $15, $88, $08, $a4, $2c, $ad, $2d, $ae, $2e, $af, $af, $03, $90, $15, $58
    db $98, $20, $22, $90, $c4, $c6, $c8, $ca, $04, $2a, $cc, $04, $04, $ce, $d0, $d2
    db $18, $12, $81, $a4, $b6, $c6, $d6, $e6, $f6, $06, $17, $27, $37, $a7, $88, $08
    db $a4, $80, $00, $90, $d0, $d5, $d9, $dd, $e1, $e5, $09, $08, $08, $54, $28

    sub $0a
    nop
    ld [bc], a

CompressedVirginLogoData::
    db $a0, $07, $b3, $04, $a0, $09, $2e, $c2, $03, $2d, $0c, $91, $b4, $19, $40, $29
    db $17, $90, $21, $03, $3c, $d8, $00, $60, $06, $d0, $66, $41, $24, $c0, $40, $01
    db $d1, $81, $30, $87, $00, $41, $c1, $6f, $2e, $48, $83, $7b, $30, $18, $00, $53
    db $0d, $6e, $cc, $89, $94, $09, $f1, $40, $30, $40, $18, $d8, $c8, $82, $d0, $1f
    db $08, $28, $1a, $30, $50, $26, $20, $06, $50, $06, $20, $56, $88, $80, $b4, $8b
    db $4f, $03, $ff, $32, $a0, $53, $40, $ca, $0c, $d8, $05, $18, $00, $a8, $1a, $08
    db $04, $8c, $e2, $00, $69, $5c, $40, $8d, $18, $07, $c0, $3f, $84, $47, $68, $28
    db $95, $05, $8a, $16, $28, $0d, $4c, $42, $0c, $70, $41, $20, $63, $5e, $60, $4c
    db $20, $40, $88, $01, $80, $4a, $2e, $98, $c2, $00, $47, $01, $c9, $32, $00, $59
    db $00, $a0, $00, $10, $2f, $2b, $92, $05, $b0, $c8, $8b, $70, $c0, $ea, $a2, $45
    db $7e, $14, $ca, $00, $71, $d8, $80, $6c, $a0, $43, $06, $c0, $4b, $84, $93, $0c
    db $23, $1c, $03, $25, $00, $ee, $71, $01, $1f, $82, $06, $08, $d4, $71, $a0, $48
    db $0e, $d0, $c7, $07, $e4, $08, $11, $00, $f0, $7a, $a8, $91, $0b, $61, $61, $4e
    db $0e, $30, $49, $82, $40, $c0, $31, $0e, $44, $c6, $80, $d1, $38, $80, $2e, $e1
    db $58, $01, $69, $5c, $80, $17, $b0, $1a, $f9, $09, $f2, $05, $f2, $41, $0d, $80
    db $4d, $38, $e1, $28, $03, $40, $e1, $80, $6e, $0c, $50, $92, $03, $a5, $0a, $b0
    db $e3, $0f, $88, $40, $e0, $11, $0b, $72, $e3, $41, $08, $30, $00, $01, $30, $1a
    db $81, $06, $09, $06, $00, $d1, $08, $18, $00, $4c, $c6, $84, $f6, $b8, $1f, $00
    db $44, $8b, $87, $10, $00, $e0, $22, $c2, $3c, $c1, $3c, $c4, $39, $c2, $39, $c8
    db $33, $c4, $33, $d0, $27, $c8, $27, $44, $00, $8c, $0a, $72, $64, $03, $a3, $00
    db $53, $03, $ab, $71, $a0, $95, $0a, $31, $00, $31, $a1, $60, $0b, $f4, $43, $30
    db $b8, $14, $70, $17, $03, $86, $a2, $40, $30, $c8, $00, $20, $14, $03, $c0, $05
    db $80, $b4, $38, $d0, $0d, $0b, $be, $1d, $4c, $43, $84, $03, $41, $80, $1b, $1e
    db $5c, $c3, $02, $cb, $18, $10, $00, $82, $81, $02, $01, $02, $21, $03, $04, $22
    db $44, $22, $00, $fe, $1d, $82, $c7, $38, $f0, $1a, $f9, $03, $80, $77, $98, $0f
    db $f8, $43, $b4, $a3, $10, $07, $18, $07, $10, $af, $10, $df, $68, $fc, $47, $94
    db $63, $a2, $41, $42, $20, $04, $98, $80, $23, $04, $48, $00, $48, $58, $00, $60
    db $a2, $08, $00, $70, $21, $c8, $30, $c8, $30, $c1, $50, $80, $51, $a0, $11, $10
    db $20, $10, $20, $81, $20, $a0, $81, $22, $01, $45, $00, $be, $90, $01, $80, $63
    db $20, $e8, $8a, $07, $6a, $f1, $27, $c4, $c3, $02, $a1, $70, $98, $07, $03, $2c
    db $08, $48, $48, $08, $70, $01, $80, $1a, $16, $40, $43, $44, $38, $01, $a0, $15
    db $e2, $05, $02, $d5, $f0, $20, $df, $c1, $32, $cc, $08, $7c, $81, $40, $98, $70
    db $89, $0b, $32, $31, $01, $1e, $20, $5e, $a2, $00, $28, $88, $02, $31, $42, $31
    db $12, $61, $90, $63, $88, $40, $18, $50, $a7, $10, $0f, $30, $4f, $00, $78, $3b
    db $07, $39, $46, $38, $06, $78, $06, $7a, $4c, $04, $f6, $21, $89, $30, $81, $30
    db $91, $a0, $10, $a1, $00, $21, $20, $01, $c0, $60, $80, $00, $81, $80, $02, $81
    db $40, $45, $00, $01, $80, $87, $00, $07, $00, $03, $05, $22, $00, $26, $08, $06
    db $22, $0c, $24, $48, $20, $48, $28, $00, $c9, $10, $c9, $50, $80, $51, $80, $11
    db $f0, $01, $f2, $01, $24, $01, $6f, $48, $82, $41, $80, $23, $c0, $43, $84, $83
    db $28, $90, $3b, $08, $8d, $04, $03, $82, $02, $b9, $41, $c8, $68, $9c, $23, $08
    db $84, $04, $a1, $88, $17, $38, $84, $01, $6d, $17, $01, $c0, $47, $10, $08, $02
    db $7c, $00, $7e, $04, $c0, $b5, $80, $10, $e0, $27, $08, $98, $82, $78, $10, $00
    db $42, $05, $84, $01, $4c, $48, $31, $2e, $58, $40, $43, $88, $71, $88, $01, $20
    db $0c, $44, $c2, $80, $00, $20, $00, $88, $43, $3c, $02, $7c, $02, $1e, $00, $ab
    db $30, $c0, $27, $60, $20, $a0, $85, $48, $80, $40, $00, $c0, $20, $c0, $00, $91
    db $00, $b8, $c2, $01, $4d, $48, $14, $00, $04, $20, $1c, $00, $3c, $00, $fc, $02
    db $7c, $c4, $00, $1e, $42, $0c, $84, $48, $48, $80, $00, $80, $21, $02, $d3, $50
    db $28, $50, $10, $e0, $88, $02, $01, $82, $c3, $2d, $ec, $78, $86, $01, $84, $70
    db $20, $20, $04, $00, $61, $00, $10, $0e, $04, $20, $1f, $00, $3f, $80, $82, $20
    db $00, $fa, $09, $00, $aa, $0e, $08, $07, $08, $06, $81, $06, $0f, $00, $58, $c1
    db $21, $c0, $02, $e0, $02, $06, $40, $00, $00, $0f, $18, $00, $48, $0d, $e8, $0a
    db $f0, $03, $fc, $23, $14, $4c, $e1, $01, $22, $bc, $08, $85, $01, $f2, $0a, $18
    db $a1, $40, $80, $60, $8b, $60, $40, $10, $78, $06, $f8, $00, $f0, $08, $f1, $08
    db $f9, $00, $f8, $01, $01, $1e, $00, $1e, $02, $0c, $12, $2c, $10, $2c, $14, $08
    db $30, $48, $38, $00, $00, $ce, $11, $80, $2f, $f8, $00, $60, $13, $7e, $00, $70
    db $8b, $1f, $40, $00, $08, $16, $c0, $ed, $0f, $e8, $67, $20, $f8, $f6, $10, $00
    db $c8, $0a, $07, $10, $00, $82, $40, $38, $c0, $38, $c0, $38, $c5, $38, $62, $10
    db $16, $4c, $21, $02, $3c, $00, $38, $01, $7e, $00, $bc, $48, $30, $c0, $21, $23
    db $a0, $0d, $28, $10, $e0, $86, $05, $bd, $06, $42, $40, $40, $b0, $ef, $20, $4c
    db $f4, $0b, $78, $14, $00, $2a, $60, $13, $3e, $00, $fc, $00, $50, $ed, $20, $00
    db $58, $84, $0f, $10, $0f, $00, $84, $80, $a9, $1f, $80, $bf, $c1, $21, $d8, $02
    db $2c, $04, $18, $10, $00, $50, $01, $83, $08, $00, $bf, $10, $e0, $09, $f0, $09
    db $03, $74, $01, $bb, $f8, $00, $78, $26, $18, $0a, $80, $5e, $c1, $84, $02, $c1
    db $a6, $05, $76, $01, $61, $20, $d9, $42, $68, $28, $16, $40, $8b, $1f, $01, $1e
    db $02, $1c, $04, $18, $00, $18, $20, $10, $60, $80, $c0, $01, $78, $06, $f1, $00
    db $f2, $01, $f8, $67, $58, $d0, $12, $e0, $0f, $f0, $27, $28, $56, $0d, $04, $84
    db $8c, $80, $21, $c0, $01, $f0, $05, $0c, $00, $62, $05, $de, $fe, $40, $3e, $10
    db $0e, $04, $0c, $c0, $54, $80, $00, $82, $41, $58, $10, $86, $71, $20, $18, $04
    db $00, $ff, $00, $7f, $c2, $00, $d1, $40, $00, $08, $00, $02, $c8, $87, $60, $11
    db $0e, $64, $61, $80, $0b, $04, $9e, $fc, $09, $f0, $21, $c0, $81, $0c, $c0, $11
    db $90, $09, $38, $00, $78, $15, $00, $30, $80, $70, $00, $f0, $01, $84, $00, $d0
    db $02, $fa, $01, $fc, $03, $f8, $37, $1c, $10, $81, $00, $23, $c0, $0f, $f0, $1b
    db $0e, $a8, $02, $02, $42, $44, $60, $80, $0e, $f0, $84, $01, $26, $e0, $1f, $41
    db $01, $11, $1c, $a0, $20, $80, $68, $80, $5f, $00, $04, $05, $c6, $21, $40, $10
    db $38, $80, $81, $20, $00, $30, $08, $80, $79, $28, $0c, $0c, $c1, $00, $c4, $03
    db $f0, $8f, $a1

    stop
    cp $05

CompressedJungleBookLogoTileMap::
    db $d0, $00, $89, $00, $00, $a0, $09, $10, $18, $20, $28, $30, $38, $40, $48, $50
    db $50, $44, $74, $da, $02, $43, $83, $c3, $03, $44, $84, $c4, $04, $45, $85, $c5
    db $05, $06, $40, $86, $c6, $06, $c7, $44, $12, $90, $3a, $3c, $3e, $40, $42, $44
    db $46, $48, $4a, $4c, $4e, $50, $52, $54, $56, $58, $5a, $5c, $5e, $60, $28, $92
    db $80, $14, $23, $33, $43, $53, $63, $73, $83, $93, $a3, $b3, $c3, $d3, $e3, $f3
    db $03, $14, $24, $34, $44, $44, $11, $05, $a4, $22, $a3, $23, $a4, $24, $a5, $25
    db $a6, $26, $a7, $27, $a8, $28, $a9, $29, $aa, $2a, $ab, $ab, $89, $28, $20, $61
    db $65, $69, $6d, $65, $65, $71, $75, $79, $65, $7d, $81, $85, $89, $8d, $91, $65
    db $65, $95, $4d, $64, $09, $0e, $88, $d9, $99

    ld b, b
    ld [$0200], sp

CompressedJungleBookLogoData::
    db $80, $06, $24, $05, $80, $20, $e3, $66, $1a, $0c, $3c, $1c, $7c, $34, $74, $6c
    db $6c, $cc, $d4, $d8, $f8, $90, $31, $60, $78, $f0, $dc, $f8, $fc, $6f, $ef, $f7
    db $f7, $f4, $77, $f4, $e4, $76, $7a, $44, $30, $0b, $0b, $67, $21, $30, $f0, $ff
    db $fa, $ff, $af, $df, $cf, $ff, $1f, $70, $f8, $b3, $e7, $ff, $bf, $ff, $dc, $bf
    db $a9, $bf, $3f, $20, $00, $3a, $bc, $3e, $ff, $cb, $c7, $f3, $a1, $5a, $3c, $1e
    db $1f, $9f, $1f, $00, $40, $9f, $cf, $ff, $5f, $f4, $b8, $7a, $30, $75, $73, $d0
    db $f0, $c5, $90, $4d, $0a, $8b, $10, $30, $00, $04, $c0, $c6, $02, $c5, $bd, $40
    db $63, $38, $f1, $8e, $07, $e3, $8f, $e7, $fd, $dc, $40, $70, $96, $ea, $4a, $4e
    db $4a, $4a, $00, $00, $a0, $c0, $09, $25, $08, $78, $f5, $70, $6d, $60, $10, $c2
    db $c0, $92, $b1, $b1, $b1, $91, $b1, $c9, $91, $e1, $c0, $f9, $37, $04, $a5, $b0
    db $37, $33, $56, $07, $0f, $46, $1c, $0e, $80, $a0, $92, $e1, $ff, $ff, $e1, $41
    db $96, $02, $c2, $88, $d8, $58, $00, $40, $dc, $fc, $df, $ff, $ff, $73, $30, $40
    db $8b, $c3, $c2, $e3, $c2, $6f, $ce, $8f, $0f, $8f, $cf, $cd, $fd, $ec, $7c, $f8
    db $c1, $63, $ee, $6c, $ee, $cf, $ef, $4f, $8f, $2f, $00, $e0, $af, $27, $80, $47
    db $2e, $3c, $28, $23, $24, $28, $04, $28, $0c, $68, $5e, $ec, $ff, $ff, $fc, $bf
    db $29, $3f, $ec, $e5, $65, $20, $00, $a0, $39, $2c, $ac, $7f, $ff, $ff, $75, $f8
    db $cf, $ff, $8c, $01, $9a, $38, $78, $38, $1d, $08, $88, $18, $f1, $fb, $ff, $f3
    db $f6, $ef, $3e, $18, $4a, $11, $bc, $98, $34, $78, $fc, $78, $ff, $ce, $cf, $87
    db $f0, $e0, $30, $30, $f8, $f0, $70, $38, $18, $b8, $7f, $3f, $ff, $ff, $4e, $49
    db $34, $48, $ff, $00, $90, $9a, $40, $80, $00, $01, $2a, $40, $42, $82, $03, $0b
    db $0e, $98, $02, $45, $60, $6a, $5c, $40, $54, $30, $f0, $f7, $cf, $ff, $0f, $78
    db $20, $82, $c9, $82, $52, $d8, $cf, $27, $00, $84, $c7, $88, $29, $49, $4d, $c9
    db $49, $49, $f9, $f2, $f1, $f1, $93, $10, $8c, $98, $18, $41, $10, $c0, $fc, $ff
    db $0f, $00, $ff, $18, $10, $08, $06, $e8, $21, $8e, $04, $88, $00, $88, $60, $61
    db $e1, $ef, $81, $cf, $48, $86, $00, $30, $20, $49, $00, $48, $01, $78, $37, $12
    db $84, $34, $20, $13, $03, $fd, $04, $80, $10, $60, $0d, $07, $f8, $3d, $3c, $3f
    db $0d, $00, $d4, $60, $80, $01, $f8, $01, $f8, $03, $0e, $04, $dc, $38, $b0, $1c
    db $01, $f6, $01, $f6, $87, $03, $0d, $05, $d8, $a8, $10, $4f, $b0, $0f, $f0, $0f
    db $0c, $88, $00, $a0, $c6, $fc, $ff, $ff, $0b, $07, $40, $80, $10, $60, $89, $70
    db $3a, $1c, $78, $30, $f4, $63, $e0, $67, $08, $06, $21, $1e, $80, $7f, $8c, $73
    db $18, $00, $03, $00, $80, $5f, $c0, $9f, $91, $14, $6a, $e2, $ec, $dd, $cf, $cd
    db $cf, $8f, $0e, $0f, $0c, $08, $c1, $08, $c2, $01, $84, $c3, $e1, $c0, $fc, $f8
    db $ff, $fe, $d7, $cf, $c1, $c3, $c8, $f1, $c5, $78, $e0, $1c, $00, $80, $48, $02
    db $fb, $10, $e2, $01, $f8, $91, $10, $08, $85, $90, $cf, $00, $00, $84, $c0, $32
    db $04, $f9, $84, $18, $10, $68, $22, $1c, $78, $cf, $dc, $df, $8f, $07, $0f, $2c
    db $04, $c1, $20, $40, $03, $20, $09, $01, $00, $a0, $c1, $fb, $f1, $7f, $3e, $0e
    db $0e, $26, $c0, $11, $e0, $81, $71, $06, $02, $7e, $3e, $fe, $fe, $e1, $c3, $01
    db $00, $41, $3e, $80, $7e, $10, $e2, $00, $01, $21, $1f, $01, $3f, $11, $0f, $01
    db $06, $00, $07, $80, $06, $41, $86, $19, $18, $1e, $9e, $1f, $9e, $6d, $12, $a8
    db $8b, $03, $a1, $30, $20, $19, $00, $3d, $3e, $3e, $7f, $21, $08, $02, $02, $33
    db $03, $03, $0e, $0c, $07, $0f, $0b, $02, $10, $30, $38, $1e, $3e, $2e, $1e, $0c
    db $00, $42, $84, $4a, $04, $c0, $5e, $08, $20, $e2, $e7, $f7, $e7, $77, $60, $00
    db $00, $85, $20, $25, $c3, $64, $04, $c1, $40, $2a, $40, $38, $21, $1e, $42, $20
    db $08, $f0, $09, $02, $01, $c0, $4f, $00, $40, $85, $7c, $81, $42, $20, $c0, $13
    db $04, $24, $61, $00, $a3, $80, $f0, $50, $09, $07, $f8, $09, $06, $81, $47, $18
    db $10, $02, $f0, $01, $f2, $01, $f2, $0d, $81, $80, $10, $10, $44, $13, $88, $17
    db $00, $02, $7c, $e0, $10, $00, $86, $31, $ce, $81, $7e, $0c, $83, $70, $f0, $0d
    db $81, $1e, $01, $1f, $00, $3c, $04, $38, $40, $12, $02, $50, $42, $3c, $40, $3f
    db $40, $3f, $09, $71, $08, $43, $c8, $0b, $c8, $cf, $08, $2f, $14, $02, $e0, $37
    db $e4, $00, $10, $a0, $9f, $21, $1e, $21, $1e, $43, $3c, $01, $f8, $05, $f8, $a1
    db $1a, $82, $49, $08, $e8, $21, $08, $7c, $c2, $81, $00, $10, $00, $04, $40, $1e
    db $02, $1c, $00, $1e, $01, $1e, $80, $04, $20, $04, $f8, $84, $78, $84, $78, $00
    db $c6, $21, $02, $9a, $30, $00, $3e, $00, $3e, $02, $dc, $00, $90, $84, $01, $cb
    db $06, $32, $e1, $41, $18, $90, $84, $05, $c2, $0a, $c4, $24, $d8, $08, $f0, $02
    db $fc, $01, $fe, $00, $cf, $08, $c7, $3c, $38, $30, $78, $70, $e0, $b8, $70, $18
    db $38, $3c, $18, $8c, $1c, $0c, $9c, $20, $29, $04, $87, $40, $10, $04, $34, $42
    db $40, $38, $44, $38, $40, $3c, $c0, $3f, $44, $e0, $15, $c2, $7d, $04, $38, $90
    db $0f, $80, $1f, $a0, $1f, $80, $bf, $00, $3f, $01, $3e, $04, $78, $d0, $20, $45
    db $02, $01, $80, $4f, $00, $68, $f5, $03, $f0, $03, $f2, $a1, $40, $78, $28, $04
    db $00, $7c, $02, $7c, $c1, $3e, $20, $1f, $c0, $3c, $c4, $38, $c4, $38, $84, $38
    db $80, $bc, $42, $3c, $00, $7f, $0c, $03, $08, $f0, $08, $70, $89, $70, $80, $f1
    db $08, $70, $06, $f8, $02, $7c, $a1, $1c, $46, $38, $20, $40, $06, $78, $80, $7f
    db $80, $7f, $c0, $3f, $8c, $f3, $10, $60, $9c, $04, $02, $c0, $03, $e0, $03, $d0
    db $a3, $01, $50, $ec, $3b, $03, $18, $88, $07, $80, $07, $04, $01, $40, $25, $c0
    db $01, $e8, $01, $f2, $6c, $10, $1c, $10, $10, $90, $13, $90, $13, $94, $b3, $10
    db $17, $38, $77, $30, $7e, $74, $88, $91, $40, $00, $7e, $06, $7c, $86, $7c, $00
    db $f9, $00, $f8, $19, $e0, $61, $14, $02, $c0, $23, $d4, $63, $80, $3f, $31, $0e
    db $00, $2f, $00, $2f, $08, $a7, $08, $67, $a0, $07, $c4, $03, $c2, $41, $0c, $18
    db $88, $87, $08, $87, $08, $07, $00, $07, $08, $07, $31, $0e, $02, $7c, $88, $30
    db $4a, $02, $01, $22, $1c, $20, $1e, $20, $1e, $30, $4e, $21, $0e, $e8, $07, $60
    db $1e, $60, $1e, $62, $1c, $62, $1c, $60, $9c, $64, $18, $e0, $19, $f0, $01, $e1
    db $18, $e1, $18, $24, $81, $00, $f0, $8c, $72, $0c, $71, $0e, $30, $cf, $c0, $c9
    db $83, $c9, $c8, $c3, $c2, $c0, $c0, $c0, $c8, $c4, $c0, $cc, $c5, $c8, $c0, $e0
    db $c0, $70, $f0, $b0, $70, $00, $12, $24, $a8, $c0, $b5, $70, $e0, $f1, $a3, $cf
    db $6f, $28, $60, $0b, $84, $04, $18, $0e, $ff, $fb, $f7, $f2, $71, $30, $80, $1a
    db $10, $08, $c8, $c7, $e7, $c7, $ef, $70, $78, $38, $28, $18, $08, $00, $00, $00
    db $06, $01, $56, $88, $07, $fc, $93, $60, $00, $02, $94, $0f, $ee, $08, $80, $12
    db $30, $00, $f0, $d3, $e3, $e3, $07, $07, $0e, $3e, $1c, $34, $38, $30, $e0, $c1
    db $c3, $d7, $cf, $7f, $7e, $3c, $f8, $45, $0e, $88, $02, $01, $04, $01, $44, $0f
    db $98, $84, $03, $04, $09, $4c, $f0, $70, $fd, $de, $df, $8f, $87, $03, $88, $02
    db $22, $81, $83, $87, $8f, $ff, $fe, $7c, $78, $c4, $a1, $12, $10, $a0, $00, $08
    db $fe, $03, $05, $44, $0c, $1c, $7c, $38, $f8, $f0, $d0, $e0, $88, $42, $f9, $fb
    db $11, $2c, $0f, $60

    ld h, b
    add hl, bc
    nop
    ld [bc], a
    ld b, l
    ld [bc], a
    ld bc, $4f80
    nop
    ld l, b
    push af
    inc bc
    ldh a, [$03]
    ld a, [c]
    and c
    ld b, b
    ld a, b
    jr z, jr_003_7e8b

    nop
    ld a, h
    ld [bc], a
    ld a, h

jr_003_7e8b:
    pop bc
    ld a, $20
    rra
    ret nz

    inc a
    call nz, $c438
    jr c, @-$7a

    jr c, @-$7e

    cp h
    ld b, d
    inc a
    nop
    ld a, a
    inc c
    inc bc
    ld [$08f0], sp
    ld [hl], b
    adc c
    ld [hl], b
    add b
    pop af
    ld [$0670], sp
    ld hl, sp+$02
    ld a, h
    and c
    inc e
    ld b, [hl]
    jr c, jr_003_7ed2

    ld b, b
    ld b, $78
    add b
    ld a, a
    add b
    ld a, a
    ret nz

    ccf
    adc h
    di
    db $10
    ld h, b
    sbc h
    inc b
    ld [bc], a
    ret nz

    inc bc
    ldh [$03], a
    ret nc

    and e
    ld bc, $ec50
    dec sp
    inc bc
    jr @-$76

    rlca
    add b
    rlca

jr_003_7ed2:
    inc b
    ld bc, $2540
    ret nz

    ld bc, $01e8
    ld a, [c]
    ld l, h
    db $10
    inc e
    db $10
    db $10
    sub b
    inc de
    sub b
    inc de
    sub h
    or e
    db $10
    rla
    jr c, @+$79

    jr nc, @+$80

    ld [hl], h
    adc b
    sub c
    ld b, b
    nop
    ld a, [hl]
    ld b, $7c
    add [hl]
    ld a, h
    nop
    ld sp, hl
    nop
    ld hl, sp+$19
    ldh [$61], a
    inc d
    ld [bc], a
    ret nz

    inc hl
    call nc, $8063
    ccf
    ld sp, $000e
    cpl
    nop
    cpl
    ld [$08a7], sp
    ld h, a
    and b
    rlca
    call nz, $c203
    ld b, c
    inc c
    jr @-$76

    add a
    ld [$0887], sp
    rlca
    nop
    rlca
    ld [$3107], sp
    ld c, $02
    ld a, h
    adc b
    jr nc, jr_003_7f72

    ld [bc], a
    ld bc, $1c22
    jr nz, jr_003_7f4c

    jr nz, @+$20

    jr nc, jr_003_7f80

    ld hl, $e80e
    rlca
    ld h, b
    ld e, $60
    ld e, $62
    inc e
    ld h, d
    inc e
    ld h, b
    sbc h
    ld h, h
    jr @-$1e

    add hl, de
    ldh a, [rSB]
    pop hl
    jr @-$1d

    jr jr_003_7f6f

    add c

jr_003_7f4c:
    nop
    ldh a, [$8c]
    ld [hl], d
    inc c
    ld [hl], c
    ld c, $30
    rst $08
    ret nz

    ret


    add e
    ret


    ret z

    jp $c0c2


    ret nz

    ret nz

    ret z

    call nz, $ccc0
    push bc
    ret z

    ret nz

    ldh [$c0], a
    ld [hl], b
    ldh a, [$b0]
    ld [hl], b
    nop
    ld [de], a
    inc h

jr_003_7f6f:
    xor b
    ret nz

    or l

jr_003_7f72:
    ld [hl], b
    ldh [$f1], a
    and e
    rst $08
    ld l, a
    jr z, jr_003_7fda

    dec bc
    add h
    inc b
    jr jr_003_7f8d

    rst $38

jr_003_7f80:
    ei
    rst $30
    ld a, [c]
    ld [hl], c
    jr nc, @-$7e

    ld a, [de]
    db $10
    ld [$c7c8], sp
    rst $20
    rst $00

jr_003_7f8d:
    rst $28
    ld [hl], b
    ld a, b
    jr c, jr_003_7fba

    jr jr_003_7f9c

    nop
    nop
    nop
    ld b, $01
    ld d, [hl]
    adc b
    rlca

jr_003_7f9c:
    db $fc
    sub e
    ld h, b
    nop
    ld [bc], a
    sub h
    rrca
    xor $08
    add b
    ld [de], a
    jr nc, jr_003_7fa9

jr_003_7fa9:
    ldh a, [$d3]
    db $e3
    db $e3
    rlca
    rlca
    ld c, $3e
    inc e
    inc [hl]
    jr c, jr_003_7fe5

    ldh [$c1], a
    jp $cfd7


jr_003_7fba:
    ld a, a
    ld a, [hl]
    inc a
    ld hl, sp+$45
    ld c, $88
    ld [bc], a
    ld bc, HeaderLogo
    ld b, h
    rrca
    sbc b
    add h
    inc bc
    inc b
    add hl, bc
    ld c, h
    ldh a, [rSVBK]
    db $fd
    sbc $df
    adc a
    add a
    inc bc
    adc b
    ld [bc], a
    ld [hl+], a
    add c
    add e

jr_003_7fda:
    add a
    adc a
    rst $38
    cp $7c
    ld a, b
    call nz, Call_000_12a1
    db $10
    and b

jr_003_7fe5:
    nop
    ld [$03fe], sp
    dec b
    ld b, h
    inc c
    inc e
    ld a, h
    jr c, @-$06

    ldh a, [$d0]
    ldh [$88], a
    ld b, d
    ld sp, hl
    ei
    ld de, $0f2c
    ld h, b
    ld h, b

Jump_003_7ffc:
    add hl, bc
    nop
    ld [bc], a
    inc bc
