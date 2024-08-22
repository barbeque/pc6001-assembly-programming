# PC-6001 mode 3 is pretty brutal: green, yellow, blue, red
MODE_3_PALETTE = [
        0, 255, 0,
        255, 255, 0,
        0, 0, 255,
        255, 0, 0
        ]

from PIL import Image, ImagePalette

palette = Image.new('P', (4,1))
palette.putpalette(MODE_3_PALETTE)

oldimage = Image.open('meules.png').convert('RGB')
newimage = oldimage.quantize(4, palette=palette)
newimage.save('meules-4.png')
