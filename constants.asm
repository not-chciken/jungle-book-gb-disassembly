; Special Registers.
DEF rLCDC             EQU $ff40 ; LCD Control (R/W)
DEF rLY               EQU $ff44 ; LCDC Y-Coordinate (R)
DEF rLYC              EQU $ff45 ; LY Compare (R/W)
DEF rIE               EQU $ffff ; Interrupt Enable (R/W)


; Memory regions.
DEF ROM_BANK_SELECT        EQU $2000
DEF WNDW_TILE_MAP_LOW      EQU $9800
DEF WNDW_TILE_MAP_HIGH     EQU $9c00
DEF INTERNAL_RAM           EQU $c000

; Memory region sizes
DEF WNDW_TILE_MAP_SIZE      EQU $800