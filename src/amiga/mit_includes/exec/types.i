	.ifndef	EXEC_TYPES_I
EXEC_TYPES_I = 1

* defines the start of a structure (arg is ignored?)
	.macro		STRUCTURE	arg,offset
	.set		_foffset,\offset
	.endm
	
* defines the end of a structure (arg is ignored?)

	.macro		LABEL	arg
	.set		\arg,_foffset
	.endm
	
	.macro		STRUCT	arg,offset
\arg = _foffset
	.set		_foffset,_foffset+\offset
	.endm
	
	.macro		LONG	arg
\arg = _foffset
	.set	_foffset,_foffset+4
	.endm
	
	.macro		APTR	arg
	LONG		\arg
	.endm
	
	.macro		UWORD	arg
\arg = _foffset
	.set	_foffset,_foffset+2
	.endm
	
	.macro		UBYTE	arg
\arg = _foffset
	.set	_foffset,_foffset+1
	.endm
	
	.macro		WORD	arg
	UWORD		\arg
	.endm
	.endif
