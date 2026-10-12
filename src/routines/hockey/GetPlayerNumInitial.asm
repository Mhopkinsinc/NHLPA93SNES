GetPlayerNumInitial:		;a1 = mesarea "NN F. Last" (FormatPlayerNumInitial) for player
		;   SNES: a1 = the name of player TempPlOffset (PlayerShortName; bit 15 = the visitors); saves d0, a2
	lda.b d0+2
	pha
	lda.b d0
	pha
	lda.b a2+2
	pha
	lda.b a2
	pha
	stz.b a2
	lda.w TempPlOffset
	sta.b d0
	bpl .home
	and.w #$00FF
	sta.b d0
	lda.w #$0002
	sta.b a2
.home:
	jsl.l PlayerShortName
	pla
	sta.b a2
	pla
	sta.b a2+2
	pla
	sta.b d0
	pla
	sta.b d0+2
	rtl
