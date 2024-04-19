# cracks p6 tape images with an intent to reformat them for bare ROM
import os, sys, optparse
import hashlib
import struct

parser = optparse.OptionParser(usage='%prog <filename.p6>')
parser.add_option('-q', '--quiet')

(options, args) = parser.parse_args()

if len(args) < 1:
    parser.print_usage()
    sys.exit(1)

def hash_header(filename, file_bytes):
    """
    Compute the hash of the start of a P6 image, to see
    if the BASIC loader is likely to be identical between
    multiple tapes
    """
    BYTES_TO_HASH = 128
    hash = hashlib.md5(file_bytes[:BYTES_TO_HASH])
    if not options.quiet:
        print(f'{filename}: {hash.hexdigest()}')
    return hash.hexdigest()

def crack_inufuto(filename, file_bytes):
    # differences start at $0112:
    #   0112-0113: length (little endian) including the next two bytes
    #   0114 onward: program continues until end of tape
    record_length = struct.unpack('<h', file_bytes[0x112:0x114])[0]
    program_chunk = file_bytes[0x114:]
    # sanity check
    print(hex(program_chunk[0]))
    if not options.quiet:
        print(f'{filename}: bytes left {len(program_chunk)}, reported program length {record_length}')

    with open('dump.bin', 'wb') as f:
        f.write(program_chunk)


# yewdow got converted to cartridge fairly easily it seems
# AB.@ and then the program from $114 onward... but seems to have
# changed many addresses. we will probably have to make a RAM-copier
# that just duplicates what the original Inufuto-loader did

"""
    Known header hashes, and the method to convert each of them
"""
known_header_hashes = {
    '45228b3f6533752931fb43028ce4edec': crack_inufuto
}

for file in args:
    with open(file, 'rb') as f:
        buf = bytes(f.read())
        hash = hash_header(file, buf)
        if hash in known_header_hashes.keys():
            crack = known_header_hashes[hash]
            crack(file, buf)
        else:
            sys.stderr.write(f'{file}: Cannot find a suitable crack for header hash "{hash}" - time to make a new one')