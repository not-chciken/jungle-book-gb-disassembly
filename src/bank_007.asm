SECTION "ROM Bank $007", ROMX[$4000], BANK[$7]

LoadSound0::
    jp InitSound

; $4003: Handles the currently playing sound as well as event sounds.
HandleSound::
    call HandleEventSound
    ld a, [FadeOutCounter]
    and a
    jr z, HandleSongTransition      ; Jump if [FadeOutCounter] is zero.
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
HandleSongTransition:
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
    ld de, SongDataBase

; $40b6: Sets up SongDataBase with data from SongHeaderTable. Content identical to SongDataRam.
.CopyLoop2:
    ld a, [hl+]
    ld [de], a
    inc de
    dec c
    jr nz, .CopyLoop2

    ld a, 1
    ld [Square1NoteDelayCounter], a ; = 1
    ld [Square2NoteDelayCounter], a ; = 1
    ld [WaveNoteDelayCounter], a    ; = 1
    ld [NoiseNoteDelayCounter], a   ; = 1
    ld [PercussionNoteDelayCounter], a ; = 1
    dec a
    ld [Square1Note], a             ; = 0
    ld [LegatoFlags], a             ; = 0
    ld [SquareNR12Set], a           ; = 0
    ld [SquareNR22Set], a           ; = 0
    ld [WaveNr34Trigger], a         ; = 0
    ld [WaveSoundVolume], a         ; = 0
    ld [FadeOutCounter], a          ; = 0
    ld [EventSoundChannelsUsed], a  ; = 0
    ld [$c5b9], a                   ; = 0
    ld [NoiseWaveControl], a        ; = 0
    dec a
    ld [Square1ScoreId], a          ; = $ff
    ld [Square2ScoreId], a          ; = $ff
    ld [WaveScoreId], a             ; = $ff
    ld [NoiseScoreId], a            ; = $ff
    ld [PercussionScoreId], a       ; = $ff
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
 :  ld a, [Square1ScoreId]
    cp $ff
    jr z, Square1ReadStream0
    ld a, [Square1ScorePtrLsb]
    ld l, a
    ld a, [Square1ScorePtrMsb]
    ld h, a
    jp Square1ReadScoreLoop

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
    jr z, .SetScoreId          ; Jump if data < $80

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
    jr z, Square1ReadStream1        ; Go to next stream byte if last iteration finished.
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

; $41c8:  Reached if data == $ff.
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

; $41d7: Reached if data == $fe,
.SetStreamPointerFromSongData:
    ld a, [SongDataSquare1Lsb]
    ld e, a
    ld a, [SongDataSquare1Msb]
    ld d, a
    jr Square1ReadStream1

; $41e1: Reached if $fe > data >= c0.
.SetStreamPointer:
    inc de
    ld a, [de]
    ld [SongDataSquare1Lsb], a      ; [SongDataSquare1Lsb] = [StreamPtr + 1]
    ld b, a
    inc de
    ld a, [de]
    ld [SongDataSquare1Msb], a      ; [SongDataSquare1Msb] = [StreamPtr + 2]
    ld d, a
    ld e, b                         ; de = new StreamPtr
    jr Square1ReadStream1

; $41f0: Reached if data < $80
.SetScoreId:
    and a
    jr nz, :+                       ; Jump if value is 0.
    inc de
    ld a, [de]

 :  ld [Square1ScoreId], a          ; [Square1ScoreId] = [StreamPtr + 1]
    ld l, a
    ld h, $00
    add hl, hl                      ; hl = [Square1ScoreId] * 2
    ld bc, ScoreData
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
    ld l, e                         ; hl = [ScoreData + offset]

; $420e: Now do actions based on the value of [ScoreData + offset].
Square1ReadScoreLoop:
    ld a, [hl+]
    bit 7, a
    jp z, HandleSquare1             ; Jump if value < $80.

    cp $a0
    jr nc, .Continue0               ; Jump if value >= $a0.

; $4218 : Reached if value in [$80, $9f] (see SCORE_NOTE_DELAY).
.SetSquare1NoteDelay:
    and %11111
    jr nz, :+
    ld a, [hl+]                     ; Next item sets up the note delay if first 5 bits are zero.
 :  ld [Square1NoteDelay], a
    jr Square1ReadScoreLoop

; $4222
.Continue0:
    cp $b0
    jr nc, .Continue8               ; Jump if data >= $b0.

    and $0f                         ; Reached if data in [$a0, $af].
    jr nz, .Continue1

; $422a: Reached if data == $a0 (SCORE_RESET).
.ResetSquare1:
    ld [Square1EnvelopeDataInd], a  ; = 0
    ld [Square1DutyCycleStepPeriod], a ; = 0
    ld [Square1PreNoteDuration], a  ; = 0
    ld [Square1ScaleCounterEnd], a  ; = 0
    ld [Square1SweepDelay], a       ; = 0
    ld [Square1VibratoDelay], a     ; = 0
    jr Square1ReadScoreLoop

; $423e
.Continue1:
    dec a
    jr nz, .Continue2

; $4241: Reached if data == $a1 (SCORE_SQUARE_ENVELOPE).
.SetSquare1EnvelopeDataInd:
    ld a, [hl+]
    ld [Square1EnvelopeDataInd], a
    jr Square1ReadScoreLoop

; $4247
.Continue2:
    dec a
    jr nz, .Continue3

; $424a: Reached if data == $a2 (SCORE_SQUARE_DUTY).
.SetDutyCycle:
    ld a, [hl+]
    ld [Square1DutyCycleDataIndReset], a
    ld [Square1DutyCycleDataInd], a
    ld a, [hl+]
    ld [Square1DutyCycleDataIndEnd], a
    ld a, [hl+]
    ld [Square1DutyCycleStepPeriod], a
    jr Square1ReadScoreLoop

; $426c
.Continue3:
    dec a
    jr nz, .Continue4

; $425e: Reached if data == $a3 (SCORE_SQUARE_PRE_NOTE).
.SetPreNoteAndNoteMod:
    ld a, [hl+]
    ld [Square1PreNoteDuration], a
    ld a, [hl+]
    ld [Square1NoteMod], a
    ld a, [hl+]
    ld [Square1PreNote], a
    jr Square1ReadScoreLoop

; $427d
.Continue4:
    dec a
    jr nz, .Continue5

; $426f: Reached if data == $a4 (SCORE_ARPEGGIO).
.SetArpeggio:
    ld a, [hl+]
    ld [Square1ScaleIndexReset], a
    ld a, [hl+]
    ld [Square1ScaleIndexEnd], a
    ld a, [hl+]
    ld [Square1ScaleCounterEnd], a
    jr Square1ReadScoreLoop

; $428a
.Continue5:
    dec a
    jr nz, .Continue6

; $4280: Reached if data == $a5 (SCORE_SQUARE_SWEEP).
.SetSquare1Sweep:
    ld a, [hl+]
    ld [Square1SweepValue], a
    ld a, [hl+]
    ld [Square1SweepDelay], a
    jr Square1ReadScoreLoop

; $428a
.Continue6:
    dec a
    jr nz, .Continue7

; $428d: Reached if data == $a6 (SCORE_SQUARE_VIBRATO).
.SetSquare1Vibrato:
    ld a, [hl+]
    ld [Square1Vibrato1], a
    ld a, [hl+]
    ld [Square1VibratoDelay], a
    ld a, [hl+]
    ld [Square1Vibrato2], a

; $4299: Reached if value & $f > 6.
.Continue7:                         
    jp Square1ReadScoreLoop

; $429c
.Continue8:
    cp $c0
    jr nc, .Continue9

; $42a0: Reached if value e [$b0, $c0).
.SetDelay:
    ld a, [hl+]
    ld [Square1NoteDelayCounter], a
    ld a, l
    ld [Square1ScorePtrLsb], a
    ld a, h
    ld [Square1ScorePtrMsb], a
    jp SetSquare1Registers

; $42af
.Continue9:
    cp SCORE_LEGATO + 2
    jr nc, .Continuea

; $42b3. Reached if data is $c0 or $c1.
.SetLegato:
    bit 0, a
    ld a, [LegatoFlags]
    jr z, .SetLegatoTrue

; $42ba
.SetLegatoFalse:
    res 0, a
    jr .StoreLegatoFlags

; $42be
.SetLegatoTrue:
    set 0, a

; $42c0
.StoreLegatoFlags:
    ld [LegatoFlags], a
    jp Square1ReadScoreLoop

; $42c6
.Continuea:
    cp SCORE_END
    jp z, Square1ReadStream0        ; Next element from stream if data is $ff

    cp SCORE_LOAD_POINTER
    jr nz, .Continueb

; $42cf: Reached if data == $d0 (SCORE_LOAD_POINTER).
.LoadScorePoiner:
    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    push hl
    ld h, a
    ld l, b
    jp Square1ReadScoreLoop

; $42d8
.Continueb:
    cp $d1
    jr nz, .ToMain

; $42dc
.BackToReadScoreLoop:
    pop hl
    jp Square1ReadScoreLoop

; $42e0
.ToMain:
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
    ld [Square1ScorePtrLsb], a
    ld a, h
    ld [Square1ScorePtrMsb], a
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
    ld a, [LegatoFlags]
    bit 0, a
    jr nz, .CheckEventSound

.ResetCounters:
    xor a
    ld [Square1Counter], a          ; = 0
    ld [Square1EnvelopeCounter], a  ; = 0
    ld [Square1EnvelopeToggle], a   ; = 0
    ld [Square1DutyCycleCounter], a ; = 0
    ld [Square1ScaleCounter], a     ; = 0
    ld a, [Square1ScaleIndexReset]
    ld [Square1ScaleIndex], a
    ld a, [Square1DutyCycleStepPeriod]
    bit 7, a
    jr nz, .SetSquareNR12

; $4337
.DutyCycleReset:
    ld a, [Square1DutyCycleDataIndReset]
    ld [Square1DutyCycleDataInd], a

; $433d
.SetSquareNR12:
    ld a, $80
    ld [SquareNR12Set], a           ; = $80

; $4342
.CheckEventSound:
    ld a, [Square1NoteDelay]
    ld [Square1NoteDelayCounter], a
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, SetSquare1Registers

    ld hl, EventSoundChannelsUsed
    res 0, [hl]

; $4354
SetSquare1Registers:
    ld de, Square1EnvelopeDataInd   ; Weird: Useless assignment?
    ld a, [Square1EnvelopeDataInd]
    ld de, EnvelopeData
    add e
    ld e, a
    ld a, d
    adc $00
    ld d, a
    ld hl, Square1EnvelopeCounter
    call EnvelopeSequencerStepNRx2
    ld hl, Square1DutyCycleStepPeriod
    ld a, [Square1Counter]
    ld c, a
    ld a, [Square1DutyCycleDataInd]
    ld e, a
    call StepSquareDutySequence
    ld hl, Square1ScaleCounterEnd
    ld a, [hl]
    or a
    jr z, .FreqAndDuty

; $437e
.PlayArpeggio:
    ld a, [Square1ScaleIndex]
    ld b, a
    ld a, [Square1Note]
    ld c, a
    call StepNoteArpeggio
    ld b, $00
    sla c
    rl b                        ; bc *= 2
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square1FrequencyLsb], a
    ld a, [hl]
    ld [Square1FrequencyMsb], a

; $439b
.FreqAndDuty:
    ld a, [Square1Counter]
    ld hl, Square1PreNoteDuration
    call Square1SetFreqAndDuty

; $43a4
.Vibrato;
    ld de, Square1FrequencyLsb
    ld hl, Square1VibratoBase
    ld a, [Square1Counter]
    call HandleVibrato

; $43b0
.Sweep:
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
    jp z, SetSquare2Registers

    ld a, [Square2NoteDelayCounter]
    dec a
    jr z, :+

    ld [Square2NoteDelayCounter], a ; -= 1
    jp SetSquare2Registers

 :  ld a, [Square2ScoreId]
    cp $ff
    jr z, Square2ReadStream0

    ld a, [Square2ScorePtrLsb]
    ld l, a
    ld a, [Square2ScorePtrMsb]
    ld h, a
    jp Square2ReadScoreLoop

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
    jr z, .SetScoreId

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
    jr c, .SetStreamPointer

.SetStreamPointerFromSongData:
    ld a, [SongDataSquare2Lsb]
    ld e, a
    ld a, [SongDataSquare2Msb]
    ld d, a
    jr Square2ReadStream1

; $44ae
.SetStreamPointer:
    inc de
    ld a, [de]
    ld [SongDataSquare2Lsb], a
    ld b, a
    inc de
    ld a, [de]
    ld [SongDataSquare2Msb], a
    ld d, a
    ld e, b
    jr Square2ReadStream1

; $44bd
.SetScoreId:
    and a
    jr nz, :+
    inc de
    ld a, [de]

:   ld [Square2ScoreId], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, ScoreData
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
    ld l, e                         ; hl = [ScoreData + offset]

; $44db
Square2ReadScoreLoop:
    ld a, [hl+]
    bit 7, a
    jp z, HandleSquare2

    cp $a0
    jr nc, .Continue0

; $44e5
.SetSquare2NoteDelay:
    and $1f
    jr nz, :+
    ld a, [hl+]
:   ld [Square2NoteDelay], a
    jr Square2ReadScoreLoop

; $44ef
.Continue0:
    cp $b0
    jr nc, .Continue8

    and $0f
    jr nz, .Continue1

; Reached if data == $a0
.Square2Reset:
    ld [Square2EnvelopeDataInd], a  ; = 0
    ld [Square2DutyCycleStepPeriod], a ; = 0
    ld [Square2PreNoteDuration], a  ; = 0
    ld [Square2ScaleCounterEnd], a  ; = 0
    ld [Square2SweepDelay], a       ; = 0
    ld [Square2VibratoDelay], a     ; = 0
    jr Square2ReadScoreLoop         ; = 0

; $450b
.Continue1:
    dec a
    jr nz, .Continue2

; $450e: Reached if data == $1 (SCORE_SQUARE_ENVELOPE)
.SetSquare2EnvelopeDataInd:
    ld a, [hl+]
    ld [Square2EnvelopeDataInd], a
    jr Square2ReadScoreLoop

; $4514
.Continue2:
    dec a
    jr nz, .Continue3

; $4517
.SetDutyCycle:
    ld a, [hl+]
    ld [Square2DutyCycleDataIndReset], a
    ld [Square2DutyCycleDataInd], a
    ld a, [hl+]
    ld [Square2DutyCycleDataIndEnd], a
    ld a, [hl+]
    ld [Square2DutyCycleStepPeriod], a
    jr Square2ReadScoreLoop

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
    jr Square2ReadScoreLoop

; $4539
.Continue4:
    dec a
    jr nz, .Continue5

; $426f: Reached if value & $f == 4.
.SetArpeggio:
    ld a, [hl+]
    ld [Square2ScaleIndexReset], a
    ld a, [hl+]
    ld [Square2ScaleIndexEnd], a
    ld a, [hl+]
    ld [Square2ScaleCounterEnd], a
    jr Square2ReadScoreLoop

; $454a
.Continue5:
    dec a
    jr nz, .Continue6

; $454d
.SetSquare2Sweep:
    ld a, [hl+]
    ld [Square2SweepValue], a
    ld a, [hl+]
    ld [Square2SweepDelay], a
    jr Square2ReadScoreLoop

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
    jp Square2ReadScoreLoop

; $4569
.Continue8:
    cp $c0
    jr nc, .Continue9

; $42a0
.SetDelay:
    ld a, [hl+]
    ld [Square2NoteDelayCounter], a
    ld a, l
    ld [Square2ScorePtrLsb], a
    ld a, h
    ld [Square2ScorePtrMsb], a
    jp SetSquare2Registers

; $457c
.Continue9:
    cp $c2
    jr nc, .Continuea

; $4580
.SetLegato:
    bit 0, a
    ld a, [LegatoFlags]
    jr z, .SetLegatoTrue

; $4587
.SetLegatoFalse:
    res 1, a
    jr .StoreLegatoFlags

; $458b
.SetLegatoTrue:
    set 1, a

; $458d
.StoreLegatoFlags:
    ld [LegatoFlags], a
    jp Square2ReadScoreLoop

; $4593
.Continuea:
    cp $ff
    jp z, Square2ReadStream0

    cp $d0
    jr nz, .Continueb

; Reached if data == $d0 (SCORE_LOAD_POINTER):
.LoadScorePointer:
    ld a, [hl+]
    ld b, a
    ld a, [hl+]
    push hl
    ld h, a
    ld l, b
    jp Square2ReadScoreLoop

; $45a5
.Continueb:
    cp $d1
    jr nz, .ToMain

; $45a9
.BackToReadScoreLoop:
    pop hl
    jp Square2ReadScoreLoop

; $45ad
.ToMain:
    jp Main
    jp Square2ReadStream0

; $45b3
HandleSquare2:
    ld c, a
    ld a, [Square2Tranpose]
    add c
    ld [Square2Note], a
    ld a, l
    ld [Square2ScorePtrLsb], a
    ld a, h
    ld [Square2ScorePtrMsb], a
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
    ld [$c57a], a                   ; = 0
    ld a, [LegatoFlags]
    bit 1, a
    jr nz, .CheckEventSound

    xor a
    ld [Square2Counter], a          ; = 0
    ld [Square2EnvelopeCounter], a  ; = 0
    ld [Square2EnvelopeToggle], a   ; = 0
    ld [Square2DutyCycleCounter], a ; = 0
    ld [Square2ScaleCounter], a     ; = 0
    ld a, [Square2ScaleIndexReset]
    ld [Square2ScaleIndex], a
    ld a, [Square2DutyCycleStepPeriod]
    bit 7, a
    jr nz, .SetSquareNR22

; $4604
.DutyCycleReset:
    ld a, [Square2DutyCycleDataIndReset]
    ld [Square2DutyCycleDataInd], a

; $460a
.SetSquareNR22:
    ld a, $80
    ld [SquareNR22Set], a

; $460f
.CheckEventSound:
    ld a, [Square2NoteDelay]
    ld [Square2NoteDelayCounter], a
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, SetSquare2Registers

    ld hl, EventSoundChannelsUsed
    res 1, [hl]                     ; Reset Square2 flag.

; $4621
SetSquare2Registers:
    ld de, Square2EnvelopeDataInd       ; Weird: Useless assignment?
    ld a, [Square2EnvelopeDataInd]
    ld de, EnvelopeData
    add e
    ld e, a
    ld a, d
    adc $00
    ld d, a
    ld hl, Square2EnvelopeCounter
    call EnvelopeSequencerStepNRx2
    ld hl, Square2DutyCycleStepPeriod
    ld a, [Square2Counter]
    ld c, a
    ld a, [Square2DutyCycleDataInd]
    ld e, a
    call StepSquareDutySequence
    ld hl, Square2ScaleCounterEnd
    ld a, [hl]
    or a
    jr z, .Freq

; $464b
.PlayArpeggio:
    ld a, [Square2ScaleIndex]
    ld b, a
    ld a, [Square2Note]
    ld c, a
    call StepNoteArpeggio
    ld b, $00
    sla c
    rl b
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [Square2FrequencyLsb], a
    ld a, [hl]
    ld [Square2FrequencyMsb], a

; $4668
.Freq:
    ld a, [Square2Counter]
    ld hl, Square2PreNoteDuration
    call Square2SetFreq

; $4671
.Vibrato:
    ld de, Square2FrequencyLsb
    ld hl, Square2VibratoBase
    ld a, [Square2Counter]
    call HandleVibrato

; $467d
.Sweep:
    ld de, Square2FrequencyLsb
    ld hl, Square2SweepDelay
    ld a, [Square2Counter]
    call HandleSweep
    ld a, [EventSoundChannelsUsed]
    bit 1, a
    ret nz                          ; Return if event sound uses Square2.

; $468f
.SetNr21:
    ld c, $15
    ld a, $08                       ; Weird: Useless assignment?
    inc c
    ld a, [Square2NR21]
    ldh [c], a                      ; [rNR21] = [Square2NR21]
    inc c

; $4699
.SetNr22:
    ld hl, SquareNR22Set
    bit 7, [hl]
    jr z, .SetFrequency
    ld a, [Square2NR22Value]
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
    jr z, :+

    ld [WaveCounter], a             ; [WaveCounter] += 1 

 :  ld a, [SoundCounter]
    or a
    jp z, SetWaveRegisters
    ld a, [WaveNoteDelayCounter]
    dec a
    jr z, .NoteEnded
    ld [WaveNoteDelayCounter], a
    jp SetWaveRegisters

; $46fd
.NoteEnded:
    ld a, [WaveScoreId]
    cp $ff
    jr z, WaveReadStream0

.ReadScore:
    ld a, [WaveScorePtrLsb]
    ld l, a
    ld a, [WaveScorePtrMsb]
    ld h, a
    jp WaveReadScoreLoop

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
    jr z, .SetScoreId

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
    jr c, .SetStreamPointer

; $4767
.SetStreamPointerFromSongData:
    ld a, [SongDataWave2Lsb]
    ld e, a
    ld a, [SongDataWave2Msb]
    ld d, a
    jr WaveReadStream1

; $4771
.SetStreamPointer:
    inc de
    ld a, [de]
    ld [SongDataWave2Lsb], a
    ld b, a
    inc de
    ld a, [de]
    ld [SongDataWave2Msb], a
    ld d, a
    ld e, b
    jr WaveReadStream1

; $4780
.SetScoreId:
    and a
    jr nz, :+
    inc de
    ld a, [de]
 :  ld [WaveScoreId], a
    ld l, a
    ld h, $00
    add hl, hl                      ; hl = 2 * [WaveScoreId]
    ld bc, ScoreData
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
    ld l, e                         ; hl = [ScoreData + offset]
    ld a, $80
    ld [WaveNr34Trigger], a         ; [WaveNr34Trigger] = $80

; $47a3
; data[0] == 0; delay = data[1]
; 0 < data[0] < $a0: delay = data[0]
; data[0] == $a0: reset wave
; data[0] == $a1: volume = data[0,1,2]
; data[0] == $a6: vibrato = data[0,1,2]
; data[0] == $a7: [WaveSamplePalette] = data[1]
WaveReadScoreLoop:
    ld a, [hl+]                     ; a = ScoreXX[0]
    bit 7, a
    jp z, SetUpWaveNote             ; Jump if Bit 7 is not set.

    cp $a0
    jr nc, .Continue0               ; Jump if data >= $a0

    and %11111                      ; If first 5 bits are zero, load delay from next score byte.
    jr nz, .SetWaveNoteDelay
    ld a, [hl+]                     ; a = ScoreXX[1]

; $47b2
.SetWaveNoteDelay:
    ld [WaveNoteDelay], a
    jr WaveReadScoreLoop

; $47b7
.Continue0:
    cp $b0
    jp nc, .Continue8               ; Jump if data >= $b0

; a is in [$a0, $b0)
    and %1111
    jr nz, .Continue1

; $47c0: Reached if a == $a0 (SCORE_WAVE_RESET).
.ResetWave:
    ld [WaveSoundVolumeStart], a    ; = 0
    ld [WaveVolumeHoldDelay], a     ; = 0
    ld [WaveVolumeFadeStepDelay], a ; = 0
    ld [WaveNoteChangeDelay], a     ; = 0
    ld [WaveScaleCounterEnd], a                   ; = 0
    ld [WaveSweepDelay], a          ; = 0
    ld [WaveVibratoDelay], a        ; = 0
    jr WaveReadScoreLoop

; $47d7
.Continue1:
    dec a
    jr nz, .Continue2

; $4da4: Reached if a == $a1 (SCORE_WAVE_VOLUME).
.SetUpWaveVolume:
    ld a, [hl+]
    ld [WaveSoundVolumeStart], a
    ld a, [hl+]
    ld [WaveVolumeHoldDelay], a
    ld a, [hl+]
    ld [WaveVolumeFadeStepDelay], a
    jr WaveReadScoreLoop

; $47e8
.Continue2:
    dec a
    jr nz, .Continue3

; Reached if a == $a2. Weird: useless for the wvae channel.
.SetWaveDuty:
    ld a, [hl+]
    ld [WaveDutyCycleDataIndReset], a
    ld [WaveDutyCycleDataInd], a
    ld a, [hl+]
    ld [WaveDutyCycleCounter], a
    ld a, [hl+]
    ld [WaveDutyCycleStepPeriod], a
    jr WaveReadScoreLoop

; $47fc
.Continue3:
    dec a
    jr nz, .Continue4

; Reached if a == $a3.
    ld a, [hl+]
    ld [WaveNoteChangeDelay], a
    ld a, [hl+]
    ld [WaveNoteChangeFlags], a
    ld a, [hl+]
    ld [WaveNoteOffset], a
    jr WaveReadScoreLoop

; $480d
.Continue4:
    dec a
    jr nz, .Continue5

; Reached if a == $a4 (SCORE_ARPEGGIO).
.SetArpeggio:
    ld a, [hl+]
    ld [WaveScaleIndexReset], a
    ld a, [hl+]
    ld [WaveScaleIndexEnd], a
    ld a, [hl+]
    ld [WaveScaleCounterEnd], a
    jr WaveReadScoreLoop

; $481e
.Continue5:
    dec a
    jr nz, .Continue6

; $4821: Reached if a == $a5 (SCORE_WAVE_SWEEP).
.SetWaveSweep:
    ld a, [hl+]
    ld [WaveSweepValue], a
    ld a, [hl+]
    ld [WaveSweepDelay], a
    jp WaveReadScoreLoop

; $482c
.Continue6:
    dec a
    jr nz, .Continue7

; $482f: Reached if a == $a6 (SCORE_WAVE_VIBRATO).
.SetWaveVibrato:
    ld a, [hl+]
    ld [WaveVibrato1], a
    ld a, [hl+]
    ld [WaveVibratoDelay], a
    ld a, [hl+]
    ld [WaveVibrato2], a
    jp WaveReadScoreLoop

; $483e
.Continue7:
    dec a
    jr nz, .RepeatWaveReadScoreLoop

; $4841: Reached if a == $a7 (SCORE_WAVE_SET_PALETTE).
.SetWaveSamplePalette:
    ld a, [hl+]
    ld [WaveSamplePalette], a       ; a in [$00,$10,$20]
    push hl
    call InitWaveSamples
    pop hl

; $484a
.RepeatWaveReadScoreLoop:
    jp WaveReadScoreLoop

; $484d
.Continue8:
    cp $c0
    jr nc, .Continue9

    ld a, [hl+]
    ld [WaveNoteDelayCounter], a
    ld a, l
    ld [WaveScorePtrLsb], a
    ld a, h
    ld [WaveScorePtrMsb], a
    jp SetWaveRegisters

; $4860
.Continue9:
    cp $c2
    jr nc, .Continuea

; $4864
.SetLegato:
    bit 0, a
    ld a, [LegatoFlags]
    jr z, .SetLegatoTrue

; $486b
.SetLegatoFalse:
    res 2, a
    jr .StoreLegatoFlags

; $486f
.SetLegatoTrue:
    set 2, a

; $4871
.StoreLegatoFlags:
    ld [LegatoFlags], a
    jp WaveReadScoreLoop

; $4877 Read next stream item
.Continuea:
    cp $ff
    jp z, WaveReadStream0
    jp WaveReadStream0

; $487f:
; Input: a = note to play
SetUpWaveNote:
    ld c, a
    ld a, [WaveTranspose]
    add c
    ld [WaveNote], a                ; a = input note + [WaveTranspose]
    ld a, l
    ld [WaveScorePtrLsb], a
    ld a, h
    ld [WaveScorePtrMsb], a
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
    ld a, [LegatoFlags]
    bit 2, a
    jr nz, jr_007_48db
    xor a
    ld [WaveCounter], a             ; = 0
    ld [WaveVolumeState], a         ; = 0
    ld [WaveVolumeFadeCounter], a   ; = 0
    ld [WaveDutyCycleDataIndEnd], a ; = 0
    ld [WaveScaleCounter], a        ; = 0
    ld a, $20
    ld [$c5c1], a                   ; = $20
    ld a, [WaveScaleIndexReset]
    ld [WaveScaleIndex], a
    ld a, [$c58b]
    bit 7, a
    jr nz, jr_007_48db

    ld a, [WaveDutyCycleDataIndReset]
    ld [WaveDutyCycleDataInd], a

jr_007_48db:
    ld a, [WaveNoteDelay]
    ld [WaveNoteDelayCounter], a
    ld a, [PlayingEventSound]
    bit 7, a
    jr z, SetWaveRegisters

    ld hl, EventSoundChannelsUsed
    res 2, [hl]                     ; Reset event sound wave flag.

; $48ed
SetWaveRegisters:
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
    ld [WaveNr34Trigger], a         ; [WaveNr34Trigger] = $80
    ld a, [WaveSamplePalette]
    call InitWaveSamples

jr_007_4911:
    call HandleWaveVolume
    ld hl, WaveScaleCounterEnd
    ld a, [hl]
    or a
    jr z, .Freq

; $491b
.PlayArpeggio:
    ld a, [WaveScaleIndex]
    ld b, a
    ld a, [WaveNote]
    ld c, a
    call StepNoteArpeggio
    ld b, $00
    sla c
    rl b
    ld hl, NoteToFrequencyMap
    add hl, bc
    ld a, [hl+]
    ld [WaveFrequencyLsb], a
    ld a, [hl]
    ld [WaveFrequencyMsb], a

; $4938
.Freq:
    ld a, [WaveCounter]
    ld hl, WaveNoteChangeDelay
    call SetWaveFrequency

.Vibrato:
    ld de, WaveFrequencyLsb
    ld hl, WaveVibratoBase
    ld a, [WaveCounter]
    call HandleVibrato

.Sweep:
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
    ld hl, WaveNr34Trigger
    ld a, [WaveFrequencyMsb]
    or [hl]
    ldh [c], a                      ; rNR34 = [WaveFrequencyMsb] | [WaveNr34Trigger]
    xor a
    ld [hl], a
    ret

; $498a
; Input: a = counter
;        hl[0] = WaveNoteChangeDelay
;        hl[1] = WaveNoteChangeFlags: New wave sample palette if Bit 1 is not zero.
;        hl[2] = WaveNoteOffset: New note if hl[1] Bit 1 is zero. Else this is added to [WaveNote].
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
    ld a, [hl+]                     ; a = new palette
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
HandleWaveVolume:
    ld a, [WaveVolumeState]
    bit 1, a
    ret nz                          ; Return if [WaveVolumeState] & %10
    bit 0, a
    jr nz, .CheckFade               ; Jump [WaveVolumeState] & %1

; $49c6
.SetupWaveSoundVolume:
    ld a, [WaveSoundVolumeStart]
    ld [WaveSoundVolume], a         ; = [WaveSoundVolumeStart]
    ld a, [WaveVolumeHoldDelay]
    and a
    jr nz, .CheckFadeStart

; $49d2
.NoHoldDelay:
    ld hl, WaveVolumeState
    inc [hl]                        ; [WaveVolumeState] += 1
    jr .CheckFade

; $49d8
.CheckFadeStart:
    ld hl, WaveVolumeFadeCounter
    inc [hl]                        ; [WaveVolumeFadeCounter] += 1
    xor [hl]
    ret nz                          ; Return if [WaveVolumeHoldDelay] != [WaveVolumeFadeCounter]

; $49de
.StartFade:
    ld [hl], a                      ; [WaveVolumeFadeCounter] = [WaveVolumeHoldDelay]
    ld hl, WaveVolumeState
    inc [hl]                        ; [WaveVolumeState] += 1
    ret

; $49e4
.CheckFade:
    ld a, [WaveVolumeFadeStepDelay]
    and a
    jr nz, .CheckNextFadeStep
    ld [WaveSoundVolume], a         ; = 0
    jr .NextStateAndReturn

; $49ef
.CheckNextFadeStep:
    ld hl, WaveVolumeFadeCounter
    inc [hl]
    xor [hl]
    ret nz

; $49ef
.NextFadeStep:
    ld [hl], a                      ; = 0
    ld a, [WaveSoundVolume]
    or a
    jr z, .NextStateAndReturn
    dec a
    ld [WaveSoundVolume], a         ; -= 1
    ret

; $4a01
.NextStateAndReturn:
    ld hl, WaveVolumeState
    inc [hl]                        ; [WaveVolumeState] += 1
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
    ld a, [NoiseScoreId]
    cp $ff
    jr z, NoiseReadStream0

    ld a, [NoiseScorePtrLsb]
    ld l, a
    ld a, [NoiseScorePtrMsb]
    ld h, a
    jp NoiseReadScoreLoop

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
    jr z, .SetScoreId

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
.SetScoreId:
    and a
    jr nz, :+
    inc de
    ld a, [de]

 :  ld [NoiseScoreId], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, ScoreData
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
    ld l, e                         ; hl = [ScoreData + offset]

; $4ac9
NoiseReadScoreLoop:
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
    jr NoiseReadScoreLoop

; $4add
.Continue0:
    cp $b0
    jr nc, .Continue7

    and $0f
    jr nz, .Continue1

; $4ae5: Reached if data == $a0
.ResetNoise:
    ld [$c5a8], a                   ; = 0
    ld [$c5ad], a                   ; = 0
    ld [NoiseShapeCounterThresh], a ; = 0
    jr NoiseReadScoreLoop

; $4af0
.Continue1:
    dec a
    jr nz, .Continue2

; Reached if a == $a1.
    ld a, [hl+]
    ld [$c5a8], a
    jr NoiseReadScoreLoop

; $4af9
.Continue2:
    dec a
    jr nz, .Continue3

; $4afc: Reached if a == $a2.
.SetNoiseShape1:
    ld a, [hl+]
    ld [NoiseShape1], a
    jr NoiseReadScoreLoop

; $4b02
.Continue3:
    dec a
    jr nz, .Continue4

; Reached if a == $a3.
    jr NoiseReadScoreLoop

; $4b07
.Continue4:
    dec a
    jr nz, .Continue5

; Reached if a == $a4.
    ld a, [hl+]
    ld [$c5b0], a
    ld a, [hl+]
    ld [$c5af], a
    ld a, [hl+]
    ld [$c5ad], a
    jr NoiseReadScoreLoop

; $4b18
.Continue5:
    dec a
    jr nz, .Continue6

; $4b1b: Reached if a == $a5.
.SetNoiseShapeStepAndThresh:
    ld a, [hl+]
    ld [NoiseShapeSettingStep], a
    ld a, [hl+]
    ld [NoiseShapeCounterThresh], a
    jr NoiseReadScoreLoop

; $4b25
.Continue6:
    dec a
    jr nz, :+              ; Weird: What a sick jump.
 :  jp NoiseReadScoreLoop

; $4b2b
.Continue7:
    cp $c0
    jr nc, .Continue8

.SetDelay:
    ld a, [hl+]
    ld [NoiseNoteDelayCounter], a
    ld a, l
    ld [NoiseScorePtrLsb], a
    ld a, h
    ld [NoiseScorePtrMsb], a
    jp SetNoiseRegisters

; $4b3e
.Continue8:
    cp $c2
    jr nc, .Continue9

; $4b42
.SetLegato;
    bit 0, a
    ld a, [LegatoFlags]
    jr z, .SetLegatoTrue

; $4b49
.SetLegatoFalse:
    res 3, a
    jr .StoreLegatoFlags

; $4b4d
.SetLegatoTrue:
    set 3, a

; $4b4f
.StoreLegatoFlags:
    ld [LegatoFlags], a
    jp NoiseReadScoreLoop

; $4b55
.Continue9:
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
    ld [NoiseScorePtrLsb], a
    ld a, h
    ld [NoiseScorePtrMsb], a
    ld a, [NoiseShapeSetting]
    ld l, a
    ld h, $00
    ld bc, NoiseNr43Settings
    add hl, bc
    ld a, [hl+]
    ld [NoiseShape0], a
    xor a                           ; Weird: Useless xor?
    ld a, [LegatoFlags]
    bit 3, a
    jr nz, .SetNoiseNoteDelayCounter

; $4b83
.ResetCounters:
    xor a
    ld [NoiseCounter], a            ; = 0
    ld [$c5a9], a                   ; = 0
    ld [NoiseEnvelopeToggle], a     ; = 0
    ld [$c5ae], a                   ; = 0
    ld a, [$c5b0]
    ld [NoiseNote], a
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
    ld de, EnvelopeData
    add e
    ld e, a
    ld a, d
    adc $00
    ld d, a
    ld hl, $c5a9
    call EnvelopeSequencerStepNRx2
    ld hl, $c5ad
    ld a, [hl]
    or a
    jr z, .SetNoiseNR41

; $4bc9
.PlayArpeggio:
    ld a, [NoiseNote]
    ld b, a
    ld a, [NoiseShapeSetting]
    ld c, a
    call StepNoteArpeggio
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
    ld a, [PercussionScoreId]
    cp $ff
    jr z, PercussionReadStream0

    ld a, [$c523]
    ld l, a
    ld a, [$c524]
    ld h, a
    jp PercussionReadScoreLoop

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
    jr z, .SetScoreId

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
.SetScoreId:
    and a
    jr nz, :+
    inc de
    ld a, [de]
 :  ld [PercussionScoreId], a
    ld l, a
    ld h, $00
    add hl, hl
    ld bc, ScoreData
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
    ld l, e                         ; hl = [ScoreData + offset]

; $4ce3
PercussionReadScoreLoop:
    ld a, [hl+]
    bit 7, a
    jp z, Jump_007_4cff             ; Jump if Bit 7 is not set.

    cp $a0
    jr nc, .PercussionNextStreamItem

; Reached if data < $a0.
.SetPercussionLength:
    and %11111
    jr nz, :+
    ld a, [hl+]
 :  ld [$c533], a
    jr PercussionReadScoreLoop

; $4cf7
.PercussionNextStreamItem:
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
UnusedData4dfa:
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
; Returns the next note in the arpeggio.
; Input: b = offset for ArpeggioData
;        c = note
;        hl[0] = *ScaleCounterEnd
;        hl[1] = *ScaleCounter
;        hl[4] = *ScaleIndex
; Output: c = note + [ArpeggioData + new b]
StepNoteArpeggio:
    ld de, ArpeggioData
    ld a, b
    add e
    ld e, a
    jr nc, :+
    inc d                           ; Handle LSB carry.
 :  ld a, [de]                      ; a = [ArpeggioData + b]
    add c
    ld c, a                         ; c = c + [ArpeggioData + b]
    ld a, [hl+]
    inc [hl]                        ; [hl + 1] += 1
    xor [hl]
    ret nz                          ; Return if [hl] and [hl + 1] are unequal.

.NextIndex:
    ld [hl+], a                     ; [hl + 1] = 0
    inc b                           ; b += 1
    ld a, b
    cp [hl]                         ; b - [hl + 2]
    inc hl
    jr nz, :+
    ld b, [hl]                      ; b = [hl + 3]
 :  inc hl
    ld [hl], b                      ; [hl + 4] = b
    ret

; $4e82: Input hl = Square2DutyCycleStepPeriod or Square1DutyCycleStepPeriod
;       e = [Square2DutyCycleDataInd] or [Square1DutyCycleDataInd]
;       c = counter
; Also see: *DutyCycleCounter, *DutyCycleDataIndEnd, *DutyCycleDataIndReset
StepSquareDutySequence:
    ld a, [hl+]
    or a
    ret z
    ld b, a
    ld a, LOW(SquareDutyCycleData)
    add e
    ld e, a
    ld d, HIGH(SquareDutyCycleData)
    ld a, [de]
    ld [hl+], a                     ; [hl + 1] = [SquareDutyCycleData + e]
    bit 7, b                        ; bit 7 [hl]
    jr z, .CheckCounter
    ld a, c
    or a
    jr z, .LoadNextDutyCycleValue
    ret

; $4e97
.CheckCounter:
    ld a, b                         ; a = [hl]
    inc [hl]                        ; [hl + 2]++
    xor [hl]                        ; [hl] ^ [hl + 2]
    ret nz
    ld [hl], a                      ; [hl + 2] = 0

; $4e9c
.LoadNextDutyCycleValue:
    ld a, e
    sub LOW(SquareDutyCycleData)
    inc hl
    inc a
    cp [hl]                         ; cp [hl + 3]
    inc hl
    jr nz, :+
    ld a, [hl]                      ; a = [hl + 4]
:   inc hl
    ld [hl], a                      ; [DutyCycleDataInd] = [DutyCycleDataInd] + 1 or [hl + 4]
    ret

; $4ea9: Called from noise, Square 1, and Square 2 handling.
; Input: hl = [$c541 = Square1EnvelopeCounter] [$c542 = Square1EnvelopeToggle, $c543 = SquareNR12Value, $c544 = SquareNR12Set]
;           = [$c563 = Square2EnvelopeCounter] [$c564 = Square2EnvelopeToggle, ...
;           = [$c5a9 = NoiseEnvelopeCounter] [$c5aa = NoiseEnvelopeToggle, ...
;        de = EnvelopeData + Offset
EnvelopeSequencerStepNRx2:
    ld a, [hl]
    bit 1, a
    jr nz, Pair2

    bit 0, a
    jr nz, Pair1

    ld a, [de]
    and a
    jr nz, .jr_007_4eb9             ; Jump if EnvelopeData + Offset != 0 .

    inc [hl]                        ; [EnvelopeCounter]++
    jr Pair1

; $4eb9
.jr_007_4eb9:
    inc hl                          ; hl = input + 1
    inc [hl]
    xor [hl]                        ; a = EnvelopeToggle ^ [EnvelopeData + Offset]
    jr z, .ToggleZero

; $4ebe
.ToggleNonZero:
    inc de                          ; de = [EnvelopeData + Offset + 1]
    ld a, [de]
    inc hl                          ; hl = input + 2
    ld [hl-], a                     ; [NRx2Value] = [EnvelopeData + Offset + 1]
    ld a, [hl+]
    cp 1
    ret nz

; $4ec6
.SetNRx2Set:
    inc hl                          ; hl = input + 3
    ld a, $80
    ld [hl], a                      ; [NRx2Set] = $80
    ret

; $4ecb
.ToggleZero:
    ld [hl], a                      ; [EnvelopeToggle] = 0
    dec hl
    inc [hl]                        ; ++[EnvelopeCounter]
    ret

; $4ecf
Pair1:
    inc de
    inc de                          ; de = EnvelopeData + offset + 2
    ld a, [de]                      ; a = [EnvelopeData + offset + 2]
    and a
    jr nz, jr_007_4ed8

    inc [hl]                        ; ++[EnvelopeCounter].
    jr jr_007_4ef2

; $4ed8
jr_007_4ed8:
    inc hl
    inc [hl]
    xor [hl]                        ; a = EnvelopeToggle ^ [EnvelopeData + Offse + 2t]
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

; $4eea
jr_007_4eea:
    ld [hl-], a                     ; [EnvelopeToggle] = 0
    inc [hl]                        ; ++[EnvelopeCounter]
    ret

; $4eed
Pair2:
    bit 0, a
    ret nz                          ; Return if (EnvelopeCounter & 0b11) == 0b11
    inc de
    inc de                          ; de = EnvelopeData + offset + 2

; $4ef2
jr_007_4ef2:
    inc de
    inc de                          ; de = EnvelopeData + offset + 4
    inc [hl]                        ; ++[EnvelopeCounter]
    inc hl
    inc hl
    ld a, [de]
    ld [hl+], a                     ; [*NRx2Value] = [EnvelopeData + offset + 4]
    ld a, $80
    ld [hl], a                      ; [*NRx2Set] = $80
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
; Formula: f = 2,097,152 / (2048 - frequency)
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
    dw $07e1                        ; f = 67650.1 Hz / 32 = 2114.1 Hz = C7
    dw $07e2                        ; f = 69905.1 Hz / 32 = 2184.5 Hz = C♯7
    dw $07e4                        ; f = 74898.3 Hz / 32 = 2340.6 Hz = D7
    dw $07e6                        ; f = 80659.7 Hz / 32 = 2520.6 Hz = D♯7
    dw $07e7                        ; f = 83886.1 Hz / 32 = 2621.4 Hz = E7
    dw $07e9                        ; f = 91180.5 Hz / 32 = 2849.4 Hz = F7
    dw $07ea                        ; f = 95325.1 Hz / 32 = 2978.9 Hz = F♯7
    dw $07eb                        ; f = 99864.4 Hz / 32 = 3120.8 Hz = G7
    dw $07ec                        ; f = 104857.6 Hz / 32 = 3276.8 Hz = G♯7
    dw $07ed                        ; f = 110376.4 Hz / 32 = 3449.3 Hz = A7
    dw $07ee                        ; f = 116508.4 Hz / 32 = 3640.9 Hz = A♯7
    dw $07ef                        ; f = 123361.9 Hz / 32 = 3855.1 Hz = B7

; $4fc0
NoiseNr43Settings::
    db $d7, $d6, $d5, $d4, $c7, $c6, $c5, $c4, $b7, $b6, $b5, $b4, $a7, $a6, $a5, $a4
    db $97, $96, $95, $94, $87, $86, $85, $84, $77, $76, $75, $74, $67, $66, $65, $64
    db $57, $56, $55, $54, $47, $46, $45, $44, $37, $36, $35, $34, $27, $26, $25, $24
    db $17, $16, $15, $14, $07, $06, $05, $04, $03, $02, $01, $00, $00, $00, $00, $00

    and b
    pop de

ScoreData00::
    db $a1, $05, $a2, $01, $05, $05, $a4, $00, $03, $01, $d1

ScoreData01::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $03, $06, $01, $d1

ScoreData02::
    db $a1, $05, $a2, $01, $05, $05, $a4, $06, $09, $01, $d1

ScoreData03::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $09, $0c, $01, $d1

ScoreData04::
    db $a1, $05, $a2, $01, $05, $05, $a4, $0c, $0f, $01, $d1

ScoreData05::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $0f, $12, $01, $d1

ScoreData06::
    db $a1, $05, $a2, $01, $05, $05, $a4, $12, $15, $01, $d1

ScoreData07::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $15, $18, $01, $d1

ScoreData09::
    db $a1, $05, $a2, $01, $05, $05, $a4, $18, $1b, $01, $d1

ScoreData0a::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $1b, $1e, $01, $d1

ScoreData0b::
    db $a1, $05, $a2, $01, $05, $05, $a4, $1e, $21, $01, $d1

ScoreData0c::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $21, $24, $01, $d1

ScoreData0d::
    db $a1, $05, $a2, $01, $05, $05, $a4, $24, $27, $01, $d1

ScoreData0e::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $27, $2a, $01, $d1

ScoreData0f::
    db $a1, $05, $a2, $01, $05, $05, $a4, $2a, $2d, $01, $d1

ScoreData10::
    db $a1, $0a, $a2, $00, $04, $06, $a4, $2d, $30, $01, $d1

ScoreData11::
    db $a1, $05, $a2, $01, $05, $05, $a4, $30, $33, $01, $d1

ScoreData12::
    db $a0, $a2, $02, $03, $01, $a1, $1e, $a6, $13, $10, $81

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

; $511a
EnvelopeData::
    db $00, $00, $00, $00, $00, $03, $70, $08, $10, $13, $03, $40, $03, $10, $11, $00
    db $00, $00, $00, $31, $03, $90, $28, $50, $47, $03, $90, $03, $50, $45, $02, $29
    db $40, $30, $37, $03, $70, $10, $10, $13, $03, $80, $18, $40, $47

; $5147
ArpeggioData::
    db  0, 4,  7,  7,  4,  0,  0,  5,  9,  9,  5,  0,  0,  6,  9,  9
    db  6, 0,  0,  3,  8,  8,  3,  0,  0,  3,  7,  7,  3,  0, -2,  4
    db  7, 7,  4, -2,  0,  3,  9,  9,  3,  0,  0,  5,  8,  8,  5,  0
    db  0, 4,  9,  9,  4,  0, -3,  0,  3,  7, -8, -5,  0,  4,  0,  4
    db 10, 0,  0,  0,  0,  0,  0,  0,  0

; $5190: This data is used for the square duty register.
; Upper two bits: 00 → 12.5%, 01 → 25%, 10 → 50%, 11 → 75%.
SquareDutyCycleData::
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
; *Data0: Song data used for the Square1 channel.
; *Data1: Song data used for the Square2 channel.
; *Data2: Song data used for the wave channel.
; *Data3: Song data used for the noise channel.
; If $80 > data, a new score is set up. See Score*.
; If $a0 > data >= $80 (SONG_TRANSPOSE), the next byte sets Square1Tranpose.
; If $c0 > data >= $a0 (SONG_LOOP_START) with set Bit 0 -> Next byte sets loop repeat count.
; If $c0 > data >= $a0 (SONG_LOOP_END) with no set Bit 0 -> Loop end.
; If $fe > data >= $c0 (SONG_SET_PTR), a new stream pointer is loaded from the next 2 bytes. SongDataBase is set as well.
; If data == $fe (SONG_LOAD_PTR), a new stream pointer is loaded from SongDataBase.
; If data == $ff (SONG_DISABLE_CHANNEL), the song reached its end and the channel is disabled.
;
; As you can see, in the following array, a song usually starts by setting up its transpose value.
; Then the individual scores are loaded.
SongData::

; $521b: Square1 channel. Harmony.
Song00Data0::
    db SONG_TRANSPOSE, 5
.Intro:
    db $20
.SongStart:
    db $03, $03, $07, $08, $03, $09, $0a, $17, $03, $0c, $07, $0d, $03
    db $0b, $14, $12, $0b, $0b, $03, $03, $0b, $0b, $03, $0c, $07, $16, $03, $08, $18
    db $03, $09, $09, $09, $09, $80, $02, $12
    db SONG_TRANSPOSE, 5
    db $0a, $0b, $03, $1e, $14, $12
    db SONG_SET_PTR
    dw .SongStart

; $524e: Square2 channel. Melody.
Song00Data1::
    db SONG_TRANSPOSE, -19
    db $0e, $0f, $1a
    db SONG_LOAD_PTR

; $5254: Wave channel. Bass line.
Song00Data2::
    db SONG_TRANSPOSE, 5
.Intro:
    db $00, $00
.SongStart:
    db $04, $15, $1b, $1c
    db SONG_SET_PTR
    dw .SongStart

; $525f
Song00Data3::
    db SONG_TRANSPOSE, -5
.Intro:
    db $7f
.SongStart:
    db SONG_LOOP_START, 14, $05, SONG_LOOP_END
    db $02
    db SONG_LOOP_START, 14, $05, SONG_LOOP_END
    db $01
    db SONG_LOOP_START, 24, $05, SONG_LOOP_END
    db $01, $01, $01, $05, $05, $05, $05, $05, $05
    db SONG_LOOP_START, 6, $05, SONG_LOOP_END
    db $01
    db SONG_LOOP_START, 10, $05, SONG_LOOP_END
    db $02
    db SONG_SET_PTR
    dw .SongStart

; $5286
Song00Data4::
    db $11
.SongStart:
    db SONG_LOOP_START, 7, $06, SONG_LOOP_END
    db $13
    db SONG_LOOP_START, 7, $06, SONG_LOOP_END
    db $1f
    db SONG_LOOP_START, 12, $06, SONG_LOOP_END
    db $19, $06, $06, $06, $06, $06, $1f, $06, $06, $06, $06, $06, $13
    db SONG_SET_PTR,
    dw .SongStart

Song01Data0::
    db SONG_TRANSPOSE, -4
    db $24
    db SONG_LOAD_PTR

Song01Data1::
    db SONG_TRANSPOSE, -4
    db SONG_LOOP_START, 11, $27, SONG_LOOP_END
    db $1d, $10, $1d, $10, $27
    db SONG_LOAD_PTR

Song01Data2::
    db SONG_TRANSPOSE, -4
    db $23
    db SONG_LOAD_PTR

Song01Data3::
    db SONG_TRANSPOSE, 0
    db $01
    db SONG_LOAD_PTR

Song01Data4::
    db $22
    db SONG_LOAD_PTR

Song02Data0::
    db SONG_TRANSPOSE, -8
    db $2a
    db SONG_LOOP_START, 8, $2b, SONG_LOOP_END
    db SONG_TRANSPOSE, -3
    db $2b, $2b, $2b, $2b
    db SONG_TRANSPOSE, -5
    db $2b
    db $2b, $2b, $2b
    db SONG_TRANSPOSE, -7
    db $2b, $2b, $2b, $2b
    db SONG_TRANSPOSE, -7
    db $2b, $2b
    db SONG_TRANSPOSE, -8
    db $2c, $2c
    db SONG_TRANSPOSE, -7
    db $2c, $2c
    db SONG_TRANSPOSE, -8
    db SONG_LOOP_START, 8, $2b, SONG_LOOP_END
    db SONG_LOAD_PTR

Song02Data1::
    db SONG_TRANSPOSE, 4, $25
    db SONG_LOAD_PTR

Song02Data2::
    db SONG_TRANSPOSE, -8
    db SONG_LOOP_START, 8, $26, SONG_LOOP_END
    db SONG_TRANSPOSE, -3
    db $26, $26, $26, $26
    db SONG_TRANSPOSE, -5
    db $26, $26, $26, $26
    db SONG_TRANSPOSE, -7
    db $26, $26, $26, $26
    db SONG_TRANSPOSE, -7
    db $26, $26
    db SONG_TRANSPOSE, -13
    db $26, $26
    db SONG_TRANSPOSE, -12
    db $26, $26
    db SONG_TRANSPOSE, -8
    db SONG_LOOP_START, 8, $26, SONG_LOOP_END
    db SONG_LOAD_PTR

Song02Data3::
    db SONG_TRANSPOSE, 0
    db $28
    db SONG_LOAD_PTR

Song02Data4::
    db $29
    db SONG_LOAD_PTR

Song03Data0::
    db SONG_TRANSPOSE, -12
    db SONG_LOOP_START, 7, $2d, SONG_LOOP_END
    db $2e
    db SONG_LOOP_START, 2, $2f, $2f, $2f, $2f, $30, $30, $30, $30, SONG_LOOP_END
    db $31, $31, $31, $32
    db SONG_LOAD_PTR

Song03Data1::
    db SONG_TRANSPOSE, -12
    db $33, $34, $33, $37, $38, $38, $39, $39, $38, $38, $39, $3a, $3b
    db SONG_LOAD_PTR

Song03Data2::
    db SONG_TRANSPOSE, 0
    db $3e
    db SONG_LOAD_PTR

Song03Data3::
    db SONG_TRANSPOSE, 0
    db $3c
    db SONG_LOAD_PTR

Song03Data4::
    db $3d, $3d, $3d, $3f
    db SONG_LOOP_START, 8, $3d, SONG_LOOP_END
    db $3d, $3f
    db SONG_LOAD_PTR

Song04Data0::
    db SONG_TRANSPOSE, -8
    db $44, $44
    db SONG_TRANSPOSE, -8
    db $45, $47
    db SONG_TRANSPOSE, -8
    db $44, $44
    db SONG_TRANSPOSE, -6
    db $45, $45
    db SONG_TRANSPOSE, -8
    db $44, $46
    db SONG_TRANSPOSE, -8
    db $45, $47
    db SONG_TRANSPOSE, -8
    db $44
    db SONG_TRANSPOSE, -6
    db $45
    db SONG_TRANSPOSE, -8
    db $44, $44
    db SONG_LOAD_PTR

Song04Data1::
    db SONG_TRANSPOSE, -20
    db $43
    db SONG_LOAD_PTR

Song04Data2::
    db SONG_TRANSPOSE, -8
    db $42, $42
    db SONG_TRANSPOSE, -3
    db $42, $42
    db SONG_TRANSPOSE, -8
    db $42, $42
    db SONG_TRANSPOSE, -1
    db $42, $42
    db SONG_TRANSPOSE, -8
    db $42, $42
    db SONG_TRANSPOSE, -3
    db $42, $42
    db SONG_TRANSPOSE, -8
    db $42
    db SONG_TRANSPOSE, -1
    db $42
    db SONG_TRANSPOSE, -8
    db $42, $42
    db SONG_LOAD_PTR

Song04Data3::
    db SONG_TRANSPOSE, -2,
    db $40
    db SONG_LOAD_PTR

Song04Data4::
    db $41, $41, $41, $48, $41, $48, $41, $41
    db SONG_LOAD_PTR

Song05Data0::
    db SONG_TRANSPOSE, -3
    db $52, $53, $52, $53, $56, $57, $52, $53
    db SONG_TRANSPOSE, -1
    db $56
    db SONG_TRANSPOSE, -3
    db $57
    db $52, $59
    db SONG_LOAD_PTR

Song05Data1::
    db SONG_TRANSPOSE, -3
    db $50, $51, $50, $51, $54, $55, $50, $51
    db SONG_TRANSPOSE, -1
    db $54
    db SONG_TRANSPOSE, -3
    db $55
    db $50, $58
    db SONG_LOAD_PTR

Song05Data2::
    db SONG_TRANSPOSE, -3
    db $4b, $4b
    db SONG_TRANSPOSE, 2
    db $4b
    db SONG_TRANSPOSE, -3
    db $4b
    db SONG_TRANSPOSE, 4
    db $4c
    db SONG_TRANSPOSE, -3
    db $4d
    db SONG_LOAD_PTR

Song05Data3::
    db SONG_TRANSPOSE, -4
    db $49
    db SONG_LOAD_PTR

Song05Data4::
    db $4a, $4a, $4a, $4e, $4a, $4a, $4a, $4a, $4f, $4a, $4e
    db SONG_LOAD_PTR

Song06Data0::
    db SONG_TRANSPOSE, -13
    db $5f, $60, $5f
    db SONG_TRANSPOSE, -18
    db $60, $5f, $60, $5f
    db SONG_TRANSPOSE, -13
    db $60
    db SONG_LOAD_PTR

Song06Data1::
    db SONG_TRANSPOSE, -1
    db $5b, $5b, $5b, $5c, $5c, $5c, $5c, $5b
    db SONG_LOAD_PTR

Song06Data2::
    db SONG_TRANSPOSE, -1
    db $5a, $5a, $5a
    db SONG_TRANSPOSE, -6,
    db $5a, $5a, $5a, $5a
    db SONG_TRANSPOSE, -1
    db $5a
    db SONG_LOAD_PTR

Song06Data3::
    db SONG_TRANSPOSE, 2
    db $5d
    db SONG_LOAD_PTR

Song06Data4::
    db $5e, $5e, $5e, $61, $5e, $5e, $5e, $5e, $5e, $61, $5e, $5e, $5e, $5e, $61, $61
    db SONG_LOAD_PTR

Song07Data0::
    db SONG_TRANSPOSE, 3
    db $62
    db SONG_DISABLE_CHANNEL

Song07Data1::
    db SONG_TRANSPOSE, 39
    db $62
    db SONG_DISABLE_CHANNEL

Song07Data2::
    db SONG_TRANSPOSE, 3
    db $63
    db SONG_DISABLE_CHANNEL

Song07Data3::
    db SONG_TRANSPOSE, 0
    db $01
    db SONG_DISABLE_CHANNEL

Song07Data4::
    db $64
    db SONG_DISABLE_CHANNEL

; Square 1. Melody.
Song08Data0::
    db SONG_TRANSPOSE, -13
    db $5f, $60, $5f, $60, $69, $70
    db SONG_LOAD_PTR

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
    db SONG_TRANSPOSE, -1, $6a, $6a
    db SONG_LOAD_PTR

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
    db SONG_TRANSPOSE, 2
    db $5a, $5a
    db SONG_TRANSPOSE, -1
    db $5a, $5a
    db SONG_TRANSPOSE, -8
    db $5a
    db SONG_TRANSPOSE, -3
    db $5a
    db SONG_TRANSPOSE, 2
    db $5a, $5a
    db SONG_LOAD_PTR

Song08Data3::
    db SONG_TRANSPOSE, 1
    db $5d
    db SONG_LOAD_PTR

Song08Data4::
    db SONG_LOOP_START, 7, $5e, SONG_LOOP_END
    db $61
    db SONG_LOOP_START, 15, $5e, SONG_LOOP_END
    db $61
    db SONG_LOOP_START, 7, $5e, SONG_LOOP_END
    db $61
    db SONG_LOOP_START, 6, $5e, SONG_LOOP_END
    db $68
    db SONG_LOOP_START, 15, $6d, SONG_LOOP_END
    db $6f
    db SONG_LOOP_START, 15, $6d, SONG_LOOP_END,
    db $61
    db SONG_LOAD_PTR

Song09Data0::
    db SONG_TRANSPOSE, -8,
    db $7a
    db SONG_LOAD_PTR

Song09Data1::
    db SONG_TRANSPOSE, 4
    db $76, $76, $77, $77, $78, $78, $79, $79
    db SONG_LOAD_PTR

Song09Data2::
    db SONG_TRANSPOSE, 4
    db $71, $71, $73, $73, $74, $74, $75, $75
    db SONG_LOAD_PTR

Song09Data3::
    db SONG_TRANSPOSE, 1
    db $7b
    db SONG_LOAD_PTR

Song09Data4::
    db $72
    db SONG_LOAD_PTR

Song0aData0::
    db SONG_TRANSPOSE, -9
    db $7d, $01
    db SONG_DISABLE_CHANNEL

Song0aData1::
    db SONG_TRANSPOSE, 3
    db $03, $0b, $14, $12
    db SONG_DISABLE_CHANNEL

Song0aData2::
    db SONG_TRANSPOSE, 3
    db $7c
    db SONG_DISABLE_CHANNEL

Song0aData3::
    db SONG_TRANSPOSE, -4
    db $05, $05, $05, $05, $02, $01
    db SONG_DISABLE_CHANNEL

Song0aData4::
    db $06, $06, $13, $1f
    db SONG_DISABLE_CHANNEL

Song0bData0::
    db SONG_TRANSPOSE, 4
    db $35
    db SONG_DISABLE_CHANNEL

Song0bData1::
    db SONG_TRANSPOSE, 4
    db $36
    db SONG_DISABLE_CHANNEL

Song0bData2::
    db SONG_TRANSPOSE, 4
    db $7e
    db SONG_DISABLE_CHANNEL

Song0bData3::
    db SONG_TRANSPOSE, 0
    db $01
    db SONG_DISABLE_CHANNEL

Song0bData4::
    db $1f, $02, $02, $02
    db SONG_DISABLE_CHANNEL

Song0cData0::
    db SONG_TRANSPOSE, 0
    db $01
    db SONG_DISABLE_CHANNEL

Song0cData4::
    db SONG_DISABLE_CHANNEL

; $5543: Each row related to one song. Copied to SongDataRam.
; Basically each item is a high-level score for a channel (Square1, Square2, Wave, Noise, Percussion).
SongHeaderTable::
    dw Song00Data0, Song00Data1, Song00Data2, Song00Data3, Song00Data4 ; SONG_00: "The Bare Necessities"
    dw Song01Data0, Song01Data1, Song01Data2, Song01Data3, Song01Data4 ; SONG_01: "Colonel Hathi's March"
    dw Song02Data0, Song02Data1, Song02Data2, Song02Data3, Song02Data4 ; SONG_02: "Trust in me"
    dw Song03Data0, Song03Data1, Song03Data2, Song03Data3, Song03Data4 ; SONG_03
    dw Song04Data0, Song04Data1, Song04Data2, Song04Data3, Song04Data4 ; SONG_04
    dw Song05Data0, Song05Data1, Song05Data2, Song05Data3, Song05Data4 ; SONG_05
    dw Song06Data0, Song06Data1, Song06Data2, Song06Data3, Song06Data4 ; SONG_06: "I wanna be like you"  (without melody)
    dw Song07Data0, Song07Data1, Song07Data2, Song07Data3, Song07Data4 ; SONG_07: Game over jingle
    dw Song08Data0, Song08Data1, Song08Data2, Song08Data3, Song08Data4 ; SONG_08: "I wanna be like you"
    dw Song09Data0, Song09Data1, Song09Data2, Song09Data3, Song09Data4 ; SONG_09: Boss music
    dw Song0aData0, Song0aData1, Song0aData2, Song0aData3, Song0aData4 ; SONG_0a: Outro
    dw Song0bData0, Song0bData1, Song0bData2, Song0bData3, Song0bData4 ; SONG_0b: Boss found
    dw Song0cData0, Song0cData0, Song0cData0, Song0cData0, Song0cData4 ; SONG_0c: Does nothing?

; $55c5: Array of 128 different scores.
; If Bit 7 is not set, play note!
; A value in [$80, $9f] sets up the note length using the next value in the stream.
; A value of $a0 (SCORE_RESET) performs a reset meaning that all related variables are set to 0.
; A value of $ff (SCORE_END) marks the end of a score and and the next stream item is read.
; A few things are special depending on the sound channel the score is referring to:
; SCORE_WAVE_VOLUME: Byte 0: sets up the wave channels starting volume (WaveSoundVolumeStart).
;                    Byte 1: sets up the time, after which the fade out starts (WaveVolumeHoldDelay).
;                    Byte 2: sets up the time between fade out volume decrements (WaveVolumeFadeStepDelay).
; SCORE_WAVE_SET_PALETTE: Byte 0: sets up the used wave palette (WaveSamplePalette)
; SCORE_SQUARE_SWEEP: Byte 0: *SweepValue
;                     Byte 1: *SweepDelay
Scores:

; $55c5: Wave, SONG_00
Score00:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE0
    db $b0, $2d
    db SCORE_END

; $55cb: Percussion, SONG_00
Score01:
    db SCORE_RESET
    db $80, $3c, $00
    db SCORE_END

; $55d0: Square 1, SONG_OO
Score02:
    db SCORE_RESET
    db $b0, $2d,
    db SCORE_SQUARE_ENVELOPE, $0f
    db SCORE_NOTE_DELAY | 3, $34
    db SCORE_NOTE_DELAY | 2, $37, $34, $37, $34, $37, $34
    db SCORE_END

; $55df: Square 1, SONG_OO
Score03:
    db SCORE_RESET
    db SCORE_LOAD_POINTER, $02, $50
    db SCORE_NOTE_DELAY | 15, $18
    db SCORE_NOTE_DELAY | 10, $18,
    db SCORE_LOAD_POINTER, $0d, $50
    db SCORE_NOTE_DELAY | 5, $18
    db SCORE_LOAD_POINTER, $02, $50
    db SCORE_NOTE_DELAY | 10, $18
    db SCORE_LOAD_POINTER, $0d, $50
    db SCORE_NOTE_DELAY | 5, $18
    db SCORE_LOAD_POINTER, $02, $50
    db SCORE_NOTE_DELAY | 15, $18
    db SCORE_END

; $55fc: Wave, SONG_OO
Score04:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db SCORE_WAVE_VOLUME, $03, $0f, $04
    db $9e, $0c
    db $13, $0c, $0c, $11, $0c, $12, $12, $0c, $0c, $09, $09, $0e, $0e, $07, $b0, $1e
    db $0c, $13, $0c, $0c, $11, $0c, $12, $12, $0c, $09, $0e, $13, $0c
    db SCORE_WAVE_VOLUME, $03, $0c, $03
    db $8f, $11, $11
    db SCORE_WAVE_VOLUME, $03, $0f, $03
    db $80, $3c, $0c
    db SCORE_END

; $5631: Percussion, SONG_OO
Score05:
    db SCORE_RESET
    db $a1, $0f, $a2, $00, $8a, $3b, $85, $3b, $8a, $3b, $85, $3b
    db SCORE_END

; $563f
Score06:
    db $8f, $01, $03, $01, $03
    db SCORE_END

; $5645: Square 1, SONG_OO
Score07:
    db SCORE_RESET
    db SCORE_LOAD_POINTER, $18, $50
    db $8f, $18, $8a, $18
    db SCORE_LOAD_POINTER, $23, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $18, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $23, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $18, $50
    db $8f, $18
    db SCORE_END

; $5662: Square 1, SONG_00
Score08:
    db SCORE_RESET
    db SCORE_LOAD_POINTER, $2e, $50
    db $8f, $18, $8a, $18
    db SCORE_LOAD_POINTER, $39, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $2e, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $39, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $2e, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $39, $50
    db $85, $18
    db SCORE_END

; $5684: Square 1, SONG_00
Score09:
    db SCORE_LOAD_POINTER, $44, $50
    db $8f, $19
    db $8a, $19
    db SCORE_LOAD_POINTER, $4f, $50
    db $85, $19
    db SCORE_LOAD_POINTER, $44, $50
    db $8a, $19
    db SCORE_LOAD_POINTER, $4f, $50
    db $85, $19
    db SCORE_LOAD_POINTER, $44, $50
    db $8f, $19
    db SCORE_END

; $56a0: Square 1, SONG_00
Score0a:
    db SCORE_LOAD_POINTER, $5a, $50
    db $8f, $1a
    db $8a, $1a
    db SCORE_LOAD_POINTER, $65, $50
    db $85, $1a
    db SCORE_LOAD_POINTER, $5a, $50
    db $8a, $1a
    db SCORE_LOAD_POINTER, $65, $50
    db $85, $1a
    db SCORE_LOAD_POINTER, $5a, $50
    db $8f, $1a
    db SCORE_END

; $56bc: Square 1, SONG_OO
Score0b:
    db SCORE_LOAD_POINTER, $44, $50
    db $8f, $17, $8a, $17
    db SCORE_LOAD_POINTER, $4f, $50, $85, $17
    db SCORE_LOAD_POINTER, $44, $50
    db $8a, $17
    db SCORE_LOAD_POINTER, $4f, $50
    db $85, $17
    db SCORE_LOAD_POINTER, $44, $50
    db $8a, $17
    db SCORE_LOAD_POINTER, $4f, $50
    db $85, $17
    db SCORE_END

; $56dd: Square 1, SONG_OO
Score0c:
    db SCORE_LOAD_POINTER, $70, $50
    db $8f, $18, $8a, $18
    db SCORE_LOAD_POINTER, $7b, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $70, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $7b, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $70, $50
    db $8a, $18, $85
    db SCORE_LOAD_POINTER, $7b, $50
    db $18
    db SCORE_END

; %56fe: Square 1, SONG_OO
Score0d:
    db SCORE_LOAD_POINTER, $86, $50
    db $8f, $18
    db $8a, $18
    db SCORE_LOAD_POINTER, $91, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $86, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $91, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $86, $50
    db $8f, $18
    db SCORE_END

; $571a: Square 2, SONG_OO
Score0e:
    db SCORE_RESET
    db SCORE_SQUARE_ENVELOPE, $14
    db $a2, $01, $02, $01, $a3, $00, $83, $00
    db $a6, $23, $0c, $81, $8f, $1f, $21, $9e, $24
    db SCORE_END

; $572f: Square 2, SONG_OO
Score0f:
    db $83, $27, $9b, $28, $8f, $27
    db $28, $88, $26, $96, $24, $8f, $24, $26, $24, $26, $24, $82, $25, $c0, $8d, $26
    db $c1, $88, $24, $80, $20, $21, $86, $21, $8a, $24, $8d, $1f, $96, $24, $8f, $28
    db $82, $2c, $c0, $2c, $8b, $2d, $c1, $8f, $2b, $29, $89, $28, $80, $4a, $26, $96
    db $2b, $82, $2c, $c0, $8d, $2d, $c1, $9e, $2b, $82, $2c, $c0, $9c, $2d, $c1, $8f
    db $2b, $2d, $88, $2b, $96, $28, $8f, $24, $26, $24, $26, $24, $82, $2c, $c0, $8d
    db $2d, $c1, $88, $24, $96, $24, $8f, $26, $82, $26, $c0, $27, $91, $28, $c1, $89
    db $2b, $8f, $28, $2b, $28, $87, $24, $96, $21, $8f, $1f, $80, $3c, $24
    db SCORE_END

; $57a4: Square 2, SONG_01
Score10:
    db SCORE_RESET
    db $d0, $0b, $51, $8e, $26, $22, $1d, $22, $80, $2a, $22, $87, $1d, $22, $8e, $26
    db $22, $21, $1f, $80, $2a, $1d, $87, $1d, $21, $8e, $24, $1d, $1d, $87, $1d, $21
    db $8e, $24, $1d, $1d, $87, $21, $24, $8e, $29, $27, $1f, $21, $80, $e0, $22
    db SCORE_END

; $57d5: Square 2, SONG_01
Score11:
    db $9e, $00, $8f, $03, $81, $00
    db SCORE_END

; $57dc: Square 1, SONG_OO
Score12:
    db SCORE_RESET
    db SCORE_LOAD_POINTER, $02, $50
    db $80, $3c, $18
    db SCORE_END

; $57e4
Score13:
    db $80
    db $2d, $01, $8f, $03
    db SCORE_END

; $57ea: Square 1, SONG_OO
Score14:
    db SCORE_LOAD_POINTER, $02, $50
    db $8f, $18, $8a, $18
    db SCORE_LOAD_POINTER, $0d, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $18, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $23, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $18, $50
    db $8f, $18
    db SCORE_END

; $5806: Weird: Unused score.
ScoreUnused:
    db $d0, $44, $50, $8a, $17, $d0, $4f, $50, $85, $17, $d0, $44, $50, $8f, $17
    db SCORE_END

; $5816: Wave, SONG_OO
Score15:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db SCORE_WAVE_VOLUME, $03, $0f, $03
    db $9e, $07, $13, $0e, $13, $0c, $13, $0c
    db $8f
    db SCORE_WAVE_VOLUME, $03, $0c, $03
    db $0c, $09
    db SCORE_WAVE_VOLUME, $03, $0f, $03
    db $9e, $07, $13, $0e, $13
    db $0c, $07
    db SCORE_WAVE_VOLUME, $03, $0c, $03
    db $8f, $0c, $0a, $09, $07
    db SCORE_WAVE_VOLUME, $03, $0f, $03
    db $9e
    db $11, $0c, $11, $11, $0c, $13, $0e, $0e, $80, $3c, $09, $09, $0e
    db SCORE_WAVE_VOLUME, $03, $0c, $03
    db $8f, $0e, $0e, $13, $13
    db SCORE_END

; $585c: Square 1, SONG_OO
Score16:
    db SCORE_LOAD_POINTER, $9c, $50
    db $8f, $18
    db $8a, $18
    db SCORE_LOAD_POINTER, $a7, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $9c, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $a7, $50
    db $85, $18
    db SCORE_LOAD_POINTER, $9c, $50
    db $8a, $18
    db SCORE_LOAD_POINTER, $a7, $50
    db $85, $18
    db SCORE_END

; $587d: Square 1, SONG_00
Score17:
    db SCORE_LOAD_POINTER, $44, $50
    db $80, $3c, $17
    db SCORE_END

; $5884: Square 1, SONG_OO
Score18:
    db $80, $3c
    db SCORE_LOAD_POINTER, $b2, $50
    db $18, $18
    db SCORE_LOAD_POINTER, $5a, $50
    db $1a, $8f
    db SCORE_LOAD_POINTER, $2e, $50
    db $18, $8a
    db $18
    db SCORE_LOAD_POINTER, $39, $50
    db $85, $18, $8a
    db SCORE_LOAD_POINTER, $44, $50
    db $17, $85
    db SCORE_LOAD_POINTER, $4f, $50
    db $17
    db SCORE_LOAD_POINTER, $44, $50
    db $8f, $17
    db SCORE_END

; $58ab
Score19:
    db $80, $2d, $03, $8f, $01, $80, $3c, $03, $80, $35
    db $03, $87, $04, $8f, $01, $03, $01, $03
    db SCORE_END

; $58be: Square 2, SONG_OO
Score1a:
    db SCORE_RESET, $b0, $0f
    db SCORE_SQUARE_ENVELOPE, $14
    db SCORE_SQUARE_DUTY, $01, $02, $01
    db SCORE_SQUARE_PRE_NOTE, $00, $83, $00
    db SCORE_SQUARE_VIBRATO, $23, $0c, $81
    db SCORE_NOTE_DELAY | 8, $24
    db SCORE_NOTE_DELAY | 15, $24
    db SCORE_NOTE_DELAY | 7, $23
    db SCORE_NOTE_DELAY | 15, $21
    db SCORE_NOTE_DELAY | 30, $1f
    db SCORE_NOTE_DELAY, 45, $26
    db SCORE_NOTE_DELAY | 8, $26
    db SCORE_NOTE_DELAY | 15, $26
    db SCORE_NOTE_DELAY | 7, $24
    db SCORE_NOTE_DELAY | 15, $26
    db SCORE_NOTE_DELAY | 2, $27
    db SCORE_LEGATO | 0
    db SCORE_NOTE_DELAY, 73, $28
    db SCORE_LEGATO | 1
    db SCORE_NOTE_DELAY | 8, $24
    db SCORE_NOTE_DELAY | 15, $24
    db SCORE_NOTE_DELAY | 8, $23
    db SCORE_NOTE_DELAY | 15, $21
    db SCORE_NOTE_DELAY | 30, $1f
    db SCORE_NOTE_DELAY, 45, $26
    db SCORE_NOTE_DELAY | 15, $26, $24, $26
    db SCORE_NOTE_DELAY, 75, $28
    db SCORE_NOTE_DELAY | 15, $28, $29, $2b, $2d
    db SCORE_NOTE_DELAY | 30, $2d
    db SCORE_NOTE_DELAY | 8, $29
    db SCORE_NOTE_DELAY | 22, $28
    db SCORE_NOTE_DELAY | 15, $26, $28, $29, $2b, $2b, $2b
    db SCORE_NOTE_DELAY | 8, $28
    db SCORE_NOTE_DELAY, 60, $26
    db SCORE_NOTE_DELAY | 7, $21
    db SCORE_NOTE_DELAY | 15, $28, $21
    db SCORE_NOTE_DELAY | 10, $21
    db SCORE_NOTE_DELAY | 5, $21
    db SCORE_NOTE_DELAY | 15, $21, $28, $21, $21, $21
    db SCORE_NOTE_DELAY | 10, $29
    db SCORE_NOTE_DELAY | 5, $29
    db SCORE_SQUARE_ENVELOPE, $19
    db SCORE_NOTE_DELAY | 30, $29
    db SCORE_SQUARE_ENVELOPE, $14
    db SCORE_NOTE_DELAY | 10, $28
    db SCORE_NOTE_DELAY | 5, $28
    db SCORE_NOTE_DELAY | 15, $26
    db SCORE_NOTE_DELAY | 7, $24
    db SCORE_NOTE_DELAY | 15, $23
    db SCORE_NOTE_DELAY | 5, $23
    db SCORE_SQUARE_ENVELOPE, $19
    db SCORE_NOTE_DELAY | 17, $21, $b0, $69
    db SCORE_RESET
    db SCORE_SQUARE_ENVELOPE, $05
    db SCORE_SQUARE_DUTY, $00, $01, $01
    db SCORE_SQUARE_PRE_NOTE, $05, $83, $00
    db SCORE_SQUARE_VIBRATO, $22, $08, $81
    db SCORE_NOTE_DELAY | 10, $3b, $85, $39
    db SCORE_SQUARE_ENVELOPE, $05
    db SCORE_NOTE_DELAY | 15, $3b
    db SCORE_NOTE_DELAY | 10, $3b
    db SCORE_NOTE_DELAY | 5, $39
    db SCORE_NOTE_DELAY | 10, $3b
    db SCORE_NOTE_DELAY | 15, $39
    db SCORE_NOTE_DELAY | 30, $34
    db SCORE_NOTE_DELAY | 5, $37
    db SCORE_NOTE_DELAY | 10, $36
    db SCORE_NOTE_DELAY | 5, $35
    db SCORE_NOTE_DELAY | 15, $34, $39
    db SCORE_NOTE_DELAY | 10, $39
    db SCORE_NOTE_DELAY | 5, $37
    db SCORE_NOTE_DELAY | 10, $39, $94, $37
    db SCORE_NOTE_DELAY | 15, $34
    db SCORE_RESET
    db SCORE_SQUARE_ENVELOPE, $14
    db SCORE_SQUARE_DUTY, $01, $02, $01
    db SCORE_SQUARE_PRE_NOTE, $01, $83, $00
    db SCORE_SQUARE_VIBRATO, $23, $0c, $81
    db $28, $29, $2b
    db SCORE_SQUARE_ENVELOPE, $14
    db SCORE_NOTE_DELAY | 8, $2d
    db SCORE_NOTE_DELAY | 9, $2d
    db SCORE_SQUARE_ENVELOPE, $14
    db SCORE_NOTE_DELAY | 28, $2d
    db SCORE_NOTE_DELAY | 15, $29
    db SCORE_NOTE_DELAY | 5, $28
    db SCORE_LEGATO | 0
    db $29, $28
    db SCORE_LEGATO | 1
    db SCORE_NOTE_DELAY | 15, $26, $24
    db SCORE_NOTE_DELAY | 7, $23
    db SCORE_NOTE_DELAY, $53, $24
    db SCORE_NOTE_DELAY | 15,  $23, $21
    db SCORE_NOTE_DELAY | 7, $23
    db SCORE_NOTE_DELAY, $44, $24
    db $b0, $0f
    db SCORE_END

; $59ac: Wave, SONG_OO
Score1b:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db SCORE_WAVE_VOLUME, $03, $0f, $03
    db $9e, $0c
    db $10, $09, $10, $15, $10, $09, $10, $15, $10, $b0, $3c
    db SCORE_END

; $59c1: Wave, SONG_OO
Score1c:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db SCORE_WAVE_VOLUME, $03, $0f, $03
    db $9e, $0e, $0e, $13, $13, $0c, $15, $0e, $13, $0c
    db SCORE_WAVE_VOLUME, $03, $0c
    db $03, $8f, $11, $11
    db SCORE_WAVE_VOLUME, $03, $0f, $03, $80, $3c, $0c
    db SCORE_END

; $59e1: Square 2, SONG_01
Score1d:
    db SCORE_RESET
    db $b0, $2a, SCORE_LOAD_POINTER
    db $0b, $51, $87, $26, $25
    db SCORE_END

; $59eb: Square 1, SONG_00
Score1e:
    db SCORE_LOAD_POINTER, $5a, $50
    db $8f, $1a, $8a, $1a
    db SCORE_LOAD_POINTER, $65, $50
    db $85, $1a
    db SCORE_LOAD_POINTER, $44, $50
    db $8a, $17
    db SCORE_LOAD_POINTER, $4f, $50
    db $85, $17
    db SCORE_LOAD_POINTER, $44, $50
    db $8a, $17
    db SCORE_LOAD_POINTER, $4f, $50
    db $85, $17
    db SCORE_END

; $5a0c
Score1f:
    db $80, $3c, $01
    db SCORE_END

; $5a10
Score20:
    db SCORE_RESET
    db $b0, $2d
    db SCORE_END

; $5a14
Score21:
    db $9c
    db $01, $01, $87, $01, $00, $03, $03, $01, $00, $03, $00
    db SCORE_END

; $5a21
Score22:
    db $8e, $01, $03, $01
    db $87, $03, $03, $01, $00, $03, $03, $01, $00, $03, $00
    db SCORE_END

; $5a31: Wave, SONG_01
Score23:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE2
    db SCORE_WAVE_VOLUME, $03, $0f, $04
    db $9c, $16, $11, $16, $11, $16, $11, $11, $0c, $11, $13, $14, $15
    db $11, $0c, $16, $11, $16, $15, $13, $11, $16, $15, $13, $11
    db SCORE_END

; $5a52: Square 1, SOMG_01
Score24:
    db SCORE_RESET
    db $b0, $0e
    db SCORE_LOAD_POINTER, $44, $50
    db $9c, $1a, $1a, $87, $1a, $1a, $8e, $1a, $1a, $b0, $0e
    db SCORE_LOAD_POINTER, $44, $50
    db $9c, $1a, $1a
    db SCORE_LOAD_POINTER, $18, $50
    db $18, $18
    db SCORE_LOAD_POINTER, $18, $50
    db $18, $18, $87, $18
    db $18, $8e, $18, $18, $b0, $0e
    db SCORE_LOAD_POINTER, $18, $50
    db $9c, $18, $18
    db SCORE_LOAD_POINTER, $44, $50
    db $1a, $1a
    db SCORE_LOAD_POINTER, $44, $50
    db $1a, $1a, $87, $1a, $1a, $8e, $1a, $1a, $b0, $0e
    db SCORE_LOAD_POINTER, $44, $50
    db $9c, $1a, $1a, $1a, $8e, $1a
    db SCORE_END

; $5a9d: Square 2, SONG_02
Score25:
    db SCORE_LOAD_POINTER, $bd, $50
    db $80, $40, $17, $13, $0f
    db $90, $10, $15, $19, $1e, $80, $30, $1f, $90, $1e, $80, $30, $1c, $90, $16, $80
    db $60, $17, $88, $10, $c0, $12, $13, $17, $80, $30, $18, $c1, $90, $17, $80, $30
    db $17, $90, $15, $80, $60, $10, $88, $10, $c0, $13, $16, $1c, $80, $28, $1a, $c1
    db $88, $19, $c0, $18, $17, $80, $28, $16, $c1, $88, $15, $c0, $14, $13, $90, $12
    db $c1, $15, $80, $40, $10, $88, $10, $13, $16, $1a, $80, $28, $18, $88, $17, $16
    db $15, $80, $28, $14, $88, $13, $12, $11, $90, $10, $13, $80, $60, $0e, $80, $20
    db $0e, $80, $40, $18, $80, $20, $17, $0f, $80, $40, $18, $80, $20, $17, $10, $80
    db $40, $18, $80, $20, $17, $88, $10, $12, $10, $12, $80, $40, $1b, $98, $1c, $c0
    db $84, $1a, $18, $80, $60, $17, $c1, $98, $13, $84, $c0, $12, $11, $80, $fe, $10
    db $c1, $b0, $02
    db SCORE_END

; $5b39: Wave, SONG_02
Score26:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db SCORE_WAVE_VOLUME, $03, $0c, $05
    db $90, $10, $17, $b0, $10
    db $17
    db SCORE_END

; $5b47: Square 2, SONG_01
Score27:
    db SCORE_RESET
    db $b0, $38
    db SCORE_END

; $5b4b: Noise, SONG_02
Score28:
    db SCORE_RESET
    db $a1, $0f, $90, $3b
    db SCORE_END

; $5b51
Score29:
    db $80, $40, $01
    db SCORE_END

; $5b55
Score2a:
    db SCORE_RESET
    db SCORE_END

; $5b57
Score2b:
    db $90, $b0, $20, $d0, $d1, $50, $1c, $1c
    db SCORE_END

; $5b60
Score2c:
    db $90, $b0, $20, $a4, $3a
    db $3e, $01, $23, $23
    db SCORE_END

; $5b6a
Score2d:
    db $d0, $dd, $50, $87, $a1, $05, $13, $a1, $0a, $1d, $a1
    db $05, $1f, $a1, $0a, $13, $a1, $05, $1a, $a1, $0a, $1f, $a1, $05, $1d, $a1, $0a
    db $1a
    db SCORE_END

; $5b87
Score2e:
    db $87, $a1, $05, $1a, $a1, $0a, $15, $a1, $05, $18, $a1, $0a, $1a, $a1
    db $05, $16, $a1, $0a, $18, $a1, $05, $15, $a1, $0a, $16
    db SCORE_END

; $5ba1
Score2f:
    db $87, $a1, $05, $16
    db $a1, $0a, $19, $a1, $05, $1d, $a1, $0a, $16, $a1, $05, $18, $a1, $0a, $1d, $a1
    db $05, $19, $a1, $0a, $18
    db SCORE_END

; $5bbb
Score30:
    db $87, $a1, $05, $15, $a1, $0a, $1d, $a1, $05, $21
    db $a1, $0a, $15, $a1, $05, $1c, $a1, $0a, $21, $a1, $05, $1d, $a1, $0a, $1c
    db SCORE_END

; $5bd5
Score31:
    db $87, $a1, $05, $1a, $a1, $0a, $22, $a1, $05, $26, $a1, $0a, $1a, $a1, $05, $21
    db $a1, $0a, $26, $a1, $05, $22, $a1, $0a, $21
    db SCORE_END

; $5bef
Score32:
    db $87, $a1, $05, $1a, $a1, $0a
    db $15, $a1, $05, $18, $a1, $0a, $1a, $a1, $05, $16, $a1, $0a, $18, $a1, $05, $15
    db $a1, $0a, $16
    db SCORE_END

; $5c09
Score33:
    db SCORE_RESET, $b0, $0e, $d0, $dd, $50, $a1, $23, $87, $26, $27, $8e
    db $26, $87, $2b, $2c, $8e, $2b, $87, $2d, $2e, $8e, $2d, $30
    db SCORE_END

; $5c22
Score34:
    db $b0, $0e, $87
    db $26, $27, $8e, $26, $87, $2d, $2e, $8e, $2d, $87, $26, $27, $9c, $26
    db SCORE_END

; $5c34
Score35:
    db SCORE_RESET
    db $a1, $28, $a2, $02, $03, $01, $a3, $02, $03, $00, $a6, $13, $0c, $81, $84, $2b
    db $2d, $c0, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d
    db $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d, $2b, $2d
    db $2b, $2d, $c1
    db SCORE_END

; $5c69
Score36:
    db SCORE_RESET
    db $a1, $28, $a2, $02, $03, $01, $a3, $02, $03, $00, $a6
    db $13, $0c, $81, $80, $80, $25
    db SCORE_END

; $5c7c
Score37:
    db $b0, $0e, $87, $26, $27, $8e, $26, $27, $29
    db $2b, $2d, $2e
    db SCORE_END

; $5c89
Score38:
    db $b0, $0e, $87, $2e, $2d, $8e, $2e, $87, $29, $27, $8e, $29
    db $87, $25, $24, $8e, $25, $29
    db SCORE_END

; $5c9c
Score39:
    db $b0, $0e, $87, $28, $26, $8e, $28, $87, $2d
    db $2b, $8e, $2d, $87, $31, $2f, $9c, $31
    db SCORE_END

; $5cae
Score3a:
    db $b0, $0e, $87, $28, $26, $8e, $28
    db $87, $2d, $2b, $8e, $2d, $87, $31, $2f, $8e, $31, $34
    db SCORE_END

; $5cc1
Score3b:
    db $b0, $0e, $87, $32
    db $31, $8e, $32, $87, $2e, $2d, $8e, $2e, $87, $2d, $2b, $80, $2a, $2d, $87, $32
    db $31, $8e, $32, $87, $2e, $2d, $8e, $26, $28, $29, $2d
    db SCORE_END

; $5ce1
Score3c:
    db SCORE_RESET
    db $a1, $0f, $a2
    db $00, $87, $3b
    db SCORE_END

; $5ce9
Score3d:
    db $9c, $01, $01, $01, $01
    db SCORE_END

; $5cef
Score3e:
    db SCORE_RESET
    db $a1, $03, $13, $02, $a7
    db $10, $9c, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e, $13, $0e
    db $8e, $0e, $0c, $0a, $09, $9c, $0a, $11, $0a, $11, $0a, $11, $0a, $11, $09, $10
    db $09, $10, $09, $10, $09, $10, $0a, $11, $0a, $11, $0a, $11, $0a, $11, $09, $10
    db $09, $10, $09, $10, $09, $10, $0e, $15, $0e, $15, $0e, $15, $8e, $0e, $0e, $10
    db $11
    db SCORE_END

; $5d37
Score3f:
    db $9c, $01, $01, $01, $8e, $01, $01
    db SCORE_END

; $5d3f
Score40:
    db SCORE_RESET
    db $a1, $0f, $90, $3b, $88
    db $3b
    db SCORE_END

; $5d47
Score41:
    db $80, $30, $01, $02
    db SCORE_END

; $5d4c
Score42:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_VOLUME, $03, $0f, $05
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db $80, $28
    db $13, $98, $13, $88, $0e, $98, $10
    db SCORE_END

; $5d5d
Score43:
    db SCORE_RESET
    db $b0, $17, $a1, $14, $a2, $01, $02
    db $01, $a3, $02, $03, $00, $a6, $23, $0c, $81, $82, $2e, $8d, $2f, $80, $31, $2f
    db $88, $32, $82, $2e, $c0, $96, $2d, $c1, $8f, $2b, $80, $4a, $2b, $98, $2d, $87
    db $2b, $97, $2d, $90, $2b, $82, $2d, $c0, $97, $2e, $c1, $2b, $98, $2b, $88, $2d
    db $80, $33, $2b, $8f, $28, $87, $26, $91, $28, $98, $2b, $82, $2d, $c0, $2e, $94
    db $2f, $c1, $96, $32, $9a, $32, $89, $34, $8e, $32, $80, $a9, $32, $88, $32, $90
    db $34, $80, $20, $32, $90, $34, $88, $32, $90, $34, $98, $32, $96, $37, $82, $2d
    db $88, $2e, $90, $2d, $80, $50, $2b, $90, $34, $88, $32, $90, $34, $98, $32, $30
    db $81, $2d, $87, $2e, $90, $2d, $80, $20, $2b, $90, $2d, $98, $2b, $88, $2e, $90
    db $2f, $88, $2b, $90, $2e, $98, $2f, $88, $2e, $90, $2d, $88, $2b, $90, $28, $98
    db $26, $88, $28, $90, $26, $80, $c8, $2b
    db SCORE_END

; $5dfe
Score44:
    db $d0, $c9, $50, $90, $13, $88, $1a
    db $d0, $02, $50, $90, $1f, $80, $20, $1f, $98, $1f
    db SCORE_END

; $5e10
Score45:
    db $d0, $c9, $50, $90, $13
    db $88, $18, $d0, $18, $50, $90, $1f, $80, $20, $1f, $98, $1f
    db SCORE_END

; $5e22
Score46:
    db $d0, $c9, $50
    db $90, $13, $88, $1a, $d0, $2e, $50, $90, $1d, $80, $20, $1d, $98, $1d
    db SCORE_END

; $5e34
Score47:
    db $d0
    db $c9, $50, $90, $13, $88, $16, $d0, $86, $50, $90, $1f, $80, $20, $1f, $98, $1f
    db SCORE_END

; $5e46
Score48:
    db $80, $30, $01, $80, $28, $02, $88, $01
    db SCORE_END

; $5e4f
Score49:
    db SCORE_RESET
    db $a1, $0f, $86, $39, $3b
    db $39, $39, $3b, $39
    db SCORE_END

; $5e5a
Score4a:
    db $92, $01, $02, $01, $02
    db SCORE_END

; $5e60
Score4b:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_VOLUME, $03, $12, $05
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db $8c
    db $0c, $86, $0c, $92, $10, $8c, $13, $86, $13, $8c, $15, $92, $0c
    db $86, $0c, $92, $10, $8c, $13, $86, $13, $92, $15
    db SCORE_END

; $5e80
Score4c:
    db $8c, $0c, $86, $0c, $92
    db $10, $8c, $13, $86, $0c, $8c, $0b, $92, $0a, $86, $0a, $92, $0e, $8c, $11, $86
    db $11, $92, $13
    db SCORE_END

; $5e99
Score4d:
    db $8c, $0c, $86, $0c, $92, $10, $8c, $13, $86, $13, $8c, $15
    db $92, $0c, $86, $11, $8c, $12, $92, $13, $86, $13, $92, $13
    db SCORE_END

; $5eb2
Score4e:
    db $92, $01, $02
    db $86, $01, $00, $01, $02, $03, $01
    db SCORE_END

; $5ebd
Score4f:
    db $92, $01, $02, $86, $01, $00, $02, $01
    db $00, $02, $92, $01, $02, $01, $02
    db SCORE_END

; $5ecd
Score50:
    db $d0, $dd, $50, $a1, $23, $8c, $1c, $86
    db $1c, $8c, $24, $86, $1c, $8c, $23, $86, $24, $8c, $1c, $86, $1c
    db SCORE_END

; $5ee3
Score51:
    db $8c, $24
    db $86, $1c, $8c, $23, $92, $24, $24, $86, $24
    db SCORE_END

; $5eef
Score52:
    db $d0, $dd, $50, $a1, $23, $8c
    db $1f, $86, $1f, $8c, $28, $86, $1f, $8c, $27, $86, $28, $8c, $1f, $86, $1f
    db SCORE_END

; $5f05
Score53:
    db $8c, $28, $86, $1f, $8c, $27, $92, $28, $28, $86, $28
    db SCORE_END

; $5f11
Score54:
    db $8c, $1d, $86, $1d
    db $8c, $21, $86, $1d, $8c, $20, $86, $21, $8c, $1d, $86, $1d
    db SCORE_END

; $5f22
Score55:
    db $8c, $21, $86
    db $1d, $8c, $20, $92, $21, $21, $86, $21
    db SCORE_END

; $5f2e
Score56:
    db $8c, $18, $86, $18, $8c, $24, $86
    db $18, $8c, $23, $86, $24, $8c, $18, $86, $18
    db SCORE_END

; $5f3f
Score57:
    db $8c, $24, $86, $18, $8c, $23
    db $92, $24, $24, $86, $24
    db SCORE_END

; $5f4b
Score58:
    db $8c, $24, $86, $1c, $8c, $1f, $92, $1f, $1f, $86
    db $1f
    db SCORE_END

; $5f57
Score59:
    db $8c, $28, $86, $1f, $8c, $1b, $92, $1b, $1b, $86, $1b
    db SCORE_END

; $5f63: 5-1 melody for wave.
Score5a:
    db SCORE_WAVE_LENGTH | 30
    db SCORE_WAVE_RESET
    db SCORE_WAVE_VOLUME, $03, $0d, $05
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db $18, $13
    db SCORE_END

; $5f6e
Score5b:
    db SCORE_RESET
    db $b0, $0f, $8f, $d0, $e7, $50
    db $18, $b0, $0f, $18
    db SCORE_END

; $5f7a
Score5c:
    db $d0, $00, $50, $b0, $0f, $d0, $f3, $50, $8f, $13, $b0
    db $0f, $13
    db SCORE_END

; $5f88
Score5d:
    db SCORE_RESET, $a1, $0f, $8a, $39, $85, $39
    db SCORE_END

; $5f90
Score5e:
    db $8f, $01, $01
    db SCORE_END

; $5f94
Score5f:
    db $d0
    db $dd, $50, $a1, $23, $8f, $24, $24, $99, $1f
    db SCORE_END

; $5f9f
Score60:
    db $8f, $24, $24, $85, $24, $8f
    db $1f, $1f
    db SCORE_END

; $5fa8
Score61:
    db $85, $00, $00, $01, $00, $00, $01
    db SCORE_END

; $5fb0
Score62:
    db $d0, $bd, $50, $a6, $00
    db $00, $81, $84, $18, $c0, $17, $15, $13, $c1, $1a, $c0, $18, $17, $15, $1c, $1a
    db $18, $17, $1d, $1c, $1a, $18, $1f, $1d, $1c, $1a, $c1, $23, $c0, $21, $1f, $1d
    db $88, $18, $c1, SCORE_RESET, $81, $18
    db SCORE_END

; $5fdc
Score63:
    db SCORE_WAVE_RESET
    db $b0, $60,
    db SCORE_WAVE_VOLUME, $03, $04, $04
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db $98
    db $0c
    db SCORE_END

; $5fe8
Score64:
    db $80, $60, $00, $88, $01
    db SCORE_END

; $5fee
Score65:
    db $d0, $00, $50, $b0, $0f, $8f, $d0
    db $9c, $50, $13, $b0, $0f, $13
    db SCORE_END

; $5ffc
Score66:
    db $8f, $d0, $9c, $50, $13, $b0, $0f, $d0, $18
    db $50, $9e, $11
    db SCORE_END

; $6009
Score67:
    db $9e, $18, $a1, $03, $1a, $05, $16
    db SCORE_END

; $6011
Score68:
    db $8f, $02, $01, $85
    db $01, $00, $02, $01, $00, $00
    db SCORE_END

; $601c
Score69:
    db SCORE_RESET
    db $a1, $28, $a2, $00, $01, $01, $a3, $01
    db $83, $00, $a6, $13, $0c, $81, $8f, $27, $27, $8a, $26, $85, $27, $8a, $26, $8f
    db $24, $24, $9e, $1f, $85, $1e, $8f, $1f, $1f, $8a, $1f, $8f, $1f, $80, $3c, $23
    db $85, $1f, $8f, $23, $23, $23, $8a, $1f, $8f, $23, $23, $9e, $23, $85, $1f, $8f
    db $23, $23, $8a, $21, $85, $21, $8a, $23, $80, $3c, $24, $85, $24, $8f, $27, $27
    db $26, $8a, $26, $8f, $24, $80, $2d, $1f, $85, $1e, $8f, $1f, $1f, $8a, $1f, $8f
    db $1f, $80, $3c, $23, $85, $1f, $8f, $23, $23, $23, $8a, $1f, $8f, $23, $23, $9e
    db $23, $85, $1f, $99, $23, $85, $23, $8a, $21, $85, $21, $8a, $23, $80, $23, $24
    db $9e, $22
    db SCORE_END

Score6a:
    db $d0, $00, $50, $b0, $0f, $d0, $44, $50, $8f, $13, $b0, $0f, $13
    db SCORE_END

Score6b:
    db $d0, $00, $50, $b0, $0f, $d0, $86, $50, $8f, $13, $b0, $0f, $13
    db SCORE_END

Score6c:
    db $d0
    db $00, $50, $b0, $0f, $d0
    db SCORE_END

; Weird: Another unused score.
ScoreUnused2:
    db $50, $8f, $11, $b0, $0f, $11
    db SCORE_END

Score6d:
    db $8f, $01, $02
    db SCORE_END

Score6e:
    db $9e, $1b, $18, $11, $16
    db SCORE_END

Score6f:
    db $85, $01, $00, $02, $01, $00, $02
    db SCORE_END

Score70:
    db $8f
    db $2b, $27, $80, $28, $27, $8f, $27, $27, $85, $26, $8f, $27, $28, $80, $55, $24
    db $8f, $2b, $85, $2a, $8f, $2b, $24, $9e, $24, $8f, $2b, $26, $8a, $26, $94, $2b
    db $80, $4b, $27, $8f, $2b, $2b, $2b, $2b, $27, $80, $2d, $27, $8a, $27, $85, $26
    db $8f, $27, $27, $28, $80, $55, $24, $8f, $2b, $85, $2a, $8f, $2b, $24, $9e, $24
    db $8f, $2b, $26, $8a, $26, $94, $2b, $80, $78, $27
    db SCORE_END

Score71:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_VOLUME, $03, $0f, $05
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db $98
    db $0e, $09, $0e, $09
    db SCORE_END

Score72:
    db $86, $01, $00, $03, $03, $01, $00, $03
    db $03
    db SCORE_END

Score73:
    db $10, $09, $10, $09
    db SCORE_END

Score74:
    db $11, $0c, $11, $0c
    db SCORE_END

Score75:
    db $09, $04, $09, $04
    db SCORE_END

Score76:
    db SCORE_RESET
    db $b0, $0c, $d0, $9c, $50, $86, $15, $15, $b0, $0c, $15, $15, $b0, $0c
    db $15, $15, $b0, $0c, $15, $15
    db SCORE_END

Score77:
    db SCORE_RESET
    db $b0, $0c, $d0, $02, $50, $86, $15, $15
    db $b0, $0c, $15, $15, $b0, $0c, $15, $15, $b0, $0c, $15, $15
    db SCORE_END

Score78:
    db SCORE_RESET
    db $b0, $0c
    db $d0, $b2, $50, $86, $14, $14, $b0, $0c, $14, $14, $b0, $0c, $14, $14, $b0, $0c
    db $14, $14
    db SCORE_END

Score79:
    db SCORE_RESET
    db $b0, $0c, $d0, $5a, $50, $86, $15, $15, $b0, $0c, $15, $15
    db $b0, $0c, $15, $15, $b0, $0c, $15, $15
    db SCORE_END

Score7a:
    db SCORE_RESET
    db $a1, $28, $a2, $02, $03, $01
    db $a3, $02, $03, $00, $a6, $13, $0a, $81, $9e, $29, $86, $28, $26, $25, $9e, $26
    db $86, $21, $26, $28, $9e, $29, $86, $28, $26, $25, $9e, $26, $86, $21, $28, $29
    db $9e, $2b, $86, $29, $28, $26, $9e, $28, $86, $21, $28, $29, $9e, $2b, $86, $29
    db $28, $26, $9e, $28, $86, $28, $29, $2b, $9e, $2c, $86, $2b, $29, $28, $9e, $29
    db $86, $24, $29, $2b, $9e, $2c, $86, $2b, $29, $28, $9e, $29, $86, $24, $2b, $2c
    db $9e, $2d, $86, $2c, $2b, $2a, $9e, $29, $86, $28, $27, $26, $9e, $25, $86, $24
    db $23, $22, $9e, $21, $86, $21, $26, $28
    db SCORE_END

Score7b:
    db SCORE_RESET, $a1, $0f, $86, $39
    db SCORE_END

Score7c:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_VOLUME, $03, $0e, $04
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db $9e, $0c, $09, $0e, $13, $0c, $8f, $11, $11, $80
    db $3c, $a1, $03, $06, $04, $0c
    db SCORE_END

Score7d:
    db SCORE_RESET,
    db $b0, $0a, $a1, $28, $a2, $02, $03, $01
    db $a3, $02, $03, $00, $a6, $13, $0c, $81, $82, $26, $c0, $27, $8c, $28, $c1, $84
    db $2b, $8f, $28, $2b, $28, $88, $24, $95, $21, $8f, $1f, $80, $3c, $24
    db SCORE_END

Score7e:
    db SCORE_WAVE_RESET
    db SCORE_WAVE_VOLUME, $03, $18, $04
    db SCORE_WAVE_SET_PALETTE, SCORE_WAVE_PALETTE1
    db $80, $80, $09
    db SCORE_END

Score7f:
    db SCORE_RESET
    db $b0, $1e, $a1, $0f, $83
    db $34, $82, $37, $34, $37, $34, $37, $34
    db SCORE_END

; $626e: Every element in this array is a pointer to an instrument setup/mini-score.
; There are 128 pointers to mini-scores in total.
ScoreData::
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
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR43), $70
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $60
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $50
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $40
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $30
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $20
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR42), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $646c
EventSoundDataStone::
    db LOW(rNR12), $00
    db LOW(rNR42), $0a
    db LOW(rNR43), $60
    db LOW(rNR44), $80
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR12), $a1
    db LOW(rNR42), $a1
    db LOW(rNR10), $3b
    db LOW(rNR11), $80
    db LOW(rNR43), $20
    db LOW(rNR44), $80
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 4
    db LOW(rNR12), $00
    db LOW(rNR42), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $648d
EventSoundDataJump::
    db LOW(rNR42), $00
    db LOW(rNR12), $80
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR13), LOW(rNR42)
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR13), $39
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $6b
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $7b
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $64c8
EventSoundDataLand::
    db LOW(rNR12), $00
    db LOW(rNR42), $81
    db LOW(rNR43), $78
    db LOW(rNR44), $80
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR42), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

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
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_START | 10  ; Repeat start.
    db LOW(rNR43), $50
    db LOW(rNR13), $e5
    db LOW(rNR14), $04
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $40
    db LOW(rNR13), $0b
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_END         ; Repeat end.
    db LOW(rNR12), $00
    db LOW(rNR42), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $64fe
EventSoundTeleportEnd::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $a4
    db LOW(rNR11), $80
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $06
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $652d
EventSoundTeleportStart::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $a4
    db LOW(rNR11), $80
    db LOW(rNR13), $39
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $9d
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $655c
EventSoundDataDamage::
    db LOW(rNR42), $00
    db LOW(rNR12), $a2
    db LOW(rNR10), $2a
    db LOW(rNR11), $80
    db LOW(rNR13), $0b
    db LOW(rNR14), $86
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR11), $00
    db LOW(rNR12), $82
    db LOW(rNR10), $1f
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 8
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $6579
EventSoundDataDied::
    db LOW(rNR42), $00
    db LOW(rNR10), $45
    db LOW(rNR12), $a5
    db LOW(rNR11), $80
    db LOW(rNR13), $0b
    db LOW(rNR14), $86
    db EVENT_SOUND_LENGTH, 8
    db LOW(rNR10), $00
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $f7
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $e7
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR13), $d6
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR13), $c4
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR13), $b2
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR13), $9e
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR13), $89
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR13), $72
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $5b
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $42
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 4
    db LOW(rNR13), $27,
    db LOW(rNR14), $06
    db EVENT_SOUND_LENGTH, 5
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $65d4
EventSoundDataEnemyHit::
    db LOW(rNR42), $00
    db LOW(rNR12), $a2
    db LOW(rNR10), $3a
    db LOW(rNR11), $00
    db LOW(rNR13), $63
    db LOW(rNR14), $85
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR13), $16
    db LOW(rNR14), $84
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR10), $55
    db LOW(rNR13), $b2
    db LOW(rNR14), $86
    db EVENT_SOUND_LENGTH, 4
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $65f3
EventSoundDataHopOnEnemy::
    db LOW(rNR42), $00
    db LOW(rNR12), $a8
    db LOW(rNR10), $3a
    db LOW(rNR11), $80
    db LOW(rNR13), $63
    db LOW(rNR14), $85
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR11), $00
    db LOW(rNR10), $34
    db LOW(rNR13), $16
    db LOW(rNR14), $84
    db EVENT_SOUND_LENGTH, 8
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

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
    db EVENT_SOUND_LENGTH, 4
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $6623
EventSoundDataBossDefeated::
    db LOW(rNR42), $00
    db LOW(rNR12), $a0
    db LOW(rNR11), $80
    db LOW(rNR10), $3a
    db LOW(rNR13), $63
    db LOW(rNR14), $85
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR11), $00
    db LOW(rNR10), $34
    db LOW(rNR13), $16
    db LOW(rNR14), $84
    db EVENT_SOUND_LENGTH, 8
    db LOW(rNR10), $3c
    db EVENT_SOUND_LENGTH, 8
    db LOW(rNR12), $87
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $c1
    db LOW(rNR14), $87
    db EVENT_SOUND_LOOP_START | 10  ; Repeat start.
    db LOW(rNR13), $e1
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $be
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $b6
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $ac
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $a2
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_END         ; Repeat end.
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $666c
EventSoundDataItemCollected::
    db LOW(rNR42), $00
    db LOW(rNR12), $81
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $668f
EventSoundDataLevelComplete::
    db LOW(rNR42), $00
    db LOW(rNR12), $86
    db LOW(rNR10), $00
    db LOW(rNR11), $80
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $06
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $59
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 3
    db EVENT_SOUND_LOOP_START | 8   ; Repeat start.
    db LOW(rNR13), $59
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR13), $83
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_END         ; Repeat end.
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $66c0
EventSoundDataLevelExplosion::
    db LOW(rNR12), $00
    db LOW(rNR42), $f4
    db LOW(rNR43), $79
    db LOW(rNR44), $80
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_START | 16  ; Repeat start.
    db LOW(rNR43), $7f
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $6d
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $73
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_END         ; Repeat end.
    db LOW(rNR42), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

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
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $44
    db LOW(rNR14), $07
    db EVENT_SOUND_LENGTH, 0
    db EVENT_SOUND_LOOP_END
    db LOW(rNR12), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $66f8
EventSoundDataSnakeShot::
    db LOW(rNR12), $00
    db LOW(rNR42), $a2
    db LOW(rNR43), $71
    db LOW(rNR44), $80
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $31
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $51
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR43), $71
    db EVENT_SOUND_LENGTH, 0
    db EVENT_SOUND_LOOP_START | 10  ; Repeat start.
    db LOW(rNR43), $11
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $31
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_END         ; Repeat end.
    db LOW(rNR42), $00
    db EVENT_SOUND_END              ; 0 -> End of sound.

; $671b:
EventSoundDataElephantShot::
    db LOW(rNR12), $00
    db LOW(rNR42), $60
    db LOW(rNR43), $71
    db LOW(rNR44), $80
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR43), $61
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $51
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $41
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $31
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $21
    db EVENT_SOUND_LENGTH, 4
    db LOW(rNR43), $31
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $41
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR43), $51
    db EVENT_SOUND_LENGTH, 3
    db LOW(rNR43), $61
    db EVENT_SOUND_LENGTH, 4
    db LOW(rNR43), $71
    db EVENT_SOUND_LENGTH, 8
    db LOW(rNR42), $00
    db EVENT_SOUND_END

; $6750
EventSoundDataCrocJaw::
    db LOW(rNR12), $00
    db LOW(rNR42), $91
    db LOW(rNR43), $69
    db LOW(rNR44), $80
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR43), $41
    db EVENT_SOUND_LENGTH, 6
    db LOW(rNR42), $00
    db EVENT_SOUND_END

; $6761: Weird: Mysterious event sound that is never used! Sounds like receiving damage or so.
; Set [EventSound] to EVENT_SOUND_UNKNOWN to get an audial impression.
EventSoundDataUnknown::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $a5
    db LOW(rNR11), $40
    db LOW(rNR13), $07
    db LOW(rNR14), $81
    db EVENT_SOUND_LOOP_START | 8   ; Start repeat.
    db LOW(rNR13), $07
    db LOW(rNR14), $01
    db EVENT_SOUND_LENGTH, 0
    db LOW(rNR13), $9b
    db LOW(rNR14), $03
    db EVENT_SOUND_LENGTH, 1
    db EVENT_SOUND_LOOP_END         ; End repeat.
    db LOW(rNR12), $00
    db EVENT_SOUND_END

; $677e
EventSoundDataOutOfTime::
    db LOW(rNR42), $00
    db LOW(rNR10), $00
    db LOW(rNR12), $81
    db LOW(rNR11), $80
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 2
    db LOW(rNR13), $c1
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 6
    db LOW(rNR12), $42
    db LOW(rNR13), $83
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 1
    db LOW(rNR13), $c1
    db LOW(rNR14), $87
    db EVENT_SOUND_LENGTH, 6
    db LOW(rNR12), $00
    db EVENT_SOUND_END

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
UnusedData67fb:
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

; $685f: Stores value from [LevelSongs + current level] into CurrentSong2
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
    db SONG_00                      ; Level 2: "The Bare Necessities"
    db SONG_01                      ; Level 3: "Colonel Hathi's March"
    db SONG_03                      ; Level 4: What song is this?
    db SONG_04                      ; Level 5: What song is this?
    db SONG_02                      ; Level 6: "Trust in me" (or something alike)
    db SONG_00                      ; Level 7: "The Bare Necessities"
    db SONG_06                      ; Level 8: "I wanna be like you"  (without melody)
    db SONG_02                      ; Level 9: "Trust in me" (or something alike)
    db SONG_03                      ; Level 10: What song is this?
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

; $7ffd: Unused data at the end of Bank 7.
Bank7TailData::
    db $e0, $ff, $07