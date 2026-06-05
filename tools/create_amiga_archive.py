import subprocess,os,glob,shutil,pathlib
import gen_scroll_table,gen_mirror_table

pack_data = True

def packcopy(sourcefile,dest):
# -= RNC ProPackED v1.8 [by Lab 313] (01/26/2021) =-
    if dest.is_dir():
        destfile = dest / sourcefile.name
    else:
        destfile = dest
    with open(sourcefile,"rb") as f:
        header = f.read(3).decode(errors="ignore")
    if header=="RNC" or not pack_data:
        # already packed/do not pack
        print(f"Copying {destfile}...")
        shutil.copy(sourcefile,destfile)
    else:
        cmd = ["propack","p",str(sourcefile),str(destfile)]
        print(f"Packing {destfile}...")
        p = subprocess.run(cmd,check=False,stdout=subprocess.DEVNULL)
        if p.returncode:
            print(f"failed packing {destfile}")
            shutil.copy(sourcefile,destfile)

progdir = pathlib.Path(__file__).parent.parent.absolute()
data = progdir / "data"

gen_scroll_table.doit(width = 64)   # FMODE=3
gen_mirror_table.doit(gen_mirror_table.src_dir / "mirror_table.68k")

gamename = "GhostsNGoblins"
# JOTD path for cranker, adapt to whatever your path is :)
os.environ["PATH"] += os.pathsep+r"K:\progs\cli"

cmd_prefix = ["make","-f",os.path.join(progdir,"makefile.am")]

subprocess.check_call(cmd_prefix+["clean"],cwd=progdir /"src")

subprocess.check_call(cmd_prefix+["RELEASE_BUILD=1"],cwd=progdir /"src")
# create archive

outdir = progdir  / "dist" / f"{gamename}"

dataout = outdir / "data"
if dataout.exists():
    shutil.rmtree(dataout)

if os.path.exists(outdir):
    shutil.rmtree(outdir)

outdir.mkdir(exist_ok=True,parents=True)
assets = progdir /"assets"/"amiga"

for file in ["readme.md",f"{gamename}_AGA.slave"]:  #f"{gamename}.slave",
    shutil.copy(progdir / file,outdir)

shutil.copy(assets/"GhostsNGoblins.info",outdir)

dataout.mkdir()

for file in data.glob("level?_*"):
    packcopy(file,dataout)
for file in data.glob("*.mod"):
    if file.name != "GnG_Stage_CD32.mod":
        packcopy(file,dataout)

for ext in ["aga"]:
    exename = f"{gamename}_{ext}"
    packcopy(data/exename,dataout)
    #subprocess.run(["cranker_windows.exe","-f",data/exename,"-o",progdir/f"{exename}.rnc"],check=True)


arcname = progdir / f"GhostsNGoblins_WHD.lha"
arcname.unlink(missing_ok=True)
cmd = ["lha","-r","a",arcname,"*"]

subprocess.run(cmd,cwd=outdir.parent,check=True)

outdir = progdir / f"{gamename}_CD32"

dataout = outdir / "data"
if dataout.exists():
    shutil.rmtree(dataout)


if os.path.exists(outdir):
    for x in outdir.glob("*"):
        x.unlink()

outdir.mkdir(exist_ok=True)
dataout.mkdir()

for file in ["readme.md",f"{gamename}_CD32.slave"]:  #f"{gamename}.slave",
    shutil.copy(progdir / file,outdir)

shutil.copy(assets/"GhostsNGoblins.info",outdir)

shutil.copy(assets/"GhostsNGoblins_drw.info",outdir.parent / "GhostsNGoblins.info")


for file in data.glob("level?_*"):
    shutil.copy(file,dataout)
for file in data.glob("*.mod"):
    if file.name == "GnG_Stage_CD32.mod" or not file.name.startswith("GnG_Stage"):
        shutil.copy(file,dataout)

for ext in ["cd32"]:
    exename = f"{gamename}_{ext}"
    shutil.copy(data/exename,dataout)

#subprocess.run(cmd_prefix+["clean"],cwd=progdir/"src",check=True)
