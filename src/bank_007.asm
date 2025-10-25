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

; $407b
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
    call HandleNoiseChannel
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
    ld bc, SongHeaderTable
    add hl, bc
    ld c, PTR_SIZE * 5              ; = 10
    ld de, StreamPtrsBase

; $40a8: Sets up StreamPtrsBase with data from SongHeaderTable.
.CopyLoop:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, .CopyLoop

    ld c, PTR_SIZE * 5              ; = 10
    ld hl, StreamPtrsBase
    ld de, SongDataRam2

; $40b6: Sets up SongDataRam2 with data from SongHeaderTable. Content identical to SongDataRam.
CopyLoop2:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, CopyLoop2

    ld a, 1
    ld [Square1NoteDelayCounter], a ; = 1
    ld [Square2NoteDelayCounter], a ; = 1
    ld [WaveNoteDelayCounter], a    ; = 1
    ld [NoiseNoteDelayCounter], a   ; = 1
    ld [PercussionNoteDelayCounter], a ; = 1
    dec a
    ld [Square1Note], a             ; = 0
    ld [$c5bf], a                   ; = 0
    ld [SquareNR12Set], a           ; = 0
    ld [SquareNR22Set], a           ; = 0
    ld [$c583], a                   ; = 0
    ld [WaveSoundVolume], a         ; = 0
    ld [FadeOutCounter], a          ; = 0
    ld [EventSoundChannelsUsed], a  ; = 0
    ld [$c5b9], a                   ; = 0
    ld [NoiseWaveControl], a        ; = 0
    dec a
    ld [Square1InstrumentId], a     ; = $ff
    ld [Square2InstrumentId], a     ; = $ff
    ld [WaveInstrumentId], a        ; = $ff
    ld [NoiseInstrumentId], a       ; = $ff
    ld [PercussionInstrumentId], a  ; = $ff
    ld [PlayingEventSound], a       ; = $ff
    ld a, %11111
    ld [ChannelEnable], a           ; = %11111 (enable all channels)
    ld a, 7
    call SetVolume                  ; Load volume 7 = full volume.
    ld a, 9
    ld [SoundCounter], a            ; = 9
    ld a, $00
    ld [EventSoundPriority], a      ; = 0
    dec a
    ld [PlayingEventSound], a       ; = $ff
    ret

; $4118: Initializes sound registers. Full volume on all outputs.
InitSound::
    ld a, $00
    ldh [rAUDENA], a                ; Stop all sound.
    ld a, $ff
    ld [CurrentSong], a             ; = $ff
    inc a
    ld [ChannelEnable], a           ; = 0
    ld [FadeOutCounter], a          ; = 0
    ld [CurrentSoundVolume], a      ; = 0
    ld [NoiseShape1], a             ; = 0
    ld a, $ff
    ld [PlayingEventSound], a       ; = $ff
    ld [EventSound], a              ; = $ff
    inc a
    ld [EventSoundNoteLength], a    ; = 0
    ld [EventSoundChannelsUsed], a  ; = 0
    ld [EventSoundPriority], a      ; = 0
    ld a, %10001111                 ; No effect except for bit7.
    ldh [rAUDENA], a                ; Turn on sound.
    ld a, $ff
    ldh [rAUDVOL], a                ; Full volume, both channels on.
    ldh [rAUDTERM], a               ; All sounds to all terminal.
    ret

; $414b
HandleSquare1Channel:
    ld a, [ChannelEnable]
    bit 0, a
    ret z                           ; Return if Square 1 channel is disabled.
    ld a, [Square1Counter]
    inc a
    jr z, :+
    ld [Square1Counter], a          ; += 1
 :  ld a, [SoundCounter]
    or a
    jp z, SetSquare1Registers
    ld a, [Square1NoteDelayCounter]
    dec a
    jr z, :+
    ld [Square1NoteDelayCounter], a ; -= 1
    jp SetSquare1Registers
 :  ld a, [Square1InstrumentId]
    cp $ff
    jr z, Square1ReadStream0
    ld a, [$c51b]
    ld l, a
    ld a, [$c51c]
    ld h, a
    jp Square1SetupLoop

; $417f
Square1ReadStream0:
    ld a, [Square1StreamPtrLsb]
    ld e, a
    ld a, [Square1StreamPtrMsb]
    ld d, a

; $4187
Square1ReadStream1:
    ld a, [de]
    bit 7, a
    jr z, .SetInstrumentId          ; Jump if data < $80

    cp $a0
    jr nc, .Continue0               ; Jump if data >= $a0

; $4190: Reached if $a0 > data >= $80
.SetTranspose:
    inc de
    ld a, [de]
    ld [Square1Tranpose], a
    inc de
    jr Square1ReadStream1

; $4198
.Continue0:
    cp $c0
    jr nc, .Continue1               ; Jump if data >= $c0

    bit 0, a
    jr z, .DecrementSquare1RepeatCount

; $41a0: Reached if $c0 > data >= $a0 with set Bit 0.
.SetSquare1RepeatCount:
    inc de
    ld a, [de]
    ld [Square1RepeatCount], a
    inc de
    ld a, e
    ld [Square1LoopHeaderLsb], a    ; Save stream position LSB.
    ld a, d
    ld [Square1LoopHeaderMsb], a    ; Save stream position MSB.
    jr Square1ReadStream1

; $41b0: Reached if $c0 > data >= $a0 with no set Bit 0.
.DecrementSquare1RepeatCount:
    inc de
    ld a, [Square1RepeatCount]
    dec a
    jr z, Square1ReadStream1         ; Go to next stream byte if last iteration finished.
    ld [Square1RepeatCount], a      ; -= 1
    ld a, [Square1LoopHeaderLsb]
    ld e, a
    ld a, [Square1LoopHeaderMsb]
    ld d, a
    jr Square1ReadStream1

; $414c
.Continue1:
    cp $ff
    jr c, .Continue2                ; Jump if data < $ff

; $41c8:  Reached if data == $ff
.DisableSquare1:                    ; Disable if value is $ff.
    ld hl, ChannelEnable
    res 0, [hl]                     ; Square1 disable.
    ld hl, rNR52
    res 0, [hl]                     ; Turn Square1 Sound off.
    ret

; $41d3
.Continue2:
    cp $fe
    jr c, .SetStreamPointer         ; Jump if data < $fe

; $41d7: Reached if data == $fe
.SetStreamPointerFromSongDataRam2:
    ld a, [SongDataRam2]
    ld e, a
    ld a, [SongDataRam2 + 1]
    ld d, a
    jr Square1ReadStream1

; $41e1: Reached if $fe > data >= c0.
.SetStreamPointer:
    inc de
    ld a, [de]
    ld [SongDataRam2], a            ; [SongDataRam2] = [StreamPtr + 1]
    ld b, a
    inc de
    ld a, [de]
    ld [SongDataRam2 + 1], a        ; [SongDataRam2 + 1] = [StreamPtr + 2]
    ld d, a
    ld e, b                         ; de = new StreamPtr
    jr Square1ReadStream1

; $41f0: Reached if data < $80
.SetInstrumentId:
    and a
    jr nz, :+              ; Jump if value is 0.
    inc de
    ld a, [de]

 :  ld [Square1InstrumentId], a     ; [Square1InstrumentId] = [StreamPtr + 1]
    ld l, a
    ld h, $00
    add hl, hl                      ; hl = [Square1InstrumentId] * 2
    ld bc, InstrumentData
    add hl, bc
    inc de
    ld a, e
    ld [Square1StreamPtrLsb], a     ; Save Square1StreamPtr so "de" can be used.
    ld a, d
    ld [Square1StreamPtrMsb], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e                         ; hl = [InstrumentData + offset]

; $420e: Now do actions based on the value of [InstrumentData + offset].
Square1SetupLoop:
    ld a, [hl+]
    bit 7, a
    jp z, HandleSquare1             ; Jump if value < $80.

    cp $a0
    jr nc, .Continue0               ; Jump if value >= $a0.

; $4218 : Reached if value in [$80, $9f].
.SetSquare1NoteDelay:               
    and $1f
    jr nz, :+
    ld a, [hl+]
 :  ld [Square1NoteDelay], a
    jr Square1SetupLoop

; $4222
.Continue0:
    cp $b0
    jr nc, jr_007_429c              ; Jump if value >= $b0.

    and $0f                         ; Reached if value in [$a0, $af].
    jr nz, .Continue1

; $422a: Reached if value == $a0.
.ResetSquare1:                       
    ld [$c540], a                   ; = 0
    ld [$c545], a                   ; = 0
    ld [Square1PreNoteDuration], a  ; = 0
    ld [$c54b], a                   ; = 0
    ld [Square1SweepDelay], a       ; = 0
    ld [Square1VibratoDelay], a     ; = 0
    jr Square1SetupLoop

; $423e
.Continue1:
    dec a
    jr nz, .Continue2

    ld a, [hl+]                     ; Reached if value & $f == 1.
    ld [$c540], a
    jr Square1SetupLoop

; $4247
.Continue2:
    dec a
    jr nz, .Continue3

    ld a, [hl+]                     ; Reached if value & $f == 2.
    ld [$c549], a
    ld [$c54a], a
    ld a, [hl+]
    ld [$c548], a
    ld a, [hl+]
    ld [$c545], a
    jr Square1SetupLoop

; $426c
.Continue3:
    dec a
    jr nz, .Continue4              

; $425e
.SetPreNoteAndNoteMod:
    ld a, [hl+]                     ; Reached if value & $f == 3.
    ld [Square1PreNoteDuration], a
    ld a, [hl+]
    ld [Square1NoteMod], a
    ld a, [hl+]
    ld [Square1PreNote], a
    jr Square1SetupLoop

; $427d
.Continue4:
    dec a
    jr nz, .Continue5

    ld a, [hl+]                     ; Reached if value & $f == 4.
    ld [$c54e], a
    ld a, [hl+]
    ld [$c54d], a
    ld a, [hl+]
    ld [$c54b], a
    jr Square1SetupLoop

; $428a
.Continue5:
    dec a
    jr nz, .Continue6

; $4280
.SetSquare1Sweep:                   ; Reached if value & $f == 5.
    ld a, [hl+]
    ld [Square1SweepValue], a
    ld a, [hl+]
    ld [Square1SweepDelay], a
    jr Square1SetupLoop

; $428a
.Continue6:
    dec a
    jr nz, .Continue7

; $428d
.SetSquare1Vibrato:                 ; Reached if value & $f == 6.
    ld a, [hl+]
    ld [Square1Vibrato1], a
    ld a, [hl+]
    ld [Square1VibratoDelay], a
    ld a, [hl+]
    ld [Square1Vibrato2], a

; $4299
.Continue7:                         ; Reached if value & $f > 6
    jp Square1SetupLoop

; $429c
jr_007_429c:
    cp $c0
    jr nc, jr_007_42af

    ld a, [hl+]
    ld [Square1NoteDelayCounter], a
    ld a, l
    ld [$c51b], a
    ld a, h
    ld [$c51c], a
    jp SetSquare1Registers

; $42af
jr_007_42af:
    cp $c2
    jr nc, jr_007_42c6

    bit 0, a
    ld a, [$c5bf]
    jr z, jr_007_42be

    res 0, a
    jr jr_007_42c0

; $42be
jr_007_42be:
    set 0, a

; $42c0
jr_007_42c0:
    ld [$c5bf], a
    jp Square1SetupLoop

; $42c6
jr_007_42c6:
    cp $ff
    jp z, Square1ReadStream0        ; Next element from stream if data is $ff

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
    jp Square1ReadStream0


; $42e6: This is the point at which the actual sound register is set up.
; Input: a = note to play (tranpose will be added in this function)
HandleSquare1:
    ld c, a
    ld a, [Square1Tranpose]
    add c
    ld [Square1Note], a
    ld a, l
    ld [$c51b], a
    ld a, h
    ld [$c51c], a
    ld a, [Square1Note]
    ld l, a
    ld h, $00
    add hl, hl                      ; hl = [Square1Note] * 2
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
    ld [Square1Counter], a          ; = 0
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
    ld [SquareNR12Set], a           ; = $80

jr_007_4342:
    ld a, [Square1NoteDelay]
    ld [Square1NoteDelayCounter], a
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, SetSquare1Registers

    ld hl, EventSoundChannelsUsed
    res 0, [hl]

; $4354
SetSquare1Registers:
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
    ld a, [Square1Counter]
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
    ld a, [Square1Note]
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
    ld a, [Square1Counter]
    ld hl, Square1PreNoteDuration
    call Square1SetFreqAndDuty
    ld de, Square1FrequencyLsb
    ld hl, Square1VibratoBase
    ld a, [Square1Counter]
    call HandleVibrato
    ld de, Square1FrequencyLsb
    ld hl, Square1SweepDelay
    ld a, [Square1Counter]
    call HandleSweep
    ld a, [EventSoundChannelsUsed]
    bit 0, a
    ret nz                          ; Return if EventSound uses Square1.

; $43c2
.SetUpSquare:
    ld c, LOW(rNR10)
    ld a, $08
    ldh [c], a                      ; [rNR10] = 8 (negate, shift = 0, period = 0)
    inc c
    ld a, [SquareNR11Value]
    ldh [c], a                      ; Wave duty, length load: [rNR11] = [SquareNR11Value]
    inc c
    ld hl, SquareNR12Set
    bit 7, [hl]
    jr z, .SetUpFreq

; $43d4
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
; Input: hl = Square1PreNoteDuration
;        a = Square1Counter
Square1SetFreqAndDuty:
    cp [hl]                         ; hl = Square1PreNoteDuration
    jr c, .SetFreqAndDuty           ; Jump if Square1Counter < [Square1PreNoteDuration]
    ret nz
    ld a, [Square1Note]
    jr .SetFrequencyFromA

; $43fb
.SetFreqAndDuty:
    inc hl
    ld a, [hl+]                     ; a = [Square1NoteMod]
    ld e, a
    bit 1, e
    jr z, .CheckPreNote

; 4SetDuty
.SetDuty:
    and %11000000
    ld [SquareNR11Value], a         ; Set duty cycle.

; $43fb
.CheckPreNote:
    ld c, [hl]                      ; c = [Square1PreNote]
    bit 0, e
    jr z, .SetFrequencyFromC

    ld a, [Square1Note]
    add c

; $4404
.SetFrequencyFromA:
    ld c, a

; $4405
.SetFrequencyFromC:
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
    ld a, [Square2Counter]
    inc a
    jr z, :+
    ld [Square2Counter], a          ; += 1

 :  ld a, [SoundCounter]
    or a
    jp z, Jump_007_4621

    ld a, [Square2NoteDelayCounter]
    dec a
    jr z, jr_007_443a

    ld [Square2NoteDelayCounter], a ; -= 1
    jp Jump_007_4621


jr_007_443a:
    ld a, [Square2InstrumentId]
    cp $ff
    jr z, Square2ReadStream0

    ld a, [$c51d]
    ld l, a
    ld a, [$c51e]
    ld h, a
    jp Square2SetupLoop

; $444c
Square2ReadStream0:
    ld a, [Square2StreamPtrLsb]
    ld e, a
    ld a, [Square2StreamPtrMsb]
    ld d, a

; $4454
Square2ReadStream1:
    ld a, [de]
    bit 7, a
    jr z, .SetInstrumentId

    cp $a0
    jr nc, .Continue0

; $445d
.SetTranpose:
    inc de
    ld a, [de]
    ld [Square2Tranpose], a
    inc de
    jr Square2ReadStream1

; $4465
.Continue0:
    cp $c0
    jr nc, .Continue1

    bit 0, a
    jr z, .DecrementSquare2RepeatCount

; $446d
.SetSquare2RepeatCount:
    inc de
    ld a, [de]
    ld [Square2RepeatCount], a
    inc de
    ld a, e
    ld [Square2LoopHeaderLsb], a
    ld a, d
    ld [Square2LoopHeaderMsb], a
    jr Square2ReadStream1

; $447d
.DecrementSquare2RepeatCount:
    inc de
    ld a, [Square2RepeatCount]
    dec a
    jr z, Square2ReadStream1
    ld [Square2RepeatCount], a
    ld a, [Square2LoopHeaderLsb]    ; Save stream position LSB.
    ld e, a
    ld a, [Square2LoopHeaderMsb]    ; Save stream position MSB.
    ld d, a
    jr Square2ReadStream1

; $4491
.Continue1:
    cp $ff
    jr c, .Continue2

; $4495
.DisableSquare2:
    ld hl, ChannelEnable
    res 1, [hl]
    ld hl, rNR52
    res 1, [hl]
    ret

; $44a0
.Continue2:
    cp $fe
    jr c, .Continue3

    ld a, [$c513]
    ld e, a
    ld a, [$c514]
    ld d, a
    jr Square2ReadStream1

; $44ae
.Continue3:
    inc de
    ld a, [de]
    ld [$c513], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c514], a
    ld d, a
    ld e, b
    jr Square2ReadStream1

; $44bd
.SetInstrumentId:
    and a
    jr nz, :+
    inc de
    ld a, [de]

:   ld [Square2InstrumentId], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, InstrumentData
    add hl, bc
    inc de
    ld a, e
    ld [Square2StreamPtrLsb], a
    ld a, d
    ld [Square2StreamPtrMsb], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e                         ; hl = [InstrumentData + offset]

; $44db
Square2SetupLoop:
    ld a, [hl+]
    bit 7, a
    jp z, HandleSquare2

    cp $a0
    jr nc, .Continue0

; $44e5
.SetSquare2NoteDelay
    and $1f
    jr nz, :+
    ld a, [hl+]
:   ld [Square2NoteDelay], a
    jr Square2SetupLoop

; $44ef
.Continue0:
    cp $b0
    jr nc, jr_007_4569

    and $0f
    jr nz, .Continue1

    ld [$c562], a                   ; = 0
    ld [$c567], a                   ; = 0
    ld [Square2PreNoteDuration], a  ; = 0
    ld [$c56d], a                   ; = 0
    ld [Square2SweepDelay], a       ; = 0
    ld [Square2VibratoDelay], a     ; = 0
    jr Square2SetupLoop             ; = 0

; $450b
.Continue1:
    dec a
    jr nz, .Continue2

    ld a, [hl+]
    ld [$c562], a
    jr Square2SetupLoop

; $4514
.Continue2:
    dec a
    jr nz, .Continue3

    ld a, [hl+]
    ld [$c56b], a
    ld [$c56c], a
    ld a, [hl+]
    ld [$c56a], a
    ld a, [hl+]
    ld [$c567], a
    jr Square2SetupLoop

; $4528
.Continue3:
    dec a
    jr nz, .Continue4

    ld a, [hl+]
    ld [Square2PreNoteDuration], a
    ld a, [hl+]
    ld [Square2NoteMod], a
    ld a, [hl+]
    ld [Square2PreNote], a
    jr Square2SetupLoop

; $4539
.Continue4:
    dec a
    jr nz, .Continue5

    ld a, [hl+]
    ld [$c570], a
    ld a, [hl+]
    ld [$c56f], a
    ld a, [hl+]
    ld [$c56d], a
    jr Square2SetupLoop

; $454a
.Continue5:
    dec a
    jr nz, .Continue6

    ld a, [hl+]
    ld [Square2SweepValue], a
    ld a, [hl+]
    ld [Square2SweepDelay], a
    jr Square2SetupLoop

; $4557
.Continue6:
    dec a
    jr nz, .Continue7

; $455a
.SetVibrato:
    ld a, [hl+]
    ld [Square2Vibrato1], a
    ld a, [hl+]
    ld [Square2VibratoDelay], a
    ld a, [hl+]
    ld [Square2Vibrato2], a

; $4566
.Continue7:
    jp Square2SetupLoop

jr_007_4569:
    cp $c0
    jr nc, jr_007_457c

    ld a, [hl+]
    ld [Square2NoteDelayCounter], a
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
    jp Square2SetupLoop


jr_007_4593:
    cp $ff
    jp z, Square2ReadStream0

    cp $d0
    jr nz, jr_007_45a5

    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    push hl
    ld h, a
    ld l, b
    jp Square2SetupLoop


jr_007_45a5:
    cp $d1
    jr nz, jr_007_45ad

    pop hl
    jp Square2SetupLoop


jr_007_45ad:
    jp Main
    jp Square2ReadStream0


; $45b3
HandleSquare2:
    ld c, a
    ld a, [Square2Tranpose]
    add c
    ld [Square2Note], a
    ld a, l
    ld [$c51d], a
    ld a, h
    ld [$c51e], a
    ld a, [Square2Note]
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
    ld [Square2Counter], a          ; = 0
    ld [$c563], a                   ; = 0
    ld [$c564], a                   ; = 0
    ld [$c569], a                   ; = 0
    ld [$c56e], a                   ; = 0
    ld a, [$c570]
    ld [$c571], a
    ld a, [$c567]
    bit 7, a
    jr nz, jr_007_460a

    ld a, [$c56b]
    ld [$c56c], a

jr_007_460a:
    ld a, $80
    ld [SquareNR22Set], a

jr_007_460f:
    ld a, [Square2NoteDelay]
    ld [Square2NoteDelayCounter], a
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
    ld a, [Square2Counter]
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
    ld a, [Square2Note]
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
    ld a, [Square2Counter]
    ld hl, Square2PreNoteDuration
    call Square2SetFreq
    ld de, Square2FrequencyLsb
    ld hl, Square2VibratoBase
    ld a, [Square2Counter]
    call HandleVibrato
    ld de, Square2FrequencyLsb
    ld hl, Square2SweepDelay
    ld a, [Square2Counter]
    call HandleSweep
    ld a, [EventSoundChannelsUsed]
    bit 1, a
    ret nz                          ; Return if event sound uses Square2.

    ld c, $15
    ld a, $08                       ; Weird: Useless?
    inc c
    ld a, [$c568]
    ldh [c], a                      ; [rNR21] = [$c568]
    inc c
    ld hl, SquareNR22Set
    bit 7, [hl]
    jr z, .SetFrequency

; $46a0
.SetNr22:
    ld a, [$c565]
    ldh [c], a                      ; [rNR22]

; $46a4
.SetFrequency:
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

; $46b2:
; Input hl = Square2PreNoteDuration 
Square2SetFreq:
    cp [hl]
    jr c, .CheckPreNote
    ret nz
    ld a, [Square2Note]
    jr .SetFreqFromA

; $46bb
.CheckPreNote:
    inc hl
    ld a, [hl+]                     ; a = [Square2NoteMod]
    ld e, a
    ld c, [hl]                      ; c = [Square2PreNote]
    bit 0, e
    jr z, .SetFreqFromC
    ld a, [Square2Note]
    add c

; $46c7
.SetFreqFromA:
    ld c, a

; $46c8
.SetFreqFromC:
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

    ld a, [WaveCounter]
    inc a
    jr z, jr_007_46ea

    ld [WaveCounter], a

jr_007_46ea:
    ld a, [SoundCounter]
    or a
    jp z, Jump_007_48ed

    ld a, [WaveNoteDelayCounter]
    dec a
    jr z, jr_007_46fd

    ld [WaveNoteDelayCounter], a
    jp Jump_007_48ed


jr_007_46fd:
    ld a, [WaveInstrumentId]
    cp $ff
    jr z, WaveReadStream0

    ld a, [$c51f]
    ld l, a
    ld a, [$c520]
    ld h, a
    jp WaveSetupLoop

; $470f
WaveReadStream0:
    ld a, [WaveStreamPtrLsb]
    ld e, a
    ld a, [WaveStreamPtrMsb]
    ld d, a

; $4717
WaveReadStream1:
    ld a, [de]
    bit 7, a
    jr z, .SetInstrumentId

    cp $a0
    jr nc, .Continue0

; $4720
.SetWaveTranspose:
    inc de
    ld a, [de]
    ld [WaveTranspose], a
    inc de
    jr WaveReadStream1

; $4728
.Continue0:
    cp $c0
    jr nc, .Continue1
    bit 0, a
    jr z, .DecrementWaveRepeatCount

; $4730
.SetWaveRepeatCount:
    inc de
    ld a, [de]
    ld [WaveRepeatCount], a
    inc de
    ld a, e
    ld [WaveLoopHeaderLsb], a
    ld a, d
    ld [WaveLoopHeaderMsb], a
    jr WaveReadStream1

; $4740
.DecrementWaveRepeatCount:
    inc de
    ld a, [WaveRepeatCount]
    dec a
    jr z, WaveReadStream1

    ld [WaveRepeatCount], a
    ld a, [WaveLoopHeaderLsb]
    ld e, a
    ld a, [WaveLoopHeaderMsb]
    ld d, a
    jr WaveReadStream1

; $4754
.Continue1:
    cp $ff
    jr c, .Continue2

; $4758
.DisableWave:
    ld hl, ChannelEnable
    res 2, [hl]
    ld hl, rNR52
    res 2, [hl]
    ret

; $4763
.Continue2:
    cp $fe
    jr c, .Continue3

    ld a, [$c515]
    ld e, a
    ld a, [$c516]
    ld d, a
    jr WaveReadStream1

; $4771
.Continue3:
    inc de
    ld a, [de]
    ld [$c515], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c516], a
    ld d, a
    ld e, b
    jr WaveReadStream1

; $4780
.SetInstrumentId:
    and a
    jr nz, :+
    inc de
    ld a, [de]
 :  ld [WaveInstrumentId], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, InstrumentData
    add hl, bc
    inc de
    ld a, e
    ld [WaveStreamPtrLsb], a
    ld a, d
    ld [WaveStreamPtrMsb], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e                         ; hl = [InstrumentData + offset]
    ld a, $80
    ld [$c583], a

; $47a3
WaveSetupLoop:
    ld a, [hl+]
    bit 7, a
    jp z, SetUpWaveNote

    cp $a0
    jr nc, .Continue0

    and $1f
    jr nz, .SetWaveNoteDelay

    ld a, [hl+]

; $47b2
.SetWaveNoteDelay:
    ld [WaveNoteDelay], a
    jr WaveSetupLoop

; $47b7
.Continue0:
    cp $b0
    jp nc, Jump_007_484d

    and $0f
    jr nz, .Continue1

; $47c0: Reached if a == 0.
.ResetWave:
    ld [WaveSoundVolumeStart], a    ; = 0
    ld [$c581], a                   ; = 0
    ld [$c582], a                   ; = 0
    ld [$c596], a                   ; = 0
    ld [$c591], a                   ; = 0
    ld [WaveSweepDelay], a          ; = 0
    ld [WaveVibratoDelay], a        ; = 0
    jr WaveSetupLoop

; $47d7
.Continue1:
    dec a
    jr nz, .Continue2

; Reached if a == 1.
    ld a, [hl+]
    ld [WaveSoundVolumeStart], a
    ld a, [hl+]
    ld [$c581], a
    ld a, [hl+]
    ld [$c582], a
    jr WaveSetupLoop

; $47e8
.Continue2:
    dec a
    jr nz, .Continue3

; Reached if a == 2.
    ld a, [hl+]
    ld [$c58f], a
    ld [$c590], a
    ld a, [hl+]
    ld [$c58e], a
    ld a, [hl+]
    ld [$c58b], a
    jr WaveSetupLoop

; $47fc
.Continue3:
    dec a
    jr nz, .Continue4

; Reached if a == 3.
    ld a, [hl+]
    ld [$c596], a
    ld a, [hl+]
    ld [$c597], a
    ld a, [hl+]
    ld [$c598], a
    jr WaveSetupLoop

; $480d
.Continue4:
    dec a
    jr nz, .Continue5

; Reached if a == 4.
    ld a, [hl+]
    ld [$c594], a
    ld a, [hl+]
    ld [$c593], a
    ld a, [hl+]
    ld [$c591], a
    jr WaveSetupLoop

; $481e
.Continue5:
    dec a
    jr nz, .Continue6

; $4821: Reached if a == 5.
.SetWaveSweep:
    ld a, [hl+]
    ld [WaveSweepValue], a
    ld a, [hl+]
    ld [WaveSweepDelay], a
    jp WaveSetupLoop

; $482c
.Continue6:
    dec a
    jr nz, .Continue7

; $482f: Reached if a == 6.
.SetWaveVibrato:
    ld a, [hl+]
    ld [WaveVibrato1], a
    ld a, [hl+]
    ld [WaveVibratoDelay], a
    ld a, [hl+]
    ld [WaveVibrato2], a
    jp WaveSetupLoop

; $483e
.Continue7:
    dec a
    jr nz, RepeatWaveSetupLoop

; $4841: Reached if a == 7.
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
    ld [WaveNoteDelayCounter], a
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
    jp z, WaveReadStream0
    jp WaveReadStream0


; $487f
SetUpWaveNote:
    ld c, a
    ld a, [WaveTranspose]
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
    ld [WaveCounter], a      ; = 0
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
    ld a, [WaveNoteDelay]
    ld [WaveNoteDelayCounter], a
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
    ld a, [WaveCounter]
    ld hl, $c596
    call SetWaveFrequency
    ld de, WaveFrequencyLsb
    ld hl, WaveVibratoBase
    ld a, [WaveCounter]
    call HandleVibrato
    ld de, WaveFrequencyLsb
    ld hl, WaveSweepDelay
    ld a, [WaveCounter]
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

; $4a06
HandleNoiseChannel:
    ld a, [ChannelEnable]
    bit 3, a
    ret z                           ; Return if channel is disabled.
    ld a, [NoiseCounter]
    inc a
    jr z, :+
    ld [NoiseCounter], a            ; += 1
 :  ld a, [SoundCounter]
    or a
    jp z, SetNoiseRegisters
    ld a, [NoiseNoteDelayCounter]
    dec a
    jr z, jr_007_4a28

    ld [NoiseNoteDelayCounter], a   ; += 1
    jp SetNoiseRegisters


jr_007_4a28:
    ld a, [NoiseInstrumentId]
    cp $ff
    jr z, NoiseReadStream0

    ld a, [$c521]
    ld l, a
    ld a, [$c522]
    ld h, a
    jp NoiseSetupLoop

; $4a3a
NoiseReadStream0:
    ld a, [NoiseStreamPtrLsb]
    ld e, a
    ld a, [NoiseStreamPtrMsb]
    ld d, a

; $4a42
NoiseReadStream1:
    ld a, [de]
    bit 7, a
    jr z, .SetInstrumentId

    cp $a0
    jr nc, .Continue0

; $4a4b
.SetTranspose:
    inc de
    ld a, [de]
    ld [NoiseTranspose], a
    inc de
    jr NoiseReadStream1

; $4a53
.Continue0:
    cp $c0
    jr nc, .Continue1

    bit 0, a
    jr z, .DecrementNoiseRepeatCount

; $4a5b
.SetNoiseRepeatCount:
    inc de
    ld a, [de]
    ld [NoiseRepeatCount], a
    inc de
    ld a, e
    ld [NoiseLoopHeaderLsb], a
    ld a, d
    ld [NoiseLoopHeaderMsb], a
    jr NoiseReadStream1

; $4a6b
.DecrementNoiseRepeatCount:
    inc de
    ld a, [NoiseRepeatCount]
    dec a
    jr z, NoiseReadStream1

    ld [NoiseRepeatCount], a
    ld a, [NoiseLoopHeaderLsb]
    ld e, a
    ld a, [NoiseLoopHeaderMsb]
    ld d, a
    jr NoiseReadStream1

; $4a7f
.Continue1:
    cp $ff
    jr c, .Continue2

; $4a83
.DisableNoise:
    ld hl, ChannelEnable
    res 3, [hl]
    ld hl, rNR52
    res 3, [hl]
    ret

; $4a8e
.Continue2:
    cp $fe
    jr c, .Continue3

    ld a, [$c517]
    ld e, a
    ld a, [$c518]
    ld d, a
    jr NoiseReadStream1

; $4a9c
.Continue3:
    inc de
    ld a, [de]
    ld [$c517], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c518], a
    ld d, a
    ld e, b
    jr NoiseReadStream1

; $4aab
.SetInstrumentId:
    and a
    jr nz, :+
    inc de
    ld a, [de]

 :  ld [NoiseInstrumentId], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, InstrumentData
    add hl, bc
    inc de
    ld a, e
    ld [NoiseStreamPtrLsb], a
    ld a, d
    ld [NoiseStreamPtrMsb], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e                         ; hl = [InstrumentData + offset]

; $4ac9
NoiseSetupLoop:
    ld a, [hl+]
    bit 7, a
    jp z, HandleNoise

    cp $a0
    jr nc, .Continue0

; $4ad3
.SetNoiseNoteDelay:
    and $1f
    jr nz, :+
    ld a, [hl+]
 :  ld [NoiseNoteDelay], a
    jr NoiseSetupLoop

; $4add
.Continue0:
    cp $b0
    jr nc, jr_007_4b2b

    and $0f
    jr nz, .Continue1

; $4ae5
.ResetNoise:
    ld [$c5a8], a                   ; = 0
    ld [$c5ad], a                   ; = 0
    ld [NoiseShapeCounterThresh], a ; = 0
    jr NoiseSetupLoop

; $4af0
.Continue1:
    dec a
    jr nz, .Continue2

    ld a, [hl+]
    ld [$c5a8], a
    jr NoiseSetupLoop

; $4af9
.Continue2:
    dec a
    jr nz, .Continue3

; $4afc: Reached if a == 2.
.SetNoiseShape1:
    ld a, [hl+]
    ld [NoiseShape1], a
    jr NoiseSetupLoop

; $4b02
.Continue3:
    dec a
    jr nz, .Continue4

    jr NoiseSetupLoop

; $4b07
.Continue4:
    dec a
    jr nz, .Continue5

    ld a, [hl+]
    ld [$c5b0], a
    ld a, [hl+]
    ld [$c5af], a
    ld a, [hl+]
    ld [$c5ad], a
    jr NoiseSetupLoop

; $4b18
.Continue5:
    dec a
    jr nz, .Continue6

; $4b1b
.SetNoiseShapeStepAndThresh:
    ld a, [hl+]
    ld [NoiseShapeSettingStep], a
    ld a, [hl+]
    ld [NoiseShapeCounterThresh], a
    jr NoiseSetupLoop

; $4b25
.Continue6:
    dec a
    jr nz, :+              ; Weird: What a sick jump.
 :  jp NoiseSetupLoop

jr_007_4b2b:
    cp $c0
    jr nc, jr_007_4b3e

    ld a, [hl+]
    ld [NoiseNoteDelayCounter], a
    ld a, l
    ld [$c521], a
    ld a, h
    ld [$c522], a
    jp SetNoiseRegisters


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
    jp NoiseSetupLoop


jr_007_4b55:
    cp $ff
    jp z, NoiseReadStream0
    jp NoiseReadStream0

; $4b5d
HandleNoise:
    ld c, a
    ld a, [NoiseTranspose]
    add c
    ld [NoiseShapeSetting], a
    ld a, l
    ld [$c521], a
    ld a, h
    ld [$c522], a
    ld a, [NoiseShapeSetting]
    ld l, a
    ld h, $00
    ld bc, NoiseNr43Settings
    add hl, bc
    ld a, [hl+]
    ld [NoiseShape0], a
    xor a                           ; Weird: Useless xor?
    ld a, [$c5bf]
    bit 3, a
    jr nz, .SetNoiseNoteDelayCounter

    xor a
    ld [NoiseCounter], a            ; = 0
    ld [$c5a9], a                   ; = 0
    ld [$c5aa], a                   ; = 0
    ld [$c5ae], a                   ; = 0
    ld a, [$c5b0]
    ld [$c5b1], a
    ld a, $80
    ld [NoiseControl], a            ; $80: -> indefinite length + trigger

; $4b9b
.SetNoiseNoteDelayCounter:
    ld a, [NoiseNoteDelay]
    ld [NoiseNoteDelayCounter], a
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, SetNoiseRegisters

    ld hl, EventSoundChannelsUsed
    res 3, [hl]                     ; Reset event sound wave flag.

; $4bad
SetNoiseRegisters:
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
    jr z, .SetNoiseNR41

    ld a, [$c5b1]
    ld b, a
    ld a, [NoiseShapeSetting]
    ld c, a
    call Call_007_4e67
    ld b, $00
    ld hl, NoiseNr43Settings
    add hl, bc
    ld a, [hl+]
    ld [NoiseShape0], a

; $4bde
.SetNoiseNR41:
    call LoadNewNoiseShapeSetting
    ld a, [EventSoundChannelsUsed]
    bit 3, a
    ret nz                          ; Return if an event sound is already using the noise channel.
    ld a, [NoiseWaveControl]
    and %11
    ret nz
    ld c, LOW(rNR41)
    ld a, $3f
    ldh [c], a                      ; [rNR41] = %0011 1111
    inc c
    ld hl, NoiseControl
    bit 7, [hl]
    jr z, .SetNoiseControlAndShape

; $4bfa
.SetNoiseEnvelope:
    ld a, [NoiseEnvelope]
    ldh [c], a                      ; [rNR42] = [NoiseEnvelope]

; $4bfe
.SetNoiseControlAndShape:
    inc c
    ld hl, NoiseShape1
    ld a, [NoiseShape0]
    or [hl]
    ldh [c], a                      ; [rNR43] = [NoiseShape0] | [NoiseShape1]
    inc c
    ld a, [NoiseControl]
    ret z
    ldh [c], a                      ; [rNR44] = [NoiseControl]
    xor a
    ld [NoiseControl], a            ; = 0
    ret

; $4c12 gives NoiseShape0 a new value
LoadNewNoiseShapeSetting:
    ld a, [NoiseCounter]
    ld hl, NoiseShapeCounterThresh
    cp [hl]
    ret c                           ; Return if under threshold.
    ld a, [hl]
    and a
    ret z                           ; Return if threshold is zero.
    inc hl                          ; hl = NoiseShapeSettingStep
    ld a, [NoiseShapeSetting]
    add [hl]
    ld [NoiseShapeSetting], a
    ld c, a
    ld b, $00
    ld hl, NoiseNr43Settings
    add hl, bc
    ld a, [hl+]
    ld [NoiseShape0], a
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

    ld a, [PercussionNoteDelayCounter]
    dec a
    jr z, jr_007_4c53

    ld [PercussionNoteDelayCounter], a                   ; -= 1
    jp Jump_007_4d44

jr_007_4c53:
    ld a, [PercussionInstrumentId]
    cp $ff
    jr z, PercussionReadStream0

    ld a, [$c523]
    ld l, a
    ld a, [$c524]
    ld h, a
    jp Jump_007_4ce3

; $4c65
PercussionReadStream0:
    ld a, [PercussionStreamPtrLsb]
    ld e, a
    ld a, [PercussionStreamPtrMsb]
    ld d, a

; $4c6d
PercussionReadStream1:
    ld a, [de]
    bit 7, a
    jr z, .SetInstrumentId

    cp $c0
    jr nc, .Continue0

    bit 0, a
    jr z, .DecrementPercussionRepeatCount

; $4c7a
.SetPercussionRepeatCount:
    inc de
    ld a, [de]
    ld [PercussionRepeatCount], a
    inc de
    ld a, e
    ld [PercussionLoopHeaderLsb], a
    ld a, d
    ld [PercussionLoopHeaderMsb], a
    jr PercussionReadStream1

; $4c8a
.DecrementPercussionRepeatCount:
    inc de
    ld a, [PercussionRepeatCount]
    dec a
    jr z, PercussionReadStream1
    ld [PercussionRepeatCount], a
    ld a, [PercussionLoopHeaderLsb]
    ld e, a
    ld a, [PercussionLoopHeaderMsb]
    ld d, a
    jr PercussionReadStream1

; $4c9e
.Continue0:
    cp $ff
    jr c, .Continue1

; $4ca2
.DisablePercussion:
    ld hl, ChannelEnable
    res 4, [hl]
    ret

; $4ca8
.Continue1:
    cp $fe
    jr c, .Continue2

    ld a, [$c519]
    ld e, a
    ld a, [$c51a]
    ld d, a
    jr PercussionReadStream1

; $4cb6
.Continue2:
    inc de
    ld a, [de]
    ld [$c519], a
    ld b, a
    inc de
    ld a, [de]
    ld [$c51a], a
    ld d, a
    ld e, b
    jr PercussionReadStream1

; $4cc5
.SetInstrumentId:
    and a
    jr nz, :+
    inc de
    ld a, [de]
 :  ld [PercussionInstrumentId], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, InstrumentData
    add hl, bc
    inc de
    ld a, e
    ld [PercussionStreamPtrLsb], a
    ld a, d
    ld [PercussionStreamPtrMsb], a
    ld a, [hl+]
    ld e, a
    ld a, [hl+]
    ld h, a
    ld l, e                         ; hl = [InstrumentData + offset]

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
    jp z, PercussionReadStream0

    jp PercussionReadStream0

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
    ld bc, TODOData51c8
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
    ld [PercussionNoteDelayCounter], a ; = [$c533]
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

; $4d9f
CheckSetupWaveVolume:
    ld b, a
    bit 3, a
    jr z, CheckSetupWave

; $4da4
.SetUpWaveVolume:
    ld a, [WaveVolume]
    ldh [rNR32], a

; $4da9
CheckSetupWave:
    ld a, [NoiseWaveControl]
    bit 2, a
    jr z, CheckSetupNoiseLfsr

; $4db0
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

; $4ddd
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

; $4ddd
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
;       a = value of a variable ([Square1Counter], [Square2Counter], or [WaveCounter])
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

; $4f14
VolumeNR32Settings::
    db $00                          ; Volume = 0%
    db $60                          ; Volume = 25%
    db $40                          ; Volume = 50%
    db $20                          ; Volume = 100%

; $4f18: 72 frequency settings for the wave channel. Each setting corresponds to one note.
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
    db $97, $96, $95, $94, $87, $86, $85, $84, $77, $76, $75, $74, $67, $66, $65, $64
    db $57, $56, $55, $54, $47, $46, $45, $44, $37, $36, $35, $34, $27, $26, $25, $24
    db $17, $16, $15, $14, $07, $06, $05, $04, $03, $02, $01, $00, $00, $00, $00, $00

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

; $51c8: Used to set TODOData51c8 + offset = SoundHl.
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

; $521b: 
;
; Data0: Data used for the square channel. 
; If $80 > data, a new instrument/score is set up. See ScoreXX.
; If $a0 > data >= $80, the next byte sets Square1Tranpose.
; If $c0 > data >= $a0 with set Bit 0 -> Next byte sets loop repeat count.
; If $c0 > data >= $a0 with set Bit 1 -> Loop end.
; If $fe > data >= $c0: a new stream pointer is loaded from the next 2 bytes. SongDataRam2 is set as well.
; If data == $fe, a new stream pointer is loaded from SongDataRam2.
; If data == $ff, the song reached its end and the channel is disabled
; 
; As you can see, in the following array, a song usually starts by setting up its transpose value.
; Then the individual scores are loaded.
SongData::

def SONG_TRANSPOSE EQU $80
def SONG_SET_PTR EQU $fd
def SONG_DISABLE_CHANNEL EQU $fe

; $521b: Square1 channel. Harmony.
Song00Data0::
    db SONG_TRANSPOSE, 5 
    db $20, $03, $03, $07, $08, $03, $09, $0a, $17, $03, $0c, $07, $0d, $03
    db $0b, $14, $12, $0b, $0b, $03, $03, $0b, $0b, $03, $0c, $07, $16, $03, $08, $18
    db $03, $09, $09, $09, $09, $80, $02, $12
    db SONG_TRANSPOSE, 5
    db $0a, $0b, $03, $1e, $14, $12
    db SONG_SET_PTR, $1e, $52                ; Set stream pointer to $521e

; $524e: Square2 channel. Melody.
Song00Data1::
    db SONG_TRANSPOSE, -19
    db $0e, $0f, $1a
    db SONG_DISABLE_CHANNEL

; $5254: Wave channel. Bass line.
Song00Data2::
    db SONG_TRANSPOSE, 5
    db $00, $00, $04, $15, $1b, $1c
    db SONG_SET_PTR, $58, $52

; $525f
Song00Data3::
    db SONG_TRANSPOSE, -5
    db $7f, $a1, $0e, $05, $a0, $02, $a1, $0e, $05, $a0, $01, $a1, $18, $05
    db $a0, $01, $01, $01, $05, $05, $05, $05, $05, $05, $a1, $06, $05, $a0, $01, $a1
    db $0a, $05, $a0, $02
    db SONG_SET_PTR, $62, $52

; $5286
Song00Data4::
    db $11, $a1, $07, $06, $a0, $13, $a1, $07, $06, $a0, $1f, $a1, $0c, $06, $a0, $19
    db $06, $06, $06, $06, $06, $1f, $06, $06, $06, $06, $06, $13
    db SONG_SET_PTR, $87, $52

Song01Data0::
    db SONG_TRANSPOSE, -4
    db $24
    db SONG_DISABLE_CHANNEL

Song01Data1::
    db $80, $fc, $a1, $0b, $27, $a0, $1d, $10, $1d, $10, $27, $fe

Song01Data2::
    db $80, $fc, $23, $fe

Song01Data3::
    db $80, $00, $01, $fe

Song01Data4::
    db $22, $fe

Song02Data0::
    db $80, $f8, $2a, $a1, $08, $2b, $a0, $80, $fd, $2b, $2b, $2b, $2b, $80, $fb, $2b
    db $2b, $2b, $2b, $80, $f9, $2b, $2b, $2b, $2b, $80, $f9, $2b, $2b, $80, $f8, $2c
    db $2c, $80, $f9, $2c, $2c, $80, $f8, $a1, $08, $2b, $a0, $fe

Song02Data1::
    db $80, $04, $25, $fe

Song02Data2::
    db $80, $f8, $a1, $08, $26, $a0, $80, $fd, $26, $26, $26, $26, $80, $fb, $26, $26
    db $26, $26, $80, $f9, $26, $26, $26, $26, $80, $f9, $26, $26, $80, $f3, $26, $26
    db $80, $f4, $26, $26, $80, $f8, $a1, $08, $26, $a0, $fe

Song02Data3::
    db $80, $00, $28, $fe

Song02Data4::
    db $29, $fe

Song03Data0::
    db $80, $f4, $a1, $07, $2d, $a0, $2e, $a1, $02, $2f, $2f, $2f, $2f, $30, $30, $30
    db $30, $a0, $31, $31, $31, $32, $fe

Song03Data1::
    db $80, $f4, $33, $34, $33, $37, $38, $38, $39, $39, $38, $38, $39, $3a, $3b, $fe

Song03Data2::
    db $80, $00, $3e, $fe

Song03Data3::
    db $80, $00, $3c, $fe

Song03Data4::
    db $3d, $3d, $3d, $3f, $a1, $08, $3d, $a0, $3d, $3f, $fe

Song04Data0::
    db $80, $f8, $44, $44, $80, $f8, $45, $47, $80, $f8, $44, $44, $80, $fa, $45, $45
    db $80, $f8, $44, $46, $80, $f8, $45, $47, $80, $f8, $44, $80, $fa, $45, $80, $f8
    db $44, $44, $fe

Song04Data1::
    db $80, $ec, $43, $fe

Song04Data2::
    db $80, $f8, $42, $42, $80, $fd, $42, $42, $80, $f8, $42, $42, $80, $ff, $42, $42
    db $80, $f8, $42, $42, $80, $fd, $42, $42, $80, $f8, $42, $80, $ff, $42, $80, $f8
    db $42, $42, $fe

Song04Data3::
    db $80, $fe, $40, $fe

Song04Data4::
    db $41, $41, $41, $48, $41, $48, $41, $41, $fe

Song05Data0::
    db $80, $fd, $52, $53, $52, $53, $56, $57, $52, $53, $80, $ff, $56, $80, $fd, $57
    db $52, $59, $fe

Song05Data1::
    db $80, $fd, $50, $51, $50, $51, $54, $55, $50, $51, $80, $ff, $54, $80, $fd, $55
    db $50, $58, $fe

Song05Data2::
    db $80, $fd, $4b, $4b, $80, $02, $4b, $80, $fd, $4b, $80, $04, $4c, $80, $fd, $4d
    db $fe

Song05Data3::
    db $80, $fc, $49, $fe

Song05Data4::
    db $4a, $4a, $4a, $4e, $4a, $4a, $4a, $4a, $4f, $4a, $4e, $fe

Song06Data0::
    db $80, $f3, $5f, $60, $5f, $80, $ee, $60, $5f, $60, $5f, $80, $f3, $60, $fe

Song06Data1::
    db $80, $ff, $5b, $5b, $5b, $5c, $5c, $5c, $5c, $5b, $fe

Song06Data2::
    db $80, $ff, $5a, $5a, $5a, $80, $fa, $5a, $5a, $5a, $5a, $80, $ff, $5a, $fe

Song06Data3::
    db $80, $02, $5d, $fe

Song06Data4::
    db $5e, $5e, $5e, $61, $5e, $5e, $5e, $5e, $5e, $61, $5e, $5e, $5e, $5e, $61, $61
    db $fe

Song07Data0::
    db $80, $03, $62, $ff

Song07Data1::
    db $80, $27, $62, $ff

Song07Data2::
    db $80, $03, $63, $ff

Song07Data3::
    db $80, $00, $01, $ff

Song07Data4::
    db $64, $ff

; Square 1. Melody.
Song08Data0::
    db SONG_TRANSPOSE, -13
    db $5f, $60, $5f, $60, $69, $70
    db SONG_DISABLE_CHANNEL

; Square 2. Harmony.
Song08Data1::
    db SONG_TRANSPOSE, -1
    db $65, $65, $65, $65, $65, $65, $65, $5c, $5c, $5c, $5c, $65, $65, $65
    db $65, $5c, $5c, $5c, $5c, $66
    db SONG_TRANSPOSE, -1
    db $6a, $6a, $6b, $6b, $6c
    db SONG_TRANSPOSE, -3
    db $6b
    db SONG_TRANSPOSE, -1
    db $6a
    db SONG_TRANSPOSE, -3
    db $6b
    db SONG_TRANSPOSE, -1
    db $6a, $6a, $6b, $6b, $6c
    db SONG_TRANSPOSE, -3
    db $6b
    db SONG_TRANSPOSE, -1, $6a, $6a, $fe

; Wave channel. Bass line.
Song08Data2::
    db SONG_TRANSPOSE, -1
    db $5a, $5a, $5a, $5a, $5a, $5a, $5a
    db SONG_TRANSPOSE, -6
    db $5a, $5a, $5a, $5a
    db SONG_TRANSPOSE, -1
    db $5a, $5a, $5a, $5a
    db SONG_TRANSPOSE, -6
    db $5a, $5a, $5a, $5a
    db SONG_TRANSPOSE, -1
    db $67
    db SONG_TRANSPOSE, 2
    db $5a, $5a
    db SONG_TRANSPOSE, -1
    db $5a, $5a
    db SONG_TRANSPOSE, -8
    db $5a
    db SONG_TRANSPOSE, -3
    db $5a
    db SONG_TRANSPOSE, -1
    db $6e
    db SONG_TRANSPOSE
    db $02, $5a, $5a
    db SONG_TRANSPOSE, -1
    db $5a, $5a
    db SONG_TRANSPOSE, -8
    db $5a
    db SONG_TRANSPOSE, -3
    db $5a
    db SONG_TRANSPOSE
    db $02, $5a, $5a
    db SONG_DISABLE_CHANNEL

Song08Data3::
    db SONG_TRANSPOSE, 1, $5d, SONG_DISABLE_CHANNEL

Song08Data4::
    db $a1, $07, $5e, $a0, $61, $a1, $0f, $5e, $a0, $61, $a1, $07, $5e, $a0, $61, $a1
    db $06, $5e, $a0, $68, $a1, $0f, $6d, $a0, $6f, $a1, $0f, $6d, $a0, $61, $fe

Song09Data0::
    db $80, $f8, $7a, $fe

Song09Data1::
    db $80, $04, $76, $76, $77, $77, $78, $78, $79, $79, $fe

Song09Data2::
    db $80, $04, $71, $71, $73, $73, $74, $74, $75, $75, $fe

Song09Data3::
    db $80, $01, $7b, $fe

Song09Data4::
    db $72, $fe

Song0aData0::
    db $80, $f7, $7d, $01, $ff

Song0aData1::
    db $80, $03, $03, $0b, $14, $12, $ff

Song0aData2::
    db $80, $03, $7c, $ff

Song0aData3::
    db $80, $fc, $05, $05, $05, $05, $02, $01, $ff

Song0aData4::
    db $06, $06, $13, $1f, $ff

Song0bData0::
    db $80, $04, $35, $ff

Song0bData1::
    db $80, $04, $36, $ff

Song0bData2::
    db $80, $04, $7e, $ff

Song0bData3::
    db $80, $00, $01, $ff

Song0bData4::
    db $1f, $02, $02, $02, $ff

Song0cData0::
    db $80, $00, $01, $ff

Song0cData4::
    db $ff

; $5543: Each row related to one song. Copied to SongDataRam.
; Basically each item is a high-level score for a channel (Square1, Square2, Wave, Noise, Percussion).
SongHeaderTable::
    dw Song00Data0, Song00Data1, Song00Data2, Song00Data3, Song00Data4 ; SONG_00
    dw Song01Data0, Song01Data1, Song01Data2, Song01Data3, Song01Data4 ; SONG_01
    dw Song02Data0, Song02Data1, Song02Data2, Song02Data3, Song02Data4 ; SONG_02
    dw Song03Data0, Song03Data1, Song03Data2, Song03Data3, Song03Data4 ; SONG_03
    dw Song04Data0, Song04Data1, Song04Data2, Song04Data3, Song04Data4 ; SONG_04
    dw Song05Data0, Song05Data1, Song05Data2, Song05Data3, Song05Data4 ; SONG_05
    dw Song06Data0, Song06Data1, Song06Data2, Song06Data3, Song06Data4 ; SONG_06
    dw Song07Data0, Song07Data1, Song07Data2, Song07Data3, Song07Data4 ; SONG_07
    dw Song08Data0, Song08Data1, Song08Data2, Song08Data3, Song08Data4 ; SONG_08
    dw Song09Data0, Song09Data1, Song09Data2, Song09Data3, Song09Data4 ; SONG_09
    dw Song0aData0, Song0aData1, Song0aData2, Song0aData3, Song0aData4 ; SONG_0a
    dw Song0bData0, Song0bData1, Song0bData2, Song0bData3, Song0bData4 ; SONG_0b
    dw Song0cData0, Song0cData0, Song0cData0, Song0cData0, Song0cData4 ; SONG_0c

; $55c5: 
; If Bit 7 is set, play note!
; A value in [$80, $9f] sets up the note length.
; A value of $ff reaads the next stream item.
def PART_END EQU $ff

; $55c5
Score00:
    db $a0, $a7, $00, $b0, $2d, PART_END

; $55cb
Score01:
    db $a0, $80, $3c, $00, PART_END

; $55d0
Score02:
    db $a0, $b0, $2d, $a1, $0f, $83, $34, $82, $37, $34, $37, $34, $37, $34, PART_END

; $55df
Score03:
    db $a0, $d0, $02, $50, $8f, $18, $8a, $18, $d0, $0d, $50, $85, $18, $d0, $02, $50
    db $8a, $18, $d0, $0d, $50, $85, $18, $d0, $02, $50, $8f, $18, PART_END

; $55fc
Score04:
    db $a0, $a7, $10, $a1, $03, $0f, $04, $9e, $0c
    db $13, $0c, $0c, $11, $0c, $12, $12, $0c, $0c, $09, $09, $0e, $0e, $07, $b0, $1e
    db $0c, $13, $0c, $0c, $11, $0c, $12, $12, $0c, $09, $0e, $13, $0c, $a1, $03, $0c
    db $03, $8f, $11, $11, $a1, $03, $0f, $03, $80, $3c, $0c, PART_END

; $5631
Score05:
    db $a0, $a1, $0f, $a2, $00, $8a, $3b, $85, $3b, $8a, $3b, $85, $3b, PART_END

; $563f
Score06:
    db $8f, $01, $03, $01, $03, PART_END

; $5645
Score07:
    db $a0, $d0, $18, $50, $8f, $18, $8a, $18, $d0, $23, $50, $85, $18, $d0, $18, $50
    db $8a, $18, $d0, $23, $50, $85, $18, $d0, $18, $50, $8f, $18, PART_END

; $5662
Score08:
    db $a0, $d0, $2e, $50, $8f, $18, $8a, $18, $d0, $39, $50, $85, $18, $d0, $2e, $50, $8a, $18, $d0
    db $39, $50, $85, $18, $d0, $2e, $50, $8a, $18, $d0, $39, $50, $85, $18, PART_END

; $5684
Score09:
    db $d0
    db $44, $50, $8f, $19, $8a, $19, $d0, $4f, $50, $85, $19, $d0, $44, $50, $8a, $19
    db $d0, $4f, $50, $85, $19, $d0, $44, $50, $8f, $19, PART_END

; $56a0
Score0a:
    db $d0, $5a, $50, $8f, $1a
    db $8a, $1a, $d0, $65, $50, $85, $1a, $d0, $5a, $50, $8a, $1a, $d0, $65, $50, $85
    db $1a, $d0, $5a, $50, $8f, $1a, PART_END

; $56bc
Score0b:
    db $d0, $44, $50, $8f, $17, $8a, $17, $d0, $4f
    db $50, $85, $17, $d0, $44, $50, $8a, $17, $d0, $4f, $50, $85, $17, $d0, $44, $50
    db $8a, $17, $d0, $4f, $50, $85, $17, PART_END

; $56dd
Score0c: 
    db $d0, $70, $50, $8f, $18, $8a, $18, $d0
    db $7b, $50, $85, $18, $d0, $70, $50, $8a, $18, $d0, $7b, $50, $85, $18, $d0, $70
    db $50, $8a, $18, $85, $d0, $7b, $50, $18, PART_END

; %56fe
Score0d:
    db $d0, $86, $50, $8f, $18, $8a, $18
    db $d0, $91, $50, $85, $18, $d0, $86, $50, $8a, $18, $d0, $91, $50, $85, $18, $d0
    db $86, $50, $8f, $18, PART_END

; $571a
Score0e: 
    db $a0, $a1, $14, $a2, $01, $02, $01, $a3, $00, $83, $00
    db $a6, $23, $0c, $81, $8f, $1f, $21, $9e, $24, PART_END

; $572f
Score0f:
    db $83, $27, $9b, $28, $8f, $27
    db $28, $88, $26, $96, $24, $8f, $24, $26, $24, $26, $24, $82, $25, $c0, $8d, $26
    db $c1, $88, $24, $80, $20, $21, $86, $21, $8a, $24, $8d, $1f, $96, $24, $8f, $28
    db $82, $2c, $c0, $2c, $8b, $2d, $c1, $8f, $2b, $29, $89, $28, $80, $4a, $26, $96
    db $2b, $82, $2c, $c0, $8d, $2d, $c1, $9e, $2b, $82, $2c, $c0, $9c, $2d, $c1, $8f
    db $2b, $2d, $88, $2b, $96, $28, $8f, $24, $26, $24, $26, $24, $82, $2c, $c0, $8d
    db $2d, $c1, $88, $24, $96, $24, $8f, $26, $82, $26, $c0, $27, $91, $28, $c1, $89
    db $2b, $8f, $28, $2b, $28, $87, $24, $96, $21, $8f, $1f, $80, $3c, $24, PART_END

Score10:
    db $a0
    db $d0, $0b, $51, $8e, $26, $22, $1d, $22, $80, $2a, $22, $87, $1d, $22, $8e, $26
    db $22, $21, $1f, $80, $2a, $1d, $87, $1d, $21, $8e, $24, $1d, $1d, $87, $1d, $21
    db $8e, $24, $1d, $1d, $87, $21, $24, $8e, $29, $27, $1f, $21, $80, $e0, $22, PART_END

Score11:
    db $9e, $00, $8f, $03, $81, $00, PART_END

Score12:
    db $a0, $d0, $02, $50, $80, $3c, $18, PART_END

Score13:
    db $80
    db $2d, $01, $8f, $03, PART_END

; $57ea
Score14:
    db $d0, $02, $50, $8f, $18, $8a, $18, $d0, $0d, $50, $85
    db $18, $d0, $18, $50, $8a, $18, $d0, $23, $50, $85, $18, $d0, $18, $50, $8f, $18
    db PART_END

; $5806: Weird: Unused score.
ScoreUnused:
    db $d0, $44, $50, $8a, $17, $d0, $4f, $50, $85, $17, $d0, $44, $50, $8f, $17
    db PART_END

; $5816
Score15:
    db $a0, $a7, $10, $a1, $03, $0f, $03, $9e, $07, $13, $0e, $13, $0c, $13, $0c
    db $8f, $a1, $03, $0c, $03, $0c, $09, $a1, $03, $0f, $03, $9e, $07, $13, $0e, $13
    db $0c, $07, $a1, $03, $0c, $03, $8f, $0c, $0a, $09, $07, $a1, $03, $0f, $03, $9e
    db $11, $0c, $11, $11, $0c, $13, $0e, $0e, $80, $3c, $09, $09, $0e, $a1, $03, $0c
    db $03, $8f, $0e, $0e, $13, $13, PART_END

Score16:
    db $d0, $9c, $50, $8f, $18, $8a, $18, $d0, $a7
    db $50, $85, $18, $d0, $9c, $50, $8a, $18, $d0, $a7, $50, $85, $18, $d0, $9c, $50
    db $8a, $18, $d0, $a7, $50, $85, $18, PART_END

Score17:
    db $d0, $44, $50, $80, $3c, $17, PART_END

Score18:
    db $80
    db $3c, $d0, $b2, $50, $18, $18, $d0, $5a, $50, $1a, $8f, $d0, $2e, $50, $18, $8a
    db $18, $d0, $39, $50, $85, $18, $8a, $d0, $44, $50, $17, $85, $d0, $4f, $50, $17
    db $d0, $44, $50, $8f, $17, PART_END

Score19:
    db $80, $2d, $03, $8f, $01, $80, $3c, $03, $80, $35
    db $03, $87, $04, $8f, $01, $03, $01, $03, PART_END

Score1a:
    db $a0, $b0, $0f, $a1, $14, $a2, $01
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
    db $23, $80, $44, $24, $b0, $0f, PART_END

Score1b:
    db $a0, $a7, $10, $a1, $03, $0f, $03, $9e, $0c
    db $10, $09, $10, $15, $10, $09, $10, $15, $10, $b0, $3c, PART_END

Score1c:
    db $a0, $a7, $10, $a1
    db $03, $0f, $03, $9e, $0e, $0e, $13, $13, $0c, $15, $0e, $13, $0c, $a1, $03, $0c
    db $03, $8f, $11, $11, $a1, $03, $0f, $03, $80, $3c, $0c, PART_END

Score1d:
    db $a0, $b0, $2a, $d0
    db $0b, $51, $87, $26, $25, PART_END

Score1e:
    db $d0, $5a, $50, $8f, $1a, $8a, $1a, $d0, $65, $50
    db $85, $1a, $d0, $44, $50, $8a, $17, $d0, $4f, $50, $85, $17, $d0, $44, $50, $8a
    db $17, $d0, $4f, $50, $85, $17, PART_END

Score1f:
    db $80, $3c, $01, PART_END

Score20:
    db $a0, $b0, $2d, PART_END

Score21:
    db $9c
    db $01, $01, $87, $01, $00, $03, $03, $01, $00, $03, $00, PART_END

Score22:
    db $8e, $01, $03, $01
    db $87, $03, $03, $01, $00, $03, $03, $01, $00, $03, $00, PART_END

Score23:
    db $a0, $a7, $20, $a1
    db $03, $0f, $04, $9c, $16, $11, $16, $11, $16, $11, $11, $0c, $11, $13, $14, $15
    db $11, $0c, $16, $11, $16, $15, $13, $11, $16, $15, $13, $11, PART_END

Score24:
    db $a0, $b0, $0e
    db $d0, $44, $50, $9c, $1a, $1a, $87, $1a, $1a, $8e, $1a, $1a, $b0, $0e, $d0, $44
    db $50, $9c, $1a, $1a, $d0, $18, $50, $18, $18, $d0, $18, $50, $18, $18, $87, $18
    db $18, $8e, $18, $18, $b0, $0e, $d0, $18, $50, $9c, $18, $18, $d0, $44, $50, $1a
    db $1a, $d0, $44, $50, $1a, $1a, $87, $1a, $1a, $8e, $1a, $1a, $b0, $0e, $d0, $44
    db $50, $9c, $1a, $1a, $1a, $8e, $1a, PART_END

Score25:
    db $d0, $bd, $50, $80, $40, $17, $13, $0f
    db $90, $10, $15, $19, $1e, $80, $30, $1f, $90, $1e, $80, $30, $1c, $90, $16, $80
    db $60, $17, $88, $10, $c0, $12, $13, $17, $80, $30, $18, $c1, $90, $17, $80, $30
    db $17, $90, $15, $80, $60, $10, $88, $10, $c0, $13, $16, $1c, $80, $28, $1a, $c1
    db $88, $19, $c0, $18, $17, $80, $28, $16, $c1, $88, $15, $c0, $14, $13, $90, $12
    db $c1, $15, $80, $40, $10, $88, $10, $13, $16, $1a, $80, $28, $18, $88, $17, $16
    db $15, $80, $28, $14, $88, $13, $12, $11, $90, $10, $13, $80, $60, $0e, $80, $20
    db $0e, $80, $40, $18, $80, $20, $17, $0f, $80, $40, $18, $80, $20, $17, $10, $80
    db $40, $18, $80, $20, $17, $88, $10, $12, $10, $12, $80, $40, $1b, $98, $1c, $c0
    db $84, $1a, $18, $80, $60, $17, $c1, $98, $13, $84, $c0, $12, $11, $80, $fe, $10
    db $c1, $b0, $02, PART_END

Score26:
    db $a0, $a7, $10, $a1, $03, $0c, $05, $90, $10, $17, $b0, $10
    db $17, PART_END

Score27:
    db $a0, $b0, $38, PART_END

Score28:
    db $a0, $a1, $0f, $90, $3b, PART_END

Score29:
    db $80, $40, $01, PART_END

Score2a:
    db $a0, PART_END

Score2b:
    db $90, $b0, $20, $d0, $d1, $50, $1c, $1c, PART_END

Score2c:
    db $90, $b0, $20, $a4, $3a
    db $3e, $01, $23, $23, PART_END

Score2d:
    db $d0, $dd, $50, $87, $a1, $05, $13, $a1, $0a, $1d, $a1
    db $05, $1f, $a1, $0a, $13, $a1, $05, $1a, $a1, $0a, $1f, $a1, $05, $1d, $a1, $0a
    db $1a, PART_END

Score2e:
    db $87, $a1, $05, $1a, $a1, $0a, $15, $a1, $05, $18, $a1, $0a, $1a, $a1
    db $05, $16, $a1, $0a, $18, $a1, $05, $15, $a1, $0a, $16, PART_END

Score2f:
    db $87, $a1, $05, $16
    db $a1, $0a, $19, $a1, $05, $1d, $a1, $0a, $16, $a1, $05, $18, $a1, $0a, $1d, $a1
    db $05, $19, $a1, $0a, $18, PART_END

Score30:
    db $87, $a1, $05, $15, $a1, $0a, $1d, $a1, $05, $21
    db $a1, $0a, $15, $a1, $05, $1c, $a1, $0a, $21, $a1, $05, $1d, $a1, $0a, $1c, PART_END

Score31:
    db $87, $a1, $05, $1a, $a1, $0a, $22, $a1, $05, $26, $a1, $0a, $1a, $a1, $05, $21
    db $a1, $0a, $26, $a1, $05, $22, $a1, $0a, $21, PART_END

Score32:
    db $87, $a1, $05, $1a, $a1, $0a
    db $15, $a1, $05, $18, $a1, $0a, $1a, $a1, $05, $16, $a1, $0a, $18, $a1, $05, $15
    db $a1, $0a, $16, PART_END

Score33:
    db $a0, $b0, $0e, $d0, $dd, $50, $a1, $23, $87, $26, $27, $8e
    db $26, $87, $2b, $2c, $8e, $2b, $87, $2d, $2e, $8e, $2d, $30, PART_END

Score34:
    db $b0, $0e, $87
    db $26, $27, $8e, $26, $87, $2d, $2e, $8e, $2d, $87, $26, $27, $9c, $26, PART_END

Score35:
    db $a0
    db $a1, $28, $a2, $02, $03, $01, $a3, $02, $03, $00, $a6, $13, $0c, $81, $84, $2b
    db $2d, $c0, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d
    db $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d
    db $2b, $2d, $c1, PART_END

Score36:
    db $a0, $a1, $28, $a2, $02, $03, $01, $a3, $02, $03, $00, $a6
    db $13, $0c, $81, $80, $80, $25, PART_END

Score37:
    db $b0, $0e, $87, $26, $27, $8e, $26, $27, $29
    db $2b, $2d, $2e, PART_END

Score38:
    db $b0, $0e, $87, $2e, $2d, $8e, $2e, $87, $29, $27, $8e, $29
    db $87, $25, $24, $8e, $25, $29, PART_END

Score39:
    db $b0, $0e, $87, $28, $26, $8e, $28, $87, $2d
    db $2b, $8e, $2d, $87, $31, $2f, $9c, $31, PART_END

Score3a:
    db $b0, $0e, $87, $28, $26, $8e, $28
    db $87, $2d, $2b, $8e, $2d, $87, $31, $2f, $8e, $31, $34, PART_END

Score3b:
    db $b0, $0e, $87, $32
    db $31, $8e, $32, $87, $2e, $2d, $8e, $2e, $87, $2d, $2b, $80, $2a, $2d, $87, $32
    db $31, $8e, $32, $87, $2e, $2d, $8e, $26, $28, $29, $2d, PART_END

Score3c:
    db $a0, $a1, $0f, $a2
    db $00, $87, $3b, PART_END

Score3d:
    db $9c, $01, $01, $01, $01, PART_END

Score3e:
    db $a0, $a1, $03, $13, $02, $a7
    db $10, $9c, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e
    db $8e, $0e, $0c, $0a, $09, $9c, $0a, $11, $0a, $11, $0a, $11, $0a, $11, $09, $10
    db $09, $10, $09, $10, $09, $10, $0a, $11, $0a, $11, $0a, $11, $0a, $11, $09, $10
    db $09, $10, $09, $10, $09, $10, $0e, $15, $0e, $15, $0e, $15, $8e, $0e, $0e, $10
    db $11, PART_END

Score3f:
    db $9c, $01, $01, $01, $8e, $01, $01, PART_END

Score40:
    db $a0, $a1, $0f, $90, $3b, $88
    db $3b, PART_END

Score41:
    db $80, $30, $01, $02, PART_END

Score42:
    db $a0, $a1, $03, $0f, $05, $a7, $10, $80, $28
    db $13, $98, $13, $88, $0e, $98, $10, PART_END

Score43:
    db $a0, $b0, $17, $a1, $14, $a2, $01, $02
    db $01, $a3, $02, $03, $00, $a6, $23, $0c, $81, $82, $2e, $8d, $2f, $80, $31, $2f
    db $88, $32, $82, $2e, $c0, $96, $2d, $c1, $8f, $2b, $80, $4a, $2b, $98, $2d, $87
    db $2b, $97, $2d, $90, $2b, $82, $2d, $c0, $97, $2e, $c1, $2b, $98, $2b, $88, $2d
    db $80, $33, $2b, $8f, $28, $87, $26, $91, $28, $98, $2b, $82, $2d, $c0, $2e, $94
    db $2f, $c1, $96, $32, $9a, $32, $89, $34, $8e, $32, $80, $a9, $32, $88, $32, $90
    db $34, $80, $20, $32, $90, $34, $88, $32, $90, $34, $98, $32, $96, $37, $82, $2d
    db $88, $2e, $90, $2d, $80, $50, $2b, $90, $34, $88, $32, $90, $34, $98, $32, $30
    db $81, $2d, $87, $2e, $90, $2d, $80, $20, $2b, $90, $2d, $98, $2b, $88, $2e, $90
    db $2f, $88, $2b, $90, $2e, $98, $2f, $88, $2e, $90, $2d, $88, $2b, $90, $28, $98
    db $26, $88, $28, $90, $26, $80, $c8, $2b, PART_END

Score44:
    db $d0, $c9, $50, $90, $13, $88, $1a
    db $d0, $02, $50, $90, $1f, $80, $20, $1f, $98, $1f, PART_END

Score45:
    db $d0, $c9, $50, $90, $13
    db $88, $18, $d0, $18, $50, $90, $1f, $80, $20, $1f, $98, $1f, PART_END

Score46:
    db $d0, $c9, $50
    db $90, $13, $88, $1a, $d0, $2e, $50, $90, $1d, $80, $20, $1d, $98, $1d, PART_END

Score47:
    db $d0
    db $c9, $50, $90, $13, $88, $16, $d0, $86, $50, $90, $1f, $80, $20, $1f, $98, $1f
    db PART_END

Score48:
    db $80, $30, $01, $80, $28, $02, $88, $01, PART_END

Score49:
    db $a0, $a1, $0f, $86, $39, $3b
    db $39, $39, $3b, $39, PART_END

Score4a:
    db $92, $01, $02, $01, $02, PART_END

Score4b:
    db $a0, $a1, $03, $12, $05
    db $a7, $10, $8c, $0c, $86, $0c, $92, $10, $8c, $13, $86, $13, $8c, $15, $92, $0c
    db $86, $0c, $92, $10, $8c, $13, $86, $13, $92, $15, PART_END

Score4c:
    db $8c, $0c, $86, $0c, $92
    db $10, $8c, $13, $86, $0c, $8c, $0b, $92, $0a, $86, $0a, $92, $0e, $8c, $11, $86
    db $11, $92, $13, PART_END

Score4d:
    db $8c, $0c, $86, $0c, $92, $10, $8c, $13, $86, $13, $8c, $15
    db $92, $0c, $86, $11, $8c, $12, $92, $13, $86, $13, $92, $13, PART_END

Score4e:
    db $92, $01, $02
    db $86, $01, $00, $01, $02, $03, $01, PART_END

Score4f:
    db $92, $01, $02, $86, $01, $00, $02, $01
    db $00, $02, $92, $01, $02, $01, $02, PART_END

Score50:
    db $d0, $dd, $50, $a1, $23, $8c, $1c, $86
    db $1c, $8c, $24, $86, $1c, $8c, $23, $86, $24, $8c, $1c, $86, $1c, PART_END

Score51:
    db $8c, $24
    db $86, $1c, $8c, $23, $92, $24, $24, $86, $24, PART_END

Score52:
    db $d0, $dd, $50, $a1, $23, $8c
    db $1f, $86, $1f, $8c, $28, $86, $1f, $8c, $27, $86, $28, $8c, $1f, $86, $1f, PART_END

Score53:
    db $8c, $28, $86, $1f, $8c, $27, $92, $28, $28, $86, $28, PART_END

Score54:
    db $8c, $1d, $86, $1d
    db $8c, $21, $86, $1d, $8c, $20, $86, $21, $8c, $1d, $86, $1d, PART_END

Score55:
    db $8c, $21, $86
    db $1d, $8c, $20, $92, $21, $21, $86, $21, PART_END

Score56:
    db $8c, $18, $86, $18, $8c, $24, $86
    db $18, $8c, $23, $86, $24, $8c, $18, $86, $18, PART_END

Score57:
    db $8c, $24, $86, $18, $8c, $23
    db $92, $24, $24, $86, $24, PART_END

Score58:
    db $8c, $24, $86, $1c, $8c, $1f, $92, $1f, $1f, $86
    db $1f, PART_END

Score59:
    db $8c, $28, $86, $1f, $8c, $1b, $92, $1b, $1b, $86, $1b, PART_END

; $5f63: Octave-switching melody.
Score5a:
    db $9e, $a0, $a1, $03, $0d, $05, $a7, $10, $18, $13, PART_END

Score5b:
    db $a0, $b0, $0f, $8f, $d0, $e7, $50
    db $18, $b0, $0f, $18, PART_END

Score5c:
    db $d0, $00, $50, $b0, $0f, $d0, $f3, $50, $8f, $13, $b0
    db $0f, $13, PART_END

Score5d:
    db $a0, $a1, $0f, $8a, $39, $85, $39, PART_END

Score5e:
    db $8f, $01, $01, PART_END

Score5f:
    db $d0
    db $dd, $50, $a1, $23, $8f, $24, $24, $99, $1f, PART_END

Score60:
    db $8f, $24, $24, $85, $24, $8f
    db $1f, $1f, PART_END

Score61:
    db $85, $00, $00, $01, $00, $00, $01, PART_END

Score62:
    db $d0, $bd, $50, $a6, $00
    db $00, $81, $84, $18, $c0, $17, $15, $13, $c1, $1a, $c0, $18, $17, $15, $1c, $1a
    db $18, $17, $1d, $1c, $1a, $18, $1f, $1d, $1c, $1a, $c1, $23, $c0, $21, $1f, $1d
    db $88, $18, $c1, $a0, $81, $18, PART_END

Score63:
    db $a0, $b0, $60, $a1, $03, $04, $04, $a7, $10
    db $98, $0c, PART_END

Score64:
    db $80, $60, $00, $88, $01, PART_END

Score65:
    db $d0, $00, $50, $b0, $0f, $8f, $d0
    db $9c, $50, $13, $b0, $0f, $13, PART_END

Score66:
    db $8f, $d0, $9c, $50, $13, $b0, $0f, $d0, $18
    db $50, $9e, $11, PART_END

Score67:
    db $9e, $18, $a1, $03, $1a, $05, $16, PART_END

Score68:
    db $8f, $02, $01, $85
    db $01, $00, $02, $01, $00, $00, PART_END

Score69:
    db $a0, $a1, $28, $a2, $00, $01, $01, $a3, $01
    db $83, $00, $a6, $13, $0c, $81, $8f, $27, $27, $8a, $26, $85, $27, $8a, $26, $8f
    db $24, $24, $9e, $1f, $85, $1e, $8f, $1f, $1f, $8a, $1f, $8f, $1f, $80, $3c, $23
    db $85, $1f, $8f, $23, $23, $23, $8a, $1f, $8f, $23, $23, $9e, $23, $85, $1f, $8f
    db $23, $23, $8a, $21, $85, $21, $8a, $23, $80, $3c, $24, $85, $24, $8f, $27, $27
    db $26, $8a, $26, $8f, $24, $80, $2d, $1f, $85, $1e, $8f, $1f, $1f, $8a, $1f, $8f
    db $1f, $80, $3c, $23, $85, $1f, $8f, $23, $23, $23, $8a, $1f, $8f, $23, $23, $9e
    db $23, $85, $1f, $99, $23, $85, $23, $8a, $21, $85, $21, $8a, $23, $80, $23, $24
    db $9e, $22, PART_END

Score6a:
    db $d0, $00, $50, $b0, $0f, $d0, $44, $50, $8f, $13, $b0, $0f, $13
    db PART_END

Score6b:
    db $d0, $00, $50, $b0, $0f, $d0, $86, $50, $8f, $13, $b0, $0f, $13, PART_END

Score6c:
    db $d0
    db $00, $50, $b0, $0f, $d0, PART_END

; weird: Another unused score.
ScoreUnused2:
    db $50, $8f, $11, $b0, $0f, $11, PART_END

Score6d:
    db $8f, $01, $02
    db PART_END

Score6e:
    db $9e, $1b, $18, $11, $16, PART_END

Score6f:
    db $85, $01, $00, $02, $01, $00, $02, PART_END

Score70:
    db $8f
    db $2b, $27, $80, $28, $27, $8f, $27, $27, $85, $26, $8f, $27, $28, $80, $55, $24
    db $8f, $2b, $85, $2a, $8f, $2b, $24, $9e, $24, $8f, $2b, $26, $8a, $26, $94, $2b
    db $80, $4b, $27, $8f, $2b, $2b, $2b, $2b, $27, $80, $2d, $27, $8a, $27, $85, $26
    db $8f, $27, $27, $28, $80, $55, $24, $8f, $2b, $85, $2a, $8f, $2b, $24, $9e, $24
    db $8f, $2b, $26, $8a, $26, $94, $2b, $80, $78, $27, PART_END

Score71:
    db $a0, $a1, $03, $0f, $05
    db $a7, $10, $98, $0e, $09, $0e, $09, PART_END

Score72:
    db $86, $01, $00, $03, $03, $01, $00, $03
    db $03, PART_END

Score73:
    db $10, $09, $10, $09, PART_END

Score74:
    db $11, $0c, $11, $0c, PART_END

Score75:
    db $09, $04, $09, $04
    db PART_END

Score76:
    db $a0, $b0, $0c, $d0, $9c, $50, $86, $15, $15, $b0, $0c, $15, $15, $b0, $0c
    db $15, $15, $b0, $0c, $15, $15, PART_END

Score77:
    db $a0, $b0, $0c, $d0, $02, $50, $86, $15, $15
    db $b0, $0c, $15, $15, $b0, $0c, $15, $15, $b0, $0c, $15, $15, PART_END

Score78:
    db $a0, $b0, $0c
    db $d0, $b2, $50, $86, $14, $14, $b0, $0c, $14, $14, $b0, $0c, $14, $14, $b0, $0c
    db $14, $14, PART_END

Score79:
    db $a0, $b0, $0c, $d0, $5a, $50, $86, $15, $15, $b0, $0c, $15, $15
    db $b0, $0c, $15, $15, $b0, $0c, $15, $15, PART_END

Score7a:
    db $a0, $a1, $28, $a2, $02, $03, $01
    db $a3, $02, $03, $00, $a6, $13, $0a, $81, $9e, $29, $86, $28, $26, $25, $9e, $26
    db $86, $21, $26, $28, $9e, $29, $86, $28, $26, $25, $9e, $26, $86, $21, $28, $29
    db $9e, $2b, $86, $29, $28, $26, $9e, $28, $86, $21, $28, $29, $9e, $2b, $86, $29
    db $28, $26, $9e, $28, $86, $28, $29, $2b, $9e, $2c, $86, $2b, $29, $28, $9e, $29
    db $86, $24, $29, $2b, $9e, $2c, $86, $2b, $29, $28, $9e, $29, $86, $24, $2b, $2c
    db $9e, $2d, $86, $2c, $2b, $2a, $9e, $29, $86, $28, $27, $26, $9e, $25, $86, $24
    db $23, $22, $9e, $21, $86, $21, $26, $28, PART_END

Score7b:
    db $a0, $a1, $0f, $86, $39, PART_END

Score7c:
    db $a0
    db $a1, $03, $0e, $04, $a7, $10, $9e, $0c, $09, $0e, $13, $0c, $8f, $11, $11, $80
    db $3c, $a1, $03, $06, $04, $0c, PART_END

Score7d:
    db $a0, $b0, $0a, $a1, $28, $a2, $02, $03, $01
    db $a3, $02, $03, $00, $a6, $13, $0c, $81, $82, $26, $c0, $27, $8c, $28, $c1, $84
    db $2b, $8f, $28, $2b, $28, $88, $24, $95, $21, $8f, $1f, $80, $3c, $24, PART_END

Score7e:
    db $a0
    db $a1, $03, $18, $04, $a7, $10, $80, $80, $09, PART_END

Score7f:
    db $a0, $b0, $1e, $a1, $0f, $83
    db $34, $82, $37, $34, $37, $34, $37, $34, PART_END

; $626e: Every element in this array is a pointer to an instrument setup/mini-score.
; There are 128 pointers to mini-scores in total.
InstrumentData::
    dw Score00, Score01, Score02, Score03
    dw Score04, Score05, Score06, Score07
    dw Score08, Score09, Score0a, Score0b
    dw Score0c, Score0d, Score0e, Score0f
    dw Score10, Score11, Score12, Score13
    dw Score14, Score15, Score16, Score17
    dw Score18, Score19, Score1a, Score1b
    dw Score1c, Score1d, Score1e, Score1f
    dw Score20, Score21, Score22, Score23
    dw Score24, Score25, Score26, Score27
    dw Score28, Score29, Score2a, Score2b
    dw Score2c, Score2d, Score2e, Score2f
    dw Score30, Score31, Score32, Score33
    dw Score34, Score35, Score36, Score37
    dw Score38, Score39, Score3a, Score3b
    dw Score3c, Score3d, Score3e, Score3f
    dw Score40, Score41, Score42, Score43
    dw Score44, Score45, Score46, Score47
    dw Score48, Score49, Score4a, Score4b
    dw Score4c, Score4d, Score4e, Score4f
    dw Score50, Score51, Score52, Score53
    dw Score54, Score55, Score56, Score57
    dw Score58, Score59, Score5a, Score5b
    dw Score5c, Score5d, Score5e, Score5f
    dw Score60, Score61, Score62, Score63
    dw Score64, Score65, Score66, Score67
    dw Score68, Score69, Score6a, Score6b
    dw Score6c, Score6d, Score6e, Score6f
    dw Score70, Score71, Score72, Score73
    dw Score74, Score75, Score76, Score77
    dw Score78, Score79, Score7a, Score7b
    dw Score7c, Score7d, Score7e, Score7f

; $636e: Weird: Is this function ever used?
CopyDataToWaveRam::
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
; [EventSoundPriority] = data0[N]
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
    add hl, bc                      ; hl = [EventSoundProperties + [EventSound]*2]
    ld a, [EventSoundPriority]
    cp [hl]                         ; [EventSoundPriority] - [$67cf + offset]
    jr C, :+                        ; Jump if [data_ptr] value exceeds [EventSoundPriority]
    ret nZ                          ; Return if [data_ptr] != [EventSoundPriority]
    bit 6, e                        ; Check Bit 6 of [EventSound]
    ret nZ                          ; Return if bit 6 is non zero
  : ldi a, [hl]                     ; Get data, data_ptr++
    ld [EventSoundPriority], a      ; [EventSoundPriority] = EventSoundProperties[N]
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
    ld [EventSoundPriority], a      ; = 0
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
    ld [EventSoundPriority], a    ; = 0
    ret

; $6408
.CheckAction:
    bit 7, a
    jr z, .LoadSoundRegister
    bit 5, a
    jr z, .End
    and %11111
    jr z, .CheckRepeat

; $6414
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

; $6761: Weird: Mysterious event sound that is never used! Sounds like receiving damage or so.
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

; $67cf: 2-Tuple: [EventSoundPriority, channels used by the event sound]
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

; $6812
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

; $6871: List of songs for each level.
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

; $687d
KingLouieSprites::
    INCBIN "gfx/KingLouieSprites.2bpp"

; $709d
KingLouieActionSprites::
    INCBIN "gfx/KingLouieActionSprites.2bpp"

; $78dd
ShereKhanSprites::
    INCBIN "gfx/ShereKhanSprites.2bpp"

; $7c1d
ShereKhanActionSprites::
    INCBIN "gfx/ShereKhanActionSprites.2bpp"

; $7edd: Sprites of the village girl at the end of the game.
VillageGirlSprites::
    INCBIN "gfx/VillageGirlSprites.2bpp"

; $7ffd
Bank7TailData::
    db $e0, $ff, $07