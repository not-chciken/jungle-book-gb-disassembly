SECTION "TitleScreenStrings", ROMX[$75d3], BANK[2]

charmap "(", $f4
charmap ")", $f4
charmap "?", $f5
charmap ":", $f6

NintendoLicenseString::
db "LICENSED BY NINTENDO",0  ; $175d3
PresentsString::
db "PRESENTS",0              ; $175e8

MenuString:: ; $175f1
db "(C)1994 THE WALT\r"
db "   DISNEY COMPANY\r",
db "\r"
db "   (C)1994 VIRGIN\r",
db "    INTERACTIVE\r",
db "   ENTERTAINMENT\r",
db "\r"
db "DEVELOPED BY EUROCOM\r"
db "\r"
db "PRESS START TO BEGIN\r"
db "  LEVEL : NORMAL  ",0

PracticeString::
db "PRACTICE",0             ; $17687

SECTION "LevelNameString", ROMX[$7690], BANK[2]

JungleByDayString::
db "JUNGLE BY DAY",0        ; $17690
TheGreatTreeString::
db "THE GREAT TREE",0       ; $1769e
DawnPatrolString::
db " DAWN PATROL",0         ; $176ad
ByTheRiverString::
db "BY THE RIVER",0         ; $176ba
InTheRiverString::
db "IN THE RIVER",0         ; $176c7
TreeVillageString::
db "TREE VILLAGE",0         ; $176d4
AncientRuinString::
db "ANCIENT RUINS",0        ; $176e1
FallingRuinsString::
db "FALLING RUINS",0        ; $176ef
JungleByNightString::
db "JUNGLE BY NIGHT",0      ; $176fd
TheWastelandsString::
db "THE WASTELANDS",0       ; $1770d

; $ 1771c: Pointers to the level strings from above.
LevelStringPointers::
dw JungleByDayString, TheGreatTreeString, DawnPatrolString, ByTheRiverString
dw InTheRiverString, TreeVillageString, AncientRuinString, FallingRuinsString
dw JungleByNightString, TheWastelandsString

SECTION "CreditScreenStrings", ROMX[$7730], BANK[2]

; $17730: The credits you see at the end of the game.
CreditString::
db "EUROCOM DEVELOPMENTS"
db "\r\r"
db "DESIGN: MAT SNEAP\r"
db "        DAVE LOOKER\r"
db "        JON WILLIAMS\r"
db "CODING: DAVE LOOKER\r"
db "GRAPHX: MAT SNEAP\r"
db "        COL GARRATT\r"
db "SOUNDS: NEIL BALDWIN\r"
db "UTILS : TIM ROGERS\r"
db "\r"
db "     VIRGIN US\r"
db "\r"
db "PRODUCER: ROBB ALVEY\r"
db "ASSISTANT:KEN LOVE\r"
db "QA:       MIKE MCCAA\r"
db "\r"
db "DISNEY:   P GILMORE", 0

SECTION "GameStrings", ROMX[$7846], BANK[2]
LevelString::
db "LEVEL ", 0 ; $17846
CompletedString::
db "COMPLETED", 0 ; $1784d
GetReadyString::
db "GET READY", 0 ; $17857
GameOverString::
db "GAME OVER", 0 ; $17861
WellDoneString::
db "WELL DONE", 0 ; $1786b
ContinueString::
db "CONTINUE?", 0 ; $17875

; $178cf: LZ77 compressed data of the status window at the bottom.
SECTION "CompressedStatusWindowData", ROMX[$78cf], BANK[2]
CompressedStatusWindowData::
db $80,$02,$de,$01,$00,$01,$31,$04,$e3,$41,$43,$25,$00,$fa,$19,$13
db $19,$13,$13,$06,$a8,$02,$01,$61,$02,$b3,$07,$44,$ee,$44,$42,$c6
db $00,$c6,$06,$01,$22,$18,$2c,$18,$3e,$34,$34,$63,$01,$63,$03,$c5
db $00,$14,$18,$08,$18,$28,$10,$30,$10,$30,$13,$31,$d3,$22,$80,$88
db $c7,$1c,$cb,$19,$18,$10,$0c,$18,$07,$9c,$07,$83,$31,$80,$84,$82
db $01,$03,$03,$07,$82,$06,$c2,$87,$a6,$08,$20,$c2,$f1,$d7,$33,$36
db $30,$30,$20,$30,$20,$70,$20,$60,$0c,$10,$d1,$60,$f0,$b1,$b8,$13
db $39,$19,$1b,$30,$2b,$80,$20,$b0,$11,$0f,$06,$9e,$89,$b8,$91,$21
db $b1,$01,$b1,$33,$31,$33,$11,$33,$12,$3b,$12,$0e,$12,$0e,$18,$04
db $18,$00,$80,$46,$06,$01,$03,$02,$01,$02,$a1,$00,$80,$15,$80,$29
db $00,$15,$46,$00,$68,$0e,$04,$0c,$cb,$99,$c7,$1c,$00,$c0,$82,$c3
db $83,$c1,$81,$d8,$8c,$98,$8f,$8c,$0b,$06,$a1,$22,$00,$48,$c4,$c8
db $7c,$de,$3e,$ca,$0c,$08,$04,$08,$04,$0c,$00,$0c,$0e,$40,$27,$24
db $00,$30,$10,$30,$70,$20,$e6,$43,$c7,$52,$08,$10,$0d,$44,$12,$0e
db $20,$20,$31,$10,$30,$20,$30,$14,$02,$90,$10,$20,$30,$06,$81,$5c
db $f0,$6c,$ee,$44,$c0,$46,$8e,$c4,$3c,$c8,$78,$0b,$01,$22,$77,$22
db $3e,$16,$16,$04,$0e,$04,$0c,$0c,$14,$18,$00,$18,$47,$21,$1f,$c5
db $40,$c0,$47,$cc,$47,$c0,$47,$c8,$87,$22,$58,$09,$11,$4e,$80,$1f
db $e2,$1f,$f0,$bf,$db,$4e,$94,$0f,$e4,$63,$c8,$07,$22,$80,$e0,$17
db $c0,$81,$c0,$01,$c0,$00,$00,$c0,$a6,$14,$6b,$e0,$3f,$61,$bb,$94
db $6d,$a3,$4f,$11,$21,$a8,$58,$84,$00,$80,$31,$00,$20,$82,$01,$81
db $00,$20,$20,$68,$41,$00,$30,$01,$38,$02,$c0,$3b,$c0,$31,$c0,$20
db $40,$00,$80,$03,$81,$82,$7a,$3a,$34,$4d,$10,$f1,$21,$db,$9a,$a7
db $06,$1a,$7b,$24,$80,$a8,$db,$c1,$f3,$91,$30,$40,$34,$80,$8a,$0f
db $c7,$8b,$f1,$d3,$f1,$fd,$f3,$ff,$5f,$01,$10,$fe,$01,$40,$a7,$bf
db $bf,$9f,$9f,$0f,$8f,$87,$87,$83,$83,$81,$81,$00,$7f,$7f,$77,$7e
db $6e,$74,$44,$78,$68,$10,$70,$60,$60,$40,$40,$8e,$18,$c1,$95,$90
db $0a,$00,$10,$0c,$41,$40,$80,$c8,$48,$81,$03,$c0,$40,$82,$01,$00
db $c3,$c3,$03,$00,$00,$f7,$f8,$11,$78,$fc,$5b,$22,$07,$44,$ff,$01
db $60,$f8,$ff,$07,$00,$20,$14,$8e,$43,$3c,$7e,$c0,$78,$bf,$81,$08
db $00,$02

; $17cd1: LZ77 compressed data of the font.
SECTION "CompressedFontData", ROMX[$7cd1], BANK[2]
CompressedFontData::
 db $90,$02,$4b,$02,$00,$80,$c4,$73,$f7,$32,$46,$00,$48,$23,$31,$b3
 db $63,$e1,$c1,$01,$00,$60,$60,$50,$18,$02,$42,$20,$00,$4b,$27,$10
 db $40,$34,$36,$e1,$c0,$82,$81,$67,$00,$20,$c4,$03,$5c,$67,$43,$0f
 db $0e,$67,$43,$7f,$07,$00,$32,$3c,$40,$84,$76,$26,$74,$66,$75,$7f
 db $07,$07,$06,$06,$00,$00,$73,$7f,$60,$40,$7e,$7c,$0b,$06,$17,$63
 db $6f,$17,$01,$e0,$0a,$40,$86,$01,$f9,$d0,$0e,$e4,$cd,$ec,$6e,$ec
 db $ce,$07,$11,$80,$f5,$f7,$27,$00,$86,$81,$01,$83,$01,$00,$52,$c0
 db $b5,$01,$60,$37,$1b,$73,$33,$7f,$1e,$37,$63,$7f,$66,$7e,$3c,$8c
 db $00,$26,$dc,$99,$19,$9b,$f9,$f2,$71,$30,$30,$48,$00,$ca,$61,$01
 db $3c,$9b,$b9,$b1,$bf,$bf,$39,$03,$00,$9c,$99,$99,$40,$00,$cf,$e6
 db $6e,$ec,$cf,$ef,$6c,$ec,$cd,$c8,$8f,$0f,$00,$e0,$c5,$e3,$67,$66
 db $0e,$04,$0c,$6c,$6c,$6c,$0f,$23,$00,$5c,$01,$d0,$90,$ef,$ce,$6c
 db $10,$f0,$74,$66,$e4,$c7,$c4,$87,$67,$00,$a0,$4b,$40,$04,$17,$00
 db $24,$fa,$f3,$03,$00,$c8,$f9,$81,$3b,$00,$62,$f1,$e1,$81,$81,$11
 db $80,$d0,$80,$00,$00,$3e,$1c,$76,$62,$e0,$40,$de,$14,$00,$5d,$7f
 db $32,$82,$00,$a6,$b1,$b1,$b3,$31,$b3,$b1,$2f,$b7,$23,$33,$a2,$85
 db $00,$10,$1e,$08,$18,$18,$10,$00,$38,$18,$38,$24,$82,$20,$00,$13
 db $0e,$04,$08,$80,$60,$e0,$60,$e0,$cc,$c0,$cf,$c6,$87,$03,$00,$20
 db $4c,$e8,$6c,$ec,$c9,$cc,$89,$0f,$8b,$cf,$8a,$ed,$cd,$2c,$23,$00
 db $64,$30,$70,$30,$60,$30,$70,$60,$70,$08,$00,$a8,$01,$78,$75,$62
 db $7f,$77,$3d,$7f,$17,$6b,$6a,$09,$c0,$a3,$b1,$00,$00,$95,$98,$d9
 db $9d,$d8,$de,$dc,$d7,$de,$53,$db,$d1,$02,$a8,$ec,$00,$52,$5c,$00
 db $00,$e9,$4c,$cc,$cd,$86,$07,$c3,$00,$40,$c4,$73,$37,$b3,$67,$e6
 db $c7,$07,$05,$06,$04,$06,$06,$06,$00,$e0,$c3,$f1,$27,$53,$37,$16
 db $36,$76,$67,$f6,$76,$f3,$b3,$d1,$11,$00,$22,$9f,$bd,$99,$37,$39
 db $1f,$be,$17,$33,$b1,$b3,$37,$06,$00,$d6,$8f,$c7,$de,$00,$b0,$ec
 db $c2,$e1,$60,$e0,$c3,$cc,$8b,$07,$00,$e0,$ed,$87,$01,$0c,$0c,$0c
 db $02,$80,$80,$c0,$10,$04,$a0,$c1,$04,$04,$88,$c6,$c6,$ee,$c4,$cc
 db $7c,$78,$30,$10,$00,$5c,$10,$73,$31,$73,$63,$77,$26,$3e,$34,$38
 db $1c,$1c,$0c,$c0,$a8,$91,$81,$b9,$19,$99,$31,$a7,$35,$af,$bf,$bf
 db $bb,$bb,$31,$00,$80,$b3,$b1,$31,$33,$37,$1a,$1e,$0c,$bb,$8c,$00
 db $58,$99,$99,$09,$00,$88,$60,$66,$c2,$e6,$c6,$de,$64,$6c,$38,$38
 db $18,$70,$18,$00,$54,$40,$3f,$07,$03,$0f,$05,$00,$28,$1a,$0c,$24
 db $98,$b9,$3f,$00,$00,$03,$02,$06,$04,$c6,$10,$1c,$68,$1a,$60,$34
 db $10,$0a,$48,$00,$25,$1c,$18,$1e,$0c,$42,$20,$70,$30,$f0,$60,$e0
 db $c0,$00,$00,$f8,$f1,$f8,$99,$39,$18,$78,$30,$70,$60,$20,$00,$60
 db $54,$04,$60,$06,$8a,$03,$03,$00,$00,$07,$86,$01,$08,$00,$02

 ; $17f20: LZ77 compressed data of some tiles.
SECTION "CompressedTODOData", ROMX[$7f20], BANK[2]
CompressedTODOData::
db $20,$01,$d3,$00,$04,$40,$55,$e2,$61,$10,$0c,$00,$10,$0c,$e0,$1d
db $00,$2d,$08,$a0,$1e,$00,$20,$c0,$e5,$f8,$0b,$fc,$07,$fc,$15,$02
db $4c,$01,$d8,$e6,$1e,$90,$7e,$80,$7e,$00,$fe,$f6,$01,$c8,$07,$38
db $01,$a4,$78,$c2,$23,$02,$08,$01,$fe,$02,$03,$05,$2c,$3f,$00,$a1
db $1f,$42,$02,$d1,$0f,$00,$f8,$20,$10,$1e,$33,$05,$f0,$5a,$00,$15
db $ed,$10,$ea,$11,$e4,$23,$f0,$ef,$1c,$df,$f1,$1f,$d0,$08,$88,$04
db $5c,$f9,$07,$9c,$7f,$80,$7f,$00,$07,$03,$a6,$63,$80,$35,$f8,$4b
db $bc,$0c,$82,$00,$80,$02,$80,$3e,$80,$22,$9c,$7d,$00,$fa,$01,$7e
db $00,$75,$82,$f0,$8c,$00,$42,$b4,$83,$f4,$c3,$20,$9f,$21,$5f,$a1
db $9f,$c0,$22,$10,$1a,$10,$fd,$01,$00,$02,$f8,$06,$f7,$1c,$04,$88
db $06,$8b,$3f,$40,$00,$00,$ff,$80,$cf,$41,$80,$08,$f4,$23,$ec,$23
db $e8,$27,$f4,$0f,$f0,$3f,$60,$01,$08,$00,$ff,$87,$78,$8f,$78,$8b
db $78,$88,$40,$58,$c0,$7f,$c0,$2f,$c0,$07,$3f,$08,$42,$f8,$03,$fc
db $43,$74,$01,$10,$a0,$1f,$04,

; $262c6: LZ77-compressed data of TODO.
SECTION "CompressedTODOData1", ROMX[$62c6], BANK[3]
CompressedTODOData1::
db $00,$02,$22,$01,$02,$9e,$30,$10,$04,$c4,$08,$00,$a2,$66,$68,$66
db $68,$30,$32,$0c,$01,$46,$18,$19,$19,$2b,$02,$19,$2b,$1a,$1a,$89
db $80,$d9,$d0,$d8,$10,$10,$28,$04,$5b,$ad,$ac,$68,$64,$50,$54,$18
db $02,$8a,$28,$2a,$2a,$06,$00,$63,$01,$da,$02,$88,$c5,$85,$c5,$00
db $40,$6e,$50,$d4,$8e,$4c,$8c,$cc,$0d,$8c,$8e,$00,$cc,$8e,$40,$cb
db $cc,$cd,$0c,$0d,$0c,$8c,$44,$00,$b6,$04,$4a,$4c,$44,$08,$00,$5d
db $02,$24,$29,$2a,$84,$40,$a9,$40,$b0,$12,$00,$84,$8a,$08,$00,$02
db $41,$20,$b0,$48,$40,$40,$50,$b8,$04,$11,$11,$31,$40,$10,$0c,$89
db $40,$b0,$0c,$04,$00,$a1,$63,$20,$62,$80,$00,$10,$1d,$03,$03,$1e
db $1f,$03,$06,$00,$a8,$95,$00,$60,$11,$48,$00,$08,$04,$42,$04,$04
db $24,$26,$06,$06,$24,$12,$00,$01,$11,$31,$30,$00,$44,$5a,$a9,$10
db $39,$11,$10,$10,$21,$11,$50,$11,$11,$38,$01,$59,$91,$58,$19,$10
db $18,$39,$41,$81,$81,$11,$70,$10,$20,$09,$51,$89,$18,$58,$19,$a8
db $b0,$c0,$c8,$a8,$b0,$d0,$d8,$18,$b0,$b0,$d0,$10,$70,$80,$78,$10
db $70,$90,$78,$40,$18,$30,$60,$68,$60,$18,$18,$60,$68,$18,$18,$18
db $20,$60,$50,$58,$b9,$58,$59,$e1,$59,$19,$e0,$19,$b0,$18,$e0,$59
db $c9,$c9,$19,$a8,$18,$c8,$19,$58,$c9,$59,$19,$30,$fa,$0a,$80,$18
db $c5,$01,$10,$11,$00,$21,$c0,$c8,$ac,$00,$d4,$ac,$ec,$04,$04,$08
db $08,$28,$80,$0b,$00,$02

; $26a07 LZ77-compressed data of TODO.
SECTION "CompressedTODOData2", ROMX[$6a07], BANK[3]
CompressedTODOData2::
db $00,$02,$35,$01,$02,$9e,$0e,$10,$0a,$0c,$1e,$20,$7a,$00,$1a,$1c
db $00,$00,$12,$14,$28,$2a,$20,$52,$28,$02,$02,$01,$03,$09,$0a,$0f
db $10,$00,$13,$00,$00,$04,$02,$0b,$0c,$11,$12,$14,$15,$00,$1d,$00
db $00,$18,$01,$f8,$5b,$f9,$12,$00,$40,$55,$5e,$42,$0d,$80,$90,$0d
db $0e,$91,$91,$83,$f1,$17,$49,$0d,$4b,$89,$49,$8b,$cb,$01,$a0,$a8
db $86,$a4,$84,$a5,$c5,$44,$c0,$45,$20,$45,$45,$46,$e0,$04,$05,$26
db $26,$22,$00,$f3,$12,$28,$94,$00,$b3,$32,$43,$63,$73,$83,$93,$23
db $20,$90,$10,$82,$00,$6c,$83,$9d,$7c,$7e,$04,$00,$73,$00,$81,$c0
db $30,$3a,$e2,$01,$00,$0a,$52,$5a,$12,$10,$30,$3a,$52,$5a,$02,$00
db $e8,$01,$10,$1a,$42,$4a,$62,$6a,$12,$70,$7a,$82,$92,$9a,$8a,$02
db $a0,$aa,$12,$78,$12,$90,$82,$8a,$9a,$a2,$02,$00,$a8,$6a,$89,$d1
db $93,$d5,$55,$96,$16,$16,$c0,$d6,$41,$c0,$ea,$ac,$4b,$00,$54,$85
db $76,$76,$26,$80,$66,$26,$70,$d6,$85,$a6,$08,$8e,$b3,$b3,$2e,$01
db $01,$34,$01,$33,$04,$d0,$53,$d7,$59,$83,$83,$ce,$4e,$98,$18,$90
db $97,$c2,$08,$06,$0c,$58,$9a,$5a,$98,$d8,$9a,$d7,$18,$22,$a0,$48
db $80,$ac,$8c,$ac,$0c,$23,$03,$23,$e3,$03,$e4,$03,$e4,$0b,$e0,$0b
db $22,$80,$4d,$02,$67,$66,$68,$02,$5c,$02,$02,$88,$80,$18,$03,$d0
db $d9,$01,$b0,$e8,$01,$b0,$b8,$e8,$f1,$60,$00,$81,$40,$83,$03,$50
db $50,$83,$03,$55,$15,$d4,$0f,$51,$51,$83,$43,$0d,$8b,$4f,$09,$51
db $11,$40,$47,$0f,$46,$22,$0b,$00,$02,$cc


SECTION "CompressedVirginLogo", ROMX[$7337], BANK[3]
; $27337: LZ77-compressed tile map of the Virgin logo displayed at the game's start.
CompressedVirginLogoTileMap::
db $40,$02,$cf,$00,$c0,$a5,$e0,$44,$80,$e1,$00,$41,$81,$c1,$01,$82
db $80,$40,$82,$82,$22,$22,$a0,$70,$81,$a1,$c1,$e1,$01,$22,$42,$62
db $82,$42,$21,$11,$50,$68,$71,$81,$21,$20,$90,$a1,$21,$20,$b0,$c1
db $d1,$c1,$88,$08,$24,$8f,$0f,$01,$01,$90,$10,$43,$10,$9a,$c8,$88
db $20,$22,$d0,$48,$04,$4a,$04,$4c,$04,$04,$4e,$50,$52,$04,$54,$18
db $10,$01,$b6,$c2,$62,$d1,$e2,$f2,$02,$13,$23,$33,$43,$53,$63,$73
db $e3,$78,$40,$c2,$c9,$d1,$d9,$e1,$e9,$f1,$f9,$01,$0a,$12,$1a,$22
db $2a,$72,$3c,$20,$19,$1d,$21,$25,$29,$2d,$31,$35,$39,$3d,$09,$08
db $40,$45,$39,$20,$02,$49,$4a,$60,$8a,$aa,$ca,$ea,$4a,$00,$01,$7c
db $84,$15,$88,$08,$a4,$2c,$ad,$2d,$ae,$2e,$af,$af,$03,$90,$15,$58
db $98,$20,$22,$90,$c4,$c6,$c8,$ca,$04,$2a,$cc,$04,$04,$ce,$d0,$d2
db $18,$12,$81,$a4,$b6,$c6,$d6,$e6,$f6,$06,$17,$27,$37,$a7,$88,$08
db $a4,$80,$00,$90,$d0,$d5,$d9,$dd,$e1,$e5,$09,$08,$08,$54,$28,$d6
db $0a,$00,$02

; $2740a: LZ77-compressed data of the Virgin logo displayed at the game's start.
CompressedVirginLogoData::
db $a0,$07,$b3,$04,$a0,$09,$2e,$c2,$03,$2d,$0c,$91,$b4,$19,$40,$29
db $17,$90,$21,$03,$3c,$d8,$00,$60,$06,$d0,$66,$41,$24,$c0,$40,$01
db $d1,$81,$30,$87,$00,$41,$c1,$6f,$2e,$48,$83,$7b,$30,$18,$00,$53
db $0d,$6e,$cc,$89,$94,$09,$f1,$40,$30,$40,$18,$d8,$c8,$82,$d0,$1f
db $08,$28,$1a,$30,$50,$26,$20,$06,$50,$06,$20,$56,$88,$80,$b4,$8b
db $4f,$03,$ff,$32,$a0,$53,$40,$ca,$0c,$d8,$05,$18,$00,$a8,$1a,$08
db $04,$8c,$e2,$00,$69,$5c,$40,$8d,$18,$07,$c0,$3f,$84,$47,$68,$28
db $95,$05,$8a,$16,$28,$0d,$4c,$42,$0c,$70,$41,$20,$63,$5e,$60,$4c
db $20,$40,$88,$01,$80,$4a,$2e,$98,$c2,$00,$47,$01,$c9,$32,$00,$59
db $00,$a0,$00,$10,$2f,$2b,$92,$05,$b0,$c8,$8b,$70,$c0,$ea,$a2,$45
db $7e,$14,$ca,$00,$71,$d8,$80,$6c,$a0,$43,$06,$c0,$4b,$84,$93,$0c
db $23,$1c,$03,$25,$00,$ee,$71,$01,$1f,$82,$06,$08,$d4,$71,$a0,$48
db $0e,$d0,$c7,$07,$e4,$08,$11,$00,$f0,$7a,$a8,$91,$0b,$61,$61,$4e
db $0e,$30,$49,$82,$40,$c0,$31,$0e,$44,$c6,$80,$d1,$38,$80,$2e,$e1
db $58,$01,$69,$5c,$80,$17,$b0,$1a,$f9,$09,$f2,$05,$f2,$41,$0d,$80
db $4d,$38,$e1,$28,$03,$40,$e1,$80,$6e,$0c,$50,$92,$03,$a5,$0a,$b0
db $e3,$0f,$88,$40,$e0,$11,$0b,$72,$e3,$41,$08,$30,$00,$01,$30,$1a
db $81,$06,$09,$06,$00,$d1,$08,$18,$00,$4c,$c6,$84,$f6,$b8,$1f,$00
db $44,$8b,$87,$10,$00,$e0,$22,$c2,$3c,$c1,$3c,$c4,$39,$c2,$39,$c8
db $33,$c4,$33,$d0,$27,$c8,$27,$44,$00,$8c,$0a,$72,$64,$03,$a3,$00
db $53,$03,$ab,$71,$a0,$95,$0a,$31,$00,$31,$a1,$60,$0b,$f4,$43,$30
db $b8,$14,$70,$17,$03,$86,$a2,$40,$30,$c8,$00,$20,$14,$03,$c0,$05
db $80,$b4,$38,$d0,$0d,$0b,$be,$1d,$4c,$43,$84,$03,$41,$80,$1b,$1e
db $5c,$c3,$02,$cb,$18,$10,$00,$82,$81,$02,$01,$02,$21,$03,$04,$22
db $44,$22,$00,$fe,$1d,$82,$c7,$38,$f0,$1a,$f9,$03,$80,$77,$98,$0f
db $f8,$43,$b4,$a3,$10,$07,$18,$07,$10,$af,$10,$df,$68,$fc,$47,$94
db $63,$a2,$41,$42,$20,$04,$98,$80,$23,$04,$48,$00,$48,$58,$00,$60
db $a2,$08,$00,$70,$21,$c8,$30,$c8,$30,$c1,$50,$80,$51,$a0,$11,$10
db $20,$10,$20,$81,$20,$a0,$81,$22,$01,$45,$00,$be,$90,$01,$80,$63
db $20,$e8,$8a,$07,$6a,$f1,$27,$c4,$c3,$02,$a1,$70,$98,$07,$03,$2c
db $08,$48,$48,$08,$70,$01,$80,$1a,$16,$40,$43,$44,$38,$01,$a0,$15
db $e2,$05,$02,$d5,$f0,$20,$df,$c1,$32,$cc,$08,$7c,$81,$40,$98,$70
db $89,$0b,$32,$31,$01,$1e,$20,$5e,$a2,$00,$28,$88,$02,$31,$42,$31
db $12,$61,$90,$63,$88,$40,$18,$50,$a7,$10,$0f,$30,$4f,$00,$78,$3b
db $07,$39,$46,$38,$06,$78,$06,$7a,$4c,$04,$f6,$21,$89,$30,$81,$30
db $91,$a0,$10,$a1,$00,$21,$20,$01,$c0,$60,$80,$00,$81,$80,$02,$81
db $40,$45,$00,$01,$80,$87,$00,$07,$00,$03,$05,$22,$00,$26,$08,$06
db $22,$0c,$24,$48,$20,$48,$28,$00,$c9,$10,$c9,$50,$80,$51,$80,$11
db $f0,$01,$f2,$01,$24,$01,$6f,$48,$82,$41,$80,$23,$c0,$43,$84,$83
db $28,$90,$3b,$08,$8d,$04,$03,$82,$02,$b9,$41,$c8,$68,$9c,$23,$08
db $84,$04,$a1,$88,$17,$38,$84,$01,$6d,$17,$01,$c0,$47,$10,$08,$02
db $7c,$00,$7e,$04,$c0,$b5,$80,$10,$e0,$27,$08,$98,$82,$78,$10,$00
db $42,$05,$84,$01,$4c,$48,$31,$2e,$58,$40,$43,$88,$71,$88,$01,$20
db $0c,$44,$c2,$80,$00,$20,$00,$88,$43,$3c,$02,$7c,$02,$1e,$00,$ab
db $30,$c0,$27,$60,$20,$a0,$85,$48,$80,$40,$00,$c0,$20,$c0,$00,$91
db $00,$b8,$c2,$01,$4d,$48,$14,$00,$04,$20,$1c,$00,$3c,$00,$fc,$02
db $7c,$c4,$00,$1e,$42,$0c,$84,$48,$48,$80,$00,$80,$21,$02,$d3,$50
db $28,$50,$10,$e0,$88,$02,$01,$82,$c3,$2d,$ec,$78,$86,$01,$84,$70
db $20,$20,$04,$00,$61,$00,$10,$0e,$04,$20,$1f,$00,$3f,$80,$82,$20
db $00,$fa,$09,$00,$aa,$0e,$08,$07,$08,$06,$81,$06,$0f,$00,$58,$c1
db $21,$c0,$02,$e0,$02,$06,$40,$00,$00,$0f,$18,$00,$48,$0d,$e8,$0a
db $f0,$03,$fc,$23,$14,$4c,$e1,$01,$22,$bc,$08,$85,$01,$f2,$0a,$18
db $a1,$40,$80,$60,$8b,$60,$40,$10,$78,$06,$f8,$00,$f0,$08,$f1,$08
db $f9,$00,$f8,$01,$01,$1e,$00,$1e,$02,$0c,$12,$2c,$10,$2c,$14,$08
db $30,$48,$38,$00,$00,$ce,$11,$80,$2f,$f8,$00,$60,$13,$7e,$00,$70
db $8b,$1f,$40,$00,$08,$16,$c0,$ed,$0f,$e8,$67,$20,$f8,$f6,$10,$00
db $c8,$0a,$07,$10,$00,$82,$40,$38,$c0,$38,$c0,$38,$c5,$38,$62,$10
db $16,$4c,$21,$02,$3c,$00,$38,$01,$7e,$00,$bc,$48,$30,$c0,$21,$23
db $a0,$0d,$28,$10,$e0,$86,$05,$bd,$06,$42,$40,$40,$b0,$ef,$20,$4c
db $f4,$0b,$78,$14,$00,$2a,$60,$13,$3e,$00,$fc,$00,$50,$ed,$20,$00
db $58,$84,$0f,$10,$0f,$00,$84,$80,$a9,$1f,$80,$bf,$c1,$21,$d8,$02
db $2c,$04,$18,$10,$00,$50,$01,$83,$08,$00,$bf,$10,$e0,$09,$f0,$09
db $03,$74,$01,$bb,$f8,$00,$78,$26,$18,$0a,$80,$5e,$c1,$84,$02,$c1
db $a6,$05,$76,$01,$61,$20,$d9,$42,$68,$28,$16,$40,$8b,$1f,$01,$1e
db $02,$1c,$04,$18,$00,$18,$20,$10,$60,$80,$c0,$01,$78,$06,$f1,$00
db $f2,$01,$f8,$67,$58,$d0,$12,$e0,$0f,$f0,$27,$28,$56,$0d,$04,$84
db $8c,$80,$21,$c0,$01,$f0,$05,$0c,$00,$62,$05,$de,$fe,$40,$3e,$10
db $0e,$04,$0c,$c0,$54,$80,$00,$82,$41,$58,$10,$86,$71,$20,$18,$04
db $00,$ff,$00,$7f,$c2,$00,$d1,$40,$00,$08,$00,$02,$c8,$87,$60,$11
db $0e,$64,$61,$80,$0b,$04,$9e,$fc,$09,$f0,$21,$c0,$81,$0c,$c0,$11
db $90,$09,$38,$00,$78,$15,$00,$30,$80,$70,$00,$f0,$01,$84,$00,$d0
db $02,$fa,$01,$fc,$03,$f8,$37,$1c,$10,$81,$00,$23,$c0,$0f,$f0,$1b
db $0e,$a8,$02,$02,$42,$44,$60,$80,$0e,$f0,$84,$01,$26,$e0,$1f,$41
db $01,$11,$1c,$a0,$20,$80,$68,$80,$5f,$00,$04,$05,$c6,$21,$40,$10
db $38,$80,$81,$20,$00,$30,$08,$80,$79,$28,$0c,$0c,$c1,$00,$c4,$03
db $f0,$8f,$a1,$10,$00,$fe,$05

; $278c1: LZ77-compressed data of the Jungle Book logo tile map.
SECTION "CompressedJungleBookLogoTileMap", ROMX[$78c1], BANK[3]
CompressedJungleBookLogoTileMap::
db $d0,$00,$89,$00,$00,$a0,$09,$10,$18,$20,$28,$30,$38,$40,$48,$50
db $50,$44,$74,$da,$02,$43,$83,$c3,$03,$44,$84,$c4,$04,$45,$85,$c5
db $05,$06,$40,$86,$c6,$06,$c7,$44,$12,$90,$3a,$3c,$3e,$40,$42,$44
db $46,$48,$4a,$4c,$4e,$50,$52,$54,$56,$58,$5a,$5c,$5e,$60,$28,$92
db $80,$14,$23,$33,$43,$53,$63,$73,$83,$93,$a3,$b3,$c3,$d3,$e3,$f3
db $03,$14,$24,$34,$44,$44,$11,$05,$a4,$22,$a3,$23,$a4,$24,$a5,$25
db $a6,$26,$a7,$27,$a8,$28,$a9,$29,$aa,$2a,$ab,$ab,$89,$28,$20,$61
db $65,$69,$6d,$65,$65,$71,$75,$79,$65,$7d,$81,$85,$89,$8d,$91,$65
db $65,$95,$4d,$64,$09,$0e,$88,$d9,$99,$40,$08,$00,$02

; $2794e: LZ77-compressed data of the Jungle Book logo displayed at the game's start menu.
SECTION "CompressedJungleBookLogo", ROMX[$794e], BANK[3]
CompressedJungleBookLogoData::
db $80,$06,$24,$05,$80,$20,$e3,$66,$1a,$0c,$3c,$1c,$7c,$34,$74,$6c
db $6c,$cc,$d4,$d8,$f8,$90,$31,$60,$78,$f0,$dc,$f8,$fc,$6f,$ef,$f7
db $f7,$f4,$77,$f4,$e4,$76,$7a,$44,$30,$0b,$0b,$67,$21,$30,$f0,$ff
db $fa,$ff,$af,$df,$cf,$ff,$1f,$70,$f8,$b3,$e7,$ff,$bf,$ff,$dc,$bf
db $a9,$bf,$3f,$20,$00,$3a,$bc,$3e,$ff,$cb,$c7,$f3,$a1,$5a,$3c,$1e
db $1f,$9f,$1f,$00,$40,$9f,$cf,$ff,$5f,$f4,$b8,$7a,$30,$75,$73,$d0
db $f0,$c5,$90,$4d,$0a,$8b,$10,$30,$00,$04,$c0,$c6,$02,$c5,$bd,$40
db $63,$38,$f1,$8e,$07,$e3,$8f,$e7,$fd,$dc,$40,$70,$96,$ea,$4a,$4e
db $4a,$4a,$00,$00,$a0,$c0,$09,$25,$08,$78,$f5,$70,$6d,$60,$10,$c2
db $c0,$92,$b1,$b1,$b1,$91,$b1,$c9,$91,$e1,$c0,$f9,$37,$04,$a5,$b0
db $37,$33,$56,$07,$0f,$46,$1c,$0e,$80,$a0,$92,$e1,$ff,$ff,$e1,$41
db $96,$02,$c2,$88,$d8,$58,$00,$40,$dc,$fc,$df,$ff,$ff,$73,$30,$40
db $8b,$c3,$c2,$e3,$c2,$6f,$ce,$8f,$0f,$8f,$cf,$cd,$fd,$ec,$7c,$f8
db $c1,$63,$ee,$6c,$ee,$cf,$ef,$4f,$8f,$2f,$00,$e0,$af,$27,$80,$47
db $2e,$3c,$28,$23,$24,$28,$04,$28,$0c,$68,$5e,$ec,$ff,$ff,$fc,$bf
db $29,$3f,$ec,$e5,$65,$20,$00,$a0,$39,$2c,$ac,$7f,$ff,$ff,$75,$f8
db $cf,$ff,$8c,$01,$9a,$38,$78,$38,$1d,$08,$88,$18,$f1,$fb,$ff,$f3
db $f6,$ef,$3e,$18,$4a,$11,$bc,$98,$34,$78,$fc,$78,$ff,$ce,$cf,$87
db $f0,$e0,$30,$30,$f8,$f0,$70,$38,$18,$b8,$7f,$3f,$ff,$ff,$4e,$49
db $34,$48,$ff,$00,$90,$9a,$40,$80,$00,$01,$2a,$40,$42,$82,$03,$0b
db $0e,$98,$02,$45,$60,$6a,$5c,$40,$54,$30,$f0,$f7,$cf,$ff,$0f,$78
db $20,$82,$c9,$82,$52,$d8,$cf,$27,$00,$84,$c7,$88,$29,$49,$4d,$c9
db $49,$49,$f9,$f2,$f1,$f1,$93,$10,$8c,$98,$18,$41,$10,$c0,$fc,$ff
db $0f,$00,$ff,$18,$10,$08,$06,$e8,$21,$8e,$04,$88,$00,$88,$60,$61
db $e1,$ef,$81,$cf,$48,$86,$00,$30,$20,$49,$00,$48,$01,$78,$37,$12
db $84,$34,$20,$13,$03,$fd,$04,$80,$10,$60,$0d,$07,$f8,$3d,$3c,$3f
db $0d,$00,$d4,$60,$80,$01,$f8,$01,$f8,$03,$0e,$04,$dc,$38,$b0,$1c
db $01,$f6,$01,$f6,$87,$03,$0d,$05,$d8,$a8,$10,$4f,$b0,$0f,$f0,$0f
db $0c,$88,$00,$a0,$c6,$fc,$ff,$ff,$0b,$07,$40,$80,$10,$60,$89,$70
db $3a,$1c,$78,$30,$f4,$63,$e0,$67,$08,$06,$21,$1e,$80,$7f,$8c,$73
db $18,$00,$03,$00,$80,$5f,$c0,$9f,$91,$14,$6a,$e2,$ec,$dd,$cf,$cd
db $cf,$8f,$0e,$0f,$0c,$08,$c1,$08,$c2,$01,$84,$c3,$e1,$c0,$fc,$f8
db $ff,$fe,$d7,$cf,$c1,$c3,$c8,$f1,$c5,$78,$e0,$1c,$00,$80,$48,$02
db $fb,$10,$e2,$01,$f8,$91,$10,$08,$85,$90,$cf,$00,$00,$84,$c0,$32
db $04,$f9,$84,$18,$10,$68,$22,$1c,$78,$cf,$dc,$df,$8f,$07,$0f,$2c
db $04,$c1,$20,$40,$03,$20,$09,$01,$00,$a0,$c1,$fb,$f1,$7f,$3e,$0e
db $0e,$26,$c0,$11,$e0,$81,$71,$06,$02,$7e,$3e,$fe,$fe,$e1,$c3,$01
db $00,$41,$3e,$80,$7e,$10,$e2,$00,$01,$21,$1f,$01,$3f,$11,$0f,$01
db $06,$00,$07,$80,$06,$41,$86,$19,$18,$1e,$9e,$1f,$9e,$6d,$12,$a8
db $8b,$03,$a1,$30,$20,$19,$00,$3d,$3e,$3e,$7f,$21,$08,$02,$02,$33
db $03,$03,$0e,$0c,$07,$0f,$0b,$02,$10,$30,$38,$1e,$3e,$2e,$1e,$0c
db $00,$42,$84,$4a,$04,$c0,$5e,$08,$20,$e2,$e7,$f7,$e7,$77,$60,$00
db $00,$85,$20,$25,$c3,$64,$04,$c1,$40,$2a,$40,$38,$21,$1e,$42,$20
db $08,$f0,$09,$02,$01,$c0,$4f,$00,$40,$85,$7c,$81,$42,$20,$c0,$13
db $04,$24,$61,$00,$a3,$80,$f0,$50,$09,$07,$f8,$09,$06,$81,$47,$18
db $10,$02,$f0,$01,$f2,$01,$f2,$0d,$81,$80,$10,$10,$44,$13,$88,$17
db $00,$02,$7c,$e0,$10,$00,$86,$31,$ce,$81,$7e,$0c,$83,$70,$f0,$0d
db $81,$1e,$01,$1f,$00,$3c,$04,$38,$40,$12,$02,$50,$42,$3c,$40,$3f
db $40,$3f,$09,$71,$08,$43,$c8,$0b,$c8,$cf,$08,$2f,$14,$02,$e0,$37
db $e4,$00,$10,$a0,$9f,$21,$1e,$21,$1e,$43,$3c,$01,$f8,$05,$f8,$a1
db $1a,$82,$49,$08,$e8,$21,$08,$7c,$c2,$81,$00,$10,$00,$04,$40,$1e
db $02,$1c,$00,$1e,$01,$1e,$80,$04,$20,$04,$f8,$84,$78,$84,$78,$00
db $c6,$21,$02,$9a,$30,$00,$3e,$00,$3e,$02,$dc,$00,$90,$84,$01,$cb
db $06,$32,$e1,$41,$18,$90,$84,$05,$c2,$0a,$c4,$24,$d8,$08,$f0,$02
db $fc,$01,$fe,$00,$cf,$08,$c7,$3c,$38,$30,$78,$70,$e0,$b8,$70,$18
db $38,$3c,$18,$8c,$1c,$0c,$9c,$20,$29,$04,$87,$40,$10,$04,$34,$42
db $40,$38,$44,$38,$40,$3c,$c0,$3f,$44,$e0,$15,$c2,$7d,$04,$38,$90
db $0f,$80,$1f,$a0,$1f,$80,$bf,$00,$3f,$01,$3e,$04,$78,$d0,$20,$45
db $02,$01,$80,$4f,$00,$68,$f5,$03,$f0,$03,$f2,$a1,$40,$78,$28,$04
db $00,$7c,$02,$7c,$c1,$3e,$20,$1f,$c0,$3c,$c4,$38,$c4,$38,$84,$38
db $80,$bc,$42,$3c,$00,$7f,$0c,$03,$08,$f0,$08,$70,$89,$70,$80,$f1
db $08,$70,$06,$f8,$02,$7c,$a1,$1c,$46,$38,$20,$40,$06,$78,$80,$7f
db $80,$7f,$c0,$3f,$8c,$f3,$10,$60,$9c,$04,$02,$c0,$03,$e0,$03,$d0
db $a3,$01,$50,$ec,$3b,$03,$18,$88,$07,$80,$07,$04,$01,$40,$25,$c0
db $01,$e8,$01,$f2,$6c,$10,$1c,$10,$10,$90,$13,$90,$13,$94,$b3,$10
db $17,$38,$77,$30,$7e,$74,$88,$91,$40,$00,$7e,$06,$7c,$86,$7c,$00
db $f9,$00,$f8,$19,$e0,$61,$14,$02,$c0,$23,$d4,$63,$80,$3f,$31,$0e
db $00,$2f,$00,$2f,$08,$a7,$08,$67,$a0,$07,$c4,$03,$c2,$41,$0c,$18
db $88,$87,$08,$87,$08,$07,$00,$07,$08,$07,$31,$0e,$02,$7c,$88,$30
db $4a,$02,$01,$22,$1c,$20,$1e,$20,$1e,$30,$4e,$21,$0e,$e8,$07,$60
db $1e,$60,$1e,$62,$1c,$62,$1c,$60,$9c,$64,$18,$e0,$19,$f0,$01,$e1
db $18,$e1,$18,$24,$81,$00,$f0,$8c,$72,$0c,$71,$0e,$30,$cf,$c0,$c9
db $83,$c9,$c8,$c3,$c2,$c0,$c0,$c0,$c8,$c4,$c0,$cc,$c5,$c8,$c0,$e0
db $c0,$70,$f0,$b0,$70,$00,$12,$24,$a8,$c0,$b5,$70,$e0,$f1,$a3,$cf
db $6f,$28,$60,$0b,$84,$04,$18,$0e,$ff,$fb,$f7,$f2,$71,$30,$80,$1a
db $10,$08,$c8,$c7,$e7,$c7,$ef,$70,$78,$38,$28,$18,$08,$00,$00,$00
db $06,$01,$56,$88,$07,$fc,$93,$60,$00,$02,$94,$0f,$ee,$08,$80,$12
db $30,$00,$f0,$d3,$e3,$e3,$07,$07,$0e,$3e,$1c,$34,$38,$30,$e0,$c1
db $c3,$d7,$cf,$7f,$7e,$3c,$f8,$45,$0e,$88,$02,$01,$04,$01,$44,$0f
db $98,$84,$03,$04,$09,$4c,$f0,$70,$fd,$de,$df,$8f,$87,$03,$88,$02
db $22,$81,$83,$87,$8f,$ff,$fe,$7c,$78,$c4,$a1,$12,$10,$a0,$00,$08
db $fe,$03,$05,$44,$0c,$1c,$7c,$38,$f8,$f0,$d0,$e0,$88,$42,$f9,$fb
db $11,$2c,$0f,$60,$60,$09,$00,$02
