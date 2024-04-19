import os, sys

if len(sys.argv) < 2:
    print(f'Usage: {sys.argv[0]} [hex file to convert]')
    sys.exit(1)

with open(sys.argv[1], 'r') as f:
    buf = f.read()
    tokens = [t for t in buf.split(',') if len(t.strip()) > 0 ]

if len(tokens) < 1:
    print(f'Ridiculous number of tokens in file, is this comma delimited?')
    sys.exit(2)

with open('output.bin', 'wb') as o:
    for token in tokens:
        # convert the hex character token into a byte
        b = bytes.fromhex(token)
        print(b)
        o.write(b)
