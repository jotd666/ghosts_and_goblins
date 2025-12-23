	.ifndef	UTILITY_MACROS_INC
UTILITY_MACROS_INC = 1
	
	.macro	PUSH_INTERRUPT_STATE
	move.w	_custom+intenar,-(a7)
	.endm
	
	.macro	PULL_INTERRUPT_STATE
	move.w	d0,-(a7)
	move.w	(2,a7),d0
	bset	#15,d0
	move.w	d0,_custom+intena
	move.w	(a7)+,d0
	addq	#2,a7
	.endm
	
	.macro	DISABLE_INTERRUPTS
	move.w	#0x4000,_custom+intena
	.endm

	.macro	DISABLE_INTERRUPTS_BUT_NOT_LEVEL_6
	move.w	#0x1FFF,_custom+intena
	.endm


	.macro	WAIT_BLIT
	.ifndef	RELEASE
	cmp.l	#_custom,a5
	jeq		0f
	BREAKPOINT	"custom should be set in A5"
0:
	.endif
	move.w	#0x8400,(dmacon,a5)		| blitter high priority
wait\@:
	BTST	#6,(dmaconr,a5)
	BNE.S	wait\@
	move.w	#0x0400,(dmacon,a5)		| blitter normal priority
.endm

	.macro MUL_TABLE value,len
mul\value\()_table:
	.set    mulv,0
	.rept	\len
	dc.w	mulv
	.set	mulv,mulv+\value
	.endr
.endm


* debug macro that colors the screen until LMB pressed
	.macro 	blitz_bypass
	move.w	d0,-(a7)
	clr.w	d0
loop\@:
	move.w	d0,_custom+color
	btst	#6,0xbfe001
	beq.b	out\@
	addq.w	#1,d0
	bra.b	loop\@
out\@:
	move.w	(a7)+,d0
	nop
.endm

* same thing but if LMB is pressed when entering, macro waits for release)
	.macro blitz
w\@:
	btst	#6,0xbfe001
	beq.b	w\@
	blitz_bypass
.endm

	.endif
