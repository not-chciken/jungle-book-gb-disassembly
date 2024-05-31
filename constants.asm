; Special Registers.

DEF rAUDVOL           EQU $ff24 ; Channel control / ON-OFF / Volume (R/W)
DEF rAUDTERM          EQU $ff25 ; Selection of Sound output terminal (R/W)
DEF rAUDENA           EQU $ff26 ; Sound on/off
DEF rSCY              EQU $ff42 ; Scroll Y (R/W)
DEF rSCX              EQU $ff43 ; Scroll X (R/W)
DEF rLCDC             EQU $ff40 ; LCD Control (R/W)
DEF rLY               EQU $ff44 ; LCDC Y-Coordinate (R)
DEF rLYC              EQU $ff45 ; LY Compare (R/W)
DEF rWY               EQU $ff4a ; Window Y Position (R/W)
DEF rWX               EQU $ff4b ; Window X Position minus 7 (R/W)
DEF rIE               EQU $ffff ; Interrupt Enable (R/W)


; Memory regions.
DEF ROM_BANK_SELECT        EQU $2000
DEF WNDW_TILE_MAP_LOW      EQU $9800
DEF WNDW_TILE_MAP_HIGH     EQU $9c00
DEF INTERNAL_RAM_LOW       EQU $c000
DEF IO_PORTS               EQU $ff00
DEF INTERNAL_RAM_HIGH      EQU $ff80

; Memory region sizes
DEF WNDW_TILE_MAP_SIZE      EQU $800