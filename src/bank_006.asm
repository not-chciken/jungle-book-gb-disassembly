SECTION "ROM Bank $006", ROMX[$4000], BANK[$6]

; $4000: Initializes the data in c400 by copying the level's GroundData.
; Data is copied if Bit 7 is zero. If Bit 7 is non-zero, the datum is interpreted as N bytes of zero.
InitGroundData::
    ld de, GroundDataRam
CopyLoop:
    ld a, [hl+]                 ; Points to GroundDataPtrBase.
    bit 7, a
    jr nz, .ZeroFill            ; Jump out of loop if Bit 7 in GroundData is non-zero.
    ld [de], a                  ; Copy data to [$c400+e]
    inc e
    jr nz, CopyLoop             ; Loops up to 256 times.
    ret
.ZeroFill:
    and $7f
    jr nz, :+
    or $80
 :  ld b, a
    xor a                       ; a = 0
 :  ld [de], a
    inc e
    ret z
    dec b
    jr nz, :-
    jr CopyLoop

; $401d: This should be pointer data. The referred data is related to the ground's hitbox.
; Each datum corresponds to the ground data of a 2x2 meta tile.
; No ground: $00;
; Eart-based ground: $01 = -- (straight ground, including straight branch), $02 = / (positive slope), ...;
; Branch-based groud: $25 = -o $26 = /-, $27 = -\, $28 = o-;
GroundDataPtrBase::
    dw GroundData1 ; Level 1: JUNGLE BY DAY
    dw GroundData2 ; Level 2: THE GREAT TREE
    dw GroundData3 ; Level 3: DAWN PATROL
    dw GroundData1 ; Level 4: BY THE RIVER
    dw GroundData4 ; Level 5: IN THE RIVER
    dw GroundData5 ; Level 6: TREE VILLAGE
    dw GroundData6 ; Level 7: ANCIENT RUINS
    dw GroundData6 ; Level 8: FALLING RUINS
    dw GroundData1 ; Level 9: JUNGLE BY NIGHT
    dw GroundData7 ; Level 10: THE WASTELANDS
    dw GroundData8 ; Level 11: Bonus
    dw GroundData1 ; Level 12: Transition and credit screen

; $4035
GroundData1::
    db $93, $25, $26, $27, $28, $01, $9f, $01, $cc, $02, $03, $01, $04, $06, $05, $07
    db $08, $00, $09, $0a, $0b, $87, $01, $01, $85, $04, $00, $09, $0b, $0b, $05, $04
    db $0c, $0d, $0e, $0f, $89, $02, $82, $0a, $a2, $06, $00, $09, $0b, $82, $0b, $09
    db $06, $03, $99, $03, $84

; $406a
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

; $4132
GroundData5::
    db $40, $ca, $41, $dc, $06, $82, $01, $01, $11, $01, $12, $13, $00, $00, $14, $15
    db $10, $10, $07, $10, $08, $10, $16, $17, $10, $10, $18, $19, $00, $00, $05, $10
    db $04, $00, $87, $41, $85, $42, $82, $01, $01, $1a, $00, $01, $91, $10, $00, $00
    db $00, $08, $8e

; $4165
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

; $41a8
TODOGroundData::
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
    db $01, $02, $03, $04, $05, $06, $07, $08, $09, $0a, $0b, $0c, $0d, $0e, $0f, $10
    db $10, $10, $10, $10, $10, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $09, $09, $0a, $0a, $0b, $0b, $0c, $0c, $0d, $0d, $0e, $0e, $0f, $0f, $10, $10
    db $01, $01, $02, $02, $03, $03, $04, $04, $05, $05, $06, $06, $07, $07, $08, $08
    db $10, $10, $10, $10, $10, $10, $10, $10, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $10, $0f, $0f, $0e, $0e, $0d, $0d, $0c, $0c, $0b, $0b, $0a, $0a, $09, $09
    db $08, $08, $07, $07, $06, $06, $05, $05, $04, $04, $03, $03, $02, $02, $01, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10
    db $10, $0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06, $05, $04, $03, $02, $01
    db $00, $00, $00, $00, $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10
    db $00, $00, $00, $00, $00, $00, $08, $08, $07, $07, $06, $06, $05, $05, $04, $04
    db $03, $03, $02, $02, $01, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $10, $10, $10, $10, $10, $10, $0f, $0f, $0e, $0e, $0d, $0d, $0c, $0c, $0b, $0b
    db $0a, $0a, $09, $09, $08, $08, $07, $07, $06, $06, $05, $05, $00, $00, $00, $00
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
    db $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $00, $00, $00, $00
    db $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0e, $0e, $0e, $0e, $0d, $0d, $0d, $0d
    db $0c, $0c, $0c, $0c, $0b, $0b, $0b, $0b, $0a, $0a, $0a, $0a, $09, $09, $09, $09
    db $08, $08, $08, $08, $07, $07, $07, $07, $06, $06, $06, $06, $05, $05, $05, $05
    db $04, $04, $04, $04, $03, $03, $03, $03, $02, $02, $02, $02, $01, $01, $01, $01
    db $01, $01, $01, $01, $02, $02, $02, $02, $03, $03, $03, $03, $04, $04, $04, $04
    db $05, $05, $05, $05, $06, $06, $06, $06, $07, $07, $07, $07, $08, $08, $08, $08
    db $09, $09, $09, $09, $0a, $0a, $0a, $0a, $0b, $0b, $0b, $0b, $0c, $0c, $0c, $0c
    db $0d, $0d, $0d, $0d, $0e, $0e, $0e, $0e, $0f, $0f, $0f, $0f, $10, $10, $10, $10
    db $00, $00, $00, $00, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $01, $02, $03, $04
    db $04, $04, $05, $05, $06, $06, $06, $06, $07, $07, $07, $07, $08, $08, $08, $08
    db $04, $04, $04, $03, $02, $01, $03, $05, $07, $09, $0b, $0d, $0f, $10, $10, $10
    db $10, $10, $10, $10, $0f, $0f, $0f, $0e, $0d, $0c, $0b, $0a, $09, $08, $07, $06
    db $07, $06, $05, $04, $03, $02, $01, $00, $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $0a, $0b, $0c, $0d, $0e, $0f, $10, $10, $10, $10
    db $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c
    db $02, $03, $03, $04, $05, $06, $07, $08, $09, $09, $0a, $0a, $0b, $0b, $0b, $0c
    db $0c, $0c, $0c, $0b, $0b, $0b, $0a, $0a, $0a, $09, $09, $08, $08, $08, $07, $07
    db $06, $06, $06, $07, $07, $07, $08, $08, $09, $09, $09, $0a, $0a, $09, $06, $05
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $10, $10, $10, $10, $10, $10, $10, $10
    db $10, $10, $10, $10, $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $10, $10, $10, $10, $10, $10, $10, $10, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $00, $00, $00, $00, $00, $00, $00, $00, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $09, $0a, $0b, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0c, $0b, $0a, $09
    db $03, $05, $08, $09, $09, $0a, $0b, $0c, $0d, $0d, $0c, $0c, $0d, $0d, $0c, $0b
    db $08, $08, $08, $08, $08, $07, $07, $07, $07, $08, $09, $09, $08, $09, $09, $08
    db $03, $04, $05, $05, $06, $06, $06, $07, $08, $08, $08, $07, $06, $05, $04, $03
    db $03, $04, $05, $06, $07, $08, $08, $08, $07, $06, $06, $06, $05, $05, $04, $03
    db $09, $0a, $0a, $0b, $0c, $0c, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d
    db $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0d, $0c, $0b, $0a, $0a, $09, $00
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f
    db $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f, $0f

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

TODOSprites7218::
    INCBIN "gfx/TODOSprites7218.2bpp"

    nop
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
    rst IncrAttr
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
    rst IncrAttr
    cpl
    rst IncrAttr
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
    rst IncrAttr
    rst IncrAttr
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
    call nc, $3dda
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
    rst IncrAttr
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
    rst IncrAttr
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
    call c, $6e73
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
    call z, $7fbf
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
    rst IncrAttr
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
    rst IncrAttr
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
    db $f6

TODOSprites7fb8::
    INCBIN "gfx/TODOSprites7fb8.2bpp"

    ld hl, sp-$0a
    ld hl, sp-$0a
    ld [hl], h
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
