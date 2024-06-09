#!/bin/bash
rgbasm -Wunmapped-char=0 main.asm -o jungle_book.o
rgblink jungle_book.o -o jungle_book.gb
rgbfix  -m MBC1 -l 0x61 -v -p 0xFF --non-japanese -t "JUNGLE BOOK" jungle_book.gb
