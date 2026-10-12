addteamstat:		;add d0 to the team word stat at d1 (+2 for team 2, pfteam of X). inline in ChkShotStat
	ldy.b d1		; pfteam: team 2 word
	lda.w pfteam,x
	beq .add
	iny
	iny
.add:
	lda.w $0000,y		; absolute stat address in d1 (+$0000,y)
	clc
	adc.b d0
	sta.w $0000,y
	rtl
