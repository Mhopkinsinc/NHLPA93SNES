Pausemode:		;game is in pause mode now. Save textmap, stop the sound, horizontal screen, PAUSE title and frame, PauseMenu until it returns 0
		;   then PauseExit
	phx
	ldx.w #$07FE
.save:		;textsave = textmap
	lda.l textmap,x
	sta.l textsave,x
	dex
	dex
	bpl .save
	plx
	jsl.l sndqreset		; sound off; keep sfhormode and sflags
	lda.w sfhormode
	pha
	lda.w sflags
	pha
	jsl.l forceblack
	lda.w #999		; Oldrow = 999, SetHor, setvideo
	sta.w Oldrow
	jsl.l SetHor
	jsl.l setvideo
	jsl.l KillCrowd
.top:		;draw the pause screen
	jsl.l printbigz		; big PAUSE title and the menu frame (22 x 7)
	dw $000A		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$0B,$02,"PAUSE"
	jsl.l printz
	dw $0005		; printz inline string: length (counts itself), then control bytes / text
	db $BF,$05,$0C
	lda.w #$0016
	sta.b d0
	lda.w #$0007
	sta.b d1
	jsl.l Framer		; d0 x d1
	jsl.l printscores1
	jsl.l PauseMenu		; nonzero: draw again
	bne .top
	jml.l PauseExit
