addteamstat:		;Add d0 to a team stat for player X's team
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
