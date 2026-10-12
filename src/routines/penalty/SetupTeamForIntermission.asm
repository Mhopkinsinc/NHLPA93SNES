SetupTeamForIntermission:		;Before a period: reset the bench, refill every player's energy and pick each team's starting line
		;   (power play or penalty kill line when a team is a man up or short)
	jsl.l ResetBench
	stz.b a2
	lda.w #$0002
	sta.b a3
	jsl.l .team
	stz.b a3
	lda.w #$0002
	sta.b a2
.team:		;team a2 (a3 = the other)
	jsl.l reenergizeteam
	ldx.b a3
	ldy.b a2
	stz.w tmline,x
	lda.w OptLine
	bne .rtl
	lda.w tmap,x
	sec
	sbc.w tmap,y
	sta.b d0
	beq .rtl
	lda.w #$0003
	sta.w tmline,x
	lda.b d0
	bpl .rtl
	lda.w #$0005
	sta.w tmline,x
.rtl:
	rtl
