import glob,os,re,pathlib

gfx_dir = "."

for sn,ttype,colors in ((0,"fg_tiles",16),(1,"bg_tiles",8),(2,"sprites_mag",4),):
    outdir = pathlib.Path(gfx_dir) / ttype
    outdir.mkdir(exist_ok=True)

    orig_name = f"gfx dev 0 set {sn} tiles * colors {colors} pal *.png"
    for file in glob.glob(os.path.join(gfx_dir,orig_name)):
        new_name = re.sub(".* pal ","pal_",os.path.basename(file))
        os.rename(file,outdir / new_name)