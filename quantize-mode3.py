# PC-6001 mode 3 is pretty brutal: green, yellow, blue, red
MODE_3_PALETTE = [
        0, 255, 0,
        255, 255, 0,
        0, 0, 255,
        255, 0, 0
        ]

MODE_3_SIZE = (128, 192)

from PIL import Image

palette = Image.new('P', (4,1))
palette.putpalette(MODE_3_PALETTE)

oldimage = Image.open('meules.png').convert('RGB')

# figure out the ratio and scale proportionally
# oldimage.thumbnail(MODE_3_SIZE)
oldimage = oldimage.resize(MODE_3_SIZE)

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

real_size = newimage.size

for y in range(real_size[1]):
    x = 0
    bytes_buf = []
    while x + 3 < real_size[0]:
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
    buf += '.db ' + ', '.join([hex(b) for b in bytes_buf]) + '\n'

assert(length == real_size[0] * real_size[1])
buf += 'PIC_LEN: .dw ' + str(length // 4) + '\n'
buf += f'PIC_WIDTH: .db {real_size[0]}\n'
buf += f'PIC_HEIGHT: .db {real_size[1]}\n'

print(buf)