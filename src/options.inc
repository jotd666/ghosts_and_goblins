	.ifndef	OPTIONS_INC
OPTIONS_INC = 1
	
	.ifdef	RELEASE
OPT_ENABLE_LOGGING = 0           | DO NOT CHANGE THIS
OPT_ALIGNED_MEMORY = 0
	.else
OPT_ENABLE_LOGGING = 1
OPT_ALIGNED_MEMORY = 1
	.endif
	
* makes random routines return 0. Can lock up the game
*OPT_FIX_RANDOM = 1

RAM_START = 0x0000
ROM_START = 0x6000

	.ifdef	RELEASE

	.else
	
LOG_BUFFER_SIZE = 0x8000
	* amiga specific
	.endif
	
	.macro	GET_MEMORY_START_IN_A6
	.ifeq	OPT_ALIGNED_MEMORY
	lea		ram_buffer-RAM_START,a6
	.else
	move.l		ram_start_0000,a6
	* adjust offset to avoid subbing at run-time
	.ifne	RAM_START
	sub.w	#RAM_START,a6
	.endif
	.endif	
	.endm
	
	.macro	GET_MEMORY_START_AND_DP
	move.l	m6809_direct_page_pointer,a5
	move.l	bank_base,a1
	GET_MEMORY_START_IN_A6
	.endm
	
	.endif
