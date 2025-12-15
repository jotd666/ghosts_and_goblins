
4800: 8E 20 00    LDX    #$2000
4803: 10 8E 00 20 LDY    #$0020
4807: 32 7F       LEAS   -$1,S
4809: C6 20       LDB    #$20
480B: E7 E4       STB    ,S
480D: 86 20       LDA    #$20
480F: C6 00       LDB    #$00
4811: E7 89 04 00 STB    $0400,X
4815: A7 80       STA    ,X+
4817: 6A E4       DEC    ,S
4819: 26 F6       BNE    $4811
481B: 31 3F       LEAY   -$1,Y
481D: 26 EA       BNE    $4809
481F: 32 61       LEAS   $1,S
4821: 5F          CLRB
4822: BD 48 9B    JSR    $489B
4825: 10 8E 00 D0 LDY    #$00D0
4829: 8E 20 6C    LDX    #$206C
482C: D6 F1       LDB    $F1
482E: BD 50 25    JSR    $5025
4831: D6 26       LDB    $26
4833: C4 01       ANDB   #$01
4835: 27 11       BEQ    $4848
4837: C6 02       LDB    #$02
4839: BD 48 9B    JSR    $489B
483C: 10 8E 04 48 LDY    #$0448
4840: 8E 20 75    LDX    #$2075
4843: D6 F1       LDB    $F1
4845: BD 50 25    JSR    $5025
4848: C6 01       LDB    #$01
484A: BD 48 9B    JSR    $489B
484D: 10 8E 00 68 LDY    #$0068
4851: 8E 20 61    LDX    #$2061
4854: D6 F1       LDB    $F1
4856: BD 50 25    JSR    $5025
4859: 0F F0       CLR    $F0
485B: 39          RTS
485C: 5D          TSTB
485D: 2B 1E       BMI    $487D
485F: D7 FD       STB    $FD
4861: 8E 20 80    LDX    #$2080
4864: C6 20       LDB    #$20
4866: D7 FC       STB    $FC
4868: 86 20       LDA    #$20
486A: C6 00       LDB    #$00
486C: E7 89 04 00 STB    $0400,X
4870: A7 80       STA    ,X+
4872: 0A FC       DEC    $FC
4874: 26 F6       BNE    $486C
4876: 0A FD       DEC    $FD
4878: 26 EA       BNE    $4864
487A: 0F F0       CLR    $F0
487C: 39          RTS
487D: C4 7F       ANDB   #$7F
487F: C1 1F       CMPB   #$1F
4881: 22 17       BHI    $489A
4883: 86 20       LDA    #$20
4885: 3D          MUL
4886: C3 20 00    ADDD   #$2000
4889: 1F 01       TFR    D,X
488B: 86 20       LDA    #$20
488D: C6 00       LDB    #$00
488F: E7 89 04 00 STB    $0400,X
4893: A7 80       STA    ,X+
4895: 8C 23 FF    CMPX   #$23FF
4898: 23 F5       BLS    $488F
489A: 39          RTS
489B: 34 40       PSHS   U
489D: 58          ASLB
489E: 25 20       BCS    $48C0
48A0: C4 7F       ANDB   #$7F
48A2: 8E 48 DD    LDX    #$48DD
48A5: EE 85       LDU    B,X
48A7: AE C1       LDX    ,U++
48A9: A6 C0       LDA    ,U+
48AB: E6 C0       LDB    ,U+
48AD: 27 0C       BEQ    $48BB
48AF: C1 2F       CMPB   #$2F
48B1: 27 F4       BEQ    $48A7
48B3: A7 89 04 00 STA    $0400,X
48B7: E7 80       STB    ,X+
48B9: 20 F0       BRA    $48AB
48BB: 35 C0       PULS   U,PC
48BD: 34 40       PSHS   U
48BF: 58          ASLB
48C0: 8E 48 DD    LDX    #$48DD
48C3: EE 85       LDU    B,X
48C5: AE C1       LDX    ,U++
48C7: 33 41       LEAU   $1,U
48C9: 96 F2       LDA    $F2
48CB: E6 C0       LDB    ,U+
48CD: 27 EC       BEQ    $48BB
48CF: C1 2F       CMPB   #$2F
48D1: 27 F2       BEQ    $48C5
48D3: A7 89 04 00 STA    $0400,X
48D7: C6 20       LDB    #$20
48D9: E7 80       STB    ,X+
48DB: 20 EE       BRA    $48CB

5022: D7 F1       STB    $F1                                         
5024: 39          RTS                                                

5027: C6 08       LDB    #$08
5029: D7 FC       STB    $FC
502B: 86 20       LDA    #$20
502D: A7 80       STA    ,X+
502F: 0A FC       DEC    $FC
5031: 26 FA       BNE    $502D
5033: 35 04       PULS   B
5035: AE E4       LDX    ,S
5037: 86 04       LDA    #$04
5039: 97 FC       STA    $FC
503B: 8D 14       BSR    $5051
503D: 0A FC       DEC    $FC
503F: 26 FA       BNE    $503B
5041: 35 10       PULS   X
5043: C6 20       LDB    #$20
5045: 86 07       LDA    #$07
5047: 6D 84       TST    ,X
5049: 26 05       BNE    $5050
504B: E7 80       STB    ,X+
504D: 4A          DECA
504E: 26 F7       BNE    $5047
5050: 39          RTS
5051: A6 A4       LDA    ,Y
5053: 44          LSRA
5054: 44          LSRA
5055: 44          LSRA
5056: 44          LSRA
5057: 8D 02       BSR    $505B
5059: A6 A0       LDA    ,Y+
505B: 84 0F       ANDA   #$0F
505D: E7 89 04 00 STB    $0400,X
5061: A7 80       STA    ,X+
5063: 39          RTS
5064: 34 10       PSHS   X
5066: 36 06       PSHU   D
5068: C6 10       LDB    #$10
506A: 36 04       PSHU   B
506C: 4F          CLRA
506D: 5F          CLRB
506E: 36 06       PSHU   D
5070: 36 02       PSHU   A
5072: 31 43       LEAY   $3,U
5074: 8E 50 B4    LDX    #$50B4
5077: 64 44       LSR    $4,U
5079: 66 45       ROR    $5,U
507B: 24 02       BCC    $507F
507D: 8D 21       BSR    $50A0
507F: 30 03       LEAX   $3,X
5081: 6A 43       DEC    $3,U
5083: 26 F2       BNE    $5077
5085: 30 43       LEAX   $3,U
5087: 31 46       LEAY   $6,U
5089: C6 03       LDB    #$03
508B: A6 82       LDA    ,-X
508D: 84 0F       ANDA   #$0F
508F: A7 A2       STA    ,-Y
5091: A6 84       LDA    ,X
5093: 44          LSRA
5094: 44          LSRA
5095: 44          LSRA
5096: 44          LSRA
5097: 84 0F       ANDA   #$0F
5099: A7 A2       STA    ,-Y
509B: 5A          DECB
509C: 26 ED       BNE    $508B
509E: 35 90       PULS   X,PC
50A0: 34 30       PSHS   Y,X
50A2: C6 03       LDB    #$03
50A4: 4F          CLRA
50A5: A6 A2       LDA    ,-Y
50A7: A9 82       ADCA   ,-X
50A9: 19          DAA
50AA: A7 A4       STA    ,Y
50AC: 5A          DECB
50AD: 26 F6       BNE    $50A5
50AF: 35 B0       PULS   X,Y,PC

50DD: 84 03       ANDA   #$03
50DF: 27 68       BEQ    $5149
50E1: BD 50 64    JSR    $5064
50E4: C6 20       LDB    #$20
50E6: E7 84       STB    ,X
50E8: E7 01       STB    $1,X
50EA: E7 02       STB    $2,X
50EC: E7 03       STB    $3,X
50EE: E7 04       STB    $4,X
50F0: E7 05       STB    $5,X
50F2: 96 F1       LDA    $F1
50F4: 30 89 04 00 LEAX   $0400,X
50F8: A7 84       STA    ,X
50FA: A7 01       STA    $1,X
50FC: A7 02       STA    $2,X
50FE: A7 03       STA    $3,X
5100: A7 04       STA    $4,X
5102: A7 05       STA    $5,X
5104: 30 89 FC 00 LEAX   -$0400,X
5108: C6 06       LDB    #$06
510A: A6 C4       LDA    ,U
510C: 26 08       BNE    $5116
510E: 33 41       LEAU   $1,U
5110: 5A          DECB
5111: 26 F7       BNE    $510A
5113: A7 84       STA    ,X
5115: 39          RTS
5116: A6 C0       LDA    ,U+
5118: A7 80       STA    ,X+
511A: 5A          DECB
511B: 26 F9       BNE    $5116
511D: 39          RTS
511E: 96 0F       LDA    $0F
5120: 26 13       BNE    $5135
5122: 96 51       LDA    $51
5124: 26 10       BNE    $5136
5126: C6 03       LDB    #$03
5128: BD 48 9B    JSR    $489B
512B: DC 22       LDD    $22
512D: 8E 23 A1    LDX    #$23A1
5130: 30 08       LEAX   $8,X
5132: 7E 50 E1    JMP    $50E1
5135: 39          RTS
5136: C6 04       LDB    #$04
5138: 7E 48 9B    JMP    $489B
513B: C6 07       LDB    #$07
513D: 8E 23 A0    LDX    #$23A0
5140: 8D 36       BSR    $5178
5142: D6 60       LDB    $60
5144: 27 10       BEQ    $5156
5146: 5A          DECB
5147: 27 0D       BEQ    $5156
5149: C1 07       CMPB   #$07
514B: 23 02       BLS    $514F
514D: C6 07       LDB    #$07
514F: D7 FC       STB    $FC
5151: 8E 23 A0    LDX    #$23A0
5154: 8D 01       BSR    $5157
5156: 39          RTS
5157: 10 8E 51 74 LDY    #$5174
515B: CC 0D 0D    LDD    #$0D0D
515E: ED 89 04 00 STD    $0400,X
5162: ED 89 03 E0 STD    $03E0,X
5166: EC A1       LDD    ,Y++
5168: ED 88 E0    STD    -$20,X
516B: EC A4       LDD    ,Y
516D: ED 81       STD    ,X++
516F: 0A FC       DEC    $FC
5171: 26 E4       BNE    $5157
5173: 39          RTS
5174: 8A 8B       ORA    #$8B
5176: 9A 9B       ORA    $9B
5178: 86 20       LDA    #$20
517A: A7 80       STA    ,X+
517C: 5A          DECB
517D: 26 FB       BNE    $517A
517F: 39          RTS
5180: 34 40       PSHS   U
5182: CE 21 06    LDU    #$2106
5185: 8E 51 A3    LDX    #$51A3
5188: C6 04       LDB    #$04
518A: D7 FD       STB    $FD
518C: C6 16       LDB    #$16
518E: 86 47       LDA    #$47
5190: A7 C9 04 00 STA    $0400,U
5194: A6 80       LDA    ,X+
5196: A7 C0       STA    ,U+
5198: 5A          DECB
5199: 26 F3       BNE    $518E
519B: 33 4A       LEAU   $A,U
519D: 0A FD       DEC    $FD
519F: 26 EB       BNE    $518C
51A1: 35 C0       PULS   U,PC
51A3: 00 01       NEG    $01
51A5: 02 03       XNC    $03
51A7: 04 05       LSR    $05
51A9: 06 07       ROR    $07
51AB: 08 09       ASL    $09
51AD: 0A 0B       DEC    $0B
51AF: 0C 0D       INC    $0D
51B1: 0E 0F       JMP    $0F
51B3: 40          NEGA
51B4: 41          NEGA
51B5: 42          XNCA
51B6: 43          COMA
51B7: 44          LSRA
51B8: 70 10 11    NEG    $1011
51BB: 12          NOP
51BC: 13          SYNC
51BD: 14          XHCF
51BE: 15          XHCF
51BF: 16 17 18    LBRA   $68DA
51C2: 19          DAA
51C3: 1A 1B       ORCC   #$1B
51C5: 1C 1D       ANDCC  #$1D
51C7: 1E 1F       EXG    X,inv
51C9: 50          NEGB
51CA: 51          NEGB
51CB: 52          XNCB
51CC: 53          COMB
51CD: 54          LSRB
51CE: 71 20 21    NEG    $2021
51D1: 22 23       BHI    $51F6
51D3: 24 25       BCC    $51FA
51D5: 26 27       BNE    $51FE
51D7: 28 29       BVC    $5202
51D9: 2A 2B       BPL    $5206
51DB: 2C 2D       BGE    $520A
51DD: 2E 2F       BGT    $520E
51DF: 60 61       NEG    $1,S
51E1: 62 63       XNC    $3,S
51E3: 64 72       LSR    -$E,S
51E5: 30 30       LEAX   -$10,Y
51E7: 30 30       LEAX   -$10,Y
51E9: 30 30       LEAX   -$10,Y
51EB: 30 30       LEAX   -$10,Y
51ED: 30 30       LEAX   -$10,Y
51EF: 30 30       LEAX   -$10,Y
51F1: 30 30       LEAX   -$10,Y
51F3: 30 30       LEAX   -$10,Y
51F5: 30 30       LEAX   -$10,Y
51F7: 30 30       LEAX   -$10,Y
51F9: 30 30       LEAX   -$10,Y
51FB: A8 C0       EORA   ,U+
51FD: C7 00       XSTB   #$00
51FF: 60 00       NEG    $0,X
5201: 00 00       NEG    $00
5203: 88 66       EORA   #$66
5205: AA 00       ORA    $0,X
5207: A0 80       SUBA   ,X+
5209: C0 00       SUBB   #$00
520B: A8 88 AA    EORA   -$56,X
520E: 00 60       NEG    $60
5210: A0 C0       SUBA   ,U+
5212: 00 99       NEG    $99
5214: AA C0       ORA    ,U+
5216: 00 00       NEG    $00
5218: C0 00       SUBB   #$00
521A: 00 88       NEG    $88
521C: AA C0       ORA    ,U+
521E: 00 A0       NEG    $A0
5220: C0 00       SUBB   #$00
5222: 00 D6       NEG    $D6
5224: 73 58 58    COM    $5858
5227: 58          ASLB
5228: 8E 51 FB    LDX    #$51FB
522B: 31 85       LEAY   B,X
522D: 8E 04 BC    LDX    #$04BC
5230: C6 04       LDB    #$04
5232: A6 24       LDA    $4,Y
5234: A7 88 40    STA    $40,X
5237: A6 A0       LDA    ,Y+
5239: A7 80       STA    ,X+
523B: 5A          DECB
523C: 26 F4       BNE    $5232
523E: 39          RTS
523F: 34 40       PSHS   U
5241: 34 04       PSHS   B
5243: 8D 28       BSR    $526D
5245: E6 E0       LDB    ,S+
5247: 26 22       BNE    $526B
5249: 8D D8       BSR    $5223
524B: 8E 23 6F    LDX    #$236F
524E: CE 52 A5    LDU    #$52A5
5251: D6 73       LDB    $73
5253: 58          ASLB
5254: 58          ASLB
5255: 33 C5       LEAU   B,U
5257: EC C1       LDD    ,U++
5259: ED 84       STD    ,X
525B: EC C1       LDD    ,U++
525D: ED 88 20    STD    $20,X
5260: CC 0F 0F    LDD    #$0F0F
5263: ED 89 04 00 STD    $0400,X
5267: ED 89 04 20 STD    $0420,X
526B: 35 C0       PULS   U,PC
526D: 8E 23 4E    LDX    #$234E
5270: CE 52 95    LDU    #$5295
5273: C6 04       LDB    #$04
5275: D7 FC       STB    $FC
5277: EC C1       LDD    ,U++
5279: ED 84       STD    ,X
527B: CC 0E 0E    LDD    #$0E0E
527E: ED 89 04 00 STD    $0400,X
5282: EC C1       LDD    ,U++
5284: ED 02       STD    $2,X
5286: CC 0E 0E    LDD    #$0E0E
5289: ED 89 04 02 STD    $0402,X
528D: 30 88 20    LEAX   $20,X
5290: 0A FC       DEC    $FC
5292: 26 E3       BNE    $5277
5294: 39          RTS
5295: A0 A1       SUBA   ,Y++
5297: A2 A3       SBCA   ,--Y
5299: B0 20 20    SUBA   $2020
529C: B3 C0 20    SUBD   $C020
529F: 20 C3       BRA    $5264
52A1: D0 D1       SUBB   $D1
52A3: D2 D3       SBCB   $D3
52A5: 82 83       SBCA   #$83
52A7: 92 93       SBCA   $93
52A9: 80 81       SUBA   #$81
52AB: 90 91       SUBA   $91
52AD: 88 89       EORA   #$89
52AF: 98 99       EORA   $99
52B1: 86 87       LDA    #$87
52B3: 96 97       LDA    $97
52B5: 84 85       ANDA   #$85
52B7: 94 95       ANDA   $95
52B9: C6 26       LDB    #$26
52BB: BD 48 9B    JSR    $489B
52BE: 9E AA       LDX    $AA
52C0: CC 00 3C    LDD    #$003C
52C3: 36 10       PSHU   X
52C5: BD FE F0    JSR    $FEF0
52C8: DD FC       STD    $FC
52CA: 37 06       PULU   D
52CC: 8E 20 A2    LDX    #$20A2
52CF: 86 0B       LDA    #$0B
52D1: A7 89 04 00 STA    $0400,X
52D5: E7 80       STB    ,X+
52D7: A7 89 04 00 STA    $0400,X
52DB: C6 3A       LDB    #$3A
52DD: E7 80       STB    ,X+
52DF: 34 12       PSHS   X,A
52E1: DC FC       LDD    $FC
52E3: BD 50 64    JSR    $5064
52E6: 35 12       PULS   A,X
52E8: 33 44       LEAU   $4,U
52EA: A7 89 04 00 STA    $0400,X
52EE: E6 C0       LDB    ,U+
52F0: E7 80       STB    ,X+
52F2: A7 89 04 00 STA    $0400,X
52F6: E6 C0       LDB    ,U+
52F8: E7 80       STB    ,X+
52FA: 39          RTS
52FB: 34 40       PSHS   U
52FD: D6 54       LDB    $54
52FF: BD 53 0F    JSR    $530F
5302: BD 53 1F    JSR    $531F
5305: D6 54       LDB    $54
5307: 54          LSRB
5308: 24 03       BCC    $530D
530A: BD 53 30    JSR    $5330
530D: 35 C0       PULS   U,PC
530F: C6 0D       LDB    #$0D
5311: BD 48 9B    JSR    $489B
5314: BE 53 41    LDX    $5341
5317: 10 9E 55    LDY    $55
531A: C6 03       LDB    #$03
531C: 7E 50 25    JMP    $5025
531F: C6 0E       LDB    #$0E
5321: BD 48 9B    JSR    $489B
5324: BE 53 43    LDX    $5343
5327: DE 55       LDU    $55
5329: 31 44       LEAY   $4,U
532B: C6 03       LDB    #$03
532D: 7E 50 25    JMP    $5025
5330: C6 0F       LDB    #$0F
5332: BD 48 9B    JSR    $489B
5335: BE 53 45    LDX    $5345
5338: DE 55       LDU    $55
533A: 31 48       LEAY   $8,U
533C: C6 03       LDB    #$03
533E: 7E 50 25    JMP    $5025
5341: 22 4E       BHI    $5391
5343: 22 8E       BHI    $52D3
5345: 22 CE       BHI    $5315
5347: 34 40       PSHS   U
5349: 96 51       LDA    $51
534B: 26 38       BNE    $5385
534D: 8E 15 82    LDX    #$1582
5350: 10 8E 21 E8 LDY    #$21E8
5354: 86 00       LDA    #$00
5356: A7 A9 04 00 STA    $0400,Y
535A: A6 03       LDA    $3,X
535C: 8B 30       ADDA   #$30
535E: A7 A0       STA    ,Y+
5360: 8E 53 99    LDX    #$5399
5363: 8D 23       BSR    $5388
5365: 8E 15 82    LDX    #$1582
5368: A6 03       LDA    $3,X
536A: 4A          DECA
536B: 27 0A       BEQ    $5377
536D: 86 00       LDA    #$00
536F: A7 A9 04 00 STA    $0400,Y
5373: 86 53       LDA    #$53
5375: A7 A0       STA    ,Y+
5377: 31 23       LEAY   $3,Y
5379: B6 15 86    LDA    $1586
537C: 8B 30       ADDA   #$30
537E: A7 A0       STA    ,Y+
5380: 8E 53 9E    LDX    #$539E
5383: 8D 03       BSR    $5388
5385: 35 40       PULS   U
5387: 39          RTS
5388: 86 03       LDA    #$03
538A: E6 80       LDB    ,X+
538C: C1 40       CMPB   #$40
538E: 27 08       BEQ    $5398
5390: A7 A9 04 00 STA    $0400,Y
5394: E7 A0       STB    ,Y+
5396: 20 F2       BRA    $538A
5398: 39          RTS
5399: 43          COMA
539A: 4F          CLRA
539B: 49          ROLA
539C: 4E          XCLRA
539D: 40          NEGA
539E: 50          NEGB
539F: 4C          INCA
53A0: 41          NEGA
53A1: 59          ROLB
53A2: 40          NEGA
53A3: 34 40       PSHS   U
53A5: C6 10       LDB    #$10
53A7: BD 48 9B    JSR    $489B
53AA: 10 8E 15 18 LDY    #$1518
53AE: CE 20 CB    LDU    #$20CB
53B1: 30 C4       LEAX   ,U
53B3: 86 0A       LDA    #$0A
53B5: 34 02       PSHS   A
53B7: C6 04       LDB    #$04
53B9: 34 20       PSHS   Y
53BB: 10 AE A4    LDY    ,Y
53BE: 31 24       LEAY   $4,Y
53C0: BD 53 E1    JSR    $53E1
53C3: 10 AE E4    LDY    ,S
53C6: 10 AE A4    LDY    ,Y
53C9: 30 44       LEAX   $4,U
53CB: C6 04       LDB    #$04
53CD: BD 50 25    JSR    $5025
53D0: 33 C8 40    LEAU   $40,U
53D3: 30 C4       LEAX   ,U
53D5: 35 20       PULS   Y
53D7: 31 22       LEAY   $2,Y
53D9: 6A E4       DEC    ,S
53DB: 26 DA       BNE    $53B7
53DD: 32 61       LEAS   $1,S
53DF: 35 C0       PULS   U,PC
53E1: 86 03       LDA    #$03
53E3: 34 02       PSHS   A
53E5: A6 A0       LDA    ,Y+
53E7: E7 89 04 00 STB    $0400,X
53EB: A7 80       STA    ,X+
53ED: 6A E4       DEC    ,S
53EF: 26 F4       BNE    $53E5
53F1: 35 82       PULS   A,PC
53F3: 39          RTS
53F4: 96 28       LDA    $28
53F6: 27 FB       BEQ    $53F3
53F8: 34 40       PSHS   U
53FA: 10 8E 54 57 LDY    #$5457
53FE: 58          ASLB
53FF: 10 AE A5    LDY    B,Y
5402: 96 6B       LDA    $6B
5404: AB A2       ADDA   ,-Y
5406: 19          DAA
5407: 97 6B       STA    $6B
5409: 96 6A       LDA    $6A
540B: A9 A2       ADCA   ,-Y
540D: 19          DAA
540E: 97 6A       STA    $6A
5410: 96 69       LDA    $69
5412: A9 A2       ADCA   ,-Y
5414: 19          DAA
5415: 97 69       STA    $69
5417: 96 68       LDA    $68
5419: A9 A2       ADCA   ,-Y
541B: 19          DAA
541C: 97 68       STA    $68
541E: DC 68       LDD    $68
5420: 10 93 D0    CMPD   $D0
5423: 22 09       BHI    $542E
5425: 25 1B       BCS    $5442
5427: DC 6A       LDD    $6A
5429: 10 93 D2    CMPD   $D2
542C: 25 14       BCS    $5442
542E: DC 68       LDD    $68
5430: DD D0       STD    $D0
5432: DC 6A       LDD    $6A
5434: DD D2       STD    $D2
5436: D6 F1       LDB    $F1
5438: 10 8E 00 D0 LDY    #$00D0
543C: 8E 20 6C    LDX    #$206C
543F: BD 50 25    JSR    $5025
5442: 10 8E 00 68 LDY    #$0068
5446: D6 F1       LDB    $F1
5448: 8E 20 61    LDX    #$2061
544B: 96 27       LDA    $27
544D: 27 03       BEQ    $5452
544F: 8E 20 75    LDX    #$2075
5452: BD 50 25    JSR    $5025
5455: 35 C0       PULS   U,PC
5457: 00 30       NEG    $30
5459: 54          LSRB
545A: 8B 54       ADDA   #$54
545C: 8F 54 93    XSTX   #$5493
545F: 54          LSRB
5460: 97 54       STA    $54
5462: 9B 54       ADDA   $54
5464: 9F 54       STX    $54
5466: A3 54       SUBD   -$C,U
5468: A7 54       STA    -$C,U
546A: AB 54       ADDA   -$C,U
546C: AF 54       STX    -$C,U
546E: B3 54 B7    SUBD   $54B7
5471: 54          LSRB
5472: BB 54 BF    ADDA   $54BF
5475: 54          LSRB
5476: C3 54 C7    ADDD   #$54C7
5479: 54          LSRB
547A: CB 54       ADDB   #$54
547C: CF 54 D3    XSTU   #$54D3
547F: 54          LSRB
5480: D7 54       STB    $54
5482: DB 54       ADDB   $54
5484: DF 54       STU    $54
5486: E3 00       ADDD   $0,X
5488: 00 00       NEG    $00
548A: 10 00 00    NEG    $00
548D: 00 50       NEG    $50
548F: 00 00       NEG    $00
5491: 01 00       NEG    $00
5493: 00 00       NEG    $00
5495: 02 00       XNC    $00
5497: 00 00       NEG    $00
5499: 03 00       COM    $00
549B: 00 00       NEG    $00
549D: 04 00       LSR    $00
549F: 00 00       NEG    $00
54A1: 05 00       LSR    $00
54A3: 00 00       NEG    $00
54A5: 08 00       ASL    $00
54A7: 00 00       NEG    $00
54A9: 10 00 00    NEG    $00
54AC: 00 20       NEG    $20
54AE: 00 00       NEG    $00
54B0: 00 30       NEG    $30
54B2: 00 00       NEG    $00
54B4: 00 40       NEG    $40
54B6: 00 00       NEG    $00
54B8: 00 50       NEG    $50
54BA: 00 00       NEG    $00
54BC: 00 60       NEG    $60
54BE: 00 00       NEG    $00
54C0: 00 70       NEG    $70
54C2: 00 FF       NEG    $FF
54C4: FF 80 00    STU    $8000
54C7: FF FF 90    STU    $FF90
54CA: 00 00       NEG    $00
54CC: 01 00       NEG    $00
54CE: 00 00       NEG    $00
54D0: 02 00       XNC    $00
54D2: 00 00       NEG    $00
54D4: 03 00       COM    $00
54D6: 00 00       NEG    $00
54D8: 05 00       LSR    $00
54DA: 00 00       NEG    $00
54DC: 10 00 00    NEG    $00
54DF: 00 01       NEG    $01
54E1: 50          NEGB
54E2: 00 34       NEG    $34
54E4: 40          NEGA
54E5: 8E 28 00    LDX    #$2800
54E8: 33 89 04 00 LEAU   $0400,X
54EC: 10 8E 04 00 LDY    #$0400
54F0: 86 00       LDA    #$00
54F2: 5F          CLRB
54F3: A7 80       STA    ,X+
54F5: E7 C0       STB    ,U+
54F7: 31 3F       LEAY   -$1,Y
54F9: 26 F8       BNE    $54F3
54FB: 0F F0       CLR    $F0
54FD: 35 C0       PULS   U,PC
54FF: 10 CE 20 00 LDS    #$2000
5503: CE 00 00    LDU    #$0000
5506: 4F          CLRA
5507: 30 C4       LEAX   ,U
5509: A7 80       STA    ,X+
550B: 8C 1F FF    CMPX   #$1FFF
550E: 23 F9       BLS    $5509
5510: 30 C4       LEAX   ,U
5512: A1 84       CMPA   ,X
5514: 26 3B       BNE    $5551
5516: 30 01       LEAX   $1,X
5518: 8C 1F FF    CMPX   #$1FFF
551B: 23 F5       BLS    $5512
551D: 8B 11       ADDA   #$11
551F: 24 E6       BCC    $5507
5521: CE 20 00    LDU    #$2000
5524: 4F          CLRA
5525: 30 C4       LEAX   ,U
5527: A7 80       STA    ,X+
5529: 8C 27 FF    CMPX   #$27FF
552C: 23 F9       BLS    $5527
552E: 30 C4       LEAX   ,U
5530: A1 84       CMPA   ,X
5532: 26 3A       BNE    $556E
5534: 30 01       LEAX   $1,X
5536: 8C 27 FF    CMPX   #$27FF
5539: 23 F5       BLS    $5530
553B: 8B 11       ADDA   #$11
553D: 24 E6       BCC    $5525
553F: 34 20       PSHS   Y
5541: BD 48 00    JSR    $4800
5544: C6 11       LDB    #$11
5546: BD 48 9B    JSR    $489B
5549: BD 55 A3    JSR    $55A3
554C: 30 1F       LEAX   -$1,X
554E: 26 FC       BNE    $554C
5550: 39          RTS
5551: 34 20       PSHS   Y
5553: 34 10       PSHS   X
5555: C6 01       LDB    #$01
5557: F7 3D 00    STB    $3D00
555A: BD 48 00    JSR    $4800
555D: C6 12       LDB    #$12
555F: BD 48 9B    JSR    $489B
5562: 30 01       LEAX   $1,X
5564: E6 E0       LDB    ,S+
5566: 8D 23       BSR    $558B
5568: E6 E0       LDB    ,S+
556A: 8D 1F       BSR    $558B
556C: 20 FE       BRA    $556C
556E: 34 20       PSHS   Y
5570: 34 10       PSHS   X
5572: C6 01       LDB    #$01
5574: F7 3D 00    STB    $3D00
5577: BD 48 00    JSR    $4800
557A: C6 13       LDB    #$13
557C: BD 48 9B    JSR    $489B
557F: 30 01       LEAX   $1,X
5581: E6 E0       LDB    ,S+
5583: 8D 06       BSR    $558B
5585: E6 E0       LDB    ,S+
5587: 8D 02       BSR    $558B
5589: 20 FE       BRA    $5589
558B: 1F 98       TFR    B,A
558D: 44          LSRA
558E: 44          LSRA
558F: 44          LSRA
5590: 44          LSRA
5591: 8D 04       BSR    $5597
5593: 1F 98       TFR    B,A
5595: 84 0F       ANDA   #$0F
5597: 34 04       PSHS   B
5599: C6 04       LDB    #$04
559B: E7 89 04 00 STB    $0400,X
559F: A7 80       STA    ,X+
55A1: 35 84       PULS   B,PC
55A3: C6 14       LDB    #$14
55A5: BD 48 9B    JSR    $489B
55A8: CE 5F FA    LDU    #$5FFA
55AB: 10 8E 60 00 LDY    #$6000
55AF: 8E 20 00    LDX    #$2000
55B2: 8D 6B       BSR    $561F
55B4: 8E 40 00    LDX    #$4000
55B7: 8D 66       BSR    $561F
55B9: 8E 40 00    LDX    #$4000
55BC: 8D 61       BSR    $561F
55BE: 8E 1A 00    LDX    #$1A00
55C1: 10 8E 55 D1 LDY    #$55D1
55C5: C6 4E       LDB    #$4E
55C7: A6 A0       LDA    ,Y+
55C9: A7 80       STA    ,X+
55CB: 5A          DECB
55CC: 26 F9       BNE    $55C7
55CE: 7E 1A 00    JMP    $1A00
55D1: 10 8E 5F F0 LDY    #$5FF0
55D5: 86 04       LDA    #$04
55D7: 97 E4       STA    $E4
55D9: 8E 40 00    LDX    #$4000
55DC: 96 E4       LDA    $E4
55DE: B7 3E 00    STA    $3E00
55E1: CE 5F FF    LDU    #$5FFF
55E4: 81 03       CMPA   #$03
55E6: 26 03       BNE    $55EB
55E8: CE 5F EF    LDU    #$5FEF
55EB: DF E2       STU    $E2
55ED: CC 00 00    LDD    #$0000
55F0: DD E0       STD    $E0
55F2: E6 80       LDB    ,X+
55F4: 4F          CLRA
55F5: D3 E0       ADDD   $E0
55F7: DD E0       STD    $E0
55F9: 9C E2       CMPX   $E2
55FB: 23 F5       BLS    $55F2
55FD: C6 03       LDB    #$03
55FF: F7 3E 00    STB    $3E00
5602: EE A1       LDU    ,Y++
5604: 11 93 E0    CMPU   $E0
5607: 26 0F       BNE    $5618
5609: 0A E4       DEC    $E4
560B: 2A CC       BPL    $55D9
560D: C6 15       LDB    #$15
560F: BD 48 9B    JSR    $489B
5612: 86 03       LDA    #$03
5614: B7 3E 00    STA    $3E00
5617: 39          RTS
5618: C6 16       LDB    #$16
561A: BD 48 9B    JSR    $489B
561D: 20 FE       BRA    $561D
561F: 4F          CLRA
5620: 5F          CLRB
5621: DD E0       STD    $E0
5623: 4F          CLRA
5624: 5F          CLRB
5625: E6 A0       LDB    ,Y+
5627: D3 E0       ADDD   $E0
5629: DD E0       STD    $E0
562B: 30 1F       LEAX   -$1,X
562D: 26 F4       BNE    $5623
562F: AE C1       LDX    ,U++
5631: 9C E0       CMPX   $E0
5633: 26 E3       BNE    $5618
5635: 39          RTS
5636: D6 05       LDB    $05
5638: 58          ASLB
5639: 8E 56 3E    LDX    #$563E
563C: 6E 95       JMP    [B,X]
563E: 56          RORB
563F: 42          XNCA
5640: 56          RORB
5641: 55          LSRB
5642: 7F 05 04    CLR    $0504
5645: 96 42       LDA    $42
5647: 85 40       BITA   #$40
5649: 27 07       BEQ    $5652
564B: 85 40       BITA   #$40
564D: 27 03       BEQ    $5652
564F: 7C 05 04    INC    $0504
5652: 0C 05       INC    $05
5654: 39          RTS
5655: D6 08       LDB    $08
5657: 58          ASLB
5658: 8E 56 92    LDX    #$5692
565B: AD 95       JSR    [B,X]
565D: D6 43       LDB    $43
565F: 53          COMB
5660: D4 42       ANDB   $42
5662: C4 03       ANDB   #$03
5664: C1 03       CMPB   #$03
5666: 26 29       BNE    $5691
5668: C6 01       LDB    #$01
566A: D7 D8       STB    $D8
566C: C6 3F       LDB    #$3F
566E: BD 79 58    JSR    $7958
5671: 5F          CLRB
5672: BD 79 58    JSR    $7958
5675: 5F          CLRB
5676: D7 0B       STB    $0B
5678: D7 0E       STB    $0E
567A: 0C 08       INC    $08
567C: 7D 05 04    TST    $0504
567F: 26 08       BNE    $5689
5681: D6 08       LDB    $08
5683: C1 02       CMPB   #$02
5685: 25 0A       BCS    $5691
5687: 20 06       BRA    $568F
5689: D6 08       LDB    $08
568B: C1 03       CMPB   #$03
568D: 25 02       BCS    $5691
568F: 0F 08       CLR    $08
5691: 39          RTS
5692: 56          RORB
5693: 98 58       EORA   $58
5695: D8 59       EORB   $59
5697: C0 D6       SUBB   #$D6
5699: 0B 58       XDEC   $58
569B: 8E 56 A0    LDX    #$56A0
569E: 6E 95       JMP    [B,X]
56A0: 56          RORB
56A1: AC 56       CMPX   -$A,U
56A3: D6 56       LDB    $56
56A5: AC 56       CMPX   -$A,U
56A7: FF 56 AC    STU    $56AC
56AA: 57          ASRB
56AB: 0C D6       INC    $D6
56AD: F0 26 02    SUBB   $2602
56B0: 0C 0B       INC    $0B
56B2: 39          RTS
56B3: C6 01       LDB    #$01
56B5: D7 F0       STB    $F0
56B7: CC 00 00    LDD    #$0000
56BA: BD 69 09    JSR    $6909
56BD: CC 03 00    LDD    #$0300
56C0: BD 69 09    JSR    $6909
56C3: CC 03 01    LDD    #$0301
56C6: BD 69 09    JSR    $6909
56C9: CC 03 02    LDD    #$0302
56CC: BD 69 09    JSR    $6909
56CF: CC 02 2B    LDD    #$022B
56D2: BD 69 09    JSR    $6909
56D5: 39          RTS
56D6: BD 56 B3    JSR    $56B3
56D9: CC 02 17    LDD    #$0217
56DC: BD 69 09    JSR    $6909
56DF: CC 02 1E    LDD    #$021E
56E2: BD 69 09    JSR    $6909
56E5: CC 02 1F    LDD    #$021F
56E8: BD 69 09    JSR    $6909
56EB: CC 02 20    LDD    #$0220
56EE: BD 69 09    JSR    $6909
56F1: BD 68 DF    JSR    $68DF
56F4: D6 41       LDB    $41
56F6: 53          COMB
56F7: C4 18       ANDB   #$18
56F9: F7 05 00    STB    $0500
56FC: 0C 0B       INC    $0B
56FE: 39          RTS
56FF: C6 01       LDB    #$01
5701: D7 F0       STB    $F0
5703: CC 0E 00    LDD    #$0E00
5706: BD 69 09    JSR    $6909
5709: 0C 0B       INC    $0B
570B: 39          RTS
570C: D6 21       LDB    $21
570E: C4 0F       ANDB   #$0F
5710: 26 02       BNE    $5714
5712: 8D 0A       BSR    $571E
5714: BD 58 0C    JSR    $580C
5717: BD 58 48    JSR    $5848
571A: BD 58 6B    JSR    $586B
571D: 39          RTS
571E: D6 41       LDB    $41
5720: C4 18       ANDB   #$18
5722: F1 05 00    CMPB   $0500
5725: 27 15       BEQ    $573C
5727: F7 05 00    STB    $0500
572A: C6 28       LDB    #$28
572C: BD 48 BD    JSR    $48BD
572F: C6 29       LDB    #$29
5731: BD 48 BD    JSR    $48BD
5734: C6 2A       LDB    #$2A
5736: BD 48 BD    JSR    $48BD
5739: BD 57 C6    JSR    $57C6
573C: BD 57 86    JSR    $5786
573F: 0D 52       TST    $52
5741: 26 07       BNE    $574A
5743: C6 1B       LDB    #$1B
5745: BD 48 9B    JSR    $489B
5748: 20 05       BRA    $574F
574A: C6 1A       LDB    #$1A
574C: BD 48 9B    JSR    $489B
574F: 8E 20 EE    LDX    #$20EE
5752: 96 50       LDA    $50
5754: C6 04       LDB    #$04
5756: E7 89 04 00 STB    $0400,X
575A: A7 84       STA    ,X
575C: 30 88 20    LEAX   $20,X
575F: 96 41       LDA    $41
5761: 84 60       ANDA   #$60
5763: 44          LSRA
5764: 44          LSRA
5765: 44          LSRA
5766: 44          LSRA
5767: 44          LSRA
5768: 81 01       CMPA   #$01
576A: 22 02       BHI    $576E
576C: 88 01       EORA   #$01
576E: C6 04       LDB    #$04
5770: E7 89 04 00 STB    $0400,X
5774: A7 84       STA    ,X
5776: 0D 53       TST    $53
5778: 26 06       BNE    $5780
577A: C6 1C       LDB    #$1C
577C: BD 48 9B    JSR    $489B
577F: 39          RTS
5780: C6 1D       LDB    #$1D
5782: BD 48 9B    JSR    $489B
5785: 39          RTS
5786: 0D 51       TST    $51
5788: 26 36       BNE    $57C0
578A: C6 18       LDB    #$18
578C: BD 48 9B    JSR    $489B
578F: 8E 20 48    LDX    #$2048
5792: 10 8E 15 85 LDY    #$1585
5796: A6 A4       LDA    ,Y
5798: C6 05       LDB    #$05
579A: E7 89 04 00 STB    $0400,X
579E: A7 84       STA    ,X
57A0: 30 07       LEAX   $7,X
57A2: A6 21       LDA    $1,Y
57A4: E7 89 04 00 STB    $0400,X
57A8: A7 84       STA    ,X
57AA: 30 88 19    LEAX   $19,X
57AD: A6 28       LDA    $8,Y
57AF: E7 89 04 00 STB    $0400,X
57B3: A7 84       STA    ,X
57B5: 30 07       LEAX   $7,X
57B7: A6 29       LDA    $9,Y
57B9: E7 89 04 00 STB    $0400,X
57BD: A7 84       STA    ,X
57BF: 39          RTS
57C0: C6 19       LDB    #$19
57C2: BD 48 9B    JSR    $489B
57C5: 39          RTS
57C6: BD 57 D4    JSR    $57D4
57C9: BD 57 E4    JSR    $57E4
57CC: D6 54       LDB    $54
57CE: 27 03       BEQ    $57D3
57D0: BD 57 F5    JSR    $57F5
57D3: 39          RTS
57D4: C6 28       LDB    #$28
57D6: BD 48 9B    JSR    $489B
57D9: BE 58 06    LDX    $5806
57DC: 10 9E 55    LDY    $55
57DF: C6 01       LDB    #$01
57E1: 7E 50 25    JMP    $5025
57E4: C6 29       LDB    #$29
57E6: BD 48 9B    JSR    $489B
57E9: BE 58 08    LDX    $5808
57EC: DE 55       LDU    $55
57EE: 31 44       LEAY   $4,U
57F0: C6 01       LDB    #$01
57F2: 7E 50 25    JMP    $5025
57F5: C6 2A       LDB    #$2A
57F7: BD 48 9B    JSR    $489B
57FA: BE 58 0A    LDX    $580A
57FD: DE 55       LDU    $55
57FF: 31 48       LEAY   $8,U
5801: C6 01       LDB    #$01
5803: 7E 50 25    JMP    $5025
5806: 21 6E       BRN    $5876
5808: 21 8E       BRN    $5798
580A: 21 AE       BRN    $57BA
580C: 8E 22 0A    LDX    #$220A
580F: 96 46       LDA    $46
5811: 10 8E 00 06 LDY    #$0006
5815: 8D 22       BSR    $5839
5817: 31 3F       LEAY   -$1,Y
5819: 26 FA       BNE    $5815
581B: 96 42       LDA    $42
581D: 8D 1A       BSR    $5839
581F: 8D 18       BSR    $5839
5821: 44          LSRA
5822: 44          LSRA
5823: 44          LSRA
5824: 44          LSRA
5825: 8D 12       BSR    $5839
5827: 8D 10       BSR    $5839
5829: 8E 22 14    LDX    #$2214
582C: 96 48       LDA    $48
582E: 10 8E 00 06 LDY    #$0006
5832: 8D 05       BSR    $5839
5834: 31 3F       LEAY   -$1,Y
5836: 26 FA       BNE    $5832
5838: 39          RTS
5839: 5F          CLRB
583A: 44          LSRA
583B: 59          ROLB
583C: E7 84       STB    ,X
583E: C6 04       LDB    #$04
5840: E7 89 04 00 STB    $0400,X
5844: 30 88 20    LEAX   $20,X
5847: 39          RTS
5848: 4F          CLRA
5849: D6 46       LDB    $46
584B: C5 10       BITB   #$10
584D: 27 01       BEQ    $5850
584F: 4C          INCA
5850: B7 3D 02    STA    $3D02
5853: 4F          CLRA
5854: D6 46       LDB    $46
5856: C5 20       BITB   #$20
5858: 27 01       BEQ    $585B
585A: 4C          INCA
585B: B7 3D 03    STA    $3D03
585E: 86 01       LDA    #$01
5860: D6 42       LDB    $42
5862: C5 01       BITB   #$01
5864: 27 02       BEQ    $5868
5866: 86 00       LDA    #$00
5868: 97 D8       STA    $D8
586A: 39          RTS
586B: 8D 51       BSR    $58BE
586D: D6 47       LDB    $47
586F: 53          COMB
5870: D4 46       ANDB   $46
5872: C5 10       BITB   #$10
5874: 26 52       BNE    $58C8
5876: C5 01       BITB   #$01
5878: 26 27       BNE    $58A1
587A: C5 02       BITB   #$02
587C: 26 01       BNE    $587F
587E: 39          RTS
587F: 7A 05 01    DEC    $0501
5882: F6 05 01    LDB    $0501
5885: C1 0A       CMPB   #$0A
5887: 27 10       BEQ    $5899
5889: C1 16       CMPB   #$16
588B: 27 0C       BEQ    $5899
588D: 7D 05 01    TST    $0501
5890: 2A 2C       BPL    $58BE
5892: C6 3F       LDB    #$3F
5894: F7 05 01    STB    $0501
5897: 20 25       BRA    $58BE
5899: 7A 05 01    DEC    $0501
589C: 7A 05 01    DEC    $0501
589F: 20 1D       BRA    $58BE
58A1: 7C 05 01    INC    $0501
58A4: F6 05 01    LDB    $0501
58A7: C1 09       CMPB   #$09
58A9: 27 0D       BEQ    $58B8
58AB: C1 15       CMPB   #$15
58AD: 27 09       BEQ    $58B8
58AF: C1 3F       CMPB   #$3F
58B1: 23 0B       BLS    $58BE
58B3: 7F 05 01    CLR    $0501
58B6: 20 06       BRA    $58BE
58B8: 7C 05 01    INC    $0501
58BB: 7C 05 01    INC    $0501
58BE: 8E 22 7A    LDX    #$227A
58C1: F6 05 01    LDB    $0501
58C4: BD 55 8B    JSR    $558B
58C7: 39          RTS
58C8: C6 3F       LDB    #$3F
58CA: BD 79 58    JSR    $7958
58CD: 5F          CLRB
58CE: BD 79 58    JSR    $7958
58D1: F6 05 01    LDB    $0501
58D4: BD 79 1D    JSR    $791D
58D7: 39          RTS
58D8: D6 0B       LDB    $0B
58DA: 58          ASLB
58DB: 8E 58 E0    LDX    #$58E0
58DE: 6E 95       JMP    [B,X]
58E0: 56          RORB
58E1: AC 58       CMPX   -$8,U
58E3: EC 56       LDD    -$A,U
58E5: AC 59       CMPX   -$7,U
58E7: 03 56       COM    $56
58E9: AC 59       CMPX   -$7,U
58EB: 78 BD 56    ASL    $BD56
58EE: B3 7D 05    SUBD   $7D05
58F1: 04 27       LSR    $27
58F3: 06 CC       ROR    $CC
58F5: 02 21       XNC    $21
58F7: BD 69 09    JSR    $6909
58FA: 4F          CLRA
58FB: 5F          CLRB
58FC: DD D4       STD    $D4
58FE: DD D6       STD    $D6
5900: 0C 0B       INC    $0B
5902: 39          RTS
5903: C6 01       LDB    #$01
5905: C6 F0       LDB    #$F0
5907: CC 0F 00    LDD    #$0F00
590A: BD 69 09    JSR    $6909
590D: 0C 0B       INC    $0B
590F: 39          RTS
5910: 8E 16 33    LDX    #$1633
5913: 86 FF       LDA    #$FF
5915: C6 07       LDB    #$07
5917: A7 88 40    STA    $40,X
591A: A7 80       STA    ,X+
591C: 5A          DECB
591D: 26 F8       BNE    $5917
591F: C6 00       LDB    #$00
5921: 8E 28 00    LDX    #$2800
5924: 10 8E 05 00 LDY    #$0500
5928: 8D 12       BSR    $593C
592A: 8E 28 10    LDX    #$2810
592D: 8D 0D       BSR    $593C
592F: 8E 2A 00    LDX    #$2A00
5932: 8D 08       BSR    $593C
5934: 8E 2A 10    LDX    #$2A10
5937: 8D 03       BSR    $593C
5939: 0F F0       CLR    $F0
593B: 39          RTS
593C: 86 0F       LDA    #$0F
593E: A7 21       STA    $1,Y
5940: 86 0F       LDA    #$0F
5942: A7 A4       STA    ,Y
5944: 86 B9       LDA    #$B9
5946: E7 89 04 00 STB    $0400,X
594A: A7 80       STA    ,X+
594C: 6A A4       DEC    ,Y
594E: 26 F6       BNE    $5946
5950: 86 BB       LDA    #$BB
5952: E7 89 04 00 STB    $0400,X
5956: A7 84       STA    ,X
5958: 30 88 11    LEAX   $11,X
595B: 6A 21       DEC    $1,Y
595D: 26 E1       BNE    $5940
595F: 86 0F       LDA    #$0F
5961: A7 A4       STA    ,Y
5963: 86 BA       LDA    #$BA
5965: E7 89 04 00 STB    $0400,X
5969: A7 80       STA    ,X+
596B: 6A A4       DEC    ,Y
596D: 26 F6       BNE    $5965
596F: 86 BC       LDA    #$BC
5971: E7 89 04 00 STB    $0400,X
5975: A7 84       STA    ,X
5977: 39          RTS
5978: 7D 05 04    TST    $0504
597B: 27 1B       BEQ    $5998
597D: 96 47       LDA    $47
597F: 43          COMA
5980: 94 46       ANDA   $46
5982: D6 46       LDB    $46
5984: C5 02       BITB   #$02
5986: 26 11       BNE    $5999
5988: C5 01       BITB   #$01
598A: 26 15       BNE    $59A1
598C: C5 04       BITB   #$04
598E: 26 19       BNE    $59A9
5990: C5 08       BITB   #$08
5992: 26 1D       BNE    $59B1
5994: 85 10       BITA   #$10
5996: 26 21       BNE    $59B9
5998: 39          RTS
5999: DC D4       LDD    $D4
599B: C3 00 01    ADDD   #$0001
599E: DD D4       STD    $D4
59A0: 39          RTS
59A1: DC D4       LDD    $D4
59A3: 83 00 01    SUBD   #$0001
59A6: DD D4       STD    $D4
59A8: 39          RTS
59A9: DC D6       LDD    $D6
59AB: C3 00 01    ADDD   #$0001
59AE: DD D6       STD    $D6
59B0: 39          RTS
59B1: DC D6       LDD    $D6
59B3: 83 00 01    SUBD   #$0001
59B6: DD D6       STD    $D6
59B8: 39          RTS
59B9: 4F          CLRA
59BA: 5F          CLRB
59BB: DD D4       STD    $D4
59BD: DD D6       STD    $D6
59BF: 39          RTS
59C0: D6 0B       LDB    $0B
59C2: 58          ASLB
59C3: 8E 59 C8    LDX    #$59C8
59C6: 6E 95       JMP    [B,X]
59C8: 56          RORB
59C9: AC 59       CMPX   -$7,U
59CB: D6 56       LDB    $56
59CD: AC 59       CMPX   -$7,U
59CF: E2 56       SBCB   -$A,U
59D1: AC 59       CMPX   -$7,U
59D3: EF 5A       STU    -$6,U
59D5: 2D BD       BLT    $5994
59D7: 56          RORB
59D8: B3 CC 02    SUBD   $CC02
59DB: 22 BD       BHI    $599A
59DD: 69 09       ROL    $9,X
59DF: 0C 0B       INC    $0B
59E1: 39          RTS
59E2: C6 01       LDB    #$01
59E4: D7 F0       STB    $F0
59E6: CC 0E 00    LDD    #$0E00
59E9: BD 69 09    JSR    $6909
59EC: 0C 0B       INC    $0B
59EE: 39          RTS
59EF: 86 40       LDA    #$40
59F1: A7 7F       STA    -$1,S
59F3: 86 30       LDA    #$30
59F5: A7 7E       STA    -$2,S
59F7: 86 08       LDA    #$08
59F9: A7 7D       STA    -$3,S
59FB: C6 10       LDB    #$10
59FD: 8E 1E 00    LDX    #$1E00
5A00: 86 05       LDA    #$05
5A02: A7 7C       STA    -$4,S
5A04: 86 C4       LDA    #$C4
5A06: A7 80       STA    ,X+
5A08: E7 80       STB    ,X+
5A0A: A6 7F       LDA    -$1,S
5A0C: A7 80       STA    ,X+
5A0E: A6 7E       LDA    -$2,S
5A10: A7 80       STA    ,X+
5A12: 86 20       LDA    #$20
5A14: AB 7E       ADDA   -$2,S
5A16: A7 7E       STA    -$2,S
5A18: 6A 7C       DEC    -$4,S
5A1A: 26 E8       BNE    $5A04
5A1C: 86 15       LDA    #$15
5A1E: AB 7F       ADDA   -$1,S
5A20: A7 7F       STA    -$1,S
5A22: 86 30       LDA    #$30
5A24: A7 7E       STA    -$2,S
5A26: 6A 7D       DEC    -$3,S
5A28: 26 D6       BNE    $5A00
5A2A: 0C 0B       INC    $0B
5A2C: 39          RTS
5A2D: 8E 1E 01    LDX    #$1E01
5A30: D6 47       LDB    $47
5A32: 53          COMB
5A33: D4 46       ANDB   $46
5A35: C5 02       BITB   #$02
5A37: 26 0D       BNE    $5A46
5A39: C5 01       BITB   #$01
5A3B: 26 21       BNE    $5A5E
5A3D: C5 04       BITB   #$04
5A3F: 26 2D       BNE    $5A6E
5A41: C5 08       BITB   #$08
5A43: 26 37       BNE    $5A7C
5A45: 39          RTS
5A46: C6 28       LDB    #$28
5A48: A6 84       LDA    ,X
5A4A: 84 CF       ANDA   #$CF
5A4C: A7 7F       STA    -$1,S
5A4E: A6 84       LDA    ,X
5A50: 80 10       SUBA   #$10
5A52: 84 30       ANDA   #$30
5A54: AA 7F       ORA    -$1,S
5A56: A7 84       STA    ,X
5A58: 30 04       LEAX   $4,X
5A5A: 5A          DECB
5A5B: 26 EB       BNE    $5A48
5A5D: 39          RTS
5A5E: C6 28       LDB    #$28
5A60: A6 84       LDA    ,X
5A62: 8B 10       ADDA   #$10
5A64: 84 30       ANDA   #$30
5A66: A7 84       STA    ,X
5A68: 30 04       LEAX   $4,X
5A6A: 5A          DECB
5A6B: 26 F3       BNE    $5A60
5A6D: 39          RTS
5A6E: C6 28       LDB    #$28
5A70: A6 84       LDA    ,X
5A72: 88 04       EORA   #$04
5A74: A7 84       STA    ,X
5A76: 30 04       LEAX   $4,X
5A78: 5A          DECB
5A79: 26 F5       BNE    $5A70
5A7B: 39          RTS
5A7C: C6 28       LDB    #$28
5A7E: A6 84       LDA    ,X
5A80: 88 08       EORA   #$08
5A82: A7 84       STA    ,X
5A84: 30 04       LEAX   $4,X
5A86: 5A          DECB
5A87: 26 F5       BNE    $5A7E
5A89: 39          RTS
5A8A: 10 8E 15 72 LDY    #$1572
5A8E: D6 08       LDB    $08
5A90: 58          ASLB
5A91: 8E 5A 96    LDX    #$5A96
5A94: 6E 95       JMP    [B,X]
5A96: 5A          DECB
5A97: 9C 5A       CMPX   $5A
5A99: B1 5A CE    CMPA   $5ACE
5A9C: 4F          CLRA
5A9D: 5F          CLRB
5A9E: ED A4       STD    ,Y
5AA0: ED 22       STD    $2,Y
5AA2: ED 24       STD    $4,Y
5AA4: ED 26       STD    $6,Y
5AA6: ED 28       STD    $8,Y
5AA8: ED 2A       STD    $A,Y
5AAA: ED 2C       STD    $C,Y
5AAC: ED 2E       STD    $E,Y
5AAE: 0C 08       INC    $08
5AB0: 39          RTS
5AB1: 8E 15 18    LDX    #$1518
5AB4: BD 5A E3    JSR    $5AE3
5AB7: 25 12       BCS    $5ACB
5AB9: 6C A4       INC    ,Y
5ABB: 86 0A       LDA    #$0A
5ABD: 90 E0       SUBA   $E0
5ABF: A7 21       STA    $1,Y
5AC1: 4D          TSTA
5AC2: 27 02       BEQ    $5AC6
5AC4: 86 01       LDA    #$01
5AC6: A7 2C       STA    $C,Y
5AC8: BD 5B 0C    JSR    $5B0C
5ACB: 0C 08       INC    $08
5ACD: 39          RTS
5ACE: E6 A4       LDB    ,Y
5AD0: 26 0A       BNE    $5ADC
5AD2: C6 04       LDB    #$04
5AD4: D7 05       STB    $05
5AD6: 5F          CLRB
5AD7: D7 08       STB    $08
5AD9: D7 0B       STB    $0B
5ADB: 39          RTS
5ADC: 0C 05       INC    $05
5ADE: 0F 08       CLR    $08
5AE0: 0F 0B       CLR    $0B
5AE2: 39          RTS
5AE3: C6 0A       LDB    #$0A
5AE5: D7 E0       STB    $E0
5AE7: 8D 0C       BSR    $5AF5
5AE9: 26 08       BNE    $5AF3
5AEB: 30 02       LEAX   $2,X
5AED: 0A E0       DEC    $E0
5AEF: 26 F6       BNE    $5AE7
5AF1: 53          COMB
5AF2: 39          RTS
5AF3: 5F          CLRB
5AF4: 39          RTS
5AF5: EE 84       LDU    ,X
5AF7: DC 68       LDD    $68
5AF9: 10 A3 C4    CMPD   ,U
5AFC: 25 09       BCS    $5B07
5AFE: 22 09       BHI    $5B09
5B00: DC 6A       LDD    $6A
5B02: 10 A3 42    CMPD   $2,U
5B05: 24 02       BCC    $5B09
5B07: 4F          CLRA
5B08: 39          RTS
5B09: 86 FF       LDA    #$FF
5B0B: 39          RTS
5B0C: 8E 15 2A    LDX    #$152A
5B0F: EE 84       LDU    ,X
5B11: 0A E0       DEC    $E0
5B13: 27 10       BEQ    $5B25
5B15: EC 83       LDD    ,--X
5B17: ED 02       STD    $2,X
5B19: 0A E0       DEC    $E0
5B1B: 26 F8       BNE    $5B15
5B1D: E6 21       LDB    $1,Y
5B1F: 58          ASLB
5B20: 8E 15 18    LDX    #$1518
5B23: EF 85       STU    B,X
5B25: 8E 00 68    LDX    #$0068
5B28: EC 81       LDD    ,X++
5B2A: ED C1       STD    ,U++
5B2C: EC 81       LDD    ,X++
5B2E: ED C1       STD    ,U++
5B30: EF 2A       STU    $A,Y
5B32: CC 2E 2E    LDD    #$2E2E
5B35: ED C1       STD    ,U++
5B37: E7 C4       STB    ,U
5B39: 39          RTS
5B3A: BD 69 1C    JSR    $691C
5B3D: 10 8E 15 72 LDY    #$1572
5B41: D6 08       LDB    $08
5B43: 58          ASLB
5B44: 8E 5B 49    LDX    #$5B49
5B47: 6E 95       JMP    [B,X]
5B49: 5B          XDECB
5B4A: 4D          TSTA
5B4B: 5B          XDECB
5B4C: 63 D6       COM    [A,U]
5B4E: F0 26 11    SUBB   $2611
5B51: C6 01       LDB    #$01
5B53: D7 F0       STB    $F0
5B55: BD 68 DF    JSR    $68DF
5B58: CC 01 1A    LDD    #$011A
5B5B: BD 69 09    JSR    $6909
5B5E: 0F 0B       CLR    $0B
5B60: 0C 08       INC    $08
5B62: 39          RTS
5B63: D6 0B       LDB    $0B
5B65: 58          ASLB
5B66: 8E 5B 6B    LDX    #$5B6B
5B69: 6E 95       JMP    [B,X]
5B6B: 5B          XDECB
5B6C: 77 5B A6    ASR    $5BA6
5B6F: 5B          XDECB
5B70: B1 5B DD    CMPA   $5BDD
5B73: 5B          XDECB
5B74: F3 5C 0A    ADDD   $5C0A
5B77: CC 00 01    LDD    #$0001
5B7A: 6D 2C       TST    $C,Y
5B7C: 27 03       BEQ    $5B81
5B7E: CC 01 27    LDD    #$0127
5B81: ED 2E       STD    $E,Y
5B83: BD 5C 3A    JSR    $5C3A
5B86: 8E 0D 48    LDX    #$0D48
5B89: 9F 09       STX    $09
5B8B: 6F 26       CLR    $6,Y
5B8D: 8E 5B D2    LDX    #$5BD2
5B90: E6 80       LDB    ,X+
5B92: EE 81       LDU    ,X++
5B94: 86 0B       LDA    #$0B
5B96: A7 C9 04 00 STA    $0400,U
5B9A: A6 80       LDA    ,X+
5B9C: A7 C0       STA    ,U+
5B9E: 5A          DECB
5B9F: 26 F3       BNE    $5B94
5BA1: EF 27       STU    $7,Y
5BA3: 0C 0B       INC    $0B
5BA5: 39          RTS
5BA6: CE 5B CA    LDU    #$5BCA
5BA9: E6 2C       LDB    $C,Y
5BAB: 58          ASLB
5BAC: AD D5       JSR    [B,U]
5BAE: 0C 0B       INC    $0B
5BB0: 39          RTS
5BB1: AE 2E       LDX    $E,Y
5BB3: 30 1F       LEAX   -$1,X
5BB5: AF 2E       STX    $E,Y
5BB7: 26 09       BNE    $5BC2
5BB9: 6D 2C       TST    $C,Y
5BBB: 27 03       BEQ    $5BC0
5BBD: BD 7A 14    JSR    $7A14
5BC0: 0C 0B       INC    $0B
5BC2: 10 8E 15 72 LDY    #$1572
5BC6: BD 5B DD    JSR    $5BDD
5BC9: 39          RTS
5BCA: 7A 05 7A    DEC    $057A
5BCD: 0F 7A       CLR    $7A
5BCF: 00 7A       NEG    $7A
5BD1: 0A 08       DEC    $08
5BD3: 23 28       BLS    $5BFD
5BD5: 49          ROLA
5BD6: 4E          XCLRA
5BD7: 49          ROLA
5BD8: 54          LSRB
5BD9: 49          ROLA
5BDA: 41          NEGA
5BDB: 4C          INCA
5BDC: 20 BD       BRA    $5B9B
5BDE: 5C          INCB
5BDF: 1B          NOP
5BE0: BD 5D 5E    JSR    $5D5E
5BE3: BD 5D 7C    JSR    $5D7C
5BE6: 9E 09       LDX    $09
5BE8: 30 1F       LEAX   -$1,X
5BEA: 9F 09       STX    $09
5BEC: 26 04       BNE    $5BF2
5BEE: 86 04       LDA    #$04
5BF0: 97 0B       STA    $0B
5BF2: 39          RTS
5BF3: BD 5D DD    JSR    $5DDD
5BF6: CE 5B CE    LDU    #$5BCE
5BF9: F6 15 7E    LDB    $157E
5BFC: 58          ASLB
5BFD: AD D5       JSR    [B,U]
5BFF: 10 8E 15 72 LDY    #$1572
5C03: 86 04       LDA    #$04
5C05: A7 2D       STA    $D,Y
5C07: 0C 0B       INC    $0B
5C09: 39          RTS
5C0A: 96 21       LDA    $21
5C0C: 84 7F       ANDA   #$7F
5C0E: 26 0A       BNE    $5C1A
5C10: 6A 2D       DEC    $D,Y
5C12: 26 06       BNE    $5C1A
5C14: 0F 08       CLR    $08
5C16: 0F 0B       CLR    $0B
5C18: 0C 05       INC    $05
5C1A: 39          RTS
5C1B: D6 4B       LDB    $4B
5C1D: C5 01       BITB   #$01
5C1F: 10 26 00 6B LBNE   $5C8E
5C23: C5 02       BITB   #$02
5C25: 10 26 00 A2 LBNE   $5CCB
5C29: C5 04       BITB   #$04
5C2B: 10 26 00 D7 LBNE   $5D06
5C2F: C5 08       BITB   #$08
5C31: 10 26 00 FD LBNE   $5D32
5C35: 86 09       LDA    #$09
5C37: A7 22       STA    $2,Y
5C39: 39          RTS
5C3A: 8E 5C 7F    LDX    #$5C7F
5C3D: EE 81       LDU    ,X++
5C3F: C6 0D       LDB    #$0D
5C41: 34 04       PSHS   B
5C43: C6 41       LDB    #$41
5C45: 86 0B       LDA    #$0B
5C47: A7 C9 04 00 STA    $0400,U
5C4B: E7 C1       STB    ,U++
5C4D: C1 5A       CMPB   #$5A
5C4F: 26 02       BNE    $5C53
5C51: C6 60       LDB    #$60
5C53: C1 7A       CMPB   #$7A
5C55: 27 0E       BEQ    $5C65
5C57: 5C          INCB
5C58: 6A E4       DEC    ,S
5C5A: 26 E9       BNE    $5C45
5C5C: 86 0D       LDA    #$0D
5C5E: A7 E4       STA    ,S
5C60: 33 C8 26    LEAU   $26,U
5C63: 20 E0       BRA    $5C45
5C65: 33 C8 26    LEAU   $26,U
5C68: C6 0D       LDB    #$0D
5C6A: E7 E4       STB    ,S
5C6C: E6 80       LDB    ,X+
5C6E: A7 C9 04 00 STA    $0400,U
5C72: E7 C1       STB    ,U++
5C74: 6A E4       DEC    ,S
5C76: 26 F4       BNE    $5C6C
5C78: 32 61       LEAS   $1,S
5C7A: 33 5E       LEAU   -$2,U
5C7C: EF 23       STU    $3,Y
5C7E: 39          RTS
5C7F: 20 C4       BRA    $5C45
5C81: 21 3F       BRN    $5CC2
5C83: 26 2C       BNE    $5CB1
5C85: 1D          SEX
5C86: 28 29       BVC    $5CB1
5C88: 2F 3A       BLE    $5CC4
5C8A: 2A 40       BPL    $5CCC
5C8C: 1E 1F       EXG    X,inv
5C8E: 6C 22       INC    $2,Y
5C90: A6 22       LDA    $2,Y
5C92: 81 0A       CMPA   #$0A
5C94: 25 34       BCS    $5CCA
5C96: EE 23       LDU    $3,Y
5C98: 86 0B       LDA    #$0B
5C9A: A7 C9 04 00 STA    $0400,U
5C9E: A6 C4       LDA    ,U
5CA0: 81 1F       CMPA   #$1F
5CA2: 27 13       BEQ    $5CB7
5CA4: EC 23       LDD    $3,Y
5CA6: 83 00 1C    SUBD   #$001C
5CA9: C4 1F       ANDB   #$1F
5CAB: 26 14       BNE    $5CC1
5CAD: EC 23       LDD    $3,Y
5CAF: C3 00 28    ADDD   #$0028
5CB2: ED 23       STD    $3,Y
5CB4: 6F 22       CLR    $2,Y
5CB6: 39          RTS
5CB7: 8E 5C 7F    LDX    #$5C7F
5CBA: EE 84       LDU    ,X
5CBC: EF 23       STU    $3,Y
5CBE: 6F 22       CLR    $2,Y
5CC0: 39          RTS
5CC1: EC 23       LDD    $3,Y
5CC3: C3 00 02    ADDD   #$0002
5CC6: ED 23       STD    $3,Y
5CC8: 6F 22       CLR    $2,Y
5CCA: 39          RTS
5CCB: 6C 22       INC    $2,Y
5CCD: A6 22       LDA    $2,Y
5CCF: 81 0A       CMPA   #$0A
5CD1: 25 32       BCS    $5D05
5CD3: EE 23       LDU    $3,Y
5CD5: 86 0B       LDA    #$0B
5CD7: A7 C9 04 00 STA    $0400,U
5CDB: A6 C4       LDA    ,U
5CDD: 81 41       CMPA   #$41
5CDF: 27 13       BEQ    $5CF4
5CE1: EC 23       LDD    $3,Y
5CE3: 83 00 04    SUBD   #$0004
5CE6: C4 1F       ANDB   #$1F
5CE8: 26 12       BNE    $5CFC
5CEA: EC 23       LDD    $3,Y
5CEC: 83 00 28    SUBD   #$0028
5CEF: ED 23       STD    $3,Y
5CF1: 6F 22       CLR    $2,Y
5CF3: 39          RTS
5CF4: CE 21 DC    LDU    #$21DC
5CF7: EF 23       STU    $3,Y
5CF9: 6F 22       CLR    $2,Y
5CFB: 39          RTS
5CFC: EC 23       LDD    $3,Y
5CFE: 83 00 02    SUBD   #$0002
5D01: ED 23       STD    $3,Y
5D03: 6F 22       CLR    $2,Y
5D05: 39          RTS
5D06: 6C 22       INC    $2,Y
5D08: A6 22       LDA    $2,Y
5D0A: 81 0A       CMPA   #$0A
5D0C: 25 23       BCS    $5D31
5D0E: EE 23       LDU    $3,Y
5D10: 86 0B       LDA    #$0B
5D12: A7 C9 04 00 STA    $0400,U
5D16: CE 21 C4    LDU    #$21C4
5D19: 11 A3 23    CMPU   $3,Y
5D1C: 23 0A       BLS    $5D28
5D1E: EC 23       LDD    $3,Y
5D20: C3 00 40    ADDD   #$0040
5D23: ED 23       STD    $3,Y
5D25: 6F 22       CLR    $2,Y
5D27: 39          RTS
5D28: EC 23       LDD    $3,Y
5D2A: 83 01 00    SUBD   #$0100
5D2D: ED 23       STD    $3,Y
5D2F: 6F 22       CLR    $2,Y
5D31: 39          RTS
5D32: 6C 22       INC    $2,Y
5D34: A6 22       LDA    $2,Y
5D36: 81 0A       CMPA   #$0A
5D38: 25 23       BCS    $5D5D
5D3A: EE 23       LDU    $3,Y
5D3C: 86 0B       LDA    #$0B
5D3E: A7 C9 04 00 STA    $0400,U
5D42: CE 20 DC    LDU    #$20DC
5D45: 11 A3 23    CMPU   $3,Y
5D48: 24 0A       BCC    $5D54
5D4A: EC 23       LDD    $3,Y
5D4C: 83 00 40    SUBD   #$0040
5D4F: ED 23       STD    $3,Y
5D51: 6F 22       CLR    $2,Y
5D53: 39          RTS
5D54: EC 23       LDD    $3,Y
5D56: C3 01 00    ADDD   #$0100
5D59: ED 23       STD    $3,Y
5D5B: 6F 22       CLR    $2,Y
5D5D: 39          RTS
5D5E: EE 23       LDU    $3,Y
5D60: 6C 25       INC    $5,Y
5D62: A6 25       LDA    $5,Y
5D64: 81 05       CMPA   #$05
5D66: 23 0D       BLS    $5D75
5D68: 81 10       CMPA   #$10
5D6A: 27 07       BEQ    $5D73
5D6C: 86 08       LDA    #$08
5D6E: A7 C9 04 00 STA    $0400,U
5D72: 39          RTS
5D73: 6F 25       CLR    $5,Y
5D75: 86 0B       LDA    #$0B
5D77: A7 C9 04 00 STA    $0400,U
5D7B: 39          RTS
5D7C: D6 4B       LDB    $4B
5D7E: C4 10       ANDB   #$10
5D80: 58          ASLB
5D81: 58          ASLB
5D82: 58          ASLB
5D83: 58          ASLB
5D84: A6 29       LDA    $9,Y
5D86: 49          ROLA
5D87: A7 29       STA    $9,Y
5D89: 84 07       ANDA   #$07
5D8B: 81 03       CMPA   #$03
5D8D: 26 4D       BNE    $5DDC
5D8F: EE 23       LDU    $3,Y
5D91: A6 C4       LDA    ,U
5D93: 81 40       CMPA   #$40
5D95: 26 02       BNE    $5D99
5D97: 86 20       LDA    #$20
5D99: 81 1F       CMPA   #$1F
5D9B: 27 1E       BEQ    $5DBB
5D9D: 81 1E       CMPA   #$1E
5D9F: 27 1F       BEQ    $5DC0
5DA1: E6 26       LDB    $6,Y
5DA3: AE 2A       LDX    $A,Y
5DA5: A7 85       STA    B,X
5DA7: EE 27       LDU    $7,Y
5DA9: C6 08       LDB    #$08
5DAB: E7 C9 04 00 STB    $0400,U
5DAF: A7 C0       STA    ,U+
5DB1: EF 27       STU    $7,Y
5DB3: 6C 26       INC    $6,Y
5DB5: A6 26       LDA    $6,Y
5DB7: 81 03       CMPA   #$03
5DB9: 26 21       BNE    $5DDC
5DBB: 86 04       LDA    #$04
5DBD: 97 0B       STA    $0B
5DBF: 39          RTS
5DC0: E6 26       LDB    $6,Y
5DC2: 5D          TSTB
5DC3: 27 17       BEQ    $5DDC
5DC5: 6A 26       DEC    $6,Y
5DC7: 86 20       LDA    #$20
5DC9: E6 26       LDB    $6,Y
5DCB: AE 2A       LDX    $A,Y
5DCD: A7 85       STA    B,X
5DCF: EC 27       LDD    $7,Y
5DD1: 83 00 01    SUBD   #$0001
5DD4: ED 27       STD    $7,Y
5DD6: 1E 30       EXG    U,D
5DD8: 86 20       LDA    #$20
5DDA: A7 C4       STA    ,U
5DDC: 39          RTS
5DDD: EE 2A       LDU    $A,Y
5DDF: 6D 26       TST    $6,Y
5DE1: 27 0E       BEQ    $5DF1
5DE3: E6 26       LDB    $6,Y
5DE5: 33 C5       LEAU   B,U
5DE7: A6 C2       LDA    ,-U
5DE9: 81 20       CMPA   #$20
5DEB: 26 10       BNE    $5DFD
5DED: 6A 26       DEC    $6,Y
5DEF: 26 F6       BNE    $5DE7
5DF1: 8E 5D FE    LDX    #$5DFE
5DF4: E6 80       LDB    ,X+
5DF6: A6 80       LDA    ,X+
5DF8: A7 C0       STA    ,U+
5DFA: 5A          DECB
5DFB: 26 F9       BNE    $5DF6
5DFD: 39          RTS

