BootSampleDir:		;DSP sample directory: per sample the APU address of its start and of its loop point
	dw SPCBOOTSAMPLES+$0000,SPCBOOTSAMPLES+$0DD1		; sample $00: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$0DD1,SPCBOOTSAMPLES+$1689		; sample $01: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$1689,SPCBOOTSAMPLES+$2757		; sample $02: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$2757,SPCBOOTSAMPLES+$2796		; sample $03: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$27BA,SPCBOOTSAMPLES+$4233		; sample $04: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$4233,SPCBOOTSAMPLES+$4530		; sample $05: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$4530,SPCBOOTSAMPLES+$455D		; sample $06: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$456F,SPCBOOTSAMPLES+$4968		; sample $07: start, loop (offsets in bootsamples.brr)
	dw SPCBOOTSAMPLES+$49A7,SPCBOOTSAMPLES+$5271		; sample $08: start, loop (offsets in bootsamples.brr)
BootSampleDirEnd:
	dw BOOTSAMPLESIZE, SPCBOOTSAMPLES		; block 4: the BRR samples
