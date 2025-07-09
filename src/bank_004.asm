SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

; $4000: Loads the index data for staff residing in the background, such as plants, bottom ground and stones.
; The data is stored in an array starting at $cefe.
InitBgDataIndices::
    push bc
    ld hl, CompressedDataLeveBgBasePtr
    add hl, bc                      ; Data at $4401a + offset
    ld a, [hl+]
    ld h, [hl]                      ; Loading some pointer
    ld l, a
    ld de, _RAM + $efe              ; Put data into $cefe (WRAM)
    push de
    call DecompressData
    pop hl
    pop bc
    ld a, [hl+]
    ld [LevelWidthDiv32], a         ; Set level width in pixels divided by 32 (so 4 tiles).
    ld a, [hl]
    ld [LevelHeightDiv32], a        ; Set level height in pixels divided by 32 (so 4 tiles).
    ret

; $401a: Here reside the pointers to each level's back ground index array.
; The array is 2D with the first two bytes indicating width and length.
; Each element in the array is an index for a 4x4 supertile.
CompressedDataLeveBgBasePtr:
    dw CompressedDataLevel1Bg       ; Pointer level 1: JUNGLE BY DAY ($4032)
    dw CompressedDataLevel2Bg       ; Pointer level 2: THE GREAT TREE ($44d2)
    dw CompressedDataLevel3Bg       ; Pointer level 3: DAWN PATROL ($491e)
    dw CompressedDataLevel4Bg       ; Pointer level 4: BY THE RIVER ($4d0d)
    dw CompressedDataLevel5Bg       ; Pointer level 5: IN THE RIVER ($51d8)
    dw CompressedDataLevel6Bg       ; Pointer level 6: TREE VILLAGE ($5653)
    dw CompressedDataLevel7Bg       ; Pointer level 7: ANCIENT RUINS ($5c10)
    dw CompressedDataLevel8Bg       ; Pointer level 8: FALLING RUINS ($6291)
    dw CompressedDataLevel9Bg       ; Pointer level 9: JUNGLE BY NIGHT ($66cb)
    dw CompressedDataLevel10Bg      ; Pointer level 10: THE WASTELANDS ($6c3e)
    dw CompressedDataLevel11Bg      ; Pointer level 11: Bonus ($7106)
    dw CompressedDataLevel12Bg      ; Pointer level 12: Transition and credit screen ($727f)

; Level 1 "JUNGLE BY DAY" background indices. Map size in pixels: 3072 x 512.. Decompressed: 1538 Bytes; Compressed: 1184 Bytes
CompressedDataLevel1Bg::
    INCBIN "bin/CompressedDataLevel1Bg.bin"

; $44d2. Compressed $44c. Decompressed $602.
CompressedDataLevel2Bg::
    INCBIN "bin/CompressedDataLevel2Bg.bin"

; $491e: Compressed $3ef. Decompressed $692.
CompressedDataLevel3Bg::
    INCBIN "bin/CompressedDataLevel3Bg.bin"

; $4d0d: Compressed $4cb. Decompressed $802.
CompressedDataLevel4Bg::
    INCBIN "bin/CompressedDataLevel4Bg.bin"

; $51d8: Compressed $47b. Decompressed $702.
CompressedDataLevel5Bg::
    INCBIN "bin/CompressedDataLevel5Bg.bin"

; $5653: Compressed $5bd. Decompressed $802.
CompressedDataLevel6Bg::
    INCBIN "bin/CompressedDataLevel6Bg.bin"

; $5c10: Compressed $681. Decompressed $802.
CompressedDataLevel7Bg::
    INCBIN "bin/CompressedDataLevel7Bg.bin"

; $6291: Compressed $436. Decompressed $6f8.
CompressedDataLevel8Bg::
    INCBIN "bin/CompressedDataLevel8Bg.bin"

; $66cb: Compressed $56f. Decompressed $802.
CompressedDataLevel9Bg::
    INCBIN "bin/CompressedDataLevel9Bg.bin"

; $6c3e: Compressed $4c4. Decompressed $802.
CompressedDataLevel10Bg::
    INCBIN "bin/CompressedDataLevel10Bg.bin"

; $7106: Compressed $175. Decompressed $1e2.
CompressedDataLevel11Bg::
    INCBIN "bin/CompressedDataLevel11Bg.bin"

; $727f: Compressed $2e. Decompressed $34.
CompressedDataLevel12Bg::
  INCBIN "bin/CompressedDataLevel12Bg.bin"

; $72b1: Indices for the object sprites that have to be loaded into the VRAM for a given animation.
; The indices are addressed by the elements in ObjAnimationIndicesPtr.
ObjAnimationIndices::
    db $02                                              ; $0000
    db $04, $06, $08, $0a, $14, $16, $18, $1a           ; $0001 ID_BOAR
    db $0c, $0e, $08, $0a, $1c, $1e, $20, $22           ; $0009 ID_BOAR
    db $02, $10, $08, $0a, $24, $26, $28, $22           ; $0011 ID_BOAR
    db $02, $12, $08, $0a, $2a, $2c, $2e, $30           ; $0019 ID_BOAR
    db $02, $08, $0a, $0c, $18, $1a, $1c, $02, $02, $02, $04, $02, $0e, $10, $1e
    db $20, $02, $02, $06, $02, $02, $02, $12, $14, $16, $22, $24, $26, $02, $02, $28
    db $2a, $0c, $18, $34, $1c, $02, $02, $02, $04, $02, $2c, $2e, $1e, $36, $02, $02
    db $06, $02, $02, $02, $30, $32, $16, $22, $38, $3a, $02, $0a, $0c, $0e, $02, $02
    db $20, $22, $24, $0a, $10, $12, $02, $02, $20, $22, $24, $02, $04, $06, $08, $02
    db $14, $16, $18, $20, $26, $28, $02, $02, $02, $1a, $1c, $1e, $2a, $2c, $2e, $02
    db $02, $04, $02, $02, $02, $06, $0c, $0e, $10, $12, $14, $02, $2a, $2c, $2e, $02
    db $08, $02, $02, $02, $0a, $16, $18, $1a, $1c, $1e, $02, $30, $32, $34, $02, $20
    db $22, $24, $26, $28, $02, $30, $36, $38, $02, $04, $06, $08, $0a, $02, $14, $16
    db $18, $1a, $1c, $0c, $0e, $10, $12, $02, $1e, $20, $18, $22, $24, $26, $28, $2a
    db $2c, $2e, $02, $3a, $18, $3c, $02, $30, $32, $34, $36, $38, $02, $3a, $18, $3e
    db $02, $3a, $3c, $3e, $40, $42, $02, $30, $32, $44, $02, $02, $0a, $0c, $0e, $14
    db $16, $02, $02, $10, $12, $18, $1a, $1c, $1e, $04, $06, $08, $0a, $02, $26, $28
    db $02, $0c, $0e, $10, $12, $02, $2a, $2c, $02, $14, $16, $18, $1a, $1c, $02, $2e
    db $30, $32, $02, $1e, $20, $22, $24, $34, $36, $38, $3a, $0c, $0e, $10, $12, $02
    db $1c, $1e, $02, $04, $06, $02, $02, $14, $16, $18, $1a, $02, $02, $08, $0a, $14
    db $1c, $1e, $20, $02, $14, $16, $18, $1a, $1c, $1e, $20, $02, $02, $04, $0c, $06
    db $0e, $08, $10, $0a, $12, $06, $08, $0a, $1a, $02, $02, $04, $06, $08, $0a, $18
    db $1a, $02, $02, $02, $04, $06, $08, $0a, $1c, $1e, $1a, $02, $02, $02, $02, $04
    db $06, $08, $0a, $14, $16, $18, $1a, $02, $02, $22, $02, $28, $2a, $20, $22, $02
    db $26, $28, $2a, $38, $02, $02, $02, $20, $22, $02, $3e, $26, $28, $2a, $40, $38
    db $02, $02, $02, $20, $22, $02, $2c, $2e, $30, $32, $02, $20, $22, $02, $24, $26
    db $28, $2a, $02, $20, $22, $02, $24, $26, $28, $2a, $3a, $3c, $02, $02, $02, $02
    db $20, $22, $02, $02, $24, $26, $28, $2a, $34, $36, $38, $02, $02, $02, $22, $24
    db $26, $28, $32, $34, $36, $38, $3a, $02, $22, $24, $2a, $2c, $32, $34, $36, $38
    db $3a, $02, $22, $24, $2e, $30, $32, $34, $36, $38, $3a, $22, $24, $26, $28, $34
    db $36, $38, $3a, $22, $24, $2a, $2c, $34, $36, $38, $3a, $22, $24, $2e, $30, $34
    db $36, $38, $3a, $02, $04, $06, $02, $0c, $0e, $10, $12, $02, $08, $0a, $02, $0c
    db $14, $16, $12, $0c, $18, $1a, $12, $1c, $24, $26, $22, $1c, $2c, $2e, $22, $0c
    db $30, $32, $12, $02, $28, $2a, $02, $0c, $34, $10, $12, $02, $04, $06, $02, $16
    db $18, $1a, $1c, $02, $02, $08, $1e, $20, $22, $02, $02, $0a, $24, $26, $28, $02
    db $0c, $0e, $10, $2a, $2c, $2e, $30, $02, $12, $14, $02, $32, $34, $36, $38, $04
    db $06, $02, $20, $22, $24, $08, $0a, $0c, $26, $28, $02, $0e, $10, $12, $2a, $2c
    db $02, $14, $16, $18, $02, $2e, $30, $1a, $1c, $1e, $02, $32, $34, $12, $14, $16
    db $18, $02, $04, $06, $08, $0a, $0c, $0e, $10, $1c, $1e, $20, $34, $36, $38, $04
    db $06, $02, $02, $08, $0a, $0c, $0e, $04, $06, $02, $02, $18, $1a, $1c, $0e, $10
    db $12, $02, $02, $1e, $20, $22, $24, $14, $16, $02, $02, $26, $28, $2a, $0e, $10
    db $12, $02, $02, $2c, $2e, $30, $24, $04, $0a, $0c, $04, $0e, $10, $0c, $1c, $1e
    db $20, $04, $06, $08, $0a, $10, $12, $14, $16, $04, $06, $08, $0c, $18, $1a, $1c
    db $1e, $04, $06, $08, $0a, $20, $22, $24, $26, $04, $06, $08, $0e, $28, $2a, $2c
    db $2e, $18, $02, $18, $02, $18, $02, $18, $02, $18, $1a, $02, $1c, $02, $1e, $02
    db $20, $3e, $40, $3e, $40, $04, $06, $14, $16, $0c, $0e, $18, $1a, $12, $10, $0c
    db $10, $14, $10, $12, $0a, $42, $44, $46, $48, $2e, $30, $32, $34, $02, $3c, $3e
    db $02, $26, $28, $2a, $2c, $36, $38, $3a, $02, $40, $02, $22, $02, $36, $38, $3a
    db $40, $02, $22, $02, $24, $02, $02, $26, $28, $2a, $2c, $36, $38, $3a, $02, $40
    db $02, $22, $02, $02, $24, $02, $02, $2e, $30, $32, $34, $02, $3c, $3e, $02, $02
    db $04, $06, $0a, $0c, $0e, $10, $12, $14, $16, $1e, $20, $02, $02, $08, $02, $02
    db $18, $1a, $1c, $02, $02, $22, $16, $18, $1a, $2a, $2c, $2e, $02, $1c, $1e, $20
    db $30, $32, $34, $02, $02, $1c, $22, $24, $30, $32, $34, $02, $02, $1c, $26, $28
    db $30, $32, $34, $02, $02, $04, $06, $02, $14, $16, $18, $1a, $30, $32, $34, $36
    db $4e, $50, $52, $54, $68, $6a, $6c, $6e, $02, $08, $0a, $1c, $1e, $20, $38, $3a
    db $3c, $56, $58, $52, $5a, $70, $72, $74, $76, $02, $0c, $0e, $02, $22, $24, $26
    db $02, $3e, $40, $42, $44, $5c, $52, $5e, $60, $78, $7a, $7c, $7e, $02, $10, $12
    db $02, $28, $2a, $2c, $2e, $46, $48, $4a, $4c, $62, $52, $64, $66, $80, $82, $84
    db $86, $04, $06, $02, $02, $02, $08, $0a, $0c, $0e, $10, $2c, $2e, $30, $02, $02
    db $02, $02, $68, $6a, $84, $86, $88, $8a, $8c, $8e, $90, $92, $12, $14, $16, $18
    db $1a, $02, $02, $32, $34, $36, $38, $3a, $50, $52, $54, $56, $6c, $6e, $70, $72
    db $1c, $1e, $20, $22, $02, $3c, $3e, $40, $42, $44, $58, $5a, $5c, $5e, $74, $76
    db $78, $7a, $24, $26, $28, $2a, $02, $46, $48, $4a, $4c, $4e, $60, $62, $64, $66
    db $7c, $7e, $80, $82, $04, $38, $08, $02, $1c, $1e, $20, $22, $6e, $70, $72, $74
    db $88, $8a, $8c, $8e, $04, $06, $08, $02, $1c, $1e, $20, $22, $0a, $0c, $0e, $02
    db $24, $26, $28, $2a, $10, $12, $14, $2c, $2e, $30, $16, $18, $1a, $32, $34, $36
    db $3a, $3c, $3e, $40, $54, $56, $58, $5a, $42, $44, $46, $48, $5c, $5e, $60, $62
    db $4a, $4c, $4e, $64, $66, $68, $16, $50, $52, $32, $6a, $6c, $6e, $70, $72, $74
    db $90, $92, $94, $02, $76, $78, $7a, $7c, $02, $96, $98, $9a, $7e, $80, $82, $9c
    db $9e, $a0, $16, $84, $86, $32, $a2, $a4, $04, $06, $08, $1a, $1c, $1e, $0a, $0c
    db $08, $1a, $1c, $1e, $0e, $10, $0c, $08, $02, $1a, $1c, $1e, $12, $14, $0c, $08
    db $02, $1a, $1c, $1e, $16, $18, $0c, $08, $20, $22, $1c, $1e, $6e, $70, $72, $74
    db $90, $92, $b8, $02, $6e, $70, $72, $74, $90, $ba, $bc, $02, $6e, $70, $72, $74
    db $90, $be, $c0, $c2, $6e, $70, $72, $74, $90, $a6, $a8, $aa, $6e, $70, $72, $74
    db $ac, $ae, $b0, $b2, $6e, $70, $72, $74, $90, $b4, $b6, $02, $08, $0a, $0c, $0e
    db $12, $14, $08, $0a, $10, $0e, $12, $14, $04, $06, $08, $0a, $14, $16, $18, $12
    db $02, $04, $06, $08, $0a, $0e, $10, $12, $14, $16, $02, $02, $02, $02, $04, $06
    db $02, $0c, $0e, $10, $12, $14, $16, $18, $26, $28, $02, $2a, $2c, $2e, $02, $32
    db $14, $02, $1e, $20, $30, $02, $34, $36, $22, $3a, $08, $0a, $02, $02, $1a, $1c
    db $10, $12, $02, $02, $02, $1e, $04, $06, $02, $14, $16, $18, $20, $22, $24, $02
    db $02, $02, $04, $06, $08, $0c, $18, $1a, $02, $1c, $12, $14, $16, $04, $06, $08
    db $0a, $0c, $0e, $10, $12, $1a, $1c, $1e, $20, $22, $28, $2a, $2c, $2e, $30, $32
    db $34, $36, $02, $04, $06, $08, $0a, $24, $26, $28, $2a, $02, $4a, $4c, $4e, $6c
    db $6e, $02, $02, $0c, $0e, $02, $2c, $2e, $30, $32, $50, $52, $54, $56, $70, $72
    db $74, $76, $78, $7a, $10, $12, $14, $16, $02, $34, $36, $38, $02, $58, $5a, $5c
    db $02, $18, $1a, $1c, $3a, $3c, $3e, $40, $02, $5e, $60, $62, $42, $44, $46, $48
    db $64, $66, $68, $6a, $7c, $7e, $80, $82, $8c, $8e, $90, $92, $84, $86, $88, $8a
    db $94, $96, $98, $9a, $a2, $a4, $a6, $a8, $02, $02, $02, $02, $04, $08, $0a, $0c
    db $0e, $10, $12, $14, $16, $02, $18, $1a, $34, $36, $38, $3a, $56, $58, $5a, $02
    db $3c, $3e, $40, $42, $5c, $5e, $60, $62, $02, $06, $02, $22, $24, $02, $44, $46
    db $48, $64, $66, $68, $02, $4a, $4c, $4e, $6a, $6c, $6e, $70, $02, $72, $74, $02
    db $76, $78, $7a, $7c, $7e, $80, $82, $84, $02, $0c, $0e, $02, $28, $2a, $2c, $2e
    db $52, $54, $56, $58, $72, $74, $76, $02, $02, $02, $02, $10, $12, $30, $32, $34
    db $36, $02, $5a, $5c, $5e, $60, $78, $7a, $7c, $7e, $02, $04, $06, $08, $02, $14
    db $16, $18, $38, $3a, $3c, $3e, $02, $62, $64, $66, $68, $80, $82, $84, $02, $86
    db $0a, $02, $02, $02, $1a, $1c, $1e, $18, $40, $42, $44, $46, $6a, $6c, $6e, $02
    db $70, $20, $22, $24, $26, $4a, $4c, $4e, $50

; $789a: These are offsets that are later added to ObjAnimationIndices to form a pointer.
ObjAnimationIndicesPtr::
    dw $0000
    dw $0001, $0009, $0011, $0019                             ; ID_BOAR
    dw $0021, $0029, $0032, $003e, $0046, $004f               ; ID_WALKING_MONKY
    dw $005b, $0063, $006b, $0077                             ; ID_COBRA
    dw $0081, $0090, $009f, $00a9, $00b3, $00bd, $00c7, $00d1 ; ID_EAGLE
    dw $0001
    dw $00db, $00e3, $00e9, $00f1, $00f9, $0103, $0001, $010b
    dw $0001, $0086, $0005, $000d, $0015, $003f, $001e, $0054
    dw $0086, $0113, $011b, $0123, $012d, $012f, $0131, $0133
    dw $0004, $0003, $0135, $013b, $0086, $0001, $0143, $014d
    dw $001d, $0159, $015d, $0166, $000f, $0172, $017a, $0182
    dw $018e, $019d, $01a7, $01b1, $01bb, $01c3, $01cb, $01d3
    dw $01db, $01e3, $000d, $01e7, $01eb, $01ef, $01f3, $01fb
    dw $0203, $0209, $020f, $0217, $021f, $0225, $022b, $0231
    dw $0237, $0127, $023d, $0241, $0242, $0088, $0006, $0249
    dw $003a, $00be, $00ff, $00d1, $0000, $0000, $0000, $024f
    dw $0257, $025f, $0267, $026f, $003a, $0001, $0277, $027a
    dw $0037, $0001, $0086, $0005, $027d, $003a, $0016, $001d
    dw $001f, $0281, $0289, $0291, $0299, $0054, $00c9, $0058
    dw $00d2, $02a1, $002d, $0037, $02b1, $0001, $0086, $02b5
    dw $02b9, $0001, $0009, $0005, $002d, $02bd, $02bf, $02c1
    dw $0003, $02c3, $0006, $0007, $0008, $000d, $000e, $000f
    dw $02c5, $02c7, $0016, $001d, $003a, $001f, $009c, $00a6
    dw $0059, $00c5, $02c9, $02d1, $02d9, $02dd, $02d1, $02e3
    dw $02f3, $02ff, $0305, $030d, $0060, $0000, $00d3, $0316
    dw $031c, $0324, $032c, $0334, $0340, $0348, $0351, $0359
    dw $0365, $036d, $0379, $0381, $0390, $039c, $03a8, $03b0
    dw $03ba, $03c2, $03cc, $03d4, $03dc, $03e4, $03ec, $03f4
    dw $03fa, $0400, $0408, $0410, $0416, $041c, $0424, $042c
    dw $0432, $0438, $043e, $0444, $044c, $0454, $045c, $0464
    dw $046c, $0474, $047c, $0484, $0000, $0000, $0000, $0000
    dw $0000, $0001, $048c, $0492, $0498, $0015, $04a0, $0103
    dw $04aa, $0103, $04b8, $04c4, $04ca, $04d6, $04df, $00bd
    dw $04ed, $04f5, $04fa, $0000, $0000, $0000, $0000, $0000
    dw $0000, $0000, $0000, $0000, $0000, $0000, $0000, $0000
    dw $0000, $0502, $050c, $0512, $051e, $0524, $0530, $000e
    dw $053c, $0544, $042f, $054c, $0554, $0558, $0517, $0562
    dw $0568, $000d, $0570, $0578, $00bd, $0584, $0000, $0000
    dw $058c, $0000, $0598, $05a0, $05a8, $05b2, $05ba, $05c6
    dw $05d0, $05dc, $05e1, $02c8

; $7ae2: For each animation index, there is a number of sprites that needs to be drawn for the object.
; This array holds 2-tuples with 4 bit for each element: (number of sprites in X direction, number of sprites in Y direction).
; Usually this array is accessed by an object's ID and some offset.
NumObjectSprites::
    db $11                                    ; ???
    db $42, $42, $42, $42                     ; ID_BOAR
    db $42, $33, $43, $42, $33, $43           ; ID_WALKING_MONKEY
    db $42, $42, $43, $52,                    ; ID_COBRA
    db $53, $53, $52, $52, $52, $52, $52, $52 ; ID_EAGLE
    db $31                                    ; ID_ELEPHANT
    db $42, $23                               ; ID_KING_LOUIE_SLEEP
    db $42, $42, $52, $42, $42, $42           ; ID_STANDING_MONKEY
    db $41, $41, $41, $41                     ; ID_CRAWLING_SNAKE
    db $21, $21, $21, $21                     ; ID_MOSQUITO
    db $41, $42, $42                          ; ID_CROCODILE
    db $52                                    ; ID_KAA
    db $12, $12, $12, $12, $11, $21, $32, $42 ; ID_BOSS
    db $41, $41, $52, $62, $11, $22, $33, $43 ; ID_BOSS
    db $21, $42, $42, $43, $53, $52, $52, $52 ; ID_BOSS
    db $42, $42, $42                          ; ID_BOSS
    db $42, $42, $41, $41, $41, $41, $41, $42 ; ID_FLYING_BIRD
    db $42, $32, $32, $42, $42                ; ID_FLYING_BIRD_TURN
    db $32, $32, $32, $32, $32                ; ID_FISH
    db $41, $41, $42                          ; ID_HIPPO
    db $32, $31, $31, $32, $31, $31, $31, $31 ; ID_BAT
    db $11, $11, $11                          ; TODO: Wtf? Uses the lizzard's sprites.
    db $42, $42, $42, $42, $42, $31           ; ID_SCORPION
    db $31, $31, $31, $21                     ; ID_FROG
    db $41, $41, $41, $41                     ; ID_ARMADILLO_WALKING
    db $21, $21, $21, $21                     ; ID_ARMADILLO_ROLLING
    db $42, $42, $42, $42                     ; ID_PORCUPINE_WALKING
    db $21, $21, $21, $21                     ; ID_PORCUPINE_ROLLING
    db $28, $21, $21                          ; ID_LIGHTNING
    db $41                                    ; ID_FALLING_PLATFORM
    db $41, $41, $41, $41                     ; ID_LIZZARD
    db $21, $11, $11                          ; ID_DIAMONG
    db $21                                    ; ID_100LABEL
    db $21                                    ; ID_500LABEL
    db $21                                    ; ID_1000LABEL
    db $21                                    ; ID_5000LABEL
    db $21, $21                               ; ID_1UPLABEL
    db $11                                    ; ID_MONKEY_COCONUT
    db $11                                    ; ID_KING_LOUIE_COCONUT
    db $11                                    ; ID_PROJECTILE_STONES
    db $11                                    ; ID_PROJECTILE_BANANA
    db $11                                    ; ID_CHAR_S
    db $11                                    ; ID_PINEAPPLE
    db $21, $21                               ; ID_CHECKPOINT
    db $21                                    ; ID_GRAPES
    db $21                                    ; ID_EXTRA_LIFE
    db $21                                    ; ID_MASK_OR_LEAF
    db $21                                    ; ID_EXTRA_TIME
    db $21                                    ; ID_SHOVEL
    db $21                                    ; ID_DOUBLE_BANANA and ID_STONES
    db $11                                    ; ID_BOOMERANG
    db $11                                    ; ID_SNAKE_PROJECTILE
    db $42, $43                               ; ID_HANGING_MONKEY
    db $31, $32, $43, $44, $43                ; ID_HANGING_MONKEY2
    db $32, $42, $33                          ; ID_SITTING_MONKEY
    db $31, $11                               ; ID_TURTLE
    db $21, $32, $42, $42, $42, $43, $42, $33, $42 ; ID_CATAPULT and ID_SINKING_STONE
    db $43, $42, $43, $42, $53, $43, $62, $42, $52
    db $42, $52, $42, $42, $42, $42, $42, $32, $32, $42, $42, $32, $32, $42, $42, $32
    db $32, $32, $32, $42, $42, $42, $42, $42, $42, $42, $42, $42, $11, $11, $11, $11
    db $11, $21, $23, $23, $42, $21, $52, $41, $72, $41, $34, $23, $43, $33, $72, $51
    db $42, $51, $42, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11, $11
    db $11, $52, $32, $43, $32, $43, $43, $31, $42, $42, $31, $42, $41, $52, $32, $61
    db $42, $31, $42, $34, $41, $42, $11, $11, $43, $11, $42, $42, $52, $42, $43, $52
    db $43, $51, $42, $11

; $7c06 ; Offsets for sprites in pixels: (x offset, y offset)
ObjSpritePixelOffsets::
    db   0,   0,   0,   1,   0,   3,   0,   1,   0,   0,   0,  -3,  -4, -16,   1, -18
    db   0,  -3,  -4, -16,   1, -18,  -3,   2,  -3,   2,   5, -14,   9,   2,   0,  -8
    db   0,  -8,   0,   6,   0,   5,   0,   4,   0,   5,   0,   7,   0,   8,  -5,  16
    db  -1,  -1,  -9,  -8,   0,   6,   1,   3,   3,   2,   0,   3,   0,   5,   0,   8
    db   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,   0,   0,   0,   0,   2,   0,   0,   0,   0,  -1,   0,  -1,   0
    db -12,   1,  -8,   1,  -4,   1,   0,   1,   8,  25,   8,  17,   4,   9,   0,   1
    db -12,   1,  -8, -15,  -4, -15,  -4, -15,   4,  16,   4,   8,   4,   0,   4,  -8
    db   0, -15,  -1,   4,  -1,   4,  -1,   4,   0,   4,   0,   4,   0,   4,   0,   0
    db   0,  -2,   0,  12,   0,  13,   0,  14,   0,  16,   0,  16,   0,   1,   0,   0
    db   5,   0,   5,   0,   5,   1,   1,   0,   0,   0,   0,   8,   0,  13,   0,  10
    db   0,   8,   0,  16,   0,  16,   0,   0,   0,   0,   0,  14,   0,  13,   0,  13
    db   0,  14,   0,  15,   0,  16,   0,  13,   0,  11,   0,   3,   0,   3,   0,  0
    db   0,   0,   0,   0,   0,   0,   0,   0,   0,  16,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,   0,   0,   1,   0,   0,   0,   1,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,   0,   0,  16,   0,  16,   0,  17,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16,   0,  16
    db   0,  16,   0,  16,   3,  16,   3,  17,  -2, -12,  -2, -12,   2, -12,   2, -22
    db   2, -22,   0,   0,  12,  13,   9,   0,   0,  16,   0,  16,   0,  16,   0,   7
    db  -4,   0,  -4,   0,  -4,   0,  12,   0,   4,  48,   4,   0,   0,  48,   0,   0
    db   0,  48,   0,   0,   0,  48,  -7,   0,  -3,  32, -12,  23,  -4,  55, -12,  16
    db  -8,  48, -12,  16,  -8,  48,   0,   0,   0,   6,   0,   0,   4,   0,   0,   0
    db   0,   0,   0,   0,  -2,   0,   0,   0,   0,   0,   0,   6,  -2,   6,   0,   6
    db   0,   0,   0,   6,   0,   6,  -4,   6,  -4,   6,  -4,   6,   0,   6,   0,   6
    db   0,   6,   0,   6,   0,   6,   0,   6,   0,   6,   0,   3,   0,   2,   0,   3
    db  -4,   5,   0,  16,   0, -16,   0, -16,   0,  -7, -16,  25,  -4, -17, -16,  15
    db -12, -25,   0,   7, -11, -44,   9, -28, -24, -25,   4, -25, -12, -17, -20,  15
    db   0,  -7, -12,  25,   0,   1,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    db   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0,   0
    db   0,  16,  12,  16,   4,  48,   0,  -8,   4,  40,  -4,  30,  -1,  25,   2,  25
    db  -2,  41,   5,  31,   9,  63,  10,  26,  10,  58,   2,  10,   2,  42,   6,  26
    db   6,  42,  -4,  24,   8,  40,   4,   8,   2,  24,  -6,  40,   0,  27,   0,  27
    db   0,  27,   0,  27,  -2,   8,   6,  40,   0,   0,  -4,  32,  -4, -3, -  8,  45
    db  -4,  20,  -8,  68,  -4,  40, -24,  56

; $7e4e: (element - 7) * 2 results in an index for ObjectSpritePointers.
; I have no clue, why 7 is subtracted.
; Similar to NumObjectSprites, elements are accesed by using an object's ID and an offset.
ObjectSpritePtrIndices::
    db $07
    db $09, $09, $09, $09                           ; ID_BOAR
    db $0a, $0a, $0a, $0a, $0a, $0a                 ; ID_WALKING_MONKEY
    db $0b, $0b, $0b, $0b                           ; ID_COBRA
    db $0c, $0c, $0c, $0d, $0d, $0d, $0d, $0c       ; ID_EAGLE
    db $0e, $0e, $0e                                ; ID_ELEPHANT
    db $17, $17, $17, $17, $18, $18                 ; ID_STANDING_MONKEY
    db $10, $10, $10, $10                           ; ID_CRAWLING_SNAKE
    db $10, $10, $10, $10                           ; ID_MOSQUITO
    db $11, $11, $11                                ; ID_CROCODILE
    db $13, $13, $13, $13, $13                      ; ID_KAA, ID_BOSS
    db $12, $12, $12, $12, $12, $12, $12, $12, $12
    db $12, $12, $12, $12, $12, $12, $12, $12, $13
    db $13, $13, $13, $13, $13
    db $15, $15, $15, $15, $15, $15, $15, $15       ; ID_FLYING_BIRD
    db $16, $16, $16, $16, $16                      ; ID_FLYING_BIRD_TURN
    db $19, $19, $19, $19, $19                      ; ID_FISH
    db $1a, $1a, $1a                                ; ID_HIPPO
    db $1b, $1b, $1b, $1b, $1b, $1b,                ; ID_BAT
    db $1b, $1b, $1c, $1c, $1c                      ; Another lizzard?!
    db $1d, $1d, $1d, $1d, $1d, $11                 ; ID_SCORPION
    db $1e, $1e, $1e, $1e                           ; ID_FROG
    db $1f, $1f, $1f, $1f                           ; ID_ARMADILLO_WALKING
    db $1f, $1f, $1f, $1f                           ; ID_ARMADILLO_ROLLING
    db $20, $20, $20, $20                           ; ID_PORCUPINE_WALKING
    db $20, $20, $20, $20                           ; ID_PORCUPINE_ROLLING
    db $0f, $14, $14                                ; ID_LIGHTNING
    db $07                                          ; ID_FALLING_PLATFORM
    db $1c, $1c, $1c, $1c                           ; ID_LIZZARD
    db $07, $07, $07                                ; ID_DIAMOND
    db $07                                          ; ID_100LABEL
    db $07                                          ; ID_500LABEL
    db $07                                          ; ID_1000LABEL
    db $07                                          ; ID_5000LABEL
    db $07, $07                                     ; ID_1UPLABEL
    db $07                                          ; ID_MONKEY_COCONUT
    db $07                                          ; ID_KING_LOUIE_COCONUT
    db $07                                          ; ID_PROJECTILE_STONES
    db $07                                          ; ID_PROJECTILE_BANANA
    db $07                                          ; ID_CHAR_S
    db $07                                          ; ID_PINEAPPLE
    db $07, $07                                     ; ID_CHECKPOINT
    db $07                                          ; ID_GRAPES
    db $07                                          ; ID_EXTRA_LIFE
    db $07                                          ; ID_MASK_OR_LEAF
    db $07                                          ; ID_EXTRA_TIME
    db $07                                          ; ID_SHOVEL
    db $07                                          ; ID_DOUBLE_BANANA
    db $07                                          ; ID_BOOMERANG
    db $07                                          ; ID_SNAKE_PROJECTILE
    db $08, $08                                     ; ID_HANGING_MONKEY
    db $08, $08, $08, $08, $08                      ; ID_HANGING_MONKEY2
    db $08, $08, $08                                ; ID_SITTING_MONKEY
    db $07, $07                                     ; ID_TURTLE
    db $07, $1e, $1e, $1e, $1e                      ; ID_CATAPULT / ID_SINKING_STONE
    db $21, $21, $21, $21, $21, $21, $21, $21       ; ID_BALOO
    db $22, $22, $22, $22, $22, $22, $22, $22
    db $23, $23, $23, $23, $23, $23, $23, $23       ; ID_MONKEY_BOSS
    db $23, $23, $23, $23, $23, $23, $24, $24
    db $24, $24, $24, $23, $23, $23, $23, $23
    db $23, $24, $24, $24, $24, $24
    db $2b, $2b, $2b                                ; ID_VILLAGE_GIRL
    db $28, $28, $29, $29, $2a, $2a, $2a, $2a, $2a  ; ID_SHERE_KHAN
    db $2a, $29, $29, $28, $28, $28
    db $26, $26, $26, $26, $27, $27, $27, $27, $27
    db $27, $27, $27, $27, $07, $25, $25, $25, $25
    db $25, $25, $25, $25, $25, $25, $25, $25, $26
    db $26, $26, $26, $26, $26, $26, $26, $26, $26
    db $26, $26, $26, $27, $27, $27, $27, $27, $27
    db $27, $27, $27, $27

; Macro used to create addresses for ObjectSpritePointers. Encapsulates 2-bit ROM bank, and 14-bit pointer.
; Input: ROM bank (>4), address
MACRO MakeObjSpritePtr
    dw ((\1 - 5) << 14) | (\2 & $3fff),
ENDM

; $7f72: Upper two bits of each pointer + 5 determines ROM bank.
ObjectSpritePointers::
    ; ROM bank 5
    MakeObjSpritePtr 5, AssetSprites                    ; $07
    MakeObjSpritePtr 5, SittingMonkeySprites            ; $08
    MakeObjSpritePtr 5, BoarSprites                     ; $09
    MakeObjSpritePtr 5, WalkingMonkeySprites3           ; $0a
    MakeObjSpritePtr 5, CobraSprites                    ; $0b
    MakeObjSpritePtr 5, EagleSprites                    ; $0c
    MakeObjSpritePtr 5, EagleSprites2                   ; $0d
    MakeObjSpritePtr 5, ElephantTrunkSprites            ; $0e
    MakeObjSpritePtr 5, StoneSprites                    ; $0f
    MakeObjSpritePtr 5, CrawlingSnakeSprites            ; $10
    MakeObjSpritePtr 5, CrocodileSprites                ; $11
    MakeObjSpritePtr 5, KaaSprites2                     ; $12
    MakeObjSpritePtr 5, KaaSprites                      ; $13
    MakeObjSpritePtr 5, BonusSprites                    ; $14
    MakeObjSpritePtr 5, FlyingBirdSprites               ; $15
    MakeObjSpritePtr 5, FlyingBirdTurnSprites           ; $16
    MakeObjSpritePtr 5, WalkingMonkeySprites            ; $17
    MakeObjSpritePtr 5, WalkingMonkeySprites2           ; $18
    MakeObjSpritePtr 5, FishSprites                     ; $19
    MakeObjSpritePtr 5, HippoSprites                    ; $1a
    MakeObjSpritePtr 5, BatSprites                      ; $1b
    ; ROM Bank 6
    MakeObjSpritePtr 6, LizzardSprites                  ; $1c
    MakeObjSpritePtr 6, ScorpionSprites                 ; $1d
    MakeObjSpritePtr 6, FrogSprites                     ; $1e
    MakeObjSpritePtr 6, ArmdadilloSprites               ; $1f
    MakeObjSpritePtr 6, PorcupineSprites                ; $20
    MakeObjSpritePtr 6, BalooBossDanceSprites           ; $21
    MakeObjSpritePtr 6, BalooBossJumpSprites            ; $22
    MakeObjSpritePtr 6, MonkeyBossSprites               ; $23
    MakeObjSpritePtr 6, HangingMonkeySprites            ; $24
    MakeObjSpritePtr 6, KingLouieHandSprites            ; $25
    ; ROM Bank 7
    MakeObjSpritePtr 7, KingLouieSprites                ; $26
    MakeObjSpritePtr 7, KingLouieActionSprites          ; $27
    MakeObjSpritePtr 7, ShereKhanSprites                ; $28
    MakeObjSpritePtr 7, ShereKhanActionSprites          ; $29

    MakeObjSpritePtr 6, ShereKhanHandSprites            ; $2a
    MakeObjSpritePtr 7, VillageGirlSprites              ; $2b

    ; Are these pointers accessible? They are also a copy of the previous elements.
    MakeObjSpritePtr 5, EagleSprites
    MakeObjSpritePtr 5, EagleSprites2
    MakeObjSpritePtr 5, ElephantTrunkSprites
    MakeObjSpritePtr 5, StoneSprites
    MakeObjSpritePtr 5, CrawlingSnakeSprites
    MakeObjSpritePtr 5, CrocodileSprites
    MakeObjSpritePtr 5, KaaSprites2
    MakeObjSpritePtr 5, KaaSprites
    MakeObjSpritePtr 5, BonusSprites
    MakeObjSpritePtr 5, FlyingBirdSprites
    MakeObjSpritePtr 5, FlyingBirdTurnSprites
    MakeObjSpritePtr 5, WalkingMonkeySprites
    MakeObjSpritePtr 5, WalkingMonkeySprites2
    MakeObjSpritePtr 5, FishSprites
    MakeObjSpritePtr 5, HippoSprites
    MakeObjSpritePtr 5, BatSprites
    ; ROM bank 6
    MakeObjSpritePtr 6, LizzardSprites
    MakeObjSpritePtr 6, ScorpionSprites
    MakeObjSpritePtr 6, FrogSprites
    MakeObjSpritePtr 6, ArmdadilloSprites
    MakeObjSpritePtr 6, PorcupineSprites
    MakeObjSpritePtr 6, BalooBossDanceSprites
    MakeObjSpritePtr 6, BalooBossJumpSprites
    MakeObjSpritePtr 6, MonkeyBossSprites
    MakeObjSpritePtr 6, HangingMonkeySprites
    MakeObjSpritePtr 6, KingLouieHandSprites
    ; ROM bank 7
    MakeObjSpritePtr 7, KingLouieSprites
    MakeObjSpritePtr 7, KingLouieActionSprites
    MakeObjSpritePtr 7, ShereKhanSprites
    MakeObjSpritePtr 7, ShereKhanActionSprites

    MakeObjSpritePtr 6, ShereKhanHandSprites
    MakeObjSpritePtr 7, VillageGirlSprites

    ; Probably tail data.
    dw $ffff, $04ff
