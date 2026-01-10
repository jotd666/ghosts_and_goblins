# first color of sprites purple: F0F
# fill $3841,1,$F0
# fill $3941,1,$F0  # F0 => Fx last 4 bits are ignored
# fill $3851,1,$F0
# fill $3951,1,$F0
# fill $3861,1,$F0
# fill $3961,1,$F0
# fill $3871,1,$F0
# fill $3971,1,$F0

from PIL import Image
import pathlib
black=(0,0,0)
magenta=(255,0,255)

for i in range(4):
    input_img = pathlib.Path("sprites_mag") / f"pal_{i:02}.png"
    img = Image.open(input_img)
    for x in range(img.size[0]):
        for y in range(img.size[1]):
            c = img.getpixel((x,y))
            if c==black:
                c = magenta
            elif c==magenta:
                c = black
            img.putpixel((x,y),c)

    output_img = pathlib.Path("sprites") / f"pal_{i:02}.png"
    img.save(output_img)