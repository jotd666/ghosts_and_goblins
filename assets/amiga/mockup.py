from PIL import Image,ImageOps
import os


this_dir = os.path.dirname(os.path.abspath(__file__))

tilesdir = os.path.join(this_dir,os.pardir,"sheets","bg_tiles","level3")

with open(os.path.join(this_dir,"cavern"),"rb") as f:
    contents = f.read()


side = 16
transparent = (254,254,254)  # not possible to get it in the game

blank_image = Image.new("RGB",(side,side))
for i in range(side):
    for j in range(side):
        blank_image.putpixel((i,j),transparent)


def load_tileset(image_name,side,dump_prefix=""):
    full_image_path = os.path.join(tilesdir,image_name)
    tiles_1 = Image.open(full_image_path)
    nb_rows = tiles_1.size[1] // side
    nb_cols = tiles_1.size[0] // side

    dumpdir = "dumps"

    tileset_1 = []
    k=0
    for j in range(nb_rows):
        for i in range(nb_cols):
            img = Image.new("RGBA",(side,side))
            img.paste(tiles_1,(-i*side,-j*side))
            tileset_1.append(img)
            k += 1

    return tileset_1

ts_title_list = [load_tileset(f"pal_{p:02x}.png",16) for p in range(8)]
layer = Image.new("RGB",(512,512))

m_bgvideoram = contents

used_cluts = set()
used_tiles = set()

for address in range(0x400):
    y = (address & 0x1F)*16
    x = (address // 0x20)*16

    attr = m_bgvideoram[address + 0x400]
    tile_code = m_bgvideoram[address] + ((attr & 0xc0) << 2)
    tile_color = attr & 0x07
    used_cluts.add(tile_color)
    used_tiles.add(tile_code)

    sheet = ts_title_list[tile_color]
    img = sheet[tile_code]
    if attr & 0x30 == 0x10:
        img = ImageOps.mirror(img)
    elif attr & 0x30 == 0x20:
        img = ImageOps.flip(img)

    layer.paste(img,box=(x,y))
            #TILE_FLIPYX(() >> 4));
layer.save("bg.png")








