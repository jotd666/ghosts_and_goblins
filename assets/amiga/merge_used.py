import os,pathlib,shutil,json

from shared import *




def merge(used_name,nb_items,nb_cluts):
    merged_path_file = used_graphics_dir


    # merge sprites with existing file + moves from level 1
    used_dump = data_dir / os.path.basename(used_name)
    with open(used_dump,"rb") as f:
        new_contents = f.read()


    old_used = merged_path_file / used_name
    if old_used.exists():
        with open(old_used,"rb") as f:
            old_contents = f.read()
    else:
        old_contents = bytes(nb_cluts*nb_items)

    contents = bytes([a|b for a,b in zip(new_contents,old_contents)])

    if old_contents == contents:
        print(f"Nothing new for {used_name}")
    else:
        for i,(a,b) in enumerate(zip(old_contents,contents)):
            if a!=b:
                code,clut = divmod(i,nb_cluts)
                print(f"{used_name}: New: code={code:02x}, clut={clut:02x}")
        with open(merged_path_file / used_name,"wb") as f:
            f.write(contents)

merge("fg_used_tiles",0x400,16)
merge("level4/bg_used_tiles",0x400,8)
merge("used_sprites",0x400,4)
