# this script counts the (known) number of entries of a jump table and reports
# it as a comment at the jmp/jsr that uses it

import pathlib,re

# first count the number of consecutive values in table
lab_re = re.compile("(jump_table_\w+):")
lab2_re = re.compile("#(jump_table_\w+)")

def process(asm_file):
    with open(asm_file) as f:
        asm_lines = f.readlines()

    computed_offset = None
    nb_entries = 0


    jump_table_length = dict()

    for i,line in enumerate(asm_lines):
        m = lab_re.match(line)
        if m:
            if computed_offset:
                jump_table_length[computed_offset] = nb_entries
            computed_offset = m.group(1)
            nb_entries = 0

        if computed_offset:
            toks = line.split()
            if toks and "dc.w"==toks[0]:
                nb_entries+=1

    if computed_offset:
        jump_table_length[computed_offset] = nb_entries

    for i,line in enumerate(asm_lines):
        if "[indirect_jump]" in line:
            line = re.sub(" *\[nb_entries.*","",line)
            # go back a couple lines, try to find a table
            for j in range(i-1,i-5,-1):
                m = lab2_re.search(asm_lines[j])
                if m:
                    nb_entries = jump_table_length[m.group(1)]
                    asm_lines[i] = line.rstrip()+f" [nb_entries={nb_entries}]\n"
    with open(asm_file.stem + "_new.asm","w") as f:
        f.writelines(asm_lines)

process(pathlib.Path("../src/rom_6000.asm"))
