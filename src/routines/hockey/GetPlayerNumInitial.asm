GetPlayerNumInitial:		;a1 = the number, first initial and last name of player TempPlOffset
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
