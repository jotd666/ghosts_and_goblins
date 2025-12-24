* Converted with 6809to68k v1.3 by JOTD
*
* make sure you call "cpu_init" first so all bits of data registers
* are zeroed out so we can use add.l dy,ax with dy > 0x7FFF
* without systematic masking
*
* WARNING: you also have to call "cpu_init"
* at start of any interrupt you could hook
*
* the GET_ADDRESS macro can just call get_address or it can also use
* conditional compilation to select the proper memory banks at compile time
* (see my burger time 6502 conversion which does that in RELEASE mode)

	.include 	"options.inc"

	
	.macro	ERROR	arg
	.warning	"\arg"     | comment out to disable errors
	.endm

	.macro	VIDEO_BYTE_DIRTY
	| called when a byte write was done in a0
	.endm

	.macro	VIDEO_WORD_DIRTY
	| called when a word write was done in a0
	.endm

	* the function that accesses all memory (except banks)
	.macro	GET_UNCHECKED_ADDRESS_FUNC
	lea		(a6,a0.l),a0
	.endm

	.ifdef	RELEASE
	* release mode: don't check
	.macro	GET_ADDRESS_FUNC
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.else
	* debug mode, using a function
	.macro	GET_ADDRESS_FUNC
	jbsr	get_address
	.endm

	.endif

	.macro	ABX
	moveq	#0,d6
	move.b	d1,d6
	add.w	d6,d2
	.endm

	.macro	ABA
	add.b	d1,d0
	.endm

	.macro	TBA
	move.b	d1,d0
	.endm

	.macro	CHECK_MAX	reg,arg
	ERROR  "insert check max table function index here"
	.endm

	.macro	COM	reg
	not.b	\reg
	SET_XC_FLAGS
	.endm

	.macro	SEX
	move.b	d1,d0
	ext.w	d0
	.endm

	.macro	MAKE_D
* add value of A in B MSB so D&0xFF == B
	rol.w	#8,d1
	move.b	d0,d1
	rol.w	#8,d1
	.endm

	.macro	MAKE_A
	rol.w	#8,d1
	move.b	d1,d0
	rol.w	#8,d1
	.endm

	.macro	BIT	reg,arg
	move.b	\reg,d6
	and.b	\arg,d6
	.endm


	.macro	LOAD_D
	move.b	(a0),d0
	move.b	(1,a0),d1
	MAKE_D
	.endm

	.macro CLR_XC_FLAGS
	and.b	#0xEE,ccr	| bit 4 = X, bit 0 = C
	.endm

	.macro SET_XC_FLAGS
	or.b	#0x11,ccr	| bit 4 = X, bit 0 = C
	.endm



	.macro INVERT_XC_FLAGS
	eor.b	#0x11,ccr
	.endm

* useful to recall C from X (add then move then bcx)
	.macro	SET_C_FROM_X
	PUSH_SR
	move.w	(sp),d6
	bset	#0,d6   | set C
	btst	#4,d6
	jne	0f
	bclr	#0,d6   | X is clear: clear C
0:
	move.w	d6,(sp)
	POP_SR
	.endm

* useful to store X from C (store cmp result)
	.macro	SET_X_FROM_C
	PUSH_SR
	move.w	(sp),d6
	bset	#4,d6   | set X
	btst	#0,d6
	bne.b	0f
	bclr	#4,d6   | C is clear: clear X
0:
	move.w	d6,(sp)
	POP_SR
	.endm

	.macro	SET_X_FROM_CLEARED_C
	PUSH_SR
	move.w	(sp),d6
	bset	#4,d6   | set X
	btst	#0,d6
	jeq	0f
	bclr	#4,d6   | C is set: clear X
0:
	move.w	d6,(sp)
	POP_SR
	.endm


	.macro SET_I_FLAG
	jbsr	osd_disable_interrupts
	.endm
	.macro CLR_I_FLAG
	jbsr	osd_enable_interrupts
	.endm

	.ifdef	MC68020


* 68020 compliant & optimized

	.macro    JXX_A_INDEXED    inst,reg
	and.w    #0xFF,d0  | mask 8 bits
	*CHECK_MAX    d0,\nb_cases
	\inst    ([\reg,d0.W*2])
	.endm

	.macro    JXX_B_INDEXED    inst,reg
	and.w    #0xFF,d1  | mask 8 bits
	*CHECK_MAX    d1,\nb_cases
	\inst    ([\reg,d1.W*2])
	.endm

	.macro DO_EXTB	reg
	extb.l	\reg
	.endm

	.macro PUSH_SR
	move.w	ccr,-(sp)
	.endm


	.macro	MOVE_W_TO_REG	src,dest
	move.w	(\src),\dest
	.endm

	.macro    CMP_W_TO_REG    src,dest
	cmp.w    (\src),\dest
	.endm

	.macro    ADD_W_TO_REG    src,dest
	add.w    (\src),\dest
	.endm

	.macro    SUB_W_TO_REG    src,dest
	sub.w    (\src),\dest
	.endm


	.macro	MOVE_W_FROM_REG    src,dest
	move.w	\src,(\dest)
	.endm



	.macro READ_BE_WORD	srcreg
	moveq	#0,d6
	move.w	(\srcreg),d6
	move.l	d6,\srcreg
	.endm

	.else

* 68000 compliant

    .macro    JXX_A_INDEXED    inst,reg
    and.w    #0xFF,d0  | mask 8 bits
    *CHECK_MAX   d0,\nb_cases
    add.w    d0,d0    | *2 (16 -> 32 bits)
    move.l    (\reg,d0.w),\reg
    \inst    (\reg)
    .endm

    .macro    JXX_B_INDEXED    inst,reg
    and.w    #0xFF,d1  | mask 8 bits
    *CHECK_MAX   d1,\nb_cases
    add.w    d1,d1    | *2 (16 -> 32 bits)
    move.l    (\reg,d1.w),\reg
    \inst    (\reg)
    .endm

	.macro DO_EXTB	reg
	ext	\reg
	ext.l	\reg
	.endm

	.macro PUSH_SR
	move.w	sr,-(sp)
	.endm

	.macro	MOVE_W_TO_REG    src,dest
	ror.w	#8,\dest
	move.b	(\src),\dest
	ror.w	#8,\dest
	move.b	(1,\src),\dest
	.endm

	.macro	MOVE_W_FROM_REG    src,dest
	ror.w	#8,\src
	move.b	\src,(\dest)
	ror.w	#8,\src
	move.b	\src,(1,\dest)
	.endm

    .macro    INST_W_TO_REG    inst,src,dest
    move.b    (\src),d6
    ror.w    #8,d6
    move.b    (1,\src),d6
    \inst\().w    d6,\dest
    .endm

    .macro    SUB_W_TO_REG    src,dest
    INST_W_TO_REG   sub,\src,\dest
    .endm

    .macro    ADD_W_TO_REG    src,dest
    INST_W_TO_REG   add,\src,\dest
    .endm

    .macro    CMP_W_TO_REG    src,dest
    INST_W_TO_REG   cmp,\src,\dest
    .endm


	.macro READ_BE_WORD	srcreg
	moveq	#0,d6
	move.b	(\srcreg),d6
	lsl.w	#8,d6
	move.b	(1,\srcreg),d6
	move.l	d6,\srcreg
	.endm

	.endif

* same for 68000 and 68020+
	.macro POP_SR
	move.w	(sp)+,ccr
	.endm

    .macro    JSR_A_INDEXED    reg
    JXX_A_INDEXED	jsr,\reg
    .endm
    .macro    JMP_A_INDEXED    reg
    JXX_A_INDEXED	jmp,\reg
    .endm
    .macro    JSR_B_INDEXED    reg
    JXX_B_INDEXED	jsr,\reg
    .endm
    .macro    JMP_B_INDEXED    reg
    JXX_B_INDEXED	jmp,\reg
    .endm


* registers must be masked out to proper size before use
	.macro	GET_INDIRECT_ADDRESS_REGS	reg1,reg2,destreg
	move.l	\reg1,a0
	add.l	\reg2,a0
	GET_ADDRESS_FUNC
	MOVE_W_TO_REG	a0,\destreg
	.endm


	.macro GET_DP_ADDRESS	offset
	lea	(a5,\offset\().W),a0
	.endm

* optimized DP operations
.macro OP_1_ON_DP_ADDRESS    inst,offset
	\inst\().b    (a5,\offset\().W)
.endm

.macro OP_R_ON_DP_ADDRESS    inst,offset,reg
	\inst\().b    (a5,\offset\().W),\reg
.endm

.macro OP_W_ON_DP_ADDRESS    inst,offset,reg
	\inst\().b    \reg,(a5,\offset\().W)
.endm

	.macro	STORE_DP_IN_MEMORY
	move.l	a5,m6809_direct_page_pointer
	.endm

	.macro SET_DP_FROM_A
	swap	d0    | would be catastrophic if D0 msw != 0
	clr.w	d0   | can happen with the use of subq
	swap	d0    | even if now I have set .w on all addq/subq
	lsl.w    #8,d0
	move.l    d0,a0  | remove MSB clear & change to move.w if always < 0x8000
	GET_ADDRESS_FUNC
	move.l	a0,a5
	STORE_DP_IN_MEMORY
	lsr.w    #8,d0
	.endm



	.macro SET_DP_FROM    reg
	exg	d0,\reg
	SET_DP_FROM_A

	exg	d0,\reg
	.endm

	.macro GET_REG_ADDRESS	offset,reg
	.ifeq	\offset
	move.l	\reg,a0
	.else
	lea	\offset,a0
	add.l	\reg,a0
	.endif
	GET_ADDRESS_FUNC
	.endm


	.macro GET_REG_INDIRECT_ADDRESS	offset,reg
	GET_REG_ADDRESS	\offset,\reg
	READ_BE_WORD	a0
	GET_ADDRESS_FUNC
	.endm

	.macro    GET_REG_REG_INDIRECT_ADDRESS reg1,reg2
	GET_INDIRECT_ADDRESS_REGS	\reg1,\reg2,d6
	and.l	#0xFFFF,d6
	move.l	d6,a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_REG_ADDRESS_FROM_REG	reg,reg2
	move.l	\reg,a0
	add.l	\reg2,a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_ADDRESS	offset
	lea	\offset,a0
	GET_ADDRESS_FUNC
	.endm

	.macro GET_INDIRECT_ADDRESS	offset
	GET_ADDRESS	\offset
	READ_BE_WORD	a0
	GET_ADDRESS_FUNC
	.endm
	.macro GET_REG_UNCHECKED_ADDRESS	offset,reg
	.ifeq	\offset
	move.l	\reg,a0
	.else
	lea	\offset,a0
	add.l	\reg,a0
	.endif
	GET_UNCHECKED_ADDRESS_FUNC
	.endm


	.macro GET_REG_INDIRECT_UNCHECKED_ADDRESS	offset,reg
	GET_REG_ADDRESS	\offset,\reg
	READ_BE_WORD	a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro    GET_REG_REG_UNCHECKED_INDIRECT_ADDRESS reg1,reg2
	GET_INDIRECT_ADDRESS_REGS	\reg1,\reg2,d6
	and.l	#0xFFFF,d6
	move.l	d6,a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro GET_REG_UNCHECKED_ADDRESS_FROM_REG	reg,reg2
	move.l	\reg,a0
	add.l	\reg2,a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro GET_UNCHECKED_ADDRESS	offset
	lea	\offset,a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

	.macro GET_INDIRECT_UNCHECKED_ADDRESS	offset
	GET_ADDRESS	\offset
	READ_BE_WORD	a0
	GET_UNCHECKED_ADDRESS_FUNC
	.endm

get_address:
	cmp.w	#0x3000,a0
	jcs		0f		| below 0x3000: RAM: OK
	cmp.w	#0x6000,a0
	jcc		0f		| above 0x6000: ROM: OK
	* make it simple: ignore most read/writes
	* palette: ignored
	* sound: ignored
	* scroll: read in memory at each vblank
	
	cmp.w	#0x4000,a0
	jcs		1f
	BREAKPOINT	"accessing bank 0x4000-0x6000"
	jra		0f
1:
	* zone 0x3000-0x3fff
	cmp.w	#0x3e00,a0
	jne		1f
	BREAKPOINT	"accessing bankswitch 0x3E00 address"
	jra		0f
1:
	cmp.w	#0x3800,a0
	jcc		0f			| >= 0x3800, let it live
	BREAKPOINT	"accessing range 0x3000-0x37ff"
0:
	GET_UNCHECKED_ADDRESS_FUNC
	rts




multiply_ab:
	and.w	#0xFF,d0
	and.w	#0xFF,d1
	mulu	d0,d1
	ror.w	#8,d1
	move.b	d1,d0
	ror.w	#8,d1
	rts


	.ifndef	RELEASE
	* to trace at some virtual PCs, insert this macro
	.macro	LOG_REGS	the_pc
	move.w	sr,-(a7)
	move.w	#0x\the_pc,-(a7)
	move.w	#0,-(a7)
	jbsr	osd_log_cpu
	addq.w	#4,a7
	move.w	(a7)+,sr
	.endm
	.macro	LOG_REGS_QUICK	the_pc
	move.w	sr,-(a7)

	move.w	#0x\the_pc,0x100

	move.w	(a7)+,sr
	.endm
	.endif
