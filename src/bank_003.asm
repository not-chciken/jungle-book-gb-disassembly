SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

    push bc

Call_003_4001:
    ld hl, PtrBaseLayer3Background
    add hl, bc
    push bc
    push hl
    ld hl, Layer3PtrBackground1
    ld a, c
    cp $14
    jr nz, :+
    ld hl, Layer3PtrBackground6
 :  ld de, Layer3BgPtrs1

Jump_003_4015:
    call DecompressTilesIntoVram
    pop hl
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, Layer3BgPtrs2
    call DecompressTilesIntoVram
    pop bc
    ld hl, PtrBaseLayer2Background
    add hl, bc
    push hl
    ld hl, Layer2PtrBackground1
    ld a, c
    cp $14                          ; Level 7?
    jr nz, :+
    ld hl, Layer2PtrBackground6
 :  ld de, Layer2BgPtrs1
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
    ld hl, DataTODO409a
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

; $407c
LoadVirginLogoData::
    ld hl, CompressedVirginLogoData
    call DecompressInto9000
    ld hl, _SCRN0
    ld de, $8800
    ld bc, $0200
    rst $38
    ld hl, CompressedVirginLogoTileMap

; $408f
DecompressInto9800::
    ld de, $9800
    jr JumpToDecompress

; $4094: Decompresses data into tile map.
DecompressInto9000::
    ld de, $9000

; $4097 Simply jumps to DecompressTilesIntoVram
JumpToDecompress::
    jp DecompressTilesIntoVram

; $409a: A 4-tuple per level (de, pointer to compressed data, de, pointer to compressed data)
DataTODO409a::
    dw $9000, $40fa, $96c0, $49da ; Level 0
    dw $9000, $45d9, $96d0, $4aaf ; Level 1
    dw $9000, $40fa, $96c0, $4b86 ; Level 2
    dw $9000, $40fa, $96c0, $4ca5 ; Level 3
    dw $9000, $40fa, $96c0, $4ca5 ; Level 4
    dw $9000, $45d9, $96d0, $4d79 ; Level 5
    dw $92d0, $4e8e, $9560, $4f3b ; Level 6
    dw $92d0, $4e8e, $9560, $4f3b ; Level 7
    dw $9000, $516e, $96c0, $5412 ; Level 8
    dw $9000, $550c, $0000, $0000 ; Level 9
    dw $9000, $5a51, $0000, $0000 ; Level 10
    dw $9000, $40fa, $96c0, $49da ; Level 11

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
    db $e0, $1f, $e2, $fd, $02, $7f, $80, $9f, $c0, $7f, $c0, $5f, $e0, $5f, $22

MapBackgroundTileData2::
    db $d0, $06, $fd, $03, $98, $00, $20, $d0, $8c, $87, $19, $ea, $30, $83, $d3, $02
    db $a2, $05, $54, $0b, $88, $16, $20, $1d, $70, $72, $8d, $17, $34, $10, $e1, $02
    db $a2, $05, $48, $07, $8c, $f4, $1f, $05, $05, $46, $0b, $90, $16, $10, $45, $18
    db $c2, $cf, $fa, $07, $f5, $8f, $02, $40, $5d, $fe, $17, $fc, $2b, $7e, $e1, $40
    db $6c, $81, $b8, $cf, $fe, $47, $b8, $47, $d4, $6d, $22, $0a, $b6, $ec, $03, $02
    db $5f, $19, $0f, $60, $3f, $00, $2a, $ba, $07, $c0, $07, $20, $04, $88, $43, $3c
    db $c0, $bf, $41, $fe, $03, $fc, $01, $be, $42, $b1, $6f, $c0, $dc, $01, $be, $02
    db $70, $01, $81, $80, $b6, $03, $73, $05, $e0, $88, $02, $01, $6d, $07, $a1, $81
    db $1d, $50, $20, $a0, $6a, $02, $53, $81, $a9, $d5, $40, $00, $d4, $81, $a6, $01
    db $53, $01, $90, $b0, $3a, $10, $50, $95, $a0, $a9, $2e, $90, $10, $15, $98, $5c
    db $ff, $af, $06, $02, $44, $af, $01, $80, $b9, $d5, $ff, $bb, $41, $20, $2f, $0e
    db $20, $1a, $10, $01, $8a, $aa, $03, $00, $6b, $fd, $01, $83, $50, $fd, $af, $1a
    db $00, $d8, $d5, $07, $00, $8c, $08, $02, $09, $4c, $01, $c8, $2a, $fe, $45, $fe
    db $03, $0a, $00, $4b, $05, $01, $01, $22, $d4, $7f, $aa, $81, $40, $00, $06, $08
    db $04, $f4, $1f, $68, $20, $08, $13, $74, $51, $20, $00, $40, $84, $13, $00, $54
    db $c2, $09, $0c, $e3, $05, $f8, $a2, $f8, $77, $18, $00, $94, $39, $04, $00, $89
    db $7c, $02, $02, $b9, $58, $10, $00, $28, $ea, $fb, $c7, $1f, $00, $40, $01, $04
    db $00, $84, $27, $00, $20, $0a, $ff, $10, $ff, $38, $05, $c0, $4a, $c4, $fd, $c7
    db $1b, $00, $18, $c1, $05, $00, $e6, $2f, $00, $f8, $88, $1f, $01, $00, $a4, $8e
    db $7f, $9f, $c1, $00, $44, $16, $38, $43, $95, $ff, $ab, $ff, $f7, $02, $00, $d2
    db $fc, $7f, $fc, $40, $00, $49, $e0, $ff, $61, $00, $50, $8a, $1f, $01, $00, $26
    db $98, $80, $50, $97, $ef, $bf, $ff, $00, $a0, $e8, $fe, $7f, $fc, $1f, $bc, $00
    db $70, $84, $c0, $ff, $20, $ff, $74, $ff, $ea, $ff, $e4, $ff, $ee, $ff, $ce, $ff
    db $8e, $ff, $86, $11, $09, $08, $c4, $7f, $74, $01, $80, $36, $fa, $04, $00, $a2
    db $d1, $e7, $df, $63, $30, $04, $11, $97, $f0, $22, $00, $03, $e0, $1c, $10, $02
    db $80, $f0, $27, $00, $10, $84, $01, $fe, $02, $a2, $09, $f0, $0b, $02, $c5, $00
    db $df, $01, $de, $0b, $d4, $00, $5f, $80, $5f, $61, $08, $03, $e2, $d1, $00, $ff
    db $60, $10, $e0, $8c, $07, $f8, $82, $40, $38, $2c, $84, $17, $01, $f0, $ef, $63
    db $00, $28, $07, $ff, $00, $83, $42, $bf, $84, $dc, $88, $1e, $00, $d4, $f2, $0f
    db $08, $66, $e3, $e0, $2f, $c4, $3f, $10, $04, $d0, $71, $8f, $08, $02, $a2, $12
    db $42, $01, $11, $e7, $17, $e4, $df, $2f, $0c, $62, $0d, $b4, $2a, $78, $75, $11
    db $c0, $00, $1e, $00, $08, $81, $55, $3e, $01, $3e, $01, $3c, $03, $86, $80, $a8
    db $8b, $00, $fc, $23, $28, $a0, $02, $ff, $c7, $1f, $08, $44, $89, $07, $10, $41
    db $9e, $7f, $94, $7f, $9a, $7f, $fc, $00, $18, $e3, $fc, $43, $fc, $84, $c1, $26
    db $9e, $01, $9e, $01, $9f, $00, $8f, $80, $0f, $80, $8f, $05, $80, $2e, $fa, $05
    db $fc, $0c, $06, $ca, $1a, $90, $f1, $07, $02, $9f, $0a, $06, $fc, $3f, $fe, $00
    db $b0, $69, $3e, $40, $08, $fb, $fc, $71, $fe, $c1, $fe, $e1, $fe, $88, $80, $e1
    db $0b, $08, $02, $ff, $80, $5f, $00, $df, $c0, $c7, $ff, $40, $02, $c0, $0b, $3f
    db $02, $81, $50, $b0, $0a, $f9, $03, $02, $9a, $18, $10, $2c, $e1, $d3, $80, $88
    db $0f, $18, $42, $be, $bf, $00, $3f, $02, $3c, $04, $38, $08, $30, $10, $20, $10
    db $20, $20, $00, $20, $00, $d0, $0f, $c4, $03, $c2, $01, $c1, $80, $40, $80, $40
    db $40, $00, $40, $00, $80, $1f, $c0, $30, $0f, $cf, $3f, $4a, $00, $88, $12, $40
    db $79, $00, $8c, $73, $f8, $16, $02, $ba, $f0, $c0, $59, $01, $31, $8e, $7f, $c0
    db $01, $00, $d6, $3f, $c0, $c7, $00, $00, $eb, $f3, $df, $e0, $1f, $a0, $00, $90
    db $15, $ef, $f0, $0f, $e0, $09, $10, $06, $80, $28, $50, $4a, $60, $d5, $a0, $28
    db $81, $d5, $83, $a2, $82, $68, $7d, $fe, $82, $64, $2a, $82, $00, $e0, $d8, $02
    db $a5, $05, $52, $0b, $94, $16, $48, $f9, $07, $82, $20, $20, $fc, $05, $04, $bf
    db $0e, $ff, $04, $f9, $7a, $0a, $80, $51, $bf, $01, $81, $ad, $cf, $00, $c0, $56
    db $80, $a2, $0a, $4c, $78, $a0, $08, $3c, $60, $78, $e5, $f0, $0f, $f4, $4b, $08
    db $6c, $fa, $05, $f8, $06, $80, $2f, $00, $13, $41, $3c, $d0, $0f, $30, $c4, $cb
    db $f1, $f7, $fb, $2b, $02, $9c, $f0, $2f, $60, $dc, $04, $f4, $43, $3c, $c0, $1f
    db $20, $c0, $ff, $f7, $ff, $b3, $00, $28, $fa, $fc, $3b, $fe, $01, $ff, $80, $7b
    db $e0, $1d, $e8, $f5, $f7, $6d, $00, $68, $fd, $fe, $ff, $fc, $7f, $fc, $3f, $fc
    db $1f, $fd, $be, $03, $ec, $03, $f8, $3f, $90, $8d, $c0, $3f, $e0, $1f, $7c, $02
    db $be, $01, $e6, $01, $fc, $17, $06, $6c, $13, $26, $71, $d8, $02, $a3, $41, $79
    db $05, $66, $81, $11, $44, $20, $50, $ec, $e3, $fb, $67, $50, $60, $04, $f2, $e1
    db $fd, $f3, $f3, $ef, $77, $30, $30, $0a, $f0, $55, $08, $16, $18, $1d, $20, $e2
    db $fb, $17, $14, $18, $fd, $07, $04, $b3, $e0, $fe, $05, $05, $46, $38, $ff, $01
    db $03, $c0, $ac, $43, $3c, $41, $c1, $0c, $b4, $9a, $30, $fe, $00, $03, $00, $ff
    db $05, $04, $ac, $45, $55, $01, $fe, $11, $e0, $1f, $c0, $20, $9f, $04, $f8, $17
    db $e0, $18, $c7, $27, $9f, $5f, $3f, $bf, $7f, $bf, $15, $01, $0c, $af, $1f, $df
    db $bf, $bf, $7f, $bf, $83, $c0, $e0, $07, $00, $e5, $3f, $00, $08, $fe, $ff, $fc
    db $ff, $71, $fe, $86, $c0, $f0, $00, $1f, $e0, $3f, $c0, $f7, $01, $ee, $07, $38
    db $07, $f8, $05, $f8, $7b, $00, $48, $3e, $c0, $3b, $c0, $4f, $c1, $10, $fe, $01
    db $04

; $49da: Also contains background tile data. Unpacked into $9700. Compressed $140, Uncompressed $d5.
MapBackgroundTileData10::
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
    db $e5, $18, $e4, $43, $28

MapBackgroundTileData20::
    db $30, $01, $d3, $00, $40, $80, $ff, $02, $fc, $03, $f8, $77, $30, $40, $02, $fe
    db $39, $00, $98, $79, $04, $01, $46, $14, $20, $81, $7c, $d0, $0f, $f0, $07, $f8
    db $1f, $0c, $a0, $06, $f8, $e1, $01, $98, $e3, $09, $06, $10, $45, $4a, $07, $ef
    db $7e, $80, $7f, $80, $77, $88, $07, $f8, $07, $f8, $01, $00, $de, $01, $1c, $83
    db $f0, $01, $fc, $02, $8c, $01, $6e, $48, $bc, $3a, $e4, $74, $0f, $20, $18, $04
    db $fc, $01, $fa, $01, $8c, $03, $83, $00, $52, $05, $a2, $87, $00, $00, $d2, $e4
    db $24, $78, $80, $ff, $7f, $80, $02, $f2, $1c, $00, $fc, $fd, $13, $8c, $20, $21
    db $1c, $ac, $fa, $04, $fb, $00, $ff, $f5, $f3, $fe, $31, $ff, $c0, $3f, $98, $e5
    db $c3, $fb, $9f, $e7, $ff, $06, $df, $e1, $ff, $c3, $bf, $c3, $7f, $81, $ef, $f4
    db $f3, $f9, $ff, $f9, $ff, $fe, $c1, $3f, $40, $3f, $09, $20, $d2, $bf, $5f, $bf
    db $ff, $3e, $ff, $3d, $fe, $3b, $3c, $e4, $9b, $e1, $df, $db, $ff, $fd, $ff, $fe
    db $bd, $7f, $fc, $3b, $fc, $37, $38, $fe, $81, $ff, $83, $fb, $87, $f7, $4f, $bf
    db $cf, $3b, $8c, $49, $02, $e1, $1f, $e0, $03, $fc, $0c, $7f, $8f, $bf, $d7, $ef
    db $d7, $ef, $df, $e7, $df, $03, $22

MapBackgroundTileData30::
    db $40, $01, $1b, $01, $00, $c4, $39, $c8, $33, $cc, $33, $d0, $27, $c8, $27, $e0
    db $02, $10, $80, $7e, $c0, $0e, $11, $e0, $05, $fa, $13, $e4, $25, $c8, $01, $da
    db $01, $fe, $09, $f0, $25, $12, $48, $05, $f2, $8c, $71, $4e, $30, $8f, $30, $2f
    db $90, $4f, $96, $c1, $18, $84, $81, $22, $c0, $4f, $90, $8f, $30, $0f, $f0, $1f
    db $e0, $8f, $00, $4f, $34, $08, $f2, $01, $91, $41, $81, $00, $67, $18, $00, $fc
    db $33, $1c, $10, $21, $1c, $c4, $00, $13, $00, $c2, $fe, $03, $09, $45, $20, $1f
    db $44, $83, $08, $f0, $01, $fe, $88, $41, $38, $20, $05, $e8, $07, $d1, $00, $32
    db $6c, $00, $a8, $ba, $8b, $30, $03, $70, $83, $70, $18, $e4, $23, $c8, $07, $1c
    db $20, $fb, $6b, $00, $00, $07, $0f, $72, $06, $78, $06, $78, $07, $78, $8f, $70
    db $07, $fb, $fc, $88, $a0, $d1, $1f, $e0, $0f, $e0, $07, $ca, $11, $c5, $38, $41
    db $3a, $c2, $39, $c4, $33, $c8, $27, $d0, $0f, $e0, $5f, $45, $02, $01, $e0, $9f
    db $ef, $0f, $e7, $0f, $67, $0f, $76, $8f, $77, $0e, $ee, $0e, $ee, $0e, $fe, $0e
    db $e4, $19, $e0, $1e, $60, $1f, $a0, $5f, $80, $1f, $a0, $23, $80, $10, $e0, $1f
    db $c2, $4d, $80, $2f, $00, $0f, $e1, $0e, $e0, $0f, $e8, $e7, $00, $6c, $f2, $8b
    db $01, $18, $7a, $04, $80, $07, $a0, $0f, $98, $5f, $b8, $0f, $d8, $17, $e0, $8f
    db $48, $20, $c0, $05, $00, $01, $fe, $1e, $fd, $1e, $f8, $1d, $e4, $23, $c0, $2f
    db $c0, $2f, $c8, $07, $e4, $03, $e1, $28, $0c, $9e, $df, $ff, $ff, $1f, $f0, $0f
    db $c0, $0f, $a0, $2f, $60, $4f, $e2, $cc, $c8, $a1, $c3, $07, $bf, $1f, $25

MapBackgroundTileData40::
    db $40, $01, $d0, $00, $80, $02, $a2, $00, $5e, $f0, $0f, $c7, $3f, $84, $03, $a8
    db $80, $5d, $15, $88, $0e, $76, $15, $84, $03, $4f, $e0, $03, $fc, $f0, $ff, $fe
    db $06, $05, $a2, $3f, $c0, $8f, $41, $20, $44, $18, $fe, $c0, $20, $14, $94, $73
    db $8c, $01, $f4, $01, $80, $ff, $03, $b0, $d1, $07, $d8, $13, $dc, $08, $4d, $20
    db $4b, $20, $03, $30, $80, $7f, $00, $ff, $40, $fe, $c1, $fc, $c3, $39, $00, $e0
    db $1f, $46, $02, $88, $fe, $02, $85, $33, $00, $c0, $0f, $f0, $5f, $50, $20, $fa
    db $79, $00, $06, $20, $00, $c1, $a4, $f1, $08, $18, $41, $40, $27, $78, $f0, $67
    db $00, $f0, $41, $7a, $f0, $7d, $f8, $7e, $fc, $7e, $fc, $7d, $f8, $33, $80, $4f
    db $80, $01, $f0, $0f, $80, $70, $80, $6f, $8f, $df, $97, $fe, $ac, $2c, $20, $2e
    db $2c, $ec, $01, $fc, $01, $fe, $00, $56, $00, $7b, $10, $4b, $40, $de, $40, $ca
    db $40, $00, $5f, $bf, $9b, $00, $26, $c1, $04, $00, $89, $58, $a6, $ff, $00, $ff
    db $01, $0c, $0d, $48, $01, $82, $08, $00, $00, $80, $55, $eb, $ff, $ff, $7f, $f8
    db $1f, $e3, $1c, $00, $02, $80, $89, $e1, $df, $ff, $7f, $fe, $1f, $e0, $bf, $54
    db $eb, $1f, $a0, $23

MapBackgroundTileData50::
    db $30, $01, $11, $01, $80, $00, $7f, $00, $7e, $01, $fc, $02, $b8, $07, $70, $0b
    db $e0, $27, $c0, $0d, $00, $d0, $0f, $e0, $07, $e8, $03, $f4, $01, $de, $00, $6d
    db $40, $3e, $00, $fb, $47, $84, $98, $7c, $00, $30, $06, $46, $30, $20, $4c, $84
    db $03, $03, $00, $00, $20, $18, $e0, $1c, $80, $63, $9c, $31, $78, $f7, $03, $fc
    db $03, $bc, $43, $3c, $c0, $3f, $c0, $af, $18, $c0, $0a, $f0, $2f, $c0, $bf, $00
    db $ff, $00, $fe, $05, $10, $e0, $9f, $00, $ff, $02, $fc, $8b, $88, $50, $91, $7f
    db $00, $ff, $00, $40, $01, $58, $e6, $19, $80, $7f, $e0, $1f, $c0, $3f, $10, $80
    db $10, $80, $08, $fe, $41, $e0, $bf, $e0, $5f, $e2, $ff, $f0, $5f, $e5, $ff, $e2
    db $1f, $00, $60, $80, $1f, $f5, $bf, $ee, $df, $ff, $7f, $3f, $23, $41, $f0, $0f
    db $f4, $83, $7c, $a0, $17, $e8, $01, $7e, $88, $1f, $e4, $8f, $fa, $0f, $0d, $11
    db $22, $22, $c0, $3f, $d0, $0f, $f4, $03, $fc, $81, $3e, $40, $c5, $20, $1c, $ac
    db $fa, $04, $fb, $00, $ff, $f5, $f3, $fe, $31, $ff, $c0, $3f, $98, $e5, $c3, $fb
    db $9f, $e7, $ff, $06, $df, $e1, $ff, $c3, $bf, $c3, $7f, $81, $ef, $f4, $f3, $f9
    db $ff, $f9, $ff, $fe, $c1, $3f, $40, $3f, $09, $20, $d2, $bf, $5f, $bf, $ff, $3e
    db $ff, $3d, $fe, $3b, $3c, $e4, $9b, $e1, $df, $db, $ff, $fd, $ff, $fe, $bd, $7f
    db $fc, $3b, $fc, $37, $38, $fe, $81, $ff, $83, $fb, $87, $f7, $4f, $bf, $cf, $3b
    db $8c, $49, $02, $e1, $1f, $e0, $03, $fc, $0c, $7f, $8f, $bf, $d7, $ef, $d7, $ef
    db $df, $e7, $df, $03, $22

MapBackgroundTileData3::
    db $f0, $00, $a9, $00, $ff, $00, $f3, $0f, $e9, $1e, $c0, $3f, $88, $00, $29, $80
    db $00, $20, $94, $fd, $c3, $ef, $00, $00, $89, $60, $5f, $50, $74, $06, $1c, $00
    db $ca, $e2, $1e, $e1, $1f, $00, $59, $e1, $1f, $08, $02, $b0, $ee, $1f, $7c, $ff
    db $ff, $00, $4f, $b0, $03, $fc, $43, $bc, $03, $fc, $01, $fe, $fb, $fd, $fd, $fe
    db $ed, $1f, $36, $cf, $06, $fe, $13, $ee, $39, $12, $50, $74, $11, $00, $ff, $04
    db $8b, $10, $f0, $1f, $01, $46, $48, $04, $30, $80, $01, $fe, $01, $fe, $1d, $e2
    db $1f, $e0, $1f, $e0, $0f, $70, $47, $00, $d2, $e2, $1f, $d0, $0f, $d8, $07, $d8
    db $81, $10, $c0, $3f, $40, $06, $c0, $82, $fa, $07, $f9, $57, $f8, $07, $fe, $81
    db $08, $90, $0f, $f0, $4f, $30, $42, $b2, $91, $ea, $7f, $d5, $ff, $eb, $ff, $d5
    db $ff, $ea, $ff, $dd, $ff, $ef, $ff, $df, $03, $11, $06, $c6, $3f, $00, $c0, $3f
    db $21, $20, $00, $fe, $05, $fa, $05, $fa, $0f, $f0, $ff, $01, $14

MapBackgroundTileData60::
    db $a0, $02, $2f, $02, $04, $04, $82, $b7, $0a, $42, $40, $00, $c0, $0d, $e7, $19
    db $00, $00, $18, $06, $2c, $10, $7e, $12, $82, $4a, $ff, $01, $80, $24, $84, $83
    db $20, $5f, $40, $00, $ec, $03, $40, $78, $03, $f8, $0f, $00, $a1, $0e, $5a, $0d
    db $a0, $3a, $c7, $3f, $c4, $f7, $06, $31, $2c, $c2, $1f, $80, $60, $11, $fc, $03
    db $be, $41, $fe, $01, $ae, $50, $de, $20, $f4, $0a, $3e, $00, $00, $1e, $01, $4c
    db $05, $e2, $3f, $00, $08, $fd, $00, $f8, $03, $00, $24, $f8, $ff, $77, $f8, $75
    db $fa, $71, $fe, $f1, $84, $20, $cc, $f3, $0b, $0e, $01, $0c, $00, $08, $80, $10
    db $88, $84, $f7, $df, $37, $10, $88, $fe, $80, $70, $11, $40, $00, $e8, $e8, $2f
    db $00, $8c, $87, $5c, $3f, $32, $00, $cf, $30, $80, $7f, $00, $09, $c2, $39, $84
    db $ff, $ef, $07, $10, $ef, $00, $38, $08, $ca, $e1, $23, $1c, $dc, $c0, $80, $c8
    db $ff, $bf, $40, $df, $1f, $00, $e9, $10, $04, $05, $a0, $98, $00, $f6, $09, $62
    db $9d, $20, $de, $03, $fd, $14, $81, $71, $00, $ff, $80, $3f, $e8, $c7, $86, $00
    db $a3, $01, $4a, $f3, $0f, $3c, $c3, $08, $f7, $00, $ff, $08, $f7, $d8, $27, $bc
    db $03, $ec, $c3, $fa, $f1, $fe, $fc, $45, $15, $01, $30, $e2, $fc, $3b, $fa, $e9
    db $18, $18, $38, $08, $28, $fd, $fd, $7f, $ff, $cc, $3d, $72, $8c, $17, $e3, $cf
    db $f0, $33, $fe, $c9, $3d, $00, $46, $04, $10, $8a, $0e, $d0, $0a, $d4, $01, $3e
    db $c9, $36, $c0, $1f, $e1, $be, $41, $40, $e0, $21, $c0, $06, $0c, $80, $0c, $c0
    db $06, $b8, $41, $4e, $b4, $03, $f8, $4b, $bd, $cc, $3e, $6e, $17, $af, $9b, $d7
    db $cd, $e3, $e6, $79, $f3, $bc, $74, $5f, $b8, $47, $91, $b7, $c4, $43, $f2, $a1
    db $70, $50, $30, $20, $18, $10, $08, $00, $0a, $00, $07, $08, $05, $4a, $01, $ee
    db $04, $9b, $60, $2f, $c2, $1d, $d0, $bf, $32, $7d, $73, $ec, $f6, $d8, $e5, $99
    db $cb, $63, $97, $d7, $3e, $2f, $fd, $5e, $ea, $ad, $c6, $49, $8d, $83, $08, $07
    db $05, $0e, $02, $1c, $04, $18, $b8, $15, $40, $29, $86, $00, $85, $02, $95, $02
    db $b8, $07, $e8, $17, $88, $77, $80, $7f, $88, $f7, $0d, $f2, $1e, $e0, $9b, $61
    db $8b, $04, $48, $00, $ff, $c5, $f8, $d7, $e3, $df, $0f, $a2, $40, $f8, $ff, $e3
    db $f9, $df, $e1, $71, $8f, $c7, $3f, $9c, $7f, $76, $f8, $9d, $e1, $c7, $3d, $90
    db $7d, $6c, $f0, $99, $e1, $71, $80, $c1, $01, $00, $3b, $02, $28, $18, $e0, $e0
    db $83, $20, $00, $08, $00, $68, $00, $d0, $28, $90, $6f, $08, $00, $58, $00, $d0
    db $08, $70, $8b, $20, $db, $20, $de, $01, $fe, $21, $d8, $07, $00, $70, $00, $e8
    db $c8, $01, $d2, $c0, $a3, $1a, $87, $0c, $03, $b7, $82, $c0, $90, $04, $00, $c5
    db $e6, $81, $ec, $23, $c2, $c1, $ed, $23, $c3, $a0, $c4, $c3, $ed, $c3, $ed, $c3
    db $15, $40, $75, $22, $80, $e0, $0e, $60, $3d, $00, $1c, $dd, $80, $20, $a8, $03
    db $a8, $02, $f8, $02, $d8, $03, $50, $03, $b0, $03, $b8, $02, $d0, $23, $2c, $bb
    db $24, $0e, $a5, $04, $e1, $05, $29, $85, $c5, $fb, $00, $02, $78, $24, $10, $06
    db $04, $f8, $07, $f9, $c6, $3f, $40, $06, $00, $c2, $08, $fe, $ff, $fe, $3f, $fe
    db $e7, $19, $0e

MapBackgroundTileData4::
    db $60, $04, $a0, $02, $d0, $28, $56, $fc, $58, $87, $97, $60, $01, $d1, $02, $aa
    db $05, $44, $0b, $90, $12, $38, $39, $04, $9a, $60, $01, $d1, $02, $a4, $04, $46
    db $70, $81, $22, $58, $80, $b4, $80, $28, $82, $11, $58, $00, $20, $0a, $3c, $00
    db $20, $06, $00, $0f, $00, $07, $85, $23, $68, $20, $4c, $00, $ee, $03, $00, $22
    db $b2, $40, $11, $24, $20, $8a, $07, $b0, $1f, $10, $10, $d9, $07, $00, $c4, $1d
    db $00, $1e, $40, $1e, $e0, $fd, $00, $10, $88, $f8, $81, $04, $a6, $80, $5d, $f8
    db $81, $81, $b5, $02, $60, $dc, $81, $80, $ae, $03, $63, $05, $c0, $76, $02, $01
    db $5d, $13, $aa, $02, $76, $7d, $04, $08, $94, $02, $00, $04, $02, $14, $08, $30
    db $0e, $00, $4b, $00, $01, $c0, $a9, $02, $01, $e6, $01, $70, $12, $12, $0c, $08
    db $04, $04, $00, $24, $18, $01, $7e, $a1, $40, $40, $83, $49, $0a, $01, $03, $00
    db $46, $30, $81, $00, $49, $dc, $13, $50, $01, $8d, $f2, $03, $09, $4c, $01, $01
    db $18, $80, $1b, $80, $bf, $00, $f0, $87, $1f, $08, $20, $0a, $08, $03, $00, $3b
    db $00, $3f, $05, $80, $37, $fc, $08, $08, $c8, $07, $c0, $e7, $00, $11, $1e, $10
    db $2d, $d3, $1c, $e3, $1c, $e3, $18, $0c, $f5, $10, $d2, $2d, $e2, $1d, $0a, $81
    db $7e, $18, $ec, $03, $fe, $11, $ef, $e0, $1f, $50, $ac, $23, $d8, $f7, $00, $ff
    db $03, $0c, $91, $81, $a9, $78, $87, $7c, $83, $7f, $80, $77, $88, $3b, $c4, $63
    db $9c, $43, $bc, $47, $b8, $2f, $d0, $71, $8e, $60, $1f, $d0, $2f, $e8, $97, $7e
    db $01, $f9, $86, $60, $9f, $40, $bf, $01, $fe, $03, $fc, $07, $f8, $0f, $f0, $7b
    db $84, $5d, $22, $ea, $15, $d4, $2b, $8e, $71, $87, $78, $9b, $04, $1e, $fd, $03
    db $d4, $2b, $8c, $73, $84, $7b, $0c, $f3, $7c, $83, $30, $82, $a2, $56, $a9, $e2
    db $1c, $63, $9d, $30, $ce, $3d, $c2, $3f, $c0, $7f, $80, $ff, $00, $d7, $29, $be
    db $40, $77, $89, $32, $cc, $63, $9c, $63, $9c, $f3, $0c, $f3, $0c, $ff, $01, $7e
    db $81, $9e, $60, $0f, $f1, $06, $f9, $82, $7d, $82, $7d, $c2, $3d, $60, $d2, $04
    db $9b, $c8, $3c, $02, $c6, $01, $f8, $0b, $0a, $47, $f0, $0f, $c0, $3f, $84, $40
    db $00, $fc, $03, $f8, $07, $fc, $33, $34, $60, $dd, $03, $0c, $0f, $00, $9d, $ee
    db $ff, $c7, $ff, $19, $e6, $ef, $0f, $80, $68, $98, $07, $ba, $05, $ac, $03, $ae
    db $01, $8c, $03, $9a, $05, $d8, $07, $dc, $03, $4a, $bf, $02, $ff, $4a, $bf, $a8
    db $5f, $01, $ff, $ab, $5f, $82, $7f, $40, $bf, $ef, $21, $01, $94, $9f, $00, $20
    db $ec, $fd, $bf, $fc, $bf, $16, $00, $9d, $7a, $03, $00, $11, $ef, $bf, $ca, $9f
    db $eb, $9f, $ee, $df, $ef, $9f, $ef, $cf, $48, $84, $05, $7d, $0f, $f0, $03, $fc
    db $01, $fe, $86, $e2, $27, $fe, $81, $8e, $01, $40, $d4, $7f, $00, $e0, $09, $f6
    db $ff, $01, $9e, $20, $08, $11, $90, $2a, $41, $40, $23, $3c, $c0, $63, $80, $1f
    db $00, $83, $21, $58, $20, $a2, $1f, $60, $dc, $ff, $fe, $ff, $ff, $ff, $df, $ff
    db $86, $7f, $f8, $07, $80, $07, $c0, $04, $10, $04, $15, $0e, $00, $04, $04, $00
    db $00, $84, $a0, $14, $fe, $01, $fb, $84, $f1, $4e, $b5, $8f, $fc, $03, $d1, $02
    db $80, $6b, $80, $bf, $48, $d7, $31, $ce, $23, $7c, $8a, $ff, $1c, $3f, $ca, $dd
    db $11, $a0, $e4, $1f, $d0, $3f, $90, $6f, $50, $ff, $60, $be, $51, $ec, $f3, $0f
    db $c0, $38, $a7, $fa, $7d, $f5, $fb, $f2, $7f, $f5, $ce, $3e, $ff, $07, $af, $f2
    db $ff, $f9, $e7, $fc, $13, $ef, $40, $92, $02, $22, $d5, $00, $80, $51, $ae, $df
    db $31, $0e, $21, $10, $0e, $24, $75, $fe, $fd, $00, $5f, $fe, $ed, $fc, $f3, $fd
    db $ff, $f8, $73, $fe, $fd, $03, $5c, $e3, $2b, $ff, $38, $c4, $bb, $ff, $9f, $ff
    db $af, $df, $57, $ed, $7b, $24, $10, $fe, $01, $fe, $00, $7f, $81, $3e, $c0, $5f
    db $e1, $ef, $70, $19

    ld b, b
    ld bc, $00f6

jr_003_5416:
    ld b, l
    jr nc, $53d9

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
    jr nz, $53ab

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
    call nz, $7018
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

    jp nz, $5380

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
    jp $18ff


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

; $62ae: Pointers to the layer3 background data. Note that some levels share the same data.
PtrBaseLayer3Background::
    dw Layer3PtrBackground2 ; Level 0
    dw Layer3PtrBackground3 ; Level 1
    dw Layer3PtrBackground2 ; Level 2
    dw Layer3PtrBackground2 ; Level 3
    dw Layer3PtrBackground2 ; Level 4
    dw Layer3PtrBackground3 ; Level 5
    dw Layer3PtrBackground4 ; Level 6
    dw Layer3PtrBackground4 ; Level 7
    dw Layer3PtrBackground2 ; Level 8
    dw Layer3PtrBackground5 ; Level 9
    dw Layer3PtrBackground2 ; Level 10
    dw Layer3PtrBackground2 ; Level 11

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

; $65b3: Compressed $1ec. Decompressed $200.
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

; $679f: Compressed $146. Decompressed $180.
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

; $68e5: Compressed $122. Decompressed $12c.
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

; $6a07: Compressed $139. Decompressed $200.
Layer3PtrBackground6::
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
    db $11, $40, $47, $0f, $46, $22, $0b, $00, $02

; $6b40: Pointers to the Layer 2 background data for individual levels.
PtrBaseLayer2Background::
    dw Layer2PtrBackground2  ; Level 0
    dw Layer2PtrBackground3, ; Level 1
    dw Layer2PtrBackground2, ; Level 2
    dw Layer2PtrBackground2, ; Level 3
    dw Layer2PtrBackground2, ; Level 4
    dw Layer2PtrBackground3, ; Level 5
    dw Layer2PtrBackground4, ; Level 6
    dw Layer2PtrBackground4, ; Level 7
    dw Layer2PtrBackground2, ; Level 8
    dw Layer2PtrBackground5, ; Level 9
    dw Layer2PtrBackground2, ; Level 10
    dw Layer2PtrBackground2  ; Level 11

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
    db $db, $03, $d4, $03, $00, $bc, $5b, $24, $08, $00, $ee, $f1, $07

; $6e69: Compressed $19f. Decompressed $1c0.
Layer2PtrBackground3::
    db $c0, $01, $9b, $01, $00, $03, $11, $13, $05, $07, $05, $15, $09, $0b, $17, $19
    db $0d, $0f, $1b, $1d, $5d, $5d, $37, $3b, $5d, $5d, $3d, $3f, $5d, $5d, $41, $43
    db $5d, $5d, $45, $47, $05, $8f, $05, $95, $91, $4b, $02, $d0, $84, $00, $ce, $00
    db $ce, $82, $cf, $d1, $d2, $d0, $85, $d3, $8c, $d4, $00, $d4, $00, $ae, $ae, $de
    db $df, $14, $09, $94, $81, $a3, $a0, $f0, $0a, $0b, $2e, $6b, $08, $5c, $9b, $a5
    db $ad, $b5, $25, $2f, $37, $04, $c6, $40, $bb, $00, $7a, $05, $ed, $06, $ca, $c0
    db $51, $50, $d8, $e5, $ed, $f5, $35, $04, $9a, $fd, $02, $07, $83, $73, $77, $1b
    db $02, $43, $21, $10, $a8, $66, $6c, $7e, $5e, $5d, $68, $cd, $28, $d8, $2c, $d8
    db $ac, $60, $aa, $a0, $40, $5a, $ba, $d9, $49, $5a, $ea, $f9, $49, $5a, $0a, $1a
    db $4a, $5a, $2a, $3a, $7a, $0a, $12, $e0, $b9, $6b, $ec, $60, $61, $c3, $ec, $46
    db $ed, $6d, $d4, $54, $f0, $55, $d6, $58, $d9, $d6, $40, $d5, $c4, $47, $c8, $48
    db $c9, $49, $ca, $4a, $cb, $4b, $4c, $8f, $0c, $8e, $84, $c4, $25, $66, $a5, $a5
    db $84, $04, $02, $90, $48, $62, $92, $92, $83, $e3, $12, $f3, $00, $04, $1c, $95
    db $96, $1c, $1c, $99, $9a, $12, $8f, $8f, $1c, $90, $12, $1c, $90, $91, $1c, $12
    db $91, $1c, $92, $92, $12, $dc, $dd, $0a, $0a, $1b, $01, $50, $ea, $0e, $07, $07
    db $17, $07, $0f, $1f, $07, $27, $57, $00, $30, $05, $18, $05, $ef, $6f, $f4, $f4
    db $02, $c0, $a4, $9b, $9f, $2b, $68, $70, $77, $0f, $17, $7b, $7f, $ab, $af, $7b
    db $7f, $73, $b3, $83, $2b, $88, $2b, $0c, $17, $13, $b7, $9b, $bb, $2b, $28, $dc
    db $e6, $be, $eb, $c2, $97, $2b, $28, $b8, $ba, $92, $97, $bb, $ba, $9a, $9f, $e3
    db $ea, $92, $77, $13, $1b, $73, $9f, $df, $c6, $e3, $ea, $e6, $04, $10, $e4, $15
    db $0a, $15, $18, $15, $92, $97, $99, $15, $e6, $f1, $f3, $e9, $eb, $f5, $f7, $23
    db $c2, $04, $00, $01, $20, $a3, $79, $05, $05, $fa, $7a, $05, $05, $fb, $7b, $fc
    db $7c, $85, $7f, $fd, $fd, $e5, $24, $fe, $fe, $65, $25, $7f, $8b, $00, $81, $02
    db $a0, $02, $22, $53, $13, $63, $23, $c0, $92, $22, $f0, $c8, $29, $d4, $fe, $9e
    db $bf, $5f, $41, $c1, $5f, $41, $e1, $5f, $01, $70, $39, $09, $60, $69, $59, $89
    db $a9, $49, $01, $d1, $d5, $15, $60, $c9, $d5, $95, $b1, $d1, $d5, $55, $24

; $7008: Compressed $101. Decompressed $138.
Layer2PtrBackground4::
    db $38, $01, $fd, $00, $80, $81, $86, $87, $82, $83, $80, $81, $84, $85, $88, $89
    db $9d, $9e, $00, $a0, $a1, $00, $99, $00, $00, $9a, $00, $9a, $18, $01, $80, $93
    db $0c, $00, $20, $4d, $76, $7a, $52, $82, $86, $56, $86, $5e, $5a, $6a, $5a, $6a
    db $8e, $92, $8e, $92, $0a, $96, $02, $9a, $12, $9e, $22, $a2, $02, $9a, $06, $96
    db $6e, $72, $7e, $82, $44, $88, $4b, $7d, $3d, $92, $9d, $10, $18, $b5, $87, $aa
    db $ab, $ac, $ad, $86, $c0, $a8, $3d, $34, $b4, $05, $04, $34, $1c, $8a, $eb, $2b
    db $2c, $6e, $ee, $a1, $01, $60, $6e, $75, $77, $79, $7b, $7d, $0d, $7f, $0d, $01
    db $15, $00, $4a, $b1, $b7, $b2, $b1, $b9, $b2, $86, $b6, $b5, $b3, $b3, $b4, $b4
    db $b6, $b9, $87, $8b, $8c, $c4, $c5, $c6, $86, $c7, $86, $80, $80, $c8, $c9, $80
    db $ca, $86, $87, $20, $09, $08, $5b, $06, $34, $3c, $04, $0c, $44, $4e, $66, $6e
    db $76, $7e, $5e, $64, $1c, $25, $85, $48, $41, $17, $75, $b5, $f6, $b6, $f5, $35
    db $77, $00, $02, $40, $e9, $5b, $41, $00, $c0, $35, $28, $09, $1a, $5a, $7a, $9a
    db $30, $60, $a5, $10, $08, $10, $85, $45, $46, $09, $c9, $02, $c0, $94, $04, $75
    db $35, $e0, $b6, $82, $82, $37, $60, $02, $29, $02, $81, $02, $a0, $00, $29, $02
    db $81, $04, $a0, $00, $29, $02, $01, $07, $60, $ae, $2c, $a0, $02, $e0, $b2, $e1
    db $a1, $82, $08, $00, $16, $19, $25, $4d, $d3, $d5, $d7, $d9, $01, $15, $14, $a2
    db $1b

; $7109: Compressed $11d. Decompressed $138.
Layer2PtrBackground5::
    db $38, $01, $19, $01, $00, $01, $03, $07, $00, $22, $48, $28, $38, $00, $f8, $03
    db $00, $30, $3c, $34, $3c, $0c, $44, $44, $04, $c9, $25, $26, $0a, $00, $ea, $12
    db $cc, $31, $36, $3a, $3e, $42, $46, $4a, $4e, $56, $52, $5a, $5e, $52, $52, $62
    db $52, $66, $6a, $6e, $72, $52, $52, $7e, $82, $76, $7a, $86, $8a, $8e, $92, $96
    db $9a, $9e, $02, $94, $9a, $92, $04, $c0, $29, $35, $31, $51, $75, $35, $d1, $00
    db $10, $05, $d8, $1a, $e8, $fa, $0a, $68, $10, $10, $57, $58, $41, $60, $b8, $06
    db $06, $c2, $06, $16, $02, $bc, $02, $18, $c5, $52, $52, $b2, $ae, $52, $1a, $00
    db $9a, $50, $63, $01, $00, $08, $00, $44, $01, $8c, $7c, $7f, $29, $29, $51, $57
    db $29, $29, $13, $17, $59, $57, $13, $17, $51, $63, $15, $13, $59, $57, $15, $13
    db $51, $63, $31, $12, $18, $00, $00, $b2, $b3, $94, $b4, $94, $94, $88, $c0, $00
    db $00, $a8, $b5, $bd, $2d, $10, $41, $80, $a5, $5c, $5c, $01, $00, $17, $25, $a5
    db $ee, $ae, $ee, $2e, $00, $c0, $6b, $ab, $22, $10, $60, $5d, $01, $06, $01, $56
    db $bb, $bc, $bd, $b8, $b9, $bc, $bd, $85, $08, $20, $08, $44, $0c, $0c, $a4, $a4
    db $c4, $dd, $4d, $4c, $00, $48, $e2, $22, $00, $80, $62, $22, $00, $00, $70, $02
    db $00, $29, $98, $32, $78, $20, $18, $b7, $01, $80, $23, $61, $c2, $c2, $40, $42
    db $60, $50, $52, $16, $53, $1a, $1a, $07, $22, $b2, $ae, $5a, $5e, $ca, $da, $3a
    db $82, $80, $72, $f8, $98, $92, $12, $99, $52, $39, $99, $72, $18, $80, $b7, $57
    db $37, $17, $00, $60, $b8, $18, $00, $60, $94, $b4, $d6, $56, $23

; $7226: Compressed $111. Decompressed $144.
Layer2PtrBackground6::
    db $44, $01, $0d, $01, $20, $80, $6c, $60, $df, $41, $01, $00, $e8, $f1, $29, $38
    db $30, $40, $00, $48, $50, $c0, $61, $0c, $a2, $0d, $40, $13, $20, $68, $d1, $5a
    db $6a, $70, $08, $a1, $2a, $a5, $a2, $62, $00, $0d, $21, $aa, $c4, $84, $c4, $44
    db $01, $c0, $08, $c3, $e2, $22, $43, $03, $c0, $02, $23, $e3, $e2, $49, $23, $a7
    db $41, $f8, $e5, $04, $00, $30, $18, $0c, $00, $10, $8f, $90, $0f, $11, $a7, $1d
    db $44, $20, $da, $41, $c9, $01, $02, $00, $38, $01, $40, $49, $51, $59, $51, $0c
    db $5e, $e5, $b8, $bc, $c0, $c4, $c8, $00, $00, $cc, $00, $fc, $bc, $e0, $c4, $c0
    db $00, $c8, $cc, $d8, $dc, $d8, $dc, $58, $44, $08, $12, $50, $0d, $05, $00, $88
    db $76, $02, $84, $4f, $05, $25, $50, $91, $ce, $4e, $92, $d2, $12, $53, $d3, $01
    db $00, $4a, $c1, $67, $41, $81, $61, $01, $80, $01, $21, $8c, $d4, $d1, $c1, $c1
    db $b1, $b1, $61, $00, $b0, $02, $00, $60, $01, $68, $61, $71, $69, $f9, $71, $c9
    db $01, $62, $00, $40, $19, $19, $1d, $1d, $21, $21, $19, $80, $60, $60, $d1, $84
    db $cf, $c4, $93, $8e, $cd, $8f, $cd, $0d, $c0, $0d, $40, $0e, $4e, $40, $c0, $c0
    db $80, $44, $80, $00, $80, $84, $c4, $c4, $04, $c8, $e9, $10, $28, $83, $62, $40
    db $e8, $ec, $e0, $e4, $10, $80, $80, $0a, $87, $47, $87, $aa, $67, $87, $ca, $87
    db $ea, $c9, $29, $e7, $87, $2a, $07, $28, $20, $20, $28, $68, $c7, $c8, $48, $08
    db $a5, $4a, $65, $c5, $0a, $eb, $2a, $ab, $d4, $94, $ea, $94, $ea, $09, $d5, $29
    db $25

; $7337: Tile map data of the virgin logo shown during startup. Compressed $d3, Decompressed $240.
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
    db $a4, $80, $00, $90, $d0, $d5, $d9, $dd, $e1, $e5, $09, $08, $08, $54, $28, $d6
    db $0a, $00, $02

; $740a: Tile data of the virgin logo shown during startup. Compressed $4b7, Decompressed $7a0.
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
    db $f0, $8f, $a1, $10, $00, $fe, $05

; $78c1: Tile map data of the Jungle Book logo shown in the start menu. Compressed $8d, Decompressed $d0.
CompressedJungleBookLogoTileMap::
    db $d0, $00, $89, $00, $00, $a0, $09, $10, $18, $20, $28, $30, $38, $40, $48, $50
    db $50, $44, $74, $da, $02, $43, $83, $c3, $03, $44, $84, $c4, $04, $45, $85, $c5
    db $05, $06, $40, $86, $c6, $06, $c7, $44, $12, $90, $3a, $3c, $3e, $40, $42, $44
    db $46, $48, $4a, $4c, $4e, $50, $52, $54, $56, $58, $5a, $5c, $5e, $60, $28, $92
    db $80, $14, $23, $33, $43, $53, $63, $73, $83, $93, $a3, $b3, $c3, $d3, $e3, $f3
    db $03, $14, $24, $34, $44, $44, $11, $05, $a4, $22, $a3, $23, $a4, $24, $a5, $25
    db $a6, $26, $a7, $27, $a8, $28, $a9, $29, $aa, $2a, $ab, $ab, $89, $28, $20, $61
    db $65, $69, $6d, $65, $65, $71, $75, $79, $65, $7d, $81, $85, $89, $8d, $91, $65
    db $65, $95, $4d, $64, $09, $0e, $88, $d9, $99, $40, $08, $00, $02

; $794e: Tile data of the Jungle Book logo shown in the start menu. Compressed $527, Decompressed $680.
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
    db $11, $2c, $0f, $60, $60, $09, $00

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
