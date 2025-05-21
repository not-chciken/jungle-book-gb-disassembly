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
    jr nz, :+                       ; Continue if Level 10 (BONUS).
    ld hl, Compressed2x2BgTiles6
 :  ld de, Ptr2x2BgTiles1           ; This goes into $c700.
    call DecompressData             ; Either decompresses Compressed2x2BgTiles1 or Compressed2x2BgTiles6.
    pop hl                          ; hl = PtrBaseCompressed2x2BgTiles + lvl * 2
    ld a, [hl+]
    ld h, [hl]
    ld l, a                         ; Pointer to level-specific data in "hl".
    ld de, Ptr2x2BgTiles2           ; This goes into $c900.
    call DecompressData
    pop bc
    ld hl, PtrBaseCompressed4x4BgTiles
    add hl, bc
    push hl
    ld hl, Compressed4x4BgTiles1
    ld a, c
    cp PTR_SIZE * 10                ; Continue if Level 10 (BONUS).
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
    rst CopyData
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

; $7e75: TODO: Find out what this is.
TODOData7e75::
    INCBIN "bin/TODOData7e75.bin"
