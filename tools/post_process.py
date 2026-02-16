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
"bankswitch_3e00":"set_bank",
"system_3000":"read_system",
"p1_3001":"read_p1_inputs",
"p2_3002":"read_p2_inputs",
"dsw1_3003":"read_dsw1",
"dsw2_3004":"read_dsw2",
}

def handle_special_addresses(lines,i):
    line = lines[i]
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

    if "[unchecked_address" in line:
        # give me the original instruction
        line = line.replace("_ADDRESS","_UNCHECKED_ADDRESS")
    elif "[select_address" in line:
        # slower but rarely fails
        line = line.replace("_ADDRESS","_SELECT_ADDRESS")
    elif "[video_address" in line:
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
    return line


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
    lines[i] = line
    line = handle_special_addresses(lines,i)

    ###############################################
    # game_specific
    line = process_jump_table(line)

    if address == 0x55CE:
        line = "\tILLEGAL\n"  # not reachable anyway, part of ROM/RAM check code
    if "review pshu instruction" in line or "review pulu instruction" in line or "review stack set from register" in line:
        line = remove_error(line)

    # most routines using "dec ,s", "ora ,s"... instructions need reworking
    # game uses load a with nb_iterations, then pshs a + dec,s.ora,s + puls a => not what we want as pshs uses move.l
    # we have to remove the push/pull and replace by using virtual D5 stack for counter (dec ,s does that)
    if address in {0x53e3,0x53b5}:
        line = change_instruction("GET_REG_ADDRESS\t0,d5",lines,i) + "\tsubq.w\t#1,d5\n\tmove.b\td0,-(a0)   | [...]\n"
    elif address in {0x53f1}:
        # remove the puls A
        line = "\taddq.w\t#1,d5\n"+change_instruction("rts",lines,i)
    elif address in {0x5c41,0x5241}:
        line = change_instruction("GET_REG_ADDRESS\t0,d5",lines,i) + "\tsubq.w\t#1,d5\n\tmove.b\td1,-(a0)   | [...]\n"
    elif address == 0x523E:
        # hook on weapon palette change (maybe not useful on 256 color-capable platforms but on amiga we need that)
        line = "\tjbsr\tosd_weapon_palette_change\n" + line
    elif address == 0x5025:
        # remove movem because afterwards the registers are restored individually
        # plus it's slightly faster, but it was indeed equivalent
        line = change_instruction("move.l\td2,-(sp)",lines,i) + "\tmove.l\td1,-(sp)   | [...]\n"
    elif address == 0x5035:
        # manual read of d2 value from the stack
        line = change_instruction("move.l\t(sp),d2",lines,i)
    elif address == 0x53c3:
        # manual read of d3 value from the stack
        line = change_instruction("move.l\t(sp),d3",lines,i)

    # fix score (using subq #1,d3 to adjust pointer kills X flag)
    if address in {0x5402,0x5409,0x5410,0x5417}:
        lines[i+1] = ""
    # so hardcode offset
    if address == 0x5404:
        line = line.replace("0,d3","-1,d3")
    elif address == 0x540b:
        line = line.replace("0,d3","-2,d3")
    elif address == 0x5412:
        line = line.replace("0,d3","-3,d3")
    elif address == 0x5419:
        line = line.replace("0,d3","-4,d3")

    # here it's ok to fully use target stack
    if address in {0x4807,0x480b,0X4817,0X481f,0x5035,0x53C3,
    0x53d9,0x53dd,0x53ed,0x59f1,0x59f5,0x59f9,0x5a02,0x5a0a,
    0x5a0e,0x5a14,0x5a16,0x5a18,0x5a1e,0x5a20,0x5a24,0x5a26,0x5a4c,0x5a54,
    0x5c58,0x5c5e,0x5c6a,0x5c74,0x5c78,
    }:
        lines[i-1] = remove_error(lines[i-1],ignore_missing=True)
        lines[i-2] = remove_error(lines[i-2],ignore_missing=True)

    lines[i] = line

with open(source_dir / f"{bankname}.68k","w") as fw:
    # game_specific: fill global symbols
    for gs in """clear_screen_and_show_status_4800
l_5025
l_485c
l_489b
l_48bd
l_5022
l_5025
write_one_digit_to_screen_5051
l_54ff
l_5bdd
l_511e
l_513b
write_framed_weapon_523f
l_5347
l_52fb
copy_highscores_53a3
add_to_score_53f4
compute_and_display_time_52b9
l_58ce
l_54e3
l_5a8a
l_5b3a
l_5910
l_5180
l_5975""".splitlines():
        fw.write(f"\t.global\t{gs}\n")
    fw.write("\n")


    fw.writelines(lines)

zd1d2 = """\tZERO_MSW\td1
\tZERO_MSW\td2
\tMAKE_A
"""

with open(source_dir / f"{gamename}.s") as f:
    lines = list(f)

equates_re = re.compile("\w+\s*=\s*")
for i,line in enumerate(lines):
    if equates_re.match(line):
        equates.append(line)
        line = ""

    # post-correct forced lowercase for SND_xxx
    line = re.sub("(snd_\w+)",lambda m:m.group(1).upper(),line)

    address = get_line_address(line)

    line = handle_bank(line)

    lines[i] = line
    # generic for 6809 cpus

    line = handle_special_addresses(lines,i)

    ###############################################
    # game_specific
    # the 210+ jump tables!
    line = process_jump_table(line)

    # original divide/divmod code is slow and uses stack so it's tricky to port
    # better replace it completely

    if 0xfed8 == address:
        #line = '\tBREAKPOINT "implement divide"\n'
        line = """\tand.w\t#0xFF,d1
\tjne\t0f
* avoid zero divide, follow original code behaviour
\tst.b\td0
\tmoveq\t#1,d1
\trts
0:
\tdivu\td1,d0
\tswap\td0
\tmove.w\td0,d1
\tclr.w\td0
\tswap\td0
\trts
"""
        for j in range(i+1,len(lines)):
            if "feef" in lines[j]:
                break
            lines[j] = ""

    if 0xfef0 == address:
        for j in range(i+1,len(lines)):
            if "ff10" in lines[j]:
                break
            lines[j] = ""
        line = """\tGET_REG_ADDRESS\t0,d4   | get pushed address
\tMOVE_W_TO_REG\ta0,d6   | put to scratch register
\tjne\t0f
* avoid zero divide, follow original code behaviour
\tmove.w\t#-1,d1
\tMOVE_W_FROM_REG\td1,a0
\tmoveq\t#0,d0
\tmove.b\t#0x20,d1  | relevant? whatever
\trts
0:
\tdivu\td1,d6   | divide
\texg\td1,d6
\tMOVE_W_FROM_REG\td1,a0 | store the result of the division
\tclr.w\td1     | clear the result
\tswap\td1      | swap to get the remainder
"""

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
        # direct jump
         line = change_instruction("move.l\t(a2,d6.w),a2",lines,i) + "\tjsr\t(a2)\n"
    elif address in {0x6626,0x66a0,0x6729}:
        line = "\tlea\t(a6,d5.w),a3   | change fake stack\n"+line
    elif address in {0x6667,0x66ec}:
        # same as above, but reading from current bank (bank 3)
        line = "\tlea\t(a1,d5.w),a3   | change fake stack, bank memory\n"+line
    elif address == 0xfeed:
        line = change_instruction("addq.w\t#4*2,sp   | pop up both d1 pushes",lines,i)
    elif address == 0xff0e:
        line = change_instruction("add.w\t#4*3,sp   | pop up 3 dx pushes",lines,i)
    elif address == 0x6C17:
        # change value of B so game will go straight to second loop (no more "this room is an illusion" shit)
        line = "\tmove.b\tskip_first_loop_flag,d1\n\tneg.b\td1\n"+line
    elif address == 0x7AF2:
        line = "\tmove.b\tstart_level_flag,d0\n"+change_instruction("OP_W_ON_DP_ADDRESS    move,current_level_0072,d0",lines,i)
    elif address == 0x7183:
        line = "\ttst.b\tskip_intro_flag\n\tjne\tplay_intro_7187\n"+line
    ###################################################
    # 2 table of tables to rework almost completely
    # this mixes with table rework and is quite a mess but works
    elif address == 0x712e:
        # code must be reworked a lot because of table of tables
        # that we need to convert to native 68k code
        line = change_instruction("asl.b\t#2,d1",lines,i)
        line += "\text.w\td1\n\tlea\ttable_of_jump_tables_7139,a2"
        lines[i+1] = remove_instruction(lines,i+1)
    elif address == 0x9c85:
        # code must be reworked a lot because of table of tables
        # that we need to convert to native 68k code
        line = change_instruction("asl.b\t#2,d1",lines,i)
        line += "\text.w\td1\n\tlea\ttable_of_jump_tables_9c98,a4"
        lines[i+1] = remove_instruction(lines,i+1)
        lines[i+2] = remove_instruction(lines,i+2)
        lines[i+2] = "\tmove.l\t(a4,d1.w),a4"   # will be side by side with comment
    elif address in {0x7132}:
        line = change_instruction("move.l\t(a2,d1.w),a2",lines,i)  # load jump table from jump of jump tables
    elif address in {0x9C89}:
        line = remove_instruction(lines,i)
    elif address in {0x9c8e}:
        # add sign extend + optimize
        lines[i-1] = "\text.w\td0\n"+change_instruction("add.w\td0,d0",lines,i-1)
    ###################################################

    # handle manual stack manipulation issues using ora  ,s+ / orb  ,s+
    if ",s+" in line:
        target = None
        if ": ora" in line:
            target = "d0"
        elif ": orb" in line:
            target = "d1"
        if target:
            # find the instruction above that wrongly pushes into native SP stack and change it
            # there are 38 occurrences with ora and same with orb
            for j in range(i-1,i-10,-1):
                other_line = lines[j]
                if "pshs" in other_line:
                    lines[j] = change_instruction("GET_REG_ADDRESS\t0,d5",lines,j) + f"\tsubq.w\t#1,d5   | using virtual stack\n\tmove.b\t{target},-(a0)   | [...]\n"
                    break


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

    ### U and S stack management need some complete change!!
    if address in {0x6326,0xfeed,0x6305} and ("sub" in line or "add" in line):
        lines[i-1] = remove_error(lines[i-1],ignore_missing=True)

    if address in {0x6305,0x6623,0x6664,0x669d,0x66e9,0x6726} and "move." in line:
        # let leas -2,S slide, it's used as local storage, linked to D5
        # also remove handled part where they're using the S and U to decode data
        lines[i-1] = remove_error(lines[i-1],ignore_missing=True)


    # change target stack usage by host stack usage when needed
    # (pshs + restore register without popping stack happens a lot)
    if address in {0x815b}:
        lines[i-1] = remove_error(lines[i-1])
        line = change_instruction("move.l\t(sp),d2",lines,i)

    # here it's ok to fully use target stack
    if address in {0x6104,0x6108,0X6114,0x611a,0x611e,0x6122,0x62ee,0x62f6,0x62fa,0x6301,
    0xff0a,0xff0e,0x62f2,0x6305,0x6326,0x632a,0x632e,0x6332,0x6339,0x63cc,0X63d5,0x68f3,
    0x8cc3,0X8ce0,0x8ce5,0x8cf3,0xe66e
    }:
        lines[i-1] = remove_error(lines[i-1],ignore_missing=True)
        lines[i-2] = remove_error(lines[i-2],ignore_missing=True)


    # PULU movem that is actually a data read
    if address in {0x6638,0x6677,0x66b2,0x66c2,0x66f8,
    0x6706,0x6747,0x6685,0x6DC7,0x6db2}:
        if "movem" in line:
            # change wrong movem. It matches some ROM data structure
            line = change_instruction("movem.w\t(a0)+,d1-d2  | same order than PULU we're lucky",lines,i)
            line += zd1d2

    if address in {0x728f}:
        if "movem" in line:
            # change wrong movem. It matches some ROM data structure
            line = change_instruction("movem.w\t(a0)+,d1-d3  | same order than PULU we're lucky",lines,i)
            line += "\tZERO_MSW\td3\n" + zd1d2


    # we know we handled all pshu properly, remove the errors
    if "review pshu instruction" in line or "review pulu instruction" in line:
            line = remove_error(line,True)

    # PULS
    if address in {0x662e,0x663e,0x66a8,0x66b8,0x672d,0x673d,0x666f,0x667d,0x66f0,0x66fe} and "movem" in line:
        # change wrong movem. It matches some ROM data structure
        line = change_instruction("movem.w\t(a3)+,d1-d2  | same order than PULS we're lucky",lines,i)
        line += zd1d2


    if address == 0x633d:
        # PULS D,PC to pop the stack then return to the caller (we were using target stack before)
        line = change_instruction("addq\t#2,d5",lines,i,False)
##    elif address == 0x8dfa:
##        # PULS D,PC to pop D value, not a problem pops B twice
##        # better check it when it happens
##        line = change_instruction('BREAKPOINT "8DFA"',lines,i,False)
    elif address in {0x69c9,0x7880}:
        # change long pop to just pop stack
        line = change_instruction("addq\t#2,sp",lines,i,False)

    # game uses $E2 to save/restore stack. we know
    if "review stack" in line:
        line = remove_error(line)

    # here it pushes B on stack and decreases the stack memory directly!!
    if address == 0x68df:
        # change loop count register
        line = change_instruction("move.b\t#0x18,d7",lines,i)
    if address == 0x68f3:
        # change loop count register
        line = change_instruction("subq.b\t#1,d7",lines,i)
    elif address in {0x6692,0x6423}:
        # palette update: try to change context
        line = "\tGET_ADDRESS\ttiles_palette_in_ram_1632\n"+change_instruction("jbra\tosd_set_tile_palette",lines,i)
##    elif address == 0xEE56:
##        line = "\tGET_ADDRESS\ttiles_palette_in_ram_1632\n"+change_instruction("jbra\tosd_colors_cycled",lines,i)

    elif address in [0xf570]:
        line = "\ttst.b\tinvincible_flag\n\tjne\tl_f59a\n"+line
    elif address in [0xf13c]:
        line = "\ttst.b\tinvincible_flag\n\tjne\tl_f150\n"+line
    elif address == 0x77A7:
        line = "\ttst.b\tinfinite_lives_flag\n\tjne\tl_77bb\n"+line
    elif address == 0x9bae:
        line = "\ttst.b\tinfinite_lives_flag\n\tjne\tl_9bb6\n"+line

    elif address in {0x661D,0x6697,0x671c,0x6716}:
        # no need to update palette hardware registers, it takes time for nothing
        line = change_instruction("rts",lines,i)
    elif address == 0x7942:
        # sound
        line = "\texg\td0,d1\n"+change_instruction("jbsr\tosd_sound_start",lines,i)+"\texg\td0,d1\n"
##    elif address == 0x6C11:
##        line = "\tmoveq\t#1,d1\n"+line+"\tmoveq\t#1,d0\n"  # temp show map at start
# pattern where logging is required outside the IRQ code
# entering the IRQ disables logging, and exiting restores previous logging state
##    if address == 0x65C4:
##        line = change_instruction("DISABLE_LOG_REGS",lines,i)
##    elif address == 0x65fa:
##        line = "\tREENABLE_LOG_REGS\n"+line
##    elif address == 0x81E7:  # outside IRQ
##        line = """
##    ENABLE_LOG_REGS
##0:
##"""+line


# pattern where logging is required in the IRQ code, much simpler
##    if address == 0x65C4:
##        line = change_instruction("REENABLE_LOG_REGS",lines,i)

##    if address == 0x65fa:
##        line = "\tDISABLE_LOG_REGS\n"+line
##    elif address == 0x7c45:  # in IRQ
##        line = "\tENABLE_LOG_REGS\n"+line


##    elif address == 0x62AB:
##        pass
## force same pic in "start" screen
##        line = "\tGET_ADDRESS 0x6C\n\tmove.w #0x4006,(a0)\n\tENABLE_LOG_REGS\n"+line

    ### end of stack management change

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
queue_sound_forced_791d
l_7a0f
l_7a05
l_7a00
l_7a0a
l_7a14
queue_sound_forced_with_ff_7958
divmod_fef0""".splitlines():
        fw.write(f"\t.global\t{gs}\n")
    fw.write("\n")

    fw.write("""
l_ffff:
    *BREAKPOINT  "FFFF"
    illegal
""")
    fw.writelines(lines)