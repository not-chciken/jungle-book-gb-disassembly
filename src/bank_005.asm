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

; $40dc
AssetSprites::

; $40dc: Sprite of the diamonds you have to collect in a level.
DiamondSprite::
    INCBIN "gfx/DiamondSprite.2bpp"

; $411c: Score numbers and 1UP.
LabelSprites::
    INCBIN "gfx/LabelSprites.2bpp"

; $41fc: Projectiles like bananas, stones, and coconuts.
ProjectileSprites::
    INCBIN "gfx/ProjectileSprites.2bpp"

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

; $453c
EnemySprites::

; $453c
SittingMonkeySprites::
    INCBIN "gfx/SittingMonkeySprites.2bpp"

; $471c
HangingMonkeySprites2::
    INCBIN "gfx/HangingMonkeySprites2.2bpp"

; $491c
BoarSprites::
    INCBIN "gfx/BoarSprites.2bpp"

; $4bfc
WalkingMonkeySprites3::
    INCBIN "gfx/WalkingMonkeySprites3.2bpp"

; $4f7c
CobraSprites::
    INCBIN "gfx/CobraSprites.2bpp"

; $523c: First sprites of the eagle that picks the player up after finishing a level.
EagleSprites::
    INCBIN "gfx/EagleSprites.2bpp"

; $565c: Second sprites of the eagle that picks the player up after finishing a level.
EagleSprites2::
    INCBIN "gfx/EagleSprites2.2bpp"

; $5a1c: Sprites of the elelphants' beak in the dawn patrol level. TODO
ElephantTrunkSprites::
    INCBIN "gfx/ElephantTrunkSprites.2bpp"

; $5bdc
StoneSprites::
    INCBIN "gfx/StoneSprites.2bpp"

; $5c1c: The pear item that can be collected in the bonus level.
PearSprites::
    INCBIN "gfx/PearSprites.2bpp"

; $5c5c: The cherry item that can be collected in the bonus level.
CherrySprite::
    INCBIN "gfx/CherrySprite.2bpp"

; $5c5c: The egg item that can be collected in the bonus level.
EggSprite::
    INCBIN "gfx/EggSprite.2bpp"

; $5cdc
InvincibleMaskSprites::
    INCBIN "gfx/InvincibleMaskSprites.2bpp"

; $5d1c
LightningSprites::
    INCBIN "gfx/LightningSprites.2bpp"

; $5dbc
CrawlingSnakeSprites::
    INCBIN "gfx/CrawlingSnakeSprites.2bpp"

; $5fbc: Or whatever these 4 spinning dots are supposed to represent.
MosquitoSprites::
    INCBIN "gfx/MosquitoSprites.2bpp"

; $60bc
CrocodileSprites::
    INCBIN "gfx/CrocodileSprites.2bpp"

; $62fc
KaaSprites2::
    INCBIN "gfx/KaaSprites2.2bpp"

; $66dc: Includes the "zzzzz" sprites for sleeping bosses.
KaaSprites::
    INCBIN "gfx/KaaSprites.2bpp"

; $6a5c: Sprites that read "BONUS".
BonusSprites::
    INCBIN "gfx/BonusSprites.2bpp"

; $6afc
FallingPlatformSprites::
    INCBIN "gfx/FallingPlatformSprites.2bpp"

; $6b7c
FlyingBirdSprites::
    INCBIN "gfx/FlyingBirdSprites.2bpp"

; $6e9c: Sprites when the flying bird turns.
FlyingBirdTurnSprites::
    INCBIN "gfx/FlyingBirdTurnSprites.2bpp"

; $71fc
WalkingMonkeySprites::
    INCBIN "gfx/WalkingMonkeySprites.2bpp"

; $757c
WalkingMonkeySprites2::
    INCBIN "gfx/WalkingMonkeySprites2.2bpp"

; $773c
FishSprites::
    INCBIN "gfx/FishSprites.2bpp"

; $7a5c
HippoSprites::
    INCBIN "gfx/HippoSprites.2bpp"

; $7c3c
BatSprites::
    INCBIN "gfx/BatSprites.2bpp"

; $7ffc: Unused data at the end of the bank.
Bank5TailData::
    db $00, $00, $00, $05
