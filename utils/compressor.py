#!/usr/bin/python

class Lz77Tuple:
    def __init__(self, byte, len, pos) -> None:
        self.byte = byte
        self.len = len
        self.pos = pos

NUM_TAILING_ZEROES = 32
compressed_data_size = 0
uncompressed_data_size = 0

tailing_zeroes = [0] * NUM_TAILING_ZEROES
uncompressed_data = [0xfa,0xa1,0x00,0xaa,0xbb,0xaa,0xaa,0xa1] + tailing_zeroes

def get_match(uncomp_data, search_ptr, uptr):
    len = 0
    while (uncomp_data[uptr - len] == uncomp_data[search_ptr - len]) and ((uptr - len) >= 0):
        len += 1
    return len

tuple_list = []
uptr = len(uncompressed_data) - len(tailing_zeroes) - 1
search_ptr = len(uncompressed_data) - 1

while uptr < search_ptr:
    len = get_match(uncompressed_data, search_ptr, uptr)
    if len >= 3:
        tuple_list.prepend(Lz77Tuple(0, len, search_ptr))
        uptr -= len
        break
    search_ptr -




