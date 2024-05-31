SECTION "bank0", ROM0[$0]

LoadRomBank:
  ld [$2000], a ; a = ROM bank index
  ret
  nop
  nop
  nop
  nop

MemsetZero:
  ld [hl], $00
  inc hl
  dec bc
  ld a, b
  or c
  jr nZ, MemsetZero
  ret