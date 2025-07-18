SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

; $4000: Initializes the data in c400 by copying the level's GroundData.
; Data is copied if Bit 7 is zero. If Bit 7 is non-zero, the datum is interpreted as N bytes of zero.
InitGroundData::
    ld de, GroundDataRam
CopyLoop:
    ld a, [hl+]                     ; Points to GroundDataPtrBase.
    bit 7, a
    jr nz, .ZeroFill                ; Jump out of loop if Bit 7 in GroundData is non-zero.
    ld [de], a                      ; Copy data to [$c400+e]
    inc e
    jr nz, CopyLoop                 ; Loops up to 256 times.
    ret
.ZeroFill:
    and %01111111                   ; The lower 7 bits give the number of zeroes.
    jr nz, :+
    or $80
 :  ld b, a                         ; b = number of zeroes
    xor a                           ; a = 0
.ZeroLoop:
    ld [de], a                      ; [de] = 0
    inc e
    ret z                           ; Return if $c500 is reached.
    dec b
    jr nz, .ZeroLoop
    jr CopyLoop

; $401d: This should be pointer data. The referred data is related to the ground's hitbox, which is stored in MetaTileGroundData.
; Each datum corresponds to the ground data of a 2x2 meta tile.
; No ground: $00;
; Earth-based ground: $01 = -- (straight ground, including straight branch), $02 = / (positive slope), ...;
; Branch-based groud: $25 = -o $26 = /-, $27 = -\, $28 = o-;
; For more examples see MetaTileGroundData.
GroundDataPtrBase::
    dw GroundData1                  ; Level 1: JUNGLE BY DAY
    dw GroundData2                  ; Level 2: THE GREAT TREE
    dw GroundData3                  ; Level 3: DAWN PATROL
    dw GroundData1                  ; Level 4: BY THE RIVER
    dw GroundData4                  ; Level 5: IN THE RIVER
    dw GroundData5                  ; Level 6: TREE VILLAGE
    dw GroundData6                  ; Level 7: ANCIENT RUINS
    dw GroundData6                  ; Level 8: FALLING RUINS
    dw GroundData1                  ; Level 9: JUNGLE BY NIGHT
    dw GroundData7                  ; Level 10: THE WASTELANDS
    dw GroundData8                  ; Level 11: Bonus
    dw GroundData1                  ; Level 12: Transition and credit screen

; $4035
GroundData1::
    db $93, $25, $26, $27, $28, $01, $9f, $01, $cc, $02, $03, $01, $04, $06, $05, $07
    db $08, $00, $09, $0a, $0b, $87, $01, $01, $85, $04, $00, $09, $0b, $0b, $05, $04
    db $0c, $0d, $0e, $0f, $89, $02, $82, $0a, $a2, $06, $00, $09, $0b, $82, $0b, $09
    db $06, $03, $99, $03, $84

; $406a: Important: $40, $41, and $42 are special values for portals.
GroundData2::
    db $40, $80, $a7, $06, $82, $01, $01, $11, $01, $12, $13, $00, $00, $14, $15, $10
    db $10, $07, $10, $08, $10, $16, $17, $10, $10, $18, $19, $00, $00, $05, $10, $04
    db $00, $87, $41, $85, $42, $82, $01, $01, $1a, $00, $01, $91, $10, $00, $00, $00
    db $08, $8e

; $409c
GroundData3::
    db $93, $25, $26, $27, $28, $01, $9f, $01, $cc, $02, $03, $01, $04, $06, $05, $07
    db $08, $00, $09, $0a, $0b, $87, $01, $01, $85, $04, $00, $09, $0b, $0b, $05, $04
    db $0c, $0d, $0e, $0f, $89, $02, $82, $0a, $86, $1b, $1c, $14, $1d, $1e, $1f, $20
    db $10, $10, $11, $ba, $93, $25, $26, $27, $28, $01, $9f, $01, $cc, $02, $03, $01
    db $04, $06, $05, $07, $08, $00, $09, $0a, $0b, $87, $01, $01, $85, $04, $00, $09
    db $0b, $0b, $05, $04, $0c, $0d, $0e, $0f, $89, $02, $82, $0a, $ca

; $40f9
GroundData4::
    db $93, $25, $26, $27, $28, $01, $9f, $01, $cc, $02, $03, $01, $04, $06, $05, $07
    db $08, $00, $09, $0a, $0b, $87, $01, $01, $85, $04, $00, $09, $0b, $0b, $05, $04
    db $0c, $0d, $0e, $0f, $89, $02, $82, $0a, $86, $1b, $1c, $14, $1d, $1e, $1f, $20
    db $10, $10, $11, $85, $22, $21, $23, $24, $b1

; $4132: Important: $40, $41, and $42 are special values for portals.
GroundData5::
    db $40, $ca, $41, $dc, $06, $82, $01, $01, $11, $01, $12, $13, $00, $00, $14, $15
    db $10, $10, $07, $10, $08, $10, $16, $17, $10, $10, $18, $19, $00, $00, $05, $10
    db $04, $00, $87, $41, $85, $42, $82, $01, $01, $1a, $00, $01, $91, $10, $00, $00
    db $00, $08, $8e

; $4165: Important: $40, $41, and $42 are special values for portals.
GroundData6::
    db $40, $80, $8a, $01, $01, $9d, $07, $08, $09, $10, $05, $04, $06, $0a, $0b, $02
    db $03, $cb

; $4177
GroundData7::
    db $80, $01, $00, $05, $04, $04, $01, $07, $08, $09, $01, $25, $26, $a1, $01, $00
    db $01, $00, $91, $05, $83, $08, $b9

; $418e
GroundData8::
    db $00, $01, $82, $0b, $07, $00, $08, $09, $00, $0a, $0b, $b6, $03, $83, $02, $03
    db $00, $05, $04, $06, $d9, $0c, $0d, $0e, $0f, $d7

; $41a8: Array of 16-byte array. Each 16-byte array comprises the ground data for a certain ground type.
; Each 2x2 meta tile on the map has a ground type.
; The array is accessed using ([CurrentGroundType] - 1) * 16.
; Each entry in a 16-byte array contains a Y-position for the ground and is accesed by the player's or object's X position.
; 0 is special and meangs no ground.
; Also dynamic ground (turtles, hippos, crocodiles, falling platforms, and sinking stones) makes use of this data.
MetaTileGroundData::
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10   ; $01: Flat ground
    db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10   ; $02: /-slope
    db $10, $10, $10, $10, $10, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00   ; $03: Left half ground
    db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $0d, $0d, $0e, $0e, $0f, $0f, $10, $10   ; $04: Not so steep /-slope
    db $01, $01, $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07, $07, $08, $08   ; $05: Not so steep /-slope
    db $10, $10, $10, $10, $10, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00   ; $06: Left half ground
    db $10, $10, $0f, $0f, $0e, $0e, $0d, $0d, $0c, $0c, $0b, $0b, $0a, $0a, $09, $09   ; $07: Not so steep \-slope
    db $08, $08, $07, $07, $06, $06, $05, $05, $04, $04, $03, $03, $02, $02, $01, $01   ; $08: Not so steep \-slope
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10   ; $09: Right half ground
    db $10, $0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02, $01   ; $0a: \-slope
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10   ; $0b: Right half ground
    db $00, $00, $00, $00, $00, $00, $08, $08, $07, $07, $06, $06, $05, $05, $04, $04   ; $0c: Right half \-slope
    db $03, $03, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00   ; $0d: Left half \-slope
    db $10, $10, $10, $10, $10, $10, $0f, $0f, $0e, $0e, $0d, $0d, $0c, $0c, $0b, $0b   ; $0e: ⎻\
    db $0a, $0a, $09, $09, $08, $08, $07, $07, $06, $06, $05, $05, $00, $00, $00, $00   ; $0f: Left half \-slope
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10   ; $10:
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $00, $00, $00, $00   ; $11: Elephant trunk tip
    db $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e, $0d, $0d, $0d, $0d   ; $12:
    db $0c, $0c, $0c, $0c, $0b, $0b, $0b, $0b, $0a, $0a, $0a, $0a, $09, $09, $09, $09   ; $13:
    db $08, $08, $08, $08, $07, $07, $07, $07, $06, $06, $06, $06, $05, $05, $05, $05   ; $14: Elephant middle back
    db $04, $04, $04, $04, $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01   ; $15:
    db $01, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $04, $04, $04, $04   ; $16:
    db $05, $05, $05, $05, $06, $06, $06, $06, $07, $07, $07, $07, $08, $08, $08, $08   ; $17:
    db $09, $09, $09, $09, $0a, $0a, $0a, $0a, $0b, $0b, $0b, $0b, $0c, $0c, $0c, $0c   ; $18:
    db $0d, $0d, $0d, $0d, $0e, $0e, $0e, $0e, $0f, $0f, $0f, $0f, $10, $10, $10, $10   ; $19:
    db $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10   ; $1a:
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04   ; $1b:
    db $04, $04, $05, $05, $06, $06, $06, $06, $07, $07, $07, $07, $08, $08, $08, $08   ; $1c: Elephant lower back
    db $04, $04, $04, $03, $02, $01, $03, $05, $07, $09, $0b, $0d, $0f, $10, $10, $10   ; $1d: Elephant neck
    db $10, $10, $10, $10, $0f, $0f, $0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06   ; $1e: Elephant head
    db $07, $06, $05, $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00   ; $1f: Elephant trunk
    db $00, $00, $00, $00, $00, $00, $0a, $0b, $0c, $0d, $0e, $0f, $10, $10, $10, $10   ; $20: Elephant ass
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c   ; $21: Floating Baloo belly
    db $02, $03, $03, $04, $05, $06, $07, $08, $09, $09, $0a, $0a, $0b, $0b, $0b, $0c   ; $22: Floating Baloo lower body
    db $0c, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a, $09, $09, $08, $08, $08, $07, $07   ; $23: Floating Baloo upper body
    db $06, $06, $06, $07, $07, $07, $08, $08, $09, $09, $09, $0a, $0a, $09, $06, $05   ; $24: Floating Baloo head
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $10, $10, $10, $10, $10, $10, $10, $10   ; $25: Used for tree branches.
    db $10, $10, $10, $10, $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f   ; $26:
    db $10, $10, $10, $10, $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f   ; $27: Used for tree branches.
    db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f   ; $28:
    db $09, $0a, $0b, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0b, $0a, $09   ; $29: Turtle
    db $03, $05, $08, $09, $09, $0a, $0b, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $0b   ; $2a: Crocodile
    db $08, $08, $08, $08, $08, $07, $07, $07, $07, $08, $09, $09, $08, $09, $09, $08   ; $2b:
    db $03, $04, $05, $05, $06, $06, $06, $07, $08, $08, $08, $07, $06, $05, $04, $03   ; $2c: Sinking stone
    db $03, $04, $05, $06, $07, $08, $08, $08, $07, $06, $06, $06, $05, $05, $04, $03   ; $2d: Sinking stone flipped
    db $09, $0a, $0a, $0b, $0c, $0c, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d   ; $2e: Hippo
    db $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0c, $0b, $0a, $0a, $09, $00   ; $2f:
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f   ; $30: Falling platform
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f   ; $31: Falling platform flipped

; $44b8
LizzardSprites::
    INCBIN "gfx/LizzardSprites.2bpp"

; $4638
ScorpionSprites::
    INCBIN "gfx/ScorpionSprites.2bpp"

; $4918
FrogSprites::
    INCBIN "gfx/FrogSprites.2bpp"

; $4c38
ArmdadilloSprites::
    INCBIN "gfx/ArmdadilloSprites.2bpp"

; $4f18
PorcupineSprites::
    INCBIN "gfx/PorcupineSprites.2bpp"

; $52d8
BalooBossDanceSprites::
    INCBIN "gfx/BalooBossDanceSprites.2bpp"

; $5b18
BalooBossJumpSprites::
    INCBIN "gfx/BalooBossJumpSprites.2bpp"

; $6418
MonkeyBossSprites::
    INCBIN "gfx/MonkeyBossSprites.2bpp"

; $7018
HangingMonkeySprites::
    INCBIN "gfx/HangingMonkeySprites.2bpp"

; $7218
KingLouieHandSprites::
    INCBIN "gfx/KingLouieHandSprites.2bpp"

; $7c78
ShereKhanHandSprites::
    INCBIN "gfx/ShereKhanHandSprites.2bpp"

; $7fb8: Flames thrown by Shere Khan.
FlameSprite::
    INCBIN "gfx/FlameSprite.2bpp"

; $7fd8: Whatever happened here.
ShereKhanNeckSprite::
    INCBIN "gfx/ShereKhanNeckSprite.2bpp"

; $7ff8: Unused data at the end of the bank.
Bank6TailData::
    db $ff, $ff, $ff, $ff, $ff, $ff, $ff, $06
