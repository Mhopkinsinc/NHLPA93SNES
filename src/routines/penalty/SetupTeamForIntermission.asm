SetupTeamForIntermission:		;reset the bench, then for each team refill energy and pick the starting line: Pw1 (3) for the team with more players on ice, PK1 (5) for the team with fewer
		;   else 0. Called from Intermission
		;   SNES: ResetBench; both teams re-energized, line 0 (3/5 when a team is a man short or up)
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
