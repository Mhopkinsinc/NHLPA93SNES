vb2_blank:		;Vblank: as vb2 with the screen held off
	sep #$20
	lda.b #INIDISP_FBLANK
	sta.w INIDISP
	rep #$30
	lda.w #HBdefault
	sta.b hbint
	bra vb2_main
