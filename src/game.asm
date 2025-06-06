INCLUDE "hardware.inc"

def JoyPadData EQU $c100 ; From MSB to LSB (1=pressed): down, up, left, right, start, select, B, A.
def JoyPadNewPresses EQU $c101
def PhaseTODO EQU $c102 ; Toggles once per frame from 0 to 1. I guess this is some kind of phase.
def Phase2TODO EQU $c104 ; Similar to PhaseTODO.
def TimeCounter EQU  $c103 ; 8-bit time register. Increments ~60 times per second.

; WARNING $c106 is also used differently in other contexts.
def WindowScrollYLsb EQU $c106 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollYMsb EQU $c107 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollXLsb EQU $c108 ; Window scroll in x direction. Increases from left to right.
def WindowScrollXMsb EQU $c109 ; Window scroll in x direction. Increases from left to right. Beware: $c109 is used for other stuff as well.
def AddressDecompTargetLsb EQU $c109 ; Start address of the decompression destination. Beware: $c109 is used for other stuff as well.
def AddressDecompTargetMsb EQU $c10a ; Start address of the decompression destination. Beware: $c10a is used for other stuff as well.

def StaticObjectDataAttr0 EQU $c10c

def NextLevel EQU $c10e ; Can be $ff in the start menu. 1 for "Jungle by Daylight". 12 for the bonus level.
def NextLevel2 EQU $c10f ; In the level, this is always 1 below NextLevel. After completing the level, NextLevel2 is set to NextLevel.
def CurrentLevel EQU $c110  ; Between 0-9.
def DifficultyMode EQU $c111 ; 0 = NORMAL, 1 =  PRACTICE
def CheckpointReached EQU $c112 ; 0 = no checkpoint, 8 = checkpoint
def LevelWidthDiv32 EQU $c113 ; Level width in pixels divided by 32 (LevelWidthDiv32 = 1 -> 4 tiles).
def LevelHeightDiv32 EQU $c114 ; Level height in pixels divided by 32 (LevelHeightDiv32 = 1 -> 4 tiles).

def BgScrollXDiv8Lsb EQU $c115 ; Window scroll divided by 8, then LSB.
def BgScrollYDiv8Lsb EQU $c11b ; Window scroll divided by 8, then LSB.
def BgScrollYDiv16TODO EQU $c11c ; TODO
def BgScrollXLsbDiv8 EQU $c11d ; Window scroll LSB in x direction divided by 8.
def BgScrollYLsbDiv8 EQU $c122 ; Window scroll LSB in Y direction divided by 8.
def BgScrollXLsb EQU $c125 ; Window scroll in x direction. Increases from left to right. Anchor is top left corner of the screen.
def BgScrollXMsb EQU $c126 ; Window scroll in x direction. Increases from left to right. Anchor is top left corner of the screen.
def FutureBgScrollXLsb EQU $c127 ; Used for teleports.
def FutureBgScrollXMsb EQU $c128 ; Used for teleports.
def ScrollX EQU $c12b ; Directly controls rSCX.
def ScrollY EQU $c132 ; This minus an offset controls rSCY.
def BgScrollYLsb EQU $c136 ; Window scroll in y direction. Increases from top to bottom. Anchor is top left corner of the screen.
def BgScrollYMsb EQU $c137 ; Window scroll in y direction. Increases from top to bottom. Anchor is top left corner of the screen.
def FutureBgScrollYLsb EQU $c138 ; Used for teleports.
def FutureBgScrollYMsb EQU $c139 ; Used for teleports.

def ScrollOffsetY EQU $c13a ; Only goes non-zero if there is wiggle.

def Wiggle1 EQU $c13b ; TODO: Seems to be some kind of offset for the sprites.
def Wiggle2 EQU $c13e ; TODO: Seems to be some kind of offset for the sprites.

def BgScrollYOffset EQU $c13c  ; Offset for BG scroll Y.
def BgScrollYWiggle EQU $c13d  ; Used to steer BgScrollYOffset. Related to explosions.

def PlayerPositionXLsb EQU $c13f ; Player's global x position on the map. LSB.
def PlayerPositionXMsb EQU $c140 ; Player's global x position on the map. MSB.
def PlayerPositionYLsb EQU $c141 ; Player's global y position on the map. LSB.
def PlayerPositionYMsb EQU $c142 ; Player's global y position on the map. MSB.

def PlayerWindowOffsetX EQU $c144 ; Relative offset in x direction between player and window. 0 if player at the left side of the screen.
def PlayerWindowOffsetY EQU $c145 ; Relative offset in y direction between player and window. 0 if player at the top of the screen.

def FacingDirection EQU $c146; = $01 if facing to the right, $ff if facing to the left.
def FacingDirection2 EQU $c148; = $01 if facing to the right, $ff if facing to the left. What is the difference to $c146?
def MovementState EQU $c149 ; 0 if not moving, 1 if walking, 2 if falling.

def IsPlayerDead EQU $c14a ; Goes when $ff when the player dies.

def LvlBoundingBoxXLsb EQU $c14d ; Bounding box of the level in x direction (LSB).
def LvlBoundingBoxXMsb EQU $c14e ; Bounding box of the level in x direction (MSB).
def LvlBoundingBoxYLsb EQU $c14f ; Bounding box of the level in x direction (LSB).
def LvlBoundingBoxYMsb EQU $c150 ; Bounding box of the level in x direction (MSB).

def IsCrouching EQU $c152 ; Iteratively turns $0f is player is crouching.
def CrouchingHeadTiltTimer EQU $c153 ; Timer for the head tilt animation when crouching.
def CrouchingHeadTilted EQU $c154 ; If 1 player tilts his head when crouching. This variable is also used for other animation stuff.
def JoyPadDataNonConst EQU $c155 ; Mirrors JoyPadData. However, some bits may be reset by individual functions.

def PlatformGroundDataX EQU $c158 ; TODO
def PlatformGroundDataX2 EQU $c159 ; TODO
def PlatformGroundDataY EQU $c15a ; TODO

def LandingAnimation EQU $c16f ; Animation when the player is landing.
def FallingDown EQU $c170 ; Increase/decreases when player is falling down/landing. Is 31 when in stable falling state.
def IsJumping EQU $c172 ; Turns $0f if player jumps and $f0 if player catapulted (only for the way up).
def UpwardsMomemtum EQU $c173 ; Upwards momemtum when jumping. The more momemtum, the higher you fly.

def IsCrouching2 EQU $c177 ; Turns $ff is player is crouching. Else $00,
def LookingUpDown EQU $c178 ; Turns $ff when you are looking up. Turns $01 when looking down.
def LookingUpAnimation EQU $c179 ; Seems to hold a counter for the animation when looking up.
def CrouchingAnimation EQU $c17a ; Seems to hold a counter for the animation when crouching.
def WalkingState EQU $c17d ; 0 = doing nothing, 1 = walking, $ff = running.
def XAcceleration EQU $c17f ; $10 when running. $0f when direction change. $0c when pressing down while running. Decreased in the latter two cases.
def FacingDirection3 EQU $c180 ; The value of [FacingDirection] is copied into this variable.
def ProjectileFlying EQU $c181 ; Turns $ff when a projectile is flying and player is standing still. Limits the number of projectiles per time while you are standing.

; WeaponSelect refers to the weapon currently displayed, while WeaponActive is used similarly but refers to the active weapon.
; For instance, WeaponActive is 0 when mask is selected (you can shoot bananas during invincibility), or when other weapons with 0 projectiles are selected.
def WeaponActive EQU $c182 ; 0 = banana, 1 = double banana, 2 = boomerang, 3 = stones
def WeaponSelect EQU $c183 ; 0 = banana, 1 = double banana, 2 = boomerang, 3 = stones, 4 = mask

; Seems to determine the direction of the projectiles:
; 0 doing nothing, 1 walking right, 2 walking left, 4 looking up, 8 looking down. Combinations are possible.
def PlayerDirection EQU $c184
def AmmoBase EQU $c184 ; Base address of the following array.
def CurrentNumDoubleBanana EQU $c185 ; Current number of super bananas you have. Each nibble represents one decimal digit.
def CurrentNumBoomerang EQU $c186 ; Current number of boomerangs you have. Each nibble represents one decimal digit.
def CurrentNumStones EQU $c187 ; Current number of stones you have. Each nibble represents one decimal digit.
def CurrentSecondsInvincibility EQU $c188 ; Current seconds of invincibility you have left. Each nibble represents one decimal digit.
def InvincibilityTimer EQU $c189 ; Decrements ~15 times per second.

def HeadSpriteIndex EQU $c18d ; Index of the sprite used for the head.
def HeadSpriteIndex2 EQU $c18e ; Index of the sprite used for the head. TODO: Difference between c18d?


def TodoPointerLsb EQU $c195
def TodoPointerMsb EQU $c196
def SpritePointerMsb EQU $c199 ; Is setup with values from PlayerSpritePointers.
def SpritePointerLsb EQU $c19a ; Is setup with values from PlayerSpritePointers.
def JumpTimer EQU $c19b ; Used to let frogs and fishes jump.
def ActionObject EQU $c19c ; LSB of object that will change its state..

def ActiveObjectsIds EQU $c1a9 ; Array of size 3 with IDs of active objects.
def ActiveObjectsId0 EQU $c1a9
def ActiveObjectsId1 EQU $c1aa
def ActiveObjectsId2 EQU $c1ab
def ActiveObjectsId3 EQU $c1ac ; This one seems to be special.

def NumObjects EQU $c1ad ; Number of objects in the current level.
def StaticObjectDataPtrLsb EQU $c1b0
def StaticObjectDataPtrMsb EQU $c1b1

def CollisionCheckObj EQU $c1b2 ; 0 if check against Mowgli. 1 if check against projectile.
def ScreenOffsetXTLCheckObj EQU $c1b3 ; X screen offset of the object we are checking. Refers to the top left corner.
def ScreenOffsetYTLCheckObj EQU $c1b4 ; Y screen offset of the object we are checking. Refers to the top left corner.
def ScreenOffsetXBRCheckObj EQU $c1b5 ; X screen offset of the object we are checking. Refers to the bottom right corner.
def ScreenOffsetYBRCheckObj EQU $c1b6 ; Y screen offset of the object we are checking. Refers to the bottom right corner.

def CurrentLives EQU $c1b7; Current number of lives.
def CurrentHealth EQU $c1b8 ; Current health.
def CurrentHealthDiv4 EQU $c1b9 ; Current health divided by 4.
def RedrawHealth EQU $c1ba ; Set to true if health shall be redrawn.
def NumDiamondsMissing EQU $c1be ; Current number of diamonds you still need to complete the level.
def CurrentScore1 EQU $c1bb ; Leftmost two digits of the current score.
def CurrentScore2 EQU $c1bc ; Nex two digits of the current score.
def CurrentScore3 EQU $c1bd ; Righmost two digits of the current score.
def MaxDiamondsNeeded EQU $c1bf ; Maximum number of diamonds you still need. 7 in practice. 10 in normal.

def ScreenLockX EQU $c1c0 ; Seems to lock the screen. Find out exact meaning.
def ScreenLockY EQU $c1c1 ; Seems to lock the screen. Find out exact meaning.
def Mask60HzTimer EQU $c1c2 ; Increased 60 times a second. Used to decrement displayed mask time.

def FirstDigitSeconds EQU $c1c3 ; First digit of remaining seconds (DigitMinutes : SecondDigitSeconds FirstDigitSeconds).
def SecondDigitSeconds EQU $c1c4 ; Second digit of remaining seconds (DigitMinutes : SecondDigitSeconds FirstDigitSeconds).
def DigitMinutes EQU $c1c5 ; Digit of remaining minutes.
def IsPaused EQU $c1c6 ; True if the game is paused.
def ColorToggle EQU $c1c7 ; Color toggle used for pause effect.
def PauseTimer EQU $c1c8 ; Timer that increases when game is paused. Used to toggle ColorToggle.
def RunFinishTimer EQU $c1c9 ; Goes non-zero when run is finished. Goes $ff when all diamonds collected. Else gets set to a value that is decreased each frame. At 0 the next or current level is (re)loaded.
def PlayerFreeze EQU $c1ca ; If !=0, the player and the game timer freezes.
def CurrentSong2 EQU $c1cb ; TODO: There seem to be 11 songs.
def NeedNewXTile EQU $c1cd ; Turns to a non-zero value if new tile on X axis is needed. 1 = rigth, $ff = left.
def NeedNewYTile EQU $c1ce ; Turns to a non-zero value if new horizontal tiles are needed. Else 0.

def WndwBoundingBoxXLsb EQU $c1d0 ; Determines how far the window can scroll in x direction (LSB).
def WndwBoundingBoxXMsb EQU $c1d1 ; Determines how far the window can scroll in x direction (MSB).

; Usually X coordinate 0 is the left limit. However, this might be changed if a boss fight is started.
def WndwBoundingBoxXBossLsb EQU $c1d2 ; Determines how far the window can scroll to the left (LSB). Only used in boss fights.
def WndwBoundingBoxXBossMsb EQU $c1d3 ; Determines how far the window can scroll to the left (LSB). Only used in boss fights.

def WndwBoundingBoxYLsb EQU $c1d4 ; Determines how far the window can scroll in y direction (MSB).
def WndwBoundingBoxYMsb EQU $c1d5 ; Determines how far the window can scroll in y direction (MSB).

def CatapultTodo EQU $c1dc ; Something with the launching process of the catapult.
def CatapultTilemapPtrLsb EQU $c1dd
def CatapultTilemapPtrMsb EQU $c1de
def TeleportDirection EQU $c1df ; Each nibble represent a signed direction (y,x). -1 -> down, 1 -> up, 1 -> right, -1 -> left.

def WaterFireCounter EQU $c1e0 ; Incremented every frame. At 8, a new tile for the fire/water is loaded. Only relevant for Level 4, 5, and 10.
def WaterFireIndex EQU $c1e1 ; Index for water/fire tiles currently rendered. Only relevant for Level 4, 5, and 10.
def BossHealth EQU $c1e2 ; Current health of the boss. The 4 bits of ATR_HEALTH aren't sufficient.
def BossDefeatBlinkTimer EQU $c1e3 ; $ If != 0, the boss was defeated and blinks. Steadily decremented. Set to BOSS_DEFEAT_BLINK_TIME when boss defeated.
def WhiteOutTimer EQU $c1e4 ; If != 0, the enemy sprite turns white. Steadily decremented.
def TransitionLevelState EQU $c1e5 ; Controls the sequence in the transition level. Is 0 when not in transition level.
def DiamondConvertTicks EQU $c1e7 ; Turns non-zero when collecting the bonus level item.
def BonusLevel EQU $c1e8 ; Turns non-zero when collecting the bonus level item.
def BalooFreeze EQU $c1e9 ; Turns non-zero when floating Baloo collides with a hippo.
def BossAnimation1 EQU $c1ea ; Current animation of the boss. =$ff if second monkey of monkey the boss is defeated.
def BossAnimation2 EQU $c1eb ; Current animation of the boss. =$ff if first monkey of monkey the boss is defeated.
def BossObjectIndex1 EQU $c1ed
def BossObjectIndex2 EQU $c1ee
def BossActive EQU $c1ef ; 0 if boss is not active. $ff if boss was activated and is still alive.
def BossMonkeyState EQU $c1f0 ; Only non-zero for the monkey boss. Indicates the state the monkeys are in.

def FallingPlatformLowPtr EQU $c1fa ; Set up with lower byte of falling platform pointer.
def NumContinuesLeft EQU $c1fc ; Number of continues left.
def CanContinue EQU $c1fd ; Seems pretty much like NumContinuesLeft. If it reaches zero, the game starts over.
def ContinueSeconds EQU $c1fe ; Seconds left during "CONTINUE?" screen.
def MissingItemsBonusLevel EQU $c1ff ; Remaining number of items to be collected in the bonus level.

def GeneralObjects EQU $c200 ; Start address of general objects. This includes enemies and items.
def ProjectileObjects EQU $c300 ; Start address of the projectile objects.
def ProjectileObject0 EQU $c300 ; First projectile object.
def ProjectileObject1 EQU $c320 ; Second projectile object.
def ProjectileObject2 EQU $c340 ; Third projectile object.
def ProjectileObject3 EQU $c360 ; Third projectile object.
def EnenemyProjectileObjects EQU $c380 ; Start address of enemy projectile objects.
def EnenemyProjectileObject0 EQU $c380 ; First enemy projectile objects.
def EnenemyProjectileObject1 EQU $c3a0 ; Second enemy projectile objects.

def NewTilesVertical EQU $c3c0 ; New vertical tiles are transferrPROJECTILE_UP_MASKed into VRAM from this location.
def NewTilesHorizontal EQU $c3d8 ; New horizontal tiles are transferred into VRAM from this location.
def GroundDataRam EQU $c400 ; Each element in this array corresponds to the ground data of a 2x2 meta tile. Most of it is zero (=no ground).

def CurrentSong EQU $c500 ; TODO: Still not sure. $c4 = fade out. $07 died sound.
def EventSound EQU $c501 ; Sounds of certain events. See EVENT_SOUND*.

def SoundHlMsb EQU $c5b7 ; TODO: What is in hl?
def SoundHlLsb EQU $c5b8 ; TODO: What is in hl?
def NoiseWaveControlBackup EQU $c5ba ; Is loaded with NoiseWaveControl. But this is never used?!
; Bit 0 controls noise trigger, Bit 1 controls noise setting, Bit 2 controls custom wave frequency, Bit 3 wave volume. Bit 7 resets this and other registers.
def NoiseWaveControl EQU $c5bb
def NoiseVolume EQU $c5bd ; Used to set up sound register NR42 (starting volume, envelope add mode, period).
def WaveVolume EQU $c5bc ; Used to set up sound register NR32 (wave volume).

; Bit 8: Object was defeated.
; Bit 4: Set if object is currently active
; Bit 3: Used for diamonds (and other objects) once they are collected.
; Bit 0-2: Index for corresponding entry in GeneralObjects.
def ObjectsStatus EQU $c600 ; Seems to hold some status for objects, like already found and so on. Size of array is given by NumObjects.
def CurrentSoundVolume EQU $c5be ; There are 8 different sound volumes (0 = sound off, 7 = loud)
def Ptr2x2BgTiles1 EQU $c700 ; First part of 2x2 background pointers (first half)
def Ptr2x2BgTiles2 EQU $c900 ; Second part of 2x2 background pointers (second half)
def Ptr4x4BgTiles1 EQU $cb00; First part of 4x4 background pointers (first half)
def Ptr4x4BgTiles2 EQU $cd00; Second part of 4x4 background pointers (second half)
def Layer1BgPtrs EQU $cf00; First layer of background pointers. Basically a 2D array with pointer to 4x4 meta tiles.
def StaticObjectData EQU $d700

def OldRomBank EQU $7fff

def MAX_HEALTH EQU 52 ; Starting health.
def MAX_LIFES EQU 10 ; Maximum number of lifes the player can have.
def HEALTH_ITEM_HEALTH EQU 52 ; Health restored by collecting a health item.
def MASK_SECONDS EQU $20 ; Increase of invincibility timer seconds when collecting a mask item. Note that each nibble represents one decimal digit.
def MINUTES_PER_LEVEL EQU 5 ; Number of minutes per level.
def NUM_CONTINUES_NORMAL EQU 4 ; Number of continues for the normal mode.
def NUM_CONTINUES_PRACTICE EQU 6 ; Number of continues for the practice mode.
def NUM_DIAMONDS_NORMAL EQU $10  ; Number of diamonds needed in normal mode. Note that each nibble represents one decimal digit.
def NUM_DIAMONDS_PRACTICE EQU 7 ; Number of diamonds needed in practice mode.
def NUM_DIAMONDS_FALLING_RUINS EQU 1 ; Number of diamonds needed in FALLING RUINS.
def NUM_LIVES EQU 6 ; Number of lives.
def NUM_BANANAS EQU $99 ; Number of bananas.
def NUM_WEAPONS EQU 5 ; Number of weapons (banana, double bananas, boomerang, stones, mask)
def NUM_ITEMS_BONUS_LEVEL EQU 8 ; Number of items you can collect in the bonus level. Level finishes if all items were collected.
def MAX_ACTIVE_OBJECTS EQU 3 ; Maximum number of objects in array ActiveObjectsIds.

def BIT_IND_A EQU 0
def BIT_IND_B EQU 1
def BIT_IND_SELECT EQU 2
def BIT_IND_START EQU 3
def BIT_IND_RIGHT EQU 4
def BIT_IND_LEFT EQU 5
def BIT_IND_UP EQU 6
def BIT_IND_DOWN EQU 7

; Damage of the following weapons (except default banana) is calculated as follows:
; (index * 2 + 1) * (NormalMode ? 1 : 2)
def WEAPON_BANANA EQU 0             ; Damage = 3, 6
def WEAPON_DOUBLE_BANANA EQU 1      ; Damage = 3, 6
def WEAPON_BOOMERANG EQU 2          ; Damage = 5, 10
def WEAPON_STONES EQU 3             ; Damage = 7, 14
def WEAPON_MASK EQU 4

def DAMAGE_BANANA EQU 2         ; Damage of a default banana. Note that +1 is always added. In practice mode this is multiplied with 2.

def CATAPULT_MOMENTUM_BONUS EQU 57
def CATAPULT_MOMENTUM_DEFAULT EQU 73

def JUMP_DEFAULT EQU $0f        ; Used by IsJumping.
def JUMP_CATAPULT EQU $f0       ; Used by IsJumping.

def PROJECTILE_BASE_SPEED EQU $1
def PROJECTILE_Y_OFFSET_CROUCH EQU 4
def PROJECTILE_Y_OFFSET_NORMAL EQU 16
def PROJECTILE_Y_OFFSET_UP EQU 24
def FROG_PROJECTILE_Y_OFFSET_DEFAULT EQU 2
def FROG_PROJECTILE_Y_OFFSET_JUMPING EQU 18
def FROG_PROJECTILE_X_OFFSET EQU 10
def PLAYER_FACING_RIGHT_MASK EQU %1
def PLAYER_FACING_LEFT_MASK EQU %10
def PLAYER_FACING_UP_MASK EQU %100
def PLAYER_FACING_DOWN_MASK EQU %10000

def WHITEOUT_TIME EQU 4 ; If an enemy is hit by a projectile, the sprite turns white for a time given by this constant.

def ENEMY_HIT_DAMAGE EQU 4 ; Damage received from enemies when they hit the player. In practice mode subtract 2.
def INVINCIBLE_AFTER_HIT_TIME EQU 24 ; Time in ticks the player is invincible after being hit. 15 ticks = 1 second.
def ENEMY_FREEZE_TIME EQU 64    ; Time an unkillable enemy freezes when being hit by a projectile.
def ENEMY_INVULNERABLE EQU $0f  ; Special value of the health attribute to indicate an invulnerable enemy.
def BOSS_DEFEAT_BLINK_TIME EQU 96 ; Time a boss blinks after being defeated.
def BOSS_FULL_HEALTH EQU 30 ; Full health of a boss.
def MONKY_BOSS_FULL_HEALTH EQU 15 ; Full health of a single monkey of the monkey boss.

def EMPTY_OBJECT_VALUE EQU $80 ; If a projectile object starts with this value, it is considered empty.
def NUM_GENERAL_OBJECTS EQU 8 ; Maximum number of general objects (items and enemies).
def NUM_PROJECTILE_OBJECTS EQU 4 ; Maximum number of projectile objects fired by the player.
def NUM_ENEMY_PROJECTILE_OBJECTS EQU 2 ; Maximum number of projectile objects fired by enemies.
def SIZE_PROJECTILE_OBJECT EQU $20 ; A projectile object is 32 bytes in size.
def SIZE_GENERAL_OBJECT EQU $20 ; A general object is 32 bytes in size.

; Attributes for all kinds of objects.
def ATR_Y_POSITION_LSB EQU $01 ; Y position of the object.
def ATR_Y_POSITION_MSB EQU $02 ; Y position of the object.
def ATR_X_POSITION_LSB EQU $03 ; X position of the object.
def ATR_X_POSITION_MSB EQU $04 ; X position of the object.

; Attributes for general objects.
; Various general properties: Bit 7: Non-zero if object was deleted, Bit 6: Non-zero if destructor shall be called.
; Bit 5: Object cannot be removed from active objects?
def ATR_STATUS EQU $00
; For $01, $02, $03, $04 see above.
def ATR_ID EQU $05 ; This field contains the type of the object. See ID_*.
def ATR_SPRITE_PROPERTIES EQU $07 ; See SPRITE_*_MASK below. Upper nibble contains display properties of the sprites.
def ATR_FACING_DIRECTION EQU $07 ; $1 -> facing right, $f -> facing left, 0 -> no facing direction (like falling platforms)
def ATR_OBJ_BEHAVIOR EQU $08 ; Related object behavior. E.g., frog shoots a projectile when this value reaches $ff.
def ATR_FREEZE EQU $0a ; If !=0, the enemy stops to move.
def ATR_PERIOD_TIMER0_RESET EQU $0b ; If obj[ATR_PERIOD_TIMER0] goes zero, it is reset with the value in obj[ATR_PERIOD_TIMER0_RESET]
def ATR_PERIOD_TIMER0 EQU $0c ; TODO: Somehow related to an enemies periodic behavior.
def ATR_PERIOD_TIMER1 EQU $0d ; TODO: Somehow related to an enemies periodic behavior.
def ATR_HITBOX_PTR EQU $0f ; If ==0, the object has no hitbox. $1 = projectiles, $2 = pineapple, $4 = monkey, $5 = snake, $6 = boar, $9 = snake, $a = floater, $15 = platform.
def ATR_STATUS_INDEX EQU $10 ; Holds an index for the array at ObjectsStatus ($c600).
def ATR_OBJECT_DATA EQU $11; Related to ActiveObjectsIds.
def ATR_PLATFORM_INCOMING_BLINK EQU $15 ; This field contains a timer for a platform's incoming blink. Afaik this only for used Shere Khan.
def ATR_FALLING_TIMER EQU $16 ; This field contains the counter for falling platforms.
def ATR_HEALTH EQU $17 ; This field contains the health of the enemy. Only the lower nibble is relevant for the health.
; 0 = nothing, 1 = diamond, 2 = pineapple, 3 = health package, 4 = extra life,  5 = mask, 6 = extra time, 7 = shovel, 8 = double banana, 9 = boomerang
def ATR_LOOT EQU $17 ; This field contains the loot dropped by the enemies. Only the upper nibble is relevant for the loot.

; See ATR_SPRITE_PROPERTIES and ATR_FACING_DIRECTION.
def OBJECT_FACING_RIGHT EQU $01
def OBJECT_FACING_LEFT EQU $ff
def SPRITE_WHITE_MASK EQU $10 ; 1 -> object turns white, 0 -> object keeps its normal color
def SPRITE_X_FLIP_MASK EQU $20
def SPRITE_Y_FLIP_MASK EQU $40
def SPRITE_INVISIBLE_MASK EQU $80

def LOOT_HEALTH_PACKAGE EQU $30
def FALLING_PLATFORM_TIME EQU 48 ; Time after which a falling platform falls down.
def WIGGLE_THRESHOLD EQU 24 ; Time after which a falling platfrm starts to wiggle.

; Attributes for projectiles.
def ATR_POSITION_DELTA EQU $07 ; Lower nibble contains signed x position delta of the object (basically the speed).
def ATR_SPRITE_FLIP EQU $07 ; Upper nibble tells if sprite needs to be flipped (0 = no flip, 2 = x flip, 4 = y flip).
def ATR_BANANA_SHAPED EQU $0b ; Is non-zero if the projectile is banana-shaped.
def ATR_ANIMATION_COUNTER EQU $0c ; Timer used for animations.
def ATR_SPRITE_INDEX EQU $0d ; TODO: I think this holds the index for the current sprite.
def ATR_PROJECTILE_12 EQU $12 ; TODO

; There are 22 event sounds in total. Played by EventSound ($c501) variable.
def EVENT_SOUND_PROJECTILE EQU 0
def EVENT_SOUND_STONE EQU 1
def EVENT_SOUND_JUMP EQU 2
def EVENT_SOUND_LAND EQU 3
def EVENT_SOUND_CATAPULT EQU 4
def EVENT_SOUND_TELEPORT_END EQU 5
def EVENT_SOUND_TELEPORT_START EQU 6
def EVENT_SOUND_DAMAGE_RECEIVED EQU 7
def EVENT_SOUND_DIED EQU 8
def EVENT_ENEMY_HIT EQU 9                ; When hitting an enemy with a projectile.
def EVENT_SOUND_HOP_ON_ENEMY EQU 10
def EVENT_SOUND_BALL EQU 11
def EVENT_SOUND_BOSS_DEFEATED EQU 12
def EVENT_SOUND_ITEM_COLLECTED EQU 13
def EVENT_SOUND_LVL_COMPLETE EQU 14
def EVENT_SOUND_EXPLOSION EQU 15
def EVENT_SOUND_BRAKE EQU 16
def EVENT_SOUND_SNAKE_SHOT EQU 17       ; Also the sound of the shot by frogs.
def EVENT_SOUND_ELEPHANT_SHOT EQU 18
def EVENT_SOUND_OUT_OF_TIME EQU 21

def BIT_A EQU %1
def BIT_B EQU %10
def BIT_SELECT EQU %100
def BIT_START EQU %1000
def BIT_RIGHT EQU %10000
def BIT_LEFT EQU %100000
def BIT_UP EQU %1000000
def BIT_DOWN EQU %10000000

def SCORE_ENEMY_HIT EQU $05 ; Gives you 5 << 1 = 50 points.
def SCORE_WEAPON_COLLECTED EQU $10 ; Gives you 10 << 1 = 100 points.
def SCORE_ENEMY_HOP_KILL EQU $30 ; Gives you 30 << 1 = 300 points.
def SCORE_EXTRA_TIME EQU $50 ; Gives you 50 << 1 = 500 points.
def SCORE_PINEAPPLE EQU $01 ; For pineapple as well as other items. Gives you 01 << 3 = 1000 points
def SCORE_BOSS_DEFEATED EQU $01 ; Gives you 01 << 3 = 1000 points.
def SCORE_DIAMOND EQU $05 ; Gives you $05 << 3 = 5000 points.
def SCORE_DIAMOND_TRANSITION EQU $02 ; In the transition level you get additional points for diamonds.
def SCORE_TIME EQU $10 ; Gives you $10 << 1 = 100 points. Points for remaining time when finishing a level. In practice mode the nibbles are swapped.

; Object IDs.
DEF ID_BOAR EQU $01
DEF ID_WALKING_MONKEY EQU $05
DEF ID_COBRA EQU $0b
DEF ID_EAGLE EQU $0f                   ; The eagle that picks you up after finishing a level.
DEF ID_KING_LOUIE_SLEEP EQU $18
DEF ID_STANDING_MONKEY EQU $1a
DEF ID_CRAWLING_SNAKE EQU $20
DEF ID_FLYING_STONES EQU $24
DEF ID_CROCODILE EQU $28               ; As in Level 4.
DEF ID_KAA EQU $2b
DEF ID_BOSS EQU $2c                    ; TODO: Generally related to all bosses.
DEF ID_FLYING_BIRD EQU $47
DEF ID_FISH EQU $54
DEF ID_HIPPO EQU $59
DEF ID_BAT EQU $5c
DEF ID_SCORPION EQU $67
DEF ID_FROG EQU $6d
DEF ID_ARMADILLO_WALKING EQU $71
DEF ID_ARMADILLO_ROLLING EQU $75
DEF ID_PORCUPINE_WALKING EQU $79
DEF ID_PORCUPINE_ROLLING EQU $7d
DEF ID_FALLING_PLATFORM EQU $84
DEF ID_LIZZARD EQU $85
DEF ID_DIAMOND EQU $89
DEF ID_100LABEL EQU $8c                 ; The "100" score label when collecting a weapon.
DEF ID_500LABEL EQU $8d                 ; The "500" score label when collecting additional time.
DEF ID_1000LABEL EQU $8e                ; The "1000" score label.
DEF ID_5000LABEL EQU $8f                ; The "5000" score label when collecting a diamond.
DEF ID_1UPLABEL EQU $90                 ; The "1UP" label when collecting an extra life.
DEF ID_MONKEY_COCONUT EQU $92           ; Also projectiles from Kaa, and the monkey boss.
DEF ID_KING_LOUIE_COCONUT EQU $93
DEF ID_PROJECTILE_STONES EQU $94
DEF ID_PROJECTILE_BANANA EQU $95        ; This includes the boomerang banana.
DEF ID_PINEAPPLE EQU $97                ; Weirdly, this also shares the same ID as Shere Khan's flame projectile.
DEF ID_FIRE_PROJECTILE EQU $97
DEF ID_CHECKPOINT EQU $98
DEF ID_GRAPES EQU $9a
DEF ID_EXTRA_LIFE EQU $9b
DEF ID_MASK_OR_LEAF EQU $9c             ; ID for mask. In the bonus level, this is the ID for a leaf.
DEF ID_EXTRA_TIME EQU $9d
DEF ID_SHOVEL EQU $9e
DEF ID_DOUBLE_BANANA EQU $9f            ; Depends on the level. See ID_STONES.
DEF ID_STONES EQU $9f                   ; Depends on the level. See ID_DOUBLE_BANANA
DEF ID_BOOMERANG EQU $a0
DEF ID_SNAKE_PROJECTILE EQU $a1         ; Also frog and scorpion projcetile.
DEF ID_HANGING_MONKEY EQU $a2
DEF ID_HANGING_MONKEY2 EQU $a4
DEF ID_SITTING_MONKEY EQU $a9
DEF ID_TURTLE EQU $ac
DEF ID_SINKING_STONE EQU $ae            ; Sinking stone and catapult share the same ID.
DEF ID_CATAPULT EQU $ae                 ; Sinking stone and catapult share the same ID.
DEF ID_BALOO EQU $b7
DEF ID_MONKEY_BOSS_TOP EQU $c3
DEF ID_MONKEY_BOSS_MIDDLE EQU $c9
DEF ID_MONKEY_BOSS_BOTTOM EQU $c9
DEF ID_VILLAGE_GIRL EQU $e2
DEF ID_SHERE_KHAN EQU $f2

def PTR_SIZE EQU 2                      ; Size of a pointer in bytes.
def SPRITE_SIZE EQU 16                  ; Size of a regular sprite in bytes.
def TILEMAP_SIZE EQU $400               ; Size of a tilemap.
def DMA_CYCLES EQU 160
def WINDOW_PALETTE EQU %11100100        ; Color palette used for the window.
def WINDOW_Y_SCROLL EQU 180             ; Y position of the window.
def WINDOW_Y_START EQU 119              ; After this scan line, the window is drawn instead of the background.

charmap "(", $f3
charmap ")", $f4
charmap "?", $f5
charmap ":", $f6

; Non-zero if object is empty.
MACRO IsObjEmpty
    bit 7, [hl]
ENDM

; Immediately delete the current object. Object pointer needs to be in "hl".
; Used for projectiles.
MACRO DeleteObject
    set 7, [hl]
ENDM

; Safely delete the current object. Object pointer needs to be in "hl".
; Used for things that have some kind of destructor (enemy kill animation, etc.).
MACRO SafeDeleteObject
    set 6, [hl]
ENDM

; Used with entries in ObjectsStatus.
MACRO IsObjectActive
    bit 4, a
ENDM

; Return of address of lower tile map index.
; Args: register to be loaded with address, x coordinate, y coordinate. Maximum (32,32).
MACRO TilemapLow
    ld \1, $9800 + \3 * 32 + \2
ENDM

; Return of address of upper tile map index.
; Args: register to be loaded with address, x coordinate, y coordinate. Maximum (32,32).
MACRO TilemapHigh
    ld \1, $9c00 + \3 * 32 + \2
ENDM

; Args: register to be loaded with address, index
MACRO TileDataLow
    ld \1, $8000 + \2 * 16
ENDM

; Args: register to be loaded with address, index
MACRO TileDataHigh
    ld \1, $8800 + \2 * 16
ENDM

INCLUDE "bank_000.asm"
INCLUDE "bank_001.asm"
INCLUDE "bank_002.asm"
INCLUDE "bank_003.asm"
INCLUDE "bank_004.asm"
INCLUDE "bank_005.asm"
INCLUDE "bank_006.asm"
INCLUDE "bank_007.asm"