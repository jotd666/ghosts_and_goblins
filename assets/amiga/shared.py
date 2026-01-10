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

SPRITE_NB_TILES = 0x400
FG_NB_TILES = 0x400
FG_NB_CLUTS = 16
BG_NB_TILES = 0x400
BG_NB_CLUTS = 8
SPRITE_NB_CLUTS = 4

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


def add_tile(table,index,cluts=[0],merge_cluts=True):
    if isinstance(index,range):
        pass
    elif not isinstance(index,(list,tuple)):
        index = [index]
    for idx in index:
        cluts = list(cluts)
        if idx in table and merge_cluts:
            cluts += table[idx]
        table[idx] = sorted(set(cluts))



def read_used_tiles(used_tiles_name,tile_cluts,nb_tiles,nb_cluts):
    with open(used_graphics_dir / used_tiles_name,"rb") as f:
        for index in range(nb_tiles):
            d = f.read(nb_cluts)
            cluts = [i for i,c in enumerate(d) if c]
            if cluts:
                add_tile(tile_cluts,index,cluts=cluts)


def get_sprite_names():

    rval = {i:"armored_arthur" for i in list(range(0,0x30))+[0x36,0x37,0x3E,0x3F]}

    rval.update({i+0x100:"underwear_arthur" for i in rval})
    rval[0x26E] = rval[0x26F] = rval[0x266] = rval[0x267] = "lying_arthur"

    atl = list(range(0x150,0x154))+list(range(0x158,0x15C))
    rval.update({i:"arthur_top_ladder" for i in atl})
    rval.update({i+4:"arthur_top_ladder_underwear" for i in atl})

    rval.update({i:"arthur_losing_armor" for i in [0x130,0x131,0x138,0x139]})

    rval[0x7F] = "coin_bonus"
    rval[0x8F] = "bag_bonus"
    rval[0x257] = "star_bonus"
    rval[0x277] = "king_bonus"
    rval[0x27F] = "pot"

    rval[0x1b6] = "plant_bullet"
    rval[0x132] = "armor"
    rval[0x134] = "blank"
    rval[0x132] = "armor"
    rval[0x13D] = "armor"
    rval[0x90] = rval[0x98] = "earth"
    rval[0x23B] = rval[0x23C] = rval[0x23D] = "princess"
    rval[0x233] = rval[0x234] = "princess"

    #rval.update({i:"armored_arthur" for i in range()})


    rval.update({i:"score" for i in range(0x31,0x36)})
    rval.update({i:"score" for i in range(0x3a,0x3e)})
    rval.update({i:"frog" for i in range(0x42,0x50)})
    rval.update({i:"dragon" for i in range(0x240,0x250)})
    rval.update({i:"skeleton" for i in range(0xa0,0xa8)})
    rval.update({i:"zombie" for i in range(0xa8,0xc0)})
    rval.update({i:"bat" for i in range(0xe0,0xe4)})
    rval.update({i:"bat" for i in range(0xe8,0xec)})
    rval.update({i:"plant" for i in range(0xd0,0xd5)})
    rval.update({i:"plant" for i in range(0xd8,0xdd)})
    rval.update({i:"crow" for i in range(0xc0,0xd0)})
    rval.update({i:"tombstone" for i in range(0x172,0x178)})
    rval.update({i:"tombstone" for i in range(0x17A,0x180)})
    rval.update({i:"ice_platform" for i in range(0x160,0x163)})
    rval.update({i:"earth_platform" for i in range(0x168,0x16A)})
    rval.update({i:"small_goblin" for i in range(0xF0,0xF6)})
    rval.update({i:"small_goblin" for i in range(0xF8,0x100)})
    rval.update({i:"big_devil" for i in range(0x280,0x29B)})
    rval.update({i:"big_devil" for i in range(0x2A0,0x2A6)})
    rval.update({i:"big_devil" for i in range(0x2B0,0x2B6)})
    rval.update({i:"big_devil" for i in range(0x2A8,0x2AD)})

    rval.update({i:"boss" for i in range(0x2C0,0x300)})

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