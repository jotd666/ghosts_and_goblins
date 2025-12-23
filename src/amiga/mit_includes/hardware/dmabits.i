	.ifndef	HARDWARE_DMABITS_I
HARDWARE_DMABITS_I	=	1
**
**	$VER: dmabits.i 39.1 (18.9.92)
**	Includes Release 40.13
**
**	.include "file" for defining dma control stuff
**
**	(C) Copyright 1985-1993 Commodore-Amiga, Inc.
**	    All Rights Reserved
**

* write definitions for dmaconw
DMAF_SETCLR    =   0x8000
DMAF_AUDIO     =   0x000F  | 4 bit mask
DMAF_AUD0      =   0x0001
DMAF_AUD1      =   0x0002
DMAF_AUD2      =   0x0004
DMAF_AUD3      =   0x0008
DMAF_DISK      =   0x0010
DMAF_SPRITE    =   0x0020
DMAF_BLITTER   =   0x0040
DMAF_COPPER    =   0x0080
DMAF_RASTER    =   0x0100
DMAF_MASTER    =   0x0200
DMAF_BLITHOG   =   0x0400
DMAF_ALL       =   0x01FF  | all dma channels

* read definitions for dmaconr
* bits 0-8 correspnd to dmaconw definitions
DMAF_BLTDONE   =   0x4000
DMAF_BLTNZERO  =   0x2000

DMAB_SETCLR    =   15
DMAB_AUD0      =   0
DMAB_AUD1      =   1
DMAB_AUD2      =   2
DMAB_AUD3      =   3
DMAB_DISK      =   4
DMAB_SPRITE    =   5
DMAB_BLITTER   =   6
DMAB_COPPER    =   7
DMAB_RASTER    =   8
DMAB_MASTER    =   9
DMAB_BLITHOG   =   10
DMAB_BLTDONE   =   14
DMAB_BLTNZERO  =   13

	.endif	| HARDWARE_DMABITS_I
