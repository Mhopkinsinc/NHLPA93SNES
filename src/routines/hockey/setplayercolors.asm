setplayercolors:		;Set both teams' colors and send the palette
	stz.w ffoframe+6		; pad 3 frame = 0
	stz.w colorflag1
	stz.w colorflag2
	jsl.l SetTeamColors
	lda.w #DMA_CGRAM		; whole CGRAM from palbuffer
	sta.w DMAP7
	lda.w #palbuffer
	sta.w A1T7L
	lda.w #$0200
	sta.w DAS7L
	sep #$20
	stz.w CGADD
	lda.b #palbuffer>>16
	sta.w A1B7
	lda.b #MDMAEN_CH7
	sta.w MDMAEN
	rep #$30
	rtl
