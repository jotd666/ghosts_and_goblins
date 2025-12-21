# this script was used once to
# - tag the jump/jsr calls
# - name the jump tables and dump their contents as words in the end of the file

import pathlib,re


fake = set()

def process(asm_file,rom_file,offset,end_address):
    with open(asm_file) as f:
        asm_lines = f.readlines()

    with open(rom_file,"rb") as f:
        rom = f.read()



    size = 0x100

    known_tables = set()

    # first pass: add "jump_table" tag
    for i,line in enumerate(asm_lines):
        linecode = line.split(";")[0]
        if ("JMP" in linecode or "JSR" in linecode) and "[" in linecode:
            if "[indirect_jump]" in line:
                pass
            else:
                line = line.strip() + "        ; [indirect_jump]\n"
                asm_lines[i] = line
        m = re.match("^(\w*jump_table_\w+):",line)
        if m:
            known_tables.add(m.group(1).lower())


    # second pass: find tag, then previous LDx instruction to get table address
    # create a label for table at the previous LDx instruction that matches the
    # index register (X,Y). Widely used in a lot of games, Konami but not just them.
    for i,line in enumerate(asm_lines):
        if "[indirect_jump]" in line:

            dest = None
            for j in range(i-1,i-10,-1):
                other_line = asm_lines[j]
                m = re.search("#(jump_table\w+)",other_line)
                if m:
                    dest = m.group(1)
                    break

            if dest:
                if dest.lower() in known_tables:
                    print(f"{dest} in known tables")
                    continue   # table contents already declared, nothing to do, all good

                table_address = int(re.search("jump_table_(\w+)",dest).group(1),16)

                data = rom
                sub = offset
                end = end_address


                block = data[table_address-sub:table_address-sub+size]
                label = f"jump_table_{table_address:04x}"
                #asm_lines[j] = asm_lines[j].replace(dest,label).replace("jump_table_jump_table","jump_table")+"\n"

                asm_lines.append(f"{label}:\n")

                min_address = 0x10000

                for i in range(0,len(block),2):
                    a = block[i+1] + block[i]*256   # big endian!
                    if a not in fake and (sub > a or a >= end):
                        break
                    if min_address > a:
                        min_address = a

                    if table_address >= min_address:
                        # table points on code just after: stop
                        break
                    asm_lines.append(f"\tdc.w\t${a:04x}\t; ${table_address:04x}\n")
                    table_address += 2
            else:
                pass
                #print(f"Could not find matching {line}")

    with open(asm_file.stem + "_new.asm","w") as f:
        f.writelines(asm_lines)

process(pathlib.Path("../src/rom_6000.asm"),"rom.bin",offset=0x6000,end_address=0x10000)
