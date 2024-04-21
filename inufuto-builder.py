import os, sys

if len(sys.argv) < 2:
    print(f'Usage: {sys.argv[0]} <P6 tape image>')
    sys.exit(1)

with open(sys.argv[1], 'rb') as f:
    tape_contents = bytes(f.read())

# read in the start of the assembly file
with open('inufuto-shim.asm', 'r') as f:
    preamble = f.read()

# assume offset 0x110, it seems to be the case for Lift at least
game_chunk = tape_contents[0x110:]

with open('chunk-dump.bin', 'wb') as f:
    # dump the game chunk so we can disassemble it
    f.write(game_chunk)

# should be after the 'game:' label
preamble += '\n'
preamble += '.db '
preamble += ', '.join([ "${:02x}".format(b) for b in game_chunk ])

with open('temp_rom.asm', 'w') as f:
    f.write(preamble)
