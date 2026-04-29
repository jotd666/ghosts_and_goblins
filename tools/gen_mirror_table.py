import bitplanelib
import os,pathlib


this_dir = pathlib.Path(os.path.abspath(__file__)).parent
src_dir = this_dir / os.pardir / "src" / "amiga"


def doit(asm_output):
    items = []
    for i in range(65536):
        binf = int("".join(reversed(f"{i:016b}")),2)
        items.append((binf & 0xFF00)>>8)
        items.append(binf & 0xFF)

    if asm_output:
        with open(asm_output,"w") as f:
            bitplanelib.dump_asm_bytes(bytes(items),f,True)
    return items

if __name__ == "__main__":
    items = doit(src_dir / "mirror_table.68k")