;	map(0x0000, 0x1dff).ram();
;	map(0x1e00, 0x1fff).ram().share("spriteram");
;	map(0x2000, 0x27ff).ram().w(FUNC(gng_state::fgvideoram_w)).share(m_fgvideoram);
;	map(0x2800, 0x2fff).ram().w(FUNC(gng_state::bgvideoram_w)).share(m_bgvideoram);
;	map(0x3000, 0x3000).portr("SYSTEM");
;	map(0x3001, 0x3001).portr("P1");
;	map(0x3002, 0x3002).portr("P2");
;	map(0x3003, 0x3003).portr("DSW1");
;	map(0x3004, 0x3004).portr("DSW2");
;	map(0x3800, 0x38ff).w(m_palette, FUNC(palette_device::write8_ext)).share("palette_ext");
;	map(0x3900, 0x39ff).w(m_palette, FUNC(palette_device::write8)).share("palette");
;	map(0x3a00, 0x3a00).w("soundlatch", FUNC(generic_latch_8_device::write));
;	map(0x3b08, 0x3b09).w(FUNC(gng_state::bgscrollx_w));
;	map(0x3b0a, 0x3b0b).w(FUNC(gng_state::bgscrolly_w));
;	// 0x3c00 is the DMA trigger. Not emulated.
;	map(0x3d00, 0x3d07).w("mainlatch", FUNC(ls259_device::write_d0));
;	map(0x3e00, 0x3e00).w(FUNC(gng_state::bankswitch_w));
;	map(0x4000, 0x5fff).bankr(m_mainbank);
;	map(0x6000, 0xffff).rom();

bankswitch_3e00 = $3e00
bankswitch_copy_d9 = $d9
weapon_type_0073 = $73
starting_level_0072 = $72
armour_flag_00ac = $ac
nb_lives_0060 = $60
time_00aa = $aa

; jump to 607D to skip ram/rom checks
6000: 1A 50       ORCC   #$50		; disable interrupts
6002: 8E 1E 00    LDX    #$1E00
6005: 10 8E 00 60 LDY    #$0060
6009: CC F8 F8    LDD    #$F8F8
600C: ED 81       STD    ,X++
600E: ED 81       STD    ,X++
6010: 31 3F       LEAY   -$1,Y
6012: 26 F8       BNE    $600C
6014: C6 64       LDB    #$64
; dma trigger wait loop?
6016: 13          SYNC
6017: B6 3C 00    LDA    $3C00
601A: 12          NOP
601B: 12          NOP
601C: 12          NOP
601D: 5A          DECB
601E: 26 F6       BNE    $6016
6020: C6 01       LDB    #$01
6022: F7 3D 00    STB    $3D00
6025: 4F          CLRA
6026: 5F          CLRB
6027: FD 3B 08    STD    $3B08
602A: FD 3B 0A    STD    $3B0A
602D: C6 00       LDB    #$00
602F: 1F 9B       TFR    B,DP
6031: C6 00       LDB    #$00
6033: F7 3D 01    STB    $3D01
6036: 8E 28 00    LDX    #$2800
6039: 10 8E 2C 00 LDY    #$2C00
603D: 86 00       LDA    #$00
603F: C6 00       LDB    #$00
6041: A7 80       STA    ,X+
6043: E7 A0       STB    ,Y+
6045: 8C 2C 00    CMPX   #$2C00
6048: 25 F7       BCS    $6041
604A: 8E 20 00    LDX    #$2000
604D: C6 20       LDB    #$20
604F: 10 8E 24 00 LDY    #$2400
6053: 86 08       LDA    #$08
6055: E7 80       STB    ,X+
6057: A7 A0       STA    ,Y+
6059: 8C 23 FF    CMPX   #$23FF
605C: 23 F7       BLS    $6055
605E: C6 01       LDB    #$01
6060: F7 3D 00    STB    $3D00
6063: 4F          CLRA
6064: 5F          CLRB
6065: FD 3B 08    STD    $3B08
6068: DD D4       STD    $D4
606A: FD 3B 0A    STD    $3B0A
606D: DD D6       STD    $D6
606F: D7 D9       STB    bankswitch_copy_d9
6071: C6 03       LDB    #$03
6073: F7 3E 00    STB    bankswitch_3e00
6076: 10 8E 60 7D LDY    #$607D
607A: 7E 54 FF    JMP    $54FF		; [bank_3]
; end of memory tests
607D: C6 00       LDB    #$00
607F: 1F 9B       TFR    B,DP
6081: 4F          CLRA
6082: 5F          CLRB
6083: 8E 00 00    LDX    #$0000
6086: ED 81       STD    ,X++
6088: 8C 1F FF    CMPX   #$1FFF
608B: 23 F9       BLS    $6086
608D: 10 CE 03 00 LDS    #$0300
6091: CE 02 80    LDU    #$0280
6094: 8E 01 40    LDX    #$0140
6097: 9F 16       STX    $16
6099: 9F 14       STX    $14
609B: 8E 01 00    LDX    #$0100
609E: 9F 12       STX    $12
60A0: 9F 10       STX    $10
60A2: CC FF FF    LDD    #$FFFF
60A5: ED 81       STD    ,X++
60A7: ED 81       STD    ,X++
60A9: 8C 01 3F    CMPX   #$013F
60AC: 23 F7       BLS    $60A5
60AE: 34 40       PSHS   U
60B0: 8E 03 00    LDX    #$0300
60B3: 33 88 20    LEAU   $20,X
60B6: 10 8E 00 40 LDY    #$0040
60BA: CC 10 00    LDD    #$1000
60BD: A7 80       STA    ,X+
60BF: E7 C0       STB    ,U+
60C1: 31 3F       LEAY   -$1,Y
60C3: 26 F8       BNE    $60BD
60C5: 35 40       PULS   U
60C7: 8E 1E 00    LDX    #$1E00
60CA: 10 8E 01 80 LDY    #$0180
60CE: 86 F8       LDA    #$F8
60D0: A7 80       STA    ,X+
60D2: 31 3F       LEAY   -$1,Y
60D4: 26 FA       BNE    $60D0
60D6: C6 04       LDB    #$04
60D8: D7 D9       STB    bankswitch_copy_d9
60DA: F7 3E 00    STB    bankswitch_3e00
60DD: 8E 40 00    LDX    #$4000
60E0: 10 8E 04 80 LDY    #$0480
60E4: C6 80       LDB    #$80
60E6: A6 80       LDA    ,X+
60E8: A7 A0       STA    ,Y+
60EA: 5A          DECB
60EB: 26 F9       BNE    $60E6
60ED: 8E 40 80    LDX    #$4080
60F0: 10 8E 16 B2 LDY    #$16B2
60F4: C6 80       LDB    #$80
60F6: A6 80       LDA    ,X+
60F8: A7 A0       STA    ,Y+
60FA: 5A          DECB
60FB: 26 F9       BNE    $60F6
60FD: 8E 15 2C    LDX    #$152C
6100: 10 8E 61 AA LDY    #$61AA
6104: 32 7E       LEAS   -$2,S
6106: 86 0A       LDA    #$0A
6108: A7 61       STA    $1,S
610A: CC 00 01    LDD    #$0001
610D: ED 81       STD    ,X++
610F: 5F          CLRB
6110: ED 81       STD    ,X++
6112: C6 03       LDB    #$03
6114: E7 E4       STB    ,S
6116: A6 A0       LDA    ,Y+
6118: A7 80       STA    ,X+
611A: 6A E4       DEC    ,S
611C: 26 F8       BNE    $6116
611E: 6A 61       DEC    $1,S
6120: 26 E8       BNE    $610A
6122: 32 62       LEAS   $2,S
6124: C6 0A       LDB    #$0A
6126: 10 8E 15 18 LDY    #$1518
612A: 8E 15 2C    LDX    #$152C
612D: AF A1       STX    ,Y++
612F: 30 07       LEAX   $7,X
6131: 5A          DECB
6132: 26 F9       BNE    $612D
6134: 10 8E 61 AA LDY    #$61AA
6138: CC 00 01    LDD    #$0001
613B: DD D0       STD    $D0
613D: 5F          CLRB
613E: DD D2       STD    $D2
6140: BD 62 2C    JSR    $622C
6143: BD 62 39    JSR    $6239
6146: BD 62 74    JSR    $6274
6149: 5F          CLRB
614A: F7 3A 00    STB    $3A00
614D: 4F          CLRA
614E: 5F          CLRB
614F: DD D4       STD    $D4
6151: DD D6       STD    $D6
6153: C6 01       LDB    #$01
6155: D7 D8       STB    $D8
6157: 86 01       LDA    #$01
6159: B7 3D 01    STA    $3D01
615C: 1C EF       ANDCC  #$EF
615E: 20 1F       BRA    $617F
6160: 10 8E FF FF LDY    #$FFFF
6164: 10 AF 81    STY    ,X++
6167: 8C 01 3F    CMPX   #$013F
616A: 25 03       BCS    $616F
616C: 8E 01 00    LDX    #$0100
616F: 9F 12       STX    $12
6171: 8E 61 88    LDX    #jump_table_6188
6174: AE 86       LDX    A,X
6176: 86 03       LDA    #$03
6178: 97 D9       STA    bankswitch_copy_d9
617A: B7 3E 00    STA    bankswitch_3e00
617D: AD 84       JSR    ,X			; [indirect_jump] to bank 3
617F: 9E 12       LDX    $12
6181: EC 84       LDD    ,X
6183: 48          ASLA
6184: 24 DA       BCC    $6160
6186: 20 F7       BRA    $617F
; from bank 3
jump_table_6188:
	.word	$4800 
	.word	$485C
	.word	$489B 
	.word	$48BD 
	.word	$5022

6248: 97 52       STA    $52
624A: CC 01 01    LDD    #$0101
624D: FD 15 85    STD    $1585
6250: FD 15 8D    STD    $158D
6253: 5F          CLRB
6254: 96 40       LDA    $40
6256: 84 0F       ANDA   #$0F
6258: 81 0F       CMPA   #$0F
625A: 26 01       BNE    $625D
625C: 5C          INCB
625D: D7 51       STB    $51
625F: 10 8E 15 82 LDY    #$1582
6263: 48          ASLA
6264: 8E 62 08    LDX    #$6208
6267: AE 86       LDX    A,X
6269: D6 40       LDB    $40
626B: C5 10       BITB   #$10
626D: 27 02       BEQ    $6271
626F: 31 28       LEAY   $8,Y
6271: AF 23       STX    $3,Y
6273: 39          RTS
6274: 96 41       LDA    $41
6276: 84 03       ANDA   #$03
6278: 8E 61 C8    LDX    #$61C8
627B: A6 86       LDA    A,X
627D: 97 50       STA    $50
627F: 5F          CLRB
6280: 96 41       LDA    $41
6282: 85 04       BITA   #$04
6284: 26 01       BNE    $6287
6286: 5C          INCB
6287: D7 53       STB    $53
6289: D6 41       LDB    $41
628B: C4 18       ANDB   #$18
628D: 54          LSRB
628E: 54          LSRB
628F: 8E 61 CC    LDX    #$61CC
6292: AE 85       LDX    B,X
6294: A6 80       LDA    ,X+
6296: 97 54       STA    $54
6298: 9F 55       STX    $55
629A: 96 41       LDA    $41
629C: 84 60       ANDA   #$60
629E: 44          LSRA
629F: 44          LSRA
62A0: 44          LSRA
62A1: 44          LSRA
62A2: 44          LSRA
62A3: 8E 62 28    LDX    #$6228
62A6: A6 86       LDA    A,X
62A8: 97 57       STA    $57
62AA: 39          RTS
62AB: 34 40       PSHS   U
62AD: 9E 6C       LDX    $6C
62AF: C6 02       LDB    #$02
62B1: D7 D9       STB    bankswitch_copy_d9
62B3: F7 3E 00    STB    bankswitch_3e00
62B6: E6 84       LDB    ,X
62B8: 8D 4F       BSR    $6309
62BA: DC 6C       LDD    $6C
62BC: 5A          DECB
62BD: 1F 01       TFR    D,X
62BF: C6 02       LDB    #$02
62C1: D7 D9       STB    bankswitch_copy_d9
62C3: F7 3E 00    STB    bankswitch_3e00
62C6: E6 84       LDB    ,X
62C8: 8D 3F       BSR    $6309
62CA: C6 02       LDB    #$02
62CC: D7 D9       STB    bankswitch_copy_d9
62CE: F7 3E 00    STB    bankswitch_3e00
62D1: DC 6C       LDD    $6C
62D3: 5C          INCB
62D4: 1F 01       TFR    D,X
62D6: 9F FE       STX    $FE
62D8: E6 84       LDB    ,X
62DA: D7 FC       STB    $FC
62DC: 58          ASLB
62DD: 8E 42 00    LDX    #$4200
62E0: AE 85       LDX    B,X
62E2: D6 FC       LDB    $FC
62E4: 9F FC       STX    $FC
62E6: BD 63 78    JSR    $6378
62E9: BD 63 81    JSR    $6381
62EC: 33 41       LEAU   $1,U
62EE: 32 7E       LEAS   -$2,S
62F0: C6 04       LDB    #$04
62F2: E7 61       STB    $1,S
62F4: C6 08       LDB    #$08
62F6: E7 E4       STB    ,S
62F8: 8D 45       BSR    $633F
62FA: 6A E4       DEC    ,S
62FC: 26 FA       BNE    $62F8
62FE: 33 C8 50    LEAU   $50,U
6301: 6A 61       DEC    $1,S
6303: 26 EF       BNE    $62F4
6305: 32 62       LEAS   $2,S
6307: 35 C0       PULS   U,PC
6309: 86 02       LDA    #$02
630B: 97 D9       STA    bankswitch_copy_d9
630D: B7 3E 00    STA    bankswitch_3e00
6310: 9F FE       STX    $FE
6312: D7 FC       STB    $FC
6314: 4F          CLRA
6315: 58          ASLB
6316: 49          ROLA
6317: 8E 42 00    LDX    #$4200
631A: AE 8B       LDX    D,X
631C: D6 FC       LDB    $FC
631E: 9F FC       STX    $FC
6320: 8D 56       BSR    $6378
6322: 8D 5D       BSR    $6381
6324: 33 41       LEAU   $1,U
6326: 32 7E       LEAS   -$2,S
6328: C6 08       LDB    #$08
632A: E7 61       STB    $1,S
632C: C6 08       LDB    #$08
632E: E7 E4       STB    ,S
6330: 8D 0D       BSR    $633F
6332: 6A E4       DEC    ,S
6334: 26 FA       BNE    $6330
6336: 33 C8 50    LEAU   $50,U
6339: 6A 61       DEC    $1,S
633B: 26 EF       BNE    $632C
633D: 35 86       PULS   D,PC
633F: C6 00       LDB    #$00
6341: D7 D9       STB    bankswitch_copy_d9
6343: F7 3E 00    STB    bankswitch_3e00
6346: E6 80       LDB    ,X+
6348: 4F          CLRA
6349: 58          ASLB
634A: 49          ROLA
634B: 58          ASLB
634C: 49          ROLA
634D: 58          ASLB
634E: 49          ROLA
634F: D3 FC       ADDD   $FC
6351: 1F 02       TFR    D,Y
6353: C6 01       LDB    #$01
6355: D7 D9       STB    bankswitch_copy_d9
6357: F7 3E 00    STB    bankswitch_3e00
635A: E6 A4       LDB    ,Y
635C: A6 21       LDA    $1,Y
635E: ED C3       STD    ,--U
6360: E6 22       LDB    $2,Y
6362: A6 23       LDA    $3,Y
6364: ED C8 20    STD    $20,U
6367: E6 24       LDB    $4,Y
6369: A6 25       LDA    $5,Y
636B: ED C9 04 00 STD    $0400,U
636F: E6 26       LDB    $6,Y
6371: A6 27       LDA    $7,Y
6373: ED C9 04 20 STD    $0420,U
6377: 39          RTS
6378: 86 40       LDA    #$40
637A: 3D          MUL
637B: 8E 40 00    LDX    #$4000
637E: 30 8B       LEAX   D,X
6380: 39          RTS
6381: CE 28 0F    LDU    #$280F
6384: D6 FF       LDB    $FF
6386: C5 01       BITB   #$01
6388: 27 04       BEQ    $638E
638A: 33 C9 02 00 LEAU   $0200,U
638E: C5 20       BITB   #$20
6390: 27 03       BEQ    $6395
6392: 33 C8 10    LEAU   $10,U
6395: 39          RTS
6396: E6 13       LDB    -$D,X
6398: 58          ASLB
6399: CE 63 9E    LDU    #jump_table_639e
639C: 6E D5       JMP    [B,U]		 ; [indirect_jump]



63AC: D6 F0       LDB    $F0
63AE: 26 02       BNE    $63B2
63B0: 6C 13       INC    -$D,X
63B2: 39          RTS
63B3: DC D4       LDD    $D4
63B5: ED 06       STD    $6,X
63B7: DC D6       LDD    $D6
63B9: ED 08       STD    $8,X
63BB: 4F          CLRA
63BC: 5F          CLRB
63BD: DD D4       STD    $D4
63BF: CC 01 00    LDD    #$0100
63C2: DD D6       STD    $D6
63C4: 8E 16 32    LDX    #$1632
63C7: CE 65 3C    LDU    #$653C
63CA: 86 40       LDA    #$40
63CC: A7 7F       STA    -$1,S
63CE: EC C1       LDD    ,U++
63D0: A7 88 40    STA    $40,X
63D3: E7 80       STB    ,X+
63D5: 6A 7F       DEC    -$1,S
63D7: 26 F5       BNE    $63CE
63D9: 10 8E 28 4E LDY    #$284E
63DD: CE 64 A1    LDU    #$64A1
63E0: 30 A4       LEAX   ,Y
63E2: A6 C0       LDA    ,U+
63E4: 27 0A       BEQ    $63F0
63E6: A7 82       STA    ,-X
63E8: E6 C0       LDB    ,U+
63EA: E7 89 04 00 STB    $0400,X
63EE: 20 F2       BRA    $63E2
63F0: 31 A8 20    LEAY   $20,Y
63F3: A6 C4       LDA    ,U
63F5: 26 E9       BNE    $63E0
63F7: BD 68 DF    JSR    $68DF
63FA: 96 72       LDA    starting_level_0072
63FC: 81 04       CMPA   #$04
63FE: 24 1B       BCC    $641B
6400: 8E 1E 14    LDX    #$1E14
6403: C6 5B       LDB    #$5B
6405: E7 80       STB    ,X+
6407: C6 84       LDB    #$84
6409: E7 80       STB    ,X+
640B: CE 64 81    LDU    #$6481
640E: D6 81       LDB    $81
6410: 58          ASLB
6411: EE C5       LDU    B,U
6413: 48          ASLA
6414: EC C6       LDD    A,U
6416: ED 84       STD    ,X
6418: B7 15 A7    STA    $15A7
641B: C6 3F       LDB    #$3F
641D: F7 15 AC    STB    $15AC
6420: 7C 15 95    INC    $1595
6423: 39          RTS
6424: 0F D6       CLR    $D6
6426: 6A 0A       DEC    $A,X
6428: 26 02       BNE    $642C
642A: 6C 13       INC    -$D,X
642C: BD 64 71    JSR    $6471
642F: 39          RTS
6430: BD 64 71    JSR    $6471
6433: 6A 23       DEC    $3,Y
6435: 26 02       BNE    $6439
6437: 6F 05       CLR    $5,X
6439: DC D4       LDD    $D4
643B: C3 00 01    ADDD   #$0001
643E: DD D4       STD    $D4
6440: 10 83 00 8F CMPD   #$008F
6444: 25 02       BCS    $6448
6446: 6C 13       INC    -$D,X
6448: 39          RTS
6449: 96 72       LDA    starting_level_0072
644B: 81 04       CMPA   #$04
644D: 25 03       BCS    $6452
644F: BD 64 00    JSR    $6400
6452: 6C 13       INC    -$D,X
6454: 39          RTS

6455: EC 06       LDD    $6,X
6457: DD D4       STD    $D4
6459: EC 08       LDD    $8,X
645B: DD D4       STD    $D4
645D: 86 01       LDA    #$01
645F: 97 80       STA    $80
6461: 6F 13       CLR    -$D,X
6463: BD 68 DF    JSR    $68DF
6466: C6 01       LDB    #$01
6468: D7 F0       STB    $F0
646A: CC 0E 00    LDD    #$0E00
646D: BD 69 09    JSR    $6909
6470: 39          RTS
6471: E6 05       LDB    $5,X
6473: 96 21       LDA    $21
6475: 84 08       ANDA   #$08
6477: 26 01       BNE    $647A
6479: 5F          CLRB
647A: 10 8E 1E 14 LDY    #$1E14
647E: E7 22       STB    $2,Y
6480: 39          RTS

65C4: ??? IRQ
65CA: CC 00 01    LDD    #$0001
65CD: D3 20       ADDD   $20
65CF: DD 20       STD    $20
65D1: 8D 28       BSR    $65FB
65D3: BD 67 55    JSR    $6755
65D6: BD 67 72    JSR    $6772
65D9: BD 62 2C    JSR    $622C
65DC: BD 79 30    JSR    $7930
65DF: BD 67 B3    JSR    $67B3
65E2: BD 62 39    JSR    $6239
65E5: BD 62 74    JSR    $6274
65E8: C6 03       LDB    #$03
65EA: F7 3E 00    STB    bankswitch_3e00
65ED: D6 02       LDB    $02
65EF: 58          ASLB
65F0: 8E 65 BC    LDX    #jump_table_65bc
65F3: AD 95       JSR    [B,X]		; [indirect_jump]
65F5: D6 D9       LDB    bankswitch_copy_d9
65F7: F7 3E 00    STB    bankswitch_3e00
65FA: 3B          RTI
65FB: D6 21       LDB    $21
65FD: C4 03       ANDB   #$03
65FF: 8E 66 0D    LDX    #$660D
6602: A6 85       LDA    B,X
6604: B7 3E 00    STA    bankswitch_3e00
6607: 58          ASLB
6608: 8E 66 11    LDX    #jump_table_6611
660B: 6E 95       JMP    [B,X]	; [indirect_jump]


6619: 96 DE       LDA    $DE
661B: 26 39       BNE    $6656
661D: 10 DF E2    STS    $E2
6620: CE 16 32    LDU    #$1632
6623: 32 C8 40    LEAS   $40,U
6626: 10 8E 38 00 LDY    #$3800
662A: C6 08       LDB    #$08
662C: D7 E0       STB    $E0
662E: 35 16       PULS   D,X
6630: ED A9 01 00 STD    $0100,Y
6634: AF A9 01 02 STX    $0102,Y
6638: 37 16       PULU   D,X
663A: ED A1       STD    ,Y++
663C: AF A1       STX    ,Y++
663E: 35 16       PULS   D,X
6640: ED A9 01 00 STD    $0100,Y
6644: AF A9 01 02 STX    $0102,Y
6648: 37 16       PULU   D,X
664A: ED A1       STD    ,Y++
664C: AF A1       STX    ,Y++
664E: 0A E0       DEC    $E0
6650: 26 DC       BNE    $662E
6652: 10 DE E2    LDS    $E2
6655: 39          RTS
6656: 4A          DECA
6657: 10 DF E2    STS    $E2
665A: 5F          CLRB
665B: D7 DE       STB    $DE
665D: 44          LSRA
665E: 56          RORB
665F: C3 40 00    ADDD   #$4000
6662: 1F 03       TFR    D,U
6664: 32 C8 40    LEAS   $40,U
6667: 10 8E 16 32 LDY    #$1632
666B: C6 08       LDB    #$08
666D: D7 E0       STB    $E0
666F: 35 16       PULS   D,X
6671: ED A8 40    STD    $40,Y
6674: AF A8 42    STX    $42,Y
6677: 37 16       PULU   D,X
6679: ED A1       STD    ,Y++
667B: AF A1       STX    ,Y++
667D: 35 16       PULS   D,X
667F: ED A8 40    STD    $40,Y
6682: AF A8 42    STX    $42,Y
6685: 37 16       PULU   D,X
6687: ED A1       STD    ,Y++
6689: AF A1       STX    ,Y++
668B: 0A E0       DEC    $E0
668D: 26 E0       BNE    $666F
668F: 10 DE E2    LDS    $E2
6692: 39          RTS
6693: 96 DF       LDA    $DF
6695: 2B 3B       BMI    $66D2
6697: 10 DF E2    STS    $E2
669A: CE 16 B2    LDU    #$16B2
669D: 32 C8 40    LEAS   $40,U
66A0: 10 8E 38 40 LDY    #$3840
66A4: C6 08       LDB    #$08
66A6: D7 E0       STB    $E0
66A8: 35 16       PULS   D,X
66AA: ED A9 01 00 STD    $0100,Y
66AE: AF A9 01 02 STX    $0102,Y
66B2: 37 16       PULU   D,X
66B4: ED A1       STD    ,Y++
66B6: AF A1       STX    ,Y++
66B8: 35 16       PULS   D,X
66BA: ED A9 01 00 STD    $0100,Y
66BE: AF A9 01 02 STX    $0102,Y
66C2: 37 16       PULU   D,X
66C4: ED A1       STD    ,Y++
66C6: AF A1       STX    ,Y++
66C8: 0A E0       DEC    $E0
66CA: 26 DC       BNE    $66A8
66CC: 10 DE E2    LDS    $E2
66CF: 0F DF       CLR    $DF
66D1: 39          RTS
66D2: 84 30       ANDA   #$30
66D4: 10 8E 16 B2 LDY    #$16B2
66D8: 31 A6       LEAY   A,Y
66DA: D6 DF       LDB    $DF
66DC: C4 0F       ANDB   #$0F
66DE: 86 20       LDA    #$20
66E0: 3D          MUL
66E1: CE 41 00    LDU    #$4100
66E4: 33 CB       LEAU   D,U
66E6: 10 DF E2    STS    $E2
66E9: 32 C8 10    LEAS   $10,U
66EC: C6 02       LDB    #$02
66EE: D7 E0       STB    $E0
66F0: 35 16       PULS   D,X
66F2: ED A8 40    STD    $40,Y
66F5: AF A8 42    STX    $42,Y
66F8: 37 16       PULU   D,X
66FA: ED A1       STD    ,Y++
66FC: AF A1       STX    ,Y++
66FE: 35 16       PULS   D,X
6700: ED A8 40    STD    $40,Y
6703: AF A8 42    STX    $42,Y
6706: 37 16       PULU   D,X
6708: ED A1       STD    ,Y++
670A: AF A1       STX    ,Y++
670C: 0A E0       DEC    $E0
670E: 26 E0       BNE    $66F0
6710: 10 DE E2    LDS    $E2
6713: 08 DF       ASL    $DF
6715: 39          RTS
6716: 10 8E 38 C0 LDY    #$38C0
671A: 20 04       BRA    $6720
671C: 10 8E 38 80 LDY    #$3880
6720: 10 DF E2    STS    $E2
6723: CE 04 80    LDU    #$0480
6726: 32 C8 40    LEAS   $40,U
6729: C6 08       LDB    #$08
672B: D7 E0       STB    $E0
672D: 35 16       PULS   D,X
672F: ED A9 01 00 STD    $0100,Y
6733: AF A9 01 02 STX    $0102,Y
6737: 37 16       PULU   D,X
6739: ED A1       STD    ,Y++
673B: AF A1       STX    ,Y++
673D: 35 16       PULS   D,X
673F: ED A9 01 00 STD    $0100,Y
6743: AF A9 01 02 STX    $0102,Y
6747: 37 16       PULU   D,X
6749: ED A1       STD    ,Y++
674B: AF A1       STX    ,Y++
674D: 0A E0       DEC    $E0
674F: 26 DC       BNE    $672D
6751: 10 DE E2    LDS    $E2
6754: 39          RTS
6755: D6 D8       LDB    $D8
6757: D8 DA       EORB   $DA
6759: F7 3D 00    STB    $3D00
675C: DC D4       LDD    $D4
675E: B7 3B 09    STA    $3B09
6761: F7 3B 08    STB    $3B08
6764: DC D6       LDD    $D6
6766: 43          COMA
6767: 53          COMB
6768: C3 00 01    ADDD   #$0001
676B: B7 3B 0B    STA    $3B0B
676E: F7 3B 0A    STB    $3B0A
6771: 39          RTS
6772: 8E 00 49    LDX    #$0049
6775: 31 01       LEAY   $1,X
6777: C6 07       LDB    #$07
6779: A6 82       LDA    ,-X
677B: A7 A2       STA    ,-Y
677D: 5A          DECB
677E: 26 F9       BNE    $6779
6780: B6 30 00    LDA    $3000
6783: 43          COMA
6784: 97 42       STA    $42
6786: B6 30 01    LDA    $3001
6789: 43          COMA
678A: 97 46       STA    $46
678C: B6 30 02    LDA    $3002
678F: 43          COMA
6790: 97 48       STA    $48
6792: 39          RTS
6793: 4F          CLRA
6794: E6 02       LDB    $2,X
6796: 27 0C       BEQ    $67A4
6798: 5A          DECB
6799: E7 02       STB    $2,X
679B: C1 1E       CMPB   #$1E
679D: 26 13       BNE    $67B2
679F: 86 00       LDA    #$00
67A1: A7 C4       STA    ,U
67A3: 39          RTS
67A4: E6 84       LDB    ,X
67A6: 27 0A       BEQ    $67B2
67A8: 6A 84       DEC    ,X
67AA: 86 01       LDA    #$01
67AC: A7 C4       STA    ,U
67AE: C6 3C       LDB    #$3C
67B0: E7 02       STB    $2,X
67B2: 39          RTS
67B3: 8D 26       BSR    $67DB
67B5: 8E 15 82    LDX    #$1582
67B8: CE 3D 02    LDU    #$3D02
67BB: 8D D6       BSR    $6793
67BD: 8D 53       BSR    $6812
67BF: 30 08       LEAX   $8,X
67C1: CE 3D 03    LDU    #$3D03
67C4: 8D CD       BSR    $6793
67C6: 8D 4A       BSR    $6812
67C8: D6 E0       LDB    $E0
67CA: C1 03       CMPB   #$03
67CC: 26 0C       BNE    $67DA
67CE: DC 22       LDD    $22
67D0: C3 00 01    ADDD   #$0001
67D3: 27 05       BEQ    $67DA
67D5: DD 22       STD    $22
67D7: 7E 79 50    JMP    $7950
67DA: 39          RTS
67DB: 8E 15 82    LDX    #$1582
67DE: 5F          CLRB
67DF: E7 07       STB    $7,X
67E1: E7 0F       STB    $F,X
67E3: D7 E0       STB    $E0
67E5: D6 45       LDB    $45
67E7: 58          ASLB
67E8: 69 0F       ROL    $F,X
67EA: 58          ASLB
67EB: 69 07       ROL    $7,X
67ED: 58          ASLB
67EE: 09 E0       ROL    $E0
67F0: D6 44       LDB    $44
67F2: 58          ASLB
67F3: 69 0F       ROL    $F,X
67F5: 58          ASLB
67F6: 69 07       ROL    $7,X
67F8: 58          ASLB
67F9: 09 E0       ROL    $E0
67FB: D6 43       LDB    $43
67FD: 58          ASLB
67FE: 69 0F       ROL    $F,X
6800: 58          ASLB
6801: 69 07       ROL    $7,X
6803: 58          ASLB
6804: 09 E0       ROL    $E0
6806: D6 42       LDB    $42
6808: 58          ASLB
6809: 69 0F       ROL    $F,X
680B: 58          ASLB
680C: 69 07       ROL    $7,X
680E: 58          ASLB
680F: 09 E0       ROL    $E0
6811: 39          RTS
6812: A6 07       LDA    $7,X
6814: E6 05       LDB    $5,X
6816: 26 0B       BNE    $6823
6818: 81 03       CMPA   #$03
681A: 26 11       BNE    $682D
681C: 6C 05       INC    $5,X
681E: C6 0C       LDB    #$0C
6820: E7 06       STB    $6,X
6822: 39          RTS
6823: 81 0C       CMPA   #$0C
6825: 27 07       BEQ    $682E
6827: 6A 06       DEC    $6,X
6829: 26 02       BNE    $682D
682B: 6F 05       CLR    $5,X
682D: 39          RTS
682E: 8D 09       BSR    $6839
6830: 6F 05       CLR    $5,X
6832: 34 10       PSHS   X
6834: BD 79 50    JSR    $7950
6837: 35 90       PULS   X,PC
6839: 6C 84       INC    ,X
683B: 6C 01       INC    $1,X
683D: A6 01       LDA    $1,X
683F: A1 03       CMPA   $3,X
6841: 25 0B       BCS    $684E
6843: E6 04       LDB    $4,X
6845: 4F          CLRA
6846: D3 22       ADDD   $22
6848: 25 02       BCS    $684C
684A: DD 22       STD    $22
684C: 6F 01       CLR    $1,X
684E: 39          RTS
684F: D6 05       LDB    $05
6851: 58          ASLB
6852: 8E 68 57    LDX    #jump_table_6857
6855: 6E 95       JMP    [B,X]	; [indirect_jump]

	
685F: BD 68 DF    JSR    $68DF
6862: C6 01       LDB    #$01
6864: D7 D8       STB    $D8
6866: 4F          CLRA
6867: 97 28       STA    $28
6869: 97 2A       STA    $2A
686B: 97 2B       STA    $2B
686D: 5F          CLRB
686E: DD D4       STD    $D4
6870: DD D6       STD    $D6
6872: CC 87 CD    LDD    #$87CD
6875: FD 00 6E    STD    >$006E
6878: 0F 70       CLR    $70
687A: C6 01       LDB    #$01
687C: D7 DE       STB    $DE
687E: D7 DF       STB    $DF
6880: 0C 05       INC    $05
6882: 39          RTS
6883: 8E 20 00    LDX    #$2000
6886: 86 48       LDA    #$48
6888: C6 01       LDB    #$01
688A: E7 89 04 00 STB    $0400,X
688E: A7 80       STA    ,X+
6890: 8C 23 FF    CMPX   #$23FF
6893: 23 F5       BLS    $688A
6895: CC 00 B4    LDD    #$00B4
6898: DD 03       STD    $03
689A: 0C 05       INC    $05
689C: 39          RTS
689D: 9E 03       LDX    $03
689F: 30 1F       LEAX   -$1,X
68A1: 9F 03       STX    $03
68A3: 26 16       BNE    $68BB
68A5: 4F          CLRA
68A6: 5F          CLRB
68A7: DD DE       STD    $DE
68A9: C6 01       LDB    #$01
68AB: D7 F0       STB    $F0
68AD: CC 04 04    LDD    #$0404
68B0: BD 69 09    JSR    $6909
68B3: CC 00 00    LDD    #$0000
68B6: BD 69 09    JSR    $6909
68B9: 0C 05       INC    $05
68BB: 39          RTS
68BC: D6 F0       LDB    $F0
68BE: 26 1E       BNE    $68DE
68C0: 4F          CLRA
68C1: 5F          CLRB
68C2: DD 00       STD    $00
68C4: DD 03       STD    $03
68C6: DD 06       STD    $06
68C8: DD 09       STD    $09
68CA: DD 0C       STD    $0C
68CC: D7 05       STB    $05
68CE: D7 08       STB    $08
68D0: D7 0B       STB    $0B
68D2: D7 0E       STB    $0E
68D4: C6 03       LDB    #$03
68D6: 96 0F       LDA    $0F
68D8: 26 02       BNE    $68DC
68DA: C6 01       LDB    #$01
68DC: D7 02       STB    $02
68DE: 39          RTS
68DF: C6 18       LDB    #$18
68E1: 34 44       PSHS   U,B
68E3: CE 1F 80    LDU    #$1F80
68E6: CC F8 F8    LDD    #$F8F8
68E9: 1F 01       TFR    D,X
68EB: 31 84       LEAY   ,X
68ED: 36 36       PSHU   Y,X,D
68EF: 36 36       PSHU   Y,X,D
68F1: 36 16       PSHU   X,D
68F3: 6A E4       DEC    ,S
68F5: 26 F6       BNE    $68ED
68F7: 35 C4       PULS   B,U,PC
68F9: D6 6F       LDB    $6F
68FB: D8 6E       EORB   $6E
68FD: 53          COMB
68FE: 58          ASLB
68FF: 58          ASLB
6900: 09 6F       ROL    $6F
6902: 09 6E       ROL    $6E
6904: D6 6F       LDB    $6F
6906: D7 70       STB    $70
6908: 39          RTS
6909: 10 9E 10    LDY    $10
690C: ED A1       STD    ,Y++
690E: 10 8C 01 3F CMPY   #$013F
6912: 25 04       BCS    $6918
6914: 10 8E 01 00 LDY    #$0100
6918: 10 9F 10    STY    $10
691B: 39          RTS
691C: 96 4B       LDA    $4B
691E: 97 4C       STA    $4C
6920: D6 28       LDB    $28
6922: 27 12       BEQ    $6936
6924: D6 27       LDB    $27
6926: 27 04       BEQ    $692C
6928: D6 53       LDB    $53
692A: 26 05       BNE    $6931
692C: D6 46       LDB    $46
692E: D7 4B       STB    $4B
6930: 39          RTS
6931: D6 48       LDB    $48
6933: D7 4B       STB    $4B
6935: 39          RTS
6936: D6 4D       LDB    $4D
6938: 26 10       BNE    $694A
693A: C6 02       LDB    #$02
693C: F7 3E 00    STB    bankswitch_3e00
693F: DE 4E       LDU    $4E
6941: EC C1       LDD    ,U++
6943: 97 4B       STA    $4B
6945: D7 4D       STB    $4D
6947: DF 4E       STU    $4E
6949: 39          RTS
694A: 0A 4D       DEC    $4D
694C: 39          RTS
694D: 96 05       LDA    $05
694F: 48          ASLA
6950: 8E 69 5A    LDX    #jump_table_695a
6953: AD 96       JSR    [A,X]		; [indirect_jump]
6955: BD 69 CB    JSR    $69CB
6958: 20 0A       BRA    $6964

6964: D6 22       LDB    $22
6966: DA 23       ORB    $23
6968: DA 51       ORB    $51
696A: 27 36       BEQ    $69A2
696C: D6 43       LDB    $43
696E: 53          COMB
696F: D4 42       ANDB   $42
6971: C4 03       ANDB   #$03
6973: 27 2D       BEQ    $69A2
6975: 8D 2C       BSR    $69A3
6977: 24 29       BCC    $69A2
6979: 97 26       STA    $26
697B: 0F 27       CLR    $27
697D: 0D 51       TST    $51
697F: 26 07       BNE    $6988
6981: 1D          SEX
6982: D3 22       ADDD   $22
6984: DD 22       STD    $22
6986: DD 24       STD    $24
6988: 86 01       LDA    #$01
698A: 97 28       STA    $28
698C: 4F          CLRA
698D: 5F          CLRB
698E: DD 03       STD    $03
6990: DD 06       STD    $06
6992: DD 09       STD    $09
6994: DD 0C       STD    $0C
6996: 0F 05       CLR    $05
6998: 0F 08       CLR    $08
699A: 0F 0B       CLR    $0B
699C: 0F 0E       CLR    $0E
699E: C6 02       LDB    #$02
69A0: D7 02       STB    $02
69A2: 39          RTS
69A3: 1A 01       ORCC   #$01
69A5: 34 01       PSHS   CC
69A7: 0D 51       TST    $51
69A9: 26 04       BNE    $69AF
69AB: 9E 22       LDX    $22
69AD: 27 18       BEQ    $69C7
69AF: 30 1F       LEAX   -$1,X
69B1: 27 0A       BEQ    $69BD
69B3: C5 02       BITB   #$02
69B5: 27 06       BEQ    $69BD
69B7: C6 FE       LDB    #$FE
69B9: 86 01       LDA    #$01
69BB: 35 81       PULS   CC,PC
69BD: C5 01       BITB   #$01
69BF: 27 06       BEQ    $69C7
69C1: C6 FF       LDB    #$FF
69C3: 86 00       LDA    #$00
69C5: 35 81       PULS   CC,PC
69C7: 1C FE       ANDCC  #$FE
69C9: 35 84       PULS   B,PC
69CB: DC 22       LDD    $22
69CD: 10 93 24    CMPD   $24
69D0: 27 18       BEQ    $69EA
69D2: DD 24       STD    $24
69D4: CC 04 02    LDD    #$0402
69D7: BD 69 09    JSR    $6909
69DA: CC 05 00    LDD    #$0500
69DD: BD 69 09    JSR    $6909
69E0: C6 04       LDB    #$04
69E2: D7 05       STB    $05
69E4: 0F 08       CLR    $08
69E6: 0F 0B       CLR    $0B
69E8: 0F 0E       CLR    $0E
69EA: 39          RTS
69EB: C6 01       LDB    #$01
69ED: D7 D8       STB    $D8
69EF: 0F 28       CLR    $28
69F1: CC 87 CD    LDD    #$87CD
69F4: FD 00 6E    STD    >$006E
69F7: 0F 70       CLR    $70
69F9: 0C 05       INC    $05
69FB: 39          RTS
69FC: D6 08       LDB    $08
69FE: 58          ASLB
69FF: 8E 6A 04    LDX    #jump_table_6a04
6A02: 6E 95       JMP    [B,X]		; [indirect_jump]


	
6A08: CC 01 19    LDD    #$0119
6A0B: BD 69 09    JSR    $6909
6A0E: CC 02 06    LDD    #$0206
6A11: BD 69 09    JSR    $6909
6A14: CC 02 05    LDD    #$0205
6A17: BD 69 09    JSR    $6909
6A1A: CC 02 0A    LDD    #$020A
6A1D: BD 69 09    JSR    $6909
6A20: CC 10 00    LDD    #$1000
6A23: BD 69 09    JSR    $6909
6A26: CC 09 00    LDD    #$0900
6A29: BD 69 09    JSR    $6909
6A2C: CC 04 02    LDD    #$0402
6A2F: BD 69 09    JSR    $6909
6A32: CC 05 00    LDD    #$0500
6A35: BD 69 09    JSR    $6909
6A38: CC 00 F0    LDD    #$00F0
6A3B: DD 06       STD    $06
6A3D: 0C 08       INC    $08
6A3F: 39          RTS
6A40: 9E 06       LDX    $06
6A42: 30 1F       LEAX   -$1,X
6A44: 9F 06       STX    $06
6A46: 26 04       BNE    $6A4C
6A48: 0C 05       INC    $05
6A4A: 0F 08       CLR    $08
6A4C: 39          RTS
6A4D: D6 08       LDB    $08
6A4F: 58          ASLB
6A50: 8E 6A 55    LDX    #jump_table_6a55
6A53: 6E 95       JMP    [B,X]	; [indirect_jump]

6A5B: CC 01 15    LDD    #$0115
6A5E: BD 69 09    JSR    $6909
6A61: C6 01       LDB    #$01
6A63: D7 F0       STB    $F0
6A65: 0C 08       INC    $08
6A67: 39          RTS
6A68: D6 F0       LDB    $F0
6A6A: 26 13       BNE    $6A7F
6A6C: CC 05 00    LDD    #$0500
6A6F: BD 69 09    JSR    $6909
6A72: CC 0B 00    LDD    #$0B00
6A75: BD 69 09    JSR    $6909
6A78: CC 01 2C    LDD    #$012C
6A7B: DD 06       STD    $06
6A7D: 0C 08       INC    $08
6A7F: 39          RTS
6A80: 9E 06       LDX    $06
6A82: 30 1F       LEAX   -$1,X
6A84: 9F 06       STX    $06
6A86: 26 04       BNE    $6A8C
6A88: 0C 05       INC    $05
6A8A: 0F 08       CLR    $08
6A8C: 39          RTS
6A8D: D6 08       LDB    $08
6A8F: 58          ASLB
6A90: 8E 6A 95    LDX    #jump_table_6a95
6A93: 6E 95       JMP    [B,X]	; [indirect_jump]
 
6A9D: D6 0B       LDB    $0B
6A9F: 58          ASLB
6AA0: 8E 6A A5    LDX    #jump_table_6aa5
6AA3: 6E 95       JMP    [B,X]	; [indirect_jump]

6AAB: CC 01 1B    LDD    #$011B
6AAE: BD 69 09    JSR    $6909
6AB1: BD 6C 03    JSR    $6C03
6AB4: D6 20       LDB    $20
6AB6: C4 0C       ANDB   #$0C
6AB8: 8E 6A F0    LDX    #$6AF0
6ABB: 54          LSRB
6ABC: 30 85       LEAX   B,X
6ABE: AE 84       LDX    ,X
6AC0: 9F 4E       STX    $4E
6AC2: 8E 40 0B    LDX    #$400B
6AC5: C1 01       CMPB   #$01
6AC7: 22 0A       BHI    $6AD3
6AC9: 8E 40 00    LDX    #$4000
6ACC: 9F 6C       STX    $6C
6ACE: BD 6C 65    JSR    $6C65
6AD1: 20 17       BRA    $6AEA
6AD3: 9F 6C       STX    $6C
6AD5: BD 6C 65    JSR    $6C65
6AD8: 8E 40 0B    LDX    #$400B
6ADB: 9F 6C       STX    $6C
6ADD: 8E 05 10    LDX    #$0510
6AE0: CC 0B 80    LDD    #$0B80
6AE3: ED 16       STD    -$A,X
6AE5: CC 00 40    LDD    #$0040
6AE8: ED 19       STD    -$7,X
6AEA: BD 72 83    JSR    $7283
6AED: 0C 0B       INC    $0B
6AEF: 39          RTS

6AF8: 96 72    LDA    starting_level_0072
6AFA: 81 06    CMPA   #$06
6AFC: 27 0C       BEQ    $6B0A
6AFE: BD 80 A0    JSR    $80A0
6B01: 34 01       PSHS   CC
6B03: BD 72 83    JSR    $7283
6B06: 35 01       PULS   CC
6B08: 24 09       BCC    $6B13
6B0A: 8E 06 40    LDX    #$0640
6B0D: 5F          CLRB
6B0E: BD 8F 84    JSR    $8F84
6B11: 0C 0B       INC    $0B
6B13: 39          RTS
6B14: BD 6C 9C    JSR    $6C9C
6B17: BD 68 DF    JSR    $68DF
6B1A: CC 10 00    LDD    #$1000
6B1D: BD 69 09    JSR    $6909
6B20: CC 03 84    LDD    #$0384
6B23: DD 06       STD    $06
6B25: 0C 08       INC    $08
6B27: 0F 0B       CLR    $0B
6B29: 39          RTS
6B2A: D6 21       LDB    $21
6B2C: C5 1F       BITB   #$1F
6B2E: 26 0B       BNE    $6B3B
6B30: C4 20       ANDB   #$20
6B32: 58          ASLB
6B33: 58          ASLB
6B34: CB 2E       ADDB   #$2E
6B36: 86 02       LDA    #$02
6B38: BD 69 09    JSR    $6909
6B3B: BD 72 A1    JSR    $72A1
6B3E: 9E 06       LDX    $06
6B40: 30 1F       LEAX   -$1,X
6B42: 9F 06       STX    $06
6B44: 26 02       BNE    $6B48
6B46: 0C 08       INC    $08
6B48: 39          RTS
6B49: 5F          CLRB
6B4A: D7 08       STB    $08
6B4C: D7 0B       STB    $0B
6B4E: D7 0E       STB    $0E
6B50: 0C 05       INC    $05
6B52: DC 22       LDD    $22
6B54: 26 07       BNE    $6B5D
6B56: D6 51       LDB    $51
6B58: 26 03       BNE    $6B5D
6B5A: 5F          CLRB
6B5B: D7 05       STB    $05
6B5D: 39          RTS
6B5E: 96 08       LDA    $08
6B60: 8E 6B 66    LDX    #jump_table_6b66
6B63: 48          ASLA
6B64: 6E 96       JMP    [A,X]	; [indirect_jump]


6B6C: 0D F0       TST    $F0
6B6E: 26 15       BNE    $6B85
6B70: BD 68 DF    JSR    $68DF
6B73: 4F          CLRA
6B74: 5F          CLRB
6B75: DD D4       STD    $D4
6B77: DD D6       STD    $D6
6B79: CC 01 19    LDD    #$0119
6B7C: BD 69 09    JSR    $6909
6B7F: C6 01       LDB    #$01
6B81: D7 F0       STB    $F0
6B83: 0C 08       INC    $08
6B85: 39          RTS
6B86: 40          NEGA

6B8E: 0D F0    TST    $F0
6B90: 26 63    BNE    $6BF5
6B92: 8E 6B 86    LDX    #$6B86
6B95: D6 21       LDB    $21
6B97: C4 03       ANDB   #$03
6B99: 58          ASLB
6B9A: EC 85       LDD    B,X
6B9C: DD 6C       STD    $6C
6B9E: CC 06 00    LDD    #$0600
6BA1: BD 69 09    JSR    $6909
6BA4: C6 01       LDB    #$01
6BA6: D7 DE       STB    $DE
6BA8: BD 68 DF    JSR    $68DF
6BAB: CC 02 07    LDD    #$0207
6BAE: BD 69 09    JSR    $6909
6BB1: CC 02 05    LDD    #$0205
6BB4: BD 69 09    JSR    $6909
6BB7: CC 02 08    LDD    #$0208
6BBA: 9E 22       LDX    $22
6BBC: 30 1F       LEAX   -$1,X
6BBE: 27 01       BEQ    $6BC1
6BC0: 5C          INCB
6BC1: 0D 51       TST    $51
6BC3: 27 02       BEQ    $6BC7
6BC5: C6 09       LDB    #$09
6BC7: BD 69 09    JSR    $6909
6BCA: CC 02 0A    LDD    #$020A
6BCD: BD 69 09    JSR    $6909
6BD0: CC 10 00    LDD    #$1000
6BD3: BD 69 09    JSR    $6909
6BD6: CC 04 02    LDD    #$0402
6BD9: BD 69 09    JSR    $6909
6BDC: CC 05 00    LDD    #$0500
6BDF: BD 69 09    JSR    $6909
6BE2: CC 0A 00    LDD    #$0A00
6BE5: BD 69 09    JSR    $6909
6BE8: CC 04 09    LDD    #$0409
6BEB: BD 69 09    JSR    $6909
6BEE: CC 00 F0    LDD    #$00F0
6BF1: DD 06       STD    $06
6BF3: 0C 08       INC    $08
6BF5: 39          RTS
6BF6: 9E 06       LDX    $06
6BF8: 30 1F       LEAX   -$1,X
6BFA: 9F 06       STX    $06
6BFC: 26 04       BNE    $6C02
6BFE: 0F 05       CLR    $05
6C00: 0F 08       CLR    $08
6C02: 39          RTS
6C03: 8E 40 00    LDX    #$4000
6C06: 9F 6C       STX    $6C
6C08: C6 01       LDB    #$01
6C0A: D7 73       STB    weapon_type_0073		; set lance as weapon
6C0C: 96 57       LDA    $57
6C0E: 5F          CLRB
6C0F: DD 61       STD    $61
6C11: D7 71       STB    $71
6C13: D7 80       STB    $80
6C15: D7 72       STB    starting_level_0072
6C17: D7 7F       STB    $7F
6C19: 8D 18       BSR    $6C33
6C1B: 5F          CLRB
6C1C: D7 81       STB    $81
6C1E: D7 82       STB    $82
6C20: 8E 00 60    LDX    #$0060
6C23: CE 04 40    LDU    #$0440
6C26: 10 8E 00 18 LDY    #$0018
6C2A: EC 81       LDD    ,X++
6C2C: ED C1       STD    ,U++
6C2E: 31 3F       LEAY   -$1,Y
6C30: 26 F8       BNE    $6C2A
6C32: 39          RTS
6C33: D6 50       LDB    $50
6C35: D7 60       STB    nb_lives_0060
6C37: 0F 63       CLR    $63
6C39: 9E 55       LDX    $55
6C3B: EC 84       LDD    ,X
6C3D: DD 64       STD    $64
6C3F: EC 02       LDD    $2,X
6C41: DD 66       STD    $66
6C43: 4F          CLRA
6C44: 5F          CLRB
6C45: DD 68       STD    $68
6C47: DD 6A       STD    $6A
6C49: DD 2C       STD    $2C
6C4B: DD 2E       STD    $2E
6C4D: CC 0C 00    LDD    #$0C00
6C50: 7E 69 09    JMP    $6909
6C53: 5F          CLRB
6C54: D7 81       STB    $81
6C56: D7 82       STB    $82
6C58: 96 61       LDA    $61
6C5A: 8B 04       ADDA   #$04
6C5C: 81 3F       CMPA   #$3F
6C5E: 23 02       BLS    $6C62
6C60: 86 3F       LDA    #$3F
6C62: 97 61       STA    $61
6C64: 39          RTS
6C65: 96 61       LDA    $61
6C67: D6 28       LDB    $28
6C69: 26 01       BNE    $6C6C
6C6B: 4F          CLRA
6C6C: 5F          CLRB
6C6D: DD 9A       STD    $9A
6C6F: 4F          CLRA
6C70: DD BC       STD    $BC
6C72: 97 B5       STA    $B5
6C74: BD 6D 9C    JSR    $6D9C
6C77: BD 6E D0    JSR    $6ED0
6C7A: BD 6D 25    JSR    $6D25
6C7D: BD 6C C7    JSR    $6CC7
6C80: BD 6E 06    JSR    $6E06
6C83: BD 6E 6E    JSR    $6E6E
6C86: BD 6E F7    JSR    $6EF7
6C89: 8E 06 40    LDX    #$0640
6C8C: 5F          CLRB
6C8D: BD 8F 84    JSR    $8F84
6C90: BD 72 83    JSR    $7283
6C93: CC 07 00    LDD    #$0700
6C96: BD 69 09    JSR    $6909
6C99: 7E 68 DF    JMP    $68DF
6C9C: BD 6D 9C    JSR    $6D9C
6C9F: BD 6E D0    JSR    $6ED0
6CA2: BD 6E 06    JSR    $6E06
6CA5: BD 6E 6E    JSR    $6E6E
6CA8: 7E 68 DF    JMP    $68DF

6CCB: CE 6C AB    LDU    #$6CAB
6CCE: 31 C5       LEAY   B,U
6CD0: CE 00 58    LDU    #$0058
6CD3: 8E 00 04    LDX    #$0004
6CD6: 5F          CLRB
6CD7: A6 A0       LDA    ,Y+
6CD9: ED C1       STD    ,U++
6CDB: 30 1F       LEAX   -$1,X
6CDD: 26 F8       BNE    $6CD7
6CDF: 8E 06 40    LDX    #$0640
6CE2: 4F          CLRA
6CE3: 5F          CLRB
6CE4: ED 13       STD    -$D,X
6CE6: E7 15       STB    -$B,X
6CE8: 39          RTS

6D22: 5F          CLRB
6D23: 30 40       LEAX   $0,U
6D25: 0F AC       CLR    armour_flag_00ac
6D27: 0F 99       CLR    $99
6D29: 8E 6C E9    LDX    #$6CE9
6D2C: D6 81       LDB    $81
6D2E: 58          ASLB
6D2F: AE 85       LDX    B,X
6D31: D6 72       LDB    starting_level_0072
6D33: 58          ASLB
6D34: 58          ASLB
6D35: 3A          ABX
6D36: EC 84       LDD    ,X
6D38: DD 6C       STD    $6C
6D3A: 83 40 00    SUBD   #$4000
6D3D: DD 91       STD    $91
6D3F: E6 02       LDB    $2,X
6D41: 4F          CLRA
6D42: DD E2       STD    $E2
6D44: E6 03       LDB    $3,X
6D46: DD E4       STD    $E4
6D48: 8E 05 10    LDX    #$0510
6D4B: C6 01       LDB    #$01
6D4D: E7 10       STB    -$10,X
6D4F: E7 11       STB    -$F,X
6D51: 4F          CLRA
6D52: 5F          CLRB
6D53: ED 13       STD    -$D,X
6D55: E7 15       STB    -$B,X
6D57: 96 92       LDA    $92
6D59: 84 1F       ANDA   #$1F
6D5B: 5F          CLRB
6D5C: D3 E2       ADDD   $E2
6D5E: ED 16       STD    -$A,X
6D60: DC 91       LDD    $91
6D62: 58          ASLB
6D63: 49          ROLA
6D64: 58          ASLB
6D65: 49          ROLA
6D66: 58          ASLB
6D67: 49          ROLA
6D68: 5F          CLRB
6D69: D3 E4       ADDD   $E4
6D6B: ED 19       STD    -$7,X
6D6D: C6 03       LDB    #$03
6D6F: E7 1F       STB    -$1,X
6D71: C6 01       LDB    #$01
6D73: E7 1E       STB    -$2,X
6D75: CC 97 33    LDD    #$9733
6D78: ED 84       STD    ,X
6D7A: 6F 02       CLR    $2,X
6D7C: BD 90 74    JSR    $9074
6D7F: CC 08 00    LDD    #$0800
6D82: BD 69 09    JSR    $6909
6D85: 8E 05 30    LDX    #$0530
6D88: 10 8E 00 04 LDY    #$0004
6D8C: 4F          CLRA
6D8D: 5F          CLRB
6D8E: ED 10       STD    -$10,X
6D90: ED 13       STD    -$D,X
6D92: E7 15       STB    -$B,X
6D94: 30 88 40    LEAX   $40,X
6D97: 31 3F       LEAY   -$1,Y
6D99: 26 F3       BNE    $6D8E
6D9B: 39          RTS
6D9C: CE 14 D0    LDU    #$14D0
6D9F: C6 28       LDB    #$28
6DA1: D7 93       STB    $93
6DA3: D7 E2       STB    $E2
6DA5: 8E 08 90    LDX    #$0890
6DA8: 4F          CLRA
6DA9: 5F          CLRB
6DAA: ED 10       STD    -$10,X
6DAC: ED 12       STD    -$E,X
6DAE: ED 14       STD    -$C,X
6DB0: E7 05       STB    $5,X
6DB2: 36 10       PSHU   X
6DB4: 30 88 30    LEAX   $30,X
6DB7: 0A E2       DEC    $E2
6DB9: 26 EF       BNE    $6DAA
6DBB: DF 94       STU    $94
6DBD: CE 15 0C    LDU    #$150C
6DC0: C6 1E       LDB    #$1E
6DC2: D7 98       STB    $98
6DC4: 8E 10 10    LDX    #$1010
6DC7: 36 10       PSHU   X
6DC9: 30 88 20    LEAX   $20,X
6DCC: 5A          DECB
6DCD: 26 F8       BNE    $6DC7
6DCF: DF 96       STU    $96
6DD1: CE 15 18    LDU    #$1518
6DD4: C6 06       LDB    #$06
6DD6: D7 A7       STB    $A7
6DD8: D7 E2       STB    $E2
6DDA: 8E 13 D0    LDX    #$13D0
6DDD: 4F          CLRA
6DDE: 5F          CLRB
6DDF: ED 10       STD    -$10,X
6DE1: ED 12       STD    -$E,X
6DE3: ED 14       STD    -$C,X
6DE5: E7 05       STB    $5,X
6DE7: 36 10       PSHU   X
6DE9: 30 88 20    LEAX   $20,X
6DEC: 0A E2       DEC    $E2
6DEE: 26 EF       BNE    $6DDF
6DF0: DF A8       STU    $A8
6DF2: 39          RTS

6E06: 8E 6D F3    LDX    #$6DF3
6E09: E6 80       LDB    ,X+
6E0B: 9F B3       STX    $B3
6E0D: D7 B2       STB    $B2
6E0F: C6 06       LDB    #$06
6E11: D7 B0       STB    $B0
6E13: 8E 06 70    LDX    #$0670
6E16: 4F          CLRA
6E17: 5F          CLRB
6E18: ED 13       STD    -$D,X
6E1A: 8E 06 90    LDX    #$0690
6E1D: 10 8E 00 10 LDY    #$0010
6E21: 4F          CLRA
6E22: 5F          CLRB
6E23: E7 10       STB    -$10,X
6E25: E7 13       STB    -$D,X
6E27: E7 14       STB    -$C,X
6E29: E7 16       STB    -$A,X
6E2B: E7 17       STB    -$9,X
6E2D: E7 18       STB    -$8,X
6E2F: E7 19       STB    -$7,X
6E31: A7 05       STA    $5,X
6E33: 4C          INCA
6E34: 30 88 20    LEAX   $20,X
6E37: 31 3F       LEAY   -$1,Y
6E39: 26 E8       BNE    $6E23
6E3B: C6 02       LDB    #$02
6E3D: F7 3E 00    STB    bankswitch_3e00
6E40: CE 4B 00    LDU    #$4B00
6E43: D6 72       LDB    starting_level_0072
6E45: 58          ASLB
6E46: 58          ASLB
6E47: AE C5       LDX    B,U
6E49: E6 80       LDB    ,X+
6E4B: D7 EF       STB    $EF
6E4D: BD 8D FC    JSR    $8DFC
6E50: 25 1B       BCS    $6E6D
6E52: EC 81       LDD    ,X++
6E54: A7 25       STA    $5,Y
6E56: E7 32       STB    -$E,Y
6E58: EC 81       LDD    ,X++
6E5A: ED 36       STD    -$A,Y
6E5C: EC 81       LDD    ,X++
6E5E: ED 39       STD    -$7,Y
6E60: 4F          CLRA
6E61: 5F          CLRB
6E62: ED 33       STD    -$D,Y
6E64: E7 35       STB    -$B,Y
6E66: 4C          INCA
6E67: ED 30       STD    -$10,Y
6E69: 0A EF       DEC    $EF
6E6B: 26 E0       BNE    $6E4D
6E6D: 39          RTS
6E6E: C6 02       LDB    #$02
6E70: F7 3E 00    STB    bankswitch_3e00
6E73: CE 4B 00    LDU    #$4B00
6E76: D6 72       LDB    starting_level_0072
6E78: 58          ASLB
6E79: 58          ASLB
6E7A: 33 C5       LEAU   B,U
6E7C: AE 42       LDX    $2,U
6E7E: E6 80       LDB    ,X+
6E80: D7 EF       STB    $EF
6E82: BD 8E 15    JSR    $8E15
6E85: 25 1B       BCS    $6EA2
6E87: EC 81       LDD    ,X++
6E89: A7 25       STA    $5,Y
6E8B: E7 32       STB    -$E,Y
6E8D: EC 81       LDD    ,X++
6E8F: ED 36       STD    -$A,Y
6E91: EC 81       LDD    ,X++
6E93: ED 39       STD    -$7,Y
6E95: 4F          CLRA
6E96: 5F          CLRB
6E97: ED 33       STD    -$D,Y
6E99: E7 35       STB    -$B,Y
6E9B: 4C          INCA
6E9C: ED 30       STD    -$10,Y
6E9E: 0A EF       DEC    $EF
6EA0: 26 E0       BNE    $6E82
6EA2: 8E 15 E2    LDX    #$15E2
6EA5: 4F          CLRA
6EA6: 5F          CLRB
6EA7: ED 10       STD    -$10,X
6EA9: ED 88 20    STD    $20,X
6EAC: 39          RTS

6EE1: 8E 6E BB    LDX    #$6EBB
6EE4: EC 85       LDD    B,X
6EE6: DD AA       STD    time_00aa
6EE8: CC 0D 00    LDD    #$0D00
6EEB: BD 69 09    JSR    $6909
6EEE: 4F          CLRA
6EEF: 5F          CLRB
6EF0: D7 90       STB    $90
6EF2: D7 A4       STB    $A4
6EF4: DD A5       STD    $A5
6EF6: 39          RTS
6EF7: D6 72       LDB    starting_level_0072
6EF9: 58          ASLB
6EFA: CE 6F 15    LDU    #$6F15
6EFD: EE C5       LDU    B,U
6EFF: D6 9A       LDB    $9A
6F01: C4 30       ANDB   #$30
6F03: 33 C5       LEAU   B,U
6F05: 8E 00 30    LDX    #$0030
6F08: C6 08       LDB    #$08
6F0A: D7 E0       STB    $E0
6F0C: EC C1       LDD    ,U++
6F0E: ED 81       STD    ,X++
6F10: 0A E0       DEC    $E0
6F12: 26 F8       BNE    $6F0C
6F14: 39          RTS

70E3: C6 03       LDB    #$03
70E5: F7 3E 00    STB    $3E00
70E8: 96 05       LDA    $05
70EA: 48          ASLA
70EB: 8E 70 F1    LDX    #jump_table_70f1
70EE: AD 96       JSR    [A,X]	; [indirect_jump]
70F0: 39          RTS



70FB: D6 F0       LDB    $F0
70FD: 26 15       BNE    $7114
70FF: C6 01       LDB    #$01
7101: D7 F0       STB    $F0
7103: CC 04 04    LDD    #$0404
7106: BD 69 09    JSR    $6909
7109: CC 00 00    LDD    #$0000
710C: BD 69 09    JSR    $6909
710F: BD 6C 03    JSR    $6C03
7112: 0C 05       INC    $05
7114: 39          RTS
7115: D6 08       LDB    $08
7117: 58          ASLB
7118: 8E 71 1D    LDX    #jump_table_711d
711B: 6E 95       JMP    [B,X]	; [indirect_jump]


7125: 8E 71 47    LDX    #jump_table_7147                                  
7128: D6 71       LDB    $71
712A: 27 08       BEQ    $7134
712C: D6 72       LDB    starting_level_0072
712E: 58          ASLB

712F: 8E 71 39    LDX    #table_of_jump_tables_7139
7132: AE 85       LDX    B,X
7134: D6 0B       LDB    $0B
7136: 58          ASLB
7137: 6E 95       JMP    [B,X]	; [special_indirect_jump]

table_of_jump_tables_7139:
	.word	jump_table_714b     ; 7139
	.word	jump_table_714b 	   ; 713b
	.word	jump_table_714b 	   ; 713d
	.word	jump_table_714b     ; 713f
	.word	jump_table_714b 	   ; 7141
	.word	jump_table_714b 	   ; 7143
	.word	jump_table_7151 	   ; 7145
	
jump_table_7147:
	.word	$7159	   ; 7147
	.word	$7180	   ; 7149

jump_table_714b:
	.word	$7197    ; 714b
	.word	$71ac    ; 714d
	.word	$71c7    ; 714f
jump_table_7151:
	.word	$7197    ; 7151
	.word	$71ac    ; 7153
	.word	$71fa    ; 7155
	.word	$732a    ; 7157


7159: BD 7A 39    JSR    $7A39
715C: CC 01 1A    LDD    #$011A
715F: BD 69 09    JSR    $6909
7162: CC 0E 00    LDD    #$0E00
7165: BD 69 09    JSR    $6909
7168: BD 68 DF    JSR    $68DF
716B: 8E 05 10    LDX    #$0510
716E: 4F          CLRA
716F: 5F          CLRB
7170: ED 13       STD    -$D,X
7172: E7 15       STB    -$B,X
7174: FD 05 33    STD    $0533
7177: FD 15 B5    STD    $15B5
717A: FD 08 83    STD    $0883
717D: 0C 0B       INC    $0B
717F: 39          RTS

7180: BD 7A 6B    JSR    $7A6B
7183: D6 71       LDB    $71
7185: 27 0F       BEQ    $7196
7187: 4F          CLRA
7188: 5F          CLRB
7189: FD 15 B5    STD    $15B5
718C: FD 08 83    STD    $0883
718F: 0C 08       INC    $08
7191: 5F          CLRB
7192: D7 0B       STB    $0B
7194: D7 0E       STB    $0E
7196: 39          RTS
7197: BD 7A 24    JSR    $7A24
719A: CC 01 2C    LDD    #$012C
719D: DD 09       STD    $09
719F: CC 01 1A    LDD    #$011A
71A2: BD 69 09    JSR    $6909
71A5: C6 01       LDB    #$01
71A7: D7 F0       STB    $F0
71A9: 0C 0B       INC    $0B
71AB: 39          RTS
71AC: D6 F0       LDB    $F0
71AE: 26 16       BNE    $71C6
71B0: C6 01       LDB    #$01
71B2: D7 F0       STB    $F0
71B4: CC 0E 00    LDD    #$0E00
71B7: BD 69 09    JSR    $6909
71BA: BD 68 DF    JSR    $68DF
71BD: 0F 80       CLR    $80
71BF: 4F          CLRA
71C0: 5F          CLRB
71C1: FD 15 95    STD    $1595
71C4: 0C 0B       INC    $0B
71C6: 39          RTS
71C7: 96 21       LDA    $21
71C9: 85 1F       BITA   #$1F
71CB: 26 0F       BNE    $71DC
71CD: C6 23       LDB    #$23
71CF: 85 20       BITA   #$20
71D1: 26 02       BNE    $71D5
71D3: C6 A3       LDB    #$A3
71D5: 86 02       LDA    #$02
71D7: DB 27       ADDB   $27
71D9: BD 69 09    JSR    $6909
71DC: 9E 09       LDX    $09
71DE: 30 1F       LEAX   -$1,X
71E0: 9F 09       STX    $09
71E2: 26 0C       BNE    $71F0
71E4: CC 03 23    LDD    #$0323
71E7: DB 27       ADDB   $27
71E9: BD 69 09    JSR    $6909
71EC: 0C 08       INC    $08
71EE: 0F 0B       CLR    $0B
71F0: 8E 15 A2    LDX    #$15A2
71F3: D6 80       LDB    $80
71F5: 10 27 F1 9D LBEQ   $6396
71F9: 39          RTS
71FA: 96 21       LDA    $21
71FC: 85 1F       BITA   #$1F
71FE: 26 0F       BNE    $720F
7200: C6 23       LDB    #$23
7202: 85 20       BITA   #$20
7204: 26 02       BNE    $7208
7206: C6 A3       LDB    #$A3
7208: 86 02       LDA    #$02
720A: DB 27       ADDB   $27
720C: BD 69 09    JSR    $6909
720F: 9E 09       LDX    $09
7211: 30 1F       LEAX   -$1,X
7213: 9F 09       STX    $09
7215: 26 0A       BNE    $7221
7217: CC 03 23    LDD    #$0323
721A: DB 27       ADDB   $27
721C: BD 69 09    JSR    $6909
721F: 0C 0B       INC    $0B
7221: 8E 15 A2    LDX    #$15A2
7224: D6 80       LDB    $80
7226: 10 27 F1 6C LBEQ   $6396
722A: 8E 05 10    LDX    #$0510
722D: 4F          CLRA
722E: 5F          CLRB
722F: ED 13       STD    -$D,X
7231: E7 15       STB    -$B,X
7233: FD 15 B5    STD    $15B5
7236: FD 08 83    STD    $0883
7239: 39          RTS
723A: D6 71       LDB    $71
723C: C1 02       CMPB   #$02
723E: 10 26 0B 89 LBNE   $7DCB
7242: 7E 71 87    JMP    $7187
7245: D6 0B       LDB    $0B
7247: 58          ASLB
7248: 8E 72 4D    LDX    #jump_table_724d
724B: 6E 95       JMP    [B,X]	; [indirect_jump]

7251: D6 0E       LDB    $0E                                         
7253: 58          ASLB                                               
7254: CE 72 59    LDU    #jump_table_7259
7257: 6E D5       JMP    [B,U]	; [indirect_jump]


725F: CC 04 04    LDD    #$0404                                     
7262: BD 69 09    JSR    $6909
7265: BD 6C 65    JSR    $6C65
7268: BD 72 83    JSR    $7283
726B: 0C 0E       INC    $0E
726D: 39          RTS
726E: BD 80 A0    JSR    $80A0
7271: 34 01       PSHS   CC
7273: 8D 0E       BSR    $7283
7275: 35 01       PULS   CC
7277: 24 09       BCC    $7282
7279: 8E 06 40    LDX    #$0640
727C: 5F          CLRB
727D: BD 8F 84    JSR    $8F84
7280: 0C 0E       INC    $0E
7282: 39          RTS
7283: CE 16 B2    LDU    #$16B2
7286: 4F          CLRA
7287: 5F          CLRB
7288: D7 DE       STB    $DE
728A: 1F 02       TFR    D,Y
728C: 8E 00 20    LDX    #$0020
728F: 36 26       PSHU   Y,D
7291: 30 1F       LEAX   -$1,X
7293: 26 FA       BNE    $728F
7295: 39          RTS
7296: BD 6C 9C    JSR    $6C9C
7299: BD 68 DF    JSR    $68DF
729C: 0C 0B       INC    $0B
729E: 0F 0E       CLR    $0E
72A0: 39          RTS
72A1: BD 69 1C    JSR    $691C
72A4: BD 80 0A    JSR    $800A
72A7: BD EF 17    JSR    $EF17
72AA: BD E9 50    JSR    $E950
72AD: BD F7 96    JSR    $F796
72B0: D6 90       LDB    $90
72B2: 27 0A       BEQ    $72BE
72B4: 8D 09       BSR    $72BF
72B6: C6 03       LDB    #$03
72B8: D7 08       STB    $08
72BA: 0F 0B       CLR    $0B
72BC: 0F 0E       CLR    $0E
72BE: 39          RTS
72BF: 96 61       LDA    $61
72C1: 91 57       CMPA   $57
72C3: 23 01       BLS    $72C6
72C5: 4A          DECA
72C6: 97 61       STA    $61
72C8: 39          RTS
72C9: D6 72       LDB    starting_level_0072
72CB: C1 05       CMPB   #$05
72CD: 10 22 00 9C LBHI   $736D
72D1: 25 06       BCS    $72D9
72D3: D6 73       LDB    weapon_type_0073
72D5: C1 03       CMPB   #$03
72D7: 26 3C       BNE    $7315
72D9: C6 04       LDB    #$04
72DB: F7 3E 00    STB    bankswitch_3e00
72DE: BD F7 62    JSR    $F762
72E1: BD 75 57    JSR    $7557
72E4: 8E 05 10    LDX    #$0510
72E7: BD 74 4F    JSR    $744F
72EA: BD 80 21    JSR    $8021
72ED: C6 04       LDB    #$04
72EF: F7 3E 00    STB    bankswitch_3e00
72F2: BD E2 B4    JSR    $E2B4
72F5: BD F7 88    JSR    $F788
72F8: BD F8 11    JSR    $F811
72FB: 8E 05 10    LDX    #$0510
72FE: BD F8 3D    JSR    $F83D
7301: 8E 05 40    LDX    #$0540
7304: BD F8 3D    JSR    $F83D
7307: BD F7 B3    JSR    $F7B3
730A: D6 90       LDB    $90
730C: 27 06       BEQ    $7314
730E: 0F 0B       CLR    $0B
7310: 0F 0E       CLR    $0E
7312: 0C 08       INC    $08
7314: 39          RTS
7315: D6 0B       LDB    $0B
7317: 58          ASLB
7318: CE 73 1D    LDU    #jump_table_731d
731B: 6E D5       JMP    [B,U]	; [indirect_jump]

7321: CC 0E 00    LDD    #$0E00
7324: BD 69 09    JSR    $6909
7327: BD 68 DF    JSR    $68DF
732A: CC 02 32    LDD    #$0232
732D: BD 69 09    JSR    $6909
7330: 8E 21 F9    LDX    #$21F9
7333: CE 73 56    LDU    #$7356
7336: CC 06 06    LDD    #$0606
7339: 10 AE C1    LDY    ,U++
733C: 10 AF 84    STY    ,X
733F: ED 89 04 00 STD    $0400,X
7343: 10 AE C4    LDY    ,U
7346: 10 AF 88 20 STY    $20,X
734A: ED 89 04 20 STD    $0420,X
734E: CC 00 F0    LDD    #$00F0
7351: DD 09       STD    $09
7353: 0C 0B       INC    $0B
7355: 39          RTS
7356: 86 87       LDA    #$87
7358: 96 97       LDA    $97
735A: 9E 09       LDX    $09
735C: 30 1F       LEAX   -$1,X
735E: 9F 09       STX    $09
7360: 26 0A       BNE    $736C
7362: C6 04       LDB    #$04
7364: D7 72       STB    starting_level_0072
7366: 0F 08       CLR    $08
7368: 0F 0B       CLR    $0B
736A: 0F 0E       CLR    $0E
736C: 39          RTS
736D: D6 7F       LDB    $7F
736F: 26 10       BNE    $7381
7371: D6 71       LDB    $71
7373: 5A          DECB
7374: 10 26 00 86 LBNE   $73FE
7378: 0F 72       CLR    starting_level_0072
737A: 0F 08       CLR    $08
737C: 0F 0B       CLR    $0B
737E: 0F 0E       CLR    $0E
7380: 39          RTS
7381: D6 7F       LDB    $7F
7383: C1 02       CMPB   #$02
7385: 10 26 0B 53 LBNE   $7EDC
7389: D6 0B       LDB    $0B
738B: 58          ASLB
738C: CE 73 91    LDU    #jump_table_7391
738F: 6E D5       JMP    [B,U]	; [indirect_jump]

7399: CC 02 2D    LDD    #$022D                                    
739C: BD 69 09    JSR    $6909                                     
739F: CC 0C 15    LDD    #$0C15
73A2: BD 69 09    JSR    $6909
73A5: CC 02 1C    LDD    #$021C
73A8: DD 09       STD    $09
73AA: 0C 0B       INC    $0B
73AC: 9E 09       LDX    $09
73AE: 30 1F       LEAX   -$1,X
73B0: 9F 09       STX    $09
73B2: 26 49       BNE    $73FD
73B4: CC 01 1A    LDD    #$011A
73B7: BD 69 09    JSR    $6909
73BA: CC 02 2F    LDD    #$022F
73BD: BD 69 09    JSR    $6909
73C0: CC 01 A4    LDD    #$01A4
73C3: DD 09       STD    $09
73C5: 0C 0B       INC    $0B
73C7: 9E 09       LDX    $09
73C9: 30 1F       LEAX   -$1,X
73CB: 9F 09       STX    $09
73CD: 26 2E       BNE    $73FD
73CF: CC 0E 00    LDD    #$0E00
73D2: BD 69 09    JSR    $6909
73D5: CC 01 1A    LDD    #$011A
73D8: BD 69 09    JSR    $6909
73DB: BD 68 DF    JSR    $68DF
73DE: CC 02 30    LDD    #$0230
73E1: BD 69 09    JSR    $6909
73E4: CC 00 B4    LDD    #$00B4
73E7: DD 09       STD    $09
73E9: 0C 0B       INC    $0B
73EB: 9E 09       LDX    $09
73ED: 30 1F       LEAX   -$1,X
73EF: 9F 09       STX    $09
73F1: 26 0A       BNE    $73FD
73F3: C6 01       LDB    #$01
73F5: D7 DE       STB    $DE
73F7: 0F 71       CLR    $71
73F9: 0F 7F       CLR    $7F
73FB: 20 49       BRA    $7446
73FD: 39          RTS
73FE: BD F7 88    JSR    $F788
7401: 8E 15 C2    LDX    #$15C2
7404: BD F8 3D    JSR    $F83D
7407: 8E 05 10    LDX    #$0510
740A: BD F8 3D    JSR    $F83D
740D: BD F7 B3    JSR    $F7B3
7410: D6 0B       LDB    $0B
7412: 58          ASLB
7413: CE 74 18    LDU    #jump_table_7418
7416: 6E D5       JMP    [B,U]        ; [indirect_jump]

741C: CC 0E 00    LDD    #$0E00
741F: BD 69 09    JSR    $6909
7422: 8E 15 C2    LDX    #$15C2
7425: 4F          CLRA
7426: 5F          CLRB
7427: ED 13       STD    -$D,X
7429: ED 10       STD    -$10,X
742B: CC 01 2C    LDD    #$012C
742E: DD 09       STD    $09
7430: CC 02 2C    LDD    #$022C
7433: BD 69 09    JSR    $6909
7436: 0C 0B       INC    $0B
7438: DE 09       LDU    $09
743A: 33 5F       LEAU   -$1,U
743C: DF 09       STU    $09
743E: 26 0E       BNE    $744E
7440: C6 01       LDB    #$01
7442: D7 7F       STB    $7F
7444: D7 71       STB    $71
7446: 0F 72       CLR    starting_level_0072
7448: 0F 08       CLR    $08
744A: 0F 0B       CLR    $0B
744C: 0F 0E       CLR    $0E
744E: 39          RTS
744F: D6 0B       LDB    $0B
7451: 58          ASLB
7452: CE 74 57    LDU    #jump_table_7457
7455: 6E D5       JMP    [B,U]        ; [indirect_jump]

7465: CC 02 27    LDD    #$0227
7468: BD 69 09    JSR    $6909
746B: 7F 05 53    CLR    $0553
746E: 7F 05 55    CLR    $0555
7471: 0C 0B       INC    $0B
7473: 7E ED 2A    JMP    $ED2A
7476: BD 69 1C    JSR    $691C
7479: BD 90 AB    JSR    $90AB
747C: D6 72       LDB    starting_level_0072
747E: C1 04       CMPB   #$04
7480: 24 1C       BCC    $749E
7482: DC 5A       LDD    $5A
7484: 83 00 30    SUBD   #$0030
7487: 10 A3 16    CMPD   -$A,X
748A: 10 22 78 9C LBHI   $ED2A
748E: C3 00 55    ADDD   #$0055
7491: ED 88 11    STD    $11,X
7494: C6 01       LDB    #$01
7496: F7 05 53    STB    $0553
7499: 0C 0B       INC    $0B
749B: 7E ED 2A    JMP    $ED2A
749E: DC 5C       LDD    $5C
74A0: C3 00 20    ADDD   #$0020
74A3: 10 A3 19    CMPD   -$7,X
74A6: 10 22 78 80 LBHI   $ED2A
74AA: DC 5A       LDD    $5A
74AC: 83 00 30    SUBD   #$0030
74AF: 20 DD       BRA    $748E
74B1: BD 69 1C    JSR    $691C
74B4: BD 90 AB    JSR    $90AB
74B7: E6 13       LDB    -$D,X
74B9: C1 02       CMPB   #$02
74BB: 10 27 78 6B LBEQ   $ED2A
74BF: EC 16       LDD    -$A,X
74C1: A3 88 11    SUBD   $11,X
74C4: C3 00 08    ADDD   #$0008
74C7: 10 83 00 10 CMPD   #$0010
74CB: 10 22 78 5B LBHI   $ED2A
74CF: EC 19       LDD    -$7,X
74D1: B3 05 50    SUBD   $0550
74D4: C3 00 08    ADDD   #$0008
74D7: 10 83 00 10 CMPD   #$0010
74DB: 10 22 78 4B LBHI   $ED2A
74DF: CC 0C 09    LDD    #$0C09
74E2: BD 69 09    JSR    $6909
74E5: F7 05 55    STB    $0555
74E8: 0C 0B       INC    $0B
74EA: 39          RTS
74EB: C6 01       LDB    #$01
74ED: E7 1E       STB    -$2,X
74EF: C6 32       LDB    #$32
74F1: E7 88 10    STB    $10,X
74F4: BD 9A 2F    JSR    $9A2F
74F7: 0C 0B       INC    $0B
74F9: 39          RTS
74FA: 6A 88 10    DEC    $10,X
74FD: 27 09       BEQ    $7508
74FF: CE 95 53    LDU    #$9553
7502: BD 94 77    JSR    $9477
7505: 7E 90 74    JMP    $9074
7508: BD 7A 66    JSR    $7A66
750B: BD 7A 52    JSR    $7A52
750E: C6 01       LDB    #$01
7510: F7 15 B4    STB    $15B4
7513: CC 75 1E    LDD    #$751E
7516: ED 84       STD    ,X
7518: ED 03       STD    $3,X
751A: C6 3C       LDB    #$3C
751C: 20 11       BRA    $752F

7523: 6A 88 10    DEC    $10,X
7526: 26 0C       BNE    $7534
7528: 0F AC       CLR    armour_flag_00ac
752A: BD 9A 2F    JSR    $9A2F
752D: C6 46       LDB    #$46
752F: E7 88 10    STB    $10,X
7532: 0C 0B       INC    $0B
7534: 39          RTS
7535: 6A 88 10    DEC    $10,X
7538: 27 09       BEQ    $7543
753A: CE 95 53    LDU    #$9553
753D: BD 94 77    JSR    $9477
7540: 7E 90 74    JMP    $9074
7543: D6 72       LDB    starting_level_0072
7545: 5C          INCB
7546: C1 07       CMPB   #$07
7548: 25 01       BCS    $754B
754A: 5F          CLRB
754B: D7 72       STB    starting_level_0072
754D: BD 6C 53    JSR    $6C53
7550: 0F 08       CLR    $08
7552: 0F 0B       CLR    $0B
7554: 0F 0E       CLR    $0E
7556: 39          RTS
7557: D6 0E       LDB    $0E
7559: 58          ASLB
755A: CE 75 5F    LDU    #jump_table_755f
755D: 6E D5       JMP    [B,U]        ; [indirect_jump]
755F: 75 6B 75    LSR    $6B75
7562: 7A 76 25    DEC    $7625
7565: 76 48 76    ROR    $4876
7568: B5 77 03    BITA   $7703
756B: 8E 05 40    LDX    #$0540
756E: 4F          CLRA
756F: 5F          CLRB
7570: ED 13       STD    -$D,X
7572: CC 01 00    LDD    #$0100
7575: ED 10       STD    -$10,X
7577: 0C 0E       INC    $0E
7579: 39          RTS
757A: 8E 05 40    LDX    #$0540
757D: E6 88 15    LDB    $15,X
7580: 10 26 00 98 LBNE   $761C
7584: E6 13       LDB    -$D,X
7586: 58          ASLB
7587: CE 75 8C    LDU    #jump_table_758c
758A: 6E D5       JMP    [B,U]        ; [indirect_jump]
758C: 75 94 75    LSR    $9475
758F: E5 75       BITB   -$B,S
7591: F8 76 16    EORB   $7616
7594: E6 88 13    LDB    $13,X
7597: 27 E0       BEQ    $7579
7599: DC 5A       LDD    $5A
759B: C3 00 25    ADDD   #$0025
759E: ED 16       STD    -$A,X
75A0: CC 01 01    LDD    #$0101
75A3: ED 10       STD    -$10,X
75A5: C6 00       LDB    #$00
75A7: E7 1F       STB    -$1,X
75A9: D6 72       LDB    starting_level_0072
75AB: 58          ASLB
75AC: CE 75 C0    LDU    #$75C0
75AF: EC C5       LDD    B,U
75B1: ED 19       STD    -$7,X
75B3: BD 7A 61    JSR    $7A61
75B6: C6 1E       LDB    #$1E
75B8: E7 88 16    STB    $16,X
75BB: CC 75 CC    LDD    #$75CC
75BE: 20 2D       BRA    $75ED

75E5: 6A 88 16    DEC    $16,X
75E8: 26 2C       BNE    $7616
75EA: CC 75 DA    LDD    #$75DA
75ED: ED 84       STD    ,X
75EF: ED 03       STD    $3,X
75F1: 6F 02       CLR    $2,X
75F3: 6C 13       INC    -$D,X
75F5: 7E 8E 41    JMP    $8E41
75F8: CE 76 23    LDU    #$7623
75FB: BD 93 7B    JSR    $937B
75FE: BD 90 74    JSR    $9074
7601: BD 8C A7    JSR    $8CA7
7604: 24 10       BCC    $7616
7606: 4F          CLRA
7607: E3 19       ADDD   -$7,X
7609: ED 19       STD    -$7,X
760B: C3 00 08    ADDD   #$0008
760E: ED 88 10    STD    $10,X
7611: 6C 13       INC    -$D,X
7613: 7E 8E 41    JMP    $8E41
7616: BD 90 74    JSR    $9074
7619: 7E 8E 41    JMP    $8E41
761C: 4F          CLRA
761D: 5F          CLRB
761E: ED 10       STD    -$10,X
7620: 0C 0E       INC    $0E
7622: 39          RTS

7625: D6 72       LDB    starting_level_0072
7627: CE 76 3C    LDU    #$763C
762A: 58          ASLB
762B: EC C5       LDD    B,U
762D: 8E 15 A2    LDX    #$15A2
7630: ED 84       STD    ,X
7632: 4F          CLRA
7633: 5F          CLRB
7634: ED 13       STD    -$D,X
7636: ED 88 12    STD    $12,X
7639: 0C 0E       INC    $0E
763B: 39          RTS
763C: 2B 2D       BMI    $766B
763E: 2B 2C       BMI    $766C
7640: 2B 2C       BMI    $766E
7642: 2B 2C       BMI    $7670
7644: 29 2C       BVS    $7672
7646: 29 2C       BVS    $7674
7648: 8E 15 A2    LDX    #$15A2
764B: E6 88 12    LDB    $12,X
764E: 27 64       BEQ    $76B4
7650: E6 88 13    LDB    $13,X
7653: 27 05       BEQ    $765A
7655: 6A 88 13    DEC    $13,X
7658: 26 5A       BNE    $76B4
765A: 10 8E 77 4C LDY    #$774C
765E: E6 88 12    LDB    $12,X
7661: 58          ASLB
7662: 10 AE A5    LDY    B,Y
7665: A6 A4       LDA    ,Y
7667: E6 A0       LDB    ,Y+
7669: DD E4       STD    $E4
766B: D6 72       LDB    starting_level_0072
766D: 26 0C       BNE    $767B
766F: CE 77 52    LDU    #$7752
7672: E6 88 12    LDB    $12,X
7675: A6 C5       LDA    B,U
7677: E6 C5       LDB    B,U
7679: DD E4       STD    $E4
767B: C6 03       LDB    #$03
767D: D7 E2       STB    $E2
767F: EE 84       LDU    ,X
7681: 33 5C       LEAU   -$4,U
7683: EC A1       LDD    ,Y++
7685: ED C4       STD    ,U
7687: EC A1       LDD    ,Y++
7689: ED 42       STD    $2,U
768B: DC E4       LDD    $E4
768D: ED C9 04 00 STD    $0400,U
7691: ED C9 04 02 STD    $0402,U
7695: 33 C8 20    LEAU   $20,U
7698: 0A E2       DEC    $E2
769A: 26 E7       BNE    $7683
769C: C6 32       LDB    #$32
769E: E7 88 13    STB    $13,X
76A1: 6C 88 12    INC    $12,X
76A4: E6 88 12    LDB    $12,X
76A7: C1 03       CMPB   #$03
76A9: 25 09       BCS    $76B4
76AB: 0C 0E       INC    $0E
76AD: 6F 88 12    CLR    $12,X
76B0: C6 28       LDB    #$28
76B2: D7 0C       STB    $0C
76B4: 39          RTS
76B5: 0A 0C       DEC    $0C
76B7: 26 4A       BNE    $7703
76B9: C6 05       LDB    #$05
76BB: D7 E3       STB    $E3
76BD: D6 72       LDB    starting_level_0072
76BF: C1 04       CMPB   #$04
76C1: 25 05       BCS    $76C8
76C3: 8E 21 B2    LDX    #$21B2
76C6: 20 03       BRA    $76CB
76C8: 8E 22 92    LDX    #$2292
76CB: CE 77 04    LDU    #$7704
76CE: D6 72       LDB    starting_level_0072
76D0: 86 0A       LDA    #$0A
76D2: 3D          MUL
76D3: 33 CB       LEAU   D,U
76D5: A7 89 04 00 STA    $0400,X
76D9: E6 C0       LDB    ,U+
76DB: E7 80       STB    ,X+
76DD: 0A E3       DEC    $E3
76DF: 26 F4       BNE    $76D5
76E1: C6 05       LDB    #$05
76E3: D7 E3       STB    $E3
76E5: 30 88 3B    LEAX   $3B,X
76E8: A7 89 04 00 STA    $0400,X
76EC: E6 C0       LDB    ,U+
76EE: E7 80       STB    ,X+
76F0: 0A E3       DEC    $E3
76F2: 26 F4       BNE    $76E8
76F4: D6 72       LDB    starting_level_0072
76F6: CE 77 40    LDU    #$7740
76F9: 58          ASLB
76FA: 33 C5       LEAU   B,U
76FC: EC C4       LDD    ,U
76FE: BD 69 09    JSR    $6909
7701: 0C 0E       INC    $0E
7703: 39          RTS

777C: D6 0B       LDB    $0B
777E: 58          ASLB
777F: 8E 77 84    LDX    #jump_table_7784
7782: 6E 95       JMP    [B,X]        ; [indirect_jump]

778A: D6 0E       LDB    $0E
778C: 58          ASLB
778D: 8E 77 92    LDX    #$7792
7790: 6E 95       JMP    [B,X]        ; [indirect_jump]
7792: 77 96 77    ASR    $9677
7795: 9D CC       JSR    $CC
7797: 00 78       NEG    $78
7799: DD 0C       STD    $0C
779B: 0C 0E       INC    $0E
779D: 9E 0C       LDX    $0C
779F: 30 1F       LEAX   -$1,X
77A1: 9F 0C       STX    $0C
77A3: 26 1A       BNE    $77BF
77A5: 0F 0E       CLR    $0E
77A7: 0A 60       DEC    nb_lives_0060
77A9: 26 10       BNE    $77BB
77AB: CC 02 0B    LDD    #$020B
77AE: DB 27       ADDB   $27
77B0: BD 69 09    JSR    $6909
77B3: CC 00 F0    LDD    #$00F0
77B6: DD 09       STD    $09
77B8: 0C 0B       INC    $0B
77BA: 39          RTS
77BB: C6 02       LDB    #$02
77BD: D7 0B       STB    $0B
77BF: 39          RTS
77C0: 9E 09       LDX    $09
77C2: 30 1F       LEAX   -$1,X
77C4: 9F 09       STX    $09
77C6: 26 03       BNE    $77CB
77C8: 0C 0B       INC    $0B
77CA: 39          RTS
77CB: 39          RTS
77CC: 5F          CLRB
77CD: D7 08       STB    $08
77CF: D7 0B       STB    $0B
77D1: D7 0E       STB    $0E
77D3: D6 60       LDB    nb_lives_0060
77D5: 27 10       BEQ    $77E7
77D7: D6 26       LDB    $26
77D9: 27 07       BEQ    $77E2
77DB: F6 04 40    LDB    $0440
77DE: 27 02       BEQ    $77E2
77E0: 8D 0A       BSR    $77EC
77E2: C6 01       LDB    #$01
77E4: D7 05       STB    $05
77E6: 39          RTS
77E7: C6 02       LDB    #$02
77E9: D7 05       STB    $05
77EB: 39          RTS
77EC: D6 27       LDB    $27
77EE: C8 01       EORB   #$01
77F0: D7 27       STB    $27
77F2: D6 53       LDB    $53
77F4: 27 06       BEQ    $77FC
77F6: D6 D8       LDB    $D8
77F8: C8 01       EORB   #$01
77FA: D7 D8       STB    $D8
77FC: 8E 00 60    LDX    #$0060
77FF: CE 04 40    LDU    #$0440
7802: 10 8E 00 30 LDY    #$0030
7806: A6 84       LDA    ,X
7808: E6 C4       LDB    ,U
780A: A7 C0       STA    ,U+
780C: E7 80       STB    ,X+
780E: 31 3F       LEAY   -$1,Y
7810: 26 F4       BNE    $7806
7812: 39          RTS
7813: D6 08       LDB    $08
7815: 58          ASLB
7816: CE 78 1B    LDU    #jump_table_781b
7819: 6E D5       JMP    [B,U]        ; [indirect_jump]

7821: D6 0B       LDB    $0B
7823: 58          ASLB
7824: CE 78 29    LDU    #$7829
7827: 6E D5       JMP    [B,U]        ; [indirect_jump]

7833: D6 F0       LDB    $F0
7835: 26 02       BNE    $7839
7837: 0C 0B       INC    $0B
7839: 39          RTS
783A: BD 68 DF    JSR    $68DF
783D: BD 79 46    JSR    $7946
7840: BD 7A 66    JSR    $7A66
7843: C6 01       LDB    #$01
7845: D7 F0       STB    $F0
7847: CC 01 1A    LDD    #$011A
784A: BD 69 09    JSR    $6909
784D: 0C 0B       INC    $0B
784F: 39          RTS
7850: C6 01       LDB    #$01
7852: D7 F0       STB    $F0
7854: CC 0E 00    LDD    #$0E00
7857: BD 69 09    JSR    $6909
785A: 0C 0B       INC    $0B
785C: 39          RTS
785D: CC 02 25    LDD    #$0225
7860: BD 69 09    JSR    $6909
7863: C6 10       LDB    #$10
7865: D7 0A       STB    $0A
7867: 0C 08       INC    $08
7869: 0F 0B       CLR    $0B
786B: 39          RTS
786C: 53          COMB
786D: 34 01       PSHS   CC
786F: D6 51       LDB    $51
7871: 26 04       BNE    $7877
7873: 9E 22       LDX    $22
7875: 27 08       BEQ    $787F
7877: D6 42       LDB    $42
7879: C5 03       BITB   #$03
787B: 27 02       BEQ    $787F
787D: 35 81       PULS   CC,PC
787F: 4F          CLRA
7880: 35 84       PULS   B,PC
7882: D6 46       LDB    $46
7884: DA 48       ORB    $48
7886: C5 30       BITB   #$30
7888: 27 16       BEQ    $78A0
788A: 8D E0       BSR    $786C
788C: 24 12       BCC    $78A0
788E: 9E 22       LDX    $22
7890: 30 1F       LEAX   -$1,X
7892: 9F 22       STX    $22
7894: BD 6C 33    JSR    $6C33
7897: C6 02       LDB    #$02
7899: D7 08       STB    $08
789B: 5F          CLRB
789C: D7 0B       STB    $0B
789E: D7 0E       STB    $0E
78A0: 39          RTS
78A1: 8D DF       BSR    $7882
78A3: 8D 01       BSR    $78A6
78A5: 39          RTS
78A6: D6 21       LDB    $21
78A8: C5 3F       BITB   #$3F
78AA: 26 20       BNE    $78CC
78AC: 96 0A       LDA    $0A
78AE: 8B 99       ADDA   #$99
78B0: 19          DAA
78B1: 97 0A       STA    $0A
78B3: 8E 21 EF    LDX    #$21EF
78B6: 10 8E 00 0A LDY    #$000A
78BA: C6 03       LDB    #$03
78BC: BD 50 51    JSR    $5051		; [bank_3]
78BF: D6 0A       LDB    $0A
78C1: 26 09       BNE    $78CC
78C3: C6 02       LDB    #$02
78C5: D7 08       STB    $08
78C7: 5F          CLRB
78C8: D7 0B       STB    $0B
78CA: D7 0E       STB    $0E
78CC: 39          RTS
78CD: D6 0B       LDB    $0B
78CF: 58          ASLB
78D0: CE 78 D5    LDU    #jump_table_78d5
78D3: 6E D5       JMP    [B,U]        ; [indirect_jump]

78DB: C6 01       LDB    #$01
78DD: D7 F0       STB    $F0
78DF: CC 01 1A    LDD    #$011A
78E2: BD 69 09    JSR    $6909
78E5: 0C 0B       INC    $0B
78E7: 39          RTS
78E8: C6 01       LDB    #$01
78EA: D7 F0       STB    $F0
78EC: CC 0E 00    LDD    #$0E00
78EF: BD 69 09    JSR    $6909
78F2: 5F          CLRB
78F3: D7 08       STB    $08
78F5: D7 0B       STB    $0B
78F7: D7 0E       STB    $0E
78F9: D6 26       LDB    $26
78FB: 27 0D       BEQ    $790A
78FD: F6 04 40    LDB    $0440
7900: 27 08       BEQ    $790A
7902: BD 77 EC    JSR    $77EC
7905: C6 01       LDB    #$01
7907: D7 05       STB    $05
7909: 39          RTS
790A: D6 60       LDB    nb_lives_0060
790C: 26 F7       BNE    $7905
790E: C6 01       LDB    #$01
7910: D7 02       STB    $02
7912: 0F 05       CLR    $05
7914: 39          RTS
7915: 0D 52       TST    $52
7917: 26 04       BNE    $791D
7919: 0D 28       TST    $28
791B: 27 12       BEQ    $792F
791D: 10 9E 14    LDY    $14
7920: E7 A0       STB    ,Y+
7922: 10 8C 01 7F CMPY   #$017F
7926: 25 04       BCS    $792C
7928: 10 8E 01 40 LDY    #$0140
792C: 10 9F 14    STY    $14
792F: 39          RTS
7930: 9E 16       LDX    $16
7932: 9C 14       CMPX   $14
7934: 27 0F       BEQ    $7945
7936: E6 80       LDB    ,X+
7938: 8C 01 7F    CMPX   #$017F
793B: 25 03       BCS    $7940
793D: 8E 01 40    LDX    #$0140
7940: 9F 16       STX    $16
7942: F7 3A 00    STB    $3A00
7945: 39          RTS
7946: C6 00       LDB    #$00
7948: 7E 79 15    JMP    $7915
794B: C6 3A       LDB    #$3A
794D: 7E 79 15    JMP    $7915
7950: D6 28       LDB    $28
7952: 10 26 FF EF LBNE   $7945
7956: C6 35       LDB    #$35
7958: BD 79 1D    JSR    $791D
795B: C6 FF       LDB    #$FF
795D: 7E 79 1D    JMP    $791D
7960: C6 01       LDB    #$01
7962: 7E 79 15    JMP    $7915
7965: C6 02       LDB    #$02
7967: 7E 79 15    JMP    $7915
796A: C6 03       LDB    #$03
796C: 7E 79 15    JMP    $7915
796F: C6 04       LDB    #$04
7971: 7E 79 15    JMP    $7915
7974: C6 05       LDB    #$05
7976: 7E 79 15    JMP    $7915
7979: C6 06       LDB    #$06
797B: 7E 79 58    JMP    $7958
797E: C6 07       LDB    #$07
7980: BD 79 15    JSR    $7915
7983: C6 08       LDB    #$08
7985: 7E 79 15    JMP    $7915
7988: C6 1D       LDB    #$1D
798A: 7E 79 15    JMP    $7915
798D: C6 0B       LDB    #$0B
798F: 7E 79 58    JMP    $7958
7992: C6 0C       LDB    #$0C
7994: 7E 79 58    JMP    $7958
7997: C6 0D       LDB    #$0D
7999: 7E 79 15    JMP    $7915
799C: C6 0E       LDB    #$0E
799E: 7E 79 15    JMP    $7915
79A1: C6 0F       LDB    #$0F
79A3: 7E 79 58    JMP    $7958
79A6: C6 10       LDB    #$10
79A8: 7E 79 15    JMP    $7915
79AB: C6 12       LDB    #$12
79AD: 7E 79 58    JMP    $7958
79B0: C6 13       LDB    #$13
79B2: 7E 79 15    JMP    $7915
79B5: C6 14       LDB    #$14
79B7: 7E 79 58    JMP    $7958
79BA: C6 17       LDB    #$17
79BC: 7E 79 58    JMP    $7958
79BF: C6 18       LDB    #$18
79C1: 7E 79 15    JMP    $7915
79C4: C6 19       LDB    #$19
79C6: 7E 79 15    JMP    $7915
79C9: C6 1A       LDB    #$1A
79CB: 7E 79 58    JMP    $7958
79CE: C6 1B       LDB    #$1B
79D0: 7E 79 58    JMP    $7958
79D3: C6 1C       LDB    #$1C
79D5: 7E 79 15    JMP    $7915
79D8: C6 00       LDB    #$00
79DA: 7E 79 58    JMP    $7958
79DD: C6 1E       LDB    #$1E
79DF: 7E 79 58    JMP    $7958
79E2: C6 1F       LDB    #$1F
79E4: 7E 79 58    JMP    $7958
79E7: C6 20       LDB    #$20
79E9: 7E 79 15    JMP    $7915
79EC: C6 21       LDB    #$21
79EE: 7E 79 58    JMP    $7958
79F1: C6 22       LDB    #$22
79F3: 7E 79 58    JMP    $7958
79F6: C6 23       LDB    #$23
79F8: 7E 79 58    JMP    $7958
79FB: C6 24       LDB    #$24
79FD: 7E 79 15    JMP    $7915
7A00: C6 25       LDB    #$25
7A02: 7E 79 15    JMP    $7915
7A05: C6 26       LDB    #$26
7A07: 7E 79 15    JMP    $7915
7A0A: C6 27       LDB    #$27
7A0C: 7E 79 15    JMP    $7915
7A0F: C6 2C       LDB    #$2C
7A11: 7E 79 15    JMP    $7915
7A14: C6 28       LDB    #$28
7A16: 7E 79 15    JMP    $7915
7A19: BD 7A 66    JSR    $7A66
7A1C: BD 79 46    JSR    $7946
7A1F: C6 2F       LDB    #$2F
7A21: 7E 79 15    JMP    $7915
7A24: C6 30       LDB    #$30
7A26: 7E 79 15    JMP    $7915
7A29: BD 7A 66    JSR    $7A66
7A2C: BD 79 46    JSR    $7946
7A2F: C6 31       LDB    #$31
7A31: 7E 79 15    JMP    $7915
7A34: C6 32       LDB    #$32
7A36: 7E 79 15    JMP    $7915
7A39: C6 36       LDB    #$36
7A3B: 7E 79 58    JMP    $7958
7A3E: C6 37       LDB    #$37
7A40: 7E 79 15    JMP    $7915
7A43: C6 38       LDB    #$38
7A45: 7E 79 15    JMP    $7915
7A48: C6 39       LDB    #$39
7A4A: 7E 79 15    JMP    $7915
7A4D: C6 3A       LDB    #$3A
7A4F: 7E 79 15    JMP    $7915
7A52: C6 3B       LDB    #$3B
7A54: 7E 79 15    JMP    $7915
7A57: C6 3C       LDB    #$3C
7A59: 7E 79 58    JMP    $7958
7A5C: C6 3D       LDB    #$3D
7A5E: 7E 79 58    JMP    $7958
7A61: C6 3E       LDB    #$3E
7A63: 7E 79 15    JMP    $7915
7A66: C6 3F       LDB    #$3F
7A68: 7E 79 15    JMP    $7915
7A6B: C6 04       LDB    #$04
7A6D: F7 3E 00    STB    bankswitch_3e00
7A70: D6 0E       LDB    $0E
7A72: 58          ASLB
7A73: CE 7A 78    LDU    #jump_table_7a78
7A76: 6E D5       JMP    [B,U]        ; [indirect_jump]
7A78: 7A 7E 7A    DEC    $7E7A
7A7B: A4 7C       ANDA   -$4,S
7A7D: 3D          MUL
7A7E: 4F          CLRA
7A7F: 5F          CLRB
7A80: DD D4       STD    $D4
7A82: DD D6       STD    $D6
7A84: DD 9C       STD    $9C
7A86: DD 9E       STD    $9E
7A88: CE 05 40    LDU    #$0540
7A8B: C6 04       LDB    #$04
7A8D: D7 E3       STB    $E3
7A8F: 4F          CLRA
7A90: 5F          CLRB
7A91: ED C4       STD    ,U
7A93: ED 42       STD    $2,U
7A95: 33 C8 30    LEAU   $30,U
7A98: 0A E3       DEC    $E3
7A9A: 26 F5       BNE    $7A91
7A9C: 6F 45       CLR    $5,U
7A9E: 7F 05 2A    CLR    $052A
7AA1: 0C 0E       INC    $0E
7AA3: 39          RTS
7AA4: 8E 05 10    LDX    #$0510
7AA7: 8D 33       BSR    $7ADC
7AA9: 8E 15 C2    LDX    #$15C2
7AAC: BD 7C 42    JSR    $7C42
7AAF: 8E 08 90    LDX    #$0890
7AB2: BD 7C C6    JSR    $7CC6
7AB5: 8E 05 40    LDX    #$0540
7AB8: BD 7C A0    JSR    $7CA0
7ABB: BD 7A C7    JSR    $7AC7
7ABE: 8E 05 40    LDX    #$0540
7AC1: BD F8 3D    JSR    $F83D
7AC4: 7E F7 B3    JMP    $F7B3
7AC7: BD F7 88    JSR    $F788
7ACA: 8E 05 10    LDX    #$0510
7ACD: BD F8 3D    JSR    $F83D
7AD0: 8E 15 C2    LDX    #$15C2
7AD3: BD F8 3D    JSR    $F83D
7AD6: 8E 08 90    LDX    #$0890
7AD9: 7E F8 3D    JMP    $F83D
7ADC: EC 13       LDD    -$D,X
7ADE: 48          ASLA
7ADF: CE 7A E4    LDU    #$7AE4

7AEC: C6 01       LDB    #$01
7AEE: D7 AC       STB    armour_flag_00ac
7AF0: D7 DE       STB    $DE
7AF2: 0F 72       CLR    starting_level_0072
7AF4: CC 40 00    LDD    #$4000
7AF7: DD 6C       STD    $6C
7AF9: CC 06 00    LDD    #$0600
7AFC: BD 69 09    JSR    $6909
7AFF: CC 00 60    LDD    #$0060
7B02: ED 16       STD    -$A,X
7B04: 8D 16       BSR    $7B1C
7B06: 6F 88 15    CLR    $15,X
7B09: C6 03       LDB    #$03
7B0B: E7 1F       STB    -$1,X
7B0D: C6 3C       LDB    #$3C
7B0F: E7 88 14    STB    $14,X
7B12: CC 7B 2B    LDD    #$7B2B
7B15: 7E 7D 43    JMP    $7D43
7B18: C6 01       LDB    #$01
7B1A: E7 1F       STB    -$1,X
7B1C: CC 00 40    LDD    #$0040
7B1F: ED 19       STD    -$7,X
7B21: CC 01 01    LDD    #$0101
7B24: ED 10       STD    -$10,X
7B26: E7 0E       STB    $E,X
7B28: E7 1E       STB    -$2,X
7B2A: 39          RTS
7B2B: 6E 80       JMP    ,X+
7B2D: 66 6F       ROR    $F,S
7B2F: 67 58       ASR    -$8,U
7B31: CE 7B 36    LDU    #jump_table_7b36
7B34: 6E D5       JMP    [B,U]        ; [indirect_jump]

7B4A: 6A 88 14    DEC    $14,X
7B4D: 26 14       BNE    $7B63
7B4F: CC 7B 3E    LDD    #$7B3E
7B52: ED 1C       STD    -$4,X
7B54: EE 1C       LDU    -$4,X
7B56: E6 C0       LDB    ,U+
7B58: D7 DE       STB    $DE
7B5A: E6 C0       LDB    ,U+
7B5C: E7 88 14    STB    $14,X
7B5F: EF 1C       STU    -$4,X
7B61: 6C 14       INC    -$C,X
7B63: 39          RTS
7B64: 6A 88 14    DEC    $14,X
7B67: 26 FA       BNE    $7B63
7B69: BD 7A 57    JSR    $7A57
7B6C: 20 E6       BRA    $7B54
7B6E: 6A 88 14    DEC    $14,X
7B71: 26 14       BNE    $7B87
7B73: C6 01       LDB    #$01
7B75: F7 08 80    STB    $0880
7B78: BD 7A 5C    JSR    $7A5C
7B7B: 20 D7       BRA    $7B54
7B7D: E6 88 1A    LDB    $1A,X
7B80: 27 05       BEQ    $7B87
7B82: CC 02 00    LDD    #$0200
7B85: ED 13       STD    -$D,X
7B87: 39          RTS
7B88: CE 7B 8E    LDU    #jump_table_7b8e
7B8B: 58          ASLB
7B8C: 6E D5       JMP    [B,U]        ; [indirect_jump]

7B94: CE 98 9F    LDU    #$989F
7B97: BD 98 F3    JSR    $98F3
7B9A: BD 79 4B    JSR    $794B
7B9D: CE 95 5F    LDU    #$955F
7BA0: BD 91 A1    JSR    $91A1
7BA3: CC 95 57    LDD    #$9557
7BA6: ED 88 13    STD    $13,X
7BA9: 6F 88 1A    CLR    $1A,X
7BAC: 6C 14       INC    -$C,X
7BAE: 39          RTS
7BAF: BD 96 40    JSR    $9640
7BB2: BD 96 5A    JSR    $965A
7BB5: BD 90 74    JSR    $9074
7BB8: EE 88 13    LDU    $13,X
7BBB: BD 8C A7    JSR    $8CA7
7BBE: 10 24 1A E7 LBCC   $96A9
7BC2: 4F          CLRA
7BC3: E3 19       ADDD   -$7,X
7BC5: ED 19       STD    -$7,X
7BC7: C6 1E       LDB    #$1E
7BC9: E7 88 14    STB    $14,X
7BCC: CC 03 00    LDD    #$0300
7BCF: ED 13       STD    -$D,X
7BD1: 39          RTS
7BD2: 58          ASLB
7BD3: CE 7B D8    LDU    #jump_table_7bd8
7BD6: 6E D5       JMP    [B,U]        ; [indirect_jump]

7BE2: 6A 88 14    DEC    $14,X
7BE5: 26 EA       BNE    $7BD1
7BE7: C6 14       LDB    #$14
7BE9: E7 88 14    STB    $14,X
7BEC: BD 9A 2F    JSR    $9A2F
7BEF: 6C 14       INC    -$C,X
7BF1: 39          RTS
7BF2: 6A 88 14    DEC    $14,X
7BF5: 27 09       BEQ    $7C00
7BF7: CE 95 53    LDU    #$9553
7BFA: BD 94 77    JSR    $9477
7BFD: 7E 90 74    JMP    $9074
7C00: 0F AC       CLR    armour_flag_00ac
7C02: BD 79 A6    JSR    $79A6
7C05: C6 1E       LDB    #$1E
7C07: E7 88 14    STB    $14,X
7C0A: BD 9A 2F    JSR    $9A2F
7C0D: 6C 14       INC    -$C,X
7C0F: 39          RTS
7C10: 6A 88 14    DEC    $14,X
7C13: 26 FA       BNE    $7C0F
7C15: C6 2D       LDB    #$2D
7C17: 20 D0       BRA    $7BE9
7C19: E6 88 14    LDB    $14,X
7C1C: 27 05       BEQ    $7C23
7C1E: 6A 88 14    DEC    $14,X
7C21: 20 D4       BRA    $7BF7
7C23: C6 1E       LDB    #$1E
7C25: E7 88 14    STB    $14,X
7C28: BD 9A 2F    JSR    $9A2F
7C2B: 6C 14       INC    -$C,X
7C2D: 39          RTS
7C2E: 6A 88 14    DEC    $14,X
7C31: 26 09       BNE    $7C3C
7C33: BD 7A 24    JSR    $7A24
7C36: 4F          CLRA
7C37: 5F          CLRB
7C38: ED 13       STD    -$D,X
7C3A: 0C 0E       INC    $0E
7C3C: 39          RTS
7C3D: C6 01       LDB    #$01
7C3F: D7 71       STB    $71
7C41: 39          RTS
7C42: E6 13       LDB    -$D,X
7C44: 58          ASLB
7C45: CE 7C 4A    LDU    #jump_table_7c4a
7C48: 6E D5       JMP    [B,U]        ; [indirect_jump]

7C54: CC 00 70    LDD    #$0070
7C57: ED 16       STD    -$A,X
7C59: BD 7B 18    JSR    $7B18
7C5C: C6 96       LDB    #$96
7C5E: E7 88 15    STB    $15,X
7C61: CC 7C 72    LDD    #$7C72
7C64: 7E 7D 43    JMP    $7D43
7C67: 6A 88 15    DEC    $15,X
7C6A: 26 56       BNE    $7CC2
7C6C: CC 7C 75    LDD    #$7C75
7C6F: 7E 7D 43    JMP    $7D43

7C8E: F6 05 2A    LDB    $052A
7C91: 27 2F       BEQ    $7CC2
7C93: CC 7C 78    LDD    #$7C78
7C96: 6F 02       CLR    $2,X
7C98: 7E 7D 43    JMP    $7D43
7C9B: 4F          CLRA
7C9C: 5F          CLRB
7C9D: ED 10       STD    -$10,X
7C9F: 39          RTS
7CA0: E6 13       LDB    -$D,X
7CA2: 58          ASLB
7CA3: CE 7C A8    LDU    #jump_table_7ca8
7CA6: 6E D5       JMP    [B,U]        ; [indirect_jump]

7CAC: CC 00 50    LDD    #$0050
7CAF: ED 16       STD    -$A,X
7CB1: BD 7B 18    JSR    $7B18
7CB4: CC 7C C3    LDD    #$7CC3
7CB7: 7E 7D 43    JMP    $7D43
7CBA: D6 AC       LDB    armour_flag_00ac
7CBC: 26 04       BNE    $7CC2
7CBE: 4F          CLRA
7CBF: 5F          CLRB
7CC0: ED 10       STD    -$10,X
7CC2: 39          RTS

7CC6: E6 10       LDB    -$10,X                                    
7CC8: 27 F8       BEQ    $7CC2                                     
7CCA: EC 13       LDD    -$D,X                                     
7CCC: 48          ASLA
7CCD: 10 8E 7C E4 LDY    #$7CE4
7CD1: CE 7C D6    LDU    #jump_table_7cd6
7CD4: 6E D6       JMP    [A,U]        ; [indirect_jump]

7CEA: C6 04       LDB    #$04
7CEC: E7 1F       STB    -$1,X
7CEE: CC 00 C5    LDD    #$00C5
7CF1: ED 16       STD    -$A,X
7CF3: CC 00 A0    LDD    #$00A0
7CF6: ED 19       STD    -$7,X
7CF8: CC 01 01    LDD    #$0101
7CFB: ED 10       STD    -$10,X
7CFD: E6 13       LDB    -$D,X
7CFF: E6 A5       LDB    B,Y
7D01: E7 88 14    STB    $14,X
7D04: CC 4C FC    LDD    #$4CFC
7D07: 20 3A       BRA    $7D43
7D09: 6A 88 14    DEC    $14,X
7D0C: 10 27 00 90 LBEQ   $7DA0
7D10: D6 21       LDB    $21
7D12: C4 03       ANDB   #$03
7D14: 26 05       BNE    $7D1B
7D16: EC 84       LDD    ,X
7D18: ED 03       STD    $3,X
7D1A: 39          RTS
7D1B: CC A6 31    LDD    #$A631
7D1E: 20 F8       BRA    $7D18
7D20: 6A 88 14    DEC    $14,X
7D23: 27 08       BEQ    $7D2D
7D25: D6 21       LDB    $21
7D27: C4 02       ANDB   #$02
7D29: 26 EB       BNE    $7D16
7D2B: 20 EE       BRA    $7D1B
7D2D: E6 13       LDB    -$D,X
7D2F: E6 A5       LDB    B,Y
7D31: E7 88 14    STB    $14,X
7D34: CC 4C 9F    LDD    #$4C9F
7D37: 20 0A       BRA    $7D43
7D39: 6A 88 14    DEC    $14,X
7D3C: 10 26 13 34 LBNE   $9074
7D40: CC 4C DE    LDD    #$4CDE
7D43: ED 03       STD    $3,X
7D45: ED 84       STD    ,X
7D47: 6C 13       INC    -$D,X
7D49: 39          RTS

7D52: 58          ASLB
7D53: CE 7D 58    LDU    #jump_table_7d58
7D56: 6E D5       JMP    [B,U]        ; [indirect_jump]

7D5C: CE 7D 4A    LDU    #$7D4A
7D5F: BD 94 77    JSR    $9477
7D62: 33 42       LEAU   $2,U
7D64: BD 93 7B    JSR    $937B
7D67: BD 90 74    JSR    $9074
7D6A: BD 8C A7    JSR    $8CA7
7D6D: 24 DA       BCC    $7D49
7D6F: CC 4C 9F    LDD    #$4C9F
7D72: ED 03       STD    $3,X
7D74: ED 84       STD    ,X
7D76: 6F 02       CLR    $2,X
7D78: C6 01       LDB    #$01
7D7A: F7 05 2A    STB    $052A
7D7D: 6C 14       INC    -$C,X
7D7F: 39          RTS
7D80: CE 7D 4E    LDU    #$7D4E
7D83: BD 94 77    JSR    $9477
7D86: 33 42       LEAU   $2,U
7D88: BD 93 7B    JSR    $937B
7D8B: BD 90 74    JSR    $9074
7D8E: EC 19       LDD    -$7,X
7D90: 10 83 00 A0 CMPD   #$00A0
7D94: 25 B3       BCS    $7D49
7D96: 6C 13       INC    -$D,X
7D98: 39          RTS
7D99: CC 4C FC    LDD    #$4CFC
7D9C: ED 03       STD    $3,X
7D9E: ED 84       STD    ,X
7DA0: E6 13       LDB    -$D,X
7DA2: E6 A5       LDB    B,Y
7DA4: E7 88 14    STB    $14,X
7DA7: 6C 13       INC    -$D,X
7DA9: 39          RTS
7DAA: E6 11       LDB    -$F,X
7DAC: 27 1C       BEQ    $7DCA
7DAE: E6 88 14    LDB    $14,X
7DB1: 27 17       BEQ    $7DCA
7DB3: 6A 88 14    DEC    $14,X
7DB6: 10 26 FF 56 LBNE   $7D10
7DBA: 6F 11       CLR    -$F,X
7DBC: 4F          CLRA
7DBD: 5F          CLRB
7DBE: ED 1E       STD    -$2,X
7DC0: ED 1C       STD    -$4,X
7DC2: ED 1A       STD    -$6,X
7DC4: ED 18       STD    -$8,X
7DC6: ED 16       STD    -$A,X
7DC8: ED 14       STD    -$C,X
7DCA: 39          RTS
7DCB: C6 04       LDB    #$04
7DCD: F7 3E 00    STB    bankswitch_3e00
7DD0: D6 0E       LDB    $0E
7DD2: 58          ASLB
7DD3: CE 7D D8    LDU    #jump_table_7dd8
7DD6: 6E D5       JMP    [B,U]        ; [indirect_jump]

7DDC: 8E 05 10    LDX    #$0510
7DDF: 8D 12       BSR    $7DF3
7DE1: 8E 08 90    LDX    #$0890
7DE4: BD 7E A9    JSR    $7EA9
7DE7: 8E 15 C2    LDX    #$15C2
7DEA: BD 7E 42    JSR    $7E42
7DED: BD 7A C7    JSR    $7AC7
7DF0: 7E F7 B3    JMP    $F7B3
7DF3: E6 13       LDB    -$D,X
7DF5: 58          ASLB
7DF6: CE 7D FB    LDU    #jump_table_7dfb
7DF9: 6E D5       JMP    [B,U]        ; [indirect_jump]
7DFB: 7E 01 7E    JMP    $017E
7DFE: 38 7E       XANDCC #$7E
7E00: 41          NEGA
7E01: BD 7A 43    JSR    $7A43
7E04: CC 01 00    LDD    #$0100
7E07: DD D4       STD    $D4
7E09: CC 41 5F    LDD    #$415F
7E0C: DD 6C       STD    $6C
7E0E: CC 06 00    LDD    #$0600
7E11: BD 69 09    JSR    $6909
7E14: C6 0E       LDB    #$0E
7E16: D7 DE       STB    $DE
7E18: CC 00 20    LDD    #$0020
7E1B: ED 16       STD    -$A,X
7E1D: CC 00 50    LDD    #$0050
7E20: ED 19       STD    -$7,X
7E22: CC 01 01    LDD    #$0101
7E25: ED 10       STD    -$10,X
7E27: C6 03       LDB    #$03
7E29: E7 1F       STB    -$1,X
7E2B: C6 32       LDB    #$32
7E2D: E7 88 14    STB    $14,X
7E30: 0F AC       CLR    armour_flag_00ac
7E32: BD 9A 2F    JSR    $9A2F
7E35: 6C 13       INC    -$D,X
7E37: 39          RTS
7E38: 6A 88 14    DEC    $14,X
7E3B: 10 26 FD B8 LBNE   $7BF7
7E3F: 20 F1       BRA    $7E32
7E41: 39          RTS
7E42: E6 13       LDB    -$D,X
7E44: 58          ASLB
7E45: CE 7E 4A    LDU    #jump_table_7e4a
7E48: 6E D5       JMP    [B,U]        ; [indirect_jump]
7E4A: 7E 50 7E    JMP    $507E
7E4D: 75 7E 82    LSR    $7E82
7E50: CC 00 B3    LDD    #$00B3
7E53: ED 16       STD    -$A,X
7E55: C6 02       LDB    #$02
7E57: E7 1E       STB    -$2,X
7E59: C6 01       LDB    #$01
7E5B: E7 1F       STB    -$1,X
7E5D: CC 00 4F    LDD    #$004F
7E60: ED 19       STD    -$7,X
7E62: CC 01 01    LDD    #$0101
7E65: ED 10       STD    -$10,X
7E67: CC 01 5E    LDD    #$015E
7E6A: ED 88 15    STD    $15,X
7E6D: CC 7C 7C    LDD    #$7C7C
7E70: 6F 02       CLR    $2,X
7E72: 7E 7D 43    JMP    $7D43
7E75: EE 88 15    LDU    $15,X
7E78: 33 5F       LEAU   -$1,U
7E7A: EF 88 15    STU    $15,X
7E7D: 26 02       BNE    $7E81
7E7F: 6C 13       INC    -$D,X
7E81: 39          RTS
7E82: EC 16       LDD    -$A,X
7E84: 10 83 00 F3 CMPD   #$00F3
7E88: 10 25 FD 6B LBCS   $7BF7
7E8C: CC 1F F3    LDD    #$1FF3
7E8F: ED 16       STD    -$A,X
7E91: CC 0A 4E    LDD    #$0A4E
7E94: ED 19       STD    -$7,X
7E96: C6 02       LDB    #$02
7E98: D7 71       STB    $71
7E9A: CC 01 1A    LDD    #$011A
7E9D: BD 69 09    JSR    $6909
7EA0: 8E 08 90    LDX    #$0890
7EA3: BD 7D BC    JSR    $7DBC
7EA6: 6C 13       INC    -$D,X
7EA8: 39          RTS
7EA9: E6 13       LDB    -$D,X
7EAB: 58          ASLB
7EAC: CE 7E B1    LDU    #jump_table_7eb1
7EAF: 6E D5       JMP    [B,U]        ; [indirect_jump]
7EB1: 7E B7 7E    JMP    $B77E

7EB7: CC 02 31    LDD    #$0231
7EBA: BD 69 09    JSR    $6909
7EBD: C6 06       LDB    #$06
7EBF: E7 1F       STB    -$1,X
7EC1: CC 00 A0    LDD    #$00A0
7EC4: ED 16       STD    -$A,X
7EC6: CC 00 60    LDD    #$0060
7EC9: ED 19       STD    -$7,X
7ECB: CC 01 01    LDD    #$0101
7ECE: ED 10       STD    -$10,X
7ED0: CC 53 0E    LDD    #$530E
7ED3: 6F 02       CLR    $2,X
7ED5: 7E 7D 43    JMP    $7D43
7ED8: 7E 90 74    JMP    $9074
7EDB: 39          RTS
7EDC: 8E 05 10    LDX    #$0510
7EDF: 8D 18       BSR    $7EF9
7EE1: 8E 15 C2    LDX    #$15C2
7EE4: BD 7F BC    JSR    $7FBC
7EE7: BD F7 88    JSR    $F788
7EEA: 8E 15 C2    LDX    #$15C2
7EED: BD F8 3D    JSR    $F83D
7EF0: 8E 05 10    LDX    #$0510
7EF3: BD F8 3D    JSR    $F83D
7EF6: 7E F7 B3    JMP    $F7B3
7EF9: 96 0B       LDA    $0B
7EFB: 48          ASLA
7EFC: CE 7F 01    LDU    #jump_table_7f01
7EFF: 6E D6       JMP    [A,U]        ; [indirect_jump]

7F05: 4F          CLRA
7F06: 5F          CLRB
7F07: ED 13       STD    -$D,X
7F09: FD 15 B5    STD    $15B5
7F0C: 0C 0B       INC    $0B
7F0E: 39          RTS
7F0F: A6 13       LDA    -$D,X
7F11: 48          ASLA
7F12: CE 7F 17    LDU    #jump_table_7f17
7F15: 6E D6       JMP    [A,U]        ; [indirect_jump]

7F21: FC 15 B8    LDD    $15B8
7F24: A3 16       SUBD   -$A,X
7F26: 1F 98       TFR    B,A
7F28: C6 03       LDB    #$03
7F2A: BD FE D8    JSR    $FED8
7F2D: 1F 89       TFR    A,B
7F2F: 4F          CLRA
7F30: E3 16       ADDD   -$A,X
7F32: ED 07       STD    $7,X
7F34: CC 0A 4E    LDD    #$0A4E
7F37: ED 19       STD    -$7,X
7F39: 86 01       LDA    #$01
7F3B: A7 1E       STA    -$2,X
7F3D: 6F 06       CLR    $6,X
7F3F: BD 9A 2F    JSR    $9A2F
7F42: 6C 13       INC    -$D,X
7F44: 39          RTS
7F45: A6 06       LDA    $6,X
7F47: 26 17       BNE    $7F60
7F49: EC 16       LDD    -$A,X
7F4B: 10 A3 07    CMPD   $7,X
7F4E: 24 09       BCC    $7F59
7F50: CE 95 53    LDU    #$9553
7F53: BD 94 77    JSR    $9477
7F56: 7E 90 74    JMP    $9074
7F59: 86 01       LDA    #$01
7F5B: A7 06       STA    $6,X
7F5D: BD 9A 2F    JSR    $9A2F
7F60: 39          RTS
7F61: C6 04       LDB    #$04
7F63: E7 0A       STB    $A,X
7F65: CC 7F 8D    LDD    #$7F8D
7F68: ED 84       STD    ,X
7F6A: ED 03       STD    $3,X
7F6C: C6 E0       LDB    #$E0
7F6E: E0 1A       SUBB   -$6,X
7F70: C4 F8       ANDB   #$F8
7F72: 4F          CLRA
7F73: 58          ASLB
7F74: 49          ROLA
7F75: 58          ASLB
7F76: 49          ROLA
7F77: ED 0B       STD    $B,X
7F79: 4F          CLRA
7F7A: E6 17       LDB    -$9,X
7F7C: 54          LSRB
7F7D: 54          LSRB
7F7E: 54          LSRB
7F7F: E3 0B       ADDD   $B,X
7F81: 10 8E 20 00 LDY    #$2000
7F85: 31 AB       LEAY   D,Y
7F87: 10 AF 0B    STY    $B,X
7F8A: 6C 13       INC    -$D,X
7F8C: 39          RTS
7F8D: 7D 80 75    TST    $8075
7F90: 7E 76 0F    JMP    $760F

7F95: 10 AE 0B    LDY    $B,X
7F98: D6 21       LDB    $21
7F9A: C4 0F       ANDB   #$0F
7F9C: 26 16       BNE    $7FB4
7F9E: C6 60       LDB    #$60
7FA0: E7 A4       STB    ,Y
7FA2: C6 05       LDB    #$05
7FA4: E7 A9 04 00 STB    $0400,Y
7FA8: 31 A8 E0    LEAY   -$20,Y
7FAB: 10 AF 0B    STY    $B,X
7FAE: 6A 0A       DEC    $A,X
7FB0: 26 02       BNE    $7FB4
7FB2: 6C 13       INC    -$D,X
7FB4: 39          RTS
7FB5: C6 02       LDB    #$02
7FB7: D7 7F       STB    $7F
7FB9: 0F 0B       CLR    $0B
7FBB: 39          RTS
7FBC: 96 0E       LDA    $0E
7FBE: 48          ASLA
7FBF: CE 7F C4    LDU    #jump_table_7fc4
7FC2: 6E D6       JMP    [A,U]        ; [indirect_jump]
7FC4: 7F CC 7F    CLR    $CC7F
7FC7: DC 7F       LDD    $7F
7FC9: F8 80 07    EORB   $8007
7FCC: C6 01       LDB    #$01
7FCE: E7 1F       STB    -$1,X
7FD0: CC 7C 7C    LDD    #$7C7C
7FD3: ED 84       STD    ,X
7FD5: ED 03       STD    $3,X
7FD7: 6F 02       CLR    $2,X
7FD9: 0C 0E       INC    $0E
7FDB: 39          RTS
7FDC: FC 05 17    LDD    $0517
7FDF: C3 00 10    ADDD   #$0010
7FE2: 10 A3 16    CMPD   -$A,X
7FE5: 24 09       BCC    $7FF0
7FE7: CE 95 55    LDU    #$9555
7FEA: BD 94 77    JSR    $9477
7FED: 7E 90 74    JMP    $9074
7FF0: 86 02       LDA    #$02
7FF2: B7 05 03    STA    $0503
7FF5: 97 0E       STA    $0E
7FF7: 39          RTS
7FF8: 86 03       LDA    #$03
7FFA: A7 1F       STA    -$1,X
7FFC: CC 7C 86    LDD    #$7C86
7FFF: ED 84       STD    ,X
8001: ED 03       STD    $3,X
8003: 6F 02       CLR    $2,X
8005: 0C 0E       INC    $0E
8007: 7E 90 74    JMP    $9074
800A: C6 04       LDB    #$04
800C: F7 3E 00    STB    bankswitch_3e00
800F: BD 90 AB    JSR    $90AB
8012: BD 9C 68    JSR    $9C68
8015: BD A0 A6    JSR    $A0A6
8018: BD FC 57    JSR    $FC57
801B: BD E2 B4    JSR    $E2B4
801E: BD E6 12    JSR    $E612
8021: 8E 06 40    LDX    #$0640
8024: EC 13       LDD    -$D,X
8026: 48          ASLA
8027: CE 80 9C    LDU    #jump_table_809c
802A: 6E D6       JMP    [A,U]        ; [indirect_jump]
802C: 8D 3B       BSR    $8069
802E: DF E0       STU    $E0
8030: DC E0       LDD    $E0
8032: 84 03       ANDA   #$03
8034: C3 03 1E    ADDD   #$031E
8037: 84 03       ANDA   #$03
8039: C3 28 00    ADDD   #$2800
803C: DD C8       STD    $C8
803E: DC E0       LDD    $E0
8040: 84 03       ANDA   #$03
8042: C3 03 11    ADDD   #$0311
8045: 84 03       ANDA   #$03
8047: C3 28 00    ADDD   #$2800
804A: DD CC       STD    $CC
804C: DC E0       LDD    $E0
804E: 84 03       ANDA   #$03
8050: C3 02 37    ADDD   #$0237
8053: 84 03       ANDA   #$03
8055: C3 28 00    ADDD   #$2800
8058: DD C0       STD    $C0
805A: DC E0       LDD    $E0
805C: 84 03       ANDA   #$03
805E: C3 03 D7    ADDD   #$03D7
8061: 84 03       ANDA   #$03
8063: C3 28 00    ADDD   #$2800
8066: DD C4       STD    $C4
8068: 39          RTS
8069: CE 28 00    LDU    #$2800
806C: D6 6D       LDB    $6D
806E: C5 01       BITB   #$01
8070: 27 04       BEQ    $8076
8072: 33 C9 02 00 LEAU   $0200,U
8076: C5 20       BITB   #$20
8078: 27 03       BEQ    $807D
807A: 33 C8 10    LEAU   $10,U
807D: 39          RTS
807E: D6 C1       LDB    $C1
8080: C4 1F       ANDB   #$1F
8082: 5C          INCB
8083: D7 B8       STB    $B8
8085: D7 B9       STB    $B9
8087: DC C8       LDD    $C8
8089: 58          ASLB
808A: 49          ROLA
808B: 58          ASLB
808C: 49          ROLA
808D: 58          ASLB
808E: 49          ROLA
808F: 84 1F       ANDA   #$1F
8091: A7 E2       STA    ,-S
8093: 86 20       LDA    #$20
8095: A0 E0       SUBA   ,S+
8097: 97 BA       STA    $BA
8099: 97 BB       STA    $BB
809B: 39          RTS
809C: 80 AB       SUBA   #$AB
809E: 81 56       CMPA   #$56
80A0: 8E 06 40    LDX    #$0640
80A3: EC 13       LDD    -$D,X
80A5: 48          ASLA
80A6: CE 80 9C    LDU    #jump_table_809c
80A9: 6E D6       JMP    [A,U]        ; [indirect_jump]
80AB: 58          ASLB
80AC: CE 80 B1    LDU    #$80B1
80AF: 6E D5       JMP    [B,U]        ; [indirect_jump]
80B1: 80 B7       SUBA   #$B7
80B3: 81 19       CMPA   #$19
80B5: 81 32       CMPA   #$32
80B7: 8E 06 40    LDX    #$0640
80BA: CC 06 00    LDD    #$0600
80BD: BD 69 09    JSR    $6909
80C0: BD 80 2C    JSR    $802C
80C3: 8D B9       BSR    $807E
80C5: CC 01 1E    LDD    #$011E
80C8: ED 02       STD    $2,X
80CA: ED 04       STD    $4,X
80CC: 86 00       LDA    #$00
80CE: A7 0C       STA    $C,X
80D0: A7 0D       STA    $D,X
80D2: A7 0E       STA    $E,X
80D4: A7 0F       STA    $F,X
80D6: C6 10       LDB    #$10
80D8: E7 84       STB    ,X
80DA: E7 01       STB    $1,X
80DC: DC 6C       LDD    $6C
80DE: ED 08       STD    $8,X
80E0: ED 0A       STD    $A,X
80E2: ED 1E       STD    -$2,X
80E4: C4 1F       ANDB   #$1F
80E6: 1F 98       TFR    B,A
80E8: 5F          CLRB
80E9: ED 16       STD    -$A,X
80EB: DC 6C       LDD    $6C
80ED: 58          ASLB
80EE: 49          ROLA
80EF: 58          ASLB
80F0: 49          ROLA
80F1: 58          ASLB
80F2: 49          ROLA
80F3: 84 0F       ANDA   #$0F
80F5: 5F          CLRB
80F6: ED 19       STD    -$7,X
80F8: CC 81 4A    LDD    #$814A
80FB: ED 1C       STD    -$4,X
80FD: DC C0       LDD    $C0
80FF: DD C2       STD    $C2
8101: DC C4       LDD    $C4
8103: DD C6       STD    $C6
8105: DC C8       LDD    $C8
8107: DD CA       STD    $CA
8109: DC CC       LDD    $CC
810B: DD CE       STD    $CE
810D: 86 12       LDA    #$12
810F: A7 07       STA    $7,X
8111: 6F 13       CLR    -$D,X
8113: 86 01       LDA    #$01
8115: A7 14       STA    -$C,X
8117: 4F          CLRA
8118: 39          RTS
8119: 8E 06 40    LDX    #$0640
811C: BD 81 D0    JSR    $81D0
811F: BD 81 72    JSR    $8172
8122: 6A 07       DEC    $7,X
8124: 26 0A       BNE    $8130
8126: 6F 13       CLR    -$D,X
8128: C6 02       LDB    #$02
812A: E7 14       STB    -$C,X
812C: C6 12       LDB    #$12
812E: E7 07       STB    $7,X
8130: 4F          CLRA
8131: 39          RTS
8132: 8E 06 40    LDX    #$0640
8135: BD 84 57    JSR    $8457
8138: BD 81 72    JSR    $8172
813B: 6A 07       DEC    $7,X
813D: 26 09       BNE    $8148
813F: CC 01 00    LDD    #$0100
8142: ED 13       STD    -$D,X
8144: E7 15       STB    -$B,X
8146: 43          COMA
8147: 39          RTS
8148: 4F          CLRA
8149: 39          RTS

8156: 34 10       PSHS   X
8158: BD 81 9E    JSR    $819E
815B: AE E4       LDX    ,S
815D: EC 16       LDD    -$A,X
815F: DD 9C       STD    $9C
8161: 84 01       ANDA   #$01
8163: DD D4       STD    $D4
8165: BD 86 C4    JSR    $86C4
8168: 35 10       PULS   X
816A: EC 19       LDD    -$7,X
816C: DD 9E       STD    $9E
816E: 84 01       ANDA   #$01
8170: DD D6       STD    $D6
8172: 8E 06 40    LDX    #$0640
8175: E6 0D       LDB    $D,X
8177: E7 0C       STB    $C,X
8179: E6 0F       LDB    $F,X
817B: E7 0E       STB    $E,X
817D: EC 1E       LDD    -$2,X
817F: DD 6C       STD    $6C
8181: EC 0A       LDD    $A,X
8183: ED 08       STD    $8,X
8185: D6 BB       LDB    $BB
8187: D7 BA       STB    $BA
8189: D6 B9       LDB    $B9
818B: D7 B8       STB    $B8
818D: DC C2       LDD    $C2
818F: DD C0       STD    $C0
8191: DC C6       LDD    $C6
8193: DD C4       STD    $C4
8195: DC CE       LDD    $CE
8197: DD CC       STD    $CC
8199: DC CA       LDD    $CA
819B: DD C8       STD    $C8
819D: 39          RTS
819E: FC 05 06    LDD    $0506
81A1: A3 16       SUBD   -$A,X
81A3: 10 83 00 81 CMPD   #$0081
81A7: 24 09       BCC    $81B2
81A9: 10 83 00 80 CMPD   #$0080
81AD: 10 25 02 7D LBCS   $842E
81B1: 39          RTS
81B2: EC 16       LDD    -$A,X
81B4: 10 93 5A    CMPD   $5A
81B7: 24 2D       BCC    $81E6
81B9: FC 05 07    LDD    $0507
81BC: A3 17       SUBD   -$9,X
81BE: 80 80       SUBA   #$80
81C0: E3 17       ADDD   -$9,X
81C2: ED 17       STD    -$9,X
81C4: 24 02       BCC    $81C8
81C6: 6C 16       INC    -$A,X
81C8: A6 17       LDA    -$9,X
81CA: 84 10       ANDA   #$10
81CC: A8 84       EORA   ,X
81CE: 26 16       BNE    $81E6
81D0: C6 10       LDB    #$10
81D2: E8 84       EORB   ,X
81D4: E7 84       STB    ,X
81D6: 8D 0F       BSR    $81E7
81D8: 34 10       PSHS   X
81DA: C6 00       LDB    #$00
81DC: D7 2A       STB    $2A
81DE: BD 86 77    JSR    $8677
81E1: 35 10       PULS   X
81E3: 7E 83 54    JMP    $8354
81E6: 39          RTS
81E7: E6 02       LDB    $2,X
81E9: C5 01       BITB   #$01
81EB: 10 26 00 C5 LBNE   $82B4
81EF: DC 6C       LDD    $6C
81F1: CB 01       ADDB   #$01
81F3: C4 1F       ANDB   #$1F
81F5: 34 04       PSHS   B
81F7: D6 6D       LDB    $6D
81F9: C4 E0       ANDB   #$E0
81FB: EA E0       ORB    ,S+
81FD: 96 6C       LDA    $6C
81FF: C3 00 20    ADDD   #$0020
8202: 84 01       ANDA   #$01
8204: 34 02       PSHS   A
8206: 96 6C       LDA    $6C
8208: 84 FE       ANDA   #$FE
820A: AA E0       ORA    ,S+
820C: 1F 03       TFR    D,U
820E: 8D 7E       BSR    $828E
8210: 10 8E 03 A0 LDY    #$03A0
8214: 8D 4C       BSR    $8262
8216: DC 6C       LDD    $6C
8218: CB 01       ADDB   #$01
821A: C4 1F       ANDB   #$1F
821C: 34 04       PSHS   B
821E: D6 6D       LDB    $6D
8220: C4 E0       ANDB   #$E0
8222: EA E0       ORB    ,S+
8224: 96 6C       LDA    $6C
8226: C3 00 00    ADDD   #$0000
8229: 84 01       ANDA   #$01
822B: 34 02       PSHS   A
822D: 96 6C       LDA    $6C
822F: 84 FE       ANDA   #$FE
8231: AA E0       ORA    ,S+
8233: 1F 03       TFR    D,U
8235: 8D 57       BSR    $828E
8237: 10 8E 03 90 LDY    #$0390
823B: 8D 25       BSR    $8262
823D: DC 6C       LDD    $6C
823F: CB 01       ADDB   #$01
8241: C4 1F       ANDB   #$1F
8243: 34 04       PSHS   B
8245: D6 6D       LDB    $6D
8247: C4 E0       ANDB   #$E0
8249: EA E0       ORB    ,S+
824B: 96 6C       LDA    $6C
824D: C3 FF E0    ADDD   #$FFE0
8250: 84 01       ANDA   #$01
8252: 34 02       PSHS   A
8254: 96 6C       LDA    $6C
8256: 84 FE       ANDA   #$FE
8258: AA E0       ORA    ,S+
825A: 1F 03       TFR    D,U
825C: 8D 30       BSR    $828E
825E: 10 8E 03 80 LDY    #$0380
8262: 34 10       PSHS   X
8264: C6 08       LDB    #$08
8266: D7 E2       STB    $E2
8268: C6 00       LDB    #$00
826A: F7 3E 00    STB    bankswitch_3e00
826D: E6 C0       LDB    ,U+
826F: 4F          CLRA
8270: 58          ASLB
8271: 49          ROLA
8272: 58          ASLB
8273: 49          ROLA
8274: 58          ASLB
8275: 49          ROLA
8276: D3 E0       ADDD   $E0
8278: 1F 01       TFR    D,X
827A: C6 01       LDB    #$01
827C: F7 3E 00    STB    bankswitch_3e00
827F: EC 04       LDD    $4,X
8281: ED A8 30    STD    $30,Y
8284: EC 84       LDD    ,X
8286: ED A1       STD    ,Y++
8288: 0A E2       DEC    $E2
828A: 26 DC       BNE    $8268
828C: 35 90       PULS   X,PC
828E: C6 02       LDB    #$02
8290: F7 3E 00    STB    bankswitch_3e00
8293: E6 C4       LDB    ,U
8295: 4F          CLRA
8296: 58          ASLB
8297: 49          ROLA
8298: 10 8E 42 00 LDY    #$4200
829C: EC AB       LDD    D,Y
829E: DD E0       STD    $E0
82A0: E6 C4       LDB    ,U
82A2: 86 40       LDA    #$40
82A4: 3D          MUL
82A5: C3 40 00    ADDD   #$4000
82A8: 1F 03       TFR    D,U
82AA: E6 02       LDB    $2,X
82AC: C4 0E       ANDB   #$0E
82AE: 58          ASLB
82AF: 58          ASLB
82B0: 4F          CLRA
82B1: 33 CB       LEAU   D,U
82B3: 39          RTS
82B4: DC 6C       LDD    $6C
82B6: CB 01       ADDB   #$01
82B8: C4 1F       ANDB   #$1F
82BA: 34 04       PSHS   B
82BC: D6 6D       LDB    $6D
82BE: C4 E0       ANDB   #$E0
82C0: EA E0       ORB    ,S+
82C2: 96 6C       LDA    $6C
82C4: C3 00 20    ADDD   #$0020
82C7: 84 01       ANDA   #$01
82C9: 34 02       PSHS   A
82CB: 96 6C       LDA    $6C
82CD: 84 FE       ANDA   #$FE
82CF: AA E0       ORA    ,S+
82D1: 1F 03       TFR    D,U
82D3: 8D B9       BSR    $828E
82D5: 10 8E 03 A0 LDY    #$03A0
82D9: 8D 4D       BSR    $8328
82DB: DC 6C       LDD    $6C
82DD: CB 01       ADDB   #$01
82DF: C4 1F       ANDB   #$1F
82E1: 34 04       PSHS   B
82E3: D6 6D       LDB    $6D
82E5: C4 E0       ANDB   #$E0
82E7: EA E0       ORB    ,S+
82E9: 96 6C       LDA    $6C
82EB: C3 00 00    ADDD   #$0000
82EE: 84 01       ANDA   #$01
82F0: 34 02       PSHS   A
82F2: 96 6C       LDA    $6C
82F4: 84 FE       ANDA   #$FE
82F6: AA E0       ORA    ,S+
82F8: 1F 03       TFR    D,U
82FA: 8D 92       BSR    $828E
82FC: 10 8E 03 90 LDY    #$0390
8300: 8D 26       BSR    $8328
8302: DC 6C       LDD    $6C
8304: CB 01       ADDB   #$01
8306: C4 1F       ANDB   #$1F
8308: 34 04       PSHS   B
830A: D6 6D       LDB    $6D
830C: C4 E0       ANDB   #$E0
830E: EA E0       ORB    ,S+
8310: 96 6C       LDA    $6C
8312: C3 FF E0    ADDD   #$FFE0
8315: 84 01       ANDA   #$01
8317: 34 02       PSHS   A
8319: 96 6C       LDA    $6C
831B: 84 FE       ANDA   #$FE
831D: AA E0       ORA    ,S+
831F: 1F 03       TFR    D,U
8321: BD 82 8E    JSR    $828E
8324: 10 8E 03 80 LDY    #$0380
8328: 34 10       PSHS   X
832A: C6 08       LDB    #$08
832C: D7 E2       STB    $E2
832E: C6 00       LDB    #$00
8330: F7 3E 00    STB    bankswitch_3e00
8333: E6 C0       LDB    ,U+
8335: 4F          CLRA
8336: 58          ASLB
8337: 49          ROLA
8338: 58          ASLB
8339: 49          ROLA
833A: 58          ASLB
833B: 49          ROLA
833C: D3 E0       ADDD   $E0
833E: 1F 01       TFR    D,X
8340: C6 01       LDB    #$01
8342: F7 3E 00    STB    bankswitch_3e00
8345: EC 06       LDD    $6,X
8347: ED A8 30    STD    $30,Y
834A: EC 02       LDD    $2,X
834C: ED A1       STD    ,Y++
834E: 0A E2       DEC    $E2
8350: 26 DC       BNE    $832E
8352: 35 90       PULS   X,PC
8354: E6 03       LDB    $3,X
8356: 5C          INCB
8357: C4 1F       ANDB   #$1F
8359: E7 03       STB    $3,X
835B: C4 0F       ANDB   #$0F
835D: C1 0E       CMPB   #$0E
835F: 26 1F       BNE    $8380
8361: EC 08       LDD    $8,X
8363: CB 01       ADDB   #$01
8365: C4 1F       ANDB   #$1F
8367: 34 04       PSHS   B
8369: E6 09       LDB    $9,X
836B: C4 E0       ANDB   #$E0
836D: EA E0       ORB    ,S+
836F: A6 08       LDA    $8,X
8371: C3 00 00    ADDD   #$0000
8374: 84 01       ANDA   #$01
8376: 34 02       PSHS   A
8378: A6 08       LDA    $8,X
837A: 84 FE       ANDA   #$FE
837C: AA E0       ORA    ,S+
837E: ED 0A       STD    $A,X
8380: E6 0D       LDB    $D,X
8382: 5C          INCB
8383: C4 1F       ANDB   #$1F
8385: E7 0D       STB    $D,X
8387: E6 02       LDB    $2,X
8389: 5C          INCB
838A: C4 1F       ANDB   #$1F
838C: E7 02       STB    $2,X
838E: C5 0F       BITB   #$0F
8390: 26 2B       BNE    $83BD
8392: DC 6C       LDD    $6C
8394: CB 01       ADDB   #$01
8396: C4 1F       ANDB   #$1F
8398: 34 04       PSHS   B
839A: D6 6D       LDB    $6D
839C: C4 E0       ANDB   #$E0
839E: EA E0       ORB    ,S+
83A0: 96 6C       LDA    $6C
83A2: C3 00 00    ADDD   #$0000
83A5: 84 01       ANDA   #$01
83A7: 34 02       PSHS   A
83A9: 96 6C       LDA    $6C
83AB: 84 FE       ANDA   #$FE
83AD: AA E0       ORA    ,S+
83AF: ED 1E       STD    -$2,X
83B1: DC 91       LDD    $91
83B3: C3 00 01    ADDD   #$0001
83B6: DD 91       STD    $91
83B8: C6 01       LDB    #$01
83BA: BD 8F 84    JSR    $8F84
83BD: DC C2       LDD    $C2
83BF: C3 00 20    ADDD   #$0020
83C2: 84 03       ANDA   #$03
83C4: C4 E0       ANDB   #$E0
83C6: DD E0       STD    $E0
83C8: DC C2       LDD    $C2
83CA: 84 FC       ANDA   #$FC
83CC: C4 1F       ANDB   #$1F
83CE: 9A E0       ORA    $E0
83D0: DA E1       ORB    $E1
83D2: DD C2       STD    $C2
83D4: DC C6       LDD    $C6
83D6: C3 00 20    ADDD   #$0020
83D9: 84 03       ANDA   #$03
83DB: C4 E0       ANDB   #$E0
83DD: DD E0       STD    $E0
83DF: DC C6       LDD    $C6
83E1: 84 FC       ANDA   #$FC
83E3: C4 1F       ANDB   #$1F
83E5: 9A E0       ORA    $E0
83E7: DA E1       ORB    $E1
83E9: DD C6       STD    $C6
83EB: DC CA       LDD    $CA
83ED: C3 00 20    ADDD   #$0020
83F0: 84 03       ANDA   #$03
83F2: C4 E0       ANDB   #$E0
83F4: DD E0       STD    $E0
83F6: DC CA       LDD    $CA
83F8: 84 FC       ANDA   #$FC
83FA: C4 1F       ANDB   #$1F
83FC: 9A E0       ORA    $E0
83FE: DA E1       ORB    $E1
8400: DD CA       STD    $CA
8402: DC CE       LDD    $CE
8404: C3 00 20    ADDD   #$0020
8407: 84 03       ANDA   #$03
8409: C4 E0       ANDB   #$E0
840B: DD E0       STD    $E0
840D: DC CE       LDD    $CE
840F: 84 FC       ANDA   #$FC
8411: C4 1F       ANDB   #$1F
8413: 9A E0       ORA    $E0
8415: DA E1       ORB    $E1
8417: DD CE       STD    $CE
8419: DC CA       LDD    $CA
841B: 84 03       ANDA   #$03
841D: C4 E0       ANDB   #$E0
841F: 58          ASLB
8420: 49          ROLA
8421: 58          ASLB
8422: 49          ROLA
8423: 58          ASLB
8424: 49          ROLA
8425: 97 BB       STA    $BB
8427: 86 20       LDA    #$20
8429: 90 BB       SUBA   $BB
842B: 97 BB       STA    $BB
842D: 39          RTS
842E: EC 16       LDD    -$A,X
8430: 10 93 58    CMPD   $58
8433: 2F 38       BLE    $846D
8435: FC 05 07    LDD    $0507
8438: A3 17       SUBD   -$9,X
843A: 83 80 00    SUBD   #$8000
843D: E3 17       ADDD   -$9,X
843F: ED 17       STD    -$9,X
8441: 25 0C       BCS    $844F
8443: E6 16       LDB    -$A,X
8445: 27 04       BEQ    $844B
8447: 6A 16       DEC    -$A,X
8449: 20 04       BRA    $844F
844B: E7 17       STB    -$9,X
844D: E7 18       STB    -$8,X
844F: A6 17       LDA    -$9,X
8451: 84 10       ANDA   #$10
8453: A8 84       EORA   ,X
8455: 26 16       BNE    $846D
8457: C6 10       LDB    #$10
8459: E8 84       EORB   ,X
845B: E7 84       STB    ,X
845D: 8D 0F       BSR    $846E
845F: 34 10       PSHS   X
8461: C6 01       LDB    #$01
8463: D7 2A       STB    $2A
8465: BD 86 77    JSR    $8677
8468: 35 10       PULS   X
846A: 7E 85 99    JMP    $8599
846D: 39          RTS
846E: E6 03       LDB    $3,X
8470: C5 01       BITB   #$01
8472: 10 26 00 AA LBNE   $8520
8476: DC 6C       LDD    $6C
8478: CB FF       ADDB   #$FF
847A: C4 1F       ANDB   #$1F
847C: 34 04       PSHS   B
847E: D6 6D       LDB    $6D
8480: C4 E0       ANDB   #$E0
8482: EA E0       ORB    ,S+
8484: 96 6C       LDA    $6C
8486: C3 00 20    ADDD   #$0020
8489: 84 01       ANDA   #$01
848B: 34 02       PSHS   A
848D: 96 6C       LDA    $6C
848F: 84 FE       ANDA   #$FE
8491: AA E0       ORA    ,S+
8493: 1F 03       TFR    D,U
8495: 8D 57       BSR    $84EE
8497: 10 8E 03 A0 LDY    #$03A0
849B: BD 82 62    JSR    $8262
849E: DC 6C       LDD    $6C
84A0: CB FF       ADDB   #$FF
84A2: C4 1F       ANDB   #$1F
84A4: 34 04       PSHS   B
84A6: D6 6D       LDB    $6D
84A8: C4 E0       ANDB   #$E0
84AA: EA E0       ORB    ,S+
84AC: 96 6C       LDA    $6C
84AE: C3 00 00    ADDD   #$0000
84B1: 84 01       ANDA   #$01
84B3: 34 02       PSHS   A
84B5: 96 6C       LDA    $6C
84B7: 84 FE       ANDA   #$FE
84B9: AA E0       ORA    ,S+
84BB: 1F 03       TFR    D,U
84BD: 8D 2F       BSR    $84EE
84BF: 10 8E 03 90 LDY    #$0390
84C3: BD 82 62    JSR    $8262
84C6: DC 6C       LDD    $6C
84C8: CB FF       ADDB   #$FF
84CA: C4 1F       ANDB   #$1F
84CC: 34 04       PSHS   B
84CE: D6 6D       LDB    $6D
84D0: C4 E0       ANDB   #$E0
84D2: EA E0       ORB    ,S+
84D4: 96 6C       LDA    $6C
84D6: C3 FF E0    ADDD   #$FFE0
84D9: 84 01       ANDA   #$01
84DB: 34 02       PSHS   A
84DD: 96 6C       LDA    $6C
84DF: 84 FE       ANDA   #$FE
84E1: AA E0       ORA    ,S+
84E3: 1F 03       TFR    D,U
84E5: 8D 07       BSR    $84EE
84E7: 10 8E 03 80 LDY    #$0380
84EB: 7E 82 62    JMP    $8262
84EE: E6 03       LDB    $3,X
84F0: C4 0F       ANDB   #$0F
84F2: C1 0D       CMPB   #$0D
84F4: 24 02       BCC    $84F8
84F6: 33 41       LEAU   $1,U
84F8: 8D 09       BSR    $8503
84FA: E6 03       LDB    $3,X
84FC: C4 0E       ANDB   #$0E
84FE: 58          ASLB
84FF: 58          ASLB
8500: 33 C5       LEAU   B,U
8502: 39          RTS
8503: C6 02       LDB    #$02
8505: F7 3E 00    STB    bankswitch_3e00
8508: E6 C4       LDB    ,U
850A: 4F          CLRA
850B: 58          ASLB
850C: 49          ROLA
850D: 10 8E 42 00 LDY    #$4200
8511: EC AB       LDD    D,Y
8513: DD E0       STD    $E0
8515: E6 C4       LDB    ,U
8517: 86 40       LDA    #$40
8519: 3D          MUL
851A: C3 40 00    ADDD   #$4000
851D: 1F 03       TFR    D,U
851F: 39          RTS
8520: DC 6C       LDD    $6C
8522: CB FF       ADDB   #$FF
8524: C4 1F       ANDB   #$1F
8526: 34 04       PSHS   B
8528: D6 6D       LDB    $6D
852A: C4 E0       ANDB   #$E0
852C: EA E0       ORB    ,S+
852E: 96 6C       LDA    $6C
8530: C3 00 20    ADDD   #$0020
8533: 84 01       ANDA   #$01
8535: 34 02       PSHS   A
8537: 96 6C       LDA    $6C
8539: 84 FE       ANDA   #$FE
853B: AA E0       ORA    ,S+
853D: 1F 03       TFR    D,U
853F: 8D AD       BSR    $84EE
8541: 10 8E 03 A0 LDY    #$03A0
8545: BD 83 28    JSR    $8328
8548: DC 6C       LDD    $6C
854A: CB FF       ADDB   #$FF
854C: C4 1F       ANDB   #$1F
854E: 34 04       PSHS   B
8550: D6 6D       LDB    $6D
8552: C4 E0       ANDB   #$E0
8554: EA E0       ORB    ,S+
8556: 96 6C       LDA    $6C
8558: C3 00 00    ADDD   #$0000
855B: 84 01       ANDA   #$01
855D: 34 02       PSHS   A
855F: 96 6C       LDA    $6C
8561: 84 FE       ANDA   #$FE
8563: AA E0       ORA    ,S+
8565: 1F 03       TFR    D,U
8567: 8D 85       BSR    $84EE
8569: 10 8E 03 90 LDY    #$0390
856D: BD 83 28    JSR    $8328
8570: DC 6C       LDD    $6C
8572: CB FF       ADDB   #$FF
8574: C4 1F       ANDB   #$1F
8576: 34 04       PSHS   B
8578: D6 6D       LDB    $6D
857A: C4 E0       ANDB   #$E0
857C: EA E0       ORB    ,S+
857E: 96 6C       LDA    $6C
8580: C3 FF E0    ADDD   #$FFE0
8583: 84 01       ANDA   #$01
8585: 34 02       PSHS   A
8587: 96 6C       LDA    $6C
8589: 84 FE       ANDA   #$FE
858B: AA E0       ORA    ,S+
858D: 1F 03       TFR    D,U
858F: BD 84 EE    JSR    $84EE
8592: 10 8E 03 80 LDY    #$0380
8596: 7E 83 28    JMP    $8328
8599: E6 02       LDB    $2,X
859B: 5A          DECB
859C: C4 1F       ANDB   #$1F
859E: E7 02       STB    $2,X
85A0: C5 0F       BITB   #$0F
85A2: 26 1F       BNE    $85C3
85A4: EC 08       LDD    $8,X
85A6: CB FF       ADDB   #$FF
85A8: C4 1F       ANDB   #$1F
85AA: 34 04       PSHS   B
85AC: E6 09       LDB    $9,X
85AE: C4 E0       ANDB   #$E0
85B0: EA E0       ORB    ,S+
85B2: A6 08       LDA    $8,X
85B4: C3 00 00    ADDD   #$0000
85B7: 84 01       ANDA   #$01
85B9: 34 02       PSHS   A
85BB: A6 08       LDA    $8,X
85BD: 84 FE       ANDA   #$FE
85BF: AA E0       ORA    ,S+
85C1: ED 0A       STD    $A,X
85C3: E6 0D       LDB    $D,X
85C5: 5A          DECB
85C6: C4 1F       ANDB   #$1F
85C8: E7 0D       STB    $D,X
85CA: E6 03       LDB    $3,X
85CC: 5A          DECB
85CD: C4 1F       ANDB   #$1F
85CF: E7 03       STB    $3,X
85D1: C4 0F       ANDB   #$0F
85D3: C1 0C       CMPB   #$0C
85D5: 26 2B       BNE    $8602
85D7: DC 6C       LDD    $6C
85D9: CB FF       ADDB   #$FF
85DB: C4 1F       ANDB   #$1F
85DD: 34 04       PSHS   B
85DF: D6 6D       LDB    $6D
85E1: C4 E0       ANDB   #$E0
85E3: EA E0       ORB    ,S+
85E5: 96 6C       LDA    $6C
85E7: C3 00 00    ADDD   #$0000
85EA: 84 01       ANDA   #$01
85EC: 34 02       PSHS   A
85EE: 96 6C       LDA    $6C
85F0: 84 FE       ANDA   #$FE
85F2: AA E0       ORA    ,S+
85F4: ED 1E       STD    -$2,X
85F6: DC 91       LDD    $91
85F8: 83 00 01    SUBD   #$0001
85FB: DD 91       STD    $91
85FD: C6 FF       LDB    #$FF
85FF: BD 8F 84    JSR    $8F84
8602: DC C2       LDD    $C2
8604: C3 FF E0    ADDD   #$FFE0
8607: 84 03       ANDA   #$03
8609: C4 E0       ANDB   #$E0
860B: DD E0       STD    $E0
860D: DC C2       LDD    $C2
860F: 84 FC       ANDA   #$FC
8611: C4 1F       ANDB   #$1F
8613: 9A E0       ORA    $E0
8615: DA E1       ORB    $E1
8617: DD C2       STD    $C2
8619: DC C6       LDD    $C6
861B: C3 FF E0    ADDD   #$FFE0
861E: 84 03       ANDA   #$03
8620: C4 E0       ANDB   #$E0
8622: DD E0       STD    $E0
8624: DC C6       LDD    $C6
8626: 84 FC       ANDA   #$FC
8628: C4 1F       ANDB   #$1F
862A: 9A E0       ORA    $E0
862C: DA E1       ORB    $E1
862E: DD C6       STD    $C6
8630: DC CA       LDD    $CA
8632: C3 FF E0    ADDD   #$FFE0
8635: 84 03       ANDA   #$03
8637: C4 E0       ANDB   #$E0
8639: DD E0       STD    $E0
863B: DC CA       LDD    $CA
863D: 84 FC       ANDA   #$FC
863F: C4 1F       ANDB   #$1F
8641: 9A E0       ORA    $E0
8643: DA E1       ORB    $E1
8645: DD CA       STD    $CA
8647: DC CE       LDD    $CE
8649: C3 FF E0    ADDD   #$FFE0
864C: 84 03       ANDA   #$03
864E: C4 E0       ANDB   #$E0
8650: DD E0       STD    $E0
8652: DC CE       LDD    $CE
8654: 84 FC       ANDA   #$FC
8656: C4 1F       ANDB   #$1F
8658: 9A E0       ORA    $E0
865A: DA E1       ORB    $E1
865C: DD CE       STD    $CE
865E: DC CA       LDD    $CA
8660: 84 03       ANDA   #$03
8662: C4 E0       ANDB   #$E0
8664: 58          ASLB
8665: 49          ROLA
8666: 58          ASLB
8667: 49          ROLA
8668: 58          ASLB
8669: 49          ROLA
866A: 97 BB       STA    $BB
866C: 86 20       LDA    #$20
866E: 90 BB       SUBA   $BB
8670: 97 BB       STA    $BB
8672: 39          RTS
8673: 00 C0       NEG    $C0
8675: 00 C4       NEG    $C4
8677: CE 86 73    LDU    #$8673
867A: D6 2A       LDB    $2A
867C: 58          ASLB
867D: AE D5       LDX    [B,U]
867F: 30 01       LEAX   $1,X
8681: 31 89 04 00 LEAY   $0400,X
8685: 0F 2A       CLR    $2A
8687: CE 03 88    LDU    #$0388
868A: F6 06 4E    LDB    $064E
868D: C4 0F       ANDB   #$0F
868F: 33 C5       LEAU   B,U
8691: D6 B8       LDB    $B8
8693: 8D 1C       BSR    $86B1
8695: 11 83 03 B0 CMPU   #$03B0
8699: 24 28       BCC    $86C3
869B: C6 20       LDB    #$20
869D: D0 B8       SUBB   $B8
869F: 27 22       BEQ    $86C3
86A1: D7 E6       STB    $E6
86A3: 1F 10       TFR    X,D
86A5: CA 1F       ORB    #$1F
86A7: 1F 01       TFR    D,X
86A9: D6 E6       LDB    $E6
86AB: 30 01       LEAX   $1,X
86AD: 31 89 04 00 LEAY   $0400,X
86B1: A6 C8 30    LDA    $30,U
86B4: A7 A2       STA    ,-Y
86B6: A6 C0       LDA    ,U+
86B8: A7 82       STA    ,-X
86BA: 11 83 03 B0 CMPU   #$03B0
86BE: 24 03       BCC    $86C3
86C0: 5A          DECB
86C1: 26 EE       BNE    $86B1
86C3: 39          RTS
86C4: 96 99       LDA    $99
86C6: 26 21       BNE    $86E9
86C8: FC 05 09    LDD    $0509
86CB: A3 19       SUBD   -$7,X
86CD: 10 83 00 93 CMPD   #$0093
86D1: 25 10       BCS    $86E3
86D3: CE 81 4E    LDU    #$814E
86D6: EF 1C       STU    -$4,X
86D8: 10 83 00 98 CMPD   #$0098
86DC: 25 05       BCS    $86E3
86DE: CE 81 52    LDU    #$8152
86E1: EF 1C       STU    -$4,X
86E3: 10 83 00 8F CMPD   #$008F
86E7: 24 27       BCC    $8710
86E9: CE 81 4A    LDU    #$814A
86EC: EF 1C       STU    -$4,X
86EE: FC 05 09    LDD    $0509
86F1: A3 19       SUBD   -$7,X
86F3: 10 83 00 89 CMPD   #$0089
86F7: 22 10       BHI    $8709
86F9: CE 81 4E    LDU    #$814E
86FC: EF 1C       STU    -$4,X
86FE: 10 83 00 84 CMPD   #$0084
8702: 22 05       BHI    $8709
8704: CE 81 52    LDU    #$8152
8707: EF 1C       STU    -$4,X
8709: 10 83 00 8E CMPD   #$008E
870D: 25 36       BCS    $8745
870F: 39          RTS
8710: EC 19       LDD    -$7,X
8712: 10 93 5C    CMPD   $5C
8715: 24 2D       BCC    $8744
8717: EE 1C       LDU    -$4,X
8719: EC 1A       LDD    -$6,X
871B: E3 C4       ADDD   ,U
871D: ED 1A       STD    -$6,X
871F: E6 C4       LDB    ,U
8721: 1D          SEX
8722: A9 19       ADCA   -$7,X
8724: A7 19       STA    -$7,X
8726: A6 1A       LDA    -$6,X
8728: 84 10       ANDA   #$10
872A: A8 01       EORA   $1,X
872C: 26 16       BNE    $8744
872E: C6 10       LDB    #$10
8730: E8 01       EORB   $1,X
8732: E7 01       STB    $1,X
8734: 8D 4D       BSR    $8783
8736: 34 10       PSHS   X
8738: C6 00       LDB    #$00
873A: D7 2B       STB    $2B
873C: BD 8A F2    JSR    $8AF2
873F: 35 10       PULS   X
8741: 7E 8B 45    JMP    $8B45
8744: 39          RTS
8745: EC 19       LDD    -$7,X
8747: 10 93 5E    CMPD   $5E
874A: 2F 36       BLE    $8782
874C: EE 1C       LDU    -$4,X
874E: EC 1A       LDD    -$6,X
8750: E3 42       ADDD   $2,U
8752: ED 1A       STD    -$6,X
8754: E6 42       LDB    $2,U
8756: 1D          SEX
8757: A9 19       ADCA   -$7,X
8759: A7 19       STA    -$7,X
875B: 2A 06       BPL    $8763
875D: 4F          CLRA
875E: 5F          CLRB
875F: ED 19       STD    -$7,X
8761: E7 1B       STB    -$5,X
8763: A6 1A       LDA    -$6,X
8765: 84 10       ANDA   #$10
8767: A8 01       EORA   $1,X
8769: 26 17       BNE    $8782
876B: C6 10       LDB    #$10
876D: E8 01       EORB   $1,X
876F: E7 01       STB    $1,X
8771: BD 88 A0    JSR    $88A0
8774: 34 10       PSHS   X
8776: C6 01       LDB    #$01
8778: D7 2B       STB    $2B
877A: BD 8A F2    JSR    $8AF2
877D: 35 10       PULS   X
877F: 7E 8B F6    JMP    $8BF6
8782: 39          RTS
8783: E6 04       LDB    $4,X
8785: C5 01       BITB   #$01
8787: 10 26 00 9C LBNE   $8827
878B: EC 08       LDD    $8,X
878D: CB FF       ADDB   #$FF
878F: C4 1F       ANDB   #$1F
8791: 34 04       PSHS   B
8793: E6 09       LDB    $9,X
8795: C4 E0       ANDB   #$E0
8797: EA E0       ORB    ,S+
8799: A6 08       LDA    $8,X
879B: C3 00 20    ADDD   #$0020
879E: 84 01       ANDA   #$01
87A0: 34 02       PSHS   A
87A2: A6 08       LDA    $8,X
87A4: 84 FE       ANDA   #$FE
87A6: AA E0       ORA    ,S+
87A8: 1F 03       TFR    D,U
87AA: 8D 57       BSR    $8803
87AC: 10 8E 03 E0 LDY    #$03E0
87B0: BD 89 7A    JSR    $897A
87B3: EC 08       LDD    $8,X
87B5: CB 00       ADDB   #$00
87B7: C4 1F       ANDB   #$1F
87B9: 34 04       PSHS   B
87BB: E6 09       LDB    $9,X
87BD: C4 E0       ANDB   #$E0
87BF: EA E0       ORB    ,S+
87C1: A6 08       LDA    $8,X
87C3: C3 00 20    ADDD   #$0020
87C6: 84 01       ANDA   #$01
87C8: 34 02       PSHS   A
87CA: A6 08       LDA    $8,X
87CC: 84 FE       ANDA   #$FE
87CE: AA E0       ORA    ,S+
87D0: 1F 03       TFR    D,U
87D2: 8D 2F       BSR    $8803
87D4: 10 8E 03 F0 LDY    #$03F0
87D8: BD 89 7A    JSR    $897A
87DB: EC 08       LDD    $8,X
87DD: CB 01       ADDB   #$01
87DF: C4 1F       ANDB   #$1F
87E1: 34 04       PSHS   B
87E3: E6 09       LDB    $9,X
87E5: C4 E0       ANDB   #$E0
87E7: EA E0       ORB    ,S+
87E9: A6 08       LDA    $8,X
87EB: C3 00 20    ADDD   #$0020
87EE: 84 01       ANDA   #$01
87F0: 34 02       PSHS   A
87F2: A6 08       LDA    $8,X
87F4: 84 FE       ANDA   #$FE
87F6: AA E0       ORA    ,S+
87F8: 1F 03       TFR    D,U
87FA: 8D 07       BSR    $8803
87FC: 10 8E 04 00 LDY    #$0400
8800: 7E 89 7A    JMP    $897A
8803: C6 02       LDB    #$02
8805: F7 3E 00    STB    bankswitch_3e00
8808: E6 C4       LDB    ,U
880A: 4F          CLRA
880B: 58          ASLB
880C: 49          ROLA
880D: 10 8E 42 00 LDY    #$4200
8811: EC AB       LDD    D,Y
8813: DD E0       STD    $E0
8815: E6 C4       LDB    ,U
8817: 86 40       LDA    #$40
8819: 3D          MUL
881A: C3 40 00    ADDD   #$4000
881D: 1F 03       TFR    D,U
881F: E6 04       LDB    $4,X
8821: C4 0E       ANDB   #$0E
8823: 54          LSRB
8824: 33 C5       LEAU   B,U
8826: 39          RTS
8827: EC 08       LDD    $8,X
8829: CB FF       ADDB   #$FF
882B: C4 1F       ANDB   #$1F
882D: 34 04       PSHS   B
882F: E6 09       LDB    $9,X
8831: C4 E0       ANDB   #$E0
8833: EA E0       ORB    ,S+
8835: A6 08       LDA    $8,X
8837: C3 00 20    ADDD   #$0020
883A: 84 01       ANDA   #$01
883C: 34 02       PSHS   A
883E: A6 08       LDA    $8,X
8840: 84 FE       ANDA   #$FE
8842: AA E0       ORA    ,S+
8844: 1F 03       TFR    D,U
8846: 8D BB       BSR    $8803
8848: 10 8E 03 E0 LDY    #$03E0
884C: BD 8A BC    JSR    $8ABC
884F: EC 08       LDD    $8,X
8851: CB 00       ADDB   #$00
8853: C4 1F       ANDB   #$1F
8855: 34 04       PSHS   B
8857: E6 09       LDB    $9,X
8859: C4 E0       ANDB   #$E0
885B: EA E0       ORB    ,S+
885D: A6 08       LDA    $8,X
885F: C3 00 20    ADDD   #$0020
8862: 84 01       ANDA   #$01
8864: 34 02       PSHS   A
8866: A6 08       LDA    $8,X
8868: 84 FE       ANDA   #$FE
886A: AA E0       ORA    ,S+
886C: 1F 03       TFR    D,U
886E: 8D 93       BSR    $8803
8870: 10 8E 03 F0 LDY    #$03F0
8874: BD 8A BC    JSR    $8ABC
8877: EC 08       LDD    $8,X
8879: CB 01       ADDB   #$01
887B: C4 1F       ANDB   #$1F
887D: 34 04       PSHS   B
887F: E6 09       LDB    $9,X
8881: C4 E0       ANDB   #$E0
8883: EA E0       ORB    ,S+
8885: A6 08       LDA    $8,X
8887: C3 00 20    ADDD   #$0020
888A: 84 01       ANDA   #$01
888C: 34 02       PSHS   A
888E: A6 08       LDA    $8,X
8890: 84 FE       ANDA   #$FE
8892: AA E0       ORA    ,S+
8894: 1F 03       TFR    D,U
8896: BD 88 03    JSR    $8803
8899: 10 8E 04 00 LDY    #$0400
889D: 7E 8A BC    JMP    $8ABC
88A0: E6 05       LDB    $5,X
88A2: C5 01       BITB   #$01
88A4: 10 26 01 41 LBNE   $89E9
88A8: EC 08       LDD    $8,X
88AA: CB FF       ADDB   #$FF
88AC: C4 1F       ANDB   #$1F
88AE: 34 04       PSHS   B
88B0: E6 09       LDB    $9,X
88B2: C4 E0       ANDB   #$E0
88B4: EA E0       ORB    ,S+
88B6: A6 08       LDA    $8,X
88B8: C3 FF E0    ADDD   #$FFE0
88BB: 84 01       ANDA   #$01
88BD: 34 02       PSHS   A
88BF: A6 08       LDA    $8,X
88C1: 84 FE       ANDA   #$FE
88C3: AA E0       ORA    ,S+
88C5: DD E4       STD    $E4
88C7: EC 08       LDD    $8,X
88C9: CB FF       ADDB   #$FF
88CB: C4 1F       ANDB   #$1F
88CD: 34 04       PSHS   B
88CF: E6 09       LDB    $9,X
88D1: C4 E0       ANDB   #$E0
88D3: EA E0       ORB    ,S+
88D5: A6 08       LDA    $8,X
88D7: C3 00 00    ADDD   #$0000
88DA: 84 01       ANDA   #$01
88DC: 34 02       PSHS   A
88DE: A6 08       LDA    $8,X
88E0: 84 FE       ANDA   #$FE
88E2: AA E0       ORA    ,S+
88E4: DD E9       STD    $E9
88E6: BD 89 AC    JSR    $89AC
88E9: 10 8E 03 E0 LDY    #$03E0
88ED: BD 89 7A    JSR    $897A
88F0: EC 08       LDD    $8,X
88F2: CB 00       ADDB   #$00
88F4: C4 1F       ANDB   #$1F
88F6: 34 04       PSHS   B
88F8: E6 09       LDB    $9,X
88FA: C4 E0       ANDB   #$E0
88FC: EA E0       ORB    ,S+
88FE: A6 08       LDA    $8,X
8900: C3 FF E0    ADDD   #$FFE0
8903: 84 01       ANDA   #$01
8905: 34 02       PSHS   A
8907: A6 08       LDA    $8,X
8909: 84 FE       ANDA   #$FE
890B: AA E0       ORA    ,S+
890D: DD E4       STD    $E4
890F: EC 08       LDD    $8,X
8911: CB 00       ADDB   #$00
8913: C4 1F       ANDB   #$1F
8915: 34 04       PSHS   B
8917: E6 09       LDB    $9,X
8919: C4 E0       ANDB   #$E0
891B: EA E0       ORB    ,S+
891D: A6 08       LDA    $8,X
891F: C3 00 00    ADDD   #$0000
8922: 84 01       ANDA   #$01
8924: 34 02       PSHS   A
8926: A6 08       LDA    $8,X
8928: 84 FE       ANDA   #$FE
892A: AA E0       ORA    ,S+
892C: DD E9       STD    $E9
892E: 8D 7C       BSR    $89AC
8930: 10 8E 03 F0 LDY    #$03F0
8934: 8D 44       BSR    $897A
8936: EC 08       LDD    $8,X
8938: CB 01       ADDB   #$01
893A: C4 1F       ANDB   #$1F
893C: 34 04       PSHS   B
893E: E6 09       LDB    $9,X
8940: C4 E0       ANDB   #$E0
8942: EA E0       ORB    ,S+
8944: A6 08       LDA    $8,X
8946: C3 FF E0    ADDD   #$FFE0
8949: 84 01       ANDA   #$01
894B: 34 02       PSHS   A
894D: A6 08       LDA    $8,X
894F: 84 FE       ANDA   #$FE
8951: AA E0       ORA    ,S+
8953: DD E4       STD    $E4
8955: EC 08       LDD    $8,X
8957: CB 01       ADDB   #$01
8959: C4 1F       ANDB   #$1F
895B: 34 04       PSHS   B
895D: E6 09       LDB    $9,X
895F: C4 E0       ANDB   #$E0
8961: EA E0       ORB    ,S+
8963: A6 08       LDA    $8,X
8965: C3 00 00    ADDD   #$0000
8968: 84 01       ANDA   #$01
896A: 34 02       PSHS   A
896C: A6 08       LDA    $8,X
896E: 84 FE       ANDA   #$FE
8970: AA E0       ORA    ,S+
8972: DD E9       STD    $E9
8974: 8D 36       BSR    $89AC
8976: 10 8E 04 00 LDY    #$0400
897A: 34 10       PSHS   X
897C: C6 08       LDB    #$08
897E: D7 E2       STB    $E2
8980: C6 00       LDB    #$00
8982: F7 3E 00    STB    bankswitch_3e00
8985: E6 C4       LDB    ,U
8987: 33 48       LEAU   $8,U
8989: 4F          CLRA
898A: 58          ASLB
898B: 49          ROLA
898C: 58          ASLB
898D: 49          ROLA
898E: 58          ASLB
898F: 49          ROLA
8990: D3 E0       ADDD   $E0
8992: 1F 01       TFR    D,X
8994: C6 01       LDB    #$01
8996: F7 3E 00    STB    bankswitch_3e00
8999: A6 04       LDA    $4,X
899B: E6 06       LDB    $6,X
899D: ED A8 30    STD    $30,Y
89A0: A6 84       LDA    ,X
89A2: E6 02       LDB    $2,X
89A4: ED A1       STD    ,Y++
89A6: 0A E2       DEC    $E2
89A8: 26 D6       BNE    $8980
89AA: 35 90       PULS   X,PC
89AC: E6 05       LDB    $5,X
89AE: C4 0F       ANDB   #$0F
89B0: C1 0D       CMPB   #$0D
89B2: 24 0C       BCC    $89C0
89B4: DE E9       LDU    $E9
89B6: 8D 14       BSR    $89CC
89B8: E6 05       LDB    $5,X
89BA: C4 0E       ANDB   #$0E
89BC: 54          LSRB
89BD: 33 C5       LEAU   B,U
89BF: 39          RTS
89C0: DE E4       LDU    $E4
89C2: 8D 08       BSR    $89CC
89C4: E6 05       LDB    $5,X
89C6: C4 0E       ANDB   #$0E
89C8: 54          LSRB
89C9: 33 C5       LEAU   B,U
89CB: 39          RTS
89CC: C6 02       LDB    #$02
89CE: F7 3E 00    STB    bankswitch_3e00
89D1: E6 C4       LDB    ,U
89D3: 4F          CLRA
89D4: 58          ASLB
89D5: 49          ROLA
89D6: 10 8E 42 00 LDY    #$4200
89DA: EC AB       LDD    D,Y
89DC: DD E0       STD    $E0
89DE: E6 C4       LDB    ,U
89E0: 86 40       LDA    #$40
89E2: 3D          MUL
89E3: C3 40 00    ADDD   #$4000
89E6: 1F 03       TFR    D,U
89E8: 39          RTS
89E9: EC 08       LDD    $8,X
89EB: CB FF       ADDB   #$FF
89ED: C4 1F       ANDB   #$1F
89EF: 34 04       PSHS   B
89F1: E6 09       LDB    $9,X
89F3: C4 E0       ANDB   #$E0
89F5: EA E0       ORB    ,S+
89F7: A6 08       LDA    $8,X
89F9: C3 FF E0    ADDD   #$FFE0
89FC: 84 01       ANDA   #$01
89FE: 34 02       PSHS   A
8A00: A6 08       LDA    $8,X
8A02: 84 FE       ANDA   #$FE
8A04: AA E0       ORA    ,S+
8A06: DD E4       STD    $E4
8A08: EC 08       LDD    $8,X
8A0A: CB FF       ADDB   #$FF
8A0C: C4 1F       ANDB   #$1F
8A0E: 34 04       PSHS   B
8A10: E6 09       LDB    $9,X
8A12: C4 E0       ANDB   #$E0
8A14: EA E0       ORB    ,S+
8A16: A6 08       LDA    $8,X
8A18: C3 00 00    ADDD   #$0000
8A1B: 84 01       ANDA   #$01
8A1D: 34 02       PSHS   A
8A1F: A6 08       LDA    $8,X
8A21: 84 FE       ANDA   #$FE
8A23: AA E0       ORA    ,S+
8A25: DD E9       STD    $E9
8A27: 8D 83       BSR    $89AC
8A29: 10 8E 03 E0 LDY    #$03E0
8A2D: BD 8A BC    JSR    $8ABC
8A30: EC 08       LDD    $8,X
8A32: CB 00       ADDB   #$00
8A34: C4 1F       ANDB   #$1F
8A36: 34 04       PSHS   B
8A38: E6 09       LDB    $9,X
8A3A: C4 E0       ANDB   #$E0
8A3C: EA E0       ORB    ,S+
8A3E: A6 08       LDA    $8,X
8A40: C3 FF E0    ADDD   #$FFE0
8A43: 84 01       ANDA   #$01
8A45: 34 02       PSHS   A
8A47: A6 08       LDA    $8,X
8A49: 84 FE       ANDA   #$FE
8A4B: AA E0       ORA    ,S+
8A4D: DD E4       STD    $E4
8A4F: EC 08       LDD    $8,X
8A51: CB 00       ADDB   #$00
8A53: C4 1F       ANDB   #$1F
8A55: 34 04       PSHS   B
8A57: E6 09       LDB    $9,X
8A59: C4 E0       ANDB   #$E0
8A5B: EA E0       ORB    ,S+
8A5D: A6 08       LDA    $8,X
8A5F: C3 00 00    ADDD   #$0000
8A62: 84 01       ANDA   #$01
8A64: 34 02       PSHS   A
8A66: A6 08       LDA    $8,X
8A68: 84 FE       ANDA   #$FE
8A6A: AA E0       ORA    ,S+
8A6C: DD E9       STD    $E9
8A6E: BD 89 AC    JSR    $89AC
8A71: 10 8E 03 F0 LDY    #$03F0
8A75: 8D 45       BSR    $8ABC
8A77: EC 08       LDD    $8,X
8A79: CB 01       ADDB   #$01
8A7B: C4 1F       ANDB   #$1F
8A7D: 34 04       PSHS   B
8A7F: E6 09       LDB    $9,X
8A81: C4 E0       ANDB   #$E0
8A83: EA E0       ORB    ,S+
8A85: A6 08       LDA    $8,X
8A87: C3 FF E0    ADDD   #$FFE0
8A8A: 84 01       ANDA   #$01
8A8C: 34 02       PSHS   A
8A8E: A6 08       LDA    $8,X
8A90: 84 FE       ANDA   #$FE
8A92: AA E0       ORA    ,S+
8A94: DD E4       STD    $E4
8A96: EC 08       LDD    $8,X
8A98: CB 01       ADDB   #$01
8A9A: C4 1F       ANDB   #$1F
8A9C: 34 04       PSHS   B
8A9E: E6 09       LDB    $9,X
8AA0: C4 E0       ANDB   #$E0
8AA2: EA E0       ORB    ,S+
8AA4: A6 08       LDA    $8,X
8AA6: C3 00 00    ADDD   #$0000
8AA9: 84 01       ANDA   #$01
8AAB: 34 02       PSHS   A
8AAD: A6 08       LDA    $8,X
8AAF: 84 FE       ANDA   #$FE
8AB1: AA E0       ORA    ,S+
8AB3: DD E9       STD    $E9
8AB5: BD 89 AC    JSR    $89AC
8AB8: 10 8E 04 00 LDY    #$0400
8ABC: 34 10       PSHS   X
8ABE: C6 08       LDB    #$08
8AC0: D7 E2       STB    $E2
8AC2: C6 00       LDB    #$00
8AC4: F7 3E 00    STB    bankswitch_3e00
8AC7: E6 C4       LDB    ,U
8AC9: 33 48       LEAU   $8,U
8ACB: 4F          CLRA
8ACC: 58          ASLB
8ACD: 49          ROLA
8ACE: 58          ASLB
8ACF: 49          ROLA
8AD0: 58          ASLB
8AD1: 49          ROLA
8AD2: D3 E0       ADDD   $E0
8AD4: 1F 01       TFR    D,X
8AD6: C6 01       LDB    #$01
8AD8: F7 3E 00    STB    bankswitch_3e00
8ADB: A6 05       LDA    $5,X
8ADD: E6 07       LDB    $7,X
8ADF: ED A8 30    STD    $30,Y
8AE2: A6 01       LDA    $1,X
8AE4: E6 03       LDB    $3,X
8AE6: ED A1       STD    ,Y++
8AE8: 0A E2       DEC    $E2
8AEA: 26 D6       BNE    $8AC2
8AEC: 35 90       PULS   X,PC
8AEE: 00 C8       NEG    $C8
8AF0: 00 CC       NEG    $CC
8AF2: CE 8A EE    LDU    #$8AEE
8AF5: D6 2B       LDB    $2B
8AF7: 58          ASLB
8AF8: AE D5       LDX    [B,U]
8AFA: 31 89 04 00 LEAY   $0400,X
8AFE: 0F 2B       CLR    $2B
8B00: CE 03 E8    LDU    #$03E8
8B03: F6 06 4C    LDB    $064C
8B06: C4 0F       ANDB   #$0F
8B08: 33 C5       LEAU   B,U
8B0A: D6 BA       LDB    $BA
8B0C: 8D 1E       BSR    $8B2C
8B0E: 11 83 04 10 CMPU   #$0410
8B12: 24 30       BCC    $8B44
8B14: C6 20       LDB    #$20
8B16: D0 BA       SUBB   $BA
8B18: 27 2A       BEQ    $8B44
8B1A: D7 E6       STB    $E6
8B1C: 1F 10       TFR    X,D
8B1E: 84 03       ANDA   #$03
8B20: C4 1F       ANDB   #$1F
8B22: 8B 28       ADDA   #$28
8B24: 1F 01       TFR    D,X
8B26: D6 E6       LDB    $E6
8B28: 31 89 04 00 LEAY   $0400,X
8B2C: A6 C8 30    LDA    $30,U
8B2F: A7 A4       STA    ,Y
8B31: 31 A8 20    LEAY   $20,Y
8B34: A6 C0       LDA    ,U+
8B36: A7 84       STA    ,X
8B38: 30 88 20    LEAX   $20,X
8B3B: 11 83 04 10 CMPU   #$0410
8B3F: 24 03       BCC    $8B44
8B41: 5A          DECB
8B42: 26 E8       BNE    $8B2C
8B44: 39          RTS
8B45: E6 05       LDB    $5,X
8B47: 5C          INCB
8B48: C4 1F       ANDB   #$1F
8B4A: E7 05       STB    $5,X
8B4C: C4 0F       ANDB   #$0F
8B4E: C1 0E       CMPB   #$0E
8B50: 26 1F       BNE    $8B71
8B52: EC 1E       LDD    -$2,X
8B54: CB 00       ADDB   #$00
8B56: C4 1F       ANDB   #$1F
8B58: 34 04       PSHS   B
8B5A: E6 1F       LDB    -$1,X
8B5C: C4 E0       ANDB   #$E0
8B5E: EA E0       ORB    ,S+
8B60: A6 1E       LDA    -$2,X
8B62: C3 00 20    ADDD   #$0020
8B65: 84 01       ANDA   #$01
8B67: 34 02       PSHS   A
8B69: A6 1E       LDA    -$2,X
8B6B: 84 FE       ANDA   #$FE
8B6D: AA E0       ORA    ,S+
8B6F: ED 1E       STD    -$2,X
8B71: E6 0F       LDB    $F,X
8B73: 5C          INCB
8B74: C4 1F       ANDB   #$1F
8B76: E7 0F       STB    $F,X
8B78: E6 04       LDB    $4,X
8B7A: 5C          INCB
8B7B: C4 1F       ANDB   #$1F
8B7D: E7 04       STB    $4,X
8B7F: C5 0F       BITB   #$0F
8B81: 26 2B       BNE    $8BAE
8B83: EC 0A       LDD    $A,X
8B85: CB 00       ADDB   #$00
8B87: C4 1F       ANDB   #$1F
8B89: 34 04       PSHS   B
8B8B: E6 0B       LDB    $B,X
8B8D: C4 E0       ANDB   #$E0
8B8F: EA E0       ORB    ,S+
8B91: A6 0A       LDA    $A,X
8B93: C3 00 20    ADDD   #$0020
8B96: 84 01       ANDA   #$01
8B98: 34 02       PSHS   A
8B9A: A6 0A       LDA    $A,X
8B9C: 84 FE       ANDA   #$FE
8B9E: AA E0       ORA    ,S+
8BA0: ED 0A       STD    $A,X
8BA2: DC 91       LDD    $91
8BA4: C3 00 20    ADDD   #$0020
8BA7: DD 91       STD    $91
8BA9: C6 20       LDB    #$20
8BAB: BD 8F 84    JSR    $8F84
8BAE: D6 C3       LDB    $C3
8BB0: CB FF       ADDB   #$FF
8BB2: C4 1F       ANDB   #$1F
8BB4: D7 E0       STB    $E0
8BB6: D6 C3       LDB    $C3
8BB8: C4 E0       ANDB   #$E0
8BBA: DA E0       ORB    $E0
8BBC: D7 C3       STB    $C3
8BBE: D6 C7       LDB    $C7
8BC0: CB FF       ADDB   #$FF
8BC2: C4 1F       ANDB   #$1F
8BC4: D7 E0       STB    $E0
8BC6: D6 C7       LDB    $C7
8BC8: C4 E0       ANDB   #$E0
8BCA: DA E0       ORB    $E0
8BCC: D7 C7       STB    $C7
8BCE: D6 CB       LDB    $CB
8BD0: CB FF       ADDB   #$FF
8BD2: C4 1F       ANDB   #$1F
8BD4: D7 E0       STB    $E0
8BD6: D6 CB       LDB    $CB
8BD8: C4 E0       ANDB   #$E0
8BDA: DA E0       ORB    $E0
8BDC: D7 CB       STB    $CB
8BDE: D6 CF       LDB    $CF
8BE0: CB FF       ADDB   #$FF
8BE2: C4 1F       ANDB   #$1F
8BE4: D7 E0       STB    $E0
8BE6: D6 CF       LDB    $CF
8BE8: C4 E0       ANDB   #$E0
8BEA: DA E0       ORB    $E0
8BEC: D7 CF       STB    $CF
8BEE: DC C2       LDD    $C2
8BF0: C4 1F       ANDB   #$1F
8BF2: 5C          INCB
8BF3: D7 B9       STB    $B9
8BF5: 39          RTS
8BF6: E6 04       LDB    $4,X
8BF8: 5A          DECB
8BF9: C4 1F       ANDB   #$1F
8BFB: E7 04       STB    $4,X
8BFD: C5 0F       BITB   #$0F
8BFF: 26 1F       BNE    $8C20
8C01: EC 1E       LDD    -$2,X
8C03: CB 00       ADDB   #$00
8C05: C4 1F       ANDB   #$1F
8C07: 34 04       PSHS   B
8C09: E6 1F       LDB    -$1,X
8C0B: C4 E0       ANDB   #$E0
8C0D: EA E0       ORB    ,S+
8C0F: A6 1E       LDA    -$2,X
8C11: C3 FF E0    ADDD   #$FFE0
8C14: 84 01       ANDA   #$01
8C16: 34 02       PSHS   A
8C18: A6 1E       LDA    -$2,X
8C1A: 84 FE       ANDA   #$FE
8C1C: AA E0       ORA    ,S+
8C1E: ED 1E       STD    -$2,X
8C20: E6 0F       LDB    $F,X
8C22: 5A          DECB
8C23: C4 1F       ANDB   #$1F
8C25: E7 0F       STB    $F,X
8C27: E6 05       LDB    $5,X
8C29: 5A          DECB
8C2A: C4 1F       ANDB   #$1F
8C2C: E7 05       STB    $5,X
8C2E: C4 0F       ANDB   #$0F
8C30: C1 0C       CMPB   #$0C
8C32: 26 2B       BNE    $8C5F
8C34: EC 0A       LDD    $A,X
8C36: CB 00       ADDB   #$00
8C38: C4 1F       ANDB   #$1F
8C3A: 34 04       PSHS   B
8C3C: E6 0B       LDB    $B,X
8C3E: C4 E0       ANDB   #$E0
8C40: EA E0       ORB    ,S+
8C42: A6 0A       LDA    $A,X
8C44: C3 FF E0    ADDD   #$FFE0
8C47: 84 01       ANDA   #$01
8C49: 34 02       PSHS   A
8C4B: A6 0A       LDA    $A,X
8C4D: 84 FE       ANDA   #$FE
8C4F: AA E0       ORA    ,S+
8C51: ED 0A       STD    $A,X
8C53: DC 91       LDD    $91
8C55: 83 00 20    SUBD   #$0020
8C58: DD 91       STD    $91
8C5A: C6 E0       LDB    #$E0
8C5C: BD 8F 84    JSR    $8F84
8C5F: D6 C3       LDB    $C3
8C61: CB 01       ADDB   #$01
8C63: C4 1F       ANDB   #$1F
8C65: D7 E0       STB    $E0
8C67: D6 C3       LDB    $C3
8C69: C4 E0       ANDB   #$E0
8C6B: DA E0       ORB    $E0
8C6D: D7 C3       STB    $C3
8C6F: D6 C7       LDB    $C7
8C71: CB 01       ADDB   #$01
8C73: C4 1F       ANDB   #$1F
8C75: D7 E0       STB    $E0
8C77: D6 C7       LDB    $C7
8C79: C4 E0       ANDB   #$E0
8C7B: DA E0       ORB    $E0
8C7D: D7 C7       STB    $C7
8C7F: D6 CB       LDB    $CB
8C81: CB 01       ADDB   #$01
8C83: C4 1F       ANDB   #$1F
8C85: D7 E0       STB    $E0
8C87: D6 CB       LDB    $CB
8C89: C4 E0       ANDB   #$E0
8C8B: DA E0       ORB    $E0
8C8D: D7 CB       STB    $CB
8C8F: D6 CF       LDB    $CF
8C91: CB 01       ADDB   #$01
8C93: C4 1F       ANDB   #$1F
8C95: D7 E0       STB    $E0
8C97: D6 CF       LDB    $CF
8C99: C4 E0       ANDB   #$E0
8C9B: DA E0       ORB    $E0
8C9D: D7 CF       STB    $CF
8C9F: DC C2       LDD    $C2
8CA1: C4 1F       ANDB   #$1F
8CA3: 5C          INCB
8CA4: D7 B9       STB    $B9
8CA6: 39          RTS
8CA7: 34 40       PSHS   U
8CA9: CE 8D A6    LDU    #$8DA6
8CAC: E6 1F       LDB    -$1,X
8CAE: 58          ASLB
8CAF: 58          ASLB
8CB0: 33 C5       LEAU   B,U
8CB2: EC 16       LDD    -$A,X
8CB4: A3 C1       SUBD   ,U++
8CB6: DD EC       STD    $EC
8CB8: EC 19       LDD    -$7,X
8CBA: A3 C4       SUBD   ,U
8CBC: 35 40       PULS   U
8CBE: DD EE       STD    $EE
8CC0: BD 8D D2    JSR    $8DD2
8CC3: 10 AF 7E    STY    -$2,S
8CC6: DD E8       STD    $E8
8CC8: E6 A9 04 00 LDB    $0400,Y
8CCC: C4 C0       ANDB   #$C0
8CCE: 26 10       BNE    $8CE0
8CD0: E6 A4       LDB    ,Y
8CD2: 10 8E 42 C0 LDY    #$42C0
8CD6: A6 A5       LDA    B,Y
8CD8: 27 06       BEQ    $8CE0
8CDA: E6 A5       LDB    B,Y
8CDC: D0 E9       SUBB   $E9
8CDE: 24 37       BCC    $8D17
8CE0: EC 7E       LDD    -$2,S
8CE2: 83 28 00    SUBD   #$2800
8CE5: ED 7E       STD    -$2,S
8CE7: E6 1F       LDB    -$1,X
8CE9: 58          ASLB
8CEA: 58          ASLB
8CEB: 10 8E 8D 7A LDY    #$8D7A
8CEF: EC A5       LDD    B,Y
8CF1: 58          ASLB
8CF2: 49          ROLA
8CF3: E3 7E       ADDD   -$2,S
8CF5: 84 03       ANDA   #$03
8CF7: 10 8E 28 00 LDY    #$2800
8CFB: 31 AB       LEAY   D,Y
8CFD: E6 A9 04 00 LDB    $0400,Y
8D01: C4 C0       ANDB   #$C0
8D03: 26 10       BNE    $8D15
8D05: E6 A4       LDB    ,Y
8D07: 10 8E 42 C0 LDY    #$42C0
8D0B: A6 A5       LDA    B,Y
8D0D: 27 06       BEQ    $8D15
8D0F: E6 A5       LDB    B,Y
8D11: D0 E9       SUBB   $E9
8D13: 24 02       BCC    $8D17
8D15: 4F          CLRA
8D16: 39          RTS
8D17: 1A 01       ORCC   #$01
8D19: 39          RTS
8D1A: EC 16       LDD    -$A,X
8D1C: C3 00 10    ADDD   #$0010
8D1F: DD EC       STD    $EC
8D21: EC 19       LDD    -$7,X
8D23: 83 00 08    SUBD   #$0008
8D26: DD EE       STD    $EE
8D28: BD 8D D2    JSR    $8DD2
8D2B: E6 A9 04 00 LDB    $0400,Y
8D2F: C4 C0       ANDB   #$C0
8D31: 26 14       BNE    $8D47
8D33: DD E8       STD    $E8
8D35: E6 A4       LDB    ,Y
8D37: 10 8E 43 C0 LDY    #$43C0
8D3B: 31 A5       LEAY   B,Y
8D3D: 6D A4       TST    ,Y
8D3F: 27 06       BEQ    $8D47
8D41: D6 E8       LDB    $E8
8D43: E0 A4       SUBB   ,Y
8D45: 24 02       BCC    $8D49
8D47: 5F          CLRB
8D48: 39          RTS
8D49: 1A 01       ORCC   #$01
8D4B: 39          RTS
8D4C: EC 16       LDD    -$A,X
8D4E: 83 00 10    SUBD   #$0010
8D51: DD EC       STD    $EC
8D53: EC 19       LDD    -$7,X
8D55: 83 00 08    SUBD   #$0008
8D58: DD EE       STD    $EE
8D5A: BD 8D D2    JSR    $8DD2
8D5D: E6 A9 04 00 LDB    $0400,Y
8D61: C4 C0       ANDB   #$C0
8D63: 26 10       BNE    $8D75
8D65: 97 E8       STA    $E8
8D67: E6 A4       LDB    ,Y
8D69: 10 8E 44 C0 LDY    #$44C0
8D6D: E6 A5       LDB    B,Y
8D6F: 27 04       BEQ    $8D75
8D71: D0 E8       SUBB   $E8
8D73: 24 02       BCC    $8D77
8D75: 5F          CLRB
8D76: 39          RTS
8D77: 1A 01       ORCC   #$01
8D79: 39          RTS
8D7A: 00 10       NEG    $10
8D7C: 00 10       NEG    $10
8D7E: 00 10       NEG    $10
8D80: 00 20       NEG    $20
8D82: 00 20       NEG    $20
8D84: 00 10       NEG    $10
8D86: 00 10       NEG    $10
8D88: 00 20       NEG    $20
8D8A: 00 30       NEG    $30
8D8C: 00 30       NEG    $30
8D8E: 00 30       NEG    $30
8D90: 00 10       NEG    $10
8D92: 00 40       NEG    $40
8D94: 00 40       NEG    $40
8D96: 00 40       NEG    $40
8D98: 00 10       NEG    $10
8D9A: 00 10       NEG    $10
8D9C: 00 30       NEG    $30
8D9E: 00 30       NEG    $30
8DA0: 00 20       NEG    $20
8DA2: 00 10       NEG    $10
8DA4: 00 40       NEG    $40
8DA6: 00 08       NEG    $08
8DA8: 00 08       NEG    $08
8DAA: 00 08       NEG    $08
8DAC: 00 10       NEG    $10
8DAE: 00 10       NEG    $10
8DB0: 00 08       NEG    $08
8DB2: 00 08       NEG    $08
8DB4: 00 10       NEG    $10
8DB6: 00 18       NEG    $18
8DB8: 00 18       NEG    $18
8DBA: 00 18       NEG    $18
8DBC: 00 08       NEG    $08
8DBE: 00 20       NEG    $20
8DC0: 00 20       NEG    $20
8DC2: 00 20       NEG    $20
8DC4: 00 08       NEG    $08
8DC6: 00 08       NEG    $08
8DC8: 00 18       NEG    $18
8DCA: 00 18       NEG    $18
8DCC: 00 10       NEG    $10
8DCE: 00 08       NEG    $08
8DD0: 00 20       NEG    $20
8DD2: DC EE       LDD    $EE
8DD4: C4 0F       ANDB   #$0F
8DD6: 34 04       PSHS   B
8DD8: D6 EF       LDB    $EF
8DDA: 53          COMB
8DDB: 44          LSRA
8DDC: 56          RORB
8DDD: 54          LSRB
8DDE: 54          LSRB
8DDF: 54          LSRB
8DE0: 86 28       LDA    #$28
8DE2: C4 1F       ANDB   #$1F
8DE4: CB 00       ADDB   #$00
8DE6: DD EA       STD    $EA
8DE8: DC EC       LDD    $EC
8DEA: C4 0F       ANDB   #$0F
8DEC: 34 04       PSHS   B
8DEE: D6 ED       LDB    $ED
8DF0: 58          ASLB
8DF1: 49          ROLA
8DF2: 84 03       ANDA   #$03
8DF4: C4 E0       ANDB   #$E0
8DF6: D3 EA       ADDD   $EA
8DF8: 1F 02       TFR    D,Y
8DFA: 35 86       PULS   D,PC
8DFC: D6 93       LDB    $93
8DFE: 27 0A       BEQ    $8E0A
8E00: DE 94       LDU    $94
8E02: 37 20       PULU   Y
8E04: DF 94       STU    $94
8E06: 0A 93       DEC    $93
8E08: 4F          CLRA
8E09: 39          RTS
8E0A: 53          COMB
8E0B: 39          RTS
8E0C: DE 94       LDU    $94
8E0E: 36 10       PSHU   X
8E10: DF 94       STU    $94
8E12: 0C 93       INC    $93
8E14: 39          RTS
8E15: D6 98       LDB    $98
8E17: 27 0A       BEQ    $8E23
8E19: DE 96       LDU    $96
8E1B: 37 20       PULU   Y
8E1D: DF 96       STU    $96
8E1F: 0A 98       DEC    $98
8E21: 4F          CLRA
8E22: 39          RTS
8E23: 53          COMB
8E24: 39          RTS
8E25: DE 96       LDU    $96
8E27: 36 10       PSHU   X
8E29: DF 96       STU    $96
8E2B: 0C 98       INC    $98
8E2D: 39          RTS
8E2E: DE A8       LDU    $A8
8E30: 37 20       PULU   Y
8E32: DF A8       STU    $A8
8E34: 0A A7       DEC    $A7
8E36: 4F          CLRA
8E37: 39          RTS
8E38: DE A8       LDU    $A8
8E3A: 36 10       PSHU   X
8E3C: DF A8       STU    $A8
8E3E: 0C A7       INC    $A7
8E40: 39          RTS
8E41: 6F 11       CLR    -$F,X
8E43: E6 1F       LDB    -$1,X
8E45: 58          ASLB
8E46: 58          ASLB
8E47: 58          ASLB
8E48: 10 8E 8E 67 LDY    #$8E67
8E4C: 31 A5       LEAY   B,Y
8E4E: EC A4       LDD    ,Y
8E50: E3 16       ADDD   -$A,X
8E52: 93 9C       SUBD   $9C
8E54: 10 A3 22    CMPD   $2,Y
8E57: 22 0D       BHI    $8E66
8E59: EC 24       LDD    $4,Y
8E5B: E3 19       ADDD   -$7,X
8E5D: 93 9E       SUBD   $9E
8E5F: 10 A3 26    CMPD   $6,Y
8E62: 22 02       BHI    $8E66
8E64: 6C 11       INC    -$F,X
8E66: 39          RTS

8EBF: E1 1F       CMPB   -$1,X
8EC1: 27 11       BEQ    $8ED4
8EC3: A6 1F       LDA    -$1,X
8EC5: CE 8E D5    LDU    #$8ED5
8EC8: 48          ASLA
8EC9: EE C6       LDU    A,U
8ECB: E7 1F       STB    -$1,X
8ECD: E6 C5       LDB    B,U
8ECF: 1D          SEX
8ED0: E3 19       ADDD   -$7,X
8ED2: ED 19       STD    -$7,X
8ED4: 39          RTS

8F62: EC 16       LDD    -$A,X
8F64: 93 9C       SUBD   $9C
8F66: C3 00 80    ADDD   #$0080
8F69: 10 83 02 00 CMPD   #$0200
8F6D: 22 0D       BHI    $8F7C
8F6F: EC 19       LDD    -$7,X
8F71: 93 9E       SUBD   $9E
8F73: C3 00 40    ADDD   #$0040
8F76: 10 83 01 80 CMPD   #$0180
8F7A: 23 07       BLS    $8F83
8F7C: CC 03 00    LDD    #$0300
8F7F: ED 13       STD    -$D,X
8F81: E7 15       STB    -$B,X
8F83: 39          RTS
8F84: 86 02       LDA    #$02
8F86: B7 3E 00    STA    bankswitch_3e00
8F89: E7 06       STB    $6,X
8F8B: DC 91       LDD    $91
8F8D: 58          ASLB
8F8E: 49          ROLA
8F8F: 58          ASLB
8F90: 49          ROLA
8F91: CE 43 00    LDU    #$4300
8F94: 33 CB       LEAU   D,U
8F96: E6 06       LDB    $6,X
8F98: 2A 22       BPL    $8FBC
8F9A: EC C4       LDD    ,U
8F9C: D7 DE       STB    $DE
8F9E: DC 91       LDD    $91
8FA0: 58          ASLB
8FA1: 49          ROLA
8FA2: 58          ASLB
8FA3: 49          ROLA
8FA4: CE 43 00    LDU    #$4300
8FA7: 33 CB       LEAU   D,U
8FA9: A6 43       LDA    $3,U
8FAB: 10 8E 06 70 LDY    #$0670
8FAF: E6 06       LDB    $6,X
8FB1: ED A4       STD    ,Y
8FB3: C6 01       LDB    #$01
8FB5: E7 30       STB    -$10,Y
8FB7: 4F          CLRA
8FB8: 5F          CLRB
8FB9: ED 33       STD    -$D,Y
8FBB: 39          RTS
8FBC: E6 41       LDB    $1,U
8FBE: D7 DE       STB    $DE
8FC0: E6 42       LDB    $2,U
8FC2: 2A 04       BPL    $8FC8
8FC4: A6 06       LDA    $6,X
8FC6: 26 09       BNE    $8FD1
8FC8: D1 BD       CMPB   $BD
8FCA: 23 05       BLS    $8FD1
8FCC: D7 BD       STB    $BD
8FCE: BD 79 15    JSR    $7915
8FD1: A6 43       LDA    $3,U
8FD3: 10 8E 06 70 LDY    #$0670
8FD7: E6 06       LDB    $6,X
8FD9: ED A4       STD    ,Y
8FDB: C6 01       LDB    #$01
8FDD: E7 30       STB    -$10,Y
8FDF: 4F          CLRA
8FE0: 5F          CLRB
8FE1: ED 33       STD    -$D,Y
8FE3: 39          RTS
8FE4: DC A0       LDD    $A0
8FE6: DD E2       STD    $E2
8FE8: DC A2       LDD    $A2
8FEA: DD E4       STD    $E4
8FEC: 0F E1       CLR    $E1
8FEE: DC E2       LDD    $E2
8FF0: A3 16       SUBD   -$A,X
8FF2: 2A 07       BPL    $8FFB
8FF4: 43          COMA
8FF5: 53          COMB
8FF6: C3 00 01    ADDD   #$0001
8FF9: 0C E1       INC    $E1
8FFB: DD E2       STD    $E2
8FFD: DC E4       LDD    $E4
8FFF: A3 19       SUBD   -$7,X
9001: DD E4       STD    $E4
9003: 2A 0D       BPL    $9012
9005: 43          COMA
9006: 53          COMB
9007: C3 00 01    ADDD   #$0001
900A: DD E4       STD    $E4
900C: D6 E1       LDB    $E1
900E: CA 02       ORB    #$02
9010: D7 E1       STB    $E1
9012: 96 E5       LDA    $E5
9014: D6 E3       LDB    $E3
9016: BD FE D8    JSR    $FED8
9019: D7 E6       STB    $E6
901B: C6 64       LDB    #$64
901D: 3D          MUL
901E: CE 90 58    LDU    #$9058
9021: 10 83 02 58 CMPD   #$0258
9025: 24 20       BCC    $9047
9027: CE 90 54    LDU    #$9054
902A: 10 83 00 96 CMPD   #$0096
902E: 24 17       BCC    $9047
9030: CE 90 5C    LDU    #$905C
9033: 10 83 00 4B CMPD   #$004B
9037: 24 0E       BCC    $9047
9039: CE 90 50    LDU    #$9050
903C: 96 E3       LDA    $E3
903E: 44          LSRA
903F: 44          LSRA
9040: 91 E6       CMPA   $E6
9042: 22 03       BHI    $9047
9044: CE 90 4C    LDU    #$904C
9047: D6 E1       LDB    $E1
9049: E6 C5       LDB    B,U
904B: 39          RTS

906B: E6 1E       LDB    -$2,X
906D: 58          ASLB
906E: EC C5       LDD    B,U
9070: ED 84       STD    ,X
9072: 6F 02       CLR    $2,X
9074: E6 02       LDB    $2,X
9076: 26 1F       BNE    $9097
9078: 10 8E 90 60 LDY    #$9060
907C: E6 1F       LDB    -$1,X
907E: A6 A5       LDA    B,Y
9080: 10 AE 84    LDY    ,X
9083: 10 AF 03    STY    $3,X
9086: 31 A6       LEAY   A,Y
9088: E6 3F       LDB    -$1,Y
908A: 2A 05       BPL    $9091
908C: 10 AE A4    LDY    ,Y
908F: C4 7F       ANDB   #$7F
9091: E7 02       STB    $2,X
9093: 10 AF 84    STY    ,X
9096: 39          RTS
9097: 6A 02       DEC    $2,X
9099: 39          RTS
909A: D6 AD       LDB    $AD
909C: 27 0C       BEQ    $90AA
909E: CE A6 31    LDU    #$A631
90A1: D6 21       LDB    $21
90A3: 54          LSRB
90A4: 24 02       BCC    $90A8
90A6: EE 84       LDU    ,X
90A8: EF 03       STU    $3,X
90AA: 39          RTS
90AB: 8E 05 10    LDX    #$0510
90AE: 8D 0B       BSR    $90BB
90B0: 8D E8       BSR    $909A
90B2: EC 16       LDD    -$A,X
90B4: DD A0       STD    $A0
90B6: EC 19       LDD    -$7,X
90B8: DD A2       STD    $A2
90BA: 39          RTS
90BB: E6 10       LDB    -$10,X
90BD: 27 FB       BEQ    $90BA
90BF: EC 13       LDD    -$D,X
90C1: 48          ASLA
90C2: CE 90 C7    LDU    #jump_table_90c7
90C5: 6E D6       JMP    [A,U]        ; [indirect_jump]
90C7: 90 D3       SUBA   $D3
90C9: 91 70       CMPA   $70
90CB: 95 67       BITA   $67
90CD: 9A F9       ORA    $F9
90CF: 94 AB       ANDA   $AB
90D1: 95 1A       BITA   $1A
90D3: C6 01       LDB    #$01
90D5: E7 10       STB    -$10,X
90D7: E7 0E       STB    $E,X
90D9: 4F          CLRA
90DA: 5F          CLRB
90DB: ED 88 13    STD    $13,X
90DE: ED 88 16    STD    $16,X
90E1: E7 88 15    STB    $15,X
90E4: E7 05       STB    $5,X
90E6: ED 88 19    STD    $19,X
90E9: E7 0F       STB    $F,X
90EB: E7 1E       STB    -$2,X
90ED: 0F AD       CLR    $AD
90EF: C6 0A       LDB    #$0A
90F1: E7 88 10    STB    $10,X
90F4: E6 88 18    LDB    $18,X
90F7: 27 04       BEQ    $90FD
90F9: C6 80       LDB    #$80
90FB: D7 DF       STB    $DF
90FD: CC 95 53    LDD    #$9553
9100: ED 1C       STD    -$4,X
9102: C6 03       LDB    #$03
9104: E7 1F       STB    -$1,X
9106: 6C 13       INC    -$D,X
9108: CE 95 5F    LDU    #$955F
910B: 7E 91 A1    JMP    $91A1
910E: E6 10       LDB    -$10,X
9110: 5A          DECB
9111: 26 A7       BNE    $90BA
9113: E6 88 1A    LDB    $1A,X
9116: C1 05       CMPB   #$05
9118: 22 0E       BHI    $9128
911A: D6 4C       LDB    $4C
911C: 53          COMB
911D: D4 4B       ANDB   $4B
911F: C5 10       BITB   #$10
9121: 27 05       BEQ    $9128
9123: BD 9F 51    JSR    $9F51
9126: 6F 15       CLR    -$B,X
9128: E6 88 1A    LDB    $1A,X
912B: 27 42       BEQ    $916F
912D: E6 15       LDB    -$B,X
912F: 58          ASLB
9130: CE 91 35    LDU    #jump_table_9135
9133: 6E D5       JMP    [B,U]        ; [indirect_jump]
9135: 91 39       CMPA   $39
9137: 91 5C       CMPA   $5C
9139: BD 94 85    JSR    $9485
913C: C6 0F       LDB    #$0F
913E: E7 88 1A    STB    $1A,X
9141: D6 AC       LDB    armour_flag_00ac
9143: 58          ASLB
9144: CE 97 E7    LDU    #$97E7
9147: EE C5       LDU    B,U
9149: E6 0E       LDB    $E,X
914B: 5A          DECB
914C: 58          ASLB
914D: EE C5       LDU    B,U
914F: E6 0F       LDB    $F,X
9151: 58          ASLB
9152: EC C5       LDD    B,U
9154: BD 98 FE    JSR    $98FE
9157: BD 79 79    JSR    $7979
915A: 6C 15       INC    -$B,X
915C: BD 90 74    JSR    $9074
915F: 6A 88 1A    DEC    $1A,X
9162: 26 0B       BNE    $916F
9164: C6 02       LDB    #$02
9166: E1 13       CMPB   -$D,X
9168: 27 03       BEQ    $916D
916A: BD 9A 28    JSR    $9A28
916D: 6F 15       CLR    -$B,X
916F: 39          RTS
9170: E6 14       LDB    -$C,X
9172: 58          ASLB
9173: CE 91 78    LDU    #jump_table_9178
9176: 6E D5       JMP    [B,U]        ; [indirect_jump]

917C: E6 0F       LDB    $F,X
917E: 26 34       BNE    $91B4
9180: BD 92 28    JSR    $9228
9183: 24 05       BCC    $918A
9185: E6 88 16    LDB    $16,X
9188: 26 29       BNE    $91B3
918A: E6 88 16    LDB    $16,X
918D: 10 26 01 DB LBNE   $936C
9191: BD 91 0E    JSR    $910E
9194: BD 93 D0    JSR    $93D0
9197: 25 03       BCS    $919C
9199: BD 94 02    JSR    $9402
919C: 8D 33       BSR    $91D1
919E: 7E 92 18    JMP    $9218
91A1: 31 06       LEAY   $6,X
91A3: EC C4       LDD    ,U
91A5: ED A4       STD    ,Y
91A7: EC 42       LDD    $2,U
91A9: ED 22       STD    $2,Y
91AB: EC 44       LDD    $4,U
91AD: ED 24       STD    $4,Y
91AF: EC 46       LDD    $6,U
91B1: ED 26       STD    $6,Y
91B3: 39          RTS
91B4: 6F 1E       CLR    -$2,X
91B6: BD 92 28    JSR    $9228
91B9: 25 0C       BCS    $91C7
91BB: E6 88 16    LDB    $16,X
91BE: 27 0A       BEQ    $91CA
91C0: 6F 15       CLR    -$B,X
91C2: 6F 0F       CLR    $F,X
91C4: 7E 93 6C    JMP    $936C
91C7: BD 9A 45    JSR    $9A45
91CA: 8D 4C       BSR    $9218
91CC: BD 91 0E    JSR    $910E
91CF: 20 00       BRA    $91D1
91D1: E6 05       LDB    $5,X
91D3: 27 07       BEQ    $91DC
91D5: EE 88 1E    LDU    $1E,X
91D8: 6F 49       CLR    $9,U
91DA: 6F 05       CLR    $5,X
91DC: BD 8C A7    JSR    $8CA7
91DF: 25 0B       BCS    $91EC
91E1: BD 96 74    JSR    $9674
91E4: BD 9F AE    JSR    $9FAE
91E7: 25 08       BCS    $91F1
91E9: 6C 14       INC    -$C,X
91EB: 39          RTS
91EC: 4F          CLRA
91ED: E3 19       ADDD   -$7,X
91EF: ED 19       STD    -$7,X
91F1: 39          RTS
91F2: BD 93 D0    JSR    $93D0
91F5: BD 91 0E    JSR    $910E
91F8: BD 96 74    JSR    $9674
91FB: BD 9F AE    JSR    $9FAE
91FE: 25 13       BCS    $9213
9200: BD 96 5A    JSR    $965A
9203: BD 90 74    JSR    $9074
9206: CE 95 57    LDU    #$9557
9209: BD 8C A7    JSR    $8CA7
920C: 25 03       BCS    $9211
920E: 7E 96 A9    JMP    $96A9
9211: 8D D9       BSR    $91EC
9213: 6A 14       DEC    -$C,X
9215: 7E 91 08    JMP    $9108
9218: D6 4C       LDB    $4C
921A: 53          COMB
921B: D4 4B       ANDB   $4B
921D: C5 20       BITB   #$20
921F: 27 06       BEQ    $9227
9221: 6C 13       INC    -$D,X
9223: 4F          CLRA
9224: 5F          CLRB
9225: ED 14       STD    -$C,X
9227: 39          RTS
9228: D6 4C       LDB    $4C
922A: D4 4B       ANDB   $4B
922C: C5 08       BITB   #$08
922E: 26 0B       BNE    $923B
9230: C5 04       BITB   #$04
9232: 10 26 00 9A LBNE   $92D0
9236: 6F 88 15    CLR    $15,X
9239: 53          COMB
923A: 39          RTS
923B: BD 93 11    JSR    $9311
923E: 24 2A       BCC    $926A
9240: 86 03       LDA    #$03
9242: A1 88 15    CMPA   $15,X
9245: 27 21       BEQ    $9268
9247: A7 88 15    STA    $15,X
924A: C6 01       LDB    #$01
924C: E7 88 16    STB    $16,X
924F: 6F 88 1A    CLR    $1A,X
9252: 6F 1E       CLR    -$2,X
9254: BD 93 89    JSR    $9389
9257: 53          COMB
9258: 39          RTS
9259: 86 03       LDA    #$03
925B: A1 88 15    CMPA   $15,X
925E: 27 08       BEQ    $9268
9260: A7 88 15    STA    $15,X
9263: 6F 0F       CLR    $F,X
9265: BD 94 9E    JSR    $949E
9268: 5F          CLRB
9269: 39          RTS
926A: E6 88 16    LDB    $16,X
926D: 27 EA       BEQ    $9259
926F: E6 88 17    LDB    $17,X
9272: 27 0A       BEQ    $927E
9274: C1 0A       CMPB   #$0A
9276: 27 0B       BEQ    $9283
9278: C1 11       CMPB   #$11
927A: 27 17       BEQ    $9293
927C: 20 10       BRA    $928E
927E: CE 93 94    LDU    #$9394
9281: 20 03       BRA    $9286
9283: CE 93 98    LDU    #$9398
9286: D6 AC       LDB    armour_flag_00ac
9288: 58          ASLB
9289: EC C5       LDD    B,U
928B: BD 98 FE    JSR    $98FE
928E: 6C 88 17    INC    $17,X
9291: 53          COMB
9292: 39          RTS
9293: 6F 88 16    CLR    $16,X
9296: 6F 88 17    CLR    $17,X
9299: BD 9A 33    JSR    $9A33
929C: 53          COMB
929D: 39          RTS
929E: E6 88 17    LDB    $17,X
92A1: 26 07       BNE    $92AA
92A3: C6 11       LDB    #$11
92A5: E7 88 17    STB    $17,X
92A8: 20 0A       BRA    $92B4
92AA: C1 11       CMPB   #$11
92AC: 27 06       BEQ    $92B4
92AE: C1 0A       CMPB   #$0A
92B0: 27 07       BEQ    $92B9
92B2: 20 10       BRA    $92C4
92B4: CE 93 98    LDU    #$9398
92B7: 20 03       BRA    $92BC
92B9: CE 93 94    LDU    #$9394
92BC: D6 AC       LDB    armour_flag_00ac
92BE: 58          ASLB
92BF: EC C5       LDD    B,U
92C1: BD 98 FE    JSR    $98FE
92C4: 6A 88 17    DEC    $17,X
92C7: 27 02       BEQ    $92CB
92C9: 53          COMB
92CA: 39          RTS
92CB: BD 93 89    JSR    $9389
92CE: 5F          CLRB
92CF: 39          RTS
92D0: BD 93 4A    JSR    $934A
92D3: 24 1F       BCC    $92F4
92D5: 86 04       LDA    #$04
92D7: A1 88 15    CMPA   $15,X
92DA: 27 2E       BEQ    $930A
92DC: E6 88 16    LDB    $16,X
92DF: 26 29       BNE    $930A
92E1: A7 88 15    STA    $15,X
92E4: EC 19       LDD    -$7,X
92E6: 83 00 0E    SUBD   #$000E
92E9: ED 19       STD    -$7,X
92EB: C6 01       LDB    #$01
92ED: E7 88 16    STB    $16,X
92F0: 6F 1E       CLR    -$2,X
92F2: 20 AA       BRA    $929E
92F4: 6F 88 16    CLR    $16,X
92F7: 86 04       LDA    #$04
92F9: A1 88 15    CMPA   $15,X
92FC: 27 11       BEQ    $930F
92FE: A7 88 15    STA    $15,X
9301: C6 01       LDB    #$01
9303: E7 0F       STB    $F,X
9305: BD 9A 9B    JSR    $9A9B
9308: 20 05       BRA    $930F
930A: E6 88 17    LDB    $17,X
930D: 26 8F       BNE    $929E
930F: 5F          CLRB
9310: 39          RTS
9311: EC 16       LDD    -$A,X
9313: DD EC       STD    $EC
9315: EC 19       LDD    -$7,X
9317: DD EE       STD    $EE
9319: BD 8D D2    JSR    $8DD2
931C: E6 A9 04 00 LDB    $0400,Y
9320: C4 C0       ANDB   #$C0
9322: 26 EB       BNE    $930F
9324: E6 A4       LDB    ,Y
9326: C0 40       SUBB   #$40
9328: C1 3D       CMPB   #$3D
932A: 22 E3       BHI    $930F
932C: 54          LSRB
932D: 24 0C       BCC    $933B
932F: E6 17       LDB    -$9,X
9331: C4 0F       ANDB   #$0F
9333: 50          NEGB
9334: 1D          SEX
9335: E3 16       ADDD   -$A,X
9337: ED 16       STD    -$A,X
9339: 20 0D       BRA    $9348
933B: E6 17       LDB    -$9,X
933D: C4 0F       ANDB   #$0F
933F: 50          NEGB
9340: 1D          SEX
9341: E3 16       ADDD   -$A,X
9343: C3 00 10    ADDD   #$0010
9346: ED 16       STD    -$A,X
9348: 53          COMB
9349: 39          RTS
934A: EC 16       LDD    -$A,X
934C: DD EC       STD    $EC
934E: EC 19       LDD    -$7,X
9350: 83 00 12    SUBD   #$0012
9353: DD EE       STD    $EE
9355: BD 8D D2    JSR    $8DD2
9358: E6 A9 04 00 LDB    $0400,Y
935C: C4 C0       ANDB   #$C0
935E: 26 AF       BNE    $930F
9360: E6 A4       LDB    ,Y
9362: C0 40       SUBB   #$40
9364: C1 3D       CMPB   #$3D
9366: 10 22 FF A5 LBHI   $930F
936A: 20 C0       BRA    $932C
936C: CE 95 4F    LDU    #$954F
936F: C6 03       LDB    #$03
9371: E1 88 15    CMPB   $15,X
9374: 27 02       BEQ    $9378
9376: 33 42       LEAU   $2,U
9378: BD 90 74    JSR    $9074
937B: EC 1A       LDD    -$6,X
937D: E3 C4       ADDD   ,U
937F: ED 1A       STD    -$6,X
9381: E6 C4       LDB    ,U
9383: 1D          SEX
9384: A9 19       ADCA   -$7,X
9386: A7 19       STA    -$7,X
9388: 39          RTS
9389: D6 AC       LDB    armour_flag_00ac
938B: 58          ASLB
938C: CE 93 CC    LDU    #$93CC
938F: EC C5       LDD    B,U
9391: 7E 98 FE    JMP    $98FE

93D0: D6 4C       LDB    $4C
93D2: D4 4B       ANDB   $4B
93D4: C5 02       BITB   #$02
93D6: 26 10       BNE    $93E8
93D8: C5 01       BITB   #$01
93DA: 26 14       BNE    $93F0
93DC: E6 88 1A    LDB    $1A,X
93DF: 26 03       BNE    $93E4
93E1: BD 9A 28    JSR    $9A28
93E4: 6F 1E       CLR    -$2,X
93E6: 53          COMB
93E7: 39          RTS
93E8: 86 02       LDA    #$02
93EA: A1 1E       CMPA   -$2,X
93EC: 27 12       BEQ    $9400
93EE: 20 06       BRA    $93F6
93F0: 86 01       LDA    #$01
93F2: A1 1E       CMPA   -$2,X
93F4: 27 0A       BEQ    $9400
93F6: 6F 88 1A    CLR    $1A,X
93F9: A7 0E       STA    $E,X
93FB: A7 1E       STA    -$2,X
93FD: BD 94 9E    JSR    $949E
9400: 5F          CLRB
9401: 39          RTS
9402: E6 88 1A    LDB    $1A,X
9405: 26 54       BNE    $945B
9407: E6 1E       LDB    -$2,X
9409: 5A          DECB
940A: 26 27       BNE    $9433
940C: 8D 4E       BSR    $945C
940E: BD 9F AE    JSR    $9FAE
9411: 10 25 FC 5F LBCS   $9074
9415: BD 8D 1A    JSR    $8D1A
9418: 24 06       BCC    $9420
941A: 50          NEGB
941B: 1D          SEX
941C: E3 16       ADDD   -$A,X
941E: ED 16       STD    -$A,X
9420: DC 9C       LDD    $9C
9422: C3 01 00    ADDD   #$0100
9425: A3 16       SUBD   -$A,X
9427: 10 83 00 0A CMPD   #$000A
942B: 10 25 FC 45 LBCS   $9074
942F: EE 1C       LDU    -$4,X
9431: 20 23       BRA    $9456
9433: 8D 31       BSR    $9466
9435: BD 9F AE    JSR    $9FAE
9438: 10 25 FC 38 LBCS   $9074
943C: BD 8D 4C    JSR    $8D4C
943F: 24 05       BCC    $9446
9441: 4F          CLRA
9442: E3 16       ADDD   -$A,X
9444: ED 16       STD    -$A,X
9446: EC 16       LDD    -$A,X
9448: 93 9C       SUBD   $9C
944A: 10 83 00 0A CMPD   #$000A
944E: 10 25 FC 22 LBCS   $9074
9452: EE 1C       LDU    -$4,X
9454: 33 42       LEAU   $2,U
9456: 8D 1F       BSR    $9477
9458: 7E 90 74    JMP    $9074
945B: 39          RTS
945C: EC 16       LDD    -$A,X
945E: C3 00 01    ADDD   #$0001
9461: E7 88 1B    STB    $1B,X
9464: 20 08       BRA    $946E
9466: EC 16       LDD    -$A,X
9468: 83 00 01    SUBD   #$0001
946B: E7 88 1B    STB    $1B,X
946E: EC 19       LDD    -$7,X
9470: C3 00 01    ADDD   #$0001
9473: E7 88 1D    STB    $1D,X
9476: 39          RTS
9477: EC 17       LDD    -$9,X
9479: E3 C4       ADDD   ,U
947B: ED 17       STD    -$9,X
947D: E6 C4       LDB    ,U
947F: 1D          SEX
9480: A9 16       ADCA   -$A,X
9482: A7 16       STA    -$A,X
9484: 39          RTS
9485: D6 A4       LDB    $A4
9487: 27 13       BEQ    $949C
9489: DE A5       LDU    $A5
948B: EC 56       LDD    -$A,U
948D: 10 A3 16    CMPD   -$A,X
9490: 22 04       BHI    $9496
9492: 86 02       LDA    #$02
9494: 20 02       BRA    $9498
9496: 86 01       LDA    #$01
9498: A7 0E       STA    $E,X
949A: 53          COMB
949B: 39          RTS
949C: 5F          CLRB
949D: 39          RTS
949E: A6 1E       LDA    -$2,X
94A0: 27 08       BEQ    $94AA
94A2: 8D E1       BSR    $9485
94A4: CE 97 2B    LDU    #$972B
94A7: 7E 98 F3    JMP    $98F3
94AA: 39          RTS
94AB: E6 14       LDB    -$C,X
94AD: 58          ASLB
94AE: CE 94 B3    LDU    #jump_table_94b3
94B1: 6E D5       JMP    [B,U]        ; [indirect_jump]

94B7: E6 88 18    LDB    $18,X
94BA: 26 06       BNE    $94C2
94BC: C6 08       LDB    #$08
94BE: E7 88 18    STB    $18,X
94C1: 39          RTS
94C2: C1 08       CMPB   #$08
94C4: 10 27 04 AE LBEQ   $9976
94C8: 5A          DECB
94C9: 10 27 05 0D LBEQ   $99DA
94CD: BD 92 18    JSR    $9218
94D0: 8D 15       BSR    $94E7
94D2: 25 06       BCS    $94DA
94D4: BD 94 02    JSR    $9402
94D7: BD 95 10    JSR    $9510
94DA: BD 91 D1    JSR    $91D1
94DD: D6 21       LDB    $21
94DF: C4 3F       ANDB   #$3F
94E1: 26 03       BNE    $94E6
94E3: 6A 88 18    DEC    $18,X
94E6: 39          RTS
94E7: D6 4C       LDB    $4C
94E9: D4 4B       ANDB   $4B
94EB: C5 02       BITB   #$02
94ED: 26 0B       BNE    $94FA
94EF: C5 01       BITB   #$01
94F1: 26 0B       BNE    $94FE
94F3: BD 99 0D    JSR    $990D
94F6: 6F 1E       CLR    -$2,X
94F8: 53          COMB
94F9: 39          RTS
94FA: 86 02       LDA    #$02
94FC: 20 02       BRA    $9500
94FE: 86 01       LDA    #$01
9500: A1 1E       CMPA   -$2,X
9502: 27 0A       BEQ    $950E
9504: 6F 88 1A    CLR    $1A,X
9507: A7 0E       STA    $E,X
9509: A7 1E       STA    -$2,X
950B: BD 99 0D    JSR    $990D
950E: 5F          CLRB
950F: 39          RTS
9510: D6 21       LDB    $21
9512: 5A          DECB
9513: C4 1F       ANDB   #$1F
9515: 10 27 E4 C4 LBEQ   $79DD
9519: 39          RTS
951A: E6 1E       LDB    -$2,X
951C: 5A          DECB
951D: 26 04       BNE    $9523
951F: 8D 61       BSR    $9582
9521: 20 03       BRA    $9526
9523: BD 95 A2    JSR    $95A2
9526: E6 14       LDB    -$C,X
9528: 58          ASLB
9529: CE 95 3C    LDU    #jump_table_953c
952C: AD D5       JSR    [B,U]        ; [indirect_jump]
952E: 7E 94 DD    JMP    $94DD
9531: BD 95 82    JSR    $9582
9534: E6 14       LDB    -$C,X
9536: 58          ASLB
9537: CE 95 3C    LDU    #jump_table_953c
953A: 6E D5       JMP    [B,U]        ; [indirect_jump]
953C: 95 42       BITA   $42
953E: 95 D3       BITA   $D3
9540: 96 12       LDA    $12
9542: C6 01       LDB    #$01
9544: D7 99       STB    $99
9546: BD 99 05    JSR    $9905
9549: BD 79 DD    JSR    $79DD
954C: 7E 95 BC    JMP    $95BC

9567: E6 1E       LDB    -$2,X
9569: 27 09       BEQ    $9574
956B: 5A          DECB
956C: 26 04       BNE    $9572
956E: 8D 12       BSR    $9582
9570: 20 02       BRA    $9574
9572: 8D 2E       BSR    $95A2
9574: E6 14       LDB    -$C,X
9576: 58          ASLB
9577: CE 95 7C    LDU    #jump_table_957c
957A: 6E D5       JMP    [B,U]        ; [indirect_jump]
957C: 95 B2       BITA   $B2
957E: 95 C8       BITA   $C8
9580: 96 07       LDA    $07
9582: BD 8D 1A    JSR    $8D1A
9585: 24 06       BCC    $958D
9587: 50          NEGB
9588: 1D          SEX
9589: E3 16       ADDD   -$A,X
958B: ED 16       STD    -$A,X
958D: DC 9C       LDD    $9C
958F: C3 01 00    ADDD   #$0100
9592: A3 16       SUBD   -$A,X
9594: 10 83 00 0A CMPD   #$000A
9598: 22 02       BHI    $959C
959A: 6F 1E       CLR    -$2,X
959C: 6F 88 15    CLR    $15,X
959F: 6F 0F       CLR    $F,X
95A1: 39          RTS
95A2: BD 8D 4C    JSR    $8D4C
95A5: 24 05       BCC    $95AC
95A7: 4F          CLRA
95A8: E3 16       ADDD   -$A,X
95AA: ED 16       STD    -$A,X
95AC: EC 16       LDD    -$A,X
95AE: 93 9C       SUBD   $9C
95B0: 20 E2       BRA    $9594
95B2: C6 01       LDB    #$01
95B4: D7 99       STB    $99
95B6: BD 96 FA    JSR    $96FA
95B9: BD 79 6F    JSR    $796F
95BC: CC 95 57    LDD    #$9557
95BF: ED 88 13    STD    $13,X
95C2: 6F 88 1A    CLR    $1A,X
95C5: 6C 14       INC    -$C,X
95C7: 39          RTS
95C8: BD 94 85    JSR    $9485
95CB: 25 03       BCS    $95D0
95CD: BD 97 0F    JSR    $970F
95D0: BD 91 0E    JSR    $910E
95D3: E6 1E       LDB    -$2,X
95D5: 27 0A       BEQ    $95E1
95D7: 5A          DECB
95D8: 26 05       BNE    $95DF
95DA: BD 96 67    JSR    $9667
95DD: 20 02       BRA    $95E1
95DF: 8D 5F       BSR    $9640
95E1: BD 96 4D    JSR    $964D
95E4: E6 88 1A    LDB    $1A,X
95E7: 26 03       BNE    $95EC
95E9: BD 90 74    JSR    $9074
95EC: EE 88 13    LDU    $13,X
95EF: BD 96 87    JSR    $9687
95F2: E6 1E       LDB    -$2,X
95F4: 27 10       BEQ    $9606
95F6: E6 05       LDB    $5,X
95F8: 27 0C       BEQ    $9606
95FA: EC 88 1E    LDD    $1E,X
95FD: 27 BD       BEQ    $95BC
95FF: EE 88 1E    LDU    $1E,X
9602: 6F 49       CLR    $9,U
9604: 6F 05       CLR    $5,X
9606: 39          RTS
9607: BD 94 85    JSR    $9485
960A: 25 03       BCS    $960F
960C: BD 97 0F    JSR    $970F
960F: BD 91 0E    JSR    $910E
9612: E6 1E       LDB    -$2,X
9614: 27 09       BEQ    $961F
9616: 5A          DECB
9617: 26 04       BNE    $961D
9619: 8D 4C       BSR    $9667
961B: 20 02       BRA    $961F
961D: 8D 21       BSR    $9640
961F: 8D 39       BSR    $965A
9621: E6 88 1A    LDB    $1A,X
9624: 26 03       BNE    $9629
9626: BD 90 74    JSR    $9074
9629: EE 88 13    LDU    $13,X
962C: BD 8C A7    JSR    $8CA7
962F: 10 25 00 97 LBCS   $96CA
9633: BD 96 A9    JSR    $96A9
9636: 8D 3C       BSR    $9674
9638: BD 9F AE    JSR    $9FAE
963B: 10 25 00 90 LBCS   $96CF
963F: 39          RTS
9640: EC 17       LDD    -$9,X
9642: A3 07       SUBD   $7,X
9644: ED 17       STD    -$9,X
9646: E6 16       LDB    -$A,X
9648: E2 06       SBCB   $6,X
964A: E7 16       STB    -$A,X
964C: 39          RTS
964D: EC 1A       LDD    -$6,X
964F: E3 0B       ADDD   $B,X
9651: ED 1A       STD    -$6,X
9653: E6 19       LDB    -$7,X
9655: E9 0A       ADCB   $A,X
9657: E7 19       STB    -$7,X
9659: 39          RTS
965A: EC 1A       LDD    -$6,X
965C: A3 0B       SUBD   $B,X
965E: ED 1A       STD    -$6,X
9660: E6 19       LDB    -$7,X
9662: E2 0A       SBCB   $A,X
9664: E7 19       STB    -$7,X
9666: 39          RTS
9667: EC 17       LDD    -$9,X
9669: E3 07       ADDD   $7,X
966B: ED 17       STD    -$9,X
966D: E6 16       LDB    -$A,X
966F: E9 06       ADCB   $6,X
9671: E7 16       STB    -$A,X
9673: 39          RTS
9674: C6 01       LDB    #$01
9676: E7 88 1C    STB    $1C,X
9679: EC 19       LDD    -$7,X
967B: 83 00 01    SUBD   #$0001
967E: E7 88 1D    STB    $1D,X
9681: E6 17       LDB    -$9,X
9683: E7 88 1B    STB    $1B,X
9686: 39          RTS
9687: EC 08       LDD    $8,X
9689: E3 42       ADDD   $2,U
968B: ED 08       STD    $8,X
968D: E6 07       LDB    $7,X
968F: E9 41       ADCB   $1,U
9691: E7 07       STB    $7,X
9693: EC 0C       LDD    $C,X
9695: A3 46       SUBD   $6,U
9697: ED 0C       STD    $C,X
9699: E6 0B       LDB    $B,X
969B: E2 45       SBCB   $5,U
969D: E7 0B       STB    $B,X
969F: EC 0B       LDD    $B,X
96A1: 10 A3 45    CMPD   $5,U
96A4: 24 02       BCC    $96A8
96A6: 6C 14       INC    -$C,X
96A8: 39          RTS
96A9: EC 08       LDD    $8,X
96AB: A3 42       SUBD   $2,U
96AD: 2B 08       BMI    $96B7
96AF: ED 08       STD    $8,X
96B1: E6 07       LDB    $7,X
96B3: E2 41       SBCB   $1,U
96B5: E7 07       STB    $7,X
96B7: E6 0B       LDB    $B,X
96B9: C1 05       CMPB   #$05
96BB: 24 0C       BCC    $96C9
96BD: EC 0C       LDD    $C,X
96BF: E3 46       ADDD   $6,U
96C1: ED 0C       STD    $C,X
96C3: E6 0B       LDB    $B,X
96C5: E9 45       ADCB   $5,U
96C7: E7 0B       STB    $B,X
96C9: 39          RTS
96CA: 4F          CLRA
96CB: E3 19       ADDD   -$7,X
96CD: ED 19       STD    -$7,X
96CF: BD 79 74    JSR    $7974
96D2: E6 13       LDB    -$D,X
96D4: C1 03       CMPB   #$03
96D6: 26 03       BNE    $96DB
96D8: 6C 14       INC    -$C,X
96DA: 39          RTS
96DB: CE 95 5F    LDU    #$955F
96DE: BD 91 A1    JSR    $91A1
96E1: 6F 88 1A    CLR    $1A,X
96E4: 6F 1E       CLR    -$2,X
96E6: E6 13       LDB    -$D,X
96E8: C1 04       CMPB   #$04
96EA: 27 07       BEQ    $96F3
96EC: 22 03       BHI    $96F1
96EE: BD 9A 28    JSR    $9A28
96F1: 6A 13       DEC    -$D,X
96F3: 4F          CLRA
96F4: 5F          CLRB
96F5: ED 14       STD    -$C,X
96F7: 0F 99       CLR    $99
96F9: 39          RTS
96FA: A6 0E       LDA    $E,X
96FC: BD 94 85    JSR    $9485
96FF: E6 1E       LDB    -$2,X
9701: 26 06       BNE    $9709
9703: CE 98 9F    LDU    #$989F
9706: 7E 98 F3    JMP    $98F3
9709: CE 98 73    LDU    #$9873
970C: 7E 98 F3    JMP    $98F3
970F: D6 4C       LDB    $4C
9711: D4 4B       ANDB   $4B
9713: C5 02       BITB   #$02
9715: 26 05       BNE    $971C
9717: C5 01       BITB   #$01
9719: 26 0C       BNE    $9727
971B: 39          RTS
971C: C6 02       LDB    #$02
971E: E1 0E       CMPB   $E,X
9720: 27 F9       BEQ    $971B
9722: E7 0E       STB    $E,X
9724: 7E 96 FA    JMP    $96FA
9727: C6 01       LDB    #$01
9729: 20 F3       BRA    $971E

98F3: D6 AC       LDB    armour_flag_00ac
98F5: 58          ASLB
98F6: EE C5       LDU    B,U
98F8: A6 0E       LDA    $E,X
98FA: 4A          DECA
98FB: 48          ASLA
98FC: EC C6       LDD    A,U
98FE: ED 84       STD    ,X
9900: ED 03       STD    $3,X
9902: 6F 02       CLR    $2,X
9904: 39          RTS
9905: BD 79 DD    JSR    $79DD
9908: CE 99 4A    LDU    #$994A
990B: 20 EB       BRA    $98F8
990D: CE 99 12    LDU    #$9912
9910: 20 E6       BRA    $98F8

9976: E6 15       LDB    -$B,X
9978: 58          ASLB
9979: CE 99 7E    LDU    #jump_table_997e
997C: 6E D5       JMP    [B,U]        ; [indirect_jump]

9984: C6 81       LDB    #$81
9986: D7 DF       STB    $DF
9988: CC 08 01    LDD    #$0801
998B: BD 69 09    JSR    $6909
998E: EC 84       LDD    ,X
9990: ED 88 11    STD    $11,X
9993: C6 10       LDB    #$10
9995: E7 88 10    STB    $10,X
9998: BD 79 65    JSR    $7965
999B: 6C 15       INC    -$B,X
999D: 39          RTS
999E: 6A 88 10    DEC    $10,X
99A1: 27 11       BEQ    $99B4
99A3: 96 21       LDA    $21
99A5: 84 02       ANDA   #$02
99A7: 27 05       BEQ    $99AE
99A9: CC A6 31    LDD    #$A631
99AC: 20 03       BRA    $99B1
99AE: EC 88 11    LDD    $11,X
99B1: ED 03       STD    $3,X
99B3: 39          RTS
99B4: C6 10       LDB    #$10
99B6: E7 88 10    STB    $10,X
99B9: CE 99 12    LDU    #$9912
99BC: E6 0E       LDB    $E,X
99BE: 5A          DECB
99BF: 58          ASLB
99C0: EC C5       LDD    B,U
99C2: ED 88 11    STD    $11,X
99C5: 6C 15       INC    -$B,X
99C7: 39          RTS
99C8: 6A 88 10    DEC    $10,X
99CB: 26 D6       BNE    $99A3
99CD: 6F 15       CLR    -$B,X
99CF: CC 95 53    LDD    #$9553
99D2: ED 1C       STD    -$4,X
99D4: 6A 88 18    DEC    $18,X
99D7: 7E 99 0D    JMP    $990D
99DA: E6 15       LDB    -$B,X
99DC: 58          ASLB
99DD: CE 99 E2    LDU    #jump_table_99e2
99E0: 6E D5       JMP    [B,U]        ; [indirect_jump]
99E2: 99 E8       ADCA   $E8
99E4: 99 EE       ADCA   $EE
99E6: 9A 0B       ORA    $0B
99E8: CC 08 00    LDD    #$0800
99EB: 7E 99 8B    JMP    $998B
99EE: 6A 88 10    DEC    $10,X
99F1: 26 B0       BNE    $99A3
99F3: C6 10       LDB    #$10
99F5: E7 88 10    STB    $10,X
99F8: CE 9A 39    LDU    #$9A39
99FB: D6 AC       LDB    armour_flag_00ac
99FD: 58          ASLB
99FE: EE C5       LDU    B,U
9A00: E6 0E       LDB    $E,X
9A02: 5A          DECB
9A03: 58          ASLB
9A04: EC C5       LDD    B,U
9A06: ED 88 11    STD    $11,X
9A09: 6C 15       INC    -$B,X
9A0B: 6A 88 10    DEC    $10,X
9A0E: 10 26 FF 91 LBNE   $99A3
9A12: 6F 88 18    CLR    $18,X
9A15: CC 95 53    LDD    #$9553
9A18: ED 1C       STD    -$4,X
9A1A: C6 80       LDB    #$80
9A1C: D7 DF       STB    $DF
9A1E: 8D 13       BSR    $9A33
9A20: CC 01 00    LDD    #$0100
9A23: ED 13       STD    -$D,X
9A25: E7 15       STB    -$B,X
9A27: 39          RTS
9A28: E6 0F       LDB    $F,X
9A2A: 27 07       BEQ    $9A33
9A2C: 7E 9A 9B    JMP    $9A9B
9A2F: C6 01       LDB    #$01
9A31: E7 0E       STB    $E,X
9A33: CE 9A 39    LDU    #$9A39
9A36: 7E 98 F3    JMP    $98F3

9A45: D6 4C       LDB    $4C
9A47: D4 4B       ANDB   $4B
9A49: C5 02       BITB   #$02
9A4B: 26 0A       BNE    $9A57
9A4D: C5 01       BITB   #$01
9A4F: 26 29       BNE    $9A7A
9A51: E6 88 1A    LDB    $1A,X
9A54: 27 28       BEQ    $9A7E
9A56: 39          RTS
9A57: 86 02       LDA    #$02
9A59: A1 0E       CMPA   $E,X
9A5B: 26 19       BNE    $9A76
9A5D: E6 88 1A    LDB    $1A,X
9A60: 26 13       BNE    $9A75
9A62: E6 88 10    LDB    $10,X
9A65: 27 05       BEQ    $9A6C
9A67: 6A 88 10    DEC    $10,X
9A6A: 26 09       BNE    $9A75
9A6C: C6 07       LDB    #$07
9A6E: E7 88 10    STB    $10,X
9A71: 6F 0F       CLR    $F,X
9A73: 6F 14       CLR    -$C,X
9A75: 39          RTS
9A76: A7 0E       STA    $E,X
9A78: 20 21       BRA    $9A9B
9A7A: 86 01       LDA    #$01
9A7C: 20 DB       BRA    $9A59
9A7E: E6 15       LDB    -$B,X
9A80: 58          ASLB
9A81: CE 9A 86    LDU    #jump_table_9a86
9A84: 6E D5       JMP    [B,U]        ; [indirect_jump]
9A86: 9A 8A       ORA    $8A
9A88: 9A 91       ORA    $91
9A8A: C6 0F       LDB    #$0F
9A8C: E7 88 10    STB    $10,X
9A8F: 6C 15       INC    -$B,X
9A91: 6A 88 10    DEC    $10,X
9A94: 26 04       BNE    $9A9A
9A96: 6A 0F       DEC    $F,X
9A98: 6F 15       CLR    -$B,X
9A9A: 39          RTS
9A9B: CE 9A A1    LDU    #$9AA1
9A9E: 7E 98 F3    JMP    $98F3

9AF9: 96 AC       LDA    armour_flag_00ac
9AFB: 10 26 01 3A LBNE   $9C39
9AFF: 58          ASLB
9B00: CE 9B 0F    LDU    #jump_table_9b0f
9B03: AD D5       JSR    [B,U]        ; [indirect_jump]
9B05: E6 0E       LDB    $E,X
9B07: 5A          DECB
9B08: 10 27 FA 76 LBEQ   $9582
9B0C: 7E 95 A2    JMP    $95A2

9B19: BD 79 60    JSR    $7960
9B1C: C6 78       LDB    #$78
9B1E: D7 AD       STB    $AD
9B20: E6 88 18    LDB    $18,X
9B23: 27 12       BEQ    $9B37
9B25: 6F 88 18    CLR    $18,X
9B28: C6 80       LDB    #$80
9B2A: D7 DF       STB    $DF
9B2C: CC 95 53    LDD    #$9553
9B2F: ED 1C       STD    -$4,X
9B31: CC 08 00    LDD    #$0800
9B34: BD 69 09    JSR    $6909
9B37: 10 8E 9B 54 LDY    #$9B54
9B3B: CE 05 40    LDU    #$0540
9B3E: C6 04       LDB    #$04
9B40: D7 E0       STB    $E0
9B42: 5C          INCB
9B43: E7 88 19    STB    $19,X
9B46: 8D 20       BSR    $9B68
9B48: 33 C8 40    LEAU   $40,U
9B4B: 31 25       LEAY   $5,Y
9B4D: 0A E0       DEC    $E0
9B4F: 26 F5       BNE    $9B46
9B51: 7E 9B EA    JMP    $9BEA
9B54: 01 00       NEG    $00
9B56: 08 00       ASL    $00
9B58: 08 02       ASL    $02
9B5A: 00 08       NEG    $08
9B5C: FF F8 03    STU    $F803
9B5F: FF F8 FF    STU    $F8FF
9B62: F8 04 FF    EORB   $04FF
9B65: F8 00 08    EORB   >$0008
9B68: 4F          CLRA
9B69: 5F          CLRB
9B6A: ED 53       STD    -$D,U
9B6C: E7 55       STB    -$B,U
9B6E: 86 02       LDA    #$02
9B70: ED 50       STD    -$10,U
9B72: E6 A4       LDB    ,Y
9B74: E7 5E       STB    -$2,U
9B76: EC 21       LDD    $1,Y
9B78: E3 16       ADDD   -$A,X
9B7A: ED 56       STD    -$A,U
9B7C: EC 23       LDD    $3,Y
9B7E: E3 19       ADDD   -$7,X
9B80: ED 59       STD    -$7,U
9B82: C6 05       LDB    #$05
9B84: E7 45       STB    $5,U
9B86: 39          RTS
9B87: E6 88 18    LDB    $18,X
9B8A: 27 39       BEQ    $9BC5
9B8C: 6F 88 18    CLR    $18,X
9B8F: C6 01       LDB    #$01
9B91: D7 DF       STB    $DF
9B93: 20 24       BRA    $9BB9
9B95: C6 01       LDB    #$01
9B97: E7 10       STB    -$10,X
9B99: D7 AC       STB    armour_flag_00ac
9B9B: BD 9A 28    JSR    $9A28
9B9E: 6F 88 16    CLR    $16,X
9BA1: 0F 99       CLR    $99
9BA3: CE 95 5F    LDU    #$955F
9BA6: BD 91 A1    JSR    $91A1
9BA9: 7E 9A 20    JMP    $9A20
9BAC: D6 60       LDB    nb_lives_0060
9BAE: 5A          DECB
9BAF: 26 05       BNE    $9BB6
9BB1: BD 7A 19    JSR    $7A19
9BB4: 20 03       BRA    $9BB9
9BB6: BD 7A 29    JSR    $7A29
9BB9: E6 88 18    LDB    $18,X
9BBC: 27 07       BEQ    $9BC5
9BBE: 6F 88 18    CLR    $18,X
9BC1: C6 80       LDB    #$80
9BC3: D7 DF       STB    $DF
9BC5: 96 AE       LDA    $AE
9BC7: 2A 04       BPL    $9BCD
9BC9: C6 01       LDB    #$01
9BCB: 20 04       BRA    $9BD1
9BCD: C6 02       LDB    #$02
9BCF: E7 10       STB    -$10,X
9BD1: E7 0E       STB    $E,X
9BD3: E7 1E       STB    -$2,X
9BD5: CE 9A A5    LDU    #$9AA5
9BD8: D6 AC       LDB    armour_flag_00ac
9BDA: 58          ASLB
9BDB: EE C5       LDU    B,U
9BDD: BD 98 F8    JSR    $98F8
9BE0: CC 9B F3    LDD    #$9BF3
9BE3: ED 88 13    STD    $13,X
9BE6: C6 01       LDB    #$01
9BE8: D7 99       STB    $99
9BEA: CE 95 5F    LDU    #$955F
9BED: BD 91 A1    JSR    $91A1
9BF0: 6C 14       INC    -$C,X
9BF2: 39          RTS

9BFB: 10 AE 88 1E LDY    $1E,X
9BFF: 27 04       BEQ    $9C05
9C01: 6F 29       CLR    $9,Y
9C03: 6F 05       CLR    $5,X
9C05: CE 9A DD    LDU    #$9ADD
9C08: BD 98 F8    JSR    $98F8
9C0B: C6 14       LDB    #$14
9C0D: E7 88 10    STB    $10,X
9C10: 6C 14       INC    -$C,X
9C12: 6A 88 10    DEC    $10,X
9C15: 10 26 F4 5B LBNE   $9074
9C19: 8D 33       BSR    $9C4E
9C1B: C6 28       LDB    #$28
9C1D: E7 88 10    STB    $10,X
9C20: C6 02       LDB    #$02
9C22: BD 8E BF    JSR    $8EBF
9C25: 6C 14       INC    -$C,X
9C27: E6 88 10    LDB    $10,X
9C2A: 27 06       BEQ    $9C32
9C2C: 6A 88 10    DEC    $10,X
9C2F: 7E 90 74    JMP    $9074
9C32: 0F 99       CLR    $99
9C34: C6 01       LDB    #$01
9C36: D7 90       STB    $90
9C38: 39          RTS
9C39: 58          ASLB
9C3A: CE 9C 42    LDU    #jump_table_9c42
9C3D: AD D5       JSR    [B,U]        ; [indirect_jump]
9C3F: 7E 9B 05    JMP    $9B05
9C42: 9B AC       ADDA   armour_flag_00ac
9C44: 95 D3       BITA   $D3
9C46: 96 12       LDA    $12
9C48: 9B FB       ADDA   $FB
9C4A: 9C 12       CMPX   $12
9C4C: 9C 27       CMPX   $27
9C4E: CE 9C 54    LDU    #$9C54
9C51: 7E 98 F8    JMP    $98F8

9C60: 47          ASRA
9C61: 74 46 20    LSR    $4620
9C64: 4F          CLRA
9C65: 74 4E FF    LSR    $4EFF
9C68: 8E 05 40    LDX    #$0540
9C6B: F6 05 29    LDB    $0529
9C6E: C1 02       CMPB   #$02
9C70: 25 06       BCS    $9C78
9C72: C6 04       LDB    #$04
9C74: D7 E0       STB    $E0
9C76: 20 04       BRA    $9C7C
9C78: C6 04       LDB    #$04
9C7A: D7 E0       STB    $E0
9C7C: E6 10       LDB    -$10,X
9C7E: 27 10       BEQ    $9C90
9C80: BD 8E 41    JSR    $8E41
9C83: E6 05       LDB    $5,X
9C85: 58          ASLB
9C86: CE 9C 98    LDU    #table_of_jump_tables_9c98
9C89: EE C5       LDU    B,U
9C8B: EC 13       LDD    -$D,X
9C8D: 48          ASLA
9C8E: AD D6       JSR    [A,U]        ; [special_indirect_jump]
9C90: 30 88 40    LEAX   $40,X
9C93: 0A E0       DEC    $E0
9C95: 26 E5       BNE    $9C7C
9C97: 39          RTS

table_of_jump_tables_9c98:
	.word	jump_table_9ca4
	.word	jump_table_9e31
	.word	jump_table_9e6d
	.word	jump_table_9e94
	.word	jump_table_9ed3
	.word	jump_table_a066
	
jump_table_9ca4:
	.word	$9CAC
	.word	$9CC2
	.word	$9D75
	.word	$9E8B
	
jump_table_9e31:
    .word	$9E39 
	.word	$9E63 
	.word	$9D75 
	.word	$9E8B 
	   
jump_table_9e6d:
	.word	$9CAC
	.word	$9E75
	.word	$9D75
	.word	$9E8B
	
jump_table_9e94:
jump_table_9ed3:
	.word	$9CAC 
	.word	$9E9C 
	.word	$9D75 
	.word	$9E8B 

	 
jump_table_a066:
9CAC: C6 00       LDB    #$00
9CAE: E7 1F       STB    -$1,X
9CB0: 8D 03       BSR    $9CB5
9CB2: 7E 9E 40    JMP    $9E40
9CB5: CC FF FF    LDD    #$FFFF
9CB8: ED 88 20    STD    $20,X
9CBB: ED 88 22    STD    $22,X
9CBE: ED 88 24    STD    $24,X
9CC1: 39          RTS

9CC2: 58          ASLB
9CC3: CE 9C C8    LDU    #jump_table_9cc8
9CC6: 6E D5       JMP    [B,U]        ; [indirect_jump]

9CD4: CE 9D EB    LDU    #$9DEB
9CD7: E6 05       LDB    $5,X
9CD9: 6F 88 11    CLR    $11,X
9CDC: A6 C5       LDA    B,U
9CDE: A7 88 12    STA    $12,X
9CE1: 4F          CLRA
9CE2: E6 C5       LDB    B,U
9CE4: 58          ASLB
9CE5: 49          ROLA
9CE6: ED 88 13    STD    $13,X
9CE9: EE 1C       LDU    -$4,X
9CEB: E6 1E       LDB    -$2,X
9CED: 58          ASLB
9CEE: 58          ASLB
9CEF: 33 C5       LEAU   B,U
9CF1: BD 94 77    JSR    $9477
9CF4: 33 42       LEAU   $2,U
9CF6: BD 93 7B    JSR    $937B
9CF9: EC 16       LDD    -$A,X
9CFB: A3 0E       SUBD   $E,X
9CFD: E3 88 11    ADDD   $11,X
9D00: 10 A3 88 13 CMPD   $13,X
9D04: 10 25 F3 6C LBCS   $9074
9D08: 6C 14       INC    -$C,X
9D0A: 39          RTS
9D0B: CE 9D F1    LDU    #$9DF1
9D0E: BD 91 A1    JSR    $91A1
9D11: 6C 14       INC    -$C,X
9D13: 39          RTS
9D14: 8D 05       BSR    $9D1B
9D16: 24 02       BCC    $9D1A
9D18: 6C 14       INC    -$C,X
9D1A: 39          RTS
9D1B: E6 1E       LDB    -$2,X
9D1D: 5A          DECB
9D1E: 27 05       BEQ    $9D25
9D20: BD 96 40    JSR    $9640
9D23: 20 03       BRA    $9D28
9D25: BD 96 67    JSR    $9667
9D28: BD 96 5A    JSR    $965A
9D2B: BD 90 74    JSR    $9074
9D2E: CE 9D F9    LDU    #$9DF9
9D31: BD 96 A9    JSR    $96A9
9D34: BD 8C A7    JSR    $8CA7
9D37: 24 07       BCC    $9D40
9D39: 4F          CLRA
9D3A: E3 19       ADDD   -$7,X
9D3C: ED 19       STD    -$7,X
9D3E: 53          COMB
9D3F: 39          RTS
9D40: 5F          CLRB
9D41: 39          RTS
9D42: BD 79 9C    JSR    $799C
9D45: C6 03       LDB    #$03
9D47: BD 8E BF    JSR    $8EBF
9D4A: CC 9E FB    LDD    #$9EFB
9D4D: 20 0F       BRA    $9D5E
9D4F: 6A 88 17    DEC    $17,X
9D52: 10 26 F3 1E LBNE   $9074
9D56: C6 00       LDB    #$00
9D58: BD 8E BF    JSR    $8EBF
9D5B: CC 9F 09    LDD    #$9F09
9D5E: ED 84       STD    ,X
9D60: ED 03       STD    $3,X
9D62: 6F 02       CLR    $2,X
9D64: C6 20       LDB    #$20
9D66: E7 88 17    STB    $17,X
9D69: 6C 14       INC    -$C,X
9D6B: 39          RTS
9D6C: 6A 88 17    DEC    $17,X
9D6F: 10 26 F3 01 LBNE   $9074
9D73: 20 10       BRA    $9D85
9D75: 58          ASLB
9D76: CE 9D 7B    LDU    #jump_table_9d7b
9D79: 6E D5       JMP    [B,U]        ; [indirect_jump]

9D85: CC 03 00    LDD    #$0300
9D88: ED 13       STD    -$D,X
9D8A: E7 15       STB    -$B,X
9D8C: 39          RTS
9D8D: D6 73       LDB    weapon_type_0073
9D8F: CE 9D BA    LDU    #$9DBA
9D92: E6 C5       LDB    B,U
9D94: 27 04       BEQ    $9D9A
9D96: C6 00       LDB    #$00
9D98: E7 1F       STB    -$1,X
9D9A: 8D 23       BSR    $9DBF
9D9C: C6 0F       LDB    #$0F
9D9E: E7 88 17    STB    $17,X
9DA1: BD 79 97    JSR    $7997
9DA4: 6C 14       INC    -$C,X
9DA6: 39          RTS
9DA7: D6 73       LDB    weapon_type_0073
9DA9: CE 9D BA    LDU    #$9DBA
9DAC: E6 C5       LDB    B,U
9DAE: 27 04       BEQ    $9DB4
9DB0: C6 00       LDB    #$00
9DB2: E7 1F       STB    -$1,X
9DB4: 8D 0F       BSR    $9DC5
9DB6: C6 08       LDB    #$08
9DB8: 20 E4       BRA    $9D9E
9DBA: 01 01       NEG    $01
9DBC: 00 00       NEG    $00
9DBE: 00 CE       NEG    $CE
9DC0: 9D CD       JSR    $CD
9DC2: 7E 90 6B    JMP    $906B
9DC5: CC 9D E5    LDD    #$9DE5
9DC8: ED 84       STD    ,X
9DCA: ED 03       STD    $3,X
9DCC: 6F 02       CLR    $2,X
9DCE: 39          RTS

9E37: 9E 8B       LDX    $8B
9E39: C6 02       LDB    #$02
9E3B: E7 1F       STB    -$1,X
9E3D: BD 9C B5    JSR    $9CB5
9E40: EC 16       LDD    -$A,X
9E42: ED 0E       STD    $E,X
9E44: CE 9E 01    LDU    #$9E01
9E47: E6 05       LDB    $5,X
9E49: 58          ASLB
9E4A: EE C5       LDU    B,U
9E4C: EF 1C       STU    -$4,X
9E4E: E6 05       LDB    $5,X
9E50: CE 9E 25    LDU    #$9E25
9E53: 58          ASLB
9E54: EE C5       LDU    B,U
9E56: 33 5E       LEAU   -$2,U
9E58: BD 90 6B    JSR    $906B
9E5B: CC 01 00    LDD    #$0100
9E5E: ED 13       STD    -$D,X
9E60: E7 15       STB    -$B,X
9E62: 39          RTS
9E63: 58          ASLB
9E64: CE 9E 69    LDU    #jump_table_9e69
9E67: 6E D5       JMP    [B,U]        ; [indirect_jump]
9E69: 9C D4       CMPX   $D4
9E6B: 9E B8       LDX    $B8
9E6D: 9C AC       CMPX   armour_flag_00ac
9E6F: 9E 75       LDX    $75
9E71: 9D 75       JSR    $75
9E73: 9E 8B       LDX    $8B
9E75: 58          ASLB
9E76: CE 9E 7B    LDU    #jump_table_9e7b
9E79: 6E D5       JMP    [B,U]        ; [indirect_jump]
9E7B: 9C D4       CMPX   $D4
9E7D: 9D 0B       JSR    $0B
9E7F: 9E 83       LDX    $83
9E81: 9D 85       JSR    $85
9E83: BD 9D 1B    JSR    $9D1B
9E86: 24 0B       BCC    $9E93
9E88: 6C 14       INC    -$C,X
9E8A: 39          RTS
9E8B: 4F          CLRA
9E8C: 5F          CLRB
9E8D: ED 13       STD    -$D,X
9E8F: E7 15       STB    -$B,X
9E91: ED 10       STD    -$10,X
9E93: 39          RTS
9E94: 9C AC       CMPX   armour_flag_00ac
9E96: 9E 9C       LDX    $9C
9E98: 9D 75       JSR    $75
9E9A: 9E 8B       LDX    $8B
9E9C: 58          ASLB
9E9D: CE 9E A2    LDU    #jump_table_9ea2
9EA0: 6E D5       JMP    [B,U]        ; [indirect_jump]
9EA2: 9C D4       CMPX   $D4
9EA4: 9E A8       LDX    $A8
9EA6: 9E B1       LDX    $B1
9EA8: 8D 16       BSR    $9EC0
9EAA: C6 0F       LDB    #$0F
9EAC: E7 88 17    STB    $17,X
9EAF: 6C 14       INC    -$C,X
9EB1: 6A 88 17    DEC    $17,X
9EB4: 10 26 F1 BC LBNE   $9074
9EB8: CC 02 00    LDD    #$0200
9EBB: ED 13       STD    -$D,X
9EBD: E7 15       STB    -$B,X
9EBF: 39          RTS
9EC0: CC 9E CA    LDD    #$9ECA
9EC3: ED 03       STD    $3,X
9EC5: ED 84       STD    ,X
9EC7: 6F 02       CLR    $2,X
9EC9: 39          RTS

9F4C: 00 FF       NEG    $FF
9F4E: 5F          CLRB
9F4F: 04 FF       LSR    $FF
9F51: 8D 40       BSR    $9F93
9F53: 4D          TSTA
9F54: 27 3A       BEQ    $9F90
9F56: CC 01 01    LDD    #$0101
9F59: ED 30       STD    -$10,Y
9F5B: 4F          CLRA
9F5C: 5F          CLRB
9F5D: ED 33       STD    -$D,Y
9F5F: D6 73       LDB    weapon_type_0073
9F61: E7 25       STB    $5,Y
9F63: E6 0F       LDB    $F,X
9F65: CE 9F 91    LDU    #$9F91
9F68: 33 C5       LEAU   B,U
9F6A: E6 C4       LDB    ,U
9F6C: 1D          SEX
9F6D: E3 19       ADDD   -$7,X
9F6F: ED 39       STD    -$7,Y
9F71: E6 0E       LDB    $E,X
9F73: 5A          DECB
9F74: 27 0A       BEQ    $9F80
9F76: EC 16       LDD    -$A,X
9F78: ED 36       STD    -$A,Y
9F7A: C6 02       LDB    #$02
9F7C: E7 3E       STB    -$2,Y
9F7E: 20 0B       BRA    $9F8B
9F80: EC 16       LDD    -$A,X
9F82: C3 00 0F    ADDD   #$000F
9F85: ED 36       STD    -$A,Y
9F87: C6 01       LDB    #$01
9F89: E7 3E       STB    -$2,Y
9F8B: C6 0F       LDB    #$0F
9F8D: E7 88 1A    STB    $1A,X
9F90: 39          RTS
9F91: 09 FD       ROL    $FD
9F93: CE 9F A9    LDU    #$9FA9
9F96: D6 73       LDB    weapon_type_0073
9F98: A6 C5       LDA    B,U
9F9A: 10 8E 05 40 LDY    #$0540
9F9E: E6 30       LDB    -$10,Y
9FA0: 27 06       BEQ    $9FA8
9FA2: 31 A8 40    LEAY   $40,Y
9FA5: 4A          DECA
9FA6: 26 F6       BNE    $9F9E
9FA8: 39          RTS

9FB0: 10 C6 1E    LDB    #$1E
9FB3: D7 E0       STB    $E0
9FB5: E6 51       LDB    -$F,U
9FB7: 10 27 00 83 LBEQ   $A03E
9FBB: E6 45       LDB    $5,U
9FBD: 27 7F       BEQ    $A03E
9FBF: E6 56       LDB    -$A,U
9FC1: D7 E1       STB    $E1
9FC3: A6 57       LDA    -$9,U
9FC5: E6 5A       LDB    -$6,U
9FC7: DD E2       STD    $E2
9FC9: 10 8E A0 52 LDY    #$A052
9FCD: E6 45       LDB    $5,U
9FCF: 5A          DECB
9FD0: 58          ASLB
9FD1: 58          ASLB
9FD2: 31 A5       LEAY   B,Y
9FD4: EC A4       LDD    ,Y
9FD6: DD E4       STD    $E4
9FD8: EC 22       LDD    $2,Y
9FDA: DD E6       STD    $E6
9FDC: A6 16       LDA    -$A,X
9FDE: E6 88 1B    LDB    $1B,X
9FE1: 93 E1       SUBD   $E1
9FE3: C3 00 80    ADDD   #$0080
9FE6: 10 83 01 00 CMPD   #$0100
9FEA: 22 52       BHI    $A03E
9FEC: A6 88 1B    LDA    $1B,X
9FEF: 90 E2       SUBA   $E2
9FF1: 9B E4       ADDA   $E4
9FF3: 91 E5       CMPA   $E5
9FF5: 22 47       BHI    $A03E
9FF7: A6 88 1D    LDA    $1D,X
9FFA: 90 E3       SUBA   $E3
9FFC: 9B E6       ADDA   $E6
9FFE: 91 E7       CMPA   $E7
A000: 22 3C       BHI    $A03E
A002: E6 88 1C    LDB    $1C,X
A005: 27 06       BEQ    $A00D
A007: EC 19       LDD    -$7,X
A009: A3 59       SUBD   -$7,U
A00B: 2B 31       BMI    $A03E
A00D: E6 1A       LDB    -$6,X
A00F: E0 5A       SUBB   -$6,U
A011: CB 03       ADDB   #$03
A013: C1 06       CMPB   #$06
A015: 25 07       BCS    $A01E
A017: D6 E6       LDB    $E6
A019: 4F          CLRA
A01A: E3 59       ADDD   -$7,U
A01C: ED 19       STD    -$7,X
A01E: E6 45       LDB    $5,U
A020: 10 8E A0 4C LDY    #$A04C
A024: E6 A5       LDB    B,Y
A026: 27 14       BEQ    $A03C
A028: EC 88 1E    LDD    $1E,X
A02B: 27 06       BEQ    $A033
A02D: 10 AE 88 1E LDY    $1E,X
A031: 6F 29       CLR    $9,Y
A033: EF 88 1E    STU    $1E,X
A036: C6 01       LDB    #$01
A038: E7 05       STB    $5,X
A03A: E7 49       STB    $9,U
A03C: 53          COMB
A03D: 39          RTS
A03E: 33 C8 20    LEAU   $20,U
A041: 0A E0       DEC    $E0
A043: 10 26 FF 6E LBNE   $9FB5
A047: 6F 88 1C    CLR    $1C,X
A04A: 5F          CLRB
A04B: 39          RTS
A0A6: C6 04       LDB    #$04
A0A8: F7 3E 00    STB    bankswitch_3e00
A0AB: 8E 08 90    LDX    #$0890
A0AE: C6 28       LDB    #$28
A0B0: D7 E0       STB    $E0
A0B2: E6 10       LDB    -$10,X
A0B4: 27 1D       BEQ    $A0D3
A0B6: D6 21       LDB    $21
A0B8: DB E0       ADDB   $E0
A0BA: C4 03       ANDB   #$03
A0BC: 26 03       BNE    $A0C1
A0BE: BD 8E 41    JSR    $8E41
A0C1: E6 05       LDB    $5,X
A0C3: 58          ASLB
A0C4: CE 45 44    LDU    #jump_table_4544
A0C7: AD D5       JSR    [B,U]        ; [indirect_jump]
A0C9: D6 21       LDB    $21
A0CB: C4 01       ANDB   #$01
A0CD: 58          ASLB
A0CE: CE 45 40    LDU    #jump_table_4540
A0D1: AD D5       JSR    [B,U]        ; [indirect_jump]
A0D3: 30 88 30    LEAX   $30,X
A0D6: 0A E0       DEC    $E0
A0D8: 26 D8       BNE    $A0B2
A0DA: 39          RTS
A0DB: EC 13       LDD    -$D,X
A0DD: 48          ASLA
A0DE: CE A0 E3    LDU    #$A0E3
A0E1: 6E D6       JMP    [A,U]        ; [indirect_jump]
A0E3: A0 EB       SUBA   D,S
A0E5: A1 BF A3 E1 CMPA   [$A3E1]
A0E9: A4 0B       ANDA   $B,X
A0EB: 58          ASLB
A0EC: CE A0 F1    LDU    #jump_table_a0f1
A0EF: 6E D5       JMP    [B,U]        ; [indirect_jump]
A0F1: A0 F9 A1 4D SUBA   [-$5EB3,S]
A0F5: A1 7F       CMPA   -$1,S
A0F7: A1 7F       CMPA   -$1,S
A0F9: C6 02       LDB    #$02
A0FB: E7 10       STB    -$10,X
A0FD: 4F          CLRA
A0FE: 5F          CLRB
A0FF: ED 88 10    STD    $10,X
A102: ED 88 12    STD    $12,X
A105: ED 88 1E    STD    $1E,X
A108: E7 08       STB    $8,X
A10A: E7 0A       STB    $A,X
A10C: D6 21       LDB    $21
A10E: DB E0       ADDB   $E0
A110: C4 07       ANDB   #$07
A112: E7 06       STB    $6,X
A114: C6 02       LDB    #$02
A116: E7 1F       STB    -$1,X
A118: C6 01       LDB    #$01
A11A: E7 1E       STB    -$2,X
A11C: EC 16       LDD    -$A,X
A11E: 10 93 A0    CMPD   $A0
A121: 2D 04       BLT    $A127
A123: C6 09       LDB    #$09
A125: E7 1E       STB    -$2,X
A127: CC A6 31    LDD    #$A631
A12A: ED 03       STD    $3,X
A12C: CE 45 DC    LDU    #$45DC
A12F: D6 9A       LDB    $9A
A131: C4 30       ANDB   #$30
A133: 54          LSRB
A134: 54          LSRB
A135: 33 C5       LEAU   B,U
A137: 96 E0       LDA    $E0
A139: 9B 21       ADDA   $21
A13B: 84 03       ANDA   #$03
A13D: 26 02       BNE    $A141
A13F: 33 42       LEAU   $2,U
A141: EC C4       LDD    ,U
A143: ED 1C       STD    -$4,X
A145: A6 12       LDA    -$E,X
A147: 8B 01       ADDA   #$01
A149: 5F          CLRB
A14A: ED 14       STD    -$C,X
A14C: 39          RTS
A14D: E6 15       LDB    -$B,X
A14F: 58          ASLB
A150: CE A1 55    LDU    #jump_table_a155
A153: 6E D5       JMP    [B,U]        ; [indirect_jump]
A155: A1 59       CMPA   -$7,U
A157: A1 61       CMPA   $1,S
A159: CE 45 B4    LDU    #$45B4
A15C: BD 90 6B    JSR    $906B
A15F: 6C 15       INC    -$B,X
A161: EC 16       LDD    -$A,X
A163: 93 9C       SUBD   $9C
A165: 83 00 10    SUBD   #$0010
A168: 10 83 00 E0 CMPD   #$00E0
A16C: 23 09       BLS    $A177
A16E: BD 90 74    JSR    $9074
A171: BD A4 27    JSR    $A427
A174: 7E A4 27    JMP    $A427
A177: CC 01 00    LDD    #$0100
A17A: ED 13       STD    -$D,X
A17C: E7 15       STB    -$B,X
A17E: 39          RTS
A17F: E6 15       LDB    -$B,X
A181: 58          ASLB
A182: CE A1 87    LDU    #jump_table_a187
A185: 6E D5       JMP    [B,U]        ; [indirect_jump]
A187: A1 8B       CMPA   D,X
A189: A1 A2       CMPA   ,-Y
A18B: E6 1E       LDB    -$2,X
A18D: 58          ASLB
A18E: CE 45 6A    LDU    #$456A
A191: EE C5       LDU    B,U
A193: EC C1       LDD    ,U++
A195: A7 1F       STA    -$1,X
A197: E7 0D       STB    $D,X
A199: EC C1       LDD    ,U++
A19B: ED 03       STD    $3,X
A19D: EF 0E       STU    $E,X
A19F: 6C 15       INC    -$B,X
A1A1: 39          RTS
A1A2: 6A 0D       DEC    $D,X
A1A4: 26 10       BNE    $A1B6
A1A6: EE 0E       LDU    $E,X
A1A8: EC C1       LDD    ,U++
A1AA: 2B 0B       BMI    $A1B7
A1AC: A7 1F       STA    -$1,X
A1AE: E7 0D       STB    $D,X
A1B0: EC C1       LDD    ,U++
A1B2: ED 03       STD    $3,X
A1B4: EF 0E       STU    $E,X
A1B6: 39          RTS
A1B7: CC 01 00    LDD    #$0100
A1BA: ED 13       STD    -$D,X
A1BC: E7 15       STB    -$B,X
A1BE: 39          RTS
A1BF: 58          ASLB
A1C0: CE A1 C5    LDU    #jump_table_a1c5
A1C3: 6E D5       JMP    [B,U]        ; [indirect_jump]

A1CB: D6 E0       LDB    $E0
A1CD: DB 21       ADDB   $21
A1CF: C5 7F       BITB   #$7F
A1D1: 26 03       BNE    $A1D6
A1D3: BD 79 C4    JSR    $79C4
A1D6: E6 15       LDB    -$B,X
A1D8: 58          ASLB
A1D9: CE A1 E1    LDU    #jump_table_a1e1
A1DC: AD D5       JSR    [B,U]        ; [indirect_jump]
A1DE: 7E A3 70    JMP    $A370

A1E5: C6 01       LDB    #$01
A1E7: E7 10       STB    -$10,X
A1E9: CE 45 B4    LDU    #$45B4
A1EC: BD 90 6B    JSR    $906B
A1EF: D6 70       LDB    $70
A1F1: C5 02       BITB   #$02
A1F3: 26 00       BNE    $A1F5
A1F5: 6C 15       INC    -$B,X
A1F7: 39          RTS
A1F8: BD A4 27    JSR    $A427
A1FB: BD 90 74    JSR    $9074
A1FE: 8D 03       BSR    $A203
A200: 7E 8F 62    JMP    $8F62
A203: E6 06       LDB    $6,X
A205: 27 2E       BEQ    $A235
A207: D6 21       LDB    $21
A209: DB E0       ADDB   $E0
A20B: C4 0F       ANDB   #$0F
A20D: 26 26       BNE    $A235
A20F: EC 16       LDD    -$A,X
A211: 93 A0       SUBD   $A0
A213: 2A 05       BPL    $A21A
A215: 43          COMA
A216: 53          COMB
A217: C3 00 01    ADDD   #$0001
A21A: 4D          TSTA
A21B: 26 18       BNE    $A235
A21D: 58          ASLB
A21E: 49          ROLA
A21F: 58          ASLB
A220: 49          ROLA
A221: 58          ASLB
A222: 49          ROLA
A223: CE A2 36    LDU    #$A236
A226: E6 08       LDB    $8,X
A228: EB C6       ADDB   A,U
A22A: E7 08       STB    $8,X
A22C: 24 07       BCC    $A235
A22E: CC 01 00    LDD    #$0100
A231: ED 14       STD    -$C,X
A233: 6A 06       DEC    $6,X
A235: 39          RTS

A23E: E6 15       LDB    -$B,X
A240: 58          ASLB
A241: CE 47 88    LDU    #jump_table_4788
A244: 6E D5       JMP    [B,U]        ; [indirect_jump]
A246: E6 1E       LDB    -$2,X
A248: CE 47 98    LDU    #$4798
A24B: 58          ASLB
A24C: EC C5       LDD    B,U
A24E: ED 84       STD    ,X
A250: 6F 02       CLR    $2,X
A252: BD 90 74    JSR    $9074
A255: CE 47 C8    LDU    #$47C8
A258: D6 E0       LDB    $E0
A25A: 54          LSRB
A25B: 25 02       BCS    $A25F
A25D: 33 48       LEAU   $8,U
A25F: EF 0E       STU    $E,X
A261: 6C 15       INC    -$B,X
A263: 39          RTS
A264: DC A2       LDD    $A2
A266: C3 00 20    ADDD   #$0020
A269: 10 A3 19    CMPD   -$7,X
A26C: 22 26       BHI    $A294
A26E: C3 00 20    ADDD   #$0020
A271: 10 A3 19    CMPD   -$7,X
A274: 22 08       BHI    $A27E
A276: E6 0A       LDB    $A,X
A278: CB 26       ADDB   #$26
A27A: E7 0A       STB    $A,X
A27C: 25 16       BCS    $A294
A27E: 86 01       LDA    #$01
A280: E6 1E       LDB    -$2,X
A282: C1 05       CMPB   #$05
A284: 25 02       BCS    $A288
A286: 86 FF       LDA    #$FF
A288: C6 08       LDB    #$08
A28A: ED 0C       STD    $C,X
A28C: A6 98 0E    LDA    [$0E,X]
A28F: A7 0B       STA    $B,X
A291: 6C 15       INC    -$B,X
A293: 39          RTS
A294: 86 FF       LDA    #$FF
A296: E6 1E       LDB    -$2,X
A298: C1 05       CMPB   #$05
A29A: 25 02       BCS    $A29E
A29C: 86 01       LDA    #$01
A29E: C6 08       LDB    #$08
A2A0: ED 0C       STD    $C,X
A2A2: A6 98 0E    LDA    [$0E,X]
A2A5: A7 0B       STA    $B,X
A2A7: 6C 15       INC    -$B,X
A2A9: 39          RTS
A2AA: BD A4 27    JSR    $A427
A2AD: BD 90 74    JSR    $9074
A2B0: 6A 0B       DEC    $B,X
A2B2: 26 1E       BNE    $A2D2
A2B4: EE 0E       LDU    $E,X
A2B6: A6 C0       LDA    ,U+
A2B8: EF 0E       STU    $E,X
A2BA: A7 0B       STA    $B,X
A2BC: 6A 0D       DEC    $D,X
A2BE: 26 02       BNE    $A2C2
A2C0: 6C 15       INC    -$B,X
A2C2: A6 1E       LDA    -$2,X
A2C4: AB 0C       ADDA   $C,X
A2C6: 26 02       BNE    $A2CA
A2C8: 86 10       LDA    #$10
A2CA: 81 11       CMPA   #$11
A2CC: 25 02       BCS    $A2D0
A2CE: 86 01       LDA    #$01
A2D0: A7 1E       STA    -$2,X
A2D2: 39          RTS
A2D3: EC 16       LDD    -$A,X
A2D5: 93 9C       SUBD   $9C
A2D7: 10 83 00 80 CMPD   #$0080
A2DB: 22 09       BHI    $A2E6
A2DD: E6 1E       LDB    -$2,X
A2DF: C1 09       CMPB   #$09
A2E1: 26 0A       BNE    $A2ED
A2E3: 7E A2 46    JMP    $A246
A2E6: E6 1E       LDB    -$2,X
A2E8: 5A          DECB
A2E9: 10 27 FF 59 LBEQ   $A246
A2ED: 4F          CLRA
A2EE: 5F          CLRB
A2EF: ED 14       STD    -$C,X
A2F1: 39          RTS
A2F2: E6 15       LDB    -$B,X
A2F4: 58          ASLB
A2F5: CE A2 FA    LDU    #jump_table_a2fa
A2F8: 6E D5       JMP    [B,U]        ; [indirect_jump]

A302: CE 45 C8    LDU    #$45C8
A305: EC 16       LDD    -$A,X
A307: 10 93 A0    CMPD   $A0
A30A: 23 03       BLS    $A30F
A30C: CE 45 D2    LDU    #$45D2
A30F: EF 84       STU    ,X
A311: EF 03       STU    $3,X
A313: 6F 02       CLR    $2,X
A315: CE A3 24    LDU    #$A324
A318: D6 9A       LDB    $9A
A31A: 54          LSRB
A31B: 54          LSRB
A31C: 54          LSRB
A31D: E6 C5       LDB    B,U
A31F: E7 09       STB    $9,X
A321: 6C 15       INC    -$B,X
A323: 39          RTS

A32C: 6A 09       DEC    $9,X
A32E: 10 26 ED 42 LBNE   $9074
A332: CE 47 D8    LDU    #$47D8
A335: EC 16       LDD    -$A,X
A337: 10 93 A0    CMPD   $A0
A33A: 23 03       BLS    $A33F
A33C: CE 47 E6    LDU    #$47E6
A33F: EF 84       STU    ,X
A341: EF 03       STU    $3,X
A343: 6F 02       CLR    $2,X
A345: C6 0A       LDB    #$0A
A347: E7 09       STB    $9,X
A349: 6C 15       INC    -$B,X
A34B: 39          RTS
A34C: 6A 09       DEC    $9,X
A34E: 10 26 ED 22 LBNE   $9074
A352: EE 88 1E    LDU    $1E,X
A355: CC 01 00    LDD    #$0100
A358: ED 53       STD    -$D,U
A35A: E7 55       STB    -$B,U
A35C: 4F          CLRA
A35D: ED 88 1E    STD    $1E,X
A360: C6 0A       LDB    #$0A
A362: E7 09       STB    $9,X
A364: 6C 15       INC    -$B,X
A366: 39          RTS
A367: 6A 09       DEC    $9,X
A369: 26 04       BNE    $A36F
A36B: 4F          CLRA
A36C: 5F          CLRB
A36D: ED 14       STD    -$C,X
A36F: 39          RTS
A370: 31 88 10    LEAY   $10,X
A373: A6 A4       LDA    ,Y
A375: 48          ASLA
A376: CE A3 7B    LDU    #jump_table_a37b
A379: 6E D6       JMP    [A,U]        ; [indirect_jump]

A37F: D6 21       LDB    $21
A381: DB E0       ADDB   $E0
A383: 5C          INCB
A384: C4 0F       ANDB   #$0F
A386: 26 27       BNE    $A3AF
A388: EC 16       LDD    -$A,X
A38A: 93 A0       SUBD   $A0
A38C: C3 00 10    ADDD   #$0010
A38F: 10 83 00 20 CMPD   #$0020
A393: 23 1A       BLS    $A3AF
A395: EC 19       LDD    -$7,X
A397: 10 93 A2    CMPD   $A2
A39A: 23 13       BLS    $A3AF
A39C: 86 06       LDA    #$06
A39E: 90 A7       SUBA   $A7
A3A0: D6 9A       LDB    $9A
A3A2: 54          LSRB
A3A3: 54          LSRB
A3A4: 54          LSRB
A3A5: 54          LSRB
A3A6: CE A3 B0    LDU    #$A3B0
A3A9: A1 C5       CMPA   B,U
A3AB: 24 02       BCC    $A3AF
A3AD: 6C A4       INC    ,Y
A3AF: 39          RTS
A3B0: 01 02       NEG    $02
A3B2: 04 05       LSR    $05
A3B4: D6 A7       LDB    $A7
A3B6: 27 28       BEQ    $A3E0
A3B8: 34 20       PSHS   Y
A3BA: BD 8E 2E    JSR    $8E2E
A3BD: 1F 23       TFR    Y,U
A3BF: 35 20       PULS   Y
A3C1: 6F A4       CLR    ,Y
A3C3: 4F          CLRA
A3C4: 5F          CLRB
A3C5: ED 53       STD    -$D,U
A3C7: E7 55       STB    -$B,U
A3C9: 4C          INCA
A3CA: ED 50       STD    -$10,U
A3CC: C6 04       LDB    #$04
A3CE: E7 45       STB    $5,U
A3D0: EC 16       LDD    -$A,X
A3D2: ED 56       STD    -$A,U
A3D4: EC 19       LDD    -$7,X
A3D6: ED 59       STD    -$7,U
A3D8: EF 88 1E    STU    $1E,X
A3DB: CC 02 00    LDD    #$0200
A3DE: ED 14       STD    -$C,X
A3E0: 39          RTS
A3E1: 58          ASLB
A3E2: CE A3 E7    LDU    #jump_table_a3e7
A3E5: 6E D5       JMP    [B,U]        ; [indirect_jump]

A3ED: EE 88 1E    LDU    $1E,X
A3F0: 27 09       BEQ    $A3FB
A3F2: CC 03 00    LDD    #$0300
A3F5: ED 53       STD    -$D,U
A3F7: 4F          CLRA
A3F8: ED 88 1E    STD    $1E,X
A3FB: CC 01 00    LDD    #$0100
A3FE: ED 14       STD    -$C,X
A400: 7E 79 CE    JMP    $79CE
A403: CC 03 00    LDD    #$0300
A406: ED 13       STD    -$D,X
A408: E7 15       STB    -$B,X
A40A: 39          RTS
A40B: E6 05       LDB    $5,X
A40D: CE 00 30    LDU    #$0030
A410: 6C C5       INC    B,U
A412: EE 88 1E    LDU    $1E,X
A415: 27 05       BEQ    $A41C
A417: CC 03 00    LDD    #$0300
A41A: ED 53       STD    -$D,U
A41C: 4F          CLRA
A41D: 5F          CLRB
A41E: ED 10       STD    -$10,X
A420: ED 13       STD    -$D,X
A422: E7 15       STB    -$B,X
A424: 7E 8E 0C    JMP    $8E0C
A427: EE 1C       LDU    -$4,X
A429: E6 1E       LDB    -$2,X
A42B: 58          ASLB
A42C: 58          ASLB
A42D: 33 C5       LEAU   B,U
A42F: EC 17       LDD    -$9,X
A431: E3 C4       ADDD   ,U
A433: ED 17       STD    -$9,X
A435: E6 C4       LDB    ,U
A437: 1D          SEX
A438: A9 16       ADCA   -$A,X
A43A: A7 16       STA    -$A,X
A43C: EC 1A       LDD    -$6,X
A43E: E3 42       ADDD   $2,U
A440: ED 1A       STD    -$6,X
A442: E6 42       LDB    $2,U
A444: 1D          SEX
A445: A9 19       ADCA   -$7,X
A447: A7 19       STA    -$7,X
A449: 39          RTS
A44A: EC 13       LDD    -$D,X
A44C: 48          ASLA
A44D: CE A4 52    LDU    #jump_table_a452
A450: 6E D6       JMP    [A,U]        ; [indirect_jump]

A45A: D6 9A       LDB    $9A
A45D: 54          LSRB
A45E: 54          LSRB
A45F: 54          LSRB
A460: CE 49 CA    LDU    #$49CA
A463: 58          ASLB
A464: EE C5       LDU    B,U
A466: EF 88 1C    STU    $1C,X
A469: EC 19       LDD    -$7,X
A46B: ED 06       STD    $6,X
A46D: C6 10       LDB    #$10
A46F: E7 0C       STB    $C,X
A471: 4F          CLRA
A472: 5F          CLRB
A473: E7 08       STB    $8,X
A475: ED 09       STD    $9,X
A477: E7 0D       STB    $D,X
A479: C6 01       LDB    #$01
A47B: E7 1E       STB    -$2,X
A47D: EC 16       LDD    -$A,X
A47F: 10 93 A0    CMPD   $A0
A482: 2D 04       BLT    $A488
A484: C6 00       LDB    #$00
A486: E7 1E       STB    -$2,X
A488: C6 02       LDB    #$02
A48A: E7 1F       STB    -$1,X
A48C: 5F          CLRB
A48D: E7 88 10    STB    $10,X
A490: CE 47 F4    LDU    #$47F4
A493: A6 12       LDA    -$E,X
A495: 81 03       CMPA   #$03
A497: 25 1C       BCS    $A4B5
A499: C6 00       LDB    #$00
A49B: E7 1F       STB    -$1,X
A49D: C6 01       LDB    #$01
A49F: E7 88 10    STB    $10,X
A4A2: CE 48 34    LDU    #$4834
A4A5: A6 12       LDA    -$E,X
A4A7: 81 04       CMPA   #$04
A4A9: 26 0A       BNE    $A4B5
A4AB: DC A2       LDD    $A2
A4AD: C3 00 10    ADDD   #$0010
A4B0: ED 06       STD    $6,X
A4B2: CE 48 38    LDU    #$4838
A4B5: BD 90 6B    JSR    $906B
A4B8: CE 49 52    LDU    #$4952
A4BB: E6 88 10    LDB    $10,X
A4BE: 27 03       BEQ    $A4C3
A4C0: CE 49 62    LDU    #$4962
A4C3: EF 1C       STU    -$4,X
A4C5: CC 01 00    LDD    #$0100
A4C8: ED 13       STD    -$D,X
A4CA: E7 15       STB    -$B,X
A4CC: 39          RTS
A4CD: A6 12       LDA    -$E,X
A4CF: 48          ASLA
A4D0: CE A4 D5    LDU    #jump_table_a4d5
A4D3: 6E D6       JMP    [A,U]        ; [indirect_jump]

A4E1: 58          ASLB
A4E2: CE A4 E7    LDU    #jump_table_a4e7
A4E5: 6E D5       JMP    [B,U]        ; [indirect_jump]

A4ED: EC 16       LDD    -$A,X
A4EF: 93 9C       SUBD   $9C
A4F1: 83 00 10    SUBD   #$0010
A4F4: 10 83 00 E0 CMPD   #$00E0
A4F8: 23 09       BLS    $A503
A4FA: BD 90 74    JSR    $9074
A4FD: BD A4 27    JSR    $A427
A500: 7E A4 27    JMP    $A427
A503: 6C 14       INC    -$C,X
A505: 39          RTS
A506: E6 15       LDB    -$B,X
A508: 58          ASLB
A509: CE A5 0E    LDU    #jump_table_a50e
A50C: 6E D5       JMP    [B,U]        ; [indirect_jump]

A518: BD A4 27    JSR    $A427
A51B: BD A5 3E    JSR    $A53E
A51E: BD 90 74    JSR    $9074
A521: 8D 03       BSR    $A526
A523: 7E 8F 62    JMP    $8F62
A526: E6 1E       LDB    -$2,X
A528: 5A          DECB
A529: 27 09       BEQ    $A534
A52B: EC 16       LDD    -$A,X
A52D: 10 93 A0    CMPD   $A0
A530: 22 0B       BHI    $A53D
A532: 20 07       BRA    $A53B
A534: EC 16       LDD    -$A,X
A536: 10 93 A0    CMPD   $A0
A539: 25 02       BCS    $A53D
A53B: 6C 15       INC    -$B,X
A53D: 39          RTS
A53E: CE 49 BA    LDU    #$49BA
A541: E6 88 10    LDB    $10,X
A544: 26 05       BNE    $A54B
A546: E6 0D       LDB    $D,X
A548: 58          ASLB
A549: 33 C5       LEAU   B,U
A54B: EC 09       LDD    $9,X
A54D: E3 C4       ADDD   ,U
A54F: ED 09       STD    $9,X
A551: 24 15       BCC    $A568
A553: E6 08       LDB    $8,X
A555: C9 00       ADCB   #$00
A557: E7 08       STB    $8,X
A559: DB E0       ADDB   $E0
A55B: C4 0F       ANDB   #$0F
A55D: CE 49 AA    LDU    #$49AA
A560: A6 C5       LDA    B,U
A562: A7 0C       STA    $C,X
A564: C4 07       ANDB   #$07
A566: E7 0D       STB    $D,X
A568: C6 04       LDB    #$04
A56A: F7 3E 00    STB    bankswitch_3e00
A56D: CE 41 40    LDU    #$4140
A570: E6 09       LDB    $9,X
A572: 4F          CLRA
A573: E6 CB       LDB    D,U
A575: 2A 02       BPL    $A579
A577: 50          NEGB
A578: 4C          INCA
A579: 58          ASLB
A57A: 97 E2       STA    $E2
A57C: A6 0C       LDA    $C,X
A57E: 3D          MUL
A57F: 1F 89       TFR    A,B
A581: 4F          CLRA
A582: DD E4       STD    $E4
A584: D6 E2       LDB    $E2
A586: E8 08       EORB   $8,X
A588: C4 01       ANDB   #$01
A58A: 26 06       BNE    $A592
A58C: EC 06       LDD    $6,X
A58E: D3 E4       ADDD   $E4
A590: 20 04       BRA    $A596
A592: EC 06       LDD    $6,X
A594: 93 E4       SUBD   $E4
A596: ED 19       STD    -$7,X
A598: 39          RTS
A599: BD 68 F9    JSR    $68F9
A59C: DB E0       ADDB   $E0
A59E: 6C 15       INC    -$B,X
A5A0: 54          LSRB
A5A1: 25 05       BCS    $A5A8
A5A3: CC 02 00    LDD    #$0200
A5A6: ED 14       STD    -$C,X
A5A8: 39          RTS
A5A9: CE A5 B9    LDU    #$A5B9
A5AC: D6 E0       LDB    $E0
A5AE: DB 21       ADDB   $21
A5B0: C4 07       ANDB   #$07
A5B2: E6 C5       LDB    B,U
A5B4: E7 0F       STB    $F,X
A5B6: 6C 15       INC    -$B,X
A5B8: 39          RTS

A5C1: BD A4 27    JSR    $A427
A5C4: BD A5 3E    JSR    $A53E
A5C7: BD 90 74    JSR    $9074
A5CA: BD 8F 62    JSR    $8F62
A5CD: 6A 0F       DEC    $F,X
A5CF: 26 13       BNE    $A5E4
A5D1: E6 1E       LDB    -$2,X
A5D3: C8 01       EORB   #$01
A5D5: E7 1E       STB    -$2,X
A5D7: CE 47 F4    LDU    #$47F4
A5DA: BD 90 6B    JSR    $906B
A5DD: CC 49 5A    LDD    #$495A
A5E0: ED 1C       STD    -$4,X
A5E2: 6C 15       INC    -$B,X
A5E4: 39          RTS
A5E5: BD A4 27    JSR    $A427
A5E8: BD 90 74    JSR    $9074
A5EB: 7E 8F 62    JMP    $8F62
A5EE: BD A4 27    JSR    $A427
A5F1: BD A5 3E    JSR    $A53E
A5F4: BD 90 74    JSR    $9074
A5F7: 7E 8F 62    JMP    $8F62
A5FA: 58          ASLB
A5FB: CE A6 00    LDU    #jump_table_a600
A5FE: 6E D5       JMP    [B,U]        ; [indirect_jump]

A606: E6 15       LDB    -$B,X
A608: 58          ASLB
A609: CE A6 0E    LDU    #$A60E
A60C: 6E D5       JMP    [B,U]        ; [indirect_jump]

A612: C6 1E       LDB    #$1E
A614: E7 0B       STB    $B,X
A616: 6C 15       INC    -$B,X
A618: D6 21       LDB    $21
A61A: 54          LSRB
A61B: 24 07       BCC    $A624
A61D: CC A6 31    LDD    #$A631
A620: ED 03       STD    $3,X
A622: 20 04       BRA    $A628
A624: EC 84       LDD    ,X
A626: ED 03       STD    $3,X
A628: 6A 0B       DEC    $B,X
A62A: 26 04       BNE    $A630
A62C: 6C 14       INC    -$C,X
A62E: 6F 15       CLR    -$B,X
A630: 39          RTS

A642: 58          ASLB
A643: CE A6 48    LDU    #jump_table_a648
A646: 6E D5       JMP    [B,U]        ; [indirect_jump]

A650: E6 15       LDB    -$B,X
A652: 58          ASLB
A653: CE A6 58    LDU    #$A658
A656: 6E D5       JMP    [B,U]        ; [indirect_jump]

A65C: BD A6 6F    JSR    $A66F
A65F: 6C 15       INC    -$B,X
A661: E6 11       LDB    -$F,X
A663: 27 09       BEQ    $A66E
A665: 6A 0F       DEC    $F,X
A667: 26 05       BNE    $A66E
A669: CC 01 00    LDD    #$0100
A66C: ED 14       STD    -$C,X
A66E: 39          RTS
A66F: BD 68 F9    JSR    $68F9
A672: EE 88 1C    LDU    $1C,X
A675: C4 07       ANDB   #$07
A677: E6 C5       LDB    B,U
A679: E7 0F       STB    $F,X
A67B: 39          RTS
A67C: CE 47 F4    LDU    #$47F4
A67F: E6 1E       LDB    -$2,X
A681: 58          ASLB
A682: EE C5       LDU    B,U
A684: 33 44       LEAU   $4,U
A686: EF 84       STU    ,X
A688: EF 03       STU    $3,X
A68A: 6F 02       CLR    $2,X
A68C: 6C 14       INC    -$C,X
A68E: 6F 15       CLR    -$B,X
A690: 39          RTS
A691: E6 15       LDB    -$B,X
A693: 58          ASLB
A694: CE A6 99    LDU    #jump_table_a699
A697: 6E D5       JMP    [B,U]        ; [indirect_jump]

A6AD: BD 68 F9    JSR    $68F9
A6B0: C4 0F       ANDB   #$0F
A6B2: CE A6 9D    LDU    #$A69D
A6B5: A6 C5       LDA    B,U
A6B7: A7 0C       STA    $C,X
A6B9: C1 0C       CMPB   #$0C
A6BB: 23 06       BLS    $A6C3
A6BD: E6 1E       LDB    -$2,X
A6BF: C8 01       EORB   #$01
A6C1: E7 1E       STB    -$2,X
A6C3: CC 80 00    LDD    #$8000
A6C6: ED 09       STD    $9,X
A6C8: E7 08       STB    $8,X
A6CA: E6 0C       LDB    $C,X
A6CC: 50          NEGB
A6CD: 1D          SEX
A6CE: E3 19       ADDD   -$7,X
A6D0: ED 06       STD    $6,X
A6D2: 6C 15       INC    -$B,X
A6D4: 39          RTS
A6D5: BD A4 27    JSR    $A427
A6D8: EC 09       LDD    $9,X
A6DA: C3 03 00    ADDD   #$0300
A6DD: ED 09       STD    $9,X
A6DF: 24 05       BCC    $A6E6
A6E1: CC 03 00    LDD    #$0300
A6E4: ED 14       STD    -$C,X
A6E6: C6 04       LDB    #$04
A6E8: F7 3E 00    STB    bankswitch_3e00
A6EB: E6 09       LDB    $9,X
A6ED: CE 41 40    LDU    #$4140
A6F0: 4F          CLRA
A6F1: E6 CB       LDB    D,U
A6F3: 58          ASLB
A6F4: A6 0C       LDA    $C,X
A6F6: 3D          MUL
A6F7: 1F 89       TFR    A,B
A6F9: 4F          CLRA
A6FA: E3 06       ADDD   $6,X
A6FC: ED 19       STD    -$7,X
A6FE: 7E 8F 62    JMP    $8F62
A701: E6 15       LDB    -$B,X
A703: 58          ASLB
A704: CE A7 09    LDU    #jump_table_a709
A707: 6E D5       JMP    [B,U]        ; [indirect_jump]

A70D: CC 49 52    LDD    #$4952
A710: ED 1C       STD    -$4,X
A712: 86 10       LDA    #$10
A714: A7 0C       STA    $C,X
A716: 6C 15       INC    -$B,X
A718: 39          RTS
A719: BD A4 27    JSR    $A427
A71C: BD A5 3E    JSR    $A53E
A71F: BD 90 74    JSR    $9074
A722: 7E 8F 62    JMP    $8F62
A725: 58          ASLB
A726: CE A7 2B    LDU    #jump_table_a72b
A729: 6E D5       JMP    [B,U]        ; [indirect_jump]

A72F: EC 16       LDD    -$A,X
A731: 93 9C       SUBD   $9C
A733: 2B 0B       BMI    $A740
A735: 83 00 10    SUBD   #$0010
A738: 10 83 01 00 CMPD   #$0100
A73C: 23 14       BLS    $A752
A73E: 20 09       BRA    $A749
A740: C3 00 10    ADDD   #$0010
A743: 10 83 FF F0 CMPD   #$FFF0
A747: 24 09       BCC    $A752
A749: BD 90 74    JSR    $9074
A74C: BD A4 27    JSR    $A427
A74F: 7E A4 27    JMP    $A427
A752: 6C 14       INC    -$C,X
A754: 39          RTS
A755: E6 15       LDB    -$B,X
A757: 58          ASLB
A758: CE A7 5D    LDU    #jump_table_a75d
A75B: 6E D5       JMP    [B,U]        ; [indirect_jump]

A76B: E6 11       LDB    -$F,X
A76D: 27 05       BEQ    $A774
A76F: BD A6 6F    JSR    $A66F
A772: 6C 15       INC    -$B,X
A774: 39          RTS
A775: BD 68 F9    JSR    $68F9
A778: C4 07       ANDB   #$07
A77A: CE A7 D6    LDU    #$A7D6
A77D: E6 C5       LDB    B,U
A77F: 58          ASLB
A780: CE A7 67    LDU    #$A767
A783: A6 12       LDA    -$E,X
A785: 81 03       CMPA   #$03
A787: 27 03       BEQ    $A78C
A789: CE A7 63    LDU    #$A763
A78C: A6 1E       LDA    -$2,X
A78E: 48          ASLA
A78F: EE C6       LDU    A,U
A791: EC C5       LDD    B,U
A793: BD A8 68    JSR    $A868
A796: BD 68 F9    JSR    $68F9
A799: C4 07       ANDB   #$07
A79B: CE A7 CE    LDU    #$A7CE
A79E: E6 C5       LDB    B,U
A7A0: E7 0E       STB    $E,X
A7A2: 6C 15       INC    -$B,X
A7A4: 39          RTS
A7A5: 6A 0E       DEC    $E,X
A7A7: 26 03       BNE    $A7AC
A7A9: 6A 15       DEC    -$B,X
A7AB: 39          RTS
A7AC: BD A8 03    JSR    $A803
A7AF: A1 1E       CMPA   -$2,X
A7B1: 27 05       BEQ    $A7B8
A7B3: A7 1E       STA    -$2,X
A7B5: 6A 15       DEC    -$B,X
A7B7: 39          RTS
A7B8: D6 21       LDB    $21
A7BA: C5 3F       BITB   #$3F
A7BC: 26 03       BNE    $A7C1
A7BE: BD 79 FB    JSR    $79FB
A7C1: 6A 0F       DEC    $F,X
A7C3: 26 06       BNE    $A7CB
A7C5: CC 01 00    LDD    #$0100
A7C8: ED 14       STD    -$C,X
A7CA: 39          RTS
A7CB: 7E 90 74    JMP    $9074

A7DE: E6 15       LDB    -$B,X
A7E0: 58          ASLB
A7E1: CE A7 E6    LDU    #jump_table_a7e6
A7E4: 6E D5       JMP    [B,U]        ; [indirect_jump]

A7EA: BD A8 03    JSR    $A803
A7ED: E7 1E       STB    -$2,X
A7EF: BD A8 57    JSR    $A857
A7F2: CC 49 6A    LDD    #$496A
A7F5: ED 1C       STD    -$4,X
A7F7: 6C 15       INC    -$B,X
A7F9: 39          RTS
A7FA: BD A4 27    JSR    $A427
A7FD: BD 90 74    JSR    $9074
A800: 7E 8F 62    JMP    $8F62
A803: BD 8F E4    JSR    $8FE4
A806: 86 01       LDA    #$01
A808: C1 04       CMPB   #$04
A80A: 25 05       BCS    $A811
A80C: C1 0C       CMPB   #$0C
A80E: 22 01       BHI    $A811
A810: 4F          CLRA
A811: 39          RTS
A812: 58          ASLB
A813: CE A8 18    LDU    #jump_table_a818
A816: 6E D5       JMP    [B,U]        ; [indirect_jump]

A81C: E6 15       LDB    -$B,X
A81E: 58          ASLB
A81F: CE A8 24    LDU    #$A824
A822: 6E D5       JMP    [B,U]        ; [indirect_jump]

A828: BD A8 55    JSR    $A855
A82B: CC 49 62    LDD    #$4962
A82E: ED 1C       STD    -$4,X
A830: 6C 15       INC    -$B,X
A832: 39          RTS
A833: BD A4 27    JSR    $A427
A836: BD A5 3E    JSR    $A53E
A839: BD 90 74    JSR    $9074
A83C: 7E 8F 62    JMP    $8F62
A83F: 58          ASLB
A840: CE A8 45    LDU    #jump_table_a845
A843: 6E D5       JMP    [B,U]        ; [indirect_jump]

A849: E6 15       LDB    -$B,X
A84B: 58          ASLB
A84C: CE A8 51    LDU    #$A851
A84F: 6E D5       JMP    [B,U]        ; [indirect_jump]

A855: A6 1E       LDA    -$2,X
A857: 48          ASLA
A858: CE A7 67    LDU    #$A767
A85B: E6 12       LDB    -$E,X
A85D: C1 03       CMPB   #$03
A85F: 27 03       BEQ    $A864
A861: CE A7 63    LDU    #$A763
A864: EE C6       LDU    A,U
A866: EC 46       LDD    $6,U
A868: ED 84       STD    ,X
A86A: ED 03       STD    $3,X
A86C: 6F 02       CLR    $2,X
A86E: 39          RTS
A86F: 58          ASLB
A870: CE A8 75    LDU    #jump_table_a875
A873: 6E D5       JMP    [B,U]        ; [indirect_jump]

A87B: BD 79 B5    JSR    $79B5
A87E: CC 01 00    LDD    #$0100
A881: ED 14       STD    -$C,X
A883: 39          RTS
A884: CC 03 00    LDD    #$0300
A887: ED 13       STD    -$D,X
A889: E7 15       STB    -$B,X
A88B: 39          RTS
A88C: E6 05       LDB    $5,X
A88E: CE 00 30    LDU    #$0030
A891: 6C C5       INC    B,U
A893: 4F          CLRA
A894: 5F          CLRB
A895: ED 10       STD    -$10,X
A897: ED 13       STD    -$D,X
A899: 7E 8E 0C    JMP    $8E0C
A89C: EC 13       LDD    -$D,X
A89E: 48          ASLA
A89F: CE A8 A4    LDU    #jump_table_a8a4
A8A2: 6E D6       JMP    [A,U]        ; [indirect_jump]

A8AC: E6 12       LDB    -$E,X
A8AE: 58          ASLB
A8AF: CE A8 B4    LDU    #$A8B4
A8B2: 6E D5       JMP    [B,U]        ; [indirect_jump]

A8BA: E6 14       LDB    -$C,X
A8BC: 58          ASLB
A8BD: CE A8 C2    LDU    #jump_table_a8c2
A8C0: 6E D5       JMP    [B,U]        ; [indirect_jump]

A8C6: BD 8E 41    JSR    $8E41
A8C9: 68 10       ASL    -$10,X
A8CB: BD A9 61    JSR    $A961
A8CE: 10 8E AA 19 LDY    #$AA19
A8D2: 6F 1E       CLR    -$2,X
A8D4: EC 16       LDD    -$A,X
A8D6: 10 93 A0    CMPD   $A0
A8D9: 2F 08       BLE    $A8E3
A8DB: 10 8E AA 2D LDY    #$AA2D
A8DF: C6 01       LDB    #$01
A8E1: E7 1E       STB    -$2,X
A8E3: 10 AF 84    STY    ,X
A8E6: 10 AF 03    STY    $3,X
A8E9: 6F 02       CLR    $2,X
A8EB: CC AA 8B    LDD    #$AA8B
A8EE: ED 88 19    STD    $19,X
A8F1: 6F 88 1B    CLR    $1B,X
A8F4: 86 01       LDA    #$01
A8F6: A7 0C       STA    $C,X
A8F8: 39          RTS
A8F9: BD A9 61    JSR    $A961
A8FC: C6 02       LDB    #$02
A8FE: E7 1E       STB    -$2,X
A900: 10 8E AA 41 LDY    #$AA41
A904: 10 AF 84    STY    ,X
A907: 10 AF 03    STY    $3,X
A90A: 6F 02       CLR    $2,X
A90C: CC AA CB    LDD    #$AACB
A90F: ED 88 19    STD    $19,X
A912: 86 01       LDA    #$01
A914: A7 88 1B    STA    $1B,X
A917: 86 01       LDA    #$01
A919: A7 0C       STA    $C,X
A91B: 39          RTS
A91C: 68 10       ASL    -$10,X
A91E: BD A9 61    JSR    $A961
A921: 10 8E A9 BF LDY    #$A9BF
A925: 6F 1E       CLR    -$2,X
A927: EC 16       LDD    -$A,X
A929: 10 93 A0    CMPD   $A0
A92C: 2F 08       BLE    $A936
A92E: 10 8E A9 D3 LDY    #$A9D3
A932: C6 01       LDB    #$01
A934: E7 1E       STB    -$2,X
A936: 10 AF 84    STY    ,X
A939: 10 AF 03    STY    $3,X
A93C: 6F 02       CLR    $2,X
A93E: CC AA 8B    LDD    #$AA8B
A941: ED 88 19    STD    $19,X
A944: 6F 88 1B    CLR    $1B,X
A947: CE AD 43    LDU    #$AD43
A94A: BD 68 F9    JSR    $68F9
A94D: C4 0F       ANDB   #$0F
A94F: A6 C5       LDA    B,U
A951: A7 0F       STA    $F,X
A953: BD 68 F9    JSR    $68F9
A956: C4 1F       ANDB   #$1F
A958: CB 40       ADDB   #$40
A95A: E7 0E       STB    $E,X
A95C: 6F 0D       CLR    $D,X
A95E: 6F 0C       CLR    $C,X
A960: 39          RTS
A961: E6 12       LDB    -$E,X
A963: E7 88 1C    STB    $1C,X
A966: C6 00       LDB    #$00
A968: E7 1F       STB    -$1,X
A96A: CC AA 73    LDD    #$AA73
A96D: ED 1C       STD    -$4,X
A96F: 86 04       LDA    #$04
A971: A7 88 15    STA    $15,X
A974: 86 02       LDA    #$02
A976: A7 0B       STA    $B,X
A978: DC A2       LDD    $A2
A97A: ED 88 13    STD    $13,X
A97D: CC 01 00    LDD    #$0100
A980: ED 13       STD    -$D,X
A982: E7 15       STB    -$B,X
A984: 39          RTS
A985: BD A4 27    JSR    $A427
A988: EC 19       LDD    -$7,X
A98A: 10 83 00 35 CMPD   #$0035
A98E: 22 05       BHI    $A995
A990: CC 00 36    LDD    #$0036
A993: ED 19       STD    -$7,X
A995: 6D 88 1C    TST    $1C,X
A998: 26 14       BNE    $A9AE
A99A: EC 16       LDD    -$A,X
A99C: 10 83 11 ED CMPD   #$11ED
A9A0: 25 0C       BCS    $A9AE
A9A2: 10 93 A0    CMPD   $A0
A9A5: 24 07       BCC    $A9AE
A9A7: 6F 0B       CLR    $B,X
A9A9: CC 03 00    LDD    #$0300
A9AC: ED 14       STD    -$C,X
A9AE: 39          RTS

AB4B: D6 21       LDB    $21
AB4D: DB E0       ADDB   $E0
AB4F: C4 1F       ANDB   #$1F
AB51: 26 03       BNE    $AB56
AB53: BD 79 8D    JSR    $798D
AB56: E6 14       LDB    -$C,X
AB58: 58          ASLB
AB59: CE AB 67    LDU    #jump_table_ab67
AB5C: AD D5       JSR    [B,U]        ; [indirect_jump]
AB5E: 6D 88 1C    TST    $1C,X
AB61: 26 03       BNE    $AB66
AB63: 7E B2 5E    JMP    $B25E
AB66: 39          RTS

AB6F: E6 15       LDB    -$B,X
AB71: 58          ASLB
AB72: CE AB 77    LDU    #jump_table_ab77
AB75: 6E D5       JMP    [B,U]        ; [indirect_jump]

AB7B: BD AD 1E    JSR    $AD1E
AB7E: A6 06       LDA    $6,X
AB80: A7 88 18    STA    $18,X
AB83: 6C 15       INC    -$B,X
AB85: A6 06       LDA    $6,X
AB87: 81 05       CMPA   #$05
AB89: 27 09       BEQ    $AB94
AB8B: 6A 06       DEC    $6,X
AB8D: 26 12       BNE    $ABA1
AB8F: 6C 14       INC    -$C,X
AB91: 6F 15       CLR    -$B,X
AB93: 39          RTS
AB94: 6A 06       DEC    $6,X
AB96: 6D 0F       TST    $F,X
AB98: 26 07       BNE    $ABA1
AB9A: 86 01       LDA    #$01
AB9C: A7 0D       STA    $D,X
AB9E: 17 02 5D    LBSR   $ADFE
ABA1: A6 88 18    LDA    $18,X
ABA4: A0 06       SUBA   $6,X
ABA6: 81 20       CMPA   #$20
ABA8: 26 09       BNE    $ABB3
ABAA: C6 01       LDB    #$01
ABAC: E7 10       STB    -$10,X
ABAE: CE AA 7F    LDU    #$AA7F
ABB1: EF 1C       STU    -$4,X
ABB3: BD A4 27    JSR    $A427
ABB6: BD 90 74    JSR    $9074
ABB9: 7E 8F 62    JMP    $8F62
ABBC: AD D5       JSR    [B,U]	; [special_indirect_jump] (jumped to)
ABBE: BD A9 85    JSR    $A985
ABC1: BD 90 74    JSR    $9074
ABC4: 7E 8F 62    JMP    $8F62

ABCF: E6 15       LDB    -$B,X
ABD1: 58          ASLB
ABD2: CE AB D7    LDU    #jump_table_abd7
ABD5: 6E D5       JMP    [B,U]        ; [indirect_jump]

ABDF: 6A 88 15    DEC    $15,X
ABE2: 27 23       BEQ    $AC07
ABE4: BD AD 28    JSR    $AD28
ABE7: CE AB 0B    LDU    #$AB0B
ABEA: EF 1C       STU    -$4,X
ABEC: DC A2       LDD    $A2
ABEE: ED 88 13    STD    $13,X
ABF1: 17 01 5F    LBSR   $AD53
ABF4: CC A9 E7    LDD    #$A9E7
ABF7: 6D 0C       TST    $C,X
ABF9: 27 03       BEQ    $ABFE
ABFB: CC AA 41    LDD    #$AA41
ABFE: ED 84       STD    ,X
AC00: ED 03       STD    $3,X
AC02: 6F 02       CLR    $2,X
AC04: 6C 15       INC    -$B,X
AC06: 39          RTS
AC07: CC 03 00    LDD    #$0300
AC0A: ED 14       STD    -$C,X
AC0C: 39          RTS
AC0D: 17 01 EE    LBSR   $ADFE
AC10: 6A 06       DEC    $6,X
AC12: 26 08       BNE    $AC1C
AC14: EE 88 19    LDU    $19,X
AC17: EF 1C       STU    -$4,X
AC19: 6C 15       INC    -$B,X
AC1B: 39          RTS
AC1C: CE AB C7    LDU    #$ABC7
AC1F: E6 0B       LDB    $B,X
AC21: 58          ASLB
AC22: 7E AB BC    JMP    $ABBC
AC25: BD AD 1E    JSR    $AD1E
AC28: DC A2       LDD    $A2
AC2A: ED 88 13    STD    $13,X
AC2D: 17 01 23    LBSR   $AD53
AC30: 6C 15       INC    -$B,X
AC32: 39          RTS
AC33: BD AD FE    JSR    $ADFE
AC36: 6A 06       DEC    $6,X
AC38: 26 03       BNE    $AC3D
AC3A: 6F 15       CLR    -$B,X
AC3C: 39          RTS
AC3D: CE AB C7    LDU    #jump_table_abc7
AC40: E6 0B       LDB    $B,X
AC42: 58          ASLB
AC43: 7E AB BC    JMP    $ABBC
AC46: E6 15       LDB    -$B,X
AC48: 58          ASLB
AC49: CE AC 4E    LDU    #$AC4E
AC4C: 6E D5       JMP    [B,U]        ; [indirect_jump]

AC56: EE 88 19    LDU    $19,X
AC59: EF 1C       STU    -$4,X
AC5B: 86 02       LDA    #$02
AC5D: A7 88 10    STA    $10,X
AC60: CE AA 1F    LDU    #$AA1F
AC63: 86 0F       LDA    #$0F
AC65: A7 1E       STA    -$2,X
AC67: 6D 88 11    TST    $11,X
AC6A: 27 19       BEQ    $AC85
AC6C: CE AA 33    LDU    #$AA33
AC6F: 86 09       LDA    #$09
AC71: A7 1E       STA    -$2,X
AC73: A6 88 11    LDA    $11,X
AC76: 81 01       CMPA   #$01
AC78: 27 09       BEQ    $AC83
AC7A: CE AA 41    LDU    #$AA41
AC7D: 86 0C       LDA    #$0C
AC7F: A7 1E       STA    -$2,X
AC81: 6C 15       INC    -$B,X
AC83: 6C 15       INC    -$B,X
AC85: 6C 15       INC    -$B,X
AC87: EF 84       STU    ,X
AC89: EF 03       STU    $3,X
AC8B: 39          RTS
AC8C: 6A 88 10    DEC    $10,X
AC8F: 26 0D       BNE    $AC9E
AC91: 86 02       LDA    #$02
AC93: A7 88 10    STA    $10,X
AC96: A6 1E       LDA    -$2,X
AC98: 81 08       CMPA   #$08
AC9A: 27 05       BEQ    $ACA1
AC9C: 6A 1E       DEC    -$2,X
AC9E: 7E AB BE    JMP    $ABBE
ACA1: CC 01 00    LDD    #$0100
ACA4: ED 14       STD    -$C,X
ACA6: 39          RTS
ACA7: 6A 88 10    DEC    $10,X
ACAA: 26 F2       BNE    $AC9E
ACAC: 86 01       LDA    #$01
ACAE: A7 88 10    STA    $10,X
ACB1: A6 1E       LDA    -$2,X
ACB3: 81 0F       CMPA   #$0F
ACB5: 27 EA       BEQ    $ACA1
ACB7: 6C 1E       INC    -$2,X
ACB9: 7E AB BE    JMP    $ABBE
ACBC: 6A 88 10    DEC    $10,X
ACBF: 26 DD       BNE    $AC9E
ACC1: 86 02       LDA    #$02
ACC3: A7 88 10    STA    $10,X
ACC6: A6 1E       LDA    -$2,X
ACC8: 81 04       CMPA   #$04
ACCA: 27 D5       BEQ    $ACA1
ACCC: 80 08       SUBA   #$08
ACCE: A7 1E       STA    -$2,X
ACD0: 7E AB BE    JMP    $ABBE
ACD3: E6 15       LDB    -$B,X
ACD5: 58          ASLB
ACD6: CE AC DB    LDU    #jump_table_acdb
ACD9: 6E D5       JMP    [B,U]        ; [indirect_jump]

ACDF: CE AC F0    LDU    #$ACF0
ACE2: E6 0B       LDB    $B,X
ACE4: A6 C5       LDA    B,U
ACE6: A7 1E       STA    -$2,X
ACE8: EE 88 19    LDU    $19,X
ACEB: EF 1C       STU    -$4,X
ACED: 6C 15       INC    -$B,X
ACEF: 39          RTS
ACF0: 08 00       ASL    $00
ACF2: 00 08       NEG    $08
ACF4: 6A 07       DEC    $7,X
ACF6: 26 10       BNE    $AD08
ACF8: A6 1E       LDA    -$2,X
ACFA: A1 88 12    CMPA   $12,X
ACFD: 27 09       BEQ    $AD08
ACFF: 4C          INCA
AD00: 84 0F       ANDA   #$0F
AD02: A7 1E       STA    -$2,X
AD04: A6 08       LDA    $8,X
AD06: A7 07       STA    $7,X
AD08: 39          RTS
AD09: 6A 07       DEC    $7,X
AD0B: 26 10       BNE    $AD1D
AD0D: A6 1E       LDA    -$2,X
AD0F: A1 88 12    CMPA   $12,X
AD12: 27 09       BEQ    $AD1D
AD14: 4A          DECA
AD15: 84 0F       ANDA   #$0F
AD17: A7 1E       STA    -$2,X
AD19: A6 08       LDA    $8,X
AD1B: A7 07       STA    $7,X
AD1D: 39          RTS
AD1E: BD 68 F9    JSR    $68F9
AD21: C4 1F       ANDB   #$1F
AD23: CB 50       ADDB   #$50
AD25: E7 06       STB    $6,X
AD27: 39          RTS
AD28: D6 9A       LDB    $9A
AD2A: 54          LSRB
AD2B: 54          LSRB
AD2C: 54          LSRB
AD2D: 54          LSRB
AD2E: CE AD 3F    LDU    #$AD3F
AD31: A6 C5       LDA    B,U
AD33: BD 68 F9    JSR    $68F9
AD36: C4 2F       ANDB   #$2F
AD38: D7 E1       STB    $E1
AD3A: 9B E1       ADDA   $E1
AD3C: A7 06       STA    $6,X
AD3E: 39          RTS

AD53: A6 1A       LDA    -$6,X
AD55: 90 A3       SUBA   $A3
AD57: 24 03       BCC    $AD5C
AD59: 40          NEGA
AD5A: 8B 0A       ADDA   #$0A
AD5C: 44          LSRA
AD5D: 6D 88 1B    TST    $1B,X
AD60: 27 01       BEQ    $AD63
AD62: 44          LSRA
AD63: 44          LSRA
AD64: 27 0F       BEQ    $AD75
AD66: A7 07       STA    $7,X
AD68: A7 08       STA    $8,X
AD6A: BD 8F E4    JSR    $8FE4
AD6D: 58          ASLB
AD6E: CE AD AC    LDU    #$ADAC
AD71: EE C5       LDU    B,U
AD73: 20 13       BRA    $AD88
AD75: 86 05       LDA    #$05
AD77: A7 07       STA    $7,X
AD79: A7 08       STA    $8,X
AD7B: CE AD DB    LDU    #$ADDB
AD7E: DC A0       LDD    $A0
AD80: 10 A3 16    CMPD   -$A,X
AD83: 25 03       BCS    $AD88
AD85: CE AD D8    LDU    #$ADD8
AD88: A6 C0       LDA    ,U+
AD8A: A7 0B       STA    $B,X
AD8C: A6 C0       LDA    ,U+
AD8E: A7 1E       STA    -$2,X
AD90: A6 C4       LDA    ,U
AD92: A7 88 12    STA    $12,X
AD95: 8D 47       BSR    $ADDE
AD97: CE A9 AF    LDU    #$A9AF
AD9A: E6 0B       LDB    $B,X
AD9C: 6D 0C       TST    $C,X
AD9E: 27 02       BEQ    $ADA2
ADA0: CB 04       ADDB   #$04
ADA2: 58          ASLB
ADA3: EC C5       LDD    B,U
ADA5: ED 84       STD    ,X
ADA7: ED 03       STD    $3,X
ADA9: 6F 02       CLR    $2,X
ADAB: 39          RTS

ADE3: 10 A3 16    CMPD   -$A,X
ADE6: 22 15       BHI    $ADFD
ADE8: C3 00 3C    ADDD   #$003C
ADEB: 10 A3 16    CMPD   -$A,X
ADEE: 25 0D       BCS    $ADFD
ADF0: DC A2       LDD    $A2
ADF2: 10 A3 19    CMPD   -$7,X
ADF5: 22 06       BHI    $ADFD
ADF7: 86 0A       LDA    #$0A
ADF9: A7 07       STA    $7,X
ADFB: A7 08       STA    $8,X
ADFD: 39          RTS
ADFE: 6A 0E       DEC    $E,X
AE00: 26 04       BNE    $AE06
AE02: 86 01       LDA    #$01
AE04: A7 0D       STA    $D,X
AE06: 6D 0C       TST    $C,X
AE08: 26 03       BNE    $AE0D
AE0A: 17 00 01    LBSR   $AE0E
AE0D: 39          RTS
AE0E: 6D 0D       TST    $D,X
AE10: 27 44       BEQ    $AE56
AE12: D6 A7       LDB    $A7
AE14: 27 40       BEQ    $AE56
AE16: DC A2       LDD    $A2
AE18: C3 00 10    ADDD   #$0010
AE1B: 10 A3 19    CMPD   -$7,X
AE1E: 25 1A       BCS    $AE3A
AE20: 83 00 10    SUBD   #$0010
AE23: 10 A3 19    CMPD   -$7,X
AE26: 22 12       BHI    $AE3A
AE28: DC A0       LDD    $A0
AE2A: 83 00 32    SUBD   #$0032
AE2D: 10 A3 16    CMPD   -$A,X
AE30: 22 25       BHI    $AE57
AE32: C3 00 64    ADDD   #$0064
AE35: 10 A3 16    CMPD   -$A,X
AE38: 25 1D       BCS    $AE57
AE3A: DC A0       LDD    $A0
AE3C: 83 00 05    SUBD   #$0005
AE3F: 10 A3 16    CMPD   -$A,X
AE42: 22 12       BHI    $AE56
AE44: C3 00 0A    ADDD   #$000A
AE47: 10 A3 16    CMPD   -$A,X
AE4A: 25 0A       BCS    $AE56
AE4C: DC A2       LDD    $A2
AE4E: C3 00 3C    ADDD   #$003C
AE51: 10 A3 19    CMPD   -$7,X
AE54: 25 13       BCS    $AE69
AE56: 39          RTS
AE57: BD 8E 2E    JSR    $8E2E
AE5A: 86 01       LDA    #$01
AE5C: A7 3E       STA    -$2,Y
AE5E: DC A0       LDD    $A0
AE60: 10 A3 16    CMPD   -$A,X
AE63: 25 02       BCS    $AE67
AE65: 6F 3E       CLR    -$2,Y
AE67: 20 07       BRA    $AE70
AE69: BD 8E 2E    JSR    $8E2E
AE6C: 86 02       LDA    #$02
AE6E: A7 3E       STA    -$2,Y
AE70: D6 9A       LDB    $9A
AE72: C4 30       ANDB   #$30
AE74: 54          LSRB
AE75: 54          LSRB
AE76: 54          LSRB
AE77: 54          LSRB
AE78: E7 26       STB    $6,Y
AE7A: EC 16       LDD    -$A,X
AE7C: ED 36       STD    -$A,Y
AE7E: EC 19       LDD    -$7,X
AE80: 83 00 0A    SUBD   #$000A
AE83: ED 39       STD    -$7,Y
AE85: 4F          CLRA
AE86: 5F          CLRB
AE87: ED 33       STD    -$D,Y
AE89: E7 35       STB    -$B,Y
AE8B: 4C          INCA
AE8C: ED 30       STD    -$10,Y
AE8E: C6 08       LDB    #$08
AE90: E7 25       STB    $5,Y
AE92: 86 01       LDA    #$01
AE94: A7 0C       STA    $C,X
AE96: A6 3E       LDA    -$2,Y
AE98: A7 88 11    STA    $11,X
AE9B: CC 02 00    LDD    #$0200
AE9E: ED 14       STD    -$C,X
AEA0: 39          RTS
AEA1: 58          ASLB
AEA2: CE AE A7    LDU    #jump_table_aea7
AEA5: 6E D5       JMP    [B,U]        ; [indirect_jump]
AEAB: AE B6       LDX    [A,Y]
AEAD: BD 79 B5    JSR    $79B5
AEB0: CC 01 00    LDD    #$0100
AEB3: ED 14       STD    -$C,X
AEB5: 39          RTS
AEB6: CC 03 00    LDD    #$0300
AEB9: ED 13       STD    -$D,X
AEBB: E7 15       STB    -$B,X
AEBD: 39          RTS
AEBE: CE 00 30    LDU    #$0030
AEC1: E6 05       LDB    $5,X
AEC3: 6C C5       INC    B,U
AEC5: 4F          CLRA
AEC6: 5F          CLRB
AEC7: ED 10       STD    -$10,X
AEC9: ED 13       STD    -$D,X
AECB: 7E 8E 0C    JMP    $8E0C
AECE: E6 15       LDB    -$B,X
AED0: 58          ASLB
AED1: CE AE D6    LDU    #jump_table_aed6
AED4: 6E D5       JMP    [B,U]        ; [indirect_jump]

AEDA: CC A6 31    LDD    #$A631
AEDD: ED 03       STD    $3,X
AEDF: 6F 16       CLR    -$A,X
AEE1: 6F 19       CLR    -$7,X
AEE3: 7C 15 77    INC    $1577
AEE6: B6 15 77    LDA    $1577
AEE9: 84 01       ANDA   #$01
AEEB: B7 15 77    STA    $1577
AEEE: A7 06       STA    $6,X
AEF0: CE AF 79    LDU    #$AF79
AEF3: 8D 07       BSR    $AEFC
AEF5: C6 09       LDB    #$09
AEF7: E7 07       STB    $7,X
AEF9: 6C 15       INC    -$B,X
AEFB: 39          RTS
AEFC: 10 AE C1    LDY    ,U++
AEFF: EF 08       STU    $8,X
AF01: E6 A0       LDB    ,Y+
AF03: E7 0A       STB    $A,X
AF05: A6 06       LDA    $6,X
AF07: 26 05       BNE    $AF0E
AF09: 5A          DECB
AF0A: 58          ASLB
AF0B: 58          ASLB
AF0C: 31 A5       LEAY   B,Y
AF0E: 10 AF 0B    STY    $B,X
AF11: 39          RTS
AF12: 10 AE 0B    LDY    $B,X
AF15: DC 9C       LDD    $9C
AF17: 10 A3 A4    CMPD   ,Y
AF1A: 22 3B       BHI    $AF57
AF1C: 4C          INCA
AF1D: 10 A3 A4    CMPD   ,Y
AF20: 25 35       BCS    $AF57
AF22: DC 9E       LDD    $9E
AF24: C3 00 20    ADDD   #$0020
AF27: 10 A3 22    CMPD   $2,Y
AF2A: 22 2B       BHI    $AF57
AF2C: C3 00 C0    ADDD   #$00C0
AF2F: 10 A3 22    CMPD   $2,Y
AF32: 25 23       BCS    $AF57
AF34: FC 15 74    LDD    $1574
AF37: 10 A3 22    CMPD   $2,Y
AF3A: 26 08       BNE    $AF44
AF3C: FC 15 78    LDD    $1578
AF3F: 10 A3 A4    CMPD   ,Y
AF42: 27 13       BEQ    $AF57
AF44: EC A4       LDD    ,Y
AF46: ED 16       STD    -$A,X
AF48: FD 15 78    STD    $1578
AF4B: EC 22       LDD    $2,Y
AF4D: ED 19       STD    -$7,X
AF4F: FD 15 74    STD    $1574
AF52: 86 01       LDA    #$01
AF54: A7 14       STA    -$C,X
AF56: 39          RTS
AF57: 31 3C       LEAY   -$4,Y
AF59: 6D 06       TST    $6,X
AF5B: 27 02       BEQ    $AF5F
AF5D: 31 28       LEAY   $8,Y
AF5F: 10 AF 0B    STY    $B,X
AF62: 6A 0A       DEC    $A,X
AF64: 26 0E       BNE    $AF74
AF66: EE 08       LDU    $8,X
AF68: BD AE FC    JSR    $AEFC
AF6B: 6A 07       DEC    $7,X
AF6D: 26 05       BNE    $AF74
AF6F: CC 03 00    LDD    #$0300
AF72: ED 13       STD    -$D,X
AF74: 39          RTS

AFFE: 48          ASLA
AFFF: CE B0 04    LDU    #jump_table_b004
B002: 6E D6       JMP    [A,U]        ; [indirect_jump]

B00C: 4F          CLRA 
B00D: 5F          CLRB
B00E: ED 06       STD    $6,X
B010: ED 08       STD    $8,X
B012: ED 0A       STD    $A,X
B014: C6 01       LDB    #$01
B016: E7 1F       STB    -$1,X
B018: C6 00       LDB    #$00
B01A: E7 1E       STB    -$2,X
B01C: CE B0 37    LDU    #$B037
B01F: BD 90 6B    JSR    $906B
B022: CE B0 4F    LDU    #$B04F
B025: D6 9A       LDB    $9A
B027: C4 30       ANDB   #$30
B029: 54          LSRB
B02A: 54          LSRB
B02B: 54          LSRB
B02C: EE C5       LDU    B,U
B02E: EF 1C       STU    -$4,X
B030: 6C 13       INC    -$D,X
B032: 4F          CLRA
B033: 5F          CLRB
B034: ED 14       STD    -$C,X
B036: 39          RTS
B037: B0 3B B0    SUBA   $3BB0
B03A: 45          LSRA
B03B: 73 20 72    COM    $2072
B03E: 03 75       COM    $75
B040: 20 74       BRA    $B0B6

B077: 58          ASLB    
B078: CE B0 89    LDU    #jump_table_b089
B07B: AD D5       JSR    [B,U]	; [indirect_jump]
B07D: D6 21       LDB    $21
B07F: 5C          INCB
B080: C4 1F       ANDB   #$1F
B082: 10 26 DE DC LBNE   $8F62
B086: 7E 79 E2    JMP    $79E2

B08F: C6 32       LDB    #$32
B091: E7 06       STB    $6,X
B093: EC 19       LDD    -$7,X
B095: ED 07       STD    $7,X
B097: 6F 09       CLR    $9,X
B099: C6 81       LDB    #$81
B09B: E7 10       STB    -$10,X
B09D: BD 68 F9    JSR    $68F9
B0A0: 4F          CLRA
B0A1: C4 01       ANDB   #$01
B0A3: 26 03       BNE    $B0A8
B0A5: 4C          INCA
B0A6: 6C 14       INC    -$C,X
B0A8: 6C 14       INC    -$C,X
B0AA: A7 1E       STA    -$2,X
B0AC: CE B0 37    LDU    #$B037
B0AF: BD 90 6B    JSR    $906B
B0B2: 39          RTS
B0B3: 8D 18       BSR    $B0CD
B0B5: E3 0A       ADDD   $A,X
B0B7: ED 19       STD    -$7,X
B0B9: E6 09       LDB    $9,X
B0BB: CB 06       ADDB   #$06
B0BD: 24 0B       BCC    $B0CA
B0BF: 6C 1E       INC    -$2,X
B0C1: CE B0 37    LDU    #$B037
B0C4: BD 90 6B    JSR    $906B
B0C7: 6C 14       INC    -$C,X
B0C9: 5F          CLRB
B0CA: E7 09       STB    $9,X
B0CC: 39          RTS
B0CD: BD A4 27    JSR    $A427
B0D0: BD 90 74    JSR    $9074
B0D3: E6 10       LDB    -$10,X
B0D5: 2A 0B       BPL    $B0E2
B0D7: EC 16       LDD    -$A,X
B0D9: 10 93 A0    CMPD   $A0
B0DC: 24 04       BCC    $B0E2
B0DE: C6 01       LDB    #$01
B0E0: E7 10       STB    -$10,X
B0E2: C6 04       LDB    #$04
B0E4: F7 3E 00    STB    bankswitch_3e00
B0E7: E6 09       LDB    $9,X
B0E9: CE 41 40    LDU    #$4140
B0EC: 4F          CLRA
B0ED: E6 CB       LDB    D,U
B0EF: 58          ASLB
B0F0: A6 06       LDA    $6,X
B0F2: 3D          MUL
B0F3: 1F 89       TFR    A,B
B0F5: 4F          CLRA
B0F6: ED 0A       STD    $A,X
B0F8: EC 07       LDD    $7,X
B0FA: 39          RTS
B0FB: 8D D0       BSR    $B0CD
B0FD: A3 0A       SUBD   $A,X
B0FF: ED 19       STD    -$7,X
B101: E6 09       LDB    $9,X
B103: CB 06       ADDB   #$06
B105: 24 0D       BCC    $B114
B107: C6 01       LDB    #$01
B109: E7 14       STB    -$C,X
B10B: 6F 1E       CLR    -$2,X
B10D: CE B0 37    LDU    #$B037
B110: BD 90 6B    JSR    $906B
B113: 5F          CLRB
B114: E7 09       STB    $9,X
B116: 39          RTS

B117: 58          ASLB
B118: CE B1 1D    LDU    #jump_table_b11d
B11B: 6E D5       JMP    [B,U]        ; [indirect_jump]

B123: BD 79 CE    JSR    $79CE
B126: CC 01 00    LDD    #$0100
B129: ED 14       STD    -$C,X
B12B: 39          RTS
B12C: CC 03 00    LDD    #$0300
B12F: ED 13       STD    -$D,X
B131: E7 15       STB    -$B,X
B133: 39          RTS
B134: CE 00 30    LDU    #$0030
B137: E6 05       LDB    $5,X
B139: 6C C5       INC    B,U
B13B: 4F          CLRA
B13C: 5F          CLRB
B13D: ED 10       STD    -$10,X
B13F: ED 13       STD    -$D,X
B141: E7 15       STB    -$B,X
B143: 7E 8E 0C    JMP    $8E0C
B146: EC 13       LDD    -$D,X
B148: 48          ASLA
B149: CE B1 4E    LDU    #jump_table_b14e
B14C: 6E D6       JMP    [A,U]        ; [indirect_jump]

B156: E6 12       LDB    -$E,X
B158: 58          ASLB
B159: CE B1 5E    LDU    #$B15E
B15C: 6E D5       JMP    [B,U]        ; [indirect_jump]

B166: 58          ASLB
B167: CE B1 6C    LDU    #jump_table_b16c
B16A: 6E D5       JMP    [B,U]        ; [indirect_jump]

B170: EC 19       LDD    -$7,X
B172: ED 06       STD    $6,X
B174: C6 10       LDB    #$10
B176: E7 0C       STB    $C,X
B178: 4F          CLRA
B179: 5F          CLRB
B17A: E7 08       STB    $8,X
B17C: ED 09       STD    $9,X
B17E: C6 00       LDB    #$00
B180: E7 1F       STB    -$1,X
B182: BD B2 22    JSR    $B222
B185: CE B2 8D    LDU    #$B28D
B188: BD 90 6B    JSR    $906B
B18B: CC B2 30    LDD    #$B230
B18E: ED 1C       STD    -$4,X
B190: 6C 14       INC    -$C,X
B192: 39          RTS
B193: EC 16       LDD    -$A,X
B195: 93 9C       SUBD   $9C
B197: 83 00 10    SUBD   #$0010
B19A: 10 83 00 E0 CMPD   #$00E0
B19E: 23 09       BLS    $B1A9
B1A0: 7E 90 74    JMP    $9074
B1A3: BD A4 27    JSR    $A427
B1A6: 7E A4 27    JMP    $A427
B1A9: D6 9A       LDB    $9A
B1AB: C4 30       ANDB   #$30
B1AD: 54          LSRB
B1AE: 54          LSRB
B1AF: 54          LSRB
B1B0: CE B1 BD    LDU    #$B1BD
B1B3: EC C5       LDD    B,U
B1B5: ED 88 1E    STD    $1E,X
B1B8: 6F 14       CLR    -$C,X
B1BA: 6C 13       INC    -$D,X
B1BC: 39          RTS
B1BD: 0E 10       JMP    $10
B1BF: 0A 8C       DEC    $8C
B1C1: 07 08       ASR    $08
B1C3: 04 B0       LSR    $B0
B1C5: E6 14       LDB    -$C,X
B1C7: 58          ASLB
B1C8: CE B1 CD    LDU    #jump_table_b1cd		; only 1 valid entry!
B1CB: 6E D5       JMP    [B,U]        ; [indirect_jump]

B1D4: C4 0F       ANDB   #$0F
B1D6: CB 0A       ADDB   #$0A
B1D8: E7 88 10    STB    $10,X
B1DB: CC A6 31    LDD    #$A631
B1DE: ED 03       STD    $3,X
B1E0: 6C 14       INC    -$C,X
B1E2: 6A 88 10    DEC    $10,X
B1E5: 26 04       BNE    $B1EB
B1E7: 64 10       LSR    -$10,X
B1E9: 6C 14       INC    -$C,X
B1EB: 39          RTS
B1EC: 68 10       ASL    -$10,X
B1EE: BD 8E 41    JSR    $8E41
B1F1: BD B1 A9    JSR    $B1A9
B1F4: BD B1 70    JSR    $B170
B1F7: A6 1A       LDA    -$6,X
B1F9: 90 A3       SUBA   $A3
B1FB: 44          LSRA
B1FC: 44          LSRA
B1FD: 44          LSRA
B1FE: A7 88 11    STA    $11,X
B201: A7 88 10    STA    $10,X
B204: 86 0A       LDA    #$0A
B206: A7 88 12    STA    $12,X
B209: CC B2 AD    LDD    #$B2AD
B20C: ED 84       STD    ,X
B20E: ED 03       STD    $3,X
B210: 6F 02       CLR    $2,X
B212: CC 01 04    LDD    #$0104
B215: ED 13       STD    -$D,X
B217: 6F 15       CLR    -$B,X
B219: A6 12       LDA    -$E,X
B21B: 81 02       CMPA   #$02
B21D: 26 02       BNE    $B221
B21F: 6C 14       INC    -$C,X
B221: 39          RTS
B222: 6F 1E       CLR    -$2,X
B224: EC 16       LDD    -$A,X
B226: 10 93 A0    CMPD   $A0
B229: 2D 04       BLT    $B22F
B22B: C6 01       LDB    #$01
B22D: E7 1E       STB    -$2,X
B22F: 39          RTS

B238: 58          ASLB
B239: CE B2 6A    LDU    #jump_table_b26a
B23C: AD D5       JSR    [B,U]        ; [indirect_jump]
B23E: 8D 1E       BSR    $B25E
B240: 8D 03       BSR    $B245
B242: 7E 8F 62    JMP    $8F62
B245: EE 88 1E    LDU    $1E,X
B248: 33 5F       LEAU   -$1,U
B24A: EF 88 1E    STU    $1E,X
B24D: 26 0E       BNE    $B25D
B24F: C6 05       LDB    #$05
B251: E7 05       STB    $5,X
B253: C6 02       LDB    #$02
B255: E7 12       STB    -$E,X
B257: 4F          CLRA
B258: 5F          CLRB
B259: ED 13       STD    -$D,X
B25B: E7 15       STB    -$B,X
B25D: 39          RTS
B25E: E6 11       LDB    -$F,X
B260: 26 07       BNE    $B269
B262: CC 03 00    LDD    #$0300
B265: ED 13       STD    -$D,X
B267: 6F 15       CLR    -$B,X
B269: 39          RTS

B276: E6 15       LDB    -$B,X
B278: 58          ASLB
B279: CE B2 89    LDU    #jump_table_b289
B27C: AD D5       JSR    [B,U]    ; [indirect_jump]
B27E: BD B6 30    JSR    $B630
B281: 24 05       BCC    $B288
B283: CC 02 00    LDD    #$0200
B286: ED 14       STD    -$C,X
B288: 39          RTS

B2C3: BD B2 22    JSR    $B222
B2C6: C6 00       LDB    #$00
B2C8: E7 1F       STB    -$1,X
B2CA: CE B2 8D    LDU    #$B28D
B2CD: BD 90 6B    JSR    $906B
B2D0: BD 68 F9    JSR    $68F9
B2D3: CE B2 BF    LDU    #$B2BF
B2D6: C4 03       ANDB   #$03
B2D8: E6 C5       LDB    B,U
B2DA: E7 0D       STB    $D,X
B2DC: 6C 15       INC    -$B,X
B2DE: BD 90 74    JSR    $9074
B2E1: 6A 0D       DEC    $D,X
B2E3: 26 06       BNE    $B2EB
B2E5: CC 02 00    LDD    #$0200
B2E8: ED 14       STD    -$C,X
B2EA: 39          RTS
B2EB: BD 90 74    JSR    $9074
B2EE: BD A4 27    JSR    $A427
B2F1: EC 19       LDD    -$7,X
B2F3: 83 00 01    SUBD   #$0001
B2F6: ED 19       STD    -$7,X
B2F8: BD 8C A7    JSR    $8CA7
B2FB: 25 06       BCS    $B303
B2FD: CC 02 00    LDD    #$0200
B300: ED 14       STD    -$C,X
B302: 39          RTS
B303: 1D          SEX
B304: E3 19       ADDD   -$7,X
B306: ED 19       STD    -$7,X
B308: 39          RTS
B309: E6 15       LDB    -$B,X
B30B: 58          ASLB
B30C: CE B3 1C    LDU    #jump_table_b31c
B30F: AD D5       JSR    [B,U]        ; [indirect_jump]
B311: BD B6 30    JSR    $B630
B314: 24 05       BCC    $B31B
B316: CC 03 00    LDD    #$0300
B319: ED 14       STD    -$C,X
B31B: 39          RTS

B34C: CE B3 20    LDU    #$B320
B34F: BD 90 6B    JSR    $906B
B352: BD 68 F9    JSR    $68F9
B355: CE B3 48    LDU    #$B348
B358: C4 03       ANDB   #$03
B35A: E6 C5       LDB    B,U
B35C: E7 0D       STB    $D,X
B35E: 6C 15       INC    -$B,X
B360: BD 90 74    JSR    $9074
B363: 6A 0D       DEC    $D,X
B365: 10 26 F0 BE LBNE   $A427
B369: CC 03 00    LDD    #$0300
B36C: ED 14       STD    -$C,X
B36E: 39          RTS
B36F: E6 15       LDB    -$B,X
B371: 58          ASLB
B372: CE B3 77    LDU    #jump_table_b377
B375: 6E D5       JMP    [B,U]        ; [indirect_jump]

B37F: C6 02       LDB    #$02
B381: E7 1F       STB    -$1,X
B383: CE B3 20    LDU    #$B320
B386: BD 90 6B    JSR    $906B
B389: EC 19       LDD    -$7,X
B38B: ED 06       STD    $6,X
B38D: 4F          CLRA
B38E: 5F          CLRB
B38F: ED 09       STD    $9,X
B391: E7 08       STB    $8,X
B393: BD 68 F9    JSR    $68F9
B396: CE B3 7B    LDU    #$B37B
B399: C4 01       ANDB   #$01
B39B: E6 C5       LDB    B,U
B39D: E7 0C       STB    $C,X
B39F: 6C 15       INC    -$B,X
B3A1: BD A4 27    JSR    $A427
B3A4: BD 90 74    JSR    $9074
B3A7: EC 09       LDD    $9,X
B3A9: C3 04 00    ADDD   #$0400
B3AC: ED 09       STD    $9,X
B3AE: 2A 06       BPL    $B3B6
B3B0: CC 01 00    LDD    #$0100
B3B3: ED 14       STD    -$C,X
B3B5: 39          RTS
B3B6: CE 41 40    LDU    #$4140
B3B9: 1F 89       TFR    A,B
B3BB: 4F          CLRA
B3BC: E6 CB       LDB    D,U
B3BE: 2A 01       BPL    $B3C1
B3C0: 50          NEGB
B3C1: 58          ASLB
B3C2: A6 0C       LDA    $C,X
B3C4: 3D          MUL
B3C5: 1F 89       TFR    A,B
B3C7: 4F          CLRA
B3C8: E3 06       ADDD   $6,X
B3CA: ED 19       STD    -$7,X
B3CC: 39          RTS
B3CD: E6 15       LDB    -$B,X
B3CF: 58          ASLB
B3D0: CE B3 D5    LDU    #jump_table_b3d5
B3D3: 6E D5       JMP    [B,U]        ; [indirect_jump]

B3DB: CE B3 20    LDU    #$B320
B3DE: BD 90 6B    JSR    $906B
B3E1: 6C 15       INC    -$B,X
B3E3: BD A4 27    JSR    $A427
B3E6: BD 90 74    JSR    $9074
B3E9: EC 09       LDD    $9,X
B3EB: C3 04 00    ADDD   #$0400
B3EE: ED 09       STD    $9,X
B3F0: 25 0D       BCS    $B3FF
B3F2: 8D C2       BSR    $B3B6
B3F4: BD 8C A7    JSR    $8CA7
B3F7: 24 05       BCC    $B3FE
B3F9: 1D          SEX
B3FA: E3 19       ADDD   -$7,X
B3FC: ED 19       STD    -$7,X
B3FE: 39          RTS
B3FF: 6C 15       INC    -$B,X
B401: 39          RTS
B402: BD A4 27    JSR    $A427
B405: BD 90 74    JSR    $9074
B408: EC 19       LDD    -$7,X
B40A: C3 FF FE    ADDD   #$FFFE
B40D: ED 19       STD    -$7,X
B40F: BD 8C A7    JSR    $8CA7
B412: 24 09       BCC    $B41D
B414: 1D          SEX
B415: E3 19       ADDD   -$7,X
B417: ED 19       STD    -$7,X
B419: 4F          CLRA
B41A: 5F          CLRB
B41B: ED 14       STD    -$C,X
B41D: 39          RTS
B41E: E6 15       LDB    -$B,X
B420: 58          ASLB
B421: CE B4 26    LDU    #jump_table_b426
B424: 6E D5       JMP    [B,U]        ; [indirect_jump]

B432: E6 11       LDB    -$F,X
B434: 27 20       BEQ    $B456
B436: CE B4 95    LDU    #$B495
B439: EF 88 16    STU    $16,X
B43C: 6F 88 15    CLR    $15,X
B43F: EC 16       LDD    -$A,X
B441: DD EC       STD    $EC
B443: EC 19       LDD    -$7,X
B445: DD EE       STD    $EE
B447: BD 8D D2    JSR    $8DD2
B44A: 31 A8 E0    LEAY   -$20,Y
B44D: 10 AF 88 18 STY    $18,X
B451: BD 79 AB    JSR    $79AB
B454: 6C 15       INC    -$B,X
B456: 39          RTS
B457: 6D 88 15    TST    $15,X
B45A: 26 2A       BNE    $B486
B45C: EE 88 16    LDU    $16,X
B45F: 10 AE 88 18 LDY    $18,X
B463: 86 87       LDA    #$87
B465: C6 87       LDB    #$87
B467: ED A9 04 00 STD    $0400,Y
B46B: EC C1       LDD    ,U++
B46D: ED A4       STD    ,Y
B46F: 86 87       LDA    #$87
B471: C6 87       LDB    #$87
B473: ED A9 04 20 STD    $0420,Y
B477: EC C1       LDD    ,U++
B479: ED A8 20    STD    $20,Y
B47C: E6 C0       LDB    ,U+
B47E: C4 7F       ANDB   #$7F
B480: E7 88 15    STB    $15,X
B483: EF 88 16    STU    $16,X
B486: 6A 88 15    DEC    $15,X
B489: 26 09       BNE    $B494
B48B: EE 88 16    LDU    $16,X
B48E: 6D C2       TST    ,-U
B490: 2A 02       BPL    $B494
B492: 6C 15       INC    -$B,X
B494: 39          RTS


B4BD: 6A 88 12    DEC    $12,X
B4C0: 26 4A       BNE    $B50C
B4C2: 64 10       LSR    -$10,X
B4C4: C6 02       LDB    #$02
B4C6: E7 1F       STB    -$1,X
B4C8: CC B2 B5    LDD    #$B2B5
B4CB: ED 84       STD    ,X
B4CD: ED 03       STD    $3,X
B4CF: 6F 02       CLR    $2,X
B4D1: BD B2 22    JSR    $B222
B4D4: A6 1E       LDA    -$2,X
B4D6: A7 0F       STA    $F,X
B4D8: 6F 1E       CLR    -$2,X
B4DA: DC A0       LDD    $A0
B4DC: 83 00 0A    SUBD   #$000A
B4DF: 10 A3 16    CMPD   -$A,X
B4E2: 22 0C       BHI    $B4F0
B4E4: C3 00 14    ADDD   #$0014
B4E7: 10 A3 16    CMPD   -$A,X
B4EA: 25 04       BCS    $B4F0
B4EC: 86 02       LDA    #$02
B4EE: A7 0F       STA    $F,X
B4F0: C6 01       LDB    #$01
B4F2: E7 88 14    STB    $14,X
B4F5: DC A0       LDD    $A0
B4F7: 83 00 40    SUBD   #$0040
B4FA: 10 A3 16    CMPD   -$A,X
B4FD: 22 0B       BHI    $B50A
B4FF: C3 00 80    ADDD   #$0080
B502: 10 A3 16    CMPD   -$A,X
B505: 25 03       BCS    $B50A
B507: 6F 88 14    CLR    $14,X
B50A: 6C 15       INC    -$B,X
B50C: BD 90 74    JSR    $9074
B50F: 39          RTS
B510: 6F 88 15    CLR    $15,X
B513: CE B4 A9    LDU    #$B4A9
B516: EF 88 16    STU    $16,X
B519: 6C 15       INC    -$B,X
B51B: BD B4 57    JSR    $B457
B51E: 7E B5 21    JMP    $B521
B521: BD 8C A7    JSR    $8CA7
B524: 25 11       BCS    $B537
B526: CE B5 3F    LDU    #jump_table_b53f
B529: E6 0F       LDB    $F,X
B52B: 58          ASLB
B52C: AD D5       JSR    [B,U]        ; [indirect_jump]
B52E: BD A4 27    JSR    $A427
B531: BD 90 74    JSR    $9074
B534: 7E 8F 62    JMP    $8F62
B537: BD B1 70    JSR    $B170
B53A: 4F          CLRA
B53B: 5F          CLRB
B53C: ED 14       STD    -$C,X
B53E: 39          RTS

B545: 6A 88 10    DEC    $10,X
B548: 26 0E       BNE    $B558
B54A: A6 1E       LDA    -$2,X
B54C: 81 05       CMPA   #$05
B54E: 27 02       BEQ    $B552
B550: 6C 1E       INC    -$2,X
B552: A6 88 11    LDA    $11,X
B555: A7 88 10    STA    $10,X
B558: E6 88 14    LDB    $14,X
B55B: 58          ASLB
B55C: CE B5 8B    LDU    #$B58B
B55F: EE C5       LDU    B,U
B561: EF 1C       STU    -$4,X
B563: 39          RTS
B564: 6A 88 10    DEC    $10,X
B567: 26 0E       BNE    $B577
B569: A6 1E       LDA    -$2,X
B56B: 81 05       CMPA   #$05
B56D: 27 02       BEQ    $B571
B56F: 6C 1E       INC    -$2,X
B571: A6 88 11    LDA    $11,X
B574: A7 88 10    STA    $10,X
B577: E6 88 14    LDB    $14,X
B57A: 58          ASLB
B57B: CE B5 8F    LDU    #$B58F
B57E: EE C5       LDU    B,U
B580: EF 1C       STU    -$4,X
B582: 39          RTS
B583: 6F 1E       CLR    -$2,X
B585: CE B5 F3    LDU    #$B5F3
B588: EF 1C       STU    -$4,X
B58A: 39          RTS

B5F7: E6 15       LDB    -$B,X
B5F9: 58          ASLB
B5FA: CE B5 FF    LDU    #jump_table_b5ff
B5FD: 6E D5       JMP    [B,U]        ; [indirect_jump]

B603: 58          ASLB
B604: CE B6 09    LDU    #$B609
B607: 6E D5       JMP    [B,U]        ; [indirect_jump]

B60F: BD 79 B5    JSR    $79B5                                      
B612: CC 01 00    LDD    #$0100                                     
B615: ED 14       STD    -$C,X
B617: 39          RTS
B618: CC 03 00    LDD    #$0300
B61B: ED 13       STD    -$D,X
B61D: E7 15       STB    -$B,X
B61F: 39          RTS
B620: E6 05       LDB    $5,X
B622: CE 00 30    LDU    #$0030
B625: 6C C5       INC    B,U
B627: 4F          CLRA
B628: 5F          CLRB
B629: ED 10       STD    -$10,X
B62B: ED 13       STD    -$D,X
B62D: 7E 8E 0C    JMP    $8E0C
B630: D6 9A       LDB    $9A
B632: C4 30       ANDB   #$30
B634: 54          LSRB
B635: 54          LSRB
B636: CE B6 3E    LDU    #$B63E
B639: 33 C5       LEAU   B,U
B63B: 7E B8 7E    JMP    $B87E
B63E: 00 80       NEG    $80
B640: 01 00       NEG    $00
B642: 00 60       NEG    nb_lives_0060
B644: 00 C0       NEG    $C0
B646: 00 40       NEG    $40
B648: 00 80       NEG    $80
B64A: 00 20       NEG    $20
B64C: 00 40       NEG    $40
B64E: EC 13       LDD    -$D,X
B650: 48          ASLA
B651: CE B6 56    LDU    #jump_table_b656
B654: 6E D6       JMP    [A,U]        ; [indirect_jump]

B65E: 58          ASLB
B65F: CE B6 64    LDU    #$B664
B662: 6E D5       JMP    [B,U]        ; [indirect_jump]
B664: B6 6C B6    LDA    $6CB6
B667: 7D B6 D5    TST    $B6D5
B66A: B7 34 A6    STA    $34A6
B66D: 12          NOP
B66E: 44          LSRA
B66F: 44          LSRA
B670: A7 0D       STA    $D,X
B672: E6 12       LDB    -$E,X
B674: C4 03       ANDB   #$03
B676: 26 02       BNE    $B67A
B678: C6 03       LDB    #$03
B67A: E7 14       STB    -$C,X
B67C: 39          RTS
B67D: E6 15       LDB    -$B,X
B67F: 58          ASLB
B680: CE B6 85    LDU    #jump_table_b685
B683: 6E D5       JMP    [B,U]        ; [indirect_jump]

B68B: C6 03       LDB    #$03
B68D: E7 1F       STB    -$1,X
B68F: C6 01       LDB    #$01
B691: E7 1E       STB    -$2,X
B693: CC 49 F2    LDD    #$49F2
B696: ED 84       STD    ,X
B698: 6F 02       CLR    $2,X
B69A: BD 90 74    JSR    $9074
B69D: CC 00 10    LDD    #$0010
B6A0: ED 88 1E    STD    $1E,X
B6A3: 6C 15       INC    -$B,X
B6A5: EC 19       LDD    -$7,X
B6A7: 93 A2       SUBD   $A2
B6A9: C3 00 30    ADDD   #$0030
B6AC: 10 83 00 60 CMPD   #$0060
B6B0: 22 0D       BHI    $B6BF
B6B2: EC 16       LDD    -$A,X
B6B4: 93 A0       SUBD   $A0
B6B6: C3 00 60    ADDD   #$0060
B6B9: 10 83 00 C0 CMPD   #$00C0
B6BD: 23 06       BLS    $B6C5
B6BF: E6 88 1E    LDB    $1E,X
B6C2: 5C          INCB
B6C3: 26 02       BNE    $B6C7
B6C5: 6C 15       INC    -$B,X
B6C7: 39          RTS
B6C8: 6A 88 1F    DEC    $1F,X
B6CB: 10 26 D9 A5 LBNE   $9074
B6CF: CC 03 00    LDD    #$0300
B6D2: ED 14       STD    -$C,X
B6D4: 39          RTS
B6D5: E6 15       LDB    -$B,X
B6D7: 58          ASLB
B6D8: CE B6 DD    LDU    #jump_table_b6dd
B6DB: 6E D5       JMP    [B,U]        ; [indirect_jump]

B6E7: C6 02       LDB    #$02
B6E9: E7 10       STB    -$10,X
B6EB: CC 00 F0    LDD    #$00F0
B6EE: ED 88 10    STD    $10,X
B6F1: 6C 15       INC    -$B,X
B6F3: D6 21       LDB    $21
B6F5: C5 0F       BITB   #$0F
B6F7: 26 0F       BNE    $B708
B6F9: C5 10       BITB   #$10
B6FB: 26 06       BNE    $B703
B6FD: EC 84       LDD    ,X
B6FF: ED 03       STD    $3,X
B701: 20 05       BRA    $B708
B703: CC A6 31    LDD    #$A631
B706: ED 03       STD    $3,X
B708: EC 88 10    LDD    $10,X
B70B: 83 00 01    SUBD   #$0001
B70E: ED 88 10    STD    $10,X
B711: 26 02       BNE    $B715
B713: 6C 15       INC    -$B,X
B715: 39          RTS
B716: CC 00 F0    LDD    #$00F0
B719: ED 88 10    STD    $10,X
B71C: C6 03       LDB    #$03
B71E: BD 8E BF    JSR    $8EBF
B721: CE 4A D5    LDU    #$4AD5
B724: BD B7 CA    JSR    $B7CA
B727: 6C 15       INC    -$B,X
B729: 39          RTS
B72A: C6 01       LDB    #$01
B72C: E7 10       STB    -$10,X
B72E: CC 03 00    LDD    #$0300
B731: ED 14       STD    -$C,X
B733: 39          RTS
B734: 0C B5       INC    $B5
B736: C6 03       LDB    #$03
B738: E7 88 1E    STB    $1E,X
B73B: C6 03       LDB    #$03
B73D: E7 1F       STB    -$1,X
B73F: 6F 1E       CLR    -$2,X
B741: EC 16       LDD    -$A,X
B743: 10 93 A0    CMPD   $A0
B746: 2D 02       BLT    $B74A
B748: 6C 1E       INC    -$2,X
B74A: D6 21       LDB    $21
B74C: DB E0       ADDB   $E0
B74E: C4 03       ANDB   #$03
B750: 58          ASLB
B751: CE 4A 61    LDU    #$4A61
B754: EE C5       LDU    B,U
B756: EC C1       LDD    ,U++
B758: ED 0A       STD    $A,X
B75A: EF 88 16    STU    $16,X
B75D: D6 9A       LDB    $9A
B75F: 54          LSRB
B760: 54          LSRB
B761: 54          LSRB
B762: C4 06       ANDB   #$06
B764: CE 4A 00    LDU    #$4A00
B767: EE C5       LDU    B,U
B769: A6 C0       LDA    ,U+
B76B: A7 06       STA    $6,X
B76D: EF 88 18    STU    $18,X
B770: CE 4A 34    LDU    #$4A34
B773: EE C5       LDU    B,U
B775: A6 C0       LDA    ,U+
B777: A7 07       STA    $7,X
B779: EF 88 1A    STU    $1A,X
B77C: CE 4A 47    LDU    #$4A47
B77F: EE C5       LDU    B,U
B781: A6 C0       LDA    ,U+
B783: A7 08       STA    $8,X
B785: EF 88 1C    STU    $1C,X
B788: CE B7 A2    LDU    #$B7A2
B78B: D6 9A       LDB    $9A
B78D: 54          LSRB
B78E: 54          LSRB
B78F: 54          LSRB
B790: E6 C5       LDB    B,U
B792: E7 09       STB    $9,X
B794: CE 4A D5    LDU    #$4AD5
B797: BD B7 CA    JSR    $B7CA
B79A: CC 01 00    LDD    #$0100
B79D: ED 13       STD    -$D,X
B79F: E7 15       STB    -$B,X
B7A1: 39          RTS
B7A2: 32 30       LEAS   -$10,Y
B7A4: 28 26       BVC    $B7CC
B7A6: 1E 1C       EXG    X,inv
B7A8: 12          NOP
B7A9: 0A E6       DEC    $E6
B7AB: 12          NOP
B7AC: 10 26 D8 C4 LBNE   $9074
B7B0: E6 0A       LDB    $A,X
B7B2: 2B 15       BMI    $B7C9
B7B4: EE 1C       LDU    -$4,X
B7B6: 58          ASLB
B7B7: 33 C5       LEAU   B,U
B7B9: EC 17       LDD    -$9,X
B7BB: E3 C4       ADDD   ,U
B7BD: ED 17       STD    -$9,X
B7BF: E6 C4       LDB    ,U
B7C1: 1D          SEX
B7C2: A9 16       ADCA   -$A,X
B7C4: A7 16       STA    -$A,X
B7C6: 7E 90 74    JMP    $9074
B7C9: 39          RTS
B7CA: E6 0D       LDB    $D,X
B7CC: 58          ASLB
B7CD: EE C5       LDU    B,U
B7CF: 7E 90 6B    JMP    $906B

B7D6: 58          ASLB
B7D7: CE B7 F4    LDU    #jump_table_b7f4
B7DA: AD D5       JSR    [B,U]        ; [indirect_jump]
B7DC: BD B9 01    JSR    $B901
B7DF: EC 19       LDD    -$7,X
B7E1: 93 9E       SUBD   $9E
B7E3: C3 00 40    ADDD   #$0040
B7E6: 10 83 01 80 CMPD   #$0180
B7EA: 23 07       BLS    $B7F3
B7EC: CC 03 00    LDD    #$0300
B7EF: ED 13       STD    -$D,X
B7F1: E7 15       STB    -$B,X
B7F3: 39          RTS
B7F4: B8 02 B9    EORA   $02B9
B7F7: FC BB 2A    LDD    $BB2A
B7FA: BB A5 BC    ADDA   $A5BC
B7FD: 20 BC       BRA    $B7BB
B7FF: 76 BD 4D    ROR    $BD4D
B802: E6 15       LDB    -$B,X
B804: 58          ASLB
B805: CE B8 1C    LDU    #jump_table_b81c
B808: AD D5       JSR    [B,U]        ; [indirect_jump]
B80A: BD B9 36    JSR    $B936
B80D: BD B9 57    JSR    $B957
B810: BD B9 75    JSR    $B975
B813: BD B9 C7    JSR    $B9C7
B816: BD B8 6F    JSR    $B86F
B819: 7E B9 E7    JMP    $B9E7
B81C: B8 20 B8    EORA   $20B8
B81F: 3D          MUL
B820: CC B7 D2    LDD    #$B7D2
B823: ED 1C       STD    -$4,X
B825: C6 03       LDB    #$03
B827: E7 1F       STB    -$1,X
B829: 6F 1E       CLR    -$2,X
B82B: DC A0       LDD    $A0
B82D: 10 A3 16    CMPD   -$A,X
B830: 22 02       BHI    $B834
B832: 6C 1E       INC    -$2,X
B834: CE 4A D5    LDU    #$4AD5
B837: BD B7 CA    JSR    $B7CA
B83A: 6C 15       INC    -$B,X
B83C: 39          RTS
B83D: 8D 1B       BSR    $B85A
B83F: BD B7 AA    JSR    $B7AA
B842: EC 19       LDD    -$7,X
B844: 83 00 02    SUBD   #$0002
B847: ED 19       STD    -$7,X
B849: BD 8C A7    JSR    $8CA7
B84C: 24 06       BCC    $B854
B84E: 4F          CLRA
B84F: E3 19       ADDD   -$7,X
B851: ED 19       STD    -$7,X
B853: 39          RTS
B854: CC 01 00    LDD    #$0100
B857: ED 14       STD    -$C,X
B859: 39          RTS
B85A: 6A 0B       DEC    $B,X
B85C: 26 10       BNE    $B86E
B85E: EE 88 16    LDU    $16,X
B861: EC C1       LDD    ,U++
B863: 26 04       BNE    $B869
B865: EE C4       LDU    ,U
B867: EC C1       LDD    ,U++
B869: ED 0A       STD    $A,X
B86B: EF 88 16    STU    $16,X
B86E: 39          RTS
B86F: BD B8 F0    JSR    $B8F0
B872: 8D 0A       BSR    $B87E
B874: 24 07       BCC    $B87D
B876: CC 05 00    LDD    #$0500
B879: ED 14       STD    -$C,X
B87B: 6F 0C       CLR    $C,X
B87D: 39          RTS
B87E: EC 16       LDD    -$A,X
B880: 93 A0       SUBD   $A0
B882: 97 E4       STA    $E4
B884: E3 C4       ADDD   ,U
B886: 10 A3 42    CMPD   $2,U
B889: 23 39       BLS    $B8C4
B88B: 10 8E 05 40 LDY    #$0540
B88F: C6 04       LDB    #$04
B891: D7 E1       STB    $E1
B893: E6 31       LDB    -$F,Y
B895: 27 26       BEQ    $B8BD
B897: EC 36       LDD    -$A,Y
B899: 93 A0       SUBD   $A0
B89B: 97 E5       STA    $E5
B89D: C3 00 08    ADDD   #$0008
B8A0: 10 83 00 10 CMPD   #$0010
B8A4: 23 17       BLS    $B8BD
B8A6: EC 19       LDD    -$7,X
B8A8: A3 39       SUBD   -$7,Y
B8AA: C3 00 1C    ADDD   #$001C
B8AD: 10 83 00 2C CMPD   #$002C
B8B1: 24 0A       BCC    $B8BD
B8B3: A7 0F       STA    $F,X
B8B5: 96 E5       LDA    $E5
B8B7: 98 E4       EORA   $E4
B8B9: 84 80       ANDA   #$80
B8BB: 27 09       BEQ    $B8C6
B8BD: 31 A8 40    LEAY   $40,Y
B8C0: 0A E1       DEC    $E1
B8C2: 26 CF       BNE    $B893
B8C4: 4F          CLRA
B8C5: 39          RTS
B8C6: 43          COMA
B8C7: 39          RTS
B8C8: 00 46       NEG    $46
B8CA: 00 8C       NEG    $8C
B8CC: 00 40       NEG    $40
B8CE: 00 80       NEG    $80
B8D0: 00 40       NEG    $40
B8D2: 00 80       NEG    $80
B8D4: 00 38       NEG    $38
B8D6: 00 70       NEG    $70
B8D8: 00 36       NEG    $36
B8DA: 00 6C       NEG    $6C
B8DC: 00 28       NEG    $28
B8DE: 00 50       NEG    $50
B8E0: 00 20       NEG    $20
B8E2: 00 40       NEG    $40
B8E4: 00 18       NEG    $18
B8E6: 00 30       NEG    $30
B8E8: 00 14       NEG    $14
B8EA: 00 28       NEG    $28
B8EC: 00 10       NEG    $10
B8EE: 00 20       NEG    $20
B8F0: CE B8 C8    LDU    #$B8C8
B8F3: D6 9A       LDB    $9A
B8F5: C4 30       ANDB   #$30
B8F7: 54          LSRB
B8F8: 33 C5       LEAU   B,U
B8FA: E6 0D       LDB    $D,X
B8FC: 58          ASLB
B8FD: 58          ASLB
B8FE: 33 C5       LEAU   B,U
B900: 39          RTS
B901: E6 12       LDB    -$E,X
B903: 58          ASLB
B904: CE B9 09    LDU    #jump_table_b909
B907: 6E D5       JMP    [B,U]        ; [indirect_jump]

B90F: CE 4A 8D    LDU    #$4A8D
B912: E6 1F       LDB    -$1,X
B914: C1 03       CMPB   #$03
B916: 27 02       BEQ    $B91A
B918: 33 44       LEAU   $4,U
B91A: E6 0D       LDB    $D,X
B91C: 58          ASLB
B91D: EE C5       LDU    B,U
B91F: E6 1E       LDB    -$2,X
B921: 58          ASLB
B922: EC C5       LDD    B,U
B924: ED 03       STD    $3,X
B926: C6 05       LDB    #$05
B928: E7 02       STB    $2,X
B92A: 6C 12       INC    -$E,X
B92C: 7E 79 C9    JMP    $79C9
B92F: E6 02       LDB    $2,X
B931: 26 02       BNE    $B935
B933: 6F 12       CLR    -$E,X
B935: 39          RTS
B936: E6 06       LDB    $6,X
B938: 26 1A       BNE    $B954
B93A: E6 14       LDB    -$C,X
B93C: E7 0C       STB    $C,X
B93E: CC 02 00    LDD    #$0200
B941: ED 14       STD    -$C,X
B943: EE 88 18    LDU    $18,X
B946: E6 C0       LDB    ,U+
B948: 26 04       BNE    $B94E
B94A: EE C4       LDU    ,U
B94C: E6 C0       LDB    ,U+
B94E: E7 06       STB    $6,X
B950: EF 88 18    STU    $18,X
B953: 39          RTS
B954: 6A 06       DEC    $6,X
B956: 39          RTS
B957: 6A 07       DEC    $7,X
B959: 26 19       BNE    $B974
B95B: E6 14       LDB    -$C,X
B95D: E7 0C       STB    $C,X
B95F: CC 06 00    LDD    #$0600
B962: ED 14       STD    -$C,X
B964: EE 88 1A    LDU    $1A,X
B967: E6 C0       LDB    ,U+
B969: 26 04       BNE    $B96F
B96B: EE C4       LDU    ,U
B96D: E6 C0       LDB    ,U+
B96F: E7 07       STB    $7,X
B971: EF 88 1A    STU    $1A,X
B974: 39          RTS
B975: D6 21       LDB    $21
B977: 5A          DECB
B978: C4 07       ANDB   #$07
B97A: 26 19       BNE    $B995
B97C: 6A 08       DEC    $8,X
B97E: 26 15       BNE    $B995
B980: CC 01 00    LDD    #$0100
B983: ED 14       STD    -$C,X
B985: EE 88 1C    LDU    $1C,X
B988: E6 C0       LDB    ,U+
B98A: 26 04       BNE    $B990
B98C: EE C4       LDU    ,U
B98E: E6 C0       LDB    ,U+
B990: E7 08       STB    $8,X
B992: EF 88 1C    STU    $1C,X
B995: 39          RTS
B996: 00 30       NEG    $30
B998: 00 40       NEG    $40
B99A: 00 28       NEG    $28
B99C: 00 48       NEG    $48
B99E: 00 20       NEG    $20
B9A0: 00 50       NEG    $50
B9A2: 00 18       NEG    $18
B9A4: 00 58       NEG    $58
B9A6: 00 10       NEG    $10
B9A8: 00 60       NEG    nb_lives_0060
B9AA: 00 0C       NEG    $0C
B9AC: 00 64       NEG    $64
B9AE: 00 0C       NEG    $0C
B9B0: 00 64       NEG    $64
B9B2: 00 0C       NEG    $0C
B9B4: 00 64       NEG    $64
B9B6: CE B9 96    LDU    #$B996
B9B9: D6 9A       LDB    $9A
B9BB: C4 30       ANDB   #$30
B9BD: 54          LSRB
B9BE: 33 C5       LEAU   B,U
B9C0: E6 0D       LDB    $D,X
B9C2: 58          ASLB
B9C3: 58          ASLB
B9C4: 33 C5       LEAU   B,U
B9C6: 39          RTS
B9C7: 8D ED       BSR    $B9B6
B9C9: 6F 0E       CLR    $E,X
B9CB: DC A0       LDD    $A0
B9CD: A3 16       SUBD   -$A,X
B9CF: 2A 07       BPL    $B9D8
B9D1: 43          COMA
B9D2: 53          COMB
B9D3: C3 00 01    ADDD   #$0001
B9D6: 6C 0E       INC    $E,X
B9D8: E7 0F       STB    $F,X
B9DA: A3 C4       SUBD   ,U
B9DC: 10 A3 42    CMPD   $2,U
B9DF: 23 05       BLS    $B9E6
B9E1: CC 03 00    LDD    #$0300
B9E4: ED 14       STD    -$C,X
B9E6: 39          RTS
B9E7: E6 0D       LDB    $D,X
B9E9: 26 10       BNE    $B9FB
B9EB: D6 21       LDB    $21
B9ED: 5C          INCB
B9EE: C4 1F       ANDB   #$1F
B9F0: 26 09       BNE    $B9FB
B9F2: 6A 09       DEC    $9,X
B9F4: 26 05       BNE    $B9FB
B9F6: CC 04 00    LDD    #$0400
B9F9: ED 14       STD    -$C,X
B9FB: 39          RTS
B9FC: E6 15       LDB    -$B,X
B9FE: 58          ASLB
B9FF: CE BA 13    LDU    #jump_table_ba13
BA02: AD D5       JSR    [B,U]        ; [indirect_jump]
BA04: E6 15       LDB    -$B,X
BA06: C0 02       SUBB   #$02
BA08: C1 01       CMPB   #$01
BA0A: 22 06       BHI    $BA12
BA0C: BD B9 36    JSR    $B936
BA0F: 7E B9 57    JMP    $B957
BA12: 39          RTS

BA25: 01 C0       NEG    $C0
BA27: FE 40 02    LDU    $4002
BA2A: 00 FE       NEG    $FE
BA2C: 00 40       NEG    $40
BA2E: 48          ASLA
BA2F: 54          LSRB
BA30: 44          LSRA
BA31: 4C          INCA
BA32: 38 50       XANDCC #$50
BA34: 58          ASLB
BA35: 6F 1E       CLR    -$2,X
BA37: EC 16       LDD    -$A,X
BA39: 10 93 A0    CMPD   $A0
BA3C: 23 02       BLS    $BA40
BA3E: 6C 1E       INC    -$2,X
BA40: CE BA 21    LDU    #$BA21
BA43: E6 0D       LDB    $D,X
BA45: 58          ASLB
BA46: EC C5       LDD    B,U
BA48: ED 1C       STD    -$4,X
BA4A: D6 21       LDB    $21
BA4C: DB E0       ADDB   $E0
BA4E: C4 07       ANDB   #$07
BA50: CE BA 2D    LDU    #$BA2D
BA53: E6 C5       LDB    B,U
BA55: E7 88 14    STB    $14,X
BA58: 6F 08       CLR    $8,X
BA5A: EC 19       LDD    -$7,X
BA5C: ED 88 12    STD    $12,X
BA5F: C6 09       LDB    #$09
BA61: E7 1F       STB    -$1,X
BA63: CE 4B 49    LDU    #$4B49
BA66: BD B7 CA    JSR    $B7CA
BA69: E6 1E       LDB    -$2,X
BA6B: E7 0A       STB    $A,X
BA6D: 6C 15       INC    -$B,X
BA6F: BD B7 AA    JSR    $B7AA
BA72: 7E BC D9    JMP    $BCD9
BA75: BD B7 AA    JSR    $B7AA
BA78: E6 0A       LDB    $A,X
BA7A: 27 11       BEQ    $BA8D
BA7C: EC 16       LDD    -$A,X
BA7E: 10 93 A0    CMPD   $A0
BA81: 22 1D       BHI    $BAA0
BA83: 6C 15       INC    -$B,X
BA85: 6F 1E       CLR    -$2,X
BA87: CE 4B 49    LDU    #$4B49
BA8A: 7E B7 CA    JMP    $B7CA
BA8D: EC 16       LDD    -$A,X
BA8F: 10 93 A0    CMPD   $A0
BA92: 23 0C       BLS    $BAA0
BA94: 6C 15       INC    -$B,X
BA96: C6 01       LDB    #$01
BA98: E7 1E       STB    -$2,X
BA9A: CE 4B 49    LDU    #$4B49
BA9D: 7E B7 CA    JMP    $B7CA
BAA0: 39          RTS
BAA1: BD B7 AA    JSR    $B7AA
BAA4: EC 16       LDD    -$A,X
BAA6: 93 A0       SUBD   $A0
BAA8: C3 00 50    ADDD   #$0050
BAAB: 10 83 00 A0 CMPD   #$00A0
BAAF: 23 06       BLS    $BAB7
BAB1: C6 05       LDB    #$05
BAB3: E7 08       STB    $8,X
BAB5: 6C 15       INC    -$B,X
BAB7: 39          RTS
BAB8: 6A 08       DEC    $8,X
BABA: 10 26 D5 B6 LBNE   $9074
BABE: C6 80       LDB    #$80
BAC0: E7 08       STB    $8,X
BAC2: 6C 15       INC    -$B,X
BAC4: 39          RTS
BAC5: 8D 06       BSR    $BACD
BAC7: BD BB 13    JSR    $BB13
BACA: 7E B8 6F    JMP    $B86F
BACD: BD BD 26    JSR    $BD26
BAD0: E6 08       LDB    $8,X
BAD2: CB 08       ADDB   #$08
BAD4: E7 08       STB    $8,X
BAD6: 24 0E       BCC    $BAE6
BAD8: BD 8C A7    JSR    $8CA7
BADB: 24 0A       BCC    $BAE7
BADD: E6 98 1C    LDB    [$1C,X]
BAE0: E7 08       STB    $8,X
BAE2: 4F          CLRA
BAE3: 5F          CLRB
BAE4: ED 14       STD    -$C,X
BAE6: 39          RTS
BAE7: 6C 15       INC    -$B,X
BAE9: 39          RTS
BAEA: 8D 06       BSR    $BAF2
BAEC: BD BB 13    JSR    $BB13
BAEF: 7E B8 6F    JMP    $B86F
BAF2: EC 1A       LDD    -$6,X
BAF4: C3 FC 00    ADDD   #$FC00
BAF7: ED 1A       STD    -$6,X
BAF9: E6 19       LDB    -$7,X
BAFB: C9 FF       ADCB   #$FF
BAFD: E7 19       STB    -$7,X
BAFF: BD 8C A7    JSR    $8CA7
BB02: 24 E2       BCC    $BAE6
BB04: 4F          CLRA
BB05: E3 19       ADDD   -$7,X
BB07: ED 19       STD    -$7,X
BB09: E6 98 1C    LDB    [$1C,X]
BB0C: E7 08       STB    $8,X
BB0E: 4F          CLRA
BB0F: 5F          CLRB
BB10: ED 14       STD    -$C,X
BB12: 39          RTS
BB13: EC 19       LDD    -$7,X
BB15: 93 9E       SUBD   $9E
BB17: 2B 06       BMI    $BB1F
BB19: 10 83 00 30 CMPD   #$0030
BB1D: 22 0A       BHI    $BB29
BB1F: CC 01 00    LDD    #$0100
BB22: ED 14       STD    -$C,X
BB24: EC 88 12    LDD    $12,X
BB27: ED 19       STD    -$7,X
BB29: 39          RTS
BB2A: CE BB 32    LDU    #jump_table_bb32
BB2D: E6 15       LDB    -$B,X
BB2F: 58          ASLB
BB30: 6E D5       JMP    [B,U]        ; [indirect_jump]

BB3A: C6 06       LDB    #$06
BB3C: E7 06       STB    $6,X
BB3E: CE 4B DD    LDU    #$4BDD
BB41: E6 1F       LDB    -$1,X
BB43: C1 03       CMPB   #$03
BB45: 27 02       BEQ    $BB49
BB47: 33 44       LEAU   $4,U
BB49: BD B7 CA    JSR    $B7CA
BB4C: 6C 15       INC    -$B,X
BB4E: 6A 06       DEC    $6,X
BB50: 10 26 D5 20 LBNE   $9074
BB54: 6C 15       INC    -$B,X
BB56: 39          RTS
BB57: D6 A7       LDB    $A7
BB59: 27 21       BEQ    $BB7C
BB5B: BD 8E 2E    JSR    $8E2E
BB5E: C6 07       LDB    #$07
BB60: E7 25       STB    $5,Y
BB62: EC 16       LDD    -$A,X
BB64: ED 36       STD    -$A,Y
BB66: EC 19       LDD    -$7,X
BB68: ED 39       STD    -$7,Y
BB6A: 4F          CLRA
BB6B: 5F          CLRB
BB6C: ED 33       STD    -$D,Y
BB6E: E7 35       STB    -$B,Y
BB70: 4C          INCA
BB71: ED 30       STD    -$10,Y
BB73: C6 06       LDB    #$06
BB75: E7 06       STB    $6,X
BB77: BD 79 F6    JSR    $79F6
BB7A: 6C 15       INC    -$B,X
BB7C: 39          RTS
BB7D: 6A 06       DEC    $6,X
BB7F: 10 26 D4 F1 LBNE   $9074
BB83: E6 98 18    LDB    [$18,X]
BB86: E7 06       STB    $6,X
BB88: A6 0C       LDA    $C,X
BB8A: 48          ASLA
BB8B: CE BB 93    LDU    #$BB93
BB8E: EC C6       LDD    A,U
BB90: ED 14       STD    -$C,X
BB92: 39          RTS

BBA5: E6 15       LDB    -$B,X
BBA7: 58          ASLB
BBA8: CE BB B3    LDU    #jump_table_bbb3
BBAB: AD D5       JSR    [B,U]	; [indirect_jump]

BBB7: 6F 0F       CLR    $F,X
BBB9: DC A0       LDD    $A0
BBBB: A3 16       SUBD   -$A,X
BBBD: C3 00 50    ADDD   #$0050
BBC0: 10 83 00 A0 CMPD   #$00A0
BBC4: 25 02       BCS    $BBC8
BBC6: 6C 0F       INC    $F,X
BBC8: A6 0F       LDA    $F,X
BBCA: E6 0E       LDB    $E,X
BBCC: 26 02       BNE    $BBD0
BBCE: 88 01       EORA   #$01
BBD0: A7 0A       STA    $A,X
BBD2: D6 21       LDB    $21
BBD4: DB E0       ADDB   $E0
BBD6: C4 07       ANDB   #$07
BBD8: CE BB EC    LDU    #$BBEC
BBDB: E6 C5       LDB    B,U
BBDD: E7 0F       STB    $F,X
BBDF: CE BC 02    LDU    #$BC02
BBE2: E6 0D       LDB    $D,X
BBE4: 58          ASLB
BBE5: EC C5       LDD    B,U
BBE7: ED 1C       STD    -$4,X
BBE9: 6C 15       INC    -$B,X
BBEB: 39          RTS

BBF4: BD B7 AA    JSR    $B7AA
BBF7: 6A 0F       DEC    $F,X
BBF9: 26 06       BNE    $BC01
BBFB: 8D 11       BSR    $BC0E
BBFD: 4F          CLRA
BBFE: 5F          CLRB
BBFF: ED 14       STD    -$C,X
BC01: 39          RTS
BC02: BC 06 BC    CMPX   $06BC
BC05: 0A 02       DEC    $02
BC07: 20 FD       BRA    $BC06
BC09: E0 02       SUBB   $2,X
BC0B: 40          NEGA
BC0C: FD C0 6F    STD    $C06F
BC0F: 1E DC       EXG    inv,inv
BC11: A0 10       SUBA   -$10,X
BC13: A3 16       SUBD   -$A,X
BC15: 22 02       BHI    $BC19
BC17: 6C 1E       INC    -$2,X
BC19: CE 4A D5    LDU    #$4AD5
BC1C: 7E B7 CA    JMP    $B7CA
BC1F: 39          RTS
BC20: E6 15       LDB    -$B,X
BC22: 58          ASLB
BC23: CE BC 28    LDU    #jump_table_bc28
BC26: 6E D5       JMP    [B,U]	; [indirect_jump]
BC28: BC 2E BC    CMPX   $2EBC
BC2B: 36 BC       PSHU   PC,Y,X,DP,B
BC2D: 58          ASLB
BC2E: 68 10       ASL    -$10,X
BC30: C6 0A       LDB    #$0A
BC32: E7 09       STB    $9,X
BC34: 6C 15       INC    -$B,X
BC36: D6 21       LDB    $21
BC38: C5 03       BITB   #$03
BC3A: 26 1B       BNE    $BC57
BC3C: EE 84       LDU    ,X
BC3E: C5 04       BITB   #$04
BC40: 26 03       BNE    $BC45
BC42: CE A6 31    LDU    #$A631
BC45: EF 03       STU    $3,X
BC47: 6A 09       DEC    $9,X
BC49: 26 0C       BNE    $BC57
BC4B: CE 4A DD    LDU    #$4ADD
BC4E: BD 90 6B    JSR    $906B
BC51: C6 0A       LDB    #$0A
BC53: E7 09       STB    $9,X
BC55: 6C 15       INC    -$B,X
BC57: 39          RTS
BC58: D6 21       LDB    $21
BC5A: C5 03       BITB   #$03
BC5C: 26 17       BNE    $BC75
BC5E: EE 84       LDU    ,X
BC60: C5 04       BITB   #$04
BC62: 26 03       BNE    $BC67
BC64: CE A6 31    LDU    #$A631
BC67: EF 03       STU    $3,X
BC69: 6A 09       DEC    $9,X
BC6B: 26 08       BNE    $BC75
BC6D: 4F          CLRA
BC6E: 5F          CLRB
BC6F: ED 14       STD    -$C,X
BC71: 6C 0D       INC    $D,X
BC73: 64 10       LSR    -$10,X
BC75: 39          RTS
BC76: E6 15       LDB    -$B,X
BC78: 58          ASLB
BC79: CE BC 8D    LDU    #jump_table_bc8d
BC7C: AD D5       JSR    [B,U]        ; [indirect_jump]
BC7E: E6 15       LDB    -$B,X
BC80: C0 02       SUBB   #$02
BC82: C1 01       CMPB   #$01
BC84: 22 06       BHI    $BC8C
BC86: BD B9 36    JSR    $B936
BC89: 7E B9 57    JMP    $B957
BC8C: 39          RTS

BC99: E6 0C       LDB    $C,X
BC9B: C1 05       CMPB   #$05
BC9D: 26 0B       BNE    $BCAA
BC9F: E6 0F       LDB    $F,X
BCA1: C1 10       CMPB   #$10
BCA3: 24 05       BCC    $BCAA
BCA5: C6 04       LDB    #$04
BCA7: E7 15       STB    -$B,X
BCA9: 39          RTS
BCAA: CE BD 41    LDU    #$BD41
BCAD: E6 0D       LDB    $D,X
BCAF: 58          ASLB
BCB0: EC C5       LDD    B,U
BCB2: ED 1C       STD    -$4,X
BCB4: D6 21       LDB    $21
BCB6: DB E0       ADDB   $E0
BCB8: C4 07       ANDB   #$07
BCBA: CE BA 2D    LDU    #$BA2D
BCBD: E6 C5       LDB    B,U
BCBF: E7 88 14    STB    $14,X
BCC2: 6F 08       CLR    $8,X
BCC4: EC 19       LDD    -$7,X
BCC6: ED 88 12    STD    $12,X
BCC9: C6 09       LDB    #$09
BCCB: E7 1F       STB    -$1,X
BCCD: CE 4B 49    LDU    #$4B49
BCD0: BD B7 CA    JSR    $B7CA
BCD3: E6 1E       LDB    -$2,X
BCD5: E7 0A       STB    $A,X
BCD7: 6C 15       INC    -$B,X
BCD9: BD 90 74    JSR    $9074
BCDC: BD BD 26    JSR    $BD26
BCDF: E6 08       LDB    $8,X
BCE1: CB 08       ADDB   #$08
BCE3: E7 08       STB    $8,X
BCE5: C1 A0       CMPB   #$A0
BCE7: 23 06       BLS    $BCEF
BCE9: C6 80       LDB    #$80
BCEB: E7 08       STB    $8,X
BCED: 6C 15       INC    -$B,X
BCEF: 39          RTS
BCF0: BD B8 7E    JSR    $B87E
BCF3: 25 2A       BCS    $BD1F
BCF5: D6 21       LDB    $21
BCF7: C5 07       BITB   #$07
BCF9: 10 26 D3 77 LBNE   $9074
BCFD: 6C 15       INC    -$B,X
BCFF: 39          RTS
BD00: C6 09       LDB    #$09
BD02: E7 1F       STB    -$1,X
BD04: BD B8 7E    JSR    $B87E
BD07: 25 16       BCS    $BD1F
BD09: BD B7 AA    JSR    $B7AA
BD0C: BD B8 5A    JSR    $B85A
BD0F: E6 0A       LDB    $A,X
BD11: 2A 03       BPL    $BD16
BD13: BD 90 74    JSR    $9074
BD16: D6 21       LDB    $21
BD18: C4 3F       ANDB   #$3F
BD1A: 26 02       BNE    $BD1E
BD1C: 6C 15       INC    -$B,X
BD1E: 39          RTS
BD1F: C6 05       LDB    #$05
BD21: E7 0C       STB    $C,X
BD23: 6F 15       CLR    -$B,X
BD25: 39          RTS
BD26: C6 04       LDB    #$04
BD28: F7 3E 00    STB    bankswitch_3e00
BD2B: E6 08       LDB    $8,X
BD2D: CE 41 40    LDU    #$4140
BD30: 4F          CLRA
BD31: E6 CB       LDB    D,U
BD33: 58          ASLB
BD34: A6 88 14    LDA    $14,X
BD37: 3D          MUL
BD38: 1F 89       TFR    A,B
BD3A: 4F          CLRA
BD3B: E3 88 12    ADDD   $12,X
BD3E: ED 19       STD    -$7,X
BD40: 39          RTS

BD4D: E6 15       LDB    -$B,X
BD4F: 58          ASLB
BD50: CE BD 55    LDU    #jump_table_bd55
BD53: 6E D5       JMP    [B,U]        ; [indirect_jump]


BD61: E6 1E       LDB    -$2,X
BD63: E7 0A       STB    $A,X
BD65: EC 19       LDD    -$7,X
BD67: 93 A2       SUBD   $A2
BD69: 2B 09       BMI    $BD74
BD6B: C3 00 10    ADDD   #$0010
BD6E: 10 83 00 20 CMPD   #$0020
BD72: 22 0D       BHI    $BD81
BD74: CE BE 8A    LDU    #$BE8A
BD77: E6 0D       LDB    $D,X
BD79: 58          ASLB
BD7A: EC C5       LDD    B,U
BD7C: ED 1C       STD    -$4,X
BD7E: 6C 15       INC    -$B,X
BD80: 39          RTS
BD81: C6 03       LDB    #$03
BD83: E7 15       STB    -$B,X
BD85: 39          RTS
BD86: BD B7 AA    JSR    $B7AA
BD89: DC A0       LDD    $A0
BD8B: A3 16       SUBD   -$A,X
BD8D: C3 00 10    ADDD   #$0010
BD90: 10 83 00 20 CMPD   #$0020
BD94: 24 02       BCC    $BD98
BD96: 6C 15       INC    -$B,X
BD98: 39          RTS
BD99: BD B7 AA    JSR    $B7AA
BD9C: DC A0       LDD    $A0
BD9E: A3 16       SUBD   -$A,X
BDA0: C3 00 40    ADDD   #$0040
BDA3: 10 83 00 80 CMPD   #$0080
BDA7: 23 0A       BLS    $BDB3
BDA9: E6 1E       LDB    -$2,X
BDAB: C8 01       EORB   #$01
BDAD: E7 1E       STB    -$2,X
BDAF: 4F          CLRA
BDB0: 5F          CLRB
BDB1: ED 14       STD    -$C,X
BDB3: 39          RTS
BDB4: C6 01       LDB    #$01
BDB6: E7 1E       STB    -$2,X
BDB8: EC 16       LDD    -$A,X
BDBA: 93 A0       SUBD   $A0
BDBC: 2A 07       BPL    $BDC5
BDBE: 6F 1E       CLR    -$2,X
BDC0: 43          COMA
BDC1: 53          COMB
BDC2: C3 00 01    ADDD   #$0001
BDC5: 10 83 00 80 CMPD   #$0080
BDC9: 10 24 00 B3 LBCC   $BE80
BDCD: E7 88 15    STB    $15,X
BDD0: EC 19       LDD    -$7,X
BDD2: 93 A2       SUBD   $A2
BDD4: 2A 05       BPL    $BDDB
BDD6: 43          COMA
BDD7: 53          COMB
BDD8: C3 00 01    ADDD   #$0001
BDDB: E7 88 14    STB    $14,X
BDDE: DC A0       LDD    $A0
BDE0: ED 88 10    STD    $10,X
BDE3: DC A2       LDD    $A2
BDE5: ED 88 12    STD    $12,X
BDE8: 6F 08       CLR    $8,X
BDEA: 6C 15       INC    -$B,X
BDEC: 39          RTS
BDED: BD 90 74    JSR    $9074
BDF0: E6 08       LDB    $8,X
BDF2: CE 41 C0    LDU    #$41C0
BDF5: 4F          CLRA
BDF6: E6 CB       LDB    D,U
BDF8: 58          ASLB
BDF9: D7 E1       STB    $E1
BDFB: A6 88 14    LDA    $14,X
BDFE: 3D          MUL
BDFF: 1F 89       TFR    A,B
BE01: 4F          CLRA
BE02: E3 88 12    ADDD   $12,X
BE05: ED 19       STD    -$7,X
BE07: D6 E1       LDB    $E1
BE09: A6 88 15    LDA    $15,X
BE0C: 3D          MUL
BE0D: 1F 89       TFR    A,B
BE0F: 4F          CLRA
BE10: 6D 1E       TST    -$2,X
BE12: 26 05       BNE    $BE19
BE14: 43          COMA
BE15: 53          COMB
BE16: C3 00 01    ADDD   #$0001
BE19: E3 88 10    ADDD   $10,X
BE1C: ED 16       STD    -$A,X
BE1E: C6 03       LDB    #$03
BE20: EB 08       ADDB   $8,X
BE22: E7 08       STB    $8,X
BE24: 2A 20       BPL    $BE46
BE26: C0 03       SUBB   #$03
BE28: E7 08       STB    $8,X
BE2A: E6 1E       LDB    -$2,X
BE2C: E7 0A       STB    $A,X
BE2E: C8 01       EORB   #$01
BE30: E7 1E       STB    -$2,X
BE32: C6 09       LDB    #$09
BE34: E7 1F       STB    -$1,X
BE36: CE 4B 49    LDU    #$4B49
BE39: BD B7 CA    JSR    $B7CA
BE3C: C6 80       LDB    #$80
BE3E: E0 88 15    SUBB   $15,X
BE41: E7 88 15    STB    $15,X
BE44: 6C 15       INC    -$B,X
BE46: 39          RTS
BE47: BD 90 74    JSR    $9074
BE4A: E6 08       LDB    $8,X
BE4C: CE 41 C0    LDU    #$41C0
BE4F: 4F          CLRA
BE50: E6 CB       LDB    D,U
BE52: 58          ASLB
BE53: D7 E1       STB    $E1
BE55: A6 88 14    LDA    $14,X
BE58: 3D          MUL
BE59: 1F 89       TFR    A,B
BE5B: 4F          CLRA
BE5C: E3 88 12    ADDD   $12,X
BE5F: ED 19       STD    -$7,X
BE61: D6 E1       LDB    $E1
BE63: A6 88 15    LDA    $15,X
BE66: 3D          MUL
BE67: 1F 89       TFR    A,B
BE69: 4F          CLRA
BE6A: 6D 0A       TST    $A,X
BE6C: 27 05       BEQ    $BE73
BE6E: 43          COMA
BE6F: 53          COMB
BE70: C3 00 01    ADDD   #$0001
BE73: E3 88 10    ADDD   $10,X
BE76: ED 16       STD    -$A,X
BE78: E6 08       LDB    $8,X
BE7A: C0 03       SUBB   #$03
BE7C: E7 08       STB    $8,X
BE7E: 2A 09       BPL    $BE89
BE80: CC 05 03    LDD    #$0503
BE83: ED 14       STD    -$C,X
BE85: C6 80       LDB    #$80
BE87: E7 08       STB    $8,X
BE89: 39          RTS
BE8A: BE 8E BE    LDX    $8EBE
BE8D: 92 02       SBCA   $02
BE8F: 20 FD       BRA    $BE8E

BE96: 58          ASLB
BE97: CE BE 9C    LDU    #jump_table_be9c
BE9A: 6E D5       JMP    [B,U]        ; [indirect_jump]

BEA2: BD 79 CE    JSR    $79CE
BEA5: C6 3F       LDB    #$3F
BEA7: E7 0A       STB    $A,X
BEA9: CC 01 00    LDD    #$0100
BEAC: ED 14       STD    -$C,X
BEAE: 39          RTS
BEAF: C6 02       LDB    #$02
BEB1: E7 1F       STB    -$1,X
BEB3: CC E9 30    LDD    #$E930
BEB6: ED 03       STD    $3,X
BEB8: 6A 0A       DEC    $A,X
BEBA: 26 07       BNE    $BEC3
BEBC: CC 03 00    LDD    #$0300
BEBF: ED 13       STD    -$D,X
BEC1: E7 15       STB    -$B,X
BEC3: 39          RTS
BEC4: D6 B5       LDB    $B5
BEC6: 27 02       BEQ    $BECA
BEC8: 0A B5       DEC    $B5
BECA: 0C 35       INC    $35
BECC: 4F          CLRA
BECD: 5F          CLRB
BECE: ED 10       STD    -$10,X
BED0: ED 13       STD    -$D,X
BED2: 7E 8E 0C    JMP    $8E0C
BED5: EC 13       LDD    -$D,X
BED7: 48          ASLA
BED8: CE BE DD    LDU    #jump_table_bedd
BEDB: 6E D6       JMP    [A,U]        ; [indirect_jump]

BEE5: EC 14       LDD    -$C,X
BEE7: 48          ASLA
BEE8: CE BE ED    LDU    #$BEED
BEEB: 6E D6       JMP    [A,U]        ; [indirect_jump]
BEED: BE F1 BF    LDX    $F1BF
BEF0: 1E C6       EXG    inv,inv
BEF2: 0A E7       DEC    $E7
BEF4: 88 14       EORA   #$14
BEF6: C6 04       LDB    #$04
BEF8: E7 1F       STB    -$1,X
BEFA: 6F 1E       CLR    -$2,X
BEFC: EC 16       LDD    -$A,X
BEFE: 10 93 A0    CMPD   $A0
BF01: 2D 04       BLT    $BF07
BF03: C6 01       LDB    #$01
BF05: E7 1E       STB    -$2,X
BF07: CE 4C EB    LDU    #$4CEB
BF0A: BD 90 6B    JSR    $906B
BF0D: 6F 88 1F    CLR    $1F,X
BF10: 6F 0E       CLR    $E,X
BF12: D6 9A       LDB    $9A
BF14: 54          LSRB
BF15: 54          LSRB
BF16: 54          LSRB
BF17: 54          LSRB
BF18: E7 88 1C    STB    $1C,X
BF1B: 6C 14       INC    -$C,X
BF1D: 39          RTS
BF1E: C6 81       LDB    #$81
BF20: E7 10       STB    -$10,X
BF22: EC 16       LDD    -$A,X
BF24: 93 9C       SUBD   $9C
BF26: 10 83 01 00 CMPD   #$0100
BF2A: 22 15       BHI    $BF41
BF2C: EC 19       LDD    -$7,X
BF2E: 93 9E       SUBD   $9E
BF30: 10 83 00 F0 CMPD   #$00F0
BF34: 22 0B       BHI    $BF41
BF36: CC 01 00    LDD    #$0100
BF39: ED 13       STD    -$D,X
BF3B: E7 15       STB    -$B,X
BF3D: C6 01       LDB    #$01
BF3F: E7 10       STB    -$10,X
BF41: 39          RTS
BF42: 58          ASLB
BF43: CE BF 48    LDU    #jump_table_bf48
BF46: 6E D5       JMP    [B,U]	; [indirect_jump]
BF4C: E6 15       LDB    -$B,X                                      
BF4E: 58          ASLB
BF4F: CE BF 57    LDU    #$BF57
BF52: AD D5       JSR    [B,U]	; [indirect_jump]
BF54: 7E 8F 62    JMP    $8F62
BF5F: 0C B5       INC    $B5                                         
BF61: 6C 15       INC    -$B,X                                       
BF63: 39          RTS
BF64: E6 88 1C    LDB    $1C,X
BF67: CE BF 91    LDU    #$BF91
BF6A: E6 C5       LDB    B,U
BF6C: E7 88 13    STB    $13,X
BF6F: 6F 88 10    CLR    $10,X
BF72: 86 1E       LDA    #$1E
BF74: A7 88 1B    STA    $1B,X
BF77: BD C0 63    JSR    $C063
BF7A: E7 88 1A    STB    $1A,X
BF7D: 6F 88 1D    CLR    $1D,X
BF80: 6F 0F       CLR    $F,X
BF82: 4F          CLRA
BF83: DE A0       LDU    $A0
BF85: 11 A3 16    CMPU   -$A,X
BF88: 25 02       BCS    $BF8C
BF8A: 86 01       LDA    #$01
BF8C: A7 1E       STA    -$2,X
BF8E: 6C 15       INC    -$B,X
BF90: 39          RTS

BF9B: 6C 15       INC    -$B,X
BF9D: BD 90 74    JSR    $9074
BFA0: BD C2 85    JSR    $C285
BFA3: 6D 88 1F    TST    $1F,X
BFA6: 26 21       BNE    $BFC9
BFA8: BD C3 10    JSR    $C310
BFAB: 6D 0E       TST    $E,X
BFAD: 26 15       BNE    $BFC4
BFAF: BD BF EC    JSR    $BFEC
BFB2: BD C0 01    JSR    $C001
BFB5: 6A 88 13    DEC    $13,X
BFB8: 26 10       BNE    $BFCA
BFBA: CC 01 00    LDD    #$0100
BFBD: ED 14       STD    -$C,X
BFBF: C6 01       LDB    #$01
BFC1: E7 10       STB    -$10,X
BFC3: 39          RTS
BFC4: 6A 88 13    DEC    $13,X
BFC7: 27 F1       BEQ    $BFBA
BFC9: 39          RTS
BFCA: 96 21       LDA    $21
BFCC: 84 7F       ANDA   #$7F
BFCE: 81 7F       CMPA   #$7F
BFD0: 26 07       BNE    $BFD9
BFD2: BD 68 F9    JSR    $68F9
BFD5: C4 03       ANDB   #$03
BFD7: E7 0F       STB    $F,X
BFD9: E6 0F       LDB    $F,X
BFDB: CE BF E4    LDU    #$BFE4
BFDE: BD C2 F1    JSR    $C2F1
BFE1: 7E C2 6E    JMP    $C26E
BFE4: 00 70       NEG    $70
BFE6: FF 90 00    STU    $9000
BFE9: 70 FF 90    NEG    $FF90
BFEC: 4F          CLRA
BFED: EE 16       LDU    -$A,X
BFEF: 11 93 A0    CMPU   $A0
BFF2: 25 02       BCS    $BFF6
BFF4: 86 01       LDA    #$01
BFF6: A1 1E       CMPA   -$2,X
BFF8: 27 06       BEQ    $C000
BFFA: A7 1E       STA    -$2,X
BFFC: 86 02       LDA    #$02
BFFE: A7 15       STA    -$B,X
C000: 39          RTS
C001: A6 88 10    LDA    $10,X
C004: 26 1E       BNE    $C024
C006: 6D 11       TST    -$F,X
C008: 27 11       BEQ    $C01B
C00A: 6A 88 12    DEC    $12,X
C00D: 26 0C       BNE    $C01B
C00F: BD C2 4C    JSR    $C24C
C012: CE C0 72    LDU    #$C072
C015: BD C0 66    JSR    $C066
C018: E7 88 12    STB    $12,X
C01B: 6A 88 1A    DEC    $1A,X
C01E: 26 42       BNE    $C062
C020: 6C 88 10    INC    $10,X
C023: 39          RTS
C024: A6 88 10    LDA    $10,X
C027: 81 01       CMPA   #$01
C029: 26 17       BNE    $C042
C02B: CE 4C EB    LDU    #$4CEB
C02E: BD 90 6B    JSR    $906B
C031: C6 81       LDB    #$81
C033: E7 10       STB    -$10,X
C035: 6A 88 1B    DEC    $1B,X
C038: 26 28       BNE    $C062
C03A: 6C 88 10    INC    $10,X
C03D: C6 01       LDB    #$01
C03F: E7 10       STB    -$10,X
C041: 39          RTS
C042: A6 88 10    LDA    $10,X
C045: 81 02       CMPA   #$02
C047: 26 19       BNE    $C062
C049: CE 4C 6D    LDU    #$4C6D
C04C: BD 90 6B    JSR    $906B
C04F: 6F 88 10    CLR    $10,X
C052: 86 1E       LDA    #$1E
C054: A7 88 1B    STA    $1B,X
C057: BD C0 63    JSR    $C063
C05A: E7 88 1A    STB    $1A,X
C05D: 86 05       LDA    #$05
C05F: A7 88 12    STA    $12,X
C062: 39          RTS
C063: CE C0 6E    LDU    #$C06E
C066: BD 68 F9    JSR    $68F9
C069: C4 03       ANDB   #$03
C06B: E6 C5       LDB    B,U
C06D: 39          RTS
C06E: 2F 3C       BLE    $C0AC
C070: 5A          DECB
C071: 2F 32       BLE    $C0A5
C073: 2D 28       BLT    $C09D
C075: 2F 86       BLE    $BFFD
C077: 01 E6       NEG    $E6
C079: 1E C1       EXG    inv,X
C07B: 05 25       LSR    $25
C07D: 05 C1       LSR    $C1
C07F: 0C 22       INC    $22
C081: 01 4F       NEG    $4F
C083: 48          ASLA
C084: CE 4C CD    LDU    #$4CCD
C087: EC C6       LDD    A,U
C089: ED 84       STD    ,X
C08B: ED 03       STD    $3,X
C08D: E7 02       STB    $2,X
C08F: 39          RTS
C090: E6 1E       LDB    -$2,X
C092: 58          ASLB
C093: 33 C5       LEAU   B,U
C095: EC 17       LDD    -$9,X
C097: E3 C4       ADDD   ,U
C099: ED 17       STD    -$9,X
C09B: E6 C4       LDB    ,U
C09D: 1D          SEX
C09E: A9 16       ADCA   -$A,X
C0A0: A7 16       STA    -$A,X
C0A2: 39          RTS
C0A3: 58          ASLB
C0A4: 33 C5       LEAU   B,U
C0A6: EC 1A       LDD    -$6,X
C0A8: E3 C4       ADDD   ,U
C0AA: ED 1A       STD    -$6,X
C0AC: E6 C4       LDB    ,U
C0AE: 1D          SEX
C0AF: A9 19       ADCA   -$7,X
C0B1: A7 19       STA    -$7,X
C0B3: 39          RTS
C0B4: 39          RTS
C0B5: BD C2 85    JSR    $C285
C0B8: 6D 88 1F    TST    $1F,X
C0BB: 26 F7       BNE    $C0B4
C0BD: 6D 14       TST    -$C,X
C0BF: 27 F3       BEQ    $C0B4
C0C1: E6 15       LDB    -$B,X
C0C3: 58          ASLB
C0C4: CE C0 CC    LDU    #jump_table_c0cc
C0C7: AD D5       JSR    [B,U]  ; [indirect_jump]
C0C9: 7E 8F 62    JMP    $8F62

C0D4: CC 00 01    LDD    #$0001
C0D7: ED 14       STD    -$C,X
C0D9: 39          RTS
C0DA: DC A0       LDD    $A0
C0DC: ED 0C       STD    $C,X
C0DE: BD 8F E4    JSR    $8FE4
C0E1: C4 07       ANDB   #$07
C0E3: 27 10       BEQ    $C0F5
C0E5: EC 19       LDD    -$7,X
C0E7: 93 A2       SUBD   $A2
C0E9: 2A 0F       BPL    $C0FA
C0EB: BD 8F E4    JSR    $8FE4
C0EE: E7 1E       STB    -$2,X
C0F0: 86 03       LDA    #$03
C0F2: A7 15       STA    -$B,X
C0F4: 39          RTS
C0F5: 86 01       LDA    #$01
C0F7: A7 88 1D    STA    $1D,X
C0FA: EC 16       LDD    -$A,X
C0FC: 93 A0       SUBD   $A0
C0FE: 2A 05       BPL    $C105
C100: 43          COMA
C101: 53          COMB
C102: C3 00 01    ADDD   #$0001
C105: CE 02 00    LDU    #$0200
C108: A7 41       STA    $1,U
C10A: E7 C4       STB    ,U
C10C: E6 88 1C    LDB    $1C,X
C10F: 58          ASLB
C110: 10 8E 4D 09 LDY    #$4D09
C114: 10 AE A5    LDY    B,Y
C117: 10 AF 88 18 STY    $18,X
C11B: EC 22       LDD    $2,Y
C11D: BD FE F0    JSR    $FEF0
C120: 10 AE C4    LDY    ,U
C123: 86 7F       LDA    #$7F
C125: 5F          CLRB
C126: ED C4       STD    ,U
C128: 1F 20       TFR    Y,D
C12A: BD FE F0    JSR    $FEF0
C12D: A6 C4       LDA    ,U
C12F: A7 88 15    STA    $15,X
C132: C6 00       LDB    #$00
C134: E7 1E       STB    -$2,X
C136: EC 16       LDD    -$A,X
C138: 10 93 A0    CMPD   $A0
C13B: 24 04       BCC    $C141
C13D: C6 01       LDB    #$01
C13F: E7 1E       STB    -$2,X
C141: CE 4C CD    LDU    #$4CCD
C144: BD 90 6B    JSR    $906B
C147: BD 68 F9    JSR    $68F9
C14A: C4 03       ANDB   #$03
C14C: 58          ASLB
C14D: CE C1 8B    LDU    #$C18B
C150: B6 05 1F    LDA    $051F
C153: 27 03       BEQ    $C158
C155: CE C1 93    LDU    #$C193
C158: 33 C5       LEAU   B,U
C15A: DC A2       LDD    $A2
C15C: E3 C4       ADDD   ,U
C15E: A3 19       SUBD   -$7,X
C160: 2A 05       BPL    $C167
C162: 43          COMA
C163: 53          COMB
C164: C3 00 01    ADDD   #$0001
C167: E7 06       STB    $6,X
C169: EC 19       LDD    -$7,X
C16B: ED 07       STD    $7,X
C16D: 6F 09       CLR    $9,X
C16F: A6 88 1D    LDA    $1D,X
C172: 27 14       BEQ    $C188
C174: EC 07       LDD    $7,X
C176: C3 00 60    ADDD   #$0060
C179: ED 07       STD    $7,X
C17B: 86 80       LDA    #$80
C17D: A7 09       STA    $9,X
C17F: 86 60       LDA    #$60
C181: A7 06       STA    $6,X
C183: 86 02       LDA    #$02
C185: A7 15       STA    -$B,X
C187: 39          RTS
C188: 6C 15       INC    -$B,X
C18A: 39          RTS

C1DB: E6 88 1C    LDB    $1C,X
C1DE: 58          ASLB
C1DF: EE 88 18    LDU    $18,X
C1E2: A6 88 1D    LDA    $1D,X
C1E5: 26 0B       BNE    $C1F2
C1E7: A6 09       LDA    $9,X
C1E9: 81 7F       CMPA   #$7F
C1EB: 25 05       BCS    $C1F2
C1ED: CE 4D 11    LDU    #$4D11
C1F0: EE C5       LDU    B,U
C1F2: BD C0 90    JSR    $C090
C1F5: BD 90 74    JSR    $9074
C1F8: C6 04       LDB    #$04
C1FA: F7 3E 00    STB    bankswitch_3e00
C1FD: E6 09       LDB    $9,X
C1FF: CE 41 40    LDU    #$4140
C202: 4F          CLRA
C203: E6 CB       LDB    D,U
C205: 58          ASLB
C206: A6 06       LDA    $6,X
C208: 3D          MUL
C209: 1F 89       TFR    A,B
C20B: 4F          CLRA
C20C: ED 0A       STD    $A,X
C20E: EC 07       LDD    $7,X
C210: A3 0A       SUBD   $A,X
C212: ED 19       STD    -$7,X
C214: BD C2 6E    JSR    $C26E
C217: A6 09       LDA    $9,X
C219: AB 88 15    ADDA   $15,X
C21C: 24 06       BCC    $C224
C21E: CC 00 01    LDD    #$0001
C221: ED 14       STD    -$C,X
C223: 39          RTS
C224: A7 09       STA    $9,X
C226: 39          RTS
C227: EE 88 18    LDU    $18,X
C22A: BD C0 90    JSR    $C090
C22D: BD 90 74    JSR    $9074
C230: EC 16       LDD    -$A,X
C232: A3 0C       SUBD   $C,X
C234: C3 00 10    ADDD   #$0010
C237: 10 83 00 20 CMPD   #$0020
C23B: 24 04       BCC    $C241
C23D: 86 01       LDA    #$01
C23F: A7 15       STA    -$B,X
C241: 39          RTS
C242: CE C1 9B    LDU    #$C19B
C245: BD A4 29    JSR    $A429
C248: BD C0 76    JSR    $C076
C24B: 39          RTS
C24C: D6 A7       LDB    $A7
C24E: 27 1D       BEQ    $C26D
C250: BD 8E 2E    JSR    $8E2E
C253: BD 8F E4    JSR    $8FE4
C256: E7 3E       STB    -$2,Y
C258: EC 16       LDD    -$A,X
C25A: ED 36       STD    -$A,Y
C25C: EC 19       LDD    -$7,X
C25E: ED 39       STD    -$7,Y
C260: 4F          CLRA
C261: 5F          CLRB
C262: ED 33       STD    -$D,Y
C264: E7 35       STB    -$B,Y
C266: 4C          INCA
C267: ED 30       STD    -$10,Y
C269: C6 0B       LDB    #$0B
C26B: E7 25       STB    $5,Y
C26D: 39          RTS
C26E: DC 9E       LDD    $9E
C270: 10 83 00 2E CMPD   #$002E
C274: 22 0E       BHI    $C284
C276: CC 00 47    LDD    #$0047
C279: 93 9E       SUBD   $9E
C27B: A3 19       SUBD   -$7,X
C27D: 2B 05       BMI    $C284
C27F: 4F          CLRA
C280: E3 19       ADDD   -$7,X
C282: ED 19       STD    -$7,X
C284: 39          RTS
C285: 6D 88 1F    TST    $1F,X
C288: 26 57       BNE    $C2E1
C28A: DC 9C       LDD    $9C
C28C: 83 00 20    SUBD   #$0020
C28F: 10 A3 16    CMPD   -$A,X
C292: 2E 18       BGT    $C2AC
C294: 4C          INCA
C295: C3 00 40    ADDD   #$0040
C298: 10 A3 16    CMPD   -$A,X
C29B: 2D 1A       BLT    $C2B7
C29D: DC 9E       LDD    $9E
C29F: 10 A3 19    CMPD   -$7,X
C2A2: 2E 20       BGT    $C2C4
C2A4: 4C          INCA
C2A5: 10 A3 19    CMPD   -$7,X
C2A8: 2D 21       BLT    $C2CB
C2AA: 20 35       BRA    $C2E1
C2AC: 6F 88 16    CLR    $16,X
C2AF: CC 4C D1    LDD    #$4CD1
C2B2: BD C0 89    JSR    $C089
C2B5: 20 19       BRA    $C2D0
C2B7: C6 01       LDB    #$01
C2B9: E7 88 16    STB    $16,X
C2BC: CC 4C DE    LDD    #$4CDE
C2BF: BD C0 89    JSR    $C089
C2C2: 20 0C       BRA    $C2D0
C2C4: C6 02       LDB    #$02
C2C6: E7 88 16    STB    $16,X
C2C9: 20 05       BRA    $C2D0
C2CB: C6 03       LDB    #$03
C2CD: E7 88 16    STB    $16,X
C2D0: D6 21       LDB    $21
C2D2: C4 03       ANDB   #$03
C2D4: CE C3 0C    LDU    #$C30C
C2D7: E6 C5       LDB    B,U
C2D9: E7 88 1E    STB    $1E,X
C2DC: C6 01       LDB    #$01
C2DE: E7 88 1F    STB    $1F,X
C2E1: 6D 88 1F    TST    $1F,X
C2E4: 27 1D       BEQ    $C303
C2E6: 6A 88 1E    DEC    $1E,X
C2E9: 27 10       BEQ    $C2FB
C2EB: CE C3 04    LDU    #$C304
C2EE: E6 88 16    LDB    $16,X
C2F1: C1 02       CMPB   #$02
C2F3: 25 03       BCS    $C2F8
C2F5: 7E C0 A3    JMP    $C0A3
C2F8: 7E C0 92    JMP    $C092
C2FB: CC 00 01    LDD    #$0001
C2FE: ED 14       STD    -$C,X
C300: 6F 88 1F    CLR    $1F,X
C303: 39          RTS

C310: 6D 0E       TST    $E,X
C312: 26 20       BNE    $C334
C314: EC 16       LDD    -$A,X
C316: 93 A0       SUBD   $A0
C318: C3 00 30    ADDD   #$0030
C31B: 10 83 00 60 CMPD   #$0060
C31F: 24 13       BCC    $C334
C321: CE C3 58    LDU    #$C358
C324: BD C0 66    JSR    $C066
C327: E7 88 17    STB    $17,X
C32A: C6 01       LDB    #$01
C32C: E7 0E       STB    $E,X
C32E: CE 4C 6D    LDU    #$4C6D
C331: BD 90 6B    JSR    $906B
C334: 6D 0E       TST    $E,X
C336: 27 1B       BEQ    $C353
C338: 6A 88 17    DEC    $17,X
C33B: 27 12       BEQ    $C34F
C33D: CE C3 54    LDU    #$C354
C340: DC A0       LDD    $A0
C342: A3 16       SUBD   -$A,X
C344: 2A 04       BPL    $C34A
C346: C6 01       LDB    #$01
C348: 20 02       BRA    $C34C
C34A: C6 00       LDB    #$00
C34C: 7E C0 92    JMP    $C092
C34F: 6F 0E       CLR    $E,X
C351: 20 C1       BRA    $C314
C353: 39          RTS

C35C: 58          ASLB
C35D: CE C3 62    LDU    #jump_table_c362
C360: 6E D5       JMP    [B,U]	; [indirect_jump]
C368: BD 79       JSR    $79A1                                        A1
C36B: C6 3F       LDB    #$3F                                         
C36D: E7 0A       STB    $A,X
C36F: CC 01 00    LDD    #$0100
C372: ED 14       STD    -$C,X
C374: 39          RTS
C375: C6 02       LDB    #$02
C377: E7 1F       STB    -$1,X
C379: CC E9 38    LDD    #$E938
C37C: ED 03       STD    $3,X
C37E: 6A 0A       DEC    $A,X
C380: 26 07       BNE    $C389
C382: CC 03 00    LDD    #$0300
C385: ED 13       STD    -$D,X
C387: E7 15       STB    -$B,X
C389: 39          RTS
C38A: E6 05       LDB    $5,X
C38C: CE 00 30    LDU    #$0030
C38F: 6C C5       INC    B,U
C391: 4F          CLRA
C392: 5F          CLRB
C393: ED 10       STD    -$10,X
C395: ED 13       STD    -$D,X
C397: 96 B5       LDA    $B5
C399: 27 02       BEQ    $C39D
C39B: 0A B5       DEC    $B5
C39D: BD 8E 0C    JSR    $8E0C
C3A0: 7E E8 44    JMP    $E844
C3A3: EC 13       LDD    -$D,X
C3A5: 48          ASLA
C3A6: CE C3 AB    LDU    #jump_table_c3ab
C3A9: 6E D6       JMP    [A,U]	; [indirect_jump]
C3B3: C6 02       LDB    #$02                                        
C3B5: E7 10       STB    -$10,X                                      
C3B7: C6 03       LDB    #$03                                        
C3B9: E7 1F       STB    -$1,X
C3BB: 8D 0C       BSR    $C3C9
C3BD: CE 4D 39    LDU    #$4D39
C3C0: BD 90 6B    JSR    $906B
C3C3: CC 01 00    LDD    #$0100
C3C6: ED 13       STD    -$D,X
C3C8: 39          RTS
C3C9: C6 01       LDB    #$01
C3CB: E7 1E       STB    -$2,X
C3CD: DC A0       LDD    $A0
C3CF: 10 A3 16    CMPD   -$A,X
C3D2: 25 02       BCS    $C3D6
C3D4: 6F 1E       CLR    -$2,X
C3D6: 39          RTS
C3D7: 58          ASLB
C3D8: CE C3 DD    LDU    #jump_table_c3dd
C3DB: 6E D5       JMP    [B,U]	; [indirect_jump]

C3E3: E6 15       LDB    -$B,X
C3E5: 58          ASLB
C3E6: CE C3 EB    LDU    #$C3EB
C3E9: 6E D5       JMP    [B,U]        ; [indirect_jump]
C3EB: C3 EF C3    ADDD   #$EFC3
C3EE: F8 86 3C    EORB   $863C
C3F1: A7 06       STA    $6,X
C3F3: BD 79 6A    JSR    $796A
C3F6: 6C 15       INC    -$B,X
C3F8: 6A 06       DEC    $6,X
C3FA: 27 03       BEQ    $C3FF
C3FC: 7E C4 7A    JMP    $C47A
C3FF: CC 01 00    LDD    #$0100
C402: ED 14       STD    -$C,X
C404: 39          RTS
C405: E6 15       LDB    -$B,X
C407: 58          ASLB
C408: CE C4 0D    LDU    #jump_table_c40d
C40B: 6E D5       JMP    [B,U]	; [indirect_jump]

C413: 86 14       LDA    #$14
C415: A7 88 18    STA    $18,X
C418: 6C 15       INC    -$B,X
C41A: 6A 88 18    DEC    $18,X
C41D: 26 1B       BNE    $C43A
C41F: C6 01       LDB    #$01
C421: E7 10       STB    -$10,X
C423: C6 09       LDB    #$09
C425: E7 1F       STB    -$1,X
C427: BD C3 C9    JSR    $C3C9
C42A: CE 4D 3D    LDU    #$4D3D
C42D: BD 90 6B    JSR    $906B
C430: 17 00 58    LBSR   $C48B
C433: 86 14       LDA    #$14
C435: A7 88 18    STA    $18,X
C438: 6C 15       INC    -$B,X
C43A: 7E 90 74    JMP    $9074
C43D: 6A 88 18    DEC    $18,X
C440: 26 05       BNE    $C447
C442: CC 02 00    LDD    #$0200
C445: ED 14       STD    -$C,X
C447: 39          RTS
C448: E6 15       LDB    -$B,X
C44A: 58          ASLB
C44B: CE C4 50    LDU    #jump_table_c450
C44E: 6E D5       JMP    [B,U]        ; [indirect_jump]
C450: C4 54       ANDB   #$54
C452: C4 6E       ANDB   #$6E
C454: 86 3C       LDA    #$3C
C456: A7 06       STA    $6,X
C458: C6 02       LDB    #$02
C45A: E7 10       STB    -$10,X
C45C: C6 03       LDB    #$03
C45E: E7 1F       STB    -$1,X
C460: BD C3 C9    JSR    $C3C9
C463: CE 4D 39    LDU    #$4D39
C466: BD 90 6B    JSR    $906B
C469: BD 79 6A    JSR    $796A
C46C: 6C 15       INC    -$B,X
C46E: 6A 06       DEC    $6,X
C470: 27 03       BEQ    $C475
C472: 7E C4 7A    JMP    $C47A
C475: 86 03       LDA    #$03
C477: A7 13       STA    -$D,X
C479: 39          RTS
C47A: 96 21       LDA    $21
C47C: 84 02       ANDA   #$02
C47E: 27 05       BEQ    $C485
C480: CC A6 31    LDD    #$A631
C483: ED 03       STD    $3,X
C485: BD 90 74    JSR    $9074
C488: 7E 8F 62    JMP    $8F62
C48B: D6 A7       LDB    $A7
C48D: 27 1F       BEQ    $C4AE
C48F: BD 8E 2E    JSR    $8E2E
C492: A6 1E       LDA    -$2,X
C494: A7 3E       STA    -$2,Y
C496: EC 16       LDD    -$A,X
C498: ED 36       STD    -$A,Y
C49A: EC 19       LDD    -$7,X
C49C: 83 00 0A    SUBD   #$000A
C49F: ED 39       STD    -$7,Y
C4A1: 4F          CLRA
C4A2: 5F          CLRB
C4A3: ED 33       STD    -$D,Y
C4A5: E7 35       STB    -$B,Y
C4A7: 4C          INCA
C4A8: ED 30       STD    -$10,Y
C4AA: C6 00       LDB    #$00
C4AC: E7 25       STB    $5,Y
C4AE: 39          RTS
C4AF: 58          ASLB
C4B0: CE C4 B5    LDU    #jump_table_c4b5
C4B3: 6E D5       JMP    [B,U]        ; [indirect_jump]
C4B5: C4 BB       ANDB   #$BB
C4B7: E8 5B       EORB   -$5,U
C4B9: C4 C5       ANDB   #$C5
C4BB: BD 79 B5    JSR    $79B5
C4BE: C6 3F       LDB    #$3F
C4C0: E7 0A       STB    $A,X
C4C2: 6C 14       INC    -$C,X
C4C4: 39          RTS
C4C5: C6 02       LDB    #$02
C4C7: E7 1F       STB    -$1,X
C4C9: CC E9 34    LDD    #$E934
C4CC: ED 03       STD    $3,X
C4CE: 6A 0A       DEC    $A,X
C4D0: 26 07       BNE    $C4D9
C4D2: CC 03 00    LDD    #$0300
C4D5: ED 13       STD    -$D,X
C4D7: E7 15       STB    -$B,X
C4D9: 39          RTS
C4DA: CE 00 30    LDU    #$0030
C4DD: E6 05       LDB    $5,X
C4DF: 6C C5       INC    B,U
C4E1: 4F          CLRA
C4E2: 5F          CLRB
C4E3: ED 10       STD    -$10,X
C4E5: ED 13       STD    -$D,X
C4E7: 7E 8E 0C    JMP    $8E0C
C4EA: EC 13       LDD    -$D,X
C4EC: 48          ASLA
C4ED: CE C4 F2    LDU    #jump_table_c4f2
C4F0: 6E D6       JMP    [A,U]	; [indirect_jump]

C4FA: 58          ASLB                                               
C4FB: CE C5 00    LDU    #$C500
C4FE: 6E D5       JMP    [B,U]	; [indirect_jump]

C504: 4F          CLRA
C505: 5F          CLRB
C506: ED 88 1A    STD    $1A,X
C509: ED 0A       STD    $A,X
C50B: ED 88 10    STD    $10,X
C50E: ED 88 1C    STD    $1C,X
C511: A7 88 15    STA    $15,X
C514: A6 12       LDA    -$E,X
C516: A7 88 12    STA    $12,X
C519: C6 04       LDB    #$04
C51B: E7 1F       STB    -$1,X
C51D: C6 01       LDB    #$01
C51F: E7 1E       STB    -$2,X
C521: EC 16       LDD    -$A,X
C523: 10 93 A0    CMPD   $A0
C526: 2D 04       BLT    $C52C
C528: C6 02       LDB    #$02
C52A: E7 1E       STB    -$2,X
C52C: CE 4D BD    LDU    #$4DBD
C52F: EF 88 1E    STU    $1E,X
C532: BD 90 6B    JSR    $906B
C535: 6F 02       CLR    $2,X
C537: BD 90 74    JSR    $9074
C53A: CC C6 82    LDD    #$C682
C53D: ED 1C       STD    -$4,X
C53F: CE 4D 69    LDU    #$4D69
C542: D6 9A       LDB    $9A
C544: C4 30       ANDB   #$30
C546: 54          LSRB
C547: 54          LSRB
C548: 54          LSRB
C549: EE C5       LDU    B,U
C54B: E6 C0       LDB    ,U+
C54D: E7 88 17    STB    $17,X
C550: EF 88 18    STU    $18,X
C553: C6 0A       LDB    #$0A
C555: E7 88 16    STB    $16,X
C558: CE 4D 65    LDU    #$4D65
C55B: D6 21       LDB    $21
C55D: DB E0       ADDB   $E0
C55F: C4 03       ANDB   #$03
C561: E6 C5       LDB    B,U
C563: E7 88 11    STB    $11,X
C566: 6C 14       INC    -$C,X
C568: 39          RTS
C569: A6 11       LDA    -$F,X
C56B: 27 07       BEQ    $C574
C56D: CC 01 00    LDD    #$0100
C570: ED 13       STD    -$D,X
C572: E7 15       STB    -$B,X
C574: 39          RTS
C575: 58          ASLB
C576: CE C5 7B    LDU    #jump_table_c57b
C579: 6E D5       JMP    [B,U]        ; [indirect_jump]

C587: E6 15       LDB    -$B,X
C589: 58          ASLB
C58A: CE C5 8F    LDU    #jump_table_c58f
C58D: 6E D5       JMP    [B,U]        ; [indirect_jump]

C593: BD 8C A7    JSR    $8CA7
C596: 24 05       BCC    $C59D
C598: 4F          CLRA
C599: E3 19       ADDD   -$7,X
C59B: ED 19       STD    -$7,X
C59D: 6C 15       INC    -$B,X
C59F: 39          RTS
C5A0: DC A2       LDD    $A2
C5A2: C3 00 40    ADDD   #$0040
C5A5: A3 19       SUBD   -$7,X
C5A7: 2B 13       BMI    $C5BC
C5A9: D6 21       LDB    $21
C5AB: 5C          INCB
C5AC: C4 0F       ANDB   #$0F
C5AE: 26 0C       BNE    $C5BC
C5B0: 6A 88 11    DEC    $11,X
C5B3: 26 07       BNE    $C5BC
C5B5: 0C B5       INC    $B5
C5B7: CC 01 00    LDD    #$0100
C5BA: ED 14       STD    -$C,X
C5BC: 39          RTS
C5BD: EC 16       LDD    -$A,X
C5BF: 93 9C       SUBD   $9C
C5C1: C3 01 00    ADDD   #$0100
C5C4: 10 83 03 00 CMPD   #$0300
C5C8: 22 0D       BHI    $C5D7
C5CA: EC 19       LDD    -$7,X
C5CC: 93 9E       SUBD   $9E
C5CE: C3 00 A0    ADDD   #$00A0
C5D1: 10 83 02 40 CMPD   #$0240
C5D5: 23 07       BLS    $C5DE
C5D7: CC 03 00    LDD    #$0300
C5DA: ED 13       STD    -$D,X
C5DC: E7 15       STB    -$B,X
C5DE: E6 15       LDB    -$B,X
C5E0: 58          ASLB
C5E1: CE C6 42    LDU    #jump_table_c642		; 2 entries
C5E4: AD D5       JSR    [B,U]		; [indirect_jump]
C5E6: BD CB 3A    JSR    $CB3A
C5E9: E6 88 1B    LDB    $1B,X
C5EC: 26 32       BNE    $C620
C5EE: 6A 88 17    DEC    $17,X
C5F1: 26 4E       BNE    $C641
C5F3: EE 88 18    LDU    $18,X
C5F6: E6 C0       LDB    ,U+
C5F8: 2A 04       BPL    $C5FE
C5FA: EE C4       LDU    ,U
C5FC: C4 7F       ANDB   #$7F
C5FE: EF 88 18    STU    $18,X
C601: E7 88 17    STB    $17,X
C604: C6 01       LDB    #$01
C606: E7 88 1B    STB    $1B,X
C609: E6 88 13    LDB    $13,X
C60C: 58          ASLB
C60D: CE 4E 3F    LDU    #$4E3F
C610: EF 88 1E    STU    $1E,X
C613: EE C5       LDU    B,U
C615: EF 84       STU    ,X
C617: EF 03       STU    $3,X
C619: 6F 02       CLR    $2,X
C61B: C6 28       LDB    #$28
C61D: E7 88 1A    STB    $1A,X
C620: 6A 88 1A    DEC    $1A,X
C623: 26 1C       BNE    $C641
C625: E6 88 13    LDB    $13,X
C628: 58          ASLB
C629: CE 4E C1    LDU    #$4EC1
C62C: EE C5       LDU    B,U
C62E: EF 84       STU    ,X
C630: EF 03       STU    $3,X
C632: 6F 02       CLR    $2,X
C634: C6 19       LDB    #$19
C636: E7 88 1A    STB    $1A,X
C639: 6F 88 1B    CLR    $1B,X
C63C: CC 05 00    LDD    #$0500
C63F: ED 14       STD    -$C,X
C641: 39          RTS

C696: D6 21       LDB    $21                                        
C698: DB E0       ADDB   $E0                                        
C69A: 5C          INCB                                              
C69B: C4 03       ANDB   #$03
C69D: CE C6 46    LDU    #$C646
C6A0: 58          ASLB
C6A1: EE C5       LDU    B,U
C6A3: EF 08       STU    $8,X
C6A5: 6F 07       CLR    $7,X
C6A7: BD C7 5D    JSR    $C75D
C6AA: CC C6 82    LDD    #$C682
C6AD: ED 1C       STD    -$4,X
C6AF: C6 01       LDB    #$01
C6B1: E7 88 13    STB    $13,X
C6B4: EC 16       LDD    -$A,X
C6B6: 10 93 A0    CMPD   $A0
C6B9: 2D 05       BLT    $C6C0
C6BB: C6 02       LDB    #$02
C6BD: E7 88 13    STB    $13,X
C6C0: E6 88 13    LDB    $13,X
C6C3: EE 88 1E    LDU    $1E,X
C6C6: 58          ASLB
C6C7: EE C5       LDU    B,U
C6C9: EF 84       STU    ,X
C6CB: EF 03       STU    $3,X
C6CD: 6F 02       CLR    $2,X
C6CF: BD 68 F9    JSR    $68F9
C6D2: C4 07       ANDB   #$07
C6D4: CE C6 8E    LDU    #$C68E
C6D7: E6 C5       LDB    B,U
C6D9: E7 06       STB    $6,X
C6DB: 6F 0A       CLR    $A,X
C6DD: 6F 0B       CLR    $B,X
C6DF: E6 88 12    LDB    $12,X
C6E2: 27 0A       BEQ    $C6EE
C6E4: C1 02       CMPB   #$02
C6E6: 27 06       BEQ    $C6EE
C6E8: CC 02 00    LDD    #$0200
C6EB: ED 14       STD    -$C,X
C6ED: 39          RTS
C6EE: 6C 15       INC    -$B,X
C6F0: BD C7 5D    JSR    $C75D
C6F3: E6 1E       LDB    -$2,X
C6F5: 27 0F       BEQ    $C706
C6F7: D6 21       LDB    $21
C6F9: 5C          INCB
C6FA: C4 1F       ANDB   #$1F
C6FC: 26 03       BNE    $C701
C6FE: BD 79 92    JSR    $7992
C701: BD A4 27    JSR    $A427
C704: 20 10       BRA    $C716
C706: E6 88 13    LDB    $13,X
C709: E7 1E       STB    -$2,X
C70B: EE 88 1E    LDU    $1E,X
C70E: BD 90 6B    JSR    $906B
C711: 4F          CLRA
C712: A7 1E       STA    -$2,X
C714: A7 02       STA    $2,X
C716: BD 90 74    JSR    $9074
C719: 8D 39       BSR    $C754
C71B: 6F 0B       CLR    $B,X
C71D: E6 07       LDB    $7,X
C71F: 26 1F       BNE    $C740
C721: C6 02       LDB    #$02
C723: E7 0B       STB    $B,X
C725: EC 16       LDD    -$A,X
C727: 10 93 A0    CMPD   $A0
C72A: 22 15       BHI    $C741
C72C: DC A0       LDD    $A0
C72E: A3 16       SUBD   -$A,X
C730: 10 83 00 20 CMPD   #$0020
C734: 23 0A       BLS    $C740
C736: 6A 0B       DEC    $B,X
C738: 10 83 00 78 CMPD   #$0078
C73C: 24 02       BCC    $C740
C73E: 6A 0B       DEC    $B,X
C740: 39          RTS
C741: 93 A0       SUBD   $A0
C743: 10 83 00 78 CMPD   #$0078
C747: 24 F7       BCC    $C740
C749: 6A 0B       DEC    $B,X
C74B: 10 83 00 38 CMPD   #$0038
C74F: 23 EF       BLS    $C740
C751: 6A 0B       DEC    $B,X
C753: 39          RTS
C754: 6A 06       DEC    $6,X
C756: 26 04       BNE    $C75C
C758: C6 01       LDB    #$01
C75A: E7 0A       STB    $A,X
C75C: 39          RTS
C75D: A6 88 12    LDA    $12,X
C760: 81 02       CMPA   #$02
C762: 27 17       BEQ    $C77B
C764: 96 72       LDA    starting_level_0072
C766: 81 01       CMPA   #$01
C768: 27 29       BEQ    $C793
C76A: DC 5A       LDD    $5A
C76C: C3 00 E0    ADDD   #$00E0
C76F: A3 16       SUBD   -$A,X
C771: 2A 2D       BPL    $C7A0
C773: CC 02 40    LDD    #$0240
C776: A7 1E       STA    -$2,X
C778: E7 07       STB    $7,X
C77A: 39          RTS
C77B: EC 16       LDD    -$A,X
C77D: 10 83 1D 98 CMPD   #$1D98
C781: 22 05       BHI    $C788
C783: CC 01 40    LDD    #$0140
C786: 20 EE       BRA    $C776
C788: 10 83 1E 48 CMPD   #$1E48
C78C: 25 12       BCS    $C7A0
C78E: CC 02 40    LDD    #$0240
C791: 20 E3       BRA    $C776
C793: EC 16       LDD    -$A,X
C795: 10 83 1A 18 CMPD   #$1A18
C799: 22 05       BHI    $C7A0
C79B: CC 01 40    LDD    #$0140
C79E: 20 D6       BRA    $C776
C7A0: E6 07       LDB    $7,X
C7A2: 26 12       BNE    $C7B6
C7A4: EE 08       LDU    $8,X
C7A6: EC C1       LDD    ,U++
C7A8: 4D          TSTA
C7A9: 2A 04       BPL    $C7AF
C7AB: 84 7F       ANDA   #$7F
C7AD: EE C4       LDU    ,U
C7AF: EF 08       STU    $8,X
C7B1: A7 1E       STA    -$2,X
C7B3: E7 07       STB    $7,X
C7B5: 39          RTS
C7B6: 6A 07       DEC    $7,X
C7B8: 39          RTS

C7C5: E6 15       LDB    -$B,X
C7C7: 58          ASLB
C7C8: CE C7 CD    LDU    #jump_table_c7cd
C7CB: 6E D5       JMP    [B,U]        ; [indirect_jump]

C7DD: CC 00 06    LDD    #$0006
C7E0: ED 0C       STD    $C,X
C7E2: 5F          CLRB
C7E3: ED 0E       STD    $E,X
C7E5: CE 4E 1F    LDU    #$4E1F
C7E8: E6 88 1B    LDB    $1B,X
C7EB: 27 03       BEQ    $C7F0
C7ED: CE 4E A1    LDU    #$4EA1
C7F0: EF 88 1E    STU    $1E,X
C7F3: E6 88 13    LDB    $13,X
C7F6: 58          ASLB
C7F7: EE C5       LDU    B,U
C7F9: EF 84       STU    ,X
C7FB: EF 03       STU    $3,X
C7FD: E6 88 12    LDB    $12,X
C800: 27 16       BEQ    $C818
C802: C1 02       CMPB   #$02
C804: 27 29       BEQ    $C82F
C806: 6F 88 12    CLR    $12,X
C809: C6 10       LDB    #$10
C80B: A6 88 13    LDA    $13,X
C80E: 4A          DECA
C80F: 26 02       BNE    $C813
C811: C6 0F       LDB    #$0F
C813: E7 88 13    STB    $13,X
C816: 20 2D       BRA    $C845
C818: E6 88 15    LDB    $15,X
C81B: 27 12       BEQ    $C82F
C81D: 6F 88 15    CLR    $15,X
C820: C6 05       LDB    #$05
C822: A6 88 13    LDA    $13,X
C825: 4A          DECA
C826: 26 02       BNE    $C82A
C828: C6 06       LDB    #$06
C82A: E7 88 13    STB    $13,X
C82D: 20 16       BRA    $C845
C82F: CE C8 9E    LDU    #$C89E
C832: E6 88 13    LDB    $13,X
C835: 5A          DECB
C836: 26 03       BNE    $C83B
C838: CE C8 A2    LDU    #$C8A2
C83B: BD 68 F9    JSR    $68F9
C83E: C4 03       ANDB   #$03
C840: E6 C5       LDB    B,U
C842: E7 88 13    STB    $13,X
C845: 96 72       LDA    starting_level_0072
C847: 81 05       CMPA   #$05
C849: 27 19       BEQ    $C864
C84B: 81 01       CMPA   #$01
C84D: 26 37       BNE    $C886
C84F: EC 16       LDD    -$A,X
C851: 10 83 1A 60 CMPD   #$1A60
C855: 22 2F       BHI    $C886
C857: A6 88 13    LDA    $13,X
C85A: 85 01       BITA   #$01
C85C: 26 28       BNE    $C886
C85E: CC 02 05    LDD    #$0205
C861: ED 14       STD    -$C,X
C863: 39          RTS
C864: EC 16       LDD    -$A,X
C866: 10 83 1D A8 CMPD   #$1DA8
C86A: 22 09       BHI    $C875
C86C: A6 88 13    LDA    $13,X
C86F: 85 01       BITA   #$01
C871: 26 13       BNE    $C886
C873: 20 E9       BRA    $C85E
C875: 10 83 1E 38 CMPD   #$1E38
C879: 25 0B       BCS    $C886
C87B: A6 88 13    LDA    $13,X
C87E: 27 DE       BEQ    $C85E
C880: 85 01       BITA   #$01
C882: 27 02       BEQ    $C886
C884: 20 D8       BRA    $C85E
C886: 6C 15       INC    -$B,X
C888: 39          RTS
C889: BD C9 40    JSR    $C940
C88C: 6F 88 10    CLR    $10,X
C88F: 8D 15       BSR    $C8A6
C891: EC 0D       LDD    $D,X
C893: 10 83 01 00 CMPD   #$0100
C897: 10 22 C7 D9 LBHI   $9074
C89B: 6C 15       INC    -$B,X
C89D: 39          RTS
C89E: 00 02       NEG    $02
C8A0: 04 00       LSR    $00
C8A2: 01 00       NEG    $00
C8A4: 00 03       NEG    $03
C8A6: EC 1A       LDD    -$6,X
C8A8: E3 0D       ADDD   $D,X
C8AA: ED 1A       STD    -$6,X
C8AC: E6 19       LDB    -$7,X
C8AE: E9 0C       ADCB   $C,X
C8B0: E7 19       STB    -$7,X
C8B2: CE C7 B9    LDU    #$C7B9
C8B5: E6 88 10    LDB    $10,X
C8B8: 58          ASLB
C8B9: EE C5       LDU    B,U
C8BB: EC 0E       LDD    $E,X
C8BD: A3 C4       SUBD   ,U
C8BF: ED 0E       STD    $E,X
C8C1: EC 0C       LDD    $C,X
C8C3: C2 00       SBCB   #$00
C8C5: 82 00       SBCA   #$00
C8C7: ED 0C       STD    $C,X
C8C9: 39          RTS

C8EC: 8D 52       BSR    $C940
C8EE: C6 01       LDB    #$01
C8F0: E7 88 10    STB    $10,X
C8F3: 8D B1       BSR    $C8A6
C8F5: EC 0D       LDD    $D,X
C8F7: 10 83 00 19 CMPD   #$0019
C8FB: 10 22 C7 75 LBHI   $9074
C8FF: 6C 15       INC    -$B,X
C901: 39          RTS
C902: 8D 3C       BSR    $C940
C904: C6 01       LDB    #$01
C906: E7 88 10    STB    $10,X
C909: 8D 03       BSR    $C90E
C90B: 7E 90 74    JMP    $9074
C90E: EC 1A       LDD    -$6,X
C910: A3 0D       SUBD   $D,X
C912: ED 1A       STD    -$6,X
C914: E6 19       LDB    -$7,X
C916: E2 0C       SBCB   $C,X
C918: E7 19       STB    -$7,X
C91A: CE C7 B9    LDU    #$C7B9
C91D: E6 88 10    LDB    $10,X
C920: 58          ASLB
C921: EE C5       LDU    B,U
C923: EC 0C       LDD    $C,X
C925: 10 A3 42    CMPD   $2,U
C928: 22 0E       BHI    $C938
C92A: EC 0E       LDD    $E,X
C92C: E3 C4       ADDD   ,U
C92E: ED 0E       STD    $E,X
C930: EC 0C       LDD    $C,X
C932: C9 00       ADCB   #$00
C934: 89 00       ADCA   #$00
C936: ED 0C       STD    $C,X
C938: E6 88 10    LDB    $10,X
C93B: 27 02       BEQ    $C93F
C93D: 6C 15       INC    -$B,X
C93F: 39          RTS
C940: E6 88 13    LDB    $13,X
C943: 58          ASLB
C944: CE C8 CA    LDU    #$C8CA
C947: 33 C5       LEAU   B,U
C949: EC 17       LDD    -$9,X
C94B: E3 C4       ADDD   ,U
C94D: ED 17       STD    -$9,X
C94F: E6 C4       LDB    ,U
C951: 1D          SEX
C952: A9 16       ADCA   -$A,X
C954: A7 16       STA    -$A,X
C956: 39          RTS
C957: 8D E7       BSR    $C940
C959: 6F 88 10    CLR    $10,X
C95C: 8D B0       BSR    $C90E
C95E: BD 90 74    JSR    $9074
C961: BD 8C A7    JSR    $8CA7
C964: 24 07       BCC    $C96D
C966: 4F          CLRA
C967: E3 19       ADDD   -$7,X
C969: ED 19       STD    -$7,X
C96B: 6C 15       INC    -$B,X
C96D: 39          RTS
C96E: BD 79 92    JSR    $7992
C971: C6 01       LDB    #$01
C973: E7 1E       STB    -$2,X
C975: E7 88 13    STB    $13,X
C978: EC 16       LDD    -$A,X
C97A: 10 93 A0    CMPD   $A0
C97D: 2D 07       BLT    $C986
C97F: C6 02       LDB    #$02
C981: E7 1E       STB    -$2,X
C983: E7 88 13    STB    $13,X
C986: CE 4D BD    LDU    #$4DBD
C989: E6 88 1B    LDB    $1B,X
C98C: 27 12       BEQ    $C9A0
C98E: CE 4E C1    LDU    #$4EC1
C991: BD 90 6B    JSR    $906B
C994: CC 19 00    LDD    #$1900
C997: ED 88 1A    STD    $1A,X
C99A: CC 05 00    LDD    #$0500
C99D: ED 14       STD    -$C,X
C99F: 39          RTS
C9A0: CE 4D BD    LDU    #$4DBD
C9A3: BD 90 6B    JSR    $906B
C9A6: EF 88 1E    STU    $1E,X
C9A9: 6F 02       CLR    $2,X
C9AB: BD 90 74    JSR    $9074
C9AE: 86 0F       LDA    #$0F
C9B0: A7 88 14    STA    $14,X
C9B3: 6C 15       INC    -$B,X
C9B5: 39          RTS
C9B6: 6A 88 14    DEC    $14,X
C9B9: 26 09       BNE    $C9C4
C9BB: A6 0A       LDA    $A,X
C9BD: 26 06       BNE    $C9C5
C9BF: CC 01 01    LDD    #$0101
C9C2: ED 14       STD    -$C,X
C9C4: 39          RTS
C9C5: CC 01 00    LDD    #$0100
C9C8: ED 14       STD    -$C,X
C9CA: 39          RTS
C9CB: CC 00 06    LDD    #$0006
C9CE: ED 0C       STD    $C,X
C9D0: 5F          CLRB
C9D1: ED 0E       STD    $E,X
C9D3: CE 4E 1F    LDU    #$4E1F
C9D6: E6 88 1B    LDB    $1B,X
C9D9: 27 03       BEQ    $C9DE
C9DB: CE 4E A1    LDU    #$4EA1
C9DE: EF 88 1E    STU    $1E,X
C9E1: E6 88 13    LDB    $13,X
C9E4: 58          ASLB
C9E5: EE C5       LDU    B,U
C9E7: EF 84       STU    ,X
C9E9: EF 03       STU    $3,X
C9EB: E6 88 13    LDB    $13,X
C9EE: 5A          DECB
C9EF: 27 06       BEQ    $C9F7
C9F1: EC 16       LDD    -$A,X
C9F3: 93 A0       SUBD   $A0
C9F5: 20 04       BRA    $C9FB
C9F7: DC A0       LDD    $A0
C9F9: A3 16       SUBD   -$A,X
C9FB: C4 70       ANDB   #$70
C9FD: 54          LSRB
C9FE: 54          LSRB
C9FF: 54          LSRB
CA00: 54          LSRB
CA01: A6 88 13    LDA    $13,X
CA04: 4A          DECA
CA05: 26 0F       BNE    $CA16
CA07: C1 01       CMPB   #$01
CA09: 23 03       BLS    $CA0E
CA0B: 58          ASLB
CA0C: C0 01       SUBB   #$01
CA0E: E7 88 13    STB    $13,X
CA11: 6F 15       CLR    -$B,X
CA13: 7E C8 45    JMP    $C845
CA16: 58          ASLB
CA17: 20 F5       BRA    $CA0E
CA19: 39          RTS
CA1A: E6 15       LDB    -$B,X
CA1C: 58          ASLB
CA1D: CE CA 22    LDU    #jump_table_ca22
CA20: 6E D5       JMP    [B,U]	; [indirect_jump]

CA32: DC A0       LDD    $A0                                         
CA34: C3 00       ADDD   #$0010                                       10
CA37: ED 88 1C    STD    $1C,X
CA3A: C6 01       LDB    #$01
CA3C: E7 1E       STB    -$2,X
CA3E: EC 16       LDD    -$A,X
CA40: 10 93 A0    CMPD   $A0
CA43: 23 0C       BLS    $CA51
CA45: C6 02       LDB    #$02
CA47: E7 1E       STB    -$2,X
CA49: DC A0       LDD    $A0
CA4B: 83 00 10    SUBD   #$0010
CA4E: ED 88 1C    STD    $1C,X
CA51: CC CA 26    LDD    #$CA26
CA54: ED 1C       STD    -$4,X
CA56: 6C 15       INC    -$B,X
CA58: D6 21       LDB    $21
CA5A: 5C          INCB
CA5B: C4 0F       ANDB   #$0F
CA5D: 26 03       BNE    $CA62
CA5F: BD 79 92    JSR    $7992
CA62: BD A4 27    JSR    $A427
CA65: BD 90 74    JSR    $9074
CA68: BD 90 74    JSR    $9074
CA6B: E6 1E       LDB    -$2,X
CA6D: 5A          DECB
CA6E: 27 0E       BEQ    $CA7E
CA70: EC 16       LDD    -$A,X
CA72: 10 A3 88 1C CMPD   $1C,X
CA76: 22 13       BHI    $CA8B
CA78: CC 01 00    LDD    #$0100
CA7B: ED 14       STD    -$C,X
CA7D: 39          RTS
CA7E: EC 88 1C    LDD    $1C,X
CA81: 10 A3 16    CMPD   -$A,X
CA84: 22 05       BHI    $CA8B
CA86: CC 01 00    LDD    #$0100
CA89: ED 14       STD    -$C,X
CA8B: 39          RTS
CA8C: E6 15       LDB    -$B,X
CA8E: 58          ASLB
CA8F: CE CA A4    LDU    #jump_table_caa4
CA92: AD D5       JSR    [B,U]	; [indirect_jump]
CA94: D6 21       LDB    $21
CA96: 5C          INCB
CA97: C4 1F       ANDB   #$1F
CA99: 26 03       BNE    $CA9E
CA9B: BD 79 92    JSR    $7992
CA9E: BD CB 3A    JSR    $CB3A
CAA1: 7E C5 E9    JMP    $C5E9

CAAA: E6 0B       LDB    $B,X
CAAC: E7 1E       STB    -$2,X
CAAE: 6F 0B       CLR    $B,X
CAB0: C6 01       LDB    #$01
CAB2: E7 88 13    STB    $13,X
CAB5: EC 16       LDD    -$A,X
CAB7: 10 93 A0    CMPD   $A0
CABA: 2D 05       BLT    $CAC1
CABC: C6 02       LDB    #$02
CABE: E7 88 13    STB    $13,X
CAC1: E6 88 13    LDB    $13,X
CAC4: C6 02       LDB    #$02
CAC6: E7 15       STB    -$B,X
CAC8: EC 16       LDD    -$A,X
CACA: 10 93 A0    CMPD   $A0
CACD: 22 21       BHI    $CAF0
CACF: E6 1E       LDB    -$2,X
CAD1: 5A          DECB
CAD2: 26 03       BNE    $CAD7
CAD4: 6A 15       DEC    -$B,X
CAD6: 39          RTS
CAD7: E6 88 12    LDB    $12,X
CADA: C1 02       CMPB   #$02
CADC: 27 11       BEQ    $CAEF
CADE: BD 68 F9    JSR    $68F9
CAE1: C4 01       ANDB   #$01
CAE3: 26 0A       BNE    $CAEF
CAE5: C6 01       LDB    #$01
CAE7: E7 88 15    STB    $15,X
CAEA: CC 02 00    LDD    #$0200
CAED: ED 14       STD    -$C,X
CAEF: 39          RTS
CAF0: E6 1E       LDB    -$2,X
CAF2: 5A          DECB
CAF3: 27 E2       BEQ    $CAD7
CAF5: 6A 15       DEC    -$B,X
CAF7: 39          RTS
CAF8: BD A4 27    JSR    $A427
CAFB: BD 90 74    JSR    $9074
CAFE: EC 16       LDD    -$A,X
CB00: 93 A0       SUBD   $A0
CB02: C3 00 70    ADDD   #$0070
CB05: 10 83 00 E0 CMPD   #$00E0
CB09: 22 05       BHI    $CB10
CB0B: CC 01 01    LDD    #$0101
CB0E: ED 14       STD    -$C,X
CB10: 39          RTS
CB11: BD A4 27    JSR    $A427
CB14: BD 90 74    JSR    $9074
CB17: EC 16       LDD    -$A,X
CB19: 93 A0       SUBD   $A0
CB1B: C3 00 60    ADDD   #$0060
CB1E: 10 83 00 C0 CMPD   #$00C0
CB22: 25 05       BCS    $CB29
CB24: CC 01 01    LDD    #$0101
CB27: ED 14       STD    -$C,X
CB29: FC 06 36    LDD    $0636
CB2C: C3 00 E0    ADDD   #$00E0
CB2F: A3 16       SUBD   -$A,X
CB31: 2A 06       BPL    $CB39
CB33: CC 01 01    LDD    #$0101
CB36: ED 14       STD    -$C,X
CB38: 39          RTS
CB39: 39          RTS
CB3A: E6 0A       LDB    $A,X
CB3C: 26 35       BNE    $CB73
CB3E: E6 88 1B    LDB    $1B,X
CB41: 26 26       BNE    $CB69
CB43: 0F E1       CLR    $E1
CB45: CE 05 40    LDU    #$0540
CB48: 8D 43       BSR    $CB8D
CB4A: D6 E1       LDB    $E1
CB4C: 26 24       BNE    $CB72
CB4E: 33 C8 40    LEAU   $40,U
CB51: 8D 3A       BSR    $CB8D
CB53: D6 E1       LDB    $E1
CB55: 26 1B       BNE    $CB72
CB57: 33 C8 40    LEAU   $40,U
CB5A: 8D 31       BSR    $CB8D
CB5C: D6 E1       LDB    $E1
CB5E: 26 12       BNE    $CB72
CB60: 33 C8 40    LEAU   $40,U
CB63: 8D 28       BSR    $CB8D
CB65: D6 E1       LDB    $E1
CB67: 26 09       BNE    $CB72
CB69: E6 0B       LDB    $B,X
CB6B: 27 05       BEQ    $CB72
CB6D: CC 04 00    LDD    #$0400
CB70: ED 14       STD    -$C,X
CB72: 39          RTS
CB73: A6 88 12    LDA    $12,X
CB76: 81 02       CMPA   #$02
CB78: 27 07       BEQ    $CB81
CB7A: BD 68 F9    JSR    $68F9
CB7D: C4 01       ANDB   #$01
CB7F: 26 06       BNE    $CB87
CB81: CC 03 00    LDD    #$0300
CB84: ED 14       STD    -$C,X
CB86: 39          RTS
CB87: CC 02 07    LDD    #$0207
CB8A: ED 14       STD    -$C,X
CB8C: 39          RTS
CB8D: E6 50       LDB    -$10,U
CB8F: E4 51       ANDB   -$F,U
CB91: 27 1B       BEQ    $CBAE
CB93: E6 88 13    LDB    $13,X
CB96: E1 5E       CMPB   -$2,U
CB98: 27 14       BEQ    $CBAE
CB9A: EC 16       LDD    -$A,X
CB9C: A3 56       SUBD   -$A,U
CB9E: C3 00 38    ADDD   #$0038
CBA1: 10 83 00 70 CMPD   #$0070
CBA5: 22 07       BHI    $CBAE
CBA7: 0C E1       INC    $E1
CBA9: CC 02 00    LDD    #$0200
CBAC: ED 14       STD    -$C,X
CBAE: 39          RTS
CBAF: 6A 88 1A    DEC    $1A,X
CBB2: 10 26 C4 BE LBNE   $9074
CBB6: D6 A7       LDB    $A7
CBB8: 27 37       BEQ    $CBF1
CBBA: BD 8E 2E    JSR    $8E2E
CBBD: EC 16       LDD    -$A,X
CBBF: ED 36       STD    -$A,Y
CBC1: EC 19       LDD    -$7,X
CBC3: ED 39       STD    -$7,Y
CBC5: E6 88 13    LDB    $13,X
CBC8: 5A          DECB
CBC9: E7 3E       STB    -$2,Y
CBCB: 4F          CLRA
CBCC: 5F          CLRB
CBCD: ED 33       STD    -$D,Y
CBCF: E7 35       STB    -$B,Y
CBD1: 4C          INCA
CBD2: ED 30       STD    -$10,Y
CBD4: C6 01       LDB    #$01
CBD6: E7 25       STB    $5,Y
CBD8: CE 4D BD    LDU    #$4DBD
CBDB: EF 88 1E    STU    $1E,X
CBDE: E6 88 13    LDB    $13,X
CBE1: 58          ASLB
CBE2: EE C5       LDU    B,U
CBE4: EF 84       STU    ,X
CBE6: EF 03       STU    $3,X
CBE8: A6 0A       LDA    $A,X
CBEA: 26 06       BNE    $CBF2
CBEC: CC 01 01    LDD    #$0101
CBEF: ED 14       STD    -$C,X
CBF1: 39          RTS
CBF2: CC 03 00    LDD    #$0300
CBF5: ED 14       STD    -$C,X
CBF7: 39          RTS
CBF8: 58          ASLB
CBF9: CE CB FE    LDU    #jump_table_cbfe
CBFC: 6E D5       JMP    [B,U]	; [indirect_jump]

CC04: BD 79 A1    JSR    $79A1
CC07: C6 3F       LDB    #$3F
CC09: E7 0A       STB    $A,X
CC0B: 6C 14       INC    -$C,X
CC0D: 39          RTS
CC0E: C6 02       LDB    #$02
CC10: E7 1F       STB    -$1,X
CC12: CC E9 34    LDD    #$E934
CC15: ED 03       STD    $3,X
CC17: 6A 0A       DEC    $A,X
CC19: 26 07       BNE    $CC22
CC1B: CC 03 00    LDD    #$0300
CC1E: ED 13       STD    -$D,X
CC20: E7 15       STB    -$B,X
CC22: 39          RTS
CC23: E6 05       LDB    $5,X
CC25: CE 00 30    LDU    #$0030
CC28: 6C C5       INC    B,U
CC2A: 4F          CLRA
CC2B: 5F          CLRB
CC2C: ED 10       STD    -$10,X
CC2E: ED 13       STD    -$D,X
CC30: E7 15       STB    -$B,X
CC32: 96 B5       LDA    $B5
CC34: 27 02       BEQ    $CC38
CC36: 0A B5       DEC    $B5
CC38: BD 8E 0C    JSR    $8E0C
CC3B: D6 72       LDB    starting_level_0072
CC3D: C1 05       CMPB   #$05
CC3F: 27 03       BEQ    $CC44
CC41: 7E E8 44    JMP    $E844
CC44: 39          RTS
CC45: EC 13       LDD    -$D,X
CC47: 48          ASLA
CC48: CE CC 4D    LDU    #jump_table_cc4d
CC4B: 6E D6       JMP    [A,U]	; [indirect_jump]

CC55: 58          ASLB                                                
CC56: CE CC 5B    LDU    #$CC5B
CC59: 6E D5       JMP    [B,U]	; [indirect_jump]

CC5F: C6 00       LDB    #$00                                        
CC61: E7 1F       STB    -$1,X
CC63: CC CC 96    LDD    #$CC96
CC66: ED 84       STD    ,X
CC68: 6F 02       CLR    $2,X
CC6A: BD 90 74    JSR    $9074
CC6D: 6C 14       INC    -$C,X
CC6F: 39          RTS
CC70: E6 11       LDB    -$F,X
CC72: 27 21       BEQ    $CC95
CC74: EC 16       LDD    -$A,X
CC76: 93 A0       SUBD   $A0
CC78: C3 00 20    ADDD   #$0020
CC7B: 10 83 00 40 CMPD   #$0040
CC7F: 22 14       BHI    $CC95
CC81: EC 19       LDD    -$7,X
CC83: 93 A2       SUBD   $A2
CC85: C3 00 20    ADDD   #$0020
CC88: 10 83 00 40 CMPD   #$0040
CC8C: 22 07       BHI    $CC95
CC8E: CC 01 00    LDD    #$0100
CC91: ED 13       STD    -$D,X
CC93: E7 15       STB    -$B,X
CC95: 39          RTS
CC96: A7 30       STA    -$10,Y
CC98: 83 CC 96    SUBD   #$CC96
CC9B: 58          ASLB
CC9C: CE CC A4    LDU    #jump_table_cca4
CC9F: AD D5       JSR    [B,U]	; [indirect_jump]
CCA1: 7E 8F 62    JMP    $8F62

CCAA: E6 15       LDB    -$B,X
CCAC: 58          ASLB
CCAD: CE CC B2    LDU    #$CCB2
CCB0: 6E D5       JMP    [B,U]	; [indirect_jump]

CCB8: CC CD 44    LDD    #$CD44
CCBB: ED 1C       STD    -$4,X
CCBD: C6 04       LDB    #$04
CCBF: E7 1E       STB    -$2,X
CCC1: C6 02       LDB    #$02
CCC3: E7 1F       STB    -$1,X
CCC5: CC CD 26    LDD    #$CD26
CCC8: ED 84       STD    ,X
CCCA: 6F 02       CLR    $2,X
CCCC: BD 90 74    JSR    $9074
CCCF: CC 00 03    LDD    #$0003
CCD2: ED 0A       STD    $A,X
CCD4: CC 80 00    LDD    #$8000
CCD7: ED 0C       STD    $C,X
CCD9: EC 16       LDD    -$A,X
CCDB: 83 00 08    SUBD   #$0008
CCDE: ED 16       STD    -$A,X
CCE0: 6C 15       INC    -$B,X
CCE2: 39          RTS
CCE3: BD CD 08    JSR    $CD08
CCE6: E6 02       LDB    $2,X
CCE8: 26 02       BNE    $CCEC
CCEA: 6C 15       INC    -$B,X
CCEC: 39          RTS
CCED: BD CD 08    JSR    $CD08
CCF0: E6 02       LDB    $2,X
CCF2: 26 13       BNE    $CD07
CCF4: EC 19       LDD    -$7,X
CCF6: 83 00 10    SUBD   #$0010
CCF9: ED 19       STD    -$7,X
CCFB: C6 03       LDB    #$03
CCFD: E7 1F       STB    -$1,X
CCFF: BD 90 74    JSR    $9074
CD02: CC 01 00    LDD    #$0100
CD05: ED 14       STD    -$C,X
CD07: 39          RTS
CD08: EC 1A       LDD    -$6,X
CD0A: E3 0B       ADDD   $B,X
CD0C: ED 1A       STD    -$6,X
CD0E: E6 19       LDB    -$7,X
CD10: E9 0A       ADCB   $A,X
CD12: E7 19       STB    -$7,X
CD14: EC 0C       LDD    $C,X
CD16: 83 29 85    SUBD   #$2985
CD19: ED 0C       STD    $C,X
CD1B: EC 0A       LDD    $A,X
CD1D: C2 00       SBCB   #$00
CD1F: 82 00       SBCA   #$00
CD21: ED 0A       STD    $A,X
CD23: 7E 90 74    JMP    $9074

CD30: E6 15       LDB    -$B,X
CD32: 58          ASLB
CD33: CE CD 38    LDU    #jump_table_cd38
CD36: 6E D5       JMP    [B,U]	; [indirect_jump]

CD58: BD 79 E7    JSR    $79E7                                      
CD5B: CC CD 44    LDD    #$CD44                                     
CD5E: ED 1C       STD    -$4,X
CD60: C6 02       LDB    #$02
CD62: E7 09       STB    $9,X
CD64: 6C 15       INC    -$B,X
CD66: 39          RTS
CD67: CC CE 1A    LDD    #$CE1A
CD6A: ED 84       STD    ,X
CD6C: 6F 02       CLR    $2,X
CD6E: BD 90 74    JSR    $9074
CD71: CC 00 03    LDD    #$0003
CD74: ED 0A       STD    $A,X
CD76: CC 00 00    LDD    #$0000
CD79: ED 0C       STD    $C,X
CD7B: 6C 15       INC    -$B,X
CD7D: BD CD F6    JSR    $CDF6
CD80: EC 0C       LDD    $C,X
CD82: 83 2A 16    SUBD   #$2A16
CD85: ED 0C       STD    $C,X
CD87: EC 0A       LDD    $A,X
CD89: C2 00       SBCB   #$00
CD8B: 82 00       SBCA   #$00
CD8D: ED 0A       STD    $A,X
CD8F: 26 02       BNE    $CD93
CD91: 6C 15       INC    -$B,X
CD93: 39          RTS
CD94: BD CD F6    JSR    $CDF6
CD97: BD CD A7    JSR    $CDA7
CD9A: BD 8C A7    JSR    $8CA7
CD9D: 24 07       BCC    $CDA6
CD9F: 4F          CLRA
CDA0: E3 19       ADDD   -$7,X
CDA2: ED 19       STD    -$7,X
CDA4: 6C 15       INC    -$B,X
CDA6: 39          RTS
CDA7: EC 0A       LDD    $A,X
CDA9: 10 83 FF FD CMPD   #$FFFD
CDAD: 2D 0F       BLT    $CDBE
CDAF: EC 0C       LDD    $C,X
CDB1: 83 2A 16    SUBD   #$2A16
CDB4: ED 0C       STD    $C,X
CDB6: EC 0A       LDD    $A,X
CDB8: C2 00       SBCB   #$00
CDBA: 82 00       SBCA   #$00
CDBC: ED 0A       STD    $A,X
CDBE: 39          RTS
CDBF: C6 06       LDB    #$06
CDC1: E7 08       STB    $8,X
CDC3: 6C 15       INC    -$B,X
CDC5: 6A 08       DEC    $8,X
CDC7: 10 26 C2 A9 LBNE   $9074
CDCB: 8D 0E       BSR    $CDDB
CDCD: C6 01       LDB    #$01
CDCF: E7 15       STB    -$B,X
CDD1: 6A 09       DEC    $9,X
CDD3: 26 05       BNE    $CDDA
CDD5: CC 02 00    LDD    #$0200
CDD8: ED 14       STD    -$C,X
CDDA: 39          RTS
CDDB: EC 16       LDD    -$A,X
CDDD: 93 A0       SUBD   $A0
CDDF: C3 00 40    ADDD   #$0040
CDE2: 10 83 00 80 CMPD   #$0080
CDE6: 25 0D       BCS    $CDF5
CDE8: C6 03       LDB    #$03
CDEA: EE 16       LDU    -$A,X
CDEC: 11 93 A0    CMPU   $A0
CDEF: 22 02       BHI    $CDF3
CDF1: C6 01       LDB    #$01
CDF3: E7 1E       STB    -$2,X
CDF5: 39          RTS
CDF6: E6 1E       LDB    -$2,X
CDF8: 58          ASLB
CDF9: 58          ASLB
CDFA: EE 1C       LDU    -$4,X
CDFC: 33 C5       LEAU   B,U
CDFE: EC 17       LDD    -$9,X
CE00: E3 C4       ADDD   ,U
CE02: ED 17       STD    -$9,X
CE04: E6 C4       LDB    ,U
CE06: 1D          SEX
CE07: A9 16       ADCA   -$A,X
CE09: A7 16       STA    -$A,X
CE0B: EC 1A       LDD    -$6,X
CE0D: E3 0B       ADDD   $B,X
CE0F: ED 1A       STD    -$6,X
CE11: E6 19       LDB    -$7,X
CE13: E9 0A       ADCB   $A,X
CE15: E7 19       STB    -$7,X
CE17: 7E 90 74    JMP    $9074

CE3A: E6 15       LDB    -$B,X
CE3C: 58          ASLB
CE3D: CE CE 42    LDU    #jump_table_ce42
CE40: 6E D5       JMP    [B,U]        ; [indirect_jump]

CE4C: CC 4E F6    LDD    #$4EF6
CE4F: ED 84       STD    ,X
CE51: 6F 02       CLR    $2,X
CE53: BD 90 74    JSR    $9074
CE56: EC 19       LDD    -$7,X
CE58: ED 88 18    STD    $18,X
CE5B: 4F          CLRA
CE5C: C6 50       LDB    #$50
CE5E: ED 88 16    STD    $16,X
CE61: A6 17       LDA    -$9,X
CE63: 97 E1       STA    $E1
CE65: 5F          CLRB
CE66: 96 A1       LDA    $A1
CE68: 90 E1       SUBA   $E1
CE6A: 2A 03       BPL    $CE6F
CE6C: 40          NEGA
CE6D: C6 01       LDB    #$01
CE6F: E7 88 1D    STB    $1D,X
CE72: 47          ASRA
CE73: C6 15       LDB    #$15
CE75: BD FE D8    JSR    $FED8
CE78: CE 4E E1    LDU    #$4EE1
CE7B: E6 C5       LDB    B,U
CE7D: 6D 88 1D    TST    $1D,X
CE80: 27 05       BEQ    $CE87
CE82: 43          COMA
CE83: 53          COMB
CE84: C3 00 01    ADDD   #$0001
CE87: ED 88 1B    STD    $1B,X
CE8A: 1F 89       TFR    A,B
CE8C: 1D          SEX
CE8D: A7 88 1A    STA    $1A,X
CE90: 6C 15       INC    -$B,X
CE92: 39          RTS
CE93: E6 88 16    LDB    $16,X
CE96: CB 06       ADDB   #$06
CE98: E7 88 16    STB    $16,X
CE9B: 2B 05       BMI    $CEA2
CE9D: 8D 54       BSR    $CEF3
CE9F: 20 04       BRA    $CEA5
CEA1: 39          RTS
CEA2: 6C 15       INC    -$B,X
CEA4: 39          RTS
CEA5: EC 17       LDD    -$9,X
CEA7: E3 88 1B    ADDD   $1B,X
CEAA: ED 17       STD    -$9,X
CEAC: E6 16       LDB    -$A,X
CEAE: E9 88 1A    ADCB   $1A,X
CEB1: E7 16       STB    -$A,X
CEB3: 39          RTS
CEB4: E6 88 16    LDB    $16,X
CEB7: CB 06       ADDB   #$06
CEB9: E7 88 16    STB    $16,X
CEBC: 25 18       BCS    $CED6
CEBE: C1 E0       CMPB   #$E0
CEC0: 25 05       BCS    $CEC7
CEC2: BD 8C A7    JSR    $8CA7
CEC5: 25 08       BCS    $CECF
CEC7: E6 88 16    LDB    $16,X
CECA: 8D 27       BSR    $CEF3
CECC: 20 D7       BRA    $CEA5
CECE: 39          RTS
CECF: 4F          CLRA
CED0: E3 19       ADDD   -$7,X
CED2: ED 19       STD    -$7,X
CED4: 20 05       BRA    $CEDB
CED6: EC 88 18    LDD    $18,X
CED9: ED 19       STD    -$7,X
CEDB: 6C 15       INC    -$B,X
CEDD: 39          RTS
CEDE: C6 06       LDB    #$06
CEE0: E7 08       STB    $8,X
CEE2: 6C 15       INC    -$B,X
CEE4: 6A 08       DEC    $8,X
CEE6: 10 26 C1 8A LBNE   $9074
CEEA: BD CD DB    JSR    $CDDB
CEED: CC 01 00    LDD    #$0100
CEF0: ED 14       STD    -$C,X
CEF2: 39          RTS
CEF3: CE 41 40    LDU    #$4140
CEF6: 4F          CLRA
CEF7: E6 CB       LDB    D,U
CEF9: 58          ASLB
CEFA: A6 88 17    LDA    $17,X
CEFD: 3D          MUL
CEFE: 1F 89       TFR    A,B
CF00: 4F          CLRA
CF01: E3 88 18    ADDD   $18,X
CF04: ED 19       STD    -$7,X
CF06: 39          RTS
CF07: 58          ASLB
CF08: CE CF 0D    LDU    #jump_table_cf0d
CF0B: 6E D5       JMP    [B,U]        ; [indirect_jump]

CF13: BD 79 B5    JSR    $79B5
CF16: CC 01 00    LDD    #$0100
CF19: ED 14       STD    -$C,X
CF1B: 39          RTS
CF1C: CC 03 00    LDD    #$0300
CF1F: ED 13       STD    -$D,X
CF21: E7 15       STB    -$B,X
CF23: 39          RTS
CF24: E6 05       LDB    $5,X
CF26: CE 00 30    LDU    #$0030
CF29: 6C C5       INC    B,U
CF2B: 4F          CLRA
CF2C: 5F          CLRB
CF2D: ED 10       STD    -$10,X
CF2F: ED 13       STD    -$D,X
CF31: E7 15       STB    -$B,X
CF33: 7E 8E 0C    JMP    $8E0C
CF36: EC 13       LDD    -$D,X
CF38: 48          ASLA
CF39: CE CF 3E    LDU    #jump_table_cf3e
CF3C: 6E D6       JMP    [A,U]        ; [indirect_jump]

CF46: 58          ASLB
CF47: CE CF 4C    LDU    #$CF4C
CF4A: 6E D5       JMP    [B,U]        ; [indirect_jump]

CF50: C6 01       LDB    #$01              
CF52: E7 1E       STB    -$2,X            
CF54: C6 03       LDB    #$03             
CF56: E7 1F       STB    -$1,X            
CF58: CE 4F 26    LDU    #$4F26        
CF5B: BD 90 6B    JSR    $906B         
CF5E: C6 0A       LDB    #$0A
CF60: E7 88 16    STB    $16,X
CF63: 4F          CLRA
CF64: A7 0C       STA    $C,X
CF66: A7 88 14    STA    $14,X
CF69: A7 0F       STA    $F,X
CF6B: A7 88 15    STA    $15,X
CF6E: CE 50 42    LDU    #$5042
CF71: D6 9A       LDB    $9A
CF73: C4 30       ANDB   #$30
CF75: 54          LSRB
CF76: 54          LSRB
CF77: 54          LSRB
CF78: EE C5       LDU    B,U
CF7A: E6 C0       LDB    ,U+
CF7C: E7 06       STB    $6,X
CF7E: EF 07       STU    $7,X
CF80: CE 50 0A    LDU    #$500A
CF83: D6 9A       LDB    $9A
CF85: C4 30       ANDB   #$30
CF87: 54          LSRB
CF88: 54          LSRB
CF89: 54          LSRB
CF8A: EE C5       LDU    B,U
CF8C: E6 C0       LDB    ,U+
CF8E: E7 09       STB    $9,X
CF90: EF 0A       STU    $A,X
CF92: CC 4F 16    LDD    #$4F16
CF95: ED 1C       STD    -$4,X
CF97: 6C 14       INC    -$C,X
CF99: 39          RTS
CF9A: A6 11       LDA    -$F,X
CF9C: 27 07       BEQ    $CFA5
CF9E: CC 01 00    LDD    #$0100
CFA1: ED 13       STD    -$D,X
CFA3: E7 15       STB    -$B,X
CFA5: 39          RTS
CFA6: A6 11       LDA    -$F,X
CFA8: 27 17       BEQ    $CFC1
CFAA: 58          ASLB
CFAB: CE CF C2    LDU    #jump_table_cfc2
CFAE: AD D5       JSR    [B,U]        ; [indirect_jump]
CFB0: E6 12       LDB    -$E,X
CFB2: 27 0D       BEQ    $CFC1
CFB4: CC 03 00    LDD    #$0300
CFB7: ED 14       STD    -$C,X
CFB9: 6F 12       CLR    -$E,X
CFBB: CE 4F F6    LDU    #$4FF6
CFBE: 7E 90 6B    JMP    $906B
CFC1: 39          RTS

CFCA: E6 15       LDB    -$B,X                                       
CFCC: 58          ASLB
CFCD: CE CF D2    LDU    #jump_table_cfd2
CFD0: 6E D5       JMP    [B,U]        ; [indirect_jump]

CFD6: 86 06       LDA    #$06
CFD8: A7 88 13    STA    $13,X
CFDB: BD 79 C9    JSR    $79C9
CFDE: 6C 15       INC    -$B,X
CFE0: 6A 88 13    DEC    $13,X
CFE3: 10 26 C0 8D LBNE   $9074
CFE7: 4F          CLRA
CFE8: 5F          CLRB
CFE9: ED 14       STD    -$C,X
CFEB: A7 12       STA    -$E,X
CFED: 39          RTS
CFEE: E6 15       LDB    -$B,X
CFF0: 58          ASLB
CFF1: CE CF F6    LDU    #jump_table_cff6
CFF4: 6E D5       JMP    [B,U]	; [indirect_jump]
CFFC: CE 4F 26    LDU    #$4F26                                      
CFFF: BD 90 6B    JSR    $906B                                       
D002: 6C 15       INC    -$B,X
D004: 39          RTS
D005: DC A2       LDD    $A2
D007: A3 19       SUBD   -$7,X
D009: C3 00 0A    ADDD   #$000A
D00C: 2B 0C       BMI    $D01A
D00E: 10 83 00 37 CMPD   #$0037
D012: 22 06       BHI    $D01A
D014: CC 01 00    LDD    #$0100
D017: ED 14       STD    -$C,X
D019: 39          RTS
D01A: EC 16       LDD    -$A,X
D01C: 93 A0       SUBD   $A0
D01E: C3 00 0A    ADDD   #$000A
D021: 10 83 00 14 CMPD   #$0014
D025: 22 0D       BHI    $D034
D027: EC 19       LDD    -$7,X
D029: 10 93 A2    CMPD   $A2
D02C: 2D 06       BLT    $D034
D02E: CC 02 00    LDD    #$0200
D031: ED 14       STD    -$C,X
D033: 39          RTS
D034: D6 21       LDB    $21
D036: 5C          INCB
D037: C4 1F       ANDB   #$1F
D039: 26 03       BNE    $D03E
D03B: BD 79 92    JSR    $7992
D03E: D6 21       LDB    $21
D040: 5C          INCB
D041: C4 0F       ANDB   #$0F
D043: 26 17       BNE    $D05C
D045: 8D 5D       BSR    $D0A4
D047: A6 0F       LDA    $F,X
D049: 27 11       BEQ    $D05C
D04B: A6 1E       LDA    -$2,X
D04D: A1 88 14    CMPA   $14,X
D050: 26 0A       BNE    $D05C
D052: 88 01       EORA   #$01
D054: A7 1E       STA    -$2,X
D056: CE 4F 26    LDU    #$4F26
D059: BD 90 6B    JSR    $906B
D05C: BD A4 27    JSR    $A427
D05F: BD 90 74    JSR    $9074
D062: 6A 09       DEC    $9,X
D064: 26 2D       BNE    $D093
D066: EE 0A       LDU    $A,X
D068: E6 C0       LDB    ,U+
D06A: 26 04       BNE    $D070
D06C: EE C4       LDU    ,U
D06E: E6 C0       LDB    ,U+
D070: EF 0A       STU    $A,X
D072: E7 09       STB    $9,X
D074: BD 68 F9    JSR    $68F9
D077: C4 01       ANDB   #$01
D079: 26 0C       BNE    $D087
D07B: CE 4F 8A    LDU    #$4F8A
D07E: BD 90 6B    JSR    $906B
D081: 86 64       LDA    #$64
D083: A7 0D       STA    $D,X
D085: 20 0A       BRA    $D091
D087: CE 4F 5E    LDU    #$4F5E
D08A: BD 90 6B    JSR    $906B
D08D: 86 46       LDA    #$46
D08F: A7 0D       STA    $D,X
D091: 6C 15       INC    -$B,X
D093: 39          RTS
D094: 6A 0D       DEC    $D,X
D096: 10 26 BF DA LBNE   $9074
D09A: BD 68 F9    JSR    $68F9
D09D: C4 01       ANDB   #$01
D09F: E7 1E       STB    -$2,X
D0A1: 6F 15       CLR    -$B,X
D0A3: 39          RTS
D0A4: EC 19       LDD    -$7,X
D0A6: 83 00 02    SUBD   #$0002
D0A9: ED 19       STD    -$7,X
D0AB: BD 8C A7    JSR    $8CA7
D0AE: 25 15       BCS    $D0C5
D0B0: A6 0F       LDA    $F,X
D0B2: 26 09       BNE    $D0BD
D0B4: A6 1E       LDA    -$2,X
D0B6: A7 88 14    STA    $14,X
D0B9: 86 01       LDA    #$01
D0BB: A7 0F       STA    $F,X
D0BD: EC 19       LDD    -$7,X
D0BF: C3 00 02    ADDD   #$0002
D0C2: ED 19       STD    -$7,X
D0C4: 39          RTS
D0C5: 4F          CLRA
D0C6: E3 19       ADDD   -$7,X
D0C8: ED 19       STD    -$7,X
D0CA: 6F 0F       CLR    $F,X
D0CC: 6F 88 15    CLR    $15,X
D0CF: 39          RTS
D0D0: E6 15       LDB    -$B,X
D0D2: 58          ASLB
D0D3: CE D0 D8    LDU    #jump_table_d0d8
D0D6: 6E D5       JMP    [B,U]	; [indirect_jump]

D0E2: BD D0 A4    JSR    $D0A4
D0E5: C6 00       LDB    #$00
D0E7: E7 1E       STB    -$2,X
D0E9: EC 16       LDD    -$A,X
D0EB: 10 93 A0    CMPD   $A0
D0EE: 2D 04       BLT    $D0F4
D0F0: C6 01       LDB    #$01
D0F2: E7 1E       STB    -$2,X
D0F4: CE 4F 26    LDU    #$4F26
D0F7: BD 90 6B    JSR    $906B
D0FA: 6C 15       INC    -$B,X
D0FC: 39          RTS
D0FD: DC A2       LDD    $A2
D0FF: A3 19       SUBD   -$7,X
D101: C3 00 0A    ADDD   #$000A
D104: 2B 35       BMI    $D13B
D106: 10 83 00 37 CMPD   #$0037
D10A: 22 2F       BHI    $D13B
D10C: A6 0F       LDA    $F,X
D10E: 26 28       BNE    $D138
D110: E6 1E       LDB    -$2,X
D112: 27 10       BEQ    $D124
D114: DC A0       LDD    $A0
D116: 83 00 28    SUBD   #$0028
D119: 10 A3 16    CMPD   -$A,X
D11C: 25 1A       BCS    $D138
D11E: C6 00       LDB    #$00
D120: E7 1E       STB    -$2,X
D122: 20 0E       BRA    $D132
D124: DC A0       LDD    $A0
D126: C3 00 28    ADDD   #$0028
D129: 10 A3 16    CMPD   -$A,X
D12C: 22 0A       BHI    $D138
D12E: C6 01       LDB    #$01
D130: E7 1E       STB    -$2,X
D132: CE 4F 26    LDU    #$4F26
D135: BD 90 6B    JSR    $906B
D138: 6C 15       INC    -$B,X
D13A: 39          RTS
D13B: 6F 88 15    CLR    $15,X
D13E: CC 00 00    LDD    #$0000
D141: ED 14       STD    -$C,X
D143: 39          RTS
D144: BD D0 A4    JSR    $D0A4
D147: A6 0F       LDA    $F,X
D149: 27 2E       BEQ    $D179
D14B: EC 16       LDD    -$A,X
D14D: 10 93 A0    CMPD   $A0
D150: 22 10       BHI    $D162
D152: A6 88 14    LDA    $14,X
D155: 27 31       BEQ    $D188
D157: E6 88 15    LDB    $15,X
D15A: 26 1D       BNE    $D179
D15C: A7 88 15    STA    $15,X
D15F: 4F          CLRA
D160: 20 0F       BRA    $D171
D162: A6 88 14    LDA    $14,X
D165: 26 21       BNE    $D188
D167: E6 88 15    LDB    $15,X
D16A: 26 0D       BNE    $D179
D16C: 86 01       LDA    #$01
D16E: A7 88 15    STA    $15,X
D171: A7 1E       STA    -$2,X
D173: CE 4F 26    LDU    #$4F26
D176: BD 90 6B    JSR    $906B
D179: E6 1E       LDB    -$2,X
D17B: CB 02       ADDB   #$02
D17D: E7 1E       STB    -$2,X
D17F: BD A4 27    JSR    $A427
D182: E6 1E       LDB    -$2,X
D184: C0 02       SUBB   #$02
D186: E7 1E       STB    -$2,X
D188: D6 21       LDB    $21
D18A: 5C          INCB
D18B: C4 0F       ANDB   #$0F
D18D: 26 03       BNE    $D192
D18F: BD 79 92    JSR    $7992
D192: BD 90 74    JSR    $9074
D195: BD 90 74    JSR    $9074
D198: BD 90 74    JSR    $9074
D19B: 6A 06       DEC    $6,X
D19D: 26 15       BNE    $D1B4
D19F: EE 07       LDU    $7,X
D1A1: E6 C0       LDB    ,U+
D1A3: 2A 04       BPL    $D1A9
D1A5: EE C4       LDU    ,U
D1A7: C4 7F       ANDB   #$7F
D1A9: EF 07       STU    $7,X
D1AB: E7 06       STB    $6,X
D1AD: C6 0A       LDB    #$0A
D1AF: E7 0E       STB    $E,X
D1B1: 6C 15       INC    -$B,X
D1B3: 39          RTS
D1B4: 6A 15       DEC    -$B,X
D1B6: 39          RTS
D1B7: 6A 0E       DEC    $E,X
D1B9: 26 0C       BNE    $D1C7
D1BB: 86 08       LDA    #$08
D1BD: A7 0E       STA    $E,X
D1BF: CE 4F B6    LDU    #$4FB6
D1C2: BD 90 6B    JSR    $906B
D1C5: 6C 15       INC    -$B,X
D1C7: 39          RTS
D1C8: 6A 0E       DEC    $E,X
D1CA: 10 26 BE A6 LBNE   $9074
D1CE: 8D 2D       BSR    $D1FD
D1D0: C6 01       LDB    #$01
D1D2: E7 15       STB    -$B,X
D1D4: 39          RTS
D1D5: E6 15       LDB    -$B,X
D1D7: 58          ASLB
D1D8: CE D1 DD    LDU    #jump_table_d1dd
D1DB: 6E D5       JMP    [B,U]	; [indirect_jump]

D1E5: C6 00       LDB    #$00
D1E7: E7 1E       STB    -$2,X
D1E9: EC 16       LDD    -$A,X
D1EB: 10 93 A0    CMPD   $A0
D1EE: 2D 04       BLT    $D1F4
D1F0: C6 01       LDB    #$01
D1F2: E7 1E       STB    -$2,X
D1F4: CE 4F CA    LDU    #$4FCA
D1F7: BD 90 6B    JSR    $906B
D1FA: 6C 15       INC    -$B,X
D1FC: 39          RTS
D1FD: D6 A7       LDB    $A7
D1FF: 27 43       BEQ    $D244
D201: BD 8E 2E    JSR    $8E2E
D204: E6 14       LDB    -$C,X
D206: C1 01       CMPB   #$01
D208: 26 1E       BNE    $D228
D20A: E6 1E       LDB    -$2,X
D20C: 26 09       BNE    $D217
D20E: EC 16       LDD    -$A,X
D210: C3 00 10    ADDD   #$0010
D213: ED 36       STD    -$A,Y
D215: 20 07       BRA    $D21E
D217: EC 16       LDD    -$A,X
D219: 83 00 10    SUBD   #$0010
D21C: ED 36       STD    -$A,Y
D21E: EC 19       LDD    -$7,X
D220: ED 39       STD    -$7,Y
D222: E6 1E       LDB    -$2,X
D224: E7 3E       STB    -$2,Y
D226: 20 0F       BRA    $D237
D228: EC 16       LDD    -$A,X
D22A: ED 36       STD    -$A,Y
D22C: EC 19       LDD    -$7,X
D22E: 83 00 08    SUBD   #$0008
D231: ED 39       STD    -$7,Y
D233: C6 02       LDB    #$02
D235: E7 3E       STB    -$2,Y
D237: 4F          CLRA
D238: 5F          CLRB
D239: ED 33       STD    -$D,Y
D23B: E7 35       STB    -$B,Y
D23D: 4C          INCA
D23E: ED 30       STD    -$10,Y
D240: C6 03       LDB    #$03
D242: E7 25       STB    $5,Y
D244: 39          RTS
D245: DC A2       LDD    $A2
D247: A3 19       SUBD   -$7,X
D249: C3 00 0A    ADDD   #$000A
D24C: 2B 0C       BMI    $D25A
D24E: 10 83 00 37 CMPD   #$0037
D252: 22 06       BHI    $D25A
D254: CC 01 00    LDD    #$0100
D257: ED 14       STD    -$C,X
D259: 39          RTS
D25A: EC 16       LDD    -$A,X
D25C: 93 A0       SUBD   $A0
D25E: C3 00 0A    ADDD   #$000A
D261: 10 83 00 14 CMPD   #$0014
D265: 22 14       BHI    $D27B
D267: EC 19       LDD    -$7,X
D269: 10 93 A2    CMPD   $A2
D26C: 2D 0D       BLT    $D27B
D26E: 86 1E       LDA    #$1E
D270: A7 0E       STA    $E,X
D272: CE 4F CA    LDU    #$4FCA
D275: BD 90 6B    JSR    $906B
D278: 6C 15       INC    -$B,X
D27A: 39          RTS
D27B: CC 00 00    LDD    #$0000
D27E: ED 14       STD    -$C,X
D280: 39          RTS
D281: 86 14       LDA    #$14
D283: A1 0E       CMPA   $E,X
D285: 26 03       BNE    $D28A
D287: BD D1 FD    JSR    $D1FD
D28A: 6A 0E       DEC    $E,X
D28C: 10 26 BD E4 LBNE   $9074
D290: 86 14       LDA    #$14
D292: A7 0C       STA    $C,X
D294: 6C 15       INC    -$B,X
D296: 39          RTS
D297: 6A 0C       DEC    $C,X
D299: 26 04       BNE    $D29F
D29B: 86 01       LDA    #$01
D29D: A7 15       STA    -$B,X
D29F: 39          RTS
D2A0: 58          ASLB
D2A1: CE D2 A6    LDU    #jump_table_d2a6
D2A4: 6E D5       JMP    [B,U]	; [indirect_jump]

D2AC: BD 79 CE    JSR    $79CE
D2AF: C6 70       LDB    #$70
D2B1: E7 0A       STB    $A,X
D2B3: 6C 14       INC    -$C,X
D2B5: 39          RTS
D2B6: C6 02       LDB    #$02
D2B8: E7 1F       STB    -$1,X
D2BA: CC E9 28    LDD    #$E928
D2BD: ED 03       STD    $3,X
D2BF: 6A 0A       DEC    $A,X
D2C1: 26 07       BNE    $D2CA
D2C3: CC 03 00    LDD    #$0300
D2C6: ED 13       STD    -$D,X
D2C8: E7 15       STB    -$B,X
D2CA: 39          RTS
D2CB: E6 05       LDB    $5,X
D2CD: CE 00 30    LDU    #$0030
D2D0: 6C C5       INC    B,U
D2D2: 4F          CLRA
D2D3: 5F          CLRB
D2D4: ED 10       STD    -$10,X
D2D6: ED 13       STD    -$D,X
D2D8: E7 15       STB    -$B,X
D2DA: 7E 8E 0C    JMP    $8E0C
D2DD: EC 13       LDD    -$D,X
D2DF: 48          ASLA
D2E0: CE D2 E5    LDU    #jump_table_d2e5
D2E3: 6E D6       JMP    [A,U]	; [indirect_jump]

D2ED: 58          ASLB
D2EE: CE D2 F3    LDU    #$D2F3
D2F1: 6E D5       JMP    [B,U]	; [indirect_jump]

D2F7: E6 15       LDB    -$B,X
D2F9: 58          ASLB
D2FA: CE D2 FF    LDU    #jump_table_d2ff
D2FD: 6E D5       JMP    [B,U]	; [indirect_jump]

D307: C6 02       LDB    #$02
D309: E7 10       STB    -$10,X
D30B: C6 00       LDB    #$00
D30D: E7 1F       STB    -$1,X
D30F: CC A6 31    LDD    #$A631
D312: ED 03       STD    $3,X
D314: 6C 15       INC    -$B,X
D316: EC 19       LDD    -$7,X
D318: 83 00 02    SUBD   #$0002
D31B: ED 19       STD    -$7,X
D31D: BD 8C A7    JSR    $8CA7
D320: 24 24       BCC    $D346
D322: 4F          CLRA
D323: E3 19       ADDD   -$7,X
D325: ED 19       STD    -$7,X
D327: E6 12       LDB    -$E,X
D329: 27 08       BEQ    $D333
D32B: CC 01 00    LDD    #$0100
D32E: ED 13       STD    -$D,X
D330: E7 15       STB    -$B,X
D332: 39          RTS
D333: CE D3 47    LDU    #$D347
D336: D6 21       LDB    $21
D338: DB E0       ADDB   $E0
D33A: C4 0F       ANDB   #$0F
D33C: E6 C5       LDB    B,U
D33E: E7 07       STB    $7,X
D340: C6 B4       LDB    #$B4
D342: E7 0A       STB    $A,X
D344: 6C 15       INC    -$B,X
D346: 39          RTS

D357: 6A 07       DEC    $7,X
D359: 26 02       BNE    $D35D
D35B: 6C 15       INC    -$B,X
D35D: 39          RTS
D35E: 6F 1E       CLR    -$2,X
D360: EC 16       LDD    -$A,X
D362: 10 93 A0    CMPD   $A0
D365: 2D 04       BLT    $D36B
D367: C6 01       LDB    #$01
D369: E7 1E       STB    -$2,X
D36B: C6 00       LDB    #$00
D36D: E7 1F       STB    -$1,X
D36F: CE 50 7E    LDU    #$507E
D372: BD 90 6B    JSR    $906B
D375: 6C 14       INC    -$C,X
D377: 6F 15       CLR    -$B,X
D379: 39          RTS
D37A: E6 15       LDB    -$B,X
D37C: 58          ASLB
D37D: CE D3 82    LDU    #jump_table_d382
D380: 6E D5       JMP    [B,U]	; [indirect_jump]

D386: C6 02       LDB    #$02
D388: E7 10       STB    -$10,X
D38A: EC 19       LDD    -$7,X
D38C: 83 00 02    SUBD   #$0002
D38F: ED 19       STD    -$7,X
D391: BD 8C A7    JSR    $8CA7
D394: 24 18       BCC    $D3AE
D396: 1D          SEX
D397: E3 19       ADDD   -$7,X
D399: ED 19       STD    -$7,X
D39B: C6 07       LDB    #$07
D39D: E7 06       STB    $6,X
D39F: CE 50 76    LDU    #$5076
D3A2: E6 C0       LDB    ,U+
D3A4: E7 1F       STB    -$1,X
D3A6: EF 08       STU    $8,X
D3A8: BD 79 BA    JSR    $79BA
D3AB: 6C 15       INC    -$B,X
D3AD: 39          RTS
D3AE: CC 03 00    LDD    #$0300
D3B1: ED 13       STD    -$D,X
D3B3: 39          RTS
D3B4: E6 02       LDB    $2,X
D3B6: 26 15       BNE    $D3CD
D3B8: EE 08       LDU    $8,X
D3BA: E6 C0       LDB    ,U+
D3BC: EF 08       STU    $8,X
D3BE: E7 1F       STB    -$1,X
D3C0: 6A 06       DEC    $6,X
D3C2: 26 09       BNE    $D3CD
D3C4: CC 01 00    LDD    #$0100
D3C7: ED 13       STD    -$D,X
D3C9: E7 15       STB    -$B,X
D3CB: A7 10       STA    -$10,X
D3CD: 7E 90 74    JMP    $9074
D3D0: 58          ASLB
D3D1: CE D3 D9    LDU    #jump_table_d3d9
D3D4: AD D5       JSR    [B,U]	; [indirect_jump]
D3D6: 7E 8F 62    JMP    $8F62

D3DD: E6 15       LDB    -$B,X
D3DF: 58          ASLB
D3E0: CE D3 E5    LDU    #$D3E5
D3E3: 6E D5       JMP    [B,U]	; [indirect_jump]

D3EB: C6 01       LDB    #$01
D3ED: E7 10       STB    -$10,X
D3EF: C6 03       LDB    #$03
D3F1: E7 1F       STB    -$1,X
D3F3: 6F 1E       CLR    -$2,X
D3F5: EC 16       LDD    -$A,X
D3F7: 10 93 A0    CMPD   $A0
D3FA: 2D 04       BLT    $D400
D3FC: C6 01       LDB    #$01
D3FE: E7 1E       STB    -$2,X
D400: CE 51 3E    LDU    #$513E
D403: BD 90 6B    JSR    $906B
D406: CE D4 2E    LDU    #$D42E
D409: D6 21       LDB    $21
D40B: DB E0       ADDB   $E0
D40D: C4 07       ANDB   #$07
D40F: A6 C5       LDA    B,U
D411: A7 07       STA    $7,X
D413: CE 50 EE    LDU    #$50EE
D416: D6 9A       LDB    $9A
D418: C4 30       ANDB   #$30
D41A: 54          LSRB
D41B: 54          LSRB
D41C: 33 C5       LEAU   B,U
D41E: E6 0B       LDB    $B,X
D420: 5C          INCB
D421: C4 03       ANDB   #$03
D423: 26 02       BNE    $D427
D425: 33 42       LEAU   $2,U
D427: EC C4       LDD    ,U
D429: ED 1C       STD    -$4,X
D42B: 6C 15       INC    -$B,X
D42D: 39          RTS
D42E: 28 5A       BVC    $D48A
D430: 6E 50       JMP    -$10,U
D432: 46          RORA
D433: 64 5A       LSR    -$6,U
D435: 32 BD A4 27 LEAS   [$7860,PCR]
D439: BD 90 74    JSR    $9074
D43C: EC 19       LDD    -$7,X
D43E: 83 00 02    SUBD   #$0002
D441: ED 19       STD    -$7,X
D443: BD 8C A7    JSR    $8CA7
D446: 24 09       BCC    $D451
D448: 1D          SEX
D449: E3 19       ADDD   -$7,X
D44B: ED 19       STD    -$7,X
D44D: 8D 08       BSR    $D457
D44F: 20 1E       BRA    $D46F
D451: CC 01 00    LDD    #$0100
D454: ED 14       STD    -$C,X
D456: 39          RTS
D457: E6 1E       LDB    -$2,X
D459: 27 0A       BEQ    $D465
D45B: EC 16       LDD    -$A,X
D45D: 10 93 A0    CMPD   $A0
D460: 22 0C       BHI    $D46E
D462: 6C 15       INC    -$B,X
D464: 39          RTS
D465: EC 16       LDD    -$A,X
D467: 10 93 A0    CMPD   $A0
D46A: 23 02       BLS    $D46E
D46C: 6C 15       INC    -$B,X
D46E: 39          RTS
D46F: D6 21       LDB    $21
D471: 54          LSRB
D472: 24 09       BCC    $D47D
D474: 6A 0A       DEC    $A,X
D476: 26 05       BNE    $D47D
D478: CC 01 00    LDD    #$0100
D47B: ED 14       STD    -$C,X
D47D: 39          RTS
D47E: BD A4 27    JSR    $A427
D481: 8D 0C       BSR    $D48F
D483: 6A 07       DEC    $7,X
D485: 10 26 BB EB LBNE   $9074
D489: CC 01 00    LDD    #$0100
D48C: ED 14       STD    -$C,X
D48E: 39          RTS
D48F: EC 19       LDD    -$7,X
D491: 83 00 02    SUBD   #$0002
D494: ED 19       STD    -$7,X
D496: BD 8C A7    JSR    $8CA7
D499: 24 06       BCC    $D4A1
D49B: 1D          SEX
D49C: E3 19       ADDD   -$7,X
D49E: ED 19       STD    -$7,X
D4A0: 39          RTS
D4A1: CC 01 00    LDD    #$0100
D4A4: ED 14       STD    -$C,X
D4A6: 39          RTS
D4A7: E6 15       LDB    -$B,X
D4A9: 58          ASLB
D4AA: CE D4 AF    LDU    #jump_table_d4af
D4AD: 6E D5       JMP    [B,U]	; [indirect_jump]

D4B3: C6 02       LDB    #$02
D4B5: E7 10       STB    -$10,X
D4B7: CE 51 76    LDU    #$5176
D4BA: BD 90 6B    JSR    $906B
D4BD: CE 51 7A    LDU    #$517A
D4C0: E6 C0       LDB    ,U+
D4C2: EF 08       STU    $8,X
D4C4: BD 8E BF    JSR    $8EBF
D4C7: C6 06       LDB    #$06
D4C9: E7 06       STB    $6,X
D4CB: 6C 15       INC    -$B,X
D4CD: 39          RTS
D4CE: E6 02       LDB    $2,X
D4D0: 26 14       BNE    $D4E6
D4D2: EE 08       LDU    $8,X
D4D4: E6 C0       LDB    ,U+
D4D6: EF 08       STU    $8,X
D4D8: BD 8E BF    JSR    $8EBF
D4DB: 6A 06       DEC    $6,X
D4DD: 26 07       BNE    $D4E6
D4DF: CC 03 00    LDD    #$0300
D4E2: ED 13       STD    -$D,X
D4E4: E7 15       STB    -$B,X
D4E6: 7E 90 74    JMP    $9074
D4E9: 58          ASLB
D4EA: CE D4 EF    LDU    #jump_table_d4ef
D4ED: 6E D5       JMP    [B,U]	; [indirect_jump]

D4F5: BD 79 CE    JSR    $79CE
D4F8: CC 01 00    LDD    #$0100
D4FB: ED 14       STD    -$C,X
D4FD: 39          RTS
D4FE: CC 03 00    LDD    #$0300
D501: ED 13       STD    -$D,X
D503: E7 15       STB    -$B,X
D505: 39          RTS
D506: E6 05       LDB    $5,X
D508: CE 00 30    LDU    #$0030
D50B: 6C C5       INC    B,U
D50D: 4F          CLRA
D50E: 5F          CLRB
D50F: ED 10       STD    -$10,X
D511: ED 13       STD    -$D,X
D513: E7 15       STB    -$B,X
D515: 7E 8E 0C    JMP    $8E0C
D518: EC 13       LDD    -$D,X
D51A: 48          ASLA
D51B: CE D5 20    LDU    #jump_table_d520
D51E: 6E D6       JMP    [A,U]	; [indirect_jump]

D528: A6 12       LDA    -$E,X
D52A: 48          ASLA
D52B: CE D5 30    LDU    #$D530
D52E: 6E D6       JMP    [A,U]	; [indirect_jump]

D536: 58          ASLB
D537: CE D5 3C    LDU    #jump_table_d53c
D53A: 6E D5       JMP    [B,U]	; [indirect_jump]

D542: C6 00       LDB    #$00
D544: E7 1E       STB    -$2,X
D546: E7 88 14    STB    $14,X
D549: E7 0D       STB    $D,X
D54B: EC 16       LDD    -$A,X
D54D: 10 93 A0    CMPD   $A0
D550: 2D 09       BLT    $D55B
D552: C6 08       LDB    #$08
D554: E7 1E       STB    -$2,X
D556: C6 01       LDB    #$01
D558: E7 88 14    STB    $14,X
D55B: C6 03       LDB    #$03
D55D: E7 1F       STB    -$1,X
D55F: CE 51 82    LDU    #$5182
D562: E6 88 14    LDB    $14,X
D565: 58          ASLB
D566: EE C5       LDU    B,U
D568: EF 84       STU    ,X
D56A: EF 03       STU    $3,X
D56C: 6F 02       CLR    $2,X
D56E: CC 51 B6    LDD    #$51B6
D571: ED 1C       STD    -$4,X
D573: CE D7 89    LDU    #$D789
D576: EC C1       LDD    ,U++
D578: A7 0A       STA    $A,X
D57A: E7 1E       STB    -$2,X
D57C: EF 08       STU    $8,X
D57E: CE D5 A5    LDU    #$D5A5
D581: D6 9A       LDB    $9A
D583: 54          LSRB
D584: 54          LSRB
D585: 54          LSRB
D586: 54          LSRB
D587: E6 C5       LDB    B,U
D589: E7 0E       STB    $E,X
D58B: 4F          CLRA
D58C: 5F          CLRB
D58D: ED 88 15    STD    $15,X
D590: A7 88 11    STA    $11,X
D593: A7 88 13    STA    $13,X
D596: 86 06       LDA    #$06
D598: A7 88 10    STA    $10,X
D59B: EC 19       LDD    -$7,X
D59D: ED 88 19    STD    $19,X
D5A0: 6C 14       INC    -$C,X
D5A2: 6F 15       CLR    -$B,X
D5A4: 39          RTS

D5B1: 5A          DECB
D5B2: D7 E1       STB    $E1
D5B4: 4F          CLRA
D5B5: 5F          CLRB
D5B6: ED 88 1C    STD    $1C,X
D5B9: 33 84       LEAU   ,X
D5BB: DF E2       STU    $E2
D5BD: BD 8D FC    JSR    $8DFC
D5C0: DE E2       LDU    $E2
D5C2: 10 AF C8 1E STY    $1E,U
D5C6: D6 E1       LDB    $E1
D5C8: C1 07       CMPB   #$07
D5CA: 27 0D       BEQ    $D5D9
D5CC: EC 56       LDD    -$A,U
D5CE: C3 00 0E    ADDD   #$000E
D5D1: ED 36       STD    -$A,Y
D5D3: EC 59       LDD    -$7,U
D5D5: ED 39       STD    -$7,Y
D5D7: 20 0E       BRA    $D5E7
D5D9: EC 56       LDD    -$A,U
D5DB: C3 00 14    ADDD   #$0014
D5DE: ED 36       STD    -$A,Y
D5E0: EC 59       LDD    -$7,U
D5E2: 83 00 03    SUBD   #$0003
D5E5: ED 39       STD    -$7,Y
D5E7: 4F          CLRA
D5E8: 5F          CLRB
D5E9: ED 33       STD    -$D,Y
D5EB: E7 35       STB    -$B,Y
D5ED: 4C          INCA
D5EE: ED 30       STD    -$10,Y
D5F0: E6 05       LDB    $5,X
D5F2: E7 25       STB    $5,Y
D5F4: A7 32       STA    -$E,Y
D5F6: EF A8 1C    STU    $1C,Y
D5F9: 33 A4       LEAU   ,Y
D5FB: 0A E1       DEC    $E1
D5FD: 26 BC       BNE    $D5BB
D5FF: DF E2       STU    $E2
D601: BD 8D FC    JSR    $8DFC
D604: DE E2       LDU    $E2
D606: 10 AF C8 1E STY    $1E,U
D60A: EF A8 1C    STU    $1C,Y
D60D: 4F          CLRA
D60E: 5F          CLRB
D60F: ED A8 1E    STD    $1E,Y
D612: E6 05       LDB    $5,X
D614: E7 25       STB    $5,Y
D616: C6 02       LDB    #$02
D618: E7 32       STB    -$E,Y
D61A: 5F          CLRB
D61B: ED 33       STD    -$D,Y
D61D: E7 35       STB    -$B,Y
D61F: 4C          INCA
D620: ED 30       STD    -$10,Y
D622: EC 56       LDD    -$A,U
D624: C3 00 0C    ADDD   #$000C
D627: ED 36       STD    -$A,Y
D629: EC 59       LDD    -$7,U
D62B: C3 00 02    ADDD   #$0002
D62E: ED 39       STD    -$7,Y
D630: 6C 14       INC    -$C,X
D632: 39          RTS
D633: 86 08       LDA    #$08
D635: C6 09       LDB    #$09
D637: 33 84       LEAU   ,X
D639: A7 C8 1B    STA    $1B,U
D63C: 4A          DECA
D63D: EE C8 1E    LDU    $1E,U
D640: 5A          DECB
D641: 26 F6       BNE    $D639
D643: CC 01 00    LDD    #$0100
D646: ED 13       STD    -$D,X
D648: E7 15       STB    -$B,X
D64A: 39          RTS
D64B: 6F 1E       CLR    -$2,X
D64D: EC 16       LDD    -$A,X
D64F: 10 93 A0    CMPD   $A0
D652: 2D 04       BLT    $D658
D654: C6 08       LDB    #$08
D656: E7 1E       STB    -$2,X
D658: C6 01       LDB    #$01
D65A: E7 1F       STB    -$1,X
D65C: CE D6 88    LDU    #$D688
D65F: EE C4       LDU    ,U
D661: EF 84       STU    ,X
D663: EF 03       STU    $3,X
D665: 6F 02       CLR    $2,X
D667: CC 51 B6    LDD    #$51B6
D66A: ED 1C       STD    -$4,X
D66C: 4F          CLRA
D66D: 5F          CLRB
D66E: ED 06       STD    $6,X
D670: A7 88 18    STA    $18,X
D673: A7 88 13    STA    $13,X
D676: A7 88 15    STA    $15,X
D679: 86 01       LDA    #$01
D67B: A7 88 10    STA    $10,X
D67E: A7 0D       STA    $D,X
D680: CC 01 00    LDD    #$0100
D683: ED 13       STD    -$D,X
D685: E7 15       STB    -$B,X
D687: 39          RTS

D690: 6F 1E       CLR    -$2,X
D692: EC 16       LDD    -$A,X
D694: 10 93 A0    CMPD   $A0
D697: 2D 04       BLT    $D69D
D699: C6 08       LDB    #$08
D69B: E7 1E       STB    -$2,X
D69D: C6 00       LDB    #$00
D69F: E7 1F       STB    -$1,X
D6A1: CE D6 CF    LDU    #$D6CF
D6A4: EE C4       LDU    ,U
D6A6: EF 84       STU    ,X
D6A8: EF 03       STU    $3,X
D6AA: 6F 02       CLR    $2,X
D6AC: CC 51 B6    LDD    #$51B6
D6AF: ED 1C       STD    -$4,X
D6B1: 4F          CLRA
D6B2: 5F          CLRB
D6B3: ED 06       STD    $6,X
D6B5: A7 88 18    STA    $18,X
D6B8: A7 88 13    STA    $13,X
D6BB: A7 88 15    STA    $15,X
D6BE: 86 01       LDA    #$01
D6C0: A7 88 10    STA    $10,X
D6C3: 86 02       LDA    #$02
D6C5: A7 0D       STA    $D,X
D6C7: CC 01 00    LDD    #$0100
D6CA: ED 13       STD    -$D,X
D6CC: E7 15       STB    -$B,X
D6CE: 39          RTS
D6CF: D6 D1       LDB    $D1
D6D1: 5F          CLRB
D6D2: A0 83       SUBA   ,--X
D6D4: D6 D1       LDB    $D1
D6D6: A6 0D       LDA    $D,X
D6D8: 48          ASLA
D6D9: CE D7 06    LDU    #jump_table_d706
D6DC: AD D6       JSR    [A,U]	; [indirect_jump]
D6DE: D6 72       LDB    starting_level_0072
D6E0: C1 02       CMPB   #$02
D6E2: 27 21       BEQ    $D705
D6E4: EC 16       LDD    -$A,X
D6E6: 93 9C       SUBD   $9C
D6E8: C3 01 80    ADDD   #$0180
D6EB: 10 83 04 00 CMPD   #$0400
D6EF: 22 0D       BHI    $D6FE
D6F1: EC 19       LDD    -$7,X
D6F3: 93 9E       SUBD   $9E
D6F5: C3 01 80    ADDD   #$0180
D6F8: 10 83 04 00 CMPD   #$0400
D6FC: 23 07       BLS    $D705
D6FE: CC 03 00    LDD    #$0300
D701: ED 13       STD    -$D,X
D703: E7 15       STB    -$B,X
D705: 39          RTS

D70C: 58          ASLB
D70D: CE D7 12    LDU    #jump_table_d712
D710: 6E D5       JMP    [B,U]	; [indirect_jump]

D716: A6 15       LDA    -$B,X
D718: 48          ASLA
D719: CE D7 1E    LDU    #$D71E
D71C: 6E D6       JMP    [A,U]	; [indirect_jump]

D728: 10 AE 88 1E LDY    $1E,X
D72C: A6 0A       LDA    $A,X
D72E: A7 27       STA    $7,Y
D730: E6 1E       LDB    -$2,X
D732: E7 26       STB    $6,Y
D734: 86 01       LDA    #$01
D736: A7 A8 18    STA    $18,Y
D739: 6C 15       INC    -$B,X
D73B: 39          RTS
D73C: 39          RTS
D73D: 6A 0A       DEC    $A,X
D73F: 26 FB       BNE    $D73C
D741: EE 08       LDU    $8,X
D743: EC C1       LDD    ,U++
D745: 27 16       BEQ    $D75D
D747: A7 0A       STA    $A,X
D749: E7 1E       STB    -$2,X
D74B: EF 08       STU    $8,X
D74D: 10 AE 88 1E LDY    $1E,X
D751: A7 27       STA    $7,Y
D753: E7 26       STB    $6,Y
D755: 86 01       LDA    #$01
D757: A7 A8 18    STA    $18,Y
D75A: 7E A4 27    JMP    $A427
D75D: C6 09       LDB    #$09
D75F: 33 84       LEAU   ,X
D761: 86 01       LDA    #$01
D763: A7 C8 13    STA    $13,U
D766: EE C8 1E    LDU    $1E,U
D769: 5A          DECB
D76A: 26 F5       BNE    $D761
D76C: CE 52 16    LDU    #$5216
D76F: EE C4       LDU    ,U
D771: EC C1       LDD    ,U++
D773: A7 0A       STA    $A,X
D775: E7 1E       STB    -$2,X
D777: EF 08       STU    $8,X
D779: 10 AE 88 1E LDY    $1E,X
D77D: A7 27       STA    $7,Y
D77F: E7 26       STB    $6,Y
D781: 86 01       LDA    #$01
D783: A7 A8 18    STA    $18,Y
D786: 6C 15       INC    -$B,X
D788: 39          RTS
D789: 0A 09       DEC    $09
D78B: 0A 0F       DEC    $0F
D78D: 0A 00       DEC    $00
D78F: 0A 01       DEC    $01
D791: 0A 07       DEC    $07
D793: 0A 08       DEC    $08
D795: 00 00       NEG    $00
D797: CE D7 B5    LDU    #$D7B5
D79A: 96 72       LDA    starting_level_0072
D79C: 81 05       CMPA   #$05
D79E: 27 03       BEQ    $D7A3
D7A0: CE D7 B1    LDU    #$D7B1
D7A3: D6 21       LDB    $21
D7A5: DB E0       ADDB   $E0
D7A7: C4 03       ANDB   #$03
D7A9: E6 C5       LDB    B,U
D7AB: E7 88 11    STB    $11,X
D7AE: 6C 15       INC    -$B,X
D7B0: 39          RTS
D7B1: 03 02       COM    $02
D7B3: 03 02       COM    $02
D7B5: 05 02       LSR    $02
D7B7: 05 04       LSR    $04
D7B9: E6 11       LDB    -$F,X
D7BB: 27 02       BEQ    $D7BF
D7BD: 6C 15       INC    -$B,X
D7BF: 39          RTS
D7C0: DC A2       LDD    $A2
D7C2: C3 00 20    ADDD   #$0020
D7C5: A3 19       SUBD   -$7,X
D7C7: 2B 24       BMI    $D7ED
D7C9: C1 05       CMPB   #$05
D7CB: D6 21       LDB    $21
D7CD: 5C          INCB
D7CE: C4 0F       ANDB   #$0F
D7D0: 26 1B       BNE    $D7ED
D7D2: 6A 88 11    DEC    $11,X
D7D5: 26 16       BNE    $D7ED
D7D7: CC 01 00    LDD    #$0100
D7DA: ED 14       STD    -$C,X
D7DC: 0C B5       INC    $B5
D7DE: C6 09       LDB    #$09
D7E0: 33 84       LEAU   ,X
D7E2: 6F C8 13    CLR    $13,U
D7E5: EE C8 1E    LDU    $1E,U
D7E8: 27 03       BEQ    $D7ED
D7EA: 5A          DECB
D7EB: 26 F5       BNE    $D7E2
D7ED: 39          RTS
D7EE: D6 21       LDB    $21
D7F0: 5C          INCB
D7F1: C4 7F       ANDB   #$7F
D7F3: 26 12       BNE    $D807
D7F5: CE 51 86    LDU    #$5186
D7F8: E6 88 14    LDB    $14,X
D7FB: 58          ASLB
D7FC: EE C5       LDU    B,U
D7FE: EF 03       STU    $3,X
D800: C6 0A       LDB    #$0A
D802: E7 02       STB    $2,X
D804: BD 79 EC    JSR    $79EC
D807: BD 90 74    JSR    $9074
D80A: BD 68 F9    JSR    $68F9
D80D: D7 EB       STB    $EB
D80F: 8D 07       BSR    $D818
D811: BD D9 81    JSR    bankswitch_copy_d981
D814: 7E A4 27    JMP    $A427
D817: 39          RTS
D818: 6A 0A       DEC    $A,X
D81A: 26 FB       BNE    $D817
D81C: 96 72       LDA    starting_level_0072
D81E: 81 05       CMPA   #$05
D820: 27 42       BEQ    $D864
D822: D6 EB       LDB    $EB
D824: C4 0F       ANDB   #$0F
D826: E1 0E       CMPB   $E,X
D828: 22 3A       BHI    $D864
D82A: E6 88 14    LDB    $14,X
D82D: 27 2C       BEQ    $D85B
D82F: EC 16       LDD    -$A,X
D831: 93 A0       SUBD   $A0
D833: 83 00 18    SUBD   #$0018
D836: 2B 2C       BMI    $D864
D838: BD 8F E4    JSR    $8FE4
D83B: C1 04       CMPB   #$04
D83D: 27 25       BEQ    $D864
D83F: D7 E3       STB    $E3
D841: DC 9E       LDD    $9E
D843: C3 00 60    ADDD   #$0060
D846: DD E8       STD    $E8
D848: 86 28       LDA    #$28
D84A: 10 AE 19    LDY    -$7,X
D84D: 10 9C E8    CMPY   $E8
D850: 22 02       BHI    $D854
D852: 86 12       LDA    #$12
D854: D6 E3       LDB    $E3
D856: EE 08       LDU    $8,X
D858: 7E D8 CC    JMP    $D8CC
D85B: DC A0       LDD    $A0
D85D: A3 16       SUBD   -$A,X
D85F: 83 00 18    SUBD   #$0018
D862: 2A D4       BPL    $D838
D864: EC 16       LDD    -$A,X
D866: 10 93 A0    CMPD   $A0
D869: 22 07       BHI    $D872
D86B: E6 88 14    LDB    $14,X
D86E: 26 07       BNE    $D877
D870: 20 76       BRA    $D8E8
D872: E6 88 14    LDB    $14,X
D875: 26 71       BNE    $D8E8
D877: DC 5A       LDD    $5A
D879: C3 01 00    ADDD   #$0100
D87C: 10 A3 16    CMPD   -$A,X
D87F: 23 0D       BLS    $D88E
D881: EC 16       LDD    -$A,X
D883: 93 A0       SUBD   $A0
D885: C3 00 5E    ADDD   #$005E
D888: 10 83 00 BC CMPD   #$00BC
D88C: 25 5A       BCS    $D8E8
D88E: DC 9E       LDD    $9E
D890: C3 00 80    ADDD   #$0080
D893: DD E4       STD    $E4
D895: 86 00       LDA    #$00
D897: 10 AE 19    LDY    -$7,X
D89A: 10 9C E4    CMPY   $E4
D89D: 25 02       BCS    $D8A1
D89F: 86 01       LDA    #$01
D8A1: CE 52 C2    LDU    #$52C2
D8A4: E6 88 14    LDB    $14,X
D8A7: 27 03       BEQ    $D8AC
D8A9: CE 52 E0    LDU    #$52E0
D8AC: 48          ASLA
D8AD: EE C6       LDU    A,U
D8AF: EF 08       STU    $8,X
D8B1: C8 01       EORB   #$01
D8B3: E7 88 14    STB    $14,X
D8B6: 58          ASLB
D8B7: CE 51 82    LDU    #$5182
D8BA: EE C5       LDU    B,U
D8BC: EF 84       STU    ,X
D8BE: EF 03       STU    $3,X
D8C0: 6F 02       CLR    $2,X
D8C2: EE 08       LDU    $8,X
D8C4: EC C1       LDD    ,U++
D8C6: 2A 04       BPL    $D8CC
D8C8: 84 7F       ANDA   #$7F
D8CA: EE C4       LDU    ,U
D8CC: A7 0A       STA    $A,X
D8CE: E7 1E       STB    -$2,X
D8D0: EF 08       STU    $8,X
D8D2: 10 AE 88 1E LDY    $1E,X
D8D6: 27 0F       BEQ    $D8E7
D8D8: A6 1E       LDA    -$2,X
D8DA: A1 3E       CMPA   -$2,Y
D8DC: 27 09       BEQ    $D8E7
D8DE: C6 0A       LDB    #$0A
D8E0: ED 26       STD    $6,Y
D8E2: 86 01       LDA    #$01
D8E4: A7 A8 18    STA    $18,Y
D8E7: 39          RTS
D8E8: D6 72       LDB    starting_level_0072
D8EA: C1 05       CMPB   #$05
D8EC: 27 1C       BEQ    bankswitch_copy_d90A
D8EE: CE D9 47    LDU    #bankswitch_copy_d947
D8F1: EC 19       LDD    -$7,X
D8F3: 93 A2       SUBD   $A2
D8F5: 2B 09       BMI    bankswitch_copy_d900
D8F7: 10 83 00 A0 CMPD   #$00A0
D8FB: 25 C5       BCS    $D8C2
D8FD: CE D9 43    LDU    #bankswitch_copy_d943
D900: E6 88 14    LDB    $14,X
D903: 58          ASLB
D904: EC C5       LDD    B,U
D906: EE 08       LDU    $8,X
D908: 20 C2       BRA    $D8CC
D90A: EC 88 19    LDD    $19,X
D90D: 93 A2       SUBD   $A2
D90F: C3 01 00    ADDD   #$0100
D912: 10 83 02 00 CMPD   #$0200
D916: 22 1C       BHI    bankswitch_copy_d934
D918: EC 19       LDD    -$7,X
D91A: 93 A2       SUBD   $A2
D91C: C3 00 5E    ADDD   #$005E
D91F: 10 83 00 BC CMPD   #$00BC
D923: 25 9D       BCS    $D8C2
D925: CE D9 47    LDU    #bankswitch_copy_d947
D928: EC 19       LDD    -$7,X
D92A: 10 93 A2    CMPD   $A2
D92D: 25 03       BCS    bankswitch_copy_d932
D92F: CE D9 43    LDU    #bankswitch_copy_d943
D932: 20 CC       BRA    bankswitch_copy_d900
D934: CE D9 47    LDU    #bankswitch_copy_d947
D937: EC 19       LDD    -$7,X
D939: 10 93 A2    CMPD   $A2
D93C: 22 03       BHI    bankswitch_copy_d941
D93E: CE D9 43    LDU    #bankswitch_copy_d943
D941: 20 BD       BRA    bankswitch_copy_d900
D943: 24 02       BCC    bankswitch_copy_d947
D945: 24 06       BCC    bankswitch_copy_d94D
D947: 24 0E       BCC    bankswitch_copy_d957
D949: 24 0A       BCC    bankswitch_copy_d955
D94B: A6 88 13    LDA    $13,X
D94E: 26 30       BNE    bankswitch_copy_d980
D950: 8D 03       BSR    bankswitch_copy_d955
D952: 7E A4 27    JMP    $A427
D955: E6 88 18    LDB    $18,X
D958: 27 26       BEQ    bankswitch_copy_d980
D95A: 6A 07       DEC    $7,X
D95C: 26 22       BNE    bankswitch_copy_d980
D95E: E6 06       LDB    $6,X
D960: E7 1E       STB    -$2,X
D962: 6F 88 18    CLR    $18,X
D965: 10 AE 88 1E LDY    $1E,X
D969: 27 15       BEQ    bankswitch_copy_d980
D96B: A6 1E       LDA    -$2,X
D96D: A7 26       STA    $6,Y
D96F: C6 06       LDB    #$06
D971: A6 2D       LDA    $D,Y
D973: 81 02       CMPA   #$02
D975: 27 02       BEQ    bankswitch_copy_d979
D977: C6 07       LDB    #$07
D979: E7 27       STB    $7,Y
D97B: 86 01       LDA    #$01
D97D: A7 A8 18    STA    $18,Y
D980: 39          RTS
D981: E6 88 15    LDB    $15,X
D984: 26 63       BNE    bankswitch_copy_d9E9
D986: EC 19       LDD    -$7,X
D988: 93 A2       SUBD   $A2
D98A: C3 00 48    ADDD   #$0048
D98D: 10 83 00 90 CMPD   #$0090
D991: 22 ED       BHI    bankswitch_copy_d980
D993: D6 21       LDB    $21
D995: 5C          INCB
D996: C4 1F       ANDB   #$1F
D998: 26 E6       BNE    bankswitch_copy_d980
D99A: D6 EB       LDB    $EB
D99C: C4 03       ANDB   #$03
D99E: 26 E0       BNE    bankswitch_copy_d980
D9A0: D6 A7       LDB    $A7
D9A2: 27 DC       BEQ    bankswitch_copy_d980
D9A4: E6 88 14    LDB    $14,X
D9A7: 58          ASLB
D9A8: CE 51 F6    LDU    #$51F6
D9AB: EE C5       LDU    B,U
D9AD: EF 84       STU    ,X
D9AF: EF 03       STU    $3,X
D9B1: 6F 02       CLR    $2,X
D9B3: C6 0A       LDB    #$0A
D9B5: E7 88 16    STB    $16,X
D9B8: 6C 88 15    INC    $15,X
D9BB: BD 8E 2E    JSR    $8E2E
D9BE: E6 88 14    LDB    $14,X
D9C1: E7 3E       STB    -$2,Y
D9C3: 27 09       BEQ    bankswitch_copy_d9CE
D9C5: EC 16       LDD    -$A,X
D9C7: 83 00 0A    SUBD   #$000A
D9CA: ED 36       STD    -$A,Y
D9CC: 20 07       BRA    bankswitch_copy_d9D5
D9CE: EC 16       LDD    -$A,X
D9D0: C3 00 0A    ADDD   #$000A
D9D3: ED 36       STD    -$A,Y
D9D5: EC 19       LDD    -$7,X
D9D7: 83 00 05    SUBD   #$0005
D9DA: ED 39       STD    -$7,Y
D9DC: 4F          CLRA
D9DD: 5F          CLRB
D9DE: ED 33       STD    -$D,Y
D9E0: E7 35       STB    -$B,Y
D9E2: 4C          INCA
D9E3: ED 30       STD    -$10,Y
D9E5: C6 09       LDB    #$09
D9E7: E7 25       STB    $5,Y
D9E9: 6A 88 16    DEC    $16,X
D9EC: 26 12       BNE    $DA00
D9EE: 6F 88 15    CLR    $15,X
D9F1: CE 51 82    LDU    #$5182
D9F4: E6 88 14    LDB    $14,X
D9F7: 58          ASLB
D9F8: EE C5       LDU    B,U
D9FA: EF 84       STU    ,X
D9FC: EF 03       STU    $3,X
D9FE: 6F 02       CLR    $2,X
DA00: 39          RTS
DA01: 58          ASLB
DA02: CE DA 07    LDU    #jump_table_da07
DA05: 6E D5       JMP    [B,U]	; [indirect_jump]

DA15: 33 84       LEAU   ,X
DA17: E6 C8 1B    LDB    $1B,U
DA1A: 27 1F       BEQ    $DA3B
DA1C: C1 08       CMPB   #$08
DA1E: 27 34       BEQ    $DA54
DA20: EE C8 1E    LDU    $1E,U
DA23: E6 C8 1B    LDB    $1B,U
DA26: 26 F8       BNE    $DA20
DA28: 6C 50       INC    -$10,U
DA2A: CC 01 00    LDD    #$0100
DA2D: ED 13       STD    -$D,X
DA2F: A7 10       STA    -$10,X
DA31: A7 88 10    STA    $10,X
DA34: 34 60       PSHS   U,Y
DA36: BD D9 4B    JSR    bankswitch_copy_d94B
DA39: 35 60       PULS   Y,U
DA3B: 10 AE C8 1C LDY    $1C,U
DA3F: E6 A8 1B    LDB    $1B,Y
DA42: C1 08       CMPB   #$08
DA44: 27 03       BEQ    $DA49
DA46: 6F A8 1B    CLR    $1B,Y
DA49: 4F          CLRA
DA4A: 5F          CLRB
DA4B: ED A8 1E    STD    $1E,Y
DA4E: CC 02 04    LDD    #$0204
DA51: ED 53       STD    -$D,U
DA53: 39          RTS
DA54: 10 AE C8 1E LDY    $1E,U
DA58: 27 0D       BEQ    $DA67
DA5A: CC 02 04    LDD    #$0204
DA5D: ED 33       STD    -$D,Y
DA5F: 6C 30       INC    -$10,Y
DA61: 10 AE A8 1E LDY    $1E,Y
DA65: 26 F6       BNE    $DA5D
DA67: CC 02 01    LDD    #$0201
DA6A: ED 53       STD    -$D,U
DA6C: 39          RTS
DA6D: BD 79 A1    JSR    $79A1
DA70: C6 01       LDB    #$01
DA72: E7 0B       STB    $B,X
DA74: C6 3F       LDB    #$3F
DA76: E7 0A       STB    $A,X
DA78: 6C 14       INC    -$C,X
DA7A: 39          RTS
DA7B: BD 79 CE    JSR    $79CE
DA7E: 6F 0B       CLR    $B,X
DA80: C6 3F       LDB    #$3F
DA82: E7 0A       STB    $A,X
DA84: 6C 14       INC    -$C,X
DA86: 39          RTS
DA87: C6 02       LDB    #$02
DA89: E7 1F       STB    -$1,X
DA8B: CC E9 30    LDD    #$E930
DA8E: ED 03       STD    $3,X
DA90: 6A 0A       DEC    $A,X
DA92: 26 0D       BNE    $DAA1
DA94: CC 0C 09    LDD    #$0C09
DA97: BD 69 09    JSR    $6909
DA9A: CC 03 00    LDD    #$0300
DA9D: ED 13       STD    -$D,X
DA9F: E7 15       STB    -$B,X
DAA1: 39          RTS
DAA2: C6 02       LDB    #$02
DAA4: E7 1F       STB    -$1,X
DAA6: CC E9 1C    LDD    #$E91C
DAA9: ED 03       STD    $3,X
DAAB: 6A 0A       DEC    $A,X
DAAD: 26 07       BNE    $DAB6
DAAF: CC 03 00    LDD    #$0300
DAB2: ED 13       STD    -$D,X
DAB4: E7 15       STB    -$B,X
DAB6: 39          RTS
DAB7: 4F          CLRA
DAB8: 5F          CLRB
DAB9: ED 10       STD    -$10,X
DABB: ED 13       STD    -$D,X
DABD: E7 15       STB    -$B,X
DABF: A6 0B       LDA    $B,X
DAC1: 26 03       BNE    $DAC6
DAC3: 7E 8E 0C    JMP    $8E0C
DAC6: 96 B5       LDA    $B5
DAC8: 27 02       BEQ    $DACC
DACA: 0A B5       DEC    $B5
DACC: BD 8E 0C    JSR    $8E0C
DACF: D6 72       LDB    starting_level_0072
DAD1: C1 05       CMPB   #$05
DAD3: 27 03       BEQ    $DAD8
DAD5: 7E E8 44    JMP    $E844
DAD8: 39          RTS
DAD9: EC 13       LDD    -$D,X
DADB: 48          ASLA
DADC: CE DA E1    LDU    #jump_table_dae1
DADF: 6E D6       JMP    [A,U]	; [indirect_jump]

DAE9: 58          ASLB
DAEA: CE DA EF    LDU    #$DAEF
DAED: 6E D5       JMP    [B,U]	; [indirect_jump]

DAF3: 9F A5       STX    $A5
DAF5: C6 01       LDB    #$01
DAF7: D7 A4       STB    $A4
DAF9: C6 06       LDB    #$06
DAFB: E7 1F       STB    -$1,X
DAFD: C6 01       LDB    #$01
DAFF: E7 1E       STB    -$2,X
DB01: E7 88 18    STB    $18,X
DB04: 6F 88 19    CLR    $19,X
DB07: 6F 0D       CLR    $D,X
DB09: 6F 88 12    CLR    $12,X
DB0C: D6 9A       LDB    $9A
DB0E: C4 30       ANDB   #$30
DB10: 54          LSRB
DB11: 54          LSRB
DB12: 54          LSRB
DB13: E7 88 1A    STB    $1A,X
DB16: CE 53 F2    LDU    #$53F2
DB19: EF 1C       STU    -$4,X
DB1B: 86 0A       LDA    #$0A
DB1D: A7 88 16    STA    $16,X
DB20: BD DC 39    JSR    $DC39
DB23: BD DC 20    JSR    $DC20
DB26: 6C 14       INC    -$C,X
DB28: 39          RTS
DB29: E6 11       LDB    -$F,X
DB2B: 27 14       BEQ    $DB41
DB2D: DC 9C       LDD    $9C
DB2F: C3 00 60    ADDD   #$0060
DB32: ED 0B       STD    $B,X
DB34: C3 00 80    ADDD   #$0080
DB37: ED 88 13    STD    $13,X
DB3A: CC 01 00    LDD    #$0100
DB3D: ED 13       STD    -$D,X
DB3F: E7 15       STB    -$B,X
DB41: 39          RTS
DB42: D6 21       LDB    $21
DB44: DB E0       ADDB   $E0
DB46: C4 1F       ANDB   #$1F
DB48: 26 03       BNE    $DB4D
DB4A: BD 79 92    JSR    $7992
DB4D: BD A4 27    JSR    $A427
DB50: EC 16       LDD    -$A,X
DB52: 10 A3 0B    CMPD   $B,X
DB55: 22 07       BHI    $DB5E
DB57: EC 0B       LDD    $B,X
DB59: ED 16       STD    -$A,X
DB5B: 6F 1E       CLR    -$2,X
DB5D: 39          RTS
DB5E: 10 A3 88 13 CMPD   $13,X
DB62: 25 09       BCS    $DB6D
DB64: EC 88 13    LDD    $13,X
DB67: ED 16       STD    -$A,X
DB69: 86 01       LDA    #$01
DB6B: A7 1E       STA    -$2,X
DB6D: 39          RTS
DB6E: 58          ASLB
DB6F: CE DB 74    LDU    #jump_table_db74
DB72: 6E D5       JMP    [B,U]	; [indirect_jump]

DB7A: BD 68 F9    JSR    $68F9
DB7D: C4 03       ANDB   #$03
DB7F: 1F 98       TFR    B,A
DB81: BD 68 F9    JSR    $68F9
DB84: ED 06       STD    $6,X
DB86: 6F 88 19    CLR    $19,X
DB89: BD DC DE    JSR    $DCDE
DB8C: 6C 14       INC    -$C,X
DB8E: 10 AE 06    LDY    $6,X
DB91: 31 3F       LEAY   -$1,Y
DB93: 10 AF 06    STY    $6,X
DB96: 27 10       BEQ    $DBA8
DB98: BD DC 06    JSR    $DC06
DB9B: 6D 0D       TST    $D,X
DB9D: 26 06       BNE    $DBA5
DB9F: BD DB 42    JSR    $DB42
DBA2: BD 90 74    JSR    $9074
DBA5: 7E 8F 62    JMP    $8F62
DBA8: CE DB C7    LDU    #$DBC7
DBAB: E6 88 1A    LDB    $1A,X
DBAE: 54          LSRB
DBAF: A6 C5       LDA    B,U
DBB1: 97 E1       STA    $E1
DBB3: BD 68 F9    JSR    $68F9
DBB6: C4 2F       ANDB   #$2F
DBB8: DB E1       ADDB   $E1
DBBA: E7 08       STB    $8,X
DBBC: 86 01       LDA    #$01
DBBE: A7 88 19    STA    $19,X
DBC1: BD DC DE    JSR    $DCDE
DBC4: 6C 14       INC    -$C,X
DBC6: 39          RTS

DBCB: 6A 08       DEC    $8,X
DBCD: 27 03       BEQ    $DBD2
DBCF: 7E DC 06    JMP    $DC06
DBD2: BD DB DE    JSR    $DBDE
DBD5: A6 1E       LDA    -$2,X
DBD7: 88 01       EORA   #$01
DBD9: A7 1E       STA    -$2,X
DBDB: 6F 14       CLR    -$C,X
DBDD: 39          RTS
DBDE: BD 68 F9    JSR    $68F9
DBE1: C4 0F       ANDB   #$0F
DBE3: CE DB F2    LDU    #$DBF2
DBE6: E6 C5       LDB    B,U
DBE8: CE DC 02    LDU    #$DC02
DBEB: 10 AE C5    LDY    B,U
DBEE: 10 AF 1C    STY    -$4,X
DBF1: 39          RTS

DC06: BD DC C0    JSR    $DCC0
DC09: BD DC 47    JSR    $DC47
DC0C: 6D 0D       TST    $D,X
DC0E: 26 0F       BNE    $DC1F
DC10: BD DC AA    JSR    $DCAA
DC13: 6D 88 17    TST    $17,X
DC16: 27 04       BEQ    $DC1C
DC18: BD DC FA    JSR    $DCFA
DC1B: 39          RTS
DC1C: BD DC 9F    JSR    $DC9F
DC1F: 39          RTS
DC20: CE 54 22    LDU    #$5422
DC23: 6D 0D       TST    $D,X
DC25: 26 08       BNE    $DC2F
DC27: CE 54 02    LDU    #$5402
DC2A: E6 88 1A    LDB    $1A,X
DC2D: EE C5       LDU    B,U
DC2F: BD 68 F9    JSR    $68F9
DC32: C4 07       ANDB   #$07
DC34: E6 C5       LDB    B,U
DC36: E7 09       STB    $9,X
DC38: 39          RTS
DC39: BD 68 F9    JSR    $68F9
DC3C: C4 01       ANDB   #$01
DC3E: 5C          INCB
DC3F: E7 0E       STB    $E,X
DC41: BD 68 F9    JSR    $68F9
DC44: ED 0F       STD    $F,X
DC46: 39          RTS
DC47: 6D 0D       TST    $D,X
DC49: 26 22       BNE    $DC6D
DC4B: 10 AE 0E    LDY    $E,X
DC4E: 31 3F       LEAY   -$1,Y
DC50: 10 AF 0E    STY    $E,X
DC53: 26 18       BNE    $DC6D
DC55: 86 01       LDA    #$01
DC57: A7 0D       STA    $D,X
DC59: BD DC DE    JSR    $DCDE
DC5C: 4F          CLRA
DC5D: 5F          CLRB
DC5E: BD 68 F9    JSR    $68F9
DC61: C4 7F       ANDB   #$7F
DC63: C3 00 40    ADDD   #$0040
DC66: ED 88 10    STD    $10,X
DC69: 86 01       LDA    #$01
DC6B: A7 09       STA    $9,X
DC6D: BD DC 71    JSR    $DC71
DC70: 39          RTS
DC71: 6D 0D       TST    $D,X
DC73: 27 29       BEQ    $DC9E
DC75: BD DC C0    JSR    $DCC0
DC78: 10 AE 88 10 LDY    $10,X
DC7C: 31 3F       LEAY   -$1,Y
DC7E: 10 AF 88 10 STY    $10,X
DC82: 27 0C       BEQ    $DC90
DC84: BD 68 F9    JSR    $68F9
DC87: C4 01       ANDB   #$01
DC89: E7 88 12    STB    $12,X
DC8C: BD DC 9F    JSR    $DC9F
DC8F: 39          RTS
DC90: BD DB DE    JSR    $DBDE
DC93: 6F 0D       CLR    $D,X
DC95: 6F 88 12    CLR    $12,X
DC98: BD DC DE    JSR    $DCDE
DC9B: BD DC 39    JSR    $DC39
DC9E: 39          RTS
DC9F: 6A 09       DEC    $9,X
DCA1: 26 06       BNE    $DCA9
DCA3: BD DD 12    JSR    $DD12
DCA6: BD DC 20    JSR    $DC20
DCA9: 39          RTS
DCAA: 6F 88 17    CLR    $17,X
DCAD: EC 16       LDD    -$A,X
DCAF: 93 A0       SUBD   $A0
DCB1: C3 00 50    ADDD   #$0050
DCB4: 10 83 00 A0 CMPD   #$00A0
DCB8: 25 05       BCS    $DCBF
DCBA: 86 01       LDA    #$01
DCBC: A7 88 17    STA    $17,X
DCBF: 39          RTS
DCC0: 0F E1       CLR    $E1
DCC2: EC 16       LDD    -$A,X
DCC4: 10 93 A0    CMPD   $A0
DCC7: 25 02       BCS    $DCCB
DCC9: 0C E1       INC    $E1
DCCB: A6 88 18    LDA    $18,X
DCCE: 91 E1       CMPA   $E1
DCD0: 27 0B       BEQ    $DCDD
DCD2: A6 88 18    LDA    $18,X
DCD5: 88 01       EORA   #$01
DCD7: A7 88 18    STA    $18,X
DCDA: BD DC DE    JSR    $DCDE
DCDD: 39          RTS
DCDE: CE 52 FE    LDU    #$52FE
DCE1: A6 88 18    LDA    $18,X
DCE4: 48          ASLA
DCE5: EE C6       LDU    A,U
DCE7: A6 88 19    LDA    $19,X
DCEA: 6D 0D       TST    $D,X
DCEC: 27 02       BEQ    $DCF0
DCEE: 86 02       LDA    #$02
DCF0: 48          ASLA
DCF1: EE C6       LDU    A,U
DCF3: EF 84       STU    ,X
DCF5: EF 03       STU    $3,X
DCF7: 6F 02       CLR    $2,X
DCF9: 39          RTS
DCFA: 86 01       LDA    #$01
DCFC: A7 88 12    STA    $12,X
DCFF: 96 20       LDA    $20
DD01: BD 68 F9    JSR    $68F9
DD04: C4 03       ANDB   #$03
DD06: 26 03       BNE    $DD0B
DD08: 6F 88 12    CLR    $12,X
DD0B: BD DC 9F    JSR    $DC9F
DD0E: 6F 88 12    CLR    $12,X
DD11: 39          RTS
DD12: D6 A7       LDB    $A7
DD14: 27 50       BEQ    $DD66
DD16: BD 8E 2E    JSR    $8E2E
DD19: A6 88 18    LDA    $18,X
DD1C: A7 3E       STA    -$2,Y
DD1E: E6 88 1A    LDB    $1A,X
DD21: 54          LSRB
DD22: E7 26       STB    $6,Y
DD24: 4F          CLRA
DD25: 5F          CLRB
DD26: ED 33       STD    -$D,Y
DD28: E7 35       STB    -$B,Y
DD2A: 4C          INCA
DD2B: ED 30       STD    -$10,Y
DD2D: C6 0A       LDB    #$0A
DD2F: E7 25       STB    $5,Y
DD31: EC 16       LDD    -$A,X
DD33: 6D 88 18    TST    $18,X
DD36: 26 05       BNE    $DD3D
DD38: C3 00 04    ADDD   #$0004
DD3B: 20 03       BRA    $DD40
DD3D: 83 00 04    SUBD   #$0004
DD40: ED 36       STD    -$A,Y
DD42: EC 19       LDD    -$7,X
DD44: 83 00 05    SUBD   #$0005
DD47: ED 39       STD    -$7,Y
DD49: 6D 88 12    TST    $12,X
DD4C: 27 18       BEQ    $DD66
DD4E: EC 16       LDD    -$A,X
DD50: 6D 88 18    TST    $18,X
DD53: 26 05       BNE    $DD5A
DD55: C3 00 0A    ADDD   #$000A
DD58: 20 03       BRA    $DD5D
DD5A: 83 00 0A    SUBD   #$000A
DD5D: ED 36       STD    -$A,Y
DD5F: EC 19       LDD    -$7,X
DD61: C3 00 0C    ADDD   #$000C
DD64: ED 39       STD    -$7,Y
DD66: 39          RTS
DD67: 58          ASLB
DD68: CE DD 6D    LDU    #jump_table_dd6d
DD6B: 6E D5       JMP    [B,U]	; [indirect_jump]

DD73: BD 7A 66    JSR    $7A66
DD76: BD 79 7E    JSR    $797E
DD79: 0D 7F       TST    $7F
DD7B: 27 05       BEQ    $DD82
DD7D: BD 7A 34    JSR    $7A34
DD80: 20 03       BRA    $DD85
DD82: BD 79 D3    JSR    $79D3
DD85: C6 3F       LDB    #$3F
DD87: E7 0D       STB    $D,X
DD89: 6C 14       INC    -$C,X
DD8B: 39          RTS
DD8C: C6 02       LDB    #$02
DD8E: E7 1F       STB    -$1,X
DD90: CE E9 4C    LDU    #$E94C
DD93: D6 7F       LDB    $7F
DD95: 26 03       BNE    $DD9A
DD97: CE E9 48    LDU    #$E948
DD9A: EF 03       STU    $3,X
DD9C: 6A 0D       DEC    $D,X
DD9E: 26 02       BNE    $DDA2
DDA0: 6C 13       INC    -$D,X
DDA2: 39          RTS
DDA3: 0F A4       CLR    $A4
DDA5: CE 00 30    LDU    #$0030
DDA8: E6 05       LDB    $5,X
DDAA: 6C C5       INC    B,U
DDAC: 4F          CLRA
DDAD: 5F          CLRB
DDAE: ED 10       STD    -$10,X
DDB0: ED 13       STD    -$D,X
DDB2: BD 8E 0C    JSR    $8E0C
DDB5: 7E E8 44    JMP    $E844
DDB8: 39          RTS
DDB9: A6 05       LDA    $5,X
DDBB: 81 0D       CMPA   #$0D
DDBD: 27 01       BEQ    $DDC0
DDBF: 39          RTS
DDC0: A6 12       LDA    -$E,X
DDC2: 81 01       CMPA   #$01
DDC4: 26 05       BNE    $DDCB
DDC6: 6F 12       CLR    -$E,X
DDC8: BD 79 C9    JSR    $79C9
DDCB: 10 8E 05 40 LDY    #$0540
DDCF: C6 04       LDB    #$04
DDD1: D7 E1       STB    $E1
DDD3: E6 30       LDB    -$10,Y
DDD5: E4 31       ANDB   -$F,Y
DDD7: 27 37       BEQ    $DE10
DDD9: E6 10       LDB    -$10,X
DDDB: E4 11       ANDB   -$F,X
DDDD: 27 31       BEQ    $DE10
DDDF: EC 16       LDD    -$A,X
DDE1: A3 36       SUBD   -$A,Y
DDE3: C3 00 20    ADDD   #$0020
DDE6: 10 83 00 40 CMPD   #$0040
DDEA: 22 24       BHI    $DE10
DDEC: EC 19       LDD    -$7,X
DDEE: A3 39       SUBD   -$7,Y
DDF0: C3 00 20    ADDD   #$0020
DDF3: 10 83 00 40 CMPD   #$0040
DDF7: 22 17       BHI    $DE10
DDF9: EC 19       LDD    -$7,X
DDFB: A3 39       SUBD   -$7,Y
DDFD: C3 00 09    ADDD   #$0009
DE00: 10 83 00 12 CMPD   #$0012
DE04: 25 0A       BCS    $DE10
DE06: 68 30       ASL    -$10,Y
DE08: 6F 35       CLR    -$B,Y
DE0A: CC 02 01    LDD    #$0201
DE0D: ED 33       STD    -$D,Y
DE0F: 39          RTS
DE10: 31 A8 40    LEAY   $40,Y
DE13: 0A E1       DEC    $E1
DE15: 26 BC       BNE    $DDD3
DE17: 39          RTS
DE18: D6 21       LDB    $21
DE1A: DB E0       ADDB   $E0
DE1C: C4 0F       ANDB   #$0F
DE1E: 26 03       BNE    $DE23
DE20: BD 8E 41    JSR    $8E41
DE23: CE 54 2A    LDU    #jump_table_542a		; in bank 3
DE26: EC 13       LDD    -$D,X
DE28: 48          ASLA
DE29: 6E D6       JMP    [A,U]	; [indirect_jump]

jump_table_542a:
	.word	$DE2B 
	.word	$DE5A 
	.word	$DEA2 
	.word	$DEA5

DE2B: CE 54 F7    LDU    #$54F7
DE2E: E6 C4       LDB    ,U
DE30: E7 1F       STB    -$1,X
DE32: EF 08       STU    $8,X
DE34: CE 54 32    LDU    #$5432
DE37: EF 84       STU    ,X
DE39: EF 03       STU    $3,X
DE3B: C6 02       LDB    #$02
DE3D: E7 02       STB    $2,X
DE3F: CE 54 C4    LDU    #$54C4
DE42: D6 9A       LDB    $9A
DE44: C4 30       ANDB   #$30
DE46: 54          LSRB
DE47: 54          LSRB
DE48: 54          LSRB
DE49: EE C5       LDU    B,U
DE4B: E6 C0       LDB    ,U+
DE4D: E7 0C       STB    $C,X
DE4F: EF 0A       STU    $A,X
DE51: CC 01 00    LDD    #$0100
DE54: ED 13       STD    -$D,X
DE56: E7 15       STB    -$B,X
DE58: 39          RTS
DE59: 39          RTS
DE5A: E6 11       LDB    -$F,X
DE5C: 27 FB       BEQ    $DE59
DE5E: D6 21       LDB    $21
DE60: 5C          INCB
DE61: C4 1F       ANDB   #$1F
DE63: 26 27       BNE    $DE8C
DE65: 6A 0C       DEC    $C,X
DE67: 26 23       BNE    $DE8C
DE69: EE 0A       LDU    $A,X
DE6B: E6 C0       LDB    ,U+
DE6D: 2A 04       BPL    $DE73
DE6F: EE C4       LDU    ,U
DE71: C4 7F       ANDB   #$7F
DE73: EF 0A       STU    $A,X
DE75: E7 0C       STB    $C,X
DE77: CE 54 3C    LDU    #$543C
DE7A: EF 84       STU    ,X
DE7C: EF 03       STU    $3,X
DE7E: C6 02       LDB    #$02
DE80: E7 02       STB    $2,X
DE82: CE 54 FB    LDU    #$54FB
DE85: E6 C4       LDB    ,U
DE87: EF 08       STU    $8,X
DE89: BD 8E BF    JSR    $8EBF
DE8C: E6 02       LDB    $2,X
DE8E: 26 0F       BNE    $DE9F
DE90: EE 08       LDU    $8,X
DE92: E6 C0       LDB    ,U+
DE94: 2A 04       BPL    $DE9A
DE96: EE C4       LDU    ,U
DE98: C4 7F       ANDB   #$7F
DE9A: EF 08       STU    $8,X
DE9C: BD 8E BF    JSR    $8EBF
DE9F: 7E 90 74    JMP    $9074
DEA2: 6C 14       INC    -$C,X
DEA4: 39          RTS
DEA5: 4F          CLRA
DEA6: 5F          CLRB
DEA7: ED 10       STD    -$10,X
DEA9: ED 13       STD    -$D,X
DEAB: E7 15       STB    -$B,X
DEAD: 7E 8E 0C    JMP    $8E0C
DEB0: D6 21       LDB    $21
DEB2: DB E0       ADDB   $E0
DEB4: C4 0F       ANDB   #$0F
DEB6: 26 03       BNE    $DEBB
DEB8: BD 8E 41    JSR    $8E41
DEBB: CE DE C3    LDU    #jump_table_dec3
DEBE: EC 13       LDD    -$D,X
DEC0: 48          ASLA
DEC1: 6E D6       JMP    [A,U]	; [indirect_jump]

DECB: C6 01       LDB    #$01
DECD: E7 1F       STB    -$1,X
DECF: C6 00       LDB    #$00
DED1: E7 1E       STB    -$2,X
DED3: EC 16       LDD    -$A,X
DED5: 10 93 A0    CMPD   $A0
DED8: 2D 04       BLT    $DEDE
DEDA: C6 01       LDB    #$01
DEDC: E7 1E       STB    -$2,X
DEDE: CE 55 19    LDU    #$5519
DEE1: BD 90 6B    JSR    $906B
DEE4: CE 55 61    LDU    #$5561
DEE7: D6 9A       LDB    $9A
DEE9: C4 30       ANDB   #$30
DEEB: 54          LSRB
DEEC: 54          LSRB
DEED: 54          LSRB
DEEE: EE C5       LDU    B,U
DEF0: E6 C0       LDB    ,U+
DEF2: E7 06       STB    $6,X
DEF4: EF 08       STU    $8,X
DEF6: CC 01 00    LDD    #$0100
DEF9: ED 13       STD    -$D,X
DEFB: E7 15       STB    -$B,X
DEFD: 39          RTS
DEFE: 58          ASLB
DEFF: CE DF 04    LDU    #jump_table_df04
DF02: 6E D5       JMP    [B,U]	; [indirect_jump]

DF0A: E6 11       LDB    -$F,X
DF0C: 27 02       BEQ    $DF10
DF0E: 6C 14       INC    -$C,X
DF10: 39          RTS
DF11: E6 15       LDB    -$B,X
DF13: 58          ASLB
DF14: CE DF 19    LDU    #jump_table_df19
DF17: 6E D5       JMP    [B,U]	; [indirect_jump]

DF1D: C6 00       LDB    #$00
DF1F: E7 1E       STB    -$2,X
DF21: EC 16       LDD    -$A,X
DF23: 10 93 A0    CMPD   $A0
DF26: 2D 04       BLT    $DF2C
DF28: C6 01       LDB    #$01
DF2A: E7 1E       STB    -$2,X
DF2C: CE 55 19    LDU    #$5519
DF2F: BD 90 6B    JSR    $906B
DF32: 6C 15       INC    -$B,X
DF34: 39          RTS
DF35: BD 90 74    JSR    $9074
DF38: 6A 06       DEC    $6,X
DF3A: 26 13       BNE    $DF4F
DF3C: EE 08       LDU    $8,X
DF3E: E6 C0       LDB    ,U+
DF40: 2A 04       BPL    $DF46
DF42: EE C4       LDU    ,U
DF44: C4 7F       ANDB   #$7F
DF46: EF 08       STU    $8,X
DF48: E7 06       STB    $6,X
DF4A: CC 02 00    LDD    #$0200
DF4D: ED 14       STD    -$C,X
DF4F: E6 11       LDB    -$F,X
DF51: 26 05       BNE    $DF58
DF53: CC 00 00    LDD    #$0000
DF56: ED 14       STD    -$C,X
DF58: 39          RTS
DF59: E6 15       LDB    -$B,X
DF5B: 58          ASLB
DF5C: CE DF 61    LDU    #jump_table_df61
DF5F: 6E D5       JMP    [B,U]	; [indirect_jump]

DF65: C6 18       LDB    #$18
DF67: E7 0D       STB    $D,X
DF69: CE 55 39    LDU    #$5539
DF6C: BD 90 6B    JSR    $906B
DF6F: 6C 15       INC    -$B,X
DF71: 6A 0D       DEC    $D,X
DF73: 10 26 B0 FD LBNE   $9074
DF77: D6 A7       LDB    $A7
DF79: 27 23       BEQ    $DF9E
DF7B: BD 8E 2E    JSR    $8E2E
DF7E: EC 16       LDD    -$A,X
DF80: 83 00 01    SUBD   #$0001
DF83: ED 36       STD    -$A,Y
DF85: EC 19       LDD    -$7,X
DF87: C3 00 05    ADDD   #$0005
DF8A: ED 39       STD    -$7,Y
DF8C: 4F          CLRA
DF8D: 5F          CLRB
DF8E: ED 33       STD    -$D,Y
DF90: E7 35       STB    -$B,Y
DF92: 4C          INCA
DF93: ED 30       STD    -$10,Y
DF95: C6 06       LDB    #$06
DF97: E7 25       STB    $5,Y
DF99: CC 01 00    LDD    #$0100
DF9C: ED 14       STD    -$C,X
DF9E: 39          RTS
DF9F: 58          ASLB
DFA0: CE DF A5    LDU    #jump_table_dfa5
DFA3: 6E D5       JMP    [B,U]	; [indirect_jump]

DFAB: BD 79 CE    JSR    $79CE
DFAE: CC 01 00    LDD    #$0100
DFB1: ED 14       STD    -$C,X
DFB3: 39          RTS
DFB4: CC 03 00    LDD    #$0300
DFB7: ED 13       STD    -$D,X
DFB9: E7 15       STB    -$B,X
DFBB: 39          RTS
DFBC: 4F          CLRA
DFBD: 5F          CLRB
DFBE: ED 10       STD    -$10,X
DFC0: ED 13       STD    -$D,X
DFC2: E7 15       STB    -$B,X
DFC4: 7E 8E 0C    JMP    $8E0C
DFC7: D6 21       LDB    $21
DFC9: DB E0       ADDB   $E0
DFCB: C4 0F       ANDB   #$0F
DFCD: 26 03       BNE    $DFD2
DFCF: BD 8E 41    JSR    $8E41
DFD2: EC 13       LDD    -$D,X
DFD4: 48          ASLA
DFD5: CE DF DA    LDU    #jump_table_dfda
DFD8: 6E D6       JMP    [A,U]	; [indirect_jump]

DFE2: C6 08       LDB    #$08                                       
DFE4: E7 1F       STB    -$1,X
DFE6: C6 01       LDB    #$01
DFE8: E7 1E       STB    -$2,X
DFEA: EC 16       LDD    -$A,X
DFEC: 10 93 A0    CMPD   $A0
DFEF: 2D 04       BLT    $DFF5
DFF1: C6 03       LDB    #$03
DFF3: E7 1E       STB    -$2,X
DFF5: CE 55 D1    LDU    #$55D1
DFF8: BD 90 6B    JSR    $906B
DFFB: CE 55 F3    LDU    #$55F3
DFFE: D6 9A       LDB    $9A
E000: C4 30       ANDB   #$30
E002: 54          LSRB
E003: 54          LSRB
E004: 54          LSRB
E005: EE C5       LDU    B,U
E007: 96 21       LDA    $21
E009: 9B E0       ADDA   $E0
E00B: 84 03       ANDA   #$03
E00D: E6 C6       LDB    A,U
E00F: E7 06       STB    $6,X
E011: EF 08       STU    $8,X
E013: 4C          INCA
E014: E6 C6       LDB    A,U
E016: E7 07       STB    $7,X
E018: EF 0A       STU    $A,X
E01A: C6 04       LDB    #$04
E01C: E7 88 16    STB    $16,X
E01F: CC 01 00    LDD    #$0100
E022: ED 13       STD    -$D,X
E024: E7 15       STB    -$B,X
E026: 39          RTS
E027: 58          ASLB
E028: CE E0 2D    LDU    #jump_table_e02d
E02B: 6E D5       JMP    [B,U]	; [indirect_jump]

E037: E6 11       LDB    -$F,X
E039: 27 02       BEQ    $E03D
E03B: 6C 14       INC    -$C,X
E03D: 39          RTS
E03E: E6 15       LDB    -$B,X
E040: 58          ASLB
E041: CE E0 50    LDU    #jump_table_e050
E044: AD D5       JSR    [B,U]	; [indirect_jump]
E046: E6 11       LDB    -$F,X
E048: 26 05       BNE    $E04F
E04A: CC 00 00    LDD    #$0000
E04D: ED 14       STD    -$C,X
E04F: 39          RTS

E058: C6 81       LDB    #$81                                        
E05A: E7 10       STB    -$10,X
E05C: C6 01       LDB    #$01
E05E: E7 1E       STB    -$2,X
E060: EC 16       LDD    -$A,X
E062: 10 93 A0    CMPD   $A0
E065: 2D 04       BLT    $E06B
E067: C6 03       LDB    #$03
E069: E7 1E       STB    -$2,X
E06B: CE 55 D1    LDU    #$55D1
E06E: BD 90 6B    JSR    $906B
E071: 6F 0C       CLR    $C,X
E073: EC 19       LDD    -$7,X
E075: 93 A2       SUBD   $A2
E077: C3 00 30    ADDD   #$0030
E07A: 10 83 00 60 CMPD   #$0060
E07E: 22 02       BHI    $E082
E080: 6C 15       INC    -$B,X
E082: 39          RTS
E083: 6A 06       DEC    $6,X
E085: 26 14       BNE    $E09B
E087: EE 08       LDU    $8,X
E089: E6 C0       LDB    ,U+
E08B: 2A 04       BPL    $E091
E08D: EE C4       LDU    ,U
E08F: C4 7F       ANDB   #$7F
E091: EF 08       STU    $8,X
E093: E7 06       STB    $6,X
E095: E6 0C       LDB    $C,X
E097: CA 02       ORB    #$02
E099: E7 0C       STB    $C,X
E09B: 6C 15       INC    -$B,X
E09D: 39          RTS
E09E: 6A 07       DEC    $7,X
E0A0: 26 14       BNE    $E0B6
E0A2: EE 0A       LDU    $A,X
E0A4: E6 C0       LDB    ,U+
E0A6: 2A 04       BPL    $E0AC
E0A8: EE C4       LDU    ,U
E0AA: C4 7F       ANDB   #$7F
E0AC: EF 0A       STU    $A,X
E0AE: E7 07       STB    $7,X
E0B0: E6 0C       LDB    $C,X
E0B2: CA 01       ORB    #$01
E0B4: E7 0C       STB    $C,X
E0B6: 6C 15       INC    -$B,X
E0B8: 39          RTS
E0B9: E6 0C       LDB    $C,X
E0BB: 27 04       BEQ    $E0C1
E0BD: 86 01       LDA    #$01
E0BF: A7 10       STA    -$10,X
E0C1: 58          ASLB
E0C2: CE E0 CA    LDU    #$E0CA
E0C5: EC C5       LDD    B,U
E0C7: ED 14       STD    -$C,X
E0C9: 39          RTS

E0D2: E6 15       LDB    -$B,X
E0D4: 58          ASLB
E0D5: CE E0 DA    LDU    #jump_table_e0da
E0D8: 6E D5       JMP    [B,U]	; [indirect_jump]

E0E4: C6 1E       LDB    #$1E
E0E6: E7 0D       STB    $D,X
E0E8: 6C 15       INC    -$B,X
E0EA: 39          RTS
E0EB: 6A 0D       DEC    $D,X
E0ED: 10 26 AF 83 LBNE   $9074
E0F1: E6 1E       LDB    -$2,X
E0F3: CE E1 14    LDU    #$E114
E0F6: E6 C5       LDB    B,U
E0F8: EE 03       LDU    $3,X
E0FA: A6 C1       LDA    ,U++
E0FC: ED 88 10    STD    $10,X
E0FF: A6 C0       LDA    ,U+
E101: A7 88 12    STA    $12,X
E104: A6 C4       LDA    ,U
E106: A7 88 13    STA    $13,X
E109: 33 88 10    LEAU   $10,X
E10C: EF 03       STU    $3,X
E10E: BD 79 F1    JSR    $79F1
E111: 6C 15       INC    -$B,X
E113: 39          RTS

E119: D6 A7       LDB    $A7
E11B: 27 0A       BEQ    $E127
E11D: 8D 6D       BSR    $E18C
E11F: C6 20       LDB    #$20
E121: E7 0D       STB    $D,X
E123: 6F 0E       CLR    $E,X
E125: 6C 15       INC    -$B,X
E127: 39          RTS
E128: 6A 0D       DEC    $D,X
E12A: 27 18       BEQ    $E144
E12C: E6 0E       LDB    $E,X
E12E: 58          ASLB
E12F: EB 0E       ADDB   $E,X
E131: CE E1 74    LDU    #$E174
E134: 33 C5       LEAU   B,U
E136: E6 C4       LDB    ,U
E138: E7 88 10    STB    $10,X
E13B: E6 0D       LDB    $D,X
E13D: C5 03       BITB   #$03
E13F: 26 02       BNE    $E143
E141: 6C 0E       INC    $E,X
E143: 39          RTS
E144: 6C 15       INC    -$B,X
E146: C6 0A       LDB    #$0A
E148: E7 0D       STB    $D,X
E14A: 39          RTS
E14B: 6A 0D       DEC    $D,X
E14D: 10 26 AF 23 LBNE   $9074
E151: E6 1E       LDB    -$2,X
E153: CE E1 14    LDU    #$E114
E156: E6 C5       LDB    B,U
E158: EE 03       LDU    $3,X
E15A: A6 C1       LDA    ,U++
E15C: ED 88 10    STD    $10,X
E15F: A6 C0       LDA    ,U+
E161: A7 88 12    STA    $12,X
E164: A6 C4       LDA    ,U
E166: A7 88 13    STA    $13,X
E169: 33 88 10    LEAU   $10,X
E16C: EF 03       STU    $3,X
E16E: CC 01 00    LDD    #$0100
E171: ED 14       STD    -$C,X
E173: 39          RTS
E174: 92 9B       SBCA   $9B
E176: 93 9C       SUBD   $9C
E178: 94 9D       ANDA   $9D
E17A: 9C 94       CMPX   $94
E17C: 9D 92       JSR    $92
E17E: 9B 93       ADDA   $93
E180: 92 9B       SBCA   $9B
E182: 93 92       SUBD   $92
E184: 9B 93       ADDA   $93
E186: 92 9B       SBCA   $9B
E188: 93 99       SUBD   $99
E18A: 91 9A       CMPA   $9A
E18C: BD 8E 2E    JSR    $8E2E
E18F: EC 16       LDD    -$A,X
E191: ED 36       STD    -$A,Y
E193: EC 19       LDD    -$7,X
E195: 83 00 10    SUBD   #$0010
E198: ED 39       STD    -$7,Y
E19A: C6 00       LDB    #$00
E19C: E7 3E       STB    -$2,Y
E19E: EC 16       LDD    -$A,X
E1A0: 10 93 A0    CMPD   $A0
E1A3: 2D 04       BLT    $E1A9
E1A5: C6 01       LDB    #$01
E1A7: E7 3E       STB    -$2,Y
E1A9: 4F          CLRA
E1AA: 5F          CLRB
E1AB: ED 33       STD    -$D,Y
E1AD: E7 35       STB    -$B,Y
E1AF: 4C          INCA
E1B0: ED 30       STD    -$10,Y
E1B2: C6 05       LDB    #$05
E1B4: E7 25       STB    $5,Y
E1B6: 39          RTS
E1B7: BD 8E 2E    JSR    $8E2E
E1BA: EC 16       LDD    -$A,X
E1BC: ED 36       STD    -$A,Y
E1BE: EC 19       LDD    -$7,X
E1C0: C3 00 07    ADDD   #$0007
E1C3: ED 39       STD    -$7,Y
E1C5: C6 00       LDB    #$00
E1C7: E7 3E       STB    -$2,Y
E1C9: EC 16       LDD    -$A,X
E1CB: 10 93 A0    CMPD   $A0
E1CE: 2D 04       BLT    $E1D4
E1D0: C6 01       LDB    #$01
E1D2: E7 3E       STB    -$2,Y
E1D4: 4F          CLRA
E1D5: 5F          CLRB
E1D6: ED 33       STD    -$D,Y
E1D8: E7 35       STB    -$B,Y
E1DA: 4C          INCA
E1DB: ED 30       STD    -$10,Y
E1DD: C6 05       LDB    #$05
E1DF: E7 25       STB    $5,Y
E1E1: 39          RTS
E1E2: E6 15       LDB    -$B,X
E1E4: 58          ASLB
E1E5: CE E1 EA    LDU    #jump_table_e1ea
E1E8: 6E D5       JMP    [B,U]	; [indirect_jump]

E1F4: D6 A7       LDB    $A7
E1F6: 27 0A       BEQ    $E202
E1F8: 8D BD       BSR    $E1B7
E1FA: C6 20       LDB    #$20
E1FC: E7 0D       STB    $D,X
E1FE: 6F 0F       CLR    $F,X
E200: 6C 15       INC    -$B,X
E202: 39          RTS
E203: 6A 0D       DEC    $D,X
E205: 27 1B       BEQ    $E222
E207: E6 0F       LDB    $F,X
E209: 58          ASLB
E20A: EB 0F       ADDB   $F,X
E20C: CE E1 74    LDU    #$E174
E20F: 33 C5       LEAU   B,U
E211: EC 41       LDD    $1,U
E213: A7 88 12    STA    $12,X
E216: E7 88 13    STB    $13,X
E219: E6 0D       LDB    $D,X
E21B: C5 03       BITB   #$03
E21D: 26 02       BNE    $E221
E21F: 6C 0F       INC    $F,X
E221: 39          RTS
E222: 6C 15       INC    -$B,X
E224: C6 0A       LDB    #$0A
E226: E7 0D       STB    $D,X
E228: 39          RTS
E229: E6 15       LDB    -$B,X
E22B: 58          ASLB
E22C: CE E2 31    LDU    #jump_table_e231
E22F: 6E D5       JMP    [B,U]	; [indirect_jump]

E23B: D6 A7       LDB    $A7
E23D: C1 02       CMPB   #$02
E23F: 25 0E       BCS    $E24F
E241: BD E1 8C    JSR    $E18C
E244: BD E1 B7    JSR    $E1B7
E247: C6 20       LDB    #$20
E249: E7 0D       STB    $D,X
E24B: 6F 0F       CLR    $F,X
E24D: 6C 15       INC    -$B,X
E24F: 39          RTS
E250: 6A 0D       DEC    $D,X
E252: 27 20       BEQ    $E274
E254: E6 0F       LDB    $F,X
E256: 58          ASLB
E257: EB 0F       ADDB   $F,X
E259: CE E1 74    LDU    #$E174
E25C: 33 C5       LEAU   B,U
E25E: E6 C4       LDB    ,U
E260: E7 88 10    STB    $10,X
E263: EC 41       LDD    $1,U
E265: A7 88 12    STA    $12,X
E268: E7 88 13    STB    $13,X
E26B: E6 0D       LDB    $D,X
E26D: C5 03       BITB   #$03
E26F: 26 02       BNE    $E273
E271: 6C 0F       INC    $F,X
E273: 39          RTS
E274: 6C 15       INC    -$B,X
E276: C6 0A       LDB    #$0A
E278: E7 0D       STB    $D,X
E27A: 39          RTS
E27B: 58          ASLB
E27C: CE E2 81    LDU    #jump_table_e281
E27F: 6E D5       JMP    [B,U]	; [indirect_jump]

E287: BD 79 CE    JSR    $79CE
E28A: C6 3F       LDB    #$3F
E28C: E7 0A       STB    $A,X
E28E: CC 01 00    LDD    #$0100
E291: ED 14       STD    -$C,X
E293: 39          RTS
E294: C6 02       LDB    #$02
E296: E7 1F       STB    -$1,X
E298: CC E9 20    LDD    #$E920
E29B: ED 03       STD    $3,X
E29D: 6A 0A       DEC    $A,X
E29F: 26 07       BNE    $E2A8
E2A1: CC 03 00    LDD    #$0300
E2A4: ED 13       STD    -$D,X
E2A6: E7 15       STB    -$B,X
E2A8: 39          RTS
E2A9: 4F          CLRA
E2AA: 5F          CLRB
E2AB: ED 10       STD    -$10,X
E2AD: ED 13       STD    -$D,X
E2AF: E7 15       STB    -$B,X
E2B1: 7E 8E 0C    JMP    $8E0C
E2B4: 8E 10 10    LDX    #$1010
E2B7: C6 1E       LDB    #$1E
E2B9: D7 E0       STB    $E0
E2BB: E6 10       LDB    -$10,X
E2BD: 27 0E       BEQ    $E2CD
E2BF: D6 E0       LDB    $E0
E2C1: DB 21       ADDB   $21
E2C3: C4 0F       ANDB   #$0F
E2C5: 26 03       BNE    $E2CA
E2C7: BD 8E 41    JSR    $8E41
E2CA: BD E3 15    JSR    $E315
E2CD: 30 88 20    LEAX   $20,X
E2D0: 0A E0       DEC    $E0
E2D2: 26 E7       BNE    $E2BB
E2D4: 39          RTS
E2D5: E6 05       LDB    $5,X
E2D7: C1 05       CMPB   #$05
E2D9: 27 0F       BEQ    $E2EA
E2DB: EC 16       LDD    -$A,X
E2DD: 93 9C       SUBD   $9C
E2DF: C3 00 40    ADDD   #$0040
E2E2: 10 83 01 80 CMPD   #$0180
E2E6: 22 2B       BHI    $E313
E2E8: 20 1A       BRA    $E304
E2EA: EC 16       LDD    -$A,X
E2EC: 93 9C       SUBD   $9C
E2EE: 2B 0B       BMI    $E2FB
E2F0: C3 00 40    ADDD   #$0040
E2F3: 10 83 02 00 CMPD   #$0200
E2F7: 22 1A       BHI    $E313
E2F9: 20 09       BRA    $E304
E2FB: 83 00 40    SUBD   #$0040
E2FE: 10 83 FF 00 CMPD   #$FF00
E302: 25 0F       BCS    $E313
E304: EC 19       LDD    -$7,X
E306: 93 9E       SUBD   $9E
E308: C3 00 40    ADDD   #$0040
E30B: 10 83 01 80 CMPD   #$0180
E30F: 22 02       BHI    $E313
E311: 53          COMB
E312: 39          RTS
E313: 5F          CLRB
E314: 39          RTS
E315: EC 13       LDD    -$D,X
E317: 48          ASLA
E318: CE E3 1D    LDU    #jump_table_e31d
E31B: 6E D6       JMP    [A,U]	; [indirect_jump]

E325: 6F 1E       CLR    -$2,X
E327: CE 56 67    LDU    #$5667
E32A: E6 05       LDB    $5,X
E32C: A6 C5       LDA    B,U
E32E: A7 1F       STA    -$1,X
E330: CE 56 6D    LDU    #$566D
E333: E6 05       LDB    $5,X
E335: 58          ASLB
E336: EE C5       LDU    B,U
E338: E6 12       LDB    -$E,X
E33A: 58          ASLB
E33B: EE C5       LDU    B,U
E33D: EF 84       STU    ,X
E33F: EF 03       STU    $3,X
E341: CE 56 E0    LDU    #$56E0
E344: E6 05       LDB    $5,X
E346: 58          ASLB
E347: EE C5       LDU    B,U
E349: E6 12       LDB    -$E,X
E34B: 58          ASLB
E34C: EC C5       LDD    B,U
E34E: ED 1C       STD    -$4,X
E350: EC 19       LDD    -$7,X
E352: ED 0B       STD    $B,X
E354: C6 0F       LDB    #$0F
E356: E7 0A       STB    $A,X
E358: CC 01 00    LDD    #$0100
E35B: ED 13       STD    -$D,X
E35D: E7 15       STB    -$B,X
E35F: 39          RTS
E360: 58          ASLB
E361: CE E3 66    LDU    #jump_table_e366
E364: 6E D5       JMP    [B,U]	; [indirect_jump]

E36C: E6 05       LDB    $5,X
E36E: CE 57 B6    LDU    #$57B6
E371: 58          ASLB
E372: EE C5       LDU    B,U
E374: E6 12       LDB    -$E,X
E376: 58          ASLB
E377: EE C5       LDU    B,U
E379: EF 06       STU    $6,X
E37B: 4F          CLRA
E37C: 5F          CLRB
E37D: ED 08       STD    $8,X
E37F: 6C 14       INC    -$C,X
E381: 39          RTS
E382: BD E2 D5    JSR    $E2D5
E385: 24 02       BCC    $E389
E387: 6C 14       INC    -$C,X
E389: 39          RTS
E38A: E6 05       LDB    $5,X
E38C: 58          ASLB
E38D: CE E3 9C    LDU    #jump_table_e39c
E390: AD D5       JSR    [B,U]	; [indirect_jump]
E392: BD E2 D5    JSR    $E2D5
E395: 25 04       BCS    $E39B
E397: C6 01       LDB    #$01
E399: E7 14       STB    -$C,X
E39B: 39          RTS

E3A8: E6 15       LDB    -$B,X
E3AA: 58          ASLB
E3AB: CE E3 B0    LDU    #jump_table_e3b0
E3AE: 6E D5       JMP    [B,U]	; [indirect_jump]

E3B4: DC A0       LDD    $A0
E3B6: 10 83 17 80 CMPD   #$1780
E3BA: 25 02       BCS    $E3BE
E3BC: 6C 15       INC    -$B,X
E3BE: 39          RTS
E3BF: BD 90 74    JSR    $9074
E3C2: D6 21       LDB    $21
E3C4: 54          LSRB
E3C5: 24 32       BCC    $E3F9
E3C7: E6 11       LDB    -$F,X
E3C9: 27 2E       BEQ    $E3F9
E3CB: EC 16       LDD    -$A,X
E3CD: 93 A0       SUBD   $A0
E3CF: C3 00 0C    ADDD   #$000C
E3D2: 10 83 00 18 CMPD   #$0018
E3D6: 22 21       BHI    $E3F9
E3D8: EC 19       LDD    -$7,X
E3DA: 93 A2       SUBD   $A2
E3DC: C3 00 08    ADDD   #$0008
E3DF: 10 83 00 10 CMPD   #$0010
E3E3: 22 14       BHI    $E3F9
E3E5: CC A6 31    LDD    #$A631
E3E8: ED 03       STD    $3,X
E3EA: CC 02 00    LDD    #$0200
E3ED: ED 13       STD    -$D,X
E3EF: E7 15       STB    -$B,X
E3F1: E6 12       LDB    -$E,X
E3F3: 58          ASLB
E3F4: CE E3 FA    LDU    #jump_table_e3fa
E3F7: 6E D5       JMP    [B,U]	; [indirect_jump]
E3F9: 39          RTS

E402: D6 AC       LDB    armour_flag_00ac
E404: 27 1E       BEQ    $E424
E406: CE 16 12    LDU    #$1612
E409: EC 16       LDD    -$A,X
E40B: C3 00 64    ADDD   #$0064
E40E: ED 56       STD    -$A,U
E410: EC 19       LDD    -$7,X
E412: ED 59       STD    -$7,U
E414: C6 01       LDB    #$01
E416: E7 45       STB    $5,U
E418: 5F          CLRB
E419: E7 52       STB    -$E,U
E41B: 4F          CLRA
E41C: 5F          CLRB
E41D: ED 53       STD    -$D,U
E41F: E7 54       STB    -$C,U
E421: 4C          INCA
E422: ED 50       STD    -$10,U
E424: 39          RTS
E425: CE 16 12    LDU    #$1612
E428: EC 16       LDD    -$A,X
E42A: C3 00 64    ADDD   #$0064
E42D: ED 56       STD    -$A,U
E42F: EC 19       LDD    -$7,X
E431: C3 00 80    ADDD   #$0080
E434: ED 59       STD    -$7,U
E436: C6 01       LDB    #$01
E438: E7 45       STB    $5,U
E43A: C6 13       LDB    #$13
E43C: E7 52       STB    -$E,U
E43E: 4F          CLRA
E43F: 5F          CLRB
E440: ED 53       STD    -$D,U
E442: E7 54       STB    -$C,U
E444: 4C          INCA
E445: ED 50       STD    -$10,U
E447: 39          RTS
E448: C6 02       LDB    #$02
E44A: E7 1F       STB    -$1,X
E44C: CE E4 7A    LDU    #$E47A
E44F: E6 12       LDB    -$E,X
E451: C0 02       SUBB   #$02
E453: 58          ASLB
E454: 58          ASLB
E455: 33 C5       LEAU   B,U
E457: EC C4       LDD    ,U
E459: ED 03       STD    $3,X
E45B: EC 42       LDD    $2,U
E45D: BD 69 09    JSR    $6909
E460: BD 79 88    JSR    $7988
E463: D6 E0       LDB    $E0
E465: 54          LSRB
E466: 54          LSRB
E467: 54          LSRB
E468: CE EF 2D    LDU    #$EF2D
E46B: 96 E0       LDA    $E0
E46D: 84 07       ANDA   #$07
E46F: A6 C6       LDA    A,U
E471: 43          COMA
E472: CE 00 74    LDU    #$0074
E475: A4 C5       ANDA   B,U
E477: A7 C5       STA    B,U
E479: 39          RTS
E47A: E9 1C       ADCB   -$4,X
E47C: 0C 04       INC    $04
E47E: E9 28       ADCB   $8,Y
E480: 0C 07       INC    $07
E482: E6 08       LDB    $8,X
E484: 26 12       BNE    $E498
E486: EE 06       LDU    $6,X
E488: EC C1       LDD    ,U++
E48A: A7 1E       STA    -$2,X
E48C: 5D          TSTB
E48D: 2A 04       BPL    $E493
E48F: EE C4       LDU    ,U
E491: C4 7F       ANDB   #$7F
E493: EF 06       STU    $6,X
E495: E7 08       STB    $8,X
E497: 39          RTS
E498: 8D 35       BSR    $E4CF
E49A: 6A 08       DEC    $8,X
E49C: 39          RTS
E49D: E6 12       LDB    -$E,X
E49F: 58          ASLB
E4A0: CE E4 A5    LDU    #jump_table_e4a5
E4A3: 6E D5       JMP    [B,U]	; [indirect_jump]

E4A9: A6 15       LDA    -$B,X                                      
E4AB: 48          ASLA
E4AC: CE E4 B1    LDU    #$E4B1
E4AF: 6E D6       JMP    [A,U]	; [indirect_jump]

E4B5: E6 09       LDB    $9,X
E4B7: 27 06       BEQ    $E4BF
E4B9: 6C 15       INC    -$B,X
E4BB: C6 02       LDB    #$02
E4BD: E7 1E       STB    -$2,X
E4BF: 39          RTS
E4C0: EC 19       LDD    -$7,X
E4C2: 2B 02       BMI    $E4C6
E4C4: 20 09       BRA    $E4CF
E4C6: CC 02 00    LDD    #$0200
E4C9: ED 13       STD    -$D,X
E4CB: E7 15       STB    -$B,X
E4CD: 39          RTS
E4CE: 39          RTS
E4CF: EE 1C       LDU    -$4,X
E4D1: E6 1E       LDB    -$2,X
E4D3: 58          ASLB
E4D4: 58          ASLB
E4D5: 33 C5       LEAU   B,U
E4D7: 8D 17       BSR    $E4F0
E4D9: E6 09       LDB    $9,X
E4DB: 27 F1       BEQ    $E4CE
E4DD: 34 10       PSHS   X
E4DF: 8E 05 10    LDX    #$0510
E4E2: C6 02       LDB    #$02
E4E4: E1 13       CMPB   -$D,X
E4E6: 27 04       BEQ    $E4EC
E4E8: 8D 06       BSR    $E4F0
E4EA: 35 90       PULS   X,PC
E4EC: 8D 0F       BSR    $E4FD
E4EE: 35 90       PULS   X,PC
E4F0: EC 1A       LDD    -$6,X
E4F2: E3 42       ADDD   $2,U
E4F4: ED 1A       STD    -$6,X
E4F6: E6 42       LDB    $2,U
E4F8: 1D          SEX
E4F9: A9 19       ADCA   -$7,X
E4FB: A7 19       STA    -$7,X
E4FD: EC 17       LDD    -$9,X
E4FF: E3 C4       ADDD   ,U
E501: ED 17       STD    -$9,X
E503: E6 C4       LDB    ,U
E505: 1D          SEX
E506: A9 16       ADCA   -$A,X
E508: A7 16       STA    -$A,X
E50A: 39          RTS
E50B: E6 15       LDB    -$B,X
E50D: 58          ASLB
E50E: CE E5 13    LDU    #jump_table_e513
E511: 6E D5       JMP    [B,U]	; [indirect_jump]

E517: 6F 0F       CLR    $F,X
E519: 6C 15       INC    -$B,X
E51B: 39          RTS
E51C: BD E4 82    JSR    $E482
E51F: CE 05 10    LDU    #$0510
E522: E6 53       LDB    -$D,U
E524: C1 02       CMPB   #$02
E526: 26 11       BNE    $E539
E528: EC 16       LDD    -$A,X
E52A: 93 A0       SUBD   $A0
E52C: C3 00 14    ADDD   #$0014
E52F: 10 83 00 28 CMPD   #$0028
E533: 22 7E       BHI    $E5B3
E535: 7E E5 8C    JMP    $E58C
E538: 39          RTS
E539: 6F 0F       CLR    $F,X
E53B: EC 19       LDD    -$7,X
E53D: 93 A2       SUBD   $A2
E53F: C3 00 10    ADDD   #$0010
E542: 10 83 00 20 CMPD   #$0020
E546: 22 43       BHI    $E58B
E548: EC 16       LDD    -$A,X
E54A: 93 A0       SUBD   $A0
E54C: C3 00 20    ADDD   #$0020
E54F: 10 83 00 40 CMPD   #$0040
E553: 22 36       BHI    $E58B
E555: ED 0D       STD    $D,X
E557: 10 83 00 20 CMPD   #$0020
E55B: 25 1B       BCS    $E578
E55D: CC 00 40    LDD    #$0040
E560: A3 0D       SUBD   $D,X
E562: ED 0D       STD    $D,X
E564: CC 00 05    LDD    #$0005
E567: 10 A3 0D    CMPD   $D,X
E56A: 22 05       BHI    $E571
E56C: CC 00 04    LDD    #$0004
E56F: ED 0D       STD    $D,X
E571: EC 56       LDD    -$A,U
E573: A3 0D       SUBD   $D,X
E575: ED 56       STD    -$A,U
E577: 39          RTS
E578: CC 00 05    LDD    #$0005
E57B: 10 A3 0D    CMPD   $D,X
E57E: 22 05       BHI    $E585
E580: CC 00 04    LDD    #$0004
E583: ED 0D       STD    $D,X
E585: EC 56       LDD    -$A,U
E587: E3 0D       ADDD   $D,X
E589: ED 56       STD    -$A,U
E58B: 39          RTS
E58C: EC 16       LDD    -$A,X
E58E: 93 A0       SUBD   $A0
E590: C3 00 18    ADDD   #$0018
E593: 10 83 00 30 CMPD   #$0030
E597: 22 19       BHI    $E5B2
E599: EC 19       LDD    -$7,X
E59B: 10 93 A2    CMPD   $A2
E59E: 25 12       BCS    $E5B2
E5A0: 93 A2       SUBD   $A2
E5A2: 10 83 00 14 CMPD   #$0014
E5A6: 22 0A       BHI    $E5B2
E5A8: CE 05 10    LDU    #$0510
E5AB: C3 FF EC    ADDD   #$FFEC
E5AE: E3 59       ADDD   -$7,U
E5B0: ED 59       STD    -$7,U
E5B2: 39          RTS
E5B3: EC 16       LDD    -$A,X
E5B5: 93 A0       SUBD   $A0
E5B7: 2A 07       BPL    $E5C0
E5B9: E6 5E       LDB    -$2,U
E5BB: C1 02       CMPB   #$02
E5BD: 27 08       BEQ    $E5C7
E5BF: 39          RTS
E5C0: E6 5E       LDB    -$2,U
E5C2: C1 01       CMPB   #$01
E5C4: 27 01       BEQ    $E5C7
E5C6: 39          RTS
E5C7: A6 0F       LDA    $F,X
E5C9: 26 22       BNE    $E5ED
E5CB: EC 19       LDD    -$7,X
E5CD: 93 A2       SUBD   $A2
E5CF: C3 00 10    ADDD   #$0010
E5D2: 10 83 00 20 CMPD   #$0020
E5D6: 22 15       BHI    $E5ED
E5D8: EC 16       LDD    -$A,X
E5DA: 93 A0       SUBD   $A0
E5DC: C3 00 20    ADDD   #$0020
E5DF: 10 83 00 40 CMPD   #$0040
E5E3: 22 08       BHI    $E5ED
E5E5: E6 5E       LDB    -$2,U
E5E7: C8 03       EORB   #$03
E5E9: E7 5E       STB    -$2,U
E5EB: 6C 0F       INC    $F,X
E5ED: 39          RTS
E5EE: 58          ASLB
E5EF: CE E5 F4    LDU    #jump_table_e5f4
E5F2: 6E D5       JMP    [B,U]	; [indirect_jump]

E5F8: C6 1E       LDB    #$1E                                       
E5FA: E7 0E       STB    $E,X
E5FC: 6C 14       INC    -$C,X
E5FE: 6A 0E       DEC    $E,X
E600: 26 04       BNE    $E606
E602: 6C 13       INC    -$D,X
E604: 6F 14       CLR    -$C,X
E606: 39          RTS
E607: 4F          CLRA
E608: 5F          CLRB
E609: ED 10       STD    -$10,X
E60B: ED 13       STD    -$D,X
E60D: E7 15       STB    -$B,X
E60F: 7E 8E 25    JMP    $8E25
E612: 8E 15 E2    LDX    #$15E2
E615: C6 02       LDB    #$02
E617: D7 E0       STB    $E0
E619: E6 10       LDB    -$10,X
E61B: 27 0E       BEQ    $E62B
E61D: D6 E0       LDB    $E0
E61F: DB 21       ADDB   $21
E621: C4 0F       ANDB   #$0F
E623: 26 03       BNE    $E628
E625: BD 8E 41    JSR    $8E41
E628: BD E6 33    JSR    $E633
E62B: 30 88 30    LEAX   $30,X
E62E: 0A E0       DEC    $E0
E630: 26 E7       BNE    $E619
E632: 39          RTS
E633: EC 13       LDD    -$D,X
E635: 48          ASLA
E636: CE E6 3B    LDU    #jump_table_e63b
E639: 6E D6       JMP    [A,U]	; [indirect_jump]


E643: 6F 1E       CLR    -$2,X
E645: 86 00       LDA    #$00
E647: A7 1F       STA    -$1,X
E649: CC A6 31    LDD    #$A631
E64C: ED 84       STD    ,X
E64E: ED 03       STD    $3,X
E650: E6 05       LDB    $5,X
E652: 26 0F       BNE    $E663
E654: EE 0E       LDU    $E,X
E656: E6 53       LDB    -$D,U
E658: 5A          DECB
E659: 26 07       BNE    $E662
E65B: CC 01 00    LDD    #$0100
E65E: ED 13       STD    -$D,X
E660: E7 15       STB    -$B,X
E662: 39          RTS
E663: CC 01 01    LDD    #$0101
E666: ED 13       STD    -$D,X
E668: 6F 15       CLR    -$B,X
E66A: 39          RTS
E66B: 7F 80 83    CLR    $8083
E66E: E6 6B       LDB    $B,S
E670: 86 04       LDA    #$04
E672: B7 3E 00    STA    bankswitch_3e00
E675: 58          ASLB
E676: CE E6 7E    LDU    #jump_table_e67e
E679: AD D5       JSR    [B,U]	; [indirect_jump]
E67B: 7E 8F 62    JMP    $8F62

E686: CE E6 A8    LDU    #$E6A8                                     
E689: E6 15       LDB    -$B,X                                      
E68B: 58          ASLB
E68C: AD D5       JSR    [B,U]	; [indirect_jump]
E68E: EE 0E       LDU    $E,X
E690: E6 50       LDB    -$10,U
E692: 27 0C       BEQ    $E6A0
E694: E6 53       LDB    -$D,U
E696: C1 02       CMPB   #$02
E698: 26 05       BNE    $E69F
E69A: CC 01 00    LDD    #$0100
E69D: ED 14       STD    -$C,X
E69F: 39          RTS
E6A0: CC 03 00    LDD    #$0300
E6A3: ED 13       STD    -$D,X
E6A5: E7 15       STB    -$B,X
E6A7: 39          RTS

E6AC: CE 59 02    LDU    #$5902                                     
E6AF: E6 12       LDB    -$E,X                                      
E6B1: E6 C5       LDB    B,U
E6B3: 27 07       BEQ    $E6BC
E6B5: CC E6 6B    LDD    #$E66B
E6B8: ED 84       STD    ,X
E6BA: ED 03       STD    $3,X
E6BC: 10 AE 0E    LDY    $E,X
E6BF: E6 25       LDB    $5,Y
E6C1: CE 58 E2    LDU    #$58E2
E6C4: 58          ASLB
E6C5: EC C5       LDD    B,U
E6C7: ED 06       STD    $6,X
E6C9: 6C 15       INC    -$B,X
E6CB: EE 0E       LDU    $E,X
E6CD: E6 06       LDB    $6,X
E6CF: 1D          SEX
E6D0: E3 56       ADDD   -$A,U
E6D2: ED 16       STD    -$A,X
E6D4: E6 07       LDB    $7,X
E6D6: 1D          SEX
E6D7: E3 59       ADDD   -$7,U
E6D9: ED 19       STD    -$7,X
E6DB: 39          RTS
E6DC: E6 15       LDB    -$B,X
E6DE: 58          ASLB
E6DF: CE E6 E4    LDU    #jump_table_e6e4
E6E2: 6E D5       JMP    [B,U]	; [indirect_jump]

E6E8: CC E6 6B    LDD    #$E66B                                  
E6EB: ED 84       STD    ,X                                      
E6ED: ED 03       STD    $3,X                                    
E6EF: 4F          CLRA                                           
E6F0: 5F          CLRB
E6F1: ED 0A       STD    $A,X
E6F3: ED 0C       STD    $C,X
E6F5: 6C 15       INC    -$B,X
E6F7: 8D 12       BSR    $E70B
E6F9: 8D 1D       BSR    $E718
E6FB: BD 8C A7    JSR    $8CA7
E6FE: 24 0A       BCC    $E70A
E700: 1D          SEX
E701: E3 19       ADDD   -$7,X
E703: ED 19       STD    -$7,X
E705: CC 02 00    LDD    #$0200
E708: ED 14       STD    -$C,X
E70A: 39          RTS
E70B: EC 1A       LDD    -$6,X
E70D: E3 0B       ADDD   $B,X
E70F: ED 1A       STD    -$6,X
E711: E6 19       LDB    -$7,X
E713: E9 0A       ADCB   $A,X
E715: E7 19       STB    -$7,X
E717: 39          RTS
E718: EC 0A       LDD    $A,X
E71A: 10 83 FF FC CMPD   #$FFFC
E71E: 2D 0F       BLT    $E72F
E720: EC 0C       LDD    $C,X
E722: C3 ED 4A    ADDD   #$ED4A
E725: ED 0C       STD    $C,X
E727: EC 0A       LDD    $A,X
E729: C9 FF       ADCB   #$FF
E72B: 89 FF       ADCA   #$FF
E72D: ED 0A       STD    $A,X
E72F: 39          RTS
E730: E6 15       LDB    -$B,X
E732: 58          ASLB
E733: CE E7 38    LDU    #jump_table_e738
E736: 6E D5       JMP    [B,U]	; [indirect_jump]

E73C: C6 0A       LDB    #$0A
E73E: E7 08       STB    $8,X
E740: 6C 15       INC    -$B,X
E742: 6A 08       DEC    $8,X
E744: 10 26 A9 2C LBNE   $9074
E748: CE 59 16    LDU    #$5916
E74B: E6 12       LDB    -$E,X
E74D: 58          ASLB
E74E: EB 12       ADDB   -$E,X
E750: 31 C5       LEAY   B,U
E752: EC A4       LDD    ,Y
E754: ED 84       STD    ,X
E756: ED 03       STD    $3,X
E758: E6 22       LDB    $2,Y
E75A: BD 8E BF    JSR    $8EBF
E75D: CC 03 00    LDD    #$0300
E760: ED 14       STD    -$C,X
E762: 39          RTS
E763: E6 11       LDB    -$F,X
E765: 27 36       BEQ    $E79D
E767: BD 90 74    JSR    $9074
E76A: F6 05 00    LDB    $0500
E76D: 54          LSRB
E76E: 24 2D       BCC    $E79D
E770: EC 16       LDD    -$A,X
E772: 93 A0       SUBD   $A0
E774: C3 00 08    ADDD   #$0008
E777: 10 83 00 10 CMPD   #$0010
E77B: 22 20       BHI    $E79D
E77D: EC 19       LDD    -$7,X
E77F: 93 A2       SUBD   $A2
E781: C3 00 08    ADDD   #$0008
E784: 10 83 00 10 CMPD   #$0010
E788: 22 13       BHI    $E79D
E78A: CC 02 00    LDD    #$0200
E78D: ED 13       STD    -$D,X
E78F: E7 15       STB    -$B,X
E791: C6 02       LDB    #$02
E793: E7 1F       STB    -$1,X
E795: CE 5A 66    LDU    #jump_table_5a66
E798: E6 12       LDB    -$E,X
E79A: 58          ASLB
; picking bonus
E79B: 6E D5       JMP    [B,U]	; [indirect_jump]

jump_table_5a66:
	.word	$E79E 
	.word	$E7B2 
	.word	$E7B2 
	.word	$E7B2
	.word	$E7B2
	.word	$E7B2
	.word	$E7C2
	.word	$E7C2
	.word	$E7C2
	.word	$E7C2
	.word	$E7C2
	.word	$E7C2 
	.word	$E7C2
	.word	$E7E9
	.word	$E7E9
	.word	$E7E9
	.word	$E7E9
	.word	$E7E9 
	.word	$E7E9
	.word	$E7E9


E79D: 39          RTS
E79E: CC A6 31    LDD    #$A631
E7A1: ED 03       STD    $3,X
E7A3: BD 79 A6    JSR    $79A6
E7A6: 0F AC       CLR    armour_flag_00ac
E7A8: 34 10       PSHS   X
E7AA: 8E 05 10    LDX    #$0510
E7AD: BD 9A 33    JSR    $9A33
E7B0: 35 90       PULS   X,PC
E7B2: CC A6 31    LDD    #$A631
E7B5: ED 03       STD    $3,X
E7B7: E6 12       LDB    -$E,X
E7B9: 5A          DECB
E7BA: D7 73       STB    weapon_type_0073
E7BC: CC 08 00    LDD    #$0800
E7BF: 7E 69 09    JMP    $6909
E7C2: BD 79 88    JSR    $7988
E7C5: 86 02       LDA    #$02
E7C7: E6 12       LDB    -$E,X
E7C9: C1 0C       CMPB   #$0C
E7CB: 27 06       BEQ    $E7D3
E7CD: 4A          DECA
E7CE: D6 72       LDB    starting_level_0072
E7D0: 26 01       BNE    $E7D3
E7D2: 4A          DECA
E7D3: 48          ASLA
E7D4: 48          ASLA
E7D5: CE 5A 8E    LDU    #$5A8E
E7D8: 33 C6       LEAU   A,U
E7DA: EC C4       LDD    ,U
E7DC: ED 84       STD    ,X
E7DE: ED 03       STD    $3,X
E7E0: C6 02       LDB    #$02
E7E2: E7 1F       STB    -$1,X
E7E4: EC 42       LDD    $2,U
E7E6: 7E 69 09    JMP    $6909
E7E9: BD 79 88    JSR    $7988
E7EC: CE E8 06    LDU    #$E806
E7EF: E6 12       LDB    -$E,X
E7F1: C0 0D       SUBB   #$0D
E7F3: 58          ASLB
E7F4: 58          ASLB
E7F5: 33 C5       LEAU   B,U
E7F7: EC C4       LDD    ,U
E7F9: ED 84       STD    ,X
E7FB: ED 03       STD    $3,X
E7FD: C6 02       LDB    #$02
E7FF: E7 1F       STB    -$1,X
E801: EC 42       LDD    $2,U
E803: 7E 69 09    JMP    $6909
E806: E9 1C       ADCB   -$4,X
E808: 0C 04       INC    $04
E80A: E9 28       ADCB   $8,Y
E80C: 0C 07       INC    $07
E80E: E9 2C       ADCB   $C,Y
E810: 0C 08       INC    $08
E812: E9 30       ADCB   -$10,Y
E814: 0C 09       INC    $09
E816: E9 34       ADCB   -$C,Y
E818: 0C 0A       INC    $0A
E81A: E9 40       ADCB   $0,U
E81C: 0C 0D       INC    $0D
E81E: E9 48       ADCB   $8,U
E820: 0C 12       INC    $12
E822: 58          ASLB
E823: CE E8 28    LDU    #jump_table_e828
E826: 6E D5       JMP    [B,U]	; [indirect_jump]

E82C: C6 1E       LDB    #$1E
E82E: E7 0E       STB    $E,X
E830: 6C 14       INC    -$C,X
E832: 6A 0E       DEC    $E,X
E834: 26 04       BNE    $E83A
E836: 6C 13       INC    -$D,X
E838: 6F 14       CLR    -$C,X
E83A: 39          RTS
E83B: 4F          CLRA
E83C: 5F          CLRB
E83D: ED 10       STD    -$10,X
E83F: ED 13       STD    -$D,X
E841: E7 15       STB    -$B,X
E843: 39          RTS
E844: 0A B6       DEC    $B6
E846: 26 12       BNE    $E85A
E848: 96 72       LDA    starting_level_0072
E84A: 81 06       CMPA   #$06
E84C: 27 03       BEQ    $E851
E84E: BD 7A 66    JSR    $7A66
E851: C6 02       LDB    #$02
E853: D7 08       STB    $08
E855: 4F          CLRA
E856: 97 0B       STA    $0B
E858: 97 0E       STA    $0E
E85A: 39          RTS
E85B: E6 15       LDB    -$B,X
E85D: CE E8 63    LDU    #jump_table_e863
E860: 58          ASLB
E861: 6E D5       JMP    [B,U]	; [indirect_jump]

E867: C6 03       LDB    #$03
E869: E7 1F       STB    -$1,X
E86B: CE 5A 9A    LDU    #$5A9A
E86E: EC 16       LDD    -$A,X
E870: 10 93 A0    CMPD   $A0
E873: 23 03       BLS    $E878
E875: CE 5A C0    LDU    #$5AC0
E878: EF 84       STU    ,X
E87A: 6F 02       CLR    $2,X
E87C: BD 90 74    JSR    $9074
E87F: C6 12       LDB    #$12
E881: E7 1E       STB    -$2,X
E883: 6C 15       INC    -$B,X
E885: 39          RTS
E886: E6 15       LDB    -$B,X
E888: CE E8 8E    LDU    #jump_table_e88e
E88B: 58          ASLB
E88C: 6E D5       JMP    [B,U]	; [indirect_jump]

E892: C6 03       LDB    #$03
E894: E7 1F       STB    -$1,X
E896: CC 5A E6    LDD    #$5AE6
E899: ED 84       STD    ,X
E89B: 6F 02       CLR    $2,X
E89D: BD 90 74    JSR    $9074
E8A0: C6 24       LDB    #$24
E8A2: E7 1E       STB    -$2,X
E8A4: 6C 15       INC    -$B,X
E8A6: 39          RTS
E8A7: E6 15       LDB    -$B,X
E8A9: CE E8 AF    LDU    #jump_table_e8af
E8AC: 58          ASLB
E8AD: 6E D5       JMP    [B,U]	; [indirect_jump]

E8B5: 6A 1E       DEC    -$2,X
E8B7: 10 26 A7 B9 LBNE   $9074
E8BB: C6 04       LDB    #$04
E8BD: E7 1F       STB    -$1,X
E8BF: CC 5B 24    LDD    #$5B24
E8C2: ED 84       STD    ,X
E8C4: 6F 02       CLR    $2,X
E8C6: BD 90 74    JSR    $9074
E8C9: C6 12       LDB    #$12
E8CB: E7 1E       STB    -$2,X
E8CD: 6C 15       INC    -$B,X
E8CF: 39          RTS
E8D0: E6 15       LDB    -$B,X
E8D2: CE E8 D8    LDU    #jump_table_e8d8
E8D5: 58          ASLB
E8D6: 6E D5       JMP    [B,U]	; [indirect_jump]

E8DE: C6 03       LDB    #$03
E8E0: E7 1F       STB    -$1,X
E8E2: CC 5B 89    LDD    #$5B89
E8E5: ED 84       STD    ,X
E8E7: 6F 02       CLR    $2,X
E8E9: BD 90 74    JSR    $9074
E8EC: C6 03       LDB    #$03
E8EE: E7 1E       STB    -$2,X
E8F0: 6C 15       INC    -$B,X
E8F2: 39          RTS
E8F3: 6A 1E       DEC    -$2,X
E8F5: 10 26 A7 7B LBNE   $9074
E8F9: C6 06       LDB    #$06
E8FB: E7 1F       STB    -$1,X
E8FD: CC 5B 8F    LDD    #$5B8F
E900: ED 84       STD    ,X
E902: 6F 02       CLR    $2,X
E904: BD 90 74    JSR    $9074
E907: C6 12       LDB    #$12
E909: E7 1E       STB    -$2,X
E90B: 6C 15       INC    -$B,X
E90D: 6A 1E       DEC    -$2,X
E90F: 10 26 A7 61 LBNE   $9074
E913: 6C 14       INC    -$C,X
E915: 6F 15       CLR    -$B,X
E917: 39          RTS

E94F: FF C6 02    STU    $C602
E952: F7 3E 00    STB    bankswitch_3e00
E955: 8D 18       BSR    $E96F
E957: BD EA 2E    JSR    $EA2E
E95A: C6 04       LDB    #$04
E95C: F7 3E 00    STB    bankswitch_3e00
E95F: BD ED 27    JSR    $ED27
E962: BD ED 96    JSR    $ED96
E965: BD EE B9    JSR    $EEB9
E968: BD EE 00    JSR    $EE00
E96B: BD EE D0    JSR    $EED0
E96E: 39          RTS
E96F: 8E 06 70    LDX    #$0670
E972: E6 10       LDB    -$10,X
E974: 27 F8       BEQ    $E96E
E976: EC 13       LDD    -$D,X
E978: 48          ASLA
E979: CE E9 7E    LDU    #jump_table_e97e
E97C: 6E D6       JMP    [A,U]	; [indirect_jump]

E982: CE E9 88    LDU    #$E988
E985: 58          ASLB
E986: 6E D5       JMP    [B,U]	; [indirect_jump]

E98C: E6 84       LDB    ,X                                        
E98E: 4F          CLRA                                             
E98F: 58          ASLB
E990: 49          ROLA
E991: CE 4F CE    LDU    #$4FCE
E994: EE CB       LDU    D,U
E996: E6 C0       LDB    ,U+
E998: 27 07       BEQ    $E9A1
E99A: E7 1A       STB    -$6,X
E99C: EF 16       STU    -$A,X
E99E: 6C 14       INC    -$C,X
E9A0: 39          RTS
E9A1: 4F          CLRA
E9A2: 5F          CLRB
E9A3: ED 10       STD    -$10,X
E9A5: ED 13       STD    -$D,X
E9A7: 39          RTS
E9A8: EE 16       LDU    -$A,X
E9AA: 8D 40       BSR    $E9EC
E9AC: D7 E2       STB    $E2
E9AE: C6 20       LDB    #$20
E9B0: 3D          MUL
E9B1: C3 06 90    ADDD   #$0690
E9B4: 1F 02       TFR    D,Y
E9B6: D6 E2       LDB    $E2
E9B8: 58          ASLB
E9B9: 58          ASLB
E9BA: 58          ASLB
E9BB: 58          ASLB
E9BC: E7 3C       STB    -$4,Y
E9BE: EC 84       LDD    ,X
E9C0: A7 24       STA    $4,Y
E9C2: 1D          SEX
E9C3: ED A4       STD    ,Y
E9C5: 8D 25       BSR    $E9EC
E9C7: EF 16       STU    -$A,X
E9C9: A7 22       STA    $2,Y
E9CB: EB 3C       ADDB   -$4,Y
E9CD: E7 23       STB    $3,Y
E9CF: 4F          CLRA
E9D0: 5F          CLRB
E9D1: A7 3C       STA    -$4,Y
E9D3: ED 33       STD    -$D,Y
E9D5: 4C          INCA
E9D6: A7 30       STA    -$10,Y
E9D8: 6A 1A       DEC    -$6,X
E9DA: 26 0F       BNE    $E9EB
E9DC: E6 84       LDB    ,X
E9DE: 27 07       BEQ    $E9E7
E9E0: 4F          CLRA
E9E1: 5F          CLRB
E9E2: ED 13       STD    -$D,X
E9E4: ED 10       STD    -$10,X
E9E6: 39          RTS
E9E7: 6C 13       INC    -$D,X
E9E9: 6F 14       CLR    -$C,X
E9EB: 39          RTS
E9EC: E6 C4       LDB    ,U
E9EE: A6 C0       LDA    ,U+
E9F0: 44          LSRA
E9F1: 44          LSRA
E9F2: 44          LSRA
E9F3: 44          LSRA
E9F4: C4 0F       ANDB   #$0F
E9F6: 39          RTS
E9F7: 58          ASLB
E9F8: CE E9 FD    LDU    #jump_table_e9fd
E9FB: 6E D5       JMP    [B,U]	; [indirect_jump]

EA01: C6 0A       LDB    #$0A
EA03: E7 1F       STB    -$1,X
EA05: 6C 14       INC    -$C,X
EA07: 6A 1F       DEC    -$1,X
EA09: 26 22       BNE    $EA2D
EA0B: C6 02       LDB    #$02
EA0D: F7 3E 00    STB    bankswitch_3e00
EA10: CE 43 00    LDU    #$4300
EA13: DC 91       LDD    $91
EA15: C3 00 01    ADDD   #$0001
EA18: 58          ASLB
EA19: 49          ROLA
EA1A: 58          ASLB
EA1B: 49          ROLA
EA1C: 33 CB       LEAU   D,U
EA1E: A6 43       LDA    $3,U
EA20: C6 01       LDB    #$01
EA22: ED 84       STD    ,X
EA24: 4F          CLRA
EA25: 5F          CLRB
EA26: ED 13       STD    -$D,X
EA28: C6 04       LDB    #$04
EA2A: F7 3E 00    STB    bankswitch_3e00
EA2D: 39          RTS
EA2E: 8E 06 90    LDX    #$0690
EA31: C6 10       LDB    #$10
EA33: D7 E0       STB    $E0
EA35: E6 10       LDB    -$10,X
EA37: 27 08       BEQ    $EA41
EA39: EC 13       LDD    -$D,X
EA3B: 48          ASLA
EA3C: CE EA 49    LDU    #jump_table_ea49
EA3F: AD D6       JSR    [A,U]	; [indirect_jump]
EA41: 30 88 20    LEAX   $20,X
EA44: 0A E0       DEC    $E0
EA46: 26 ED       BNE    $EA35
EA48: 39          RTS

EA4F: E6 05       LDB    $5,X
EA51: 58          ASLB
EA52: 58          ASLB
EA53: 58          ASLB
EA54: CE 5C 33    LDU    #$5C33
EA57: 33 C5       LEAU   B,U
EA59: D6 9A       LDB    $9A
EA5B: C4 30       ANDB   #$30
EA5D: 54          LSRB
EA5E: 54          LSRB
EA5F: 54          LSRB
EA60: EE C5       LDU    B,U
EA62: EF 0C       STU    $C,X
EA64: E6 1C       LDB    -$4,X
EA66: E7 1D       STB    -$3,X
EA68: 6C 13       INC    -$D,X
EA6A: 39          RTS

EA7B: 58          ASLB
EA7C: CE EA 81    LDU    #jump_table_ea81
EA7F: 6E D5       JMP    [B,U]	; [indirect_jump]

EA88: E6 05       LDB    $5,X
EA8A: 96 B5       LDA    $B5
EA8C: 27 07       BEQ    $EA95
EA8E: CE EA 6B    LDU    #$EA6B
EA91: A6 C5       LDA    B,U
EA93: 26 F2       BNE    $EA87
EA95: 58          ASLB
EA96: CE 51 78    LDU    #$5178
EA99: EE C5       LDU    B,U
EA9B: E6 03       LDB    $3,X
EA9D: 58          ASLB
EA9E: EE C5       LDU    B,U
EAA0: E6 C0       LDB    ,U+
EAA2: E7 1A       STB    -$6,X
EAA4: E7 1B       STB    -$5,X
EAA6: EF 0E       STU    $E,X
EAA8: 6C 14       INC    -$C,X
EAAA: E6 05       LDB    $5,X
EAAC: 58          ASLB
EAAD: CE EA E8    LDU    #jump_table_eae8
EAB0: 6E D5       JMP    [B,U]	; [indirect_jump]
EAB2: 39          RTS
EAB3: D6 93       LDB    $93
EAB5: 27 FB       BEQ    $EAB2
EAB7: CE 00 30    LDU    #$0030
EABA: E6 05       LDB    $5,X
EABC: E6 C5       LDB    B,U
EABE: 27 F2       BEQ    $EAB2
EAC0: E6 05       LDB    $5,X
EAC2: 58          ASLB
EAC3: CE EA C8    LDU    #jump_table_eac8
EAC6: 6E D5       JMP    [B,U]	; [indirect_jump]

EB08: E6 02       LDB    $2,X
EB0A: C5 02       BITB   #$02
EB0C: 27 26       BEQ    $EB34
EB0E: A6 04       LDA    $4,X
EB10: CE EB 3C    LDU    #$EB3C
EB13: D6 72       LDB    starting_level_0072
EB15: A0 C5       SUBA   B,U
EB17: 97 E5       STA    $E5
EB19: 10 8E EF 2D LDY    #$EF2D
EB1D: 84 07       ANDA   #$07
EB1F: A6 A6       LDA    A,Y
EB21: 97 E6       STA    $E6
EB23: D6 E5       LDB    $E5
EB25: 54          LSRB
EB26: 54          LSRB
EB27: 54          LSRB
EB28: 33 16       LEAU   -$A,X
EB2A: A4 C5       ANDA   B,U
EB2C: 26 07       BNE    $EB35
EB2E: 96 E6       LDA    $E6
EB30: AA C5       ORA    B,U
EB32: A7 C5       STA    B,U
EB34: 39          RTS
EB35: 4F          CLRA
EB36: 5F          CLRB
EB37: ED 10       STD    -$10,X
EB39: ED 13       STD    -$D,X
EB3B: 39          RTS
EB3C: 00 0E       NEG    $0E
EB3E: 25 45       BCS    $EB85
EB40: 51          NEGB
EB41: 60 6A       NEG    $A,S
EB43: BD 8D FC    JSR    $8DFC
EB46: EE 0E       LDU    $E,X
EB48: E6 02       LDB    $2,X
EB4A: 54          LSRB
EB4B: 25 0E       BCS    $EB5B
EB4D: EC C1       LDD    ,U++
EB4F: D3 9C       ADDD   $9C
EB51: ED 36       STD    -$A,Y
EB53: EC C1       LDD    ,U++
EB55: D3 9E       ADDD   $9E
EB57: ED 39       STD    -$7,Y
EB59: 20 08       BRA    $EB63
EB5B: EC C1       LDD    ,U++
EB5D: ED 36       STD    -$A,Y
EB5F: EC C1       LDD    ,U++
EB61: ED 39       STD    -$7,Y
EB63: E6 C0       LDB    ,U+
EB65: A6 C0       LDA    ,U+
EB67: A7 1F       STA    -$1,X
EB69: EF 0E       STU    $E,X
EB6B: 8D 37       BSR    $EBA4
EB6D: 6C 14       INC    -$C,X
EB6F: 39          RTS
EB70: E6 04       LDB    $4,X
EB72: F1 06 70    CMPB   $0670
EB75: 26 26       BNE    $EB9D
EB77: E6 05       LDB    $5,X
EB79: 96 B5       LDA    $B5
EB7B: 27 07       BEQ    $EB84
EB7D: CE EA 6B    LDU    #$EA6B
EB80: A6 C5       LDA    B,U
EB82: 26 19       BNE    $EB9D
EB84: CE 00 30    LDU    #$0030
EB87: E6 05       LDB    $5,X
EB89: E6 C5       LDB    B,U
EB8B: 27 0F       BEQ    $EB9C
EB8D: 6A 1F       DEC    -$1,X
EB8F: 26 0B       BNE    $EB9C
EB91: 6A 1A       DEC    -$6,X
EB93: 26 05       BNE    $EB9A
EB95: 6C 13       INC    -$D,X
EB97: 6F 14       CLR    -$C,X
EB99: 39          RTS
EB9A: 6A 14       DEC    -$C,X
EB9C: 39          RTS
EB9D: 4F          CLRA
EB9E: 5F          CLRB
EB9F: ED 13       STD    -$D,X
EBA1: ED 10       STD    -$10,X
EBA3: 39          RTS
EBA4: E7 32       STB    -$E,Y
EBA6: 4F          CLRA
EBA7: 5F          CLRB
EBA8: ED 33       STD    -$D,Y
EBAA: E7 35       STB    -$B,Y
EBAC: E7 31       STB    -$F,Y
EBAE: 4C          INCA
EBAF: ED 30       STD    -$10,Y
EBB1: E6 05       LDB    $5,X
EBB3: E7 25       STB    $5,Y
EBB5: CE 00 30    LDU    #$0030
EBB8: 6A C5       DEC    B,U
EBBA: 0A B0       DEC    $B0
EBBC: 26 2D       BNE    $EBEB
EBBE: C6 06       LDB    #$06
EBC0: D7 B0       STB    $B0
EBC2: CE 15 E2    LDU    #$15E2
EBC5: E6 50       LDB    -$10,U
EBC7: 26 22       BNE    $EBEB
EBC9: 4F          CLRA
EBCA: 5F          CLRB
EBCB: ED 53       STD    -$D,U
EBCD: E7 55       STB    -$B,U
EBCF: 4C          INCA
EBD0: ED 50       STD    -$10,U
EBD2: E7 45       STB    $5,U
EBD4: 10 AF 4E    STY    $E,U
EBD7: 0C 7D       INC    $7D
EBD9: D6 7D       LDB    $7D
EBDB: C1 07       CMPB   #$07
EBDD: 26 03       BNE    $EBE2
EBDF: 5F          CLRB
EBE0: D7 7D       STB    $7D
EBE2: 10 8E EB EC LDY    #jump_table_ebec
EBE6: 58          ASLB
EBE7: AD B5       JSR    [B,Y]	; [indirect_jump]
EBE9: E7 52       STB    -$E,U
EBEB: 39          RTS

EBFA: C6 0C       LDB    #$0C
EBFC: 96 7E       LDA    $7E
EBFE: 8B 15       ADDA   #$15
EC00: 97 7E       STA    $7E
EC02: 25 04       BCS    $EC08
EC04: C6 06       LDB    #$06
EC06: DB 72       ADDB   starting_level_0072
EC08: 39          RTS
EC09: 10 8E EF 2D LDY    #$EF2D
EC0D: D6 73       LDB    weapon_type_0073
EC0F: E6 A5       LDB    B,Y
EC11: 53          COMB
EC12: D7 E2       STB    $E2
EC14: 8D 1D       BSR    $EC33
EC16: D6 E2       LDB    $E2
EC18: D4 E1       ANDB   $E1
EC1A: 27 F8       BEQ    $EC14
EC1C: 86 05       LDA    #$05
EC1E: 97 E1       STA    $E1
EC20: 4F          CLRA
EC21: 58          ASLB
EC22: 25 06       BCS    $EC2A
EC24: 4C          INCA
EC25: 0A E1       DEC    $E1
EC27: 26 F8       BNE    $EC21
EC29: 4A          DECA
EC2A: 4C          INCA
EC2B: 1F 89       TFR    A,B
EC2D: 39          RTS
EC2E: C6 0D       LDB    #$0D
EC30: DB 72       ADDB   starting_level_0072
EC32: 39          RTS
EC33: 34 40       PSHS   U
EC35: CE EC 52    LDU    #$EC52
EC38: D6 72       LDB    starting_level_0072
EC3A: 58          ASLB
EC3B: EE C5       LDU    B,U
EC3D: 10 8E 00 7D LDY    #$007D
EC41: 0F E1       CLR    $E1
EC43: C6 05       LDB    #$05
EC45: A6 A2       LDA    ,-Y
EC47: AB C2       ADDA   ,-U
EC49: A7 A4       STA    ,Y
EC4B: 06 E1       ROR    $E1
EC4D: 5A          DECB
EC4E: 26 F5       BNE    $EC45
EC50: 35 C0       PULS   U,PC
EC52: EC 65       LDD    $5,S
EC54: EC 6A       LDD    $A,S
EC56: EC 6F       LDD    $F,S
EC58: EC 74       LDD    -$C,S
EC5A: EC 79       LDD    -$7,S
EC5C: EC 7E       LDD    -$2,S
EC5E: EC 83       LDD    ,--X
EC60: 66 40       ROR    $0,U
EC62: 00 00       NEG    $00
EC64: 59          ROLB
EC65: 40          NEGA
EC66: 40          NEGA
EC67: 33 00       LEAU   $0,X
EC69: 4C          INCA
EC6A: 19          DAA
EC6B: 40          NEGA
EC6C: 00 33       NEG    $33
EC6E: 66 00       ROR    $0,X
EC70: 40          NEGA
EC71: 0C 6E       INC    $6E
EC73: 4C          INCA
EC74: 33 33       LEAU   -$D,Y
EC76: 33 80       LEAU   ,X+
EC78: 00 00       NEG    $00
EC7A: 33 19       LEAU   -$7,X
EC7C: 80 19       SUBA   #$19
EC7E: 00 40       NEG    $40
EC80: 19          DAA
EC81: 80 19       SUBA   #$19
EC83: BD 8D FC    JSR    $8DFC
EC86: EC 06       LDD    $6,X
EC88: ED 36       STD    -$A,Y
EC8A: EC 08       LDD    $8,X
EC8C: C3 00 10    ADDD   #$0010
EC8F: ED 39       STD    -$7,Y
EC91: 4F          CLRA
EC92: 5F          CLRB
EC93: ED 33       STD    -$D,Y
EC95: E7 35       STB    -$B,Y
EC97: E7 32       STB    -$E,Y
EC99: 4C          INCA
EC9A: ED 30       STD    -$10,Y
EC9C: E6 05       LDB    $5,X
EC9E: E7 25       STB    $5,Y
ECA0: 0A 37       DEC    $37
ECA2: 4F          CLRA
ECA3: 5F          CLRB
ECA4: ED 10       STD    -$10,X
ECA6: ED 13       STD    -$D,X
ECA8: 39          RTS
ECA9: BD 8D FC    JSR    $8DFC
ECAC: EE 0E       LDU    $E,X
ECAE: DC 9C       LDD    $9C
ECB0: C3 00 80    ADDD   #$0080
ECB3: 6D 84       TST    ,X
ECB5: 2B 04       BMI    $ECBB
ECB7: E3 C1       ADDD   ,U++
ECB9: 20 02       BRA    $ECBD
ECBB: A3 C1       SUBD   ,U++
ECBD: ED 36       STD    -$A,Y
ECBF: 33 42       LEAU   $2,U
ECC1: DC A2       LDD    $A2
ECC3: ED 39       STD    -$7,Y
ECC5: E6 C0       LDB    ,U+
ECC7: A6 C0       LDA    ,U+
ECC9: A7 1F       STA    -$1,X
ECCB: EF 0E       STU    $E,X
ECCD: A6 1B       LDA    -$5,X
ECCF: A0 1A       SUBA   -$6,X
ECD1: A7 2B       STA    $B,Y
ECD3: BD EB A4    JSR    $EBA4
ECD6: 6A 1A       DEC    -$6,X
ECD8: 26 05       BNE    $ECDF
ECDA: 6C 13       INC    -$D,X
ECDC: 6F 14       CLR    -$C,X
ECDE: 39          RTS
ECDF: 6C 14       INC    -$C,X
ECE1: 39          RTS
ECE2: 58          ASLB
ECE3: CE EC E8    LDU    #jump_table_ece8
ECE6: 6E D5       JMP    [B,U]	; [indirect_jump]

ECEE: E6 02       LDB    $2,X
ECF0: C5 02       BITB   #$02
ECF2: 26 2C       BNE    $ED20
ECF4: EE 0C       LDU    $C,X
ECF6: E6 C0       LDB    ,U+
ECF8: E7 0B       STB    $B,X
ECFA: EF 0C       STU    $C,X
ECFC: 6C 14       INC    -$C,X
ECFE: 6A 0B       DEC    $B,X
ED00: 26 10       BNE    $ED12
ED02: EE 0C       LDU    $C,X
ED04: E6 C0       LDB    ,U+
ED06: 26 04       BNE    $ED0C
ED08: EE C4       LDU    ,U
ED0A: E6 C0       LDB    ,U+
ED0C: E7 0B       STB    $B,X
ED0E: EF 0C       STU    $C,X
ED10: 6C 14       INC    -$C,X
ED12: 39          RTS
ED13: E6 04       LDB    $4,X
ED15: F1 06 70    CMPB   $0670
ED18: 26 06       BNE    $ED20
ED1A: CC 01 00    LDD    #$0100
ED1D: ED 13       STD    -$D,X
ED1F: 39          RTS
ED20: 4F          CLRA
ED21: 5F          CLRB
ED22: ED 13       STD    -$D,X
ED24: ED 10       STD    -$10,X
ED26: 39          RTS
ED27: BD ED 58    JSR    $ED58
ED2A: D6 21       LDB    $21
ED2C: C4 3F       ANDB   #$3F
ED2E: 26 27       BNE    $ED57
ED30: DC AA       LDD    time_00aa
ED32: 83 00 01    SUBD   #$0001
ED35: DD AA       STD    time_00aa
ED37: 26 0F       BNE    $ED48
ED39: BD 7A 29    JSR    $7A29
ED3C: C6 01       LDB    #$01
ED3E: D7 AC       STB    armour_flag_00ac
ED40: CC 03 03    LDD    #$0303
ED43: FD 05 03    STD    $0503
ED46: DC AA       LDD    time_00aa
ED48: 10 83 00 0F CMPD   #$000F
ED4C: 26 03       BNE    $ED51
ED4E: BD 79 BF    JSR    $79BF
ED51: CC 0D 00    LDD    #$0D00
ED54: 7E 69 09    JMP    $6909
ED57: 39          RTS
ED58: D6 81       LDB    $81
ED5A: 58          ASLB
ED5B: 8E ED 60    LDX    #jump_table_ed60
ED5E: 6E 95       JMP    [B,X]	; [indirect_jump]

ED64: D6 72       LDB    starting_level_0072
ED66: 58          ASLB
ED67: 8E ED 88    LDX    #$ED88
ED6A: 30 85       LEAX   B,X
ED6C: DC 9C       LDD    $9C
ED6E: 10 A3 84    CMPD   ,X
ED71: 23 14       BLS    $ED87
ED73: 8E 6E BB    LDX    #$6EBB
ED76: D6 72       LDB    starting_level_0072
ED78: 58          ASLB
ED79: EC 85       LDD    B,X
ED7B: DD AA       STD    time_00aa
ED7D: C6 01       LDB    #$01
ED7F: D7 81       STB    $81
ED81: CC 0D 00    LDD    #$0D00
ED84: 7E 69 09    JMP    $6909
ED87: 39          RTS

EDAB: 8E ED B0    LDX    #jump_table_edb0
EDAE: 6E 95       JMP    [B,X]	; [indirect_jump]

EDB6: 8D 32       BSR    $EDEA
EDB8: 24 0A       BCC    $EDC4
EDBA: DE 55       LDU    $55
EDBC: 33 44       LEAU   $4,U
EDBE: EC C4       LDD    ,U
EDC0: DD 64       STD    $64
EDC2: 0C 63       INC    $63
EDC4: 39          RTS
EDC5: 8D 23       BSR    $EDEA
EDC7: 24 FB       BCC    $EDC4
EDC9: 8D 0C       BSR    $EDD7
EDCB: 0C 63       INC    $63
EDCD: 39          RTS
EDCE: D6 54       LDB    $54
EDD0: 54          LSRB
EDD1: 24 F1       BCC    $EDC4
EDD3: 8D 15       BSR    $EDEA
EDD5: 24 ED       BCC    $EDC4
EDD7: DE 55       LDU    $55
EDD9: 33 48       LEAU   $8,U
EDDB: 96 65       LDA    $65
EDDD: AB 41       ADDA   $1,U
EDDF: 19          DAA
EDE0: 97 65       STA    $65
EDE2: 96 64       LDA    $64
EDE4: A9 C4       ADCA   ,U
EDE6: 19          DAA
EDE7: 97 64       STA    $64
EDE9: 39          RTS
EDEA: DC 64       LDD    $64
EDEC: 10 93 68    CMPD   $68
EDEF: 22 0D       BHI    $EDFE
EDF1: 0C 60       INC    nb_lives_0060
EDF3: CC 07 00    LDD    #$0700
EDF6: BD 69 09    JSR    $6909
EDF9: BD 7A 3E    JSR    $7A3E
EDFC: 53          COMB
EDFD: 39          RTS
EDFE: 5F          CLRB
EDFF: 39          RTS
EE00: D6 21       LDB    $21
EE02: C5 07       BITB   #$07
EE04: 27 01       BEQ    $EE07
EE06: 39          RTS
EE07: C4 18       ANDB   #$18
EE09: 54          LSRB
EE0A: 54          LSRB
EE0B: 96 72       LDA    starting_level_0072
EE0D: 48          ASLA
EE0E: CE EE 13    LDU    #jump_table_ee13
EE11: 6E D6       JMP    [A,U]	; [indirect_jump]

	
EE21: CE EE 7F    LDU    #$EE7F
EE24: 8E EE 9C    LDX    #$EE9C
EE27: EE C5       LDU    B,U
EE29: AE 85       LDX    B,X
EE2B: C6 21       LDB    #$21
EE2D: 86 07       LDA    #$07
EE2F: 7E EE 44    JMP    $EE44

EE32: CE EE 57    LDU    #$EE57
EE35: 8E EE 6B    LDX    #$EE6B
EE38: EE C5       LDU    B,U
EE3A: AE 85       LDX    B,X
EE3C: C6 2A       LDB    #$2A
EE3E: 86 04       LDA    #$04
EE40: 7E EE 44    JMP    $EE44
EE43: 39          RTS
EE44: 10 8E 16 32 LDY    #$1632
EE48: 31 A5       LEAY   B,Y
EE4A: E6 80       LDB    ,X+
EE4C: E7 A8 40    STB    $40,Y
EE4F: E6 C0       LDB    ,U+
EE51: E7 A0       STB    ,Y+
EE53: 4A          DECA
EE54: 26 F4       BNE    $EE4A
EE56: 39          RTS

EEB9: D6 21       LDB    $21
EEBB: 26 12       BNE    $EECF
EEBD: 96 20       LDA    $20
EEBF: 54          LSRB
EEC0: 25 0D       BCS    $EECF
EEC2: DC 9A       LDD    $9A
EEC4: C3 00 6B    ADDD   #$006B
EEC7: 81 3F       CMPA   #$3F
EEC9: 23 02       BLS    $EECD
EECB: 86 3F       LDA    #$3F
EECD: DD 9A       STD    $9A
EECF: 39          RTS
EED0: D6 72       LDB    starting_level_0072
EED2: 58          ASLB
EED3: 8E EE D8    LDX    #jump_table_eed8
EED6: 6E 95       JMP    [B,X]	; [indirect_jump]

EEE6: DC 58       LDD    $58
EEE8: C3 01 00    ADDD   #$0100
EEEB: 10 93 9C    CMPD   $9C
EEEE: 22 07       BHI    $EEF7
EEF0: DC 9C       LDD    $9C
EEF2: 83 01 00    SUBD   #$0100
EEF5: DD 58       STD    $58
EEF7: 39          RTS
EEF8: 96 5E       LDA    $5E
EEFA: 8B 02       ADDA   #$02
EEFC: 91 9E       CMPA   $9E
EEFE: 22 F7       BHI    $EEF7
EF00: 96 9E       LDA    $9E
EF02: 80 02       SUBA   #$02
EF04: 97 5E       STA    $5E
EF06: 39          RTS
EF07: D6 AD       LDB    $AD
EF09: 27 0B       BEQ    $EF16
EF0B: 0A AD       DEC    $AD
EF0D: 26 07       BNE    $EF16
EF0F: 8E 05 10    LDX    #$0510
EF12: EC 84       LDD    ,X
EF14: ED 03       STD    $3,X
EF16: 39          RTS
EF17: 8D EE       BSR    $EF07
EF19: D6 21       LDB    $21
EF1B: 54          LSRB
EF1C: 25 06       BCS    $EF24
EF1E: BD F0 FB    JSR    $F0FB
EF21: 7E F6 A2    JMP    $F6A2
EF24: BD F3 CE    JSR    $F3CE
EF27: BD F5 30    JSR    $F530
EF2A: 7E F7 62    JMP    $F762

EF4A: E6 10       LDB    -$10,X
EF4C: E4 11       ANDB   -$F,X
EF4E: 27 F9       BEQ    $EF49
EF50: 4F          CLRA
EF51: D6 E0       LDB    $E0
EF53: 5A          DECB
EF54: 54          LSRB
EF55: 49          ROLA
EF56: 54          LSRB
EF57: 49          ROLA
EF58: 54          LSRB
EF59: 49          ROLA
EF5A: CE EF 2D    LDU    #$EF2D
EF5D: A6 C6       LDA    A,U
EF5F: CB 20       ADDB   #$20
EF61: DD E8       STD    $E8
EF63: 34 10       PSHS   X
EF65: 33 84       LEAU   ,X
EF67: 8E F0 36    LDX    #$F036
EF6A: D6 73       LDB    weapon_type_0073
EF6C: 58          ASLB
EF6D: AE 85       LDX    B,X
EF6F: E6 45       LDB    $5,U
EF71: 58          ASLB
EF72: 58          ASLB
EF73: 58          ASLB
EF74: 3A          ABX
EF75: 9F E2       STX    $E2
EF77: 8E EF 2D    LDX    #$EF2D
EF7A: D6 73       LDB    weapon_type_0073
EF7C: A6 85       LDA    B,X
EF7E: 97 E4       STA    $E4
EF80: 10 8E 05 40 LDY    #$0540
EF84: C6 04       LDB    #$04
EF86: D7 E1       STB    $E1
EF88: E6 30       LDB    -$10,Y
EF8A: E4 31       ANDB   -$F,Y
EF8C: 10 27 00 83 LBEQ   $F013
EF90: DC E8       LDD    $E8
EF92: 30 A5       LEAX   B,Y
EF94: 9F E6       STX    $E6
EF96: A4 84       ANDA   ,X
EF98: 27 79       BEQ    $F013
EF9A: 9E E2       LDX    $E2
EF9C: EC 56       LDD    -$A,U
EF9E: A3 36       SUBD   -$A,Y
EFA0: E3 84       ADDD   ,X
EFA2: 10 A3 02    CMPD   $2,X
EFA5: 22 6C       BHI    $F013
EFA7: EC 59       LDD    -$7,U
EFA9: A3 39       SUBD   -$7,Y
EFAB: E3 04       ADDD   $4,X
EFAD: 10 A3 06    CMPD   $6,X
EFB0: 22 61       BHI    $F013
EFB2: 8E EF 35    LDX    #$EF35
EFB5: E6 45       LDB    $5,U
EFB7: A6 85       LDA    B,X
EFB9: 95 E4       BITA   $E4
EFBB: 27 2C       BEQ    $EFE9
EFBD: A6 50       LDA    -$10,U
EFBF: 2B 28       BMI    $EFE9
EFC1: 8E F0 1E    LDX    #$F01E
EFC4: A6 85       LDA    B,X
EFC6: 27 08       BEQ    $EFD0
EFC8: C6 01       LDB    #$01
EFCA: E7 52       STB    -$E,U
EFCC: 6A C6       DEC    A,U
EFCE: 26 19       BNE    $EFE9
EFD0: 8E F0 D8    LDX    #$F0D8
EFD3: E6 45       LDB    $5,U
EFD5: E6 85       LDB    B,X
EFD7: 86 0C       LDA    #$0C
EFD9: 34 20       PSHS   Y
EFDB: BD 69 09    JSR    $6909
EFDE: 35 20       PULS   Y
EFE0: 68 50       ASL    -$10,U
EFE2: CC 02 00    LDD    #$0200
EFE5: ED 53       STD    -$D,U
EFE7: E7 55       STB    -$B,U
EFE9: 8E F0 EB    LDX    #$F0EB
EFEC: D6 73       LDB    weapon_type_0073
EFEE: E6 85       LDB    B,X
EFF0: 26 0B       BNE    $EFFD
EFF2: 9E E6       LDX    $E6
EFF4: D6 E8       LDB    $E8
EFF6: 53          COMB
EFF7: E4 84       ANDB   ,X
EFF9: E7 84       STB    ,X
EFFB: 20 16       BRA    $F013
EFFD: 68 30       ASL    -$10,Y
EFFF: 5F          CLRB
F000: E7 35       STB    -$B,Y
F002: A6 53       LDA    -$D,U
F004: 81 02       CMPA   #$02
F006: 27 07       BEQ    $F00F
F008: 5C          INCB
F009: A6 50       LDA    -$10,U
F00B: 2B 02       BMI    $F00F
F00D: C6 03       LDB    #$03
F00F: 86 02       LDA    #$02
F011: ED 33       STD    -$D,Y
F013: 31 A8 40    LEAY   $40,Y
F016: 0A E1       DEC    $E1
F018: 10 26 FF 6C LBNE   $EF88
F01C: 35 90       PULS   X,PC

F0FF: 10 8E 05 10 LDY    #$0510
F103: E6 30       LDB    -$10,Y
F105: 54          LSRB
F106: 24 4F       BCC    $F157
F108: CE 08 90    LDU    #$0890
F10B: C6 28       LDB    #$28
F10D: D7 E0       STB    $E0
F10F: E6 50       LDB    -$10,U
F111: E4 51       ANDB   -$F,U
F113: 27 3B       BEQ    $F150
F115: 8E F1 58    LDX    #$F158
F118: E6 5F       LDB    -$1,U
F11A: 58          ASLB
F11B: AE 85       LDX    B,X
F11D: E6 2F       LDB    $F,Y
F11F: 27 04       BEQ    $F125
F121: 30 89 00 98 LEAX   $0098,X
F125: E6 45       LDB    $5,U
F127: 58          ASLB
F128: 58          ASLB
F129: 58          ASLB
F12A: 3A          ABX
F12B: EC 59       LDD    -$7,U
F12D: A3 39       SUBD   -$7,Y
F12F: E3 04       ADDD   $4,X
F131: 10 A3 06    CMPD   $6,X
F134: 22 1A       BHI    $F150
F136: EC 56       LDD    -$A,U
F138: A3 36       SUBD   -$A,Y
F13A: E3 84       ADDD   ,X
F13C: 10 A3 02    CMPD   $2,X
F13F: 22 0F       BHI    $F150	; always branch: invincibility
F141: A3 84       SUBD   ,X
F143: DD AE       STD    $AE
F145: 68 30       ASL    -$10,Y
F147: CC 03 00    LDD    #$0300
F14A: ED 33       STD    -$D,Y
F14C: E7 35       STB    -$B,Y
F14E: 20 07       BRA    $F157
F150: 33 C8 30    LEAU   $30,U
F153: 0A E0       DEC    $E0
F155: 26 B8       BNE    $F10F
F157: 39          RTS

F3CE: 8E F4 8E    LDX    #$F48E
F3D1: D6 73       LDB    weapon_type_0073
F3D3: 58          ASLB
F3D4: EC 85       LDD    B,X
F3D6: DD E2       STD    $E2
F3D8: CE F4 52    LDU    #$F452
F3DB: 96 73       LDA    weapon_type_0073
F3DD: 48          ASLA
F3DE: 9B 73       ADDA   weapon_type_0073
F3E0: 48          ASLA
F3E1: 48          ASLA
F3E2: 33 C6       LEAU   A,U
F3E4: DF E7       STU    $E7
F3E6: 10 8E 13 D0 LDY    #$13D0
F3EA: C6 06       LDB    #$06
F3EC: D7 E0       STB    $E0
F3EE: E6 30       LDB    -$10,Y
F3F0: E4 31       ANDB   -$F,Y
F3F2: 10 27 00 52 LBEQ   $F448
F3F6: DE E7       LDU    $E7
F3F8: E6 25       LDB    $5,Y
F3FA: A6 C5       LDA    B,U
F3FC: 27 4A       BEQ    $F448
F3FE: 97 E6       STA    $E6
F400: 9E E2       LDX    $E2
F402: E6 25       LDB    $5,Y
F404: 58          ASLB
F405: 58          ASLB
F406: 58          ASLB
F407: 3A          ABX
F408: CE 05 40    LDU    #$0540
F40B: C6 04       LDB    #$04
F40D: D7 E1       STB    $E1
F40F: E6 50       LDB    -$10,U
F411: E4 51       ANDB   -$F,U
F413: 27 2C       BEQ    $F441
F415: EC 36       LDD    -$A,Y
F417: A3 56       SUBD   -$A,U
F419: E3 84       ADDD   ,X
F41B: 10 A3 02    CMPD   $2,X
F41E: 22 21       BHI    $F441
F420: EC 39       LDD    -$7,Y
F422: A3 59       SUBD   -$7,U
F424: E3 04       ADDD   $4,X
F426: 10 A3 06    CMPD   $6,X
F429: 22 16       BHI    $F441
F42B: 0A E6       DEC    $E6
F42D: 27 09       BEQ    $F438
F42F: 68 30       ASL    -$10,Y
F431: CC 02 00    LDD    #$0200
F434: ED 33       STD    -$D,Y
F436: 6F 35       CLR    -$B,Y
F438: 68 50       ASL    -$10,U
F43A: CC 02 01    LDD    #$0201
F43D: ED 53       STD    -$D,U
F43F: 6F 55       CLR    -$B,U
F441: 33 C8 40    LEAU   $40,U
F444: 0A E1       DEC    $E1
F446: 26 C7       BNE    $F40F
F448: 31 A8 20    LEAY   $20,Y
F44B: 0A E0       DEC    $E0
F44D: 10 26 FF 9D LBNE   $F3EE
F451: 39          RTS

F530: D6 AD       LDB    $AD
F532: 26 6D       BNE    $F5A1
F534: 10 8E 05 10 LDY    #$0510
F538: E6 30       LDB    -$10,Y
F53A: 54          LSRB
F53B: 24 64       BCC    $F5A1
F53D: CE F5 A2    LDU    #$F5A2
F540: E6 2F       LDB    $F,Y
F542: 27 04       BEQ    $F548
F544: 33 C9 00 80 LEAU   $0080,U
F548: DF E2       STU    $E2
F54A: CE 13 D0    LDU    #$13D0
F54D: C6 06       LDB    #$06
F54F: D7 E0       STB    $E0
F551: E6 50       LDB    -$10,U
F553: E4 51       ANDB   -$F,U
F555: 27 43       BEQ    $F59A
F557: 9E E2       LDX    $E2
F559: E6 45       LDB    $5,U
F55B: 58          ASLB
F55C: 58          ASLB
F55D: 58          ASLB
F55E: 3A          ABX
F55F: EC 59       LDD    -$7,U
F561: A3 39       SUBD   -$7,Y
F563: E3 04       ADDD   $4,X
F565: 10 A3 06    CMPD   $6,X
F568: 22 30       BHI    $F59A
F56A: EC 56       LDD    -$A,U
F56C: A3 36       SUBD   -$A,Y
F56E: E3 84       ADDD   ,X
F570: 10 A3 02    CMPD   $2,X
F573: 22 25       BHI    $F59A	; always branch: invincibility
F575: A3 84       SUBD   ,X
F577: DD AE       STD    $AE
F579: E6 45       LDB    $5,U
F57B: 26 09       BNE    $F586
F57D: CC 04 00    LDD    #$0400
F580: ED 33       STD    -$D,Y
F582: E7 35       STB    -$B,Y
F584: 20 09       BRA    $F58F
F586: 68 30       ASL    -$10,Y
F588: CC 03 00    LDD    #$0300
F58B: ED 33       STD    -$D,Y
F58D: E7 35       STB    -$B,Y
F58F: 68 50       ASL    -$10,U
F591: CC 02 00    LDD    #$0200
F594: ED 53       STD    -$D,U
F596: E7 55       STB    -$B,U
F598: 20 07       BRA    $F5A1
F59A: 33 C8 20    LEAU   $20,U
F59D: 0A E0       DEC    $E0
F59F: 26 B0       BNE    $F551
F5A1: 39          RTS

F6A2: 10 8E 10 10 LDY    #$1010
F6A6: C6 1E       LDB    #$1E
F6A8: D7 E0       STB    $E0
F6AA: E6 30       LDB    -$10,Y
F6AC: E4 31       ANDB   -$F,Y
F6AE: 10 27 00 63 LBEQ   $F715
F6B2: 8E F7 1D    LDX    #$F71D
F6B5: E6 25       LDB    $5,Y
F6B7: A6 85       LDA    B,X
F6B9: 27 5A       BEQ    $F715
F6BB: 8E F7 22    LDX    #$F722
F6BE: 58          ASLB
F6BF: 58          ASLB
F6C0: 58          ASLB
F6C1: 3A          ABX
F6C2: 9F E2       STX    $E2
F6C4: CE 05 40    LDU    #$0540
F6C7: C6 04       LDB    #$04
F6C9: D7 E1       STB    $E1
F6CB: E6 50       LDB    -$10,U
F6CD: E4 51       ANDB   -$F,U
F6CF: 27 3D       BEQ    $F70E
F6D1: 9E E2       LDX    $E2
F6D3: EC 36       LDD    -$A,Y
F6D5: A3 56       SUBD   -$A,U
F6D7: E3 84       ADDD   ,X
F6D9: 10 A3 02    CMPD   $2,X
F6DC: 22 30       BHI    $F70E
F6DE: EC 39       LDD    -$7,Y
F6E0: A3 59       SUBD   -$7,U
F6E2: E3 04       ADDD   $4,X
F6E4: 10 A3 06    CMPD   $6,X
F6E7: 22 25       BHI    $F70E
F6E9: 68 50       ASL    -$10,U
F6EB: CC 02 01    LDD    #$0201
F6EE: ED 53       STD    -$D,U
F6F0: 6F 55       CLR    -$B,U
F6F2: A6 2A       LDA    $A,Y
F6F4: 27 1F       BEQ    $F715
F6F6: 6A 2A       DEC    $A,Y
F6F8: 26 1B       BNE    $F715
F6FA: 8E 07 70    LDX    #$0770
F6FD: EC 36       LDD    -$A,Y
F6FF: ED 06       STD    $6,X
F701: EC 39       LDD    -$7,Y
F703: ED 08       STD    $8,X
F705: 4F          CLRA
F706: 5F          CLRB
F707: ED 13       STD    -$D,X
F709: 4C          INCA
F70A: ED 10       STD    -$10,X
F70C: E7 34       STB    -$C,Y
F70E: 33 C8 40    LEAU   $40,U
F711: 0A E1       DEC    $E1
F713: 26 B6       BNE    $F6CB
F715: 31 A8 20    LEAY   $20,Y
F718: 0A E0       DEC    $E0
F71A: 26 8E       BNE    $F6AA
F71C: 39          RTS

F765: 9E 10       LDX    $10
F767: 83 00 20    SUBD   #$0020
F76A: 22 1B       BHI    $F787
F76C: C6 01       LDB    #$01
F76E: D7 90       STB    $90
F770: D6 AD       LDB    $AD
F772: 26 07       BNE    $F77B
F774: F6 05 03    LDB    $0503
F777: C1 03       CMPB   #$03
F779: 27 0C       BEQ    $F787
F77B: 0F AD       CLR    $AD
F77D: D6 60       LDB    nb_lives_0060
F77F: 5A          DECB
F780: 10 27 82 95 LBEQ   $7A19
F784: 7E 7A 29    JMP    $7A29
F787: 39          RTS
F788: C6 04       LDB    #$04
F78A: F7 3E 00    STB    bankswitch_3e00
F78D: 10 8E 1E 3C LDY    #$1E3C
F791: C6 40       LDB    #$40
F793: D7 29       STB    $29
F795: 39          RTS
F796: 8D F0       BSR    $F788
F798: BD F8 27    JSR    $F827
F79B: BD F7 E5    JSR    $F7E5
F79E: BD F7 FB    JSR    $F7FB
F7A1: BD F7 CF    JSR    $F7CF
F7A4: BD F8 11    JSR    $F811
F7A7: BD F7 C3    JSR    $F7C3
F7AA: D6 72       LDB    starting_level_0072
F7AC: C1 06       CMPB   #$06
F7AE: 26 03       BNE    $F7B3
F7B0: BD F7 C9    JSR    $F7C9
F7B3: D6 29       LDB    $29
F7B5: 27 0B       BEQ    $F7C2
F7B7: 31 22       LEAY   $2,Y
F7B9: 86 F8       LDA    #$F8
F7BB: A7 A4       STA    ,Y
F7BD: 31 24       LEAY   $4,Y
F7BF: 5A          DECB
F7C0: 26 F9       BNE    $F7BB
F7C2: 39          RTS
F7C3: 8E 05 10    LDX    #$0510
F7C6: 7E F8 41    JMP    $F841
F7C9: 8E 15 C2    LDX    #$15C2
F7CC: 7E F8 41    JMP    $F841
F7CF: 8E 08 90    LDX    #$0890
F7D2: C6 28       LDB    #$28
F7D4: D7 EE       STB    $EE
F7D6: E6 11       LDB    -$F,X
F7D8: 27 03       BEQ    $F7DD
F7DA: BD F8 41    JSR    $F841
F7DD: 30 88 30    LEAX   $30,X
F7E0: 0A EE       DEC    $EE
F7E2: 26 F2       BNE    $F7D6
F7E4: 39          RTS
F7E5: 8E 05 40    LDX    #$0540
F7E8: C6 04       LDB    #$04
F7EA: D7 EE       STB    $EE
F7EC: E6 11       LDB    -$F,X
F7EE: 27 03       BEQ    $F7F3
F7F0: BD F8 41    JSR    $F841
F7F3: 30 88 40    LEAX   $40,X
F7F6: 0A EE       DEC    $EE
F7F8: 26 F2       BNE    $F7EC
F7FA: 39          RTS
F7FB: 8E 13 D0    LDX    #$13D0
F7FE: C6 06       LDB    #$06
F800: D7 EE       STB    $EE
F802: E6 11       LDB    -$F,X
F804: 27 03       BEQ    $F809
F806: BD F8 41    JSR    $F841
F809: 30 88 20    LEAX   $20,X
F80C: 0A EE       DEC    $EE
F80E: 26 F2       BNE    $F802
F810: 39          RTS
F811: 8E 10 10    LDX    #$1010
F814: C6 1E       LDB    #$1E
F816: D7 EE       STB    $EE
F818: E6 11       LDB    -$F,X
F81A: 27 03       BEQ    $F81F
F81C: BD F8 41    JSR    $F841
F81F: 30 88 20    LEAX   $20,X
F822: 0A EE       DEC    $EE
F824: 26 F2       BNE    $F818
F826: 39          RTS
F827: 8E 15 E2    LDX    #$15E2
F82A: C6 02       LDB    #$02
F82C: D7 EE       STB    $EE
F82E: E6 11       LDB    -$F,X
F830: 27 03       BEQ    $F835
F832: BD F8 41    JSR    $F841
F835: 30 88 30    LEAX   $30,X
F838: 0A EE       DEC    $EE
F83A: 26 F2       BNE    $F82E
F83C: 39          RTS
F83D: E6 11       LDB    -$F,X
F83F: 27 E5       BEQ    $F826
F841: CE F8 64    LDU    #$F864
F844: E6 1F       LDB    -$1,X
F846: 58          ASLB
F847: 33 C5       LEAU   B,U
F849: E6 C4       LDB    ,U
F84B: 1D          SEX
F84C: E3 16       ADDD   -$A,X
F84E: 93 9C       SUBD   $9C
F850: 84 01       ANDA   #$01
F852: DD E4       STD    $E4
F854: E6 41       LDB    $1,U
F856: EB 1A       ADDB   -$6,X
F858: D0 9F       SUBB   $9F
F85A: D7 E7       STB    $E7
F85C: CE F8 7A    LDU    #jump_table_f87a
F85F: E6 1F       LDB    -$1,X
F861: 58          ASLB
F862: 6E D5       JMP    [B,U]	; [indirect_jump]

F890: D6 29       LDB    $29
F892: 27 15       BEQ    $F8A9
F894: 0A 29       DEC    $29
F896: EE 03       LDU    $3,X
F898: EC C4       LDD    ,U
F89A: DA E4       ORB    $E4
F89C: ED A1       STD    ,Y++
F89E: D6 E7       LDB    $E7
F8A0: 50          NEGB
F8A1: C0 10       SUBB   #$10
F8A3: E7 A0       STB    ,Y+
F8A5: D6 E5       LDB    $E5
F8A7: E7 A0       STB    ,Y+
F8A9: 39          RTS
F8AA: D6 29       LDB    $29
F8AC: C0 02       SUBB   #$02
F8AE: 25 F9       BCS    $F8A9
F8B0: D7 29       STB    $29
F8B2: EE 03       LDU    $3,X
F8B4: EC C4       LDD    ,U
F8B6: DA E4       ORB    $E4
F8B8: ED A4       STD    ,Y
F8BA: A6 42       LDA    $2,U
F8BC: ED 24       STD    $4,Y
F8BE: D6 E7       LDB    $E7
F8C0: 50          NEGB
F8C1: C0 10       SUBB   #$10
F8C3: E7 22       STB    $2,Y
F8C5: C0 10       SUBB   #$10
F8C7: E7 26       STB    $6,Y
F8C9: D6 E5       LDB    $E5
F8CB: E7 23       STB    $3,Y
F8CD: E7 27       STB    $7,Y
F8CF: 31 28       LEAY   $8,Y
F8D1: 39          RTS
F8D2: D6 29       LDB    $29
F8D4: C0 02       SUBB   #$02
F8D6: 25 D1       BCS    $F8A9
F8D8: D7 29       STB    $29
F8DA: EE 03       LDU    $3,X
F8DC: EC C4       LDD    ,U
F8DE: DA E4       ORB    $E4
F8E0: ED A4       STD    ,Y
F8E2: A6 42       LDA    $2,U
F8E4: A7 24       STA    $4,Y
F8E6: D6 E7       LDB    $E7
F8E8: 50          NEGB
F8E9: C0 10       SUBB   #$10
F8EB: E7 22       STB    $2,Y
F8ED: E7 26       STB    $6,Y
F8EF: DC E4       LDD    $E4
F8F1: E7 23       STB    $3,Y
F8F3: C3 00 10    ADDD   #$0010
F8F6: 84 01       ANDA   #$01
F8F8: E7 27       STB    $7,Y
F8FA: AA 41       ORA    $1,U
F8FC: A7 25       STA    $5,Y
F8FE: 31 28       LEAY   $8,Y
F900: 39          RTS
F901: D6 29       LDB    $29
F903: C0 04       SUBB   #$04
F905: 25 A2       BCS    $F8A9
F907: D7 29       STB    $29
F909: EE 03       LDU    $3,X
F90B: EC C4       LDD    ,U
F90D: DA E4       ORB    $E4
F90F: ED A4       STD    ,Y
F911: A6 42       LDA    $2,U
F913: ED 24       STD    $4,Y
F915: A6 43       LDA    $3,U
F917: A7 28       STA    $8,Y
F919: A6 44       LDA    $4,U
F91B: A7 2C       STA    $C,Y
F91D: D6 E7       LDB    $E7
F91F: 50          NEGB
F920: C0 10       SUBB   #$10
F922: E7 22       STB    $2,Y
F924: E7 2A       STB    $A,Y
F926: C0 10       SUBB   #$10
F928: E7 26       STB    $6,Y
F92A: E7 2E       STB    $E,Y
F92C: DC E4       LDD    $E4
F92E: E7 23       STB    $3,Y
F930: E7 27       STB    $7,Y
F932: C3 00 10    ADDD   #$0010
F935: 84 01       ANDA   #$01
F937: E7 2B       STB    $B,Y
F939: E7 2F       STB    $F,Y
F93B: AA 41       ORA    $1,U
F93D: A7 29       STA    $9,Y
F93F: A7 2D       STA    $D,Y
F941: 31 A8 10    LEAY   $10,Y
F944: 39          RTS
F945: D6 29       LDB    $29
F947: C0 09       SUBB   #$09
F949: 25 F9       BCS    $F944
F94B: D7 29       STB    $29
F94D: EE 03       LDU    $3,X
F94F: EC C4       LDD    ,U
F951: DA E4       ORB    $E4
F953: ED A4       STD    ,Y
F955: A6 42       LDA    $2,U
F957: ED 24       STD    $4,Y
F959: A6 43       LDA    $3,U
F95B: ED 28       STD    $8,Y
F95D: A6 44       LDA    $4,U
F95F: A7 2C       STA    $C,Y
F961: A6 45       LDA    $5,U
F963: A7 A8 10    STA    $10,Y
F966: A6 46       LDA    $6,U
F968: A7 A8 14    STA    $14,Y
F96B: A6 47       LDA    $7,U
F96D: A7 A8 18    STA    $18,Y
F970: A6 48       LDA    $8,U
F972: A7 A8 1C    STA    $1C,Y
F975: A6 49       LDA    $9,U
F977: A7 A8 20    STA    $20,Y
F97A: D6 E7       LDB    $E7
F97C: 50          NEGB
F97D: C0 10       SUBB   #$10
F97F: E7 22       STB    $2,Y
F981: E7 2E       STB    $E,Y
F983: E7 A8 1A    STB    $1A,Y
F986: C0 10       SUBB   #$10
F988: E7 26       STB    $6,Y
F98A: E7 A8 12    STB    $12,Y
F98D: E7 A8 1E    STB    $1E,Y
F990: C0 10       SUBB   #$10
F992: E7 2A       STB    $A,Y
F994: E7 A8 16    STB    $16,Y
F997: E7 A8 22    STB    $22,Y
F99A: DC E4       LDD    $E4
F99C: E7 23       STB    $3,Y
F99E: E7 27       STB    $7,Y
F9A0: E7 2B       STB    $B,Y
F9A2: C3 00 10    ADDD   #$0010
F9A5: 84 01       ANDA   #$01
F9A7: 97 E4       STA    $E4
F9A9: E7 2F       STB    $F,Y
F9AB: E7 A8 13    STB    $13,Y
F9AE: E7 A8 17    STB    $17,Y
F9B1: AA 41       ORA    $1,U
F9B3: A7 2D       STA    $D,Y
F9B5: A7 A8 11    STA    $11,Y
F9B8: A7 A8 15    STA    $15,Y
F9BB: 96 E4       LDA    $E4
F9BD: C3 00 10    ADDD   #$0010
F9C0: 84 01       ANDA   #$01
F9C2: E7 A8 1B    STB    $1B,Y
F9C5: E7 A8 1F    STB    $1F,Y
F9C8: E7 A8 23    STB    $23,Y
F9CB: AA 41       ORA    $1,U
F9CD: A7 A8 19    STA    $19,Y
F9D0: A7 A8 1D    STA    $1D,Y
F9D3: A7 A8 21    STA    $21,Y
F9D6: 31 A8 24    LEAY   $24,Y
F9D9: 39          RTS
F9DA: D6 29       LDB    $29
F9DC: C0 03       SUBB   #$03
F9DE: 25 3D       BCS    $FA1D
F9E0: D7 29       STB    $29
F9E2: EE 03       LDU    $3,X
F9E4: EC C4       LDD    ,U
F9E6: DA E4       ORB    $E4
F9E8: ED A4       STD    ,Y
F9EA: A6 42       LDA    $2,U
F9EC: A7 24       STA    $4,Y
F9EE: A6 43       LDA    $3,U
F9F0: A7 28       STA    $8,Y
F9F2: D6 E7       LDB    $E7
F9F4: 50          NEGB
F9F5: C0 10       SUBB   #$10
F9F7: E7 22       STB    $2,Y
F9F9: E7 26       STB    $6,Y
F9FB: E7 2A       STB    $A,Y
F9FD: DC E4       LDD    $E4
F9FF: E7 23       STB    $3,Y
FA01: C3 00 10    ADDD   #$0010
FA04: 84 01       ANDA   #$01
FA06: 97 E4       STA    $E4
FA08: E7 27       STB    $7,Y
FA0A: AA 41       ORA    $1,U
FA0C: A7 25       STA    $5,Y
FA0E: C3 00 10    ADDD   #$0010
FA11: 84 01       ANDA   #$01
FA13: 97 E4       STA    $E4
FA15: E7 2B       STB    $B,Y
FA17: AA 41       ORA    $1,U
FA19: A7 29       STA    $9,Y
FA1B: 31 2C       LEAY   $C,Y
FA1D: 39          RTS
FA1E: D6 29       LDB    $29
FA20: C0 10       SUBB   #$10
FA22: 25 F9       BCS    $FA1D
FA24: D7 29       STB    $29
FA26: EE 03       LDU    $3,X
FA28: EC C4       LDD    ,U
FA2A: DA E4       ORB    $E4
FA2C: ED A4       STD    ,Y
FA2E: A6 42       LDA    $2,U
FA30: ED 24       STD    $4,Y
FA32: A6 43       LDA    $3,U
FA34: ED 28       STD    $8,Y
FA36: A6 44       LDA    $4,U
FA38: ED 2C       STD    $C,Y
FA3A: A6 45       LDA    $5,U
FA3C: A7 A8 10    STA    $10,Y
FA3F: A6 46       LDA    $6,U
FA41: A7 A8 14    STA    $14,Y
FA44: A6 47       LDA    $7,U
FA46: A7 A8 18    STA    $18,Y
FA49: A6 48       LDA    $8,U
FA4B: A7 A8 1C    STA    $1C,Y
FA4E: A6 49       LDA    $9,U
FA50: A7 A8 20    STA    $20,Y
FA53: A6 4A       LDA    $A,U
FA55: A7 A8 24    STA    $24,Y
FA58: A6 4B       LDA    $B,U
FA5A: A7 A8 28    STA    $28,Y
FA5D: A6 4C       LDA    $C,U
FA5F: A7 A8 2C    STA    $2C,Y
FA62: A6 4D       LDA    $D,U
FA64: A7 A8 30    STA    $30,Y
FA67: A6 4E       LDA    $E,U
FA69: A7 A8 34    STA    $34,Y
FA6C: A6 4F       LDA    $F,U
FA6E: A7 A8 38    STA    $38,Y
FA71: A6 C8 10    LDA    $10,U
FA74: A7 A8 3C    STA    $3C,Y
FA77: D6 E7       LDB    $E7
FA79: 50          NEGB
FA7A: C0 10       SUBB   #$10
FA7C: E7 22       STB    $2,Y
FA7E: E7 A8 12    STB    $12,Y
FA81: E7 A8 22    STB    $22,Y
FA84: E7 A8 32    STB    $32,Y
FA87: C0 10       SUBB   #$10
FA89: E7 26       STB    $6,Y
FA8B: E7 A8 16    STB    $16,Y
FA8E: E7 A8 26    STB    $26,Y
FA91: E7 A8 36    STB    $36,Y
FA94: C0 10       SUBB   #$10
FA96: E7 2A       STB    $A,Y
FA98: E7 A8 1A    STB    $1A,Y
FA9B: E7 A8 2A    STB    $2A,Y
FA9E: E7 A8 3A    STB    $3A,Y
FAA1: C0 10       SUBB   #$10
FAA3: E7 2E       STB    $E,Y
FAA5: E7 A8 1E    STB    $1E,Y
FAA8: E7 A8 2E    STB    $2E,Y
FAAB: E7 A8 3E    STB    $3E,Y
FAAE: DC E4       LDD    $E4
FAB0: E7 23       STB    $3,Y
FAB2: E7 27       STB    $7,Y
FAB4: E7 2B       STB    $B,Y
FAB6: E7 2F       STB    $F,Y
FAB8: C3 00 10    ADDD   #$0010
FABB: 84 01       ANDA   #$01
FABD: 97 E4       STA    $E4
FABF: E7 A8 13    STB    $13,Y
FAC2: E7 A8 17    STB    $17,Y
FAC5: E7 A8 1B    STB    $1B,Y
FAC8: E7 A8 1F    STB    $1F,Y
FACB: AA 41       ORA    $1,U
FACD: A7 A8 11    STA    $11,Y
FAD0: A7 A8 15    STA    $15,Y
FAD3: A7 A8 19    STA    $19,Y
FAD6: A7 A8 1D    STA    $1D,Y
FAD9: 96 E4       LDA    $E4
FADB: C3 00 10    ADDD   #$0010
FADE: 84 01       ANDA   #$01
FAE0: 97 E4       STA    $E4
FAE2: E7 A8 23    STB    $23,Y
FAE5: E7 A8 27    STB    $27,Y
FAE8: E7 A8 2B    STB    $2B,Y
FAEB: E7 A8 2F    STB    $2F,Y
FAEE: AA 41       ORA    $1,U
FAF0: A7 A8 21    STA    $21,Y
FAF3: A7 A8 25    STA    $25,Y
FAF6: A7 A8 29    STA    $29,Y
FAF9: A7 A8 2D    STA    $2D,Y
FAFC: 96 E4       LDA    $E4
FAFE: C3 00 10    ADDD   #$0010
FB01: 84 01       ANDA   #$01
FB03: E7 A8 33    STB    $33,Y
FB06: E7 A8 37    STB    $37,Y
FB09: E7 A8 3B    STB    $3B,Y
FB0C: E7 A8 3F    STB    $3F,Y
FB0F: AA 41       ORA    $1,U
FB11: A7 A8 31    STA    $31,Y
FB14: A7 A8 35    STA    $35,Y
FB17: A7 A8 39    STA    $39,Y
FB1A: A7 A8 3D    STA    $3D,Y
FB1D: 31 A8 40    LEAY   $40,Y
FB20: 39          RTS
FB21: D6 29       LDB    $29
FB23: C0 04       SUBB   #$04
FB25: 25 F9       BCS    $FB20
FB27: D7 29       STB    $29
FB29: EE 03       LDU    $3,X
FB2B: EC C4       LDD    ,U
FB2D: DA E4       ORB    $E4
FB2F: ED A4       STD    ,Y
FB31: A6 42       LDA    $2,U
FB33: A7 24       STA    $4,Y
FB35: A6 43       LDA    $3,U
FB37: A7 28       STA    $8,Y
FB39: A6 44       LDA    $4,U
FB3B: A7 2C       STA    $C,Y
FB3D: D6 E7       LDB    $E7
FB3F: 50          NEGB
FB40: C0 10       SUBB   #$10
FB42: E7 22       STB    $2,Y
FB44: E7 26       STB    $6,Y
FB46: E7 2A       STB    $A,Y
FB48: E7 2E       STB    $E,Y
FB4A: DC E4       LDD    $E4
FB4C: E7 23       STB    $3,Y
FB4E: C3 00 10    ADDD   #$0010
FB51: 84 01       ANDA   #$01
FB53: 97 E4       STA    $E4
FB55: E7 27       STB    $7,Y
FB57: AA 41       ORA    $1,U
FB59: A7 25       STA    $5,Y
FB5B: 96 E4       LDA    $E4
FB5D: C3 00 10    ADDD   #$0010
FB60: 84 01       ANDA   #$01
FB62: 97 E4       STA    $E4
FB64: E7 2B       STB    $B,Y
FB66: AA 41       ORA    $1,U
FB68: A7 29       STA    $9,Y
FB6A: 96 E4       LDA    $E4
FB6C: C3 00 10    ADDD   #$0010
FB6F: 84 01       ANDA   #$01
FB71: E7 2F       STB    $F,Y
FB73: AA 41       ORA    $1,U
FB75: A7 2D       STA    $D,Y
FB77: 31 A8 10    LEAY   $10,Y
FB7A: 39          RTS
FB7B: D6 29       LDB    $29
FB7D: C0 03       SUBB   #$03
FB7F: 25 2B       BCS    $FBAC
FB81: D7 29       STB    $29
FB83: EE 03       LDU    $3,X
FB85: EC C4       LDD    ,U
FB87: DA E4       ORB    $E4
FB89: ED A4       STD    ,Y
FB8B: A6 42       LDA    $2,U
FB8D: ED 24       STD    $4,Y
FB8F: A6 43       LDA    $3,U
FB91: ED 28       STD    $8,Y
FB93: D6 E7       LDB    $E7
FB95: 50          NEGB
FB96: C0 10       SUBB   #$10
FB98: E7 22       STB    $2,Y
FB9A: C0 10       SUBB   #$10
FB9C: E7 26       STB    $6,Y
FB9E: C0 10       SUBB   #$10
FBA0: E7 2A       STB    $A,Y
FBA2: D6 E5       LDB    $E5
FBA4: E7 23       STB    $3,Y
FBA6: E7 27       STB    $7,Y
FBA8: E7 2B       STB    $B,Y
FBAA: 31 2C       LEAY   $C,Y
FBAC: 39          RTS
FBAD: D6 29       LDB    $29
FBAF: C0 06       SUBB   #$06
FBB1: 25 66       BCS    $FC19
FBB3: D7 29       STB    $29
FBB5: EE 03       LDU    $3,X
FBB7: EC C4       LDD    ,U
FBB9: DA E4       ORB    $E4
FBBB: ED A4       STD    ,Y
FBBD: A6 42       LDA    $2,U
FBBF: ED 24       STD    $4,Y
FBC1: A6 43       LDA    $3,U
FBC3: A7 28       STA    $8,Y
FBC5: A6 44       LDA    $4,U
FBC7: A7 2C       STA    $C,Y
FBC9: A6 45       LDA    $5,U
FBCB: A7 A8 10    STA    $10,Y
FBCE: A6 46       LDA    $6,U
FBD0: A7 A8 14    STA    $14,Y
FBD3: D6 E7       LDB    $E7
FBD5: 50          NEGB
FBD6: C0 10       SUBB   #$10
FBD8: E7 22       STB    $2,Y
FBDA: E7 2A       STB    $A,Y
FBDC: E7 A8 12    STB    $12,Y
FBDF: C0 10       SUBB   #$10
FBE1: E7 26       STB    $6,Y
FBE3: E7 2E       STB    $E,Y
FBE5: E7 A8 16    STB    $16,Y
FBE8: DC E4       LDD    $E4
FBEA: E7 23       STB    $3,Y
FBEC: E7 27       STB    $7,Y
FBEE: C3 00 10    ADDD   #$0010
FBF1: 84 01       ANDA   #$01
FBF3: 97 E4       STA    $E4
FBF5: E7 2B       STB    $B,Y
FBF7: E7 2F       STB    $F,Y
FBF9: AA 41       ORA    $1,U
FBFB: A7 29       STA    $9,Y
FBFD: A7 2D       STA    $D,Y
FBFF: 96 E4       LDA    $E4
FC01: C3 00 10    ADDD   #$0010
FC04: 84 01       ANDA   #$01
FC06: 97 E4       STA    $E4
FC08: E7 A8 13    STB    $13,Y
FC0B: E7 A8 17    STB    $17,Y
FC0E: AA 41       ORA    $1,U
FC10: A7 A8 11    STA    $11,Y
FC13: A7 A8 15    STA    $15,Y
FC16: 31 A8 18    LEAY   $18,Y
FC19: 39          RTS
FC1A: D6 29       LDB    $29
FC1C: C0 04       SUBB   #$04
FC1E: 25 36       BCS    $FC56
FC20: D7 29       STB    $29
FC22: EE 03       LDU    $3,X
FC24: EC C4       LDD    ,U
FC26: DA E4       ORB    $E4
FC28: ED A4       STD    ,Y
FC2A: A6 42       LDA    $2,U
FC2C: ED 24       STD    $4,Y
FC2E: A6 43       LDA    $3,U
FC30: ED 28       STD    $8,Y
FC32: A6 44       LDA    $4,U
FC34: ED 2C       STD    $C,Y
FC36: D6 E7       LDB    $E7
FC38: 50          NEGB
FC39: C0 10       SUBB   #$10
FC3B: E7 22       STB    $2,Y
FC3D: C0 10       SUBB   #$10
FC3F: E7 26       STB    $6,Y
FC41: C0 10       SUBB   #$10
FC43: E7 2A       STB    $A,Y
FC45: C0 10       SUBB   #$10
FC47: E7 2E       STB    $E,Y
FC49: D6 E5       LDB    $E5
FC4B: E7 23       STB    $3,Y
FC4D: E7 27       STB    $7,Y
FC4F: E7 2B       STB    $B,Y
FC51: E7 2F       STB    $F,Y
FC53: 31 A8 10    LEAY   $10,Y
FC56: 39          RTS
FC57: C6 06       LDB    #$06
FC59: D7 E0       STB    $E0
FC5B: 8E 13 D0    LDX    #$13D0
FC5E: E6 10       LDB    -$10,X
FC60: 27 0E       BEQ    $FC70
FC62: D6 21       LDB    $21
FC64: DB E0       ADDB   $E0
FC66: C4 03       ANDB   #$03
FC68: 26 03       BNE    $FC6D
FC6A: BD 8E 41    JSR    $8E41
FC6D: BD FC 78    JSR    $FC78
FC70: 30 88 20    LEAX   $20,X
FC73: 0A E0       DEC    $E0
FC75: 26 E7       BNE    $FC5E
FC77: 39          RTS
FC78: EC 13       LDD    -$D,X
FC7A: 48          ASLA
FC7B: CE FC 80    LDU    #jump_table_fc80
FC7E: 6E D6       JMP    [A,U]	; [indirect_jump]

FC88: A6 05       LDA    $5,X                                      
FC8A: 48          ASLA                                             
FC8B: CE FC 90    LDU    #jump_table_fc90
FC8E: 6E D6       JMP    [A,U]	; [indirect_jump]

FCA8: C6 00       LDB    #$00                                        
FCAA: E7 1F       STB    -$1,X
FCAC: BD FD 3D    JSR    $FD3D
FCAF: BD 90 6B    JSR    $906B
FCB2: 6C 13       INC    -$D,X
FCB4: 39          RTS
FCB5: C6 00       LDB    #$00
FCB7: E7 1F       STB    -$1,X
FCB9: BD FD 3D    JSR    $FD3D
FCBC: EF 84       STU    ,X
FCBE: EF 03       STU    $3,X
FCC0: 6F 02       CLR    $2,X
FCC2: 6C 13       INC    -$D,X
FCC4: 39          RTS
FCC5: C6 03       LDB    #$03
FCC7: E7 1F       STB    -$1,X
FCC9: 7E FC B9    JMP    $FCB9
FCCC: 6F 11       CLR    -$F,X
FCCE: 0F E2       CLR    $E2
FCD0: EC 19       LDD    -$7,X
FCD2: 93 A2       SUBD   $A2
FCD4: 2A 07       BPL    $FCDD
FCD6: 97 E2       STA    $E2
FCD8: 43          COMA
FCD9: 53          COMB
FCDA: C3 00 01    ADDD   #$0001
FCDD: DD E4       STD    $E4
FCDF: 0F E3       CLR    $E3
FCE1: EC 16       LDD    -$A,X
FCE3: 93 A0       SUBD   $A0
FCE5: 2A 07       BPL    $FCEE
FCE7: 97 E3       STA    $E3
FCE9: 43          COMA
FCEA: 53          COMB
FCEB: C3 00 01    ADDD   #$0001
FCEE: 10 93 E4    CMPD   $E4
FCF1: 25 10       BCS    $FD03
FCF3: C6 02       LDB    #$02
FCF5: E7 1F       STB    -$1,X
FCF7: 4F          CLRA
FCF8: D6 E3       LDB    $E3
FCFA: 26 02       BNE    $FCFE
FCFC: 86 02       LDA    #$02
FCFE: A7 1E       STA    -$2,X
FD00: 7E FD 11    JMP    $FD11
FD03: C6 01       LDB    #$01
FD05: E7 1F       STB    -$1,X
FD07: 86 03       LDA    #$03
FD09: D6 E2       LDB    $E2
FD0B: 26 02       BNE    $FD0F
FD0D: 86 01       LDA    #$01
FD0F: A7 1E       STA    -$2,X
FD11: BD FD 3D    JSR    $FD3D
FD14: 7E 90 6B    JMP    $906B
FD17: C6 00       LDB    #$00
FD19: E7 1F       STB    -$1,X
FD1B: BD FD 3D    JSR    $FD3D
FD1E: BD 90 6B    JSR    $906B
FD21: EE 1C       LDU    -$4,X
FD23: E6 06       LDB    $6,X
FD25: 58          ASLB
FD26: EE C5       LDU    B,U
FD28: EF 1C       STU    -$4,X
FD2A: 6C 13       INC    -$D,X
FD2C: 39          RTS
FD2D: BD 8F E4    JSR    $8FE4
FD30: E7 1E       STB    -$2,X
FD32: 7E FC A8    JMP    $FCA8
FD35: BD 8F E4    JSR    $8FE4
FD38: E7 1E       STB    -$2,X
FD3A: 7E FC B5    JMP    $FCB5
FD3D: A6 05       LDA    $5,X
FD3F: 48          ASLA
FD40: CE 5D 57    LDU    #$5D57
FD43: EE C6       LDU    A,U
FD45: EF 1C       STU    -$4,X
FD47: CE FD 4D    LDU    #$FD4D
FD4A: EE C6       LDU    A,U
FD4C: 39          RTS

FE12: B6 74 03    LDA    $7403
FE15: B7 70 03    STA    $7003
FE18: B6 70 03    LDA    $7003
FE1B: B7 78 83    STA    $7883
FE1E: FE 12 B6    LDU    $12B6
FE21: 70 03 B7    NEG    $03B7
FE24: 70 03 B6    NEG    $03B6
FE27: 74 03 B7    LSR    $03B7
FE2A: 78 83 FE    ASL    $83FE
FE2D: 20 53       BRA    $FE82

FE83: A6 05       LDA    $5,X
FE85: 48          ASLA
FE86: CE FE 8B    LDU    #jump_table_fe8b
FE89: 6E D6       JMP    [A,U]	; [indirect_jump]

FEA3: BD 8E 41    JSR    $8E41                                     
FEA6: BD A4 27    JSR    $A427
FEA9: BD 8F 62    JSR    $8F62
FEAC: BD 8C A7    JSR    $8CA7
FEAF: 24 0C       BCC    $FEBD
FEB1: 1D          SEX
FEB2: E3 19       ADDD   -$7,X
FEB4: ED 19       STD    -$7,X
FEB6: CC 03 00    LDD    #$0300
FEB9: ED 13       STD    -$D,X
FEBB: E7 15       STB    -$B,X
FEBD: 39          RTS
FEBE: BD 8E 41    JSR    $8E41
FEC1: BD A4 27    JSR    $A427
FEC4: BD 90 74    JSR    $9074
FEC7: 7E 8F 62    JMP    $8F62
FECA: 6C 13       INC    -$D,X
FECC: 39          RTS
FECD: 4F          CLRA
FECE: 5F          CLRB
FECF: ED 10       STD    -$10,X
FED1: ED 13       STD    -$D,X
FED3: E7 15       STB    -$B,X
FED5: 7E 8E 38    JMP    $8E38
FED8: 34 04       PSHS   B
FEDA: C6 08       LDB    #$08
FEDC: 34 04       PSHS   B
FEDE: 5F          CLRB
FEDF: 48          ASLA
FEE0: 59          ROLB
FEE1: 4C          INCA
FEE2: E2 61       SBCB   $1,S
FEE4: 24 03       BCC    $FEE9
FEE6: 4A          DECA
FEE7: EB 61       ADDB   $1,S
FEE9: 6A E4       DEC    ,S
FEEB: 26 F2       BNE    $FEDF
FEED: 32 62       LEAS   $2,S
FEEF: 39          RTS
FEF0: 34 06       PSHS   D
FEF2: C6 10       LDB    #$10
FEF4: 34 04       PSHS   B
FEF6: 4F          CLRA
FEF7: 5F          CLRB
FEF8: 68 41       ASL    $1,U
FEFA: 69 C4       ROL    ,U
FEFC: 59          ROLB
FEFD: 49          ROLA
FEFE: 6C 41       INC    $1,U
FF00: E2 62       SBCB   $2,S
FF02: A2 61       SBCA   $1,S
FF04: 24 04       BCC    $FF0A
FF06: 6A 41       DEC    $1,U
FF08: E3 61       ADDD   $1,S
FF0A: 6A E4       DEC    ,S
FF0C: 26 EA       BNE    $FEF8
FF0E: 32 63       LEAS   $3,S
FF10: 39          RTS

	; from bank 4
jump_table_4540:
	.word	$EF4A 
	.word	$DDB9 
jump_table_4544:
	.word	$A0DB 
	.word	$A44A 
	.word	$A89C 
	.word	$AFFC
	.word	$B146 
	.word	$B64E 
	.word	$BED5 
	.word	$C3A3 
	.word	$C4EA 
	.word	$CC45 
	.word	$CF36
	.word	$D2DD 
	.word	$D518
	.word	$DAD9 
	.word	$DE18

jump_table_4788:
	.word	$A246
	.word	$A264
	.word	$A2AA
	.word	$A2D3
	.word	$A246
	.word	$A264
	.word	$A2AA
	.word	$A2ED
	jump_table_639e:
	dc.w	$63ac	; $639e
	dc.w	$63b3	; $63a0
	dc.w	$6424	; $63a2
	dc.w	$6430	; $63a4
	dc.w	$6449	; $63a6
	dc.w	$6424	; $63a8
	dc.w	$6455	; $63aa
jump_table_65bc:
	dc.w	$684f	; $65bc
	dc.w	$694d	; $65be
	dc.w	$70e3	; $65c0
jump_table_6611:
	dc.w	$6619	; $6611
	dc.w	$6693	; $6613
	dc.w	$671c	; $6615
	dc.w	$6716	; $6617
jump_table_6857:
	dc.w	$685f	; $6857
	dc.w	$6883	; $6859
	dc.w	$689d	; $685b
	dc.w	$68bc	; $685d
jump_table_695a:
	dc.w	$69eb	; $695a
	dc.w	$69fc	; $695c
	dc.w	$6a4d	; $695e
	dc.w	$6a8d	; $6960
	dc.w	$6b5e	; $6962
	dc.w	$d622	; $6964
	dc.w	$da23	; $6966
	dc.w	$da51	; $6968
jump_table_6a04:
	dc.w	$6a08	; $6a04
	dc.w	$6a40	; $6a06
jump_table_6a55:
	dc.w	$6a5b	; $6a55
	dc.w	$6a68	; $6a57
	dc.w	$6a80	; $6a59
jump_table_6a95:
	dc.w	$6a9d	; $6a95
	dc.w	$6b2a	; $6a97
	dc.w	$6b49	; $6a99
	dc.w	$6b49	; $6a9b
jump_table_6aa5:
	dc.w	$6aab	; $6aa5
	dc.w	$6af8	; $6aa7
	dc.w	$6b14	; $6aa9
jump_table_6b66:
	dc.w	$6b6c	; $6b66
	dc.w	$6b8e	; $6b68
	dc.w	$6bf6	; $6b6a
jump_table_70f1:
	dc.w	$70fb	; $70f1
	dc.w	$7115	; $70f3
jump_table_711d:
	dc.w	$7125	; $711d
	dc.w	$7245	; $711f
	dc.w	$72c9	; $7121
	dc.w	$777c	; $7123
jump_table_724d:
	dc.w	$7251	; $724d
	dc.w	$72a1	; $724f
jump_table_7259:
	dc.w	$725f	; $7259
	dc.w	$726e	; $725b
	dc.w	$7296	; $725d
jump_table_731d:
	dc.w	$7321	; $731d
	dc.w	$735a	; $731f
jump_table_7391:
	dc.w	$7399	; $7391
	dc.w	$73ac	; $7393
	dc.w	$73c7	; $7395
	dc.w	$73eb	; $7397
jump_table_7418:
	dc.w	$741c	; $7418
	dc.w	$7438	; $741a
jump_table_7457:
	dc.w	$7465	; $7457
	dc.w	$7476	; $7459
	dc.w	$74b1	; $745b
	dc.w	$74eb	; $745d
	dc.w	$74fa	; $745f
	dc.w	$7523	; $7461
	dc.w	$7535	; $7463
jump_table_755f:
	dc.w	$756b	; $755f
	dc.w	$757a	; $7561
	dc.w	$7625	; $7563
	dc.w	$7648	; $7565
	dc.w	$76b5	; $7567
	dc.w	$7703	; $7569
jump_table_758c:
	dc.w	$7594	; $758c
	dc.w	$75e5	; $758e
	dc.w	$75f8	; $7590
	dc.w	$7616	; $7592
jump_table_7784:
	dc.w	$778a	; $7784
	dc.w	$77c0	; $7786
	dc.w	$77cc	; $7788
jump_table_781b:
	dc.w	$7821	; $781b
	dc.w	$78a1	; $781d
	dc.w	$78cd	; $781f
jump_table_78d5:
	dc.w	$78db	; $78d5
	dc.w	$7833	; $78d7
	dc.w	$78e8	; $78d9
jump_table_7a78:
	dc.w	$7a7e	; $7a78
	dc.w	$7aa4	; $7a7a
	dc.w	$7c3d	; $7a7c
jump_table_7b36:
	dc.w	$7b4a	; $7b36
	dc.w	$7b64	; $7b38
	dc.w	$7b6e	; $7b3a
	dc.w	$7b7d	; $7b3c
jump_table_7b8e:
	dc.w	$7b94	; $7b8e
	dc.w	$95df	; $7b90
	dc.w	$7baf	; $7b92
jump_table_7bd8:
	dc.w	$7be2	; $7bd8
	dc.w	$7bf2	; $7bda
	dc.w	$7c10	; $7bdc
	dc.w	$7c19	; $7bde
	dc.w	$7c2e	; $7be0
jump_table_7c4a:
	dc.w	$7c54	; $7c4a
	dc.w	$7c67	; $7c4c
	dc.w	$7c8e	; $7c4e
	dc.w	$7d80	; $7c50
	dc.w	$7c9b	; $7c52
jump_table_7ca8:
	dc.w	$7cac	; $7ca8
	dc.w	$7cba	; $7caa
jump_table_7cd6:
	dc.w	$7cea	; $7cd6
	dc.w	$7d09	; $7cd8
	dc.w	$7d20	; $7cda
	dc.w	$7d39	; $7cdc
	dc.w	$7d52	; $7cde
	dc.w	$7d99	; $7ce0
	dc.w	$7daa	; $7ce2
jump_table_7d58:
	dc.w	$7d5c	; $7d58
	dc.w	$7d80	; $7d5a
jump_table_7dd8:
	dc.w	$7a7e	; $7dd8
	dc.w	$7ddc	; $7dda
jump_table_7dfb:
	dc.w	$7e01	; $7dfb
	dc.w	$7e38	; $7dfd
	dc.w	$7e41	; $7dff
jump_table_7e4a:
	dc.w	$7e50	; $7e4a
	dc.w	$7e75	; $7e4c
	dc.w	$7e82	; $7e4e
jump_table_7eb1:
	dc.w	$7eb7	; $7eb1
	dc.w	$7ed8	; $7eb3
	dc.w	$7edb	; $7eb5
jump_table_7f01:
	dc.w	$7f05	; $7f01
	dc.w	$7f0f	; $7f03
jump_table_7f17:
	dc.w	$7f21	; $7f17
	dc.w	$7f45	; $7f19
	dc.w	$7f61	; $7f1b
	dc.w	$7f95	; $7f1d
	dc.w	$7fb5	; $7f1f
jump_table_7fc4:
	dc.w	$7fcc	; $7fc4
	dc.w	$7fdc	; $7fc6
	dc.w	$7ff8	; $7fc8
	dc.w	$8007	; $7fca
jump_table_809c:
	dc.w	$80ab	; $809c
	dc.w	$8156	; $809e
	dc.w	$8e06	; $80a0
jump_table_90c7:
	dc.w	$90d3	; $90c7
	dc.w	$9170	; $90c9
	dc.w	$9567	; $90cb
	dc.w	$9af9	; $90cd
	dc.w	$94ab	; $90cf
	dc.w	$951a	; $90d1
jump_table_9135:
	dc.w	$9139	; $9135
	dc.w	$915c	; $9137
jump_table_9178:
	dc.w	$917c	; $9178
	dc.w	$91f2	; $917a
jump_table_94b3:
	dc.w	$94b7	; $94b3
	dc.w	$91f2	; $94b5
jump_table_953c:
	dc.w	$9542	; $953c
	dc.w	$95d3	; $953e
	dc.w	$9612	; $9540
jump_table_957c:
	dc.w	$95b2	; $957c
	dc.w	$95c8	; $957e
	dc.w	$9607	; $9580
	dc.w	$bd8d	; $9582
jump_table_997e:
	dc.w	$9984	; $997e
	dc.w	$999e	; $9980
	dc.w	$99c8	; $9982
jump_table_99e2:
	dc.w	$99e8	; $99e2
	dc.w	$99ee	; $99e4
	dc.w	$9a0b	; $99e6
jump_table_9a86:
	dc.w	$9a8a	; $9a86
	dc.w	$9a91	; $9a88
jump_table_9b0f:
	dc.w	$9b19	; $9b0f
	dc.w	$9b87	; $9b11
	dc.w	$95d3	; $9b13
	dc.w	$9612	; $9b15
	dc.w	$9b95	; $9b17
jump_table_9c42:
	dc.w	$9bac	; $9c42
	dc.w	$95d3	; $9c44
	dc.w	$9612	; $9c46
	dc.w	$9bfb	; $9c48
	dc.w	$9c12	; $9c4a
	dc.w	$9c27	; $9c4c
	dc.w	$ffff	; $9c4e
jump_table_9cc8:
	dc.w	$9cd4	; $9cc8
	dc.w	$9d0b	; $9cca
	dc.w	$9d14	; $9ccc
	dc.w	$9d42	; $9cce
	dc.w	$9d4f	; $9cd0
	dc.w	$9d6c	; $9cd2
jump_table_9d7b:
	dc.w	$9d85	; $9d7b
	dc.w	$9d8d	; $9d7d
	dc.w	$9d6c	; $9d7f
	dc.w	$9da7	; $9d81
	dc.w	$9d6c	; $9d83
jump_table_9e69:
	dc.w	$9cd4	; $9e69
	dc.w	$9eb8	; $9e6b
	dc.w	$9cac	; $9e6d
	dc.w	$9e75	; $9e6f
	dc.w	$9d75	; $9e71
	dc.w	$9e8b	; $9e73
jump_table_9e7b:
	dc.w	$9cd4	; $9e7b
	dc.w	$9d0b	; $9e7d
	dc.w	$9e83	; $9e7f
	dc.w	$9d85	; $9e81
jump_table_9ea2:
	dc.w	$9cd4	; $9ea2
	dc.w	$9ea8	; $9ea4
	dc.w	$9eb1	; $9ea6
jump_table_a0f1:
	dc.w	$a0f9	; $a0f1
	dc.w	$a14d	; $a0f3
	dc.w	$a17f	; $a0f5
	dc.w	$a17f	; $a0f7
jump_table_a155:
	dc.w	$a159	; $a155
	dc.w	$a161	; $a157
jump_table_a187:
	dc.w	$a18b	; $a187
	dc.w	$a1a2	; $a189
jump_table_a1c5:
	dc.w	$a1cb	; $a1c5
	dc.w	$a23e	; $a1c7
	dc.w	$a2f2	; $a1c9
jump_table_a1e1:
	dc.w	$a1e5	; $a1e1
	dc.w	$a1f8	; $a1e3
jump_table_a2fa:
	dc.w	$a302	; $a2fa
	dc.w	$a32c	; $a2fc
	dc.w	$a34c	; $a2fe
	dc.w	$a367	; $a300
jump_table_a37b:
	dc.w	$a37f	; $a37b
	dc.w	$a3b4	; $a37d
jump_table_a3e7:
	dc.w	$a3ed	; $a3e7
	dc.w	$e886	; $a3e9
	dc.w	$a403	; $a3eb
jump_table_a452:
	dc.w	$a45a	; $a452
	dc.w	$a4cd	; $a454
	dc.w	$a86f	; $a456
	dc.w	$a88c	; $a458
jump_table_a4d5:
	dc.w	$a4e1	; $a4d5
	dc.w	$a5fa	; $a4d7
	dc.w	$a642	; $a4d9
	dc.w	$a725	; $a4db
	dc.w	$a812	; $a4dd
	dc.w	$a83f	; $a4df
jump_table_a4e7:
	dc.w	$a4ed	; $a4e7
	dc.w	$a506	; $a4e9
	dc.w	$a5ee	; $a4eb
jump_table_a50e:
	dc.w	$a518	; $a50e
	dc.w	$a599	; $a510
	dc.w	$a5a9	; $a512
	dc.w	$a5c1	; $a514
	dc.w	$a5e5	; $a516
jump_table_a600:
	dc.w	$a606	; $a600
	dc.w	$a506	; $a602
	dc.w	$a5ee	; $a604
jump_table_a648:
	dc.w	$a650	; $a648
	dc.w	$a67c	; $a64a
	dc.w	$a691	; $a64c
	dc.w	$a701	; $a64e
jump_table_a699:
	dc.w	$a6ad	; $a699
	dc.w	$a6d5	; $a69b
	dc.w	$ffff	; $a69d
jump_table_a709:
	dc.w	$a70d	; $a709
	dc.w	$a719	; $a70b
jump_table_a72b:
	dc.w	$a755	; $a72b
	dc.w	$a7de	; $a72d
	dc.w	$ec16	; $a72f
	dc.w	$939c	; $a731
jump_table_a75d:
	dc.w	$a76b	; $a75d
	dc.w	$a775	; $a75f
	dc.w	$a7a5	; $a761
jump_table_a7e6:
	dc.w	$a7ea	; $a7e6
	dc.w	$a7fa	; $a7e8
jump_table_a818:
	dc.w	$a72f	; $a818
	dc.w	$a81c	; $a81a
jump_table_a845:
	dc.w	$a755	; $a845
	dc.w	$a849	; $a847
jump_table_a875:
	dc.w	$a87b	; $a875
	dc.w	$e85b	; $a877
	dc.w	$a884	; $a879
jump_table_a8a4:
	dc.w	$a8ac	; $a8a4
	dc.w	$ab4b	; $a8a6
	dc.w	$aea1	; $a8a8
	dc.w	$aebe	; $a8aa
jump_table_a8c2:
	dc.w	$aece	; $a8c2
	dc.w	$a8c6	; $a8c4
jump_table_ab67:
	dc.w	$ab6f	; $ab67
	dc.w	$abcf	; $ab69
	dc.w	$ac46	; $ab6b
	dc.w	$acd3	; $ab6d
jump_table_ab77:
	dc.w	$ab7b	; $ab77
	dc.w	$ab85	; $ab79
jump_table_abd7:
	dc.w	$abdf	; $abd7
	dc.w	$ac0d	; $abd9
	dc.w	$ac25	; $abdb
	dc.w	$ac33	; $abdd
jump_table_abc7:
	dc.w	$acf4	; $abc7
	dc.w	$ad09	; $abc9
	dc.w	$acf4	; $abcb
	dc.w	$ad09	; $abcd
	dc.w	$e615	; $abcf
jump_table_acdb:
	dc.w	$acdf	; $acdb
	dc.w	$abbe	; $acdd
jump_table_aea7:
	dc.w	$aead	; $aea7
	dc.w	$e85b	; $aea9
	dc.w	$aeb6	; $aeab
jump_table_aed6:
	dc.w	$aeda	; $aed6
	dc.w	$af12	; $aed8
jump_table_b004:
	dc.w	$b00c	; $b004
	dc.w	$b077	; $b006
	dc.w	$b117	; $b008
	dc.w	$b134	; $b00a
jump_table_b089:
	dc.w	$b08f	; $b089
	dc.w	$b0b3	; $b08b
	dc.w	$b0fb	; $b08d
jump_table_b11d:
	dc.w	$b123	; $b11d
	dc.w	$e886	; $b11f
	dc.w	$b12c	; $b121
jump_table_b14e:
	dc.w	$b156	; $b14e
	dc.w	$b238	; $b150
	dc.w	$b603	; $b152
	dc.w	$b620	; $b154
jump_table_b16c:
	dc.w	$b170	; $b16c
	dc.w	$b193	; $b16e
jump_table_b1cd:
	dc.w	$b1ec	; $b1cd
	dc.w	$ffff	; $b1cf
	dc.w	$ffff	; $b1d1
	dc.w	$ffff	; $b1d3
jump_table_b26a:
	dc.w	$b276	; $b26a
	dc.w	$b309	; $b26c
	dc.w	$b36f	; $b26e
	dc.w	$b3cd	; $b270
	dc.w	$b41e	; $b272
	dc.w	$b5f7	; $b274
jump_table_b289:
	dc.w	$b2c3	; $b289
	dc.w	$b2de	; $b28b
	dc.w	$ffff	; $b28d
	dc.w	$ffff	; $b28f
jump_table_b31c:
	dc.w	$b34c	; $b31c
	dc.w	$b360	; $b31e
	dc.w	$ffff	; $b320
	dc.w	$ffff	; $b322
jump_table_b377:
	dc.w	$b37f	; $b377
	dc.w	$b3a1	; $b379
jump_table_b3d5:
	dc.w	$b3db	; $b3d5
	dc.w	$b3e3	; $b3d7
	dc.w	$b402	; $b3d9
jump_table_b426:
	dc.w	$b432	; $b426
	dc.w	$b457	; $b428
	dc.w	$b4bd	; $b42a
	dc.w	$b510	; $b42c
	dc.w	$b51b	; $b42e
	dc.w	$b521	; $b430
jump_table_b53f:
	dc.w	$b545	; $b53f
	dc.w	$b564	; $b541
	dc.w	$b583	; $b543
jump_table_b5ff:
	dc.w	$b4bd	; $b5ff
	dc.w	$b521	; $b601
jump_table_b656:
	dc.w	$b65e	; $b656
	dc.w	$b7d6	; $b658
	dc.w	$be96	; $b65a
	dc.w	$bec4	; $b65c
jump_table_b685:
	dc.w	$b68b	; $b685
	dc.w	$b6a5	; $b687
	dc.w	$b6c8	; $b689
jump_table_b6dd:
	dc.w	$b6e7	; $b6dd
	dc.w	$b6f3	; $b6df
	dc.w	$b716	; $b6e1
	dc.w	$b6f3	; $b6e3
	dc.w	$b72a	; $b6e5
jump_table_b7f4:
	dc.w	$b802	; $b7f4
	dc.w	$b9fc	; $b7f6
	dc.w	$bb2a	; $b7f8
	dc.w	$bba5	; $b7fa
	dc.w	$bc20	; $b7fc
	dc.w	$bc76	; $b7fe
	dc.w	$bd4d	; $b800
jump_table_b81c:
	dc.w	$b820	; $b81c
	dc.w	$b83d	; $b81e
jump_table_b909:
	dc.w	$b935	; $b909
	dc.w	$b90f	; $b90b
	dc.w	$b92f	; $b90d
jump_table_ba13:
	dc.w	$ba35	; $ba13
	dc.w	$ba6f	; $ba15
	dc.w	$ba75	; $ba17
	dc.w	$baa1	; $ba19
	dc.w	$bab8	; $ba1b
	dc.w	$bac5	; $ba1d
	dc.w	$baea	; $ba1f
	dc.w	$ba25	; $ba21
	dc.w	$ffff	; $ba23
jump_table_bb32:
	dc.w	$bb3a	; $bb32
	dc.w	$bb4e	; $bb34
	dc.w	$bb57	; $bb36
	dc.w	$bb7d	; $bb38
jump_table_bbb3:
	dc.w	$bbb7	; $bbb3
	dc.w	$bbf4	; $bbb5
jump_table_bc28:
	dc.w	$bc2e	; $bc28
	dc.w	$bc36	; $bc2a
	dc.w	$bc58	; $bc2c
jump_table_bc8d:
	dc.w	$bc99	; $bc8d
	dc.w	$bcd9	; $bc8f
	dc.w	$bcf0	; $bc91
	dc.w	$bd00	; $bc93
	dc.w	$bac5	; $bc95
	dc.w	$baea	; $bc97
jump_table_bd55:
	dc.w	$bd61	; $bd55
	dc.w	$bd86	; $bd57
	dc.w	$bd99	; $bd59
	dc.w	$bdb4	; $bd5b
	dc.w	$bded	; $bd5d
	dc.w	$be47	; $bd5f
jump_table_be9c:
	dc.w	$bea2	; $be9c
	dc.w	$e886	; $be9e
	dc.w	$beaf	; $bea0
jump_table_bedd:
	dc.w	$bee5	; $bedd
	dc.w	$bf42	; $bedf
	dc.w	$c35c	; $bee1
	dc.w	$c38a	; $bee3
jump_table_bf48:
	dc.w	$bf4c	; $bf48
	dc.w	$c0b5	; $bf4a
jump_table_c0cc:
	dc.w	$c0da	; $c0cc
	dc.w	$c1db	; $c0ce
	dc.w	$c227	; $c0d0
	dc.w	$c242	; $c0d2
	dc.w	$ffff	; $c0d4
jump_table_c362:
	dc.w	$c368	; $c362
	dc.w	$e8a7	; $c364
	dc.w	$c375	; $c366
jump_table_c3ab:
	dc.w	$c3b3	; $c3ab
	dc.w	$c3d7	; $c3ad
	dc.w	$c4af	; $c3af
	dc.w	$c4da	; $c3b1
jump_table_c3dd:
	dc.w	$c3e3	; $c3dd
	dc.w	$c405	; $c3df
	dc.w	$c448	; $c3e1
jump_table_c40d:
	dc.w	$c413	; $c40d
	dc.w	$c41a	; $c40f
	dc.w	$c43d	; $c411
jump_table_c450:
	dc.w	$c454	; $c450
	dc.w	$c46e	; $c452
jump_table_c4b5:
	dc.w	$c4bb	; $c4b5
	dc.w	$e85b	; $c4b7
	dc.w	$c4c5	; $c4b9
jump_table_c4f2:
	dc.w	$c4fa	; $c4f2
	dc.w	$c575	; $c4f4
	dc.w	$cbf8	; $c4f6
	dc.w	$cc23	; $c4f8
jump_table_c57b:
	dc.w	$c587	; $c57b
	dc.w	$c5bd	; $c57d
	dc.w	$c7c5	; $c57f
	dc.w	$ca1a	; $c581
	dc.w	$ca8c	; $c583
	dc.w	$cbaf	; $c585
jump_table_c58f:
	dc.w	$c593	; $c58f
	dc.w	$c5a0	; $c591
jump_table_c642:
	dc.w	$c696	; $c642
	dc.w	$c6f0	; $c644
	dc.w	$ffff	; $c646
	dc.w	$ffff	; $c648
	dc.w	$ffff	; $c64a
	dc.w	$ffff	; $c64c
jump_table_c7cd:
	dc.w	$c7dd	; $c7cd
	dc.w	$c889	; $c7cf
	dc.w	$c8ec	; $c7d1
	dc.w	$c902	; $c7d3
	dc.w	$c957	; $c7d5
	dc.w	$c96e	; $c7d7
	dc.w	$c9b6	; $c7d9
	dc.w	$c9cb	; $c7db
jump_table_ca22:
	dc.w	$ca32	; $ca22
	dc.w	$ca58	; $ca24
jump_table_caa4:
	dc.w	$caaa	; $caa4
	dc.w	$caf8	; $caa6
	dc.w	$cb11	; $caa8
jump_table_cbfe:
	dc.w	$cc04	; $cbfe
	dc.w	$e8a7	; $cc00
	dc.w	$cc0e	; $cc02
jump_table_cc4d:
	dc.w	$cc55	; $cc4d
	dc.w	$cc9b	; $cc4f
	dc.w	$cf07	; $cc51
	dc.w	$cf24	; $cc53
jump_table_cca4:
	dc.w	$ccaa	; $cca4
	dc.w	$cd30	; $cca6
	dc.w	$ce3a	; $cca8
jump_table_cd38:
	dc.w	$cd58	; $cd38
	dc.w	$cd67	; $cd3a
	dc.w	$cd7d	; $cd3c
	dc.w	$cd94	; $cd3e
	dc.w	$cdbf	; $cd40
	dc.w	$cdc5	; $cd42
jump_table_ce42:
	dc.w	$ce4c	; $ce42
	dc.w	$ce93	; $ce44
	dc.w	$ceb4	; $ce46
	dc.w	$cede	; $ce48
	dc.w	$cee4	; $ce4a
jump_table_cf0d:
	dc.w	$cf13	; $cf0d
	dc.w	$e85b	; $cf0f
	dc.w	$cf1c	; $cf11
jump_table_cf3e:
	dc.w	$cf46	; $cf3e
	dc.w	$cfa6	; $cf40
	dc.w	$d2a0	; $cf42
	dc.w	$d2cb	; $cf44
jump_table_cfc2:
	dc.w	$cfee	; $cfc2
	dc.w	$d0d0	; $cfc4
	dc.w	$d1d5	; $cfc6
	dc.w	$cfca	; $cfc8
jump_table_cfd2:
	dc.w	$cfd6	; $cfd2
	dc.w	$cfe0	; $cfd4
jump_table_cff6:
	dc.w	$cffc	; $cff6
	dc.w	$d005	; $cff8
	dc.w	$d094	; $cffa
jump_table_d0d8:
	dc.w	$d0e2	; $d0d8
	dc.w	$d0fd	; $d0da
	dc.w	$d144	; $d0dc
	dc.w	$d1b7	; $d0de
	dc.w	$d1c8	; $d0e0
jump_table_d1dd:
	dc.w	$d1e5	; $d1dd
	dc.w	$d245	; $d1df
	dc.w	$d281	; $d1e1
	dc.w	$d297	; $d1e3
jump_table_d2a6:
	dc.w	$d2ac	; $d2a6
	dc.w	$e886	; $d2a8
	dc.w	$d2b6	; $d2aa
jump_table_d2e5:
	dc.w	$d2ed	; $d2e5
	dc.w	$d3d0	; $d2e7
	dc.w	$d4e9	; $d2e9
	dc.w	$d506	; $d2eb
jump_table_d2ff:
	dc.w	$d307	; $d2ff
	dc.w	$d316	; $d301
	dc.w	$d357	; $d303
	dc.w	$d35e	; $d305
jump_table_d382:
	dc.w	$d386	; $d382
	dc.w	$d3b4	; $d384
jump_table_d3d9:
	dc.w	$d3dd	; $d3d9
	dc.w	$d4a7	; $d3db
jump_table_d4af:
	dc.w	$d4b3	; $d4af
	dc.w	$d4ce	; $d4b1
jump_table_d4ef:
	dc.w	$d4f5	; $d4ef
	dc.w	$e85b	; $d4f1
	dc.w	$d4fe	; $d4f3
jump_table_d520:
	dc.w	$d528	; $d520
	dc.w	$d6d6	; $d522
	dc.w	$da01	; $d524
	dc.w	$dab7	; $d526
jump_table_d53c:
	dc.w	$d542	; $d53c
	dc.w	$d5a9	; $d53e
	dc.w	$d633	; $d540
jump_table_d706:
	dc.w	$d70c	; $d706
	dc.w	$d94b	; $d708
	dc.w	$d94b	; $d70a
jump_table_d712:
	dc.w	$d716	; $d712
	dc.w	$d7ee	; $d714
jump_table_da07:
	dc.w	$da15	; $da07
	dc.w	$da6d	; $da09
	dc.w	$e8a7	; $da0b
	dc.w	$da87	; $da0d
	dc.w	$da7b	; $da0f
	dc.w	$e886	; $da11
	dc.w	$daa2	; $da13
jump_table_dae1:
	dc.w	$dae9	; $dae1
	dc.w	$db6e	; $dae3
	dc.w	$dd67	; $dae5
	dc.w	$dda3	; $dae7
jump_table_db74:
	dc.w	$db7a	; $db74
	dc.w	$db8e	; $db76
	dc.w	$dbcb	; $db78
jump_table_dd6d:
	dc.w	$dd73	; $dd6d
	dc.w	$e8d0	; $dd6f
	dc.w	$dd8c	; $dd71
jump_table_dec3:
	dc.w	$decb	; $dec3
	dc.w	$defe	; $dec5
	dc.w	$df9f	; $dec7
	dc.w	$dfbc	; $dec9
jump_table_df04:
	dc.w	$df0a	; $df04
	dc.w	$df11	; $df06
	dc.w	$df59	; $df08
jump_table_df19:
	dc.w	$df1d	; $df19
	dc.w	$df35	; $df1b
jump_table_df61:
	dc.w	$df65	; $df61
	dc.w	$df71	; $df63
jump_table_dfa5:
	dc.w	$dfab	; $dfa5
	dc.w	$e886	; $dfa7
	dc.w	$dfb4	; $dfa9
jump_table_dfda:
	dc.w	$dfe2	; $dfda
	dc.w	$e027	; $dfdc
	dc.w	$e27b	; $dfde
	dc.w	$e2a9	; $dfe0
jump_table_e02d:
	dc.w	$e037	; $e02d
	dc.w	$e03e	; $e02f
	dc.w	$e0d2	; $e031
	dc.w	$e1e2	; $e033
	dc.w	$e229	; $e035
jump_table_e050:
	dc.w	$e058	; $e050
	dc.w	$e083	; $e052
	dc.w	$e09e	; $e054
	dc.w	$e0b9	; $e056
jump_table_e0da:
	dc.w	$e0e4	; $e0da
	dc.w	$e0eb	; $e0dc
	dc.w	$e119	; $e0de
	dc.w	$e128	; $e0e0
	dc.w	$e14b	; $e0e2
jump_table_e1ea:
	dc.w	$e0e4	; $e1ea
	dc.w	$e0eb	; $e1ec
	dc.w	$e1f4	; $e1ee
	dc.w	$e203	; $e1f0
	dc.w	$e14b	; $e1f2
jump_table_e231:
	dc.w	$e0e4	; $e231
	dc.w	$e0eb	; $e233
	dc.w	$e23b	; $e235
	dc.w	$e250	; $e237
	dc.w	$e14b	; $e239
jump_table_e281:
	dc.w	$e287	; $e281
	dc.w	$e886	; $e283
	dc.w	$e294	; $e285
jump_table_e31d:
	dc.w	$e325	; $e31d
	dc.w	$e360	; $e31f
	dc.w	$e5ee	; $e321
	dc.w	$e607	; $e323
jump_table_e366:
	dc.w	$e36c	; $e366
	dc.w	$e382	; $e368
	dc.w	$e38a	; $e36a
jump_table_e39c:
	dc.w	$e3bf	; $e39c
	dc.w	$e3f9	; $e39e
	dc.w	$e482	; $e3a0
	dc.w	$e49d	; $e3a2
	dc.w	$e3a8	; $e3a4
	dc.w	$e50b	; $e3a6
jump_table_e3b0:
	dc.w	$e3b4	; $e3b0
	dc.w	$e482	; $e3b2
jump_table_e3fa:
	dc.w	$e402	; $e3fa
	dc.w	$e425	; $e3fc
	dc.w	$e448	; $e3fe
	dc.w	$e448	; $e400
jump_table_e4a5:
	dc.w	$e482	; $e4a5
	dc.w	$e4a9	; $e4a7
jump_table_e513:
	dc.w	$e517	; $e513
	dc.w	$e51c	; $e515
jump_table_e5f4:
	dc.w	$e5f8	; $e5f4
	dc.w	$e5fe	; $e5f6
jump_table_e63b:
	dc.w	$e643	; $e63b
	dc.w	$e670	; $e63d
	dc.w	$e822	; $e63f
	dc.w	$e83b	; $e641
jump_table_e67e:
	dc.w	$e686	; $e67e
	dc.w	$e6dc	; $e680
	dc.w	$e730	; $e682
	dc.w	$e763	; $e684
jump_table_e6e4:
	dc.w	$e6e8	; $e6e4
	dc.w	$e6f7	; $e6e6
jump_table_e738:
	dc.w	$e73c	; $e738
	dc.w	$e742	; $e73a
jump_table_e828:
	dc.w	$e82c	; $e828
	dc.w	$e832	; $e82a
jump_table_e863:
	dc.w	$e867	; $e863
	dc.w	$e90d	; $e865
jump_table_e88e:
	dc.w	$e892	; $e88e
	dc.w	$e90d	; $e890
jump_table_e8af:
	dc.w	$e8de	; $e8af
	dc.w	$e8b5	; $e8b1
	dc.w	$e90d	; $e8b3
jump_table_e8d8:
	dc.w	$e8de	; $e8d8
	dc.w	$e8f3	; $e8da
	dc.w	$e90d	; $e8dc
jump_table_e97e:
	dc.w	$e982	; $e97e
	dc.w	$e9f7	; $e980
jump_table_e9fd:
	dc.w	$ea01	; $e9fd
	dc.w	$ea07	; $e9ff
jump_table_ea49:
	dc.w	$ea4f	; $ea49
	dc.w	$ea7b	; $ea4b
	dc.w	$ece2	; $ea4d
jump_table_ea81:
	dc.w	$ea88	; $ea81
	dc.w	$eab3	; $ea83
	dc.w	$eb70	; $ea85
jump_table_eae8:
	dc.w	$eb34	; $eae8
	dc.w	$eb34	; $eaea
	dc.w	$eb34	; $eaec
	dc.w	$eb34	; $eaee
	dc.w	$eb34	; $eaf0
	dc.w	$eb08	; $eaf2
	dc.w	$eb08	; $eaf4
	dc.w	$eb34	; $eaf6
	dc.w	$eb08	; $eaf8
	dc.w	$eb34	; $eafa
	dc.w	$eb08	; $eafc
	dc.w	$eb34	; $eafe
	dc.w	$eb08	; $eb00
	dc.w	$eb08	; $eb02
	dc.w	$eb34	; $eb04
	dc.w	$eb34	; $eb06
jump_table_eac8:
	dc.w	$eb43	; $eac8
	dc.w	$eb43	; $eaca
	dc.w	$eb43	; $eacc
	dc.w	$eb43	; $eace
	dc.w	$eb43	; $ead0
	dc.w	$eb43	; $ead2
	dc.w	$eb43	; $ead4
	dc.w	$ec83	; $ead6
	dc.w	$eb43	; $ead8
	dc.w	$eb43	; $eada
	dc.w	$eb43	; $eadc
	dc.w	$eca9	; $eade
	dc.w	$eb43	; $eae0
	dc.w	$eb43	; $eae2
	dc.w	$eb35	; $eae4
	dc.w	$eb35	; $eae6
	dc.w	$eb34	; $eae8
	dc.w	$eb34	; $eaea
	dc.w	$eb34	; $eaec
	dc.w	$eb34	; $eaee
	dc.w	$eb34	; $eaf0
	dc.w	$eb08	; $eaf2
	dc.w	$eb08	; $eaf4
	dc.w	$eb34	; $eaf6
	dc.w	$eb08	; $eaf8
	dc.w	$eb34	; $eafa
	dc.w	$eb08	; $eafc
	dc.w	$eb34	; $eafe
	dc.w	$eb08	; $eb00
	dc.w	$eb08	; $eb02
	dc.w	$eb34	; $eb04
	dc.w	$eb34	; $eb06
jump_table_ebec:
	dc.w	$ebfa	; $ebec
	dc.w	$ebfa	; $ebee
	dc.w	$ec09	; $ebf0
	dc.w	$ebfa	; $ebf2
	dc.w	$ec2e	; $ebf4
	dc.w	$ebfa	; $ebf6
	dc.w	$ec09	; $ebf8
jump_table_ece8:
	dc.w	$ecee	; $ece8
	dc.w	$ecfe	; $ecea
	dc.w	$ed13	; $ecec
jump_table_ed60:
	dc.w	$ed64	; $ed60
	dc.w	$ed57	; $ed62
jump_table_edb0:
	dc.w	$edb6	; $edb0
	dc.w	$edc5	; $edb2
	dc.w	$edce	; $edb4
jump_table_ee13:
	dc.w	$ee32	; $ee13
	dc.w	$ee43	; $ee15
	dc.w	$ee43	; $ee17
	dc.w	$ee21	; $ee19
	dc.w	$ee43	; $ee1b
	dc.w	$ee43	; $ee1d
	dc.w	$ee43	; $ee1f
jump_table_eed8:
	dc.w	$eee6	; $eed8
	dc.w	$eee6	; $eeda
	dc.w	$eef7	; $eedc
	dc.w	$eee6	; $eede
	dc.w	$eef8	; $eee0
	dc.w	$eef8	; $eee2
	dc.w	$eef7	; $eee4
jump_table_f87a:
	dc.w	$f890	; $f87a
	dc.w	$f8aa	; $f87c
	dc.w	$f8d2	; $f87e
	dc.w	$f901	; $f880
	dc.w	$f945	; $f882
	dc.w	$f9da	; $f884
	dc.w	$fa1e	; $f886
	dc.w	$fb21	; $f888
	dc.w	$fb7b	; $f88a
	dc.w	$fbad	; $f88c
	dc.w	$fc1a	; $f88e
jump_table_fc80:
	dc.w	$fc88	; $fc80
	dc.w	$fe83	; $fc82
	dc.w	$feca	; $fc84
	dc.w	$fecd	; $fc86
jump_table_fc90:
	dc.w	$fcc5	; $fc90
	dc.w	$fca8	; $fc92
	dc.w	$fca8	; $fc94
	dc.w	$fca8	; $fc96
	dc.w	$fccc	; $fc98
	dc.w	$fca8	; $fc9a
	dc.w	$fd2d	; $fc9c
	dc.w	$fd35	; $fc9e
	dc.w	$fd17	; $fca0
	dc.w	$fca8	; $fca2
	dc.w	$fd17	; $fca4
	dc.w	$fcb5	; $fca6
jump_table_fe8b:
	dc.w	$febe	; $fe8b
	dc.w	$febe	; $fe8d
	dc.w	$febe	; $fe8f
	dc.w	$febe	; $fe91
	dc.w	$fea3	; $fe93
	dc.w	$febe	; $fe95
	dc.w	$febe	; $fe97
	dc.w	$febe	; $fe99
	dc.w	$febe	; $fe9b
	dc.w	$febe	; $fe9d
	dc.w	$fea3	; $fe9f
	dc.w	$febe	; $fea1
