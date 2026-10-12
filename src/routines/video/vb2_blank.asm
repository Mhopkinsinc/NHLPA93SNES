vb2_blank:		;vbint target: vb2 with the screen held in forced blank. Resets hbint to HBdefault
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	rep #$30
	lda.w #HBdefault
	sta.b hbint
	bra vb2_main
