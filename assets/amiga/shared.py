from PIL import Image,ImageOps
import os,sys,bitplanelib,subprocess,json,pathlib

this_dir = pathlib.Path(__file__).absolute().parent

data_dir = this_dir / ".." / ".." / "data"


src_dir = this_dir / ".." / ".." / "src" / "amiga"
bg_bank_dir = src_dir / "bg_banks"
bg_bank_dir.mkdir(exist_ok=True)

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

sr = lambda a,b : set(range(a,b))
sr2 = lambda a,b : set(range(a,b,2))
sr3 = lambda a,b : set(range(a,b,3))
sr4 = lambda a,b : set(range(a,b,4))

group_sprite_pairs = (sr2(0,0x30) | # player
sr2(0x100,0x134) | # player (underwear)
sr2(0x136,0x13C) | # player
sr2(0x13E,0x15F) | # player / dead
sr2(0x42,0x50)  | # frog
sr2(0x50,0x54) | # flame
sr2(0x58,0x5C) | # flame
sr2(0x62,0x68) | # flying bag
sr2(0x6A,0x6C) | # flying bag
sr2(0x78,0x7C) | # flying bag
sr2(0x80,0x8A) | # level 2 goblin
sr2(0xA0,0xA6) | # jumping skeleton
sr2(0xA8,0xC0) | # jumping skeleton / zombie
sr2(0xE0,0xE4) | # bat
sr2(0xE8,0xEC) | # bat
sr2(0x1C0,0x1D0) | # explosions
sr2(0x170,0x1A0) | # misc
sr2(0x1D8,0x1DC) | # misc
sr2(0x1E0,0x1F0) | # bullies
sr2(0x1F2,0x1F8) | # bullies
sr2(0x1FA,0x200) | # bullies
sr2(0x240,0x250) | # dragon
sr2(0x2BC,0x2C0) | # blast
{0x168,0x1A6,0x1AE,0x22E,0x25C,0x275,0x26E,0x27D,0x286,0x28E,0x266,0x226,
0x296,0x2A0,0x2A3,0x2AB,0x26,0x3E,0x54,0x36,0x76,0x206,0x238,0x20E}
)

group_sprite_triplets = ({0x203,0x223,0X2A8,0x250,0x258,0x213,0x160,0xE4,0x1D4,0x200,0x208,0x20B,0x228,0x22B,0x230,0x220,0x210,0x218,0x21B} |
sr3(0x1A0,0x1A6) |
sr3(0x1A8,0x1AE) |
sr3(0x1B0,0x1B6) |
sr3(0x2B0,0x2B6) |
sr3(0x1B8,0x1BE) |
sr3(0x280,0x286) |
sr3(0x288,0x28E) |
sr3(0x290,0x296)
)

group_sprite_quadruplets = sr4(0x2C0,0x300)


# tiles that represent lives and weapon: not alphanumeric

weapon_layout = lambda x:{x,x+1,x+0x10,x+0x11}

weapons = [
0x82, # torch
0x80, # lance
0x88, # axe
0x86, # shield
0x84, # sword
]

lower_osd_tiles = {
0x8A,0x8B,  # lives upper
0x9A,0x9B,  # lives lower
} | sr(0xA0,0xD4)

for w in weapons:
    lower_osd_tiles.update(weapon_layout(w))

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

    rval = {i:"giant" for i in list(range(0x200,0x231))+[0x238,0x22B,0x23A,0x20B,0x20E,0x21B]}
    rval.update({i:"armored_arthur" for i in list(range(0,0x30))+[0x36,0x37,0x3E,0x3F]})

    rval.update({i+0x100:"underwear_arthur" for i in rval})
    rval[0x26E] = rval[0x26F] = rval[0x266] = rval[0x267] = "lying_arthur"

    atl = list(range(0x150,0x154))+list(range(0x158,0x15C))
    rval.update({i:"arthur_top_ladder" for i in atl})
    rval.update({i+4:"arthur_top_ladder_underwear" for i in atl})

    rval.update({i:"arthur_losing_armor" for i in [0x130,0x131,0x138,0x139,0x13A]})

    rval[0x25B] = "arthur_spectre"
    rval[0x275] = rval[0x27D] = "arthur_passing_armor"
    rval[0xE4] = "eye_platform"
    rval[0x7F] = "coin_bonus"
    rval[0x26D] = rval[0x268] = rval[0x26A] = rval[0x26C] = "statue_bonus"

    rval[0xF7] = "small_fire_bullet"
    rval[0x38] = rval[0x39] = "axe"
    rval[0x5E] = "shield"
    rval[0x5F] = "sword"
    rval[0x8F] = "bag_bonus"
    rval[0x260] = "necklace_bonus"
    rval[0x262] = "shoe_bonus"
    rval[0x257] = "star_bonus"
    rval[0x277] = "king_bonus"
    rval[0x269] = "statue_bonus"
    rval[0x26B] = "statue_bonus"
    rval[0x261] = "ring_bonus"
    rval[0x27F] = "pot"
    rval[0xD7] = "key"
    rval[0x57] = "torch"
    rval[0x9F] = "boulder"
    rval[0x170] = "stone_platform"
    rval[0x40] = "boss_shot"
    rval[0x9F] = "boulder"
    rval[0x170] = "stone_platform"
    rval[0x263] = "ham_bonus"  # worth ??
    rval[0x264] = "trousers_bonus"  # worth 2000
    rval[0x265] = "crown_bonus"  # worth ??
    rval.update({x:"arthur_skeleton" for x in range(0x140,0x14f)})
    rval.update({x:"flying_goblin" for x in range(0x80,0x8f)})
    rval.update({x:"flying_bag" for x in range(0x6A,0x7B)})
    rval.update({x:"flying_bag" for x in [0x62,0x64,0x66,0x61]})
    rval.update({x:"shield_warrior" for x in [0x60,0x68,0x70,0x71,0x72,0x73,0x74,0x75]})
    rval.update({x:"thug" for x in range(0x1E0,0x1FF)})
    rval.update({x:"arremer" for x in list(range(0x180,0x199))+list(range(0x1A0,0x1C0))+list(range(0x19A,0x19F))+[0x250,0x251,0x252,0x258,0x259,0x25A]})
    rval.update({x:"princess" for x in [0x236,0x237,0x23e,0x23f]})
    rval.update({x:"princess" for x in [0x226,0x227,0x22e,0x22f]})
    rval.update({x:"bridge_flame" for x in range(0xE7,0xF7)})
    rval.update({x:"bridge_flame" for x in range(0x163,0x168)})
    rval.update({x:"magic_trunk" for x in range(0x91,0x9f)})
    rval[0x1D4] = rval[0x1DD] = "tomb_sorcerer"
    rval[0x18E] = rval[0x186] = rval[0x253] = rval[0x254] = rval[0x255] = "tomb_sorcerer"
    rval[0x1b6] = rval[0x1b7] = "plant_bullet"
    rval[0x54] = "spear"
    rval[0x132] = "armor"
    rval[0x134] = "blank"
    rval[0x132] = "armor"
    rval[0x13D] = "armor"
    rval[0x178] = rval[0x135] = "cave_tombstone"
    rval[0x90] = rval[0x98] = "earth"
    rval[0x23B] = rval[0x23C] = rval[0x23D] = "princess"
    rval[0x233] = rval[0x234] = rval[0x235] = "princess"
    rval[0x7C] = rval[0x7D] = rval[0x7E] = "dragon_shot"

    #rval.update({i:"armored_arthur" for i in range()})


    rval.update({i:"flame" for i in range(0x270,0x274)})
    rval.update({i:"score" for i in range(0x31,0x36)})
    rval.update({i:"score" for i in range(0x3a,0x3e)})
    rval.update({i:"frog" for i in range(0x42,0x50)})
    rval.update({i:"dragon" for i in range(0x240,0x250)})
    rval.update({i:"skeleton" for i in range(0xa0,0xae)})
    rval.update({i:"zombie" for i in range(0xae,0xc0)})
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

    rval[0x96] = rval[0x97] = rval[0x9E] = "sparkle"
    rval[0xa6] = "zombie"
    return rval

def get_mirror_sprites():
    """ return the index of the sprites that need mirroring
as opposed to Gyruss, most of the sprites don't

"""
    rval = {}
    return rval



alphanum_tile_codes = set(range(0,10)) | set(range(65-48,65+27-48))

##import json
##
##with open("sprites_per_level.json","r") as f:
##    spl = json.load(f)
##sn = get_sprite_names()
##snv = {k:{"pre_mirror":None,"levels":spl.get(k)} for k in set(sn.values())}
##for k,v in snv.items():
##    if v and v["levels"]=="*":
##        v["levels"] = None
##        v["on_last_level"] = False
##
##with open("sprites_per_level_all.json","w") as f:
##    json.dump(snv,f,indent=2)

if __name__ == "__main__":
    raise Exception("no main!")