; $818000-$818FFF  ROM $08000-$08FFF: the in-game SPC700 upload stream (GameSoundUpload), $818000-$82B86B. setupice sends it
; with the uploader at $82FA7A ($82FAB9: blocks of length word, APU address word, data; a length of 0 ends and jumps to the address).
; Blocks: the sample directory (to APU $2C00), the BRR samples (data/gamesamples.brr, to APU $2C50), the end block (jump to SPCRESUME, in bank82_B000).
; The samples run on through bank $81 (one incbin slice per segment file) and end in bank82_B000.
org $818000
GameSoundUpload:		;in-game sample set for the SPC700 sound driver (the boot stream at $868000 carries the driver itself)
	dw GameSampleDirEnd-GameSampleDir, SPCSAMPLEDIR		; block 1: 76 bytes to APU $2C00
GameSampleDir:		;DSP sample directory: per sample the APU address of its start and of its loop point
	dw SPCSAMPLES+$0000,SPCSAMPLES+$001B		; sample $00: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$002D,SPCSAMPLES+$3B8E		; sample $01: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$3B8E,SPCSAMPLES+$43F5		; sample $02: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$43F5,SPCSAMPLES+$4DB2		; sample $03: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$4DB2,SPCSAMPLES+$62F7		; sample $04: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$62F7,SPCSAMPLES+$6A3E		; sample $05: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$6A3E,SPCSAMPLES+$72C9		; sample $06: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$72C9,SPCSAMPLES+$7B42		; sample $07: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$7B42,SPCSAMPLES+$9051		; sample $08: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$9051,SPCSAMPLES+$99B4		; sample $09: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$99B4,SPCSAMPLES+$9C8D		; sample $0A: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$9C8D,SPCSAMPLES+$9E58		; sample $0B: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$9E58,SPCSAMPLES+$A03E		; sample $0C: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$A03E,SPCSAMPLES+$A47F		; sample $0D: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$A47F,SPCSAMPLES+$ADBE		; sample $0E: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$ADBE,SPCSAMPLES+$ADD9		; sample $0F: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$AE9F,SPCSAMPLES+$AF1D		; sample $10: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$AF80,SPCSAMPLES+$AFDA		; sample $11: start, loop (offsets in gamesamples.brr)
	dw SPCSAMPLES+$B034,SPCSAMPLES+$B814		; sample $12: start, loop (offsets in gamesamples.brr)
GameSampleDirEnd:
	dw GAMESAMPLESIZE, SPCSAMPLES		; block 2: the BRR samples to APU $2C50
GameSamples:		;BRR samples (9-byte blocks), $818054-$82B867
	incbin "../data/gamesamples.brr":0..$FAC		; $818054-$818FFF
