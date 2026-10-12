ChkGoalies:		;The computer pulls its goalie on a delayed penalty
	lda.w gmclock		; clock stopped
	bne ChkGoalies_CPG_rtl
	stz.b a2
	lda.w #$0001
	sta.b d0
	inc a
	sta.b a1
	jsl.l ChkGoalies_CPG
	lda.w #$0002
	sta.b d0
	lda.b a1
	ldy.b a2
	sta.b a2
	sty.b a1
ChkGoalies_CPG:		;d0 = team (1/2), a2/a1 = team/other
	lda.b d0
	cmp.w cont1team		; controlled team: no
	beq .rtl
	cmp.w cont2team
	beq .rtl
	ldy.b a2
	lda.w tmgoalie,y		; goalie already out
	bmi .rtl
	lda.w puckc
	bmi .rtl
	sec
	sbc.w #$0006		; puckc - 6, negated for the away team: negative = team a2 has the puck
	ldy.b a2
	beq .side
	eor.w #$FFFF
	inc a
.side:
	sta.b d0
	cmp.w #$0000
	bpl .rtl
	lda.w pucky
	sta.b d1
	lda.w gmode
	bit.w #gmpendel		; gmpendel
	bne .pull
	jmp.w CPgoalie
.pull:		;delayed penalty: pull the goalie, any team
	lda.w tmgoalie,y
	ora.w #$FF00		; tmgoalie high byte $FF: pulled
	sta.w tmgoalie,y
	jmp.w setpersonel
.rtl:
	rtl
