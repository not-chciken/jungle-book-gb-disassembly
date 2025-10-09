INCLUDE "hardware.inc"

def SpriteToOamData EQU $c000 ; Sprite data to transfer to the OAM.
def PlayerSpritesOam EQU $c000 ; 6 * 4 bytes of data for the player sprite attributes. These bytes are transferred to OAM.
def ObjectSpritesOam EQU $c018 ; Data for the object sprite attributes. These bytes are transferred to OAM.

def JoyPadData EQU $c100 ; From MSB to LSB (1=pressed): down, up, left, right, start, select, B, A.
def JoyPadNewPresses EQU $c101
def VBlankIsrFinished EQU $c102 ; Toggles once per frame from 0 to 1. I guess this is some kind of phase.
def TimeCounter EQU  $c103 ; 8-bit time register. Increments ~60 times per second.
def Phase EQU $c104 ; The game's engine works in two phases.

; WARNING $c106 is also used differently in other contexts.
def WindowScrollYLsb EQU $c106 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollYMsb EQU $c107 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollXLsb EQU $c108 ; Window scroll in x direction. Increases from left to right.
def WindowScrollXMsb EQU $c109 ; Window scroll in x direction. Increases from left to right. Beware: $c109 is used for other stuff as well.
def AddressDecompTargetLsb EQU $c109 ; Start address of the decompression destination. Beware: $c109 is used for other stuff as well.
def AddressDecompTargetMsb EQU $c10a ; Start address of the decompression destination. Beware: $c10a is used for other stuff as well.

def ObjXPosition4To12 EQU $c106  ; Contains Bit 4 to Bit 12 of an object's X position.
def ObjYPosition4To12 EQU $c107  ; Contains Bit 4 to Bit 12 of an object's Y position.
def ObjXPosition0To7 EQU $c108 ; Contains Bit 0 to Bit 7 of an object's X position.
def ObjYPositionLsb EQU $c109 ; Contains the LSB of an object's Y position.

def SpriteYPosition EQU $c106
def SpriteXPosition EQU $c107
def SpriteVramIndex EQU $c108
def SpriteFlags EQU $c109

def Lz77BitBuffer EQU $c106

def SpritesYOffset EQU $c10a ; Accounts for BgScrollYOffset and wiggle.
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
def DawnPatrolLsb EQU $c12d ; Somehow related to the dawn patrol in Level 3.
def DawnPatrolMsb EQU $c12e ; Somehow related to the dawn patrol in Level 3.
def BalooElephantXLsb EQU $c12f
def BalooElephantXMsb EQU $c130

def ScrollY EQU $c132 ; This minus an offset controls rSCY.
def BalooDpLayer1OffsetLsb EQU $c134 ; This offset is added to Layer1BgPtrs.
def BalooDpLayer1OffsetMsb EQU $c135 ; This offset is added to Layer1BgPtrs.
def BgScrollYLsb EQU $c136 ; Window scroll in y direction. Increases from top to bottom. Anchor is top left corner of the screen.
def BgScrollYMsb EQU $c137 ; Window scroll in y direction. Increases from top to bottom. Anchor is top left corner of the screen.
def FutureBgScrollYLsb EQU $c138 ; Used for teleports.
def FutureBgScrollYMsb EQU $c139 ; Used for teleports.

def ScrollOffsetY EQU $c13a ; Only goes non-zero if there is wiggle.

def ObjYWiggle EQU $c13b ; Y offset for certain objects (elephant, turtles, etc).
def PlayerYWiggle EQU $c13e ; Y offset for the player. Used when standing on a turtle, for example.

def BgScrollYOffset EQU $c13c  ; Offset for BG scroll Y.
def BgScrollYWiggle EQU $c13d  ; Used to steer BgScrollYOffset. Related to explosions.

def PlayerPositionXLsb EQU $c13f ; Player's global x position on the map. LSB.
def PlayerPositionXMsb EQU $c140 ; Player's global x position on the map. MSB.
def PlayerPositionYLsb EQU $c141 ; Player's global y position on the map. LSB.
def PlayerPositionYMsb EQU $c142 ; Player's global y position on the map. MSB.

def PlayerWindowOffsetX EQU $c144 ; Relative offset in x direction between player and window. 0 if player at the left side of the screen.
def PlayerWindowOffsetY EQU $c145 ; Relative offset in y direction between player and window. 0 if player at the top of the screen.

def FacingDirection EQU $c146; = $01 if facing to the right, $ff if facing to the left.
def LianaClimbSpriteDir EQU $c147 ; When the player climbs a liana, the game alternatively flips the the sprite to get this "left-right-left-right" climbing motion. -1 is right arm moving up, 1 is left arm moving up.
def SpriteFacingDirection EQU $c148; = 1 if player sprites face to the right, -1 if they face to the left. FacingDirection cannot be directly used because of the liana climbing animation.
def MovementState EQU $c149 ; 0 if not moving, 1 if walking, 2 if falling (or traversering a liana), 3 if climbing a liana, 4 if swinging on a liana, 6 if dropping from a liana.

def IsPlayerDead EQU $c14a ; Goes when $ff when the player dies.

def LeftLvlBoundingBoxXLsb EQU $c14b  ; Left-side bounding box which is actives when entering the boss fight.
def LeftLvlBoundingBoxXMsb EQU $c14c  ; Left-side bounding box which is actives when entering the boss fight.
def LvlBoundingBoxXLsb EQU $c14d ; Bounding box of the level in x direction (LSB).
def LvlBoundingBoxXMsb EQU $c14e ; Bounding box of the level in x direction (MSB).
def LvlBoundingBoxYLsb EQU $c14f ; Bounding box of the level in x direction (LSB).
def LvlBoundingBoxYMsb EQU $c150 ; Bounding box of the level in x direction (MSB).

def AnimationCounter EQU $c151 ; Animation counter used differently in other contexts.
def CrouchingAnim EQU $c152 ; Iteratively turns 15 is player is crouching. This variable divided by 8 determines animation index.
def CrouchingHeadTiltTimer EQU $c153 ; Timer for the head tilt animation when crouching.
def CrouchingHeadTilted EQU $c154 ; This variable is used for different animation stuff. If 1 player tilts his head when crouching. Counts from 0 to 11 for the liana climbing animation. TODO: Rename.
def JoyPadDataNonConst EQU $c155 ; Mirrors JoyPadData. However, some bits may be reset by individual functions.

def CurrentGroundType EQU $c156 ; Contains the current ground type the player is standing on.
def PlayerInWaterOrFire EQU $c157 ; Goes non-zero if player is standing in water or fire.
def DynamicGroundDataType EQU $c158 ; Contains ground type of dynamic ground (turtles, platforms, floating Baloo, etc.).
def DynamicGroundPlayerPosition EQU $c159 ; Position of the player on the dynamic ground if there is one.
def DynamicGroundYPosition EQU $c15a ; Y position of the current dynamic ground if there is one.
def PlayerOnLiana EQU $c15b ; Turns non-zero if player is hanging on a liana. Bit 0: Set if player is on liana, Bit 1: Set if player is swinging, Bit 2: set if liana swinging without player
def CurrentLianaIndex EQU $c15c ; Index of the liana the player is currently. $ff if player is not attached to any liana. This does not include U-liana.
def CurrentLianaYPos8 EQU $c15d ; Y position / 8 of the current liana.

def PlayerSwingAnimIndex EQU $c15e ; Animation index of a swinging player. Between 0 and 6. 3 is middle. 0 is left. 6 is right. Between 2 and 4 when idling on a U-liana.
def ULianaCounter EQU $c15f ; Counter of the U-liana to trigger certain action.
def ULianaSwingDirection EQU $c160 ; Direction of the player when singing on a U-liana. Alternates between -1 and 1 when idling on a U-liana.
def ULianaTurn EQU $c161 ; -1 if the player turns left, 1 if the player turns right, else 0.
def PlayerSwingAnimIndex2 EQU $c163 ; Animation index of a swinging player. Copy of PlayerSwingAnimIndex.
def PlayerOnLianaYPosition EQU $c164 ; Related to a player's Y position on a liana (between 0 and 15). At a value of 4, a player can start to swing. 0 is top of the liana.
def LianaXPositionLsb EQU $c165 ; X position LSB of the straight liana the player is currently attached to.
def LianaXPositionMsb EQU $c166 ; X position MSB of the straight liana the player is currently attached to.
def PlayerPositionYLianaLsb EQU $c167 ; Player Y position LSB. Is not affected by swinging.
def PlayerPositionYLianaMsb EQU $c168 ; Player Y position MSB. Is not affected by swinging.

def PlayerOnULiana EQU $c169 ; 1 = hanging on U-liana, 2 = traversing on U-liana, 0 = else
def PLAYER_HANGING_ON_ULIANA EQU 1
def PLAYER_TRAVERSING_ULIANA EQU 2

def ULianaSpriteOffset EQU $c16b ; Sprite offset when the player is on a U-liana.
def PlayerSpriteYOffset EQU $c16c
def LandingAnimation EQU $c16f ; Animation when the player is landing. Is $ff when player is falling down.
def FallingDown EQU $c170 ; Increase/decreases when player is falling down/landing. Is 31 when in stable falling state.
def IsJumping EQU $c172 ; Turns $0f if player jumps and $f0 if player catapulted (only for the way up).
def UpwardsMomemtum EQU $c173 ; Upwards momemtum when jumping. The more momemtum, the higher you fly.
def JumpStyle EQU $c174 ; 0 = vertical, 1 = sideways, 2 = from slope, 3 = from liana
def PlayerKnockUp EQU $c175 ; Related to the player being knocked up by enemy hit, enemy kill, or dying. The greater the value, the higher the player is knocked up.
def KnockUpDirection EQU $c176 ; Player knock up direction.

def IsCrouching EQU $c177 ; Turns $ff is player is crouching. Else $00,
def LookingUpDown EQU $c178 ; Turns $ff when you are looking up. Turns $01 when looking down.
def LookingUpAnimation EQU $c179 ; Seems to hold a counter for the animation when looking up. Between 0 and 15.
def CrouchingHeadTiltDelay EQU $c17a ; Seems to hold a counter for the animation when crouching.
def HeadTiltCounter EQU $c17b ; Tilts the player's head once reaching 2.
def PlayerOnSlope EQU $c17c ; 0 = player not on a slope, 1 = player on slope, 2 = player on very steep slope
def WalkingState EQU $c17d ; 0 = doing nothing or braking, 1 = walking, $ff = running. Value is retained when player is in the air.
def WalkRunAccel EQU $c17e; Acceleration-like parameter between 0 and 9. Used to enable a smooth transition between walking and running.
def XAcceleration EQU $c17f ; $10 when running. $0f when direction change. $0c when pressing down while running. Decreased in the latter two cases.
def FacingDirection3 EQU $c180 ; The value of [FacingDirection] is copied into this variable.
def InShootingAnimation EQU $c181 ; Turns $ff when a projectile is in standing still shooting animation. Limits the number of projectiles per time while you are standing.

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
def InvincibilityTimer EQU $c189 ; Decrements ~15 times per second if mask is selected. Else it is zero.
def PlayerSpriteFlags EQU $c18a ; Sprite flags of the player's sprite. X flip is excluded.
def AllPlayerSpritesCopied EQU $c18b ; 0 if all prepared sprites have been transferred to the VRAM. $ff else.

def NumPlayerSpritesToDraw EQU $c18c
def AnimationIndexNew EQU $c18d ; Newest animation index. Needed to diff against AnimationIndex.
def AnimationIndexNew2 EQU $c18e ; Index of the sprite used for the head. TODO: Difference between c18d?
def AnimationIndexNew3 EQU $c18f ; Newest animation index. Needed to diff against AnimationIndex. Simply a copy of AnimationIndexNew?
def AnimationIndex EQU $c190 ; Related to the player's animations. 0 = standing, 1 looking at player, 3c = crouching, 3e = looking up, 3f = looking up sideways, 46 = falling, 50 = climbing

def VramAnimationPointerToggle EQU $c191
def VramAnimationPointerToggle2 EQU $c192
def VramAnimationPointerLsb EQU $c193 ; Holds an address to the current animation sprites in the VRAM.
def VramAnimationPointerMsb EQU $c194 ; Holds an address to the current animation sprites in the VRAM. Between $80 and $81.
def AnimationIndex2PointerLsb EQU $c195 ; Points to one element in PlayerAnimationIndices.
def AnimationIndex2PointerMsb EQU $c196 ; Points to one element in PlayerAnimationIndices.
def AnimPtr2Lsb EQU $c197
def AnimPtr2Msb EQU $c198
def PlayerSpritePointerMsb EQU $c199 ; Is setup with values from PlayerSpritePalettePointers. Points to 1 of 5 possible addresses.
def PlayerSpritePointerLsb EQU $c19a ; Is setup with values from PlayerSpritePalettePointers. Points to 1 of 5 possible addresses.
def JumpTimer EQU $c19b ; Used to let frogs and fishes jump. But also used for checkpoints.
def ActionObject EQU $c19c ; LSB of object that will change its state.
def ObjNumSpritesToDraw EQU $c19d ; Number of sprites to draw for a given object.
def NumObjSpriteIndex EQU $c19e ; Used in combination with obj[ATR_06] to determine the number of sprites for an object.

def ObjSpriteVramPtrLsb EQU $c19f ; VRAM location at which object sprites will be copied to.
def ObjSpriteVramPtrMsb EQU $c1a0 ; VRAM location at which object sprites will be copied to.
def ObjAnimationIndexPtrLsb EQU $c1a1
def ObjAnimationIndexPtrMsb EQU $c1a2
def ObjSpritePointerLsb EQU $c1a3
def ObjSpritePointerMsb EQU $c1a4
def ObjSpriteRomBank EQU $c1a5
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
def PlayerFreeze EQU $c1ca ; If !=0, the player cannot be controlled by inputs. Used for cutscenes like in the transition level.
def CurrentSong2 EQU $c1cb ; TODO: There seem to be 11 songs. 8 = standard, 9 = boss music.
def BossSongCounter EQU $c1cc ; Plays the boss music once it reaches 0.
def NeedNewXTile EQU $c1cd ; Turns to a non-zero value if new tile on X axis is needed. 1 = rigth, $ff = left.
def NeedNewYTile EQU $c1ce ; Turns to a non-zero value if new horizontal tiles are needed. Else 0.

def WndwBoundingBoxXLsb EQU $c1d0 ; Determines how far the window can scroll in x direction (LSB).
def WndwBoundingBoxXMsb EQU $c1d1 ; Determines how far the window can scroll in x direction (MSB).

; Usually X coordinate 0 is the left limit. However, this might be changed if a boss fight is started.
def WndwBoundingBoxXBossLsb EQU $c1d2 ; Determines how far the window can scroll to the left (LSB). Only used in boss fights.
def WndwBoundingBoxXBossMsb EQU $c1d3 ; Determines how far the window can scroll to the left (LSB). Only used in boss fights.

def WndwBoundingBoxYLsb EQU $c1d4 ; Determines how far the window can scroll in y direction (MSB).
def WndwBoundingBoxYMsb EQU $c1d5 ; Determines how far the window can scroll in y direction (MSB).

def NumLianas EQU $c1d6 ; Number of lianas in the current level.
def ActiveLianaToggle EQU $c1d7 ; Between 0 and 1 to toggle between ActiveLiana1 and ActiveLiana2.
def ActiveLiana1 EQU $c1d8 ; These lianas have active sprites that need to be transferred. Contains the low-byte of liana's address in LianaStatus.
def ActiveLiana2 EQU $c1d9 ; These lianas have active sprites that need to be transferred. Contains the low-byte of liana's address in LianaStatus.
def LianaPositionPtrLsb EQU $c1da
def LianaPositionPtrMsb EQU $c1db
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
def EagleTransitionState EQU $c1e6 ; Controls the sequence for the eagle in transition level.
def DiamondConvertTicks EQU $c1e7 ; Turns non-zero when collecting the bonus level item.
def BonusLevel EQU $c1e8 ; Turns non-zero when collecting the bonus level item.
def BalooFreeze EQU $c1e9 ; Turns non-zero when floating Baloo collides with a hippo.
def BossAnimation1 EQU $c1ea ; Current animation of the boss. =$ff if second monkey of monkey the boss is defeated.
def BossAnimation2 EQU $c1eb ; Current animation of the boss. =$ff if first monkey of monkey the boss is defeated.
def BossObjectIndex1 EQU $c1ed
def BossObjectIndex2 EQU $c1ee
def BossActive EQU $c1ef ; 0 if boss is not active. $ff if boss was activated and is still alive.
def BossMonkeyState EQU $c1f0 ; Only non-zero for the monkey boss. Indicates the state the monkeys are in.

def BossPlatformIndex0 EQU $c1f4 ; Platform object index in Shere Khan boss fight.
def BossPlatformIndex1 EQU $c1f5 ; Platform object index in Shere Khan boss fight.
def BossPlatformIndex2 EQU $c1f6 ; Platform object index in Shere Khan boss fight.
def ItemDespawnTimer EQU $c1f9 ; When reaching zero, items despawn. Only used for King Louie.

def FallingPlatformLowPtr EQU $c1fa ; Set up with lower byte of falling platform pointer.
def BossAction EQU $c1fb ; Determines which action is performed by the boss.
def NumContinuesLeft EQU $c1fc ; Number of continues left.
def CanContinue EQU $c1fd ; Seems pretty much like NumContinuesLeft. If it reaches zero, the game starts over.
def ContinueSeconds EQU $c1fe ; Seconds left during "CONTINUE?" screen.
def MissingItemsBonusLevel EQU $c1ff ; Remaining number of items to be collected in the bonus level.

def GeneralObjects EQU $c200 ; Start address of general objects. This includes enemies and items.
def ProjectileObjects EQU $c300 ; Start address of the projectile objects.
def ProjectileObject0 EQU $c300 ; First projectile object.
def ProjectileObject1 EQU $c320 ; Second projectile object.
def ProjectileObject2 EQU $c340 ; Third projectile object.
def ProjectileObject3 EQU $c360 ; Fourth projectile object.
def EnenemyProjectileObjects EQU $c380 ; Start address of enemy projectile objects.
def EnenemyProjectileObject0 EQU $c380 ; First enemy projectile objects.
def EnenemyProjectileObject1 EQU $c3a0 ; Second enemy projectile objects.

def NewTilesVertical EQU $c3c0 ; New vertical tiles are transferred into VRAM from this location.
def NewTilesHorizontal EQU $c3d8 ; New horizontal tiles are transferred into VRAM from this location.
def BalooDawnPatrolNewTMInds EQU $c3f0 ; New tile map indices of Baloo or the Dawn Patrol.
def GroundDataRam EQU $c400 ; Each element in this array corresponds to the ground data of a 2x2 meta tile. Most of it is zero (=no ground).

def CurrentSong EQU $c500 ; TODO: Still not sure. $c4 = fade out. $07 died sound.
def EventSound EQU $c501 ; Sounds of certain events. See EVENT_SOUND*.
def FadeOutCounterResetVal EQU $c502 ; Always $0c. Only used to copy its value into [$c506].
def TrackEnable EQU $c503 ; Always $c0. Bit 7: Enable song track; Bit 6: Enable event sound track. Weird: Pretty useless.
def ChannelEnable EQU $c504 ; Bit 0: Main voice (Square 1); Bit 1: Percustic wave (Square 2); Bit 2: Bass (Wave); Bit 4: Percussion (Noise)
def CurrentSongUnused EQU $c505 ; Set up with the lower 6 bits of CurrentSong. Weird: This variable seems to be completely unused.
def FadeOutCounter EQU $c506 ; Used to decrement the sound volume when song is fading out.
def SongDataRam EQU $c507 ; Song data is copied into [$c507:$c511]
def Square1VibratoCounter EQU $c534
def Square2VibratoCounter EQU $c535
def WaveVibratoCounter EQU $c536
def WaveTriggerEnable EQU $c538 ; Enables wave trigger if non-zero.
def Square1FrequencyLsb EQU $c53d ; The value of this variable is directly copied into NR13.
def Square1FrequencyMsb EQU $c53e ; The value of this variable is directly copied into NR14.
def SquareNR12Value EQU $c543 ; The value of this variable is directly copied into NR12.
def SquareNR11Value EQU $c546 ; The value of this variable is directly copied into NR11.
def Square1SweepDelay EQU $c553
def Square1SweepValue EQU $c554
def Square1VibratoBase EQU $c555
def Square1VibratoDelay EQU $c555 ; Period after which the vibrato starts.
def Square1Vibrato1 EQU $c556
def Square1Vibrato2 EQU $c557
def Square1Vibrato3 EQU $c558
def Square1VibratoDirection EQU $c559
def Square1VibratoDirCount EQU $c55a
def Square2FrequencyLsb EQU $c55f ; NR23
def Square2FrequencyMsb EQU $c560 ; NR24
def Square2SweepDelay EQU $c575
def Square2SweepValue EQU $c576
def Square2VibratoBase EQU $c577
def Square2VibratoDelay EQU $c577 ; Period after which the vibrato starts.
def Square2Vibrato1 EQU $c578
def Square2Vibrato2 EQU $c579
def Square2Vibrato3 EQU $c57a
def Square2VibratoDirection EQU $c57b
def Square2VibratoDirCount EQU $c57c

def WaveSoundVolume EQU $c57f ; General sound volume. Used to set up NR32. 0 -> 0, 1 -> 25%, 2 -> 50%, 3 -> 100%
def WaveSoundVolumeStart EQU $c580
def WaveNote EQU $c587 ; Determines the note played by the wave channel.
def WaveFrequencyLsb EQU $c588 ; NR33
def WaveFrequencyMsb EQU $c589 ; NR34
def WaveNoteBase EQU $c58a ; This value plus another value sets up [WaveNote].
def WaveSamplePalette EQU $c58c ; Index to a wave sample palette.

def WaveSweepDelay EQU $c599
def WaveSweepValue EQU $c59a
def WaveVibratoBase EQU $c59b
def WaveVibratoDelay EQU $c59b ; Period after which the vibrato starts.
def WaveVibrato1 EQU $c59c
def WaveVibrato2 EQU $c59d
def WaveVibrato3 EQU $c59e
def WaveVibratoDirection EQU $c59f
def WaveVibratoDirCount EQU $c5a0

def SoundHlMsb EQU $c5b7 ; TODO: What is in hl?
def SoundHlLsb EQU $c5b8 ; TODO: What is in hl?
def NoiseWaveControlBackup EQU $c5ba ; Is loaded with NoiseWaveControl. But this is never used?!
; Bit 0 controls noise trigger, Bit 1 controls noise setting, Bit 2 controls custom wave frequency, Bit 3 wave volume. Bit 7 resets this and other registers.
def NoiseWaveControl EQU $c5bb
def WaveVolume EQU $c5bc ; Used to set up sound register NR32 (wave volume).
def NoiseVolume EQU $c5bd ; Used to set up sound register NR42 (starting volume, envelope add mode, period).
def CurrentSoundVolume EQU $c5be ; There are 8 different sound volumes (0 = sound off, 7 = loud)

def SoundCounter EQU $c5c0 ; Counts down from 9 to 0 and then starts again from 9.
def PlayingEventSound EQU $c5c3  ; Index of the currently playing event sound. $ff if no event sound is playing.
def EventSoundNoteLength EQU $c5c5  ; This value determines the waiting length after an event sound register load.
def EventSoundDataPtrLsb EQU $c5c6
def EventSoundDataPtrMsb EQU $c5c7
def EventSoundRepeatCount EQU $c5c8
def EventSoundRepeatStartLsb EQU $c5c9
def EventSoundRepeatStartMsb EQU $c5ca
def EventSoundChannelsUsed EQU $c5cb ; Bit 0: Square1 in use, Bit 1: Square2 in use, Bit 2 = Wave in use, Bit 3 = Noise in use

; Bit 7: Object was defeated.
; Bit 4: Set if object is currently active
; Bit 3: Used for diamonds (and other objects) once they are collected.
; Bit 0-2: Index for corresponding entry in GeneralObjects.
def ObjectsStatus EQU $c600 ; Seems to hold some status for objects, like already found and so on. Size of array is given by NumObjects.


; 8 byte per liana. 16 slots in total = $80 bytes.
; Byte 5 contains the right limit of the liana.
; Byte 4 contains the left limit of the liana.
; Byte 3 contains liana swinging direction.
; Byte 1 contains an action counter. When it reaches 0, an action is performed.
; Byte 0, Bit 7 = 1 if liana swing
; Byte 0, Bit 6 = 1 if liana needs to redrawn.
; Byte 0, Bit 4 = 1 if liana is active
; Byte 0, Bit 2 = 1 if liana swings without player
; Byte 0, Bit 1 = 1 if liana swings with player
; Byte 0, Bit 0 = 1 if player on liana
def LianaStatus EQU $c660
def Ptr2x2BgTiles1 EQU $c700 ; First part of 2x2 background pointers (first half)
def Ptr2x2BgTiles2 EQU $c900 ; Second part of 2x2 background pointers (second half)
def Ptr4x4BgTiles1 EQU $cb00 ; First part of 4x4 background pointers (first half)
def Ptr4x4BgTiles2 EQU $cd00 ; Second part of 4x4 background pointers (second half)
def Layer1BgPtrs EQU $cf00 ; First layer of background pointers. Basically a 2D array with pointer to 4x4 meta tiles.
def StaticObjectData EQU $d700 ; Object data per level is decompressed at this address.

def OldRomBank EQU $7fff

def MAX_NUM_LIANAS EQU 16 ; Maximum number of lianas in a level.
def SIZE_LIANA_OBJ EQU 8 ; Size of a liana object in LianaStatus.
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

def SONG_00 EQU $00
def SONG_01 EQU $01 ; Dawn patrol.
def SONG_02 EQU $02 ; Kaa?
def SONG_03 EQU $03
def SONG_04 EQU $04
def SONG_05 EQU $05 ; Transition level music.
def SONG_06 EQU $06
def SONG_07 EQU $07 ; Game over jingle.
def SONG_08 EQU $08 ; "I wanna be like you"
def SONG_09 EQU $09 ; Boss music.
def SONG_0a EQU $0a ; Outro
def SONG_0b EQU $0b ; Boss found jingle.

def BIT_IND_A EQU 0
def BIT_IND_B EQU 1
def BIT_IND_SELECT EQU 2
def BIT_IND_START EQU 3
def BIT_IND_RIGHT EQU 4
def BIT_IND_LEFT EQU 5
def BIT_IND_UP EQU 6
def BIT_IND_DOWN EQU 7

; Needed for MovementState.
def STATE_IDLE EQU 0                ; Includes jumping up.
def STATE_WALKING EQU 1             ; Includes running, walking, and braking.
def STATE_FALLING EQU 2
def STATE_CLIMBING EQU 3
def STATE_SWINGING EQU 4
def STATE_LIANA_DROP EQU 6

; Values for AnimationIndexNew.
def STANDING_ANIM_IND EQU 0         ; Player standing, looking sideways.
def HEAD_TILT_ANIM_IND EQU 1        ; Player standing, looking at screen.
def WALK_ANIM_IND EQU 2             ; Player walking. Goes up to 9.
def RUN_ANIM_IND EQU 9              ; Player running Goes up to 21.
def LAND_JUMP_ANIM_IND EQU 22       ; Used for the start of a jump as well as landing.
def JUMP_SIDE_ANIM_IND EQU 23       ; Starting animations for a sideway jump.
def FALL_SIDE_IND EQU 27            ; Player falling from a sideways jump.
def DEATH_ANIM_IND EQU 29           ; Player dying and doing starfish-like hop.
def PIPE_45DEG_ANIM_IND EQU 31      ; Player using the pipe and shooting at a 45° angle.
def BRAKE_ANIM_IND EQU 32           ; Player braking.
def SWING_ANIM_IND EQU 35           ; Player swinging.
def PIPE_VERT_ANIM_IND EQU 42       ; Player using the pipe and shooting vertical.
def PIPE_SIDE_ANIM_IND EQU 43       ; Player using the pipe and shooting sideways.
def TRAVERSE_ANIM_IND EQU 44        ; Player traversing a U-liana.
def PIPE_CROUCH_ANIM_IND EQU 57     ; Player using the pipe while crouching.
def SHOOT_SIDE_ANIM_IND EQU 58      ; Player shooting sideways.
def CROUCH_ANIM_IND EQU 59          ; Player crouching.
def LOOK_UP_SIDE_ANIM_IND EQU 62    ; Player looking up and pressing right or left.
def LOOK_UP_VERT_ANIM_IND EQU 63    ; Player looking up.
def JUMP_VERT_ANIM_IND EQU 64       ; Player jumping vertically.
def FALL_VERT_ANIM_IND EQU 68       ; Player falling vertically.
def SHOOT_45DEG_ANIM_IND EQU 71     ; Player shooting sideways.
def SHOOT_VERT_ANIM_IND EQU 72      ; Player shooting vertically.
def SHOOT_CROUCH_ANIM_IND EQU 74   ; Player shooting while crouching.
def CLMBING_ANIM_IND EQU 75         ; Start index of the climbing animation.
def SHOVELING_ANIM_IND EQU 81       ; Start index of the shoveling animation.

def NUM_CLIMBING_ANIM_FRAMES EQU 6  ; In total, there are 6 climbing animation frames. However, they are mirrored, leading to 12 effective frames.

def GROUND_TYPE_TURTLE EQU $29
def GROUND_TYPE_CROC EQU $2a
def GROUND_TYPE_STONE EQU $2c
def GROUND_TYPE_HIPPO EQU $2e
def GROUND_TYPE_PLATFORM EQU $30

; Values for JumpStyle
def VERTICAL_JUMP EQU 0
def SIDEWAYS_JUMP EQU 1
def SLOPE_JUMP EQU 2
def LIANA_JUMP EQU 3

; Damage of the following weapons (except default banana) is calculated as follows:
; (index * 2 + 1) * (NormalMode ? 1 : 2)
def WEAPON_BANANA EQU 0             ; Damage = 3, 6
def WEAPON_DOUBLE_BANANA EQU 1      ; Damage = 3, 6
def WEAPON_BOOMERANG EQU 2          ; Damage = 5, 10
def WEAPON_STONES EQU 3             ; Damage = 7, 14
def WEAPON_MASK EQU 4

def DAMAGE_BANANA EQU 2         ; Damage of a default banana. Note that +1 is always added. In practice mode this is multiplied with 2.

def LOW_JUMP_MOMENTUM EQU 31
def DEFAULT_JUMP_MOMENTUM EQU 43
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

def WATER_FIRE_DAMAGE EQU 1 ; Damage received from water and fire.
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

; Various general properties
; Bit 7: Non-zero if object was deleted,
; Bit 6: Non-zero if destructor shall be called.
; Bit 5: 1 if object serves as a dynamic ground (turtle, crocdile, etc.) else 0
; Bit 4: 1 if object in screen, 0 if object off screen
; Bit 3: Different meanings depending on the object. For ball projectiles, this bit is set once, a direction has been determined.
; Bit 2: 1 if boss is awake, 0 if boss is still sleeping. Also seen in checkpoint objects.
; Bit 1: For mosquito: 1 if object was hit by a player's projectile or player else 0.
;        For fish: 1 if fish is lurking, 0 if fish is jumping.
; Bit 0: Set when frog is jumping
def ATR_STATUS EQU $00
; For $01, $02, $03, $04 see above.
def ATR_ID EQU $05 ; This field contains the type of the object. See ID_*.
def ATR_06 EQU $06 ; TODO
def ATR_SPRITE_PROPERTIES EQU $07 ; See SPRITE_*_MASK below. Upper nibble contains display properties of the sprites.
def ATR_FACING_DIRECTION EQU $07 ; $1 -> facing right, $f -> facing left, 0 -> no facing direction (like falling platforms)
def ATR_Y_POS_DELTA EQU $08 ; Related object behavior. E.g., frog shoots a projectile when this value reaches $ff.
def ATR_09 EQU $09 ; TODO
def ATR_FREEZE EQU $0a ; If !=0, the enemy stops to move.
def ATR_PERIOD_TIMER0_RESET EQU $0b ; If obj[ATR_PERIOD_TIMER0] goes zero, it is reset with the value in obj[ATR_PERIOD_TIMER0_RESET]
def ATR_PERIOD_TIMER0 EQU $0c ; TODO: Somehow related to an enemies periodic behavior.
def ATR_PERIOD_TIMER1 EQU $0d ; TODO: Somehow related to an enemies periodic behavior.
def ATR_PERIOD_TIMER1_RESET EQU $0e
def ATR_HITBOX_PTR EQU $0f ; If ==0, the object has no hitbox. $1 = projectiles, $2 = pineapple, $4 = monkey, $5 = snake, $6 = boar, $9 = snake, $a = floater, $15 = platform.
def ATR_STATUS_INDEX EQU $10 ; Holds an index for the array at ObjectsStatus ($c600).
def ATR_OBJECT_DATA EQU $11; Related to ActiveObjectsIds.
def ATR_12 EQU $12
def X_POS_LIM_LEFT EQU $13 ; X position limit for enemies that move horizontally. Different meaning for bosses.
def Y_POS_LIM_TOP EQU $13 ; Y position limit for enemies that move vertically. Different meaning for bosses.
def ATR_13 EQU $13
def X_POS_LIM_RIGHT EQU $14 ; X position limit for enemies that move horizontally. Different meaning for bosses.
def Y_POS_LIM_BOT EQU $14 ; Y position limit for enemies that move vertically. Different meaning for bosses.
def ATR_14 EQU $14
def ATR_PLATFORM_INCOMING_BLINK EQU $15 ; This field contains a timer for a platform's incoming blink. Afaik this only for used Shere Khan.
def ATR_WALK_ROLL_COUNTER EQU $15 ; Used for the state change of armadillos and porcupines.
def ATR_16 EQU $16
def ATR_FALLING_TIMER EQU $16 ; This field contains the counter for falling platforms and sinking stones.
def ATR_LIGHNTING_TIMER EQU $16 ; This field contains the counter for lightnings.
def ATR_MOSQUITO_TIMER EQU $16 ; This field contains the counter for mosquitoes.
def ATR_FISH_TIMER EQU $16 ; This counter determines the time between two jumps for fishes.
def ATR_HEALTH EQU $17 ; This field contains the health of the enemy. Only the lower nibble is relevant for the health.
; 0 = nothing, 1 = diamond, 2 = pineapple, 3 = health package, 4 = extra life,  5 = mask, 6 = extra time, 7 = shovel, 8 = double banana, 9 = boomerang
def ATR_LOOT EQU $17 ; This field contains the loot dropped by the enemies. Only the upper nibble is relevant for the loot.

; See ATR_SPRITE_PROPERTIES and ATR_FACING_DIRECTION.
def OBJECT_FACING_RIGHT EQU 1
def OBJECT_FACING_LEFT EQU -1
def SPRITE_WHITE_MASK EQU $10 ; 1 -> object turns white, 0 -> object keeps its normal color
def SPRITE_X_FLIP_MASK EQU $20
def SPRITE_Y_FLIP_MASK EQU $40
def SPRITE_INVISIBLE_MASK EQU $80
def IS_ROLLING_MASK EQU %100    ; 1 -> enemy is rolling; 0 -> enemy is walkking; Only applies to porcupines and armadillos.

def LOOT_HEALTH_PACKAGE EQU $30
def FALLING_PLATFORM_TIME EQU 48 ; Time after which a falling platform falls down.
def WIGGLE_THRESHOLD EQU 24 ; Time after which a falling platfrm starts to wiggle.
def FISH_JUMP_PAUSE_TIME EQU 12 ; Time between jumps of a fish.

; Attributes for projectiles.
; Status: Bit 7 = 1 if projectile was deleted
;         Bit 4 = 1 if projectile is active
;         Bit 2 = 1 for banana and boomerang banana
;         Bit 1 = 1 if projectile shall return (only used for boomerang banana)
;         Bit 0 = always 0 for bananas and stones, always 1 for boomerang
def ATR_POSITION_DELTA EQU $07 ; Lower nibble contains signed x position delta of the object (basically the speed).
def ATR_SPRITE_FLIP EQU $07 ; Upper nibble tells if sprite needs to be flipped (0 = no flip, 2 = x flip, 4 = y flip).
def ATR_BALL_VSPEED EQU $08 ; Negative -> going up; Positive -> going down.
def ATR_PROJECTILE_09 EQU $09 ; TODO
def ATR_PROJECTILE_0A EQU $0a ; TODO
def ATR_BANANA_SHAPED EQU $0b ; Is non-zero if the projectile is banana-shaped.
def ATR_ANIMATION_COUNTER EQU $0c ; Timer used for animations.
def ATR_BALL_UP_COUNTER EQU $0c ; Used for ball projectiles.
def ATR_SPRITE_INDEX EQU $0d ; TODO: I think this holds the index for the current sprite.
def ATR_PROJECTILE_0E EQU $0e ; TODO
def ATR_BALL_DOWN_COUNTER EQU $0e ; Used for ball projectiles.
def ATR_TARGET_Y_LSB EQU $10 ; At least for boomerang.
def ATR_TARGET_Y_MSB EQU $11 ; At least for boomerang.
def ATR_PROJECTILE_12 EQU $12 ; TODO
def ATR_TARGET_X_LSB EQU $13 ; At least for boomerang.
def ATR_TARGET_X_MSB EQU $14 ; At least for boomerang.
def ATR_SHOOT_DIRECTION EQU $15 ; Only used for the boomerang. Inherits the value of [PlayerDirection].

; Attributes for lianas. See LianaStatus.
def ATR_LIANA_0 EQU $00
def ATR_LIANA_TIMER EQU $01
def ATR_LIANA_2 EQU $02
def ATR_LIANA_FACING_DIR EQU $03
def ATR_LIANA_LEFT_LIM EQU $04
def ATR_LIANA_RIGHT_LIM EQU $05
def ATR_LIANA_TM_LSB EQU $06 ; LSB of the starting address in the tile map.
def ATR_LIANA_TM_MSB EQU $07 ; MSB of the starting address in the tile map.

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
def EVENT_SOUND_SNAKE_SHOT EQU 17       ; Also the sound of the shot by frogs and scorpions.
def EVENT_SOUND_ELEPHANT_SHOT EQU 18
def EVENT_SOUND_CROC_JAW EQU 19
def EVENT_SOUND_UNKNOWN EQU 20          ; Weird: This event sound is never used!
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
; Good to know: The ID's aren't evenly distributed, because the numbers inbetween are used to determine
; the number of sprites for an object's animation. See NumObjectSprites.
DEF ID_BOAR EQU $01
DEF ID_WALKING_MONKEY EQU $05
DEF ID_COBRA EQU $0b
DEF ID_EAGLE EQU $0f                   ; The eagle that picks you up after finishing a level.
DEF ID_ELEPHANT EQU $17
DEF ID_KING_LOUIE_SLEEP EQU $18
DEF ID_STANDING_MONKEY EQU $1a
DEF ID_CRAWLING_SNAKE EQU $20
DEF ID_MOSQUITO EQU $24
DEF ID_CROCODILE EQU $28               ; As in Level 4.
DEF ID_KAA EQU $2b
DEF ID_BOSS EQU $2c                    ; Generally related to all bosses. Used for the "zzzz" animation
DEF ID_FLYING_BIRD EQU $47
DEF ID_FLYING_BIRD_TURN EQU $4f
DEF ID_FISH EQU $54
DEF ID_HIPPO EQU $59
DEF ID_BAT EQU $5c
DEF ID_SCORPION EQU $67
DEF ID_FROG EQU $6d
DEF ID_ARMADILLO_WALKING EQU $71
DEF ID_ARMADILLO_ROLLING EQU $75
DEF ID_PORCUPINE_WALKING EQU $79
DEF ID_PORCUPINE_ROLLING EQU $7d
DEF ID_LIGHTNING EQU $81
DEF ID_FALLING_PLATFORM EQU $84
DEF ID_LIZZARD EQU $85
DEF ID_DIAMOND EQU $89
DEF ID_100LABEL EQU $8c                 ; The "100" score label when collecting a weapon.
DEF ID_500LABEL EQU $8d                 ; The "500" score label when collecting additional time.
DEF ID_1000LABEL EQU $8e                ; The "1000" score label.
DEF ID_5000LABEL EQU $8f                ; The "5000" score label when collecting a diamond.
DEF ID_1UPLABEL EQU $90                 ; The "1UP" label when collecting an extra life.
DEF ID_MONKEY_COCONUT EQU $92           ; Also projectiles from Kaa, and the monkey boss.
DEF ID_CHAR_B EQU $92                   ; Only used in transition level.
DEF ID_KING_LOUIE_COCONUT EQU $93
DEF ID_CHAR_O EQU $93                   ; Only used in transition level.
DEF ID_PROJECTILE_STONES EQU $94
DEF ID_CHAR_N EQU $94                   ; Only used in transition level.
DEF ID_PROJECTILE_BANANA EQU $95        ; This includes the boomerang banana.
DEF ID_CHAR_U EQU $95
DEF ID_CHAR_S EQU $96                   ; Only used in transition level.
DEF ID_PINEAPPLE EQU $97                ; Weirdly, this also shares the same ID as Shere Khan's flame projectile.
DEF ID_FIRE_PROJECTILE EQU $97          ; Weirdly, this also shares the same ID as the pineapple.
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
DEF ID_JUMPING_FROG EQU $af             ; Not really used as an ID, but at that ID the jumping frog sprites can be found.
DEF ID_BALOO EQU $b7
DEF ID_MONKEY_BOSS_TOP EQU $c3
DEF ID_MONKEY_BOSS_MIDDLE EQU $c9
DEF ID_MONKEY_BOSS_BOTTOM EQU $c9
DEF ID_VILLAGE_GIRL EQU $e2
DEF ID_SHERE_KHAN EQU $f2

def SPRITE_WIDTH EQU 8
def SPRITE_HEIGHT EQU 16
def PLAYER_HEIGHT EQU SPRITE_HEIGHT * 2
def PTR_SIZE EQU 2                      ; Size of a pointer in bytes.
def SPRITE_SIZE EQU 16                  ; Size of a regular sprite in bytes.
def TILEMAP_SIZE EQU $400               ; Size of a tilemap.
def DMA_CYCLES EQU 160
def WINDOW_PALETTE EQU %11100100        ; Color palette used for the window.
def DEFAULT_PALETTE EQU %11100100       ; Default color palette.
def WINDOW_Y_SCROLL EQU 180             ; Y position of the window.
def WINDOW_Y_START EQU 119              ; After this scan line, the window is drawn instead of the background.

charmap "(", $f3
charmap ")", $f4
charmap "?", $f5
charmap ":", $f6

MACRO SwitchToBank
    ld a, \1
    rst LoadRomBank                 ; Load ROM bank 6.
ENDM

; Non-zero if object is empty. Related to ATR_STATUS.
MACRO IsObjEmpty
    bit 7, [hl]
ENDM

; Non.zero if object is marked for safe delete.
MACRO ObjMarkedSafeDelete
    bit 6, [hl]
ENDM

; True if object is active and visible on screen.
MACRO IsObjOnScreen
    bit 4, [hl]
ENDM

; Non-zero if boss is awake.
MACRO IsBossAwake
    bit 2, [hl]
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

; Sets an object's attribute. Assumes object pointer in "hl".
MACRO SetAttribute
    IF \2 != 0
        ld a, \2
    ELSE
        xor a
    ENDC
    ld c, \1
    rst SetAttr
ENDM

; Increments "c" and sets an object's attribute. Assumes object pointer in "hl".
MACRO SetNextAttribute
    ld a, \1
    inc c
    rst SetAttr
ENDM

; Increments "c" and sets an object's attribute. Assumes object pointer in "hl".
MACRO SetNextAttribute2
    inc c
    ld a, \1
    rst SetAttr
ENDM

; Similar to SetAttribute, but with instructions differently ordered.
MACRO SetAttribute2
    ld c, \1
    ld a, \2
    rst SetAttr
ENDM

; Copies an object's attribute into "a". Assumes object pointer in "hl".
MACRO GetAttribute
    ld c, \1
    rst GetAttr
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