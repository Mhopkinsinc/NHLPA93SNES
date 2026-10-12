ReturnGoalies:		;If the computer pulled its goalie, should he come back?
	stz.b a2
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l ReturnGoalies_r
	lda.w #$0002
	sta.b d0
	lda.b a1
	ldy.b a2
	sta.b a2
	sty.b a1
ReturnGoalies_r:		;d0 = team (1/2), a2/a1 = team/other
	lda.b d0
	cmp.w cont1team		; controlled team: no
	beq .rtl
	cmp.w cont2team
	beq .rtl
	ldy.b a2
	lda.w tmgoalie,y
	bpl .rtl		; goalie in
	and.w #$00FF
	cmp.w #$000A		; low byte = goalie to return
	bcs .rtl
	sta.w tmgoalie,y
	lda.w foy		; d1 = foy
	sta.b d1
	jmp.w CPgoalie
.rtl:
	rtl
