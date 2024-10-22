; Disassembly of "jb.gb"
; This file was created with:
; mgbdis v2.0 - Game Boy ROM disassembler by Matt Currie and contributors.
; https://github.com/mattcurrie/mgbdis

INCLUDE "hardware.inc"

def JoyPadData EQU $c100 ; From MSB to LSB (1=pressed): down, up, left, right, start, select, B, A.
def JoyPadNewPresses EQU $c101
def PhaseTODO EQU $c102 ; Toggles once per frame from 0 to 1. I guess this is some kind of phase.
def TimeCounter EQU  $c103 ; 8-bit time register. Increments ~60 times per second.
; WARNING $c106 is also used differently in other contexts.
def WindowScrollYLsb EQU $c106 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollYMsb EQU $c107 ; Window scroll in y direction. Decrease from bottom to top.
def WindowScrollXLsb EQU $c108 ; Window scroll in x direction. Increases from left to right.
def WindowScrollXMsb EQU $c109 ; Window scroll in x direction. Increases from left to right.

def CurrentLevel EQU $c110  ; Between 0-9.
def NextLevel EQU $c10e ; Can be $ff in the start menu.
def DifficultyMode EQU $c111 ; 0 = NORMAL, 1 =  PRACTICE
def CheckpointReached EQU $c112 ; 0 = no checkpoint, 8 = checkpoint

def BgScrollXMsbEights EQU $c11d ; Window scroll MSB in x direction divided by 8.
def BgScrollXLsb EQU $c125 ; Window scroll in x direction. Increases from left to right.
def BgScrollXMsb EQU $c126 ; Window scroll in x direction. Increases from left to right.
def BgScrollYLsb EQU $c136 ; Window scroll in y direction. Increases from top to bottom.
def BgScrollYMsb EQU $c137 ; Window scroll in y direction. Increases from top to bottom.

def NextLevel2 EQU $c10f ; Next level.
def PlayerPositionXLsb EQU $c13f ; Player's global x position on the map. LSB.
def PlayerPositionXMsb EQU $c140 ; Player's global x position on the map. MSB.
def PlayerPositionYLsb EQU $c141 ; Player's global y position on the map. LSB.
def PlayerPositionYMsb EQU $c142 ; Player's global y position on the map. MSB.

def FacingDirection EQU $c146; = $01 if facing to the right, $ff if facing to the left.
def FacingDirection2 EQU $c148; = $01 if facing to the right, $ff if facing to the left. What is the difference to $c146?
def MovementState EQU $c149 ; 0 if not moving, 1 if walking, 2 if falling.
def IsCrouching EQU $c152 ; Turns $0f is player is crouching.
def CrouchingHeadTiltTimer EQU $c153 ; Timer for the head tilt animation when crouching.
def CrouchingHeadTilted EQU $c154 ; If 1 player tilts his head when crouching. This variable is also used for other animation stuff.
def LandingAnimation EQU $c16f ; Animation when the player is landing.
def IsJumping EQU $c172 ; Turns $f is player is jumping (just the upgoing part).

def LookingUp EQU $c178 ; Turns $ff when you are looking up.
def LookingUpAnimation EQU $c179 ; Seems to hold a counter for the animation when looking up.
def CrouchingAnimation EQU $c17a ; Seems to hold a counter for the animation when crouching.
def ProjectileFlying EQU $c181 ; Turns $ff when a projectile is flying and player is standing still. Limits the number of projectiles per time while you are standing.
def HeadSpriteIndex EQU $c18d ; Index of the sprite used for the head.
def HeadSpriteIndex2 EQU $c18e ; Index of the sprite used for the head. TODO: Difference between c18d?

; WeaponSelect refers to the weapon currently displayed, while WeaponSelect2 is used similarly but switches to banana when mask is selected
; as you can shoot bananas during invincibility.
def WeaponSelect2 EQU $c182 ; 0 = banana, 1 = double banana, 2 = boomerang, 3 = stones
def WeaponSelect EQU $c183 ; 0 = banana, 1 = double banana, 2 = boomerang, 3 = stones, 4 = mask
def AmmoBase EQU $c184 ; Base address of the following array.
def CurrentNumDoubleBanana EQU $c185 ; Current number of super bananas you have. Each nibble represents one decimal digit.
def CurrentNumBoomerang EQU $c186 ; Current number of boomerangs you have. Each nibble represents one decimal digit.
def CurrentNumStones EQU $c187 ; Current number of stones you have. Each nibble represents one decimal digit.
def CurrentSecondsInvincibility EQU $c188 ; Current seconds of invincibility you have left. Each nibble represents one decimal digit.
def InvincibilityTimer EQU $c189 ; Decrements ~15 times per second.

def CurrentLives EQU $c1b7; Current number of lives.
def CurrentHealth EQU $c1b8 ; Current health.
def CurrentHealthDiv4 EQU $c1b9 ; Current health divided by 4.
def NumDiamondsMissing EQU $c1be ; Current number of diamonds you still need to complete the level.
def CurrentScore1 EQU $c1bb ; Leftmost two digits of the current score.
def CurrentScore2 EQU $c1bc ; Nex two digits of the current score.
def CurrentScore3 EQU $c1bd ; Righmost two digits of the current score.
def MaxDiamondsNeeded EQU $c1bf ; Maximum number of diamonds you still need. 7 in practice. 10 in normal.
def FirstDigitSeconds EQU $c1c3 ; First digit of remaining seconds (DigitMinutes : SecondDigitSeconds FirstDigitSeconds).
def SecondDigitSeconds EQU $c1c4 ; Second digit of remaining seconds (DigitMinutes : SecondDigitSeconds FirstDigitSeconds).
def DigitMinutes EQU $c1c5 ; Digit of remaining minutes.
def IsPaused EQU $c1c6 ; True if the game is paused.
def ColorToggle EQU $c1c7 ; Color toggle used for pause effect.
def PauseTimer EQU $c1c8 ; Timer that increases when game is paused. Used to toggle ColorToggle.
def PlayerFreeze EQU $c1ca ; If !=0, the player and the game timer freezes.
def CurrentSong2 EQU $c1cb ; TODO: There seem to be 11 songs.
def NumContinuesLeft EQU $c1fc ; Number of continues left.
def CanContinue EQU $c1fd ; Seems pretty much like NumContinuesLeft. If it reaches zero, the game starts over.
def ContinueSeconds EQU $c1fe ; Seconds left during "CONTINUE?" screen.
def CurrentSong EQU $c500 ; TODO: Still not sure. $c4 = fade out. $07 died sound.
def EventSound EQU $c501 ; Sounds of certain events. See EVENT_SOUND*.
def CurrentSoundVolume EQU $c5be ; There are 8 different sound volumes (0 = sound off, 7 = loud)

def OldRomBank EQU $7fff

def MAX_HEALTH EQU 52 ; Starting health.
def MINUTES_PER_LEVEL EQU 5 ; Number of minutes per level.
def NUM_CONTINUES_NORMAL EQU 4 ; Number of continues for the normal mode.
def NUM_CONTINUES_PRACTICE EQU 6 ; Number of continues for the practice mode.
def NUM_DIAMONDS_NORMAL EQU $10  ; Number of diamonds needed in normal mode. Note that each nibble represents one decimal digit.
def NUM_DIAMONDS_PRACTICE EQU 7 ; Number of diamonds needed in practice mode.
def NUM_LIVES EQU 6 ; Number of lives.
def NUM_BANANAS EQU $99 ; Number of bananas.
def NUM_WEAPONS EQU 5 ; Number of weapons (banana, double bananas, boomerang, stones, mask)

def BIT_IND_A EQU 0
def BIT_IND_B EQU 1
def BIT_IND_SELECT EQU 2
def BIT_IND_START EQU 3
def BIT_IND_RIGHT EQU 4
def BIT_IND_LEFT EQU 5
def BIT_IND_UP EQU 6
def BIT_IND_DOWN EQU 7

def WEAPON_BANANA EQU 0
def WEAPON_DOUBLE_BANANA EQU 1
def WEAPON_BOOMERANG EQU 2
def WEAPON_STONES EQU 3
def WEAPON_MASK EQU 4

; There are 22 event sounds in total.
def EVENT_SOUND_PROJECTILE EQU 0
def EVENT_SOUND_STONE EQU 1
def EVENT_SOUND_JUMP EQU 2
def EVENT_SOUND_LAND EQU 3
def EVENT_SOUND_HIGHJUMP EQU 4
def EVENT_SOUND_ITEM_COLLECTED EQU 6
def EVENT_SOUND_DAMAGE_RECEIVED EQU 7
def EVENT_SOUND_DIED EQU 8
def EVENT_ENEMY_HIT EQU 9
def EVENT_SOUND_HOP_ON_ENEMY EQU 10
def EVENT_SOUND_BALL EQU 11
def EVENT_SOUND_CHECKPOINT EQU 13
def EVENT_SOUND_EXPLOSION EQU 15
def EVENT_SOUND_BRAKE EQU 16
def EVENT_SOUND_SNAKE_SHOT EQU 17
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

charmap "(", $f3
charmap ")", $f4
charmap "?", $f5
charmap ":", $f6

INCLUDE "bank_000.asm"
INCLUDE "bank_001.asm"
INCLUDE "bank_002.asm"
INCLUDE "bank_003.asm"
INCLUDE "bank_004.asm"
INCLUDE "bank_005.asm"
INCLUDE "bank_006.asm"
INCLUDE "bank_007.asm"