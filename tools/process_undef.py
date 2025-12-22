import re

ure = re.compile(".*undefined reference to `(\w+)")

undefs = set()
with open("../src/link.txt") as f:
    for line in f:
        m = ure.match(line)
        if m:
            undefs.add(m.group(1))

for u in sorted(undefs):
    print(u)

print(f"nb undefs {len(undefs)}")