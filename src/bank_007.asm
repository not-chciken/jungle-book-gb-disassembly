SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

LoadSound0::
    jp InitSound

; $4003: Handles the currently playing sound as well as event sounds.
HandleSound::
    call HandleEventSound
    ld a, [FadeOutCounter]
    and a
    jr z, jr_007_401e         ; Jump if [FadeOutCounter] is zero.
    ld a, [CurrentSoundVolume]
    cp 1
    jr nz, HandleAllChannels

; $4013
PreNewSong:
    ld hl, CurrentSong
    ld a, [hl]
    and %00111111
    set 7, [hl]
    jp LoadNewSong

; $401e
jr_007_401e:
    ld a, [CurrentSong]
    bit 7, a
    jr nz, HandleAllChannels
    bit 6, a
    jr z, PreNewSong
    ld a, [ChannelEnable]
    and %111
    jr z, PreNewSong

.ReloadFadeOutCounter:
    ld a, [FadeOutCounterResetVal]
    ld [FadeOutCounter], a          ; = 12

; $4036
HandleAllChannels:
    ld a, [SoundCounter]
    dec a
    ld [SoundCounter], a
    call HandleSquare1Channel
    call HandleSquare2Channel
    call HandleWaveChannel
    call Call_007_4a06
    call HandlePercussion
    ld a, [SoundCounter]
    or a
    jr nz, CheckFadeOut
    ld a, 9

; $4054
CheckFadeOut:
    ld [SoundCounter], a
    ld a, [FadeOutCounter]
    or a
    ret z
    dec a
    jr z, .DecrementSoundVolume
    ld [FadeOutCounter], a          ; -= 1
    ret

; $4063
.DecrementSoundVolume:
    ld a, [CurrentSoundVolume]
    dec a
    cp 1
    jr z, TurnOff
    ld [CurrentSoundVolume], a
    call SetVolume
    jr ReloadFadeOutCounter

; $4073
TurnOff:
    xor a
    ld [ChannelEnable], a           ; = 0 (all sound channels disabled)
    ld [FadeOutCounter], a          ; = 0
    ret

; $407b
ReloadFadeOutCounter:
    ld a, [FadeOutCounterResetVal]
    ld [FadeOutCounter], a          ; = 12
    ret

; $4082
LoadNewSong:
    ld hl, TrackEnable
    bit 7, [hl]
    ret z                           ; Return if song track is not enabled.
    ld [CurrentSongUnused], a       ; Just set to be never used again...
    ld b, $00
    ld c, a
    sla c
    rlc b
    ld a, c
    ld l, a
    ld a, b
    ld h, a                         ; hl = [CurrentSong] * 2
    sla c
    rlc b
    sla c
    rlc b
    add hl, bc                      ; hl = [CurrentSong] * 10
    ld bc, TODOData5543
    add hl, bc
    ld c, 10
    ld de, SongDataRam

; $40a8
.CopyLoop:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, .CopyLoop

    ld c, 10
    ld hl, SongDataRam
    ld de, $c511

; $40b6: Copy the same data again into $c511.
CopyLoop2:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, CopyLoop2

    ld a, $01
    ld [$c52a], a                   ; = 1
    ld [$c52b], a                   ; = 1
    ld [$c52c], a                   ; = 1
    ld [$c52d], a                   ; = 1
    ld [$c52e], a                   ; = 1
    dec a
    ld [$c53c], a                   ; = 0
    ld [$c5bf], a                   ; = 0
    ld [$c544], a                   ; = 0
    ld [$c566], a                   ; = 0
    ld [$c583], a                   ; = 0
    ld [WaveSoundVolume], a         ; = 0
    ld [FadeOutCounter], a          ; = 0
    ld [EventSoundChannelsUsed], a  ; = 0
    ld [$c5b9], a                   ; = 0
    ld [NoiseWaveControl], a        ; = 0
    dec a
    ld [$c525], a                   ; = $ff
    ld [$c526], a                   ; = $ff
    ld [$c527], a                   ; = $ff
    ld [$c528], a                   ; = $ff
    ld [$c529], a                   ; = $ff
    ld [PlayingEventSound], a       ; = $ff
    ld a, %11111
    ld [ChannelEnable], a           ; = %11111 (enable all channels)
    ld a, 7
    call SetVolume                  ; Load volume 7 = full volume.
    ld a, 9
    ld [SoundCounter], a            ; = 9
    ld a, $00
    ld [$c5c4], a                   ; = 0
    dec a
    ld [PlayingEventSound], a       ; = $ff
    ret

; Initializes sound registers. Full volume on all outputs.
InitSound::
    ld a, $00
    ldh [rAUDENA], a                ; Stop all sound.
    ld a, $ff
    ld [CurrentSong], a             ; = $ff
    inc a
    ld [ChannelEnable], a                   ; = 0
    ld [FadeOutCounter], a          ; = 0
    ld [CurrentSoundVolume], a      ; = 0
    ld [$c5a6], a                   ; = 0
    ld a, $ff
    ld [PlayingEventSound], a                   ; = $ff
    ld [EventSound], a              ; = $ff
    inc a
    ld [EventSoundNoteLength], a    ; = 0
    ld [EventSoundChannelsUsed], a  ; = 0
    ld [$c5c4], a                   ; = 0
    ld a, %10001111                 ; No effect except for bit7.
    ldh [rAUDENA], a                ; Turn on sound.
    ld a, $ff
    ldh [rAUDVOL], a                ; Full volume, both channels on.
    ldh [rAUDTERM], a               ; All sounds to all terminal.
    ret

HandleSquare1Channel:
    ld a, [ChannelEnable]
    bit 0, a
    ret z                           ; Return if Square 1 channel is disabled.
    ld a, [Square1VibratoCounter]
    inc a
    jr z, jr_007_415a

    ld [Square1VibratoCounter], a                   ; += 1

jr_007_415a:
    ld a, [SoundCounter]
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
    jr z, Jump_007_417f

    ld a, [$c51b]
    ld l, a
    ld a, [$c51c]
    ld h, a
    jp Square1SetupLoop


Jump_007_417f:
    ld a, [SongDataRam]
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

    ld hl, ChannelEnable
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
    ld bc, TODOData626e
    add hl, bc
    inc de
    ld a, e
    ld [SongDataRam], a
    ld a, d
    ld [$c508], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e                         ; hl = [TODOData626e + offset]

; $420e: Now do actions based on the value of [TODOData626e + offset].
Square1SetupLoop:
    ld a, [hl+]
    bit 7, a
    jp z, HandleSquare

    cp $a0
    jr nc, jr_007_4222

    and $1f
    jr nz, jr_007_421d

    ld a, [hl+]

jr_007_421d:
    ld [$c52f], a
    jr Square1SetupLoop

jr_007_4222:
    cp $b0
    jr nc, jr_007_429c

    and $0f
    jr nz, jr_007_423e
    ld [$c540], a                   ; = 0
    ld [$c545], a                   ; = 0
    ld [$c550], a                   ; = 0
    ld [$c54b], a                   ; = 0
    ld [Square1SweepDelay], a       ; = 0
    ld [Square1VibratoDelay], a     ; = 0
    jr Square1SetupLoop

jr_007_423e:
    dec a
    jr nz, jr_007_4247

    ld a, [hl+]
    ld [$c540], a
    jr Square1SetupLoop

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
    jr Square1SetupLoop

jr_007_425b:
    dec a
    jr nz, jr_007_426c

    ld a, [hl+]
    ld [$c550], a
    ld a, [hl+]
    ld [$c551], a
    ld a, [hl+]
    ld [$c552], a
    jr Square1SetupLoop

jr_007_426c:
    dec a
    jr nz, jr_007_427d

    ld a, [hl+]
    ld [$c54e], a
    ld a, [hl+]
    ld [$c54d], a
    ld a, [hl+]
    ld [$c54b], a
    jr Square1SetupLoop

jr_007_427d:
    dec a
    jr nz, jr_007_428a

.SetSquare1Sweep:
    ld a, [hl+]
    ld [Square1SweepValue], a
    ld a, [hl+]
    ld [Square1SweepDelay], a
    jr Square1SetupLoop

jr_007_428a:
    dec a
    jr nz, jr_007_4299

.SetSquare1Vibrato:
    ld a, [hl+]
    ld [Square1Vibrato1], a
    ld a, [hl+]
    ld [Square1VibratoDelay], a
    ld a, [hl+]
    ld [Square1Vibrato2], a

jr_007_4299:
    jp Square1SetupLoop


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
    jp Square1SetupLoop


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
    jp Square1SetupLoop


jr_007_42d8:
    cp $d1
    jr nz, ToMain

    pop hl
    jp Square1SetupLoop

; $42e0
ToMain:
    jp Main
    jp Jump_007_417f


; $42e6
HandleSquare:
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
    ld bc, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square1FrequencyLsb], a
    ld a, [hl+]
    ld [Square1FrequencyMsb], a
    xor a
    ld [Square1VibratoDirection], a ; = 0
    ld [Square1VibratoDirCount], a  ; = 0
    ld [Square1Vibrato3], a         ; = 0
    ld a, [$c5bf]
    bit 0, a
    jr nz, jr_007_4342

    xor a
    ld [Square1VibratoCounter], a   ; = 0
    ld [$c541], a                   ; = 0
    ld [$c542], a                   ; = 0
    ld [$c547], a                   ; = 0
    ld [$c54c], a                   ; = 0
    ld a, [$c54e]
    ld [$c54f], a
    ld a, [$c545]
    bit 7, a
    jr nz, jr_007_433d

    ld a, [$c549]
    ld [$c54a], a

jr_007_433d:
    ld a, $80
    ld [$c544], a                   ; = $80

jr_007_4342:
    ld a, [$c52f]
    ld [$c52a], a
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, Jump_007_4354

    ld hl, EventSoundChannelsUsed
    res 0, [hl]

Jump_007_4354:
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
    ld a, [Square1VibratoCounter]
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
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square1FrequencyLsb], a
    ld a, [hl]
    ld [Square1FrequencyMsb], a

jr_007_439b:
    ld a, [Square1VibratoCounter]
    ld hl, $c550
    call Call_007_43e6
    ld de, Square1FrequencyLsb
    ld hl, Square1VibratoBase
    ld a, [Square1VibratoCounter]
    call HandleVibrato
    ld de, Square1FrequencyLsb
    ld hl, Square1SweepDelay
    ld a, [Square1VibratoCounter]
    call HandleSweep
    ld a, [EventSoundChannelsUsed]
    bit 0, a
    ret nz                          ; Return if EventSound uses Square1.

.SetUpSquare:
    ld c, LOW(rNR10)
    ld a, $08
    ldh [c], a                      ; [rNR10] = 8
    inc c
    ld a, [SquareNR11Value]
    ldh [c], a                      ; Wave duty, length load: [rNR11] = [SquareNR11Value]
    inc c
    ld hl, $c544
    bit 7, [hl]
    jr z, .SetUpFreq

.SetUpNR12:
    ld a, [SquareNR12Value]
    ldh [c], a                      ; Init volume, envelope mode, envelope period: [rNR12] = [SquareNR12Value]

; $43d8
.SetUpFreq:
    inc c
    ld a, [Square1FrequencyLsb]
    ldh [c], a                      ; Frequency LSB: [rNR13] = [Square1FrequencyLsb]
    inc c
    ld a, [Square1FrequencyMsb]
    or [hl]
    ldh [c], a                      ; Trigger, length enable, frequency MSB: [rNR14] = a
    xor a
    ld [hl], a
    ret

; $43e6
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
    ld [SquareNR11Value], a

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
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square1FrequencyLsb], a
    ld a, [hl]
    ld [Square1FrequencyMsb], a
    ret

; $4418
HandleSquare2Channel:
    ld a, [ChannelEnable]
    bit 1, a
    ret z                           ; Return if Square 2 channel is disabled.
    ld a, [Square2VibratoCounter]
    inc a
    jr z, jr_007_4427

    ld [Square2VibratoCounter], a

jr_007_4427:
    ld a, [SoundCounter]
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
    jr z, Jump_007_444c

    ld a, [$c51d]
    ld l, a
    ld a, [$c51e]
    ld h, a
    jp Jump_007_44db


Jump_007_444c:
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

    ld hl, ChannelEnable
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
    ld bc, TODOData626e
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
    ld l, e                         ; hl = [TODOData626e + offset]

Jump_007_44db:
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
    jr Jump_007_44db

jr_007_44ef:
    cp $b0
    jr nc, jr_007_4569

    and $0f
    jr nz, jr_007_450b

    ld [$c562], a
    ld [$c567], a
    ld [$c572], a
    ld [$c56d], a
    ld [Square2SweepDelay], a
    ld [Square2VibratoDelay], a
    jr Jump_007_44db

jr_007_450b:
    dec a
    jr nz, jr_007_4514

    ld a, [hl+]
    ld [$c562], a
    jr Jump_007_44db

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
    jr Jump_007_44db

jr_007_4528:
    dec a
    jr nz, jr_007_4539

    ld a, [hl+]
    ld [$c572], a
    ld a, [hl+]
    ld [$c573], a
    ld a, [hl+]
    ld [$c574], a
    jr Jump_007_44db

jr_007_4539:
    dec a
    jr nz, jr_007_454a

    ld a, [hl+]
    ld [$c570], a
    ld a, [hl+]
    ld [$c56f], a
    ld a, [hl+]
    ld [$c56d], a
    jr Jump_007_44db

jr_007_454a:
    dec a
    jr nz, jr_007_4557

    ld a, [hl+]
    ld [Square2SweepValue], a
    ld a, [hl+]
    ld [Square2SweepDelay], a
    jr Jump_007_44db

jr_007_4557:
    dec a
    jr nz, jr_007_4566

    ld a, [hl+]
    ld [Square2Vibrato1], a
    ld a, [hl+]
    ld [Square2VibratoDelay], a
    ld a, [hl+]
    ld [Square2Vibrato2], a

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
    jp Main


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
    ld bc, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square2FrequencyLsb], a
    ld a, [hl+]
    ld [Square2FrequencyMsb], a
    xor a
    ld [Square2VibratoDirection], a ; = 0
    ld [Square2VibratoDirCount], a  ; = 0
    ld [$c57a], a
    ld a, [$c5bf]
    bit 1, a
    jr nz, jr_007_460f

    xor a
    ld [Square2VibratoCounter], a
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
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, Jump_007_4621

    ld hl, EventSoundChannelsUsed
    res 1, [hl]                     ; Reset Square2 flag.

Jump_007_4621:
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
    ld a, [Square2VibratoCounter]
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
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square2FrequencyLsb], a
    ld a, [hl]
    ld [Square2FrequencyMsb], a

jr_007_4668:
    ld a, [Square2VibratoCounter]
    ld hl, $c572
    call Call_007_46b2
    ld de, Square2FrequencyLsb
    ld hl, Square2VibratoBase
    ld a, [Square2VibratoCounter]
    call HandleVibrato
    ld de, Square2FrequencyLsb
    ld hl, Square2SweepDelay
    ld a, [Square2VibratoCounter]
    call HandleSweep
    ld a, [EventSoundChannelsUsed]
    bit 1, a
    ret nz                          ; Return if event sound uses Square2.

    ld c, $15
    ld a, $08
    inc c
    ld a, [$c568]
    ldh [c], a                      ; [rNR21] = [$c568]
    inc c
    ld hl, $c566
    bit 7, [hl]
    jr z, jr_007_46a4

    ld a, [$c565]
    ldh [c], a                      ; [rNR22]

jr_007_46a4:
    inc c
    ld a, [Square2FrequencyLsb]
    ldh [c], a                      ; [rNR23]
    inc c
    ld a, [Square2FrequencyMsb]
    or [hl]
    ldh [c], a                      ; [rNR24]
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
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square2FrequencyLsb], a
    ld a, [hl]
    ld [Square2FrequencyMsb], a
    ret


; $46db
HandleWaveChannel:
    ld a, [ChannelEnable]
    bit 2, a
    ret z                           ; Return if wave channel is disabled.

    ld a, [WaveVibratoCounter]
    inc a
    jr z, jr_007_46ea

    ld [WaveVibratoCounter], a

jr_007_46ea:
    ld a, [SoundCounter]
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
    jr z, Jump_007_470f

    ld a, [$c51f]
    ld l, a
    ld a, [$c520]
    ld h, a
    jp WaveSetupLoop

Jump_007_470f:
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

.SetWaveNoteBase
    inc de
    ld a, [de]
    ld [WaveNoteBase], a
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

    ld hl, ChannelEnable
    res 2, [hl]
    ld hl, rNR52
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
    ld bc, TODOData626e
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
    ld l, e                         ; hl = [TODOData626e + offset]
    ld a, $80
    ld [$c583], a

; $47a3
WaveSetupLoop:
    ld a, [hl+]
    bit 7, a
    jp z, SetUpWaveNote

    cp $a0
    jr nc, jr_007_47b7

    and $1f
    jr nz, jr_007_47b2

    ld a, [hl+]

jr_007_47b2:
    ld [$c531], a
    jr WaveSetupLoop

jr_007_47b7:
    cp $b0
    jp nc, Jump_007_484d

    and $0f
    jr nz, WaveCheckA1

    ld [WaveSoundVolumeStart], a    ; = 0
    ld [$c581], a                   ; = 0
    ld [$c582], a                   ; = 0
    ld [$c596], a                   ; = 0
    ld [$c591], a                   ; = 0
    ld [WaveSweepDelay], a          ; = 0
    ld [WaveVibratoDelay], a        ; = 0
    jr WaveSetupLoop

; $47d7
WaveCheckA1:
    dec a
    jr nz, WaveCheckA2

    ld a, [hl+]
    ld [WaveSoundVolumeStart], a
    ld a, [hl+]
    ld [$c581], a
    ld a, [hl+]
    ld [$c582], a
    jr WaveSetupLoop

; $47e8
WaveCheckA2:
    dec a
    jr nz, WaveCheckA3

    ld a, [hl+]
    ld [$c58f], a
    ld [$c590], a
    ld a, [hl+]
    ld [$c58e], a
    ld a, [hl+]
    ld [$c58b], a
    jr WaveSetupLoop

; $47fc
WaveCheckA3:
    dec a
    jr nz, WaveCheckA4

    ld a, [hl+]
    ld [$c596], a
    ld a, [hl+]
    ld [$c597], a
    ld a, [hl+]
    ld [$c598], a
    jr WaveSetupLoop

; $480d
WaveCheckA4:
    dec a
    jr nz, WaveCheckA5

    ld a, [hl+]
    ld [$c594], a
    ld a, [hl+]
    ld [$c593], a
    ld a, [hl+]
    ld [$c591], a
    jr WaveSetupLoop

; $481e
WaveCheckA5:
    dec a
    jr nz, WaveCheckA6

.SetWaveSwep:
    ld a, [hl+]
    ld [WaveSweepValue], a
    ld a, [hl+]
    ld [WaveSweepDelay], a
    jp WaveSetupLoop

; $482c
WaveCheckA6:
    dec a
    jr nz, WaveCheckA7

.SetWaveVibrato:
    ld a, [hl+]
    ld [WaveVibrato1], a
    ld a, [hl+]
    ld [WaveVibratoDelay], a
    ld a, [hl+]
    ld [WaveVibrato2], a
    jp WaveSetupLoop

; $483e
WaveCheckA7:
    dec a
    jr nz, RepeatWaveSetupLoop

.SetWaveSamplePalette:
    ld a, [hl+]
    ld [WaveSamplePalette], a
    push hl
    call InitWaveSamples
    pop hl

; $484a
RepeatWaveSetupLoop:
    jp WaveSetupLoop


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
    jp WaveSetupLoop


jr_007_4877:
    cp $ff
    jp z, Jump_007_470f

    jp Jump_007_470f


; $487f
SetUpWaveNote:
    ld c, a
    ld a, [WaveNoteBase]
    add c
    ld [WaveNote], a
    ld a, l
    ld [$c51f], a
    ld a, h
    ld [$c520], a
    ld a, [WaveNote]
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [WaveFrequencyLsb], a
    ld a, [hl+]
    ld [WaveFrequencyMsb], a
    xor a
    ld [WaveVibratoDirection], a    ; = 0
    ld [WaveVibratoDirCount], a     ; = 0
    ld [WaveVibrato3], a            ; = 0
    ld a, [$c5bf]
    bit 2, a
    jr nz, jr_007_48db
    xor a
    ld [WaveVibratoCounter], a      ; = 0
    ld [$c57d], a                   ; = 0
    ld [$c57e], a                   ; = 0
    ld [$c58d], a                   ; = 0
    ld [$c592], a                   ; = 0
    ld a, $20
    ld [$c5c1], a                   ; = $20
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
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, Jump_007_48ed

    ld hl, EventSoundChannelsUsed
    res 2, [hl]                     ; Reset event sound wave flag.

Jump_007_48ed:
    ld a, [EventSoundChannelsUsed]
    bit 2, a
    jr nz, jr_007_4911              ; Jump if event sound uses wave. There is no event sound with wave afaik.

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
    ld a, [WaveSamplePalette]
    call InitWaveSamples

jr_007_4911:
    call Call_007_49bc
    ld hl, $c591
    ld a, [hl]
    or a
    jr z, jr_007_4938

    ld a, [$c595]
    ld b, a
    ld a, [WaveNote]
    ld c, a
    call Call_007_4e67
    ld b, $00
    sla c
    rl b
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [WaveFrequencyLsb], a
    ld a, [hl]
    ld [WaveFrequencyMsb], a

jr_007_4938:
    ld a, [WaveVibratoCounter]
    ld hl, $c596
    call SetWaveFrequency
    ld de, WaveFrequencyLsb
    ld hl, WaveVibratoBase
    ld a, [WaveVibratoCounter]
    call HandleVibrato
    ld de, WaveFrequencyLsb
    ld hl, WaveSweepDelay
    ld a, [WaveVibratoCounter]
    call HandleSweep
    ld a, [EventSoundChannelsUsed]
    bit 2, a
    ret nz                          ; Return if event sound uses Square2.
    ld a, [NoiseWaveControl]
    and $0c
    ret nz
    ld c, LOW(rNR30)
    ld a, $ff
    ldh [c], a                      ; rNR30 = $ff -> Turn wave sound on
    inc c
    ld a, $ff
    ldh [c], a                      ; rNR31 = $ff -> 1/256 second sound
    inc c
    ld a, [WaveSoundVolume]
    add LOW(VolumeNR32Settings)
    ld l, a
    ld h, HIGH(VolumeNR32Settings)
    ld a, [hl]
    ldh [c], a                      ; rNR32 (volume)
    inc c
    ld a, [WaveFrequencyLsb]
    ldh [c], a                      ; rNR33 = [WaveFrequencyLsb]
    inc c
    ld hl, $c583
    ld a, [WaveFrequencyMsb]
    or [hl]
    ldh [c], a                      ; rNR34 = ..
    xor a
    ld [hl], a
    ret

; $498a
; Input: a = counter
;        hl[0] = some delay?
;        hl[1] = new wave sample palette if Bit 1 is not zero.
;        hl[2] = new note if hl[1] Bit 1 is zero. Else this is added to [WaveNote].
SetWaveFrequency:
    cp [hl]
    jr c, .CheckPaletteSet
    ret nz

; $498e
.ChooseWaveNote:
    ld a, [WaveNote]                ; Simply get the note.
    jr .SetFrequencyToA

; $4993
.CheckPaletteSet:
    inc hl
    ld a, [hl+]                     ; a = new note
    ld e, a
    bit 1, e
    jr z, .CheckNote

; $499a
.SetWaveSamplePalette:
    and %11000000
    ld [WaveSamplePalette], a

; $499f
.CheckNote:
    ld c, [hl]
    bit 0, e
    jr z, .SetFrequency

; $49a4
.NoteWithBase:
    ld a, [WaveNote]
    add c

; $49a8
.SetFrequencyToA:
    ld c, a

; $49a9
.SetFrequency:
    ld b, $00
    sla c
    rl b                            ; bc = 2 * bc
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [WaveFrequencyLsb], a
    ld a, [hl]
    ld [WaveFrequencyMsb], a
    ret

; $49bc
Call_007_49bc:
    ld a, [$c57d]
    bit 1, a
    ret nz                          ; Return if [$c57d] & %10
    bit 0, a
    jr nz, jr_007_49e4              ; Jump [$c57d] & %1

    ld a, [WaveSoundVolumeStart]
    ld [WaveSoundVolume], a         ; = [WaveSoundVolumeStart]
    ld a, [$c581]
    and a
    jr nz, jr_007_49d8

    ld hl, $c57d
    inc [hl]
    jr jr_007_49e4

jr_007_49d8:
    ld hl, $c57e
    inc [hl]                        ; [$c57e] += 1
    xor [hl]
    ret nz                          ; Return if [$c581] != [$c57e]

    ld [hl], a                      ; [$c57e] = [$c581]
    ld hl, $c57d
    inc [hl]                        ; [$c57d] += 1
    ret

; $49e4
jr_007_49e4:
    ld a, [$c582]
    and a
    jr nz, jr_007_49ef

    ld [WaveSoundVolume], a         ; = 0
    jr jr_007_4a01

; $49ef
jr_007_49ef:
    ld hl, $c57e
    inc [hl]
    xor [hl]
    ret nz

    ld [hl], a                      ; = 0
    ld a, [WaveSoundVolume]
    or a
    jr z, jr_007_4a01

    dec a
    ld [WaveSoundVolume], a         ; -= 1
    ret

; $4a01
jr_007_4a01:
    ld hl, $c57d
    inc [hl]
    ret


Call_007_4a06:
    ld a, [ChannelEnable]
    bit 3, a
    ret z

    ld a, [$c537]
    inc a
    jr z, jr_007_4a15

    ld [$c537], a

jr_007_4a15:
    ld a, [SoundCounter]
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
    jr z, Jump_007_4a3a

    ld a, [$c521]
    ld l, a
    ld a, [$c522]
    ld h, a
    jp Jump_007_4ac9


Jump_007_4a3a:
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

    ld hl, ChannelEnable
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
    ld bc, TODOData626e
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
    ld l, e                         ; hl = [TODOData626e + offset]

Jump_007_4ac9:
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
    jr Jump_007_4ac9

jr_007_4add:
    cp $b0
    jr nc, jr_007_4b2b

    and $0f
    jr nz, jr_007_4af0

    ld [$c5a8], a
    ld [$c5ad], a
    ld [$c5b2], a
    jr Jump_007_4ac9

jr_007_4af0:
    dec a
    jr nz, jr_007_4af9

    ld a, [hl+]
    ld [$c5a8], a
    jr Jump_007_4ac9

jr_007_4af9:
    dec a
    jr nz, jr_007_4b02

    ld a, [hl+]
    ld [$c5a6], a
    jr Jump_007_4ac9

jr_007_4b02:
    dec a
    jr nz, jr_007_4b07

    jr Jump_007_4ac9

jr_007_4b07:
    dec a
    jr nz, jr_007_4b18

    ld a, [hl+]
    ld [$c5b0], a
    ld a, [hl+]
    ld [$c5af], a
    ld a, [hl+]
    ld [$c5ad], a
    jr Jump_007_4ac9

jr_007_4b18:
    dec a
    jr nz, jr_007_4b25

    ld a, [hl+]
    ld [$c5b3], a
    ld a, [hl+]
    ld [$c5b2], a
    jr Jump_007_4ac9

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
    ld bc, NoiseNr43Settings
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
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, Jump_007_4bad

    ld hl, EventSoundChannelsUsed
    res 3, [hl]                     ; Reset event sound wave flag.

Jump_007_4bad:
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
    ld hl, NoiseNr43Settings
    add hl, bc
    ld a, [hl+]
    ld [$c5a5], a

jr_007_4bde:
    call Call_007_4c12
    ld a, [EventSoundChannelsUsed]
    bit 3, a
    ret nz

    ld a, [NoiseWaveControl]
    and $03
    ret nz

    ld c, LOW(rNR41)
    ld a, $3f
    ldh [c], a                      ; [rNR41 ] = %0011 1111
    inc c
    ld hl, $c5ac
    bit 7, [hl]
    jr z, jr_007_4bfe

    ld a, [$c5ab]
    ldh [c], a

jr_007_4bfe:
    inc c
    ld hl, $c5a6
    ld a, [$c5a5]
    or [hl]
    ldh [c], a
    inc c
    ld a, [$c5ac]
    ret z

    ldh [c], a
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
    ld hl, NoiseNr43Settings
    add hl, bc
    ld a, [hl+]
    ld [$c5a5], a
    ret

; $4c31 Noise-channel related things.
HandlePercussion:
    ld a, [ChannelEnable]
    bit 4, a
    ret z                         ; Return if noise channel is not enabled.
    ld a, [WaveTriggerEnable]
    inc a
    jr z, jr_007_4c40

    ld [WaveTriggerEnable], a

jr_007_4c40:
    ld a, [SoundCounter]
    or a
    jp z, Jump_007_4d44

    ld a, [$c52e]
    dec a
    jr z, jr_007_4c53

    ld [$c52e], a                   ; -= 1
    jp Jump_007_4d44

jr_007_4c53:
    ld a, [$c529]
    cp $ff
    jr z, Jump_007_4c65

    ld a, [$c523]
    ld l, a
    ld a, [$c524]
    ld h, a
    jp Jump_007_4ce3

Jump_007_4c65:
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

    ld hl, ChannelEnable
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
    ld bc, TODOData626e
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
    ld l, e                         ; hl = [TODOData626e + offset]

Jump_007_4ce3:
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
    jr Jump_007_4ce3

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
    ld [SoundHlLsb], a
    ld a, h
    ld [SoundHlMsb], a

jr_007_4d25:
    xor a
    ld [WaveTriggerEnable], a       ; = 0
    ld [$c5c1], a                   ; = 0
    ld a, $80
    ldh [rNR30], a                  ; = $80 (sound on)
    ld a, [$c533]
    ld [$c52e], a                   ; = [$c533]
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, Jump_007_4d44

    ld hl, EventSoundChannelsUsed
    res 2, [hl]
    res 3, [hl]

; $4d44
Jump_007_4d44:
    ld a, [$c5b9]
    and a
    jr nz, jr_007_4d4b
    ret

jr_007_4d4b:
    xor a
    ld [NoiseWaveControl], a        ; = 0
    ld a, [SoundHlLsb]
    ld l, a
    ld a, [SoundHlMsb]
    ld h, a
    ld a, [hl+]
    ld [NoiseWaveControl], a
    bit 7, a
    jr z, jr_007_4d72

    ld [NoiseWaveControlBackup], a
    xor a
    ld [$c5b9], a                   ; = 0
    ld [NoiseWaveControl], a        ; = 0
    ld a, [$c5c1]                   ; = 0
    set 6, a
    ld [$c5c1], a
    ret

jr_007_4d72:
    ld a, [hl+]
    ld [WaveVolume], a
    ld a, [hl+]
    ld c, a
    ld a, [hl+]
    ld e, a                         ; = offset for Noise setting.
    ld a, [hl+]
    ld [NoiseVolume], a
    ld a, l
    ld [SoundHlLsb], a              ; Save LSB of hl.
    ld a, h
    ld [SoundHlMsb], a              ; Save MSB of hl.
    ld a, [EventSoundChannelsUsed]  ; Skip wave if Bit 2 is set. Skip noise if Bit 3 is set.
    and %100
    jr nz, CheckSetupNoiseLfsr

    ld a, [NoiseWaveControl]
    ld b, a
    and $0c
    jr nz, CheckSetupWaveVolume

    ld a, [$c5c1]
    set 6, a
    ld [$c5c1], a
    jr CheckSetupNoiseLfsr

CheckSetupWaveVolume:              ; $4d9f
    ld b, a
    bit 3, a
    jr z, CheckSetupWave

.SetUpWaveVolume:
    ld a, [WaveVolume]
    ldh [rNR32], a

; $4da9
CheckSetupWave:
    ld a, [NoiseWaveControl]
    bit 2, a
    jr z, CheckSetupNoiseLfsr

.SetUpWave:
    ld l, c
    ld h, $00
    add hl, hl
    ld bc, NoteToFrequencyMap
    add hl, bc                      ; hl = NoteToFrequencyMap + 2 * c
    ld a, [hl+]
    ldh [rNR33], a                  ; Wave frequency LSB
    ld a, [WaveTriggerEnable]
    and a
    ld a, [hl+]
    jr nz, :+
    or $80                          ; Enable trigger
 :  ldh [rNR34], a                  ; Wave: trigger, length enable, frequency MSB

; $4dc6
CheckSetupNoiseLfsr:
    ld a, [EventSoundChannelsUsed]
    and %1000
    jr nz, .SkipSetup
    ld a, [NoiseWaveControl]
    bit 1, a
    jr z, .CheckTriggerNoise

.SetUpNoiseLfsr:
    ld d, $00
    ld hl, NoiseNr43Settings
    add hl, de
    ld a, [hl]
    ldh [rNR43], a                  ; Set up noise clock shift, width mode of LFSR, divisor code.

; $4ddd
.CheckTriggerNoise:
    ld a, [NoiseWaveControl]
    bit 0, a
    jr z, .SkipSetup

.TriggerNoise:
    ld a, [NoiseVolume]
    ldh [rNR42], a                  ; Setup noise starting volume, envelope add mode, and period.
    ld a, $80
    ldh [rNR44], a                  ; Trigger noise channel. Don't use length.

; $4ded
.SkipSetup:
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

; $4e00: Settings used by SetVolume.
VolumeSettings:
    db $88,$99,$aa,$bb,$cc,$dd,$ee,$ff


; $4e08: Maybe this is some kind of vibrato? Called for all frequency-based channels.
; Input de = frequency
;       hl = pointer to RAM (WaveVibratoBase, Square1VibratoBase, or Square2VibratoDelay)
;       a = value of a variable ([Square1VibratoCounter], [Square2VibratoCounter], or [WaveVibratoCounter])
HandleVibrato:
    cp [hl]
    ret c                           ; Check if VibratoCounter reached VibratoDelay.
    ld a, [hl+]
    or a
    ret z                           ; Return if VibratoDelay is zero.
    ld a, [hl]
    swap a
    and $0f
    ld b, a                         ; b = [hl + 1] >> 4 = amount of frequency change
    ld a, [hl+]
    and $0f
    ld c, a                         ; c = [hl + 1] & $0f = period length of vibrato
    ld a, [hl+]
    add [hl]
    ld [hl-], a                     ; [hl + 3] = [hl + 2] + [hl + 3]
    jr z, .CheckFrequencyChange
    ret nc

; 4e1d
.CheckFrequencyChange:
    ld a, [hl+]                     ; a = [hl + 2]
    ld [hl+], a                     ; [hl + 3] = [hl + 2]
    ld a, [hl+]                     ; a = [hl + 4]
    bit 1, a
    jr nz, .FrequencyDecrement

; $4e24
.FrequencyIncrement:
    ld a, [de]
    add b
    ld [de], a                      ; Increment frequency.
    inc de
    ld a, [de]
    jr nc, .CheckDirectionChange
    inc a
    jr .CheckDirectionChange

; $4e2e
.FrequencyDecrement:
    ld a, b
    xor $ff
    inc a                           ; Two's complement.
    ld b, a
    ld a, [de]
    add b
    ld [de], a
    inc de
    ld a, [de]
    jr c, .CheckDirectionChange
    dec a

; $4e3b
.CheckDirectionChange:
    ld [de], a                      ; Handle overflow/underflow case.
    ld a, c
    inc [hl]
    xor [hl]                        ; [hl + 5]
    ret nz                          ; Return if a and [hl] are different.

; $4e40
.ChangeDirection:
    ld [hl-], a                     ; [hl + 5] = 0
    ld a, [hl]
    dec a
    bit 7, a                        ; Set to 3 if value turned negative.
    jr z, .SetVibratoDirection
    ld a, 3

; $4e49
.SetVibratoDirection:
    ld [hl], a                      ; [hl + 4] = [VibratoDirection] vibrato direction
    ret

; $4e4b
; Input de = frequency
;       hl[0] = sweep counter
;       hl[1] = sweep value
HandleSweep:
    cp [hl]
    ret c
    ld a, [hl]
    or a
    ret z
    inc hl
    bit 7, [hl]
    jr nz, .DecrementFrequency

; $4e55
.IncrementFrequency:
    ld a, [de]
    add [hl]
    ld [de], a
    inc de
    ld a, [de]
    adc 0
    ld [de], a
    ret

; $4e5e
.DecrementFrequency:
    ld a, [de]
    add [hl]
    ld [de], a
    inc de
    ld a, [de]
    ret c
    dec a
    ld [de], a
    ret

; $4e67
; Input: b = offset for TODOData5147
;        c = c + [TODOData5147 + b]
Call_007_4e67:
    ld de, TODOData5147
    ld a, b
    add e
    ld e, a
    jr nc, jr_007_4e70
    inc d                           ; Handle LSB carry.

jr_007_4e70:
    ld a, [de]                      ; a = [TODOData5147 + b]
    add c
    ld c, a                         ; c = c + [TODOData5147 + b]
    ld a, [hl+]
    inc [hl]                        ; [hl + 1] += 1
    xor [hl]
    ret nz                          ; Return if [hl] and [hl + 1] are unequal.

    ld [hl+], a                     ; [hl + 1] = 0
    inc b                           ; b += 1
    ld a, b
    cp [hl]                         ; b - [hl + 2]
    inc hl
    jr nz, jr_007_4e7f

    ld b, [hl]                      ; b = [hl + 3]

jr_007_4e7f:
    inc hl
    ld [hl], b                      ; [hl + 4] = b
    ret

; Only called for square waves.
; Input hl = $c567 or $c545
;       e = [$c56c] or [$c54a]
Call_007_4e82:
    ld a, [hl+]
    or a
    ret z

    ld b, a
    ld a, LOW(TODOData5190)
    add e
    ld e, a
    ld d, HIGH(TODOData5190)
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


; $4efd: Sets up the wave samples.
; Input: a = index for wave sample palette
InitWaveSamples:
    ld b, $00
    ld c, a
    ld l, LOW(WaveSampleData)
    ld h, HIGH(WaveSampleData)
    add hl, bc
    xor a
    ldh [rNR30], a                  ; = 0
    ld c, 16                        ; There are 32 samples with 4 bit each.
    ld de, _AUD3WAVERAM

; $4f0d
.CopyLoop:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, .CopyLoop
    ret

VolumeNR32Settings::
    db $00                          ; Volume = 0%
    db $60                          ; Volume = 25%
    db $40                          ; Volume = 50%
    db $20                          ; Volume = 100%

; $4f18: Frequency setting for the wave channel.
NoteToFrequencyMap::
    dw $002c                        ; f = 1046.4 Hz / 32 = 32.7 Hz = C1
    dw $009d                        ; f = 1110.4 Hz / 32 = 34.7 Hz = C♯1
    dw $0107                        ; f = 1174.4 Hz / 32 = 36.7 Hz = D1
    dw $016b                        ; f = 1244.8 Hz / 32 = 38.9 Hz = D♯1
    dw $01c9                        ; f = 1318.4 Hz / 32 = 41.2 Hz = E1
    dw $0223                        ; f = 1398.4 Hz / 32 = 43.7 Hz = F1
    dw $0277                        ; f = 1478.4 Hz / 32 = 46.2 Hz = F♯1
    dw $02c7                        ; f = 1568.0 Hz / 32 = 49.0 Hz = G1
    dw $0312                        ; f = 1660.8 Hz / 32 = 51.9 Hz = G♯1
    dw $0358                        ; f = 1760.0 Hz / 32 = 55.0 Hz = A1
    dw $039b                        ; f = 1865.6 Hz / 32 = 58.3 Hz = A♯1
    dw $03da                        ; f = 1974.4 Hz / 32 = 61.7 Hz = B1
    dw $0416                        ; f = 2092.8 Hz / 32 = 65.4 Hz = C2
    dw $044e                        ; f = 2217.6 Hz / 32 = 69.3 Hz = C♯2
    dw $0483                        ; f = 2348.8 Hz / 32 = 73.4 Hz = D2
    dw $04b5                        ; f = 2486.4 Hz / 32 = 77.7 Hz = D♯2
    dw $04e5                        ; f = 2636.8 Hz / 32 = 82.4 Hz = E2
    dw $0511                        ; f = 2793.6 Hz / 32 = 87.3 Hz = F2
    dw $053b                        ; f = 2956.8 Hz / 32 = 92.4 Hz = F♯2
    dw $0563                        ; f = 3136.0 Hz / 32 = 98.0 Hz = G2
    dw $0589                        ; f = 3324.8 Hz / 32 = 103.9 Hz = G♯2
    dw $05ac                        ; f = 3520.0 Hz / 32 = 110.0 Hz = A2
    dw $05ce                        ; f = 3731.2 Hz / 32 = 116.6 Hz = A♯2
    dw $05ed                        ; f = 3948.8 Hz / 32 = 123.4 Hz = B2
    dw $060b                        ; f = 4185.6 Hz / 32 = 130.8 Hz = C3
    dw $0627                        ; f = 4435.2 Hz / 32 = 138.6 Hz = C♯3
    dw $0642                        ; f = 4700.8 Hz / 32 = 146.9 Hz = D3
    dw $065b                        ; f = 4982.4 Hz / 32 = 155.7 Hz = D♯3
    dw $0672                        ; f = 5270.4 Hz / 32 = 164.7 Hz = E3
    dw $0689                        ; f = 5593.6 Hz / 32 = 174.8 Hz = F3
    dw $069e                        ; f = 5923.2 Hz / 32 = 185.1 Hz = F♯3
    dw $06b2                        ; f = 6278.4 Hz / 32 = 196.2 Hz = G3
    dw $06c4                        ; f = 6636.8 Hz / 32 = 207.4 Hz = G♯3
    dw $06d6                        ; f = 7036.8 Hz / 32 = 219.9 Hz = A3
    dw $06e7                        ; f = 7462.4 Hz / 32 = 233.2 Hz = A♯3
    dw $06f7                        ; f = 7913.6 Hz / 32 = 247.3 Hz = B3
    dw $0706                        ; f = 8387.2 Hz / 32 = 262.1 Hz = C4
    dw $0714                        ; f = 8886.4 Hz / 32 = 277.7 Hz = C♯4
    dw $0721                        ; f = 9404.8 Hz / 32 = 293.9 Hz = D4
    dw $072d                        ; f = 9939.2 Hz / 32 = 310.6 Hz = D♯4
    dw $0739                        ; f = 10537.6 Hz / 32 = 329.3 Hz = E4
    dw $0744                        ; f = 11155.2 Hz / 32 = 348.6 Hz = F4
    dw $074f                        ; f = 11849.6 Hz / 32 = 370.3 Hz = F♯4
    dw $0759                        ; f = 12556.8 Hz / 32 = 392.4 Hz = G4
    dw $0762                        ; f = 13273.6 Hz / 32 = 414.8 Hz = G♯4
    dw $076b                        ; f = 14073.6 Hz / 32 = 439.8 Hz = A4
    dw $0773                        ; f = 14873.6 Hz / 32 = 464.8 Hz = A♯4
    dw $077b                        ; f = 15769.6 Hz / 32 = 492.8 Hz = B4
    dw $0783                        ; f = 16777.6 Hz / 32 = 524.3 Hz = C5
    dw $078a                        ; f = 17772.8 Hz / 32 = 555.4 Hz = C♯5
    dw $0790                        ; f = 18723.2 Hz / 32 = 585.1 Hz = D5
    dw $0797                        ; f = 19974.4 Hz / 32 = 624.2 Hz = D♯5
    dw $079d                        ; f = 21184.0 Hz / 32 = 662.0 Hz = E5
    dw $07a2                        ; f = 22310.4 Hz / 32 = 697.2 Hz = F5
    dw $07a7                        ; f = 23564.8 Hz / 32 = 736.4 Hz = F♯5
    dw $07ac                        ; f = 24966.4 Hz / 32 = 780.2 Hz = G5
    dw $07b1                        ; f = 26547.2 Hz / 32 = 829.6 Hz = G♯5
    dw $07b6                        ; f = 28339.2 Hz / 32 = 885.6 Hz = A5
    dw $07ba                        ; f = 29958.4 Hz / 32 = 936.2 Hz = A♯5
    dw $07be                        ; f = 31776.0 Hz / 32 = 993.0 Hz = B5
    dw $07c1                        ; f = 33289.6 Hz / 32 = 1040.3 Hz = C6
    dw $07c5                        ; f = 35545.6 Hz / 32 = 1110.8 Hz = C♯6
    dw $07c8                        ; f = 37449.6 Hz / 32 = 1170.3 Hz = D6
    dw $07cb                        ; f = 39568.0 Hz / 32 = 1236.5 Hz = D♯6
    dw $07ce                        ; f = 41942.4 Hz / 32 = 1310.7 Hz = E6
    dw $07d1                        ; f = 44620.8 Hz / 32 = 1394.4 Hz = F6
    dw $07d4                        ; f = 47664.0 Hz / 32 = 1489.5 Hz = F♯6
    dw $07d6                        ; f = 49932.8 Hz / 32 = 1560.4 Hz = G6
    dw $07d9                        ; f = 53772.8 Hz / 32 = 1680.4 Hz = G♯6
    dw $07db                        ; f = 56678.4 Hz / 32 = 1771.2 Hz = A6
    dw $07dd                        ; f = 59920.0 Hz / 32 = 1872.5 Hz = A♯6
    dw $07df                        ; f = 63548.8 Hz / 32 = 1985.9 Hz = B6

    pop hl
    rlca
    ldh [c], a
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

; $4fc0
NoiseNr43Settings::
    db $d7, $d6, $d5, $d4, $c7, $c6, $c5, $c4, $b7, $b6, $b5, $b4, $a7, $a6, $a5, $a4

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
    jr @+$42
    ld b, a

; $5147
TODOData5147::
    db $00, $04, $07, $07, $04, $00, $00, $05, $09, $09, $05, $00, $00, $06, $09, $09
    db $06, $00, $00, $03, $08, $08, $03, $00, $00, $03, $07, $07, $03, $00, $fe, $04
    db $07, $07, $04, $fe, $00, $03, $09, $09, $03, $00, $00, $05, $08, $08, $05, $00
    db $00, $04, $09, $09, $04, $00, $fd, $00, $03, $07, $f8, $fb, $00, $04, $00, $04
    db $0a, $00, $00, $00, $00, $00, $00, $00, $00

; $5190
TODOData5190::
    db $00, $40, $80, $c0, $80, $40, $00, $00

; $5198: Each row is one palette. A palette comprises 32 samples, 4 bit each.
WaveSampleData::
    db $01, $23, $45, $67, $89, $ab, $cd, $ef, $ed, $cb, $a9, $87, $65, $43, $21, $00     ; Triangle wave.
    db $01, $24, $68, $ab, $cd, $ef, $ff, $ff, $ff, $ff, $fe, $dc, $ba, $86, $42, $10     ; Mildly clipped sine wave.
    db $7c, $ee, $ef, $ff, $ff, $ee, $ed, $c9, $63, $21, $11, $10, $00, $01, $11, $37     ; Noisy and mildy-clipped sine wave.

; $51c8
TODOData51c8::
    dw .TodoPtr1 
    dw .TodoPtr2
    dw .TodoPtr3
    dw .TodoPtr4
    dw .TodoPtr5 
    dw .TodoPtr6

; $51d4
.TodoPtr1:
    db $00, $ff

; $51d6
.TodoPtr2:
    db $0f, $20, $18, $3a, $71, $0c, $20, $12, $3a, $00, $ff

; $51e1
.TodoPtr3:
    db $0f, $20, $20, $34, $91, $0e, $20, $1c, $37, $00, $02, $00, $00, $39, $00, $02
    db $00, $00, $37, $00, $02, $00, $00, $39, $00, $02, $00, $00, $37, $00, $ff

; $5200
.TodoPtr4:
    db $0f, $20, $20, $35, $61, $02, $20, $1c, $37, $00, $ff

; $520b
.TodoPtr5:
    db $03, $00, $1b, $34, $41, $ff

; $5211
.TodoPtr6:
    db $03, $01, $1c, $33, $21, $ff, $80, $00, $ff, $ff

; $521b
SongData::
    db $80, $05, $20, $03, $03, $07, $08, $03, $09, $0a, $17, $03, $0c, $07, $0d, $03
    db $0b, $14, $12, $0b, $0b, $03, $03, $0b, $0b, $03, $0c, $07, $16, $03, $08, $18
    db $03, $09, $09, $09, $09, $80, $02, $12, $80, $05, $0a, $0b, $03, $1e, $14, $12
    db $fd, $1e, $52, $80, $ed, $0e, $0f, $1a, $fe, $80, $05, $00, $00, $04, $15, $1b
    db $1c, $fd, $58, $52, $80, $fb, $7f, $a1, $0e, $05, $a0, $02, $a1, $0e, $05, $a0
    db $01, $a1, $18, $05, $a0, $01, $01, $01, $05, $05, $05, $05, $05, $05, $a1, $06
    db $05, $a0, $01, $a1, $0a, $05, $a0, $02, $fd, $62, $52, $11, $a1, $07, $06, $a0
    db $13, $a1, $07, $06, $a0, $1f, $a1, $0c, $06, $a0, $19, $06, $06, $06, $06, $06
    db $1f, $06, $06, $06, $06, $06, $13, $fd, $87, $52, $80, $fc, $24, $fe, $80, $fc
    db $a1, $0b, $27, $a0, $1d, $10, $1d, $10, $27, $fe, $80, $fc, $23, $fe, $80, $00
    db $01, $fe, $22, $fe, $80, $f8, $2a, $a1, $08, $2b, $a0, $80, $fd, $2b, $2b, $2b
    db $2b, $80, $fb, $2b, $2b, $2b, $2b, $80, $f9, $2b, $2b, $2b, $2b, $80, $f9, $2b
    db $2b, $80, $f8, $2c, $2c, $80, $f9, $2c, $2c, $80, $f8, $a1, $08, $2b, $a0, $fe
    db $80, $04, $25, $fe, $80, $f8, $a1, $08, $26, $a0, $80, $fd, $26, $26, $26, $26
    db $80, $fb, $26, $26, $26, $26, $80, $f9, $26, $26, $26, $26, $80, $f9, $26, $26
    db $80, $f3, $26, $26, $80, $f4, $26, $26, $80, $f8, $a1, $08, $26, $a0, $fe, $80
    db $00, $28, $fe, $29, $fe, $80, $f4, $a1, $07, $2d, $a0, $2e, $a1, $02, $2f, $2f
    db $2f, $2f, $30, $30, $30, $30, $a0, $31, $31, $31, $32, $fe, $80, $f4, $33, $34
    db $33, $37, $38, $38, $39, $39, $38, $38, $39, $3a, $3b, $fe, $80, $00, $3e, $fe
    db $80, $00, $3c, $fe, $3d, $3d, $3d, $3f, $a1, $08, $3d, $a0, $3d, $3f, $fe, $80
    db $f8, $44, $44, $80, $f8, $45, $47, $80, $f8, $44, $44, $80, $fa, $45, $45, $80
    db $f8, $44, $46, $80, $f8, $45, $47, $80, $f8, $44, $80, $fa, $45, $80, $f8, $44
    db $44, $fe, $80, $ec, $43, $fe, $80, $f8, $42, $42, $80, $fd, $42, $42, $80, $f8
    db $42, $42, $80, $ff, $42, $42, $80, $f8, $42, $42, $80, $fd, $42, $42, $80, $f8
    db $42, $80, $ff, $42, $80, $f8, $42, $42, $fe, $80, $fe, $40, $fe, $41, $41, $41
    db $48, $41, $48, $41, $41, $fe, $80, $fd, $52, $53, $52, $53, $56, $57, $52, $53
    db $80, $ff, $56, $80, $fd, $57, $52, $59, $fe, $80, $fd, $50, $51, $50, $51, $54
    db $55, $50, $51, $80, $ff, $54, $80, $fd, $55, $50, $58, $fe, $80, $fd, $4b, $4b
    db $80, $02, $4b, $80, $fd, $4b, $80, $04, $4c, $80, $fd, $4d, $fe, $80, $fc, $49
    db $fe, $4a, $4a, $4a, $4e, $4a, $4a, $4a, $4a, $4f, $4a, $4e, $fe, $80, $f3, $5f
    db $60, $5f, $80, $ee, $60, $5f, $60, $5f, $80, $f3, $60, $fe, $80, $ff, $5b, $5b
    db $5b, $5c, $5c, $5c, $5c, $5b, $fe, $80, $ff, $5a, $5a, $5a, $80, $fa, $5a, $5a
    db $5a, $5a, $80, $ff, $5a, $fe, $80, $02, $5d, $fe, $5e, $5e, $5e, $61, $5e, $5e
    db $5e, $5e, $5e, $61, $5e, $5e, $5e, $5e, $61, $61, $fe, $80, $03, $62, $ff, $80
    db $27, $62, $ff, $80, $03, $63, $ff, $80, $00, $01, $ff, $64, $ff, $80, $f3, $5f
    db $60, $5f, $60, $69, $70, $fe, $80, $ff, $65, $65, $65, $65, $65, $65, $65, $5c
    db $5c, $5c, $5c, $65, $65, $65, $65, $5c, $5c, $5c, $5c, $66, $80, $ff, $6a, $6a
    db $6b, $6b, $6c, $80, $fd, $6b, $80, $ff, $6a, $80, $fd, $6b, $80, $ff, $6a, $6a
    db $6b, $6b, $6c, $80, $fd, $6b, $80, $ff, $6a, $6a, $fe, $80, $ff, $5a, $5a, $5a
    db $5a, $5a, $5a, $5a, $80, $fa, $5a, $5a, $5a, $5a, $80, $ff, $5a, $5a, $5a, $5a
    db $80, $fa, $5a, $5a, $5a, $5a, $80, $ff, $67, $80, $02, $5a, $5a, $80, $ff, $5a
    db $5a, $80, $f8, $5a, $80, $fd, $5a, $80, $ff, $6e, $80, $02, $5a, $5a, $80, $ff
    db $5a, $5a, $80, $f8, $5a, $80, $fd, $5a, $80, $02, $5a, $5a, $fe, $80, $01, $5d
    db $fe, $a1, $07, $5e, $a0, $61, $a1, $0f, $5e, $a0, $61, $a1, $07, $5e, $a0, $61
    db $a1, $06, $5e, $a0, $68, $a1, $0f, $6d, $a0, $6f, $a1, $0f, $6d, $a0, $61, $fe
    db $80, $f8, $7a, $fe, $80, $04, $76, $76, $77, $77, $78, $78, $79, $79, $fe, $80
    db $04, $71, $71, $73, $73, $74, $74, $75, $75, $fe, $80, $01, $7b, $fe, $72, $fe
    db $80, $f7, $7d, $01, $ff, $80, $03, $03, $0b, $14, $12, $ff, $80, $03, $7c, $ff
    db $80, $fc, $05, $05, $05, $05, $02, $01, $ff, $06, $06, $13, $1f, $ff, $80, $04
    db $35, $ff, $80, $04, $36, $ff, $80, $04, $7e, $ff, $80, $00, $01, $ff, $1f, $02
    db $02, $02, $ff, $80, $00, $01, $ff, $ff

; $5543: Each row related to one song. Copied to SongDataRam.
TODOData5543::
    dw SongData, $524e, $5254, $525f, $5286
    dw $52a5, $52a9, $52b5, $52b9, $52bd
    dw $52bf, $52eb, $52ef, $531a, $531e
    dw $5320, $5337, $5347, $534b, $534f
    dw $535a, $537d, $5381, $53a4, $53a8
    dw $53b1, $53c4, $53d7, $53e8, $53ec
    dw $53f8, $5407, $5412, $5421, $5425
    dw $5436, $543a, $543e, $5442, $5446
    dw $5448, $5451, $5486, $54c8, $54cc
    dw $54eb, $54ef, $54fa, $5505, $5509

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
    ld d, l
    add hl, sp
    ld d, l
    ld a, $55
    ld a, $55
    ld a, $55
    ld a, $55
    ld b, d
    ld d, l

TODOData55c5::
    db $a0, $a7, $00, $b0, $2d, $ff, $a0, $80, $3c, $00, $ff, $a0, $b0, $2d, $a1, $0f
    db $83, $34, $82, $37, $34, $37, $34, $37, $34, $ff, $a0, $d0, $02, $50, $8f, $18
    db $8a, $18, $d0, $0d, $50, $85, $18, $d0, $02, $50, $8a, $18, $d0, $0d, $50, $85
    db $18, $d0, $02, $50, $8f, $18, $ff, $a0, $a7, $10, $a1, $03, $0f, $04, $9e, $0c
    db $13, $0c, $0c, $11, $0c, $12, $12, $0c, $0c, $09, $09, $0e, $0e, $07, $b0, $1e
    db $0c, $13, $0c, $0c, $11, $0c, $12, $12, $0c, $09, $0e, $13, $0c, $a1, $03, $0c
    db $03, $8f, $11, $11, $a1, $03, $0f, $03, $80, $3c, $0c, $ff, $a0, $a1, $0f, $a2
    db $00, $8a, $3b, $85, $3b, $8a, $3b, $85, $3b, $ff, $8f, $01, $03, $01, $03, $ff
    db $a0, $d0, $18, $50, $8f, $18, $8a, $18, $d0, $23, $50, $85, $18, $d0, $18, $50
    db $8a, $18, $d0, $23, $50, $85, $18, $d0, $18, $50, $8f, $18, $ff, $a0, $d0, $2e
    db $50, $8f, $18, $8a, $18, $d0, $39, $50, $85, $18, $d0, $2e, $50, $8a, $18, $d0
    db $39, $50, $85, $18, $d0, $2e, $50, $8a, $18, $d0, $39, $50, $85, $18, $ff, $d0
    db $44, $50, $8f, $19, $8a, $19, $d0, $4f, $50, $85, $19, $d0, $44, $50, $8a, $19
    db $d0, $4f, $50, $85, $19, $d0, $44, $50, $8f, $19, $ff, $d0, $5a, $50, $8f, $1a
    db $8a, $1a, $d0, $65, $50, $85, $1a, $d0, $5a, $50, $8a, $1a, $d0, $65, $50, $85
    db $1a, $d0, $5a, $50, $8f, $1a, $ff, $d0, $44, $50, $8f, $17, $8a, $17, $d0, $4f
    db $50, $85, $17, $d0, $44, $50, $8a, $17, $d0, $4f, $50, $85, $17, $d0, $44, $50
    db $8a, $17, $d0, $4f, $50, $85, $17, $ff, $d0, $70, $50, $8f, $18, $8a, $18, $d0
    db $7b, $50, $85, $18, $d0, $70, $50, $8a, $18, $d0, $7b, $50, $85, $18, $d0, $70
    db $50, $8a, $18, $85, $d0, $7b, $50, $18, $ff, $d0, $86, $50, $8f, $18, $8a, $18
    db $d0, $91, $50, $85, $18, $d0, $86, $50, $8a, $18, $d0, $91, $50, $85, $18, $d0
    db $86, $50, $8f, $18, $ff, $a0, $a1, $14, $a2, $01, $02, $01, $a3, $00, $83, $00
    db $a6, $23, $0c, $81, $8f, $1f, $21, $9e, $24, $ff, $83, $27, $9b, $28, $8f, $27
    db $28, $88, $26, $96, $24, $8f, $24, $26, $24, $26, $24, $82, $25, $c0, $8d, $26
    db $c1, $88, $24, $80, $20, $21, $86, $21, $8a, $24, $8d, $1f, $96, $24, $8f, $28
    db $82, $2c, $c0, $2c, $8b, $2d, $c1, $8f, $2b, $29, $89, $28, $80, $4a, $26, $96
    db $2b, $82, $2c, $c0, $8d, $2d, $c1, $9e, $2b, $82, $2c, $c0, $9c, $2d, $c1, $8f
    db $2b, $2d, $88, $2b, $96, $28, $8f, $24, $26, $24, $26, $24, $82, $2c, $c0, $8d
    db $2d, $c1, $88, $24, $96, $24, $8f, $26, $82, $26, $c0, $27, $91, $28, $c1, $89
    db $2b, $8f, $28, $2b, $28, $87, $24, $96, $21, $8f, $1f, $80, $3c, $24, $ff, $a0
    db $d0, $0b, $51, $8e, $26, $22, $1d, $22, $80, $2a, $22, $87, $1d, $22, $8e, $26
    db $22, $21, $1f, $80, $2a, $1d, $87, $1d, $21, $8e, $24, $1d, $1d, $87, $1d, $21
    db $8e, $24, $1d, $1d, $87, $21, $24, $8e, $29, $27, $1f, $21, $80, $e0, $22, $ff
    db $9e, $00, $8f, $03, $81, $00, $ff, $a0, $d0, $02, $50, $80, $3c, $18, $ff, $80
    db $2d, $01, $8f, $03, $ff, $d0, $02, $50, $8f, $18, $8a, $18, $d0, $0d, $50, $85
    db $18, $d0, $18, $50, $8a, $18, $d0, $23, $50, $85, $18, $d0, $18, $50, $8f, $18
    db $ff, $d0, $44, $50, $8a, $17, $d0, $4f, $50, $85, $17, $d0, $44, $50, $8f, $17
    db $ff, $a0, $a7, $10, $a1, $03, $0f, $03, $9e, $07, $13, $0e, $13, $0c, $13, $0c
    db $8f, $a1, $03, $0c, $03, $0c, $09, $a1, $03, $0f, $03, $9e, $07, $13, $0e, $13
    db $0c, $07, $a1, $03, $0c, $03, $8f, $0c, $0a, $09, $07, $a1, $03, $0f, $03, $9e
    db $11, $0c, $11, $11, $0c, $13, $0e, $0e, $80, $3c, $09, $09, $0e, $a1, $03, $0c
    db $03, $8f, $0e, $0e, $13, $13, $ff, $d0, $9c, $50, $8f, $18, $8a, $18, $d0, $a7
    db $50, $85, $18, $d0, $9c, $50, $8a, $18, $d0, $a7, $50, $85, $18, $d0, $9c, $50
    db $8a, $18, $d0, $a7, $50, $85, $18, $ff, $d0, $44, $50, $80, $3c, $17, $ff, $80
    db $3c, $d0, $b2, $50, $18, $18, $d0, $5a, $50, $1a, $8f, $d0, $2e, $50, $18, $8a
    db $18, $d0, $39, $50, $85, $18, $8a, $d0, $44, $50, $17, $85, $d0, $4f, $50, $17
    db $d0, $44, $50, $8f, $17, $ff, $80, $2d, $03, $8f, $01, $80, $3c, $03, $80, $35
    db $03, $87, $04, $8f, $01, $03, $01, $03, $ff, $a0, $b0, $0f, $a1, $14, $a2, $01
    db $02, $01, $a3, $00, $83, $00, $a6, $23, $0c, $81, $88, $24, $8f, $24, $87, $23
    db $8f, $21, $9e, $1f, $80, $2d, $26, $88, $26, $8f, $26, $87, $24, $8f, $26, $82
    db $27, $c0, $80, $49, $28, $c1, $88, $24, $8f, $24, $88, $23, $8f, $21, $9e, $1f
    db $80, $2d, $26, $8f, $26, $24, $26, $80, $4b, $28, $8f, $28, $29, $2b, $2d, $9e
    db $2d, $88, $29, $96, $28, $8f, $26, $28, $29, $2b, $2b, $2b, $88, $28, $80, $3c
    db $26, $87, $21, $8f, $28, $21, $8a, $21, $85, $21, $8f, $21, $28, $21, $21, $21
    db $8a, $29, $85, $29, $a1, $19, $9e, $29, $a1, $14, $8a, $28, $85, $28, $8f, $26
    db $87, $24, $8f, $23, $85, $23, $a1, $19, $91, $21, $b0, $69, $a0, $a1, $05, $a2
    db $00, $01, $01, $a3, $05, $83, $00, $a6, $22, $08, $81, $8a, $3b, $85, $39, $a1
    db $05, $8f, $3b, $8a, $3b, $85, $39, $8a, $3b, $8f, $39, $9e, $34, $85, $37, $8a
    db $36, $85, $35, $8f, $34, $39, $8a, $39, $85, $37, $8a, $39, $94, $37, $8f, $34
    db $a0, $a1, $14, $a2, $01, $02, $01, $a3, $01, $83, $00, $a6, $23, $0c, $81, $28
    db $29, $2b, $a1, $14, $88, $2d, $89, $2d, $a1, $14, $9c, $2d, $8f, $29, $85, $28
    db $c0, $29, $28, $c1, $8f, $26, $24, $87, $23, $80, $53, $24, $8f, $23, $21, $87
    db $23, $80, $44, $24, $b0, $0f, $ff, $a0, $a7, $10, $a1, $03, $0f, $03, $9e, $0c
    db $10, $09, $10, $15, $10, $09, $10, $15, $10, $b0, $3c, $ff, $a0, $a7, $10, $a1
    db $03, $0f, $03, $9e, $0e, $0e, $13, $13, $0c, $15, $0e, $13, $0c, $a1, $03, $0c
    db $03, $8f, $11, $11, $a1, $03, $0f, $03, $80, $3c, $0c, $ff, $a0, $b0, $2a, $d0
    db $0b, $51, $87, $26, $25, $ff, $d0, $5a, $50, $8f, $1a, $8a, $1a, $d0, $65, $50
    db $85, $1a, $d0, $44, $50, $8a, $17, $d0, $4f, $50, $85, $17, $d0, $44, $50, $8a
    db $17, $d0, $4f, $50, $85, $17, $ff, $80, $3c, $01, $ff, $a0, $b0, $2d, $ff, $9c
    db $01, $01, $87, $01, $00, $03, $03, $01, $00, $03, $00, $ff, $8e, $01, $03, $01
    db $87, $03, $03, $01, $00, $03, $03, $01, $00, $03, $00, $ff, $a0, $a7, $20, $a1
    db $03, $0f, $04, $9c, $16, $11, $16, $11, $16, $11, $11, $0c, $11, $13, $14, $15
    db $11, $0c, $16, $11, $16, $15, $13, $11, $16, $15, $13, $11, $ff, $a0, $b0, $0e
    db $d0, $44, $50, $9c, $1a, $1a, $87, $1a, $1a, $8e, $1a, $1a, $b0, $0e, $d0, $44
    db $50, $9c, $1a, $1a, $d0, $18, $50, $18, $18, $d0, $18, $50, $18, $18, $87, $18
    db $18, $8e, $18, $18, $b0, $0e, $d0, $18, $50, $9c, $18, $18, $d0, $44, $50, $1a
    db $1a, $d0, $44, $50, $1a, $1a, $87, $1a, $1a, $8e, $1a, $1a, $b0, $0e, $d0, $44
    db $50, $9c, $1a, $1a, $1a, $8e, $1a, $ff, $d0, $bd, $50, $80, $40, $17, $13, $0f
    db $90, $10, $15, $19, $1e, $80, $30, $1f, $90, $1e, $80, $30, $1c, $90, $16, $80
    db $60, $17, $88, $10, $c0, $12, $13, $17, $80, $30, $18, $c1, $90, $17, $80, $30
    db $17, $90, $15, $80, $60, $10, $88, $10, $c0, $13, $16, $1c, $80, $28, $1a, $c1
    db $88, $19, $c0, $18, $17, $80, $28, $16, $c1, $88, $15, $c0, $14, $13, $90, $12
    db $c1, $15, $80, $40, $10, $88, $10, $13, $16, $1a, $80, $28, $18, $88, $17, $16
    db $15, $80, $28, $14, $88, $13, $12, $11, $90, $10, $13, $80, $60, $0e, $80, $20
    db $0e, $80, $40, $18, $80, $20, $17, $0f, $80, $40, $18, $80, $20, $17, $10, $80
    db $40, $18, $80, $20, $17, $88, $10, $12, $10, $12, $80, $40, $1b, $98, $1c, $c0
    db $84, $1a, $18, $80, $60, $17, $c1, $98, $13, $84, $c0, $12, $11, $80, $fe, $10
    db $c1, $b0, $02, $ff, $a0, $a7, $10, $a1, $03, $0c, $05, $90, $10, $17, $b0, $10
    db $17, $ff, $a0, $b0, $38, $ff, $a0, $a1, $0f, $90, $3b, $ff, $80, $40, $01, $ff
    db $a0, $ff, $90, $b0, $20, $d0, $d1, $50, $1c, $1c, $ff, $90, $b0, $20, $a4, $3a
    db $3e, $01, $23, $23, $ff, $d0, $dd, $50, $87, $a1, $05, $13, $a1, $0a, $1d, $a1
    db $05, $1f, $a1, $0a, $13, $a1, $05, $1a, $a1, $0a, $1f, $a1, $05, $1d, $a1, $0a
    db $1a, $ff, $87, $a1, $05, $1a, $a1, $0a, $15, $a1, $05, $18, $a1, $0a, $1a, $a1
    db $05, $16, $a1, $0a, $18, $a1, $05, $15, $a1, $0a, $16, $ff, $87, $a1, $05, $16
    db $a1, $0a, $19, $a1, $05, $1d, $a1, $0a, $16, $a1, $05, $18, $a1, $0a, $1d, $a1
    db $05, $19, $a1, $0a, $18, $ff, $87, $a1, $05, $15, $a1, $0a, $1d, $a1, $05, $21
    db $a1, $0a, $15, $a1, $05, $1c, $a1, $0a, $21, $a1, $05, $1d, $a1, $0a, $1c, $ff
    db $87, $a1, $05, $1a, $a1, $0a, $22, $a1, $05, $26, $a1, $0a, $1a, $a1, $05, $21
    db $a1, $0a, $26, $a1, $05, $22, $a1, $0a, $21, $ff, $87, $a1, $05, $1a, $a1, $0a
    db $15, $a1, $05, $18, $a1, $0a, $1a, $a1, $05, $16, $a1, $0a, $18, $a1, $05, $15
    db $a1, $0a, $16, $ff, $a0, $b0, $0e, $d0, $dd, $50, $a1, $23, $87, $26, $27, $8e
    db $26, $87, $2b, $2c, $8e, $2b, $87, $2d, $2e, $8e, $2d, $30, $ff, $b0, $0e, $87
    db $26, $27, $8e, $26, $87, $2d, $2e, $8e, $2d, $87, $26, $27, $9c, $26, $ff, $a0
    db $a1, $28, $a2, $02, $03, $01, $a3, $02, $03, $00, $a6, $13, $0c, $81, $84, $2b
    db $2d, $c0, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d
    db $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d
    db $2b, $2d, $c1, $ff, $a0, $a1, $28, $a2, $02, $03, $01, $a3, $02, $03, $00, $a6
    db $13, $0c, $81, $80, $80, $25, $ff, $b0, $0e, $87, $26, $27, $8e, $26, $27, $29
    db $2b, $2d, $2e, $ff, $b0, $0e, $87, $2e, $2d, $8e, $2e, $87, $29, $27, $8e, $29
    db $87, $25, $24, $8e, $25, $29, $ff, $b0, $0e, $87, $28, $26, $8e, $28, $87, $2d
    db $2b, $8e, $2d, $87, $31, $2f, $9c, $31, $ff, $b0, $0e, $87, $28, $26, $8e, $28
    db $87, $2d, $2b, $8e, $2d, $87, $31, $2f, $8e, $31, $34, $ff, $b0, $0e, $87, $32
    db $31, $8e, $32, $87, $2e, $2d, $8e, $2e, $87, $2d, $2b, $80, $2a, $2d, $87, $32
    db $31, $8e, $32, $87, $2e, $2d, $8e, $26, $28, $29, $2d, $ff, $a0, $a1, $0f, $a2
    db $00, $87, $3b, $ff, $9c, $01, $01, $01, $01, $ff, $a0, $a1, $03, $13, $02, $a7
    db $10, $9c, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e
    db $8e, $0e, $0c, $0a, $09, $9c, $0a, $11, $0a, $11, $0a, $11, $0a, $11, $09, $10
    db $09, $10, $09, $10, $09, $10, $0a, $11, $0a, $11, $0a, $11, $0a, $11, $09, $10
    db $09, $10, $09, $10, $09, $10, $0e, $15, $0e, $15, $0e, $15, $8e, $0e, $0e, $10
    db $11, $ff, $9c, $01, $01, $01, $8e, $01, $01, $ff, $a0, $a1, $0f, $90, $3b, $88
    db $3b, $ff, $80, $30, $01, $02, $ff, $a0, $a1, $03, $0f, $05, $a7, $10, $80, $28
    db $13, $98, $13, $88, $0e, $98, $10, $ff, $a0, $b0, $17, $a1, $14, $a2, $01, $02
    db $01, $a3, $02, $03, $00, $a6, $23, $0c, $81, $82, $2e, $8d, $2f, $80, $31, $2f
    db $88, $32, $82, $2e, $c0, $96, $2d, $c1, $8f, $2b, $80, $4a, $2b, $98, $2d, $87
    db $2b, $97, $2d, $90, $2b, $82, $2d, $c0, $97, $2e, $c1, $2b, $98, $2b, $88, $2d
    db $80, $33, $2b, $8f, $28, $87, $26, $91, $28, $98, $2b, $82, $2d, $c0, $2e, $94
    db $2f, $c1, $96, $32, $9a, $32, $89, $34, $8e, $32, $80, $a9, $32, $88, $32, $90
    db $34, $80, $20, $32, $90, $34, $88, $32, $90, $34, $98, $32, $96, $37, $82, $2d
    db $88, $2e, $90, $2d, $80, $50, $2b, $90, $34, $88, $32, $90, $34, $98, $32, $30
    db $81, $2d, $87, $2e, $90, $2d, $80, $20, $2b, $90, $2d, $98, $2b, $88, $2e, $90
    db $2f, $88, $2b, $90, $2e, $98, $2f, $88, $2e, $90, $2d, $88, $2b, $90, $28, $98
    db $26, $88, $28, $90, $26, $80, $c8, $2b, $ff, $d0, $c9, $50, $90, $13, $88, $1a
    db $d0, $02, $50, $90, $1f, $80, $20, $1f, $98, $1f, $ff, $d0, $c9, $50, $90, $13
    db $88, $18, $d0, $18, $50, $90, $1f, $80, $20, $1f, $98, $1f, $ff, $d0, $c9, $50
    db $90, $13, $88, $1a, $d0, $2e, $50, $90, $1d, $80, $20, $1d, $98, $1d, $ff, $d0
    db $c9, $50, $90, $13, $88, $16, $d0, $86, $50, $90, $1f, $80, $20, $1f, $98, $1f
    db $ff, $80, $30, $01, $80, $28, $02, $88, $01, $ff, $a0, $a1, $0f, $86, $39, $3b
    db $39, $39, $3b, $39, $ff, $92, $01, $02, $01, $02, $ff, $a0, $a1, $03, $12, $05
    db $a7, $10, $8c, $0c, $86, $0c, $92, $10, $8c, $13, $86, $13, $8c, $15, $92, $0c
    db $86, $0c, $92, $10, $8c, $13, $86, $13, $92, $15, $ff, $8c, $0c, $86, $0c, $92
    db $10, $8c, $13, $86, $0c, $8c, $0b, $92, $0a, $86, $0a, $92, $0e, $8c, $11, $86
    db $11, $92, $13, $ff, $8c, $0c, $86, $0c, $92, $10, $8c, $13, $86, $13, $8c, $15
    db $92, $0c, $86, $11, $8c, $12, $92, $13, $86, $13, $92, $13, $ff, $92, $01, $02
    db $86, $01, $00, $01, $02, $03, $01, $ff, $92, $01, $02, $86, $01, $00, $02, $01
    db $00, $02, $92, $01, $02, $01, $02, $ff, $d0, $dd, $50, $a1, $23, $8c, $1c, $86
    db $1c, $8c, $24, $86, $1c, $8c, $23, $86, $24, $8c, $1c, $86, $1c, $ff, $8c, $24
    db $86, $1c, $8c, $23, $92, $24, $24, $86, $24, $ff, $d0, $dd, $50, $a1, $23, $8c
    db $1f, $86, $1f, $8c, $28, $86, $1f, $8c, $27, $86, $28, $8c, $1f, $86, $1f, $ff
    db $8c, $28, $86, $1f, $8c, $27, $92, $28, $28, $86, $28, $ff, $8c, $1d, $86, $1d
    db $8c, $21, $86, $1d, $8c, $20, $86, $21, $8c, $1d, $86, $1d, $ff, $8c, $21, $86
    db $1d, $8c, $20, $92, $21, $21, $86, $21, $ff, $8c, $18, $86, $18, $8c, $24, $86
    db $18, $8c, $23, $86, $24, $8c, $18, $86, $18, $ff, $8c, $24, $86, $18, $8c, $23
    db $92, $24, $24, $86, $24, $ff, $8c, $24, $86, $1c, $8c, $1f, $92, $1f, $1f, $86
    db $1f, $ff, $8c, $28, $86, $1f, $8c, $1b, $92, $1b, $1b, $86, $1b, $ff, $9e, $a0
    db $a1, $03, $0d, $05, $a7, $10, $18, $13, $ff, $a0, $b0, $0f, $8f, $d0, $e7, $50
    db $18, $b0, $0f, $18, $ff, $d0, $00, $50, $b0, $0f, $d0, $f3, $50, $8f, $13, $b0
    db $0f, $13, $ff, $a0, $a1, $0f, $8a, $39, $85, $39, $ff, $8f, $01, $01, $ff, $d0
    db $dd, $50, $a1, $23, $8f, $24, $24, $99, $1f, $ff, $8f, $24, $24, $85, $24, $8f
    db $1f, $1f, $ff, $85, $00, $00, $01, $00, $00, $01, $ff, $d0, $bd, $50, $a6, $00
    db $00, $81, $84, $18, $c0, $17, $15, $13, $c1, $1a, $c0, $18, $17, $15, $1c, $1a
    db $18, $17, $1d, $1c, $1a, $18, $1f, $1d, $1c, $1a, $c1, $23, $c0, $21, $1f, $1d
    db $88, $18, $c1, $a0, $81, $18, $ff, $a0, $b0, $60, $a1, $03, $04, $04, $a7, $10
    db $98, $0c, $ff, $80, $60, $00, $88, $01, $ff, $d0, $00, $50, $b0, $0f, $8f, $d0
    db $9c, $50, $13, $b0, $0f, $13, $ff, $8f, $d0, $9c, $50, $13, $b0, $0f, $d0, $18
    db $50, $9e, $11, $ff

    sbc [hl]
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
    jr z, @-$5c

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
    jr z, @+$2d

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

; $626e
TODOData626e::
    dw TODOData55c5, $55cb, $55d0, $55df, $55fc, $5631, $563f, $5645
    dw $5662, $5684, $56a0, $56bc, $56dd, $56fe, $571a, $572f
    dw $57a4, $57d5, $57dc, $57e4, $57ea, $5816, $585c, $587d
    dw $5884, $58ab, $58be, $59ac, $59c1, $59e1, $59eb, $5a0c
    dw $5a10, $5a14, $5a21, $5a31, $5a52, $5a9d, $5b39, $5b47
    dw $5b4b, $5b51, $5b55, $5b57, $5b60, $5b6a, $5b87, $5ba1
    dw $5bbb, $5bd5, $5bef, $5c09, $5c22, $5c34, $5c69, $5c7c
    dw $5c89, $5c9c, $5cae, $5cc1, $5ce1, $5ce9, $5cef, $5d37
    dw $5d3f, $5d47, $5d4c, $5d5d, $5dfe, $5e10, $5e22, $5e34
    dw $5e46, $5e4f, $5e5a, $5e60, $5e80, $5e99, $5eb2, $5ebd
    dw $5ecd, $5ee3, $5eef, $5f05, $5f11, $5f22, $5f2e, $5f3f
    dw $5f4b, $5f57, $5f63, $5f6e, $5f7a, $5f88, $5f90, $5f94
    dw $5f9f, $5fa8, $5fb0, $5fdc, $5fe8, $5fee, $5ffc, $6009

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
    jr nz, $63b3

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

    ld hl, _AUD3WAVERAM
    ld c, 16

; $6373
.CopyLoop:
    ld a, [de]
    ld [hl+], a
    inc de
    dec c
    jr nz, .CopyLoop
    ret

; $637a
; [EventSoundNoteLength] = 0
; [$c5c4] = data0[N]
; [PlayingEventSound] = ?
; [TrackEnable] = read : return if bit 6 is set
; [ChannelEnable] = read :
; [FadeOutCounter] = read : return if non-zero
; offset = mod64(a) * 2
SetUpEventSound:
    ld hl, TrackEnable
    bit 6, [hl]                     ; Return if event sound track is not enabled.
    ret Z                           ; Return if bit 6 in [TrackEnable] is set.
    ld e, a                         ; e = [EventSound]
    ld a, [FadeOutCounter]
    and a
    ret nZ                          ; Return if [FadeOutCounter] is non-zero.
    ld a, e                         ; a = [EventSound]
    and 64 - 1                      ; a = mod64([EventSound])
    ld b, 0
    sla a                           ; a = a * 2
    ld c, a                         ; bc = a * 2
    ld hl, EventSoundProperties     ; Get some base address.
    add hl, bc                      ; Add some length.
    ld a, [$c5c4]
    cp [hl]                         ; [$c5c4] - [$67cf + offset]
    jr C, :+                        ; Jump if [data_ptr] value exceeds [$c5c4]
    ret nZ                          ; Return if [data_ptr] != [$c5c4]
    bit 6, e
    ret nZ                          ; Return if bit 6 is non zero
  : ldi a, [hl]                     ; Get data, data_ptr++
    ld [$c5c4], a                   ; [$c5c4] = data0[N]
    ld a, [hl]
    ld [EventSoundChannelsUsed], a
    ld hl, EventSoundDataPtrs
    add hl, bc                      ; Add same length.
    ldi a, [hl]                     ; Get data, data_ptr++
    ld [EventSoundDataPtrLsb], a    ; [EventSoundDataPtrLsb] = data1[N]
    ld a, [hl]
    ld [EventSoundDataPtrMsb], a    ; [EventSoundDataPtrMsb] = data1[N+1]
    ld a, e
    and 64 - 1                      ; Mod 64.
    ld [PlayingEventSound], a       ; = [EventSound]
    ld a, [ChannelEnable]
    and %11111
    ld a, 0
    ld [EventSoundNoteLength], a    ; = 0
    ret

; $63c1: Weird: Is this ever called?
ResetEventSound:
    ld a, $ff
    ld [PlayingEventSound], a       ; = $ff (no event sound playing)
    ld [EventSound], a              ; = $ff
    inc a
    ld [EventSoundNoteLength], a    ; = 0
    ld [EventSoundChannelsUsed], a  ; = 0
    ld [$c5c4], a                   ; = 0
    ret

; $63d4: Does all EventSound-related things.
HandleEventSound:
    ld a, [EventSound]
    bit 7, a
    call z, SetUpEventSound
    ld a, $ff
    ld [EventSound], a               ; = $ff
    ld a, [PlayingEventSound]
    cp $ff
    ret z                           ; Return if no event sound is playing.

; $63e7
.CheckLength:
    ld a, [EventSoundNoteLength]
    and a
    jr z, .NextRegisterLoad

; $63ed
.DecrementLength:
    dec a
    ld [EventSoundNoteLength], a    ; -= 1
    ret

; $63f2: Let's load the next setting into the sound registers.
.NextRegisterLoad:
    ld a, [EventSoundDataPtrLsb]
    ld l, a
    ld a, [EventSoundDataPtrMsb]
    ld h, a

; $63fa
.Loop:
    ld a, [hl+]
    and a
    jr nz, .CheckAction

; $63fe
.FinishedEventSound:
    ld a, $ff
    ld [PlayingEventSound], a     ; = $ff (finished playing the sound)
    xor a
    ld [$c5c4], a                 ; = 0
    ret

; $6408
.CheckAction:
    bit 7, a
    jr z, .LoadSoundRegister
    bit 5, a
    jr z, .End
    and %11111
    jr z, .CheckRepeat

.SetUpRepeat:
    ld [EventSoundRepeatCount], a
    ld a, l
    ld [EventSoundRepeatStartLsb], a
    ld a, h
    ld [EventSoundRepeatStartMsb], a
    jr .Loop

; $6421
.CheckRepeat:
    ld a, [EventSoundRepeatCount]
    and a
    jr z, .Loop
    dec a
    ld [EventSoundRepeatCount], a   ; -= 1
    ld a, [EventSoundRepeatStartLsb]
    ld l, a
    ld a, [EventSoundRepeatStartMsb]
    ld h, a
    jr .Loop

; $6435: Load sound register given in "c" with next value in data.
.LoadSoundRegister:
    ld c, a
    ld a, [hl+]
    ldh [c], a
    jr .Loop

; $643a
.End:
    ld a, [hl+]
    ld [EventSoundNoteLength], a
    ld a, l
    ld [EventSoundDataPtrLsb], a
    ld a, h
    ld [EventSoundDataPtrMsb], a
    ret

; How this following data works:
; If data byte is 0, then the event sound ended.
; If data byte is != 0 and if Bit 7 is zero, we have a register load.
; That means set the register of Byte 0 to the value of Byte 1.
; It data Byte0 is != 0 and if Bit 5 is zero, save Byte 1 in [EventSoundNoteLength] and return.

; $6447
EventSoundDataProjectileShot::
    db LOW(rNR12), $00
    db LOW(rNR42), $4a
    db LOW(rNR43), $80
    db LOW(rNR44), $80
    db $80, 2
    db LOW(rNR43), $70
    db $80, 0
    db LOW(rNR43), $60
    db $80, 0
    db LOW(rNR43), $50
    db $80, 0
    db LOW(rNR43), $40
    db $80, 0
    db LOW(rNR43), $30
    db $80, 0
    db LOW(rNR43), $20
    db $80, 0
    db LOW(rNR42), $00
    db $00                          ; 0 -> End of sound.

; $646c
EventSoundDataStone::
    db LOW(rNR12), $00
    db LOW(rNR42), $0a
    db LOW(rNR43), $60
    db LOW(rNR44), $80
    db $80, 3
    db LOW(rNR12), $a1
    db LOW(rNR42), $a1
    db LOW(rNR10), $3b
    db LOW(rNR11), $80
    db LOW(rNR43), $20
    db LOW(rNR44), $80
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db $80, 4
    db LOW(rNR12), $00
    db LOW(rNR42), $00
    db $00                          ; 0 -> End of sound.

; $648d
EventSoundDataJump::
    db LOW(rNR42), $00
    db LOW(rNR12), $80
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db $80, 2
    db LOW(rNR13), LOW(rNR42)
    db LOW(rNR14), $07
    db $80, $01
    db LOW(rNR13), $39
    db LOW(rNR14), $07
    db $80, $01
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR13), $6b
    db LOW(rNR14), $07
    db $80, $00
    db LOW(rNR13), $7b
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $64c8
EventSoundDataLand::
    db LOW(rNR12), $00
    db LOW(rNR42), $81
    db LOW(rNR43), $78
    db LOW(rNR44), $80
    db $80, 3
    db LOW(rNR42), $00
    db $00                           ; 0 -> End of sound.

; $64d5
EventSoundDataCatapult::
    db LOW(rNR12), $c3
    db LOW(rNR42), $a1
    db LOW(rNR10), $45
    db LOW(rNR11), $00
    db LOW(rNR43), $40
    db LOW(rNR44), $80
    db LOW(rNR13), $16
    db LOW(rNR14), $84
    db $80, $01
    db $aa                          ; Repeat start.
    db LOW(rNR43), $50
    db LOW(rNR13), $e5
    db LOW(rNR14), $04
    db $80, 1
    db LOW(rNR43), $40
    db LOW(rNR13), $0b
    db LOW(rNR14), $06
    db $80, 1
    db $a0                          ; Repeat end.
    db LOW(rNR12), $00
    db LOW(rNR42), $00
    db $00                          ; 0 -> End of sound.

; $64fe
EventSoundTeleportEnd::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $a4
    db LOW(rNR11), $80
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $06
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $652d
EventSoundTeleportStart::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $a4
    db LOW(rNR11), $80
    db LOW(rNR13), $39
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR13), $9d
    db LOW(rNR14), $07
    db $80, 3
    db LOW(rNR12), $00
    db $00                            ; 0 -> End of sound.

; $655c
EventSoundDataDamage::
    db LOW(rNR42), $00
    db LOW(rNR12), $a2
    db LOW(rNR10), $2a
    db LOW(rNR11), $80
    db LOW(rNR13), $0b
    db LOW(rNR14), $86
    db $80, 1
    db LOW(rNR11), $00
    db LOW(rNR12), $82
    db LOW(rNR10), $1f
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db $80, 8
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $6579
EventSoundDataDied::
    db LOW(rNR42), $00
    db LOW(rNR10), $45
    db LOW(rNR12), $a5
    db LOW(rNR11), $80
    db LOW(rNR13), $0b
    db LOW(rNR14), $86
    db $80, 8
    db LOW(rNR10), $00
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db $80, 0
    db LOW(rNR13), $f7
    db LOW(rNR14), $06
    db $80, 0
    db LOW(rNR13), $e7
    db LOW(rNR14), $06
    db $80, 1
    db LOW(rNR13), $d6
    db LOW(rNR14), $06
    db $80, 1
    db LOW(rNR13), $c4
    db LOW(rNR14), $06
    db $80, 1
    db LOW(rNR13), $b2
    db LOW(rNR14), $06
    db $80, 2
    db LOW(rNR13), $9e
    db LOW(rNR14), $06
    db $80, 2
    db LOW(rNR13), $89
    db LOW(rNR14), $06
    db $80, 2
    db LOW(rNR13), $72
    db LOW(rNR14), $06
    db $80, 3
    db LOW(rNR13), $5b
    db LOW(rNR14), $06
    db $80, 3
    db LOW(rNR13), $42
    db LOW(rNR14), $06
    db $80, 4
    db LOW(rNR13), $27,
    db LOW(rNR14), $06
    db $80, 5
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $65d4
EventSoundDataEnemyHit::
    db LOW(rNR42), $00
    db LOW(rNR12), $a2
    db LOW(rNR10), $3a
    db LOW(rNR11), $00
    db LOW(rNR13), $63
    db LOW(rNR14), $85
    db $80, 2
    db LOW(rNR13), $16
    db LOW(rNR14), $84
    db $80, 0
    db LOW(rNR10), $55
    db LOW(rNR13), $b2
    db LOW(rNR14), $86
    db $80, 4
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $65f3
EventSoundDataHopOnEnemy::
    db LOW(rNR42), $00
    db LOW(rNR12), $a8
    db LOW(rNR10), $3a
    db LOW(rNR11), $80
    db LOW(rNR13), $63
    db LOW(rNR14), $85
    db $80, 2
    db LOW(rNR11), $00
    db LOW(rNR10), $34
    db LOW(rNR13), $16
    db LOW(rNR14), $84
    db $80, 8
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $660e
EventSoundDataBall::
    db LOW(rNR42), $81
    db LOW(rNR12), $a2
    db LOW(rNR10), $3a
    db LOW(rNR11), $80
    db LOW(rNR13), $63
    db LOW(rNR14), $85
    db LOW(rNR43), $69
    db LOW(rNR44), $80
    db $80, 4
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $6623
EventSoundDataBossDefeated::
    db LOW(rNR42), $00
    db LOW(rNR12), $a0
    db LOW(rNR11), $80
    db LOW(rNR10), $3a
    db LOW(rNR13), $63
    db LOW(rNR14), $85
    db $80, $02
    db LOW(rNR11), $00
    db LOW(rNR10), $34
    db LOW(rNR13), $16
    db LOW(rNR14), $84
    db $80, 8
    db LOW(rNR10), $3c
    db $80, 8
    db LOW(rNR12), $87
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $c1
    db LOW(rNR14), $87
    db $aa                          ; Repeat start.
    db LOW(rNR13), $e1
    db LOW(rNR14), $07
    db $80, $00
    db LOW(rNR13), $be
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR13), $b6
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR13), $ac
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR13), $a2
    db LOW(rNR14), $07
    db $80, 1
    db $a0                          ; Repeat end.
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $666c
EventSoundDataItemCollected::
    db LOW(rNR42), $00
    db LOW(rNR12), $81
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $668f
EventSoundDataLevelComplete::
    db LOW(rNR42), $00
    db LOW(rNR12), $86
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db $80, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db $80, 3
    db $a8                          ; Repeat start.
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db $80, 1
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db $80, 1
    db $a0                          ; Repeat end.
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $66c0
EventSoundDataLevelExplosion::
    db LOW(rNR12), $00
    db LOW(rNR42), $f4
    db LOW(rNR43), $79
    db LOW(rNR44), $80
    db $80, 1
    db $b0                          ; Repeat start.
    db LOW(rNR43), $7f
    db $80, 1
    db LOW(rNR43), $6d
    db $80, 0
    db LOW(rNR43), $73
    db $80, 1
    db $a0                          ; Repeat end.
    db LOW(rNR42), $00
    db $00                          ; 0 -> End of sound.

; $66db
EventSoundDataBrake::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $66
    db LOW(rNR11), $80
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db $a8
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db $80, 0
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db $80, 0
    db $a0
    db LOW(rNR12), $00
    db $00                          ; 0 -> End of sound.

; $66f8
EventSoundDataSnakeShot::
    db LOW(rNR12), $00
    db LOW(rNR42), $a2
    db LOW(rNR43), $71
    db LOW(rNR44), $80
    db $80, 0
    db LOW(rNR43), $31
    db $80, 0
    db LOW(rNR43), $51
    db $80, 0
    db LOW(rNR43), $71
    db $80, $00
    db $aa                          ; Repeat start.
    db LOW(rNR43), $11
    db $80, $01
    db LOW(rNR43), $31
    db $80, $01
    db $a0                          ; Repeat end.
    db LOW(rNR42), $00
    db $00                          ; 0 -> End of sound.

; $671b:
EventSoundDataElephantShot::
    db LOW(rNR12), $00
    db LOW(rNR42), $60
    db LOW(rNR43), $71
    db LOW(rNR44), $80
    db $80, 3
    db LOW(rNR43), $61
    db $80, 1
    db LOW(rNR43), $51
    db $80, 1
    db LOW(rNR43), $41
    db $80, 1
    db LOW(rNR43), $31
    db $80, 1
    db LOW(rNR43), $21
    db $80, 4
    db LOW(rNR43), $31
    db $80, 1
    db LOW(rNR43), $41
    db $80, 2
    db LOW(rNR43), $51
    db $80, 3
    db LOW(rNR43), $61
    db $80, 4
    db LOW(rNR43), $71
    db $80, 8
    db LOW(rNR42), $00
    db $00

; $6750
EventSoundDataCrocJaw::
    db LOW(rNR12), $00
    db LOW(rNR42), $91
    db LOW(rNR43), $69
    db LOW(rNR44), $80
    db $80, 1
    db LOW(rNR43), $41
    db $80, 6
    db LOW(rNR42), $00
    db $00

; $6761: Mysterious event sound that is never used! Sounds like receiving damage or so.
; Set [EventSound] to EVENT_SOUND_UNKNOWN to get an audial impression.
EventSoundDataUnknown::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $a5
    db LOW(rNR11), $40
    db LOW(rNR13), $07
    db LOW(rNR14), $81
    db $a8                          ; Start repeat.
    db LOW(rNR13), $07
    db LOW(rNR14), $01
    db $80, $00
    db LOW(rNR13), $9b
    db LOW(rNR14), $03
    db $80, $01
    db $a0                          ; End repeat.
    db LOW(rNR12), $00
    db $00

; $677e
EventSoundDataOutOfTime::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $81
    db LOW(rNR11), $80
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db $80, 2
    db LOW(rNR13), $c1
    db LOW(rNR14), $87
    db $80, 6
    db LOW(rNR12), $42
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db $80, 1
    db LOW(rNR13), $c1
    db LOW(rNR14), $87
    db $80, 6
    db LOW(rNR12), $00
    db $00

; $67a3
EventSoundDataPtrs::
    dw EventSoundDataProjectileShot
    dw EventSoundDataStone
    dw EventSoundDataJump
    dw EventSoundDataLand
    dw EventSoundDataCatapult
    dw EventSoundTeleportEnd
    dw EventSoundTeleportStart
    dw EventSoundDataDamage
    dw EventSoundDataDied
    dw EventSoundDataEnemyHit
    dw EventSoundDataHopOnEnemy
    dw EventSoundDataBall
    dw EventSoundDataBossDefeated
    dw EventSoundDataItemCollected
    dw EventSoundDataLevelComplete
    dw EventSoundDataLevelExplosion
    dw EventSoundDataBrake
    dw EventSoundDataSnakeShot
    dw EventSoundDataElephantShot
    dw EventSoundDataCrocJaw
    dw EventSoundDataUnknown
    dw EventSoundDataOutOfTime

; $67cf: Tuple: ???, channels used by the event sound.
EventSoundProperties::
    db $07, $08                     ; EVENT_SOUND_PROJECTILE
    db $07, $09                     ; EVENT_SOUND_STONE
    db $04, $01                     ; EVENT_SOUND_JUMP
    db $01, $08                     ; EVENT_SOUND_LAND
    db $04, $09                     ; EVENT_SOUND_CATAPULT
    db $06, $01                     ; EVENT_SOUND_TELEPORT_END
    db $06, $01                     ; EVENT_SOUND_TELEPORT_START
    db $08, $01                     ; EVENT_SOUND_DAMAGE_RECEIVED
    db $0f, $01                     ; EVENT_SOUND_DIED
    db $02, $01                     ; EVENT_ENEMY_HIT
    db $02, $01                     ; EVENT_SOUND_HOP_ON_ENEMY
    db $03, $09                     ; EVENT_SOUND_BALL
    db $0e, $01                     ; EVENT_SOUND_BOSS_DEFEATED
    db $0d, $01                     ; EVENT_SOUND_ITEM_COLLECTED
    db $0e, $01                     ; EVENT_SOUND_LVL_COMPLETE
    db $08, $08                     ; EVENT_SOUND_EXPLOSION
    db $02, $01                     ; EVENT_SOUND_BRAKE
    db $02, $08                     ; EVENT_SOUND_SNAKE_SHOT
    db $02, $08                     ; EVENT_SOUND_ELEPHANT_SHOT
    db $02, $08                     ; EVENT_SOUND_CROC_JAW
    db $06, $01                     ; EVENT_SOUND_UNKNOWN
    db $01, $01                     ; EVENT_SOUND_OUT_OF_TIME

; Unsused data.
db $00, $00, $00, $00, $00

; $6800
PlayerDirectionChange::
    ld a, [WalkingState]
    inc a
    ret nz                          ; Return if [WalkingState] is $ff.
    ld a, [FacingDirection3]
    and BIT_LEFT
    ld c, a                         ; "c" will be non-zero, if player faces to the left.
    ld a, [JoyPadData]
    and BIT_LEFT
    xor c
    ret z                           ; Return if facing direction and d-pad press are the same. Else, there is change of direction.

.ChangesDirection:
    ld a, $0f
    ld [XAcceleration], a           ; = $0f -> lets player brake
    xor a
    ld [WalkingState], a            ; = 0
    ld [JumpStyle], a               ; = 0
    ret

; $681f : Increments pause timer. Every 16 calls, ColorToggle is toggled.
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

; $6833: Sets up screen scrolls, number of lives, timer counter, and a few other things.
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
    ld a, 12
    ld [FadeOutCounterResetVal], a  ; = 12
    ld a, %11000000
    ld [TrackEnable], a         ; = $c0
    ld a, 160
    ld [TimeCounter], a         ; = 160
    ld a, NUM_LIVES
    ld [CurrentLives], a
    ld a, NUM_CONTINUES_NORMAL
    ld [NumContinuesLeft], a
    ret

; $685f: TODO
; Stores value from [LevelSongs + current level] into CurrentSong2
; Stores $4c into CurrentSong.
FadeOutSong::
    ld hl, LevelSongs
    ld a, [CurrentLevel]
    add l
    ld l, a
    ld a, [hl]
    ld [CurrentSong2], a
    ld a, $4c
    ld [CurrentSong], a
    ret

; $6871
LevelSongs::
    db SONG_08                      ; Level 1: "I wanna be like you"
    db SONG_00                      ; Level 2:
    db SONG_01                      ; Level 3:
    db SONG_03                      ; Level 4:
    db SONG_04                      ; Level 5:
    db SONG_02                      ; Level 6:
    db SONG_00                      ; Level 7:
    db SONG_06                      ; Level 8:
    db SONG_02                      ; Level 9:
    db SONG_03                      ; Level 10:
    db SONG_05                      ; Level Bonus:
    db SONG_05                      ; Level Transition:

KingLouieSprites::
    INCBIN "gfx/KingLouieSprites.2bpp"

KingLouieActionSprites::
    INCBIN "gfx/KingLouieActionSprites.2bpp"

ShereKhanSprites::
    INCBIN "gfx/ShereKhanSprites.2bpp"

ShereKhanActionSprites::
    INCBIN "gfx/ShereKhanActionSprites.2bpp"

VillageGirlSprites::
    INCBIN "gfx/VillageGirlSprites.2bpp"

Bank7TailData::
    db $e0, $ff, $07