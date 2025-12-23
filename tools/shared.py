import re,pathlib
import os,struct


this_dir = pathlib.Path(__file__).absolute().parent

source_dir = this_dir / "../src"
amiga_source_dir = source_dir / "amiga"

gfx_dir = this_dir / "../assets/sheets"

# post-conversion automatic patches, allowing not to change the asm file by hand
tablere = re.compile("move.w\t#(\w*jump_table_....),d(.)")
jmpre = re.compile("(j..)\s+\[([ab]),(.)\]")

def remove_instruction(lines,i):
    return change_instruction("",lines,i)

def remove_continuing_lines(lines,i):
    for j in range(i+1,i+4):
        if "[...]" in lines[j]:
            lines[j] = ""
        else:
            break

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


dreg_dict = {'a':'d0','b':'d1'}
areg_dict = {'x':'a2','y':'a3','u':'a4'}

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



def remove_error(line):
    if "ERROR" in line:
        return ""
    else:
        raise Exception(f"No ERROR to remove in {line}")

# for log comparison


sorted_cmp = False
avoid_regs = []
regslist = list("abdxu")

def rework(name):
    regs[name] = decode_address(regs[name])

def get_line_address(line):
    try:
        toks = line.split("|")
        address = toks[1].strip(" [$").split(":")[0]
        return int(address,16)
    except (ValueError,IndexError):
        return None


def load_amiga_log(log_name,out_name,existing_pcs=None):
    with open(log_name,"rb") as f:
        contents = f.read()
        contents = contents[:-8]
        dead_marker, = struct.unpack(">H",contents[-2:])

        if dead_marker != 0xDEAD:
            raise Exception("Corrupt CPU log, should end by 0xDEAD at offset -8")

    pcs = set()
    # generated using LOG_REGS
    macro = """
    .macro    LOG_REGS    m6809pc
    move.w    sr,-(a7)
    move.l    a6,-(a7)
    move.l    sub_log_ptr,a6
    move.w    #0x\m6809pc,(a6)+
    move.w    d0,(a6)+
    move.w    d1,(a6)+
    move.w    d2,(a6)+
    move.w    d3,(a6)+
    move.w    d4,(a6)+
    cmp.w    #0xCAFE,(a6)  | hitting the protection buffer
    jne        444f
    BREAKPOINT    "sub cpu log buffer full!"
444:
    move.w    #0xDEAD,(a6)+
    move.l    a6,sub_log_ptr
    move.l    (a7)+,a6
    move.w    (a7)+,sr
    .endm

"""
    len_block = 0

    size = {"b":1,"w":2,"l":4}

    for line in macro.splitlines():
        m = re.search ("move.([bwl]).*,\(a6\)",line)
        if m:
            s = m.group(1)
            len_block += size[s]

    print("Block size = ",hex(len_block))



    lst = []
    for i in range(0,len(contents),len_block):
        chunk = contents[i:i+len_block]
        if len(chunk)<len_block:
            break
        regs=dict()
        regs["pc"],regs["a"],regs["d"],regs["x"],regs["y"],regs["u"],end = struct.unpack_from(">HHHHHHH",chunk)
        if end==0xCCCC:
            break

        regspc = regs["pc"]

        # some PCs that will trigger unnecessary diffs
        if regspc in excluded_pcs:
            continue

        # if set, filter to only existing pcs (pass 2)
        if existing_pcs and regspc not in existing_pcs:
            continue

        pcs.add(regspc)

        regs['b'] = regs['d'] & 0xFF

        regsize = {"a":2,"b":2,"d":4,"x":4,"y":4,"u":4}


        regstr = ["{}={:0{}X}".format(reg.upper(),regs[reg],regsize[reg]) for reg in regslist if reg not in avoid_regs]
        rest = ", ".join(regstr)

        out = f"{regs['pc']:04X}: {rest}\n"

        lst.append(out)

    if sorted_cmp:
        lst.sort()

    with open(out_name,"w") as f:
        prev = None
        for line in lst:
            if prev != line:
                f.write(line)
            prev = line
    return pcs


def load_mame_log(in_log,out_log,pcs):
    """ generated using log:
        trace mame.tr,,noloop,{tracelog "A=%02X, B=%02X, D=%04X, X=%04X, Y=%04X, U=%04X ",a,b,d,x,y,u}
    """
    lst = []
    print("reading MAME trace file...")
    with open(in_log,"r") as f:
        l = len("A=01, B=00, D=9300, X=8100, Y=9300, U=XXXX ")
        for line in f:
            m = re.match("A=(..), B=(..), D=(....), X=(....), Y=(....), U=(....)",line)
            if m:
                pc = line[l:l+4]
                regs = dict()
                pcval = int(pc,16)
                if pcval in pcs and pcval not in excluded_pcs:
                    regs["a"],regs["b"],regs["d"],regs["x"],regs["y"],regs["u"] = m.groups()
                    regstr = ["{}={}".format(reg.upper(),regs[reg]) for reg in regslist if reg not in avoid_regs]
                    rest = ", ".join(regstr)
                    lst.append(f"{pc}: {rest}\n")

    if sorted_cmp:
        lst.sort()
    print("writing filtered MAME trace file...")
    with open(out_log,"w") as fw:
        fw.writelines(lst)

