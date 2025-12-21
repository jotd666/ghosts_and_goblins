# TODO: detect LDx followed JMP, auto rename + lowercase
# count not found tables (because instruction in between)
# warn if still fake code not removed at table address
# create MAME disassemble script for first table address

# this script was used once to
# - tag the jump/jsr calls
# - name the jump tables and dump their contents as words in the end of the file

import pathlib,re,bisect


fake = {0xce9c,0x6070,0x6810,0xbd68,0xf9c4,0xb291,0xb29f,0xb324,0xB336,0xba29,
0xcc00,0xc64e,0xC65A,0xC668,0xC674}

def process(asm_file,rom_file,offset,end_address):
    with open(asm_file) as f:
        asm_lines = f.readlines()

    with open(rom_file,"rb") as f:
        rom = f.read()



    size = 0x100

    known_tables = set()
    inst_addresses = dict()
    not_in_listing = set()
    # first pass: add "jump_table" tag, collect valid instruction addresses

    for i,line in enumerate(asm_lines):
        m = re.match("([0-9A-F]{4}):",line)
        if m:
            inst_addresses[int(m.group(1),16)] = line

        linecode = line.split(";")[0]
        if ("JMP" in linecode or "JSR" in linecode) and "[" in linecode:
            if "indirect_jump]" in line:
                pass
            else:
                line = line.strip() + "        ; [indirect_jump]\n"
                asm_lines[i] = line
        m = re.match("^(\w*jump_table_\w+):",line)
        if m:
            known_tables.add(m.group(1).lower())

    inst_addresses_list = sorted(inst_addresses)
    # second pass: find tag, then previous LDx instruction to get table address
    # create a label for table at the previous LDx instruction that matches the
    # index register (X,Y). Widely used in a lot of games, Konami but not just them.
    for i,line in enumerate(asm_lines):
        # table offset in lowercase
        asm_lines[i] = re.sub("(jump_table_)(\w+)",lambda m: m.group(1)+m.group(2).lower(),line)

        if "[indirect_jump]" in line:
            base_reg = None
            # detect index register
            m = re.search("J[SM][RP]\s+\[[AB],(.)\]",line)

            if m:
                base_reg = m.group(1)
            dest = None
            for j in range(i-1,i-10,-1):
                other_line = asm_lines[j]
                m = re.search("#(jump_table_\w+)",other_line)
                if m:
                    dest = m.group(1)
                    break

            table_address = None
            if dest:
                if dest.lower() in known_tables:
                    #print(f"{dest} in known tables")
                    continue   # table contents already declared, nothing to do, all good
                table_address = int(re.search("jump_table_(\w+)",dest).group(1),16)


            else:
                for j in range(i-1,i-3,-1):
                    prev = asm_lines[j]
                    m = re.search("LD(.)\s+#\$(\w+)",prev)
                    if m:
                        reg = m.group(1)
                        offset_str = m.group(2)
                        table_address = int(offset_str,16)
                        if reg == base_reg:    # minimum check
                            label = f"jump_table_{table_address:04x}"
                            asm_lines[j] = prev.replace(f"${offset_str}",label)
                            break
                else:
                    print(f"Could not find matching {line}")


            if table_address:
                data = rom
                sub = offset
                end = end_address


                block = data[table_address-sub:table_address-sub+size]
                label = f"jump_table_{table_address:04x}"

                known_tables.add(label)   # don't do it twice


                asm_lines.append(f"{label}:\n")

                min_address = 0x10000
                nb_entries = 0
                first_entry = None

                for i in range(0,len(block),2):
                    a = block[i+1] + block[i]*256   # big endian!
                    if a not in fake and (sub > a or a >= end):
                        break
                    # most table first entries follow the table itself. This allows
                    # to stop and not declare bogus entries
                    # don't stop if the address is below table or too far
                    if a > table_address and min_address > a:
                        min_address = a

                    if table_address >= min_address:
                        # table points on code just after: stop
                        #print(f"STOP: {table_address:04x} >= {min_address:04x}")
                        break

                    if not first_entry:
                        first_entry = a

                    if a in fake:
                        a = 0xFFFF

                    asm_lines.append(f"\tdc.w\t${a:04x}\t; ${table_address:04x}\n")

                    if a != 0xFFFF and a != first_entry and a not in inst_addresses:
                        closest_idx = bisect.bisect(inst_addresses_list,a)
                        closest_address = inst_addresses_list[closest_idx]
                        print(f"{label}: table entry {a:04x} not in listing (closest: {closest_address:04x})")
                        not_in_listing.add((a,closest_address))

                    nb_entries += 1
                    table_address += 2

                if first_entry and first_entry not in inst_addresses:
                    closest_idx = bisect.bisect(inst_addresses_list,first_entry)
                    closest_address = inst_addresses_list[closest_idx]
                    print(f"{label}: first entry {first_entry:04x} not in listing (closest: {closest_address:04x})")
                    not_in_listing.add((first_entry,closest_address))

                if nb_entries < 2:
                    print(f"{label}: no or not enough entries")

    # write mame debug script to find missing entrypoints
    # once run in MAME, use "type d-*asm > missing.asm 2>&1" to reunite the dumps
    with open("debug_script","w") as f:
        for n,c in sorted(not_in_listing):

            f.write(f"dasm d-{c:04x}.asm,{n:04x},20\n")

    with open(asm_file.stem + "_new.asm","w") as f:
        f.writelines(asm_lines)

process(pathlib.Path("../src/rom_6000.asm"),"rom.bin",offset=0x6000,end_address=0x10000)
