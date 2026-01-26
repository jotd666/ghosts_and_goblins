from PIL import Image,ImageOps
import os

import shared

sprite_names = shared.get_sprite_names()

this_dir = os.path.dirname(os.path.abspath(__file__))

tilesdir = os.path.join(this_dir,os.pardir,"sheets","sprites")

def doit(binname):
    with open(os.path.join(this_dir,binname),"rb") as f:
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

    ts_title_list = [load_tileset(f"pal_{p:02x}.png",16) for p in range(4)]
    layer = Image.new("RGB",(256,256))

    buffered_spriteram = contents[0:0x180]

    used_sprites = set()

    for offs in range(len(buffered_spriteram)-4,0,-4):
        attributes = buffered_spriteram[offs + 1]
        sx = buffered_spriteram[offs + 3] - 0x100 * (attributes & 0x01)
        sy = buffered_spriteram[offs + 2]
        if sy==0xF8:
            continue
        flipx = attributes & 0x04
        flipy = attributes & 0x08

        tile_code = buffered_spriteram[offs] + ((attributes << 2) & 0x300)
        tile_color = (attributes >> 4) & 3
        name = sprite_names.get(tile_code,"unknown")
        if name=="blank":
            continue

        #sx += 128
        sy += 6

        used_sprites.add(tile_code)

        sheet = ts_title_list[tile_color]
        img = sheet[tile_code]
        if flipx:
            img = ImageOps.mirror(img)
        elif flipy:
            img = ImageOps.flip(img)

        print(f"offset={offs:04x}, code={tile_code:02x}: name={name}, x={sx}, y={sy}")
        layer.paste(img,box=(sx,sy))


    layer.save(f"{binname}.png")

doit("sprites")






