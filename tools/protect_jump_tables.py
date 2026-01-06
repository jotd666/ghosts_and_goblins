# this script was used once to scan the detected jump table and add filler FFFF
# when needed to make sure that we don't overshoot, because some tables have "holes"
# in them (impossible values) followed by legit jumps. If we miss that, the code can select
# another jump in another table, making the bug difficult to find (happened more than once!)

import pathlib,re


lab_re = re.compile("jump_table_(\w+):")

def process(asm_file):
    with open(asm_file) as f:
        asm_lines = f.readlines()

    computed_offset = -1
    prev_word = False
    max_offset = 0

    for i,line in enumerate(asm_lines):
        m = lab_re.match(line)
        if m:
            computed_offset = int(m.group(1),16)

        if computed_offset > 0:
            toks = line.split()
            if toks and "dc.w"==toks[0]:
                if len(toks)>3:
                    read_offset = int(toks[3].strip("$"),16)
                    if read_offset != computed_offset:
                        print(f"read_offset != computed_offset: {read_offset:04x} {computed_offset:04x}")
                else:
                    read_offset = computed_offset
                    asm_lines[i] = line.rstrip() + f"\t; ${read_offset:04x}\n"
                computed_offset += 2
                max_offset = max(max_offset,computed_offset)
                prev_word = True
            else:
                if prev_word:
                    prev_word = False
                    if not line.strip():
                        # we don't want to scan until non empty
                        raise Exception(f"Empty line after table line {i+1}")
                    computed_offset = int(m.group(1),16)
                    if max_offset > computed_offset:  # if one of the labels points to the exact end of table, skip
                        if abs(read_offset-computed_offset) > 4:  # insert crap if distance with next label is too long/irrelevant
                            asm_lines[i-1] += "\tdc.w\t$ffff   ; bogus auto-insert\n"*8
                computed_offset == -1
                max_offset = 0

    with open(asm_file.stem + "_new.asm","w") as f:
        f.writelines(asm_lines)

process(pathlib.Path("../src/rom_6000.asm"))
