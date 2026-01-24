import subprocess,os,struct,glob,tempfile
import shutil

from shared import *

gamename = "ghosts_and_goblins"
sox = "sox"

sound_dir = this_dir / ".." / "sounds"

sound_settings_dict = { 0x14 : {"channel":3,"priority":1},
8 : {"priority":40},
3 : {"priority":20},
0x15 : {"priority":70},
0xC : {"priority":70},
0x13 : {"priority":80},

}

def convert():
    if not shutil.which("sox"):
        raise Exception("sox command not in path, please install it")
    # BTW convert wav to mp3: ffmpeg -i input.wav -codec:a libmp3lame -b:a 330k output.mp3

    out_dir = src_dir

    outfile = os.path.join(out_dir,"sounds.68k")
    sndfile = os.path.join(out_dir,"sound_entries.68k")

    low_memory = False

    hq_sample_rate = 10000 if low_memory else 20000  #{"aga":18004,"ecs":12000,"ocs":11025}[mode]
    lq_sample_rate = hq_sample_rate//2 # if aga_mode else 8000


    loop_channel = 2

    EMPTY_SND = "EMPTY_SND"

    dummy_sounds = {
0x3E, # take a key (3F: stop tune?)
0x3B, # door opening
0x2D, # boss 1/2 music
0x33, # level 3 cave music
0x34, # level 3 boss dragon music
0x29, # castle music (lev 5)
0x38, # last boss music (resolve your battle)
0x2A, # boss music (in game)
    0xFF}


    sound_dict = {}
    sfx_list = set()
    # scan directory for speech
    for f in sound_dir.glob("*.wav"):
        sound_name = f.stem
        parts = sound_name.rsplit("_",maxsplit=1)
        if len(parts)>1:
            try:
                index = int(parts[1],16)
                if index not in dummy_sounds:
                    sfx_list.add(index)
                    # auto-declare according to name suffix
                    entry = f"{sound_name}_SND"
                    # fix channel to avoid overlap
                    extra_info = sound_settings_dict.get(index) or dict()

                    sfx_sample_rate = extra_info.get("sample_rate",lq_sample_rate)
                    sound_dict[entry] = {"channel":extra_info.get("channel",-1),
                    "priority":extra_info.get("priority",40),"index":index,"sample_rate":sfx_sample_rate}
            except ValueError:
                pass







    sound_dict.update({
    "MAIN_TUNE_SND"      :{"index":0x2B,"pattern":0,"volume":32},
    "KILLED_TUNE_SND"      :{"index":0x31,"pattern":7,"volume":32},
    "LEVEL_COMPLETE_TUNE_SND"      :{"index":0x3E,"pattern":0xf,"volume":32},
    "LEVEL_START_TUNE_SND"      :{"index":0x30,"pattern":0xB,"volume":32},
    })



    with open(os.path.join(src_dir,"..","sounds.inc"),"w") as f:
        for k,v in sorted(sound_dict.items(),key = lambda x:x[1]["index"]):
            f.write(f"\t.equ\t{k.upper()},  0x{v['index']:x}\n")

    max_sound = 0x100  # max(x["index"] for x in sound_dict.values())+1
    sound_table = [""]*max_sound
    sound_table_set_1 = ["\t.long\t0,0"]*max_sound

    for d in dummy_sounds:
        sound_table_set_1[d] = "\t.word\t3,0,0,0   | valid but muted"



    snd_header = rf"""
    # sound tables
    #
    # the "sound_table" table has 8 bytes per entry
    # first word: 0: no entry, 1: sample, 2: pattern from music module
    # second word: 0 except for music module: pattern number
    # longword: sample data pointer if sample, 0 if no entry and
    # 2 words: 0/1 noloop/loop followed by duration in ticks
    #
    # SOUND_ENTRY macro defines a ptplayer-compatible structure, with added the number
    # of ticks (PAL) giving the duration of the sample (offset 0xA)
    FXFREQBASE = 3579564

        .macro    SOUND_ENTRY    sound_name,size,channel,soundfreq,volume,priority,ticks
    \sound_name\()_sound:
        .long    \sound_name\()_raw
        .word   \size
        .word   FXFREQBASE/\soundfreq,\volume
        .byte    \channel
        .byte    \priority
        .word    \ticks
        .endm

    """

    def write_asm(contents,fw):
        n=0
        for c in contents:
            if n%16 == 0:
                fw.write("\n\t.byte\t0x{:x}".format(c))
            else:
                fw.write(",0x{:x}".format(c))
            n += 1
        fw.write("\n")


    raw_file = os.path.join(tempfile.gettempdir(),"out.raw")
    with open(sndfile,"w") as fst,open(outfile,"w") as fw:
        fst.write(snd_header)

        fw.write("\t.section\t.datachip\n")

        fw.write("\t.global\tmodule_table\n")


        for wav_file,details in sound_dict.items():
            wav_name = os.path.basename(wav_file).lower()[:-4]
            if details.get("channel") is not None:
                fw.write("\t.global\t{}_raw\n".format(wav_name))


        # write the table index => module (there are several modules now)
        vals = [("0","empty")]*32
        for k,v in sound_dict.items():
            m = v.get("module")
            if m:
                index = v["index"]
                vals[index] = (m+"_tunes",k)

        fw.write("module_table:\n")
        for i,val in enumerate(vals):
            fw.write(f"\t.long\t{val[0]}  | {i:02x} ({val[1]})\n")
        fw.write("\n")

        for wav_entry,details in sound_dict.items():
            sound_index = details["index"]

            channel = details.get("channel")
            if channel is None:

                same_as = details.get("same_as")
                if same_as is None:
                    # if music loops, ticks are set to 1 so sound orders only can happen once (else music is started 50 times per second!!)

                    sound_table_set_1[sound_index] = "\t.word\t{},{},{}\n\t.byte\t{},{}".format(2,details["pattern"],0,details["volume"],int(details.get("loops",0)))
                else:
                    # aliased sound: reuse sample for a different sound index
                    wav_entry = same_as
                    details = sound_dict[same_as]
                    wav_name = os.path.basename(wav_entry).lower()[:-4]
                    wav = os.path.splitext(wav_name)[0]
                    sound_table_set_1[sound_index] = f"\t.word\t1,{int(details.get('loops',0))}\n\t.long\t{wav}_sound"
            else:
                wav_name = os.path.basename(wav_entry).lower()[:-4]
                wav_file = os.path.join(sound_dir,wav_name+".wav")

                def get_sox_cmd(sr,output):
                    return [sox,"--volume","3.0",wav_file,"--channels","1","-D","--bits","8","-r",str(sr),"--encoding","signed-integer",output]

                used_sampling_rate = details["sample_rate"]
                used_priority = details.get("priority",1)

                cmd = get_sox_cmd(used_sampling_rate,raw_file)

                subprocess.check_call(cmd)
                with open(raw_file,"rb") as f:
                    contents = f.read()

                # compute max amplitude so we can feed the sound chip with an amped sound sample
                # and reduce the replay volume. this gives better sound quality than replaying at max volume
                # (thanks no9 for the tip!)
                signed_data = [x if x < 128 else x-256 for x in contents]
                maxsigned = max(signed_data)
                minsigned = min(signed_data)

                amp_ratio = max(maxsigned,abs(minsigned))/32

                # JOTD: for that one, I'm using maxxed out sfx by no9, no amp
                print(f"amp_ratio: {amp_ratio}")

                wav = os.path.splitext(wav_name)[0]
                if amp_ratio > 1:
                    print(f"{wav}: volume peaked {amp_ratio}")
                    amp_ratio = 1
                ticks = details.get("ticks")
                if not ticks:
                    ticks = int(len(signed_data)/used_sampling_rate*170)+1  # inflate time (else speech is too fast)
                sound_table[sound_index] = "    SOUND_ENTRY {},{},{},{},{},{},{}\n".format(wav,len(signed_data)//2,channel,
                            used_sampling_rate,int(64*amp_ratio),used_priority,ticks)
                sound_table_set_1[sound_index] = f"\t.word\t1,{int(details.get('loops',0))}\n\t.long\t{wav}_sound"

                if amp_ratio > 0:
                    maxed_contents = [int(x/amp_ratio) for x in signed_data]
                else:
                    maxed_contents = signed_data



                signed_contents = bytes([x if x >= 0 else 256+x for x in maxed_contents])
                # pre-pad with 0W, used by ptplayer for idling
                if signed_contents[0] != b'\x00' and signed_contents[1] != b'\x00':
                    # add zeroes
                    signed_contents = struct.pack(">H",0) + signed_contents

                contents = signed_contents
                # align on 16-bit
                if len(contents)%2:
                    contents += b'\x00'
                # pre-pad with 0W, used by ptplayer for idling
                if contents[0] != b'\x00' and contents[1] != b'\x00':
                    # add zeroes
                    contents = b'\x00\x00' + contents

                fw.write("{}_raw:   | {} bytes".format(wav,len(contents)))

                if len(contents)>65530:
                    raise Exception(f"Sound {wav_entry} is too long")
                write_asm(contents,fw)



        fw.write("\t.align\t8\n")


        fst.writelines(sound_table)
        fst.write("\n\t.global\t{0}\n\n{0}:\n".format("sound_table"))
        for i,st in enumerate(sound_table_set_1):
            fst.write(st)
            fst.write(f" | 0x{i:02x}\n")


convert()


