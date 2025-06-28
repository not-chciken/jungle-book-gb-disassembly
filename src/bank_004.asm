SECTION "ROM Bank $004", ROMX[$4000], BANK[$4]

; $4000: Loads the index data for staff residing in the background, such as plants, bottom ground and stones.
; The data is stored in an array starting at $cefe.
InitBgDataIndices::
    push bc
    ld hl, CompressedDataLeveBgBasePtr
    add hl, bc                  ; Data at $4401a + offset
    ld a, [hl+]
    ld h, [hl]                  ; Loading some pointer
    ld l, a
    ld de, $cefe                ; Put data into $cefe (WRAM)
    push de
    call DecompressData
    pop hl
    pop bc
    ld a, [hl+]
    ld [LevelWidthDiv32], a     ; Set level width in pixels divided by 32 (so 4 tiles).
    ld a, [hl]
    ld [LevelHeightDiv32], a    ; Set level height in pixels divided by 32 (so 4 tiles).
    ret

; $401a: Here reside the pointers to each level's back ground index array.
; The array is 2D with the first two bytes indicating width and length.
; Each element in the array is an index for a 4x4 supertile.
CompressedDataLeveBgBasePtr:
    dw CompressedDataLevel1Bg ; Pointer level 1: JUNGLE BY DAY ($4032)
    dw CompressedDataLevel2Bg ; Pointer level 2: THE GREAT TREE ($44d2)
    dw CompressedDataLevel3Bg ; Pointer level 3: DAWN PATROL ($491e)
    dw CompressedDataLevel4Bg ; Pointer level 4: BY THE RIVER ($4d0d)
    dw CompressedDataLevel5Bg ; Pointer level 5: IN THE RIVER ($51d8)
    dw CompressedDataLevel6Bg ; Pointer level 6: TREE VILLAGE ($5653)
    dw CompressedDataLevel7Bg ; Pointer level 7: ANCIENT RUINS ($5c10)
    dw CompressedDataLevel8Bg ; Pointer level 8: FALLING RUINS ($6291)
    dw CompressedDataLevel9Bg ; Pointer level 9: JUNGLE BY NIGHT ($66cb)
    dw CompressedDataLevel10Bg ; Pointer level 10: THE WASTELANDS ($6c3e)
    dw CompressedDataLevel11Bg ; Pointer level 11: Bonus ($7106)
    dw CompressedDataLevel12Bg ; Pointer level 12: Transition and credit screen ($727f)

; Level 1 "JUNGLE BY DAY" background indices. Map size in pixels: 3072 x 512.. Decompressed: 1538 Bytes; Compressed: 1184 Bytes
CompressedDataLevel1Bg::
    INCBIN "bin/CompressedDataLevel1Bg.bin"

; $44d2. Dempressed $602, Compressed $44c.
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

; $727f: Compressed $30. Decompressed $34.
CompressedDataLevel12Bg::
  INCBIN "bin/CompressedDataLevel12Bg.bin"

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

    jp nz, $706e

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
    rst IncrAttr
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
    call c, $3c00
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
    call c, $5c26
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
    call c, $5c26
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
