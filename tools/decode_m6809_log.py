from shared import *

pcs = load_amiga_log(r"..\cpu_log","amiga.tr")

# trace mame.tr,,noloop,{tracelog "A=%02X, B=%02X, D=%04X, X=%04X, Y=%04X, U=%04X ",a,b,d,x,y,u}
load_mame_log(r"K:\Emulation\MAME\mame.tr","mame.tr",pcs)

