# PC-6001 mode 3 is pretty brutal: green, yellow, blue, red
MODE_3_PALETTE = [
        0, 255, 0,
        255, 255, 0,
        0, 0, 255,
        255, 0, 0
        ]

MODE_3_SIZE = (128, 192)

from PIL import Image, ImagePalette

palette = Image.new('P', (4,1))
palette.putpalette(MODE_3_PALETTE)

oldimage = Image.open('meules.png').convert('RGB').transpose(Image.ROTATE_270).resize(MODE_3_SIZE)
newimage = oldimage.quantize(4, palette=palette)
newimage.save('meules-4.png')

def pack_into_byte(a):
    assert(len(a) == 4)
    tb = 0
    for b in range(4):
        assert(a[b] >= 0)
        assert(a[b] < 4)
        tb = (tb << 2) | (a[b])
    return tb

assert(pack_into_byte([0,0,0,0]) == 0)
assert(pack_into_byte([3,3,3,3]) == 0xff)
assert(pack_into_byte([0,1,2,3]) == 0b00_01_10_11)

# go through and generate the asm now
buf = 'PIC: '
length = 0
pixels = newimage.load()
for y in range(MODE_3_SIZE[1]):
    buf += '.db '

    x = 0
    bytes_buf = []
    while x < MODE_3_SIZE[0]:
        # pack into 1-byte chunks (2-bits each)
        tb = pack_into_byte([
            pixels[x, y],
            pixels[x + 1, y],
            pixels[x + 2, y],
            pixels[x + 3, y],
        ])
        bytes_buf.append(tb)
        x += 4
        length += 4
    buf += ', '.join([hex(b) for b in bytes_buf]) + '\n'

assert(length == MODE_3_SIZE[1] * MODE_3_SIZE[0])
buf += 'PIC_LEN: .dw ' + str(length // 4) + '\n'

print(buf)