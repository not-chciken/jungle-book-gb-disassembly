SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

; $4000: Initializes the background when the level is started.
; lvl * 2 needs to be in "bc".
InitBackgroundTileData::
    push bc
    ld hl, PtrBaseCompressed2x2BgTiles
    add hl, bc
    push bc
    push hl
    ld hl, Compressed2x2BgTiles1
    ld a, c
    cp PTR_SIZE * 10
    jr nz, :+                       ; Continue if Level 10.
    ld hl, Compressed2x2BgTiles6
 :  ld de, Ptr2x2BgTiles1            ; This goes into $c700.
    call DecompressData             ; Either decompresses Compressed2x2BgTiles1 or Compressed2x2BgTiles6.
    pop hl                          ; hl = PtrBaseCompressed2x2BgTiles + lvl * 2
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; Pointer to level-specific data in "hl".
    ld de, Ptr2x2BgTiles2            ; This goes into $c900.
    call DecompressData
    pop bc
    ld hl, PtrBaseCompressed4x4BgTiles
    add hl, bc
    push hl
    ld hl, Compressed4x4BgTiles1
    ld a, c
    cp PTR_SIZE * 10                ; Level 10?
    jr nz, :+
    ld hl, Compressed4x4BgTiles6
 :  ld de, Ptr4x4BgTiles1
    call DecompressData
    pop hl
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, Ptr4x4BgTiles2
    call DecompressData
    pop bc
    sla c
    sla c
    ld hl, CompressedMapBgTilesBasePtr
    add hl, bc                             ; Add level offset-
    ld e, [hl]
    inc hl
    ld d, [hl]                             ; de = VRAM pointer basic data
    inc hl
    ld a, [hl+]
    push hl
    ld h, [hl]
    ld l, a                                ; hl = compressed data pointer
    ld a, [NextLevel]
    cp 9
    jr z, :+                               ; Jump if next level is 9.
    ld a, d
    cp $90
    jr z, :++
 :  push hl
    push de
    ld hl, CompressedMapBgTiles1          ;  For levels "ANCIENT RUINS", "FALLING RUINS", and "JUNGLE BY NIGHT"" the plain jungle setting is loaded as well.
    call DecompressInto9000
    pop de
    pop hl
 :  call DecompressData
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
    jp DecompressData

; $407c
LoadVirginLogoData::
    ld hl, CompressedVirginLogoData
    call DecompressInto9000
    ld hl, _SCRN0
    ld de, $8800
    ld bc, $0200
    rst RST_38
    ld hl, CompressedVirginLogoTileMap

; $408f
DecompressInto9800::
    ld de, _SCRN0
    jr JumpToDecompress

; $4094: Decompresses data into tile map.
DecompressInto9000::
    ld de, $9000

; $4097 Simply jumps to DecompressData
JumpToDecompress::
    jp DecompressData

; $409a: A 4-tuple per level (vram pointer0, pointer to compressed data0, vram pointer1, pointer to compressed data1)
; The first pointer points to data for the general level setting (jungle, tree, ruins, etc.).
; The second pointer points to data for level specific stuff (catapult, elephants, etc.).
CompressedMapBgTilesBasePtr::
    dw $9000, CompressedMapBgTiles1, $96c0, CompressedMapBgTiles10 ; Level 1: JUNGLE BY DAY
    dw $9000, CompressedMapBgTiles2, $96d0, CompressedMapBgTiles20 ; Level 2: THE GREAT TREE
    dw $9000, CompressedMapBgTiles1, $96c0, CompressedMapBgTiles30 ; Level 3: DAWN PATROL
    dw $9000, CompressedMapBgTiles1, $96c0, CompressedMapBgTiles40 ; Level 4: BY THE RIVER
    dw $9000, CompressedMapBgTiles1, $96c0, CompressedMapBgTiles40 ; Level 5: IN THE RIVER
    dw $9000, CompressedMapBgTiles2, $96d0, CompressedMapBgTiles50 ; Level 6: TREE VILLAGE
    dw $92d0, CompressedMapBgTiles3, $9560, CompressedMapBgTiles60 ; Level 7: ANCIENT RUINS
    dw $92d0, CompressedMapBgTiles3, $9560, CompressedMapBgTiles60 ; Level 8: FALLING RUINS
    dw $9000, CompressedMapBgTiles4, $96c0, CompressedMapBgTiles70 ; Level 9: JUNGLE BY NIGHT
    dw $9000, CompressedMapBgTiles5, $0000, $0000                  ; Level 10: THE WASTELANDS
    dw $9000, CompressedMapBgTiles6, $0000, $0000                  ; Level 11: Bonus
    dw $9000, CompressedMapBgTiles1, $96c0, CompressedMapBgTiles10 ; Level 12: Transition and credit screen

; $40fa: Tile data for map background. Reused across levels. This contains tiles for a plain jungle setting.
; Compressed $4df; Decompressed: $6c0
CompressedMapBgTiles1::
    INCBIN "bin/CompressedMapBgTiles1.bin"

; $45d9: Tile data for map background. Reused across levels. This contains a tree setting.
CompressedMapBgTiles2::
    INCBIN "bin/CompressedMapBgTiles2.bin"

; $49da: Contains special background data (a catapult) for Level 1 "JUNGLE BY DAY".
; Unpacked into $9700. Compressed $140, Uncompressed $d5.
CompressedMapBgTiles10::
    INCBIN "bin/CompressedMapBgTiles10.bin"

; $4aaf: Contains special background data (Kaa the snake) for Level 2 "THE GREAT TREE".
CompressedMapBgTiles20::
    INCBIN "bin/CompressedMapBgTiles20.bin"

; $4b86: Contains special background data (an elephant herd) for Level 3 "DAWN PATROL"
CompressedMapBgTiles30::
    INCBIN "bin/CompressedMapBgTiles30.bin"

; $4b86: Contains special background data (water and Baloo) for Level 4 "BY THE RIVER"
CompressedMapBgTiles40::
    INCBIN "bin/CompressedMapBgTiles40.bin"

; $4d79: Contains special background data (water and Baloo floating in the water) for Level 5 "IN THE RIVER"
CompressedMapBgTiles50::
    INCBIN "bin/CompressedMapBgTiles50.bin"

; $4e8e: Tile data for map background. Reused across levels. This contains a ruins setting.
CompressedMapBgTiles3::
    INCBIN "bin/CompressedMapBgTiles3.bin"

; $4f3b: Contains special background data (hut) for Level 6 "TREE VILLAGE".
CompressedMapBgTiles60::
    INCBIN "bin/CompressedMapBgTiles60.bin"

; $516e: Tile data for map background. Only used in Level 9 "JUNGLE BY NIGHT". Thus, contains a jungle by night setting.
CompressedMapBgTiles4::
    INCBIN "bin/CompressedMapBgTiles4.bin"

; $5412: Contains special background data (doors and slopes) for Level 7 "ANCIENT RUINS".
CompressedMapBgTiles70::
    INCBIN "bin/CompressedMapBgTiles70.bin"

; $550c: Tile data for map background. Only used in Level 10 "THE WASTELANDS". Thus, contains a wasteland setting.
CompressedMapBgTiles5::
    INCBIN "bin/CompressedMapBgTiles5.bin"

; $5a51: Tile data for map background. Only used in the bonus level. Thus, contains a cave setting.
; Compressed $688. Decompressed $800.
CompressedMapBgTiles6::
    INCBIN "bin/CompressedMapBgTiles6.bin"

; $60d9: 80 bytes of data.
WaterData::
    INCBIN "bin/WaterData.bin"

; $6129: Compressed $185. Decompressed $200.
; This is loaded into $9e00 (upper tile map) for the THE WASTELANDS.
CompressedFireData::
    INCBIN "bin/CompressedFireData.bin"

; $62ae: Pointers to the layer3 background data. Note that some levels share the same data.
; The indices are used to construct 2x2 tile tiles.
PtrBaseCompressed2x2BgTiles::
    dw Compressed2x2BgTiles2 ; Level 1: JUNGLE BY DAY
    dw Compressed2x2BgTiles3 ; Level 2: THE GREAT TREE
    dw Compressed2x2BgTiles2 ; Level 3: DAWN PATROL
    dw Compressed2x2BgTiles2 ; Level 4: BY THE RIVER
    dw Compressed2x2BgTiles2 ; Level 5: IN THE RIVER
    dw Compressed2x2BgTiles3 ; Level 6: TREE VILLAGE
    dw Compressed2x2BgTiles4 ; Level 7: ANCIENT RUINS
    dw Compressed2x2BgTiles4 ; Level 8: FALLING RUINS
    dw Compressed2x2BgTiles2 ; Level 9: JUNGLE BY NIGHT
    dw Compressed2x2BgTiles5 ; Level 10: THE WASTELANDS
    dw Compressed2x2BgTiles2 ; Level 11: Bonus
    dw Compressed2x2BgTiles2 ; Level 12: Transition and credit screen

; $362c6 First Layer 3 pointers for the background. This is loaded into $c700. 512 Bytes decompressed. $126 compressed.
Compressed2x2BgTiles1::
    INCBIN "bin/Compressed2x2BgTiles1.bin"

; $63ec Second Layer 3 pointers for the background. This is loaded into $c900. $1f0 decompressed. $1c7 compressed.
Compressed2x2BgTiles2::
    INCBIN "bin/Compressed2x2BgTiles2.bin"

; $65b3: Compressed $1ec. Decompressed $200.
Compressed2x2BgTiles3::
    INCBIN "bin/Compressed2x2BgTiles3.bin"

; $679f: Compressed $146. Decompressed $180.
Compressed2x2BgTiles4::
    INCBIN "bin/Compressed2x2BgTiles4.bin"

; $68e5: Compressed $122. Decompressed $12c.
Compressed2x2BgTiles5::
    INCBIN "bin/Compressed2x2BgTiles5.bin"

; $6a07: Compressed $139. Decompressed $200.
Compressed2x2BgTiles6::
    INCBIN "bin/Compressed2x2BgTiles6.bin"

; $6b40: Pointers to the Layer 2 background data for individual levels.
; The indices are used to construct 4x4 tile tiles.
PtrBaseCompressed4x4BgTiles::
    dw Compressed4x4BgTiles2  ; Level 1: JUNGLE BY DAY
    dw Compressed4x4BgTiles3, ; Level 2: THE GREAT TREE
    dw Compressed4x4BgTiles2, ; Level 3: DAWN PATROL
    dw Compressed4x4BgTiles2, ; Level 4: BY THE RIVER
    dw Compressed4x4BgTiles2, ; Level 5: IN THE RIVER
    dw Compressed4x4BgTiles3, ; Level 6: TREE VILLAGE
    dw Compressed4x4BgTiles4, ; Level 7: ANCIENT RUINS
    dw Compressed4x4BgTiles4, ; Level 8: FALLING RUINS
    dw Compressed4x4BgTiles2, ; Level 9: JUNGLE BY NIGHT
    dw Compressed4x4BgTiles5, ; Level 10: THE WASTELANDS
    dw Compressed4x4BgTiles2, ; Level 11: Bonus
    dw Compressed4x4BgTiles2  ; Level 12: Transition and credit screen

; $6b58: First Layer 2 pointers for background data. Decompressed to $cb00. Compressed $174. Decompressed $200.
Compressed4x4BgTiles1::
    INCBIN "bin/Compressed4x4BgTiles1.bin"

; $6ccc: Second Layer 2 pointers for background data. Decompressed to $cd00. Compressed $1b4. Decompressed $199.
Compressed4x4BgTiles2::
    INCBIN "bin/Compressed4x4BgTiles2.bin"

; $6e69: Compressed $19f. Decompressed $1c0.
Compressed4x4BgTiles3::
    INCBIN "bin/Compressed4x4BgTiles3.bin"

; $7008: Compressed $101. Decompressed $138.
Compressed4x4BgTiles4::
    INCBIN "bin/Compressed4x4BgTiles4.bin"

; $7109: Compressed $11d. Decompressed $138.
Compressed4x4BgTiles5::
    INCBIN "bin/Compressed4x4BgTiles5.bin"

; $7226: Compressed $111. Decompressed $144.
Compressed4x4BgTiles6::
    INCBIN "bin/Compressed4x4BgTiles6.bin"

; $7337: Tile map data of the virgin logo shown during startup. Compressed $d3, Decompressed $240.
CompressedVirginLogoTileMap::
    INCBIN "bin/CompressedVirginLogoTileMap.bin"

; $740a: Tile data of the virgin logo shown during startup. Compressed $4b7, Decompressed $7a0.
CompressedVirginLogoData::
    INCBIN "bin/CompressedVirginLogoData.bin"

; $78c1: Tile map data of the Jungle Book logo shown in the start menu. Compressed $8d, Decompressed $d0.
CompressedJungleBookLogoTileMap::
    INCBIN "bin/CompressedJungleBookLogoTileMap.bin"

; $794e: Tile data of the Jungle Book logo shown in the start menu. Compressed $527, Decompressed $680.
CompressedJungleBookLogoData::
    INCBIN "bin/CompressedJungleBookLogoData.bin"

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
