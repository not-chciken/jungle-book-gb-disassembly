SECTION "bank0", ROM0[$0]

INCLUDE "constants.asm"

; a = ROM bank index
LoadRomBank:
  ld [ROM_BANK_SELECT], a
  ret
  nop
  nop
  nop
  nop

; Sets lower and upper window tile map to zero.
ResetWndwTileMapLow:
   ld bc, WNDW_TILE_MAP_SIZE
   ld hl, WNDW_TILE_MAP_LOW
   jr MemsetZero

ResetSpriteTable:
  ld bc, $a0
  ld hl, INTERNAL_RAM
  call MemsetZero
  ld hl, INTERNAL_RAM
  ld bc, $1ff8

; hl = start address, bc = length
MemsetZero:
  ld [hl], $00
  inc hl
  dec bc
  ld a, b
  or c
  jr nZ, MemsetZero
  ret

; Waits for RegLY 128 and then stops display operation
StopDisplay:
  di
  ld a, [rIE]
  ld c, a
  res 0, a
  ld [rIE], a
: ld a, [rLY]
  cp $91
  jr nZ, :-
  ld a, [rLCDC]
  and $7f
  ld [rLCDC], a
  ld a, c
  ld [rIE], a
  ret
