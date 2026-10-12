loadTeamStruct:		;return a2 = team struct of player a3, a1 = the other team's struct. Called from ChkShotStat and updateplayers
		;   SNES: a2 = team of player X, a1 = the other team
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
