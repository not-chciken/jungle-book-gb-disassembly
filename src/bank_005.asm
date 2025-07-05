SECTION "ROM Bank $005", ROMX[$4000], BANK[$5]

; $4000: Starting posiitions for the player and the background scroll for every level.
; Tuples are as follows:
; (BgScrollXLsb, BgScrollXMsb, BgScrollYLsb, BgScrollYMsb, PlayerPositionXLsb, PlayerPositionXMsb, PlayerPositionYLsb, PlayerPositionYMsb)
; Each level has two tuples: One for the start, and one for the checkpoint.
StartingPositions::
    db $00, $00, $58, $01, $10, $00, $a0, $01 ; Level 1 "JUNGLE BY DAY": Start.
    db $10, $06, $88, $01, $34, $06, $e0, $01 ; Level 1 "JUNGLE BY DAY": Checkpoint.
    db $00, $00, $88, $07, $10, $00, $d0, $07 ; Level 2 "THE GREAT TREE": Start.
    db $10, $01, $38, $01, $34, $01, $80, $01 ; Level 2 "THE GREAT TREE": Checkpoint.
    db $00, $00, $00, $00, $24, $00, $00, $01 ; Level 3 "DAWN PATROL": Start.
    db $50, $09, $00, $00, $74, $09, $00, $01 ; Level 3 "DAWN PATROL": Checkpoint.
    db $50, $01, $88, $01, $c8, $01, $c0, $01 ; Level 4 "BY THE RIVER": Start.
    db $18, $0e, $68, $01, $3c, $0e, $a0, $01 ; Level 4 "BY THE RIVER": Checkpoint.
    db $00, $00, $88, $03, $34, $00, $e4, $03 ; Level 5 "IN THE RIVER": Start.
    db $60, $06, $18, $03, $b0, $06, $60, $03 ; Level 5 "IN THE RIVER": Checkpoint.
    db $00, $00, $80, $03, $24, $00, $e0, $03 ; Level 6 "TREE VILLAGE": Start.
    db $10, $05, $38, $01, $34, $05, $80, $01 ; Level 6 "TREE VILLAGE": Checkpoint.
    db $00, $00, $30, $00, $24, $00, $80, $00 ; Level 7 "ANICENT RUINS": Start.
    db $50, $05, $88, $03, $84, $05, $e0, $03 ; Level 7 "ANICENT RUINS": Checkpoint.
    db $20, $00, $48, $06, $46, $00, $a1, $06 ; Level 8 "FALLING RUINS": Start.
    db $00, $00, $48, $00, $10, $00, $a0, $00 ; Level 8 "FALLING RUINS": Checkpoint.
    db $00, $00, $88, $03, $24, $00, $e0, $03 ; Level 9 "JUNGLE BY NIGHT": Start.
    db $60, $07, $88, $03, $e0, $07, $e0, $03 ; Level 9 "JUNGLE BY NIGHT": Checkpoint.
    db $00, $00, $58, $03, $24, $00, $a0, $03 ; Level 10 "THE WASTELANDS": Start.
    db $58, $06, $68, $03, $84, $06, $a0, $03 ; Level 10 "THE WASTELANDS": Checkpoint.
    db $40, $01, $00, $00, $90, $01, $20, $00 ; Level 11 "Bonus": Start.
    db $40, $01, $00, $00, $90, $01, $20, $00 ; Level 11 "Bonus": Checkpoint.
    db $00, $00, $18, $00, $00, $00, $00, $00 ; Level 12 "Transition": Start.
    db $00, $00, $18, $00, $00, $00, $00, $00 ; Level 12 "Transition": Checkpoint.

; $40c0: Seemingly unused data.
.UnusedData40c0:
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00, $00, $00, $00, $00
    db $00, $00, $00, $00

AssetSprites::

; $40dc: Sprite of the diamonds you have to collect in a level.
DiamondSprite::
  INCBIN "gfx/DiamondSprite.2bpp"

; $411c: Projectiles, score numbers, etc.
AssetSprites2::
  INCBIN "gfx/AssetSprites2.2bpp"

; $429c: Pineapple giving bonus points.
PineappleSprite::
    INCBIN "gfx/PineappleSprite.2bpp"

; $42bc: Leaf from the bonus level.
LeafSprites::
    INCBIN "gfx/LeafSprites.2bpp"

; $42fc: Grape-like health package.
HealthPackageSprites::
    INCBIN "gfx/HealthPackageSprites.2bpp"

; $433c: Mowgli-icon giving an extra life.
ExtraLifeSprites::
    INCBIN "gfx/ExtraLifeSprites.2bpp"

; $437c: Clock giving extra time.
ExtraTimeSprites::
    INCBIN "gfx/ExtraTimeSprites.2bpp"

; $43bc: Shovel providing access to the bonus level.
ShovelSprites::
    INCBIN "gfx/ShovelSprites.2bpp"

; $43fc: Double banana item as dropped by enemies.
DoubleBananaSprites::
    INCBIN "gfx/DoubleBananaSprites.2bpp"

; $443c: Boomerang weapon item as dropped by enemies.
BoomerangItemSprite::
    INCBIN "gfx/BoomerangItemSprite.2bpp"

; $445c: Projectile shot by snakes.
SnakeProjectileSprite::
    INCBIN "gfx/SnakeProjectileSprite.2bpp"

; $447c: Sprite of the catapult boulder.
BoulderSprite::
    INCBIN "gfx/BoulderSprite.2bpp"

; $44bc: Sprite of the rotating checkpoint flower.
CheckpointSprite::
    INCBIN "gfx/CheckpointSprite.2bpp"

SittingMonkeySprites::
    INCBIN "gfx/SittingMonkeySprites.2bpp"

HangingMonkeySprites2::
    INCBIN "gfx/HangingMonkeySprites2.2bpp"

BoarSprites::
    INCBIN "gfx/BoarSprites.2bpp"

TODOSprites4bfc::
    INCBIN "gfx/TODOSprites4bfc.2bpp"

CobraSprites::
    INCBIN "gfx/CobraSprites.2bpp"

EagleSprites::
    INCBIN "gfx/EagleSprites.2bpp"

TODOSprites565c::
    INCBIN "gfx/TODOSprites565c.2bpp"

FloatingBalooSprites::
    INCBIN "gfx/FloatingBalooSprites.2bpp"

StoneSprites::
    INCBIN "gfx/StoneSprites.2bpp"

PearSprites::
    INCBIN "gfx/PearSprites.2bpp"

CherrySprite::
    INCBIN "gfx/CherrySprite.2bpp"

EggSprite::
    INCBIN "gfx/EggSprite.2bpp"

InvincibleMaskSprites::
    INCBIN "gfx/InvincibleMaskSprites.2bpp"

TODOSprites5d1c::
    INCBIN "gfx/TODOSprites5d1c.2bpp"

FloaterSprites::
    INCBIN "gfx/FloaterSprites.2bpp"

CrocodileSprites::
    INCBIN "gfx/CrocodileSprites.2bpp"

TODOSprites62fc::
    INCBIN "gfx/TODOSprites62fc.2bpp"

KaaSprites::
    INCBIN "gfx/KaaSprites.2bpp"

BonusSprites::
    INCBIN "gfx/BonusSprites.2bpp"

TODOSprites6afc::
    INCBIN "gfx/TODOSprites6afc.2bpp"

FlyingBirdSprites::
    INCBIN "gfx/FlyingBirdSprites.2bpp"

FlyingBirdTurnSprites::
    INCBIN "gfx/FlyingBirdTurnSprites.2bpp"

WalkingMonkeySprites::
    INCBIN "gfx/WalkingMonkeySprites.2bpp"

WalkingMonkeySprites2::
    INCBIN "gfx/WalkingMonkeySprites2.2bpp"

FishSprites::
    INCBIN "gfx/FishSprites.2bpp"

HippoSprites::
    INCBIN "gfx/HippoSprites.2bpp"

BatSprites::
    INCBIN "gfx/BatSprites.2bpp"

Bank5TailData::
    db $00, $00, $00, $05
