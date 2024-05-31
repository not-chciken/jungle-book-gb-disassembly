#!/bin/bash
rgbasm main.asm -o jungle_book.o
rgblink jungle_book.o -o jungle_book.gb
rgbfix  -m MBC1 -v -p 0xFF -t "JUNGLE BOOK" jungle_book.gb
