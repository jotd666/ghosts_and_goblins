import re,os
from shared import change_instruction

# this is a "generic" 68000 code optimizer that removes unnecessary address loads
# generated naively by the 6809 converter


def remcomments(line):
    return re.sub("[\|\*].*","",line)

breaking_instructions = ["rts","jmp","bra","jra","JSR_B_INDEXED","JSR_A_INDEXED","jbsr"]

def optimize(lines,verbose=False):
    nb = 0
    prev_loaded = None

    for i,org_line in enumerate(lines):
        line = remcomments(org_line)  # remove comments
        toks = line.split()
        if toks and "MOVE_W" in toks[0]:
            prev_line = remcomments(lines[i-1])
            prev_toks = prev_line.split()
            if len(prev_toks)==2 and prev_toks[0]=="GET_ADDRESS":
                try:
                    address = int(prev_toks[1],16)
                except ValueError:
                    address = int(prev_toks[1].split("_")[-1],16)
                if address%2 == 0:
                    # even: remove macro use move.w (faster on 68000/68010, no effect on 68020+)
                    args = toks[1].split(",")
                    arg = f"{args[0]},({args[1]})" if toks[0]=="MOVE_W_FROM_REG" else f"({args[0]}),{args[1]}"
                    lines[i] = change_instruction(f"move.w\t{arg}",lines,i,False)


    new_lines = []
    for i,org_line in enumerate(lines):
        line = remcomments(org_line)  # remove comments
        toks = line.split()
        if "GET_ADDRESS" in toks or "GET_UNCHECKED_ADDRESS" in toks:
            value = toks[1]
            if prev_loaded == value and i-prev_line < 6:
                print(f"Prev loaded: {prev_loaded} line {i+1} loaded at line {prev_line+1}")
                org_line = re.sub(".*\|","\t|",org_line)
                nb += 1
            prev_line = i
            prev_loaded = value
        if any(x in toks for x in breaking_instructions) or any(x.startswith("GET_") for x in toks):
            prev_loaded = None
        if re.match("\w+:",line):
            prev_loaded = None


        new_lines.append(org_line)

    #GET_REG_ADDRESS    0x4,d3
    prev_lineno = -1
    prev_toks = []

    new_lines2 = []
    for i,org_line in enumerate(new_lines):
        line = remcomments(org_line)  # remove comments
        toks = line.split()
        if toks and toks[0] == "GET_REG_ADDRESS":
            if prev_toks == toks:
                # 2 same GET_REG_ADDRESS. Check register
                reg = toks[1].split(",")[1]
                # now check if register is referenced between the lines
                reg_re = re.compile(fr"\b{reg}\b")
                label_found = False
                for j in range(prev_lineno+1,i):
                    if reg_re.search(lines[j]):
                        break
                    toks2 = lines[j].split()
                    if any(x in toks2 for x in breaking_instructions) or any(x.startswith("GET_") for x in toks2):
                        label_found = True
                    if re.match("\w+:",lines[j]):
                        label_found = True
                else:
                    if not label_found:
                        nb += 1
                        if verbose:
                            print(f"Prev loaded: {toks}: line {i+1} (loaded at line {prev_lineno+1})")
                        org_line = re.sub(".*\|","\t|",org_line)
            prev_lineno = i
            prev_toks = toks

        new_lines2.append(org_line)

    if verbose:
        if nb:
            print(f"found {nb} GET_ADDRESS useless occs")
        else:
            print("Nothing found")

    return new_lines2
