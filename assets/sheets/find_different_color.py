import pathlib,glob
import os,re
nb_cols = 64
dct = {}
for p in glob.glob("bg_tiles/*/palette0 colors_256.txt"):
    d = str(pathlib.Path(p).parent)
    with open(p) as f:
        f.readline()
        f.readline()
        f.readline()
        colors = [next(f).strip() for _ in range(nb_cols)]
    dct[d] = colors

ucf = False
for i in range(nb_cols):
    cols1 = [v[i] for k,v in dct.items()]
    for j in range(nb_cols):
        cols2 = [v[j] for k,v in dct.items()]
        colmat = set(zip(cols1,cols2))
        if len(colmat)==len(dct):
            print(f"unique color at indices {i},{j}")
            ucf = True
            break
    if ucf:
        break

for k,v in dct.items():
    print(k,v[i],v[j])
