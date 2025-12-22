import re,pathlib

bankname = "bank3_code_4000"
gamename = "main_code_6000"
# post-conversion automatic patches, allowing not to change the asm file by hand
tablere = re.compile("move.w\t#(\w*table_....),d(.)")
jmpre = re.compile("(j..)\s+\[a,(.)\]")


def remove_error(line):
    if "ERROR" in line:
        return ""
    else:
        raise Exception(f"No ERROR to remove in {line}")

def remove_instruction(lines,i):
    return change_instruction("",lines,i)

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break


def get_line_address(line):
    try:
        toks = line.split("|")
        address = toks[1].strip(" [$").split(":")[0]
        return int(address,16)
    except (ValueError,IndexError):
        return None

def change_instruction(code,lines,i):
    line = lines[i]
    toks = line.split("|")
    if len(toks)==2:
        toks[0] = f"\t{code}"
        remove_continuing_lines(lines,i)
        return " | ".join(toks)
    return line

def remove_code(pattern,lines,i):
    if pattern in lines[i]:
        lines[i] = remove_instruction(lines,i)
        remove_continuing_lines(lines,i)
    return lines[i]

def subt(m):
    tn = m.group(1)
    rn = m.group(2)
    offset = tn.split("_")[-1]
    rval = f"""
\t.ifndef\tRELEASE
\tmove.w\t#0x{offset},d{rn}
\t.endif
\tlea\t{tn},a{rn}"""
    return rval

dreg_dict = {'a':'d0','b':'d1'}
areg_dict = {'x':'a2','y':'a3','u':'a4'}
equates = []

this_dir = pathlib.Path(__file__).absolute().parent

source_dir = this_dir / "../src"

# game_specific: replace or remove I/O addresses
input_dict = {
#"sh_irqtrigger_w_1481":"",
}

store_to_video = re.compile("GET_ADDRESS\s+0x2")   # game_specific

def process_jump_table(line):
    if "#jump_table_" in line:
        # move.w  #jump_table...,dX => lea jump_table...,aX works as X ranges from 2 to 4
        line = line.replace("move.w\t#","lea\t").replace(",d",",a")

    if "indirect j" in line:
        # grab original code in comments, dirty but works as long as converter
        # presents it like this
        comment = line.split('|')[1]
        orig_inst = line.split(":")[1].split("]")[0].replace('[','')
        # parse code: Jxx [R1,R2], R1 = A or B, R2 = X,Y,U
        toks = orig_inst.split()

        dreg,areg = toks[1].split(",")
        dreg = dreg_dict[dreg]
        areg = areg_dict[areg]
        line = remove_error(line)
        line = f"""\tadd.w\t{dreg},{dreg}
\t{toks[0]}\t({areg},{dreg}.w)  |{comment}
"""
    return line

# various dirty but at least automatic patches applying on the converted code
with open(source_dir / f"{bankname}.s") as f:
    lines = list(f)

for i,line in enumerate(lines):
    address = get_line_address(line)

    ###############################################
    # game_specific
    line = process_jump_table(line)

    if address == 0x55CE:
        line = "\tILLEGAL\n"  # not reachable anyway, part of ROM/RAM check code
    lines[i] = line




with open(source_dir / f"{bankname}.68k","w") as fw:
    # game_specific: fill global symbols
    for gs in """l_4800
l_5025
l_485c
l_489b
l_48bd
l_5022
l_5025
l_5051
l_54ff
l_5bdd""".splitlines():
        fw.write(f"\t.global\t{gs}\n")
    fw.write("\n")
    fw.writelines(lines)

with open(source_dir / f"{gamename}.s") as f:
    lines = list(f)

for i,line in enumerate(lines):
    if " = " in line:
        equates.append(line)
        line = ""


    address = get_line_address(line)

    ###############################################
    # game_specific

    # skip RAM/ROM check
    if address == 0x6000:
        line = change_instruction("jmp\tend_of_memory_test_607d",lines,i)

    # remove stray bcc/bcs issues by protecting SR or moving POP_SR
    if address in {0xec02}:
        line = "\tPOP_SR   | restore C\n"+line
        lines[i+1] = remove_error(lines[i+1])
        lines[i-2] += "\tPUSH_SR  | save C\n"

    elif address in {0xa22c,0xbad6,0xcebc,0xa27c}:
        line = "\tPOP_SR   | restore C\n"+line
        lines[i+1] = remove_error(lines[i+1])
        lines[i-3] += "\tPUSH_SR  | save C\n"

    elif address in {0x81c4,0x8441,0xa551,0xa6df,0xb3f0}:
        lines[i+1] = remove_error(lines[i+1])
        lines[i-1] += "\tPOP_SR   | restore\n"
        if "POP_SR" not in lines[i-4]:
            raise Exception(f"Cannot move POP_SR before{address:04x}")
        lines[i-4] = ""  #remove POP_SR

    if address in {0xec80,0xec6a}:
        # remove DAA
        line = remove_instruction(lines,i)

    line = process_jump_table(line)

    if "stray cmp" in line:
        # 1 useless CMP instruction
        line = remove_error(line)
    # end game_specific
    ###############################################
    lines[i] = line

with open(source_dir / "data.inc","w") as fw:
    fw.writelines(equates)

with open(source_dir / f"{gamename}.68k","w") as fw:
    # game_specific: fill global symbols
    fw.write(f'\t.include "data.inc"\n')
    # referenced in bank3 code
    for gs in """l_68df
l_6909
l_691c
l_791d
l_7a0f
l_7a05
l_7a00
l_7a0a
l_7a14
l_fef0""".splitlines():
        fw.write(f"\t.global\t{gs}\n")
    fw.write("\n")

    fw.write("""
l_ffff:
    *BREAKPOINT  "FFFF"
    illegal
""")
    fw.writelines(lines)