SetTeamColors:		;Convert both teams' colors into the palette buffer
	phx
	phy
	ldx.w #$0000
	lda.w tmdata		; home team colors: palbuffer+$40
	sta.b tmp0
	lda.w #TeamList>>16
	sta.b tmp1
	stz.b tmp2+1
	jsl.l SetTeamColors_team
	lda.w tmdata+2		; away team colors: palbuffer+$60
	sta.b tmp0
	lda.w #$0020
	sta.b tmp2+1
	jsl.l SetTeamColors_team
	ply
	plx
	rtl
