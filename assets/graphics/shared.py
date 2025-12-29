from PIL import Image,ImageOps
import os,sys,bitplanelib,subprocess,json,pathlib

this_dir = pathlib.Path(__file__).absolute().parent

data_dir = this_dir / ".." / ".."


src_dir = this_dir / ".." / ".." / "src" / "amiga"



sheets_path = this_dir / ".." / "sheets"
dump_dir = this_dir / "dumps"

used_sprite_cluts_file = this_dir / "used_sprite_cluts.json"
fg_used_tile_cluts_file = this_dir / "fg_used_tile_cluts.json"
used_graphics_dir = this_dir / "used_graphics"

NB_SPRITES = 0x100
FG_NB_TILES = 0x400

def palette_pad(palette,pad_nb):
    palette += (pad_nb-len(palette)) * [(0x10,0x20,0x30)]

def ensure_empty(d):
    if os.path.exists(d):
        for f in os.listdir(d):
            x = os.path.join(d,f)
            if os.path.isfile(x):
                os.remove(x)
    else:
        os.makedirs(d)

def ensure_exists(d):
    if os.path.exists(d):
        pass
    else:
        os.makedirs(d)

sr2 = lambda a,b : set(range(a,b,2))

player_sprite_pairs = set()

group_sprite_pairs = player_sprite_pairs

def get_sprite_names():

    rval = {}
    return rval

def get_mirror_sprites():
    """ return the index of the sprites that need mirroring
as opposed to Gyruss, most of the sprites don't

"""
    rval = {}
    return rval



alphanum_tile_codes = set(range(0,10)) | set(range(65-48,65+27-48))

if __name__ == "__main__":
    raise Exception("no main!")