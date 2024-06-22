; Disassembly of "jb.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $003", ROMX[$4000], BANK[$3]

    push bc

Call_003_4001:
    ld hl, $62ae
    add hl, bc
    push bc
    push hl
    ld hl, CompressedTODOData262c6
    ld a, c
    cp $14
    jr nz, jr_003_4012

    ld hl, CompressedTODOData26a07

jr_003_4012:
    ld de, $c700

Jump_003_4015:
    call DecompressTilesIntoVram
    pop hl
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $c900
    call DecompressTilesIntoVram
    pop bc
    ld hl, $6b40
    add hl, bc
    push hl
    ld hl, $6b58
    ld a, c
    cp $14
    jr nz, jr_003_4033

    ld hl, $7226

jr_003_4033:
    ld de, $cb00
    call DecompressTilesIntoVram
    pop hl
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld de, $cd00

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
    ld hl, $40fa
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

DecompressInto9000::
    ld de, $9000

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

jr_003_40c1:
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

jr_003_40d5:
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
    jp c, $c049

    ld b, $db
    inc b
    nop
    ld h, $e8
    sub h
    add a

Jump_003_4103:
    add hl, de
    ld [$1330], a
    inc l
    jr nz, jr_003_4164

    ld b, b
    or l
    add b
    ld l, b

jr_003_410e:
    ld bc, $0252
    and a
    ld hl, sp+$40
    inc de
    inc l
    jr nz, jr_003_4172

    add b
    sub h
    ret nz

    add sp, $31
    ld d, b
    inc b
    dec bc

jr_003_4120:
    sub b
    ld d, $10
    ld b, l
    jr nc, jr_003_4120

    db $fc
    ld a, a
    ld hl, sp-$01
    jr z, jr_003_412c

jr_003_412c:
    ld c, b
    ld a, [hl]
    nop
    adc b
    dec bc
    pop af
    inc bc
    ld b, a
    ret nc

    ld b, b
    ld h, [hl]
    inc bc
    add b
    db $10
    pop af
    cp a
    add hl, sp
    jr nz, jr_003_40c1

    ld [bc], a
    ld [c], a
    db $10
    cpl
    jr jr_003_40d5

    inc bc
    ld a, h
    ld bc, $51c0
    cp $03
    db $fc
    ld b, e
    ld a, h
    ld bc, $2f10
    rst $38
    dec b
    cp $07
    rst $38
    rst $00
    sub b
    ret nz

    inc d
    or b
    db $ed
    jr nz, @+$32

    or b
    ld d, [hl]
    nop
    ld l, [hl]
    inc h

jr_003_4164:
    db $10
    ret nc

    db $76
    ld h, b
    xor [hl]
    nop
    inc e
    ld [hl], c
    jr nz, jr_003_410e

    ld l, l
    ld b, d
    ld d, l
    ret nz

jr_003_4172:
    ld [hl], $f0
    ld b, b
    ld b, b
    dec h
    ld c, [hl]
    ld h, b
    ld a, [hl+]
    jr nc, @-$75

    xor e
    ld bc, $4801
    cp h
    ld a, [bc]
    inc b
    db $10
    dec d
    ret c

    ld b, h
    rst $30
    add b
    nop
    ld h, $d6
    rst $38
    dec bc
    ld b, $2a
    or c
    ld l, $90
    ldh a, [$84]
    ld bc, $088c
    ld [bc], a
    ld a, [bc]
    ld c, h
    ld a, [hl+]
    rst $38
    dec d
    rst $38
    ld [hl+], a
    rst $38
    ld bc, $0087
    and b
    inc l
    ld b, b
    add h
    ld a, [$354f]
    db $10
    ld [$c0c0], sp
    add b
    inc b
    inc l
    inc bc
    ld a, [bc]
    inc h
    db $10
    dec b
    inc [hl]
    ld [hl-], a
    ld [$3028], sp
    db $fd
    inc b
    nop
    or c
    ld [hl], b
    inc h
    nop
    ld [$ff03], sp
    rlca
    inc bc
    ld bc, $fe22
    nop
    ld h, b
    rla
    pop af
    ccf
    ldh a, [rP1]
    jr nc, @-$54

    db $10
    rla
    ld b, $dc
    adc d
    ld b, h
    add [hl]
    ld de, $6888
    ld [bc], a
    add b
    ret nc

    ret c

    db $10

jr_003_41e3:
    inc bc
    ld c, d
    ld e, c
    inc b
    nop
    ld hl, $1fb0
    ld b, $54
    ld a, [$77f8]
    jr jr_003_41f2

jr_003_41f2:
    ld a, h
    and e
    adc $7f
    rst $18
    nop
    add b
    add hl, bc
    jr c, jr_003_423c

    jr nc, jr_003_41e3

    ldh a, [$2f]
    ld [$8316], sp
    ld hl, sp+$47
    db $fc
    rst $00
    add hl, hl
    nop
    ld h, h
    pop bc
    dec b
    nop
    and [hl]
    jr c, jr_003_4212

    add b
    ld a, [c]

jr_003_4212:
    push af
    rst $38
    ld [hl-], a
    nop
    sub b
    ret z

    add [hl]
    nop
    ld h, b
    sub l
    rst $18
    ccf
    rst $38
    ccf
    cp $3f
    db $fc
    ld bc, $1070
    ld [bc], a
    add b
    ld c, h
    dec hl
    rst $38
    ld d, a

jr_003_422c:
    inc bc
    nop
    or h
    ld hl, sp+$40
    ldh [rHDMA1], a
    add b
    ld d, c
    ld hl, sp-$19
    jr jr_003_4239

jr_003_4239:
    jr c, jr_003_422c

    db $fc

jr_003_423c:
    add e
    inc c
    add h
    and h
    xor b
    cp $1d
    rst $38
    sbc l
    ld a, [bc]
    nop
    ld [hl], c
    jr jr_003_4268

    nop
    call nc, $e047
    nop
    jr nc, @+$35

    ld d, d
    db $fc
    add e
    cp $13
    db $fd
    sbc e
    rra
    nop
    pop bc
    add hl, sp
    nop
    ld [$0186], sp
    and b
    inc h
    and b
    nop
    add b
    dec e
    sbc $3f

jr_003_4268:
    rst $18
    nop
    db $10
    ld a, h
    cp $3d
    ld b, $0a
    ld sp, $0ea0
    rst $38
    jr nz, @-$1f

    add b
    sub b
    nop
    rst $20
    ld de, $0230
    ld c, h
    add b
    ld l, a
    ld c, b
    add b
    ld b, [hl]
    ld hl, sp+$07
    ldh [$1f], a
    ret nz

    ccf
    ld b, e
    and c
    daa
    ld [bc], a
    rlca
    add b
    or d
    cp b
    ld b, a
    ld hl, sp+$07
    ld b, b
    ld d, [hl]
    ld hl, sp+$07
    add d
    nop
    xor h
    ld a, e
    add b
    pop hl
    ld bc, $d3a0
    db $fd
    rst $38
    ld hl, sp+$3f
    jp $fdfc


    ld bc, $1ad8
    ld sp, $740f
    dec bc
    ld e, b
    rlca
    ld e, h
    inc bc
    jr jr_003_42bc

    inc [hl]
    dec bc
    or b
    rrca
    cp b
    rlca
    sub h

jr_003_42bc:
    ld a, [hl]
    dec b
    cp $95
    ld a, [hl]
    ld d, c
    cp a
    ld [bc], a
    cp $57
    cp a
    inc b
    dec sp
    ld [bc], a
    and b
    add h
    rst $28
    ld bc, $f940
    add hl, bc
    nop
    jp nz, $ffde

    set 7, a
    ld l, e
    ld bc, $a9d0
    scf
    nop
    db $10
    pop af
    cp $ab
    db $fc
    cp c
    cp $e9
    cp $fd
    cp $f9
    cp $03
    db $fc
    inc bc
    db $fc
    dec sp
    call nz, $c03f
    inc d
    add hl, bc
    call nz, $85c2
    ld d, l
    ld hl, sp+$00
    ccf
    jr nc, jr_003_42fd

jr_003_42fd:
    inc h
    call nz, Call_003_5005
    db $fc
    inc bc
    dec e
    inc bc
    ret nz

    and h
    rst $38
    nop
    ret nz

    inc de
    db $ec
    rst $38
    inc bc
    db $fc
    rlca
    ld hl, sp+$27
    ret c

    ld a, a
    ld [bc], a
    add hl, bc
    ld l, c
    nop
    db $d3
    db $eb
    rst $38
    push de
    rst $38
    ld [$ddff], a
    ld bc, $e8f0
    rst $28
    rra
    rrca

jr_003_4326:
    sub b
    ld a, b
    nop
    db $e4
    inc bc
    jr nz, jr_003_439e

    inc b
    ld b, $f0

jr_003_4330:
    inc bc
    adc h
    ld c, e
    nop
    jr nc, jr_003_4330

    rst $38
    rst $38
    db $fd
    ld l, a
    ld hl, sp-$79
    ld a, a
    ld d, b
    db $fd
    xor a

jr_003_4340:
    ld e, d
    ld [$fa84], sp
    ld a, a
    push af
    cp a
    rst $38
    ld a, a
    rst $38
    ld bc, $ea48
    nop
    rra
    db $e3
    sbc h
    ld h, l
    jp c, $b768

    jp z, $fe57

    add c
    ld l, b
    sbc a
    ld a, a
    ld b, b
    and b
    cp a
    ld c, b
    rst $10
    ld sp, $23ce
    ld a, h

Jump_003_4365:
    adc d
    rst $38
    inc e
    ccf
    jp z, Jump_000_23dd

    pop bc
    adc l
    jr z, jr_003_4340

    ld e, a
    or b
    sbc a
    ld h, b
    ld e, a
    pop af
    ld l, [hl]
    or d
    ld e, l
    db $e4
    ei
    rlca
    ret z

    jr c, jr_003_4326

    ld a, [$f57d]
    ei
    ld a, [c]
    ld a, a
    push af
    adc $3e
    rst $38
    rlca
    xor a
    jp nc, $4011

    ld c, d
    ld [hl], h
    cp $89
    ld [hl], a
    jr nz, jr_003_43a9

    db $10
    xor c
    ld b, $00
    adc h
    ld [hl], d
    db $fd
    adc [hl]
    ld [hl], c

jr_003_439e:
    cp $0b
    ld b, [hl]
    ld a, e
    ret c

    ld sp, hl
    rst $30
    inc bc
    ld a, h
    ld sp, hl
    or a

jr_003_43a9:
    di
    rst $08
    rst $30
    rst $38
    db $e3
    rst $08
    ld sp, hl
    add a
    ld a, a
    ld [hl], b
    adc l
    xor a
    db $fc
    db $e3
    db $10
    rst $28
    cp $7f
    cp $bf
    ld a, [hl]
    ld e, a
    or l
    rst $28
    sub c
    and c
    jr z, jr_003_43c9

    ld a, [$fd05]
    add d

jr_003_43c9:
    ld a, b
    ld b, a

jr_003_43cb:
    cp l
    and a
    db $db
    ld [hl], l
    db $fd
    cp d
    cp $11
    db $fd
    ld b, e
    cp a
    ld a, e
    add b
    rst $38
    ld bc, $48b6
    db $10
    ld a, [de]
    ld a, [c]
    rrca
    call nc, $a03f
    ld a, a
    ret nc

    ld a, a
    xor b
    ld a, a
    ldh [$1f], a
    inc b
    ei
    ld b, b
    cp $3d
    ret nz

    ld b, a
    cp b
    add e
    ld a, a
    sub h
    ld a, l
    ld c, $fc
    ld b, a
    cp $a9
    db $fc
    ld [hl], a
    ld sp, hl
    rst $38
    inc bc
    ld hl, sp+$07

Call_003_4402:
    ldh [$1f], a
    call nz, $a83f
    ld a, a
    inc d
    rst $38
    inc l
    rst $38
    ld e, h
    cp a
    inc b
    add b
    ld c, $a3
    ld a, h
    ld hl, $91de
    xor $0d
    rst $30
    dec l
    ld a, [$fd7f]
    ld a, l
    ld a, [de]
    dec b
    ld e, h
    jr jr_003_43cb

    ld a, [bc]
    ld a, a
    add b
    ccf
    ret nz

    rra
    pop hl
    ld d, h
    cp e
    xor e
    ld d, l
    ld [c], a
    rla
    ld [bc], a
    ld d, b
    db $eb
    inc d
    rst $20
    inc bc
    ld b, b
    xor [hl]
    ld e, e
    and h
    ld h, e
    sbc h
    ld [hl], l
    adc [hl]
    ld a, e
    add [hl]
    ld a, l
    ld [bc], a
    push bc
    nop
    sub e
    ld c, d
    ld a, a
    db $d3
    db $fc
    pop hl
    cp $d0
    rst $38
    ld [c], a
    db $fd
    pop de
    rst $38
    push hl
    ld a, e
    push bc
    cp e
    db $eb
    rst $38
    pop de

Call_003_4458:
    cp a
    db $e4
    ld a, e
    or $b9
    ld l, e
    db $fc
    inc sp
    db $fc
    add hl, sp
    cp $01
    cp [hl]
    di
    adc a
    ld sp, hl
    rst $00
    cp h
    ld b, e
    cp $49
    nop

jr_003_446e:
    xor c
    ld c, $40
    ld sp, hl
    cp $f5
    rst $38
    pop hl
    cp $e5
    rst $38
    pop af
    xor $5d
    and $39
    rst $00
    ld hl, sp+$07
    inc a
    pop bc
    sbc $60
    rra
    ld [c], a
    ld c, a
    or e
    adc a
    di
    rst $38
    db $d3
    rst $08
    di
    rst $10
    jp hl


    ei
    ld a, $7d
    cp a
    cp l
    ld a, [hl]
    db $fd
    ld a, a
    ld sp, hl
    ld a, [hl]
    push af
    ld a, d
    db $ed
    ld [hl], e
    call c, $fc63
    inc bc
    ld a, h
    add b
    rst $38
    ld [bc], a
    rst $38
    nop
    rst $38
    ld bc, $64ea
    jr nc, jr_003_44d9

    rst $00
    rst $38
    sbc e
    and a
    db $dd
    and e
    sbc $61
    rst $18
    and b
    ld e, a
    add b
    ld de, $833c
    ld a, h
    add d

Jump_003_44c0:
    ld bc, $05b6
    ld l, e
    dec c
    inc bc
    jp nz, $3101

    ret nz

    inc c
    ldh a, [$88]
    pop bc
    xor e
    ld [bc], a
    ld a, b
    ldh [$df], a
    jr c, jr_003_450c

    ld c, $09
    rlca
    ld [bc], a

jr_003_44d9:
    ld bc, $0070
    inc c
    ld [hl], b
    dec c
    ld b, d
    jr jr_003_446e

    inc b
    cp $89
    ld [hl], a
    ld [c], a
    ld bc, $7ff0
    ld e, b

jr_003_44eb:
    ld h, b
    sbc e
    ld [$804b], sp
    inc hl
    call nz, $e413
    dec bc
    db $f4
    inc bc
    ld hl, sp+$07
    db $fc
    ld [hl], e
    nop
    ld h, b
    ld bc, $03fe
    rst $38
    add d
    ld a, l
    pop bc
    cp h
    ld h, b
    ld e, h
    ld [hl-], a
    inc l
    add hl, de
    add [hl]
    inc c

jr_003_450c:
    ld b, e
    add h
    inc hl
    ret nz

    inc de
    ldh [$0b], a
    ldh a, [rTAC]
    ld hl, sp+$07
    ld hl, sp+$6f
    inc h
    nop
    add hl, hl
    ret nc

    pop de
    ld b, b
    cp a
    add c
    ld a, $03
    dec a
    ld b, [hl]
    ld a, [hl-]
    adc h

jr_003_4527:
    ld [hl], h
    jr jr_003_44eb

    or b
    ld a, [c]
    ld h, c
    db $e4
    ld b, e

Call_003_452f:
    ret z

    ld b, a
    ret nc

    ld c, a
    ldh [$df], a
    ld b, l
    ld b, $ae
    db $10
    rrca
    jr nz, jr_003_455a

    ld b, b
    ld a, $0c
    add e
    ld d, b
    inc bc
    and b
    ld c, $9a
    ld bc, $8c04

jr_003_4548:
    ld h, h
    jr nz, jr_003_4557

    ld l, [hl]
    ld a, [de]
    jr nz, jr_003_4548

    ld e, $a4
    ld a, b
    rst $38
    ld bc, $07fe
    ei

jr_003_4557:
    inc e
    db $e4
    ld a, b

jr_003_455a:
    sub b
    ldh [rSCX], a
    add b
    inc c
    inc bc
    ld sp, $900f
    ld h, b
    ld b, e
    nop
    inc c
    inc bc
    ld [hl], b
    rrca
    ld b, b
    ccf
    ld b, b
    ccf
    nop
    ld hl, $bc01
    ld a, [bc]
    cp $09
    ld hl, sp+$27
    ld [$0d3c], sp
    ld [hl], b
    ld a, [de]
    ld c, h
    inc b
    ldh a, [$f7]
    rst $38
    ld sp, hl
    add a
    ld [hl], c
    ld [hl], b
    ld [$fa20], sp
    inc bc
    nop
    ld a, [$0021]
    inc hl
    db $fd
    add e
    rst $38
    ld [hl], e
    add b
    rla
    add b
    jr nz, jr_003_4527

    ld d, c
    add b
    ccf
    ldh [$1f], a
    ret z

    rra
    call nc, $c80f
    rlca
    db $e4
    inc bc
    ld a, [c]
    dec c
    ret nz

    cp a
    ld d, b
    cp a
    ld b, h
    nop
    sub b
    ld [bc], a
    ld [bc], a
    ret nz

    cp a

jr_003_45b1:
    ret nz

    ld a, a
    add c
    cp a
    ld [bc], a
    cp l
    push bc
    dec sp
    add sp, $1f
    pop af
    ld c, $d6
    ld hl, $27d9
    call nc, Call_003_452f
    ld [bc], a
    ld bc, $2ff0
    ldh [$3f], a
    ldh [$1f], a

jr_003_45cc:
    ld [c], a
    db $fd
    ld [bc], a
    ld a, a
    add b
    sbc a
    ret nz

    ld a, a
    ret nz

    ld e, a
    ldh [$5f], a
    ld [hl+], a
    ret nc

    ld b, $fd
    inc bc
    sbc b
    nop
    jr nz, jr_003_45b1

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
    jr jr_003_45cc

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

Jump_003_46ec:
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

Call_003_476d:
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

jr_003_49d2:
    dec sp
    ret nz

    ld c, a
    pop bc
    db $10
    cp $01
    inc b
    ld b, b
    ld bc, $00d1
    db $fc
    db $fd
    cp a
    ld a, h
    nop
    nop
    dec de
    ld c, $88
    db $fc
    rst $38
    jp hl


    pop af
    ld bc, $0c06
    add a
    ld c, e
    db $fc
    nop
    dec b
    inc bc
    add h
    inc b
    cp h
    rra
    nop
    ld d, h
    ld h, b
    ld b, d
    ld [bc], a
    ld e, $40
    cp a
    jr nz, jr_003_49d2

    ld l, b

Call_003_4a03:
    add d
    ld de, $3fd8
    adc $9f
    rst $00
    and a
    ld bc, $0940
    ccf
    or b
    and b
    inc b
    db $f4
    adc a
    ld [hl], c
    ld h, b
    db $10
    ld l, [hl]
    jr nc, @+$32

    ld a, [$f903]
    jp $75f8


    ld hl, sp+$3e
    jr c, jr_003_4a33

    ret z

    rlca
    ldh a, [$6f]
    inc e
    ld [de], a
    ld bc, $83fe
    rst $38
    ld h, e
    db $fd
    nop
    dec c
    ld [hl+], a

jr_003_4a33:
    inc e
    sbc b
    cp $05
    cp $31
    ret nz

    pop bc
    ld c, $03
    cp $0d
    cp $39
    db $fc
    pop af
    ld a, [c]
    rra
    nop
    ld c, [hl]
    rra
    ld bc, $f8c1
    dec c
    inc h
    ld [hl-], a
    dec a
    ld d, b
    ld a, [bc]
    ldh a, [$27]
    ldh a, [$c7]
    add sp, -$79
    db $db
    rrca
    ld hl, sp+$3f
    ld hl, sp-$29
    ldh [rNR22], a
    ld [$4886], sp
    pop hl
    add b
    sbc a
    inc bc
    ld a, [hl]
    ld [bc], a
    db $fc
    add hl, de
    ld a, [bc]
    ld bc, $9fe0
    nop
    cp a
    ld h, d
    db $fc
    ld [c], a
    reti


    db $ed
    ld [hl], e
    db $e3
    rst $30
    cp $c7
    rst $20
    xor a
    db $ed
    rrca
    db $e4
    inc bc
    push af
    jr jr_003_4b00

    sbc $32
    rrca
    cp c
    ld a, a
    sbc [hl]
    dec e
    call nc, $c98f
    sub $af
    xor l
    push bc

jr_003_4a91:
    rst $08
    db $fc
    add a
    ld h, d
    scf
    call $e233
    sbc c
    ld h, d
    sbc h
    nop
    rra
    rl [hl]
    ret nc

    ld l, a
    add d
    dec e
    or h
    db $db
    jr nc, jr_003_4ab7

    ld h, c
    ld e, $e5
    jr jr_003_4a91

    ld b, e
    jr z, jr_003_4ae0

    ld bc, $00d3
    ld b, b
    add b
    rst $38
    ld [bc], a

jr_003_4ab7:
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

jr_003_4b00:
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

Call_003_5005:
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
    call z, Call_003_6e3e
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
    call c, Call_003_4a03
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
    call c, Call_003_4a03
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
    jp Jump_003_44c0


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
    call nz, Call_003_681f
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

    call nz, Call_003_6c01
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

Jump_003_62c2:
    db $ec
    ld h, e
    db $ec
    ld h, e

CompressedTODOData262c6::
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
    db $08, $28

    add b
    dec bc
    nop
    ld [bc], a
    ldh a, [rSB]
    jp $8001


    ld [hl+], a
    ld bc, $17a6
    adc l
    adc l
    ld e, $9f
    jr @-$65

    nop
    sub [hl]
    add hl, de
    sbc d
    sub a
    sbc d
    add b
    adc b
    nop
    cp b
    add c
    dec b
    add b
    call Call_003_4402
    and l
    dec b
    nop
    xor [hl]
    jp z, $cac8

    inc b
    inc b
    ld [bc], a
    ld [bc], a
    call nz, $b0c6
    or d
    xor h
    xor [hl]
    ld [bc], a
    ld [bc], a
    or b
    or d
    inc b
    or h
    inc b
    jr z, jr_003_6437

    jr nc, @-$59

    push bc

jr_003_6428:
    dec d
    or b
    push bc
    ld d, l
    nop
    sbc b
    jp nc, $11fa

    nop
    ld a, b
    dec [hl]
    add hl, sp
    dec b
    ld c, h

jr_003_6437:
    add hl, bc
    ld [$f8f4], sp
    jr nz, jr_003_643d

jr_003_643d:
    add $92
    sbc [hl]
    and b
    xor b
    ld [bc], a
    add [hl]
    adc b
    sub h
    sub [hl]
    and d
    and h
    ld [bc], a
    xor d
    call z, $c2ce
    or h
    call z, $d0ce
    or h
    call nc, $022c
    jr nz, @+$04

    ld bc, $0100
    inc de
    ld b, b
    inc de
    nop
    ld e, e
    inc de
    jr c, @+$06

    inc c
    and c
    ld b, b
    jr nz, jr_003_6428

    ld c, b
    ld c, l
    dec bc
    ld c, l
    ret nz

    ld [$00ca], a
    jr nz, jr_003_64cf

    ld l, b
    ld e, d
    ld [bc], a
    ld e, l
    ld [bc], a
    ld l, c
    ld l, d
    ld [bc], a
    ld h, d
    ld h, e
    ld h, d

jr_003_647d:
    ld h, e
    ld h, h
    ld l, c
    rrca
    ld [bc], a
    inc l
    ld bc, $3ebe
    cp a
    cp a
    add hl, sp
    ld bc, $baba
    nop
    dec b
    nop
    inc d
    bit 1, e
    ld b, b
    ld b, b
    dec c
    ld c, [hl]
    ret nz

    ld b, c
    add b
    jp hl


    ld b, l
    jr nz, jr_003_647d

    dec h
    add hl, bc
    ret z

    add sp, $48
    ld b, b
    add b
    push hl
    add l
    ld bc, $8484
    inc hl
    ld d, b
    inc hl
    add b
    ld d, e
    db $e3
    push hl
    push af
    sub l
    ld [$0a2c], sp
    ld [de], a
    ld a, [bc]
    ld c, b
    ld [c], a
    add d
    jp c, $0ae2

    ld [de], a
    ld b, d
    ld a, [bc]
    ld a, b
    ld a, [bc]
    and b
    ld a, d
    inc b
    db $10
    push de
    call nc, $0404
    inc b
    inc c
    add hl, hl
    add hl, hl
    dec l

jr_003_64cf:
    dec l
    dec b
    jr nc, jr_003_64d8

    inc [hl]
    nop
    sbc h
    sbc $04

jr_003_64d8:
    inc b
    ldh [$e2], a
    inc b
    inc b
    db $e4
    db $10
    inc b
    ld c, h
    ld [bc], a
    db $76
    ld [bc], a
    ld [bc], a
    ld [hl], a
    ld [bc], a
    ld l, a
    ld a, b
    ld l, h
    ld [bc], a
    ld l, h
    ld a, c
    ld a, h
    ld a, l
    ld [bc], a
    ld a, d
    ld [bc], a
    ld [bc], a
    ld a, e
    ld [bc], a
    ld a, [hl]
    dec d
    ld bc, $7264
    or c
    ld [hl], c
    or c
    ld de, $3010
    ld [$8041], sp
    or [hl]

Jump_003_6504:
    nop
    ld h, h
    ld [hl], e
    ld [bc], a
    ld l, h
    ld [hl], h
    ld [hl], l
    ld l, l
    ld l, [hl]
    db $76
    ld [hl], a
    ld l, a
    ld [hl], b
    ld a, b
    ld a, c
    ld [hl], c
    ld [hl], d
    ld a, d

jr_003_6516:
    ld a, e
    ld a, h
    ld a, h
    ld bc, $7d01
    ld a, l
    ld bc, $7e01
    ld a, [hl]
    ld bc, $7f01
    ld a, a
    ld bc, $6b01
    ld l, b
    ld l, c
    ld l, d
    dec h
    ld bc, $1278
    db $10
    db $10
    inc b
    inc a
    add hl, bc
    inc b
    ld [bc], a
    and d
    inc b
    call nc, $cac8
    ld e, b
    ld e, b
    inc c
    add b
    pop bc
    ld [de], a
    nop
    jr z, jr_003_6516

    ld a, [bc]
    nop
    adc h
    ld d, $cb
    ld a, [de]
    ld c, e
    sbc d
    sbc d
    ld bc, $8880
    and l
    adc e
    dec h
    call $8aea
    dec h
    adc l
    xor h
    inc c
    ld l, l
    ld bc, $85a0
    add $e2
    ld h, d
    jp Jump_003_62c2


    ld c, b
    jr z, @+$7c

    jr nc, jr_003_65d3

    inc l
    inc l
    ld l, e
    ld l, c
    ld l, d
    ld l, c

jr_003_656f:
    inc l
    ld l, e
    ld l, b
    ld l, e
    ld l, b
    inc l
    ld l, d
    nop
    ld e, $1e
    ld [bc], a
    dec e
    nop
    ld [bc], a
    dec e
    ld d, $01
    ld [bc], a
    ld bc, $0000
    ld e, $00
    or [hl]
    ld [hl], $b8
    inc e
    or a
    or a
    sbc h
    jr c, jr_003_658f

jr_003_658f:
    nop
    cp h
    inc a
    cp d
    inc e
    cp l
    cp l
    ld a, [hl-]
    dec sp
    ld a, $00
    cp a
    cp a
    adc l
    inc c
    inc c
    ld b, l
    dec b
    nop
    add b
    push bc
    dec b
    nop
    ret nz

    dec e
    nop
    nop
    nop
    ld c, e
    inc bc
    jr nz, jr_003_656f

    ld e, b
    ld e, b

jr_003_65b1:
    ld e, b
    ld [$0200], sp
    add sp, $01
    nop
    ld c, e
    rrc l
    adc [hl]
    ld c, e
    dec bc
    inc c
    adc [hl]
    nop
    adc h
    add b
    dec bc
    inc bc
    add b
    ld [$6665], sp
    ld h, d
    ld [hl], h
    ld [$4400], sp
    jr z, @-$4b

    or d
    ld d, d
    or e

jr_003_65d3:
    or d
    inc hl
    ld h, e
    inc hl
    jp $b373


    nop
    db $10
    ld [hl], e
    jp hl


    ld [hl], c
    add hl, bc
    jp z, $89f1

    ld de, $c9fa
    add hl, de

jr_003_65e7:
    adc d
    pop af
    ld e, c
    ld de, $595a
    ld bc, $215a
    ld a, [c]
    or c
    ld de, $19b2
    ret z

    ret z

    ld e, b
    pop de
    jr @+$5a

    pop de
    xor b
    ld e, b
    add hl, de
    xor b
    ld e, b
    or c
    or b
    jr jr_003_661d

    jr @-$3e

    ret z

    ret nz

    ret z

    ld [hl], b
    ld c, c
    ld h, b
    inc c
    inc c
    xor h
    xor h
    ld d, b
    ld d, h
    jr jr_003_6617

    ld h, e
    ld h, b

jr_003_6617:
    ld b, b
    ld h, e
    ld h, e
    ld h, l
    push bc
    ld [c], a

jr_003_661d:
    jp nz, $62e2

    ld h, b
    nop
    nop
    add b
    push hl

Call_003_6625:
    ld sp, $0010
    ld l, $41
    inc bc
    ld b, b
    ld [hl-], a
    sub a
    jr nz, jr_003_65b1

    jr @+$23

    sub a
    add b
    and c
    sbc b
    jr jr_003_6639

    and c

jr_003_6639:
    dec d
    ld bc, $1597
    and d
    inc e
    rla
    ld hl, $b91b
    add hl, sp
    cp h
    cp e
    add hl, sp
    ld a, [hl-]
    cp h
    cp e
    ld [hl], $3a
    or a
    ld a, [hl-]
    cp c
    scf
    dec sp
    cp b
    jr nc, jr_003_65e7

    nop
    ld [hl], b
    dec b
    add sp, $0a
    ld a, b
    ld [$0961], a
    ld a, [hl+]
    nop
    inc c
    call nc, Call_003_5211
    call nc, Call_003_51ca
    rrc d
    adc $11
    ld d, d
    sub d
    jp nc, $d312

    inc de
    ld d, h
    sub e
    ld d, e
    sub h
    ld d, h
    ret nz

    ld d, h
    ld b, b
    nop
    ld d, l
    ld d, l
    ret nz

    sbc a
    add b
    ret nz

    ld [de], a

jr_003_6680:
    sub e
    add b
    ld b, b
    sub e
    db $d3
    inc de
    ld d, h
    ret nz

    ld d, h
    sub h
    inc d
    ld d, l
    ld d, l
    ld c, e
    ld b, $c5
    cpl
    nop
    and b
    ld h, h
    ld [hl], l
    add l
    sub l
    and l
    or l
    dec h
    jr nz, @-$3e

    push de
    dec h
    jr nz, jr_003_6680

    push af
    dec b
    ld d, $46
    ld d, [hl]
    ld h, $36
    ld h, [hl]
    ld d, $c0
    push de
    dec b
    ld d, $e6
    push af
    dec h
    ld [hl], $46
    ld d, [hl]
    and $17
    ld h, b
    ld [hl], $12
    ld h, b
    cpl
    ld bc, JoyPadNewPresses
    ld h, b
    sbc h
    and c
    and l
    xor c
    ld de, $ce00
    cp $02
    dec b

jr_003_66c8:
    ld c, b
    ld bc, $56a1
    ld [hl], d
    inc b
    ld h, d
    ld h, b
    adc d
    nop
    ld c, $40
    ld b, [hl]
    ld a, $00
    ld b, d
    ld sp, $3930
    ld l, $00
    ld [hl-], a
    nop
    ld [hl-], a
    ld sp, $3932
    ld a, $33
    ld sp, $3935
    ld [bc], a
    ld b, l
    jr nc, jr_003_66ec

jr_003_66ec:
    nop
    ld b, [hl]
    nop
    nop
    jr nc, @+$3b

    ld sp, $3031
    nop
    ld l, $00
    add hl, sp
    ld sp, $0925
    add d
    sbc h
    sbc b
    inc hl
    and h
    sub l
    or b
    inc hl
    inc h
    ld sp, $9925
    inc hl
    sbc c
    dec d
    sbc a
    ld sp, $1b21
    or b
    sub l
    jr nc, jr_003_66c8

    cp b
    inc a
    ld bc, $9781
    adc l
    nop
    jr z, @-$0d

    jp hl


    dec b
    ld hl, sp-$13
    db $fd
    push af
    dec b
    add sp, -$13
    ld sp, hl
    push af
    ld sp, $6082
    ldh [$d2], a
    ld b, b
    and [hl]
    jr c, jr_003_676f

    ld bc, $be81
    add b
    cp b
    cp h
    add b
    cp [hl]
    rla
    sbc d
    ccf
    ld a, [de]
    rlca
    ld b, b
    sub d
    inc bc
    call nz, $0bc3
    adc l
    call nz, Call_003_5c44
    ld e, $44
    call nz, $838b
    call nz, $8bc3
    add e
    ret nz

    jp Jump_003_5b1a


    nop
    dec c
    adc l
    add b
    add b
    add b
    sub $56
    ld e, h
    add b
    ld b, b
    sbc h
    add b
    ld b, b
    inc e
    adc l
    push de
    push de
    ld c, c
    nop
    pop hl
    ld b, c
    ld b, b
    xor [hl]
    dec l
    ld h, b
    adc [hl]

jr_003_676f:
    adc [hl]
    ld h, $a2
    xor $28
    ld h, e
    push bc
    xor $6e
    ld b, l
    inc bc
    ld c, a
    jr nz, @-$30

    ld c, l
    and b
    ld c, l
    ldh [$2d], a
    ldh [$e5], a
    db $ed
    ld c, l
    and b
    inc bc
    ld c, $8e
    and d
    ld [bc], a
    ld c, $ce
    ld [c], a
    ld [bc], a
    ld c, $ce
    inc hl
    rrca
    xor $cd
    ld c, l
    ldh [rKEY1], a
    ldh [rTMA], a
    add a
    dec h
    xor b
    ld h, $80
    ld bc, $0142
    ret nc

    ld [de], a
    ld [hl], e
    ld h, e
    push de
    ld [bc], a
    ld [hl], e
    ld [hl], e
    ld [$1b90], sp
    rla
    jr jr_003_67ce

    ld b, d
    ret nz

    sub l
    ld c, h
    jr nz, @-$3e

    xor [hl]
    push bc
    push hl
    ld b, [hl]
    rlca
    ld h, $66
    rst $00
    ld a, [hl+]
    ld b, [hl]
    add $ea
    add [hl]
    ld bc, $5740
    ret nz

    ld l, $2c
    nop

jr_003_67cb:
    db $10
    ld h, d
    ld h, d

jr_003_67ce:
    ld h, e
    ld h, h
    add h
    jr nz, jr_003_67cb

    jr nz, @+$39

    and b
    dec l
    nop
    ld d, c
    ld bc, $dbe9
    db $db
    inc bc
    ldh [$03], a
    ret c

    db $e3
    db $e3
    db $db
    ld d, e
    inc b
    jr z, jr_003_6849

    jp hl


    ld [hl], l
    push hl
    jp hl


    pop bc
    db $e4
    db $ed
    call nz, Call_003_58b4
    adc l
    pop bc
    inc [hl]
    ld [bc], a
    ld [hl+], a
    add [hl]
    ld l, h
    xor h
    dec b
    add [hl]
    ld l, h
    rlca
    dec bc
    xor a
    dec hl
    rrca
    cpl
    ld h, $cf
    ld [$8f4a], a
    dec hl
    ld l, a
    ld [hl+], a
    ld bc, $3447
    ld [hl], $5f
    ld a, [hl]
    ld h, b
    ld e, [hl]
    ld a, a
    ld e, c
    ld l, $58
    ld a, [hl-]
    ld e, l
    dec l
    ld e, b
    scf
    ld e, l
    ld l, $58

Call_003_681f:
    ld [bc], a
    ld bc, $0102
    ld a, [hl-]
    rla
    ld de, $3336

jr_003_6828:
    dec sp
    ld b, e
    ld c, e
    add e
    adc c
    ld sp, $533b
    ld e, e
    cp e
    reti


    ld b, c
    ld c, e
    ld d, e
    ld e, e
    ld l, e
    ld [hl], c
    sub c
    sbc e
    sub e
    sbc e
    and e
    xor e
    and e
    xor e
    or e
    cp e
    ld h, e
    inc de
    ld l, b
    ld h, e
    ld [hl], e
    ld l, e

jr_003_6849:
    inc de
    ld [hl], b
    inc de
    ld a, b
    ld a, e
    add e
    add e
    adc e
    adc e
    inc de
    ld l, b
    ld [hl], c
    ld [hl], c
    add hl, bc
    db $10
    ld [$58ec], sp
    dec c
    nop
    adc b
    inc b
    db $ec
    xor $76
    xor h
    inc b
    inc c
    nop
    db $d3
    ld [c], a
    ld [hl+], a
    inc hl
    nop
    inc de
    inc hl
    jr nc, jr_003_6892

    inc hl
    ld [hl], b
    and e
    inc hl
    jr nc, jr_003_6828

    ld h, e
    push de
    ld [de], a
    inc hl
    inc sp
    inc hl
    inc sp
    ld [hl], e
    ld h, e
    add l
    sub c
    ld [hl+], a
    ld e, b
    nop
    ld d, l
    ld d, [hl]
    db $76
    and e
    ld d, e
    ld d, [hl]
    or [hl]
    ld h, e
    dec b
    sub b
    nop
    inc b
    xor l
    ret nz

    ret nz

jr_003_6892:
    ld [hl], h
    ld bc, $0008
    adc h
    xor [hl]
    nop
    cp b
    ld b, $00
    ld b, l
    ld e, h
    nop
    ld sp, $5600
    ld e, d
    nop
    nop
    ld bc, $3100
    ld e, d
    ld d, [hl]
    ld e, h
    ld bc, $5d00
    ld de, $1211
    ld bc, $1e81
    rra
    ld b, d
    add c
    pop de
    rrca
    sub b
    pop de
    ld d, c
    sub b
    db $10
    ld d, d
    jp nc, $9110

    jp nc, $9152

    nop
    db $d3
    dec bc
    ld b, h
    add d
    ld h, b
    nop
    ld d, c
    sub e
    ld d, e
    ret nz

    call nc, Call_000_1413
    ld d, l
    ld b, b
    sub h
    ld d, h
    ld b, b
    dec d
    inc bc
    ld [$5800], sp
    ld e, [hl]
    ld [bc], a
    ld [bc], a
    ld l, d
    ld [hl], b
    ld [bc], a
    ld [bc], a
    ld [de], a
    inc l
    ld bc, $011e
    nop
    jp c, $0224

    ld b, b
    db $10
    ldh [$6d], a
    add e
    ld b, e
    db $10
    db $10
    dec de
    inc e
    ld hl, $191a
    ld a, [de]
    ld [bc], a
    ld [bc], a
    adc b
    ret nz

    nop
    nop
    xor b
    or b
    cp b
    ret nz

    db $10
    db $10
    add b
    add c
    ld bc, $b800
    add c
    pop de
    ld bc, $d980
    ld bc, $4208
    ld c, d
    ld c, d
    adc d
    ld d, d
    ld c, d
    sub d
    sbc d
    ld [c], a
    ld [$0002], a
    ret c

    ld [c], a
    ld [bc], a
    nop
    ld e, b
    ld h, d
    and d
    xor d
    ld l, d
    ld a, [bc]
    or b
    cp d
    ld [$02f2], a
    nop
    ld hl, sp+$02
    inc bc
    nop
    and b
    add hl, bc
    db $10
    inc b
    ld d, d
    jp z, $e9e1

    pop af
    ld bc, $f800
    ld bc, $120a
    ld a, [bc]
    ld [$0a18], sp
    jr nz, @+$2c

    ld [bc], a
    ld [hl], b
    ld [hl-], a
    ld a, [hl-]
    ld a, d
    add d
    ld [bc], a
    ret nz

    ld [bc], a
    nop
    ret z

    jp nc, Jump_003_48e2

    nop
    sub a
    ret c

    ld e, b
    ld b, b
    nop
    ld e, c
    sbc c
    ld bc, $6d50
    dec l
    ret nz

    adc h
    xor l
    db $ed
    inc c
    dec c
    nop
    jr nz, @+$4f

    dec c

Call_003_696c:
    nop
    ret nz

    db $ed
    dec l
    ld c, [hl]
    ld c, $0e
    ld h, b
    ld c, $a0
    adc $0e
    nop
    ldh [$0e], a
    ld h, b
    inc hl
    add c
    ld c, d
    ld [hl], c
    ld [hl], d
    dec e
    ld e, $04
    add b
    add hl, bc
    ld [$0e1d], sp
    ld bc, $1f0f
    jr nz, @+$03

    ld bc, $0088
    add hl, hl
    adc b
    ld [$1301], sp
    add c
    ld [de], a
    ld bc, $8813
    adc b
    add hl, bc
    add hl, bc
    ld a, [bc]
    add c
    add hl, bc
    ld bc, $0488
    jr c, jr_003_69b3

    inc c
    nop
    add b
    inc d
    sub l
    inc de
    sub h
    add b
    nop
    nop
    add b
    dec d
    sub [hl]

jr_003_69b3:
    dec d
    sub [hl]
    ld d, $97
    ld d, $17
    adc c
    inc b
    ld b, $00
    ld b, b
    ld b, b
    ret nz

    ld c, e
    ld c, l
    ld b, b
    add b
    dec c
    adc [hl]
    call $2002
    add hl, bc
    cpl
    adc a
    xor a
    ld c, a
    ld l, a
    rst $08
    rst $28
    rrca
    nop
    ldh [$03], a
    inc b
    nop
    and b
    jp $c3a3


    inc hl
    add a
    daa
    ldh [rNR42], a
    ldh [$e1], a
    dec b
    ld h, a
    add e
    inc hl
    nop
    rlca
    rlca
    ldh [rTIMA], a
    rlca
    nop
    ldh [rNR51], a
    nop
    ldh [$e5], a
    dec b
    and a
    jp nz, Jump_000_2102

    ret nz

    add b
    and c
    add c
    ld hl, $8020
    and c
    ld hl, $2020
    add b
    add b
    ld b, c
    add c
    daa

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
    call z, Call_003_696c
    ld l, [hl]
    call z, $cc6c
    ld l, h
    call z, Call_003_696c
    ld l, [hl]
    ld [$0870], sp
    ld [hl], b
    call z, $096c
    ld [hl], c
    call z, $cc6c
    ld l, h
    nop
    ld [bc], a
    ld [hl], b
    ld bc, $0080
    cpl
    inc d
    ld [$5800], sp
    ld hl, $0443
    ld b, d
    ld bc, $c343
    ld [bc], a
    add a
    jp Jump_003_4103


    add d
    add e
    inc b
    add a
    inc bc
    ld b, e
    add e
    ld b, h
    ld [bc], a
    add [hl]
    and c
    ld b, c
    nop
    or b
    rst $00
    ld de, $e800
    db $e3
    ld [$e800], sp
    ld b, l
    ld c, b
    ld [$a200], sp
    ldh a, [$a2]
    ld b, d
    ld b, c
    pop hl
    and b
    nop
    adc h
    inc d
    ret nz

    ld l, h
    jp Jump_003_4365


    ld b, d
    add d
    jp nz, $a000

    inc h
    ld [bc], a
    inc hl
    ld sp, $0400
    rrca
    add hl, bc
    db $10
    dec b
    ld b, d
    ld h, b
    ld c, b
    ld c, b
    ld h, b
    ld h, h
    cp h
    ld a, h
    jr z, jr_003_6bcd

    nop
    push hl
    inc bc
    ld b, e
    ld [c], a
    inc bc
    ld b, h
    pop bc
    db $10
    jr @+$07

    and d
    ld [hl], b
    ld [hl], c
    ld b, c
    ld [$1a4c], sp
    jr jr_003_6bd7

    ld [de], a
    add hl, de
    ld a, [de]
    inc hl
    cpl
    ld a, [de]
    inc hl
    inc hl

jr_003_6bcd:
    ld [de], a
    ld a, [bc]
    nop

jr_003_6bd0:
    add hl, bc
    db $10
    ld a, $1b
    scf
    rla
    dec a

jr_003_6bd7:
    dec e
    ld [de], a

jr_003_6bd9:
    dec hl
    inc c
    ld sp, $210a
    ld a, [bc]
    ld a, [de]
    ld c, $20
    and e
    db $10
    add hl, bc
    ld [de], a
    adc c
    ld [de], a
    adc c
    rrca
    add hl, bc
    sub d
    inc de
    add hl, bc
    inc de
    adc c
    ld de, $1389
    add hl, bc
    adc c
    sub d
    sub d
    inc c
    inc c
    add l
    adc e
    inc b
    inc d
    and c
    sub h
    ld h, h
    ret z

Call_003_6c01:
    jr z, jr_003_6c2b

    and b
    and h
    ld h, h
    ret z

    sbc b
    ld c, b
    ld h, h
    sbc b
    jr z, jr_003_6bd9

    ld b, b
    inc b
    add b

jr_003_6c10:
    ld c, h
    jp nz, Jump_003_6504

    nop
    and b
    and h
    ld h, b
    add d
    ld [hl+], a
    sub e
    ld [hl], c
    ld [hl], c
    pop de
    or c
    ld [hl], c
    ld [hl], c
    ld hl, $e1d2
    or b
    jp nz, $2311

    or c
    ld [hl+], a
    or c

jr_003_6c2b:
    ld b, d
    and e
    add b
    ld bc, $60a2
    inc de
    and d
    pop af
    ld d, d
    inc hl
    or c
    sub d
    ld hl, $a343
    jr nz, jr_003_6bd0

    and c
    add b
    and e
    sub c
    inc sp
    or d
    add d
    sub b
    and b
    and b
    db $10
    inc de
    add b
    and l
    inc b
    sub e
    add a
    inc c
    inc bc
    add hl, bc
    adc c
    ld b, $04
    nop
    rla
    ld b, d
    add d
    inc bc
    rrca
    ld b, c
    add [hl]
    call nz, $c3c3
    add c
    add h
    inc b
    ld b, h
    add e
    inc bc
    add b
    ld l, c
    ld bc, $8222
    db $e3
    add b
    and c
    pop bc
    add b
    add e
    and c
    add c
    and b
    add b
    add e
    db $e3
    ld bc, $6498
    and b
    and b
    jr nc, jr_003_6c7d

jr_003_6c7d:
    ld [bc], a
    adc [hl]

jr_003_6c7f:
    rra
    add hl, bc
    add hl, bc
    jr nz, jr_003_6c8d

    and c
    jr nz, jr_003_6c10

    ld hl, $9e85
    dec c
    add l
    and c

jr_003_6c8d:
    adc l
    ld e, $85
    ld hl, $2185
    ld c, $0e
    inc bc
    ld c, $80
    ld a, [c]
    inc hl
    ld [hl], e
    add d
    ld [bc], a
    dec b
    dec b
    adc c
    dec d
    adc b
    ld hl, $0888
    add h
    add h
    add hl, bc
    sub l
    nop
    ret z

    call nz, $c080
    add b
    add b
    add l
    ret nz

    add b
    call nz, $0483
    sub c
    ld b, h
    sub c
    add h
    add h
    add e
    add h
    sub c
    call nz, $8491
    add h
    inc b
    rlca
    rlca
    ld de, $4712
    ld [$000b], sp

jr_003_6ccb:
    ld [bc], a
    or b
    ld bc, $0199
    nop
    add a
    rlca
    add d
    ld b, b
    inc b
    dec e
    dec b
    ld c, c
    inc b
    nop
    ld de, $1616
    ld a, [bc]
    nop
    ld b, [hl]
    ld h, b
    ld b, b
    ld [hl], b
    jr nc, jr_003_6d1b

    push de
    nop
    ld c, b
    inc d
    jr c, jr_003_6d55

    jr nz, jr_003_6c7f

    ld bc, $8287
    pop bc
    push hl
    and l
    add d
    ld b, d
    ld [c], a
    ld hl, $02a2
    inc hl
    ld b, b
    ld [$1b19], sp
    dec d
    inc d
    db $10
    ld a, [bc]
    nop
    ld l, b
    sub b
    ld bc, $a900
    ld c, d
    ld b, b
    bit 2, h
    add l
    ld [bc], a
    ret nz

    ld [de], a
    and $65
    and [hl]
    jp nz, $a1a5

    add d
    ld h, [hl]
    ld h, [hl]
    ld [bc], a

jr_003_6d1b:
    add b
    ret z

    ld sp, $d1f5
    ld d, c
    pop hl
    pop de
    nop
    jr z, jr_003_6ccb

    xor c
    and b
    cp c
    ld c, c
    nop
    ldh [$62], a
    inc b
    ld d, l
    ret nc

    ld c, h
    ld d, c
    ld sp, $8800
    xor b
    add d
    and $81
    add d
    add d
    and h
    ld b, d
    xor c
    add d
    add d
    xor c
    jp nz, $aa29

    ld [bc], a
    xor e
    ld [$44ea], a
    nop
    sbc [hl]
    inc h
    ld e, l
    daa
    inc hl
    add hl, hl
    dec d
    inc c
    ld c, $00
    ld c, l

jr_003_6d55:
    xor d
    xor c
    xor c
    ld a, [bc]
    ld a, [bc]
    xor d
    xor a
    ld a, [bc]
    ld a, [bc]
    or b
    xor e
    dec bc
    jr nz, jr_003_6dab

    adc l
    dec h
    sub h
    dec l
    add h
    ld e, l
    ld c, l
    inc a
    ld c, h
    nop
    ld a, $cd
    ld a, [hl-]
    jp nc, $d63e

    ld b, d
    jp c, $de46

    ld a, [hl+]
    jr z, jr_003_6d7a

jr_003_6d7a:
    ld b, h
    ld [hl], a
    rst $10
    ld [hl-], a
    push af
    nop
    rla
    scf
    ld d, a
    ld b, c
    and c
    ld d, l
    ld hl, $55b5
    ld [hl], c
    sub c
    or a
    ld d, a
    ld e, b
    pop bc
    rst $30
    ld d, a
    ld h, c
    jr jr_003_6dcc

    sbc b
    cp b
    cp b
    ld d, e
    ld hl, $0153
    ld hl, $4141
    sub d
    and b
    ld b, b
    ld b, c
    ld [hl-], a
    push de
    ld hl, sp+$58
    pop bc
    ret c

    ret c

    dec h
    nop

jr_003_6dab:
    ld b, a
    ret z

    ld bc, $2200
    push hl
    ld l, b
    jp hl


    ld h, l
    and $67
    add sp, $66
    rst $20
    inc b
    add b
    jr z, jr_003_6df9

    ld b, e
    dec hl
    jr z, jr_003_6e05

    ld c, e
    dec hl
    ld c, h
    daa
    add d
    ld h, e
    ld e, d
    add c
    ld e, d
    ld b, c
    and c

jr_003_6dcc:
    nop
    inc e
    ld bc, $a027
    ld d, h
    ld e, e
    ld d, e
    dec hl
    ld e, h
    ld e, [hl]
    ld d, [hl]
    ld e, e
    dec hl
    jr z, jr_003_6e04

    ld e, h
    and a
    ld [de], a
    ld [de], a
    xor $ef
    ld b, a
    inc b
    ld b, b
    ld d, d
    ld d, e
    dec b
    add b
    ld de, $2a48
    pop af
    db $10
    ld a, e
    nop
    ld [hl], b
    and l
    xor a
    cpl
    ld [$d48c], sp
    ld d, h
    push bc

jr_003_6df9:
    push bc
    ld l, h
    ld l, l
    ld a, l
    ld a, l
    rst $00
    call nc, Call_003_476d
    db $fd
    ld l, l

jr_003_6e04:
    ld a, l

jr_003_6e05:
    ld a, l
    call z, Call_003_6ecb
    db $fd
    ld c, e
    ld b, e
    ld a, l
    xor $ee
    adc h
    nop
    ld c, b
    ret nz

    pop hl
    ld c, $17
    nop
    inc b
    cp b
    ld a, [hl]
    or a
    ld a, [hl]
    or $b7
    ld a, $b7
    cp [hl]
    or a
    ld a, $b7
    inc hl
    db $ed
    db $76
    ld l, l
    xor d
    or c
    cp b
    cp [hl]
    or c
    or c
    ld b, l
    add d
    ld h, d
    ld [hl], b
    ld c, h
    db $eb
    adc a
    rrca
    add d
    adc e
    ret z

    inc bc
    add b
    ld d, e
    xor [hl]
    xor a

Call_003_6e3e:
    ld l, a
    ld a, [hl]
    adc [hl]
    xor [hl]
    ld a, a
    ld a, c
    sbc c
    xor [hl]
    cp [hl]
    nop
    adc b
    push af
    nop
    db $10
    add sp, -$49
    inc bc
    cp b
    or a
    inc bc
    or b
    or e
    cp e
    cp a
    jp $cfcb


    rst $00
    inc bc
    ret nc

    db $db
    inc bc
    call nc, Call_000_0003
    cp h
    ld e, e
    inc h
    ld [$ee00], sp
    pop af
    rlca
    ret nz

    ld bc, $019b
    nop
    inc bc
    ld de, $0513
    rlca
    dec b
    dec d
    add hl, bc
    dec bc
    rla
    add hl, de
    dec c
    rrca
    dec de
    dec e
    ld e, l
    ld e, l
    scf
    dec sp
    ld e, l
    ld e, l
    dec a
    ccf
    ld e, l
    ld e, l
    ld b, c
    ld b, e
    ld e, l
    ld e, l
    ld b, l
    ld b, a
    dec b
    adc a
    dec b
    sub l
    sub c
    ld c, e
    ld [bc], a
    ret nc

    add h
    nop
    adc $00
    adc $82
    rst $08
    pop de
    jp nc, $85d0

    db $d3
    adc h
    call nc, $d400
    nop
    xor [hl]
    xor [hl]
    sbc $df
    inc d
    add hl, bc
    sub h
    add c
    and e
    and b
    ldh a, [$0a]
    dec bc
    ld l, $6b
    ld [$9b5c], sp
    and l
    xor l
    or l
    dec h
    cpl
    scf
    inc b
    add $40
    cp e
    nop
    ld a, d
    dec b
    db $ed
    ld b, $ca
    ret nz

    ld d, c
    ld d, b

Call_003_6ecb:
    ret c

    push hl
    db $ed
    push af
    dec [hl]
    inc b
    sbc d
    db $fd
    ld [bc], a
    rlca
    add e
    ld [hl], e
    ld [hl], a
    dec de
    ld [bc], a
    ld b, e
    ld hl, $a810
    ld h, [hl]
    ld l, h
    ld a, [hl]
    ld e, [hl]
    ld e, l
    ld l, b
    call $d828
    inc l
    ret c

    xor h
    ld h, b
    xor d
    and b
    ld b, b
    ld e, d
    cp d
    reti


    ld c, c
    ld e, d
    ld [$49f9], a
    ld e, d
    ld a, [bc]
    ld a, [de]
    ld c, d
    ld e, d
    ld a, [hl+]
    ld a, [hl-]
    ld a, d
    ld a, [bc]
    ld [de], a
    ldh [$b9], a
    ld l, e
    db $ec
    ld h, b
    ld h, c
    jp Jump_003_46ec


    db $ed
    ld l, l
    call nc, $f054
    ld d, l
    sub $58
    reti


    sub $40
    push de
    call nz, $c847
    ld c, b
    ret


    ld c, c
    jp z, $cb4a

    ld c, e
    ld c, h
    adc a
    inc c
    adc [hl]
    add h
    call nz, Call_003_6625
    and l
    and l
    add h
    inc b
    ld [bc], a
    sub b
    ld c, b
    ld h, d
    sub d
    sub d
    add e
    db $e3
    ld [de], a
    di
    nop
    inc b
    inc e
    sub l
    sub [hl]
    inc e
    inc e
    sbc c
    sbc d
    ld [de], a
    adc a
    adc a
    inc e
    sub b
    ld [de], a
    inc e
    sub b
    sub c
    inc e
    ld [de], a

jr_003_6f49:
    sub c
    inc e
    sub d
    sub d
    ld [de], a
    call c, Call_000_0add
    ld a, [bc]
    dec de
    ld bc, $ea50
    ld c, $07
    rlca
    rla
    rlca
    rrca
    rra
    rlca
    daa
    ld d, a
    nop
    jr nc, jr_003_6f68

    jr jr_003_6f6a

jr_003_6f65:
    rst $28
    ld l, a
    db $f4

jr_003_6f68:
    db $f4
    ld [bc], a

jr_003_6f6a:
    ret nz

    and h
    sbc e
    sbc a
    dec hl
    ld l, b
    ld [hl], b
    ld [hl], a
    rrca
    rla
    ld a, e
    ld a, a
    xor e
    xor a
    ld a, e
    ld a, a
    ld [hl], e
    or e
    add e
    dec hl
    adc b
    dec hl
    inc c
    rla
    inc de
    or a
    sbc e
    cp e
    dec hl
    jr z, jr_003_6f65

    and $be
    db $eb
    jp nz, Jump_000_2b97

    jr z, jr_003_6f49

    cp d
    sub d
    sub a
    cp e
    cp d
    sbc d
    sbc a
    db $e3
    ld [$7792], a
    inc de
    dec de
    ld [hl], e
    sbc a
    rst $18
    add $e3
    ld [$04e6], a
    db $10
    db $e4
    dec d
    ld a, [bc]
    dec d
    jr jr_003_6fc2

    sub d
    sub a
    sbc c
    dec d
    and $f1
    di
    jp hl


    db $eb
    push af
    rst $30
    inc hl
    jp nz, Jump_000_0004

    ld bc, $a320
    ld a, c
    dec b
    dec b

jr_003_6fc2:
    ld a, [$057a]
    dec b
    ei
    ld a, e
    db $fc
    ld a, h
    add l
    ld a, a
    db $fd
    db $fd
    push hl
    inc h
    cp $fe
    ld h, l
    dec h
    ld a, a
    adc e
    nop
    add c
    ld [bc], a
    and b
    ld [bc], a
    ld [hl+], a
    ld d, e
    inc de
    ld h, e
    inc hl
    ret nz

    sub d
    ld [hl+], a
    ldh a, [$c8]
    add hl, hl
    call nc, $9efe
    cp a
    ld e, a
    ld b, c
    pop bc
    ld e, a
    ld b, c
    pop hl
    ld e, a
    ld bc, $3970
    add hl, bc
    ld h, b
    ld l, c
    ld e, c
    adc c
    xor c
    ld c, c
    ld bc, $d5d1
    dec d
    ld h, b
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

    call c, Call_003_4458
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
