import re
from shared import *

ure = re.compile(".*undefined reference to `(\w+)")

undefs = set()
with open(this_dir / "../src/link.txt") as f:
    for line in f:
        m = ure.match(line)
        if m:
            undefs.add(m.group(1))

for u in sorted(undefs):
    print(u)

# to join entries in MAME
# type d-*.asm > entry.asm 2>&1

with open(this_dir / "debug_script","w") as f:
    for u in sorted(undefs):
        try:
            uv = u.rsplit("_",1)[-1]
            uv = int(uv,16)
            f.write(f"dasm d-{uv:04x}.asm,${uv:04x},10\n")
        except Exception as e:
            print(f"Warn: {u}: {e}")
print(f"nb undefs {len(undefs)}")