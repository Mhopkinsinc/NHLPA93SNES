loadTeamStruct:		;a2 = player X's team, a1 = the other team
	stz.b a2
	lda.w #$0002
	sta.b a1
	lda.w pfteam,x
	beq .rtl
	stz.b a1
	lda.w #$0002
	sta.b a2
.rtl:
	rtl
