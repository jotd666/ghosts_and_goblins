	.ifndef	EXEC_TYPES_I
EXEC_TYPES_I = 1
* exact copy of types.i with a different offset variable
* else gnu as detects a duplicate symbol...
* defines the start of a structure (arg is ignored?)
	.macro		STRUCTURE	arg,offset
	.set		_soffset,\offset
	.endm
	
* defines the end of a structure (arg is ignored?)

	.macro		LABEL	arg
	.set		\arg,_soffset
	.endm
	
	.macro		STRUCT	arg,offset
\arg = _soffset
	.set		_soffset,_soffset+\offset
	.endm
	
	.macro		LONG	arg
\arg = _soffset
	.set	_soffset,_soffset+4
	.endm
	
	.macro		APTR	arg
	LONG		\arg
	.endm
	
	.macro		UWORD	arg
\arg = _soffset
	.set	_soffset,_soffset+2
	.endm
	
	.macro		UBYTE	arg
\arg = _soffset
	.set	_soffset,_soffset+1
	.endm
	
	.macro		WORD	arg
	UWORD		\arg
	.endm
	.endif
