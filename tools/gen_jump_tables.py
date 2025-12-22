# this script allows to collect the remaining jump tables that the
# other make_jump_tables.py didn't see for some reason

tables = """A60E A612
A658 A65C
A824 A828
A851 A855
A8B4 A8BA
BF57 BF5F
C500 C504
CC5B CC5F
CCB2 CCB8
CF4C CF50
D2F3 D2F7
""".lower().splitlines()

with open("rom.bin","rb") as f:
    rom = f.read()

offset = 0x6000

write = lambda x: print(x,end="")

for table in tables:
    start,end = (int(x,16) for x in table.split())
    write(f"jump_table_{start:04x}:\n")
    for offs in range(start,end,2):
        foffs = offs-offset
        data = rom[foffs]*256 + rom[foffs+1]
        write(f"\t.word\t${data:04x}\t; ${offs:04x}\n")



