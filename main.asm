SECTION "bank0", ROM0

LoadRomBank:
  ld [$2000], a ; a = ROM bank index
  ret
  nop
  nop
  nop
  nop