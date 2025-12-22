import subprocess,os,glob,shutil,pathlib

progdir = pathlib.Path(__file__).parent.parent.absolute()

gamename = "digdug2"
# JOTD path for cranker, adapt to whatever your path is :)
os.environ["PATH"] += os.pathsep+r"K:\progs\cli"

cmd_prefix = ["make","-f",os.path.join(progdir,"makefile.am")]

subprocess.check_call(cmd_prefix+["clean"],cwd=progdir /"src")

subprocess.check_call(cmd_prefix+["RELEASE_BUILD=1"],cwd=progdir /"src")
# create archive

outdir = progdir / f"{gamename}_HD"

if os.path.exists(outdir):
    for x in outdir.glob("*"):
        x.unlink()
else:
    outdir.mkdir()
for file in ["readme.md",f"{gamename}_ocs.slave",f"{gamename}_aga.slave"]:  #f"{gamename}.slave",
    shutil.copy(progdir / file,outdir)

assets = progdir /"assets"/"amiga"
shutil.copy(assets/"DigDug2-A.info",outdir)
shutil.copy(assets/"DigDug2-B.info",outdir)



for ext in ["aga","ocs"]:
    exename = f"{gamename}_{ext}"
    shutil.copy(progdir/exename,outdir)
    subprocess.run(["cranker_windows.exe","-f",progdir/exename,"-o",progdir/f"{exename}.rnc"],check=True)

subprocess.run(cmd_prefix+["clean"],cwd=progdir/"src",check=True)
