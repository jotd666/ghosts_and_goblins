import re,pathlib
from shared import *

bankname = "bank3_code_4000"
gamename = "main_code_6000"
# post-conversion automatic patches, allowing not to change the asm file by hand


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

equates = []

this_dir = pathlib.Path(__file__).absolute().parent

source_dir = this_dir / "../src"

# game_specific: replace or remove I/O addresses
input_dict = {
"bankswitch_3e00":"set_bank"
}


def handle_bank(line):
    # pre-add video_address tag if we find a store instruction to an explicit 3000-3FFF address
    if store_to_video.search(line):
        line = line.rstrip() + " [video_address]\n"
    # pre-add bank_address tag if we find a read instruction to an explicit 4000-5FFF address
    if access_bank.search(line):
        line = line.rstrip() + " [bank_address]\n"

    if "[bank_address" in line:
        # give me the original instruction
        line = line.replace("_ADDRESS","_BANK_ADDRESS")

    return line

# various dirty but at least automatic patches applying on the converted code
with open(source_dir / f"{bankname}.s") as f:
    lines = list(f)

for i,line in enumerate(lines):
    address = get_line_address(line)

    line = handle_bank(line)

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

    line = handle_bank(line)

    # generic for 6809 cpus

    if "GET_ADDRESS" in line:
        val = line.split()[1]
        is_stb = ": stb" in line

        osd_call = input_dict.get(val)
        if osd_call is not None:
            if osd_call:
                line = change_instruction(f"jbsr\tosd_{osd_call}",lines,i)
                if is_stb:
                    line = f"\texg\td0,d1\n{line}\texg\td0,d1\n"
            else:
                line = remove_instruction(lines,i)
            lines[i+1] = remove_instruction(lines,i+1)


    if "[video_address" in line:
        # give me the original instruction
        line = line.replace("_ADDRESS","_UNCHECKED_ADDRESS")
        # if it's a write, insert a "VIDEO_DIRTY" macro after the write
        for j in range(i+1,len(lines)):
            next_line = lines[j]
            if "[...]" not in next_line:
                break
            if ",(a0)" in next_line or "clr" in next_line or "MOVE_W_FROM_REG" in next_line:
                if any(x in next_line for x in ["address_word","MOVE_W_FROM_REG"]):
                    lines[j] = next_line+"\tVIDEO_WORD_DIRTY | [...]\n"
                else:
                    lines[j] = next_line+"\tVIDEO_BYTE_DIRTY | [...]\n"
                break

    ###############################################
    # game_specific
    # the 210+ jump tables!
    line = process_jump_table(line)

    # skip RAM/ROM check
    if address == 0x6000:
        start_boot = i
    elif address == 0x607d:
        for j in range(start_boot,i):
            lines[j] = remove_instruction(lines,j)
    elif address == 0x65C4:
        line = remove_instruction(lines,i)
    elif address == 0x65fa:
        line = change_instruction("rts",lines,i)
    elif address == 0x6174:
         line = remove_instruction(lines,i)
         line = change_instruction("add.w\td6,d6",lines,i)
    elif address == 0x617d:
         line = change_instruction("jsr\t(a2,d6.w)",lines,i)

    ###################################################
    # 2 table of tables to rework almost completely
    # this mixes with table rework and is quite a mess but works
    elif address == 0x712e:
        # code must be reworked a lot because of table of tables
        # that we need to convert to native 68k code
        line = change_instruction("asl.b\t#2,d1",lines,i)
        line += "\text.w\td1\n\tlea\ttable_of_jump_tables_7139,a2"
        lines[i+1] = remove_instruction(lines,i+1)
        lines[i+2] = change_instruction("move.l\t(a2,d1.w),a2",lines,i+2)
    elif address == 0x9c85:
        # code must be reworked a lot because of table of tables
        # that we need to convert to native 68k code
        line = change_instruction("asl.b\t#2,d1",lines,i)
        line += "\text.w\td1\n\tlea\ttable_of_jump_tables_9c98,a4"
        lines[i+1] = remove_instruction(lines,i+1)
        lines[i+2] = remove_instruction(lines,i+2)
        lines[i+2] = "\tmove.l\t(a4,d1.w),a4"   # will be side by side with comment
    elif address in {0x7132,0x9C89}:
        line = remove_instruction(lines,i)
    elif address in {0x9c8e}:
        # add sign extend + optimize
        lines[i-1] = "\text.w\td0\n"+change_instruction("add.w\td0,d0",lines,i-1)

    ###################################################

    # remove stray bcc/bcs issues by protecting SR or moving POP_SR
    elif address in {0xec02}:
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

    # game uses $E2 to save/restore stack. We need to use a longword
    if "unsupported instruction sts" in line:
        line = change_instruction("move.l\tsp,stack_save",lines,i)
    if address in {0x6652,0x668F,0x66CC,0x6710}:
        line = change_instruction("move.l\tstack_save,sp",lines,i)
        lines[i+1] = remove_instruction(lines,i+1)


    if "stray cmp" in line:
        # 1 useless CMP instruction
        line = remove_error(line)
    # end game_specific
    ###############################################
    # copy the current line
    lines[i] = line

with open(source_dir / "data.inc","w") as fw:
    fw.writelines(equates)

with open(source_dir / f"{gamename}.68k","w") as fw:
    # game_specific: fill global symbols
    fw.write(f'\t.include "data.inc"\n')
    # referenced in bank3 code
    for gs in """irq_65c4
reset_6000
l_68df
l_6909
l_691c
l_791d
l_7a0f
l_7a05
l_7a00
l_7a0a
l_7a14
l_7958
l_fef0""".splitlines():
        fw.write(f"\t.global\t{gs}\n")
    fw.write("\n")

    fw.write("""
l_ffff:
    *BREAKPOINT  "FFFF"
    illegal
""")
    fw.writelines(lines)