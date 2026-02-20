import subprocess,os,glob,shutil,pathlib

progdir = pathlib.Path(__file__).parent.parent.absolute()
data = progdir / "data"

gamename = "GhostsNGoblins"
# JOTD path for cranker, adapt to whatever your path is :)
os.environ["PATH"] += os.pathsep+r"K:\progs\cli"

cmd_prefix = ["make","-f",os.path.join(progdir,"makefile.am")]

subprocess.check_call(cmd_prefix+["clean"],cwd=progdir /"src")

subprocess.check_call(cmd_prefix+["RELEASE_BUILD=1"],cwd=progdir /"src")
# create archive

outdir = progdir / f"{gamename}_HD"

dataout = outdir / "data"
if dataout.exists():
    shutil.rmtree(dataout)

if os.path.exists(outdir):
    for x in outdir.glob("*"):
        x.unlink()
else:
    outdir.mkdir()
for file in ["readme.md",f"{gamename}_aga.slave"]:  #f"{gamename}.slave",
    shutil.copy(progdir / file,outdir)

assets = progdir /"assets"/"amiga"
shutil.copy(assets/"GhostsNGoblins.info",outdir)

dataout.mkdir()

for file in data.glob("level?_*"):
    shutil.copy(file,dataout)
for file in data.glob("*.mod"):
    shutil.copy(file,dataout)

for ext in ["aga"]:
    exename = f"{gamename}_{ext}"
    shutil.copy(data/exename,dataout)
    subprocess.run(["cranker_windows.exe","-f",data/exename,"-o",progdir/f"{exename}.rnc"],check=True)

subprocess.run(cmd_prefix+["clean"],cwd=progdir/"src",check=True)
