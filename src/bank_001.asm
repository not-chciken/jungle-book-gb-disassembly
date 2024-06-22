; Disassembly of "jb.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

SECTION "ROM Bank $001", ROMX[$4000], BANK[$1]

    ld bc, $05e8
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_4010

    cp $05
    ret nz

    ld bc, $0188

jr_001_4010:
    add hl, bc
    ld de, $9c20
    ld bc, $0801
    jr jr_001_401f

    ld de, $9800
    ld b, $08
    ld c, b

jr_001_401f:
    push bc
    push de
    push hl

jr_001_4022:
    push bc
    push de
    ld a, [hl+]
    push hl
    ld b, $00
    add a
    rl b
    add a
    rl b
    ld c, a
    ld hl, $cb00
    add hl, bc
    push de
    call Call_001_4069
    inc de
    inc de
    call Call_001_4069
    pop de
    ld a, e
    add $40
    ld e, a
    jr nc, jr_001_4044

    inc d

jr_001_4044:
    call Call_001_4069
    inc de
    inc de
    call Call_001_4069
    pop hl
    pop de
    inc de
    inc de
    inc de
    inc de
    pop bc
    dec b
    jr nz, jr_001_4022

    pop hl
    ld a, [$c113]
    ld c, a
    add hl, bc
    pop de
    ld a, e
    add $80
    ld e, a
    jr nc, jr_001_4064

    inc d

jr_001_4064:
    pop bc
    dec c
    jr nz, jr_001_401f

    ret


Call_001_4069:
    push de
    ld a, [hl+]
    push hl
    ld b, $00
    add a
    rl b
    add a
    rl b
    ld c, a
    ld hl, $c700
    add hl, bc
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl+]
    ld [de], a
    dec de
    ld a, e
    add $20
    ld e, a
    jr nc, jr_001_4086

    inc d

jr_001_4086:
    ld a, [hl+]
    ld [de], a
    inc de
    ld a, [hl]
    ld [de], a
    pop hl
    pop de
    ret


    ld d, $0c
    ld a, [NextLevel]
    ld e, a
    cp $0b
    jr nz, jr_001_409a

    ld d, $20

jr_001_409a:
    ld a, [$c113]
    ld b, $00
    add a
    rl b
    swap b
    swap a
    ld c, a
    and $0f
    or b
    ld b, a
    ld a, c
    and $f0
    ld c, a
    ld a, e
    cp $0a
    jr nz, jr_001_40b9

    ld a, c
    sub $18
    ld c, a
    dec b

jr_001_40b9:
    ld a, c
    sub d
    ld [$c14d], a
    ld a, b
    sbc $00
    ld [$c14e], a
    ld a, e
    cp $0c
    jr nz, jr_001_40cd

    xor a
    ld b, a
    jr jr_001_40d3

jr_001_40cd:
    ld a, c
    sub $a0
    jr nc, jr_001_40d3

    dec b

jr_001_40d3:
    ld [$c1d0], a
    ld a, b
    ld [$c1d1], a
    ld a, [$c114]
    add a
    swap a
    ld c, a
    and $0f
    ld b, a
    ld a, c
    and $f0
    ld c, a
    ld [$c14f], a
    ld a, b
    ld [$c150], a
    ld a, c
    sub $78
    jr nc, jr_001_40f5

    dec b

jr_001_40f5:
    ld [$c1d4], a
    ld a, b
    ld [$c1d5], a
    ld a, d
    inc a
    ld [$c14b], a
    xor a
    ld [$c14c], a
    ld [$c1d2], a
    ld [$c1d3], a
    ret


    ld hl, DigitMinutes
    ld a, [hl-]
    ld e, $d0
    call Call_001_4125
    ld a, [hl-]
    ld e, $d2
    call Call_001_4125
    ld a, [hl]
    ld e, $d3
    jr jr_001_4125

    ld a, [CurrentLives]
    ld e, $c3

Call_001_4125:
jr_001_4125:
    ld d, $9c
    add $d8
    ld c, a
    call Call_001_4137
    add $0a
    ld c, a
    ld a, e
    add $20
    ld e, a
    jr nc, jr_001_4137

    inc d

Call_001_4137:
jr_001_4137:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_4137

    ld a, c
    ld [de], a
    ret


Call_001_4140:
    ld a, [NumDiamondsMissing]
    or a
    jr z, jr_001_414b

    dec a
    daa
    ld [NumDiamondsMissing], a

jr_001_414b:
    push af
    call Call_001_4151
    pop af
    ret


Call_001_4151:
    ld a, [NumDiamondsMissing]
    ld e, $e6
    jr jr_001_416a

Jump_001_4158:
    ld a, [WeaponSelect]
    or a
    jr nz, jr_001_4162

    ld a, $99
    jr jr_001_4168

jr_001_4162:
    ld hl, AmmoBase
    add l
    ld l, a
    ld a, [hl]

jr_001_4168:
    ld e, $ea

Call_001_416a:
jr_001_416a:
    ld d, $9c
    ld b, a
    and $f0
    swap a
    call Call_001_4178
    inc e
    ld a, b
    and $0f

Call_001_4178:
    add $ce
    ld c, a

jr_001_417b:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_417b

    ld a, c
    ld [de], a
    ret


    ld a, [$c1ca]
    or a
    ret nz

    ld a, [$c14a]
    or a
    ret nz

    ld a, [$c1c2]
    inc a
    cp $3c
    jr c, jr_001_41e6

Call_001_4196:
    ld a, [FirstDigitSeconds]
    dec a
    bit 7, a
    jr z, jr_001_41d2

    ld a, [SecondDigitSeconds]
    dec a
    bit 7, a
    jr z, jr_001_41c8

    ld a, [DigitMinutes]
    dec a
    bit 7, a
    jr z, jr_001_41be

    ld a, [$c1e5]
    or a
    ret nz

    ld a, [NextLevel]
    cp $0b
    jp z, Jump_001_5fbd

    jp Jump_000_1612


jr_001_41be:
    ld [DigitMinutes], a
    ld e, $d0
    call Call_001_4125
    ld a, $05

jr_001_41c8:
    ld [SecondDigitSeconds], a
    ld e, $d2
    call Call_001_4125
    ld a, $09

jr_001_41d2:
    ld [FirstDigitSeconds], a
    ld e, $d3
    call Call_001_4125
    ld a, [$c1e5]
    or a
    jr z, jr_001_41e2

    xor a
    ret


jr_001_41e2:
    call Call_000_2371
    xor a

jr_001_41e6:
    ld [$c1c2], a
    ret nz

    ld a, [WeaponSelect]
    cp $04
    ret nz

    ld a, [CurrentSecondsInvincibility]
    or a
    ret z

    dec a
    daa
    ld [CurrentSecondsInvincibility], a
    jr z, jr_001_4207

    ld a, [InvincibilityTimer]
    or a
    jp nz, Jump_001_4158

    ld a, $ff
    jr jr_001_4209

jr_001_4207:
    ld a, $0f

jr_001_4209:
    ld [InvincibilityTimer], a
    jp Jump_001_4158


Call_001_420f:
    push hl
    ld hl, CurrentScore3
    ld b, $03
    jr jr_001_421d

    push hl
    ld hl, CurrentScore2
    ld b, $02

jr_001_421d:
    and a

jr_001_421e:
    adc [hl]
    daa
    ld [hl-], a
    jr nc, jr_001_4228

    ld a, $00
    dec b
    jr nz, jr_001_421e

jr_001_4228:
    pop hl
    push hl
    ld hl, CurrentScore1
    ld e, $c5
    ld b, $03

jr_001_4231:
    ld a, [hl+]
    push bc
    call Call_001_416a
    pop bc
    inc e
    dec b
    jr nz, jr_001_4231

    pop hl
    ret


    bit 1, b
    ret z

    bit 2, b
    ret nz

    ld a, [$c17f]
    and $0f
    jp nz, Jump_001_449c

    ld a, [$c181]
    or a
    ret nz

    ld [$c17a], a
    ld a, [$c178]
    dec a
    jr nz, jr_001_425c

    ld [$c178], a

jr_001_425c:
    ld a, [$c182]
    cp $03
    ld a, $01
    jr z, jr_001_4266

    xor a

jr_001_4266:
    ld [$c501], a
    ld a, b
    and $f0
    swap a
    ld [AmmoBase], a
    ld c, a
    and $0c
    jr nz, jr_001_427c

    ld [$c179], a
    ld [$c152], a

jr_001_427c:
    ld a, [$c149]
    or a
    jr nz, jr_001_42eb

    ld a, [$c172]
    or a
    jp nz, Jump_001_42eb

    ld a, [$c16f]
    or a
    jp nz, Jump_001_42eb

    ld a, [$c169]
    or a
    jp nz, Jump_001_42eb

    ld a, [$c15b]
    and $01
    jp nz, Jump_001_42eb

    xor a
    ld [$c154], a
    ld [$c151], a
    dec a
    ld [$c181], a
    ld a, [$c18d]
    ld [$c18e], a
    ret


    ld a, [$c181]
    or a
    ret z

    ld a, [$c151]
    inc a
    and $07
    ld [$c151], a
    ret nz

    ld a, [$c154]
    inc a
    and $01
    ld [$c154], a
    jr nz, jr_001_42d4

    ld [$c181], a
    ld a, [$c18e]
    jp Jump_001_44f2


jr_001_42d4:
    ld a, [AmmoBase]
    ld b, $00
    ld c, a
    ld hl, $676c
    ld a, [$c182]
    cp $03
    jr nz, jr_001_42e6

    ld l, $77

jr_001_42e6:
    add hl, bc
    ld a, [hl]
    ld [$c18d], a

Jump_001_42eb:
jr_001_42eb:
    ld a, [$c182]
    cp $01
    jr nz, jr_001_4322

    ld hl, $c300
    bit 7, [hl]
    jr nz, jr_001_4300

    ld l, $40
    bit 7, [hl]
    jp z, Jump_001_449c

jr_001_4300:
    ld de, $6735
    ld a, [AmmoBase]
    add a
    add a
    add e
    ld e, a
    ld b, $02
    ld c, $00

jr_001_430e:
    push bc
    call Call_001_43d8
    ld a, l
    add $20
    ld l, a
    pop bc
    ld c, $02
    dec b
    jr nz, jr_001_430e

    ld hl, CurrentNumDoubleBanana
    jp Jump_001_43cc


jr_001_4322:
    ld de, $6741
    ld c, $00
    ld hl, $c300
    bit 7, [hl]
    jr nz, jr_001_4335

    ld l, $20
    bit 7, [hl]
    jp z, Jump_001_449c

jr_001_4335:
    or a
    jp z, Jump_001_43d8

    cp $02
    jr z, jr_001_434e

    call Call_001_43d8
    ld [hl], $00
    ld a, $94
    rst $10
    ld c, $0b
    xor a
    rst $10
    ld hl, CurrentNumStones
    jr jr_001_43cc

jr_001_434e:
    call Call_001_43d8
    set 0, [hl]
    push hl
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [AmmoBase]
    cp $04
    jr z, jr_001_436f

    ld a, [$c146]
    ld bc, $0050
    and $80
    jr z, jr_001_436e

    ld bc, $ffb0

jr_001_436e:
    add hl, bc

jr_001_436f:
    ld d, h
    ld e, l
    pop hl
    ld a, e
    ld c, $13
    rst $10
    ld a, d
    inc c
    rst $10
    ld a, [AmmoBase]
    cp $08
    jr nz, jr_001_4381

    xor a

jr_001_4381:
    ld c, $15
    rst $10
    push hl
    ld hl, $6761
    ld b, $00
    ld c, a
    add hl, bc
    ld c, [hl]
    bit 7, c
    jr z, jr_001_4392

    dec b

jr_001_4392:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld d, h
    ld e, l
    pop hl
    ld a, e
    ld c, $10
    rst $10
    ld a, d
    inc c
    rst $10
    ld a, $44
    ld c, $0e
    rst $10
    ld c, $15
    rst $08
    cp $04
    jr nc, jr_001_43bb

    ld a, $01
    ld c, $08
    rst $10
    ld a, $88
    ld c, $0a
    rst $10
    jr jr_001_43c9

jr_001_43bb:
    cp $04
    jr nz, jr_001_43c9

    ld a, $0f
    ld c, $07
    rst $10
    ld a, $88
    ld c, $09
    rst $10

jr_001_43c9:
    ld hl, CurrentNumBoomerang

Jump_001_43cc:
jr_001_43cc:
    ld a, [hl]
    dec a
    daa
    ld [hl], a
    jr nz, jr_001_43d5

    ld [$c182], a

jr_001_43d5:
    jp Jump_001_4158


Call_001_43d8:
Jump_001_43d8:
    ld [hl], $04
    ld a, c
    ld c, $0d
    rst $10
    dec c
    ld a, $01
    rst $10
    ld c, $0f
    rst $10
    ld c, $01
    ld a, [$c17d]
    or a
    jr z, jr_001_43f2

    inc c
    inc a
    jr nz, jr_001_43f2

    inc c

jr_001_43f2:
    ld a, [AmmoBase]
    ld b, a
    and $03
    jr nz, jr_001_43fe

    bit 2, b
    jr nz, jr_001_440a

jr_001_43fe:
    ld a, [$c146]
    add a
    bit 7, a
    jr nz, jr_001_4409

    add c
    jr jr_001_440a

jr_001_4409:
    sub c

jr_001_440a:
    ld c, $07
    push af
    and $0f
    push bc
    rst $10
    pop bc
    ld a, b
    and $04
    jr z, jr_001_4420

    ld a, b
    and $03
    ld a, $fd
    jr z, jr_001_4420

    ld a, $fe

jr_001_4420:
    push bc
    inc c
    rst $10
    ld a, $11
    inc c
    rst $10
    inc c
    rst $10
    inc c
    ld a, $02
    rst $10
    pop bc
    bit 2, b
    ld b, $18
    jr nz, jr_001_443e

    ld b, $04
    ld a, [$c177]
    or a
    jr nz, jr_001_443e

    ld b, $10

jr_001_443e:
    ld a, [de]
    inc de
    add b
    ld b, a

Call_001_4442:
    ld a, [PlayerPositionYLsb]
    sub b
    push af
    ld c, $01
    rst $10
    pop af
    ld a, [PlayerPositionYMsb]
    sbc $00
    inc c
    rst $10
    pop af
    or a
    jr z, jr_001_445e

    ld b, $fc
    bit 7, a
    jr nz, jr_001_445e

    ld b, $04

jr_001_445e:
    ld a, [de]
    inc de
    add b
    ld b, a
    ld a, [PlayerPositionXLsb]
    add b
    bit 7, b
    jr z, jr_001_446b

    ccf

jr_001_446b:
    ld b, $00
    jr nc, jr_001_4475

    ld b, $01
    jr z, jr_001_4475

    ld b, $ff

jr_001_4475:
    inc c
    push bc
    rst $10
    pop bc
    ld a, [PlayerPositionXMsb]
    add b
    inc c
    rst $10
    inc c
    ld a, $95
    rst $10
    inc c
    ld a, $90
    rst $10
    dec c
    ld a, [$c182]
    or a
    ret nz

    ld a, [WeaponSelect]
    cp $04
    jr nz, jr_001_4499

    ld a, [CurrentSecondsInvincibility]
    or a
    ret nz

jr_001_4499:
    jp Jump_000_0fc3


Jump_001_449c:
    ld a, [$c155]
    and $fd
    ld [$c155], a
    ret


    ld a, [$c16f]
    or a
    ret nz

    ld a, [$c172]
    or a
    ret nz

    ld a, [$c17d]
    inc a
    jr z, jr_001_44d4

    ld a, [$c151]
    inc a
    cp c
    jr c, jr_001_44bd

    xor a

jr_001_44bd:
    ld [$c151], a
    ret nz

    ld a, [$c154]
    cp $02
    jr c, jr_001_44cd

    inc a
    cp $0a
    jr c, jr_001_44cf

jr_001_44cd:
    ld a, $02

jr_001_44cf:
    ld [$c154], a
    jr jr_001_44f2

jr_001_44d4:
    ld a, [$c151]
    inc a
    cp $04
    jr c, jr_001_44dd

    xor a

jr_001_44dd:
    ld [$c151], a
    ret nz

    ld a, [$c154]
    cp $0a
    jr c, jr_001_44ed

    inc a
    cp $16
    jr c, jr_001_44ef

jr_001_44ed:
    ld a, $0a

jr_001_44ef:
    ld [$c154], a

Jump_001_44f2:
jr_001_44f2:
    ld [$c18d], a
    ret


    ld a, [$c151]
    inc a
    and $03
    ld [$c151], a
    ret nz

    ld a, [$c154]
    add c
    bit 7, a
    jr z, jr_001_450c

    ld a, $0b
    jr jr_001_4511

jr_001_450c:
    cp $0c
    jr c, jr_001_4511

    xor a

jr_001_4511:
    ld [$c154], a
    ld c, a
    cp $06
    jr c, jr_001_451b

    sub $06

jr_001_451b:
    add $4b
    ld [$c18d], a
    ld a, c
    cp $06
    ld a, $01
    jr c, jr_001_4529

    ld a, $ff

jr_001_4529:
    ld [$c147], a
    ret


    ld a, [$c177]
    or a
    ret nz

    ld a, [$c172]
    or a
    ret nz

    ld a, [$c17f]
    and $0f
    ret nz

    ld a, [$c178]
    or a
    jr nz, jr_001_454a

    ld [$c179], a
    dec a
    ld [$c178], a

jr_001_454a:
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_455b

    ld a, [$c179]
    cp $07
    ret z

    ld a, $07
    jr jr_001_4562

jr_001_455b:
    ld a, [$c179]
    inc a
    cp $10
    ret nc

jr_001_4562:
    ld [$c179], a
    call TrippleShiftRightCarry
    ld hl, $633a
    jr jr_001_45e1

Jump_001_456d:
    ld a, [JoyPadData]
    and $40
    ret nz

    ld a, [$c178]
    dec a
    ret z

    ld a, [$c179]
    or a
    jr z, jr_001_4581

    dec a
    jr nz, jr_001_4562

jr_001_4581:
    jp Jump_001_463b


    ld a, [$c175]
    or a
    ret nz

    ld a, [$c177]
    or a
    jr nz, jr_001_45a3

    ld a, [JoyPadData]
    and $30
    ret nz

    ld [$c154], a
    ld [$c152], a
    ld [$c153], a
    dec a
    ld [$c177], a
    ret


jr_001_45a3:
    ld a, [$c152]
    ld c, a
    inc a
    cp $10
    jr c, jr_001_45e9

    ld a, [$c17a]
    inc a
    ld [$c17a], a
    cp $0c
    ld a, c
    jr c, jr_001_45e9

    ld a, $0c
    ld [$c17a], a
    ld a, [$c178]
    or a
    jr nz, jr_001_45ca

    ld [$c153], a
    inc a
    ld [$c178], a

jr_001_45ca:
    ld a, [$c153]
    inc a
    and $1f
    ld [$c153], a
    ret nz

    ld a, [$c154]
    inc a
    and $01
    ld [$c154], a
    inc a
    ld hl, $6337

jr_001_45e1:
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    jp Jump_001_44f2


jr_001_45e9:
    ld [$c152], a
    call TrippleShiftRightCarry
    ld b, $00
    ld c, a
    ld hl, $6335
    add hl, bc
    ld a, [hl]
    ld [$c18d], a
    cp $3c
    ret nz

    ld b, $30
    call Call_000_1523
    ret nc

    ld a, c

Jump_001_4604:
    cp $1e
    jr z, jr_001_4612

Jump_001_4608:
    ld a, [NextLevel]
    cp $0a
    ret nz

    ld a, c
    cp $c1
    ret nz

jr_001_4612:
    ld a, [PlayerPositionYLsb]
    add $20
    ld [PlayerPositionYLsb], a
    ld a, [PlayerPositionYMsb]
    adc $00
    ld [PlayerPositionYMsb], a
    ld de, $0014
    call Call_001_4ae0
    ret


jr_001_4629:
    ld a, [JoyPadData]
    and $80
    ret nz

    ld a, [$c152]
    or a
    jr z, jr_001_4638

    dec a
    jr nz, jr_001_45e9

jr_001_4638:
    ld [$c177], a

Jump_001_463b:
    ld [$c178], a
    ld [$c17a], a
    ld c, a
    jp Jump_001_46cb


    ld a, [$c15b]
    and $01
    ret nz

    ld a, [$c1e5]
    and $df
    cp $06
    ret z

    and $01
    ret nz

    ld a, [$c169]
    or a
    ret nz

    ld a, [$c181]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [$c177]
    or a
    jr nz, jr_001_4629

    ld a, [$c178]
    or a
    jp nz, Jump_001_456d

    ld a, [JoyPadData]
    and $30
    jr z, jr_001_468c

    ld a, [$c1ca]
    or a
    jr nz, jr_001_468c

    ld a, [$c17f]
    and $0f
    jp nz, Jump_001_471f

    xor a
    ld [$c17b], a
    ret


jr_001_468c:
    ld a, [$c172]
    or a
    jp nz, Jump_001_4739

    ld a, [$c16f]
    or a
    jp nz, Jump_001_4739

    call Call_001_46a0
    xor a
    inc a
    ret


Call_001_46a0:
    call Call_000_165e
    ld a, [$c156]
    cp $02
    jr z, jr_001_470e

    cp $03
    jr z, jr_001_470e

    cp $0a
    jr z, jr_001_470a

    cp $0b
    jr z, jr_001_470a

    ld a, [$c17f]
    or a
    jr nz, jr_001_471f

    ld a, [$c17d]
    and $80
    jr nz, jr_001_471f

    ld c, $00
    ld a, [$c149]
    or a
    jr z, jr_001_46ed

Call_001_46cb:
Jump_001_46cb:
jr_001_46cb:
    xor a
    ld [$c149], a
    ld [$c151], a
    ld [$c17d], a
    ld [$c17e], a
    ld [$c17f], a
    ld [$c169], a
    ld [$c173], a
    ld [$c174], a
    dec a
    ld [$c15c], a
    xor a
    add c
    jp Jump_001_44f2


jr_001_46ed:
    ld c, $01
    ld a, [TimeCounter]
    and $7f
    ret nz

    ld a, [$c17b]
    inc a
    ld [$c17b], a
    cp $02
    jr z, jr_001_46cb

    cp $03
    ret nz

    xor a
    ld [$c17b], a
    ld c, a
    jr jr_001_46cb

jr_001_470a:
    ld a, $01
    jr jr_001_4710

jr_001_470e:
    ld a, $ff

jr_001_4710:
    ld [$c180], a
    ld [$c146], a
    ld a, $0c
    ld [$c17f], a
    ld a, $03
    jr jr_001_4741

Jump_001_471f:
jr_001_471f:
    ld a, [$c17f]
    dec a
    ld [$c17f], a
    call TrippleShiftRightCarry
    ld c, $00
    jr nz, jr_001_4741

    ld a, [$c172]
    or a
    jr nz, jr_001_4739

    ld a, [$c16f]
    or a
    jr z, jr_001_46cb

Jump_001_4739:
jr_001_4739:
    xor a
    ld [$c17d], a
    ld [$c17f], a
    ret


jr_001_4741:
    ld b, $00
    ld c, a
    ld a, [$c172]
    or a
    jr nz, jr_001_476d

    ld a, [$c16f]
    or a
    jr nz, jr_001_476d

    ld a, [TimeCounter]
    rra
    jr nc, jr_001_475b

    ld a, $10
    ld [$c501], a

jr_001_475b:
    ld hl, $638a
    ld a, [JoyPadData]
    and $30
    jr nz, jr_001_4768

    ld hl, $638e

jr_001_4768:
    add hl, bc
    ld a, [hl]
    ld [$c18d], a

jr_001_476d:
    ld a, c
    cp $02
    jr nz, jr_001_4779

    ld a, $80
    ld [$c17d], a
    jr jr_001_4782

jr_001_4779:
    cp $01
    jr nz, jr_001_4782

    ld a, [TimeCounter]
    rra
    ret c

jr_001_4782:
    ld a, [$c180]
    and $80
    jp nz, Jump_000_094a

    jp Jump_000_085e


    ld a, [$c172]
    or a
    ret nz

    ld a, [$c16f]
    or a
    ret nz

    ld a, [$c149]
    cp $01
    ret z

    xor a
    ld [$c151], a
    ld [$c17e], a
    inc a
    ld [$c17d], a
    ld [$c149], a
    inc a
    ld [$c154], a
    jp Jump_001_44f2


Call_001_47b2:
Jump_001_47b2:
    xor a
    ld [$c170], a
    ld [$c169], a
    ld [$c13e], a
    dec a
    ld [$c16f], a
    ld a, $02
    ld [$c149], a
    dec a
    ld [$c151], a
    jp Jump_000_1aeb


Jump_001_47cc:
    ld a, [$c16f]
    or a
    ret z

    inc a
    ret z

    xor a
    ld [$c16f], a
    ld [$c170], a
    ld c, a
    jp Jump_001_46cb


    ld a, [$c149]
    cp $03
    ret z

    xor a
    ld [$c151], a
    ld [$c154], a
    ld a, $03
    ld [$c149], a
    ld a, $4b
    jp Jump_001_44f2


    bit 0, b
    ret z

    ld a, [$c1e2]
    or a
    ret z

    ld a, [$c1df]
    or a
    ret nz

Call_001_4802:
    ld a, [$c1ca]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [$c172]
    or a
    jr nz, jr_001_4878

    ld a, [$c16f]
    or a
    jr nz, jr_001_4878

    ld a, [$c15b]
    rra
    jp c, Jump_001_48a0

    ld a, [$c169]
    or a
    jr nz, jr_001_48a0

    ld a, [$c15b]
    and $04
    ld [$c15b], a
    ld a, $02
    ld [$c501], a
    ld a, $0f
    ld [$c172], a
    ld a, $2b
    call Call_001_4896
    ld [$c156], a
    ld [$c13e], a
    ld [$c152], a
    ld [$c153], a
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_486c

    ld a, [$c17d]
    inc a
    jr z, jr_001_4864

    ld a, [$c17c]
    or a
    jr z, jr_001_486a

jr_001_485b:
    cp $02
    jr z, jr_001_486c

    inc a
    ld [$c174], a
    ret


jr_001_4864:
    ld a, [$c17c]
    or a
    jr nz, jr_001_485b

jr_001_486a:
    ld a, $01

jr_001_486c:
    ld [$c174], a
    cp $01
    ret nz

    ld a, $1f
    ld [$c173], a
    ret


jr_001_4878:
    ld a, [$c155]
    and $fe
    ld [$c155], a
    ret


Call_001_4881:
    ld a, $f0
    ld [$c172], a
    ld a, $04
    ld [$c501], a
    ld a, [NextLevel]
    cp $0b
    ld a, $39
    jr z, jr_001_4896

    ld a, $49

Call_001_4896:
jr_001_4896:
    ld [$c173], a
    xor a
    ld [$c149], a
    jp Jump_001_4ba9


Jump_001_48a0:
jr_001_48a0:
    ld a, [$c169]
    or a
    jr z, jr_001_48b4

    ld a, $80
    ld [$c169], a
    xor a
    ld [$c16b], a
    ld [$c16c], a
    ld c, $05

jr_001_48b4:
    ld a, [$c146]
    ld d, a
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_4917

    ld b, a
    ld d, $01
    bit 4, b
    jr nz, jr_001_48c8

    ld d, $ff

jr_001_48c8:
    ld a, [$c169]
    or a
    jr nz, jr_001_48dd

    ld a, [$c15b]
    cp $03
    jr nz, jr_001_4917

    ld a, [$c164]
    sub $04
    jr c, jr_001_4917

    ld c, a

jr_001_48dd:
    ld a, [$c15e]
    bit 4, b
    jr nz, jr_001_48ea

    cp $03
    jr nc, jr_001_4917

    jr jr_001_48ee

jr_001_48ea:
    cp $04
    jr c, jr_001_4917

jr_001_48ee:
    ld a, [$c169]
    or a
    jr nz, jr_001_48f9

    ld a, $04
    ld [$c15b], a

jr_001_48f9:
    ld a, $0f
    ld [$c172], a
    ld a, $03
    ld [$c174], a
    xor a
    ld [$c149], a
    ld b, a
    ld hl, $6127
    add hl, bc
    ld a, [hl]
    ld [$c173], a
    ld a, [$c169]
    or a
    ret nz

    jr jr_001_4931

jr_001_4917:
    xor a
    ld [$c170], a
    dec a
    ld [$c16f], a
    ld a, $06
    ld [$c149], a
    ld a, [$c15b]
    or a
    ret z

    inc a
    and $04
    ld [$c15b], a
    jr z, jr_001_4937

jr_001_4931:
    ld a, [$c164]
    cp $04
    ret nc

jr_001_4937:
    ld a, [$c169]
    or a
    ret nz

    ld hl, $c165
    ld a, [hl+]
    ld h, [hl]
    and $f8
    ld l, a
    dec hl
    dec hl
    dec hl
    dec hl
    ld bc, $0014
    ld a, d
    and $80
    jr nz, jr_001_4951

    add hl, bc

jr_001_4951:
    ld a, l
    ld [PlayerPositionXLsb], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ret


    ld a, [$c172]
    and $0f
    jp z, Jump_001_4a03

    ld a, [JoyPadData]
    ld c, a
    ld a, [$c173]
    ld b, a
    ld a, [$c17c]
    or a
    ld a, b
    jr nz, jr_001_497e

    cp $20
    jr nz, jr_001_497e

    bit 0, c
    jr nz, jr_001_497e

    ld a, $0c
    ld [$c173], a

jr_001_497e:
    srl a
    ld c, a
    ld a, $15
    sub c
    ld b, $00
    ld c, a
    ld a, [$c174]
    add a
    ld d, $00
    ld e, a
    ld hl, $633c
    add hl, de
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, [hl]
    ld [$c18d], a
    ld hl, $6344
    srl e
    add hl, de
    ld a, [$c173]
    or a
    jp z, Jump_001_4a43

    dec a
    ld [$c173], a
    srl a
    cp [hl]
    ret nc

    srl a
    srl a
    jr nz, jr_001_49be

    ld a, [$c174]
    or a
    jp z, Jump_001_4a43

    ld a, $01

jr_001_49be:
    cp $05
    jr c, jr_001_49c4

    ld a, $04

jr_001_49c4:
    call Call_001_4a3a
    call Call_000_1aeb
    ld a, [$c15b]
    or a
    ret nz

    ld a, [$c173]
    cp $12
    ret nc

    ld a, [PlayerPositionYMsb]
    or a
    jr nz, jr_001_49e1

    ld a, [PlayerPositionYLsb]
    cp $20
    ret c

jr_001_49e1:
    call Call_000_151d
    ld de, $ffe0
    jr c, jr_001_49ff

    call Call_000_1521
    ret nc

    ld a, c
    cp $1e
    jr z, jr_001_49fc

    ld a, [NextLevel]
    cp $0a
    ret nz

    ld a, c
    cp $c1
    ret nz

jr_001_49fc:
    ld de, $fff0

jr_001_49ff:
    call Call_001_4a6d
    ret


Jump_001_4a03:
    ld a, [$c172]
    and $f0
    ret z

    ld a, [$c173]
    srl a
    srl a
    ld c, a
    ld a, $15
    sub c
    ld b, $00
    ld c, a
    ld hl, $6348
    add hl, bc
    ld a, [hl]
    ld [$c18d], a
    ld a, [$c173]
    or a
    jr z, jr_001_4a43

    dec a
    ld [$c173], a
    srl a
    srl a
    cp $12
    ret nc

    srl a
    inc a
    inc a
    cp $09
    jr c, jr_001_4a3a

    ld a, $08

Call_001_4a3a:
jr_001_4a3a:
    push af
    call Call_000_0e26
    pop af
    dec a
    jr nz, jr_001_4a3a

    ret


Jump_001_4a43:
jr_001_4a43:
    ld [$c172], a
    jp Jump_001_47b2


    ld a, [$c175]
    or a
    ret z

    dec a
    ld [$c175], a
    srl a
    srl a
    jr z, jr_001_4a62

    call Call_001_4a3a
    ld a, [$c1c9]
    or a
    jp nz, Jump_001_4e4e

jr_001_4a62:
    ld a, [$c176]
    and $80
    jp nz, Jump_000_094a

    jp Jump_000_085e


Call_001_4a6d:
    ld a, c
    cp $1e
    jr z, jr_001_4ae0

    cp $c1
    jr z, jr_001_4ae0

    ld c, $3f
    cp $c7
    jr c, jr_001_4a7e

    ld c, $c7

jr_001_4a7e:
    sub c
    add a
    add a
    ld c, a
    ld d, a
    xor a
    call Call_001_4ba0
    ld b, a
    dec a
    ld [$c15c], a
    ld a, $01
    ld [$c169], a
    ld hl, $61ff
    add hl, bc
    ld a, [PlayerPositionXLsb]
    ld e, a
    ld c, $02
    and $0f
    cp $04
    jr c, jr_001_4ab5

    inc b
    ld c, $06
    inc hl
    cp $08
    jr c, jr_001_4ab5

    inc b
    ld c, $0a
    inc hl
    cp $0c
    jr c, jr_001_4ab5

    inc b
    ld c, $0e
    inc hl

jr_001_4ab5:
    ld a, e
    and $f0
    add c
    ld [PlayerPositionXLsb], a
    ld a, [PlayerPositionYLsb]
    and $f0
    add [hl]
    ld [PlayerPositionYLsb], a
    ld a, d
    add b
    ld [$c16a], a
    ld a, $26
    ld [$c18d], a
    ld a, $03
    ld [$c15e], a
    inc a
    ld [$c15f], a
    ld a, [$c146]
    ld [$c160], a
    pop bc
    ret


Call_001_4ae0:
jr_001_4ae0:
    ld hl, PlayerPositionXLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld bc, $fff8
    add hl, bc
    ld a, l
    and $f0
    bit 4, a
    ret nz

    add $0e
    ld l, a
    ld [PlayerPositionXLsb], a
    ld [$c165], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ld [$c166], a
    push hl
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld [$c167], a
    ld a, h
    ld [$c168], a
    add hl, de
    ld a, h
    and $0f
    swap a
    ld d, a
    ld a, l
    and $f0
    swap a
    or d
    ld d, a
    pop hl
    srl h
    rr l
    ld a, h
    and $0f
    swap a
    ld e, a
    ld a, l
    and $f0
    swap a
    or e
    ld e, a
    ld hl, $c1da
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld a, [$c1d6]
    ld b, a
    ld c, a

jr_001_4b39:
    ld a, [hl+]
    cp e
    jr nz, jr_001_4b48

    ld a, [hl]
    cp d
    jr z, jr_001_4b4d

    jr nc, jr_001_4b48

    add $05
    cp d
    jr nc, jr_001_4b4d

jr_001_4b48:
    inc hl
    dec b
    jr nz, jr_001_4b39

    ret


jr_001_4b4d:
    ld a, c
    sub b
    ld c, a
    ld a, [$c15c]
    cp c
    ret z

    ld a, c
    call Call_000_2382
    ret nz

    ld a, c
    ld [$c15c], a
    call Call_001_4b96
    inc a
    ld [$c15b], a
    pop bc
    ld a, [PlayerPositionYLsb]
    and $0f
    srl a
    srl a
    ld e, a
    ld a, [hl]
    add a
    ld [$c15d], a
    ld a, d
    sub [hl]
    jr c, jr_001_4b8c

    add a
    add a
    or e
    cp $10
    jr c, jr_001_4b82

    ld a, $0f

jr_001_4b82:
    ld [$c164], a
    ld a, [JoyPadData]
    and $30
    jr nz, jr_001_4bb9

jr_001_4b8c:
    ld a, $03
    ld [$c149], a
    ld a, $4b
    jp Jump_001_44f2


Call_001_4b96:
    xor a
    ld [$c15b], a
    ld [$c169], a
    ld [$c164], a

Call_001_4ba0:
    ld [$c17f], a
    ld [$c17d], a
    ld [$c172], a

Jump_001_4ba9:
    ld [$c174], a
    ld [$c16f], a
    ld [$c170], a
    ld [$c177], a
    ld [$c178], a
    ret


jr_001_4bb9:
    ld a, [$c15c]
    add a
    add a
    add a
    ld b, $00
    ld c, a
    ld a, $03
    ld [$c15b], a
    ld [$c15e], a
    ld [$c163], a
    inc a
    ld [$c149], a
    ld a, [$c1d7]
    inc a
    and $01
    ld [$c1d7], a
    ld de, $c1d8
    add e
    ld e, a
    ld hl, $c660
    add hl, bc
    ld a, l
    ld [de], a
    set 7, [hl]
    inc l
    inc l
    inc l
    ld a, [$c146]
    ld [hl], a
    ld a, $26
    jp Jump_001_44f2


    ld a, [$c145]
    cp $c8
    ret nc

    ld a, [$c1e5]
    or a
    ret nz

    ld a, [$c172]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [$c15b]
    and $01
    ret nz

    ld a, [$c169]
    and $7f
    ret nz

    ld a, [PlayerPositionYMsb]
    or a
    jr nz, jr_001_4c21

    ld a, [PlayerPositionYLsb]
    cp $20
    jr c, jr_001_4c4b

jr_001_4c21:
    ld a, [$c16f]
    inc a
    jr nz, jr_001_4c4b

    call Call_000_151d
    ld de, $ffe0
    jr c, jr_001_4c48

    call Call_000_1521
    jr nc, jr_001_4c4b

    ld a, c
    cp $1e
    jr z, jr_001_4c45

    ld a, [NextLevel]
    cp $0a
    jr nz, jr_001_4c4b

    ld a, c
    cp $c1
    jr nz, jr_001_4c4b

jr_001_4c45:
    ld de, $fff0

jr_001_4c48:
    call Call_001_4a6d

jr_001_4c4b:
    call Call_000_165e
    jp nc, Jump_001_4d5d

    cp $11
    jr z, jr_001_4c63

    ld c, a
    ld a, [$c158]
    or a
    jr nz, jr_001_4c63

    ld a, b
    sub c
    cp $08
    jp nc, Jump_001_4dbb

jr_001_4c63:
    ld a, [$c16f]
    or a
    jp z, Jump_001_4cf1

    inc a
    jr nz, jr_001_4c79

    ld a, [$c170]
    cp $08
    jr c, jr_001_4c79

    ld a, $03
    ld [$c501], a

jr_001_4c79:
    ld a, [$c156]
    cp $0c
    jr nz, jr_001_4c88

    ld a, $02
    ld [$c1dc], a
    jp Jump_001_4d5d


jr_001_4c88:
    ld a, [$c1dc]
    or a
    jp nz, Jump_001_4d5d

    ld a, [$c170]
    ld [$c16f], a
    or a
    jr z, jr_001_4cf1

    ld c, a
    ld b, $06
    ld a, [$c17d]
    or a
    jr z, jr_001_4cd8

    inc a
    jr nz, jr_001_4ca6

    ld b, $0e

jr_001_4ca6:
    ld a, c
    dec a
    ld [$c170], a
    cp $1b
    jr c, jr_001_4cb3

    ld a, $16
    jr jr_001_4cb4

jr_001_4cb3:
    ld a, b

jr_001_4cb4:
    ld [$c18d], a

jr_001_4cb7:
    xor a
    ld [$c16f], a
    ld [$c170], a
    ld [$c173], a
    ld [$c174], a
    ld [$c169], a
    inc a
    ld [$c149], a
    jr jr_001_4cf1

jr_001_4ccd:
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_4cb7

    ld a, $06
    jr jr_001_4cb4

Jump_001_4cd8:
jr_001_4cd8:
    ld a, c
    dec a
    ld [$c170], a
    call TrippleShiftRightCarry
    jr z, jr_001_4ccd

    dec a
    jr z, jr_001_4ccd

    dec a
    ld b, $00
    ld c, a
    ld hl, $6388
    add hl, bc
    ld c, [hl]
    call Call_001_46cb

Jump_001_4cf1:
jr_001_4cf1:
    ld c, $00
    ld a, [$c156]
    cp $02
    jr c, jr_001_4d0c

    ld c, $02
    cp $04
    jr c, jr_001_4d0c

    cp $0b
    jr z, jr_001_4d0c

    cp $0a
    jr z, jr_001_4d0c

    dec c
    jr c, jr_001_4d0c

    dec c

jr_001_4d0c:
    ld a, c
    ld [$c17c], a

jr_001_4d10:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    dec hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    push hl
    call Call_000_165e
    jr c, jr_001_4d31

jr_001_4d26:
    pop de
    pop hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ret


jr_001_4d31:
    ld c, a
    ld a, [$c158]
    or a
    jr nz, jr_001_4d49

    ld a, [$c156]
    cp $0c
    jr c, jr_001_4d49

    cp $10
    jr nc, jr_001_4d49

    ld a, b
    sub c
    cp $04
    jr nc, jr_001_4d26

jr_001_4d49:
    pop hl
    pop de
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    sub c
    ld [$c145], a
    cp $48
    jr nc, jr_001_4d10

    call Call_000_123d
    jr jr_001_4d10

Jump_001_4d5d:
    ld a, [$c16f]
    inc a
    jr z, jr_001_4dcf

    ld a, [$c158]
    or a
    jr nz, jr_001_4d7a

    ld b, $04
    call Call_000_1660
    jr c, jr_001_4d7a

    ld a, [$c156]
    or a
    jr z, jr_001_4dc1

    ld a, b
    or a
    jr z, jr_001_4dc1

jr_001_4d7a:
    ld hl, PlayerPositionYLsb
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    push hl
    inc hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    push hl
    ld b, $ff
    call Call_000_1660
    jr nc, jr_001_4da7

    pop de
    pop hl
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ld a, [$c170]
    or a
    jp z, Jump_001_47cc

    ld c, a
    jp Jump_001_4cd8


jr_001_4da7:
    pop hl
    pop de
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, l
    sub c
    ld [$c145], a
    cp $58
    jr c, jr_001_4d7a

    call Call_000_134c
    jr jr_001_4d7a

Jump_001_4dbb:
    ld a, [$c16f]
    or a
    jr nz, jr_001_4dcf

jr_001_4dc1:
    call Call_001_47b2
    ld a, [$c1c9]
    or a
    jr nz, jr_001_4dcf

    ld a, $45
    ld [$c18d], a

jr_001_4dcf:
    ld a, [$c170]
    inc a
    cp $20
    jr nc, jr_001_4dda

    ld [$c170], a

jr_001_4dda:
    call TrippleShiftRightCarry
    ret z

    push af
    inc a
    ld b, a
    call Call_000_1660
    pop bc
    ld c, b
    jr nc, jr_001_4dea

    ld b, $01

jr_001_4dea:
    push bc
    call Call_000_0f0d
    pop bc
    dec b
    jr nz, jr_001_4dea

    ld a, [NextLevel]
    cp $0b
    jr z, jr_001_4e05

    ld a, [$c1ca]
    or a
    jr nz, jr_001_4e4e

    ld a, [$c1c9]
    or a
    jr nz, jr_001_4e4e

jr_001_4e05:
    ld a, [$c1dc]
    or a
    jr nz, jr_001_4e38

    ld a, [$c174]
    cp $01
    jr z, jr_001_4e32

    dec c
    jr nz, jr_001_4e1b

    ld a, [$c18d]
    cp $45
    ret z

jr_001_4e1b:
    ld hl, $6378

jr_001_4e1e:
    add hl, bc
    ld a, [hl]
    ld [$c18d], a
    ld a, [$c174]
    cp $03
    ret nz

    ld a, c
    cp $03
    ret c

    xor a
    ld [$c174], a
    ret


jr_001_4e32:
    dec c
    ld hl, $637d
    jr jr_001_4e1e

jr_001_4e38:
    ld c, $da
    ld a, [NextLevel]
    dec a
    jr z, jr_001_4e42

    ld c, $5a

jr_001_4e42:
    ld a, [PlayerPositionYLsb]
    cp c
    ret c

    ld a, c
    ld [PlayerPositionYLsb], a
    jp Jump_001_52ce


Jump_001_4e4e:
jr_001_4e4e:
    ld a, [$c151]
    or a
    jr z, jr_001_4e59

    dec a
    ld [$c151], a
    ret nz

jr_001_4e59:
    ld a, $04
    ld [$c151], a
    ld a, [$c154]
    inc a
    cp $06
    jr c, jr_001_4e67

    xor a

jr_001_4e67:
    ld [$c154], a
    ld b, $00
    ld c, a
    ld hl, $6382
    add hl, bc
    ld a, [hl]
    and $1f
    ld [$c18d], a
    ld a, $01
    bit 7, [hl]
    jr z, jr_001_4e7f

    ld a, $ff

jr_001_4e7f:
    ld [$c146], a
    ret


    ld c, a
    ld a, [$c149]
    or a
    ret z

    ld a, [$c169]
    or a
    ret nz

    ld a, [$c15b]
    and $01
    ret nz

    ld a, [$c172]
    or a
    ret nz

    ld a, [$c175]
    or a
    ret nz

    ld a, [$c16f]
    or a
    ret nz

    ld a, [$c178]
    or a
    ret nz

    ld a, [$c157]
    or a
    jr nz, jr_001_4ec8

    ld a, [$c146]
    ld b, a
    ld a, [$c156]
    or a
    jr z, jr_001_4ed2

    cp $0c
    jr nc, jr_001_4ed2

    cp $07
    jr nc, jr_001_4eec

    cp $02
    jr c, jr_001_4ed2

    bit 7, b
    jr nz, jr_001_4ef0

jr_001_4ec8:
    ld a, $01
    ld [$c17d], a
    xor a
    ld [$c17f], a
    ret


jr_001_4ed2:
    ld a, [$c17d]
    inc a
    jr nz, jr_001_4ede

    ld a, [$c17e]
    or a
    jr z, jr_001_4ec8

jr_001_4ede:
    bit 1, c
    jr nz, jr_001_4ef6

    ld a, [$c17e]
    or a
    ret z

    dec a
    ld [$c17e], a
    ret


jr_001_4eec:
    bit 7, b
    jr nz, jr_001_4ec8

jr_001_4ef0:
    ld a, c
    and $30
    ret z

    jr jr_001_4f06

jr_001_4ef6:
    ld a, c
    and $30
    ret z

    ld a, [$c17e]
    inc a
    cp $0a
    jr nc, jr_001_4f06

    ld [$c17e], a
    ret


jr_001_4f06:
    ld a, [$c17d]
    inc a
    ret z

    ld a, $ff
    ld [$c17d], a
    ld a, $09
    ld [$c17e], a
    ld a, $10
    ld [$c17f], a
    ld a, [$c146]
    ld [$c180], a
    ret


    ld a, [NextLevel]
    dec a
    ld b, $00
    ld c, a
    ld hl, $6133
    add hl, bc
    ld a, [hl]
    ld [$c1d6], a
    sla c
    ld hl, $613f
    add hl, bc
    ld a, [hl+]
    ld [$c1da], a
    ld a, [hl]
    ld [$c1db], a
    ld hl, $c660
    ld b, $80
    jp MemsetZero2


Call_001_4f46:
    ld a, [$c118]
    ld b, a
    ld a, [$c117]
    srl b
    rra
    ld c, a
    ld a, [$c11c]
    ld b, a
    ld a, [hl+]
    sub c
    add a
    bit 7, a
    jr z, jr_001_4f62

    cp $fd
    jr c, jr_001_4fd1

    jr jr_001_4f66

jr_001_4f62:
    cp $0d
    jr nc, jr_001_4fd1

jr_001_4f66:
    dec a
    ld c, a
    ld a, [$c117]
    and $01
    xor $01
    add c
    add a
    ld c, a
    ld a, [$c11d]
    and $01
    xor $01
    add c
    ld c, a
    ld a, [hl]
    sub b
    bit 7, a
    jr z, jr_001_4f87

    cp $fd
    jr c, jr_001_4fd1

    jr jr_001_4f8b

jr_001_4f87:
    cp $0b
    jr nc, jr_001_4fd1

jr_001_4f8b:
    add a
    push af
    ld a, [$c122]
    and $01
    ld b, a
    pop af
    sub b
    ld b, a
    ld a, [de]
    bit 4, a
    ret nz

    or $10
    ld [de], a
    inc e
    ld a, $04
    ld [de], a
    dec a
    inc e
    ld [de], a
    inc e
    inc e
    xor a
    ld [de], a
    inc e
    ld a, $06
    ld [de], a
    inc e
    ld a, [$c11d]
    add c
    and $1f
    ld c, a
    ld a, [$c122]
    add b
    and $1f
    ld b, a
    xor a
    srl b
    rra
    srl b
    rra
    srl b
    rra
    add c
    ld c, a
    ld hl, $9800
    add hl, bc
    ld a, l
    ld [de], a
    inc e
    ld a, h
    ld [de], a
    ret


jr_001_4fd1:
    xor a
    ld [de], a
    ret


    ld a, [$c15b]
    or a
    ret z

    ld hl, $c660
    ld a, [$c1d6]
    or a
    ret z

    ld b, a
    ld c, $00

jr_001_4fe4:
    push bc
    push hl
    ld a, c
    ld [WindowScrollYLsb], a
    ld a, [$c15c]
    cp c
    jr nz, jr_001_5004

    ld a, [$c15b]
    and $0f
    ld b, a
    ld a, [hl]
    and $f0
    jr nz, jr_001_500f

    ld a, [hl]
    or a
    jr z, jr_001_500f

    ld [$c15b], a
    jr jr_001_5011

jr_001_5004:
    ld a, [hl]

Call_001_5005:
    and $fe
    bit 7, a
    jr z, jr_001_5010

    or $04
    jr jr_001_5010

jr_001_500f:
    or b

jr_001_5010:
    ld [hl], a

jr_001_5011:
    push hl
    ld b, $00
    sla c
    ld hl, $c1da
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    pop de
    push de
    call Call_001_4f46
    pop hl
    call Call_001_5031
    pop hl
    pop bc
    ld a, l
    add $08
    ld l, a
    inc c
    dec b
    jr nz, jr_001_4fe4

    ret


Call_001_5031:
    bit 7, [hl]
    ret z

    ld c, $01
    rst $08
    or a
    jr z, jr_001_503c

    rst $20
    ret nz

jr_001_503c:
    bit 6, [hl]
    ret nz

    set 6, [hl]
    inc c
    rst $08
    ld d, a
    inc c
    rst $08
    ld e, a
    ld a, d
    and $0f
    add e
    ld b, a
    ld a, d
    and $0f
    swap a
    or b
    ld d, b
    dec c
    rst $10
    ld a, d
    ld c, $04
    bit 7, e
    jr nz, jr_001_505d

    inc c

jr_001_505d:
    rst $28
    jr nz, jr_001_509f

    ld c, $03
    rst $08
    cpl
    inc a
    rst $10
    ld a, [hl]
    and $04
    jr z, jr_001_509f

    inc c
    rst $08
    cp $03
    jr z, jr_001_5080

    inc a
    rst $10
    inc c
    rst $08
    cp $03
    jr z, jr_001_5080

    dec a
    rst $10
    ld c, $01
    ld a, c
    rst $10
    ret


jr_001_5080:
    ld c, $04
    xor a
    rst $10
    inc c
    ld a, $06
    rst $10
    ld c, $01
    rst $10
    ld a, [hl]
    ld b, a
    and $71
    ld [hl], a
    and $01
    jr nz, jr_001_509b

    ld a, [$c15b]
    and $01
    ret nz

    xor a

jr_001_509b:
    ld [$c15b], a
    ret


jr_001_509f:
    push hl
    ld b, $00
    ld c, d
    ld hl, $6005
    add hl, bc
    ld a, [hl]
    pop hl
    ld c, $01
    rst $10
    ld a, [hl]
    and $03
    cp $03
    ret nz

    ld c, d
    ld a, c
    cp $03
    jr nz, jr_001_50d6

    ld a, [JoyPadData]
    and $30
    jr z, jr_001_50d6

    ld b, a
    ld a, [$c146]
    bit 7, a
    jr z, jr_001_50cd

    bit 4, b
    jr z, jr_001_50d6

    jr jr_001_50d1

jr_001_50cd:
    bit 5, b
    jr z, jr_001_50d6

jr_001_50d1:
    cpl
    inc a
    ld [$c146], a

Jump_001_50d6:
jr_001_50d6:
    ld a, [$c146]
    and $80
    jr nz, jr_001_50e0

    ld a, c
    jr jr_001_50e3

jr_001_50e0:
    ld a, $06
    sub c

jr_001_50e3:
    add $23
    ld [$c18d], a
    ld a, c
    ld [$c15e], a
    ret


    ld a, [$c169]
    cp $01
    jr z, jr_001_5136

    cp $02
    ret nz

    ld a, [$c146]
    and $02
    rra
    ld c, a
    ld a, [JoyPadData]
    and $30
    jr z, jr_001_510f

    swap a
    dec a
    cp c
    ret z

    cpl
    inc a
    jr nz, jr_001_510f

    inc a

jr_001_510f:
    ld [$c161], a
    ld a, [$c15e]
    or a
    jr z, jr_001_5123

    ld a, [$c146]
    and $80
    jp z, Jump_000_0a1b

    jp Jump_000_0b58


jr_001_5123:
    ld a, $01
    ld [$c169], a
    ld [$c15f], a
    ld a, $03
    ld [$c15e], a
    ld a, [$c146]
    ld [$c160], a

jr_001_5136:
    ld hl, $c15f
    dec [hl]
    ret nz

    ld a, [$c1ca]
    or a
    jr nz, jr_001_514b

    ld de, $0205
    ld a, [JoyPadData]
    and $30
    jr nz, jr_001_514e

jr_001_514b:
    ld de, $0304

jr_001_514e:
    ld a, [$c160]
    ld b, a
    ld a, [$c15e]
    add b
    ld c, a
    bit 7, b
    jr z, jr_001_5163

    cp d
    jr nc, jr_001_516c

    ld a, b
    cpl
    inc a
    jr jr_001_5169

jr_001_5163:
    cp e
    jr c, jr_001_516c

    ld a, b
    cpl
    inc a

jr_001_5169:
    ld [$c160], a

jr_001_516c:
    ld b, $00
    ld hl, $6005
    ld a, d
    cp $02
    jr z, jr_001_5179

    ld hl, $600c

jr_001_5179:
    add hl, bc
    ld a, [hl]
    ld [$c15f], a
    jp Jump_001_50d6


    ld a, [$c163]
    ld b, $00
    ld c, a
    push bc
    ld hl, $60b7
    swap a
    and $f0
    ld c, a
    add hl, bc
    ld a, [$c164]
    ld c, a
    add hl, bc
    ld d, $00
    ld e, [hl]
    bit 7, e
    jr z, jr_001_519e

    dec d

jr_001_519e:
    ld hl, $c165
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, de
    ld a, l
    ld [PlayerPositionXLsb], a
    ld a, h
    ld [PlayerPositionXMsb], a
    ld a, c
    sub $0d
    jr c, jr_001_51d5

    ld c, a
    ld hl, $60a2
    add a
    ld d, a
    add a
    add d
    add c
    ld c, a
    add hl, bc
    pop bc
    add hl, bc
    ld c, [hl]
    bit 7, c
    jr z, jr_001_51c5

    dec b

jr_001_51c5:
    ld hl, $c167
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    add hl, bc
    ld a, l
    ld [PlayerPositionYLsb], a
    ld a, h
    ld [PlayerPositionYMsb], a
    ret


jr_001_51d5:
    pop bc
    ld c, b
    jr jr_001_51c5

    ld h, $c6
    ld a, [$c1d8]
    ld l, a
    ld a, [hl]
    and $50
    cp $50
    jr z, jr_001_51f3

    ld a, [$c1d9]
    ld l, a
    ld a, [hl]
    and $50
    cp $50
    jr z, jr_001_51f3

    and a
    ret


jr_001_51f3:
    res 6, [hl]
    inc l
    inc l
    ld c, [hl]
    ld a, l
    add $04
    ld l, a
    ld e, [hl]
    ld a, e
    inc l
    ld d, [hl]
    push bc
    push de
    ld a, c
    swap a
    and $0f
    add a
    ld c, a
    ld b, $00
    ld hl, $6013
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld b, [hl]
    dec b
    ld a, e
    add $20
    ld e, a
    inc hl
    inc hl
    inc hl
    inc hl

jr_001_521c:
    ld c, [hl]
    inc hl
    inc hl
    bit 7, c
    jr z, jr_001_522c

    ld a, e
    add c
    ld c, e
    ld e, a
    jr c, jr_001_5233

    dec d
    jr jr_001_5233

jr_001_522c:
    ld a, e
    add c
    ld c, e
    ld e, a
    jr nc, jr_001_5233

    inc d

jr_001_5233:
    ld a, c
    xor e
    and $10
    jr z, jr_001_5253

    ld a, e
    bit 4, c
    jr nz, jr_001_5249

    bit 3, c
    jr nz, jr_001_5253

    add $20
    jr nc, jr_001_5252

    inc d
    jr jr_001_5252

jr_001_5249:
    bit 3, c
    jr z, jr_001_5253

    sub $20
    jr nc, jr_001_5252

    dec d

jr_001_5252:
    ld e, a

jr_001_5253:
    ld a, d
    cp $9c
    jr c, jr_001_525a

    ld d, $98

jr_001_525a:
    ld c, $03
    ld a, [NextLevel]
    cp $0a
    jr nz, jr_001_5265

    ld c, $01

jr_001_5265:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5265

    ld a, c
    ld [de], a
    dec b
    jr nz, jr_001_521c

    pop de
    pop bc
    ld a, c
    and $0f
    add a
    ld c, a
    ld b, $00
    ld hl, $6013
    add hl, bc
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    ld b, [hl]
    inc hl

jr_001_5282:
    ld a, [hl+]
    push af
    ld c, [hl]
    inc hl
    bit 7, c
    jr z, jr_001_5293

    ld a, e
    add c
    ld c, e
    ld e, a
    jr c, jr_001_529a

    dec d
    jr jr_001_529a

jr_001_5293:
    ld a, e
    add c
    ld c, e
    ld e, a
    jr nc, jr_001_529a

    inc d

jr_001_529a:
    ld a, c
    xor e
    and $10
    jr z, jr_001_52ba

    ld a, e
    bit 4, c
    jr nz, jr_001_52b0

    bit 3, c
    jr nz, jr_001_52ba

    add $20
    jr nc, jr_001_52b9

    inc d
    jr jr_001_52b9

jr_001_52b0:
    bit 3, c
    jr z, jr_001_52ba

    sub $20
    jr nc, jr_001_52b9

    dec d

jr_001_52b9:
    ld e, a

jr_001_52ba:
    ld a, d
    cp $9c
    jr c, jr_001_52c1

    ld d, $98

jr_001_52c1:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_52c1

    pop af
    ld [de], a
    dec b
    jr nz, jr_001_5282

    scf
    ret


Jump_001_52ce:
    ld a, [$c1dc]
    and $01
    ret nz

    ld a, $05
    ld [$c18d], a
    ld hl, $c200
    ld c, $05

jr_001_52de:
    rst $08
    cp $ae
    jr z, jr_001_52ea

    ld a, l
    add $20
    ld l, a
    jr nc, jr_001_52de

    ret


jr_001_52ea:
    set 6, [hl]
    ld bc, $000c
    add hl, bc
    ld [hl], $1b
    ld a, $81
    jr jr_001_5306

    ld a, [$c1dc]
    and $01
    ret z

    ld a, $0f
    ld [$c501], a
    call Call_001_4881
    ld a, $80

jr_001_5306:
    ld [$c1dc], a
    ld hl, $9938
    ld a, [PlayerPositionXMsb]
    or a
    jr z, jr_001_531c

    ld hl, $9b36
    cp $02
    jr z, jr_001_531c

    ld hl, $9b32

jr_001_531c:
    ld a, l
    ld [$c1dd], a
    ld a, h
    ld [$c1de], a
    ret


    ld a, [$c1dc]
    and $01
    ld [$c1dc], a
    ld c, $1b
    ld hl, $c1dd
    ld de, $5366
    ld a, [hl+]
    ld h, [hl]
    ld l, a
    jr nz, jr_001_533d

    ld de, $535a

jr_001_533d:
    ld b, $06
    call Call_001_5353
    add hl, bc
    ld a, [de]
    ld [hl+], a
    inc hl
    inc hl
    inc de
    ld a, [de]
    ld [hl+], a
    inc de
    add hl, bc
    call Call_001_5351
    inc hl
    inc hl

Call_001_5351:
    ld b, $02

Call_001_5353:
jr_001_5353:
    ld a, [de]
    ld [hl+], a
    inc de
    dec b
    jr nz, jr_001_5353

    ret


    ld [hl], b
    ld [hl], c
    ld [hl], d
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [bc], a
    ld [hl], e
    ld [bc], a
    ld [bc], a
    ld [hl], h
    ld [hl], l
    ld [bc], a
    ld [bc], a
    ld [bc], a
    db $76
    ld [hl], a
    ld a, b
    ld a, c
    ld [bc], a
    ld a, d
    ld a, e
    ld [bc], a
    ld [bc], a
    call Call_001_556f
    ret nz

    call Call_001_53c6
    ret nz

    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5384

    cp $05
    ret nz

jr_001_5384:
    ld a, [$c1cf]
    or a
    ret z

    ld hl, $9c20
    and $80
    jr nz, jr_001_5397

    ld a, [$c121]
    add $14
    jr jr_001_539b

jr_001_5397:
    ld a, [$c121]
    dec a

jr_001_539b:
    ld b, $00
    and $1f
    ld c, a
    add hl, bc
    ld a, h
    cp $a0
    jr c, jr_001_53ab

    sub $a0
    add $9c
    ld h, a

jr_001_53ab:
    ld de, $c3f0
    ld bc, $0020
    ld a, $04

jr_001_53b3:
    push af

jr_001_53b4:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_53b4

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    pop af
    dec a
    jr nz, jr_001_53b3

    ld [$c1cf], a
    ret


Call_001_53c6:
    ld a, [$c1cd]
    or a
    ret z

    push af
    ld hl, $9800
    ld a, [$c123]
    dec a
    and $1f
    ld c, $00
    srl a
    rr c
    srl a
    rr c
    srl a
    rr c
    ld b, a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_53ef

    sub $9c
    add $98
    ld h, a

jr_001_53ef:
    pop af
    and $80
    jr nz, jr_001_53fb

    ld a, [$c11e]
    add $14
    jr jr_001_53ff

jr_001_53fb:
    ld a, [$c11e]
    dec a

jr_001_53ff:
    ld b, $00
    and $1f
    ld c, a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_540f

    sub $9c
    add $98
    ld h, a

jr_001_540f:
    ld de, $c3c0
    ld bc, $0020

jr_001_5415:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5415

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5426

    ld h, $98

jr_001_5426:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5426

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5437

    ld h, $98

jr_001_5437:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5437

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5448

    ld h, $98

jr_001_5448:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5448

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5459

    ld h, $98

jr_001_5459:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5459

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_546a

    ld h, $98

jr_001_546a:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_546a

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_547b

    ld h, $98

jr_001_547b:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_547b

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_548c

    ld h, $98

jr_001_548c:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_548c

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_549d

    ld h, $98

jr_001_549d:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_549d

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_54ae

    ld h, $98

jr_001_54ae:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_54ae

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_54bf

    ld h, $98

jr_001_54bf:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_54bf

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_54d0

    ld h, $98

jr_001_54d0:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_54d0

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_54e1

    ld h, $98

jr_001_54e1:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_54e1

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_54f2

    ld h, $98

jr_001_54f2:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_54f2

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5503

    ld h, $98

jr_001_5503:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5503

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5514

    ld h, $98

jr_001_5514:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5514

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5525

    ld h, $98

jr_001_5525:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5525

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5536

    ld h, $98

jr_001_5536:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5536

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5547

    ld h, $98

jr_001_5547:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5547

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5558

    ld h, $98

jr_001_5558:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5558

    ld a, [de]
    inc e
    ld [hl], a
    add hl, bc
    ld a, h
    cp $9c
    jr c, jr_001_5569

    ld h, $98

jr_001_5569:
    xor a
    ld [$c1cd], a
    inc a
    ret


Call_001_556f:
    ld a, [$c1ce]
    or a
    ret z

    push af
    ld h, $98
    ld a, [$c11f]
    dec a
    and $1f
    ld l, a
    pop af
    and $80
    jr nz, jr_001_558a

    ld a, [$c124]
    add $12
    jr jr_001_558e

jr_001_558a:
    ld a, [$c124]
    dec a

jr_001_558e:
    and $1f
    ld c, $00
    srl a
    rr c
    srl a
    rr c
    srl a
    rr c
    ld b, a
    add hl, bc
    ld de, $c3d8
    ld bc, $ffe0

jr_001_55a6:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_55a6

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_55b5

    add hl, bc

jr_001_55b5:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_55b5

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_55c4

    add hl, bc

jr_001_55c4:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_55c4

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_55d3

    add hl, bc

jr_001_55d3:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_55d3

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_55e2

    add hl, bc

jr_001_55e2:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_55e2

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_55f1

    add hl, bc

jr_001_55f1:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_55f1

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_5600

    add hl, bc

jr_001_5600:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5600

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_560f

    add hl, bc

jr_001_560f:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_560f

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_561e

    add hl, bc

jr_001_561e:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_561e

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_562d

    add hl, bc

jr_001_562d:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_562d

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_563c

    add hl, bc

jr_001_563c:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_563c

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_564b

    add hl, bc

jr_001_564b:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_564b

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_565a

    add hl, bc

jr_001_565a:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_565a

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_5669

    add hl, bc

jr_001_5669:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5669

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_5678

    add hl, bc

jr_001_5678:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5678

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_5687

    add hl, bc

jr_001_5687:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5687

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_5696

    add hl, bc

jr_001_5696:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5696

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_56a5

    add hl, bc

jr_001_56a5:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_56a5

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_56b4

    add hl, bc

jr_001_56b4:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_56b4

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_56c3

    add hl, bc

jr_001_56c3:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_56c3

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_56d2

    add hl, bc

jr_001_56d2:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_56d2

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_56e1

    add hl, bc

jr_001_56e1:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_56e1

    ld a, [de]
    inc e
    ld [hl+], a
    ld a, l
    and $1f
    jr nz, jr_001_56f0

    add hl, bc

jr_001_56f0:
    xor a
    ld [$c1ce], a
    inc a
    ret


    ld a, [$c1e5]
    or a
    ret z

    and $df
    cp $01
    jr z, jr_001_5712

    cp $03
    jr z, jr_001_574c

    cp $05
    jr nz, jr_001_5768

    ld b, a
    ld a, [$c1e8]
    or a
    jp z, Jump_001_5848

    ld a, b

jr_001_5712:
    push af
    call Call_000_085e
    call Call_000_1889
    pop bc
    ld a, [PlayerPositionXLsb]
    cp $7c
    ret c

    xor a
    ld [$c18d], a
    ld a, b
    cp $05
    jr z, jr_001_5735

    ld a, $ff
    ld [$c146], a
    ld a, $01
    ld [$c1e7], a
    jr jr_001_5760

jr_001_5735:
    ld a, $08
    ld [$c151], a
    xor a
    ld [$c154], a
    ld [$c152], a
    dec a
    ld [$c153], a
    ld a, $3e
    ld [$c18d], a
    jr jr_001_5760

jr_001_574c:
    call Call_000_094a
    call Call_000_1889
    ld a, [PlayerPositionXLsb]
    cp $28
    ret nc

    xor a
    ld [$c18d], a
    inc a
    ld [$c146], a

jr_001_5760:
    ld a, [$c1e5]
    inc a
    ld [$c1e5], a
    ret


jr_001_5768:
    cp $02
    jr nz, jr_001_5781

    call Call_001_4196
    push af
    ld a, [DifficultyMode]
    or a
    ld a, $10
    jr z, jr_001_577a

    swap a

jr_001_577a:
    call Call_001_420f
    pop af
    ret z

    jr jr_001_57c1

jr_001_5781:
    bit 6, a
    jr z, jr_001_57a4

    ld hl, $c240
    bit 4, [hl]
    ret nz

    ld a, $06
    ld bc, $0020

jr_001_5790:
    ld [hl], $80
    add hl, bc
    dec a
    jr nz, jr_001_5790

    ld [$c1e6], a
    ld a, [$c1e5]
    and $0f
    or $10
    ld [$c1e5], a
    ret


jr_001_57a4:
    cp $04
    jr nz, jr_001_57df

    ld hl, $c1e7
    dec [hl]
    ret nz

    ld [hl], $04
    call Call_001_4140
    push af
    ld a, [DifficultyMode]
    ld c, a
    ld a, $02
    sub c
    swap a
    call Call_001_420f
    pop af
    ret nz

jr_001_57c1:
    ld a, [$c1e5]
    and $df
    or $40
    ld [$c1e5], a
    ld hl, $c247
    ld b, $06
    ld c, $02

jr_001_57d2:
    ld [hl], c
    inc l
    inc l
    ld [hl], $01
    ld a, l
    add $1e
    ld l, a
    dec b
    jr nz, jr_001_57d2

    ret


jr_001_57df:
    cp $06
    ret nz

    ld hl, $c151
    dec [hl]
    ret nz

    ld [hl], $08
    ld a, [$c154]
    inc a
    cp $07
    jr c, jr_001_57f2

    xor a

jr_001_57f2:
    ld [$c154], a
    ld hl, $6392
    ld b, $00
    ld c, a
    add hl, bc
    ld a, [hl]
    ld [$c18d], a
    cp $53
    ret nz

    ld a, [$c152]
    inc a
    and $01
    ld [$c152], a
    ret z

    ld a, [PlayerPositionYLsb]
    cp $98
    jr nc, jr_001_5848

    add $04
    ld [PlayerPositionYLsb], a
    ld hl, $6399
    ld a, [$c153]
    inc a
    ld [$c153], a
    cp $04
    ret nc

    add a
    add a
    add a
    ld c, a
    add hl, bc
    ld de, $9a0e
    ld b, $02
    ld c, $04

jr_001_5832:
    ldh a, [rSTAT]
    and $02
    jr nz, jr_001_5832

    ld a, [hl+]
    ld [de], a
    inc e
    dec c
    jr nz, jr_001_5832

    ld a, e
    add $1c
    ld e, a
    ld c, $04
    dec b
    jr nz, jr_001_5832

    ret


Jump_001_5848:
jr_001_5848:
    ld a, [$c1c9]
    or a
    ret nz

    ld a, [NextLevel2]
    cp $0a
    jr nz, jr_001_586f

    xor a
    ld [$c1c0], a
    ld a, $a0
    ld [$c1d0], a
    ld a, [PlayerPositionXLsb]
    cp $dc
    jp c, Jump_000_07e2

    xor a
    ld [$c18d], a
    ld b, $fe
    ld a, $0c
    jr jr_001_587a

jr_001_586f:
    ld a, [$c1e8]
    or a
    jp z, Jump_001_5fbd

    ld b, $01
    ld a, $0a

jr_001_587a:
    ld [CurrentLevel], a
    ld a, b
    ld [$c1c9], a
    ret


    ld a, [NextLevel]
    ld de, $06c8
    cp $05
    jr z, jr_001_58a0

    cp $03
    ret nz

    ld hl, $9c3f
    ld bc, $0020
    ld a, $04

jr_001_5897:
    ld [hl], $02
    add hl, bc
    dec a
    jr nz, jr_001_5897

    ld de, $05e8

jr_001_58a0:
    ld a, e
    ld [$c134], a
    ld a, d
    ld [$c135], a
    ld hl, $9c00
    ld a, $20

jr_001_58ad:
    ld [hl], $02
    inc hl
    dec a
    jr nz, jr_001_58ad

    ld hl, $c129
    ld a, [BgScrollXLsb]
    ld [hl+], a
    ld a, [BgScrollXMsb]
    ld [hl+], a
    ld b, $06
    xor a

jr_001_58c1:
    ld [hl+], a
    dec b
    jr nz, jr_001_58c1

    ld [$c13a], a
    ld [$c13b], a
    ld [$c13e], a
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_58da

    ld a, [CheckpointReached]
    or a
    ret nz

jr_001_58da:
    call Call_000_1351
    push af
    call Call_001_556f
    pop af
    jr nz, jr_001_58da

    ret


    ld a, [$c1ca]
    or a
    ret nz

    ld a, [NextLevel]
    ld d, a
    ld hl, $63b9
    cp $03
    ret c

    jr z, jr_001_5919

    cp $06
    ret nc

    ld hl, $63c1
    ld a, [$c13b]
    cp $03
    jr c, jr_001_5919

    ld c, a
    ld a, [TimeCounter]
    and $07
    jr nz, jr_001_593a

    ld a, c
    dec a
    ld [$c13b], a
    cp $03
    jr nc, jr_001_593a

    ld a, $0a
    ld [$c131], a

jr_001_5919:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_593a

    ld b, a
    ld a, [$c131]
    inc a
    and $0f
    ld [$c131], a
    ld c, a
    srl c
    add hl, bc
    bit 0, a
    ld a, [hl]
    jr nz, jr_001_5935

    swap a

jr_001_5935:
    and $0f
    ld [$c13b], a

jr_001_593a:
    ld a, d
    cp $04
    jp z, Jump_001_5a3a

    cp $05
    call z, Call_001_5a3a
    ld hl, $c12d
    ld e, [hl]
    inc hl
    ld d, [hl]
    push hl
    push de
    call Call_001_59ba
    pop de
    pop hl
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5996

    ld a, [$c1e9]
    or a
    jr nz, jr_001_5996

    ld bc, $1500
    ld a, [NextLevel]
    cp $03
    jr nz, jr_001_5975

    ld a, d
    cp $03
    jr nz, jr_001_5981

    ld a, e
    cp $68
    jr z, jr_001_5996

    jr jr_001_5981

jr_001_5975:
    ld bc, $0700
    ld a, d
    or a
    jr nz, jr_001_5981

    ld a, e
    cp $a0
    jr z, jr_001_5996

jr_001_5981:
    ld a, d
    or e
    jr nz, jr_001_5987

    ld d, b
    ld e, c

jr_001_5987:
    dec de
    ld [hl], d
    dec hl
    ld [hl], e
    ld hl, $c12f
    ld a, e
    cpl
    inc a
    ld [hl+], a
    dec b
    ld a, b
    sub d
    ld [hl], a

jr_001_5996:
    ld a, [$c129]
    ld b, a
    ld a, [BgScrollXLsb]
    ld c, a
    ld a, e
    add c
    sub b
    ret z

    bit 7, a
    jr z, jr_001_59b1

    cpl
    inc a

jr_001_59a8:
    push af
    call Call_001_5a6e
    pop af
    dec a
    jr nz, jr_001_59a8

    ret


jr_001_59b1:
    push af
    call Call_001_5b15
    pop af
    dec a
    jr nz, jr_001_59b1

    ret


Call_001_59ba:
    ld b, $01
    push de
    call Call_000_1660
    pop de
    ld a, [NextLevel]
    cp $03
    jr nz, jr_001_59d6

    ld a, [$c156]
    cp $20
    jr z, jr_001_59ea

    and $1f
    cp $14
    ret c

    jr jr_001_59ea

jr_001_59d6:
    ld a, [$c156]
    cp $21
    ret c

    cp $25
    ret nc

    ld a, [$c16f]
    or a
    jr z, jr_001_59ea

    ld a, $06
    ld [$c13b], a

jr_001_59ea:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5a20

    ld [$c13e], a
    ld a, [NextLevel]
    cp $03
    jr nz, jr_001_5a07

    ld a, d
    cp $03
    jr nz, jr_001_5a10

    ld a, e
    cp $68
    jr z, jr_001_5a20

    jr jr_001_5a10

jr_001_5a07:
    ld a, d
    or a
    jr nz, jr_001_5a10

    ld a, e
    cp $a0
    jr z, jr_001_5a20

jr_001_5a10:
    ld a, [$c149]
    push af
    ld a, $ff
    ld [$c149], a
    call Call_000_085e
    pop af
    ld [$c149], a

jr_001_5a20:
    ld a, [$c172]
    or a
    ret nz

    ld a, [$c13b]
    ld [$c13e], a
    ld a, [$c1e9]
    or a
    ret z

    ld a, $ff
    ld [$c176], a
    ld c, $04
    jp Jump_000_1973


Call_001_5a3a:
Jump_001_5a3a:
    ld a, [$c158]
    cp $29
    ret c

    cp $2c
    jr c, jr_001_5a4d

    cp $2e
    jr z, jr_001_5a58

    cp $2f
    jr z, jr_001_5a58

    ret


jr_001_5a4d:
    ld a, [$c16f]
    or a
    jr z, jr_001_5a58

    ld a, $06
    ld [$c13b], a

jr_001_5a58:
    ld a, [TimeCounter]
    and $03
    jr nz, jr_001_5a62

    ld [$c13e], a

jr_001_5a62:
    ld a, [$c172]
    or a
    ret nz

    ld a, [$c13b]
    ld [$c13e], a
    ret


Call_001_5a6e:
    ld hl, $c129
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld a, d
    or e
    jr nz, jr_001_5a85

    ld de, $1500
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5a85

    ld de, $0700

jr_001_5a85:
    dec de
    ld [hl], d
    dec hl
    ld [hl], e
    ld a, e
    and $07
    ret nz

    dec a
    ld [$c1cf], a
    call Call_001_5bab
    ld a, [$c116]
    and $01
    xor $01
    ld c, a
    ld a, [$c11a]
    ld b, a
    ld a, [$c119]
    sub c
    ld c, a
    jr nc, jr_001_5abb

    ld a, b
    or a
    jr nz, jr_001_5aba

    ld bc, $014f
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5abb

    ld bc, $006f
    jr jr_001_5abb

jr_001_5aba:
    dec b

jr_001_5abb:
    srl b
    rr c
    ld hl, $cf00
    ld a, [$c134]
    ld e, a
    ld a, [$c135]
    ld d, a
    add hl, de
    add hl, bc
    ld de, $c3f0
    ld b, $02
    ld c, $00

jr_001_5ad3:
    push bc
    call Call_001_5ae6
    pop bc
    inc c
    dec b
    jr nz, jr_001_5ad3

Jump_001_5adc:
    ld a, [$c120]
    ld [$c121], a
    ld a, $01
    rst $00
    ret


Call_001_5ae6:
    ld a, [hl]
    push bc
    push hl
    call Call_000_1454
    ld a, c
    and $01
    jr z, jr_001_5af3

    inc hl
    inc hl

jr_001_5af3:
    ld a, [$c116]
    and $01
    ld c, a
    ld a, [$c119]
    and $01
    xor c
    jr nz, jr_001_5b02

    inc hl

jr_001_5b02:
    ld bc, $cb00
    add hl, bc
    ld a, [hl]
    call Call_000_1454
    ld a, [$c116]
    and $01
    jr nz, jr_001_5b12

    inc hl

jr_001_5b12:
    jp Jump_000_10f2


Call_001_5b15:
    ld hl, $c129
    ld e, [hl]
    inc hl
    ld d, [hl]
    ld b, $15
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5b26

    ld b, $07

jr_001_5b26:
    inc de
    ld a, d
    cp b
    jr nz, jr_001_5b2e

    ld de, $0000

jr_001_5b2e:
    ld [hl], d
    dec hl
    ld [hl], e
    ld a, e
    and $07
    ret nz

    inc a
    ld [$c1cf], a
    call Call_001_5bab
    ld de, $0150
    ld a, [NextLevel]
    cp $03
    jr z, jr_001_5b49

    ld de, $0070

jr_001_5b49:
    ld a, [$c119]
    add $0a
    ld c, a
    ld a, [$c11a]
    adc $00
    ld b, a
    cp d
    jr nz, jr_001_5b5f

    ld a, c
    sub e
    jr c, jr_001_5b5f

    ld c, a
    ld b, $00

jr_001_5b5f:
    srl b
    rr c
    ld hl, $cf00
    ld a, [$c134]
    ld e, a
    ld a, [$c135]
    ld d, a
    add hl, de
    add hl, bc
    ld de, $c3f0
    ld b, $02
    ld c, $00

jr_001_5b77:
    push bc
    call Call_001_5b83
    pop bc
    inc c
    dec b
    jr nz, jr_001_5b77

    jp Jump_001_5adc


Call_001_5b83:
    ld a, [hl]
    push bc
    push hl
    call Call_000_1454
    ld a, c
    and $01
    jr z, jr_001_5b90

    inc hl
    inc hl

jr_001_5b90:
    ld a, [$c119]
    and $01
    jr z, jr_001_5b98

    inc hl

jr_001_5b98:
    ld bc, $cb00
    add hl, bc
    ld a, [hl]
    call Call_000_1454
    ld a, [$c116]
    and $01
    jr z, jr_001_5ba8

    inc hl

jr_001_5ba8:
    jp Jump_000_10f2


Call_001_5bab:
    ld a, e
    call TrippleShiftRightCarry
    ld [$c120], a
    call TrippleRotateShiftRight
    ld a, e
    ld [$c116], a
    srl d
    rra
    ld [$c119], a
    ld a, d
    ld [$c11a], a
    ret


    bit 7, [hl]
    ret nz

    call Call_001_5c80
    call Call_001_5cb1
    call Call_001_5d5f
    call Call_001_5d1c
    call Call_001_5cc0
    ld c, $09
    rst $08
    dec a
    rst $10
    ld b, a
    and $0f
    jr nz, jr_001_5c31

    ld a, b
    swap a
    or b
    rst $10
    ld c, $07
    rst $08
    and $0f
    jr z, jr_001_5c31

    bit 3, a
    jr z, jr_001_5bf2

    or $f0

jr_001_5bf2:
    ld c, a
    push bc
    ld c, $03
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    pop bc
    bit 7, c
    jr nz, jr_001_5c08

    ld a, e
    add c
    ld e, a
    jr nc, jr_001_5c0e

    inc d
    jr jr_001_5c0e

jr_001_5c08:
    ld a, e
    add c
    ld e, a
    jr c, jr_001_5c0e

    dec d

jr_001_5c0e:
    ld c, $03
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    bit 0, [hl]
    jr z, jr_001_5c20

    ld c, $15
    rst $08
    cp $0c
    jr nz, jr_001_5c31

jr_001_5c20:
    ld a, [BgScrollXLsb]
    ld c, a
    ld a, e
    sub c
    cp $b8
    jr c, jr_001_5c31

    cp $e8
    jr nc, jr_001_5c31

    set 7, [hl]
    ret


jr_001_5c31:
    ld c, $0a
    rst $08
    dec a
    rst $10
    ld b, a
    and $0f
    ret nz

    ld a, b
    swap a
    or b
    rst $10
    ld c, $08
    rst $08
    or a
    ret z

    ld c, a
    push bc
    ld c, $01
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    pop bc
    bit 7, c
    jr nz, jr_001_5c5a

    ld a, e
    add c
    ld e, a
    jr nc, jr_001_5c60

    inc d
    jr jr_001_5c60

jr_001_5c5a:
    ld a, e
    add c
    ld e, a
    jr c, jr_001_5c60

    dec d

jr_001_5c60:
    ld c, $01
    ld a, e
    rst $10
    inc c
    ld a, d
    rst $10
    bit 0, [hl]
    jr z, jr_001_5c71

    ld c, $15
    rst $08
    cp $0c
    ret nz

jr_001_5c71:
    ld a, [BgScrollYLsb]
    ld c, a
    ld a, e
    sub c
    cp $90
    ret c

    cp $e0
    ret nc

    set 7, [hl]
    ret


Call_001_5c80:
    ld c, $0b
    rst $08
    or a
    ret z

    ld d, a
    inc c
    rst $20
    ret nz

    ld a, d
    rst $10
    inc c
    rst $08
    inc a
    bit 2, [hl]
    jr nz, jr_001_5c96

    and $01
    rst $10
    ret


jr_001_5c96:
    and $03
    rst $10
    ld de, $672d
    add a
    add e
    ld e, a
    jr nc, jr_001_5ca2

    inc d

jr_001_5ca2:
    ld a, [de]
    ld c, $12
    rst $10
    inc de
    ld a, [de]
    ld d, a
    ld c, $07
    rst $08
    and $0f
    or d
    rst $10
    ret


Call_001_5cb1:
    bit 2, [hl]
    ret nz

    ld c, $12
    rst $08
    or a
    ret z

    dec a
    rst $10
    or a
    ret nz

    set 7, [hl]
    ret


Call_001_5cc0:
    ld a, [hl]
    and $03
    cp $02
    ret nz

    ld c, $0c
    rst $08
    or a
    jr z, jr_001_5cdc

    dec a
    rst $10
    srl a
    srl a
    cpl
    inc a
    ld c, $08
    rst $10
    xor a
    ld c, $0e
    rst $10
    ret


jr_001_5cdc:
    ld c, $0e
    rst $08
    inc a
    cp $11
    jr nc, jr_001_5cec

    rst $10
    srl a
    srl a
    ld c, $08
    rst $10

jr_001_5cec:
    call Call_000_17f2
    ret nc

    ld a, $14
    ld c, $0c
    rst $10
    ld a, $0b
    ld [$c501], a
    bit 3, [hl]
    ret nz

    set 3, [hl]
    ld a, [$c1ef]
    or a
    jr nz, jr_001_5d16

    ld a, [BgScrollXLsb]
    ld e, a
    ld c, $03
    rst $08
    sub e
    ld c, a
    ld a, [$c144]
    cp c
    ld a, $01
    jr nc, jr_001_5d18

jr_001_5d16:
    ld a, $0f

jr_001_5d18:
    ld c, $07
    rst $10
    ret


Call_001_5d1c:
    ld a, [hl]
    and $37
    cp $37
    ret nz

    ld c, $01
    rst $08
    ld c, a
    ld a, [BgScrollYLsb]
    ld b, a
    ld a, c
    sub b
    ld c, a
    ld b, $04
    ld a, [$c177]
    or a
    jr nz, jr_001_5d37

    ld b, $0c

jr_001_5d37:
    ld a, [$c145]
    sub b
    sub c
    bit 7, a
    jr z, jr_001_5d42

    cpl
    inc a

jr_001_5d42:
    cp b
    ret nc

    ld c, $03
    rst $08
    ld c, a
    ld a, [BgScrollXLsb]
    ld b, a
    ld a, c
    sub b
    ld c, a
    ld a, [$c144]
    sub c
    bit 7, a
    jr z, jr_001_5d59

    cpl
    inc a

jr_001_5d59:
    cp $08
    ret nc

    set 7, [hl]
    ret


Call_001_5d5f:
    bit 0, [hl]
    ret z

    bit 1, [hl]
    jr nz, jr_001_5d91

    ld c, $13
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld a, [$c146]
    and $80
    jr nz, jr_001_5d81

    ld a, [$c17d]
    or a
    jr z, jr_001_5d8c

    inc de
    inc a
    jr nz, jr_001_5d8c

    inc de
    jr jr_001_5d8c

jr_001_5d81:
    ld a, [$c17d]
    or a
    jr z, jr_001_5d8c

    dec de
    inc a
    jr nz, jr_001_5d8c

    dec de

jr_001_5d8c:
    ld a, d
    rst $10
    dec c
    ld a, e
    rst $10

jr_001_5d91:
    ld c, $15
    rst $08
    cp $04
    jr c, jr_001_5da8

    jp z, Jump_001_5e95

    cp $08
    jp z, Jump_001_5e95

    cp $0c
    jp z, Jump_001_5e95

    call Call_001_5e95

jr_001_5da8:
    ld c, $0e
    rst $08
    dec a
    rst $10
    ld b, a
    and $0f
    ret nz

    ld a, b
    or $04
    rst $10

Jump_001_5db5:
    ld c, $03
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld c, $13
    rst $08
    sub e
    ld e, a
    push af
    inc c
    rst $08
    ld b, a
    pop af
    ld a, b
    sbc d
    ld d, a
    bit 1, [hl]
    jr nz, jr_001_5de6

    ld c, $07
    rst $08
    swap a
    xor d
    and $80
    ret z

    set 1, [hl]
    set 3, [hl]
    ld c, $15
    rst $08
    cp $04
    jr nc, jr_001_5de6

    set 5, [hl]
    call Call_001_5f7a

jr_001_5de6:
    ld a, [PlayerPositionXLsb]
    add $08
    ld c, $13
    push af
    rst $10
    pop af
    ld a, [PlayerPositionXMsb]
    adc $00
    inc c
    rst $10
    bit 3, [hl]
    jr nz, jr_001_5e3f

    ld c, $07
    rst $08
    swap a
    xor d
    and $80
    jr z, jr_001_5e09

    set 3, [hl]
    jr jr_001_5e3f

jr_001_5e09:
    ld c, $09
    rst $08
    ld b, a
    and $f0
    cp $10
    jr z, jr_001_5e1f

    srl a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $09
    rst $10
    jr jr_001_5e8d

jr_001_5e1f:
    ld c, $07
    rst $08
    ld b, a
    and $0f
    bit 3, a
    jr nz, jr_001_5e30

    cp $03
    jr z, jr_001_5e8d

    inc a
    jr jr_001_5e35

jr_001_5e30:
    cp $0d
    jr z, jr_001_5e8d

    dec a

jr_001_5e35:
    ld c, a
    ld a, b
    and $f0
    or c
    ld c, $07
    rst $10
    jr jr_001_5e8d

jr_001_5e3f:
    ld c, $07
    rst $08
    ld b, a
    and $0f
    bit 3, a
    jr nz, jr_001_5e4e

    dec a
    jr z, jr_001_5e5d

    jr jr_001_5e53

jr_001_5e4e:
    cp $0f
    jr z, jr_001_5e5d

    inc a

jr_001_5e53:
    ld c, a
    ld a, b
    and $f0
    or c
    ld c, $07
    rst $10
    jr jr_001_5e8d

jr_001_5e5d:
    ld c, $09
    rst $08
    ld b, a
    and $f0
    cp $40
    jr nc, jr_001_5e73

    sla a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $09
    rst $10
    jr jr_001_5e8d

jr_001_5e73:
    res 3, [hl]
    ld c, $07
    rst $08
    ld b, a
    and $0f
    bit 3, a
    jr z, jr_001_5e81

    or $f0

jr_001_5e81:
    cpl
    inc a
    and $0f
    ld c, a
    ld a, b
    and $f0
    or c
    ld c, $07
    rst $10

jr_001_5e8d:
    ld c, $15
    rst $08
    cp $04
    ret nc

    jr jr_001_5eaa

Call_001_5e95:
Jump_001_5e95:
    ld c, $05
    rst $08
    cp $97
    jr z, jr_001_5eaa

    ld c, $0e
    rst $08
    sub $10
    rst $10
    ld b, a
    and $f0
    ret nz

    ld a, b
    or $40
    rst $10

jr_001_5eaa:
    ld c, $01
    rst $08
    ld e, a
    inc c
    rst $08
    ld d, a
    ld c, $10
    rst $08
    sub e
    ld e, a
    push af
    inc c
    rst $08
    ld b, a
    pop af
    ld a, b
    sbc d
    ld d, a
    bit 5, [hl]
    jr nz, jr_001_5edc

    ld c, $08
    rst $08
    xor d
    and $80
    ret z

    set 5, [hl]
    set 6, [hl]
    ld c, $15
    rst $08
    cp $04
    jr z, jr_001_5ed8

    cp $08
    jr nz, jr_001_5edc

jr_001_5ed8:
    set 1, [hl]
    set 3, [hl]

jr_001_5edc:
    ld b, $08
    ld a, [$c177]
    or a
    jr nz, jr_001_5eef

    ld c, $15
    rst $08
    ld b, $10
    cp $0c
    jr z, jr_001_5eef

    ld b, $14

jr_001_5eef:
    ld a, [PlayerPositionYLsb]
    sub b
    ld c, $10
    push af
    rst $10
    pop af
    ld a, [PlayerPositionYMsb]
    sbc $00
    inc c
    rst $10
    bit 6, [hl]
    jr nz, jr_001_5f4b

    ld c, $08
    rst $08
    xor d
    and $80
    jr z, jr_001_5f0f

    set 6, [hl]
    jr jr_001_5f4b

jr_001_5f0f:
    ld c, $0a
    rst $08
    ld b, a
    and $f0
    cp $10
    jr z, jr_001_5f25

    srl a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $0a
    rst $10
    jr jr_001_5f82

jr_001_5f25:
    ld c, $05
    rst $08
    ld d, $03
    cp $97
    jr z, jr_001_5f36

    ld c, $15
    rst $08
    cp $0c
    ret z

    ld d, $02

jr_001_5f36:
    ld c, $08
    rst $08
    bit 7, a
    jr nz, jr_001_5f43

    cp d
    jr z, jr_001_5f82

    inc a
    jr jr_001_5f48

jr_001_5f43:
    cp $fe
    jr z, jr_001_5f82

    dec a

jr_001_5f48:
    rst $10
    jr jr_001_5f82

jr_001_5f4b:
    ld c, $05
    rst $08
    cp $97
    jr z, jr_001_5f82

    ld c, $08
    rst $08
    bit 7, a
    jr nz, jr_001_5f5e

    dec a
    jr z, jr_001_5f64

    jr jr_001_5f61

jr_001_5f5e:
    inc a
    jr z, jr_001_5f64

jr_001_5f61:
    rst $10
    jr jr_001_5f82

jr_001_5f64:
    ld c, $0a
    rst $08
    ld b, a
    and $f0
    cp $80
    jr z, jr_001_5f7a

    sla a
    ld c, a
    ld a, b
    and $0f
    or c
    ld c, $0a
    rst $10
    jr jr_001_5f82

Call_001_5f7a:
jr_001_5f7a:
    res 6, [hl]
    ld c, $08
    rst $08
    cpl
    inc a
    rst $10

jr_001_5f82:
    ld c, $15
    rst $08
    cp $04
    jr z, jr_001_5f8c

    cp $08
    ret nz

jr_001_5f8c:
    jp Jump_001_5db5


    ld a, [$c13d]
    or a
    ret z

    dec a
    ld [$c13d], a
    jr z, jr_001_5fa0

    ld c, a
    ldh a, [rLY]
    add c
    and $07

jr_001_5fa0:
    ld [$c13c], a
    ret


    ld a, [PlayerPositionYLsb]
    sub c
    ld [de], a
    inc e
    ld a, [PlayerPositionYMsb]
    sbc $00
    ld [de], a
    inc e
    inc e
    ld a, [PlayerPositionXLsb]
    ld [de], a
    inc e
    ld a, [PlayerPositionXMsb]
    ld [de], a
    pop hl
    ret


Jump_001_5fbd:
    ld a, [NextLevel2]
    or a
    ret z

    ld a, [$c1c9]
    or a
    ret nz

    ld [$c1e8], a
    dec a
    ld [$c1ca], a
    ld a, [NextLevel2]
    ld [CurrentLevel], a
    ld a, $20
    ld [$c1c9], a
    ld a, $4c
    ld [CurrentSong], a
    ret


    set 7, [hl]
    ld c, $10
    rst $08
    ld d, $c6
    ld e, a
    ld a, [de]
    or $80
    ld [de], a
    ld c, $06
    rst $08
    cp $90
    ret nc

    ld c, $11
    rst $08
    bit 3, a
    jr z, jr_001_5ffa

    ld a, $06

jr_001_5ffa:
    srl a
    ld b, a
    ld de, $c1a9
    add e
    ld e, a
    xor a
    ld [de], a
    ret


    inc d
    inc c
    ld [$0804], sp
    inc c
    inc d
    inc d
    inc c
    inc d
    inc c
    inc d
    inc c
    inc d
    ld hl, $3660
    ld h, b
    ld c, c
    ld h, b
    ld e, d
    ld h, b
    ld l, e
    ld h, b
    ld a, h
    ld h, b
    sub c
    ld h, b
    ld a, [bc]
    dec b
    jr nz, jr_001_602d

    jr nz, jr_001_602b

    rra
    ld a, [bc]
    jr nz, jr_001_6034

jr_001_602b:
    rst $38
    ld a, [bc]

jr_001_602d:
    jr nz, jr_001_6038

    rst $38
    ld a, [bc]
    jr nz, jr_001_6038

    rst $38

jr_001_6034:
    add hl, bc
    rst $38
    add hl, bc
    inc b

jr_001_6038:
    jr nz, jr_001_6042

    jr nz, jr_001_6046

    jr nz, @+$0b

    rst $38
    dec b
    jr nz, jr_001_604c

jr_001_6042:
    jr nz, jr_001_604d

    rst $38
    dec b

jr_001_6046:
    jr nz, jr_001_6055

    rra
    ld [$2004], sp

jr_001_604c:
    inc b

jr_001_604d:
    jr nz, jr_001_6057

    jr nz, jr_001_6059

    jr nz, jr_001_6057

    rra
    dec b

jr_001_6055:
    jr nz, @+$0c

jr_001_6057:
    jr nz, jr_001_6062

jr_001_6059:
    rst $38
    rlca
    inc b
    jr nz, jr_001_6062

    jr nz, jr_001_6064

    jr nz, jr_001_6066

jr_001_6062:
    jr nz, jr_001_6068

jr_001_6064:
    jr nz, jr_001_606a

jr_001_6066:
    jr nz, jr_001_606c

jr_001_6068:
    jr nz, @+$06

jr_001_606a:
    jr nz, jr_001_6074

jr_001_606c:
    inc b
    jr nz, @+$06

    jr nz, jr_001_6079

    ld hl, $2008

jr_001_6074:
    inc b
    jr nz, jr_001_607d

    jr nz, jr_001_6080

jr_001_6079:
    ld bc, $200b
    ld a, [bc]

jr_001_607d:
    inc b
    jr nz, @+$0a

Call_001_6080:
jr_001_6080:
    ld hl, $200b
    ld b, $20
    rlca
    ld bc, $200b
    ld b, $20
    rlca
    ld bc, $2006
    ld a, [bc]
    ld bc, $0608
    jr nz, @+$09

    ld bc, $2008
    inc b
    jr nz, jr_001_60a6

    ld hl, $210b
    dec c
    ld hl, $010c
    db $fc
    nop
    nop
    nop

jr_001_60a6:
    nop
    nop
    db $fc
    db $fc
    nop
    nop
    nop
    nop
    nop
    db $fc
    ld hl, sp-$04
    nop
    nop
    nop
    db $fc
    ld hl, sp+$00
    nop
    nop
    db $fc
    db $fc
    db $fc
    ld hl, sp-$08
    db $f4
    ldh a, [$ec]
    add sp, -$1c
    ldh [$dc], a
    ret c

    nop
    nop
    nop
    nop
    db $fc
    db $fc
    db $fc
    ld hl, sp-$08
    db $f4
    db $f4
    ldh a, [$f0]
    db $ec
    add sp, -$1c
    nop
    nop
    nop
    nop
    nop
    nop
    db $fc
    db $fc
    db $fc
    db $fc
    ld hl, sp-$08
    ld hl, sp-$0c
    db $f4
    ldh a, [rP1]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    inc b
    inc b
    inc b
    ld [$0808], sp
    inc c
    inc c
    stop
    nop
    nop
    nop
    inc b
    inc b
    inc b
    ld [$0c08], sp
    inc c
    db $10
    db $10
    inc d
    jr jr_001_6133

    nop
    nop
    nop
    inc b
    inc b
    inc b
    ld [$0c08], sp
    db $10
    inc d
    jr jr_001_6140

    jr nz, jr_001_614a

    jr z, @+$0c

    inc c
    ld c, $10
    ld [de], a
    inc d
    ld d, $18
    ld a, [de]
    inc e
    ld e, $20

jr_001_6133:
    dec c
    inc b
    ld de, $0b09
    ld b, $09
    nop
    add hl, bc
    ld [$0000], sp
    ld d, e

jr_001_6140:
    ld h, c
    ld l, l
    ld h, c
    ld [hl], l
    ld h, c
    sub a
    ld h, c
    xor c
    ld h, c
    cp a

jr_001_614a:
    ld h, c
    bit 4, c
    nop
    nop
    db $dd
    ld h, c
    rst $28
    ld h, c
    inc bc
    ld b, $08
    inc d
    dec de
    ld d, $1f
    db $10
    daa
    ld [$0c2b], sp
    ld sp, $350a
    inc c
    ld b, [hl]
    inc c
    ld c, c
    ld b, $4c
    nop
    ld d, b
    nop
    ld d, h
    nop
    inc bc
    ld [hl], h
    ld b, $2e
    dec d
    ld l, $16
    inc a
    stop
    ld a, [de]
    nop
    ld h, $06
    ld l, $06
    dec [hl]
    ld b, $38
    nop
    dec a
    ld b, $43
    nop
    ld d, b
    ld b, $54
    ld b, $5f
    ld b, $63
    nop
    ld l, b
    nop
    ld l, h
    nop
    ld [hl], b
    nop
    adc b
    nop
    sub h
    ld b, $03
    db $10
    rlca
    inc c
    ld a, [bc]
    nop
    dec d
    ld [$1020], sp
    ld b, d
    ld b, $4e
    ld c, $57
    db $10
    db $76
    ld a, [bc]
    ld [bc], a
    ld [de], a
    inc b
    ld e, $08
    jr jr_001_61bc

    ld [$2215], sp
    ld a, [de]
    ld [$141b], sp
    ld [hl+], a
    ld e, $25
    ld a, [bc]
    inc l

jr_001_61bc:
    jr nz, @+$31

    ld [de], a
    ld [bc], a
    inc e
    ld [bc], a
    jr z, jr_001_61d3

    ld c, $0e
    jr z, @+$24

    ld h, $37
    inc [hl]
    ld [bc], a
    ld a, [bc]
    ld [$1622], sp
    jr z, @+$1a

    inc [hl]

jr_001_61d3:
    dec e
    nop
    ld [hl-], a
    ld h, $3c
    inc c
    dec a
    jr jr_001_6219

    inc h
    ld [bc], a
    inc [hl]
    dec bc
    nop
    rrca
    nop
    inc de
    nop
    rra
    inc e
    dec h
    inc [hl]
    ld l, $18
    ld a, [hl-]
    ld c, $3c
    ld [hl-], a
    ld [bc], a
    ld e, $0b
    ld [de], a
    ld c, $2a
    rra
    ld [hl-], a
    jr nz, @+$20

    jr z, jr_001_6203

    inc l
    ld l, $30
    inc d
    ld [$100c], sp
    db $10

jr_001_6203:
    inc b
    inc b
    ld [$0808], sp
    ld [$0404], sp
    db $10
    db $10
    inc c
    ld [$0b04], sp
    inc c
    inc b
    dec bc
    inc c
    nop
    ld [$0008], sp

jr_001_6219:
    ld [$0008], sp
    inc b
    inc b
    nop
    nop
    nop
    nop
    nop
    db $fc
    nop
    nop
    ld hl, sp+$00
    nop
    ld hl, sp+$00
    nop
    db $f4
    nop
    nop
    db $f4
    nop
    nop
    db $f4
    nop
    nop
    db $fc
    nop
    nop
    nop
    nop
    inc b
    inc b
    inc b
    dec bc
    inc c
    db $fc
    ld hl, sp-$08
    db $f4
    inc bc
    dec b
    sbc e
    inc bc
    inc l
    inc b
    db $f4
    ld [bc], a
    add d
    nop
    sub h
    nop
    inc e
    ld [bc], a
    sbc $00
    add c
    rlca
    xor [hl]
    rlca
    ld h, d
    inc b
    jr nc, jr_001_625e

    ld h, a
    dec b
    rst $20

jr_001_625e:
    nop
    sbc b
    rlca
    ret c

    inc bc
    cp e
    rlca
    cp e
    inc b
    xor l
    rlca
    cp [hl]
    dec b
    xor [hl]
    rlca
    cp a
    dec b
    inc h
    ld bc, $0488
    ld [hl], h
    ld bc, $04e0
    db $10
    inc h
    ld bc, $0668
    ld [hl], h
    ld bc, $06c0
    ldh a, [rLY]
    ld bc, $03a8
    adc h
    ld bc, $0400
    db $10
    ld b, h
    ld bc, $0548
    adc h
    ld bc, $05a0
    ldh a, [rLY]
    ld [bc], a
    stop
    adc h
    ld [bc], a
    ld h, b
    nop
    ld bc, $0004
    stop
    ld c, h
    nop
    ld h, b
    nop
    rrca
    add h
    inc bc
    jr nc, jr_001_62a9

jr_001_62a9:
    call z, $8003
    nop
    ld de, $0344
    ret nc

    nop
    adc h
    inc bc
    jr nz, jr_001_62b7

    rst $38

jr_001_62b7:
    add h
    dec b
    adc b
    inc bc
    call z, $e005
    inc bc
    ld bc, $0000
    adc b
    inc bc
    inc l
    nop
    ldh [$03], a
    rrca
    call nz, Call_001_5005
    ld bc, $060c
    and b
    ld bc, $0411
    inc b
    ldh [rSB], a
    ld c, h
    inc b
    jr nc, jr_001_62dc

    rst $38
    and h

jr_001_62dc:
    inc b
    jr nc, jr_001_62df

jr_001_62df:
    db $ec
    inc b
    add b
    nop
    db $10
    and h
    inc b
    ld [hl], b
    ld [bc], a
    db $ec
    inc b
    ret nz

    ld [bc], a
    ldh a, [$c4]
    ld [bc], a
    or b
    ld bc, $030c
    nop
    ld [bc], a
    db $10
    call nz, $8802
    inc bc
    inc c
    inc bc
    ldh [$03], a
    ldh a, [rNR50]
    rlca
    db $10
    ld [bc], a
    ld l, h
    rlca
    ld h, b
    ld [bc], a
    db $10
    inc h
    rlca
    adc b
    inc bc
    ld l, h
    rlca
    ldh [$03], a
    ldh a, [$90]
    rlca
    sub b
    ld [bc], a
    ldh [rTAC], a
    ldh [rSC], a
    ld de, $0570
    adc b
    inc bc
    ret nz

    dec b
    ldh [$03], a
    rst $38
    sub b
    rlca
    sub b
    ld [bc], a
    ldh [rTAC], a
    ldh [rSC], a
    ld de, $0570
    adc b
    inc bc
    ret nz

    dec b
    ldh [$03], a
    rst $38
    dec sp
    inc a
    dec sp
    inc a
    dec a
    ld a, $3f
    ld c, b
    ld h, e
    ld h, b
    ld h, e
    ld h, b
    ld h, e
    ld c, b
    ld h, e
    dec d
    inc c
    ld [de], a
    inc d
    ld d, $16
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, b
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, c
    ld b, d
    ld b, d
    ld b, d
    ld b, d
    ld b, e
    ld b, e
    ld d, $16
    ld d, $16
    ld d, $16
    ld d, $16
    ld d, $16
    rla
    rla
    jr jr_001_6386

    jr @+$1a

    add hl, de
    add hl, de
    add hl, de
    add hl, de
    ld a, [de]
    ld a, [de]
    ld a, [de]
    ld a, [de]
    ld b, h
    ld b, l
    ld b, [hl]
    ld b, [hl]
    ld b, [hl]
    dec de
    dec de
    inc e
    inc e
    inc e
    dec e
    ld e, $9e
    sbc l

jr_001_6386:
    sbc [hl]
    ld e, $05
    ld d, $00
    ld [hl+], a
    ld hl, $0020
    jr nz, jr_001_63b1

    jr nz, jr_001_63e4

    ld d, d
    ld d, e
    ld d, h
    ld d, l
    ld d, h
    ld d, e
    ld l, [hl]
    ld l, a
    ld [hl], b
    ld [hl], c
    ld h, c
    ld e, d
    ld h, c
    ld e, d
    ld [hl], d
    ld [hl], e
    ld [hl], h
    ld [hl], l
    ld h, c
    db $76
    ld [hl], a
    ld e, d
    ld a, b
    ld bc, $7901
    ld a, d
    ld a, e
    ld a, h
    ld a, l

jr_001_63b1:
    ld a, b
    ld bc, $7901
    ld a, [hl]
    ld bc, $7f01
    nop
    ld bc, $3312
    ld b, h
    ld b, e
    ld [hl-], a
    ld de, $0000
    ld bc, $2211
    ld [hl+], a
    ld hl, $0011
    nop
    nop
    nop
    ld bc, $2111
    ld de, $0000
    nop
    nop
    rrca
    rst $38
    rst $28
    rst $38
    nop
    ld bc, $0503
    ld b, $05
    inc bc
    ld bc, $9789
    sbc d

jr_001_63e4:
    sbc e
    sbc h
    sbc l
    sbc [hl]
    sbc a
    and b
    ld a, [c]
    ld h, e
    ld [$2064], sp
    ld h, h
    inc l
    ld h, h
    and h
    ld b, $a5
    ld [$0aa6], sp
    and a
    inc c
    xor b
    ld e, $a7
    inc b
    and a
    inc h
    and [hl]
    ld a, [bc]
    and l
    ld [$06a4], sp
    xor l
    ld a, b
    inc c
    inc d
    dec bc
    inc d
    inc c
    inc d
    dec bc
    inc d
    inc c
    ld a, [bc]
    dec c
    inc b
    ld c, $14
    dec c
    ld [$0a0c], sp
    dec c
    inc b
    ld c, $14
    dec c
    ld [$0a17], sp
    jr jr_001_642e

    add hl, de
    ld [hl-], a
    jr @+$0c

    rla
    ld a, [bc]
    xor l
    sub [hl]
    nop
    or h

jr_001_642e:
    ld bc, $0208
    jr z, @+$03

    ld [$6438], sp
    ld b, d
    ld h, h
    nop
    nop
    ld bc, $0201
    inc bc
    inc b
    inc b
    inc b
    inc b
    ld b, d
    ld b, e
    ld b, e
    ld b, h
    ld b, l
    ld b, h
    ld b, e
    ld b, e
    ld b, d
    xor l
    jr @+$36

    ld [$0835], sp
    ld [hl], $08
    scf
    jr nc, jr_001_6497

    db $10
    ld b, d
    ld [$1043], sp
    ld b, d
    ld [$0841], sp
    ld b, c
    ld [$0842], sp
    ld b, e
    db $10
    ld b, d
    ld [$1041], sp
    scf
    jr @+$38

    ld [$0835], sp
    inc [hl]
    ld [$18ad], sp
    ld b, b
    ld h, b
    ccf
    db $10
    ld a, $10
    dec a
    db $10
    inc a
    db $10
    xor l
    jr jr_001_64b0

    ld [$0831], sp
    ld [hl-], a
    ld [$1833], sp
    ld b, h
    db $10
    ld b, l
    ld [$1046], sp
    ld b, l
    ld [$0844], sp
    ld b, h
    ld [$0845], sp
    ld b, [hl]
    db $10

jr_001_6497:
    ld b, l
    ld [$1044], sp
    inc sp
    jr jr_001_64d0

    ld [$0831], sp
    jr nc, jr_001_64ab

    xor l
    jr @+$3d

    ld h, b
    ld a, [hl-]
    db $10
    add hl, sp
    db $10

jr_001_64ab:
    jr c, jr_001_64bd

    xor l
    db $10
    cp c

jr_001_64b0:
    ld a, [bc]
    cp d
    nop
    or a
    dec b
    cp b
    nop
    or l
    dec b
    or [hl]
    nop
    or e
    ld a, [bc]

jr_001_64bd:
    or h
    nop
    or l
    dec b
    or [hl]
    nop
    or a
    dec b
    cp b
    nop
    cp e
    ld a, [bc]
    cp h
    nop
    cp l
    dec b
    cp [hl]
    nop
    cp a

jr_001_64d0:
    inc d
    ret nz

    nop
    pop bc
    dec b
    jp nz, $bb00

    dec b
    cp h
    nop
    cp l
    ld a, [bc]
    cp [hl]
    nop
    call $c910
    push bc
    adc $04
    jp z, $cfc6

    inc b
    set 0, a
    ret nc

    inc b
    call z, $d1c8
    inc b
    pop de
    pop de
    pop de
    db $10
    pop de
    pop de
    ret nc

    inc b
    call z, $cfc8
    inc b
    set 0, a
    adc $04
    jp z, $cdc6

    ld [$c5c9], sp
    pop de
    db $10
    pop de
    pop de
    pop de
    inc b
    pop de
    jp nc, Jump_000_04d1

    pop de
    db $d3
    pop de
    inc b
    pop de
    call nc, Call_000_04d1
    pop de
    push de
    pop de
    db $10
    pop de
    pop de
    pop de
    inc b
    jp nc, $d1d1

    inc b
    db $d3
    pop de
    pop de
    inc b
    call nc, $d1d1
    inc b
    push de
    pop de
    pop de
    db $10
    pop de
    pop de
    jp nc, $d104

    pop de
    db $d3
    inc b
    pop de
    pop de
    call nc, $d104
    pop de
    push de
    inc b
    pop de
    pop de
    call $c908
    push bc
    sub $02
    ret


    push bc
    rst $10
    ld [bc], a
    ret


    push bc
    ret c

    ld [bc], a
    ret


    push bc
    reti


    ld [bc], a
    ret


    push bc
    jp c, $c902

    push bc
    db $db
    ld [bc], a
    ret


    push bc
    call $c908
    push bc
    call nz, $c914
    jp Jump_000_0409


    ld a, [bc]
    nop
    dec bc
    inc b
    inc c
    nop
    ld bc, $0204
    nop
    inc bc
    inc b
    inc b
    nop
    dec b
    inc b
    nop
    nop
    ld b, $04
    nop
    nop
    rlca
    inc b
    ld [$1800], sp
    ld [$0000], sp
    add hl, bc
    inc b
    ld a, [bc]
    nop
    dec bc
    inc b
    inc c
    nop
    dec c
    inc b
    ld c, $00
    rrca
    inc b
    stop
    ld de, $1204
    nop
    inc de
    inc b
    nop
    nop
    inc d
    inc c
    dec d
    nop
    add hl, bc
    inc b
    ld a, [bc]
    nop
    dec bc
    inc b
    inc c
    nop
    ld a, [de]
    inc b
    dec de
    nop
    inc e
    inc b
    dec e
    nop
    ld e, $04
    rra
    nop
    jr nz, jr_001_65bd

    ld hl, $2200
    inc c

jr_001_65bd:
    inc hl
    nop
    jr nz, @+$0a

    ld hl, $2200
    db $10
    inc hl
    nop
    db $e4
    ld b, $e5
    nop
    and $06
    rst $20
    nop
    add sp, $06
    jp hl


    nop
    ld [$eb06], a
    nop
    db $ec
    ld b, $ed
    nop
    xor $06
    rst $28
    nop
    db $e4
    inc c
    push hl
    nop
    ld a, [c]
    ld [$0000], sp

jr_001_65e7:
    db $e4
    ld b, $e5
    nop
    and $06
    rst $20
    nop
    add sp, $06
    jp hl


    nop
    ld [$eb06], a
    nop
    db $ec
    ld b, $ed
    nop
    xor $06
    rst $28
    nop
    db $e4
    jr nz, jr_001_65e7

    nop

jr_001_6603:
    and $06
    rst $20
    nop
    add sp, $06
    jp hl


    nop
    ld [$eb06], a
    nop
    db $ec
    ld b, $ed
    nop
    xor $06
    rst $28
    nop
    ldh a, [$0c]
    pop af
    nop
    db $e4
    jr nz, jr_001_6603

    nop
    nop
    ld [bc], a
    ld bc, $0103
    nop
    ld [bc], a
    inc bc
    ld [bc], a
    nop
    inc bc
    ld bc, $0302
    nop
    ld bc, $0000
    nop
    ld de, $2100
    nop
    ld sp, $0041
    ld d, c
    ld bc, $0000
    ld h, c
    nop
    ld [hl], c
    nop
    nop
    add c
    nop
    nop
    ld de, $3121
    ld b, c
    nop
    ld d, c
    ld bc, $0061
    ld [hl], c
    ld bc, $9141
    dec b
    dec b
    dec b
    nop
    ld [bc], a
    inc bc
    inc b
    ld bc, $8585
    add l
    nop
    inc bc
    inc b
    ld [bc], a
    ld bc, $0005
    inc b
    ld [bc], a
    inc bc
    ld bc, $8585
    add l
    nop
    ld [bc], a
    inc b
    inc bc
    ld bc, $0505
    nop
    inc bc
    ld [bc], a
    inc b
    ld bc, $0000
    ld bc, $0000
    ld bc, $0000
    ld bc, $0002
    nop
    ld bc, $0000
    ld bc, $0302
    ld bc, $0000
    ld bc, $0202
    ld bc, $0000
    ld bc, $0302
    nop
    ld bc, $1080
    jr nz, @+$05

    ld [bc], a
    inc bc
    jr nc, jr_001_66df

    ld d, b
    jr nz, jr_001_6703

    ld [bc], a
    inc bc
    ret nc

    ldh [rP1], a
    ldh a, [rP1]
    ldh [$d1], a
    ld [bc], a
    inc bc
    sub b
    and b
    or b
    pop bc
    db $10
    ld [hl], b
    ld d, c
    ld bc, $24e0
    jr nz, jr_001_66b9

jr_001_66b9:
    ret nz

    jr nc, jr_001_66dc

    ld [hl-], a
    xor h
    jr nc, jr_001_66e0

    ld [hl-], a
    add b
    inc h
    ld h, b
    nop
    nop
    jr jr_001_66c8

jr_001_66c8:
    dec b
    inc d

jr_001_66ca:
    dec b
    jr z, jr_001_66d2

    inc a
    dec b
    ld d, b
    dec b
    ld h, h

jr_001_66d2:
    ld [$0700], sp
    jr nz, @+$09

    inc a
    rlca
    ld e, b
    ld [bc], a
    nop

jr_001_66dc:
    rlca
    jr nz, jr_001_66e6

jr_001_66df:
    inc a

jr_001_66e0:
    ld b, $3c
    rlca
    ld c, b
    ld a, b
    ld e, b

jr_001_66e6:
    sub b
    ld hl, sp-$80
    ld bc, $fc13
    and b
    rrca
    ld de, $50fe
    ld bc, $f817
    ld [hl], b
    rrca
    dec d
    ld hl, sp+$50
    ld bc, $f815
    and b
    rrca
    inc de
    sbc d
    ld a, b
    nop
    ret nc

jr_001_6703:
    nop
    ret nz

    sbc h
    sbc b
    nop
    ret c

    nop
    cp b
    nop
    ret z

    sbc [hl]
    adc b
    nop
    nop
    nop
    ld bc, $0000
    rst $38
    ld bc, $0000
    rst $38
    ld bc, $0000
    rst $38
    ld bc, $0100
    nop
    ld bc, $0000
    rst $38
    nop
    rst $38
    nop
    rst $38
    rst $38
    nop
    nop
    sub l
    nop
    sub [hl]
    nop
    sub l
    jr nz, jr_001_66ca

    ld b, b
    inc b
    nop
    db $fc
    nop
    inc b
    nop
    db $fc
    nop
    inc b
    nop
    db $fc
    nop
    nop
    nop
    nop
    nop
    nop
    db $fc
    nop
    inc b
    inc bc
    db $fd
    db $fd
    inc bc
    inc bc
    inc bc
    db $fd
    db $fd
    nop
    nop
    nop
    nop
    inc b
    nop
    db $fc
    nop
    db $fd
    db $fd
    inc bc
    inc bc
    inc bc
    db $fd
    db $fd
    inc bc
    ldh a, [$f0]
    ldh a, [rP1]
    or b
    ret nz

    ret nz

    nop
    ldh a, [$30]
    jr nc, @+$3c

    ld a, [hl-]
    ld a, [hl-]
    nop

jr_001_6770:
    ld c, b
    ld b, a
    ld b, a
    nop
    ld c, d
    ld c, d
    ld c, d
    dec hl
    dec hl
    dec hl
    nop
    ld a, [hl+]
    rra
    rra
    nop
    add hl, sp
    add hl, sp
    add hl, sp
    ld a, [hl+]
    dec hl
    ld a, [hl+]
    ld b, d
    dec a
    ld sp, $4839
    dec hl
    dec l
    add hl, bc
    nop
    and [hl]
    ld h, a
    ld a, a
    ld l, c
    adc l
    ld l, e
    ld c, a
    ld l, l
    inc de
    ld [hl], b
    call $3772
    ld [hl], l
    rst $20
    ld [hl], a
    push de
    ld a, c
    rst $38
    ld a, e
    ld b, e
    ld a, [hl]
    nop
    nop
    ldh a, [$03]
    push de
    ld bc, $6010
    ld b, $60
    nop
    inc d
    inc c
    adc h
    ld b, $02
    ld b, [hl]
    ld b, [hl]
    inc b
    ret c

    ld bc, $0620
    sbc b
    ld b, $01
    ld b, d
    inc e
    ld h, h
    ld [hl], l
    ld b, b
    rla
    rrca
    jr jr_001_6838

    dec bc
    ld [$8c1a], sp
    ld a, [bc]
    inc de
    dec b
    ldh a, [$2e]

jr_001_67d0:
    cp b
    ld [de], a
    inc b
    ld e, h
    or c
    pop de
    dec hl
    ld l, d
    rlca
    add b
    adc c
    ld [bc], a
    jr @+$03

    ld b, $08
    db $10
    adc h
    ld [de], a
    ld c, b
    dec c
    or b
    ld b, h
    sbc b
    ld bc, $2001
    ld b, h
    jr nc, jr_001_6770

    add a
    dec b
    nop
    and b
    inc l
    nop
    ld b, b
    ld [hl+], a
    ld [hl], h
    ld b, c
    ret nz

    ld b, b
    add b
    inc c
    ld hl, $4000
    ld h, [hl]
    db $10
    ld [$44b0], sp
    jr z, jr_001_6806

jr_001_6806:
    nop
    ld a, [de]
    ld [bc], a
    nop
    inc de
    adc $80
    ld h, b
    ld [hl+], a
    sbc b
    or b
    ld [bc], a
    db $10
    ld h, c
    ld h, h
    rla
    nop
    adc d
    ld b, e
    ld h, $10
    inc a
    jr jr_001_6877

    inc d
    add b
    ld b, $a0
    dec h
    jr @+$20

jr_001_6825:
    adc h
    ld l, h
    ld a, [bc]
    inc b
    ret nz

    ld b, [hl]
    cp b
    or b
    nop
    nop
    ld b, d
    nop
    jr nc, jr_001_6825

    ld [$6000], sp
    jr z, @+$2a

jr_001_6838:
    db $10
    ldh a, [$99]
    dec b
    ld b, b
    ld c, $80
    cp [hl]
    ld b, [hl]
    add h
    ld de, $0054
    ld d, b
    ld [hl+], a
    jr jr_001_685e

    ldh a, [$3a]
    ld h, b
    inc b
    ld l, e
    jr nz, jr_001_67d0

    ld [$80a6], sp
    ld c, h
    ret nz

    ld [$0582], sp
    inc hl
    jr c, @+$7a

    ld bc, $5180

jr_001_685e:
    nop
    ld a, $40
    dec b
    ld [de], a
    add b
    sub a
    jp nz, $1180

    add c
    add d
    jr nz, jr_001_68b4

    dec l
    add b
    dec e
    ld b, d
    nop
    ld c, b
    nop
    ld b, h
    ld hl, $68c1

jr_001_6877:
    db $10
    inc e
    ld d, b
    nop
    add b
    add hl, hl
    nop
    ld d, $40
    and b
    pop bc
    ld [$1028], sp
    nop
    rlca
    ld d, $00
    cp h
    jp Jump_001_4608


    dec b
    di
    jr nc, jr_001_6891

jr_001_6891:
    ld e, h
    ldh [rP1], a
    ld [de], a
    db $10
    inc a
    sub b
    pop de
    inc b
    add b

jr_001_689b:
    ld bc, $1200
    jr jr_001_68b0

    adc h
    ld [de], a
    ld [$4921], sp
    nop
    ld b, b
    dec c
    xor [hl]
    ld b, b
    ret nz

    and b
    ld b, $1a
    nop
    ret nz

jr_001_68b0:
    ld a, [bc]
    ld h, b
    inc b
    ld b, a

jr_001_68b4:
    jr nz, jr_001_68f6

jr_001_68b6:
    jr nc, jr_001_68f2

    ld [hl], h
    rlca
    jr nz, jr_001_68fe

    add b
    ld b, d
    nop
    ld d, b
    ei
    add b
    dec h
    ld b, l
    add b
    ld a, [de]
    nop
    ld e, h
    ld h, b
    ld b, b
    sub b
    ld a, [hl-]
    call nc, Call_000_2007
    add hl, de
    nop
    ld [$6400], sp
    ld [hl], b
    ld e, b
    jr nc, @+$04

    ld bc, $0013
    db $dd
    dec b
    ld b, h
    add d
    inc a
    db $10
    inc l
    jr nc, jr_001_6925

    ld b, b
    ld [$b000], sp
    ld [$0210], sp
    ld b, b
    rrca
    ld c, b
    ld bc, $010e
    ld e, b

jr_001_68f2:
    ld b, b
    ld bc, $0b00

jr_001_68f6:
    inc de
    dec b
    jr nz, jr_001_6902

    inc [hl]
    dec b
    jr nz, @+$15

jr_001_68fe:
    nop
    ld a, [bc]
    nop
    ld l, b

jr_001_6902:
    ld h, b
    jr nc, jr_001_6907

    ld [bc], a
    rla

jr_001_6907:
    inc b
    jr @-$7d

    rlca
    nop
    dec c
    jr jr_001_689b

    and b
    ld hl, $2001
    ld c, b
    ld [bc], a
    add b
    nop
    add b
    ld de, $000a
    ld [bc], a
    ld a, [de]
    nop
    ld b, [hl]
    inc b
    ld bc, $0600
    inc b
    dec b

jr_001_6925:
    ld h, b
    ld [hl+], a
    jr z, @+$1a

    nop
    ld [$000a], sp
    jr nz, jr_001_692f

jr_001_692f:
    ld b, b
    nop
    ld b, l
    ld b, h
    jr jr_001_68b6

    ld bc, $0c80
    db $10
    inc h
    jp nz, RST_28

    cpl
    ld h, c
    db $10
    ld de, $a046
    nop
    ret nc

    dec bc
    adc c
    add l
    adc b
    sub b
    ld [bc], a
    add b
    jr nz, @-$1e

    inc h
    ld c, b
    add h
    ld de, $813c
    and $40
    ld [hl+], a
    and h
    ld h, b
    inc b
    inc b
    ld de, $0461
    ld e, $00
    or l
    or b
    ld e, c
    add b
    ld [$6023], sp
    nop
    xor b
    add e
    adc $c2
    add e
    ld d, c
    ldh [rLCDC], a
    rla
    ld hl, sp-$7c
    inc b
    nop
    ld [$4008], sp
    inc b
    add l
    ld b, b
    add b
    ld [$0200], sp
    ld [$0a04], sp
    ld [bc], a
    db $10
    ld b, b
    rra
    add b
    nop
    inc d
    inc c
    adc h
    ld d, $f1
    dec b
    sub h
    ld b, e
    cp h
    nop
    sub d
    nop
    call z, $8082
    inc de
    ld c, $04
    add b
    push af
    ld e, $18
    add c
    ld e, $00
    inc b
    db $10
    inc h
    jp nz, Jump_000_00e8

    ld d, [hl]
    db $10
    ld de, HeaderSGBFlag
    xor b
    db $10
    ld e, h
    ld b, b
    db $10

jr_001_69b1:
    ld de, $e046
    dec b
    or b
    add e
    adc c
    jr nc, @+$24

    add b
    db $10
    inc a
    jr jr_001_69cc

    inc d
    call nz, $1001
    add b
    ld b, h
    ret z

    ld b, d
    add b
    ld e, d
    ld bc, $06aa

jr_001_69cc:
    ld b, [hl]
    ld c, a
    inc b
    jr nc, jr_001_69d1

jr_001_69d1:
    add h
    ld b, $a3
    pop bc
    ld [hl], b
    ld hl, sp+$7d
    nop
    dec hl
    ld b, b
    ld [$0869], sp
    ld c, h
    ld a, [de]
    inc d
    dec d
    ld bc, $62e3
    call nc, Call_000_0035
    add hl, bc
    db $10
    dec l
    inc d
    ld c, b
    add hl, bc
    inc b
    inc c
    or b
    ld [bc], a
    jr nz, jr_001_6a02

    jr nz, jr_001_69f7

    ld a, [bc]

jr_001_69f7:
    ld [$0346], sp
    ld e, h
    ld de, $0038
    ld h, b
    inc d
    nop
    add hl, sp

jr_001_6a02:
    nop
    add hl, hl
    ld d, b
    ld h, b
    jr z, jr_001_6a48

    ld b, l
    inc bc
    ld [bc], a
    ld b, c
    add b
    jr z, jr_001_69b1

    inc bc
    ld b, b
    ld d, b
    nop
    ret nz

    ld a, [bc]
    add b
    inc hl
    jr nz, @+$04

    ld c, e
    ld [$4ac0], sp
    add b
    jr nz, @+$62

    call nc, Call_000_0b01
    dec h
    nop
    ld h, d
    jr nz, jr_001_6a39

    ld b, [hl]
    and b
    nop
    add b
    inc bc
    adc b
    sub b
    sub d
    nop
    ld b, b
    ld a, $80
    cpl
    ld b, b
    add h
    sub c
    inc e

jr_001_6a39:
    nop
    or h
    ld bc, $0170
    ld [hl+], a
    or b
    inc b
    nop
    ld [$900b], sp
    ld bc, $000c

jr_001_6a48:
    ld b, [hl]
    dec de
    and h
    nop
    ld [bc], a
    nop
    add a
    jr @+$24

    adc h
    call nz, $c000
    dec b
    ret nz

    inc bc
    ld d, d
    ld bc, $1200
    inc c
    ld b, [hl]
    sub d
    nop
    adc [hl]
    ld bc, $02b6
    xor c
    rlca
    ld bc, $a026
    nop
    add b
    add c
    add c
    ld [bc], a
    add c
    sub c
    ld c, h
    ld bc, $01c8
    ld [hl], h
    add b
    ld bc, $a422
    ld a, [bc]
    ret nz

    dec bc
    jr nz, jr_001_6a7f

    ld a, [bc]

jr_001_6a7f:
    ld de, $7461
    ld c, [hl]
    nop
    ld e, $b0
    nop
    nop
    ld [hl], d
    ld h, b
    jr nc, @+$34

    add hl, hl
    nop
    ld a, [de]
    ret nz

    ld bc, $3858
    ld [$a180], sp
    ld b, a
    nop
    nop
    ld b, e

jr_001_6a9a:
    ld b, c
    add c
    ld b, b
    dec bc
    ld l, l
    ld [bc], a
    nop
    ld b, [hl]
    jr nz, @+$03

    ld b, $23
    db $10
    db $10
    and b
    ld bc, $1180
    add sp, $01
    ldh a, [rP1]
    ret nz

    add sp, -$1b
    ld e, a
    add b
    ret nz

    inc b
    inc d
    ld [$4210], sp
    or b
    nop
    ldh a, [rP1]
    ld [bc], a
    add b
    pop de
    inc b
    ld h, $50
    nop
    ld e, b
    xor h
    nop
    ret nz

    nop
    ld h, b
    add b
    inc a
    add b
    nop
    ld b, $82
    ld de, $3a10
    jr nc, jr_001_6b13

    ld b, d
    nop
    add c
    nop
    sub [hl]
    ld b, b
    rra
    ret nz

    ld c, e
    ld b, b

jr_001_6ae1:
    ld b, b
    add b
    ld b, c
    ld b, h
    nop
    adc h
    inc c
    ld [bc], a
    nop
    ld b, [hl]
    ret nz

    ld e, b
    ldh [$60], a
    ld [$c001], sp
    ld b, $b0
    adc c
    ld b, $26
    adc h
    nop

jr_001_6af9:
    add b
    ld d, c
    add b
    ld b, c
    dec c
    jr nc, jr_001_6b18

    ld b, c
    ld b, b
    dec bc
    ld [bc], a
    adc h
    ret nz

    add hl, bc
    jr nc, jr_001_6b10

    ld bc, $1d52
    or b
    ret nz

    ld b, $00

jr_001_6b10:
    ld b, $0c
    ld d, d

jr_001_6b13:
    ret nc

    add c
    ld bc, $0126

jr_001_6b18:
    jr z, jr_001_6a9a

    pop bc
    add d
    ld de, $9e0a
    jr nz, jr_001_6ae1

    ld [$0044], sp
    ld [hl+], a
    add b
    nop
    adc b
    dec d
    pop bc
    ld [$471d], sp
    db $10
    ld h, b
    inc b
    ld e, d
    nop
    rla
    nop
    ld [bc], a
    ldh a, [$72]
    jr nz, jr_001_6af9

    ld c, d
    ld [$1800], sp
    ld hl, $02e1
    nop
    inc a
    inc b
    ld b, b
    dec c
    nop
    ld a, [bc]
    sub b
    nop
    cp h
    inc [hl]
    db $10
    adc h
    ld h, b
    ret nz

    dec b
    nop
    ld b, [hl]
    ld bc, $0320
    add b
    nop
    inc h
    nop
    ld bc, $0008
    inc hl
    add d
    nop
    nop
    sub e
    ld b, d
    nop
    ret nz

    ld [$040c], sp
    nop
    nop
    ld bc, $1c04
    add b
    inc h
    ld h, b
    dec b
    nop
    and h
    ld sp, $1460
    ldh [rNR41], a
    jr nz, jr_001_6ba7

    ld a, [$400f]
    ld b, $80
    ld [$3960], sp
    nop
    ld c, c
    ld b, b
    nop
    ld b, d
    nop
    nop
    add c
    and c
    ld [$0200], sp
    ldh a, [$03]
    cp [hl]
    ld bc, $0080
    jr nz, jr_001_6b95

jr_001_6b95:
    rlca
    and b
    ld h, b
    ld h, b
    inc [hl]
    db $10
    jr nc, jr_001_6bcf

    ld [hl+], a
    ret nz

    rlca
    nop
    ld c, h
    ret nz

    inc [hl]
    inc c
    ld [hl-], a
    ld h, e

jr_001_6ba7:
    ld h, b
    add hl, hl
    inc a
    ld h, b
    ld [hl], h

jr_001_6bac:
    sbc b
    rrca
    ld b, c
    nop
    inc a
    rlca
    dec c
    ld b, [hl]
    rlca
    sbc c
    ld d, b
    ld b, d
    ld d, e
    jr nc, jr_001_6bcc

    ld e, b
    inc bc
    ld bc, $308a
    ld a, [hl+]
    ld [$844c], sp
    ld de, $81a0
    ld h, b
    ld [hl+], a
    adc h
    and b
    dec d

jr_001_6bcc:
    inc b
    ld a, [bc]
    ld b, [hl]

jr_001_6bcf:
    dec c
    adc e
    add b
    add hl, hl
    ld [de], a
    ld hl, $8209
    sub b
    ld [$0010], sp
    ld b, b
    ld a, [bc]
    inc b
    add a
    add hl, de
    ld de, $0036
    ldh [rNR21], a
    pop bc
    ld l, b
    nop
    inc e
    ld a, b
    jr nz, jr_001_6bac

    ld [$4023], sp
    ld h, b
    ld de, $0346
    ld bc, $308a
    ld [hl-], a
    ld [$8450], sp
    ld d, c
    ld b, d

jr_001_6bfc:
    jr nz, @+$24

    adc h
    ld h, b
    nop
    jr nz, jr_001_6c1f

    adc [hl]
    ld a, [bc]
    nop
    ld b, d
    jr jr_001_6c61

    ld c, $03
    nop
    db $10
    jr z, jr_001_6c17

    ld bc, $084e
    rlca
    nop
    jr nz, jr_001_6c56

    nop

jr_001_6c17:
    ldh a, [$82]
    dec b
    db $10
    jr nz, jr_001_6c35

    dec c
    ld [hl], b

jr_001_6c1f:
    jp nz, Jump_001_4604

    ret nc

    ld bc, $0402
    and e
    ld b, d
    ld d, h
    ld a, b
    nop
    dec bc
    adc [hl]
    ld b, b
    or b
    ld h, b
    inc b
    ld [de], a
    nop
    sub b
    and d

jr_001_6c35:
    add hl, bc
    inc b
    ld c, b
    ld hl, $1804
    adc h
    ld [bc], a

jr_001_6c3d:
    ld c, b
    ld d, c
    ld b, $00
    sbc b
    and b
    inc e
    inc b
    inc c
    ld b, [hl]
    ret nz

    ld bc, $a300

jr_001_6c4b:
    nop
    ld b, d
    ld [$2103], sp
    ld b, b
    jr nc, jr_001_6c6d

    jr nz, @-$7a

    add b

jr_001_6c56:
    ld bc, $a300
    nop
    ld [hl], b
    nop
    and b
    adc c
    ld [bc], a
    add b
    nop

jr_001_6c61:
    ld b, h
    add b
    ld e, d
    nop
    ld hl, $0824
    nop
    ld c, $30
    jr jr_001_6c6d

jr_001_6c6d:
    inc b
    ld b, l
    ld hl, $28c0
    ld hl, $60f0
    inc h
    dec d
    nop
    jr nc, jr_001_6bfc

    ld e, a
    db $10
    ld b, b
    add h
    ld de, $0a01
    nop
    call c, $a904
    ld b, c
    db $10
    ld c, $28
    nop
    ld h, b
    ld h, c
    and d
    db $10
    ld b, b
    ld b, $04
    nop
    jr nz, jr_001_6cd7

    nop
    jr nc, jr_001_6c99

    dec c
    db $10

jr_001_6c99:
    inc l
    jr nc, jr_001_6c3d

    ret nz

    ld a, [bc]
    ld b, $8c
    ret nz

    rrca
    ld b, b
    nop
    ld [bc], a
    ld a, [bc]
    ld [$b046], sp
    db $10
    add d
    nop
    inc hl
    jr nz, jr_001_6caf

jr_001_6caf:
    ld h, b
    add hl, bc
    sub b
    add d
    add b
    ld de, $0042
    ret nz

    jr z, @+$23

    nop
    ld h, b
    inc b
    add hl, bc
    rrca
    nop
    ldh a, [$50]
    nop
    jr nc, jr_001_6cc7

    dec l
    db $10

jr_001_6cc7:
    inc l
    jr jr_001_6c4b

    add c
    dec bc
    ld b, $8c
    jr nz, jr_001_6cdd

    inc b
    dec bc
    ld b, [hl]
    ld d, b
    ret nc

    add d
    nop

jr_001_6cd7:
    inc hl
    ld e, b
    nop
    jr z, jr_001_6ce1

    ld [bc], a

jr_001_6cdd:
    add d
    pop de
    ret nz

    inc h

jr_001_6ce1:
    ret nc

    nop
    add b
    ld d, c
    nop
    jr jr_001_6ce8

jr_001_6ce8:
    ld c, b
    inc b
    add hl, bc
    ret nz

    dec bc
    ld [hl+], a
    ret nc

    dec hl
    nop
    add b
    ld b, b
    add c
    nop
    jr c, jr_001_6cd7

    ld h, b
    nop
    nop
    ld [$0085], sp
    dec [hl]
    add b
    add b
    ld bc, $05d9
    and [hl]
    add b
    ret nz

    ld b, h
    sub b
    ld hl, $0806
    ld h, $82
    inc c
    ld b, c
    ld b, b
    ld h, b
    ld b, b
    db $76
    pop bc
    ld c, e
    jr nz, jr_001_6d67

    ld h, b
    ld b, h
    db $10
    ld d, b
    jr nc, @+$44

    ld a, [de]
    db $10
    inc d
    jr @+$17

    inc b
    inc d
    adc h
    ret nc

    dec h
    inc b
    dec b
    ld b, [hl]
    nop
    ld bc, $2305
    or h
    add hl, bc
    ld b, c
    add c
    ld d, c
    ld b, b
    ld b, b
    pop bc
    ld [$6025], sp
    ld h, b
    inc h
    db $10
    jr c, jr_001_6d6e

    ld [hl-], a
    ld bc, $400a
    and l
    cp b
    jr nc, jr_001_6d4e

    ld c, c
    ld b, b
    ret nz

    add b
    ld bc, $08a1
    nop

jr_001_6d4e:
    ld [bc], a
    jr nc, @+$08

    ret nz

    ld [bc], a
    inc b
    cp b
    ld bc, $01e0
    dec b
    ld [bc], a
    and e
    ret nz

    or d
    sbc b
    ld [$0102], sp
    ld [hl+], a
    ld h, [hl]
    nop
    ld b, b
    dec c
    inc sp

jr_001_6d67:
    jr nz, jr_001_6dc9

    adc a
    inc bc
    ld bc, $5280

jr_001_6d6e:
    inc a
    ld b, b
    sub h
    dec b
    adc h
    ld [bc], a
    ld h, [hl]
    ld h, h
    inc b
    and [hl]
    ld bc, $089c
    jr @+$12

    jr nc, jr_001_6d89

    ldh [$90], a
    ld bc, $4298
    add h
    ld de, $8150
    nop

jr_001_6d89:
    ld b, c
    ld l, d
    nop
    ld e, $02
    dec b
    ld [bc], a
    adc h
    ld [bc], a
    ld a, b
    ld hl, $1004
    adc h
    ld a, [bc]
    ld a, b
    dec h
    jr nc, jr_001_6dfe

    ld [$3000], sp
    add l
    ld [$9023], sp
    ld b, $01
    ld [bc], a
    db $d3
    and b
    inc l
    sub b
    ret nz

    add b
    ld de, $004c
    ret nz

    jr z, jr_001_6dd2

    ret nc

    ld h, b
    inc h
    ld [bc], a
    rra
    nop
    db $ed
    ret nz

    ld a, [bc]
    ld sp, hl
    ld [bc], a
    nop
    and b
    db $10
    sub b
    ld e, d
    ld [$c004], sp
    inc hl
    ld [hl], h
    jr nz, jr_001_6d89

jr_001_6dc9:
    jr z, jr_001_6dcb

jr_001_6dcb:
    ld d, [hl]
    nop
    and e
    sub b
    ld b, b
    add e
    pop de

jr_001_6dd2:
    ld c, c
    nop
    add b
    ret


    nop

jr_001_6dd7:
    dec b
    ldh [$81], a
    db $10
    sbc h
    adc e
    ld bc, $909c
    ld [hl+], a
    db $10
    ret nz

    adc h
    or b
    add c
    ld bc, $2823
    ld bc, $0001
    db $d3
    adc b
    sub b
    ld [de], a
    ld [$044c], sp
    inc de
    call nz, Call_001_6080
    ld [hl+], a
    sbc b
    ldh [rTMA], a
    inc b
    inc de
    pop bc

jr_001_6dfe:
    inc b
    ld a, e
    jr nz, jr_001_6e02

jr_001_6e02:
    ld h, b
    ld a, [de]
    ld de, $0b52
    add c
    adc c
    ld h, b
    ld [bc], a
    ld e, a
    stop
    jr nc, @-$79

    ld [$b023], sp
    ld b, $01
    nop
    db $d3
    ld [bc], a
    and e
    ld b, $02
    add hl, bc
    rra
    nop
    jp c, Jump_000_0ae0

    ld l, c
    nop
    sbc h
    add $0e
    ld b, [hl]
    ld e, b
    add c
    nop
    and [hl]
    db $10
    ld h, c
    inc b
    jr jr_001_6e30

jr_001_6e30:
    jr nc, @+$04

    ld [$1834], sp
    add l
    ret nz

    rlca
    and b
    ld a, $b8
    ld b, d
    add d
    nop
    db $10
    jr z, @+$04

    add b
    ld sp, $da81
    jr nz, @+$39

jr_001_6e47:
    ld b, h
    ld c, $00
    or [hl]
    ld h, d
    inc b
    and e
    add c
    cp e
    ld [$081c], sp
    jr nc, jr_001_6dd7

    ld a, [bc]
    nop
    ld hl, sp-$1f
    dec b
    inc hl
    ldh a, [rLCDC]
    add b
    ld d, c
    nop
    inc a
    inc b
    add hl, hl
    db $10
    jr nz, @+$1a

    dec c
    ld [de], a
    ld b, d
    or b
    ld b, b
    add b
    ld de, $004c
    add h
    ld [bc], a
    and c
    add c
    ld l, c
    add b
    ld de, $0058
    and h

jr_001_6e79:
    ld [bc], a
    ld bc, $68c1
    ldh [$2e], a
    ld [bc], a
    dec b
    nop
    adc h
    ld [bc], a
    add a
    ld hl, $03b8
    add hl, bc
    ret nz

    ld c, e
    ld hl, $0c00
    inc bc
    ld h, b
    db $e3
    nop
    inc hl
    ld d, b
    stop
    nop
    add h
    ld [bc], a
    add b
    ld de, $8086
    ld h, b
    ld [hl+], a
    adc h
    ld h, b
    dec bc
    inc b
    rrca
    ld b, [hl]
    dec b
    and h
    ld c, $02
    inc de

jr_001_6eaa:
    ld h, c
    inc b
    sub b
    jr nz, jr_001_6e47

    ld [$9826], sp
    inc b
    add c
    inc bc
    inc de
    ld b, h
    jr nz, jr_001_6e79

    ld [$002c], sp
    ld h, b
    inc d
    db $10
    ld l, b
    jr nc, @+$04

    add e
    stop
    ld h, a
    and b
    ld [bc], a
    ld a, b
    ld bc, $0818
    nop
    sbc b
    ld hl, sp+$07
    ld d, b
    add b
    adc b
    nop
    sub $04
    ld [$00c0], sp
    ret nz

    ld [$407e], sp
    nop
    ld de, HeaderMaskROMVersion
    adc h
    nop
    ld c, $04
    rrca
    ld b, [hl]
    ld [hl-], a
    jr nz, jr_001_6eaa

    ld bc, $0e10
    ld l, l
    rlca
    ld bc, $a023
    nop
    add b
    ld bc, $4285
    add b
    ld d, c
    and b
    inc hl
    adc c
    ld [bc], a
    jr nc, jr_001_6eff

jr_001_6eff:
    ld b, b
    ld [bc], a
    jp $9183


    ld h, l
    nop
    ret nz

    ld [$40c0], sp
    nop
    ret nz

    call nc, $08c1
    jr jr_001_6f11

jr_001_6f11:
    ret c

    ld h, b
    ld bc, $e000
    ret nz

    ld h, b
    ld h, h
    ld d, c
    nop
    ld [$fb00], sp
    ld h, b
    add b
    ld [$02a3], sp
    jr nz, jr_001_6f25

jr_001_6f25:
    nop
    add a
    dec b
    nop
    db $10
    inc b
    add b
    sub c
    ld b, a
    nop
    nop
    ld b, e
    ld b, c
    add c
    ld b, b
    ld [$026d], sp
    ret nz

    ld bc, $00a0
    inc c
    dec c
    ld b, [hl]
    dec b
    sbc b
    ld [bc], a
    ld a, [hl]
    pop hl
    adc b
    ld h, b
    ld [bc], a
    inc bc
    nop
    ld a, [de]
    jr nz, @+$22

    jr jr_001_6f5a

    db $ec
    inc bc
    ld c, $10
    ld h, b
    ld de, $2004
    ld [bc], a
    ld l, e
    nop
    db $d3
    ld b, c

jr_001_6f5a:
    and b
    add c
    add hl, hl
    add b
    ld d, a
    nop
    jr nc, jr_001_6f62

jr_001_6f62:
    inc l
    add c
    pop bc
    ld [$1e0e], sp
    nop
    add d
    jr z, jr_001_6f6c

jr_001_6f6c:
    jr nc, jr_001_6f6e

jr_001_6f6e:
    inc l
    ld b, c
    or c
    ld h, b
    inc b
    inc bc
    add hl, bc
    nop
    ld b, c
    jr @+$62

    nop
    sub b
    jp z, $0460

    ld bc, $0007
    ld b, c
    ld d, e
    nop
    jr nc, jr_001_6f88

    ld e, h
    db $10

jr_001_6f88:
    jr nc, jr_001_6fa2

    pop bc
    ld [bc], a
    ld b, b
    sub b
    dec b
    nop
    ld [bc], a
    ld b, b
    ld a, [hl-]
    inc d
    nop
    inc b
    jr nc, jr_001_6f98

jr_001_6f98:
    adc h
    ld [$0002], sp
    db $76
    add e
    add e
    db $10
    ld a, [bc]
    ld a, [de]

jr_001_6fa2:
    nop
    add d
    ld [de], a
    nop
    inc [hl]
    nop
    ld [$7340], sp
    ld de, $5e11
    ld bc, $46bb
    add h
    ld de, $0058
    ld d, h
    nop
    ld h, c
    ld [hl+], a
    adc h
    add b
    dec bc
    inc b
    ld de, $0461
    inc e
    nop
    sub e
    ld b, b
    adc b
    ld [$4023], sp
    nop
    ldh [rTAC], a
    add d
    ld b, h
    jr jr_001_6fd0

    ret nz

jr_001_6fd0:
    scf
    inc h
    ld [de], a
    ld c, $8c
    ld a, [de]
    ld b, e
    ld bc, $c005
    ccf
    ld a, b
    ld b, d
    ld a, [de]
    ld a, [bc]
    sbc b
    inc b
    ld [bc], a
    push bc
    ld c, d
    jr nz, @-$7d

    nop
    and e
    db $db

jr_001_6fe9:
    add b
    add b
    ld d, c
    ret nz

    ld [hl+], a
    inc bc

jr_001_6fef:
    dec bc
    ld b, c
    add c
    ld de, $6400
    nop
    db $f4
    inc bc
    xor [hl]
    ld b, c
    ret nz

    jr z, jr_001_700d

    inc [hl]
    ld [hl-], a
    ld a, [$600f]
    inc c
    jr nc, @+$80

    ld h, b
    add hl, sp
    nop
    ld c, c
    ld b, b
    ld b, b
    ld b, e

jr_001_700c:
    nop

jr_001_700d:
    nop
    add c
    and c
    ld [$0200], sp
    cp b
    dec b
    or [hl]
    ld [bc], a
    inc b
    ret z

    inc bc
    ld d, b
    nop
    dec b
    ld [bc], a
    and e
    ret nz

    ld e, h
    adc l
    ld e, b
    sub d
    nop
    ld l, e
    nop
    call nc, $d300
    jr nz, jr_001_700c

    add a
    inc bc
    ld bc, $4a60
    ld e, h
    ld h, b
    sub d
    inc bc
    adc h
    nop
    ld bc, $1404
    pop bc
    inc b
    db $10
    sbc b
    ld [$a023], sp
    nop
    add b
    pop de
    ld c, e
    nop
    ld [hl+], a
    adc h
    add b
    inc bc
    inc b
    inc de
    ld h, c
    inc b
    dec sp
    jr nz, jr_001_6fe9

    ld [$1023], sp
    ld [bc], a
    ld bc, $1844
    add c
    ld b, c
    db $10
    add b
    ld d, $50
    ld bc, $801c
    add b
    jr nc, jr_001_7064

jr_001_7064:
    ld h, b
    ld [c], a
    sbc a
    ld b, b

jr_001_7068:
    add b
    sub e
    inc de
    jr nz, jr_001_6fef

    nop
    inc hl
    add b
    nop

jr_001_7071:
    ld bc, $4845
    and l
    ld [$7823], sp
    ld bc, $44c1
    jr @+$43

    ld [de], a
    ld [$c226], sp
    ld [$40a8], sp
    nop
    ld de, $2746
    rst $38
    inc bc
    ld h, b
    ld b, $59
    nop
    jr nz, jr_001_7098

    ret nz

    and h
    add b
    nop
    nop
    daa
    ld c, $30

jr_001_7098:
    add d
    rst $38
    rla
    inc b
    or c
    pop bc
    ld c, $00
    dec bc
    db $10
    db $10
    adc h
    ld a, [bc]
    ld d, b
    pop hl
    nop
    inc hl
    ldh a, [$80]
    inc bc
    inc de
    inc b
    and b
    jr nz, jr_001_7071

    ld [$0078], sp
    sbc h
    add b
    add b
    ld h, b
    inc [hl]
    ret z

    xor e
    add b
    ld de, $00c8
    ldh [rP1], a
    ld bc, $8c22
    ld [bc], a
    ld d, h
    pop bc
    jr jr_001_70d1

    ld a, [de]
    sbc b

jr_001_70cb:
    ld b, $18
    pop bc
    dec b
    ld b, b
    rlca

jr_001_70d1:
    db $10
    db $10
    adc h
    ld b, $90
    add c
    dec b
    ld b, $e4
    db $10
    cp d
    ldh [rBCPS], a
    nop
    jr nz, jr_001_7068

    dec b
    jr nz, jr_001_70f5

    add c
    ld b, d
    stop
    rlca
    ld e, $00
    ld h, b
    jp $4c00


    jr nz, jr_001_70f1

jr_001_70f1:
    add d
    adc b
    ld h, b
    ld [bc], a

jr_001_70f5:
    dec c
    nop
    ld c, b
    ld h, e
    ld b, $26
    ret nc

    ld b, b
    add b
    ld de, $00e0
    and h
    ld b, b
    ld e, e
    pop bc
    ld b, b
    ld [$1c80], a
    ld b, $30
    ld [bc], a
    ld bc, $001a

jr_001_710f:
    add hl, bc
    ld l, b
    inc sp
    jr jr_001_7164

    ld h, c
    ld bc, $0c36
    nop
    add [hl]
    ld [de], a
    ld bc, $3900
    add h
    ld l, $10
    jr nc, jr_001_70cb

    add c
    nop
    ld b, b
    ld d, b
    nop
    nop
    add hl, bc
    add b
    nop
    inc h
    ld e, $f8
    add h
    ld [bc], a
    nop
    ld e, [hl]
    sub b
    add c
    inc b
    and e
    ld b, c
    ld d, d
    ret nz

    ld bc, $af00
    add b
    nop
    nop
    daa
    ld [bc], a
    inc b
    jr @-$36

    add b
    inc bc
    nop
    ld l, d
    ld bc, $0060
    jr nc, jr_001_714f

    add l

jr_001_714f:
    dec b
    ld h, $70
    ld c, b
    nop
    ld [$02aa], sp
    add b
    inc d
    inc h
    add b
    and b
    ld b, c
    ld l, d
    nop
    add hl, de
    add b
    nop
    and b
    nop

jr_001_7164:
    ld h, c
    pop bc
    ld [$2028], sp
    jr nz, jr_001_7170

    inc e
    nop
    ld sp, $f048

jr_001_7170:
    ld a, [de]
    nop
    rlca
    dec b
    nop
    ld b, c
    ld c, b
    add b
    ld [bc], a
    nop
    dec [hl]
    ld b, b
    xor d
    jr z, jr_001_710f

    ld e, d
    sbc b
    db $10
    inc c
    call $8021
    ld d, h
    nop
    ld a, b

jr_001_7189:
    nop
    ld e, h
    pop bc
    ld bc, $68c1
    add b
    ld a, [de]
    ld l, h
    nop
    ld b, b
    ld a, [hl+]
    ld [hl], b
    add b
    jr @+$0a

    ld d, $98
    and b
    pop hl
    nop
    jr nz, @+$2a

    ld bc, $0280
    add b
    ld a, [bc]
    ld d, d
    ld bc, $1a00
    inc c
    ld c, h
    ld [hl-], a
    ld bc, $0080
    ret nz

    inc b
    dec b
    nop
    ld bc, VirginStartScreen
    ld h, $03
    ld [bc], a
    ld bc, $1180
    inc h
    inc a
    nop
    inc b
    ld b, c
    ld bc, $0e90
    ret c

    jr nz, jr_001_723c

    jr nz, jr_001_7189

    rlca
    inc d
    nop
    jr nc, @+$32

jr_001_71ce:
    ld d, b
    nop
    add d
    ld [bc], a
    ld b, b
    jr @-$7e

    add hl, bc
    inc d
    ld b, b
    add b
    ld h, b
    inc [hl]
    ld b, b
    dec c
    ld a, [hl-]
    db $10
    ld h, b
    inc b
    dec de
    nop
    ld e, d
    adc e
    ld h, b
    inc [hl]
    ldh a, [$ae]
    add b
    inc d
    adc h
    nop
    jr @+$03

    ld bc, $68c1
    ret nc

    add hl, de
    add d
    ld b, $02
    adc h
    and b
    ld bc, $0680
    ld [$4609], sp
    add e
    adc e
    ld b, $18
    ld b, c
    ld b, $c0
    rla
    sub b
    nop
    cp h
    inc e
    nop
    adc e
    ld [$0002], sp
    ld b, [hl]
    inc bc
    ret nz

    db $10
    db $10
    ld [$8000], sp
    db $10
    ld h, b
    inc b
    ld a, [hl-]
    jr nz, jr_001_7276

    ld h, b
    add d
    add e
    ld [bc], a
    rlca
    ld b, a
    ld [$1a00], sp
    nop
    db $10
    ld d, b

jr_001_722a:
    nop
    jr jr_001_722a

    rlca
    ld c, $8c
    and b
    and b
    nop

jr_001_7233:
    ld bc, $02b0
    ld b, b
    dec b
    and b
    ld bc, $00f2

jr_001_723c:
    jr jr_001_727e

    db $10
    ld h, b
    stop
    ld b, b
    ld h, b
    ld h, b
    db $10
    inc l
    inc bc
    dec b
    ld b, l
    jr z, jr_001_724c

jr_001_724c:
    jr jr_001_71ce

    ld [$0058], sp
    nop
    ld e, b
    inc [hl]
    jr jr_001_726b

    nop
    add hl, bc
    ld b, b
    ld c, $2c
    nop
    add b
    jr nz, jr_001_725f

jr_001_725f:
    adc h
    inc a
    ld [bc], a
    nop
    jr jr_001_726f

    ld a, [bc]
    inc b
    ld b, [hl]
    ld [hl], $01
    nop

jr_001_726b:
    inc hl
    add sp, $00
    pop bc

jr_001_726f:
    ld b, h
    jr jr_001_7233

    ld d, $68
    ld c, $20

jr_001_7276:
    jp nz, Jump_001_7808

    nop
    ld a, b
    ldh [$b3], a
    nop

jr_001_727e:
    ld de, $3846
    ld [bc], a
    stop
    add h
    adc c
    ld h, b
    ld [bc], a
    inc b
    db $10
    ld b, b
    add h
    ld d, c
    ldh [$80], a
    inc de
    ld c, b
    inc e
    ld c, b
    add h
    inc d
    cp b
    ld b, c
    ld [c], a
    jr nz, jr_001_72bc

    sbc b
    inc b
    add b
    dec c
    ld [de], a
    add hl, bc
    ld [$8d46], sp
    adc e
    ld b, $c0
    dec c
    ld a, [hl-]
    add hl, bc
    ld [$8b46], sp
    adc e
    ret nz

    nop
    ldh [rDIV], a
    inc a
    ld hl, $0001
    ld [bc], a
    ld [bc], a
    inc d
    ld b, c
    ld hl, $2810

jr_001_72bc:
    jr nc, jr_001_72c0

    add c
    rra

jr_001_72c0:
    ld b, b
    ld [hl], $70
    add l
    inc b
    ld b, c
    db $10
    adc b
    ld b, d
    add b
    ld [$0200], sp
    sbc b
    inc b
    ld h, [hl]
    ld [bc], a
    db $10
    ld h, b
    rrca
    jr nz, jr_001_72d6

jr_001_72d6:
    inc d
    ld [$028c], sp
    ret c

    dec [hl]

jr_001_72dc:
    ld [hl+], a
    ld b, a
    ld [bc], a
    cp h
    nop
    sub b
    ld [bc], a
    ld c, h
    add e
    add b
    db $dd
    ld b, b
    nop
    ld e, b
    rst $28
    nop
    add hl, sp
    ld c, $92
    inc bc
    ld e, $80
    rlca
    jr nz, @+$2a

    ld c, b
    dec b
    jr c, jr_001_72fc

    inc bc
    ld b, a
    inc e

jr_001_72fc:
    nop
    ld c, d
    pop bc
    dec b
    ld [$8c02], sp
    ld [hl+], a
    jr nc, jr_001_730b

    db $ec
    jp nz, $8009

    ld [de], a

jr_001_730b:
    nop
    ld [bc], a
    jr nc, jr_001_730f

jr_001_730f:
    jr @-$01

    rlca
    ld c, $8c
    ld d, b
    ld b, b
    pop bc
    ret nz

    or b
    ld [bc], a
    ld b, b
    ld bc, $0300
    inc d
    ld a, [bc]
    ld b, [hl]
    ld bc, $1118
    inc d
    inc e
    daa
    nop
    inc h
    nop
    ld [hl], h
    jr nz, jr_001_733b

    jr nz, @+$62

jr_001_732f:
    add c
    ret nz

    inc b
    ld b, $06
    ld c, $8e
    ld e, b
    nop
    or b
    ld b, h
    ret nc

jr_001_733b:
    add d
    cp b
    ld bc, $1200
    ld h, $30
    ld a, [de]
    ret nz

    adc c
    db $10
    jr nz, jr_001_7368

    jr c, jr_001_734b

    ret nz

jr_001_734b:
    ld bc, $0720
    ld [hl], c
    nop
    cpl
    ld bc, $000d
    ld a, [hl+]
    inc c
    jr nz, jr_001_72dc

    ld b, $81
    ret nz

    ld h, [hl]
    inc b
    inc b
    nop
    ret nz

    ld [bc], a
    nop
    ld e, $00
    ld [$4848], sp
    inc b

jr_001_7368:
    sub [hl]
    nop
    ld e, h
    ret nz

    ldh [rSB], a
    ld c, e
    ld h, $00
    ld [hl-], a
    nop
    and [hl]
    and b
    ld h, b
    inc d
    jr nz, jr_001_7387

    dec bc
    nop
    add d
    ld [hl-], a
    nop
    sbc $00
    ld e, b
    ld [hl], h
    ld b, c
    ld a, [bc]
    add hl, bc
    ld d, a
    db $10

jr_001_7387:
    add b
    dec d
    ld b, b
    adc d
    jr nz, jr_001_738d

jr_001_738d:
    ld de, $0158
    jr c, jr_001_73a3

    ld l, d
    jr nz, jr_001_73aa

    nop
    and b
    ret nc

    jr nz, jr_001_73af

    ret nz

    add hl, bc
    ld bc, $0902
    ld b, [hl]
    inc bc
    sbc h
    db $10

jr_001_73a3:
    inc d
    nop
    add d
    inc l
    nop
    stop

jr_001_73aa:
    and d
    and b
    nop
    jr nz, jr_001_732f

jr_001_73af:
    ld sp, $6520
    ld b, b
    jr nz, jr_001_73bd

    ldh a, [rSC]
    rlca
    add b
    jr nz, jr_001_73bf

    nop
    dec c

jr_001_73bd:
    add b
    ld [hl-], a

jr_001_73bf:
    ld c, b
    inc a
    jr jr_001_740c

    nop
    ld h, b
    inc c
    ld b, b
    inc e
    and h
    ld e, $04
    call nc, $0280
    nop
    ld b, $06
    ld a, [bc]
    inc b
    ld l, d
    ld [hl], d
    ld bc, $02d0
    ld [hl], b
    nop
    ld b, $04
    and e
    ld [bc], a
    ld d, d
    ld bc, $028c
    jp nz, $07c1

    ld [$8c16], sp
    ld b, b
    add c
    inc b
    ld bc, $9046
    inc bc
    db $10
    ld b, $24
    dec b
    ld bc, $8223
    nop
    add b
    sbc d
    ld b, d
    jr nz, jr_001_746c

    ld c, $03
    ret c

    ld hl, $c004
    dec bc
    nop
    ld a, [bc]
    jr jr_001_7429

    jp nz, $5008

    nop
    sub b

jr_001_740c:
    add b
    ret nc

    ld h, b
    inc [hl]
    db $10
    ld a, [bc]
    and c
    nop
    nop
    dec bc
    adc [hl]
    nop
    ld e, [hl]

jr_001_7419:
    ld c, $00
    ld b, [hl]
    ld b, $01
    nop
    ccf
    and h
    ld [$e508], sp
    ld h, c
    ld b, b
    dec h

jr_001_7427:
    inc l
    nop

jr_001_7429:
    ld e, $00
    inc h
    jr z, @+$46

    add h
    ld de, $0070
    ldh a, [rSB]
    ld bc, $8c22
    ld a, [bc]
    ld h, b
    ld b, $80
    inc c
    ld d, $00
    ld b, b
    stop
    ld b, [hl]
    ld e, $01
    nop
    inc c
    dec b
    dec b
    ld [bc], a
    ld a, $9b
    nop
    ret nz

    nop
    sbc b
    nop
    inc bc
    inc bc
    inc e
    ld e, h
    ld h, b
    ret nz

    ld [$400c], sp
    ret nz

    ld b, b

jr_001_745b:
    ld b, $19
    db $10
    ldh a, [rSC]
    nop
    rla
    jr jr_001_7490

    jr jr_001_7427

    dec b
    inc b
    adc h
    nop
    inc b
    inc b

jr_001_746c:
    rrca
    ld b, [hl]
    rlca
    or b
    ld b, b
    ld b, $04
    dec bc
    ld b, [hl]
    ret nc

    ld d, b
    ld [bc], a
    ld bc, $00a9
    cp b
    add d
    ld bc, $d182
    ret nz

    jr c, jr_001_745b

    ld b, b
    add b
    ld de, $00b0
    inc a
    ld bc, $c161
    ld [$4816], sp
    db $10

jr_001_7490:
    ld h, b
    inc b
    ld h, $20
    ld l, b
    jr nc, jr_001_7419

    add b
    ld d, $00
    jr jr_001_74a1

    add b
    rrca
    nop
    ld e, $80

jr_001_74a1:
    nop
    inc b
    jr nz, jr_001_74ad

    sub b
    jr nc, @+$23

    nop
    ld c, h
    inc b
    rrca
    dec bc

jr_001_74ad:
    nop
    ldh a, [rP1]
    ld a, [c]
    ld a, $00
    add hl, sp
    and b
    ld b, b
    jr nc, @+$6c

    ld h, h
    db $f4
    ld [$6100], sp
    ld b, b
    ld [$0069], sp
    inc a
    ld a, [hl+]
    ld h, b
    ld d, h
    ld bc, $3020
    ld e, $1b
    add b
    inc bc
    jr jr_001_7512

    add h
    ld de, $00d0
    ret nc

    nop
    ld hl, $8c22
    ret nz

    inc bc
    ld h, b
    rlca
    ld [de], a
    pop bc
    inc b
    inc sp
    nop
    ld h, [hl]
    ld b, b
    adc b
    ld [$4023], sp
    nop
    add sp, $02
    ld [bc], a
    add d
    ld d, c
    db $e3
    ld l, $48
    ld bc, $8118
    ld b, h
    ld c, b
    ld b, e
    ld bc, $4093
    and b
    ld hl, sp+$0a
    inc b
    ld e, h
    nop
    ld h, b
    call nc, Call_000_101c
    jr nc, jr_001_750e

    ld e, b
    add h
    db $10
    db $10
    jr nc, jr_001_752c

    dec bc
    inc b
    jr jr_001_7527

jr_001_750e:
    rlca
    nop
    adc h
    sub d

jr_001_7512:
    inc bc
    rrca
    ld b, [hl]
    nop
    xor h
    nop
    adc b
    rlca
    jp $0106


jr_001_751d:
    and e
    ld b, c
    ld [hl], c
    ld de, $2e20
    ld a, [$c00f]
    inc b

jr_001_7527:
    ret nz

    dec sp
    ld h, b
    add hl, sp
    nop

jr_001_752c:
    ld c, c
    ld b, b
    nop
    ld b, d
    nop
    nop
    add c
    and c
    ld [$0200], sp
    ld e, b
    dec b
    xor h
    ld [bc], a
    nop
    ld [bc], a
    inc a
    nop
    ld a, [bc]
    add b

jr_001_7541:
    ld [bc], a
    add c
    ld d, c
    nop
    and [hl]
    ld b, [hl]
    ld b, [hl]
    inc b
    ret c

    inc bc
    sbc b
    dec b
    sbc b
    ld b, $01
    ld d, c
    inc e
    ld [$e300], sp
    ld h, d
    inc bc
    and d
    inc c
    ld l, b
    add [hl]
    ld d, b
    ld bc, $7089
    ld b, l
    ret nc

    nop
    ret nz

    ld a, $4e
    ld h, b
    ld a, [bc]
    ld [hl], b
    adc a
    sbc b
    ldh [rNR41], a
    ld e, b
    ld bc, $0110
    nop
    ld [$2701], sp
    sbc h
    add b
    dec b
    ld a, [bc]
    adc d
    jr nc, jr_001_757b

jr_001_757b:
    or h
    inc bc
    ld h, $10
    jr nz, @+$32

    dec c
    ret nc

    ld b, d
    ld h, b
    ld d, b
    ld d, b
    inc l
    ld [bc], a
    nop
    inc e
    ld e, b
    jr nz, jr_001_758e

jr_001_758e:
    xor e
    add e
    ld de, $0090
    sbc b
    ld bc, JoyPadNewPresses
    ld l, [hl]
    nop
    jr jr_001_751d

    ld bc, $0d02
    nop
    sbc b
    ld [bc], a
    add sp, $62
    nop
    and e
    add hl, bc
    ld a, h
    ldh a, [rLCDC]
    add b
    inc bc
    nop
    ld h, e
    inc e
    add b
    ld [hl-], a
    jr jr_001_75e6

    jr @-$7d

    add c
    dec bc
    ld [bc], a
    ret z

    ldh [$0a], a
    ld [c], a
    ld b, $0a
    ld e, b
    ld d, b
    jr nc, jr_001_7541

    inc bc
    nop
    dec sp
    or b
    ld bc, $81f0
    cp b
    jp nz, $1182

    ld c, h
    jr nz, jr_001_760f

    ld a, [bc]
    inc sp
    nop
    ld d, [hl]
    add b
    db $10
    ld de, $f846
    ld bc, $6ec0
    cp h
    add b
    dec b
    dec bc
    ld bc, $4404
    nop
    and b
    push bc
    nop

jr_001_75e6:
    ld h, b
    add b
    ld a, [hl-]
    ld [bc], a
    and b
    ld d, a
    inc b
    add hl, hl
    adc h
    add b
    add b
    call nc, $7400
    ret nz

    nop
    ret nz

    jr z, jr_001_75fb

    inc de
    inc e

jr_001_75fb:
    inc b
    jr nz, @+$32

    ld b, d
    nop
    or b
    nop
    ld e, b
    add c
    ld h, d
    add c
    add hl, bc
    ld [bc], a
    nop
    ld [$b110], sp
    jr nz, @-$3e

    adc h

jr_001_760f:
    ld [hl], l
    nop
    ld bc, $04ff
    ld [bc], a
    and e
    ld bc, $c058
    ld bc, $4800
    inc c
    add b
    add a
    jr nc, jr_001_7624

    ld [hl], c
    nop
    cpl

jr_001_7624:
    ld bc, $0006
    ld d, a
    inc c
    ld h, b
    ld h, h
    stop
    jr nc, @-$7c

    rlca
    inc b
    ld [bc], a
    jp nz, $042c

    ld a, b
    ld bc, $1a04
    cp h
    ld b, $18
    pop bc
    add hl, bc
    nop
    inc b
    db $10
    ld d, $8c
    add b
    ld b, c
    inc b
    ld bc, $d046
    ld [bc], a
    ret nz

    ld [bc], a
    inc b
    dec b
    and e
    add b
    ld d, e
    dec b
    adc h
    ld b, $40
    ld b, $06
    dec bc
    ld b, [hl]
    ldh [$60], a
    ld [bc], a
    nop
    and e
    nop
    sbc h
    ld [$601a], sp
    jr nc, jr_001_7667

    inc bc
    rla

jr_001_7667:
    inc b
    ldh [rNR42], a
    inc a
    nop
    ret c

    ld bc, $c009
    bit 4, c
    nop
    adc [hl]
    ld b, b
    ld b, c
    db $10
    and b
    adc b
    and b
    ld bc, $b780
    nop
    ld b, [hl]
    or b
    inc b
    add d
    adc b
    jr nc, jr_001_7687

    inc b
    ld b, b

jr_001_7687:
    dec l
    jr nz, jr_001_76d2

    add h
    inc d
    nop
    sbc d
    pop bc
    nop
    add b
    jp hl


    add e
    ld d, c
    nop

jr_001_7695:
    db $fc
    ret nz

    jr nz, @+$24

    sbc b
    ret nz

    ld bc, $0150
    ld [$4c00], sp
    dec e
    adc h
    add b
    dec b
    jr nc, @+$04

    ld [$7c00], sp
    dec de
    adc h
    nop
    ret nz

    ld b, $e0
    inc bc
    ld a, [bc]
    ld de, $0581
    jr z, jr_001_76b7

jr_001_76b7:
    inc b
    ld b, b
    ld b, b
    jr nc, jr_001_76e6

    ld h, b
    ld d, a
    nop
    ld c, e
    nop
    ld e, d
    ld h, b
    ldh a, [rNR41]
    ld b, l
    inc d
    nop
    jr nc, @+$45

    ld a, b
    ld bc, $0201
    db $d3
    ld bc, $083b

jr_001_76d2:
    ld c, d
    nop
    ldh a, [rSB]
    ld a, b
    inc bc
    ld b, h
    ld h, b
    ld c, c
    inc b
    add b
    ld [$1740], sp
    ld [de], a
    adc h
    ld b, $c0
    dec b
    ld h, b

jr_001_76e6:
    and d
    add hl, bc
    nop
    dec bc
    add b
    inc l
    jr nc, @+$1a

    and c
    pop hl
    ld [bc], a
    ld b, b
    sub b
    inc d
    inc b
    ldh [$0a], a
    ld [bc], a
    dec b
    ld d, d
    ld b, $04
    add d
    ld bc, $0838
    ld a, [hl-]
    ld bc, $1c20
    call nz, $2a41
    nop

jr_001_7708:
    ld c, b
    add c
    pop bc
    ld c, b
    ld b, $00
    inc [hl]
    nop
    adc b
    jr nz, jr_001_7708

    jr nz, jr_001_7695

    add h
    ld b, b
    ld bc, $0300
    inc bc
    dec b
    ld [bc], a
    inc h
    inc d
    add hl, bc
    nop
    ld a, b
    pop bc
    add hl, bc
    ld [$8c18], sp
    ldh a, [rP1]
    nop
    or b
    ld [bc], a
    nop
    ld bc, $0880
    ld [de], a
    inc c
    ld e, b
    ld e, b
    ld bc, $2901
    ld bc, $80f0
    ld b, c
    inc bc
    db $d3
    nop
    add hl, hl
    ldh a, [rSB]
    ld h, b
    ld bc, $82c2
    ld de, $006a
    add b
    add hl, bc
    inc sp
    nop
    ld a, b
    nop
    ld e, $c0
    or b
    ld h, b
    add h
    adc h
    ld bc, $8000
    jr jr_001_7759

jr_001_7759:
    ld a, [bc]
    nop
    ld a, b
    ld [hl], b
    ld b, $10
    ret nc

    nop
    jr nc, @+$24

    ld [$2800], sp
    ld c, b
    nop
    jr nc, jr_001_776a

jr_001_776a:
    inc b
    ld a, $00
    nop
    ld b, d
    nop
    inc c
    nop
    ldh [rLCDC], a
    ld [hl+], a
    ld [hl+], a
    adc h
    and b
    inc b
    nop
    inc bc
    ld [$6111], sp
    inc b
    add hl, hl
    nop
    ld l, b
    ld b, b
    adc b
    ld [$d823], sp
    nop
    ret nz

    inc bc
    ld [bc], a
    ld b, h
    jr jr_001_7793

    add b
    inc c
    nop
    ld [de], a
    inc e

jr_001_7793:
    ld bc, $20bc
    nop
    adc h
    inc c
    ld [bc], a
    nop
    db $10
    jr z, jr_001_77a8

    add c
    ld e, c
    ldh [rSB], a
    nop
    xor e
    ld [bc], a
    ldh a, [rP1]
    ld e, b

jr_001_77a8:
    add d
    ld [bc], a
    nop
    ld d, e
    rlca
    inc hl
    ret nz

    nop
    ldh a, [rSB]
    add b
    ld de, $a048
    pop bc
    xor b
    nop
    ld [hl], h
    nop
    ld [bc], a
    ld h, b
    ld bc, $10e0
    ld h, b
    db $e4
    ld de, $c000
    ld d, b
    ld d, b
    jr nz, jr_001_77f9

    or d
    ld bc, $0500
    nop
    ld a, [hl-]
    ld c, b
    inc a
    jr nz, @+$1a

    dec l
    ld l, $02

jr_001_77d6:
    ld de, $2000
    add sp, -$7c
    inc b
    nop
    ld [$5008], sp
    inc b
    add l
    ld b, b
    add b
    ld [$0200], sp
    ret nz

    ld b, $ea
    ld bc, $8040
    ld l, d
    ld b, b
    ld b, e
    jr c, jr_001_7822

    ld a, [de]
    ld [$4918], sp
    ld h, $01
    and [hl]

jr_001_77f9:
    nop
    add sp, $0b
    ld sp, $0203
    and h
    add hl, sp
    stop
    ret nz

    ld c, h
    add c
    ret nz

    add c

Jump_001_7808:
    dec h
    ld a, [de]
    ld b, b
    ld [bc], a
    inc c
    jr z, jr_001_7851

    dec c
    jr nz, jr_001_7842

    ld de, $3058
    ld bc, $8982
    ret nz

    add d
    rrca
    db $10
    ld c, h
    inc b
    ld d, $4c
    ld h, b
    ld [hl+], a

jr_001_7822:
    or b
    pop de
    nop
    ld e, d
    ld h, b
    jr nz, jr_001_783a

    ld [$0068], a
    ld hl, $0898
    ld [hl-], a

jr_001_7830:
    inc bc
    jr z, @-$3d

    ld b, h
    ld h, b
    add hl, de

jr_001_7836:
    ld b, b
    rrca
    inc c
    inc h

jr_001_783a:
    ld [bc], a
    add hl, bc
    dec c
    ldh [rTAC], a
    ld b, $13
    ld b, c

jr_001_7842:
    ld b, $41
    jr nz, jr_001_77d6

    ld [$2c3f], sp
    add b
    inc e
    jr jr_001_789d

    inc b
    call c, $5089

jr_001_7851:
    call nz, $8802
    add c
    add c
    ld b, h
    sbc b

jr_001_7858:
    ld h, c
    ld bc, $609c
    ld [hl+], a
    or h
    ret nc

    nop
    ld b, d
    ld h, b
    jr nc, jr_001_7875

    ld c, h
    sub b
    add c
    adc c
    ret nz

    add $02
    xor b
    add b
    add c
    ld b, h
    ret nz

    ld h, e
    ld bc, $c02c
    ld b, b

jr_001_7875:
    ld [hl+], a

jr_001_7876:
    ldh [$0a], a
    ldh [rDIV], a
    inc de
    add c
    ld d, l
    db $10
    and b
    ld [$2c78], sp
    add b
    inc bc
    jr @+$4e

    inc b
    inc e
    ld c, h
    ld h, b
    ld [hl+], a
    add b
    sub c
    nop
    ld a, [bc]
    ld h, b
    jr nz, @+$13

    xor b
    ld c, b
    nop
    rlca
    jr nc, jr_001_7830

    ld [$6838], sp
    nop
    add c

jr_001_789d:
    ld b, h
    ldh a, [rNR11]
    ld b, b
    ld [$4226], sp
    inc d
    add hl, bc
    ld h, b
    ld [bc], a
    ld b, $12
    ld hl, $0587
    and b
    add d
    adc c
    jr nz, jr_001_7876

    ld [bc], a
    jr nz, jr_001_7836

    ld b, h
    jr jr_001_78b9

    inc d

jr_001_78b9:
    ld b, b
    rrca
    ld h, $02
    add hl, bc
    add hl, bc

jr_001_78bf:
    ld b, b
    inc b
    inc de
    pop hl
    ld b, l
    nop
    dec sp
    jr nc, jr_001_7858

    ld [$244e], sp
    add b
    rra
    jr jr_001_7917

    inc b
    ld hl, $4012
    db $10
    inc c
    jr z, jr_001_7919

    ld c, $07
    ld [bc], a
    inc de
    add c
    dec b
    dec de
    sub b
    ld [$d823], sp
    ld bc, $01a8
    ld b, l
    jr @+$43

    inc c
    ld [$4226], sp

jr_001_78ec:
    dec bc
    ld bc, $1203
    ld h, c
    inc b
    ld a, [hl-]
    nop
    ld [hl], $90
    ld [$b023], sp
    ld bc, HeaderROMSize
    add d
    ld b, h
    ret z

    pop hl
    nop
    cp b
    ld h, b
    ld [hl+], a
    call nc, Call_001_4802
    sub l
    ld [$013b], sp
    ld c, b
    add c
    ld b, h
    jr jr_001_7911

    ld a, [bc]

jr_001_7911:
    ret nz

    dec c
    db $10
    ld h, $42
    ld a, [bc]

jr_001_7917:
    ld l, d
    ld b, b

jr_001_7919:
    jr nz, jr_001_792c

    ld a, h
    ld [bc], a
    ret nc

    ld [bc], a
    inc bc
    adc c
    sub b
    ld [de], a
    add b
    inc d
    ld c, b
    add h
    ld de, $0090
    adc h
    nop

jr_001_792c:
    ld hl, $8c22
    ret nz

    dec b
    ldh [$03], a
    ld [$e112], sp
    add h
    inc bc
    ret nc

    ld [bc], a
    adc c
    jr nc, jr_001_78bf

    dec de
    add b

jr_001_793f:
    dec c
    jr nz, jr_001_798e

    inc b
    inc de
    ld c, h
    add b
    jr nz, jr_001_796a

    adc h
    and b
    rlca
    and b
    rlca
    inc de
    and c
    ld [hl], $00
    daa
    sbc b
    ld [$81ac], sp
    ret nz

    ld b, h
    ld c, b
    ld b, c
    inc c
    ld b, b
    dec c
    ld h, $42
    ld c, l
    jr nz, jr_001_79a2

    ld de, $0258
    jr nc, @+$04

    adc c
    jr nc, jr_001_78ec

jr_001_796a:
    ld [de], a
    add b
    ld a, [de]
    ld c, b
    add h
    ld de, $808c
    ld h, b
    ld [hl+], a
    adc h
    add b
    inc bc
    jr nz, jr_001_7980

    ld [de], a
    ld h, c
    inc b
    add hl, de
    nop
    scf
    sub b

jr_001_7980:
    ld [$9023], sp
    nop
    ldh [rSTAT], a
    add d
    ld d, c
    inc bc
    ld h, $78
    nop
    ld [hl], b
    nop

jr_001_798e:
    ld b, d
    ld c, b
    inc bc
    ld b, b
    inc d
    jr nc, jr_001_793f

    ld [$3f18], sp
    ld bc, $4001
    inc b
    inc h
    ld b, d
    ld a, [de]
    nop
    and h
    ld a, [bc]

jr_001_79a2:
    inc d
    add hl, bc
    inc b
    adc d
    sub e
    ld b, b
    ld [bc], a
    ld bc, $1846
    ld bc, $a301
    nop
    ld c, h
    ld bc, $8218
    ld [bc], a
    inc hl
    nop
    inc l
    nop
    ld a, [$d681]
    add b
    inc bc
    ld de, $3234
    ld a, [$800f]
    inc bc
    ld h, b
    rra
    ld h, b
    add hl, sp
    nop
    ld c, c
    ld b, b
    nop
    ld b, d
    nop
    nop
    add c
    and c
    ld [$0200], sp
    ld [$2604], sp
    ld [bc], a
    nop
    jr @+$43

    nop
    ld [$8c0c], sp
    ld d, $89
    ld h, d
    ldh [$3d], a
    db $ec
    ld bc, $03e8
    call z, $8082
    jr z, jr_001_79fc

    inc b
    nop
    sub a
    or b
    ld bc, $0e36
    and b
    ld b, d
    add b
    nop
    add c
    pop de
    ld [bc], a

jr_001_79fc:
    daa
    inc c
    and b
    add l
    sub h
    ld bc, $0320
    nop
    ld l, c
    inc c
    ld [$6008], sp
    ld hl, $0204
    sub b
    ld [hl], b
    nop
    jr nc, @+$08

    ld b, h
    ld b, [hl]
    sub d
    ld [bc], a
    ld bc, $3480
    ld b, $04
    ld [hl+], a
    jp nz, Jump_001_7808

    nop
    ret z

    add b
    nop
    ld de, $0546

jr_001_7a26:
    ld h, b
    nop
    add b
    inc b
    dec bc
    ld b, $01
    ccf
    db $f4
    ld [$6000], sp
    jr z, jr_001_7a5c

    db $10
    ld hl, sp-$5f

jr_001_7a37:
    ld c, l
    nop
    db $e4
    nop
    add b
    ld a, [bc]
    rra
    jr jr_001_7a55

    sub b
    ld [bc], a
    dec c
    inc b
    jr jr_001_7a87

    ld c, $40
    ld [de], a
    db $10
    ld d, $8c
    add b
    ld [bc], a
    ld [bc], a
    ld b, [hl]
    ld [hl], b
    inc bc
    and b
    rlca
    inc h

jr_001_7a55:
    add l
    ld bc, $00a3
    ld h, h
    ld a, [bc]
    add c

jr_001_7a5c:
    nop
    dec [hl]
    ldh a, [rLCDC]
    nop
    inc e
    cp h
    nop
    ld l, b
    nop
    ld bc, $a8c1
    add b
    ld d, a
    ld bc, $0129
    ldh a, [$81]
    pop bc
    add d
    ld de, $9414
    jr nz, jr_001_7a37

    ld [$003c], sp
    adc b
    scf
    ld [hl+], a
    adc h
    and b
    ld [bc], a
    ret nz

    sub d
    ret z

    dec b
    ldh a, [$32]
    ld [hl], b

jr_001_7a87:
    jr nc, jr_001_7a8b

    add hl, bc
    nop

jr_001_7a8b:
    dec b
    ld d, a
    and b
    ld b, b
    ld a, [bc]
    ld b, c
    ld b, c
    nop
    ld h, b
    inc b
    ld [$0008], sp
    ld b, b
    stop
    inc a
    nop
    ld [hl], $a0
    ld b, b
    jr nc, jr_001_7abc

    ld [hl], h
    adc c
    jr nz, jr_001_7a26

    ret nz

    adc b
    ld bc, $03e0
    ret nz

    rlca
    ld a, c
    nop
    cpl
    rst $38
    ld bc, $0601
    db $10

jr_001_7ab5:
    ld bc, $425c
    add e
    ld b, b
    nop
    inc de

jr_001_7abc:
    inc a
    jr z, jr_001_7ae7

    ld d, [hl]
    nop
    cp b
    ld bc, $ebb0
    add d
    ld de, $b41c
    nop
    ld h, b
    ld a, [bc]
    inc bc
    xor d
    ld b, c
    ld b, $12
    adc h
    ld a, [bc]
    ld a, b
    dec b
    ld e, d
    ld a, [bc]
    ld b, b
    ld b, $6b
    jr nz, jr_001_7b1c

    jr nc, jr_001_7af8

    add b
    add l
    rra
    nop
    ret z

    jp nz, Jump_000_3000

    nop

jr_001_7ae7:
    sbc b
    add c
    inc sp
    ld b, e
    add c
    ld d, c
    ld b, c
    add d
    jr nz, jr_001_7b31

    dec c
    dec bc
    nop
    nop
    sub e
    nop
    ret nz

jr_001_7af8:
    inc b
    ld b, $20
    ld h, b
    db $10
    ld b, d
    call z, VBlankInterrupt
    rra
    xor b
    nop
    ret nc

    and b
    add c
    add hl, bc
    ld d, $00
    add d
    inc l
    nop
    ld h, h
    nop
    ld d, $91
    ld b, b
    ld [hl], $30
    inc c
    inc bc
    ld c, b
    ld de, $0005
    rlca
    add b

jr_001_7b1c:
    inc b
    jr @+$1a

    adc h
    ldh [rP1], a
    jr nz, jr_001_7b2c

    add hl, bc
    nop
    ld e, [hl]
    ld b, b
    ld [bc], a
    ld [bc], a
    inc b
    and e

jr_001_7b2c:
    add c
    ld c, c
    ld [$081c], sp

jr_001_7b31:
    or b
    inc bc
    jr jr_001_7ab5

    inc e
    jr nc, jr_001_7bb0

    and c
    dec b
    inc b
    ret z

    ld b, b
    dec b
    ldh [$08], a
    ld [$6400], sp
    dec e
    db $ec
    nop
    dec b
    ld h, b
    rrca
    ld [$7000], sp
    rra
    cp h
    ld [bc], a
    nop
    ld [$0b06], sp
    ld b, [hl]
    ret z

    ld bc, $2300
    cp d
    nop
    or b
    nop
    ld hl, sp+$02
    inc bc
    ld d, $2a
    adc [hl]
    nop
    ret nz

    dec hl
    nop
    inc a
    ld h, b
    ret nc

    ld h, b
    add h
    db $10
    ld [$0a30], sp
    nop
    ld b, $80
    dec sp
    jr z, jr_001_7ba1

    jr nc, @-$5d

jr_001_7b77:
    ldh [rSC], a
    ld b, b
    sub b
    nop
    nop
    ld [bc], a
    ret nz

    rra
    adc b
    ld [bc], a
    add b
    inc [hl]
    ld a, [de]
    and h
    ld [bc], a
    ld b, b
    ld bc, $0bc0
    ld a, [bc]
    dec bc
    ld b, [hl]
    adc b
    jr c, jr_001_7b91

jr_001_7b91:
    db $10
    inc [hl]
    ld bc, $0080
    ld d, b
    nop
    dec b
    nop
    ld bc, $000d
    inc hl
    add d
    nop
    nop

jr_001_7ba1:
    inc bc
    add d
    ld [bc], a
    ldh [rLCDC], a
    ld h, b
    ld [bc], a
    ld b, b
    ld d, b
    inc d
    add b
    inc bc
    ld [de], a
    ld b, b
    inc d

jr_001_7bb0:
    add b
    db $10
    ld h, b
    inc b
    inc d
    nop
    jr nz, @+$32

    ld d, b
    jr nz, jr_001_7beb

    sub d
    ld [$3000], sp
    ld b, c
    ld [$2208], sp
    jp nz, Jump_001_7808

    nop
    jp z, $1080

    ld de, $e046
    inc bc
    ldh a, [rTAC]
    add h
    inc b
    and e
    push bc
    ld b, l
    ld h, b
    nop
    sub b
    inc b
    adc c
    dec b
    nop
    and e
    add b
    nop
    add b
    ld d, c
    ld b, b
    and d
    ld b, $46
    ld l, a
    ld bc, $0710
    inc b
    adc b

jr_001_7beb:
    jr nc, jr_001_7bef

    ld a, c
    inc b

jr_001_7bef:
    add b
    add hl, bc
    jr nz, jr_001_7b77

    inc b
    nop
    db $10
    ld [$0458], sp
    ld b, l
    ld b, l
    add b
    ld [$0200], sp
    jr c, jr_001_7c05

    ld b, b
    ld [bc], a
    nop
    add b

jr_001_7c05:
    ld de, $8004
    add b
    ret nz

    jr z, @-$3e

    inc e
    nop
    add b
    and b
    jr c, @+$0a

    ld sp, $3007
    dec c
    jr nc, jr_001_7c23

    ld [bc], a
    or $38
    stop
    jr nc, jr_001_7c31

    ld [$c018], sp
    inc hl

jr_001_7c23:
    ld d, d
    nop
    ld b, b
    ld c, $2f
    jr @-$5d

    pop hl
    ld a, [bc]
    ld [bc], a
    adc h
    ret nc

    ld b, $60

jr_001_7c31:
    add hl, bc
    ld [$4608], sp
    inc bc

jr_001_7c36:
    jr c, jr_001_7c49

    dec sp
    db $10
    ld h, b

jr_001_7c3b:
    add h
    inc sp
    nop
    ld h, e

jr_001_7c3f:
    db $10
    ld [$7810], sp
    nop
    ld e, h
    ld [bc], a
    ld a, [bc]
    nop

jr_001_7c48:
    dec de

jr_001_7c49:
    and c
    ld b, [hl]
    nop
    ret nz

    ld [$0805], sp
    nop
    ld [$00a0], sp
    ld h, b
    inc b

jr_001_7c56:
    add hl, de
    jr nz, jr_001_7c99

    ld h, b
    ld a, [de]
    add b
    add l
    add hl, bc
    ld [$1888], sp
    nop
    inc [hl]
    nop
    inc h
    db $10
    rlca
    db $10
    ret nz

    jr z, @+$32

    ld a, [de]
    ldh [$87], a
    and b
    ld h, b
    ld h, b
    add e
    nop
    ld a, [hl+]
    inc b
    inc e
    db $10
    inc l
    jr jr_001_7c3b

    ld b, d
    add d
    add e
    ld h, c
    ld b, $80
    dec c
    nop
    jr jr_001_7c48

    ld bc, $04bc
    inc b
    inc b
    jr jr_001_7ccf

    inc b
    ret nz

    add hl, bc
    dec c
    ld [bc], a
    ld bc, $0884
    ld bc, $8e0e
    ld b, e
    nop
    and b

jr_001_7c99:
    ld b, d
    ldh [rLCDC], a
    ld [bc], a
    ld e, c
    ld bc, $1c39
    ld h, b
    inc b
    jr c, jr_001_7cc5

    ld a, b
    ld h, b
    ld a, [hl+]
    ld h, b
    inc [hl]
    nop
    ld e, b
    jr nc, jr_001_7c36

    ld [$182c], sp
    ld bc, $0200
    ld b, d
    ld b, h
    jr jr_001_7cf9

    ld b, $00
    and c
    jr nc, jr_001_7c3f

    pop de
    ret nz

    ccf
    inc b
    inc c
    inc b
    jr jr_001_7d06

jr_001_7cc5:
    inc bc
    nop
    dec d
    db $10
    db $10
    adc h
    ld b, $2e
    ld [hl+], a
    ld [hl], b

jr_001_7ccf:
    jr nz, @-$3e

    ld [$002e], sp
    jr nc, jr_001_7c56

    dec bc
    ldh [$e5], a
    jr nc, jr_001_7d3b

    add h
    and b
    jr nz, jr_001_7cff

    ld h, b
    ld b, e
    add d
    nop
    ldh a, [rSB]
    ld a, b
    ld bc, $81c3
    ld d, c
    ld bc, $8c35
    nop
    ld b, b
    inc de
    ld b, $c0
    ld [bc], a
    inc hl
    db $10
    inc e
    jr jr_001_7d0d

    ret nz

jr_001_7cf9:
    jp nz, Jump_000_000b

    jr nc, jr_001_7d03

    add b

jr_001_7cff:
    inc bc
    ld a, [bc]
    jr nz, jr_001_7d33

jr_001_7d03:
    dec d
    ret nz

    ld a, [bc]

jr_001_7d06:
    ld b, b
    add [hl]
    add hl, de
    nop
    ld e, $00
    ld h, h

jr_001_7d0d:
    ld h, b
    jr c, jr_001_7d40

    ld a, [hl+]
    ld b, b
    ld d, $10
    ld a, [bc]
    ld [hl], c
    ld [bc], a
    inc b
    nop
    ld e, d
    ld [$2670], sp
    jr z, jr_001_7d4f

    ld a, [hl+]
    ld [$1804], sp
    ld b, c
    pop bc
    nop
    nop
    ld h, b

jr_001_7d28:
    dec d
    nop
    adc h
    jr nz, jr_001_7d2e

    inc b

jr_001_7d2e:
    dec bc
    ld b, [hl]
    ld c, b
    ret c

    ld [bc], a

jr_001_7d33:
    nop
    and e
    add b
    ld h, h
    jr nc, jr_001_7d3b

    ld [bc], a
    inc b

jr_001_7d3b:
    and e
    ld bc, $587c
    ret nz

jr_001_7d40:
    ld [$0060], sp
    add d
    add b
    ret nz

    ld h, b
    add h
    dec d
    nop
    jr nc, @+$0c

    jr nz, @+$07

    ld [de], a

jr_001_7d4f:
    ld h, b
    jr nc, jr_001_7d94

    add $13
    inc b
    jr @-$7d

    ld [bc], a
    ret nz

    inc e
    inc d
    ld d, $06
    adc h
    ld [bc], a
    sbc b
    ld h, c
    ld b, d
    nop
    ret nz

    ld [$161a], sp
    nop
    ldh [rNR42], a
    nop
    ld d, b
    nop
    jr nc, @+$42

    or c
    ld h, b
    inc b
    inc bc
    dec l
    db $10
    jr nc, @+$0c

    ret c

    sub l
    ld bc, $360b
    jr nc, @+$62

    inc b
    inc a
    jr nz, jr_001_7dc2

    jr nc, jr_001_7d9e

    ld hl, sp+$05
    inc d
    ld [$0260], sp
    ld c, $80
    ld h, $20
    inc l
    jr @+$23

    ld [hl+], a
    nop
    ld b, b

jr_001_7d94:
    db $10
    dec b
    nop
    dec bc
    add b
    inc h
    jr jr_001_7d28

    ld b, b
    ld b, c

jr_001_7d9e:
    dec b
    ld bc, $2046
    ld bc, $05a0
    add h
    dec b
    inc hl
    ld [$0008], sp
    ld [$008a], sp
    jr nc, jr_001_7db0

jr_001_7db0:
    ld [$0283], sp
    add b
    add b
    ld b, $80
    ld de, $0041
    add b
    ld bc, $7821
    rrca
    ld [de], a
    ld [de], a
    nop

jr_001_7dc2:
    add d
    inc c
    nop
    ld [hl], b
    nop
    ld c, h
    ld b, b
    ld de, $4611
    ld b, b
    ld bc, $07d0
    inc b
    adc c
    ld h, b
    ld a, [bc]
    jr jr_001_7e0b

    ld [hl+], a
    adc h
    ret nz

    rlca
    and b
    inc c
    ld [$6111], sp
    inc b
    ld [$3f00], sp
    sub b
    ld e, b
    jr c, jr_001_7e17

    ld l, d
    call c, Call_000_1c05
    nop
    ld h, $a0
    add hl, bc
    ld l, c
    nop
    xor [hl]
    ld a, [bc]
    ld h, b
    inc d
    sub b
    xor b
    add c
    ld de, $00f6
    ret nc

    ld b, b
    ld [hl+], a
    adc h
    ret nc

    rlca
    ldh [rTMA], a
    add hl, bc
    ld b, [hl]
    dec c
    sbc b
    ldh a, [rTAC]
    ld b, b
    rrca

jr_001_7e0b:
    ld [$0121], sp
    nop
    inc b
    ld [bc], a
    inc d
    ld b, c
    ld d, c
    ld de, $8210

jr_001_7e17:
    ld b, c
    add d
    dec sp
    add b
    ld a, h
    ret nz

    ld d, d
    nop
    sub d
    add b
    nop
    ld bc, $1180
    ld b, c
    ret nz

    jr c, jr_001_7e32

    inc h
    db $10
    ld h, b
    inc h
    rra
    db $10
    inc d
    add h
    nop

jr_001_7e32:
    add b
    add b
    adc h

jr_001_7e35:
    ld b, d
    add c
    ld de, $f000
    nop
    or $41
    xor e
    and c
    add hl, bc
    nop
    cp $05
    ret c

    nop
    ld e, c
    nop
    nop
    and b
    dec h
    ret nz

    ld c, $e0
    ld l, d
    db $10
    jr nc, jr_001_7ebb

    ld [hl], h
    and h
    dec d
    db $10
    ldh a, [rNR12]
    nop
    inc de
    jr z, jr_001_7e73

    dec [hl]
    ld l, $0a
    ldh [$75], a
    add hl, de
    add b
    ld [$f823], sp
    nop
    jr z, @+$03

    call Call_001_4442
    ld c, b
    dec b
    ret nz

    ld [$126c], sp
    jr nz, jr_001_7e35

jr_001_7e73:
    ld [$003a], sp
    ld [hl+], a
    add b
    or e
    nop
    ld de, $4046
    ld bc, $00f0
    sbc l
    dec b
    adc b
    jr nc, jr_001_7e87

    inc de
    add b

jr_001_7e87:
    rrca
    ldh a, [$2c]
    jr nz, jr_001_7ea4

    dec l
    ld l, $82
    inc c
    add b
    ld c, $e0
    add h
    inc b
    nop
    ld [$5008], sp
    inc b
    add l
    ld b, b
    add b
    ld [$0200], sp
    nop
    nop
    nop
    nop

jr_001_7ea4:
    nop
    sub d
    sub b
    nop
    ld bc, $1111
    nop
    nop
    nop
    inc d
    rlca
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc hl
    nop
    nop

jr_001_7ebb:
    nop
    nop
    and c
    sub b
    ld c, $01
    ld de, $0088
    nop
    nop
    ld b, h
    ld [$0000], sp
    nop
    nop
    nop
    inc c
    nop
    nop
    ld bc, $0000
    nop
    nop
    sub d
    sub b
    ld c, $01
    ld de, $0288
    ld bc, $4400
    rlca
    nop
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
    adc c
    sub b
    nop
    nop
    ld bc, $0001
    nop
    nop
    nop
    ld [bc], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [hl+], a
    ldh a, [rSB]
    db $10
    db $10
    xor h
    sub b
    cpl
    nop
    ld [bc], a
    ld bc, $0000
    nop
    nop
    dec bc
    nop
    nop
    nop
    db $10
    jr nz, jr_001_7f16

jr_001_7f16:
    nop
    nop
    daa
    nop
    ld [bc], a
    xor b
    rrca
    jr z, jr_001_7f1f

jr_001_7f1f:
    nop
    rst $38
    inc b
    ld bc, Entry
    inc bc
    inc b
    inc d
    nop
    nop
    nop
    db $10
    jr nz, jr_001_7f2e

jr_001_7f2e:
    nop
    nop
    ld bc, $0080
    ldh [$03], a
    ld [hl], l
    nop
    cpl
    ld bc, Entry
    inc b
    ld bc, $0400
    ld b, $00
    nop
    nop
    ld d, b
    nop
    sbc a
    sbc a
    ld a, [bc]
    ld bc, $0388
    nop
    rlca
    add c
    nop
    add b
    nop
    ld bc, $4001
    ld bc, $0100
    ld a, [de]
    nop
    nop
    nop
    nop
    nop
    nop
    inc c
    nop
    inc bc
    nop
    nop
    ld h, $00
    rrca
    nop
    jr nz, jr_001_7f6a

    ld [bc], a

jr_001_7f6a:
    ld bc, $0108
    nop
    ld [$0000], sp
    nop
    nop
    nop
    ld d, b
    nop
    nop
    nop
    nop
    add b
    nop
    inc d
    ld bc, $00e2
    nop
    nop
    ld bc, $4001
    ld bc, $0200
    nop
    ld bc, $0002
    nop
    nop
    nop
    nop
    nop
    db $fc
    db $f4
    inc b
    db $fc
    ld a, [$06f4]
    nop
    ld hl, sp-$10
    ld [$f800], sp
    and $08
    nop
    or $e0
    ld a, [bc]
    nop
    db $f4
    xor $0c
    nop
    db $fd
    ld hl, sp+$03
    cp $fc
    or $04
    ld a, [$f4f4]
    inc c
    nop
    ld hl, sp-$10
    ld [$f000], sp
    ldh a, [rNR10]
    nop
    ldh a, [$f4]
    stop
    nop
    ldh [$08], a
    add sp, -$08
    ldh [rP1], a
    add sp, -$0c
    add sp, -$04
    ldh a, [$f8]
    add sp, $00
    ldh a, [$f8]
    ld [$1000], sp
    db $f4
    nop
    db $fc
    ld [$e0f8], sp
    ld [$f0f0], sp

jr_001_7fdd:
    ldh a, [rNR10]
    nop
    ldh a, [$ec]
    stop
    db $f4
    ldh a, [$0c]
    jr nc, jr_001_7fdd

    add sp, $0c
    nop
    db $f4
    nop
    inc c
    jr @-$0e

    ldh [rNR10], a
    ld hl, sp-$04
    ldh [rDIV], a
    ld h, b
    ldh [rDIV], a
    ld h, b
    ldh [rDIV], a
    ld h, b
    add h
    db $01
