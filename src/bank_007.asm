SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

LoadSound0::
    jp InitSound

; $4003
SoundTODO::
    call Call_007_63d4
    ld a, [$c506]
    and a
    jr z, jr_007_401e         ; Jump if [$c506] is zero.
    ld a, [CurrentSoundVolume]
    cp $01
    jr nz, jr_007_4036

jr_007_4013:
    ld hl, CurrentSong
    ld a, [hl]
    and $3f
    set 7, [hl]
    jp Jump_007_4082


jr_007_401e:
    ld a, [CurrentSong]
    bit 7, a
    jr nz, jr_007_4036

    bit 6, a
    jr z, jr_007_4013

    ld a, [$c504]
    and $07
    jr z, jr_007_4013

    ld a, [$c502]
    ld [$c506], a

jr_007_4036:
    ld a, [$c5c0]
    dec a
    ld [$c5c0], a
    call Call_007_414b
    call Call_007_4418
    call Call_007_46db
    call Call_007_4a06
    call Call_007_4c31
    ld a, [$c5c0]
    or a
    jr nz, jr_007_4054

    ld a, $09

jr_007_4054:
    ld [$c5c0], a
    ld a, [$c506]
    or a
    ret z
    dec a
    jr z, jr_007_4063
    ld [$c506], a
    ret

jr_007_4063:
    ld a, [CurrentSoundVolume]
    dec a
    cp $01
    jr z, jr_007_4073

    ld [CurrentSoundVolume], a
    call SetVolume
    jr jr_007_407b

jr_007_4073:
    xor a
    ld [$c504], a
    ld [$c506], a
    ret


jr_007_407b:
    ld a, [$c502]
    ld [$c506], a
    ret


Jump_007_4082:
    ld hl, $c503
    bit 7, [hl]
    ret z

    ld [$c505], a
    ld b, $00
    ld c, a
    sla c
    rlc b
    ld a, c
    ld l, a
    ld a, b
    ld h, a
    sla c
    rlc b
    sla c
    rlc b
    add hl, bc
    ld bc, $5543
    add hl, bc
    ld c, $0a
    ld de, $c507

jr_007_40a8:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, jr_007_40a8

    ld c, $0a
    ld hl, $c507
    ld de, $c511

jr_007_40b6:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, jr_007_40b6
    ld a, $01
    ld [$c52a], a     ; = 1
    ld [$c52b], a     ; = 1
    ld [$c52c], a     ; = 1
    ld [$c52d], a     ; = 1
    ld [$c52e], a     ; = 1
    dec a
    ld [$c53c], a     ; = 0
    ld [$c5bf], a     ; = 0
    ld [$c544], a     ; = 0
    ld [$c566], a     ; = 0
    ld [$c583], a     ; = 0
    ld [$c57f], a     ; = 0
    ld [$c506], a     ; = 0
    ld [$c5cb], a     ; = 0
    ld [$c5b9], a     ; = 0
    ld [$c5bb], a     ; = 0
    dec a
    ld [$c525], a     ; = $ff
    ld [$c526], a     ; = $ff
    ld [$c527], a     ; = $ff
    ld [$c528], a     ; = $ff
    ld [$c529], a     ; = $ff
    ld [$c5c3], a     ; = $ff
    ld a, $1f
    ld [$c504], a     ; = $1f
    ld a, $07
    call SetVolume    ; Load volume 7 = full volume.
    ld a, $09
    ld [$c5c0], a     ; = 9
    ld a, $00
    ld [$c5c4], a     ; = 0
    dec a
    ld [$c5c3], a     ; = $ff
    ret

; Initializes sound registers. Full volume on all outputs.
InitSound::
    ld a, $00
    ldh [rAUDENA], a            ; Stop all sound.
    ld a, $ff
    ld [CurrentSong], a         ; = $ff
    inc a
    ld [$c504], a               ; = 0
    ld [$c506], a               ; = 0
    ld [CurrentSoundVolume], a  ; = 0
    ld [$c5a6], a               ; = 0
    ld a, $ff
    ld [$c5c3], a               ; = $ff
    ld [EventSound], a          ; = $ff
    inc a
    ld [$c5c5], a               ; = 0
    ld [$c5cb], a               ; = 0
    ld [$c5c4], a               ; = 0
    ld a, %10001111             ; No effect except for bit7.
    ldh [rAUDENA], a            ; Turn on sound.
    ld a, $ff
    ldh [rAUDVOL], a            ; Full volume, both channels on.
    ldh [rAUDTERM], a           ; All sounds to all terminal.
    ret


Call_007_414b:
    ld a, [$c504]
    bit 0, a
    ret z

    ld a, [$c534]
    inc a
    jr z, jr_007_415a

    ld [$c534], a

jr_007_415a:
    ld a, [$c5c0]
    or a
    jp z, Jump_007_4354

    ld a, [$c52a]
    dec a
    jr z, jr_007_416d

    ld [$c52a], a
    jp Jump_007_4354


jr_007_416d:
    ld a, [$c525]
    cp $ff
    jr z, jr_007_417f

    ld a, [$c51b]
    ld l, a
    ld a, [$c51c]
    ld h, a
    jp Jump_007_420e


Jump_007_417f:
jr_007_417f:
    ld a, [$c507]
    ld e, a
    ld a, [$c508]
    ld d, a

jr_007_4187:
    ld a, [de]
    bit 7, a
    jr z, jr_007_41f0

    cp $a0
    jr nc, jr_007_4198

    inc de
    ld a, [de]
    ld [$c53f], a
    inc de
    jr jr_007_4187

jr_007_4198:
    cp $c0
    jr nc, jr_007_41c4

    bit 0, a
    jr z, jr_007_41b0

    inc de
    ld a, [de]
    ld [$c539], a
    inc de
    ld a, e
    ld [$c53a], a
    ld a, d
    ld [$c53b], a
    jr jr_007_4187

jr_007_41b0:
    inc de
    ld a, [$c539]
    dec a
    jr z, jr_007_4187

    ld [$c539], a
    ld a, [$c53a]
    ld e, a
    ld a, [$c53b]
    ld d, a
    jr jr_007_4187

jr_007_41c4:
    cp $ff
    jr c, jr_007_41d3

    ld hl, $c504
    res 0, [hl]
    ld hl, $ff26
    res 0, [hl]
    ret


jr_007_41d3:
    cp $fe
    jr c, jr_007_41e1

    ld a, [$c511]
    ld e, a
    ld a, [$c512]
    ld d, a
    jr jr_007_4187

jr_007_41e1:
    inc de
    ld a, [de]
    ld [$c511], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c512], a
    ld d, a
    ld e, b
    jr jr_007_4187

jr_007_41f0:
    and a
    jr nz, jr_007_41f5

    inc de
    ld a, [de]

jr_007_41f5:
    ld [$c525], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $626e
    add hl, bc
    inc de
    ld a, e
    ld [$c507], a
    ld a, d
    ld [$c508], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e

Jump_007_420e:
jr_007_420e:
    ld a, [hl+]
    bit 7, a
    jp z, Jump_007_42e6

    cp $a0
    jr nc, jr_007_4222

    and $1f
    jr nz, jr_007_421d

    ld a, [hl+]

jr_007_421d:
    ld [$c52f], a
    jr jr_007_420e

jr_007_4222:
    cp $b0
    jr nc, jr_007_429c

    and $0f
    jr nz, jr_007_423e

    ld [$c540], a
    ld [$c545], a
    ld [$c550], a
    ld [$c54b], a
    ld [$c553], a
    ld [$c555], a
    jr jr_007_420e

jr_007_423e:
    dec a
    jr nz, jr_007_4247

    ld a, [hl+]
    ld [$c540], a
    jr jr_007_420e

jr_007_4247:
    dec a
    jr nz, jr_007_425b

    ld a, [hl+]
    ld [$c549], a
    ld [$c54a], a
    ld a, [hl+]
    ld [$c548], a
    ld a, [hl+]
    ld [$c545], a
    jr jr_007_420e

jr_007_425b:
    dec a
    jr nz, jr_007_426c

    ld a, [hl+]
    ld [$c550], a
    ld a, [hl+]
    ld [$c551], a
    ld a, [hl+]
    ld [$c552], a
    jr jr_007_420e

jr_007_426c:
    dec a
    jr nz, jr_007_427d

    ld a, [hl+]
    ld [$c54e], a
    ld a, [hl+]
    ld [$c54d], a
    ld a, [hl+]
    ld [$c54b], a
    jr jr_007_420e

jr_007_427d:
    dec a
    jr nz, jr_007_428a

    ld a, [hl+]
    ld [$c554], a
    ld a, [hl+]
    ld [$c553], a
    jr jr_007_420e

jr_007_428a:
    dec a
    jr nz, jr_007_4299

    ld a, [hl+]
    ld [$c556], a
    ld a, [hl+]
    ld [$c555], a
    ld a, [hl+]
    ld [$c557], a

jr_007_4299:
    jp Jump_007_420e


jr_007_429c:
    cp $c0
    jr nc, jr_007_42af

    ld a, [hl+]
    ld [$c52a], a
    ld a, l
    ld [$c51b], a
    ld a, h
    ld [$c51c], a
    jp Jump_007_4354


jr_007_42af:
    cp $c2
    jr nc, jr_007_42c6

    bit 0, a
    ld a, [$c5bf]
    jr z, jr_007_42be

    res 0, a
    jr jr_007_42c0

jr_007_42be:
    set 0, a

jr_007_42c0:
    ld [$c5bf], a
    jp Jump_007_420e


jr_007_42c6:
    cp $ff
    jp z, Jump_007_417f

    cp $d0
    jr nz, jr_007_42d8

    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    push hl
    ld h, a
    ld l, b
    jp Jump_007_420e


jr_007_42d8:
    cp $d1
    jr nz, jr_007_42e0

    pop hl
    jp Jump_007_420e


jr_007_42e0:
    jp MainContinued


    jp Jump_007_417f


Jump_007_42e6:
    ld c, a
    ld a, [$c53f]
    add c
    ld [$c53c], a
    ld a, l
    ld [$c51b], a
    ld a, h
    ld [$c51c], a
    ld a, [$c53c]
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c53d], a
    ld a, [hl+]
    ld [$c53e], a
    xor a
    ld [$c559], a
    ld [$c55a], a
    ld [$c558], a
    ld a, [$c5bf]
    bit 0, a
    jr nz, jr_007_4342

    xor a
    ld [$c534], a
    ld [$c541], a
    ld [$c542], a
    ld [$c547], a
    ld [$c54c], a
    ld a, [$c54e]
    ld [$c54f], a
    ld a, [$c545]
    bit 7, a
    jr nz, jr_007_433d

    ld a, [$c549]
    ld [$c54a], a

jr_007_433d:
    ld a, $80
    ld [$c544], a

jr_007_4342:
    ld a, [$c52f]
    ld [$c52a], a
    ld a, [$c5c3]
    bit 7, a
    jr z, jr_007_4354

    ld hl, $c5cb
    res 0, [hl]

Jump_007_4354:
jr_007_4354:
    ld de, $c540
    ld a, [$c540]
    ld de, $511a
    add e
    ld e, a
    ld a, d
    adc $00
    ld d, a
    ld hl, $c541
    call Call_007_4ea9
    ld hl, $c545
    ld a, [$c534]
    ld c, a
    ld a, [$c54a]
    ld e, a
    call Call_007_4e82
    ld hl, $c54b
    ld a, [hl]
    or a
    jr z, jr_007_439b

    ld a, [$c54f]
    ld b, a
    ld a, [$c53c]
    ld c, a
    call Call_007_4e67
    ld b, $00
    sla c
    rl b
    ld hl, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c53d], a
    ld a, [hl]
    ld [$c53e], a

jr_007_439b:
    ld a, [$c534]
    ld hl, $c550
    call Call_007_43e6
    ld de, $c53d
    ld hl, $c555
    ld a, [$c534]
    call Call_007_4e08
    ld de, $c53d
    ld hl, $c553
    ld a, [$c534]
    call Call_007_4e4b
    ld a, [$c5cb]
    bit 0, a
    ret nz

    ld c, $10
    ld a, $08
    ld [c], a
    inc c
    ld a, [$c546]
    ld [c], a
    inc c
    ld hl, $c544
    bit 7, [hl]
    jr z, jr_007_43d8

    ld a, [$c543]
    ld [c], a

jr_007_43d8:
    inc c
    ld a, [$c53d]
    ld [c], a
    inc c
    ld a, [$c53e]
    or [hl]
    ld [c], a
    xor a
    ld [hl], a
    ret


Call_007_43e6:
    cp [hl]
    jr c, jr_007_43ef

    ret nz

    ld a, [$c53c]
    jr jr_007_4404

jr_007_43ef:
    inc hl
    ld a, [hl+]
    ld e, a
    bit 1, e
    jr z, jr_007_43fb

    and $c0
    ld [$c546], a

jr_007_43fb:
    ld c, [hl]
    bit 0, e
    jr z, jr_007_4405

    ld a, [$c53c]
    add c

jr_007_4404:
    ld c, a

jr_007_4405:
    ld b, $00
    sla c
    rl b
    ld hl, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c53d], a
    ld a, [hl]
    ld [$c53e], a
    ret


Call_007_4418:
    ld a, [$c504]
    bit 1, a
    ret z

    ld a, [$c535]
    inc a
    jr z, jr_007_4427

    ld [$c535], a

jr_007_4427:
    ld a, [$c5c0]
    or a
    jp z, Jump_007_4621

    ld a, [$c52b]
    dec a
    jr z, jr_007_443a

    ld [$c52b], a
    jp Jump_007_4621


jr_007_443a:
    ld a, [$c526]
    cp $ff
    jr z, jr_007_444c

    ld a, [$c51d]
    ld l, a
    ld a, [$c51e]
    ld h, a
    jp Jump_007_44db


Jump_007_444c:
jr_007_444c:
    ld a, [$c509]
    ld e, a
    ld a, [$c50a]
    ld d, a

jr_007_4454:
    ld a, [de]
    bit 7, a
    jr z, jr_007_44bd

    cp $a0
    jr nc, jr_007_4465

    inc de
    ld a, [de]
    ld [$c561], a
    inc de
    jr jr_007_4454

jr_007_4465:
    cp $c0
    jr nc, jr_007_4491

    bit 0, a
    jr z, jr_007_447d

    inc de
    ld a, [de]
    ld [$c55b], a
    inc de
    ld a, e
    ld [$c55c], a
    ld a, d
    ld [$c55d], a
    jr jr_007_4454

jr_007_447d:
    inc de
    ld a, [$c55b]
    dec a
    jr z, jr_007_4454

    ld [$c55b], a
    ld a, [$c55c]
    ld e, a
    ld a, [$c55d]
    ld d, a
    jr jr_007_4454

jr_007_4491:
    cp $ff
    jr c, jr_007_44a0

    ld hl, $c504
    res 1, [hl]
    ld hl, $ff26
    res 1, [hl]
    ret


jr_007_44a0:
    cp $fe
    jr c, jr_007_44ae

    ld a, [$c513]
    ld e, a
    ld a, [$c514]
    ld d, a
    jr jr_007_4454

jr_007_44ae:
    inc de
    ld a, [de]
    ld [$c513], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c514], a
    ld d, a
    ld e, b
    jr jr_007_4454

jr_007_44bd:
    and a
    jr nz, jr_007_44c2

    inc de
    ld a, [de]

jr_007_44c2:
    ld [$c526], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $626e
    add hl, bc
    inc de
    ld a, e
    ld [$c509], a
    ld a, d
    ld [$c50a], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e

Jump_007_44db:
jr_007_44db:
    ld a, [hl+]
    bit 7, a
    jp z, Jump_007_45b3

    cp $a0
    jr nc, jr_007_44ef

    and $1f
    jr nz, jr_007_44ea

    ld a, [hl+]

jr_007_44ea:
    ld [$c530], a
    jr jr_007_44db

jr_007_44ef:
    cp $b0
    jr nc, jr_007_4569

    and $0f
    jr nz, jr_007_450b

    ld [$c562], a
    ld [$c567], a
    ld [$c572], a
    ld [$c56d], a
    ld [$c575], a
    ld [$c577], a
    jr jr_007_44db

jr_007_450b:
    dec a
    jr nz, jr_007_4514

    ld a, [hl+]
    ld [$c562], a
    jr jr_007_44db

jr_007_4514:
    dec a
    jr nz, jr_007_4528

    ld a, [hl+]
    ld [$c56b], a
    ld [$c56c], a
    ld a, [hl+]
    ld [$c56a], a
    ld a, [hl+]
    ld [$c567], a
    jr jr_007_44db

jr_007_4528:
    dec a
    jr nz, jr_007_4539

    ld a, [hl+]
    ld [$c572], a
    ld a, [hl+]
    ld [$c573], a
    ld a, [hl+]
    ld [$c574], a
    jr jr_007_44db

jr_007_4539:
    dec a
    jr nz, jr_007_454a

    ld a, [hl+]
    ld [$c570], a
    ld a, [hl+]
    ld [$c56f], a
    ld a, [hl+]
    ld [$c56d], a
    jr jr_007_44db

jr_007_454a:
    dec a
    jr nz, jr_007_4557

    ld a, [hl+]
    ld [$c576], a
    ld a, [hl+]
    ld [$c575], a
    jr jr_007_44db

jr_007_4557:
    dec a
    jr nz, jr_007_4566

    ld a, [hl+]
    ld [$c578], a
    ld a, [hl+]
    ld [$c577], a
    ld a, [hl+]
    ld [$c579], a

jr_007_4566:
    jp Jump_007_44db


jr_007_4569:
    cp $c0
    jr nc, jr_007_457c

    ld a, [hl+]
    ld [$c52b], a
    ld a, l
    ld [$c51d], a
    ld a, h
    ld [$c51e], a
    jp Jump_007_4621


jr_007_457c:
    cp $c2
    jr nc, jr_007_4593

    bit 0, a
    ld a, [$c5bf]
    jr z, jr_007_458b

    res 1, a
    jr jr_007_458d

jr_007_458b:
    set 1, a

jr_007_458d:
    ld [$c5bf], a
    jp Jump_007_44db


jr_007_4593:
    cp $ff
    jp z, Jump_007_444c

    cp $d0
    jr nz, jr_007_45a5

    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    push hl
    ld h, a
    ld l, b
    jp Jump_007_44db


jr_007_45a5:
    cp $d1
    jr nz, jr_007_45ad

    pop hl
    jp Jump_007_44db


jr_007_45ad:
    jp MainContinued


    jp Jump_007_444c


Jump_007_45b3:
    ld c, a
    ld a, [$c561]
    add c
    ld [$c55e], a
    ld a, l
    ld [$c51d], a
    ld a, h
    ld [$c51e], a
    ld a, [$c55e]
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c55f], a
    ld a, [hl+]
    ld [$c560], a
    xor a
    ld [$c57b], a
    ld [$c57c], a
    ld [$c57a], a
    ld a, [$c5bf]
    bit 1, a
    jr nz, jr_007_460f

    xor a
    ld [$c535], a
    ld [$c563], a
    ld [$c564], a
    ld [$c569], a
    ld [$c56e], a
    ld a, [$c570]
    ld [$c571], a
    ld a, [$c567]
    bit 7, a
    jr nz, jr_007_460a

    ld a, [$c56b]
    ld [$c56c], a

jr_007_460a:
    ld a, $80
    ld [$c566], a

jr_007_460f:
    ld a, [$c530]
    ld [$c52b], a
    ld a, [$c5c3]
    bit 7, a
    jr z, jr_007_4621

    ld hl, $c5cb
    res 1, [hl]

Jump_007_4621:
jr_007_4621:
    ld de, $c562
    ld a, [$c562]
    ld de, $511a
    add e
    ld e, a
    ld a, d
    adc $00
    ld d, a
    ld hl, $c563
    call Call_007_4ea9
    ld hl, $c567
    ld a, [$c535]
    ld c, a
    ld a, [$c56c]
    ld e, a
    call Call_007_4e82
    ld hl, $c56d
    ld a, [hl]
    or a
    jr z, jr_007_4668

    ld a, [$c571]
    ld b, a
    ld a, [$c55e]
    ld c, a
    call Call_007_4e67
    ld b, $00
    sla c
    rl b
    ld hl, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c55f], a
    ld a, [hl]
    ld [$c560], a

jr_007_4668:
    ld a, [$c535]
    ld hl, $c572
    call Call_007_46b2
    ld de, $c55f
    ld hl, $c577
    ld a, [$c535]
    call Call_007_4e08
    ld de, $c55f
    ld hl, $c575
    ld a, [$c535]
    call Call_007_4e4b
    ld a, [$c5cb]
    bit 1, a
    ret nz

    ld c, $15
    ld a, $08
    inc c
    ld a, [$c568]
    ld [c], a
    inc c
    ld hl, $c566
    bit 7, [hl]
    jr z, jr_007_46a4

    ld a, [$c565]
    ld [c], a

jr_007_46a4:
    inc c
    ld a, [$c55f]
    ld [c], a
    inc c
    ld a, [$c560]
    or [hl]
    ld [c], a
    xor a
    ld [hl], a
    ret


Call_007_46b2:
    cp [hl]
    jr c, jr_007_46bb

    ret nz

    ld a, [$c55e]
    jr jr_007_46c7

jr_007_46bb:
    inc hl
    ld a, [hl+]
    ld e, a
    ld c, [hl]
    bit 0, e
    jr z, jr_007_46c8

    ld a, [$c55e]
    add c

jr_007_46c7:
    ld c, a

jr_007_46c8:
    ld b, $00
    sla c
    rl b
    ld hl, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c55f], a
    ld a, [hl]
    ld [$c560], a
    ret


Call_007_46db:
    ld a, [$c504]
    bit 2, a
    ret z

    ld a, [$c536]
    inc a
    jr z, jr_007_46ea

    ld [$c536], a

jr_007_46ea:
    ld a, [$c5c0]
    or a
    jp z, Jump_007_48ed

    ld a, [$c52c]
    dec a
    jr z, jr_007_46fd

    ld [$c52c], a
    jp Jump_007_48ed


jr_007_46fd:
    ld a, [$c527]
    cp $ff
    jr z, jr_007_470f

    ld a, [$c51f]
    ld l, a
    ld a, [$c520]
    ld h, a
    jp Jump_007_47a3


Jump_007_470f:
jr_007_470f:
    ld a, [$c50b]
    ld e, a
    ld a, [$c50c]
    ld d, a

jr_007_4717:
    ld a, [de]
    bit 7, a
    jr z, jr_007_4780

    cp $a0
    jr nc, jr_007_4728

    inc de
    ld a, [de]
    ld [$c58a], a
    inc de
    jr jr_007_4717

jr_007_4728:
    cp $c0
    jr nc, jr_007_4754

    bit 0, a
    jr z, jr_007_4740

    inc de
    ld a, [de]
    ld [$c584], a
    inc de
    ld a, e
    ld [$c585], a
    ld a, d
    ld [$c586], a
    jr jr_007_4717

jr_007_4740:
    inc de
    ld a, [$c584]
    dec a
    jr z, jr_007_4717

    ld [$c584], a
    ld a, [$c585]
    ld e, a
    ld a, [$c586]
    ld d, a
    jr jr_007_4717

jr_007_4754:
    cp $ff
    jr c, jr_007_4763

    ld hl, $c504
    res 2, [hl]
    ld hl, $ff26
    res 2, [hl]
    ret


jr_007_4763:
    cp $fe
    jr c, jr_007_4771

    ld a, [$c515]
    ld e, a
    ld a, [$c516]
    ld d, a
    jr jr_007_4717

jr_007_4771:
    inc de
    ld a, [de]
    ld [$c515], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c516], a
    ld d, a
    ld e, b
    jr jr_007_4717

jr_007_4780:
    and a
    jr nz, jr_007_4785

    inc de
    ld a, [de]

jr_007_4785:
    ld [$c527], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $626e
    add hl, bc
    inc de
    ld a, e
    ld [$c50b], a
    ld a, d
    ld [$c50c], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e
    ld a, $80
    ld [$c583], a

Jump_007_47a3:
jr_007_47a3:
    ld a, [hl+]
    bit 7, a
    jp z, Jump_007_487f

    cp $a0
    jr nc, jr_007_47b7

    and $1f
    jr nz, jr_007_47b2

    ld a, [hl+]

jr_007_47b2:
    ld [$c531], a
    jr jr_007_47a3

jr_007_47b7:
    cp $b0
    jp nc, Jump_007_484d

    and $0f
    jr nz, jr_007_47d7

    ld [$c580], a
    ld [$c581], a
    ld [$c582], a
    ld [$c596], a
    ld [$c591], a
    ld [$c599], a
    ld [$c59b], a
    jr jr_007_47a3

jr_007_47d7:
    dec a
    jr nz, jr_007_47e8

    ld a, [hl+]
    ld [$c580], a
    ld a, [hl+]
    ld [$c581], a
    ld a, [hl+]
    ld [$c582], a
    jr jr_007_47a3

jr_007_47e8:
    dec a
    jr nz, jr_007_47fc

    ld a, [hl+]
    ld [$c58f], a
    ld [$c590], a
    ld a, [hl+]
    ld [$c58e], a
    ld a, [hl+]
    ld [$c58b], a
    jr jr_007_47a3

jr_007_47fc:
    dec a
    jr nz, jr_007_480d

    ld a, [hl+]
    ld [$c596], a
    ld a, [hl+]
    ld [$c597], a
    ld a, [hl+]
    ld [$c598], a
    jr jr_007_47a3

jr_007_480d:
    dec a
    jr nz, jr_007_481e

    ld a, [hl+]
    ld [$c594], a
    ld a, [hl+]
    ld [$c593], a
    ld a, [hl+]
    ld [$c591], a
    jr jr_007_47a3

jr_007_481e:
    dec a
    jr nz, jr_007_482c

    ld a, [hl+]
    ld [$c59a], a
    ld a, [hl+]
    ld [$c599], a
    jp Jump_007_47a3


jr_007_482c:
    dec a
    jr nz, jr_007_483e

    ld a, [hl+]
    ld [$c59c], a
    ld a, [hl+]
    ld [$c59b], a
    ld a, [hl+]
    ld [$c59d], a
    jp Jump_007_47a3


jr_007_483e:
    dec a
    jr nz, jr_007_484a

    ld a, [hl+]
    ld [$c58c], a
    push hl
    call Call_007_4efd
    pop hl

jr_007_484a:
    jp Jump_007_47a3


Jump_007_484d:
    cp $c0
    jr nc, jr_007_4860

    ld a, [hl+]
    ld [$c52c], a
    ld a, l
    ld [$c51f], a
    ld a, h
    ld [$c520], a
    jp Jump_007_48ed


jr_007_4860:
    cp $c2
    jr nc, jr_007_4877

    bit 0, a
    ld a, [$c5bf]
    jr z, jr_007_486f

    res 2, a
    jr jr_007_4871

jr_007_486f:
    set 2, a

jr_007_4871:
    ld [$c5bf], a
    jp Jump_007_47a3


jr_007_4877:
    cp $ff
    jp z, Jump_007_470f

    jp Jump_007_470f


Jump_007_487f:
    ld c, a
    ld a, [$c58a]
    add c
    ld [$c587], a
    ld a, l
    ld [$c51f], a
    ld a, h
    ld [$c520], a
    ld a, [$c587]
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c588], a
    ld a, [hl+]
    ld [$c589], a
    xor a
    ld [$c59f], a
    ld [$c5a0], a
    ld [$c59e], a
    ld a, [$c5bf]
    bit 2, a
    jr nz, jr_007_48db

    xor a
    ld [$c536], a
    ld [$c57d], a
    ld [$c57e], a
    ld [$c58d], a
    ld [$c592], a
    ld a, $20
    ld [$c5c1], a
    ld a, [$c594]
    ld [$c595], a
    ld a, [$c58b]
    bit 7, a
    jr nz, jr_007_48db

    ld a, [$c58f]
    ld [$c590], a

jr_007_48db:
    ld a, [$c531]
    ld [$c52c], a
    ld a, [$c5c3]
    bit 7, a
    jr z, jr_007_48ed

    ld hl, $c5cb
    res 2, [hl]

Jump_007_48ed:
jr_007_48ed:
    ld a, [$c5cb]
    bit 2, a
    jr nz, jr_007_4911

    ld a, [$c5c1]
    bit 7, a
    jr nz, jr_007_4911

    bit 6, a
    jr z, jr_007_4911

    set 7, a
    res 6, a
    ld [$c5c1], a
    ld a, $80
    ld [$c583], a
    ld a, [$c58c]
    call Call_007_4efd

jr_007_4911:
    call Call_007_49bc
    ld hl, $c591
    ld a, [hl]
    or a
    jr z, jr_007_4938

    ld a, [$c595]
    ld b, a
    ld a, [$c587]
    ld c, a
    call Call_007_4e67
    ld b, $00
    sla c
    rl b
    ld hl, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c588], a
    ld a, [hl]
    ld [$c589], a

jr_007_4938:
    ld a, [$c536]
    ld hl, $c596
    call Call_007_498a
    ld de, $c588
    ld hl, $c59b
    ld a, [$c536]
    call Call_007_4e08
    ld de, $c588
    ld hl, $c599
    ld a, [$c536]
    call Call_007_4e4b
    ld a, [$c5cb]
    bit 2, a
    ret nz

    ld a, [$c5bb]
    and $0c
    ret nz

    ld c, $1a
    ld a, $ff
    ld [c], a
    inc c
    ld a, $ff
    ld [c], a
    inc c
    ld a, [$c57f]
    add $14
    ld l, a
    ld h, $4f
    ld a, [hl]
    ld [c], a
    inc c
    ld a, [$c588]
    ld [c], a
    inc c
    ld hl, $c583
    ld a, [$c589]
    or [hl]
    ld [c], a
    xor a
    ld [hl], a
    ret


Call_007_498a:
    cp [hl]
    jr c, jr_007_4993

    ret nz

    ld a, [$c587]
    jr jr_007_49a8

jr_007_4993:
    inc hl
    ld a, [hl+]
    ld e, a
    bit 1, e
    jr z, jr_007_499f

    and $c0
    ld [$c58c], a

jr_007_499f:
    ld c, [hl]
    bit 0, e
    jr z, jr_007_49a9

    ld a, [$c587]
    add c

jr_007_49a8:
    ld c, a

jr_007_49a9:
    ld b, $00
    sla c
    rl b
    ld hl, $4f18
    add hl, bc
    ld a, [hl+]
    ld [$c588], a
    ld a, [hl]
    ld [$c589], a
    ret


Call_007_49bc:
    ld a, [$c57d]
    bit 1, a
    ret nz

    bit 0, a
    jr nz, jr_007_49e4

    ld a, [$c580]
    ld [$c57f], a
    ld a, [$c581]
    and a
    jr nz, jr_007_49d8

    ld hl, $c57d
    inc [hl]
    jr jr_007_49e4

jr_007_49d8:
    ld hl, $c57e
    inc [hl]
    xor [hl]
    ret nz

    ld [hl], a
    ld hl, $c57d
    inc [hl]
    ret


jr_007_49e4:
    ld a, [$c582]
    and a
    jr nz, jr_007_49ef

    ld [$c57f], a
    jr jr_007_4a01

jr_007_49ef:
    ld hl, $c57e
    inc [hl]
    xor [hl]
    ret nz

    ld [hl], a
    ld a, [$c57f]
    or a
    jr z, jr_007_4a01

    dec a
    ld [$c57f], a
    ret


jr_007_4a01:
    ld hl, $c57d
    inc [hl]
    ret


Call_007_4a06:
    ld a, [$c504]
    bit 3, a
    ret z

    ld a, [$c537]
    inc a
    jr z, jr_007_4a15

    ld [$c537], a

jr_007_4a15:
    ld a, [$c5c0]
    or a
    jp z, Jump_007_4bad

    ld a, [$c52d]
    dec a
    jr z, jr_007_4a28

    ld [$c52d], a
    jp Jump_007_4bad


jr_007_4a28:
    ld a, [$c528]
    cp $ff
    jr z, jr_007_4a3a

    ld a, [$c521]
    ld l, a
    ld a, [$c522]
    ld h, a
    jp Jump_007_4ac9


Jump_007_4a3a:
jr_007_4a3a:
    ld a, [$c50d]
    ld e, a
    ld a, [$c50e]
    ld d, a

jr_007_4a42:
    ld a, [de]
    bit 7, a
    jr z, jr_007_4aab

    cp $a0
    jr nc, jr_007_4a53

    inc de
    ld a, [de]
    ld [$c5a7], a
    inc de
    jr jr_007_4a42

jr_007_4a53:
    cp $c0
    jr nc, jr_007_4a7f

    bit 0, a
    jr z, jr_007_4a6b

    inc de
    ld a, [de]
    ld [$c5a1], a
    inc de
    ld a, e
    ld [$c5a2], a
    ld a, d
    ld [$c5a3], a
    jr jr_007_4a42

jr_007_4a6b:
    inc de
    ld a, [$c5a1]
    dec a
    jr z, jr_007_4a42

    ld [$c5a1], a
    ld a, [$c5a2]
    ld e, a
    ld a, [$c5a3]
    ld d, a
    jr jr_007_4a42

jr_007_4a7f:
    cp $ff
    jr c, jr_007_4a8e

    ld hl, $c504
    res 3, [hl]
    ld hl, $ff26
    res 3, [hl]
    ret


jr_007_4a8e:
    cp $fe
    jr c, jr_007_4a9c

    ld a, [$c517]
    ld e, a
    ld a, [$c518]
    ld d, a
    jr jr_007_4a42

jr_007_4a9c:
    inc de
    ld a, [de]
    ld [$c517], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c518], a
    ld d, a
    ld e, b
    jr jr_007_4a42

jr_007_4aab:
    and a
    jr nz, jr_007_4ab0

    inc de
    ld a, [de]

jr_007_4ab0:
    ld [$c528], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $626e
    add hl, bc
    inc de
    ld a, e
    ld [$c50d], a
    ld a, d
    ld [$c50e], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e

Jump_007_4ac9:
jr_007_4ac9:
    ld a, [hl+]
    bit 7, a
    jp z, Jump_007_4b5d

    cp $a0
    jr nc, jr_007_4add

    and $1f
    jr nz, jr_007_4ad8

    ld a, [hl+]

jr_007_4ad8:
    ld [$c532], a
    jr jr_007_4ac9

jr_007_4add:
    cp $b0
    jr nc, jr_007_4b2b

    and $0f
    jr nz, jr_007_4af0

    ld [$c5a8], a
    ld [$c5ad], a
    ld [$c5b2], a
    jr jr_007_4ac9

jr_007_4af0:
    dec a
    jr nz, jr_007_4af9

    ld a, [hl+]
    ld [$c5a8], a
    jr jr_007_4ac9

jr_007_4af9:
    dec a
    jr nz, jr_007_4b02

    ld a, [hl+]
    ld [$c5a6], a
    jr jr_007_4ac9

jr_007_4b02:
    dec a
    jr nz, jr_007_4b07

    jr jr_007_4ac9

jr_007_4b07:
    dec a
    jr nz, jr_007_4b18

    ld a, [hl+]
    ld [$c5b0], a
    ld a, [hl+]
    ld [$c5af], a
    ld a, [hl+]
    ld [$c5ad], a
    jr jr_007_4ac9

jr_007_4b18:
    dec a
    jr nz, jr_007_4b25

    ld a, [hl+]
    ld [$c5b3], a
    ld a, [hl+]
    ld [$c5b2], a
    jr jr_007_4ac9

jr_007_4b25:
    dec a
    jr nz, jr_007_4b28

jr_007_4b28:
    jp Jump_007_4ac9


jr_007_4b2b:
    cp $c0
    jr nc, jr_007_4b3e

    ld a, [hl+]
    ld [$c52d], a
    ld a, l
    ld [$c521], a
    ld a, h
    ld [$c522], a
    jp Jump_007_4bad


jr_007_4b3e:
    cp $c2
    jr nc, jr_007_4b55

    bit 0, a
    ld a, [$c5bf]
    jr z, jr_007_4b4d

    res 3, a
    jr jr_007_4b4f

jr_007_4b4d:
    set 3, a

jr_007_4b4f:
    ld [$c5bf], a
    jp Jump_007_4ac9


jr_007_4b55:
    cp $ff
    jp z, Jump_007_4a3a

    jp Jump_007_4a3a


Jump_007_4b5d:
    ld c, a
    ld a, [$c5a7]
    add c
    ld [$c5a4], a
    ld a, l
    ld [$c521], a
    ld a, h
    ld [$c522], a
    ld a, [$c5a4]
    ld l, a
    ld h, $00
    ld bc, $4fc0
    add hl, bc
    ld a, [hl+]
    ld [$c5a5], a
    xor a
    ld a, [$c5bf]
    bit 3, a
    jr nz, jr_007_4b9b

    xor a
    ld [$c537], a
    ld [$c5a9], a
    ld [$c5aa], a
    ld [$c5ae], a
    ld a, [$c5b0]
    ld [$c5b1], a
    ld a, $80
    ld [$c5ac], a

jr_007_4b9b:
    ld a, [$c532]
    ld [$c52d], a
    ld a, [$c5c3]
    bit 7, a
    jr z, jr_007_4bad

    ld hl, $c5cb
    res 3, [hl]

Jump_007_4bad:
jr_007_4bad:
    ld de, $c5a8
    ld a, [$c5a8]
    ld de, $511a
    add e
    ld e, a
    ld a, d
    adc $00
    ld d, a
    ld hl, $c5a9
    call Call_007_4ea9
    ld hl, $c5ad
    ld a, [hl]
    or a
    jr z, jr_007_4bde

    ld a, [$c5b1]
    ld b, a
    ld a, [$c5a4]
    ld c, a
    call Call_007_4e67
    ld b, $00
    ld hl, $4fc0
    add hl, bc
    ld a, [hl+]
    ld [$c5a5], a

jr_007_4bde:
    call Call_007_4c12
    ld a, [$c5cb]
    bit 3, a
    ret nz

    ld a, [$c5bb]
    and $03
    ret nz

    ld c, $20
    ld a, $3f
    ld [c], a
    inc c
    ld hl, $c5ac
    bit 7, [hl]
    jr z, jr_007_4bfe

    ld a, [$c5ab]
    ld [c], a

jr_007_4bfe:
    inc c
    ld hl, $c5a6
    ld a, [$c5a5]
    or [hl]
    ld [c], a
    inc c
    ld a, [$c5ac]
    ret z

    ld [c], a
    xor a
    ld [$c5ac], a
    ret


Call_007_4c12:
    ld a, [$c537]
    ld hl, $c5b2
    cp [hl]
    ret c

    ld a, [hl]
    and a
    ret z

    inc hl
    ld a, [$c5a4]
    add [hl]
    ld [$c5a4], a
    ld c, a
    ld b, $00
    ld hl, $4fc0
    add hl, bc
    ld a, [hl+]
    ld [$c5a5], a
    ret


Call_007_4c31:
    ld a, [$c504]
    bit 4, a
    ret z

    ld a, [$c538]
    inc a
    jr z, jr_007_4c40

    ld [$c538], a

jr_007_4c40:
    ld a, [$c5c0]
    or a
    jp z, Jump_007_4d44

    ld a, [$c52e]
    dec a
    jr z, jr_007_4c53

    ld [$c52e], a
    jp Jump_007_4d44


jr_007_4c53:
    ld a, [$c529]
    cp $ff
    jr z, jr_007_4c65

    ld a, [$c523]
    ld l, a
    ld a, [$c524]
    ld h, a
    jp Jump_007_4ce3


Jump_007_4c65:
jr_007_4c65:
    ld a, [$c50f]
    ld e, a
    ld a, [$c510]
    ld d, a

jr_007_4c6d:
    ld a, [de]
    bit 7, a
    jr z, jr_007_4cc5

    cp $c0
    jr nc, jr_007_4c9e

    bit 0, a
    jr z, jr_007_4c8a

    inc de
    ld a, [de]
    ld [$c5b4], a
    inc de
    ld a, e
    ld [$c5b5], a
    ld a, d
    ld [$c5b6], a
    jr jr_007_4c6d

jr_007_4c8a:
    inc de
    ld a, [$c5b4]
    dec a
    jr z, jr_007_4c6d

    ld [$c5b4], a
    ld a, [$c5b5]
    ld e, a
    ld a, [$c5b6]
    ld d, a
    jr jr_007_4c6d

jr_007_4c9e:
    cp $ff
    jr c, jr_007_4ca8

    ld hl, $c504
    res 4, [hl]
    ret


jr_007_4ca8:
    cp $fe
    jr c, jr_007_4cb6

    ld a, [$c519]
    ld e, a
    ld a, [$c51a]
    ld d, a
    jr jr_007_4c6d

jr_007_4cb6:
    inc de
    ld a, [de]
    ld [$c519], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c51a], a
    ld d, a
    ld e, b
    jr jr_007_4c6d

jr_007_4cc5:
    and a
    jr nz, jr_007_4cca

    inc de
    ld a, [de]

jr_007_4cca:
    ld [$c529], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $626e
    add hl, bc
    inc de
    ld a, e
    ld [$c50f], a
    ld a, d
    ld [$c510], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e

Jump_007_4ce3:
jr_007_4ce3:
    ld a, [hl+]
    bit 7, a
    jp z, Jump_007_4cff

    cp $a0
    jr nc, jr_007_4cf7

    and $1f
    jr nz, jr_007_4cf2

    ld a, [hl+]

jr_007_4cf2:
    ld [$c533], a
    jr jr_007_4ce3

jr_007_4cf7:
    cp $ff
    jp z, Jump_007_4c65

    jp Jump_007_4c65


Jump_007_4cff:
    ld [$c5b9], a
    ld a, l
    ld [$c523], a
    ld a, h
    ld [$c524], a
    ld a, [$c5b9]
    and a
    jr z, jr_007_4d25

    ld l, a
    ld h, $00
    add hl, hl
    ld bc, $51c8
    add hl, bc
    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    ld h, a
    ld l, b
    ld a, l
    ld [$c5b8], a
    ld a, h
    ld [$c5b7], a

jr_007_4d25:
    xor a
    ld [$c538], a
    ld [$c5c1], a
    ld a, $80
    ldh [rNR30], a
    ld a, [$c533]
    ld [$c52e], a
    ld a, [$c5c3]
    bit 7, a
    jr z, jr_007_4d44

    ld hl, $c5cb
    res 2, [hl]
    res 3, [hl]

Jump_007_4d44:
jr_007_4d44:
    ld a, [$c5b9]
    and a
    jr nz, jr_007_4d4b

    ret


jr_007_4d4b:
    xor a
    ld [$c5bb], a
    ld a, [$c5b8]
    ld l, a
    ld a, [$c5b7]
    ld h, a
    ld a, [hl+]
    ld [$c5bb], a
    bit 7, a
    jr z, jr_007_4d72

    ld [$c5ba], a
    xor a
    ld [$c5b9], a
    ld [$c5bb], a
    ld a, [$c5c1]
    set 6, a
    ld [$c5c1], a
    ret


jr_007_4d72:
    ld a, [hl+]
    ld [$c5bc], a
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld [$c5bd], a
    ld a, l
    ld [$c5b8], a
    ld a, h
    ld [$c5b7], a
    ld a, [$c5cb]
    and $04
    jr nz, jr_007_4dc6

    ld a, [$c5bb]
    ld b, a
    and $0c
    jr nz, jr_007_4d9f

    ld a, [$c5c1]
    set 6, a
    ld [$c5c1], a
    jr jr_007_4dc6

jr_007_4d9f:
    ld b, a
    bit 3, a
    jr z, jr_007_4da9

    ld a, [$c5bc]
    ldh [rNR32], a

jr_007_4da9:
    ld a, [$c5bb]
    bit 2, a
    jr z, jr_007_4dc6

    ld l, c
    ld h, $00
    add hl, hl
    ld bc, $4f18
    add hl, bc
    ld a, [hl+]
    ldh [rNR33], a
    ld a, [$c538]
    and a
    ld a, [hl+]
    jr nz, jr_007_4dc4

    or $80

jr_007_4dc4:
    ldh [rNR34], a

jr_007_4dc6:
    ld a, [$c5cb]
    and $08
    jr nz, jr_007_4ded

    ld a, [$c5bb]
    bit 1, a
    jr z, jr_007_4ddd

    ld d, $00
    ld hl, $4fc0
    add hl, de
    ld a, [hl]
    ldh [rNR43], a

jr_007_4ddd:
    ld a, [$c5bb]
    bit 0, a
    jr z, jr_007_4ded

    ld a, [$c5bd]
    ldh [rNR42], a
    ld a, $80
    ldh [rNR44], a

jr_007_4ded:
    ret

; $64dee
; Loads a sound volume setting (see VolumeSettings) from $4e00 + "a"
; Saves old "a" to CurrentSoundVolume. There are 8 volume settings in total.
SetVolume::
    ld [CurrentSoundVolume], a
    ld de, VolumeSettings
    add e
    ld e, a
    ld a, [de]
    ldh [rAUDVOL], a ; [rAUDVOL] = $4e00 + a
    ret

; $64dfa: I guess this is just non-occupied space.
EmptySpace:
    db $00,$00,$00,$00,$00,$00

VolumeSettings:
    db $88,$99,$aa,$bb,$cc,$dd,$ee,$ff

Call_007_4e08:
    cp [hl]
    ret c

    ld a, [hl+]
    or a
    ret z

    ld a, [hl]
    swap a
    and $0f
    ld b, a
    ld a, [hl+]
    and $0f
    ld c, a
    ld a, [hl+]
    add [hl]
    ld [hl-], a
    jr z, jr_007_4e1d

    ret nc

jr_007_4e1d:
    ld a, [hl+]
    ld [hl+], a
    ld a, [hl+]
    bit 1, a
    jr nz, jr_007_4e2e

    ld a, [de]
    add b
    ld [de], a
    inc de
    ld a, [de]
    jr nc, jr_007_4e3b

    inc a
    jr jr_007_4e3b

jr_007_4e2e:
    ld a, b
    xor $ff
    inc a
    ld b, a
    ld a, [de]
    add b
    ld [de], a
    inc de
    ld a, [de]
    jr c, jr_007_4e3b

    dec a

jr_007_4e3b:
    ld [de], a
    ld a, c
    inc [hl]
    xor [hl]
    ret nz

    ld [hl-], a
    ld a, [hl]
    dec a
    bit 7, a
    jr z, jr_007_4e49

    ld a, $03

jr_007_4e49:
    ld [hl], a
    ret


Call_007_4e4b:
    cp [hl]
    ret c

    ld a, [hl]
    or a
    ret z

    inc hl
    bit 7, [hl]
    jr nz, jr_007_4e5e

    ld a, [de]
    add [hl]
    ld [de], a
    inc de
    ld a, [de]
    adc $00
    ld [de], a
    ret


jr_007_4e5e:
    ld a, [de]
    add [hl]
    ld [de], a
    inc de
    ld a, [de]
    ret c

    dec a
    ld [de], a
    ret


Call_007_4e67:
    ld de, $5147
    ld a, b
    add e
    ld e, a
    jr nc, jr_007_4e70

    inc d

jr_007_4e70:
    ld a, [de]
    add c
    ld c, a
    ld a, [hl+]
    inc [hl]
    xor [hl]
    ret nz

    ld [hl+], a
    inc b
    ld a, b
    cp [hl]
    inc hl
    jr nz, jr_007_4e7f

    ld b, [hl]

jr_007_4e7f:
    inc hl
    ld [hl], b
    ret


Call_007_4e82:
    ld a, [hl+]
    or a
    ret z

    ld b, a
    ld a, $90
    add e
    ld e, a
    ld d, $51
    ld a, [de]
    ld [hl+], a
    bit 7, b
    jr z, jr_007_4e97

    ld a, c
    or a
    jr z, jr_007_4e9c

    ret


jr_007_4e97:
    ld a, b
    inc [hl]
    xor [hl]
    ret nz

    ld [hl], a

jr_007_4e9c:
    ld a, e
    sub $90
    inc hl
    inc a
    cp [hl]
    inc hl
    jr nz, jr_007_4ea6

    ld a, [hl]

jr_007_4ea6:
    inc hl
    ld [hl], a
    ret


Call_007_4ea9:
    ld a, [hl]
    bit 1, a
    jr nz, jr_007_4eed

    bit 0, a
    jr nz, jr_007_4ecf

    ld a, [de]
    and a
    jr nz, jr_007_4eb9

    inc [hl]
    jr jr_007_4ecf

jr_007_4eb9:
    inc hl
    inc [hl]
    xor [hl]
    jr z, jr_007_4ecb

    inc de
    ld a, [de]
    inc hl
    ld [hl-], a
    ld a, [hl+]
    cp $01
    ret nz

    inc hl
    ld a, $80
    ld [hl], a
    ret


jr_007_4ecb:
    ld [hl], a
    dec hl
    inc [hl]
    ret


jr_007_4ecf:
    inc de
    inc de
    ld a, [de]
    and a
    jr nz, jr_007_4ed8

    inc [hl]
    jr jr_007_4ef2

jr_007_4ed8:
    inc hl
    inc [hl]
    xor [hl]
    jr z, jr_007_4eea

    inc de
    inc hl
    ld a, [de]
    ld [hl-], a
    ld a, [hl+]
    cp $01
    ret nz

    ld a, $80
    inc hl
    ld [hl], a
    ret


jr_007_4eea:
    ld [hl-], a
    inc [hl]
    ret


jr_007_4eed:
    bit 0, a
    ret nz

    inc de
    inc de

jr_007_4ef2:
    inc de
    inc de
    inc [hl]
    inc hl
    inc hl
    ld a, [de]
    ld [hl+], a
    ld a, $80
    ld [hl], a
    ret


Call_007_4efd:
    ld b, $00
    ld c, a
    ld l, $98
    ld h, $51
    add hl, bc
    xor a
    ldh [rNR30], a
    ld c, $10
    ld de, $ff30

jr_007_4f0d:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, jr_007_4f0d

    ret


    nop
    ld h, b
    ld b, b
    jr nz, @+$2e

    nop
    sbc l
    nop
    rlca
    ld bc, $016b
    ret


    ld bc, $0223
    ld [hl], a
    ld [bc], a
    rst $00
    ld [bc], a
    ld [de], a
    inc bc
    ld e, b
    inc bc
    sbc e
    inc bc
    jp c, $1603

    inc b
    ld c, [hl]
    inc b
    add e
    inc b
    or l
    inc b
    push hl
    inc b
    ld de, $3b05
    dec b
    ld h, e
    dec b
    adc c
    dec b
    xor h
    dec b
    adc $05
    db $ed
    dec b
    dec bc
    ld b, $27
    ld b, $42
    ld b, $5b
    ld b, $72
    ld b, $89
    ld b, $9e
    ld b, $b2
    ld b, $c4
    ld b, $d6
    ld b, $e7
    ld b, $f7
    ld b, $06
    rlca
    inc d
    rlca
    ld hl, $2d07
    rlca
    add hl, sp
    rlca
    ld b, h
    rlca
    ld c, a
    rlca
    ld e, c
    rlca
    ld h, d
    rlca
    ld l, e
    rlca
    ld [hl], e
    rlca
    ld a, e
    rlca
    add e
    rlca
    adc d
    rlca
    sub b
    rlca
    sub a
    rlca
    sbc l
    rlca
    and d
    rlca
    and a
    rlca
    xor h
    rlca
    or c
    rlca
    or [hl]
    rlca
    cp d
    rlca
    cp [hl]
    rlca
    pop bc
    rlca
    push bc
    rlca
    ret z

    rlca
    rlc a
    adc $07
    pop de
    rlca
    call nc, $d607
    rlca
    reti


    rlca
    db $db
    rlca
    db $dd
    rlca
    rst $18
    rlca
    pop hl
    rlca
    ld [c], a
    rlca
    db $e4
    rlca
    and $07
    rst $20
    rlca
    jp hl


    rlca
    ld [$eb07], a
    rlca
    db $ec
    rlca
    db $ed
    rlca
    xor $07
    rst $28
    rlca
    rst $10
    sub $d5
    call nc, $c6c7
    push bc
    call nz, $b6b7
    or l
    or h
    and a
    and [hl]
    and l
    and h
    sub a
    sub [hl]
    sub l
    sub h
    add a
    add [hl]
    add l
    add h
    ld [hl], a
    db $76
    ld [hl], l
    ld [hl], h
    ld h, a
    ld h, [hl]
    ld h, l
    ld h, h
    ld d, a
    ld d, [hl]
    ld d, l
    ld d, h
    ld b, a
    ld b, [hl]
    ld b, l
    ld b, h
    scf
    ld [hl], $35
    inc [hl]
    daa
    ld h, $25
    inc h
    rla
    ld d, $15
    inc d
    rlca
    ld b, $05
    inc b
    inc bc
    ld [bc], a
    ld bc, $0000
    nop
    nop
    nop
    and b
    pop de
    and c
    dec b
    and d
    ld bc, $0505
    and h
    nop
    inc bc
    ld bc, $a1d1
    ld a, [bc]
    and d
    nop
    inc b
    ld b, $a4
    inc bc
    ld b, $01
    pop de
    and c
    dec b
    and d
    ld bc, $0505
    and h
    ld b, $09
    ld bc, $a1d1
    ld a, [bc]
    and d
    nop
    inc b
    ld b, $a4
    add hl, bc
    inc c
    ld bc, $a1d1
    dec b
    and d
    ld bc, $0505
    and h
    inc c
    rrca
    ld bc, $a1d1
    ld a, [bc]
    and d
    nop
    inc b
    ld b, $a4
    rrca
    ld [de], a
    ld bc, $a1d1
    dec b
    and d
    ld bc, $0505
    and h
    ld [de], a
    dec d
    ld bc, $a1d1
    ld a, [bc]
    and d
    nop
    inc b
    ld b, $a4
    dec d
    jr jr_007_505a

    pop de

jr_007_505a:
    and c
    dec b
    and d
    ld bc, $0505
    and h
    jr jr_007_507e

    ld bc, $a1d1
    ld a, [bc]
    and d
    nop
    inc b
    ld b, $a4
    dec de
    ld e, $01
    pop de
    and c
    dec b
    and d
    ld bc, $0505
    and h
    ld e, $21
    ld bc, $a1d1
    ld a, [bc]
    and d

jr_007_507e:
    nop
    inc b
    ld b, $a4
    ld hl, $0124
    pop de
    and c
    dec b
    and d
    ld bc, $0505
    and h
    inc h
    daa
    ld bc, $a1d1
    ld a, [bc]
    and d
    nop
    inc b
    ld b, $a4
    daa
    ld a, [hl+]
    ld bc, $a1d1
    dec b
    and d
    ld bc, $0505
    and h
    ld a, [hl+]
    dec l
    ld bc, $a1d1
    ld a, [bc]
    and d
    nop
    inc b
    ld b, $a4
    dec l
    jr nc, jr_007_50b2

    pop de

jr_007_50b2:
    and c
    dec b
    and d
    ld bc, $0505
    and h
    jr nc, jr_007_50ee

    ld bc, $a0d1
    and d
    ld [bc], a
    inc bc
    ld bc, $1ea1
    and [hl]
    inc de
    db $10
    add c
    pop de
    and b
    and c
    ld a, [bc]
    and d
    nop
    ld bc, $d101
    and b
    and c
    dec b
    and d
    ld [bc], a
    ld b, $07
    and h
    ld [hl], $3a
    ld bc, $a0d1
    and d
    ld [bc], a
    inc bc
    ld bc, $01a3
    ld b, e
    nop
    pop de
    and b
    and c
    dec b
    and d
    ld [bc], a
    ld b, $07

jr_007_50ee:
    and h
    ld [hl], $39
    ld bc, $a0d1
    and c
    dec b
    and d
    ld [bc], a
    ld b, $07
    and h
    ld e, $21
    ld bc, $a0d1
    and c
    dec b
    and d
    ld [bc], a
    ld b, $07
    and h
    ld a, $41
    ld bc, $a1d1
    dec b
    and d
    ld [bc], a
    inc bc
    ld bc, $13a6
    ld [$a381], sp
    ld [bc], a
    ld bc, $d113
    nop
    nop
    nop
    nop
    nop
    inc bc
    ld [hl], b
    ld [$1310], sp
    inc bc
    ld b, b
    inc bc
    db $10
    ld de, $0000
    nop
    nop
    ld sp, $9003
    jr z, @+$52

    ld b, a
    inc bc
    sub b
    inc bc
    ld d, b
    ld b, l
    ld [bc], a
    add hl, hl
    ld b, b
    jr nc, @+$39

    inc bc
    ld [hl], b
    db $10
    db $10
    inc de
    inc bc
    add b
    jr jr_007_5186

    ld b, a
    nop
    inc b
    rlca
    rlca
    inc b
    nop
    nop
    dec b
    add hl, bc
    add hl, bc
    dec b
    nop
    nop
    ld b, $09
    add hl, bc
    ld b, $00
    nop
    inc bc
    ld [$0308], sp
    nop
    nop
    inc bc
    rlca
    rlca
    inc bc
    nop
    cp $04
    rlca
    rlca
    inc b
    cp $00
    inc bc
    add hl, bc
    add hl, bc
    inc bc
    nop
    nop
    dec b
    ld [$0508], sp
    nop
    nop
    inc b
    add hl, bc
    add hl, bc
    inc b
    nop
    db $fd
    nop
    inc bc
    rlca
    ld hl, sp-$05
    nop
    inc b
    nop

jr_007_5186:
    inc b
    ld a, [bc]
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

    add b
    ld b, b
    nop
    nop
    ld bc, $4523
    ld h, a
    adc c
    xor e
    call $edef
    res 5, c
    add a
    ld h, l
    ld b, e
    ld hl, $0100
    inc h
    ld l, b
    xor e
    call $ffef
    rst $38
    rst $38
    rst $38
    cp $dc
    cp d
    add [hl]
    ld b, d
    db $10
    ld a, h
    xor $ef
    rst $38
    rst $38
    xor $ed
    ret


    ld h, e
    ld hl, $1011
    nop
    ld bc, $3711
    call nc, $d651
    ld d, c
    pop hl
    ld d, c
    nop
    ld d, d
    dec bc
    ld d, d
    ld de, $0052
    rst $38
    rrca
    jr nz, jr_007_51f1

    ld a, [hl-]
    ld [hl], c
    inc c
    jr nz, jr_007_51f0

    ld a, [hl-]
    nop
    rst $38
    rrca
    jr nz, jr_007_5204

    inc [hl]
    sub c
    ld c, $20
    inc e
    scf
    nop
    ld [bc], a
    nop
    nop
    add hl, sp
    nop

jr_007_51f0:
    ld [bc], a

jr_007_51f1:
    nop
    nop
    scf
    nop
    ld [bc], a
    nop
    nop
    add hl, sp
    nop
    ld [bc], a
    nop
    nop
    scf
    nop
    rst $38
    rrca
    jr nz, @+$22

    dec [hl]

jr_007_5204:
    ld h, c
    ld [bc], a
    jr nz, jr_007_5224

    scf
    nop
    rst $38
    inc bc
    nop
    dec de
    inc [hl]
    ld b, c
    rst $38
    inc bc
    ld bc, $331c
    ld hl, $80ff
    nop
    rst $38
    rst $38
    add b
    dec b
    jr nz, @+$05

    inc bc
    rlca
    ld [$0903], sp

jr_007_5224:
    ld a, [bc]
    rla
    inc bc
    inc c
    rlca
    dec c
    inc bc
    dec bc
    inc d
    ld [de], a
    dec bc
    dec bc
    inc bc
    inc bc
    dec bc
    dec bc
    inc bc
    inc c
    rlca
    ld d, $03
    ld [$0318], sp
    add hl, bc
    add hl, bc
    add hl, bc
    add hl, bc
    add b
    ld [bc], a
    ld [de], a
    add b
    dec b
    ld a, [bc]
    dec bc
    inc bc
    ld e, $14
    ld [de], a
    db $fd
    ld e, $52
    add b
    db $ed
    ld c, $0f
    ld a, [de]
    cp $80
    dec b
    nop
    nop
    inc b
    dec d
    dec de
    inc e
    db $fd
    ld e, b
    ld d, d
    add b
    ei
    ld a, a
    and c
    ld c, $05
    and b
    ld [bc], a
    and c
    ld c, $05
    and b
    ld bc, $18a1
    dec b
    and b
    ld bc, Entry
    dec b
    dec b
    dec b
    dec b
    dec b
    dec b
    and c
    ld b, $05
    and b
    ld bc, $0aa1
    dec b
    and b
    ld [bc], a
    db $fd
    ld h, d
    ld d, d
    ld de, $07a1
    ld b, $a0
    inc de
    and c
    rlca
    ld b, $a0
    rra
    and c
    inc c
    ld b, $a0
    add hl, de
    ld b, $06
    ld b, $06
    ld b, $1f
    ld b, $06
    ld b, $06
    ld b, $13
    db $fd
    add a
    ld d, d
    add b
    db $fc
    inc h
    cp $80
    db $fc
    and c
    dec bc
    daa
    and b
    dec e
    db $10
    dec e
    db $10
    daa
    cp $80
    db $fc
    inc hl
    cp $80
    nop
    ld bc, $22fe
    cp $80
    ld hl, sp+$2a
    and c
    ld [$a02b], sp
    add b
    db $fd
    dec hl
    dec hl
    dec hl
    dec hl
    add b
    ei
    dec hl
    dec hl
    dec hl
    dec hl
    add b
    ld sp, hl
    dec hl
    dec hl
    dec hl
    dec hl
    add b
    ld sp, hl
    dec hl
    dec hl
    add b
    ld hl, sp+$2c
    inc l
    add b
    ld sp, hl
    inc l
    inc l
    add b
    ld hl, sp-$5f
    ld [$a02b], sp
    cp $80
    inc b
    dec h
    cp $80
    ld hl, sp-$5f
    ld [$a026], sp
    add b
    db $fd
    ld h, $26
    ld h, $26
    add b
    ei
    ld h, $26
    ld h, $26
    add b
    ld sp, hl
    ld h, $26
    ld h, $26
    add b
    ld sp, hl
    ld h, $26
    add b
    di
    ld h, $26
    add b
    db $f4
    ld h, $26
    add b
    ld hl, sp-$5f
    ld [$a026], sp
    cp $80
    nop

jr_007_531c:
    jr z, jr_007_531c

    add hl, hl
    cp $80
    db $f4
    and c
    rlca
    dec l
    and b
    ld l, $a1
    ld [bc], a
    cpl
    cpl
    cpl
    cpl
    jr nc, jr_007_535f

    jr nc, jr_007_5361

    and b
    ld sp, $3131
    ld [hl-], a
    cp $80
    db $f4
    inc sp
    inc [hl]
    inc sp
    scf
    jr c, @+$3a

    add hl, sp
    add hl, sp
    jr c, jr_007_537b

    add hl, sp
    ld a, [hl-]
    dec sp
    cp $80
    nop
    ld a, $fe
    add b
    nop
    inc a
    cp $3d
    dec a
    dec a
    ccf
    and c
    ld [$a03d], sp
    dec a
    ccf
    cp $80
    ld hl, sp+$44
    ld b, h
    add b

jr_007_535f:
    ld hl, sp+$45

jr_007_5361:
    ld b, a
    add b
    ld hl, sp+$44
    ld b, h
    add b
    ld a, [$4545]
    add b
    ld hl, sp+$44
    ld b, [hl]
    add b
    ld hl, sp+$45
    ld b, a
    add b
    ld hl, sp+$44
    add b
    ld a, [$8045]
    ld hl, sp+$44

jr_007_537b:
    ld b, h
    cp $80
    db $ec
    ld b, e
    cp $80
    ld hl, sp+$42
    ld b, d
    add b
    db $fd
    ld b, d
    ld b, d
    add b
    ld hl, sp+$42
    ld b, d
    add b
    rst $38
    ld b, d
    ld b, d
    add b
    ld hl, sp+$42
    ld b, d
    add b
    db $fd
    ld b, d
    ld b, d
    add b
    ld hl, sp+$42
    add b
    rst $38
    ld b, d
    add b
    ld hl, sp+$42
    ld b, d
    cp $80
    cp $40
    cp $41
    ld b, c
    ld b, c
    ld c, b
    ld b, c
    ld c, b
    ld b, c
    ld b, c
    cp $80
    db $fd
    ld d, d
    ld d, e
    ld d, d
    ld d, e
    ld d, [hl]
    ld d, a
    ld d, d
    ld d, e
    add b
    rst $38
    ld d, [hl]
    add b
    db $fd
    ld d, a
    ld d, d
    ld e, c
    cp $80
    db $fd
    ld d, b
    ld d, c
    ld d, b
    ld d, c
    ld d, h
    ld d, l
    ld d, b
    ld d, c
    add b
    rst $38
    ld d, h
    add b
    db $fd
    ld d, l
    ld d, b
    ld e, b
    cp $80
    db $fd
    ld c, e
    ld c, e
    add b
    ld [bc], a
    ld c, e
    add b
    db $fd
    ld c, e
    add b
    inc b
    ld c, h
    add b
    db $fd
    ld c, l
    cp $80
    db $fc
    ld c, c
    cp $4a
    ld c, d
    ld c, d
    ld c, [hl]
    ld c, d
    ld c, d
    ld c, d
    ld c, d
    ld c, a
    ld c, d
    ld c, [hl]
    cp $80
    di
    ld e, a
    ld h, b
    ld e, a
    add b
    xor $60
    ld e, a
    ld h, b
    ld e, a
    add b
    di
    ld h, b
    cp $80
    rst $38
    ld e, e
    ld e, e
    ld e, e
    ld e, h
    ld e, h
    ld e, h
    ld e, h
    ld e, e
    cp $80
    rst $38
    ld e, d
    ld e, d
    ld e, d
    add b
    ld a, [$5a5a]
    ld e, d
    ld e, d
    add b
    rst $38
    ld e, d
    cp $80
    ld [bc], a
    ld e, l
    cp $5e
    ld e, [hl]
    ld e, [hl]
    ld h, c
    ld e, [hl]
    ld e, [hl]
    ld e, [hl]
    ld e, [hl]
    ld e, [hl]
    ld h, c
    ld e, [hl]
    ld e, [hl]
    ld e, [hl]
    ld e, [hl]
    ld h, c
    ld h, c
    cp $80
    inc bc
    ld h, d
    rst $38
    add b
    daa
    ld h, d
    rst $38
    add b
    inc bc
    ld h, e
    rst $38
    add b
    nop
    ld bc, $64ff
    rst $38
    add b
    di
    ld e, a
    ld h, b
    ld e, a
    ld h, b
    ld l, c
    ld [hl], b
    cp $80
    rst $38
    ld h, l
    ld h, l
    ld h, l
    ld h, l
    ld h, l
    ld h, l
    ld h, l
    ld e, h
    ld e, h
    ld e, h
    ld e, h
    ld h, l
    ld h, l
    ld h, l
    ld h, l
    ld e, h
    ld e, h
    ld e, h
    ld e, h
    ld h, [hl]
    add b
    rst $38
    ld l, d
    ld l, d
    ld l, e
    ld l, e
    ld l, h
    add b
    db $fd
    ld l, e
    add b
    rst $38
    ld l, d
    add b
    db $fd
    ld l, e
    add b
    rst $38
    ld l, d
    ld l, d
    ld l, e
    ld l, e
    ld l, h
    add b
    db $fd
    ld l, e
    add b
    rst $38
    ld l, d
    ld l, d
    cp $80
    rst $38
    ld e, d
    ld e, d
    ld e, d
    ld e, d
    ld e, d
    ld e, d
    ld e, d
    add b
    ld a, [$5a5a]
    ld e, d
    ld e, d
    add b
    rst $38
    ld e, d
    ld e, d
    ld e, d
    ld e, d
    add b
    ld a, [$5a5a]
    ld e, d
    ld e, d
    add b
    rst $38
    ld h, a
    add b
    ld [bc], a
    ld e, d
    ld e, d
    add b
    rst $38
    ld e, d
    ld e, d
    add b
    ld hl, sp+$5a
    add b
    db $fd
    ld e, d
    add b
    rst $38
    ld l, [hl]
    add b
    ld [bc], a
    ld e, d
    ld e, d
    add b
    rst $38
    ld e, d
    ld e, d
    add b
    ld hl, sp+$5a
    add b
    db $fd
    ld e, d
    add b
    ld [bc], a
    ld e, d
    ld e, d
    cp $80
    ld bc, $fe5d
    and c
    rlca
    ld e, [hl]
    and b
    ld h, c
    and c
    rrca
    ld e, [hl]
    and b
    ld h, c
    and c
    rlca
    ld e, [hl]
    and b
    ld h, c
    and c
    ld b, $5e
    and b
    ld l, b
    and c
    rrca
    ld l, l
    and b
    ld l, a
    and c
    rrca
    ld l, l
    and b
    ld h, c
    cp $80
    ld hl, sp+$7a
    cp $80
    inc b
    db $76
    db $76
    ld [hl], a
    ld [hl], a
    ld a, b
    ld a, b
    ld a, c
    ld a, c
    cp $80
    inc b
    ld [hl], c
    ld [hl], c
    ld [hl], e
    ld [hl], e
    ld [hl], h
    ld [hl], h
    ld [hl], l
    ld [hl], l
    cp $80
    ld bc, $fe7b
    ld [hl], d
    cp $80
    rst $30
    ld a, l
    ld bc, $80ff
    inc bc
    inc bc
    dec bc
    inc d
    ld [de], a
    rst $38
    add b
    inc bc
    ld a, h
    rst $38
    add b
    db $fc
    dec b
    dec b
    dec b
    dec b
    ld [bc], a
    ld bc, $06ff
    ld b, $13
    rra
    rst $38
    add b
    inc b
    dec [hl]
    rst $38
    add b
    inc b
    ld [hl], $ff
    add b
    inc b
    ld a, [hl]
    rst $38
    add b
    nop
    ld bc, $1fff
    ld [bc], a
    ld [bc], a
    ld [bc], a
    rst $38
    add b
    nop
    ld bc, $ffff
    dec de
    ld d, d
    ld c, [hl]
    ld d, d
    ld d, h
    ld d, d
    ld e, a
    ld d, d
    add [hl]
    ld d, d
    and l
    ld d, d
    xor c
    ld d, d
    or l
    ld d, d
    cp c
    ld d, d
    cp l
    ld d, d
    cp a
    ld d, d
    db $eb
    ld d, d
    rst $28
    ld d, d
    ld a, [de]
    ld d, e
    ld e, $53
    jr nz, @+$55

    scf
    ld d, e
    ld b, a
    ld d, e
    ld c, e
    ld d, e
    ld c, a
    ld d, e
    ld e, d
    ld d, e
    ld a, l
    ld d, e
    add c

jr_007_5570:
    ld d, e
    and h
    ld d, e
    xor b
    ld d, e
    or c
    ld d, e
    call nz, $d753
    ld d, e
    add sp, $53
    db $ec
    ld d, e
    ld hl, sp+$53
    rlca
    ld d, h
    ld [de], a
    ld d, h
    ld hl, $2554
    ld d, h
    ld [hl], $54
    ld a, [hl-]
    ld d, h
    ld a, $54
    ld b, d
    ld d, h
    ld b, [hl]
    ld d, h
    ld c, b
    ld d, h
    ld d, c
    ld d, h
    add [hl]
    ld d, h
    ret z

    ld d, h
    call z, $eb54
    ld d, h
    rst $28
    ld d, h
    ld a, [$0554]
    ld d, l
    add hl, bc
    ld d, l
    dec bc
    ld d, l
    db $10
    ld d, l
    rla
    ld d, l
    dec de
    ld d, l
    inc h
    ld d, l
    add hl, hl
    ld d, l
    dec l
    ld d, l
    ld sp, $3555

jr_007_55b8:
    ld d, l
    add hl, sp
    ld d, l
    ld a, $55

jr_007_55bd:
    ld a, $55
    ld a, $55
    ld a, $55
    ld b, d
    ld d, l
    and b
    and a

jr_007_55c7:
    nop
    or b
    dec l
    rst $38
    and b
    add b
    inc a
    nop
    rst $38
    and b
    or b
    dec l
    and c
    rrca
    add e

jr_007_55d6:
    inc [hl]
    add d
    scf
    inc [hl]
    scf
    inc [hl]
    scf
    inc [hl]
    rst $38
    and b
    ret nc

    ld [bc], a
    ld d, b
    adc a
    jr jr_007_5570

    jr jr_007_55b8

    dec c
    ld d, b
    add l
    jr jr_007_55bd

    ld [bc], a
    ld d, b
    adc d
    jr @-$2e

    dec c

jr_007_55f3:
    ld d, b
    add l
    jr jr_007_55c7

    ld [bc], a
    ld d, b
    adc a
    jr @+$01

    and b
    and a
    db $10
    and c
    inc bc
    rrca
    inc b
    sbc [hl]
    inc c
    inc de
    inc c
    inc c
    ld de, $120c
    ld [de], a
    inc c
    inc c
    add hl, bc
    add hl, bc
    ld c, $0e
    rlca
    or b
    ld e, $0c
    inc de
    inc c
    inc c
    ld de, $120c
    ld [de], a
    inc c

jr_007_561e:
    add hl, bc
    ld c, $13
    inc c
    and c

jr_007_5623:
    inc bc
    inc c
    inc bc
    adc a
    ld de, $a111
    inc bc
    rrca
    inc bc

jr_007_562d:
    add b
    inc a
    inc c
    rst $38
    and b
    and c
    rrca
    and d
    nop
    adc d
    dec sp
    add l
    dec sp
    adc d

jr_007_563b:
    dec sp
    add l
    dec sp
    rst $38
    adc a

jr_007_5640:
    ld bc, $0103
    inc bc
    rst $38

jr_007_5645:
    and b
    ret nc

    jr jr_007_5699

    adc a

jr_007_564a:
    jr jr_007_55d6

    jr jr_007_561e

    inc hl

jr_007_564f:
    ld d, b
    add l
    jr jr_007_5623

    jr jr_007_56a5

    adc d
    jr @-$2e

    inc hl
    ld d, b
    add l
    jr jr_007_562d

    jr jr_007_56af

    adc a
    jr @+$01

    and b
    ret nc

    ld l, $50
    adc a
    jr jr_007_55f3

    jr jr_007_563b

    add hl, sp
    ld d, b

jr_007_566d:
    add l
    jr jr_007_5640

    ld l, $50
    adc d
    jr jr_007_5645

    add hl, sp
    ld d, b
    add l
    jr jr_007_564a

    ld l, $50
    adc d
    jr jr_007_564f

    add hl, sp
    ld d, b
    add l
    jr @+$01

    ret nc

    ld b, h
    ld d, b
    adc a
    add hl, de
    adc d
    add hl, de
    ret nc

    ld c, a
    ld d, b

jr_007_568e:
    add l
    add hl, de
    ret nc

    ld b, h
    ld d, b
    adc d
    add hl, de
    ret nc

    ld c, a
    ld d, b
    add l

jr_007_5699:
    add hl, de
    ret nc

    ld b, h
    ld d, b
    adc a
    add hl, de
    rst $38
    ret nc

    ld e, d
    ld d, b
    adc a
    ld a, [de]

jr_007_56a5:
    adc d
    ld a, [de]
    ret nc

    ld h, l
    ld d, b
    add l
    ld a, [de]
    ret nc

    ld e, d
    ld d, b

jr_007_56af:
    adc d
    ld a, [de]
    ret nc

    ld h, l
    ld d, b
    add l

jr_007_56b5:
    ld a, [de]
    ret nc

    ld e, d
    ld d, b
    adc a

jr_007_56ba:
    ld a, [de]
    rst $38
    ret nc

    ld b, h
    ld d, b

jr_007_56bf:
    adc a
    rla
    adc d
    rla

jr_007_56c3:
    ret nc

jr_007_56c4:
    ld c, a
    ld d, b
    add l
    rla
    ret nc

    ld b, h
    ld d, b
    adc d
    rla
    ret nc

    ld c, a
    ld d, b
    add l
    rla
    ret nc

    ld b, h
    ld d, b
    adc d

jr_007_56d6:
    rla
    ret nc

jr_007_56d8:
    ld c, a
    ld d, b
    add l

jr_007_56db:
    rla
    rst $38
    ret nc

    ld [hl], b
    ld d, b

jr_007_56e0:
    adc a
    jr jr_007_566d

    jr jr_007_56b5

jr_007_56e5:
    ld a, e
    ld d, b
    add l
    jr jr_007_56ba

    ld [hl], b
    ld d, b
    adc d
    jr jr_007_56bf

    ld a, e
    ld d, b
    add l
    jr jr_007_56c4

    ld [hl], b
    ld d, b
    adc d
    jr @-$79

    ret nc

    ld a, e
    ld d, b
    jr @+$01

    ret nc

    add [hl]
    ld d, b
    adc a
    jr jr_007_568e

    jr jr_007_56d6

    sub c
    ld d, b
    add l
    jr jr_007_56db

jr_007_570b:
    add [hl]
    ld d, b
    adc d
    jr jr_007_56e0

    sub c
    ld d, b
    add l
    jr jr_007_56e5

    add [hl]
    ld d, b
    adc a
    jr @+$01

    and b
    and c
    inc d
    and d
    ld bc, $0102
    and e

jr_007_5722:
    nop
    add e
    nop
    and [hl]
    inc hl
    inc c
    add c
    adc a
    rra
    ld hl, $249e
    rst $38
    add e
    daa
    sbc e
    jr z, jr_007_56c3

    daa
    jr z, jr_007_56bf

    ld h, $96
    inc h
    adc a
    inc h
    ld h, $24
    ld h, $24
    add d
    dec h
    ret nz

    adc l
    ld h, $c1
    adc b
    inc h
    add b
    jr nz, jr_007_576c

    add [hl]
    ld hl, $248a
    adc l
    rra
    sub [hl]
    inc h
    adc a
    jr z, jr_007_56d8

    inc l
    ret nz

    inc l
    adc e
    dec l
    pop bc
    adc a
    dec hl
    add hl, hl
    adc c
    jr z, @-$7e

    ld c, d
    ld h, $96
    dec hl
    add d
    inc l
    ret nz

    adc l
    dec l
    pop bc

jr_007_576c:
    sbc [hl]
    dec hl
    add d
    inc l
    ret nz

    sbc h
    dec l
    pop bc
    adc a
    dec hl
    dec l
    adc b
    dec hl
    sub [hl]

jr_007_577a:
    jr z, jr_007_570b

    inc h
    ld h, $24
    ld h, $24
    add d
    inc l
    ret nz

    adc l
    dec l
    pop bc
    adc b
    inc h
    sub [hl]
    inc h
    adc a
    ld h, $82
    ld h, $c0
    daa
    sub c
    jr z, @-$3d

    adc c
    dec hl
    adc a
    jr z, jr_007_57c4

    jr z, jr_007_5722

    inc h
    sub [hl]
    ld hl, $1f8f
    add b
    inc a
    inc h
    rst $38
    and b
    ret nc

    dec bc
    ld d, c
    adc [hl]
    ld h, $22
    dec e
    ld [hl+], a
    add b
    ld a, [hl+]
    ld [hl+], a
    add a
    dec e
    ld [hl+], a
    adc [hl]
    ld h, $22
    ld hl, $801f
    ld a, [hl+]
    dec e
    add a
    dec e
    ld hl, $248e
    dec e
    dec e

jr_007_57c2:
    add a
    dec e

jr_007_57c4:
    ld hl, $248e

jr_007_57c7:
    dec e
    dec e
    add a
    ld hl, $8e24
    add hl, hl
    daa
    rra
    ld hl, $e080
    ld [hl+], a
    rst $38
    sbc [hl]
    nop
    adc a
    inc bc
    add c
    nop
    rst $38
    and b
    ret nc

    ld [bc], a
    ld d, b
    add b
    inc a
    jr @+$01

    add b
    dec l
    ld bc, $038f
    rst $38
    ret nc

    ld [bc], a

jr_007_57ec:
    ld d, b
    adc a
    jr jr_007_577a

    jr jr_007_57c2

    dec c
    ld d, b
    add l
    jr jr_007_57c7

    jr @+$52

    adc d
    jr @-$2e

    inc hl
    ld d, b
    add l
    jr @-$2e

    jr jr_007_5853

    adc a
    jr @+$01

    ret nc

    ld b, h
    ld d, b
    adc d
    rla
    ret nc

    ld c, a
    ld d, b
    add l
    rla
    ret nc

    ld b, h
    ld d, b
    adc a
    rla
    rst $38
    and b
    and a
    db $10
    and c
    inc bc
    rrca
    inc bc
    sbc [hl]
    rlca

jr_007_581f:
    inc de
    ld c, $13
    inc c
    inc de
    inc c
    adc a

jr_007_5826:
    and c
    inc bc
    inc c
    inc bc
    inc c
    add hl, bc
    and c
    inc bc
    rrca
    inc bc
    sbc [hl]
    rlca
    inc de
    ld c, $13
    inc c
    rlca
    and c
    inc bc

jr_007_5839:
    inc c
    inc bc
    adc a
    inc c
    ld a, [bc]

jr_007_583e:
    add hl, bc
    rlca
    and c
    inc bc
    rrca

jr_007_5843:
    inc bc
    sbc [hl]
    ld de, $110c

jr_007_5848:
    ld de, $130c
    ld c, $0e
    add b
    inc a
    add hl, bc
    add hl, bc
    ld c, $a1

jr_007_5853:
    inc bc
    inc c
    inc bc
    adc a
    ld c, $0e
    inc de
    inc de
    rst $38
    ret nc

    sbc h
    ld d, b
    adc a
    jr jr_007_57ec

    jr @-$2e

    and a
    ld d, b
    add l

jr_007_5867:
    jr jr_007_5839

    sbc h
    ld d, b
    adc d
    jr jr_007_583e

    and a
    ld d, b
    add l
    jr jr_007_5843

    sbc h
    ld d, b
    adc d
    jr jr_007_5848

    and a
    ld d, b
    add l
    jr @+$01

    ret nc

    ld b, h
    ld d, b
    add b
    inc a
    rla
    rst $38
    add b
    inc a
    ret nc

    or d
    ld d, b
    jr jr_007_58a3

    ret nc

    ld e, d
    ld d, b
    ld a, [de]

jr_007_588f:
    adc a
    ret nc

    ld l, $50
    jr jr_007_581f

    jr jr_007_5867

    add hl, sp
    ld d, b
    add l

jr_007_589a:
    jr jr_007_5826

    ret nc

    ld b, h
    ld d, b
    rla
    add l
    ret nc

    ld c, a

jr_007_58a3:
    ld d, b
    rla
    ret nc

    ld b, h
    ld d, b
    adc a
    rla
    rst $38
    add b

jr_007_58ac:
    dec l
    inc bc
    adc a
    ld bc, $3c80
    inc bc
    add b
    dec [hl]
    inc bc
    add a

jr_007_58b7:
    inc b
    adc a
    ld bc, $0103
    inc bc
    rst $38
    and b
    or b
    rrca
    and c
    inc d

jr_007_58c3:
    and d
    ld bc, $0102
    and e
    nop
    add e
    nop
    and [hl]
    inc hl
    inc c
    add c
    adc b
    inc h
    adc a
    inc h
    add a
    inc hl
    adc a
    ld hl, $1f9e
    add b
    dec l
    ld h, $88
    ld h, $8f
    ld h, $87
    inc h
    adc a
    ld h, $82
    daa
    ret nz

    add b
    ld c, c
    jr z, jr_007_58ac

    adc b
    inc h
    adc a
    inc h
    adc b
    inc hl
    adc a
    ld hl, $1f9e
    add b
    dec l
    ld h, $8f
    ld h, $24
    ld h, $80
    ld c, e
    jr z, jr_007_588f

    jr z, jr_007_592b

    dec hl
    dec l
    sbc [hl]
    dec l
    adc b
    add hl, hl
    sub [hl]
    jr z, jr_007_589a

    ld h, $28
    add hl, hl
    dec hl
    dec hl
    dec hl
    adc b
    jr z, @-$7e

    inc a
    ld h, $87
    ld hl, $288f
    ld hl, $218a
    add l
    ld hl, $218f
    jr z, jr_007_5944

    ld hl, $8a21
    add hl, hl
    add l
    add hl, hl
    and c
    add hl, de

jr_007_592b:
    sbc [hl]
    add hl, hl
    and c
    inc d
    adc d
    jr z, jr_007_58b7

    jr z, jr_007_58c3

    ld h, $87
    inc h
    adc a
    inc hl
    add l
    inc hl
    and c
    add hl, de
    sub c
    ld hl, $69b0
    and b
    and c
    dec b

jr_007_5944:
    and d
    nop
    ld bc, $a301
    dec b
    add e
    nop
    and [hl]
    ld [hl+], a
    ld [$8a81], sp
    dec sp
    add l
    add hl, sp
    and c
    dec b

jr_007_5956:
    adc a
    dec sp
    adc d
    dec sp

jr_007_595a:
    add l
    add hl, sp
    adc d
    dec sp
    adc a
    add hl, sp
    sbc [hl]
    inc [hl]
    add l
    scf
    adc d
    ld [hl], $85
    dec [hl]
    adc a
    inc [hl]
    add hl, sp
    adc d
    add hl, sp
    add l
    scf
    adc d
    add hl, sp
    sub h
    scf
    adc a
    inc [hl]
    and b
    and c
    inc d
    and d
    ld bc, $0102
    and e
    ld bc, $0083
    and [hl]
    inc hl
    inc c
    add c
    jr z, jr_007_59af

    dec hl
    and c
    inc d
    adc b
    dec l
    adc c
    dec l
    and c
    inc d
    sbc h
    dec l
    adc a
    add hl, hl
    add l
    jr z, jr_007_5956

    add hl, hl
    jr z, jr_007_595a

    adc a
    ld h, $24
    add a
    inc hl
    add b
    ld d, e
    inc h
    adc a
    inc hl
    ld hl, $2387
    add b
    ld b, h
    inc h
    or b
    rrca
    rst $38
    and b
    and a
    db $10

jr_007_59af:
    and c
    inc bc
    rrca
    inc bc
    sbc [hl]
    inc c
    db $10
    add hl, bc
    db $10
    dec d
    db $10
    add hl, bc
    db $10
    dec d
    db $10
    or b
    inc a
    rst $38
    and b
    and a
    db $10
    and c
    inc bc
    rrca
    inc bc
    sbc [hl]
    ld c, $0e
    inc de
    inc de
    inc c
    dec d
    ld c, $13
    inc c
    and c
    inc bc
    inc c
    inc bc

jr_007_59d6:
    adc a
    ld de, $a111
    inc bc
    rrca
    inc bc
    add b
    inc a
    inc c
    rst $38
    and b
    or b
    ld a, [hl+]
    ret nc

    dec bc
    ld d, c
    add a
    ld h, $25
    rst $38
    ret nc

    ld e, d
    ld d, b
    adc a
    ld a, [de]
    adc d
    ld a, [de]
    ret nc

    ld h, l
    ld d, b
    add l
    ld a, [de]
    ret nc

    ld b, h
    ld d, b
    adc d
    rla
    ret nc

    ld c, a
    ld d, b
    add l
    rla
    ret nc

    ld b, h
    ld d, b
    adc d
    rla
    ret nc

    ld c, a
    ld d, b
    add l
    rla
    rst $38
    add b
    inc a
    ld bc, $a0ff
    or b
    dec l
    rst $38
    sbc h
    ld bc, $8701
    ld bc, $0300
    inc bc
    ld bc, $0300
    nop
    rst $38
    adc [hl]
    ld bc, $0103
    add a
    inc bc
    inc bc
    ld bc, $0300
    inc bc
    ld bc, $0300
    nop
    rst $38
    and b
    and a
    jr nz, jr_007_59d6

    inc bc
    rrca
    inc b
    sbc h
    ld d, $11
    ld d, $11
    ld d, $11
    ld de, $110c
    inc de
    inc d
    dec d
    ld de, $160c
    ld de, $1516
    inc de
    ld de, $1516
    inc de
    ld de, $a0ff
    or b
    ld c, $d0
    ld b, h
    ld d, b
    sbc h
    ld a, [de]
    ld a, [de]
    add a
    ld a, [de]
    ld a, [de]
    adc [hl]
    ld a, [de]
    ld a, [de]
    or b
    ld c, $d0
    ld b, h
    ld d, b
    sbc h
    ld a, [de]
    ld a, [de]
    ret nc

    jr jr_007_5abc

    jr jr_007_5a86

    ret nc

    jr jr_007_5ac1

    jr jr_007_5a8b

    add a
    jr jr_007_5a8e

    adc [hl]
    jr jr_007_5a91

    or b
    ld c, $d0
    jr jr_007_5ace

    sbc h
    jr jr_007_5a99

    ret nc

    ld b, h
    ld d, b
    ld a, [de]
    ld a, [de]

jr_007_5a86:
    ret nc

    ld b, h
    ld d, b
    ld a, [de]

jr_007_5a8a:
    ld a, [de]

jr_007_5a8b:
    add a
    ld a, [de]
    ld a, [de]

jr_007_5a8e:
    adc [hl]
    ld a, [de]
    ld a, [de]

jr_007_5a91:
    or b
    ld c, $d0
    ld b, h
    ld d, b
    sbc h
    ld a, [de]

jr_007_5a98:
    ld a, [de]

jr_007_5a99:
    ld a, [de]
    adc [hl]
    ld a, [de]
    rst $38
    ret nc

    cp l
    ld d, b
    add b
    ld b, b
    rla
    inc de
    rrca
    sub b
    db $10
    dec d
    add hl, de

jr_007_5aa9:
    ld e, $80
    jr nc, jr_007_5acc

    sub b
    ld e, $80
    jr nc, jr_007_5ace

    sub b
    ld d, $80
    ld h, b
    rla
    adc b
    db $10
    ret nz

    ld [de], a
    inc de

jr_007_5abc:
    rla
    add b
    jr nc, jr_007_5ad8

    pop bc

jr_007_5ac1:
    sub b
    rla
    add b
    jr nc, jr_007_5add

    sub b
    dec d
    add b
    ld h, b
    db $10
    adc b

jr_007_5acc:
    db $10
    ret nz

jr_007_5ace:
    inc de
    ld d, $1c
    add b
    jr z, @+$1c

    pop bc
    adc b
    add hl, de
    ret nz

jr_007_5ad8:
    jr @+$19

    add b
    jr z, jr_007_5af3

jr_007_5add:
    pop bc
    adc b
    dec d
    ret nz

    inc d
    inc de
    sub b
    ld [de], a
    pop bc
    dec d
    add b
    ld b, b
    db $10
    adc b
    db $10
    inc de
    ld d, $1a
    add b
    jr z, jr_007_5b0a

    adc b

jr_007_5af3:
    rla
    ld d, $15
    add b
    jr z, jr_007_5b0d

    adc b
    inc de
    ld [de], a
    ld de, $1090
    inc de
    add b
    ld h, b
    ld c, $80
    jr nz, jr_007_5b14

    add b
    ld b, b

jr_007_5b08:
    jr jr_007_5a8a

jr_007_5b0a:
    jr nz, jr_007_5b23

    rrca

jr_007_5b0d:
    add b
    ld b, b
    jr jr_007_5a91

    jr nz, jr_007_5b2a

    db $10

jr_007_5b14:
    add b
    ld b, b
    jr jr_007_5a98

    jr nz, jr_007_5b31

    adc b
    db $10
    ld [de], a
    db $10
    ld [de], a
    add b
    ld b, b
    dec de
    sbc b

jr_007_5b23:
    inc e
    ret nz

    add h
    ld a, [de]
    jr jr_007_5aa9

    ld h, b

jr_007_5b2a:
    rla

jr_007_5b2b:
    pop bc
    sbc b
    inc de
    add h
    ret nz

    ld [de], a

jr_007_5b31:
    ld de, $fe80
    db $10
    pop bc
    or b
    ld [bc], a
    rst $38
    and b
    and a
    db $10

jr_007_5b3c:
    and c
    inc bc
    inc c
    dec b
    sub b
    db $10
    rla
    or b
    db $10
    rla
    rst $38
    and b
    or b
    jr c, @+$01

    and b
    and c
    rrca
    sub b
    dec sp
    rst $38
    add b
    ld b, b

jr_007_5b53:
    ld bc, $a0ff
    rst $38
    sub b
    or b
    jr nz, jr_007_5b2b

    pop de
    ld d, b
    inc e
    inc e
    rst $38
    sub b
    or b
    jr nz, jr_007_5b08

    ld a, [hl-]
    ld a, $01
    inc hl
    inc hl
    rst $38
    ret nc

    db $dd
    ld d, b
    add a
    and c
    dec b
    inc de
    and c
    ld a, [bc]
    dec e
    and c
    dec b
    rra
    and c
    ld a, [bc]
    inc de
    and c
    dec b
    ld a, [de]
    and c
    ld a, [bc]
    rra
    and c
    dec b
    dec e
    and c
    ld a, [bc]
    ld a, [de]
    rst $38
    add a
    and c
    dec b
    ld a, [de]
    and c
    ld a, [bc]
    dec d
    and c
    dec b
    jr @-$5d

    ld a, [bc]
    ld a, [de]
    and c
    dec b
    ld d, $a1
    ld a, [bc]
    jr jr_007_5b3c

jr_007_5b9b:
    dec b
    dec d
    and c
    ld a, [bc]
    ld d, $ff
    add a
    and c
    dec b

jr_007_5ba4:
    ld d, $a1
    ld a, [bc]
    add hl, de
    and c
    dec b
    dec e
    and c
    ld a, [bc]
    ld d, $a1
    dec b
    jr jr_007_5b53

    ld a, [bc]
    dec e
    and c
    dec b
    add hl, de
    and c
    ld a, [bc]
    jr @+$01

    add a
    and c
    dec b
    dec d
    and c
    ld a, [bc]
    dec e
    and c
    dec b
    ld hl, $0aa1
    dec d
    and c
    dec b
    inc e
    and c
    ld a, [bc]
    ld hl, $05a1
    dec e
    and c
    ld a, [bc]
    inc e
    rst $38
    add a
    and c
    dec b
    ld a, [de]
    and c

jr_007_5bda:
    ld a, [bc]
    ld [hl+], a
    and c
    dec b
    ld h, $a1
    ld a, [bc]
    ld a, [de]
    and c
    dec b
    ld hl, $0aa1
    ld h, $a1
    dec b
    ld [hl+], a
    and c
    ld a, [bc]
    ld hl, $87ff
    and c
    dec b
    ld a, [de]
    and c
    ld a, [bc]
    dec d
    and c
    dec b
    jr jr_007_5b9b

    ld a, [bc]
    ld a, [de]
    and c
    dec b
    ld d, $a1
    ld a, [bc]
    jr jr_007_5ba4

    dec b
    dec d
    and c
    ld a, [bc]
    ld d, $ff
    and b
    or b
    ld c, $d0
    db $dd
    ld d, b

jr_007_5c0f:
    and c
    inc hl
    add a
    ld h, $27
    adc [hl]
    ld h, $87
    dec hl
    inc l
    adc [hl]
    dec hl
    add a
    dec l
    ld l, $8e
    dec l
    jr nc, @+$01

    or b
    ld c, $87
    ld h, $27
    adc [hl]
    ld h, $87
    dec l

jr_007_5c2b:
    ld l, $8e
    dec l
    add a
    ld h, $27
    sbc h
    ld h, $ff
    and b
    and c
    jr z, jr_007_5bda

    ld [bc], a
    inc bc
    ld bc, $02a3

jr_007_5c3d:
    inc bc
    nop
    and [hl]
    inc de
    inc c
    add c
    add h
    dec hl
    dec l
    ret nz

    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    dec hl
    dec l
    pop bc
    rst $38
    and b
    and c
    jr z, jr_007_5c0f

    ld [bc], a
    inc bc
    ld bc, $02a3
    inc bc
    nop
    and [hl]
    inc de
    inc c
    add c
    add b
    add b
    dec h
    rst $38
    or b
    ld c, $87
    ld h, $27
    adc [hl]
    ld h, $27
    add hl, hl
    dec hl
    dec l
    ld l, $ff
    or b
    ld c, $87
    ld l, $2d
    adc [hl]
    ld l, $87
    add hl, hl
    daa
    adc [hl]
    add hl, hl
    add a
    dec h
    inc h
    adc [hl]
    dec h
    add hl, hl
    rst $38
    or b
    ld c, $87
    jr z, @+$28

    adc [hl]
    jr z, jr_007_5c2b

    dec l
    dec hl
    adc [hl]
    dec l
    add a
    ld sp, $9c2f
    ld sp, $b0ff
    ld c, $87
    jr z, jr_007_5cd9

    adc [hl]
    jr z, jr_007_5c3d

    dec l
    dec hl
    adc [hl]
    dec l
    add a
    ld sp, $8e2f
    ld sp, $ff34
    or b
    ld c, $87
    ld [hl-], a
    ld sp, $328e
    add a
    ld l, $2d
    adc [hl]
    ld l, $87
    dec l
    dec hl
    add b
    ld a, [hl+]
    dec l
    add a
    ld [hl-], a
    ld sp, $328e
    add a

jr_007_5cd9:
    ld l, $2d
    adc [hl]
    ld h, $28
    add hl, hl
    dec l
    rst $38
    and b
    and c
    rrca
    and d
    nop
    add a
    dec sp
    rst $38
    sbc h
    ld bc, Entry
    ld bc, $a0ff
    and c
    inc bc
    inc de
    ld [bc], a
    and a
    db $10
    sbc h
    inc de
    ld c, $13
    ld c, $13
    ld c, $13
    ld c, $13
    ld c, $13
    ld c, $13
    ld c, $8e
    ld c, $0c
    ld a, [bc]
    add hl, bc
    sbc h
    ld a, [bc]
    ld de, $110a
    ld a, [bc]
    ld de, $110a
    add hl, bc
    db $10
    add hl, bc
    db $10
    add hl, bc
    db $10
    add hl, bc
    db $10
    ld a, [bc]
    ld de, $110a
    ld a, [bc]
    ld de, $110a
    add hl, bc
    db $10
    add hl, bc
    db $10
    add hl, bc
    db $10
    add hl, bc
    db $10
    ld c, $15
    ld c, $15
    ld c, $15
    adc [hl]
    ld c, $0e
    db $10
    ld de, $9cff
    ld bc, Entry
    adc [hl]
    ld bc, $ff01
    and b
    and c
    rrca
    sub b
    dec sp
    adc b
    dec sp
    rst $38
    add b
    jr nc, jr_007_5d4b

    ld [bc], a

jr_007_5d4b:
    rst $38
    and b
    and c
    inc bc
    rrca
    dec b
    and a
    db $10
    add b
    jr z, jr_007_5d69

    sbc b

jr_007_5d57:
    inc de
    adc b
    ld c, $98
    db $10
    rst $38
    and b
    or b
    rla
    and c
    inc d
    and d
    ld bc, $0102
    and e
    ld [bc], a
    inc bc

jr_007_5d69:
    nop
    and [hl]
    inc hl
    inc c
    add c
    add d
    ld l, $8d
    cpl
    add b
    ld sp, $882f
    ld [hl-], a
    add d
    ld l, $c0
    sub [hl]
    dec l
    pop bc
    adc a
    dec hl
    add b
    ld c, d
    dec hl
    sbc b
    dec l
    add a
    dec hl
    sub a
    dec l
    sub b

jr_007_5d89:
    dec hl
    add d
    dec l
    ret nz

jr_007_5d8d:
    sub a
    ld l, $c1
    dec hl
    sbc b
    dec hl
    adc b
    dec l
    add b
    inc sp
    dec hl
    adc a
    jr z, @-$77

    ld h, $91
    jr z, @-$66

    dec hl
    add d
    dec l
    ret nz

    ld l, $94
    cpl
    pop bc
    sub [hl]
    ld [hl-], a
    sbc d
    ld [hl-], a
    adc c
    inc [hl]
    adc [hl]
    ld [hl-], a
    add b
    xor c
    ld [hl-], a
    adc b
    ld [hl-], a
    sub b
    inc [hl]
    add b
    jr nz, jr_007_5deb

    sub b
    inc [hl]
    adc b
    ld [hl-], a
    sub b
    inc [hl]
    sbc b
    ld [hl-], a
    sub [hl]
    scf
    add d
    dec l
    adc b
    ld l, $90
    dec l
    add b
    ld d, b
    dec hl
    sub b
    inc [hl]
    adc b
    ld [hl-], a
    sub b
    inc [hl]
    sbc b
    ld [hl-], a
    jr nc, jr_007_5d57

    dec l
    add a
    ld l, $90
    dec l
    add b
    jr nz, jr_007_5e09

    sub b
    dec l
    sbc b
    dec hl
    adc b
    ld l, $90
    cpl
    adc b
    dec hl

jr_007_5de8:
    sub b
    ld l, $98

jr_007_5deb:
    cpl
    adc b
    ld l, $90
    dec l
    adc b
    dec hl
    sub b
    jr z, jr_007_5d8d

    ld h, $88
    jr z, jr_007_5d89

    ld h, $80
    ret z

    dec hl
    rst $38
    ret nc

    ret


    ld d, b
    sub b
    inc de
    adc b
    ld a, [de]
    ret nc

    ld [bc], a
    ld d, b
    sub b

jr_007_5e09:
    rra
    add b
    jr nz, jr_007_5e2c

    sbc b
    rra
    rst $38
    ret nc

    ret


    ld d, b
    sub b
    inc de
    adc b
    jr jr_007_5de8

    jr jr_007_5e6a

    sub b
    rra
    add b
    jr nz, jr_007_5e3e

    sbc b
    rra
    rst $38
    ret nc

    ret


    ld d, b
    sub b
    inc de
    adc b
    ld a, [de]
    ret nc

    ld l, $50

jr_007_5e2c:
    sub b
    dec e
    add b
    jr nz, @+$1f

    sbc b
    dec e
    rst $38
    ret nc

    ret


    ld d, b
    sub b
    inc de
    adc b
    ld d, $d0
    add [hl]
    ld d, b

jr_007_5e3e:
    sub b
    rra
    add b
    jr nz, jr_007_5e62

    sbc b
    rra
    rst $38
    add b
    jr nc, jr_007_5e4a

    add b

jr_007_5e4a:
    jr z, @+$04

    adc b
    ld bc, $a0ff
    and c
    rrca
    add [hl]
    add hl, sp
    dec sp
    add hl, sp
    add hl, sp
    dec sp
    add hl, sp
    rst $38
    sub d
    ld bc, $0102
    ld [bc], a
    rst $38
    and b
    and c

jr_007_5e62:
    inc bc
    ld [de], a
    dec b
    and a
    db $10
    adc h
    inc c
    add [hl]

jr_007_5e6a:
    inc c
    sub d
    db $10
    adc h
    inc de
    add [hl]
    inc de
    adc h
    dec d
    sub d
    inc c
    add [hl]
    inc c
    sub d
    db $10
    adc h
    inc de
    add [hl]
    inc de
    sub d
    dec d
    rst $38
    adc h

jr_007_5e81:
    inc c
    add [hl]
    inc c
    sub d
    db $10
    adc h
    inc de
    add [hl]
    inc c
    adc h
    dec bc
    sub d

jr_007_5e8d:
    ld a, [bc]

jr_007_5e8e:
    add [hl]
    ld a, [bc]
    sub d
    ld c, $8c
    ld de, $1186
    sub d
    inc de
    rst $38
    adc h
    inc c
    add [hl]
    inc c
    sub d
    db $10
    adc h
    inc de
    add [hl]

jr_007_5ea2:
    inc de
    adc h
    dec d
    sub d
    inc c
    add [hl]
    ld de, $128c
    sub d
    inc de
    add [hl]
    inc de
    sub d
    inc de
    rst $38
    sub d
    ld bc, $8602
    ld bc, $0100
    ld [bc], a
    inc bc

jr_007_5ebb:
    ld bc, $92ff
    ld bc, $8602
    ld bc, $0200
    ld bc, $0200
    sub d
    ld bc, $0102
    ld [bc], a
    rst $38
    ret nc

    db $dd
    ld d, b

jr_007_5ed0:
    and c
    inc hl
    adc h
    inc e
    add [hl]
    inc e
    adc h
    inc h
    add [hl]
    inc e
    adc h
    inc hl
    add [hl]
    inc h
    adc h
    inc e

jr_007_5ee0:
    add [hl]
    inc e
    rst $38
    adc h
    inc h
    add [hl]
    inc e
    adc h
    inc hl
    sub d
    inc h
    inc h
    add [hl]
    inc h
    rst $38
    ret nc

    db $dd
    ld d, b
    and c
    inc hl
    adc h
    rra
    add [hl]
    rra
    adc h
    jr z, jr_007_5e81

    rra
    adc h
    daa
    add [hl]
    jr z, jr_007_5e8d

    rra
    add [hl]
    rra
    rst $38
    adc h
    jr z, jr_007_5e8e

    rra
    adc h
    daa
    sub d
    jr z, @+$2a

    add [hl]
    jr z, @+$01

    adc h
    dec e
    add [hl]
    dec e
    adc h
    ld hl, $1d86
    adc h
    jr nz, jr_007_5ea2

    ld hl, $1d8c
    add [hl]
    dec e
    rst $38
    adc h
    ld hl, $1d86
    adc h

jr_007_5f27:
    jr nz, jr_007_5ebb

    ld hl, $8621
    ld hl, $8cff
    jr @-$78

    jr @-$72

    inc h
    add [hl]
    jr @-$72

    inc hl
    add [hl]
    inc h
    adc h
    jr @-$78

    jr @+$01

    adc h
    inc h
    add [hl]
    jr jr_007_5ed0

    inc hl
    sub d
    inc h
    inc h
    add [hl]
    inc h
    rst $38
    adc h
    inc h
    add [hl]
    inc e
    adc h
    rra
    sub d
    rra
    rra
    add [hl]
    rra
    rst $38
    adc h
    jr z, jr_007_5ee0

    rra
    adc h
    dec de
    sub d
    dec de
    dec de
    add [hl]
    dec de
    rst $38
    sbc [hl]
    and b
    and c
    inc bc
    dec c
    dec b
    and a
    db $10
    jr jr_007_5f80

    rst $38
    and b
    or b
    rrca
    adc a
    ret nc

    rst $20
    ld d, b
    jr jr_007_5f27

    rrca
    jr @+$01

jr_007_5f7a:
    ret nc

    nop
    ld d, b
    or b
    rrca
    ret nc

jr_007_5f80:
    di
    ld d, b
    adc a
    inc de
    or b
    rrca
    inc de
    rst $38
    and b
    and c
    rrca
    adc d
    add hl, sp
    add l
    add hl, sp
    rst $38
    adc a
    ld bc, $ff01
    ret nc

    db $dd
    ld d, b
    and c
    inc hl

jr_007_5f99:
    adc a
    inc h
    inc h
    sbc c
    rra
    rst $38
    adc a

Call_007_5fa0:
    inc h
    inc h
    add l
    inc h
    adc a
    rra
    rra
    rst $38
    add l
    nop
    nop
    ld bc, $0000
    ld bc, $d0ff
    cp l
    ld d, b
    and [hl]
    nop
    nop
    add c
    add h
    jr jr_007_5f7a

    rla
    dec d
    inc de
    pop bc
    ld a, [de]
    ret nz

    jr jr_007_5fd9

jr_007_5fc2:
    dec d
    inc e
    ld a, [de]
    jr jr_007_5fde

    dec e
    inc e
    ld a, [de]
    jr jr_007_5feb

    dec e
    inc e
    ld a, [de]
    pop bc
    inc hl
    ret nz

    ld hl, $1d1f
    adc b
    jr jr_007_5f99

    and b

jr_007_5fd9:
    add c
    jr @+$01

    and b
    or b

jr_007_5fde:
    ld h, b
    and c
    inc bc
    inc b
    inc b
    and a
    db $10
    sbc b
    inc c
    rst $38
    add b
    ld h, b
    nop

jr_007_5feb:
    adc b
    ld bc, $d0ff
    nop
    ld d, b
    or b
    rrca
    adc a
    ret nc

    sbc h
    ld d, b
    inc de
    or b
    rrca
    inc de
    rst $38
    adc a
    ret nc

    sbc h
    ld d, b
    inc de
    or b
    rrca
    ret nc

    jr jr_007_6056

    sbc [hl]
    ld de, $9eff
    jr @-$5d

    inc bc
    ld a, [de]
    dec b
    ld d, $ff
    adc a
    ld [bc], a
    ld bc, $0185
    nop
    ld [bc], a
    ld bc, $0000
    rst $38
    and b
    and c
    jr z, jr_007_5fc2

    nop
    ld bc, $a301
    ld bc, $0083
    and [hl]
    inc de
    inc c
    add c
    adc a
    daa
    daa
    adc d
    ld h, $85
    daa
    adc d
    ld h, $8f
    inc h
    inc h
    sbc [hl]
    rra
    add l
    ld e, $8f
    rra
    rra
    adc d
    rra
    adc a
    rra
    add b
    inc a
    inc hl
    add l
    rra
    adc a
    inc hl
    inc hl
    inc hl
    adc d
    rra
    adc a
    inc hl
    inc hl
    sbc [hl]
    inc hl
    add l
    rra
    adc a
    inc hl

jr_007_6056:
    inc hl
    adc d
    ld hl, $2185
    adc d
    inc hl
    add b
    inc a
    inc h
    add l
    inc h
    adc a

jr_007_6063:
    daa
    daa
    ld h, $8a
    ld h, $8f
    inc h
    add b
    dec l
    rra
    add l
    ld e, $8f
    rra
    rra
    adc d
    rra
    adc a
    rra
    add b
    inc a
    inc hl
    add l
    rra
    adc a
    inc hl
    inc hl
    inc hl
    adc d
    rra
    adc a
    inc hl
    inc hl
    sbc [hl]
    inc hl
    add l
    rra
    sbc c
    inc hl

jr_007_608a:
    add l
    inc hl
    adc d
    ld hl, $2185
    adc d
    inc hl
    add b
    inc hl
    inc h
    sbc [hl]
    ld [hl+], a
    rst $38
    ret nc

    nop
    ld d, b
    or b
    rrca
    ret nc

    ld b, h
    ld d, b
    adc a
    inc de
    or b
    rrca
    inc de
    rst $38
    ret nc

    nop
    ld d, b
    or b
    rrca
    ret nc

    add [hl]
    ld d, b
    adc a
    inc de
    or b
    rrca
    inc de
    rst $38
    ret nc

    nop
    ld d, b
    or b
    rrca
    ret nc

    rst $38
    ld d, b
    adc a
    ld de, $0fb0
    ld de, $8fff
    ld bc, $ff02
    sbc [hl]
    dec de
    jr jr_007_60db

    ld d, $ff
    add l
    ld bc, $0200
    ld bc, $0200
    rst $38
    adc a
    dec hl
    daa
    add b
    jr z, jr_007_6101

    adc a

jr_007_60db:
    daa
    daa
    add l
    ld h, $8f

Call_007_60e0:
    daa
    jr z, jr_007_6063

    ld d, l
    inc h
    adc a
    dec hl
    add l
    ld a, [hl+]
    adc a
    dec hl
    inc h
    sbc [hl]
    inc h
    adc a
    dec hl
    ld h, $8a
    ld h, $94
    dec hl
    add b
    ld c, e
    daa
    adc a
    dec hl
    dec hl
    dec hl
    dec hl
    daa
    add b
    dec l
    daa

jr_007_6101:
    adc d
    daa
    add l
    ld h, $8f
    daa
    daa
    jr z, jr_007_608a

    ld d, l
    inc h
    adc a
    dec hl
    add l
    ld a, [hl+]
    adc a
    dec hl
    inc h
    sbc [hl]
    inc h
    adc a
    dec hl
    ld h, $8a
    ld h, $94
    dec hl
    add b
    ld a, b
    daa
    rst $38
    and b
    and c
    inc bc
    rrca
    dec b
    and a
    db $10
    sbc b
    ld c, $09
    ld c, $09
    rst $38
    add [hl]
    ld bc, $0300
    inc bc
    ld bc, $0300
    inc bc
    rst $38
    db $10
    add hl, bc
    db $10
    add hl, bc
    rst $38
    ld de, $110c
    inc c
    rst $38
    add hl, bc
    inc b
    add hl, bc

jr_007_6144:
    inc b
    rst $38
    and b
    or b
    inc c
    ret nc

    sbc h
    ld d, b
    add [hl]
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    or b

jr_007_6154:
    inc c
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    rst $38
    and b
    or b
    inc c
    ret nc

jr_007_6160:
    ld [bc], a
    ld d, b
    add [hl]
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    rst $38
    and b
    or b
    inc c
    ret nc

    or d
    ld d, b
    add [hl]
    inc d
    inc d
    or b
    inc c
    inc d
    inc d
    or b
    inc c
    inc d

jr_007_6182:
    inc d
    or b
    inc c
    inc d
    inc d
    rst $38
    and b
    or b
    inc c
    ret nc

    ld e, d
    ld d, b

jr_007_618e:
    add [hl]
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    or b
    inc c
    dec d
    dec d
    rst $38
    and b
    and c
    jr z, jr_007_6144

    ld [bc], a
    inc bc
    ld bc, $02a3
    inc bc
    nop
    and [hl]
    inc de
    ld a, [bc]
    add c
    sbc [hl]
    add hl, hl
    add [hl]
    jr z, jr_007_61d8

    dec h
    sbc [hl]
    ld h, $86
    ld hl, $2826
    sbc [hl]
    add hl, hl
    add [hl]
    jr z, jr_007_61e4

    dec h
    sbc [hl]
    ld h, $86
    ld hl, $2928
    sbc [hl]
    dec hl
    add [hl]
    add hl, hl
    jr z, jr_007_61f1

    sbc [hl]
    jr z, jr_007_6154

    ld hl, $2928
    sbc [hl]
    dec hl

jr_007_61d3:
    add [hl]

jr_007_61d4:
    add hl, hl
    jr z, jr_007_61fd

    sbc [hl]

jr_007_61d8:
    jr z, jr_007_6160

    jr z, jr_007_6205

    dec hl
    sbc [hl]
    inc l
    add [hl]
    dec hl
    add hl, hl
    jr z, jr_007_6182

jr_007_61e4:
    add hl, hl
    add [hl]
    inc h
    add hl, hl
    dec hl
    sbc [hl]
    inc l
    add [hl]
    dec hl
    add hl, hl
    jr z, jr_007_618e

    add hl, hl

jr_007_61f1:
    add [hl]
    inc h
    dec hl
    inc l
    sbc [hl]
    dec l
    add [hl]
    inc l
    dec hl
    ld a, [hl+]
    sbc [hl]
    add hl, hl

jr_007_61fd:
    add [hl]
    jr z, jr_007_6227

    ld h, $9e
    dec h
    add [hl]
    inc h

jr_007_6205:
    inc hl
    ld [hl+], a
    sbc [hl]
    ld hl, $2186
    ld h, $28
    rst $38
    and b
    and c
    rrca
    add [hl]
    add hl, sp
    rst $38
    and b
    and c
    inc bc
    ld c, $04
    and a
    db $10
    sbc [hl]
    inc c
    add hl, bc
    ld c, $13
    inc c
    adc a
    ld de, $8011
    inc a
    and c

jr_007_6227:
    inc bc
    ld b, $04
    inc c
    rst $38
    and b
    or b
    ld a, [bc]
    and c
    jr z, jr_007_61d4

    ld [bc], a
    inc bc
    ld bc, $02a3
    inc bc
    nop
    and [hl]
    inc de
    inc c
    add c
    add d
    ld h, $c0
    daa
    adc h
    jr z, jr_007_6205

    add h
    dec hl
    adc a
    jr z, jr_007_6274

    jr z, jr_007_61d3

    inc h
    sub l
    ld hl, $1f8f
    add b
    inc a
    inc h
    rst $38
    and b
    and c
    inc bc
    jr jr_007_625d

    and a
    db $10
    add b
    add b

jr_007_625d:
    add hl, bc
    rst $38
    and b
    or b
    ld e, $a1
    rrca
    add e
    inc [hl]
    add d
    scf
    inc [hl]
    scf
    inc [hl]
    scf
    inc [hl]
    rst $38
    push bc
    ld d, l
    bit 2, l
    ret nc

    ld d, l

jr_007_6274:
    rst $18
    ld d, l
    db $fc
    ld d, l
    ld sp, $3f56
    ld d, [hl]
    ld b, l
    ld d, [hl]
    ld h, d
    ld d, [hl]
    add h
    ld d, [hl]
    and b
    ld d, [hl]
    cp h
    ld d, [hl]
    db $dd
    ld d, [hl]
    cp $56
    ld a, [de]
    ld d, a
    cpl
    ld d, a
    and h
    ld d, a
    push de
    ld d, a
    call c, $e457
    ld d, a
    ld [$1657], a
    ld e, b
    ld e, h
    ld e, b
    ld a, l
    ld e, b
    add h
    ld e, b
    xor e
    ld e, b
    cp [hl]
    ld e, b
    xor h
    ld e, c
    pop bc
    ld e, c
    pop hl
    ld e, c
    db $eb
    ld e, c
    inc c
    ld e, d
    db $10
    ld e, d
    inc d
    ld e, d
    ld hl, $315a
    ld e, d
    ld d, d
    ld e, d
    sbc l
    ld e, d
    add hl, sp
    ld e, e
    ld b, a
    ld e, e
    ld c, e
    ld e, e
    ld d, c
    ld e, e
    ld d, l
    ld e, e
    ld d, a
    ld e, e
    ld h, b
    ld e, e
    ld l, d
    ld e, e
    add a
    ld e, e
    and c
    ld e, e
    cp e
    ld e, e
    push de
    ld e, e
    rst $28
    ld e, e
    add hl, bc
    ld e, h
    ld [hl+], a
    ld e, h
    inc [hl]
    ld e, h
    ld l, c
    ld e, h
    ld a, h
    ld e, h
    adc c
    ld e, h
    sbc h
    ld e, h
    xor [hl]
    ld e, h
    pop bc
    ld e, h
    pop hl
    ld e, h
    jp hl


    ld e, h
    rst $28
    ld e, h
    scf
    ld e, l
    ccf
    ld e, l
    ld b, a
    ld e, l
    ld c, h
    ld e, l
    ld e, l
    ld e, l
    cp $5d
    db $10
    ld e, [hl]
    ld [hl+], a
    ld e, [hl]
    inc [hl]
    ld e, [hl]
    ld b, [hl]
    ld e, [hl]
    ld c, a
    ld e, [hl]
    ld e, d
    ld e, [hl]
    ld h, b
    ld e, [hl]
    add b
    ld e, [hl]
    sbc c
    ld e, [hl]
    or d
    ld e, [hl]
    cp l
    ld e, [hl]
    call $e35e
    ld e, [hl]
    rst $28
    ld e, [hl]
    dec b
    ld e, a
    ld de, $225f
    ld e, a
    ld l, $5f
    ccf
    ld e, a
    ld c, e
    ld e, a
    ld d, a
    ld e, a
    ld h, e
    ld e, a
    ld l, [hl]
    ld e, a
    ld a, d
    ld e, a
    adc b
    ld e, a
    sub b
    ld e, a
    sub h
    ld e, a
    sbc a
    ld e, a
    xor b
    ld e, a
    or b
    ld e, a
    call c, $e85f
    ld e, a
    xor $5f
    db $fc
    ld e, a
    add hl, bc
    ld h, b
    ld de, $1c60
    ld h, b
    sbc b
    ld h, b
    and [hl]
    ld h, b
    or h
    ld h, b
    jp nz, $c660

    ld h, b
    call z, $d460
    ld h, b
    jr nz, jr_007_63b3

    dec l
    ld h, c
    scf
    ld h, c
    inc a
    ld h, c
    ld b, c
    ld h, c
    ld b, [hl]
    ld h, c
    ld e, h
    ld h, c
    ld [hl], d
    ld h, c
    adc b
    ld h, c
    sbc [hl]
    ld h, c
    ld c, $62
    inc d
    ld h, d
    inc l
    ld h, d
    ld d, h
    ld h, d
    ld e, a
    ld h, d
    ld hl, $ff30
    ld c, $10

jr_007_6373:
    ld a, [de]
    ld [hl+], a
    inc de
    dec c
    jr nz, jr_007_6373

    ret

; Length of data in register a.
; [$c5cb] = data0[N+1]
; [$c5c7] = data1[N+1]
; [$c5c6] = data1[N]
; [$c5c5] = 0
; [$c5c4] = data0[N]
; [$c5c3] = ?
; [$c503] = read : return if bit 6 is set
; [$c504] = read :
; [$c506] = read : return if non-zero
; offset = mod64(a) * 2
Call_007_637a:
    ld hl, $c503
    bit 6, [hl]
    ret Z           ; Return if bit 6 in [$c503] is set.
    ld e, a
    ld a, [$c506]
    and a
    ret nZ          ; Return if [$c506] is non-zero.
    ld a, e
    and $3f         ; a = mod64(a).
    ld b, 0
    sla a           ; a = a * 2
    ld c, a         ; bc = a * 2
    ld hl, $67cf    ; Get some base address.
    add hl, bc      ; Add some length.
    ld a, [$c5c4]
    cp [hl]
    jr C, :+        ; Jump if [data_ptr] value exceeds [$c5c4]
    ret nZ          ; Return if [data_ptr] == [$c5c4]
    bit 6, e
    ret nZ          ; Return if bit 6 is non zero
  : ldi a, [hl]     ; Get data, data_ptr++
    ld [$c5c4], a   ; [$c5c4] = data0[N]
    ld a, [hl]
    ld [$c5cb], a   ; [$c5cb] = data0[N+1]
    ld hl, $67a3    ; Get some base address.
    add hl, bc      ; Add same length.
    ldi a, [hl]     ; Get data, data_ptr++
    ld [$c5c6], a   ; [$c5c6] = data1[N]
    ld a, [hl]
    ld [$c5c7], a   ; [$c5c7] = data1[N+1]
    ld a, e
    and $3f         ; Mod 64.
jr_007_63b3:
    ld [$c5c3], a   ; [$c5c3] = ?
    ld a, [$c504]
    and $1f         ; Mod 32.
    ld a, 0
    ld [$c5c5], a   ; [$c5c5] = 0
    ret

    ld a, $ff
    ld [$c5c3], a
    ld [EventSound], a      ; = $ff
    inc a
    ld [$c5c5], a
    ld [$c5cb], a
    ld [$c5c4], a
    ret

Call_007_63d4:
    ld a, [EventSound]
    bit 7, a
    call z, Call_007_637a
    ld a, $ff
    ld [EventSound], a               ; = $ff
    ld a, [$c5c3]
jr_007_63e4:
    cp $ff
    ret z
    ld a, [$c5c5]
    and a
    jr z, jr_007_63f2
    dec a
    ld [$c5c5], a
    ret

jr_007_63f2:
    ld a, [$c5c6]
    ld l, a
    ld a, [$c5c7]
    ld h, a

jr_007_63fa:
    ld a, [hl+]
    and a
    jr nz, jr_007_6408
    ld a, $ff
    ld [$c5c3], a
    xor a
    ld [$c5c4], a
    ret

jr_007_6408:
    bit 7, a
    jr z, jr_007_6435
    bit 5, a
    jr z, jr_007_643a
    and $1f
    jr z, jr_007_6421
    ld [$c5c8], a
    ld a, l
    ld [$c5c9], a
    ld a, h
    ld [$c5ca], a
    jr jr_007_63fa

jr_007_6421:
    ld a, [$c5c8]
    and a
    jr z, jr_007_63fa
    dec a
    ld [$c5c8], a
    ld a, [$c5c9]
    ld l, a
    ld a, [$c5ca]
    ld h, a
    jr jr_007_63fa

jr_007_6435:
    ld c, a
    ld a, [hl+]
    ld [c], a
    jr jr_007_63fa

jr_007_643a:
    ld a, [hl+]
    ld [$c5c5], a
    ld a, l
    ld [$c5c6], a
    ld a, h
    ld [$c5c7], a
    ret


    ld [de], a
    nop
    ld hl, $224a
    add b
    inc hl
    add b
    add b
    ld [bc], a
    ld [hl+], a
    ld [hl], b
    add b
    nop
    ld [hl+], a
    ld h, b
    add b
    nop
    ld [hl+], a
    ld d, b
    add b
    nop
    ld [hl+], a
    ld b, b
    add b
    nop
    ld [hl+], a
    jr nc, jr_007_63e4

    nop
    ld [hl+], a
    jr nz, @-$7e

    nop
    ld hl, $0000
    ld [de], a
    nop
    ld hl, $220a
    ld h, b
    inc hl
    add b
    add b
    inc bc
    ld [de], a
    and c
    ld hl, $10a1
    dec sp
    ld de, $2280
    jr nz, jr_007_64a4

    add b
    inc de
    ld b, $14
    add a
    add b
    inc b
    ld [de], a
    nop
    ld hl, $0000
    ld hl, $1200
    add b
    stop
    ld de, $1380
    ld b, $14
    add a
    add b
    ld [bc], a
    inc de
    ld hl, $0714
    add b
    ld bc, $3913
    inc d

jr_007_64a4:
    rlca
    add b
    ld bc, $4413
    inc d
    rlca
    add b
    nop
    inc de
    ld e, c
    inc d
    rlca
    add b
    nop
    inc de
    ld l, e
    inc d
    rlca
    add b
    nop
    inc de
    ld a, e
    inc d
    rlca
    add b
    nop
    inc de
    add e
    inc d
    rlca
    add b
    nop
    ld [de], a
    nop
    nop
    ld [de], a
    nop
    ld hl, $2281
    ld a, b
    inc hl
    add b
    add b
    inc bc
    ld hl, $0000
    ld [de], a
    jp $a121


    db $10
    ld b, l
    ld de, $2200
    ld b, b
    inc hl
    add b
    inc de
    ld d, $14
    add h
    add b
    ld bc, $22aa
    ld d, b
    inc de
    push hl
    inc d
    inc b
    add b
    ld bc, $4022
    inc de
    dec bc
    inc d
    ld b, $80
    ld bc, $12a0
    nop
    ld hl, $0000
    ld hl, $1000
    nop
    ld [de], a
    and h
    ld de, $1380
    add e
    inc d
    add a
    add b
    inc bc
    inc de
    ld e, c
    inc d
    rlca
    add b
    inc bc
    inc de
    ld b, h
    inc d
    rlca
    add b
    inc bc
    inc de
    ld e, c
    inc d
    rlca
    add b
    inc bc
    inc de
    ld b, h
    inc d
    rlca
    add b
    inc bc
    inc de
    ld b, $14
    rlca
    add b
    inc bc
    ld [de], a
    nop
    nop
    ld hl, $1000
    nop
    ld [de], a
    and h
    ld de, $1380
    add hl, sp
    inc d
    add a
    add b
    inc bc
    inc de
    ld e, c
    inc d
    rlca
    add b
    inc bc
    inc de
    add e
    inc d
    rlca
    add b
    inc bc
    inc de
    ld e, c
    inc d
    rlca
    add b
    inc bc
    inc de
    add e
    inc d
    rlca
    add b
    inc bc
    inc de
    sbc l
    inc d
    rlca
    add b
    inc bc
    ld [de], a
    nop
    nop
    ld hl, $1200
    and d
    db $10
    ld a, [hl+]
    ld de, $1380
    dec bc
    inc d
    add [hl]
    add b
    ld bc, $0011
    ld [de], a
    add d
    db $10
    rra
    inc de
    ld b, $14
    add a
    add b
    ld [$0012], sp
    nop
    ld hl, $1000
    ld b, l
    ld [de], a
    and l
    ld de, $1380
    dec bc
    inc d
    add [hl]
    add b
    ld [$0010], sp
    inc de
    ld b, $14
    add a
    add b
    nop
    inc de
    rst $30
    inc d
    ld b, $80
    nop
    inc de
    rst $20
    inc d
    ld b, $80
    ld bc, $d613
    inc d
    ld b, $80
    ld bc, $c413
    inc d
    ld b, $80
    ld bc, $b213
    inc d
    ld b, $80
    ld [bc], a
    inc de
    sbc [hl]
    inc d
    ld b, $80
    ld [bc], a
    inc de
    adc c
    inc d
    ld b, $80
    ld [bc], a
    inc de
    ld [hl], d
    inc d
    ld b, $80
    inc bc
    inc de
    ld e, e
    inc d
    ld b, $80
    inc bc
    inc de
    ld b, d
    inc d
    ld b, $80
    inc b
    inc de
    daa
    inc d
    ld b, $80
    dec b
    ld [de], a
    nop
    nop
    ld hl, $1200
    and d
    db $10
    ld a, [hl-]
    ld de, $1300
    ld h, e
    inc d
    add l
    add b
    ld [bc], a
    inc de
    ld d, $14
    add h
    add b
    nop
    db $10
    ld d, l
    inc de
    or d
    inc d
    add [hl]
    add b
    inc b
    ld [de], a
    nop
    nop
    ld hl, $1200
    xor b
    db $10
    ld a, [hl-]
    ld de, $1380
    ld h, e
    inc d
    add l
    add b
    ld [bc], a
    ld de, $1000
    inc [hl]
    inc de
    ld d, $14
    add h
    add b
    ld [$0012], sp
    nop
    ld hl, $1281
    and d
    db $10
    ld a, [hl-]
    ld de, $1380
    ld h, e
    inc d
    add l
    ld [hl+], a
    ld l, c
    inc hl
    add b
    add b
    inc b
    ld [de], a
    nop
    nop
    ld hl, $1200
    and b
    ld de, $1080
    ld a, [hl-]
    inc de
    ld h, e
    inc d
    add l
    add b
    ld [bc], a
    ld de, $1000
    inc [hl]
    inc de
    ld d, $14
    add h
    add b
    ld [$3c10], sp
    add b
    ld [$8712], sp
    stop
    ld de, $1380
    pop bc
    inc d
    add a
    xor d
    inc de
    pop hl
    inc d
    rlca
    add b
    nop
    inc de
    cp [hl]
    inc d
    rlca
    add b
    nop
    inc de
    or [hl]
    inc d
    rlca
    add b
    nop
    inc de
    xor h
    inc d
    rlca
    add b
    nop
    inc de
    and d
    inc d
    rlca
    add b
    ld bc, $12a0
    nop
    nop
    ld hl, $1200
    add c
    stop
    ld de, $1380
    ld e, c
    inc d
    add a
    add b
    inc bc
    inc de
    ld b, $14
    add a
    add b
    inc bc
    inc de
    ld e, c
    inc d
    add a
    add b
    inc bc
    inc de
    add e
    inc d
    add a
    add b
    inc bc
    ld [de], a
    nop
    nop
    ld hl, $1200
    add [hl]
    stop
    ld de, $1380
    ld e, c
    inc d
    add a
    add b
    inc bc
    inc de
    ld b, $14
    add a
    add b
    inc bc
    inc de
    ld e, c
    inc d
    add a
    add b
    inc bc
    inc de
    add e
    inc d
    add a
    add b
    inc bc
    xor b
    inc de
    ld e, c
    inc d
    rlca
    add b
    ld bc, $8313
    inc d
    rlca
    add b
    ld bc, $12a0
    nop
    nop
    ld [de], a
    nop
    ld hl, $22f4
    ld a, c
    inc hl
    add b
    add b
    ld bc, $22b0
    ld a, a
    add b
    ld bc, $6d22
    add b
    nop
    ld [hl+], a
    ld [hl], e
    add b
    ld bc, $21a0
    nop
    nop
    ld hl, $1000
    nop
    ld [de], a
    ld h, [hl]
    ld de, $1380
    ld e, c
    inc d
    add a
    xor b
    inc de
    ld e, c
    inc d
    rlca
    add b
    nop
    inc de
    ld b, h
    inc d
    rlca
    add b
    nop
    and b
    ld [de], a
    nop
    nop
    ld [de], a
    nop
    ld hl, $22a2
    ld [hl], c
    inc hl
    add b
    add b
    nop
    ld [hl+], a
    ld sp, $0080
    ld [hl+], a
    ld d, c
    add b
    nop
    ld [hl+], a
    ld [hl], c
    add b
    nop
    xor d
    ld [hl+], a
    ld de, $0180
    ld [hl+], a
    ld sp, $0180
    and b
    ld hl, $0000
    ld [de], a
    nop
    ld hl, $2260
    ld [hl], c
    inc hl
    add b
    add b
    inc bc
    ld [hl+], a
    ld h, c
    add b
    ld bc, $5122
    add b
    ld bc, $4122
    add b
    ld bc, $3122
    add b
    ld bc, $2122
    add b
    inc b
    ld [hl+], a
    ld sp, $0180
    ld [hl+], a
    ld b, c
    add b
    ld [bc], a
    ld [hl+], a
    ld d, c
    add b
    inc bc
    ld [hl+], a
    ld h, c
    add b
    inc b
    ld [hl+], a
    ld [hl], c
    add b
    ld [$0021], sp
    nop
    ld [de], a
    nop
    ld hl, $2291
    ld l, c
    inc hl
    add b
    add b
    ld bc, $4122
    add b
    ld b, $21
    nop
    nop
    ld hl, $1000
    nop
    ld [de], a
    and l
    ld de, $1340
    rlca
    inc d
    add c
    xor b
    inc de
    rlca
    inc d
    ld bc, $0080
    inc de
    sbc e
    inc d
    inc bc
    add b
    ld bc, $12a0
    nop
    nop
    ld hl, $1000
    nop
    ld [de], a
    add c
    ld de, $1380
    add e
    inc d
    add a
    add b
    ld [bc], a
    inc de
    pop bc
    inc d
    add a
    add b
    ld b, $12
    ld b, d
    inc de
    add e
    inc d
    add a
    add b
    ld bc, $c113
    inc d
    add a
    add b
    ld b, $12
    nop
    nop
    ld b, a
    ld h, h
    ld l, h
    ld h, h
    adc l
    ld h, h
    ret z

    ld h, h
    push de
    ld h, h
    cp $64
    dec l
    ld h, l
    ld e, h
    ld h, l
    ld a, c
    ld h, l
    call nc, $f365
    ld h, l
    ld c, $66
    inc hl
    ld h, [hl]
    ld l, h
    ld h, [hl]
    adc a
    ld h, [hl]
    ret nz

    ld h, [hl]
    db $db
    ld h, [hl]
    ld hl, sp+$66
    dec de
    ld h, a
    ld d, b
    ld h, a
    ld h, c
    ld h, a
    ld a, [hl]
    ld h, a
    rlca
    ld [$0907], sp
    inc b
    ld bc, $0801
    inc b
    add hl, bc
    ld b, $01
    ld b, $01
    ld [$0f01], sp
    ld bc, $0102
    ld [bc], a
    ld bc, $0903
    ld c, $01
    dec c
    ld bc, $010e
    ld [$0208], sp
    ld bc, $0802
    ld [bc], a
    ld [$0802], sp
    ld b, $01
    ld bc, $0001
    nop
    nop
    nop
    nop

TODOFunc6800::
    ld a, [$c17d]
    inc a
    ret nz

    ld a, [$c180]
    and $20
    ld c, a
    ld a, [JoyPadData]
    and BIT_LEFT
    xor c
    ret z

    ld a, $0f
    ld [$c17f], a
    xor a
    ld [$c17d], a
    ld [$c174], a
    ret

; $6681f : Increments pause timer. Every 16 calls, ColorToggle is toggled.
IncrementPauseTimer::
    ld a, [PauseTimer]
    inc a
    and %1111                 ; Mod 16.
    ld [PauseTimer], a
    ret nz
    ld a, [ColorToggle]
    inc a
    and %1
    ld [ColorToggle], a
    ret

; $66833: Sets up screen scrolls, number of lives, timer counter, and a few other things.
SetUpScreen::
    xor a
    ld [CurrentSong], a         ; = 0
    ldh [rSCX], a               ; = 0
    ldh [rSCY], a               ; = 0
    ldh [rWY], a                ; = 0
    dec a
    ld [NextLevel], a           ; = =$ff
    ld a, 7
    ldh [rWX], a
    ld a, $0c
    ld [$c502], a
    ld a, $c0
    ld [$c503], a
    ld a, 160
    ld [TimeCounter], a         ; = 160
    ld a, NUM_LIVES
    ld [CurrentLives], a
    ld a, NUM_CONTINUES_NORMAL
    ld [NumContinuesLeft], a
    ret

; $6685f: TODO
; Stores value from [$66871 + current level] into CurrentSong2
; Stores $4c into CurrentSong.
FadeOutSong::
    ld hl, $6871
    ld a, [CurrentLevel]
    add l
    ld l, a
    ld a, [hl]
    ld [CurrentSong2], a
    ld a, $4c
    ld [CurrentSong], a
    ret

    ld [$0100], sp
    inc bc
    inc b
    ld [bc], a
    nop
    ld b, $02
    inc bc
    dec b
    dec b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, b
    nop
    sub b
    ld h, b
    or b
    ld h, b
    add sp, $70
    cp b
    ld [hl], b
    ld hl, sp+$70
    cp b
    ld [hl], b
    ld hl, sp+$70
    adc b
    ld [hl], b
    ld hl, sp+$70
    add sp, $70
    cp b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_68b4:
    nop
    jr c, jr_007_68b7

jr_007_68b7:
    ld b, h
    jr c, jr_007_68b4

    ld a, h
    cp $7c
    nop
    nop
    inc a
    nop
    ld d, [hl]
    inc a
    ld c, [hl]
    inc a
    ld e, e
    ld a, $59
    ld a, $33
    rra
    inc h
    rra
    add hl, de
    rrca
    rra
    rrca
    inc c
    rlca
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
    ld bc, $0200
    ld bc, $00b7
    ld e, a
    or b
    rst $38
    db $e3
    and a

jr_007_68f0:
    pop bc
    dec de
    db $e4
    rla
    rst $28
    cpl
    rst $18
    dec l

jr_007_68f8:
    sbc $3e
    pop bc
    dec a
    sbc $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ld [$c4f0], sp
    jr c, jr_007_68f0

    jr jr_007_68f8

    call nc, Call_007_7cca
    ld a, [bc]
    db $fc
    ld a, [bc]
    db $f4
    ld b, d
    cp h
    add c
    ld a, [hl]
    ld bc, $80fe
    ld a, a
    inc bc
    nop
    rlca
    inc bc
    ld b, $01
    ld bc, $0000
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0102
    inc b
    inc bc
    ld [$0807], sp
    rlca
    db $10
    rrca
    db $10
    rrca
    and b
    rra
    ret c

    jr nc, jr_007_68f8

    ret nc

    ld l, b
    ldh a, [$c8]
    ld [hl], b
    sub b
    ld h, b
    sub b
    ld h, b
    jr nz, @-$3e

    jr nz, @-$3e

    jr nz, @-$3e

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
    add b
    nop
    ld b, b
    nop
    ldh [rLCDC], a
    ret nc

    ld h, b
    ld l, b
    jr nc, jr_007_699a

    jr jr_007_6982

    inc c
    add hl, de
    ld c, $0d
    ld b, $0f
    inc bc
    rrca
    ld b, $0e
    dec b
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

jr_007_6982:
    nop
    nop
    nop
    ld bc, $0300
    nop
    rlca
    nop
    rrca
    rlca
    adc a
    ld [bc], a
    sub [hl]
    add hl, bc
    ld l, a
    sbc a
    ld e, a
    cp a
    ld a, l
    cp [hl]
    ld a, a
    add b
    rla

jr_007_699a:
    add sp, $28
    rst $18
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ld [$84f0], sp
    ld a, b
    call nz, $c438
    cp b
    add h
    ld hl, sp-$7c
    ld hl, sp+$42
    cp h
    jp nz, $823c

    ld a, h
    and c
    ld e, [hl]
    ld b, c
    cp [hl]
    add b
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
    ld e, $00
    dec e
    ld c, $0b
    rlca
    dec b
    inc bc
    inc bc
    ld bc, $0102
    inc b
    inc bc
    ld [$0807], sp
    rlca
    ld de, $000e
    nop
    nop
    nop
    nop
    nop
    ld c, $00
    add hl, de
    ld c, $3e
    rra
    ld [hl], h
    ccf
    bit 7, [hl]
    daa
    cp $96
    db $fc
    sbc h
    ld hl, sp-$08
    ldh a, [rSVBK]
    ret nz

    ld b, b
    add b
    add b
    nop
    nop
    nop
    ld [hl], b
    nop
    sbc b
    ld [hl], b
    xor h
    ld a, b
    ld l, h
    jr c, jr_007_6a62

    jr c, jr_007_6a3a

    inc e
    ld [hl-], a
    inc e
    ld [hl-], a
    inc e
    ld sp, $781e
    ccf
    ld a, b
    rlca
    inc b
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $0001
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
    add c
    nop
    ld b, e
    add b
    scf
    jp $f10f


    dec bc
    db $f4
    rla

jr_007_6a3a:
    rst $28
    cpl
    rst $18
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, b
    nop
    add h
    ld a, b
    jp nz, $e23c

    inc e
    ld [c], a
    call c, Call_007_7cc2
    ld b, d
    db $fc
    and c
    sbc $e9
    sub [hl]
    nop
    nop
    nop
    nop
    nop

jr_007_6a62:
    nop
    nop
    nop
    inc bc
    nop
    dec b
    inc bc
    inc b
    inc bc
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
    ld bc, $0100
    nop
    sub $7c
    sub $7c
    jp nz, $827c

    ld a, h
    add d
    ld a, h
    add d
    db $fc
    ld [bc], a
    db $fc
    call nz, $4438
    jr c, @+$46

    jr c, @+$60

    jr nz, jr_007_6af5

    ld e, $f1
    ld c, $f8
    rlca
    ld hl, sp-$09
    ldh a, [$5f]
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld e, $00
    ld hl, $601e
    rra
    ld a, b
    rlca
    ld hl, sp+$37
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $f300
    ld bc, $73ec
    ld e, b
    ccf
    jr nz, jr_007_6b14

jr_007_6af5:
    db $10
    rrca
    sub b
    rrca
    and c
    ld e, $c2
    inc a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [hl], b
    nop
    ret z

    ld [hl], b
    db $f4
    ld hl, sp-$5c
    ld hl, sp+$54
    ld hl, sp+$38
    ldh a, [$30]

jr_007_6b14:
    ldh [rNR41], a
    ret nz

    ld b, b
    add b
    add b
    nop
    nop
    nop
    sbc a
    ld h, c
    sub a
    ld l, a
    ld l, a
    rra
    ld a, a
    rra
    ccf
    rra
    cpl
    rra
    inc de
    rrca
    daa
    rra
    cpl
    rra
    ccf
    rra
    ccf
    rra
    ccf
    rra
    ccf
    rra
    ccf
    rra

jr_007_6b39:
    cpl
    rra
    cpl
    rra
    ret nz

    rst $38
    ldh [rIE], a
    ldh [rIE], a
    ldh a, [rIE]
    ldh a, [rIE]

jr_007_6b47:
    db $f4
    ei
    ld [de], a
    db $fd
    ld [c], a
    db $fd
    ld sp, hl
    cp $fc
    rst $38
    db $fc
    rst $38
    cp $ff
    cp $ff
    cp $ff
    cp $ff
    cp $ff
    ld h, c
    sbc [hl]
    ld b, c
    cp [hl]
    ld b, c
    cp [hl]
    add c
    ld a, [hl]
    add d
    ld a, h
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$04
    ld hl, sp-$7c
    ld a, b
    adc b
    ld [hl], b
    ld c, b
    or b
    jr z, jr_007_6b47

    jr nc, jr_007_6b39

    db $10
    ldh [rAUD1SWEEP], a
    ldh [$bf], a
    ld e, b
    rst $18
    ccf
    ld e, a
    ccf
    ld c, a
    ccf
    ld h, e
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
    ld e, a
    ccf
    ld e, a

Jump_007_6b94:
    ccf
    ccf
    rra
    cpl
    rra
    cpl
    rra
    scf
    rrca
    ldh [rIE], a
    ld hl, sp-$01
    db $fc
    rst $38
    db $fd
    cp $c4
    rst $38
    ld hl, sp-$01
    db $fc
    rst $38

jr_007_6bab:
    cp $ff
    cp $ff
    cp $ff
    cp $ff
    db $fc
    rst $38
    db $fc
    rst $38
    db $fc
    rst $38
    db $fd
    cp $f9
    cp $60
    add b
    inc e
    ldh [$03], a
    db $fc
    nop
    rst $38
    add b
    ld a, a
    add b
    ld a, a
    ld b, b
    cp a
    ld b, b
    cp a
    ld b, b
    cp a
    ld h, c
    sbc [hl]
    ld d, d
    adc h
    ld c, h
    add b
    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    ld hl, $421e
    inc a
    add h
    ld a, b
    ld [$10f0], sp
    ldh [rNR41], a
    ret nz

    jr nz, jr_007_6bab

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
    cp [hl]
    ld e, a
    ld a, a
    nop
    ld e, a
    ccf
    ld e, a
    ccf
    ld e, a
    ccf
    daa
    rra

jr_007_6c09:
    ld e, e
    ccf

jr_007_6c0b:
    ld a, l
    ccf

jr_007_6c0d:
    cp [hl]
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    rst $38
    ld a, a
    add sp, $17
    ld a, b
    sub a
    ld a, b
    sub a
    ld a, b
    or a
    ld [hl], b
    rst $28
    ldh a, [$1f]
    ldh a, [rIE]
    db $f4
    ei
    ld h, h
    ei
    add d
    db $fd
    ei
    db $fc
    pop bc
    cp $fd
    cp $fd
    cp $fd
    cp $fd
    cp $80
    nop
    add b
    nop
    ld b, b
    add b
    ld b, b
    add b
    ld b, b
    add b
    jr nz, jr_007_6c09

    jr nz, jr_007_6c0b

    jr nz, jr_007_6c0d

    db $10
    ldh [rAUD1SWEEP], a
    ldh [$08], a
    ldh a, [rDIV]
    ld hl, sp-$7c
    ld a, b
    add e
    ld a, h
    ld b, c
    ld a, $42
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, $00
    dec c
    ld b, $1b
    ld c, $b5
    ld e, $cb
    cp [hl]
    ld [bc], a
    ld bc, $0305
    dec bc
    rlca
    rla
    rrca
    ld a, [de]
    rlca
    rla
    ld [$0f1e], sp
    ld e, $0f
    ld e, $07
    daa
    rra
    dec sp
    rra
    ld a, l
    ccf
    ld a, a
    ccf
    ld a, a
    ccf
    ld a, [hl]
    ccf
    ld a, a
    ccf

jr_007_6c9d:
    ret nz

    ccf
    or b
    rst $08
    or c
    adc $51
    xor [hl]
    pop af
    ld l, $f0
    cpl
    ldh a, [$2f]
    ret nz

    ccf
    ldh [$df], a
    ret nz

    ccf
    ret nz

    rst $38
    ret nz

    rst $38
    ret nz

    rst $38
    add b
    rst $38
    add c
    cp $41
    cp [hl]
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
    ld b, b
    add b
    ld b, b
    add b
    add b
    nop
    add b
    nop
    ld b, b
    add b
    jr nz, jr_007_6c9d

    rrca
    inc bc
    rla
    rrca
    cpl
    rra
    ld a, $01
    ld [bc], a
    ld bc, $0102
    inc bc
    ld bc, $0003

jr_007_6ced:
    ld [bc], a
    ld bc, $0102
    inc bc
    nop
    ld [bc], a
    ld bc, $0304
    ld [$1007], sp
    rrca
    jr nz, jr_007_6d1c

    cp b
    ld d, a
    add c
    cp $e3
    db $fc
    ldh [$3f], a
    ldh a, [$2f]
    ldh [$5f], a
    ldh [$9f], a
    ret nz

    ccf
    add b
    ld a, a
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld bc, $02fe
    db $fd
    rlca

jr_007_6d1c:
    ei
    add d
    ld a, h
    inc b
    ld hl, sp+$08
    ldh a, [$88]
    ld [hl], b
    ld d, b
    and b
    ld h, b
    add b
    ld h, b
    add b
    jr nz, jr_007_6ced

    jr nz, @-$3e

    db $10
    ldh [rAUD1SWEEP], a
    ldh [$08], a
    ldh a, [rDIV]
    ld hl, sp+$62
    db $fc
    pop hl
    cp $e9
    or $1f
    rrca
    rla
    rrca
    dec bc
    rlca
    dec b
    inc bc

jr_007_6d45:
    rlca
    nop

jr_007_6d47:
    inc b
    inc bc

jr_007_6d49:
    inc b
    inc bc
    ld [bc], a
    ld bc, $0001
    nop
    nop

jr_007_6d51:
    rrca
    nop
    jr jr_007_6d64

    ld a, $1f
    ccf
    nop
    nop
    nop
    nop
    nop
    db $fc
    rst $38
    db $fc
    rst $38
    ld sp, hl
    cp $e2

jr_007_6d64:
    db $fd
    inc e
    db $e3
    db $f4
    dec bc
    db $10
    rst $28
    ld de, $18ee
    rst $20
    sub h
    ld h, e
    push de
    inc hl
    ld a, [bc]
    pop af
    jp hl


    ldh a, [$f8]
    nop
    nop
    nop
    nop
    nop
    db $10
    ldh [rAUD1SWEEP], a
    ldh [rNR41], a
    ret nz

    jr nz, jr_007_6d45

    jr nz, jr_007_6d47

    jr nz, jr_007_6d49

    ld b, b
    add b
    ret nz

    nop
    ld b, b
    add b
    jr nc, jr_007_6d51

    adc b
    ldh a, [$f8]
    ldh a, [$28]
    ldh a, [$f0]
    nop
    nop
    nop
    nop
    nop
    dec de
    rlca
    dec e

jr_007_6da0:
    inc bc
    inc de
    inc c
    ld [$0807], sp
    rlca
    inc b
    inc bc
    inc b

jr_007_6daa:
    inc bc
    ld [bc], a
    ld bc, $0001
    nop
    nop
    rrca
    nop
    jr @+$11

    ld a, $1f
    ccf
    nop
    nop
    nop
    nop
    nop
    ld a, [$fcfd]
    ei
    ld l, b
    rst $30
    ldh a, [rIF]
    db $10
    rst $28
    jr z, jr_007_6da0

    jr nz, jr_007_6daa

    inc hl
    call c, $ef10
    sbc b
    ld h, a
    db $db
    daa
    dec c
    di
    ld [$f9f1], a
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
    ld b, b
    add b
    ld b, b
    add b
    ret nz

    nop
    ret nz

    nop
    add b
    nop
    ld h, b
    add b
    db $10
    ldh [$f0], a
    ldh [$50], a
    ldh [$e0], a
    nop
    nop
    nop
    nop
    nop
    cp a
    ld a, a
    ld a, a
    ccf
    ld e, a
    ccf
    cpl
    rra
    inc a
    inc bc
    inc hl
    inc e
    jr nz, jr_007_6e2a

    db $10
    rrca
    db $10
    rrca
    ld [$0407], sp
    inc bc
    ld [bc], a
    ld bc, $003f
    ld h, b
    ccf
    ei
    ld a, a
    rst $38
    nop
    db $fd
    cp $fd
    cp $f2
    db $fc
    ld [c], a
    db $fc
    ld sp, $c1ce
    ld a, $41

jr_007_6e2a:
    cp [hl]
    and c
    ld e, [hl]
    add e
    ld a, h
    adc a
    ld [hl], b
    ld b, d
    cp h
    ld h, c
    sbc [hl]
    ld l, h
    sbc a
    scf
    rst $08
    xor c
    rst $00
    rst $20
    nop
    ld hl, $181e
    rlca
    ld b, $01
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
    add b
    nop
    ld b, b
    add b
    ret nz

    add b
    ld b, b
    add b
    add b
    nop
    ld h, l
    cp $f2
    ld a, h
    or h
    ld a, b
    adc b
    ld [hl], b
    ld [hl], b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, a
    ccf

jr_007_6e7f:
    ld a, a
    ccf

jr_007_6e81:
    ld a, a
    ccf

jr_007_6e83:
    ld a, a
    ccf

jr_007_6e85:
    ccf
    rra

jr_007_6e87:
    cpl
    rra

jr_007_6e89:
    rla
    rrca

jr_007_6e8b:
    ld c, $01
    add hl, bc
    ld b, $08
    rlca
    ld [$0607], sp
    ld bc, $003f
    ld h, b
    ccf
    ei
    ld a, a
    rst $38
    nop
    ld b, c

jr_007_6e9e:
    cp [hl]
    jp nz, $c2bd

    cp l
    jp nz, $c6bd

    cp c
    and a
    jp c, $d6ad

    ld [hl], $dd
    xor $1d
    dec hl
    sbc $33
    rst $18
    inc a
    rst $08
    add hl, hl
    rst $00
    dec h
    jp $c1a2


    pop hl
    nop
    jr nz, jr_007_6e7f

    jr nz, jr_007_6e81

    jr nz, jr_007_6e83

    jr nz, jr_007_6e85

    jr nz, jr_007_6e87

    jr nz, jr_007_6e89

    jr nz, jr_007_6e8b

    ld b, b
    add b
    ld b, b
    add b
    add b
    nop
    ld b, b
    add b
    and b
    ret nz

    ld d, b
    ldh [$f0], a
    ldh [$d0], a
    ldh [$e0], a
    nop
    nop
    nop
    inc bc
    nop
    inc c
    inc bc
    ld d, $0f
    ld l, $1f
    scf
    rra
    scf
    rra
    add hl, sp
    rra
    cpl

jr_007_6eee:
    dec e
    dec hl
    inc e
    inc h
    jr jr_007_6f38

    jr c, jr_007_6e9e

    ld [hl], b
    ret z

    ld [hl], b
    ldh a, [$60]
    ld h, b
    nop
    ld b, b
    ccf
    add b
    ld a, a
    nop
    rst $38
    nop
    rst $38
    add b
    ld a, a
    add b
    ld a, a
    add b
    ld a, a
    rst $38
    nop
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
    ld bc, $0300
    ld bc, $0003
    rrca
    rst $30
    rra
    rst $28
    rra
    rst $28
    ccf
    rst $18
    ccf
    rst $18
    ld e, a
    cp a
    cp a
    ld a, a
    cp h
    ld a, a
    cp a
    ld b, b
    pop bc
    ld a, $41
    ld a, $31
    ld c, $fc
    inc bc
    add b

jr_007_6f38:
    rst $38
    xor $ff
    rst $38
    nop
    jp hl


    or $f1
    xor $f1
    xor $f1
    xor $c1
    cp $a1
    sbc $f1
    adc [hl]
    adc $30
    inc h
    jr @+$26

    jr jr_007_6f8e

    jr jr_007_6f88

    jr jr_007_6eee

    nop
    add b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0600
    ld bc, $0708
    ld d, $09
    inc e
    inc bc
    jr nz, jr_007_6f9a

    inc l
    inc de
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_6f88:
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_6f8e:
    nop
    ldh [rP1], a
    db $10
    ldh [rAUD1SWEEP], a
    ldh [$c8], a
    jr nc, jr_007_7000

    sub b
    inc b

jr_007_6f9a:
    ld hl, sp+$64
    sbc b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld bc, $0200
    ld bc, $0102
    ld c, $01
    inc de
    inc c
    jr nz, jr_007_6fde

    inc hl
    inc e
    inc hl
    ld e, $27
    rra

jr_007_6fc5:
    cpl
    rra
    cpl
    rra
    ld e, a
    cpl
    sbc a
    ld l, a
    sbc a
    ld l, a
    rra
    rst $28
    rla
    rst $28
    ld c, l
    or [hl]
    sbc h
    ld [hl], a
    cp e
    ld [hl], a
    cp a
    ld a, b
    rlca
    rst $38
    rlca

jr_007_6fde:
    ld hl, sp-$7c
    ld a, e
    call nz, $e8fb
    rst $30
    add sp, -$09
    ld hl, sp-$09
    ld hl, sp-$09
    ld hl, sp-$09
    add sp, -$09
    db $ec
    rst $30
    db $f4
    rst $28
    ld e, [hl]
    db $ed
    ld l, l
    sbc $bf
    sbc $df
    ld a, $87
    cp $00
    nop
    add b

jr_007_7000:
    nop
    ld b, b
    add b
    jr nz, jr_007_6fc5

    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$7c
    add b
    add [hl]
    ld a, b
    dec [hl]
    ld c, $4b
    ld a, $aa
    ld a, a
    call nc, $d17f
    ld a, a
    and a
    ld a, a
    ld l, [hl]
    ccf
    ld e, l
    ccf
    dec a
    rra
    cpl
    rra
    ld e, $0f
    ld de, $0f0e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $38
    rst $38
    ld a, a
    rst $38
    rst $38
    ld a, a
    sbc a
    ld h, e
    and a
    ld e, e
    ld a, e
    or a
    cpl
    rst $30
    rst $30
    rst $28
    rst $10
    rst $28
    rst $18
    rst $28
    xor a
    rst $18
    rst $08
    ccf
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, [$fefd]
    db $fd
    cp $fd
    cp $fd
    rst $38
    db $fd
    rst $38
    pop af
    rst $38
    db $ed
    or $ef
    ei
    rst $30
    rst $38
    ei
    db $fd
    ei
    ld a, [c]
    db $fd
    rst $38
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [$aafc], a
    db $fc
    cp c
    cp $ab
    cp $8b
    cp $2b
    cp $81
    cp $3d
    cp $dd
    cp $fd
    cp $da
    db $fc
    ld h, d
    sbc h
    call c, LoadRomBank
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_70af:
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0102
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
    ld bc, $0200
    ld bc, $0306
    dec bc
    rlca
    ld d, $0f
    sbc c
    rrca
    ld [hl], l
    adc d
    rst $18
    db $fc
    ld a, [hl]
    db $fc
    nop
    nop
    nop
    nop
    nop
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
    jr nz, jr_007_70af

    ret nc

    ldh [$30], a
    ret nz

    and b
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
    ld b, $00
    add hl, bc
    ld b, $17
    ld c, $17
    ld c, $21
    ld e, $36
    inc e
    ld c, [hl]
    inc a

jr_007_711b:
    ld d, [hl]
    inc l
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca
    nop
    jr jr_007_713e

    ld hl, $401f
    ccf
    add c
    ld a, [hl]
    nop

jr_007_713e:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_7151:
    nop
    nop
    add b
    nop
    ld b, b
    add b
    and b
    ret nz

    jr nz, jr_007_711b

    and b
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
    ld bc, $0200
    ld bc, $0102
    ld h, a
    inc bc
    ld a, h
    daa
    ld a, $17
    ld [hl], $1f
    dec sp
    ld e, $37
    ld e, $25
    ld e, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, b
    nop
    sub b
    ld h, b
    ret nc

    ldh [$e0], a
    ret nz

    jr nz, jr_007_7151

    ret nz

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
    ld bc, $0100
    nop
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
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_71b7:
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, [$9cdc]
    ld hl, sp+$7c
    cp b
    inc [hl]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp-$7e
    ld a, h
    ld b, d
    inc a
    ld b, c
    ld a, $21
    ld e, $20
    rra
    db $10
    rrca
    db $10
    rrca
    ld [$0807], sp
    rlca
    inc b
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
    jr nz, jr_007_71b7

    db $10
    ldh [rAUD1SWEEP], a
    ldh [$08], a
    ldh a, [$62]
    inc a
    ld [hl], h
    jr c, @-$0a

    jr c, @+$76

    cp b
    call nz, $f4f8
    ld hl, sp-$2c
    ld hl, sp+$73
    call c, Call_007_7f80
    ld b, b
    ccf
    jr nz, jr_007_7232

    db $10
    rrca
    ld c, $01
    ld de, $200e
    rra
    jr nz, @+$21

    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_7224:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rst $28
    nop
    inc e
    db $e3
    inc bc
    db $fc
    nop

jr_007_7232:
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ret nz

    ccf
    ldh a, [rVBK]
    nop
    nop
    nop
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
    jr c, @-$3e

    ld b, $f8
    ld bc, $c0fe
    ccf
    jr nc, jr_007_7224

    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld bc, $00fe
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc c
    inc bc
    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    db $10
    rrca
    ld [$0807], sp
    rlca
    inc b

jr_007_727c:
    inc bc
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc b
    inc bc
    ld [$1007], sp
    rrca
    sub b
    rrca
    ld h, b
    sbc a

jr_007_728f:
    nop
    rst $38

jr_007_7291:
    ld [hl+], a
    db $dd
    ld [hl], d
    xor l
    inc bc
    db $fc
    ld l, l
    sub d
    db $e3
    inc a
    xor c
    ld e, a
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    nop
    inc a
    ret nz

    inc bc
    db $fc
    nop
    rst $38
    jr nc, jr_007_727c

    nop
    rst $38
    inc c
    di
    ld [bc], a
    db $fd
    ld bc, $00fe
    rst $38
    nop
    rst $38
    add b
    ld a, a
    ld b, b
    cp a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_72c7:
    nop
    nop
    add b
    nop
    ld b, b
    add b
    jr nz, jr_007_728f

    jr nz, jr_007_7291

    db $10
    ldh [rAUD1SWEEP], a
    ldh [$88], a
    ld [hl], b
    adc b
    ld [hl], b
    ld c, b
    or b
    ld b, h
    cp b
    ld bc, $0600
    ld bc, $0708
    db $10
    rrca
    jr nz, @+$21

    jr nz, @+$21

    jr nz, jr_007_730a

    jr jr_007_72f4

    inc b
    inc bc
    ld [bc], a
    ld bc, $0001
    nop

jr_007_72f4:
    nop
    ld bc, $0100
    nop
    nop
    nop

jr_007_72fb:
    nop
    nop
    rlca
    ld hl, sp+$09
    ldh a, [rAUD1LEN]
    ldh [rNR42], a
    ret nz

    jr nz, jr_007_72c7

    ld hl, $1ac0

jr_007_730a:
    pop hl
    ld b, $f9
    rrca
    or $1f
    ld [c], a
    ld l, b
    sbc a
    cp e
    ld a, l
    ld a, l
    ei
    ld a, [$fb07]
    ld a, h

jr_007_731b:
    ld a, l
    inc bc

jr_007_731d:
    ret c

    and b
    rst $20
    ld hl, sp-$73
    cp $e3
    ld e, $f1
    ld c, $1e
    ldh [$08], a
    ldh a, [rDIV]
    ld hl, sp+$22
    call c, $fe21
    ld hl, $20fe
    rst $18
    nop
    rst $38
    add b
    ld a, a
    ld [$e8f7], sp
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
    nop
    nop
    nop
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
    jr nz, jr_007_731b

    jr nz, jr_007_731d

    inc bc
    nop
    inc b
    inc bc
    dec bc
    rlca
    ld de, $2c0e
    ld e, $32
    inc e
    ld c, [hl]
    inc a
    ld b, a
    ld a, $5f
    jr nz, jr_007_73b8

    jr nc, jr_007_72fb

    ld [hl], b
    adc d
    ld [hl], c
    adc h
    ld [hl], e
    adc a
    ld [hl], b
    add a
    ld a, b
    add e
    ld a, a
    ret nz

    nop
    and b
    ret nz

    ld h, b
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
    ld a, b
    nop
    add l
    ld a, b
    ld [bc], a
    db $fd
    nop
    rst $38
    nop
    rst $38
    sub b
    ld l, a
    sbc b
    ld [hl], a
    sbc b
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ld c, $f0
    ld bc, $00fe
    rst $38
    nop

jr_007_73b8:
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld [hl+], a
    inc e
    ld hl, $211e
    ld e, $a1
    ld e, $61
    sbc [hl]
    ld hl, $01de
    cp $01
    cp $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0200
    ld bc, $0304
    inc b
    inc bc
    inc b
    inc bc
    inc b
    inc bc
    ld [bc], a
    ld bc, $0102
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc b
    inc bc
    ld [$3007], sp
    rrca
    ret nz

    ccf
    nop
    rst $38
    nop
    rst $38
    ld [$1df7], sp
    ld [$ff00], a
    db $10
    rst $28
    inc hl
    rst $18
    inc b
    inc bc
    inc b
    inc bc
    ld e, $01
    pop hl
    ld e, $00
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    ld bc, $02fe
    db $fd
    nop
    rst $38
    nop
    rst $38
    add h
    ld a, e
    add b
    ld a, a
    inc b
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$08
    ldh a, [rAUD1SWEEP]
    ldh [rNR41], a
    ret nz

    ld b, b
    add b
    or b
    ld b, b
    ld [$04f0], sp
    ld hl, sp+$04
    ld hl, sp+$02
    db $fc
    ld [bc], a
    db $fc
    ld bc, $01fe
    cp $20
    rra
    db $10
    rrca
    db $10
    rrca
    add hl, bc
    ld b, $07
    nop
    inc bc
    nop
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
    rrca
    nop
    jr nc, jr_007_748c

    ld c, $f1
    call $ca32
    ld [hl], l
    ld d, a
    ld a, [$fabd]
    cp a
    ld a, l
    ld a, a
    cp l
    cp a

jr_007_748c:
    ld a, l
    ld e, a
    cp l
    ccf
    call $708f
    add d
    ld a, h
    ld b, d
    inc a
    ld b, d
    inc a
    pop hl
    ld e, $11
    xor $02
    db $fd
    db $fc
    inc bc
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38
    nop
    rst $38

jr_007_74a9:
    add b
    ld a, a

jr_007_74ab:
    add b
    ld a, a
    add h
    ld a, e
    db $e4
    ei
    db $fc
    ei
    add d
    ld a, l
    ld a, [hl]
    ld bc, $1c23
    ld [hl+], a
    inc e
    inc e
    nop
    ld [$08f0], sp
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$28]
    ret nc

    jr jr_007_74a9

    jr jr_007_74ab

    ld [$08f0], sp
    ldh a, [$08]
    ldh a, [$08]
    ldh a, [$38]
    ret nz

    ld c, b
    or b
    ld c, b
    or b
    ld [$c4f0], sp
    jr c, jr_007_74de

jr_007_74de:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_74e8:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc c
    inc bc
    rra
    rrca
    rra
    nop
    dec b
    ld [bc], a
    inc bc
    nop
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
    rlca
    nop
    jr c, jr_007_751c

    ret nz

    ccf
    jr nc, jr_007_74e8

    pop af
    cp [hl]
    rst $38

jr_007_751c:
    nop
    rst $18
    db $fd
    cp $9d
    cp l
    ld e, [hl]
    db $fd
    ld a, $af
    ld e, [hl]
    sub l
    ld l, [hl]
    ld c, a
    jr nc, jr_007_756e

    dec a
    inc h
    dec de
    jr z, jr_007_7548

    pop af
    ld c, $e1
    sbc $c1
    ld a, $eb
    ld a, [hl]
    rst $38
    xor d
    xor d
    nop
    and b
    ld e, a
    or e
    ld c, h
    adc h
    ld [hl], e
    sub b
    ld l, a
    and b
    ld e, a
    ret nz

jr_007_7548:
    ccf
    rlca
    ld hl, sp+$39
    add $51
    adc [hl]
    sub c
    ld c, $10
    rrca
    rrca
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc [hl]
    ret z

    inc h
    ret c

    inc d
    add sp, $1c
    ldh [$3c], a
    ret nz

    ret z

    jr nc, jr_007_7572

    ldh a, [rNR14]
    add sp, $24

jr_007_756e:
    ret c

    inc b
    ld hl, sp-$7c

jr_007_7572:
    ld a, b
    ld c, b
    inc [hl]
    ld [hl-], a
    inc c
    db $fd
    ld a, $ef
    ld a, [hl]
    rst $38
    nop
    dec bc
    rlca
    add hl, bc
    rlca
    rrca
    rlca
    rla
    rrca
    rla
    rrca
    ld [hl], a
    rrca
    sub a
    ld l, a
    sub a
    ld l, a
    adc a
    ld [hl], a
    sbc e
    ld h, a
    add l
    ld a, e
    add a
    ld a, c
    ld b, h
    add hl, sp
    inc hl
    inc e
    ld [hl+], a
    inc e
    ld [de], a
    inc c
    db $f4
    ei
    add d
    db $fd

jr_007_75a1:
    ld a, [c]
    db $fd
    db $fd
    cp $ff
    cp $fe
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, a
    rst $38
    cp a
    ld a, a
    ld h, c
    ld e, $20
    ret nz

    jr jr_007_75a1

    rlca
    ld hl, sp+$00
    rst $38
    nop
    rst $38
    add b
    ld a, a
    add b
    ld a, a
    ld b, c
    cp [hl]
    add $b8
    cp b
    ret nz

    adc b
    ldh a, [$88]
    ldh a, [$90]
    ldh [$90], a
    ldh [rAUD1SWEEP], a
    ldh [rAUD1SWEEP], a
    ldh [rP1], a
    nop
    nop
    nop
    cp $00
    ld bc, $01fe
    cp $0d
    cp $7f
    sub d
    cp a
    ld [de], a
    cpl
    ld [de], a
    scf
    ld [bc], a
    rrca
    ld [bc], a
    dec de
    ld c, $1d
    ld c, $0e
    inc b
    inc e
    ld [$0008], sp
    add e
    ld a, h
    add b
    ld a, a
    add a
    ld a, c
    add e
    ld a, l
    adc a
    ld [hl], a
    adc [hl]
    ld [hl], a
    sub a
    ld l, [hl]
    sub b
    ld l, a
    ld l, a
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
    ld bc, $ff80
    ld [hl], b
    rst $38
    ld hl, sp-$09
    add sp, -$09
    ld l, h
    rst $30
    or $6f
    cpl
    rst $18
    add $bf

jr_007_762d:
    sbc a
    ld a, a

jr_007_762f:
    cp a
    ld a, a

jr_007_7631:
    rst $38
    ld a, a

jr_007_7633:
    rst $38
    ld a, a

jr_007_7635:
    cp a
    ld a, a

jr_007_7637:
    rst $18
    ccf

jr_007_7639:
    ld l, a
    sbc a

jr_007_763b:
    add hl, sp
    rst $00
    nop
    rst $38
    nop
    rst $38
    ld b, $f9
    ld bc, $00fe
    rst $38
    nop
    rst $38
    add b
    rst $38
    nop
    rst $38
    add b
    rst $38
    ld hl, sp-$01
    cp $ff
    cp $ff
    cp $ff
    cp $ff
    cp $ff
    cp $ff
    ld bc, $01fe
    cp $01
    cp $81
    ld a, [hl]
    ld h, c
    sbc [hl]
    ld e, c
    add [hl]
    ld h, $c0
    jr nz, jr_007_762d

    jr nz, jr_007_762f

    jr nz, jr_007_7631

    jr nz, jr_007_7633

    jr nz, jr_007_7635

    jr nz, jr_007_7637

    jr nz, jr_007_7639

    jr nz, jr_007_763b

    db $10
    ldh [rSB], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    ld bc, $0100
    nop
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0102
    ld [bc], a
    ld bc, $0102
    db $76
    cp c
    ei
    inc l
    rst $38
    ld c, h
    rst $28
    ld e, h
    ld a, a
    adc h
    cpl
    call c, $ec1f
    rra
    db $ec
    rlca
    db $fc
    ld c, $f0
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$40
    cp a
    ret nz

    cp a
    nop
    rst $38
    and b
    ld e, a
    ret nc

    cpl
    ret nc

    cpl
    ld l, b
    rst $18
    call c, Call_007_7c3f
    rst $38
    cp [hl]
    ld a, l
    ld l, [hl]
    dec e
    ld e, [hl]
    ld hl, $3d42
    ld b, e
    inc a
    ld b, l
    jr c, jr_007_7715

    nop
    ld bc, $01fe
    cp $09
    or $05
    ld a, [$fa05]
    ld bc, $01fe
    cp $02
    db $fc
    ld [bc], a
    db $fc
    ld [bc], a
    db $fc
    inc b
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp+$0a
    db $f4
    ld a, [bc]
    db $f4
    ld b, $f8
    inc bc
    nop
    inc e

jr_007_7700:
    inc bc
    ccf
    rra
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
    nop
    nop
    nop
    nop

jr_007_7715:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ret nz

    ccf
    jr nz, jr_007_7700

    di
    cp h
    db $fc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_7734:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $01fe
    cp $c2
    inc a
    inc a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [hl], d
    inc c
    cp a
    ld a, h
    call $ff7e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rla
    ld c, $3f
    ld a, [de]
    ld e, d
    jr nc, jr_007_7734

    ld h, b

jr_007_7785:
    ld hl, sp+$60
    ld hl, sp+$50

jr_007_7789:
    ldh a, [rLCDC]

jr_007_778b:
    ldh [rLCDC], a

jr_007_778d:
    ld b, b
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld e, $01
    ld [bc], a
    ld bc, $0102
    dec b
    ld [bc], a
    inc b
    inc bc
    ld [$0e07], sp
    dec b
    rra
    add hl, bc
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
    db $10
    ldh [rAUD1SWEEP], a
    ldh [rNR41], a
    ret nz

    jr nz, jr_007_7785

    ld b, b
    add b
    jr nz, jr_007_7789

    jr nz, jr_007_778b

    jr nz, jr_007_778d

    sub b
    ldh [rAUD1SWEEP], a
    ldh [$f0], a
    ld h, b
    ldh a, [$60]
    ret nc

    ld h, b
    ld h, b
    nop
    nop
    nop
    nop
    nop
    ld [bc], a
    ld bc, $0102
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
    ld b, a
    cp b
    ld [bc], a
    db $fc
    ld bc, $83fe
    ld a, a
    ld [hl], a
    inc c
    ld c, $04
    ld c, $04
    rrca
    inc b
    rrca
    dec b
    rrca
    inc b
    ld c, $04
    ld c, $04
    ld a, [bc]
    inc b
    ld b, $00
    nop
    nop
    nop
    nop
    inc e
    rst $38
    ld hl, sp+$07
    add h
    inc bc
    add d
    ld bc, $0102
    ld bc, $0200
    ld bc, $0102
    add d
    ld bc, $0183
    inc bc
    ld bc, $0001
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    db $10
    ldh [$08], a
    ldh a, [$08]
    ldh a, [rDIV]
    ld hl, sp+$04
    ld hl, sp+$04
    ld hl, sp-$78
    ld [hl], b
    ld [hl], h
    adc b
    add h
    ld hl, sp-$3e
    ld a, h
    ld a, [c]
    inc a
    dec l
    ld e, $3d
    ld e, $16
    ld [$0008], sp
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $1e00
    ld bc, $1ee1
    rst $38
    db $fd
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
    inc b
    inc bc
    inc b
    inc bc
    ld [$0807], sp
    rlca
    db $10
    rrca
    jr nc, jr_007_7898

    ret nz

    ccf
    ld bc, $02fe
    db $fc
    adc h
    ldh a, [$f0]
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_7898:
    nop
    nop
    nop
    nop
    nop
    ld [$00f0], sp
    ldh a, [rAUD1SWEEP]
    ldh [rNR41], a
    ret nz

    nop
    ret nz

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
    rlca
    ld a, [$36cb]
    ld [hl], c
    ld c, $61
    ld a, $63
    ld e, $3b
    ld e, $3f
    ld e, $15
    ld c, $0e
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc b
    inc bc
    inc e
    inc bc
    jr nz, jr_007_790c

    daa
    jr jr_007_792e

    dec b
    ld a, [bc]
    dec b
    inc c
    inc bc
    ld [$0907], sp
    ld b, $0f
    nop
    rrca
    nop
    nop
    nop
    rlca
    nop
    jr c, jr_007_790a

    ret nz

    ccf
    inc bc
    db $fc
    dec bc
    or $1f

jr_007_790a:
    and $76

jr_007_790c:
    adc c
    ld b, b
    cp a
    ld e, b
    and a
    dec de
    db $fc
    ld e, a
    cp a
    rst $18
    ccf
    cp $3f
    cp [hl]
    ld a, a
    cp l
    ld a, [hl]
    ldh a, [rP1]
    rrca
    ldh a, [$15]
    ld [$cb34], a
    ld l, h
    sub e
    ei
    inc b
    ld d, [hl]
    xor a
    ld d, a
    xor a
    sub a

jr_007_792e:
    ld l, a
    cpl
    rst $18
    rra
    rst $38
    ld a, $ff
    or e
    ld a, h
    xor d
    ld [hl], a
    rst $38
    inc sp
    db $db
    ccf
    ld a, a
    nop
    db $fd
    ld [bc], a
    dec [hl]
    jp z, Jump_007_6b94

    ld [de], a
    db $ed
    ld [de], a
    db $ed
    adc d
    ld [hl], l
    ld c, c
    or [hl]
    ld c, c
    or [hl]
    ld c, c
    or [hl]
    ld b, c
    cp [hl]
    add b
    ld a, a
    ldh [$1f], a
    sbc b
    ld h, a
    ld [hl], h
    ei
    ld a, d
    db $fd
    rlca
    inc bc
    ld [bc], a
    ld bc, $0003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_7971:
    nop
    nop

jr_007_7973:
    nop
    nop

jr_007_7975:
    nop
    nop

jr_007_7977:
    nop
    nop

jr_007_7979:
    nop
    nop

jr_007_797b:
    nop
    nop

jr_007_797d:
    add e
    db $fc
    ccf
    ret nz

    rst $30
    ld [$7c83], sp
    add e
    ld a, l
    add e
    ld a, h
    ld b, d
    dec a
    ld b, c
    ld a, $79
    ld b, $60
    rra
    jr nz, @+$21

    ld l, $11
    jr c, @+$09

    jr nz, @+$21

    jr nc, jr_007_79aa

    ld d, $09
    cp $1d
    rst $28
    inc e
    db $fd
    ld l, $ff
    ld c, $ff
    ld e, $fd
    ld a, $7e

jr_007_79aa:
    db $fc
    or h
    ld a, b
    ld hl, sp+$00
    jr nz, jr_007_7971

    jr nz, jr_007_7973

    jr nz, jr_007_7975

    jr nz, jr_007_7977

    jr nz, jr_007_7979

    jr nz, jr_007_797b

    jr nz, jr_007_797d

    rst $38
    ld a, [hl]
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca
    inc bc
    ld [bc], a
    ld bc, $0003
    ld [bc], a
    ld bc, $0102
    rlca
    nop
    inc b
    inc bc
    inc c
    inc bc
    ld [$1f07], sp
    nop
    db $10
    rrca
    inc a
    inc bc
    ld [hl-], a
    dec c
    jr nz, jr_007_7a18

    ld b, b
    ccf
    add c
    ld a, [hl]
    add e
    db $fc
    ccf
    ret nz

    rst $30
    ld [$fc03], sp
    inc bc
    db $fd
    add e
    ld a, h
    ld b, d
    cp l
    ld bc, $01fe
    cp $02
    db $fc
    adc h
    ld [hl], b
    db $10
    ldh [rNR41], a
    ret nz

    ld b, b

jr_007_7a18:
    add b
    add b
    nop
    nop
    nop
    cp $1d
    rst $28
    inc e
    db $fd
    ld l, $ff
    ld c, $ff
    ld e, $fd
    ld a, $7e
    db $fc
    or h
    ld a, b
    ld hl, sp+$00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld [$0c00], sp
    nop
    ld b, $01
    inc bc
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
    stop
    nop
    nop
    inc b
    nop
    add d
    ld b, b
    pop hl
    jr nc, jr_007_7ae3

    inc e
    ccf
    rrca
    rra
    rlca
    rrca
    ld bc, $0003
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

jr_007_7a7f:
    nop
    nop

jr_007_7a81:
    nop
    nop

jr_007_7a83:
    nop
    nop
    nop
    nop
    nop
    add b
    ld b, b
    ldh [$38], a
    ld a, [hl]
    adc a
    rst $38
    db $fd
    rst $38
    rst $38
    rst $38
    ld a, a
    rst $38
    rra
    ccf
    inc bc
    rrca
    nop
    nop
    nop
    nop
    jr jr_007_7aa6

    jr jr_007_7aa8

    ld [$0c07], sp
    inc bc
    inc b

jr_007_7aa6:
    inc bc
    inc b

jr_007_7aa8:
    inc bc
    ld [bc], a
    ld bc, $0003
    adc a
    pop af
    cp $c7
    sbc $bf
    db $dd
    cp [hl]
    db $e3
    db $dd

jr_007_7ab7:
    rst $38
    db $e3

jr_007_7ab9:
    dec sp
    rst $30
    inc b
    inc bc
    jr nz, jr_007_7a7f

    jr nz, jr_007_7a81

    jr nc, jr_007_7a83

    ld l, b
    or b
    jr c, jr_007_7ab7

    jr c, jr_007_7ab9

    ld d, h
    ld hl, sp-$34
    ld hl, sp-$14
    ld hl, sp-$0c
    ld hl, sp+$18
    ldh a, [$88]
    ldh a, [$b8]
    ret nc

    ret c

    or b
    ld a, b
    or b
    xor b
    ld [hl], b
    rrca
    nop
    jr nc, jr_007_7af0

    ld b, b
    ccf

jr_007_7ae3:
    adc c
    db $76
    or [hl]
    ld a, a
    cp a
    ld a, a
    ld h, [hl]
    rra
    rra
    nop
    nop
    nop
    nop

jr_007_7af0:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    pop bc
    ld a, $02
    db $fc
    ld b, $f8
    ld d, d
    db $ec
    ld [c], a
    db $fc
    call c, Call_007_60e0
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
    nop
    nop
    nop
    nop
    inc bc
    nop
    inc b
    inc bc
    jr jr_007_7b34

    jr nz, jr_007_7b4e

    ret nz

    ccf
    add b
    ld a, a
    and b

jr_007_7b34:
    ld e, a
    ld [hl], b
    rrca
    ld sp, $3d0e
    ld [bc], a
    add hl, hl
    ld d, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld a, a
    nop
    add b
    ld a, a
    nop
    rst $38
    ld bc, $03fe

jr_007_7b4e:
    db $fc
    add hl, de
    and $45
    cp d
    sub l
    ld l, d
    add sp, $17
    inc sp
    call z, Call_007_7fbf
    rst $38
    ccf
    nop
    nop
    nop
    nop
    nop
    nop
    ld hl, sp+$00
    ld e, $e0
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
    cp $00
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
    jr nz, jr_007_7bbe

    inc d
    dec bc
    inc d
    dec bc
    inc c
    inc bc
    rlca
    nop
    ld [bc], a
    ld bc, $0003
    rlca
    nop
    rlca
    nop
    add hl, bc
    ld b, $08
    rlca
    ld de, $170e
    ld [$070a], sp
    rrca
    rlca
    ld a, [bc]
    rlca
    ld e, [hl]

jr_007_7bbe:
    cp a
    ld l, a
    sbc a
    ld l, h
    sbc a
    cp $1d
    db $fd
    inc bc
    rst $10
    rst $28
    rst $38
    rst $38
    rst $38
    rst $38
    ld a, c
    cp $ce
    ld sp, $8679
    rst $00
    jr c, jr_007_7bf6

    rst $18
    ret c

    rst $38
    ld hl, sp-$01
    rst $10
    ld hl, sp-$32
    ccf
    rst $30
    ld a, c
    ld l, l
    or e
    or e
    rst $08
    rst $30
    rst $08
    db $db
    rst $20
    rst $18
    ldh [$ac], a
    db $d3
    ret nz

    ccf
    nop
    rst $38
    add b
    ld a, a
    nop
    rst $38
    add e

jr_007_7bf6:
    ld a, a
    ld a, l
    sbc a
    ccf
    rst $18
    db $fd
    ld c, $84
    ld a, e
    call nz, $c43b
    dec sp
    ldh [$9f], a
    ld hl, sp-$79
    db $fc
    jp $40bf


    ld a, h
    add e
    add $39
    ld h, d
    db $fd
    jr nc, @+$01

    pop af
    cp $70
    rst $28
    or b
    rst $28
    cp a
    ret nz

    ld b, b
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
    rlca
    nop
    jr jr_007_7c3e

    jr nz, jr_007_7c58

    ldh [$1f], a
    add b
    ld a, a
    nop

jr_007_7c3e:
    nop

Call_007_7c3f:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld bc, $fe00
    ld bc, $ff00
    nop
    rst $38
    dec c

jr_007_7c58:
    ld a, [c]
    ld l, $dd
    ld l, d
    sbc l
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh [rP1], a
    ccf
    ret nz

    ld l, e
    sub h
    pop de
    ld l, $f2
    dec c
    xor l
    ld e, [hl]
    cp [hl]
    ld e, a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    ld a, a
    add b
    dec a
    jp nz, $6a95

    inc d
    db $eb
    sub [hl]
    ld l, c
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ldh a, [rP1]
    ccf
    ret nz

    dec e
    ld [c], a
    sub l
    ld l, d
    inc d
    db $eb
    sub [hl]
    ld l, c
    nop
    nop
    nop
    nop
    nop

Call_007_7cc2:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop

Call_007_7cca:
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rlca
    nop
    add hl, sp
    ld b, $4c
    inc sp
    add b
    ld a, a
    ld [bc], a
    db $fd
    ret nz

    ccf
    ld a, e
    inc b
    ld a, c
    ld d, $48
    scf
    jr z, @+$19

    jr nc, jr_007_7cf8

    inc de
    inc c
    rra
    nop
    ld e, $01
    dec de
    rlca
    db $fc
    inc bc
    inc hl
    call c, Call_007_5fa0
    nop

jr_007_7cf8:
    rst $38
    ret nz

    ccf
    ret nz

    ccf
    call nc, $983b
    ld h, a
    cp d
    ld a, l
    cp h
    ld a, a
    ld a, a
    cp a
    rst $18
    ccf
    sbc $3f
    cp l
    ld a, [hl]
    ld [hl], a
    ld hl, sp-$41
    ret nz

    inc l
    db $d3
    call z, Call_000_0f33
    pop af
    rra
    rst $28
    rla
    rst $28
    dec e
    db $e3
    ld e, [hl]
    cp a
    cp [hl]
    ld a, a
    db $fd
    cp $72
    db $fd
    dec l
    ld a, [c]
    ld h, [hl]
    reti


    call $ee7f
    ld a, a
    or [hl]
    ld a, a
    cp d
    ld a, a
    ld a, e
    db $fc
    ld a, e
    db $fc
    cp $f8
    db $fc
    ld hl, sp-$0c
    ld hl, sp-$48
    ret nz

    sub d
    ld l, l
    sub d
    ld l, l
    ld [de], a
    db $ed
    ld [de], a
    db $ed
    sub d
    ld l, l
    ld b, d
    cp l
    or b
    rst $08
    add sp, -$09
    db $f4
    ei
    ei
    db $fc
    ld a, [hl]
    rst $38
    pop hl
    ld e, $1f
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, b
    nop
    ld b, b
    nop
    ld b, b
    nop
    ld b, b
    nop
    ld b, b
    ld b, b
    ld b, d
    ld b, b
    ld h, d
    ld b, d
    ld h, d
    ld b, d
    ld h, d
    ld h, b
    ld h, e
    ld hl, $2173
    ld [hl], c
    ld sp, $3031
    add hl, sp
    jr jr_007_7db7

    inc e
    ld a, $00
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
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
    add b
    ret nz

    ret nz

    ldh [$e0], a
    ldh a, [$fc]
    ldh a, [$c0]
    ccf
    ld a, e
    inc b
    ld a, c
    ld d, $48
    scf
    jr z, jr_007_7dbe

    jr nc, @+$11

    inc de
    inc c
    rra
    nop
    ld e, $01
    dec de
    rlca
    inc e
    inc bc
    rrca
    nop
    inc de
    inc c

jr_007_7db7:
    jr c, @+$09

    ld c, h
    inc sp
    ret nz

    ccf
    ld [bc], a

jr_007_7dbe:
    ld bc, $0304
    ld [$1007], sp
    rrca
    jr nz, jr_007_7de6

    jr nz, jr_007_7de8

    db $10
    rrca
    ld [de], a
    dec c
    inc c
    rlca
    add hl, bc
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
    inc bc
    rst $38
    rrca
    rst $30
    ld [$0ff7], sp
    ldh a, [rNR14]

jr_007_7de6:
    ld hl, sp+$1e

jr_007_7de8:
    ld hl, sp-$46
    ld a, h
    ld [hl-], a
    call c, $c0fe
    ld d, b
    ldh [$e0], a
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld h, e
    sbc h
    ld a, h
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
    nop
    nop
    nop
    nop
    db $e3
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rra
    rra
    rrca
    rra
    rrca
    rra
    rrca
    ld c, $07
    inc c
    ld b, $01
    ld b, $01
    rlca
    nop
    ld b, $01
    ld [bc], a
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
    ld [hl], e
    call z, $ffce
    rst $38
    rst $18
    db $ed
    rra
    add hl, de
    rst $20
    di
    rst $38
    ld [hl], a
    rst $38
    and $1f
    db $ec
    rst $38
    ld [hl], e
    db $fc
    db $fc
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    ld b, $01
    adc a
    rlca
    ld a, a
    add [hl]
    sbc l
    cp $3d
    cp $7b
    db $fc
    rst $30
    ld hl, sp-$28
    ldh [$60], a
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
    ld b, b
    cp a
    ld b, b
    cp a
    add c
    ld a, [hl]
    ld c, $f0
    ld [hl], b
    add b
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
    rrca
    ldh a, [rSVBK]
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
    nop
    nop
    nop
    nop
    rst $38
    nop
    jp $ffff


    rst $38
    rst $30
    rst $38
    db $e3
    rst $38
    inc c
    di
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
    rst $38
    nop
    jp $ffff


    rst $38
    rst $38
    rst $38
    db $e3
    rst $38
    inc c
    di
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
    nop
    nop
    nop
    nop
    nop
    nop
    nop
    rra
    nop
    ld de, $3f0e
    nop
    ld b, a
    ccf
    ld b, a
    ccf
    ld a, h
    inc bc
    ld b, a
    ccf
    daa
    rra
    daa
    rra
    ld h, a
    rra
    nop
    nop
    nop
    nop

jr_007_7f41:
    nop
    nop
    nop
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
    ld b, b
    add b
    ret nz

    nop
    ld b, b
    add b
    add b
    nop
    add b
    nop
    add b
    nop
    ld d, c
    ld l, $6f
    jr nc, @-$5f

    ld h, b
    or c

jr_007_7f64:
    ld c, [hl]
    ld a, [$9645]
    ld l, a
    ld c, c

jr_007_7f6a:
    ld [hl], $36
    add hl, de
    ld [hl+], a
    rra
    scf
    rrca
    rra
    nop
    db $10
    rrca
    rrca
    nop
    ld [$1f07], sp
    nop
    ld d, $09
    add b
    nop
    add b

Call_007_7f80:
    nop
    ret nz

    nop
    ret nz

    nop
    ret nz

    nop
    add b
    nop
    add b
    ld b, b
    and b
    ld b, b
    ld [hl], b
    add b
    and b
    ret nz

    and b
    ld b, b
    ret nc

    ld h, b
    sub b
    ld h, b
    ret nc

    jr nz, jr_007_7f6a

    jr nz, jr_007_7f64

    jr nc, @+$53

    ld l, $6f
    jr nc, jr_007_7f41

    ld h, b
    or c
    ld c, [hl]
    ldh a, [rVBK]
    sub [hl]
    ld l, a
    ld c, c
    ld [hl], $36
    add hl, de
    ld [hl+], a
    rra
    scf
    rrca
    rra
    nop
    db $10
    rrca
    rrca
    nop
    ld [$1f07], sp
    nop
    ld d, $09
    dec e
    dec bc

Call_007_7fbf:
    dec e
    dec bc
    cpl
    dec de
    dec hl
    rra
    dec hl
    rra
    cpl
    rra
    ccf
    rra
    dec a
    rra
    ccf
    rra
    dec a
    rra
    inc a
    rra
    ccf
    nop
    inc c
    nop
    dec [hl]
    ld [$3dda], sp
    rst $38
    nop
    ld c, b
    or b
    ld l, b
    sub b
    cp b
    ret nz

    ldh [$c0], a
    ldh [$c0], a
    ldh [$c0], a
    ldh [$c0], a
    ret nc

    ldh [$d0], a
    ldh [rSVBK], a
    ldh [rSVBK], a
    ldh [$f0], a
    nop
    ret nz

    nop
    jr nz, @-$3e

    ldh [$c0], a
    ldh [rP1], a
    ldh [rIE], a
    rlca
